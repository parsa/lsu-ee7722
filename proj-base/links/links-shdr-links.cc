/// LSU EE 4702-1 (Fall 2016), GPU Programming
//


// Specify version of OpenGL Shading Language.
//
#version 450 compatibility

layout ( location = 1 ) uniform vec4 color_front;
layout ( location = 2 ) uniform vec4 color_back;

// A bit vector indicating which lights are on.
layout ( location = 6 ) uniform int lighting_options;

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;


layout ( location = 4 ) uniform vec2 sides_rad;
layout ( location = 5 ) uniform float delta_tee;

layout ( binding = 1 ) buffer sr { vec4 pos1[]; };
layout ( binding = 2 ) buffer sr2 { vec4 pos2[]; };
layout ( binding = 3 ) buffer spr { vec4 v1[]; };
layout ( binding = 4 ) buffer sc { vec4 v2[]; };
layout ( binding = 5 ) buffer sc5 { vec4 b1_ydir[]; };
layout ( binding = 6 ) buffer sc6 { vec4 b2_ydir[]; };
layout ( binding = 7 ) buffer sc7 { vec4 tex_rad[]; };



#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  int iid; // Instance ID
  vec4 gl_Position;
  vec4 vertex_e;

  float t;
  vec4 ctr;
  vec3 norm, binorm;

  // Any changes here must also be made to the fragment shader input.
};

void
vs_main_2()
{
  iid = gl_InstanceID;

  const int i = gl_VertexID;
  t = i * delta_tee;
  const float t2 = t * t;
  const float t3 = t2 * t;

  // Cubic Hermite interpolation.
  // Compute point along core of link.
  //
  ctr.xyz =
    ( 2*t3 - 3*t2 + 1 ) * pos1[iid].xyz + (-2*t3 + 3*t2 ) * pos2[iid].xyz
    + (t3 - 2*t2 + t ) * v1[iid].xyz - (t3 - t2 ) * v2[iid].xyz;
  ctr.w = 1;

  // Compute direction of link at this point.
  //
  vec3 tan_raw =
    ( 6*t2 - 6*t ) * pos1[iid].xyz + (-6*t2 + 6*t ) * pos2[iid].xyz
    + (3*t2 - 4*t + 1 ) * v1[iid].xyz - (3*t2 - 2*t ) * v2[iid].xyz;
  vec3 tan = normalize(tan_raw);

  // Compute local x and y axes for drawing a cylinder.
  //
  vec3 ydir = mix(b1_ydir[iid].xyz, b2_ydir[iid].xyz, t);
  vec3 norm_raw = cross(tan,ydir);
  norm = normalize(norm_raw);
  binorm = cross(tan,norm);
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  int iid; // Instance ID
  vec4 gl_Position;
  vec4 vertex_e;

  float t;
  vec4 ctr;
  vec3 norm, binorm;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
};

// Type of primitive at geometry shader input.
//
layout ( lines ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 42 ) out;


void
gs_main_2()
{
  const float M_PI = 3.1415926535;
  const vec2 tex_scale = tex_rad[In[1].iid].xy;
  const float rad = tex_rad[In[1].iid].z;
  const float sides = sides_rad.x;

  for ( int j=0; j<=sides; j++ )
    {
      const float theta = j * ( 2 * M_PI / sides );

      vec3 vect0 = cos(theta) * In[0].norm + sin(theta) * In[0].binorm;
      vec3 vect1 = cos(theta) * In[1].norm + sin(theta) * In[1].binorm;
      vec4 pt0 = In[0].ctr + vec4(rad * vect0,0);
      vec4 pt1 = In[1].ctr + vec4(rad * vect1,0);

      normal_e = gl_NormalMatrix * vect1;
      vertex_e = gl_ModelViewMatrix * pt1;
      gl_TexCoord[0] =
        vec2( In[1].t * tex_scale.x, 0.5 + theta * tex_scale.y );
      gl_Position = gl_ModelViewProjectionMatrix * pt1;
      EmitVertex();

      normal_e = gl_NormalMatrix * vect0;
      vertex_e = gl_ModelViewMatrix * pt0;
      gl_TexCoord[0] =
        vec2( In[0].t * tex_scale.x, 0.5 + theta * tex_scale.y );
      gl_Position = gl_ModelViewProjectionMatrix * pt0;
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
  vec4 color2 = gl_FrontFacing ? color_front : color_back;

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
  vec3 normal_e = normalize(normal_e);

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
