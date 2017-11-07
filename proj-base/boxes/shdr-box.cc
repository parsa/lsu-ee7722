/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Demo of Dynamic Simulation, Multiple Balls and Boxes on Curved Platform

#version 450 compatibility

// The _GEOMETRY_SHADER_ define is put there by code in shader.h.
//
#ifdef _GEOMETRY_SHADER_
#extension GL_EXT_geometry_shader4 : enable
#endif

layout ( binding = 1 ) buffer spr { vec4 box_pos[]; };
layout ( binding = 2 ) buffer sr { vec4 box_ori[]; };
layout ( binding = 3 ) buffer sc { vec4 box_dim[]; };
layout ( binding = 4 ) buffer sco { vec4 box_color[]; };
layout ( binding = 5 ) buffer sce { vec4 box_color_events[]; };
layout ( binding = 6 ) buffer sct { uint box_tunits[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 1 ) uniform bool color_events_on;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 3 ) uniform bvec2 opt_debug;
layout ( location = 4 ) uniform vec4 light_pos; // Used for shadow volumes


mat3
make_rot_quat(vec4 q)
{
  mat3 m;
  //c  r
  m[0][0] = 1 - 2 * q.y * q.y - 2 * q.z * q.z;
  m[1][0] = 2 * q.x * q.y - 2 * q.w * q.z;
  m[2][0] = 2 * q.x * q.z + 2 * q.w * q.y;
  m[0][1] = 2 * q.x * q.y + 2 * q.w * q.z;
  m[1][1] = 1 - 2 * q.x * q.x - 2 * q.z * q.z;
  m[2][1] = 2 * q.y * q.z - 2 * q.w * q.x;
  m[0][2] = 2 * q.x * q.z - 2 * q.w * q.y;
  m[1][2] = 2 * q.y * q.z + 2 * q.w * q.x;
  m[2][2] = 1 - 2 * q.x * q.x - 2 * q.y * q.y;
  return m;
}


#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  int vtx_id;
};

void
vs_main_box()
{
  vtx_id = gl_VertexID;
}
#endif

#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  int vtx_id;
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat int vtx_id;
  flat uint tex_unit;
};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 30 ) out;

ivec3
box_get_ax_idx(int axis, int f)
{
 return ivec3
   ( 1 << ( axis + 1 + f ) % 3, 1 << ( axis + 2 - f ) % 3, 1 << axis );
}

int
box_get_idx(int i, int f, ivec3 a)
{
  const bool xi[] = { false, true,  true, false, false };
  const bool yi[] = { false, false, true, true,  false };
  const bool x = xi[i], y = yi[i];
  return ( x ? a.x : 0 ) + ( y ? a.y : 0 ) + ( bool(f) ? a.z : 0 );
}

vec3[8]
box_get_vertices(const vec4 pos, const mat3 ori, const vec4 xyz)
{
  vec3 box_vs[8];
  for ( int i=0; i<8; i++ )
    {
      vec3 vtx_loc =
        vec3( bool( i & 1 ) ? xyz.x : -xyz.x,
              bool( i & 2 ) ? xyz.y : -xyz.y,
              bool( i & 4 ) ? xyz.z : -xyz.z );
      box_vs[i] = pos.xyz + ori * vtx_loc;
    }
  return box_vs;
}

