/// LSU EE X70X GPU Prog / Microarch
//
 /// Code for scheduling contact pairs to work on for CUDA threads.

#include <pthread.h>
#include "world.h"
#include "phys.h"
#include "cuda-sched.h"

void
World::cuda_schedule()
{
  /// Prepare CUDA Schedule for Contact Pair Handling
  //
  //  Each CUDA thread reads the schedule to determine which
  //  phys pairs to handle (by calling penetration_balls_resolve).
  //
  //  The schedule consists of two arrays, block_balls_needed and
  //  cuda_tacts_schedule.
  //
  //  The block_balls_needed array lists all the balls needed by each
  //  block in each pass. At the beginning of a pass threads will read
  //  ball numbers from this array and load (prefetch) data for those
  //  balls from device memory into shared memory.
  //
  //  The cuda_tacts_schedule lists pairs of phys, threads
  //  will call penetration_balls_resolve on these pairs, which
  //  will read and write shared memory.
  //
  //  At the end of a pass data from shared memory is copied back
  //  to device memory.

#define Static static

  frame_timer.user_timer_start(timer_id_sched);

  const int block_size = opt_block_size;

  // Find pairs of phys that are in contact or might soon be.
  // The pairs are assigned to variable pairs and the identity of
  // phys near to a ball are put in its proximity member.
  //
  contact_pairs_find();

  // Prepare Ball Lists
  //
  // neighborhood:     Most desirable phys to schedule in the current pass.
  // physs_todo_now:   Phys to schedule in the current pass, after neighbors.
  // physs_todo_later: Phys to schedule in the next pass.
  //
  Static PQueue<Phys*> physs_todo_a, physs_todo_b;
  Static PQueue<Phys*> neighborhood;
  physs_todo_a.reset(); physs_todo_b.reset(); neighborhood.reset();
  PQueue<Phys*> *physs_todo_now = &physs_todo_a;
  PQueue<Phys*> *physs_todo_later = &physs_todo_b;

  // Initialize phys members for scheduling, and initialize physs_todo_now.
  //
  for ( Phys_Iterator phys(physs); phys; phys++ )
    {
      phys->idx = phys.get_idx();
      phys->color_block = -1; // Used for coloring based on block num.
      if ( !phys->proximity.occ() ) continue;
      phys->pass = -1;
      phys->pass_todo = 0;
      phys->block = -1;
      if ( phys->read_only ) continue;
      physs_todo_later->enqueue(phys);
    }

  const double block_size_inv = 1.0 / block_size;

  int block_num = -1;
  int ball_count = -1;
  const int max_rounds = 32;
  const int ball_limit = balls_per_block_max;
  int iterations = 0;           // Used for algorithm tuning.
  int thd_rounds = 0;           // Used for placement tuning.
  bool new_block = false;
  const int ball_idx_bits = 18;

# define WARP_LG 5
# define WARP_SIZE (1<<WARP_LG)
# define WARP_MASK (WARP_SIZE-1)

  const int warp_per_block = ( block_size + WARP_MASK ) >> WARP_LG;
  const int max_code_paths = CP_ENUM_SIZE;
  const int cp_limit = min(warp_per_block,max_code_paths);
  const int round_retry_limit = max( block_size >> 2, 4 );
  int next_thd[cp_limit+1][max_rounds];

  // Return next thread to use for a given contact pair code path and
  // round. To limit branch divergence, contact pairs with different
  // code paths are placed in different warps.
  //

#define next_thd_get(code_path,round)                                         \
  ({ int& cthd = next_thd[min(code_path,cp_limit)][round];                    \
    ASSERTS(code_path >= 0 );                                                 \
    ASSERTS(round >= 0 && round < max_rounds);                                \
     if ( ( cthd & WARP_MASK ) == 0 ) {                                       \
       cthd = next_thd[0][round]; next_thd[0][round] += WARP_SIZE; }          \
     cthd >= block_size ? -1 : cthd++; })

  PQueue<int> tacts;

  passes_next->reset();
  PSList<Phys*,uint> pref_balls;
  pref_balls.reset();
  int soft_ball_limit = 0;
  int new_seed_ball_limit = 0;

  while ( true )
    {
      // If there are no more neighbors of placed balls to
      // work on, grab any unplaced ball.
      //
      if ( !neighborhood.occ() && physs_todo_now->occ() )
        {
          Pass* const p = &passes_next->peek();
          const int block_num_base = p->block_num_base;

          while ( physs_todo_now->occ() )
            {
              Phys* const phys = physs_todo_now->dequeue();
              const bool placed = phys->block >= block_num_base;
              if ( placed ) continue;
              if ( ball_count > new_seed_ball_limit ) new_block = true;
              neighborhood += phys;
              break;
            }
        }

      const bool new_pass = !neighborhood.occ();

      // Check for end of this pass.
      //
      if ( new_pass )
        {
          // If there is nothing in the next pass, exit the loop.
          //
          if ( !physs_todo_later->occ() ) break;

          // Prepare for the next pass by swapping todo lists.
          //
          PQueue<Phys*>* const todo_x = physs_todo_now;
          physs_todo_now = physs_todo_later; physs_todo_later = todo_x;

          neighborhood += physs_todo_now->dequeue();
        }

      ASSERTS( ball_count <= ball_limit );

      // If necessary, initialize a new block.
      //
      // A new block is prepared if the old block reached the ball limit
      // or if this is the start of a new pass and the current block isn't
      // empty.
      //
      if ( new_pass && ball_count || new_block )
        {
          new_block = false;
          ball_count = 0;  block_num++;
          bzero(next_thd,sizeof(next_thd));
        }

      // If necessary, initialize a new pass.
      //
      if ( new_pass )
        {
          Pass* const p = passes_next->pushi();
          p->block_num_next_pass = p->block_num_base = block_num;
          p->ball_cnt = 0;
          p->thread_num_max = 0;
          p->balls_per_block_max = 0;
          p->round_cnt = 0;
          soft_ball_limit =
            passes_next->occ() == 1 ?
            min(max(8, 2 * block_size), ball_limit ) : ball_limit;
          new_seed_ball_limit = min(30,soft_ball_limit-2);
        }

      const int pass_num = passes_next->occ() - 1;
      Pass* const p = &passes_next->peek();
      const int block_num_base = p->block_num_base;

      // Get a phys to consider.
      //
      Phys* const phys1 = neighborhood.dequeue();
      ASSERTS( !phys1->read_only );

      // Check whether this ball already used in this pass.
      //
      const bool b1_placed = phys1->block >= block_num_base;

      // Macro for adding ball to todo list.
#define NEXT_PASS_ADD(ba)                                                     \
      { if ( ba->pass_todo <= pass_num )                                 \
          { ba->pass_todo = pass_num + 1; physs_todo_later->enqueue(ba); } }

      // If ball used in this pass but not in this block then we have no
      // choice but to schedule it in a future pass.
      //
      if ( b1_placed && phys1->block != block_num )
        { NEXT_PASS_ADD(phys1);  continue; }

      // Initialize schedule for this ball if it's new to this block.
      //
      if ( !b1_placed ) phys1->rounds = 0;

      // Look for balls near phys1 that have not been considered,
      // and add suitable ones to tacts (contacts).
      //
      tacts.reset();

      for ( int c_idx = phys1->proximity.iterate_reset();
            phys1->proximity.iterate(c_idx); )
        {
          iterations++;
          Contact* const c = &contact_pairs[c_idx];
          if ( c->pass >= 0 ) continue;
          Phys* const phys2 = c->other_phys(phys1);
          const bool b2_placed =
            phys2->block >= block_num_base;

          // If other ball used in this pass but not this block
          // then we can't consider the phys1/phys2 contact in this
          // pass, so try again in the next pass. (Either phys1 or phys2
          // could be added, phys1 may be more efficient.) This doesn't
          // apply to read-only objects.
          //
          if ( b2_placed && phys2->block != block_num && !phys2->read_only )
            { NEXT_PASS_ADD(phys1);  continue; }

          if ( !b2_placed ) phys2->rounds = 0;
          tacts += c_idx;
        }

      int rounds_skipped = 0;
      int dwell_count = 0;
      int round = 0;
      int round_full_cnt = 0;
      while ( tacts.occ() && round < max_rounds )
        {
          // Counter used for tuning CPU time of this scheduling algorithm.
          iterations++;

          // Get a contact pair to try.
          //
          const int c_idx = tacts.dequeue();
          Contact* const c = &contact_pairs[c_idx];
          Phys* const phys2 = c->other_phys(phys1);
          const bool b1_placed = phys1->block >= block_num_base;
          const bool b2_placed = 
            phys2->read_only
            ? phys2->block == block_num
            : phys2->block >= block_num_base;
          const int code_path = c->code_path;

          // Bit positions indicate rounds in which ball is used.
          const uint32_t mask = 1 << round;

          // If phys1 used elsewhere in this round move to next round.
          //
          if ( phys1->rounds & mask )
            {
              round++;  dwell_count = 0;
              rounds_skipped++;
              tacts += c_idx;   // Put contact pair back in list.
              continue;
            }

          // Check if phys2 used elsewhere in this round.
          //
          if ( phys2->rounds & mask )
            {
              // Move to next round if we've already tried scheduling
              // other balls in this round.
              //
              if ( dwell_count++ >= tacts.occ() )
                {
                  round++;  dwell_count = 0;
                  rounds_skipped++;
                }

              tacts += c_idx;   // Put contact pair back in list.
              continue;
            }
          dwell_count = 0;

          const int next_ball_count = ball_count + !b1_placed + !b2_placed;

          // If this contact pair would exceed ball limit, then try again
          // next pass.
          //
          if ( next_ball_count > soft_ball_limit )
            { NEXT_PASS_ADD(phys1); continue; }

          const int thd = next_thd_get(code_path,round);
          if ( thd < 0 )
            {
              round++;  round_full_cnt++;
              tacts += c_idx;   // Put contact pair back in list.
              if ( round_full_cnt > round_retry_limit )
                { new_block = true;  break; }
              continue;
            }

          if ( !b1_placed )
            {
              phys1->block = block_num;
              p->ball_cnt++;

              // Add ball to prefetch list.  Used to load CUDA
              // shared memory.
              //
              pref_balls.insert
                ( ( block_num << ball_idx_bits ) | phys1->idx, phys1 );
            }

          if ( !b2_placed )
            {
              if ( !phys2->read_only || phys2->block < block_num_base )
                p->ball_cnt++;
              phys2->block = block_num;
              pref_balls.insert
                ( ( block_num << ball_idx_bits ) | phys2->idx, phys2 );

              // Put phys2 at the head of the todo list since phys1 and phys2
              // are likely to have common neighbors.
              //
              if ( !phys2->read_only )
                neighborhood += phys2;
            }

          ball_count = next_ball_count;
          set_max(p->balls_per_block_max,ball_count);

          /// Scheduling of this Contact Pair Complete
          //
          c->pass = pass_num;
          c->block = block_num;
          c->thread = thd;
          set_max(p->thread_num_max,c->thread);
          c->round = round;
          p->block_num_next_pass = block_num + 1;

          // Update bit vectors indicating which rounds ball used.
          if ( !phys1->read_only ) phys1->rounds |= mask;
          if ( !phys2->read_only ) phys2->rounds |= mask;

          round++;
          thd_rounds += rounds_skipped + 1;
          rounds_skipped = 0;
          set_max(p->round_cnt,round);
        }

      // If anything is left over, re-consider ball in next pass.
      //
      if ( tacts.occ() ) NEXT_PASS_ADD(phys1);
    }

  // Compute number of blocks in each pass and collect tuning information.
  //
  int pass_blocks = 0;
  int pass_block_rounds = 0;
  int total_rounds = 0;
  int max_blocks = 0;
  while ( Pass* const p = passes_next->iterate() )
    {
      p->thread_cnt_max = p->thread_num_max + 1;
      p->block_cnt = p->block_num_next_pass - p->block_num_base;
      p->balls_per_thread_max =
        int( ceil( p->balls_per_block_max * block_size_inv ) );
      pass_blocks += p->block_cnt;
      total_rounds += p->round_cnt;
      pass_block_rounds += p->block_cnt * p->round_cnt;
      set_max(max_blocks,p->block_cnt);
    }

  {
    // Temporary Hack.
    Pass& last_p = passes_next->peek();
    if ( passes_next->occ() > 1 && last_p.block_cnt == 0 ) passes_next->pop();
  }

  // Prepare the pair_check sorted list, which is used for scheduling,
  // sanity checks, and collecting tuning information.
  //
  Static PSList<Contact*,int64_t> pair_check;
  pair_check.reset();
  while ( Contact* const c = contact_pairs.iterate() )
    if ( !c->phys1->read_only || !c->phys2->read_only )
      pair_check.insert
        ( c->block * max_rounds * block_size
          + c->round * block_size + int64_t(c->thread) ,
          c );
  pair_check.sort();

  // Sanity Check: Make sure phys scheduled in at most one
  // block per pass.
  //
  for ( Phys_Iterator ball(physs); ball; ball++ ) ball->pass = -1;
  while ( Contact* const c = pair_check.iterate() )
    {
      const int pass = c->pass;
      const int round = c->round;
      const int block = c->block;
      ASSERTS( pass >= 0 );
      for ( int i=0; i<2; i++ )
        {
          Phys* const b = i ? c->phys2 : c->phys1;
          ASSERTS( b->pass < pass || b->read_only
                   || b->block == block && b->rounds < round );
          b->pass = pass;
          b->block = block;
          b->rounds = round;
        }
    }

  // Tuning Info: Determine how much each warp being used.
  //
  int warp_rounds = 0;
  const int warp_lg = 5;
  const int warps_per_block = max(1,block_size >> warp_lg);
  const int warp_limit = ( block_num + 1 ) * warps_per_block;
  int warp_rounds_each[warp_limit];
  bzero(warp_rounds_each,sizeof(warp_rounds_each));
  int warp_path = 0, idx_last = -1;
  int warp_cnt = 0;
  int warp_broken_cnt = 0;
  while ( Contact* const c = pair_check.iterate() )
    {
      const int round_cnt = c->round + 1;
      const int warp_idx = c->thread >> WARP_LG;
      const int idx = c->block * warps_per_block + warp_idx;

      if ( idx != idx_last )
        {
          warp_cnt++;
          warp_path = c->code_path;
          idx_last = idx;
        }
      else if ( warp_path && warp_path != c->code_path )
        {
          warp_broken_cnt++;
          warp_path = 0;
        }

      ASSERTS( idx >= 0 && idx < warp_limit );

      const int a = round_cnt - warp_rounds_each[idx];
      if ( a <= 0 ) continue;
      warp_rounds_each[idx] = round_cnt;
      warp_rounds += a;
    }

  round_count_prev = total_rounds;
  static int total_rounds_max = 0;
  if ( opt_info || total_rounds > total_rounds_max )
    {
      opt_info = false;
      printf("For %d tacts, %d p, %d tot rnds; "
             "Max Bl %d/%d/%d W %d/%d  Eff %.3f %.3f  Br %.5f\n",
             contact_pairs.occ(),
             passes_next->occ(),
             total_rounds,
             max_blocks, pass_blocks, pass_block_rounds,
             warp_rounds << warp_lg,
             thd_rounds,
             contact_pairs.occ() / double(warp_rounds<<warp_lg),
             contact_pairs.occ() / double(iterations),
             warp_broken_cnt / double(warp_cnt)
             );
      total_rounds_max = total_rounds;
    }

  // Determine size of schedule data (cuda_tacts_schedule and
  // block_balls_needed) for each pass, and remember offsets into
  // these arrays.
  //
  int ba_size = 0;
  int pa_size = 0;

  while ( Pass* const p = passes_next->iterate() )
    {
      p->dim_block.x = block_size;
      p->dim_block.y = p->dim_block.z = 1;
      p->dim_grid.x = p->block_cnt;
      p->dim_grid.y = p->dim_grid.z = 1;
      p->prefetch_offset = pa_size;
      const int prefetch_elts_per_block = p->balls_per_thread_max * block_size;
      p->prefetch_elts_per_block = prefetch_elts_per_block;
      pa_size += prefetch_elts_per_block * p->block_cnt;
      p->schedule_offset = ba_size;
      ba_size += block_size * p->block_cnt * p->round_cnt;
    }

  // Update size of schedule arrays and initialize.
  //
  cuda_tacts_schedule.realloc_locked(ba_size);
  block_balls_needed.realloc_locked(pa_size);
  memset(cuda_tacts_schedule.data,-1,cuda_tacts_schedule.chars);
  memset(block_balls_needed.data,-1,block_balls_needed.chars);

  pref_balls.sort();

  // Write schedule arrays.
  //
  int block_curr = -1;
  int pbi = 0;
  xx_pairs_count = 0;
  while ( Contact* const c = pair_check.iterate() )
    if ( c->code_path == CP_Box_Box ) xx_pairs_count++;
  xx_pairs.realloc(xx_pairs_count);
  xx_pairs_debug.realloc(xx_pairs_count);
  xx_pairs_count = 0;

  while ( Contact* const c = pair_check.iterate() )
    {
      const int round = c->round;
      const int block = c->block;
      Pass& p = passes_next[0][c->pass];

      // Fill in prefetch (balls_needed) array.
      //
      if ( block_curr != block )
        {
          block_curr = block;
          const int idx_base =
            p.prefetch_offset
            + ( block - p.block_num_base ) * p.prefetch_elts_per_block;
          int ball_sidx_next = 0;
          while ( pbi < pref_balls.occ() )
            {
              const int pb_block = pref_balls.get_key(pbi) >> ball_idx_bits;
              if ( pb_block > block_curr ) break;
              Phys* const b = pref_balls[pbi++];
              const int idx = idx_base + ball_sidx_next;
              ASSERTS( ball_sidx_next < ball_limit );
              ASSERTS( pb_block == block );
              ASSERTS( block_balls_needed[idx] == -1 );
              ASSERTS( idx >= 0 && idx < pa_size );
              b->sm_idx = ball_sidx_next++;
              block_balls_needed[ idx ] = b->idx;
              if ( c->pass == opt_block_color_pass ) b->color_block = block;
            }
        }

      // Fill in cuda_tacts_schedule array.
      //
      const bool two_first = c->phys1->phys_type > c->phys2->phys_type;
      Phys* const physa = two_first ? c->phys2 : c->phys1;
      Phys* const physb = two_first ? c->phys1 : c->phys2;

      SM_Idx2 pair(physa->sm_idx, physb->sm_idx);
      const int ba_idx =
        p.schedule_offset
        + ( block - p.block_num_base ) * p.round_cnt * block_size
        + round * block_size
        + c->thread;
      ASSERTS( ba_idx < ba_size && ba_idx >= 0 );
      SM_Idx2 old_pair = cuda_tacts_schedule[ba_idx];
      ASSERTS( old_pair.x == 0xffff && old_pair.y == 0xffff );
      cuda_tacts_schedule[ ba_idx ] = pair;

      if ( c->code_path == CP_Box_Box )
        {
          xx_pairs[xx_pairs_count].x = physa->idx;
          xx_pairs[xx_pairs_count].y = physb->idx;
          xx_pairs[xx_pairs_count].z = ba_idx;
#ifdef XX_DEBUG
          xx_pairs_debug[xx_pairs_count] =
            box_box_intersect(BOX(physa),BOX(physb),NULL);
#endif
          xx_pairs_count++;
        }
    }

  xx_sects_dir.realloc(ba_size);
  xx_sects_center.realloc(ba_size);
  xx_sects_debug.realloc(ba_size);

  frame_timer.user_timer_end(timer_id_sched);
}

 ///
 /// CUDA Scheduler Thread Routines
 ///

