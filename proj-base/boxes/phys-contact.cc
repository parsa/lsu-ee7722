/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Find pairs of objects that are in contact.

#include "boxes.h"
#include "world.h"
#include "phys-obj-ball.h"
#include "phys-obj-box.h"
#include "phys-obj-tile.h"

int
World::contact_pairs_proximity_check
(int idx9, double lifetime_delta_t, bool verify)
{
  /// Find pairs of balls that are, or might soon be, touching.
  //
  Phys* const phys9 = phys_zsort[idx9];
  Ball* const ball9 = BALL(phys9);
  Tile* const tile9 = TILE(phys9);
  const float z_min = phys9->min_z_get(lifetime_delta_t);

  int prox_count9 = 0;          // Used for verification.

  // Mark physs in proximity to phys9 using proximity data that is
  // already present.
  //
  if ( verify )
    {
      for ( int c_idx = phys9->proximity.iterate_reset();
            phys9->proximity.iterate(c_idx); )
        {
          Contact* const c = &contact_pairs[c_idx];
          Phys* const pother = c->other_phys(phys9);
          pother->prox_check = idx9;
        }
    }

  // Look at physs that can overlap phys9 in the z axis, and check if
  // they might truly overlap (are in proximity when all three axes
  // considered).
  //
  for ( int i=idx9-1; i>=0 && phys_zsort.get_key(i) >= z_min; i-- )
    {
      Phys* const phys1 = phys_zsort[i];
      Ball* const ball1 = BALL(phys1);
      Tile* const tile1 = TILE(phys1);
      Phys *physa, *physb;

      // The kind of computation needed to resolve contact. This
      // is used for scheduling so that all threads in a warp perform
      // the same kind of computation.
      Code_Path code_path = CP_Unset;

      if ( tile1 && tile9 ) continue;
      if ( !verify ) prox_test_per_ball++;

      if ( !tile1 && !tile9 )
        {
          // Quick test using bounding sphere.

          pNorm dist(phys1->position,phys9->position);
          const float region_length_small =
            1.1 * ( phys1->radius + phys9->radius );

          if ( dist.mag_sq > region_length_small * region_length_small )
            {
              // Need to take square roots. (delta_v.mag and dist.magnitude).
              pVect delta_v = phys9->velocity - phys1->velocity;
              const double delta_d = lifetime_delta_t * delta_v.mag();
              const double dist2 = dist.magnitude - delta_d;
              if ( dist2 > region_length_small ) continue;
            }

          // At this point in code bounding spheres will intersect
          // if current velocity does not change.  Mark this
          // as a potential contact pair. This code can be
          // improved by accounting for the shape of the box.

          physa = phys1;
          physb = phys9;
          code_path =
            ball1 && ball9 ? CP_Ball_Ball :
            ( ball1 || ball9 ) ? CP_Box_Ball : CP_Box_Box;
        }
      else
        {
          Ball* const ball = ball1 ? ball1 : ball9;
          Tile* const tile = tile1 ? tile1 : tile9;
          const float delta_s = ball->velocity.mag() * lifetime_delta_t;
          if ( !tile_sphere_intersect
               (tile, ball->position, ball->radius + delta_s) ) continue;
          physa = tile;
          physb = ball;
          code_path = CP_Ball_Tile;
        }

      if ( verify )
        {
          const float z_margin = fabs( z_min - phys_zsort.get_key(0) );
          if ( !( z_margin < 0.001 || phys1->prox_check == idx9 ) )
            {
              printf("z_margin %.6f  idx9 %d  prox_check %d\n",
                     z_margin, idx9, phys1->prox_check);
              if ( ball1 && ball9 )
                {
                  pNorm dist(ball1->position,ball9->position);
                  printf("r1 %.4f r9 %.4f dist %.4f\n",
                         ball1->radius, ball9->radius,
                         dist.magnitude);
                }

            }
          ASSERTS( z_margin < 0.001 || phys1->prox_check == idx9 );
          prox_count9++;
          continue;
        }

      // Determine the index of the next Contact object.
      const int c_idx = contact_pairs.occ();

      // Allocate a new Contact object in contact_pairs list and call
      // Contact constructor on it.
      new (contact_pairs.pushi()) Contact(physa,physb,code_path);

      // Append the index of the new Contact object to the proximity
      // lists of both physs.  Note that '+=' does a list append, it
      // does not perform arithmetic addition.
      phys1->proximity += c_idx;
      phys9->proximity += c_idx;
    }

  return prox_count9;
}

