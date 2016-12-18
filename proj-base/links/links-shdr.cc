/// LSU EE 4702-1 (Fall 2016), GPU Programming
//


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility


layout ( binding = 1 ) buffer sr { mat4 sphere_rot[]; };
layout ( binding = 2 ) buffer spr { vec4 sphere_pos_rad[]; };
layout ( binding = 3 ) buffer sc { vec4 sphere_color[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;
layout ( location = 2 ) uniform int lighting_options;


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
vs_main()
{
  // Here, the vertex shader does nothing except pass variables
  // to the geometry shader.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = normalize(gl_NormalMatrix * gl_Normal);
  gl_TexCoord[0] = gl_MultiTexCoord0;
  color = gl_Color;
}

void
vs_main_instances_sv()
{
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);
  vec4 vertex_o = rot * gl_Vertex;
  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;
}

void
vs_main_instances_sphere()
{
  vec4 pos_rad = sphere_pos_rad[gl_InstanceID];
  float rad = pos_rad.w;
  mat4 rot = transpose(sphere_rot[gl_InstanceID]);
  vec4 normr = rot * gl_Vertex;
  vec3 normal_o = normr.xyz;
  vec4 vertex_o = vec4( pos_rad.xyz + rad * normal_o, 1 );

  gl_Position = gl_ModelViewProjectionMatrix * vertex_o;
  vertex_e = gl_ModelViewMatrix * vertex_o;
  normal_e = normalize(gl_NormalMatrix * normal_o );
  gl_TexCoord[0] = gl_MultiTexCoord0;
  color = sphere_color[gl_InstanceID];
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
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 3 ) out;


void
gs_main_simple()
{
  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      color = In[i].color;
      gl_Position = In[i].gl_Position;
      gl_TexCoord[0] = In[i].gl_TexCoord[0];
      EmitVertex();
    }
  EndPrimitive();
}

void
gs_main_sv()
{
  for ( int i=0; i<3; i++ )
    {
      gl_Position = In[i].gl_Position;
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
  flat vec4 color;

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,gl_TexCoord[0]);

  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_sv()
{
  vec4 color2 = gl_FrontFacing ? vec4(0.8,0,0,1) : vec4(0,0,0,0);
  gl_FragColor = color2;
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
