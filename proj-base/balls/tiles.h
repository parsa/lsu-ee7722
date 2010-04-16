/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for ball / rectangle physics.

// $Id:$

pVect vec_pos(pVect v)
{ return pVect(max(v.x,0.0f),max(v.y,0.0f),max(v.z,0.0f)); }
pVect vec_neg(pVect v)
{ return pVect(min(v.x,0.0f),min(v.y,0.0f),min(v.z,0.0f)); }

struct Bounding_Box {
  Bounding_Box(){ initialized = false; }
  Bounding_Box operator = (Bounding_Box b)
  {
    initialized = true;
    ll = b.ll;  ur = b.ur;
    return *this;
  }
  Bounding_Box operator += (Bounding_Box b)
  {
    if ( !initialized ) return operator = (b);
    set_min(ll.x,b.ll.x); set_min(ll.y,b.ll.y); set_min(ll.z,b.ll.z);
    set_max(ur.x,b.ur.x); set_max(ur.y,b.ur.y); set_max(ur.z,b.ur.z);
    return *this;
  }
  bool initialized;
  pCoor ll, ur;
};

class Tile : public Phys {
public:
  Tile(bool &cuda_stale, pCoor ll, pVect up, pVect rt)
    :Phys(PT_Tile),cuda_stale(cuda_stale),marker(NULL)
  {
    read_only = true;
    set(ll,up,rt);
  }
  ~Tile(){ ASSERTS( false ); }

  void set(pCoor ll, pVect up, pVect rt)
  {
    pt_ll = ll;
    pt_ul = ll + up;
    pt_lr = ll + rt;
    vec_up = up;
    vec_rt = rt;
    normal.set(cross(rt,up));
    norm_rt.set(rt);
    width = norm_rt.magnitude;
    norm_up.set(up);
    height = norm_up.magnitude;
    cuda_stale = true;
    bb.ll = pt_ll + vec_neg(vec_up) + vec_neg(vec_rt);
    bb.ur = pt_ll + vec_pos(vec_up) + vec_pos(vec_rt);
  }

  float max_z_get(double delta_t){ return bb.ur.z; }
  float min_z_get(double delta_t){ return bb.ll.z; }

  Bounding_Box bounding_box_get(){return bb;}

  bool& cuda_stale;
  void *marker;
  pCoor pt_ll; // A corner called lower-left but it doesn't have to be.
  pCoor pt_ul, pt_lr;
  pVect vec_up;
  pVect vec_rt;
  pNorm normal, norm_rt, norm_up;
  pColor color;
  float width, height;
  Bounding_Box bb;
  Ball *ball_tested;
};

