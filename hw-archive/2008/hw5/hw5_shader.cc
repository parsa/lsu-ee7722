void
vs_ff_vertex(vec4 vtx)
{
  // Transform VTX in the same way fixed functionality would.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vtx;
}

void
vs_lighting(vec4 vtx, vec4 color, vec3 normal)
{
  // Perform lighting calculations VTX, using COLOR and NORMAL.
  //
  // Supposedly a tweak, but this routine doesn't do anything special.

  vec4 vertex_e = gl_ModelViewMatrix * vtx;
  vec3 norm_e = gl_NormalMatrix * normal;
  vec4 light_pos = gl_LightSource[0].position;
  vec4 v_vtx_light = light_pos - vertex_e;
  float phase_light = dot(norm_e, normalize(v_vtx_light).xyz);
  const vec3 ambient = gl_LightSource[0].ambient.rgb;
  const vec3 diffuse = gl_LightSource[0].diffuse.rgb;
  const float dist = length(v_vtx_light);
  const float distsq = dot(v_vtx_light,v_vtx_light);
  const float atten_inv =
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 new_color;
  new_color.rgb = color.rgb * ( phase_light * diffuse / atten_inv + ambient );
  new_color.a = color.a;
  gl_FrontColor = new_color;
}

void
vs_main_lighting()
{
  // Use custom lighting model.
  //
  vs_ff_vertex(gl_Vertex);
  vs_lighting(gl_Vertex,gl_Color,gl_Normal);
}
