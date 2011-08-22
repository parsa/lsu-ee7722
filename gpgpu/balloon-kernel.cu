/// LSU EE 4702-1 (Fall 2011), GPU Programming
//
 /// Balloon Simulation

// $Id:$

 /// Purpose
//
//   Demonstrate use of gpu for physics.


#include "balloon.cuh"

__constant__ CUDA_Tri_Strc* tri_strc;
__constant__ CUDA_Tri_Strc_X tri_strc_x;
__constant__ CUDA_Vtx_Strc* vtx_strc;
__constant__ CUDA_Vtx_Strc_X vtx_strc_x;
__constant__ CUDA_Tri_Data* tri_data;
__constant__ CUDA_Vtx_Data *vtx_data_0, *vtx_data_1;
__constant__ CUDA_Vtx_Data_X vtx_data_x0, vtx_data_x1;
__constant__ float *tower_volumes[2];
__constant__ float3* centroid_parts;

texture<float4> vtx_data_pos_tex;
texture<float4> tri_data_tex;

__constant__ CUDA_Tri_Work_Strc* tri_work_strc;
__constant__ CUDA_Tri_Work_Strc_X tri_work_strc_x;
__constant__ int tri_work_per_vtx;
__constant__ int tri_work_per_vtx_lg;

__constant__ float volume_cpu;
__constant__ int tri_count;
__constant__ int point_count;
__constant__ int tethered_idx;
__constant__ bool opt_gravity;

__constant__ float spring_constant;
__constant__ float damping_v;
__constant__ float pressure_factor_coeff;
__constant__ float gas_m_over_temp;

__constant__ float air_resistance;
__constant__ float gas_mass_per_vertex;
__constant__ float air_particle_mass;
__constant__ float gravity_mag;

__constant__ float delta_t;
__constant__ float rep_constant;
__constant__ float point_mass;
__constant__ float point_mass_inv;

__constant__ float platform_xmin;
__constant__ float platform_xmax;
__constant__ float platform_zmin;
__constant__ float platform_zmax;


__device__ float4 make_float4(float3 f3, float f)
{
  return make_float4(f3.x,f3.y,f3.z,f);
}

__device__ float3 make_float3(float4 f4){return make_float3(f4.x,f4.y,f4.z);}

__device__ int
div_p2_ceil(int num, int den_lg)
{
  const int quot = num >> den_lg;
  return quot << den_lg == num ? quot : quot + 1;
}

__device__ float3
vec_add(float3 a, float3 b){return make_float3(a.x+b.x,a.y+b.y,a.z+b.z);}
__device__ float3
vec_add3(float3 a, float3 b, float3 c) { return vec_add(a,vec_add(b,c)); }
__device__ void vec_addto(float3& a, float3 b)
{
  float3 sum = vec_add(a,b);
  a = sum;
}

__device__ float3
vec_sub(float3 a, float3 b){return make_float3(a.x-b.x, a.y-b.y, a.z-b.z);}

__device__ float3
vec_scale(float s, float3 a) {return make_float3(s*a.x,s*a.y,s*a.z);}

__device__ float
dot(float3 a, float3 b){return a.x*b.x + a.y*b.y + a.z*b.z;}

__device__ float length(float3 a) {return sqrtf(dot(a,a));}

__device__ float3
normalize(float3 a) { return vec_scale(rsqrtf(dot(a,a)),a); }

__device__ float3
cross(float3 a, float3 b)
{
  return make_float3
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}

__device__ float3
cross3(float3 a, float3 b, float3 c)
{
  float3 ab = vec_sub(a,b);
  float3 cb = vec_sub(c,b);
  return cross(ab,cb);
}

 ///
 /// Reduction Routine
 ///
 // Computes a sum of floats over all threads in the block.
 //
