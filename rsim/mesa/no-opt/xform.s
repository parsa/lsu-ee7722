
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	gl_xform_points_4fv
	.type	gl_xform_points_4fv,#function
gl_xform_points_4fv:
	save	%sp,-152,%sp

	! block 1
.L13:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L14:
.L16:
.L17:

! File xform.c:
!    1	/* $Id: xform.c,v 1.10 1997/10/30 06:00:06 brianp Exp $ */
!    2	
!    3	/*
!    4	 * Mesa 3-D graphics library
!    5	 * Version:  2.5
!    6	 * Copyright (C) 1995-1997  Brian Paul
!    7	 *
!    8	 * This library is free software; you can redistribute it and/or
!    9	 * modify it under the terms of the GNU Library General Public
!   10	 * License as published by the Free Software Foundation; either
!   11	 * version 2 of the License, or (at your option) any later version.
!   12	 *
!   13	 * This library is distributed in the hope that it will be useful,
!   14	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
!   15	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!   16	 * Library General Public License for more details.
!   17	 *
!   18	 * You should have received a copy of the GNU Library General Public
!   19	 * License along with this library; if not, write to the Free
!   20	 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!   21	 */
!   22	
!   24	/*
!   25	 * $Log: xform.c,v $
!   26	 * Revision 1.10  1997/10/30 06:00:06  brianp
!   27	 * added Intel X86 assembly optimzations (Josh Vanderhoof)
!   28	 *
!   29	 * Revision 1.9  1997/07/24 01:25:54  brianp
!   30	 * changed precompiled header symbol from PCH to PC_HEADER
!   31	 *
!   32	 * Revision 1.8  1997/05/28 03:27:03  brianp
!   33	 * added precompiled header (PCH) support
!   34	 *
!   35	 * Revision 1.7  1997/05/01 01:40:51  brianp
!   36	 * replaced sqrt() with GL_SQRT()
!   37	 *
!   38	 * Revision 1.6  1997/04/02 03:15:02  brianp
!   39	 * removed gl_xform_texcoords_4fv()
!   40	 *
!   41	 * Revision 1.5  1997/01/03 23:54:17  brianp
!   42	 * changed length threshold in gl_xform_normals_3fv() to 1E-30 per Jeroen
!   43	 *
!   44	 * Revision 1.4  1996/11/09 01:50:49  brianp
!   45	 * relaxed the minimum normal threshold in gl_xform_normals_3fv()
!   46	 *
!   47	 * Revision 1.3  1996/11/08 02:20:39  brianp
!   48	 * added gl_xform_texcoords_4fv()
!   49	 *
!   50	 * Revision 1.2  1996/11/05 01:38:50  brianp
!   51	 * fixed some comments
!   52	 *
!   53	 * Revision 1.1  1996/09/13 01:38:16  brianp
!   54	 * Initial revision
!   55	 *
!   56	 */
!   57	
!   59	/*
!   60	 * Matrix/vertex/vector transformation stuff
!   61	 *
!   62	 *
!   63	 * NOTES:
!   64	 * 1. 4x4 transformation matrices are stored in memory in column major order.
!   65	 * 2. Points/vertices are to be thought of as column vectors.
!   66	 * 3. Transformation of a point p by a matrix M is: p' = M * p
!   67	 *
!   68	 */
!   69	
!   71	#ifdef PC_HEADER
!   72	#include "all.h"
!   73	#else
!   74	#include <math.h>
!   75	#include "mmath.h"
!   76	#include "types.h"
!   77	#include "xform.h"
!   78	#endif
!   79	
!   82	/*
!   83	 * Apply a transformation matrix to an array of [X Y Z W] coordinates:
!   84	 *   for i in 0 to n-1 do   q[i] = m * p[i]
!   85	 * where p[i] and q[i] are 4-element column vectors and m is a 16-element
!   86	 * transformation matrix.
!   87	 */
!   88	void gl_xform_points_4fv( GLuint n, GLfloat q[][4], const GLfloat m[16],
!   89	                          GLfloat p[][4] )
!   90	{
!   91	   /* This function has been carefully crafted to maximize register usage
!   92	    * and use loop unrolling with IRIX 5.3's cc.  Hopefully other compilers
!   93	    * will like this code too.
!   94	    */
!   95	   {
!   96	      GLuint i;
!   97	      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8],  m12 = m[12];

	ld	[%fp+76],%l0
	ld	[%l0+0],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+16],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+32],%f4
	st	%f4,[%fp-16]
	ld	[%fp+76],%l0
	ld	[%l0+48],%f4
	st	%f4,[%fp-20]

	! block 3
.L18:

!   98	      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9],  m13 = m[13];

	ld	[%fp+76],%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+20],%f4
	st	%f4,[%fp-28]
	ld	[%fp+76],%l0
	ld	[%l0+36],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+52],%f4
	st	%f4,[%fp-36]

	! block 4
.L19:
.L21:

!   99	      if (m12==0.0F && m13==0.0F) {

	ld	[%fp-20],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L20
	nop

	! block 5
.L22:
	ld	[%fp-36],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L20
	nop

	! block 6
.L23:
.L24:
.L25:
.L26:
.L27:

!  100	         /* common case */
!  101	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L30
	st	%g0,[%fp-4]

	! block 7
.L31:
.L28:
.L32:
.L33:
.L34:

!  102	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]

	! block 8
.L35:

!  103	            q[i][0] = m0 * p0 + m4  * p1 + m8 * p2;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	st	%f4,[%l2+%l1]

	! block 9
.L36:

!  104	            q[i][1] = m1 * p0 + m5  * p1 + m9 * p2;

	ld	[%fp-24],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-28],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-32],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+4]

	! block 10
.L37:
.L38:
.L39:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L28
	nop

	! block 11
.L40:
.L30:
.L41:
.L42:
.L43:
	ba	.L44
	nop

	! block 12
.L20:
.L45:
.L46:
.L47:
.L48:

!  105	         }
!  106	      }
!  107	      else {
!  108	         /* general case */
!  109	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L51
	st	%g0,[%fp-4]

	! block 13
.L52:
.L49:
.L53:
.L54:
.L55:

!  110	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-52]

	! block 14
.L56:

!  111	            q[i][0] = m0 * p0 + m4  * p1 + m8 * p2 + m12 * p3;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-20],%f5
	ld	[%fp-52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	st	%f4,[%l2+%l1]

	! block 15
.L57:

!  112	            q[i][1] = m1 * p0 + m5  * p1 + m9 * p2 + m13 * p3;

	ld	[%fp-24],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-28],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-32],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-36],%f5
	ld	[%fp-52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+4]

	! block 16
.L58:
.L59:
.L60:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L49
	nop

	! block 17
.L61:
.L51:
.L62:
.L63:
.L64:
.L44:
.L65:
.L66:
.L67:
.L68:

!  113	         }
!  114	      }
!  115	   }
!  116	   {
!  117	      GLuint i;
!  118	      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10],  m14 = m[14];

	ld	[%fp+76],%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+24],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+40],%f4
	st	%f4,[%fp-16]
	ld	[%fp+76],%l0
	ld	[%l0+56],%f4
	st	%f4,[%fp-20]

	! block 18
.L69:

!  119	      GLfloat m3 = m[3],  m7 = m[7],  m11 = m[11],  m15 = m[15];

	ld	[%fp+76],%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+28],%f4
	st	%f4,[%fp-28]
	ld	[%fp+76],%l0
	ld	[%l0+44],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+60],%f4
	st	%f4,[%fp-36]

	! block 19
.L70:
.L72:

!  120	      if (m3==0.0F && m7==0.0F && m11==0.0F && m15==1.0F) {

	ld	[%fp-24],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L71
	nop

	! block 20
.L73:
	ld	[%fp-28],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L71
	nop

	! block 21
.L74:
	ld	[%fp-32],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L71
	nop

	! block 22
.L75:
	ld	[%fp-36],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbne	.L71
	nop

	! block 23
.L76:
.L77:
.L78:
.L79:
.L80:

!  121	         /* common case */
!  122	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L83
	st	%g0,[%fp-4]

	! block 24
.L84:
.L81:
.L85:
.L86:
.L87:

!  123	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-52]

	! block 25
.L88:

!  124	            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14 * p3;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-20],%f5
	ld	[%fp-52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 26
.L89:

!  125	            q[i][3] = p3;

	ld	[%fp-52],%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+12]

	! block 27
.L90:
.L91:
.L92:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L81
	nop

	! block 28
