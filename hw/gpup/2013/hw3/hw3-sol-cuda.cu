/// LSU EE 4702-1 (Fall 2013), GPU Programming
//
 /// Homework 3
 //

 /// Most of the solution should be in this file.


 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2013/hw03.pdf



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

  /// Put Solution Code Here.

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

  /// Put Solution Code Here.


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
  /// Modify this routine.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int bi = tid; // Ball Index

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
  const float4 ball_position = ball->position;
  const float ball_radius = ball->radius;

  float3 force = zero_vec;

  // Gravitational Force
  //
  force += ball->mass * dc.gravity_accel;

  // Spring Force from Neighbor Balls
  //
  for ( int j = -3;  j < 4;  j++ )
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
      pNorm ball_to_neighbor = mn(ball_position,neighbor_ball->position);

      // Compute the speed of ball towards neighbor_ball.
      //
      pVect delta_v = neighbor_ball->velocity - ball->velocity;
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

  // Check for contact between us and other balls, except our immediate
  // neighbors.
  //
  for ( int j=0; j<dc.chain_length; j++ )
    if ( abs(j-bi)>1 )
      {
        Ball* const ball2 = &dc.d_balls[j];
        pNorm ball_to_2 = mn(ball_position,ball2->position);
        const float rsum = ball_radius + ball2->radius;
        if ( rsum * rsum > ball_to_2.mag_sq )
          {
            const float compression = rsum - ball_to_2.magnitude;
            const float f = -compression * 1000;
            force += f * ball_to_2;
          }
      }

  // Update Velocity
  //
  // This code assumes that force on ball is constant over time
  // step. This is clearly wrong when balls are moving with
  // respect to each other because the springs are changing
  // length. This inaccuracy will make the simulation unstable
  // when spring constant is large for the time step.
  //
  ball->velocity += delta_t * ball->mass_inv * force;

  // Air Resistance
  //
  const double fs = powf(1+dc.opt_air_resistance,-delta_t);
  ball->velocity *= fs;
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
  /// Modify this routine.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  const int bi = tid; // Ball Index

  if ( bi >= dc.chain_length ) return;

  Ball* const ball = &dc.d_balls[bi];

  ///
  /// Update Position of Each Ball
  ///

  // Update Position
  //
  // Assume that velocity is constant.
  //
  ball->position += ball->velocity * delta_t;

  // Possible Collision with Platform
  //

  // Skip if collision impossible.
  //
  if ( !platform_collision_possible(ball->position) ) return;
  if ( ball->position.y >= ball->radius ) return;
  if ( ball->position.y < 0 ) return;

  // Apply spring forces due to collision with platform.
  //
  const float spr_const = ball->velocity.y > 0 ? 500000 : 1000000;
  ball->velocity.y += ( ball->radius - ball->position.y ) * delta_t * spr_const;
}