__device__ float
reduce(int block_lg, float *shared_array, float my_value, bool all)
{
  const int tid = threadIdx.x;
  const int block_lg_h = block_lg >> 1;
  const int block_lg_l = block_lg - block_lg_h;
  const int lower_size = 1 << block_lg_l;

  float vol_sum = shared_array[tid] = my_value;
  __syncthreads();

  // Round 1
  //
  if ( tid < lower_size )
    {
      // Note: CUDA is not good at unrolling loops or optimizing once
      // unrolled. For that matter, it's not good at scheduling
      // either. (CUDA 2.1) That's why the two loops below are hand
      // unrolled. Thankfully CUDA does optimize out the if
      // statements.
#define ITER(i) vol_sum += shared_array[ (i << block_lg_l ) + tid ]
#define ITER2(i) { ITER(i); ITER(i+1); }
#define ITER4(i) { ITER2(i); ITER2(i+2); }
#define ITER8(i) { ITER4(i); ITER4(i+4); }
      if ( block_lg_h >= 1 ) ITER(1);
      if ( block_lg_h >= 2 ) ITER2(2);
      if ( block_lg_h >= 3 ) ITER4(4);
      if ( block_lg_h >= 4 ) ITER8(8);
      if ( block_lg_h >= 5 ) { ITER8(16); ITER8(24); }
#undef ITER

      shared_array[tid] = vol_sum;
    }

  // Round 2
  //
  __syncthreads();

  if ( tid == 0 )
    {
#define ITER(i) vol_sum += shared_array[i];
      if ( block_lg_l >= 1 ) ITER(1);
      if ( block_lg_l >= 2 ) ITER2(2);
      if ( block_lg_l >= 3 ) ITER4(4);
      if ( block_lg_l >= 4 ) ITER8(8);
      if ( block_lg_l >= 5 ) { ITER8(16); ITER8(24); }
#undef ITER
    }

  if ( !all ) return vol_sum;
  if ( tid == 0 ) shared_array[0] = vol_sum;
  __syncthreads();
  return shared_array[0];
}


 ///
 /// Texture Access Convenience Functions
 ///

// These functions access data via the texture cache and place them in
// appropriate data structures. (Texture cache fetches can not return
// structures and cannot return vectors of length 3.)

__device__ float3 vtx_data_pos(int idx)
{
  return make_float3(tex1Dfetch(vtx_data_pos_tex, idx));
}

__device__ float3 tri_data_surface_normal(int idx)
{
  return make_float3(tex1Dfetch(tri_data_tex, idx << 2));
}

__device__ float3 tri_data_force(int idx, int member)
{
  return make_float3(tex1Dfetch(tri_data_tex, (idx<<2)+1+member));
}


 ///
 /// Compute Repulsion Force
 ///
//
// Used by one- and two-pass algorithms.
//
__device__ float3
repforce_compute(float3 p_pos, int po_idx)
{
  const float3 po_pos = vtx_data_pos(po_idx);
  const float3 p_to_q = vec_sub(p_pos,po_pos);
  const float mag_sq = dot(p_to_q,p_to_q);
  const float dist_sq_inv = rep_constant / max(0.001,mag_sq);
  const float3 p_to_q_n = normalize(p_to_q);
  return vec_scale(dist_sq_inv, p_to_q_n);
}


///
/// Two-Pass Code
///

__global__ void pass_triangles();
__global__ void pass_vertices(int write_side);


 __host__ void
pass_triangles_launch
 (dim3 dg, dim3 db, int write_size,
  CUDA_Vtx_Data_X *vtx_data_in,
  CUDA_Vtx_Data *vtx_data, size_t vtx_data_size)
 {
   size_t offset;
   cudaBindTexture(&offset, vtx_data_pos_tex, vtx_data_in->pos, vtx_data_size);
   pass_triangles<<<dg,db>>>();
 }