.L93:
.L83:
.L94:
.L95:
.L96:
	ba	.L97
	nop

	! block 29
.L71:
.L98:
.L99:
.L100:
.L101:

!  126	         }
!  127	      }
!  128	      else {
!  129	         /* general case */
!  130	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L104
	st	%g0,[%fp-4]

	! block 30
.L105:
.L102:
.L106:
.L107:
.L108:

!  131	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2], p3 = p[i][3];

	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-52]

	! block 31
.L109:

!  132	            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14 * p3;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-20],%f5
	ld	[%fp-52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 32
.L110:

!  133	            q[i][3] = m3 * p0 + m7 * p1 + m11 * p2 + m15 * p3;

	ld	[%fp-24],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-28],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-32],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-36],%f5
	ld	[%fp-52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+12]

	! block 33
.L111:
.L112:
.L113:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L102
	nop

	! block 34
.L114:
.L104:
.L115:
.L116:
.L117:
.L97:
.L118:
.L119:

	! block 35
.L120:
.L121:
.L12:
	jmp	%i7+8
	restore
	.size	gl_xform_points_4fv,(.-gl_xform_points_4fv)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_xform_points_3fv
	.type	gl_xform_points_3fv,#function
gl_xform_points_3fv:
	save	%sp,-144,%sp

	! block 1
.L124:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L125:
.L127:
.L128:

! File xform.c:
!  134	         }
!  135	      }
!  136	   }
!  137	}
!  138	
!  141	/*
!  142	 * Apply a transformation matrix to an array of [X Y Z] coordinates:
!  143	 *   for i in 0 to n-1 do   q[i] = m * p[i]
!  144	 */
!  145	void gl_xform_points_3fv( GLuint n, GLfloat q[][4], const GLfloat m[16],
!  146	                          GLfloat p[][3] )
!  147	{
!  148	   /* This function has been carefully crafted to maximize register usage
!  149	    * and use loop unrolling with IRIX 5.3's cc.  Hopefully other compilers
!  150	    * will like this code too.
!  151	    */
!  152	   {
!  153	      GLuint i;
!  154	      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8],  m12 = m[12];

	ld	[%fp+76],%l0
	ld	[%l0+0],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+16],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+32],%f4
	st	%f4,[%fp-16]
	ld	[%fp+76],%l0
	ld	[%l0+48],%f4
	st	%f4,[%fp-20]

	! block 3
.L129:

!  155	      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9],  m13 = m[13];

	ld	[%fp+76],%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+20],%f4
	st	%f4,[%fp-28]
	ld	[%fp+76],%l0
	ld	[%l0+36],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+52],%f4
	st	%f4,[%fp-36]

	! block 4
.L130:
.L131:

!  156	      for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L134
	st	%g0,[%fp-4]

	! block 5
.L135:
.L132:
.L136:
.L137:
.L138:

!  157	         GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]

	! block 6
.L139:

!  158	         q[i][0] = m0 * p0 + m4  * p1 + m8 * p2 + m12;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f5
	ld	[%fp-20],%f4
	fadds	%f5,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	st	%f4,[%l2+%l1]

	! block 7
.L140:

!  159	         q[i][1] = m1 * p0 + m5  * p1 + m9 * p2 + m13;

	ld	[%fp-24],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-28],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-32],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f5
	ld	[%fp-36],%f4
	fadds	%f5,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+4]

	! block 8
.L141:
.L142:
.L143:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L132
	nop

	! block 9
.L144:
.L134:
.L145:
.L146:
.L147:
.L148:

!  160	      }
!  161	   }
!  162	   {
!  163	      GLuint i;
!  164	      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10],  m14 = m[14];

	ld	[%fp+76],%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+24],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+40],%f4
	st	%f4,[%fp-16]
	ld	[%fp+76],%l0
	ld	[%l0+56],%f4
	st	%f4,[%fp-20]

	! block 10
.L149:

!  165	      GLfloat m3 = m[3],  m7 = m[7],  m11 = m[11],  m15 = m[15];

	ld	[%fp+76],%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+28],%f4
	st	%f4,[%fp-28]
	ld	[%fp+76],%l0
	ld	[%l0+44],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+60],%f4
	st	%f4,[%fp-36]

	! block 11
.L150:
.L152:

!  166	      if (m3==0.0F && m7==0.0F && m11==0.0F && m15==1.0F) {

	ld	[%fp-24],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L151
	nop

	! block 12
.L153:
	ld	[%fp-28],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L151
	nop

	! block 13
.L154:
	ld	[%fp-32],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L151
	nop

	! block 14
.L155:
	ld	[%fp-36],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbne	.L151
	nop

	! block 15
.L156:
.L157:
.L158:
.L159:
.L160:

!  167	         /* common case */
!  168	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L163
	st	%g0,[%fp-4]

	! block 16
.L_y0:
	sethi	%hi(.L_cseg1),%l4
	or	%l4,%lo(.L_cseg1),%l4
.L164:
.L161:
.L165:
.L166:
.L167:

!  169	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]

	! block 17
.L168:

!  170	            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f5
	ld	[%fp-20],%f4
	fadds	%f5,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 18
.L169:

!  171	            q[i][3] = 1.0F;

	ld	[%l4+0],%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+12]

	! block 19
.L170:
.L171:
.L172:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L161
	nop

	! block 20
.L173:
.L163:
.L174:
.L175:
.L176:
	ba	.L177
	nop

	! block 21
.L151:
.L178:
.L179:
.L180:
.L181:

!  172	         }
!  173	      }
!  174	      else {
!  175	         /* general case */
!  176	         for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L184
	st	%g0,[%fp-4]

	! block 22
.L185:
.L182:
.L186:
.L187:
.L188:

!  177	            GLfloat p0 = p[i][0], p1 = p[i][1], p2 = p[i][2];

	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-40]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-48]

	! block 23
.L189:

!  178	            q[i][2] = m2 * p0 + m6 * p1 + m10 * p2 + m14;

	ld	[%fp-8],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f5
	ld	[%fp-20],%f4
	fadds	%f5,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 24
.L190:

!  179	            q[i][3] = m3 * p0 + m7 * p1 + m11 * p2 + m15;

	ld	[%fp-24],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-28],%f5
	ld	[%fp-44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-32],%f5
	ld	[%fp-48],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f5
	ld	[%fp-36],%f4
	fadds	%f5,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-4],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+12]

	! block 25
.L191:
.L192:
.L193:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L182
	nop

	! block 26
.L194:
.L184:
.L195:
.L196:
.L197:
.L177:
.L198:
.L199:

	! block 27
.L200:
.L201:
.L123:
	jmp	%i7+8
	restore
	.size	gl_xform_points_3fv,(.-gl_xform_points_3fv)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_xform_normals_3fv
	.type	gl_xform_normals_3fv,#function
gl_xform_normals_3fv:
	save	%sp,-184,%sp

	! block 1
.L204:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	stb	%i4,[%fp+87]

	! block 2
.L205:
.L207:
.L209:

! File xform.c:
!  180	         }
!  181	      }
!  182	   }
!  183	}
!  184	
!  187	#ifndef USE_ASM
!  188	/*
!  189	 * Apply a transformation matrix to an array of normal vectors:
!  190	 *   for i in 0 to n-1 do  v[i] = u[i] * m
!  191	 * where u[i] and v[i] are 3-element row vectors and m is a 16-element
!  192	 * transformation matrix.
!  193	 * If the normalize flag is true the normals will be scaled to length 1.
!  194	 */
!  195	void gl_xform_normals_3fv( GLuint n, GLfloat v[][3], const GLfloat m[16],
!  196	                           GLfloat u[][3], GLboolean normalize )
!  197	{
!  198	   if (normalize) {

	ldub	[%fp+87],%l0
	cmp	%l0,%g0
	be	.L208
	nop

	! block 3
.L210:
.L211:
.L212:
.L213:

!  199	      /* Transform normals and scale to unit length */
!  200	      GLuint i;
!  201	      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8];

	ld	[%fp+76],%l0
	ld	[%l0+0],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+16],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+32],%f4
	st	%f4,[%fp-16]

	! block 4
.L214:

!  202	      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9];

	ld	[%fp+76],%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-20]
	ld	[%fp+76],%l0
	ld	[%l0+20],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+36],%f4
	st	%f4,[%fp-28]

	! block 5
.L215:

!  203	      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10];

	ld	[%fp+76],%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+24],%f4
	st	%f4,[%fp-36]
	ld	[%fp+76],%l0
	ld	[%l0+40],%f4
	st	%f4,[%fp-40]

	! block 6
