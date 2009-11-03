/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// Purpose
//
//   Shader Code for Ball Collision Demo.
//
//   Shaders compute shadow and reflection locations.


// Specify version of OpenGL Shading Language.
//
#version 150

// The _GEOMETRY_SHADER_ define is put there by code in shader.h.
//
#ifdef _GEOMETRY_SHADER_
#extension GL_EXT_geometry_shader4 : enable
#endif


uniform vec4 axis_e;
uniform vec3 axis_ne;
uniform float platform_xrad_sq;
uniform int light_num;
uniform int opt_mirror_method;
uniform int opt_color_events;

///
/// Support Functions
///

float dist_sq(vec2 a, vec2 b) { vec2 ab = a - b; return dot(ab,ab); }
float mag_sq(vec3 v) { return dot(v,v); }
float dot_pos(vec3 a, vec3 b){ return max(0.0,dot(a,b)); }

vec3 deaxis(vec3 vect, vec3 norm) { return vect - dot(vect,norm) * norm; }
vec3 deaxis(vec4 vect, vec3 norm) { return deaxis(vect.xyz,norm); }



///
/// Shader for Shadows
///

void
vs_main_shadow()
{
  /// Compute coordinate of shadow cast by vertex.

  vec3 axis_exy = deaxis( axis_e, axis_ne );
  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec4 light_pos = gl_LightSource[light_num].position;
  vec3 vertex_exy = deaxis( vertex_e, axis_ne );

  vec3 light_pos_ma = vertex_exy - axis_exy;
  vec3 v_light_vtx = vertex_e.xyz - light_pos.xyz;
  vec3 v_light_vtx_xy = deaxis( v_light_vtx, axis_ne );

  float a = dot(v_light_vtx_xy,v_light_vtx_xy);
  float b = 2.0 * dot( light_pos_ma, v_light_vtx_xy );
  float c = dot( light_pos_ma, light_pos_ma ) - platform_xrad_sq;
  float radical = b * b - 4.0 * a * c;

  // Use this position if shadow not visible.
  //
  gl_Position = vec4(0,0,-1000,1);

  if ( radical < 0.0 ) return;

  float t = ( -b + sqrt( radical ) ) / ( 2.0 * a );

  if ( t < 0.0001 ) return;

  vec4 shadow_e;
  shadow_e.xyz = vertex_e.xyz + t * v_light_vtx;

  shadow_e.w = 1.0;
  gl_Position = gl_ProjectionMatrix * shadow_e;
}


struct pNorm {
  vec3 v;
  float mag_sq, magnitude;
};

pNorm mn(vec3 v)
{
  pNorm n;
  n.mag_sq = mag_sq(v);
  if ( n.mag_sq == 0.0 )
    {
      n.magnitude = 0.0;
      n.v.x = n.v.y = n.v.z = 0.0;
    }
  else
    {
      n.magnitude = sqrt(n.mag_sq);
      n.v = (1.0/n.magnitude) * v;
    }
  return n;
}

pNorm mn(vec2 v) { return mn(vec3(v,0)); }
pNorm mn(vec2 a, vec2 b) {return mn(b.xy-a.xy);}
pNorm mn(vec3 a, vec3 b) {return mn(b-a);}
pNorm mn(vec4 a, vec4 b) {return mn(b.xyz-a.xyz);}
pNorm mn(float x, float y, float z){ return mn(vec3(x,y,z)); }

float
alhazan_check(vec2 eye,vec2 vertex,vec2 mirror)
{
  pNorm me = mn(mirror,eye);
  pNorm mv = mn(mirror,vertex);
  float de = dot(me.v.xy,mirror);
  float dv = dot(mv.v.xy,mirror);
  float err = abs(dv-de);
  return err;
}

struct AH_Solutions {
  vec2 sol[4];
  int count;
};
AH_Solutions ah_solutions;

void
alhazan_finish
(vec2 eye, vec2 vertex, float errs,
 float q, float r, float s, mat2 rot, float y)
{
  float x1 = r * y / ( 2. * q * y + s );
  pNorm m1n = mn(x1,y,0.0); // Should this be necessary?
  vec2 m1 = rot * m1n.v.xy;
  float errm1 = alhazan_check(eye,vertex,m1);
  if ( errm1 > errs ) return;
  ah_solutions.sol[ah_solutions.count] = m1;
  if ( m1.y < 0.1 ) ah_solutions.count++;
}


