/// LSU EE 4702-1 (Fall 2015), GPU Programming
//
 /// Demonstration of Geometry Shader

 /// See demo-10-shader.cc for details.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

// Define storage buffer binding indices and attribute locations.
//
#define UNIF_IDX_BULDGE_LOC 0
#define UNIF_IDX_BULDGE_DIST_THRESH 1
#define UNIF_IDX_WIRE_RADIUS 2
#define ATTR_IDX_HELIX_INDICES 1
#define SB_COORD 1

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


///
/// Variable Declarations
///
//  Declare variables for communication between shaders.
//

layout ( location = UNIF_IDX_WIRE_RADIUS ) uniform float wire_radius;

layout ( location = UNIF_IDX_BULDGE_LOC ) uniform float bulge_loc;
layout ( location = UNIF_IDX_BULDGE_DIST_THRESH
         ) uniform float bulge_dist_thresh;
uniform sampler2D tex_unit_0;


// Declare buffer objects which are read as arrays.
//
// Binding indices must agree with second argument of glBindBufferBase
// in client (CPU) code.
//
layout ( binding = SB_COORD  ) buffer Helix_Coord  { vec4  helix_coord[];  };


#ifdef _VERTEX_SHADER_

 /// Declaration of Rendering Pipeline Input (Vertex Attribute)
//
// Written by CPU code as a vertex attribute.
//
// Location index must agree with argument to  glEnableVertexAttribArray
// in client (CPU) code. See demo-10.h
//
layout ( location = ATTR_IDX_HELIX_INDICES ) in int helix_index;

out Data
{
  int hidx;                     // Same as helix_index input.
  vec3 normal_o;
  vec4 color;
};

// Re-declare predefined variable gl_TexCoord so that it uses just 2 coords.
out vec2 gl_TexCoord[];

#endif

#ifdef _GEOMETRY_SHADER_

// Indicate type of input primitive expected by geometry shader.
//
layout ( triangles ) in;
layout ( triangle_strip, max_vertices = 53 ) out;

in Data
{
  int hidx;
  vec3 normal_o;
  vec4 color;
} In[];

out Data_GF
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  flat vec4 color;
};

#endif
#ifdef _FRAGMENT_SHADER_

in Data_GF
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  flat vec4 color;
};

in vec2 gl_TexCoord[];

#endif

///
/// Shader Code
///

#ifdef _VERTEX_SHADER_
void
vs_main_helix()
{
  // Here, the vertex shader does nothing except pass variables
  // to the geometry shader.

  normal_o = gl_Normal;
  hidx = helix_index;
  color = gl_Color;
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;
}
#endif

#ifdef _GEOMETRY_SHADER_

void
gs_main_helix()
{
  // If "bulge" is far away, just emit one triangle.
  // If bulge is near, emit multiple triangles so that bulge is
  // smooth.

  float bulge_dist_0 = abs( bulge_loc - In[0].hidx );

  const bool type_a = In[0].hidx < In[2].hidx;

  const vec4 base_shade = type_a ? vec4(1,1,1,1) : vec4(0.625,1,1,1);

  if ( bulge_dist_0 > bulge_dist_thresh )
    {
      /// Bulge is far away, just emit one triangle.
      //
      for ( int i=0; i<3; i++ )
        {
          // Lighten the color to distinguish this area of helix from
          // the part with the bulge.
          //
          color = In[i].color * vec4(0.8,0.8,0.8,1) * base_shade;

          // Compute the vertex coordinate.
          //
          int hidx = In[i].hidx;
          vec4 c = helix_coord[hidx];  // Coordinate of core of helix.

          // Vertex normal in object space.
          vec3 norm_o = wire_radius * In[i].normal_o;

          // Vertex coordinate in object space.
          vec4 pos_o = c + vec4(norm_o,0);

          gl_Position = gl_ModelViewProjectionMatrix * pos_o;
          var_normal_e = gl_NormalMatrix * In[i].normal_o;
          var_vertex_e = gl_ModelViewMatrix * pos_o;

          // Indicate that vertex is finished.
          EmitVertex();
        }

      // Indicate that primitive is finished.
      EndPrimitive();
      return;
    }

  // Sort indices so that gs_vidx_10 and gs_vidx_11 are at same
  // position along helix (though at different positions on surface of
  // wire).

  int gs_vidx_00;
  int gs_vidx_10;
  int gs_vidx_11;

  if ( In[0].hidx == In[1].hidx )
    { gs_vidx_00 = 2;  gs_vidx_10 = 0;  gs_vidx_11 = 1; }
  else if ( In[0].hidx == In[2].hidx )
    { gs_vidx_00 = 1;  gs_vidx_10 = 0;  gs_vidx_11 = 2; }
  else
    { gs_vidx_00 = 0;  gs_vidx_10 = 1;  gs_vidx_11 = 2;}

  int hidx0 = In[gs_vidx_00].hidx;
  int hidx1 = In[gs_vidx_10].hidx;
  vec3 c0 = helix_coord[hidx0].xyz;
  vec3 c1 = helix_coord[hidx1].xyz;
  vec3 delta_c = c0 - c1;
  float delta_idx = hidx0 - hidx1;
  vec3 n0 = In[gs_vidx_00].normal_o;
  vec3 n10 = In[gs_vidx_10].normal_o;
  vec3 n11 = In[gs_vidx_11].normal_o;
  vec3 delta_n10 = n0 - n10;
  vec3 delta_n11 = n0 - n11;

  // Number of times to split triangle.
  int slices = 7;
  float bulge_rad = 1;
  float delta_f = 1.0f/slices;

  for ( float f=0; f<1.01f; f += delta_f )
    {
      float hidxx = hidx1 + f * delta_idx;
      vec3 c =   c1  + f * delta_c;
      vec3 nx0 = n10 + f * delta_n10;
      vec3 nx1 = n11 + f * delta_n11;

      float bulge_dist = abs( bulge_loc - hidxx );

      // Make surface of bulge curved.
      //
      float mult = 1.25f
        - 0.25f *
        cos( 3.1415f * max(0.0f, ( bulge_rad - bulge_dist ) / bulge_rad ) );
      float rx = wire_radius * mult;

      vec4 pos0 = vec4( c + rx * nx0, 1);
      vec4 pos1 = vec4( c + rx * nx1, 1);

      color = In[0].color * base_shade;
      gl_Position = gl_ModelViewProjectionMatrix * pos0;
      var_vertex_e = gl_ModelViewMatrix * pos0;
      var_normal_e = gl_NormalMatrix * nx0; // Not quite correct.
      EmitVertex();

      color = In[0].color * vec4(1,0.8,1,1) * base_shade;
      gl_Position = gl_ModelViewProjectionMatrix * pos1;
      var_vertex_e = gl_ModelViewMatrix * pos1;
      var_normal_e = gl_NormalMatrix * nx1;  // Not quite correct.
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

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0].xy);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor =
    texel * generic_lighting(var_vertex_e, color, normalize(var_normal_e));

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}
#endif


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
