/// LSU EE 4702-1 (Fall 2016), GPU Programming
//

// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


layout ( location = 2 ) uniform float wire_radius;
layout ( location = 3 ) uniform float theta;
layout ( location = 4 ) uniform vec4 front_color;
layout ( location = 5 ) uniform vec4 back_color;

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
  vec3 normal_e;
  vec4 vertex_e;
  vec4 gl_Position;
  vec2 gl_TexCoord;
  ivec2 hidx;
};

#endif

#ifdef _GEOMETRY_SHADER_

// Indicate type of input primitive expected by geometry shader.
//
layout ( triangles ) in;
layout ( triangle_strip ) out;

// Indicate the maximum number of vertices that the geometry shader
// can write.
//
layout ( max_vertices = 3 ) out;

in Data
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 gl_Position;
  vec2 gl_TexCoord;
  ivec2 hidx;
} In[3];

out Data
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord;
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord;
};

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

  // hidx.x:  Index to position along core.
  // hidx.y:  Index to position along cylinder (wire) surrounding core.

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
  vertex_e = gl_ModelViewMatrix * vertex_o;
  normal_e = normalize(gl_NormalMatrix * normal);

  // Copy texture coordinate to output (no need to modify it).
  // Only copy x and y components since it's a 2D texture.
  //
  gl_TexCoord.x = -helix_index.x * 0.25f;
  gl_TexCoord.y = helix_index.y * 0.05f;
}
#endif

#ifdef _GEOMETRY_SHADER_

void
gs_main_helix()
{
  // Adjust color of certain triangles.

  for ( int i=0; i<3; i++ )
    {
      // Pass the other values through unmodified.
      //
      gl_Position = In[i].gl_Position;
      gl_TexCoord = In[i].gl_TexCoord;
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
  // Note that in the fixed-function pipeline lighting would be performed
  // in the vertex shader.

  // Note: gl_Color in fragment shader is either gl_FrontColor or gl_BackColor
  // in vertex shader.

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord.xy);

  vec4 color = gl_FrontFacing ? front_color : back_color;

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor =
    texel * generic_lighting( vertex_e, color, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}
#endif


vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_er)
{
  // Return lighted color of vertex_e.
  //

  vec3 nspc_color = color.rgb * gl_LightModel.ambient.rgb;
  vec3 spec_color = vec3(0);
  vec3 normal_e = normalize(normal_er);

  for ( int i=0; i<1; i++ )
    {
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
