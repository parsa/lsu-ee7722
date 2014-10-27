/// LSU EE 4702-1 (Fall 2014), GPU Programming
//

// $Id:$

 /// See demo-10-shader.cc for details.


// Specify version of OpenGL Shading Language.
//
#version 430 compatibility
#extension GL_EXT_geometry_shader4 : enable

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


layout ( location = 0 ) uniform float bulge_loc;
layout ( location = 1 ) uniform float bulge_dist_thresh;
layout ( location = 2 ) uniform float wire_radius;
layout ( binding = 1 ) buffer Helix_Coord  { vec4  helix_coord[];  };
uniform sampler2D tex_unit_0;


///
/// Shader Input and Output Variables
///


// Declare variables for communication between vertex shader
// and fragment shader.
//
#ifdef _VERTEX_SHADER_

// Helix Index: An integer giving position along helix.
// Used to index the helix coordinate array.
//
layout ( location = 1 ) in int helix_index;

out Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  int hidx;
};

out vec2 gl_TexCoord[];  // Declaring this is optional, since it's predefined.

#endif

#ifdef _GEOMETRY_SHADER_

layout ( triangles ) in;
layout ( triangle_strip, max_vertices = 4 ) out;

in Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  int hidx;
} In[3];

out Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  flat int hidx;
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;

  flat int hidx;
};

in vec2 gl_TexCoord[];

#endif


///
/// Shaders
///

#ifdef _VERTEX_SHADER_
void
vs_main_basic()
{
  // Perform basic vertex shading operations.

  // Transform vertex to clip space.
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

  // Compute eye-space vertex coordinate and normal.
  // These are outputs of the vertex shader and inputs to the frag shader.
  //
  var_vertex_e = gl_ModelViewMatrix * gl_Vertex;
  var_normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Copy color to output unmodified. Lighting calculations will
  // be performed in the fragment shader.
  //
  gl_BackColor = gl_FrontColor = gl_Color;

  // Copy texture coordinate to output (no need to modify it).
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}

void
vs_main_helix()
{
  // Perform basic vertex shading operations, but also:
  //   - Compute wire surface coordinates.
  //   - Adjust wire diameter based on location of bulge.
  //
  // Note that this shader only works for the helix.

  // Pass helix index to fragment shader output.
  //
  hidx = helix_index;

  // Set wire radius based on location of bulge.
  //
  float radius = wire_radius * ( hidx == int(bulge_loc) ? 1.2f : 1.0f );

  /// Compute wire surface location by adding normal to helix coordinate.
  //
  vec4 vertex_o;
  vertex_o.xyz = helix_coord[hidx].xyz + radius * gl_Normal;
  vertex_o.w = 1;

  // Transform vertex coordinate to clip space.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;

  // Compute eye-space coordinates for vertex and normal.
  //
  var_vertex_e = gl_ModelViewMatrix * vertex_o;
  var_normal_e = normalize(gl_NormalMatrix * gl_Normal);

  // Pass color along to next stage in pipeline.
  //
  gl_BackColor = gl_FrontColor = gl_Color;

  // Pass texture coordinate to next stage in pipeline.
  // Only copy x and y components since it's a 2D texture.
  //
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}
#endif

#ifdef _GEOMETRY_SHADER_

void
gs_main_helix()
{
  /// Geometry Shader
  //
  // Pre-defined input: gl_PositionIn[] (array of vec4, size determined by prim)
  // Pre-defined output: gl_Position (vec4, read when EmitVertex called).
  //
  // Most other inputs and outputs should be declared by programmer,
  // but for compatibility gl_FrontColor, etc., available.

  // Adjust color of certain triangles.

  const bool type_a = In[0].hidx < In[2].hidx;
  vec4 color_adjust = type_a ? vec4(0.5,0.5,0.5,1) : vec4(1);

  for ( int i=0; i<3; i++ )
    {
      // Send the adjusted colors.
      //
      gl_FrontColor = gl_FrontColorIn[i] * color_adjust;
      gl_BackColor = gl_BackColorIn[i] * color_adjust;

      // Pass the other values through unmodified.
      //
      gl_Position = gl_PositionIn[i];
      gl_TexCoord[0] = gl_TexCoordIn[i][0];
      var_normal_e = In[i].var_normal_e;
      var_vertex_e = In[i].var_vertex_e;

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
  // Note that in the fixed-function pipeline lighting would be performed
  // in the vertex shader.

  // Note: gl_Color in fragment shader is either gl_FrontColor or gl_BackColor
  // in vertex shader.

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0].xy);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor =
    texel * generic_lighting( var_vertex_e, gl_Color, normalize(var_normal_e));

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
