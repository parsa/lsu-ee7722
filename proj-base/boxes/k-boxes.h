/// LSU EE X70X-X (Fall 2012), GPU Programming
//
 /// CUDA code for computing intersection volume of boxes.

// $Id:$

struct Isect_Boxes;

struct Isect_Edge {
public:
  __device__ Isect_Edge() {
    outside = false; lo_t = 0;  hi_t = 1e10f;
    lo_face = hi_face = -1;
  }
  pLine line;
  float lo_t, hi_t;
  char lo_face, hi_face;
  bool outside;
};

struct Isect_Thread {
public:
  __device__ Isect_Thread(Isect_Boxes *bp):b(bp),ie1(),ie2() {
    vec_sum = mv(0,0,0);
    volume_sum = 0;
  }
  Isect_Edge ie1, ie2;
  pVect vec_sum;
  float volume_sum;
  Isect_Boxes* const b;
};

struct Isect_Line {
  __device__ void init(){ occ = false; }
  pVect pt;
  int occ;
};


struct Isect_Face {
public:
  __device__ void init() { ref_pt_set = false; }
  __device__ void line_add
  (Isect_Thread& it, pCoor pt_lo, pCoor pt_hi, bool area);
  pCoor face_ref_pt;
  int ref_pt_set;
  pVect vol_to_face;
  float area_sum;
};

struct Isect_Boxes {

  __device__ void
  init()
  {
    ref_pt_set = false;
    vol_pieces = 0;
  };

  __device__ void
  line_add(Isect_Thread& it, int f1, int f2, pCoor p1, pCoor p2);
  __device__ void
  intersect_point_add
  (Isect_Thread& it, int f1, int f2, bool first, pCoor pt);
  Isect_Face faces[12];
  Isect_Line l[6][6];
  pCoor vol_ref_pt;
  int ref_pt_set;
  unsigned int vol_pieces;
};

__device__ void
Isect_Boxes::line_add(Isect_Thread& it, int f1, int f2, pCoor p1, pCoor p2)
{
  const bool im_first = !ref_pt_set && !atomicExch(&ref_pt_set,true);
  if ( im_first ) vol_ref_pt = p1;

  faces[f1].line_add(it,p1,p2,false);
  faces[f2].line_add(it,p1,p2,true);
}

__device__ void
Isect_Boxes::intersect_point_add
(Isect_Thread& it, int f1p, int f2p, bool first, pCoor pt)
{
  const int f1 = first ? f1p : f2p;
  const int f2 = first ? f2p : f1p;
  Isect_Line* const il = &l[f1][f2];
  const bool im_first = !atomicExch( &il->occ, 1 );
  if ( im_first ) il->pt = pt;
  __threadfence();
  if ( im_first ) return;
  line_add(it,f1,f2+6,il->pt,pt);
}

__device__ void
Isect_Face::line_add
(Isect_Thread& it, pCoor p1, pCoor p2, bool area)
{
  const bool im_first = !atomicExch(&ref_pt_set,true);
  if ( im_first )
    {
      face_ref_pt = p1;
      vol_to_face = mv(it.b->vol_ref_pt,face_ref_pt);
      area_sum = 0;
    }

  __threadfence();

  pVect ftop1 = mv(face_ref_pt,p1);
  pVect ftop2 = mv(face_ref_pt,p2);
  pVect cp = cross(ftop1,ftop2);
  const float volx6 = fabs(dot(vol_to_face,cp));
  pVect centroidx3 = ( p1 + p2 + face_ref_pt );
  it.volume_sum += volx6;
#ifdef XX_DEBUG
  atomicAdd(&it.b->vol_pieces,1);
#endif
  pVect c_scaled = volx6 * centroidx3;
  it.vec_sum += c_scaled;
  if ( !area ) return;
  const float areax2 = dot(cp,cp);
  atomicAdd(&area_sum,areax2);
}

__device__ CUDA_Box_W
xx_box_get_pos_rad(int m_idx)
{
  CUDA_Box_W box;
  float4 pos_rad = balls_x.position[m_idx];
  box.position = m3(pos_rad);
  box.radius = pos_rad.w;
  return box;
}

__device__ void
xx_box_get_other(CUDA_Box_W& box, int m_idx)
{
  set_f3(box.to_111, balls_x.to_111[m_idx]);
  box.orientation = balls_x.orientation[m_idx];
  pMatrix_set_rotation_transpose(box.rot_inv, box.orientation);
}

