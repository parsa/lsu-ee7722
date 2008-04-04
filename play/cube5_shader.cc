
vec3
cross3(vec4 a, vec4 b, vec4 c)
{
  vec3 ab = a.xyz - b.xyz;
  vec3 cb = c.xyz - b.xyz;
  return cross(ab,cb);
}

void
vs_ff_vertex()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  gl_TexCoord[0] = gl_MultiTexCoord0;
}

void
vs_lighting(vec4 o_point, vec4 color, vec3 normal)
{
  // Input: gl_Vertex, gl_Normal
  // Output: gl_Position, gl_PointSize, gl_ClipVertex
  vec4 vertex_e = gl_ModelViewMatrix * o_point;
  vec3 norm_e = gl_NormalMatrix * normal;
  vec4 light_pos = gl_LightSource[1].position;
  float phase_light = dot(norm_e, normalize(light_pos - vertex_e).xyz);
  float phase_user = dot(norm_e, -vertex_e.xyz);
  float phase = sign(phase_light) == sign(phase_user) ? abs(phase_light) : 0.0;
  const vec3 ambient = gl_LightSource[1].ambient.rgb;
  const vec3 diffuse = gl_LightSource[1].diffuse.rgb;
  vec4 new_color;
  new_color.rgb = color.rgb * ( phase * diffuse + ambient );
  new_color.a = color.a;
  gl_FrontColor = new_color;
  gl_BackColor = color;
}

void
vs_main_lighting()
{
  vs_ff_vertex();
  vs_lighting(gl_Vertex,gl_Color,gl_Normal);
}

uniform vec3 gravity_force;
uniform float gs_constant;
uniform float damping_factor;
uniform float gp_mass_inv;
uniform float delta_t;
uniform vec2 ball_size;

attribute float step_last_time;
attribute vec4 position_left, position_right, position_above, position_below;
attribute vec3 velocity_left, velocity_right, velocity_above, velocity_below;
attribute vec3 in_velocity;
attribute vec3 in_force;
attribute vec3 in_extra; // (contact_time, cross_direction, boundary)
attribute vec3 ball_position;
attribute vec3 ball_speed;

varying vec4 out_position;
varying vec3 out_velocity;
varying vec3 out_force;
varying vec3 out_extra;

void physics_point_edge();
void physics_point_interior();
void physics_ball();

void
main_physics()
{
  const bool boundary = in_extra.z != 0.0;
  if ( boundary ) physics_point_edge();
  else physics_point_interior();
  physics_ball();
}

void
physics_ball()
{
  const float contact_time = in_extra.x;
  const float cross_direction = in_extra.y;
  const bool boundary = in_extra.z != 0.0;

  out_extra = in_extra;
  gl_Position = vec4(2.0,2.0,2.0,1.0);  // May be reassigned, otherwise cull.

  //  if ( contact_time != -4314.2735 ) return;

  vec3 gp_to_ball = out_position.xyz - ball_position;
  const float dist_sq = dot(gp_to_ball,gp_to_ball);
  if ( dist_sq > ball_size.y ) return;

  out_extra.x = step_last_time;

  vec3 gp_to_ball_n = normalize(gp_to_ball);
  vec3 gp_v_wrt_ball = ball_speed - in_velocity;

  vec3 plane_vect = vec3(0.0,0.0,0.0);

  if ( boundary )
    {
      plane_vect = -gp_to_ball_n;
    }
  else
    {
      plane_vect += normalize(cross3(position_right,gl_Vertex,position_above));
      plane_vect += normalize(cross3(position_above,gl_Vertex,position_left));
      plane_vect += normalize(cross3(position_left, gl_Vertex,position_below));
      plane_vect += normalize(cross3(position_below,gl_Vertex,position_right));
      plane_vect *= cross_direction;
    }

  vec3 plane_norm = normalize(plane_vect);
  //  const float closest = dot(gp_to_ball, plane_norm);


  if ( !boundary )
    {
      vec3 gp_v_wrt_ball_n = normalize(gp_v_wrt_ball);
      float coming = sign(dot(gp_v_wrt_ball_n,plane_vect));
      //  out_position.xyz = ball_position + gp_v_wrt_ball_n * ball_size.x;
      out_position.xyz = ball_position + gp_to_ball_n * ball_size.x;
    }
  const float s_to_ball = -dot(plane_norm,gp_v_wrt_ball);

  //  out_position += plane_norm * (closest - ball_size.x);
  vec3 v_to_ball = s_to_ball * plane_norm;
  //  ball_impact_v_sum += v_to_ball;
  out_velocity += -v_to_ball;
  //  gp.velocity = ball_speed;

  gl_Position = vec4(-1.0,-1.0,0.0,1.0);
  gl_FrontColor.rgb = v_to_ball;
  gl_FrontColor.a = s_to_ball;
}

