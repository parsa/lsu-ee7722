/// LSU EE 4702-1 (Fall 2018), GPU Programming
//

// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

//  #extension GL_EXT_geometry_shader : enable

vec4 generic_lighting
(vec4 vertex_e, vec4 color, vec3 normal_e, bool front_facing);


uniform sampler2D tex_unit_0;


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
vs_main()
{
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

#endif

#ifdef _GEOMETRY_SHADER_

#endif


#ifdef _FRAGMENT_SHADER_
void
fs_main()
{
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
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 lighted_color;
  lighted_color.rgb =
    color.rgb * gl_LightModel.ambient.rgb
    + color.rgb
    * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
  lighted_color.a = color.a;
  return lighted_color;
}
