/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

 /// Homework 3 - Shader Code
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gpup/2012/hw03.pdf

 /// Your Name:

// Specify version of OpenGL Shading Language.
//
#version 430 compatibility
#extension GL_EXT_geometry_shader4 : enable

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


layout ( location = 2 ) uniform float wire_radius;
layout ( binding = 1 ) buffer Helix_Coord  { vec4  helix_coord[];  };
xuniform sampler2D tex_unit_0;


///
/// Shader Input and Output Variables
///


// Declare variables for communication between vertex shader
// and fragment shader.
//
#ifdef _VERTEX_SHADER_

// Helix Index
//
// A two-element vector.
// The first element is the position along the helix, it ranges from
//   0 to segments_per_helix-1.
// The second element is the position along a circle surrounding the
//   helix (the circle is on the surface of the wire). This element
//   ranges from 0 to seg_per_wire_revolution-1.
//
layout ( location = 1 ) in ivec2 helix_index;

out Data
{
  vec3 normal_e;  // "e" is for eye space.
  vec4 vertex_e;
  ivec2 hidx;
};

out vec2 gl_TexCoord[];  // Redeclaration, to limit size to two elements.

#endif

#ifdef _GEOMETRY_SHADER_

in Data
{
  vec3 normal_e;
  vec4 vertex_e;
  ivec2 hidx;
} In[3];

out Data
{
  vec3 normal_e;
  vec4 vertex_e;
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 normal_e;
  vec4 vertex_e;
};

in vec2 gl_TexCoord[];

#endif


///
/// Shaders
///

#ifdef _VERTEX_SHADER_

void
vs_main_helix()
{
  // Perform basic vertex shading operations, but also:
  //   - Compute wire surface coordinates.
  //
  // Note that this shader only works for the helix.

  // Pass helix index to fragment shader output.
  //
  hidx = helix_index;

  // Compute wire surface location by adding normal to helix coordinate.
  //
  vec4 vertex_o;
  vertex_o.xyz = helix_coord[hidx.x].xyz + wire_radius * gl_Normal;
  vertex_o.w = 1;

  // Transform vertex coordinate to clip space.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;

  // Compute eye-space coordinates for vertex and normal.
  //
  vertex_e = gl_ModelViewMatrix * vertex_o;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Call our lighting routine to compute the lighted color of this
  // vertex.
  //
  gl_FrontColor = gl_Color;

  // Copy texture coordinate to output.
  //
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;

}
#endif

#ifdef _GEOMETRY_SHADER_

void
gs_main_helix()
{
  const bool type_a = In[0].hidx.x < In[2].hidx.x;

  for ( int i=0; i<3; i++ )
    {
      // Pass the other values through unmodified.
      //
      gl_FrontColor = gl_FrontColorIn[i];
      gl_Position = gl_PositionIn[i];
      gl_TexCoord[0] = gl_TexCoordIn[i][0];
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;

      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_helix2()
{
  const bool type_a = In[0].hidx.x < In[2].hidx.x;

  for ( int i=0; i<3; i++ )
    {
      // Pass the other values through unmodified.
      //
      gl_FrontColor = gl_FrontColorIn[i];
      gl_Position = gl_PositionIn[i];
      gl_TexCoord[0] = gl_TexCoordIn[i][0];
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;

      EmitVertex();
    }
  EndPrimitive();
}

#endif


#ifdef _FRAGMENT_SHADER_
void
fs_main_phong()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // If primitive facing user get texel, otherwise assign a reddish shade.
  //
  vec4 texel = gl_FrontFacing
    ? texture(tex_unit_0,gl_TexCoord[0].xy)
    : vec4(0.6,0.1,0.1,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor =
    texel * generic_lighting( vertex_e, gl_Color, normalize(normal_e));

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}
#endif


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
