/// LSU EE 4702-X/7722 GPU Programming / Microarch
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   This file contains headers for CPU and GPU/cuda code.
//   See balls.cc for main program.

#ifndef BALLS_CUH
#define BALLS_CUH

#include <gp/cuda-gpuinfo.h>


enum Phys_Type { PT_Unset =0, PT_Ball=1, PT_Tile=2, PT_ENUM_SIZE=3 };


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

struct CUDA_Ball_W { // W is for work.
  float3 position;
  float3 velocity;
  float3 omega;
  float3 prev_velocity;
  float radius, mass_inv;
  float pad, pad2;
};

struct CUDA_Tile_W {
  float3 pt_00; // pos
  float lx, ly;
  float torque; // vel
  float3 nx, ny; // omega, prev vel
  float3 tact_pos; // scalars.
  float tact_time;
};

struct CUDA_Phys_W { // W is for work.
  union {
    CUDA_Ball_W ball;
    CUDA_Tile_W tile;
  };
  char pt_type;
  char part_of_wheel;
  short contact_count;
  short debug_pair_calls;
  short m_idx;
};

struct CUDA_Wheel {
  float3 center;
  float3 axis_dir;
  float *omega;
  float moment_of_inertia_inv;
  float friction_torque;
  int idx_start, idx_stop;
};

__host__ void pass_platform_launch(dim3 dg, dim3 db, int ball_count);

__host__ cudaError_t cuda_get_attr_plat_pairs(GPU_Info *gpu_info);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt,
 int max_balls_per_thread, int balls_per_block_max);


__host__ void
pass_sched_launch
(dim3 dg, dim3 db, int ball_count, float lifetime_delta_t,
 void *pos_array_dev, void *vel_array_dev);


// Type used to store proximities.
typedef int64_t Prox_Offsets;

// Number of proximities that can be stored per ball.
const int cuda_prox_per_ball = sizeof(Prox_Offsets);


#endif
