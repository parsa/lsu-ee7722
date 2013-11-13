/// LSU EE 4702-1 (Fall 2013), GPU Programming
//
 /// Homework 3
 //
 /// This file can be modified, but few if any changes will be needed.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2013/hw03.pdf


// Info about a specific kernel.
//
struct Kernel_Info {
  void (*func_ptr)();           // Pointer to kernel function.
  char *name;                   // ASCII version of kernel name.
  cudaFuncAttributes cfa;       // Kernel attributes reported by CUDA.
};

// Info about GPU and each kernel.
//
struct GPU_Info {
  double bw_Bps;
  static const int num_kernels_max = 10;
  int num_kernels;
  Kernel_Info ki[num_kernels_max];
};

__host__ cudaError_t cuda_setup(GPU_Info *gpu_info);
__host__ void
launch_time_step_gpu_base_part_1
(int grid_size, int block_size, float delta_t);
__host__ void
launch_time_step_gpu_base_part_2
(int grid_size, int block_size, float delta_t);
__host__ void
launch_time_step_gpu_sol_part_1
(int grid_size, int block_size, float delta_t);
__host__ void
launch_time_step_gpu_sol_part_2
(int grid_size, int block_size, float delta_t);
__host__ void launch_data_pack(int grid_size, int block_size);
__host__ void launch_data_unpack(int grid_size, int block_size);


// Object Holding Ball State
//
class Ball {
public:
  pCoor position;
  pVect velocity;
  float mass, mass_inv;
  float radius;
  bool contact;
  char pad[7];
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

// Infrequently changing items accessed by both CPU and GPU code.
struct CPU_GPU_Common
{
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;

  Ball *d_balls;
  float4 *d_pos;

  bool opt_test1; // For ad-hoc use.
  bool opt_test2; // For ad-hoc use.

  bool opt_head_lock, opt_tail_lock;
  float opt_spring_constant;
  float opt_air_resistance;
  float distance_relaxed;
  int chain_length;
  pVect gravity_accel;
};
