
	.section	".text",#alloc,#execinstr,#progbits
	.file	"xform.c"

	.section	".bss",#alloc,#write,#nobits

Bbss.bss:

	.section	".data",#alloc,#write,#progbits

Ddata.data:

	.section	".rodata",#alloc,#progbits
!
! CONSTANT POOL
!

Drodata.rodata:

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000101:
/* 000000	   0 */		.word	1065353216
/* 0x0004	   0 */		.type	___const_seg_900000101,1
/* 0x0004	   0 */		.size	___const_seg_900000101,(.-___const_seg_900000101)
/* 0x0004	   0 */		.align	4
! FILE xform.c

!    1		      !/* $Id: xform.c,v 1.10 1997/10/30 06:00:06 brianp Exp $ */
!    3		      !/*
!    4		      ! * Mesa 3-D graphics library
!    5		      ! * Version:  2.5
!    6		      ! * Copyright (C) 1995-1997  Brian Paul
!    7		      ! *
!    8		      ! * This library is free software; you can redistribute it and/or
!    9		      ! * modify it under the terms of the GNU Library General Public
!   10		      ! * License as published by the Free Software Foundation; either
!   11		      ! * version 2 of the License, or (at your option) any later version.
!   12		      ! *
!   13		      ! * This library is distributed in the hope that it will be useful,
!   14		      ! * but WITHOUT ANY WARRANTY; without even the implied warranty of
!   15		      ! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!   16		      ! * Library General Public License for more details.
!   17		      ! *
!   18		      ! * You should have received a copy of the GNU Library General Public
!   19		      ! * License along with this library; if not, write to the Free
!   20		      ! * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!   21		      ! */
!   24		      !/*
!   25		      ! * $Log: xform.c,v $
!   26		      ! * Revision 1.10  1997/10/30 06:00:06  brianp
!   27		      ! * added Intel X86 assembly optimzations (Josh Vanderhoof)
!   28		      ! *
!   29		      ! * Revision 1.9  1997/07/24 01:25:54  brianp
!   30		      ! * changed precompiled header symbol from PCH to PC_HEADER
!   31		      ! *
!   32		      ! * Revision 1.8  1997/05/28 03:27:03  brianp
!   33		      ! * added precompiled header (PCH) support
!   34		      ! *
!   35		      ! * Revision 1.7  1997/05/01 01:40:51  brianp
!   36		      ! * replaced sqrt() with GL_SQRT()
!   37		      ! *
!   38		      ! * Revision 1.6  1997/04/02 03:15:02  brianp
!   39		      ! * removed gl_xform_texcoords_4fv()
!   40		      ! *
!   41		      ! * Revision 1.5  1997/01/03 23:54:17  brianp
!   42		      ! * changed length threshold in gl_xform_normals_3fv() to 1E-30 per Jeroen
!   43		      ! *
!   44		      ! * Revision 1.4  1996/11/09 01:50:49  brianp
!   45		      ! * relaxed the minimum normal threshold in gl_xform_normals_3fv()
!   46		      ! *
!   47		      ! * Revision 1.3  1996/11/08 02:20:39  brianp
!   48		      ! * added gl_xform_texcoords_4fv()
!   49		      ! *
!   50		      ! * Revision 1.2  1996/11/05 01:38:50  brianp
!   51		      ! * fixed some comments
!   52		      ! *
!   53		      ! * Revision 1.1  1996/09/13 01:38:16  brianp
!   54		      ! * Initial revision
!   55		      ! *
!   56		      ! */
!   59		      !/*
!   60		      ! * Matrix/vertex/vector transformation stuff
!   61		      ! *
!   62		      ! *
!   63		      ! * NOTES:
!   64		      ! * 1. 4x4 transformation matrices are stored in memory in column major order.
!   65		      ! * 2. Points/vertices are to be thought of as column vectors.
!   66		      ! * 3. Transformation of a point p by a matrix M is: p' = M * p
!   67		      ! *
!   68		      ! */
!   71		      !#ifdef PC_HEADER
!   72		      !#include "all.h"
!   73		      !#else
!   74		      !#include <math.h>
!   75		      !#include "mmath.h"
!   76		      !#include "types.h"
!   77		      !#include "xform.h"
!   78		      !#endif
!   82		      !/*
!   83		      ! * Apply a transformation matrix to an array of [X Y Z W] coordinates:
!   84		      ! *   for i in 0 to n-1 do   q[i] = m * p[i]
!   85		      ! * where p[i] and q[i] are 4-element column vectors and m is a 16-element
!   86		      ! * transformation matrix.
!   87		      ! */
!   88		      !void gl_xform_points_4fv( GLuint n, GLfloat q[][4], const GLfloat m[16],
!   89		      !                          GLfloat p[][4] )
!   90		      !{
!   91		      !   /* This function has been carefully crafted to maximize register usage
!   92		      !    * and use loop unrolling with IRIX 5.3's cc.  Hopefully other compilers
!   93		      !    * will like this code too.
!   94		      !    */
!   95		      !   {
!   96		      !      GLuint i;
!   97		      !      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8],  m12 = m[12];
!   98		      !      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9],  m13 = m[13];
!   99		      !      if (m12==0.0F && m13==0.0F) {

!
! SUBROUTINE gl_xform_points_4fv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_xform_points_4fv
                       

			gl_xform_points_4fv:
/* 000000	  99 */		fzeros	%f23
/* 0x0004	  97 */		ld	[%o2+48],%f26
/* 0x0008	  98 */		ld	[%o2+52],%f3
/* 0x000c	  99 */		fcmps	%fcc0,%f26,%f23
/* 0x0010	     */		fbne,pn	%fcc0,.L77000289
/* 0x0014	  90 */		or	%g0,%o3,%g5

! Registers live out of gl_xform_points_4fv: 
! g1 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f3 f4 f23 f26 
		                       
! predecessor blocks: gl_xform_points_4fv

			.L77000277:
/* 0x0018	  99 */		fcmps	%fcc1,%f3,%f23
/* 0x001c	     */		fbne,pn	%fcc1,.L77000289
/* 0x0020	 101 */		cmp	%o0,0

! Registers live out of .L77000277: 
! g1 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f3 f4 f23 f26 
		
!  100		      !         /* common case */
!  101		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000277

			.L77000279:
/* 0x0024	 101 */		bleu,a,pn	%icc,.L900000143
/* 0x0028	 120 */		ld	[%o2+12],%f0

! Registers live out of .L77000279: 
! g1 g3 g4 g5 o0 o1 o2 o3 o5 sp o7 fp gsr 
! f0 f4 f23 
		                       
! predecessor blocks: .L77000279

			.L77000336:
/* 0x002c	  97 */		ld	[%o2],%f17
/* 0x0030	  98 */		ld	[%o2+4],%f28
/* 0x0034	  97 */		ld	[%o2+16],%f0
/* 0x0038	  98 */		ld	[%o2+20],%f30
/* 0x003c	  97 */		ld	[%o2+32],%f24
/* 0x0040	     */		cmp	%o0,2
/* 0x0044	  98 */		ld	[%o2+36],%f1
/* 0x0048	  97 */		bl,pn	%icc,.L77000439
/* 0x004c	 101 */		sethi	%hi(0x7ffffc00),%g2

! Registers live out of .L77000336: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000336

			.L77000358:
/* 0x0050	 101 */		add	%g2,1022,%o4
/* 0x0054	     */		srl	%o0,0,%g1
/* 0x0058	     */		sub	%g1,%o4,%g4
/* 0x005c	     */		srlx	%g4,63,%o5
/* 0x0060	     */		andcc	%o5,1,%g0
/* 0x0064	     */		be,a,pn	%icc,.L77000354
/* 0x0068	     */		or	%g0,0,%g3

! Registers live out of .L77000358: 
! g1 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		
!  102		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

                       
! predecessor blocks: .L77000358

			.L77000386:
/* 0x006c	 102 */		cmp	%o0,4
/* 0x0070	 101 */		add	%o0,-1,%g2
/* 0x0074	     */		or	%g0,0,%g3
/* 0x0078	     */		or	%g0,%o1,%o5
/* 0x007c	 102 */		bl,pn	%icc,.L77000387
/* 0x0080	     */		nop

! Registers live out of .L77000386: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000386

			.L900000125:
/* 0x0084	 102 */		fmovs	%f1,%f5
/* 0x0088	     */		fmovs	%f28,%f3
/* 0x008c	     */		fmovs	%f30,%f4
/* 0x0090	     */		fmovs	%f17,%f6
/* 0x0094	     */		fmovs	%f24,%f1
/* 0x0098	     */		add	%o0,-4,%o4

! Registers live out of .L900000125: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f5 f6 f23 
		                       
! predecessor blocks: .L900000123 .L900000125

			.L900000123:
/* 0x009c	 102 */		prefetch	[%o3+168],0
/* 0x00a0	     */		prefetch	[%o5+164],2
/* 0x00a4	 101 */		add	%g3,4,%g3
/* 0x00a8	 102 */		ld	[%o3],%f16
/* 0x00ac	 101 */		add	%o3,64,%o3
/* 0x00b0	     */		cmp	%g3,%o4
/* 0x00b4	     */		add	%o5,64,%o5
/* 0x00b8	 102 */		ld	[%o3-60],%f2

!  103		      !            q[i][0] = m0 * p0 + m4  * p1 + m8 * p2;

/* 0x00bc	 103 */		fmuls	%f16,%f6,%f20
/* 0x00c0	     */		fmuls	%f2,%f0,%f18

!  104		      !            q[i][1] = m1 * p0 + m5  * p1 + m9 * p2;

/* 0x00c4	 104 */		fmuls	%f16,%f3,%f31
/* 0x00c8	     */		fmuls	%f2,%f4,%f22
/* 0x00cc	 102 */		ld	[%o3-56],%f24
/* 0x00d0	 103 */		fadds	%f20,%f18,%f28
/* 0x00d4	     */		fmuls	%f24,%f1,%f26
/* 0x00d8	 104 */		fadds	%f31,%f22,%f8
/* 0x00dc	     */		fmuls	%f24,%f5,%f17
/* 0x00e0	 103 */		fadds	%f28,%f26,%f30
/* 0x00e4	     */		st	%f30,[%o5-64]
/* 0x00e8	 104 */		fadds	%f8,%f17,%f10
/* 0x00ec	     */		st	%f10,[%o5-60]
/* 0x00f0	 102 */		ld	[%o3-48],%f12
/* 0x00f4	     */		ld	[%o3-44],%f7
/* 0x00f8	 103 */		fmuls	%f12,%f6,%f14
/* 0x00fc	     */		fmuls	%f7,%f0,%f19
/* 0x0100	 104 */		fmuls	%f12,%f3,%f15
/* 0x0104	     */		fmuls	%f7,%f4,%f21
/* 0x0108	 102 */		ld	[%o3-40],%f13
/* 0x010c	 103 */		fadds	%f14,%f19,%f9
/* 0x0110	     */		fmuls	%f13,%f1,%f25
/* 0x0114	 104 */		fadds	%f15,%f21,%f29
/* 0x0118	     */		fmuls	%f13,%f5,%f27
/* 0x011c	 103 */		fadds	%f9,%f25,%f11
/* 0x0120	     */		st	%f11,[%o5-48]
/* 0x0124	 104 */		fadds	%f29,%f27,%f16
/* 0x0128	     */		st	%f16,[%o5-44]
/* 0x012c	 102 */		ld	[%o3-32],%f2
/* 0x0130	     */		ld	[%o3-28],%f18
/* 0x0134	 103 */		fmuls	%f2,%f6,%f22
/* 0x0138	     */		fmuls	%f18,%f0,%f20
/* 0x013c	 104 */		fmuls	%f2,%f3,%f24
/* 0x0140	     */		fmuls	%f18,%f4,%f31
/* 0x0144	 102 */		ld	[%o3-24],%f26
/* 0x0148	 103 */		fadds	%f22,%f20,%f30
/* 0x014c	     */		fmuls	%f26,%f1,%f28
/* 0x0150	 104 */		fadds	%f24,%f31,%f10
/* 0x0154	     */		fmuls	%f26,%f5,%f8
/* 0x0158	 103 */		fadds	%f30,%f28,%f17
/* 0x015c	     */		st	%f17,[%o5-32]
/* 0x0160	 104 */		fadds	%f10,%f8,%f12
/* 0x0164	     */		st	%f12,[%o5-28]
/* 0x0168	 102 */		ld	[%o3-16],%f19
/* 0x016c	     */		ld	[%o3-12],%f7
/* 0x0170	 103 */		fmuls	%f19,%f6,%f21
/* 0x0174	     */		fmuls	%f7,%f0,%f14
/* 0x0178	 104 */		fmuls	%f19,%f3,%f13
/* 0x017c	     */		fmuls	%f7,%f4,%f15
/* 0x0180	 102 */		ld	[%o3-8],%f25
/* 0x0184	 103 */		fadds	%f21,%f14,%f9
/* 0x0188	     */		fmuls	%f25,%f1,%f11
/* 0x018c	 104 */		fadds	%f13,%f15,%f16
/* 0x0190	     */		fmuls	%f25,%f5,%f29
/* 0x0194	 103 */		fadds	%f9,%f11,%f27
/* 0x0198	     */		st	%f27,[%o5-16]
/* 0x019c	 104 */		fadds	%f16,%f29,%f2
/* 0x01a0	 101 */		ble,pt	%icc,.L900000123
/* 0x01a4	 104 */		st	%f2,[%o5-12]

! Registers live out of .L900000123: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f5 f6 f23 
		                       
! predecessor blocks: .L900000123

			.L900000126:
/* 0x01a8	 102 */		fmovs	%f1,%f24
/* 0x01ac	     */		fmovs	%f5,%f1
/* 0x01b0	     */		fmovs	%f4,%f30
/* 0x01b4	 101 */		cmp	%g3,%g2
/* 0x01b8	 102 */		fmovs	%f3,%f28
/* 0x01bc	     */		fmovs	%f6,%f17
/* 0x01c0	 101 */		bg,pn	%icc,.L900000118
/* 0x01c4	 102 */		nop

! Registers live out of .L900000126: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000386 .L900000126

			.L77000387:
/* 0x01c8	 102 */		ld	[%o3],%f4

! Registers live out of .L77000387: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000387 .L900000145

			.L900000145:
/* 0x01cc	 102 */		ld	[%o3+4],%f26
/* 0x01d0	 104 */		fmuls	%f4,%f28,%f9
/* 0x01d4	 103 */		fmuls	%f4,%f17,%f3
/* 0x01d8	 104 */		fmuls	%f26,%f30,%f12
/* 0x01dc	 103 */		fmuls	%f26,%f0,%f2
/* 0x01e0	 102 */		ld	[%o3+8],%f5
/* 0x01e4	 101 */		add	%g3,1,%g3
/* 0x01e8	     */		cmp	%g3,%g2
/* 0x01ec	 104 */		fmuls	%f5,%f1,%f16
/* 0x01f0	     */		fadds	%f9,%f12,%f6
/* 0x01f4	 103 */		fmuls	%f5,%f24,%f31
/* 0x01f8	     */		fadds	%f3,%f2,%f19
/* 0x01fc	 101 */		add	%o3,16,%o3
/* 0x0200	 104 */		fadds	%f6,%f16,%f18
/* 0x0204	     */		st	%f18,[%o5+4]
/* 0x0208	 103 */		fadds	%f19,%f31,%f7
/* 0x020c	     */		st	%f7,[%o5]
/* 0x0210	 101 */		add	%o5,16,%o5
/* 0x0214	     */		ble,a,pt	%icc,.L900000145
/* 0x0218	 102 */		ld	[%o3],%f4

! Registers live out of .L900000145: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L900000126 .L900000145

			.L900000118:
/* 0x021c	 102 */		ba	.L900000141
/* 0x0220	 119 */		ld	[%o2+12],%f4

! Registers live out of .L900000118: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f4 f23 
		                       
! predecessor blocks: .L77000336

			.L77000439:
/* 0x0224	 101 */		or	%g0,0,%g3

! Registers live out of .L77000439: 
! g1 g3 g4 g5 o0 o1 o2 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000358 .L77000439

			.L77000354:
/* 0x0228	 102 */		sll	%g3,4,%g2

! Registers live out of .L77000354: 
! g1 g2 g3 g4 g5 o0 o1 o2 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L77000354 .L900000144

			.L900000144:
/* 0x022c	 102 */		add	%g2,%g5,%o3
/* 0x0230	     */		ld	[%o3],%f3
/* 0x0234	     */		ld	[%o3+4],%f26
/* 0x0238	     */		ld	[%o3+8],%f6
/* 0x023c	 103 */		fmuls	%f3,%f17,%f31
/* 0x0240	     */		fmuls	%f26,%f0,%f18
/* 0x0244	 104 */		fmuls	%f26,%f30,%f19
/* 0x0248	     */		fmuls	%f3,%f28,%f7
/* 0x024c	 103 */		fmuls	%f6,%f24,%f14
/* 0x0250	 104 */		fmuls	%f6,%f1,%f11
/* 0x0254	 101 */		add	%g3,1,%g3
/* 0x0258	 103 */		fadds	%f31,%f18,%f21
/* 0x025c	     */		add	%g2,%o1,%o4
/* 0x0260	 104 */		fadds	%f7,%f19,%f8
/* 0x0264	 101 */		cmp	%g3,%o0
/* 0x0268	 103 */		fadds	%f21,%f14,%f25
/* 0x026c	     */		st	%f25,[%o1+%g2]
/* 0x0270	 104 */		fadds	%f8,%f11,%f27
/* 0x0274	     */		st	%f27,[%o4+4]
/* 0x0278	 101 */		bcs,pt	%icc,.L900000144
/* 0x027c	 102 */		sll	%g3,4,%g2

! Registers live out of .L900000144: 
! g1 g2 g3 g4 g5 o0 o1 o2 o5 sp o7 fp gsr 
! f0 f1 f4 f17 f23 f24 f28 f30 
		                       
! predecessor blocks: .L900000144

			.L900000117:
/* 0x0280	 102 */		ba	.L900000141
/* 0x0284	 119 */		ld	[%o2+12],%f4

! Registers live out of .L900000117: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f4 f23 
		
!  105		      !         }
!  106		      !      }
!  107		      !      else {
!  108		      !         /* general case */
!  109		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000277 gl_xform_points_4fv

			.L77000289:
/* 0x0288	 109 */		cmp	%o0,0
/* 0x028c	     */		bleu,a,pn	%icc,.L900000143
/* 0x0290	 120 */		ld	[%o2+12],%f0

! Registers live out of .L77000289: 
! g1 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f3 f4 f23 f26 
		                       
! predecessor blocks: .L77000289

			.L77000337:
/* 0x0294	  97 */		ld	[%o2],%f17
/* 0x0298	  98 */		ld	[%o2+4],%f28
/* 0x029c	  97 */		ld	[%o2+16],%f0
/* 0x02a0	  98 */		ld	[%o2+20],%f30
/* 0x02a4	  97 */		ld	[%o2+32],%f24
/* 0x02a8	     */		cmp	%o0,2
/* 0x02ac	  98 */		ld	[%o2+36],%f1
/* 0x02b0	  97 */		bl,pn	%icc,.L77000437
/* 0x02b4	 109 */		sethi	%hi(0x7ffffc00),%o3

! Registers live out of .L77000337: 
! g1 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000337

			.L77000366:
/* 0x02b8	 109 */		add	%o3,1022,%g3
/* 0x02bc	     */		srl	%o0,0,%g2
/* 0x02c0	     */		sub	%g2,%g3,%o4
/* 0x02c4	     */		srlx	%o4,63,%g1
/* 0x02c8	     */		andcc	%g1,1,%g0
/* 0x02cc	     */		be,a,pn	%icc,.L77000362
/* 0x02d0	     */		or	%g0,0,%g3

! Registers live out of .L77000366: 
! g1 g3 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 
		
!  110		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

                       
! predecessor blocks: .L77000366

			.L77000388:
/* 0x02d4	 110 */		cmp	%o0,4
/* 0x02d8	 109 */		add	%o0,-1,%g4
/* 0x02dc	     */		or	%g0,0,%g2
/* 0x02e0	     */		or	%g0,%o1,%g3
/* 0x02e4	     */		or	%g0,%g5,%o4
/* 0x02e8	 110 */		bl,pn	%icc,.L77000389
/* 0x02ec	     */		nop

! Registers live out of .L77000388: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000388

			.L900000121:
/* 0x02f0	 110 */		add	%o0,-4,%o5

! Registers live out of .L900000121: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L900000119 .L900000121

			.L900000119:
/* 0x02f4	 110 */		prefetch	[%o4+172],0
/* 0x02f8	     */		prefetch	[%g3+164],2
/* 0x02fc	 109 */		add	%g2,4,%g2
/* 0x0300	 110 */		ld	[%o4+12],%f6
/* 0x0304	 109 */		add	%o4,64,%o4
/* 0x0308	     */		cmp	%g2,%o5
/* 0x030c	     */		add	%g3,64,%g3

!  111		      !            q[i][0] = m0 * p0 + m4  * p1 + m8 * p2 + m12 * p3;

/* 0x0310	 111 */		fmuls	%f6,%f26,%f20
/* 0x0314	 110 */		ld	[%o4-56],%f4

!  112		      !            q[i][1] = m1 * p0 + m5  * p1 + m9 * p2 + m13 * p3;

/* 0x0318	 112 */		fmuls	%f6,%f3,%f31
/* 0x031c	 111 */		fmuls	%f4,%f24,%f18
/* 0x0320	 110 */		ld	[%o4-60],%f5
/* 0x0324	 112 */		fmuls	%f4,%f1,%f22
/* 0x0328	 111 */		fmuls	%f5,%f0,%f7
/* 0x032c	 110 */		ld	[%o4-64],%f19
/* 0x0330	 112 */		fmuls	%f5,%f30,%f14
/* 0x0334	 111 */		fadds	%f20,%f18,%f10
/* 0x0338	     */		fmuls	%f19,%f17,%f8
/* 0x033c	 112 */		fadds	%f31,%f22,%f12
/* 0x0340	     */		fmuls	%f19,%f28,%f21
/* 0x0344	 111 */		fadds	%f8,%f7,%f15
/* 0x0348	 112 */		fadds	%f21,%f14,%f25
/* 0x034c	 111 */		fadds	%f15,%f10,%f13
/* 0x0350	     */		st	%f13,[%g3-64]
/* 0x0354	 112 */		fadds	%f25,%f12,%f11
/* 0x0358	     */		st	%f11,[%g3-60]
/* 0x035c	 110 */		ld	[%o4-36],%f27
/* 0x0360	 111 */		fmuls	%f27,%f26,%f6
/* 0x0364	 110 */		ld	[%o4-40],%f9
/* 0x0368	 112 */		fmuls	%f27,%f3,%f5
/* 0x036c	 111 */		fmuls	%f9,%f24,%f2
/* 0x0370	 110 */		ld	[%o4-44],%f29
/* 0x0374	 112 */		fmuls	%f9,%f1,%f4
/* 0x0378	 111 */		fmuls	%f29,%f0,%f20
/* 0x037c	 110 */		ld	[%o4-48],%f18
/* 0x0380	 112 */		fmuls	%f29,%f30,%f16
/* 0x0384	 111 */		fadds	%f6,%f2,%f19
/* 0x0388	     */		fmuls	%f18,%f17,%f22
/* 0x038c	 112 */		fadds	%f5,%f4,%f14
/* 0x0390	     */		fmuls	%f18,%f28,%f31
/* 0x0394	 111 */		fadds	%f22,%f20,%f7
/* 0x0398	 112 */		fadds	%f31,%f16,%f21
/* 0x039c	 111 */		fadds	%f7,%f19,%f8
/* 0x03a0	     */		st	%f8,[%g3-48]
/* 0x03a4	 112 */		fadds	%f21,%f14,%f10
/* 0x03a8	     */		st	%f10,[%g3-44]
/* 0x03ac	 110 */		ld	[%o4-20],%f15
/* 0x03b0	 111 */		fmuls	%f15,%f26,%f12
/* 0x03b4	 110 */		ld	[%o4-24],%f25
/* 0x03b8	 112 */		fmuls	%f15,%f3,%f13
/* 0x03bc	 111 */		fmuls	%f25,%f24,%f27
/* 0x03c0	 110 */		ld	[%o4-28],%f11
/* 0x03c4	 112 */		fmuls	%f25,%f1,%f9
/* 0x03c8	 111 */		fmuls	%f11,%f0,%f2
/* 0x03cc	 110 */		ld	[%o4-32],%f29
/* 0x03d0	 112 */		fmuls	%f11,%f30,%f4
/* 0x03d4	 111 */		fadds	%f12,%f27,%f18
/* 0x03d8	     */		fmuls	%f29,%f17,%f6
/* 0x03dc	 112 */		fadds	%f13,%f9,%f16
/* 0x03e0	     */		fmuls	%f29,%f28,%f5
/* 0x03e4	 111 */		fadds	%f6,%f2,%f20
/* 0x03e8	 112 */		fadds	%f5,%f4,%f31
/* 0x03ec	 111 */		fadds	%f20,%f18,%f22
/* 0x03f0	     */		st	%f22,[%g3-32]
/* 0x03f4	 112 */		fadds	%f31,%f16,%f19
/* 0x03f8	     */		st	%f19,[%g3-28]
/* 0x03fc	 110 */		ld	[%o4-4],%f7
/* 0x0400	 111 */		fmuls	%f7,%f26,%f10
/* 0x0404	 110 */		ld	[%o4-8],%f14
/* 0x0408	 112 */		fmuls	%f7,%f3,%f11
/* 0x040c	 111 */		fmuls	%f14,%f24,%f21
/* 0x0410	 110 */		ld	[%o4-12],%f8
/* 0x0414	 112 */		fmuls	%f14,%f1,%f25
/* 0x0418	 111 */		fmuls	%f8,%f0,%f15
/* 0x041c	 110 */		ld	[%o4-16],%f27
/* 0x0420	 112 */		fmuls	%f8,%f30,%f29
/* 0x0424	 111 */		fadds	%f10,%f21,%f2
/* 0x0428	     */		fmuls	%f27,%f17,%f13
/* 0x042c	 112 */		fadds	%f11,%f25,%f12
/* 0x0430	     */		fmuls	%f27,%f28,%f9
/* 0x0434	 111 */		fadds	%f13,%f15,%f6
/* 0x0438	 112 */		fadds	%f9,%f29,%f5
/* 0x043c	 111 */		fadds	%f6,%f2,%f4
/* 0x0440	     */		st	%f4,[%g3-16]
/* 0x0444	 112 */		fadds	%f5,%f12,%f18
/* 0x0448	 109 */		ble,pt	%icc,.L900000119
/* 0x044c	 112 */		st	%f18,[%g3-12]

! Registers live out of .L900000119: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L900000119

			.L900000122:
/* 0x0450	 109 */		cmp	%g2,%g4
/* 0x0454	     */		bg,pn	%icc,.L900000116
/* 0x0458	 110 */		nop

! Registers live out of .L900000122: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000388 .L900000122

			.L77000389:
/* 0x045c	 110 */		ld	[%o4],%f31

! Registers live out of .L77000389: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 f31 
		                       
! predecessor blocks: .L77000389 .L900000142

			.L900000142:
/* 0x0460	 110 */		ld	[%o4+4],%f18
/* 0x0464	     */		ld	[%o4+8],%f16
/* 0x0468	     */		ld	[%o4+12],%f6
/* 0x046c	 112 */		fmuls	%f31,%f28,%f21
/* 0x0470	 111 */		fmuls	%f31,%f17,%f27
/* 0x0474	 112 */		fmuls	%f16,%f1,%f19
/* 0x0478	 111 */		fmuls	%f16,%f24,%f25
/* 0x047c	 112 */		fmuls	%f18,%f30,%f14
/* 0x0480	     */		fmuls	%f6,%f3,%f7
/* 0x0484	 111 */		fmuls	%f6,%f26,%f8
/* 0x0488	     */		fmuls	%f18,%f0,%f11
/* 0x048c	 109 */		add	%g2,1,%g2
/* 0x0490	     */		cmp	%g2,%g4
/* 0x0494	 112 */		fadds	%f21,%f14,%f15
/* 0x0498	     */		fadds	%f7,%f19,%f10
/* 0x049c	 111 */		fadds	%f8,%f25,%f22
/* 0x04a0	     */		fadds	%f27,%f11,%f13
/* 0x04a4	 109 */		add	%o4,16,%o4
/* 0x04a8	 112 */		fadds	%f15,%f10,%f20
/* 0x04ac	     */		st	%f20,[%g3+4]
/* 0x04b0	 111 */		fadds	%f13,%f22,%f29
/* 0x04b4	     */		st	%f29,[%g3]
/* 0x04b8	 109 */		add	%g3,16,%g3
/* 0x04bc	     */		ble,a,pt	%icc,.L900000142
/* 0x04c0	 110 */		ld	[%o4],%f31

! Registers live out of .L900000142: 
! g1 g2 g3 g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f4 f17 f23 f24 f26 f28 f30 f31 
		                       
! predecessor blocks: .L900000122 .L900000142

			.L900000116:
/* 0x04c4	 110 */		ba	.L900000141
/* 0x04c8	 119 */		ld	[%o2+12],%f4

! Registers live out of .L900000116: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f4 f23 
		                       
! predecessor blocks: .L77000337

			.L77000437:
/* 0x04cc	 109 */		or	%g0,0,%g3

! Registers live out of .L77000437: 
! g1 g3 g5 o0 o1 o2 o4 sp o7 fp gsr 
! f0 f1 f3 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000366 .L77000437

			.L77000362:
/* 0x04d0	 110 */		sll	%g3,4,%o5

! Registers live out of .L77000362: 
! g1 g3 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f17 f23 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000362 .L900000140

			.L900000140:
/* 0x04d4	 110 */		add	%o5,%g5,%g4
/* 0x04d8	     */		ld	[%g4],%f14
/* 0x04dc	     */		ld	[%g4+4],%f11
/* 0x04e0	     */		ld	[%g4+8],%f21
/* 0x04e4	     */		ld	[%g4+12],%f25
/* 0x04e8	 111 */		fmuls	%f14,%f17,%f15
/* 0x04ec	     */		fmuls	%f21,%f24,%f8
/* 0x04f0	     */		fmuls	%f25,%f26,%f27
/* 0x04f4	     */		fmuls	%f11,%f0,%f20
/* 0x04f8	 112 */		fmuls	%f14,%f28,%f4
/* 0x04fc	     */		fmuls	%f21,%f1,%f22
/* 0x0500	     */		fmuls	%f25,%f3,%f10
/* 0x0504	     */		fmuls	%f11,%f30,%f29
/* 0x0508	 111 */		fadds	%f27,%f8,%f12
/* 0x050c	     */		fadds	%f15,%f20,%f13
/* 0x0510	 109 */		add	%g3,1,%g3
/* 0x0514	 111 */		add	%o5,%o1,%o3
/* 0x0518	 112 */		fadds	%f10,%f22,%f9
/* 0x051c	     */		fadds	%f4,%f29,%f2
/* 0x0520	 109 */		cmp	%g3,%o0
/* 0x0524	 111 */		fadds	%f13,%f12,%f5
/* 0x0528	     */		st	%f5,[%o1+%o5]
/* 0x052c	 112 */		fadds	%f2,%f9,%f16
/* 0x0530	     */		st	%f16,[%o3+4]
/* 0x0534	 109 */		bcs,pt	%icc,.L900000140
/* 0x0538	 110 */		sll	%g3,4,%o5

! Registers live out of .L900000140: 
! g1 g3 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f3 f17 f23 f24 f26 f28 f30 
		
!  113		      !         }
!  114		      !      }
!  115		      !   }
!  116		      !   {
!  117		      !      GLuint i;
!  118		      !      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10],  m14 = m[14];
!  119		      !      GLfloat m3 = m[3],  m7 = m[7],  m11 = m[11],  m15 = m[15];

                       
! predecessor blocks: .L900000140

			.L77000299:
