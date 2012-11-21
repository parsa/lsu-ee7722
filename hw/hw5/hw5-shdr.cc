/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

// $Id:$

// Specify version of OpenGL Shading Language.
//
#version 430 compatibility
#extension GL_EXT_geometry_shader4 : enable

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


layout ( location = 2 ) uniform float wire_radius;
layout ( location = 3 ) uniform float theta;
layout ( binding = 1 ) buffer Helix_Coord  { vec4  helix_coord[];  };
layout ( binding = 2 ) buffer Helix_u  { vec4  helix_u[];  };
layout ( binding = 3 ) buffer Helix_v  { vec4  helix_v[];  };
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
layout ( location = 1 ) in ivec2 helix_index;

out Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  ivec2 hidx;
};

out vec2 gl_TexCoord[];  // Declaring this is optional, since it's predefined.

#endif

#ifdef _GEOMETRY_SHADER_

in Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  ivec2 hidx;
} In[3];

out Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
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

  vec3 vtx = helix_coord[hidx.x].xyz;

  float pi = 3.14159265;
  float theta = hidx.y * 2 * pi / 20;
  vec3 u = helix_u[hidx.x].xyz;
  vec3 v = helix_v[hidx.x].xyz;

  vec3 normal = normalize( cos(theta) * u + sin(theta) * v );

  // Compute wire surface location by adding normal to helix coordinate.
  //
  vec4 vertex_o;
  vertex_o.xyz = helix_coord[hidx.x].xyz + wire_radius * normal;
  vertex_o.w = 1;

  // Transform vertex coordinate to clip space.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;

  // Compute eye-space coordinates for vertex and normal.
  //
  var_vertex_e = gl_ModelViewMatrix * vertex_o;
  var_normal_e = normalize(gl_NormalMatrix * normal);

  // Call our lighting routine to compute the lighted color of this
  // vertex.
  //
  gl_BackColor = gl_FrontColor = gl_Color;

  // Copy texture coordinate to output (no need to modify it).
  // Only copy x and y components since it's a 2D texture.
  //
  gl_TexCoord[0].xy = gl_MultiTexCoord0.xy;

  gl_TexCoord[0].x = -helix_index.x * 0.25f;
  gl_TexCoord[0].y = helix_index.y * 0.05f;
}
#endif

#ifdef _GEOMETRY_SHADER_

void
gs_main_helix()
{
  // Adjust color of certain triangles.

  const bool type_a = In[0].hidx.x < In[2].hidx.x;
  vec4 color_adjust = type_a ? vec4(0.9,0.9,0.9,1) : vec4(1);

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

void
gs_main_helix2()
{
  // Adjust color of certain triangles.

  const bool type_a = In[0].hidx.x < In[2].hidx.x;

  float th = type_a ? 0 : theta;
  vec3 pctr = (In[0].var_vertex_e + In[1].var_vertex_e
               + In[2].var_vertex_e ).xyz * 0.333333f;
  vec4 tctr = ( gl_TexCoordIn[0][0] + gl_TexCoordIn[1][0]
                + gl_TexCoordIn[2][0] ) * 0.333333f;

  for ( int tri=0; tri<3; tri++ )
    {
      vec3 p0 = In[(0+tri)%3].var_vertex_e.xyz;
      vec3 p1 = In[(1+tri)%3].var_vertex_e.xyz;
      int p2_idx = (2+tri)%3;
      vec3 p2 = pctr;

      vec3 v01_norm = normalize( p0 - p1 );
      vec3 v02 = p2 - p0;
      vec3 p01_nearest = p0 + v01_norm * dot(v01_norm,v02);
      vec3 axis2 = p2 - p01_nearest;
      float axis2_len = length(axis2);
      vec3 axis2_norm = axis2/axis2_len;
      vec3 axis1_norm = cross(v01_norm,axis2_norm);
      vec3 axis1 = axis2_len * axis1_norm;
      vec4 new_p2 = vec4(p01_nearest + cos(th) * axis2 + sin(th) * axis1,1);
      vec4 new_p2_c = gl_ProjectionMatrix * new_p2; 
      vec3 new_norm = normalize(cross(v01_norm,new_p2.xyz-p0));
      var_normal_e = -new_norm;

      for ( int i=0; i<3; i++ )
        {
          gl_FrontColor = gl_FrontColorIn[i];
          gl_BackColor = vec4(.8,0,0,1);
          gl_Position = i == p2_idx ? new_p2_c : gl_PositionIn[i];
          gl_TexCoord[0] = i == p2_idx ? tctr : gl_TexCoordIn[i][0];
          var_vertex_e = i == p2_idx ? new_p2 : In[i].var_vertex_e;

          EmitVertex();
        }
      EndPrimitive();
    }
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

