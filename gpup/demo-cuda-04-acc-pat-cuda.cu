/// LSU EE 4702-1 (Fall 2016), GPU Programming
//

#if 0
 /// CUDA Demo 04
 //
 //  This code demonstrates different methods of all-to-all access in
 //  CUDA, such as the accesses to array in the code below:
 //
     for ( int x=0; x<n; x++ )
       for ( int y=0; y<n; y++ )
         sum += array[ x ] * array[ y ];
 //
 ///  See routines time_step_intersect_1 and time_step_intersect_2 in
 //  demo-cuda-04-acc-pat-cuda.cu. Instead of array, this code
 //  accesses helix_position.
#endif

#include "cuda-coord.cu"
#include "demo-cuda-04-acc-pat.cuh"
#include <gp/cuda-util-kernel.h>

// Physical State Variables
//
__constant__ float4 *helix_position;
__constant__ float3 *helix_velocity;     // Note: float4 would be faster.
__constant__ float4 *helix_orientation;
__constant__ float3 *helix_omega;        // Note: float4 would be faster.

__device__ Timing_Data timing_data;   // Measure execution time of intersect.
__constant__ Helix_Info hi;  // Scalar Constants

__global__ void
time_step_intersect_1()
{
  // Find intersections of one helix segment with some other
  // segments. Each block handles several "a" segments, the threads in
  // the block check for intersection with other segments, called "b"
  // segments.

  __shared__ clock_t time_start;
  if ( !threadIdx.x ) time_start = clock64();


  // Note: The size of the helix_position array is hi.phys_helix_segments.

  // Compute how many "a" elements will be handled by each block.
  //
  const int a_per_block = hi.phys_helix_segments / gridDim.x;

  // Compute how many threads handle each "a" element.
  //
  const int thd_per_a = blockDim.x / a_per_block;

  // Compute the smallest "a" element index that this block will handle.
  //
  const int a_idx_block = blockIdx.x * a_per_block;

  /// Assignment of "a" and "b" Values to Threads
  //
  //  The table below is an example of how this routine
  //  assigns "a" and "b" elements to threads.  The table
  //  is based upon the following values:
  //
  //    blockDim = 8,     blockIdx = 4,   hi.phys_helix_segments = 1024
  //    a_per_block = 4,  thd_per_a = 2,  a_idx_block = 16
  //
  // tIx     al   a      b ---> 
  //   0     0    16     0  2  4 ... 1022
  //   1     1    17     0  2  4 ... 1022
  //   2     2    18     0  2  4 ... 1022
  //   3     3    19     0  2  4 ... 1022
  //   4     0    16     1  3  5 ... 1023
  //   5     1    17     1  3  5 ... 1023
  //   6     2    18     1  3  5 ... 1023
  //   7     3    19     1  3  5 ... 1023
  //   |     |     |     |
  //   |     |     |     |
  //   |     |     |     |--------> b_idx_start
  //   |     |     |--------------> a_idx
  //   |     |--------------------> a_local_idx
  //   |--------------------------> threadIdx.x

  // Compute a_idx and b_idx_start to realize ordering above.
  //
  const int a_local_idx = threadIdx.x % a_per_block;
  const int a_idx = a_idx_block + a_local_idx;
  const int b_idx_start = threadIdx.x / a_per_block;


  const float3 a_position = m3(helix_position[a_idx]);
  const int min_idx_dist = 0.999f + hi.wire_radius / hi.helix_seg_hlength;
  const float four_wire_radius_sq = 4 * hi.wire_radius * hi.wire_radius;

  // Declare dynamically allocated shared memory. Will be split
  // between array for forces, force, and position cache, pos_cache.
  //
  extern __shared__ float3 shared[];

  pVect* const force = shared;
  if ( threadIdx.x < a_per_block ) force[threadIdx.x] = mv(0,0,0);

  __syncthreads();


  float3* const pos_cache = &shared[blockDim.x];

  for ( int j=b_idx_start; j<hi.phys_helix_segments; j += thd_per_a )
    {
      if ( hi.opt_use_shared )
        {
          __syncthreads();
          if ( threadIdx.x < thd_per_a )
            pos_cache[threadIdx.x] =
              m3(helix_position[ j - b_idx_start + threadIdx.x ] );
          __syncthreads();
        }

      float3 b_position = 
        hi.opt_use_shared ? pos_cache[b_idx_start] : m3(helix_position[j]);

      pVect ab = mv(a_position,b_position);

      // Skip if segment is too close.
      if ( abs(a_idx-j) < min_idx_dist ) continue;

      // Skip if no chance of intersection.
      if ( mag_sq(ab) >= four_wire_radius_sq ) continue;

      // Compute intersection force based on bounding sphere, an
      // admittedly crude approximation.
      //
      pNorm dist = mn(ab);
      const float pen = 2 * hi.wire_radius - dist.magnitude;
      float3 f = pen * hi.opt_spring_constant * dist;

      // Add force to shared variable. This is time consuming
      // (especially in CC 3.x and older GPUs) but done
      // infrequently. (A segment can normally only intersect a a few
      // other segments.)
      //
      atomicAdd(&force[a_local_idx].x,f.x);
      atomicAdd(&force[a_local_idx].y,f.y);
      atomicAdd(&force[a_local_idx].z,f.z);
      //
      // Optimization Note: Could acquire a lock and then update
      // all three components.
    }

  // Wait for all threads to finish.
  __syncthreads();

  // Leave it to thread 0 to update velocity.
  if ( threadIdx.x >= a_per_block ) return;

  // Update velocity and write it.
  //
  float3 velocity = helix_velocity[a_idx];
  velocity -= hi.delta_t_mass_inv * force[a_local_idx];
  if ( hi.opt_end_fixed && a_idx + 1 == hi.phys_helix_segments )
    velocity = mv(0,0,0);
  helix_velocity[a_idx] = velocity;

  if ( !threadIdx.x && !blockIdx.x )
    {
      timing_data.inter_time += clock64() - time_start;
      timing_data.inter_count++;
    }
}