/* 0x053c	 119 */		ld	[%o2+12],%f4

! Registers live out of .L77000299: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f4 f23 
		
!  120		      !      if (m3==0.0F && m7==0.0F && m11==0.0F && m15==1.0F) {

                       
! predecessor blocks: .L77000299 .L900000116 .L900000117 .L900000118

			.L900000141:
/* 0x0540	 120 */		fcmps	%fcc2,%f4,%f23
/* 0x0544	 119 */		ld	[%o2+28],%f20
/* 0x0548	     */		ld	[%o2+44],%f2
/* 0x054c	     */		ld	[%o2+60],%f22
/* 0x0550	 120 */		fbne,pn	%fcc2,.L900000139
/* 0x0554	 130 */		cmp	%o0,2

! Registers live out of .L900000141: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 f23 
		                       
! predecessor blocks: .L900000141

			.L77000301:
/* 0x0558	 120 */		fcmps	%fcc3,%f20,%f23
/* 0x055c	     */		fbne,pn	%fcc3,.L900000139
/* 0x0560	 130 */		cmp	%o0,2

! Registers live out of .L77000301: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 f23 
		                       
! predecessor blocks: .L77000301

			.L77000303:
/* 0x0564	 120 */		fcmps	%fcc0,%f2,%f23
/* 0x0568	     */		fbne,pn	%fcc0,.L77000317
/* 0x056c	     */		sethi	%hi(___const_seg_900000101),%o5

! Registers live out of .L77000303: 
! g5 o0 o1 o2 o5 sp o7 fp gsr 
! f2 f4 f20 f22 
		                       
! predecessor blocks: .L77000303

			.L77000305:
/* 0x0570	 120 */		ld	[%o5+%lo(___const_seg_900000101)],%f0
/* 0x0574	     */		fcmps	%fcc1,%f22,%f0
/* 0x0578	     */		fbne,pn	%fcc1,.L77000317
/* 0x057c	 122 */		cmp	%o0,2

! Registers live out of .L77000305: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 
		
!  121		      !         /* common case */
!  122		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000305

			.L77000307:
/* 0x0580	 122 */		bl,pn	%icc,.L77000485
/* 0x0584	 118 */		sethi	%hi(0x7ffffc00),%g4

! Registers live out of .L77000307: 
! g4 g5 o0 o1 o2 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000307

			.L77000342:
/* 0x0588	 118 */		add	%g4,1022,%o5
/* 0x058c	     */		srl	%o0,0,%o3
/* 0x0590	     */		sub	%o3,%o5,%g2
/* 0x0594	     */		srlx	%g2,63,%o4
/* 0x0598	     */		andcc	%o4,1,%g0
/* 0x059c	     */		be,pn	%icc,.L77000491
/* 0x05a0	 122 */		cmp	%o0,0

! Registers live out of .L77000342: 
! g5 o0 o1 o2 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000342

			.L77000390:
/* 0x05a4	 122 */		ble,pn	%icc,.L77000328
/* 0x05a8	     */		or	%g0,0,%g3

! Registers live out of .L77000390: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! 
		
!  123		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

                       
! predecessor blocks: .L77000390

			.L77000419:
/* 0x05ac	 123 */		add	%o0,0,%g1
/* 0x05b0	 118 */		ld	[%o2+8],%f6
/* 0x05b4	     */		ld	[%o2+24],%f0
/* 0x05b8	 123 */		cmp	%g1,4
/* 0x05bc	 122 */		add	%o0,-1,%o0
/* 0x05c0	 118 */		ld	[%o2+40],%f16
/* 0x05c4	     */		add	%o1,8,%o1
/* 0x05c8	     */		ld	[%o2+56],%f18
/* 0x05cc	     */		or	%g0,%g5,%o2
/* 0x05d0	 123 */		bl,pn	%icc,.L77000391
/* 0x05d4	     */		nop

! Registers live out of .L77000419: 
! g3 o0 o1 o2 sp o7 fp gsr 
! f0 f6 f16 f18 
		                       
! predecessor blocks: .L77000419

			.L900000133:
/* 0x05d8	 123 */		fmovs	%f16,%f1
/* 0x05dc	     */		fmovs	%f18,%f3
/* 0x05e0	     */		sub	%o0,3,%o5

! Registers live out of .L900000133: 
! g3 o0 o1 o2 o5 sp o7 fp gsr 
! f0 f1 f3 f6 
		                       
! predecessor blocks: .L900000131 .L900000133

			.L900000131:
/* 0x05e4	 123 */		prefetch	[%o2+172],0
/* 0x05e8	     */		prefetch	[%o1+164],2
/* 0x05ec	 122 */		add	%g3,4,%g3

!  124		      !            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14 * p3;

/* 0x05f0	 124 */		ld	[%o2],%f8
/* 0x05f4	 122 */		add	%o2,64,%o2
/* 0x05f8	     */		cmp	%g3,%o5
/* 0x05fc	     */		add	%o1,64,%o1
/* 0x0600	 124 */		ld	[%o2-60],%f10
/* 0x0604	     */		fmuls	%f8,%f6,%f7
/* 0x0608	 123 */		ld	[%o2-52],%f12
/* 0x060c	 124 */		fmuls	%f10,%f0,%f5
/* 0x0610	     */		ld	[%o2-56],%f14

!  125		      !            q[i][3] = p3;

/* 0x0614	 125 */		st	%f12,[%o1-60]
/* 0x0618	 124 */		fmuls	%f12,%f3,%f11
/* 0x061c	     */		fmuls	%f14,%f1,%f9
/* 0x0620	     */		fadds	%f7,%f5,%f15
/* 0x0624	     */		fadds	%f11,%f9,%f13
/* 0x0628	     */		fadds	%f15,%f13,%f19
/* 0x062c	     */		st	%f19,[%o1-64]
/* 0x0630	     */		ld	[%o2-48],%f21
/* 0x0634	     */		ld	[%o2-44],%f23
/* 0x0638	     */		fmuls	%f21,%f6,%f31
/* 0x063c	 123 */		ld	[%o2-36],%f25
/* 0x0640	 124 */		fmuls	%f23,%f0,%f29
/* 0x0644	     */		ld	[%o2-40],%f27
/* 0x0648	 125 */		st	%f25,[%o1-44]
/* 0x064c	 124 */		fmuls	%f25,%f3,%f2
/* 0x0650	     */		fmuls	%f27,%f1,%f16
/* 0x0654	     */		fadds	%f31,%f29,%f4
/* 0x0658	     */		fadds	%f2,%f16,%f18
/* 0x065c	     */		fadds	%f4,%f18,%f20
/* 0x0660	     */		st	%f20,[%o1-48]
/* 0x0664	     */		ld	[%o2-32],%f22
/* 0x0668	     */		ld	[%o2-28],%f24
/* 0x066c	     */		fmuls	%f22,%f6,%f17
/* 0x0670	 123 */		ld	[%o2-20],%f26
/* 0x0674	 124 */		fmuls	%f24,%f0,%f30
/* 0x0678	     */		ld	[%o2-24],%f28
/* 0x067c	 125 */		st	%f26,[%o1-28]
/* 0x0680	 124 */		fmuls	%f26,%f3,%f8
/* 0x0684	     */		fmuls	%f28,%f1,%f10
/* 0x0688	     */		fadds	%f17,%f30,%f14
/* 0x068c	     */		fadds	%f8,%f10,%f12
/* 0x0690	     */		fadds	%f14,%f12,%f5
/* 0x0694	     */		st	%f5,[%o1-32]
/* 0x0698	     */		ld	[%o2-16],%f7
/* 0x069c	     */		ld	[%o2-12],%f9
/* 0x06a0	     */		fmuls	%f7,%f6,%f19
/* 0x06a4	 123 */		ld	[%o2-4],%f11
/* 0x06a8	 124 */		fmuls	%f9,%f0,%f15
/* 0x06ac	     */		ld	[%o2-8],%f13
/* 0x06b0	 125 */		st	%f11,[%o1-12]
/* 0x06b4	 124 */		fmuls	%f11,%f3,%f23
/* 0x06b8	     */		fmuls	%f13,%f1,%f21
/* 0x06bc	     */		fadds	%f19,%f15,%f27
/* 0x06c0	     */		fadds	%f23,%f21,%f25
/* 0x06c4	     */		fadds	%f27,%f25,%f29
/* 0x06c8	 122 */		ble,pt	%icc,.L900000131
/* 0x06cc	 124 */		st	%f29,[%o1-16]

! Registers live out of .L900000131: 
! g3 o0 o1 o2 o5 sp o7 fp gsr 
! f0 f1 f3 f6 
		                       
! predecessor blocks: .L900000131

			.L900000134:
/* 0x06d0	 122 */		cmp	%g3,%o0
/* 0x06d4	 123 */		fmovs	%f3,%f18
/* 0x06d8	     */		fmovs	%f1,%f16
/* 0x06dc	 122 */		bg,pn	%icc,.L900000115
/* 0x06e0	 123 */		nop

! Registers live out of .L900000134: 
! g3 o0 o1 o2 sp o7 fp gsr 
! f0 f6 f16 f18 
		                       
! predecessor blocks: .L77000419 .L900000134

			.L77000391:
/* 0x06e4	 124 */		ld	[%o2],%f13

! Registers live out of .L77000391: 
! g3 o0 o1 o2 sp o7 fp gsr 
! f0 f6 f13 f16 f18 
		                       
! predecessor blocks: .L77000391 .L900000138

			.L900000138:
/* 0x06e8	 123 */		ld	[%o2+12],%f29
/* 0x06ec	 124 */		ld	[%o2+4],%f20
/* 0x06f0	     */		ld	[%o2+8],%f22
/* 0x06f4	     */		fmuls	%f13,%f6,%f12
/* 0x06f8	     */		fmuls	%f20,%f0,%f4
/* 0x06fc	     */		fmuls	%f22,%f16,%f9
/* 0x0700	     */		fmuls	%f29,%f18,%f2
/* 0x0704	 122 */		add	%g3,1,%g3
/* 0x0708	 125 */		st	%f29,[%o1+4]
/* 0x070c	 122 */		cmp	%g3,%o0
/* 0x0710	 124 */		fadds	%f12,%f4,%f3
/* 0x0714	 122 */		add	%o2,16,%o2
/* 0x0718	 124 */		fadds	%f2,%f9,%f5
/* 0x071c	     */		fadds	%f3,%f5,%f23
/* 0x0720	     */		st	%f23,[%o1]
/* 0x0724	 122 */		add	%o1,16,%o1
/* 0x0728	     */		ble,a,pt	%icc,.L900000138
/* 0x072c	 124 */		ld	[%o2],%f13

! Registers live out of .L900000138: 
! g3 o0 o1 o2 sp o7 fp gsr 
! f0 f6 f13 f16 f18 
		                       
! predecessor blocks: .L900000134 .L900000138

			.L900000115:
/* 0x0730	 130 */		retl	! Result = 
/* 0x0734	     */		nop
                       
! predecessor blocks: .L77000342

			.L77000491:
/* 0x0738	 118 */		ld	[%o2+8],%f6
/* 0x073c	     */		ld	[%o2+24],%f0
/* 0x0740	     */		ld	[%o2+40],%f16
/* 0x0744	 122 */		or	%g0,0,%g3
/* 0x0748	 118 */		ld	[%o2+56],%f18
/* 0x074c	     */		ba	.L900000137
/* 0x0750	 123 */		or	%g0,0,%g1

! Registers live out of .L77000491: 
! g1 g3 g5 o0 o1 sp o7 fp gsr 
! f0 f6 f16 f18 
		                       
! predecessor blocks: .L77000307

			.L77000485:
/* 0x0754	 118 */		ld	[%o2+8],%f6
/* 0x0758	     */		ld	[%o2+24],%f0
/* 0x075c	     */		ld	[%o2+40],%f16
/* 0x0760	 122 */		or	%g0,0,%g3
/* 0x0764	 118 */		ld	[%o2+56],%f18
/* 0x0768	 123 */		or	%g0,0,%g1

! Registers live out of .L77000485: 
! g1 g3 g5 o0 o1 sp o7 fp gsr 
! f0 f6 f16 f18 
		                       
! predecessor blocks: .L77000485 .L77000491 .L900000137

			.L900000137:
/* 0x076c	 123 */		add	%g1,%g5,%o2
/* 0x0770	 124 */		ld	[%g5+%g1],%f20
/* 0x0774	 123 */		ld	[%o2+12],%f14
/* 0x0778	 124 */		ld	[%o2+4],%f4
/* 0x077c	     */		ld	[%o2+8],%f22
/* 0x0780	     */		fmuls	%f20,%f6,%f11
/* 0x0784	     */		fmuls	%f14,%f18,%f21
/* 0x0788	     */		fmuls	%f22,%f16,%f2
/* 0x078c	     */		fmuls	%f4,%f0,%f25
/* 0x0790	     */		add	%g1,%o1,%g4
/* 0x0794	 122 */		add	%g3,1,%g3
/* 0x0798	     */		cmp	%g3,%o0
/* 0x079c	 125 */		st	%f14,[%g4+12]
/* 0x07a0	 124 */		fadds	%f21,%f2,%f8
/* 0x07a4	     */		fadds	%f11,%f25,%f27
/* 0x07a8	     */		fadds	%f27,%f8,%f1
/* 0x07ac	     */		st	%f1,[%g4+8]
/* 0x07b0	 122 */		bcs,pt	%icc,.L900000137
/* 0x07b4	 123 */		sll	%g3,4,%g1

! Registers live out of .L900000137: 
! g1 g3 g5 o0 o1 sp o7 fp gsr 
! f0 f6 f16 f18 
		                       
! predecessor blocks: .L900000137

			.L900000114:
/* 0x07b8	 130 */		retl	! Result = 
/* 0x07bc	     */		nop

!  126		      !         }
!  127		      !      }
!  128		      !      else {
!  129		      !         /* general case */
!  130		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000303 .L77000305

			.L77000317:
/* 0x07c0	 130 */		cmp	%o0,2

! Registers live out of .L77000317: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 
		                       
! predecessor blocks: .L77000301 .L77000317 .L900000141

			.L900000139:
/* 0x07c4	 130 */		bl,pn	%icc,.L77000461
/* 0x07c8	 118 */		sethi	%hi(0x7ffffc00),%g1

! Registers live out of .L900000139: 
! g1 g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 
		                       
! predecessor blocks: .L900000139

			.L77000350:
/* 0x07cc	 118 */		add	%g1,1022,%g4
/* 0x07d0	     */		srl	%o0,0,%o5
/* 0x07d4	     */		sub	%o5,%g4,%o3
/* 0x07d8	     */		srlx	%o3,63,%g2
/* 0x07dc	     */		andcc	%g2,1,%g0
/* 0x07e0	     */		be,pn	%icc,.L77000473
/* 0x07e4	 130 */		cmp	%o0,0

! Registers live out of .L77000350: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f2 f4 f20 f22 
		                       
! predecessor blocks: .L77000350

			.L77000392:
/* 0x07e8	 130 */		ble,pn	%icc,.L77000328
/* 0x07ec	     */		or	%g0,0,%o5

! Registers live out of .L77000392: 
! g5 o0 o1 o2 o5 sp o7 fp gsr 
! f2 f4 f20 f22 
		                       
! predecessor blocks: .L77000392

			.L77000417:
/* 0x07f0	 118 */		ld	[%o2+8],%f6
/* 0x07f4	     */		ld	[%o2+24],%f0

!  131		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

/* 0x07f8	 131 */		cmp	%o0,4
/* 0x07fc	 118 */		ld	[%o2+40],%f16
/* 0x0800	 130 */		add	%o0,-1,%g2
/* 0x0804	 118 */		add	%o1,8,%g4
/* 0x0808	     */		ld	[%o2+56],%f18
/* 0x080c	 131 */		bl,pn	%icc,.L77000393
/* 0x0810	     */		nop

! Registers live out of .L77000417: 
! g2 g4 g5 o0 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000417

			.L900000129:
/* 0x0814	 131 */		add	%o0,-4,%o3

! Registers live out of .L900000129: 
! g2 g4 g5 o3 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000127 .L900000129

			.L900000127:
/* 0x0818	 131 */		prefetch	[%g5+172],0
/* 0x081c	     */		prefetch	[%g4+164],2
/* 0x0820	 130 */		add	%o5,4,%o5
/* 0x0824	 131 */		ld	[%g5+12],%f31
/* 0x0828	 130 */		add	%g5,64,%g5
/* 0x082c	     */		cmp	%o5,%o3
/* 0x0830	     */		add	%g4,64,%g4

!  132		      !            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14 * p3;

/* 0x0834	 132 */		fmuls	%f31,%f18,%f30
/* 0x0838	 131 */		ld	[%g5-56],%f24

!  133		      !            q[i][3] = m3 * p0 + m7 * p1 + m11 * p2 + m15 * p3;

/* 0x083c	 133 */		fmuls	%f31,%f22,%f17
/* 0x0840	 132 */		fmuls	%f24,%f16,%f28
/* 0x0844	 131 */		ld	[%g5-60],%f26
/* 0x0848	 133 */		fmuls	%f24,%f2,%f1
/* 0x084c	 132 */		fmuls	%f26,%f0,%f12
/* 0x0850	 131 */		ld	[%g5-64],%f3
/* 0x0854	 133 */		fmuls	%f26,%f20,%f14
/* 0x0858	 132 */		fadds	%f30,%f28,%f10
/* 0x085c	     */		fmuls	%f3,%f6,%f8
/* 0x0860	 133 */		fadds	%f17,%f1,%f11
/* 0x0864	     */		fmuls	%f3,%f4,%f5
/* 0x0868	 132 */		fadds	%f8,%f12,%f7
/* 0x086c	 133 */		fadds	%f5,%f14,%f9
/* 0x0870	 132 */		fadds	%f7,%f10,%f13
/* 0x0874	     */		st	%f13,[%g4-64]
/* 0x0878	 133 */		fadds	%f9,%f11,%f15
/* 0x087c	     */		st	%f15,[%g4-60]
/* 0x0880	 131 */		ld	[%g5-36],%f19
/* 0x0884	 132 */		fmuls	%f19,%f18,%f27
/* 0x0888	 131 */		ld	[%g5-40],%f21
/* 0x088c	 133 */		fmuls	%f19,%f22,%f31
/* 0x0890	 132 */		fmuls	%f21,%f16,%f25
/* 0x0894	 131 */		ld	[%g5-44],%f23
/* 0x0898	 133 */		fmuls	%f21,%f2,%f29
/* 0x089c	 132 */		fmuls	%f23,%f0,%f26
/* 0x08a0	 131 */		ld	[%g5-48],%f24
/* 0x08a4	 133 */		fmuls	%f23,%f20,%f30
/* 0x08a8	 132 */		fadds	%f27,%f25,%f17
/* 0x08ac	     */		fmuls	%f24,%f6,%f28
/* 0x08b0	 133 */		fadds	%f31,%f29,%f8
/* 0x08b4	     */		fmuls	%f24,%f4,%f1
/* 0x08b8	 132 */		fadds	%f28,%f26,%f3
/* 0x08bc	 133 */		fadds	%f1,%f30,%f14
/* 0x08c0	 132 */		fadds	%f3,%f17,%f12
/* 0x08c4	     */		st	%f12,[%g4-48]
/* 0x08c8	 133 */		fadds	%f14,%f8,%f5
/* 0x08cc	     */		st	%f5,[%g4-44]
/* 0x08d0	 131 */		ld	[%g5-20],%f10
/* 0x08d4	 132 */		fmuls	%f10,%f18,%f11
/* 0x08d8	 131 */		ld	[%g5-24],%f7
/* 0x08dc	 133 */		fmuls	%f10,%f22,%f21
/* 0x08e0	 132 */		fmuls	%f7,%f16,%f19
/* 0x08e4	 131 */		ld	[%g5-28],%f15
/* 0x08e8	 133 */		fmuls	%f7,%f2,%f9
/* 0x08ec	 132 */		fmuls	%f15,%f0,%f23
/* 0x08f0	 131 */		ld	[%g5-32],%f13
/* 0x08f4	 133 */		fmuls	%f15,%f20,%f27
/* 0x08f8	 132 */		fadds	%f11,%f19,%f31
/* 0x08fc	     */		fmuls	%f13,%f6,%f25
/* 0x0900	 133 */		fadds	%f21,%f9,%f28
/* 0x0904	     */		fmuls	%f13,%f4,%f29
/* 0x0908	 132 */		fadds	%f25,%f23,%f24
/* 0x090c	 133 */		fadds	%f29,%f27,%f30
/* 0x0910	 132 */		fadds	%f24,%f31,%f26
/* 0x0914	     */		st	%f26,[%g4-32]
/* 0x0918	 133 */		fadds	%f30,%f28,%f1
/* 0x091c	     */		st	%f1,[%g4-28]
/* 0x0920	 131 */		ld	[%g5-4],%f17
/* 0x0924	 132 */		fmuls	%f17,%f18,%f10
/* 0x0928	 131 */		ld	[%g5-8],%f3
/* 0x092c	 133 */		fmuls	%f17,%f22,%f12
/* 0x0930	 132 */		fmuls	%f3,%f16,%f5
/* 0x0934	 131 */		ld	[%g5-12],%f8
/* 0x0938	 133 */		fmuls	%f3,%f2,%f7
/* 0x093c	 132 */		fmuls	%f8,%f0,%f14
/* 0x0940	 131 */		ld	[%g5-16],%f19
/* 0x0944	 133 */		fmuls	%f8,%f20,%f15
/* 0x0948	 132 */		fadds	%f10,%f5,%f13
/* 0x094c	     */		fmuls	%f19,%f6,%f21
/* 0x0950	 133 */		fadds	%f12,%f7,%f11
/* 0x0954	     */		fmuls	%f19,%f4,%f9
/* 0x0958	 132 */		fadds	%f21,%f14,%f23
/* 0x095c	 133 */		fadds	%f9,%f15,%f27
/* 0x0960	 132 */		fadds	%f23,%f13,%f25
/* 0x0964	     */		st	%f25,[%g4-16]
/* 0x0968	 133 */		fadds	%f27,%f11,%f29
/* 0x096c	 130 */		ble,pt	%icc,.L900000127
/* 0x0970	 133 */		st	%f29,[%g4-12]

! Registers live out of .L900000127: 
! g2 g4 g5 o3 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000127

			.L900000130:
/* 0x0974	 130 */		cmp	%o5,%g2
/* 0x0978	     */		bg,pn	%icc,.L900000113
/* 0x097c	 131 */		nop

! Registers live out of .L900000130: 
! g2 g4 g5 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000417 .L900000130

			.L77000393:
/* 0x0980	 131 */		ld	[%g5],%f26

! Registers live out of .L77000393: 
! g2 g4 g5 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 f26 
		                       
! predecessor blocks: .L77000393 .L900000136

			.L900000136:
/* 0x0984	 131 */		ld	[%g5+4],%f24
/* 0x0988	     */		ld	[%g5+8],%f23
/* 0x098c	     */		ld	[%g5+12],%f1
/* 0x0990	 133 */		fmuls	%f26,%f4,%f31
/* 0x0994	 132 */		fmuls	%f26,%f6,%f21
/* 0x0998	 133 */		fmuls	%f23,%f2,%f28
/* 0x099c	 132 */		fmuls	%f23,%f16,%f19
/* 0x09a0	 133 */		fmuls	%f1,%f22,%f30
/* 0x09a4	     */		fmuls	%f24,%f20,%f17
/* 0x09a8	 132 */		fmuls	%f1,%f18,%f7
/* 0x09ac	     */		fmuls	%f24,%f0,%f14
/* 0x09b0	 130 */		add	%o5,1,%o5
/* 0x09b4	     */		cmp	%o5,%g2
/* 0x09b8	 133 */		fadds	%f30,%f28,%f8
/* 0x09bc	     */		fadds	%f31,%f17,%f25
/* 0x09c0	 132 */		fadds	%f7,%f19,%f27
/* 0x09c4	     */		fadds	%f21,%f14,%f10
/* 0x09c8	 130 */		add	%g5,16,%g5
/* 0x09cc	 133 */		fadds	%f25,%f8,%f11
/* 0x09d0	     */		st	%f11,[%g4+4]
/* 0x09d4	 132 */		fadds	%f10,%f27,%f15
/* 0x09d8	     */		st	%f15,[%g4]
/* 0x09dc	 130 */		add	%g4,16,%g4
/* 0x09e0	     */		ble,a,pt	%icc,.L900000136
/* 0x09e4	 131 */		ld	[%g5],%f26

! Registers live out of .L900000136: 
! g2 g4 g5 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 f26 
		                       
! predecessor blocks: .L900000130 .L900000136

			.L900000113:
/* 0x09e8	 130 */		retl	! Result = 
/* 0x09ec	     */		nop
                       
! predecessor blocks: .L77000350

			.L77000473:
/* 0x09f0	 118 */		ld	[%o2+8],%f6
/* 0x09f4	     */		ld	[%o2+24],%f0
/* 0x09f8	     */		ld	[%o2+40],%f16
/* 0x09fc	 130 */		or	%g0,0,%g3
/* 0x0a00	 118 */		ld	[%o2+56],%f18
/* 0x0a04	     */		ba	.L900000135
/* 0x0a08	 131 */		or	%g0,0,%o4

! Registers live out of .L77000473: 
! g3 g5 o0 o1 o4 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000139

			.L77000461:
/* 0x0a0c	 118 */		ld	[%o2+8],%f6
/* 0x0a10	     */		ld	[%o2+24],%f0
/* 0x0a14	     */		ld	[%o2+40],%f16
/* 0x0a18	 130 */		or	%g0,0,%g3
/* 0x0a1c	 118 */		ld	[%o2+56],%f18
/* 0x0a20	 131 */		or	%g0,0,%o4

! Registers live out of .L77000461: 
! g3 g5 o0 o1 o4 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000461 .L77000473 .L900000135

			.L900000135:
/* 0x0a24	 131 */		add	%o4,%g5,%o2
/* 0x0a28	     */		ld	[%o2],%f1
/* 0x0a2c	     */		ld	[%o2+4],%f30
/* 0x0a30	     */		ld	[%o2+8],%f24
/* 0x0a34	     */		ld	[%o2+12],%f28
/* 0x0a38	 133 */		fmuls	%f1,%f4,%f12
/* 0x0a3c	 132 */		fmuls	%f1,%f6,%f15
/* 0x0a40	 133 */		fmuls	%f24,%f2,%f17
/* 0x0a44	     */		fmuls	%f28,%f22,%f23
/* 0x0a48	     */		fmuls	%f30,%f20,%f29
/* 0x0a4c	 132 */		fmuls	%f24,%f16,%f13
/* 0x0a50	     */		fmuls	%f28,%f18,%f10
/* 0x0a54	     */		fmuls	%f30,%f0,%f5
/* 0x0a58	     */		add	%o4,%o1,%g1
/* 0x0a5c	 133 */		fadds	%f23,%f17,%f26
/* 0x0a60	     */		fadds	%f12,%f29,%f3
/* 0x0a64	 130 */		add	%g3,1,%g3
/* 0x0a68	 132 */		fadds	%f10,%f13,%f9
/* 0x0a6c	     */		fadds	%f15,%f5,%f19
/* 0x0a70	 130 */		cmp	%g3,%o0
/* 0x0a74	 133 */		fadds	%f3,%f26,%f31
/* 0x0a78	     */		st	%f31,[%g1+12]
/* 0x0a7c	 132 */		fadds	%f19,%f9,%f7
/* 0x0a80	     */		st	%f7,[%g1+8]
/* 0x0a84	 130 */		bcs,pt	%icc,.L900000135
/* 0x0a88	 131 */		sll	%g3,4,%o4

! Registers live out of .L900000135: 
! g3 g5 o0 o1 o4 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000135

			.L900000112:
/* 0x0a8c	 130 */		retl	! Result = 
/* 0x0a90	     */		nop
                       
! predecessor blocks: .L77000279 .L77000289

			.L900000143:
/* 0x0a94	 120 */		fcmps	%fcc0,%f0,%f23
/* 0x0a98	     */		fbne,pn	%fcc0,.L77000328
/* 0x0a9c	     */		nop

! Registers live out of .L900000143: 
! sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000143

			.L77000413:

! Registers live out of .L77000413: 
! sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000390 .L77000392 .L77000413 .L900000143

			.L77000328:
/* 0x0aa0	 130 */		retl	! Result = 
/* 0x0aa4	     */		nop
/* 0x0aa8	   0 */		.type	gl_xform_points_4fv,2
/* 0x0aa8	   0 */		.size	gl_xform_points_4fv,(.-gl_xform_points_4fv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000201:
/* 000000	   0 */		.word	1065353216
/* 0x0004	   0 */		.type	___const_seg_900000201,1
/* 0x0004	   0 */		.size	___const_seg_900000201,(.-___const_seg_900000201)
/* 0x0004	   0 */		.align	4
/* 0x0004	     */		.skip	16
/* 0x0014	     */		.align	4

!  134		      !         }
!  135		      !      }
!  136		      !   }
!  137		      !}
!  141		      !/*
!  142		      ! * Apply a transformation matrix to an array of [X Y Z] coordinates:
!  143		      ! *   for i in 0 to n-1 do   q[i] = m * p[i]
!  144		      ! */
!  145		      !void gl_xform_points_3fv( GLuint n, GLfloat q[][4], const GLfloat m[16],
!  146		      !                          GLfloat p[][3] )
!  147		      !{

!
! SUBROUTINE gl_xform_points_3fv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_xform_points_3fv
                       

			gl_xform_points_3fv:
/* 000000	 147 */		orcc	%g0,%o0,%g0

!  148		      !   /* This function has been carefully crafted to maximize register usage
!  149		      !    * and use loop unrolling with IRIX 5.3's cc.  Hopefully other compilers
!  150		      !    * will like this code too.
!  151		      !    */
!  152		      !   {
!  153		      !      GLuint i;
!  154		      !      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8],  m12 = m[12];
!  155		      !      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9],  m13 = m[13];
!  156		      !      for (i=0;i<n;i++) {

/* 0x0004	 156 */		bleu,a,pn	%icc,.L900000230
/* 0x0008	 166 */		fzeros	%f1

! Registers live out of gl_xform_points_3fv: 
! g1 g3 o0 o1 o2 o3 sp o7 fp gsr 
! f1 f10 
		                       
! predecessor blocks: gl_xform_points_3fv

			.L77000549:
/* 0x000c	 154 */		ld	[%o2],%f24
/* 0x0010	 155 */		ld	[%o2+4],%f26
/* 0x0014	 154 */		ld	[%o2+16],%f1
/* 0x0018	 155 */		ld	[%o2+20],%f30
/* 0x001c	 154 */		ld	[%o2+32],%f3
/* 0x0020	 155 */		ld	[%o2+36],%f28
/* 0x0024	 154 */		ld	[%o2+48],%f5
/* 0x0028	     */		cmp	%o0,2
/* 0x002c	 155 */		ld	[%o2+52],%f7
/* 0x0030	 154 */		bl,pn	%icc,.L77000622
/* 0x0034	 147 */		or	%g0,%o3,%g5

! Registers live out of .L77000549: 
! g1 g3 g5 o0 o1 o2 sp o7 fp gsr 
! f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000549

			.L77000563:
/* 0x0038	 156 */		sethi	%hi(0x7ffffc00),%o5
/* 0x003c	     */		add	%o5,1022,%o4
/* 0x0040	     */		srl	%o0,0,%g4
/* 0x0044	     */		sub	%g4,%o4,%g2
/* 0x0048	     */		srlx	%g2,63,%o3
/* 0x004c	     */		andcc	%o3,1,%g0
/* 0x0050	     */		be,a,pn	%icc,.L77000559
/* 0x0054	     */		or	%g0,0,%g3

! Registers live out of .L77000563: 
! g1 g3 g5 o0 o1 o2 sp o7 fp gsr 
! f1 f3 f5 f7 f10 f24 f26 f28 f30 
		
!  157		      !         GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

                       
! predecessor blocks: .L77000563

			.L77000587:
/* 0x0058	 157 */		cmp	%o0,4
/* 0x005c	 156 */		add	%o0,-1,%o4
/* 0x0060	     */		or	%g0,0,%g2
/* 0x0064	     */		or	%g0,%g5,%o3
/* 0x0068	     */		or	%g0,%o1,%g4
/* 0x006c	 157 */		bl,pn	%icc,.L77000588
/* 0x0070	     */		nop

! Registers live out of .L77000587: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 sp o7 fp gsr 
! f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000587

			.L900000212:
/* 0x0074	 157 */		add	%o0,-4,%o5

! Registers live out of .L900000212: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f1 f3 f5 f7 f24 f26 f28 f30 
		                       
! predecessor blocks: .L900000210 .L900000212

			.L900000210:
/* 0x0078	 157 */		prefetch	[%o3+152],0
/* 0x007c	     */		prefetch	[%g4+196],2
/* 0x0080	 156 */		add	%g2,4,%g2
/* 0x0084	     */		add	%g4,64,%g4
/* 0x0088	 157 */		ld	[%o3],%f0
/* 0x008c	 156 */		cmp	%g2,%o5
/* 0x0090	 157 */		ld	[%o3+4],%f16
/* 0x0094	 156 */		add	%o3,48,%o3

!  158		      !         q[i][0] = m0 * p0 + m4  * p1 + m8 * p2 + m12;

/* 0x0098	 158 */		fmuls	%f0,%f24,%f18
/* 0x009c	 157 */		ld	[%o3-40],%f20
/* 0x00a0	 158 */		fmuls	%f16,%f1,%f2
/* 0x00a4	     */		fmuls	%f20,%f3,%f22

!  159		      !         q[i][1] = m1 * p0 + m5  * p1 + m9 * p2 + m13;

/* 0x00a8	 159 */		fmuls	%f0,%f26,%f4
/* 0x00ac	     */		fmuls	%f16,%f30,%f6
/* 0x00b0	 158 */		fadds	%f18,%f2,%f11
/* 0x00b4	 159 */		fmuls	%f20,%f28,%f8
/* 0x00b8	 158 */		fadds	%f5,%f22,%f10
/* 0x00bc	 159 */		fadds	%f4,%f6,%f12
/* 0x00c0	     */		fadds	%f7,%f8,%f9
/* 0x00c4	 158 */		fadds	%f11,%f10,%f13
/* 0x00c8	     */		st	%f13,[%g4-64]
/* 0x00cc	 159 */		fadds	%f12,%f9,%f15
/* 0x00d0	     */		st	%f15,[%g4-60]
/* 0x00d4	 157 */		ld	[%o3-36],%f17
/* 0x00d8	     */		ld	[%o3-32],%f19
/* 0x00dc	 158 */		fmuls	%f17,%f24,%f23
/* 0x00e0	 157 */		ld	[%o3-28],%f25
/* 0x00e4	 158 */		fmuls	%f19,%f1,%f21
/* 0x00e8	     */		fmuls	%f25,%f3,%f27
/* 0x00ec	 159 */		fmuls	%f17,%f26,%f14
/* 0x00f0	     */		fmuls	%f19,%f30,%f29
/* 0x00f4	 158 */		fadds	%f23,%f21,%f16
/* 0x00f8	 159 */		fmuls	%f25,%f28,%f31
/* 0x00fc	 158 */		fadds	%f5,%f27,%f0
/* 0x0100	 159 */		fadds	%f14,%f29,%f20
/* 0x0104	     */		fadds	%f7,%f31,%f18
/* 0x0108	 158 */		fadds	%f16,%f0,%f2
/* 0x010c	     */		st	%f2,[%g4-48]
/* 0x0110	 159 */		fadds	%f20,%f18,%f22
/* 0x0114	     */		st	%f22,[%g4-44]
/* 0x0118	 157 */		ld	[%o3-24],%f6
/* 0x011c	     */		ld	[%o3-20],%f4
/* 0x0120	 158 */		fmuls	%f6,%f24,%f11
/* 0x0124	 157 */		ld	[%o3-16],%f9
/* 0x0128	 158 */		fmuls	%f4,%f1,%f10
/* 0x012c	     */		fmuls	%f9,%f3,%f13
/* 0x0130	 159 */		fmuls	%f6,%f26,%f12
/* 0x0134	     */		fmuls	%f4,%f30,%f8
/* 0x0138	 158 */		fadds	%f11,%f10,%f19
/* 0x013c	 159 */		fmuls	%f9,%f28,%f15
/* 0x0140	 158 */		fadds	%f5,%f13,%f17
/* 0x0144	 159 */		fadds	%f12,%f8,%f25
/* 0x0148	     */		fadds	%f7,%f15,%f23
/* 0x014c	 158 */		fadds	%f19,%f17,%f21
/* 0x0150	     */		st	%f21,[%g4-32]
/* 0x0154	 159 */		fadds	%f25,%f23,%f27
/* 0x0158	     */		st	%f27,[%g4-28]
/* 0x015c	 157 */		ld	[%o3-12],%f29
/* 0x0160	     */		ld	[%o3-8],%f31
/* 0x0164	 158 */		fmuls	%f29,%f24,%f16
/* 0x0168	 157 */		ld	[%o3-4],%f2
/* 0x016c	 158 */		fmuls	%f31,%f1,%f0
/* 0x0170	     */		fmuls	%f2,%f3,%f18
/* 0x0174	 159 */		fmuls	%f29,%f26,%f14
/* 0x0178	     */		fmuls	%f31,%f30,%f20
/* 0x017c	 158 */		fadds	%f16,%f0,%f4
/* 0x0180	 159 */		fmuls	%f2,%f28,%f22
/* 0x0184	 158 */		fadds	%f5,%f18,%f6
/* 0x0188	 159 */		fadds	%f14,%f20,%f9
/* 0x018c	     */		fadds	%f7,%f22,%f11
/* 0x0190	 158 */		fadds	%f4,%f6,%f10
/* 0x0194	     */		st	%f10,[%g4-16]
/* 0x0198	 159 */		fadds	%f9,%f11,%f13
/* 0x019c	 156 */		ble,pt	%icc,.L900000210
/* 0x01a0	 159 */		st	%f13,[%g4-12]

! Registers live out of .L900000210: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 fp gsr 
! f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L900000210

			.L900000213:
/* 0x01a4	 156 */		cmp	%g2,%o4
/* 0x01a8	     */		bg,pn	%icc,.L900000209
/* 0x01ac	 157 */		nop

! Registers live out of .L900000213: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 sp o7 fp gsr 
! f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000587 .L900000213

			.L77000588:
/* 0x01b0	 157 */		ld	[%o3],%f0

! Registers live out of .L77000588: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 sp o7 fp gsr 
! f0 f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000588 .L900000229

			.L900000229:
/* 0x01b4	 157 */		ld	[%o3+4],%f20
/* 0x01b8	     */		ld	[%o3+8],%f16
/* 0x01bc	 159 */		fmuls	%f0,%f26,%f17
/* 0x01c0	 158 */		fmuls	%f0,%f24,%f19
/* 0x01c4	 159 */		fmuls	%f16,%f28,%f6
/* 0x01c8	 158 */		fmuls	%f16,%f3,%f4
/* 0x01cc	 159 */		fmuls	%f20,%f30,%f15
/* 0x01d0	 158 */		fmuls	%f20,%f1,%f12
/* 0x01d4	 156 */		add	%g2,1,%g2
/* 0x01d8	     */		cmp	%g2,%o4
/* 0x01dc	 159 */		fadds	%f7,%f6,%f21
/* 0x01e0	 158 */		fadds	%f5,%f4,%f25
/* 0x01e4	 159 */		fadds	%f17,%f15,%f8
/* 0x01e8	 158 */		fadds	%f19,%f12,%f27
/* 0x01ec	 156 */		add	%o3,12,%o3
/* 0x01f0	 159 */		fadds	%f8,%f21,%f23
/* 0x01f4	     */		st	%f23,[%g4+4]
/* 0x01f8	 158 */		fadds	%f27,%f25,%f29
/* 0x01fc	     */		st	%f29,[%g4]
/* 0x0200	 156 */		add	%g4,16,%g4
/* 0x0204	     */		ble,a,pt	%icc,.L900000229
/* 0x0208	 157 */		ld	[%o3],%f0

! Registers live out of .L900000229: 
! g1 g2 g3 g4 g5 o0 o1 o2 o3 o4 sp o7 fp gsr 
! f0 f1 f3 f5 f7 f10 f24 f26 f28 f30 
		                       
! predecessor blocks: .L900000213 .L900000229

			.L900000209:
/* 0x020c	 156 */		ba	.L900000228
/* 0x0210	 166 */		fzeros	%f10

! Registers live out of .L900000209: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f10 
		                       
! predecessor blocks: .L77000549

			.L77000622:
/* 0x0214	 156 */		or	%g0,0,%g3

! Registers live out of .L77000622: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! f1 f3 f5 f7 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000563 .L77000622

			.L77000559:
/* 0x0218	 157 */		sll	%g3,2,%g1

! Registers live out of .L77000559: 
! g1 g3 g5 o0 o1 o2 sp o7 fp gsr 
! f1 f3 f5 f7 f24 f26 f28 f30 
		                       
! predecessor blocks: .L77000559 .L900000227

			.L900000227:
/* 0x021c	 157 */		sub	%g1,%g3,%o5
/* 0x0220	     */		sll	%o5,2,%o4
/* 0x0224	     */		add	%o4,%g5,%g4
/* 0x0228	     */		ld	[%g4],%f14
/* 0x022c	     */		ld	[%g4+4],%f10
/* 0x0230	     */		ld	[%g4+8],%f22
/* 0x0234	 158 */		fmuls	%f14,%f24,%f16
/* 0x0238	     */		fmuls	%f10,%f1,%f11
/* 0x023c	     */		fmuls	%f22,%f3,%f0
/* 0x0240	 159 */		fmuls	%f14,%f26,%f13
/* 0x0244	     */		fmuls	%f22,%f28,%f9
/* 0x0248	     */		fmuls	%f10,%f30,%f20
/* 0x024c	 158 */		sll	%g3,4,%o3
/* 0x0250	     */		fadds	%f16,%f11,%f4
/* 0x0254	     */		fadds	%f5,%f0,%f6
/* 0x0258	 156 */		add	%g3,1,%g3
/* 0x025c	 159 */		fadds	%f7,%f9,%f17
/* 0x0260	     */		fadds	%f13,%f20,%f12
/* 0x0264	 158 */		add	%o3,%o1,%g2
/* 0x0268	 156 */		cmp	%g3,%o0
/* 0x026c	 158 */		fadds	%f4,%f6,%f15
/* 0x0270	     */		st	%f15,[%o1+%o3]
/* 0x0274	 159 */		fadds	%f12,%f17,%f19
/* 0x0278	     */		st	%f19,[%g2+4]
/* 0x027c	 156 */		bcs,pt	%icc,.L900000227
/* 0x0280	 157 */		sll	%g3,2,%g1

! Registers live out of .L900000227: 
! g1 g3 g5 o0 o1 o2 sp o7 fp gsr 
! f1 f3 f5 f7 f24 f26 f28 f30 
		
!  160		      !      }
!  161		      !   }
!  162		      !   {
!  163		      !      GLuint i;
!  164		      !      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10],  m14 = m[14];
!  165		      !      GLfloat m3 = m[3],  m7 = m[7],  m11 = m[11],  m15 = m[15];
!  166		      !      if (m3==0.0F && m7==0.0F && m11==0.0F && m15==1.0F) {

                       
! predecessor blocks: .L900000227

			.L77000514:
/* 0x0284	 166 */		fzeros	%f10

! Registers live out of .L77000514: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f10 
		                       
! predecessor blocks: .L77000514 .L900000209

			.L900000228:
/* 0x0288	 165 */		ld	[%o2+12],%f0
/* 0x028c	     */		ld	[%o2+28],%f18
/* 0x0290	     */		ld	[%o2+44],%f2
/* 0x0294	 166 */		fcmps	%fcc1,%f0,%f10
/* 0x0298	 165 */		ld	[%o2+60],%f22
/* 0x029c	 166 */		fbne,pn	%fcc1,.L900000226
/* 0x02a0	 176 */		cmp	%o0,2

! Registers live out of .L900000228: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f10 f18 f22 
		                       
! predecessor blocks: .L900000228

			.L77000516:
/* 0x02a4	 166 */		fcmps	%fcc2,%f18,%f10
/* 0x02a8	     */		fbne,pn	%fcc2,.L900000226
/* 0x02ac	 176 */		cmp	%o0,2

! Registers live out of .L77000516: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f10 f18 f22 
		                       
! predecessor blocks: .L77000516

			.L77000518:
/* 0x02b0	 166 */		fcmps	%fcc3,%f2,%f10
/* 0x02b4	     */		fbne,pn	%fcc3,.L77000532
/* 0x02b8	     */		sethi	%hi(___const_seg_900000201),%o3

! Registers live out of .L77000518: 
! g5 o0 o1 o2 o3 sp o7 fp gsr 
! f0 f2 f18 f22 
		                       
! predecessor blocks: .L77000518

			.L77000520:
/* 0x02bc	 166 */		ld	[%o3+%lo(___const_seg_900000201)],%f14
/* 0x02c0	     */		fcmps	%fcc0,%f22,%f14
/* 0x02c4	     */		fbne,pn	%fcc0,.L77000532
/* 0x02c8	 168 */		cmp	%o0,2

! Registers live out of .L77000520: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f14 f18 f22 
		
!  167		      !         /* common case */
!  168		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000520

			.L77000522:
/* 0x02cc	 168 */		bl,pn	%icc,.L77000658
/* 0x02d0	 164 */		sethi	%hi(0x7ffffc00),%o4

! Registers live out of .L77000522: 
! g5 o0 o1 o2 o4 sp o7 fp gsr 
! f14 
		                       
! predecessor blocks: .L77000522

			.L77000571:
/* 0x02d4	 164 */		add	%o4,1022,%g4
/* 0x02d8	     */		srl	%o0,0,%g2
/* 0x02dc	     */		sub	%g2,%g4,%g1
/* 0x02e0	     */		srlx	%g1,63,%o5
/* 0x02e4	     */		andcc	%o5,1,%g0
/* 0x02e8	     */		be,pn	%icc,.L77000664
/* 0x02ec	 168 */		cmp	%o0,0

! Registers live out of .L77000571: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f14 
		                       
! predecessor blocks: .L77000571

			.L77000589:
/* 0x02f0	 168 */		ble,pn	%icc,.L77000543
/* 0x02f4	     */		add	%o0,-1,%o0

! Registers live out of .L77000589: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f14 
		
!  169		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];
!  170		      !            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14;

                       
! predecessor blocks: .L77000589

			.L77000612:
