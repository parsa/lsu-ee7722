/// LSU EE 4702-1 (Fall 2015), GPU Programming
//
 /// Homework 4 -- SOLUTION
 //
 //  Use this file for your solution.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2015/hw04.pdf



// Specify version of OpenGL Shading Language.
//
#version 430 compatibility

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;


// Array of ball positions.
//
layout ( binding = 1 ) buffer Balls_Pos { vec4 balls_pos_rad[]; };
layout ( binding = 2 ) buffer Balls_Color { vec4 balls_color[]; };

 /// SOLUTION -- Problem 2
layout ( binding = 3 ) buffer Links_Color { vec4 links_color[]; };

#ifdef _VERTEX_SHADER_

in ivec2 gl_Vertex;

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  ivec2 indices;

  /// SOLUTION -- Problem 2
  //
  //  Replace vec4 color with int vtx_id;
  int vtx_id;
};


void
vs_main()
{
  // Here, the vertex shader does nothing except pass variables
  // to the geometry shader.

  indices = gl_Vertex;

  /// SOLUTION -- Problem 2
  //
  //  Transfer vertex id
  vtx_id = gl_VertexID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  ivec2 indices;

  /// SOLUTION -- Problem 2
  //  Replace color with vtx_id.
  int vtx_id;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  /// SOLUTION -- Problem 2
  //  Replace color with vtx_id.
  flat int vtx_id;
};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 42 ) out;

void
gs_main_links()
{
  vec4 pos_rad1 = balls_pos_rad[In[0].indices.x];
  vec4 pos_rad2 = balls_pos_rad[In[0].indices.y];
  vec3 pos1 = pos_rad1.xyz;
  vec3 pos2 = pos_rad2.xyz;
  float radius = pos_rad1.w * 0.3;
  vec3 v12 = pos2 - pos1;
  vec3 vna =
    normalize(v12.x == 0 ? vec3(0,-v12.z,v12.y) : vec3(-v12.y,v12.x,0));
  vec3 vnb = normalize(cross(v12,vna));
  mat4 to_obj;
  to_obj[0] = vec4(radius * vna, 0);
  to_obj[1] = vec4(radius * vnb, 0);
  to_obj[2] = vec4(v12, 0);
  to_obj[3] = vec4(pos1,1);
  mat4 mv = gl_ModelViewMatrix * to_obj;
  mat4 mvp = gl_ModelViewProjectionMatrix * to_obj;
  vec4 pos1_e = gl_ModelViewMatrix * vec4(pos1,1);

  const int sides = 20;
  const float M_PI = 3.1415926535f;
  const float delta_theta = 2 * M_PI / sides;

  /// SOLUTION -- Problem 2
  //  Replace color with vtx_id.
  vtx_id = In[0].vtx_id;
  for ( int i=0; i<=sides; i++ )
    {
      const float theta = delta_theta * i;
      const float cos_t = cos(theta);
      const float sin_t = sin(theta);
      for ( int j=0; j<2; j++ )
        {
          vec4 p1 = vec4( cos_t, sin_t, j, 1 );
          vertex_e = mv * p1;
          if ( j == 0 ) normal_e = vertex_e.xyz - pos1_e.xyz;
          gl_Position = mvp * p1;
          EmitVertex();
        }
    }
  EndPrimitive();
}

#endif


#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  /// SOLUTION -- Problem 2
  //  Replace color with vtx_id.
  flat int vtx_id;

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  /// SOLUTION -- Problem 2
  //  Use vtx_id to retrieve color.
  //
  vec4 color = links_color[vtx_id];

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
