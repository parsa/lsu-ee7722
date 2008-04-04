
void
vs_ff_vertex()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}

// void
// vs_ff_clip()
// {
//   for ( int i = 0; i < gl_MaxClipPlanes; i++ )
//     {
//       vec4 clip_plane = gl_ClipPlane[i];
      
//     }

// }

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
vs_texgen(vec4 o_point)
{
  gl_TexCoord[0] = 
    vec4(dot(gl_ObjectPlaneS[0],o_point),dot(gl_ObjectPlaneT[0],o_point),0,1);
}

void
vs_main_lighting()
{
  vs_ff_vertex();
  vs_texgen(gl_Vertex);
  vs_lighting(gl_Vertex);
}

attribute vec3 bump_info;
attribute vec4 pinnacle;

void
vs_main_circle()
{
  const float theta = gl_Vertex.x;
  const float radius = bump_info.z;
  vec4 o_point = vec4(bump_info.xy,0,1);
  o_point.xy += radius * vec2( cos(theta), sin(theta) );
  gl_Position = gl_ModelViewProjectionMatrix * o_point;
  vs_texgen(o_point);
  vs_lighting(o_point);
}

void
vs_main_bump()
{
  const float theta = gl_Vertex.x;
  const float eta = gl_Vertex.y;
  const float radius = pinnacle.w;  pinnacle.w = 1.0;
  const float rlen_n = 0.5 * ( sin(eta)<0.0?2.0-cos(eta):cos(eta));
  const float rlen = radius * rlen_n;
  vec4 v_planar = rlen * vec4( cos(theta), sin(theta), 0, 0 );
  vec4 v_non_planar = vec4(pinnacle.xyz * (1.0+sin(eta)),0);
  vec4 o_point = vec4(bump_info.xy,0,1) + v_planar + v_non_planar;
  gl_Position = gl_ModelViewProjectionMatrix * o_point;
  vec4 t_point = vec4(bump_info.xy,0,1) + v_planar;
  vec3 vtheta = (rlen+0.001) * vec3(-sin(theta),cos(theta),0);
  vec3 veta =
    normalize(-abs(sin(eta)) * radius * vec3(cos(theta),sin(theta),0)
              + cos(eta) * pinnacle.xyz);
  vec3 normal = normalize(cross(vtheta,veta));
  
  gl_Color.a = 1.0 - abs(veta.z) * 0.8;
  gl_Color.rgb = gl_Color.rgb * ( 1.0 - rlen_n ) + rlen_n;
  
  gl_Normal = normal;
  vs_texgen(t_point);
  vs_lighting(o_point);
}