void
physics_point_edge()
{
  const float delta_t_inv = 1.0 / delta_t;
  vec4 local_pos = vec4(in_force,1);
  out_position = gl_ModelViewMatrix * local_pos;
  out_force = in_force;
  out_velocity = ( out_position.xyz - gl_Vertex.xyz ) * delta_t_inv;
}

void
physics_point_interior()
{
  const float h_delta_t = delta_t * 0.5;
  const float h_delta_t_sq = delta_t * delta_t / 2.0;
  const float sixth_delta_t_sq = delta_t * delta_t / 6.0;
  const float contact_time = in_extra.x;

  if ( false )
    {
      out_position = gl_Vertex;
      out_velocity = vec3(55.,66.,77.);
      out_force = vec3(88.,99.,1010.);
      out_extra = vec3(1111.,1212.,1313.0);
      if ( delta_t != -1.0 ) return;
    }

  vec3 delta_v_sum =
    velocity_left + velocity_right + velocity_above + velocity_below;

  vec4 dist_sum = 
    position_left + position_right + position_above + position_below
    - 4.0 * gl_Vertex;

  vec3 force_now =
    gravity_force + dist_sum.xyz * gs_constant
    + damping_factor * ( delta_v_sum - 4.0 * in_velocity );
  vec3 delta_f = ( force_now - in_force );
  out_velocity = in_velocity + 
    gp_mass_inv * ( delta_t * force_now - h_delta_t * delta_f );
  vec3 displacement =
    out_velocity * delta_t
    + gp_mass_inv
    * ( h_delta_t_sq * force_now + sixth_delta_t_sq * delta_f );
  out_force = force_now;
  out_position.xyz = gl_Vertex.xyz + displacement;
  out_position.w = 1.0;
}

attribute float time_th;

void grid_color_normal_compute( inout vec4 color, inout vec3 normal );

void
main_faces()
{
  vec4 color;
  vec3 normal = vec3(0.57735,0.57735,0.57735);
  grid_color_normal_compute(color,normal);
  vs_lighting(gl_Vertex,color,normal);
  vs_ff_vertex();
}

float btof(int b){ return float(b)/255.0; }

void
grid_color_normal_compute( inout vec4 color, inout vec3 normal )
{
  const float contact_time = in_extra.x;
  const bool boundary = in_extra.z != 0.0;
  const float contact_mark_duration = 10.0;
  const float contact_mark_mult = 1.0 / contact_mark_duration;
  const vec3 color_purple = vec3( btof(0x58), btof(0xd), btof(0xa6) );

  if ( contact_time > time_th )
    {
      const float gb = ( step_last_time - contact_time ) * contact_mark_mult;
      //  color = vec4(1.0,gb,gb,0.9);
      color.xyz = mix( color_purple, vec3(1.0,1.0,1.0), gb );
      color.a = 0.9;
    }
  else
    color = vec4(1.,1.,1.,0.9);

  if ( boundary )
    {
      return;
    }

  normal = normalize( cross3(position_left,gl_Vertex,position_above)
                      + cross3(position_right,gl_Vertex,position_below));
  
}
