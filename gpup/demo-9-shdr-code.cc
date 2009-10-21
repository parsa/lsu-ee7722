/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Fragment Shader / Phong Shading Demonstration

// $Id:$

 /// See demo-9-shader.cc for details.


void
vs_ff_vertex(vec4 vtx)
{
  // Transform VTX in the same way fixed functionality would.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vtx;
}

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Perform lighting calculations VTX, using COLOR and NORMAL.
  //

  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos - vertex_e;
  float phase_light = max(0,dot(normal_e, normalize(v_vtx_light).xyz));
  const vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  const vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  const float dist = length(v_vtx_light);
  const float distsq = dist * dist;
  float atten_inv =
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 new_color;
  new_color.rgb =
    color.rgb * gl_LightModel.ambient.rgb
    + color.rgb * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
  new_color.a = color.a;
  return new_color;
}

void
vs_main_lighting()
{
  // Use custom lighting model.
  //
  vs_ff_vertex(gl_Vertex);
  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_FrontColor = generic_lighting(vertex_e,gl_Color,normal_e);
}

varying vec3 var_normal_e;
varying vec4 var_vertex_e;

void
vs_main_phong()
{
  // Use custom lighting model.
  //
  vs_ff_vertex(gl_Vertex);
  var_vertex_e = gl_ModelViewMatrix * gl_Vertex;
  var_normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_BackColor = gl_FrontColor = gl_Color;
}

void
fs_main_phong()
{
  // Note: gl_Color in fragment shader is either gl_FrontColor or gl_BackColor
  // in vertex shader.

  gl_FragColor =
    generic_lighting(var_vertex_e,gl_Color,normalize(var_normal_e));
  gl_FragDepth = gl_FragCoord.z;
}
