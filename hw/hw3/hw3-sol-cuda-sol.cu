/// LSU EE 4702-1 (Fall 2013), GPU Programming
//
 /// Homework 3  -- SOLUTION
 //

 /// Most of the solution is in this file.

 //  See the assignment: http://www.ece.lsu.edu/koppel/gpup/2013/hw03.pdf


__host__ void
launch_data_pack(int grid_size, int block_size)
{
  data_pack<<<grid_size,block_size>>>();
}

__global__ void
data_pack()
{
  const int bi = threadIdx.x + blockIdx.x * blockDim.x;
  if ( bi >= dc.chain_length ) return;
  if ( !dc.d_pos ) return;

  /// SOLUTION

  Ball* const ball = &dc.d_balls[bi];

  // Put ball position and radius into d_pos. An element of d_pos is a
  // float4. If space were the only concern it would have been a
  // float3. But GPUs can load float4 values more efficiently, and so
  // a float4 was used. The fourth element is used to hold the ball
  // radius.
  //
  dc.d_pos[bi] = ball->position;
  dc.d_pos[bi].w = ball->radius;
}

__host__ void
launch_data_unpack(int grid_size, int block_size)
{
  data_unpack<<<grid_size,block_size>>>();
}

__global__ void
data_unpack()
{
  const int bi = threadIdx.x + blockIdx.x * blockDim.x;
  if ( bi >= dc.chain_length ) return;
  if ( !dc.d_pos ) return;

  /// SOLUTION

  // Put the position data back into the ball structure. Note that the
  // pack and unpack routines are called less frequently than the time
  // step routines.
  //
  Ball* const ball = &dc.d_balls[bi];
  ball->position = dc.d_pos[bi];
  ball->position.w = 1;
}


__host__ void
launch_time_step_gpu_sol_part_1
(int grid_size, int block_size, float delta_t)
{
 time_step_gpu_sol_part_1<<<grid_size,block_size>>>(delta_t);
}