.L216:
.L217:

!  204	      for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L220
	st	%g0,[%fp-4]

	! block 7
.L221:
.L218:
.L222:
.L223:
.L224:
.L225:

!  205	         GLdouble tx, ty, tz;
!  206	         {
!  207	            GLfloat ux = u[i][0],  uy = u[i][1],  uz = u[i][2];

	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-68]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-72]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-76]

	! block 8
.L226:

!  208	            tx = ux * m0 + uy * m1 + uz * m2;

	ld	[%fp-68],%f5
	ld	[%fp-8],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-72],%f5
	ld	[%fp-20],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-76],%f5
	ld	[%fp-32],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%fp-48]

	! block 9
.L227:

!  209	            ty = ux * m4 + uy * m5 + uz * m6;

	ld	[%fp-68],%f5
	ld	[%fp-12],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-72],%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-76],%f5
	ld	[%fp-36],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%fp-56]

	! block 10
.L228:

!  210	            tz = ux * m8 + uy * m9 + uz * m10;

	ld	[%fp-68],%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-72],%f5
	ld	[%fp-28],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-76],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%fp-64]

	! block 11
.L229:
.L230:
.L231:

!  211	         }
!  212	         {
!  213	            GLdouble len, scale;
!  214	            len = GL_SQRT( tx*tx + ty*ty + tz*tz );

	ldd	[%fp-48],%f4
	fmuld	%f4,%f4,%f6
	ldd	[%fp-56],%f4
	fmuld	%f4,%f4,%f4
	faddd	%f6,%f4,%f6
	ldd	[%fp-64],%f4
	fmuld	%f4,%f4,%f4
	faddd	%f6,%f4,%f4
	std	%f4,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o0
	or	%g0,%g1,%o1
	call	sqrt
	nop
	std	%f0,[%fp-72]

	! block 12
.L232:

!  215	            scale = (len>1E-30) ? (1.0 / len) : 1.0;

	ldd	[%fp-72],%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbule	.L233
	nop

	! block 13
.L234:
	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f6
	ldd	[%fp-72],%f4
	fdivd	%f6,%f4,%f4
	ba	.L235
	std	%f4,[%fp-88]

	! block 14
.L233:
	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	std	%f4,[%fp-88]

	! block 15
.L235:
	ldd	[%fp-88],%f4
	std	%f4,[%fp-80]

	! block 16
.L236:

!  216	            v[i][0] = tx * scale;

	ldd	[%fp-48],%f6
	ldd	[%fp-80],%f4
	fmuld	%f6,%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	st	%f4,[%l3+%l1]

	! block 17
.L237:

!  217	            v[i][1] = ty * scale;

	ldd	[%fp-56],%f6
	ldd	[%fp-80],%f4
	fmuld	%f6,%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	st	%f4,[%l0+4]

	! block 18
.L238:

!  218	            v[i][2] = tz * scale;

	ldd	[%fp-64],%f6
	ldd	[%fp-80],%f4
	fmuld	%f6,%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	st	%f4,[%l0+8]

	! block 19
.L239:
.L240:
.L241:
.L242:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L218
	nop

	! block 20
.L243:
.L220:
.L244:
.L245:
.L246:
	ba	.L247
	nop

	! block 21
.L208:
.L248:
.L249:
.L250:

!  219	         }
!  220	      }
!  221	   }
!  222	   else {
!  223	      /* Just transform normals, don't scale */
!  224	      GLuint i;
!  225	      GLfloat m0 = m[0],  m4 = m[4],  m8 = m[8];

	ld	[%fp+76],%l0
	ld	[%l0+0],%f4
	st	%f4,[%fp-8]
	ld	[%fp+76],%l0
	ld	[%l0+16],%f4
	st	%f4,[%fp-12]
	ld	[%fp+76],%l0
	ld	[%l0+32],%f4
	st	%f4,[%fp-16]

	! block 22
.L251:

!  226	      GLfloat m1 = m[1],  m5 = m[5],  m9 = m[9];

	ld	[%fp+76],%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-20]
	ld	[%fp+76],%l0
	ld	[%l0+20],%f4
	st	%f4,[%fp-24]
	ld	[%fp+76],%l0
	ld	[%l0+36],%f4
	st	%f4,[%fp-28]

	! block 23
.L252:

!  227	      GLfloat m2 = m[2],  m6 = m[6],  m10 = m[10];

	ld	[%fp+76],%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-32]
	ld	[%fp+76],%l0
	ld	[%l0+24],%f4
	st	%f4,[%fp-36]
	ld	[%fp+76],%l0
	ld	[%l0+40],%f4
	st	%f4,[%fp-40]

	! block 24
.L253:
.L254:

!  228	      for (i=0;i<n;i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bgeu	.L257
	st	%g0,[%fp-4]

	! block 25
.L258:
.L255:
.L259:
.L260:
.L261:

!  229	         GLfloat ux = u[i][0],  uy = u[i][1],  uz = u[i][2];

	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-44]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-48]
	ld	[%fp+80],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-52]

	! block 26
.L262:

!  230	         v[i][0] = ux * m0 + uy * m1 + uz * m2;

	ld	[%fp-44],%f5
	ld	[%fp-8],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-48],%f5
	ld	[%fp-20],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-52],%f5
	ld	[%fp-32],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	st	%f4,[%l3+%l1]

	! block 27
.L263:

!  231	         v[i][1] = ux * m4 + uy * m5 + uz * m6;

	ld	[%fp-44],%f5
	ld	[%fp-12],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-48],%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-52],%f5
	ld	[%fp-36],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	st	%f4,[%l0+4]

	! block 28
.L264:

!  232	         v[i][2] = ux * m8 + uy * m9 + uz * m10;

	ld	[%fp-44],%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-48],%f5
	ld	[%fp-28],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-52],%f5
	ld	[%fp-40],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l3
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	st	%f4,[%l0+8]

	! block 29
.L265:
.L266:
.L267:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	blu	.L255
	nop

	! block 30
.L268:
.L257:
.L269:
.L270:
.L271:
.L247:
.L272:

	! block 31
.L273:
.L274:
.L203:
	jmp	%i7+8
	restore
	.size	gl_xform_normals_3fv,(.-gl_xform_normals_3fv)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_transform_vector
	.type	gl_transform_vector,#function
gl_transform_vector:
	save	%sp,-112,%sp

	! block 1
.L277:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L278:
.L280:

! File xform.c:
!  233	      }
!  234	   }
!  235	}
!  236	#endif
!  237	
!  239	/*
!  240	 * Transform a 4-element row vector (1x4 matrix) by a 4x4 matrix.  This
!  241	 * function is used for transforming clipping plane equations and spotlight
!  242	 * directions.
!  243	 * Mathematically,  u = v * m.
!  244	 * Input:  v - input vector
!  245	 *         m - transformation matrix
!  246	 * Output:  u - transformed vector
!  247	 */
!  248	void gl_transform_vector( GLfloat u[4], const GLfloat v[4], const GLfloat m[16] )
!  249	{
!  250	   GLfloat v0=v[0], v1=v[1], v2=v[2], v3=v[3];

	ld	[%fp+72],%l0
	ld	[%l0+0],%f4
	st	%f4,[%fp-4]
	ld	[%fp+72],%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-8]
	ld	[%fp+72],%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-12]
	ld	[%fp+72],%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-16]

	! block 3
.L281:

!  251	#define M(row,col)  m[col*4+row]
!  252	   u[0] = v0 * M(0,0) + v1 * M(1,0) + v2 * M(2,0) + v3 * M(3,0);

	ld	[%fp-4],%f5
	ld	[%fp+76],%l0
	ld	[%l0+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-8],%f5
	ld	[%l0+4],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%l0+8],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%l0+12],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+68],%l0
	st	%f4,[%l0+0]

	! block 4
.L282:

!  253	   u[1] = v0 * M(0,1) + v1 * M(1,1) + v2 * M(2,1) + v3 * M(3,1);

	ld	[%fp-4],%f5
	ld	[%fp+76],%l0
	ld	[%l0+16],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-8],%f5
	ld	[%l0+20],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%l0+24],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%l0+28],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+68],%l0
	st	%f4,[%l0+4]

	! block 5
.L283:

!  254	   u[2] = v0 * M(0,2) + v1 * M(1,2) + v2 * M(2,2) + v3 * M(3,2);

	ld	[%fp-4],%f5
	ld	[%fp+76],%l0
	ld	[%l0+32],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-8],%f5
	ld	[%l0+36],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%l0+40],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%l0+44],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+68],%l0
	st	%f4,[%l0+8]

	! block 6
