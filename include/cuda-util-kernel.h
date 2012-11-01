/// LSU EE 4702-X / EE 77XX   -*- c++ -*-
//
 ///  CUDA Kernel Utility Functions

 // $Id:$

#ifndef CUDA_UTIL_KERNEL_H
#define CUDA_UTIL_KERNEL_H

extern void cuda_util_symbol_insert(const char *name, void *symbol);
#define CU_SYM(a) cuda_util_symbol_insert(#a,&a)

#endif