__device__ void box_box_intersect_1
(CUDA_Box_W& box1, CUDA_Box_W& box2, Isect_Edge& ie);
__device__ void box_box_intersect_2
(Isect_Thread& it, CUDA_Box_W& box1, CUDA_Box_W& box2, bool first,
 Isect_Edge& ie, int edge2);

__global__ void
pass_xx_intersect(int xx_pairs_count)
{
  const int thds_per_bb_lg = 4;
  const int per_bb_mask = ( 1 << thds_per_bb_lg ) - 1;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int xx_idx = tid >> thds_per_bb_lg;
  const int bxx_idx = threadIdx.x >> thds_per_bb_lg;
  const int max_block_size = 256;
  const int xx_per_block_max = max_block_size >> thds_per_bb_lg;
  const int part_idx = threadIdx.x & per_bb_mask;
  const bool lead_thd = part_idx == 0;

  __shared__ Isect_Boxes isba[xx_per_block_max];

  if ( xx_idx >= xx_pairs_count ) return;
  if ( part_idx >= 12 ) return;

  XX_Pair box_pair = xx_pairs[xx_idx];

  CUDA_Box_W box1 = xx_box_get_pos_rad(box_pair.x);
  CUDA_Box_W box2 = xx_box_get_pos_rad(box_pair.y);

  pNorm b1tob2 = mn(box1.position,box2.position);
  if ( b1tob2.magnitude >= box1.radius + box2.radius  )
    {
      if ( lead_thd )
        xx_sects_dir[box_pair.z] = make_float4(b1tob2.magnitude,0,2.2f,0);
      return;
    }

  xx_box_get_other(box1,box_pair.x);  xx_box_get_other(box2,box_pair.y);

  Isect_Boxes& isb = isba[bxx_idx];
  if ( lead_thd ) isb.init();
  isb.faces[part_idx].init();

  const bool f2_start = part_idx >= 6;
  const int f1 = f2_start ? part_idx - 6 : part_idx;
  for ( int f2 = f2_start;  f2 < 6;  f2 += 2 ) isb.l[f2][f1].init();

  Isect_Thread it(&isb);
  it.ie1.line = box_get_edge(box1,part_idx);
  it.ie2.line = box_get_edge(box2,part_idx);

  box_box_intersect_1(box1,box2,it.ie2);
  box_box_intersect_1(box2,box1,it.ie1);

  if ( !it.ie2.outside )
    box_box_intersect_2(it,box1,box2,true,it.ie2,part_idx);
  if ( !it.ie1.outside )
    box_box_intersect_2(it,box2,box1,false,it.ie1,part_idx);

  __shared__ float volume_sum_a[max_block_size];
  __shared__ pVect vec_sum_a[max_block_size];
  volume_sum_a[threadIdx.x] = it.volume_sum;
  vec_sum_a[threadIdx.x] = it.vec_sum;

  if ( !lead_thd ) return;

  float volume_sum = 0;
  pVect vec_sum = mv(0,0,0);
  for ( int i=0; i<12; i++ )
    {
      volume_sum += volume_sum_a[threadIdx.x+i];
      vec_sum += vec_sum_a[threadIdx.x+i];
    }

  float vol_area_sum = 0;
  pVect dir = mv(0,0,0);
  int ref_pt_count = 0;
#ifdef XX_DEBUG
  float a[6]; int aptr=0;
#endif

  for ( int f=6; f<12; f++ )
    {
      if ( !isb.faces[f].ref_pt_set ) continue;
      ref_pt_count++;
      pVect n2 = box_get_face_norm(box2,f-6);
      const float wt = isb.faces[f].area_sum;
      dir += wt * n2;
      vol_area_sum += wt;
#ifdef XX_DEBUG
      a[aptr++]=wt;
#endif
    }

  vec_sum += volume_sum * isb.vol_ref_pt;

#ifdef XX_DEBUG
  xx_sects_debug[box_pair.z] =
    // make_float4(ref_pt_count,a[2],a[1],a[3]);
    make_float4(ref_pt_count,isb.vol_pieces,volume_sum,vol_area_sum);
#endif

  if ( volume_sum < 0.001f || vol_area_sum < 0.01f )
    {
      xx_sects_dir[box_pair.z] = make_float4(volume_sum,0,1.1f,0);
      return;
    }

  pCoor centroid = mv(0,0,0) + (0.25f/volume_sum) * vec_sum;

  pNorm dirN = mn(dir);
  float4 dir_and_m = m4(-dirN.v,volume_sum);
  xx_sects_dir[box_pair.z] = dir_and_m;
  xx_sects_center[box_pair.z] = m4(centroid,volume_sum);
}