__global__ void
time_step_intersect_2()
{
  // Find intersections of one helix segment with some other
  // segments. Each block handles several "a" segments, the threads in the
  // block check for intersection with other segments, called "b"
  // segments.

  __shared__ clock_t time_start;
  if ( !threadIdx.x ) time_start = clock64();

  // Note: The size of the helix_position array is hi.phys_helix_segments.

  // Compute how many "a" elements will be handled by each block.
  //
  const int a_per_block = hi.phys_helix_segments / gridDim.x;

  // Compute how many threads handle each "a" element.
  //
  const int thd_per_a = blockDim.x / a_per_block;

  // Compute the smallest "a" element index that this block will handle.
  //
  const int a_idx_block = blockIdx.x * a_per_block;

  /// Assignment of "a" and "b" Values to Threads
  //
  //  The table below is an example of how this routine
  //  assigns "a" and "b" elements to threads.  The table
  //  is based upon the following values:
  //
  //    blockDim = 8,     blockIdx = 4,   hi.phys_helix_segments = 1024
  //    a_per_block = 4,  thd_per_a = 2,  a_idx_block = 16
  //
  // tIx     al   a      b ---> 
  //   0     0    16     0  2  4 ...
  //   1     0    16     1  3  5
  //   2     1    17     0  2  4
  //   3     1    17     1  3  5
  //   4     2    18     0  2  4
  //   5     2    18     1  3  5
  //   6     3    19     0  2  4
  //   7     3    19     1  3  5 
  //   |     |     |     |
  //   |     |     |     |
  //   |     |     |     |--------> b_idx_start
  //   |     |     |--------------> a_idx
  //   |     |--------------------> a_local_idx
  //   |--------------------------> threadIdx.x

  // Compute a_idx and b_idx_start to realize ordering above.
  //
  const int a_local_idx = threadIdx.x / thd_per_a;
  const int a_idx = a_idx_block + a_local_idx;
  const int b_idx_start = threadIdx.x % thd_per_a;

  const float3 a_position = m3(helix_position[a_idx]);
  const int min_idx_dist = 0.999f + hi.wire_radius / hi.helix_seg_hlength;
  const float four_wire_radius_sq = 4 * hi.wire_radius * hi.wire_radius;

  // Declare dynamically allocated shared memory. Will be split
  // between array for forces, force, and position cache, pos_cache.
  //
  extern __shared__ float3 shared[];

  pVect* const force = shared;
  if ( threadIdx.x < a_per_block ) force[threadIdx.x] = mv(0,0,0);

  // Wait for thread 0 to initialize force.
  __syncthreads();


  float3* const pos_cache = &shared[blockDim.x];

  for ( int j=b_idx_start; j<hi.phys_helix_segments; j += thd_per_a )
    {
      if ( hi.opt_use_shared )
        {
          __syncthreads();
          if ( threadIdx.x < thd_per_a )
            pos_cache[threadIdx.x] = m3(helix_position[j]);
          __syncthreads();
        }
      float3 b_position = 
        hi.opt_use_shared ? pos_cache[b_idx_start] : m3(helix_position[j]);

      pVect ab = mv(a_position,b_position);

      // Skip if segment is too close.
      if ( abs(a_idx-j) < min_idx_dist ) continue;

      // Skip if no chance of intersection.
      if ( mag_sq(ab) >= four_wire_radius_sq ) continue;

      // Compute intersection force based on bounding sphere, an
      // admittedly crude approximation.
      //
      pNorm dist = mn(ab);
      const float pen = 2 * hi.wire_radius - dist.magnitude;
      float3 f = pen * hi.opt_spring_constant * dist;

      // Add force to shared variable. This is time consuming but
      // done infrequently. (A segment can normally only intersect a
      // a few other segments.)
      //
      atomicAdd(&force[a_local_idx].x,f.x);
      atomicAdd(&force[a_local_idx].y,f.y);
      atomicAdd(&force[a_local_idx].z,f.z);
      //
      // Optimization Note: Could acquire a lock and then update
      // all three components.
    }

  // Wait for all threads to finish.
  __syncthreads();

  // Leave it to thread 0 to update velocity.
  if ( threadIdx.x >= a_per_block ) return;

  {
    // Re-compute a_idx so that first a_per_block threads can write
    // velocities.

    const int a_local_idx = threadIdx.x;
    const int a_idx = a_idx_block + a_local_idx;

    // Update velocity and write it.
    //
    float3 velocity = helix_velocity[a_idx];
    velocity -= hi.delta_t_mass_inv * force[a_local_idx];
    if ( hi.opt_end_fixed && a_idx + 1 == hi.phys_helix_segments )
      velocity = mv(0,0,0);
    helix_velocity[a_idx] = velocity;

    if ( !threadIdx.x && !blockIdx.x )
      {
        timing_data.inter_time += clock64() - time_start;
        timing_data.inter_count++;
      }
  }
}


