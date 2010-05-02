
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	gl_init_eval
	.type	gl_init_eval,#function
gl_init_eval:
	save	%sp,-96,%sp

	! block 1
.L13:
.L14:
.L17:
.L19:

! File eval.c:
!    1	/* $Id: eval.c,v 1.8 1997/07/24 01:25:01 brianp Exp $ */
!    2	
!    3	/*
!    4	 * Mesa 3-D graphics library
!    5	 * Version:  2.4
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
!   25	 * $Log: eval.c,v $
!   26	 * Revision 1.8  1997/07/24 01:25:01  brianp
!   27	 * changed precompiled header symbol from PCH to PC_HEADER
!   28	 *
!   29	 * Revision 1.7  1997/06/20 01:58:47  brianp
!   30	 * changed color components from GLfixed to GLubyte
!   31	 *
!   32	 * Revision 1.6  1997/05/28 03:24:22  brianp
!   33	 * added precompiled header (PCH) support
!   34	 *
!   35	 * Revision 1.5  1997/05/14 03:27:04  brianp
!   36	 * removed context argument from gl_init_eval()
!   37	 *
!   38	 * Revision 1.4  1997/05/01 01:38:38  brianp
!   39	 * use NORMALIZE_3FV() from mmath.h instead of private NORMALIZE() macro
!   40	 *
!   41	 * Revision 1.3  1997/04/02 03:10:58  brianp
!   42	 * changed some #include's
!   43	 *
!   44	 * Revision 1.2  1996/09/15 14:17:30  brianp
!   45	 * now use GLframebuffer and GLvisual
!   46	 *
!   47	 * Revision 1.1  1996/09/13 01:38:16  brianp
!   48	 * Initial revision
!   49	 *
!   50	 */
!   51	
!   53	/*
!   54	 * eval.c was written by
!   55	 * Bernd Barsuhn (bdbarsuh@cip.informatik.uni-erlangen.de) and
!   56	 * Volker Weiss (vrweiss@cip.informatik.uni-erlangen.de).
!   57	 *
!   58	 * My original implementation of evaluators was simplistic and didn't
!   59	 * compute surface normal vectors properly.  Bernd and Volker applied
!   60	 * used more sophisticated methods to get better results.
!   61	 *
!   62	 * Thanks guys!
!   63	 */
!   64	
!   66	#ifdef PC_HEADER
!   67	#include "all.h"
!   68	#else
!   69	#include <math.h>
!   70	#include <stdlib.h>
!   71	#include <string.h>
!   72	#include "context.h"
!   73	#include "eval.h"
!   74	#include "dlist.h"
!   75	#include "macros.h"
!   76	#include "mmath.h"
!   77	#include "types.h"
!   78	#include "vbfill.h"
!   79	#endif
!   80	
!   83	/*
!   84	 * Do one-time initialization for evaluators.
!   85	 */
!   86	void gl_init_eval( void )
!   87	{
!   88	  static int init_flag = 0;
!   89	
!   90	  /* Compute a table of nCr (combination) values used by the
!   91	   * Bernstein polynomial generator.
!   92	   */
!   93	
!   94	  if (init_flag==0) 

	sethi	%hi($XBa59JCRsd3LWyK.gl_init_eval.init_flag),%l0
	ld	[%l0+%lo($XBa59JCRsd3LWyK.gl_init_eval.init_flag)],%l0
	cmp	%l0,0
	bne	.L18
	nop

	! block 2
.L20:
.L21:
.L22:
.L23:
.L24:
.L18:
.L25:
.L26:

!   95	  { /* no initialization needed */ 
!   96	  }
!   97	
!   98	  init_flag = 1;

	mov	1,%l1
	sethi	%hi($XBa59JCRsd3LWyK.gl_init_eval.init_flag),%l0
	st	%l1,[%l0+%lo($XBa59JCRsd3LWyK.gl_init_eval.init_flag)]

	! block 3
.L27:
.L28:
.L12:
	jmp	%i7+8
	restore
	.size	gl_init_eval,(.-gl_init_eval)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	horner_bezier_curve,#function
horner_bezier_curve:
	save	%sp,-128,%sp

	! block 1
.L31:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]

	! block 2
.L32:
.L34:
.L36:

! File eval.c:
!   99	}
!  100	
!  103	/*
!  104	 * Horner scheme for Bezier curves
!  105	 * 
!  106	 * Bezier curves can be computed via a Horner scheme.
!  107	 * Horner is numerically less stable than the de Casteljau
!  108	 * algorithm, but it is faster. For curves of degree n 
!  109	 * the complexity of Horner is O(n) and de Casteljau is O(n^2).
!  110	 * Since stability is not important for displaying curve 
!  111	 * points I decided to use the Horner scheme.
!  112	 *
!  113	 * A cubic Bezier curve with control points b0, b1, b2, b3 can be 
!  114	 * written as
!  115	 *
!  116	 *        (([3]        [3]     )     [3]       )     [3]
!  117	 * c(t) = (([0]*s*b0 + [1]*t*b1)*s + [2]*t^2*b2)*s + [3]*t^2*b3
!  118	 *
!  119	 *                                           [n]
!  120	 * where s=1-t and the binomial coefficients [i]. These can 
!  121	 * be computed iteratively using the identity:
!  122	 *
!  123	 * [n]               [n  ]             [n]
!  124	 * [i] = (n-i+1)/i * [i-1]     and     [0] = 1
!  125	 */
!  126	
!  127	static void
!  128	horner_bezier_curve(GLfloat *cp, GLfloat *out, GLfloat t,
!  129	                    GLuint dim, GLuint order)
!  130	{
!  131	  GLfloat s, powert;
!  132	  GLuint i, k, bincoeff;
!  133	
!  134	  if(order >= 2)

	ld	[%fp+84],%l0
	cmp	%l0,2
	blu	.L35
	nop

	! block 3
.L37:
.L38:
.L39:
.L40:

!  135	  { 
!  136	    bincoeff = order-1;

	ld	[%fp+84],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-20]

	! block 4
.L41:

!  137	    s = 1.0-t;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f6
	ld	[%fp+76],%f4
	fstod	%f4,%f4
	fsubd	%f6,%f4,%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-4]

	! block 5
.L42:
.L43:

!  139	    for(k=0; k<dim; k++)

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bgeu	.L46
	st	%g0,[%fp-16]

	! block 6
.L_y39:
	mov	0,%l5
	sethi	%hi(0x43300000),%l4
.L47:
.L44:
.L48:
.L49:

!  140	      out[k] = s*cp[k] + bincoeff*t*cp[dim+k];

	ld	[%fp-4],%f5
	ld	[%fp+68],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f8
	ld	[%fp-20],%l0
	st	%l4,[%fp-32]
	st	%l0,[%fp-28]
	ldd	[%fp-32],%f6
	st	%l5,[%fp-28]
	ldd	[%fp-32],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+76],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l3
	ld	[%fp+80],%l0
	ld	[%fp-16],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f8,%f4,%f4
	ld	[%fp+72],%l0
	sll	%l2,2,%l1
	st	%f4,[%l0+%l1]

	! block 7
.L50:
.L51:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	blu	.L44
	nop

	! block 8
.L52:
.L46:
.L53:
.L54:
.L55:

!  142	    for(i=2, cp+=2*dim, powert=t*t; i<order; i++, powert*=t, cp +=dim)

	mov	2,%l0
	st	%l0,[%fp-12]
	ld	[%fp+68],%l2
	ld	[%fp+80],%l0
	sll	%l0,1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+68]
	ld	[%fp+76],%f4
	fmuls	%f4,%f4,%f4
	st	%f4,[%fp-8]
	mov	2,%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	bgeu	.L58
	nop

	! block 9
.L59:
.L56:
.L60:
.L61:
.L62:

!  143	    {
!  144	      bincoeff *= order-i;

	ld	[%fp-20],%l2
	ld	[%fp+84],%l0
	ld	[%fp-12],%l1
	sub	%l0,%l1,%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 10
.L63:

!  145	      bincoeff /= i;

	ld	[%fp-20],%l0
	ld	[%fp-12],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 11
.L64:
.L65:

!  147	      for(k=0; k<dim; k++)

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bgeu	.L68
	st	%g0,[%fp-16]

	! block 12
.L_y40:
	mov	0,%l3
	sethi	%hi(0x43300000),%l4
.L69:
.L66:
.L70:
.L71:

!  148	        out[k] = s*out[k] + bincoeff*powert*cp[k];

	ld	[%fp-4],%f5
	ld	[%fp+72],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f8
	ld	[%fp-20],%l0
	st	%l4,[%fp-32]
	st	%l0,[%fp-28]
	ldd	[%fp-32],%f6
	st	%l3,[%fp-28]
	ldd	[%fp-32],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-8],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l1
	ld	[%fp-16],%l0
	sll	%l0,2,%l2
	ld	[%l1+%l2],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f8,%f4,%f4
	ld	[%fp+72],%l0
	st	%f4,[%l0+%l2]

	! block 13
.L72:
.L73:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	blu	.L66
	nop

	! block 14
.L74:
.L68:
.L75:
.L76:
.L77:
.L78:
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]
	ld	[%fp-8],%f5
	ld	[%fp+76],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-8]
	ld	[%fp+68],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+68]
	ld	[%fp-12],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	blu	.L56
	nop

	! block 15
.L79:
.L58:
.L80:
.L81:
.L82:
	ba	.L83
	nop

	! block 16
.L35:
.L84:
.L85:
.L86:
.L87:

!  149	    }
!  150	  }
!  151	  else /* order=1 -> constant curve */
!  152	  { 
!  153	    for(k=0; k<dim; k++)

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bgeu	.L90
	st	%g0,[%fp-16]

	! block 17
.L91:
.L88:
.L92:
.L93:

!  154	      out[k] = cp[k];

	ld	[%fp+68],%l1
	ld	[%fp-16],%l0
	sll	%l0,2,%l2
	ld	[%l1+%l2],%f4
	ld	[%fp+72],%l0
	st	%f4,[%l0+%l2]

	! block 18
.L94:
.L95:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	blu	.L88
	nop

	! block 19
.L96:
.L90:
.L97:
.L98:
.L99:
.L83:
.L100:

	! block 20
.L101:
.L102:
.L30:
	jmp	%i7+8
	restore
	.size	horner_bezier_curve,(.-horner_bezier_curve)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	horner_bezier_surf,#function
horner_bezier_surf:
	save	%sp,-144,%sp

	! block 1
.L105:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]

	! block 2
.L106:
.L108:

! File eval.c:
!  155	  } 
!  156	}
!  157	
!  158	/*
!  159	 * Tensor product Bezier surfaces
!  160	 *
!  161	 * Again the Horner scheme is used to compute a point on a 
!  162	 * TP Bezier surface. First a control polygon for a curve
!  163	 * on the surface in one parameter direction is computed,
!  164	 * then the point on the curve for the other parameter 
!  165	 * direction is evaluated.
!  166	 *
!  167	 * To store the curve control polygon additional storage
!  168	 * for max(uorder,vorder) points is needed in the 
!  169	 * control net cn.
!  170	 */
!  171	
!  172	static void
!  173	horner_bezier_surf(GLfloat *cn, GLfloat *out, GLfloat u, GLfloat v,
!  174	                   GLuint dim, GLuint uorder, GLuint vorder)
!  175	{
!  176	  GLfloat *cp = cn + uorder*vorder*dim;

	ld	[%fp+68],%l2
	ld	[%fp+88],%l0
	ld	[%fp+92],%l1
	smul	%l0,%l1,%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-4]

	! block 3
.L109:

!  177	  GLuint i, uinc = vorder*dim;

	ld	[%fp+92],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L110:
.L112:

!  179	  if(vorder > uorder)

	ld	[%fp+92],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bleu	.L111
	nop

	! block 5
.L113:
.L114:
.L115:
.L116:
.L118:

!  180	  {
!  181	    if(uorder >= 2)

	ld	[%fp+88],%l0
	cmp	%l0,2
	blu	.L117
	nop

	! block 6
.L119:
.L120:
.L121:
.L122:
.L123:

!  182	    { 
!  183	      GLfloat s, poweru;
!  184	      GLuint j, k, bincoeff;
!  185	
!  186	      /* Compute the control polygon for the surface-curve in u-direction */
!  187	      for(j=0; j<vorder; j++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L126
	st	%g0,[%fp-24]

	! block 7
.L127:
.L124:
.L128:
.L129:
.L130:

!  188	      {
!  189	        GLfloat *ucp = &cn[j*dim];

	ld	[%fp+68],%l2
	ld	[%fp-24],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-36]

	! block 8
.L131:

!  191	        /* Each control point is the point for parameter u on a */ 
!  192	        /* curve defined by the control polygons in u-direction */
!  193		bincoeff = uorder-1;

	ld	[%fp+88],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-32]

	! block 9
.L132:

!  194		s = 1.0-u;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f6
	ld	[%fp+76],%f4
	fstod	%f4,%f4
	fsubd	%f6,%f4,%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-16]

	! block 10
.L133:
.L134:

!  196		for(k=0; k<dim; k++)

	ld	[%fp+84],%l0
	cmp	%g0,%l0
	bgeu	.L137
	st	%g0,[%fp-28]

	! block 11
.L_y41:
	mov	0,%l5
	sethi	%hi(0x43300000),%l4
.L138:
.L135:
.L139:
.L140:

!  197		  cp[j*dim+k] = s*ucp[k] + bincoeff*u*ucp[uinc+k];

	ld	[%fp-16],%f5
	ld	[%fp-36],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f8
	ld	[%fp-32],%l0
	st	%l4,[%fp-48]
	st	%l0,[%fp-44]
	ldd	[%fp-48],%f6
	st	%l5,[%fp-44]
	ldd	[%fp-48],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+76],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp-36],%l3
	ld	[%fp-12],%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f8,%f4,%f4
	ld	[%fp-4],%l3
	ld	[%fp-24],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 12
.L141:
.L142:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	blu	.L135
	nop

	! block 13
.L143:
.L137:
.L144:
.L145:
.L146:

!  199		for(i=2, ucp+=2*uinc, poweru=u*u; i<uorder; 

	mov	2,%l0
	st	%l0,[%fp-8]
	ld	[%fp-36],%l2
	ld	[%fp-12],%l0
	sll	%l0,1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-36]
	ld	[%fp+76],%f4
	fmuls	%f4,%f4,%f4
	st	%f4,[%fp-20]
	mov	2,%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bgeu	.L149
	nop

	! block 14
.L150:
.L147:
.L151:
.L152:
.L153:

!  200	            i++, poweru*=u, ucp +=uinc)
!  201		{
!  202		  bincoeff *= uorder-i;

	ld	[%fp-32],%l2
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	sub	%l0,%l1,%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-32]

	! block 15
.L154:

!  203	          bincoeff /= i;

	ld	[%fp-32],%l0
	ld	[%fp-8],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 16
.L155:
.L156:

!  205		  for(k=0; k<dim; k++)

	ld	[%fp+84],%l0
	cmp	%g0,%l0
	bgeu	.L159
	st	%g0,[%fp-28]

	! block 17
.L_y42:
	mov	0,%l5
	sethi	%hi(0x43300000),%l4
.L160:
.L157:
.L161:
.L162:

!  206		    cp[j*dim+k] = s*cp[j*dim+k] + bincoeff*poweru*ucp[k];

	ld	[%fp-16],%f5
	ld	[%fp-4],%l2
	ld	[%fp-24],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-28],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f8
	ld	[%fp-32],%l0
	st	%l4,[%fp-48]
	st	%l0,[%fp-44]
	ldd	[%fp-48],%f6
	st	%l5,[%fp-44]
	ldd	[%fp-48],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-20],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp-36],%l2
	ld	[%fp-28],%l3
	sll	%l3,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f8,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-24],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	add	%l0,%l3,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 18
.L163:
.L164:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	blu	.L157
	nop

	! block 19
.L165:
.L159:
.L166:
.L167:
.L168:
.L169:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-20],%f5
	ld	[%fp+76],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-20]
	ld	[%fp-36],%l2
	ld	[%fp-12],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-36]

	! block 20
.L170:
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	blu	.L147
	nop

	! block 21
.L171:
.L149:
.L172:
.L173:
.L174:
.L175:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L124
	nop

	! block 22
.L176:
.L126:
.L177:
.L178:

!  207		}
!  208	      }
!  209	        
!  210	      /* Evaluate curve point in v */
!  211	      horner_bezier_curve(cp, out, v, dim, vorder);

	ld	[%fp-4],%l0
	ld	[%fp+72],%l1
	ld	[%fp+80],%f4
	ld	[%fp+84],%l2
	ld	[%fp+92],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	%l2,%o3
	call	horner_bezier_curve
	mov	%l3,%o4

	! block 23
.L179:
.L180:
	ba	.L181
	nop

	! block 24
.L117:
.L182:
.L183:

!  212	    }
!  213	    else /* uorder=1 -> cn defines a curve in v */
!  214	      horner_bezier_curve(cn, out, v, dim, vorder);

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+80],%f4
	ld	[%fp+84],%l2
	ld	[%fp+92],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	%l2,%o3
	call	horner_bezier_curve
	mov	%l3,%o4

	! block 25
.L184:
.L181:
.L185:
.L186:
.L187:
	ba	.L188
	nop

	! block 26
.L111:
.L189:
.L190:
.L191:
.L193:

!  215	  }
!  216	  else /* vorder <= uorder */
!  217	  {
!  218	    if(vorder > 1)

	ld	[%fp+92],%l0
	cmp	%l0,1
	bleu	.L192
	nop

	! block 27
.L194:
.L195:
.L196:
.L197:
.L198:

!  219	    {
!  220	      GLuint i;
!  221	
!  222	      /* Compute the control polygon for the surface-curve in u-direction */
!  223	      for(i=0; i<uorder; i++, cn += uinc)

	ld	[%fp+88],%l0
	cmp	%g0,%l0
	bgeu	.L201
	st	%g0,[%fp-16]

	! block 28
.L202:
.L199:
.L203:
.L204:
.L205:

!  224	      {
!  225		/* For constant i all cn[i][j] (j=0..vorder) are located */
!  226		/* on consecutive memory locations, so we can use        */
!  227		/* horner_bezier_curve to compute the control points     */
!  228	
!  229		horner_bezier_curve(cn, &cp[i*dim], v, dim, vorder);

	ld	[%fp+68],%l5
	ld	[%fp-4],%l3
	ld	[%fp-16],%l0
	ld	[%fp+84],%l2
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	add	%l3,%l1,%l0
	ld	[%fp+80],%f4
	ld	[%fp+92],%l1
	mov	%l5,%o0
	mov	%l0,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	%l2,%o3
	call	horner_bezier_curve
	mov	%l1,%o4

	! block 29
.L206:
.L207:
.L208:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp+68],%l2
	ld	[%fp-12],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+68]
	ld	[%fp-16],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	blu	.L199
	nop

	! block 30
.L209:
.L201:
.L210:
.L211:

!  230	      }
!  231	
!  232	      /* Evaluate curve point in u */
!  233	      horner_bezier_curve(cp, out, u, dim, uorder);

	ld	[%fp-4],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%f4
	ld	[%fp+84],%l2
	ld	[%fp+88],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	%l2,%o3
	call	horner_bezier_curve
	mov	%l3,%o4

	! block 31
.L212:
.L213:
	ba	.L214
	nop

	! block 32
.L192:
.L215:
.L216:

!  234	    }
!  235	    else  /* vorder=1 -> cn defines a curve in u */
!  236	      horner_bezier_curve(cn, out, u, dim, uorder);

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%f4
	ld	[%fp+84],%l2
	ld	[%fp+88],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	%l2,%o3
	call	horner_bezier_curve
	mov	%l3,%o4

	! block 33
.L217:
.L214:
.L218:
.L219:
.L220:
.L188:
.L221:

	! block 34
.L222:
.L223:
.L104:
	jmp	%i7+8
	restore
	.size	horner_bezier_surf,(.-horner_bezier_surf)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	de_casteljau_surf,#function
de_casteljau_surf:
	save	%sp,-192,%sp

	! block 1
.L226:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]
	ld	[%fp+96],%l0
	st	%l0,[%fp+96]
	ld	[%fp+100],%l0
	st	%l0,[%fp+100]

	! block 2
.L227:
.L229:

! File eval.c:
!  237	  }
!  238	}
!  239	
!  240	/*
!  241	 * The direct de Casteljau algorithm is used when a point on the
!  242	 * surface and the tangent directions spanning the tangent plane
!  243	 * should be computed (this is needed to compute normals to the
!  244	 * surface). In this case the de Casteljau algorithm approach is
!  245	 * nicer because a point and the partial derivatives can be computed 
!  246	 * at the same time. To get the correct tangent length du and dv
!  247	 * must be multiplied with the (u2-u1)/uorder-1 and (v2-v1)/vorder-1. 
!  248	 * Since only the directions are needed, this scaling step is omitted.
!  249	 *
!  250	 * De Casteljau needs additional storage for uorder*vorder
!  251	 * values in the control net cn.
!  252	 */
!  253	
!  254	static void
!  255	de_casteljau_surf(GLfloat *cn, GLfloat *out, GLfloat *du, GLfloat *dv,
!  256	                  GLfloat u, GLfloat v, GLuint dim, 
!  257	                  GLuint uorder, GLuint vorder)
!  258	{
!  259	  GLfloat *dcn = cn + uorder*vorder*dim;

	ld	[%fp+68],%l2
	ld	[%fp+96],%l0
	ld	[%fp+100],%l1
	smul	%l0,%l1,%l0
	ld	[%fp+92],%l1
	smul	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-4]

	! block 3
.L230:

!  260	  GLfloat us = 1.0-u, vs = 1.0-v;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f6
	ld	[%fp+84],%f4
	fstod	%f4,%f4
	fsubd	%f6,%f4,%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-8]
	ldd	[%l0+%lo(.L_cseg0)],%f6
	ld	[%fp+88],%f4
	fstod	%f4,%f4
	fsubd	%f6,%f4,%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-12]

	! block 4
.L231:

!  261	  GLuint h, i, j, k;
!  262	  GLuint minorder = uorder < vorder ? uorder : vorder;

	ld	[%fp+96],%l1
	ld	[%fp+100],%l0
	cmp	%l1,%l0
	bgeu	.L232
	nop

	! block 5
.L233:
	ld	[%fp+96],%l0
	ba	.L234
	st	%l0,[%fp-36]

	! block 6
.L232:
	ld	[%fp+100],%l0
	st	%l0,[%fp-36]

	! block 7
.L234:
	ld	[%fp-36],%l0
	st	%l0,[%fp-32]

	! block 8
.L235:

!  263	  GLuint uinc = vorder*dim;

	ld	[%fp+100],%l0
	ld	[%fp+92],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 9
.L236:

!  264	  GLuint dcuinc = vorder;

	ld	[%fp+100],%l0
	st	%l0,[%fp-44]

	! block 10
.L237:
.L239:

!  265	 
!  266	  /* Each component is evaluated separately to save buffer space  */
!  267	  /* This does not drasticaly decrease the performance of the     */
!  268	  /* algorithm. If additional storage for (uorder-1)*(vorder-1)   */
!  269	  /* points would be available, the components could be accessed  */
!  270	  /* in the innermost loop which could lead to less cache misses. */
!  271	
!  272	#define CN(I,J,K) cn[(I)*uinc+(J)*dim+(K)] 
!  273	#define DCN(I, J) dcn[(I)*dcuinc+(J)]
!  274	  if(minorder < 3)

	ld	[%fp-32],%l0
	cmp	%l0,3
	bgeu	.L238
	nop

	! block 11
.L240:
.L241:
.L242:
.L243:
.L245:

!  275	  {
!  276	    if(uorder==vorder)

	ld	[%fp+96],%l1
	ld	[%fp+100],%l0
	cmp	%l1,%l0
	bne	.L244
	nop

	! block 12
.L246:
.L247:
.L248:
.L249:
.L250:

!  277	    {
!  278	      for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L253
	st	%g0,[%fp-28]

	! block 13
.L254:
.L251:
.L255:
.L256:
.L257:

!  279	      {
!  280		/* Derivative direction in u */
!  281		du[k] = vs*(CN(1,0,k) - CN(0,0,k)) +
!  282		         v*(CN(1,1,k) - CN(0,1,k));

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	st	%g0,[%fp-56]
	st	%g0,[%fp-60]
	ld	[%fp-12],%f6
	ld	[%fp+68],%l5
	ld	[%fp-40],%l3
	ld	[%fp-48],%l1
	add	%l3,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f5
	ld	[%fp-52],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f7
	ld	[%fp+88],%f6
	ld	[%fp+92],%l4
	add	%l3,%l4,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f5
	add	%l4,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f7,%f4,%f4
	ld	[%fp+76],%l0
	sll	%l2,2,%l1
	st	%f4,[%l0+%l1]

	! block 14
.L258:

!  284		/* Derivative direction in v */
!  285		dv[k] = us*(CN(0,1,k) - CN(0,0,k)) + 
!  286		         u*(CN(1,1,k) - CN(1,0,k));

	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	st	%g0,[%fp-72]
	st	%g0,[%fp-76]
	ld	[%fp-8],%f6
	ld	[%fp+68],%l5
	ld	[%fp-64],%l0
	ld	[%fp+92],%l3
	add	%l0,%l3,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f5
	ld	[%fp-68],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f7
	ld	[%fp+84],%f6
	ld	[%fp-40],%l4
	add	%l4,%l3,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f5
	add	%l4,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f7,%f4,%f4
	ld	[%fp+80],%l0
	sll	%l2,2,%l1
	st	%f4,[%l0+%l1]

	! block 15
.L259:

!  288		/* bilinear de Casteljau step */
!  289	        out[k] =  us*(vs*CN(0,0,k) + v*CN(0,1,k)) +
!  290		           u*(vs*CN(1,0,k) + v*CN(1,1,k));

	st	%g0,[%fp-80]
	st	%g0,[%fp-84]
	st	%g0,[%fp-88]
	st	%g0,[%fp-92]
	ld	[%fp-8],%f6
	ld	[%fp-12],%f7
	ld	[%fp+68],%l5
	ld	[%fp-80],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f7,%f4,%f5
	ld	[%fp+88],%f8
	ld	[%fp-88],%l0
	ld	[%fp+92],%l3
	add	%l0,%l3,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f8,%f4,%f4
	fadds	%f5,%f4,%f4
	fmuls	%f6,%f4,%f9
	ld	[%fp+84],%f6
	ld	[%fp-40],%l4
	add	%l4,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f7,%f4,%f5
	add	%l4,%l3,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f8,%f4,%f4
	fadds	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f9,%f4,%f4
	ld	[%fp+72],%l0
	sll	%l2,2,%l1
	st	%f4,[%l0+%l1]

	! block 16
.L260:
.L261:
.L262:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L251
	nop

	! block 17
.L263:
.L253:
.L264:
.L265:
.L266:
	ba	.L267
	nop

	! block 18
.L244:
.L268:
.L269:
.L271:

!  291	      }
!  292	    }
!  293	    else if(minorder == uorder)

	ld	[%fp-32],%l1
	ld	[%fp+96],%l0
	cmp	%l1,%l0
	bne	.L270
	nop

	! block 19
.L272:
.L273:
.L274:
.L275:
.L276:

!  294	    {
!  295	      for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L279
	st	%g0,[%fp-28]

	! block 20
.L280:
.L277:
.L281:
.L282:
.L283:

!  296	      {
!  297		/* bilinear de Casteljau step */
!  298		DCN(1,0) =    CN(1,0,k) -   CN(0,0,k);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	st	%g0,[%fp-56]
	ld	[%fp+68],%l3
	ld	[%fp-40],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%fp-52],%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 21
.L284:

!  299		DCN(0,0) = us*CN(0,0,k) + u*CN(1,0,k);

	st	%g0,[%fp-60]
	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	st	%g0,[%fp-72]
	ld	[%fp-8],%f5
	ld	[%fp+68],%l3
	ld	[%fp-64],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-40],%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-60],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 22
.L285:
.L286:

!  301		for(j=0; j<vorder-1; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L289
	nop

	! block 23
.L290:
.L287:
.L291:
.L292:
.L293:

!  302		{
!  303		  /* for the derivative in u */
!  304		  DCN(1,j+1) =    CN(1,j+1,k) -   CN(0,j+1,k);

	st	%g0,[%fp-76]
	ld	[%fp+68],%l6
	ld	[%fp-40],%l3
	ld	[%fp-24],%l0
	add	%l0,1,%l7
	ld	[%fp+92],%l1
	smul	%l7,%l1,%l5
	add	%l3,%l5,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l6+%l1],%f5
	add	%l5,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l6+%l1],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l0
	add	%l0,%l7,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 24
.L294:

!  305		  DCN(1,j)   = vs*DCN(1,j)    + v*DCN(1,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-44],%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 25
.L295:

!  307		  /* for the `point' */
!  308		  DCN(0,j+1) = us*CN(0,j+1,k) + u*CN(1,j+1,k);

	st	%g0,[%fp-80]
	st	%g0,[%fp-84]
	ld	[%fp-8],%f5
	ld	[%fp+68],%l5
	ld	[%fp-24],%l0
	add	%l0,1,%l6
	ld	[%fp+92],%l1
	smul	%l6,%l1,%l3
	add	%l3,0,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-40],%l0
	add	%l0,%l3,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-80],%l0
	add	%l0,%l6,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 26
.L296:

!  309		  DCN(0,j)   = vs*DCN(0,j)    + v*DCN(0,j+1);

	st	%g0,[%fp-88]
	st	%g0,[%fp-92]
	st	%g0,[%fp-96]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-92],%l0
	ld	[%fp-24],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-88],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 27
.L297:
.L298:
.L299:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L287
	nop

	! block 28
.L300:
.L289:
.L301:
.L302:
.L303:

!  310		}
!  311	        
!  312		/* remaining linear de Casteljau steps until the second last step */
!  313		for(h=minorder; h<vorder-1; h++)

	ld	[%fp-32],%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L306
	nop

	! block 29
.L307:
.L304:
.L308:
.L309:
.L310:

!  314		  for(j=0; j<vorder-h; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L313
	nop

	! block 30
.L314:
.L311:
.L315:
.L316:
.L317:

!  315		  {
!  316		    /* for the derivative in u */
!  317		    DCN(1,j) = vs*DCN(1,j) + v*DCN(1,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-44],%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 31
.L318:

!  319		    /* for the `point' */
!  320		    DCN(0,j) = vs*DCN(0,j) + v*DCN(0,j+1);

	st	%g0,[%fp-76]
	st	%g0,[%fp-80]
	st	%g0,[%fp-84]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-80],%l0
	ld	[%fp-24],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-76],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 32
.L319:
.L320:
.L321:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l2
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L311
	nop

	! block 33
.L322:
.L313:
.L323:
.L324:
.L325:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L304
	nop

	! block 34
.L326:
.L306:
.L327:
.L328:

!  321		  }
!  322	
!  323		/* derivative direction in v */
!  324		dv[k] = DCN(0,1) - DCN(0,0);

	st	%g0,[%fp-76]
	st	%g0,[%fp-80]
	ld	[%fp-4],%l2
	ld	[%fp-76],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	ld	[%l2+0],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp+80],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 35
.L329:

!  326		/* derivative direction in u */
!  327		du[k] =   vs*DCN(1,0) + v*DCN(1,1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-44],%l2
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 36
.L330:

!  329		/* last linear de Casteljau step */
!  330		out[k] =  vs*DCN(0,0) + v*DCN(0,1);

	st	%g0,[%fp-84]
	st	%g0,[%fp-88]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l2
	ld	[%fp-84],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	ld	[%l2+4],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 37
.L331:
.L332:
.L333:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L277
	nop

	! block 38
.L334:
.L279:
.L335:
.L336:
.L337:
	ba	.L338
	nop

	! block 39
.L270:
.L339:
.L340:
.L341:
.L342:

!  331	      }
!  332	    }
!  333	    else /* minorder == vorder */
!  334	    {
!  335	      for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L345
	st	%g0,[%fp-28]

	! block 40
.L346:
.L343:
.L347:
.L348:
.L349:

!  336	      {
!  337		/* bilinear de Casteljau step */
!  338		DCN(0,1) =    CN(0,1,k) -   CN(0,0,k);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	st	%g0,[%fp-56]
	st	%g0,[%fp-60]
	ld	[%fp+68],%l3
	ld	[%fp-52],%l0
	ld	[%fp+92],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%fp-56],%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-48],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 41
.L350:

!  339		DCN(0,0) = vs*CN(0,0,k) + v*CN(0,1,k);

	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	st	%g0,[%fp-72]
	st	%g0,[%fp-76]
	ld	[%fp-12],%f5
	ld	[%fp+68],%l3
	ld	[%fp-68],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	ld	[%fp+92],%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 42
.L351:
.L352:

!  340		for(i=0; i<uorder-1; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L355
	nop

	! block 43
.L356:
.L353:
.L357:
.L358:
.L359:

!  341		{
!  342		  /* for the derivative in v */
!  343		  DCN(i+1,1) =    CN(i+1,1,k) -   CN(i+1,0,k);

	st	%g0,[%fp-80]
	ld	[%fp+68],%l5
	ld	[%fp-20],%l0
	add	%l0,1,%l6
	ld	[%fp-40],%l1
	smul	%l6,%l1,%l3
	ld	[%fp+92],%l1
	add	%l3,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f5
	add	%l3,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%l6,%l1,%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 44
.L360:

!  344		  DCN(i,1)   = us*DCN(i,1)    + u*DCN(i+1,1);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 45
.L361:

!  346		  /* for the `point' */
!  347		  DCN(i+1,0) = vs*CN(i+1,0,k) + v*CN(i+1,1,k);

	st	%g0,[%fp-84]
	ld	[%fp-12],%f5
	ld	[%fp+68],%l5
	ld	[%fp-20],%l0
	add	%l0,1,%l6
	ld	[%fp-40],%l1
	smul	%l6,%l1,%l3
	add	%l3,0,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	ld	[%fp+92],%l1
	add	%l3,%l1,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%l6,%l1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 46
.L362:

!  348		  DCN(i,0)   = us*DCN(i,0)    + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 47
.L363:
.L364:
.L365:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L353
	nop

	! block 48
.L366:
.L355:
.L367:
.L368:
.L369:

!  349		}
!  350	        
!  351		/* remaining linear de Casteljau steps until the second last step */
!  352		for(h=minorder; h<uorder-1; h++)

	ld	[%fp-32],%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L372
	nop

	! block 49
.L373:
.L370:
.L374:
.L375:
.L376:

!  353		  for(i=0; i<uorder-h; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L379
	nop

	! block 50
.L380:
.L377:
.L381:
.L382:
.L383:

!  354		  {
!  355		    /* for the derivative in v */
!  356		    DCN(i,1) = us*DCN(i,1) + u*DCN(i+1,1);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 51
.L384:

!  358		    /* for the `point' */
!  359		    DCN(i,0) = us*DCN(i,0) + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 52
.L385:
.L386:
.L387:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l2
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L377
	nop

	! block 53
.L388:
.L379:
.L389:
.L390:
.L391:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L370
	nop

	! block 54
.L392:
.L372:
.L393:
.L394:

!  360		  }
!  361	
!  362		/* derivative direction in u */
!  363		du[k] = DCN(1,0) - DCN(0,0);

	st	%g0,[%fp-80]
	ld	[%fp-4],%l2
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	ld	[%l2+0],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 55
.L395:

!  365		/* derivative direction in v */
!  366		dv[k] =   us*DCN(0,1) + u*DCN(1,1);

	st	%g0,[%fp-84]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l2
	ld	[%l2+4],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+80],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 56
.L396:

!  368		/* last linear de Casteljau step */
!  369		out[k] =  us*DCN(0,0) + u*DCN(1,0);

	st	%g0,[%fp-88]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l2
	ld	[%l2+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 57
.L397:
.L398:
.L399:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L343
	nop

	! block 58
.L400:
.L345:
.L401:
.L402:
.L403:
.L338:
.L404:
.L405:
.L267:
.L406:
.L407:
.L408:
	ba	.L409
	nop

	! block 59
.L238:
.L410:
.L411:
.L413:

!  370	      }
!  371	    }
!  372	  }
!  373	  else if(uorder == vorder)

	ld	[%fp+96],%l1
	ld	[%fp+100],%l0
	cmp	%l1,%l0
	bne	.L412
	nop

	! block 60
.L414:
.L415:
.L416:
.L417:
.L418:

!  374	  {
!  375	    for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L421
	st	%g0,[%fp-28]

	! block 61
.L422:
.L419:
.L423:
.L424:
.L425:
.L426:

!  376	    {
!  377	      /* first bilinear de Casteljau step */
!  378	      for(i=0; i<uorder-1; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L429
	nop

	! block 62
.L430:
.L427:
.L431:
.L432:
.L433:

!  379	      {
!  380		DCN(i,0) = us*CN(i,0,k) + u*CN(i+1,0,k);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	ld	[%fp-8],%f5
	ld	[%fp+68],%l5
	ld	[%fp-20],%l6
	ld	[%fp-40],%l3
	smul	%l6,%l3,%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l6,1,%l0
	smul	%l0,%l3,%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%l6,%l1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 63
.L434:
.L435:

!  381		for(j=0; j<vorder-1; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L438
	nop

	! block 64
.L439:
.L436:
.L440:
.L441:
.L442:

!  382		{
!  383		  DCN(i,j+1) = us*CN(i,j+1,k) + u*CN(i+1,j+1,k);

	ld	[%fp-8],%f5
	ld	[%fp+68],%l7
	ld	[%fp-20],%i0
	ld	[%fp-40],%l5
	smul	%i0,%l5,%l3
	ld	[%fp-24],%l0
	add	%l0,1,%i1
	ld	[%fp+92],%l1
	smul	%i1,%l1,%l6
	add	%l3,%l6,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%i0,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l6,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%i0,%l1,%l0
	add	%l0,%i1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 65
.L443:

!  384		  DCN(i,j)   = vs*DCN(i,j)    + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 66
.L444:
.L445:
.L446:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L436
	nop

	! block 67
.L447:
.L438:
.L448:
.L449:
.L450:
.L451:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L427
	nop

	! block 68
.L452:
.L429:
.L453:
.L454:
.L455:

!  385		}
!  386	      }
!  387	
!  388	      /* remaining bilinear de Casteljau steps until the second last step */
!  389	      for(h=2; h<minorder-1; h++)

	mov	2,%l0
	st	%l0,[%fp-16]
	mov	2,%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L458
	nop

	! block 69
.L459:
.L456:
.L460:
.L461:
.L462:

!  390		for(i=0; i<uorder-h; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L465
	nop

	! block 70
.L466:
.L463:
.L467:
.L468:
.L469:

!  391		{
!  392		  DCN(i,0) = us*DCN(i,0) + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 71
.L470:
.L471:

!  393		  for(j=0; j<vorder-h; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L474
	nop

	! block 72
.L475:
.L472:
.L476:
.L477:
.L478:

!  394		  {
!  395		    DCN(i,j+1) = us*DCN(i,j+1) + u*DCN(i+1,j+1);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l6
	ld	[%fp-20],%l3
	ld	[%fp-44],%l5
	smul	%l3,%l5,%l1
	ld	[%fp-24],%l0
	add	%l0,1,%l2
	add	%l1,%l2,%l0
	sll	%l0,2,%l1
	add	%l6,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l6+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 73
.L479:

!  396		    DCN(i,j)   = vs*DCN(i,j)   + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 74
.L480:
.L481:
.L482:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l2
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L472
	nop

	! block 75
.L483:
.L474:
.L484:
.L485:
.L486:
.L487:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l2
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L463
	nop

	! block 76
.L488:
.L465:
.L489:
.L490:
.L491:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L456
	nop

	! block 77
.L492:
.L458:
.L493:
.L494:

!  397		  }
!  398		}
!  399	
!  400	      /* derivative direction in u */
!  401	      du[k] = vs*(DCN(1,0) - DCN(0,0)) +
!  402		       v*(DCN(1,1) - DCN(0,1));

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	ld	[%fp-12],%f6
	ld	[%fp-4],%l3
	ld	[%fp-44],%l2
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%fp-48],%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f7
	ld	[%fp+88],%f6
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%l3+4],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f7,%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 78
.L495:

!  404	      /* derivative direction in v */
!  405	      dv[k] = us*(DCN(0,1) - DCN(0,0)) + 
!  406		       u*(DCN(1,1) - DCN(1,0));

	st	%g0,[%fp-56]
	st	%g0,[%fp-60]
	ld	[%fp-8],%f6
	ld	[%fp-4],%l3
	ld	[%fp-56],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%l3+0],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f7
	ld	[%fp+84],%f6
	ld	[%fp-44],%l2
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f4
	fsubs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f7,%f4,%f4
	ld	[%fp+80],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 79
.L496:

!  408	      /* last bilinear de Casteljau step */
!  409	      out[k] =  us*(vs*DCN(0,0) + v*DCN(0,1)) +
!  410		         u*(vs*DCN(1,0) + v*DCN(1,1));

	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	ld	[%fp-8],%f6
	ld	[%fp-12],%f7
	ld	[%fp-4],%l3
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f7,%f4,%f5
	ld	[%fp+88],%f8
	ld	[%l3+4],%f4
	fmuls	%f8,%f4,%f4
	fadds	%f5,%f4,%f4
	fmuls	%f6,%f4,%f9
	ld	[%fp+84],%f6
	ld	[%fp-44],%l2
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f7,%f4,%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f8,%f4,%f4
	fadds	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	fadds	%f9,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 80
.L497:
.L498:
.L499:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L419
	nop

	! block 81
.L500:
.L421:
.L501:
.L502:
.L503:
	ba	.L504
	nop

	! block 82
.L412:
.L505:
.L506:
.L508:

!  411	    }
!  412	  }
!  413	  else if(minorder == uorder)

	ld	[%fp-32],%l1
	ld	[%fp+96],%l0
	cmp	%l1,%l0
	bne	.L507
	nop

	! block 83
.L509:
.L510:
.L511:
.L512:
.L513:

!  414	  {
!  415	    for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L516
	st	%g0,[%fp-28]

	! block 84
.L517:
.L514:
.L518:
.L519:
.L520:
.L521:

!  416	    {
!  417	      /* first bilinear de Casteljau step */
!  418	      for(i=0; i<uorder-1; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L524
	nop

	! block 85
.L525:
.L522:
.L526:
.L527:
.L528:

!  419	      {
!  420		DCN(i,0) = us*CN(i,0,k) + u*CN(i+1,0,k);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	ld	[%fp-8],%f5
	ld	[%fp+68],%l5
	ld	[%fp-20],%l6
	ld	[%fp-40],%l3
	smul	%l6,%l3,%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l6,1,%l0
	smul	%l0,%l3,%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%l6,%l1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 86
.L529:
.L530:

!  421		for(j=0; j<vorder-1; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L533
	nop

	! block 87
.L534:
.L531:
.L535:
.L536:
.L537:

!  422		{
!  423		  DCN(i,j+1) = us*CN(i,j+1,k) + u*CN(i+1,j+1,k);

	ld	[%fp-8],%f5
	ld	[%fp+68],%l7
	ld	[%fp-20],%i0
	ld	[%fp-40],%l5
	smul	%i0,%l5,%l3
	ld	[%fp-24],%l0
	add	%l0,1,%i1
	ld	[%fp+92],%l1
	smul	%i1,%l1,%l6
	add	%l3,%l6,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%i0,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l6,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%i0,%l1,%l0
	add	%l0,%i1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 88
.L538:

!  424		  DCN(i,j)   = vs*DCN(i,j)    + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 89
.L539:
.L540:
.L541:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L531
	nop

	! block 90
.L542:
.L533:
.L543:
.L544:
.L545:
.L546:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L522
	nop

	! block 91
.L547:
.L524:
.L548:
.L549:
.L550:

!  425		}
!  426	      }
!  427	
!  428	      /* remaining bilinear de Casteljau steps until the second last step */
!  429	      for(h=2; h<minorder-1; h++)

	mov	2,%l0
	st	%l0,[%fp-16]
	mov	2,%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L553
	nop

	! block 92
.L554:
.L551:
.L555:
.L556:
.L557:

!  430		for(i=0; i<uorder-h; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L560
	nop

	! block 93
.L561:
.L558:
.L562:
.L563:
.L564:

!  431		{
!  432		  DCN(i,0) = us*DCN(i,0) + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 94
.L565:
.L566:

!  433		  for(j=0; j<vorder-h; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L569
	nop

	! block 95
.L570:
.L567:
.L571:
.L572:
.L573:

!  434		  {
!  435		    DCN(i,j+1) = us*DCN(i,j+1) + u*DCN(i+1,j+1);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l6
	ld	[%fp-20],%l3
	ld	[%fp-44],%l5
	smul	%l3,%l5,%l1
	ld	[%fp-24],%l0
	add	%l0,1,%l2
	add	%l1,%l2,%l0
	sll	%l0,2,%l1
	add	%l6,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l6+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 96
.L574:

!  436		    DCN(i,j)   = vs*DCN(i,j)   + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 97
.L575:
.L576:
.L577:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l2
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L567
	nop

	! block 98
.L578:
.L569:
.L579:
.L580:
.L581:
.L582:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l2
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L558
	nop

	! block 99
.L583:
.L560:
.L584:
.L585:
.L586:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L551
	nop

	! block 100
.L587:
.L553:
.L588:
.L589:

!  437		  }
!  438		}
!  439	
!  440	      /* last bilinear de Casteljau step */
!  441	      DCN(2,0) =    DCN(1,0) -   DCN(0,0);

	st	%g0,[%fp-48]
	ld	[%fp-4],%l3
	ld	[%fp-44],%l2
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f5
	ld	[%l3+0],%f4
	fsubs	%f5,%f4,%f4
	sll	%l2,1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 101
.L590:

!  442	      DCN(0,0) = us*DCN(0,0) + u*DCN(1,0);

	st	%g0,[%fp-52]
	st	%g0,[%fp-56]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l2
	ld	[%l2+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-52],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 102
.L591:
.L592:

!  443	      for(j=0; j<vorder-1; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L595
	nop

	! block 103
.L596:
.L593:
.L597:
.L598:
.L599:

!  444	      {
!  445		/* for the derivative in u */
!  446		DCN(2,j+1) =    DCN(1,j+1) -    DCN(0,j+1);

	st	%g0,[%fp-60]
	ld	[%fp-4],%l4
	ld	[%fp-44],%l3
	ld	[%fp-24],%l0
	add	%l0,1,%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l4+%l1],%f5
	add	%l2,0,%l0
	sll	%l0,2,%l1
	ld	[%l4+%l1],%f4
	fsubs	%f5,%f4,%f4
	sll	%l3,1,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l4+%l1]

	! block 104
.L600:

!  447		DCN(2,j)   = vs*DCN(2,j)    + v*DCN(2,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-44],%l0
	sll	%l0,1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 105
.L601:

!  448		
!  449		/* for the `point' */
!  450		DCN(0,j+1) = us*DCN(0,j+1 ) + u*DCN(1,j+1);

	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l3
	ld	[%fp-24],%l0
	add	%l0,1,%l2
	add	%l2,0,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-64],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 106
.L602:

!  451		DCN(0,j)   = vs*DCN(0,j)    + v*DCN(0,j+1);

	st	%g0,[%fp-72]
	st	%g0,[%fp-76]
	st	%g0,[%fp-80]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-76],%l0
	ld	[%fp-24],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-72],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 107
.L603:
.L604:
.L605:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L593
	nop

	! block 108
.L606:
.L595:
.L607:
.L608:
.L609:

!  452	      }
!  453	        
!  454	      /* remaining linear de Casteljau steps until the second last step */
!  455	      for(h=minorder; h<vorder-1; h++)

	ld	[%fp-32],%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L612
	nop

	! block 109
.L613:
.L610:
.L614:
.L615:
.L616:

!  456		for(j=0; j<vorder-h; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L619
	nop

	! block 110
.L620:
.L617:
.L621:
.L622:
.L623:

!  457		{
!  458		  /* for the derivative in u */
!  459		  DCN(2,j) = vs*DCN(2,j) + v*DCN(2,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-44],%l0
	sll	%l0,1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 111
.L624:

!  460		  
!  461		  /* for the `point' */
!  462		  DCN(0,j) = vs*DCN(0,j) + v*DCN(0,j+1);

	st	%g0,[%fp-60]
	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-64],%l0
	ld	[%fp-24],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-60],%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 112
.L625:
.L626:
.L627:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l2
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L617
	nop

	! block 113
.L628:
.L619:
.L629:
.L630:
.L631:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L610
	nop

	! block 114
.L632:
.L612:
.L633:
.L634:

!  463		}
!  464	      
!  465	      /* derivative direction in v */
!  466	      dv[k] = DCN(0,1) - DCN(0,0);

	st	%g0,[%fp-60]
	st	%g0,[%fp-64]
	ld	[%fp-4],%l2
	ld	[%fp-60],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	ld	[%l2+0],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp+80],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 115
.L635:

!  467	      
!  468	      /* derivative direction in u */
!  469	      du[k] =   vs*DCN(2,0) + v*DCN(2,1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-44],%l0
	sll	%l0,1,%l2
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 116
.L636:

!  470	      
!  471	      /* last linear de Casteljau step */
!  472	      out[k] =  vs*DCN(0,0) + v*DCN(0,1);

	st	%g0,[%fp-68]
	st	%g0,[%fp-72]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l2
	ld	[%fp-68],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	ld	[%l2+4],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 117
.L637:
.L638:
.L639:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L514
	nop

	! block 118
.L640:
.L516:
.L641:
.L642:
.L643:
	ba	.L644
	nop

	! block 119
.L507:
.L645:
.L646:
.L647:
.L648:

!  473	    }
!  474	  }
!  475	  else /* minorder == vorder */
!  476	  {
!  477	    for(k=0; k<dim; k++)

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bgeu	.L651
	st	%g0,[%fp-28]

	! block 120
.L652:
.L649:
.L653:
.L654:
.L655:
.L656:

!  478	    {
!  479	      /* first bilinear de Casteljau step */
!  480	      for(i=0; i<uorder-1; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L659
	nop

	! block 121
.L660:
.L657:
.L661:
.L662:
.L663:

!  481	      {
!  482		DCN(i,0) = us*CN(i,0,k) + u*CN(i+1,0,k);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	ld	[%fp-8],%f5
	ld	[%fp+68],%l5
	ld	[%fp-20],%l6
	ld	[%fp-40],%l3
	smul	%l6,%l3,%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l6,1,%l0
	smul	%l0,%l3,%l0
	add	%l0,0,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%l6,%l1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 122
.L664:
.L665:

!  483		for(j=0; j<vorder-1; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L668
	nop

	! block 123
.L669:
.L666:
.L670:
.L671:
.L672:

!  484		{
!  485		  DCN(i,j+1) = us*CN(i,j+1,k) + u*CN(i+1,j+1,k);

	ld	[%fp-8],%f5
	ld	[%fp+68],%l7
	ld	[%fp-20],%i0
	ld	[%fp-40],%l5
	smul	%i0,%l5,%l3
	ld	[%fp-24],%l0
	add	%l0,1,%i1
	ld	[%fp+92],%l1
	smul	%i1,%l1,%l6
	add	%l3,%l6,%l0
	ld	[%fp-28],%l2
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%i0,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l6,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l7+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-4],%l2
	ld	[%fp-44],%l1
	smul	%i0,%l1,%l0
	add	%l0,%i1,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 124
.L673:

!  486		  DCN(i,j)   = vs*DCN(i,j)    + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 125
.L674:
.L675:
.L676:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+100],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L666
	nop

	! block 126
.L677:
.L668:
.L678:
.L679:
.L680:
.L681:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L657
	nop

	! block 127
.L682:
.L659:
.L683:
.L684:
.L685:

!  487		}
!  488	      }
!  489	
!  490	      /* remaining bilinear de Casteljau steps until the second last step */
!  491	      for(h=2; h<minorder-1; h++)

	mov	2,%l0
	st	%l0,[%fp-16]
	mov	2,%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L688
	nop

	! block 128
.L689:
.L686:
.L690:
.L691:
.L692:

!  492		for(i=0; i<uorder-h; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L695
	nop

	! block 129
.L696:
.L693:
.L697:
.L698:
.L699:

!  493		{
!  494		  DCN(i,0) = us*DCN(i,0) + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 130
.L700:
.L701:

!  495		  for(j=0; j<vorder-h; j++)

	st	%g0,[%fp-24]
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L704
	nop

	! block 131
.L705:
.L702:
.L706:
.L707:
.L708:

!  496		  {
!  497		    DCN(i,j+1) = us*DCN(i,j+1) + u*DCN(i+1,j+1);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l6
	ld	[%fp-20],%l3
	ld	[%fp-44],%l5
	smul	%l3,%l5,%l1
	ld	[%fp-24],%l0
	add	%l0,1,%l2
	add	%l1,%l2,%l0
	sll	%l0,2,%l1
	add	%l6,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l5,%l0
	add	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l6+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 132
.L709:

!  498		    DCN(i,j)   = vs*DCN(i,j)   + v*DCN(i,j+1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l3
	ld	[%fp-24],%l2
	add	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l1
	add	%l3,%l1,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 133
.L710:
.L711:
.L712:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l2
	ld	[%fp+100],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L702
	nop

	! block 134
.L713:
.L704:
.L714:
.L715:
.L716:
.L717:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l2
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L693
	nop

	! block 135
.L718:
.L695:
.L719:
.L720:
.L721:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp-32],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L686
	nop

	! block 136
.L722:
.L688:
.L723:
.L724:

!  499		  }
!  500		}
!  501	
!  502	      /* last bilinear de Casteljau step */
!  503	      DCN(0,2) =    DCN(0,1) -   DCN(0,0);

	st	%g0,[%fp-48]
	st	%g0,[%fp-52]
	st	%g0,[%fp-56]
	ld	[%fp-4],%l2
	ld	[%fp-52],%l0
	add	%l0,1,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	ld	[%l2+0],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp-48],%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 137
.L725:

!  504	      DCN(0,0) = vs*DCN(0,0) + v*DCN(0,1);

	st	%g0,[%fp-60]
	st	%g0,[%fp-64]
	st	%g0,[%fp-68]
	ld	[%fp-12],%f5
	ld	[%fp-4],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	ld	[%l2+4],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp-60],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 138
.L726:
.L727:

!  505	      for(i=0; i<uorder-1; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bgeu	.L730
	nop

	! block 139
.L731:
.L728:
.L732:
.L733:
.L734:

!  506	      {
!  507		/* for the derivative in v */
!  508		DCN(i+1,2) =    DCN(i+1,1)  -   DCN(i+1,0);

	ld	[%fp-4],%l3
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l2
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f5
	sll	%l2,2,%l1
	ld	[%l3+%l1],%f4
	fsubs	%f5,%f4,%f4
	add	%l2,2,%l0
	sll	%l0,2,%l1
	st	%f4,[%l3+%l1]

	! block 140
.L735:

!  509		DCN(i,2)   = us*DCN(i,2)    + u*DCN(i+1,2);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 141
.L736:

!  510		
!  511		/* for the `point' */
!  512		DCN(i+1,0) = vs*DCN(i+1,0)  + v*DCN(i+1,1);

	ld	[%fp-12],%f5
	ld	[%fp-4],%l3
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	ld	[%fp-44],%l1
	smul	%l0,%l1,%l2
	sll	%l2,2,%l1
	add	%l3,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+88],%f5
	add	%l2,1,%l0
	sll	%l0,2,%l1
	ld	[%l3+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 142
.L737:

!  513		DCN(i,0)   = us*DCN(i,0)    + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 143
.L738:
.L739:
.L740:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L728
	nop

	! block 144
.L741:
.L730:
.L742:
.L743:
.L744:

!  514	      }
!  515	      
!  516	      /* remaining linear de Casteljau steps until the second last step */
!  517	      for(h=minorder; h<uorder-1; h++)

	ld	[%fp-32],%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bgeu	.L747
	nop

	! block 145
.L748:
.L745:
.L749:
.L750:
.L751:

!  518		for(i=0; i<uorder-h; i++)

	st	%g0,[%fp-20]
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%g0,%l0
	bgeu	.L754
	nop

	! block 146
.L755:
.L752:
.L756:
.L757:
.L758:

!  519		{
!  520		  /* for the derivative in v */
!  521		  DCN(i,2) = us*DCN(i,2) + u*DCN(i+1,2);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 147
.L759:

!  522		  
!  523		  /* for the `point' */
!  524		  DCN(i,0) = us*DCN(i,0) + u*DCN(i+1,0);

	ld	[%fp-8],%f5
	ld	[%fp-4],%l5
	ld	[%fp-20],%l3
	ld	[%fp-44],%l2
	smul	%l3,%l2,%l0
	sll	%l0,2,%l1
	add	%l5,%l1,%l4
	ld	[%l4+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	add	%l3,1,%l0
	smul	%l0,%l2,%l0
	sll	%l0,2,%l1
	ld	[%l5+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	st	%f4,[%l4+0]

	! block 148
.L760:
.L761:
.L762:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l2
	ld	[%fp+96],%l0
	ld	[%fp-16],%l1
	sub	%l0,%l1,%l0
	cmp	%l2,%l0
	blu	.L752
	nop

	! block 149
.L763:
.L754:
.L764:
.L765:
.L766:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+96],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	blu	.L745
	nop

	! block 150
.L767:
.L747:
.L768:
.L769:

!  525		}
!  526	      
!  527	      /* derivative direction in u */
!  528	      du[k] = DCN(1,0) - DCN(0,0);

	st	%g0,[%fp-72]
	ld	[%fp-4],%l2
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	ld	[%l2+0],%f4
	fsubs	%f5,%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 151
.L770:

!  529	      
!  530	      /* derivative direction in v */
!  531	      dv[k] =   us*DCN(0,2) + u*DCN(1,2);

	st	%g0,[%fp-76]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l2
	ld	[%l2+8],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	add	%l0,2,%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+80],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 152
.L771:

!  532	      
!  533	      /* last linear de Casteljau step */
!  534	      out[k] =  us*DCN(0,0) + u*DCN(1,0);

	st	%g0,[%fp-80]
	ld	[%fp-8],%f5
	ld	[%fp-4],%l2
	ld	[%l2+0],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp+84],%f5
	ld	[%fp-44],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fmuls	%f5,%f4,%f4
	fadds	%f6,%f4,%f4
	ld	[%fp+72],%l2
	ld	[%fp-28],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 153
.L772:
.L773:
.L774:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	blu	.L649
	nop

	! block 154
.L775:
.L651:
.L776:
.L777:
.L778:
.L644:
.L779:
.L780:
.L504:
.L781:
.L782:
.L409:
.L783:

	! block 155
.L784:
.L785:
.L225:
	jmp	%i7+8
	restore
	.size	de_casteljau_surf,(.-de_casteljau_surf)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	components,#function
components:
	save	%sp,-104,%sp

	! block 1
.L788:
	st	%i0,[%fp+68]

	! block 2
.L789:
.L791:
.L794:

! File eval.c:
!  535	    }
!  536	  }
!  537	#undef DCN
!  538	#undef CN
!  539	}
!  540	
!  541	/*
!  542	 * Return the number of components per control point for any type of
!  543	 * evaluator.  Return 0 if bad target.
!  544	 */
!  545	
!  546	static GLint components( GLenum target )
!  547	{
!  548	   switch (target) {

	ba	.L793
	nop

	! block 3
.L795:
.L796:
.L797:
.L798:

!  549	      case GL_MAP1_VERTEX_3:		return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 4
.L799:
.L800:

!  550	      case GL_MAP1_VERTEX_4:		return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 5
.L801:
.L802:

!  551	      case GL_MAP1_INDEX:		return 1;

	mov	1,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 6
.L803:
.L804:

!  552	      case GL_MAP1_COLOR_4:		return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 7
.L805:
.L806:

!  553	      case GL_MAP1_NORMAL:		return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 8
.L807:
.L808:

!  554	      case GL_MAP1_TEXTURE_COORD_1:	return 1;

	mov	1,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 9
.L809:
.L810:

!  555	      case GL_MAP1_TEXTURE_COORD_2:	return 2;

	mov	2,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 10
.L811:
.L812:

!  556	      case GL_MAP1_TEXTURE_COORD_3:	return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 11
.L813:
.L814:

!  557	      case GL_MAP1_TEXTURE_COORD_4:	return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 12
.L815:
.L816:

!  558	      case GL_MAP2_VERTEX_3:		return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 13
.L817:
.L818:

!  559	      case GL_MAP2_VERTEX_4:		return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 14
.L819:
.L820:

!  560	      case GL_MAP2_INDEX:		return 1;

	mov	1,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 15
.L821:
.L822:

!  561	      case GL_MAP2_COLOR_4:		return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 16
.L823:
.L824:

!  562	      case GL_MAP2_NORMAL:		return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 17
.L825:
.L826:

!  563	      case GL_MAP2_TEXTURE_COORD_1:	return 1;

	mov	1,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 18
.L827:
.L828:

!  564	      case GL_MAP2_TEXTURE_COORD_2:	return 2;

	mov	2,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 19
.L829:
.L830:

!  565	      case GL_MAP2_TEXTURE_COORD_3:	return 3;

	mov	3,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 20
.L831:
.L832:

!  566	      case GL_MAP2_TEXTURE_COORD_4:	return 4;

	mov	4,%l0
	ba	.L787
	st	%l0,[%fp-4]

	! block 21
.L833:
.L834:

!  567	      default:				return 0;

	ba	.L787
	st	%g0,[%fp-4]

	! block 22
.L835:
.L836:
.L793:
.L837:
	ld	[%fp+68],%l2
	cmp	%l2,3504
	bge	.L_y0
	nop

	! block 23
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L833
	nop

	! block 24
	sll	%l0,2,%l1
	sethi	%hi(.L_y1-36),%l0
	or	%l0,%lo(.L_y1-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 25
.L_y0:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L833
	nop

	! block 26
	sll	%l0,2,%l1
	sethi	%hi(.L_y2-36),%l0
	or	%l0,%lo(.L_y2-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 27
.L838:
.L839:

	! block 28
.L840:
.L841:
.L787:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	components,(.-components)

	.word	.L803
	.word	.L801
	.word	.L805
	.word	.L807
	.word	.L809
	.word	.L811
	.word	.L813
	.word	.L797
	.word	.L799
.L_y1:
	.word	.L821
	.word	.L819
	.word	.L823
	.word	.L825
	.word	.L827
	.word	.L829
	.word	.L831
	.word	.L815
	.word	.L817
.L_y2:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_copy_map_points1f
	.type	gl_copy_map_points1f,#function
gl_copy_map_points1f:
	save	%sp,-120,%sp

	! block 1
.L844:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L845:
.L847:

! File eval.c:
!  568	   }
!  569	}
!  570	
!  572	/**********************************************************************/
!  573	/***            Copy and deallocate control points                  ***/
!  574	/**********************************************************************/
!  575	
!  577	/*
!  578	 * Copy 1-parametric evaluator control points from user-specified 
!  579	 * memory space to a buffer of contiguous control points.
!  580	 * Input:  see glMap1f for details
!  581	 * Return:  pointer to buffer of contiguous control points or NULL if out
!  582	 *          of memory.
!  583	 */
!  584	GLfloat *gl_copy_map_points1f( GLenum target,
!  585	                               GLint ustride, GLint uorder,
!  586	                               const GLfloat *points )
!  587	{
!  588	   GLfloat *buffer, *p;
!  589	   GLuint i, k, size = components(target);

	ld	[%fp+68],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-24]

	! block 3
.L848:
.L850:

!  591	   if (!points || components==0) {

	ld	[%fp+80],%l0
	cmp	%l0,%g0
	be	.L851
	nop

	! block 4
.L852:
	sethi	%hi(components),%l0
	or	%l0,%lo(components),%l0
	cmp	%l0,%g0
	bne	.L849
	nop

	! block 5
.L853:
.L851:
.L854:
.L855:
.L856:

!  592	      return NULL;

	ba	.L843
	st	%g0,[%fp-4]

	! block 6
.L857:
.L858:
.L849:
.L859:
.L860:

!  593	   }
!  594	
!  595	   buffer = (GLfloat *) malloc(uorder * size * sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp-24],%l1
	smul	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 7
.L861:
.L863:

!  597	   if(buffer) 

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L862
	nop

	! block 8
.L864:
.L865:
.L866:
.L867:

!  598	      for(i=0, p=buffer; i<uorder; i++, points+=ustride)

	st	%g0,[%fp-16]
	ld	[%fp-8],%l0
	st	%l0,[%fp-12]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bgeu	.L870
	nop

	! block 9
.L871:
.L868:
.L872:
.L873:
.L874:

!  599		for(k=0; k<size; k++)

	ld	[%fp-24],%l0
	cmp	%g0,%l0
	bgeu	.L877
	st	%g0,[%fp-20]

	! block 10
.L878:
.L875:
.L879:
.L880:

!  600		  *p++ = points[k];

	ld	[%fp+80],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	ld	[%fp-12],%l0
	st	%f4,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,4,%l0
	st	%l0,[%fp-12]

	! block 11
.L881:
.L882:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp-24],%l0
	cmp	%l1,%l0
	blu	.L875
	nop

	! block 12
.L883:
.L877:
.L884:
.L885:
.L886:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp+80],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+80]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	blu	.L868
	nop

	! block 13
.L887:
.L870:
.L888:
.L889:
.L862:
.L890:
.L891:

!  602	   return buffer;

	ld	[%fp-8],%l0
	ba	.L843
	st	%l0,[%fp-4]

	! block 14

	! block 15
.L892:
.L893:
.L843:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_copy_map_points1f,(.-gl_copy_map_points1f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_copy_map_points1d
	.type	gl_copy_map_points1d,#function
gl_copy_map_points1d:
	save	%sp,-120,%sp

	! block 1
.L896:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L897:
.L899:

! File eval.c:
!  603	}
!  604	
!  607	/*
!  608	 * Same as above but convert doubles to floats.
!  609	 */
!  610	GLfloat *gl_copy_map_points1d( GLenum target,
!  611				        GLint ustride, GLint uorder,
!  612				        const GLdouble *points )
!  613	{
!  614	   GLfloat *buffer, *p;
!  615	   GLuint i, k, size = components(target);

	ld	[%fp+68],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-24]

	! block 3
.L900:

!  617	   buffer = (GLfloat *) malloc(uorder * size * sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp-24],%l1
	smul	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 4
.L901:
.L903:

!  619	   if(buffer)

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L902
	nop

	! block 5
.L904:
.L905:
.L906:
.L907:

!  620	      for(i=0, p=buffer; i<uorder; i++, points+=ustride)

	st	%g0,[%fp-16]
	ld	[%fp-8],%l0
	st	%l0,[%fp-12]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bgeu	.L910
	nop

	! block 6
.L911:
.L908:
.L912:
.L913:
.L914:

!  621		for(k=0; k<size; k++)

	ld	[%fp-24],%l0
	cmp	%g0,%l0
	bgeu	.L917
	st	%g0,[%fp-20]

	! block 7
.L918:
.L915:
.L919:
.L920:

!  622		  *p++ = (GLfloat) points[k];

	ld	[%fp+80],%l2
	ld	[%fp-20],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%g1
	ld	[%g1],%f4
	ld	[%g1+4],%f5
	fdtos	%f4,%f4
	ld	[%fp-12],%l0
	st	%f4,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,4,%l0
	st	%l0,[%fp-12]

	! block 8
.L921:
.L922:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp-24],%l0
	cmp	%l1,%l0
	blu	.L915
	nop

	! block 9
.L923:
.L917:
.L924:
.L925:
.L926:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp+80],%l2
	ld	[%fp+72],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+80]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	blu	.L908
	nop

	! block 10
.L927:
.L910:
.L928:
.L929:
.L902:
.L930:
.L931:

!  624	   return buffer;

	ld	[%fp-8],%l0
	ba	.L895
	st	%l0,[%fp-4]

	! block 11

	! block 12
.L932:
.L933:
.L895:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_copy_map_points1d,(.-gl_copy_map_points1d)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_copy_map_points2f
	.type	gl_copy_map_points2f,#function
gl_copy_map_points2f:
	save	%sp,-144,%sp

	! block 1
.L936:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L937:
.L939:

! File eval.c:
!  625	}
!  626	
!  629	/*
!  630	 * Copy 2-parametric evaluator control points from user-specified 
!  631	 * memory space to a buffer of contiguous control points.
!  632	 * Additional memory is allocated to be used by the horner and
!  633	 * de Casteljau evaluation schemes.
!  634	 *
!  635	 * Input:  see glMap2f for details
!  636	 * Return:  pointer to buffer of contiguous control points or NULL if out
!  637	 *          of memory.
!  638	 */
!  639	GLfloat *gl_copy_map_points2f( GLenum target,
!  640				        GLint ustride, GLint uorder,
!  641				        GLint vstride, GLint vorder,
!  642				        const GLfloat *points )
!  643	{
!  644	   GLfloat *buffer, *p;
!  645	   GLuint i, j, k, size, dsize, hsize;
!  646	   GLint uinc;
!  647	
!  648	   size = components(target);

	ld	[%fp+68],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-28]

	! block 3
.L940:

!  650	   /* max(uorder, vorder) additional points are used in      */
!  651	   /* horner evaluation and uorder*vorder additional */
!  652	   /* values are needed for de Casteljau                     */
!  653	   dsize = (uorder == 2 && vorder == 2)? 0 : uorder*vorder;

	ld	[%fp+76],%l0
	cmp	%l0,2
	bne	.L941
	nop

	! block 4
.L942:
	ld	[%fp+84],%l0
	cmp	%l0,2
	bne	.L941
	nop

	! block 5
.L943:
	ba	.L944
	st	%g0,[%fp-44]

	! block 6
.L941:
	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 7
.L944:
	ld	[%fp-44],%l0
	st	%l0,[%fp-32]

	! block 8
.L945:

!  654	   hsize = (uorder > vorder ? uorder : vorder)*size;

	ld	[%fp+76],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	ble	.L946
	nop

	! block 9
.L947:
	ld	[%fp+76],%l0
	ba	.L948
	st	%l0,[%fp-48]

	! block 10
.L946:
	ld	[%fp+84],%l0
	st	%l0,[%fp-48]

	! block 11
.L948:
	ld	[%fp-48],%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 12
.L949:
.L951:

!  656	   if(hsize>dsize)

	ld	[%fp-36],%l1
	ld	[%fp-32],%l0
	cmp	%l1,%l0
	bleu	.L950
	nop

	! block 13
.L952:
.L953:
.L954:

!  657	     buffer = (GLfloat *) malloc((uorder*vorder*size+hsize)*sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-36],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 14
.L955:
	ba	.L956
	nop

	! block 15
.L950:
.L957:
.L958:

!  658	   else
!  659	     buffer = (GLfloat *) malloc((uorder*vorder*size+dsize)*sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-32],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 16
.L959:
.L956:
.L960:
.L961:

!  661	   /* compute the increment value for the u-loop */
!  662	   uinc = ustride - vorder*vstride;

	ld	[%fp+72],%l2
	ld	[%fp+84],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l1
	sub	%l2,%l1,%l0
	st	%l0,[%fp-40]

	! block 17
.L962:
.L964:

!  664	   if (buffer) 

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L963
	nop

	! block 18
.L965:
.L966:
.L967:
.L968:

!  665	      for (i=0, p=buffer; i<uorder; i++, points += uinc)

	st	%g0,[%fp-16]
	ld	[%fp-8],%l0
	st	%l0,[%fp-12]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bgeu	.L971
	nop

	! block 19
.L972:
.L969:
.L973:
.L974:
.L975:

!  666		 for (j=0; j<vorder; j++, points += vstride)

	ld	[%fp+84],%l0
	cmp	%g0,%l0
	bgeu	.L978
	st	%g0,[%fp-20]

	! block 20
.L979:
.L976:
.L980:
.L981:
.L982:

!  667		    for (k=0; k<size; k++)

	ld	[%fp-28],%l0
	cmp	%g0,%l0
	bgeu	.L985
	st	%g0,[%fp-24]

	! block 21
.L986:
.L983:
.L987:
.L988:

!  668		       *p++ = points[k];

	ld	[%fp+88],%l2
	ld	[%fp-24],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	ld	[%fp-12],%l0
	st	%f4,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,4,%l0
	st	%l0,[%fp-12]

	! block 22
.L989:
.L990:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp-28],%l0
	cmp	%l1,%l0
	blu	.L983
	nop

	! block 23
.L991:
.L985:
.L992:
.L993:
.L994:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp+88],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+88]
	ld	[%fp-20],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	blu	.L976
	nop

	! block 24
.L995:
.L978:
.L996:
.L997:
.L998:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp+88],%l2
	ld	[%fp-40],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+88]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	blu	.L969
	nop

	! block 25
.L999:
.L971:
.L1000:
.L1001:
.L963:
.L1002:
.L1003:

!  670	   return buffer;

	ld	[%fp-8],%l0
	ba	.L935
	st	%l0,[%fp-4]

	! block 26

	! block 27
.L1004:
.L1005:
.L935:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_copy_map_points2f,(.-gl_copy_map_points2f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_copy_map_points2d
	.type	gl_copy_map_points2d,#function
gl_copy_map_points2d:
	save	%sp,-144,%sp

	! block 1
.L1008:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L1009:
.L1011:

! File eval.c:
!  671	}
!  672	
!  675	/*
!  676	 * Same as above but convert doubles to floats.
!  677	 */
!  678	GLfloat *gl_copy_map_points2d(GLenum target,
!  679	                              GLint ustride, GLint uorder,
!  680	                              GLint vstride, GLint vorder,
!  681	                              const GLdouble *points )
!  682	{
!  683	   GLfloat *buffer, *p;
!  684	   GLuint i, j, k, size, hsize, dsize;
!  685	   GLint uinc;
!  686	
!  687	   size = components(target);

	ld	[%fp+68],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-28]

	! block 3
.L1012:

!  689	   /* max(uorder, vorder) additional points are used in      */
!  690	   /* horner evaluation and uorder*vorder additional */
!  691	   /* values are needed for de Casteljau                     */
!  692	   dsize = (uorder == 2 && vorder == 2)? 0 : uorder*vorder;

	ld	[%fp+76],%l0
	cmp	%l0,2
	bne	.L1013
	nop

	! block 4
.L1014:
	ld	[%fp+84],%l0
	cmp	%l0,2
	bne	.L1013
	nop

	! block 5
.L1015:
	ba	.L1016
	st	%g0,[%fp-44]

	! block 6
.L1013:
	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 7
.L1016:
	ld	[%fp-44],%l0
	st	%l0,[%fp-36]

	! block 8
.L1017:

!  693	   hsize = (uorder > vorder ? uorder : vorder)*size;

	ld	[%fp+76],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	ble	.L1018
	nop

	! block 9
.L1019:
	ld	[%fp+76],%l0
	ba	.L1020
	st	%l0,[%fp-48]

	! block 10
.L1018:
	ld	[%fp+84],%l0
	st	%l0,[%fp-48]

	! block 11
.L1020:
	ld	[%fp-48],%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 12
.L1021:
.L1023:

!  695	   if(hsize>dsize)

	ld	[%fp-32],%l1
	ld	[%fp-36],%l0
	cmp	%l1,%l0
	bleu	.L1022
	nop

	! block 13
.L1024:
.L1025:
.L1026:

!  696	     buffer = (GLfloat *) malloc((uorder*vorder*size+hsize)*sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-32],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 14
.L1027:
	ba	.L1028
	nop

	! block 15
.L1022:
.L1029:
.L1030:

!  697	   else
!  698	     buffer = (GLfloat *) malloc((uorder*vorder*size+dsize)*sizeof(GLfloat));

	ld	[%fp+76],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-28],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-36],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 16
.L1031:
.L1028:
.L1032:
.L1033:

!  700	   /* compute the increment value for the u-loop */
!  701	   uinc = ustride - vorder*vstride;

	ld	[%fp+72],%l2
	ld	[%fp+84],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l1
	sub	%l2,%l1,%l0
	st	%l0,[%fp-40]

	! block 17
.L1034:
.L1036:

!  703	   if (buffer) 

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L1035
	nop

	! block 18
.L1037:
.L1038:
.L1039:
.L1040:

!  704	      for (i=0, p=buffer; i<uorder; i++, points += uinc)

	st	%g0,[%fp-16]
	ld	[%fp-8],%l0
	st	%l0,[%fp-12]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bgeu	.L1043
	nop

	! block 19
.L1044:
.L1041:
.L1045:
.L1046:
.L1047:

!  705		 for (j=0; j<vorder; j++, points += vstride)

	ld	[%fp+84],%l0
	cmp	%g0,%l0
	bgeu	.L1050
	st	%g0,[%fp-20]

	! block 20
.L1051:
.L1048:
.L1052:
.L1053:
.L1054:

!  706		    for (k=0; k<size; k++)

	ld	[%fp-28],%l0
	cmp	%g0,%l0
	bgeu	.L1057
	st	%g0,[%fp-24]

	! block 21
.L1058:
.L1055:
.L1059:
.L1060:

!  707		       *p++ = (GLfloat) points[k];

	ld	[%fp+88],%l2
	ld	[%fp-24],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%g1
	ld	[%g1],%f4
	ld	[%g1+4],%f5
	fdtos	%f4,%f4
	ld	[%fp-12],%l0
	st	%f4,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,4,%l0
	st	%l0,[%fp-12]

	! block 22
.L1061:
.L1062:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp-28],%l0
	cmp	%l1,%l0
	blu	.L1055
	nop

	! block 23
.L1063:
.L1057:
.L1064:
.L1065:
.L1066:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp+88],%l2
	ld	[%fp+80],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+88]
	ld	[%fp-20],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	blu	.L1048
	nop

	! block 24
.L1067:
.L1050:
.L1068:
.L1069:
.L1070:
	ld	[%fp-16],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp+88],%l2
	ld	[%fp-40],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp+88]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	blu	.L1041
	nop

	! block 25
.L1071:
.L1043:
.L1072:
.L1073:
.L1035:
.L1074:
.L1075:

!  709	   return buffer;

	ld	[%fp-8],%l0
	ba	.L1007
	st	%l0,[%fp-4]

	! block 26

	! block 27
.L1076:
.L1077:
.L1007:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_copy_map_points2d,(.-gl_copy_map_points2d)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_free_control_points
	.type	gl_free_control_points,#function
gl_free_control_points:
	save	%sp,-104,%sp

	! block 1
.L1080:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L1081:
.L1083:

! File eval.c:
!  710	}
!  711	
!  713	/*
!  714	 * This function is called by the display list deallocator function to
!  715	 * specify that a given set of control points are no longer needed.
!  716	 */
!  717	void gl_free_control_points( GLcontext* ctx, GLenum target, GLfloat *data )
!  718	{
!  719	   struct gl_1d_map *map1 = NULL;

	st	%g0,[%fp-4]

	! block 3
.L1084:

!  720	   struct gl_2d_map *map2 = NULL;

	st	%g0,[%fp-8]

	! block 4
.L1085:
.L1088:

!  722	   switch (target) {

	ba	.L1087
	nop

	! block 5
.L1089:
.L1090:
.L1091:
.L1092:

!  723	      case GL_MAP1_VERTEX_3:
!  724	         map1 = &ctx->EvalMap.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 6
.L1093:

!  725	         break;

	ba	.L1086
	nop

	! block 7
.L1094:
.L1095:

!  726	      case GL_MAP1_VERTEX_4:
!  727	         map1 = &ctx->EvalMap.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 8
.L1096:

!  728		 break;

	ba	.L1086
	nop

	! block 9
.L1097:
.L1098:

!  729	      case GL_MAP1_INDEX:
!  730	         map1 = &ctx->EvalMap.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 10
.L1099:

!  731	         break;

	ba	.L1086
	nop

	! block 11
.L1100:
.L1101:

!  732	      case GL_MAP1_COLOR_4:
!  733	         map1 = &ctx->EvalMap.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 12
.L1102:

!  734	         break;

	ba	.L1086
	nop

	! block 13
.L1103:
.L1104:

!  735	      case GL_MAP1_NORMAL:
!  736	         map1 = &ctx->EvalMap.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 14
.L1105:

!  737		 break;

	ba	.L1086
	nop

	! block 15
.L1106:
.L1107:

!  738	      case GL_MAP1_TEXTURE_COORD_1:
!  739	         map1 = &ctx->EvalMap.Map1Texture1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 16
.L1108:

!  740		 break;

	ba	.L1086
	nop

	! block 17
.L1109:
.L1110:

!  741	      case GL_MAP1_TEXTURE_COORD_2:
!  742	         map1 = &ctx->EvalMap.Map1Texture2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 18
.L1111:

!  743		 break;

	ba	.L1086
	nop

	! block 19
.L1112:
.L1113:

!  744	      case GL_MAP1_TEXTURE_COORD_3:
!  745	         map1 = &ctx->EvalMap.Map1Texture3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 20
.L1114:

!  746		 break;

	ba	.L1086
	nop

	! block 21
.L1115:
.L1116:

!  747	      case GL_MAP1_TEXTURE_COORD_4:
!  748	         map1 = &ctx->EvalMap.Map1Texture4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 22
.L1117:

!  749		 break;

	ba	.L1086
	nop

	! block 23
.L1118:
.L1119:

!  750	      case GL_MAP2_VERTEX_3:
!  751	         map2 = &ctx->EvalMap.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 24
.L1120:

!  752		 break;

	ba	.L1086
	nop

	! block 25
.L1121:
.L1122:

!  753	      case GL_MAP2_VERTEX_4:
!  754	         map2 = &ctx->EvalMap.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 26
.L1123:

!  755		 break;

	ba	.L1086
	nop

	! block 27
.L1124:
.L1125:

!  756	      case GL_MAP2_INDEX:
!  757	         map2 = &ctx->EvalMap.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 28
.L1126:

!  758		 break;

	ba	.L1086
	nop

	! block 29
.L1127:
.L1128:

!  759	      case GL_MAP2_COLOR_4:
!  760	         map2 = &ctx->EvalMap.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 30
.L1129:

!  761	         break;

	ba	.L1086
	nop

	! block 31
.L1130:
.L1131:

!  762	      case GL_MAP2_NORMAL:
!  763	         map2 = &ctx->EvalMap.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 32
.L1132:

!  764		 break;

	ba	.L1086
	nop

	! block 33
.L1133:
.L1134:

!  765	      case GL_MAP2_TEXTURE_COORD_1:
!  766	         map2 = &ctx->EvalMap.Map2Texture1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 34
.L1135:

!  767		 break;

	ba	.L1086
	nop

	! block 35
.L1136:
.L1137:

!  768	      case GL_MAP2_TEXTURE_COORD_2:
!  769	         map2 = &ctx->EvalMap.Map2Texture2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 36
.L1138:

!  770		 break;

	ba	.L1086
	nop

	! block 37
.L1139:
.L1140:

!  771	      case GL_MAP2_TEXTURE_COORD_3:
!  772	         map2 = &ctx->EvalMap.Map2Texture3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 38
.L1141:

!  773		 break;

	ba	.L1086
	nop

	! block 39
.L1142:
.L1143:

!  774	      case GL_MAP2_TEXTURE_COORD_4:
!  775	         map2 = &ctx->EvalMap.Map2Texture4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 40
.L1144:

!  776		 break;

	ba	.L1086
	nop

	! block 41
.L1145:
.L1146:

!  777	      default:
!  778		 gl_error( ctx, GL_INVALID_ENUM, "gl_free_control_points" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1147),%l1
	or	%l1,%lo(.L1147),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 42
.L1148:

!  779	         return;

	ba	.L1079
	nop

	! block 43
.L1149:
.L1150:
.L1087:
.L1151:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y3
	nop

	! block 44
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L1145
	nop

	! block 45
	sll	%l0,2,%l1
	sethi	%hi(.L_y4-36),%l0
	or	%l0,%lo(.L_y4-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 46
.L_y3:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L1145
	nop

	! block 47
	sll	%l0,2,%l1
	sethi	%hi(.L_y5-36),%l0
	or	%l0,%lo(.L_y5-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 48
.L1152:
.L1086:
.L1153:
.L1154:
.L1156:

!  780	   }
!  781	
!  782	   if (map1) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L1155
	nop

	! block 49
.L1157:
.L1158:
.L1159:
.L1160:
.L1162:

!  783	      if (data==map1->Points) {

	ld	[%fp+76],%l1
	ld	[%fp-4],%l0
	ld	[%l0+12],%l0
	cmp	%l1,%l0
	bne	.L1161
	nop

	! block 50
.L1163:
.L1164:
.L1165:
.L1166:

!  784	         /* The control points in the display list are currently */
!  785	         /* being used so we can mark them as discard-able. */
!  786	         map1->Retain = GL_FALSE;

	ld	[%fp-4],%l0
	stb	%g0,[%l0+16]

	! block 51
.L1167:
.L1168:
	ba	.L1169
	nop

	! block 52
.L1161:
.L1170:
.L1171:
.L1172:

!  787	      }
!  788	      else {
!  789	         /* The control points in the display list are not currently */
!  790	         /* being used. */
!  791	         free( data );

	ld	[%fp+76],%l0
	call	free
	mov	%l0,%o0

	! block 53
.L1173:
.L1174:
.L1169:
.L1175:
.L1176:
.L1177:
.L1155:
.L1178:
.L1179:
.L1181:

!  792	      }
!  793	   }
!  794	   if (map2) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L1180
	nop

	! block 54
.L1182:
.L1183:
.L1184:
.L1185:
.L1187:

!  795	      if (data==map2->Points) {

	ld	[%fp+76],%l1
	ld	[%fp-8],%l0
	ld	[%l0+24],%l0
	cmp	%l1,%l0
	bne	.L1186
	nop

	! block 55
.L1188:
.L1189:
.L1190:
.L1191:

!  796	         /* The control points in the display list are currently */
!  797	         /* being used so we can mark them as discard-able. */
!  798	         map2->Retain = GL_FALSE;

	ld	[%fp-8],%l0
	stb	%g0,[%l0+28]

	! block 56
.L1192:
.L1193:
	ba	.L1194
	nop

	! block 57
.L1186:
.L1195:
.L1196:
.L1197:

!  799	      }
!  800	      else {
!  801	         /* The control points in the display list are not currently */
!  802	         /* being used. */
!  803	         free( data );

	ld	[%fp+76],%l0
	call	free
	mov	%l0,%o0

	! block 58
.L1198:
.L1199:
.L1194:
.L1200:
.L1201:
.L1202:
.L1180:
.L1203:

	! block 59
.L1204:
.L1205:
.L1079:
	jmp	%i7+8
	restore
	.size	gl_free_control_points,(.-gl_free_control_points)

	.word	.L1100
	.word	.L1097
	.word	.L1103
	.word	.L1106
	.word	.L1109
	.word	.L1112
	.word	.L1115
	.word	.L1091
	.word	.L1094
.L_y4:
	.word	.L1127
	.word	.L1124
	.word	.L1130
	.word	.L1133
	.word	.L1136
	.word	.L1139
	.word	.L1142
	.word	.L1118
	.word	.L1121
.L_y5:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_Map1f
	.type	gl_Map1f,#function
gl_Map1f:
	save	%sp,-104,%sp

	! block 1
.L1208:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]
	ldub	[%fp+99],%l0
	stb	%l0,[%fp+99]

	! block 2
.L1209:
.L1211:
.L1213:

! File eval.c:
!  804	      }
!  805	   }
!  806	
!  807	}
!  808	
!  811	/**********************************************************************/
!  812	/***                      API entry points                          ***/
!  813	/**********************************************************************/
!  814	
!  816	/*
!  817	 * Note that the array of control points must be 'unpacked' at this time.
!  818	 * Input:  retain - if TRUE, this control point data is also in a display
!  819	 *                  list and can't be freed until the list is freed.
!  820	 */
!  821	void gl_Map1f( GLcontext* ctx, GLenum target,
!  822	               GLfloat u1, GLfloat u2, GLint stride,
!  823	               GLint order, const GLfloat *points, GLboolean retain )
!  824	{
!  825	   GLuint k;
!  826	
!  827	   if (!points) {

	ld	[%fp+92],%l0
	cmp	%l0,%g0
	bne	.L1212
	nop

	! block 3
.L1214:
.L1215:
.L1216:
.L1217:

!  828	      gl_error( ctx, GL_OUT_OF_MEMORY, "glMap1f" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1218),%l1
	or	%l1,%lo(.L1218),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1219:

!  829	      return;

	ba	.L1207
	nop

	! block 5
.L1220:
.L1221:
.L1212:
.L1222:
.L1223:

!  830	   }
!  831	
!  832	   /* may be a new stride after copying control points */
!  833	   stride = components( target );

	ld	[%fp+72],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp+84]

	! block 6
.L1224:
.L1226:

!  835	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1225
	nop

	! block 7
.L1227:
.L1228:
.L1229:
.L1230:

!  836	      gl_error( ctx, GL_INVALID_OPERATION, "glMap1" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1231),%l1
	or	%l1,%lo(.L1231),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 8
.L1232:

!  837	      return;

	ba	.L1207
	nop

	! block 9
.L1233:
.L1234:
.L1225:
.L1235:
.L1236:
.L1238:

!  838	   }
!  839	
!  840	   if (u1==u2) {

	ld	[%fp+76],%f5
	ld	[%fp+80],%f4
	fcmps	%f5,%f4
	fbne	.L1237
	nop

	! block 10
.L1239:
.L1240:
.L1241:
.L1242:

!  841	      gl_error( ctx, GL_INVALID_VALUE, "glMap1(u1,u2)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1243),%l1
	or	%l1,%lo(.L1243),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L1244:

!  842	      return;

	ba	.L1207
	nop

	! block 12
.L1245:
.L1246:
.L1237:
.L1247:
.L1248:
.L1250:

!  843	   }
!  844	
!  845	   if (order<1 || order>MAX_EVAL_ORDER) {

	ld	[%fp+88],%l0
	cmp	%l0,1
	bl	.L1251
	nop

	! block 13
.L1252:
	ld	[%fp+88],%l0
	cmp	%l0,30
	ble	.L1249
	nop

	! block 14
.L1253:
.L1251:
.L1254:
.L1255:
.L1256:

!  846	      gl_error( ctx, GL_INVALID_VALUE, "glMap1(order)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1257),%l1
	or	%l1,%lo(.L1257),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L1258:

!  847	      return;

	ba	.L1207
	nop

	! block 16
.L1259:
.L1260:
.L1249:
.L1261:
.L1262:

!  848	   }
!  849	
!  850	   k = components( target );

	ld	[%fp+72],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-4]

	! block 17
.L1263:
.L1265:

!  851	   if (k==0) {

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L1264
	nop

	! block 18
.L1266:
.L1267:
.L1268:
.L1269:

!  852	      gl_error( ctx, GL_INVALID_ENUM, "glMap1(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1270),%l1
	or	%l1,%lo(.L1270),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 19
.L1271:
.L1272:
.L1264:
.L1273:
.L1274:
.L1276:

!  853	   }
!  854	
!  855	   if (stride < k) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	cmp	%l1,%l0
	bgeu	.L1275
	nop

	! block 20
.L1277:
.L1278:
.L1279:
.L1280:

!  856	      gl_error( ctx, GL_INVALID_VALUE, "glMap1(stride)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1281),%l1
	or	%l1,%lo(.L1281),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 21
.L1282:

!  857	      return;

	ba	.L1207
	nop

	! block 22
.L1283:
.L1284:
.L1275:
.L1285:
.L1286:
.L1289:

!  858	   }
!  859	
!  860	   switch (target) {

	ba	.L1288
	nop

	! block 23
.L1290:
.L1291:
.L1292:
.L1293:

!  861	      case GL_MAP1_VERTEX_3:
!  862	         ctx->EvalMap.Map1Vertex3.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	st	%l2,[%l0+%l1]

	! block 24
.L1294:

!  863		 ctx->EvalMap.Map1Vertex3.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	st	%f4,[%l0+4]

	! block 25
.L1295:

!  864		 ctx->EvalMap.Map1Vertex3.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	st	%f4,[%l0+8]

	! block 26
.L1296:
.L1298:

!  865		 if (ctx->EvalMap.Map1Vertex3.Points
!  866	             && !ctx->EvalMap.Map1Vertex3.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%l0
	cmp	%l0,%g0
	be	.L1297
	nop

	! block 27
.L1299:
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+16],%l0
	cmp	%l0,%g0
	bne	.L1297
	nop

	! block 28
.L1300:
.L1301:
.L1302:
.L1303:

!  867		    free( ctx->EvalMap.Map1Vertex3.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%l0
	call	free
	mov	%l0,%o0

	! block 29
.L1304:
.L1305:
.L1297:
.L1306:
.L1307:

!  868		 }
!  869		 ctx->EvalMap.Map1Vertex3.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	st	%l2,[%l0+12]

	! block 30
.L1308:

!  870	         ctx->EvalMap.Map1Vertex3.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+16]

	! block 31
.L1309:

!  871		 break;

	ba	.L1287
	nop

	! block 32
.L1310:
.L1311:

!  872	      case GL_MAP1_VERTEX_4:
!  873	         ctx->EvalMap.Map1Vertex4.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	st	%l2,[%l0+%l1]

	! block 33
.L1312:

!  874		 ctx->EvalMap.Map1Vertex4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	st	%f4,[%l0+%l1]

	! block 34
.L1313:

!  875		 ctx->EvalMap.Map1Vertex4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	st	%f4,[%l0+%l1]

	! block 35
.L1314:
.L1316:

!  876		 if (ctx->EvalMap.Map1Vertex4.Points
!  877	             && !ctx->EvalMap.Map1Vertex4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1315
	nop

	! block 36
.L1317:
	ld	[%fp+68],%l0
	sethi	%hi(0xde08),%l1
	or	%l1,%lo(0xde08),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1315
	nop

	! block 37
.L1318:
.L1319:
.L1320:
.L1321:

!  878		    free( ctx->EvalMap.Map1Vertex4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 38
.L1322:
.L1323:
.L1315:
.L1324:
.L1325:

!  879		 }
!  880		 ctx->EvalMap.Map1Vertex4.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	st	%l2,[%l0+%l1]

	! block 39
.L1326:

!  881		 ctx->EvalMap.Map1Vertex4.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde08),%l1
	or	%l1,%lo(0xde08),%l1
	stb	%l2,[%l0+%l1]

	! block 40
.L1327:

!  882		 break;

	ba	.L1287
	nop

	! block 41
.L1328:
.L1329:

!  883	      case GL_MAP1_INDEX:
!  884	         ctx->EvalMap.Map1Index.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	st	%l2,[%l0+%l1]

	! block 42
.L1330:

!  885		 ctx->EvalMap.Map1Index.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	st	%f4,[%l0+%l1]

	! block 43
.L1331:

!  886		 ctx->EvalMap.Map1Index.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	st	%f4,[%l0+%l1]

	! block 44
.L1332:
.L1334:

!  887		 if (ctx->EvalMap.Map1Index.Points
!  888	             && !ctx->EvalMap.Map1Index.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1333
	nop

	! block 45
.L1335:
	ld	[%fp+68],%l0
	sethi	%hi(0xde1c),%l1
	or	%l1,%lo(0xde1c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1333
	nop

	! block 46
.L1336:
.L1337:
.L1338:
.L1339:

!  889		    free( ctx->EvalMap.Map1Index.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 47
.L1340:
.L1341:
.L1333:
.L1342:
.L1343:

!  890		 }
!  891		 ctx->EvalMap.Map1Index.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	st	%l2,[%l0+%l1]

	! block 48
.L1344:

!  892		 ctx->EvalMap.Map1Index.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde1c),%l1
	or	%l1,%lo(0xde1c),%l1
	stb	%l2,[%l0+%l1]

	! block 49
.L1345:

!  893		 break;

	ba	.L1287
	nop

	! block 50
.L1346:
.L1347:

!  894	      case GL_MAP1_COLOR_4:
!  895	         ctx->EvalMap.Map1Color4.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	st	%l2,[%l0+%l1]

	! block 51
.L1348:

!  896		 ctx->EvalMap.Map1Color4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	st	%f4,[%l0+%l1]

	! block 52
.L1349:

!  897		 ctx->EvalMap.Map1Color4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	st	%f4,[%l0+%l1]

	! block 53
.L1350:
.L1352:

!  898		 if (ctx->EvalMap.Map1Color4.Points
!  899	             && !ctx->EvalMap.Map1Color4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1351
	nop

	! block 54
.L1353:
	ld	[%fp+68],%l0
	sethi	%hi(0xde30),%l1
	or	%l1,%lo(0xde30),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1351
	nop

	! block 55
.L1354:
.L1355:
.L1356:
.L1357:

!  900		    free( ctx->EvalMap.Map1Color4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 56
.L1358:
.L1359:
.L1351:
.L1360:
.L1361:

!  901		 }
!  902		 ctx->EvalMap.Map1Color4.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	st	%l2,[%l0+%l1]

	! block 57
.L1362:

!  903		 ctx->EvalMap.Map1Color4.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde30),%l1
	or	%l1,%lo(0xde30),%l1
	stb	%l2,[%l0+%l1]

	! block 58
.L1363:

!  904		 break;

	ba	.L1287
	nop

	! block 59
.L1364:
.L1365:

!  905	      case GL_MAP1_NORMAL:
!  906	         ctx->EvalMap.Map1Normal.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	st	%l2,[%l0+%l1]

	! block 60
.L1366:

!  907		 ctx->EvalMap.Map1Normal.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	st	%f4,[%l0+%l1]

	! block 61
.L1367:

!  908		 ctx->EvalMap.Map1Normal.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	st	%f4,[%l0+%l1]

	! block 62
.L1368:
.L1370:

!  909		 if (ctx->EvalMap.Map1Normal.Points
!  910	             && !ctx->EvalMap.Map1Normal.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1369
	nop

	! block 63
.L1371:
	ld	[%fp+68],%l0
	sethi	%hi(0xde44),%l1
	or	%l1,%lo(0xde44),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1369
	nop

	! block 64
.L1372:
.L1373:
.L1374:
.L1375:

!  911		    free( ctx->EvalMap.Map1Normal.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 65
.L1376:
.L1377:
.L1369:
.L1378:
.L1379:

!  912		 }
!  913		 ctx->EvalMap.Map1Normal.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	st	%l2,[%l0+%l1]

	! block 66
.L1380:

!  914		 ctx->EvalMap.Map1Normal.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde44),%l1
	or	%l1,%lo(0xde44),%l1
	stb	%l2,[%l0+%l1]

	! block 67
.L1381:

!  915		 break;

	ba	.L1287
	nop

	! block 68
.L1382:
.L1383:

!  916	      case GL_MAP1_TEXTURE_COORD_1:
!  917	         ctx->EvalMap.Map1Texture1.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	st	%l2,[%l0+%l1]

	! block 69
.L1384:

!  918		 ctx->EvalMap.Map1Texture1.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	st	%f4,[%l0+%l1]

	! block 70
.L1385:

!  919		 ctx->EvalMap.Map1Texture1.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	st	%f4,[%l0+%l1]

	! block 71
.L1386:
.L1388:

!  920		 if (ctx->EvalMap.Map1Texture1.Points
!  921	             && !ctx->EvalMap.Map1Texture1.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1387
	nop

	! block 72
.L1389:
	ld	[%fp+68],%l0
	sethi	%hi(0xde58),%l1
	or	%l1,%lo(0xde58),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1387
	nop

	! block 73
.L1390:
.L1391:
.L1392:
.L1393:

!  922		    free( ctx->EvalMap.Map1Texture1.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 74
.L1394:
.L1395:
.L1387:
.L1396:
.L1397:

!  923		 }
!  924		 ctx->EvalMap.Map1Texture1.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	st	%l2,[%l0+%l1]

	! block 75
.L1398:

!  925		 ctx->EvalMap.Map1Texture1.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde58),%l1
	or	%l1,%lo(0xde58),%l1
	stb	%l2,[%l0+%l1]

	! block 76
.L1399:

!  926		 break;

	ba	.L1287
	nop

	! block 77
.L1400:
.L1401:

!  927	      case GL_MAP1_TEXTURE_COORD_2:
!  928	         ctx->EvalMap.Map1Texture2.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	st	%l2,[%l0+%l1]

	! block 78
.L1402:

!  929		 ctx->EvalMap.Map1Texture2.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	st	%f4,[%l0+%l1]

	! block 79
.L1403:

!  930		 ctx->EvalMap.Map1Texture2.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	st	%f4,[%l0+%l1]

	! block 80
.L1404:
.L1406:

!  931		 if (ctx->EvalMap.Map1Texture2.Points
!  932	             && !ctx->EvalMap.Map1Texture2.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1405
	nop

	! block 81
.L1407:
	ld	[%fp+68],%l0
	sethi	%hi(0xde6c),%l1
	or	%l1,%lo(0xde6c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1405
	nop

	! block 82
.L1408:
.L1409:
.L1410:
.L1411:

!  933		    free( ctx->EvalMap.Map1Texture2.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 83
.L1412:
.L1413:
.L1405:
.L1414:
.L1415:

!  934		 }
!  935		 ctx->EvalMap.Map1Texture2.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	st	%l2,[%l0+%l1]

	! block 84
.L1416:

!  936		 ctx->EvalMap.Map1Texture2.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde6c),%l1
	or	%l1,%lo(0xde6c),%l1
	stb	%l2,[%l0+%l1]

	! block 85
.L1417:

!  937		 break;

	ba	.L1287
	nop

	! block 86
.L1418:
.L1419:

!  938	      case GL_MAP1_TEXTURE_COORD_3:
!  939	         ctx->EvalMap.Map1Texture3.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	st	%l2,[%l0+%l1]

	! block 87
.L1420:

!  940		 ctx->EvalMap.Map1Texture3.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	st	%f4,[%l0+%l1]

	! block 88
.L1421:

!  941		 ctx->EvalMap.Map1Texture3.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	st	%f4,[%l0+%l1]

	! block 89
.L1422:
.L1424:

!  942		 if (ctx->EvalMap.Map1Texture3.Points
!  943	             && !ctx->EvalMap.Map1Texture3.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1423
	nop

	! block 90
.L1425:
	ld	[%fp+68],%l0
	sethi	%hi(0xde80),%l1
	or	%l1,%lo(0xde80),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1423
	nop

	! block 91
.L1426:
.L1427:
.L1428:
.L1429:

!  944		    free( ctx->EvalMap.Map1Texture3.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 92
.L1430:
.L1431:
.L1423:
.L1432:
.L1433:

!  945		 }
!  946		 ctx->EvalMap.Map1Texture3.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	st	%l2,[%l0+%l1]

	! block 93
.L1434:

!  947		 ctx->EvalMap.Map1Texture3.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde80),%l1
	or	%l1,%lo(0xde80),%l1
	stb	%l2,[%l0+%l1]

	! block 94
.L1435:

!  948		 break;

	ba	.L1287
	nop

	! block 95
.L1436:
.L1437:

!  949	      case GL_MAP1_TEXTURE_COORD_4:
!  950	         ctx->EvalMap.Map1Texture4.Order = order;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	st	%l2,[%l0+%l1]

	! block 96
.L1438:

!  951		 ctx->EvalMap.Map1Texture4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	st	%f4,[%l0+%l1]

	! block 97
.L1439:

!  952		 ctx->EvalMap.Map1Texture4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	st	%f4,[%l0+%l1]

	! block 98
.L1440:
.L1442:

!  953		 if (ctx->EvalMap.Map1Texture4.Points
!  954	             && !ctx->EvalMap.Map1Texture4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1441
	nop

	! block 99
.L1443:
	ld	[%fp+68],%l0
	sethi	%hi(0xde94),%l1
	or	%l1,%lo(0xde94),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1441
	nop

	! block 100
.L1444:
.L1445:
.L1446:
.L1447:

!  955		    free( ctx->EvalMap.Map1Texture4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 101
.L1448:
.L1449:
.L1441:
.L1450:
.L1451:

!  956		 }
!  957		 ctx->EvalMap.Map1Texture4.Points = (GLfloat *) points;

	ld	[%fp+92],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	st	%l2,[%l0+%l1]

	! block 102
.L1452:

!  958		 ctx->EvalMap.Map1Texture4.Retain = retain;

	ldub	[%fp+99],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde94),%l1
	or	%l1,%lo(0xde94),%l1
	stb	%l2,[%l0+%l1]

	! block 103
.L1453:

!  959		 break;

	ba	.L1287
	nop

	! block 104
.L1454:
.L1455:

!  960	      default:
!  961	         gl_error( ctx, GL_INVALID_ENUM, "glMap1(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1456),%l1
	or	%l1,%lo(.L1456),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 105
.L1457:
.L1458:
	ba	.L1287
	nop

	! block 106
.L1288:
.L1459:
	ld	[%fp+72],%l0
	sub	%l0,3472,%l0
	cmp	%l0,8
	bgu	.L1454
	nop

	! block 107
	sll	%l0,2,%l1
	sethi	%hi(.L_y6-36),%l0
	or	%l0,%lo(.L_y6-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 108
.L1460:
.L1287:
.L1461:

	! block 109
.L1462:
.L1463:
.L1207:
	jmp	%i7+8
	restore
	.size	gl_Map1f,(.-gl_Map1f)

	.word	.L1346
	.word	.L1328
	.word	.L1364
	.word	.L1382
	.word	.L1400
	.word	.L1418
	.word	.L1436
	.word	.L1292
	.word	.L1310
.L_y6:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_Map2f
	.type	gl_Map2f,#function
gl_Map2f:
	save	%sp,-104,%sp

	! block 1
.L1466:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]
	ld	[%fp+96],%l0
	st	%l0,[%fp+96]
	ld	[%fp+100],%l0
	st	%l0,[%fp+100]
	ld	[%fp+104],%l0
	st	%l0,[%fp+104]
	ld	[%fp+108],%l0
	st	%l0,[%fp+108]
	ldub	[%fp+115],%l0
	stb	%l0,[%fp+115]

	! block 2
.L1467:
.L1469:
.L1471:

! File eval.c:
!  962	   }
!  963	}
!  964	
!  968	/*
!  969	 * Note that the array of control points must be 'unpacked' at this time.
!  970	 * Input:  retain - if TRUE, this control point data is also in a display
!  971	 *                  list and can't be freed until the list is freed.
!  972	 */
!  973	void gl_Map2f( GLcontext* ctx, GLenum target,
!  974		      GLfloat u1, GLfloat u2, GLint ustride, GLint uorder,
!  975		      GLfloat v1, GLfloat v2, GLint vstride, GLint vorder,
!  976		      const GLfloat *points, GLboolean retain )
!  977	{
!  978	   GLuint k;
!  979	
!  980	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1470
	nop

	! block 3
.L1472:
.L1473:
.L1474:
.L1475:

!  981	      gl_error( ctx, GL_INVALID_OPERATION, "glMap2" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1476),%l1
	or	%l1,%lo(.L1476),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1477:

!  982	      return;

	ba	.L1465
	nop

	! block 5
.L1478:
.L1479:
.L1470:
.L1480:
.L1481:
.L1483:

!  983	   }
!  984	
!  985	   if (u1==u2) {

	ld	[%fp+76],%f5
	ld	[%fp+80],%f4
	fcmps	%f5,%f4
	fbne	.L1482
	nop

	! block 6
.L1484:
.L1485:
.L1486:
.L1487:

!  986	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(u1,u2)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1488),%l1
	or	%l1,%lo(.L1488),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L1489:

!  987	      return;

	ba	.L1465
	nop

	! block 8
.L1490:
.L1491:
.L1482:
.L1492:
.L1493:
.L1495:

!  988	   }
!  989	
!  990	   if (v1==v2) {

	ld	[%fp+92],%f5
	ld	[%fp+96],%f4
	fcmps	%f5,%f4
	fbne	.L1494
	nop

	! block 9
.L1496:
.L1497:
.L1498:
.L1499:

!  991	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(v1,v2)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1500),%l1
	or	%l1,%lo(.L1500),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 10
.L1501:

!  992	      return;

	ba	.L1465
	nop

	! block 11
.L1502:
.L1503:
.L1494:
.L1504:
.L1505:
.L1507:

!  993	   }
!  994	
!  995	   if (uorder<1 || uorder>MAX_EVAL_ORDER) {

	ld	[%fp+88],%l0
	cmp	%l0,1
	bl	.L1508
	nop

	! block 12
.L1509:
	ld	[%fp+88],%l0
	cmp	%l0,30
	ble	.L1506
	nop

	! block 13
.L1510:
.L1508:
.L1511:
.L1512:
.L1513:

!  996	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(uorder)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1514),%l1
	or	%l1,%lo(.L1514),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 14
.L1515:

!  997	      return;

	ba	.L1465
	nop

	! block 15
.L1516:
.L1517:
.L1506:
.L1518:
.L1519:
.L1521:

!  998	   }
!  999	
! 1000	   if (vorder<1 || vorder>MAX_EVAL_ORDER) {

	ld	[%fp+104],%l0
	cmp	%l0,1
	bl	.L1522
	nop

	! block 16
.L1523:
	ld	[%fp+104],%l0
	cmp	%l0,30
	ble	.L1520
	nop

	! block 17
.L1524:
.L1522:
.L1525:
.L1526:
.L1527:

! 1001	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(vorder)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1528),%l1
	or	%l1,%lo(.L1528),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L1529:

! 1002	      return;

	ba	.L1465
	nop

	! block 19
.L1530:
.L1531:
.L1520:
.L1532:
.L1533:

! 1003	   }
! 1004	
! 1005	   k = components( target );

	ld	[%fp+72],%l0
	call	components
	mov	%l0,%o0
	st	%o0,[%fp-4]

	! block 20
.L1534:
.L1536:

! 1006	   if (k==0) {

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L1535
	nop

	! block 21
.L1537:
.L1538:
.L1539:
.L1540:

! 1007	      gl_error( ctx, GL_INVALID_ENUM, "glMap2(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1541),%l1
	or	%l1,%lo(.L1541),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 22
.L1542:
.L1543:
.L1535:
.L1544:
.L1545:
.L1547:

! 1008	   }
! 1009	
! 1010	   if (ustride < k) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	cmp	%l1,%l0
	bgeu	.L1546
	nop

	! block 23
.L1548:
.L1549:
.L1550:
.L1551:

! 1011	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(ustride)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1552),%l1
	or	%l1,%lo(.L1552),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 24
.L1553:

! 1012	      return;

	ba	.L1465
	nop

	! block 25
.L1554:
.L1555:
.L1546:
.L1556:
.L1557:
.L1559:

! 1013	   }
! 1014	   if (vstride < k) {

	ld	[%fp+100],%l1
	ld	[%fp-4],%l0
	cmp	%l1,%l0
	bgeu	.L1558
	nop

	! block 26
.L1560:
.L1561:
.L1562:
.L1563:

! 1015	      gl_error( ctx, GL_INVALID_VALUE, "glMap2(vstride)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1564),%l1
	or	%l1,%lo(.L1564),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 27
.L1565:

! 1016	      return;

	ba	.L1465
	nop

	! block 28
.L1566:
.L1567:
.L1558:
.L1568:
.L1569:
.L1572:

! 1017	   }
! 1018	
! 1019	   switch (target) {

	ba	.L1571
	nop

	! block 29
.L1573:
.L1574:
.L1575:
.L1576:

! 1020	      case GL_MAP2_VERTEX_3:
! 1021	         ctx->EvalMap.Map2Vertex3.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	st	%l2,[%l0+%l1]

	! block 30
.L1577:

! 1022		 ctx->EvalMap.Map2Vertex3.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	st	%f4,[%l0+%l1]

	! block 31
.L1578:

! 1023		 ctx->EvalMap.Map2Vertex3.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	st	%f4,[%l0+%l1]

	! block 32
.L1579:

! 1024	         ctx->EvalMap.Map2Vertex3.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	st	%l2,[%l0+%l1]

	! block 33
.L1580:

! 1025		 ctx->EvalMap.Map2Vertex3.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	st	%f4,[%l0+%l1]

	! block 34
.L1581:

! 1026		 ctx->EvalMap.Map2Vertex3.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	st	%f4,[%l0+%l1]

	! block 35
.L1582:
.L1584:

! 1027		 if (ctx->EvalMap.Map2Vertex3.Points
! 1028	             && !ctx->EvalMap.Map2Vertex3.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1583
	nop

	! block 36
.L1585:
	ld	[%fp+68],%l0
	sethi	%hi(0xdeb4),%l1
	or	%l1,%lo(0xdeb4),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1583
	nop

	! block 37
.L1586:
.L1587:
.L1588:
.L1589:

! 1029		    free( ctx->EvalMap.Map2Vertex3.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 38
.L1590:
.L1591:
.L1583:
.L1592:
.L1593:

! 1030		 }
! 1031		 ctx->EvalMap.Map2Vertex3.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdeb4),%l1
	or	%l1,%lo(0xdeb4),%l1
	stb	%l2,[%l0+%l1]

	! block 39
.L1594:

! 1032		 ctx->EvalMap.Map2Vertex3.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	st	%l2,[%l0+%l1]

	! block 40
.L1595:

! 1033		 break;

	ba	.L1570
	nop

	! block 41
.L1596:
.L1597:

! 1034	      case GL_MAP2_VERTEX_4:
! 1035	         ctx->EvalMap.Map2Vertex4.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	st	%l2,[%l0+%l1]

	! block 42
.L1598:

! 1036		 ctx->EvalMap.Map2Vertex4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	st	%f4,[%l0+%l1]

	! block 43
.L1599:

! 1037		 ctx->EvalMap.Map2Vertex4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	st	%f4,[%l0+%l1]

	! block 44
.L1600:

! 1038	         ctx->EvalMap.Map2Vertex4.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	st	%l2,[%l0+%l1]

	! block 45
.L1601:

! 1039		 ctx->EvalMap.Map2Vertex4.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	st	%f4,[%l0+%l1]

	! block 46
.L1602:

! 1040		 ctx->EvalMap.Map2Vertex4.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	st	%f4,[%l0+%l1]

	! block 47
.L1603:
.L1605:

! 1041		 if (ctx->EvalMap.Map2Vertex4.Points
! 1042	             && !ctx->EvalMap.Map2Vertex4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1604
	nop

	! block 48
.L1606:
	ld	[%fp+68],%l0
	sethi	%hi(0xded4),%l1
	or	%l1,%lo(0xded4),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1604
	nop

	! block 49
.L1607:
.L1608:
.L1609:
.L1610:

! 1043		    free( ctx->EvalMap.Map2Vertex4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 50
.L1611:
.L1612:
.L1604:
.L1613:
.L1614:

! 1044		 }
! 1045		 ctx->EvalMap.Map2Vertex4.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	st	%l2,[%l0+%l1]

	! block 51
.L1615:

! 1046		 ctx->EvalMap.Map2Vertex4.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xded4),%l1
	or	%l1,%lo(0xded4),%l1
	stb	%l2,[%l0+%l1]

	! block 52
.L1616:

! 1047		 break;

	ba	.L1570
	nop

	! block 53
.L1617:
.L1618:

! 1048	      case GL_MAP2_INDEX:
! 1049	         ctx->EvalMap.Map2Index.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	st	%l2,[%l0+%l1]

	! block 54
.L1619:

! 1050		 ctx->EvalMap.Map2Index.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	st	%f4,[%l0+%l1]

	! block 55
.L1620:

! 1051		 ctx->EvalMap.Map2Index.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	st	%f4,[%l0+%l1]

	! block 56
.L1621:

! 1052	         ctx->EvalMap.Map2Index.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	st	%l2,[%l0+%l1]

	! block 57
.L1622:

! 1053		 ctx->EvalMap.Map2Index.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	st	%f4,[%l0+%l1]

	! block 58
.L1623:

! 1054		 ctx->EvalMap.Map2Index.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	st	%f4,[%l0+%l1]

	! block 59
.L1624:
.L1626:

! 1055		 if (ctx->EvalMap.Map2Index.Points
! 1056	             && !ctx->EvalMap.Map2Index.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1625
	nop

	! block 60
.L1627:
	ld	[%fp+68],%l0
	sethi	%hi(0xdef4),%l1
	or	%l1,%lo(0xdef4),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1625
	nop

	! block 61
.L1628:
.L1629:
.L1630:
.L1631:

! 1057		    free( ctx->EvalMap.Map2Index.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 62
.L1632:
.L1633:
.L1625:
.L1634:
.L1635:

! 1058		 }
! 1059		 ctx->EvalMap.Map2Index.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdef4),%l1
	or	%l1,%lo(0xdef4),%l1
	stb	%l2,[%l0+%l1]

	! block 63
.L1636:

! 1060		 ctx->EvalMap.Map2Index.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	st	%l2,[%l0+%l1]

	! block 64
.L1637:

! 1061		 break;

	ba	.L1570
	nop

	! block 65
.L1638:
.L1639:

! 1062	      case GL_MAP2_COLOR_4:
! 1063	         ctx->EvalMap.Map2Color4.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	st	%l2,[%l0+%l1]

	! block 66
.L1640:

! 1064		 ctx->EvalMap.Map2Color4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	st	%f4,[%l0+%l1]

	! block 67
.L1641:

! 1065		 ctx->EvalMap.Map2Color4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	st	%f4,[%l0+%l1]

	! block 68
.L1642:

! 1066	         ctx->EvalMap.Map2Color4.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	st	%l2,[%l0+%l1]

	! block 69
.L1643:

! 1067		 ctx->EvalMap.Map2Color4.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	st	%f4,[%l0+%l1]

	! block 70
.L1644:

! 1068		 ctx->EvalMap.Map2Color4.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	st	%f4,[%l0+%l1]

	! block 71
.L1645:
.L1647:

! 1069		 if (ctx->EvalMap.Map2Color4.Points
! 1070	             && !ctx->EvalMap.Map2Color4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1646
	nop

	! block 72
.L1648:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf14),%l1
	or	%l1,%lo(0xdf14),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1646
	nop

	! block 73
.L1649:
.L1650:
.L1651:
.L1652:

! 1071		    free( ctx->EvalMap.Map2Color4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 74
.L1653:
.L1654:
.L1646:
.L1655:
.L1656:

! 1072		 }
! 1073		 ctx->EvalMap.Map2Color4.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf14),%l1
	or	%l1,%lo(0xdf14),%l1
	stb	%l2,[%l0+%l1]

	! block 75
.L1657:

! 1074		 ctx->EvalMap.Map2Color4.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	st	%l2,[%l0+%l1]

	! block 76
.L1658:

! 1075		 break;

	ba	.L1570
	nop

	! block 77
.L1659:
.L1660:

! 1076	      case GL_MAP2_NORMAL:
! 1077	         ctx->EvalMap.Map2Normal.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	st	%l2,[%l0+%l1]

	! block 78
.L1661:

! 1078		 ctx->EvalMap.Map2Normal.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	st	%f4,[%l0+%l1]

	! block 79
.L1662:

! 1079		 ctx->EvalMap.Map2Normal.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	st	%f4,[%l0+%l1]

	! block 80
.L1663:

! 1080	         ctx->EvalMap.Map2Normal.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	st	%l2,[%l0+%l1]

	! block 81
.L1664:

! 1081		 ctx->EvalMap.Map2Normal.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	st	%f4,[%l0+%l1]

	! block 82
.L1665:

! 1082		 ctx->EvalMap.Map2Normal.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	st	%f4,[%l0+%l1]

	! block 83
.L1666:
.L1668:

! 1083		 if (ctx->EvalMap.Map2Normal.Points
! 1084	             && !ctx->EvalMap.Map2Normal.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1667
	nop

	! block 84
.L1669:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf34),%l1
	or	%l1,%lo(0xdf34),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1667
	nop

	! block 85
.L1670:
.L1671:
.L1672:
.L1673:

! 1085		    free( ctx->EvalMap.Map2Normal.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 86
.L1674:
.L1675:
.L1667:
.L1676:
.L1677:

! 1086		 }
! 1087		 ctx->EvalMap.Map2Normal.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf34),%l1
	or	%l1,%lo(0xdf34),%l1
	stb	%l2,[%l0+%l1]

	! block 87
.L1678:

! 1088		 ctx->EvalMap.Map2Normal.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	st	%l2,[%l0+%l1]

	! block 88
.L1679:

! 1089		 break;

	ba	.L1570
	nop

	! block 89
.L1680:
.L1681:

! 1090	      case GL_MAP2_TEXTURE_COORD_1:
! 1091	         ctx->EvalMap.Map2Texture1.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	st	%l2,[%l0+%l1]

	! block 90
.L1682:

! 1092		 ctx->EvalMap.Map2Texture1.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	st	%f4,[%l0+%l1]

	! block 91
.L1683:

! 1093		 ctx->EvalMap.Map2Texture1.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	st	%f4,[%l0+%l1]

	! block 92
.L1684:

! 1094	         ctx->EvalMap.Map2Texture1.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	st	%l2,[%l0+%l1]

	! block 93
.L1685:

! 1095		 ctx->EvalMap.Map2Texture1.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	st	%f4,[%l0+%l1]

	! block 94
.L1686:

! 1096		 ctx->EvalMap.Map2Texture1.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	st	%f4,[%l0+%l1]

	! block 95
.L1687:
.L1689:

! 1097		 if (ctx->EvalMap.Map2Texture1.Points
! 1098	             && !ctx->EvalMap.Map2Texture1.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1688
	nop

	! block 96
.L1690:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf54),%l1
	or	%l1,%lo(0xdf54),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1688
	nop

	! block 97
.L1691:
.L1692:
.L1693:
.L1694:

! 1099		    free( ctx->EvalMap.Map2Texture1.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 98
.L1695:
.L1696:
.L1688:
.L1697:
.L1698:

! 1100		 }
! 1101		 ctx->EvalMap.Map2Texture1.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf54),%l1
	or	%l1,%lo(0xdf54),%l1
	stb	%l2,[%l0+%l1]

	! block 99
.L1699:

! 1102		 ctx->EvalMap.Map2Texture1.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	st	%l2,[%l0+%l1]

	! block 100
.L1700:

! 1103		 break;

	ba	.L1570
	nop

	! block 101
.L1701:
.L1702:

! 1104	      case GL_MAP2_TEXTURE_COORD_2:
! 1105	         ctx->EvalMap.Map2Texture2.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	st	%l2,[%l0+%l1]

	! block 102
.L1703:

! 1106		 ctx->EvalMap.Map2Texture2.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	st	%f4,[%l0+%l1]

	! block 103
.L1704:

! 1107		 ctx->EvalMap.Map2Texture2.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	st	%f4,[%l0+%l1]

	! block 104
.L1705:

! 1108	         ctx->EvalMap.Map2Texture2.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	st	%l2,[%l0+%l1]

	! block 105
.L1706:

! 1109		 ctx->EvalMap.Map2Texture2.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	st	%f4,[%l0+%l1]

	! block 106
.L1707:

! 1110		 ctx->EvalMap.Map2Texture2.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	st	%f4,[%l0+%l1]

	! block 107
.L1708:
.L1710:

! 1111		 if (ctx->EvalMap.Map2Texture2.Points
! 1112	             && !ctx->EvalMap.Map2Texture2.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1709
	nop

	! block 108
.L1711:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf74),%l1
	or	%l1,%lo(0xdf74),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1709
	nop

	! block 109
.L1712:
.L1713:
.L1714:
.L1715:

! 1113		    free( ctx->EvalMap.Map2Texture2.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 110
.L1716:
.L1717:
.L1709:
.L1718:
.L1719:

! 1114		 }
! 1115		 ctx->EvalMap.Map2Texture2.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf74),%l1
	or	%l1,%lo(0xdf74),%l1
	stb	%l2,[%l0+%l1]

	! block 111
.L1720:

! 1116		 ctx->EvalMap.Map2Texture2.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	st	%l2,[%l0+%l1]

	! block 112
.L1721:

! 1117		 break;

	ba	.L1570
	nop

	! block 113
.L1722:
.L1723:

! 1118	      case GL_MAP2_TEXTURE_COORD_3:
! 1119	         ctx->EvalMap.Map2Texture3.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	st	%l2,[%l0+%l1]

	! block 114
.L1724:

! 1120		 ctx->EvalMap.Map2Texture3.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	st	%f4,[%l0+%l1]

	! block 115
.L1725:

! 1121		 ctx->EvalMap.Map2Texture3.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	st	%f4,[%l0+%l1]

	! block 116
.L1726:

! 1122	         ctx->EvalMap.Map2Texture3.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	st	%l2,[%l0+%l1]

	! block 117
.L1727:

! 1123		 ctx->EvalMap.Map2Texture3.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	st	%f4,[%l0+%l1]

	! block 118
.L1728:

! 1124		 ctx->EvalMap.Map2Texture3.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	st	%f4,[%l0+%l1]

	! block 119
.L1729:
.L1731:

! 1125		 if (ctx->EvalMap.Map2Texture3.Points
! 1126	             && !ctx->EvalMap.Map2Texture3.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1730
	nop

	! block 120
.L1732:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf94),%l1
	or	%l1,%lo(0xdf94),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1730
	nop

	! block 121
.L1733:
.L1734:
.L1735:
.L1736:

! 1127		    free( ctx->EvalMap.Map2Texture3.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 122
.L1737:
.L1738:
.L1730:
.L1739:
.L1740:

! 1128		 }
! 1129		 ctx->EvalMap.Map2Texture3.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf94),%l1
	or	%l1,%lo(0xdf94),%l1
	stb	%l2,[%l0+%l1]

	! block 123
.L1741:

! 1130		 ctx->EvalMap.Map2Texture3.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	st	%l2,[%l0+%l1]

	! block 124
.L1742:

! 1131		 break;

	ba	.L1570
	nop

	! block 125
.L1743:
.L1744:

! 1132	      case GL_MAP2_TEXTURE_COORD_4:
! 1133	         ctx->EvalMap.Map2Texture4.Uorder = uorder;

	ld	[%fp+88],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	st	%l2,[%l0+%l1]

	! block 126
.L1745:

! 1134		 ctx->EvalMap.Map2Texture4.u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	st	%f4,[%l0+%l1]

	! block 127
.L1746:

! 1135		 ctx->EvalMap.Map2Texture4.u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	st	%f4,[%l0+%l1]

	! block 128
.L1747:

! 1136	         ctx->EvalMap.Map2Texture4.Vorder = vorder;

	ld	[%fp+104],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	st	%l2,[%l0+%l1]

	! block 129
.L1748:

! 1137		 ctx->EvalMap.Map2Texture4.v1 = v1;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	st	%f4,[%l0+%l1]

	! block 130
.L1749:

! 1138		 ctx->EvalMap.Map2Texture4.v2 = v2;

	ld	[%fp+96],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	st	%f4,[%l0+%l1]

	! block 131
.L1750:
.L1752:

! 1139		 if (ctx->EvalMap.Map2Texture4.Points
! 1140	             && !ctx->EvalMap.Map2Texture4.Retain) {

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1751
	nop

	! block 132
.L1753:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfb4),%l1
	or	%l1,%lo(0xdfb4),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L1751
	nop

	! block 133
.L1754:
.L1755:
.L1756:
.L1757:

! 1141		    free( ctx->EvalMap.Map2Texture4.Points );

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	ld	[%l0+%l1],%l0
	call	free
	mov	%l0,%o0

	! block 134
.L1758:
.L1759:
.L1751:
.L1760:
.L1761:

! 1142		 }
! 1143		 ctx->EvalMap.Map2Texture4.Retain = retain;

	ldub	[%fp+115],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdfb4),%l1
	or	%l1,%lo(0xdfb4),%l1
	stb	%l2,[%l0+%l1]

	! block 135
.L1762:

! 1144		 ctx->EvalMap.Map2Texture4.Points = (GLfloat *) points;

	ld	[%fp+108],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	st	%l2,[%l0+%l1]

	! block 136
.L1763:

! 1145		 break;

	ba	.L1570
	nop

	! block 137
.L1764:
.L1765:

! 1146	      default:
! 1147	         gl_error( ctx, GL_INVALID_ENUM, "glMap2(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1766),%l1
	or	%l1,%lo(.L1766),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 138
.L1767:
.L1768:
	ba	.L1570
	nop

	! block 139
.L1571:
.L1769:
	ld	[%fp+72],%l0
	sub	%l0,3504,%l0
	cmp	%l0,8
	bgu	.L1764
	nop

	! block 140
	sll	%l0,2,%l1
	sethi	%hi(.L_y7-36),%l0
	or	%l0,%lo(.L_y7-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 141
.L1770:
.L1570:
.L1771:

	! block 142
.L1772:
.L1773:
.L1465:
	jmp	%i7+8
	restore
	.size	gl_Map2f,(.-gl_Map2f)

	.word	.L1638
	.word	.L1617
	.word	.L1659
	.word	.L1680
	.word	.L1701
	.word	.L1722
	.word	.L1743
	.word	.L1575
	.word	.L1596
.L_y7:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetMapdv
	.type	gl_GetMapdv,#function
gl_GetMapdv:
	save	%sp,-120,%sp

	! block 1
.L1776:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L1777:
.L1779:
.L1782:

! File eval.c:
! 1148	   }
! 1149	}
! 1150	
! 1152	   
! 1153	
! 1155	void gl_GetMapdv( GLcontext* ctx, GLenum target, GLenum query, GLdouble *v )
! 1156	{
! 1157	   GLuint i, n;
! 1158	   GLfloat *data;
! 1159	
! 1160	   switch (query) {

	ba	.L1781
	nop

	! block 3
.L1783:
.L1784:
.L1785:
.L1786:
.L1789:

! 1161	      case GL_COEFF:
! 1162		 switch (target) {

	ba	.L1788
	nop

	! block 4
.L1790:
.L1791:
.L1792:
.L1793:

! 1163		    case GL_MAP1_COLOR_4:
! 1164		       data = ctx->EvalMap.Map1Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 5
.L1794:

! 1165		       n = ctx->EvalMap.Map1Color4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 6
.L1795:

! 1166		       break;

	ba	.L1787
	nop

	! block 7
.L1796:
.L1797:

! 1167		    case GL_MAP1_INDEX:
! 1168		       data = ctx->EvalMap.Map1Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 8
.L1798:

! 1169		       n = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 9
.L1799:

! 1170		       break;

	ba	.L1787
	nop

	! block 10
.L1800:
.L1801:

! 1171		    case GL_MAP1_NORMAL:
! 1172		       data = ctx->EvalMap.Map1Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 11
.L1802:

! 1173		       n = ctx->EvalMap.Map1Normal.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 12
.L1803:

! 1174		       break;

	ba	.L1787
	nop

	! block 13
.L1804:
.L1805:

! 1175		    case GL_MAP1_TEXTURE_COORD_1:
! 1176		       data = ctx->EvalMap.Map1Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 14
.L1806:

! 1177		       n = ctx->EvalMap.Map1Texture1.Order * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 15
.L1807:

! 1178		       break;

	ba	.L1787
	nop

	! block 16
.L1808:
.L1809:

! 1179		    case GL_MAP1_TEXTURE_COORD_2:
! 1180		       data = ctx->EvalMap.Map1Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 17
.L1810:

! 1181		       n = ctx->EvalMap.Map1Texture2.Order * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 18
.L1811:

! 1182		       break;

	ba	.L1787
	nop

	! block 19
.L1812:
.L1813:

! 1183		    case GL_MAP1_TEXTURE_COORD_3:
! 1184		       data = ctx->EvalMap.Map1Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 20
.L1814:

! 1185		       n = ctx->EvalMap.Map1Texture3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 21
.L1815:

! 1186		       break;

	ba	.L1787
	nop

	! block 22
.L1816:
.L1817:

! 1187		    case GL_MAP1_TEXTURE_COORD_4:
! 1188		       data = ctx->EvalMap.Map1Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 23
.L1818:

! 1189		       n = ctx->EvalMap.Map1Texture4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 24
.L1819:

! 1190		       break;

	ba	.L1787
	nop

	! block 25
.L1820:
.L1821:

! 1191		    case GL_MAP1_VERTEX_3:
! 1192		       data = ctx->EvalMap.Map1Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%l0
	st	%l0,[%fp-12]

	! block 26
.L1822:

! 1193		       n = ctx->EvalMap.Map1Vertex3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 27
.L1823:

! 1194		       break;

	ba	.L1787
	nop

	! block 28
.L1824:
.L1825:

! 1195		    case GL_MAP1_VERTEX_4:
! 1196		       data = ctx->EvalMap.Map1Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 29
.L1826:

! 1197		       n = ctx->EvalMap.Map1Vertex4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 30
.L1827:

! 1198		       break;

	ba	.L1787
	nop

	! block 31
.L1828:
.L1829:

! 1199		    case GL_MAP2_COLOR_4:
! 1200		       data = ctx->EvalMap.Map2Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 32
.L1830:

! 1201		       n = ctx->EvalMap.Map2Color4.Uorder
! 1202	                 * ctx->EvalMap.Map2Color4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 33
.L1831:

! 1203		       break;

	ba	.L1787
	nop

	! block 34
.L1832:
.L1833:

! 1204		    case GL_MAP2_INDEX:
! 1205		       data = ctx->EvalMap.Map2Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 35
.L1834:

! 1206		       n = ctx->EvalMap.Map2Index.Uorder
! 1207	                 * ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 36
.L1835:

! 1208		       break;

	ba	.L1787
	nop

	! block 37
.L1836:
.L1837:

! 1209		    case GL_MAP2_NORMAL:
! 1210		       data = ctx->EvalMap.Map2Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 38
.L1838:

! 1211		       n = ctx->EvalMap.Map2Normal.Uorder
! 1212	                 * ctx->EvalMap.Map2Normal.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 39
.L1839:

! 1213		       break;

	ba	.L1787
	nop

	! block 40
.L1840:
.L1841:

! 1214		    case GL_MAP2_TEXTURE_COORD_1:
! 1215		       data = ctx->EvalMap.Map2Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 41
.L1842:

! 1216		       n = ctx->EvalMap.Map2Texture1.Uorder
! 1217	                 * ctx->EvalMap.Map2Texture1.Vorder * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 42
.L1843:

! 1218		       break;

	ba	.L1787
	nop

	! block 43
.L1844:
.L1845:

! 1219		    case GL_MAP2_TEXTURE_COORD_2:
! 1220		       data = ctx->EvalMap.Map2Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 44
.L1846:

! 1221		       n = ctx->EvalMap.Map2Texture2.Uorder
! 1222	                 * ctx->EvalMap.Map2Texture2.Vorder * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 45
.L1847:

! 1223		       break;

	ba	.L1787
	nop

	! block 46
.L1848:
.L1849:

! 1224		    case GL_MAP2_TEXTURE_COORD_3:
! 1225		       data = ctx->EvalMap.Map2Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 47
.L1850:

! 1226		       n = ctx->EvalMap.Map2Texture3.Uorder
! 1227	                 * ctx->EvalMap.Map2Texture3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 48
.L1851:

! 1228		       break;

	ba	.L1787
	nop

	! block 49
.L1852:
.L1853:

! 1229		    case GL_MAP2_TEXTURE_COORD_4:
! 1230		       data = ctx->EvalMap.Map2Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 50
.L1854:

! 1231		       n = ctx->EvalMap.Map2Texture4.Uorder
! 1232	                 * ctx->EvalMap.Map2Texture4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 51
.L1855:

! 1233		       break;

	ba	.L1787
	nop

	! block 52
.L1856:
.L1857:

! 1234		    case GL_MAP2_VERTEX_3:
! 1235		       data = ctx->EvalMap.Map2Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 53
.L1858:

! 1236		       n = ctx->EvalMap.Map2Vertex3.Uorder
! 1237	                 * ctx->EvalMap.Map2Vertex3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 54
.L1859:

! 1238		       break;

	ba	.L1787
	nop

	! block 55
.L1860:
.L1861:

! 1239		    case GL_MAP2_VERTEX_4:
! 1240		       data = ctx->EvalMap.Map2Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 56
.L1862:

! 1241		       n = ctx->EvalMap.Map2Vertex4.Uorder
! 1242	                 * ctx->EvalMap.Map2Vertex4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 57
.L1863:

! 1243		       break;

	ba	.L1787
	nop

	! block 58
.L1864:
.L1865:

! 1244		    default:
! 1245		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapdv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1866),%l1
	or	%l1,%lo(.L1866),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 59
.L1867:
.L1868:
	ba	.L1787
	nop

	! block 60
.L1788:
.L1869:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y8
	nop

	! block 61
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L1864
	nop

	! block 62
	sll	%l0,2,%l1
	sethi	%hi(.L_y9-36),%l0
	or	%l0,%lo(.L_y9-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 63
.L_y8:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L1864
	nop

	! block 64
	sll	%l0,2,%l1
	sethi	%hi(.L_y10-36),%l0
	or	%l0,%lo(.L_y10-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 65
.L1870:
.L1787:
.L1871:
.L1872:
.L1874:

! 1246		 }
! 1247		 if (data) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L1873
	nop

	! block 66
.L1875:
.L1876:
.L1877:
.L1878:
.L1879:

! 1248		    for (i=0;i<n;i++) {

	ld	[%fp-8],%l0
	cmp	%g0,%l0
	bgeu	.L1882
	st	%g0,[%fp-4]

	! block 67
.L1883:
.L1880:
.L1884:
.L1885:
.L1886:

! 1249		       v[i] = data[i];

	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%g1
	st	%f4,[%g1]
	st	%f5,[%g1+4]

	! block 68
.L1887:
.L1888:
.L1889:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	blu	.L1880
	nop

	! block 69
.L1890:
.L1882:
.L1891:
.L1892:
.L1893:
.L1873:
.L1894:
.L1895:

! 1250		    }
! 1251		 }
! 1252	         break;

	ba	.L1780
	nop

	! block 70
.L1896:
.L1897:
.L1900:

! 1253	      case GL_ORDER:
! 1254		 switch (target) {

	ba	.L1899
	nop

	! block 71
.L1901:
.L1902:
.L1903:
.L1904:

! 1255		    case GL_MAP1_COLOR_4:
! 1256		       *v = ctx->EvalMap.Map1Color4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 72
.L1905:

! 1257		       break;

	ba	.L1898
	nop

	! block 73
.L1906:
.L1907:

! 1258		    case GL_MAP1_INDEX:
! 1259		       *v = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 74
.L1908:

! 1260		       break;

	ba	.L1898
	nop

	! block 75
.L1909:
.L1910:

! 1261		    case GL_MAP1_NORMAL:
! 1262		       *v = ctx->EvalMap.Map1Normal.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 76
.L1911:

! 1263		       break;

	ba	.L1898
	nop

	! block 77
.L1912:
.L1913:

! 1264		    case GL_MAP1_TEXTURE_COORD_1:
! 1265		       *v = ctx->EvalMap.Map1Texture1.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 78
.L1914:

! 1266		       break;

	ba	.L1898
	nop

	! block 79
.L1915:
.L1916:

! 1267		    case GL_MAP1_TEXTURE_COORD_2:
! 1268		       *v = ctx->EvalMap.Map1Texture2.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 80
.L1917:

! 1269		       break;

	ba	.L1898
	nop

	! block 81
.L1918:
.L1919:

! 1270		    case GL_MAP1_TEXTURE_COORD_3:
! 1271		       *v = ctx->EvalMap.Map1Texture3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 82
.L1920:

! 1272		       break;

	ba	.L1898
	nop

	! block 83
.L1921:
.L1922:

! 1273		    case GL_MAP1_TEXTURE_COORD_4:
! 1274		       *v = ctx->EvalMap.Map1Texture4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 84
.L1923:

! 1275		       break;

	ba	.L1898
	nop

	! block 85
.L1924:
.L1925:

! 1276		    case GL_MAP1_VERTEX_3:
! 1277		       *v = ctx->EvalMap.Map1Vertex3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 86
.L1926:

! 1278		       break;

	ba	.L1898
	nop

	! block 87
.L1927:
.L1928:

! 1279		    case GL_MAP1_VERTEX_4:
! 1280		       *v = ctx->EvalMap.Map1Vertex4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 88
.L1929:

! 1281		       break;

	ba	.L1898
	nop

	! block 89
.L1930:
.L1931:

! 1282		    case GL_MAP2_COLOR_4:
! 1283		       v[0] = ctx->EvalMap.Map2Color4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 90
.L1932:

! 1284		       v[1] = ctx->EvalMap.Map2Color4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 91
.L1933:

! 1285		       break;

	ba	.L1898
	nop

	! block 92
.L1934:
.L1935:

! 1286		    case GL_MAP2_INDEX:
! 1287		       v[0] = ctx->EvalMap.Map2Index.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 93
.L1936:

! 1288		       v[1] = ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 94
.L1937:

! 1289		       break;

	ba	.L1898
	nop

	! block 95
.L1938:
.L1939:

! 1290		    case GL_MAP2_NORMAL:
! 1291		       v[0] = ctx->EvalMap.Map2Normal.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 96
.L1940:

! 1292		       v[1] = ctx->EvalMap.Map2Normal.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 97
.L1941:

! 1293		       break;

	ba	.L1898
	nop

	! block 98
.L1942:
.L1943:

! 1294		    case GL_MAP2_TEXTURE_COORD_1:
! 1295		       v[0] = ctx->EvalMap.Map2Texture1.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 99
.L1944:

! 1296		       v[1] = ctx->EvalMap.Map2Texture1.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 100
.L1945:

! 1297		       break;

	ba	.L1898
	nop

	! block 101
.L1946:
.L1947:

! 1298		    case GL_MAP2_TEXTURE_COORD_2:
! 1299		       v[0] = ctx->EvalMap.Map2Texture2.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 102
.L1948:

! 1300		       v[1] = ctx->EvalMap.Map2Texture2.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 103
.L1949:

! 1301		       break;

	ba	.L1898
	nop

	! block 104
.L1950:
.L1951:

! 1302		    case GL_MAP2_TEXTURE_COORD_3:
! 1303		       v[0] = ctx->EvalMap.Map2Texture3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 105
.L1952:

! 1304		       v[1] = ctx->EvalMap.Map2Texture3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 106
.L1953:

! 1305		       break;

	ba	.L1898
	nop

	! block 107
.L1954:
.L1955:

! 1306		    case GL_MAP2_TEXTURE_COORD_4:
! 1307		       v[0] = ctx->EvalMap.Map2Texture4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 108
.L1956:

! 1308		       v[1] = ctx->EvalMap.Map2Texture4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 109
.L1957:

! 1309		       break;

	ba	.L1898
	nop

	! block 110
.L1958:
.L1959:

! 1310		    case GL_MAP2_VERTEX_3:
! 1311		       v[0] = ctx->EvalMap.Map2Vertex3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 111
.L1960:

! 1312		       v[1] = ctx->EvalMap.Map2Vertex3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 112
.L1961:

! 1313		       break;

	ba	.L1898
	nop

	! block 113
.L1962:
.L1963:

! 1314		    case GL_MAP2_VERTEX_4:
! 1315		       v[0] = ctx->EvalMap.Map2Vertex4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 114
.L1964:

! 1316		       v[1] = ctx->EvalMap.Map2Vertex4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 115
.L1965:

! 1317		       break;

	ba	.L1898
	nop

	! block 116
.L1966:
.L1967:

! 1318		    default:
! 1319		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapdv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1968),%l1
	or	%l1,%lo(.L1968),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 117
.L1969:
.L1970:
	ba	.L1898
	nop

	! block 118
.L1899:
.L1971:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y11
	nop

	! block 119
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L1966
	nop

	! block 120
	sll	%l0,2,%l1
	sethi	%hi(.L_y12-36),%l0
	or	%l0,%lo(.L_y12-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 121
.L_y11:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L1966
	nop

	! block 122
	sll	%l0,2,%l1
	sethi	%hi(.L_y13-36),%l0
	or	%l0,%lo(.L_y13-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 123
.L1972:
.L1898:
.L1973:
.L1974:

! 1320		 }
! 1321	         break;

	ba	.L1780
	nop

	! block 124
.L1975:
.L1976:
.L1979:

! 1322	      case GL_DOMAIN:
! 1323		 switch (target) {

	ba	.L1978
	nop

	! block 125
.L1980:
.L1981:
.L1982:
.L1983:

! 1324		    case GL_MAP1_COLOR_4:
! 1325		       v[0] = ctx->EvalMap.Map1Color4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 126
.L1984:

! 1326		       v[1] = ctx->EvalMap.Map1Color4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 127
.L1985:

! 1327		       break;

	ba	.L1977
	nop

	! block 128
.L1986:
.L1987:

! 1328		    case GL_MAP1_INDEX:
! 1329		       v[0] = ctx->EvalMap.Map1Index.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 129
.L1988:

! 1330		       v[1] = ctx->EvalMap.Map1Index.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 130
.L1989:

! 1331		       break;

	ba	.L1977
	nop

	! block 131
.L1990:
.L1991:

! 1332		    case GL_MAP1_NORMAL:
! 1333		       v[0] = ctx->EvalMap.Map1Normal.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 132
.L1992:

! 1334		       v[1] = ctx->EvalMap.Map1Normal.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 133
.L1993:

! 1335		       break;

	ba	.L1977
	nop

	! block 134
.L1994:
.L1995:

! 1336		    case GL_MAP1_TEXTURE_COORD_1:
! 1337		       v[0] = ctx->EvalMap.Map1Texture1.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 135
.L1996:

! 1338		       v[1] = ctx->EvalMap.Map1Texture1.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 136
.L1997:

! 1339		       break;

	ba	.L1977
	nop

	! block 137
.L1998:
.L1999:

! 1340		    case GL_MAP1_TEXTURE_COORD_2:
! 1341		       v[0] = ctx->EvalMap.Map1Texture2.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 138
.L2000:

! 1342		       v[1] = ctx->EvalMap.Map1Texture2.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 139
.L2001:

! 1343		       break;

	ba	.L1977
	nop

	! block 140
.L2002:
.L2003:

! 1344		    case GL_MAP1_TEXTURE_COORD_3:
! 1345		       v[0] = ctx->EvalMap.Map1Texture3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 141
.L2004:

! 1346		       v[1] = ctx->EvalMap.Map1Texture3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 142
.L2005:

! 1347		       break;

	ba	.L1977
	nop

	! block 143
.L2006:
.L2007:

! 1348		    case GL_MAP1_TEXTURE_COORD_4:
! 1349		       v[0] = ctx->EvalMap.Map1Texture4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 144
.L2008:

! 1350		       v[1] = ctx->EvalMap.Map1Texture4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 145
.L2009:

! 1351		       break;

	ba	.L1977
	nop

	! block 146
.L2010:
.L2011:

! 1352		    case GL_MAP1_VERTEX_3:
! 1353		       v[0] = ctx->EvalMap.Map1Vertex3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 147
.L2012:

! 1354		       v[1] = ctx->EvalMap.Map1Vertex3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 148
.L2013:

! 1355		       break;

	ba	.L1977
	nop

	! block 149
.L2014:
.L2015:

! 1356		    case GL_MAP1_VERTEX_4:
! 1357		       v[0] = ctx->EvalMap.Map1Vertex4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 150
.L2016:

! 1358		       v[1] = ctx->EvalMap.Map1Vertex4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 151
.L2017:

! 1359		       break;

	ba	.L1977
	nop

	! block 152
.L2018:
.L2019:

! 1360		    case GL_MAP2_COLOR_4:
! 1361		       v[0] = ctx->EvalMap.Map2Color4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 153
.L2020:

! 1362		       v[1] = ctx->EvalMap.Map2Color4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 154
.L2021:

! 1363		       v[2] = ctx->EvalMap.Map2Color4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 155
.L2022:

! 1364		       v[3] = ctx->EvalMap.Map2Color4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 156
.L2023:

! 1365		       break;

	ba	.L1977
	nop

	! block 157
.L2024:
.L2025:

! 1366		    case GL_MAP2_INDEX:
! 1367		       v[0] = ctx->EvalMap.Map2Index.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 158
.L2026:

! 1368		       v[1] = ctx->EvalMap.Map2Index.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 159
.L2027:

! 1369		       v[2] = ctx->EvalMap.Map2Index.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 160
.L2028:

! 1370		       v[3] = ctx->EvalMap.Map2Index.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 161
.L2029:

! 1371		       break;

	ba	.L1977
	nop

	! block 162
.L2030:
.L2031:

! 1372		    case GL_MAP2_NORMAL:
! 1373		       v[0] = ctx->EvalMap.Map2Normal.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 163
.L2032:

! 1374		       v[1] = ctx->EvalMap.Map2Normal.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 164
.L2033:

! 1375		       v[2] = ctx->EvalMap.Map2Normal.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 165
.L2034:

! 1376		       v[3] = ctx->EvalMap.Map2Normal.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 166
.L2035:

! 1377		       break;

	ba	.L1977
	nop

	! block 167
.L2036:
.L2037:

! 1378		    case GL_MAP2_TEXTURE_COORD_1:
! 1379		       v[0] = ctx->EvalMap.Map2Texture1.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 168
.L2038:

! 1380		       v[1] = ctx->EvalMap.Map2Texture1.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 169
.L2039:

! 1381		       v[2] = ctx->EvalMap.Map2Texture1.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 170
.L2040:

! 1382		       v[3] = ctx->EvalMap.Map2Texture1.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 171
.L2041:

! 1383		       break;

	ba	.L1977
	nop

	! block 172
.L2042:
.L2043:

! 1384		    case GL_MAP2_TEXTURE_COORD_2:
! 1385		       v[0] = ctx->EvalMap.Map2Texture2.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 173
.L2044:

! 1386		       v[1] = ctx->EvalMap.Map2Texture2.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 174
.L2045:

! 1387		       v[2] = ctx->EvalMap.Map2Texture2.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 175
.L2046:

! 1388		       v[3] = ctx->EvalMap.Map2Texture2.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 176
.L2047:

! 1389		       break;

	ba	.L1977
	nop

	! block 177
.L2048:
.L2049:

! 1390		    case GL_MAP2_TEXTURE_COORD_3:
! 1391		       v[0] = ctx->EvalMap.Map2Texture3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 178
.L2050:

! 1392		       v[1] = ctx->EvalMap.Map2Texture3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 179
.L2051:

! 1393		       v[2] = ctx->EvalMap.Map2Texture3.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 180
.L2052:

! 1394		       v[3] = ctx->EvalMap.Map2Texture3.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 181
.L2053:

! 1395		       break;

	ba	.L1977
	nop

	! block 182
.L2054:
.L2055:

! 1396		    case GL_MAP2_TEXTURE_COORD_4:
! 1397		       v[0] = ctx->EvalMap.Map2Texture4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 183
.L2056:

! 1398		       v[1] = ctx->EvalMap.Map2Texture4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 184
.L2057:

! 1399		       v[2] = ctx->EvalMap.Map2Texture4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 185
.L2058:

! 1400		       v[3] = ctx->EvalMap.Map2Texture4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 186
.L2059:

! 1401		       break;

	ba	.L1977
	nop

	! block 187
.L2060:
.L2061:

! 1402		    case GL_MAP2_VERTEX_3:
! 1403		       v[0] = ctx->EvalMap.Map2Vertex3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 188
.L2062:

! 1404		       v[1] = ctx->EvalMap.Map2Vertex3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 189
.L2063:

! 1405		       v[2] = ctx->EvalMap.Map2Vertex3.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 190
.L2064:

! 1406		       v[3] = ctx->EvalMap.Map2Vertex3.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 191
.L2065:

! 1407		       break;

	ba	.L1977
	nop

	! block 192
.L2066:
.L2067:

! 1408		    case GL_MAP2_VERTEX_4:
! 1409		       v[0] = ctx->EvalMap.Map2Vertex4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 193
.L2068:

! 1410		       v[1] = ctx->EvalMap.Map2Vertex4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 194
.L2069:

! 1411		       v[2] = ctx->EvalMap.Map2Vertex4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 195
.L2070:

! 1412		       v[3] = ctx->EvalMap.Map2Vertex4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 196
.L2071:

! 1413		       break;

	ba	.L1977
	nop

	! block 197
.L2072:
.L2073:

! 1414		    default:
! 1415		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapdv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2074),%l1
	or	%l1,%lo(.L2074),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 198
.L2075:
.L2076:
	ba	.L1977
	nop

	! block 199
.L1978:
.L2077:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y14
	nop

	! block 200
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2072
	nop

	! block 201
	sll	%l0,2,%l1
	sethi	%hi(.L_y15-36),%l0
	or	%l0,%lo(.L_y15-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 202
.L_y14:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2072
	nop

	! block 203
	sll	%l0,2,%l1
	sethi	%hi(.L_y16-36),%l0
	or	%l0,%lo(.L_y16-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 204
.L2078:
.L1977:
.L2079:
.L2080:

! 1416		 }
! 1417	         break;

	ba	.L1780
	nop

	! block 205
.L2081:
.L2082:

! 1418	      default:
! 1419	         gl_error( ctx, GL_INVALID_ENUM, "glGetMapdv(query)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2083),%l1
	or	%l1,%lo(.L2083),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 206
.L2084:
.L2085:
	ba	.L1780
	nop

	! block 207
.L1781:
.L2086:
	ld	[%fp+76],%l0
	sub	%l0,2560,%l0
	cmp	%l0,2
	bgu	.L2081
	nop

	! block 208
	sll	%l0,2,%l1
	sethi	%hi(.L_y17-12),%l0
	or	%l0,%lo(.L_y17-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 209
.L2087:
.L1780:
.L2088:

	! block 210
.L2089:
.L2090:
.L1775:
	jmp	%i7+8
	restore
	.size	gl_GetMapdv,(.-gl_GetMapdv)

	.word	.L1792
	.word	.L1796
	.word	.L1800
	.word	.L1804
	.word	.L1808
	.word	.L1812
	.word	.L1816
	.word	.L1820
	.word	.L1824
.L_y9:
	.word	.L1828
	.word	.L1832
	.word	.L1836
	.word	.L1840
	.word	.L1844
	.word	.L1848
	.word	.L1852
	.word	.L1856
	.word	.L1860
.L_y10:
	.word	.L1903
	.word	.L1906
	.word	.L1909
	.word	.L1912
	.word	.L1915
	.word	.L1918
	.word	.L1921
	.word	.L1924
	.word	.L1927
.L_y12:
	.word	.L1930
	.word	.L1934
	.word	.L1938
	.word	.L1942
	.word	.L1946
	.word	.L1950
	.word	.L1954
	.word	.L1958
	.word	.L1962
.L_y13:
	.word	.L1982
	.word	.L1986
	.word	.L1990
	.word	.L1994
	.word	.L1998
	.word	.L2002
	.word	.L2006
	.word	.L2010
	.word	.L2014
.L_y15:
	.word	.L2018
	.word	.L2024
	.word	.L2030
	.word	.L2036
	.word	.L2042
	.word	.L2048
	.word	.L2054
	.word	.L2060
	.word	.L2066
.L_y16:
	.word	.L1785
	.word	.L1896
	.word	.L1975
.L_y17:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetMapfv
	.type	gl_GetMapfv,#function
gl_GetMapfv:
	save	%sp,-120,%sp

	! block 1
.L2093:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L2094:
.L2096:
.L2099:

! File eval.c:
! 1420	   }
! 1421	}
! 1422	
! 1424	void gl_GetMapfv( GLcontext* ctx, GLenum target, GLenum query, GLfloat *v )
! 1425	{
! 1426	   GLuint i, n;
! 1427	   GLfloat *data;
! 1428	
! 1429	   switch (query) {

	ba	.L2098
	nop

	! block 3
.L2100:
.L2101:
.L2102:
.L2103:
.L2106:

! 1430	      case GL_COEFF:
! 1431		 switch (target) {

	ba	.L2105
	nop

	! block 4
.L2107:
.L2108:
.L2109:
.L2110:

! 1432		    case GL_MAP1_COLOR_4:
! 1433		       data = ctx->EvalMap.Map1Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 5
.L2111:

! 1434		       n = ctx->EvalMap.Map1Color4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 6
.L2112:

! 1435		       break;

	ba	.L2104
	nop

	! block 7
.L2113:
.L2114:

! 1436		    case GL_MAP1_INDEX:
! 1437		       data = ctx->EvalMap.Map1Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 8
.L2115:

! 1438		       n = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 9
.L2116:

! 1439		       break;

	ba	.L2104
	nop

	! block 10
.L2117:
.L2118:

! 1440		    case GL_MAP1_NORMAL:
! 1441		       data = ctx->EvalMap.Map1Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 11
.L2119:

! 1442		       n = ctx->EvalMap.Map1Normal.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 12
.L2120:

! 1443		       break;

	ba	.L2104
	nop

	! block 13
.L2121:
.L2122:

! 1444		    case GL_MAP1_TEXTURE_COORD_1:
! 1445		       data = ctx->EvalMap.Map1Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 14
.L2123:

! 1446		       n = ctx->EvalMap.Map1Texture1.Order * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 15
.L2124:

! 1447		       break;

	ba	.L2104
	nop

	! block 16
.L2125:
.L2126:

! 1448		    case GL_MAP1_TEXTURE_COORD_2:
! 1449		       data = ctx->EvalMap.Map1Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 17
.L2127:

! 1450		       n = ctx->EvalMap.Map1Texture2.Order * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 18
.L2128:

! 1451		       break;

	ba	.L2104
	nop

	! block 19
.L2129:
.L2130:

! 1452		    case GL_MAP1_TEXTURE_COORD_3:
! 1453		       data = ctx->EvalMap.Map1Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 20
.L2131:

! 1454		       n = ctx->EvalMap.Map1Texture3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 21
.L2132:

! 1455		       break;

	ba	.L2104
	nop

	! block 22
.L2133:
.L2134:

! 1456		    case GL_MAP1_TEXTURE_COORD_4:
! 1457		       data = ctx->EvalMap.Map1Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 23
.L2135:

! 1458		       n = ctx->EvalMap.Map1Texture4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 24
.L2136:

! 1459		       break;

	ba	.L2104
	nop

	! block 25
.L2137:
.L2138:

! 1460		    case GL_MAP1_VERTEX_3:
! 1461		       data = ctx->EvalMap.Map1Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%l0
	st	%l0,[%fp-12]

	! block 26
.L2139:

! 1462		       n = ctx->EvalMap.Map1Vertex3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 27
.L2140:

! 1463		       break;

	ba	.L2104
	nop

	! block 28
.L2141:
.L2142:

! 1464		    case GL_MAP1_VERTEX_4:
! 1465		       data = ctx->EvalMap.Map1Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 29
.L2143:

! 1466		       n = ctx->EvalMap.Map1Vertex4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 30
.L2144:

! 1467		       break;

	ba	.L2104
	nop

	! block 31
.L2145:
.L2146:

! 1468		    case GL_MAP2_COLOR_4:
! 1469		       data = ctx->EvalMap.Map2Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 32
.L2147:

! 1470		       n = ctx->EvalMap.Map2Color4.Uorder
! 1471	                 * ctx->EvalMap.Map2Color4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 33
.L2148:

! 1472		       break;

	ba	.L2104
	nop

	! block 34
.L2149:
.L2150:

! 1473		    case GL_MAP2_INDEX:
! 1474		       data = ctx->EvalMap.Map2Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 35
.L2151:

! 1475		       n = ctx->EvalMap.Map2Index.Uorder
! 1476	                 * ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 36
.L2152:

! 1477		       break;

	ba	.L2104
	nop

	! block 37
.L2153:
.L2154:

! 1478		    case GL_MAP2_NORMAL:
! 1479		       data = ctx->EvalMap.Map2Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 38
.L2155:

! 1480		       n = ctx->EvalMap.Map2Normal.Uorder
! 1481	                 * ctx->EvalMap.Map2Normal.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 39
.L2156:

! 1482		       break;

	ba	.L2104
	nop

	! block 40
.L2157:
.L2158:

! 1483		    case GL_MAP2_TEXTURE_COORD_1:
! 1484		       data = ctx->EvalMap.Map2Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 41
.L2159:

! 1485		       n = ctx->EvalMap.Map2Texture1.Uorder
! 1486	                 * ctx->EvalMap.Map2Texture1.Vorder * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 42
.L2160:

! 1487		       break;

	ba	.L2104
	nop

	! block 43
.L2161:
.L2162:

! 1488		    case GL_MAP2_TEXTURE_COORD_2:
! 1489		       data = ctx->EvalMap.Map2Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 44
.L2163:

! 1490		       n = ctx->EvalMap.Map2Texture2.Uorder
! 1491	                 * ctx->EvalMap.Map2Texture2.Vorder * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 45
.L2164:

! 1492		       break;

	ba	.L2104
	nop

	! block 46
.L2165:
.L2166:

! 1493		    case GL_MAP2_TEXTURE_COORD_3:
! 1494		       data = ctx->EvalMap.Map2Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 47
.L2167:

! 1495		       n = ctx->EvalMap.Map2Texture3.Uorder
! 1496	                 * ctx->EvalMap.Map2Texture3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 48
.L2168:

! 1497		       break;

	ba	.L2104
	nop

	! block 49
.L2169:
.L2170:

! 1498		    case GL_MAP2_TEXTURE_COORD_4:
! 1499		       data = ctx->EvalMap.Map2Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 50
.L2171:

! 1500		       n = ctx->EvalMap.Map2Texture4.Uorder
! 1501	                 * ctx->EvalMap.Map2Texture4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 51
.L2172:

! 1502		       break;

	ba	.L2104
	nop

	! block 52
.L2173:
.L2174:

! 1503		    case GL_MAP2_VERTEX_3:
! 1504		       data = ctx->EvalMap.Map2Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 53
.L2175:

! 1505		       n = ctx->EvalMap.Map2Vertex3.Uorder
! 1506	                 * ctx->EvalMap.Map2Vertex3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 54
.L2176:

! 1507		       break;

	ba	.L2104
	nop

	! block 55
.L2177:
.L2178:

! 1508		    case GL_MAP2_VERTEX_4:
! 1509		       data = ctx->EvalMap.Map2Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 56
.L2179:

! 1510		       n = ctx->EvalMap.Map2Vertex4.Uorder
! 1511	                 * ctx->EvalMap.Map2Vertex4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 57
.L2180:

! 1512		       break;

	ba	.L2104
	nop

	! block 58
.L2181:
.L2182:

! 1513		    default:
! 1514		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapfv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2183),%l1
	or	%l1,%lo(.L2183),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 59
.L2184:
.L2185:
	ba	.L2104
	nop

	! block 60
.L2105:
.L2186:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y18
	nop

	! block 61
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2181
	nop

	! block 62
	sll	%l0,2,%l1
	sethi	%hi(.L_y19-36),%l0
	or	%l0,%lo(.L_y19-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 63
.L_y18:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2181
	nop

	! block 64
	sll	%l0,2,%l1
	sethi	%hi(.L_y20-36),%l0
	or	%l0,%lo(.L_y20-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 65
.L2187:
.L2104:
.L2188:
.L2189:
.L2191:

! 1515		 }
! 1516		 if (data) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L2190
	nop

	! block 66
.L2192:
.L2193:
.L2194:
.L2195:
.L2196:

! 1517		    for (i=0;i<n;i++) {

	ld	[%fp-8],%l0
	cmp	%g0,%l0
	bgeu	.L2199
	st	%g0,[%fp-4]

	! block 67
.L2200:
.L2197:
.L2201:
.L2202:
.L2203:

! 1518		       v[i] = data[i];

	ld	[%fp-12],%l1
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	ld	[%l1+%l2],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+%l2]

	! block 68
.L2204:
.L2205:
.L2206:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	blu	.L2197
	nop

	! block 69
.L2207:
.L2199:
.L2208:
.L2209:
.L2210:
.L2190:
.L2211:
.L2212:

! 1519		    }
! 1520		 }
! 1521	         break;

	ba	.L2097
	nop

	! block 70
.L2213:
.L2214:
.L2217:

! 1522	      case GL_ORDER:
! 1523		 switch (target) {

	ba	.L2216
	nop

	! block 71
.L2218:
.L2219:
.L2220:
.L2221:

! 1524		    case GL_MAP1_COLOR_4:
! 1525		       *v = ctx->EvalMap.Map1Color4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 72
.L2222:

! 1526		       break;

	ba	.L2215
	nop

	! block 73
.L2223:
.L2224:

! 1527		    case GL_MAP1_INDEX:
! 1528		       *v = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 74
.L2225:

! 1529		       break;

	ba	.L2215
	nop

	! block 75
.L2226:
.L2227:

! 1530		    case GL_MAP1_NORMAL:
! 1531		       *v = ctx->EvalMap.Map1Normal.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 76
.L2228:

! 1532		       break;

	ba	.L2215
	nop

	! block 77
.L2229:
.L2230:

! 1533		    case GL_MAP1_TEXTURE_COORD_1:
! 1534		       *v = ctx->EvalMap.Map1Texture1.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 78
.L2231:

! 1535		       break;

	ba	.L2215
	nop

	! block 79
.L2232:
.L2233:

! 1536		    case GL_MAP1_TEXTURE_COORD_2:
! 1537		       *v = ctx->EvalMap.Map1Texture2.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 80
.L2234:

! 1538		       break;

	ba	.L2215
	nop

	! block 81
.L2235:
.L2236:

! 1539		    case GL_MAP1_TEXTURE_COORD_3:
! 1540		       *v = ctx->EvalMap.Map1Texture3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 82
.L2237:

! 1541		       break;

	ba	.L2215
	nop

	! block 83
.L2238:
.L2239:

! 1542		    case GL_MAP1_TEXTURE_COORD_4:
! 1543		       *v = ctx->EvalMap.Map1Texture4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 84
.L2240:

! 1544		       break;

	ba	.L2215
	nop

	! block 85
.L2241:
.L2242:

! 1545		    case GL_MAP1_VERTEX_3:
! 1546		       *v = ctx->EvalMap.Map1Vertex3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 86
.L2243:

! 1547		       break;

	ba	.L2215
	nop

	! block 87
.L2244:
.L2245:

! 1548		    case GL_MAP1_VERTEX_4:
! 1549		       *v = ctx->EvalMap.Map1Vertex4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 88
.L2246:

! 1550		       break;

	ba	.L2215
	nop

	! block 89
.L2247:
.L2248:

! 1551		    case GL_MAP2_COLOR_4:
! 1552		       v[0] = ctx->EvalMap.Map2Color4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 90
.L2249:

! 1553		       v[1] = ctx->EvalMap.Map2Color4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 91
.L2250:

! 1554		       break;

	ba	.L2215
	nop

	! block 92
.L2251:
.L2252:

! 1555		    case GL_MAP2_INDEX:
! 1556		       v[0] = ctx->EvalMap.Map2Index.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 93
.L2253:

! 1557		       v[1] = ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 94
.L2254:

! 1558		       break;

	ba	.L2215
	nop

	! block 95
.L2255:
.L2256:

! 1559		    case GL_MAP2_NORMAL:
! 1560		       v[0] = ctx->EvalMap.Map2Normal.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 96
.L2257:

! 1561		       v[1] = ctx->EvalMap.Map2Normal.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 97
.L2258:

! 1562		       break;

	ba	.L2215
	nop

	! block 98
.L2259:
.L2260:

! 1563		    case GL_MAP2_TEXTURE_COORD_1:
! 1564		       v[0] = ctx->EvalMap.Map2Texture1.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 99
.L2261:

! 1565		       v[1] = ctx->EvalMap.Map2Texture1.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 100
.L2262:

! 1566		       break;

	ba	.L2215
	nop

	! block 101
.L2263:
.L2264:

! 1567		    case GL_MAP2_TEXTURE_COORD_2:
! 1568		       v[0] = ctx->EvalMap.Map2Texture2.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 102
.L2265:

! 1569		       v[1] = ctx->EvalMap.Map2Texture2.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 103
.L2266:

! 1570		       break;

	ba	.L2215
	nop

	! block 104
.L2267:
.L2268:

! 1571		    case GL_MAP2_TEXTURE_COORD_3:
! 1572		       v[0] = ctx->EvalMap.Map2Texture3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 105
.L2269:

! 1573		       v[1] = ctx->EvalMap.Map2Texture3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 106
.L2270:

! 1574		       break;

	ba	.L2215
	nop

	! block 107
.L2271:
.L2272:

! 1575		    case GL_MAP2_TEXTURE_COORD_4:
! 1576		       v[0] = ctx->EvalMap.Map2Texture4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 108
.L2273:

! 1577		       v[1] = ctx->EvalMap.Map2Texture4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 109
.L2274:

! 1578		       break;

	ba	.L2215
	nop

	! block 110
.L2275:
.L2276:

! 1579		    case GL_MAP2_VERTEX_3:
! 1580		       v[0] = ctx->EvalMap.Map2Vertex3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 111
.L2277:

! 1581		       v[1] = ctx->EvalMap.Map2Vertex3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 112
.L2278:

! 1582		       break;

	ba	.L2215
	nop

	! block 113
.L2279:
.L2280:

! 1583		    case GL_MAP2_VERTEX_4:
! 1584		       v[0] = ctx->EvalMap.Map2Vertex4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 114
.L2281:

! 1585		       v[1] = ctx->EvalMap.Map2Vertex4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 115
.L2282:

! 1586		       break;

	ba	.L2215
	nop

	! block 116
.L2283:
.L2284:

! 1587		    default:
! 1588		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapfv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2285),%l1
	or	%l1,%lo(.L2285),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 117
.L2286:
.L2287:
	ba	.L2215
	nop

	! block 118
.L2216:
.L2288:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y21
	nop

	! block 119
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2283
	nop

	! block 120
	sll	%l0,2,%l1
	sethi	%hi(.L_y22-36),%l0
	or	%l0,%lo(.L_y22-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 121
.L_y21:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2283
	nop

	! block 122
	sll	%l0,2,%l1
	sethi	%hi(.L_y23-36),%l0
	or	%l0,%lo(.L_y23-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 123
.L2289:
.L2215:
.L2290:
.L2291:

! 1589		 }
! 1590	         break;

	ba	.L2097
	nop

	! block 124
.L2292:
.L2293:
.L2296:

! 1591	      case GL_DOMAIN:
! 1592		 switch (target) {

	ba	.L2295
	nop

	! block 125
.L2297:
.L2298:
.L2299:
.L2300:

! 1593		    case GL_MAP1_COLOR_4:
! 1594		       v[0] = ctx->EvalMap.Map1Color4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 126
.L2301:

! 1595		       v[1] = ctx->EvalMap.Map1Color4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 127
.L2302:

! 1596		       break;

	ba	.L2294
	nop

	! block 128
.L2303:
.L2304:

! 1597		    case GL_MAP1_INDEX:
! 1598		       v[0] = ctx->EvalMap.Map1Index.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 129
.L2305:

! 1599		       v[1] = ctx->EvalMap.Map1Index.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 130
.L2306:

! 1600		       break;

	ba	.L2294
	nop

	! block 131
.L2307:
.L2308:

! 1601		    case GL_MAP1_NORMAL:
! 1602		       v[0] = ctx->EvalMap.Map1Normal.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 132
.L2309:

! 1603		       v[1] = ctx->EvalMap.Map1Normal.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 133
.L2310:

! 1604		       break;

	ba	.L2294
	nop

	! block 134
.L2311:
.L2312:

! 1605		    case GL_MAP1_TEXTURE_COORD_1:
! 1606		       v[0] = ctx->EvalMap.Map1Texture1.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 135
.L2313:

! 1607		       v[1] = ctx->EvalMap.Map1Texture1.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 136
.L2314:

! 1608		       break;

	ba	.L2294
	nop

	! block 137
.L2315:
.L2316:

! 1609		    case GL_MAP1_TEXTURE_COORD_2:
! 1610		       v[0] = ctx->EvalMap.Map1Texture2.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 138
.L2317:

! 1611		       v[1] = ctx->EvalMap.Map1Texture2.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 139
.L2318:

! 1612		       break;

	ba	.L2294
	nop

	! block 140
.L2319:
.L2320:

! 1613		    case GL_MAP1_TEXTURE_COORD_3:
! 1614		       v[0] = ctx->EvalMap.Map1Texture3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 141
.L2321:

! 1615		       v[1] = ctx->EvalMap.Map1Texture3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 142
.L2322:

! 1616		       break;

	ba	.L2294
	nop

	! block 143
.L2323:
.L2324:

! 1617		    case GL_MAP1_TEXTURE_COORD_4:
! 1618		       v[0] = ctx->EvalMap.Map1Texture4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 144
.L2325:

! 1619		       v[1] = ctx->EvalMap.Map1Texture4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 145
.L2326:

! 1620		       break;

	ba	.L2294
	nop

	! block 146
.L2327:
.L2328:

! 1621		    case GL_MAP1_VERTEX_3:
! 1622		       v[0] = ctx->EvalMap.Map1Vertex3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 147
.L2329:

! 1623		       v[1] = ctx->EvalMap.Map1Vertex3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 148
.L2330:

! 1624		       break;

	ba	.L2294
	nop

	! block 149
.L2331:
.L2332:

! 1625		    case GL_MAP1_VERTEX_4:
! 1626		       v[0] = ctx->EvalMap.Map1Vertex4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 150
.L2333:

! 1627		       v[1] = ctx->EvalMap.Map1Vertex4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 151
.L2334:

! 1628		       break;

	ba	.L2294
	nop

	! block 152
.L2335:
.L2336:

! 1629		    case GL_MAP2_COLOR_4:
! 1630		       v[0] = ctx->EvalMap.Map2Color4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 153
.L2337:

! 1631		       v[1] = ctx->EvalMap.Map2Color4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 154
.L2338:

! 1632		       v[2] = ctx->EvalMap.Map2Color4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 155
.L2339:

! 1633		       v[3] = ctx->EvalMap.Map2Color4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 156
.L2340:

! 1634		       break;

	ba	.L2294
	nop

	! block 157
.L2341:
.L2342:

! 1635		    case GL_MAP2_INDEX:
! 1636		       v[0] = ctx->EvalMap.Map2Index.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 158
.L2343:

! 1637		       v[1] = ctx->EvalMap.Map2Index.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 159
.L2344:

! 1638		       v[2] = ctx->EvalMap.Map2Index.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 160
.L2345:

! 1639		       v[3] = ctx->EvalMap.Map2Index.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 161
.L2346:

! 1640		       break;

	ba	.L2294
	nop

	! block 162
.L2347:
.L2348:

! 1641		    case GL_MAP2_NORMAL:
! 1642		       v[0] = ctx->EvalMap.Map2Normal.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 163
.L2349:

! 1643		       v[1] = ctx->EvalMap.Map2Normal.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 164
.L2350:

! 1644		       v[2] = ctx->EvalMap.Map2Normal.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 165
.L2351:

! 1645		       v[3] = ctx->EvalMap.Map2Normal.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 166
.L2352:

! 1646		       break;

	ba	.L2294
	nop

	! block 167
.L2353:
.L2354:

! 1647		    case GL_MAP2_TEXTURE_COORD_1:
! 1648		       v[0] = ctx->EvalMap.Map2Texture1.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 168
.L2355:

! 1649		       v[1] = ctx->EvalMap.Map2Texture1.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 169
.L2356:

! 1650		       v[2] = ctx->EvalMap.Map2Texture1.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 170
.L2357:

! 1651		       v[3] = ctx->EvalMap.Map2Texture1.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 171
.L2358:

! 1652		       break;

	ba	.L2294
	nop

	! block 172
.L2359:
.L2360:

! 1653		    case GL_MAP2_TEXTURE_COORD_2:
! 1654		       v[0] = ctx->EvalMap.Map2Texture2.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 173
.L2361:

! 1655		       v[1] = ctx->EvalMap.Map2Texture2.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 174
.L2362:

! 1656		       v[2] = ctx->EvalMap.Map2Texture2.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 175
.L2363:

! 1657		       v[3] = ctx->EvalMap.Map2Texture2.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 176
.L2364:

! 1658		       break;

	ba	.L2294
	nop

	! block 177
.L2365:
.L2366:

! 1659		    case GL_MAP2_TEXTURE_COORD_3:
! 1660		       v[0] = ctx->EvalMap.Map2Texture3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 178
.L2367:

! 1661		       v[1] = ctx->EvalMap.Map2Texture3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 179
.L2368:

! 1662		       v[2] = ctx->EvalMap.Map2Texture3.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 180
.L2369:

! 1663		       v[3] = ctx->EvalMap.Map2Texture3.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 181
.L2370:

! 1664		       break;

	ba	.L2294
	nop

	! block 182
.L2371:
.L2372:

! 1665		    case GL_MAP2_TEXTURE_COORD_4:
! 1666		       v[0] = ctx->EvalMap.Map2Texture4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 183
.L2373:

! 1667		       v[1] = ctx->EvalMap.Map2Texture4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 184
.L2374:

! 1668		       v[2] = ctx->EvalMap.Map2Texture4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 185
.L2375:

! 1669		       v[3] = ctx->EvalMap.Map2Texture4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 186
.L2376:

! 1670		       break;

	ba	.L2294
	nop

	! block 187
.L2377:
.L2378:

! 1671		    case GL_MAP2_VERTEX_3:
! 1672		       v[0] = ctx->EvalMap.Map2Vertex3.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 188
.L2379:

! 1673		       v[1] = ctx->EvalMap.Map2Vertex3.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 189
.L2380:

! 1674		       v[2] = ctx->EvalMap.Map2Vertex3.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 190
.L2381:

! 1675		       v[3] = ctx->EvalMap.Map2Vertex3.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 191
.L2382:

! 1676		       break;

	ba	.L2294
	nop

	! block 192
.L2383:
.L2384:

! 1677		    case GL_MAP2_VERTEX_4:
! 1678		       v[0] = ctx->EvalMap.Map2Vertex4.u1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+0]

	! block 193
.L2385:

! 1679		       v[1] = ctx->EvalMap.Map2Vertex4.u2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+4]

	! block 194
.L2386:

! 1680		       v[2] = ctx->EvalMap.Map2Vertex4.v1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+8]

	! block 195
.L2387:

! 1681		       v[3] = ctx->EvalMap.Map2Vertex4.v2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+80],%l0
	st	%f4,[%l0+12]

	! block 196
.L2388:

! 1682		       break;

	ba	.L2294
	nop

	! block 197
.L2389:
.L2390:

! 1683		    default:
! 1684		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapfv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2391),%l1
	or	%l1,%lo(.L2391),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 198
.L2392:
.L2393:
	ba	.L2294
	nop

	! block 199
.L2295:
.L2394:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y24
	nop

	! block 200
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2389
	nop

	! block 201
	sll	%l0,2,%l1
	sethi	%hi(.L_y25-36),%l0
	or	%l0,%lo(.L_y25-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 202
.L_y24:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2389
	nop

	! block 203
	sll	%l0,2,%l1
	sethi	%hi(.L_y26-36),%l0
	or	%l0,%lo(.L_y26-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 204
.L2395:
.L2294:
.L2396:
.L2397:

! 1685		 }
! 1686	         break;

	ba	.L2097
	nop

	! block 205
.L2398:
.L2399:

! 1687	      default:
! 1688	         gl_error( ctx, GL_INVALID_ENUM, "glGetMapfv(query)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2400),%l1
	or	%l1,%lo(.L2400),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 206
.L2401:
.L2402:
	ba	.L2097
	nop

	! block 207
.L2098:
.L2403:
	ld	[%fp+76],%l0
	sub	%l0,2560,%l0
	cmp	%l0,2
	bgu	.L2398
	nop

	! block 208
	sll	%l0,2,%l1
	sethi	%hi(.L_y27-12),%l0
	or	%l0,%lo(.L_y27-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 209
.L2404:
.L2097:
.L2405:

	! block 210
.L2406:
.L2407:
.L2092:
	jmp	%i7+8
	restore
	.size	gl_GetMapfv,(.-gl_GetMapfv)

	.word	.L2109
	.word	.L2113
	.word	.L2117
	.word	.L2121
	.word	.L2125
	.word	.L2129
	.word	.L2133
	.word	.L2137
	.word	.L2141
.L_y19:
	.word	.L2145
	.word	.L2149
	.word	.L2153
	.word	.L2157
	.word	.L2161
	.word	.L2165
	.word	.L2169
	.word	.L2173
	.word	.L2177
.L_y20:
	.word	.L2220
	.word	.L2223
	.word	.L2226
	.word	.L2229
	.word	.L2232
	.word	.L2235
	.word	.L2238
	.word	.L2241
	.word	.L2244
.L_y22:
	.word	.L2247
	.word	.L2251
	.word	.L2255
	.word	.L2259
	.word	.L2263
	.word	.L2267
	.word	.L2271
	.word	.L2275
	.word	.L2279
.L_y23:
	.word	.L2299
	.word	.L2303
	.word	.L2307
	.word	.L2311
	.word	.L2315
	.word	.L2319
	.word	.L2323
	.word	.L2327
	.word	.L2331
.L_y25:
	.word	.L2335
	.word	.L2341
	.word	.L2347
	.word	.L2353
	.word	.L2359
	.word	.L2365
	.word	.L2371
	.word	.L2377
	.word	.L2383
.L_y26:
	.word	.L2102
	.word	.L2213
	.word	.L2292
.L_y27:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetMapiv
	.type	gl_GetMapiv,#function
gl_GetMapiv:
	save	%sp,-328,%sp

	! block 1
.L2410:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L2411:
.L2413:
.L2416:

! File eval.c:
! 1689	   }
! 1690	}
! 1691	
! 1693	void gl_GetMapiv( GLcontext* ctx, GLenum target, GLenum query, GLint *v )
! 1694	{
! 1695	   GLuint i, n;
! 1696	   GLfloat *data;
! 1697	
! 1698	   switch (query) {

	ba	.L2415
	nop

	! block 3
.L2417:
.L2418:
.L2419:
.L2420:
.L2423:

! 1699	      case GL_COEFF:
! 1700		 switch (target) {

	ba	.L2422
	nop

	! block 4
.L2424:
.L2425:
.L2426:
.L2427:

! 1701		    case GL_MAP1_COLOR_4:
! 1702		       data = ctx->EvalMap.Map1Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde2c),%l1
	or	%l1,%lo(0xde2c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 5
.L2428:

! 1703		       n = ctx->EvalMap.Map1Color4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 6
.L2429:

! 1704		       break;

	ba	.L2421
	nop

	! block 7
.L2430:
.L2431:

! 1705		    case GL_MAP1_INDEX:
! 1706		       data = ctx->EvalMap.Map1Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde18),%l1
	or	%l1,%lo(0xde18),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 8
.L2432:

! 1707		       n = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 9
.L2433:

! 1708		       break;

	ba	.L2421
	nop

	! block 10
.L2434:
.L2435:

! 1709		    case GL_MAP1_NORMAL:
! 1710		       data = ctx->EvalMap.Map1Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde40),%l1
	or	%l1,%lo(0xde40),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 11
.L2436:

! 1711		       n = ctx->EvalMap.Map1Normal.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 12
.L2437:

! 1712		       break;

	ba	.L2421
	nop

	! block 13
.L2438:
.L2439:

! 1713		    case GL_MAP1_TEXTURE_COORD_1:
! 1714		       data = ctx->EvalMap.Map1Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde54),%l1
	or	%l1,%lo(0xde54),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 14
.L2440:

! 1715		       n = ctx->EvalMap.Map1Texture1.Order * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 15
.L2441:

! 1716		       break;

	ba	.L2421
	nop

	! block 16
.L2442:
.L2443:

! 1717		    case GL_MAP1_TEXTURE_COORD_2:
! 1718		       data = ctx->EvalMap.Map1Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde68),%l1
	or	%l1,%lo(0xde68),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 17
.L2444:

! 1719		       n = ctx->EvalMap.Map1Texture2.Order * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 18
.L2445:

! 1720		       break;

	ba	.L2421
	nop

	! block 19
.L2446:
.L2447:

! 1721		    case GL_MAP1_TEXTURE_COORD_3:
! 1722		       data = ctx->EvalMap.Map1Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde7c),%l1
	or	%l1,%lo(0xde7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 20
.L2448:

! 1723		       n = ctx->EvalMap.Map1Texture3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 21
.L2449:

! 1724		       break;

	ba	.L2421
	nop

	! block 22
.L2450:
.L2451:

! 1725		    case GL_MAP1_TEXTURE_COORD_4:
! 1726		       data = ctx->EvalMap.Map1Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde90),%l1
	or	%l1,%lo(0xde90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 23
.L2452:

! 1727		       n = ctx->EvalMap.Map1Texture4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 24
.L2453:

! 1728		       break;

	ba	.L2421
	nop

	! block 25
.L2454:
.L2455:

! 1729		    case GL_MAP1_VERTEX_3:
! 1730		       data = ctx->EvalMap.Map1Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%l0
	st	%l0,[%fp-12]

	! block 26
.L2456:

! 1731		       n = ctx->EvalMap.Map1Vertex3.Order * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 27
.L2457:

! 1732		       break;

	ba	.L2421
	nop

	! block 28
.L2458:
.L2459:

! 1733		    case GL_MAP1_VERTEX_4:
! 1734		       data = ctx->EvalMap.Map1Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xde04),%l1
	or	%l1,%lo(0xde04),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 29
.L2460:

! 1735		       n = ctx->EvalMap.Map1Vertex4.Order * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 30
.L2461:

! 1736		       break;

	ba	.L2421
	nop

	! block 31
.L2462:
.L2463:

! 1737		    case GL_MAP2_COLOR_4:
! 1738		       data = ctx->EvalMap.Map2Color4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf10),%l1
	or	%l1,%lo(0xdf10),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 32
.L2464:

! 1739		       n = ctx->EvalMap.Map2Color4.Uorder
! 1740	                 * ctx->EvalMap.Map2Color4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 33
.L2465:

! 1741		       break;

	ba	.L2421
	nop

	! block 34
.L2466:
.L2467:

! 1742		    case GL_MAP2_INDEX:
! 1743		       data = ctx->EvalMap.Map2Index.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef0),%l1
	or	%l1,%lo(0xdef0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 35
.L2468:

! 1744		       n = ctx->EvalMap.Map2Index.Uorder
! 1745	                 * ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 36
.L2469:

! 1746		       break;

	ba	.L2421
	nop

	! block 37
.L2470:
.L2471:

! 1747		    case GL_MAP2_NORMAL:
! 1748		       data = ctx->EvalMap.Map2Normal.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf30),%l1
	or	%l1,%lo(0xdf30),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 38
.L2472:

! 1749		       n = ctx->EvalMap.Map2Normal.Uorder
! 1750	                 * ctx->EvalMap.Map2Normal.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 39
.L2473:

! 1751		       break;

	ba	.L2421
	nop

	! block 40
.L2474:
.L2475:

! 1752		    case GL_MAP2_TEXTURE_COORD_1:
! 1753		       data = ctx->EvalMap.Map2Texture1.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf50),%l1
	or	%l1,%lo(0xdf50),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 41
.L2476:

! 1754		       n = ctx->EvalMap.Map2Texture1.Uorder
! 1755	                 * ctx->EvalMap.Map2Texture1.Vorder * 1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-8]

	! block 42
.L2477:

! 1756		       break;

	ba	.L2421
	nop

	! block 43
.L2478:
.L2479:

! 1757		    case GL_MAP2_TEXTURE_COORD_2:
! 1758		       data = ctx->EvalMap.Map2Texture2.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf70),%l1
	or	%l1,%lo(0xdf70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 44
.L2480:

! 1759		       n = ctx->EvalMap.Map2Texture2.Uorder
! 1760	                 * ctx->EvalMap.Map2Texture2.Vorder * 2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 45
.L2481:

! 1761		       break;

	ba	.L2421
	nop

	! block 46
.L2482:
.L2483:

! 1762		    case GL_MAP2_TEXTURE_COORD_3:
! 1763		       data = ctx->EvalMap.Map2Texture3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf90),%l1
	or	%l1,%lo(0xdf90),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 47
.L2484:

! 1764		       n = ctx->EvalMap.Map2Texture3.Uorder
! 1765	                 * ctx->EvalMap.Map2Texture3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 48
.L2485:

! 1766		       break;

	ba	.L2421
	nop

	! block 49
.L2486:
.L2487:

! 1767		    case GL_MAP2_TEXTURE_COORD_4:
! 1768		       data = ctx->EvalMap.Map2Texture4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb0),%l1
	or	%l1,%lo(0xdfb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 50
.L2488:

! 1769		       n = ctx->EvalMap.Map2Texture4.Uorder
! 1770	                 * ctx->EvalMap.Map2Texture4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 51
.L2489:

! 1771		       break;

	ba	.L2421
	nop

	! block 52
.L2490:
.L2491:

! 1772		    case GL_MAP2_VERTEX_3:
! 1773		       data = ctx->EvalMap.Map2Vertex3.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb0),%l1
	or	%l1,%lo(0xdeb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 53
.L2492:

! 1774		       n = ctx->EvalMap.Map2Vertex3.Uorder
! 1775	                 * ctx->EvalMap.Map2Vertex3.Vorder * 3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-8]

	! block 54
.L2493:

! 1776		       break;

	ba	.L2421
	nop

	! block 55
.L2494:
.L2495:

! 1777		    case GL_MAP2_VERTEX_4:
! 1778		       data = ctx->EvalMap.Map2Vertex4.Points;

	ld	[%fp+68],%l0
	sethi	%hi(0xded0),%l1
	or	%l1,%lo(0xded0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-12]

	! block 56
.L2496:

! 1779		       n = ctx->EvalMap.Map2Vertex4.Uorder
! 1780	                 * ctx->EvalMap.Map2Vertex4.Vorder * 4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	smul	%l2,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 57
.L2497:

! 1781		       break;

	ba	.L2421
	nop

	! block 58
.L2498:
.L2499:

! 1782		    default:
! 1783		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapiv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2500),%l1
	or	%l1,%lo(.L2500),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 59
.L2501:
.L2502:
	ba	.L2421
	nop

	! block 60
.L2422:
.L2503:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y28
	nop

	! block 61
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2498
	nop

	! block 62
	sll	%l0,2,%l1
	sethi	%hi(.L_y29-36),%l0
	or	%l0,%lo(.L_y29-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 63
.L_y28:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2498
	nop

	! block 64
	sll	%l0,2,%l1
	sethi	%hi(.L_y30-36),%l0
	or	%l0,%lo(.L_y30-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 65
.L2504:
.L2421:
.L2505:
.L2506:
.L2508:

! 1784		 }
! 1785		 if (data) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L2507
	nop

	! block 66
.L2509:
.L2510:
.L2511:
.L2512:
.L2513:

! 1786		    for (i=0;i<n;i++) {

	ld	[%fp-8],%l0
	cmp	%g0,%l0
	bgeu	.L2516
	st	%g0,[%fp-4]

	! block 67
.L2517:
.L2514:
.L2518:
.L2519:
.L2520:

! 1787		       v[i] = ROUNDF(data[i]);

	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2521
	nop

	! block 68
.L2522:
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2523
	st	%l0,[%fp-16]

	! block 69
.L2521:
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-16]

	! block 70
.L2523:
	ld	[%fp-16],%l3
	ld	[%fp+80],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 71
.L2524:
.L2525:
.L2526:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	blu	.L2514
	nop

	! block 72
.L2527:
.L2516:
.L2528:
.L2529:
.L2530:
.L2507:
.L2531:
.L2532:

! 1788		    }
! 1789		 }
! 1790	         break;

	ba	.L2414
	nop

	! block 73
.L2533:
.L2534:
.L2537:

! 1791	      case GL_ORDER:
! 1792		 switch (target) {

	ba	.L2536
	nop

	! block 74
.L2538:
.L2539:
.L2540:
.L2541:

! 1793		    case GL_MAP1_COLOR_4:
! 1794		       *v = ctx->EvalMap.Map1Color4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 75
.L2542:

! 1795		       break;

	ba	.L2535
	nop

	! block 76
.L2543:
.L2544:

! 1796		    case GL_MAP1_INDEX:
! 1797		       *v = ctx->EvalMap.Map1Index.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 77
.L2545:

! 1798		       break;

	ba	.L2535
	nop

	! block 78
.L2546:
.L2547:

! 1799		    case GL_MAP1_NORMAL:
! 1800		       *v = ctx->EvalMap.Map1Normal.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 79
.L2548:

! 1801		       break;

	ba	.L2535
	nop

	! block 80
.L2549:
.L2550:

! 1802		    case GL_MAP1_TEXTURE_COORD_1:
! 1803		       *v = ctx->EvalMap.Map1Texture1.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 81
.L2551:

! 1804		       break;

	ba	.L2535
	nop

	! block 82
.L2552:
.L2553:

! 1805		    case GL_MAP1_TEXTURE_COORD_2:
! 1806		       *v = ctx->EvalMap.Map1Texture2.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 83
.L2554:

! 1807		       break;

	ba	.L2535
	nop

	! block 84
.L2555:
.L2556:

! 1808		    case GL_MAP1_TEXTURE_COORD_3:
! 1809		       *v = ctx->EvalMap.Map1Texture3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 85
.L2557:

! 1810		       break;

	ba	.L2535
	nop

	! block 86
.L2558:
.L2559:

! 1811		    case GL_MAP1_TEXTURE_COORD_4:
! 1812		       *v = ctx->EvalMap.Map1Texture4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 87
.L2560:

! 1813		       break;

	ba	.L2535
	nop

	! block 88
.L2561:
.L2562:

! 1814		    case GL_MAP1_VERTEX_3:
! 1815		       *v = ctx->EvalMap.Map1Vertex3.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 89
.L2563:

! 1816		       break;

	ba	.L2535
	nop

	! block 90
.L2564:
.L2565:

! 1817		    case GL_MAP1_VERTEX_4:
! 1818		       *v = ctx->EvalMap.Map1Vertex4.Order;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 91
.L2566:

! 1819		       break;

	ba	.L2535
	nop

	! block 92
.L2567:
.L2568:

! 1820		    case GL_MAP2_COLOR_4:
! 1821		       v[0] = ctx->EvalMap.Map2Color4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 93
.L2569:

! 1822		       v[1] = ctx->EvalMap.Map2Color4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdefc),%l1
	or	%l1,%lo(0xdefc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 94
.L2570:

! 1823		       break;

	ba	.L2535
	nop

	! block 95
.L2571:
.L2572:

! 1824		    case GL_MAP2_INDEX:
! 1825		       v[0] = ctx->EvalMap.Map2Index.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 96
.L2573:

! 1826		       v[1] = ctx->EvalMap.Map2Index.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdedc),%l1
	or	%l1,%lo(0xdedc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 97
.L2574:

! 1827		       break;

	ba	.L2535
	nop

	! block 98
.L2575:
.L2576:

! 1828		    case GL_MAP2_NORMAL:
! 1829		       v[0] = ctx->EvalMap.Map2Normal.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 99
.L2577:

! 1830		       v[1] = ctx->EvalMap.Map2Normal.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf1c),%l1
	or	%l1,%lo(0xdf1c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 100
.L2578:

! 1831		       break;

	ba	.L2535
	nop

	! block 101
.L2579:
.L2580:

! 1832		    case GL_MAP2_TEXTURE_COORD_1:
! 1833		       v[0] = ctx->EvalMap.Map2Texture1.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 102
.L2581:

! 1834		       v[1] = ctx->EvalMap.Map2Texture1.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf3c),%l1
	or	%l1,%lo(0xdf3c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 103
.L2582:

! 1835		       break;

	ba	.L2535
	nop

	! block 104
.L2583:
.L2584:

! 1836		    case GL_MAP2_TEXTURE_COORD_2:
! 1837		       v[0] = ctx->EvalMap.Map2Texture2.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 105
.L2585:

! 1838		       v[1] = ctx->EvalMap.Map2Texture2.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf5c),%l1
	or	%l1,%lo(0xdf5c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 106
.L2586:

! 1839		       break;

	ba	.L2535
	nop

	! block 107
.L2587:
.L2588:

! 1840		    case GL_MAP2_TEXTURE_COORD_3:
! 1841		       v[0] = ctx->EvalMap.Map2Texture3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 108
.L2589:

! 1842		       v[1] = ctx->EvalMap.Map2Texture3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf7c),%l1
	or	%l1,%lo(0xdf7c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 109
.L2590:

! 1843		       break;

	ba	.L2535
	nop

	! block 110
.L2591:
.L2592:

! 1844		    case GL_MAP2_TEXTURE_COORD_4:
! 1845		       v[0] = ctx->EvalMap.Map2Texture4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 111
.L2593:

! 1846		       v[1] = ctx->EvalMap.Map2Texture4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf9c),%l1
	or	%l1,%lo(0xdf9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 112
.L2594:

! 1847		       break;

	ba	.L2535
	nop

	! block 113
.L2595:
.L2596:

! 1848		    case GL_MAP2_VERTEX_3:
! 1849		       v[0] = ctx->EvalMap.Map2Vertex3.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 114
.L2597:

! 1850		       v[1] = ctx->EvalMap.Map2Vertex3.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xde9c),%l1
	or	%l1,%lo(0xde9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 115
.L2598:

! 1851		       break;

	ba	.L2535
	nop

	! block 116
.L2599:
.L2600:

! 1852		    case GL_MAP2_VERTEX_4:
! 1853		       v[0] = ctx->EvalMap.Map2Vertex4.Uorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 117
.L2601:

! 1854		       v[1] = ctx->EvalMap.Map2Vertex4.Vorder;

	ld	[%fp+68],%l0
	sethi	%hi(0xdebc),%l1
	or	%l1,%lo(0xdebc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 118
.L2602:

! 1855		       break;

	ba	.L2535
	nop

	! block 119
.L2603:
.L2604:

! 1856		    default:
! 1857		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapiv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2605),%l1
	or	%l1,%lo(.L2605),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 120
.L2606:
.L2607:
	ba	.L2535
	nop

	! block 121
.L2536:
.L2608:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y31
	nop

	! block 122
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2603
	nop

	! block 123
	sll	%l0,2,%l1
	sethi	%hi(.L_y32-36),%l0
	or	%l0,%lo(.L_y32-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 124
.L_y31:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2603
	nop

	! block 125
	sll	%l0,2,%l1
	sethi	%hi(.L_y33-36),%l0
	or	%l0,%lo(.L_y33-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 126
.L2609:
.L2535:
.L2610:
.L2611:

! 1858		 }
! 1859	         break;

	ba	.L2414
	nop

	! block 127
.L2612:
.L2613:
.L2616:

! 1860	      case GL_DOMAIN:
! 1861		 switch (target) {

	ba	.L2615
	nop

	! block 128
.L2617:
.L2618:
.L2619:
.L2620:

! 1862		    case GL_MAP1_COLOR_4:
! 1863		       v[0] = ROUNDF(ctx->EvalMap.Map1Color4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2621
	nop

	! block 129
.L2622:
	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2623
	st	%l0,[%fp-16]

	! block 130
.L2621:
	ld	[%fp+68],%l0
	sethi	%hi(0xde24),%l1
	or	%l1,%lo(0xde24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-16]

	! block 131
.L2623:
	ld	[%fp-16],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 132
.L2624:

! 1864		       v[1] = ROUNDF(ctx->EvalMap.Map1Color4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2625
	nop

	! block 133
.L2626:
	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2627
	st	%l0,[%fp-20]

	! block 134
.L2625:
	ld	[%fp+68],%l0
	sethi	%hi(0xde28),%l1
	or	%l1,%lo(0xde28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-20]

	! block 135
.L2627:
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 136
.L2628:

! 1865		       break;

	ba	.L2614
	nop

	! block 137
.L2629:
.L2630:

! 1866		    case GL_MAP1_INDEX:
! 1867		       v[0] = ROUNDF(ctx->EvalMap.Map1Index.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2631
	nop

	! block 138
.L2632:
	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2633
	st	%l0,[%fp-24]

	! block 139
.L2631:
	ld	[%fp+68],%l0
	sethi	%hi(0xde10),%l1
	or	%l1,%lo(0xde10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-24]

	! block 140
.L2633:
	ld	[%fp-24],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 141
.L2634:

! 1868		       v[1] = ROUNDF(ctx->EvalMap.Map1Index.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2635
	nop

	! block 142
.L2636:
	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2637
	st	%l0,[%fp-28]

	! block 143
.L2635:
	ld	[%fp+68],%l0
	sethi	%hi(0xde14),%l1
	or	%l1,%lo(0xde14),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-28]

	! block 144
.L2637:
	ld	[%fp-28],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 145
.L2638:

! 1869		       break;

	ba	.L2614
	nop

	! block 146
.L2639:
.L2640:

! 1870		    case GL_MAP1_NORMAL:
! 1871		       v[0] = ROUNDF(ctx->EvalMap.Map1Normal.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2641
	nop

	! block 147
.L2642:
	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2643
	st	%l0,[%fp-32]

	! block 148
.L2641:
	ld	[%fp+68],%l0
	sethi	%hi(0xde38),%l1
	or	%l1,%lo(0xde38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-32]

	! block 149
.L2643:
	ld	[%fp-32],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 150
.L2644:

! 1872		       v[1] = ROUNDF(ctx->EvalMap.Map1Normal.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2645
	nop

	! block 151
.L2646:
	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2647
	st	%l0,[%fp-36]

	! block 152
.L2645:
	ld	[%fp+68],%l0
	sethi	%hi(0xde3c),%l1
	or	%l1,%lo(0xde3c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-36]

	! block 153
.L2647:
	ld	[%fp-36],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 154
.L2648:

! 1873		       break;

	ba	.L2614
	nop

	! block 155
.L2649:
.L2650:

! 1874		    case GL_MAP1_TEXTURE_COORD_1:
! 1875		       v[0] = ROUNDF(ctx->EvalMap.Map1Texture1.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2651
	nop

	! block 156
.L2652:
	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2653
	st	%l0,[%fp-40]

	! block 157
.L2651:
	ld	[%fp+68],%l0
	sethi	%hi(0xde4c),%l1
	or	%l1,%lo(0xde4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-40]

	! block 158
.L2653:
	ld	[%fp-40],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 159
.L2654:

! 1876		       v[1] = ROUNDF(ctx->EvalMap.Map1Texture1.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2655
	nop

	! block 160
.L2656:
	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2657
	st	%l0,[%fp-44]

	! block 161
.L2655:
	ld	[%fp+68],%l0
	sethi	%hi(0xde50),%l1
	or	%l1,%lo(0xde50),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-44]

	! block 162
.L2657:
	ld	[%fp-44],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 163
.L2658:

! 1877		       break;

	ba	.L2614
	nop

	! block 164
.L2659:
.L2660:

! 1878		    case GL_MAP1_TEXTURE_COORD_2:
! 1879		       v[0] = ROUNDF(ctx->EvalMap.Map1Texture2.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2661
	nop

	! block 165
.L2662:
	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2663
	st	%l0,[%fp-48]

	! block 166
.L2661:
	ld	[%fp+68],%l0
	sethi	%hi(0xde60),%l1
	or	%l1,%lo(0xde60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-48]

	! block 167
.L2663:
	ld	[%fp-48],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 168
.L2664:

! 1880		       v[1] = ROUNDF(ctx->EvalMap.Map1Texture2.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2665
	nop

	! block 169
.L2666:
	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2667
	st	%l0,[%fp-52]

	! block 170
.L2665:
	ld	[%fp+68],%l0
	sethi	%hi(0xde64),%l1
	or	%l1,%lo(0xde64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-52]

	! block 171
.L2667:
	ld	[%fp-52],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 172
.L2668:

! 1881		       break;

	ba	.L2614
	nop

	! block 173
.L2669:
.L2670:

! 1882		    case GL_MAP1_TEXTURE_COORD_3:
! 1883		       v[0] = ROUNDF(ctx->EvalMap.Map1Texture3.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2671
	nop

	! block 174
.L2672:
	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2673
	st	%l0,[%fp-56]

	! block 175
.L2671:
	ld	[%fp+68],%l0
	sethi	%hi(0xde74),%l1
	or	%l1,%lo(0xde74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-56]

	! block 176
.L2673:
	ld	[%fp-56],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 177
.L2674:

! 1884		       v[1] = ROUNDF(ctx->EvalMap.Map1Texture3.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2675
	nop

	! block 178
.L2676:
	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2677
	st	%l0,[%fp-60]

	! block 179
.L2675:
	ld	[%fp+68],%l0
	sethi	%hi(0xde78),%l1
	or	%l1,%lo(0xde78),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-60]

	! block 180
.L2677:
	ld	[%fp-60],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 181
.L2678:

! 1885		       break;

	ba	.L2614
	nop

	! block 182
.L2679:
.L2680:

! 1886		    case GL_MAP1_TEXTURE_COORD_4:
! 1887		       v[0] = ROUNDF(ctx->EvalMap.Map1Texture4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2681
	nop

	! block 183
.L2682:
	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2683
	st	%l0,[%fp-64]

	! block 184
.L2681:
	ld	[%fp+68],%l0
	sethi	%hi(0xde88),%l1
	or	%l1,%lo(0xde88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-64]

	! block 185
.L2683:
	ld	[%fp-64],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 186
.L2684:

! 1888		       v[1] = ROUNDF(ctx->EvalMap.Map1Texture4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2685
	nop

	! block 187
.L2686:
	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2687
	st	%l0,[%fp-68]

	! block 188
.L2685:
	ld	[%fp+68],%l0
	sethi	%hi(0xde8c),%l1
	or	%l1,%lo(0xde8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-68]

	! block 189
.L2687:
	ld	[%fp-68],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 190
.L2688:

! 1889		       break;

	ba	.L2614
	nop

	! block 191
.L2689:
.L2690:

! 1890		    case GL_MAP1_VERTEX_3:
! 1891		       v[0] = ROUNDF(ctx->EvalMap.Map1Vertex3.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2691
	nop

	! block 192
.L2692:
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2693
	st	%l0,[%fp-72]

	! block 193
.L2691:
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-72]

	! block 194
.L2693:
	ld	[%fp-72],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 195
.L2694:

! 1892		       v[1] = ROUNDF(ctx->EvalMap.Map1Vertex3.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2695
	nop

	! block 196
.L2696:
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2697
	st	%l0,[%fp-76]

	! block 197
.L2695:
	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-76]

	! block 198
.L2697:
	ld	[%fp-76],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 199
.L2698:

! 1893		       break;

	ba	.L2614
	nop

	! block 200
.L2699:
.L2700:

! 1894		    case GL_MAP1_VERTEX_4:
! 1895		       v[0] = ROUNDF(ctx->EvalMap.Map1Vertex4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2701
	nop

	! block 201
.L2702:
	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2703
	st	%l0,[%fp-80]

	! block 202
.L2701:
	ld	[%fp+68],%l0
	sethi	%hi(0xddfc),%l1
	or	%l1,%lo(0xddfc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-80]

	! block 203
.L2703:
	ld	[%fp-80],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 204
.L2704:

! 1896		       v[1] = ROUNDF(ctx->EvalMap.Map1Vertex4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2705
	nop

	! block 205
.L2706:
	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2707
	st	%l0,[%fp-84]

	! block 206
.L2705:
	ld	[%fp+68],%l0
	sethi	%hi(0xde00),%l1
	or	%l1,%lo(0xde00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-84]

	! block 207
.L2707:
	ld	[%fp-84],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 208
.L2708:

! 1897		       break;

	ba	.L2614
	nop

	! block 209
.L2709:
.L2710:

! 1898		    case GL_MAP2_COLOR_4:
! 1899		       v[0] = ROUNDF(ctx->EvalMap.Map2Color4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2711
	nop

	! block 210
.L2712:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2713
	st	%l0,[%fp-88]

	! block 211
.L2711:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf00),%l1
	or	%l1,%lo(0xdf00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-88]

	! block 212
.L2713:
	ld	[%fp-88],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 213
.L2714:

! 1900		       v[1] = ROUNDF(ctx->EvalMap.Map2Color4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2715
	nop

	! block 214
.L2716:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2717
	st	%l0,[%fp-92]

	! block 215
.L2715:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf04),%l1
	or	%l1,%lo(0xdf04),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-92]

	! block 216
.L2717:
	ld	[%fp-92],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 217
.L2718:

! 1901		       v[2] = ROUNDF(ctx->EvalMap.Map2Color4.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2719
	nop

	! block 218
.L2720:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2721
	st	%l0,[%fp-96]

	! block 219
.L2719:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf08),%l1
	or	%l1,%lo(0xdf08),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-96]

	! block 220
.L2721:
	ld	[%fp-96],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 221
.L2722:

! 1902		       v[3] = ROUNDF(ctx->EvalMap.Map2Color4.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2723
	nop

	! block 222
.L2724:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2725
	st	%l0,[%fp-100]

	! block 223
.L2723:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf0c),%l1
	or	%l1,%lo(0xdf0c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-100]

	! block 224
.L2725:
	ld	[%fp-100],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 225
.L2726:

! 1903		       break;

	ba	.L2614
	nop

	! block 226
.L2727:
.L2728:

! 1904		    case GL_MAP2_INDEX:
! 1905		       v[0] = ROUNDF(ctx->EvalMap.Map2Index.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2729
	nop

	! block 227
.L2730:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2731
	st	%l0,[%fp-104]

	! block 228
.L2729:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee0),%l1
	or	%l1,%lo(0xdee0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-104]

	! block 229
.L2731:
	ld	[%fp-104],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 230
.L2732:

! 1906		       v[1] = ROUNDF(ctx->EvalMap.Map2Index.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2733
	nop

	! block 231
.L2734:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2735
	st	%l0,[%fp-108]

	! block 232
.L2733:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee4),%l1
	or	%l1,%lo(0xdee4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-108]

	! block 233
.L2735:
	ld	[%fp-108],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 234
.L2736:

! 1907		       v[2] = ROUNDF(ctx->EvalMap.Map2Index.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2737
	nop

	! block 235
.L2738:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2739
	st	%l0,[%fp-112]

	! block 236
.L2737:
	ld	[%fp+68],%l0
	sethi	%hi(0xdee8),%l1
	or	%l1,%lo(0xdee8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-112]

	! block 237
.L2739:
	ld	[%fp-112],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 238
.L2740:

! 1908		       v[3] = ROUNDF(ctx->EvalMap.Map2Index.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2741
	nop

	! block 239
.L2742:
	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2743
	st	%l0,[%fp-116]

	! block 240
.L2741:
	ld	[%fp+68],%l0
	sethi	%hi(0xdeec),%l1
	or	%l1,%lo(0xdeec),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-116]

	! block 241
.L2743:
	ld	[%fp-116],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 242
.L2744:

! 1909		       break;

	ba	.L2614
	nop

	! block 243
.L2745:
.L2746:

! 1910		    case GL_MAP2_NORMAL:
! 1911		       v[0] = ROUNDF(ctx->EvalMap.Map2Normal.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2747
	nop

	! block 244
.L2748:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2749
	st	%l0,[%fp-120]

	! block 245
.L2747:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf20),%l1
	or	%l1,%lo(0xdf20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-120]

	! block 246
.L2749:
	ld	[%fp-120],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 247
.L2750:

! 1912		       v[1] = ROUNDF(ctx->EvalMap.Map2Normal.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2751
	nop

	! block 248
.L2752:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2753
	st	%l0,[%fp-124]

	! block 249
.L2751:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf24),%l1
	or	%l1,%lo(0xdf24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-124]

	! block 250
.L2753:
	ld	[%fp-124],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 251
.L2754:

! 1913		       v[2] = ROUNDF(ctx->EvalMap.Map2Normal.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2755
	nop

	! block 252
.L2756:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2757
	st	%l0,[%fp-128]

	! block 253
.L2755:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf28),%l1
	or	%l1,%lo(0xdf28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-128]

	! block 254
.L2757:
	ld	[%fp-128],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 255
.L2758:

! 1914		       v[3] = ROUNDF(ctx->EvalMap.Map2Normal.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2759
	nop

	! block 256
.L2760:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2761
	st	%l0,[%fp-132]

	! block 257
.L2759:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf2c),%l1
	or	%l1,%lo(0xdf2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-132]

	! block 258
.L2761:
	ld	[%fp-132],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 259
.L2762:

! 1915		       break;

	ba	.L2614
	nop

	! block 260
.L2763:
.L2764:

! 1916		    case GL_MAP2_TEXTURE_COORD_1:
! 1917		       v[0] = ROUNDF(ctx->EvalMap.Map2Texture1.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2765
	nop

	! block 261
.L2766:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2767
	st	%l0,[%fp-136]

	! block 262
.L2765:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf40),%l1
	or	%l1,%lo(0xdf40),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-136]

	! block 263
.L2767:
	ld	[%fp-136],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 264
.L2768:

! 1918		       v[1] = ROUNDF(ctx->EvalMap.Map2Texture1.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2769
	nop

	! block 265
.L2770:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2771
	st	%l0,[%fp-140]

	! block 266
.L2769:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf44),%l1
	or	%l1,%lo(0xdf44),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-140]

	! block 267
.L2771:
	ld	[%fp-140],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 268
.L2772:

! 1919		       v[2] = ROUNDF(ctx->EvalMap.Map2Texture1.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2773
	nop

	! block 269
.L2774:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2775
	st	%l0,[%fp-144]

	! block 270
.L2773:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf48),%l1
	or	%l1,%lo(0xdf48),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-144]

	! block 271
.L2775:
	ld	[%fp-144],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 272
.L2776:

! 1920		       v[3] = ROUNDF(ctx->EvalMap.Map2Texture1.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2777
	nop

	! block 273
.L2778:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2779
	st	%l0,[%fp-148]

	! block 274
.L2777:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf4c),%l1
	or	%l1,%lo(0xdf4c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-148]

	! block 275
.L2779:
	ld	[%fp-148],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 276
.L2780:

! 1921		       break;

	ba	.L2614
	nop

	! block 277
.L2781:
.L2782:

! 1922		    case GL_MAP2_TEXTURE_COORD_2:
! 1923		       v[0] = ROUNDF(ctx->EvalMap.Map2Texture2.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2783
	nop

	! block 278
.L2784:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2785
	st	%l0,[%fp-152]

	! block 279
.L2783:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf60),%l1
	or	%l1,%lo(0xdf60),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-152]

	! block 280
.L2785:
	ld	[%fp-152],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 281
.L2786:

! 1924		       v[1] = ROUNDF(ctx->EvalMap.Map2Texture2.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2787
	nop

	! block 282
.L2788:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2789
	st	%l0,[%fp-156]

	! block 283
.L2787:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf64),%l1
	or	%l1,%lo(0xdf64),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-156]

	! block 284
.L2789:
	ld	[%fp-156],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 285
.L2790:

! 1925		       v[2] = ROUNDF(ctx->EvalMap.Map2Texture2.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2791
	nop

	! block 286
.L2792:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2793
	st	%l0,[%fp-160]

	! block 287
.L2791:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf68),%l1
	or	%l1,%lo(0xdf68),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-160]

	! block 288
.L2793:
	ld	[%fp-160],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 289
.L2794:

! 1926		       v[3] = ROUNDF(ctx->EvalMap.Map2Texture2.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2795
	nop

	! block 290
.L2796:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2797
	st	%l0,[%fp-164]

	! block 291
.L2795:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf6c),%l1
	or	%l1,%lo(0xdf6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-164]

	! block 292
.L2797:
	ld	[%fp-164],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 293
.L2798:

! 1927		       break;

	ba	.L2614
	nop

	! block 294
.L2799:
.L2800:

! 1928		    case GL_MAP2_TEXTURE_COORD_3:
! 1929		       v[0] = ROUNDF(ctx->EvalMap.Map2Texture3.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2801
	nop

	! block 295
.L2802:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2803
	st	%l0,[%fp-168]

	! block 296
.L2801:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf80),%l1
	or	%l1,%lo(0xdf80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-168]

	! block 297
.L2803:
	ld	[%fp-168],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 298
.L2804:

! 1930		       v[1] = ROUNDF(ctx->EvalMap.Map2Texture3.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2805
	nop

	! block 299
.L2806:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2807
	st	%l0,[%fp-172]

	! block 300
.L2805:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf84),%l1
	or	%l1,%lo(0xdf84),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-172]

	! block 301
.L2807:
	ld	[%fp-172],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 302
.L2808:

! 1931		       v[2] = ROUNDF(ctx->EvalMap.Map2Texture3.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2809
	nop

	! block 303
.L2810:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2811
	st	%l0,[%fp-176]

	! block 304
.L2809:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf88),%l1
	or	%l1,%lo(0xdf88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-176]

	! block 305
.L2811:
	ld	[%fp-176],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 306
.L2812:

! 1932		       v[3] = ROUNDF(ctx->EvalMap.Map2Texture3.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2813
	nop

	! block 307
.L2814:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2815
	st	%l0,[%fp-180]

	! block 308
.L2813:
	ld	[%fp+68],%l0
	sethi	%hi(0xdf8c),%l1
	or	%l1,%lo(0xdf8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-180]

	! block 309
.L2815:
	ld	[%fp-180],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 310
.L2816:

! 1933		       break;

	ba	.L2614
	nop

	! block 311
.L2817:
.L2818:

! 1934		    case GL_MAP2_TEXTURE_COORD_4:
! 1935		       v[0] = ROUNDF(ctx->EvalMap.Map2Texture4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2819
	nop

	! block 312
.L2820:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2821
	st	%l0,[%fp-184]

	! block 313
.L2819:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa0),%l1
	or	%l1,%lo(0xdfa0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-184]

	! block 314
.L2821:
	ld	[%fp-184],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 315
.L2822:

! 1936		       v[1] = ROUNDF(ctx->EvalMap.Map2Texture4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2823
	nop

	! block 316
.L2824:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2825
	st	%l0,[%fp-188]

	! block 317
.L2823:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa4),%l1
	or	%l1,%lo(0xdfa4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-188]

	! block 318
.L2825:
	ld	[%fp-188],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 319
.L2826:

! 1937		       v[2] = ROUNDF(ctx->EvalMap.Map2Texture4.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2827
	nop

	! block 320
.L2828:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2829
	st	%l0,[%fp-192]

	! block 321
.L2827:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfa8),%l1
	or	%l1,%lo(0xdfa8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-192]

	! block 322
.L2829:
	ld	[%fp-192],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 323
.L2830:

! 1938		       v[3] = ROUNDF(ctx->EvalMap.Map2Texture4.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2831
	nop

	! block 324
.L2832:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2833
	st	%l0,[%fp-196]

	! block 325
.L2831:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfac),%l1
	or	%l1,%lo(0xdfac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-196]

	! block 326
.L2833:
	ld	[%fp-196],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 327
.L2834:

! 1939		       break;

	ba	.L2614
	nop

	! block 328
.L2835:
.L2836:

! 1940		    case GL_MAP2_VERTEX_3:
! 1941		       v[0] = ROUNDF(ctx->EvalMap.Map2Vertex3.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2837
	nop

	! block 329
.L2838:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2839
	st	%l0,[%fp-200]

	! block 330
.L2837:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea0),%l1
	or	%l1,%lo(0xdea0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-200]

	! block 331
.L2839:
	ld	[%fp-200],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 332
.L2840:

! 1942		       v[1] = ROUNDF(ctx->EvalMap.Map2Vertex3.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2841
	nop

	! block 333
.L2842:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2843
	st	%l0,[%fp-204]

	! block 334
.L2841:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea4),%l1
	or	%l1,%lo(0xdea4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-204]

	! block 335
.L2843:
	ld	[%fp-204],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 336
.L2844:

! 1943		       v[2] = ROUNDF(ctx->EvalMap.Map2Vertex3.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2845
	nop

	! block 337
.L2846:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2847
	st	%l0,[%fp-208]

	! block 338
.L2845:
	ld	[%fp+68],%l0
	sethi	%hi(0xdea8),%l1
	or	%l1,%lo(0xdea8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-208]

	! block 339
.L2847:
	ld	[%fp-208],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 340
.L2848:

! 1944		       v[3] = ROUNDF(ctx->EvalMap.Map2Vertex3.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2849
	nop

	! block 341
.L2850:
	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2851
	st	%l0,[%fp-212]

	! block 342
.L2849:
	ld	[%fp+68],%l0
	sethi	%hi(0xdeac),%l1
	or	%l1,%lo(0xdeac),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-212]

	! block 343
.L2851:
	ld	[%fp-212],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 344
.L2852:

! 1945		       break;

	ba	.L2614
	nop

	! block 345
.L2853:
.L2854:

! 1946		    case GL_MAP2_VERTEX_4:
! 1947		       v[0] = ROUNDF(ctx->EvalMap.Map2Vertex4.u1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2855
	nop

	! block 346
.L2856:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2857
	st	%l0,[%fp-216]

	! block 347
.L2855:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec0),%l1
	or	%l1,%lo(0xdec0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-216]

	! block 348
.L2857:
	ld	[%fp-216],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+0]

	! block 349
.L2858:

! 1948		       v[1] = ROUNDF(ctx->EvalMap.Map2Vertex4.u2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2859
	nop

	! block 350
.L2860:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2861
	st	%l0,[%fp-220]

	! block 351
.L2859:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec4),%l1
	or	%l1,%lo(0xdec4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-220]

	! block 352
.L2861:
	ld	[%fp-220],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+4]

	! block 353
.L2862:

! 1949		       v[2] = ROUNDF(ctx->EvalMap.Map2Vertex4.v1);

	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2863
	nop

	! block 354
.L2864:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2865
	st	%l0,[%fp-224]

	! block 355
.L2863:
	ld	[%fp+68],%l0
	sethi	%hi(0xdec8),%l1
	or	%l1,%lo(0xdec8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-224]

	! block 356
.L2865:
	ld	[%fp-224],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+8]

	! block 357
.L2866:

! 1950		       v[3] = ROUNDF(ctx->EvalMap.Map2Vertex4.v2);

	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L2867
	nop

	! block 358
.L2868:
	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	ba	.L2869
	st	%l0,[%fp-228]

	! block 359
.L2867:
	ld	[%fp+68],%l0
	sethi	%hi(0xdecc),%l1
	or	%l1,%lo(0xdecc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fadds	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-232]
	ld	[%fp-232],%l0
	st	%l0,[%fp-228]

	! block 360
.L2869:
	ld	[%fp-228],%l1
	ld	[%fp+80],%l0
	st	%l1,[%l0+12]

	! block 361
.L2870:

! 1951		       break;

	ba	.L2614
	nop

	! block 362
.L2871:
.L2872:

! 1952		    default:
! 1953		       gl_error( ctx, GL_INVALID_ENUM, "glGetMapiv(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2873),%l1
	or	%l1,%lo(.L2873),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 363
.L2874:
.L2875:
	ba	.L2614
	nop

	! block 364
.L2615:
.L2876:
	ld	[%fp+72],%l2
	cmp	%l2,3504
	bge	.L_y34
	nop

	! block 365
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2871
	nop

	! block 366
	sll	%l0,2,%l1
	sethi	%hi(.L_y35-36),%l0
	or	%l0,%lo(.L_y35-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 367
.L_y34:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2871
	nop

	! block 368
	sll	%l0,2,%l1
	sethi	%hi(.L_y36-36),%l0
	or	%l0,%lo(.L_y36-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 369
.L2877:
.L2614:
.L2878:
.L2879:

! 1954		 }
! 1955	         break;

	ba	.L2414
	nop

	! block 370
.L2880:
.L2881:

! 1956	      default:
! 1957	         gl_error( ctx, GL_INVALID_ENUM, "glGetMapiv(query)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2882),%l1
	or	%l1,%lo(.L2882),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 371
.L2883:
.L2884:
	ba	.L2414
	nop

	! block 372
.L2415:
.L2885:
	ld	[%fp+76],%l0
	sub	%l0,2560,%l0
	cmp	%l0,2
	bgu	.L2880
	nop

	! block 373
	sll	%l0,2,%l1
	sethi	%hi(.L_y37-12),%l0
	or	%l0,%lo(.L_y37-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 374
.L2886:
.L2414:
.L2887:

	! block 375
.L2888:
.L2889:
.L2409:
	jmp	%i7+8
	restore
	.size	gl_GetMapiv,(.-gl_GetMapiv)

	.word	.L2426
	.word	.L2430
	.word	.L2434
	.word	.L2438
	.word	.L2442
	.word	.L2446
	.word	.L2450
	.word	.L2454
	.word	.L2458
.L_y29:
	.word	.L2462
	.word	.L2466
	.word	.L2470
	.word	.L2474
	.word	.L2478
	.word	.L2482
	.word	.L2486
	.word	.L2490
	.word	.L2494
.L_y30:
	.word	.L2540
	.word	.L2543
	.word	.L2546
	.word	.L2549
	.word	.L2552
	.word	.L2555
	.word	.L2558
	.word	.L2561
	.word	.L2564
.L_y32:
	.word	.L2567
	.word	.L2571
	.word	.L2575
	.word	.L2579
	.word	.L2583
	.word	.L2587
	.word	.L2591
	.word	.L2595
	.word	.L2599
.L_y33:
	.word	.L2619
	.word	.L2629
	.word	.L2639
	.word	.L2649
	.word	.L2659
	.word	.L2669
	.word	.L2679
	.word	.L2689
	.word	.L2699
.L_y35:
	.word	.L2709
	.word	.L2727
	.word	.L2745
	.word	.L2763
	.word	.L2781
	.word	.L2799
	.word	.L2817
	.word	.L2835
	.word	.L2853
.L_y36:
	.word	.L2419
	.word	.L2533
	.word	.L2612
.L_y37:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalCoord1f
	.type	gl_EvalCoord1f,#function
gl_EvalCoord1f:
	save	%sp,-184,%sp

	! block 1
.L2892:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L2893:
.L2895:
.L2897:

! File eval.c:
! 1958	   }
! 1959	}
! 1960	
! 1963	void gl_EvalCoord1f(GLcontext* ctx, GLfloat u)
! 1964	{
! 1965	  GLfloat vertex[4];
! 1966	  GLfloat normal[3];
! 1967	  GLfloat fcolor[4];
! 1968	  GLubyte icolor[4];
! 1969	  GLubyte *colorptr;
! 1970	  GLfloat texcoord[4];
! 1971	  GLuint index;
! 1972	  register GLfloat uu;
! 1973	
! 1974	  /** Vertex **/
! 1975	  if (ctx->Eval.Map1Vertex4) 

	ld	[%fp+68],%l0
	sethi	%hi(0x1f48),%l1
	or	%l1,%lo(0x1f48),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2896
	nop

	! block 3
.L2898:
.L2899:
.L2900:
.L2901:

! 1976	  {
! 1977	     struct gl_1d_map *map = &ctx->EvalMap.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0xddf8),%l1
	or	%l1,%lo(0xddf8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 4
.L2902:

! 1978	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 5
.L2903:

! 1979	     horner_bezier_curve(map->Points, vertex, uu, 4, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-16,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	4,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 6
.L2904:
.L2905:
	ba	.L2906
	nop

	! block 7
.L2896:
.L2907:
.L2908:
.L2910:

! 1980	  }
! 1981	  else if (ctx->Eval.Map1Vertex3) 

	ld	[%fp+68],%l0
	sethi	%hi(0x1f47),%l1
	or	%l1,%lo(0x1f47),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2909
	nop

	! block 8
.L2911:
.L2912:
.L2913:
.L2914:

! 1982	  {
! 1983	     struct gl_1d_map *map = &ctx->EvalMap.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde4),%l1
	or	%l1,%lo(0xdde4),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 9
.L2915:

! 1984	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 10
.L2916:

! 1985	     horner_bezier_curve(map->Points, vertex, uu, 3, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-16,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	3,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 11
.L2917:

! 1986	     vertex[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-4]

	! block 12
.L2918:
.L2919:
.L2909:
.L2920:
.L2921:
.L2906:
.L2922:
.L2923:
.L2925:

! 1987	  }
! 1988	
! 1989	  /** Color Index **/
! 1990	  if (ctx->Eval.Map1Index) 

	ld	[%fp+68],%l0
	sethi	%hi(0x1f41),%l1
	or	%l1,%lo(0x1f41),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2924
	nop

	! block 13
.L2926:
.L2927:
.L2928:
.L2929:

! 1991	  {
! 1992	     struct gl_1d_map *map = &ctx->EvalMap.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0xde0c),%l1
	or	%l1,%lo(0xde0c),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 14
.L2930:

! 1993	     GLfloat findex;
! 1994	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 15
.L2931:

! 1995	     horner_bezier_curve(map->Points, &findex, uu, 1, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-84,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	1,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 16
.L2932:

! 1996	     index = (GLuint) (GLint) findex;

	ld	[%fp-84],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l0
	st	%l0,[%fp-72]

	! block 17
.L2933:
.L2934:
	ba	.L2935
	nop

	! block 18
.L2924:
.L2936:
.L2937:
.L2938:

! 1997	  }
! 1998	  else {
! 1999	     index = ctx->Current.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-72]

	! block 19
.L2939:
.L2940:
.L2935:
.L2941:
.L2942:
.L2944:

! 2000	  }
! 2001	
! 2002	  /** Color **/
! 2003	  if (ctx->Eval.Map1Color4) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f40),%l1
	or	%l1,%lo(0x1f40),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2943
	nop

	! block 20
.L2945:
.L2946:
.L2947:
.L2948:

! 2004	     struct gl_1d_map *map = &ctx->EvalMap.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde20),%l1
	or	%l1,%lo(0xde20),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 21
.L2949:

! 2005	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 22
.L2950:

! 2006	     horner_bezier_curve(map->Points, fcolor, uu, 4, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-44,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	4,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 23
.L2951:

! 2007	     icolor[0] = (GLint) (fcolor[0] * ctx->Visual->RedScale);

	ld	[%fp-44],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+4],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l0
	stb	%l0,[%fp-48]

	! block 24
.L2952:

! 2008	     icolor[1] = (GLint) (fcolor[1] * ctx->Visual->GreenScale);

	ld	[%fp-40],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+8],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l0
	stb	%l0,[%fp-47]

	! block 25
.L2953:

! 2009	     icolor[2] = (GLint) (fcolor[2] * ctx->Visual->BlueScale);

	ld	[%fp-36],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+12],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l0
	stb	%l0,[%fp-46]

	! block 26
.L2954:

! 2010	     icolor[3] = (GLint) (fcolor[3] * ctx->Visual->AlphaScale);

	ld	[%fp-32],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+16],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l0
	stb	%l0,[%fp-45]

	! block 27
.L2955:

! 2011	     colorptr = icolor;

	add	%fp,-48,%l0
	st	%l0,[%fp-52]

	! block 28
.L2956:
.L2957:
	ba	.L2958
	nop

	! block 29
.L2943:
.L2959:
.L2960:
.L2961:

! 2012	  }
! 2013	  else {
! 2014	     GLubyte col[4];
! 2015	     COPY_4V(col, ctx->Current.ByteColor );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-80]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+1],%l0
	stb	%l0,[%fp-79]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+2],%l0
	stb	%l0,[%fp-78]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+3],%l0
	stb	%l0,[%fp-77]

	! block 30
.L2962:

! 2016	     colorptr = col;

	add	%fp,-80,%l0
	st	%l0,[%fp-52]

	! block 31
.L2963:
.L2964:
.L2958:
.L2965:
.L2966:
.L2968:

! 2017	  }
! 2018	
! 2019	  /** Normal Vector **/
! 2020	  if (ctx->Eval.Map1Normal) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f42),%l1
	or	%l1,%lo(0x1f42),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2967
	nop

	! block 32
.L2969:
.L2970:
.L2971:
.L2972:

! 2021	     struct gl_1d_map *map = &ctx->EvalMap.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0xde34),%l1
	or	%l1,%lo(0xde34),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 33
.L2973:

! 2022	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 34
.L2974:

! 2023	     horner_bezier_curve(map->Points, normal, uu, 3, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-28,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	3,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 35
.L2975:
.L2976:
	ba	.L2977
	nop

	! block 36
.L2967:
.L2978:
.L2979:
.L2980:

! 2024	  }
! 2025	  else {
! 2026	    normal[0] = ctx->Current.Normal[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-28]

	! block 37
.L2981:

! 2027	    normal[1] = ctx->Current.Normal[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-24]

	! block 38
.L2982:

! 2028	    normal[2] = ctx->Current.Normal[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 39
.L2983:
.L2984:
.L2977:
.L2985:
.L2986:
.L2988:

! 2029	  }
! 2030	
! 2031	  /** Texture Coordinates **/
! 2032	  if (ctx->Eval.Map1TextureCoord4) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f46),%l1
	or	%l1,%lo(0x1f46),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2987
	nop

	! block 40
.L2989:
.L2990:
.L2991:
.L2992:

! 2033	     struct gl_1d_map *map = &ctx->EvalMap.Map1Texture4;

	ld	[%fp+68],%l0
	sethi	%hi(0xde84),%l1
	or	%l1,%lo(0xde84),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 41
.L2993:

! 2034	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 42
.L2994:

! 2035	     horner_bezier_curve(map->Points, texcoord, uu, 4, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	4,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 43
.L2995:
.L2996:
	ba	.L2997
	nop

	! block 44
.L2987:
.L2998:
.L2999:
.L3001:

! 2036	  }
! 2037	  else if (ctx->Eval.Map1TextureCoord3) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f45),%l1
	or	%l1,%lo(0x1f45),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3000
	nop

	! block 45
.L3002:
.L3003:
.L3004:
.L3005:

! 2038	     struct gl_1d_map *map = &ctx->EvalMap.Map1Texture3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde70),%l1
	or	%l1,%lo(0xde70),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 46
.L3006:

! 2039	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 47
.L3007:

! 2040	     horner_bezier_curve(map->Points, texcoord, uu, 3, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	3,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 48
.L3008:

! 2041	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 49
.L3009:
.L3010:
	ba	.L3011
	nop

	! block 50
.L3000:
.L3012:
.L3013:
.L3015:

! 2042	  }
! 2043	  else if (ctx->Eval.Map1TextureCoord2) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f44),%l1
	or	%l1,%lo(0x1f44),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3014
	nop

	! block 51
.L3016:
.L3017:
.L3018:
.L3019:

! 2044	     struct gl_1d_map *map = &ctx->EvalMap.Map1Texture2;

	ld	[%fp+68],%l0
	sethi	%hi(0xde5c),%l1
	or	%l1,%lo(0xde5c),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 52
.L3020:

! 2045	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 53
.L3021:

! 2046	     horner_bezier_curve(map->Points, texcoord, uu, 2, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	2,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 54
.L3022:

! 2047	     texcoord[2] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 55
.L3023:

! 2048	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 56
.L3024:
.L3025:
	ba	.L3026
	nop

	! block 57
.L3014:
.L3027:
.L3028:
.L3030:

! 2049	  }
! 2050	  else if (ctx->Eval.Map1TextureCoord1) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f43),%l1
	or	%l1,%lo(0x1f43),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3029
	nop

	! block 58
.L3031:
.L3032:
.L3033:
.L3034:

! 2051	     struct gl_1d_map *map = &ctx->EvalMap.Map1Texture1;

	ld	[%fp+68],%l0
	sethi	%hi(0xde48),%l1
	or	%l1,%lo(0xde48),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 59
.L3035:

! 2052	     uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-80],%l0
	ld	[%l0+4],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+8],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 60
.L3036:

! 2053	     horner_bezier_curve(map->Points, texcoord, uu, 1, map->Order);

	ld	[%fp-80],%l0
	ld	[%l0+12],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%l0+0],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	mov	1,%o3
	call	horner_bezier_curve
	mov	%l0,%o4

	! block 61
.L3037:

! 2054	     texcoord[1] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-64]

	! block 62
.L3038:

! 2055	     texcoord[2] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 63
.L3039:

! 2056	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 64
.L3040:
.L3041:
	ba	.L3042
	nop

	! block 65
.L3029:
.L3043:
.L3044:
.L3045:

! 2057	  }
! 2058	  else {
! 2059	     texcoord[0] = ctx->Current.TexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-68]

	! block 66
.L3046:

! 2060	     texcoord[1] = ctx->Current.TexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-64]

	! block 67
.L3047:

! 2061	     texcoord[2] = ctx->Current.TexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-60]

	! block 68
.L3048:

! 2062	     texcoord[3] = ctx->Current.TexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-56]

	! block 69
.L3049:
.L3050:
.L3042:
.L3051:
.L3052:
.L3026:
.L3053:
.L3054:
.L3011:
.L3055:
.L3056:
.L2997:
.L3057:
.L3058:

! 2063	  }
! 2064	  
! 2065	  gl_eval_vertex( ctx, vertex, normal, colorptr, index, texcoord );

	ld	[%fp+68],%l0
	add	%fp,-16,%l1
	add	%fp,-28,%l2
	ld	[%fp-52],%l3
	ld	[%fp-72],%l5
	add	%fp,-68,%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	call	gl_eval_vertex
	mov	%l4,%o5

	! block 70
.L3059:
.L3060:
.L2891:
	jmp	%i7+8
	restore
	.size	gl_EvalCoord1f,(.-gl_EvalCoord1f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalCoord2f
	.type	gl_EvalCoord2f,#function
gl_EvalCoord2f:
	save	%sp,-232,%sp

	! block 1
.L3063:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L3064:
.L3066:
.L3068:

! File eval.c:
! 2066	}
! 2067	
! 2069	void gl_EvalCoord2f( GLcontext* ctx, GLfloat u, GLfloat v )
! 2070	{
! 2071	   GLfloat vertex[4];
! 2072	   GLfloat normal[3];
! 2073	   GLfloat fcolor[4];
! 2074	   GLubyte icolor[4];
! 2075	   GLubyte *colorptr;
! 2076	   GLfloat texcoord[4];
! 2077	   GLuint index;
! 2078	   register GLfloat uu, vv;
! 2079	
! 2080	#define CROSS_PROD(n, u, v) \
! 2081	  (n)[0] = (u)[1]*(v)[2] - (u)[2]*(v)[1]; \
! 2082	  (n)[1] = (u)[2]*(v)[0] - (u)[0]*(v)[2]; \
! 2083	  (n)[2] = (u)[0]*(v)[1] - (u)[1]*(v)[0]
! 2084	
! 2085	   /** Vertex **/
! 2086	   if(ctx->Eval.Map2Vertex4) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3067
	nop

	! block 3
.L3069:
.L3070:
.L3071:
.L3072:

! 2087	      struct gl_2d_map *map = &ctx->EvalMap.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdeb8),%l1
	or	%l1,%lo(0xdeb8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 4
.L3073:

! 2088	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 5
.L3074:

! 2089	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 6
.L3075:
.L3077:

! 2091	      if (ctx->Eval.AutoNormal) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3076
	nop

	! block 7
.L3078:
.L3079:
.L3080:
.L3081:

! 2092	         GLfloat du[4], dv[4];
! 2093	
! 2094	         de_casteljau_surf(map->Points, vertex, du, dv, uu, vv, 4,
! 2095	                           map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-16,%l2
	add	%fp,-100,%l3
	add	%fp,-116,%l5
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	mov	4,%l6
	ld	[%l0+0],%l7
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l3,%o2
	mov	%l5,%o3
	st	%f4,[%sp+84]
	ld	[%sp+84],%o4
	st	%f5,[%sp+88]
	ld	[%sp+88],%o5
	st	%l6,[%sp+92]
	st	%l7,[%sp+96]
	call	de_casteljau_surf
	st	%l0,[%sp+100]

	! block 8
.L3082:

! 2097	         CROSS_PROD(normal, du, dv);

	ld	[%fp-96],%f5
	ld	[%fp-108],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-92],%f5
	ld	[%fp-112],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-28]
	ld	[%fp-92],%f5
	ld	[%fp-116],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-100],%f5
	ld	[%fp-108],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-24]
	ld	[%fp-100],%f5
	ld	[%fp-112],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-96],%f5
	ld	[%fp-116],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-20]

	! block 9
.L3083:
.L3084:

! 2098	         NORMALIZE_3FV(normal);

	ld	[%fp-28],%f4
	fmuls	%f4,%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f4,%f4,%f4
	fadds	%f5,%f4,%f5
	ld	[%fp-20],%f4
	fmuls	%f4,%f4,%f4
	fadds	%f5,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o0
	or	%g0,%g1,%o1
	call	sqrt
	nop
	fdtos	%f0,%f4
	st	%f4,[%fp-120]

	! block 10
.L3085:
	ld	[%fp-120],%f5
	sethi	%hi(.L_cseg5),%l0
	ld	[%l0+%lo(.L_cseg5)],%f4
	fcmpes	%f5,%f4
	fbule	.L3086
	nop

	! block 11
.L3087:
.L3088:
.L3089:
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f5
	ld	[%fp-120],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-120]
	ld	[%fp-28],%f5
	ld	[%fp-120],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-28]
	ld	[%fp-24],%f5
	ld	[%fp-120],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-24]
	ld	[%fp-20],%f5
	ld	[%fp-120],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-20]

	! block 12
.L3090:
.L3091:
.L3086:
.L3092:
.L3093:
.L3094:
.L3095:
	ba	.L3096
	nop

	! block 13
.L3076:
.L3097:
.L3098:
.L3099:

! 2099	      }
! 2100	      else {
! 2101	         horner_bezier_surf(map->Points, vertex, uu, vv, 4,
! 2102	                            map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-16,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	4,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 14
.L3100:
.L3101:
.L3096:
.L3102:
.L3103:
.L3104:
	ba	.L3105
	nop

	! block 15
.L3067:
.L3106:
.L3107:
.L3109:

! 2103	      }
! 2104	   }
! 2105	   else if (ctx->Eval.Map2Vertex3) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3108
	nop

	! block 16
.L3110:
.L3111:
.L3112:
.L3113:

! 2106	      struct gl_2d_map *map = &ctx->EvalMap.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0xde98),%l1
	or	%l1,%lo(0xde98),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 17
.L3114:

! 2107	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 18
.L3115:

! 2108	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 19
.L3116:
.L3118:

! 2109	      if (ctx->Eval.AutoNormal) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3117
	nop

	! block 20
.L3119:
.L3120:
.L3121:
.L3122:

! 2110	         GLfloat du[3], dv[3];
! 2111	         de_casteljau_surf(map->Points, vertex, du, dv, uu, vv, 3,
! 2112	                           map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-16,%l2
	add	%fp,-96,%l3
	add	%fp,-108,%l5
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	mov	3,%l6
	ld	[%l0+0],%l7
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l3,%o2
	mov	%l5,%o3
	st	%f4,[%sp+84]
	ld	[%sp+84],%o4
	st	%f5,[%sp+88]
	ld	[%sp+88],%o5
	st	%l6,[%sp+92]
	st	%l7,[%sp+96]
	call	de_casteljau_surf
	st	%l0,[%sp+100]

	! block 21
.L3123:

! 2113	         CROSS_PROD(normal, du, dv);

	ld	[%fp-92],%f5
	ld	[%fp-100],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-88],%f5
	ld	[%fp-104],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-28]
	ld	[%fp-88],%f5
	ld	[%fp-108],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-96],%f5
	ld	[%fp-100],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-24]
	ld	[%fp-96],%f5
	ld	[%fp-104],%f4
	fmuls	%f5,%f4,%f6
	ld	[%fp-92],%f5
	ld	[%fp-108],%f4
	fmuls	%f5,%f4,%f4
	fsubs	%f6,%f4,%f4
	st	%f4,[%fp-20]

	! block 22
.L3124:
.L3125:

! 2114	         NORMALIZE_3FV(normal);

	ld	[%fp-28],%f4
	fmuls	%f4,%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f4,%f4,%f4
	fadds	%f5,%f4,%f5
	ld	[%fp-20],%f4
	fmuls	%f4,%f4,%f4
	fadds	%f5,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o0
	or	%g0,%g1,%o1
	call	sqrt
	nop
	fdtos	%f0,%f4
	st	%f4,[%fp-112]

	! block 23
.L3126:
	ld	[%fp-112],%f5
	sethi	%hi(.L_cseg5),%l0
	ld	[%l0+%lo(.L_cseg5)],%f4
	fcmpes	%f5,%f4
	fbule	.L3127
	nop

	! block 24
.L3128:
.L3129:
.L3130:
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-112]
	ld	[%fp-28],%f5
	ld	[%fp-112],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-28]
	ld	[%fp-24],%f5
	ld	[%fp-112],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-24]
	ld	[%fp-20],%f5
	ld	[%fp-112],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-20]

	! block 25
.L3131:
.L3132:
.L3127:
.L3133:
.L3134:
.L3135:
.L3136:
	ba	.L3137
	nop

	! block 26
.L3117:
.L3138:
.L3139:
.L3140:

! 2115	      }
! 2116	      else {
! 2117	         horner_bezier_surf(map->Points, vertex, uu, vv, 3,
! 2118	                            map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-16,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	3,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 27
.L3141:
.L3142:
.L3137:
.L3143:
.L3144:

! 2119	      }
! 2120	      vertex[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-4]

	! block 28
.L3145:
.L3146:
.L3108:
.L3147:
.L3148:
.L3105:
.L3149:
.L3150:
.L3152:

! 2121	   }
! 2122	#undef CROSS_PROD
! 2123	   
! 2124	   /** Color Index **/
! 2125	   if (ctx->Eval.Map2Index) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4a),%l1
	or	%l1,%lo(0x1f4a),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3151
	nop

	! block 29
.L3153:
.L3154:
.L3155:
.L3156:

! 2126	      GLfloat findex;
! 2127	      struct gl_2d_map *map = &ctx->EvalMap.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0xded8),%l1
	or	%l1,%lo(0xded8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 30
.L3157:

! 2128	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-88],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 31
.L3158:

! 2129	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-88],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 32
.L3159:

! 2130	      horner_bezier_surf(map->Points, &findex, uu, vv, 1,
! 2131	                         map->Uorder, map->Vorder);

	ld	[%fp-88],%l0
	ld	[%l0+24],%l1
	add	%fp,-84,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	1,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 33
.L3160:

! 2132	      index = (GLuint) (GLint) findex;

	ld	[%fp-84],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-124]
	ld	[%fp-124],%l0
	st	%l0,[%fp-72]

	! block 34
.L3161:
.L3162:
	ba	.L3163
	nop

	! block 35
.L3151:
.L3164:
.L3165:
.L3166:

! 2133	   }
! 2134	   else {
! 2135	      index = ctx->Current.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-72]

	! block 36
.L3167:
.L3168:
.L3163:
.L3169:
.L3170:
.L3172:

! 2136	   }
! 2137	
! 2138	   /** Color **/
! 2139	   if (ctx->Eval.Map2Color4) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f49),%l1
	or	%l1,%lo(0x1f49),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3171
	nop

	! block 37
.L3173:
.L3174:
.L3175:
.L3176:

! 2140	      struct gl_2d_map *map = &ctx->EvalMap.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdef8),%l1
	or	%l1,%lo(0xdef8),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 38
.L3177:

! 2141	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 39
.L3178:

! 2142	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 40
.L3179:

! 2143	      horner_bezier_surf(map->Points, fcolor, uu, vv, 4,
! 2144	                         map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-44,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	4,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 41
.L3180:

! 2145	      icolor[0] = (GLint) (fcolor[0] * ctx->Visual->RedScale);

	ld	[%fp-44],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+4],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-124]
	ld	[%fp-124],%l0
	stb	%l0,[%fp-48]

	! block 42
.L3181:

! 2146	      icolor[1] = (GLint) (fcolor[1] * ctx->Visual->GreenScale);

	ld	[%fp-40],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+8],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-124]
	ld	[%fp-124],%l0
	stb	%l0,[%fp-47]

	! block 43
.L3182:

! 2147	      icolor[2] = (GLint) (fcolor[2] * ctx->Visual->BlueScale);

	ld	[%fp-36],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+12],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-124]
	ld	[%fp-124],%l0
	stb	%l0,[%fp-46]

	! block 44
.L3183:

! 2148	      icolor[3] = (GLint) (fcolor[3] * ctx->Visual->AlphaScale);

	ld	[%fp-32],%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+16],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-124]
	ld	[%fp-124],%l0
	stb	%l0,[%fp-45]

	! block 45
.L3184:

! 2149	      colorptr = icolor;

	add	%fp,-48,%l0
	st	%l0,[%fp-52]

	! block 46
.L3185:
.L3186:
	ba	.L3187
	nop

	! block 47
.L3171:
.L3188:
.L3189:
.L3190:

! 2150	   }
! 2151	   else {
! 2152	     GLubyte col[4];
! 2153	     COPY_4V(col, ctx->Current.ByteColor );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-84]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+1],%l0
	stb	%l0,[%fp-83]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+2],%l0
	stb	%l0,[%fp-82]
	ld	[%fp+68],%l0
	add	%l0,%l1,%l0
	ldub	[%l0+3],%l0
	stb	%l0,[%fp-81]

	! block 48
.L3191:

! 2154	     colorptr = col;

	add	%fp,-84,%l0
	st	%l0,[%fp-52]

	! block 49
.L3192:
.L3193:
.L3187:
.L3194:
.L3195:
.L3197:

! 2155	   }
! 2156	
! 2157	   /** Normal **/
! 2158	   if (!ctx->Eval.AutoNormal
! 2159	       || (!ctx->Eval.Map2Vertex3 && !ctx->Eval.Map2Vertex4)) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3198
	nop

	! block 50
.L3199:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L3196
	nop

	! block 51
.L3200:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L3196
	nop

	! block 52
.L3201:
.L3198:
.L3202:
.L3203:
.L3204:
.L3206:

! 2160	      if (ctx->Eval.Map2Normal) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4b),%l1
	or	%l1,%lo(0x1f4b),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3205
	nop

	! block 53
.L3207:
.L3208:
.L3209:
.L3210:

! 2161	         struct gl_2d_map *map = &ctx->EvalMap.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf18),%l1
	or	%l1,%lo(0xdf18),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 54
.L3211:

! 2162	         uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 55
.L3212:

! 2163	         vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 56
.L3213:

! 2164	         horner_bezier_surf(map->Points, normal, uu, vv, 3,
! 2165	                            map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-28,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	3,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 57
.L3214:
.L3215:
	ba	.L3216
	nop

	! block 58
.L3205:
.L3217:
.L3218:
.L3219:

! 2166	      }
! 2167	      else {
! 2168	         normal[0] = ctx->Current.Normal[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-28]

	! block 59
.L3220:

! 2169	         normal[1] = ctx->Current.Normal[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-24]

	! block 60
.L3221:

! 2170	         normal[2] = ctx->Current.Normal[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 61
.L3222:
.L3223:
.L3216:
.L3224:
.L3225:
.L3226:
.L3196:
.L3227:
.L3228:
.L3230:

! 2171	      }
! 2172	   }
! 2173	
! 2174	   /** Texture Coordinates **/
! 2175	   if (ctx->Eval.Map2TextureCoord4) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4f),%l1
	or	%l1,%lo(0x1f4f),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3229
	nop

	! block 62
.L3231:
.L3232:
.L3233:
.L3234:

! 2176	      struct gl_2d_map *map = &ctx->EvalMap.Map2Texture4;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf98),%l1
	or	%l1,%lo(0xdf98),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 63
.L3235:

! 2177	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 64
.L3236:

! 2178	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 65
.L3237:

! 2179	      horner_bezier_surf(map->Points, texcoord, uu, vv, 4,
! 2180	                         map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	4,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 66
.L3238:
.L3239:
	ba	.L3240
	nop

	! block 67
.L3229:
.L3241:
.L3242:
.L3244:

! 2181	   }
! 2182	   else if (ctx->Eval.Map2TextureCoord3) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4e),%l1
	or	%l1,%lo(0x1f4e),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3243
	nop

	! block 68
.L3245:
.L3246:
.L3247:
.L3248:

! 2183	      struct gl_2d_map *map = &ctx->EvalMap.Map2Texture3;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf78),%l1
	or	%l1,%lo(0xdf78),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 69
.L3249:

! 2184	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 70
.L3250:

! 2185	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 71
.L3251:

! 2186	      horner_bezier_surf(map->Points, texcoord, uu, vv, 3,
! 2187	                         map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	3,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 72
.L3252:

! 2188	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 73
.L3253:
.L3254:
	ba	.L3255
	nop

	! block 74
.L3243:
.L3256:
.L3257:
.L3259:

! 2189	   }
! 2190	   else if (ctx->Eval.Map2TextureCoord2) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4d),%l1
	or	%l1,%lo(0x1f4d),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3258
	nop

	! block 75
.L3260:
.L3261:
.L3262:
.L3263:

! 2191	      struct gl_2d_map *map = &ctx->EvalMap.Map2Texture2;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf58),%l1
	or	%l1,%lo(0xdf58),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 76
.L3264:

! 2192	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 77
.L3265:

! 2193	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 78
.L3266:

! 2194	      horner_bezier_surf(map->Points, texcoord, uu, vv, 2,
! 2195	                         map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	2,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 79
.L3267:

! 2196	     texcoord[2] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 80
.L3268:

! 2197	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 81
.L3269:
.L3270:
	ba	.L3271
	nop

	! block 82
.L3258:
.L3272:
.L3273:
.L3275:

! 2198	   }
! 2199	   else if (ctx->Eval.Map2TextureCoord1) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4c),%l1
	or	%l1,%lo(0x1f4c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3274
	nop

	! block 83
.L3276:
.L3277:
.L3278:
.L3279:

! 2200	      struct gl_2d_map *map = &ctx->EvalMap.Map2Texture1;

	ld	[%fp+68],%l0
	sethi	%hi(0xdf38),%l1
	or	%l1,%lo(0xdf38),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 84
.L3280:

! 2201	      uu = (u - map->u1) / (map->u2 - map->u1);

	ld	[%fp+72],%f4
	ld	[%fp-84],%l0
	ld	[%l0+8],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+12],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 85
.L3281:

! 2202	      vv = (v - map->v1) / (map->v2 - map->v1);

	ld	[%fp+76],%f4
	ld	[%fp-84],%l0
	ld	[%l0+16],%f5
	fsubs	%f4,%f5,%f6
	ld	[%l0+20],%f4
	fsubs	%f4,%f5,%f4
	fdivs	%f6,%f4,%f4
	st	%f4,[%fp-80]

	! block 86
.L3282:

! 2203	      horner_bezier_surf(map->Points, texcoord, uu, vv, 1,
! 2204	                         map->Uorder, map->Vorder);

	ld	[%fp-84],%l0
	ld	[%l0+24],%l1
	add	%fp,-68,%l2
	ld	[%fp-76],%f4
	ld	[%fp-80],%f5
	ld	[%l0+0],%l3
	ld	[%l0+4],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	st	%f4,[%sp+76]
	ld	[%sp+76],%o2
	st	%f5,[%sp+80]
	ld	[%sp+80],%o3
	mov	1,%o4
	mov	%l3,%o5
	call	horner_bezier_surf
	st	%l0,[%sp+92]

	! block 87
.L3283:

! 2205	     texcoord[1] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-64]

	! block 88
.L3284:

! 2206	     texcoord[2] = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 89
.L3285:

! 2207	     texcoord[3] = 1.0;

	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-56]

	! block 90
.L3286:
.L3287:
	ba	.L3288
	nop

	! block 91
.L3274:
.L3289:
.L3290:
.L3291:

! 2208	   }
! 2209	   else 
! 2210	   {
! 2211	     texcoord[0] = ctx->Current.TexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-68]

	! block 92
.L3292:

! 2212	     texcoord[1] = ctx->Current.TexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-64]

	! block 93
.L3293:

! 2213	     texcoord[2] = ctx->Current.TexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-60]

	! block 94
.L3294:

! 2214	     texcoord[3] = ctx->Current.TexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-56]

	! block 95
.L3295:
.L3296:
.L3288:
.L3297:
.L3298:
.L3271:
.L3299:
.L3300:
.L3255:
.L3301:
.L3302:
.L3240:
.L3303:
.L3304:

! 2215	   }
! 2216	
! 2217	   gl_eval_vertex( ctx, vertex, normal, colorptr, index, texcoord );

	ld	[%fp+68],%l0
	add	%fp,-16,%l1
	add	%fp,-28,%l2
	ld	[%fp-52],%l3
	ld	[%fp-72],%l5
	add	%fp,-68,%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	call	gl_eval_vertex
	mov	%l4,%o5

	! block 96
.L3305:
.L3306:
.L3062:
	jmp	%i7+8
	restore
	.size	gl_EvalCoord2f,(.-gl_EvalCoord2f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_MapGrid1f
	.type	gl_MapGrid1f,#function
gl_MapGrid1f:
	save	%sp,-96,%sp

	! block 1
.L3309:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L3310:
.L3312:
.L3314:

! File eval.c:
! 2218	}
! 2219	
! 2221	void gl_MapGrid1f( GLcontext* ctx, GLint un, GLfloat u1, GLfloat u2 )
! 2222	{
! 2223	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3313
	nop

	! block 3
.L3315:
.L3316:
.L3317:
.L3318:

! 2224	      gl_error( ctx, GL_INVALID_OPERATION, "glMapGrid1f" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3319),%l1
	or	%l1,%lo(.L3319),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3320:

! 2225	      return;

	ba	.L3308
	nop

	! block 5
.L3321:
.L3322:
.L3313:
.L3323:
.L3324:
.L3326:

! 2226	   }
! 2227	   if (un<1) {

	ld	[%fp+72],%l0
	cmp	%l0,1
	bge	.L3325
	nop

	! block 6
.L3327:
.L3328:
.L3329:
.L3330:

! 2228	      gl_error( ctx, GL_INVALID_VALUE, "glMapGrid1f" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3331),%l1
	or	%l1,%lo(.L3331),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3332:

! 2229	      return;

	ba	.L3308
	nop

	! block 8
.L3333:
.L3334:
.L3325:
.L3335:
.L3336:

! 2230	   }
! 2231	   ctx->Eval.MapGrid1un = un;

	ld	[%fp+72],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	st	%l2,[%l0+%l1]

	! block 9
.L3337:

! 2232	   ctx->Eval.MapGrid1u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	st	%f4,[%l0+%l1]

	! block 10
.L3338:

! 2233	   ctx->Eval.MapGrid1u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	st	%f4,[%l0+%l1]

	! block 11
.L3339:
.L3340:
.L3308:
	jmp	%i7+8
	restore
	.size	gl_MapGrid1f,(.-gl_MapGrid1f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_MapGrid2f
	.type	gl_MapGrid2f,#function
gl_MapGrid2f:
	save	%sp,-96,%sp

	! block 1
.L3343:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]

	! block 2
.L3344:
.L3346:
.L3348:

! File eval.c:
! 2234	}
! 2235	
! 2237	void gl_MapGrid2f( GLcontext* ctx, GLint un, GLfloat u1, GLfloat u2,
! 2238			  GLint vn, GLfloat v1, GLfloat v2 )
! 2239	{
! 2240	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3347
	nop

	! block 3
.L3349:
.L3350:
.L3351:
.L3352:

! 2241	      gl_error( ctx, GL_INVALID_OPERATION, "glMapGrid2f" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3353),%l1
	or	%l1,%lo(.L3353),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3354:

! 2242	      return;

	ba	.L3342
	nop

	! block 5
.L3355:
.L3356:
.L3347:
.L3357:
.L3358:
.L3360:

! 2243	   }
! 2244	   if (un<1) {

	ld	[%fp+72],%l0
	cmp	%l0,1
	bge	.L3359
	nop

	! block 6
.L3361:
.L3362:
.L3363:
.L3364:

! 2245	      gl_error( ctx, GL_INVALID_VALUE, "glMapGrid2f(un)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3365),%l1
	or	%l1,%lo(.L3365),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3366:

! 2246	      return;

	ba	.L3342
	nop

	! block 8
.L3367:
.L3368:
.L3359:
.L3369:
.L3370:
.L3372:

! 2247	   }
! 2248	   if (vn<1) {

	ld	[%fp+84],%l0
	cmp	%l0,1
	bge	.L3371
	nop

	! block 9
.L3373:
.L3374:
.L3375:
.L3376:

! 2249	      gl_error( ctx, GL_INVALID_VALUE, "glMapGrid2f(vn)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3377),%l1
	or	%l1,%lo(.L3377),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 10
.L3378:

! 2250	      return;

	ba	.L3342
	nop

	! block 11
.L3379:
.L3380:
.L3371:
.L3381:
.L3382:

! 2251	   }
! 2252	   ctx->Eval.MapGrid2un = un;

	ld	[%fp+72],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	st	%l2,[%l0+%l1]

	! block 12
.L3383:

! 2253	   ctx->Eval.MapGrid2u1 = u1;

	ld	[%fp+76],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	st	%f4,[%l0+%l1]

	! block 13
.L3384:

! 2254	   ctx->Eval.MapGrid2u2 = u2;

	ld	[%fp+80],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	st	%f4,[%l0+%l1]

	! block 14
.L3385:

! 2255	   ctx->Eval.MapGrid2vn = vn;

	ld	[%fp+84],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	st	%l2,[%l0+%l1]

	! block 15
.L3386:

! 2256	   ctx->Eval.MapGrid2v1 = v1;

	ld	[%fp+88],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	st	%f4,[%l0+%l1]

	! block 16
.L3387:

! 2257	   ctx->Eval.MapGrid2v2 = v2;

	ld	[%fp+92],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	st	%f4,[%l0+%l1]

	! block 17
.L3388:
.L3389:
.L3342:
	jmp	%i7+8
	restore
	.size	gl_MapGrid2f,(.-gl_MapGrid2f)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalPoint1
	.type	gl_EvalPoint1,#function
gl_EvalPoint1:
	save	%sp,-112,%sp

	! block 1
.L3392:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L3393:
.L3395:
.L3397:

! File eval.c:
! 2258	}
! 2259	
! 2261	void gl_EvalPoint1( GLcontext* ctx, GLint i )
! 2262	{
! 2263		GLfloat u, du;
! 2264	
! 2265		if (i==0) {

	ld	[%fp+72],%l0
	cmp	%l0,0
	bne	.L3396
	nop

	! block 3
.L3398:
.L3399:
.L3400:
.L3401:

! 2266			u = ctx->Eval.MapGrid1u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-4]

	! block 4
.L3402:
.L3403:
	ba	.L3404
	nop

	! block 5
.L3396:
.L3405:
.L3406:
.L3408:

! 2267		}
! 2268		else if (i==ctx->Eval.MapGrid1un) {

	ld	[%fp+72],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3407
	nop

	! block 6
.L3409:
.L3410:
.L3411:
.L3412:

! 2269			u = ctx->Eval.MapGrid1u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-4]

	! block 7
.L3413:
.L3414:
	ba	.L3415
	nop

	! block 8
.L3407:
.L3416:
.L3417:
.L3418:

! 2270		}
! 2271		else {
! 2272			du = (ctx->Eval.MapGrid1u2 - ctx->Eval.MapGrid1u1)
! 2273				/ (GLfloat) ctx->Eval.MapGrid1un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-16]
	st	%l1,[%fp-12]
	ldd	[%fp-16],%f6
	mov	0,%l0
	st	%l0,[%fp-12]
	ldd	[%fp-16],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-8]

	! block 9
.L3419:

! 2274			u = i * du + ctx->Eval.MapGrid1u1;

	ld	[%fp+72],%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%f4
	fitos	%f4,%f5
	ld	[%fp-8],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-4]

	! block 10
.L3420:
.L3421:
.L3415:
.L3422:
.L3423:
.L3404:
.L3424:
.L3425:

! 2275		}
! 2276		gl_EvalCoord1f( ctx, u );

	ld	[%fp+68],%l0
	ld	[%fp-4],%f4
	mov	%l0,%o0
	st	%f4,[%sp+72]
	call	gl_EvalCoord1f
	ld	[%sp+72],%o1

	! block 11
.L3426:
.L3427:
.L3391:
	jmp	%i7+8
	restore
	.size	gl_EvalPoint1,(.-gl_EvalPoint1)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalPoint2
	.type	gl_EvalPoint2,#function
gl_EvalPoint2:
	save	%sp,-120,%sp

	! block 1
.L3430:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L3431:
.L3433:
.L3435:

! File eval.c:
! 2277	}
! 2278	
! 2281	void gl_EvalPoint2( GLcontext* ctx, GLint i, GLint j )
! 2282	{
! 2283		GLfloat u, du;
! 2284		GLfloat v, dv;
! 2285	
! 2286		if (i==0) {

	ld	[%fp+72],%l0
	cmp	%l0,0
	bne	.L3434
	nop

	! block 3
.L3436:
.L3437:
.L3438:
.L3439:

! 2287			u = ctx->Eval.MapGrid2u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-4]

	! block 4
.L3440:
.L3441:
	ba	.L3442
	nop

	! block 5
.L3434:
.L3443:
.L3444:
.L3446:

! 2288		}
! 2289		else if (i==ctx->Eval.MapGrid2un) {

	ld	[%fp+72],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3445
	nop

	! block 6
.L3447:
.L3448:
.L3449:
.L3450:

! 2290			u = ctx->Eval.MapGrid2u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-4]

	! block 7
.L3451:
.L3452:
	ba	.L3453
	nop

	! block 8
.L3445:
.L3454:
.L3455:
.L3456:

! 2291		}
! 2292		else {
! 2293			du = (ctx->Eval.MapGrid2u2 - ctx->Eval.MapGrid2u1)
! 2294				/ (GLfloat) ctx->Eval.MapGrid2un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-8]

	! block 9
.L3457:

! 2295			u = i * du + ctx->Eval.MapGrid2u1;

	ld	[%fp+72],%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%f4
	fitos	%f4,%f5
	ld	[%fp-8],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-4]

	! block 10
.L3458:
.L3459:
.L3453:
.L3460:
.L3461:
.L3442:
.L3462:
.L3463:
.L3465:

! 2296		}
! 2297	
! 2298		if (j==0) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bne	.L3464
	nop

	! block 11
.L3466:
.L3467:
.L3468:
.L3469:

! 2299			v = ctx->Eval.MapGrid2v1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 12
.L3470:
.L3471:
	ba	.L3472
	nop

	! block 13
.L3464:
.L3473:
.L3474:
.L3476:

! 2300		}
! 2301		else if (j==ctx->Eval.MapGrid2vn) {

	ld	[%fp+76],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3475
	nop

	! block 14
.L3477:
.L3478:
.L3479:
.L3480:

! 2302			v = ctx->Eval.MapGrid2v2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 15
.L3481:
.L3482:
	ba	.L3483
	nop

	! block 16
.L3475:
.L3484:
.L3485:
.L3486:

! 2303		}
! 2304		else {
! 2305			dv = (ctx->Eval.MapGrid2v2 - ctx->Eval.MapGrid2v1)
! 2306				/ (GLfloat) ctx->Eval.MapGrid2vn;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-16]

	! block 17
.L3487:

! 2307			v = j * dv + ctx->Eval.MapGrid2v1;

	ld	[%fp+76],%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%f4
	fitos	%f4,%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-12]

	! block 18
.L3488:
.L3489:
.L3483:
.L3490:
.L3491:
.L3472:
.L3492:
.L3493:

! 2308		}
! 2309	
! 2310		gl_EvalCoord2f( ctx, u, v );

	ld	[%fp+68],%l0
	ld	[%fp-4],%f4
	ld	[%fp-12],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 19
.L3494:
.L3495:
.L3429:
	jmp	%i7+8
	restore
	.size	gl_EvalPoint2,(.-gl_EvalPoint2)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalMesh1
	.type	gl_EvalMesh1,#function
gl_EvalMesh1:
	save	%sp,-120,%sp

	! block 1
.L3498:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L3499:
.L3501:
.L3503:

! File eval.c:
! 2311	}
! 2312	
! 2315	void gl_EvalMesh1( GLcontext* ctx, GLenum mode, GLint i1, GLint i2 )
! 2316	{
! 2317	   GLint i;
! 2318	   GLfloat u, du;
! 2319	   GLenum prim;
! 2320	
! 2321		if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3502
	nop

	! block 3
.L3504:
.L3505:
.L3506:
.L3507:

! 2322			gl_error( ctx, GL_INVALID_OPERATION, "glEvalMesh1" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3508),%l1
	or	%l1,%lo(.L3508),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3509:

! 2323			return;

	ba	.L3497
	nop

	! block 5
.L3510:
.L3511:
.L3502:
.L3512:
.L3513:
.L3516:

! 2324		}
! 2325	
! 2326		switch (mode) {

	ba	.L3515
	nop

	! block 6
.L3517:
.L3518:
.L3519:
.L3520:

! 2327		case GL_POINT:
! 2328			prim = GL_POINTS;

	st	%g0,[%fp-16]

	! block 7
.L3521:

! 2329			break;

	ba	.L3514
	nop

	! block 8
.L3522:
.L3523:

! 2330		case GL_LINE:
! 2331			prim = GL_LINE_STRIP;

	mov	3,%l0
	st	%l0,[%fp-16]

	! block 9
.L3524:

! 2332			break;

	ba	.L3514
	nop

	! block 10
.L3525:
.L3526:

! 2333		default:
! 2334			gl_error( ctx, GL_INVALID_ENUM, "glEvalMesh1(mode)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3527),%l1
	or	%l1,%lo(.L3527),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3528:

! 2335			return;

	ba	.L3497
	nop

	! block 12
.L3529:
.L3530:
.L3515:
.L3531:
	ld	[%fp+72],%l1
	sethi	%hi(0x1b00),%l0
	or	%l0,%lo(0x1b00),%l0
	cmp	%l1,%l0
	be	.L3519
	nop

	! block 13
	sethi	%hi(0x1b01),%l0
	or	%l0,%lo(0x1b01),%l0
	cmp	%l1,%l0
	be	.L3522
	nop

	! block 14
	ba	.L3525
	nop

	! block 15
.L3532:
.L3514:
.L3533:
.L3534:

! 2336		}
! 2337	
! 2338		du = (ctx->Eval.MapGrid1u2 - ctx->Eval.MapGrid1u1)
! 2339			/ (GLfloat) ctx->Eval.MapGrid1un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-24]
	st	%l1,[%fp-20]
	ldd	[%fp-24],%f6
	mov	0,%l0
	st	%l0,[%fp-20]
	ldd	[%fp-24],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-12]

	! block 16
.L3535:

! 2341		gl_Begin( ctx, prim );

	ld	[%fp+68],%l0
	ld	[%fp-16],%l1
	mov	%l0,%o0
	call	gl_Begin
	mov	%l1,%o1

	! block 17
.L3536:
.L3537:

! 2342		for (i=i1;i<=i2;i++) {

	ld	[%fp+76],%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bg	.L3540
	nop

	! block 18
.L3541:
.L3538:
.L3542:
.L3543:
.L3544:
.L3546:

! 2343			if (i==0) {

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L3545
	nop

	! block 19
.L3547:
.L3548:
.L3549:
.L3550:

! 2344				u = ctx->Eval.MapGrid1u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-8]

	! block 20
.L3551:
.L3552:
	ba	.L3553
	nop

	! block 21
.L3545:
.L3554:
.L3555:
.L3557:

! 2345			}
! 2346			else if (i==ctx->Eval.MapGrid1un) {

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3556
	nop

	! block 22
.L3558:
.L3559:
.L3560:
.L3561:

! 2347				u = ctx->Eval.MapGrid1u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-8]

	! block 23
.L3562:
.L3563:
	ba	.L3564
	nop

	! block 24
.L3556:
.L3565:
.L3566:
.L3567:

! 2348			}
! 2349			else {
! 2350				u = i * du + ctx->Eval.MapGrid1u1;

	ld	[%fp-4],%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%f4
	fitos	%f4,%f5
	ld	[%fp-12],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-8]

	! block 25
.L3568:
.L3569:
.L3564:
.L3570:
.L3571:
.L3553:
.L3572:
.L3573:

! 2351			}
! 2352			gl_EvalCoord1f( ctx, u );

	ld	[%fp+68],%l0
	ld	[%fp-8],%f4
	mov	%l0,%o0
	st	%f4,[%sp+72]
	call	gl_EvalCoord1f
	ld	[%sp+72],%o1

	! block 26
.L3574:
.L3575:
.L3576:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	ble	.L3538
	nop

	! block 27
.L3577:
.L3540:
.L3578:
.L3579:

! 2353		}
! 2354		gl_End(ctx);

	ld	[%fp+68],%l0
	call	gl_End
	mov	%l0,%o0

	! block 28
.L3580:
.L3581:
.L3497:
	jmp	%i7+8
	restore
	.size	gl_EvalMesh1,(.-gl_EvalMesh1)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_EvalMesh2
	.type	gl_EvalMesh2,#function
gl_EvalMesh2:
	save	%sp,-136,%sp

	! block 1
.L3584:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L3585:
.L3587:
.L3589:

! File eval.c:
! 2355	}
! 2356	
! 2359	void gl_EvalMesh2( GLcontext* ctx, GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 )
! 2360	{
! 2361		GLint i, j;
! 2362		GLfloat u, du, v, dv, v1, v2;
! 2363	
! 2364		if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3588
	nop

	! block 3
.L3590:
.L3591:
.L3592:
.L3593:

! 2365			gl_error( ctx, GL_INVALID_OPERATION, "glEvalMesh2" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3594),%l1
	or	%l1,%lo(.L3594),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3595:

! 2366			return;

	ba	.L3583
	nop

	! block 5
.L3596:
.L3597:
.L3588:
.L3598:
.L3599:

! 2367		}
! 2368	
! 2369		du = (ctx->Eval.MapGrid2u2 - ctx->Eval.MapGrid2u1)
! 2370			/ (GLfloat) ctx->Eval.MapGrid2un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-40]
	st	%l1,[%fp-36]
	ldd	[%fp-40],%f6
	mov	0,%l0
	st	%l0,[%fp-36]
	ldd	[%fp-40],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-16]

	! block 6
.L3600:

! 2371		dv = (ctx->Eval.MapGrid2v2 - ctx->Eval.MapGrid2v1)
! 2372			/ (GLfloat) ctx->Eval.MapGrid2vn;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fsubs	%f5,%f4,%f8
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-40]
	st	%l1,[%fp-36]
	ldd	[%fp-40],%f6
	mov	0,%l0
	st	%l0,[%fp-36]
	ldd	[%fp-40],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	fdivs	%f8,%f4,%f4
	st	%f4,[%fp-24]

	! block 7
.L3601:
.L3604:

! 2374	#define I_TO_U( I, U )				\
! 2375		if ((I)==0) {		       	\
! 2376			U = ctx->Eval.MapGrid2u1;		\
! 2377		}					\
! 2378		else if ((I)==ctx->Eval.MapGrid2un) {	\
! 2379			U = ctx->Eval.MapGrid2u2;		\
! 2380		}					\
! 2381		else {				\
! 2382			U = (I) * du + ctx->Eval.MapGrid2u1;\
! 2383		}
! 2384	
! 2385	#define J_TO_V( J, V )				\
! 2386		if ((J)==0) {			\
! 2387			V = ctx->Eval.MapGrid2v1;		\
! 2388		}					\
! 2389		else if ((J)==ctx->Eval.MapGrid2vn) {	\
! 2390			V = ctx->Eval.MapGrid2v2;		\
! 2391		}					\
! 2392		else {				\
! 2393			V = (J) * dv + ctx->Eval.MapGrid2v1;\
! 2394		}
! 2395	
! 2396		switch (mode) {

	ba	.L3603
	nop

	! block 8
.L3605:
.L3606:
.L3607:
.L3608:

! 2397		case GL_POINT:
! 2398			gl_Begin( ctx, GL_POINTS );

	ld	[%fp+68],%l0
	mov	%l0,%o0
	call	gl_Begin
	mov	%g0,%o1

	! block 9
.L3609:
.L3610:

! 2399			for (j=j1;j<=j2;j++) {

	ld	[%fp+84],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bg	.L3613
	nop

	! block 10
.L3614:
.L3611:
.L3615:
.L3616:
.L3617:
.L3619:

! 2400				J_TO_V( j, v );

	ld	[%fp-8],%l0
	cmp	%l0,0
	bne	.L3618
	nop

	! block 11
.L3620:
.L3621:
.L3622:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 12
.L3623:
.L3624:
	ba	.L3625
	nop

	! block 13
.L3618:
.L3626:
.L3627:
	ld	[%fp-8],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3628
	nop

	! block 14
.L3629:
.L3630:
.L3631:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 15
.L3632:
.L3633:
	ba	.L3634
	nop

	! block 16
.L3628:
.L3635:
.L3636:
	ld	[%fp-8],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-20]

	! block 17
.L3637:
.L3638:
.L3634:
.L3639:
.L3640:
.L3625:
.L3641:
.L3642:
.L3643:

! 2401				for (i=i1;i<=i2;i++) {

	ld	[%fp+76],%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bg	.L3646
	nop

	! block 18
.L3647:
.L3644:
.L3648:
.L3649:
.L3650:
.L3652:

! 2402					I_TO_U( i, u );

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L3651
	nop

	! block 19
.L3653:
.L3654:
.L3655:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 20
.L3656:
.L3657:
	ba	.L3658
	nop

	! block 21
.L3651:
.L3659:
.L3660:
	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3661
	nop

	! block 22
.L3662:
.L3663:
.L3664:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 23
.L3665:
.L3666:
	ba	.L3667
	nop

	! block 24
.L3661:
.L3668:
.L3669:
	ld	[%fp-4],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-12]

	! block 25
.L3670:
.L3671:
.L3667:
.L3672:
.L3673:
.L3658:
.L3674:
.L3675:

! 2403					gl_EvalCoord2f( ctx, u, v );

	ld	[%fp+68],%l0
	ld	[%fp-12],%f4
	ld	[%fp-20],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 26
.L3676:
.L3677:
.L3678:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	ble	.L3644
	nop

	! block 27
.L3679:
.L3646:
.L3680:
.L3681:
.L3682:
.L3683:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	ble	.L3611
	nop

	! block 28
.L3684:
.L3613:
.L3685:
.L3686:

! 2404				}
! 2405			}
! 2406			gl_End(ctx);

	ld	[%fp+68],%l0
	call	gl_End
	mov	%l0,%o0

	! block 29
.L3687:

! 2407			break;

	ba	.L3602
	nop

	! block 30
.L3688:
.L3689:
.L3690:

! 2408		case GL_LINE:
! 2409			for (j=j1;j<=j2;j++) {

	ld	[%fp+84],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bg	.L3693
	nop

	! block 31
.L3694:
.L3691:
.L3695:
.L3696:
.L3697:
.L3699:

! 2410				J_TO_V( j, v );

	ld	[%fp-8],%l0
	cmp	%l0,0
	bne	.L3698
	nop

	! block 32
.L3700:
.L3701:
.L3702:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 33
.L3703:
.L3704:
	ba	.L3705
	nop

	! block 34
.L3698:
.L3706:
.L3707:
	ld	[%fp-8],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3708
	nop

	! block 35
.L3709:
.L3710:
.L3711:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 36
.L3712:
.L3713:
	ba	.L3714
	nop

	! block 37
.L3708:
.L3715:
.L3716:
	ld	[%fp-8],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-20]

	! block 38
.L3717:
.L3718:
.L3714:
.L3719:
.L3720:
.L3705:
.L3721:
.L3722:

! 2411				gl_Begin( ctx, GL_LINE_STRIP );

	ld	[%fp+68],%l0
	mov	%l0,%o0
	call	gl_Begin
	mov	3,%o1

	! block 39
.L3723:
.L3724:

! 2412				for (i=i1;i<=i2;i++) {

	ld	[%fp+76],%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bg	.L3727
	nop

	! block 40
.L3728:
.L3725:
.L3729:
.L3730:
.L3731:
.L3733:

! 2413					I_TO_U( i, u );

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L3732
	nop

	! block 41
.L3734:
.L3735:
.L3736:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 42
.L3737:
.L3738:
	ba	.L3739
	nop

	! block 43
.L3732:
.L3740:
.L3741:
	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3742
	nop

	! block 44
.L3743:
.L3744:
.L3745:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 45
.L3746:
.L3747:
	ba	.L3748
	nop

	! block 46
.L3742:
.L3749:
.L3750:
	ld	[%fp-4],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-12]

	! block 47
.L3751:
.L3752:
.L3748:
.L3753:
.L3754:
.L3739:
.L3755:
.L3756:

! 2414					gl_EvalCoord2f( ctx, u, v );

	ld	[%fp+68],%l0
	ld	[%fp-12],%f4
	ld	[%fp-20],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 48
.L3757:
.L3758:
.L3759:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	ble	.L3725
	nop

	! block 49
.L3760:
.L3727:
.L3761:
.L3762:

! 2415				}
! 2416				gl_End(ctx);

	ld	[%fp+68],%l0
	call	gl_End
	mov	%l0,%o0

	! block 50
.L3763:
.L3764:
.L3765:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	ble	.L3691
	nop

	! block 51
.L3766:
.L3693:
.L3767:
.L3768:
.L3769:

! 2417			}
! 2418			for (i=i1;i<=i2;i++) {

	ld	[%fp+76],%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bg	.L3772
	nop

	! block 52
.L3773:
.L3770:
.L3774:
.L3775:
.L3776:
.L3778:

! 2419				I_TO_U( i, u );

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L3777
	nop

	! block 53
.L3779:
.L3780:
.L3781:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 54
.L3782:
.L3783:
	ba	.L3784
	nop

	! block 55
.L3777:
.L3785:
.L3786:
	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3787
	nop

	! block 56
.L3788:
.L3789:
.L3790:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 57
.L3791:
.L3792:
	ba	.L3793
	nop

	! block 58
.L3787:
.L3794:
.L3795:
	ld	[%fp-4],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-12]

	! block 59
.L3796:
.L3797:
.L3793:
.L3798:
.L3799:
.L3784:
.L3800:
.L3801:

! 2420				gl_Begin( ctx, GL_LINE_STRIP );

	ld	[%fp+68],%l0
	mov	%l0,%o0
	call	gl_Begin
	mov	3,%o1

	! block 60
.L3802:
.L3803:

! 2421				for (j=j1;j<=j2;j++) {

	ld	[%fp+84],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bg	.L3806
	nop

	! block 61
.L3807:
.L3804:
.L3808:
.L3809:
.L3810:
.L3812:

! 2422					J_TO_V( j, v );

	ld	[%fp-8],%l0
	cmp	%l0,0
	bne	.L3811
	nop

	! block 62
.L3813:
.L3814:
.L3815:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 63
.L3816:
.L3817:
	ba	.L3818
	nop

	! block 64
.L3811:
.L3819:
.L3820:
	ld	[%fp-8],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3821
	nop

	! block 65
.L3822:
.L3823:
.L3824:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 66
.L3825:
.L3826:
	ba	.L3827
	nop

	! block 67
.L3821:
.L3828:
.L3829:
	ld	[%fp-8],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-20]

	! block 68
.L3830:
.L3831:
.L3827:
.L3832:
.L3833:
.L3818:
.L3834:
.L3835:

! 2423					gl_EvalCoord2f( ctx, u, v );

	ld	[%fp+68],%l0
	ld	[%fp-12],%f4
	ld	[%fp-20],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 69
.L3836:
.L3837:
.L3838:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	ble	.L3804
	nop

	! block 70
.L3839:
.L3806:
.L3840:
.L3841:

! 2424				}
! 2425				gl_End(ctx);

	ld	[%fp+68],%l0
	call	gl_End
	mov	%l0,%o0

	! block 71
.L3842:
.L3843:
.L3844:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	ble	.L3770
	nop

	! block 72
.L3845:
.L3772:
.L3846:
.L3847:

! 2426			}
! 2427			break;

	ba	.L3602
	nop

	! block 73
.L3848:
.L3849:
.L3850:

! 2428		case GL_FILL:
! 2429			for (j=j1;j<j2;j++) {

	ld	[%fp+84],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bge	.L3853
	nop

	! block 74
.L3854:
.L3851:
.L3855:
.L3856:
.L3857:

! 2430				/* NOTE: a quad strip can't be used because the four */
! 2431				/* can't be guaranteed to be coplanar! */
! 2432				gl_Begin( ctx, GL_TRIANGLE_STRIP );

	ld	[%fp+68],%l0
	mov	%l0,%o0
	call	gl_Begin
	mov	5,%o1

	! block 75
.L3858:
.L3860:

! 2433				J_TO_V( j, v1 );

	ld	[%fp-8],%l0
	cmp	%l0,0
	bne	.L3859
	nop

	! block 76
.L3861:
.L3862:
.L3863:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-28]

	! block 77
.L3864:
.L3865:
	ba	.L3866
	nop

	! block 78
.L3859:
.L3867:
.L3868:
	ld	[%fp-8],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3869
	nop

	! block 79
.L3870:
.L3871:
.L3872:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-28]

	! block 80
.L3873:
.L3874:
	ba	.L3875
	nop

	! block 81
.L3869:
.L3876:
.L3877:
	ld	[%fp-8],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-28]

	! block 82
.L3878:
.L3879:
.L3875:
.L3880:
.L3881:
.L3866:
.L3882:
.L3883:
.L3885:

! 2434				J_TO_V( j+1, v2 );

	ld	[%fp-8],%l0
	add	%l0,1,%l0
	cmp	%l0,0
	bne	.L3884
	nop

	! block 83
.L3886:
.L3887:
.L3888:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-32]

	! block 84
.L3889:
.L3890:
	ba	.L3891
	nop

	! block 85
.L3884:
.L3892:
.L3893:
	ld	[%fp-8],%l0
	add	%l0,1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3894
	nop

	! block 86
.L3895:
.L3896:
.L3897:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-32]

	! block 87
.L3898:
.L3899:
	ba	.L3900
	nop

	! block 88
.L3894:
.L3901:
.L3902:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-24],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-32]

	! block 89
.L3903:
.L3904:
.L3900:
.L3905:
.L3906:
.L3891:
.L3907:
.L3908:
.L3909:

! 2435				for (i=i1;i<=i2;i++) {

	ld	[%fp+76],%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bg	.L3912
	nop

	! block 90
.L3913:
.L3910:
.L3914:
.L3915:
.L3916:
.L3918:

! 2436					I_TO_U( i, u );

	ld	[%fp-4],%l0
	cmp	%l0,0
	bne	.L3917
	nop

	! block 91
.L3919:
.L3920:
.L3921:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 92
.L3922:
.L3923:
	ba	.L3924
	nop

	! block 93
.L3917:
.L3925:
.L3926:
	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bne	.L3927
	nop

	! block 94
.L3928:
.L3929:
.L3930:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 95
.L3931:
.L3932:
	ba	.L3933
	nop

	! block 96
.L3927:
.L3934:
.L3935:
	ld	[%fp-4],%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%f4
	fitos	%f4,%f5
	ld	[%fp-16],%f4
	fmuls	%f5,%f4,%f5
	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-12]

	! block 97
.L3936:
.L3937:
.L3933:
.L3938:
.L3939:
.L3924:
.L3940:
.L3941:

! 2437					gl_EvalCoord2f( ctx, u, v1 );

	ld	[%fp+68],%l0
	ld	[%fp-12],%f4
	ld	[%fp-28],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 98
.L3942:

! 2438					gl_EvalCoord2f( ctx, u, v2 );

	ld	[%fp+68],%l0
	ld	[%fp-12],%f4
	ld	[%fp-32],%f5
	mov	%l0,%o0
	st	%f4,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	call	gl_EvalCoord2f
	ld	[%sp+76],%o2

	! block 99
.L3943:
.L3944:
.L3945:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	ble	.L3910
	nop

	! block 100
.L3946:
.L3912:
.L3947:
.L3948:

! 2439				}
! 2440				gl_End(ctx);

	ld	[%fp+68],%l0
	call	gl_End
	mov	%l0,%o0

	! block 101
.L3949:
.L3950:
.L3951:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+88],%l0
	cmp	%l1,%l0
	bl	.L3851
	nop

	! block 102
.L3952:
.L3853:
.L3953:
.L3954:

! 2441			}
! 2442			break;

	ba	.L3602
	nop

	! block 103
.L3955:
.L3956:

! 2443		default:
! 2444			gl_error( ctx, GL_INVALID_ENUM, "glEvalMesh2(mode)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3957),%l1
	or	%l1,%lo(.L3957),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 104
.L3958:

! 2445			return;

	ba	.L3583
	nop

	! block 105
.L3959:
.L3960:
.L3603:
.L3961:
	ld	[%fp+72],%l0
	sethi	%hi(0x1b00),%l1
	or	%l1,%lo(0x1b00),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,2
	bgu	.L3955
	nop

	! block 106
	sll	%l0,2,%l1
	sethi	%hi(.L_y38-12),%l0
	or	%l0,%lo(.L_y38-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 107
.L3962:
.L3602:
.L3963:

	! block 108
.L3964:
.L3965:
.L3583:
	jmp	%i7+8
	restore
	.size	gl_EvalMesh2,(.-gl_EvalMesh2)

	.word	.L3607
	.word	.L3688
	.word	.L3848
.L_y38:
	.align	8

	.section	".data",#alloc,#write
	.align	4
Ddata.data:
	.global	$XBa59JCRsd3LWyK.gl_init_eval.init_flag
$XBa59JCRsd3LWyK.gl_init_eval.init_flag:
	.skip	4
	.type	$XBa59JCRsd3LWyK.gl_init_eval.init_flag,#object
	.size	$XBa59JCRsd3LWyK.gl_init_eval.init_flag,4

	.section	".rodata",#alloc
	.align	8
Drodata.rodata:
.L_cseg0:
	.word	0x3ff00000,0x0
	.type	.L_cseg0,#object
	.size	.L_cseg0,8

	.section	".rodata1",#alloc
	.align	4
.L1147:
	.ascii	"gl_free_control_points\000"
	.skip	1
	.type	.L1147,#object
	.size	.L1147,24
	.align	4
.L1218:
	.ascii	"glMap1f\000"
	.type	.L1218,#object
	.size	.L1218,8
	.align	4
.L1231:
	.ascii	"glMap1\000"
	.skip	1
	.type	.L1231,#object
	.size	.L1231,8
	.align	4
.L1243:
	.ascii	"glMap1(u1,u2)\000"
	.skip	2
	.type	.L1243,#object
	.size	.L1243,16
	.align	4
.L1257:
	.ascii	"glMap1(order)\000"
	.skip	2
	.type	.L1257,#object
	.size	.L1257,16
	.align	4
.L1270:
	.ascii	"glMap1(target)\000"
	.skip	1
	.type	.L1270,#object
	.size	.L1270,16
	.align	4
.L1281:
	.ascii	"glMap1(stride)\000"
	.skip	1
	.type	.L1281,#object
	.size	.L1281,16
	.align	4
.L1456:
	.ascii	"glMap1(target)\000"
	.skip	1
	.type	.L1456,#object
	.size	.L1456,16
	.align	4
.L1476:
	.ascii	"glMap2\000"
	.skip	1
	.type	.L1476,#object
	.size	.L1476,8
	.align	4
.L1488:
	.ascii	"glMap2(u1,u2)\000"
	.skip	2
	.type	.L1488,#object
	.size	.L1488,16
	.align	4
.L1500:
	.ascii	"glMap2(v1,v2)\000"
	.skip	2
	.type	.L1500,#object
	.size	.L1500,16
	.align	4
.L1514:
	.ascii	"glMap2(uorder)\000"
	.skip	1
	.type	.L1514,#object
	.size	.L1514,16
	.align	4
.L1528:
	.ascii	"glMap2(vorder)\000"
	.skip	1
	.type	.L1528,#object
	.size	.L1528,16
	.align	4
.L1541:
	.ascii	"glMap2(target)\000"
	.skip	1
	.type	.L1541,#object
	.size	.L1541,16
	.align	4
.L1552:
	.ascii	"glMap2(ustride)\000"
	.type	.L1552,#object
	.size	.L1552,16
	.align	4
.L1564:
	.ascii	"glMap2(vstride)\000"
	.type	.L1564,#object
	.size	.L1564,16
	.align	4
.L1766:
	.ascii	"glMap2(target)\000"
	.skip	1
	.type	.L1766,#object
	.size	.L1766,16
	.align	4
.L1866:
	.ascii	"glGetMapdv(target)\000"
	.skip	1
	.type	.L1866,#object
	.size	.L1866,20
	.align	4
.L1968:
	.ascii	"glGetMapdv(target)\000"
	.skip	1
	.type	.L1968,#object
	.size	.L1968,20
	.align	4
.L2074:
	.ascii	"glGetMapdv(target)\000"
	.skip	1
	.type	.L2074,#object
	.size	.L2074,20
	.align	4
.L2083:
	.ascii	"glGetMapdv(query)\000"
	.skip	2
	.type	.L2083,#object
	.size	.L2083,20
	.align	4
.L2183:
	.ascii	"glGetMapfv(target)\000"
	.skip	1
	.type	.L2183,#object
	.size	.L2183,20
	.align	4
.L2285:
	.ascii	"glGetMapfv(target)\000"
	.skip	1
	.type	.L2285,#object
	.size	.L2285,20
	.align	4
.L2391:
	.ascii	"glGetMapfv(target)\000"
	.skip	1
	.type	.L2391,#object
	.size	.L2391,20
	.align	4
.L2400:
	.ascii	"glGetMapfv(query)\000"
	.skip	2
	.type	.L2400,#object
	.size	.L2400,20
	.align	4
.L2500:
	.ascii	"glGetMapiv(target)\000"
	.skip	1
	.type	.L2500,#object
	.size	.L2500,20
	.align	4
.L2605:
	.ascii	"glGetMapiv(target)\000"
	.skip	1
	.type	.L2605,#object
	.size	.L2605,20
	.align	4
.L2873:
	.ascii	"glGetMapiv(target)\000"
	.skip	1
	.type	.L2873,#object
	.size	.L2873,20
	.align	4
.L2882:
	.ascii	"glGetMapiv(query)\000"
	.skip	2
	.type	.L2882,#object
	.size	.L2882,20

	.section	".rodata",#alloc
	.align	4
.L_cseg1:
	.skip	4
	.type	.L_cseg1,#object
	.size	.L_cseg1,4
	.align	4
.L_cseg2:
	.word	0xbf000000
	.type	.L_cseg2,#object
	.size	.L_cseg2,4
	.align	4
.L_cseg3:
	.word	0x3f000000
	.type	.L_cseg3,#object
	.size	.L_cseg3,4
	.align	8
.L_cseg4:
	.skip	8
	.type	.L_cseg4,#object
	.size	.L_cseg4,8
	.align	4
.L_cseg5:
	.word	0x38d1b717
	.type	.L_cseg5,#object
	.size	.L_cseg5,4
	.align	4
.L_cseg6:
	.word	0x3f800000
	.type	.L_cseg6,#object
	.size	.L_cseg6,4

	.section	".rodata1",#alloc
	.align	4
.L3319:
	.ascii	"glMapGrid1f\000"
	.type	.L3319,#object
	.size	.L3319,12
	.align	4
.L3331:
	.ascii	"glMapGrid1f\000"
	.type	.L3331,#object
	.size	.L3331,12
	.align	4
.L3353:
	.ascii	"glMapGrid2f\000"
	.type	.L3353,#object
	.size	.L3353,12
	.align	4
.L3365:
	.ascii	"glMapGrid2f(un)\000"
	.type	.L3365,#object
	.size	.L3365,16
	.align	4
.L3377:
	.ascii	"glMapGrid2f(vn)\000"
	.type	.L3377,#object
	.size	.L3377,16
	.align	4
.L3508:
	.ascii	"glEvalMesh1\000"
	.type	.L3508,#object
	.size	.L3508,12
	.align	4
.L3527:
	.ascii	"glEvalMesh1(mode)\000"
	.skip	2
	.type	.L3527,#object
	.size	.L3527,20
	.align	4
.L3594:
	.ascii	"glEvalMesh2\000"
	.type	.L3594,#object
	.size	.L3594,12
	.align	4
.L3957:
	.ascii	"glEvalMesh2(mode)\000"
	.type	.L3957,#object
	.size	.L3957,18
	.section	".bss",#alloc,#write
Bbss.bss:

	.file	"eval.c"
	.ident	"@(#)math.h	2.24	04/10/23 SMI"
	.ident	"@(#)math_iso.h	1.9	04/10/23 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)math_c99.h	1.9	04/11/01 SMI"
	.ident	"@(#)floatingpoint.h	2.9	04/10/23 SMI"
	.ident	"@(#)stdio_tag.h	1.4	04/09/28 SMI"
	.ident	"@(#)ieeefp.h	2.12	04/10/23 SMI"
	.ident	"@(#)stdlib.h	1.51	04/06/30 SMI"
	.ident	"@(#)stdlib_iso.h	1.9	04/09/28 SMI"
	.ident	"@(#)stdlib_c99.h	1.2	04/03/29 SMI"
	.ident	"@(#)string.h	1.27	07/01/14 SMI"
	.ident	"@(#)string_iso.h	1.5	04/06/18 SMI"
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
!   reloc[1]: knd=2, off=251, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=273, siz=4, lab1=gl_init_eval, lab2=, loff=0
!   reloc[3]: knd=0, off=277, siz=4, lab1=.L28, lab2=, loff=0
!   reloc[4]: knd=0, off=309, siz=4, lab1=$XBa59JCRsd3LWyK.gl_init_eval.init_flag, lab2=, loff=0
!   reloc[5]: knd=0, off=345, siz=4, lab1=horner_bezier_curve, lab2=, loff=0
!   reloc[6]: knd=0, off=349, siz=4, lab1=.L102, lab2=, loff=0
!   reloc[7]: knd=0, off=589, siz=4, lab1=horner_bezier_surf, lab2=, loff=0
!   reloc[8]: knd=0, off=593, siz=4, lab1=.L223, lab2=, loff=0
!   reloc[9]: knd=0, off=755, siz=4, lab1=.L110, lab2=, loff=0
!   reloc[10]: knd=0, off=759, siz=4, lab1=.L221, lab2=, loff=0
!   reloc[11]: knd=0, off=764, siz=4, lab1=.L114, lab2=, loff=0
!   reloc[12]: knd=0, off=768, siz=4, lab1=.L187, lab2=, loff=0
!   reloc[13]: knd=0, off=773, siz=4, lab1=.L115, lab2=, loff=0
!   reloc[14]: knd=0, off=777, siz=4, lab1=.L186, lab2=, loff=0
!   reloc[15]: knd=0, off=782, siz=4, lab1=.L116, lab2=, loff=0
!   reloc[16]: knd=0, off=786, siz=4, lab1=.L185, lab2=, loff=0
!   reloc[17]: knd=0, off=791, siz=4, lab1=.L120, lab2=, loff=0
!   reloc[18]: knd=0, off=795, siz=4, lab1=.L180, lab2=, loff=0
!   reloc[19]: knd=0, off=800, siz=4, lab1=.L121, lab2=, loff=0
!   reloc[20]: knd=0, off=804, siz=4, lab1=.L179, lab2=, loff=0
!   reloc[21]: knd=0, off=886, siz=4, lab1=.L122, lab2=, loff=0
!   reloc[22]: knd=0, off=890, siz=4, lab1=.L177, lab2=, loff=0
!   reloc[23]: knd=0, off=895, siz=4, lab1=.L128, lab2=, loff=0
!   reloc[24]: knd=0, off=899, siz=4, lab1=.L174, lab2=, loff=0
!   reloc[25]: knd=0, off=904, siz=4, lab1=.L129, lab2=, loff=0
!   reloc[26]: knd=0, off=908, siz=4, lab1=.L173, lab2=, loff=0
!   reloc[27]: knd=0, off=936, siz=4, lab1=.L189, lab2=, loff=0
!   reloc[28]: knd=0, off=940, siz=4, lab1=.L220, lab2=, loff=0
!   reloc[29]: knd=0, off=945, siz=4, lab1=.L190, lab2=, loff=0
!   reloc[30]: knd=0, off=949, siz=4, lab1=.L219, lab2=, loff=0
!   reloc[31]: knd=0, off=954, siz=4, lab1=.L191, lab2=, loff=0
!   reloc[32]: knd=0, off=958, siz=4, lab1=.L218, lab2=, loff=0
!   reloc[33]: knd=0, off=963, siz=4, lab1=.L195, lab2=, loff=0
!   reloc[34]: knd=0, off=967, siz=4, lab1=.L213, lab2=, loff=0
!   reloc[35]: knd=0, off=972, siz=4, lab1=.L196, lab2=, loff=0
!   reloc[36]: knd=0, off=976, siz=4, lab1=.L212, lab2=, loff=0
!   reloc[37]: knd=0, off=1023, siz=4, lab1=de_casteljau_surf, lab2=, loff=0
!   reloc[38]: knd=0, off=1027, siz=4, lab1=.L785, lab2=, loff=0
!   reloc[39]: knd=0, off=1354, siz=4, lab1=components, lab2=, loff=0
!   reloc[40]: knd=0, off=1358, siz=4, lab1=.L841, lab2=, loff=0
!   reloc[41]: knd=0, off=13634, siz=4, lab1=gl_copy_map_points1f, lab2=, loff=0
!   reloc[42]: knd=0, off=13638, siz=4, lab1=.L893, lab2=, loff=0
!   reloc[43]: knd=0, off=13847, siz=4, lab1=gl_copy_map_points1d, lab2=, loff=0
!   reloc[44]: knd=0, off=13851, siz=4, lab1=.L933, lab2=, loff=0
!   reloc[45]: knd=0, off=14085, siz=4, lab1=gl_copy_map_points2f, lab2=, loff=0
!   reloc[46]: knd=0, off=14089, siz=4, lab1=.L1005, lab2=, loff=0
!   reloc[47]: knd=0, off=14404, siz=4, lab1=gl_copy_map_points2d, lab2=, loff=0
!   reloc[48]: knd=0, off=14408, siz=4, lab1=.L1077, lab2=, loff=0
!   reloc[49]: knd=0, off=14725, siz=4, lab1=gl_free_control_points, lab2=, loff=0
!   reloc[50]: knd=0, off=14729, siz=4, lab1=.L1205, lab2=, loff=0
!   reloc[51]: knd=0, off=40330, siz=4, lab1=gl_Map1f, lab2=, loff=0
!   reloc[52]: knd=0, off=40334, siz=4, lab1=.L1463, lab2=, loff=0
!   reloc[53]: knd=0, off=40526, siz=4, lab1=gl_Map2f, lab2=, loff=0
!   reloc[54]: knd=0, off=40530, siz=4, lab1=.L1773, lab2=, loff=0
!   reloc[55]: knd=0, off=40796, siz=4, lab1=gl_GetMapdv, lab2=, loff=0
!   reloc[56]: knd=0, off=40800, siz=4, lab1=.L2090, lab2=, loff=0
!   reloc[57]: knd=0, off=40948, siz=4, lab1=gl_GetMapfv, lab2=, loff=0
!   reloc[58]: knd=0, off=40952, siz=4, lab1=.L2407, lab2=, loff=0
!   reloc[59]: knd=0, off=41095, siz=4, lab1=gl_GetMapiv, lab2=, loff=0
!   reloc[60]: knd=0, off=41099, siz=4, lab1=.L2889, lab2=, loff=0
!   reloc[61]: knd=0, off=41250, siz=4, lab1=gl_EvalCoord1f, lab2=, loff=0
!   reloc[62]: knd=0, off=41254, siz=4, lab1=.L3060, lab2=, loff=0
!   reloc[63]: knd=0, off=41451, siz=4, lab1=.L2895, lab2=, loff=0
!   reloc[64]: knd=0, off=41455, siz=4, lab1=.L2922, lab2=, loff=0
!   reloc[65]: knd=0, off=41460, siz=4, lab1=.L2899, lab2=, loff=0
!   reloc[66]: knd=0, off=41464, siz=4, lab1=.L2905, lab2=, loff=0
!   reloc[67]: knd=0, off=41469, siz=4, lab1=.L2900, lab2=, loff=0
!   reloc[68]: knd=0, off=41473, siz=4, lab1=.L2904, lab2=, loff=0
!   reloc[69]: knd=0, off=41497, siz=4, lab1=.L2907, lab2=, loff=0
!   reloc[70]: knd=0, off=41501, siz=4, lab1=.L2921, lab2=, loff=0
!   reloc[71]: knd=0, off=41506, siz=4, lab1=.L2908, lab2=, loff=0
!   reloc[72]: knd=0, off=41510, siz=4, lab1=.L2920, lab2=, loff=0
!   reloc[73]: knd=0, off=41515, siz=4, lab1=.L2912, lab2=, loff=0
!   reloc[74]: knd=0, off=41519, siz=4, lab1=.L2919, lab2=, loff=0
!   reloc[75]: knd=0, off=41524, siz=4, lab1=.L2913, lab2=, loff=0
!   reloc[76]: knd=0, off=41528, siz=4, lab1=.L2918, lab2=, loff=0
!   reloc[77]: knd=0, off=41555, siz=4, lab1=.L2923, lab2=, loff=0
!   reloc[78]: knd=0, off=41559, siz=4, lab1=.L2941, lab2=, loff=0
!   reloc[79]: knd=0, off=41564, siz=4, lab1=.L2927, lab2=, loff=0
!   reloc[80]: knd=0, off=41568, siz=4, lab1=.L2934, lab2=, loff=0
!   reloc[81]: knd=0, off=41573, siz=4, lab1=.L2928, lab2=, loff=0
!   reloc[82]: knd=0, off=41577, siz=4, lab1=.L2933, lab2=, loff=0
!   reloc[83]: knd=0, off=41622, siz=4, lab1=.L2942, lab2=, loff=0
!   reloc[84]: knd=0, off=41626, siz=4, lab1=.L2965, lab2=, loff=0
!   reloc[85]: knd=0, off=41631, siz=4, lab1=.L2946, lab2=, loff=0
!   reloc[86]: knd=0, off=41635, siz=4, lab1=.L2957, lab2=, loff=0
!   reloc[87]: knd=0, off=41640, siz=4, lab1=.L2947, lab2=, loff=0
!   reloc[88]: knd=0, off=41644, siz=4, lab1=.L2956, lab2=, loff=0
!   reloc[89]: knd=0, off=41668, siz=4, lab1=.L2959, lab2=, loff=0
!   reloc[90]: knd=0, off=41672, siz=4, lab1=.L2964, lab2=, loff=0
!   reloc[91]: knd=0, off=41677, siz=4, lab1=.L2960, lab2=, loff=0
!   reloc[92]: knd=0, off=41681, siz=4, lab1=.L2963, lab2=, loff=0
!   reloc[93]: knd=0, off=41706, siz=4, lab1=.L2966, lab2=, loff=0
!   reloc[94]: knd=0, off=41710, siz=4, lab1=.L2985, lab2=, loff=0
!   reloc[95]: knd=0, off=41715, siz=4, lab1=.L2970, lab2=, loff=0
!   reloc[96]: knd=0, off=41719, siz=4, lab1=.L2976, lab2=, loff=0
!   reloc[97]: knd=0, off=41724, siz=4, lab1=.L2971, lab2=, loff=0
!   reloc[98]: knd=0, off=41728, siz=4, lab1=.L2975, lab2=, loff=0
!   reloc[99]: knd=0, off=41753, siz=4, lab1=.L2986, lab2=, loff=0
!   reloc[100]: knd=0, off=41757, siz=4, lab1=.L3057, lab2=, loff=0
!   reloc[101]: knd=0, off=41762, siz=4, lab1=.L2990, lab2=, loff=0
!   reloc[102]: knd=0, off=41766, siz=4, lab1=.L2996, lab2=, loff=0
!   reloc[103]: knd=0, off=41771, siz=4, lab1=.L2991, lab2=, loff=0
!   reloc[104]: knd=0, off=41775, siz=4, lab1=.L2995, lab2=, loff=0
!   reloc[105]: knd=0, off=41799, siz=4, lab1=.L2998, lab2=, loff=0
!   reloc[106]: knd=0, off=41803, siz=4, lab1=.L3056, lab2=, loff=0
!   reloc[107]: knd=0, off=41808, siz=4, lab1=.L2999, lab2=, loff=0
!   reloc[108]: knd=0, off=41812, siz=4, lab1=.L3055, lab2=, loff=0
!   reloc[109]: knd=0, off=41817, siz=4, lab1=.L3003, lab2=, loff=0
!   reloc[110]: knd=0, off=41821, siz=4, lab1=.L3010, lab2=, loff=0
!   reloc[111]: knd=0, off=41826, siz=4, lab1=.L3004, lab2=, loff=0
!   reloc[112]: knd=0, off=41830, siz=4, lab1=.L3009, lab2=, loff=0
!   reloc[113]: knd=0, off=41854, siz=4, lab1=.L3012, lab2=, loff=0
!   reloc[114]: knd=0, off=41858, siz=4, lab1=.L3054, lab2=, loff=0
!   reloc[115]: knd=0, off=41863, siz=4, lab1=.L3013, lab2=, loff=0
!   reloc[116]: knd=0, off=41867, siz=4, lab1=.L3053, lab2=, loff=0
!   reloc[117]: knd=0, off=41872, siz=4, lab1=.L3017, lab2=, loff=0
!   reloc[118]: knd=0, off=41876, siz=4, lab1=.L3025, lab2=, loff=0
!   reloc[119]: knd=0, off=41881, siz=4, lab1=.L3018, lab2=, loff=0
!   reloc[120]: knd=0, off=41885, siz=4, lab1=.L3024, lab2=, loff=0
!   reloc[121]: knd=0, off=41909, siz=4, lab1=.L3027, lab2=, loff=0
!   reloc[122]: knd=0, off=41913, siz=4, lab1=.L3052, lab2=, loff=0
!   reloc[123]: knd=0, off=41918, siz=4, lab1=.L3028, lab2=, loff=0
!   reloc[124]: knd=0, off=41922, siz=4, lab1=.L3051, lab2=, loff=0
!   reloc[125]: knd=0, off=41927, siz=4, lab1=.L3032, lab2=, loff=0
!   reloc[126]: knd=0, off=41931, siz=4, lab1=.L3041, lab2=, loff=0
!   reloc[127]: knd=0, off=41936, siz=4, lab1=.L3033, lab2=, loff=0
!   reloc[128]: knd=0, off=41940, siz=4, lab1=.L3040, lab2=, loff=0
!   reloc[129]: knd=0, off=42094, siz=4, lab1=gl_EvalCoord2f, lab2=, loff=0
!   reloc[130]: knd=0, off=42098, siz=4, lab1=.L3306, lab2=, loff=0
!   reloc[131]: knd=0, off=42325, siz=4, lab1=.L3066, lab2=, loff=0
!   reloc[132]: knd=0, off=42329, siz=4, lab1=.L3149, lab2=, loff=0
!   reloc[133]: knd=0, off=42334, siz=4, lab1=.L3070, lab2=, loff=0
!   reloc[134]: knd=0, off=42338, siz=4, lab1=.L3104, lab2=, loff=0
!   reloc[135]: knd=0, off=42343, siz=4, lab1=.L3071, lab2=, loff=0
!   reloc[136]: knd=0, off=42347, siz=4, lab1=.L3103, lab2=, loff=0
!   reloc[137]: knd=0, off=42369, siz=4, lab1=.L3075, lab2=, loff=0
!   reloc[138]: knd=0, off=42373, siz=4, lab1=.L3102, lab2=, loff=0
!   reloc[139]: knd=0, off=42378, siz=4, lab1=.L3079, lab2=, loff=0
!   reloc[140]: knd=0, off=42382, siz=4, lab1=.L3095, lab2=, loff=0
!   reloc[141]: knd=0, off=42387, siz=4, lab1=.L3080, lab2=, loff=0
!   reloc[142]: knd=0, off=42391, siz=4, lab1=.L3094, lab2=, loff=0
!   reloc[143]: knd=0, off=42428, siz=4, lab1=.L3083, lab2=, loff=0
!   reloc[144]: knd=0, off=42432, siz=4, lab1=.L3093, lab2=, loff=0
!   reloc[145]: knd=0, off=42460, siz=4, lab1=.L3106, lab2=, loff=0
!   reloc[146]: knd=0, off=42464, siz=4, lab1=.L3148, lab2=, loff=0
!   reloc[147]: knd=0, off=42469, siz=4, lab1=.L3107, lab2=, loff=0
!   reloc[148]: knd=0, off=42473, siz=4, lab1=.L3147, lab2=, loff=0
!   reloc[149]: knd=0, off=42478, siz=4, lab1=.L3111, lab2=, loff=0
!   reloc[150]: knd=0, off=42482, siz=4, lab1=.L3146, lab2=, loff=0
!   reloc[151]: knd=0, off=42487, siz=4, lab1=.L3112, lab2=, loff=0
!   reloc[152]: knd=0, off=42491, siz=4, lab1=.L3145, lab2=, loff=0
!   reloc[153]: knd=0, off=42513, siz=4, lab1=.L3116, lab2=, loff=0
!   reloc[154]: knd=0, off=42517, siz=4, lab1=.L3143, lab2=, loff=0
!   reloc[155]: knd=0, off=42522, siz=4, lab1=.L3120, lab2=, loff=0
!   reloc[156]: knd=0, off=42526, siz=4, lab1=.L3136, lab2=, loff=0
!   reloc[157]: knd=0, off=42531, siz=4, lab1=.L3121, lab2=, loff=0
!   reloc[158]: knd=0, off=42535, siz=4, lab1=.L3135, lab2=, loff=0
!   reloc[159]: knd=0, off=42572, siz=4, lab1=.L3124, lab2=, loff=0
!   reloc[160]: knd=0, off=42576, siz=4, lab1=.L3134, lab2=, loff=0
!   reloc[161]: knd=0, off=42607, siz=4, lab1=.L3150, lab2=, loff=0
!   reloc[162]: knd=0, off=42611, siz=4, lab1=.L3169, lab2=, loff=0
!   reloc[163]: knd=0, off=42616, siz=4, lab1=.L3154, lab2=, loff=0
!   reloc[164]: knd=0, off=42620, siz=4, lab1=.L3162, lab2=, loff=0
!   reloc[165]: knd=0, off=42625, siz=4, lab1=.L3155, lab2=, loff=0
!   reloc[166]: knd=0, off=42629, siz=4, lab1=.L3161, lab2=, loff=0
!   reloc[167]: knd=0, off=42674, siz=4, lab1=.L3170, lab2=, loff=0
!   reloc[168]: knd=0, off=42678, siz=4, lab1=.L3194, lab2=, loff=0
!   reloc[169]: knd=0, off=42683, siz=4, lab1=.L3174, lab2=, loff=0
!   reloc[170]: knd=0, off=42687, siz=4, lab1=.L3186, lab2=, loff=0
!   reloc[171]: knd=0, off=42692, siz=4, lab1=.L3175, lab2=, loff=0
!   reloc[172]: knd=0, off=42696, siz=4, lab1=.L3185, lab2=, loff=0
!   reloc[173]: knd=0, off=42720, siz=4, lab1=.L3188, lab2=, loff=0
!   reloc[174]: knd=0, off=42724, siz=4, lab1=.L3193, lab2=, loff=0
!   reloc[175]: knd=0, off=42729, siz=4, lab1=.L3189, lab2=, loff=0
!   reloc[176]: knd=0, off=42733, siz=4, lab1=.L3192, lab2=, loff=0
!   reloc[177]: knd=0, off=42758, siz=4, lab1=.L3195, lab2=, loff=0
!   reloc[178]: knd=0, off=42762, siz=4, lab1=.L3227, lab2=, loff=0
!   reloc[179]: knd=0, off=42767, siz=4, lab1=.L3202, lab2=, loff=0
!   reloc[180]: knd=0, off=42771, siz=4, lab1=.L3226, lab2=, loff=0
!   reloc[181]: knd=0, off=42776, siz=4, lab1=.L3203, lab2=, loff=0
!   reloc[182]: knd=0, off=42780, siz=4, lab1=.L3225, lab2=, loff=0
!   reloc[183]: knd=0, off=42785, siz=4, lab1=.L3204, lab2=, loff=0
!   reloc[184]: knd=0, off=42789, siz=4, lab1=.L3224, lab2=, loff=0
!   reloc[185]: knd=0, off=42794, siz=4, lab1=.L3208, lab2=, loff=0
!   reloc[186]: knd=0, off=42798, siz=4, lab1=.L3215, lab2=, loff=0
!   reloc[187]: knd=0, off=42803, siz=4, lab1=.L3209, lab2=, loff=0
!   reloc[188]: knd=0, off=42807, siz=4, lab1=.L3214, lab2=, loff=0
!   reloc[189]: knd=0, off=42835, siz=4, lab1=.L3228, lab2=, loff=0
!   reloc[190]: knd=0, off=42839, siz=4, lab1=.L3303, lab2=, loff=0
!   reloc[191]: knd=0, off=42844, siz=4, lab1=.L3232, lab2=, loff=0
!   reloc[192]: knd=0, off=42848, siz=4, lab1=.L3239, lab2=, loff=0
!   reloc[193]: knd=0, off=42853, siz=4, lab1=.L3233, lab2=, loff=0
!   reloc[194]: knd=0, off=42857, siz=4, lab1=.L3238, lab2=, loff=0
!   reloc[195]: knd=0, off=42881, siz=4, lab1=.L3241, lab2=, loff=0
!   reloc[196]: knd=0, off=42885, siz=4, lab1=.L3302, lab2=, loff=0
!   reloc[197]: knd=0, off=42890, siz=4, lab1=.L3242, lab2=, loff=0
!   reloc[198]: knd=0, off=42894, siz=4, lab1=.L3301, lab2=, loff=0
!   reloc[199]: knd=0, off=42899, siz=4, lab1=.L3246, lab2=, loff=0
!   reloc[200]: knd=0, off=42903, siz=4, lab1=.L3254, lab2=, loff=0
!   reloc[201]: knd=0, off=42908, siz=4, lab1=.L3247, lab2=, loff=0
!   reloc[202]: knd=0, off=42912, siz=4, lab1=.L3253, lab2=, loff=0
!   reloc[203]: knd=0, off=42936, siz=4, lab1=.L3256, lab2=, loff=0
!   reloc[204]: knd=0, off=42940, siz=4, lab1=.L3300, lab2=, loff=0
!   reloc[205]: knd=0, off=42945, siz=4, lab1=.L3257, lab2=, loff=0
!   reloc[206]: knd=0, off=42949, siz=4, lab1=.L3299, lab2=, loff=0
!   reloc[207]: knd=0, off=42954, siz=4, lab1=.L3261, lab2=, loff=0
!   reloc[208]: knd=0, off=42958, siz=4, lab1=.L3270, lab2=, loff=0
!   reloc[209]: knd=0, off=42963, siz=4, lab1=.L3262, lab2=, loff=0
!   reloc[210]: knd=0, off=42967, siz=4, lab1=.L3269, lab2=, loff=0
!   reloc[211]: knd=0, off=42991, siz=4, lab1=.L3272, lab2=, loff=0
!   reloc[212]: knd=0, off=42995, siz=4, lab1=.L3298, lab2=, loff=0
!   reloc[213]: knd=0, off=43000, siz=4, lab1=.L3273, lab2=, loff=0
!   reloc[214]: knd=0, off=43004, siz=4, lab1=.L3297, lab2=, loff=0
!   reloc[215]: knd=0, off=43009, siz=4, lab1=.L3277, lab2=, loff=0
!   reloc[216]: knd=0, off=43013, siz=4, lab1=.L3287, lab2=, loff=0
!   reloc[217]: knd=0, off=43018, siz=4, lab1=.L3278, lab2=, loff=0
!   reloc[218]: knd=0, off=43022, siz=4, lab1=.L3286, lab2=, loff=0
!   reloc[219]: knd=0, off=43242, siz=4, lab1=gl_MapGrid1f, lab2=, loff=0
!   reloc[220]: knd=0, off=43246, siz=4, lab1=.L3340, lab2=, loff=0
!   reloc[221]: knd=0, off=43339, siz=4, lab1=gl_MapGrid2f, lab2=, loff=0
!   reloc[222]: knd=0, off=43343, siz=4, lab1=.L3389, lab2=, loff=0
!   reloc[223]: knd=0, off=43482, siz=4, lab1=gl_EvalPoint1, lab2=, loff=0
!   reloc[224]: knd=0, off=43486, siz=4, lab1=.L3427, lab2=, loff=0
!   reloc[225]: knd=0, off=43578, siz=4, lab1=gl_EvalPoint2, lab2=, loff=0
!   reloc[226]: knd=0, off=43582, siz=4, lab1=.L3495, lab2=, loff=0
!   reloc[227]: knd=0, off=43716, siz=4, lab1=gl_EvalMesh1, lab2=, loff=0
!   reloc[228]: knd=0, off=43720, siz=4, lab1=.L3581, lab2=, loff=0
!   reloc[229]: knd=0, off=43875, siz=4, lab1=gl_EvalMesh2, lab2=, loff=0
!   reloc[230]: knd=0, off=43879, siz=4, lab1=.L3965, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0xad,0x44,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "eval.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  eval.c -W0,-xp\\$XAa59JCRsd3LWyK.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCRsd3LWyK.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_init_eval\0"
	.byte 0x01,0x02,0x01,0x57
	.uaword gl_init_eval
	.uaword .L28
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x3a
	.byte 0x03
	.ascii "init_flag\0"
	.byte 0x00,0x00,0x01,0x3a,0x03,0x01,0x58,0x05
	.byte 0x03
	.uaword $XBa59JCRsd3LWyK.gl_init_eval.init_flag
	.byte 0x00,0x04
	.ascii "int\0"
	.byte 0x05,0x04,0x05
	.ascii "horner_bezier_curve\0"
	.byte 0x03,0x01,0x82
	.uaword horner_bezier_curve
	.uaword .L102
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x02,0x01
	.byte 0x06,0x00,0x00,0x02,0x18
	.ascii "cp\0"
	.byte 0x01,0x80,0x03,0x91,0xc4,0x00,0x06,0x00
	.byte 0x00,0x02,0x18
	.ascii "out\0"
	.byte 0x01,0x80,0x03,0x91,0xc8,0x00,0x06,0x00
	.byte 0x00,0x02,0x0a
	.ascii "t\0"
	.byte 0x01,0x80,0x03,0x91,0xcc,0x00,0x06,0x00
	.byte 0x00,0x02,0x29
	.ascii "dim\0"
	.byte 0x01,0x81,0x03,0x91,0xd0,0x00,0x06,0x00
	.byte 0x00,0x02,0x29
	.ascii "order\0"
	.byte 0x01,0x81,0x03,0x91,0xd4,0x00,0x03
	.ascii "s\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x83,0x02
	.byte 0x91,0x7c,0x03
	.ascii "powert\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x83,0x02
	.byte 0x91,0x78,0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x84,0x02
	.byte 0x91,0x74,0x03
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x84,0x02
	.byte 0x91,0x70,0x03
	.ascii "bincoeff\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x84,0x02
	.byte 0x91,0x6c,0x00,0x04
	.ascii "float\0"
	.byte 0x04,0x04,0x07,0x00,0x00,0x02,0x01
	.ascii "GLfloat\0"
	.byte 0x02,0x08,0x00,0x00,0x02,0x0a,0x04
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x07,0x00,0x00,0x02,0x1d
	.ascii "GLuint\0"
	.byte 0x02,0x05
	.ascii "horner_bezier_surf\0"
	.byte 0x03,0x01,0xaf
	.uaword horner_bezier_surf
	.uaword .L223
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0xe8
	.byte 0x06,0x00,0x00,0x02,0x18
	.ascii "cn\0"
	.byte 0x01,0xad,0x03,0x91,0xc4,0x00,0x06,0x00
	.byte 0x00,0x02,0x18
	.ascii "out\0"
	.byte 0x01,0xad,0x03,0x91,0xc8,0x00,0x06,0x00
	.byte 0x00,0x02,0x0a
	.ascii "u\0"
	.byte 0x01,0xad,0x03,0x91,0xcc,0x00,0x06,0x00
	.byte 0x00,0x02,0x0a
	.ascii "v\0"
	.byte 0x01,0xad,0x03,0x91,0xd0,0x00,0x06,0x00
	.byte 0x00,0x02,0x29
	.ascii "dim\0"
	.byte 0x01,0xae,0x03,0x91,0xd4,0x00,0x06,0x00
	.byte 0x00,0x02,0x29
	.ascii "uorder\0"
	.byte 0x01,0xae,0x03,0x91,0xd8,0x00,0x06,0x00
	.byte 0x00,0x02,0x29
	.ascii "vorder\0"
	.byte 0x01,0xae,0x03,0x91,0xdc,0x00,0x03
	.ascii "cp\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0xb0,0x02
	.byte 0x91,0x7c,0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xb1,0x02
	.byte 0x91,0x78,0x03
	.ascii "uinc\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xb1,0x02
	.byte 0x91,0x74,0x09
	.uaword .L110
	.uaword .L221
	.byte 0x09
	.uaword .L114
	.uaword .L187
	.byte 0x09
	.uaword .L115
	.uaword .L186
	.byte 0x09
	.uaword .L116
	.uaword .L185
	.byte 0x09
	.uaword .L120
	.uaword .L180
	.byte 0x09
	.uaword .L121
	.uaword .L179
	.byte 0x03
	.ascii "s\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0xb7,0x02
	.byte 0x91,0x70,0x03
	.ascii "poweru\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0xb7,0x02
	.byte 0x91,0x6c,0x03
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xb8,0x02
	.byte 0x91,0x68,0x03
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xb8,0x02
	.byte 0x91,0x64,0x03
	.ascii "bincoeff\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xb8,0x02
	.byte 0x91,0x60,0x09
	.uaword .L122
	.uaword .L177
	.byte 0x09
	.uaword .L128
	.uaword .L174
	.byte 0x09
	.uaword .L129
	.uaword .L173
	.byte 0x03
	.ascii "ucp\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0xbd,0x02
	.byte 0x91,0x5c,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x09
	.uaword .L189
	.uaword .L220
	.byte 0x09
	.uaword .L190
	.uaword .L219
	.byte 0x09
	.uaword .L191
	.uaword .L218
	.byte 0x09
	.uaword .L195
	.uaword .L213
	.byte 0x09
	.uaword .L196
	.uaword .L212
	.byte 0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0xdc,0x02
	.byte 0x91,0x70,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x0a
	.ascii "de_casteljau_surf\0"
	.byte 0x03,0x01,0x01,0x02
	.uaword de_casteljau_surf
	.uaword .L785
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x05,0x3a
	.byte 0x06,0x00,0x00,0x02,0x18
	.ascii "cn\0"
	.byte 0x01,0xff,0x03,0x91,0xc4,0x00,0x06,0x00
	.byte 0x00,0x02,0x18
	.ascii "out\0"
	.byte 0x01,0xff,0x03,0x91,0xc8,0x00,0x06,0x00
	.byte 0x00,0x02,0x18
	.ascii "du\0"
	.byte 0x01,0xff,0x03,0x91,0xcc,0x00,0x06,0x00
	.byte 0x00,0x02,0x18
	.ascii "dv\0"
	.byte 0x01,0xff,0x03,0x91,0xd0,0x00,0x0b,0x00
	.byte 0x00,0x02,0x0a
	.ascii "u\0"
	.byte 0x01,0x01,0x00,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v\0"
	.byte 0x01,0x01,0x00,0x03,0x91,0xd8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x29
	.ascii "dim\0"
	.byte 0x01,0x01,0x00,0x03,0x91,0xdc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x29
	.ascii "uorder\0"
	.byte 0x01,0x01,0x01,0x03,0x91,0xe0,0x00,0x0b
	.byte 0x00,0x00,0x02,0x29
	.ascii "vorder\0"
	.byte 0x01,0x01,0x01,0x03,0x91,0xe4,0x00,0x0c
	.ascii "dcn\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x01,0x03
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "us\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x01,0x04
	.byte 0x02,0x91,0x78,0x0c
	.ascii "vs\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x01,0x04
	.byte 0x02,0x91,0x74,0x0c
	.ascii "h\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x05
	.byte 0x02,0x91,0x70,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x05
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x05
	.byte 0x02,0x91,0x68,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x05
	.byte 0x02,0x91,0x64,0x0c
	.ascii "minorder\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x06
	.byte 0x02,0x91,0x60,0x0c
	.ascii "uinc\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x07
	.byte 0x02,0x91,0x58,0x0c
	.ascii "dcuinc\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x01,0x08
	.byte 0x02,0x91,0x54,0x00,0x0d
	.ascii "components\0"
	.byte 0x03,0x01,0x02,0x23
	.uaword components
	.uaword .L841
	.byte 0x01,0x6e,0x01,0x00,0x00,0x05,0x72,0x01
	.byte 0x00,0x00,0x05,0x72,0x0b,0x00,0x00,0x35
	.byte 0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0x22,0x03,0x91,0xc4,0x00,0x00
	.byte 0x07,0x00,0x00,0x01,0x3a
	.ascii "GLint\0"
	.byte 0x02,0x0e,0x04,0x02,0x00,0x00,0x35,0x1a
	.byte 0x0f
	.ascii "GL_FALSE\0"
	.byte 0x00,0x0f
	.ascii "GL_TRUE\0"
	.byte 0x01,0x0f
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x0f
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x0f
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x0f
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x0f
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x0f
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x0f
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x0f
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x0f
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x0f
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x0f
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x0f
	.ascii "GL_LINES\0"
	.byte 0x01,0x0f
	.ascii "GL_POINTS\0"
	.byte 0x00,0x0f
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x0f
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x0f
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x0f
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x0f
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x0f
	.ascii "GL_QUADS\0"
	.byte 0x07,0x0f
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x0f
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x0f
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x0f
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x0f
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x0f
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x0f
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x0f
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x0f
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x0f
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x0f
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x0f
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x0f
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x0f
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x0f
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x0f
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x0f
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x0f
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x0f
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x0f
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x0f
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x0f
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x0f
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x0f
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x0f
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x0f
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x0f
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x0f
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x0f
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x0f
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x0f
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x0f
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x0f
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x0f
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x0f
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x0f
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x0f
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x0f
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x0f
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x0f
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x0f
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x0f
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x0f
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x0f
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x0f
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x0f
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x0f
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x0f
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x0f
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x0f
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x0f
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x0f
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x0f
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x0f
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x0f
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x0f
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x0f
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x0f
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x0f
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x0f
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x0f
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x0f
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x0f
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x0f
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x0f
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x0f
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x0f
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x0f
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x0f
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x0f
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x0f
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x0f
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x0f
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x0f
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x0f
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x0f
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x0f
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x0f
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x0f
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x0f
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x0f
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x0f
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x0f
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x0f
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x0f
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x0f
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x0f
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x0f
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x0f
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x0f
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x0f
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x0f
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x0f
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x0f
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x0f
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x0f
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x0f
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x0f
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x0f
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x0f
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x0f
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x0f
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x0f
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x0f
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x0f
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x0f
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x0f
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x0f
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x0f
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x0f
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x0f
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x0f
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x0f
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x0f
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x0f
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x0f
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x0f
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x0f
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x0f
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x0f
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x0f
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x0f
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x0f
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x0f
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x0f
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x0f
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x0f
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x0f
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x0f
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x0f
	.ascii "GL_ZERO\0"
	.byte 0x00,0x0f
	.ascii "GL_ONE\0"
	.byte 0x01,0x0f
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x0f
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x0f
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x0f
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x0f
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x0f
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x0f
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x0f
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x0f
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x0f
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x0f
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x0f
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x0f
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x0f
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x0f
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x0f
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x0f
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x0f
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x0f
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x0f
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x0f
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x0f
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x0f
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x0f
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x0f
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x0f
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x0f
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x0f
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x0f
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x0f
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x0f
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x0f
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x0f
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x0f
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x0f
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x0f
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x0f
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x0f
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x0f
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x0f
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x0f
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x0f
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x0f
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0f
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0f
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x0f
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x0f
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x0f
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x0f
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x0f
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x0f
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x0f
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x0f
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x0f
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x0f
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x0f
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x0f
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x0f
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x0f
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x0f
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x0f
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x0f
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x0f
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x0f
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x0f
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x0f
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x0f
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x0f
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x0f
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x0f
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x0f
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x0f
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x0f
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x0f
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x0f
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x0f
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x0f
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x0f
	.ascii "GL_NONE\0"
	.byte 0x00,0x0f
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x0f
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x0f
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x0f
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x0f
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x0f
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x0f
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x0f
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x0f
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x0f
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x0f
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x0f
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x0f
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x0f
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x0f
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x0f
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x0f
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x0f
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x0f
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x0f
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x0f
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x0f
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x0f
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x0f
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x0f
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x0f
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x0f
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x0f
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x0f
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x0f
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x0f
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x0f
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x0f
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x0f
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x0f
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x0f
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x0f
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x0f
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x0f
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x0f
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x0f
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x0f
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x0f
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x0f
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x0f
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x0f
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x0f
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x0f
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x0f
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x0f
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x0f
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x0f
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x0f
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x0f
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x0f
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x0f
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x0f
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x0f
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x0f
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x0f
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x0f
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x0f
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x0f
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x0f
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x0f
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x0f
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x0f
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x0f
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x0f
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x0f
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x0f
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x0f
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x0f
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x0f
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x0f
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x0f
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x0f
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x0f
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x0f
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x0f
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x0f
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x0f
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x0f
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x0f
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x0f
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x0f
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x0f
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x0f
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x0f
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x0f
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x0f
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x0f
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x0f
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x0f
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x0f
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x0f
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x0f
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x0f
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x0f
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x0f
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x0f
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x0f
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x0f
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x0f
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x0f
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x0f
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x0f
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x0f
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x0f
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x0f
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x0f
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x0f
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x0f
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x0f
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x0f
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x0f
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x0f
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x0f
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x0f
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x0f
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x0f
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x0f
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x0f
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x0f
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x0f
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x0f
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x0f
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x0f
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x0f
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x0f
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x0f
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x0f
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x0f
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x0f
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x0f
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x0f
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x0f
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x0f
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x0f
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x0f
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x0f
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x0f
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x0f
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x0f
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x0f
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x0f
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x0f
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x0f
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x0f
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x0f
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x0f
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x0f
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x0f
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x0f
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x0f
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x0f
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x0f
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x0f
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x0f
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x0f
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x0f
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x0f
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x0f
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x0f
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x0f
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x0f
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x0f
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x0f
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x0f
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x0f
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x0f
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x0f
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x0f
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x0f
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x0f
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x0f
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x0f
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x0f
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x0f
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x0f
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x0f
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x0f
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x0f
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x0f
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x0f
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x0f
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x0f
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x0f
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x0f
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x0f
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x0f
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x0f
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x0f
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x0f
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x0f
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x0f
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x0f
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x0f
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x0f
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x0f
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x0f
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x0f
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x0f
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x0f
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x0f
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x0f
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x0f
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x0f
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x0f
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x0f
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x0f
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x0f
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x0f
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x0f
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x0f
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x0f
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x0f
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x0f
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x0f
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x0f
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x0f
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x0f
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x0f
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x0f
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x0f
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x0f
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x0f
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x0f
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x0f
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x0f
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x0f
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x0f
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x0f
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x0f
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x0f
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x0f
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x0f
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x0f
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x0f
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x0f
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x0f
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x0f
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x0f
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x0f
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x0f
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x0f
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x0f
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x0f
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x0f
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x0f
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x0f
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x0f
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x0f
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x0f
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x0f
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x07,0x00,0x00,0x05
	.byte 0x7e
	.ascii "GLenum\0"
	.byte 0x02,0x10
	.ascii "gl_copy_map_points1f\0"
	.byte 0x01,0x02,0x01,0x02,0x4b
	.uaword gl_copy_map_points1f
	.uaword .L893
	.byte 0x01,0x6e,0x01,0x00,0x00,0x02,0x18,0x01
	.byte 0x00,0x00,0x35,0xf2,0x0b,0x00,0x00,0x35
	.byte 0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0x48,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "ustride\0"
	.byte 0x01,0x02,0x49,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "uorder\0"
	.byte 0x01,0x02,0x49,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x35,0xf7
	.ascii "points\0"
	.byte 0x01,0x02,0x4a,0x03,0x91,0xd0,0x00,0x0c
	.ascii "buffer\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x4c
	.byte 0x02,0x91,0x78,0x0c
	.ascii "p\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x4c
	.byte 0x02,0x91,0x74,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x4d
	.byte 0x02,0x91,0x70,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x4d
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "size\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x4d
	.byte 0x02,0x91,0x68,0x00,0x11,0x00,0x00,0x02
	.byte 0x0a,0x08,0x00,0x00,0x35,0xf2,0x10
	.ascii "gl_copy_map_points1d\0"
	.byte 0x01,0x02,0x01,0x02,0x65
	.uaword gl_copy_map_points1d
	.uaword .L933
	.byte 0x01,0x6e,0x01,0x00,0x00,0x02,0x18,0x01
	.byte 0x00,0x00,0x36,0xc7,0x0b,0x00,0x00,0x35
	.byte 0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0x62,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "ustride\0"
	.byte 0x01,0x02,0x63,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "uorder\0"
	.byte 0x01,0x02,0x63,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x36,0xe5
	.ascii "points\0"
	.byte 0x01,0x02,0x64,0x03,0x91,0xd0,0x00,0x0c
	.ascii "buffer\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x66
	.byte 0x02,0x91,0x78,0x0c
	.ascii "p\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x66
	.byte 0x02,0x91,0x74,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x67
	.byte 0x02,0x91,0x70,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x67
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "size\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x67
	.byte 0x02,0x91,0x68,0x00,0x04
	.ascii "double\0"
	.byte 0x04,0x08,0x07,0x00,0x00,0x36,0xc7
	.ascii "GLdouble\0"
	.byte 0x02,0x11,0x00,0x00,0x36,0xd1,0x08,0x00
	.byte 0x00,0x36,0xe0,0x10
	.ascii "gl_copy_map_points2f\0"
	.byte 0x01,0x02,0x01,0x02,0x83
	.uaword gl_copy_map_points2f
	.uaword .L1005
	.byte 0x01,0x6e,0x01,0x00,0x00,0x02,0x18,0x01
	.byte 0x00,0x00,0x38,0x1f,0x0b,0x00,0x00,0x35
	.byte 0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0x7f,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "ustride\0"
	.byte 0x01,0x02,0x80,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "uorder\0"
	.byte 0x01,0x02,0x80,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vstride\0"
	.byte 0x01,0x02,0x81,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vorder\0"
	.byte 0x01,0x02,0x81,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x38,0x24
	.ascii "points\0"
	.byte 0x01,0x02,0x82,0x03,0x91,0xd8,0x00,0x0c
	.ascii "buffer\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x84
	.byte 0x02,0x91,0x78,0x0c
	.ascii "p\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0x84
	.byte 0x02,0x91,0x74,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x70,0x0c
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x68,0x0c
	.ascii "size\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x64,0x0c
	.ascii "dsize\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x60,0x0c
	.ascii "hsize\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0x85
	.byte 0x02,0x91,0x5c,0x0c
	.ascii "uinc\0"
	.byte 0x00,0x00,0x05,0x72,0x01,0x01,0x02,0x86
	.byte 0x02,0x91,0x58,0x00,0x11,0x00,0x00,0x02
	.byte 0x0a,0x08,0x00,0x00,0x38,0x1f,0x10
	.ascii "gl_copy_map_points2d\0"
	.byte 0x01,0x02,0x01,0x02,0xaa
	.uaword gl_copy_map_points2d
	.uaword .L1077
	.byte 0x01,0x6e,0x01,0x00,0x00,0x02,0x18,0x01
	.byte 0x00,0x00,0x39,0x5e,0x0b,0x00,0x00,0x35
	.byte 0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0xa6,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "ustride\0"
	.byte 0x01,0x02,0xa7,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "uorder\0"
	.byte 0x01,0x02,0xa7,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vstride\0"
	.byte 0x01,0x02,0xa8,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vorder\0"
	.byte 0x01,0x02,0xa8,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x39,0x63
	.ascii "points\0"
	.byte 0x01,0x02,0xa9,0x03,0x91,0xd8,0x00,0x0c
	.ascii "buffer\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0xab
	.byte 0x02,0x91,0x78,0x0c
	.ascii "p\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x02,0xab
	.byte 0x02,0x91,0x74,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x70,0x0c
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x68,0x0c
	.ascii "size\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x64,0x0c
	.ascii "hsize\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x60,0x0c
	.ascii "dsize\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x02,0xac
	.byte 0x02,0x91,0x5c,0x0c
	.ascii "uinc\0"
	.byte 0x00,0x00,0x05,0x72,0x01,0x01,0x02,0xad
	.byte 0x02,0x91,0x58,0x00,0x11,0x00,0x00,0x36
	.byte 0xd1,0x08,0x00,0x00,0x39,0x5e,0x12
	.ascii "gl_free_control_points\0"
	.byte 0x01,0x02,0x01,0x02,0xce
	.uaword gl_free_control_points
	.uaword .L1205
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x39,0xec
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x02,0xcd,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x02,0xcd,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x18
	.ascii "data\0"
	.byte 0x01,0x02,0xcd,0x03,0x91,0xcc,0x00,0x0c
	.ascii "map1\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x02,0xcf
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "map2\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x02,0xd0
	.byte 0x02,0x91,0x78,0x00,0x13
	.ascii "HashTable\0"
	.byte 0x01,0x08,0x00,0x00,0x39,0xec,0x04
	.ascii "long\0"
	.byte 0x05,0x04,0x14,0x00,0x00,0x05,0x72,0x10
	.byte 0x00,0x00,0x3a,0x16,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x04
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x07,0x00,0x00,0x3a,0x16
	.ascii "GLubyte\0"
	.byte 0x02,0x08,0x00,0x00,0x3a,0x27,0x04
	.ascii "void\0"
	.byte 0x05,0x00,0x08,0x00,0x00,0x3a,0x3a,0x16
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x03,0x00,0x00,0x3b,0x50,0x17
	.ascii "Format\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "Border\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x08,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x0c,0x17
	.ascii "Height\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x10,0x17
	.ascii "Depth\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x14,0x17
	.ascii "Width2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x18,0x17
	.ascii "Height2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x1c,0x17
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x20,0x17
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x24,0x17
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x28,0x17
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x2c,0x17
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x30,0x17
	.ascii "Data\0"
	.byte 0x00,0x00,0x3a,0x35,0x02,0x23,0x34,0x17
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x38,0x00
	.byte 0x08,0x00,0x00,0x3a,0x47,0x14,0x00,0x00
	.byte 0x3b,0x50,0x2c,0x00,0x00,0x3b,0x66,0x15
	.byte 0x00,0x00,0x39,0xfd,0x0a,0x00,0x18,0x00
	.byte 0x00,0x3a,0x27,0x04,0x00,0x00,0x00,0x3b
	.byte 0x79,0x19,0x00,0x00,0x39,0xfd,0x03,0xff
	.byte 0x00,0x07,0x00,0x00,0x3a,0x16
	.ascii "GLboolean\0"
	.byte 0x02,0x1a
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x03,0x00,0x00,0x3d,0x18,0x17
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "Name\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x04,0x17
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x08,0x17
	.ascii "Priority\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x0c,0x17
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x3a,0x05,0x02,0x23,0x10,0x17
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x20,0x17
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x24,0x17
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x28,0x17
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x2c,0x17
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x30,0x17
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x34,0x17
	.ascii "Image\0"
	.byte 0x00,0x00,0x3b,0x55,0x02,0x23,0x38,0x17
	.ascii "Palette\0"
	.byte 0x00,0x00,0x3b,0x66,0x02,0x23,0x64,0x17
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xe4,0x08
	.byte 0x17
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x35,0x1a,0x03,0x23,0xe8,0x08
	.byte 0x17
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x35,0x1a,0x03,0x23,0xec,0x08
	.byte 0x17
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xf0,0x08
	.byte 0x17
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x3a,0x42,0x03,0x23,0xf4,0x08
	.byte 0x17
	.ascii "Complete\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xf8,0x08
	.byte 0x17
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x3d,0x8e,0x03,0x23,0xfc,0x08
	.byte 0x17
	.ascii "Next\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0x80,0x09
	.byte 0x00,0x11,0x00,0x00,0x3b,0x89,0x08,0x00
	.byte 0x00,0x3d,0x18,0x11,0x00,0x00,0x02,0x01
	.byte 0x08,0x00,0x00,0x3d,0x22,0x11,0x00,0x00
	.byte 0x02,0x01,0x08,0x00,0x00,0x3d,0x2c,0x11
	.byte 0x00,0x00,0x02,0x01,0x08,0x00,0x00,0x3d
	.byte 0x36,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x3d,0x40,0x08,0x00,0x00,0x3a,0x16
	.byte 0x1b,0x01,0x01,0x00,0x00,0x3d,0x89,0x1c
	.byte 0x00,0x00,0x3d,0x1d,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0x3d,0x27,0x1c,0x00
	.byte 0x00,0x3d,0x31,0x1c,0x00,0x00,0x3d,0x3b
	.byte 0x1c,0x00,0x00,0x3d,0x45,0x1c,0x00,0x00
	.byte 0x3d,0x4a,0x1c,0x00,0x00,0x3d,0x4a,0x1c
	.byte 0x00,0x00,0x3d,0x4a,0x1c,0x00,0x00,0x3d
	.byte 0x4a,0x00,0x08,0x00,0x00,0x3d,0x4f,0x07
	.byte 0x00,0x00,0x3d,0x89
	.ascii "TextureSampleFunc\0"
	.byte 0x03,0x08,0x00,0x00,0x3b,0x89,0x16
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x03,0x00,0x00,0x3e,0x47,0x17
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x39,0xf8,0x02,0x23,0x04,0x17
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x39,0xf8,0x02,0x23,0x08,0x17
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x3d,0xa6,0x02,0x23,0x0c,0x17
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x02,0x23,0x10,0x17
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x02,0x23,0x14,0x17
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x02,0x23,0x18,0x00
	.byte 0x08,0x00,0x00,0x3d,0xab,0x1a
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x03,0x00,0x00,0x45,0x19,0x17
	.ascii "Shared\0"
	.byte 0x00,0x00,0x3e,0x47,0x02,0x23,0x00,0x17
	.ascii "API\0"
	.byte 0x00,0x00,0x5d,0xfa,0x02,0x23,0x04,0x17
	.ascii "Save\0"
	.byte 0x00,0x00,0x5d,0xfa,0x03,0x23,0xe0,0x05
	.byte 0x17
	.ascii "Exec\0"
	.byte 0x00,0x00,0x5d,0xfa,0x03,0x23,0xbc,0x0b
	.byte 0x17
	.ascii "Visual\0"
	.byte 0x00,0x00,0x6e,0x55,0x03,0x23,0x98,0x11
	.byte 0x17
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x6f,0x89,0x03,0x23,0x9c,0x11
	.byte 0x17
	.ascii "Driver\0"
	.byte 0x00,0x00,0x78,0x98,0x03,0x23,0xa0,0x11
	.byte 0x17
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x3a,0x42,0x03,0x23,0xf4,0x12
	.byte 0x17
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x3a,0x42,0x03,0x23,0xf8,0x12
	.byte 0x17
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xfc,0x12
	.byte 0x17
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0x80,0x13
	.byte 0x17
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x7d,0x00,0x03,0x23,0x84,0x13
	.byte 0x17
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x7d,0x11,0x03,0x23,0xc4,0x13
	.byte 0x17
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0x84,0x14
	.byte 0x17
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x7d,0x33,0x03,0x23,0x88,0x14
	.byte 0x17
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0x88,0x24
	.byte 0x17
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0x8c,0x24
	.byte 0x17
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x7d,0x45,0x03,0x23,0x90,0x24
	.byte 0x17
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xd0,0x24
	.byte 0x17
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x7d,0x67,0x03,0x23,0xd4,0x24
	.byte 0x17
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x7d,0x8a,0x03,0x23,0xd4,0x34
	.byte 0x17
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xd4,0x36
	.byte 0x17
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xd8,0x36
	.byte 0x17
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x7d,0x9c,0x03,0x23,0xdc,0x36
	.byte 0x17
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0x9c,0x37
	.byte 0x17
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x7d,0xbe,0x03,0x23,0xa0,0x37
	.byte 0x17
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xa0,0x3c
	.byte 0x17
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xa4,0x3c
	.byte 0x17
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xa5,0x3c
	.byte 0x17
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xa8,0x3c
	.byte 0x17
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x7e,0x24,0x03,0x23,0xac,0x3c
	.byte 0x17
	.ascii "Accum\0"
	.byte 0x00,0x00,0x7e,0x46,0x03,0x23,0xec,0x3c
	.byte 0x17
	.ascii "Color\0"
	.byte 0x00,0x00,0x7e,0x93,0x03,0x23,0xfc,0x3c
	.byte 0x17
	.ascii "Current\0"
	.byte 0x00,0x00,0x80,0xa8,0x03,0x23,0xd4,0x3d
	.byte 0x17
	.ascii "Depth\0"
	.byte 0x00,0x00,0x81,0x92,0x03,0x23,0xb4,0x3e
	.byte 0x17
	.ascii "Eval\0"
	.byte 0x00,0x00,0x81,0xe5,0x03,0x23,0xc0,0x3e
	.byte 0x17
	.ascii "Fog\0"
	.byte 0x00,0x00,0x84,0x5b,0x03,0x23,0xf8,0x3e
	.byte 0x17
	.ascii "Hint\0"
	.byte 0x00,0x00,0x84,0xd4,0x03,0x23,0xa0,0x3f
	.byte 0x17
	.ascii "Light\0"
	.byte 0x00,0x00,0x89,0xdf,0x03,0x23,0xb4,0x3f
	.byte 0x17
	.ascii "Line\0"
	.byte 0x00,0x00,0x8b,0x0f,0x04,0x23,0x88,0xdc
	.byte 0x02,0x17
	.ascii "List\0"
	.byte 0x00,0x00,0x8b,0x88,0x04,0x23,0x94,0xdc
	.byte 0x02,0x17
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x8c,0x6e,0x04,0x23,0x98,0xdc
	.byte 0x02,0x17
	.ascii "Point\0"
	.byte 0x00,0x00,0x8f,0x3e,0x04,0x23,0x80,0xad
	.byte 0x03,0x17
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x8f,0xb7,0x04,0x23,0xa0,0xad
	.byte 0x03,0x17
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x90,0xea,0x04,0x23,0xc8,0xad
	.byte 0x03,0x17
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x91,0x09,0x04,0x23,0xc8,0xae
	.byte 0x03,0x17
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x91,0x64,0x04,0x23,0xdc,0xae
	.byte 0x03,0x17
	.ascii "Texture\0"
	.byte 0x00,0x00,0x92,0xbe,0x04,0x23,0xf4,0xae
	.byte 0x03,0x17
	.ascii "Transform\0"
	.byte 0x00,0x00,0x95,0x20,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x17
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x95,0x9a,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x17
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x17
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x96,0x41,0x04,0x23,0xec,0xb9
	.byte 0x03,0x17
	.ascii "Array\0"
	.byte 0x00,0x00,0x96,0x57,0x04,0x23,0xac,0xba
	.byte 0x03,0x17
	.ascii "Pack\0"
	.byte 0x00,0x00,0x99,0x02,0x04,0x23,0xac,0xbb
	.byte 0x03,0x17
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x99,0x02,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x17
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x9a,0x7f,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x17
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x9c,0x09,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x17
	.ascii "Select\0"
	.byte 0x00,0x00,0x9c,0x7e,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x17
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0xec,0xc1
	.byte 0x03,0x17
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x17
	.ascii "NewState\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x17
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x17
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x17
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0x80,0xc2
	.byte 0x03,0x17
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0x84,0xc2
	.byte 0x03,0x17
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0x88,0xc2
	.byte 0x03,0x17
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x17
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x17
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x02,0x0a,0x04,0x23,0x90,0xc2
	.byte 0x03,0x17
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x02,0x0a,0x04,0x23,0x94,0xc2
	.byte 0x03,0x17
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x02,0x0a,0x04,0x23,0x98,0xc2
	.byte 0x03,0x17
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x17
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x17
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x17
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x17
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x75,0xd3,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x17
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x76,0x06,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x17
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x76,0x3c,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x17
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x76,0x7b,0x04,0x23,0xac,0xc2
	.byte 0x03,0x17
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x76,0xb1,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x17
	.ascii "VB\0"
	.byte 0x00,0x00,0x9d,0x43,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x17
	.ascii "PB\0"
	.byte 0x00,0x00,0x9d,0x57,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x17
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x17
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x08,0x00,0x00,0x3e,0x4c,0x1b
	.byte 0x01,0x01,0x00,0x00,0x45,0x35,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x45,0x1e,0x1b,0x01,0x01,0x00,0x00
	.byte 0x45,0x51,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x02
	.byte 0x01,0x00,0x08,0x00,0x00,0x45,0x3a,0x11
	.byte 0x00,0x00,0x02,0x1d,0x08,0x00,0x00,0x45
	.byte 0x56,0x1d,0x01,0x00,0x00,0x3a,0x16,0x01
	.byte 0x00,0x00,0x45,0x80,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x45,0x5b,0x1c,0x00,0x00,0x3d,0x4a
	.byte 0x00,0x08,0x00,0x00,0x45,0x60,0x1b,0x01
	.byte 0x01,0x00,0x00,0x45,0x97,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x01,0x3a,0x00
	.byte 0x08,0x00,0x00,0x45,0x85,0x1b,0x01,0x01
	.byte 0x00,0x00,0x45,0xae,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x45,0x9c,0x1b,0x01,0x01,0x00
	.byte 0x00,0x45,0xca,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x00,0x08,0x00,0x00,0x45,0xb3
	.byte 0x07,0x00,0x00,0x3a,0x3a
	.ascii "GLvoid\0"
	.byte 0x02,0x08,0x00,0x00,0x45,0xcf,0x16
	.ascii "gl_image\0"
	.byte 0x24,0x03,0x00,0x00,0x46,0x7e,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "Height\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "Depth\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x08,0x17
	.ascii "Components\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x0c,0x17
	.ascii "Format\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x10,0x17
	.ascii "Type\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x14,0x17
	.ascii "Data\0"
	.byte 0x00,0x00,0x45,0xdc,0x02,0x23,0x18,0x17
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x1c,0x17
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x20,0x00
	.byte 0x11,0x00,0x00,0x45,0xe1,0x08,0x00,0x00
	.byte 0x46,0x7e,0x1b,0x01,0x01,0x00,0x00,0x46
	.byte 0xb8,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x46
	.byte 0x83,0x00,0x08,0x00,0x00,0x46,0x88,0x1b
	.byte 0x01,0x01,0x00,0x00,0x46,0xde,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x00
	.byte 0x08,0x00,0x00,0x46,0xbd,0x1b,0x01,0x01
	.byte 0x00,0x00,0x46,0xf5,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x46,0xe3,0x1b,0x01,0x01,0x00
	.byte 0x00,0x47,0x11,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x00,0x08,0x00,0x00,0x46,0xfa
	.byte 0x1b,0x01,0x01,0x00,0x00,0x47,0x28,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x08,0x00,0x00,0x47,0x16,0x11
	.byte 0x00,0x00,0x3a,0x3a,0x08,0x00,0x00,0x47
	.byte 0x2d,0x1b,0x01,0x01,0x00,0x00,0x47,0x53
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x47,0x32,0x00,0x08,0x00,0x00
	.byte 0x47,0x37,0x1b,0x01,0x01,0x00,0x00,0x47
	.byte 0x6a,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x00,0x08,0x00,0x00,0x47
	.byte 0x58,0x1b,0x01,0x01,0x00,0x00,0x47,0x90
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x00,0x08,0x00,0x00,0x47,0x6f,0x1b
	.byte 0x01,0x01,0x00,0x00,0x47,0xb6,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x00
	.byte 0x08,0x00,0x00,0x47,0x95,0x1b,0x01,0x01
	.byte 0x00,0x00,0x47,0xcd,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x36,0xc7,0x00,0x08
	.byte 0x00,0x00,0x47,0xbb,0x1b,0x01,0x01,0x00
	.byte 0x00,0x47,0xe4,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x47,0xd2,0x1b,0x01,0x01,0x00,0x00
	.byte 0x47,0xfb,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x00,0x08,0x00,0x00
	.byte 0x47,0xe9,0x11,0x00,0x00,0x02,0x01,0x08
	.byte 0x00,0x00,0x48,0x00,0x1b,0x01,0x01,0x00
	.byte 0x00,0x48,0x21,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x48,0x05,0x00,0x08,0x00,0x00,0x48,0x0a
	.byte 0x1b,0x01,0x01,0x00,0x00,0x48,0x42,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x48
	.byte 0x26,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x48,0x47,0x1b,0x01,0x01,0x00,0x00
	.byte 0x48,0x63,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x48,0x4c,0x00,0x08,0x00,0x00
	.byte 0x48,0x51,0x1b,0x01,0x01,0x00,0x00,0x48
	.byte 0x89,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x01,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x00,0x08,0x00,0x00,0x48,0x68
	.byte 0x11,0x00,0x00,0x02,0x01,0x08,0x00,0x00
	.byte 0x48,0x8e,0x1b,0x01,0x01,0x00,0x00,0x48
	.byte 0xaa,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x48,0x93,0x00,0x08,0x00,0x00,0x48
	.byte 0x98,0x1b,0x01,0x01,0x00,0x00,0x48,0xd0
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x3a,0x16,0x1c,0x00,0x00,0x3a,0x16,0x1c
	.byte 0x00,0x00,0x3a,0x16,0x1c,0x00,0x00,0x3a
	.byte 0x16,0x00,0x08,0x00,0x00,0x48,0xaf,0x11
	.byte 0x00,0x00,0x3a,0x16,0x08,0x00,0x00,0x48
	.byte 0xd5,0x1b,0x01,0x01,0x00,0x00,0x48,0xf1
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x48,0xda,0x00,0x08,0x00,0x00,0x48,0xdf
	.byte 0x1b,0x01,0x01,0x00,0x00,0x49,0x17,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x3a
	.byte 0x16,0x1c,0x00,0x00,0x3a,0x16,0x1c,0x00
	.byte 0x00,0x3a,0x16,0x1c,0x00,0x00,0x3a,0x16
	.byte 0x00,0x08,0x00,0x00,0x48,0xf6,0x1b,0x01
	.byte 0x01,0x00,0x00,0x49,0x33,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x00,0x08,0x00,0x00
	.byte 0x49,0x1c,0x11,0x00,0x00,0x3a,0x3a,0x08
	.byte 0x00,0x00,0x49,0x38,0x1b,0x01,0x01,0x00
	.byte 0x00,0x49,0x63,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x49,0x3d,0x00,0x08,0x00,0x00
	.byte 0x49,0x42,0x08,0x00,0x00,0x45,0xe1,0x1b
	.byte 0x01,0x01,0x00,0x00,0x49,0x89,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x49,0x68,0x00,0x08,0x00,0x00,0x49,0x6d
	.byte 0x1b,0x01,0x01,0x00,0x00,0x49,0xaa,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x49,0x68,0x00,0x08,0x00,0x00,0x49
	.byte 0x8e,0x1b,0x01,0x01,0x00,0x00,0x49,0xd5
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x49,0xaf,0x1b,0x01,0x01,0x00
	.byte 0x00,0x4a,0x0a,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x00,0x08,0x00,0x00,0x49
	.byte 0xda,0x1b,0x01,0x01,0x00,0x00,0x4a,0x44
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x00,0x08,0x00
	.byte 0x00,0x4a,0x0f,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4a,0x74,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x00,0x08,0x00
	.byte 0x00,0x4a,0x49,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4a,0xae,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x00
	.byte 0x08,0x00,0x00,0x4a,0x79,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4a,0xed,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x00,0x08
	.byte 0x00,0x00,0x4a,0xb3,0x1b,0x01,0x01,0x00
	.byte 0x00,0x4b,0x04,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x00,0x08,0x00
	.byte 0x00,0x4a,0xf2,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4b,0x20,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x00,0x08,0x00,0x00,0x4b,0x09,0x11
	.byte 0x00,0x00,0x02,0x1d,0x08,0x00,0x00,0x4b
	.byte 0x25,0x1b,0x01,0x01,0x00,0x00,0x4b,0x46
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x4b,0x2a,0x00
	.byte 0x08,0x00,0x00,0x4b,0x2f,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4b,0x5d,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x4b,0x4b,0x1b,0x01,0x01,0x00
	.byte 0x00,0x4b,0x74,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x3a,0x16,0x00,0x08,0x00
	.byte 0x00,0x4b,0x62,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4b,0x90,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x36,0xc7,0x1c,0x00,0x00,0x36
	.byte 0xc7,0x00,0x08,0x00,0x00,0x4b,0x79,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4b,0xa7,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x00,0x08,0x00,0x00,0x4b,0x95,0x1b,0x01
	.byte 0x01,0x00,0x00,0x4b,0xbe,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x00
	.byte 0x08,0x00,0x00,0x4b,0xac,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4b,0xdf,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x00,0x08,0x00,0x00,0x4b,0xc3,0x1b,0x01
	.byte 0x01,0x00,0x00,0x4b,0xf6,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x00
	.byte 0x08,0x00,0x00,0x4b,0xe4,0x11,0x00,0x00
	.byte 0x3a,0x3a,0x08,0x00,0x00,0x4b,0xfb,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4c,0x26,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x4c,0x00,0x00
	.byte 0x08,0x00,0x00,0x4c,0x05,0x11,0x00,0x00
	.byte 0x3a,0x3a,0x08,0x00,0x00,0x4c,0x2b,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4c,0x5b,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x4c,0x30,0x00,0x08,0x00,0x00
	.byte 0x4c,0x35,0x1b,0x01,0x01,0x00,0x00,0x4c
	.byte 0x72,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x3a,0x16,0x00,0x08,0x00,0x00,0x4c
	.byte 0x60,0x11,0x00,0x00,0x3a,0x16,0x08,0x00
	.byte 0x00,0x4c,0x77,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4c,0x98,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x4c
	.byte 0x7c,0x00,0x08,0x00,0x00,0x4c,0x81,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4c,0xaf,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x00,0x08,0x00,0x00,0x4c,0x9d,0x1b,0x01
	.byte 0x01,0x00,0x00,0x4c,0xc6,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x00
	.byte 0x08,0x00,0x00,0x4c,0xb4,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4c,0xd8,0x1c,0x00,0x00,0x45
	.byte 0x19,0x00,0x08,0x00,0x00,0x4c,0xcb,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4c,0xea,0x1c,0x00
	.byte 0x00,0x45,0x19,0x00,0x08,0x00,0x00,0x4c
	.byte 0xdd,0x1b,0x01,0x01,0x00,0x00,0x4d,0x01
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x01,0x00,0x08,0x00,0x00,0x4c,0xef
	.byte 0x1b,0x01,0x01,0x00,0x00,0x4d,0x1d,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x00,0x08
	.byte 0x00,0x00,0x4d,0x06,0x1b,0x01,0x01,0x00
	.byte 0x00,0x4d,0x3e,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x00
	.byte 0x08,0x00,0x00,0x4d,0x22,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4d,0x69,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x00,0x08,0x00,0x00,0x4d,0x43
	.byte 0x1b,0x01,0x01,0x00,0x00,0x4d,0x80,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x00,0x08,0x00,0x00,0x4d,0x6e,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4d,0x9c,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x00,0x08,0x00
	.byte 0x00,0x4d,0x85,0x08,0x00,0x00,0x02,0x01
	.byte 0x1b,0x01,0x01,0x00,0x00,0x4d,0xc2,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x4d,0xa1,0x00,0x08,0x00,0x00,0x4d
	.byte 0xa6,0x1b,0x01,0x01,0x00,0x00,0x4d,0xd4
	.byte 0x1c,0x00,0x00,0x45,0x19,0x00,0x08,0x00
	.byte 0x00,0x4d,0xc7,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4d,0xe6,0x1c,0x00,0x00,0x45,0x19,0x00
	.byte 0x08,0x00,0x00,0x4d,0xd9,0x11,0x00,0x00
	.byte 0x02,0x01,0x08,0x00,0x00,0x4d,0xeb,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4e,0x0c,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4d,0xf0,0x00,0x08,0x00
	.byte 0x00,0x4d,0xf5,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4e,0x23,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x00,0x08,0x00,0x00
	.byte 0x4e,0x11,0x1b,0x01,0x01,0x00,0x00,0x4e
	.byte 0x53,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x36,0xc7,0x1c,0x00,0x00,0x36,0xc7
	.byte 0x1c,0x00,0x00,0x36,0xc7,0x1c,0x00,0x00
	.byte 0x36,0xc7,0x1c,0x00,0x00,0x36,0xc7,0x1c
	.byte 0x00,0x00,0x36,0xc7,0x00,0x08,0x00,0x00
	.byte 0x4e,0x28,0x1d,0x01,0x00,0x00,0x02,0x1d
	.byte 0x01,0x00,0x00,0x4e,0x6e,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x01,0x3a,0x00
	.byte 0x08,0x00,0x00,0x4e,0x58,0x08,0x00,0x00
	.byte 0x02,0x1d,0x1b,0x01,0x01,0x00,0x00,0x4e
	.byte 0x8f,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x4e,0x73
	.byte 0x00,0x08,0x00,0x00,0x4e,0x78,0x1b,0x01
	.byte 0x01,0x00,0x00,0x4e,0xab,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x3d,0x4a,0x00,0x08,0x00,0x00
	.byte 0x4e,0x94,0x08,0x00,0x00,0x36,0xc7,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4e,0xcc,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4e,0xb0,0x00,0x08,0x00
	.byte 0x00,0x4e,0xb5,0x1b,0x01,0x01,0x00,0x00
	.byte 0x4e,0xf2,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x3a,0x42,0x00,0x08,0x00,0x00,0x4e
	.byte 0xd1,0x08,0x00,0x00,0x01,0x3a,0x1b,0x01
	.byte 0x01,0x00,0x00,0x4f,0x18,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x4e
	.byte 0xf7,0x00,0x08,0x00,0x00,0x4e,0xfc,0x1b
	.byte 0x01,0x01,0x00,0x00,0x4f,0x34,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4e,0xb0,0x00,0x08,0x00
	.byte 0x00,0x4f,0x1d,0x1d,0x01,0x00,0x00,0x05
	.byte 0x7e,0x01,0x00,0x00,0x4f,0x4a,0x1c,0x00
	.byte 0x00,0x45,0x19,0x00,0x08,0x00,0x00,0x4f
	.byte 0x39,0x1b,0x01,0x01,0x00,0x00,0x4f,0x66
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x4d,0xa1,0x00
	.byte 0x08,0x00,0x00,0x4f,0x4f,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4f,0x82,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x4e
	.byte 0xf7,0x00,0x08,0x00,0x00,0x4f,0x6b,0x11
	.byte 0x00,0x00,0x3a,0x16,0x08,0x00,0x00,0x4f
	.byte 0x87,0x1d,0x01,0x00,0x00,0x4f,0x8c,0x01
	.byte 0x00,0x00,0x4f,0xa7,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x4f,0x91,0x1b,0x01,0x01,0x00
	.byte 0x00,0x4f,0xc8,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x4d,0xa1,0x00
	.byte 0x08,0x00,0x00,0x4f,0xac,0x1b,0x01,0x01
	.byte 0x00,0x00,0x4f,0xe9,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x4e,0xf7
	.byte 0x00,0x08,0x00,0x00,0x4f,0xcd,0x1b,0x01
	.byte 0x01,0x00,0x00,0x50,0x0a,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x4e
	.byte 0xb0,0x00,0x08,0x00,0x00,0x4f,0xee,0x1b
	.byte 0x01,0x01,0x00,0x00,0x50,0x2b,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x4d,0xa1,0x00,0x08,0x00,0x00,0x50,0x0f
	.byte 0x1b,0x01,0x01,0x00,0x00,0x50,0x4c,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x4e,0xf7,0x00,0x08,0x00,0x00,0x50
	.byte 0x30,0x1b,0x01,0x01,0x00,0x00,0x50,0x6d
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x4d,0xa1,0x00,0x08,0x00,0x00
	.byte 0x50,0x51,0x1b,0x01,0x01,0x00,0x00,0x50
	.byte 0x8e,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4e,0xf7,0x00,0x08,0x00
	.byte 0x00,0x50,0x72,0x1b,0x01,0x01,0x00,0x00
	.byte 0x50,0xaa,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x4d
	.byte 0xa1,0x00,0x08,0x00,0x00,0x50,0x93,0x1b
	.byte 0x01,0x01,0x00,0x00,0x50,0xc6,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4e,0x73,0x00,0x08,0x00
	.byte 0x00,0x50,0xaf,0x04
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x08,0x00,0x00,0x50,0xcb,0x1b
	.byte 0x01,0x01,0x00,0x00,0x50,0xf9,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x50,0xdd,0x00,0x08,0x00
	.byte 0x00,0x50,0xe2,0x08,0x00,0x00,0x3a,0x42
	.byte 0x1b,0x01,0x01,0x00,0x00,0x51,0x1a,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x50,0xfe,0x00,0x08
	.byte 0x00,0x00,0x51,0x03,0x1b,0x01,0x01,0x00
	.byte 0x00,0x51,0x31,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x3d,0x4a,0x00,0x08,0x00
	.byte 0x00,0x51,0x1f,0x11,0x00,0x00,0x02,0x1d
	.byte 0x08,0x00,0x00,0x51,0x36,0x11,0x00,0x00
	.byte 0x02,0x01,0x08,0x00,0x00,0x51,0x40,0x1b
	.byte 0x01,0x01,0x00,0x00,0x51,0x66,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x51,0x3b,0x1c,0x00,0x00
	.byte 0x51,0x45,0x00,0x08,0x00,0x00,0x51,0x4a
	.byte 0x1b,0x01,0x01,0x00,0x00,0x51,0x87,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x4d,0xa1,0x00,0x08,0x00,0x00,0x51
	.byte 0x6b,0x1b,0x01,0x01,0x00,0x00,0x51,0xa8
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x4e,0xf7,0x00,0x08,0x00,0x00
	.byte 0x51,0x8c,0x1b,0x01,0x01,0x00,0x00,0x51
	.byte 0xc9,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x4e,0xb0,0x00,0x08,0x00
	.byte 0x00,0x51,0xad,0x1b,0x01,0x01,0x00,0x00
	.byte 0x51,0xea,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x4d,0xa1,0x00,0x08
	.byte 0x00,0x00,0x51,0xce,0x1b,0x01,0x01,0x00
	.byte 0x00,0x52,0x0b,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x4e,0xf7,0x00
	.byte 0x08,0x00,0x00,0x51,0xef,0x1b,0x01,0x01
	.byte 0x00,0x00,0x52,0x36,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x3a,0x42,0x00,0x08,0x00,0x00,0x52,0x10
	.byte 0x1b,0x01,0x01,0x00,0x00,0x52,0x5c,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x4d,0xa1
	.byte 0x00,0x08,0x00,0x00,0x52,0x3b,0x1b,0x01
	.byte 0x01,0x00,0x00,0x52,0x82,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x4e,0xf7,0x00,0x08
	.byte 0x00,0x00,0x52,0x61,0x1b,0x01,0x01,0x00
	.byte 0x00,0x52,0xa3,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x4d,0xa1,0x00
	.byte 0x08,0x00,0x00,0x52,0x87,0x1b,0x01,0x01
	.byte 0x00,0x00,0x52,0xc4,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x4e,0xf7
	.byte 0x00,0x08,0x00,0x00,0x52,0xa8,0x1b,0x01
	.byte 0x01,0x00,0x00,0x52,0xe0,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x00,0x08,0x00,0x00
	.byte 0x52,0xc9,0x1b,0x01,0x01,0x00,0x00,0x52
	.byte 0xf7,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x00,0x08,0x00,0x00,0x52
	.byte 0xe5,0x1b,0x01,0x01,0x00,0x00,0x53,0x0e
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x01,0x00,0x08,0x00,0x00,0x52,0xfc
	.byte 0x1b,0x01,0x01,0x00,0x00,0x53,0x25,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x00,0x08,0x00,0x00,0x53,0x13,0x11
	.byte 0x00,0x00,0x3a,0x3a,0x08,0x00,0x00,0x53
	.byte 0x2a,0x1b,0x01,0x01,0x00,0x00,0x53,0x50
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x53,0x2f,0x00,0x08,0x00,0x00
	.byte 0x53,0x34,0x1b,0x01,0x01,0x00,0x00,0x53
	.byte 0x62,0x1c,0x00,0x00,0x45,0x19,0x00,0x08
	.byte 0x00,0x00,0x53,0x55,0x11,0x00,0x00,0x3a
	.byte 0x3a,0x08,0x00,0x00,0x53,0x67,0x1b,0x01
	.byte 0x01,0x00,0x00,0x53,0x8d,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x53
	.byte 0x6c,0x00,0x08,0x00,0x00,0x53,0x71,0x1d
	.byte 0x01,0x00,0x00,0x3a,0x16,0x01,0x00,0x00
	.byte 0x53,0xa8,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x00,0x08,0x00,0x00
	.byte 0x53,0x92,0x1d,0x01,0x00,0x00,0x3a,0x16
	.byte 0x01,0x00,0x00,0x53,0xc3,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x02,0x1d,0x00
	.byte 0x08,0x00,0x00,0x53,0xad,0x1d,0x01,0x00
	.byte 0x00,0x3a,0x16,0x01,0x00,0x00,0x53,0xde
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x00,0x08,0x00,0x00,0x53,0xc8
	.byte 0x11,0x00,0x00,0x02,0x01,0x08,0x00,0x00
	.byte 0x53,0xe3,0x1b,0x01,0x01,0x00,0x00,0x54
	.byte 0x04,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x53,0xe8
	.byte 0x00,0x08,0x00,0x00,0x53,0xed,0x11,0x00
	.byte 0x00,0x02,0x01,0x08,0x00,0x00,0x54,0x09
	.byte 0x1b,0x01,0x01,0x00,0x00,0x54,0x34,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x54,0x0e,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x00,0x08,0x00,0x00,0x54,0x13,0x1b,0x01
	.byte 0x01,0x00,0x00,0x54,0x50,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x50,0xcb,0x00,0x08,0x00,0x00
	.byte 0x54,0x39,0x1b,0x01,0x01,0x00,0x00,0x54
	.byte 0x67,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x54
	.byte 0x55,0x1b,0x01,0x01,0x00,0x00,0x54,0x7e
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x00,0x08,0x00,0x00,0x54,0x6c
	.byte 0x1b,0x01,0x01,0x00,0x00,0x54,0x90,0x1c
	.byte 0x00,0x00,0x45,0x19,0x00,0x08,0x00,0x00
	.byte 0x54,0x83,0x11,0x00,0x00,0x02,0x01,0x08
	.byte 0x00,0x00,0x54,0x95,0x1b,0x01,0x01,0x00
	.byte 0x00,0x54,0xb1,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x54,0x9a,0x00,0x08,0x00
	.byte 0x00,0x54,0x9f,0x1b,0x01,0x01,0x00,0x00
	.byte 0x54,0xc8,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x00,0x08,0x00,0x00
	.byte 0x54,0xb6,0x1b,0x01,0x01,0x00,0x00,0x54
	.byte 0xdf,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x00,0x08,0x00,0x00,0x54
	.byte 0xcd,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x54,0xe4,0x1b,0x01,0x01,0x00,0x00
	.byte 0x55,0x1e,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x54,0xe9,0x1c,0x00,0x00
	.byte 0x3a,0x16,0x00,0x08,0x00,0x00,0x54,0xee
	.byte 0x11,0x00,0x00,0x02,0x01,0x08,0x00,0x00
	.byte 0x55,0x23,0x1b,0x01,0x01,0x00,0x00,0x55
	.byte 0x71,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x55,0x28
	.byte 0x1c,0x00,0x00,0x3a,0x16,0x00,0x08,0x00
	.byte 0x00,0x55,0x2d,0x1b,0x01,0x01,0x00,0x00
	.byte 0x55,0x92,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x00,0x08
	.byte 0x00,0x00,0x55,0x76,0x1b,0x01,0x01,0x00
	.byte 0x00,0x55,0xc2,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x00,0x08
	.byte 0x00,0x00,0x55,0x97,0x11,0x00,0x00,0x02
	.byte 0x01,0x08,0x00,0x00,0x55,0xc7,0x1b,0x01
	.byte 0x01,0x00,0x00,0x55,0xed,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x55
	.byte 0xcc,0x00,0x08,0x00,0x00,0x55,0xd1,0x1b
	.byte 0x01,0x01,0x00,0x00,0x56,0x04,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x00,0x08,0x00,0x00,0x55,0xf2,0x11,0x00
	.byte 0x00,0x02,0x01,0x08,0x00,0x00,0x56,0x09
	.byte 0x1b,0x01,0x01,0x00,0x00,0x56,0x25,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x56
	.byte 0x0e,0x00,0x08,0x00,0x00,0x56,0x13,0x1b
	.byte 0x01,0x01,0x00,0x00,0x56,0x41,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x1d
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x00,0x08,0x00
	.byte 0x00,0x56,0x2a,0x1b,0x01,0x01,0x00,0x00
	.byte 0x56,0x62,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x00,0x08
	.byte 0x00,0x00,0x56,0x46,0x11,0x00,0x00,0x02
	.byte 0x01,0x08,0x00,0x00,0x56,0x67,0x1b,0x01
	.byte 0x01,0x00,0x00,0x56,0x83,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x56,0x6c,0x00
	.byte 0x08,0x00,0x00,0x56,0x71,0x11,0x00,0x00
	.byte 0x3a,0x3a,0x08,0x00,0x00,0x56,0x88,0x1b
	.byte 0x01,0x01,0x00,0x00,0x56,0xae,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x56,0x8d,0x00,0x08,0x00,0x00,0x56,0x92
	.byte 0x1b,0x01,0x01,0x00,0x00,0x56,0xde,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x36
	.byte 0xc7,0x1c,0x00,0x00,0x36,0xc7,0x1c,0x00
	.byte 0x00,0x36,0xc7,0x1c,0x00,0x00,0x36,0xc7
	.byte 0x1c,0x00,0x00,0x36,0xc7,0x1c,0x00,0x00
	.byte 0x36,0xc7,0x00,0x08,0x00,0x00,0x56,0xb3
	.byte 0x1b,0x01,0x01,0x00,0x00,0x56,0xf5,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x01,0x00,0x08,0x00,0x00,0x56,0xe3,0x11
	.byte 0x00,0x00,0x02,0x01,0x08,0x00,0x00,0x56
	.byte 0xfa,0x1b,0x01,0x01,0x00,0x00,0x57,0x20
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x56,0xff,0x00,0x08,0x00,0x00
	.byte 0x57,0x04,0x1b,0x01,0x01,0x00,0x00,0x57
	.byte 0x3c,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x00,0x08,0x00,0x00,0x57,0x25,0x1b,0x01
	.byte 0x01,0x00,0x00,0x57,0x58,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x02,0x01,0x00,0x08,0x00,0x00
	.byte 0x57,0x41,0x1b,0x01,0x01,0x00,0x00,0x57
	.byte 0x74,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x01,0x1c,0x00,0x00,0x02,0x01
	.byte 0x00,0x08,0x00,0x00,0x57,0x5d,0x11,0x00
	.byte 0x00,0x02,0x01,0x08,0x00,0x00,0x57,0x79
	.byte 0x1b,0x01,0x01,0x00,0x00,0x57,0x9a,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x57,0x7e,0x00,0x08
	.byte 0x00,0x00,0x57,0x83,0x1b,0x01,0x01,0x00
	.byte 0x00,0x57,0xb1,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x57,0x9f,0x1b,0x01,0x01,0x00,0x00
	.byte 0x57,0xcd,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x00,0x08,0x00,0x00,0x57,0xb6,0x1b
	.byte 0x01,0x01,0x00,0x00,0x57,0xe9,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x57,0xd2,0x11,0x00,0x00,0x3a,0x16
	.byte 0x08,0x00,0x00,0x57,0xee,0x1b,0x01,0x01
	.byte 0x00,0x00,0x58,0x0a,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x57,0xf3,0x00,0x08
	.byte 0x00,0x00,0x57,0xf8,0x1b,0x01,0x01,0x00
	.byte 0x00,0x58,0x1c,0x1c,0x00,0x00,0x45,0x19
	.byte 0x00,0x08,0x00,0x00,0x58,0x0f,0x1b,0x01
	.byte 0x01,0x00,0x00,0x58,0x2e,0x1c,0x00,0x00
	.byte 0x45,0x19,0x00,0x08,0x00,0x00,0x58,0x21
	.byte 0x1b,0x01,0x01,0x00,0x00,0x58,0x40,0x1c
	.byte 0x00,0x00,0x45,0x19,0x00,0x08,0x00,0x00
	.byte 0x58,0x33,0x1b,0x01,0x01,0x00,0x00,0x58
	.byte 0x52,0x1c,0x00,0x00,0x45,0x19,0x00,0x08
	.byte 0x00,0x00,0x58,0x45,0x1b,0x01,0x01,0x00
	.byte 0x00,0x58,0x69,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x1d,0x00,0x08,0x00
	.byte 0x00,0x58,0x57,0x1b,0x01,0x01,0x00,0x00
	.byte 0x58,0x80,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x00,0x08,0x00,0x00
	.byte 0x58,0x6e,0x1b,0x01,0x01,0x00,0x00,0x58
	.byte 0x92,0x1c,0x00,0x00,0x45,0x19,0x00,0x08
	.byte 0x00,0x00,0x58,0x85,0x1b,0x01,0x01,0x00
	.byte 0x00,0x58,0xa9,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x1d,0x00,0x08,0x00
	.byte 0x00,0x58,0x97,0x1b,0x01,0x01,0x00,0x00
	.byte 0x58,0xcf,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x58
	.byte 0xae,0x1b,0x01,0x01,0x00,0x00,0x58,0xe6
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x00,0x08,0x00,0x00,0x58,0xd4
	.byte 0x1b,0x01,0x01,0x00,0x00,0x59,0x1b,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x3a,0x42,0x00
	.byte 0x08,0x00,0x00,0x58,0xeb,0x1b,0x01,0x01
	.byte 0x00,0x00,0x59,0x41,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x59,0x20,0x1d,0x01,0x00,0x00,0x01
	.byte 0x3a,0x01,0x00,0x00,0x59,0x5c,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x00,0x08,0x00,0x00,0x59,0x46,0x1b,0x01
	.byte 0x01,0x00,0x00,0x59,0x82,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x00,0x08
	.byte 0x00,0x00,0x59,0x61,0x1b,0x01,0x01,0x00
	.byte 0x00,0x59,0xa3,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x00
	.byte 0x08,0x00,0x00,0x59,0x87,0x1b,0x01,0x01
	.byte 0x00,0x00,0x59,0xc9,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x00,0x08,0x00
	.byte 0x00,0x59,0xa8,0x1b,0x01,0x01,0x00,0x00
	.byte 0x59,0xe5,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x4e
	.byte 0x73,0x00,0x08,0x00,0x00,0x59,0xce,0x1b
	.byte 0x01,0x01,0x00,0x00,0x59,0xfc,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x00,0x08,0x00,0x00,0x59,0xea,0x1b,0x01
	.byte 0x01,0x00,0x00,0x5a,0x1d,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x08,0x00,0x00,0x5a,0x01,0x1b
	.byte 0x01,0x01,0x00,0x00,0x5a,0x34,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x1d
	.byte 0x00,0x08,0x00,0x00,0x5a,0x22,0x1b,0x01
	.byte 0x01,0x00,0x00,0x5a,0x55,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x00,0x08,0x00,0x00,0x5a,0x39,0x1b
	.byte 0x01,0x01,0x00,0x00,0x5a,0x71,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x00,0x08,0x00
	.byte 0x00,0x5a,0x5a,0x1b,0x01,0x01,0x00,0x00
	.byte 0x5a,0x97,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x5a
	.byte 0x76,0x11,0x00,0x00,0x3a,0x3a,0x08,0x00
	.byte 0x00,0x5a,0x9c,0x1b,0x01,0x01,0x00,0x00
	.byte 0x5a,0xc7,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x5a,0xa1,0x00,0x08,0x00,0x00,0x5a
	.byte 0xa6,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x5a,0xcc,0x1b,0x01,0x01,0x00,0x00
	.byte 0x5a,0xf2,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x5a,0xd1,0x00,0x08
	.byte 0x00,0x00,0x5a,0xd6,0x11,0x00,0x00,0x02
	.byte 0x01,0x08,0x00,0x00,0x5a,0xf7,0x1b,0x01
	.byte 0x01,0x00,0x00,0x5b,0x1d,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x5a
	.byte 0xfc,0x00,0x08,0x00,0x00,0x5b,0x01,0x1b
	.byte 0x01,0x01,0x00,0x00,0x5b,0x57,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x49,0x68,0x00,0x08,0x00,0x00,0x5b
	.byte 0x22,0x1b,0x01,0x01,0x00,0x00,0x5b,0x96
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x49,0x68,0x00,0x08,0x00,0x00,0x5b,0x5c
	.byte 0x1b,0x01,0x01,0x00,0x00,0x5b,0xcb,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x49,0x68,0x00
	.byte 0x08,0x00,0x00,0x5b,0x9b,0x1b,0x01,0x01
	.byte 0x00,0x00,0x5c,0x0a,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x49,0x68,0x00,0x08
	.byte 0x00,0x00,0x5b,0xd0,0x1b,0x01,0x01,0x00
	.byte 0x00,0x5c,0x4e,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x49,0x68,0x00,0x08,0x00,0x00,0x5c,0x0f
	.byte 0x1b,0x01,0x01,0x00,0x00,0x5c,0x97,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00
	.byte 0x00,0x49,0x68,0x00,0x08,0x00,0x00,0x5c
	.byte 0x53,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x5c,0x9c,0x1b,0x01,0x01,0x00,0x00
	.byte 0x5c,0xc2,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x5c,0xa1,0x00,0x08
	.byte 0x00,0x00,0x5c,0xa6,0x1b,0x01,0x01,0x00
	.byte 0x00,0x5c,0xe3,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x00
	.byte 0x08,0x00,0x00,0x5c,0xc7,0x1b,0x01,0x01
	.byte 0x00,0x00,0x5c,0xff,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x5c
	.byte 0xe8,0x1b,0x01,0x01,0x00,0x00,0x5d,0x20
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x02,0x01,0x00,0x08,0x00,0x00
	.byte 0x5d,0x04,0x1b,0x01,0x01,0x00,0x00,0x5d
	.byte 0x46,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x01,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x00,0x08,0x00,0x00,0x5d,0x25
	.byte 0x11,0x00,0x00,0x02,0x01,0x08,0x00,0x00
	.byte 0x5d,0x4b,0x1b,0x01,0x01,0x00,0x00,0x5d
	.byte 0x67,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x5d,0x50,0x00,0x08,0x00,0x00,0x5d
	.byte 0x55,0x11,0x00,0x00,0x3a,0x3a,0x08,0x00
	.byte 0x00,0x5d,0x6c,0x1b,0x01,0x01,0x00,0x00
	.byte 0x5d,0x97,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x5d,0x71,0x00,0x08,0x00,0x00,0x5d
	.byte 0x76,0x1b,0x01,0x01,0x00,0x00,0x5d,0xbd
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x00,0x08,0x00,0x00,0x5d,0x9c,0x1b
	.byte 0x01,0x01,0x00,0x00,0x5d,0xe3,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x01
	.byte 0x1c,0x00,0x00,0x02,0x01,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x00
	.byte 0x08,0x00,0x00,0x5d,0xc2,0x1b,0x01,0x01
	.byte 0x00,0x00,0x5d,0xf5,0x1c,0x00,0x00,0x45
	.byte 0x19,0x00,0x08,0x00,0x00,0x5d,0xe8,0x1a
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x03,0x00,0x00,0x6c,0x9e,0x17
	.ascii "Accum\0"
	.byte 0x00,0x00,0x45,0x35,0x02,0x23,0x00,0x17
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x45,0x51,0x02,0x23,0x04,0x17
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x45,0x80,0x02,0x23,0x08,0x17
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x45,0x97,0x02,0x23,0x0c,0x17
	.ascii "Begin\0"
	.byte 0x00,0x00,0x45,0xae,0x02,0x23,0x10,0x17
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x45,0xca,0x02,0x23,0x14,0x17
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x46,0xb8,0x02,0x23,0x18,0x17
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x46,0xde,0x02,0x23,0x1c,0x17
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x46,0xf5,0x02,0x23,0x20,0x17
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x47,0x11,0x02,0x23,0x24,0x17
	.ascii "CallList\0"
	.byte 0x00,0x00,0x47,0x28,0x02,0x23,0x28,0x17
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x47,0x53,0x02,0x23,0x2c,0x17
	.ascii "Clear\0"
	.byte 0x00,0x00,0x47,0x6a,0x02,0x23,0x30,0x17
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x47,0x90,0x02,0x23,0x34,0x17
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x47,0xb6,0x02,0x23,0x38,0x17
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x47,0xcd,0x02,0x23,0x3c,0x17
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x47,0xe4,0x02,0x23,0x40,0x17
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x47,0xfb,0x02,0x23,0x44,0x17
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x48,0x21,0x02,0x23,0x48,0x17
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x48,0x42,0x02,0x23,0x4c,0x17
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x48,0x63,0x02,0x23,0x50,0x17
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x48,0x89,0x02,0x23,0x54,0x17
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x48,0xaa,0x02,0x23,0x58,0x17
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x48,0xd0,0x02,0x23,0x5c,0x17
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x48,0xf1,0x02,0x23,0x60,0x17
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x49,0x17,0x02,0x23,0x64,0x17
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x49,0x33,0x02,0x23,0x68,0x17
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x49,0x63,0x02,0x23,0x6c,0x17
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x49,0x89,0x02,0x23,0x70,0x17
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x49,0xaa,0x02,0x23,0x74,0x17
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x49,0xd5,0x02,0x23,0x78,0x17
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x4a,0x0a,0x02,0x23,0x7c,0x17
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x4a,0x44,0x03,0x23,0x80,0x01
	.byte 0x17
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x4a,0x74,0x03,0x23,0x84,0x01
	.byte 0x17
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x4a,0xae,0x03,0x23,0x88,0x01
	.byte 0x17
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x4a,0xed,0x03,0x23,0x8c,0x01
	.byte 0x17
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x4b,0x04,0x03,0x23,0x90,0x01
	.byte 0x17
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x4b,0x20,0x03,0x23,0x94,0x01
	.byte 0x17
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x4b,0x46,0x03,0x23,0x98,0x01
	.byte 0x17
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x4b,0x5d,0x03,0x23,0x9c,0x01
	.byte 0x17
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x4b,0x74,0x03,0x23,0xa0,0x01
	.byte 0x17
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x4b,0x90,0x03,0x23,0xa4,0x01
	.byte 0x17
	.ascii "Disable\0"
	.byte 0x00,0x00,0x4b,0xa7,0x03,0x23,0xa8,0x01
	.byte 0x17
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x4b,0xbe,0x03,0x23,0xac,0x01
	.byte 0x17
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x4b,0xdf,0x03,0x23,0xb0,0x01
	.byte 0x17
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x4b,0xf6,0x03,0x23,0xb4,0x01
	.byte 0x17
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x4c,0x26,0x03,0x23,0xb8,0x01
	.byte 0x17
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x4c,0x5b,0x03,0x23,0xbc,0x01
	.byte 0x17
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x4c,0x72,0x03,0x23,0xc0,0x01
	.byte 0x17
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x4c,0x98,0x03,0x23,0xc4,0x01
	.byte 0x17
	.ascii "Enable\0"
	.byte 0x00,0x00,0x4c,0xaf,0x03,0x23,0xc8,0x01
	.byte 0x17
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x4c,0xc6,0x03,0x23,0xcc,0x01
	.byte 0x17
	.ascii "End\0"
	.byte 0x00,0x00,0x4c,0xd8,0x03,0x23,0xd0,0x01
	.byte 0x17
	.ascii "EndList\0"
	.byte 0x00,0x00,0x4c,0xea,0x03,0x23,0xd4,0x01
	.byte 0x17
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x4d,0x01,0x03,0x23,0xd8,0x01
	.byte 0x17
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x4d,0x1d,0x03,0x23,0xdc,0x01
	.byte 0x17
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x4d,0x3e,0x03,0x23,0xe0,0x01
	.byte 0x17
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x4d,0x69,0x03,0x23,0xe4,0x01
	.byte 0x17
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x4d,0x80,0x03,0x23,0xe8,0x01
	.byte 0x17
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x4d,0x9c,0x03,0x23,0xec,0x01
	.byte 0x17
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x4d,0xc2,0x03,0x23,0xf0,0x01
	.byte 0x17
	.ascii "Finish\0"
	.byte 0x00,0x00,0x4d,0xd4,0x03,0x23,0xf4,0x01
	.byte 0x17
	.ascii "Flush\0"
	.byte 0x00,0x00,0x4d,0xe6,0x03,0x23,0xf8,0x01
	.byte 0x17
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x4e,0x0c,0x03,0x23,0xfc,0x01
	.byte 0x17
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x4e,0x23,0x03,0x23,0x80,0x02
	.byte 0x17
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x4e,0x53,0x03,0x23,0x84,0x02
	.byte 0x17
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x4e,0x6e,0x03,0x23,0x88,0x02
	.byte 0x17
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x4e,0x8f,0x03,0x23,0x8c,0x02
	.byte 0x17
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x4e,0xab,0x03,0x23,0x90,0x02
	.byte 0x17
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x4e,0xcc,0x03,0x23,0x94,0x02
	.byte 0x17
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x4e,0xf2,0x03,0x23,0x98,0x02
	.byte 0x17
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x4f,0x18,0x03,0x23,0x9c,0x02
	.byte 0x17
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x4f,0x34,0x03,0x23,0xa0,0x02
	.byte 0x17
	.ascii "GetError\0"
	.byte 0x00,0x00,0x4f,0x4a,0x03,0x23,0xa4,0x02
	.byte 0x17
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x4f,0x66,0x03,0x23,0xa8,0x02
	.byte 0x17
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x4f,0x82,0x03,0x23,0xac,0x02
	.byte 0x17
	.ascii "GetString\0"
	.byte 0x00,0x00,0x4f,0xa7,0x03,0x23,0xb0,0x02
	.byte 0x17
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x4f,0xc8,0x03,0x23,0xb4,0x02
	.byte 0x17
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x4f,0xe9,0x03,0x23,0xb8,0x02
	.byte 0x17
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x50,0x0a,0x03,0x23,0xbc,0x02
	.byte 0x17
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x50,0x2b,0x03,0x23,0xc0,0x02
	.byte 0x17
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x50,0x4c,0x03,0x23,0xc4,0x02
	.byte 0x17
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x50,0x6d,0x03,0x23,0xc8,0x02
	.byte 0x17
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x50,0x8e,0x03,0x23,0xcc,0x02
	.byte 0x17
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x50,0xaa,0x03,0x23,0xd0,0x02
	.byte 0x17
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x50,0xc6,0x03,0x23,0xd4,0x02
	.byte 0x17
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x50,0xf9,0x03,0x23,0xd8,0x02
	.byte 0x17
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x51,0x1a,0x03,0x23,0xdc,0x02
	.byte 0x17
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x51,0x31,0x03,0x23,0xe0,0x02
	.byte 0x17
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x51,0x66,0x03,0x23,0xe4,0x02
	.byte 0x17
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x51,0x87,0x03,0x23,0xe8,0x02
	.byte 0x17
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x51,0xa8,0x03,0x23,0xec,0x02
	.byte 0x17
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x51,0xc9,0x03,0x23,0xf0,0x02
	.byte 0x17
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x51,0xea,0x03,0x23,0xf4,0x02
	.byte 0x17
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x52,0x0b,0x03,0x23,0xf8,0x02
	.byte 0x17
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x52,0x36,0x03,0x23,0xfc,0x02
	.byte 0x17
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x52,0x5c,0x03,0x23,0x80,0x03
	.byte 0x17
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x52,0x82,0x03,0x23,0x84,0x03
	.byte 0x17
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x52,0xa3,0x03,0x23,0x88,0x03
	.byte 0x17
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x52,0xc4,0x03,0x23,0x8c,0x03
	.byte 0x17
	.ascii "Hint\0"
	.byte 0x00,0x00,0x52,0xe0,0x03,0x23,0x90,0x03
	.byte 0x17
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x52,0xf7,0x03,0x23,0x94,0x03
	.byte 0x17
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x53,0x0e,0x03,0x23,0x98,0x03
	.byte 0x17
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x53,0x25,0x03,0x23,0x9c,0x03
	.byte 0x17
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x53,0x50,0x03,0x23,0xa0,0x03
	.byte 0x17
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x53,0x62,0x03,0x23,0xa4,0x03
	.byte 0x17
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x53,0x8d,0x03,0x23,0xa8,0x03
	.byte 0x17
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x53,0xa8,0x03,0x23,0xac,0x03
	.byte 0x17
	.ascii "IsList\0"
	.byte 0x00,0x00,0x53,0xc3,0x03,0x23,0xb0,0x03
	.byte 0x17
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x53,0xde,0x03,0x23,0xb4,0x03
	.byte 0x17
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x54,0x04,0x03,0x23,0xb8,0x03
	.byte 0x17
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x54,0x34,0x03,0x23,0xbc,0x03
	.byte 0x17
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x54,0x50,0x03,0x23,0xc0,0x03
	.byte 0x17
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x54,0x67,0x03,0x23,0xc4,0x03
	.byte 0x17
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x54,0x7e,0x03,0x23,0xc8,0x03
	.byte 0x17
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x54,0x90,0x03,0x23,0xcc,0x03
	.byte 0x17
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x54,0xb1,0x03,0x23,0xd0,0x03
	.byte 0x17
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x54,0xc8,0x03,0x23,0xd4,0x03
	.byte 0x17
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x54,0xdf,0x03,0x23,0xd8,0x03
	.byte 0x17
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x55,0x1e,0x03,0x23,0xdc,0x03
	.byte 0x17
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x55,0x71,0x03,0x23,0xe0,0x03
	.byte 0x17
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x55,0x92,0x03,0x23,0xe4,0x03
	.byte 0x17
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x55,0xc2,0x03,0x23,0xe8,0x03
	.byte 0x17
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x55,0xed,0x03,0x23,0xec,0x03
	.byte 0x17
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x56,0x04,0x03,0x23,0xf0,0x03
	.byte 0x17
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x56,0x25,0x03,0x23,0xf4,0x03
	.byte 0x17
	.ascii "NewList\0"
	.byte 0x00,0x00,0x56,0x41,0x03,0x23,0xf8,0x03
	.byte 0x17
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x56,0x62,0x03,0x23,0xfc,0x03
	.byte 0x17
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x56,0x83,0x03,0x23,0x80,0x04
	.byte 0x17
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x56,0xae,0x03,0x23,0x84,0x04
	.byte 0x17
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x56,0xde,0x03,0x23,0x88,0x04
	.byte 0x17
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x56,0xf5,0x03,0x23,0x8c,0x04
	.byte 0x17
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x57,0x20,0x03,0x23,0x90,0x04
	.byte 0x17
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x57,0x3c,0x03,0x23,0x94,0x04
	.byte 0x17
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x57,0x58,0x03,0x23,0x98,0x04
	.byte 0x17
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x57,0x74,0x03,0x23,0x9c,0x04
	.byte 0x17
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x57,0x9a,0x03,0x23,0xa0,0x04
	.byte 0x17
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x57,0xb1,0x03,0x23,0xa4,0x04
	.byte 0x17
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x57,0xcd,0x03,0x23,0xa8,0x04
	.byte 0x17
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x57,0xe9,0x03,0x23,0xac,0x04
	.byte 0x17
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x58,0x0a,0x03,0x23,0xb0,0x04
	.byte 0x17
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x58,0x1c,0x03,0x23,0xb4,0x04
	.byte 0x17
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x58,0x2e,0x03,0x23,0xb8,0x04
	.byte 0x17
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x58,0x40,0x03,0x23,0xbc,0x04
	.byte 0x17
	.ascii "PopName\0"
	.byte 0x00,0x00,0x58,0x52,0x03,0x23,0xc0,0x04
	.byte 0x17
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x58,0x69,0x03,0x23,0xc4,0x04
	.byte 0x17
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x58,0x80,0x03,0x23,0xc8,0x04
	.byte 0x17
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x58,0x92,0x03,0x23,0xcc,0x04
	.byte 0x17
	.ascii "PushName\0"
	.byte 0x00,0x00,0x58,0xa9,0x03,0x23,0xd0,0x04
	.byte 0x17
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x58,0xcf,0x03,0x23,0xd4,0x04
	.byte 0x17
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x58,0xe6,0x03,0x23,0xd8,0x04
	.byte 0x17
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x59,0x1b,0x03,0x23,0xdc,0x04
	.byte 0x17
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x59,0x41,0x03,0x23,0xe0,0x04
	.byte 0x17
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x59,0x5c,0x03,0x23,0xe4,0x04
	.byte 0x17
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x59,0x82,0x03,0x23,0xe8,0x04
	.byte 0x17
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x59,0xa3,0x03,0x23,0xec,0x04
	.byte 0x17
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x59,0xc9,0x03,0x23,0xf0,0x04
	.byte 0x17
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x59,0xe5,0x03,0x23,0xf4,0x04
	.byte 0x17
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x59,0xfc,0x03,0x23,0xf8,0x04
	.byte 0x17
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x5a,0x1d,0x03,0x23,0xfc,0x04
	.byte 0x17
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x5a,0x34,0x03,0x23,0x80,0x05
	.byte 0x17
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x5a,0x55,0x03,0x23,0x84,0x05
	.byte 0x17
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x5a,0x71,0x03,0x23,0x88,0x05
	.byte 0x17
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x5a,0x97,0x03,0x23,0x8c,0x05
	.byte 0x17
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x5a,0xc7,0x03,0x23,0x90,0x05
	.byte 0x17
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x5a,0xf2,0x03,0x23,0x94,0x05
	.byte 0x17
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x5b,0x1d,0x03,0x23,0x98,0x05
	.byte 0x17
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x5b,0x57,0x03,0x23,0x9c,0x05
	.byte 0x17
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x5b,0x96,0x03,0x23,0xa0,0x05
	.byte 0x17
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x5b,0xcb,0x03,0x23,0xa4,0x05
	.byte 0x17
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x5c,0x0a,0x03,0x23,0xa8,0x05
	.byte 0x17
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x5c,0x4e,0x03,0x23,0xac,0x05
	.byte 0x17
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x5c,0x97,0x03,0x23,0xb0,0x05
	.byte 0x17
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x5c,0xc2,0x03,0x23,0xb4,0x05
	.byte 0x17
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x5c,0xe3,0x03,0x23,0xb8,0x05
	.byte 0x17
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x5c,0xff,0x03,0x23,0xbc,0x05
	.byte 0x17
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x5d,0x20,0x03,0x23,0xc0,0x05
	.byte 0x17
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x5d,0x46,0x03,0x23,0xc4,0x05
	.byte 0x17
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x5d,0x67,0x03,0x23,0xc8,0x05
	.byte 0x17
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x5d,0x97,0x03,0x23,0xcc,0x05
	.byte 0x17
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x5d,0xbd,0x03,0x23,0xd0,0x05
	.byte 0x17
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x5d,0xe3,0x03,0x23,0xd4,0x05
	.byte 0x17
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x5d,0xf5,0x03,0x23,0xd8,0x05
	.byte 0x00,0x16
	.ascii "gl_visual\0"
	.byte 0x4c,0x03,0x00,0x00,0x6e,0x46,0x17
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x01,0x17
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x04,0x17
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x08,0x17
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x0c,0x17
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x10,0x17
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x14,0x17
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x20,0x17
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x24,0x17
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x28,0x17
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x2c,0x17
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x30,0x17
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x34,0x17
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x38,0x17
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x3c,0x17
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x40,0x17
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x44,0x17
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x48,0x17
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x49,0x00
	.byte 0x07,0x00,0x00,0x6c,0x9e
	.ascii "GLvisual\0"
	.byte 0x03,0x08,0x00,0x00,0x6e,0x46,0x07,0x00
	.byte 0x00,0x50,0xcb
	.ascii "GLdepth\0"
	.byte 0x03,0x08,0x00,0x00,0x6e,0x5a,0x07,0x00
	.byte 0x00,0x3a,0x16
	.ascii "GLstencil\0"
	.byte 0x03,0x08,0x00,0x00,0x6e,0x6d,0x04
	.ascii "short\0"
	.byte 0x05,0x02,0x07,0x00,0x00,0x6e,0x82
	.ascii "GLaccum\0"
	.byte 0x03,0x08,0x00,0x00,0x6e,0x8b,0x16
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x03,0x00,0x00,0x6f,0x75,0x17
	.ascii "Visual\0"
	.byte 0x00,0x00,0x6e,0x55,0x02,0x23,0x00,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "Height\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x08,0x17
	.ascii "Depth\0"
	.byte 0x00,0x00,0x6e,0x68,0x02,0x23,0x0c,0x17
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x6e,0x7d,0x02,0x23,0x10,0x17
	.ascii "Accum\0"
	.byte 0x00,0x00,0x6e,0x99,0x02,0x23,0x14,0x17
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x3a,0x35,0x02,0x23,0x18,0x17
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x3a,0x35,0x02,0x23,0x1c,0x17
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x3a,0x35,0x02,0x23,0x20,0x17
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x05,0x72
	.byte 0x02,0x23,0x24,0x17
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x28,0x17
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x2c,0x17
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x30,0x00
	.byte 0x07,0x00,0x00,0x6e,0x9e
	.ascii "GLframebuffer\0"
	.byte 0x03,0x08,0x00,0x00,0x6f,0x75,0x04
	.ascii "char\0"
	.byte 0x06,0x01,0x11,0x00,0x00,0x6f,0x8e,0x08
	.byte 0x00,0x00,0x6f,0x96,0x1e,0x01,0x00,0x00
	.byte 0x6f,0x9b,0x01,0x08,0x00,0x00,0x6f,0xa0
	.byte 0x1b,0x01,0x01,0x00,0x00,0x6f,0xb9,0x1c
	.byte 0x00,0x00,0x45,0x19,0x00,0x08,0x00,0x00
	.byte 0x6f,0xac,0x1b,0x01,0x01,0x00,0x00,0x6f
	.byte 0xd0,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x00,0x08,0x00,0x00,0x6f
	.byte 0xbe,0x1b,0x01,0x01,0x00,0x00,0x6f,0xf6
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x3a,0x16,0x1c,0x00,0x00,0x3a,0x16,0x1c
	.byte 0x00,0x00,0x3a,0x16,0x1c,0x00,0x00,0x3a
	.byte 0x16,0x00,0x08,0x00,0x00,0x6f,0xd5,0x1b
	.byte 0x01,0x01,0x00,0x00,0x70,0x21,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x3a,0x16
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x00,0x08,0x00,0x00
	.byte 0x6f,0xfb,0x1b,0x01,0x01,0x00,0x00,0x70
	.byte 0x38,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x00,0x08,0x00,0x00,0x70
	.byte 0x26,0x1b,0x01,0x01,0x00,0x00,0x70,0x5e
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x3a,0x16,0x1c,0x00,0x00,0x3a,0x16,0x1c
	.byte 0x00,0x00,0x3a,0x16,0x1c,0x00,0x00,0x3a
	.byte 0x16,0x00,0x08,0x00,0x00,0x70,0x3d,0x1d
	.byte 0x01,0x00,0x00,0x3a,0x16,0x01,0x00,0x00
	.byte 0x70,0x79,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x00,0x08,0x00,0x00
	.byte 0x70,0x63,0x1b,0x01,0x01,0x00,0x00,0x70
	.byte 0x95,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x4e,0x73,0x1c,0x00,0x00,0x4e,0x73
	.byte 0x00,0x08,0x00,0x00,0x70,0x7e,0x11,0x00
	.byte 0x00,0x3a,0x16,0x08,0x00,0x00,0x70,0x9a
	.byte 0x11,0x00,0x00,0x3a,0x16,0x08,0x00,0x00
	.byte 0x70,0xa4,0x11,0x00,0x00,0x3a,0x16,0x08
	.byte 0x00,0x00,0x70,0xae,0x11,0x00,0x00,0x3a
	.byte 0x16,0x08,0x00,0x00,0x70,0xb8,0x11,0x00
	.byte 0x00,0x3a,0x16,0x08,0x00,0x00,0x70,0xc2
	.byte 0x1b,0x01,0x01,0x00,0x00,0x71,0x01,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x70,0x9f
	.byte 0x1c,0x00,0x00,0x70,0xa9,0x1c,0x00,0x00
	.byte 0x70,0xb3,0x1c,0x00,0x00,0x70,0xbd,0x1c
	.byte 0x00,0x00,0x70,0xc7,0x00,0x08,0x00,0x00
	.byte 0x70,0xcc,0x11,0x00,0x00,0x3a,0x16,0x08
	.byte 0x00,0x00,0x71,0x06,0x1b,0x01,0x01,0x00
	.byte 0x00,0x71,0x31,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x71,0x0b,0x00,0x08,0x00,0x00
	.byte 0x71,0x10,0x11,0x00,0x00,0x01,0x3a,0x08
	.byte 0x00,0x00,0x71,0x36,0x11,0x00,0x00,0x01
	.byte 0x3a,0x08,0x00,0x00,0x71,0x40,0x11,0x00
	.byte 0x00,0x3a,0x16,0x08,0x00,0x00,0x71,0x4a
	.byte 0x11,0x00,0x00,0x3a,0x16,0x08,0x00,0x00
	.byte 0x71,0x54,0x11,0x00,0x00,0x3a,0x16,0x08
	.byte 0x00,0x00,0x71,0x5e,0x11,0x00,0x00,0x3a
	.byte 0x16,0x08,0x00,0x00,0x71,0x68,0x11,0x00
	.byte 0x00,0x3a,0x16,0x08,0x00,0x00,0x71,0x72
	.byte 0x1b,0x01,0x01,0x00,0x00,0x71,0xb1,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0x71,0x3b,0x1c,0x00
	.byte 0x00,0x71,0x45,0x1c,0x00,0x00,0x71,0x4f
	.byte 0x1c,0x00,0x00,0x71,0x59,0x1c,0x00,0x00
	.byte 0x71,0x63,0x1c,0x00,0x00,0x71,0x6d,0x1c
	.byte 0x00,0x00,0x71,0x77,0x00,0x08,0x00,0x00
	.byte 0x71,0x7c,0x11,0x00,0x00,0x01,0x3a,0x08
	.byte 0x00,0x00,0x71,0xb6,0x11,0x00,0x00,0x01
	.byte 0x3a,0x08,0x00,0x00,0x71,0xc0,0x11,0x00
	.byte 0x00,0x3a,0x16,0x08,0x00,0x00,0x71,0xca
	.byte 0x1b,0x01,0x01,0x00,0x00,0x71,0xf5,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0x71,0xbb,0x1c,0x00
	.byte 0x00,0x71,0xc5,0x1c,0x00,0x00,0x71,0xcf
	.byte 0x00,0x08,0x00,0x00,0x71,0xd4,0x11,0x00
	.byte 0x00,0x02,0x1d,0x08,0x00,0x00,0x71,0xfa
	.byte 0x11,0x00,0x00,0x3a,0x16,0x08,0x00,0x00
	.byte 0x72,0x04,0x1b,0x01,0x01,0x00,0x00,0x72
	.byte 0x34,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x71,0xff,0x1c,0x00,0x00,0x72,0x09,0x00
	.byte 0x08,0x00,0x00,0x72,0x0e,0x11,0x00,0x00
	.byte 0x3a,0x16,0x08,0x00,0x00,0x72,0x39,0x1b
	.byte 0x01,0x01,0x00,0x00,0x72,0x64,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x1d
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x72,0x3e,0x00
	.byte 0x08,0x00,0x00,0x72,0x43,0x11,0x00,0x00
	.byte 0x01,0x3a,0x08,0x00,0x00,0x72,0x69,0x11
	.byte 0x00,0x00,0x01,0x3a,0x08,0x00,0x00,0x72
	.byte 0x73,0x11,0x00,0x00,0x02,0x1d,0x08,0x00
	.byte 0x00,0x72,0x7d,0x11,0x00,0x00,0x3a,0x16
	.byte 0x08,0x00,0x00,0x72,0x87,0x1b,0x01,0x01
	.byte 0x00,0x00,0x72,0xb7,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00
	.byte 0x00,0x72,0x6e,0x1c,0x00,0x00,0x72,0x78
	.byte 0x1c,0x00,0x00,0x72,0x82,0x1c,0x00,0x00
	.byte 0x72,0x8c,0x00,0x08,0x00,0x00,0x72,0x91
	.byte 0x11,0x00,0x00,0x01,0x3a,0x08,0x00,0x00
	.byte 0x72,0xbc,0x11,0x00,0x00,0x01,0x3a,0x08
	.byte 0x00,0x00,0x72,0xc6,0x11,0x00,0x00,0x3a
	.byte 0x16,0x08,0x00,0x00,0x72,0xd0,0x1b,0x01
	.byte 0x01,0x00,0x00,0x72,0xfb,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c
	.byte 0x00,0x00,0x72,0xc1,0x1c,0x00,0x00,0x72
	.byte 0xcb,0x1c,0x00,0x00,0x72,0xd5,0x00,0x08
	.byte 0x00,0x00,0x72,0xda,0x1b,0x01,0x01,0x00
	.byte 0x00,0x73,0x21,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x4e,0x73,0x00,0x08,0x00,0x00
	.byte 0x73,0x00,0x1b,0x01,0x01,0x00,0x00,0x73
	.byte 0x56,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x3d,0x4a,0x1c,0x00,0x00,0x3d,0x4a,0x1c
	.byte 0x00,0x00,0x3d,0x4a,0x1c,0x00,0x00,0x3d
	.byte 0x4a,0x00,0x08,0x00,0x00,0x73,0x26,0x11
	.byte 0x00,0x00,0x01,0x3a,0x08,0x00,0x00,0x73
	.byte 0x5b,0x11,0x00,0x00,0x01,0x3a,0x08,0x00
	.byte 0x00,0x73,0x65,0x11,0x00,0x00,0x3a,0x16
	.byte 0x08,0x00,0x00,0x73,0x6f,0x1b,0x01,0x01
	.byte 0x00,0x00,0x73,0x9f,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00
	.byte 0x00,0x73,0x60,0x1c,0x00,0x00,0x73,0x6a
	.byte 0x1c,0x00,0x00,0x4e,0x73,0x1c,0x00,0x00
	.byte 0x73,0x74,0x00,0x08,0x00,0x00,0x73,0x79
	.byte 0x11,0x00,0x00,0x01,0x3a,0x08,0x00,0x00
	.byte 0x73,0xa4,0x11,0x00,0x00,0x01,0x3a,0x08
	.byte 0x00,0x00,0x73,0xae,0x11,0x00,0x00,0x3a
	.byte 0x16,0x08,0x00,0x00,0x73,0xb8,0x1b,0x01
	.byte 0x01,0x00,0x00,0x73,0xf7,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c
	.byte 0x00,0x00,0x73,0xa9,0x1c,0x00,0x00,0x73
	.byte 0xb3,0x1c,0x00,0x00,0x3d,0x4a,0x1c,0x00
	.byte 0x00,0x3d,0x4a,0x1c,0x00,0x00,0x3d,0x4a
	.byte 0x1c,0x00,0x00,0x3d,0x4a,0x1c,0x00,0x00
	.byte 0x73,0xbd,0x00,0x08,0x00,0x00,0x73,0xc2
	.byte 0x1b,0x01,0x01,0x00,0x00,0x74,0x09,0x1c
	.byte 0x00,0x00,0x45,0x19,0x00,0x08,0x00,0x00
	.byte 0x73,0xfc,0x1b,0x01,0x01,0x00,0x00,0x74
	.byte 0x1b,0x1c,0x00,0x00,0x45,0x19,0x00,0x08
	.byte 0x00,0x00,0x74,0x0e,0x1d,0x01,0x00,0x00
	.byte 0x3a,0x16,0x01,0x00,0x00,0x74,0x36,0x1c
	.byte 0x00,0x00,0x45,0x19,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x08,0x00,0x00,0x74,0x20,0x1d
	.byte 0x01,0x00,0x00,0x3a,0x16,0x01,0x00,0x00
	.byte 0x74,0x60,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x3a,0x16,0x1c,0x00,0x00,0x3a
	.byte 0x16,0x1c,0x00,0x00,0x3a,0x16,0x1c,0x00
	.byte 0x00,0x3a,0x16,0x00,0x08,0x00,0x00,0x74
	.byte 0x3b,0x1d,0x01,0x00,0x00,0x3a,0x16,0x01
	.byte 0x00,0x00,0x74,0x7b,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x05,0x7e,0x00,0x08
	.byte 0x00,0x00,0x74,0x65,0x1b,0x01,0x01,0x00
	.byte 0x00,0x74,0x92,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x3a,0x16,0x00,0x08,0x00
	.byte 0x00,0x74,0x80,0x1b,0x01,0x01,0x00,0x00
	.byte 0x74,0xa4,0x1c,0x00,0x00,0x45,0x19,0x00
	.byte 0x08,0x00,0x00,0x74,0x97,0x1b,0x01,0x01
	.byte 0x00,0x00,0x74,0xc0,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x01,0x1c,0x00
	.byte 0x00,0x02,0x01,0x00,0x08,0x00,0x00,0x74
	.byte 0xa9,0x1b,0x01,0x01,0x00,0x00,0x74,0xd2
	.byte 0x1c,0x00,0x00,0x45,0x19,0x00,0x08,0x00
	.byte 0x00,0x74,0xc5,0x1b,0x01,0x01,0x00,0x00
	.byte 0x74,0xe4,0x1c,0x00,0x00,0x45,0x19,0x00
	.byte 0x08,0x00,0x00,0x74,0xd7,0x11,0x00,0x00
	.byte 0x50,0xcb,0x08,0x00,0x00,0x74,0xe9,0x1d
	.byte 0x01,0x00,0x00,0x02,0x1d,0x01,0x00,0x00
	.byte 0x75,0x1d,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00
	.byte 0x00,0x74,0xee,0x1c,0x00,0x00,0x3d,0x4a
	.byte 0x00,0x08,0x00,0x00,0x74,0xf3,0x11,0x00
	.byte 0x00,0x01,0x3a,0x08,0x00,0x00,0x75,0x22
	.byte 0x11,0x00,0x00,0x01,0x3a,0x08,0x00,0x00
	.byte 0x75,0x2c,0x11,0x00,0x00,0x50,0xcb,0x08
	.byte 0x00,0x00,0x75,0x36,0x1b,0x01,0x01,0x00
	.byte 0x00,0x75,0x66,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00,0x00
	.byte 0x75,0x27,0x1c,0x00,0x00,0x75,0x31,0x1c
	.byte 0x00,0x00,0x75,0x3b,0x1c,0x00,0x00,0x3d
	.byte 0x4a,0x00,0x08,0x00,0x00,0x75,0x40,0x1b
	.byte 0x01,0x01,0x00,0x00,0x75,0x8c,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x02,0x1d
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x4d,0xa1,0x00
	.byte 0x08,0x00,0x00,0x75,0x6b,0x1b,0x01,0x01
	.byte 0x00,0x00,0x75,0xb2,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00
	.byte 0x00,0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x50,0xdd,0x00,0x08,0x00
	.byte 0x00,0x75,0x91,0x1b,0x01,0x01,0x00,0x00
	.byte 0x75,0xce,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x08,0x00,0x00,0x75,0xb7,0x07
	.byte 0x00,0x00,0x75,0xce
	.ascii "points_func\0"
	.byte 0x03,0x1b,0x01,0x01,0x00,0x00,0x76,0x01
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x1c,0x00,0x00,0x02,0x1d,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x00,0x08,0x00,0x00
	.byte 0x75,0xe5,0x07,0x00,0x00,0x76,0x01
	.ascii "line_func\0"
	.byte 0x03,0x1b,0x01,0x01,0x00,0x00,0x76,0x37
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x1c,0x00,0x00,0x02,0x1d,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x08,0x00,0x00,0x76,0x16,0x07
	.byte 0x00,0x00,0x76,0x37
	.ascii "triangle_func\0"
	.byte 0x03,0x1b,0x01,0x01,0x00,0x00,0x76,0x76
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x02,0x1d,0x1c,0x00,0x00,0x02,0x1d,0x1c
	.byte 0x00,0x00,0x02,0x1d,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0x02,0x1d,0x00,0x08
	.byte 0x00,0x00,0x76,0x50,0x07,0x00,0x00,0x76
	.byte 0x76
	.ascii "quad_func\0"
	.byte 0x03,0x1b,0x01,0x01,0x00,0x00,0x76,0xac
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x01
	.byte 0x3a,0x00,0x08,0x00,0x00,0x76,0x8b,0x07
	.byte 0x00,0x00,0x76,0xac
	.ascii "rect_func\0"
	.byte 0x03,0x11,0x00,0x00,0x3a,0x3a,0x08,0x00
	.byte 0x00,0x76,0xc1,0x1d,0x01,0x00,0x00,0x3a
	.byte 0x16,0x01,0x00,0x00,0x77,0x04,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x01,0x3a,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x05
	.byte 0x7e,0x1c,0x00,0x00,0x3a,0x16,0x1c,0x00
	.byte 0x00,0x76,0xc6,0x00,0x08,0x00,0x00,0x76
	.byte 0xcb,0x11,0x00,0x00,0x45,0xe1,0x08,0x00
	.byte 0x00,0x77,0x09,0x1d,0x01,0x00,0x00,0x3a
	.byte 0x16,0x01,0x00,0x00,0x77,0x47,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x01,0x3a
	.byte 0x1c,0x00,0x00,0x01,0x3a,0x1c,0x00,0x00
	.byte 0x02,0x01,0x1c,0x00,0x00,0x02,0x01,0x1c
	.byte 0x00,0x00,0x02,0x01,0x1c,0x00,0x00,0x02
	.byte 0x01,0x1c,0x00,0x00,0x77,0x0e,0x00,0x08
	.byte 0x00,0x00,0x77,0x13,0x1b,0x01,0x01,0x00
	.byte 0x00,0x77,0x5e,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x00,0x08,0x00
	.byte 0x00,0x77,0x4c,0x1b,0x01,0x01,0x00,0x00
	.byte 0x77,0x70,0x1c,0x00,0x00,0x45,0x19,0x00
	.byte 0x08,0x00,0x00,0x77,0x63,0x1b,0x01,0x01
	.byte 0x00,0x00,0x77,0x8c,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x02,0x1d,0x1c,0x00
	.byte 0x00,0x02,0x1d,0x00,0x08,0x00,0x00,0x77
	.byte 0x75,0x1d,0x01,0x00,0x00,0x3a,0x16,0x01
	.byte 0x00,0x00,0x77,0xa7,0x1c,0x00,0x00,0x45
	.byte 0x19,0x1c,0x00,0x00,0x3a,0x16,0x00,0x08
	.byte 0x00,0x00,0x77,0x91,0x11,0x00,0x00,0x02
	.byte 0x01,0x08,0x00,0x00,0x77,0xac,0x1b,0x01
	.byte 0x01,0x00,0x00,0x77,0xcd,0x1c,0x00,0x00
	.byte 0x45,0x19,0x1c,0x00,0x00,0x05,0x7e,0x1c
	.byte 0x00,0x00,0x77,0xb1,0x00,0x08,0x00,0x00
	.byte 0x77,0xb6,0x11,0x00,0x00,0x3a,0x47,0x08
	.byte 0x00,0x00,0x77,0xd2,0x1b,0x01,0x01,0x00
	.byte 0x00,0x78,0x02,0x1c,0x00,0x00,0x45,0x19
	.byte 0x1c,0x00,0x00,0x05,0x7e,0x1c,0x00,0x00
	.byte 0x3d,0xa6,0x1c,0x00,0x00,0x01,0x3a,0x1c
	.byte 0x00,0x00,0x01,0x3a,0x1c,0x00,0x00,0x77
	.byte 0xd7,0x00,0x08,0x00,0x00,0x77,0xdc,0x11
	.byte 0x00,0x00,0x02,0x01,0x08,0x00,0x00,0x78
	.byte 0x07,0x1b,0x01,0x01,0x00,0x00,0x78,0x32
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0x3d,0xa6,0x1c
	.byte 0x00,0x00,0x05,0x7e,0x1c,0x00,0x00,0x78
	.byte 0x0c,0x00,0x08,0x00,0x00,0x78,0x11,0x1b
	.byte 0x01,0x01,0x00,0x00,0x78,0x4e,0x1c,0x00
	.byte 0x00,0x45,0x19,0x1c,0x00,0x00,0x05,0x7e
	.byte 0x1c,0x00,0x00,0x3d,0xa6,0x00,0x08,0x00
	.byte 0x00,0x78,0x37,0x1b,0x01,0x01,0x00,0x00
	.byte 0x78,0x65,0x1c,0x00,0x00,0x45,0x19,0x1c
	.byte 0x00,0x00,0x3d,0xa6,0x00,0x08,0x00,0x00
	.byte 0x78,0x53,0x1b,0x01,0x01,0x00,0x00,0x78
	.byte 0x7c,0x1c,0x00,0x00,0x45,0x19,0x1c,0x00
	.byte 0x00,0x3d,0xa6,0x00,0x08,0x00,0x00,0x78
	.byte 0x6a,0x1b,0x01,0x01,0x00,0x00,0x78,0x93
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x3a,0x16,0x00,0x08,0x00,0x00,0x78,0x81
	.byte 0x16
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x7d,0x00,0x17
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x6f,0xa7,0x02,0x23,0x00,0x17
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x6f,0xb9,0x02,0x23,0x04,0x17
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x6f,0xd0,0x02,0x23,0x08,0x17
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x6f,0xf6,0x02,0x23,0x0c,0x17
	.ascii "Clear\0"
	.byte 0x00,0x00,0x70,0x21,0x02,0x23,0x10,0x17
	.ascii "Index\0"
	.byte 0x00,0x00,0x70,0x38,0x02,0x23,0x14,0x17
	.ascii "Color\0"
	.byte 0x00,0x00,0x70,0x5e,0x02,0x23,0x18,0x17
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x70,0x79,0x02,0x23,0x1c,0x17
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x70,0x95,0x02,0x23,0x20,0x17
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x71,0x01,0x02,0x23,0x24,0x17
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x71,0x31,0x02,0x23,0x28,0x17
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x71,0xb1,0x02,0x23,0x2c,0x17
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x71,0xf5,0x02,0x23,0x30,0x17
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x72,0x34,0x02,0x23,0x34,0x17
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x72,0x64,0x02,0x23,0x38,0x17
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x72,0xb7,0x02,0x23,0x3c,0x17
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x72,0xfb,0x02,0x23,0x40,0x17
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x73,0x21,0x02,0x23,0x44,0x17
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x73,0x56,0x02,0x23,0x48,0x17
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x73,0x9f,0x02,0x23,0x4c,0x17
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x73,0xf7,0x02,0x23,0x50,0x17
	.ascii "Finish\0"
	.byte 0x00,0x00,0x74,0x09,0x02,0x23,0x54,0x17
	.ascii "Flush\0"
	.byte 0x00,0x00,0x74,0x1b,0x02,0x23,0x58,0x17
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x74,0x36,0x02,0x23,0x5c,0x17
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x74,0x60,0x02,0x23,0x60,0x17
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x74,0x7b,0x02,0x23,0x64,0x17
	.ascii "Dither\0"
	.byte 0x00,0x00,0x74,0x92,0x02,0x23,0x68,0x17
	.ascii "Error\0"
	.byte 0x00,0x00,0x74,0xa4,0x02,0x23,0x6c,0x17
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x74,0xc0,0x02,0x23,0x70,0x17
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x74,0xd2,0x02,0x23,0x74,0x17
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x74,0xe4,0x02,0x23,0x78,0x17
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x75,0x1d,0x02,0x23,0x7c,0x17
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x75,0x66,0x03,0x23,0x80,0x01
	.byte 0x17
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x75,0x8c,0x03,0x23,0x84,0x01
	.byte 0x17
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x75,0xb2,0x03,0x23,0x88,0x01
	.byte 0x17
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x75,0xd3,0x03,0x23,0x8c,0x01
	.byte 0x17
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x76,0x06,0x03,0x23,0x90,0x01
	.byte 0x17
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x76,0x3c,0x03,0x23,0x94,0x01
	.byte 0x17
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x76,0x7b,0x03,0x23,0x98,0x01
	.byte 0x17
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x76,0xb1,0x03,0x23,0x9c,0x01
	.byte 0x17
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x77,0x04,0x03,0x23,0xa0,0x01
	.byte 0x17
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x77,0x47,0x03,0x23,0xa4,0x01
	.byte 0x17
	.ascii "Begin\0"
	.byte 0x00,0x00,0x77,0x5e,0x03,0x23,0xa8,0x01
	.byte 0x17
	.ascii "End\0"
	.byte 0x00,0x00,0x77,0x70,0x03,0x23,0xac,0x01
	.byte 0x17
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x77,0x8c,0x03,0x23,0xb0,0x01
	.byte 0x17
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x77,0xa7,0x03,0x23,0xb4,0x01
	.byte 0x17
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x77,0xcd,0x03,0x23,0xb8,0x01
	.byte 0x17
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x78,0x02,0x03,0x23,0xbc,0x01
	.byte 0x17
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x78,0x32,0x03,0x23,0xc0,0x01
	.byte 0x17
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x78,0x4e,0x03,0x23,0xc4,0x01
	.byte 0x17
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x78,0x65,0x03,0x23,0xc8,0x01
	.byte 0x17
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x78,0x7c,0x03,0x23,0xcc,0x01
	.byte 0x17
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x78,0x93,0x03,0x23,0xd0,0x01
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x40,0x00
	.byte 0x00,0x7d,0x11,0x15,0x00,0x00,0x39,0xfd
	.byte 0x0f,0x00,0x14,0x00,0x00,0x02,0x0a,0x40
	.byte 0x00,0x00,0x7d,0x22,0x15,0x00,0x00,0x39
	.byte 0xfd,0x0f,0x00,0x14,0x00,0x00,0x02,0x01
	.byte 0x40,0x00,0x00,0x7d,0x33,0x15,0x00,0x00
	.byte 0x39,0xfd,0x0f,0x00,0x18,0x00,0x00,0x7d
	.byte 0x22,0x08,0x00,0x00,0x00,0x7d,0x45,0x15
	.byte 0x00,0x00,0x39,0xfd,0x1f,0x00,0x14,0x00
	.byte 0x00,0x02,0x0a,0x40,0x00,0x00,0x7d,0x56
	.byte 0x15,0x00,0x00,0x39,0xfd,0x0f,0x00,0x14
	.byte 0x00,0x00,0x02,0x01,0x40,0x00,0x00,0x7d
	.byte 0x67,0x15,0x00,0x00,0x39,0xfd,0x0f,0x00
	.byte 0x18,0x00,0x00,0x7d,0x56,0x08,0x00,0x00
	.byte 0x00,0x7d,0x79,0x15,0x00,0x00,0x39,0xfd
	.byte 0x1f,0x00,0x14,0x00,0x00,0x02,0x01,0x08
	.byte 0x00,0x00,0x7d,0x8a,0x15,0x00,0x00,0x39
	.byte 0xfd,0x01,0x00,0x18,0x00,0x00,0x7d,0x79
	.byte 0x01,0x00,0x00,0x00,0x7d,0x9c,0x15,0x00
	.byte 0x00,0x39,0xfd,0x1f,0x00,0x14,0x00,0x00
	.byte 0x02,0x0a,0x40,0x00,0x00,0x7d,0xad,0x15
	.byte 0x00,0x00,0x39,0xfd,0x0f,0x00,0x14,0x00
	.byte 0x00,0x02,0x01,0x40,0x00,0x00,0x7d,0xbe
	.byte 0x15,0x00,0x00,0x39,0xfd,0x0f,0x00,0x18
	.byte 0x00,0x00,0x7d,0xad,0x02,0x80,0x00,0x00
	.byte 0x7d,0xd0,0x15,0x00,0x00,0x39,0xfd,0x09
	.byte 0x00,0x07,0x00,0x00,0x02,0x1d
	.ascii "GLbitfield\0"
	.byte 0x02,0x08,0x00,0x00,0x7d,0xe6,0x16
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x03,0x00,0x00,0x7e,0x24,0x17
	.ascii "kind\0"
	.byte 0x00,0x00,0x7d,0xd0,0x02,0x23,0x00,0x17
	.ascii "data\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x04,0x17
	.ascii "next\0"
	.byte 0x00,0x00,0x7d,0xe1,0x02,0x23,0x08,0x00
	.byte 0x14,0x00,0x00,0x7d,0xe1,0x40,0x00,0x00
	.byte 0x7e,0x35,0x15,0x00,0x00,0x39,0xfd,0x0f
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x10,0x00
	.byte 0x00,0x7e,0x46,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x16
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x03,0x00,0x00,0x7e,0x71,0x17
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x7e,0x35,0x02,0x23,0x00,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x7e,0x82,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x10,0x00
	.byte 0x00,0x7e,0x93,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x16
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x03,0x00,0x00,0x80,0x42,0x17
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x00,0x17
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x7e,0x71,0x02,0x23,0x04,0x17
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x14,0x17
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x18,0x17
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x1c,0x17
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x20,0x17
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x24,0x17
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x28,0x17
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x2c,0x17
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x3a,0x27,0x02,0x23,0x30,0x17
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x31,0x17
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x34,0x17
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x38,0x17
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x3c,0x17
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x7e,0x82,0x02,0x23,0x40,0x17
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x50,0x17
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x54,0x17
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x55,0x17
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x56,0x17
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x57,0x00
	.byte 0x14,0x00,0x00,0x3a,0x27,0x04,0x00,0x00
	.byte 0x80,0x53,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x0c,0x00
	.byte 0x00,0x80,0x64,0x15,0x00,0x00,0x39,0xfd
	.byte 0x02,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0x80,0x75,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x02,0x0a
	.byte 0x10,0x00,0x00,0x80,0x86,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x14,0x00,0x00,0x02
	.byte 0x0a,0x10,0x00,0x00,0x80,0x97,0x15,0x00
	.byte 0x00,0x39,0xfd,0x03,0x00,0x14,0x00,0x00
	.byte 0x02,0x0a,0x10,0x00,0x00,0x80,0xa8,0x15
	.byte 0x00,0x00,0x39,0xfd,0x03,0x00,0x16
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x03,0x00,0x00,0x81,0x92,0x17
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x80,0x42,0x02,0x23,0x00,0x17
	.ascii "Index\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x04,0x17
	.ascii "Normal\0"
	.byte 0x00,0x00,0x80,0x53,0x02,0x23,0x08,0x17
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x80,0x64,0x02,0x23,0x14,0x17
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x80,0x75,0x02,0x23,0x24,0x17
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x34,0x17
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x80,0x86,0x02,0x23,0x38,0x17
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x48,0x17
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x80,0x97,0x02,0x23,0x4c,0x17
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x5c,0x17
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x5d,0x00
	.byte 0x16
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x03,0x00,0x00,0x81,0xe5,0x17
	.ascii "Func\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "Clear\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x04,0x17
	.ascii "Test\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x08,0x17
	.ascii "Mask\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x09,0x00
	.byte 0x16
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x03,0x00,0x00,0x84,0x4a,0x17
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x01,0x17
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x02,0x17
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x03,0x17
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x04,0x17
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x05,0x17
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x06,0x17
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x07,0x17
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x08,0x17
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x09,0x17
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0a,0x17
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0b,0x17
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0c,0x17
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0d,0x17
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0e,0x17
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0f,0x17
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x10,0x17
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x11,0x17
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x12,0x17
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x14,0x17
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x20,0x17
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x24,0x17
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x28,0x17
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x2c,0x17
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x30,0x17
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x34,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x84,0x5b,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x16
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x03,0x00,0x00,0x84,0xd4,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "Color\0"
	.byte 0x00,0x00,0x84,0x4a,0x02,0x23,0x04,0x17
	.ascii "Density\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x14,0x17
	.ascii "Start\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "End\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "Index\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x20,0x17
	.ascii "Mode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x24,0x00
	.byte 0x16
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x03,0x00,0x00,0x85,0x52,0x17
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x08,0x17
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x0c,0x17
	.ascii "Fog\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x10,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x85,0x63,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x10,0x00
	.byte 0x00,0x85,0x74,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0x85,0x85,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x02,0x0a
	.byte 0x10,0x00,0x00,0x85,0x96,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x14,0x00,0x00,0x02
	.byte 0x0a,0x10,0x00,0x00,0x85,0xa7,0x15,0x00
	.byte 0x00,0x39,0xfd,0x03,0x00,0x1a
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x03,0x00,0x00,0x87,0x69,0x17
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x85,0x52,0x02,0x23,0x00,0x17
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x85,0x63,0x02,0x23,0x10,0x17
	.ascii "Specular\0"
	.byte 0x00,0x00,0x85,0x74,0x02,0x23,0x20,0x17
	.ascii "Position\0"
	.byte 0x00,0x00,0x85,0x85,0x02,0x23,0x30,0x17
	.ascii "Direction\0"
	.byte 0x00,0x00,0x85,0x96,0x02,0x23,0x40,0x17
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x50,0x17
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x54,0x17
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x58,0x17
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x5c,0x17
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x60,0x17
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x64,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x68,0x17
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x87,0x69,0x02,0x23,0x6c,0x17
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x87,0x6e,0x02,0x23,0x70,0x17
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x87,0x7f,0x02,0x23,0x7c,0x17
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x87,0x90,0x03,0x23,0x88,0x01
	.byte 0x17
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x87,0xb2,0x03,0x23,0x94,0x01
	.byte 0x17
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x87,0xd6,0x03,0x23,0x94,0x21
	.byte 0x17
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x87,0xf8,0x03,0x23,0xac,0x21
	.byte 0x17
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x88,0x1a,0x03,0x23,0xc4,0x21
	.byte 0x17
	.ascii "dli\0"
	.byte 0x00,0x00,0x02,0x0a,0x03,0x23,0xdc,0x21
	.byte 0x17
	.ascii "sli\0"
	.byte 0x00,0x00,0x02,0x0a,0x03,0x23,0xe0,0x21
	.byte 0x00,0x08,0x00,0x00,0x85,0xa7,0x14,0x00
	.byte 0x00,0x02,0x0a,0x0c,0x00,0x00,0x87,0x7f
	.byte 0x15,0x00,0x00,0x39,0xfd,0x02,0x00,0x14
	.byte 0x00,0x00,0x02,0x0a,0x0c,0x00,0x00,0x87
	.byte 0x90,0x15,0x00,0x00,0x39,0xfd,0x02,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x0c,0x00,0x00
	.byte 0x87,0xa1,0x15,0x00,0x00,0x39,0xfd,0x02
	.byte 0x00,0x14,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0x87,0xb2,0x15,0x00,0x00,0x39,0xfd
	.byte 0x01,0x00,0x18,0x00,0x00,0x87,0xa1,0x10
	.byte 0x00,0x00,0x00,0x87,0xc5,0x19,0x00,0x00
	.byte 0x39,0xfd,0x01,0xff,0x00,0x14,0x00,0x00
	.byte 0x02,0x01,0x0c,0x00,0x00,0x87,0xd6,0x15
	.byte 0x00,0x00,0x39,0xfd,0x02,0x00,0x14,0x00
	.byte 0x00,0x87,0xc5,0x18,0x00,0x00,0x87,0xe7
	.byte 0x15,0x00,0x00,0x39,0xfd,0x01,0x00,0x14
	.byte 0x00,0x00,0x02,0x01,0x0c,0x00,0x00,0x87
	.byte 0xf8,0x15,0x00,0x00,0x39,0xfd,0x02,0x00
	.byte 0x14,0x00,0x00,0x87,0xe7,0x18,0x00,0x00
	.byte 0x88,0x09,0x15,0x00,0x00,0x39,0xfd,0x01
	.byte 0x00,0x14,0x00,0x00,0x02,0x01,0x0c,0x00
	.byte 0x00,0x88,0x1a,0x15,0x00,0x00,0x39,0xfd
	.byte 0x02,0x00,0x14,0x00,0x00,0x88,0x09,0x18
	.byte 0x00,0x00,0x88,0x2b,0x15,0x00,0x00,0x39
	.byte 0xfd,0x01,0x00,0x18,0x00,0x00,0x85,0xa7
	.byte 0x87,0x20,0x00,0x00,0x88,0x3d,0x15,0x00
	.byte 0x00,0x39,0xfd,0x07,0x00,0x14,0x00,0x00
	.byte 0x02,0x0a,0x10,0x00,0x00,0x88,0x4e,0x15
	.byte 0x00,0x00,0x39,0xfd,0x03,0x00,0x16
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x03,0x00,0x00,0x88,0x98,0x17
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x88,0x3d,0x02,0x23,0x00,0x17
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x10,0x17
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x11,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x88,0xa9,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x10,0x00
	.byte 0x00,0x88,0xba,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0x88,0xcb,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x02,0x0a
	.byte 0x10,0x00,0x00,0x88,0xdc,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x18,0x00,0x00,0x02
	.byte 0x0a,0x03,0x20,0x00,0x00,0x88,0xef,0x19
	.byte 0x00,0x00,0x39,0xfd,0x00,0xc7,0x00,0x1a
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x03,0x00,0x00,0x89,0xab,0x17
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x88,0x98,0x02,0x23,0x00,0x17
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x88,0xa9,0x02,0x23,0x10,0x17
	.ascii "Specular\0"
	.byte 0x00,0x00,0x88,0xba,0x02,0x23,0x20,0x17
	.ascii "Emission\0"
	.byte 0x00,0x00,0x88,0xcb,0x02,0x23,0x30,0x17
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x40,0x17
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x44,0x17
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x48,0x17
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x4c,0x17
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x88,0xdc,0x02,0x23,0x50,0x00
	.byte 0x18,0x00,0x00,0x88,0xef,0x06,0xe0,0x00
	.byte 0x00,0x89,0xbd,0x15,0x00,0x00,0x39,0xfd
	.byte 0x01,0x00,0x14,0x00,0x00,0x02,0x01,0x10
	.byte 0x00,0x00,0x89,0xce,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x89,0xbd
	.byte 0x20,0x00,0x00,0x89,0xdf,0x15,0x00,0x00
	.byte 0x39,0xfd,0x01,0x00,0x1a
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x03,0x00,0x00,0x8b,0x00,0x17
	.ascii "Light\0"
	.byte 0x00,0x00,0x88,0x2b,0x02,0x23,0x00,0x17
	.ascii "Model\0"
	.byte 0x00,0x00,0x88,0x4e,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x17
	.ascii "Material\0"
	.byte 0x00,0x00,0x89,0xab,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0x94,0x9c
	.byte 0x02,0x17
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0x98,0x9c
	.byte 0x02,0x17
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x17
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x17
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x02,0x29,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x17
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x17
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x87,0x69,0x04,0x23,0xac,0x9c
	.byte 0x02,0x17
	.ascii "Fast\0"
	.byte 0x00,0x00,0x3b,0x79,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x17
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x89,0xce,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x07,0x00,0x00,0x50,0xcb
	.ascii "GLushort\0"
	.byte 0x02,0x16
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x03,0x00,0x00,0x8b,0x88,0x17
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x01,0x17
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x8b,0x00,0x02,0x23,0x02,0x17
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x08,0x00
	.byte 0x16
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x03,0x00,0x00,0x8b,0xb0,0x17
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x00,0x00
	.byte 0x18,0x00,0x00,0x05,0x72,0x04,0x00,0x00
	.byte 0x00,0x8b,0xc3,0x19,0x00,0x00,0x39,0xfd
	.byte 0x00,0xff,0x00,0x18,0x00,0x00,0x05,0x72
	.byte 0x04,0x00,0x00,0x00,0x8b,0xd6,0x19,0x00
	.byte 0x00,0x39,0xfd,0x00,0xff,0x00,0x18,0x00
	.byte 0x00,0x02,0x0a,0x04,0x00,0x00,0x00,0x8b
	.byte 0xe9,0x19,0x00,0x00,0x39,0xfd,0x00,0xff
	.byte 0x00,0x18,0x00,0x00,0x02,0x0a,0x04,0x00
	.byte 0x00,0x00,0x8b,0xfc,0x19,0x00,0x00,0x39
	.byte 0xfd,0x00,0xff,0x00,0x18,0x00,0x00,0x02
	.byte 0x0a,0x04,0x00,0x00,0x00,0x8c,0x0f,0x19
	.byte 0x00,0x00,0x39,0xfd,0x00,0xff,0x00,0x18
	.byte 0x00,0x00,0x02,0x0a,0x04,0x00,0x00,0x00
	.byte 0x8c,0x22,0x19,0x00,0x00,0x39,0xfd,0x00
	.byte 0xff,0x00,0x18,0x00,0x00,0x02,0x0a,0x04
	.byte 0x00,0x00,0x00,0x8c,0x35,0x19,0x00,0x00
	.byte 0x39,0xfd,0x00,0xff,0x00,0x18,0x00,0x00
	.byte 0x02,0x0a,0x04,0x00,0x00,0x00,0x8c,0x48
	.byte 0x19,0x00,0x00,0x39,0xfd,0x00,0xff,0x00
	.byte 0x18,0x00,0x00,0x02,0x0a,0x04,0x00,0x00
	.byte 0x00,0x8c,0x5b,0x19,0x00,0x00,0x39,0xfd
	.byte 0x00,0xff,0x00,0x18,0x00,0x00,0x02,0x0a
	.byte 0x04,0x00,0x00,0x00,0x8c,0x6e,0x19,0x00
	.byte 0x00,0x39,0xfd,0x00,0xff,0x00,0x1a
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x03,0x00,0x00,0x8f,0x2d,0x17
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x04,0x17
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x08,0x17
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x0c,0x17
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x10,0x17
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x14,0x17
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x20,0x17
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x24,0x17
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x28,0x17
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x2c,0x17
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x30,0x17
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x34,0x17
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x35,0x17
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x38,0x17
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x3c,0x17
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x40,0x17
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x44,0x17
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x48,0x17
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x4c,0x17
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x50,0x17
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x54,0x17
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x58,0x17
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x5c,0x17
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x60,0x17
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x64,0x17
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x8b,0xb0,0x02,0x23,0x68,0x17
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x8b,0xc3,0x03,0x23,0xe8,0x08
	.byte 0x17
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x8b,0xd6,0x03,0x23,0xe8,0x10
	.byte 0x17
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x8b,0xe9,0x03,0x23,0xe8,0x18
	.byte 0x17
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x8b,0xfc,0x03,0x23,0xe8,0x20
	.byte 0x17
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x8c,0x0f,0x03,0x23,0xe8,0x28
	.byte 0x17
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x8c,0x22,0x03,0x23,0xe8,0x30
	.byte 0x17
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x8c,0x35,0x03,0x23,0xe8,0x38
	.byte 0x17
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x8c,0x48,0x03,0x23,0xe8,0x40
	.byte 0x17
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x8c,0x5b,0x03,0x23,0xe8,0x48
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x0c,0x00
	.byte 0x00,0x8f,0x3e,0x15,0x00,0x00,0x39,0xfd
	.byte 0x02,0x00,0x16
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x03,0x00,0x00,0x8f,0xb7,0x17
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "Size\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x04,0x17
	.ascii "Params\0"
	.byte 0x00,0x00,0x8f,0x2d,0x02,0x23,0x08,0x17
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x14,0x17
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x00
	.byte 0x16
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x03,0x00,0x00,0x90,0xea,0x17
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x08,0x17
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0c,0x17
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x0d,0x17
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x10,0x17
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x14,0x17
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x18,0x17
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x19,0x17
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x20,0x17
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x24,0x17
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x25,0x17
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x26,0x17
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x27,0x00
	.byte 0x14,0x00,0x00,0x02,0x29,0x80,0x00,0x00
	.byte 0x90,0xfb,0x15,0x00,0x00,0x39,0xfd,0x1f
	.byte 0x00,0x07,0x00,0x00,0x01,0x3a
	.ascii "GLsizei\0"
	.byte 0x02,0x16
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x03,0x00,0x00,0x91,0x64,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "X\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "Y\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x08,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x0c,0x17
	.ascii "Height\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x10,0x00
	.byte 0x16
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x03,0x00,0x00,0x92,0x12,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x00,0x17
	.ascii "Function\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x08,0x17
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x0c,0x17
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x10,0x17
	.ascii "Ref\0"
	.byte 0x00,0x00,0x6e,0x6d,0x02,0x23,0x14,0x17
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x6e,0x6d,0x02,0x23,0x15,0x17
	.ascii "Clear\0"
	.byte 0x00,0x00,0x6e,0x6d,0x02,0x23,0x16,0x17
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x6e,0x6d,0x02,0x23,0x17,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x92,0x23,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x02,0x0a,0x10,0x00
	.byte 0x00,0x92,0x34,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0x92,0x45,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x02,0x0a
	.byte 0x10,0x00,0x00,0x92,0x56,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x14,0x00,0x00,0x02
	.byte 0x0a,0x10,0x00,0x00,0x92,0x67,0x15,0x00
	.byte 0x00,0x39,0xfd,0x03,0x00,0x14,0x00,0x00
	.byte 0x02,0x0a,0x10,0x00,0x00,0x92,0x78,0x15
	.byte 0x00,0x00,0x39,0xfd,0x03,0x00,0x14,0x00
	.byte 0x00,0x02,0x0a,0x10,0x00,0x00,0x92,0x89
	.byte 0x15,0x00,0x00,0x39,0xfd,0x03,0x00,0x14
	.byte 0x00,0x00,0x02,0x0a,0x10,0x00,0x00,0x92
	.byte 0x9a,0x15,0x00,0x00,0x39,0xfd,0x03,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0x92,0xab,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x18,0x00,0x00,0x3a,0x27,0x04,0x00
	.byte 0x00,0x00,0x92,0xbe,0x19,0x00,0x00,0x39
	.byte 0xfd,0x03,0xff,0x00,0x1a
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x03,0x00,0x00,0x94,0xed,0x17
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x00,0x17
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x92,0x12,0x02,0x23,0x08,0x17
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x18,0x17
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x1c,0x17
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x20,0x17
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x24,0x17
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x28,0x17
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x92,0x23,0x02,0x23,0x2c,0x17
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x92,0x34,0x02,0x23,0x3c,0x17
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x92,0x45,0x02,0x23,0x4c,0x17
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x92,0x56,0x02,0x23,0x5c,0x17
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x92,0x67,0x02,0x23,0x6c,0x17
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x92,0x78,0x02,0x23,0x7c,0x17
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x92,0x89,0x03,0x23,0x8c,0x01
	.byte 0x17
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x92,0x9a,0x03,0x23,0x9c,0x01
	.byte 0x17
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xac,0x01
	.byte 0x17
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xb0,0x01
	.byte 0x17
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xb4,0x01
	.byte 0x17
	.ascii "Current\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xb8,0x01
	.byte 0x17
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xbc,0x01
	.byte 0x17
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xc0,0x01
	.byte 0x17
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x3d,0xa6,0x03,0x23,0xc4,0x01
	.byte 0x17
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0xc8,0x01
	.byte 0x17
	.ascii "Palette\0"
	.byte 0x00,0x00,0x92,0xab,0x03,0x23,0xc9,0x01
	.byte 0x17
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x02,0x29,0x03,0x23,0xcc,0x09
	.byte 0x17
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x35,0x1a,0x03,0x23,0xd0,0x09
	.byte 0x17
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x35,0x1a,0x03,0x23,0xd4,0x09
	.byte 0x00,0x14,0x00,0x00,0x02,0x01,0x10,0x00
	.byte 0x00,0x94,0xfe,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x94,0xed,0x60
	.byte 0x00,0x00,0x95,0x0f,0x15,0x00,0x00,0x39
	.byte 0xfd,0x05,0x00,0x14,0x00,0x00,0x3b,0x79
	.byte 0x06,0x00,0x00,0x95,0x20,0x15,0x00,0x00
	.byte 0x39,0xfd,0x05,0x00,0x16
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x03,0x00,0x00,0x95,0x9a,0x17
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x94,0xfe,0x02,0x23,0x04,0x17
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x95,0x0f,0x02,0x23,0x64,0x17
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x6a,0x17
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x6b,0x00
	.byte 0x16
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x03,0x00,0x00,0x96,0x41,0x17
	.ascii "X\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "Y\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "Width\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x08,0x17
	.ascii "Height\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x0c,0x17
	.ascii "Near\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x10,0x17
	.ascii "Far\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x14,0x17
	.ascii "Sx\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x18,0x17
	.ascii "Sy\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x1c,0x17
	.ascii "Sz\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x20,0x17
	.ascii "Tx\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x24,0x17
	.ascii "Ty\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x28,0x17
	.ascii "Tz\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x2c,0x00
	.byte 0x14,0x00,0x00,0x7d,0xe1,0x40,0x00,0x00
	.byte 0x96,0x52,0x15,0x00,0x00,0x39,0xfd,0x0f
	.byte 0x00,0x08,0x00,0x00,0x3b,0x79,0x16
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x03,0x00,0x00,0x99,0x02,0x17
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x04,0x17
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x08,0x17
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x0c,0x17
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x10,0x17
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x14,0x17
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x18,0x17
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x1c,0x17
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x20,0x17
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x24,0x17
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x28,0x17
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x2c,0x17
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x30,0x17
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x34,0x17
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x38,0x17
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x3c,0x17
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x40,0x17
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x44,0x17
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x48,0x17
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x4c,0x17
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x50,0x17
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x54,0x17
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x58,0x17
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x5c,0x17
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x60,0x17
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x64,0x17
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x3a,0x42,0x02,0x23,0x68,0x17
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x6c,0x17
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x70,0x17
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x90,0xfb,0x02,0x23,0x74,0x17
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x96,0x52,0x02,0x23,0x78,0x17
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x7c,0x00
	.byte 0x16
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x03,0x00,0x00,0x99,0xb1,0x17
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x00,0x17
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x04,0x17
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x08,0x17
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x0c,0x17
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x10,0x17
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x05,0x72,0x02,0x23,0x14,0x17
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x18,0x17
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x19,0x00
	.byte 0x16
	.ascii "gl_1d_map\0"
	.byte 0x14,0x03,0x00,0x00,0x9a,0x05,0x17
	.ascii "Order\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x00,0x17
	.ascii "u1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x04,0x17
	.ascii "u2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x08,0x17
	.ascii "Points\0"
	.byte 0x00,0x00,0x02,0x18,0x02,0x23,0x0c,0x17
	.ascii "Retain\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x10,0x00
	.byte 0x16
	.ascii "gl_2d_map\0"
	.byte 0x20,0x03,0x00,0x00,0x9a,0x7f,0x17
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x00,0x17
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x04,0x17
	.ascii "u1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x08,0x17
	.ascii "u2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x0c,0x17
	.ascii "v1\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x10,0x17
	.ascii "v2\0"
	.byte 0x00,0x00,0x02,0x0a,0x02,0x23,0x14,0x17
	.ascii "Points\0"
	.byte 0x00,0x00,0x02,0x18,0x02,0x23,0x18,0x17
	.ascii "Retain\0"
	.byte 0x00,0x00,0x3b,0x79,0x02,0x23,0x1c,0x00
	.byte 0x1a
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x03,0x00,0x00,0x9c,0x09,0x17
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x00,0x17
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x14,0x17
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x28,0x17
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x3c,0x17
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x50,0x17
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x64,0x17
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x99,0xb1,0x02,0x23,0x78,0x17
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x99,0xb1,0x03,0x23,0x8c,0x01
	.byte 0x17
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x99,0xb1,0x03,0x23,0xa0,0x01
	.byte 0x17
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xb4,0x01
	.byte 0x17
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xd4,0x01
	.byte 0x17
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xf4,0x01
	.byte 0x17
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0x94,0x02
	.byte 0x17
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xb4,0x02
	.byte 0x17
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xd4,0x02
	.byte 0x17
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xf4,0x02
	.byte 0x17
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0x94,0x03
	.byte 0x17
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x9a,0x05,0x03,0x23,0xb4,0x03
	.byte 0x00,0x16
	.ascii "gl_feedback\0"
	.byte 0x14,0x03,0x00,0x00,0x9c,0x67,0x17
	.ascii "Type\0"
	.byte 0x00,0x00,0x35,0x1a,0x02,0x23,0x00,0x17
	.ascii "Mask\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x04,0x17
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x02,0x18,0x02,0x23,0x08,0x17
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x0c,0x17
	.ascii "Count\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x10,0x00
	.byte 0x08,0x00,0x00,0x02,0x29,0x18,0x00,0x00
	.byte 0x02,0x29,0x01,0x00,0x00,0x00,0x9c,0x7e
	.byte 0x15,0x00,0x00,0x39,0xfd,0x3f,0x00,0x1a
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x03,0x00,0x00,0x9d,0x33,0x17
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x9c,0x67,0x02,0x23,0x00,0x17
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x04,0x17
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x08,0x17
	.ascii "Hits\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x0c,0x17
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x02,0x29,0x02,0x23,0x10,0x17
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x9c,0x6c,0x02,0x23,0x14,0x17
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x3b,0x79,0x03,0x23,0x94,0x02
	.byte 0x17
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x02,0x0a,0x03,0x23,0x98,0x02
	.byte 0x17
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x02,0x0a,0x03,0x23,0x9c,0x02
	.byte 0x00,0x13
	.ascii "vertex_buffer\0"
	.byte 0x01,0x08,0x00,0x00,0x9d,0x33,0x13
	.ascii "pixel_buffer\0"
	.byte 0x01,0x08,0x00,0x00,0x9d,0x48,0x07,0x00
	.byte 0x00,0x3e,0x4c
	.ascii "GLcontext\0"
	.byte 0x03,0x08,0x00,0x00,0x9d,0x5c,0x08,0x00
	.byte 0x00,0x99,0xb1,0x08,0x00,0x00,0x9a,0x05
	.byte 0x12
	.ascii "gl_Map1f\0"
	.byte 0x01,0x02,0x01,0x03,0x38
	.uaword gl_Map1f
	.uaword .L1463
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9e,0x35
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x03,0x35,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x03,0x35,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u1\0"
	.byte 0x01,0x03,0x36,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u2\0"
	.byte 0x01,0x03,0x36,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "stride\0"
	.byte 0x01,0x03,0x36,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "order\0"
	.byte 0x01,0x03,0x37,0x03,0x91,0xd8,0x00,0x0b
	.byte 0x00,0x00,0x9e,0x3a
	.ascii "points\0"
	.byte 0x01,0x03,0x37,0x03,0x91,0xdc,0x00,0x0b
	.byte 0x00,0x00,0x3b,0x79
	.ascii "retain\0"
	.byte 0x01,0x03,0x37,0x03,0x91,0xe3,0x00,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x03,0x39
	.byte 0x02,0x91,0x7c,0x00,0x11,0x00,0x00,0x02
	.byte 0x0a,0x08,0x00,0x00,0x9e,0x35,0x12
	.ascii "gl_Map2f\0"
	.byte 0x01,0x02,0x01,0x03,0xd1
	.uaword gl_Map2f
	.uaword .L1773
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9f,0x40
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x03,0xcd,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x03,0xcd,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u1\0"
	.byte 0x01,0x03,0xce,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u2\0"
	.byte 0x01,0x03,0xce,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "ustride\0"
	.byte 0x01,0x03,0xce,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "uorder\0"
	.byte 0x01,0x03,0xce,0x03,0x91,0xd8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v1\0"
	.byte 0x01,0x03,0xcf,0x03,0x91,0xdc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v2\0"
	.byte 0x01,0x03,0xcf,0x03,0x91,0xe0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vstride\0"
	.byte 0x01,0x03,0xcf,0x03,0x91,0xe4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vorder\0"
	.byte 0x01,0x03,0xcf
	.byte 0x03,0x91,0xe8,0x00,0x0b,0x00,0x00,0x9f
	.byte 0x45
	.ascii "points\0"
	.byte 0x01,0x03,0xd0,0x03,0x91,0xec,0x00,0x0b
	.byte 0x00,0x00,0x3b,0x79
	.ascii "retain\0"
	.byte 0x01,0x03,0xd0,0x03,0x91,0xf3,0x00,0x0c
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x03,0xd2
	.byte 0x02,0x91,0x7c,0x00,0x11,0x00,0x00,0x02
	.byte 0x0a,0x08,0x00,0x00,0x9f,0x40,0x12
	.ascii "gl_GetMapdv\0"
	.byte 0x01,0x02,0x01,0x04,0x84
	.uaword gl_GetMapdv
	.uaword .L2090
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9f,0xdd
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x04,0x83,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x04,0x83,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "query\0"
	.byte 0x01,0x04,0x83,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x9f,0xdd
	.ascii "v\0"
	.byte 0x01,0x04,0x83,0x03,0x91,0xd0,0x00,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x04,0x85
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "n\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x04,0x85
	.byte 0x02,0x91,0x78,0x0c
	.ascii "data\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x04,0x86
	.byte 0x02,0x91,0x74,0x00,0x08,0x00,0x00,0x36
	.byte 0xd1,0x12
	.ascii "gl_GetMapfv\0"
	.byte 0x01,0x02,0x01,0x05,0x91
	.uaword gl_GetMapfv
	.uaword .L2407
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa0,0x75
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x05,0x90,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x05,0x90,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "query\0"
	.byte 0x01,0x05,0x90,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x18
	.ascii "v\0"
	.byte 0x01,0x05,0x90,0x03,0x91,0xd0,0x00,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x05,0x92
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "n\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x05,0x92
	.byte 0x02,0x91,0x78,0x0c
	.ascii "data\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x05,0x93
	.byte 0x02,0x91,0x74,0x00,0x12
	.ascii "gl_GetMapiv\0"
	.byte 0x01,0x02,0x01,0x06,0x9e
	.uaword gl_GetMapiv
	.uaword .L2889
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa1,0x08
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x06,0x9d,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "target\0"
	.byte 0x01,0x06,0x9d,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "query\0"
	.byte 0x01,0x06,0x9d,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0xa1,0x08
	.ascii "v\0"
	.byte 0x01,0x06,0x9d,0x03,0x91,0xd0,0x00,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x06,0x9f
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "n\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x06,0x9f
	.byte 0x02,0x91,0x78,0x0c
	.ascii "data\0"
	.byte 0x00,0x00,0x02,0x18,0x01,0x01,0x06,0xa0
	.byte 0x02,0x91,0x74,0x00,0x08,0x00,0x00,0x05
	.byte 0x72,0x12
	.ascii "gl_EvalCoord1f\0"
	.byte 0x01,0x02,0x01,0x07,0xac
	.uaword gl_EvalCoord1f
	.uaword .L3060
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa3,0xf3
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x07,0xab,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u\0"
	.byte 0x01,0x07,0xab,0x03,0x91,0xc8,0x00,0x0c
	.ascii "vertex\0"
	.byte 0x00,0x00,0xa3,0xf3,0x01,0x01,0x07,0xad
	.byte 0x02,0x91,0x70,0x0c
	.ascii "normal\0"
	.byte 0x00,0x00,0xa4,0x04,0x01,0x01,0x07,0xae
	.byte 0x02,0x91,0x64,0x0c
	.ascii "fcolor\0"
	.byte 0x00,0x00,0xa4,0x15,0x01,0x01,0x07,0xaf
	.byte 0x02,0x91,0x54,0x0c
	.ascii "icolor\0"
	.byte 0x00,0x00,0xa4,0x26,0x01,0x01,0x07,0xb0
	.byte 0x02,0x91,0x50,0x0c
	.ascii "colorptr\0"
	.byte 0x00,0x00,0x3a,0x35,0x01,0x01,0x07,0xb1
	.byte 0x02,0x91,0x4c,0x0c
	.ascii "texcoord\0"
	.byte 0x00,0x00,0xa4,0x37,0x01,0x01,0x07,0xb2
	.byte 0x03,0x91,0xbc,0x7f,0x0c
	.ascii "index\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x07,0xb3
	.byte 0x03,0x91,0xb8,0x7f,0x0c
	.ascii "uu\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x07,0xb4
	.byte 0x03,0x91,0xb4,0x7f,0x09
	.uaword .L2895
	.uaword .L2922
	.byte 0x09
	.uaword .L2899
	.uaword .L2905
	.byte 0x09
	.uaword .L2900
	.uaword .L2904
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xb9
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x09
	.uaword .L2907
	.uaword .L2921
	.byte 0x09
	.uaword .L2908
	.uaword .L2920
	.byte 0x09
	.uaword .L2912
	.uaword .L2919
	.byte 0x09
	.uaword .L2913
	.uaword .L2918
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xbf
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x09
	.uaword .L2923
	.uaword .L2941
	.byte 0x09
	.uaword .L2927
	.uaword .L2934
	.byte 0x09
	.uaword .L2928
	.uaword .L2933
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xc8
	.byte 0x03,0x91,0xb0,0x7f,0x0c
	.ascii "findex\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x07,0xc9
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x00,0x09
	.uaword .L2942
	.uaword .L2965
	.byte 0x09
	.uaword .L2946
	.uaword .L2957
	.byte 0x09
	.uaword .L2947
	.uaword .L2956
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xd4
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x09
	.uaword .L2959
	.uaword .L2964
	.byte 0x09
	.uaword .L2960
	.uaword .L2963
	.byte 0x0c
	.ascii "col\0"
	.byte 0x00,0x00,0xa4,0x48,0x01,0x01,0x07,0xde
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x09
	.uaword .L2966
	.uaword .L2985
	.byte 0x09
	.uaword .L2970
	.uaword .L2976
	.byte 0x09
	.uaword .L2971
	.uaword .L2975
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xe5
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x09
	.uaword .L2986
	.uaword .L3057
	.byte 0x09
	.uaword .L2990
	.uaword .L2996
	.byte 0x09
	.uaword .L2991
	.uaword .L2995
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xf1
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x09
	.uaword .L2998
	.uaword .L3056
	.byte 0x09
	.uaword .L2999
	.uaword .L3055
	.byte 0x09
	.uaword .L3003
	.uaword .L3010
	.byte 0x09
	.uaword .L3004
	.uaword .L3009
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xf6
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x09
	.uaword .L3012
	.uaword .L3054
	.byte 0x09
	.uaword .L3013
	.uaword .L3053
	.byte 0x09
	.uaword .L3017
	.uaword .L3025
	.byte 0x09
	.uaword .L3018
	.uaword .L3024
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x07,0xfc
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x09
	.uaword .L3027
	.uaword .L3052
	.byte 0x09
	.uaword .L3028
	.uaword .L3051
	.byte 0x09
	.uaword .L3032
	.uaword .L3041
	.byte 0x09
	.uaword .L3033
	.uaword .L3040
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x71,0x01,0x01,0x08,0x03
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00
	.byte 0x00,0x02,0x0a,0x10,0x00,0x00,0xa4,0x04
	.byte 0x15,0x00,0x00,0x39,0xfd,0x03,0x00,0x14
	.byte 0x00,0x00,0x02,0x0a,0x0c,0x00,0x00,0xa4
	.byte 0x15,0x15,0x00,0x00,0x39,0xfd,0x02,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0xa4,0x26,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x3a,0x27,0x04,0x00
	.byte 0x00,0xa4,0x37,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0xa4,0x48,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x3a,0x27
	.byte 0x04,0x00,0x00,0xa4,0x59,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x12
	.ascii "gl_EvalCoord2f\0"
	.byte 0x01,0x02,0x01,0x08,0x16
	.uaword gl_EvalCoord2f
	.uaword .L3306
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa8,0x2d
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x08,0x15,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u\0"
	.byte 0x01,0x08,0x15,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v\0"
	.byte 0x01,0x08,0x15,0x03,0x91,0xcc,0x00,0x0c
	.ascii "vertex\0"
	.byte 0x00,0x00,0xa8,0x2d,0x01,0x01,0x08,0x17
	.byte 0x02,0x91,0x70,0x0c
	.ascii "normal\0"
	.byte 0x00,0x00,0xa8,0x3e,0x01,0x01,0x08,0x18
	.byte 0x02,0x91,0x64,0x0c
	.ascii "fcolor\0"
	.byte 0x00,0x00,0xa8,0x4f,0x01,0x01,0x08,0x19
	.byte 0x02,0x91,0x54,0x0c
	.ascii "icolor\0"
	.byte 0x00,0x00,0xa8,0x60,0x01,0x01,0x08,0x1a
	.byte 0x02,0x91,0x50,0x0c
	.ascii "colorptr\0"
	.byte 0x00,0x00,0x3a,0x35,0x01,0x01,0x08,0x1b
	.byte 0x02,0x91,0x4c,0x0c
	.ascii "texcoord\0"
	.byte 0x00,0x00,0xa8,0x71,0x01,0x01,0x08,0x1c
	.byte 0x03,0x91,0xbc,0x7f,0x0c
	.ascii "index\0"
	.byte 0x00,0x00,0x02,0x29,0x01,0x01,0x08,0x1d
	.byte 0x03,0x91,0xb8,0x7f,0x0c
	.ascii "uu\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0x1e
	.byte 0x03,0x91,0xb4,0x7f,0x0c
	.ascii "vv\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0x1e
	.byte 0x03,0x91,0xb0,0x7f,0x09
	.uaword .L3066
	.uaword .L3149
	.byte 0x09
	.uaword .L3070
	.uaword .L3104
	.byte 0x09
	.uaword .L3071
	.uaword .L3103
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x27
	.byte 0x03,0x91,0xac,0x7f,0x09
	.uaword .L3075
	.uaword .L3102
	.byte 0x09
	.uaword .L3079
	.uaword .L3095
	.byte 0x09
	.uaword .L3080
	.uaword .L3094
	.byte 0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0xa8,0x82,0x01,0x01,0x08,0x2c
	.byte 0x03,0x91,0x9c,0x7f,0x0c
	.ascii "dv\0"
	.byte 0x00,0x00,0xa8,0x93,0x01,0x01,0x08,0x2c
	.byte 0x03,0x91,0x8c,0x7f,0x09
	.uaword .L3083
	.uaword .L3093
	.byte 0x0c
	.ascii "len\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0x32
	.byte 0x03,0x91,0x88,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x09
	.uaword .L3106
	.uaword .L3148
	.byte 0x09
	.uaword .L3107
	.uaword .L3147
	.byte 0x09
	.uaword .L3111
	.uaword .L3146
	.byte 0x09
	.uaword .L3112
	.uaword .L3145
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x3a
	.byte 0x03,0x91,0xac,0x7f,0x09
	.uaword .L3116
	.uaword .L3143
	.byte 0x09
	.uaword .L3120
	.uaword .L3136
	.byte 0x09
	.uaword .L3121
	.uaword .L3135
	.byte 0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0xa8,0xa4,0x01,0x01,0x08,0x3e
	.byte 0x03,0x91,0xa0,0x7f,0x0c
	.ascii "dv\0"
	.byte 0x00,0x00,0xa8,0xb5,0x01,0x01,0x08,0x3e
	.byte 0x03,0x91,0x94,0x7f,0x09
	.uaword .L3124
	.uaword .L3134
	.byte 0x0c
	.ascii "len\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0x42
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x09
	.uaword .L3150
	.uaword .L3169
	.byte 0x09
	.uaword .L3154
	.uaword .L3162
	.byte 0x09
	.uaword .L3155
	.uaword .L3161
	.byte 0x0c
	.ascii "findex\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0x4e
	.byte 0x03,0x91,0xac,0x7f,0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x4f
	.byte 0x03,0x91,0xa8,0x7f,0x00,0x00,0x00,0x09
	.uaword .L3170
	.uaword .L3194
	.byte 0x09
	.uaword .L3174
	.uaword .L3186
	.byte 0x09
	.uaword .L3175
	.uaword .L3185
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x5c
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x09
	.uaword .L3188
	.uaword .L3193
	.byte 0x09
	.uaword .L3189
	.uaword .L3192
	.byte 0x0c
	.ascii "col\0"
	.byte 0x00,0x00,0xa8,0xc6,0x01,0x01,0x08,0x68
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x00,0x09
	.uaword .L3195
	.uaword .L3227
	.byte 0x09
	.uaword .L3202
	.uaword .L3226
	.byte 0x09
	.uaword .L3203
	.uaword .L3225
	.byte 0x09
	.uaword .L3204
	.uaword .L3224
	.byte 0x09
	.uaword .L3208
	.uaword .L3215
	.byte 0x09
	.uaword .L3209
	.uaword .L3214
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x71
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x09
	.uaword .L3228
	.uaword .L3303
	.byte 0x09
	.uaword .L3232
	.uaword .L3239
	.byte 0x09
	.uaword .L3233
	.uaword .L3238
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x80
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x09
	.uaword .L3241
	.uaword .L3302
	.byte 0x09
	.uaword .L3242
	.uaword .L3301
	.byte 0x09
	.uaword .L3246
	.uaword .L3254
	.byte 0x09
	.uaword .L3247
	.uaword .L3253
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x87
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x09
	.uaword .L3256
	.uaword .L3300
	.byte 0x09
	.uaword .L3257
	.uaword .L3299
	.byte 0x09
	.uaword .L3261
	.uaword .L3270
	.byte 0x09
	.uaword .L3262
	.uaword .L3269
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x8f
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x09
	.uaword .L3272
	.uaword .L3298
	.byte 0x09
	.uaword .L3273
	.uaword .L3297
	.byte 0x09
	.uaword .L3277
	.uaword .L3287
	.byte 0x09
	.uaword .L3278
	.uaword .L3286
	.byte 0x0c
	.ascii "map\0"
	.byte 0x00,0x00,0x9d,0x76,0x01,0x01,0x08,0x98
	.byte 0x03,0x91,0xac,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x14,0x00
	.byte 0x00,0x02,0x0a,0x10,0x00,0x00,0xa8,0x3e
	.byte 0x15,0x00,0x00,0x39,0xfd,0x03,0x00,0x14
	.byte 0x00,0x00,0x02,0x0a,0x0c,0x00,0x00,0xa8
	.byte 0x4f,0x15,0x00,0x00,0x39,0xfd,0x02,0x00
	.byte 0x14,0x00,0x00,0x02,0x0a,0x10,0x00,0x00
	.byte 0xa8,0x60,0x15,0x00,0x00,0x39,0xfd,0x03
	.byte 0x00,0x14,0x00,0x00,0x3a,0x27,0x04,0x00
	.byte 0x00,0xa8,0x71,0x15,0x00,0x00,0x39,0xfd
	.byte 0x03,0x00,0x14,0x00,0x00,0x02,0x0a,0x10
	.byte 0x00,0x00,0xa8,0x82,0x15,0x00,0x00,0x39
	.byte 0xfd,0x03,0x00,0x14,0x00,0x00,0x02,0x0a
	.byte 0x10,0x00,0x00,0xa8,0x93,0x15,0x00,0x00
	.byte 0x39,0xfd,0x03,0x00,0x14,0x00,0x00,0x02
	.byte 0x0a,0x10,0x00,0x00,0xa8,0xa4,0x15,0x00
	.byte 0x00,0x39,0xfd,0x03,0x00,0x14,0x00,0x00
	.byte 0x02,0x0a,0x0c,0x00,0x00,0xa8,0xb5,0x15
	.byte 0x00,0x00,0x39,0xfd,0x02,0x00,0x14,0x00
	.byte 0x00,0x02,0x0a,0x0c,0x00,0x00,0xa8,0xc6
	.byte 0x15,0x00,0x00,0x39,0xfd,0x02,0x00,0x14
	.byte 0x00,0x00,0x3a,0x27,0x04,0x00,0x00,0xa8
	.byte 0xd7,0x15,0x00,0x00,0x39,0xfd,0x03,0x00
	.byte 0x12
	.ascii "gl_MapGrid1f\0"
	.byte 0x01,0x02,0x01,0x08,0xae
	.uaword gl_MapGrid1f
	.uaword .L3340
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa9,0x38
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x08,0xad,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "un\0"
	.byte 0x01,0x08,0xad,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u1\0"
	.byte 0x01,0x08,0xad,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u2\0"
	.byte 0x01,0x08,0xad,0x03,0x91,0xd0,0x00,0x00
	.byte 0x12
	.ascii "gl_MapGrid2f\0"
	.byte 0x01,0x02,0x01,0x08,0xbf
	.uaword gl_MapGrid2f
	.uaword .L3389
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa9,0xc6
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x08,0xbd,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "un\0"
	.byte 0x01,0x08,0xbd,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u1\0"
	.byte 0x01,0x08,0xbd,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "u2\0"
	.byte 0x01,0x08,0xbd,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "vn\0"
	.byte 0x01,0x08,0xbe,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v1\0"
	.byte 0x01,0x08,0xbe,0x03,0x91,0xd8,0x00,0x0b
	.byte 0x00,0x00,0x02,0x0a
	.ascii "v2\0"
	.byte 0x01,0x08,0xbe,0x03,0x91,0xdc,0x00,0x00
	.byte 0x12
	.ascii "gl_EvalPoint1\0"
	.byte 0x01,0x02,0x01,0x08,0xd6
	.uaword gl_EvalPoint1
	.uaword .L3427
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xaa,0x26
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x08,0xd5,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i\0"
	.byte 0x01,0x08,0xd5,0x03,0x91,0xc8,0x00,0x0c
	.ascii "u\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xd7
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xd7
	.byte 0x02,0x91,0x78,0x00,0x12
	.ascii "gl_EvalPoint2\0"
	.byte 0x01,0x02,0x01,0x08,0xea
	.uaword gl_EvalPoint2
	.uaword .L3495
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xaa,0xb1
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x08,0xe9,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i\0"
	.byte 0x01,0x08,0xe9,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "j\0"
	.byte 0x01,0x08,0xe9,0x03,0x91,0xcc,0x00,0x0c
	.ascii "u\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xeb
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xeb
	.byte 0x02,0x91,0x78,0x0c
	.ascii "v\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xec
	.byte 0x02,0x91,0x74,0x0c
	.ascii "dv\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x08,0xec
	.byte 0x02,0x91,0x70,0x00,0x12
	.ascii "gl_EvalMesh1\0"
	.byte 0x01,0x02,0x01,0x09,0x0c
	.uaword gl_EvalMesh1
	.uaword .L3581
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xab,0x50
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x09,0x0b,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "mode\0"
	.byte 0x01,0x09,0x0b,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i1\0"
	.byte 0x01,0x09,0x0b,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i2\0"
	.byte 0x01,0x09,0x0b,0x03,0x91,0xd0,0x00,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x05,0x72,0x01,0x01,0x09,0x0d
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "u\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x0e
	.byte 0x02,0x91,0x78,0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x0e
	.byte 0x02,0x91,0x74,0x0c
	.ascii "prim\0"
	.byte 0x00,0x00,0x35,0x1a,0x01,0x01,0x09,0x0f
	.byte 0x02,0x91,0x70,0x00,0x12
	.ascii "gl_EvalMesh2\0"
	.byte 0x01,0x02,0x01,0x09,0x38
	.uaword gl_EvalMesh2
	.uaword .L3965
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xac,0x45
	.byte 0x0b,0x00,0x00,0x9d,0x6c
	.ascii "ctx\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xc4,0x00,0x0b
	.byte 0x00,0x00,0x35,0x1a
	.ascii "mode\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xc8,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i1\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xcc,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "i2\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xd0,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "j1\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xd4,0x00,0x0b
	.byte 0x00,0x00,0x05,0x72
	.ascii "j2\0"
	.byte 0x01,0x09,0x37,0x03,0x91,0xd8,0x00,0x0c
	.ascii "i\0"
	.byte 0x00,0x00,0x05,0x72,0x01,0x01,0x09,0x39
	.byte 0x02,0x91,0x7c,0x0c
	.ascii "j\0"
	.byte 0x00,0x00,0x05,0x72,0x01,0x01,0x09,0x39
	.byte 0x02,0x91,0x78,0x0c
	.ascii "u\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x74,0x0c
	.ascii "du\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x70,0x0c
	.ascii "v\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x6c,0x0c
	.ascii "dv\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x68,0x0c
	.ascii "v1\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x64,0x0c
	.ascii "v2\0"
	.byte 0x00,0x00,0x02,0x0a,0x01,0x01,0x09,0x3a
	.byte 0x02,0x91,0x60,0x00,0x1f
	.ascii "gl_End\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xac,0x5b
	.byte 0x1c,0x00,0x00,0x45,0x19,0x00,0x1f
	.ascii "gl_Begin\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xac,0x78
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x00,0x11,0x00,0x00,0x02,0x01
	.byte 0x08,0x00,0x00,0xac,0x78,0x11,0x00,0x00
	.byte 0x02,0x01,0x08,0x00,0x00,0xac,0x82,0x11
	.byte 0x00,0x00,0x3a,0x16,0x08,0x00,0x00,0xac
	.byte 0x8c,0x11,0x00,0x00,0x02,0x01,0x08,0x00
	.byte 0x00,0xac,0x96,0x1f
	.ascii "gl_eval_vertex\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xac,0xd7
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0xac,0x7d,0x1c,0x00,0x00,0xac,0x87,0x1c
	.byte 0x00,0x00,0xac,0x91,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x1c,0x00,0x00,0xac,0x9b,0x00,0x11
	.byte 0x00,0x00,0x6f,0x8e,0x08,0x00,0x00,0xac
	.byte 0xd7,0x1f
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xad,0x03
	.byte 0x1c,0x00,0x00,0x45,0x19,0x1c,0x00,0x00
	.byte 0x05,0x7e,0x1c,0x00,0x00,0xac,0xdc,0x00
	.byte 0x20
	.ascii "malloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x3a,0x42,0x01
	.byte 0x00,0x00,0xad,0x1d,0x1c,0x00,0x00,0x02
	.byte 0x1d,0x00,0x1f
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xad,0x31
	.byte 0x1c,0x00,0x00,0x3a,0x42,0x00,0x21
	.ascii "sqrt\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x36,0xc7,0x01
	.byte 0x1c,0x00,0x00,0x36,0xc7,0x00,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=124, siz=4, lab1=gl_init_eval, lab2=, loff=0
!   reloc[1]: knd=0, off=131, siz=4, lab1=.L19, lab2=, loff=0
!   reloc[2]: knd=0, off=143, siz=4, lab1=.L26, lab2=, loff=0
!   reloc[3]: knd=0, off=153, siz=4, lab1=.L27, lab2=, loff=0
!   reloc[4]: knd=0, off=166, siz=4, lab1=horner_bezier_curve, lab2=, loff=0
!   reloc[5]: knd=0, off=173, siz=4, lab1=.L36, lab2=, loff=0
!   reloc[6]: knd=0, off=185, siz=4, lab1=.L40, lab2=, loff=0
!   reloc[7]: knd=0, off=193, siz=4, lab1=.L41, lab2=, loff=0
!   reloc[8]: knd=0, off=201, siz=4, lab1=.L43, lab2=, loff=0
!   reloc[9]: knd=0, off=209, siz=4, lab1=.L49, lab2=, loff=0
!   reloc[10]: knd=0, off=217, siz=4, lab1=.L51, lab2=, loff=0
!   reloc[11]: knd=0, off=225, siz=4, lab1=.L55, lab2=, loff=0
!   reloc[12]: knd=0, off=235, siz=4, lab1=.L62, lab2=, loff=0
!   reloc[13]: knd=0, off=243, siz=4, lab1=.L63, lab2=, loff=0
!   reloc[14]: knd=0, off=251, siz=4, lab1=.L65, lab2=, loff=0
!   reloc[15]: knd=0, off=259, siz=4, lab1=.L71, lab2=, loff=0
!   reloc[16]: knd=0, off=267, siz=4, lab1=.L73, lab2=, loff=0
!   reloc[17]: knd=0, off=275, siz=4, lab1=.L78, lab2=, loff=0
!   reloc[18]: knd=0, off=285, siz=4, lab1=.L87, lab2=, loff=0
!   reloc[19]: knd=0, off=295, siz=4, lab1=.L93, lab2=, loff=0
!   reloc[20]: knd=0, off=303, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[21]: knd=0, off=311, siz=4, lab1=.L101, lab2=, loff=0
!   reloc[22]: knd=0, off=326, siz=4, lab1=horner_bezier_surf, lab2=, loff=0
!   reloc[23]: knd=0, off=333, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[24]: knd=0, off=345, siz=4, lab1=.L109, lab2=, loff=0
!   reloc[25]: knd=0, off=353, siz=4, lab1=.L112, lab2=, loff=0
!   reloc[26]: knd=0, off=361, siz=4, lab1=.L118, lab2=, loff=0
!   reloc[27]: knd=0, off=369, siz=4, lab1=.L123, lab2=, loff=0
!   reloc[28]: knd=0, off=379, siz=4, lab1=.L130, lab2=, loff=0
!   reloc[29]: knd=0, off=387, siz=4, lab1=.L131, lab2=, loff=0
!   reloc[30]: knd=0, off=397, siz=4, lab1=.L132, lab2=, loff=0
!   reloc[31]: knd=0, off=405, siz=4, lab1=.L134, lab2=, loff=0
!   reloc[32]: knd=0, off=413, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[33]: knd=0, off=421, siz=4, lab1=.L142, lab2=, loff=0
!   reloc[34]: knd=0, off=429, siz=4, lab1=.L146, lab2=, loff=0
!   reloc[35]: knd=0, off=439, siz=4, lab1=.L153, lab2=, loff=0
!   reloc[36]: knd=0, off=449, siz=4, lab1=.L154, lab2=, loff=0
!   reloc[37]: knd=0, off=457, siz=4, lab1=.L156, lab2=, loff=0
!   reloc[38]: knd=0, off=465, siz=4, lab1=.L162, lab2=, loff=0
!   reloc[39]: knd=0, off=473, siz=4, lab1=.L164, lab2=, loff=0
!   reloc[40]: knd=0, off=481, siz=4, lab1=.L169, lab2=, loff=0
!   reloc[41]: knd=0, off=491, siz=4, lab1=.L170, lab2=, loff=0
!   reloc[42]: knd=0, off=499, siz=4, lab1=.L175, lab2=, loff=0
!   reloc[43]: knd=0, off=509, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[44]: knd=0, off=519, siz=4, lab1=.L183, lab2=, loff=0
!   reloc[45]: knd=0, off=529, siz=4, lab1=.L193, lab2=, loff=0
!   reloc[46]: knd=0, off=539, siz=4, lab1=.L198, lab2=, loff=0
!   reloc[47]: knd=0, off=549, siz=4, lab1=.L205, lab2=, loff=0
!   reloc[48]: knd=0, off=559, siz=4, lab1=.L208, lab2=, loff=0
!   reloc[49]: knd=0, off=569, siz=4, lab1=.L211, lab2=, loff=0
!   reloc[50]: knd=0, off=579, siz=4, lab1=.L216, lab2=, loff=0
!   reloc[51]: knd=0, off=589, siz=4, lab1=.L222, lab2=, loff=0
!   reloc[52]: knd=0, off=602, siz=4, lab1=de_casteljau_surf, lab2=, loff=0
!   reloc[53]: knd=0, off=609, siz=4, lab1=.L229, lab2=, loff=0
!   reloc[54]: knd=0, off=621, siz=4, lab1=.L230, lab2=, loff=0
!   reloc[55]: knd=0, off=629, siz=4, lab1=.L231, lab2=, loff=0
!   reloc[56]: knd=0, off=637, siz=4, lab1=.L235, lab2=, loff=0
!   reloc[57]: knd=0, off=645, siz=4, lab1=.L236, lab2=, loff=0
!   reloc[58]: knd=0, off=653, siz=4, lab1=.L239, lab2=, loff=0
!   reloc[59]: knd=0, off=663, siz=4, lab1=.L245, lab2=, loff=0
!   reloc[60]: knd=0, off=671, siz=4, lab1=.L250, lab2=, loff=0
!   reloc[61]: knd=0, off=679, siz=4, lab1=.L257, lab2=, loff=0
!   reloc[62]: knd=0, off=689, siz=4, lab1=.L258, lab2=, loff=0
!   reloc[63]: knd=0, off=699, siz=4, lab1=.L259, lab2=, loff=0
!   reloc[64]: knd=0, off=709, siz=4, lab1=.L262, lab2=, loff=0
!   reloc[65]: knd=0, off=719, siz=4, lab1=.L271, lab2=, loff=0
!   reloc[66]: knd=0, off=729, siz=4, lab1=.L276, lab2=, loff=0
!   reloc[67]: knd=0, off=737, siz=4, lab1=.L283, lab2=, loff=0
!   reloc[68]: knd=0, off=747, siz=4, lab1=.L284, lab2=, loff=0
!   reloc[69]: knd=0, off=755, siz=4, lab1=.L286, lab2=, loff=0
!   reloc[70]: knd=0, off=763, siz=4, lab1=.L293, lab2=, loff=0
!   reloc[71]: knd=0, off=773, siz=4, lab1=.L294, lab2=, loff=0
!   reloc[72]: knd=0, off=781, siz=4, lab1=.L295, lab2=, loff=0
!   reloc[73]: knd=0, off=791, siz=4, lab1=.L296, lab2=, loff=0
!   reloc[74]: knd=0, off=799, siz=4, lab1=.L299, lab2=, loff=0
!   reloc[75]: knd=0, off=809, siz=4, lab1=.L303, lab2=, loff=0
!   reloc[76]: knd=0, off=819, siz=4, lab1=.L310, lab2=, loff=0
!   reloc[77]: knd=0, off=827, siz=4, lab1=.L317, lab2=, loff=0
!   reloc[78]: knd=0, off=837, siz=4, lab1=.L318, lab2=, loff=0
!   reloc[79]: knd=0, off=847, siz=4, lab1=.L321, lab2=, loff=0
!   reloc[80]: knd=0, off=857, siz=4, lab1=.L325, lab2=, loff=0
!   reloc[81]: knd=0, off=865, siz=4, lab1=.L328, lab2=, loff=0
!   reloc[82]: knd=0, off=875, siz=4, lab1=.L329, lab2=, loff=0
!   reloc[83]: knd=0, off=885, siz=4, lab1=.L330, lab2=, loff=0
!   reloc[84]: knd=0, off=895, siz=4, lab1=.L333, lab2=, loff=0
!   reloc[85]: knd=0, off=905, siz=4, lab1=.L342, lab2=, loff=0
!   reloc[86]: knd=0, off=915, siz=4, lab1=.L349, lab2=, loff=0
!   reloc[87]: knd=0, off=925, siz=4, lab1=.L350, lab2=, loff=0
!   reloc[88]: knd=0, off=933, siz=4, lab1=.L352, lab2=, loff=0
!   reloc[89]: knd=0, off=941, siz=4, lab1=.L359, lab2=, loff=0
!   reloc[90]: knd=0, off=951, siz=4, lab1=.L360, lab2=, loff=0
!   reloc[91]: knd=0, off=959, siz=4, lab1=.L361, lab2=, loff=0
!   reloc[92]: knd=0, off=969, siz=4, lab1=.L362, lab2=, loff=0
!   reloc[93]: knd=0, off=977, siz=4, lab1=.L365, lab2=, loff=0
!   reloc[94]: knd=0, off=987, siz=4, lab1=.L369, lab2=, loff=0
!   reloc[95]: knd=0, off=997, siz=4, lab1=.L376, lab2=, loff=0
!   reloc[96]: knd=0, off=1005, siz=4, lab1=.L383, lab2=, loff=0
!   reloc[97]: knd=0, off=1015, siz=4, lab1=.L384, lab2=, loff=0
!   reloc[98]: knd=0, off=1025, siz=4, lab1=.L387, lab2=, loff=0
!   reloc[99]: knd=0, off=1035, siz=4, lab1=.L391, lab2=, loff=0
!   reloc[100]: knd=0, off=1043, siz=4, lab1=.L394, lab2=, loff=0
!   reloc[101]: knd=0, off=1053, siz=4, lab1=.L395, lab2=, loff=0
!   reloc[102]: knd=0, off=1063, siz=4, lab1=.L396, lab2=, loff=0
!   reloc[103]: knd=0, off=1073, siz=4, lab1=.L399, lab2=, loff=0
!   reloc[104]: knd=0, off=1083, siz=4, lab1=.L413, lab2=, loff=0
!   reloc[105]: knd=0, off=1093, siz=4, lab1=.L418, lab2=, loff=0
!   reloc[106]: knd=0, off=1101, siz=4, lab1=.L426, lab2=, loff=0
!   reloc[107]: knd=0, off=1111, siz=4, lab1=.L433, lab2=, loff=0
!   reloc[108]: knd=0, off=1119, siz=4, lab1=.L435, lab2=, loff=0
!   reloc[109]: knd=0, off=1127, siz=4, lab1=.L442, lab2=, loff=0
!   reloc[110]: knd=0, off=1135, siz=4, lab1=.L443, lab2=, loff=0
!   reloc[111]: knd=0, off=1143, siz=4, lab1=.L446, lab2=, loff=0
!   reloc[112]: knd=0, off=1153, siz=4, lab1=.L451, lab2=, loff=0
!   reloc[113]: knd=0, off=1163, siz=4, lab1=.L455, lab2=, loff=0
!   reloc[114]: knd=0, off=1173, siz=4, lab1=.L462, lab2=, loff=0
!   reloc[115]: knd=0, off=1181, siz=4, lab1=.L469, lab2=, loff=0
!   reloc[116]: knd=0, off=1189, siz=4, lab1=.L471, lab2=, loff=0
!   reloc[117]: knd=0, off=1197, siz=4, lab1=.L478, lab2=, loff=0
!   reloc[118]: knd=0, off=1205, siz=4, lab1=.L479, lab2=, loff=0
!   reloc[119]: knd=0, off=1213, siz=4, lab1=.L482, lab2=, loff=0
!   reloc[120]: knd=0, off=1223, siz=4, lab1=.L487, lab2=, loff=0
!   reloc[121]: knd=0, off=1233, siz=4, lab1=.L491, lab2=, loff=0
!   reloc[122]: knd=0, off=1241, siz=4, lab1=.L494, lab2=, loff=0
!   reloc[123]: knd=0, off=1251, siz=4, lab1=.L495, lab2=, loff=0
!   reloc[124]: knd=0, off=1261, siz=4, lab1=.L496, lab2=, loff=0
!   reloc[125]: knd=0, off=1271, siz=4, lab1=.L499, lab2=, loff=0
!   reloc[126]: knd=0, off=1281, siz=4, lab1=.L508, lab2=, loff=0
!   reloc[127]: knd=0, off=1291, siz=4, lab1=.L513, lab2=, loff=0
!   reloc[128]: knd=0, off=1299, siz=4, lab1=.L521, lab2=, loff=0
!   reloc[129]: knd=0, off=1309, siz=4, lab1=.L528, lab2=, loff=0
!   reloc[130]: knd=0, off=1317, siz=4, lab1=.L530, lab2=, loff=0
!   reloc[131]: knd=0, off=1325, siz=4, lab1=.L537, lab2=, loff=0
!   reloc[132]: knd=0, off=1333, siz=4, lab1=.L538, lab2=, loff=0
!   reloc[133]: knd=0, off=1341, siz=4, lab1=.L541, lab2=, loff=0
!   reloc[134]: knd=0, off=1351, siz=4, lab1=.L546, lab2=, loff=0
!   reloc[135]: knd=0, off=1361, siz=4, lab1=.L550, lab2=, loff=0
!   reloc[136]: knd=0, off=1371, siz=4, lab1=.L557, lab2=, loff=0
!   reloc[137]: knd=0, off=1379, siz=4, lab1=.L564, lab2=, loff=0
!   reloc[138]: knd=0, off=1387, siz=4, lab1=.L566, lab2=, loff=0
!   reloc[139]: knd=0, off=1395, siz=4, lab1=.L573, lab2=, loff=0
!   reloc[140]: knd=0, off=1403, siz=4, lab1=.L574, lab2=, loff=0
!   reloc[141]: knd=0, off=1411, siz=4, lab1=.L577, lab2=, loff=0
!   reloc[142]: knd=0, off=1421, siz=4, lab1=.L582, lab2=, loff=0
!   reloc[143]: knd=0, off=1431, siz=4, lab1=.L586, lab2=, loff=0
!   reloc[144]: knd=0, off=1439, siz=4, lab1=.L589, lab2=, loff=0
!   reloc[145]: knd=0, off=1449, siz=4, lab1=.L590, lab2=, loff=0
!   reloc[146]: knd=0, off=1457, siz=4, lab1=.L592, lab2=, loff=0
!   reloc[147]: knd=0, off=1465, siz=4, lab1=.L599, lab2=, loff=0
!   reloc[148]: knd=0, off=1475, siz=4, lab1=.L600, lab2=, loff=0
!   reloc[149]: knd=0, off=1483, siz=4, lab1=.L601, lab2=, loff=0
!   reloc[150]: knd=0, off=1493, siz=4, lab1=.L602, lab2=, loff=0
!   reloc[151]: knd=0, off=1501, siz=4, lab1=.L605, lab2=, loff=0
!   reloc[152]: knd=0, off=1511, siz=4, lab1=.L609, lab2=, loff=0
!   reloc[153]: knd=0, off=1521, siz=4, lab1=.L616, lab2=, loff=0
!   reloc[154]: knd=0, off=1529, siz=4, lab1=.L623, lab2=, loff=0
!   reloc[155]: knd=0, off=1539, siz=4, lab1=.L624, lab2=, loff=0
!   reloc[156]: knd=0, off=1549, siz=4, lab1=.L627, lab2=, loff=0
!   reloc[157]: knd=0, off=1559, siz=4, lab1=.L631, lab2=, loff=0
!   reloc[158]: knd=0, off=1567, siz=4, lab1=.L634, lab2=, loff=0
!   reloc[159]: knd=0, off=1577, siz=4, lab1=.L635, lab2=, loff=0
!   reloc[160]: knd=0, off=1587, siz=4, lab1=.L636, lab2=, loff=0
!   reloc[161]: knd=0, off=1597, siz=4, lab1=.L639, lab2=, loff=0
!   reloc[162]: knd=0, off=1607, siz=4, lab1=.L648, lab2=, loff=0
!   reloc[163]: knd=0, off=1617, siz=4, lab1=.L656, lab2=, loff=0
!   reloc[164]: knd=0, off=1627, siz=4, lab1=.L663, lab2=, loff=0
!   reloc[165]: knd=0, off=1635, siz=4, lab1=.L665, lab2=, loff=0
!   reloc[166]: knd=0, off=1643, siz=4, lab1=.L672, lab2=, loff=0
!   reloc[167]: knd=0, off=1651, siz=4, lab1=.L673, lab2=, loff=0
!   reloc[168]: knd=0, off=1659, siz=4, lab1=.L676, lab2=, loff=0
!   reloc[169]: knd=0, off=1669, siz=4, lab1=.L681, lab2=, loff=0
!   reloc[170]: knd=0, off=1679, siz=4, lab1=.L685, lab2=, loff=0
!   reloc[171]: knd=0, off=1689, siz=4, lab1=.L692, lab2=, loff=0
!   reloc[172]: knd=0, off=1697, siz=4, lab1=.L699, lab2=, loff=0
!   reloc[173]: knd=0, off=1705, siz=4, lab1=.L701, lab2=, loff=0
!   reloc[174]: knd=0, off=1713, siz=4, lab1=.L708, lab2=, loff=0
!   reloc[175]: knd=0, off=1721, siz=4, lab1=.L709, lab2=, loff=0
!   reloc[176]: knd=0, off=1729, siz=4, lab1=.L712, lab2=, loff=0
!   reloc[177]: knd=0, off=1739, siz=4, lab1=.L717, lab2=, loff=0
!   reloc[178]: knd=0, off=1749, siz=4, lab1=.L721, lab2=, loff=0
!   reloc[179]: knd=0, off=1757, siz=4, lab1=.L724, lab2=, loff=0
!   reloc[180]: knd=0, off=1767, siz=4, lab1=.L725, lab2=, loff=0
!   reloc[181]: knd=0, off=1775, siz=4, lab1=.L727, lab2=, loff=0
!   reloc[182]: knd=0, off=1783, siz=4, lab1=.L734, lab2=, loff=0
!   reloc[183]: knd=0, off=1793, siz=4, lab1=.L735, lab2=, loff=0
!   reloc[184]: knd=0, off=1801, siz=4, lab1=.L736, lab2=, loff=0
!   reloc[185]: knd=0, off=1811, siz=4, lab1=.L737, lab2=, loff=0
!   reloc[186]: knd=0, off=1819, siz=4, lab1=.L740, lab2=, loff=0
!   reloc[187]: knd=0, off=1829, siz=4, lab1=.L744, lab2=, loff=0
!   reloc[188]: knd=0, off=1839, siz=4, lab1=.L751, lab2=, loff=0
!   reloc[189]: knd=0, off=1847, siz=4, lab1=.L758, lab2=, loff=0
!   reloc[190]: knd=0, off=1857, siz=4, lab1=.L759, lab2=, loff=0
!   reloc[191]: knd=0, off=1867, siz=4, lab1=.L762, lab2=, loff=0
!   reloc[192]: knd=0, off=1877, siz=4, lab1=.L766, lab2=, loff=0
!   reloc[193]: knd=0, off=1885, siz=4, lab1=.L769, lab2=, loff=0
!   reloc[194]: knd=0, off=1895, siz=4, lab1=.L770, lab2=, loff=0
!   reloc[195]: knd=0, off=1905, siz=4, lab1=.L771, lab2=, loff=0
!   reloc[196]: knd=0, off=1915, siz=4, lab1=.L774, lab2=, loff=0
!   reloc[197]: knd=0, off=1925, siz=4, lab1=.L784, lab2=, loff=0
!   reloc[198]: knd=0, off=1940, siz=4, lab1=components, lab2=, loff=0
!   reloc[199]: knd=0, off=1947, siz=4, lab1=.L794, lab2=, loff=0
!   reloc[200]: knd=0, off=1959, siz=4, lab1=.L798, lab2=, loff=0
!   reloc[201]: knd=0, off=1967, siz=4, lab1=.L800, lab2=, loff=0
!   reloc[202]: knd=0, off=1975, siz=4, lab1=.L802, lab2=, loff=0
!   reloc[203]: knd=0, off=1983, siz=4, lab1=.L804, lab2=, loff=0
!   reloc[204]: knd=0, off=1991, siz=4, lab1=.L806, lab2=, loff=0
!   reloc[205]: knd=0, off=1999, siz=4, lab1=.L808, lab2=, loff=0
!   reloc[206]: knd=0, off=2007, siz=4, lab1=.L810, lab2=, loff=0
!   reloc[207]: knd=0, off=2015, siz=4, lab1=.L812, lab2=, loff=0
!   reloc[208]: knd=0, off=2023, siz=4, lab1=.L814, lab2=, loff=0
!   reloc[209]: knd=0, off=2031, siz=4, lab1=.L816, lab2=, loff=0
!   reloc[210]: knd=0, off=2039, siz=4, lab1=.L818, lab2=, loff=0
!   reloc[211]: knd=0, off=2047, siz=4, lab1=.L820, lab2=, loff=0
!   reloc[212]: knd=0, off=2055, siz=4, lab1=.L822, lab2=, loff=0
!   reloc[213]: knd=0, off=2063, siz=4, lab1=.L824, lab2=, loff=0
!   reloc[214]: knd=0, off=2071, siz=4, lab1=.L826, lab2=, loff=0
!   reloc[215]: knd=0, off=2079, siz=4, lab1=.L828, lab2=, loff=0
!   reloc[216]: knd=0, off=2087, siz=4, lab1=.L830, lab2=, loff=0
!   reloc[217]: knd=0, off=2095, siz=4, lab1=.L832, lab2=, loff=0
!   reloc[218]: knd=0, off=2103, siz=4, lab1=.L834, lab2=, loff=0
!   reloc[219]: knd=0, off=2111, siz=4, lab1=.L837, lab2=, loff=0
!   reloc[220]: knd=0, off=2121, siz=4, lab1=.L840, lab2=, loff=0
!   reloc[221]: knd=0, off=2136, siz=4, lab1=gl_copy_map_points1f, lab2=, loff=0
!   reloc[222]: knd=0, off=2143, siz=4, lab1=.L847, lab2=, loff=0
!   reloc[223]: knd=0, off=2155, siz=4, lab1=.L850, lab2=, loff=0
!   reloc[224]: knd=0, off=2163, siz=4, lab1=.L856, lab2=, loff=0
!   reloc[225]: knd=0, off=2171, siz=4, lab1=.L860, lab2=, loff=0
!   reloc[226]: knd=0, off=2181, siz=4, lab1=.L863, lab2=, loff=0
!   reloc[227]: knd=0, off=2189, siz=4, lab1=.L867, lab2=, loff=0
!   reloc[228]: knd=0, off=2197, siz=4, lab1=.L874, lab2=, loff=0
!   reloc[229]: knd=0, off=2205, siz=4, lab1=.L880, lab2=, loff=0
!   reloc[230]: knd=0, off=2213, siz=4, lab1=.L882, lab2=, loff=0
!   reloc[231]: knd=0, off=2221, siz=4, lab1=.L886, lab2=, loff=0
!   reloc[232]: knd=0, off=2229, siz=4, lab1=.L891, lab2=, loff=0
!   reloc[233]: knd=0, off=2239, siz=4, lab1=.L892, lab2=, loff=0
!   reloc[234]: knd=0, off=2252, siz=4, lab1=gl_copy_map_points1d, lab2=, loff=0
!   reloc[235]: knd=0, off=2259, siz=4, lab1=.L899, lab2=, loff=0
!   reloc[236]: knd=0, off=2271, siz=4, lab1=.L900, lab2=, loff=0
!   reloc[237]: knd=0, off=2279, siz=4, lab1=.L903, lab2=, loff=0
!   reloc[238]: knd=0, off=2287, siz=4, lab1=.L907, lab2=, loff=0
!   reloc[239]: knd=0, off=2295, siz=4, lab1=.L914, lab2=, loff=0
!   reloc[240]: knd=0, off=2303, siz=4, lab1=.L920, lab2=, loff=0
!   reloc[241]: knd=0, off=2311, siz=4, lab1=.L922, lab2=, loff=0
!   reloc[242]: knd=0, off=2319, siz=4, lab1=.L926, lab2=, loff=0
!   reloc[243]: knd=0, off=2327, siz=4, lab1=.L931, lab2=, loff=0
!   reloc[244]: knd=0, off=2337, siz=4, lab1=.L932, lab2=, loff=0
!   reloc[245]: knd=0, off=2350, siz=4, lab1=gl_copy_map_points2f, lab2=, loff=0
!   reloc[246]: knd=0, off=2357, siz=4, lab1=.L939, lab2=, loff=0
!   reloc[247]: knd=0, off=2369, siz=4, lab1=.L940, lab2=, loff=0
!   reloc[248]: knd=0, off=2379, siz=4, lab1=.L945, lab2=, loff=0
!   reloc[249]: knd=0, off=2387, siz=4, lab1=.L951, lab2=, loff=0
!   reloc[250]: knd=0, off=2395, siz=4, lab1=.L954, lab2=, loff=0
!   reloc[251]: knd=0, off=2403, siz=4, lab1=.L958, lab2=, loff=0
!   reloc[252]: knd=0, off=2411, siz=4, lab1=.L961, lab2=, loff=0
!   reloc[253]: knd=0, off=2421, siz=4, lab1=.L964, lab2=, loff=0
!   reloc[254]: knd=0, off=2429, siz=4, lab1=.L968, lab2=, loff=0
!   reloc[255]: knd=0, off=2437, siz=4, lab1=.L975, lab2=, loff=0
!   reloc[256]: knd=0, off=2445, siz=4, lab1=.L982, lab2=, loff=0
!   reloc[257]: knd=0, off=2453, siz=4, lab1=.L988, lab2=, loff=0
!   reloc[258]: knd=0, off=2461, siz=4, lab1=.L990, lab2=, loff=0
!   reloc[259]: knd=0, off=2469, siz=4, lab1=.L994, lab2=, loff=0
!   reloc[260]: knd=0, off=2477, siz=4, lab1=.L998, lab2=, loff=0
!   reloc[261]: knd=0, off=2485, siz=4, lab1=.L1003, lab2=, loff=0
!   reloc[262]: knd=0, off=2495, siz=4, lab1=.L1004, lab2=, loff=0
!   reloc[263]: knd=0, off=2508, siz=4, lab1=gl_copy_map_points2d, lab2=, loff=0
!   reloc[264]: knd=0, off=2515, siz=4, lab1=.L1011, lab2=, loff=0
!   reloc[265]: knd=0, off=2527, siz=4, lab1=.L1012, lab2=, loff=0
!   reloc[266]: knd=0, off=2537, siz=4, lab1=.L1017, lab2=, loff=0
!   reloc[267]: knd=0, off=2545, siz=4, lab1=.L1023, lab2=, loff=0
!   reloc[268]: knd=0, off=2553, siz=4, lab1=.L1026, lab2=, loff=0
!   reloc[269]: knd=0, off=2561, siz=4, lab1=.L1030, lab2=, loff=0
!   reloc[270]: knd=0, off=2569, siz=4, lab1=.L1033, lab2=, loff=0
!   reloc[271]: knd=0, off=2579, siz=4, lab1=.L1036, lab2=, loff=0
!   reloc[272]: knd=0, off=2587, siz=4, lab1=.L1040, lab2=, loff=0
!   reloc[273]: knd=0, off=2595, siz=4, lab1=.L1047, lab2=, loff=0
!   reloc[274]: knd=0, off=2603, siz=4, lab1=.L1054, lab2=, loff=0
!   reloc[275]: knd=0, off=2611, siz=4, lab1=.L1060, lab2=, loff=0
!   reloc[276]: knd=0, off=2619, siz=4, lab1=.L1062, lab2=, loff=0
!   reloc[277]: knd=0, off=2627, siz=4, lab1=.L1066, lab2=, loff=0
!   reloc[278]: knd=0, off=2635, siz=4, lab1=.L1070, lab2=, loff=0
!   reloc[279]: knd=0, off=2643, siz=4, lab1=.L1075, lab2=, loff=0
!   reloc[280]: knd=0, off=2653, siz=4, lab1=.L1076, lab2=, loff=0
!   reloc[281]: knd=0, off=2666, siz=4, lab1=gl_free_control_points, lab2=, loff=0
!   reloc[282]: knd=0, off=2673, siz=4, lab1=.L1083, lab2=, loff=0
!   reloc[283]: knd=0, off=2685, siz=4, lab1=.L1084, lab2=, loff=0
!   reloc[284]: knd=0, off=2693, siz=4, lab1=.L1088, lab2=, loff=0
!   reloc[285]: knd=0, off=2701, siz=4, lab1=.L1092, lab2=, loff=0
!   reloc[286]: knd=0, off=2709, siz=4, lab1=.L1093, lab2=, loff=0
!   reloc[287]: knd=0, off=2717, siz=4, lab1=.L1095, lab2=, loff=0
!   reloc[288]: knd=0, off=2725, siz=4, lab1=.L1096, lab2=, loff=0
!   reloc[289]: knd=0, off=2733, siz=4, lab1=.L1098, lab2=, loff=0
!   reloc[290]: knd=0, off=2741, siz=4, lab1=.L1099, lab2=, loff=0
!   reloc[291]: knd=0, off=2749, siz=4, lab1=.L1101, lab2=, loff=0
!   reloc[292]: knd=0, off=2757, siz=4, lab1=.L1102, lab2=, loff=0
!   reloc[293]: knd=0, off=2765, siz=4, lab1=.L1104, lab2=, loff=0
!   reloc[294]: knd=0, off=2773, siz=4, lab1=.L1105, lab2=, loff=0
!   reloc[295]: knd=0, off=2781, siz=4, lab1=.L1107, lab2=, loff=0
!   reloc[296]: knd=0, off=2789, siz=4, lab1=.L1108, lab2=, loff=0
!   reloc[297]: knd=0, off=2797, siz=4, lab1=.L1110, lab2=, loff=0
!   reloc[298]: knd=0, off=2805, siz=4, lab1=.L1111, lab2=, loff=0
!   reloc[299]: knd=0, off=2813, siz=4, lab1=.L1113, lab2=, loff=0
!   reloc[300]: knd=0, off=2821, siz=4, lab1=.L1114, lab2=, loff=0
!   reloc[301]: knd=0, off=2829, siz=4, lab1=.L1116, lab2=, loff=0
!   reloc[302]: knd=0, off=2837, siz=4, lab1=.L1117, lab2=, loff=0
!   reloc[303]: knd=0, off=2845, siz=4, lab1=.L1119, lab2=, loff=0
!   reloc[304]: knd=0, off=2853, siz=4, lab1=.L1120, lab2=, loff=0
!   reloc[305]: knd=0, off=2861, siz=4, lab1=.L1122, lab2=, loff=0
!   reloc[306]: knd=0, off=2869, siz=4, lab1=.L1123, lab2=, loff=0
!   reloc[307]: knd=0, off=2877, siz=4, lab1=.L1125, lab2=, loff=0
!   reloc[308]: knd=0, off=2885, siz=4, lab1=.L1126, lab2=, loff=0
!   reloc[309]: knd=0, off=2893, siz=4, lab1=.L1128, lab2=, loff=0
!   reloc[310]: knd=0, off=2901, siz=4, lab1=.L1129, lab2=, loff=0
!   reloc[311]: knd=0, off=2909, siz=4, lab1=.L1131, lab2=, loff=0
!   reloc[312]: knd=0, off=2917, siz=4, lab1=.L1132, lab2=, loff=0
!   reloc[313]: knd=0, off=2925, siz=4, lab1=.L1134, lab2=, loff=0
!   reloc[314]: knd=0, off=2933, siz=4, lab1=.L1135, lab2=, loff=0
!   reloc[315]: knd=0, off=2941, siz=4, lab1=.L1137, lab2=, loff=0
!   reloc[316]: knd=0, off=2949, siz=4, lab1=.L1138, lab2=, loff=0
!   reloc[317]: knd=0, off=2957, siz=4, lab1=.L1140, lab2=, loff=0
!   reloc[318]: knd=0, off=2965, siz=4, lab1=.L1141, lab2=, loff=0
!   reloc[319]: knd=0, off=2973, siz=4, lab1=.L1143, lab2=, loff=0
!   reloc[320]: knd=0, off=2981, siz=4, lab1=.L1144, lab2=, loff=0
!   reloc[321]: knd=0, off=2989, siz=4, lab1=.L1146, lab2=, loff=0
!   reloc[322]: knd=0, off=2997, siz=4, lab1=.L1148, lab2=, loff=0
!   reloc[323]: knd=0, off=3005, siz=4, lab1=.L1151, lab2=, loff=0
!   reloc[324]: knd=0, off=3015, siz=4, lab1=.L1156, lab2=, loff=0
!   reloc[325]: knd=0, off=3025, siz=4, lab1=.L1162, lab2=, loff=0
!   reloc[326]: knd=0, off=3033, siz=4, lab1=.L1166, lab2=, loff=0
!   reloc[327]: knd=0, off=3043, siz=4, lab1=.L1172, lab2=, loff=0
!   reloc[328]: knd=0, off=3053, siz=4, lab1=.L1181, lab2=, loff=0
!   reloc[329]: knd=0, off=3063, siz=4, lab1=.L1187, lab2=, loff=0
!   reloc[330]: knd=0, off=3071, siz=4, lab1=.L1191, lab2=, loff=0
!   reloc[331]: knd=0, off=3081, siz=4, lab1=.L1197, lab2=, loff=0
!   reloc[332]: knd=0, off=3091, siz=4, lab1=.L1204, lab2=, loff=0
!   reloc[333]: knd=0, off=3106, siz=4, lab1=gl_Map1f, lab2=, loff=0
!   reloc[334]: knd=0, off=3113, siz=4, lab1=.L1213, lab2=, loff=0
!   reloc[335]: knd=0, off=3125, siz=4, lab1=.L1217, lab2=, loff=0
!   reloc[336]: knd=0, off=3133, siz=4, lab1=.L1219, lab2=, loff=0
!   reloc[337]: knd=0, off=3141, siz=4, lab1=.L1223, lab2=, loff=0
!   reloc[338]: knd=0, off=3151, siz=4, lab1=.L1226, lab2=, loff=0
!   reloc[339]: knd=0, off=3159, siz=4, lab1=.L1230, lab2=, loff=0
!   reloc[340]: knd=0, off=3167, siz=4, lab1=.L1232, lab2=, loff=0
!   reloc[341]: knd=0, off=3175, siz=4, lab1=.L1238, lab2=, loff=0
!   reloc[342]: knd=0, off=3185, siz=4, lab1=.L1242, lab2=, loff=0
!   reloc[343]: knd=0, off=3193, siz=4, lab1=.L1244, lab2=, loff=0
!   reloc[344]: knd=0, off=3201, siz=4, lab1=.L1250, lab2=, loff=0
!   reloc[345]: knd=0, off=3211, siz=4, lab1=.L1256, lab2=, loff=0
!   reloc[346]: knd=0, off=3219, siz=4, lab1=.L1258, lab2=, loff=0
!   reloc[347]: knd=0, off=3227, siz=4, lab1=.L1262, lab2=, loff=0
!   reloc[348]: knd=0, off=3237, siz=4, lab1=.L1265, lab2=, loff=0
!   reloc[349]: knd=0, off=3245, siz=4, lab1=.L1269, lab2=, loff=0
!   reloc[350]: knd=0, off=3253, siz=4, lab1=.L1276, lab2=, loff=0
!   reloc[351]: knd=0, off=3263, siz=4, lab1=.L1280, lab2=, loff=0
!   reloc[352]: knd=0, off=3271, siz=4, lab1=.L1282, lab2=, loff=0
!   reloc[353]: knd=0, off=3279, siz=4, lab1=.L1289, lab2=, loff=0
!   reloc[354]: knd=0, off=3289, siz=4, lab1=.L1293, lab2=, loff=0
!   reloc[355]: knd=0, off=3297, siz=4, lab1=.L1294, lab2=, loff=0
!   reloc[356]: knd=0, off=3305, siz=4, lab1=.L1295, lab2=, loff=0
!   reloc[357]: knd=0, off=3313, siz=4, lab1=.L1298, lab2=, loff=0
!   reloc[358]: knd=0, off=3321, siz=4, lab1=.L1303, lab2=, loff=0
!   reloc[359]: knd=0, off=3329, siz=4, lab1=.L1307, lab2=, loff=0
!   reloc[360]: knd=0, off=3337, siz=4, lab1=.L1308, lab2=, loff=0
!   reloc[361]: knd=0, off=3345, siz=4, lab1=.L1309, lab2=, loff=0
!   reloc[362]: knd=0, off=3353, siz=4, lab1=.L1311, lab2=, loff=0
!   reloc[363]: knd=0, off=3361, siz=4, lab1=.L1312, lab2=, loff=0
!   reloc[364]: knd=0, off=3369, siz=4, lab1=.L1313, lab2=, loff=0
!   reloc[365]: knd=0, off=3377, siz=4, lab1=.L1316, lab2=, loff=0
!   reloc[366]: knd=0, off=3385, siz=4, lab1=.L1321, lab2=, loff=0
!   reloc[367]: knd=0, off=3393, siz=4, lab1=.L1325, lab2=, loff=0
!   reloc[368]: knd=0, off=3401, siz=4, lab1=.L1326, lab2=, loff=0
!   reloc[369]: knd=0, off=3409, siz=4, lab1=.L1327, lab2=, loff=0
!   reloc[370]: knd=0, off=3417, siz=4, lab1=.L1329, lab2=, loff=0
!   reloc[371]: knd=0, off=3425, siz=4, lab1=.L1330, lab2=, loff=0
!   reloc[372]: knd=0, off=3433, siz=4, lab1=.L1331, lab2=, loff=0
!   reloc[373]: knd=0, off=3441, siz=4, lab1=.L1334, lab2=, loff=0
!   reloc[374]: knd=0, off=3449, siz=4, lab1=.L1339, lab2=, loff=0
!   reloc[375]: knd=0, off=3457, siz=4, lab1=.L1343, lab2=, loff=0
!   reloc[376]: knd=0, off=3465, siz=4, lab1=.L1344, lab2=, loff=0
!   reloc[377]: knd=0, off=3473, siz=4, lab1=.L1345, lab2=, loff=0
!   reloc[378]: knd=0, off=3481, siz=4, lab1=.L1347, lab2=, loff=0
!   reloc[379]: knd=0, off=3489, siz=4, lab1=.L1348, lab2=, loff=0
!   reloc[380]: knd=0, off=3497, siz=4, lab1=.L1349, lab2=, loff=0
!   reloc[381]: knd=0, off=3505, siz=4, lab1=.L1352, lab2=, loff=0
!   reloc[382]: knd=0, off=3513, siz=4, lab1=.L1357, lab2=, loff=0
!   reloc[383]: knd=0, off=3521, siz=4, lab1=.L1361, lab2=, loff=0
!   reloc[384]: knd=0, off=3529, siz=4, lab1=.L1362, lab2=, loff=0
!   reloc[385]: knd=0, off=3537, siz=4, lab1=.L1363, lab2=, loff=0
!   reloc[386]: knd=0, off=3545, siz=4, lab1=.L1365, lab2=, loff=0
!   reloc[387]: knd=0, off=3553, siz=4, lab1=.L1366, lab2=, loff=0
!   reloc[388]: knd=0, off=3561, siz=4, lab1=.L1367, lab2=, loff=0
!   reloc[389]: knd=0, off=3569, siz=4, lab1=.L1370, lab2=, loff=0
!   reloc[390]: knd=0, off=3577, siz=4, lab1=.L1375, lab2=, loff=0
!   reloc[391]: knd=0, off=3585, siz=4, lab1=.L1379, lab2=, loff=0
!   reloc[392]: knd=0, off=3593, siz=4, lab1=.L1380, lab2=, loff=0
!   reloc[393]: knd=0, off=3601, siz=4, lab1=.L1381, lab2=, loff=0
!   reloc[394]: knd=0, off=3609, siz=4, lab1=.L1383, lab2=, loff=0
!   reloc[395]: knd=0, off=3617, siz=4, lab1=.L1384, lab2=, loff=0
!   reloc[396]: knd=0, off=3625, siz=4, lab1=.L1385, lab2=, loff=0
!   reloc[397]: knd=0, off=3633, siz=4, lab1=.L1388, lab2=, loff=0
!   reloc[398]: knd=0, off=3641, siz=4, lab1=.L1393, lab2=, loff=0
!   reloc[399]: knd=0, off=3649, siz=4, lab1=.L1397, lab2=, loff=0
!   reloc[400]: knd=0, off=3657, siz=4, lab1=.L1398, lab2=, loff=0
!   reloc[401]: knd=0, off=3665, siz=4, lab1=.L1399, lab2=, loff=0
!   reloc[402]: knd=0, off=3673, siz=4, lab1=.L1401, lab2=, loff=0
!   reloc[403]: knd=0, off=3681, siz=4, lab1=.L1402, lab2=, loff=0
!   reloc[404]: knd=0, off=3689, siz=4, lab1=.L1403, lab2=, loff=0
!   reloc[405]: knd=0, off=3697, siz=4, lab1=.L1406, lab2=, loff=0
!   reloc[406]: knd=0, off=3705, siz=4, lab1=.L1411, lab2=, loff=0
!   reloc[407]: knd=0, off=3713, siz=4, lab1=.L1415, lab2=, loff=0
!   reloc[408]: knd=0, off=3721, siz=4, lab1=.L1416, lab2=, loff=0
!   reloc[409]: knd=0, off=3729, siz=4, lab1=.L1417, lab2=, loff=0
!   reloc[410]: knd=0, off=3737, siz=4, lab1=.L1419, lab2=, loff=0
!   reloc[411]: knd=0, off=3745, siz=4, lab1=.L1420, lab2=, loff=0
!   reloc[412]: knd=0, off=3753, siz=4, lab1=.L1421, lab2=, loff=0
!   reloc[413]: knd=0, off=3761, siz=4, lab1=.L1424, lab2=, loff=0
!   reloc[414]: knd=0, off=3769, siz=4, lab1=.L1429, lab2=, loff=0
!   reloc[415]: knd=0, off=3777, siz=4, lab1=.L1433, lab2=, loff=0
!   reloc[416]: knd=0, off=3785, siz=4, lab1=.L1434, lab2=, loff=0
!   reloc[417]: knd=0, off=3793, siz=4, lab1=.L1435, lab2=, loff=0
!   reloc[418]: knd=0, off=3801, siz=4, lab1=.L1437, lab2=, loff=0
!   reloc[419]: knd=0, off=3809, siz=4, lab1=.L1438, lab2=, loff=0
!   reloc[420]: knd=0, off=3817, siz=4, lab1=.L1439, lab2=, loff=0
!   reloc[421]: knd=0, off=3825, siz=4, lab1=.L1442, lab2=, loff=0
!   reloc[422]: knd=0, off=3833, siz=4, lab1=.L1447, lab2=, loff=0
!   reloc[423]: knd=0, off=3841, siz=4, lab1=.L1451, lab2=, loff=0
!   reloc[424]: knd=0, off=3849, siz=4, lab1=.L1452, lab2=, loff=0
!   reloc[425]: knd=0, off=3857, siz=4, lab1=.L1453, lab2=, loff=0
!   reloc[426]: knd=0, off=3865, siz=4, lab1=.L1455, lab2=, loff=0
!   reloc[427]: knd=0, off=3873, siz=4, lab1=.L1459, lab2=, loff=0
!   reloc[428]: knd=0, off=3884, siz=4, lab1=.L1462, lab2=, loff=0
!   reloc[429]: knd=0, off=3900, siz=4, lab1=gl_Map2f, lab2=, loff=0
!   reloc[430]: knd=0, off=3907, siz=4, lab1=.L1471, lab2=, loff=0
!   reloc[431]: knd=0, off=3919, siz=4, lab1=.L1475, lab2=, loff=0
!   reloc[432]: knd=0, off=3927, siz=4, lab1=.L1477, lab2=, loff=0
!   reloc[433]: knd=0, off=3935, siz=4, lab1=.L1483, lab2=, loff=0
!   reloc[434]: knd=0, off=3945, siz=4, lab1=.L1487, lab2=, loff=0
!   reloc[435]: knd=0, off=3953, siz=4, lab1=.L1489, lab2=, loff=0
!   reloc[436]: knd=0, off=3961, siz=4, lab1=.L1495, lab2=, loff=0
!   reloc[437]: knd=0, off=3971, siz=4, lab1=.L1499, lab2=, loff=0
!   reloc[438]: knd=0, off=3979, siz=4, lab1=.L1501, lab2=, loff=0
!   reloc[439]: knd=0, off=3987, siz=4, lab1=.L1507, lab2=, loff=0
!   reloc[440]: knd=0, off=3997, siz=4, lab1=.L1513, lab2=, loff=0
!   reloc[441]: knd=0, off=4005, siz=4, lab1=.L1515, lab2=, loff=0
!   reloc[442]: knd=0, off=4013, siz=4, lab1=.L1521, lab2=, loff=0
!   reloc[443]: knd=0, off=4023, siz=4, lab1=.L1527, lab2=, loff=0
!   reloc[444]: knd=0, off=4031, siz=4, lab1=.L1529, lab2=, loff=0
!   reloc[445]: knd=0, off=4039, siz=4, lab1=.L1533, lab2=, loff=0
!   reloc[446]: knd=0, off=4049, siz=4, lab1=.L1536, lab2=, loff=0
!   reloc[447]: knd=0, off=4057, siz=4, lab1=.L1540, lab2=, loff=0
!   reloc[448]: knd=0, off=4065, siz=4, lab1=.L1547, lab2=, loff=0
!   reloc[449]: knd=0, off=4075, siz=4, lab1=.L1551, lab2=, loff=0
!   reloc[450]: knd=0, off=4083, siz=4, lab1=.L1553, lab2=, loff=0
!   reloc[451]: knd=0, off=4091, siz=4, lab1=.L1559, lab2=, loff=0
!   reloc[452]: knd=0, off=4099, siz=4, lab1=.L1563, lab2=, loff=0
!   reloc[453]: knd=0, off=4107, siz=4, lab1=.L1565, lab2=, loff=0
!   reloc[454]: knd=0, off=4115, siz=4, lab1=.L1572, lab2=, loff=0
!   reloc[455]: knd=0, off=4125, siz=4, lab1=.L1576, lab2=, loff=0
!   reloc[456]: knd=0, off=4133, siz=4, lab1=.L1577, lab2=, loff=0
!   reloc[457]: knd=0, off=4141, siz=4, lab1=.L1578, lab2=, loff=0
!   reloc[458]: knd=0, off=4149, siz=4, lab1=.L1579, lab2=, loff=0
!   reloc[459]: knd=0, off=4157, siz=4, lab1=.L1580, lab2=, loff=0
!   reloc[460]: knd=0, off=4165, siz=4, lab1=.L1581, lab2=, loff=0
!   reloc[461]: knd=0, off=4173, siz=4, lab1=.L1584, lab2=, loff=0
!   reloc[462]: knd=0, off=4181, siz=4, lab1=.L1589, lab2=, loff=0
!   reloc[463]: knd=0, off=4189, siz=4, lab1=.L1593, lab2=, loff=0
!   reloc[464]: knd=0, off=4197, siz=4, lab1=.L1594, lab2=, loff=0
!   reloc[465]: knd=0, off=4205, siz=4, lab1=.L1595, lab2=, loff=0
!   reloc[466]: knd=0, off=4213, siz=4, lab1=.L1597, lab2=, loff=0
!   reloc[467]: knd=0, off=4221, siz=4, lab1=.L1598, lab2=, loff=0
!   reloc[468]: knd=0, off=4229, siz=4, lab1=.L1599, lab2=, loff=0
!   reloc[469]: knd=0, off=4237, siz=4, lab1=.L1600, lab2=, loff=0
!   reloc[470]: knd=0, off=4245, siz=4, lab1=.L1601, lab2=, loff=0
!   reloc[471]: knd=0, off=4253, siz=4, lab1=.L1602, lab2=, loff=0
!   reloc[472]: knd=0, off=4261, siz=4, lab1=.L1605, lab2=, loff=0
!   reloc[473]: knd=0, off=4269, siz=4, lab1=.L1610, lab2=, loff=0
!   reloc[474]: knd=0, off=4277, siz=4, lab1=.L1614, lab2=, loff=0
!   reloc[475]: knd=0, off=4285, siz=4, lab1=.L1615, lab2=, loff=0
!   reloc[476]: knd=0, off=4293, siz=4, lab1=.L1616, lab2=, loff=0
!   reloc[477]: knd=0, off=4301, siz=4, lab1=.L1618, lab2=, loff=0
!   reloc[478]: knd=0, off=4309, siz=4, lab1=.L1619, lab2=, loff=0
!   reloc[479]: knd=0, off=4317, siz=4, lab1=.L1620, lab2=, loff=0
!   reloc[480]: knd=0, off=4325, siz=4, lab1=.L1621, lab2=, loff=0
!   reloc[481]: knd=0, off=4333, siz=4, lab1=.L1622, lab2=, loff=0
!   reloc[482]: knd=0, off=4341, siz=4, lab1=.L1623, lab2=, loff=0
!   reloc[483]: knd=0, off=4349, siz=4, lab1=.L1626, lab2=, loff=0
!   reloc[484]: knd=0, off=4357, siz=4, lab1=.L1631, lab2=, loff=0
!   reloc[485]: knd=0, off=4365, siz=4, lab1=.L1635, lab2=, loff=0
!   reloc[486]: knd=0, off=4373, siz=4, lab1=.L1636, lab2=, loff=0
!   reloc[487]: knd=0, off=4381, siz=4, lab1=.L1637, lab2=, loff=0
!   reloc[488]: knd=0, off=4389, siz=4, lab1=.L1639, lab2=, loff=0
!   reloc[489]: knd=0, off=4397, siz=4, lab1=.L1640, lab2=, loff=0
!   reloc[490]: knd=0, off=4405, siz=4, lab1=.L1641, lab2=, loff=0
!   reloc[491]: knd=0, off=4413, siz=4, lab1=.L1642, lab2=, loff=0
!   reloc[492]: knd=0, off=4421, siz=4, lab1=.L1643, lab2=, loff=0
!   reloc[493]: knd=0, off=4429, siz=4, lab1=.L1644, lab2=, loff=0
!   reloc[494]: knd=0, off=4437, siz=4, lab1=.L1647, lab2=, loff=0
!   reloc[495]: knd=0, off=4445, siz=4, lab1=.L1652, lab2=, loff=0
!   reloc[496]: knd=0, off=4453, siz=4, lab1=.L1656, lab2=, loff=0
!   reloc[497]: knd=0, off=4461, siz=4, lab1=.L1657, lab2=, loff=0
!   reloc[498]: knd=0, off=4469, siz=4, lab1=.L1658, lab2=, loff=0
!   reloc[499]: knd=0, off=4477, siz=4, lab1=.L1660, lab2=, loff=0
!   reloc[500]: knd=0, off=4485, siz=4, lab1=.L1661, lab2=, loff=0
!   reloc[501]: knd=0, off=4493, siz=4, lab1=.L1662, lab2=, loff=0
!   reloc[502]: knd=0, off=4501, siz=4, lab1=.L1663, lab2=, loff=0
!   reloc[503]: knd=0, off=4509, siz=4, lab1=.L1664, lab2=, loff=0
!   reloc[504]: knd=0, off=4517, siz=4, lab1=.L1665, lab2=, loff=0
!   reloc[505]: knd=0, off=4525, siz=4, lab1=.L1668, lab2=, loff=0
!   reloc[506]: knd=0, off=4533, siz=4, lab1=.L1673, lab2=, loff=0
!   reloc[507]: knd=0, off=4541, siz=4, lab1=.L1677, lab2=, loff=0
!   reloc[508]: knd=0, off=4549, siz=4, lab1=.L1678, lab2=, loff=0
!   reloc[509]: knd=0, off=4557, siz=4, lab1=.L1679, lab2=, loff=0
!   reloc[510]: knd=0, off=4565, siz=4, lab1=.L1681, lab2=, loff=0
!   reloc[511]: knd=0, off=4573, siz=4, lab1=.L1682, lab2=, loff=0
!   reloc[512]: knd=0, off=4581, siz=4, lab1=.L1683, lab2=, loff=0
!   reloc[513]: knd=0, off=4589, siz=4, lab1=.L1684, lab2=, loff=0
!   reloc[514]: knd=0, off=4597, siz=4, lab1=.L1685, lab2=, loff=0
!   reloc[515]: knd=0, off=4605, siz=4, lab1=.L1686, lab2=, loff=0
!   reloc[516]: knd=0, off=4613, siz=4, lab1=.L1689, lab2=, loff=0
!   reloc[517]: knd=0, off=4621, siz=4, lab1=.L1694, lab2=, loff=0
!   reloc[518]: knd=0, off=4629, siz=4, lab1=.L1698, lab2=, loff=0
!   reloc[519]: knd=0, off=4637, siz=4, lab1=.L1699, lab2=, loff=0
!   reloc[520]: knd=0, off=4645, siz=4, lab1=.L1700, lab2=, loff=0
!   reloc[521]: knd=0, off=4653, siz=4, lab1=.L1702, lab2=, loff=0
!   reloc[522]: knd=0, off=4661, siz=4, lab1=.L1703, lab2=, loff=0
!   reloc[523]: knd=0, off=4669, siz=4, lab1=.L1704, lab2=, loff=0
!   reloc[524]: knd=0, off=4677, siz=4, lab1=.L1705, lab2=, loff=0
!   reloc[525]: knd=0, off=4685, siz=4, lab1=.L1706, lab2=, loff=0
!   reloc[526]: knd=0, off=4693, siz=4, lab1=.L1707, lab2=, loff=0
!   reloc[527]: knd=0, off=4701, siz=4, lab1=.L1710, lab2=, loff=0
!   reloc[528]: knd=0, off=4709, siz=4, lab1=.L1715, lab2=, loff=0
!   reloc[529]: knd=0, off=4717, siz=4, lab1=.L1719, lab2=, loff=0
!   reloc[530]: knd=0, off=4725, siz=4, lab1=.L1720, lab2=, loff=0
!   reloc[531]: knd=0, off=4733, siz=4, lab1=.L1721, lab2=, loff=0
!   reloc[532]: knd=0, off=4741, siz=4, lab1=.L1723, lab2=, loff=0
!   reloc[533]: knd=0, off=4749, siz=4, lab1=.L1724, lab2=, loff=0
!   reloc[534]: knd=0, off=4757, siz=4, lab1=.L1725, lab2=, loff=0
!   reloc[535]: knd=0, off=4765, siz=4, lab1=.L1726, lab2=, loff=0
!   reloc[536]: knd=0, off=4773, siz=4, lab1=.L1727, lab2=, loff=0
!   reloc[537]: knd=0, off=4781, siz=4, lab1=.L1728, lab2=, loff=0
!   reloc[538]: knd=0, off=4789, siz=4, lab1=.L1731, lab2=, loff=0
!   reloc[539]: knd=0, off=4797, siz=4, lab1=.L1736, lab2=, loff=0
!   reloc[540]: knd=0, off=4805, siz=4, lab1=.L1740, lab2=, loff=0
!   reloc[541]: knd=0, off=4813, siz=4, lab1=.L1741, lab2=, loff=0
!   reloc[542]: knd=0, off=4821, siz=4, lab1=.L1742, lab2=, loff=0
!   reloc[543]: knd=0, off=4829, siz=4, lab1=.L1744, lab2=, loff=0
!   reloc[544]: knd=0, off=4837, siz=4, lab1=.L1745, lab2=, loff=0
!   reloc[545]: knd=0, off=4845, siz=4, lab1=.L1746, lab2=, loff=0
!   reloc[546]: knd=0, off=4853, siz=4, lab1=.L1747, lab2=, loff=0
!   reloc[547]: knd=0, off=4861, siz=4, lab1=.L1748, lab2=, loff=0
!   reloc[548]: knd=0, off=4869, siz=4, lab1=.L1749, lab2=, loff=0
!   reloc[549]: knd=0, off=4877, siz=4, lab1=.L1752, lab2=, loff=0
!   reloc[550]: knd=0, off=4885, siz=4, lab1=.L1757, lab2=, loff=0
!   reloc[551]: knd=0, off=4893, siz=4, lab1=.L1761, lab2=, loff=0
!   reloc[552]: knd=0, off=4901, siz=4, lab1=.L1762, lab2=, loff=0
!   reloc[553]: knd=0, off=4909, siz=4, lab1=.L1763, lab2=, loff=0
!   reloc[554]: knd=0, off=4917, siz=4, lab1=.L1765, lab2=, loff=0
!   reloc[555]: knd=0, off=4925, siz=4, lab1=.L1769, lab2=, loff=0
!   reloc[556]: knd=0, off=4936, siz=4, lab1=.L1772, lab2=, loff=0
!   reloc[557]: knd=0, off=4952, siz=4, lab1=gl_GetMapdv, lab2=, loff=0
!   reloc[558]: knd=0, off=4959, siz=4, lab1=.L1782, lab2=, loff=0
!   reloc[559]: knd=0, off=4971, siz=4, lab1=.L1789, lab2=, loff=0
!   reloc[560]: knd=0, off=4979, siz=4, lab1=.L1793, lab2=, loff=0
!   reloc[561]: knd=0, off=4987, siz=4, lab1=.L1794, lab2=, loff=0
!   reloc[562]: knd=0, off=4995, siz=4, lab1=.L1795, lab2=, loff=0
!   reloc[563]: knd=0, off=5003, siz=4, lab1=.L1797, lab2=, loff=0
!   reloc[564]: knd=0, off=5011, siz=4, lab1=.L1798, lab2=, loff=0
!   reloc[565]: knd=0, off=5019, siz=4, lab1=.L1799, lab2=, loff=0
!   reloc[566]: knd=0, off=5027, siz=4, lab1=.L1801, lab2=, loff=0
!   reloc[567]: knd=0, off=5035, siz=4, lab1=.L1802, lab2=, loff=0
!   reloc[568]: knd=0, off=5043, siz=4, lab1=.L1803, lab2=, loff=0
!   reloc[569]: knd=0, off=5051, siz=4, lab1=.L1805, lab2=, loff=0
!   reloc[570]: knd=0, off=5059, siz=4, lab1=.L1806, lab2=, loff=0
!   reloc[571]: knd=0, off=5067, siz=4, lab1=.L1807, lab2=, loff=0
!   reloc[572]: knd=0, off=5075, siz=4, lab1=.L1809, lab2=, loff=0
!   reloc[573]: knd=0, off=5083, siz=4, lab1=.L1810, lab2=, loff=0
!   reloc[574]: knd=0, off=5091, siz=4, lab1=.L1811, lab2=, loff=0
!   reloc[575]: knd=0, off=5099, siz=4, lab1=.L1813, lab2=, loff=0
!   reloc[576]: knd=0, off=5107, siz=4, lab1=.L1814, lab2=, loff=0
!   reloc[577]: knd=0, off=5115, siz=4, lab1=.L1815, lab2=, loff=0
!   reloc[578]: knd=0, off=5123, siz=4, lab1=.L1817, lab2=, loff=0
!   reloc[579]: knd=0, off=5131, siz=4, lab1=.L1818, lab2=, loff=0
!   reloc[580]: knd=0, off=5139, siz=4, lab1=.L1819, lab2=, loff=0
!   reloc[581]: knd=0, off=5147, siz=4, lab1=.L1821, lab2=, loff=0
!   reloc[582]: knd=0, off=5155, siz=4, lab1=.L1822, lab2=, loff=0
!   reloc[583]: knd=0, off=5163, siz=4, lab1=.L1823, lab2=, loff=0
!   reloc[584]: knd=0, off=5171, siz=4, lab1=.L1825, lab2=, loff=0
!   reloc[585]: knd=0, off=5179, siz=4, lab1=.L1826, lab2=, loff=0
!   reloc[586]: knd=0, off=5187, siz=4, lab1=.L1827, lab2=, loff=0
!   reloc[587]: knd=0, off=5195, siz=4, lab1=.L1829, lab2=, loff=0
!   reloc[588]: knd=0, off=5203, siz=4, lab1=.L1830, lab2=, loff=0
!   reloc[589]: knd=0, off=5211, siz=4, lab1=.L1831, lab2=, loff=0
!   reloc[590]: knd=0, off=5219, siz=4, lab1=.L1833, lab2=, loff=0
!   reloc[591]: knd=0, off=5227, siz=4, lab1=.L1834, lab2=, loff=0
!   reloc[592]: knd=0, off=5235, siz=4, lab1=.L1835, lab2=, loff=0
!   reloc[593]: knd=0, off=5243, siz=4, lab1=.L1837, lab2=, loff=0
!   reloc[594]: knd=0, off=5251, siz=4, lab1=.L1838, lab2=, loff=0
!   reloc[595]: knd=0, off=5259, siz=4, lab1=.L1839, lab2=, loff=0
!   reloc[596]: knd=0, off=5267, siz=4, lab1=.L1841, lab2=, loff=0
!   reloc[597]: knd=0, off=5275, siz=4, lab1=.L1842, lab2=, loff=0
!   reloc[598]: knd=0, off=5283, siz=4, lab1=.L1843, lab2=, loff=0
!   reloc[599]: knd=0, off=5291, siz=4, lab1=.L1845, lab2=, loff=0
!   reloc[600]: knd=0, off=5299, siz=4, lab1=.L1846, lab2=, loff=0
!   reloc[601]: knd=0, off=5307, siz=4, lab1=.L1847, lab2=, loff=0
!   reloc[602]: knd=0, off=5315, siz=4, lab1=.L1849, lab2=, loff=0
!   reloc[603]: knd=0, off=5323, siz=4, lab1=.L1850, lab2=, loff=0
!   reloc[604]: knd=0, off=5331, siz=4, lab1=.L1851, lab2=, loff=0
!   reloc[605]: knd=0, off=5339, siz=4, lab1=.L1853, lab2=, loff=0
!   reloc[606]: knd=0, off=5347, siz=4, lab1=.L1854, lab2=, loff=0
!   reloc[607]: knd=0, off=5355, siz=4, lab1=.L1855, lab2=, loff=0
!   reloc[608]: knd=0, off=5363, siz=4, lab1=.L1857, lab2=, loff=0
!   reloc[609]: knd=0, off=5371, siz=4, lab1=.L1858, lab2=, loff=0
!   reloc[610]: knd=0, off=5379, siz=4, lab1=.L1859, lab2=, loff=0
!   reloc[611]: knd=0, off=5387, siz=4, lab1=.L1861, lab2=, loff=0
!   reloc[612]: knd=0, off=5395, siz=4, lab1=.L1862, lab2=, loff=0
!   reloc[613]: knd=0, off=5403, siz=4, lab1=.L1863, lab2=, loff=0
!   reloc[614]: knd=0, off=5411, siz=4, lab1=.L1865, lab2=, loff=0
!   reloc[615]: knd=0, off=5419, siz=4, lab1=.L1869, lab2=, loff=0
!   reloc[616]: knd=0, off=5430, siz=4, lab1=.L1874, lab2=, loff=0
!   reloc[617]: knd=0, off=5441, siz=4, lab1=.L1879, lab2=, loff=0
!   reloc[618]: knd=0, off=5449, siz=4, lab1=.L1886, lab2=, loff=0
!   reloc[619]: knd=0, off=5457, siz=4, lab1=.L1889, lab2=, loff=0
!   reloc[620]: knd=0, off=5465, siz=4, lab1=.L1895, lab2=, loff=0
!   reloc[621]: knd=0, off=5475, siz=4, lab1=.L1900, lab2=, loff=0
!   reloc[622]: knd=0, off=5483, siz=4, lab1=.L1904, lab2=, loff=0
!   reloc[623]: knd=0, off=5491, siz=4, lab1=.L1905, lab2=, loff=0
!   reloc[624]: knd=0, off=5499, siz=4, lab1=.L1907, lab2=, loff=0
!   reloc[625]: knd=0, off=5507, siz=4, lab1=.L1908, lab2=, loff=0
!   reloc[626]: knd=0, off=5515, siz=4, lab1=.L1910, lab2=, loff=0
!   reloc[627]: knd=0, off=5523, siz=4, lab1=.L1911, lab2=, loff=0
!   reloc[628]: knd=0, off=5531, siz=4, lab1=.L1913, lab2=, loff=0
!   reloc[629]: knd=0, off=5539, siz=4, lab1=.L1914, lab2=, loff=0
!   reloc[630]: knd=0, off=5547, siz=4, lab1=.L1916, lab2=, loff=0
!   reloc[631]: knd=0, off=5555, siz=4, lab1=.L1917, lab2=, loff=0
!   reloc[632]: knd=0, off=5563, siz=4, lab1=.L1919, lab2=, loff=0
!   reloc[633]: knd=0, off=5571, siz=4, lab1=.L1920, lab2=, loff=0
!   reloc[634]: knd=0, off=5579, siz=4, lab1=.L1922, lab2=, loff=0
!   reloc[635]: knd=0, off=5587, siz=4, lab1=.L1923, lab2=, loff=0
!   reloc[636]: knd=0, off=5595, siz=4, lab1=.L1925, lab2=, loff=0
!   reloc[637]: knd=0, off=5603, siz=4, lab1=.L1926, lab2=, loff=0
!   reloc[638]: knd=0, off=5611, siz=4, lab1=.L1928, lab2=, loff=0
!   reloc[639]: knd=0, off=5619, siz=4, lab1=.L1929, lab2=, loff=0
!   reloc[640]: knd=0, off=5627, siz=4, lab1=.L1931, lab2=, loff=0
!   reloc[641]: knd=0, off=5635, siz=4, lab1=.L1932, lab2=, loff=0
!   reloc[642]: knd=0, off=5643, siz=4, lab1=.L1933, lab2=, loff=0
!   reloc[643]: knd=0, off=5651, siz=4, lab1=.L1935, lab2=, loff=0
!   reloc[644]: knd=0, off=5659, siz=4, lab1=.L1936, lab2=, loff=0
!   reloc[645]: knd=0, off=5667, siz=4, lab1=.L1937, lab2=, loff=0
!   reloc[646]: knd=0, off=5675, siz=4, lab1=.L1939, lab2=, loff=0
!   reloc[647]: knd=0, off=5683, siz=4, lab1=.L1940, lab2=, loff=0
!   reloc[648]: knd=0, off=5691, siz=4, lab1=.L1941, lab2=, loff=0
!   reloc[649]: knd=0, off=5699, siz=4, lab1=.L1943, lab2=, loff=0
!   reloc[650]: knd=0, off=5707, siz=4, lab1=.L1944, lab2=, loff=0
!   reloc[651]: knd=0, off=5715, siz=4, lab1=.L1945, lab2=, loff=0
!   reloc[652]: knd=0, off=5723, siz=4, lab1=.L1947, lab2=, loff=0
!   reloc[653]: knd=0, off=5731, siz=4, lab1=.L1948, lab2=, loff=0
!   reloc[654]: knd=0, off=5739, siz=4, lab1=.L1949, lab2=, loff=0
!   reloc[655]: knd=0, off=5747, siz=4, lab1=.L1951, lab2=, loff=0
!   reloc[656]: knd=0, off=5755, siz=4, lab1=.L1952, lab2=, loff=0
!   reloc[657]: knd=0, off=5763, siz=4, lab1=.L1953, lab2=, loff=0
!   reloc[658]: knd=0, off=5771, siz=4, lab1=.L1955, lab2=, loff=0
!   reloc[659]: knd=0, off=5779, siz=4, lab1=.L1956, lab2=, loff=0
!   reloc[660]: knd=0, off=5787, siz=4, lab1=.L1957, lab2=, loff=0
!   reloc[661]: knd=0, off=5795, siz=4, lab1=.L1959, lab2=, loff=0
!   reloc[662]: knd=0, off=5803, siz=4, lab1=.L1960, lab2=, loff=0
!   reloc[663]: knd=0, off=5811, siz=4, lab1=.L1961, lab2=, loff=0
!   reloc[664]: knd=0, off=5819, siz=4, lab1=.L1963, lab2=, loff=0
!   reloc[665]: knd=0, off=5827, siz=4, lab1=.L1964, lab2=, loff=0
!   reloc[666]: knd=0, off=5835, siz=4, lab1=.L1965, lab2=, loff=0
!   reloc[667]: knd=0, off=5843, siz=4, lab1=.L1967, lab2=, loff=0
!   reloc[668]: knd=0, off=5851, siz=4, lab1=.L1971, lab2=, loff=0
!   reloc[669]: knd=0, off=5862, siz=4, lab1=.L1974, lab2=, loff=0
!   reloc[670]: knd=0, off=5873, siz=4, lab1=.L1979, lab2=, loff=0
!   reloc[671]: knd=0, off=5881, siz=4, lab1=.L1983, lab2=, loff=0
!   reloc[672]: knd=0, off=5889, siz=4, lab1=.L1984, lab2=, loff=0
!   reloc[673]: knd=0, off=5897, siz=4, lab1=.L1985, lab2=, loff=0
!   reloc[674]: knd=0, off=5905, siz=4, lab1=.L1987, lab2=, loff=0
!   reloc[675]: knd=0, off=5913, siz=4, lab1=.L1988, lab2=, loff=0
!   reloc[676]: knd=0, off=5921, siz=4, lab1=.L1989, lab2=, loff=0
!   reloc[677]: knd=0, off=5929, siz=4, lab1=.L1991, lab2=, loff=0
!   reloc[678]: knd=0, off=5937, siz=4, lab1=.L1992, lab2=, loff=0
!   reloc[679]: knd=0, off=5945, siz=4, lab1=.L1993, lab2=, loff=0
!   reloc[680]: knd=0, off=5953, siz=4, lab1=.L1995, lab2=, loff=0
!   reloc[681]: knd=0, off=5961, siz=4, lab1=.L1996, lab2=, loff=0
!   reloc[682]: knd=0, off=5969, siz=4, lab1=.L1997, lab2=, loff=0
!   reloc[683]: knd=0, off=5977, siz=4, lab1=.L1999, lab2=, loff=0
!   reloc[684]: knd=0, off=5985, siz=4, lab1=.L2000, lab2=, loff=0
!   reloc[685]: knd=0, off=5993, siz=4, lab1=.L2001, lab2=, loff=0
!   reloc[686]: knd=0, off=6001, siz=4, lab1=.L2003, lab2=, loff=0
!   reloc[687]: knd=0, off=6009, siz=4, lab1=.L2004, lab2=, loff=0
!   reloc[688]: knd=0, off=6017, siz=4, lab1=.L2005, lab2=, loff=0
!   reloc[689]: knd=0, off=6025, siz=4, lab1=.L2007, lab2=, loff=0
!   reloc[690]: knd=0, off=6033, siz=4, lab1=.L2008, lab2=, loff=0
!   reloc[691]: knd=0, off=6041, siz=4, lab1=.L2009, lab2=, loff=0
!   reloc[692]: knd=0, off=6049, siz=4, lab1=.L2011, lab2=, loff=0
!   reloc[693]: knd=0, off=6057, siz=4, lab1=.L2012, lab2=, loff=0
!   reloc[694]: knd=0, off=6065, siz=4, lab1=.L2013, lab2=, loff=0
!   reloc[695]: knd=0, off=6073, siz=4, lab1=.L2015, lab2=, loff=0
!   reloc[696]: knd=0, off=6081, siz=4, lab1=.L2016, lab2=, loff=0
!   reloc[697]: knd=0, off=6089, siz=4, lab1=.L2017, lab2=, loff=0
!   reloc[698]: knd=0, off=6097, siz=4, lab1=.L2019, lab2=, loff=0
!   reloc[699]: knd=0, off=6105, siz=4, lab1=.L2020, lab2=, loff=0
!   reloc[700]: knd=0, off=6113, siz=4, lab1=.L2021, lab2=, loff=0
!   reloc[701]: knd=0, off=6121, siz=4, lab1=.L2022, lab2=, loff=0
!   reloc[702]: knd=0, off=6129, siz=4, lab1=.L2023, lab2=, loff=0
!   reloc[703]: knd=0, off=6137, siz=4, lab1=.L2025, lab2=, loff=0
!   reloc[704]: knd=0, off=6145, siz=4, lab1=.L2026, lab2=, loff=0
!   reloc[705]: knd=0, off=6153, siz=4, lab1=.L2027, lab2=, loff=0
!   reloc[706]: knd=0, off=6161, siz=4, lab1=.L2028, lab2=, loff=0
!   reloc[707]: knd=0, off=6169, siz=4, lab1=.L2029, lab2=, loff=0
!   reloc[708]: knd=0, off=6177, siz=4, lab1=.L2031, lab2=, loff=0
!   reloc[709]: knd=0, off=6185, siz=4, lab1=.L2032, lab2=, loff=0
!   reloc[710]: knd=0, off=6193, siz=4, lab1=.L2033, lab2=, loff=0
!   reloc[711]: knd=0, off=6201, siz=4, lab1=.L2034, lab2=, loff=0
!   reloc[712]: knd=0, off=6209, siz=4, lab1=.L2035, lab2=, loff=0
!   reloc[713]: knd=0, off=6217, siz=4, lab1=.L2037, lab2=, loff=0
!   reloc[714]: knd=0, off=6225, siz=4, lab1=.L2038, lab2=, loff=0
!   reloc[715]: knd=0, off=6233, siz=4, lab1=.L2039, lab2=, loff=0
!   reloc[716]: knd=0, off=6241, siz=4, lab1=.L2040, lab2=, loff=0
!   reloc[717]: knd=0, off=6249, siz=4, lab1=.L2041, lab2=, loff=0
!   reloc[718]: knd=0, off=6257, siz=4, lab1=.L2043, lab2=, loff=0
!   reloc[719]: knd=0, off=6265, siz=4, lab1=.L2044, lab2=, loff=0
!   reloc[720]: knd=0, off=6273, siz=4, lab1=.L2045, lab2=, loff=0
!   reloc[721]: knd=0, off=6281, siz=4, lab1=.L2046, lab2=, loff=0
!   reloc[722]: knd=0, off=6289, siz=4, lab1=.L2047, lab2=, loff=0
!   reloc[723]: knd=0, off=6297, siz=4, lab1=.L2049, lab2=, loff=0
!   reloc[724]: knd=0, off=6305, siz=4, lab1=.L2050, lab2=, loff=0
!   reloc[725]: knd=0, off=6313, siz=4, lab1=.L2051, lab2=, loff=0
!   reloc[726]: knd=0, off=6321, siz=4, lab1=.L2052, lab2=, loff=0
!   reloc[727]: knd=0, off=6329, siz=4, lab1=.L2053, lab2=, loff=0
!   reloc[728]: knd=0, off=6337, siz=4, lab1=.L2055, lab2=, loff=0
!   reloc[729]: knd=0, off=6345, siz=4, lab1=.L2056, lab2=, loff=0
!   reloc[730]: knd=0, off=6353, siz=4, lab1=.L2057, lab2=, loff=0
!   reloc[731]: knd=0, off=6361, siz=4, lab1=.L2058, lab2=, loff=0
!   reloc[732]: knd=0, off=6369, siz=4, lab1=.L2059, lab2=, loff=0
!   reloc[733]: knd=0, off=6377, siz=4, lab1=.L2061, lab2=, loff=0
!   reloc[734]: knd=0, off=6385, siz=4, lab1=.L2062, lab2=, loff=0
!   reloc[735]: knd=0, off=6393, siz=4, lab1=.L2063, lab2=, loff=0
!   reloc[736]: knd=0, off=6401, siz=4, lab1=.L2064, lab2=, loff=0
!   reloc[737]: knd=0, off=6409, siz=4, lab1=.L2065, lab2=, loff=0
!   reloc[738]: knd=0, off=6417, siz=4, lab1=.L2067, lab2=, loff=0
!   reloc[739]: knd=0, off=6425, siz=4, lab1=.L2068, lab2=, loff=0
!   reloc[740]: knd=0, off=6433, siz=4, lab1=.L2069, lab2=, loff=0
!   reloc[741]: knd=0, off=6441, siz=4, lab1=.L2070, lab2=, loff=0
!   reloc[742]: knd=0, off=6449, siz=4, lab1=.L2071, lab2=, loff=0
!   reloc[743]: knd=0, off=6457, siz=4, lab1=.L2073, lab2=, loff=0
!   reloc[744]: knd=0, off=6465, siz=4, lab1=.L2077, lab2=, loff=0
!   reloc[745]: knd=0, off=6476, siz=4, lab1=.L2080, lab2=, loff=0
!   reloc[746]: knd=0, off=6487, siz=4, lab1=.L2082, lab2=, loff=0
!   reloc[747]: knd=0, off=6495, siz=4, lab1=.L2086, lab2=, loff=0
!   reloc[748]: knd=0, off=6506, siz=4, lab1=.L2089, lab2=, loff=0
!   reloc[749]: knd=0, off=6522, siz=4, lab1=gl_GetMapfv, lab2=, loff=0
!   reloc[750]: knd=0, off=6529, siz=4, lab1=.L2099, lab2=, loff=0
!   reloc[751]: knd=0, off=6541, siz=4, lab1=.L2106, lab2=, loff=0
!   reloc[752]: knd=0, off=6549, siz=4, lab1=.L2110, lab2=, loff=0
!   reloc[753]: knd=0, off=6557, siz=4, lab1=.L2111, lab2=, loff=0
!   reloc[754]: knd=0, off=6565, siz=4, lab1=.L2112, lab2=, loff=0
!   reloc[755]: knd=0, off=6573, siz=4, lab1=.L2114, lab2=, loff=0
!   reloc[756]: knd=0, off=6581, siz=4, lab1=.L2115, lab2=, loff=0
!   reloc[757]: knd=0, off=6589, siz=4, lab1=.L2116, lab2=, loff=0
!   reloc[758]: knd=0, off=6597, siz=4, lab1=.L2118, lab2=, loff=0
!   reloc[759]: knd=0, off=6605, siz=4, lab1=.L2119, lab2=, loff=0
!   reloc[760]: knd=0, off=6613, siz=4, lab1=.L2120, lab2=, loff=0
!   reloc[761]: knd=0, off=6621, siz=4, lab1=.L2122, lab2=, loff=0
!   reloc[762]: knd=0, off=6629, siz=4, lab1=.L2123, lab2=, loff=0
!   reloc[763]: knd=0, off=6637, siz=4, lab1=.L2124, lab2=, loff=0
!   reloc[764]: knd=0, off=6645, siz=4, lab1=.L2126, lab2=, loff=0
!   reloc[765]: knd=0, off=6653, siz=4, lab1=.L2127, lab2=, loff=0
!   reloc[766]: knd=0, off=6661, siz=4, lab1=.L2128, lab2=, loff=0
!   reloc[767]: knd=0, off=6669, siz=4, lab1=.L2130, lab2=, loff=0
!   reloc[768]: knd=0, off=6677, siz=4, lab1=.L2131, lab2=, loff=0
!   reloc[769]: knd=0, off=6685, siz=4, lab1=.L2132, lab2=, loff=0
!   reloc[770]: knd=0, off=6693, siz=4, lab1=.L2134, lab2=, loff=0
!   reloc[771]: knd=0, off=6701, siz=4, lab1=.L2135, lab2=, loff=0
!   reloc[772]: knd=0, off=6709, siz=4, lab1=.L2136, lab2=, loff=0
!   reloc[773]: knd=0, off=6717, siz=4, lab1=.L2138, lab2=, loff=0
!   reloc[774]: knd=0, off=6725, siz=4, lab1=.L2139, lab2=, loff=0
!   reloc[775]: knd=0, off=6733, siz=4, lab1=.L2140, lab2=, loff=0
!   reloc[776]: knd=0, off=6741, siz=4, lab1=.L2142, lab2=, loff=0
!   reloc[777]: knd=0, off=6749, siz=4, lab1=.L2143, lab2=, loff=0
!   reloc[778]: knd=0, off=6757, siz=4, lab1=.L2144, lab2=, loff=0
!   reloc[779]: knd=0, off=6765, siz=4, lab1=.L2146, lab2=, loff=0
!   reloc[780]: knd=0, off=6773, siz=4, lab1=.L2147, lab2=, loff=0
!   reloc[781]: knd=0, off=6781, siz=4, lab1=.L2148, lab2=, loff=0
!   reloc[782]: knd=0, off=6789, siz=4, lab1=.L2150, lab2=, loff=0
!   reloc[783]: knd=0, off=6797, siz=4, lab1=.L2151, lab2=, loff=0
!   reloc[784]: knd=0, off=6805, siz=4, lab1=.L2152, lab2=, loff=0
!   reloc[785]: knd=0, off=6813, siz=4, lab1=.L2154, lab2=, loff=0
!   reloc[786]: knd=0, off=6821, siz=4, lab1=.L2155, lab2=, loff=0
!   reloc[787]: knd=0, off=6829, siz=4, lab1=.L2156, lab2=, loff=0
!   reloc[788]: knd=0, off=6837, siz=4, lab1=.L2158, lab2=, loff=0
!   reloc[789]: knd=0, off=6845, siz=4, lab1=.L2159, lab2=, loff=0
!   reloc[790]: knd=0, off=6853, siz=4, lab1=.L2160, lab2=, loff=0
!   reloc[791]: knd=0, off=6861, siz=4, lab1=.L2162, lab2=, loff=0
!   reloc[792]: knd=0, off=6869, siz=4, lab1=.L2163, lab2=, loff=0
!   reloc[793]: knd=0, off=6877, siz=4, lab1=.L2164, lab2=, loff=0
!   reloc[794]: knd=0, off=6885, siz=4, lab1=.L2166, lab2=, loff=0
!   reloc[795]: knd=0, off=6893, siz=4, lab1=.L2167, lab2=, loff=0
!   reloc[796]: knd=0, off=6901, siz=4, lab1=.L2168, lab2=, loff=0
!   reloc[797]: knd=0, off=6909, siz=4, lab1=.L2170, lab2=, loff=0
!   reloc[798]: knd=0, off=6917, siz=4, lab1=.L2171, lab2=, loff=0
!   reloc[799]: knd=0, off=6925, siz=4, lab1=.L2172, lab2=, loff=0
!   reloc[800]: knd=0, off=6933, siz=4, lab1=.L2174, lab2=, loff=0
!   reloc[801]: knd=0, off=6941, siz=4, lab1=.L2175, lab2=, loff=0
!   reloc[802]: knd=0, off=6949, siz=4, lab1=.L2176, lab2=, loff=0
!   reloc[803]: knd=0, off=6957, siz=4, lab1=.L2178, lab2=, loff=0
!   reloc[804]: knd=0, off=6965, siz=4, lab1=.L2179, lab2=, loff=0
!   reloc[805]: knd=0, off=6973, siz=4, lab1=.L2180, lab2=, loff=0
!   reloc[806]: knd=0, off=6981, siz=4, lab1=.L2182, lab2=, loff=0
!   reloc[807]: knd=0, off=6989, siz=4, lab1=.L2186, lab2=, loff=0
!   reloc[808]: knd=0, off=7000, siz=4, lab1=.L2191, lab2=, loff=0
!   reloc[809]: knd=0, off=7011, siz=4, lab1=.L2196, lab2=, loff=0
!   reloc[810]: knd=0, off=7019, siz=4, lab1=.L2203, lab2=, loff=0
!   reloc[811]: knd=0, off=7027, siz=4, lab1=.L2206, lab2=, loff=0
!   reloc[812]: knd=0, off=7035, siz=4, lab1=.L2212, lab2=, loff=0
!   reloc[813]: knd=0, off=7045, siz=4, lab1=.L2217, lab2=, loff=0
!   reloc[814]: knd=0, off=7053, siz=4, lab1=.L2221, lab2=, loff=0
!   reloc[815]: knd=0, off=7061, siz=4, lab1=.L2222, lab2=, loff=0
!   reloc[816]: knd=0, off=7069, siz=4, lab1=.L2224, lab2=, loff=0
!   reloc[817]: knd=0, off=7077, siz=4, lab1=.L2225, lab2=, loff=0
!   reloc[818]: knd=0, off=7085, siz=4, lab1=.L2227, lab2=, loff=0
!   reloc[819]: knd=0, off=7093, siz=4, lab1=.L2228, lab2=, loff=0
!   reloc[820]: knd=0, off=7101, siz=4, lab1=.L2230, lab2=, loff=0
!   reloc[821]: knd=0, off=7109, siz=4, lab1=.L2231, lab2=, loff=0
!   reloc[822]: knd=0, off=7117, siz=4, lab1=.L2233, lab2=, loff=0
!   reloc[823]: knd=0, off=7125, siz=4, lab1=.L2234, lab2=, loff=0
!   reloc[824]: knd=0, off=7133, siz=4, lab1=.L2236, lab2=, loff=0
!   reloc[825]: knd=0, off=7141, siz=4, lab1=.L2237, lab2=, loff=0
!   reloc[826]: knd=0, off=7149, siz=4, lab1=.L2239, lab2=, loff=0
!   reloc[827]: knd=0, off=7157, siz=4, lab1=.L2240, lab2=, loff=0
!   reloc[828]: knd=0, off=7165, siz=4, lab1=.L2242, lab2=, loff=0
!   reloc[829]: knd=0, off=7173, siz=4, lab1=.L2243, lab2=, loff=0
!   reloc[830]: knd=0, off=7181, siz=4, lab1=.L2245, lab2=, loff=0
!   reloc[831]: knd=0, off=7189, siz=4, lab1=.L2246, lab2=, loff=0
!   reloc[832]: knd=0, off=7197, siz=4, lab1=.L2248, lab2=, loff=0
!   reloc[833]: knd=0, off=7205, siz=4, lab1=.L2249, lab2=, loff=0
!   reloc[834]: knd=0, off=7213, siz=4, lab1=.L2250, lab2=, loff=0
!   reloc[835]: knd=0, off=7221, siz=4, lab1=.L2252, lab2=, loff=0
!   reloc[836]: knd=0, off=7229, siz=4, lab1=.L2253, lab2=, loff=0
!   reloc[837]: knd=0, off=7237, siz=4, lab1=.L2254, lab2=, loff=0
!   reloc[838]: knd=0, off=7245, siz=4, lab1=.L2256, lab2=, loff=0
!   reloc[839]: knd=0, off=7253, siz=4, lab1=.L2257, lab2=, loff=0
!   reloc[840]: knd=0, off=7261, siz=4, lab1=.L2258, lab2=, loff=0
!   reloc[841]: knd=0, off=7269, siz=4, lab1=.L2260, lab2=, loff=0
!   reloc[842]: knd=0, off=7277, siz=4, lab1=.L2261, lab2=, loff=0
!   reloc[843]: knd=0, off=7285, siz=4, lab1=.L2262, lab2=, loff=0
!   reloc[844]: knd=0, off=7293, siz=4, lab1=.L2264, lab2=, loff=0
!   reloc[845]: knd=0, off=7301, siz=4, lab1=.L2265, lab2=, loff=0
!   reloc[846]: knd=0, off=7309, siz=4, lab1=.L2266, lab2=, loff=0
!   reloc[847]: knd=0, off=7317, siz=4, lab1=.L2268, lab2=, loff=0
!   reloc[848]: knd=0, off=7325, siz=4, lab1=.L2269, lab2=, loff=0
!   reloc[849]: knd=0, off=7333, siz=4, lab1=.L2270, lab2=, loff=0
!   reloc[850]: knd=0, off=7341, siz=4, lab1=.L2272, lab2=, loff=0
!   reloc[851]: knd=0, off=7349, siz=4, lab1=.L2273, lab2=, loff=0
!   reloc[852]: knd=0, off=7357, siz=4, lab1=.L2274, lab2=, loff=0
!   reloc[853]: knd=0, off=7365, siz=4, lab1=.L2276, lab2=, loff=0
!   reloc[854]: knd=0, off=7373, siz=4, lab1=.L2277, lab2=, loff=0
!   reloc[855]: knd=0, off=7381, siz=4, lab1=.L2278, lab2=, loff=0
!   reloc[856]: knd=0, off=7389, siz=4, lab1=.L2280, lab2=, loff=0
!   reloc[857]: knd=0, off=7397, siz=4, lab1=.L2281, lab2=, loff=0
!   reloc[858]: knd=0, off=7405, siz=4, lab1=.L2282, lab2=, loff=0
!   reloc[859]: knd=0, off=7413, siz=4, lab1=.L2284, lab2=, loff=0
!   reloc[860]: knd=0, off=7421, siz=4, lab1=.L2288, lab2=, loff=0
!   reloc[861]: knd=0, off=7432, siz=4, lab1=.L2291, lab2=, loff=0
!   reloc[862]: knd=0, off=7443, siz=4, lab1=.L2296, lab2=, loff=0
!   reloc[863]: knd=0, off=7451, siz=4, lab1=.L2300, lab2=, loff=0
!   reloc[864]: knd=0, off=7459, siz=4, lab1=.L2301, lab2=, loff=0
!   reloc[865]: knd=0, off=7467, siz=4, lab1=.L2302, lab2=, loff=0
!   reloc[866]: knd=0, off=7475, siz=4, lab1=.L2304, lab2=, loff=0
!   reloc[867]: knd=0, off=7483, siz=4, lab1=.L2305, lab2=, loff=0
!   reloc[868]: knd=0, off=7491, siz=4, lab1=.L2306, lab2=, loff=0
!   reloc[869]: knd=0, off=7499, siz=4, lab1=.L2308, lab2=, loff=0
!   reloc[870]: knd=0, off=7507, siz=4, lab1=.L2309, lab2=, loff=0
!   reloc[871]: knd=0, off=7515, siz=4, lab1=.L2310, lab2=, loff=0
!   reloc[872]: knd=0, off=7523, siz=4, lab1=.L2312, lab2=, loff=0
!   reloc[873]: knd=0, off=7531, siz=4, lab1=.L2313, lab2=, loff=0
!   reloc[874]: knd=0, off=7539, siz=4, lab1=.L2314, lab2=, loff=0
!   reloc[875]: knd=0, off=7547, siz=4, lab1=.L2316, lab2=, loff=0
!   reloc[876]: knd=0, off=7555, siz=4, lab1=.L2317, lab2=, loff=0
!   reloc[877]: knd=0, off=7563, siz=4, lab1=.L2318, lab2=, loff=0
!   reloc[878]: knd=0, off=7571, siz=4, lab1=.L2320, lab2=, loff=0
!   reloc[879]: knd=0, off=7579, siz=4, lab1=.L2321, lab2=, loff=0
!   reloc[880]: knd=0, off=7587, siz=4, lab1=.L2322, lab2=, loff=0
!   reloc[881]: knd=0, off=7595, siz=4, lab1=.L2324, lab2=, loff=0
!   reloc[882]: knd=0, off=7603, siz=4, lab1=.L2325, lab2=, loff=0
!   reloc[883]: knd=0, off=7611, siz=4, lab1=.L2326, lab2=, loff=0
!   reloc[884]: knd=0, off=7619, siz=4, lab1=.L2328, lab2=, loff=0
!   reloc[885]: knd=0, off=7627, siz=4, lab1=.L2329, lab2=, loff=0
!   reloc[886]: knd=0, off=7635, siz=4, lab1=.L2330, lab2=, loff=0
!   reloc[887]: knd=0, off=7643, siz=4, lab1=.L2332, lab2=, loff=0
!   reloc[888]: knd=0, off=7651, siz=4, lab1=.L2333, lab2=, loff=0
!   reloc[889]: knd=0, off=7659, siz=4, lab1=.L2334, lab2=, loff=0
!   reloc[890]: knd=0, off=7667, siz=4, lab1=.L2336, lab2=, loff=0
!   reloc[891]: knd=0, off=7675, siz=4, lab1=.L2337, lab2=, loff=0
!   reloc[892]: knd=0, off=7683, siz=4, lab1=.L2338, lab2=, loff=0
!   reloc[893]: knd=0, off=7691, siz=4, lab1=.L2339, lab2=, loff=0
!   reloc[894]: knd=0, off=7699, siz=4, lab1=.L2340, lab2=, loff=0
!   reloc[895]: knd=0, off=7707, siz=4, lab1=.L2342, lab2=, loff=0
!   reloc[896]: knd=0, off=7715, siz=4, lab1=.L2343, lab2=, loff=0
!   reloc[897]: knd=0, off=7723, siz=4, lab1=.L2344, lab2=, loff=0
!   reloc[898]: knd=0, off=7731, siz=4, lab1=.L2345, lab2=, loff=0
!   reloc[899]: knd=0, off=7739, siz=4, lab1=.L2346, lab2=, loff=0
!   reloc[900]: knd=0, off=7747, siz=4, lab1=.L2348, lab2=, loff=0
!   reloc[901]: knd=0, off=7755, siz=4, lab1=.L2349, lab2=, loff=0
!   reloc[902]: knd=0, off=7763, siz=4, lab1=.L2350, lab2=, loff=0
!   reloc[903]: knd=0, off=7771, siz=4, lab1=.L2351, lab2=, loff=0
!   reloc[904]: knd=0, off=7779, siz=4, lab1=.L2352, lab2=, loff=0
!   reloc[905]: knd=0, off=7787, siz=4, lab1=.L2354, lab2=, loff=0
!   reloc[906]: knd=0, off=7795, siz=4, lab1=.L2355, lab2=, loff=0
!   reloc[907]: knd=0, off=7803, siz=4, lab1=.L2356, lab2=, loff=0
!   reloc[908]: knd=0, off=7811, siz=4, lab1=.L2357, lab2=, loff=0
!   reloc[909]: knd=0, off=7819, siz=4, lab1=.L2358, lab2=, loff=0
!   reloc[910]: knd=0, off=7827, siz=4, lab1=.L2360, lab2=, loff=0
!   reloc[911]: knd=0, off=7835, siz=4, lab1=.L2361, lab2=, loff=0
!   reloc[912]: knd=0, off=7843, siz=4, lab1=.L2362, lab2=, loff=0
!   reloc[913]: knd=0, off=7851, siz=4, lab1=.L2363, lab2=, loff=0
!   reloc[914]: knd=0, off=7859, siz=4, lab1=.L2364, lab2=, loff=0
!   reloc[915]: knd=0, off=7867, siz=4, lab1=.L2366, lab2=, loff=0
!   reloc[916]: knd=0, off=7875, siz=4, lab1=.L2367, lab2=, loff=0
!   reloc[917]: knd=0, off=7883, siz=4, lab1=.L2368, lab2=, loff=0
!   reloc[918]: knd=0, off=7891, siz=4, lab1=.L2369, lab2=, loff=0
!   reloc[919]: knd=0, off=7899, siz=4, lab1=.L2370, lab2=, loff=0
!   reloc[920]: knd=0, off=7907, siz=4, lab1=.L2372, lab2=, loff=0
!   reloc[921]: knd=0, off=7915, siz=4, lab1=.L2373, lab2=, loff=0
!   reloc[922]: knd=0, off=7923, siz=4, lab1=.L2374, lab2=, loff=0
!   reloc[923]: knd=0, off=7931, siz=4, lab1=.L2375, lab2=, loff=0
!   reloc[924]: knd=0, off=7939, siz=4, lab1=.L2376, lab2=, loff=0
!   reloc[925]: knd=0, off=7947, siz=4, lab1=.L2378, lab2=, loff=0
!   reloc[926]: knd=0, off=7955, siz=4, lab1=.L2379, lab2=, loff=0
!   reloc[927]: knd=0, off=7963, siz=4, lab1=.L2380, lab2=, loff=0
!   reloc[928]: knd=0, off=7971, siz=4, lab1=.L2381, lab2=, loff=0
!   reloc[929]: knd=0, off=7979, siz=4, lab1=.L2382, lab2=, loff=0
!   reloc[930]: knd=0, off=7987, siz=4, lab1=.L2384, lab2=, loff=0
!   reloc[931]: knd=0, off=7995, siz=4, lab1=.L2385, lab2=, loff=0
!   reloc[932]: knd=0, off=8003, siz=4, lab1=.L2386, lab2=, loff=0
!   reloc[933]: knd=0, off=8011, siz=4, lab1=.L2387, lab2=, loff=0
!   reloc[934]: knd=0, off=8019, siz=4, lab1=.L2388, lab2=, loff=0
!   reloc[935]: knd=0, off=8027, siz=4, lab1=.L2390, lab2=, loff=0
!   reloc[936]: knd=0, off=8035, siz=4, lab1=.L2394, lab2=, loff=0
!   reloc[937]: knd=0, off=8046, siz=4, lab1=.L2397, lab2=, loff=0
!   reloc[938]: knd=0, off=8057, siz=4, lab1=.L2399, lab2=, loff=0
!   reloc[939]: knd=0, off=8065, siz=4, lab1=.L2403, lab2=, loff=0
!   reloc[940]: knd=0, off=8076, siz=4, lab1=.L2406, lab2=, loff=0
!   reloc[941]: knd=0, off=8092, siz=4, lab1=gl_GetMapiv, lab2=, loff=0
!   reloc[942]: knd=0, off=8099, siz=4, lab1=.L2416, lab2=, loff=0
!   reloc[943]: knd=0, off=8111, siz=4, lab1=.L2423, lab2=, loff=0
!   reloc[944]: knd=0, off=8119, siz=4, lab1=.L2427, lab2=, loff=0
!   reloc[945]: knd=0, off=8127, siz=4, lab1=.L2428, lab2=, loff=0
!   reloc[946]: knd=0, off=8135, siz=4, lab1=.L2429, lab2=, loff=0
!   reloc[947]: knd=0, off=8143, siz=4, lab1=.L2431, lab2=, loff=0
!   reloc[948]: knd=0, off=8151, siz=4, lab1=.L2432, lab2=, loff=0
!   reloc[949]: knd=0, off=8159, siz=4, lab1=.L2433, lab2=, loff=0
!   reloc[950]: knd=0, off=8167, siz=4, lab1=.L2435, lab2=, loff=0
!   reloc[951]: knd=0, off=8175, siz=4, lab1=.L2436, lab2=, loff=0
!   reloc[952]: knd=0, off=8183, siz=4, lab1=.L2437, lab2=, loff=0
!   reloc[953]: knd=0, off=8191, siz=4, lab1=.L2439, lab2=, loff=0
!   reloc[954]: knd=0, off=8199, siz=4, lab1=.L2440, lab2=, loff=0
!   reloc[955]: knd=0, off=8207, siz=4, lab1=.L2441, lab2=, loff=0
!   reloc[956]: knd=0, off=8215, siz=4, lab1=.L2443, lab2=, loff=0
!   reloc[957]: knd=0, off=8223, siz=4, lab1=.L2444, lab2=, loff=0
!   reloc[958]: knd=0, off=8231, siz=4, lab1=.L2445, lab2=, loff=0
!   reloc[959]: knd=0, off=8239, siz=4, lab1=.L2447, lab2=, loff=0
!   reloc[960]: knd=0, off=8247, siz=4, lab1=.L2448, lab2=, loff=0
!   reloc[961]: knd=0, off=8255, siz=4, lab1=.L2449, lab2=, loff=0
!   reloc[962]: knd=0, off=8263, siz=4, lab1=.L2451, lab2=, loff=0
!   reloc[963]: knd=0, off=8271, siz=4, lab1=.L2452, lab2=, loff=0
!   reloc[964]: knd=0, off=8279, siz=4, lab1=.L2453, lab2=, loff=0
!   reloc[965]: knd=0, off=8287, siz=4, lab1=.L2455, lab2=, loff=0
!   reloc[966]: knd=0, off=8295, siz=4, lab1=.L2456, lab2=, loff=0
!   reloc[967]: knd=0, off=8303, siz=4, lab1=.L2457, lab2=, loff=0
!   reloc[968]: knd=0, off=8311, siz=4, lab1=.L2459, lab2=, loff=0
!   reloc[969]: knd=0, off=8319, siz=4, lab1=.L2460, lab2=, loff=0
!   reloc[970]: knd=0, off=8327, siz=4, lab1=.L2461, lab2=, loff=0
!   reloc[971]: knd=0, off=8335, siz=4, lab1=.L2463, lab2=, loff=0
!   reloc[972]: knd=0, off=8343, siz=4, lab1=.L2464, lab2=, loff=0
!   reloc[973]: knd=0, off=8351, siz=4, lab1=.L2465, lab2=, loff=0
!   reloc[974]: knd=0, off=8359, siz=4, lab1=.L2467, lab2=, loff=0
!   reloc[975]: knd=0, off=8367, siz=4, lab1=.L2468, lab2=, loff=0
!   reloc[976]: knd=0, off=8375, siz=4, lab1=.L2469, lab2=, loff=0
!   reloc[977]: knd=0, off=8383, siz=4, lab1=.L2471, lab2=, loff=0
!   reloc[978]: knd=0, off=8391, siz=4, lab1=.L2472, lab2=, loff=0
!   reloc[979]: knd=0, off=8399, siz=4, lab1=.L2473, lab2=, loff=0
!   reloc[980]: knd=0, off=8407, siz=4, lab1=.L2475, lab2=, loff=0
!   reloc[981]: knd=0, off=8415, siz=4, lab1=.L2476, lab2=, loff=0
!   reloc[982]: knd=0, off=8423, siz=4, lab1=.L2477, lab2=, loff=0
!   reloc[983]: knd=0, off=8431, siz=4, lab1=.L2479, lab2=, loff=0
!   reloc[984]: knd=0, off=8439, siz=4, lab1=.L2480, lab2=, loff=0
!   reloc[985]: knd=0, off=8447, siz=4, lab1=.L2481, lab2=, loff=0
!   reloc[986]: knd=0, off=8455, siz=4, lab1=.L2483, lab2=, loff=0
!   reloc[987]: knd=0, off=8463, siz=4, lab1=.L2484, lab2=, loff=0
!   reloc[988]: knd=0, off=8471, siz=4, lab1=.L2485, lab2=, loff=0
!   reloc[989]: knd=0, off=8479, siz=4, lab1=.L2487, lab2=, loff=0
!   reloc[990]: knd=0, off=8487, siz=4, lab1=.L2488, lab2=, loff=0
!   reloc[991]: knd=0, off=8495, siz=4, lab1=.L2489, lab2=, loff=0
!   reloc[992]: knd=0, off=8503, siz=4, lab1=.L2491, lab2=, loff=0
!   reloc[993]: knd=0, off=8511, siz=4, lab1=.L2492, lab2=, loff=0
!   reloc[994]: knd=0, off=8519, siz=4, lab1=.L2493, lab2=, loff=0
!   reloc[995]: knd=0, off=8527, siz=4, lab1=.L2495, lab2=, loff=0
!   reloc[996]: knd=0, off=8535, siz=4, lab1=.L2496, lab2=, loff=0
!   reloc[997]: knd=0, off=8543, siz=4, lab1=.L2497, lab2=, loff=0
!   reloc[998]: knd=0, off=8551, siz=4, lab1=.L2499, lab2=, loff=0
!   reloc[999]: knd=0, off=8559, siz=4, lab1=.L2503, lab2=, loff=0
!   reloc[1000]: knd=0, off=8570, siz=4, lab1=.L2508, lab2=, loff=0
!   reloc[1001]: knd=0, off=8581, siz=4, lab1=.L2513, lab2=, loff=0
!   reloc[1002]: knd=0, off=8589, siz=4, lab1=.L2520, lab2=, loff=0
!   reloc[1003]: knd=0, off=8597, siz=4, lab1=.L2526, lab2=, loff=0
!   reloc[1004]: knd=0, off=8605, siz=4, lab1=.L2532, lab2=, loff=0
!   reloc[1005]: knd=0, off=8615, siz=4, lab1=.L2537, lab2=, loff=0
!   reloc[1006]: knd=0, off=8623, siz=4, lab1=.L2541, lab2=, loff=0
!   reloc[1007]: knd=0, off=8631, siz=4, lab1=.L2542, lab2=, loff=0
!   reloc[1008]: knd=0, off=8639, siz=4, lab1=.L2544, lab2=, loff=0
!   reloc[1009]: knd=0, off=8647, siz=4, lab1=.L2545, lab2=, loff=0
!   reloc[1010]: knd=0, off=8655, siz=4, lab1=.L2547, lab2=, loff=0
!   reloc[1011]: knd=0, off=8663, siz=4, lab1=.L2548, lab2=, loff=0
!   reloc[1012]: knd=0, off=8671, siz=4, lab1=.L2550, lab2=, loff=0
!   reloc[1013]: knd=0, off=8679, siz=4, lab1=.L2551, lab2=, loff=0
!   reloc[1014]: knd=0, off=8687, siz=4, lab1=.L2553, lab2=, loff=0
!   reloc[1015]: knd=0, off=8695, siz=4, lab1=.L2554, lab2=, loff=0
!   reloc[1016]: knd=0, off=8703, siz=4, lab1=.L2556, lab2=, loff=0
!   reloc[1017]: knd=0, off=8711, siz=4, lab1=.L2557, lab2=, loff=0
!   reloc[1018]: knd=0, off=8719, siz=4, lab1=.L2559, lab2=, loff=0
!   reloc[1019]: knd=0, off=8727, siz=4, lab1=.L2560, lab2=, loff=0
!   reloc[1020]: knd=0, off=8735, siz=4, lab1=.L2562, lab2=, loff=0
!   reloc[1021]: knd=0, off=8743, siz=4, lab1=.L2563, lab2=, loff=0
!   reloc[1022]: knd=0, off=8751, siz=4, lab1=.L2565, lab2=, loff=0
!   reloc[1023]: knd=0, off=8759, siz=4, lab1=.L2566, lab2=, loff=0
!   reloc[1024]: knd=0, off=8767, siz=4, lab1=.L2568, lab2=, loff=0
!   reloc[1025]: knd=0, off=8775, siz=4, lab1=.L2569, lab2=, loff=0
!   reloc[1026]: knd=0, off=8783, siz=4, lab1=.L2570, lab2=, loff=0
!   reloc[1027]: knd=0, off=8791, siz=4, lab1=.L2572, lab2=, loff=0
!   reloc[1028]: knd=0, off=8799, siz=4, lab1=.L2573, lab2=, loff=0
!   reloc[1029]: knd=0, off=8807, siz=4, lab1=.L2574, lab2=, loff=0
!   reloc[1030]: knd=0, off=8815, siz=4, lab1=.L2576, lab2=, loff=0
!   reloc[1031]: knd=0, off=8823, siz=4, lab1=.L2577, lab2=, loff=0
!   reloc[1032]: knd=0, off=8831, siz=4, lab1=.L2578, lab2=, loff=0
!   reloc[1033]: knd=0, off=8839, siz=4, lab1=.L2580, lab2=, loff=0
!   reloc[1034]: knd=0, off=8847, siz=4, lab1=.L2581, lab2=, loff=0
!   reloc[1035]: knd=0, off=8855, siz=4, lab1=.L2582, lab2=, loff=0
!   reloc[1036]: knd=0, off=8863, siz=4, lab1=.L2584, lab2=, loff=0
!   reloc[1037]: knd=0, off=8871, siz=4, lab1=.L2585, lab2=, loff=0
!   reloc[1038]: knd=0, off=8879, siz=4, lab1=.L2586, lab2=, loff=0
!   reloc[1039]: knd=0, off=8887, siz=4, lab1=.L2588, lab2=, loff=0
!   reloc[1040]: knd=0, off=8895, siz=4, lab1=.L2589, lab2=, loff=0
!   reloc[1041]: knd=0, off=8903, siz=4, lab1=.L2590, lab2=, loff=0
!   reloc[1042]: knd=0, off=8911, siz=4, lab1=.L2592, lab2=, loff=0
!   reloc[1043]: knd=0, off=8919, siz=4, lab1=.L2593, lab2=, loff=0
!   reloc[1044]: knd=0, off=8927, siz=4, lab1=.L2594, lab2=, loff=0
!   reloc[1045]: knd=0, off=8935, siz=4, lab1=.L2596, lab2=, loff=0
!   reloc[1046]: knd=0, off=8943, siz=4, lab1=.L2597, lab2=, loff=0
!   reloc[1047]: knd=0, off=8951, siz=4, lab1=.L2598, lab2=, loff=0
!   reloc[1048]: knd=0, off=8959, siz=4, lab1=.L2600, lab2=, loff=0
!   reloc[1049]: knd=0, off=8967, siz=4, lab1=.L2601, lab2=, loff=0
!   reloc[1050]: knd=0, off=8975, siz=4, lab1=.L2602, lab2=, loff=0
!   reloc[1051]: knd=0, off=8983, siz=4, lab1=.L2604, lab2=, loff=0
!   reloc[1052]: knd=0, off=8991, siz=4, lab1=.L2608, lab2=, loff=0
!   reloc[1053]: knd=0, off=9002, siz=4, lab1=.L2611, lab2=, loff=0
!   reloc[1054]: knd=0, off=9013, siz=4, lab1=.L2616, lab2=, loff=0
!   reloc[1055]: knd=0, off=9021, siz=4, lab1=.L2620, lab2=, loff=0
!   reloc[1056]: knd=0, off=9029, siz=4, lab1=.L2624, lab2=, loff=0
!   reloc[1057]: knd=0, off=9037, siz=4, lab1=.L2628, lab2=, loff=0
!   reloc[1058]: knd=0, off=9045, siz=4, lab1=.L2630, lab2=, loff=0
!   reloc[1059]: knd=0, off=9053, siz=4, lab1=.L2634, lab2=, loff=0
!   reloc[1060]: knd=0, off=9061, siz=4, lab1=.L2638, lab2=, loff=0
!   reloc[1061]: knd=0, off=9069, siz=4, lab1=.L2640, lab2=, loff=0
!   reloc[1062]: knd=0, off=9077, siz=4, lab1=.L2644, lab2=, loff=0
!   reloc[1063]: knd=0, off=9085, siz=4, lab1=.L2648, lab2=, loff=0
!   reloc[1064]: knd=0, off=9093, siz=4, lab1=.L2650, lab2=, loff=0
!   reloc[1065]: knd=0, off=9101, siz=4, lab1=.L2654, lab2=, loff=0
!   reloc[1066]: knd=0, off=9109, siz=4, lab1=.L2658, lab2=, loff=0
!   reloc[1067]: knd=0, off=9117, siz=4, lab1=.L2660, lab2=, loff=0
!   reloc[1068]: knd=0, off=9125, siz=4, lab1=.L2664, lab2=, loff=0
!   reloc[1069]: knd=0, off=9133, siz=4, lab1=.L2668, lab2=, loff=0
!   reloc[1070]: knd=0, off=9141, siz=4, lab1=.L2670, lab2=, loff=0
!   reloc[1071]: knd=0, off=9149, siz=4, lab1=.L2674, lab2=, loff=0
!   reloc[1072]: knd=0, off=9157, siz=4, lab1=.L2678, lab2=, loff=0
!   reloc[1073]: knd=0, off=9165, siz=4, lab1=.L2680, lab2=, loff=0
!   reloc[1074]: knd=0, off=9173, siz=4, lab1=.L2684, lab2=, loff=0
!   reloc[1075]: knd=0, off=9181, siz=4, lab1=.L2688, lab2=, loff=0
!   reloc[1076]: knd=0, off=9189, siz=4, lab1=.L2690, lab2=, loff=0
!   reloc[1077]: knd=0, off=9197, siz=4, lab1=.L2694, lab2=, loff=0
!   reloc[1078]: knd=0, off=9205, siz=4, lab1=.L2698, lab2=, loff=0
!   reloc[1079]: knd=0, off=9213, siz=4, lab1=.L2700, lab2=, loff=0
!   reloc[1080]: knd=0, off=9221, siz=4, lab1=.L2704, lab2=, loff=0
!   reloc[1081]: knd=0, off=9229, siz=4, lab1=.L2708, lab2=, loff=0
!   reloc[1082]: knd=0, off=9237, siz=4, lab1=.L2710, lab2=, loff=0
!   reloc[1083]: knd=0, off=9245, siz=4, lab1=.L2714, lab2=, loff=0
!   reloc[1084]: knd=0, off=9253, siz=4, lab1=.L2718, lab2=, loff=0
!   reloc[1085]: knd=0, off=9261, siz=4, lab1=.L2722, lab2=, loff=0
!   reloc[1086]: knd=0, off=9269, siz=4, lab1=.L2726, lab2=, loff=0
!   reloc[1087]: knd=0, off=9277, siz=4, lab1=.L2728, lab2=, loff=0
!   reloc[1088]: knd=0, off=9285, siz=4, lab1=.L2732, lab2=, loff=0
!   reloc[1089]: knd=0, off=9293, siz=4, lab1=.L2736, lab2=, loff=0
!   reloc[1090]: knd=0, off=9301, siz=4, lab1=.L2740, lab2=, loff=0
!   reloc[1091]: knd=0, off=9309, siz=4, lab1=.L2744, lab2=, loff=0
!   reloc[1092]: knd=0, off=9317, siz=4, lab1=.L2746, lab2=, loff=0
!   reloc[1093]: knd=0, off=9325, siz=4, lab1=.L2750, lab2=, loff=0
!   reloc[1094]: knd=0, off=9333, siz=4, lab1=.L2754, lab2=, loff=0
!   reloc[1095]: knd=0, off=9341, siz=4, lab1=.L2758, lab2=, loff=0
!   reloc[1096]: knd=0, off=9349, siz=4, lab1=.L2762, lab2=, loff=0
!   reloc[1097]: knd=0, off=9357, siz=4, lab1=.L2764, lab2=, loff=0
!   reloc[1098]: knd=0, off=9365, siz=4, lab1=.L2768, lab2=, loff=0
!   reloc[1099]: knd=0, off=9373, siz=4, lab1=.L2772, lab2=, loff=0
!   reloc[1100]: knd=0, off=9381, siz=4, lab1=.L2776, lab2=, loff=0
!   reloc[1101]: knd=0, off=9389, siz=4, lab1=.L2780, lab2=, loff=0
!   reloc[1102]: knd=0, off=9397, siz=4, lab1=.L2782, lab2=, loff=0
!   reloc[1103]: knd=0, off=9405, siz=4, lab1=.L2786, lab2=, loff=0
!   reloc[1104]: knd=0, off=9413, siz=4, lab1=.L2790, lab2=, loff=0
!   reloc[1105]: knd=0, off=9421, siz=4, lab1=.L2794, lab2=, loff=0
!   reloc[1106]: knd=0, off=9429, siz=4, lab1=.L2798, lab2=, loff=0
!   reloc[1107]: knd=0, off=9437, siz=4, lab1=.L2800, lab2=, loff=0
!   reloc[1108]: knd=0, off=9445, siz=4, lab1=.L2804, lab2=, loff=0
!   reloc[1109]: knd=0, off=9453, siz=4, lab1=.L2808, lab2=, loff=0
!   reloc[1110]: knd=0, off=9461, siz=4, lab1=.L2812, lab2=, loff=0
!   reloc[1111]: knd=0, off=9469, siz=4, lab1=.L2816, lab2=, loff=0
!   reloc[1112]: knd=0, off=9477, siz=4, lab1=.L2818, lab2=, loff=0
!   reloc[1113]: knd=0, off=9485, siz=4, lab1=.L2822, lab2=, loff=0
!   reloc[1114]: knd=0, off=9493, siz=4, lab1=.L2826, lab2=, loff=0
!   reloc[1115]: knd=0, off=9501, siz=4, lab1=.L2830, lab2=, loff=0
!   reloc[1116]: knd=0, off=9509, siz=4, lab1=.L2834, lab2=, loff=0
!   reloc[1117]: knd=0, off=9517, siz=4, lab1=.L2836, lab2=, loff=0
!   reloc[1118]: knd=0, off=9525, siz=4, lab1=.L2840, lab2=, loff=0
!   reloc[1119]: knd=0, off=9533, siz=4, lab1=.L2844, lab2=, loff=0
!   reloc[1120]: knd=0, off=9541, siz=4, lab1=.L2848, lab2=, loff=0
!   reloc[1121]: knd=0, off=9549, siz=4, lab1=.L2852, lab2=, loff=0
!   reloc[1122]: knd=0, off=9557, siz=4, lab1=.L2854, lab2=, loff=0
!   reloc[1123]: knd=0, off=9565, siz=4, lab1=.L2858, lab2=, loff=0
!   reloc[1124]: knd=0, off=9573, siz=4, lab1=.L2862, lab2=, loff=0
!   reloc[1125]: knd=0, off=9581, siz=4, lab1=.L2866, lab2=, loff=0
!   reloc[1126]: knd=0, off=9589, siz=4, lab1=.L2870, lab2=, loff=0
!   reloc[1127]: knd=0, off=9597, siz=4, lab1=.L2872, lab2=, loff=0
!   reloc[1128]: knd=0, off=9605, siz=4, lab1=.L2876, lab2=, loff=0
!   reloc[1129]: knd=0, off=9616, siz=4, lab1=.L2879, lab2=, loff=0
!   reloc[1130]: knd=0, off=9627, siz=4, lab1=.L2881, lab2=, loff=0
!   reloc[1131]: knd=0, off=9635, siz=4, lab1=.L2885, lab2=, loff=0
!   reloc[1132]: knd=0, off=9646, siz=4, lab1=.L2888, lab2=, loff=0
!   reloc[1133]: knd=0, off=9662, siz=4, lab1=gl_EvalCoord1f, lab2=, loff=0
!   reloc[1134]: knd=0, off=9669, siz=4, lab1=.L2897, lab2=, loff=0
!   reloc[1135]: knd=0, off=9681, siz=4, lab1=.L2901, lab2=, loff=0
!   reloc[1136]: knd=0, off=9689, siz=4, lab1=.L2902, lab2=, loff=0
!   reloc[1137]: knd=0, off=9697, siz=4, lab1=.L2903, lab2=, loff=0
!   reloc[1138]: knd=0, off=9705, siz=4, lab1=.L2910, lab2=, loff=0
!   reloc[1139]: knd=0, off=9713, siz=4, lab1=.L2914, lab2=, loff=0
!   reloc[1140]: knd=0, off=9721, siz=4, lab1=.L2915, lab2=, loff=0
!   reloc[1141]: knd=0, off=9729, siz=4, lab1=.L2916, lab2=, loff=0
!   reloc[1142]: knd=0, off=9737, siz=4, lab1=.L2917, lab2=, loff=0
!   reloc[1143]: knd=0, off=9745, siz=4, lab1=.L2925, lab2=, loff=0
!   reloc[1144]: knd=0, off=9755, siz=4, lab1=.L2929, lab2=, loff=0
!   reloc[1145]: knd=0, off=9763, siz=4, lab1=.L2930, lab2=, loff=0
!   reloc[1146]: knd=0, off=9771, siz=4, lab1=.L2931, lab2=, loff=0
!   reloc[1147]: knd=0, off=9779, siz=4, lab1=.L2932, lab2=, loff=0
!   reloc[1148]: knd=0, off=9787, siz=4, lab1=.L2938, lab2=, loff=0
!   reloc[1149]: knd=0, off=9797, siz=4, lab1=.L2944, lab2=, loff=0
!   reloc[1150]: knd=0, off=9807, siz=4, lab1=.L2948, lab2=, loff=0
!   reloc[1151]: knd=0, off=9815, siz=4, lab1=.L2949, lab2=, loff=0
!   reloc[1152]: knd=0, off=9823, siz=4, lab1=.L2950, lab2=, loff=0
!   reloc[1153]: knd=0, off=9831, siz=4, lab1=.L2951, lab2=, loff=0
!   reloc[1154]: knd=0, off=9839, siz=4, lab1=.L2952, lab2=, loff=0
!   reloc[1155]: knd=0, off=9847, siz=4, lab1=.L2953, lab2=, loff=0
!   reloc[1156]: knd=0, off=9855, siz=4, lab1=.L2954, lab2=, loff=0
!   reloc[1157]: knd=0, off=9863, siz=4, lab1=.L2955, lab2=, loff=0
!   reloc[1158]: knd=0, off=9871, siz=4, lab1=.L2961, lab2=, loff=0
!   reloc[1159]: knd=0, off=9881, siz=4, lab1=.L2962, lab2=, loff=0
!   reloc[1160]: knd=0, off=9889, siz=4, lab1=.L2968, lab2=, loff=0
!   reloc[1161]: knd=0, off=9899, siz=4, lab1=.L2972, lab2=, loff=0
!   reloc[1162]: knd=0, off=9907, siz=4, lab1=.L2973, lab2=, loff=0
!   reloc[1163]: knd=0, off=9915, siz=4, lab1=.L2974, lab2=, loff=0
!   reloc[1164]: knd=0, off=9923, siz=4, lab1=.L2980, lab2=, loff=0
!   reloc[1165]: knd=0, off=9933, siz=4, lab1=.L2981, lab2=, loff=0
!   reloc[1166]: knd=0, off=9941, siz=4, lab1=.L2982, lab2=, loff=0
!   reloc[1167]: knd=0, off=9949, siz=4, lab1=.L2988, lab2=, loff=0
!   reloc[1168]: knd=0, off=9959, siz=4, lab1=.L2992, lab2=, loff=0
!   reloc[1169]: knd=0, off=9967, siz=4, lab1=.L2993, lab2=, loff=0
!   reloc[1170]: knd=0, off=9975, siz=4, lab1=.L2994, lab2=, loff=0
!   reloc[1171]: knd=0, off=9983, siz=4, lab1=.L3001, lab2=, loff=0
!   reloc[1172]: knd=0, off=9991, siz=4, lab1=.L3005, lab2=, loff=0
!   reloc[1173]: knd=0, off=9999, siz=4, lab1=.L3006, lab2=, loff=0
!   reloc[1174]: knd=0, off=10007, siz=4, lab1=.L3007, lab2=, loff=0
!   reloc[1175]: knd=0, off=10015, siz=4, lab1=.L3008, lab2=, loff=0
!   reloc[1176]: knd=0, off=10023, siz=4, lab1=.L3015, lab2=, loff=0
!   reloc[1177]: knd=0, off=10031, siz=4, lab1=.L3019, lab2=, loff=0
!   reloc[1178]: knd=0, off=10039, siz=4, lab1=.L3020, lab2=, loff=0
!   reloc[1179]: knd=0, off=10047, siz=4, lab1=.L3021, lab2=, loff=0
!   reloc[1180]: knd=0, off=10055, siz=4, lab1=.L3022, lab2=, loff=0
!   reloc[1181]: knd=0, off=10063, siz=4, lab1=.L3023, lab2=, loff=0
!   reloc[1182]: knd=0, off=10071, siz=4, lab1=.L3030, lab2=, loff=0
!   reloc[1183]: knd=0, off=10079, siz=4, lab1=.L3034, lab2=, loff=0
!   reloc[1184]: knd=0, off=10087, siz=4, lab1=.L3035, lab2=, loff=0
!   reloc[1185]: knd=0, off=10095, siz=4, lab1=.L3036, lab2=, loff=0
!   reloc[1186]: knd=0, off=10103, siz=4, lab1=.L3037, lab2=, loff=0
!   reloc[1187]: knd=0, off=10111, siz=4, lab1=.L3038, lab2=, loff=0
!   reloc[1188]: knd=0, off=10119, siz=4, lab1=.L3039, lab2=, loff=0
!   reloc[1189]: knd=0, off=10127, siz=4, lab1=.L3045, lab2=, loff=0
!   reloc[1190]: knd=0, off=10137, siz=4, lab1=.L3046, lab2=, loff=0
!   reloc[1191]: knd=0, off=10145, siz=4, lab1=.L3047, lab2=, loff=0
!   reloc[1192]: knd=0, off=10153, siz=4, lab1=.L3048, lab2=, loff=0
!   reloc[1193]: knd=0, off=10161, siz=4, lab1=.L3058, lab2=, loff=0
!   reloc[1194]: knd=0, off=10171, siz=4, lab1=.L3059, lab2=, loff=0
!   reloc[1195]: knd=0, off=10184, siz=4, lab1=gl_EvalCoord2f, lab2=, loff=0
!   reloc[1196]: knd=0, off=10191, siz=4, lab1=.L3068, lab2=, loff=0
!   reloc[1197]: knd=0, off=10203, siz=4, lab1=.L3072, lab2=, loff=0
!   reloc[1198]: knd=0, off=10211, siz=4, lab1=.L3073, lab2=, loff=0
!   reloc[1199]: knd=0, off=10219, siz=4, lab1=.L3074, lab2=, loff=0
!   reloc[1200]: knd=0, off=10227, siz=4, lab1=.L3077, lab2=, loff=0
!   reloc[1201]: knd=0, off=10235, siz=4, lab1=.L3081, lab2=, loff=0
!   reloc[1202]: knd=0, off=10245, siz=4, lab1=.L3082, lab2=, loff=0
!   reloc[1203]: knd=0, off=10253, siz=4, lab1=.L3084, lab2=, loff=0
!   reloc[1204]: knd=0, off=10261, siz=4, lab1=.L3099, lab2=, loff=0
!   reloc[1205]: knd=0, off=10271, siz=4, lab1=.L3109, lab2=, loff=0
!   reloc[1206]: knd=0, off=10281, siz=4, lab1=.L3113, lab2=, loff=0
!   reloc[1207]: knd=0, off=10289, siz=4, lab1=.L3114, lab2=, loff=0
!   reloc[1208]: knd=0, off=10297, siz=4, lab1=.L3115, lab2=, loff=0
!   reloc[1209]: knd=0, off=10305, siz=4, lab1=.L3118, lab2=, loff=0
!   reloc[1210]: knd=0, off=10313, siz=4, lab1=.L3122, lab2=, loff=0
!   reloc[1211]: knd=0, off=10323, siz=4, lab1=.L3123, lab2=, loff=0
!   reloc[1212]: knd=0, off=10331, siz=4, lab1=.L3125, lab2=, loff=0
!   reloc[1213]: knd=0, off=10339, siz=4, lab1=.L3140, lab2=, loff=0
!   reloc[1214]: knd=0, off=10349, siz=4, lab1=.L3144, lab2=, loff=0
!   reloc[1215]: knd=0, off=10357, siz=4, lab1=.L3152, lab2=, loff=0
!   reloc[1216]: knd=0, off=10367, siz=4, lab1=.L3156, lab2=, loff=0
!   reloc[1217]: knd=0, off=10375, siz=4, lab1=.L3157, lab2=, loff=0
!   reloc[1218]: knd=0, off=10383, siz=4, lab1=.L3158, lab2=, loff=0
!   reloc[1219]: knd=0, off=10391, siz=4, lab1=.L3159, lab2=, loff=0
!   reloc[1220]: knd=0, off=10399, siz=4, lab1=.L3160, lab2=, loff=0
!   reloc[1221]: knd=0, off=10407, siz=4, lab1=.L3166, lab2=, loff=0
!   reloc[1222]: knd=0, off=10417, siz=4, lab1=.L3172, lab2=, loff=0
!   reloc[1223]: knd=0, off=10427, siz=4, lab1=.L3176, lab2=, loff=0
!   reloc[1224]: knd=0, off=10435, siz=4, lab1=.L3177, lab2=, loff=0
!   reloc[1225]: knd=0, off=10443, siz=4, lab1=.L3178, lab2=, loff=0
!   reloc[1226]: knd=0, off=10451, siz=4, lab1=.L3179, lab2=, loff=0
!   reloc[1227]: knd=0, off=10459, siz=4, lab1=.L3180, lab2=, loff=0
!   reloc[1228]: knd=0, off=10467, siz=4, lab1=.L3181, lab2=, loff=0
!   reloc[1229]: knd=0, off=10475, siz=4, lab1=.L3182, lab2=, loff=0
!   reloc[1230]: knd=0, off=10483, siz=4, lab1=.L3183, lab2=, loff=0
!   reloc[1231]: knd=0, off=10491, siz=4, lab1=.L3184, lab2=, loff=0
!   reloc[1232]: knd=0, off=10499, siz=4, lab1=.L3190, lab2=, loff=0
!   reloc[1233]: knd=0, off=10509, siz=4, lab1=.L3191, lab2=, loff=0
!   reloc[1234]: knd=0, off=10517, siz=4, lab1=.L3197, lab2=, loff=0
!   reloc[1235]: knd=0, off=10527, siz=4, lab1=.L3206, lab2=, loff=0
!   reloc[1236]: knd=0, off=10535, siz=4, lab1=.L3210, lab2=, loff=0
!   reloc[1237]: knd=0, off=10543, siz=4, lab1=.L3211, lab2=, loff=0
!   reloc[1238]: knd=0, off=10551, siz=4, lab1=.L3212, lab2=, loff=0
!   reloc[1239]: knd=0, off=10559, siz=4, lab1=.L3213, lab2=, loff=0
!   reloc[1240]: knd=0, off=10567, siz=4, lab1=.L3219, lab2=, loff=0
!   reloc[1241]: knd=0, off=10577, siz=4, lab1=.L3220, lab2=, loff=0
!   reloc[1242]: knd=0, off=10585, siz=4, lab1=.L3221, lab2=, loff=0
!   reloc[1243]: knd=0, off=10593, siz=4, lab1=.L3230, lab2=, loff=0
!   reloc[1244]: knd=0, off=10603, siz=4, lab1=.L3234, lab2=, loff=0
!   reloc[1245]: knd=0, off=10611, siz=4, lab1=.L3235, lab2=, loff=0
!   reloc[1246]: knd=0, off=10619, siz=4, lab1=.L3236, lab2=, loff=0
!   reloc[1247]: knd=0, off=10627, siz=4, lab1=.L3237, lab2=, loff=0
!   reloc[1248]: knd=0, off=10635, siz=4, lab1=.L3244, lab2=, loff=0
!   reloc[1249]: knd=0, off=10643, siz=4, lab1=.L3248, lab2=, loff=0
!   reloc[1250]: knd=0, off=10651, siz=4, lab1=.L3249, lab2=, loff=0
!   reloc[1251]: knd=0, off=10659, siz=4, lab1=.L3250, lab2=, loff=0
!   reloc[1252]: knd=0, off=10667, siz=4, lab1=.L3251, lab2=, loff=0
!   reloc[1253]: knd=0, off=10675, siz=4, lab1=.L3252, lab2=, loff=0
!   reloc[1254]: knd=0, off=10683, siz=4, lab1=.L3259, lab2=, loff=0
!   reloc[1255]: knd=0, off=10691, siz=4, lab1=.L3263, lab2=, loff=0
!   reloc[1256]: knd=0, off=10699, siz=4, lab1=.L3264, lab2=, loff=0
!   reloc[1257]: knd=0, off=10707, siz=4, lab1=.L3265, lab2=, loff=0
!   reloc[1258]: knd=0, off=10715, siz=4, lab1=.L3266, lab2=, loff=0
!   reloc[1259]: knd=0, off=10723, siz=4, lab1=.L3267, lab2=, loff=0
!   reloc[1260]: knd=0, off=10731, siz=4, lab1=.L3268, lab2=, loff=0
!   reloc[1261]: knd=0, off=10739, siz=4, lab1=.L3275, lab2=, loff=0
!   reloc[1262]: knd=0, off=10747, siz=4, lab1=.L3279, lab2=, loff=0
!   reloc[1263]: knd=0, off=10755, siz=4, lab1=.L3280, lab2=, loff=0
!   reloc[1264]: knd=0, off=10763, siz=4, lab1=.L3281, lab2=, loff=0
!   reloc[1265]: knd=0, off=10771, siz=4, lab1=.L3282, lab2=, loff=0
!   reloc[1266]: knd=0, off=10779, siz=4, lab1=.L3283, lab2=, loff=0
!   reloc[1267]: knd=0, off=10787, siz=4, lab1=.L3284, lab2=, loff=0
!   reloc[1268]: knd=0, off=10795, siz=4, lab1=.L3285, lab2=, loff=0
!   reloc[1269]: knd=0, off=10803, siz=4, lab1=.L3291, lab2=, loff=0
!   reloc[1270]: knd=0, off=10813, siz=4, lab1=.L3292, lab2=, loff=0
!   reloc[1271]: knd=0, off=10821, siz=4, lab1=.L3293, lab2=, loff=0
!   reloc[1272]: knd=0, off=10829, siz=4, lab1=.L3294, lab2=, loff=0
!   reloc[1273]: knd=0, off=10837, siz=4, lab1=.L3304, lab2=, loff=0
!   reloc[1274]: knd=0, off=10847, siz=4, lab1=.L3305, lab2=, loff=0
!   reloc[1275]: knd=0, off=10860, siz=4, lab1=gl_MapGrid1f, lab2=, loff=0
!   reloc[1276]: knd=0, off=10867, siz=4, lab1=.L3314, lab2=, loff=0
!   reloc[1277]: knd=0, off=10879, siz=4, lab1=.L3318, lab2=, loff=0
!   reloc[1278]: knd=0, off=10887, siz=4, lab1=.L3320, lab2=, loff=0
!   reloc[1279]: knd=0, off=10895, siz=4, lab1=.L3326, lab2=, loff=0
!   reloc[1280]: knd=0, off=10903, siz=4, lab1=.L3330, lab2=, loff=0
!   reloc[1281]: knd=0, off=10911, siz=4, lab1=.L3332, lab2=, loff=0
!   reloc[1282]: knd=0, off=10919, siz=4, lab1=.L3336, lab2=, loff=0
!   reloc[1283]: knd=0, off=10927, siz=4, lab1=.L3337, lab2=, loff=0
!   reloc[1284]: knd=0, off=10935, siz=4, lab1=.L3338, lab2=, loff=0
!   reloc[1285]: knd=0, off=10943, siz=4, lab1=.L3339, lab2=, loff=0
!   reloc[1286]: knd=0, off=10956, siz=4, lab1=gl_MapGrid2f, lab2=, loff=0
!   reloc[1287]: knd=0, off=10963, siz=4, lab1=.L3348, lab2=, loff=0
!   reloc[1288]: knd=0, off=10975, siz=4, lab1=.L3352, lab2=, loff=0
!   reloc[1289]: knd=0, off=10983, siz=4, lab1=.L3354, lab2=, loff=0
!   reloc[1290]: knd=0, off=10991, siz=4, lab1=.L3360, lab2=, loff=0
!   reloc[1291]: knd=0, off=10999, siz=4, lab1=.L3364, lab2=, loff=0
!   reloc[1292]: knd=0, off=11007, siz=4, lab1=.L3366, lab2=, loff=0
!   reloc[1293]: knd=0, off=11015, siz=4, lab1=.L3372, lab2=, loff=0
!   reloc[1294]: knd=0, off=11023, siz=4, lab1=.L3376, lab2=, loff=0
!   reloc[1295]: knd=0, off=11031, siz=4, lab1=.L3378, lab2=, loff=0
!   reloc[1296]: knd=0, off=11039, siz=4, lab1=.L3382, lab2=, loff=0
!   reloc[1297]: knd=0, off=11047, siz=4, lab1=.L3383, lab2=, loff=0
!   reloc[1298]: knd=0, off=11055, siz=4, lab1=.L3384, lab2=, loff=0
!   reloc[1299]: knd=0, off=11063, siz=4, lab1=.L3385, lab2=, loff=0
!   reloc[1300]: knd=0, off=11071, siz=4, lab1=.L3386, lab2=, loff=0
!   reloc[1301]: knd=0, off=11079, siz=4, lab1=.L3387, lab2=, loff=0
!   reloc[1302]: knd=0, off=11087, siz=4, lab1=.L3388, lab2=, loff=0
!   reloc[1303]: knd=0, off=11100, siz=4, lab1=gl_EvalPoint1, lab2=, loff=0
!   reloc[1304]: knd=0, off=11107, siz=4, lab1=.L3397, lab2=, loff=0
!   reloc[1305]: knd=0, off=11119, siz=4, lab1=.L3401, lab2=, loff=0
!   reloc[1306]: knd=0, off=11127, siz=4, lab1=.L3408, lab2=, loff=0
!   reloc[1307]: knd=0, off=11135, siz=4, lab1=.L3412, lab2=, loff=0
!   reloc[1308]: knd=0, off=11143, siz=4, lab1=.L3418, lab2=, loff=0
!   reloc[1309]: knd=0, off=11153, siz=4, lab1=.L3419, lab2=, loff=0
!   reloc[1310]: knd=0, off=11161, siz=4, lab1=.L3425, lab2=, loff=0
!   reloc[1311]: knd=0, off=11169, siz=4, lab1=.L3426, lab2=, loff=0
!   reloc[1312]: knd=0, off=11182, siz=4, lab1=gl_EvalPoint2, lab2=, loff=0
!   reloc[1313]: knd=0, off=11189, siz=4, lab1=.L3435, lab2=, loff=0
!   reloc[1314]: knd=0, off=11201, siz=4, lab1=.L3439, lab2=, loff=0
!   reloc[1315]: knd=0, off=11209, siz=4, lab1=.L3446, lab2=, loff=0
!   reloc[1316]: knd=0, off=11217, siz=4, lab1=.L3450, lab2=, loff=0
!   reloc[1317]: knd=0, off=11225, siz=4, lab1=.L3456, lab2=, loff=0
!   reloc[1318]: knd=0, off=11235, siz=4, lab1=.L3457, lab2=, loff=0
!   reloc[1319]: knd=0, off=11243, siz=4, lab1=.L3465, lab2=, loff=0
!   reloc[1320]: knd=0, off=11253, siz=4, lab1=.L3469, lab2=, loff=0
!   reloc[1321]: knd=0, off=11261, siz=4, lab1=.L3476, lab2=, loff=0
!   reloc[1322]: knd=0, off=11269, siz=4, lab1=.L3480, lab2=, loff=0
!   reloc[1323]: knd=0, off=11277, siz=4, lab1=.L3486, lab2=, loff=0
!   reloc[1324]: knd=0, off=11287, siz=4, lab1=.L3487, lab2=, loff=0
!   reloc[1325]: knd=0, off=11295, siz=4, lab1=.L3493, lab2=, loff=0
!   reloc[1326]: knd=0, off=11305, siz=4, lab1=.L3494, lab2=, loff=0
!   reloc[1327]: knd=0, off=11318, siz=4, lab1=gl_EvalMesh1, lab2=, loff=0
!   reloc[1328]: knd=0, off=11325, siz=4, lab1=.L3503, lab2=, loff=0
!   reloc[1329]: knd=0, off=11337, siz=4, lab1=.L3507, lab2=, loff=0
!   reloc[1330]: knd=0, off=11345, siz=4, lab1=.L3509, lab2=, loff=0
!   reloc[1331]: knd=0, off=11353, siz=4, lab1=.L3516, lab2=, loff=0
!   reloc[1332]: knd=0, off=11363, siz=4, lab1=.L3520, lab2=, loff=0
!   reloc[1333]: knd=0, off=11371, siz=4, lab1=.L3521, lab2=, loff=0
!   reloc[1334]: knd=0, off=11379, siz=4, lab1=.L3523, lab2=, loff=0
!   reloc[1335]: knd=0, off=11387, siz=4, lab1=.L3524, lab2=, loff=0
!   reloc[1336]: knd=0, off=11395, siz=4, lab1=.L3526, lab2=, loff=0
!   reloc[1337]: knd=0, off=11403, siz=4, lab1=.L3528, lab2=, loff=0
!   reloc[1338]: knd=0, off=11411, siz=4, lab1=.L3531, lab2=, loff=0
!   reloc[1339]: knd=0, off=11421, siz=4, lab1=.L3534, lab2=, loff=0
!   reloc[1340]: knd=0, off=11431, siz=4, lab1=.L3535, lab2=, loff=0
!   reloc[1341]: knd=0, off=11439, siz=4, lab1=.L3537, lab2=, loff=0
!   reloc[1342]: knd=0, off=11447, siz=4, lab1=.L3546, lab2=, loff=0
!   reloc[1343]: knd=0, off=11455, siz=4, lab1=.L3550, lab2=, loff=0
!   reloc[1344]: knd=0, off=11463, siz=4, lab1=.L3557, lab2=, loff=0
!   reloc[1345]: knd=0, off=11471, siz=4, lab1=.L3561, lab2=, loff=0
!   reloc[1346]: knd=0, off=11479, siz=4, lab1=.L3567, lab2=, loff=0
!   reloc[1347]: knd=0, off=11489, siz=4, lab1=.L3573, lab2=, loff=0
!   reloc[1348]: knd=0, off=11497, siz=4, lab1=.L3576, lab2=, loff=0
!   reloc[1349]: knd=0, off=11507, siz=4, lab1=.L3579, lab2=, loff=0
!   reloc[1350]: knd=0, off=11517, siz=4, lab1=.L3580, lab2=, loff=0
!   reloc[1351]: knd=0, off=11530, siz=4, lab1=gl_EvalMesh2, lab2=, loff=0
!   reloc[1352]: knd=0, off=11537, siz=4, lab1=.L3589, lab2=, loff=0
!   reloc[1353]: knd=0, off=11549, siz=4, lab1=.L3593, lab2=, loff=0
!   reloc[1354]: knd=0, off=11557, siz=4, lab1=.L3595, lab2=, loff=0
!   reloc[1355]: knd=0, off=11565, siz=4, lab1=.L3599, lab2=, loff=0
!   reloc[1356]: knd=0, off=11575, siz=4, lab1=.L3600, lab2=, loff=0
!   reloc[1357]: knd=0, off=11583, siz=4, lab1=.L3604, lab2=, loff=0
!   reloc[1358]: knd=0, off=11593, siz=4, lab1=.L3608, lab2=, loff=0
!   reloc[1359]: knd=0, off=11601, siz=4, lab1=.L3610, lab2=, loff=0
!   reloc[1360]: knd=0, off=11609, siz=4, lab1=.L3619, lab2=, loff=0
!   reloc[1361]: knd=0, off=11617, siz=4, lab1=.L3643, lab2=, loff=0
!   reloc[1362]: knd=0, off=11625, siz=4, lab1=.L3652, lab2=, loff=0
!   reloc[1363]: knd=0, off=11633, siz=4, lab1=.L3675, lab2=, loff=0
!   reloc[1364]: knd=0, off=11641, siz=4, lab1=.L3678, lab2=, loff=0
!   reloc[1365]: knd=0, off=11651, siz=4, lab1=.L3683, lab2=, loff=0
!   reloc[1366]: knd=0, off=11661, siz=4, lab1=.L3686, lab2=, loff=0
!   reloc[1367]: knd=0, off=11671, siz=4, lab1=.L3687, lab2=, loff=0
!   reloc[1368]: knd=0, off=11679, siz=4, lab1=.L3690, lab2=, loff=0
!   reloc[1369]: knd=0, off=11687, siz=4, lab1=.L3699, lab2=, loff=0
!   reloc[1370]: knd=0, off=11695, siz=4, lab1=.L3722, lab2=, loff=0
!   reloc[1371]: knd=0, off=11703, siz=4, lab1=.L3724, lab2=, loff=0
!   reloc[1372]: knd=0, off=11711, siz=4, lab1=.L3733, lab2=, loff=0
!   reloc[1373]: knd=0, off=11719, siz=4, lab1=.L3756, lab2=, loff=0
!   reloc[1374]: knd=0, off=11727, siz=4, lab1=.L3759, lab2=, loff=0
!   reloc[1375]: knd=0, off=11737, siz=4, lab1=.L3762, lab2=, loff=0
!   reloc[1376]: knd=0, off=11747, siz=4, lab1=.L3765, lab2=, loff=0
!   reloc[1377]: knd=0, off=11757, siz=4, lab1=.L3769, lab2=, loff=0
!   reloc[1378]: knd=0, off=11767, siz=4, lab1=.L3778, lab2=, loff=0
!   reloc[1379]: knd=0, off=11775, siz=4, lab1=.L3801, lab2=, loff=0
!   reloc[1380]: knd=0, off=11783, siz=4, lab1=.L3803, lab2=, loff=0
!   reloc[1381]: knd=0, off=11791, siz=4, lab1=.L3812, lab2=, loff=0
!   reloc[1382]: knd=0, off=11799, siz=4, lab1=.L3835, lab2=, loff=0
!   reloc[1383]: knd=0, off=11807, siz=4, lab1=.L3838, lab2=, loff=0
!   reloc[1384]: knd=0, off=11817, siz=4, lab1=.L3841, lab2=, loff=0
!   reloc[1385]: knd=0, off=11827, siz=4, lab1=.L3844, lab2=, loff=0
!   reloc[1386]: knd=0, off=11837, siz=4, lab1=.L3847, lab2=, loff=0
!   reloc[1387]: knd=0, off=11847, siz=4, lab1=.L3850, lab2=, loff=0
!   reloc[1388]: knd=0, off=11855, siz=4, lab1=.L3857, lab2=, loff=0
!   reloc[1389]: knd=0, off=11865, siz=4, lab1=.L3860, lab2=, loff=0
!   reloc[1390]: knd=0, off=11873, siz=4, lab1=.L3885, lab2=, loff=0
!   reloc[1391]: knd=0, off=11881, siz=4, lab1=.L3909, lab2=, loff=0
!   reloc[1392]: knd=0, off=11889, siz=4, lab1=.L3918, lab2=, loff=0
!   reloc[1393]: knd=0, off=11897, siz=4, lab1=.L3941, lab2=, loff=0
!   reloc[1394]: knd=0, off=11905, siz=4, lab1=.L3942, lab2=, loff=0
!   reloc[1395]: knd=0, off=11913, siz=4, lab1=.L3945, lab2=, loff=0
!   reloc[1396]: knd=0, off=11923, siz=4, lab1=.L3948, lab2=, loff=0
!   reloc[1397]: knd=0, off=11933, siz=4, lab1=.L3951, lab2=, loff=0
!   reloc[1398]: knd=0, off=11943, siz=4, lab1=.L3954, lab2=, loff=0
!   reloc[1399]: knd=0, off=11953, siz=4, lab1=.L3956, lab2=, loff=0
!   reloc[1400]: knd=0, off=11961, siz=4, lab1=.L3958, lab2=, loff=0
!   reloc[1401]: knd=0, off=11969, siz=4, lab1=.L3961, lab2=, loff=0
!   reloc[1402]: knd=0, off=11979, siz=4, lab1=.L3964, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x2e,0xd3,0x00,0x02,0x00,0x00
	.byte 0x00,0x6f,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x65,0x76,0x61,0x6c,0x2e
	.byte 0x63,0x00,0x01,0x00,0x00,0x67,0x6c,0x2e
	.byte 0x68,0x00,0x02,0x00,0x00,0x74,0x79,0x70
	.byte 0x65,0x73,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x64,0x64,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x00,0x00,0x05,0x02
	.uaword gl_init_eval
	.byte 0x00,0x05,0x02
	.uaword .L19
	.byte 0x06,0x03,0xdd,0x00,0x01,0x00,0x05,0x02
	.uaword .L26
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L27
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword horner_bezier_curve
	.byte 0x00,0x05,0x02
	.uaword .L36
	.byte 0x06,0x03,0x85,0x01,0x01,0x00,0x05,0x02
	.uaword .L40
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L41
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L43
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L49
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L51
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L55
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L62
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L63
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L65
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L71
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L73
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L78
	.byte 0x03,0x7b,0x01,0x00,0x05,0x02
	.uaword .L87
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L93
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L95
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L101
	.byte 0x03,0x03,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword horner_bezier_surf
	.byte 0x00,0x05,0x02
	.uaword .L108
	.byte 0x06,0x03,0xaf,0x01,0x01,0x00,0x05,0x02
	.uaword .L109
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L112
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L118
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L123
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L130
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L131
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L134
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L142
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L146
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L153
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L154
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L156
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L164
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L169
	.byte 0x03,0x7b,0x01,0x00,0x05,0x02
	.uaword .L170
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L175
	.byte 0x03,0x74,0x01,0x00,0x05,0x02
	.uaword .L178
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L183
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L193
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L198
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L205
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L208
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L211
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L216
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L222
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword de_casteljau_surf
	.byte 0x00,0x05,0x02
	.uaword .L229
	.byte 0x06,0x03,0x82,0x02,0x01,0x00,0x05,0x02
	.uaword .L230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L231
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L235
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L239
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L245
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L250
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L257
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L258
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L259
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L262
	.byte 0x03,0x74,0x01,0x00,0x05,0x02
	.uaword .L271
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L276
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L283
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L286
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L293
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L295
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L296
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L299
	.byte 0x03,0x78,0x01,0x00,0x05,0x02
	.uaword .L303
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L310
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L317
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L318
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L321
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L325
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L328
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L329
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L330
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L333
	.byte 0x03,0x5d,0x01,0x00,0x05,0x02
	.uaword .L342
	.byte 0x03,0x28,0x01,0x00,0x05,0x02
	.uaword .L349
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L350
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L359
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L360
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L361
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L365
	.byte 0x03,0x78,0x01,0x00,0x05,0x02
	.uaword .L369
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L376
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L383
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L384
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L387
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L391
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L394
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L395
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L396
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L399
	.byte 0x03,0x5e,0x01,0x00,0x05,0x02
	.uaword .L413
	.byte 0x03,0x26,0x01,0x00,0x05,0x02
	.uaword .L418
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L426
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L433
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L435
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L442
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L446
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L451
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L455
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L462
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L469
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L471
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L478
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L479
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L482
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L487
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L491
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L494
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L495
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L496
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L499
	.byte 0x03,0x5d,0x01,0x00,0x05,0x02
	.uaword .L508
	.byte 0x03,0x26,0x01,0x00,0x05,0x02
	.uaword .L513
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L521
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L528
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L530
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L537
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L538
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L541
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L546
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L550
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L557
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L564
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L566
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L573
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L574
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L577
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L582
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L586
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L589
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L590
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L592
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L599
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L600
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L601
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L605
	.byte 0x03,0x78,0x01,0x00,0x05,0x02
	.uaword .L609
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L616
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L623
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L624
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L627
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L631
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L634
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L635
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L636
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L639
	.byte 0x03,0x47,0x01,0x00,0x05,0x02
	.uaword .L648
	.byte 0x03,0x3e,0x01,0x00,0x05,0x02
	.uaword .L656
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L663
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L672
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L676
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L681
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L685
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L699
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L701
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L708
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L709
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L712
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L717
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L721
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L724
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L725
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L727
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L734
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L735
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L736
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L737
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L740
	.byte 0x03,0x78,0x01,0x00,0x05,0x02
	.uaword .L744
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L751
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L758
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L759
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L762
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L766
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L769
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L770
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L771
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L774
	.byte 0x03,0x47,0x01,0x00,0x05,0x02
	.uaword .L784
	.byte 0x03,0x3e,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword components
	.byte 0x00,0x05,0x02
	.uaword .L794
	.byte 0x06,0x03,0xa3,0x04,0x01,0x00,0x05,0x02
	.uaword .L798
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L800
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L802
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L804
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L806
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L810
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L816
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L818
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L820
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L822
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L824
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L828
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L832
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L837
	.byte 0x03,0x6d,0x01,0x00,0x05,0x02
	.uaword .L840
	.byte 0x03,0x15,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_copy_map_points1f
	.byte 0x00,0x05,0x02
	.uaword .L847
	.byte 0x06,0x03,0xcc,0x04,0x01,0x00,0x05,0x02
	.uaword .L850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L856
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L860
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L863
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L867
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L874
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L880
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L882
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L886
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L891
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L892
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_copy_map_points1d
	.byte 0x00,0x05,0x02
	.uaword .L899
	.byte 0x06,0x03,0xe6,0x04,0x01,0x00,0x05,0x02
	.uaword .L900
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L903
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L907
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L914
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L920
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L922
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L926
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L931
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L932
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_copy_map_points2f
	.byte 0x00,0x05,0x02
	.uaword .L939
	.byte 0x06,0x03,0x87,0x05,0x01,0x00,0x05,0x02
	.uaword .L940
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L945
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L951
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L954
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L958
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L961
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L964
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L968
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L975
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L988
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L990
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L994
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L998
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1003
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1004
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_copy_map_points2d
	.byte 0x00,0x05,0x02
	.uaword .L1011
	.byte 0x06,0x03,0xae,0x05,0x01,0x00,0x05,0x02
	.uaword .L1012
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1017
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1023
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1026
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1030
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1033
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1036
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1040
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1054
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1060
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1062
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1066
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1070
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1075
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1076
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_free_control_points
	.byte 0x00,0x05,0x02
	.uaword .L1083
	.byte 0x06,0x03,0xce,0x05,0x01,0x00,0x05,0x02
	.uaword .L1084
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1088
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1092
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1093
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1095
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1096
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1098
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1099
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1101
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1102
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1104
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1105
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1107
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1108
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1110
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1111
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1113
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1116
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1117
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1119
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1120
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1122
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1123
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1125
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1126
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1128
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1129
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1131
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1134
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1137
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1138
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1140
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1141
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1143
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1144
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1146
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1148
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1151
	.byte 0x03,0x47,0x01,0x00,0x05,0x02
	.uaword .L1156
	.byte 0x03,0x3c,0x01,0x00,0x05,0x02
	.uaword .L1162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1166
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1172
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1181
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1187
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1191
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1197
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1204
	.byte 0x03,0x04,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_Map1f
	.byte 0x00,0x05,0x02
	.uaword .L1213
	.byte 0x06,0x03,0xba,0x06,0x01,0x00,0x05,0x02
	.uaword .L1217
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1219
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1223
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1226
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1232
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1238
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1242
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1244
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1250
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1256
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1258
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1262
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1265
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1269
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1276
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1280
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1289
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1293
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1295
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1298
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1303
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1307
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1308
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1309
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1311
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1316
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1321
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1325
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1329
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1331
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1334
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1339
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1343
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1345
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1347
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1349
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1352
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1357
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1361
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1363
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1365
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1366
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1367
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1370
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1375
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1379
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1380
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1381
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1383
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1385
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1388
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1393
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1397
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1398
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1399
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1401
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1402
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1403
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1406
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1411
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1415
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1416
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1417
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1419
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1421
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1424
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1429
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1433
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1434
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1435
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1437
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1438
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1439
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1442
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1451
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1452
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1453
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1455
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1459
	.byte 0x03,0x9b,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1462
	.byte 0x03,0xe7,0x00,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_Map2f
	.byte 0x00,0x05,0x02
	.uaword .L1471
	.byte 0x06,0x03,0xd3,0x07,0x01,0x00,0x05,0x02
	.uaword .L1475
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1477
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1483
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1487
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1489
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1495
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1499
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1501
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1507
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1513
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1521
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1529
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1533
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1536
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1540
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1547
	.byte 0x03,0x03,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1551
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1553
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1559
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1563
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1572
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1576
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1579
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1580
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1581
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1584
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1589
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1593
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1594
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1595
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1597
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1598
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1599
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1600
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1601
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1605
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1610
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1614
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1615
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1616
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1618
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1619
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1620
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1621
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1622
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1623
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1626
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1631
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1635
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1636
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1637
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1639
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1640
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1641
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1642
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1643
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1644
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1647
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1652
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1656
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1657
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1658
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1660
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1661
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1662
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1663
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1668
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1677
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1678
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1679
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1681
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1682
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1684
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1685
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1686
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1689
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1694
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1698
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1699
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1700
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1702
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1703
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1704
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1706
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1707
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1710
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1719
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1720
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1721
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1723
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1724
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1725
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1726
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1727
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1728
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1731
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1736
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1740
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1741
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1742
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1744
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1745
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1746
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1747
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1748
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1749
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1752
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1757
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1761
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1763
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1765
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1769
	.byte 0x03,0x80,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1772
	.byte 0x03,0x82,0x01,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetMapdv
	.byte 0x00,0x05,0x02
	.uaword .L1782
	.byte 0x06,0x03,0x87,0x09,0x01,0x00,0x05,0x02
	.uaword .L1789
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1793
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1795
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1797
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1798
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1799
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1801
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1802
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1803
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1805
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1806
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1807
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1809
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1810
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1811
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1813
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1815
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1817
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1818
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1819
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1821
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1822
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1823
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1825
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1827
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1829
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1830
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1831
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1833
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1834
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1835
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1837
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1838
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1839
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1841
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1842
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1843
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1845
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1846
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1847
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1849
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1853
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1854
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1855
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1857
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1858
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1859
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1861
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1862
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1863
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1865
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1869
	.byte 0x03,0xad,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1874
	.byte 0x03,0xd5,0x00,0x01,0x00,0x05,0x02
	.uaword .L1879
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1886
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1889
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1895
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1900
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1904
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1905
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1907
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1908
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1910
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1911
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1913
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1914
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1916
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1919
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1920
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1922
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1923
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1925
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1926
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1928
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1929
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1931
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1932
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1933
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1935
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1936
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1937
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1939
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1940
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1943
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1944
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1945
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1947
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1948
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1949
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1951
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1952
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1955
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1956
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1957
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1959
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1960
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1961
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1963
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1964
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1965
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1967
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1971
	.byte 0x03,0xbf,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1974
	.byte 0x03,0xc3,0x00,0x01,0x00,0x05,0x02
	.uaword .L1979
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1983
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1984
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1985
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1987
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1988
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1991
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1992
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1993
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1995
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1997
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1999
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2000
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2001
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2003
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2004
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2005
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2007
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2008
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2009
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2011
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2012
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2013
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2015
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2017
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2019
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2020
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2021
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2022
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2023
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2025
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2026
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2027
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2028
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2029
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2031
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2032
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2033
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2035
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2037
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2038
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2039
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2040
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2041
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2043
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2044
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2045
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2046
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2049
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2050
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2051
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2052
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2053
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2055
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2056
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2057
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2058
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2059
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2061
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2062
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2063
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2064
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2065
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2067
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2068
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2069
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2070
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2071
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2073
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2077
	.byte 0x03,0xa4,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2080
	.byte 0x03,0xde,0x00,0x01,0x00,0x05,0x02
	.uaword .L2082
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2086
	.byte 0x03,0xfd,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2089
	.byte 0x03,0x85,0x02,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetMapfv
	.byte 0x00,0x05,0x02
	.uaword .L2099
	.byte 0x06,0x03,0x94,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2106
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2110
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2111
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2112
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2114
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2115
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2116
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2118
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2119
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2120
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2122
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2123
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2124
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2126
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2127
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2128
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2130
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2134
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2138
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2139
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2142
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2143
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2144
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2146
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2147
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2148
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2150
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2151
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2152
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2154
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2155
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2158
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2159
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2160
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2162
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2163
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2164
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2166
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2167
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2170
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2171
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2172
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2174
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2175
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2179
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2180
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2182
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2186
	.byte 0x03,0xad,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2191
	.byte 0x03,0xd5,0x00,0x01,0x00,0x05,0x02
	.uaword .L2196
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2203
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2206
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2212
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2217
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2221
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2222
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2224
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2225
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2227
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2228
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2230
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2233
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2234
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2236
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2237
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2239
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2240
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2242
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2243
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2245
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2246
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2248
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2249
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2250
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2252
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2253
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2254
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2256
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2257
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2258
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2260
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2261
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2262
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2264
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2265
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2266
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2268
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2269
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2270
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2272
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2273
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2274
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2276
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2277
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2278
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2280
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2281
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2284
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2288
	.byte 0x03,0xbf,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2291
	.byte 0x03,0xc3,0x00,0x01,0x00,0x05,0x02
	.uaword .L2296
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2300
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2301
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2302
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2304
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2305
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2306
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2308
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2309
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2310
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2312
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2314
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2316
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2317
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2320
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2321
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2322
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2324
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2325
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2328
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2329
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2332
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2333
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2334
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2336
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2337
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2338
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2339
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2340
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2342
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2343
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2345
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2346
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2348
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2349
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2350
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2351
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2354
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2355
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2356
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2357
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2358
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2360
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2361
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2363
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2366
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2367
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2368
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2369
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2370
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2372
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2373
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2374
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2375
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2376
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2378
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2379
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2380
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2381
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2382
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2384
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2385
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2387
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2388
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2390
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2394
	.byte 0x03,0xa4,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2397
	.byte 0x03,0xde,0x00,0x01,0x00,0x05,0x02
	.uaword .L2399
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2403
	.byte 0x03,0xfd,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2406
	.byte 0x03,0x85,0x02,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetMapiv
	.byte 0x00,0x05,0x02
	.uaword .L2416
	.byte 0x06,0x03,0xa1,0x0d,0x01,0x00,0x05,0x02
	.uaword .L2423
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2427
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2428
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2429
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2431
	.byte 0x0d,0x00,0x05
	.byte 0x02
	.uaword .L2432
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2433
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2435
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2436
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2437
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2439
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2440
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2441
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2443
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2444
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2445
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2447
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2448
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2449
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2451
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2452
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2453
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2455
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2456
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2459
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2460
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2461
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2463
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2464
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2465
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2467
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2468
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2469
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2471
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2472
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2475
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2476
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2477
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2479
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2480
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2481
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2483
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2484
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2485
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2487
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2488
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2489
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2491
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2492
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2493
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2495
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2496
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2497
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2499
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2503
	.byte 0x03,0xad,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2508
	.byte 0x03,0xd5,0x00,0x01,0x00,0x05,0x02
	.uaword .L2513
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2520
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2526
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2532
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2537
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2542
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2544
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2545
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2547
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2548
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2550
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2551
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2553
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2554
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2556
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2557
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2559
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2560
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2562
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2563
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2565
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2566
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2568
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2569
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2570
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2572
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2573
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2574
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2576
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2580
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2581
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2582
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2584
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2585
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2586
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2588
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2589
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2590
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2592
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2593
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2594
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2596
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2598
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2600
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2601
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2604
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2608
	.byte 0x03,0xbf,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2611
	.byte 0x03,0xc3,0x00,0x01,0x00,0x05,0x02
	.uaword .L2616
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2620
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2624
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2628
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2630
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2634
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2638
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2640
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2644
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2648
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2650
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2654
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2658
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2660
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2670
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2674
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2678
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2680
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2684
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2688
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2690
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2694
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2698
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2700
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2704
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2710
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2718
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2722
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2726
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2728
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2732
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2736
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2740
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2744
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2746
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2754
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2758
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2764
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2768
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2772
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2776
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2780
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2782
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2786
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2790
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2798
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2800
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2804
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2816
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2818
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2822
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2836
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2840
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2844
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2852
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2854
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2858
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2862
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2866
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2872
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2876
	.byte 0x03,0xa4,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2879
	.byte 0x03,0xde,0x00,0x01,0x00,0x05,0x02
	.uaword .L2881
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2885
	.byte 0x03,0xfd,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2888
	.byte 0x03,0x85,0x02,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_EvalCoord1f
	.byte 0x00,0x05,0x02
	.uaword .L2897
	.byte 0x06,0x03,0xb6,0x0f,0x01,0x00,0x05,0x02
	.uaword .L2901
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2902
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2903
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2910
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2914
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2915
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2916
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2925
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2929
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2930
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2931
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2932
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2938
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2944
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2948
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2949
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2950
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2951
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2952
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2954
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2955
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2961
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2962
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2968
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2972
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2973
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2974
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2980
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2981
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2988
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2992
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2993
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2994
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3001
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3005
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3006
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3007
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3008
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3015
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3019
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3020
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3021
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3022
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3023
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3030
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3035
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3036
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3037
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3038
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3039
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3045
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3046
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3048
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3058
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3059
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_EvalCoord2f
	.byte 0x00,0x05,0x02
	.uaword .L3068
	.byte 0x06,0x03,0xa5,0x10,0x01,0x00,0x05,0x02
	.uaword .L3072
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3073
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3074
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3077
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3081
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3082
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3084
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3099
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3109
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3113
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3115
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3118
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3122
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3123
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3125
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3140
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3144
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3152
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3156
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3157
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3159
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3160
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3166
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3172
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3177
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3178
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3179
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3180
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3181
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3183
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3184
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3190
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3191
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3197
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3206
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3210
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3211
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3212
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3213
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3219
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3220
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3221
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3230
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3234
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3235
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3237
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3244
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3248
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3249
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3250
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3251
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3252
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3259
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3263
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3264
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3265
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3266
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3267
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3268
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3275
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3279
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3280
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3281
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3282
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3283
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3285
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3291
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3292
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3293
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3304
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3305
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_MapGrid1f
	.byte 0x00,0x05,0x02
	.uaword .L3314
	.byte 0x06,0x03,0xae,0x11,0x01,0x00,0x05,0x02
	.uaword .L3318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3320
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3326
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3336
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3337
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3338
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3339
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_MapGrid2f
	.byte 0x00,0x05,0x02
	.uaword .L3348
	.byte 0x06,0x03,0xbf,0x11,0x01,0x00,0x05,0x02
	.uaword .L3352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3354
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3360
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3366
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3372
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3376
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3378
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3382
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3383
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3385
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3387
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3388
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_EvalPoint1
	.byte 0x00,0x05,0x02
	.uaword .L3397
	.byte 0x06,0x03,0xd8,0x11,0x01,0x00,0x05,0x02
	.uaword .L3401
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3408
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3412
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3418
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3419
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3425
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3426
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_EvalPoint2
	.byte 0x00,0x05,0x02
	.uaword .L3435
	.byte 0x06,0x03,0xed,0x11,0x01,0x00,0x05,0x02
	.uaword .L3439
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3446
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3450
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3456
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3465
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3469
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3476
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3480
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3486
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3487
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3493
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3494
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_EvalMesh1
	.byte 0x00,0x05,0x02
	.uaword .L3503
	.byte 0x06,0x03,0x90,0x12,0x01,0x00,0x05,0x02
	.uaword .L3507
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3509
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3516
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3520
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3521
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3524
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3526
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3528
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3531
	.byte 0x03,0x77,0x01,0x00,0x05,0x02
	.uaword .L3534
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L3535
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3537
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3546
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3550
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3557
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3561
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3567
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3573
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3576
	.byte 0x03,0x76,0x01,0x00,0x05,0x02
	.uaword .L3579
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L3580
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_EvalMesh2
	.byte 0x00,0x05,0x02
	.uaword .L3589
	.byte 0x06,0x03,0xbb,0x12,0x01,0x00,0x05,0x02
	.uaword .L3593
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3595
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3599
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3600
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3604
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L3608
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3610
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3619
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3643
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3652
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3675
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3678
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3683
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3686
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3687
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3690
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3699
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3722
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3724
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3733
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3756
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3759
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3762
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3765
	.byte 0x03,0x79,0x01,0x00,0x05,0x02
	.uaword .L3769
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L3778
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3803
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3835
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3838
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3841
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3844
	.byte 0x03,0x79,0x01,0x00,0x05,0x02
	.uaword .L3847
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L3850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3857
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3860
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3885
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3909
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3918
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3942
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3945
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L3948
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3951
	.byte 0x03,0x75,0x01,0x00,0x05,0x02
	.uaword .L3954
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L3956
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3958
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3961
	.byte 0x03,0x4f,0x01,0x00,0x05,0x02
	.uaword .L3964
	.byte 0x03,0x36,0x01,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x00,0x03,0x34,0x00,0x03,0x08,0x49,0x13
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a
	.byte 0x00,0x00,0x04,0x24,0x00,0x03,0x08,0x3e
	.byte 0x0b,0x0b,0x0b,0x00,0x00,0x05,0x2e,0x01
	.byte 0x03,0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x0b
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x06
	.byte 0x05,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x07,0x16
	.byte 0x00,0x49,0x13,0x03,0x08,0x3a,0x0b,0x00
	.byte 0x00,0x08,0x0f,0x00,0x49,0x13,0x00,0x00
	.byte 0x09,0x0b,0x01,0x11,0x01,0x12,0x01,0x00
	.byte 0x00,0x0a,0x2e,0x01,0x03,0x08,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12,0x01
	.byte 0x40,0x0a,0x27,0x0c,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x0b,0x05,0x00,0x49,0x13
	.byte 0x03,0x08,0x3a,0x0b,0x3b,0x05,0x02,0x0a
	.byte 0x00,0x00,0x0c,0x34,0x00,0x03,0x08,0x49
	.byte 0x13,0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x02
	.byte 0x0a,0x00,0x00,0x0d,0x2e,0x01,0x03,0x08
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x11,0x01
	.byte 0x12,0x01,0x40,0x0a,0x27,0x0c,0x49,0x13
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x0e
	.byte 0x04,0x01,0x0b,0x0b,0x3a,0x0b,0x01,0x13
	.byte 0x00,0x00,0x0f,0x28,0x00,0x03,0x08,0x1c
	.byte 0x0d,0x00,0x00,0x10,0x2e,0x01,0x03,0x08
	.byte 0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b,0x05
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x49,0x13,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x11,0x26,0x00,0x49,0x13,0x00,0x00
	.byte 0x12,0x2e,0x01,0x03,0x08,0x3f,0x0c,0x17
	.byte 0x0b,0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12
	.byte 0x01,0x40,0x0a,0x27,0x0c,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x13,0x13,0x00,0x03
	.byte 0x08,0x3c,0x0c,0x00,0x00,0x14,0x01,0x01
	.byte 0x49,0x13,0x0b,0x0b,0x01,0x13,0x00,0x00
	.byte 0x15,0x21,0x00,0x49,0x13,0x2f,0x0b,0x00
	.byte 0x00,0x16,0x13,0x01,0x03,0x08,0x0b,0x0b
	.byte 0x3a,0x0b,0x01,0x13,0x00,0x00,0x17,0x0d
	.byte 0x00,0x03,0x08,0x49,0x13,0x38,0x0a,0x00
	.byte 0x00,0x18,0x01,0x01,0x49,0x13,0x0b,0x05
	.byte 0x01,0x13,0x00,0x00,0x19,0x21,0x00,0x49
	.byte 0x13,0x2f,0x05,0x00,0x00,0x1a,0x13,0x01
	.byte 0x03,0x08,0x0b,0x05,0x3a,0x0b,0x01,0x13
	.byte 0x00,0x00,0x1b,0x15,0x01,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x1c,0x05
	.byte 0x00,0x49,0x13,0x00,0x00,0x1d,0x15,0x01
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x1e,0x15,0x00,0x27,0x0c
	.byte 0x49,0x13,0x88,0x44,0x0b,0x00,0x00,0x1f
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c
	.byte 0x27,0x0c,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x20,0x2e,0x01,0x03,0x08,0x3f,0x0c
	.byte 0x3c,0x0c,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x21,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c
	.byte 0x49,0x13,0x88,0x44,0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x01,0x78,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xad,0x48,0x00,0x00,0x00,0xff
	.byte 0x67,0x6c,0x5f,0x69,0x6e,0x69,0x74,0x5f
	.byte 0x65,0x76,0x61,0x6c,0x00,0x00,0x00,0x35
	.byte 0x27,0x67,0x6c,0x5f,0x63,0x6f,0x70,0x79
	.byte 0x5f,0x6d,0x61,0x70,0x5f,0x70,0x6f,0x69
	.byte 0x6e,0x74,0x73,0x31,0x66,0x00,0x00,0x00
	.byte 0x35,0xfc,0x67,0x6c,0x5f,0x63,0x6f,0x70
	.byte 0x79,0x5f,0x6d,0x61,0x70,0x5f,0x70,0x6f
	.byte 0x69,0x6e,0x74,0x73,0x31,0x64,0x00,0x00
	.byte 0x00,0x36,0xea,0x67,0x6c,0x5f,0x63,0x6f
	.byte 0x70,0x79,0x5f,0x6d,0x61,0x70,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x73,0x32,0x66,0x00
	.byte 0x00,0x00,0x38,0x29,0x67,0x6c,0x5f,0x63
	.byte 0x6f,0x70,0x79,0x5f,0x6d,0x61,0x70,0x5f
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x32,0x64
	.byte 0x00,0x00,0x00,0x39,0x68,0x67,0x6c,0x5f
	.byte 0x66,0x72,0x65,0x65,0x5f,0x63,0x6f,0x6e
	.byte 0x74,0x72,0x6f,0x6c,0x5f,0x70,0x6f,0x69
	.byte 0x6e,0x74,0x73,0x00,0x00,0x00,0x9d,0x7b
	.byte 0x67,0x6c,0x5f,0x4d,0x61,0x70,0x31,0x66
	.byte 0x00,0x00,0x00,0x9e,0x3f,0x67,0x6c,0x5f
	.byte 0x4d,0x61,0x70,0x32,0x66,0x00,0x00,0x00
	.byte 0x9f,0x4a,0x67,0x6c,0x5f,0x47,0x65,0x74
	.byte 0x4d,0x61,0x70,0x64,0x76,0x00,0x00,0x00
	.byte 0x9f,0xe2,0x67,0x6c,0x5f,0x47,0x65,0x74
	.byte 0x4d,0x61,0x70,0x66,0x76,0x00,0x00,0x00
	.byte 0xa0,0x75,0x67,0x6c,0x5f,0x47,0x65,0x74
	.byte 0x4d,0x61,0x70,0x69,0x76,0x00,0x00,0x00
	.byte 0xa1,0x0d,0x67,0x6c,0x5f,0x45,0x76,0x61
	.byte 0x6c,0x43,0x6f,0x6f,0x72,0x64,0x31,0x66
	.byte 0x00,0x00,0x00,0xa4,0x59,0x67,0x6c,0x5f
	.byte 0x45,0x76,0x61,0x6c,0x43,0x6f,0x6f,0x72
	.byte 0x64,0x32,0x66,0x00,0x00,0x00,0xa8,0xd7
	.byte 0x67,0x6c,0x5f,0x4d,0x61,0x70,0x47,0x72
	.byte 0x69,0x64,0x31,0x66,0x00,0x00,0x00,0xa9
	.byte 0x38,0x67,0x6c,0x5f,0x4d,0x61,0x70,0x47
	.byte 0x72,0x69,0x64,0x32,0x66,0x00,0x00,0x00
	.byte 0xa9,0xc6,0x67,0x6c,0x5f,0x45,0x76,0x61
	.byte 0x6c,0x50,0x6f,0x69,0x6e,0x74,0x31,0x00
	.byte 0x00,0x00,0xaa,0x26,0x67,0x6c,0x5f,0x45
	.byte 0x76,0x61,0x6c,0x50,0x6f,0x69,0x6e,0x74
	.byte 0x32,0x00,0x00,0x00,0xaa,0xb1,0x67,0x6c
	.byte 0x5f,0x45,0x76,0x61,0x6c,0x4d,0x65,0x73
	.byte 0x68,0x31,0x00,0x00,0x00,0xab,0x50,0x67
	.byte 0x6c,0x5f,0x45,0x76,0x61,0x6c,0x4d,0x65
	.byte 0x73,0x68,0x32,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0x64,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xad,0x48,0x00,0x00,0x01,0x41
	.byte 0x68,0x6f,0x72,0x6e,0x65,0x72,0x5f,0x62
	.byte 0x65,0x7a,0x69,0x65,0x72,0x5f,0x63,0x75
	.byte 0x72,0x76,0x65,0x00,0x00,0x00,0x02,0x36
	.byte 0x68,0x6f,0x72,0x6e,0x65,0x72,0x5f,0x62
	.byte 0x65,0x7a,0x69,0x65,0x72,0x5f,0x73,0x75
	.byte 0x72,0x66,0x00,0x00,0x00,0x03,0xe8,0x64
	.byte 0x65,0x5f,0x63,0x61,0x73,0x74,0x65,0x6c
	.byte 0x6a,0x61,0x75,0x5f,0x73,0x75,0x72,0x66
	.byte 0x00,0x00,0x00,0x05,0x3a,0x63,0x6f,0x6d
	.byte 0x70,0x6f,0x6e,0x65,0x6e,0x74,0x73,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x30,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xad,0x48,0x00,0x00,0x02,0x0a
	.byte 0x47,0x4c,0x66,0x6c,0x6f,0x61,0x74,0x00
	.byte 0x00,0x00,0x02,0x29,0x47,0x4c,0x75,0x69
	.byte 0x6e,0x74,0x00,0x00,0x00,0x05,0x72,0x47
	.byte 0x4c,0x69,0x6e,0x74,0x00,0x00,0x00,0x05
	.byte 0x7e,0x00,0x00,0x00,0x35,0x1a,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x36
	.byte 0xd1,0x47,0x4c,0x64,0x6f,0x75,0x62,0x6c
	.byte 0x65,0x00,0x00,0x00,0x3a,0x27,0x47,0x4c
	.byte 0x75,0x62,0x79,0x74,0x65,0x00,0x00,0x00
	.byte 0x3a,0x47,0x67,0x6c,0x5f,0x74,0x65,0x78
	.byte 0x74,0x75,0x72,0x65,0x5f,0x69,0x6d,0x61
	.byte 0x67,0x65,0x00,0x00,0x00,0x3b,0x79,0x47
	.byte 0x4c,0x62,0x6f,0x6f,0x6c,0x65,0x61,0x6e
	.byte 0x00,0x00,0x00,0x3d,0x8e,0x54,0x65,0x78
	.byte 0x74,0x75,0x72,0x65,0x53,0x61,0x6d,0x70
	.byte 0x6c,0x65,0x46,0x75,0x6e,0x63,0x00,0x00
	.byte 0x00,0x3b,0x89,0x67,0x6c,0x5f,0x74,0x65
	.byte 0x78,0x74,0x75,0x72,0x65,0x5f,0x6f,0x62
	.byte 0x6a,0x65,0x63,0x74,0x00,0x00,0x00,0x3d
	.byte 0xab,0x67,0x6c,0x5f,0x73,0x68,0x61,0x72
	.byte 0x65,0x64,0x5f,0x73,0x74,0x61,0x74,0x65
	.byte 0x00,0x00,0x00,0x45,0xcf,0x47,0x4c,0x76
	.byte 0x6f,0x69,0x64,0x00,0x00,0x00,0x45,0xe1
	.byte 0x67,0x6c,0x5f,0x69,0x6d,0x61,0x67,0x65
	.byte 0x00,0x00,0x00,0x5d,0xfa,0x67,0x6c,0x5f
	.byte 0x61,0x70,0x69,0x5f,0x74,0x61,0x62,0x6c
	.byte 0x65,0x00,0x00,0x00,0x6c,0x9e,0x67,0x6c
	.byte 0x5f,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x6e,0x46,0x47,0x4c,0x76,0x69
	.byte 0x73,0x75,0x61,0x6c,0x00,0x00,0x00,0x6e
	.byte 0x5a,0x47,0x4c,0x64,0x65,0x70,0x74,0x68
	.byte 0x00,0x00,0x00,0x6e,0x6d,0x47,0x4c,0x73
	.byte 0x74,0x65,0x6e,0x63,0x69,0x6c,0x00,0x00
	.byte 0x00,0x6e,0x8b,0x47,0x4c,0x61,0x63,0x63
	.byte 0x75,0x6d,0x00,0x00,0x00,0x6e,0x9e,0x67
	.byte 0x6c,0x5f,0x66,0x72,0x61,0x6d,0x65,0x5f
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x00,0x00
	.byte 0x00,0x6f,0x75,0x47,0x4c,0x66,0x72,0x61
	.byte 0x6d,0x65,0x62,0x75,0x66,0x66,0x65,0x72
	.byte 0x00,0x00,0x00,0x75,0xd3,0x70,0x6f,0x69
	.byte 0x6e,0x74,0x73,0x5f,0x66,0x75,0x6e,0x63
	.byte 0x00,0x00,0x00,0x76,0x06,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x66,0x75,0x6e,0x63,0x00,0x00
	.byte 0x00,0x76,0x3c,0x74,0x72,0x69,0x61,0x6e
	.byte 0x67,0x6c,0x65,0x5f,0x66,0x75,0x6e,0x63
	.byte 0x00,0x00,0x00,0x76,0x7b,0x71,0x75,0x61
	.byte 0x64,0x5f,0x66,0x75,0x6e,0x63,0x00,0x00
	.byte 0x00,0x76,0xb1,0x72,0x65,0x63,0x74,0x5f
	.byte 0x66,0x75,0x6e,0x63,0x00,0x00,0x00,0x78
	.byte 0x98,0x64,0x64,0x5f,0x66,0x75,0x6e,0x63
	.byte 0x74,0x69,0x6f,0x6e,0x5f,0x74,0x61,0x62
	.byte 0x6c,0x65,0x00,0x00,0x00,0x7d,0xd0,0x47
	.byte 0x4c,0x62,0x69,0x74,0x66,0x69,0x65,0x6c
	.byte 0x64,0x00,0x00,0x00,0x7d,0xe6,0x67,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x5f
	.byte 0x6e,0x6f,0x64,0x65,0x00,0x00,0x00,0x7e
	.byte 0x46,0x67,0x6c,0x5f,0x61,0x63,0x63,0x75
	.byte 0x6d,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7e,0x93,0x67,0x6c,0x5f
	.byte 0x63,0x6f,0x6c,0x6f,0x72,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x80,0xa8,0x67
	.byte 0x6c,0x5f,0x63,0x75,0x72,0x72,0x65,0x6e
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x81,0x92,0x67,0x6c,0x5f
	.byte 0x64,0x65,0x70,0x74,0x68,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x81,0xe5,0x67
	.byte 0x6c,0x5f,0x65,0x76,0x61,0x6c,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x84,0x5b,0x67,0x6c,0x5f,0x66,0x6f,0x67
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x84,0xd4,0x67,0x6c,0x5f,0x68
	.byte 0x69,0x6e,0x74,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x85,0xa7,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x00
	.byte 0x00,0x00,0x88,0x4e,0x67,0x6c,0x5f,0x6c
	.byte 0x69,0x67,0x68,0x74,0x6d,0x6f,0x64,0x65
	.byte 0x6c,0x00,0x00,0x00,0x88,0xef,0x67,0x6c
	.byte 0x5f,0x6d,0x61,0x74,0x65,0x72,0x69,0x61
	.byte 0x6c,0x00,0x00,0x00,0x89,0xdf,0x67,0x6c
	.byte 0x5f,0x6c,0x69,0x67,0x68,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x8b,0x00,0x47,0x4c,0x75,0x73,0x68,0x6f
	.byte 0x72,0x74,0x00,0x00,0x00,0x8b,0x0f,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x6e,0x65,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x8b,0x88,0x67,0x6c,0x5f,0x6c,0x69,0x73
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x8c,0x6e,0x67,0x6c,0x5f
	.byte 0x70,0x69,0x78,0x65,0x6c,0x5f,0x61,0x74
	.byte 0x74,0x72,0x69,0x62,0x00,0x00,0x00,0x8f
	.byte 0x3e,0x67,0x6c,0x5f,0x70,0x6f,0x69,0x6e
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x8f,0xb7,0x67,0x6c,0x5f
	.byte 0x70,0x6f,0x6c,0x79,0x67,0x6f,0x6e,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x90,0xfb,0x47,0x4c,0x73,0x69,0x7a
	.byte 0x65,0x69,0x00,0x00,0x00,0x91,0x09,0x67
	.byte 0x6c,0x5f,0x73,0x63,0x69,0x73,0x73,0x6f
	.byte 0x72,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x91,0x64,0x67,0x6c,0x5f
	.byte 0x73,0x74,0x65,0x6e,0x63,0x69,0x6c,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x92,0xbe,0x67,0x6c,0x5f,0x74,0x65
	.byte 0x78,0x74,0x75,0x72,0x65,0x5f,0x61,0x74
	.byte 0x74,0x72,0x69,0x62,0x00,0x00,0x00,0x95
	.byte 0x20,0x67,0x6c,0x5f,0x74,0x72,0x61,0x6e
	.byte 0x73,0x66,0x6f,0x72,0x6d,0x5f,0x61,0x74
	.byte 0x74,0x72,0x69,0x62,0x00,0x00,0x00,0x95
	.byte 0x9a,0x67,0x6c,0x5f,0x76,0x69,0x65,0x77
	.byte 0x70,0x6f,0x72,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x96,0x57
	.byte 0x67,0x6c,0x5f,0x61,0x72,0x72,0x61,0x79
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x99,0x02,0x67,0x6c,0x5f,0x70
	.byte 0x69,0x78,0x65,0x6c,0x73,0x74,0x6f,0x72
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x99,0xb1,0x67,0x6c,0x5f
	.byte 0x31,0x64,0x5f,0x6d,0x61,0x70,0x00,0x00
	.byte 0x00,0x9a,0x05,0x67,0x6c,0x5f,0x32,0x64
	.byte 0x5f,0x6d,0x61,0x70,0x00,0x00,0x00,0x9a
	.byte 0x7f,0x67,0x6c,0x5f,0x65,0x76,0x61,0x6c
	.byte 0x75,0x61,0x74,0x6f,0x72,0x73,0x00,0x00
	.byte 0x00,0x9c,0x09,0x67,0x6c,0x5f,0x66,0x65
	.byte 0x65,0x64,0x62,0x61,0x63,0x6b,0x00,0x00
	.byte 0x00,0x9c,0x7e,0x67,0x6c,0x5f,0x73,0x65
	.byte 0x6c,0x65,0x63,0x74,0x69,0x6f,0x6e,0x00
	.byte 0x00,0x00,0x3e,0x4c,0x67,0x6c,0x5f,0x63
	.byte 0x6f,0x6e,0x74,0x65,0x78,0x74,0x00,0x00
	.byte 0x00,0x9d,0x5c,0x47,0x4c,0x63,0x6f,0x6e
	.byte 0x74,0x65,0x78,0x74,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_varnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_varnames"
	.byte 0x00,0x00,0x00,0x1c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xad,0x48,0x00,0x00,0x01,0x21
	.byte 0x69,0x6e,0x69,0x74,0x5f,0x66,0x6c,0x61
	.byte 0x67,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
