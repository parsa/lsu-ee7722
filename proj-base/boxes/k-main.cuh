/// LSU EE X70X-X (Fall 2012), GPU Programming
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   This file contains headers for CPU and GPU/cuda code.
//   See demo-x-collide.cc for main program.

#ifndef K_MAIN_CUH
#define K_MAIN_CUH

#undef XX_DEBUG

enum Force_Types { FT_Unset =0, FT_NonFriction=1, FT_Friction=2, FT_All=3 };

enum Phys_Type { PT_Unset =0, PT_Ball=1, PT_Tile=2, PT_Box=3, PT_ENUM_SIZE=4 };

enum Code_Path 
  { CP_Unset=0, CP_Ball_Ball=1, 
    CP_Box_Box=2, CP_Box_Ball=3,
    CP_Ball_Tile=4, CP_ENUM_SIZE=5 };

typedef ushort2 SM_Idx2;

struct CUDA_Ball {
  float4 position;
  float4 orientation;
  float4 velocity;
  float4 prev_velocity;
  float4 omega;
  int4 tact_counts;
  float4 ball_props;
  float4 to_111;
};

struct CUDA_Ball_X { // X is for transpose.
  float4 *position;
  float4 *orientation;
  float4 *velocity;
  float4 *prev_velocity;
  float4 *omega;
  int4 *tact_counts;
  float4 *ball_props;
  float4 *to_111;
};

struct CUDA_SectTT {
  float3 start;
  float3 dir;
  float pen_dist;
  bool exists; // If false, no intersection.
};

#ifndef COORD_H
struct pMatrix3x3 { float3 r0, r1, r2; };
#endif

struct CUDA_Box_W { // W is for work.
  float3 position;
  float3 velocity;
  float3 omega;
  float3 prev_velocity;
  float mass_inv, radius;
  float4 orientation;
  float3 to_111;
  pMatrix3x3 rot_inv;
  float3 mi_vec;
};

struct CUDA_Ball_W { // W is for work.
  float3 position;
  float3 velocity;
  float3 omega;
  float3 prev_velocity;
  float mass_inv, radius;
  float pad1, pad2;
};

struct CUDA_Tile_W {
  float3 pt_ll; // A corner called lower-left but it doesn't have to be.
  float3 norm_rt, norm_up;
  float3 normal;
  float width, height;
  float mass_inv;
  float torque;
};

struct CUDA_Phys_W  { // W is for work.
  union {
    CUDA_Ball_W ball;
    CUDA_Tile_W tile;
    CUDA_Box_W box;
  };
  short contact_count;
  short debug_pair_calls;
  short m_idx;
  bool read_only;
  char pt_type;
  char part_of_wheel;
  float pad[2];
};


struct CUDA_Wheel {
  float3 center;
  float3 axis_dir;
  float *omega;
  float moment_of_inertia_inv;
  float friction_torque;
  int idx_start, idx_stop;
};

// x: phys1, y: phys2, z: index into pair array;  w: unused.
typedef int4 XX_Pair;

__host__ void pass_platform_launch(dim3 dg, dim3 db, int ball_count);

__host__ cudaError_t cuda_get_attr_plat_pairs
(struct cudaFuncAttributes *attr_platform,
 struct cudaFuncAttributes *attr_pairs,
 struct cudaFuncAttributes *attr_xx_intersect);

__host__ void 
pass_xx_intersect_launch(dim3 dg, dim3 db, int xx_pairs_count);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt,
 int max_balls_per_thread, int balls_per_block_max, Force_Types ft);

__host__ bool
pass_sched_launch
(dim3 dg, dim3 db, int ball_count, float lifetime_delta_t,
 void *pos_array_dev, void *vel_array_dev);


// Type used to store proximities.
typedef int64_t Prox_Offsets;

// Number of proximities that can be stored per ball.
const int cuda_prox_per_ball = sizeof(Prox_Offsets);

#endif