/* 0x02f8	 170 */		add	%o0,1,%g1
/* 0x02fc	 164 */		ld	[%o2+8],%f4
/* 0x0300	     */		ld	[%o2+24],%f20
/* 0x0304	 170 */		cmp	%g1,4
/* 0x0308	 164 */		ld	[%o2+40],%f6
/* 0x030c	     */		add	%o1,8,%o3
/* 0x0310	     */		ld	[%o2+56],%f16
/* 0x0314	 168 */		or	%g0,0,%o2
/* 0x0318	 164 */		fmovs	%f14,%f0
/* 0x031c	 170 */		bl,pn	%icc,.L77000590
/* 0x0320	     */		nop

! Registers live out of .L77000612: 
! g5 o0 o2 o3 sp o7 fp gsr 
! f0 f4 f6 f16 f20 
		                       
! predecessor blocks: .L77000612

			.L900000220:
/* 0x0324	 170 */		fmovs	%f20,%f5
/* 0x0328	     */		fmovs	%f16,%f1
/* 0x032c	     */		sub	%o0,3,%o5

! Registers live out of .L900000220: 
! g5 o0 o2 o3 o5 sp o7 fp gsr 
! f0 f1 f4 f5 f6 
		                       
! predecessor blocks: .L900000218 .L900000220

			.L900000218:
/* 0x0330	 170 */		prefetch	[%g5+152],0
/* 0x0334	     */		prefetch	[%o3+196],2
/* 0x0338	 168 */		add	%o2,4,%o2
/* 0x033c	     */		add	%o3,64,%o3
/* 0x0340	 170 */		ld	[%g5],%f8
/* 0x0344	 168 */		cmp	%o2,%o5
/* 0x0348	 170 */		ld	[%g5+4],%f10
/* 0x034c	 168 */		add	%g5,48,%g5
/* 0x0350	 170 */		fmuls	%f8,%f4,%f9
/* 0x0354	     */		ld	[%g5-40],%f12
/* 0x0358	     */		fmuls	%f10,%f5,%f14
/* 0x035c	     */		fmuls	%f12,%f6,%f11
/* 0x0360	     */		fadds	%f9,%f14,%f15
/* 0x0364	     */		fadds	%f1,%f11,%f13

!  171		      !            q[i][3] = 1.0F;

/* 0x0368	 171 */		st	%f0,[%o3-60]
/* 0x036c	 170 */		fadds	%f15,%f13,%f17
/* 0x0370	     */		st	%f17,[%o3-64]
/* 0x0374	     */		ld	[%g5-36],%f19
/* 0x0378	     */		ld	[%g5-32],%f21
/* 0x037c	     */		fmuls	%f19,%f4,%f27
/* 0x0380	     */		ld	[%g5-28],%f23
/* 0x0384	     */		fmuls	%f21,%f5,%f25
/* 0x0388	     */		fmuls	%f23,%f6,%f29
/* 0x038c	     */		fadds	%f27,%f25,%f16
/* 0x0390	     */		fadds	%f1,%f29,%f31
/* 0x0394	 171 */		st	%f0,[%o3-44]
/* 0x0398	 170 */		fadds	%f16,%f31,%f2
/* 0x039c	     */		st	%f2,[%o3-48]
/* 0x03a0	     */		ld	[%g5-24],%f18
/* 0x03a4	     */		ld	[%g5-20],%f20
/* 0x03a8	     */		fmuls	%f18,%f4,%f26
/* 0x03ac	     */		ld	[%g5-16],%f22
/* 0x03b0	     */		fmuls	%f20,%f5,%f24
/* 0x03b4	     */		fmuls	%f22,%f6,%f28
/* 0x03b8	     */		fadds	%f26,%f24,%f3
/* 0x03bc	     */		fadds	%f1,%f28,%f30
/* 0x03c0	 171 */		st	%f0,[%o3-28]
/* 0x03c4	 170 */		fadds	%f3,%f30,%f7
/* 0x03c8	     */		st	%f7,[%o3-32]
/* 0x03cc	     */		ld	[%g5-12],%f8
/* 0x03d0	     */		ld	[%g5-8],%f10
/* 0x03d4	     */		fmuls	%f8,%f4,%f9
/* 0x03d8	     */		ld	[%g5-4],%f12
/* 0x03dc	     */		fmuls	%f10,%f5,%f14
/* 0x03e0	     */		fmuls	%f12,%f6,%f11
/* 0x03e4	     */		fadds	%f9,%f14,%f15
/* 0x03e8	     */		fadds	%f1,%f11,%f13
/* 0x03ec	 171 */		st	%f0,[%o3-12]
/* 0x03f0	 170 */		fadds	%f15,%f13,%f17
/* 0x03f4	 168 */		ble,pt	%icc,.L900000218
/* 0x03f8	 170 */		st	%f17,[%o3-16]

! Registers live out of .L900000218: 
! g5 o0 o2 o3 o5 sp o7 fp gsr 
! f0 f1 f4 f5 f6 
		                       
! predecessor blocks: .L900000218

			.L900000221:
/* 0x03fc	 168 */		cmp	%o2,%o0
/* 0x0400	 170 */		fmovs	%f1,%f16
/* 0x0404	     */		fmovs	%f5,%f20
/* 0x0408	 168 */		bg,pn	%icc,.L900000208
/* 0x040c	 170 */		nop

! Registers live out of .L900000221: 
! g5 o0 o2 o3 sp o7 fp gsr 
! f0 f4 f6 f16 f20 
		                       
! predecessor blocks: .L77000612 .L900000221

			.L77000590:
/* 0x0410	 170 */		ld	[%g5],%f2

! Registers live out of .L77000590: 
! g5 o0 o2 o3 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f20 
		                       
! predecessor blocks: .L77000590 .L900000225

			.L900000225:
/* 0x0414	 170 */		ld	[%g5+4],%f18
/* 0x0418	     */		ld	[%g5+8],%f14
/* 0x041c	     */		fmuls	%f2,%f4,%f10
/* 0x0420	     */		fmuls	%f18,%f20,%f22
/* 0x0424	     */		fmuls	%f14,%f6,%f11
/* 0x0428	 168 */		add	%o2,1,%o2
/* 0x042c	 171 */		st	%f0,[%o3+4]
/* 0x0430	 168 */		cmp	%o2,%o0
/* 0x0434	     */		add	%g5,12,%g5
/* 0x0438	 170 */		fadds	%f10,%f22,%f13
/* 0x043c	     */		fadds	%f16,%f11,%f9
/* 0x0440	     */		fadds	%f13,%f9,%f3
/* 0x0444	     */		st	%f3,[%o3]
/* 0x0448	 168 */		add	%o3,16,%o3
/* 0x044c	     */		ble,a,pt	%icc,.L900000225
/* 0x0450	 170 */		ld	[%g5],%f2

! Registers live out of .L900000225: 
! g5 o0 o2 o3 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f20 
		                       
! predecessor blocks: .L900000221 .L900000225

			.L900000208:
/* 0x0454	 176 */		retl	! Result = 
/* 0x0458	     */		nop
                       
! predecessor blocks: .L77000571

			.L77000664:
/* 0x045c	 164 */		ld	[%o2+8],%f4
/* 0x0460	     */		ld	[%o2+24],%f20
/* 0x0464	     */		ld	[%o2+40],%f6
/* 0x0468	 168 */		or	%g0,0,%g3
/* 0x046c	 164 */		ld	[%o2+56],%f16
/* 0x0470	     */		ba	.L900000224
/* 0x0474	 170 */		or	%g0,0,%o2

! Registers live out of .L77000664: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! f4 f6 f14 f16 f20 
		                       
! predecessor blocks: .L77000522

			.L77000658:
/* 0x0478	 164 */		ld	[%o2+8],%f4
/* 0x047c	     */		ld	[%o2+24],%f20
/* 0x0480	     */		ld	[%o2+40],%f6
/* 0x0484	 168 */		or	%g0,0,%g3
/* 0x0488	 164 */		ld	[%o2+56],%f16
/* 0x048c	 170 */		or	%g0,0,%o2

! Registers live out of .L77000658: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! f4 f6 f14 f16 f20 
		                       
! predecessor blocks: .L77000658 .L77000664 .L900000224

			.L900000224:
/* 0x0490	 170 */		sub	%o2,%g3,%o4
/* 0x0494	     */		sll	%o4,2,%g2
/* 0x0498	     */		add	%g2,%g5,%g4
/* 0x049c	     */		ld	[%g4+4],%f24
/* 0x04a0	     */		ld	[%g4+8],%f1
/* 0x04a4	     */		ld	[%g5+%g2],%f26
/* 0x04a8	     */		fmuls	%f24,%f20,%f30
/* 0x04ac	     */		fmuls	%f1,%f6,%f28
/* 0x04b0	     */		fmuls	%f26,%f4,%f5
/* 0x04b4	     */		sll	%g3,4,%o3
/* 0x04b8	 168 */		add	%g3,1,%g3
/* 0x04bc	 170 */		add	%o3,%o1,%g1
/* 0x04c0	 168 */		cmp	%g3,%o0
/* 0x04c4	 170 */		fadds	%f16,%f28,%f31
/* 0x04c8	     */		fadds	%f5,%f30,%f2
/* 0x04cc	 171 */		st	%f14,[%g1+12]
/* 0x04d0	 170 */		fadds	%f2,%f31,%f18
/* 0x04d4	     */		st	%f18,[%g1+8]
/* 0x04d8	 168 */		bcs,pt	%icc,.L900000224
/* 0x04dc	 170 */		sll	%g3,2,%o2

! Registers live out of .L900000224: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! f4 f6 f14 f16 f20 
		                       
! predecessor blocks: .L900000224

			.L900000207:
/* 0x04e0	 176 */		retl	! Result = 
/* 0x04e4	     */		nop

