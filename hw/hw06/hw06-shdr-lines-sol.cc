/// LSU EE 4702-1 (Fall 2014), GPU Programming
//
 /// Homework 6
 //
 /// SOLUTION

 //  Assignment: http://www.ece.lsu.edu/koppel/gpup/2014/hw06.pdf
 //  Solution Discussion: http://www.ece.lsu.edu/koppel/gpup/2014/hw06_sol.pdf

// Specify version of OpenGL Shading Language.
//
#version 440 compatibility

// Number of triangle pairs between balls.
//
layout ( location = 1 ) uniform int opt_segments;

// Number of balls.
//
layout ( location = 2 ) uniform int chain_length;

// Use this variable to debug your code. Press 'd' to toggle
// debug_bool.x and 'D' to toggle debug_bool.y (between true and
// false).
//
layout ( location = 3 ) uniform bvec2 debug_bool;

// Use this to debug your code. Press TAB until "debug_float"
// appears, then press +/- to adjust its value.
//
layout ( location = 4 ) uniform float debug_float;


// Array of ball positions.
//
layout ( binding = 1 ) buffer Balls_Pos { vec4 balls_pos[]; };


#ifdef _VERTEX_SHADER_

// Redefine this vertex shader input to be an integer vector.
//
 /// SOLUTION
//
//   Reduce gl_Vertex from three to two components since the third
//   component was used to indicate whether to compute an inner or outer
//   vertex, and now we always do both.
in ivec2 gl_Vertex;


// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  /// SOLUTION
  //
  //  Change vertex_e from a vec4 to a 2-D array of vec4's.  The
  //    four values are for inner/outer, and upper/lower vertices.
  //    Indexing:  [level (upper/lower)] [ radius (inner/outer) ]
  //
  //  Also declare four position vectors (and don't bother using gl_Position).
  //
  //
  vec4 vertex_e[2][2];  // Vertex coordinates in eye space.
  vec4 position[2][2];  // Vertex coordinates in clip space.

  //  Only two texCoord and normal_e vectors are declared because the
  //  upper and lower spirals have the same texture coordinates and normals.
  //
  vec2 texCoord[2];
  vec3 normal_e[2];

  //  All for vertices have the same radial vector.
  //
  vec3 radial_e;  // Normal for edge primitives.
};


void
vs_main_lines()
{
  const float spiral_radius = 0.5;
  const float omega = 10;

  const int bidx = gl_Vertex.x;
  const int ti = gl_Vertex.y;

  const int radial_idx = bidx * opt_segments + ti;
  const float delta_t = 1.0 / opt_segments;
  const float t = float(ti) * delta_t;
  const float theta = delta_t * radial_idx * omega;

  vec3 pos1 = balls_pos[bidx-1].xyz;
  vec3 pos2 = balls_pos[bidx].xyz;

  vec3 v12 = pos2.xyz - pos1.xyz;

  // Find a vector that's orthogonal to v12.
  //
  vec3 van =
    normalize(v12.x == 0 ? vec3(0,v12.z,-v12.y) : vec3(v12.y,-v12.x,0));

  // Find a vector that's orthogonal to v12 and van.
  //
  vec3 vbn = normalize(cross(v12,van));

  vec3 va = van * spiral_radius;
  vec3 vb = vbn * spiral_radius;

  // Point on line between ball1 and ball2.
  //
  vec3 p = pos1 + t * v12;

  // Vector from p to spiral outer edge.
  //
  vec3 radial = va * cos(theta) + vb * sin(theta);
  vec3 p_outer = p + radial;

  const float inner_frac = 0.5;
  vec3 p_inner = p + inner_frac * radial;

  // Compute surface normals.
  //
  vec3 tangial = -omega * va * sin(theta) + omega * vb * cos(theta);
  vec3 tang = v12 + tangial;
  vec3 tang_inner = v12 + inner_frac * tangial;
  vec3 norm = normalize(cross(radial,tang));
  vec3 norm_inner = normalize(cross(radial,tang_inner));

  /// SOLUTION
  //
  //  Compute information for the four vertices.
  //
  //  Indexing:  [level (upper/lower)] [ radius (inner/outer) ]

  vec3 v12n = normalize(v12);
  vec3 depth_vector = 0.1f * v12n;

  // Compute the four vertex coordinates in object space.
  //
  vec3 pos_o[2][2];
  pos_o[0][0] = p_inner;
  pos_o[0][1] = p_outer;
  pos_o[1][0] = p_inner + depth_vector;
  pos_o[1][1] = p_outer + depth_vector;

  // Transform the object-space coordinates to clip and eye space.
  //
  for ( int l=0; l<2; l++ )
    for ( int r=0; r<2; r++ )
      {
        vec4 position_o = vec4( pos_o[l][r], 1 );
        position[l][r] = gl_ModelViewProjectionMatrix * position_o;
        vertex_e[l][r] = gl_ModelViewMatrix * position_o;
      }

  normal_e[0] = gl_NormalMatrix * norm_inner;
  normal_e[1] = gl_NormalMatrix * norm;

  // Amount by which to zoom the texture.
  //
  float tex_zoom = 0.5;

  // Uncomment the line below to use "debug_float" to zoom text.
  // tex_zoom /= debug_float;

  const float du = 0.5 * tex_zoom / chain_length;
  const float u = float(bidx) * du;

  texCoord[0].x = texCoord[1].x = tex_zoom * t;
  texCoord[0].y = 0.18 + u;
  texCoord[1].y = 0.18 + u + du;

  radial_e = gl_NormalMatrix * radial;
}