__global__ void
pass_triangles()
{
  const int tid = threadIdx.x;
  const int ti = blockIdx.x * blockDim.x + threadIdx.x;
  __shared__ float volumes[CUDA_TRI_BLOCK_SIZE];
  if ( ti >= tri_count ) volumes[tid] = 0;
  __syncthreads();
  if ( ti >= tri_count ) return;

  const CUDA_Tri_Strc_X_a tsa = tri_strc_x.a[ti];
  const CUDA_Tri_Strc_X_b tsb = tri_strc_x.b[ti];

  const float3 ppos = vtx_data_pos(tsa.pi);
  const float3 qpos = vtx_data_pos(tsa.qi);
  const float3 rpos = vtx_data_pos(tsa.ri);

  const float3 center = vec_scale(1.0/3.0, vec_add3(ppos,qpos,rpos));
  const float3 pqr_cross = cross3(qpos,ppos,rpos);

  const float triangle_area_x2 = length(pqr_cross);
  const float tower_volume_x2 = -pqr_cross.y * center.y;

  float3 force_p = repforce_compute(ppos,tsa.pi_opp);
  float3 force_q = repforce_compute(qpos,tsb.qi_opp);
  float3 force_r = repforce_compute(rpos,tsb.ri_opp);

  const float3 p_to_c = vec_sub(center,ppos);
  const float3 q_to_c = vec_sub(center,qpos);
  const float3 r_to_c = vec_sub(center,rpos);

  const float perimeter = length(p_to_c) + length(q_to_c) + length(r_to_c);

  const float length_relaxed = tri_strc_x.length_relaxed[ti];
  const float eff_length = max(0.0f, perimeter - length_relaxed );
  const float spring_force = eff_length * spring_constant;

  tri_data[ti].surface_normal = make_float4(pqr_cross,0);
  tri_data[ti].force_p =
    make_float4(vec_add(force_p, vec_scale(spring_force, p_to_c)),0);
  tri_data[ti].force_q =
    make_float4(vec_add(force_q, vec_scale(spring_force, q_to_c)),0);
  tri_data[ti].force_r = 
    make_float4(vec_add(force_r, vec_scale(spring_force, r_to_c)),0);

  const float vol_sum =
    reduce(CUDA_TRI_BLOCK_LG,volumes,tower_volume_x2 * 0.5f,false);
  if ( threadIdx.x == 0 ) tower_volumes[0][ blockIdx.x ] = vol_sum;
}

__host__ void
pass_vertices_launch
(dim3 dg, dim3 db, int write_side, CUDA_Tri_Data *tri_data, size_t tri_data_size)
{
  size_t offset;
  cudaBindTexture(&offset, tri_data_tex, tri_data, tri_data_size);
  pass_vertices<<<dg,db>>>(write_side);
  cudaUnbindTexture(vtx_data_pos_tex);
  cudaUnbindTexture(tri_data_tex);
}

