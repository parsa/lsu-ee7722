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
#version 150 compatibility

// The _GEOMETRY_SHADER_ define is put there by code in shader.h.
//
#ifdef _GEOMETRY_SHADER_
#extension GL_EXT_geometry_shader4 : enable
#endif


///
/// Support Functions
///

float dist_sq(vec2 a, vec2 b) { vec2 ab = a - b; return dot(ab,ab); }
float mag_sq(vec3 v) { return dot(v,v); }
float dot_pos(vec3 a, vec3 b){ return max(0.0,dot(a,b)); }

vec3 deaxis(vec3 vect, vec3 norm) { return vect - dot(vect,norm) * norm; }
vec3 deaxis(vec4 vect, vec3 norm) { return deaxis(vect.xyz,norm); }
struct pNorm {
  vec3 v;
  float mag_sq, magnitude;
};

// Structure for holding a normalized vector and it's pre-normalized
// length.  The mn functions play the role of pNorm constructors.
//
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


///
/// Shader For Reflections
///

// Reflections (of the ball on the platform) are done by transforming
// vertex coordinates into reflected coordinates (which appear, put
// informally, on the other side of the mirror). The reflected point
// is found by first finding a point on the platform in which the
// angle between the platform normal and the vector to the eye
// location is the same as the angle between the platform normal and
// the vertex location. It is sufficient to find such mirror points in
// two dimensions, but still tricky. Mathematicians know this as
// Alhazan's Billiard Problem, with the reflected light ray replaced
// with a bouncing pool (billiard) ball. The code below uses an
// admittedly clumsy solution.

// There are several possible mirror points, up to four if the
// platform were a full cylinder. The reflected point is the eye to
// platform vector lengthened by the distance from the platform to the
// vertex.

// The code uses both a vertex shader and a geometry shader. The
// vertex shader computes up to three reflected locations for each
// vertex. The geometry shader then emits up to three triangles.


// Used to select variations on mirror technique. Used for
// debugging and tuning.
//
uniform int opt_mirror_method;
uniform int opt_color_events;

uniform float platform_xmid;
uniform float platform_xrad;


// These needed so that reflection can be computed in world coordinates,
// where axis is conveniently parallel to z axis.
//
uniform vec4 eye_location;
uniform mat4 eye_to_world, world_to_clip;

#define VSO_LIGHT0 1
#define VSO_LIGHT1 2
#define VSO_SEPARATE_SPECULAR_COLOR 4

#ifdef _VERTEX_SHADER_
uniform int vs_options;
flat out vec3 world_pos0;  // World-space coordinate of a mirror point.
flat out vec3 world_pos1;
flat out vec3 world_pos2;
flat out int count;        // Number of mirror points found.
#endif

#ifdef _GEOMETRY_SHADER_
flat in vec3 world_pos0[3];
flat in vec3 world_pos1[3];
flat in vec3 world_pos2[3];
flat in int count[3];
#endif


// Determine the error in a possible mirror point.
//
float
alhazan_check(vec2 eye,vec2 vertex,vec2 mirror)
{
  pNorm me = mn(mirror,eye);
  pNorm mv = mn(mirror,vertex);
  float de = dot(me.v.xy,mirror);
  float dv = dot(mv.v.xy,mirror);
  return abs(dv-de);
}


struct AH_Solutions {
  vec2 sol[4];
  int count;                    // Number of solutions computed.
};
AH_Solutions ah_solutions;


// Given the y coordinate of a mirror point, determine the x coordinate
// and check if it's better than a symmetric solution. If so, add it
// to the solution list.
//
void
alhazan_finish
(vec2 eye, vec2 vertex, float errs,
 float q, float r, float s, mat2 rot, float y)
{
  float x1 = r * y / ( 2. * q * y + s );
  pNorm m1n = mn(x1,y,0.0); // Should this be necessary?
  vec2 m1 = rot * m1n.v.xy;
  float errm1 = alhazan_check(eye,vertex,m1);
  if ( errm1 > errs ) return; // Don't use if symmetric solution better.
  ah_solutions.sol[ah_solutions.count] = m1;
  if ( m1.y < 0.1 ) ah_solutions.count++;  // Ignore solutions above platform.
}


 /// Compute mirror points (solutions to alhazan's problem).
