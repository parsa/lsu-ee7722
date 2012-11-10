/// LSU EE X70X GPU Prog / Microarch
//
 /// Main code for NVIDIA CUDA GPU Execution
 //  Also code for CPU/GPU data movement.

#include "boxes.h"
#include "world.h"
#include "phys.h"
#include "phys-obj-tile.h"
#include "phys-obj-ball.h"
#include "phys-obj-box.h"

void
World::cuda_init()
{
  if ( cuda_initialized ) return;
  cuda_initialized = true;
  cuda_constants_stale = true;

  cuda_ball_cnt = 5;  // Set initial size of CUDA ball_x array.
  schedule_lifetime_steps = 18; // Number of steps schedule good for.
  passes_curr = &passes_0;
  passes_next = &passes_1;

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  ASSERTS( device_count );
  for ( int dev = 0; dev < device_count; dev ++ )
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      CE(cudaGLSetGLDevice(dev));
      printf
        ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
         dev, cuda_prop.name, cuda_prop.clockRate/1e6,
         int(cuda_prop.totalGlobalMem >> 20));

      printf
        ("GPU %d: CAP: %d.%d  MP: %2d  TH/WP: %3d  TH/BL: %4d\n",
         dev, cuda_prop.major, cuda_prop.minor,
         cuda_prop.multiProcessorCount,
         cuda_prop.warpSize,
         cuda_prop.maxThreadsPerBlock
         );

      printf
        ("GPU %d: SHARED: %5d  CONST: %5d  # REGS: %5d\n",
         dev,
         int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
         cuda_prop.regsPerBlock
         );

    }

  const int dev = 0;

  printf("Using GPU %d\n",dev);
  CE(cudaSetDevice(dev));

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&frame_start_ce));
  CE(cudaEventCreate(&frame_stop_ce));
  CE(cudaEventCreate(&xx_pairs_start_ce));
  CE(cudaEventCreate(&pairs_start_ce));
  CE(cudaEventCreate(&pairs_stop_ce));
  CE(cudaEventCreate(&platform_stop_ce));
  pairs_cumulative_count = 0;
  platform_cumulative = pairs_cumulative = pairs_cumulative = 0;
  xx_pairs_cumulative = 0;

  timer_id_cuda_prox = frame_timer.user_timer_per_start_define("CUDA Prox");
  timer_id_sched = frame_timer.user_timer_per_start_define("Sched");
  timer_id_spart = frame_timer.user_timer_per_start_define("CPU Prox");

  // Set up cuda_balls class.
  //
  // Identify structure members so they can be transposed into arrays.
  //
  CMX_SETUP(cuda_balls,orientation);
  CMX_SETUP(cuda_balls,position);
  CMX_SETUP(cuda_balls,velocity);
  CMX_SETUP(cuda_balls,prev_velocity);
  CMX_SETUP(cuda_balls,omega);
  CMX_SETUP(cuda_balls,tact_counts);
  CMX_SETUP(cuda_balls,ball_props);
  CMX_SETUP(cuda_balls,to_111);

  // Determine resources used by each CUDA kernel.
  // Also collect addresses of global and constant symbols.
  // See demo-x-kernel for code.
  //
  CE(cuda_get_attr_plat_pairs(&cfa_platform,&cfa_pairs,&cfa_xx_intersect));

  // Allocate initial storage for cuda_balls.
  //
  cuda_balls.alloc_locked(cuda_ball_cnt);

  // Send pointer to this storage to cuda.
  //
  cuda_balls.ptrs_to_cuda("balls_x");

  block_size_max =
    min(cfa_platform.maxThreadsPerBlock, cfa_pairs.maxThreadsPerBlock);
  set_min(block_size_max,cuda_prop.maxThreadsPerBlock);

  printf("CUDA Routine Resource Usage:\n");
  printf(" pass_platform: %6zd shared, %zd const, %zd loc, %d regs; "
         "%d max thr\n",
         cfa_platform.sharedSizeBytes,
         cfa_platform.constSizeBytes,
         cfa_platform.localSizeBytes,
         cfa_platform.numRegs,
         cfa_platform.maxThreadsPerBlock);
  printf(" pass_xx_intersect: %6zd shared, %zd const, "
         "%zd loc, %d regs; %d max thr\n",
         cfa_xx_intersect.sharedSizeBytes,
         cfa_xx_intersect.constSizeBytes,
         cfa_xx_intersect.localSizeBytes,
         cfa_xx_intersect.numRegs,
         cfa_xx_intersect.maxThreadsPerBlock);
  printf(" pass_pairs: %6zd shared, %zd const, %zd loc, %d regs; %d max thr\n",
         cfa_pairs.sharedSizeBytes,
         cfa_pairs.constSizeBytes,
         cfa_pairs.localSizeBytes,
         cfa_pairs.numRegs,
         cfa_pairs.maxThreadsPerBlock);
  balls_per_block_max =
    int(cuda_prop.sharedMemPerBlock / sizeof(CUDA_Phys_W));
  printf(" Shared Memory: %d balls, based on ball size of %zd chars.\n",
         balls_per_block_max, sizeof(CUDA_Phys_W));
}