__global__ void
pass_vertices(int write_side)
{
  const int tid = threadIdx.x;
  const int vi = blockIdx.x * blockDim.x + threadIdx.x;

  __shared__ float volumes[CUDA_VTX_BLOCK_SIZE];

  const int grid_dim_tri = div_p2_ceil(tri_count,CUDA_TRI_BLOCK_LG);
  const int vol_per_thread = div_p2_ceil(grid_dim_tri,CUDA_VTX_BLOCK_LG);
  float my_vol = 0;
  for ( int i=0; i<vol_per_thread; i++ )
    my_vol += tower_volumes[0][tid + ( i << CUDA_VTX_BLOCK_LG ) ];

  const float volume = reduce(CUDA_VTX_BLOCK_LG,volumes,my_vol,true);
  if ( vi >= point_count ) return;

  const float friction_coefficient = .04;
  const float bounce_factor = 0.0;
  const float mass = 1.0;

  const float3 gravity = make_float3(0.0,-gravity_mag,0.0);

  CUDA_Vtx_Data_X vtx_data_r = write_side ? vtx_data_x0 : vtx_data_x1;
  const float3 vel = make_float3(vtx_data_r.vel[vi]);
  const float3 pos = make_float3(vtx_data_r.pos[vi]);

  CUDA_Vtx_Strc_X_a vsa = vtx_strc_x.a[vi];
  CUDA_Vtx_Strc_X_b vsb = vtx_strc_x.b[vi];
  const int tri_idx_base = vtx_strc_x.tri_idx_base[vi];
  CUDA_Vtx_Strc vs;
  vs.n0=vsa.n0; vs.n1=vsa.n1; vs.n2=vsa.n2; vs.n3=vsa.n3;
  vs.n4=vsb.n4; vs.n5=vsb.n5; vs.n6=vsb.n6; vs.n7=vsb.n7;

  float3 force_spring = make_float3(0.0,0.0,0.0);
  float3 surface_normal_sum = make_float3(0.0,0.0,0.0);

#define TRI_BODY(i)                                                           \
  { const int idx_packed = vs.n##i;                                           \
    if ( idx_packed )                                                         \
      {                                                                       \
        const int idx_base = tri_idx_base + ( idx_packed >> 2 );              \
        const int idx_force = idx_packed & 0x3;                               \
        const float3 surface_normal_t = tri_data_surface_normal(idx_base);    \
        vec_addto(surface_normal_sum, surface_normal_t);                      \
        const float3 force_x = tri_data_force(idx_base,idx_force);            \
        vec_addto(force_spring, force_x);                                     \
      }}

  TRI_BODY(0); TRI_BODY(1); TRI_BODY(2); TRI_BODY(3);
  TRI_BODY(4); TRI_BODY(5); TRI_BODY(6); TRI_BODY(7);
#undef TRI_BODY

  float3 surface_normal = vec_scale(1./6., surface_normal_sum);

  float pressure_factor = pressure_factor_coeff / fabs(volume);

  float pressure =
    opt_gravity
    ? pressure_factor * exp( - gas_m_over_temp * pos.y )
    : pressure_factor;
  float air_pressure =
    opt_gravity ? exp( - 0.2f * air_particle_mass * pos.y ) : 1.0;

  float3 force_pressure = vec_scale(air_pressure - pressure, surface_normal);

  float3 force = make_float3(0,0,0);
  vec_addto(force_spring, force_pressure);

  float3 vel_norm = normalize(vel);
  float facing_area = max(0.0f,-dot(vel_norm,surface_normal));
  float3 force_ar = vec_scale( - air_resistance * facing_area, vel);

  float3 gforce = vec_scale(point_mass * mass, gravity);
  vec_addto(force, gforce);

  vec_addto(force, force_ar);

  float3 force_ns = force;

  vec_addto(force, force_spring);

  float mass_wgas_inv_dt =
    delta_t / ( point_mass * mass + gas_mass_per_vertex );

  float3 delta_vns = vec_scale(mass_wgas_inv_dt, force_ns);
  float3 delta_vs = vec_scale(mass_wgas_inv_dt, force_spring);
  float3 delta_v = vec_add(delta_vns, delta_vs);

  float3 pos_next =
    vec_add(pos, vec_scale(delta_t, vec_add( vel,  vec_scale(0.5f,delta_v) )));

  float3 vel_next = vec_add3(vel,  vec_scale(damping_v, delta_vs), delta_vns);

  const bool platform_aligned =
    pos_next.x >= platform_xmin && pos_next.x <= platform_xmax
    && pos_next.z >= platform_zmin && pos_next.z <= platform_zmax;
  const bool above_to_below =  pos_next.y <= 0.0f && pos.y >= 0.0f;

  if ( platform_aligned && above_to_below )
    {
      pos_next.y = 0.0;
      vel_next.y = - bounce_factor * vel_next.y;
      const float f_y = min(0.0, gforce.y + force_spring.y );
      const float friction_force = -f_y * friction_coefficient;
      const float delta_v = friction_force * delta_t / ( point_mass * mass );
      const float3 xzvel = make_float3(vel_next.x,0,vel_next.z);
      if ( length(xzvel) <= delta_v ) {
        vel_next.x = 0.0;  vel_next.z = 0.0;
      }
      else
        vec_addto(vel_next, vec_scale( -delta_v, normalize(xzvel) ));
    }

  if ( false && vi == tethered_idx ) { vel_next = vel; pos_next = pos; }

  CUDA_Vtx_Data_X vtx_data_w = write_side ? vtx_data_x1 : vtx_data_x0;
  vtx_data_w.surface_normal[vi] = make_float4(surface_normal,0);
  vtx_data_w.vel[vi] = make_float4(vel_next,0);
  vtx_data_w.pos[vi] = make_float4(pos_next,1);
}



///
/// One-Pass Code
///

struct CUDA_Tri_Shared {
  // Note: make sure GCD(16,sizeof(this)/4) = 1, e.g., not a power of 2!
  float3 center;
  float spring_force;
  float3 surface_normal;
};

__global__ void pass_unified(int write_side);

__host__ void
pass_unified_launch
(dim3 dg, dim3 db, int write_side,
 CUDA_Vtx_Data_X *vtx_data_in, size_t vtx_data_size )
{
  size_t offset;
  cudaBindTexture(&offset, vtx_data_pos_tex, vtx_data_in->pos, vtx_data_size);
  pass_unified<<<dg,db>>>(write_side);
  cudaUnbindTexture(vtx_data_pos_tex);
}

