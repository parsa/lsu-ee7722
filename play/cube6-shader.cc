/// LSU EE 7700-1 (Sp 2009), Graphics Processors
//
 /// Balloon Simulation, Under construction.

// $Id:$

 /// Purpose
//
//   Demonstrate use of gpu for physics.

#extension GL_EXT_gpu_shader4 : enable

void plan_c_pass_1_triangles();
void plan_c_pass_2_vertices();


vec3
cross3(vec3 a, vec3 b, vec3 c)
{
  vec3 ab = a - b;
  vec3 cb = c - b;
  return cross(ab,cb);
}

uniform ivec4 control;
uniform samplerBuffer tex_data_vtx;
uniform samplerBuffer tex_data_tri;
uniform vec4 constants_sc;
uniform vec4 constants_gas;
uniform vec4 constants_dt;
uniform vec4 platform;
attribute float volume;
attribute ivec4 in_indices;
attribute vec4 in_pos;
attribute vec4 in_vel;
varying vec4 out_surface_normal;
varying vec4 out_force_or_v;  // force_p
varying vec4 out_pos;         // force_q
varying vec4 out_force_r;

void
main_physics_plan_c()
{
  int pass = gl_Vertex.y == 0.5 ? 2 : 1;
  if ( pass == 1 )
    {
      plan_c_pass_1_triangles();
    }
  else
    {
      plan_c_pass_2_vertices();
    }
}

vec3
plan_c_pass_1_repforce(vec3 p_pos, int po_idx)
{
  float rep_constant = constants_dt.y;
  vec4 po_posd = texelFetchBuffer(tex_data_vtx,po_idx+2);  
  vec3 po_pos = po_posd.xyz;
  vec3 p_to_q = p_pos - po_pos;
  float mag_sq = dot(p_to_q,p_to_q);
  float dist_sq_inv = rep_constant / max(0.001,mag_sq);
  vec3 p_to_q_n = normalize(p_to_q);
  return dist_sq_inv * p_to_q_n;
}

void
plan_c_pass_1_triangles()
{
  int pidx = int(gl_Vertex.x) << 2;
  int qidx = int(gl_Vertex.y) << 2;
  int ridx = int(gl_Vertex.z) << 2;
  int pi_opp = in_indices.x << 2;
  int qi_opp = in_indices.y << 2;
  int ri_opp = in_indices.z << 2;

  float spring_constant = constants_sc.x;
  vec4 pposd = texelFetchBuffer(tex_data_vtx,pidx+2);
  vec4 qposd = texelFetchBuffer(tex_data_vtx,qidx+2);
  vec4 rposd = texelFetchBuffer(tex_data_vtx,ridx+2);
  vec3 ppos = pposd.xyz;
  vec3 qpos = qposd.xyz;
  vec3 rpos = rposd.xyz;

  vec3 center = (1.0/3.0) * ( ppos + qpos + rpos );
  vec3 pqr_cross = cross3(qpos,ppos,rpos);

  float triangle_area_x2 = length(pqr_cross);

  float tower_volume_x2 = -pqr_cross.y * center.y;

  vec3 force_p = plan_c_pass_1_repforce(ppos,pi_opp);
  vec3 force_q = plan_c_pass_1_repforce(qpos,qi_opp);
  vec3 force_r = plan_c_pass_1_repforce(rpos,ri_opp);

  vec3 p_to_c = center - ppos;
  vec3 q_to_c = center - qpos;
  vec3 r_to_c = center - rpos;

  float perimeter = length(p_to_c) + length(q_to_c) + length(r_to_c);

  out_surface_normal.xyz = pqr_cross;
  out_surface_normal.w = tower_volume_x2;

  float length_relaxed = gl_Vertex.w;

  float eff_length = max(0.0, perimeter - length_relaxed );
  float spring_force = eff_length * spring_constant;

  force_p += spring_force * p_to_c;
  force_q += spring_force * q_to_c;
  force_r += spring_force * r_to_c;

  out_force_or_v.xyz = force_p;
  out_pos.xyz = force_q;
  out_force_r.xyz = force_r;

  gl_Position = vec4(-1.0,-1.0,0.0,1.0);
  gl_FrontColor.rgb = center;
  gl_FrontColor.a = tower_volume_x2;

}

int lo_idx(int i) { return i >> int(16); }
int hi_idx(int i) { return i & int(0xffff); }