__global__ void time_step();
__global__ void time_step_intersect_1();
__global__ void time_step_intersect_2();
__global__ void time_step_update_pos();


__host__ cudaError_t
cuda_setup(GPU_Info *gpu_info)
{
  // Pass the device address to host code. (See gp/cuda-util-kernel.h ).
  CU_SYM(helix_position);
  CU_SYM(helix_velocity);
  CU_SYM(helix_orientation);
  CU_SYM(helix_omega);
  CU_SYM(hi);
  CU_SYM(timing_data);

  // Return attributes of CUDA functions. The code needs the
  // maximum number of threads.

  cudaError_t e1 = cudaSuccess;

  /// WARNING: Code in render expects time_step_intersect_1 and
  /// time_step_intersect_2 to be 2nd and 3rd (at index 1 and 2) of
  /// gpu_info::ki.
  gpu_info->GET_INFO(time_step);
  gpu_info->GET_INFO(time_step_intersect_1);
  gpu_info->GET_INFO(time_step_intersect_2);
  gpu_info->GET_INFO(time_step_update_pos);

  return e1;
}

__host__ void time_step_launch(int grid_size, int block_size)
{
  time_step<<<grid_size,block_size>>>();
}

__device__ void
helix_apply_force_at
(float3 position, float3& force, float3& torque,
 float3 force_pos, pVect dir, float magnitude);


