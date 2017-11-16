/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for ball / rectangle physics.

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
  Tile(bool &cuda_stale, pCoor ll, pVect ay, pVect ax)
    :Phys(PT_Tile),cuda_stale(cuda_stale),marker(NULL)
  {
    read_only = true;
    set(ll,ay,ax);
  }
  ~Tile(){ };

  void set(pCoor ll, pVect ayp, pVect axp)
  {
    ay = ayp;
    ax = axp;
    pt_00 = ll;
    nz.set(cross(ax,ay));
    nx.set(ax);
    lx = nx.magnitude;
    ny.set(ay);
    ly = ny.magnitude;
    cuda_stale = true;
    bb.ll = pt_00 + vec_neg(ay) + vec_neg(ax);
    bb.ur = pt_00 + vec_pos(ay) + vec_pos(ax);

    m_to_local = pMatrix_Rows(nx,ny,nz) * pMatrix_Translate(-ll);

  }

  float max_z_get(double delta_t){ return bb.ur.z; }
  float min_z_get(double delta_t){ return bb.ll.z; }

  Bounding_Box bounding_box_get(){return bb;}

  bool& cuda_stale;

  // Transformation to local coordinate space.
  pMatrix m_to_local;

  // Length of tile along local x and y axes.
  float lx, ly;

  pCoor pt_00; // Global coordinate corresponding to local coord (0,0,0).

  // Local space axes.
  pVect ay, ax;
  pNorm nx, ny, nz;

  Bounding_Box bb;

  pColor color;
  void *marker;
  Ball *ball_tested;
};

class Tile_Manager {
public:
  Tile_Manager(){ phys_list = NULL; cuda_stale = true; };
  void init(Phys_List *pl){ phys_list = pl; }
  void clear(){ tiles.clear(); }
  void render(bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Tile* new_tile(pCoor ll, pVect ay, pVect ax, pColor color);
  Tile* new_tile(pCoor ll, pVect ay, pVect ax);
  int occ() { return tiles.size(); }

private:
  World* w;
  vector<Tile*> tiles;
  Phys_List *phys_list;
  bool cuda_stale;
};

Tile*
Tile_Manager::new_tile(pCoor ll, pVect ay, pVect ax, pColor color)
{
  Tile* const rv = new_tile(ll,ay,ax);
  rv->color = color;
  return rv;
}

Tile*
Tile_Manager::new_tile(pCoor ll, pVect ay, pVect ax)
{
  Tile* const rv = new Tile(cuda_stale,ll,ay,ax);
  tiles.push_back( rv );
  rv->idx = phys_list->size();
  phys_list->push_back(rv);
  return rv;
}

void
Tile_Manager::render(bool simple)
{
  glBegin(GL_TRIANGLES);
  for ( Tile* tile: tiles )
    {
      if ( !simple )
        {
          glColor3fv(tile->color);
          glNormal3fv(tile->nz);
        }

      glVertex3fv(tile->pt_00 + tile->ay);
      glVertex3fv(tile->pt_00);
      glVertex3fv(tile->pt_00 + tile->ax);
      glVertex3fv(tile->pt_00 + tile->ax);
      glVertex3fv(tile->pt_00+tile->ax+tile->ay);
      glVertex3fv(tile->pt_00 + tile->ay);
    }
  glEnd();
}

void
Tile_Manager::render_simple(){ render(true); }

void
Tile_Manager::render_shadow_volume(pCoor light_pos)
{
  const float height = 1000;
  for ( Tile* tile: tiles )
    {
      pCoor pt_11 = tile->pt_00+tile->ax+tile->ay;
      pCoor pt_10 = tile->pt_00+tile->ax;
      pCoor pt_01 = tile->pt_00+tile->ay;
      pNorm l_to_01(light_pos,pt_01);
      pCoor pt_01_2 = light_pos + height * l_to_01;
      pCoor pt_00_2 = light_pos + height * pNorm(light_pos,tile->pt_00);
      pCoor pt_10_2 = light_pos + height * pNorm(light_pos,pt_10);
      pCoor pt_11_2 = light_pos + height * pNorm(light_pos,pt_11);
      const bool facing_light = dot(tile->nz,l_to_01) < 0;

      if ( facing_light )
        glFrontFace(GL_CW);
      else
        glFrontFace(GL_CCW);

      glBegin(GL_TRIANGLE_STRIP);
      glVertex3fv(tile->pt_00);
      glVertex3fv(pt_00_2);
      glVertex3fv(pt_10);
      glVertex3fv(pt_10_2);
      glVertex3fv(pt_11);
      glVertex3fv(pt_11_2);
      glVertex3fv(pt_01);
      glVertex3fv(pt_01_2);
      glVertex3fv(tile->pt_00);
      glVertex3fv(pt_00_2);
      glEnd();
    }
  glFrontFace(GL_CCW);
}

bool
tile_sphere_intersect
(Tile *tile, pCoor ball_pos, float radius,
 pCoor& tact_pos, pNorm& tact_dir, bool dont_compute_tact = false)
{
  // Transform sphere position to tile's local coordinate space.
  //
  pCoor ball_loc = tile->m_to_local * ball_pos;

  // Distance from tile's plane to the ball.
  const float dist = ball_loc.z;

  if ( fabs(dist) > radius ) return false;

  // Get local y coordinate of ball and return if it's too far to touch.
  //
  const float loc_y = ball_loc.y;
  if ( loc_y < -radius ) return false;
  if ( loc_y > tile->ly + radius ) return false;

  // Get local x coordinate of ball and return if it's too far to touch.
  //
  const float loc_x = ball_loc.x;
  if ( loc_x < -radius ) return false;
  if ( loc_x > tile->lx + radius ) return false;

  // The return value here should be maybe, but true is good enough
  // for preparing a proximity list.
  if ( dont_compute_tact ) return true;

  // Find closest ball local x and y coordinates that are within tile.
  //
  const float loc_xc = clamp(loc_x, 0, tile->lx);
  const float loc_yc = clamp(loc_y, 0, tile->ly);

  // If ball local coordinates are within tile then pseudo ball is
  // on opposite side of tile.
  //
  if ( loc_x == loc_xc && loc_y == loc_yc )
    {
      tact_pos = ball_pos - dist * tile->nz;
      tact_dir = dist > 0 ? -tile->nz : tile->nz;
      return true;
    }

  // Otherwise, ball is touching an edge or corner.

  tact_pos = tile->pt_00 + loc_xc * tile->nx + loc_yc * tile->ny;
  tact_dir = pVect(ball_pos,tact_pos);

  return tact_dir.mag_sq < radius * radius;
}

bool
tile_sphere_intersect
(Tile *tile, pCoor ball_pos, float radius)
{
  pCoor dummyc;
  pNorm dummyn;
  return tile_sphere_intersect(tile,ball_pos,radius,dummyc,dummyn,true);
}