#define CP(f) { const int rv=f; ASSERTS( rv == 0 ); }

// Wrapper to call scheduler main thread in World class.
void* pt_sched_main(void *arg){((World*)arg)->pt_sched_main();return NULL;}


void
World::pt_init()
{
  // Initialize pthread condition variables and mutex, thread interaction.
  //
  CP(pthread_cond_init(&pt_render_cond,NULL));
  CP(pthread_cond_init(&pt_sched_cond,NULL));
  CP(pthread_mutex_init(&pt_mutex,NULL));
  CP(pthread_mutex_init(&pt_pairs_mutex,NULL));
  pt_sched_waiting = false;
  pt_render_cmd = 0;

  // Create scheduler thread and wait for it to be ready.
  //
  CP(pthread_create(&pt_sched_tid, NULL, ::pt_sched_main, (void*)this));
  pt_sched_waitfor();
}

void
World::pt_sched_main()
{
  /// Main Scheduler Thread Routine

  // Initialize.
  pt_sched_data_pending = false;

  while ( true )
    {
      // Wait for a command from the render (main) thread.
      //
      CP(pthread_mutex_lock(&pt_mutex));
      pt_sched_waiting = true;
      while ( !pt_render_cmd )
        pthread_cond_wait(&pt_sched_cond,&pt_mutex);

      // Main thread has woken us up (with pthread_cond_signal),
      // perform command we were roused for.
      //
      const char cmd = pt_render_cmd;
      pt_render_cmd = 0;
      pt_sched_waiting = false;
      pthread_mutex_unlock(&pt_mutex);
      // After unlocking main thread can "see" that we are awake and
      // received the command (since it's now zero).

      // Exit scheduler thread, perhaps because program is exiting.
      //
      if ( cmd == 'x' ) break;

      // Wake up render thread.
      //
      if ( cmd == 'w' )
        {
          pthread_mutex_lock(&pt_mutex);
          pthread_cond_signal(&pt_render_cond);
          pthread_mutex_unlock(&pt_mutex);
          continue;
        }

      ASSERTS( cmd == 's' );

      // Compute a CUDA schedule.
      //
      cuda_schedule();
    }
}