void
alhazan(vec2 eye, vec2 vertex)
{
  //  http://mathworld.wolfram.com/AlhazensBilliardProblem.html
  //  http://www.math.sjsu.edu/~alperin/Alhazen.pdf

  const bool avoid_br = false;

  ah_solutions.count = 0;

  pNorm dir_b = mn(vertex);

  if ( dir_b.magnitude > 1 && vertex.y < 0 ) return;

  pNorm dir_a = mn(eye);

  pNorm dir_ab = mn( dir_a.v + dir_b.v );
  vec2 rvab = dir_ab.v.xy;

  if ( bool( opt_mirror_method & 1 ) )
    {
      ah_solutions.sol[0] = rvab;
      ah_solutions.count = 1;
      return;
    }

  float errab = alhazan_check(eye,vertex,rvab);
  vec2 rvb = dir_b.v.xy;
  float errb = alhazan_check(eye,vertex,rvb);
  bool ab_better = errab < errb;
  float errs = ab_better ? errab : errb;
  vec2 rvs = ab_better ? rvab : rvb;
  if ( rvs.y > 0 ) rvs = -rvs;

  float cos_th =  dir_ab.v.x;
  float sin_th = -dir_ab.v.y;

  mat2 rot  = mat2(cos_th,  sin_th, -sin_th, cos_th);
  mat2 roti = mat2(cos_th, -sin_th,  sin_th, cos_th);

  vec2 a = rot * eye.xy;
  vec2 b = rot * vertex.xy;

  float p = a.x * b.y + a.y * b.x;
  float q = a.x * b.x - a.y * b.y;
  float r = a.x + b.x;
  float s = a.y + b.y;
  float ssq = s * s;
  float qsq = q * q;
  float rsq = r * r;

  float k1 = (-4.0 * qsq + rsq + ssq);
  float k1cu = k1 * k1 * k1;
  float k2 = 2.0 * k1cu + 432.0 * qsq * ssq * ( k1 + 4.0 * qsq - ssq );

  float k4 = 4.0 * qsq - rsq - ssq;
  float k4sq = k4 * k4;

  float k3pre = -4.0 * k1cu * k1cu + k2 * k2;

  bool k3_neg = k3pre < 0.0;
  float k3sp = sqrt( abs(k3pre) );
  float k3_re = k2 + ( k3_neg ? 0.0 : k3sp );

  float k21;

  if ( k3_neg || avoid_br )
    {
      float k3_imsq = max(-k3pre,0.0);
      float k3_im = k3_neg ? k3sp : 0.0;
      float k3_car = (1./3.) * atan(k3_im,k3_re);
      float k3cr_cm = pow( k3_re * k3_re + k3_imsq, 1/6.);
      float k3_real_n = cos(k3_car);
      k21 =
        k3_real_n *
        ( 1.5874010519681996 * k3cr_cm + 2.5198420997897464 * k4sq / k3cr_cm );
    }
  else
    {
      float k3cr = pow(k3_re,1./3);
      k21 = 
        1.5874010519681996 * k3cr + 2.5198420997897464 * k4sq / k3cr;
    }

  float k20 = sqrt( -4.*k1 + k21 + 6.*ssq );

  float k6 = 8.*k1 + k21 - 12.*ssq;
  float k7 = 29.393876913398135 * s * (k1 + 8.*qsq - ssq) / k20;

  float k14 = -k6 - k7;
  float k15 = -k6 + k7;

  float k9 = 0.25 * s;
  float k11b = 2.449489742783178 / 24.0;
  float k10 = k11b * k20;

  float qinv = 1/q;

  if ( k14 >= 0 )
    {
      float k14sr = k11b * sqrt( k14 );
      float ys11 = ( -k9 - k10 - k14sr ) * qinv;
      float ys12 = ( -k9 - k10 + k14sr ) * qinv;
      alhazan_finish(eye,vertex,errs,q,r,s,roti,ys11);
      alhazan_finish(eye,vertex,errs,q,r,s,roti,ys12);
    }

  if ( k15 >= 0 )
    {
      float k15sr = k11b * sqrt( k15 );
      float ys21 = ( -k9 + k10 - k15sr ) * qinv;
      float ys22 = ( -k9 + k10 + k15sr ) * qinv;
      alhazan_finish(eye,vertex,errs,q,r,s,roti,ys21);
      alhazan_finish(eye,vertex,errs,q,r,s,roti,ys22);
    }

  if ( ah_solutions.count == 0 && errs < 0.01 )
    {
      ah_solutions.sol[0] = rvs;
      ah_solutions.count = 1;
    }

}

