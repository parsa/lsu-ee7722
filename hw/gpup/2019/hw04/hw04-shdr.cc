/// LSU EE 4702-1 (Fall 2019), GPU Programming
//
 /// Homework 4
//
//   Solution goes in this file and in hw04.cc

// Specify version of OpenGL Shading Language.
//
#version 460 compatibility


// Use this variable, tryout, to debug your code. Press 'y' to toggle
// tryout.x and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec3 tryout;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 4 ) uniform float tryoutf;

layout ( location = 5 ) uniform vec4 color_diamond;
layout ( location = 6 ) uniform vec4 color_edge;


layout ( location = 7 ) uniform vec4 hw04_scalars1;
layout ( location = 8 ) uniform vec4 ctr0;

//
//  Add additional uniforms needed to construct the protrusions.
//
layout ( location = 9 ) uniform vec3 ax;
layout ( location = 10 ) uniform vec3 ay;
layout ( location = 11 ) uniform vec3 vd;
layout ( location = 12 ) uniform float hw04_scalars2;

/// Code for Strip-Plus Shaders Immediately Below
//  (Code for points shaders further below.)

#ifndef HW04_POINTS

#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;

  // Any changes here must also be made to the fragment shader input.
};


void
vs_strip_plus()
{
  /// Problem 1 solution goes here and other places.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = gl_NormalMatrix * gl_Normal;
  color = gl_Color;
}


void
vs_strip_plus_sv()
{
  /// Problem 1 solution goes here and other places.

  // Pass data to geometry shader unchanged.
  gl_Position = gl_Vertex;
  normal_e = gl_Normal;
}


#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;
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
layout ( triangle_strip, max_vertices = 8 ) out;


void
gs_strip_plus()
{
  /// Problem 1 solution goes here and other places.

  //  If the normal provided for the provoking (3rd) vertex is zero
  //  this must be the start of a new triangle strip, so return.
  //
  if ( In[2].normal_e == vec3(0,0,0) ) return;

  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;
      color = In[i].color;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}


void
gs_strip_plus_sv()
{
  if ( In[2].normal_e == vec3(0,0,0) ) return;

  // Get object space coordinates of light.
  vec4 l_pos_o = gl_ModelViewMatrixInverse * gl_LightSource[0].position;
  float sv_len = 1000;  // Size of shadow volume.

  vec3 norm = In[2].normal_e;

  // Is light illuminating the front face or the back face?
  //
  bool front_lit = dot( norm, l_pos_o.xyz - In[0].gl_Position.xyz ) > 0;
  //
  // We need to know this so that the front of the triangles forming
  // our shadow volume surface faces the light side (and the backs
  // face the shadow side).

  for ( int ii=0; ii<4; ii++ )
    {
      int i = ii % 3;
      vec4 v = In[i].gl_Position;  // Shorter name, v, for convenience.
      // Light to vertex.
      vec3 ltov = normalize( v.xyz - l_pos_o.xyz );

      // Vertex far from the light.
      vec4 vfar = vec4( v.xyz + sv_len * ltov, 1 );

      gl_Position = gl_ModelViewProjectionMatrix * ( front_lit ? v : vfar );
      EmitVertex();
      gl_Position = gl_ModelViewProjectionMatrix * ( front_lit ? vfar : v );
      EmitVertex();
    }
  EndPrimitive();
}

#endif

/// Code for Strip-Plus Shaders Above

#else

/// Code for Points Shaders Below 


#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;

  // Any changes here must also be made to the fragment shader input.

  int vertex_id;
};


//
//   All the vertex shader does is pass along the vertex ID.
void
vs_points()
{
  vertex_id = gl_VertexID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;

  int vertex_id;

} In[];

out Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
// Increase max_vertices to 14.
layout ( triangle_strip, max_vertices = 14 ) out;

void gs_points_common(bool shadow_volumes);
void gs_points() { gs_points_common(false); }
void gs_points_sv() { gs_points_common(true); }


void
gs_points_common(bool shadow_volumes)
{

  // Retrieve the scalars and assign them to helpfully named variables.
  //
  float delta_theta = hw04_scalars1.x;
  float r = hw04_scalars1.y;
  float theta_to_ndz = hw04_scalars1.z;
  float size_d_theta = hw04_scalars1.w;
  float dr = hw04_scalars2;

  // Compute theta.
  //
  float theta = delta_theta * In[0].vertex_id;

  // Compute the coordinates of the diamond. (The protrusion's top.)
  //
  vec3 ctr = ctr0.xyz + vd * theta * theta_to_ndz;
  vec3 nc = ax * sin(theta) + ay * cos(theta);
  vec3 ctop = ctr + r * nc;
  vec3 nl = ax * sin(theta-size_d_theta) + ay * cos(theta-size_d_theta);
  vec3 nr = ax * sin(theta+size_d_theta) + ay * cos(theta+size_d_theta);
  vec3 cl = ctr + r * nl + vd;
  vec3 cr = ctr + r * nr + vd;
  vec3 cbot = ctop + vd + vd;

  // Prepare an array of object-space coordinates of vertices
  // describing the protrusion, and use that to initialize an array of
  // eye-space coordinates.
  //
  vec3 pts_o[8] =
    { ctop,       cr,       cbot,       cl,
      ctop+nc*dr, cr+nr*dr, cbot+nc*dr, cl+nr*dr };
  vec4 pts_e[8];
  for ( int i=0; i<8; i++ ) pts_e[i] = gl_ModelViewMatrix * vec4(pts_o[i],1);

  if ( shadow_volumes )
    {
      /// Put Problem 2 Solution Here.

      return;
    }

  // Emit the diamond-shaped protrusion top.
  //
  color = color_diamond;
  normal_e = gl_NormalMatrix * nl;

  int ord[4] = { 1, 0, 2, 3 }; // Order in which to emit vertices.
  for ( int i=0; i<4; i++ )
    {
      vertex_e = pts_e[ord[i]];  // Retrieve vertices in the correct order.
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();
    }
  EndPrimitive();

  // Emit the sides.
  //
  color = color_edge;

  for ( int i=0; i<5; i++ )
    {
      int i0 = i & 0x3;          // The current edge.
      int i1 = ( i + 1 ) & 0x3;  // The next edge. (Used to compute the normal.)

      vertex_e = pts_e[i0+4];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      vertex_e = pts_e[i0];
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();

      // This normal will be used for the next two vertices.
      //
      normal_e =
        cross( pts_e[i1].xyz   - pts_e[i0].xyz,
               pts_e[i0+4].xyz - pts_e[i0].xyz );
      //
      // Note that because the interpolation qualifier of normal_e is
      // flat the normal only has to be correct for the provoking
      // vertex.
    }
  EndPrimitive();
}


#endif

/// Code for Points Shaders Above

#endif


/// Code below is common to all problems.

#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}

void
fs_main_sv()
{
  vec4 color = gl_FrontFacing ? vec4(0,0,0.5,1) : vec4(0.5,0,0,1);
  gl_FragColor = color;
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
