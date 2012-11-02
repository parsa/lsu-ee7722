/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Common definition for boxes code.

#ifndef BOXES_H
#define BOXES_H

#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#ifndef MAIN_FILE
#define GP_UTIL_DECLARE_ONLY
#endif

#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include <gp/cuda-util.h>
#include <gp/colors.h>
#include "k-main.cuh"


// Class World: All data about scene.
class World;

// Class Contact: Information about pair of nearby balls.
class Contact;

// Class Tile: Physical rectangular object.
class Tile;

class Phys;
class Ball;
class Box;
typedef PStack<Phys*> Phys_List;
typedef PStackIterator<Phys*> Phys_Iterator;

class Tile_Manager;
class Box_Manager;

// Constants for Location of Data (CUDA or CPU)
//
// Used to decide whether to copy data to or from CUDA.
//
enum Data_Location
  {
    DL_PO  = 0x1, // Position, Orientation
    DL_CV  = 0x2, // Collision Count, Velocity
    DL_OT  = 0x4, // Other.
    DL_ALL = 0x7,
    DL_PO_CPU  = 0x1, // Position, Orientation
    DL_CV_CPU  = 0x2, // Collision Count, Velocity
    DL_OT_CPU  = 0x4, // Other.
    DL_ALL_CPU = 0x7,
    DL_PO_CUDA = 0x10,
    DL_CV_CUDA = 0x20,
    DL_OT_CUDA = 0x40,
    DL_ALL_CUDA = 0x70 };


enum GPU_Physics_Method { GP_cpu, GP_cuda, GP_ENUM_SIZE };
const char* const gpu_physics_method_str[] = { "CPU", "CUDA" };


typedef enum { ST_Unset, ST_Intersect_Line, ST_Contained_Vertex, ST_Centroid
} Sect_Type;

// Class indicating information about a box-related intersection.
// Usually used to describe a line along intersecting faces.
//
class SectTT {
public:
  SectTT(){
    exists = false;
    t_start = -1e10; t_end = 1e10;
    type = ST_Unset;
    sect_case = 0;
  };
  bool exists; // If false, no intersection.
  Sect_Type type;
  pCoor start;
  pCoor end;
  pVect dir;
  float t_start, t_end;
  int sect_case;
};

class Tact_Box_Box {
public:
  Tact_Box_Box() {};
  SectTT sect;
  Box *box1;
  Box *box2;
};

// Class providing information about pair of phys in proximity (and
// so potentially in contact).
//
class Contact {
public:
  Contact():phys1(NULL),phys2(NULL),code_path(CP_Unset){};
  Contact(Contact *c):
    phys1(c->phys1),phys2(c->phys2),code_path(c->code_path),pass(-1){};
  Contact(Phys *phys1, Phys *phys2, Code_Path code_path):
    phys1(phys1),phys2(phys2),code_path(code_path),pass(-1){};
  Phys* const phys1;
  Phys* const phys2;
  const Code_Path code_path;   // Code path expected, for grouping warps.
  Phys* other_phys(Phys* ball) { return ball == phys1 ? phys2 : phys1; }
  int pass;   // Index of pass_pairs launch: 0 is first, 1 is second, ..
  int block;  // Like blockIdx, but numbering is within time step, not pass.
  int thread; // Index of thread within block.
  int round;  // Index within thread. Zero is 1st pair done by thd, etc.
};



// Class Pass: Information needed for a CUDA launch of a pair pass kernel.
//
class Pass {
public:
  Pass(){ block_cnt = 0; round_cnt = 0; }
  dim3 dim_grid, dim_block;
  int balls_per_block_max;
  int balls_per_thread_max;
  int block_num_base, block_num_next_pass;
  int block_cnt;
  int round_cnt;
  int thread_num_max;           // Maximum thread number of any block.
  int thread_cnt_max;           // Maximum number of threads used in any block.
  int prefetch_offset;
  int schedule_offset;
  int prefetch_elts_per_block;
  int ball_cnt;
};

const pColor dark(0);

#endif