__global__ void
time_step_gpu_sol_part_1(float delta_t)
{
  /// SOLUTION

  // Based on the launch configuration (number of threads per block
  // [blockDim.x] and number of blocks [gridDim.x]) determine how many
  // balls each block will handle and the number of threads per ball.
  //
  const int balls_per_block = ( gridDim.x - 1 + dc.chain_length ) / gridDim.x;
  const int thds_per_ball = blockDim.x / balls_per_block;

  const int bi_block = blockIdx.x * balls_per_block;

  const int b_local = threadIdx.x % balls_per_block;
  const int bi = bi_block + b_local;
  const int ai_first = threadIdx.x / balls_per_block;

  if ( ai_first >= thds_per_ball ) return;
  if ( bi >= dc.chain_length ) return;

  Ball* const ball = &dc.d_balls[bi];

  // Convenient zero vector.
  const float3 zero_vec = make_float3(0,0,0);

  if ( dc.opt_head_lock && bi == 0
       || dc.opt_tail_lock && bi == dc.chain_length - 1 )
    {
      ball->velocity = zero_vec;
      return;
    }

  // Load the ball position and radius from memory. They will be used
  // several times. (They are loaded into registers.)
  //

  /// SOLUTION
  //  Load from new d_pos array.
  const float4 ball_position = dc.d_pos[bi];

  const float ball_radius = ball->radius;
  const float3 ball_velocity = ball->velocity;

  float3 force = zero_vec;

  // Gravitational Force
  //
  /// SOLUTION
  //  Only one thread per ball applies gravitational force.
  if ( ai_first == 0 )
    force += ball->mass * dc.gravity_accel;

  // Spring Force from Neighbor Balls
  //

  /// SOLUTION
  //  Divide work of applying a ball's neighbor forces between the
  //  different threads assigned to that ball.
  //
  for ( int j = ai_first - 3;  j < 4;  j += thds_per_ball )
    {
      const int n_idx = bi + j;
      if ( j == 0 ) continue;
      if ( n_idx < 0 ) continue;
      if ( n_idx >= dc.chain_length ) continue;
      const int idx_dist = abs(j);
      const bool rep_only = idx_dist > 1;

      Ball* const neighbor_ball = &dc.d_balls[n_idx];

      // Construct a normalized (Unit) Vector from ball to neighbor.
      //
      /// SOLUTION
      //  Use d_pos array.
      pNorm ball_to_neighbor = mn(ball_position,dc.d_pos[n_idx]);

      // Compute the speed of ball towards neighbor_ball.
      //
      pVect delta_v = neighbor_ball->velocity - ball_velocity;
      float delta_s = dot( delta_v, ball_to_neighbor );

      // Compute distance between us and neighbor at which "spring"
      // will be relaxed (neither stretched nor compressed).
      //
      const float distance_relaxed =
        rep_only ? idx_dist * dc.distance_relaxed : dc.distance_relaxed;

      // Compute by how much the spring is stretched (positive value)
      // or compressed (negative value).
      //
      const float spring_stretch =
        ball_to_neighbor.magnitude - distance_relaxed;

      // Determine whether spring is gaining energy (whether its length
      // is getting further from its relaxed length).
      //
      const bool gaining_e = ( delta_s > 0.0f ) == ( spring_stretch > 0 );

      // Use a smaller spring constant when spring is loosing energy,
      // a quick and dirty way of simulating energy loss due to spring
      // friction.
      //
      const float spring_constant =
        gaining_e ? dc.opt_spring_constant : dc.opt_spring_constant * 0.7f;

      if ( !rep_only || spring_stretch < 0 )
        force += spring_constant * spring_stretch * ball_to_neighbor;
    }

  /// SOLUTION

  __shared__ float3 forces[1024];
  forces[threadIdx.x] = force;
  
  __syncthreads();

  // At this point the values of each ball's forces are spread over
  // several threads. Here one volunteer thread per ball (the thread
  // with ai_first==0) will add up these forces.
  //
  if ( ai_first == 0 )
    {
      // Add up forces.  Because only 7 values are added a linear
      // reduction (the loop) is acceptable. If more values needed
      // to be added a tree reduction would be used.
      //
      const int iters = min(7,thds_per_ball);
      for ( int i=1; i<iters; i++ ) 
        force += forces[threadIdx.x + i * balls_per_block];
      forces[threadIdx.x] = force;
    }

  __syncthreads();

  // Check for contact between us and other balls, except our immediate
  // neighbors.  If opt_test1 is true then skip these tests, as a way
  // of demonstrating how much time they take.
  //
  if ( !dc.opt_test1 )
    for ( int j=ai_first; j<dc.chain_length; j += thds_per_ball )
      if ( abs(j-bi)>1 )
        {
          Ball* const ball2 = &dc.d_balls[j];
          pNorm ball_to_2 = 
            mn( ball_position,
                dc.opt_test2 ? ball2->position : dc.d_pos[j]);
          const float rsum = ball_radius +
            ( dc.opt_test2 ? ball2->radius : dc.d_pos[j].w );
          if ( rsum * rsum > ball_to_2.mag_sq )
            {
              const float compression = rsum - ball_to_2.magnitude;
              const float f = -compression * 1000;
              const float3 sep_f = f * ball_to_2;
              atomicAdd(&forces[b_local].x,sep_f.x);
              atomicAdd(&forces[b_local].y,sep_f.y);
              atomicAdd(&forces[b_local].z,sep_f.z);
            }
        }

  __syncthreads();

  if ( ai_first ) return;

  float3 velocity = ball_velocity;

  velocity += delta_t * ball->mass_inv * forces[b_local];

  // Air Resistance
  //
  const double fs = powf(1+dc.opt_air_resistance,-delta_t);
  velocity *= fs;

  ball->velocity = velocity;
}


__host__ void
launch_time_step_gpu_sol_part_2
(int grid_size, int block_size, float delta_t)
{
 time_step_gpu_sol_part_2<<<grid_size,block_size>>>(delta_t); 
}

__global__ void
time_step_gpu_sol_part_2(float delta_t)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int bi = tid; // Ball Index

  if ( bi >= dc.chain_length ) return;

  Ball* const ball = &dc.d_balls[bi];

  // Update Position
  //
  // Assume that velocity is constant.
  //
  /// SOLUTION
  //  Update d_pos array.
  float4 pos = dc.d_pos[bi] += ball->velocity * delta_t;

  /// SOLUTION
  //  Also update ball structure if test2 is true, to be able to
  //  see the affect of less efficient memory access.
  //
  if ( dc.opt_test2 )
    ball->position = pos;

  // Possible Collision with Platform
  //

  // Skip if collision impossible.
  //
  if ( !platform_collision_possible(pos) ) return;
  if ( pos.y < 0 ) return;
  if ( pos.y >= ball->radius ) return;

  const float spr_const = ball->velocity.y > 0 ? 500000 : 1000000;

  ball->velocity.y += ( ball->radius - pos.y ) * delta_t * spr_const;
}
