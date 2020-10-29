/// LSU EE 4702-1 (Fall 2019), GPU Programming
//


// Specify version of OpenGL Shading Language.
//
#version 460 compatibility

/// Background -- True Spheres
///

 /// True Sphere
 //
 //  A sphere rendered perfectly.
 //  (A tessellation using triangles is not perfect since the triangles
 //   approximate the sphere surface.)

 // Each sphere rendered using one (one!) vertex.
 //
 // Buffer Objects / Arrays
 //
 //  Each array has one element per sphere.
 //
 //  sphere_pos_rad.  A vec4.
 //    sphere_pos_rad[i].xyz
 //      Coordinates of center of sphere i.
 //    sphere_pos_rad[i].w
 //      Radius of sphere i.
 //
 //  sphere_rot. A mat4
 //    Orientation of sphere. (A rotation matrix.)
 //
 //  sphere_color. A vec4.
 //    Sphere color.

 /// Rendering Pass
 //
 //   Input primitive is point.
 //   There are no input attributes ..
 //   .. other than gl_VertexID which is automatically generated.
 //
 ///   Vertex Shader
 //
 //      Passes gl_VertexID to geometry shader.
 //      That's all the vertex shader does.
 //
 ///   Geometry Shader
 //
 //      Input: Point
 //      Output: Triangle Strip
 //
 //      Generates a square (two triangles) around sphere.
 //      From eye, the square perfectly frames the sphere.
 //
 ///   Fragment Shader
 //
 //      Determines whether pixel covered by sphere ..
 //      .. and if so, the coordinates of that point on the sphere.
 //      Fragment is dropped if pixel not covered by sphere ..
 //      .. otherwise determines normal and texture coordinates.

 /// Efficiency: True Sphere v. Tessellated Sphere
 //
 //  Operation Background
 //
 //    mad: 
 //      Multiply add.
 //      Performed by a "CUDA Core"
 //      "Cost" of one multiply or one add same as cost of one mad.
 //
 //    special:
 //      Operations using special functional unit.
 //      Include reciprocal, reciprocal square root. Used for division, sqrt.
 //      From CC 5.0 (Maxell) to present (Turing/Volta) ..
 //      .. cost is 4 times that of a mad.
 //
 //    trig:
 //      Operations requiring library code.
 //      Assume cost is 20 * mad.
 //
 //
 /// Tessellated Sphere
 //    Code in links-shdr.cc.
 //
 //    Rendered using an instanced rendering pass:
 //      One rendering pass renders n spheres.
 //      Vertex shader input is for vertex on a radius=1 sphere at origin.
 //      Instance ID used to retrieve actual radius, center, and rotation.
 //
 //    Vertex Shader Estimated Work per Vertex
 //      59 mad, 1 special.
 //      Cost: 63
 //
 //    Let s denote number of slices. Approximate: s^2 vertices in tessellation.
 //
 /// True Sphere
 //    Code in this file.
 //
 //    Fragment Shader Extra Work per Fragment
 //      Note: Extra work means work not done by tessellated sphere's fragment
 //            shader. 
 //      61 mad, 7 special, 2 trig
 //      Cost: 61 + 7*4 + 2*20 = 129
 //
 /// Comparison
 //
 //   Work FS True / Work VS Tess = 129 / 63 approx 2
 //
 //   Expect True Sphere better when:
 //     Tess Sphere  Frag / Vtx ratio < 0.5
 //



layout ( binding = 1 ) buffer sr { mat4 sphere_rot[]; };
layout ( binding = 2 ) buffer spr { vec4 sphere_pos_rad[]; };
layout ( binding = 3 ) buffer sc { vec4 sphere_color[]; };

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec3 tryout;
layout ( location = 2 ) uniform int lighting_options;
layout ( location = 4 ) uniform float tryoutf;
layout ( location = 5 ) uniform bool mirrored;
layout ( location = 6 ) uniform mat4 trans_proj;


#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS{ int vertex_id; };

