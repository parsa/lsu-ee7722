/// LSU EE 7700-1 (Sp 2009), Graphics Processors -*- c++ -*-
//
 /// Balloon Simulation

// $Id:$

 /// Purpose
//
//   Demonstrate use of gpu for physics.

#ifndef CUBE6_CUH
#define CUBE6_CUH

#include <stdint.h>

#define CUDA_TRI_BLOCK_LG 6
#define CUDA_TRI_BLOCK_SIZE (1<<CUDA_TRI_BLOCK_LG)

#define CUDA_VTX_BLOCK_LG 6
#define CUDA_VTX_BLOCK_SIZE (1<<CUDA_VTX_BLOCK_LG)

struct __align__(16) CUDA_Tri_Strc {
  int16_t pi, qi, ri;
  int16_t pi_opp, qi_opp, ri_opp;
  float length_relaxed;
};  // 16 bytes

#define VTX_TRI_DEG_MAX 8

struct __align__(16) CUDA_Vtx_Strc  {
  // Index of triangles that contain this element's vertex.
  uint16_t n0, n1, n2, n3, n4, n5, n6, n7;
};

struct __align__(16) CUDA_Vtx_Data {
  float3 surface_normal;
  float pad1;  // Pad to enable easy access using float4 texture fetches.
  float3 vel;
  float pad2;
  float3 pos;
  float pad3;
};

struct __align__(16) CUDA_Tri_Data {
  float3 surface_normal;
  float3 force_p;
  float3 force_q;
  float3 force_r;
};

struct __align__(32) CUDA_Tri_Work_Strc {
  int16_t pi, qi, ri, pull_i;   // 8 bytes
  int16_t vi_opp0, vi_opp1, vi_opp2, vi_opp3;  // 8 bytes
  float length_relaxed;
  int8_t pull_tid_0, pull_tid_1, pull_tid_2, pull_tid_3;
  int8_t pad[8];
}; // 32 bytes


__host__ void pass_triangles_launch
(dim3 dg, dim3 db, CUDA_Vtx_Data *vtx_data, size_t vtx_data_size);
__host__ void pass_vertices_launch
(dim3 dg, dim3 db, CUDA_Tri_Data *tri_data, CUDA_Vtx_Data *vtx_out,
 size_t vtx_data_size);
__host__ void pass_unified_launch
(dim3 dg, dim3 db,
 CUDA_Vtx_Data *vtx_data_in, CUDA_Vtx_Data *vtx_out,
 float *tv_in, float *tv_out,
 size_t tri_data_size, size_t vtx_data_size );

#endif