//
void
alhazan(vec2 eye, vec2 vertex)
{
  //  http://mathworld.wolfram.com/AlhazensBilliardProblem.html
  //  http://www.math.sjsu.edu/~alperin/Alhazen.pdf
  //  http://dx.doi.org/10.1137/S0036144596310872

  const bool avoid_br = false;

  ah_solutions.count = 0;

  pNorm dir_b = mn(vertex);

  // Return if outside of platform.
  if ( dir_b.magnitude > 1 && vertex.y < 0 ) return;

  pNorm dir_a = mn(eye);

  // Compute symmetric solution.
  // Only valid when vertex and eye are same distance from axis.
  //
  pNorm dir_ab = mn( dir_a.v + dir_b.v );
  vec2 rvab = dir_ab.v.xy;

  if ( bool( opt_mirror_method & 1 ) )
    {
      // Return quickly for experimental purposes.
      //
      ah_solutions.sol[0] = rvab;
      ah_solutions.count = 1;
      return;
    }

  // Compute error of two possible symmetric solutions and remember
  // better one. This will be used for code below doesn't find anything
  // better.
  //
  float errab = alhazan_check(eye,vertex,rvab);
  vec2 rvb = dir_b.v.xy;
  float errb = alhazan_check(eye,vertex,rvb);
  bool ab_better = errab < errb;
  float errs = ab_better ? errab : errb;
  vec2 rvs = ab_better ? rvab : rvb;
  if ( rvs.y > 0 ) rvs = -rvs;


  // Rotate space so that x-axis midway between eye and vertex directions.
  // Simplifies computation.
  //
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

  // Code below based on Mathematica solution to
  // a^2 + b^2 == 1,  2 q a b + s a - r b == 0
  // See http://www.math.sjsu.edu/~alperin/Alhazen.pdf

  // The solution computed below does not work well when a and b
  // (or the eye and the vertex) are close to the same distance
  // from the center (or axis).

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
      // Always execute this code (avoid_br true) if cost of diverging
      // branches is higher than unnecessary complex-realm calculations.
      //
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
      // Use symmetric solution if code above yields nothing good.
      //
      ah_solutions.sol[0] = rvs;
      ah_solutions.count = 1;
    }

}

void
generic_lighting_i
(vec4 vertex_e, vec4 color, vec3 normal_e,
 inout vec4 new_color, inout vec4 spec_color, int i);

void
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e, int options)
{
  // Compute Lighting for Ball
  // Uses OpenGL lighting model, nothing fancy here.

  vec4 new_color = vec4( color.rgb * gl_LightModel.ambient.rgb, color.a);
  vec4 spec_color = vec4(0,0,0,1);

  // Bug Workaround: Compile error when code from generic_lighting_i
  // placed in a loop body (with loop iterating over i). So instead,
  // hand-unroll loop.  Bug encountered on driver 4.0.0 NVIDIA 256.40
  if ( bool( options & VSO_LIGHT0 ) )
    generic_lighting_i(vertex_e, color, normal_e, new_color, spec_color,0);
  if ( bool( options & VSO_LIGHT1 ) )
    generic_lighting_i(vertex_e, color, normal_e, new_color, spec_color,1);

  if ( true )
    {
      gl_BackColor.rgb = gl_FrontColor.rgb = new_color.rgb + spec_color.rgb;
      gl_BackColor.a = gl_FrontColor.a = new_color.a;
    }
  else
    {
      gl_BackColor = gl_FrontColor = new_color;
      gl_BackSecondaryColor = gl_FrontSecondaryColor = spec_color;
    }
}

void
generic_lighting_i(vec4 vertex_e, vec4 color, vec3 normal_e,
                   inout vec4 new_color, inout vec4 spec_color, int i)
{
  // Compute Lighting for Ball
  // Uses OpenGL lighting model, nothing fancy here.

  vec3 light_pos = gl_LightSource[i].position.xyz;
  vec3 v_vtx_light = light_pos - vertex_e.xyz;
  vec3 v_to_light = normalize(v_vtx_light);
  vec3 v_to_eye = normalize(-vertex_e.xyz);
  bool front_visible = dot(normal_e,v_to_eye) > 0.0;
  float phase_light_raw = dot(normal_e, v_to_light);
  float phase_light =
    max(0.0f, front_visible ? phase_light_raw : -phase_light_raw );
  vec3 h = normalize( v_to_light + v_to_eye );
  vec3 ambient_light = gl_LightSource[i].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[i].diffuse.rgb;
  float dist = length(v_vtx_light);
  float distsq = dist * dist;
  float atten_inv =
    gl_LightSource[i].constantAttenuation +
    gl_LightSource[i].linearAttenuation * dist +
    gl_LightSource[i].quadraticAttenuation * distsq;
  new_color.rgb +=
    color.rgb * ( ambient_light + phase_light * diffuse_light )
    / atten_inv;
  if ( gl_FrontMaterial.shininess > 0.0 && phase_light > 0.0 )
    spec_color.rgb +=
      pow(dot_pos(normal_e,h),gl_FrontMaterial.shininess)
      * gl_FrontMaterial.specular.rgb
      * gl_LightSource[i].specular.rgb / atten_inv;
}


#ifdef _VERTEX_SHADER_

void
vs_main_xform_only()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