void
World::cuda_at_balls_change()
{
  /// Reset scheduler and other CUDA data.
  //
  // Called when a ball is added or removed, or there is some other
  // disrupting change.

  if ( opt_physics_method == GP_cpu ) return;

  // Wait for scheduler thread to finish whatever it's currently doing.
  //
  pt_sched_waitfor();

  // Forget about the schedule it may have just finished.
  //
  pt_sched_data_pending = false;
  cuda_schedule_stale = 1;

  // Bring data back to CPU.
  //
  cuda_data_to_cpu(DL_ALL);
  data_location = DL_ALL_CPU;
}


void
World::cuda_constants_update()
{
  /// If necessary, copy constants to CUDA.
  //
  // Performed during program initialization and after user changes to
  // options such as ball mass.

  if ( !cuda_constants_stale ) return;
  cuda_constants_stale = false;

  set_max(opt_block_size, 1);
  set_min(opt_block_size, block_size_max);

  // The macros below copy values to CUDA device variables with
  // the same name.
  //
  TO_DEV(gravity_accel_dt);
  TO_DEV(opt_bounce_loss);
  TO_DEV(opt_bounce_loss_box);
  TO_DEV(platform_xmin); TO_DEV(platform_xmax);
  TO_DEV(platform_zmin); TO_DEV(platform_zmax);
  TO_DEV(platform_xmid); TO_DEV(platform_xrad);
  TO_DEVF(delta_t);
  TO_DEVF(elasticity_inv_dt);
  TO_DEVF(opt_friction_coeff); TO_DEVF(opt_friction_roll);
  TO_DEVF(opt_air_resistance);
  TO_DEV(opt_debug);
  TO_DEV(opt_debug2);
}


