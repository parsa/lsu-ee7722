/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

 /// Homework 3 - Shader Code -- SOLUTION
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gpup/2012/hw03.pdf

 /// Your Name:

// Specify version of OpenGL Shading Language.
//
#version 430 compatibility
#extension GL_EXT_geometry_shader4 : enable

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


layout ( location = 2 ) uniform float wire_radius;

 /// SOLUTION
// Declare a uniform variable for the door angle, theta.
//
layout ( location = 3 ) uniform float theta;          // Problem 3
layout ( location = 4 ) uniform vec2 texture_scale;   // Problem 1

layout ( binding = 1 ) buffer Helix_Coord  { vec4  helix_coord[];  };
uniform sampler2D tex_unit_0;


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

// Indicate type of input primitive expected by geometry shader.
//
layout ( triangles ) in;
layout ( triangle_strip, max_vertices = 9 ) out;

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
  flat bool no_texture;  /// SOLUTION - Problem 2
};

#endif

#ifdef _FRAGMENT_SHADER_
in Data
{
  vec3 normal_e;
  vec4 vertex_e;
  flat bool no_texture;    /// SOLUTION - Problem 2
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

  // Copy texture coordinate to output (no need to modify it).
  // Only copy x and y components since it's a 2D texture.
  //

  /// SOLUTION -- Problem 1
  //  Use scale factor pre-computed on CPU to transform helix indices
  //  to texture coordinates.  Note that all variables below are
  //  two-element vectors and that the multiply operator is element-wise.
  //
  gl_TexCoord[0] = texture_scale * helix_index;

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
      no_texture = type_a;                     /// SOLUTION - Problem 2
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;

      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_helix2()
{
  /// SOLUTION - Problem 3

  // Select which triangles to split into "trap doors".
  //
  const bool trap_door = In[0].hidx.x >= In[2].hidx.x;

  // Set door angle (0 is fully closed, pi/2 is straight out, etc.
  //
  float th = trap_door ? theta : 0;

  // Find center of triangle (in eye-space coordinates).
  //
  vec3 pctr = (In[0].vertex_e + In[1].vertex_e
               + In[2].vertex_e ).xyz * 0.333333f;

  // Find texture coordinate of center of triangle.
  //
  vec4 tctr = ( gl_TexCoordIn[0][0] + gl_TexCoordIn[1][0]
                + gl_TexCoordIn[2][0] ) * 0.333333f;

  // Generate the three "trap door" triangles.
  //
  for ( int tri=0; tri<3; tri++ )
    {
      // Note that calculations performed in eye-space coordinates. If
      // the calculations were performed in clip-space coordinates
      // (for example, using gl_PositionIn) results would be distorted
      // due to the perspective projection.

      // Select two "fixed" vertices.
      //
      vec3 p0 = In[(0+tri)%3].vertex_e.xyz;
      vec3 p1 = In[(1+tri)%3].vertex_e.xyz;

      // Select the "swinging" vertex.
      //
      int p2_idx = (2+tri)%3;
      vec3 p2 = pctr;

      // Compute the two axes defining the plane that point new_p2
      // (below) will move along.

      // Start by finding the point between p0 and p1 that's closest to p2.
      //
      vec3 v01_norm = normalize( p0 - p1 );
      vec3 v02 = p2 - p0;
      vec3 p01_nearest = p0 + v01_norm * dot(v01_norm,v02);

      // Axis 2 is from p2 to the p0-p1 line.
      //
      vec3 axis2 = p2 - p01_nearest;
      float axis2_len = length(axis2);
      vec3 axis2_norm = axis2/axis2_len;

      // Axis 1 is a vector orthogonal to both axis 2 and the p0-p1 line.
      //
      vec3 axis1_norm = cross(v01_norm,axis2_norm);
      vec3 axis1 = axis2_len * axis1_norm;

      // Use a simple circle formula to find new_p2.
      //
      vec4 new_p2 = vec4(p01_nearest + cos(th) * axis2 + sin(th) * axis1,1);

      // Finish by computing the clip-space coordinate of new_p2_c and
      // an eye-space normal for the new triangle.
      //
      vec4 new_p2_c = gl_ProjectionMatrix * new_p2;
      vec3 new_norm = normalize(cross(v01_norm,new_p2.xyz-p0));
      normal_e = -new_norm;

      // Emit the three vertices of this triangle.
      //
      for ( int i=0; i<3; i++ )
        {
          gl_FrontColor = gl_FrontColorIn[i];
          gl_Position = i == p2_idx ? new_p2_c : gl_PositionIn[i];
          gl_TexCoord[0] = i == p2_idx ? tctr : gl_TexCoordIn[i][0];
          vertex_e = i == p2_idx ? new_p2 : In[i].vertex_e;
          no_texture = false;
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

  // If primitive facing user get texel, otherwise assign a reddish shade.
  //
  vec4 texel = gl_FrontFacing
    ? ( no_texture ? vec4(1,1,1,1) :    /// SOLUTION - Problem 2
        texture(tex_unit_0,gl_TexCoord[0].xy) )
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