__device__ void
box_box_intersect_1
(CUDA_Box_W& box1, CUDA_Box_W& box2, Isect_Edge& ie)
{
  pLine line2 = ie.line;
  pCoor p2 = line2.start;
  pVect u2 = line2.dir;
  const float l = line2.len;

#define OUTSIDE { ie.outside = true; }

#define ITER(axis1,front1)                                                    \
  {                                                                           \
    pVect a1 = box_get_axis_norm(box1,axis1);                                 \
    const float u2da1 = dot(u2,a1);                                           \
    const bool edge_par_to_face = fabs(u2da1) < 0.0001f;                      \
    const int face1 = ( axis1 << 1 ) + front1;                                \
    const int idx1 = front1 << (2-axis1);                                     \
    pCoor p1 = box_get_vertices(box1,idx1);                                   \
    if ( !ie.outside )                                                        \
      {                                                                       \
        pVect p1p2 = mv(p1,p2);                                               \
        const float p1p2dist = dot(p1p2,a1);                                  \
        const bool p2_outside = front1 ? p1p2dist > 0 : p1p2dist < 0;         \
        const bool e_inward = front1 ? u2da1 < 0 : u2da1 > 0;                 \
        const float t = edge_par_to_face ? 0 : -p1p2dist / u2da1;             \
        if ( edge_par_to_face ) {                                             \
          if ( p2_outside ) { OUTSIDE; }                                      \
        }                                                                     \
        else if ( p2_outside )                                                \
          {                                                                   \
            if ( !e_inward || t>=l || t > ie.hi_t ) { OUTSIDE; }              \
            else if ( t > ie.lo_t ) {                                         \
              ie.lo_face = face1;  ie.lo_t = t; }                             \
          }                                                                   \
        else if ( e_inward ) { /* Do nothing. */ }                            \
        else if ( t > l ) { set_min(ie.hi_t,l); }                             \
        else if ( t < ie.lo_t ) { OUTSIDE; }                                  \
        else if ( t < ie.hi_t ) {ie.hi_face = face1;  ie.hi_t = t;}           \
      }}

  ITER(0,0); ITER(0,1);
  ITER(1,0); ITER(1,1);
  ITER(2,0); ITER(2,1);

# undef OUTSIDE
# undef ITER
}

__device__ void
box_box_intersect_2
(Isect_Thread& it, CUDA_Box_W& box1, CUDA_Box_W& box2, bool first,
 Isect_Edge& ie2, int edge2)
{
  const int face_base = first ? 6 : 0;
  Isect_Boxes* const isb = it.b;
  pLine line2 = ie2.line;

  pCoor pt_lo = line2.start + ie2.lo_t * line2.dir;
  pCoor pt_hi = line2.start + ie2.hi_t * line2.dir;

  const int axis2 = edge2 >> 2;
  const int face_x_axis = axis2 ? 0 : 2;
  const int face_y_axis = axis2 == 2 ? 2 : 4;
  const int face_x = face_x_axis + ( ( edge2 & 2 ) >> 1 );
  const int face_y = face_y_axis + ( edge2 & 1 );

  isb->line_add(it,face_base+face_x,face_base+face_y,pt_lo,pt_hi);

  if ( ie2.lo_face >= 0 )
    {
      isb->intersect_point_add(it,ie2.lo_face,face_x,first,pt_lo);
      isb->intersect_point_add(it,ie2.lo_face,face_y,first,pt_lo);
    }

  if ( ie2.hi_face >= 0 )
    {
      isb->intersect_point_add(it,ie2.hi_face,face_x,first,pt_hi);
      isb->intersect_point_add(it,ie2.hi_face,face_y,first,pt_hi);
    }
}

