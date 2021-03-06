/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 ///  Midterm Exam (Based on 2020 Homework 3)

// Specify version of OpenGL Shading Language.
//
#version 460 compatibility


layout ( binding = 1 ) buffer sr { mat4 sphere_rot[]; };
layout ( binding = 2 ) buffer spr { vec4 sphere_pos_rad[]; };
layout ( binding = 3 ) buffer sc { vec4 sphere_color[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec3 tryout;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 4 ) uniform vec2 tryoutf;
layout ( location = 5 ) uniform bool mirrored;
layout ( location = 6 ) uniform mat4 trans_proj;
layout ( location = 7 ) uniform vec2 pixel_size_c;

#ifdef _VERTEX_SHADER_

in vec2 gl_MultiTexCoord0;

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 color;
  vec4 gl_Position;

  // Any changes here must also be made to the fragment shader input.
};


void
vs_main_instances_sphere()
{
  vec4 pos_rad = sphere_pos_rad[gl_InstanceID];
  float rad = pos_rad.w;
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);
  vec4 normr = rot * gl_Vertex;  // mad: 16-4 = 12
  vec3 normal_o = normr.xyz;
  vec4 vertex_o = vec4( pos_rad.xyz + rad * normal_o, 1 );  // mad:3

  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;  // mad: 16
  vertex_e = gl_ModelViewMatrix * vertex_o;               // mad: 16
  normal_e = normalize(gl_NormalMatrix * normal_o );      // mad: 12, spc: 1
  gl_TexCoord[0] = gl_MultiTexCoord0;
  color = sphere_color[gl_InstanceID];

  // Total work: mad: 59,  spc: 1
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 color;
  vec4 gl_Position;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat vec4 color;

  flat bool mono;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//

layout ( triangle_strip, max_vertices = 20 ) out;

void
gs_one_triangle()
{
  mono = false;
  color = In[0].color;
  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }

  EndPrimitive();
}

#define AVG(mem) (In[0].mem+In[1].mem+In[2].mem)*0.33333333f;

void gs_monolith();

void
gs_main_many_triangles()
{
  // Skip monolith.
  if ( ( gl_PrimitiveIDIn & 0xf ) == 0 )
    gs_monolith();
  else
    gs_one_triangle();
}

