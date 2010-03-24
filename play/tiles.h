/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for ball / rectangle physics.

// $Id:$


class Tile {
public:
  Tile(){}
  Tile(pCoor ll, pVect up, pVect rt){set(ll,up,rt);}
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
  }
  pCoor pt_ll; // A corner called lower-left but it doesn't have to be.
  pCoor pt_ul, pt_lr;
  pVect vec_up;
  pVect vec_rt;
  pNorm normal, norm_rt, norm_up;
  pColor color;
  float width, height;
  Ball *ball_tested;
};

class Tile_Manager {
public:
  Tile_Manager(){};
  void render(bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Tile* new_tile(pCoor ll, pVect up, pVect rt, pColor color);
  Tile* new_tile(pCoor ll, pVect up, pVect rt);
  Tile* iterate();
private:
  PStack<Tile*> tiles;
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
  Tile* const rv = new Tile(ll,up,rt);
  tiles += rv;
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
tile_ball_collide
(Tile *tile, Ball *ball, pCoor& pball_pos, float opt_ball_radius)
{
  pVect tile_to_ball(tile->pt_ll,ball->position);

  // Distance from tile's plane to the ball.
  const float dist = dot(tile_to_ball,tile->normal); 

  if ( fabs(dist) > opt_ball_radius ) return false;

  // The closest point on tile plane to the ball.
  pCoor pt_closest = ball->position - dist * tile->normal; 

  // How far up the tile in the y direction the center of the ball sits
  const float dist_ht = dot(tile->norm_up,tile_to_ball);  

  if ( dist_ht < -opt_ball_radius ) return false; 
  if ( dist_ht > tile->height + opt_ball_radius ) return false;

  // How far up the tile in the x direction the center of the ball sits
  const float dist_wd = dot(tile->norm_rt,tile_to_ball);
  if ( dist_wd < -opt_ball_radius ) return false;
  if ( dist_wd > tile->width + opt_ball_radius ) return false;

  // If ball touching tile surface (not including an edge or corner)
  // then set up the pseudo ball for collision handling
  if ( dist_ht >= 0 && dist_ht <= tile->height
       && dist_wd >= 0 && dist_wd <= tile->width )
    {
      tile->ball_tested = ball;
      pball_pos = pt_closest
        - ( dist > 0 ? opt_ball_radius : -opt_ball_radius) * tile->normal;
      return true;
    }

  // Test whether the ball is touching a corner
  if ( ( dist_ht < 0 || dist_ht > tile->height ) 
       && ( dist_wd < 0 || dist_wd > tile->width) )
    {
      pCoor ref_pt;

      // We need to place the pseudo ball based upon the vector from
      // ball position to the corner. First step is to figure out which
      // corner.

      if ( dist_ht < 0 && dist_wd < 0 ) 
        {
          ref_pt = tile->pt_ll;
        }
      else if ( dist_ht < 0 && dist_wd > tile->width ) 
        {
          ref_pt = tile->pt_lr;
        }
      else if ( dist_ht > tile->height && dist_wd < 0 ) 
        {
          ref_pt = tile->pt_ul;
        }
      else 
        {
          ref_pt = tile->pt_ll+tile->vec_rt+tile->vec_up;
        }

      pNorm ball_to_corner(ball->position,ref_pt);
      tile->ball_tested = ball;
      pball_pos = ref_pt + opt_ball_radius * ball_to_corner;

      return true;
    }

  // Else the ball is touching an edge

  const bool tact_horiz = dist_ht < 0 || dist_ht > tile->height;
  const pVect corner_to_tact =
    tact_horiz ? dist_wd * tile->norm_rt : dist_ht * tile->norm_up;
  const pCoor ref_pt =
    tact_horiz ? ( dist_ht < 0 ? tile->pt_ll : tile->pt_ul ) :
    ( dist_wd < 0 ? tile->pt_ll : tile->pt_lr );

  tile->ball_tested = ball;

  // Find the closest edge point of the tile to the ball
  pCoor tact = ref_pt + corner_to_tact;
  pNorm ball_to_tact(ball->position,tact);
  pball_pos = tact + opt_ball_radius * ball_to_tact;

  return true;
}
