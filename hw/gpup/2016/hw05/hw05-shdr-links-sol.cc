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

  /// SOLUTION -- Problem 1
  float theta;
};


void
vs_main()
{
  /// Problem 1 solution here and other places.

  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_TexCoord[0] = gl_MultiTexCoord0;

  /// SOLUTION -- Problem 1
  //
  //  Move theta to newly declared vertex shader output and re-construct
  //  the object space vertex coordinate in vtx_o
  //
  theta = gl_Vertex.w;
  vec4 vtx_o = vec4(gl_Vertex.xyz,1);
  gl_Position = gl_ModelViewProjectionMatrix * vtx_o;
  vertex_e = gl_ModelViewMatrix * vtx_o;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 gl_Position;

  /// SOLUTION -- Problem 1
  //
  // Carry theta value to GS where it will be used to determine if
  // triangles should be discarded.
  float theta;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];

  /// SOLUTION -- Problem 2
  flat vec3 normal_f;
  flat bool is_side;
  float height;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
 /// SOLUTION -- Problem 2
//
// Specify just enough vertices to render triangle (3) and sides (2*4=8)
//
layout ( triangle_strip, max_vertices = 11 ) out;


void
gs_main_1()
{

  /// SOLUTION -- Problem 1
  //
  //  Discard primitives in which the provoking vertex is a theta = 0,
  //  because for those primitives vertex In[0] belongs to a previous
  //  segment.
  //
  if ( In[2].theta == 0 ) return;

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

  /// SOLUTION -- Problem 2

  // Compute offset, the vector to use to raise the triangle.
  //
  vec3 v01 = In[1].vertex_e.xyz - In[0].vertex_e.xyz;
  vec3 v02 = In[2].vertex_e.xyz - In[0].vertex_e.xyz;
  vec3 norm = normalize(cross( v01, v02 ));
  vec3 offset = thickness * norm;

  is_side = true;

  // Raise one out of every eight triangles.
  //
  const bool raised = ( gl_PrimitiveIDIn & 0x3 ) == 0;

  // Draw Side Triangles
  //
  // Side triangles are drawn as one triangle strip. Note that In[0]
  // is examined for the first (i=0) and last (i=3) iteration of the loop.
  //
  if ( raised )
  for ( int i=0; i<=3; i++ )
    {
      const int this_vtx_idx = i % 3;
      const int prev_vtx_idx = ( i + 2 ) % 3;

      // Use same texture coordinate for surface and raised vertices.
      //
      gl_TexCoord[0] = In[this_vtx_idx].gl_TexCoord[0];

      vec4 vertex_e_surface = In[this_vtx_idx].vertex_e;
      vec4 vertex_e_raised = vertex_e_surface + vec4(offset,0);
      vec4 vertex_e_prev = In[prev_vtx_idx].vertex_e;

      // Compute normal of side triangles and assign to flat normal output.
      //
      vec3 v_this_prev = vertex_e_prev.xyz - vertex_e_surface.xyz;
      normal_f = cross(norm,v_this_prev);

      // Emit side triangle vertex at raised triangle.
      //
      height = 1;
      vertex_e = vertex_e_raised;
      gl_Position = gl_ProjectionMatrix * vertex_e_raised;
      EmitVertex();

      // Emit side triangle vertex at surface.
      //
      height = 0;
      vertex_e = vertex_e_surface;
      gl_Position = In[this_vtx_idx].gl_Position;
      EmitVertex();
    }
  EndPrimitive();

  is_side = false;
  height = raised ? 1 : 0;

  // Emit either a raised or surface triangle.
  //
  for ( int i=0; i<3; i++ )
    {
      normal_e = normalize(In[i].normal_e);
      vertex_e = In[i].vertex_e + ( raised ? vec4(offset,0) : vec4(0) );
      gl_Position = gl_ProjectionMatrix * vertex_e;
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

  /// SOLUTION -- Problem 2
  flat vec3 normal_f;  // Declare flat so normal is the same on whole triangle.
  flat bool is_side;
  float height;
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

  /// SOLUTION -- Problem 2
  float marg = 0.333;
  float omm = 1 - marg;  // One Minus Margin

  vec4 color2 = !gl_FrontFacing ? color_back :
    height > omm ? ( ( height - omm ) * color_top
                     + ( 1.0 - height ) * color_side ) / marg :
    height < marg ? ( height * color_side
                     + ( marg - height ) * color_bottom ) / marg :
    color_side;

  // Compute a texture blend amount and apply it to texel.
  float tblend = 2 * abs(height-0.5);
  vec4 texel2;
  texel2.xyz = vec3(1-tblend) + tblend*texel.xyz;
  texel2.w = 1;

  /// SOLUTION -- Problem 2
  //
  vec3 norm = is_side ? normal_f : normal_e;

  // Multiply filtered texel color with lighted color of fragment.
  //
  /// SOLUTION
  gl_FragColor = texel2 * generic_lighting(vertex_e, color2, norm);

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
