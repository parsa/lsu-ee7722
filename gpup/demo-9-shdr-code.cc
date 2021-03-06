/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 /// Fragment Shader / Phong Shading Demonstration

 /// See demo-9-shader.cc for details.


// Specify version of OpenGL Shading Language.
//
#version 460 compatibility


vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e, bool front);

#define USE_MATERIAL_COLOR


layout ( location = 1 ) uniform vec4 material_color;


///
/// Vertex-Shader Only Code -- "Lighting" Program
///


// Declare variables for communication between vertex shader
// and fragment shader.
//
#ifdef _VERTEX_SHADER_

// Declare some outputs as a group. These are grouped together
// because they are used by the generic lighting routine.
//
out VF_Generic_Lighting
  {
    vec3 normal_e;
    vec4 vertex_e;
  } GLiO; // Generic Lighting Output Block

// Re-declare pre-defined gl_TexCoord as a vec3.
out vec2 gl_TexCoord[];

#endif

#ifdef _FRAGMENT_SHADER_

in VF_Generic_Lighting
  {
    vec3 normal_e;
    vec4 vertex_e;
  } GLiI; // Generic Lighting Input Block

in vec2 gl_TexCoord[];  // Declaring this is optional, since it's predefined.

uniform sampler2D tex_unit_0;
#endif

 // Entry Point for Vertex Shader Code
//
#ifdef _VERTEX_SHADER_
void
vs_main_lighting()
{
  /// Pre-Defined Inputs
  //
  // gl_Vertex, gl_Normal, gl_Color
  //
  // (storage qualifier "in") (Compatibility Profile)
  // See OGSL Spec 4.6 Section 7.2

  /// Pre-Defined Outputs
  //
  // gl_Position, gl_FrontColor, etc.
  //
  // (storage qualifier "out")

  /// Pre-Defined Uniforms 
  //
  // gl_ModelViewMatrix, gl_NormalMatrix, gl_ModelViewProjectionMatrix, ..
  //
  // (storage qualifier uniform) (Compatibility Profile)
  // See OGSL Spec 4.6 Section 7.4.1

  // Transform vertex coordinate to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space coordinates for vertex and normal.
  //
  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);

#ifdef USE_MATERIAL_COLOR
  vec4 our_color = material_color;
#else
  vec4 our_color = gl_Color;
#endif

  // Call our lighting routine to compute the lighted color of this
  // vertex.
  //
  gl_FrontColor = generic_lighting(vertex_e,our_color,normal_e,true);
  gl_BackColor = generic_lighting(vertex_e,our_color,normal_e,false);

  // Copy texture coordinate to output (no need to modify it).
  // Only copy x and y components since it's a 2D texture.
  //
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}
#endif

///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e, bool front_facing)
{
  // See OpenGL 4.5 Section 12.2.1.1 for a lighting formula.
  //
  // Return lighted color of vertex_e.
  //
  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
  float dist = length(v_vtx_light);
  float d_n_vl = dot(normalize(normal_e), v_vtx_light) / dist;
  float phase_light = max(0,front_facing ? d_n_vl : -d_n_vl );

  vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  float distsq = dist * dist;
  float atten_inv =
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 lighted_color;
  lighted_color.rgb =
    color.rgb * gl_LightModel.ambient.rgb
    + color.rgb * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
  lighted_color.a = color.a;
  return lighted_color;
}


///
/// Vertex & Fragment Shader Code
///


#ifdef _VERTEX_SHADER_
void
vs_main_phong()
{
  // Transform vertex to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space vertex coordinate and normal.
  // These are outputs of the vertex shader and inputs to the frag shader.
  //
  GLiO.vertex_e = gl_ModelViewMatrix * gl_Vertex;
  GLiO.normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Copy color to output unmodified. Lighting calculations will
  // be performed in the fragment shader.
  //
#ifndef USE_MATERIAL_COLOR
  gl_BackColor = gl_FrontColor = gl_Color;
#endif

  // Copy texture coordinate to output (no need to modify it).
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}
#endif

#ifdef _FRAGMENT_SHADER_
void
fs_main_phong()
{
  // Note: gl_Color in fragment shader is either gl_FrontColor or gl_BackColor
  // in vertex shader.

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0].xy);

#ifdef USE_MATERIAL_COLOR
  vec4 our_color = material_color;
#else
  vec4 our_color = gl_Color;
#endif

  // Normalize because interpolation does not preserve length.
  //
  vec3 nnormal_e = normalize(GLiI.normal_e);

  vec4 lighted_color =
    generic_lighting( GLiI.vertex_e, our_color, nnormal_e, gl_FrontFacing );

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * lighted_color;

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}
#endif
