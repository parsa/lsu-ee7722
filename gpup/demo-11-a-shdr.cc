#version 440

layout ( binding = 0 ) buffer B1 { float a[]; };
layout ( binding = 1 ) buffer B2 { float x[]; };

layout ( location = 1 ) uniform int elts;
layout ( local_size_x = 64 ) in;

void
main()
{
  uint tid = gl_WorkGroupID.x * gl_WorkGroupSize.x + gl_LocalInvocationID.x;

  if ( tid > elts ) return;

  x[tid] = a[tid] + 1;

}