bool
World::pt_sched_is_idle()
{
  /// Return true if scheduling thread is idle.

  CP(pthread_mutex_lock(&pt_mutex));
  const bool rv = pt_sched_waiting && !pt_render_cmd;
  CP(pthread_mutex_unlock(&pt_mutex));
  return rv;
}

void
World::pt_sched_waitfor()
{
  /// Wait for schedule thread to be idle.

  CP(pthread_mutex_lock(&pt_mutex));

  while ( pt_sched_waiting && pt_render_cmd )
    {
      // Schedule thread is idle, but has work to do (pt_render_cmd),
      // so wait for that to be finished.
      //
      pthread_mutex_unlock(&pt_mutex);
      pthread_yield();
      pthread_mutex_lock(&pt_mutex);
    }

  while ( true )
    {
      if ( pt_sched_waiting ) break;

      // Schedule thread isn't waiting, so request a wakeup and
      // go to sleep.
      //
      pt_render_cmd = 'w';
      pthread_cond_wait(&pt_render_cond,&pt_mutex);
    }
  ASSERTS( !pt_render_cmd );
  CP(pthread_mutex_unlock(&pt_mutex));
}

void
World::pt_sched_start()
{
  /// Command scheduler thread to compute schedule.
  //
  // Called from render (main) thread.

  ASSERTS( pt_sched_waiting );

  // Get data from CUDA.
  // This can only be done from one thread, here the render thread.
  //
  cuda_data_to_cpu( DL_PO | DL_CV );

  if ( opt_cuda_prox )
    {
      cpu_data_to_cuda();  // In case new balls were added.
      cuda_contact_pairs_find();
    }

  // Set command and then wake up scheduler thread.
  //
  CP(pthread_mutex_lock(&pt_mutex));
  pt_render_cmd = 's';
  pthread_cond_signal(&pt_sched_cond); // Wake up scheduler.
  pt_sched_data_pending = true;
  CP(pthread_mutex_unlock(&pt_mutex));
}
