/// LSU EE 4702-1 (Fall 2019), GPU Programming
//
 /// 2019 Final Exam Code
//
//   Note: The exam problems can be solved on paper. This file
//   is being made available as a convenience.
//
//   Search for Problem 2a and Problem 2b in this file to find final exam code.


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
  bool ts_start; // Triangle-strip start. True for first two vertices of ts.
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;
};


void
vs_strip_plus()
{
  vec4 v_o = vec4( gl_Vertex.xyz, 1 );

  ts_start = gl_Vertex.w == 0;
  gl_Position = gl_ModelViewProjectionMatrix * v_o;
  vertex_e = gl_ModelViewMatrix * v_o;
  color = gl_Color;
}


void
vs_strip_plus_sv()
{
  // Pass data to geometry shader unchanged.
  gl_Position = gl_Vertex;
}


#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  bool ts_start;  // True for first two vertices of a triangle strip.
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;
} In[];

out Data_to_FS
{
  flat vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
  vec2 texcoord;
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
  //  Don't emit triangle if last vertex starts a new strip.
  //
  if ( In[2].ts_start ) return;

  // Final Exam: Set texture coordinate to zero to avoid unexpected behavior.
  //
  texcoord = vec2(0,0);
  //
  // Note: Code using the strip plus shader does not set texture coords.

  //  Since normal is not a pipeline input, compute it ourselves here.
  //
  normal_e =
    cross( In[2].vertex_e.xyz - In[1].vertex_e.xyz,
           In[0].vertex_e.xyz - In[1].vertex_e.xyz );

  for ( int i=0; i<3; i++ )
    {
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
  //  Don't emit triangle strip if last vertex starts a new strip.
  if ( In[2].gl_Position.w == 0 ) return;

  // Get object space coordinates of light.
  vec4 l_pos_o = gl_ModelViewMatrixInverse * gl_LightSource[0].position;
  float sv_len = 1000;  // Size of shadow volume.

  //  Need to compute our own normal.
  vec3 norm =
    cross( In[2].gl_Position.xyz - In[1].gl_Position.xyz,
           In[0].gl_Position.xyz - In[1].gl_Position.xyz );

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

      //  Need to replace w component with 1.
      vec4 v = vec4( In[i].gl_Position.xyz,1);
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
  vec2 texcoord;
};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
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
      // Get object space coordinates of light source zero.
      vec4 l_pos = gl_ModelViewMatrixInverse * gl_LightSource[0].position;
      float sv_len = 1000;  // Size of shadow volume.

      // Compute normal of top of protrusion. (The diamond.)
      //
      vec3 top_norm_o =
        cross( pts_o[2].xyz - pts_o[1].xyz, pts_o[0].xyz - pts_o[1].xyz );
      //
      // Using the normal determine if the top is lit.
      //
      bool top_lit = dot( top_norm_o, l_pos.xyz - pts_o[0].xyz ) > 0;

      // Prepare an array indicating which sides are lit.
      //
      bool side_lit[4];
      //
      for ( int i0=0; i0<4; i0++ )
        {
          int i1 = ( i0 + 1 ) & 0x3;  // The next edge. (To find the normal.)

          // Compute normal for side i0.
          //
          vec3 side_norm_o =
            cross( pts_o[i0+4].xyz - pts_o[i0].xyz,
                   pts_o[i1].xyz   - pts_o[i0].xyz );

          // Find a vector from the side to the light.
          //
          vec3 vtol = l_pos.xyz - pts_o[i0].xyz;

          // If their dot product is positive the side faces the light.
          //
          side_lit[i0] = dot(vtol,side_norm_o) > 0;
        }

      int l_clo = top_lit ? 0 : 4;  // Offset for side close to light.
      int l_far = top_lit ? 4 : 0;  // Offset for side far from light.
      //
      // Note: pts_o[ 1     ]: Vertex 1 of the diamond (above the ring).
      //       pts_o[ 1 + 4 ]: The point below vertex 1, on the ring.
      //       pts_o[ 1 + l_clo ]:
      //         pts_o[1],   if pts_o[1] is closer to the light;
      //         pts_o[1+4], if pts_o[1+4] is closer to the light.
      //       pts_o[ 1 + l_far ]:
      //         pts_o[1+4], if pts_o[1] is closer to the light;
      //         pts_o[1],   if pts_o[1+4] is closer to the light.


      // Iterate around the diamond's vertices.
      // Note that vertex 0 visited twice (i=0 and i=4).
      //
      for ( int i=0; i<5; i++ )
        {
          // Compute the current vertex number.
          //
          int i0 = i & 0x3;
          int i1 = ( i + 1 ) & 0x3; // Next vertex number. Not used.


          // Compute the previous vertex number.
          //
          int ip = ( i - 1 ) & 0x3;

          // The current side is the side using edge i0/i1.
          // The previous side is the side using edge ip/i0.

          // Look up whether the previous side and the current side are lit.
          bool pl = side_lit[ip], cl = side_lit[i0];

          // For each diamond vertex we need to emit either one or two
          // shadow volume edges. One edge is emitted if both the
          // current and previous sides are either both lit or both
          // dark. Element lev[0] indicates whether the first edge is
          // on the diamond (0) or on the ring (4). If lev[1] then
          // there is no second edge, otherwise it indicates whether
          // that second edge is on the diamond or ring.

          int lev[2];
          lev[0] = pl ? l_far : l_clo;
          lev[1] = pl == cl ? -1 : pl ? l_clo : l_far;

          // Emit the two edges of the shadow volume.
          //
          for ( int j=0; j<2; j++ )
            {
              if ( lev[j] < 0 ) continue;

              // The vertex of the shadow volume shared with the protrusion.
              //
              vec3 v = pts_o[ i0 + lev[j] ];

              // Compute the shadow volume vertex far away (in the
              // direction of the light).
              vec3 ltov = normalize( v - l_pos.xyz );
              vec3 vfar = v + sv_len * ltov;

              // Emit the two shadow volume vertices. Flip the order
              // if the diamond is not lit.

              gl_Position = gl_ModelViewProjectionMatrix
                * vec4(top_lit ? v : vfar, 1);
              EmitVertex();

              gl_Position = gl_ModelViewProjectionMatrix
                * vec4(top_lit ? vfar : v, 1);
              EmitVertex();
            }
        }
      EndPrimitive();

      return;
    }

  // Emit the diamond-shaped protrusion top.
  //
  color = color_diamond;
  normal_e = gl_NormalMatrix * nl;



  /// Final Exam -- Prepare an array of texture coordinates for diamond (top).
  //
  vec2 tc[4] = { {0,0}, {1,0}, {1,1}, {0,1} };
  int ord[4] = { 1, 0, 2, 3 }; // Order in which to emit vertices.

  /// Final Exam -- Problem 2b
  //
  //  Modify code above and below so that texture on diamond is not
  //  upside down. This applies for the entire ring, not just the diamonds
  //  in view.

  for ( int i=0; i<4; i++ )
    {
      texcoord = tc[ord[i]];     // Final Exam: Send appropriate tex coord.
      vertex_e = pts_e[ord[i]];  // Retrieve vertices in the correct order.
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();
    }
  EndPrimitive();

  // Emit the sides.
  //
  color = color_edge;

  /// Final Exam -- Problem 2a
  //
  //  Modify code below so that texture applied to the sides. Each
  //  side must show exactly 1/4 of texture.

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
  vec2 texcoord;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  vec4 color2 = gl_FrontFacing ? color : vec4(0.5,0,0,1);

  // Final Exam: Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,texcoord);

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