.L284:

!  255	   u[3] = v0 * M(0,3) + v1 * M(1,3) + v2 * M(2,3) + v3 * M(3,3);

	ld	[%fp-4],%f5
	ld	[%fp+76],%l0
	ld	[%l0+48],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-8],%f5
	ld	[%l0+52],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-12],%f5
	ld	[%l0+56],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f6
	ld	[%fp-16],%f5
	ld	[%l0+60],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+68],%l0
	st	%f4,[%l0+12]

	! block 7
.L285:
.L286:
.L276:
	jmp	%i7+8
	restore
	.size	gl_transform_vector,(.-gl_transform_vector)
	.align	8

	.section	".rodata",#alloc
	.align	4
Drodata.rodata:
.L_cseg0:
	.skip	4
	.type	.L_cseg0,#object
	.size	.L_cseg0,4
	.align	4
.L_cseg1:
	.word	0x3f800000
	.type	.L_cseg1,#object
	.size	.L_cseg1,4
	.align	8
.L_cseg2:
	.word	0x39b4484b,0xfeebc2a0
	.type	.L_cseg2,#object
	.size	.L_cseg2,8
	.align	8
.L_cseg3:
	.word	0x3ff00000,0x0
	.type	.L_cseg3,#object
	.size	.L_cseg3,8
	.section	".bss",#alloc,#write
Bbss.bss:
	.section	".data",#alloc,#write
