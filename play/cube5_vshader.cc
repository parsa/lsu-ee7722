
void
main()
{
  // Input: gl_Vertex, gl_Normal
  // Output: gl_Position, gl_PointSize, gl_ClipVertex
  vec4 pvertex;
  pvertex.xyz = gl_Vertex.xyz;
  pvertex.w = gl_Vertex.w;

  gl_Position = gl_ModelViewProjectionMatrix * pvertex;
  gl_TexCoord[0] = gl_MultiTexCoord0;
  vec4 vertex_e = gl_ModelViewMatrix * gl_Vertex;
  vec3 norm_e = gl_NormalMatrix * gl_Normal;
  vec4 light_pos = gl_LightSource[0].position;
  float phase = abs(dot(norm_e, normalize(light_pos - vertex_e).xyz));

  const float ambient = 0.2;
  vec4 new_color;
  new_color.rgb = gl_Color.rgb * phase * ( 1.0 - ambient );
  new_color.a = gl_Color.a;
  new_color.rgb = new_color.rgb + gl_Color.rgb * ambient;
  gl_BackColor = gl_FrontColor = new_color;
}
