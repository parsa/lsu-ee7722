/// LSU EE 4702-1 (Fall 2014), GPU Programming
//

 /// Compute Shader -- Simple Example
//
//   This file contains code that will run on the GPU as a compute shader.   


// Specify version of compute shader language being used.
//
#version 440

// Declare arrays that will be bound to buffer objects.
//
layout ( binding = 0 ) buffer B1 { float a[]; };
layout ( binding = 1 ) buffer B2 { float x[]; };

layout ( location = 1 ) uniform int elts;

// Specify number of members of each work group.
//
// For NVIDIA devices should be a multiple of 32.
// The significance of this number will be explained when we cover CUDA.
//
layout ( local_size_x = 64 ) in;

// The Compute Shader Code
void
main()
{
  uint tid = gl_WorkGroupID.x * gl_WorkGroupSize.x + gl_LocalInvocationID.x;

  if ( tid > elts ) return;

  x[tid] = a[tid] + 1;
}