!  172		      !         }
!  173		      !      }
!  174		      !      else {
!  175		      !         /* general case */
!  176		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77000518 .L77000520

			.L77000532:
/* 0x04e8	 176 */		cmp	%o0,2

! Registers live out of .L77000532: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f18 f22 
		                       
! predecessor blocks: .L77000516 .L77000532 .L900000228

			.L900000226:
/* 0x04ec	 176 */		bl,pn	%icc,.L77000638
/* 0x04f0	 164 */		sethi	%hi(0x7ffffc00),%g1

! Registers live out of .L900000226: 
! g1 g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f18 f22 
		                       
! predecessor blocks: .L900000226

			.L77000555:
/* 0x04f4	 164 */		add	%g1,1022,%o5
/* 0x04f8	     */		srl	%o0,0,%o4
/* 0x04fc	     */		sub	%o4,%o5,%g4
/* 0x0500	     */		srlx	%g4,63,%o3
/* 0x0504	     */		andcc	%o3,1,%g0
/* 0x0508	     */		be,pn	%icc,.L77000646
/* 0x050c	 176 */		cmp	%o0,0

! Registers live out of .L77000555: 
! g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f18 f22 
		                       
! predecessor blocks: .L77000555

			.L77000591:
/* 0x0510	 176 */		ble,pn	%icc,.L77000543
/* 0x0514	     */		or	%g0,0,%g3

! Registers live out of .L77000591: 
! g3 g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f18 f22 
		                       
! predecessor blocks: .L77000591

			.L77000616:
/* 0x0518	 164 */		ld	[%o2+8],%f4
/* 0x051c	     */		ld	[%o2+24],%f20

!  177		      !            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

/* 0x0520	 177 */		cmp	%o0,4
/* 0x0524	 164 */		ld	[%o2+40],%f6
/* 0x0528	 176 */		add	%o0,-1,%g2
/* 0x052c	 164 */		add	%o1,8,%o1
/* 0x0530	     */		ld	[%o2+56],%f16
/* 0x0534	 177 */		bl,pn	%icc,.L77000592
/* 0x0538	     */		nop

! Registers live out of .L77000616: 
! g2 g3 g5 o0 o1 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000616

			.L900000216:
/* 0x053c	 177 */		add	%o0,-4,%o4

! Registers live out of .L900000216: 
! g2 g3 g5 o1 o4 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000214 .L900000216

			.L900000214:
/* 0x0540	 177 */		prefetch	[%g5+152],0
/* 0x0544	     */		prefetch	[%o1+196],2
/* 0x0548	 176 */		add	%g3,4,%g3
/* 0x054c	     */		add	%o1,64,%o1
/* 0x0550	 177 */		ld	[%g5],%f19
/* 0x0554	 176 */		cmp	%g3,%o4
/* 0x0558	 177 */		ld	[%g5+4],%f21
/* 0x055c	 176 */		add	%g5,48,%g5

!  178		      !            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14;

/* 0x0560	 178 */		fmuls	%f19,%f4,%f25
/* 0x0564	 177 */		ld	[%g5-40],%f27
/* 0x0568	 178 */		fmuls	%f21,%f20,%f23
/* 0x056c	     */		fmuls	%f27,%f6,%f29

!  179		      !            q[i][3] = m3 * p0 + m7 * p1 + m11 * p2 + m15;

/* 0x0570	 179 */		fmuls	%f19,%f0,%f24
/* 0x0574	     */		fmuls	%f21,%f18,%f31
/* 0x0578	 178 */		fadds	%f25,%f23,%f30
/* 0x057c	 179 */		fmuls	%f27,%f2,%f26
/* 0x0580	 178 */		fadds	%f16,%f29,%f28
/* 0x0584	 179 */		fadds	%f24,%f31,%f3
/* 0x0588	     */		fadds	%f22,%f26,%f1
/* 0x058c	 178 */		fadds	%f30,%f28,%f5
/* 0x0590	     */		st	%f5,[%o1-64]
/* 0x0594	 179 */		fadds	%f3,%f1,%f7
/* 0x0598	     */		st	%f7,[%o1-60]
/* 0x059c	 177 */		ld	[%g5-36],%f8
/* 0x05a0	     */		ld	[%g5-32],%f9
/* 0x05a4	 178 */		fmuls	%f8,%f4,%f11
/* 0x05a8	 177 */		ld	[%g5-28],%f12
/* 0x05ac	 178 */		fmuls	%f9,%f20,%f10
/* 0x05b0	     */		fmuls	%f12,%f6,%f13
/* 0x05b4	 179 */		fmuls	%f8,%f0,%f14
/* 0x05b8	     */		fmuls	%f9,%f18,%f15
/* 0x05bc	 178 */		fadds	%f11,%f10,%f21
/* 0x05c0	 179 */		fmuls	%f12,%f2,%f17
/* 0x05c4	 178 */		fadds	%f16,%f13,%f19
/* 0x05c8	 179 */		fadds	%f14,%f15,%f27
/* 0x05cc	     */		fadds	%f22,%f17,%f25
/* 0x05d0	 178 */		fadds	%f21,%f19,%f23
/* 0x05d4	     */		st	%f23,[%o1-48]
/* 0x05d8	 179 */		fadds	%f27,%f25,%f29
/* 0x05dc	     */		st	%f29,[%o1-44]
/* 0x05e0	 177 */		ld	[%g5-24],%f31
/* 0x05e4	     */		ld	[%g5-20],%f24
/* 0x05e8	 178 */		fmuls	%f31,%f4,%f28
/* 0x05ec	 177 */		ld	[%g5-16],%f30
/* 0x05f0	 178 */		fmuls	%f24,%f20,%f26
/* 0x05f4	     */		fmuls	%f30,%f6,%f5
/* 0x05f8	 179 */		fmuls	%f31,%f0,%f3
/* 0x05fc	     */		fmuls	%f24,%f18,%f1
/* 0x0600	 178 */		fadds	%f28,%f26,%f10
/* 0x0604	 179 */		fmuls	%f30,%f2,%f7
/* 0x0608	 178 */		fadds	%f16,%f5,%f8
/* 0x060c	 179 */		fadds	%f3,%f1,%f12
/* 0x0610	     */		fadds	%f22,%f7,%f9
/* 0x0614	 178 */		fadds	%f10,%f8,%f11
/* 0x0618	     */		st	%f11,[%o1-32]
/* 0x061c	 179 */		fadds	%f12,%f9,%f13
/* 0x0620	     */		st	%f13,[%o1-28]
/* 0x0624	 177 */		ld	[%g5-12],%f15
/* 0x0628	     */		ld	[%g5-8],%f17
/* 0x062c	 178 */		fmuls	%f15,%f4,%f21
/* 0x0630	 177 */		ld	[%g5-4],%f23
/* 0x0634	 178 */		fmuls	%f17,%f20,%f19
/* 0x0638	     */		fmuls	%f23,%f6,%f25
/* 0x063c	 179 */		fmuls	%f15,%f0,%f14
/* 0x0640	     */		fmuls	%f17,%f18,%f27
/* 0x0644	 178 */		fadds	%f21,%f19,%f24
/* 0x0648	 179 */		fmuls	%f23,%f2,%f29
/* 0x064c	 178 */		fadds	%f16,%f25,%f31
/* 0x0650	 179 */		fadds	%f14,%f27,%f30
/* 0x0654	     */		fadds	%f22,%f29,%f28
/* 0x0658	 178 */		fadds	%f24,%f31,%f26
/* 0x065c	     */		st	%f26,[%o1-16]
/* 0x0660	 179 */		fadds	%f30,%f28,%f5
/* 0x0664	 176 */		ble,pt	%icc,.L900000214
/* 0x0668	 179 */		st	%f5,[%o1-12]

! Registers live out of .L900000214: 
! g2 g3 g5 o1 o4 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000214

			.L900000217:
/* 0x066c	 176 */		cmp	%g3,%g2
/* 0x0670	     */		bg,pn	%icc,.L900000206
/* 0x0674	 177 */		nop

! Registers live out of .L900000217: 
! g2 g3 g5 o1 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000616 .L900000217

			.L77000592:
/* 0x0678	 177 */		ld	[%g5],%f26

! Registers live out of .L77000592: 
! g2 g3 g5 o1 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 f26 
		                       
! predecessor blocks: .L77000592 .L900000223

			.L900000223:
/* 0x067c	 177 */		ld	[%g5+4],%f30
/* 0x0680	     */		ld	[%g5+8],%f28
/* 0x0684	 179 */		fmuls	%f26,%f0,%f12
/* 0x0688	 178 */		fmuls	%f26,%f4,%f21
/* 0x068c	 179 */		fmuls	%f28,%f2,%f5
/* 0x0690	 178 */		fmuls	%f28,%f6,%f15
/* 0x0694	 179 */		fmuls	%f30,%f18,%f17
/* 0x0698	 178 */		fmuls	%f30,%f20,%f19
/* 0x069c	 176 */		add	%g3,1,%g3
/* 0x06a0	     */		cmp	%g3,%g2
/* 0x06a4	 179 */		fadds	%f22,%f5,%f8
/* 0x06a8	 178 */		fadds	%f16,%f15,%f27
/* 0x06ac	 179 */		fadds	%f12,%f17,%f23
/* 0x06b0	 178 */		fadds	%f21,%f19,%f29
/* 0x06b4	 176 */		add	%g5,12,%g5
/* 0x06b8	 179 */		fadds	%f23,%f8,%f25
/* 0x06bc	     */		st	%f25,[%o1+4]
/* 0x06c0	 178 */		fadds	%f29,%f27,%f31
/* 0x06c4	     */		st	%f31,[%o1]
/* 0x06c8	 176 */		add	%o1,16,%o1
/* 0x06cc	     */		ble,a,pt	%icc,.L900000223
/* 0x06d0	 177 */		ld	[%g5],%f26

! Registers live out of .L900000223: 
! g2 g3 g5 o1 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 f26 
		                       
! predecessor blocks: .L900000217 .L900000223

			.L900000206:
/* 0x06d4	 176 */		retl	! Result = 
/* 0x06d8	     */		nop
                       
! predecessor blocks: .L77000555

			.L77000646:
/* 0x06dc	 164 */		ld	[%o2+8],%f4
/* 0x06e0	     */		ld	[%o2+24],%f20
/* 0x06e4	     */		ld	[%o2+40],%f6
/* 0x06e8	 176 */		or	%g0,0,%g2
/* 0x06ec	 164 */		ld	[%o2+56],%f16
/* 0x06f0	     */		ba	.L900000222
/* 0x06f4	 177 */		or	%g0,0,%o2

! Registers live out of .L77000646: 
! g2 g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000226

			.L77000638:
/* 0x06f8	 164 */		ld	[%o2+8],%f4
/* 0x06fc	     */		ld	[%o2+24],%f20
/* 0x0700	     */		ld	[%o2+40],%f6
/* 0x0704	 176 */		or	%g0,0,%g2
/* 0x0708	 164 */		ld	[%o2+56],%f16
/* 0x070c	 177 */		or	%g0,0,%o2

! Registers live out of .L77000638: 
! g2 g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L77000638 .L77000646 .L900000222

			.L900000222:
/* 0x0710	 177 */		sub	%o2,%g2,%g3
/* 0x0714	     */		sll	%g3,2,%g1
/* 0x0718	     */		add	%g1,%g5,%o5
/* 0x071c	     */		ld	[%o5],%f3
/* 0x0720	     */		ld	[%o5+4],%f23
/* 0x0724	     */		ld	[%o5+8],%f21
/* 0x0728	 179 */		fmuls	%f3,%f0,%f29
/* 0x072c	 178 */		fmuls	%f3,%f4,%f24
/* 0x0730	 179 */		fmuls	%f21,%f2,%f8
/* 0x0734	 178 */		fmuls	%f21,%f6,%f25
/* 0x0738	 179 */		fmuls	%f23,%f18,%f27
/* 0x073c	 178 */		fmuls	%f23,%f20,%f1
/* 0x0740	     */		sll	%g2,4,%o4
/* 0x0744	 176 */		add	%g2,1,%g2
/* 0x0748	 179 */		fadds	%f22,%f8,%f26
/* 0x074c	 178 */		fadds	%f16,%f25,%f5
/* 0x0750	 179 */		fadds	%f29,%f27,%f28
/* 0x0754	 178 */		fadds	%f24,%f1,%f31
/* 0x0758	     */		add	%o4,%o1,%g4
/* 0x075c	 176 */		cmp	%g2,%o0
/* 0x0760	 179 */		fadds	%f28,%f26,%f30
/* 0x0764	     */		st	%f30,[%g4+12]
/* 0x0768	 178 */		fadds	%f31,%f5,%f7
/* 0x076c	     */		st	%f7,[%g4+8]
/* 0x0770	 176 */		bcs,pt	%icc,.L900000222
/* 0x0774	 177 */		sll	%g2,2,%o2

! Registers live out of .L900000222: 
! g2 g5 o0 o1 o2 sp o7 fp gsr 
! f0 f2 f4 f6 f16 f18 f20 f22 
		                       
! predecessor blocks: .L900000222

			.L900000205:
/* 0x0778	 176 */		retl	! Result = 
/* 0x077c	     */		nop
                       
! predecessor blocks: gl_xform_points_3fv

			.L900000230:
/* 0x0780	 166 */		ld	[%o2+12],%f3
/* 0x0784	     */		fcmps	%fcc3,%f3,%f1
/* 0x0788	     */		fbne,pn	%fcc3,.L77000543
/* 0x078c	     */		nop

! Registers live out of .L900000230: 
! o2 sp o7 fp gsr 
! f1 
		                       
! predecessor blocks: .L900000230

			.L77000608:
/* 0x0790	 165 */		ld	[%o2+28],%f7
/* 0x0794	 166 */		fcmps	%fcc2,%f7,%f1
/* 0x0798	     */		fbne,pn	%fcc2,.L77000543
/* 0x079c	     */		nop

! Registers live out of .L77000608: 
! sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000608

			.L77000607:

! Registers live out of .L77000607: 
! sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000589 .L77000591 .L77000607 .L77000608 .L900000230

			.L77000543:
/* 0x07a0	 176 */		retl	! Result = 
/* 0x07a4	     */		nop
/* 0x07a8	   0 */		.type	gl_xform_points_3fv,2
/* 0x07a8	   0 */		.size	gl_xform_points_3fv,(.-gl_xform_points_3fv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000301:
/* 000000	   0 */		.word	968116299,-18103648
/* 0x0008	     */		.word	1072693248,0
/* 0x0010	   0 */		.type	___const_seg_900000301,1
/* 0x0010	   0 */		.size	___const_seg_900000301,(.-___const_seg_900000301)
/* 0x0010	   0 */		.align	4

!  180		      !         }
!  181		      !      }
!  182		      !   }
!  183		      !}
!  187		      !#ifndef USE_ASM
!  188		      !/*
!  189		      ! * Apply a transformation matrix to an array of normal vectors:
!  190		      ! *   for i in 0 to n-1 do  v[i] = u[i] * m
!  191		      ! * where u[i] and v[i] are 3-element row vectors and m is a 16-element
!  192		      ! * transformation matrix.
!  193		      ! * If the normalize flag is true the normals will be scaled to length 1.
!  194		      ! */
!  195		      !void gl_xform_normals_3fv( GLuint n, GLfloat v[][3], const GLfloat m[16],
!  196		      !                           GLfloat u[][3], GLboolean normalize )
!  197		      !{

!
! SUBROUTINE gl_xform_normals_3fv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_xform_normals_3fv
                       

			gl_xform_normals_3fv:
/* 000000	 197 */		andcc	%o4,255,%g0
/* 0x0004	     */		or	%g0,%o3,%o4
/* 0x0008	     */		or	%g0,%o1,%o5

!  198		      !   if (normalize) {

/* 0x000c	 198 */		be,pn	%icc,.L77000694
/* 0x0010	 204 */		cmp	%o0,0

! Registers live out of gl_xform_normals_3fv: 
! o0 o2 o4 o5 sp o7 fp gsr 
! 
		
!  199		      !      /* Transform normals and scale to unit length */
!  200		      !      GLuint i;
!  201		      !      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8];
!  202		      !      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9];
!  203		      !      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10];
!  204		      !      for (i=0;i<n;i++) {

                       
! predecessor blocks: gl_xform_normals_3fv

			.L77000678:
/* 0x0014	 204 */		bleu,pn	%icc,.L77000705
/* 0x0018	     */		nop

! Registers live out of .L77000678: 
! o0 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000678

			.L77000709:
/* 0x001c	 201 */		ld	[%o2],%f26
/* 0x0020	 202 */		ld	[%o2+4],%f6
/* 0x0024	 203 */		ld	[%o2+8],%f27
/* 0x0028	 201 */		ld	[%o2+16],%f8
/* 0x002c	 202 */		ld	[%o2+20],%f29
/* 0x0030	 203 */		ld	[%o2+24],%f2
/* 0x0034	 201 */		ld	[%o2+32],%f31
/* 0x0038	 202 */		ld	[%o2+36],%f4
/* 0x003c	 201 */		cmp	%o0,2
/* 0x0040	   0 */		sethi	%hi(___const_seg_900000301+8),%g5
/* 0x0044	 203 */		ld	[%o2+40],%f17
/* 0x0048	 201 */		bl,pn	%icc,.L77000761
/* 0x004c	   0 */		add	%g5,%lo(___const_seg_900000301+8),%o1

! Registers live out of .L77000709: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000709

			.L77000718:
/* 0x0050	 204 */		sethi	%hi(0x7ffffc00),%g2
/* 0x0054	     */		add	%g2,1022,%g1
/* 0x0058	     */		srl	%o0,0,%o3
/* 0x005c	     */		sub	%o3,%g1,%o2
/* 0x0060	     */		srlx	%o2,63,%g4
/* 0x0064	     */		andcc	%g4,1,%g0
/* 0x0068	     */		be,a,pn	%icc,.L77000711
/* 0x006c	     */		or	%g0,0,%o2

! Registers live out of .L77000718: 
! g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000718

			.L77000738:
/* 0x0070	 204 */		add	%o0,-1,%g3

!  205		      !         GLdouble tx, ty, tz;
!  206		      !         {
!  207		      !            GLfloat ux = u[i][0],  uy = u[i][1],  uz = u[i][2];

/* 0x0074	 207 */		ld	[%o4],%f10
/* 0x0078	 204 */		or	%g0,0,%o0

! Registers live out of .L77000738: 
! g3 g5 o0 o1 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f10 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000738 .L900000319

			.L900000318:
/* 0x007c	 207 */		ld	[%o4+4],%f21

!  208		      !            tx = ux * m0 + uy * m1 + uz * m2;
!  209		      !            ty = ux * m4 + uy * m5 + uz * m6;

/* 0x0080	 209 */		fmuls	%f10,%f8,%f24
/* 0x0084	 208 */		fmuls	%f10,%f26,%f25
/* 0x0088	 209 */		fmuls	%f21,%f29,%f22
/* 0x008c	 208 */		fmuls	%f21,%f6,%f23
/* 0x0090	 207 */		ld	[%o4+8],%f18

!  210		      !            tz = ux * m8 + uy * m9 + uz * m10;

/* 0x0094	 210 */		fmuls	%f21,%f4,%f20
/* 0x0098	     */		fmuls	%f10,%f31,%f28
/* 0x009c	 209 */		fmuls	%f18,%f2,%f30
/* 0x00a0	     */		fadds	%f24,%f22,%f1
/* 0x00a4	 208 */		fmuls	%f18,%f27,%f3
/* 0x00a8	     */		fadds	%f25,%f23,%f13
/* 0x00ac	 210 */		fmuls	%f18,%f17,%f5
/* 0x00b0	     */		fadds	%f28,%f20,%f0

!  211		      !         }
!  212		      !         {
!  213		      !            GLdouble len, scale;
!  214		      !            len = GL_SQRT( tx*tx + ty*ty + tz*tz );
!  215		      !            scale = (len>1E-30) ? (1.0 / len) : 1.0;

/* 0x00b4	 215 */		ldd	[%o1-8],%f58
/* 0x00b8	 209 */		fadds	%f1,%f30,%f16
/* 0x00bc	 208 */		fadds	%f13,%f3,%f7
/* 0x00c0	 210 */		fadds	%f0,%f5,%f9
/* 0x00c4	 214 */		fsmuld	%f16,%f16,%f40
/* 0x00c8	 209 */		fstod	%f16,%f56
/* 0x00cc	 214 */		fsmuld	%f7,%f7,%f42
/* 0x00d0	 208 */		fstod	%f7,%f54
/* 0x00d4	 214 */		fsmuld	%f9,%f9,%f44
/* 0x00d8	     */		faddd	%f42,%f40,%f46
/* 0x00dc	     */		faddd	%f46,%f44,%f48
/* 0x00e0	     */		fsqrtd	%f48,%f60
/* 0x00e4	 215 */		fcmped	%fcc0,%f60,%f58
/* 0x00e8	     */		fbule,pn	%fcc0,.L77000686
/* 0x00ec	 210 */		fstod	%f9,%f62

! Registers live out of .L900000318: 
! g3 g5 o0 o1 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f10 f17 f22 f24 f26 f27 f28 f29 f30 f31 
		                       
! predecessor blocks: .L900000318

			.L77000684:
/* 0x00f0	 215 */		ldd	[%g5+%lo(___const_seg_900000301+8)],%f36
/* 0x00f4	     */		fdivd	%f36,%f60,%f38
/* 0x00f8	     */		ba	.L900000319
/* 0x00fc	 218 */		fmuld	%f62,%f38,%f32

! Registers live out of .L77000684: 
! g3 g5 o0 o1 o4 o5 sp o7 fp gsr y
! f0 f2 f4 f6 f8 f10 f17 f22 f24 f26 f27 f29 f31 
		                       
! predecessor blocks: .L900000318

			.L77000686:
/* 0x0100	 215 */		ldd	[%g5+%lo(___const_seg_900000301+8)],%f38

!  216		      !            v[i][0] = tx * scale;
!  217		      !            v[i][1] = ty * scale;
!  218		      !            v[i][2] = tz * scale;

/* 0x0104	 218 */		fmuld	%f62,%f38,%f32

! Registers live out of .L77000686: 
! g3 g5 o0 o1 o4 o5 sp o7 fp gsr y
! f0 f2 f4 f6 f8 f10 f17 f22 f24 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000684 .L77000686

			.L900000319:
/* 0x0108	 217 */		fmuld	%f56,%f38,%f34
/* 0x010c	 216 */		fmuld	%f54,%f38,%f36
/* 0x0110	 218 */		fdtos	%f32,%f0
/* 0x0114	 204 */		add	%o0,1,%o0
/* 0x0118	 218 */		st	%f0,[%o5+8]
/* 0x011c	 204 */		cmp	%o0,%g3
/* 0x0120	 217 */		fdtos	%f34,%f18
/* 0x0124	     */		st	%f18,[%o5+4]
/* 0x0128	 216 */		fdtos	%f36,%f20
/* 0x012c	     */		st	%f20,[%o5]
/* 0x0130	 204 */		add	%o4,12,%o4
/* 0x0134	     */		add	%o5,12,%o5
/* 0x0138	     */		ble,a,pt	%icc,.L900000318
/* 0x013c	 207 */		ld	[%o4],%f10

! Registers live out of .L900000319: 
! g3 g5 o0 o1 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f10 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L900000319

			.L900000309:
/* 0x0140	 228 */		retl	! Result = 
/* 0x0144	     */		nop
                       
! predecessor blocks: .L77000709

			.L77000761:
/* 0x0148	 204 */		or	%g0,0,%o2

! Registers live out of .L77000761: 
! g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000718 .L77000761

			.L77000711:
/* 0x014c	 207 */		sll	%o2,2,%g2

! Registers live out of .L77000711: 
! g2 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000711 .L900000317

			.L900000316:
/* 0x0150	 207 */		sub	%g2,%o2,%g1
/* 0x0154	     */		sll	%g1,2,%g4
/* 0x0158	     */		add	%g4,%o4,%o3
/* 0x015c	     */		ld	[%o3],%f18
/* 0x0160	     */		ld	[%o3+4],%f25
/* 0x0164	     */		ld	[%o3+8],%f1
/* 0x0168	 209 */		fmuls	%f18,%f8,%f28
/* 0x016c	     */		fmuls	%f25,%f29,%f20
/* 0x0170	 208 */		fmuls	%f25,%f6,%f30
/* 0x0174	     */		fmuls	%f18,%f26,%f13
/* 0x0178	 210 */		fmuls	%f25,%f4,%f0
/* 0x017c	     */		fmuls	%f18,%f31,%f3
/* 0x0180	 209 */		fmuls	%f1,%f2,%f5
/* 0x0184	     */		fadds	%f28,%f20,%f16
/* 0x0188	 208 */		fmuls	%f1,%f27,%f7
/* 0x018c	     */		fadds	%f13,%f30,%f9
/* 0x0190	 210 */		fmuls	%f1,%f17,%f14
/* 0x0194	     */		fadds	%f3,%f0,%f12
/* 0x0198	 215 */		ldd	[%o1-8],%f56
/* 0x019c	 209 */		fadds	%f16,%f5,%f19
/* 0x01a0	 208 */		fadds	%f9,%f7,%f11
/* 0x01a4	 210 */		fadds	%f12,%f14,%f15
/* 0x01a8	 214 */		fsmuld	%f19,%f19,%f48
/* 0x01ac	 209 */		fstod	%f19,%f52
/* 0x01b0	 214 */		fsmuld	%f11,%f11,%f60
/* 0x01b4	 208 */		fstod	%f11,%f50
/* 0x01b8	 214 */		fsmuld	%f15,%f15,%f58
/* 0x01bc	     */		faddd	%f60,%f48,%f62
/* 0x01c0	     */		faddd	%f62,%f58,%f32
/* 0x01c4	     */		fsqrtd	%f32,%f34
/* 0x01c8	 215 */		fcmped	%fcc1,%f34,%f56
/* 0x01cc	     */		fbule,pn	%fcc1,.L77000714
/* 0x01d0	 210 */		fstod	%f15,%f54

! Registers live out of .L900000316: 
! g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f18 f20 f22 f26 f27 f29 f31 
		                       
! predecessor blocks: .L900000316

			.L77000712:
/* 0x01d4	 215 */		ldd	[%g5+%lo(___const_seg_900000301+8)],%f44
/* 0x01d8	     */		fdivd	%f44,%f34,%f46
/* 0x01dc	     */		ba	.L900000317
/* 0x01e0	 216 */		fmuld	%f50,%f46,%f38

! Registers live out of .L77000712: 
! g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f14 f17 f20 f22 f26 f27 f29 f31 
		                       
! predecessor blocks: .L900000316

			.L77000714:
/* 0x01e4	 215 */		ldd	[%g5+%lo(___const_seg_900000301+8)],%f46
/* 0x01e8	 216 */		fmuld	%f50,%f46,%f38

! Registers live out of .L77000714: 
! g4 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f14 f17 f20 f22 f26 f27 f29 f31 
		                       
! predecessor blocks: .L77000712 .L77000714

			.L900000317:
/* 0x01ec	 218 */		fmuld	%f54,%f46,%f40
/* 0x01f0	 217 */		fmuld	%f52,%f46,%f42
/* 0x01f4	 216 */		fdtos	%f38,%f22
/* 0x01f8	 204 */		add	%o2,1,%o2
/* 0x01fc	 216 */		add	%g4,%o5,%g3
/* 0x0200	     */		st	%f22,[%o5+%g4]
/* 0x0204	 218 */		fdtos	%f40,%f24
/* 0x0208	 204 */		cmp	%o2,%o0
/* 0x020c	 218 */		st	%f24,[%g3+8]
/* 0x0210	 217 */		fdtos	%f42,%f23
/* 0x0214	     */		st	%f23,[%g3+4]
/* 0x0218	 204 */		bcs,pt	%icc,.L900000316
/* 0x021c	 207 */		sll	%o2,2,%g2

! Registers live out of .L900000317: 
! g2 g5 o0 o1 o2 o4 o5 sp o7 fp gsr 
! f2 f4 f6 f8 f17 f26 f27 f29 f31 
		                       
! predecessor blocks: .L900000317

			.L900000308:
/* 0x0220	 228 */		retl	! Result = 
/* 0x0224	     */		nop

!  219		      !         }
!  220		      !      }
!  221		      !   }
!  222		      !   else {
!  223		      !      /* Just transform normals, don't scale */
!  224		      !      GLuint i;
!  225		      !      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8];
!  226		      !      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9];
!  227		      !      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10];
!  228		      !      for (i=0;i<n;i++) {

                       
! predecessor blocks: gl_xform_normals_3fv

			.L77000694:
/* 0x0228	 228 */		bleu,pn	%icc,.L77000705
/* 0x022c	     */		nop

! Registers live out of .L77000694: 
! o0 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000694

			.L77000710:
/* 0x0230	 225 */		ld	[%o2],%f22
/* 0x0234	 226 */		ld	[%o2+4],%f0
/* 0x0238	 227 */		ld	[%o2+8],%f4
/* 0x023c	 225 */		ld	[%o2+16],%f6
/* 0x0240	 226 */		ld	[%o2+20],%f18
/* 0x0244	 227 */		ld	[%o2+24],%f20
/* 0x0248	 225 */		ld	[%o2+32],%f24
/* 0x024c	 226 */		ld	[%o2+36],%f2
/* 0x0250	 225 */		cmp	%o0,2
/* 0x0254	 227 */		ld	[%o2+40],%f8
/* 0x0258	 225 */		bl,pn	%icc,.L77000763
/* 0x025c	 228 */		sethi	%hi(0x7ffffc00),%g5

! Registers live out of .L77000710: 
! g5 o0 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000710

			.L77000726:
/* 0x0260	 228 */		add	%g5,1022,%g3
/* 0x0264	     */		srl	%o0,0,%g4
/* 0x0268	     */		sub	%g4,%g3,%g2
/* 0x026c	     */		srlx	%g2,63,%g1
/* 0x0270	     */		andcc	%g1,1,%g0
/* 0x0274	     */		be,a,pn	%icc,.L77000722
/* 0x0278	     */		or	%g0,0,%g5

! Registers live out of .L77000726: 
! g5 o0 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		
!  229		      !         GLfloat ux = u[i][0],  uy = u[i][1],  uz = u[i][2];

                       
! predecessor blocks: .L77000726

			.L77000740:
/* 0x027c	 229 */		cmp	%o0,4
/* 0x0280	 228 */		add	%o0,-1,%o2
/* 0x0284	     */		or	%g0,0,%o1
/* 0x0288	 229 */		bl,pn	%icc,.L77000741
/* 0x028c	     */		nop

! Registers live out of .L77000740: 
! o1 o2 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000740

			.L900000312:
/* 0x0290	 229 */		sub	%o2,3,%o3

! Registers live out of .L900000312: 
! o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L900000310 .L900000312

			.L900000310:
/* 0x0294	 229 */		prefetch	[%o4+164],0
/* 0x0298	     */		prefetch	[%o5+164],2
/* 0x029c	 228 */		add	%o1,4,%o1
/* 0x02a0	 229 */		ld	[%o4],%f16
/* 0x02a4	 228 */		add	%o4,48,%o4
/* 0x02a8	     */		cmp	%o1,%o3
/* 0x02ac	     */		add	%o5,48,%o5
/* 0x02b0	 229 */		ld	[%o4-44],%f12

!  230		      !         v[i][0] = ux * m0 + uy * m1 + uz * m2;

/* 0x02b4	 230 */		fmuls	%f16,%f22,%f26
/* 0x02b8	     */		fmuls	%f12,%f0,%f10

!  231		      !         v[i][1] = ux * m4 + uy * m5 + uz * m6;

/* 0x02bc	 231 */		fmuls	%f16,%f6,%f14
/* 0x02c0	     */		fmuls	%f12,%f18,%f28

!  232		      !         v[i][2] = ux * m8 + uy * m9 + uz * m10;

/* 0x02c4	 232 */		fmuls	%f16,%f24,%f1
/* 0x02c8	 230 */		fadds	%f26,%f10,%f7
/* 0x02cc	 232 */		fmuls	%f12,%f2,%f30
/* 0x02d0	 229 */		ld	[%o4-40],%f3
/* 0x02d4	 231 */		fadds	%f14,%f28,%f13
/* 0x02d8	 230 */		fmuls	%f3,%f4,%f5
/* 0x02dc	 231 */		fmuls	%f3,%f20,%f11
/* 0x02e0	 232 */		fadds	%f1,%f30,%f19
/* 0x02e4	     */		fmuls	%f3,%f8,%f17
/* 0x02e8	 230 */		fadds	%f7,%f5,%f9
/* 0x02ec	     */		st	%f9,[%o5-48]
/* 0x02f0	 231 */		fadds	%f13,%f11,%f15
/* 0x02f4	     */		st	%f15,[%o5-44]
/* 0x02f8	 232 */		fadds	%f19,%f17,%f21
/* 0x02fc	     */		st	%f21,[%o5-40]
/* 0x0300	 229 */		ld	[%o4-36],%f23
/* 0x0304	     */		ld	[%o4-32],%f29
/* 0x0308	 230 */		fmuls	%f23,%f22,%f27
/* 0x030c	     */		fmuls	%f29,%f0,%f25
/* 0x0310	 231 */		fmuls	%f23,%f6,%f26
/* 0x0314	     */		fmuls	%f29,%f18,%f31
/* 0x0318	 232 */		fmuls	%f23,%f24,%f14
/* 0x031c	 230 */		fadds	%f27,%f25,%f16
/* 0x0320	 232 */		fmuls	%f29,%f2,%f28
/* 0x0324	 229 */		ld	[%o4-28],%f10
/* 0x0328	 231 */		fadds	%f26,%f31,%f3
/* 0x032c	 230 */		fmuls	%f10,%f4,%f30
/* 0x0330	 231 */		fmuls	%f10,%f20,%f12
/* 0x0334	 232 */		fadds	%f14,%f28,%f9
/* 0x0338	     */		fmuls	%f10,%f8,%f7
/* 0x033c	 230 */		fadds	%f16,%f30,%f1
/* 0x0340	     */		st	%f1,[%o5-36]
/* 0x0344	 231 */		fadds	%f3,%f12,%f5
/* 0x0348	     */		st	%f5,[%o5-32]
/* 0x034c	 232 */		fadds	%f9,%f7,%f11
/* 0x0350	     */		st	%f11,[%o5-28]
/* 0x0354	 229 */		ld	[%o4-24],%f15
/* 0x0358	     */		ld	[%o4-20],%f21
/* 0x035c	 230 */		fmuls	%f15,%f22,%f19
/* 0x0360	     */		fmuls	%f21,%f0,%f17
/* 0x0364	 231 */		fmuls	%f15,%f6,%f23
/* 0x0368	     */		fmuls	%f21,%f18,%f13
/* 0x036c	 232 */		fmuls	%f15,%f24,%f27
/* 0x0370	 230 */		fadds	%f19,%f17,%f26
/* 0x0374	 232 */		fmuls	%f21,%f2,%f25
/* 0x0378	 229 */		ld	[%o4-16],%f29
/* 0x037c	 231 */		fadds	%f23,%f13,%f16
/* 0x0380	 230 */		fmuls	%f29,%f4,%f31
/* 0x0384	 231 */		fmuls	%f29,%f20,%f30
/* 0x0388	 232 */		fadds	%f27,%f25,%f14
/* 0x038c	     */		fmuls	%f29,%f8,%f10
/* 0x0390	 230 */		fadds	%f26,%f31,%f28
/* 0x0394	     */		st	%f28,[%o5-24]
/* 0x0398	 231 */		fadds	%f16,%f30,%f1
/* 0x039c	     */		st	%f1,[%o5-20]
/* 0x03a0	 232 */		fadds	%f14,%f10,%f12
/* 0x03a4	     */		st	%f12,[%o5-16]
/* 0x03a8	 229 */		ld	[%o4-12],%f3
/* 0x03ac	     */		ld	[%o4-8],%f9
/* 0x03b0	 230 */		fmuls	%f3,%f22,%f7
/* 0x03b4	     */		fmuls	%f9,%f0,%f5
/* 0x03b8	 231 */		fmuls	%f3,%f6,%f17
/* 0x03bc	     */		fmuls	%f9,%f18,%f11
/* 0x03c0	 232 */		fmuls	%f3,%f24,%f15
/* 0x03c4	 230 */		fadds	%f7,%f5,%f25
/* 0x03c8	 232 */		fmuls	%f9,%f2,%f19
/* 0x03cc	 229 */		ld	[%o4-4],%f21
/* 0x03d0	 231 */		fadds	%f17,%f11,%f13
/* 0x03d4	 230 */		fmuls	%f21,%f4,%f23
/* 0x03d8	 231 */		fmuls	%f21,%f20,%f29
/* 0x03dc	 232 */		fadds	%f15,%f19,%f28
/* 0x03e0	     */		fmuls	%f21,%f8,%f26
/* 0x03e4	 230 */		fadds	%f25,%f23,%f27
/* 0x03e8	     */		st	%f27,[%o5-12]
/* 0x03ec	 231 */		fadds	%f13,%f29,%f31
/* 0x03f0	     */		st	%f31,[%o5-8]
/* 0x03f4	 232 */		fadds	%f28,%f26,%f30
/* 0x03f8	 228 */		ble,pt	%icc,.L900000310
/* 0x03fc	 232 */		st	%f30,[%o5-4]

! Registers live out of .L900000310: 
! o1 o2 o3 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L900000310

			.L900000313:
/* 0x0400	 228 */		cmp	%o1,%o2
/* 0x0404	     */		bg,pn	%icc,.L900000307
/* 0x0408	 229 */		nop

! Registers live out of .L900000313: 
! o1 o2 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000740 .L900000313

			.L77000741:
/* 0x040c	 229 */		ld	[%o4],%f1

! Registers live out of .L77000741: 
! o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000741 .L900000315

			.L900000315:
/* 0x0410	 229 */		ld	[%o4+4],%f16
/* 0x0414	 232 */		fmuls	%f1,%f24,%f12
/* 0x0418	 231 */		fmuls	%f1,%f6,%f7
/* 0x041c	 230 */		fmuls	%f1,%f22,%f10
/* 0x0420	 232 */		fmuls	%f16,%f2,%f3
/* 0x0424	 231 */		fmuls	%f16,%f18,%f14
/* 0x0428	 230 */		fmuls	%f16,%f0,%f9
/* 0x042c	 229 */		ld	[%o4+8],%f5
/* 0x0430	 228 */		add	%o1,1,%o1
/* 0x0434	     */		cmp	%o1,%o2
/* 0x0438	 232 */		fadds	%f12,%f3,%f19
/* 0x043c	     */		fmuls	%f5,%f8,%f11
/* 0x0440	 231 */		fmuls	%f5,%f20,%f21
/* 0x0444	     */		fadds	%f7,%f14,%f23
/* 0x0448	 230 */		fmuls	%f5,%f4,%f17
/* 0x044c	     */		fadds	%f10,%f9,%f27
/* 0x0450	 228 */		add	%o4,12,%o4
/* 0x0454	 232 */		fadds	%f19,%f11,%f15
/* 0x0458	     */		st	%f15,[%o5+8]
/* 0x045c	 231 */		fadds	%f23,%f21,%f25
/* 0x0460	     */		st	%f25,[%o5+4]
/* 0x0464	 230 */		fadds	%f27,%f17,%f29
/* 0x0468	     */		st	%f29,[%o5]
/* 0x046c	 228 */		add	%o5,12,%o5
/* 0x0470	     */		ble,a,pt	%icc,.L900000315
/* 0x0474	 229 */		ld	[%o4],%f1

! Registers live out of .L900000315: 
! o1 o2 o4 o5 sp o7 fp gsr 
! f0 f1 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L900000313 .L900000315

			.L900000307:
/* 0x0478	 228 */		retl	! Result = 
/* 0x047c	     */		nop
                       
! predecessor blocks: .L77000710

			.L77000763:
/* 0x0480	 228 */		or	%g0,0,%g5

! Registers live out of .L77000763: 
! g5 o0 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000726 .L77000763

			.L77000722:
/* 0x0484	 229 */		sll	%g5,2,%o3

! Registers live out of .L77000722: 
! g5 o0 o3 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000722 .L900000314

			.L900000314:
/* 0x0488	 229 */		sub	%o3,%g5,%o2
/* 0x048c	     */		sll	%o2,2,%g4
/* 0x0490	     */		add	%g4,%o4,%o1
/* 0x0494	     */		ld	[%o1],%f26
/* 0x0498	     */		ld	[%o1+4],%f31
/* 0x049c	     */		ld	[%o1+8],%f13
/* 0x04a0	 230 */		fmuls	%f26,%f22,%f30
/* 0x04a4	     */		fmuls	%f31,%f0,%f28
/* 0x04a8	 232 */		fmuls	%f31,%f2,%f1
/* 0x04ac	 231 */		fmuls	%f31,%f18,%f5
/* 0x04b0	 232 */		fmuls	%f26,%f24,%f3
/* 0x04b4	 231 */		fmuls	%f26,%f6,%f14
/* 0x04b8	 230 */		fmuls	%f13,%f4,%f16
/* 0x04bc	     */		fadds	%f30,%f28,%f7
/* 0x04c0	 232 */		fmuls	%f13,%f8,%f12
/* 0x04c4	 231 */		fmuls	%f13,%f20,%f15
/* 0x04c8	 232 */		fadds	%f3,%f1,%f11
/* 0x04cc	 231 */		fadds	%f14,%f5,%f10
/* 0x04d0	 228 */		add	%g5,1,%g5
/* 0x04d4	 230 */		fadds	%f7,%f16,%f9
/* 0x04d8	     */		add	%g4,%o5,%g3
/* 0x04dc	     */		st	%f9,[%o5+%g4]
/* 0x04e0	 232 */		fadds	%f11,%f12,%f19
/* 0x04e4	 228 */		cmp	%g5,%o0
/* 0x04e8	 232 */		st	%f19,[%g3+8]
/* 0x04ec	 231 */		fadds	%f10,%f15,%f21
/* 0x04f0	     */		st	%f21,[%g3+4]
/* 0x04f4	 228 */		bcs,pt	%icc,.L900000314
/* 0x04f8	 229 */		sll	%g5,2,%o3

! Registers live out of .L900000314: 
! g5 o0 o3 o4 o5 sp o7 fp gsr 
! f0 f2 f4 f6 f8 f18 f20 f22 f24 
		                       
! predecessor blocks: .L77000678 .L77000694 .L900000314

			.L77000705:
/* 0x04fc	 228 */		retl	! Result = 
/* 0x0500	     */		nop
/* 0x0504	   0 */		.type	gl_xform_normals_3fv,2
/* 0x0504	   0 */		.size	gl_xform_normals_3fv,(.-gl_xform_normals_3fv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  233		      !      }
!  234		      !   }
!  235		      !}
!  236		      !#endif
!  239		      !/*
!  240		      ! * Transform a 4-element row vector (1x4 matrix) by a 4x4 matrix.  This
!  241		      ! * function is used for transforming clipping plane equations and spotlight
!  242		      ! * directions.
!  243		      ! * Mathematically,  u = v * m.
!  244		      ! * Input:  v - input vector
!  245		      ! *         m - transformation matrix
!  246		      ! * Output:  u - transformed vector
!  247		      ! */
!  248		      !void gl_transform_vector( GLfloat u[4], const GLfloat v[4], const GLfloat m[16] )
!  249		      !{
!  250		      !   GLfloat v0=v[0], v1=v[1], v2=v[2], v3=v[3];

!
! SUBROUTINE gl_transform_vector
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_transform_vector
                       

			gl_transform_vector:
/* 000000	 250 */		ld	[%o1],%f8
/* 0x0004	     */		ld	[%o1+4],%f6
/* 0x0008	     */		ld	[%o1+8],%f5
/* 0x000c	     */		ld	[%o1+12],%f7

!  251		      !#define M(row,col)  m[col*4+row]
!  252		      !   u[0] = v0 * M(0,0) + v1 * M(1,0) + v2 * M(2,0) + v3 * M(3,0);

/* 0x0010	 252 */		ld	[%o2+4],%f4
/* 0x0014	     */		ld	[%o2],%f10
/* 0x0018	     */		ld	[%o2+12],%f2
/* 0x001c	     */		ld	[%o2+8],%f0
/* 0x0020	     */		fmuls	%f6,%f4,%f14
/* 0x0024	     */		fmuls	%f7,%f2,%f12
/* 0x0028	     */		fmuls	%f8,%f10,%f16
/* 0x002c	     */		fmuls	%f5,%f0,%f0
/* 0x0030	     */		fadds	%f16,%f14,%f20
/* 0x0034	     */		fadds	%f12,%f0,%f18
/* 0x0038	     */		fadds	%f20,%f18,%f22
/* 0x003c	     */		st	%f22,[%o0]

!  253		      !   u[1] = v0 * M(0,1) + v1 * M(1,1) + v2 * M(2,1) + v3 * M(3,1);

/* 0x0040	 253 */		ld	[%o2+24],%f24
/* 0x0044	     */		ld	[%o2+16],%f30
/* 0x0048	     */		ld	[%o2+20],%f26
/* 0x004c	     */		ld	[%o2+28],%f28
/* 0x0050	     */		fmuls	%f5,%f24,%f3
/* 0x0054	     */		fmuls	%f6,%f26,%f9
/* 0x0058	     */		fmuls	%f7,%f28,%f1
/* 0x005c	     */		fmuls	%f8,%f30,%f11
/* 0x0060	     */		fadds	%f1,%f3,%f13
/* 0x0064	     */		fadds	%f11,%f9,%f15
/* 0x0068	     */		fadds	%f15,%f13,%f17
/* 0x006c	     */		st	%f17,[%o0+4]

!  254		      !   u[2] = v0 * M(0,2) + v1 * M(1,2) + v2 * M(2,2) + v3 * M(3,2);

/* 0x0070	 254 */		ld	[%o2+40],%f19
/* 0x0074	     */		ld	[%o2+32],%f25
/* 0x0078	     */		ld	[%o2+36],%f21
/* 0x007c	     */		ld	[%o2+44],%f23
/* 0x0080	     */		fmuls	%f5,%f19,%f27
/* 0x0084	     */		fmuls	%f6,%f21,%f31
/* 0x0088	     */		fmuls	%f7,%f23,%f29
/* 0x008c	     */		fmuls	%f8,%f25,%f4
/* 0x0090	     */		fadds	%f29,%f27,%f2
/* 0x0094	     */		fadds	%f4,%f31,%f10
/* 0x0098	     */		fadds	%f10,%f2,%f0
/* 0x009c	     */		st	%f0,[%o0+8]

!  255		      !   u[3] = v0 * M(0,3) + v1 * M(1,3) + v2 * M(2,3) + v3 * M(3,3);

/* 0x00a0	 255 */		ld	[%o2+56],%f12
/* 0x00a4	     */		ld	[%o2+48],%f18
/* 0x00a8	     */		ld	[%o2+52],%f14
/* 0x00ac	     */		ld	[%o2+60],%f16
/* 0x00b0	     */		fmuls	%f5,%f12,%f20
/* 0x00b4	     */		fmuls	%f6,%f14,%f24
/* 0x00b8	     */		fmuls	%f7,%f16,%f22
/* 0x00bc	     */		fmuls	%f8,%f18,%f26
/* 0x00c0	     */		fadds	%f22,%f20,%f28
/* 0x00c4	     */		fadds	%f26,%f24,%f30
/* 0x00c8	     */		fadds	%f30,%f28,%f3
/* 0x00cc	     */		retl	! Result = 
/* 0x00d0	     */		st	%f3,[%o0+12]
/* 0x00d4	   0 */		.type	gl_transform_vector,2
/* 0x00d4	   0 */		.size	gl_transform_vector,(.-gl_transform_vector)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	58
/* 0x000c	   0 */		.word	188
/* 0x0010	   0 */		.word	20
/* 0x0014	   0 */		.word	93
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	101
/* 0x0024	   0 */		.word	65571
/* 0x0028	   0 */		.word	1
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.align	4
/* 0x0030	   0 */		.word	-1
/* 0x0034	   0 */		.word	-1
/* 0x0038	   0 */		.word	109
/* 0x003c	   0 */		.word	65571
/* 0x0040	   0 */		.word	1
/* 0x0044	   0 */		.word	1
/* 0x0048	   0 */		.align	4
/* 0x0048	   0 */		.word	-1
/* 0x004c	   0 */		.word	-1
/* 0x0050	   0 */		.word	122
/* 0x0054	   0 */		.word	65571
/* 0x0058	   0 */		.word	1
/* 0x005c	   0 */		.word	2
/* 0x0060	   0 */		.align	4
/* 0x0060	   0 */		.word	-1
/* 0x0064	   0 */		.word	-1
/* 0x0068	   0 */		.word	130
/* 0x006c	   0 */		.word	65571
/* 0x0070	   0 */		.word	1
/* 0x0074	   0 */		.word	3
/* 0x0078	   0 */		.align	4
/* 0x0078	   0 */		.word	-1
/* 0x007c	   0 */		.word	-1
/* 0x0080	   0 */		.word	101
/* 0x0084	   0 */		.word	4148
/* 0x0088	   0 */		.word	3
/* 0x008c	   0 */		.word	4
/* 0x0090	   0 */		.align	4
/* 0x0090	   0 */		.word	-1
/* 0x0094	   0 */		.word	-1
/* 0x0098	   0 */		.word	109
/* 0x009c	   0 */		.word	4148
/* 0x00a0	   0 */		.word	3
/* 0x00a4	   0 */		.word	7
/* 0x00a8	   0 */		.align	4
/* 0x00a8	   0 */		.word	-1
/* 0x00ac	   0 */		.word	-1
/* 0x00b0	   0 */		.word	122
/* 0x00b4	   0 */		.word	4148
/* 0x00b8	   0 */		.word	3
/* 0x00bc	   0 */		.word	10
/* 0x00c0	   0 */		.align	4
/* 0x00c0	   0 */		.word	-1
/* 0x00c4	   0 */		.word	-1
/* 0x00c8	   0 */		.word	130
/* 0x00cc	   0 */		.word	4148
/* 0x00d0	   0 */		.word	3
/* 0x00d4	   0 */		.word	13
/* 0x00d8	   0 */		.align	4
/* 0x00d8	   0 */		.word	-1
/* 0x00dc	   0 */		.word	-1
/* 0x00e0	   0 */		.word	109
/* 0x00e4	   0 */		.word	8218
/* 0x00e8	   0 */		.word	2
/* 0x00ec	   0 */		.word	16
/* 0x00f0	   0 */		.align	4
/* 0x00f0	   0 */		.word	-1
/* 0x00f4	   0 */		.word	-1
/* 0x00f8	   0 */		.word	109
/* 0x00fc	   0 */		.word	4122
/* 0x0100	   0 */		.word	2
/* 0x0104	   0 */		.word	18
/* 0x0108	   0 */		.align	4
/* 0x0108	   0 */		.word	-1
/* 0x010c	   0 */		.word	-1
/* 0x0110	   0 */		.word	109
/* 0x0114	   0 */		.word	4123
/* 0x0118	   0 */		.word	7
/* 0x011c	   0 */		.word	20
/* 0x0120	   0 */		.align	4
/* 0x0120	   0 */		.word	-1
/* 0x0124	   0 */		.word	-1
/* 0x0128	   0 */		.word	109
/* 0x012c	   0 */		.word	4145
/* 0x0130	   0 */		.word	7
/* 0x0134	   0 */		.word	27
/* 0x0138	   0 */		.align	4
/* 0x0138	   0 */		.word	-1
/* 0x013c	   0 */		.word	-1
/* 0x0140	   0 */		.word	101
/* 0x0144	   0 */		.word	8218
/* 0x0148	   0 */		.word	2
/* 0x014c	   0 */		.word	34
/* 0x0150	   0 */		.align	4
/* 0x0150	   0 */		.word	-1
/* 0x0154	   0 */		.word	-1
/* 0x0158	   0 */		.word	101
/* 0x015c	   0 */		.word	4122
/* 0x0160	   0 */		.word	2
/* 0x0164	   0 */		.word	36
/* 0x0168	   0 */		.align	4
/* 0x0168	   0 */		.word	-1
/* 0x016c	   0 */		.word	-1
/* 0x0170	   0 */		.word	101
/* 0x0174	   0 */		.word	4123
/* 0x0178	   0 */		.word	7
/* 0x017c	   0 */		.word	38
/* 0x0180	   0 */		.align	4
/* 0x0180	   0 */		.word	-1
/* 0x0184	   0 */		.word	-1
/* 0x0188	   0 */		.word	101
/* 0x018c	   0 */		.word	4145
/* 0x0190	   0 */		.word	7
/* 0x0194	   0 */		.word	45
/* 0x0198	   0 */		.align	4
/* 0x0198	   0 */		.word	-1
/* 0x019c	   0 */		.word	-1
/* 0x01a0	   0 */		.word	130
/* 0x01a4	   0 */		.word	8218
/* 0x01a8	   0 */		.word	2
/* 0x01ac	   0 */		.word	52
/* 0x01b0	   0 */		.align	4
/* 0x01b0	   0 */		.word	-1
/* 0x01b4	   0 */		.word	-1
/* 0x01b8	   0 */		.word	130
/* 0x01bc	   0 */		.word	4122
/* 0x01c0	   0 */		.word	2
/* 0x01c4	   0 */		.word	54
/* 0x01c8	   0 */		.align	4
/* 0x01c8	   0 */		.word	-1
/* 0x01cc	   0 */		.word	-1
/* 0x01d0	   0 */		.word	130
/* 0x01d4	   0 */		.word	4123
/* 0x01d8	   0 */		.word	7
/* 0x01dc	   0 */		.word	56
/* 0x01e0	   0 */		.align	4
/* 0x01e0	   0 */		.word	-1
/* 0x01e4	   0 */		.word	-1
/* 0x01e8	   0 */		.word	130
/* 0x01ec	   0 */		.word	4145
/* 0x01f0	   0 */		.word	7
/* 0x01f4	   0 */		.word	63
/* 0x01f8	   0 */		.align	4
/* 0x01f8	   0 */		.word	-1
/* 0x01fc	   0 */		.word	-1
/* 0x0200	   0 */		.word	122
/* 0x0204	   0 */		.word	8218
/* 0x0208	   0 */		.word	2
/* 0x020c	   0 */		.word	70
/* 0x0210	   0 */		.align	4
/* 0x0210	   0 */		.word	-1
/* 0x0214	   0 */		.word	-1
/* 0x0218	   0 */		.word	122
/* 0x021c	   0 */		.word	4122
/* 0x0220	   0 */		.word	2
/* 0x0224	   0 */		.word	72
/* 0x0228	   0 */		.align	4
/* 0x0228	   0 */		.word	-1
/* 0x022c	   0 */		.word	-1
/* 0x0230	   0 */		.word	122
/* 0x0234	   0 */		.word	4123
/* 0x0238	   0 */		.word	7
/* 0x023c	   0 */		.word	74
/* 0x0240	   0 */		.align	4
/* 0x0240	   0 */		.word	-1
/* 0x0244	   0 */		.word	-1
/* 0x0248	   0 */		.word	122
/* 0x024c	   0 */		.word	4145
/* 0x0250	   0 */		.word	7
/* 0x0254	   0 */		.word	81
/* 0x0258	   0 */		.align	4
/* 0x0258	   0 */		.word	-1
/* 0x025c	   0 */		.word	-1
/* 0x0260	   0 */		.word	122
/* 0x0264	   0 */		.word	8229
/* 0x0268	   0 */		.word	1
/* 0x026c	   0 */		.word	88
/* 0x0270	   0 */		.align	4
/* 0x0270	   0 */		.word	-1
/* 0x0274	   0 */		.word	-1
/* 0x0278	   0 */		.word	130
/* 0x027c	   0 */		.word	8229
/* 0x0280	   0 */		.word	1
/* 0x0284	   0 */		.word	89
/* 0x0288	   0 */		.align	4
/* 0x0288	   0 */		.word	-1
/* 0x028c	   0 */		.word	-1
/* 0x0290	   0 */		.word	101
/* 0x0294	   0 */		.word	8229
/* 0x0298	   0 */		.word	1
/* 0x029c	   0 */		.word	90
/* 0x02a0	   0 */		.align	4
/* 0x02a0	   0 */		.word	-1
/* 0x02a4	   0 */		.word	-1
/* 0x02a8	   0 */		.word	109
/* 0x02ac	   0 */		.word	8229
/* 0x02b0	   0 */		.word	1
/* 0x02b4	   0 */		.word	91
/* 0x02b8	   0 */		.align	4
/* 0x02b8	   0 */		.word	-1
/* 0x02bc	   0 */		.word	-1
/* 0x02c0	   0 */		.word	156
/* 0x02c4	   0 */		.word	65571
/* 0x02c8	   0 */		.word	1
/* 0x02cc	   0 */		.word	92
/* 0x02d0	   0 */		.align	4
/* 0x02d0	   0 */		.word	-1
/* 0x02d4	   0 */		.word	-1
/* 0x02d8	   0 */		.word	168
/* 0x02dc	   0 */		.word	65571
/* 0x02e0	   0 */		.word	1
/* 0x02e4	   0 */		.word	93
/* 0x02e8	   0 */		.align	4
/* 0x02e8	   0 */		.word	-1
/* 0x02ec	   0 */		.word	-1
/* 0x02f0	   0 */		.word	176
/* 0x02f4	   0 */		.word	65571
/* 0x02f8	   0 */		.word	1
/* 0x02fc	   0 */		.word	94
/* 0x0300	   0 */		.align	4
/* 0x0300	   0 */		.word	-1
/* 0x0304	   0 */		.word	-1
/* 0x0308	   0 */		.word	156
/* 0x030c	   0 */		.word	4148
/* 0x0310	   0 */		.word	3
/* 0x0314	   0 */		.word	95
/* 0x0318	   0 */		.align	4
/* 0x0318	   0 */		.word	-1
/* 0x031c	   0 */		.word	-1
/* 0x0320	   0 */		.word	168
/* 0x0324	   0 */		.word	4148
/* 0x0328	   0 */		.word	3
/* 0x032c	   0 */		.word	98
/* 0x0330	   0 */		.align	4
/* 0x0330	   0 */		.word	-1
/* 0x0334	   0 */		.word	-1
/* 0x0338	   0 */		.word	176
/* 0x033c	   0 */		.word	4148
/* 0x0340	   0 */		.word	3
/* 0x0344	   0 */		.word	101
/* 0x0348	   0 */		.align	4
/* 0x0348	   0 */		.word	-1
/* 0x034c	   0 */		.word	-1
/* 0x0350	   0 */		.word	156
/* 0x0354	   0 */		.word	8218
/* 0x0358	   0 */		.word	2
/* 0x035c	   0 */		.word	104
/* 0x0360	   0 */		.align	4
/* 0x0360	   0 */		.word	-1
/* 0x0364	   0 */		.word	-1
/* 0x0368	   0 */		.word	156
/* 0x036c	   0 */		.word	4122
/* 0x0370	   0 */		.word	2
/* 0x0374	   0 */		.word	106
/* 0x0378	   0 */		.align	4
/* 0x0378	   0 */		.word	-1
/* 0x037c	   0 */		.word	-1
/* 0x0380	   0 */		.word	156
/* 0x0384	   0 */		.word	4123
/* 0x0388	   0 */		.word	7
/* 0x038c	   0 */		.word	108
/* 0x0390	   0 */		.align	4
/* 0x0390	   0 */		.word	-1
/* 0x0394	   0 */		.word	-1
/* 0x0398	   0 */		.word	156
/* 0x039c	   0 */		.word	4145
/* 0x03a0	   0 */		.word	7
/* 0x03a4	   0 */		.word	115
/* 0x03a8	   0 */		.align	4
/* 0x03a8	   0 */		.word	-1
/* 0x03ac	   0 */		.word	-1
/* 0x03b0	   0 */		.word	176
/* 0x03b4	   0 */		.word	8218
/* 0x03b8	   0 */		.word	2
/* 0x03bc	   0 */		.word	122
/* 0x03c0	   0 */		.align	4
/* 0x03c0	   0 */		.word	-1
/* 0x03c4	   0 */		.word	-1
/* 0x03c8	   0 */		.word	176
/* 0x03cc	   0 */		.word	4122
/* 0x03d0	   0 */		.word	2
/* 0x03d4	   0 */		.word	124
/* 0x03d8	   0 */		.align	4
/* 0x03d8	   0 */		.word	-1
/* 0x03dc	   0 */		.word	-1
/* 0x03e0	   0 */		.word	176
/* 0x03e4	   0 */		.word	4123
/* 0x03e8	   0 */		.word	7
/* 0x03ec	   0 */		.word	126
/* 0x03f0	   0 */		.align	4
/* 0x03f0	   0 */		.word	-1
/* 0x03f4	   0 */		.word	-1
/* 0x03f8	   0 */		.word	176
/* 0x03fc	   0 */		.word	4145
/* 0x0400	   0 */		.word	7
/* 0x0404	   0 */		.word	133
/* 0x0408	   0 */		.align	4
/* 0x0408	   0 */		.word	-1
/* 0x040c	   0 */		.word	-1
/* 0x0410	   0 */		.word	168
/* 0x0414	   0 */		.word	8218
/* 0x0418	   0 */		.word	2
/* 0x041c	   0 */		.word	140
/* 0x0420	   0 */		.align	4
/* 0x0420	   0 */		.word	-1
/* 0x0424	   0 */		.word	-1
/* 0x0428	   0 */		.word	168
/* 0x042c	   0 */		.word	4122
/* 0x0430	   0 */		.word	2
/* 0x0434	   0 */		.word	142
/* 0x0438	   0 */		.align	4
/* 0x0438	   0 */		.word	-1
/* 0x043c	   0 */		.word	-1
/* 0x0440	   0 */		.word	168
/* 0x0444	   0 */		.word	4123
/* 0x0448	   0 */		.word	7
/* 0x044c	   0 */		.word	144
/* 0x0450	   0 */		.align	4
/* 0x0450	   0 */		.word	-1
/* 0x0454	   0 */		.word	-1
/* 0x0458	   0 */		.word	168
/* 0x045c	   0 */		.word	4145
/* 0x0460	   0 */		.word	7
/* 0x0464	   0 */		.word	151
/* 0x0468	   0 */		.align	4
/* 0x0468	   0 */		.word	-1
/* 0x046c	   0 */		.word	-1
/* 0x0470	   0 */		.word	168
/* 0x0474	   0 */		.word	8229
/* 0x0478	   0 */		.word	1
/* 0x047c	   0 */		.word	158
/* 0x0480	   0 */		.align	4
/* 0x0480	   0 */		.word	-1
/* 0x0484	   0 */		.word	-1
/* 0x0488	   0 */		.word	176
/* 0x048c	   0 */		.word	8229
/* 0x0490	   0 */		.word	1
/* 0x0494	   0 */		.word	159
/* 0x0498	   0 */		.align	4
/* 0x0498	   0 */		.word	-1
/* 0x049c	   0 */		.word	-1
/* 0x04a0	   0 */		.word	156
/* 0x04a4	   0 */		.word	8229
/* 0x04a8	   0 */		.word	1
/* 0x04ac	   0 */		.word	160
/* 0x04b0	   0 */		.align	4
/* 0x04b0	   0 */		.word	-1
/* 0x04b4	   0 */		.word	-1
/* 0x04b8	   0 */		.word	204
/* 0x04bc	   0 */		.word	65571
/* 0x04c0	   0 */		.word	1
/* 0x04c4	   0 */		.word	161
/* 0x04c8	   0 */		.align	4
/* 0x04c8	   0 */		.word	-1
/* 0x04cc	   0 */		.word	-1
/* 0x04d0	   0 */		.word	228
/* 0x04d4	   0 */		.word	65571
/* 0x04d8	   0 */		.word	1
/* 0x04dc	   0 */		.word	162
/* 0x04e0	   0 */		.align	4
/* 0x04e0	   0 */		.word	-1
/* 0x04e4	   0 */		.word	-1
/* 0x04e8	   0 */		.word	204
/* 0x04ec	   0 */		.word	4148
/* 0x04f0	   0 */		.word	3
/* 0x04f4	   0 */		.word	163
/* 0x04f8	   0 */		.align	4
/* 0x04f8	   0 */		.word	-1
/* 0x04fc	   0 */		.word	-1
/* 0x0500	   0 */		.word	228
/* 0x0504	   0 */		.word	4148
/* 0x0508	   0 */		.word	3
/* 0x050c	   0 */		.word	166
/* 0x0510	   0 */		.align	4
/* 0x0510	   0 */		.word	-1
/* 0x0514	   0 */		.word	-1
/* 0x0518	   0 */		.word	228
/* 0x051c	   0 */		.word	8218
/* 0x0520	   0 */		.word	2
/* 0x0524	   0 */		.word	169
/* 0x0528	   0 */		.align	4
/* 0x0528	   0 */		.word	-1
/* 0x052c	   0 */		.word	-1
/* 0x0530	   0 */		.word	228
/* 0x0534	   0 */		.word	4122
/* 0x0538	   0 */		.word	2
/* 0x053c	   0 */		.word	171
/* 0x0540	   0 */		.align	4
/* 0x0540	   0 */		.word	-1
/* 0x0544	   0 */		.word	-1
/* 0x0548	   0 */		.word	228
/* 0x054c	   0 */		.word	4123
/* 0x0550	   0 */		.word	7
/* 0x0554	   0 */		.word	173
/* 0x0558	   0 */		.align	4
/* 0x0558	   0 */		.word	-1
/* 0x055c	   0 */		.word	-1
/* 0x0560	   0 */		.word	228
/* 0x0564	   0 */		.word	4145
/* 0x0568	   0 */		.word	7
/* 0x056c	   0 */		.word	180
/* 0x0570	   0 */		.align	4
/* 0x0570	   0 */		.word	-1
/* 0x0574	   0 */		.word	-1
/* 0x0578	   0 */		.word	228
/* 0x057c	   0 */		.word	8229
/* 0x0580	   0 */		.word	1
/* 0x0584	   0 */		.word	187
/* 0x0588	   0 */		.word	8
/* 0x058c	   0 */		.word	11
/* 0x0590	   0 */		.word	14
/* 0x0594	   0 */		.word	17
/* 0x0598	   0 */		.word	8
/* 0x059c	   0 */		.word	20
/* 0x05a0	   0 */		.word	42
/* 0x05a4	   0 */		.word	11
/* 0x05a8	   0 */		.word	20
/* 0x05ac	   0 */		.word	46
/* 0x05b0	   0 */		.word	14
/* 0x05b4	   0 */		.word	20
/* 0x05b8	   0 */		.word	50
/* 0x05bc	   0 */		.word	17
/* 0x05c0	   0 */		.word	20
/* 0x05c4	   0 */		.word	54
/* 0x05c8	   0 */		.word	46
/* 0x05cc	   0 */		.word	19
/* 0x05d0	   0 */		.word	46
/* 0x05d4	   0 */		.word	4
/* 0x05d8	   0 */		.word	46
/* 0x05dc	   0 */		.word	4
/* 0x05e0	   0 */		.word	2
/* 0x05e4	   0 */		.word	2
/* 0x05e8	   0 */		.word	6
/* 0x05ec	   0 */		.word	8
/* 0x05f0	   0 */		.word	0
/* 0x05f4	   0 */		.word	46
/* 0x05f8	   0 */		.word	0
/* 0x05fc	   0 */		.word	0
/* 0x0600	   0 */		.word	4
/* 0x0604	   0 */		.word	0
/* 0x0608	   0 */		.word	0
/* 0x060c	   0 */		.word	0
/* 0x0610	   0 */		.word	42
/* 0x0614	   0 */		.word	15
/* 0x0618	   0 */		.word	42
/* 0x061c	   0 */		.word	4
/* 0x0620	   0 */		.word	42
/* 0x0624	   0 */		.word	3
/* 0x0628	   0 */		.word	2
/* 0x062c	   0 */		.word	2
/* 0x0630	   0 */		.word	4
/* 0x0634	   0 */		.word	6
/* 0x0638	   0 */		.word	0
/* 0x063c	   0 */		.word	42
/* 0x0640	   0 */		.word	0
/* 0x0644	   0 */		.word	0
/* 0x0648	   0 */		.word	4
/* 0x064c	   0 */		.word	0
/* 0x0650	   0 */		.word	0
/* 0x0654	   0 */		.word	0
/* 0x0658	   0 */		.word	54
/* 0x065c	   0 */		.word	19
/* 0x0660	   0 */		.word	54
/* 0x0664	   0 */		.word	4
/* 0x0668	   0 */		.word	54
/* 0x066c	   0 */		.word	4
/* 0x0670	   0 */		.word	2
/* 0x0674	   0 */		.word	2
/* 0x0678	   0 */		.word	6
/* 0x067c	   0 */		.word	8
/* 0x0680	   0 */		.word	0
/* 0x0684	   0 */		.word	54
/* 0x0688	   0 */		.word	0
/* 0x068c	   0 */		.word	0
/* 0x0690	   0 */		.word	4
/* 0x0694	   0 */		.word	0
/* 0x0698	   0 */		.word	0
/* 0x069c	   0 */		.word	0
/* 0x06a0	   0 */		.word	50
/* 0x06a4	   0 */		.word	15
/* 0x06a8	   0 */		.word	50
/* 0x06ac	   0 */		.word	4
/* 0x06b0	   0 */		.word	50
/* 0x06b4	   0 */		.word	4
/* 0x06b8	   0 */		.word	2
/* 0x06bc	   0 */		.word	2
/* 0x06c0	   0 */		.word	3
/* 0x06c4	   0 */		.word	4
/* 0x06c8	   0 */		.word	0
/* 0x06cc	   0 */		.word	50
/* 0x06d0	   0 */		.word	0
/* 0x06d4	   0 */		.word	0
/* 0x06d8	   0 */		.word	4
/* 0x06dc	   0 */		.word	0
/* 0x06e0	   0 */		.word	0
/* 0x06e4	   0 */		.word	0
/* 0x06e8	   0 */		.word	14
/* 0x06ec	   0 */		.word	17
/* 0x06f0	   0 */		.word	8
/* 0x06f4	   0 */		.word	11
/* 0x06f8	   0 */		.word	58
/* 0x06fc	   0 */		.word	61
/* 0x0700	   0 */		.word	64
/* 0x0704	   0 */		.word	58
/* 0x0708	   0 */		.word	20
/* 0x070c	   0 */		.word	67
/* 0x0710	   0 */		.word	61
/* 0x0714	   0 */		.word	20
/* 0x0718	   0 */		.word	71
/* 0x071c	   0 */		.word	64
/* 0x0720	   0 */		.word	20
/* 0x0724	   0 */		.word	75
/* 0x0728	   0 */		.word	67
/* 0x072c	   0 */		.word	17
/* 0x0730	   0 */		.word	67
/* 0x0734	   0 */		.word	4
/* 0x0738	   0 */		.word	67
/* 0x073c	   0 */		.word	3
/* 0x0740	   0 */		.word	2
/* 0x0744	   0 */		.word	2
/* 0x0748	   0 */		.word	6
/* 0x074c	   0 */		.word	6
/* 0x0750	   0 */		.word	0
/* 0x0754	   0 */		.word	67
/* 0x0758	   0 */		.word	0
/* 0x075c	   0 */		.word	0
/* 0x0760	   0 */		.word	4
/* 0x0764	   0 */		.word	0
/* 0x0768	   0 */		.word	0
/* 0x076c	   0 */		.word	0
/* 0x0770	   0 */		.word	75
/* 0x0774	   0 */		.word	17
/* 0x0778	   0 */		.word	75
/* 0x077c	   0 */		.word	4
/* 0x0780	   0 */		.word	75
/* 0x0784	   0 */		.word	3
/* 0x0788	   0 */		.word	2
/* 0x078c	   0 */		.word	2
/* 0x0790	   0 */		.word	6
/* 0x0794	   0 */		.word	6
/* 0x0798	   0 */		.word	0
/* 0x079c	   0 */		.word	75
/* 0x07a0	   0 */		.word	0
/* 0x07a4	   0 */		.word	0
/* 0x07a8	   0 */		.word	4
/* 0x07ac	   0 */		.word	0
/* 0x07b0	   0 */		.word	0
/* 0x07b4	   0 */		.word	0
/* 0x07b8	   0 */		.word	71
/* 0x07bc	   0 */		.word	14
/* 0x07c0	   0 */		.word	71
/* 0x07c4	   0 */		.word	4
/* 0x07c8	   0 */		.word	71
/* 0x07cc	   0 */		.word	3
/* 0x07d0	   0 */		.word	2
/* 0x07d4	   0 */		.word	2
/* 0x07d8	   0 */		.word	3
/* 0x07dc	   0 */		.word	3
/* 0x07e0	   0 */		.word	0
/* 0x07e4	   0 */		.word	71
/* 0x07e8	   0 */		.word	0
/* 0x07ec	   0 */		.word	0
/* 0x07f0	   0 */		.word	4
/* 0x07f4	   0 */		.word	0
/* 0x07f8	   0 */		.word	0
/* 0x07fc	   0 */		.word	0
/* 0x0800	   0 */		.word	61
/* 0x0804	   0 */		.word	64
/* 0x0808	   0 */		.word	58
/* 0x080c	   0 */		.word	79
/* 0x0810	   0 */		.word	82
/* 0x0814	   0 */		.word	79
/* 0x0818	   0 */		.word	20
/* 0x081c	   0 */		.word	85
/* 0x0820	   0 */		.word	82
/* 0x0824	   0 */		.word	20
/* 0x0828	   0 */		.word	89
/* 0x082c	   0 */		.word	89
/* 0x0830	   0 */		.word	17
/* 0x0834	   0 */		.word	89
/* 0x0838	   0 */		.word	4
/* 0x083c	   0 */		.word	89
/* 0x0840	   0 */		.word	3
/* 0x0844	   0 */		.word	3
/* 0x0848	   0 */		.word	2
/* 0x084c	   0 */		.word	6
/* 0x0850	   0 */		.word	9
/* 0x0854	   0 */		.word	0
/* 0x0858	   0 */		.word	89
/* 0x085c	   0 */		.word	0
/* 0x0860	   0 */		.word	0
/* 0x0864	   0 */		.word	4
/* 0x0868	   0 */		.word	0
/* 0x086c	   0 */		.word	0
/* 0x0870	   0 */		.word	0
/* 0x0874	   0 */		.word	82
/* 0x0878	   0 */		.asciz	"xform.c"
/* 0x0880	   0 */		.asciz	"L1"
/* 0x0883	   0 */		.asciz	"L2"
/* 0x0886	   0 */		.asciz	"L3"
/* 0x0889	   0 */		.asciz	"L4"
/* 0x088c	   0 */		.asciz	"improved-signed-index"
/* 0x08a2	   0 */		.asciz	"L14"
/* 0x08a6	   0 */		.asciz	"L16"
/* 0x08aa	   0 */		.asciz	"L10"
/* 0x08ae	   0 */		.asciz	"L12"
/* 0x08b2	   0 */		.asciz	"L5"
/* 0x08b5	   0 */		.asciz	"L6"
/* 0x08b8	   0 */		.asciz	"L7"
/* 0x08bb	   0 */		.asciz	"L20"
/* 0x08bf	   0 */		.asciz	"L22"
/* 0x08c3	   0 */		.asciz	"L18"
/* 0x08c7	   0 */		.asciz	"L8"
/* 0x08ca	   0 */		.asciz	"L9"
/* 0x08cd	   0 */		.asciz	"L24"
/* 0x08d1	   0 */		.asciz	"L26"

! Begin Disassembling Debug Info
!  Begin sdCreateSection : .debug_loc
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_loc"
!  End sdCreateSection
!  Begin sdCreateSection : .debug_info
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_abbrev, lab2=, loff=0
!   reloc[1]: knd=2, off=250, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=279, siz=4, lab1=gl_xform_points_4fv, lab2=, loff=0
!   reloc[3]: knd=0, off=283, siz=4, lab1=gl_xform_points_4fv, lab2=, loff=2728
!   reloc[4]: knd=0, off=954, siz=4, lab1=gl_xform_points_3fv, lab2=, loff=0
!   reloc[5]: knd=0, off=958, siz=4, lab1=gl_xform_points_3fv, lab2=, loff=1960
!   reloc[6]: knd=0, off=1490, siz=4, lab1=gl_xform_normals_3fv, lab2=, loff=0
!   reloc[7]: knd=0, off=1494, siz=4, lab1=gl_xform_normals_3fv, lab2=, loff=1284
!   reloc[8]: knd=0, off=2180, siz=4, lab1=gl_transform_vector, lab2=, loff=0
!   reloc[9]: knd=0, off=2184, siz=4, lab1=gl_transform_vector, lab2=, loff=212
	.section ".debug_info"
	.byte 0x00,0x00,0x09,0x20,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "xform.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  xform.c -W0,-xp\\$XAa59JCigJdL2Ps.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCigJdL2Ps.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_xform_points_4fv\0"
	.byte 0x01,0x02,0x01,0x5a
	.uaword gl_xform_points_4fv
	.uaword gl_xform_points_4fv+2728
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0x33
	.byte 0x03,0x00,0x00,0x03,0x3f
	.ascii "n\0"
	.byte 0x01,0x58,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x03,0x6e
	.ascii "q\0"
	.byte 0x01,0x58,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x03,0x86
	.ascii "m\0"
	.byte 0x01,0x58,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x03,0x9c
	.ascii "p\0"
	.byte 0x01,0x59,0x03,0x91,0xd0,0x00,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0x60,0x01
	.byte 0x53,0x04
	.ascii "m0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x61,0x02
	.byte 0x90,0x31,0x04
	.ascii "m4\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x61,0x02
	.byte 0x90,0x20,0x04
	.ascii "m8\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x61,0x02
	.byte 0x90,0x38,0x04
	.ascii "m12\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x61,0x02
	.byte 0x90,0x3a,0x04
	.ascii "m1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x62,0x02
	.byte 0x90,0x3c,0x04
	.ascii "m5\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x62,0x02
	.byte 0x90,0x3e,0x04
	.ascii "m9\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x62,0x02
	.byte 0x90,0x21,0x04
	.ascii "m13\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x62,0x02
	.byte 0x90,0x23,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x66,0x02
	.byte 0x90,0x33,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x66,0x02
	.byte 0x90,0x27,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x66,0x02
	.byte 0x90,0x39,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x6e,0x02
	.byte 0x90,0x3b,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x6e,0x02
	.byte 0x90,0x28,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x6e,0x02
	.byte 0x90,0x2e,0x04
	.ascii "p3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x6e,0x02
	.byte 0x90,0x27,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0x75,0x01
	.byte 0x53,0x04
	.ascii "m2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x76,0x02
	.byte 0x90,0x26,0x04
	.ascii "m6\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x76,0x02
	.byte 0x90,0x20,0x04
	.ascii "m10\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x76,0x02
	.byte 0x90,0x30,0x04
	.ascii "m14\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x76,0x02
	.byte 0x90,0x32,0x04
	.ascii "m3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x77,0x02
	.byte 0x90,0x24,0x04
	.ascii "m7\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x77,0x02
	.byte 0x90,0x34,0x04
	.ascii "m11\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x77,0x02
	.byte 0x90,0x22,0x04
	.ascii "m15\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x77,0x02
	.byte 0x90,0x36,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x7b,0x03
	.byte 0x91,0x98,0x7f,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x7b,0x03
	.byte 0x91,0x94,0x7f,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x7b,0x03
	.byte 0x91,0x90,0x7f,0x04
	.ascii "p3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x7b,0x02
	.byte 0x90,0x2b,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x83,0x02
	.byte 0x90,0x33,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x83,0x02
	.byte 0x90,0x28,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x83,0x02
	.byte 0x90,0x23,0x04
	.ascii "p3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x83,0x02
	.byte 0x90,0x31,0x05,0x44,0x01,0x18,0x00,0x06
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x07,0x00,0x00,0x03,0x33
	.ascii "GLuint\0"
	.byte 0x02,0x06
	.ascii "float\0"
	.byte 0x04,0x04,0x06
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x03,0x4c,0x10
	.byte 0x00,0x00,0x03,0x6e,0x09,0x00,0x00,0x03
	.byte 0x55,0x03,0x00,0x0a,0x00,0x00,0x03,0x5d
	.byte 0x07,0x00,0x00,0x03,0x4c
	.ascii "GLfloat\0"
	.byte 0x02,0x0b,0x00,0x00,0x03,0x73,0x0a,0x00
	.byte 0x00,0x03,0x81,0x08,0x00,0x00,0x03,0x4c
	.byte 0x10,0x00,0x00,0x03,0x9c,0x09,0x00,0x00
	.byte 0x03,0x55,0x03,0x00,0x0a,0x00,0x00,0x03
	.byte 0x8b,0x02
	.ascii "gl_xform_points_3fv\0"
	.byte 0x01,0x02,0x01,0x93
	.uaword gl_xform_points_3fv
	.uaword gl_xform_points_3fv+1960
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x05,0x82
	.byte 0x03,0x00,0x00,0x03,0x3f
	.ascii "n\0"
	.byte 0x01,0x91,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x05,0x93
	.ascii "q\0"
	.byte 0x01,0x91,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x05,0x9d
	.ascii "m\0"
	.byte 0x01,0x91,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x05,0xb3
	.ascii "p\0"
	.byte 0x01,0x92,0x03,0x91,0xd0,0x00,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0x99,0x01
	.byte 0x53,0x04
	.ascii "m0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9a,0x02
	.byte 0x90,0x38,0x04
	.ascii "m4\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9a,0x02
	.byte 0x90,0x21,0x04
	.ascii "m8\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9a,0x02
	.byte 0x90,0x23,0x04
	.ascii "m12\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9a,0x02
	.byte 0x90,0x25,0x04
	.ascii "m1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9b,0x02
	.byte 0x90,0x3a,0x04
	.ascii "m5\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9b,0x02
	.byte 0x90,0x3e,0x04
	.ascii "m9\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9b,0x02
	.byte 0x90,0x3c,0x04
	.ascii "m13\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9b,0x02
	.byte 0x90,0x27,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9d,0x02
	.byte 0x90,0x3d,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9d,0x02
	.byte 0x90,0x3f,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0x9d,0x02
	.byte 0x90,0x22,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0xa3,0x01
	.byte 0x53,0x04
	.ascii "m2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa4,0x02
	.byte 0x90,0x24,0x04
	.ascii "m6\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa4,0x02
	.byte 0x90,0x34,0x04
	.ascii "m10\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa4,0x02
	.byte 0x90,0x26,0x04
	.ascii "m14\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa4,0x02
	.byte 0x90,0x30,0x04
	.ascii "m3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa5,0x02
	.byte 0x90,0x20,0x04
	.ascii "m7\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa5,0x02
	.byte 0x90,0x32,0x04
	.ascii "m11\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa5,0x02
	.byte 0x90,0x22,0x04
	.ascii "m15\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa5,0x02
	.byte 0x90,0x36,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa9,0x03
	.byte 0x91,0xa8,0x7f,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa9,0x03
	.byte 0x91,0xa4,0x7f,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xa9,0x03
	.byte 0x91,0xa0,0x7f,0x04
	.ascii "p0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xb1,0x02
	.byte 0x90,0x2f,0x04
	.ascii "p1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xb1,0x02
	.byte 0x90,0x31,0x04
	.ascii "p2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xb1,0x02
	.byte 0x90,0x37,0x05,0x44,0x01,0x04,0x00,0x08
	.byte 0x00,0x00,0x03,0x4c,0x10,0x00,0x00,0x05
	.byte 0x93,0x09,0x00,0x00,0x03,0x55,0x03,0x00
	.byte 0x0a,0x00,0x00,0x05,0x82,0x0b,0x00,0x00
	.byte 0x03,0x73,0x0a,0x00,0x00,0x05,0x98,0x08
	.byte 0x00,0x00,0x03,0x4c,0x0c,0x00,0x00,0x05
	.byte 0xb3,0x09,0x00,0x00,0x03,0x55,0x02,0x00
	.byte 0x0a,0x00,0x00,0x05,0xa2,0x02
	.ascii "gl_xform_normals_3fv\0"
	.byte 0x01,0x02,0x01,0xc5
	.uaword gl_xform_normals_3fv
	.uaword gl_xform_normals_3fv+1284
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x07,0xfb
	.byte 0x03,0x00,0x00,0x03,0x3f
	.ascii "n\0"
	.byte 0x01,0xc3,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x08,0x0c
	.ascii "v\0"
	.byte 0x01,0xc3,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x08,0x16
	.ascii "m\0"
	.byte 0x01,0xc3,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x08,0x2c
	.ascii "u\0"
	.byte 0x01,0xc4,0x01,0x5c,0x03,0x00,0x00,0x08
	.byte 0x42
	.ascii "normalize\0"
	.byte 0x01,0xc4,0x03,0x91,0xd7,0x00,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0xc8,0x01
	.byte 0x5a,0x04
	.ascii "m0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xc9,0x02
	.byte 0x90,0x3a,0x04
	.ascii "m4\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xc9,0x02
	.byte 0x90,0x28,0x04
	.ascii "m8\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xc9,0x02
	.byte 0x90,0x3f,0x04
	.ascii "m1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xca,0x02
	.byte 0x90,0x26,0x04
	.ascii "m5\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xca,0x02
	.byte 0x90,0x3d,0x04
	.ascii "m9\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xca,0x02
	.byte 0x90,0x24,0x04
	.ascii "m2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcb,0x02
	.byte 0x90,0x3b,0x04
	.ascii "m6\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcb,0x02
	.byte 0x90,0x22,0x04
	.ascii "m10\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcb,0x02
	.byte 0x90,0x31,0x04
	.ascii "tx\0"
	.byte 0x00,0x00,0x08,0x5c,0x01,0x01,0xcd,0x08
	.byte 0x90,0x32,0x93,0x04,0x90,0x33,0x93,0x04
	.byte 0x04
	.ascii "ty\0"
	.byte 0x00,0x00,0x08,0x5c,0x01,0x01,0xcd,0x08
	.byte 0x90,0x34,0x93,0x04,0x90,0x35,0x93,0x04
	.byte 0x04
	.ascii "tz\0"
	.byte 0x00,0x00,0x08,0x5c,0x01,0x01,0xcd,0x08
	.byte 0x90,0x36,0x93,0x04,0x90,0x37,0x93,0x04
	.byte 0x04
	.ascii "ux\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcf,0x02
	.byte 0x90,0x32,0x04
	.ascii "uy\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcf,0x02
	.byte 0x90,0x39,0x04
	.ascii "uz\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xcf,0x02
	.byte 0x90,0x21,0x04
	.ascii "len\0"
	.byte 0x00,0x00,0x08,0x5c,0x01,0x01,0xd5,0x08
	.byte 0x90,0x22,0x93,0x04,0x90,0x23,0x93,0x04
	.byte 0x04
	.ascii "scale\0"
	.byte 0x00,0x00,0x08,0x5c,0x01,0x01,0xd5,0x03
	.byte 0x91,0xa0,0x7f,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x03,0x3f,0x01,0x01,0xe0,0x01
	.byte 0x55,0x04
	.ascii "m0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe1,0x02
	.byte 0x90,0x36,0x04
	.ascii "m4\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe1,0x02
	.byte 0x90,0x26,0x04
	.ascii "m8\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe1,0x02
	.byte 0x90,0x38,0x04
	.ascii "m1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe2,0x02
	.byte 0x90,0x20,0x04
	.ascii "m5\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe2,0x02
	.byte 0x90,0x32,0x04
	.ascii "m9\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe2,0x02
	.byte 0x90,0x22,0x04
	.ascii "m2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe3,0x02
	.byte 0x90,0x24,0x04
	.ascii "m6\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe3,0x02
	.byte 0x90,0x34,0x04
	.ascii "m10\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe3,0x02
	.byte 0x90,0x28,0x04
	.ascii "ux\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe5,0x02
	.byte 0x90,0x23,0x04
	.ascii "uy\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe5,0x02
	.byte 0x90,0x29,0x04
	.ascii "uz\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xe5,0x02
	.byte 0x90,0x35,0x05,0x44,0x01,0x0c,0x00,0x08
	.byte 0x00,0x00,0x03,0x4c,0x0c,0x00,0x00,0x08
	.byte 0x0c,0x09,0x00,0x00,0x03,0x55,0x02,0x00
	.byte 0x0a,0x00,0x00,0x07,0xfb,0x0b,0x00,0x00
	.byte 0x03,0x73,0x0a,0x00,0x00,0x08,0x11,0x08
	.byte 0x00,0x00,0x03,0x4c,0x0c,0x00,0x00,0x08
	.byte 0x2c,0x09,0x00,0x00,0x03,0x55,0x02,0x00
	.byte 0x0a,0x00,0x00,0x08,0x1b,0x06
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x07,0x00,0x00,0x08,0x31
	.ascii "GLboolean\0"
	.byte 0x02,0x06
	.ascii "double\0"
	.byte 0x04,0x08,0x07,0x00,0x00,0x08,0x52
	.ascii "GLdouble\0"
	.byte 0x02,0x02
	.ascii "gl_transform_vector\0"
	.byte 0x01,0x02,0x01,0xf9
	.uaword gl_transform_vector
	.uaword gl_transform_vector+212
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x08,0xf4
	.byte 0x03,0x00,0x00,0x08,0xf4
	.ascii "u\0"
	.byte 0x01,0xf8,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x08,0xfe
	.ascii "v\0"
	.byte 0x01,0xf8,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x09,0x08
	.ascii "m\0"
	.byte 0x01,0xf8,0x03,0x91,0xcc,0x00,0x04
	.ascii "v0\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xfa,0x02
	.byte 0x90,0x28,0x04
	.ascii "v1\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xfa,0x02
	.byte 0x90,0x26,0x04
	.ascii "v2\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xfa,0x02
	.byte 0x90,0x25,0x04
	.ascii "v3\0"
	.byte 0x00,0x00,0x03,0x73,0x01,0x01,0xfa,0x02
	.byte 0x90,0x27,0x00,0x0a,0x00,0x00,0x03,0x73
	.byte 0x0b,0x00,0x00,0x03,0x73,0x0a,0x00,0x00
	.byte 0x08,0xf9,0x0b,0x00,0x00,0x03,0x73,0x0a
	.byte 0x00,0x00,0x09,0x03,0x0c
	.ascii "sqrt\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x08,0x52,0x01
	.byte 0x0d,0x00,0x00,0x08,0x52,0x00,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=95, siz=4, lab1=gl_xform_points_4fv, lab2=, loff=0
!   reloc[1]: knd=0, off=935, siz=4, lab1=gl_xform_points_3fv, lab2=, loff=0
!   reloc[2]: knd=0, off=1576, siz=4, lab1=gl_xform_normals_3fv, lab2=, loff=0
!   reloc[3]: knd=0, off=2112, siz=4, lab1=gl_transform_vector, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x08,0x4e,0x00,0x02,0x00,0x00
	.byte 0x00,0x52,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x78,0x66,0x6f,0x72,0x6d,0x2e,0x63,0x00
	.byte 0x01,0x00,0x00,0x67,0x6c,0x2e,0x68,0x00
	.byte 0x02,0x00,0x00,0x00,0x00,0x05,0x02
	.uaword gl_xform_points_4fv
	.byte 0x06,0x03,0xe2,0x00,0x01,0x02,0x01,0x03
	.byte 0x7e,0x01,0x10,0x10,0x17,0x15,0x02,0x02
	.byte 0x03,0x13,0x01,0x02,0x01,0x03,0x69,0x01
	.byte 0x10,0x0e,0x10,0x0e,0x14,0x0e,0x02,0x01
	.byte 0x03,0x04,0x01,0x2c,0x0e,0x18,0x32,0x10
	.byte 0x0e,0x18,0x10,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x14,0x12,0x14,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x14,0x12,0x14,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x14,0x12,0x14,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x14,0x12,0x14,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x01,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7e,0x01,0x16,0x10,0x12,0x10
	.byte 0x19,0x0e,0x10,0x0e,0x0e,0x0e,0x02,0x02
	.byte 0x03,0x03,0x01,0x12,0x02,0x02,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x12,0x02
	.byte 0x02,0x03,0x7e,0x01,0x14,0x02,0x02,0x03
	.byte 0x11,0x01,0x02,0x01,0x03,0x6e,0x01,0x10
	.byte 0x20,0x14,0x12,0x10,0x02,0x01,0x03,0x7d
	.byte 0x01,0x11,0x14,0x02,0x01,0x03,0x7d,0x01
	.byte 0x11,0x14,0x02,0x02,0x03,0x7d,0x01,0x10
	.byte 0x02,0x02,0x03,0x11,0x01,0x02,0x01,0x03
	.byte 0x76,0x01,0x02,0x02,0x03,0x0b,0x01,0x02
	.byte 0x01,0x03,0x69,0x01,0x10,0x0e,0x10,0x0e
	.byte 0x14,0x0e,0x02,0x01,0x03,0x0c,0x01,0x2c
	.byte 0x0e,0x1c,0x1e,0x10,0x0e,0x19,0x0e,0x11
	.byte 0x0e,0x0e,0x11,0x0e,0x0e,0x11,0x0e,0x14
	.byte 0x12,0x10,0x0e,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x0e,0x11,0x0e,0x0e,0x11,0x0e
	.byte 0x0e,0x11,0x0e,0x14,0x12,0x10,0x0e,0x14
	.byte 0x02,0x02,0x03,0x7e,0x01,0x10,0x0e,0x11
	.byte 0x0e,0x0e,0x11,0x0e,0x0e,0x11,0x0e,0x14
	.byte 0x12,0x10,0x0e,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x10,0x0e,0x11,0x0e,0x0e,0x11,0x0e
	.byte 0x0e,0x11,0x0e,0x14,0x12,0x10,0x0e,0x14
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7d,0x01,0x14
	.byte 0x21,0x0e,0x10,0x0e,0x10,0x12,0x02,0x02
	.byte 0x03,0x7e,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x12,0x02,0x02,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x12,0x02,0x02,0x03,0x7e
	.byte 0x01,0x14,0x02,0x02,0x03,0x09,0x01,0x02
	.byte 0x01,0x03,0x76,0x01,0x10,0x24,0x1c,0x1a
	.byte 0x02,0x02,0x03,0x7e,0x01,0x11,0x10,0x02
	.byte 0x02,0x03,0x7d,0x01,0x11,0x14,0x02,0x02
	.byte 0x03,0x7d,0x01,0x10,0x02,0x01,0x03,0x09
	.byte 0x01,0x10,0x0e,0x18,0x02,0x01,0x03,0x0a
	.byte 0x01,0x02,0x01,0x03,0x76,0x01,0x02,0x02
	.byte 0x03,0x0a,0x01,0x02,0x01,0x03,0x76,0x01
	.byte 0x25,0x02,0x02,0x03,0x7c,0x01,0x02,0x07
	.byte 0x03,0x04,0x01,0x18,0x02,0x01,0x03,0x7b
	.byte 0x01,0x02,0x02,0x03,0x05,0x01,0x0e,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x04,0x03,0x05
	.byte 0x01,0x26,0x11,0x02,0x01,0x03,0x7e,0x01
	.byte 0x19,0x12,0x10,0x14,0x0e,0x2e,0x10,0x14
	.byte 0x0e,0x2e,0x10,0x14,0x0e,0x2e,0x10,0x14
	.byte 0x0e,0x02,0x05,0x03,0x7e,0x01,0x11,0x02
	.byte 0x01,0x03,0x7e,0x01,0x10,0x12,0x10,0x10
	.byte 0x0e,0x10,0x02,0x06,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x11,0x02,0x01,0x03,0x7e,0x01,0x11
	.byte 0x02,0x03,0x03,0x7e,0x01,0x15,0x02,0x01
	.byte 0x03,0x06,0x01,0x02,0x02,0x03,0x74,0x01
	.byte 0x02,0x03,0x03,0x04,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x02,0x02,0x03,0x05,0x01,0x02
	.byte 0x01,0x03,0x7b,0x01,0x02,0x03,0x03,0x04
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x02,0x01
	.byte 0x03,0x05,0x01,0x14,0x0e,0x10,0x02,0x07
	.byte 0x03,0x7e,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x0e,0x02,0x04,0x03,0x7e,0x01,0x10,0x02
	.byte 0x01,0x03,0x07,0x01,0x02,0x04,0x03,0x74
	.byte 0x01,0x02,0x07,0x03,0x0c,0x01,0x02,0x03
	.byte 0x03,0x74,0x01,0x02,0x02,0x03,0x0d,0x01
	.byte 0x02,0x01,0x03,0x73,0x01,0x02,0x01,0x03
	.byte 0x0c,0x01,0x02,0x01,0x03,0x74,0x01,0x02
	.byte 0x02,0x03,0x0d,0x01,0x1e,0x10,0x0e,0x19
	.byte 0x0e,0x11,0x0e,0x0e,0x11,0x0e,0x0e,0x11
	.byte 0x0e,0x14,0x12,0x10,0x0e,0x14,0x02,0x02
	.byte 0x03,0x7e,0x01,0x10,0x0e,0x11,0x0e,0x0e
	.byte 0x11,0x0e,0x0e,0x11,0x0e,0x14,0x12,0x10
	.byte 0x0e,0x14,0x02,0x02,0x03,0x7e,0x01,0x10
	.byte 0x0e,0x11,0x0e,0x0e,0x11,0x0e,0x0e,0x11
	.byte 0x0e,0x14,0x12,0x10,0x0e,0x14,0x02,0x02
	.byte 0x03,0x7e,0x01,0x10,0x0e,0x11,0x0e,0x0e
	.byte 0x11,0x0e,0x0e,0x11,0x0e,0x14,0x12,0x10
	.byte 0x0e,0x14,0x02,0x01,0x03,0x7d,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x14,0x21,0x0e,0x10,0x0e,0x10,0x12
	.byte 0x02,0x02,0x03,0x7e,0x01,0x02,0x02,0x03
	.byte 0x03,0x01,0x12,0x02,0x02,0x03,0x7e,0x01
	.byte 0x02,0x01,0x03,0x03,0x01,0x12,0x02,0x02
	.byte 0x03,0x7e,0x01,0x14,0x0e,0x02,0x02,0x03
	.byte 0x74,0x01,0x02,0x03,0x03,0x0c,0x01,0x02
	.byte 0x01,0x03,0x74,0x01,0x02,0x02,0x03,0x0d
	.byte 0x01,0x02,0x01,0x03,0x73,0x01,0x02,0x03
	.byte 0x03,0x0c,0x01,0x02,0x01,0x03,0x74,0x01
	.byte 0x02,0x01,0x03,0x0d,0x01,0x25,0x0e,0x10
	.byte 0x16,0x1c,0x02,0x02,0x03,0x7d,0x01,0x11
	.byte 0x02,0x02,0x03,0x7e,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x12,0x02,0x02,0x03,0x7e,0x01
	.byte 0x10,0x0e,0x02,0x02,0x03,0x76,0x01,0x02
	.byte 0x03,0x03,0x0a,0x01,0x02,0x02,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_xform_points_3fv
	.byte 0x06,0x02,0x01,0x03,0x9b,0x01,0x01,0x02
	.byte 0x01,0x03,0x0a,0x01,0x02,0x01,0x03,0x74
	.byte 0x01,0x10,0x0e,0x10,0x0e,0x10,0x0e,0x14
	.byte 0x0e,0x15,0x2c,0x0e,0x1c,0x1e,0x14,0x0e
	.byte 0x10,0x0e,0x11,0x0e,0x10,0x14,0x12,0x10
	.byte 0x0e,0x10,0x12,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x14,0x0e,0x10,0x14,0x12,0x10,0x0e
	.byte 0x10,0x12,0x14,0x02,0x02,0x03,0x7e,0x01
	.byte 0x14,0x0e,0x10,0x14,0x12,0x10,0x0e,0x10
	.byte 0x12,0x14,0x02,0x02,0x03,0x7e,0x01,0x14
	.byte 0x0e,0x10,0x14,0x12,0x10,0x0e,0x10,0x12
	.byte 0x14,0x02,0x01,0x03,0x7d,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7d,0x01
	.byte 0x14,0x1d,0x0e,0x10,0x0e,0x10,0x0e,0x02
	.byte 0x01,0x03,0x7e,0x01,0x02,0x02,0x03,0x03
	.byte 0x01,0x0e,0x10,0x0e,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x12,0x02
	.byte 0x02,0x03,0x7e,0x01,0x14,0x0e,0x02,0x01
	.byte 0x03,0x0a,0x01,0x02,0x01,0x03,0x76,0x01
	.byte 0x10,0x28,0x18,0x16,0x02,0x03,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x12,0x02
	.byte 0x01,0x03,0x7e,0x01,0x11,0x14,0x02,0x02
	.byte 0x03,0x7d,0x01,0x10,0x02,0x01,0x03,0x09
	.byte 0x01,0x0e,0x18,0x0e,0x10,0x02,0x01,0x03
	.byte 0x0a,0x01,0x02,0x01,0x03,0x76,0x01,0x02
	.byte 0x02,0x03,0x0a,0x01,0x02,0x01,0x03,0x76
	.byte 0x01,0x25,0x02,0x02,0x03,0x7c,0x01,0x02
	.byte 0x07,0x03,0x04,0x01,0x19,0x02,0x01,0x03
	.byte 0x7a,0x01,0x02,0x02,0x03,0x06,0x01,0x02
	.byte 0x01,0x03,0x7a,0x01,0x02,0x03,0x03,0x04
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x02,0x01
	.byte 0x03,0x06,0x01,0x02,0x07,0x03,0x7e,0x01
	.byte 0x15,0x02,0x01,0x03,0x7e,0x01,0x11,0x02
	.byte 0x01,0x03,0x7e,0x01,0x11,0x24,0x0e,0x34
	.byte 0x0e,0x34,0x0e,0x34,0x0e,0x02,0x01,0x03
	.byte 0x7e,0x01,0x11,0x02,0x01,0x03,0x7e,0x01
	.byte 0x11,0x02,0x02,0x03,0x7e,0x01,0x11,0x02
	.byte 0x07,0x03,0x7e,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x15,0x02
	.byte 0x04,0x03,0x7e,0x01,0x15,0x02,0x01,0x03
	.byte 0x06,0x01,0x02,0x02,0x03,0x74,0x01,0x02
	.byte 0x03,0x03,0x04,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x02,0x03,0x06,0x01,0x02,0x01
	.byte 0x03,0x7a,0x01,0x02,0x03,0x03,0x04,0x01
	.byte 0x02,0x01,0x03,0x7c,0x01,0x02,0x01,0x03
	.byte 0x06,0x01,0x02,0x0b,0x03,0x7e,0x01,0x11
	.byte 0x02,0x01,0x03,0x7e,0x01,0x11,0x14,0x0e
	.byte 0x02,0x02,0x03,0x7e,0x01,0x11,0x02,0x01
	.byte 0x03,0x06,0x01,0x02,0x04,0x03,0x74,0x01
	.byte 0x02,0x07,0x03,0x0c,0x01,0x02,0x03,0x03
	.byte 0x74,0x01,0x02,0x02,0x03,0x0d,0x01,0x02
	.byte 0x01,0x03,0x73,0x01,0x02,0x01,0x03,0x0c
	.byte 0x01,0x02,0x01,0x03,0x74,0x01,0x02,0x02
	.byte 0x03,0x0d,0x01,0x1e,0x14,0x0e,0x10,0x0e
	.byte 0x11,0x0e,0x10,0x14,0x12,0x10,0x0e,0x10
	.byte 0x12,0x14,0x02,0x02,0x03,0x7e,0x01,0x14
	.byte 0x0e,0x10,0x14,0x12,0x10,0x0e,0x10,0x12
	.byte 0x14,0x02,0x02,0x03,0x7e,0x01,0x14,0x0e
	.byte 0x10,0x14,0x12,0x10,0x0e,0x10,0x12,0x14
	.byte 0x02,0x02,0x03,0x7e,0x01,0x14,0x0e,0x10
	.byte 0x14,0x12,0x10,0x0e,0x10,0x12,0x14,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x14,0x1d
	.byte 0x0e,0x10,0x0e,0x10,0x0e,0x02,0x01,0x03
	.byte 0x7e,0x01,0x02,0x02,0x03,0x03,0x01,0x0e
	.byte 0x10,0x0e,0x02,0x01,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x12,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x0e,0x02,0x02,0x03,0x74
	.byte 0x01,0x02,0x03,0x03,0x0c,0x01,0x02,0x01
	.byte 0x03,0x74,0x01,0x02,0x02,0x03,0x0d,0x01
	.byte 0x02,0x01,0x03,0x73,0x01,0x02,0x03,0x03
	.byte 0x0c,0x01,0x02,0x01,0x03,0x74,0x01,0x02
	.byte 0x01,0x03,0x0d,0x01,0x29,0x0e,0x10,0x0e
	.byte 0x10,0x0e,0x02,0x02,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x0e,0x10,0x0e,0x02
	.byte 0x02,0x03,0x7e,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x12,0x02,0x02,0x03,0x7e,0x01,0x10
	.byte 0x0e,0x02,0x02,0x03,0x76,0x01,0x1a,0x10
	.byte 0x02,0x03,0x03,0x0a,0x01,0x02,0x02,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_xform_normals_3fv
	.byte 0x06,0x03,0xc4,0x01,0x01,0x18,0x02,0x01
	.byte 0x03,0x06,0x01,0x02,0x03,0x03,0x7d,0x01
	.byte 0x10,0x10,0x02,0x01,0x03,0x7e,0x01,0x10
	.byte 0x10,0x02,0x01,0x03,0x7e,0x01,0x10,0x0e
	.byte 0x15,0x02,0x01,0x03,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x09,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x11,0x0e,0x10,0x0e,0x0e,0x02
	.byte 0x01,0x03,0x03,0x01,0x12,0x12,0x15,0x02
	.byte 0x02,0x03,0x05,0x01,0x02,0x01,0x03,0x7a
	.byte 0x01,0x0e,0x11,0x02,0x01,0x03,0x04,0x01
	.byte 0x02,0x01,0x03,0x7b,0x01,0x02,0x01,0x03
	.byte 0x05,0x01,0x02,0x01,0x03,0x7a,0x01,0x02
	.byte 0x01,0x03,0x06,0x01,0x1c,0x02,0x02,0x03
	.byte 0x7b,0x01,0x02,0x01,0x03,0x05,0x01,0x02
	.byte 0x03,0x03,0x03,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x0e,0x0e
	.byte 0x11,0x02,0x01,0x03,0x72,0x01,0x02,0x01
	.byte 0x03,0x0e,0x01,0x02,0x01,0x03,0x72,0x01
	.byte 0x02,0x01,0x03,0x0d,0x01,0x12,0x02,0x02
	.byte 0x03,0x74,0x01,0x02,0x03,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x15,0x01,0x02,0x02,0x03
	.byte 0x68,0x01,0x02,0x01,0x03,0x03,0x01,0x29
	.byte 0x12,0x15,0x12,0x12,0x15,0x02,0x02,0x03
	.byte 0x05,0x01,0x02,0x01,0x03,0x7a,0x01,0x0e
	.byte 0x11,0x02,0x01,0x03,0x04,0x01,0x02,0x01
	.byte 0x03,0x7b,0x01,0x02,0x01,0x03,0x05,0x01
	.byte 0x02,0x01,0x03,0x7a,0x01,0x02,0x01,0x03
	.byte 0x06,0x01,0x1c,0x02,0x02,0x03,0x7b,0x01
	.byte 0x02,0x01,0x03,0x05,0x01,0x18,0x0e,0x10
	.byte 0x11,0x0e,0x0e,0x02,0x01,0x03,0x74,0x01
	.byte 0x02,0x01,0x03,0x0c,0x01,0x15,0x02,0x01
	.byte 0x03,0x72,0x01,0x02,0x01,0x03,0x0e,0x01
	.byte 0x0e,0x02,0x02,0x03,0x73,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x15,0x01
	.byte 0x02,0x04,0x03,0x7d,0x01,0x10,0x10,0x02
	.byte 0x01,0x03,0x7e,0x01,0x10,0x10,0x02,0x01
	.byte 0x03,0x7e,0x01,0x10,0x0e,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x2c,0x0e,0x14,0x1e,0x10,0x0e,0x18,0x10
	.byte 0x14,0x14,0x02,0x01,0x03,0x7e,0x01,0x11
	.byte 0x02,0x01,0x03,0x7d,0x01,0x11,0x0e,0x10
	.byte 0x10,0x02,0x02,0x03,0x7e,0x01,0x14,0x14
	.byte 0x02,0x02,0x03,0x7d,0x01,0x14,0x14,0x14
	.byte 0x02,0x01,0x03,0x7e,0x01,0x11,0x02,0x01
	.byte 0x03,0x7d,0x01,0x11,0x0e,0x10,0x10,0x02
	.byte 0x02,0x03,0x7e,0x01,0x14,0x14,0x02,0x02
	.byte 0x03,0x7d,0x01,0x14,0x14,0x14,0x02,0x01
	.byte 0x03,0x7e,0x01,0x11,0x02,0x01,0x03,0x7d
	.byte 0x01,0x11,0x0e,0x10,0x10,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x14,0x02,0x02,0x03,0x7d
	.byte 0x01,0x14,0x14,0x14,0x02,0x01,0x03,0x7e
	.byte 0x01,0x11,0x02,0x01,0x03,0x7d,0x01,0x11
	.byte 0x0e,0x10,0x10,0x02,0x02,0x03,0x7e,0x01
	.byte 0x14,0x14,0x02,0x01,0x03,0x7c,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x14,0x02,0x03,0x03,0x03,0x01,0x0e
	.byte 0x0e,0x11,0x0e,0x0e,0x0e,0x0e,0x02,0x02
	.byte 0x03,0x04,0x01,0x12,0x12,0x02,0x02,0x03
	.byte 0x7e,0x01,0x02,0x01,0x03,0x04,0x01,0x12
	.byte 0x12,0x02,0x02,0x03,0x7e,0x01,0x14,0x0e
	.byte 0x18,0x28,0x15,0x0e,0x10,0x0e,0x0e,0x15
	.byte 0x0e,0x10,0x0e,0x02,0x01,0x03,0x7d,0x01
	.byte 0x11,0x19,0x02,0x01,0x03,0x7c,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x0e,0x02,0x02,0x03
	.byte 0x7d,0x01,0x10,0x0e,0x02,0x02,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_transform_vector
	.byte 0x06,0x03,0xf9,0x01,0x01,0x1d,0x3c,0x3c
	.byte 0x3c,0x02,0x0d,0x00,0x01,0x01
!  End sdCreateSection
!  Begin sdCreateSection : .debug_abbrev
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_abbrev"
	.byte 0x01,0x11,0x01,0x03,0x08,0x13,0x0b,0x1b
	.byte 0x08,0x85,0x44,0x08,0x87,0x44,0x08,0x25
	.byte 0x08,0x10,0x06,0x00,0x00,0x02,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x11,0x01,0x12,0x01,0x40,0x0a
	.byte 0x27,0x0c,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x03,0x05,0x00,0x49,0x13,0x03,0x08
	.byte 0x3a,0x0b,0x3b,0x0b,0x02,0x0a,0x00,0x00
	.byte 0x04,0x34,0x00,0x03,0x08,0x49,0x13,0x17
	.byte 0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a,0x00
	.byte 0x00,0x05,0x86,0x84,0x01,0x00,0x92,0x44
	.byte 0x0b,0x91,0x44,0x09,0x00,0x00,0x06,0x24
	.byte 0x00,0x03,0x08,0x3e,0x0b,0x0b,0x0b,0x00
	.byte 0x00,0x07,0x16,0x00,0x49,0x13,0x03,0x08
	.byte 0x3a,0x0b,0x00,0x00,0x08,0x01,0x01,0x49
	.byte 0x13,0x0b,0x0b,0x01,0x13,0x00,0x00,0x09
	.byte 0x21,0x00,0x49,0x13,0x2f,0x0b,0x00,0x00
	.byte 0x0a,0x0f,0x00,0x49,0x13,0x00,0x00,0x0b
	.byte 0x26,0x00,0x49,0x13,0x00,0x00,0x0c,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x00,0x00
	.byte 0x0d,0x05,0x00,0x49,0x13,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x70,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x09,0x24,0x00,0x00,0x00,0xfe
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f
	.byte 0x34,0x66,0x76,0x00,0x00,0x00,0x03,0xa1
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f
	.byte 0x33,0x66,0x76,0x00,0x00,0x00,0x05,0xb8
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x6e,0x6f,0x72,0x6d,0x61,0x6c,0x73
	.byte 0x5f,0x33,0x66,0x76,0x00,0x00,0x00,0x08
	.byte 0x6b,0x67,0x6c,0x5f,0x74,0x72,0x61,0x6e
	.byte 0x73,0x66,0x6f,0x72,0x6d,0x5f,0x76,0x65
	.byte 0x63,0x74,0x6f,0x72,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x00,0x40,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x09,0x24,0x00,0x00,0x03,0x3f
	.byte 0x47,0x4c,0x75,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x03,0x73,0x47,0x4c,0x66,0x6c,0x6f
	.byte 0x61,0x74,0x00,0x00,0x00,0x08,0x42,0x47
	.byte 0x4c,0x62,0x6f,0x6f,0x6c,0x65,0x61,0x6e
	.byte 0x00,0x00,0x00,0x08,0x5c,0x47,0x4c,0x64
	.byte 0x6f,0x75,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)math.h\t2.24\t04/10/23 SMI"	! (/tmp/acompAAA.11325.6GaOhw:8)
	.ident	"@(#)math_iso.h\t1.9\t04/10/23 SMI"	! (/tmp/acompAAA.11325.6GaOhw:9)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11325.6GaOhw:10)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11325.6GaOhw:11)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11325.6GaOhw:12)
	.ident	"@(#)math_c99.h\t1.9\t04/11/01 SMI"	! (/tmp/acompAAA.11325.6GaOhw:13)
	.ident	"@(#)floatingpoint.h\t2.9\t04/10/23 SMI"	! (/tmp/acompAAA.11325.6GaOhw:14)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11325.6GaOhw:15)
	.ident	"@(#)ieeefp.h\t2.12\t04/10/23 SMI"	! (/tmp/acompAAA.11325.6GaOhw:16)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11325.6GaOhw:17)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11325.6GaOhw:18)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
