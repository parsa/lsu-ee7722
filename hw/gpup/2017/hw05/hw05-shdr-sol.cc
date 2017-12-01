/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Homework 5 -- SOLUTION

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2017/hw05.pdf
 //
 ///  Put the solution in this file.
 //   To solve the problem code in hw05.cc needs to be inspected.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

// The _GEOMETRY_SHADER_ define is put there by code in shader.h.
//
#ifdef _GEOMETRY_SHADER_
#extension GL_EXT_geometry_shader4 : enable
#endif

 // ----------------------------------------------------------------------------
 /// PROBLEM 1 - 3      ↓↓  Code can be placed below.   ↓↓


layout ( location = 1 ) uniform bvec2 opt_debug;
layout ( location = 2 ) uniform int lighting_options;

 /// SOLUTION?

layout ( location = 3 ) uniform float world_time;

layout ( binding = 1 ) buffer b1 { vec4 pt_00s[]; };
layout ( binding = 2 ) buffer b2 { vec4 axs[]; };
layout ( binding = 3 ) buffer b3 { vec4 ays[]; };
layout ( binding = 4 ) buffer b4 { vec4 colors[]; };
layout ( binding = 5 ) buffer b5 { vec4 tact_pos_times[]; };


#ifdef _VERTEX_SHADER_

 /// PROBLEM 1 - 3       ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------


#ifndef _PROBLEM_2_

 // ----------------------------------------------------------------------------
 /// PROBLEM 1 and 3   ↓↓  Code can be placed below.   ↓↓


// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the geometry shader input.
};

void
vs_main_tiles_0()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  color = gl_Color;
}

void
vs_main_tiles_1()
{
  //  vs_main_tiles_0();

  /// SOLUTION
  vertex_e = gl_Vertex;
  color = gl_Color;
}

 /// PROBLEM 1  and 3   ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------
#else
 // ----------------------------------------------------------------------------
 /// PROBLEM 2 and 3    ↓↓  Code can be placed below.   ↓↓

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the geometry shader input.
  /// SOLUTION
  int vertex_id;
};

void
vs_main_tiles_2()
{
  //  vs_main_tiles_0();

  /// SOLUTION
  vertex_id = gl_VertexID;
}

#endif

 /// PROBLEM 2 and 3          ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------

#endif

 // ----------------------------------------------------------------------------
 /// PROBLEM 1 - 3             ↓↓  Code can be placed below.   ↓↓


#ifdef _GEOMETRY_SHADER_

out Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;

  /// SOLUTION
  flat vec4 tact_pos_time_e;
};

 /// PROBLEM 1 - 3           ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------

#ifndef _PROBLEM_2_

 // ----------------------------------------------------------------------------
 /// PROBLEM 1 and 3     ↓↓  Code can be placed below.   ↓↓

 /// Problem 1 Solution Code

// Interface block for vertex shader output / geometry shader input.
//
in Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the vertex shader output.
} In[3];


// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
 /// SOLUTION
layout ( triangle_strip, max_vertices = 4 ) out;