void
vs_main()
{
  vertex_id = gl_VertexID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS { int vertex_id; } In[1];

out Data_to_FS
{
  flat int vertex_id;
  vec3 vertex_o;
};

// Type of primitive at geometry shader input.
//
layout ( points ) in;

// Type of primitives emitted geometry shader output.
//
layout ( triangle_strip, max_vertices = 4 ) out;

void
gs_main()
{
  vertex_id = In[0].vertex_id;
  vec4 pos_rad = sphere_pos_rad[vertex_id];
  vec3 ctr_o = pos_rad.xyz;
  float r = pos_rad.w;

  if ( mirrored ) ctr_o.y = -ctr_o.y;

  // Eye location in object space.
  vec3 e_o = vec3(gl_ModelViewMatrixInverse * vec4(0,0,0,1));

  // Vector from eye to sphere center.
  vec3 ec_o = ctr_o - e_o;  // Eye to Center (of sphere).

  // Vectors orthogonal to ec_o.
  //
  vec3 atr_o = abs(ec_o);
  int min_idx = atr_o.x < atr_o.y ? ( atr_o.x < atr_o.z ? 0 : 2 )
    : ( atr_o.y < atr_o.z ? 1 : 2 );
  vec3 ax_raw = min_idx == 0 ? vec3(0,-ec_o.z,ec_o.y)
    : min_idx == 1 ? vec3(-ec_o.z,0,ec_o.x) : vec3(-ec_o.y,ec_o.x,0);
  vec3 ax = normalize(ax_raw);
  vec3 ay = normalize(cross(ec_o,ax));

  // Compute center of the limb, lmb_o, the circle formed by the most
  // distant visible parts of the sphere surface.
  float sin_theta_sq = r * r / dot(ec_o,ec_o);

  // The following is equivalent to the simplified expression for lmb_o:
  //  vec3 lmb_o = ctr_o - sin_theta * r * ec_o / length(ec_o);
  vec3 lmb_o = ctr_o - sin_theta_sq * ec_o;

  // Compute axes to draw the limb.
  float b = r * sqrt( 1 - sin_theta_sq );
  vec3 vx = b * ax;
  vec3 vy = b * ay;

  mat4 mvp = trans_proj * gl_ModelViewMatrix;

  // Emit a bounding square for the limb.
  for ( int i = -1; i < 2; i += 2 )
    for ( int j = -1; j < 2; j += 2 )
      {
        vertex_o = lmb_o + vx * i + vy * j;
        gl_Position = mvp * vec4(vertex_o,1);
        EmitVertex();
      }
  EndPrimitive();
}

#endif


#ifdef _FRAGMENT_SHADER_

uniform sampler2D tex_unit_0;

in Data_to_FS
{
  flat int vertex_id;
  vec3 vertex_o;
};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  vec4 pos_rad = sphere_pos_rad[vertex_id];

  // Center of sphere in original object-space coordinates (oo) and possibly
  // reflected (o).
  vec3 ctr_oo = pos_rad.xyz;
  vec3 ctr_o = mirrored ? ctr_oo * vec3(1,-1,1) : ctr_oo;

  float rsq = pos_rad.w * pos_rad.w;   // mad: 1

  // Eye location in object-space coordinates.
  vec3 e_o = vec3( gl_ModelViewMatrixInverse * vec4(0,0,0,1) );  // mad: 0

  // Prepare to compute intersection of ray from eye to through fragment with
  // sphere. That intersection is the point on the sphere corresponding
  // to this fragment.
  //
  vec3 ef = vertex_o - e_o;
  float ef_d_ef = dot(ef,ef);  // mad: 3
  vec3 ce = e_o-ctr_o;
  float ce_d_ce = dot(ce,ce);  // mad: 3
  float ef_d_ce = dot(ef,ce);  // mad: 3
  float qfa = ef_d_ef;
  float qfb = 2 * ef_d_ce;     // mad: 1
  float qfc = ce_d_ce - rsq;
  float discr = qfb*qfb - 4 * qfa * qfc;  // mad: 3

  // If outside the limb, return.
  if ( discr < 0 ) discard;

  // Finish computing coordinate of point for this fragment.
  //
  float t = ( -qfb - sqrt( discr ) ) / ( 2 * qfa ); // mad: 1;  spc: 2
  vec4 sur_o = vec4(e_o + t * ef, 1);               // mad: 1

  {
    // Compute clip-space depth. Take care so that compiler avoids full
    // matrix / vector multiplication.
    vec4 sur_e = gl_ModelViewMatrix * sur_o;          // mad: 4
    vec4 sur_c = trans_proj * vec4(0,0,2*sur_e.z,1);  // mad: 1
    gl_FragDepth = sur_c.z / sur_c.w;                 // spc: 1
  }

  // Compute eye-space coordinate and vector of unreflected point.
  //
  vec4 sur_oo = mirrored ? sur_o * vec4(1,-1,1,1) : sur_o;
  vec3 normal_oo = normalize(sur_oo.xyz - ctr_oo);         // mad: 3  spc: 1
  vec3 normal_ee = normalize(gl_NormalMatrix * normal_oo); // mad: 12 spc: 1
  vec4 sur_ee = gl_ModelViewMatrix * sur_oo;               // mad: 16

  // Use sphere-local coordinates to compute texture coordinates.
  //
  vec3 sur_l = mat3(sphere_rot[vertex_id]) * normal_oo;    // mad: 9
  float pi = 3.14159265359;
  float tpi = 2 * pi;
  float theta = atan(sur_l.x,sur_l.z);                     // trg: 1
  float eta = acos(sur_l.y);                               // trg: 1
  vec2 tcoord = vec2( ( 1.5 * pi + theta ) / tpi, eta / pi );  // spc: 2

  // Totals: mad: 61   spc: 7   trg: 2

  // Get filtered texel.
  //
  vec4 texel = texture(tex_unit_0,tcoord);

  vec4 color = sphere_color[vertex_id];
  vec4 color2 = gl_FrontFacing != mirrored ? color : vec4(0.5,0,0,1);

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = texel * generic_lighting(sur_ee, color2, normal_ee);
}

///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Return lighted color of vertex_e.
  //

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

      float d_n_vl = dot(normal_e, v_vtx_l_n);
      float phase_light = max(0,gl_FrontFacing != mirrored ? d_n_vl : -d_n_vl );

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