Ddata.data:

	.file	"xform.c"
	.ident	"@(#)math.h	2.24	04/10/23 SMI"
	.ident	"@(#)math_iso.h	1.9	04/10/23 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)math_c99.h	1.9	04/11/01 SMI"
	.ident	"@(#)floatingpoint.h	2.9	04/10/23 SMI"
	.ident	"@(#)stdio_tag.h	1.4	04/09/28 SMI"
	.ident	"@(#)ieeefp.h	2.12	04/10/23 SMI"
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"
!  Begin sdCreateSection : .debug_loc
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_loc"
!  End sdCreateSection
!  Begin sdCreateSection : .debug_info
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_abbrev, lab2=, loff=0
!   reloc[1]: knd=2, off=253, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=282, siz=4, lab1=gl_xform_points_4fv, lab2=, loff=0
!   reloc[3]: knd=0, off=286, siz=4, lab1=.L121, lab2=, loff=0
!   reloc[4]: knd=0, off=351, siz=4, lab1=.L16, lab2=, loff=0
!   reloc[5]: knd=0, off=355, siz=4, lab1=.L66, lab2=, loff=0
!   reloc[6]: knd=0, off=487, siz=4, lab1=.L19, lab2=, loff=0
!   reloc[7]: knd=0, off=491, siz=4, lab1=.L65, lab2=, loff=0
!   reloc[8]: knd=0, off=496, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[9]: knd=0, off=500, siz=4, lab1=.L43, lab2=, loff=0
!   reloc[10]: knd=0, off=505, siz=4, lab1=.L25, lab2=, loff=0
!   reloc[11]: knd=0, off=509, siz=4, lab1=.L42, lab2=, loff=0
!   reloc[12]: knd=0, off=514, siz=4, lab1=.L26, lab2=, loff=0
!   reloc[13]: knd=0, off=518, siz=4, lab1=.L41, lab2=, loff=0
!   reloc[14]: knd=0, off=523, siz=4, lab1=.L32, lab2=, loff=0
!   reloc[15]: knd=0, off=527, siz=4, lab1=.L38, lab2=, loff=0
!   reloc[16]: knd=0, off=532, siz=4, lab1=.L33, lab2=, loff=0
!   reloc[17]: knd=0, off=536, siz=4, lab1=.L37, lab2=, loff=0
!   reloc[18]: knd=0, off=588, siz=4, lab1=.L45, lab2=, loff=0
!   reloc[19]: knd=0, off=592, siz=4, lab1=.L64, lab2=, loff=0
!   reloc[20]: knd=0, off=597, siz=4, lab1=.L46, lab2=, loff=0
!   reloc[21]: knd=0, off=601, siz=4, lab1=.L63, lab2=, loff=0
!   reloc[22]: knd=0, off=606, siz=4, lab1=.L47, lab2=, loff=0
!   reloc[23]: knd=0, off=610, siz=4, lab1=.L62, lab2=, loff=0
!   reloc[24]: knd=0, off=615, siz=4, lab1=.L53, lab2=, loff=0
!   reloc[25]: knd=0, off=619, siz=4, lab1=.L59, lab2=, loff=0
!   reloc[26]: knd=0, off=624, siz=4, lab1=.L54, lab2=, loff=0
!   reloc[27]: knd=0, off=628, siz=4, lab1=.L58, lab2=, loff=0
!   reloc[28]: knd=0, off=696, siz=4, lab1=.L67, lab2=, loff=0
!   reloc[29]: knd=0, off=700, siz=4, lab1=.L119, lab2=, loff=0
!   reloc[30]: knd=0, off=834, siz=4, lab1=.L70, lab2=, loff=0
!   reloc[31]: knd=0, off=838, siz=4, lab1=.L118, lab2=, loff=0
!   reloc[32]: knd=0, off=843, siz=4, lab1=.L77, lab2=, loff=0
!   reloc[33]: knd=0, off=847, siz=4, lab1=.L96, lab2=, loff=0
!   reloc[34]: knd=0, off=852, siz=4, lab1=.L78, lab2=, loff=0
!   reloc[35]: knd=0, off=856, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[36]: knd=0, off=861, siz=4, lab1=.L79, lab2=, loff=0
!   reloc[37]: knd=0, off=865, siz=4, lab1=.L94, lab2=, loff=0
!   reloc[38]: knd=0, off=870, siz=4, lab1=.L85, lab2=, loff=0
!   reloc[39]: knd=0, off=874, siz=4, lab1=.L91, lab2=, loff=0
!   reloc[40]: knd=0, off=879, siz=4, lab1=.L86, lab2=, loff=0
!   reloc[41]: knd=0, off=883, siz=4, lab1=.L90, lab2=, loff=0
!   reloc[42]: knd=0, off=949, siz=4, lab1=.L98, lab2=, loff=0
!   reloc[43]: knd=0, off=953, siz=4, lab1=.L117, lab2=, loff=0
!   reloc[44]: knd=0, off=958, siz=4, lab1=.L99, lab2=, loff=0
!   reloc[45]: knd=0, off=962, siz=4, lab1=.L116, lab2=, loff=0
!   reloc[46]: knd=0, off=967, siz=4, lab1=.L100, lab2=, loff=0
!   reloc[47]: knd=0, off=971, siz=4, lab1=.L115, lab2=, loff=0
!   reloc[48]: knd=0, off=976, siz=4, lab1=.L106, lab2=, loff=0
!   reloc[49]: knd=0, off=980, siz=4, lab1=.L112, lab2=, loff=0
!   reloc[50]: knd=0, off=985, siz=4, lab1=.L107, lab2=, loff=0
!   reloc[51]: knd=0, off=989, siz=4, lab1=.L111, lab2=, loff=0
!   reloc[52]: knd=0, off=1192, siz=4, lab1=gl_xform_points_3fv, lab2=, loff=0
!   reloc[53]: knd=0, off=1196, siz=4, lab1=.L201, lab2=, loff=0
!   reloc[54]: knd=0, off=1261, siz=4, lab1=.L127, lab2=, loff=0
!   reloc[55]: knd=0, off=1265, siz=4, lab1=.L146, lab2=, loff=0
!   reloc[56]: knd=0, off=1397, siz=4, lab1=.L130, lab2=, loff=0
!   reloc[57]: knd=0, off=1401, siz=4, lab1=.L145, lab2=, loff=0
!   reloc[58]: knd=0, off=1406, siz=4, lab1=.L136, lab2=, loff=0
!   reloc[59]: knd=0, off=1410, siz=4, lab1=.L142, lab2=, loff=0
!   reloc[60]: knd=0, off=1415, siz=4, lab1=.L137, lab2=, loff=0
!   reloc[61]: knd=0, off=1419, siz=4, lab1=.L141, lab2=, loff=0
!   reloc[62]: knd=0, off=1470, siz=4, lab1=.L147, lab2=, loff=0
!   reloc[63]: knd=0, off=1474, siz=4, lab1=.L199, lab2=, loff=0
!   reloc[64]: knd=0, off=1608, siz=4, lab1=.L150, lab2=, loff=0
!   reloc[65]: knd=0, off=1612, siz=4, lab1=.L198, lab2=, loff=0
!   reloc[66]: knd=0, off=1617, siz=4, lab1=.L157, lab2=, loff=0
!   reloc[67]: knd=0, off=1621, siz=4, lab1=.L176, lab2=, loff=0
!   reloc[68]: knd=0, off=1626, siz=4, lab1=.L158, lab2=, loff=0
!   reloc[69]: knd=0, off=1630, siz=4, lab1=.L175, lab2=, loff=0
!   reloc[70]: knd=0, off=1635, siz=4, lab1=.L159, lab2=, loff=0
!   reloc[71]: knd=0, off=1639, siz=4, lab1=.L174, lab2=, loff=0
!   reloc[72]: knd=0, off=1644, siz=4, lab1=.L165, lab2=, loff=0
!   reloc[73]: knd=0, off=1648, siz=4, lab1=.L171, lab2=, loff=0
!   reloc[74]: knd=0, off=1653, siz=4, lab1=.L166, lab2=, loff=0
!   reloc[75]: knd=0, off=1657, siz=4, lab1=.L170, lab2=, loff=0
!   reloc[76]: knd=0, off=1709, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[77]: knd=0, off=1713, siz=4, lab1=.L197, lab2=, loff=0
!   reloc[78]: knd=0, off=1718, siz=4, lab1=.L179, lab2=, loff=0
!   reloc[79]: knd=0, off=1722, siz=4, lab1=.L196, lab2=, loff=0
!   reloc[80]: knd=0, off=1727, siz=4, lab1=.L180, lab2=, loff=0
!   reloc[81]: knd=0, off=1731, siz=4, lab1=.L195, lab2=, loff=0
!   reloc[82]: knd=0, off=1736, siz=4, lab1=.L186, lab2=, loff=0
!   reloc[83]: knd=0, off=1740, siz=4, lab1=.L192, lab2=, loff=0
!   reloc[84]: knd=0, off=1745, siz=4, lab1=.L187, lab2=, loff=0
!   reloc[85]: knd=0, off=1749, siz=4, lab1=.L191, lab2=, loff=0
!   reloc[86]: knd=0, off=1883, siz=4, lab1=gl_xform_normals_3fv, lab2=, loff=0
!   reloc[87]: knd=0, off=1887, siz=4, lab1=.L274, lab2=, loff=0
!   reloc[88]: knd=0, off=1973, siz=4, lab1=.L207, lab2=, loff=0
!   reloc[89]: knd=0, off=1977, siz=4, lab1=.L272, lab2=, loff=0
!   reloc[90]: knd=0, off=1982, siz=4, lab1=.L211, lab2=, loff=0
!   reloc[91]: knd=0, off=1986, siz=4, lab1=.L246, lab2=, loff=0
!   reloc[92]: knd=0, off=1991, siz=4, lab1=.L212, lab2=, loff=0
!   reloc[93]: knd=0, off=1995, siz=4, lab1=.L245, lab2=, loff=0
!   reloc[94]: knd=0, off=2140, siz=4, lab1=.L216, lab2=, loff=0
!   reloc[95]: knd=0, off=2144, siz=4, lab1=.L244, lab2=, loff=0
!   reloc[96]: knd=0, off=2149, siz=4, lab1=.L222, lab2=, loff=0
!   reloc[97]: knd=0, off=2153, siz=4, lab1=.L241, lab2=, loff=0
!   reloc[98]: knd=0, off=2158, siz=4, lab1=.L223, lab2=, loff=0
!   reloc[99]: knd=0, off=2162, siz=4, lab1=.L240, lab2=, loff=0
!   reloc[100]: knd=0, off=2209, siz=4, lab1=.L224, lab2=, loff=0
!   reloc[101]: knd=0, off=2213, siz=4, lab1=.L229, lab2=, loff=0
!   reloc[102]: knd=0, off=2264, siz=4, lab1=.L230, lab2=, loff=0
!   reloc[103]: knd=0, off=2268, siz=4, lab1=.L239, lab2=, loff=0
!   reloc[104]: knd=0, off=2313, siz=4, lab1=.L248, lab2=, loff=0
!   reloc[105]: knd=0, off=2317, siz=4, lab1=.L271, lab2=, loff=0
!   reloc[106]: knd=0, off=2322, siz=4, lab1=.L249, lab2=, loff=0
!   reloc[107]: knd=0, off=2326, siz=4, lab1=.L270, lab2=, loff=0
!   reloc[108]: knd=0, off=2471, siz=4, lab1=.L253, lab2=, loff=0
!   reloc[109]: knd=0, off=2475, siz=4, lab1=.L269, lab2=, loff=0
!   reloc[110]: knd=0, off=2480, siz=4, lab1=.L259, lab2=, loff=0
!   reloc[111]: knd=0, off=2484, siz=4, lab1=.L266, lab2=, loff=0
!   reloc[112]: knd=0, off=2489, siz=4, lab1=.L260, lab2=, loff=0
!   reloc[113]: knd=0, off=2493, siz=4, lab1=.L265, lab2=, loff=0
!   reloc[114]: knd=0, off=2683, siz=4, lab1=gl_transform_vector, lab2=, loff=0
!   reloc[115]: knd=0, off=2687, siz=4, lab1=.L286, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x0b,0x18,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "xform.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  xform.c -W0,-xp\\$XAa59JCTsd3LGaL.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCTsd3LGaL.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_xform_points_4fv\0"
	.byte 0x01,0x02,0x01,0x5a
	.uaword gl_xform_points_4fv
	.uaword .L121
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x04,0x21
	.byte 0x03,0x00,0x00,0x04,0x2d
	.ascii "n\0"
	.byte 0x01,0x58,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x04,0x5c
	.ascii "q\0"
	.byte 0x01,0x58,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x04,0x74
	.ascii "m\0"
	.byte 0x01,0x58,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x04,0x8a
	.ascii "p\0"
	.byte 0x01,0x59,0x03,0x91,0xd0,0x00,0x04
	.uaword .L16
	.uaword .L66
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0x60,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x61,0x02
	.byte 0x91,0x78,0x05
	.ascii "m4\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x61,0x02
	.byte 0x91,0x74,0x05
	.ascii "m8\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x61,0x02
	.byte 0x91,0x70,0x05
	.ascii "m12\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x61,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x62,0x02
	.byte 0x91,0x68,0x05
	.ascii "m5\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x62,0x02
	.byte 0x91,0x64,0x05
	.ascii "m9\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x62,0x02
	.byte 0x91,0x60,0x05
	.ascii "m13\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x62,0x02
	.byte 0x91,0x5c,0x04
	.uaword .L19
	.uaword .L65
	.byte 0x04
	.uaword .L24
	.uaword .L43
	.byte 0x04
	.uaword .L25
	.uaword .L42
	.byte 0x04
	.uaword .L26
	.uaword .L41
	.byte 0x04
	.uaword .L32
	.uaword .L38
	.byte 0x04
	.uaword .L33
	.uaword .L37
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x66,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x66,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x66,0x02
	.byte 0x91,0x50,0x00,0x00,0x00,0x00,0x00,0x04
	.uaword .L45
	.uaword .L64
	.byte 0x04
	.uaword .L46
	.uaword .L63
	.byte 0x04
	.uaword .L47
	.uaword .L62
	.byte 0x04
	.uaword .L53
	.uaword .L59
	.byte 0x04
	.uaword .L54
	.uaword .L58
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x6e,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x6e,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x6e,0x02
	.byte 0x91,0x50,0x05
	.ascii "p3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x6e,0x02
	.byte 0x91,0x4c,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x04
	.uaword .L67
	.uaword .L119
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0x75,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x76,0x02
	.byte 0x91,0x78,0x05
	.ascii "m6\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x76,0x02
	.byte 0x91,0x74,0x05
	.ascii "m10\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x76,0x02
	.byte 0x91,0x70,0x05
	.ascii "m14\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x76,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x77,0x02
	.byte 0x91,0x68,0x05
	.ascii "m7\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x77,0x02
	.byte 0x91,0x64,0x05
	.ascii "m11\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x77,0x02
	.byte 0x91,0x60,0x05
	.ascii "m15\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x77,0x02
	.byte 0x91,0x5c,0x04
	.uaword .L70
	.uaword .L118
	.byte 0x04
	.uaword .L77
	.uaword .L96
	.byte 0x04
	.uaword .L78
	.uaword .L95
	.byte 0x04
	.uaword .L79
	.uaword .L94
	.byte 0x04
	.uaword .L85
	.uaword .L91
	.byte 0x04
	.uaword .L86
	.uaword .L90
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x7b,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x7b,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x7b,0x02
	.byte 0x91,0x50,0x05
	.ascii "p3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x7b,0x02
	.byte 0x91,0x4c,0x00,0x00,0x00,0x00,0x00,0x04
	.uaword .L98
	.uaword .L117
	.byte 0x04
	.uaword .L99
	.uaword .L116
	.byte 0x04
	.uaword .L100
	.uaword .L115
	.byte 0x04
	.uaword .L106
	.uaword .L112
	.byte 0x04
	.uaword .L107
	.uaword .L111
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x83,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x83,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x83,0x02
	.byte 0x91,0x50,0x05
	.ascii "p3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x83,0x02
	.byte 0x91,0x4c,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x06
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x07,0x00,0x00,0x04,0x21
	.ascii "GLuint\0"
	.byte 0x02,0x06
	.ascii "float\0"
	.byte 0x04,0x04,0x06
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x04,0x3a,0x10
	.byte 0x00,0x00,0x04,0x5c,0x09,0x00,0x00,0x04
	.byte 0x43,0x03,0x00,0x0a,0x00,0x00,0x04,0x4b
	.byte 0x07,0x00,0x00,0x04,0x3a
	.ascii "GLfloat\0"
	.byte 0x02,0x0b,0x00,0x00,0x04,0x61,0x0a,0x00
	.byte 0x00,0x04,0x6f,0x08,0x00,0x00,0x04,0x3a
	.byte 0x10,0x00,0x00,0x04,0x8a,0x09,0x00,0x00
	.byte 0x04,0x43,0x03,0x00,0x0a,0x00,0x00,0x04
	.byte 0x79,0x02
	.ascii "gl_xform_points_3fv\0"
	.byte 0x01,0x02,0x01,0x93
	.uaword gl_xform_points_3fv
	.uaword .L201
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x07,0x0b
	.byte 0x03,0x00,0x00,0x04,0x2d
	.ascii "n\0"
	.byte 0x01,0x91,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x07,0x1c
	.ascii "q\0"
	.byte 0x01,0x91,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x07,0x26
	.ascii "m\0"
	.byte 0x01,0x91,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x07,0x3c
	.ascii "p\0"
	.byte 0x01,0x92,0x03,0x91,0xd0,0x00,0x04
	.uaword .L127
	.uaword .L146
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0x99,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9a,0x02
	.byte 0x91,0x78,0x05
	.ascii "m4\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9a,0x02
	.byte 0x91,0x74,0x05
	.ascii "m8\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9a,0x02
	.byte 0x91,0x70,0x05
	.ascii "m12\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9a,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9b,0x02
	.byte 0x91,0x68,0x05
	.ascii "m5\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9b,0x02
	.byte 0x91,0x64,0x05
	.ascii "m9\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9b,0x02
	.byte 0x91,0x60,0x05
	.ascii "m13\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9b,0x02
	.byte 0x91,0x5c,0x04
	.uaword .L130
	.uaword .L145
	.byte 0x04
	.uaword .L136
	.uaword .L142
	.byte 0x04
	.uaword .L137
	.uaword .L141
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9d,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9d,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0x9d,0x02
	.byte 0x91,0x50,0x00,0x00,0x00,0x00,0x04
	.uaword .L147
	.uaword .L199
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0xa3,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa4,0x02
	.byte 0x91,0x78,0x05
	.ascii "m6\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa4,0x02
	.byte 0x91,0x74,0x05
	.ascii "m10\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa4,0x02
	.byte 0x91,0x70,0x05
	.ascii "m14\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa4,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa5,0x02
	.byte 0x91,0x68,0x05
	.ascii "m7\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa5,0x02
	.byte 0x91,0x64,0x05
	.ascii "m11\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa5,0x02
	.byte 0x91,0x60,0x05
	.ascii "m15\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa5,0x02
	.byte 0x91,0x5c,0x04
	.uaword .L150
	.uaword .L198
	.byte 0x04
	.uaword .L157
	.uaword .L176
	.byte 0x04
	.uaword .L158
	.uaword .L175
	.byte 0x04
	.uaword .L159
	.uaword .L174
	.byte 0x04
	.uaword .L165
	.uaword .L171
	.byte 0x04
	.uaword .L166
	.uaword .L170
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa9,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa9,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xa9,0x02
	.byte 0x91,0x50,0x00,0x00,0x00,0x00,0x00,0x04
	.uaword .L178
	.uaword .L197
	.byte 0x04
	.uaword .L179
	.uaword .L196
	.byte 0x04
	.uaword .L180
	.uaword .L195
	.byte 0x04
	.uaword .L186
	.uaword .L192
	.byte 0x04
	.uaword .L187
	.uaword .L191
	.byte 0x05
	.ascii "p0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xb1,0x02
	.byte 0x91,0x58,0x05
	.ascii "p1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xb1,0x02
	.byte 0x91,0x54,0x05
	.ascii "p2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xb1,0x02
	.byte 0x91,0x50,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x08,0x00,0x00,0x04,0x3a,0x10
	.byte 0x00,0x00,0x07,0x1c,0x09,0x00,0x00,0x04
	.byte 0x43,0x03,0x00,0x0a,0x00,0x00,0x07,0x0b
	.byte 0x0b,0x00,0x00,0x04,0x61,0x0a,0x00,0x00
	.byte 0x07,0x21,0x08,0x00,0x00,0x04,0x3a,0x0c
	.byte 0x00,0x00,0x07,0x3c,0x09,0x00,0x00,0x04
	.byte 0x43,0x02,0x00,0x0a,0x00,0x00,0x07,0x2b
	.byte 0x02
	.ascii "gl_xform_normals_3fv\0"
	.byte 0x01,0x02,0x01,0xc5
	.uaword gl_xform_normals_3fv
	.uaword .L274
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x09,0xf2
	.byte 0x03,0x00,0x00,0x04,0x2d
	.ascii "n\0"
	.byte 0x01,0xc3,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x0a,0x03
	.ascii "v\0"
	.byte 0x01,0xc3,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x0a,0x0d
	.ascii "m\0"
	.byte 0x01,0xc3,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x0a,0x23
	.ascii "u\0"
	.byte 0x01,0xc4,0x03,0x91,0xd0,0x00,0x03,0x00
	.byte 0x00,0x0a,0x39
	.ascii "normalize\0"
	.byte 0x01,0xc4,0x03,0x91,0xd7,0x00,0x04
	.uaword .L207
	.uaword .L272
	.byte 0x04
	.uaword .L211
	.uaword .L246
	.byte 0x04
	.uaword .L212
	.uaword .L245
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0xc8,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xc9,0x02
	.byte 0x91,0x78,0x05
	.ascii "m4\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xc9,0x02
	.byte 0x91,0x74,0x05
	.ascii "m8\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xc9,0x02
	.byte 0x91,0x70,0x05
	.ascii "m1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xca,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m5\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xca,0x02
	.byte 0x91,0x68,0x05
	.ascii "m9\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xca,0x02
	.byte 0x91,0x64,0x05
	.ascii "m2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcb,0x02
	.byte 0x91,0x60,0x05
	.ascii "m6\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcb,0x02
	.byte 0x91,0x5c,0x05
	.ascii "m10\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcb,0x02
	.byte 0x91,0x58,0x04
	.uaword .L216
	.uaword .L244
	.byte 0x04
	.uaword .L222
	.uaword .L241
	.byte 0x04
	.uaword .L223
	.uaword .L240
	.byte 0x05
	.ascii "tx\0"
	.byte 0x00,0x00,0x0a,0x53,0x01,0x01,0xcd,0x02
	.byte 0x91,0x50,0x05
	.ascii "ty\0"
	.byte 0x00,0x00,0x0a,0x53,0x01,0x01,0xcd,0x02
	.byte 0x91,0x48,0x05
	.ascii "tz\0"
	.byte 0x00,0x00,0x0a,0x53,0x01,0x01,0xcd,0x02
	.byte 0x91,0x40,0x04
	.uaword .L224
	.uaword .L229
	.byte 0x05
	.ascii "ux\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcf,0x03
	.byte 0x91,0xbc,0x7f,0x05
	.ascii "uy\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcf,0x03
	.byte 0x91,0xb8,0x7f,0x05
	.ascii "uz\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xcf,0x03
	.byte 0x91,0xb4,0x7f,0x00,0x04
	.uaword .L230
	.uaword .L239
	.byte 0x05
	.ascii "len\0"
	.byte 0x00,0x00,0x0a,0x53,0x01,0x01,0xd5,0x03
	.byte 0x91,0xb8,0x7f,0x05
	.ascii "scale\0"
	.byte 0x00,0x00,0x0a,0x53,0x01,0x01,0xd5,0x03
	.byte 0x91,0xb0,0x7f,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x04
	.uaword .L248
	.uaword .L271
	.byte 0x04
	.uaword .L249
	.uaword .L270
	.byte 0x05
	.ascii "i\0"
	.byte 0x00,0x00,0x04,0x2d,0x01,0x01,0xe0,0x02
	.byte 0x91,0x7c,0x05
	.ascii "m0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe1,0x02
	.byte 0x91,0x78,0x05
	.ascii "m4\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe1,0x02
	.byte 0x91,0x74,0x05
	.ascii "m8\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe1,0x02
	.byte 0x91,0x70,0x05
	.ascii "m1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe2,0x02
	.byte 0x91,0x6c,0x05
	.ascii "m5\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe2,0x02
	.byte 0x91,0x68,0x05
	.ascii "m9\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe2,0x02
	.byte 0x91,0x64,0x05
	.ascii "m2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe3,0x02
	.byte 0x91,0x60,0x05
	.ascii "m6\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe3,0x02
	.byte 0x91,0x5c,0x05
	.ascii "m10\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe3,0x02
	.byte 0x91,0x58,0x04
	.uaword .L253
	.uaword .L269
	.byte 0x04
	.uaword .L259
	.uaword .L266
	.byte 0x04
	.uaword .L260
	.uaword .L265
	.byte 0x05
	.ascii "ux\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe5,0x02
	.byte 0x91,0x54,0x05
	.ascii "uy\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe5,0x02
	.byte 0x91,0x50,0x05
	.ascii "uz\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xe5,0x02
	.byte 0x91,0x4c,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x08,0x00,0x00,0x04,0x3a,0x0c,0x00
	.byte 0x00,0x0a,0x03,0x09,0x00,0x00,0x04,0x43
	.byte 0x02,0x00,0x0a,0x00,0x00,0x09,0xf2,0x0b
	.byte 0x00,0x00,0x04,0x61,0x0a,0x00,0x00,0x0a
	.byte 0x08,0x08,0x00,0x00,0x04,0x3a,0x0c,0x00
	.byte 0x00,0x0a,0x23,0x09,0x00,0x00,0x04,0x43
	.byte 0x02,0x00,0x0a,0x00,0x00,0x0a,0x12,0x06
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x07,0x00,0x00,0x0a,0x28
	.ascii "GLboolean\0"
	.byte 0x02,0x06
	.ascii "double\0"
	.byte 0x04,0x08,0x07,0x00,0x00,0x0a,0x49
	.ascii "GLdouble\0"
	.byte 0x02,0x02
	.ascii "gl_transform_vector\0"
	.byte 0x01,0x02,0x01,0xf9
	.uaword gl_transform_vector
	.uaword .L286
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x0a,0xeb
	.byte 0x03,0x00,0x00,0x0a,0xeb
	.ascii "u\0"
	.byte 0x01,0xf8,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x0a,0xf5
	.ascii "v\0"
	.byte 0x01,0xf8,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x0a,0xff
	.ascii "m\0"
	.byte 0x01,0xf8,0x03,0x91,0xcc,0x00,0x05
	.ascii "v0\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xfa,0x02
	.byte 0x91,0x7c,0x05
	.ascii "v1\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xfa,0x02
	.byte 0x91,0x78,0x05
	.ascii "v2\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xfa,0x02
	.byte 0x91,0x74,0x05
	.ascii "v3\0"
	.byte 0x00,0x00,0x04,0x61,0x01,0x01,0xfa,0x02
	.byte 0x91,0x70,0x00,0x0a,0x00,0x00,0x04,0x61
	.byte 0x0b,0x00,0x00,0x04,0x61,0x0a,0x00,0x00
	.byte 0x0a,0xf0,0x0b,0x00,0x00,0x04,0x61,0x0a
	.byte 0x00,0x00,0x0a,0xfa,0x0c
	.ascii "sqrt\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x0a,0x49,0x01
	.byte 0x0d,0x00,0x00,0x0a,0x49,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=106, siz=4, lab1=gl_xform_points_4fv, lab2=, loff=0
