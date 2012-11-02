/// LSU EE X70X GPU Prog / Microarch
//
 /// Main code for rendering.

#include "boxes.h"
#include "world.h"
#include "phys-obj-tile.h"
#include "phys-obj-box.h"
#include "phys-obj-ball.h"

void
World::balls_render_simple()
{
  // Render balls without textures. Intended for casting shadows.

  tile_manager->render_simple();
  box_manager->render_simple();

  for ( Ball *ball; balls_iterate(ball); )
    {
      const int c = ball->contact_count;

      // Assume that a ball in contact with more than 6 others
      // won't cast a visible shadow.
      //
      if ( c > 6 ) continue;

      Sphere* const s =
        opt_pause && opt_fixed_lod < 0 ? &sphere : sphere_get(ball);

      s->render_simple(ball->radius,ball->position);
    }
}

void
World::balls_render(bool attempt_ot)
{
  physs_occluded = 0;
  int iter=0;
  for ( Phys *phys; eye_dist.iterate(phys); )
    {
      Ball* const ball = BALL(phys);
      iter++;
      if ( !ball ) continue;
      pColor color =
        opt_color_events ? ball->color_event : ball->color;

      // Retrieve the result of an occlusion test on this ball.
      //
      while ( attempt_ot && ball->occlusion_query_active )
        {
          GLint avail = -1;
          glGetQueryObjectiv
            (ball->query_occlusion_id,GL_QUERY_RESULT_AVAILABLE,&avail);
          if ( !avail ) break;
          GLint samples_passed = -1;
          glGetQueryObjectiv
            (ball->query_occlusion_id,GL_QUERY_RESULT,&samples_passed);
          ball->occlusion_query_active = false;
          ball->occluded = samples_passed == 0;
          if ( ball->occluded ) ball->occluded_run++;
          else                  ball->occluded_run = 0;
          ball->occlusion_countdown = 3;
          break;
        }

      if ( ball->occluded ) physs_occluded++;
      
      // Decide whether to perform an occlusion test.
      //
      const bool do_ot = attempt_ot && ball->occlusion_countdown-- == 0;

      // Don't render this ball because it hasn't resulted in
      // anything being written to the frame buffer more than
      // 10 consecutive times.
      //
      if ( ball->occluded_run > 10 && !do_ot ) continue;

      // Maybe start an occlusion query.
      if ( do_ot )
        glBeginQuery(GL_SAMPLES_PASSED,ball->query_occlusion_id);

      if ( ball->occluded_run > 10 )
        {
          // Ball is probably not visible, so render it with
          // a simple sphere.
          //
          sphere_lite.render_simple(ball->radius,ball->position);
        }
      else
        {
          // Get sphere with detail level appropriate for viewer distance.
          //
          Sphere* const s = 
            opt_pause && opt_fixed_lod < 0 ? &sphere : sphere_get(ball);

          // Set ball's color, position, and orientation, and
          // render it.
          //
          pMatrix_Rotation rot(ball->orientation);
          s->color = color;
          s->render(ball->radius,ball->position,rot);
        }
      if ( do_ot )
        {
          ball->occlusion_query_active = true;
          glEndQuery(GL_SAMPLES_PASSED);
        }
    }
}

