/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Code for computing reflection points on cylinder.

//  For background on mathematics of these reflection points see:
//
//  http://mathworld.wolfram.com/AlhazensBilliardProblem.html
//  http://www.math.sjsu.edu/~alperin/Alhazen.pdf

#ifndef GRA_ALHAZAN_H
#define GRA_ALHAZAN_H

#include "boxes.h"

double alhazan_check(pCoor center,pCoor eye,pCoor vertex,pCoor mirror);
pCoor alhazan(pCoor center, double radius, pCoor eye, pCoor vertex);

#endif
