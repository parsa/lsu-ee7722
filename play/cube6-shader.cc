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
varying vec4 out_force_or_v;
varying vec4 out_pos;

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

void
plan_c_pass_1_triangles()
{
  int pidx = int(gl_Vertex.x);
  int qidx = int(gl_Vertex.y);
  int ridx = int(gl_Vertex.z);

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

  vec3 p_to_c = center - ppos;
  vec3 q_to_c = center - qpos;
  vec3 r_to_c = center - rpos;

  float perimeter = length(p_to_c) + length(q_to_c) + length(r_to_c);

  out_surface_normal.xyz = pqr_cross;
  out_surface_normal.w = tower_volume_x2;

  float length_relaxed = gl_Vertex.w;

  float eff_length = max(0.0, perimeter - length_relaxed );
  float spring_force = eff_length * spring_constant;

  out_force_or_v.xyz = center;
  out_force_or_v.w = spring_force;

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
  float nom_volume = constants_sc.z;
  float temp_ratio = constants_sc.w;

  float gas_amount = constants_gas.x;
  float particle_mass = constants_gas.y;
  float air_particle_mass = constants_gas.z;
  float gravity_mag = constants_gas.w;

  float delta_t = constants_dt.x;
  float air_pressure_factor = constants_dt.y;
  float point_mass = constants_dt.z;
  float point_mass_inv = constants_dt.w;

  float platform_xmin = platform.x;
  float platform_xmax = platform.y;
  float platform_zmin = platform.z;
  float platform_zmax = platform.w;

  const float friction_coefficient = 0.08;
  const float bounce_factor = 0.5;
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
      int idx = indices[i];
      if ( idx == 1 ) continue;
      surface_normal_vol += texelFetchBuffer(tex_data_tri,idx);
      vec4 center_and_force = texelFetchBuffer(tex_data_tri,idx+1);
      force_spring += center_and_force.w * ( center_and_force.xyz - pos );
    }
  vec3 surface_normal = surface_normal_vol.xyz;

  float eff_volume = abs( volume );
  float volume_ratio = nom_volume / eff_volume;
  float pressure_factor = 1.0/6.0 * gas_amount * volume_ratio * temp_ratio;
  float gas_m_over_temp = particle_mass / temp_ratio;
    
  float pressure =
    opt_gravity
    ? pressure_factor * exp( - gas_m_over_temp * pos.y )
    : pressure_factor;
  float air_pressure =
    opt_gravity
    ? air_pressure_factor * exp( - air_particle_mass * pos.y )
    : air_pressure_factor;

  vec3 force_pressure = ( air_pressure - pressure ) * surface_normal;
  vec3 gforce = point_mass * mass * gravity;

  vec3 force_ng = force_pressure + force_spring;
  vec3 force = force_ng + gforce;

  vec3 delta_vng = point_mass_inv * delta_t * force_ng;
  vec3 delta_vg = delta_t * gravity;
  vec3 delta_v = delta_vng + delta_vg;

  vec3 pos_next = pos + ( vel +  0.5 * delta_v ) * delta_t;
  vec3 vel_next = vel + damping_v * delta_vng + delta_vg;

  while ( true ) {
    if ( pos_next.x < platform_xmin || pos_next.x > platform_xmax
         || pos_next.z < platform_zmin || pos_next.z > platform_zmax ) break;
    if ( pos_next.y > 0.0 ) break;
    if ( pos.y < 0.0 ) break;
    pos_next.y = 0.0;
    vel_next.y = - bounce_factor * vel_next.y;
    if ( force.y >= 0.0 ) break;
    float friction_force = -force.y * friction_coefficient;
    float delta_v = point_mass * friction_force * mass * delta_t;
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

