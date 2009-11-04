/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   This file contains headers for CPU and GPU/cuda code.
//   See demo-x-collide.cc for main program.

#ifndef DEMO_X_CUH
#define DEMO_X_CUH

typedef ushort2 SM_Idx2;

struct CUDA_Ball {
  float4 position;
  float4 orientation;
  float3 velocity;
  float3 prev_velocity;
  float3 angular_momentum;
  int collision_count;
  int contact_count;
  uint debug_pair_calls;
};

struct CUDA_Ball_X { // X is for transpose.
  float4 *position;
  float4 *orientation;
  float3 *velocity;
  float3 *prev_velocity;
  float3 *angular_momentum;

  int *collision_count;
  int *contact_count;
  uint *debug_pair_calls;
};

struct __align__(64) CUDA_Ball_W { // W is for work.
  float3 position;
  float3 velocity;
  float3 angular_momentum;
  float3 prev_velocity;
  int collision_count;
  int contact_count;
  uint debug_pair_calls;
  int m_idx;
};

#define BALLS_PER_BLOCK ( 16000 / sizeof(CUDA_Ball_W) )

__host__ void pass_something_launch
(dim3 dg, dim3 db, int read_side, int ball_count);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int read_side, int prefetch_offset, int schedule_offset,
 int round_cnt);

#endif
