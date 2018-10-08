/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 /// Fragment Shader / Phong Shading Demonstration

 /// See demo-9-shader.cc for details.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility


vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e, bool front);

out vec2 gl_TexCoord[];  // Declaring this is optional, since it's predefined.

 // Entry Point for Vertex Shader Code
//
void
vs_main_lighting()
{
  /// Pre-Defined Inputs in Compatibility Profile
  //
  // gl_Vertex, gl_Normal, gl_Color
  //
  // (storage qualifier "in") (Compatibility Profile)
  // See OGSL Spec 4.5 Section 7.2
  //
  // ( None of these are in the regular profile.
  //    Instead: gl_VertexID, gl_InstanceID )

  /// Pre-Defined Outputs in Compatibility Profile
  //
  // gl_Position, gl_FrontColor, etc.
  //
  // (storage qualifier "out")
  //

  /// Pre-Defined Uniforms 
  //
  // gl_ModelViewMatrix, gl_NormalMatrix, gl_ModelViewProjectionMatrix, ..
  //
  // (storage qualifier uniform) (Compatibility Profile)
  // See OGSL Spec 4.3 Section 7.4.1

  // Transform vertex coordinate to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space coordinates for vertex and normal.
  //
  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);


  // Call our lighting routine to compute the lighted color of this
  // vertex.
  //
  gl_FrontColor = generic_lighting(vertex_e,gl_Color,normal_e,true);
  gl_BackColor = generic_lighting(vertex_e,gl_Color,normal_e,false);

  // Copy texture coordinate to output (no need to modify it).
  // Only copy x and y components since it's a 2D texture.
  //
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}


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