void
World::cuda_contact_pairs_find()
{
  /// Find pairs of phys that are in proximity: in contact now or may be so soon.

  // The pair list should include phys that may touch within
  // schedule_lifetime_steps (a constant); from that compute
  // a time.
  //
  const double lifetime_delta_t = schedule_lifetime_steps * delta_t;
  const bool debug = false;

  frame_timer.user_timer_start(timer_id_cuda_prox);

  /// Sort phys in z in preparation for finding phys in proximity.
  //
  phys_zsort.reset(); // Avoid reallocation by resetting rather than declaring.
  for ( Phys_Iterator ball(physs); ball; ball++ )
    {
      // Get maximum z value that phys could occupy.
      const float max_z = ball->max_z_get(lifetime_delta_t);

      // Add a pointer to the ball to a sorted list class using
      // max_z as a sort key.
      phys_zsort.insert(max_z,ball);

      // Set a ball index. This isn't the best place to do this.
      // The ball index refers to the position in the physs array
      // on the CPU and the balls_x arrays on the GPU.
      ball->idx = ball.get_idx();
    }
  phys_zsort.sort();

  // Store number of balls for a sanity check (ball_cnt_sched).
  ball_cnt_sched = physs.occ();
  const int ball_cnt = ball_cnt_sched;

  // Update storage on GPU if number of balls has changed.
  //
  if ( ball_cnt != z_sort_indices.elements )
    {
      z_sort_indices.realloc(ball_cnt);
      z_sort_indices.ptrs_to_cuda("z_sort_indices");
      z_sort_z_max.realloc(ball_cnt);
      z_sort_z_max.ptrs_to_cuda("z_sort_z_max");
      cuda_prox.realloc( ball_cnt * cuda_prox_per_ball );
      cuda_prox.ptrs_to_cuda("cuda_prox");
    }

  // Block size chosen to maximize multiprocessor utilization
  // or is set to 32, whichever is larger.
  // HW 4 note: The block size chosen here may not be the best.
  //
  dim3 dim_grid, dim_block;
  const int plat_block_size_1pmp =
    max(32,int(ceil(double(ball_cnt) / cuda_prop.multiProcessorCount)));
  const int plat_block_size =
    min(plat_block_size_1pmp, cfa_platform.maxThreadsPerBlock);

  dim_grid.x = int(ceil(double(ball_cnt)/plat_block_size));
  dim_grid.y = dim_grid.z = 1;
  dim_block.x = plat_block_size;
  dim_block.y = dim_block.z = 1;

  if ( debug )
    {
      // Allocate storage on cuda that might be handy for debugging.
      pass_sched_debug.realloc(ball_cnt);
      pass_sched_debug.ptrs_to_cuda("pass_sched_debug");
    }

  // Initialize array of indices to send to CUDA.
  //
  for ( int i=0; i<ball_cnt; i++ )
    {
      Phys* const phys9 = phys_zsort[i];
      z_sort_indices[i] = phys9->phys_type == PT_Ball ? phys9->idx : -1;
      z_sort_z_max[i] = phys_zsort.get_key(i);

      // Reset proximity list. Won't be populated until contact_pairs_find
      // is called.
      phys9->proximity.reset();

      // Initialize debug array. Change initialization to whatever you want.
      if ( debug ) pass_sched_debug[i].x = 7700.1;
    }

  // Send indices and z_max values to CUDA, and maybe debug data.
  z_sort_indices.to_cuda();
  z_sort_z_max.to_cuda();
  if ( debug ) pass_sched_debug.to_cuda();

  // Determine memory address on GPU of position and velocity arrays.
  //
  char* const position_array_dev =
    cuda_balls.cuda_mem_all.get_dev_addr() +
    ( ((char*)&cuda_balls.soa.position[0]) - cuda_balls.cuda_mem_all.data );
  char* const velocity_array_dev =
    cuda_balls.cuda_mem_all.get_dev_addr() +
    ( ((char*)&cuda_balls.soa.velocity[0]) - cuda_balls.cuda_mem_all.data );

  // Launch the sched kernel.  Despite its name, all it does is
  // determine which balls are in proximity.  Just balls, it skips
  // tiles.
  //
  const bool rv = pass_sched_launch
    (dim_grid,dim_block, ball_cnt, lifetime_delta_t,
     position_array_dev, velocity_array_dev);
  ASSERTS( rv );

  // Move data back from CUDA.  This cannot be done in contact_pairs_find
  // because that code runs in another thread. (All CUDA calls must
  // be in the same thread.)  The data returned from CUDA will be
  // unpacked in routine contact_pairs_find.
  //
  cuda_prox.from_cuda();

  // Return debug data to CUDA. This is only of value if code
  // has been added to balls-kernel.cu to write this storage.
  //
  if ( debug ) pass_sched_debug.from_cuda();

  frame_timer.user_timer_end(timer_id_cuda_prox);
}

