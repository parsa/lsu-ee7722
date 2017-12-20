/// LSU EE 4702-1 (Fall 2016), GPU Programming
//
 /// Final Exam Code
 //
 //  See http://www.ece.lsu.edu/koppel/gpup/2016/fe.pdf
 //
 //  This file contains code used in Final Exam problem 1 which was
 //  based on Homework 6.


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

void compute_ctr_norm_binorm(float t);


// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  int iid; // Instance ID
  vec4 gl_Position;
  vec4 vertex_e;

  float t;
  vec4 ctr_e;
  vec3 norm_e, binorm_e;
};

void
vs_main_2()
{
  t = gl_VertexID * delta_tee;
  compute_ctr_norm_binorm(t);  // Compute and assign norm_e, etc.
}

#if 0
void
gs_main_2_excerpt()
{
  // ...
  for ( int j=0; j<=sides; j++ )
    {
      const float theta = j * ( 2 * M_PI / sides );
      vec3 vect1 = cos(theta) * In[1].norm_e + sin(theta) * In[1].binorm_e;
      //...
    }
  EndPrimitive();
}
#endif

#endif

#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  int iid; // Instance ID
  vec4 gl_Position;
  vec4 vertex_e;

  float t;
  vec4 ctr_e;
  vec3 norm_e, binorm_e;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
};

layout ( lines ) in;
layout ( triangle_strip, max_vertices = 78 ) out;

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
      const float tx_y = 0.5 + theta * tex_scale.y;
      for ( int i=1; i>=0; i-- )
        {
          normal_e =
            cos(theta) * In[i].norm_e + sin(theta) * In[i].binorm_e;
          vertex_e = In[i].ctr_e + vec4( rad * normal_e, 0);
          gl_TexCoord[0] = vec2( In[i].t * tex_scale.x, tx_y );
          gl_Position = gl_ProjectionMatrix * vertex_e;
          EmitVertex();
        }
    }
  EndPrimitive();
}



#endif


#ifdef _VERTEX_SHADER_

void
compute_ctr_norm_binorm(float t)
{
  iid = gl_InstanceID;
  const float t2 = t * t;
  const float t3 = t2 * t;

  // Cubic Hermite interpolation.
  // Compute point along core of link in object space.
  //
  vec3 ctr_o =
    ( 2*t3 - 3*t2 + 1 ) * pos1[iid].xyz + (-2*t3 + 3*t2 ) * pos2[iid].xyz
    + ( t3 - 2*t2 + t ) * v1[iid].xyz - ( t3 - t2 ) * v2[iid].xyz;
  ctr_e = gl_ModelViewMatrix * vec4(ctr_o,1);

  // Compute direction of link at this point.
  //
  vec3 tan_o =
    ( 6*t2 - 6*t ) * pos1[iid].xyz + ( -6*t2 + 6*t ) * pos2[iid].xyz
    + ( 3*t2 - 4*t + 1 ) * v1[iid].xyz - ( 3*t2 - 2*t ) * v2[iid].xyz;

  vec3 tan_e = normalize( gl_NormalMatrix * tan_o );

  // Compute local x and y axes for drawing a cylinder.
  //
  vec3 ydir_o = mix(b1_ydir[iid].xyz, b2_ydir[iid].xyz, t);
  vec3 norm_raw = cross(tan_o,ydir_o);
  norm_e = normalize(gl_NormalMatrix * norm_raw);
  binorm_e = cross(tan_e,norm_e);
}


void
vs_main_1()
{
  t = gl_VertexID * delta_tee;
  compute_ctr_norm_binorm(t);
}

#endif


#ifdef _GEOMETRY_SHADER_




void
gs_main_1()
{
  /// Final Exam Problem 1

  // Emit primitives for a cylinder. One end of the cylinder is
  // defined by data in In[0], the other end by data in In[1].

  const float M_PI = 3.1415926535;
  const vec2 tex_scale = tex_rad[In[1].iid].xy;
  const float rad = tex_rad[In[1].iid].z;
  const float sides = sides_rad.x;

  for ( int j=0; j<=sides; j++ )
    {
      const float theta = j * ( 2 * M_PI / sides );

      vec3 vect0 = cos(theta) * In[0].norm_e + sin(theta) * In[0].binorm_e;
      vec3 vect1 = cos(theta) * In[1].norm_e + sin(theta) * In[1].binorm_e;

      normal_e = vect1;
      vertex_e = In[1].ctr_e + vec4( rad * vect1, 0);
      gl_TexCoord[0] = vec2( In[1].t * tex_scale.x, 0.5 + theta * tex_scale.y );
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      normal_e = vect0;
      vertex_e = In[0].ctr_e + vec4(rad * vect0,0);
      gl_TexCoord[0] = vec2( In[0].t * tex_scale.x, 0.5 + theta * tex_scale.y );
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();
    }
  EndPrimitive();

  /// SOLUTION -- Final Exam Problem 1

  // Skip the first segment because we don't want to render a ring at
  // the beginning of the link.
  //
  if ( In[0].t == 0 ) return;

  gl_TexCoord[0] = vec2(0,0);

  // Compute the normal based on the axes used to draw the cylinder.
  //
  normal_e = cross(In[0].norm_e,In[0].binorm_e);

  // Outer radius of ring. (Inner radius is rad)
  float rad2 = rad * 2;

  for ( int j=0; j<=sides; j++ )
    {
      const float theta = j * ( 2 * M_PI / sides );

      vec3 vect0 = cos(theta) * In[0].norm_e + sin(theta) * In[0].binorm_e;

      vertex_e = In[0].ctr_e + vec4(rad * vect0,0);
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      vertex_e = In[0].ctr_e + vec4(rad2 * vect0,0);
      gl_Position = gl_ProjectionMatrix * vertex_e;
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

  // Get filtered texel, unless the fragment belongs to an edge primitive.
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