bool
World::cpu_data_to_cuda()
{
  /// Copy data to CUDA.

  ASSERTS( ( DL_ALL & ( data_location | ( data_location >> 4 ) ) ) == DL_ALL );

  const int cnt = physs.occ();

  // Allocate additional cuda storage, if necessary.
  //
  if ( cnt > cuda_ball_cnt )
    {
      cuda_balls.realloc(cnt);
      cuda_balls.ptrs_to_cuda_soa("balls_x");
      cuda_ball_cnt = cnt;
    }
  cuda_constants_update();

  // Just return if data already has valid values.
  //
  if ( ( data_location & DL_ALL_CUDA ) == DL_ALL_CUDA ) return false;
  data_location |= DL_ALL_CUDA;

  // Copy CPU's phys information to arrays, in preparation for
  // transfer to CUDA.
  //
  for ( int idx=0; idx<cnt; idx++ )
    {
      Phys* const phys = physs[idx];
      Tile* const tile = TILE(phys);

      int4 tact_counts;
      tact_counts.x = phys->phys_type;
      tact_counts.y = 0;        // phys->contact_count, init to 0
      tact_counts.z = 0;        // phys->debug_pair_calls, init to 0.
      tact_counts.w = tile && tile->marker ? 1 : 0; // 1 if wheel.
      tact_counts.w |= phys->read_only << 1;
      cuda_balls.soa.tact_counts[idx] = tact_counts;

      if ( tile )
        {
          float4 wht;
          wht.x = tile->width;
          wht.y = 0;     // mass_inv, identifying this as read-only.
          wht.z = 0;     // Torque, initialized to zero.
          wht.w = tile->height;;
          vec_sets3(cuda_balls.soa.position[idx],tile->pt_ll);
          vec_sets3(cuda_balls.soa.velocity[idx],tile->norm_rt);
          vec_sets3(cuda_balls.soa.omega[idx],tile->norm_up);
          vec_sets3(cuda_balls.soa.prev_velocity[idx],tile->normal);
          cuda_balls.soa.ball_props[idx] = wht;
          continue;
        }

      // Elements common to ball and boxes.

      vec_set(cuda_balls.soa.orientation[idx],phys->orientation);
      vec_sets3(cuda_balls.soa.position[idx],phys->position);
      cuda_balls.soa.position[idx].w = phys->radius;
      vec_sets3(cuda_balls.soa.prev_velocity[idx],phys->velocity);
      vec_sets3(cuda_balls.soa.velocity[idx],phys->velocity);
      vec_sets3(cuda_balls.soa.omega[idx],phys->omega);

      {
        float4 phys_props;
        phys_props.x = phys->radius;
        phys_props.y = phys->mass_inv;
        cuda_balls.soa.ball_props[idx] = phys_props;
      }

      if ( Ball* const ball = BALL(phys) )
        {
          cuda_balls.soa.ball_props[idx].z = ball->fdt_to_do;
        }
      else if ( Box* const box = BOX(phys) )
        {
          vec_sets3(cuda_balls.soa.to_111[idx],box->to_111);
        }
      else
        {
          ASSERTS( false );
        }
    }

  // Transfer the data.
  cuda_balls.to_cuda();
  return true;
}

void
World::cuda_data_to_cpu(uint which_data)
{
  /// Copy data from CUDA.

  ASSERTS( ( DL_ALL & ( data_location | ( data_location >> 4 ) ) ) == DL_ALL );
  ASSERTS( which_data & DL_ALL );

  // If the needed data is already on the CPU, return.
  //
  const uint mask = which_data & ~data_location;
  if ( !mask ) return;

  // Mark that the needed data is on the CPU (not yet, but it will be soon).
  //
  data_location |= which_data;

  cuda_balls.from_cuda();       // Transfer data.

  const int cnt = physs.occ();

  // Copy data to physs array, copying only the data that's
  // needed and not already present.
  //
  for ( int idx=0; idx<cnt; idx++ )
    {
      Phys* const phys = physs[idx];
      Tile* const tile = TILE(phys);

      if ( mask & DL_CV_CPU )
        {
          const int4 tact_counts = cuda_balls.soa.tact_counts[idx];
          phys->contact_count = tact_counts.y;
          phys->collision |= phys->contact_count;
          phys->debug_pair_calls = tact_counts.z;
        }

      if ( tile && tile->marker && ( mask & DL_PO_CPU ) )
        {
          ASSERTS( false );
          pCoor pt_ll; pt_ll.w = 1;
          pVect norm_rt, norm_up;
          vec_sets3(pt_ll,cuda_balls.soa.position[idx]);
          vec_sets4(norm_rt,cuda_balls.soa.velocity[idx]);
          vec_sets4(norm_up,cuda_balls.soa.omega[idx]);
          tile->set(pt_ll, tile->height * norm_up, tile->width * norm_rt);
        }

      if ( phys->read_only ) continue;
      ASSERTS( !tile );

      if ( mask & DL_CV_CPU )
        {
          vec_sets4(phys->velocity,cuda_balls.soa.velocity[idx]);
        }
      if ( mask & DL_OT_CPU )
        {
          vec_sets4(phys->omega,cuda_balls.soa.omega[idx]);
        }
      if ( mask & DL_PO_CPU )
        {
          vec_sets3(phys->position,cuda_balls.soa.position[idx]);
          vec_set(phys->orientation,cuda_balls.soa.orientation[idx]);
          phys->geometry_update();
        }
    }
  phys_check();
}
