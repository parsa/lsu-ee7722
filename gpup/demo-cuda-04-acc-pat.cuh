

#include <gp/cuda-gpuinfo.h>

__host__ cudaError_t cuda_setup(GPU_Info *gpu_info);

__host__ void cuda_array_addrs_set
(float4 *h_pos, float3 *h_vel, float4 *h_ori, float3 *h_om);

__host__ void time_step_launch(int grid_size, int block_size);

 __host__ void time_step_intersect_launch
(int grid_size, int block_size, int version, int dynamic_sm_amt);

__host__ void time_step_update_pos_launch
(int grid_size, int block_size);

struct Timing_Data {
  clock_t inter_time;
  int inter_count;
};

struct Helix_Info {
  bool opt_gravity;
  bool opt_tryout1;
  bool opt_tryout2;
  bool opt_end_fixed;
  int opt_use_shared;
  float opt_spring_constant;

  float delta_t;
  float delta_t_mass_inv;
  float delta_t_ma_axis;
  float delta_t_ma_perp_axis;

  int phys_helix_segments;
  float wire_radius;
  float helix_seg_hlength;
  float helix_seg_mass_inv;
  pVect gravity_accel;
  pQuat helix_rn_trans;
};
