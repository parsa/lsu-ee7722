/// LSU EE 4702-1 (Fall 2014), GPU Programming
//
 /// Homework 4
 //
 //  Use this file for your solution.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2015/hw04.pdf



// Specify version of OpenGL Shading Language.
//
#version 430 compatibility

layout ( location = 2 ) uniform int tri_cull;

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;



// Array of ball positions.
//
layout ( binding = 1 ) buffer Balls_Pos { vec4 balls_pos_rad[]; };
layout ( binding = 2 ) buffer Balls_Color { vec4 balls_color[]; };



#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;

  // Any changes here must also be made to the fragment shader input.

};


void
vs_main()
{
  // Here, the vertex shader does nothing except pass variables
  // to the geometry shader.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = gl_NormalMatrix * gl_Vertex.xyz;
  color = gl_Color;
}

void
vs_main_instances()
{
  vec4 center_o_rad = balls_pos_rad[gl_InstanceID];
  float rad = center_o_rad.w;
  vec3 to_surface = rad * gl_Vertex.xyz;
  vec4 position_o = vec4(center_o_rad.xyz + to_surface, 1f);

  gl_Position = gl_ModelViewProjectionMatrix * position_o;
  vertex_e = gl_ModelViewMatrix * position_o;
  normal_e = gl_NormalMatrix * gl_Vertex.xyz;
  color = balls_color[gl_InstanceID];
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 3 ) out;

void
gs_main_simple()
{
  /// Problem 1 Solution Here.
  //
  //  Behavior:
  //    When try_cull = 0, emit all triangles.
  //    When try_cull = 1, only emit triangles facing user.
  //    When try_cull = 2, only emit triangles not facing user.

  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      color = In[i].color;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_peel()
{
  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      color = In[i].color;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}


#endif


#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color, normalize(normal_e));

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}


///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Return lighted color of vertex_e.
  //
  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
  float d_n_ve = -dot(normal_e,vertex_e.xyz);
  float d_n_vl = dot(normal_e, normalize(v_vtx_light).xyz);
  bool same_sign = ( d_n_ve > 0 ) == ( d_n_vl > 0 );
  float phase_light = same_sign ? abs(d_n_vl) : 0;

  vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  float dist = length(v_vtx_light);
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

#endif
