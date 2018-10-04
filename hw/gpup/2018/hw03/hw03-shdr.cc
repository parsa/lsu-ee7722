/// LSU EE 4702-1 (Fall 2018), GPU Programming
//

 /// Homework 3
 //

 /// Instructions
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2018/hw03.pdf
 //
 //  Modify code and declarations throughout this file.
 //
 //  This file and hw03.cc will be collected.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

vec4 generic_lighting
(vec4 vertex_e, vec4 color, vec3 normal_e, bool front_facing);


uniform sampler2D tex_unit_0;


// Use these variables to debug your code. Press 'y' to toggle
// tryout.x and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;
layout ( location = 4 ) uniform float tryoutf;


///
/// Shader Input and Output Variables
///


// Declare variables for communication between vertex shader
// and fragment shader.
//
#ifdef _VERTEX_SHADER_

out Data
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 tex_coord;
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 tex_coord;
};

#endif


///
/// Shaders
///

#ifdef _VERTEX_SHADER_
void
vs_main_hw03()
{
  /// Homework 3:  Can put solution here, and other places.

  // Perform basic vertex shading operations.

  // Transform vertex to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space vertex coordinate and normal.
  // These are outputs of the vertex shader and inputs to the frag shader.
  //
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Copy color to output unmodified. Lighting calculations will
  // be performed in the fragment shader.
  //
  gl_BackColor = gl_FrontColor = gl_Color;

  // Copy texture coordinate to output (no need to modify it).
  tex_coord = gl_MultiTexCoord0.xy;
}

void
vs_main_plain()
{
  /// HOMEWORK 3: DO NOT PLACE SOLUTION HERE

  // Perform basic vertex shading operations.

  // Transform vertex to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space vertex coordinate and normal.
  // These are outputs of the vertex shader and inputs to the frag shader.
  //
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Copy color to output unmodified. Lighting calculations will
  // be performed in the fragment shader.
  //
  gl_BackColor = gl_FrontColor = gl_Color;

  // Copy texture coordinate to output (no need to modify it).
  tex_coord = gl_MultiTexCoord0.xy;

  /// HOMEWORK 3: DO NOT PLACE SOLUTION HERE
}

#endif


#ifdef _FRAGMENT_SHADER_
void
fs_main_hw03()
{
  /// Homework 3:  Can put solution here, and other places.

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,tex_coord);

  vec3 nne = normalize(normal_e);

  // Homework 3: This is a placeholder value. It needs to be changed
  // to something based on fragment's position within primitve.
  //
  float edge_dist = 0.1;
  //
  // Range [0,1].  0.5, center of segment; 0, back edge; 1, front edge.

  // Homework 3: This is a placeholder value. It needs to be changed
  // to the correct spiral normal.
  //
  vec3 spiral_normal = vec3(1,0,0);

  // Homework 3: Blend incoming normal with triangular spiral's ormal.
  vec3 bnorm =
    tryout.x
    ? nne
    : edge_dist > 0.9
    ? normalize(mix(nne,spiral_normal,2*(edge_dist-0.9)))
    : edge_dist < 0.1
    ? normalize(mix(-spiral_normal,nne,0.8+2*edge_dist))
    : nne;

  // Compute lighted color of fragment.
  //
  vec4 lighted_color =
    generic_lighting( vertex_e, gl_Color, nne, gl_FrontFacing );

  // Combine filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * lighted_color;

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_plain()
{
  /// HOMEWORK 3: DO NOT PLACE SOLUTION HERE

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,tex_coord);

  // Compute lighted color of fragment.
  //
  vec4 lighted_color =
    generic_lighting( vertex_e, gl_Color, normalize(normal_e), gl_FrontFacing );

  // Combine filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * lighted_color;

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;

  /// HOMEWORK 3: DO NOT PLACE SOLUTION HERE
}
#endif


vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e, bool front_facing)
{
  // Return lighted color of vertex_e.
  //
  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
  float dist = length(v_vtx_light);
  float d_n_vl = dot(normalize(normal_e), v_vtx_light) / dist;
  float phase_light = max(0, front_facing ? d_n_vl : -d_n_vl );

  vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  float distsq = dist * dist;
  float atten_inv =
    0 * gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 lighted_color;
  lighted_color.rgb =
    tryoutf * color.rgb * gl_LightModel.ambient.rgb
    + color.rgb
    * ( tryoutf * ambient_light + phase_light * diffuse_light ) / atten_inv;
  lighted_color.a = color.a;
  return lighted_color;
}