void
gs_main_box()
{
  vtx_id = In[0].vtx_id;

  vec4 pos = box_pos[vtx_id];
  mat3 ori = make_rot_quat(box_ori[vtx_id]);
  vec4 xyz = box_dim[vtx_id];
  uint tunits = box_tunits[vtx_id];
  const int tunits_bits = 5;
  const uint tunits_mask = ( 1 << tunits_bits ) - 1;

  vec3 box_vs[8] = box_get_vertices(pos,ori,xyz);

  for ( int axis = 0; axis < 3; axis++ )
    for ( int f = 0; f < 2; f++ )
      {
        ivec3 a = box_get_ax_idx(axis,f);
        int ef = axis * 2 + f;
        vec3 zplus  = box_vs[a.z] - box_vs[0];
        vec3 norm_o = bool(f) ? zplus : -zplus;
        normal_e = normalize(gl_NormalMatrix * norm_o);
        tex_unit = tunits >> ef * tunits_bits & tunits_mask;

        for ( int x=0; x<2; x++ )
          for ( int y=0; y<2; y++ )
            {
              int idx = ( bool(x) ? a.x : 0 )
                + ( bool(y) ? a.y : 0 ) + ( bool(f) ? a.z : 0 );

              vec4 vtx_o = vec4(box_vs[idx],1);
              gl_Position = gl_ModelViewProjectionMatrix * vtx_o;
              vertex_e = gl_ModelViewMatrix * vtx_o;
              gl_TexCoord[0] = vec2(0.5,0.5) + 0.5f * vec2(x,y);
              EmitVertex();
            }
        EndPrimitive();
      }
}

void
gs_main_box_sv()
{
  vtx_id = In[0].vtx_id;

  vec4 pos = box_pos[vtx_id];
  mat3 ori = make_rot_quat(box_ori[vtx_id]);
  vec4 xyz = box_dim[vtx_id];
  const float height = 1000;

  vec3 box_vs[8] = box_get_vertices(pos,ori,xyz);

  gl_FrontColor = vec4(1,0,0,0.5);

  int box_vtx_use[8];
  for ( int i=0; i<8; i++ ) box_vtx_use[i] = 0;
  bool use_face[3][2];

  for ( int axis = 0; axis < 3; axis++ )
    for ( int f = 0; f < 2; f++ )
      {
        ivec3 a = box_get_ax_idx(axis,f);
        int idx_00 = bool(f) ? a.z : 0;
        int idx_op = bool(f) ?  0 : a.z;
        vec3 vtx_00 = box_vs[idx_00];
        vec3 norm_o = vtx_00 - box_vs[idx_op];
        vec3 l_to_00 = vtx_00 - light_pos.xyz;
        use_face[axis][f] = dot(norm_o,l_to_00) < 0;
        if ( !use_face[axis][f] ) continue;
        for ( int i=0; i<4; i++ ) box_vtx_use[box_get_idx(i,f,a)]++;
      }

  for ( int axis = 0; axis < 3; axis++ )
    for ( int f = 0; f < 2; f++ )
      {
        if ( !use_face[axis][f] ) continue;
        ivec3 a = box_get_ax_idx(axis,f);
        for ( int i=0; i<5; i++ )
          {
            int idxp = box_get_idx(i-1,f,a);
            int idx =  box_get_idx(i,  f,a);
            int idxn = box_get_idx(i+1,f,a);
            bool edge_prev =
              i > 0 && ( box_vtx_use[idxp] == 1 || box_vtx_use[idx] == 1 );
            bool edge_next =
              i < 4 && ( box_vtx_use[idxn] == 1 || box_vtx_use[idx] == 1 );
            if ( !edge_prev && !edge_next ) continue;
            vec4 vtx_o = vec4(box_vs[idx],1);
            vec3 l_to_vtx_o = normalize(vtx_o.xyz - light_pos.xyz);
            vec4 vtx_of = vtx_o + vec4(height * l_to_vtx_o, 0 );
            gl_Position = gl_ModelViewProjectionMatrix * vtx_o;
            EmitVertex();
            gl_Position = gl_ModelViewProjectionMatrix * vtx_of;
            EmitVertex();
            if ( !edge_next ) EndPrimitive();
          }
      }
}


#endif

#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0, tex_unit_1, tex_unit_2;

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec2 gl_TexCoord[1];
  flat int vtx_id;
  flat uint tex_unit;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main_box()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Get filtered texel.
  //
  vec4 texel =
    tex_unit > 0 ? texture(tex_unit_0,gl_TexCoord[0]) : vec4(1,1,1,1);

  vec4 color2 =
    !gl_FrontFacing ? vec4(0.5,0,0,1) :
    color_events_on ? box_color_events[vtx_id]
    : box_color[vtx_id];

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(vertex_e, color2, normal_e);

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
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