void
gs_monolith()
{
  vec4 ctr_ce = AVG(vertex_e);       // Coord at triangle center.
  vec3 ctr_ne = AVG(normal_e);       // Normal at triangle center.
  vec2 ctr_tx = AVG(gl_TexCoord[0]); // Texture coord at triangle center.

  const float f = tryoutf.y; // Relative hole size.
  color = In[0].color;
  mono = false;

  // Render the triangle-with-a-hole using a triangle strip that wraps
  // around the hole in the triangle. 
  //
  for ( int ii=0; ii<=3; ii++ )
    {
      int i = ii % 3;  // Values of i:  0, 1, 2, 0.  (0 appears twice.)
      vec3 n_e = In[i].normal_e;

      // Prepare and emit inner vertex by blending outer vertex and center.
      normal_e =       f * n_e                  + (1-f) * ctr_ne;
      vertex_e =       f * In[i].vertex_e       + (1-f) * ctr_ce;
      gl_TexCoord[0] = f * In[i].gl_TexCoord[0] + (1-f) * ctr_tx;
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      // Prepare and emit vertex of original triangle.
      normal_e = n_e;
      vertex_e = In[i].vertex_e;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();

  mono = true;
  // SOLUTION GOES HERE.
}

void
gs_main_many_triangles_sol()
{
  // The tryout variables can be changed using the user interface.
  // They are intended for debugging, tuning, familiarization, etc.
  //
  const bool opt_tryout1 = tryout.x;
  const bool opt_tryout2 = tryout.y;
  const float opt_tryoutf = tryoutf.x;

  const float opt_hw03_hole_frac = tryoutf.y;

  const float f = opt_hw03_hole_frac; // Use a short variable name.

  mono = false;

  // Assume that the color of all three vertices is the same.
  color = In[0].color;

  if ( ( gl_PrimitiveIDIn & 0xf ) != 0 )
    {
      for ( int i=0; i<3; i++ )
        {
          // Prepare and emit vertex of original triangle.
          normal_e = In[i].normal_e;
          vertex_e = In[i].vertex_e;
          gl_TexCoord[0] = In[i].gl_TexCoord[0];
          gl_Position = In[i].gl_Position;
          EmitVertex();
        }

      EndPrimitive();

      return;
    }

  // Find the value of normal_e, vertex_e, and gl_TexCoord at the
  // center of the triangle.
  // 
  vec4 ctr_ce = vec4(0);
  vec3 ctr_ne = vec3(0);
  vec2 ctr_tx = vec2(0);

  float len_min = 1e10, len_max = 0;

  for ( int i=0; i<3; i++ )
    {
      int ni = ( i + 1 ) % 3;
      float len = length( In[i].vertex_e.xyz - In[ni].vertex_e.xyz );
      if ( len > len_max ) len_max = len;
      if ( len < len_min ) len_min = len;
    }

  if ( len_min == 0 || len_max / len_min > 10 ) return;

  for ( int i=0; i<3; i++ )
    {
      ctr_ne += In[i].normal_e;
      ctr_ce += In[i].vertex_e;
      ctr_tx += In[i].gl_TexCoord[0];
    }
  ctr_ce *= 0.333333333f;
  ctr_ne *= 0.333333333f;
  ctr_tx *= 0.333333333f;

  // Assume that the color of all three vertices is the same.
  color = In[0].color;

  // Render the triangle-with-a-hole using a triangle strip that wraps
  // around the hole in the triangle. Notice that vertex 0 is visited
  // twice, on the first iteration and on the last iteration.
  //
  for ( int ii=0; ii<=3; ii++ )
    {
      int i = ii % 3;
      vec3 n_e = In[i].normal_e;

      // Prepare and emit inner vertex by blending outer vertex and center.
      normal_e =       f * n_e                  + (1-f) * ctr_ne;
      vertex_e =       f * In[i].vertex_e       + (1-f) * ctr_ce;
      gl_TexCoord[0] = f * In[i].gl_TexCoord[0] + (1-f) * ctr_tx;
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      // Prepare and emit vertex of original triangle.
      normal_e = n_e;
      vertex_e = In[i].vertex_e;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }

  EndPrimitive();

  /// SOLUTION

  mono = true;

  float size = 2 * length(In[0].vertex_e-In[1].vertex_e);

  color = vec4(0.5,0.5,0.5,1);

  vec3 vtx_e[3], snorm_e[3];

  // Compute and save the coordinates of the top of the monolith.
  // Also save the surface normals.
  for ( int i=0; i<3; i++ )
    {
      vec3 n_e = In[i].normal_e;
      snorm_e[i] = size * normalize(f * n_e + (1-f) * ctr_ne);
      vtx_e[i] = f * In[i].vertex_e.xyz + (1-f) * ctr_ce.xyz;
    }

  for ( int i=0; i<3; i++ )
    {
      int ni = ( i + 1 ) % 3;  // Next i, possibly wrapped around.

      // Compute the normal of a face of the monolith.
      normal_e =
        normalize
        ( cross( In[ni].vertex_e.xyz - In[i].vertex_e.xyz, snorm_e[i].xyz ) );

      vertex_e.xyz = vtx_e[i];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      vertex_e.xyz = vtx_e[ni];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      vertex_e.xyz = vtx_e[i] + snorm_e[i];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      vertex_e.xyz = vtx_e[ni] + snorm_e[ni];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      EndPrimitive();
    }
}


#endif


#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat vec4 color;

  flat bool mono;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main_many_triangles()
{
  // The tryout variables can be changed using the user interface.
  // They are intended for debugging, tuning, familiarization, etc.
  //
  const bool opt_tryout1 = tryout.x;
  const bool opt_tryout2 = tryout.y;
  const float opt_tryoutf = tryoutf.x;

  const float opt_hw03_hole_frac = tryoutf.y;

  vec3 norm_e = normal_e;

  if ( gl_FrontFacing || mono )
    {
      // Multiply filtered texel color with lighted color of fragment.
      //
      vec4 texel = mono ? vec4(1,1,1,1) : texture(tex_unit_0,gl_TexCoord[0]);
      gl_FragColor = texel * generic_lighting(vertex_e, color, norm_e);
    }
  else
    {
      // Show back of primitives as red and without texture.
      //
      gl_FragColor = vec4(0.5,0,0,1);
    }

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}


///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_er)
{
  // Return lighted color of vertex_e.
  //

  vec3 nspc_color = color.rgb * gl_LightModel.ambient.rgb;
  vec3 spec_color = vec3(0);
  vec3 normal_e = normalize(normal_er);

  for ( int i=0; i<2; i++ )
    {
      if ( ( lighting_options & ( 1 << i ) ) == 0 ) continue;
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


#endif
