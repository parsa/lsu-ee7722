
#include <gp/cuda-gpuinfo.h>

enum Shared_Memory_Option
{
  SMO_none,
  SMO_sync_experiment,
  SMO_one_iteration,
  SMO_multiple_iterations,
  SMO_ENUM_SIZE
};

const char* const smo_text[] = {"NONE","SYNC EXPER", "ONE ITER", "MULT ITERS" };

__host__ cudaError_t cuda_setup(GPU_Info *gpu_info);

__host__ void time_step_launch(int grid_size, int block_size);

 __host__ void time_step_intersect_launch
(int grid_size, int block_size, int version, int dynamic_sm_amt);

__host__ void time_step_update_pos_launch
(int grid_size, int block_size);

struct Timing_Data {
  clock_t intersect_time;
  int intersect_count;
};

struct Helix_Info {
  bool opt_gravity;
  bool opt_tryout1;
  bool opt_tryout2;
  bool opt_end_fixed;
  float opt_spring_constant;
  Shared_Memory_Option opt_sm_option;

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

