/// LSU EE 4702-1 (Fall 2015), GPU Programming
//
 /// Homework 4
 //
 //  Use this file for your solution.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2015/hw04.pdf



// Specify version of OpenGL Shading Language.
//
#version 430 compatibility

layout ( location = 2 ) uniform int tri_cull;

// Use this variable to debug your code. Press 'y' to toggle tryout.x
// and 'Y' to toggle debug_bool.y (between true and false).
//
layout ( location = 3 ) uniform bvec2 tryout;



// Array of ball positions.
//
layout ( binding = 1 ) buffer Balls_Pos { vec4 balls_pos_rad[]; };
layout ( binding = 2 ) buffer Balls_Color { vec4 balls_color[]; };
layout ( binding = 4 ) buffer Balls_Velocity { vec4 balls_velocity[]; };



#ifdef _VERTEX_SHADER_

// Interface block for vertex shader output / geometry shader input.
//
out Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;

  /// SOLUTION -- Problem 3
  //
  //  Pass instance ID to geometry shader.
  int inst_id;

  // Any changes here must also be made to the fragment shader input.

};


void
vs_main()
{
  // Here, the vertex shader does nothing except pass variables
  // to the geometry shader.

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  vertex_e = gl_ModelViewMatrix * gl_Vertex;
  normal_e = gl_NormalMatrix * gl_Vertex.xyz;
  color = gl_Color;

  /// SOLUTION -- Problem 3
  //
  //  Set instance ID to -1, indicating that this is not a sphere.
  inst_id = -1;
}

void
vs_main_instances()
{
  vec4 center_o_rad = balls_pos_rad[gl_InstanceID];
  float rad = center_o_rad.w;
  vec3 to_surface = rad * gl_Vertex.xyz;
  vec4 position_o = vec4(center_o_rad.xyz + to_surface, 1f);

  gl_Position = gl_ModelViewProjectionMatrix * position_o;
  vertex_e = gl_ModelViewMatrix * position_o;
  normal_e = gl_NormalMatrix * gl_Vertex.xyz;
  color = balls_color[gl_InstanceID];

  /// SOLUTION -- Problem 3
  //
  //  Pass instance ID to geometry shader. This is only done for spheres.
  //
  inst_id = gl_InstanceID;
}

#endif


#ifdef _GEOMETRY_SHADER_

in Data_to_GS
{
  vec3 normal_e;
  vec4 vertex_e;
  vec4 color;
  vec4 gl_Position;
  int inst_id;        /// SOLUTION -- Problem 3
} In[];

out Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;
};

// Type of primitive at geometry shader input.
//
layout ( triangles ) in;

// Type of primitives emitted geometry shader output.
//
 /// SOLUTION -- Problem 3
//   Increase number of vertices to 6 to accommodate peeled triangle. 
layout ( triangle_strip, max_vertices = 6 ) out;


 /// SOLUTION -- Problem 3
//   Entire peeled routine.
bool
peeled(vec3 gnorm_e)
{
  // Routine to be called from the geometry shader before emitting a
  // triangle. This routine will, if appropriate, emit a triangle that
  // looks like it's peeling off the sphere due to the force of
  // rushing air, and return true. Otherwise return false.

  // Return if this primitive isn't part of a sphere. (The
  // vertex shader sets inst_id, and it knows.)
  //
  if ( In[0].inst_id < 0 ) return false;

  // Since we already have eye-space vertex coordinates, convert
  // the velocity to eye space. Note that vectors are transformed
  // using a different transformation than coordinates.
  //
  vec3 vel_o = balls_velocity[In[0].inst_id].xyz;
  vec3 vel_e = gl_NormalMatrix * vel_o;

  // Return if air presses triangle into sphere.
  //
  float inward_amt = dot(vel_e,gnorm_e);
  if ( inward_amt > 0 ) return false;

  // Find the triangle vertex that is furthest downstream in the
  // direction of motion.
  //
  float upstr_amt[3];
  for ( int i=0; i<3; i++ ) upstr_amt[i] = dot(In[i].vertex_e.xyz,vel_e);
  int min01 = upstr_amt[0] < upstr_amt[1] ? 0 : 1;
  int free_i = upstr_amt[min01] < upstr_amt[2] ? min01 : 2;

  // Get the indices of the other two vertices.
  //
  int a0 = ( free_i + 1 ) % 3;
  int a1 = ( free_i + 2 ) % 3;

  // If the downstream vertex (free_i) is too close to either of the
  // other two vertices, return. This happens when the sphere is
  // moving slowly or not at all.
  //
  if ( abs(upstr_amt[free_i] - upstr_amt[a0]) < .01 ) return false;
  if ( abs(upstr_amt[free_i] - upstr_amt[a1]) < .01 ) return false;

  // Get the vertices' coordinates.
  //
  vec3 p_0 = In[a0].vertex_e.xyz;
  vec3 p_1 = In[a1].vertex_e.xyz;
  vec3 p_f = In[free_i].vertex_e.xyz;

  // Note: edge 01 (axis) doesn't move.
  //
  vec3 axis = p_1 - p_0;
  vec3 axis_n = normalize(axis);

  // Find the velocity component that's not along the axis, vel_rad.
  // It is vel_rad that will cause the triangle to swing along axis.
  //
  float vel_axis = dot(vel_e,axis_n);
  vec3 vel_rad = vel_e - vel_axis * axis_n;
  float vel_rad_mag = length(vel_rad);
  vec3 vel_rad_n = vel_rad/vel_rad_mag;

  // If axis is fixed and the triangle can't change its shape,
  // the free vertex will move in a circle. Find two vectors
  // orthogonal to axis, v_cf and v_up, that can be used to find
  // points on this circle. (See the line assigning p_r.)
  //
  vec3 v_0f = p_f - p_0;
  vec3 p_c = p_0 + axis_n * dot(axis_n,v_0f);
  vec3 v_cf = p_f - p_c;
  float len_cf_sq = dot(v_cf,v_cf);
  float len_cf = sqrt(len_cf_sq);
  vec3 v_up = cross(axis_n,v_cf);

  // Compute the position of the free vertex that aligns the triangle
  // with the direction of motion (as though it were pushed by the
  // rushing air [ignoring the effect of the sphere shape on air
  // flow]).
  //
  vec3 p_r_max = p_c - len_cf * vel_rad_n;
  vec3 v_cr_max = p_r_max - p_c;

  // Compute the angle that triangle 01f makes with 01rmax.
  //
  float bend = dot(v_cf,v_cr_max) / len_cf_sq;
  float angle_max = acos(bend);

  // Scale that angle based on the velocity.
  //
  float stiffness = 10;
  float angle = ( 1 - stiffness/(stiffness+vel_rad_mag) ) * angle_max;

  // Compute the position of the free vertex based upon the magnitude
  // of the velocity.
  //
  vec3 p_r = p_c + v_cf * cos(angle) + v_up * sin(angle);

  // Collect the vertices in a convenient array.
  //
  vec3 vertices[3] = { p_0, p_1, p_r };

  // The triangle should look like it's peeling off the
  // sphere. Therefore, use the sphere normals for the two fixed
  // vertices (p_0 and p_1), and the normal of triangle 01r for the
  // free vertex (p_r).
  //
  vec3 normal_r_e = normalize(cross(axis,p_r-p_0));
  vec3 normals[3] = { In[a0].normal_e, In[a1].normal_e, normal_r_e };

  color = In[0].color;  // We know that all vertices are the same color.
  for ( int i=0; i<3; i++ )
    {
      normal_e = normals[i];
      vertex_e = vec4(vertices[i],1);
      gl_Position = gl_ProjectionMatrix * vertex_e;
      EmitVertex();
    }
  EndPrimitive();

  return true;
}


