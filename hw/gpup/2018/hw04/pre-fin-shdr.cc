/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 ///  Pre-Final Solution
//
 ///  Put solution in this file, most or all code in routine |fs_main|.
 //
 //   Assignment: https://www.ece.lsu.edu/koppel/gpup/2018/hw04.pdf

 //   Note: Code in this file is based on the code from
 //         links-shdr-sphere-true.cc.


// Specify version of OpenGL Shading Language.
//
#version 460 compatibility

const int h = 20;


layout ( binding = 1 ) buffer sr { mat4 sphere_rot[]; };
layout ( binding = 2 ) buffer spr { vec4 sphere_pos_rad[]; };
layout ( binding = 3 ) buffer sc { vec4 sphere_color[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec4 tryout;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 4 ) uniform float tryoutf;
layout ( location = 5 ) uniform bool mirrored;
layout ( location = 6 ) uniform mat4 trans_proj;
layout ( location = 7 ) uniform int opt_n_holes_eqt;
layout ( location = 8 ) uniform int opt_holes;

const int OHO_None = 0, OHO_Holes = 1, OHO_Lenses = 2;


#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS{ int vertex_id; };

void
vs_main()
{
  vertex_id = gl_VertexID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS { int vertex_id; } In[1];

out Data_to_FS
{
  flat int vertex_id;
  vec3 vertex_o;

  /// SOLUTION -- Add variables for lens center and face.
  //
  flat vec3 lens_ctr_o;
  flat bool lens_front;

};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
 /// SOLUTION -- Increase number of vertices.
layout ( triangle_strip, max_vertices = h * 4 ) out;

void
gs_main()
{
  vertex_id = In[0].vertex_id;
  vec4 pos_rad = sphere_pos_rad[vertex_id];
  vec3 ctr_o = pos_rad.xyz;
  float r = pos_rad.w;

  if ( mirrored ) ctr_o.y = -ctr_o.y;

  // Eye location in object space.
  vec3 e_o = vec3(gl_ModelViewMatrixInverse * vec4(0,0,0,1));

  // Vectors from eye to sphere center.
  vec3 ec_o = ctr_o - e_o;  // Eye to Center (of sphere).
  float ec_len = length(ec_o);
  vec3 ne = ec_o / ec_len;

  // Vectors orthogonal to ec_o.
  //
  vec3 atr_o = abs(ec_o);
  int min_idx = atr_o.x < atr_o.y ? ( atr_o.x < atr_o.z ? 0 : 2 )
    : ( atr_o.y < atr_o.z ? 1 : 2 );
  vec3 nx_raw = min_idx == 0 ? vec3(0,-ec_o.z,ec_o.y)
    : min_idx == 1 ? vec3(-ec_o.z,0,ec_o.x) : vec3(-ec_o.y,ec_o.x,0);
  vec3 nx = normalize(nx_raw);
  vec3 ny = cross(ne,nx);

  // Compute center of the limb, lmb_o, the circle formed by the most
  // distant visible parts of the sphere surface.
  float sin_theta = r / ec_len;
  float a = r * sin_theta;
  vec3 lmb_o = ctr_o - a * ne;

  // Compute axes to draw the limb.
  float b = r * sqrt( 1 - sin_theta * sin_theta );
  vec3 ax = b * nx;
  vec3 ay = b * ny;

  mat4 mvp = trans_proj * gl_ModelViewMatrix;

  /// SOLUTION -- Remove original code emitting primitive.
#if 0
  // Emit a bounding square for the limb.
  for ( int i = -1; i < 2; i += 2 )
    for ( int j = -1; j < 2; j += 2 )
      {
        vertex_o = lmb_o + ax * i + ay * j;
        gl_Position = mvp * vec4(vertex_o,1);
        EmitVertex();
      }
  EndPrimitive();
#endif

  mat3 inv_rot = transpose(mat3(sphere_rot[vertex_id]));
  const float two_pi = 2 * 3.14159265359;

#if 1

  for ( int l=0; l<h; l++ )
    {
      float theta = two_pi / h * l;
      float radius_rad = theta / 10;
      vec3 norm_l = vec3(cos(theta),0,sin(theta));
      vec3 norm_o = inv_rot * norm_l;
      lens_ctr_o = ctr_o + r*norm_o;
      lens_front = dot(ec_o,norm_o) < 0;
      // Emit a bounding square for the limb.
      for ( int i = -1; i < 2; i += 2 )
        for ( int j = -1; j < 2; j += 2 )
          {
            vertex_o = lmb_o + ax * i + ay * j;
            gl_Position = mvp * vec4(vertex_o,1);
            EmitVertex();
          }
      EndPrimitive();
    }

#else

  for ( int l=0; l<h; l++ )
    {
      lens_ctr_o = lens_get_ctr_o(l,sphere_info);
      vec3 norm_o = lens_ctr_o - ctr_o;
      lens_front = dot(ec_o,norm_o) < 0;
      // Emit a bounding square for the limb.
      int indices[] = {0, 1, 3, 2};
      for ( int s=0; s<4; s++ )
        {
          vertex_o = lens_get_bb_o(l,indices[s],4,sphere_info);
          gl_Position = mvp * vec4(vertex_o,1);
          EmitVertex();
        }
      EndPrimitive();
    }
#endif
}

#endif


#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  flat int vertex_id;
  vec3 vertex_o;

  /// SOLUTION -- Add variables for lens center and face.
  //
  flat vec3 lens_ctr_o;
  flat bool lens_front;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void fs_main_assigned()
{
  vec4 pos_rad = sphere_pos_rad[vertex_id];
  vec3 ctr_o = pos_rad.xyz;
  float rsq = pos_rad.w * pos_rad.w;
  vec3 e_o = gl_ModelViewMatrixInverse[3].xyz;
  vec3 ef = vertex_o - e_o;   // Eye to fragment.
  vec3 ce = e_o-ctr_o;
  float qfa = dot(ef,ef), qfb = 2 * dot(ef,ce), qfc = dot(ce,ce) - rsq;
  float discr = qfb*qfb - 4 * qfa * qfc;

  if ( discr < 0 ) discard;

  const float pi = 3.14159265359;
  const float two_pi = 2 * pi;
  const bool holes = opt_holes == OHO_Holes;    // If true sphere has holes
  const bool lenses = opt_holes == OHO_Lenses;
  const bool solid = !holes && !lenses;         // If true show complete sphere.

  vec4 sur_o;  // Global surface coördinates (front or back) of sphere.
  vec3 normal_o, sur_l;
  bool front;          // If true, coördinates are of front of sphere.
  float theta, eta;    // Local angular coördinates of sphere.
  bool found_hole = false;

  for ( float dir = -1;  dir <= 1;  dir+=2 ) {
      front = dir == -1;
      float t = ( -qfb + dir * sqrt( discr ) ) / ( 2 * qfa );

      sur_o = vec4(e_o + t * ef, 1);
      normal_o = normalize(sur_o.xyz - ctr_o);

      if ( !front ) normal_o = -normal_o;

      sur_l = normalize(mat3(sphere_rot[vertex_id]) * normal_o);
      theta = atan(sur_l.x,sur_l.z);
      eta = acos(sur_l.y);

      if ( solid ) break;

      const float hole_frac = 0.2;
      const float radians_per_hole_eq = two_pi / opt_n_holes_eqt;
      const float hole_radius = 0.5 * hole_frac * radians_per_hole_eq;

      float eta_hole = round( eta / radians_per_hole_eq ) * radians_per_hole_eq;
      float r = sin(eta_hole);
      const float n_holes = floor( two_pi * r / radians_per_hole_eq );
      if ( n_holes < -1 )
        {
          if ( holes ) break;
          if ( dir == 1 ) discard;
        }

      const float radians_per_hole = two_pi / n_holes;
      float theta_hole = round( theta / radians_per_hole ) * radians_per_hole;
      vec3 hole_dir_l =
        vec3( r * sin(theta_hole), cos(eta_hole), r * cos(theta_hole) );

      float dist = distance(hole_dir_l,sur_l);
      found_hole = dist < hole_radius;
      if ( lenses && found_hole || holes && !found_hole ) break;
      if ( !front ) discard;
    }

  vec3 normal_ee = normalize(gl_NormalMatrix * normal_o);
  vec4 sur_ee = gl_ModelViewMatrix * sur_o;

  // Compute clip-space depth. Take care so that compiler avoids full
  // matrix / vector multiplication.
  vec4 sur_e = gl_ModelViewMatrix * sur_o;
  vec4 sur_c = trans_proj * vec4(0,0,2*sur_e.z,1);
  gl_FragDepth = sur_c.z / sur_c.w;

  vec2 tcoord = vec2( ( 1.5 * pi + theta ) / two_pi, eta / pi );
  vec4 texel = front ? texture(tex_unit_0,tcoord) : vec4(1);
  vec4 color2 = front ? sphere_color[vertex_id] : vec4(0.3,0,0,1);
  gl_FragColor = texel * generic_lighting(sur_ee, color2, normal_ee);
}

void
fs_main()
{
  /// SOLUTION - Pre-final Problem 3b

  vec4 pos_rad = sphere_pos_rad[vertex_id];

  // Center of sphere in original object-space coördinates.
  vec3 ctr_o = pos_rad.xyz;
  float rsq = pos_rad.w * pos_rad.w;

  // Eye location in object-space coördinates.
  vec3 e_o = gl_ModelViewMatrixInverse[3].xyz;

  // Prepare to compute intersection of ray from eye to through fragment with
  // sphere. That intersection is the point on the sphere corresponding
  // to this fragment.
  //
  vec3 ef = vertex_o - e_o;   // Eye to fragment.
  vec3 ce = e_o-ctr_o;
  float qfa = dot(ef,ef);
  float qfb = 2 * dot(ef,ce);
  float qfc = dot(ce,ce) - rsq;
  float discr = qfb*qfb - 4 * qfa * qfc;

  // If outside the limb, return.
  if ( discr < 0 ) discard;

  const float pi = 3.14159265359;
  const float two_pi = 2 * pi;

  vec4 sur_o;  // Global surface coördinates (front or back) of sphere.
  vec3 normal_o, sur_l;
  float theta, eta;    // Local angular coördinates of sphere.

  /// SOLUTION -- No changes made to code above this point ..
  //  .. except for deleting unneeded vars.


  /// SOLUTION - Geometry shader determines which side faces eye.
  //
  bool front = lens_front;

  /// SOLUTION:  Remove loop. Value of dir based on lens_front from geo shader.
  {
    float dir = front ? -1 : 1;

    // Finish computing coordinate of point for this fragment.
    //
    float t = ( -qfb + dir * sqrt( discr ) ) / ( 2 * qfa );

    // Compute true sphere surface coordinate.
    //
    sur_o = vec4(e_o + t * ef, 1);

    // Compute possibly reflected sphere surface coordinate.
    //
    normal_o = normalize(sur_o.xyz - ctr_o);

    //  Reverse normal if this is the back surface of the sphere.
    //
    if ( !front ) normal_o = -normal_o;

    // Use sphere-local coordinates to compute texture coordinates.
    //
    sur_l = normalize(mat3(sphere_rot[vertex_id]) * normal_o);
    theta = atan(sur_l.x,sur_l.z);
    eta = acos(sur_l.y);

    const float hole_frac = 0.4;
    const float radians_per_hole_eq = pos_rad.w * two_pi / h;
    const float hole_radius = 0.5 * hole_frac * radians_per_hole_eq;

    /// SOLUTION -- Removed code computing hole location.
    //  Instead use lens_ctr_o provided by geo shader.
    //
    // Find distance from center of lens to sphere surface point ..
    //
    float dist = distance(lens_ctr_o,sur_o.xyz);
    //
    // .. and check whether surface point is in lens.
    //
    bool found_lens = dist < hole_radius;
    //
    // If this part of the sphere is not visible, we're done.
    //
    if ( !found_lens ) discard;
  }

  /// SOLUTION -- No changes made to code below this point.

  vec3 normal_ee = normalize(gl_NormalMatrix * normal_o);
  vec4 sur_ee = gl_ModelViewMatrix * sur_o;

  // Compute clip-space depth. Take care so that compiler avoids full
  // matrix / vector multiplication.
  vec4 sur_e = gl_ModelViewMatrix * sur_o;
  vec4 sur_c = trans_proj * vec4(0,0,2*sur_e.z,1);
  gl_FragDepth = sur_c.z / sur_c.w;

  vec2 tcoord = vec2( ( 1.5 * pi + theta ) / two_pi, eta / pi );

  // Get filtered texel.
  //
  vec4 texel = front ? texture(tex_unit_0,tcoord) : vec4(1);

  vec4 color = sphere_color[vertex_id];
  vec4 color2 = front ? color : vec4(0.3,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(sur_ee, color2, normal_ee);
}


///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Return lighted color of vertex_e.
  //

  vec3 nspc_color = color.rgb * gl_LightModel.ambient.rgb;
  vec3 spec_color = vec3(0);

  for ( int i=0; i<2; i++ )
    {
      if ( ( lighting_options & ( 1 << i ) ) == 0 ) continue;
      vec4 light_pos = gl_LightSource[i].position;
      vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
      float dist = length(v_vtx_light);
      float dist_vl_inv = 1.0 / dist;
      vec3 v_vtx_l_n = v_vtx_light * dist_vl_inv;

      float d_n_vl = dot(normal_e, v_vtx_l_n);
      float phase_light = max(0,gl_FrontFacing != mirrored ? d_n_vl : -d_n_vl );

      vec3 ambient_light = gl_LightSource[i].ambient.rgb;
      vec3 diffuse_light = gl_LightSource[i].diffuse.rgb;
      float distsq = dist * dist;
      float atten_inv =
        gl_LightSource[i].constantAttenuation +
        gl_LightSource[i].linearAttenuation * dist +
        gl_LightSource[i].quadraticAttenuation * distsq;
      vec3 lighted_color =
        color.rgb
        * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
      nspc_color += lighted_color;

      vec3 h = normalize( v_vtx_l_n - normalize(vertex_e.xyz) );

      spec_color +=
        pow(max(0.0,dot(normal_e,h)),16)
        * color.rgb
        * gl_LightSource[i].specular.rgb / atten_inv;
    }

  return vec4(nspc_color+spec_color,1);
}


#endif