void
vs_main_plain()
{
  gl_TexCoord[0] = gl_MultiTexCoord0;
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Compute lighting using ordinary lighting calculations.
  //
  generic_lighting(vertex_e,gl_Color,normal_e,vs_options);
}

void
vs_main_reflect()
{
  /// Compute locations of reflected points of vertex.

  // Easy stuff first, pass on texture coordinate to next stage.
  //
  gl_TexCoord[0] = gl_MultiTexCoord0;

  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);
  vec4 vertex_e_pn = vertex_e + vec4(normal_e,0);

  // Compute lighting using ordinary lighting calculations.
  //
  generic_lighting(vertex_e,gl_Color,normal_e,-1);

  // Find world-space coordinate of vertex and vertex normal,
  // then find two-dimensional location of eye and vertex with
  // axis at origin.
  //
  vec4 vertex_w = eye_to_world * vertex_e;
  vec4 vertex_w_pn = eye_to_world * vertex_e_pn;
  vec3 normal_w = vertex_w_pn.xyz - vertex_w.xyz;
  vec3 center = vec3(platform_xmid,0,0); // Axis passes through this point.
  float rad_inv = 1.0 / platform_xrad;
  vec2 eye_xy = rad_inv * ( eye_location.xy - center.xy );
  vec2 vertex_xy = rad_inv * ( vertex_w.xy - center.xy );

  /// Compute Solutions.
  //
  // Solutions written to global variable ah_solutions.
  //
  alhazan(eye_xy,vertex_xy);

  for ( int i=0; i<4; i++ )
    {
      // Using 2-D mirror point compute 3-D reflected point.

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

      // Code more efficient if loop exited this way because
      // compiler knows there will be no more than 4 iterations.
      //
      if ( i == ah_solutions.count ) break;
    }
  count = ah_solutions.count;
}
#endif



#ifdef _GEOMETRY_SHADER_

void
gs_reflect(vec3 world_pos[3],float dlimit_sq, vec3 color)
{
  /// Emit a triangle for a set of reflected vertices.

  // Return if triangle looks suspiciously large. (This happens when
  // a vertex is reflected to more than one location and they are
  // not matched up properly.)  This code will also reject legitimate
  // triangles that are very stretched out.
  //
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

      // Overwrite colors if this tuning option is turned on.
      // The color assigned here is based on the number of
      // solutions found.
      //
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
  // Locate a set of vertices near ref and pass them to gs_reflect.
  // This routine called when the number of solutions is not
  // the same for every vertex.

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
  /// Emit triangles based on the mirror points found for each triangle.

  // Up to three solutions per vertex can be found (meaning the
  // triangle would be seen reflected in three different places). The
  // code must handle situations where one vertex has fewer or more
  // solutions than the others. It also does not use a precise way of
  // determining which of the multiple solutions belong to the same
  // triangle. (Distance is used to reject mismatched sets.)


  // Compute rejection threshold. Triangles with vertices more than
  // this distance apart will be rejected.
  //
  float rx = platform_xrad * 0.3;
  float rxsq = rx * rx;

  if ( bool(opt_mirror_method & 2 ) )
    {
      // Just emit one triangle and return.
      // Intended for tuning and debugging.
      // For example, returning here will avoid massive branch
      // divergence that occur in transitional areas.
      gs_reflect(world_pos0,rxsq,vec3(1,1,1));
      return;
    }

  // Look at each vertex and find the smallest number of solutions.
  int minc = min(min(count[0],count[1]),count[2]);
  if ( minc == 0 ) return;
  // And find the largest number of solutions.
  int maxc = max(max(count[0],count[1]),count[2]);

  if ( minc == 1 && maxc > 1 )
    {
      // Just one complete triangle.
      //
      vec2 ref =
        count[0] == 1 ? world_pos0[0].xy :
        count[1] == 1 ? world_pos0[1].xy : world_pos0[2].xy;
      reflect_if_nearby(ref);
      return;
    }

  if ( minc == 2 && maxc > 2 )
    {
      // Two complete triangles.
      //
      vec4 ref =
        count[0] == 2 ? vec4(world_pos0[0].xy,world_pos1[0].xy) :
        count[1] == 2 ? vec4(world_pos0[1].xy,world_pos1[1].xy)
        : vec4(world_pos0[2].xy,world_pos1[2].xy);
      reflect_if_nearby(ref.xy);
      reflect_if_nearby(ref.zw);
      return;
    }

  // Set color based on number of solutions found.  For
  // debugging, tuning, learning, and fun.
  //
  vec3 color = minc == 1 ? vec3(1,1,1) : minc == 2 ? vec3(0,1,0) : vec3(0,0,1);

  gs_reflect(world_pos0,rxsq,color);

  if ( minc < 2 ) return;

  gs_reflect(world_pos1,rxsq,color);

  if ( minc < 3 ) return;

  gs_reflect(world_pos2,rxsq,color);

}


#endif