void
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Compute Lighting for Ball
  // Uses OpenGL lighting model, nothing fancy here.

  vec4 new_color = vec4( color.rgb * gl_LightModel.ambient.rgb, color.a);
  vec4 spec_color = vec4(0,0,0,1);

  for ( int i=0; i<2; i++ )
    {
      vec4 light_pos = gl_LightSource[i].position;
      vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
      float phase_light = dot_pos(normal_e, normalize(v_vtx_light).xyz);
      pNorm v_to_light = mn(vertex_e,light_pos);
      pNorm v_to_eye = mn(vertex_e,vec4(0,0,0,1));
      pNorm h = mn( v_to_light.v + v_to_eye.v );
      bool f = dot(normal_e,v_to_light.v) > 0.0;
      vec3 ambient_light = gl_LightSource[i].ambient.rgb;
      vec3 diffuse_light = gl_LightSource[i].diffuse.rgb;
      float dist = length(v_vtx_light);
      float distsq = dist * dist;
      float atten_inv =
        gl_LightSource[i].constantAttenuation +
        gl_LightSource[i].linearAttenuation * dist +
        gl_LightSource[i].quadraticAttenuation * distsq;
      new_color.rgb +=
        color.rgb *
        ( ambient_light + phase_light * diffuse_light ) / atten_inv;
      if ( !f ) continue;
      spec_color.rgb +=
        pow(dot_pos(normal_e,h.v),gl_FrontMaterial.shininess)
        * gl_FrontMaterial.specular.rgb
        * gl_LightSource[i].specular.rgb / atten_inv;
    }

    gl_FrontColor = new_color;
    gl_FrontSecondaryColor =  spec_color;
}


uniform float platform_xmid;
uniform float platform_xrad;
uniform vec4 eye_location;
uniform mat4 eye_to_world, world_to_clip;



#ifdef _GEOMETRY_SHADER_

flat in vec3 world_pos0[3];
flat in vec3 world_pos1[3];
flat in vec3 world_pos2[3];
flat in int count[3];

#endif

#ifdef _VERTEX_SHADER_
flat out vec3 world_pos0;
flat out vec3 world_pos1;
flat out vec3 world_pos2;
flat out int count;


void
vs_main_reflect()
{
  // Compute locations of reflected points of vertex.

  gl_TexCoord[0] = gl_MultiTexCoord0;

  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);
  vec4 vertex_e_pn = vertex_e + vec4(normal_e,0);

  generic_lighting(vertex_e,gl_Color,normal_e);

  vec4 vertex_w = eye_to_world * vertex_e;
  vec4 vertex_w_pn = eye_to_world * vertex_e_pn;
  vec3 normal_w = vertex_w_pn.xyz - vertex_w.xyz;
  vec3 center = vec3(platform_xmid,0,0);
  float rad_inv = 1.0 / platform_xrad;
  vec2 eye_xy = rad_inv * ( eye_location.xy - center.xy );
  vec2 vertex_xy = rad_inv * ( vertex_w.xy - center.xy );

  // Sets ah_solutions.
  alhazan(eye_xy,vertex_xy);

  for ( int i=0; i<4; i++ )
    {
      vec2 mirror = ah_solutions.sol[i];
      float eye_mirror_xy_dist = distance(eye_xy,mirror);
      float mirror_ball_xy_dist = distance(mirror,vertex_xy);
      float z = eye_location.z
        + eye_mirror_xy_dist
        / ( eye_mirror_xy_dist + mirror_ball_xy_dist )
        * ( -eye_location.z + vertex_w.z );

      vec3 mirror_w = vec3(mirror * platform_xrad, z ) + center;
      pNorm mirror_ball = mn(mirror_w,vertex_w.xyz);

      pNorm eye_mirror = mn(eye_location.xyz,mirror_w);

      vec3 reflection = mirror_w + mirror_ball.magnitude * eye_mirror.v;

      switch(i){
      case 0 : world_pos0 = reflection; break;
      case 1 : world_pos1 = reflection; break;
      case 2 : world_pos2 = reflection; break;
      case 3: break;
      }
      if ( i == ah_solutions.count ) break;
    }
  count = ah_solutions.count;
}
#endif