__device__ CUDA_SectTT
box_sphere_interpenetrate
(CUDA_Box_W& box, pCoor sphere_pos, float radius)
{
  CUDA_SectTT sect; sect.exists = false;
  pVect btos = mv(box.position,sphere_pos);
  const float dist_sq = ( box.radius + radius ) * ( box.radius + radius );
  if ( dot(btos,btos) >= dist_sq ) return sect;
  pVect btosl = box.rot_inv * btos;
  pVect btosla = fabs(btosl);
  pVect dist = btosla - box.to_111;
  const float max_dist = max(dist);
  if ( max_dist >= radius ) return sect;
  pVect tact = mv(dist.x > 0 ? copysignf(box.to_111.x,btosl.x) : btosl.x,
                  dist.y > 0 ? copysignf(box.to_111.y,btosl.y) : btosl.y,
                  dist.z > 0 ? copysignf(box.to_111.z,btosl.z) : btosl.z);
  sect.start = box.position + mm_transpose(box.rot_inv,tact);
  pNorm dir = mn(sect.start,sphere_pos);
  if ( dir.mag_sq > radius*radius ) return sect;
  const float pen = radius - dir.magnitude;
  sect.dir = dir.v;
  sect.pen_dist = pen;
  sect.exists = true;
  return sect;
}

__device__ bool
penetration_box_ball_resolve
(CUDA_Phys_W& boxp, CUDA_Phys_W& ballp, bool friction)
{
  CUDA_Box_W& box = boxp.box;
  CUDA_Ball_W& ball = ballp.ball;

  CUDA_SectTT sect = box_sphere_interpenetrate(box,ball.position,ball.radius);
  if ( !sect.exists ) return false;

  pNorm sep_normal = mn(sect.dir,sect.pen_dist);
  pCoor pos = sect.start;

  const float pen_dist = 0.1f * sect.pen_dist;

  pVect vel1 = box_get_vel(box,pos);
  pVect vel2 = ball.prev_velocity;
  pVect velto1 = vel2 - vel1;

  const float sep_vel = dot(velto1,sep_normal);

  const double loss_factor = 1 - opt_bounce_loss_box;
  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const bool separating = sep_vel >= 0;
  const float appr_force_dt = separating
    ? force_dt_no_loss * loss_factor : force_dt_no_loss;

  pVect sep_force = appr_force_dt * sep_normal;

  box_apply_force_dt(box, pos, -sep_force );
  ball.velocity += ball.mass_inv * sep_force;

  pVect vel1b = box_get_vel(box,pos);
  pVect vel2b =
    point_rot_vel(ball.omega,ball.radius,-sep_normal) + ball.velocity;

  pVect velto1b = vel2b - vel1b;

  const float sep_velb = dot(velto1b,sep_normal);
  pNorm tan_vel = mn(velto1b - sep_velb * sep_normal);
  const float fric_force_dt_potential = force_dt_no_loss * opt_friction_coeff;
  const float ball_mi_inv =
    2.5f * ball.mass_inv / ( ball.radius * ball.radius );
  const float fdt_limit =
    tan_vel.magnitude /
    (
     ( boxp.read_only ? 0
       : box.mass_inv + box_get_moment_of_inertia_inv(box,pos,tan_vel) )
     + ( ballp.read_only ? 0 : ball.mass_inv + ball_mi_inv ));

  const float fric_force_dt = min(fdt_limit,fric_force_dt_potential);

  box_apply_force_fric_dt(box, pos, tan_vel, fric_force_dt);
  ball.velocity -= fric_force_dt * ball.mass_inv * tan_vel;
  ball.omega += tan_force_dt(sep_normal,tan_vel.v,fric_force_dt);

  /// Torque
  //
  //
  // Account for forces of surfaces twisting against each
  // other. (For example, if one box is spinning on top of
  // another.)
  //
  const float appr_omega =
    dot(box.omega,sep_normal) - dot(ball.omega,sep_normal);
  if ( fabs(appr_omega) > 0.00001f )
    {
      const float mi1_inv = box_get_moment_of_inertia_inv(box,sep_normal);
      const float mi2_inv = get_fdt_to_do(ball.radius,ball.mass_inv);
      const float fdt_limit = fabs(appr_omega) / ( mi1_inv + mi2_inv );
      const bool rev = appr_omega < 0;
      const float fdt_raw = min(fdt_limit,fric_force_dt);
      const pVect fdt_v = ( rev ? fdt_raw : -fdt_raw ) * sep_normal;
      if ( !boxp.read_only ) box.omega += mi1_inv * fdt_v;
      if ( !ballp.read_only ) ball.omega -= mi2_inv * fdt_v;
    }

  return true;
}
