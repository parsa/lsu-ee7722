/// LSU EE 4702-1 (Fall 2016), GPU Programming
//
 ///  MIDTERM EXAM SOLUTION
 //
 //   Additional midterm exam solution code in mt.cc.

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
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_TexCoord[0] = gl_MultiTexCoord0;
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
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


 /// SOLUTION -- Problem 2a
//
// (max_vertices changed from 3 to 8. This applies to both 2a and 2c.)
//
layout ( triangle_strip, max_vertices = 8 ) out;

void gs_main_1()
{
  /// MIDTERM EXAM -- Problem 2b
  //
  // Note that this code also has texture coordinates.

  vec2 tc_sum = vec2(0);
  vec3 pt_sum = vec3(0);
  vec3 n_sum = vec3(0);
  for ( int i=0; i<3; i++ )
    {
      pt_sum += In[i].vertex_e.xyz;
      tc_sum += In[i].gl_TexCoord[0];
      n_sum += In[i].normal_e;
    }
  vec4 center_e = vec4( pt_sum/3, 1 );
  vec3 center_norm_e = n_sum/3;
  vec2 tc_c = tc_sum/3;


  /// SOLUTION -- Problem 2b
  //
  //  Compute coordinates of center point in clip space.
  //
  vec4 center_c = gl_ProjectionMatrix * center_e;

  for ( int i=0; i<=3; i++ )
    {
      int idx = i%3;

      vertex_e = center_e;
      normal_e = center_norm_e;
      gl_TexCoord[0] = tc_c;

      /// SOLUTION -- Problem 2b
      //
      //  Assign clip space coordinate to geometry shader output.
      //
      gl_Position = center_c;

      EmitVertex();

      normal_e = In[idx].normal_e;
      vertex_e = In[idx].vertex_e;
      gl_Position = In[idx].gl_Position;
      gl_TexCoord[0] = In[idx].gl_TexCoord[0];
      EmitVertex();
    }
  EndPrimitive();
}


void gs_main_2()
{
  /// MIDTERM EXAM -- Problem 2c
  //
  // Note that this code also has texture coordinates.

  vec2 tc_sum = vec2(0);
  vec3 pt_sum = vec3(0);
  vec3 n_sum = vec3(0);
  for ( int i=0; i<3; i++ )
    {
      pt_sum += In[i].vertex_e.xyz;
      tc_sum += In[i].gl_TexCoord[0];
      n_sum += In[i].normal_e;
    }
  vec3 center_e = pt_sum/3;
  vec3 center_norm_e = n_sum/3;
  vec2 tc_c = tc_sum/3;

  for ( int i=0; i<=3; i++ )
    {
      int idx = i%3;

      /// SOLUTION -- Problem 2c
      //
      vec3 ctr_to_vtx = In[idx].vertex_e.xyz - center_e;
      vertex_e = vec4( center_e + 0.5 * ctr_to_vtx, 1 );
      // Note: The commented out line below is equivalent to the one above.
      // vertex_e = vec4( ( center_e + In[idx].vertex_e.xyz ) * 0.5, 1 );

      normal_e = ( center_norm_e + In[idx].normal_e ) * 0.5;
      gl_TexCoord[0] = ( tc_c + In[idx].gl_TexCoord[0] ) * 0.5;

      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      normal_e = In[idx].normal_e;
      vertex_e = In[idx].vertex_e;
      gl_Position = In[idx].gl_Position;
      gl_TexCoord[0] = In[idx].gl_TexCoord[0];
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
fs_main()
{
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