__global__ void
time_step()
{
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  // Use tid for helix segment number.

  if ( tid + 1 > hi.phys_helix_segments ) return;

  // The position of segment 0 is fixed, so don't evolve it.
  if ( tid == 0 ) return;

  pVect vZero = mv(0,0,0);
  pVect gravity_force = hi.helix_seg_mass_inv * hi.gravity_accel;

  pQuat c_orientation = cq(helix_orientation[tid]);
  float3 c_position = m3(helix_position[tid]);

  pMatrix3x3 c_rot;
  // Initialize c_rot to a rotation matrix based on quaternion c_orientation.
  pMatrix_set_rotation(c_rot,c_orientation);

  float3 c_u = c_rot * mv(0,0,1);  // mv: Make Vector.
  float3 c_v = c_rot * mv(0,1,0);
  float3 c_ctr_to_right_dir = c_rot * mv(1,0,0);
  pVect c_ctr_to_right = hi.helix_seg_hlength * c_ctr_to_right_dir;
  float3 c_pos_right = c_position + c_ctr_to_right;
  float3 c_pos_left = c_position - c_ctr_to_right;

  float3 force = hi.opt_gravity ? gravity_force : vZero;
  float3 torque = vZero;

  const int pieces = 3;
  const float delta_theta = 2 * M_PI / pieces;

  /// Compute forces due to right neighbor.
  //
  if ( tid + 1 < hi.phys_helix_segments )
    {
      pQuat r_orientation = cq(helix_orientation[tid+1]);
      float3 r_position = m3(helix_position[tid+1]);
      pMatrix3x3 r_rot;
      pMatrix_set_rotation(r_rot,r_orientation);
      float3 r_u = r_rot * mv(0,0,1);
      float3 r_v = r_rot * mv(0,1,0);
      float3 r_ctr_to_right_dir = r_rot * mv(1,0,0);
      pVect r_ctr_to_right = hi.helix_seg_hlength * r_ctr_to_right_dir;
      float3 r_pos_left = r_position - r_ctr_to_right;

      pQuat cn_rot_q = c_orientation * hi.helix_rn_trans;
      pMatrix3x3 cn_rot;
      pMatrix_set_rotation(cn_rot,cn_rot_q);
      pVect n_ru = cn_rot * mv(0,0,1);
      pVect n_rv = cn_rot * mv(0,1,0);

      for ( int j=0; j<pieces; j++ )
        {
          const float theta = delta_theta * j;
          pCoor c_pt = c_pos_right + cosf(theta) * n_ru + sinf(theta) * n_rv;
          pCoor r_pt = r_pos_left + cosf(theta) * r_u + sinf(theta) * r_v;
          pNorm dist = mn(c_pt,r_pt);
          const float force_mag = dist.magnitude * hi.opt_spring_constant;
          helix_apply_force_at(c_position,force,torque,c_pt,dist.v,force_mag);
        }
    }

  /// Compute forces due to left neighbor.
  //
  if ( tid > 0 )
    {
      pQuat l_orientation = cq(helix_orientation[tid-1]);
      float3 l_position = m3(helix_position[tid-1]);
      pMatrix3x3 l_rot;
      pMatrix_set_rotation(l_rot,l_orientation);
      float3 l_u = l_rot * mv(0,0,1);
      float3 l_v = l_rot * mv(0,1,0);
      float3 l_ctr_to_right_dir = l_rot * mv(1,0,0);
      pVect l_ctr_to_right = hi.helix_seg_hlength * l_ctr_to_right_dir;
      float3 l_pos_right = l_position + l_ctr_to_right;

      pQuat ln_rot_q = l_orientation * hi.helix_rn_trans;
      pMatrix3x3 ln_rot;
      pMatrix_set_rotation(ln_rot,ln_rot_q);
      pVect n_cu = ln_rot * mv(0,0,1);
      pVect n_cv = ln_rot * mv(0,1,0);

      for ( int j=0; j<pieces; j++ )
        {
          const float theta = delta_theta * j;
          pCoor c_pt = c_pos_left + cosf(theta) * c_u + sinf(theta) * c_v;
          pCoor l_pt = l_pos_right + cosf(theta) * n_cu + sinf(theta) * n_cv;
          pNorm dist = mn(c_pt,l_pt);
          const float force_mag = dist.magnitude * hi.opt_spring_constant;
          helix_apply_force_at(c_position,force,torque,c_pt,dist.v,force_mag);
        }
    }

  float3 velocity = helix_velocity[tid];
  velocity *= 0.99999f;
  float3 omega = helix_omega[tid];
  omega *= 0.99999f;
  velocity += hi.delta_t_mass_inv * force;
  const float torque_axial_mag = dot( torque, c_ctr_to_right_dir );
  pVect torque_axial = torque_axial_mag * c_ctr_to_right_dir;
  pVect do_axial = hi.delta_t_ma_axis * torque_axial;
  pVect torque_other = torque - torque_axial;
  pVect do_other = hi.delta_t_ma_perp_axis * torque_other;
  omega += do_axial + do_other;

  // Update velocity and omega. Don't update position or orientation
  // because we don't want threads in this kernel to accidentally read
  // the updated values.

  helix_omega[tid] = omega;
  helix_velocity[tid] = velocity;
}