!   reloc[1]: knd=0, off=113, siz=4, lab1=.L17, lab2=, loff=0
!   reloc[2]: knd=0, off=125, siz=4, lab1=.L18, lab2=, loff=0
!   reloc[3]: knd=0, off=133, siz=4, lab1=.L21, lab2=, loff=0
!   reloc[4]: knd=0, off=141, siz=4, lab1=.L27, lab2=, loff=0
!   reloc[5]: knd=0, off=149, siz=4, lab1=.L34, lab2=, loff=0
!   reloc[6]: knd=0, off=157, siz=4, lab1=.L35, lab2=, loff=0
!   reloc[7]: knd=0, off=165, siz=4, lab1=.L36, lab2=, loff=0
!   reloc[8]: knd=0, off=173, siz=4, lab1=.L39, lab2=, loff=0
!   reloc[9]: knd=0, off=183, siz=4, lab1=.L48, lab2=, loff=0
!   reloc[10]: knd=0, off=193, siz=4, lab1=.L55, lab2=, loff=0
!   reloc[11]: knd=0, off=201, siz=4, lab1=.L56, lab2=, loff=0
!   reloc[12]: knd=0, off=209, siz=4, lab1=.L57, lab2=, loff=0
!   reloc[13]: knd=0, off=217, siz=4, lab1=.L60, lab2=, loff=0
!   reloc[14]: knd=0, off=227, siz=4, lab1=.L68, lab2=, loff=0
!   reloc[15]: knd=0, off=237, siz=4, lab1=.L69, lab2=, loff=0
!   reloc[16]: knd=0, off=245, siz=4, lab1=.L72, lab2=, loff=0
!   reloc[17]: knd=0, off=253, siz=4, lab1=.L80, lab2=, loff=0
!   reloc[18]: knd=0, off=261, siz=4, lab1=.L87, lab2=, loff=0
!   reloc[19]: knd=0, off=269, siz=4, lab1=.L88, lab2=, loff=0
!   reloc[20]: knd=0, off=277, siz=4, lab1=.L89, lab2=, loff=0
!   reloc[21]: knd=0, off=285, siz=4, lab1=.L92, lab2=, loff=0
!   reloc[22]: knd=0, off=295, siz=4, lab1=.L101, lab2=, loff=0
!   reloc[23]: knd=0, off=305, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[24]: knd=0, off=313, siz=4, lab1=.L109, lab2=, loff=0
!   reloc[25]: knd=0, off=321, siz=4, lab1=.L110, lab2=, loff=0
!   reloc[26]: knd=0, off=329, siz=4, lab1=.L113, lab2=, loff=0
!   reloc[27]: knd=0, off=339, siz=4, lab1=.L120, lab2=, loff=0
!   reloc[28]: knd=0, off=354, siz=4, lab1=gl_xform_points_3fv, lab2=, loff=0
!   reloc[29]: knd=0, off=361, siz=4, lab1=.L128, lab2=, loff=0
!   reloc[30]: knd=0, off=373, siz=4, lab1=.L129, lab2=, loff=0
!   reloc[31]: knd=0, off=381, siz=4, lab1=.L131, lab2=, loff=0
!   reloc[32]: knd=0, off=389, siz=4, lab1=.L138, lab2=, loff=0
!   reloc[33]: knd=0, off=397, siz=4, lab1=.L139, lab2=, loff=0
!   reloc[34]: knd=0, off=405, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[35]: knd=0, off=413, siz=4, lab1=.L143, lab2=, loff=0
!   reloc[36]: knd=0, off=423, siz=4, lab1=.L148, lab2=, loff=0
!   reloc[37]: knd=0, off=433, siz=4, lab1=.L149, lab2=, loff=0
!   reloc[38]: knd=0, off=441, siz=4, lab1=.L152, lab2=, loff=0
!   reloc[39]: knd=0, off=449, siz=4, lab1=.L160, lab2=, loff=0
!   reloc[40]: knd=0, off=457, siz=4, lab1=.L167, lab2=, loff=0
!   reloc[41]: knd=0, off=465, siz=4, lab1=.L168, lab2=, loff=0
!   reloc[42]: knd=0, off=473, siz=4, lab1=.L169, lab2=, loff=0
!   reloc[43]: knd=0, off=481, siz=4, lab1=.L172, lab2=, loff=0
!   reloc[44]: knd=0, off=491, siz=4, lab1=.L181, lab2=, loff=0
!   reloc[45]: knd=0, off=501, siz=4, lab1=.L188, lab2=, loff=0
!   reloc[46]: knd=0, off=509, siz=4, lab1=.L189, lab2=, loff=0
!   reloc[47]: knd=0, off=517, siz=4, lab1=.L190, lab2=, loff=0
!   reloc[48]: knd=0, off=525, siz=4, lab1=.L193, lab2=, loff=0
!   reloc[49]: knd=0, off=535, siz=4, lab1=.L200, lab2=, loff=0
!   reloc[50]: knd=0, off=550, siz=4, lab1=gl_xform_normals_3fv, lab2=, loff=0
!   reloc[51]: knd=0, off=557, siz=4, lab1=.L209, lab2=, loff=0
!   reloc[52]: knd=0, off=569, siz=4, lab1=.L213, lab2=, loff=0
!   reloc[53]: knd=0, off=579, siz=4, lab1=.L214, lab2=, loff=0
!   reloc[54]: knd=0, off=587, siz=4, lab1=.L215, lab2=, loff=0
!   reloc[55]: knd=0, off=595, siz=4, lab1=.L217, lab2=, loff=0
!   reloc[56]: knd=0, off=603, siz=4, lab1=.L225, lab2=, loff=0
!   reloc[57]: knd=0, off=613, siz=4, lab1=.L226, lab2=, loff=0
!   reloc[58]: knd=0, off=621, siz=4, lab1=.L227, lab2=, loff=0
!   reloc[59]: knd=0, off=629, siz=4, lab1=.L228, lab2=, loff=0
!   reloc[60]: knd=0, off=637, siz=4, lab1=.L231, lab2=, loff=0
!   reloc[61]: knd=0, off=647, siz=4, lab1=.L232, lab2=, loff=0
!   reloc[62]: knd=0, off=655, siz=4, lab1=.L236, lab2=, loff=0
!   reloc[63]: knd=0, off=663, siz=4, lab1=.L237, lab2=, loff=0
!   reloc[64]: knd=0, off=671, siz=4, lab1=.L238, lab2=, loff=0
!   reloc[65]: knd=0, off=679, siz=4, lab1=.L242, lab2=, loff=0
!   reloc[66]: knd=0, off=689, siz=4, lab1=.L250, lab2=, loff=0
!   reloc[67]: knd=0, off=699, siz=4, lab1=.L251, lab2=, loff=0
!   reloc[68]: knd=0, off=707, siz=4, lab1=.L252, lab2=, loff=0
!   reloc[69]: knd=0, off=715, siz=4, lab1=.L254, lab2=, loff=0
!   reloc[70]: knd=0, off=723, siz=4, lab1=.L261, lab2=, loff=0
!   reloc[71]: knd=0, off=731, siz=4, lab1=.L262, lab2=, loff=0
!   reloc[72]: knd=0, off=739, siz=4, lab1=.L263, lab2=, loff=0
!   reloc[73]: knd=0, off=747, siz=4, lab1=.L264, lab2=, loff=0
!   reloc[74]: knd=0, off=755, siz=4, lab1=.L267, lab2=, loff=0
!   reloc[75]: knd=0, off=765, siz=4, lab1=.L273, lab2=, loff=0
!   reloc[76]: knd=0, off=780, siz=4, lab1=gl_transform_vector, lab2=, loff=0
!   reloc[77]: knd=0, off=787, siz=4, lab1=.L280, lab2=, loff=0
!   reloc[78]: knd=0, off=799, siz=4, lab1=.L281, lab2=, loff=0
!   reloc[79]: knd=0, off=807, siz=4, lab1=.L282, lab2=, loff=0
!   reloc[80]: knd=0, off=815, siz=4, lab1=.L283, lab2=, loff=0
!   reloc[81]: knd=0, off=823, siz=4, lab1=.L284, lab2=, loff=0
!   reloc[82]: knd=0, off=831, siz=4, lab1=.L285, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x03,0x45,0x00,0x02,0x00,0x00
	.byte 0x00,0x5d,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x2e,0x63,0x00,0x01,0x00,0x00,0x67,0x6c
	.byte 0x2e,0x68,0x00,0x02,0x00,0x00,0x00,0x00
	.byte 0x05,0x02
	.uaword gl_xform_points_4fv
	.byte 0x00,0x05,0x02
	.uaword .L17
	.byte 0x06,0x03,0xe0,0x00,0x01,0x00,0x05,0x02
	.uaword .L18
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L21
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L27
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L34
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L35
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L36
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L39
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L48
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L55
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L56
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L57
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L60
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L68
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L69
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L72
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L80
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L87
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L88
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L89
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L92
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L101
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L108
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L109
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L110
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L113
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L120
	.byte 0x03,0x07,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_xform_points_3fv
	.byte 0x00,0x05,0x02
	.uaword .L128
	.byte 0x06,0x03,0x99,0x01,0x01,0x00,0x05,0x02
	.uaword .L129
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L138
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L139
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L143
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L148
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L149
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L152
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L160
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L169
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L172
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L181
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L188
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L189
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L190
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L193
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L200
	.byte 0x03,0x07,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_xform_normals_3fv
	.byte 0x00,0x05,0x02
	.uaword .L209
	.byte 0x06,0x03,0xc5,0x01,0x01,0x00,0x05,0x02
	.uaword .L213
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L214
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L217
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L225
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L226
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L228
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L231
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L232
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L237
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L238
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L242
	.byte 0x03,0x72,0x01,0x00,0x05,0x02
	.uaword .L250
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L251
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L252
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L254
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L261
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L262
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L263
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L264
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L267
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L273
	.byte 0x03,0x07,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_transform_vector
	.byte 0x00,0x05,0x02
	.uaword .L280
	.byte 0x06,0x03,0xf9,0x01,0x01,0x00,0x05,0x02
	.uaword .L281
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L283
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L285
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x04,0x0b,0x01,0x11,0x01,0x12,0x01,0x00
	.byte 0x00,0x05,0x34,0x00,0x03,0x08,0x49,0x13
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a
	.byte 0x00,0x00,0x06,0x24,0x00,0x03,0x08,0x3e
	.byte 0x0b,0x0b,0x0b,0x00,0x00,0x07,0x16,0x00
	.byte 0x49,0x13,0x03,0x08,0x3a,0x0b,0x00,0x00
	.byte 0x08,0x01,0x01,0x49,0x13,0x0b,0x0b,0x01
	.byte 0x13,0x00,0x00,0x09,0x21,0x00,0x49,0x13
	.byte 0x2f,0x0b,0x00,0x00,0x0a,0x0f,0x00,0x49
	.byte 0x13,0x00,0x00,0x0b,0x26,0x00,0x49,0x13
	.byte 0x00,0x00,0x0c,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x3c,0x0c,0x27,0x0c,0x49,0x13,0x88
	.byte 0x44,0x0b,0x00,0x00,0x0d,0x05,0x00,0x49
	.byte 0x13,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x70,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x0b,0x1c,0x00,0x00,0x01,0x01
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f
	.byte 0x34,0x66,0x76,0x00,0x00,0x00,0x04,0x8f
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f
	.byte 0x33,0x66,0x76,0x00,0x00,0x00,0x07,0x41
	.byte 0x67,0x6c,0x5f,0x78,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x6e,0x6f,0x72,0x6d,0x61,0x6c,0x73
	.byte 0x5f,0x33,0x66,0x76,0x00,0x00,0x00,0x0a
	.byte 0x62,0x67,0x6c,0x5f,0x74,0x72,0x61,0x6e
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
	.byte 0x00,0x00,0x0b,0x1c,0x00,0x00,0x04,0x2d
	.byte 0x47,0x4c,0x75,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x04,0x61,0x47,0x4c,0x66,0x6c,0x6f
	.byte 0x61,0x74,0x00,0x00,0x00,0x0a,0x39,0x47
	.byte 0x4c,0x62,0x6f,0x6f,0x6c,0x65,0x61,0x6e
	.byte 0x00,0x00,0x00,0x0a,0x53,0x47,0x4c,0x64
	.byte 0x6f,0x75,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
