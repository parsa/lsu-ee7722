#include <stdio.h>
#include <string>
#include <iostream>
#include <fstream>
#include <cuda-gpuinfo.h>
#include <pstring.h>

using namespace std;

int
main(int argc, char **argv)
{
  GPU_Choose_Info info = gpu_choose(argc>2);

  pStringF rv("sm_%d%d",info.cc_major,info.cc_minor);

  if ( argc == 1 )
    {
      printf("%s",rv.s);
      return 0;
    }

  const char* const path = argv[1];

  if ( string(path) == "-dhash" )
    {
      printf("c%d-cc%d%d.d",
             info.cuda_version, info.cc_major, info.cc_minor);
      return 0;
    }

  pStringF correct_contents
    ("Compiled for CUDA CC %d.%d  CUDA Version %d",
     info.cc_major,info.cc_minor,info.cuda_version);

  ifstream curr_file(path);
  bool update_needed = false;
  if ( curr_file.is_open() )
    {
      string contents;
      getline(curr_file,contents);
      update_needed = contents != correct_contents.s;
      curr_file.close();
    }
  else
    {
      update_needed = true;
    }

  if ( update_needed )
    {
      ofstream updated_file(path);
      updated_file << correct_contents;
      updated_file.close();
    }

  printf("%s",rv.s);
  return 0;
}
