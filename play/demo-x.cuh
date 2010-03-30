/// LSU EE X70X-X (Sp 2010), GPU Microarchitecture
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
  float4 velocity;
  float4 prev_velocity;
  float4 omega;
  int4 tact_counts;
  float4 ball_props;
};

struct CUDA_Ball_X { // X is for transpose.
  float4 *position;
  float4 *orientation;
  float4 *velocity;
  float4 *prev_velocity;
  float4 *omega;
  int4 *tact_counts;
  float4 *ball_props;
};

struct  CUDA_Ball_W { // W is for work.
  float3 position;
  float3 velocity;
  float3 omega;
  float3 prev_velocity;
  short collision_count;
  short contact_count;
  short debug_pair_calls;
  short m_idx;
  float radius, mass_inv;
  char pad[4];
};

#define BALLS_PER_BLOCK ( 16000 / sizeof(CUDA_Ball_W) )

__host__ void pass_platform_launch(dim3 dg, dim3 db, int ball_count);

__host__ cudaError_t cuda_get_attr_plat_pairs
(struct cudaFuncAttributes *attr_platform,
 struct cudaFuncAttributes *attr_pairs);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt);

#endif
