/// LSU EE 4702-1 (Fall 2019), GPU Programming
//
 /// Homework 3
//
//   Solution goes in this file and in hw03.cc

// Specify version of OpenGL Shading Language.
//
#version 460 compatibility


// Use this variable, tryout, to debug your code. Press 'y' to toggle
// tryout.x and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec3 tryout;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 4 ) uniform float tryoutf;

layout ( location = 5 ) uniform vec4 color_diamond;
layout ( location = 6 ) uniform vec4 color_edge;


layout ( location = 7 ) uniform vec4 hw03_scalars1;
layout ( location = 8 ) uniform vec4 ctr0;


/// Code for Strip-Plus Shaders Immediately Below
//  (Code for points shaders further below.)

#ifndef HW03_POINTS

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
vs_strip_plus()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = gl_NormalMatrix * gl_Normal;
  color = gl_Color;
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
gs_strip_plus()
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

/// Code for Strip-Plus Shaders Above

#else

/// Code for Points Shaders Below 


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
vs_points()
{
  int vid = gl_VertexID;

  // Be sure to remove unneeded code. You can remove this comment too.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  color = gl_Color;
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
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 3 ) out;


void
gs_points()
{
#ifdef xxxx
  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      color = In[i].color;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
#endif
}

#endif

/// Code for Points Shaders Above

#endif


/// Code below is common to all problems.

#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}


///
/// Routine used by Either Vertex or Fragment Shader
///

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
