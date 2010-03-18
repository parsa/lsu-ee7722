/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for ball / rectangle physics.

// $Id:$

#if 0
Instructions:

I've placed quick and dirty code for ball/rectangle physics in the
proj-base/balls directory. If you "svn update" your code will be
updated. If you made extensive changes to balls.cc the update might
have collisions.

Here's a quick description:

A Tile (not to be confused with the platform tile) is rectangle which
interacts with balls and which is rendered. Balls will bounce off
tiles but tiles themselves will not move as a result of the collision.

A Tile_Manager object manages the set of tiles. Just one should
be declared, it is already declared in World.

A tile is created using a coordinate, two vectors, and an optional
color, using a call to a tile_manager object:

 pCoor corner(1,2,3);
 pVect width_vec(1,0,0);
 pVect height_vec(0,1,0);
 pColor color(1,0,0);

   Tile *my_tile = tile_manager.new_tile(corner, width_vec, height_vec, color);

A tile is returned, but the value can be discarded. One reason for
keeping it is to move the tile. To change the position of a tile use:
my_tile->set(new_corner,new_wid,new_height), to change the color,
my_tile->color = new_color.

Tiles are rendered by a call to tile_manager.render().  This
call has been inserted in the right places.

Ball / Tile interaction is handled in the time_step_cpu routine. The
routine tile_ball_collide(tile,ball,pball_location,radius) returns
true if there is a collision, and also sets pball_location to the
location of a pseudo ball to use as a proxy for the tile. (The pseudo
ball is used in penetration_balls_resolve.)


To use this code:

 Call new_tile as needed to add surfaces.

Limitations

 Tiles don't have textures.  Adding them would be straightforward.

 The collision detection does not account for corners. A ball approaching
 a corner will penetrate a corner without interaction until it
 reaches an edge. At that point it may be pressed very hard against
 the object and so will fly off.  That also is easy to fix (though
 a bit tedious).  The fix should go in tiles.h:tile_ball_collide.

 If two tiles share an edge, the ball touching that edge will feel
 twice the intended amount of force.   Fixing this would be
 of moderate complexity (at least fixing it the Right way).

 There is no GPU code for tile collisions. Fixing that would be of
 moderate complexity (since we haven't covered CUDA yet).

 There are no shadows and reflections on tiles.  Fixing this
 efficiently would be of moderate to high complexity.

 Collision detection is tested for on every ball/tile pair, limiting
 the number of tiles that can be efficiently handled. Fixing
 this would be of moderate complexity.
#endif

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
  void render();
  void render_simple();
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
Tile_Manager::render()
{
  glBegin(GL_TRIANGLES);
  for ( PStackIterator<Tile*> tile(tiles); tile; tile++ )
    {
      glColor3fv(tile->color);
      glNormal3fv(tile->normal);
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
Tile_Manager::render_simple(){ render(); }

bool
tile_ball_collide
(Tile *tile, Ball *ball, pCoor& pball_pos, float opt_ball_radius)
{
  pVect tile_to_ball(tile->pt_ll,ball->position);
  const float dist = dot(tile_to_ball,tile->normal);
  if ( fabs(dist) > opt_ball_radius ) return false;
  pCoor pt_closest = ball->position - dist * tile->normal;
  const float dist_ht = dot(tile->norm_up,tile_to_ball);
  if ( dist_ht < -opt_ball_radius ) return false;
  if ( dist_ht > tile->height + opt_ball_radius ) return false;
  const float dist_wd = dot(tile->norm_rt,tile_to_ball);
  if ( dist_wd < -opt_ball_radius ) return false;
  if ( dist_wd > tile->width + opt_ball_radius ) return false;
  if ( dist_ht >= 0 && dist_ht <= tile->height
       && dist_wd >= 0 && dist_wd <= tile->width )
    {
      tile->ball_tested = ball;
      pball_pos = pt_closest
        - ( dist > 0 ? opt_ball_radius : -opt_ball_radius) * tile->normal;
      return true;
    }

  const bool tact_horiz = dist_ht < 0 || dist_ht > tile->height;
  const pVect corner_to_tact =
    tact_horiz ? dist_wd * tile->norm_rt : dist_ht * tile->norm_up;
  const pCoor ref_pt =
    tact_horiz ? ( dist_ht < 0 ? tile->pt_ll : tile->pt_ul ) :
    ( dist_wd < 0 ? tile->pt_ll : tile->pt_lr );

  pCoor tact = ref_pt + corner_to_tact;
  pNorm ball_to_tact(ball->position,tact);
  pball_pos = tact + opt_ball_radius * ball_to_tact;

  return true;
}
