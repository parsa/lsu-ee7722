
#include <gp/cuda-gpuinfo.h>

__host__ cudaError_t cuda_setup(GPU_Info *gpu_info);

__host__ void time_step_launch(int grid_size, int block_size);

 __host__ void time_step_intersect_launch
(int grid_size, int block_size, float4 *helix_position, float3 *helix_velocity);

__host__ void time_step_update_pos_launch
(int grid_size, int block_size);

struct Timing_Data {
  clock_t inter_time;
  int inter_count;
};

struct Helix_Info {
  bool opt_gravity;
  bool opt_test;
  bool opt_end_fixed;
  int opt_interpen_method;
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
