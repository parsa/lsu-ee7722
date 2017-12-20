/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Homework 4
 //

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2017/hw04.pdf
 //
 ///  Most of the solution should be in this file, but some modifications
 //   can be placed in hw04.cc.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility


layout ( binding = 1 ) buffer sr { mat4 sphere_rot[]; };
layout ( binding = 2 ) buffer spr { vec4 sphere_pos_rad[]; };
layout ( binding = 3 ) buffer sc { vec4 sphere_color[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec3 tryout;
layout ( location = 2 ) uniform int lighting_options;

layout ( location = 4 ) uniform int opt_spirals;

const vec4 color_lsu_spirit_purple =
  vec4(0x58 / 256.0, 0x0d/ 256.0, 0xa6/256.0, 1);

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

  int instance_id;

  // Any changes here must also be made to the fragment shader input.
};


void
vs_main_p0()
{
  /// Do not put solution here.  Use this file for comparison or minor experiments.
  //  Instead, make vertex shader changes to vs_main_p1.

  vec4 pos_rad = sphere_pos_rad[gl_InstanceID];

  vec3 sphere_center = pos_rad.xyz;
  float radius = pos_rad.w;

  // Sphere orientation. Transpose is needed to convert C ordering to Fortran.
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);

  // Coordinate of slice in the sphere's local coordinate space.
  vec4 vtx_local = vec4(gl_Vertex.xyz,1);

  // Transform slice normal / local coordinate to an object-space
  // normal and coordinate
  //
  vec4 normr = rot * vtx_local;
  vec3 normal_o = normr.xyz;
  vec4 vertex_o = vec4( sphere_center + radius * normal_o, 1 );

  // Transform coordinate to clip and eye space, and transform normal to
  // eye space.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;
  vertex_e = gl_ModelViewMatrix * vertex_o;
  normal_e = normalize(gl_NormalMatrix * normal_o );

  // Compute texture coordinates using theta and local y coordinate.
  //
  float theta = gl_Vertex.w;
  float y_loc = gl_Vertex.y;
  float tex_s = -theta / ( 2 * 3.1415926535f );
  float tex_t = 0.5f - 0.5f * y_loc;
  gl_TexCoord[0] = vec2(tex_s,tex_t);

  // Pass instance id down pipeline.
  //
  instance_id = gl_InstanceID;
}

void
vs_main_p1()
{
  /// Vertex Shader for Homework 4 Solution
  //
  // Homework 4 solution goes here, and other places.

  vec4 pos_rad = sphere_pos_rad[gl_InstanceID];

  vec3 sphere_center = pos_rad.xyz;
  float radius = pos_rad.w;

  // Sphere orientation. Transpose is needed to convert C ordering to Fortran.
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);

  // Coordinate of slice in the sphere's local coordinate space.
  vec4 vtx_local = vec4(gl_Vertex.xyz,1);

  // Transform slice normal / local coordinate to an object-space
  // normal and coordinate
  //
  vec4 normr = rot * vtx_local;
  vec3 normal_o = normr.xyz;
  vec4 vertex_o = vec4( sphere_center + radius * normal_o, 1 );

  // Transform coordinate to clip and eye space, and transform normal to
  // eye space.
  //
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;
  vertex_e = gl_ModelViewMatrix * vertex_o;
  normal_e = normalize(gl_NormalMatrix * normal_o );

  // Compute texture coordinates using theta and local y coordinate.
  //
  float theta = gl_Vertex.w;
  float y_loc = gl_Vertex.y;
  float tex_s = -theta / ( 2 * 3.1415926535f );
  float tex_t = 0.5f - 0.5f * y_loc;
  gl_TexCoord[0] = vec2(tex_s,tex_t);

  // Pass instance id down pipeline.
  //
  instance_id = gl_InstanceID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  vec4 gl_Position;
  int instance_id;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat int instance_id;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
 /// Homework 4 solution goes here, and other places.
//
layout ( triangle_strip, max_vertices = 3 ) out;


void
gs_main_p0()
{
  /// Do not put solution here.  Use this file for comparison or minor experiments.
  //  Instead, make geometry shader changes to gs_main_p1.

  // If true use sphere normal, otherwise use one normal for whole triangle.
  const bool opt_normal_sphere = tryout.z;

  for ( int i=0; i<3; i++ )
    {
      // Optionally use same normal for each vertex.
      normal_e = In[opt_normal_sphere?i:0].normal_e;

      // Pass along values unchanged.
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      instance_id = In[i].instance_id;
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_p1()
{
  /// Geometry Shader for Homework 4 Solution 
  //
  //  Put Homework 4 solution here, and other places.

  // If true use sphere normal, otherwise use one normal for whole triangle.
  const bool opt_normal_sphere = tryout.z;

  for ( int i=0; i<3; i++ )
    {
      // Optionally use same normal for each vertex.
      normal_e = In[opt_normal_sphere?i:0].normal_e;

      // Pass along values unchanged.
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      instance_id = In[i].instance_id;
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
  flat int instance_id;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main_p0()
{
  /// Do not put solution here. Use this for minor experiments.
  //
  //  Use fs_main_p1 for the Homework 4 solution.

  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0]);

  vec4 color = sphere_color[instance_id];
  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_p1()
{
  /// Problem 1 Solution goes here and other places.

  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0]);

  vec4 color = sphere_color[instance_id];
  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

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
