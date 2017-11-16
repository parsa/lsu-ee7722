/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform


/// Purpose
//
//   Shader Code for Ball Collision Demo.
//
//   Shaders compute shadow and reflection locations.


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

// The _GEOMETRY_SHADER_ define is put there by code in shader.h.
//
#ifdef _GEOMETRY_SHADER_
#extension GL_EXT_geometry_shader4 : enable
#endif


layout ( location = 1 ) uniform bvec2 opt_debug;
layout ( location = 2 ) uniform int lighting_options;


#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the geometry shader input.
};

void
vs_main_tiles_0()
{
  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  color = gl_Color;
}

void
vs_main_tiles_1()
{
  vs_main_tiles_0();
}
void
vs_main_tiles_2()
{
  vs_main_tiles_0();
}

#if 0
void
vs_main_instances_sv()
{
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);
  vec4 vertex_o = rot * gl_Vertex;
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;
}
#endif

#endif

#ifdef _GEOMETRY_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
in Data_to_GS
{
  vec4 gl_Position;
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;

  // Any changes here must also be made to the vertex shader output.
} In[];

out Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 3 ) out;


void
gs_main_tiles_0()
{
  /// Do not put solution here.  Use this file for comparison or minor experiments.
  //  Instead, make geometry shader changes to gs_main_p1.

  // Color and normal will be the same for each vertex.
  normal_e = In[0].normal_e;
  color = In[0].color;

  for ( int i=0; i<3; i++ )
    {
      // Pass along values unchanged.
      vertex_e = In[i].vertex_e;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_tiles_1()
{
  gs_main_tiles_0();
}

void
gs_main_tiles_2()
{
  gs_main_tiles_0();
}


#endif




#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);

void
fs_main_tiles_0()
{
  /// Do not put solution here. Use this for minor experiments.
  //

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_tiles_1()
{
  fs_main_tiles_0();
}

void
fs_main_tiles_2()
{
  fs_main_tiles_0();
}


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



#if 0
vec4
olde_generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  vec3 nspc_color = color.rgb * gl_LightModel.ambient.rgb;
  vec3 spec_color = vec3(0);

  for ( int i=0; i<2; i++ )
    {
      if ( ( lighting_options & ( 1 << i ) ) == 0 ) continue;
      vec4 light_pos = gl_LightSource[i].position;
      vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
      float dist = length(v_vtx_light);
      float dist_vl_inv = 1.0 / dist;
      vec3 v_vtx_l_n = v_vtx_light * dist_vl_inv;

      float d_n_vl = dot(normalize(normal_e), v_vtx_l_n);
      //  float phase_light = max(0,gl_FrontFacing ? d_n_vl : -d_n_vl );
      float phase_light = max(0,true ? d_n_vl : -d_n_vl );

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
        pow(max(0.0,dot(normal_e,h)),gl_FrontMaterial.shininess)
        * gl_FrontMaterial.specular.rgb
        * gl_LightSource[i].specular.rgb / atten_inv;
    }

  gl_FrontColor = vec4(nspc_color,color.a);
  gl_FrontSecondaryColor = vec4(spec_color,1);
}
#endif