__global__ void
pass_unified(int write_side)
{
  const int tid = threadIdx.x;
  const int vtx_bk_base = __mul24(blockIdx.x , blockDim.x);
  const int vi = vtx_bk_base + tid;
  const int work_idx_base = __mul24(tri_work_per_vtx, vtx_bk_base) + tid;
  const int block_lg = CUDA_VTX_BLOCK_LG;
  const int block_size = CUDA_VTX_BLOCK_SIZE;
  float* const tower_volumes_in = 
    write_side ? tower_volumes[0] : tower_volumes[1];
  float* const tower_volumes_out =
    write_side ? tower_volumes[1] : tower_volumes[0];

  __shared__ float volumes[block_size], volumes_read[block_size];
  __shared__ CUDA_Tri_Shared tri_shared[block_size];

  // This routine computes information (area, surface normal, and a
  // force) for several triangles and up to one vertex. Each vertex
  // uses information from up to eight triangles. The triangles that a
  // vertex needs are computed somewhere in the same block, but not
  // necessarily in the same thread, so vertices get the triangle
  // information they need through shared memory.

  ///
  /// Triangle Round
  ///
  // Note that several triangles are processed by a thread.

  float local_volume_x2 = 0;
  float3 force_spring = make_float3(0,0,0);
  float3 surface_normal_sum = make_float3(0,0,0);

  CUDA_Vtx_Data_X vtx_data_r = write_side ? vtx_data_x0 : vtx_data_x1;

  const float3 pos =
    vi < point_count ? vtx_data_pos(vi) : make_float3(0,0,0);

  for ( int i=0; i<tri_work_per_vtx; i++ )
    {
      const int widx = work_idx_base + ( i << block_lg );
      CUDA_Tri_Work_Strc_X_a tsa = tri_work_strc_x.a[widx];
      CUDA_Tri_Work_Strc_X_b tsb = tri_work_strc_x.b[widx];
      CUDA_Tri_Work_Strc_X_c tsc = tri_work_strc_x.c[widx];

      const int ts_pull_i =  tsa.pull_i;

      /// Compute information for a triangle (if there is one).
      //
      if ( tsa.pi != tsa.ri || tsa.pi != tsa.qi ) // Compiler Workaround
        {
          const float3 ppos = vtx_data_pos(tsa.pi);
          const float3 qpos = vtx_data_pos(tsa.qi);
          const float3 rpos = vtx_data_pos(tsa.ri);

          const float3 center = vec_scale(1.0/3.0, vec_add3(ppos,qpos,rpos));
          const float3 pqr_cross = cross3(qpos,ppos,rpos);
          const float tower_volume_x2 = -pqr_cross.y * center.y;

          const bool use_vol = ts_pull_i & 1;
          if ( use_vol ) local_volume_x2 += tower_volume_x2;

          const float3 p_to_c = vec_sub(center,ppos);
          const float3 q_to_c = vec_sub(center,qpos);
          const float3 r_to_c = vec_sub(center,rpos);
          const float perimeter = length(p_to_c)+length(q_to_c)+length(r_to_c);
          const float length_relaxed = tri_work_strc_x.length_relaxed[widx];
          const float eff_length = max(0.0f, perimeter - length_relaxed );
          const float spring_force = eff_length * spring_constant;

          tri_shared[tid].center = center;
          tri_shared[tid].surface_normal = pqr_cross;
          tri_shared[tid].spring_force = spring_force;
        }

      __syncthreads();

      const int pull_i = ts_pull_i >> 1;

      /// Accumulate sum of triangle information computed above.
      //
      // Note that loops are hand unrolled to overcome compiler
      // limitations.
      //
#define VTX_PULL(idx)                                                         \
      if ( idx < pull_i )                                                     \
        {                                                                     \
          const int tri_id = tsc.pull_tid_##idx;                              \
          const float3 center = tri_shared[tri_id].center;                    \
          const float3 surface_normal_t = tri_shared[tri_id].surface_normal;  \
          vec_addto(surface_normal_sum,surface_normal_t);                     \
          vec_addto(force_spring,repforce_compute(pos,tsb.vi_opp##idx));      \
          const float3 p_to_c = vec_sub(center,pos);                          \
          const float spring_force = tri_shared[tri_id].spring_force;         \
          vec_addto(force_spring, vec_scale(spring_force, p_to_c));           \
        }

      VTX_PULL(0); VTX_PULL(1); VTX_PULL(2); VTX_PULL(3);
    }

  /// Write Volumes
  //
  // Compute sum of volumes of each thread this block, then write to a
  // global array for use in next time step.
  //
  const float vol_sum = reduce(block_lg,volumes,local_volume_x2 * 0.5f,false);
  if ( tid == 0 ) tower_volumes_out[ blockIdx.x ] = vol_sum;

  /// Read Volumes
  //
  // Retrieve volumes of blocks written in the last time step and
  // compute their sum.
  //
  const int vol_per_thread = div_p2_ceil(gridDim.x,block_lg);
  float my_vol = 0;
  for ( int i=0; i<vol_per_thread; i++ )
    my_vol += tower_volumes_in[tid + ( i << block_lg ) ];
  const float volume = reduce(block_lg,volumes_read,my_vol,true);

  ///
  /// Vertex Round
  ///
  // Compute new position and velocity.

  if ( vi >= point_count ) return;

  const float friction_coefficient = .04;
  const float bounce_factor = 0.0;
  const float mass = 1.0;

  const float3 gravity = make_float3(0.0,-gravity_mag,0.0);

  const float3 vel = make_float3(vtx_data_r.vel[vi]);

  const float3 surface_normal = vec_scale((1./6.), surface_normal_sum);

  float pressure_factor = pressure_factor_coeff / fabs(volume);

  float pressure =
    opt_gravity
    ? pressure_factor * exp( - gas_m_over_temp * pos.y )
    : pressure_factor;
  float air_pressure =
    opt_gravity ? exp( - 0.2f * air_particle_mass * pos.y ) : 1.0;

  float3 force_pressure = vec_scale(air_pressure - pressure, surface_normal);

  float3 force = make_float3(0,0,0);
  vec_addto(force_spring,force_pressure);

  float3 vel_norm = normalize(vel);
  float facing_area = max(0.0f,-dot(vel_norm,surface_normal));
  float3 force_ar = vec_scale( - air_resistance * facing_area, vel);

  float3 gforce = vec_scale(point_mass * mass, gravity);
  vec_addto(force, gforce);

  vec_addto(force, force_ar);

  float3 force_ns = force;

  vec_addto(force, force_spring);

  float mass_wgas_inv_dt =
    delta_t / ( point_mass * mass + gas_mass_per_vertex );

  float3 delta_vns = vec_scale(mass_wgas_inv_dt, force_ns);
  float3 delta_vs = vec_scale(mass_wgas_inv_dt, force_spring);
  float3 delta_v = vec_add(delta_vns, delta_vs);

  float3 pos_next =
    vec_add(pos, vec_scale(delta_t, vec_add( vel,  vec_scale(0.5,delta_v) )));

  float3 vel_next = vec_add3(vel,  vec_scale(damping_v, delta_vs), delta_vns);

  const bool platform_aligned =
    pos_next.x >= platform_xmin && pos_next.x <= platform_xmax
    && pos_next.z >= platform_zmin && pos_next.z <= platform_zmax;
  const bool above_to_below =  pos_next.y <= 0.0f && pos.y >= 0.0f;

  if ( platform_aligned && above_to_below )
    {
      pos_next.y = 0.0;
      vel_next.y = - bounce_factor * vel_next.y;
      const float f_y = min(0.0f, gforce.y + force_spring.y);
      const float friction_force = -f_y * friction_coefficient;
      const float delta_v = friction_force * delta_t / ( point_mass * mass );
      const float3 xzvel = make_float3(vel_next.x,0,vel_next.z);
      if ( length(xzvel) <= delta_v ) {
        vel_next.x = 0.0;  vel_next.z = 0.0;
      }
      else
        vec_addto(vel_next, vec_scale( -delta_v, normalize(xzvel) ));
    }

  CUDA_Vtx_Data_X vtx_data_x = write_side ? vtx_data_x1 : vtx_data_x0;
  vtx_data_x.surface_normal[vi] = make_float4(surface_normal,0);
  vtx_data_x.vel[vi] = make_float4(vel_next,0);
  vtx_data_x.pos[vi] = make_float4(pos_next,1);
}
