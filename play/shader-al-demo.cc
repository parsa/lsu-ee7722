
// Compile command.
//  cgc -profile arbvp1 -oglsl -entry vs_main -o try.s shader-al-demo.cc

void
vs_ff_vertex()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}


void
vs_lighting(vec4 o_point)
{
  // Input: gl_Vertex, gl_Normal
  // Output: gl_Position, gl_PointSize, gl_ClipVertex
  vec4 vertex_e = gl_ModelViewMatrix * o_point;
  vec3 norm_e = gl_NormalMatrix * gl_Normal;
  vec4 light_pos = gl_LightSource[1].position;
  float phase_light = dot(norm_e, normalize(light_pos - vertex_e).xyz);
  float phase_user = dot(norm_e, -vertex_e.xyz);
  float phase = sign(phase_light) == sign(phase_user) ? abs(phase_light) : 0.0;
  const vec3 ambient = gl_LightSource[1].ambient.rgb;
  const vec3 diffuse = gl_LightSource[1].diffuse.rgb;
  vec4 new_color;
  new_color.rgb = gl_Color.rgb * ( phase * diffuse + ambient );
  new_color.a = gl_Color.a;
  gl_FrontColor = new_color;
  gl_BackColor = gl_Color;
}


void
vs_main()
{
  vs_ff_vertex();
  vs_lighting(gl_Vertex);
}