void
World::render_shadow_volumes(pCoor light_pos)
{
  // Render objects' shadow volumes.

  // Make sure that only stencil buffer written.
  //
  glColorMask(false,false,false,false);
  glDepthMask(false);

  // Don't waste time computing lighting.
  //
  glDisable(GL_LIGHTING);
  glDisable(GL_TEXTURE_2D);

  // Set up stencil test to count shadow volume surfaces: plus 1 for
  // entering the shadow volume, minus 1 for leaving the shadow
  // volume.
  //
  glEnable(GL_STENCIL_TEST);
  // sfail, dfail, dpass
  glStencilOpSeparate(GL_FRONT,GL_KEEP,GL_KEEP,GL_INCR_WRAP);
  glStencilOpSeparate(GL_BACK,GL_KEEP,GL_KEEP,GL_DECR_WRAP);
  glStencilFuncSeparate(GL_FRONT_AND_BACK,GL_ALWAYS,1,-1); // ref, mask

  if ( opt_shadow_volumes )
    {
      // Make shadow volumes visible.

      glColorMask(true,true,true,true);
      glColor3f(0.8,0,0);
    }

  // Render balls' shadow volumes.
  //
  for ( Ball *ball; balls_iterate(ball); )
    {
      Sphere* const s = 
        opt_pause && opt_fixed_lod < 0 ? &sphere : sphere_get(ball);
      s->light_pos = light_pos;
      s->render_shadow_volume(ball->radius,ball->position);
    }

  // Render tiles' shadow volumes.
  //
  tile_manager->render_shadow_volume(light_pos);
  box_manager->render_shadow_volume(light_pos);

  // Restore assumed state.
  //
  glColorMask(true,true,true,true);
  glDepthMask(true);
}

void
World::render_objects(bool attempt_ot)
{
  // Render objects normally.

  const float shininess_ball = 20;
  pColor spec_color(0.2,0.2,0.2);

  glEnable(GL_LIGHTING);
  glEnable(GL_TEXTURE_2D);

  //
  // Render Balls
  //

  // Set up cool specular lighting parameters.
  //
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
  glEnable(GL_COLOR_SUM);

  glBindTexture(GL_TEXTURE_2D,texid_ball);

  // Render each ball.
  //
  balls_render(attempt_ot);

  glDisable(GL_COLOR_SUM);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR);

  // Render each tile.
  //
  tile_manager->render();
  box_manager->render(opt_color_events);
  while ( SectTT* const sect = sects.iterate() )
    {
      switch ( sect->sect_case ){
      case 0: glColor3f(0.1,0.1,0.1); break;
      case 1: glColor3fv(color_violet_red); break;
      case 2: glColor3f(0,0,0.8); break;
      case 3: glColor3f(0,1,0); break;
      default: glColor3f(1,0,0); break;
      }

      switch ( sect->type ) {
      case ST_Intersect_Line:
        cone.render(sect->start,0.2,sect->dir,0.8);
        break;
      case ST_Centroid:
        cone.render(sect->start,0.2,50*sect->dir,0.05);
        break;
      default:
        ASSERTS( false );
      }
    }

  //
  // Render Platform
  //

  // Set up attribute (vertex, normal, etc.) arrays.
  //
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid_plat);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  platform_tile_norms.bind();
  glNormalPointer(GL_FLOAT,sizeof(platform_tile_norms.data[0]), 0);
  glEnableClientState(GL_NORMAL_ARRAY);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Write lighter-colored, textured tiles.
  //
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
  glColor3f(0.35,0.35,0.35);
  glDrawArrays(GL_QUADS,0,platform_even_vtx_cnt);

  // Write darker-colored, untextured, mirror tiles.
  //
  glEnable(GL_BLEND);
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,color_white);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,20);
  glDisable(GL_TEXTURE_2D);
  glColor3fv(mirror_tint);
  glDrawArrays(GL_QUADS,platform_even_vtx_cnt,platform_odd_vtx_cnt);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
}


