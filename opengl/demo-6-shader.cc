void
vs_ff_vertex(vec4 vtx)
{
  // Transform VTX in the same way fixed functionality would.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vtx;
  gl_TexCoord[0] = gl_MultiTexCoord0;
}

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Perform lighting calculations VTX, using COLOR and NORMAL.
  //
  // Supposedly a tweak, but this routine doesn't do anything special.

  vec4 light_pos = gl_LightSource[0].position;
  vec4 v_vtx_light = light_pos - vertex_e;
  float phase_light = dot(normal_e, normalize(v_vtx_light).xyz);
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

uniform sampler2D sam_1;

varying vec3 var_normal_e;
varying vec4 var_vertex_e;
varying vec4 var_color;

void
vs_main_phong()
{
  // Use custom lighting model.
  //
  vs_ff_vertex(gl_Vertex);
  var_vertex_e = gl_ModelViewMatrix * gl_Vertex;
  var_normal_e = normalize(gl_NormalMatrix * gl_Normal);
  var_color = gl_Color;
}

void
fs_main_phong()
{
  vec4 base_color =
    generic_lighting(var_vertex_e,var_color,normalize(var_normal_e));
  vec4 texel = texture2D(sam_1,gl_TexCoord[0].xy);
  gl_FragDepth = gl_FragCoord.z;
  gl_FragColor.rgb = texel.rgb * base_color.rgb;
  gl_FragColor.a = texel.a;
}
