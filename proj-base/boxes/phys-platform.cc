/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Platform Simulation

#include "world.h"
#include "phys-obj-ball.h"
#include "phys-obj-box.h"
#include "phys-obj-tile.h"


void
World::platform_object_setup()
{
  if ( opt_platform_curved == !platform_box ) return;

  cuda_at_balls_change();
  if ( opt_platform_curved )
    {
      for ( Box *box; boxes_iterate(box); )
        if ( box == platform_box )
          { 
            physs.iterate_yank(); 
            delete box;
            ASSERTS( platform_box == NULL );
          }
      return;
    }

  const float platform_thickness = 1;

  const float platform_delta_x = platform_xmax - platform_xmin;
  const float platform_delta_z = platform_zmax - platform_zmin;
  pCoor platform_ll
    (platform_xmin, platform_y - platform_thickness - 0.01, platform_zmin);

  platform_box =
    box_manager->new_box
    (platform_ll, pVect(platform_delta_x,platform_thickness,platform_delta_z),
     color_green_yellow);
  platform_box->set_read_only();
  platform_box->set_pointer(&platform_box);
}