void
gs_main_simple()
{
  /// Problem 1 and 3 Solution Here.
  //
  //  Behavior:
  //    When try_cull = 0, emit all triangles.
  //    When try_cull = 1, only emit triangles facing user.
  //    When try_cull = 2, only emit triangles not facing user.

  /// SOLUTION  Problem 1

  // Compute the normal based on the triangle coordinates (geometric
  // norm) rather than using the vertex normal.
  //
  vec3 gnorm_e = cross
    ( In[1].vertex_e.xyz - In[0].vertex_e.xyz,
      In[2].vertex_e.xyz - In[1].vertex_e.xyz );

  // Compute the vector to the user. This is easy in eye space because
  // the user is at the origin.
  //
  vec3 to_user = -In[0].vertex_e.xyz;

  // Determine if the triangle is facing the user.
  float visibility = dot( gnorm_e, to_user );
  if ( tri_cull == 1 && visibility < 0 ) return;
  if ( tri_cull == 2 && visibility > 0 ) return;

  /// SOLUTION -- Problem 3
  //
  //  Call routine peeled to emit a peeled triangle (if any). If the
  //  return value is true then a peeled triangle was emitted.
  //
  bool peeled_tri = peeled(gnorm_e);

  for ( int i=0; i<3; i++ )
    {
      normal_e = In[i].normal_e;
      vertex_e = In[i].vertex_e;

      /// SOLUTION -- Problem 3
      //  If this triangle has peeled, then use dark red for the
      //  surface of the sphere.
      color = peeled_tri ? vec4(0.5,0,0,1) : In[i].color;
      gl_Position = In[i].gl_Position;
      EmitVertex();
    }
  EndPrimitive();
}



#endif


#ifdef _FRAGMENT_SHADER_

in Data_to_FS
{
  vec3 normal_e;
  vec4 vertex_e;
  flat vec4 color;

};

vec4 generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e);


void
fs_main()
{
  // Perform lighting, fetch and blend texture, then emit fragment.
  //

  // Multiply filtered texel color with lighted color of fragment.
  //
  gl_FragColor = generic_lighting(vertex_e, color, normalize(normal_e));

  // Copy fragment depth unmodified.
  //
  gl_FragDepth = gl_FragCoord.z;
}


///
/// Routine used by Either Vertex or Fragment Shader
///

vec4
generic_lighting(vec4 vertex_e, vec4 color, vec3 normal_e)
{
  // Return lighted color of vertex_e.
  //
  vec4 light_pos = gl_LightSource[0].position;
  vec3 v_vtx_light = light_pos.xyz - vertex_e.xyz;
  float d_n_ve = -dot(normal_e,vertex_e.xyz);
  float d_n_vl = dot(normal_e, normalize(v_vtx_light).xyz);
  bool same_sign = ( d_n_ve > 0 ) == ( d_n_vl > 0 );
  float phase_light = same_sign ? abs(d_n_vl) : 0;

  vec3 ambient_light = gl_LightSource[0].ambient.rgb;
  vec3 diffuse_light = gl_LightSource[0].diffuse.rgb;
  float dist = length(v_vtx_light);
  float distsq = dist * dist;
  float atten_inv =
    gl_LightSource[0].constantAttenuation +
    gl_LightSource[0].linearAttenuation * dist +
    gl_LightSource[0].quadraticAttenuation * distsq;
  vec4 lighted_color;
  lighted_color.rgb =
    color.rgb * gl_LightModel.ambient.rgb
    + color.rgb * ( ambient_light + phase_light * diffuse_light ) / atten_inv;
  lighted_color.a = color.a;
  return lighted_color;
}

#endif
