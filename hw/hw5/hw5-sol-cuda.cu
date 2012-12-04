/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

 /// Homework 5
//
//   See hw5.cc for details.

#include "cuda-util.cu"
#include "hw5-sol.cuh"
#include <gp/cuda-util-kernel.h>

// Physical State Variables
//
__constant__ float3 *helix_position;
__constant__ float3 *helix_velocity;
__constant__ pQuat *helix_orientation;
__constant__ float3 *helix_omega;

// Scalar Constants (Placed in a struct for convenience.)
//
__constant__ Helix_Info hi;

__global__ void time_step();

__host__ cudaError_t
cuda_setup(struct cudaFuncAttributes *attr_helix)
{
  // Pass the device address to host code. (See gp/cuda-util-kernel.h ).
  CU_SYM(helix_position);
  CU_SYM(helix_velocity);
  CU_SYM(helix_orientation);
  CU_SYM(helix_omega);
  CU_SYM(hi);

  // Return attributes of CUDA functions. The code needs the
  // maximum number of threads.
  cudaError_t e1 = cudaFuncGetAttributes(attr_helix,time_step);
  if ( e1 ) return e1;
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

  pQuat c_orientation = helix_orientation[tid];
  float3 c_position = helix_position[tid];

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
      pQuat r_orientation = helix_orientation[tid+1];
      float3 r_position = helix_position[tid+1];
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
      pQuat l_orientation = helix_orientation[tid-1];
      float3 l_position = helix_position[tid-1];
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

  /// SOLUTION - Problem 1
  if ( hi.opt_interpen_method == 1 )
    {
      const int min_idx_dist = 0.999f + hi.wire_radius / hi.helix_seg_hlength;
      const float four_wire_radius_sq = 4 * hi.wire_radius * hi.wire_radius;
      for ( int j=0; j<hi.phys_helix_segments; j++ )
        {
          float3 b_position = helix_position[j];
          pVect ab = mv(c_position,b_position);
          if ( abs(tid-j) < min_idx_dist ) continue;
          if ( mag_sq(ab) < four_wire_radius_sq )
            {
              pNorm dist = mn(ab);
              const float pen = 2 * hi.wire_radius - dist.magnitude;
              force -= pen * hi.opt_spring_constant * dist;
            }
        }
    }

  float3 velocity = helix_velocity[tid];
  velocity *= 0.9999f;
  float3 omega = helix_omega[tid];
  omega *= 0.9999f;
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

 /// SOLUTION -- Problem 2
//
__global__ void
time_step_intersect()
{
  // Find intersections of one helix segment with some other segments.
  // Each block handles one "a" segment, the threads in the block
  //  check for intersection with other segments.
  // The kernel is launched with one block per segment.

  int a_idx = blockIdx.x;
  int b_idx_start = threadIdx.x;

  if ( a_idx == 0 ) return;

  float3 a_position = helix_position[a_idx];

  const int min_idx_dist = 0.999f + hi.wire_radius / hi.helix_seg_hlength;
  const float four_wire_radius_sq = 4 * hi.wire_radius * hi.wire_radius;
  __shared__ pVect force;

  if ( threadIdx.x == 0 ) force = mv(0,0,0);

  // Wait for thread 0 to initialize force.
  __syncthreads();

  for ( int j=b_idx_start; j<hi.phys_helix_segments; j += blockDim.x )
    {
      float3 b_position = helix_position[j];
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
      // a few other segments.
      //
      atomicAdd(&force.x,f.x);
      atomicAdd(&force.y,f.y);
      atomicAdd(&force.z,f.z);
      //
      // Optimization Note: Could acquire a lock and then update
      // all three components.
    }

  // Wait for all threads to finish.
  __syncthreads();

  // Leave it to thread 0 to update velocity.
  if ( threadIdx.x != 0 ) return;

  // Update velocity and write it.
  //
  float3 velocity = helix_velocity[a_idx];
  velocity -= hi.delta_t_mass_inv * force;
  if ( hi.opt_end_fixed && a_idx + 1 == hi.phys_helix_segments )
    velocity = mv(0,0,0);
  helix_velocity[a_idx] = velocity;
}

__host__ void
time_step_intersect_launch(int grid_size, int block_size)
{
  time_step_intersect<<<grid_size,block_size>>>();
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
  pQuat orientation = helix_orientation[tid];
  float3 omega = helix_omega[tid];
  pNorm axis = mn(omega);
  helix_orientation[tid] =
    quat_normalize
    ( quat_mult ( mq( axis, hi.delta_t * axis.magnitude ), orientation));

  // Return if at last segment and it is fixed. Note that even
  // if the segment's position is fixed, it can still rotate.
  //
  if ( hi.opt_end_fixed && tid + 1 == hi.phys_helix_segments ) return;

  // Update Velocity
  //
  float3 position = helix_position[tid];
  float3 velocity = helix_velocity[tid];
  helix_position[tid] = position + hi.delta_t * velocity;
}

__host__ void 
time_step_update_pos_launch
(int grid_size, int block_size)
{
  time_step_update_pos<<<grid_size,block_size>>>();
}