#ifdef _GEOMETRY_SHADER_

void
gs_reflect(vec3 world_pos[3],float dlimit_sq, vec3 color)
{
  vec2 v0 = world_pos[0].xy;
  vec2 v1 = world_pos[1].xy;
  vec2 v2 = world_pos[2].xy;

  if ( dist_sq(v0,v1) > dlimit_sq ) return;
  if ( dist_sq(v1,v2) > dlimit_sq ) return;

  for ( int i=0; i<3; i++ )
    {
      gl_FrontColor = gl_FrontColorIn[i];
      gl_BackColor = gl_BackColorIn[i];
      gl_FrontSecondaryColor = gl_FrontSecondaryColorIn[i];
      gl_BackSecondaryColor = gl_BackSecondaryColorIn[i];

      if ( opt_color_events != 0 )
        gl_FrontColor = gl_BackColor
          = gl_FrontSecondaryColor = gl_BackSecondaryColor = vec4(color,1);

      gl_Position = world_to_clip * vec4(world_pos[i],1);
      gl_TexCoord[0] = gl_TexCoordIn[i][0];
      EmitVertex();
    }
  EndPrimitive();
}

void
reflect_if_nearby(vec2 ref)
{
  float xregion = ref.x;
  float rx = platform_xrad * 0.1;
  vec3 wp[3];
  for ( int i=0; i<3; i++ )
    {
      float d0 = dist_sq(world_pos0[i].xy,ref);
      float d1 = dist_sq(world_pos1[i].xy,ref);
      float d2 = dist_sq(world_pos2[i].xy,ref);
      if ( d0 <= d1 ) wp[i] = d2 < d0 ? world_pos2[i] : world_pos0[i];
      else            wp[i] = d2 < d1 ? world_pos2[i] : world_pos1[i];
    }

  gs_reflect(wp,rx * rx,vec3(1,0,0));
}


void
gs_main_reflect()
{
  float rx = platform_xrad * 0.3;
  float rxsq = rx * rx;

  if ( bool(opt_mirror_method & 2 ) )
    {
      gs_reflect(world_pos0,rxsq,vec3(1,1,1));
      return;
    }

  int minc = min(min(count[0],count[1]),count[2]);
  if ( minc == 0 ) return;

  int maxc = max(max(count[0],count[1]),count[2]);

  if ( minc == 1 && maxc > 1 )
    {
      vec2 ref =
        count[0] == 1 ? world_pos0[0].xy :
        count[1] == 1 ? world_pos0[1].xy : world_pos0[2].xy;
      reflect_if_nearby(ref);
      return;
    }

  if ( minc == 2 && maxc > 2 )
    {
      vec4 ref =
        count[0] == 2 ? vec4(world_pos0[0].xy,world_pos1[0].xy) :
        count[1] == 2 ? vec4(world_pos0[1].xy,world_pos1[1].xy)
        : vec4(world_pos0[2].xy,world_pos1[2].xy);
      reflect_if_nearby(ref.xy);
      reflect_if_nearby(ref.zw);
      return;
    }

  vec3 color = minc == 1 ? vec3(1,1,1) : minc == 2 ? vec3(0,1,0) : vec3(0,0,1);

  gs_reflect(world_pos0,rxsq,color);

  if ( minc < 2 ) return;

  gs_reflect(world_pos1,rxsq,color);

  if ( minc < 3 ) return;

  gs_reflect(world_pos2,rxsq,color);

}


#endif