void
World::render()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

  const double time_now = time_wall_fp();

  if ( opt_pause || last_frame_time == 0 )
    {
      /// Don't change simulation state.
      //
      last_frame_time = time_now;
    }
  else
    {
      // If we are recording a video base world time on video frame
      // rate rather than wall clock time.
      //
      if ( ogl_helper.animation_record )
        world_time = time_now - ogl_helper.frame_period;

      // Advance simulation state by wall clock time.
      //
      const double elapsed_time = time_now - last_frame_time;
      const int iter_limit =
        int( min( opt_time_step_factor * 3.0, 0.5 + elapsed_time / delta_t));
      for ( int iter=0; iter < iter_limit; iter++ )
        {
          if ( opt_physics_method == GP_cpu )
            time_step_cpu();
          else
            time_step_cuda(iter,iter_limit);

          world_time += delta_t;
        }
      last_frame_time = time_now;
      frame_timer.work_amt_set(iter_limit);
    }

  /// Emit a Graphical Representation of Simulation State
  //
  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  // Frustum: left, right, bottom, top, near, far
  pMatrix_Frustum projection(-.8,.8,-.8/aspect,.8/aspect,1,5000);
  glLoadTransposeMatrixf(projection);

  glViewport(0, 0, win_width, win_height);
  pError_Check();

  const double tri_edge_len_px = 4;

  sphere_lod_factor =
    win_width * 2.0 * M_PI
    / ( 1.6 * tri_edge_len_px * sphere_delta_lod );
  sphere_lod_offset = sphere_lod_min / sphere_delta_lod;

  glClearColor(0,0,0,0);
  glClearDepth(1.0);
  glClearStencil(0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glEnable(GL_VERTEX_PROGRAM_TWO_SIDE);

  glLightfv(GL_LIGHT0, GL_POSITION, light_location);
  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);

  pCoor light1_location(0,40,100);
  glLightfv(GL_LIGHT1, GL_POSITION, light1_location);
  glLightf(GL_LIGHT1, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT1, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT1, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x555555);
  const float spec_intensity = opt_light_intensity * 0.4;

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, color_white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, color_white * spec_intensity);

  glLightfv(GL_LIGHT1, GL_DIFFUSE, color_white * opt_light_intensity);
  glLightfv(GL_LIGHT1, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT1, GL_SPECULAR, color_white * spec_intensity);

  glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,true);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHT1);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

  const float shininess_ball = 20;
  pColor spec_color(0.2,0.2,0.2);

  // Common to all textures.
  //
  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
                  GL_LINEAR_MIPMAP_LINEAR);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  glEnable(GL_RESCALE_NORMAL);
  glEnable(GL_NORMALIZE);

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Shadows: %-3s ('w')  Mirror: %-3s %d "
     "Light location: [%5.1f, %5.1f, %5.1f]\n",
     opt_shadows ? "on" : "off",
     opt_mirror ? "on" : "off", opt_mirror_method,
     light_location.x, light_location.y, light_location.z);

  Phys* const phys = phys_last();
  pVect z(0,0,0);
  pVect pos = phys ? pVect(phys->position) : z;
  pVect vel = phys ? phys->velocity : z;
  ogl_helper.fbprintf
    ("Objects %4d (%4d/%4d)  Boxes %3d  Last Object Pos  "
     "[%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]  Tri Count %d\n",
     physs.occ(), 
     physs.occ() - physs_occluded, physs_occluded,
     box_manager->occ(), pos.x,pos.y,pos.z, vel.x,vel.y,vel.z, tri_count);

  const bool blink_visible = int64_t(time_now*3) & 1;