#endif



#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  //  Indexing:  [level (upper/lower)] [ radius (inner/outer) ]
  vec4 vertex_e[2][2];  // Vertex coordinates in eye space.
  vec4 position[2][2];  // Vertex coordinates in clip space.
  vec2 texCoord[2];

  // Normal in eye space. Note: inner and outer normals are the same.
  vec3 normal_e[2];

  vec3 radial_e;  // Normal for edge primitives.
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat bool is_edge;  // True if primitive an inner or outer edge.
};

 /// SOLUTION
//
//   Change input primitive type to lines.  The reason for using lines,
//   remember, is because that's the most convenient way of passing
//   the needed vertices to the geometry shader.

layout ( lines ) in;
layout ( triangle_strip, max_vertices = 16 ) out;

void
gs_main_lines()
{
  /// SOLUTION
  //
  // Use the two sets of four vertices to construct the upper and
  // lower spiral and edges. The vertices were organized into a
  // two-dimensional array in such a way that the spiral and edge
  // triangles could each be rendered with a single loop nest.

  /// Emit the spiral triangles.
  //
  for ( int level=0; level<2; level++ )         // Upper / Lower
    {
      for ( int theta=0; theta<2; theta++ )
        {
          for ( int r=0; r<2; r++ )             // Inner / outer
            {
              normal_e       = In[theta].normal_e[r];
              vertex_e       = In[theta].vertex_e[level][r];
              gl_Position    = In[theta].position[level][r];
              gl_TexCoord[0] = In[theta].texCoord[r];
              is_edge = false;
              EmitVertex();
            }
        }
      EndPrimitive();
    }

  /// Emit the edge (wall) triangles.
  //
  // Because we know that In[0] is in back of In[1] there is no need
  // for the vertex sorting code used in the Homework 4 solution. Just
  // one simple loop nest.
  //
  for ( int r=0; r<2; r++ )                     // Inner / outer  
    {
      for ( int theta=0; theta<2; theta++ )
        {
          for ( int level=0; level<2; level++ ) // Upper / Lower
            {
              normal_e    = In[theta].radial_e;
              vertex_e    = In[theta].vertex_e[level][r];
              gl_Position = In[theta].position[level][r];
              is_edge = true;
              EmitVertex();
            }
        }
      EndPrimitive();
    }
}

#endif


#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[];
  flat bool is_edge;
};

uniform sampler2D tex_unit_0;
vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Choose color based on which side of spiral we are rendering.
  //
  vec4 color =
    is_edge ? gl_FrontMaterial.ambient :
    gl_FrontFacing ? gl_FrontMaterial.diffuse : gl_BackMaterial.diffuse;

  // Get filtered texel, unless the fragment belongs to an edge primitive.
  //
  vec4 texel = is_edge ? vec4(1,1,1,1) : texture(tex_unit_0,gl_TexCoord[0].xy);

  // If texel is too dark don't write fragment, leaving a hole.
  //
  bool hole = texel.r + texel.g + texel.b < 0.05;
  if ( hole ) discard;

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor =
    texel * generic_lighting(vertex_e, color, normalize(normal_e));

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

#endif
