/// LSU EE 4702-1 (Fall 2016), GPU Programming
//
 /// Homework 5
 //
 //  See http://www.ece.lsu.edu/koppel/gpup/2016/hw05.pdf

 /// Use this file for your solution.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

layout ( location = 1 ) uniform vec4 color_bottom;
layout ( location = 2 ) uniform vec4 color_back;
layout ( location = 4 ) uniform vec4 color_side;
layout ( location = 5 ) uniform vec4 color_top;
layout ( location = 6 ) uniform ivec2 seg_sides;
layout ( location = 7 ) uniform float thickness;

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle tryout.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;



#ifdef _VERTEX_SHADER_

in vec2 gl_MultiTexCoord0;

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 gl_Position;

};


void
vs_main()
{
  /// Problem 1 solution here and other places.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_TexCoord[0] = gl_MultiTexCoord0;

}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 gl_Position;

} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 3 ) out;


void
gs_main_1()
{
  /// Problem 1 solution goes here, and other places.

  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_2()
{
  /// Problem 2 solution goes here, and other places.

  // Don't a render triangle for first two vertices of a segment since
  // such a triangle would cross between segments. Note: this is an
  // alternative method of fixing the issue described in Problem 1.
  //
  int vtx_num = gl_PrimitiveIDIn + 2;
  int side_num = vtx_num % ( 2 * seg_sides.y );
  if ( side_num < 2 ) return;

  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      EmitVertex();
    }
  EndPrimitive();
}



#endif


#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main_1()
{
  /// Do not modify this module. Use fs_main_2 for Problem 2

  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel, unless the fragment belongs to an edge primitive.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0]);

  vec4 color2 = gl_FrontFacing ? color_bottom : color_back;

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_2()
{
  /// Problem 2 solution goes here and other places.

  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel, unless the fragment belongs to an edge primitive.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0]);

  vec4 color2 = gl_FrontFacing ? color_bottom : color_back;

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(vertex_e, color2, normal_e);

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
  /// It should not be necessary to modify this module for Homework 5.

  // Return lighted color of vertex_e.
  //
  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
  float dist = length(v_vtx_light);

  float d_n_vl = dot(normalize(normal_e), v_vtx_light) / dist;
  float phase_light = max(0,gl_FrontFacing ? d_n_vl : -d_n_vl );

  vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  float distsq = dist * dist;
  float atten_inv =
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 lighted_color;
  lighted_color.rgb =
    color.rgb * gl_LightModel.ambient.rgb
    + 0.3 * color.rgb
    * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
  lighted_color.a = color.a;
  return lighted_color;
}


#endif