# define BLINK(txt,pad) ( blink_visible ? txt : pad )

  ogl_helper.fbprintf
    ("Physics: %s ('a')  Debug Options: %d %d ('qQ')  "
     "Physics Verification %s ('v')\n",
     opt_physics_method != GP_cuda
     ? BLINK(gpu_physics_method_str[opt_physics_method],"      ") 
     : gpu_physics_method_str[opt_physics_method], 
     opt_debug, opt_debug2,
     opt_verify ? BLINK("On ","   ") : "Off");

  if ( opt_physics_method == GP_cuda && cuda_initialized )
    {
      ogl_helper.fbprintf
        ("MPs: %d  Blocks: %d  (%.1f Bl/MP)  Th/Bl: %d  WP/Bl: %.3f  "
         "Passes: %d  Rounds: %d  Time %.0f\n",
         cuda_prop.multiProcessorCount,
         block_count_prev,
         block_count_prev / double(cuda_prop.multiProcessorCount),
         opt_block_size,
         opt_block_size / 32.0,
         passes_curr->occ(), round_count_prev,
         ceil(block_count_prev / double(cuda_prop.multiProcessorCount))
         * ceil(opt_block_size / 32.0)
         * round_count_prev
         );

      ogl_helper.fbprintf
        ("Time  Intersect %.3f ms  Pairs  %.3f ms  Platform  %.3f\n",
         xx_pairs_cumulative / max(1, pairs_cumulative_count),
         pairs_cumulative / max(1, pairs_cumulative_count),
         platform_cumulative / max(1, pairs_cumulative_count) );
      pairs_cumulative_count = 0;
      platform_cumulative = xx_pairs_cumulative = pairs_cumulative = 0;

      pString pass_txt;
      pString cp_txt;
      int time_total = 0;
      while ( Pass* const p = passes_curr->iterate() )
        {
          const int blocks_per_mp =
            int(0.99999 + double(p->block_cnt)/cuda_prop.multiProcessorCount);
          const int active_warps_per_block =
            int( 0.99999 + p->thread_cnt_max / 32.0 );
          pass_txt.sprintf
            ("%3d / %3d / %3d / %4d  ",
             p->block_cnt, p->thread_cnt_max, p->round_cnt, p->ball_cnt);
          cp_txt.sprintf(" %2d * %2d * %2d + ",
                         blocks_per_mp, active_warps_per_block, p->round_cnt);
          time_total += blocks_per_mp * active_warps_per_block * p->round_cnt;
        }

      ogl_helper.fbprintf("Time %3d: %s\n",
                          time_total, cp_txt.s);
      ogl_helper.fbprintf("Other data: (bl/th/rn/obj) %s\n", pass_txt.s);

      if ( 0 )
      ogl_helper.fbprintf
        ("Platform Block cnt/size: %d / %d\n",
         dim_grid.x, dim_block.x
         );
    }

  tri_count = 0;

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());

  ogl_helper.fbprintf("CUDA Prox %s ('F4' to change) "
                      "CPU test/ball: %.3f total %d,  Full %d\n",
                      opt_cuda_prox ? "On" : BLINK("Off","   "),
                      double(prox_test_per_ball_prev) / physs.occ(),
                      prox_test_per_ball_prev,
                      cuda_prox_full_prev);

  // Sort balls by distance from user's eye.
  // This is needed for the occlusion test.
  //
  eye_dist.reset();
  for ( Ball *ball; balls_iterate(ball); )
    {
      pVect ve(ball->position,eye_location);
      eye_dist.insert(dot(ve,ve),ball);
    }
  eye_dist.sort();

  if ( opt_mirror && vs_reflect->okay() )
    {
      //
      // Render ball reflection.  (Will be blended with dark tiles.)
      //

      // Write stencil at location of dark (mirrored) tiles.
      //
      glDisable(GL_LIGHTING);
      glEnable(GL_STENCIL_TEST);
      glStencilFunc(GL_NEVER,4,-1);
      glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);
      platform_tile_coords.bind();
      glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
      glEnableClientState(GL_VERTEX_ARRAY);
      glDrawArrays(GL_QUADS,platform_even_vtx_cnt,platform_odd_vtx_cnt);

      glEnable(GL_LIGHTING);
      glDisableClientState(GL_VERTEX_ARRAY);
      glBindBuffer(GL_ARRAY_BUFFER,0);

      // Prepare to write only stenciled locations.
      //
      glStencilFunc(GL_EQUAL,4,4);
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

      // Reflected front face should still be treated as the front face.
      //
      glFrontFace(GL_CW);
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D,texid_ball);

      glEnable(GL_LIGHT0);
      glEnable(GL_LIGHT1);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);

      glEnable(GL_BLEND);
      glBlendEquation(GL_FUNC_ADD);
      glBlendFunc(GL_CONSTANT_ALPHA,GL_ZERO); // src, dst
      glBlendColor(0,0,0,0.5);

      // Use a shader that reflects objects.
      //
      vs_reflect->use();

      // Send constants to shader.
      //
      glUniform1f(sun_platform_xmid, platform_xmid);
      glUniform1f(sun_platform_xrad, platform_xrad);
      glUniform1i(sun_opt_mirror_method, opt_mirror_method);
      glUniform1i(sun_opt_color_events, opt_color_events);
      glUniform4fv(sun_eye_location, 1, eye_location);
      glUniformMatrix4fv(sun_eye_to_world, 1, true, modelview_inv);
      modelview_projection = projection * modelview;
      glUniformMatrix4fv(sun_world_to_clip, 1, true, modelview_projection);

      balls_render(false);
      tile_manager->render();
      box_manager->render(opt_color_events);

      // Change back to fixed functionality (no user shader).
      //
      vs_fixed->use();

      glFrontFace(GL_CCW);
      glDisable(GL_STENCIL_TEST);
    }


  // At this point, frame buffer contains only object reflections.

  glDisable(GL_BLEND);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_ONE,GL_ONE);

  const bool opt_vshader = true;

  if ( opt_vshader ) vs_plain->use();

  if ( !opt_shadows )
    {
      //
      /// Render objects in just a single pass, no shadows.
      //

      glEnable(GL_LIGHT1);
      glEnable(GL_LIGHT0);

      if ( opt_vshader ) glUniform1i(sun_vs_options,15);

      render_objects(true);
    }
  else
    {
      //
      /// Render objects and the shadows they cast.
      //

      //
      // First pass, render using only ambient light.
      //
      glDisable(GL_LIGHT1);
      glDisable(GL_LIGHT0);
      if ( opt_vshader ) glUniform1i(sun_vs_options,8);

      // Send balls, tiles, and platform to opengl.
      // Do occlusion test too.
      //
      render_objects(true);

      //
      // Second pass, add on light0.
      //

      // Turn off ambient light, turn on light 0.
      //
      glLightModelfv(GL_LIGHT_MODEL_AMBIENT, dark);
      glEnable(GL_LIGHT0);

      // Write stencil with shadow locations based on shadow volumes
      // cast by light0 (light_location).  Shadowed locations will
      // have a positive stencil value.
      //
      glClear(GL_STENCIL_BUFFER_BIT);
      if ( opt_vshader ) vs_xfrom_only->use();
      render_shadow_volumes(light_location);

      // Use stencil test to prevent writes to shaded areas.
      //
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,0,-1); // ref, mask

      // Allow pixels to be re-written.
      //
      glDepthFunc(GL_LEQUAL);

      // Render, but don't do occlusion test again.
      //
      if ( opt_vshader ){ vs_plain->use(); glUniform1i(sun_vs_options,5); }
      render_objects(false);

      //
      // Third pass, add on light1.
      //

      glDisable(GL_LIGHT0);
      glEnable(GL_LIGHT1);

      glClear(GL_STENCIL_BUFFER_BIT);
      if ( opt_vshader ) vs_xfrom_only->use();
      render_shadow_volumes(light1_location);

      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,0,-1); // ref, mask

      if ( opt_vshader ){  vs_plain->use(); glUniform1i(sun_vs_options,6); }
      render_objects(false);
    }

  vs_fixed->use();

  // Maybe render platform normals.
  //
  if ( opt_normals_visible )
    {
      glColor3fv(color_lsu_spirit_gold);
      for ( int i=0; i<platform_tile_coords.elements; i++ )
        cone.render(platform_tile_coords[i],0.2,5 * platform_tile_norms[i]);
    }

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glDisable(GL_LIGHTING);
  glDisable(GL_BLEND);
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_STENCIL_TEST);
  frame_timer.frame_end();

  glColor3f(0.5,1,0.5);
  ogl_helper.user_text_reprint();
  glutSwapBuffers();
}