__device__ void
helix_apply_force_at
(float3 position, float3& force, float3& torque,
 float3 force_pos, pVect dir, float magnitude)
{
  // Update force and torque of segment for a force acting on FORCE_POS
  // pointing in direction DIR of magnitude MAGNITUDE.
  //
  force += magnitude * dir;
  pVect arm = mv(position,force_pos);
  pVect axis = cross( arm, dir );
  pVect amt = magnitude * axis;
  torque += amt;
}



__host__ void
time_step_intersect_launch
(int grid_size, int block_size, int version, int dynamic_sm_amt)
{
  switch ( version ) {
    case 1: time_step_intersect_1<<<grid_size,block_size,dynamic_sm_amt>>>();
    case 2: time_step_intersect_2<<<grid_size,block_size,dynamic_sm_amt>>>();
  }
}

__global__ void
time_step_update_pos()
{
  // Update position and orientation of spring segments.

  // Use tid for helix segment number.
  int tid = threadIdx.x + blockIdx.x * blockDim.x;

  // Skip out-of-range segments.
  if ( tid >= hi.phys_helix_segments ) return;
  if ( tid == 0 ) return;

  // Update Orientation
  //
  pQuat orientation = cq(helix_orientation[tid]);
  float3 omega = helix_omega[tid];
  pNorm axis = mn(omega);
  helix_orientation[tid] =
    c4( quat_normalize
    ( quat_mult ( mq( axis, hi.delta_t * axis.magnitude ), orientation)));

  // Return if at last segment and it is fixed. Note that even
  // if the segment's position is fixed, it can still rotate.
  //
  if ( hi.opt_end_fixed && tid + 1 == hi.phys_helix_segments ) return;

  // Update Velocity
  //
  float3 position = m3(helix_position[tid]);
  float3 velocity = helix_velocity[tid];
  helix_position[tid] = m4(position + hi.delta_t * velocity,1);
}

__host__ void
time_step_update_pos_launch
(int grid_size, int block_size)
{
  time_step_update_pos<<<grid_size,block_size>>>();
}