class Tile_Manager {
public:
  Tile_Manager(){ phys_list = NULL; cuda_stale = true; };
  void init(Phys_List *pl){ phys_list = pl; }
  void render(bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Tile* new_tile(pCoor ll, pVect up, pVect rt, pColor color);
  Tile* new_tile(pCoor ll, pVect up, pVect rt);
  Tile* iterate();
  int occ() { return tiles.occ(); }

private:
  World* w;
  PStack<Tile*> tiles;
  Phys_List *phys_list;
  bool cuda_stale;
};

Tile*
Tile_Manager::new_tile(pCoor ll, pVect up, pVect rt, pColor color)
{
  Tile* const rv = new_tile(ll,up,rt);
  rv->color = color;
  return rv;
}

Tile*
Tile_Manager::new_tile(pCoor ll, pVect up, pVect rt)
{
  Tile* const rv = new Tile(cuda_stale,ll,up,rt);
  tiles += rv;
  phys_list->push(rv);
  return rv;
}

Tile*
Tile_Manager::iterate()
{
  Tile** const tp = tiles.iterate();
  return tp ? *tp : NULL;
}

void
Tile_Manager::render(bool simple)
{
  glBegin(GL_TRIANGLES);
  for ( PStackIterator<Tile*> tile(tiles); tile; tile++ )
    {
      if ( !simple )
        {
          glColor3fv(tile->color);
          glNormal3fv(tile->normal);
        }
      glVertex3fv(tile->pt_ul);
      glVertex3fv(tile->pt_ll);
      glVertex3fv(tile->pt_lr);
      glVertex3fv(tile->pt_lr);
      glVertex3fv(tile->pt_ll+tile->vec_rt+tile->vec_up);
      glVertex3fv(tile->pt_ul);
    }
  glEnd();
}

void
Tile_Manager::render_simple(){ render(true); }

void
Tile_Manager::render_shadow_volume(pCoor light_pos)
{
  const float height = 1000;
  for ( PStackIterator<Tile*> tile(tiles); tile; tile++ )
    {
      pCoor pt_ur = tile->pt_ll+tile->vec_rt+tile->vec_up;
      pNorm l_to_ul(light_pos,tile->pt_ul);
      pCoor ul_2 = light_pos + height * l_to_ul;
      pCoor ll_2 = light_pos + height * pNorm(light_pos,tile->pt_ll);
      pCoor lr_2 = light_pos + height * pNorm(light_pos,tile->pt_lr);
      pCoor ur_2 = light_pos + height * pNorm(light_pos,pt_ur);
      const bool facing_light = dot(tile->normal,l_to_ul) < 0;

      if ( facing_light )
        glFrontFace(GL_CW);
      else
        glFrontFace(GL_CCW);

      glBegin(GL_QUAD_STRIP);
      glVertex3fv(tile->pt_ll);
      glVertex3fv(ll_2);
      glVertex3fv(tile->pt_lr);
      glVertex3fv(lr_2);
      glVertex3fv(pt_ur);
      glVertex3fv(ur_2);
      glVertex3fv(tile->pt_ul);
      glVertex3fv(ul_2);
      glVertex3fv(tile->pt_ll);
      glVertex3fv(ll_2);
      glEnd();
    }
  glFrontFace(GL_CCW);
}

bool
tile_sphere_intersect
(Tile *tile, pCoor position, float radius,
 pCoor& tact_pos, pNorm& tact_dir, bool dont_compute_tact = false)
{
  pVect tile_to_ball(tile->pt_ll,position);

  // Distance from tile's plane to the ball.
  const float dist = dot(tile_to_ball,tile->normal); 

  if ( fabs(dist) > radius ) return false;

  // The closest point on tile plane to the ball.
  pCoor pt_closest = position - dist * tile->normal; 

  // How far up the tile in the y direction the center of the ball sits
  const float dist_ht = dot(tile->norm_up,tile_to_ball);  

  if ( dist_ht < -radius ) return false; 
  if ( dist_ht > tile->height + radius ) return false;

  // How far up the tile in the x direction the center of the ball sits
  const float dist_wd = dot(tile->norm_rt,tile_to_ball);
  if ( dist_wd < -radius ) return false;
  if ( dist_wd > tile->width + radius ) return false;

  // The return value here should be maybe, but true is good enough
  // for preparing a proximity list.
  if ( dont_compute_tact ) return true;

  // If ball touching tile surface (not including an edge or corner)
  // then set up the pseudo ball for collision handling
  if ( dist_ht >= 0 && dist_ht <= tile->height
       && dist_wd >= 0 && dist_wd <= tile->width )
    {
      tact_pos = pt_closest;
      tact_dir = dist > 0 ? -tile->normal : tile->normal;
      return true;
    }

  const float radius_sq = radius * radius;

  // Test whether the ball is touching a corner
  if ( ( dist_ht < 0 || dist_ht > tile->height ) 
       && ( dist_wd < 0 || dist_wd > tile->width) )
    {
      // We need to place the pseudo ball based upon the vector from
      // ball position to the corner. First step is to figure out which
      // corner.

      if ( dist_ht < 0 && dist_wd < 0 ) 
        {
          tact_pos = tile->pt_ll;
        }
      else if ( dist_ht < 0 && dist_wd > tile->width ) 
        {
          tact_pos = tile->pt_lr;
        }
      else if ( dist_ht > tile->height && dist_wd < 0 ) 
        {
          tact_pos = tile->pt_ul;
        }
      else 
        {
          tact_pos = tile->pt_ll+tile->vec_rt+tile->vec_up;
        }
    }
  else
    {
      // Else the ball is touching an edge

      const bool tact_horiz = dist_ht < 0 || dist_ht > tile->height;
      const pVect corner_to_tact =
        tact_horiz ? dist_wd * tile->norm_rt : dist_ht * tile->norm_up;
      const pCoor ref_pt =
        tact_horiz ? ( dist_ht < 0 ? tile->pt_ll : tile->pt_ul ) :
        ( dist_wd < 0 ? tile->pt_ll : tile->pt_lr );

      // Find the closest edge point of the tile to the ball
      tact_pos = ref_pt + corner_to_tact;
    }

  tact_dir = pVect(position,tact_pos);
  return tact_dir.mag_sq < radius_sq;
}

bool
tile_sphere_intersect
(Tile *tile, pCoor position, float radius)
{
  pCoor dummyc;
  pNorm dummyn;
  return tile_sphere_intersect(tile,position,radius,dummyc,dummyn,true);
}