void
World::contact_pairs_find()
{
  /// Find pairs of phys that are in proximity: in contact now or maybe soon.

  //  If opt_cuda_prox is false, then this routine will find all
  //  proximity pairs. Otherwise, it will read the pairs discovered
  //  by the CUDA code and compute proximity for balls that the CUDA
  //  could not handle. (See pass_sched in balls-kernel.cu.)

  //  Compute the amount of time over which proximity should be
  //  valid.

  const double lifetime_delta_t = schedule_lifetime_steps * delta_t;
  const int ball_cnt = physs.occ();

  // Used for performance tuning. Incremented for each pair the
  // CPU code examines.
  prox_test_per_ball = 0;

  // Make sure ball count hasn't changed. If it did then the
  // proximity data will be invalid.
  ASSERTS( !opt_cuda_prox || ball_cnt == ball_cnt_sched );

  const bool cpu_computes_prox = !opt_cuda_prox;

  frame_timer.user_timer_start(timer_id_spart);

  /// Sort phys in z in preparation for finding phys in proximity.
  //
  if ( cpu_computes_prox )
    {
      phys_zsort.reset();
      for ( Phys_Iterator ball(physs); ball; ball++ )
        {
          const float max_z = ball->max_z_get(lifetime_delta_t);
          phys_zsort.insert(max_z,ball);
          ball->proximity.reset();
        }
      phys_zsort.sort();
    }

  contact_pairs.reset();

  /// Unpack proximity values computed on CUDA.
  //
  if ( !cpu_computes_prox )
    {
      cuda_prox_full = 0;
      int prox_count_cuda_total = 0;
      int prox_count_check_total = 0;
      for ( int i=0; i<ball_cnt; i++ )
        {
          // The code in pass_sched writes cuda_prox as an array
          // of type Prox_Offsets (a 64 bit integer, unless it's changed).
          // This code reads the memory as an array of characters.

          // Compute the cuda_prox index for ball i in z-sort order.
          const int pi = i * cuda_prox_per_ball;

          // If CUDA could not do this phys, compute proximity here.
          //
          if ( cuda_prox[pi] == 255 )
            {
              // CUDA code could not compute proximity for this phys.
              //
              contact_pairs_proximity_check(i,lifetime_delta_t,false);
              if ( cuda_prox[pi+1] == 't' ) cuda_prox_full++;
              continue;
            }

          // Create Contact structures and place in physs proximity members.
          //
          Phys* const phys9 = phys_zsort[i];
          int prox_count_cuda = 0;
          for ( int j=pi; j<pi+cuda_prox_per_ball; j++ )
            {
              // Get the difference in z-sort index for a ball in
              // the proximity list.
              //
              const uint8_t offset = cuda_prox[j];

              // Check for the end of list marker.
              if ( offset == 0 ) break;

              // Compute the z-sort index for the ball.
              //
              const int zidx = i - offset;
              ASSERTS( zidx >= 0 );

              // Get a pointer to the ball itself.
              //
              Phys* const phys1 = phys_zsort[zidx];

              // Determine the index of the next free Contact object.
              const int c_idx = contact_pairs.occ();

              // Allocate a new Contact object in contact_pairs list and call
              // Contact constructor on it.
              new (contact_pairs.pushi()) Contact(phys9,phys1,CP_Ball_Ball);

              // Append the index of the new Contact object to the
              // proximity lists of both physs. Note that '+=' does a
              // list append, it does not perform arithmetic addition.
              phys1->proximity += c_idx;
              phys9->proximity += c_idx;
              prox_count_cuda++;
            }

          if ( !opt_verify ) continue;

          // Verify CUDA proximity pairs. The verification is time
          // consuming, so it should only be done for testing.
          //
          const int prox_count_check =
            contact_pairs_proximity_check(i,lifetime_delta_t,true);
          prox_count_check_total += prox_count_check;
          prox_count_cuda_total += prox_count_cuda;
        }

      // Tiny differences in floating-point calculation can result
      // in differences in proximity count. Therefore forgive small
      // differences.
      //
      const int error_tolerance = ( prox_count_check_total >> 4 ) + 10;
      const bool okay =
        abs( prox_count_check_total - prox_count_cuda_total )
        < error_tolerance;
      if ( opt_verify && !okay )
        printf("Excessive proximity check errors: check %d cuda %d tol %d\n",
               prox_count_check_total, prox_count_cuda_total,
               error_tolerance );
      ASSERTS( !opt_verify || okay );
      cuda_prox_full_prev = cuda_prox_full;
    }

  /// Compute proximity on CPU.
  //
  if ( cpu_computes_prox )
    for ( int idx9 = 0; idx9 < phys_zsort.occ(); idx9++ )
      contact_pairs_proximity_check(idx9,lifetime_delta_t,false);

  prox_test_per_ball_prev = prox_test_per_ball;

  frame_timer.user_timer_end(timer_id_spart);
}