void
gs_main_tiles_0()
{
  /// Do not put solution here.  Use this file for comparison or minor experiments.
  //  Instead, make geometry shader changes to gs_main_p1.

  // Color and normal will be the same for each vertex.
  normal_e = In[0].normal_e;
  color = In[0].color;

  for ( int i=0; i<3; i++ )
    {
      // Pass along values unchanged.
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_tiles_1()
{
  //  gs_main_tiles_0();

  /// SOLUTION

  vec4 vtx_o[4];
  vec4 pt_00 = In[0].vertex_e;
  vec4 ax_o = vec4(In[1].vertex_e.xyz,0);
  vec4 ay_o = vec4(In[2].vertex_e.xyz,0);

  vtx_o[0] = pt_00;
  vtx_o[1] = pt_00 + ax_o;
  vtx_o[2] = pt_00 + ay_o;
  vtx_o[3] = pt_00 + ay_o + ax_o;
  vec3 normal_o = normalize(cross(ax_o.xyz,ay_o.xyz));
  normal_e = normalize(gl_NormalMatrix * normal_o);
  color = In[0].color;

  for ( int i=0; i<4; i++ )
    {
      gl_Position = gl_ModelViewProjectionMatrix * vtx_o[i];
      vertex_e = gl_ModelViewMatrix * vtx_o[i];
      EmitVertex();
    }
  EndPrimitive();
}

 /// PROBLEM 1 and 3     ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------

#else

 // ----------------------------------------------------------------------------
 /// PROBLEM 2 and 3     ↓↓  Code can be placed below.   ↓↓

// Interface block for vertex shader output / geometry shader input.
//
in Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the vertex shader output.

  /// SOLUTION
  int vertex_id;

} In[1];


// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
 /// SOLUTION
layout ( triangle_strip, max_vertices = 4 ) out;

void
gs_main_tiles_2()
{
  //  gs_main_tiles_0();


  /// SOLUTION
  int vertex_id = In[0].vertex_id;
  vec4 vtx_o[4];
  vec4 pt_00 = pt_00s[vertex_id];
  vec4 ax_o = vec4(axs[vertex_id].xyz,0);
  vec4 ay_o = vec4(ays[vertex_id].xyz,0);

  vtx_o[0] = pt_00;
  vtx_o[1] = pt_00 + ax_o;
  vtx_o[2] = pt_00 + ay_o;
  vtx_o[3] = pt_00 + ay_o + ax_o;
  vec3 normal_o = normalize(cross(ax_o.xyz,ay_o.xyz));

  vec4 tact_pos_time = tact_pos_times[vertex_id];
  tact_pos_time_e = gl_ModelViewMatrix * vec4(tact_pos_time.xyz,1);
  tact_pos_time_e.w = tact_pos_time.w;

  normal_e = normalize(gl_NormalMatrix * normal_o);
  color = colors[vertex_id];

  for ( int i=0; i<4; i++ )
    {
      gl_Position = gl_ModelViewProjectionMatrix * vtx_o[i];
      vertex_e = gl_ModelViewMatrix * vtx_o[i];
      EmitVertex();
    }
  EndPrimitive();


}


 /// PROBLEM 2 and 3      ↑↑   Code can be placed above.   ↑↑
 // ----------------------------------------------------------------------------

#endif

#endif

 // ----------------------------------------------------------------------------
 /// PROBLEM 1 - 3        ↓↓  Code can be placed below.   ↓↓



#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;

  /// SOLUTION
  flat vec4 tact_pos_time_e;

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);

void
fs_main_tiles_0()
{
  /// Do not put solution here. Use this for minor experiments.
  //

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_tiles_1()
{
  fs_main_tiles_0();
}

void
fs_main_tiles_2()
{
  //  fs_main_tiles_0();

  /// SOLUTION

  float age = world_time - tact_pos_time_e.w;
  float speed = 0.5;
  float base_width = 0.05;
  float width = base_width + age * speed / 8;
  float dist = distance(vertex_e.xyz,tact_pos_time_e.xyz);
  float radius_0 = age * speed - width;
  float radius_1 = age * speed;
  float radius_2 = radius_1 + width;
  bool ring = dist >= radius_0 && dist <= radius_2;
  float sat = ring ? 1/(1+age) : 0;

  gl_FragColor = generic_lighting
    (vertex_e, mix(color, vec4(1,0,0,1),sat), normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;

}


vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_er)
{
  // Return lighted color of vertex_e.
  //
  vec3 nspc_color = color.rgb * gl_LightModel.ambient.rgb;
  vec3 spec_color = vec3(0);
  vec3 normal_e = normalize(normal_er);

  for ( int i=0; i<2; i++ )
    {
      if ( ( lighting_options & ( 1 << i ) ) == 0 ) continue;
      vec4 light_pos = gl_LightSource[i].position;
      vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
      float dist = length(v_vtx_light);
      float dist_vl_inv = 1.0 / dist;
      vec3 v_vtx_l_n = v_vtx_light * dist_vl_inv;

      float d_n_vl = dot(normal_e, v_vtx_l_n);
      float phase_light = max(0,gl_FrontFacing ? d_n_vl : -d_n_vl );

      vec3 ambient_light = gl_LightSource[i].ambient.rgb;
      vec3 diffuse_light = gl_LightSource[i].diffuse.rgb;
      float distsq = dist * dist;
      float atten_inv =
        gl_LightSource[i].constantAttenuation +
        gl_LightSource[i].linearAttenuation * dist +
        gl_LightSource[i].quadraticAttenuation * distsq;
      vec3 lighted_color =
        color.rgb
        * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
      nspc_color += lighted_color;

      vec3 h = normalize( v_vtx_l_n - normalize(vertex_e.xyz) );

      spec_color +=
        pow(max(0.0,dot(normal_e,h)),16)
        * color.rgb
        * gl_LightSource[i].specular.rgb / atten_inv;
    }

  return vec4(nspc_color+spec_color,1);
}

#endif