void
plan_c_pass_2_vertices()
{
  float damping_v = constants_sc.y;
  float pressure_factor_coeff = constants_sc.z;
  float gas_m_over_temp = constants_sc.w;

  float air_resistance = constants_gas.x;
  float gas_mass_per_vertex = constants_gas.y;
  float air_particle_mass = constants_gas.z;
  float gravity_mag = constants_gas.w;

  float delta_t = constants_dt.x;
  float rep_constant = constants_dt.y;
  float point_mass = constants_dt.z;
  float point_mass_inv = constants_dt.w;

  float platform_xmin = platform.x;
  float platform_xmax = platform.y;
  float platform_zmin = platform.z;
  float platform_zmax = platform.w;

  const float friction_coefficient = .04;
  const float bounce_factor = 0.0;
  const float mass = 1.0;

  vec3 gravity = vec3(0.0,-gravity_mag,0.0);
  bool opt_gravity = gravity_mag != 0.0;
  
  vec3 pos = in_pos.xyz;
  vec3 vel = in_vel.xyz;

  int indices[8];
  indices[0] = lo_idx(in_indices.x);
  indices[1] = hi_idx(in_indices.x);
  indices[2] = lo_idx(in_indices.y);
  indices[3] = hi_idx(in_indices.y);
  indices[4] = lo_idx(in_indices.z);
  indices[5] = hi_idx(in_indices.z);
  indices[6] = lo_idx(in_indices.w);
  indices[7] = hi_idx(in_indices.w);

  vec3 force_spring = vec3(0.0,0.0,0.0);
  vec4 surface_normal_vol = vec4(0.0,0.0,0.0,0.0);

  for ( int i=0; i<8; i++ )
    {
      int idx_packed = indices[i];
      if ( idx_packed == -1 ) continue;
      int idx_base = idx_packed & ~0x3;
      int idx_force = idx_base + 1 + ( idx_packed & 0x3 );
      surface_normal_vol += texelFetchBuffer(tex_data_tri,idx_base);
      force_spring += texelFetchBuffer(tex_data_tri,idx_force);
    }
  vec3 surface_normal = (1./6.) * surface_normal_vol.xyz;

  float pressure_factor = pressure_factor_coeff / abs(volume);

  float pressure =
    opt_gravity
    ? pressure_factor * exp( - gas_m_over_temp * pos.y )
    : pressure_factor;
  float air_pressure =
    opt_gravity ? exp( - 0.2 * air_particle_mass * pos.y ) : 1.0;

  vec3 force_pressure = ( air_pressure - pressure ) * surface_normal;

  vec3 force = force_pressure;

  vec3 vel_norm = normalize(-vel);
  float facing_area = max(0.0,dot(vel_norm,surface_normal));
  vec3 force_ar = - air_resistance * facing_area * vel;

  vec3 gforce = point_mass * mass * gravity;
  force += gforce;

  force += force_ar;

  vec3 force_ns = force;

  force += force_spring;

  float mass_wgas_inv_dt =
    delta_t / ( point_mass * mass + gas_mass_per_vertex );

  vec3 delta_vns = mass_wgas_inv_dt * force_ns;
  vec3 delta_vs = mass_wgas_inv_dt * force_spring;
  vec3 delta_v = delta_vns + delta_vs;

  vec3 pos_next = pos + ( vel +  0.5 * delta_v ) * delta_t;
  vec3 vel_next = vel + damping_v * delta_vs + delta_vns;

  while ( true ) {
    if ( pos_next.x < platform_xmin || pos_next.x > platform_xmax
         || pos_next.z < platform_zmin || pos_next.z > platform_zmax ) break;
    if ( pos_next.y > 0.0 ) break;
    if ( pos.y < 0.0 ) break;
    pos_next.y = 0.0;
    vel_next.y = - bounce_factor * vel_next.y;
    float f_y = gforce.y + force_spring.y - pressure * surface_normal.y;
    if ( f_y >= 0.0 ) break;
    float friction_force = -f_y * friction_coefficient;
    float delta_v = friction_force * delta_t / ( point_mass * mass );
    vec3 xzvel = vec3(vel_next.x,0,vel_next.z);
    if ( length(xzvel) <= delta_v ) {
      vel_next.x = 0.0;  vel_next.z = 0.0;
    }
    else
      vel_next -= delta_v * normalize(xzvel);
    break;
  }

  out_surface_normal.xyz = surface_normal;
  out_surface_normal.w = 1.0;
  out_pos.xyz = pos_next;
  out_pos.w = 1.0;
  out_force_or_v.xyz = vel_next;
  //  out_force.xyz = force_spring;
  out_force_or_v.w = 1.0;

  gl_Position = vec4(-2.0,-2.0, -2.0, 1.0);
}

