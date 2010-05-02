
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	gl_LineWidth
	.type	gl_LineWidth,#function
gl_LineWidth:
	save	%sp,-96,%sp

	! block 1
.L13:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L14:
.L16:
.L18:

! File lines.c:
!    1	/* $Id: lines.c,v 1.18 1997/07/24 01:24:11 brianp Exp $ */
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
!   25	 * $Log: lines.c,v $
!   26	 * Revision 1.18  1997/07/24 01:24:11  brianp
!   27	 * changed precompiled header symbol from PCH to PC_HEADER
!   28	 *
!   29	 * Revision 1.17  1997/07/05 16:03:51  brianp
!   30	 * fixed PB overflow problem
!   31	 *
!   32	 * Revision 1.16  1997/06/20 02:01:49  brianp
!   33	 * changed color components from GLfixed to GLubyte
!   34	 *
!   35	 * Revision 1.15  1997/06/03 01:38:22  brianp
!   36	 * fixed divide by zero problem in feedback function (William Mitchell)
!   37	 *
!   38	 * Revision 1.14  1997/05/28 03:25:26  brianp
!   39	 * added precompiled header (PCH) support
!   40	 *
!   41	 * Revision 1.13  1997/05/03 00:51:02  brianp
!   42	 * removed calls to gl_texturing_enabled()
!   43	 *
!   44	 * Revision 1.12  1997/04/14 02:00:39  brianp
!   45	 * #include "texstate.h" instead of "texture.h"
!   46	 *
!   47	 * Revision 1.11  1997/04/12 12:25:01  brianp
!   48	 * replaced ctx->LineFunc with ctx->Driver.LineFunc, fixed PB->count bug
!   49	 *
!   50	 * Revision 1.10  1997/03/16 02:07:31  brianp
!   51	 * now use linetemp.h in line drawing functions
!   52	 *
!   53	 * Revision 1.9  1997/03/08 02:04:27  brianp
!   54	 * better implementation of feedback function
!   55	 *
!   56	 * Revision 1.8  1997/02/09 18:44:20  brianp
!   57	 * added GL_EXT_texture3D support
!   58	 *
!   59	 * Revision 1.7  1997/01/09 19:48:00  brianp
!   60	 * now call gl_texturing_enabled()
!   61	 *
!   62	 * Revision 1.6  1996/11/08 02:21:21  brianp
!   63	 * added null drawing function for GL_NO_RASTER
!   64	 *
!   65	 * Revision 1.5  1996/09/27 01:28:56  brianp
!   66	 * removed unused variables
!   67	 *
!   68	 * Revision 1.4  1996/09/25 02:01:54  brianp
!   69	 * new texture coord interpolation
!   70	 *
!   71	 * Revision 1.3  1996/09/15 14:18:10  brianp
!   72	 * now use GLframebuffer and GLvisual
!   73	 *
!   74	 * Revision 1.2  1996/09/15 01:48:58  brianp
!   75	 * removed #define NULL 0
!   76	 *
!   77	 * Revision 1.1  1996/09/13 01:38:16  brianp
!   78	 * Initial revision
!   79	 *
!   80	 */
!   81	
!   83	#ifdef PC_HEADER
!   84	#include "all.h"
!   85	#else
!   86	#include "context.h"
!   87	#include "depth.h"
!   88	#include "feedback.h"
!   89	#include "lines.h"
!   90	#include "dlist.h"
!   91	#include "macros.h"
!   92	#include "pb.h"
!   93	#include "texstate.h"
!   94	#include "types.h"
!   95	#include "vb.h"
!   96	#endif
!   97	
!  100	void gl_LineWidth( GLcontext *ctx, GLfloat width )
!  101	{
!  102	   if (width<=0.0) {

	ld	[%fp+72],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fcmped	%f6,%f4
	fbug	.L17
	nop

	! block 3
.L19:
.L20:
.L21:
.L22:

!  103	      gl_error( ctx, GL_INVALID_VALUE, "glLineWidth" );

	ld	[%fp+68],%l0
	sethi	%hi(.L23),%l1
	or	%l1,%lo(.L23),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L24:

!  104	      return;

	ba	.L12
	nop

	! block 5
.L25:
.L26:
.L17:
.L27:
.L28:
.L30:

!  105	   }
!  106	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L29
	nop

	! block 6
.L31:
.L32:
.L33:
.L34:

!  107	      gl_error( ctx, GL_INVALID_OPERATION, "glLineWidth" );

	ld	[%fp+68],%l0
	sethi	%hi(.L35),%l1
	or	%l1,%lo(.L35),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L36:

!  108	      return;

	ba	.L12
	nop

	! block 8
.L37:
.L38:
.L29:
.L39:
.L40:

!  109	   }
!  110	   ctx->Line.Width = width;

	ld	[%fp+72],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	st	%f4,[%l0+%l1]

	! block 9
.L41:

!  111	   ctx->NewState |= NEW_RASTER_OPS;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f4),%l1
	or	%l1,%lo(0xe0f4),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	or	%l0,2,%l0
	st	%l0,[%l1+0]

	! block 10
.L42:
.L43:
.L12:
	jmp	%i7+8
	restore
	.size	gl_LineWidth,(.-gl_LineWidth)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_LineStipple
	.type	gl_LineStipple,#function
gl_LineStipple:
	save	%sp,-104,%sp

	! block 1
.L46:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	sth	%i2,[%fp+78]

	! block 2
.L47:
.L49:
.L51:

! File lines.c:
!  112	}
!  113	
!  116	void gl_LineStipple( GLcontext *ctx, GLint factor, GLushort pattern )
!  117	{
!  118	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L50
	nop

	! block 3
.L52:
.L53:
.L54:
.L55:

!  119	      gl_error( ctx, GL_INVALID_OPERATION, "glLineStipple" );

	ld	[%fp+68],%l0
	sethi	%hi(.L56),%l1
	or	%l1,%lo(.L56),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L57:

!  120	      return;

	ba	.L45
	nop

	! block 5
.L58:
.L59:
.L50:
.L60:
.L61:

!  121	   }
!  122	   ctx->Line.StippleFactor = CLAMP( factor, 1, 256 );

	ld	[%fp+72],%l0
	cmp	%l0,1
	bge	.L62
	nop

	! block 6
.L63:
	mov	1,%l0
	ba	.L64
	st	%l0,[%fp-4]

	! block 7
.L62:
	ld	[%fp+72],%l0
	cmp	%l0,256
	ble	.L65
	nop

	! block 8
.L66:
	mov	256,%l0
	ba	.L67
	st	%l0,[%fp-8]

	! block 9
.L65:
	ld	[%fp+72],%l0
	st	%l0,[%fp-8]

	! block 10
.L67:
	ld	[%fp-8],%l0
	st	%l0,[%fp-4]

	! block 11
.L64:
	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	st	%l2,[%l0+%l1]

	! block 12
.L68:

!  123	   ctx->Line.StipplePattern = pattern;

	lduh	[%fp+78],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	sth	%l2,[%l0+%l1]

	! block 13
.L69:

!  124	   ctx->NewState |= NEW_RASTER_OPS;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f4),%l1
	or	%l1,%lo(0xe0f4),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	or	%l0,2,%l0
	st	%l0,[%l1+0]

	! block 14
.L70:
.L71:
.L45:
	jmp	%i7+8
	restore
	.size	gl_LineStipple,(.-gl_LineStipple)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	feedback_line,#function
feedback_line:
	save	%sp,-232,%sp

	! block 1
.L74:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L75:
.L77:

! File lines.c:
!  125	}
!  126	
!  129	/**********************************************************************/
!  130	/*****                    Rasterization                           *****/
!  131	/**********************************************************************/
!  132	
!  134	/*
!  135	 * There are 4 pairs (RGBA, CI) of line drawing functions:
!  136	 *   1. simple:  width=1 and no special rasterization functions (fastest)
!  137	 *   2. flat:  width=1, non-stippled, flat-shaded, any raster operations
!  138	 *   3. smooth:  width=1, non-stippled, smooth-shaded, any raster operations
!  139	 *   4. general:  any other kind of line (slowest)
!  140	 */
!  141	
!  143	/*
!  144	 * All line drawing functions have the same arguments:
!  145	 * v1, v2 - indexes of first and second endpoints into vertex buffer arrays
!  146	 * pv     - provoking vertex: which vertex color/index to use for flat shading.
!  147	 */
!  148	
!  151	static void feedback_line( GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv )
!  152	{
!  153	   struct vertex_buffer *VB = ctx->VB;

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L78:

!  154	   GLfloat x1, y1, z1, w1;
!  155	   GLfloat x2, y2, z2, w2;
!  156	   GLfloat tex1[4], tex2[4], invq;
!  157	   GLfloat invRedScale   = ctx->Visual->InvRedScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f4
	st	%f4,[%fp-76]

	! block 4
.L79:

!  158	   GLfloat invGreenScale = ctx->Visual->InvGreenScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f4
	st	%f4,[%fp-80]

	! block 5
.L80:

!  159	   GLfloat invBlueScale  = ctx->Visual->InvBlueScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f4
	st	%f4,[%fp-84]

	! block 6
.L81:

!  160	   GLfloat invAlphaScale = ctx->Visual->InvAlphaScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f4
	st	%f4,[%fp-88]

	! block 7
.L82:

!  162	   x1 = VB->Win[v1][0];

	ld	[%fp-4],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l1
	or	%l1,%lo(0x5e80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-8]

	! block 8
.L83:

!  163	   y1 = VB->Win[v1][1];

	ld	[%fp-4],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l1
	or	%l1,%lo(0x5e84),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-12]

	! block 9
.L84:

!  164	   z1 = VB->Win[v1][2] / DEPTH_SCALE;

	ld	[%fp-4],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-16]

	! block 10
.L85:

!  165	   w1 = VB->Clip[v1][3];

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l1
	or	%l1,%lo(0x3f0c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-20]

	! block 11
.L86:

!  167	   x2 = VB->Win[v2][0];

	ld	[%fp-4],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l1
	or	%l1,%lo(0x5e80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-24]

	! block 12
.L87:

!  168	   y2 = VB->Win[v2][1];

	ld	[%fp-4],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l1
	or	%l1,%lo(0x5e84),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-28]

	! block 13
.L88:

!  169	   z2 = VB->Win[v2][2] / DEPTH_SCALE;

	ld	[%fp-4],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-32]

	! block 14
.L89:

!  170	   w2 = VB->Clip[v2][3];

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l1
	or	%l1,%lo(0x3f0c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-36]

	! block 15
.L90:

!  172	   invq = (VB->TexCoord[v1][3]==0.0) ? 1.0 : (1.0F / VB->TexCoord[v1][3]);

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fcmpd	%f6,%f4
	fbne	.L91
	nop

	! block 16
.L92:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L93
	std	%f4,[%fp-96]

	! block 17
.L91:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	fdivs	%f5,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%fp-96]

	! block 18
.L93:
	ldd	[%fp-96],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 19
.L94:

!  173	   tex1[0] = VB->TexCoord[v1][0] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l1
	or	%l1,%lo(0xaf40),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-52]

	! block 20
.L95:

!  174	   tex1[1] = VB->TexCoord[v1][1] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l1
	or	%l1,%lo(0xaf44),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-48]

	! block 21
.L96:

!  175	   tex1[2] = VB->TexCoord[v1][2] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l1
	or	%l1,%lo(0xaf48),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-44]

	! block 22
.L97:

!  176	   tex1[3] = VB->TexCoord[v1][3];

	ld	[%fp-4],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-40]

	! block 23
.L98:

!  177	   invq = (VB->TexCoord[v2][3]==0.0) ? 1.0 : (1.0F / VB->TexCoord[v2][3]);

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ldd	[%l0+%lo(.L_cseg0)],%f4
	fcmpd	%f6,%f4
	fbne	.L99
	nop

	! block 24
.L100:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L101
	std	%f4,[%fp-104]

	! block 25
.L99:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	fdivs	%f5,%f4,%f4
	fstod	%f4,%f4
	std	%f4,[%fp-104]

	! block 26
.L101:
	ldd	[%fp-104],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 27
.L102:

!  178	   tex2[0] = VB->TexCoord[v2][0] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l1
	or	%l1,%lo(0xaf40),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-68]

	! block 28
.L103:

!  179	   tex2[1] = VB->TexCoord[v2][1] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l1
	or	%l1,%lo(0xaf44),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-64]

	! block 29
.L104:

!  180	   tex2[2] = VB->TexCoord[v2][2] * invq;

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l1
	or	%l1,%lo(0xaf48),%l1
	ld	[%l0+%l1],%f5
	ld	[%fp-72],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-60]

	! block 30
.L105:

!  181	   tex2[3] = VB->TexCoord[v2][3];

	ld	[%fp-4],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l1
	or	%l1,%lo(0xaf4c),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-56]

	! block 31
.L106:
.L108:

!  183	   if (ctx->StippleCounter==0) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,0
	bne	.L107
	nop

	! block 32
.L109:
.L110:
.L111:
.L112:
.L114:

!  184	      FEEDBACK_TOKEN( ctx, (GLfloat) GL_LINE_RESET_TOKEN );

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bgeu	.L113
	nop

	! block 33
.L115:
.L116:
.L117:
	sethi	%hi(.L_cseg4),%l0
	ld	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfc0),%l1
	or	%l1,%lo(0xdfc0),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 34
.L118:
.L119:
.L113:
.L120:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 35
.L121:
.L122:
	ba	.L123
	nop

	! block 36
.L107:
.L124:
.L125:
.L126:
.L128:

!  185	   }
!  186	   else {
!  187	      FEEDBACK_TOKEN( ctx, (GLfloat) GL_LINE_TOKEN );

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l0
	cmp	%l2,%l0
	bgeu	.L127
	nop

	! block 37
.L129:
.L130:
.L131:
	sethi	%hi(.L_cseg5),%l0
	ld	[%l0+%lo(.L_cseg5)],%f4
	ld	[%fp+68],%l0
	sethi	%hi(0xdfc0),%l1
	or	%l1,%lo(0xdfc0),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	ld	[%l0+%l1],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 38
.L132:
.L133:
.L127:
.L134:
	ld	[%fp+68],%l0
	sethi	%hi(0xdfc8),%l1
	or	%l1,%lo(0xdfc8),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 39
.L135:
.L136:
.L123:
.L137:
.L138:
.L139:

!  188	   }
!  189	
!  190	   {
!  191	      GLfloat color[4];
!  192	      /* convert color from integer to a float in [0,1] */
!  193	      color[0] = (GLfloat) VB->Color[pv][0] * invRedScale;

	ld	[%fp-4],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-76],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-120]

	! block 40
.L140:

!  194	      color[1] = (GLfloat) VB->Color[pv][1] * invGreenScale;

	ld	[%fp-4],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-80],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 41
.L141:

!  195	      color[2] = (GLfloat) VB->Color[pv][2] * invBlueScale;

	ld	[%fp-4],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-84],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-112]

	! block 42
.L142:

!  196	      color[3] = (GLfloat) VB->Color[pv][3] * invAlphaScale;

	ld	[%fp-4],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp-88],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 43
.L143:

!  197	      gl_feedback_vertex( ctx, x1,y1,z1,w1, color,
!  198	                          (GLfloat) VB->Index[pv], tex1 );

	ld	[%fp+68],%l3
	ld	[%fp-8],%f8
	ld	[%fp-12],%f9
	ld	[%fp-16],%f10
	ld	[%fp-20],%f11
	add	%fp,-120,%l5
	ld	[%fp-4],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	add	%fp,-52,%l0
	mov	%l3,%o0
	st	%f8,[%sp+72]
	ld	[%sp+72],%o1
	st	%f9,[%sp+76]
	ld	[%sp+76],%o2
	st	%f10,[%sp+80]
	ld	[%sp+80],%o3
	st	%f11,[%sp+84]
	ld	[%sp+84],%o4
	mov	%l5,%o5
	st	%f4,[%sp+92]
	call	gl_feedback_vertex
	st	%l0,[%sp+96]

	! block 44
.L144:

!  199	      gl_feedback_vertex( ctx, x2,y2,z2,w2, color,
!  200	                          (GLfloat) VB->Index[pv], tex2 );

	ld	[%fp+68],%l3
	ld	[%fp-24],%f8
	ld	[%fp-28],%f9
	ld	[%fp-32],%f10
	ld	[%fp-36],%f11
	add	%fp,-120,%l5
	ld	[%fp-4],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	add	%fp,-68,%l0
	mov	%l3,%o0
	st	%f8,[%sp+72]
	ld	[%sp+72],%o1
	st	%f9,[%sp+76]
	ld	[%sp+76],%o2
	st	%f10,[%sp+80]
	ld	[%sp+80],%o3
	st	%f11,[%sp+84]
	ld	[%sp+84],%o4
	mov	%l5,%o5
	st	%f4,[%sp+92]
	call	gl_feedback_vertex
	st	%l0,[%sp+96]

	! block 45
.L145:
.L146:

!  201	   }
!  202	
!  203	   ctx->StippleCounter++;

	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 46
.L147:
.L148:
.L73:
	jmp	%i7+8
	restore
	.size	feedback_line,(.-feedback_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	select_line,#function
select_line:
	save	%sp,-96,%sp

	! block 1
.L151:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L152:
.L154:

! File lines.c:
!  204	}
!  205	
!  208	static void select_line( GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv )
!  209	{
!  210	   gl_update_hitflag( ctx, ctx->VB->Win[v1][2] / DEPTH_SCALE );

	ld	[%fp+68],%l4
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l4+%l1],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fdivs	%f5,%f4,%f4
	mov	%l4,%o0
	st	%f4,[%sp+72]
	call	gl_update_hitflag
	ld	[%sp+72],%o1

	! block 3
.L155:

!  211	   gl_update_hitflag( ctx, ctx->VB->Win[v2][2] / DEPTH_SCALE );

	ld	[%fp+68],%l4
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l4+%l1],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fdivs	%f5,%f4,%f4
	mov	%l4,%o0
	st	%f4,[%sp+72]
	call	gl_update_hitflag
	ld	[%sp+72],%o1

	! block 4
.L156:
.L157:
.L150:
	jmp	%i7+8
	restore
	.size	select_line,(.-select_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	flat_ci_line,#function
flat_ci_line:
	save	%sp,-168,%sp

	! block 1
.L160:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L161:
.L163:

! File lines.c:
!  212	}
!  213	
!  216	#if MAX_WIDTH > MAX_HEIGHT
!  217	#  define MAXPOINTS MAX_WIDTH
!  218	#else
!  219	#  define MAXPOINTS MAX_HEIGHT
!  220	#endif
!  221	
!  223	/* Flat, color index line */
!  224	static void flat_ci_line( GLcontext *ctx,
!  225	                          GLuint vert0, GLuint vert1, GLuint pvert )
!  226	{
!  227	   GLint count;
!  228	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L164:

!  229	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L165:
.L167:

!  230	   PB_SET_INDEX( ctx, ctx->PB, ctx->VB->Index[pvert] );

	ld	[%fp+68],%l2
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	ld	[%l0+%l1],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	cmp	%l3,%l0
	bne	.L168
	nop

	! block 5
.L169:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L166
	nop

	! block 6
.L170:
.L168:
.L171:
.L172:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 7
.L173:
.L174:
.L166:
.L175:
	ld	[%fp+68],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l3+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l5
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l3+%l2],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	st	%l5,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 8
.L176:

!  231	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 9
.L177:
.L178:

! File linetemp.h:
!    1	/* $Id: linetemp.h,v 1.3 1997/06/20 02:49:53 brianp Exp $ */
!    2	
!    3	/*
!    4	 * Mesa 3-D graphics library
!    5	 * Version:  2.3
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
!   25	 * $Log: linetemp.h,v $
!   26	 * Revision 1.3  1997/06/20 02:49:53  brianp
!   27	 * changed color components from GLfixed to GLubyte
!   28	 *
!   29	 * Revision 1.2  1997/05/16 01:54:54  brianp
!   30	 * zPtrYstep calculation was negated!
!   31	 *
!   32	 * Revision 1.1  1997/03/16 02:07:56  brianp
!   33	 * Initial revision
!   34	 *
!   35	 */
!   36	
!   38	/*
!   39	 * Line Rasterizer Template
!   40	 *
!   41	 * This file is #include'd to generate custom line rasterizers.
!   42	 *
!   43	 * The following macros may be defined to indicate what auxillary information
!   44	 * must be interplated along the line:
!   45	 *    INTERP_Z      - if defined, interpolate Z values
!   46	 *    INTERP_RGB    - if defined, interpolate RGB values
!   47	 *    INTERP_ALPHA  - if defined, interpolate Alpha values
!   48	 *    INTERP_INDEX  - if defined, interpolate color index values
!   49	 *    INTERP_ST     - if defined, interpolate integer ST texcoords
!   50	 *                         (fast, simple 2-D texture mapping)
!   51	 *    INTERP_STW    - if defined, interpolate float ST texcoords and W
!   52	 *                         (2-D texture maps with perspective correction)
!   53	 *    INTERP_UV     - if defined, interpolate float UV texcoords too
!   54	 *                         (for 3-D, 4-D? texture maps)
!   55	 *
!   56	 * When one can directly address pixels in the color buffer the following
!   57	 * macros can be defined and used to directly compute pixel addresses during
!   58	 * rasterization (see pixelPtr):
!   59	 *    PIXEL_TYPE          - the datatype of a pixel (GLubyte, GLushort, GLuint)
!   60	 *    BYTES_PER_ROW       - number of bytes per row in the color buffer
!   61	 *    PIXEL_ADDRESS(X,Y)  - returns the address of pixel at (X,Y) where
!   62	 *                          Y==0 at bottom of screen and increases upward.
!   63	 *
!   64	 * Optionally, one may provide one-time setup code
!   65	 *    SETUP_CODE    - code which is to be executed once per line
!   66	 *
!   67	 * To enable line stippling define STIPPLE = 1
!   68	 * To enable wide lines define WIDE = 1
!   69	 * 
!   70	 * To actually "plot" each pixel either the PLOT macro or
!   71	 * (XMAJOR_PLOT and YMAJOR_PLOT macros) must be defined...
!   72	 *    PLOT(X,Y) - code to plot a pixel.  Example:
!   73	 *                if (Z < *zPtr) {
!   74	 *                   *zPtr = Z;
!   75	 *                   color = pack_rgb( FixedToInt(r0), FixedToInt(g0),
!   76	 *                                     FixedToInt(b0) );
!   77	 *                   put_pixel( X, Y, color );
!   78	 *                }
!   79	 *
!   80	 * This code was designed for the origin to be in the lower-left corner.
!   81	 *
!   82	 */
!   83	
!   85	/*void line( GLcontext *ctx, GLuint vert0, GLuint vert1, GLuint pvert )*/
!   86	{
!   87	   struct vertex_buffer *VB = ctx->VB;

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-16]

	! block 10
.L179:

!   88	/*
!   89	   GLint x0 = (GLint) VB->Win[vert0][0], dx = (GLint) VB->Win[vert1][0] - x0;
!   90	   GLint y0 = (GLint) VB->Win[vert0][1], dy = (GLint) VB->Win[vert1][1] - y0;
!   91	*/
!   92	   GLint x0 = (GLint) VB->Win[vert0][0], x1 = (GLint) VB->Win[vert1][0];

	ld	[%fp-16],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-68]
	ld	[%fp-68],%l0
	st	%l0,[%fp-20]
	ld	[%fp-16],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-68]
	ld	[%fp-68],%l0
	st	%l0,[%fp-24]

	! block 11
.L180:

!   93	   GLint y0 = (GLint) VB->Win[vert0][1], y1 = (GLint) VB->Win[vert1][1];

	ld	[%fp-16],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-68]
	ld	[%fp-68],%l0
	st	%l0,[%fp-28]
	ld	[%fp-16],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-68]
	ld	[%fp-68],%l0
	st	%l0,[%fp-32]

	! block 12
.L181:

!   94	   GLint dx, dy;
!   95	#if INTERP_XY
!   96	   GLint xstep, ystep;
!   97	#endif
!   98	#if INTERP_Z
!   99	   GLint z0, z1, dz, zPtrXstep, zPtrYstep;
!  100	   GLdepth *zPtr;
!  101	#endif
!  102	#if INTERP_RGB
!  103	   GLfixed r0 = IntToFixed(VB->Color[vert0][0]);
!  104	   GLfixed dr = IntToFixed(VB->Color[vert1][0]) - r0;
!  105	   GLfixed g0 = IntToFixed(VB->Color[vert0][1]);
!  106	   GLfixed dg = IntToFixed(VB->Color[vert1][1]) - g0;
!  107	   GLfixed b0 = IntToFixed(VB->Color[vert0][2]);
!  108	   GLfixed db = IntToFixed(VB->Color[vert1][2]) - b0;
!  109	#endif
!  110	#if INTERP_ALPHA
!  111	   GLfixed a0 = IntToFixed(VB->Color[vert0][3]);
!  112	   GLfixed da = IntToFixed(VB->Color[vert1][3]) - a0;
!  113	#endif
!  114	#if INTERP_INDEX
!  115	   GLint i0 = VB->Index[vert0] << 8,  di = (GLint) (VB->Index[vert1] << 8)-i0;
!  116	#endif
!  117	#if INTERP_ST
!  118	   GLfixed s0 = FloatToFixed(VB->TexCoord[vert0][0] * S_SCALE);
!  119	   GLfixed ds = FloatToFixed(VB->TexCoord[vert1][0] * S_SCALE) - s0;
!  120	   GLfixed t0 = FloatToFixed(VB->TexCoord[vert0][1] * T_SCALE);
!  121	   GLfixed dt = FloatToFixed(VB->TexCoord[vert1][1] * T_SCALE) - t0;
!  122	#endif
!  123	#if INTERP_STW
!  124	   GLfloat s0 = VB->TexCoord[vert0][0], ds = VB->TexCoord[vert1][0] - s0;
!  125	   GLfloat t0 = VB->TexCoord[vert0][1], dt = VB->TexCoord[vert1][1] - t0;
!  126	   GLfloat w0 = 1.0F / VB->Clip[vert0][3], dw = 1.0F / VB->Clip[vert1][3] - w0;
!  127	#endif
!  128	#if INTERP_UV
!  129	   GLfloat u0 = VB->TexCoord[vert0][2], du = VB->TexCoord[vert1][2] - u0;
!  130	   GLfloat v0 = VB->TexCoord[vert0][3], dv = VB->TexCoord[vert1][3] - v0;
!  131	#endif
!  132	#ifdef PIXEL_ADDRESS
!  133	   PIXEL_TYPE *pixelPtr;
!  134	   GLint pixelXstep, pixelYstep;
!  135	#endif
!  136	
!  137	#if WIDE
!  138	   GLint width, min, max;
!  139	   width = (GLint) CLAMP( ctx->Line.Width, MIN_LINE_WIDTH, MAX_LINE_WIDTH );
!  140	   min = -width / 2;
!  141	   max = min + width - 1;
!  142	#endif
!  143	
!  144	/*
!  145	 * Despite being clipped to the view volume, the line's window coordinates
!  146	 * may just lie outside the window bounds.  That is, if the legal window
!  147	 * coordinates are [0,W-1][0,H-1], it's possible for x==W and/or y==H.
!  148	 * This quick and dirty code nudges the endpoints inside the window if
!  149	 * necessary.
!  150	 */
!  151	#if CLIP_HACK
!  152	   {
!  153	      GLint w = ctx->Buffer->Width;
!  154	      GLint h = ctx->Buffer->Height;
!  155	      if ((x0==w) | (x1==w)) {
!  156	         if ((x0==w) & (x1==w))
!  157	           return;
!  158	         x0 -= x0==w;
!  159	         x1 -= x1==w;
!  160	      }
!  161	      if ((y0==h) | (y1==h)) {
!  162	         if ((y0==h) & (y1==h))
!  163	           return;
!  164	         y0 -= y0==h;
!  165	         y1 -= y1==h;
!  166	      }
!  167	   }
!  168	#endif
!  169	   dx = x1 - x0;

	ld	[%fp-24],%l0
	ld	[%fp-20],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 13
.L182:

!  170	   dy = y1 - y0;

	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 14
.L183:
.L185:

!  171	   if (dx==0 && dy==0) {

	ld	[%fp-36],%l0
	cmp	%l0,0
	bne	.L184
	nop

	! block 15
.L186:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L184
	nop

	! block 16
.L187:
.L188:
.L189:
.L190:

!  172	      return;

	ba	.L159
	nop

	! block 17
.L191:
.L192:
.L184:
.L193:
.L194:
.L196:

!  173	   }
!  174	
!  175	   /*
!  176	    * Setup
!  177	    */
!  178	#ifdef SETUP_CODE
!  179	   SETUP_CODE
!  180	#endif
!  181	
!  182	#if INTERP_Z
!  183	   zPtr = Z_ADDRESS(ctx,x0,y0);
!  184	#  if DEPTH_BITS==16
!  185	      z0 = FloatToFixed(VB->Win[vert0][2]);
!  186	      z1 = FloatToFixed(VB->Win[vert1][2]);
!  187	#  else
!  188	      z0 = (int) VB->Win[vert0][2];
!  189	      z1 = (int) VB->Win[vert1][2];
!  190	#  endif
!  191	#endif
!  192	#ifdef PIXEL_ADDRESS
!  193	   pixelPtr = (PIXEL_TYPE *) PIXEL_ADDRESS(x0,y0);
!  194	#endif
!  195	
!  196	   if (dx<0) {

	ld	[%fp-36],%l0
	cmp	%l0,0
	bge	.L195
	nop

	! block 18
.L197:
.L198:
.L199:
.L200:

!  197	      dx = -dx;   /* make positive */

	ld	[%fp-36],%l0
	neg	%l0,%l0
	st	%l0,[%fp-36]

	! block 19
.L201:

!  198	#if INTERP_XY
!  199	      xstep = -1;

	mov	-1,%l0
	st	%l0,[%fp-44]

	! block 20
.L202:
.L203:
	ba	.L204
	nop

	! block 21
.L195:
.L205:
.L206:
.L207:

!  200	#endif
!  201	#ifdef INTERP_Z
!  202	      zPtrXstep = -sizeof(GLdepth);
!  203	#endif
!  204	#ifdef PIXEL_ADDRESS
!  205	      pixelXstep = -sizeof(PIXEL_TYPE);
!  206	#endif
!  207	   }
!  208	   else {
!  209	#if INTERP_XY
!  210	      xstep = 1;

	mov	1,%l0
	st	%l0,[%fp-44]

	! block 22
.L208:
.L209:
.L204:
.L210:
.L211:
.L213:

!  211	#endif
!  212	#if INTERP_Z
!  213	      zPtrXstep = sizeof(GLdepth);
!  214	#endif
!  215	#ifdef PIXEL_ADDRESS
!  216	      pixelXstep = sizeof(PIXEL_TYPE);
!  217	#endif
!  218	   }
!  219	
!  220	   if (dy<0) {

	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L212
	nop

	! block 23
.L214:
.L215:
.L216:
.L217:

!  221	      dy = -dy;   /* make positive */

	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 24
.L218:

!  222	#if INTERP_XY
!  223	      ystep = -1;

	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 25
.L219:
.L220:
	ba	.L221
	nop

	! block 26
.L212:
.L222:
.L223:
.L224:

!  224	#endif
!  225	#if INTERP_Z
!  226	      zPtrYstep = -ctx->Buffer->Width * sizeof(GLdepth);
!  227	#endif
!  228	#ifdef PIXEL_ADDRESS
!  229	      pixelYstep = BYTES_PER_ROW;
!  230	#endif
!  231	   }
!  232	   else {
!  233	#if INTERP_XY
!  234	      ystep = 1;

	mov	1,%l0
	st	%l0,[%fp-48]

	! block 27
.L225:
.L226:
.L221:
.L227:
.L228:
.L230:

!  235	#endif
!  236	#if INTERP_Z
!  237	      zPtrYstep = ctx->Buffer->Width * sizeof(GLdepth);
!  238	#endif
!  239	#ifdef PIXEL_ADDRESS
!  240	      pixelYstep = -(BYTES_PER_ROW);
!  241	#endif
!  242	   }
!  243	
!  244	   /*
!  245	    * Draw
!  246	    */
!  247	
!  248	   if (dx>dy) {

	ld	[%fp-36],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	ble	.L229
	nop

	! block 28
.L231:
.L232:
.L233:
.L234:

!  249	      /*
!  250	       * X-major line
!  251	       */
!  252	      GLint i;
!  253	      GLint errorInc = dy+dy;

	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-56]

	! block 29
.L235:

!  254	      GLint error = errorInc-dx;

	ld	[%fp-56],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 30
.L236:

!  255	      GLint errorDec = error-dx;

	ld	[%fp-60],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 31
.L237:
.L238:

!  256	#if INTERP_Z
!  257	      dz = (z1-z0) / dx;
!  258	#endif
!  259	#if INTERP_RGB
!  260	      dr /= dx;   /* convert from whole line delta to per-pixel delta */
!  261	      dg /= dx;
!  262	      db /= dx;
!  263	#endif
!  264	#if INTERP_ALPHA
!  265	      da /= dx;
!  266	#endif
!  267	#if INTERP_INDEX
!  268	      di /= dx;
!  269	#endif
!  270	#if INTERP_ST
!  271	      ds /= dx;
!  272	      dt /= dx;
!  273	#endif
!  274	#if INTERP_STW
!  275	      {
!  276	         GLfloat fdxinv = 1.0F / (GLfloat) dx;
!  277	         ds *= fdxinv;
!  278	         dt *= fdxinv;
!  279	         dw *= fdxinv;
!  280	#if INTERP_UV
!  281	         du *= fdxinv;
!  282	         dv *= fdxinv;
!  283	#endif
!  284	      }
!  285	#endif
!  286	      for (i=0;i<dx;i++) {

	ld	[%fp-36],%l0
	cmp	%g0,%l0
	bge	.L241
	st	%g0,[%fp-52]

	! block 32
.L242:
.L239:
.L243:
.L244:
.L245:

!  287	#if STIPPLE
!  288	         GLushort m;
!  289	         m = 1 << ((ctx->StippleCounter/ctx->Line.StippleFactor) & 0xf);
!  290	         if (ctx->Line.StipplePattern & m) {
!  291	#endif
!  292	#if INTERP_Z
!  293	#  if DEPTH_BITS==16
!  294	            GLdepth Z = FixedToInt(z0);
!  295	#  else
!  296	            GLdepth Z = z0;
!  297	#  endif
!  298	#endif
!  299	#if INTERP_INDEX
!  300	            GLint I = i0 >> 8;
!  301	#endif
!  302	#if WIDE
!  303	            GLint yy;
!  304	            GLint ymin = y0 + min;
!  305	            GLint ymax = y0 + max;
!  306	            for (yy=ymin;yy<=ymax;yy++) {
!  307	               PLOT( x0, yy );
!  308	            }
!  309	#else
!  310	#  ifdef XMAJOR_PLOT
!  311	            XMAJOR_PLOT( x0, y0 );
!  312	#  else
!  313	            PLOT( x0, y0 );

	ld	[%fp-20],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 33
.L246:

!  314	#  endif
!  315	#endif /*WIDE*/
!  316	#if STIPPLE
!  317	        }
!  318		ctx->StippleCounter++;
!  319	#endif
!  320	#if INTERP_XY
!  321	         x0 += xstep;

	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 34
.L247:
.L249:

!  322	#endif
!  323	#if INTERP_Z
!  324	         zPtr = (GLdepth *) ((GLubyte*) zPtr + zPtrXstep);
!  325	         z0 += dz;
!  326	#endif
!  327	#if INTERP_RGB
!  328	         r0 += dr;
!  329	         g0 += dg;
!  330	         b0 += db;
!  331	#endif
!  332	#if INTERP_ALPHA
!  333	         a0 += da;
!  334	#endif
!  335	#if INTERP_INDEX
!  336	         i0 += di;
!  337	#endif
!  338	#if INTERP_ST
!  339	         s0 += ds;
!  340	         t0 += dt;
!  341	#endif
!  342	#if INTERP_STW
!  343	         s0 += ds;
!  344	         t0 += dt;
!  345	         w0 += dw;
!  346	#endif
!  347	#if INTERP_UV
!  348	         u0 += du;
!  349	         v0 += dv;
!  350	#endif
!  351	#ifdef PIXEL_ADDRESS
!  352	         pixelPtr = (PIXEL_TYPE*) ((GLubyte*) pixelPtr + pixelXstep);
!  353	#endif
!  354	         if (error<0) {

	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L248
	nop

	! block 35
.L250:
.L251:
.L252:
.L253:

!  355	            error += errorInc;

	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 36
.L254:
.L255:
	ba	.L256
	nop

	! block 37
.L248:
.L257:
.L258:
.L259:

!  356	         }
!  357	         else {
!  358	            error += errorDec;

	ld	[%fp-60],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 38
.L260:

!  359	#if INTERP_XY
!  360	            y0 += ystep;

	ld	[%fp-28],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 39
.L261:
.L262:
.L256:
.L263:
.L264:
.L265:
.L266:
	ld	[%fp-52],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-52]
	ld	[%fp-52],%l1
	ld	[%fp-36],%l0
	cmp	%l1,%l0
	bl	.L239
	nop

	! block 40
.L267:
.L241:
.L268:
.L269:
.L270:
	ba	.L271
	nop

	! block 41
.L229:
.L272:
.L273:
.L274:

!  361	#endif
!  362	#if INTERP_Z
!  363	            zPtr = (GLdepth *) ((GLubyte*) zPtr + zPtrYstep);
!  364	#endif
!  365	#ifdef PIXEL_ADDRESS
!  366	            pixelPtr = (PIXEL_TYPE*) ((GLubyte*) pixelPtr + pixelYstep);
!  367	#endif
!  368	         }
!  369	      }
!  370	   }
!  371	   else {
!  372	      /*
!  373	       * Y-major line
!  374	       */
!  375	      GLint i;
!  376	      GLint errorInc = dx+dx;

	ld	[%fp-36],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-56]

	! block 42
.L275:

!  377	      GLint error = errorInc-dy;

	ld	[%fp-56],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 43
.L276:

!  378	      GLint errorDec = error-dy;

	ld	[%fp-60],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 44
.L277:
.L278:

!  379	#if INTERP_Z
!  380	      dz = (z1-z0) / dy;
!  381	#endif
!  382	#if INTERP_RGB
!  383	      dr /= dy;   /* convert from whole line delta to per-pixel delta */
!  384	      dg /= dy;
!  385	      db /= dy;
!  386	#endif
!  387	#if INTERP_ALPHA
!  388	      da /= dy;
!  389	#endif
!  390	#if INTERP_INDEX
!  391	      di /= dy;
!  392	#endif
!  393	#if INTERP_ST
!  394	      ds /= dy;
!  395	      dt /= dy;
!  396	#endif
!  397	#if INTERP_STW
!  398	      {
!  399	         GLfloat fdyinv = 1.0F / (GLfloat) dy;
!  400	         ds *= fdyinv;
!  401	         dt *= fdyinv;
!  402	         dw *= fdyinv;
!  403	#if INTERP_UV
!  404	         du *= fdyinv;
!  405	         dv *= fdyinv;
!  406	#endif
!  407	      }
!  408	#endif
!  409	      for (i=0;i<dy;i++) {

	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L281
	st	%g0,[%fp-52]

	! block 45
.L282:
.L279:
.L283:
.L284:
.L285:

!  410	#if STIPPLE
!  411	         GLushort m;
!  412	         m = 1 << ((ctx->StippleCounter/ctx->Line.StippleFactor) & 0xf);
!  413	         if (ctx->Line.StipplePattern & m) {
!  414	#endif
!  415	#if INTERP_Z
!  416	#  if DEPTH_BITS==16
!  417	            GLdepth Z = FixedToInt(z0);
!  418	#  else
!  419	            GLdepth Z = z0;
!  420	#  endif
!  421	#endif
!  422	#if INTERP_INDEX
!  423	            GLint I = i0 >> 8;
!  424	#endif
!  425	#if WIDE
!  426	            GLint xx;
!  427	            GLint xmin = x0 + min;
!  428	            GLint xmax = x0 + max;
!  429	            for (xx=xmin;xx<=xmax;xx++) {
!  430	               PLOT( xx, y0 );
!  431	            }
!  432	#else
!  433	#  ifdef YMAJOR_PLOT
!  434	            YMAJOR_PLOT( x0, y0 );
!  435	#  else
!  436	            PLOT( x0, y0 );

	ld	[%fp-20],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 46
.L286:

!  437	#  endif
!  438	#endif /*WIDE*/
!  439	#if STIPPLE
!  440	        }
!  441		ctx->StippleCounter++;
!  442	#endif
!  443	#if INTERP_XY
!  444	         y0 += ystep;

	ld	[%fp-28],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 47
.L287:
.L289:

!  445	#endif
!  446	#if INTERP_Z
!  447	         zPtr = (GLdepth *) ((GLubyte*) zPtr + zPtrYstep);
!  448	         z0 += dz;
!  449	#endif
!  450	#if INTERP_RGB
!  451	         r0 += dr;
!  452	         g0 += dg;
!  453	         b0 += db;
!  454	#endif
!  455	#if INTERP_ALPHA
!  456	         a0 += da;
!  457	#endif
!  458	#if INTERP_INDEX
!  459	         i0 += di;
!  460	#endif
!  461	#if INTERP_ST
!  462	         s0 += ds;
!  463	         t0 += dt;
!  464	#endif
!  465	#if INTERP_STW
!  466	         s0 += ds;
!  467	         t0 += dt;
!  468	         w0 += dw;
!  469	#endif
!  470	#if INTERP_UV
!  471	         u0 += du;
!  472	         v0 += dv;
!  473	#endif
!  474	#ifdef PIXEL_ADDRESS
!  475	         pixelPtr = (PIXEL_TYPE*) ((GLubyte*) pixelPtr + pixelYstep);
!  476	#endif
!  477	         if (error<0) {

	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L288
	nop

	! block 48
.L290:
.L291:
.L292:
.L293:

!  478	            error += errorInc;

	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 49
.L294:
.L295:
	ba	.L296
	nop

	! block 50
.L288:
.L297:
.L298:
.L299:

!  479	         }
!  480	         else {
!  481	            error += errorDec;

	ld	[%fp-60],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 51
.L300:

!  482	#if INTERP_XY
!  483	            x0 += xstep;

	ld	[%fp-20],%l0
	ld	[%fp-44],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 52
.L301:
.L302:
.L296:
.L303:
.L304:
.L305:
.L306:
	ld	[%fp-52],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-52]
	ld	[%fp-52],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L279
	nop

	! block 53
.L307:
.L281:
.L308:
.L309:
.L310:
.L271:
.L311:
.L312:
.L313:

! File lines.c:
!  233	#define INTERP_XY 1
!  234	
!  235	#define PLOT(X,Y)		\
!  236		pbx[count] = X;		\
!  237		pby[count] = Y;		\
!  238		count++;
!  239	
!  240	#include "linetemp.h"
!  241	
!  242	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 54
.L314:
.L316:

!  243	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L315
	nop

	! block 55
.L317:
.L318:
.L319:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 56
.L320:
.L321:
.L315:
.L322:

	! block 57
.L323:
.L324:
.L159:
	jmp	%i7+8
	restore
	.size	flat_ci_line,(.-flat_ci_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	flat_ci_z_line,#function
flat_ci_z_line:
	save	%sp,-200,%sp

	! block 1
.L327:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L328:
.L330:

! File lines.c:
!  244	}
!  245	
!  248	/* Flat, color index line with Z interpolation/testing */
!  249	static void flat_ci_z_line( GLcontext *ctx,
!  250	                            GLuint vert0, GLuint vert1, GLuint pvert )
!  251	{
!  252	   GLint count;
!  253	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L331:

!  254	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L332:

!  255	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L333:
.L335:

!  256	   PB_SET_INDEX( ctx, ctx->PB, ctx->VB->Index[pvert] );

	ld	[%fp+68],%l2
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	ld	[%l0+%l1],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	cmp	%l3,%l0
	bne	.L336
	nop

	! block 6
.L337:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L334
	nop

	! block 7
.L338:
.L336:
.L339:
.L340:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 8
.L341:
.L342:
.L334:
.L343:
	ld	[%fp+68],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l3+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l5
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l3+%l2],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	st	%l5,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 9
.L344:

!  257	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 10
.L345:
.L346:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 11
.L347:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-28]

	! block 12
.L348:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-36]

	! block 13
.L349:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 14
.L350:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 15
.L351:
.L353:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L352
	nop

	! block 16
.L354:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L352
	nop

	! block 17
.L355:
.L356:
.L357:
.L358:
	ba	.L326
	nop

	! block 18
.L359:
.L360:
.L352:
.L361:
.L362:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-32],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-24],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-76]

	! block 19
.L363:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-56]

	! block 20
.L364:
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-100]
	ld	[%fp-100],%l0
	st	%l0,[%fp-60]

	! block 21
.L365:
.L367:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L366
	nop

	! block 22
.L368:
.L369:
.L370:
.L371:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 23
.L372:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 24
.L373:
	mov	-2,%l0
	st	%l0,[%fp-68]

	! block 25
.L374:
.L375:
	ba	.L376
	nop

	! block 26
.L366:
.L377:
.L378:
.L379:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 27
.L380:
	mov	2,%l0
	st	%l0,[%fp-68]

	! block 28
.L381:
.L382:
.L376:
.L383:
.L384:
.L386:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L385
	nop

	! block 29
.L387:
.L388:
.L389:
.L390:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 30
.L391:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 31
.L392:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 32
.L393:
.L394:
	ba	.L395
	nop

	! block 33
.L385:
.L396:
.L397:
.L398:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 34
.L399:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 35
.L400:
.L401:
.L395:
.L402:
.L403:
.L405:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L404
	nop

	! block 36
.L406:
.L407:
.L408:
.L409:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-84]

	! block 37
.L410:
	ld	[%fp-84],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 38
.L411:
	ld	[%fp-88],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 39
.L412:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-40],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 40
.L413:
.L414:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L417
	st	%g0,[%fp-80]

	! block 41
.L418:
.L415:
.L419:
.L420:
.L421:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-94]

	! block 42
.L422:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 43
.L423:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 44
.L424:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 45
.L425:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 46
.L426:
.L428:
	ld	[%fp-88],%l0
	cmp	%l0,0
	bge	.L427
	nop

	! block 47
.L429:
.L430:
.L431:
.L432:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 48
.L433:
.L434:
	ba	.L435
	nop

	! block 49
.L427:
.L436:
.L437:
.L438:
	ld	[%fp-88],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 50
.L439:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 51
.L440:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 52
.L441:
.L442:
.L435:
.L443:
.L444:
.L445:
.L446:
	ld	[%fp-80],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-80]
	ld	[%fp-80],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L415
	nop

	! block 53
.L447:
.L417:
.L448:
.L449:
.L450:
	ba	.L451
	nop

	! block 54
.L404:
.L452:
.L453:
.L454:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-84]

	! block 55
.L455:
	ld	[%fp-84],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 56
.L456:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 57
.L457:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 58
.L458:
.L459:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L462
	st	%g0,[%fp-80]

	! block 59
.L463:
.L460:
.L464:
.L465:
.L466:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-94]

	! block 60
.L467:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 61
.L468:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 62
.L469:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 63
.L470:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 64
.L471:
.L473:
	ld	[%fp-88],%l0
	cmp	%l0,0
	bge	.L472
	nop

	! block 65
.L474:
.L475:
.L476:
.L477:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 66
.L478:
.L479:
	ba	.L480
	nop

	! block 67
.L472:
.L481:
.L482:
.L483:
	ld	[%fp-88],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 68
.L484:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 69
.L485:

!  484	#endif
!  485	#if INTERP_Z
!  486	            zPtr = (GLdepth *) ((GLubyte*) zPtr + zPtrXstep);

	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 70
.L486:
.L487:
.L480:
.L488:
.L489:
.L490:
.L491:
	ld	[%fp-80],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-80]
	ld	[%fp-80],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L460
	nop

	! block 71
.L492:
.L462:
.L493:
.L494:
.L495:
.L451:
.L496:
.L497:
.L498:

! File lines.c:
!  259	#define INTERP_XY 1
!  260	#define INTERP_Z 1
!  261	
!  262	#define PLOT(X,Y)		\
!  263		pbx[count] = X;		\
!  264		pby[count] = Y;		\
!  265		pbz[count] = Z;		\
!  266		count++;
!  267	
!  268	#include "linetemp.h"
!  269	
!  270	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 72
.L499:
.L501:

!  271	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L500
	nop

	! block 73
.L502:
.L503:
.L504:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 74
.L505:
.L506:
.L500:
.L507:

	! block 75
.L508:
.L509:
.L326:
	jmp	%i7+8
	restore
	.size	flat_ci_z_line,(.-flat_ci_z_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	flat_rgba_line,#function
flat_rgba_line:
	save	%sp,-168,%sp

	! block 1
.L512:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L513:
.L515:

! File lines.c:
!  272	}
!  273	
!  276	/* Flat-shaded, RGBA line */
!  277	static void flat_rgba_line( GLcontext *ctx,
!  278	                            GLuint vert0, GLuint vert1, GLuint pvert )
!  279	{
!  280	   GLint count;
!  281	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L516:

!  282	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L517:

!  283	   GLubyte *color = ctx->VB->Color[pvert];

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L518:
.L520:

!  284	   PB_SET_COLOR( ctx, ctx->PB, color[0], color[1], color[2], color[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-16],%l0
	ldub	[%l0+0],%l0
	cmp	%l1,%l0
	bne	.L521
	nop

	! block 6
.L522:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-16],%l0
	ldub	[%l0+1],%l0
	cmp	%l1,%l0
	bne	.L521
	nop

	! block 7
.L523:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-16],%l0
	ldub	[%l0+2],%l0
	cmp	%l1,%l0
	bne	.L521
	nop

	! block 8
.L524:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-16],%l0
	ldub	[%l0+3],%l0
	cmp	%l1,%l0
	bne	.L521
	nop

	! block 9
.L525:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L519
	nop

	! block 10
.L526:
.L521:
.L527:
.L528:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 11
.L529:
.L530:
.L519:
.L531:
	ld	[%fp-16],%l0
	ldub	[%l0+0],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-16],%l0
	ldub	[%l0+1],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-16],%l0
	ldub	[%l0+2],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-16],%l0
	ldub	[%l0+3],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	st	%l3,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 12
.L532:

!  285	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 13
.L533:
.L534:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 14
.L535:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-72]
	ld	[%fp-72],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-72]
	ld	[%fp-72],%l0
	st	%l0,[%fp-28]

	! block 15
.L536:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-72]
	ld	[%fp-72],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-72]
	ld	[%fp-72],%l0
	st	%l0,[%fp-36]

	! block 16
.L537:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 17
.L538:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 18
.L539:
.L541:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L540
	nop

	! block 19
.L542:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L540
	nop

	! block 20
.L543:
.L544:
.L545:
.L546:
	ba	.L511
	nop

	! block 21
.L547:
.L548:
.L540:
.L549:
.L550:
.L552:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L551
	nop

	! block 22
.L553:
.L554:
.L555:
.L556:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 23
.L557:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 24
.L558:
.L559:
	ba	.L560
	nop

	! block 25
.L551:
.L561:
.L562:
.L563:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 26
.L564:
.L565:
.L560:
.L566:
.L567:
.L569:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L568
	nop

	! block 27
.L570:
.L571:
.L572:
.L573:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 28
.L574:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 29
.L575:
.L576:
	ba	.L577
	nop

	! block 30
.L568:
.L578:
.L579:
.L580:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 31
.L581:
.L582:
.L577:
.L583:
.L584:
.L586:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L585
	nop

	! block 32
.L587:
.L588:
.L589:
.L590:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-60]

	! block 33
.L591:
	ld	[%fp-60],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 34
.L592:
	ld	[%fp-64],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 35
.L593:
.L594:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L597
	st	%g0,[%fp-56]

	! block 36
.L598:
.L595:
.L599:
.L600:
.L601:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 37
.L602:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 38
.L603:
.L605:
	ld	[%fp-64],%l0
	cmp	%l0,0
	bge	.L604
	nop

	! block 39
.L606:
.L607:
.L608:
.L609:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 40
.L610:
.L611:
	ba	.L612
	nop

	! block 41
.L604:
.L613:
.L614:
.L615:
	ld	[%fp-64],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 42
.L616:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 43
.L617:
.L618:
.L612:
.L619:
.L620:
.L621:
.L622:
	ld	[%fp-56],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-56]
	ld	[%fp-56],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L595
	nop

	! block 44
.L623:
.L597:
.L624:
.L625:
.L626:
	ba	.L627
	nop

	! block 45
.L585:
.L628:
.L629:
.L630:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-60]

	! block 46
.L631:
	ld	[%fp-60],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 47
.L632:
	ld	[%fp-64],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 48
.L633:
.L634:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L637
	st	%g0,[%fp-56]

	! block 49
.L638:
.L635:
.L639:
.L640:
.L641:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 50
.L642:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 51
.L643:
.L645:
	ld	[%fp-64],%l0
	cmp	%l0,0
	bge	.L644
	nop

	! block 52
.L646:
.L647:
.L648:
.L649:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 53
.L650:
.L651:
	ba	.L652
	nop

	! block 54
.L644:
.L653:
.L654:
.L655:
	ld	[%fp-64],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-64]

	! block 55
.L656:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 56
.L657:
.L658:
.L652:
.L659:
.L660:
.L661:
.L662:
	ld	[%fp-56],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-56]
	ld	[%fp-56],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L635
	nop

	! block 57
.L663:
.L637:
.L664:
.L665:
.L666:
.L627:
.L667:
.L668:
.L669:

! File lines.c:
!  287	#define INTERP_XY 1
!  288	
!  289	#define PLOT(X,Y)		\
!  290		pbx[count] = X;		\
!  291		pby[count] = Y;		\
!  292		count++;
!  293	
!  294	#include "linetemp.h"
!  295	
!  296	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 58
.L670:
.L672:

!  297	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L671
	nop

	! block 59
.L673:
.L674:
.L675:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 60
.L676:
.L677:
.L671:
.L678:

	! block 61
.L679:
.L680:
.L511:
	jmp	%i7+8
	restore
	.size	flat_rgba_line,(.-flat_rgba_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	flat_rgba_z_line,#function
flat_rgba_z_line:
	save	%sp,-200,%sp

	! block 1
.L683:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L684:
.L686:

! File lines.c:
!  298	}
!  299	
!  302	/* Flat-shaded, RGBA line with Z interpolation/testing */
!  303	static void flat_rgba_z_line( GLcontext *ctx,
!  304	                              GLuint vert0, GLuint vert1, GLuint pvert )
!  305	{
!  306	   GLint count;
!  307	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L687:

!  308	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L688:

!  309	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L689:

!  310	   GLubyte *color = ctx->VB->Color[pvert];

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 6
.L690:
.L692:

!  311	   PB_SET_COLOR( ctx, ctx->PB, color[0], color[1], color[2], color[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+0],%l0
	cmp	%l1,%l0
	bne	.L693
	nop

	! block 7
.L694:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+1],%l0
	cmp	%l1,%l0
	bne	.L693
	nop

	! block 8
.L695:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+2],%l0
	cmp	%l1,%l0
	bne	.L693
	nop

	! block 9
.L696:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+3],%l0
	cmp	%l1,%l0
	bne	.L693
	nop

	! block 10
.L697:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L691
	nop

	! block 11
.L698:
.L693:
.L699:
.L700:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 12
.L701:
.L702:
.L691:
.L703:
	ld	[%fp-20],%l0
	ldub	[%l0+0],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+1],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+2],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+3],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	st	%l3,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 13
.L704:

!  312	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 14
.L705:
.L706:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 15
.L707:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-32]

	! block 16
.L708:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-40]

	! block 17
.L709:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 18
.L710:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 19
.L711:
.L713:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L712
	nop

	! block 20
.L714:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L712
	nop

	! block 21
.L715:
.L716:
.L717:
.L718:
	ba	.L682
	nop

	! block 22
.L719:
.L720:
.L712:
.L721:
.L722:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 23
.L723:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-60]

	! block 24
.L724:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-104]
	ld	[%fp-104],%l0
	st	%l0,[%fp-64]

	! block 25
.L725:
.L727:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L726
	nop

	! block 26
.L728:
.L729:
.L730:
.L731:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 27
.L732:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 28
.L733:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 29
.L734:
.L735:
	ba	.L736
	nop

	! block 30
.L726:
.L737:
.L738:
.L739:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 31
.L740:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 32
.L741:
.L742:
.L736:
.L743:
.L744:
.L746:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L745
	nop

	! block 33
.L747:
.L748:
.L749:
.L750:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 34
.L751:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 35
.L752:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 36
.L753:
.L754:
	ba	.L755
	nop

	! block 37
.L745:
.L756:
.L757:
.L758:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 38
.L759:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 39
.L760:
.L761:
.L755:
.L762:
.L763:
.L765:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L764
	nop

	! block 40
.L766:
.L767:
.L768:
.L769:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-88]

	! block 41
.L770:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 42
.L771:
	ld	[%fp-92],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 43
.L772:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 44
.L773:
.L774:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L777
	st	%g0,[%fp-84]

	! block 45
.L778:
.L775:
.L779:
.L780:
.L781:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-98]

	! block 46
.L782:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 47
.L783:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 48
.L784:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 49
.L785:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 50
.L786:
.L788:
	ld	[%fp-92],%l0
	cmp	%l0,0
	bge	.L787
	nop

	! block 51
.L789:
.L790:
.L791:
.L792:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 52
.L793:
.L794:
	ba	.L795
	nop

	! block 53
.L787:
.L796:
.L797:
.L798:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 54
.L799:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 55
.L800:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 56
.L801:
.L802:
.L795:
.L803:
.L804:
.L805:
.L806:
	ld	[%fp-84],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L775
	nop

	! block 57
.L807:
.L777:
.L808:
.L809:
.L810:
	ba	.L811
	nop

	! block 58
.L764:
.L812:
.L813:
.L814:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-88]

	! block 59
.L815:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 60
.L816:
	ld	[%fp-92],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 61
.L817:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 62
.L818:
.L819:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L822
	st	%g0,[%fp-84]

	! block 63
.L823:
.L820:
.L824:
.L825:
.L826:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-98]

	! block 64
.L827:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 65
.L828:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 66
.L829:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 67
.L830:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 68
.L831:
.L833:
	ld	[%fp-92],%l0
	cmp	%l0,0
	bge	.L832
	nop

	! block 69
.L834:
.L835:
.L836:
.L837:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 70
.L838:
.L839:
	ba	.L840
	nop

	! block 71
.L832:
.L841:
.L842:
.L843:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 72
.L844:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 73
.L845:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 74
.L846:
.L847:
.L840:
.L848:
.L849:
.L850:
.L851:
	ld	[%fp-84],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L820
	nop

	! block 75
.L852:
.L822:
.L853:
.L854:
.L855:
.L811:
.L856:
.L857:
.L858:

! File lines.c:
!  314	#define INTERP_XY 1
!  315	#define INTERP_Z 1
!  316	
!  317	#define PLOT(X,Y)	\
!  318		pbx[count] = X;	\
!  319		pby[count] = Y;	\
!  320		pbz[count] = Z;	\
!  321		count++;
!  322	
!  323	#include "linetemp.h"
!  324	
!  325	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 76
.L859:
.L861:

!  326	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L860
	nop

	! block 77
.L862:
.L863:
.L864:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 78
.L865:
.L866:
.L860:
.L867:

	! block 79
.L868:
.L869:
.L682:
	jmp	%i7+8
	restore
	.size	flat_rgba_z_line,(.-flat_rgba_z_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	smooth_ci_line,#function
smooth_ci_line:
	save	%sp,-184,%sp

	! block 1
.L872:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L873:
.L875:

! File lines.c:
!  327	}
!  328	
!  331	/* Smooth shaded, color index line */
!  332	static void smooth_ci_line( GLcontext *ctx,
!  333	                            GLuint vert0, GLuint vert1, GLuint pvert )
!  334	{
!  335	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L876:

!  336	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L877:

!  337	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L878:

!  338	   GLuint *pbi = ctx->PB->i;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x10680),%l1
	or	%l1,%lo(0x10680),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L879:
.L880:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 7
.L881:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-84]
	ld	[%fp-84],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-84]
	ld	[%fp-84],%l0
	st	%l0,[%fp-28]

	! block 8
.L882:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-84]
	ld	[%fp-84],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-84]
	ld	[%fp-84],%l0
	st	%l0,[%fp-36]

	! block 9
.L883:
	ld	[%fp-20],%l0
	sethi	%hi(0xad44),%l3
	or	%l3,%lo(0xad44),%l3
	ld	[%l0+%l3],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	st	%l0,[%fp-56]
	ld	[%fp-20],%l0
	ld	[%l0+%l3],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 10
.L884:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 11
.L885:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 12
.L886:
.L888:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L887
	nop

	! block 13
.L889:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L887
	nop

	! block 14
.L890:
.L891:
.L892:
.L893:
	ba	.L871
	nop

	! block 15
.L894:
.L895:
.L887:
.L896:
.L897:
.L899:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L898
	nop

	! block 16
.L900:
.L901:
.L902:
.L903:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 17
.L904:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 18
.L905:
.L906:
	ba	.L907
	nop

	! block 19
.L898:
.L908:
.L909:
.L910:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 20
.L911:
.L912:
.L907:
.L913:
.L914:
.L916:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L915
	nop

	! block 21
.L917:
.L918:
.L919:
.L920:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 22
.L921:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 23
.L922:
.L923:
	ba	.L924
	nop

	! block 24
.L915:
.L925:
.L926:
.L927:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 25
.L928:
.L929:
.L924:
.L930:
.L931:
.L933:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L932
	nop

	! block 26
.L934:
.L935:
.L936:
.L937:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-68]

	! block 27
.L938:
	ld	[%fp-68],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 28
.L939:
	ld	[%fp-72],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 29
.L940:
	ld	[%fp-60],%l0
	ld	[%fp-40],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-60]

	! block 30
.L941:
.L942:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L945
	st	%g0,[%fp-64]

	! block 31
.L946:
.L943:
.L947:
.L948:
.L949:
	ld	[%fp-56],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-80]

	! block 32
.L950:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-80],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 33
.L951:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 34
.L952:
	ld	[%fp-56],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 35
.L953:
.L955:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bge	.L954
	nop

	! block 36
.L956:
.L957:
.L958:
.L959:
	ld	[%fp-72],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 37
.L960:
.L961:
	ba	.L962
	nop

	! block 38
.L954:
.L963:
.L964:
.L965:
	ld	[%fp-72],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 39
.L966:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 40
.L967:
.L968:
.L962:
.L969:
.L970:
.L971:
.L972:
	ld	[%fp-64],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-64]
	ld	[%fp-64],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L943
	nop

	! block 41
.L973:
.L945:
.L974:
.L975:
.L976:
	ba	.L977
	nop

	! block 42
.L932:
.L978:
.L979:
.L980:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-68]

	! block 43
.L981:
	ld	[%fp-68],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 44
.L982:
	ld	[%fp-72],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 45
.L983:
	ld	[%fp-60],%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-60]

	! block 46
.L984:
.L985:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L988
	st	%g0,[%fp-64]

	! block 47
.L989:
.L986:
.L990:
.L991:
.L992:
	ld	[%fp-56],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-80]

	! block 48
.L993:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-80],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 49
.L994:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 50
.L995:
	ld	[%fp-56],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 51
.L996:
.L998:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bge	.L997
	nop

	! block 52
.L999:
.L1000:
.L1001:
.L1002:
	ld	[%fp-72],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 53
.L1003:
.L1004:
	ba	.L1005
	nop

	! block 54
.L997:
.L1006:
.L1007:
.L1008:
	ld	[%fp-72],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 55
.L1009:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 56
.L1010:
.L1011:
.L1005:
.L1012:
.L1013:
.L1014:
.L1015:
	ld	[%fp-64],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-64]
	ld	[%fp-64],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L986
	nop

	! block 57
.L1016:
.L988:
.L1017:
.L1018:
.L1019:
.L977:
.L1020:
.L1021:
.L1022:

! File lines.c:
!  340	#define INTERP_XY 1
!  341	#define INTERP_INDEX 1
!  342	
!  343	#define PLOT(X,Y)		\
!  344		pbx[count] = X;		\
!  345		pby[count] = Y;		\
!  346		pbi[count] = I;		\
!  347		count++;
!  348	
!  349	#include "linetemp.h"
!  350	
!  351	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 58
.L1023:
.L1025:

!  352	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L1024
	nop

	! block 59
.L1026:
.L1027:
.L1028:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 60
.L1029:
.L1030:
.L1024:
.L1031:

	! block 61
.L1032:
.L1033:
.L871:
	jmp	%i7+8
	restore
	.size	smooth_ci_line,(.-smooth_ci_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	smooth_ci_z_line,#function
smooth_ci_z_line:
	save	%sp,-216,%sp

	! block 1
.L1036:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L1037:
.L1039:

! File lines.c:
!  353	}
!  354	
!  357	/* Smooth shaded, color index line with Z interpolation/testing */
!  358	static void smooth_ci_z_line( GLcontext *ctx,
!  359	                              GLuint vert0, GLuint vert1, GLuint pvert )
!  360	{
!  361	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L1040:

!  362	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L1041:

!  363	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L1042:

!  364	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L1043:

!  365	   GLuint *pbi = ctx->PB->i;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x10680),%l1
	or	%l1,%lo(0x10680),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L1044:
.L1045:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 8
.L1046:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-32]

	! block 9
.L1047:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-40]

	! block 10
.L1048:
	ld	[%fp-24],%l0
	sethi	%hi(0xad44),%l3
	or	%l3,%lo(0xad44),%l3
	ld	[%l0+%l3],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	st	%l0,[%fp-84]
	ld	[%fp-24],%l0
	ld	[%l0+%l3],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 11
.L1049:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 12
.L1050:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 13
.L1051:
.L1053:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L1052
	nop

	! block 14
.L1054:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L1052
	nop

	! block 15
.L1055:
.L1056:
.L1057:
.L1058:
	ba	.L1035
	nop

	! block 16
.L1059:
.L1060:
.L1052:
.L1061:
.L1062:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 17
.L1063:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-60]

	! block 18
.L1064:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-64]

	! block 19
.L1065:
.L1067:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L1066
	nop

	! block 20
.L1068:
.L1069:
.L1070:
.L1071:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 21
.L1072:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 22
.L1073:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 23
.L1074:
.L1075:
	ba	.L1076
	nop

	! block 24
.L1066:
.L1077:
.L1078:
.L1079:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 25
.L1080:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 26
.L1081:
.L1082:
.L1076:
.L1083:
.L1084:
.L1086:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L1085
	nop

	! block 27
.L1087:
.L1088:
.L1089:
.L1090:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 28
.L1091:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 29
.L1092:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 30
.L1093:
.L1094:
	ba	.L1095
	nop

	! block 31
.L1085:
.L1096:
.L1097:
.L1098:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 32
.L1099:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 33
.L1100:
.L1101:
.L1095:
.L1102:
.L1103:
.L1105:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L1104
	nop

	! block 34
.L1106:
.L1107:
.L1108:
.L1109:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-96]

	! block 35
.L1110:
	ld	[%fp-96],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 36
.L1111:
	ld	[%fp-100],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 37
.L1112:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 38
.L1113:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 39
.L1114:
.L1115:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L1118
	st	%g0,[%fp-92]

	! block 40
.L1119:
.L1116:
.L1120:
.L1121:
.L1122:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-106]

	! block 41
.L1123:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-112]

	! block 42
.L1124:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 43
.L1125:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 44
.L1126:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 45
.L1127:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 46
.L1128:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 47
.L1129:
.L1131:
	ld	[%fp-100],%l0
	cmp	%l0,0
	bge	.L1130
	nop

	! block 48
.L1132:
.L1133:
.L1134:
.L1135:
	ld	[%fp-100],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 49
.L1136:
.L1137:
	ba	.L1138
	nop

	! block 50
.L1130:
.L1139:
.L1140:
.L1141:
	ld	[%fp-100],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 51
.L1142:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 52
.L1143:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 53
.L1144:
.L1145:
.L1138:
.L1146:
.L1147:
.L1148:
.L1149:
	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L1116
	nop

	! block 54
.L1150:
.L1118:
.L1151:
.L1152:
.L1153:
	ba	.L1154
	nop

	! block 55
.L1104:
.L1155:
.L1156:
.L1157:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-96]

	! block 56
.L1158:
	ld	[%fp-96],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 57
.L1159:
	ld	[%fp-100],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 58
.L1160:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 59
.L1161:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 60
.L1162:
.L1163:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L1166
	st	%g0,[%fp-92]

	! block 61
.L1167:
.L1164:
.L1168:
.L1169:
.L1170:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-106]

	! block 62
.L1171:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-112]

	! block 63
.L1172:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 64
.L1173:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 65
.L1174:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 66
.L1175:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 67
.L1176:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 68
.L1177:
.L1179:
	ld	[%fp-100],%l0
	cmp	%l0,0
	bge	.L1178
	nop

	! block 69
.L1180:
.L1181:
.L1182:
.L1183:
	ld	[%fp-100],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 70
.L1184:
.L1185:
	ba	.L1186
	nop

	! block 71
.L1178:
.L1187:
.L1188:
.L1189:
	ld	[%fp-100],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 72
.L1190:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 73
.L1191:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 74
.L1192:
.L1193:
.L1186:
.L1194:
.L1195:
.L1196:
.L1197:
	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L1164
	nop

	! block 75
.L1198:
.L1166:
.L1199:
.L1200:
.L1201:
.L1154:
.L1202:
.L1203:
.L1204:

! File lines.c:
!  367	#define INTERP_XY 1
!  368	#define INTERP_Z 1
!  369	#define INTERP_INDEX 1
!  370	
!  371	#define PLOT(X,Y)		\
!  372		pbx[count] = X;		\
!  373		pby[count] = Y;		\
!  374		pbz[count] = Z;		\
!  375		pbi[count] = I;		\
!  376		count++;
!  377	
!  378	#include "linetemp.h"
!  379	
!  380	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 76
.L1205:
.L1207:

!  381	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L1206
	nop

	! block 77
.L1208:
.L1209:
.L1210:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 78
.L1211:
.L1212:
.L1206:
.L1213:

	! block 79
.L1214:
.L1215:
.L1035:
	jmp	%i7+8
	restore
	.size	smooth_ci_z_line,(.-smooth_ci_z_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	smooth_rgba_line,#function
smooth_rgba_line:
	save	%sp,-216,%sp

	! block 1
.L1218:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L1219:
.L1221:

! File lines.c:
!  382	}
!  383	
!  386	/* Smooth-shaded, RGBA line */
!  387	static void smooth_rgba_line( GLcontext *ctx,
!  388	                       	      GLuint vert0, GLuint vert1, GLuint pvert )
!  389	{
!  390	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L1222:

!  391	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L1223:

!  392	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L1224:

!  393	   GLubyte *pbr = ctx->PB->r;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xbb80),%l1
	or	%l1,%lo(0xbb80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L1225:

!  394	   GLubyte *pbg = ctx->PB->g;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xce40),%l1
	or	%l1,%lo(0xce40),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L1226:

!  395	   GLubyte *pbb = ctx->PB->b;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 8
.L1227:

!  396	   GLubyte *pba = ctx->PB->a;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xf3c0),%l1
	or	%l1,%lo(0xf3c0),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 9
.L1228:
.L1229:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-32]

	! block 10
.L1230:
	ld	[%fp-32],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-36]
	ld	[%fp-32],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-40]

	! block 11
.L1231:
	ld	[%fp-32],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-44]
	ld	[%fp-32],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	st	%l0,[%fp-48]

	! block 12
.L1232:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-68]

	! block 13
.L1233:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-68],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 14
.L1234:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-76]

	! block 15
.L1235:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-76],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 16
.L1236:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-84]

	! block 17
.L1237:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 18
.L1238:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-92]

	! block 19
.L1239:
	ld	[%fp-32],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-92],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 20
.L1240:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-52]

	! block 21
.L1241:
	ld	[%fp-48],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 22
.L1242:
.L1244:
	ld	[%fp-52],%l0
	cmp	%l0,0
	bne	.L1243
	nop

	! block 23
.L1245:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L1243
	nop

	! block 24
.L1246:
.L1247:
.L1248:
.L1249:
	ba	.L1217
	nop

	! block 25
.L1250:
.L1251:
.L1243:
.L1252:
.L1253:
.L1255:
	ld	[%fp-52],%l0
	cmp	%l0,0
	bge	.L1254
	nop

	! block 26
.L1256:
.L1257:
.L1258:
.L1259:
	ld	[%fp-52],%l0
	neg	%l0,%l0
	st	%l0,[%fp-52]

	! block 27
.L1260:
	mov	-1,%l0
	st	%l0,[%fp-60]

	! block 28
.L1261:
.L1262:
	ba	.L1263
	nop

	! block 29
.L1254:
.L1264:
.L1265:
.L1266:
	mov	1,%l0
	st	%l0,[%fp-60]

	! block 30
.L1267:
.L1268:
.L1263:
.L1269:
.L1270:
.L1272:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L1271
	nop

	! block 31
.L1273:
.L1274:
.L1275:
.L1276:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 32
.L1277:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 33
.L1278:
.L1279:
	ba	.L1280
	nop

	! block 34
.L1271:
.L1281:
.L1282:
.L1283:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 35
.L1284:
.L1285:
.L1280:
.L1286:
.L1287:
.L1289:
	ld	[%fp-52],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	ble	.L1288
	nop

	! block 36
.L1290:
.L1291:
.L1292:
.L1293:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-104]

	! block 37
.L1294:
	ld	[%fp-104],%l0
	ld	[%fp-52],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 38
.L1295:
	ld	[%fp-108],%l0
	ld	[%fp-52],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 39
.L1296:
	ld	[%fp-72],%l0
	ld	[%fp-52],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-72]

	! block 40
.L1297:
	ld	[%fp-80],%l0
	ld	[%fp-52],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 41
.L1298:
	ld	[%fp-88],%l0
	ld	[%fp-52],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 42
.L1299:
	ld	[%fp-96],%l0
	ld	[%fp-52],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-96]

	! block 43
.L1300:
.L1301:
	ld	[%fp-52],%l0
	cmp	%g0,%l0
	bge	.L1304
	st	%g0,[%fp-100]

	! block 44
.L1305:
.L1302:
.L1306:
.L1307:
.L1308:
	ld	[%fp-36],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-44],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-68],%l0
	sra	%l0,11,%l2
	ld	[%fp-16],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-76],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-84],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-92],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 45
.L1309:
	ld	[%fp-36],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 46
.L1310:
	ld	[%fp-68],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 47
.L1311:
	ld	[%fp-76],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 48
.L1312:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 49
.L1313:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 50
.L1314:
.L1316:
	ld	[%fp-108],%l0
	cmp	%l0,0
	bge	.L1315
	nop

	! block 51
.L1317:
.L1318:
.L1319:
.L1320:
	ld	[%fp-108],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 52
.L1321:
.L1322:
	ba	.L1323
	nop

	! block 53
.L1315:
.L1324:
.L1325:
.L1326:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 54
.L1327:
	ld	[%fp-44],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 55
.L1328:
.L1329:
.L1323:
.L1330:
.L1331:
.L1332:
.L1333:
	ld	[%fp-100],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-100]
	ld	[%fp-100],%l1
	ld	[%fp-52],%l0
	cmp	%l1,%l0
	bl	.L1302
	nop

	! block 56
.L1334:
.L1304:
.L1335:
.L1336:
.L1337:
	ba	.L1338
	nop

	! block 57
.L1288:
.L1339:
.L1340:
.L1341:
	ld	[%fp-52],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-104]

	! block 58
.L1342:
	ld	[%fp-104],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 59
.L1343:
	ld	[%fp-108],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 60
.L1344:
	ld	[%fp-72],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-72]

	! block 61
.L1345:
	ld	[%fp-80],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 62
.L1346:
	ld	[%fp-88],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 63
.L1347:
	ld	[%fp-96],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-96]

	! block 64
.L1348:
.L1349:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L1352
	st	%g0,[%fp-100]

	! block 65
.L1353:
.L1350:
.L1354:
.L1355:
.L1356:
	ld	[%fp-36],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-44],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-68],%l0
	sra	%l0,11,%l2
	ld	[%fp-16],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-76],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-84],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-92],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 66
.L1357:
	ld	[%fp-44],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 67
.L1358:
	ld	[%fp-68],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 68
.L1359:
	ld	[%fp-76],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 69
.L1360:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 70
.L1361:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 71
.L1362:
.L1364:
	ld	[%fp-108],%l0
	cmp	%l0,0
	bge	.L1363
	nop

	! block 72
.L1365:
.L1366:
.L1367:
.L1368:
	ld	[%fp-108],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 73
.L1369:
.L1370:
	ba	.L1371
	nop

	! block 74
.L1363:
.L1372:
.L1373:
.L1374:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 75
.L1375:
	ld	[%fp-36],%l0
	ld	[%fp-60],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 76
.L1376:
.L1377:
.L1371:
.L1378:
.L1379:
.L1380:
.L1381:
	ld	[%fp-100],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-100]
	ld	[%fp-100],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L1350
	nop

	! block 77
.L1382:
.L1352:
.L1383:
.L1384:
.L1385:
.L1338:
.L1386:
.L1387:
.L1388:

! File lines.c:
!  398	#define INTERP_XY 1
!  399	#define INTERP_RGB 1
!  400	#define INTERP_ALPHA 1
!  401	
!  402	#define PLOT(X,Y)			\
!  403		pbx[count] = X;			\
!  404		pby[count] = Y;			\
!  405		pbr[count] = FixedToInt(r0);	\
!  406		pbg[count] = FixedToInt(g0);	\
!  407		pbb[count] = FixedToInt(b0);	\
!  408		pba[count] = FixedToInt(a0);	\
!  409		count++;
!  410	
!  411	#include "linetemp.h"
!  412	
!  413	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 78
.L1389:
.L1391:

!  414	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L1390
	nop

	! block 79
.L1392:
.L1393:
.L1394:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 80
.L1395:
.L1396:
.L1390:
.L1397:

	! block 81
.L1398:
.L1399:
.L1217:
	jmp	%i7+8
	restore
	.size	smooth_rgba_line,(.-smooth_rgba_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	smooth_rgba_z_line,#function
smooth_rgba_z_line:
	save	%sp,-248,%sp

	! block 1
.L1402:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L1403:
.L1405:

! File lines.c:
!  415	}
!  416	
!  419	/* Smooth-shaded, RGBA line with Z interpolation/testing */
!  420	static void smooth_rgba_z_line( GLcontext *ctx,
!  421	                       	        GLuint vert0, GLuint vert1, GLuint pvert )
!  422	{
!  423	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L1406:

!  424	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L1407:

!  425	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L1408:

!  426	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L1409:

!  427	   GLubyte *pbr = ctx->PB->r;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xbb80),%l1
	or	%l1,%lo(0xbb80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L1410:

!  428	   GLubyte *pbg = ctx->PB->g;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xce40),%l1
	or	%l1,%lo(0xce40),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 8
.L1411:

!  429	   GLubyte *pbb = ctx->PB->b;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 9
.L1412:

!  430	   GLubyte *pba = ctx->PB->a;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xf3c0),%l1
	or	%l1,%lo(0xf3c0),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 10
.L1413:
.L1414:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 11
.L1415:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-44]

	! block 12
.L1416:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-52]

	! block 13
.L1417:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-96]

	! block 14
.L1418:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-96],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 15
.L1419:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-104]

	! block 16
.L1420:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-104],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 17
.L1421:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-112]

	! block 18
.L1422:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-112],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 19
.L1423:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-120]

	! block 20
.L1424:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-120],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 21
.L1425:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 22
.L1426:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 23
.L1427:
.L1429:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L1428
	nop

	! block 24
.L1430:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L1428
	nop

	! block 25
.L1431:
.L1432:
.L1433:
.L1434:
	ba	.L1401
	nop

	! block 26
.L1435:
.L1436:
.L1428:
.L1437:
.L1438:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 27
.L1439:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-72]

	! block 28
.L1440:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-76]

	! block 29
.L1441:
.L1443:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L1442
	nop

	! block 30
.L1444:
.L1445:
.L1446:
.L1447:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 31
.L1448:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 32
.L1449:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 33
.L1450:
.L1451:
	ba	.L1452
	nop

	! block 34
.L1442:
.L1453:
.L1454:
.L1455:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 35
.L1456:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 36
.L1457:
.L1458:
.L1452:
.L1459:
.L1460:
.L1462:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L1461
	nop

	! block 37
.L1463:
.L1464:
.L1465:
.L1466:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 38
.L1467:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 39
.L1468:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 40
.L1469:
.L1470:
	ba	.L1471
	nop

	! block 41
.L1461:
.L1472:
.L1473:
.L1474:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 42
.L1475:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 43
.L1476:
.L1477:
.L1471:
.L1478:
.L1479:
.L1481:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L1480
	nop

	! block 44
.L1482:
.L1483:
.L1484:
.L1485:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-132]

	! block 45
.L1486:
	ld	[%fp-132],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 46
.L1487:
	ld	[%fp-136],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 47
.L1488:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 48
.L1489:
	ld	[%fp-100],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 49
.L1490:
	ld	[%fp-108],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 50
.L1491:
	ld	[%fp-116],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 51
.L1492:
	ld	[%fp-124],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 52
.L1493:
.L1494:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L1497
	st	%g0,[%fp-128]

	! block 53
.L1498:
.L1495:
.L1499:
.L1500:
.L1501:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-142]

	! block 54
.L1502:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 55
.L1503:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 56
.L1504:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 57
.L1505:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 58
.L1506:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 59
.L1507:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 60
.L1508:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 61
.L1509:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 62
.L1510:
.L1512:
	ld	[%fp-136],%l0
	cmp	%l0,0
	bge	.L1511
	nop

	! block 63
.L1513:
.L1514:
.L1515:
.L1516:
	ld	[%fp-136],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 64
.L1517:
.L1518:
	ba	.L1519
	nop

	! block 65
.L1511:
.L1520:
.L1521:
.L1522:
	ld	[%fp-136],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 66
.L1523:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 67
.L1524:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 68
.L1525:
.L1526:
.L1519:
.L1527:
.L1528:
.L1529:
.L1530:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L1495
	nop

	! block 69
.L1531:
.L1497:
.L1532:
.L1533:
.L1534:
	ba	.L1535
	nop

	! block 70
.L1480:
.L1536:
.L1537:
.L1538:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-132]

	! block 71
.L1539:
	ld	[%fp-132],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 72
.L1540:
	ld	[%fp-136],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 73
.L1541:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 74
.L1542:
	ld	[%fp-100],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 75
.L1543:
	ld	[%fp-108],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 76
.L1544:
	ld	[%fp-116],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 77
.L1545:
	ld	[%fp-124],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 78
.L1546:
.L1547:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L1550
	st	%g0,[%fp-128]

	! block 79
.L1551:
.L1548:
.L1552:
.L1553:
.L1554:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-142]

	! block 80
.L1555:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 81
.L1556:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 82
.L1557:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 83
.L1558:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 84
.L1559:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 85
.L1560:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 86
.L1561:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 87
.L1562:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 88
.L1563:
.L1565:
	ld	[%fp-136],%l0
	cmp	%l0,0
	bge	.L1564
	nop

	! block 89
.L1566:
.L1567:
.L1568:
.L1569:
	ld	[%fp-136],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 90
.L1570:
.L1571:
	ba	.L1572
	nop

	! block 91
.L1564:
.L1573:
.L1574:
.L1575:
	ld	[%fp-136],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 92
.L1576:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 93
.L1577:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 94
.L1578:
.L1579:
.L1572:
.L1580:
.L1581:
.L1582:
.L1583:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L1548
	nop

	! block 95
.L1584:
.L1550:
.L1585:
.L1586:
.L1587:
.L1535:
.L1588:
.L1589:
.L1590:

! File lines.c:
!  432	#define INTERP_XY 1
!  433	#define INTERP_Z 1
!  434	#define INTERP_RGB 1
!  435	#define INTERP_ALPHA 1
!  436	
!  437	#define PLOT(X,Y)			\
!  438		pbx[count] = X;			\
!  439		pby[count] = Y;			\
!  440		pbz[count] = Z;			\
!  441		pbr[count] = FixedToInt(r0);	\
!  442		pbg[count] = FixedToInt(g0);	\
!  443		pbb[count] = FixedToInt(b0);	\
!  444		pba[count] = FixedToInt(a0);	\
!  445		count++;
!  446	
!  447	#include "linetemp.h"
!  448	
!  449	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 96
.L1591:
.L1593:

!  450	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L1592
	nop

	! block 97
.L1594:
.L1595:
.L1596:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 98
.L1597:
.L1598:
.L1592:
.L1599:

	! block 99
.L1600:
.L1601:
.L1401:
	jmp	%i7+8
	restore
	.size	smooth_rgba_z_line,(.-smooth_rgba_z_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	general_smooth_ci_line,#function
general_smooth_ci_line:
	save	%sp,-256,%sp

	! block 1
.L1604:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L1605:
.L1607:

! File lines.c:
!  451	}
!  452	
!  454	#define CHECK_FULL(count)			\
!  455		if (count >= PB_SIZE-MAX_WIDTH) {	\
!  456		   ctx->PB->count = count;		\
!  457		   gl_flush_pb(ctx);			\
!  458		   count = ctx->PB->count;		\
!  459		}
!  460	
!  463	/* Smooth shaded, color index, any width, maybe stippled */
!  464	static void general_smooth_ci_line( GLcontext *ctx,
!  465	                           	    GLuint vert0, GLuint vert1, GLuint pvert )
!  466	{
!  467	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L1608:

!  468	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L1609:

!  469	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L1610:

!  470	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L1611:

!  471	   GLuint *pbi = ctx->PB->i;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x10680),%l1
	or	%l1,%lo(0x10680),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L1612:
.L1614:

!  473	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1613
	nop

	! block 8
.L1615:
.L1616:
.L1617:
.L1618:
.L1619:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 9
.L1620:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-32]

	! block 10
.L1621:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-40]

	! block 11
.L1622:
	ld	[%fp-24],%l0
	sethi	%hi(0xad44),%l3
	or	%l3,%lo(0xad44),%l3
	ld	[%l0+%l3],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	st	%l0,[%fp-84]
	ld	[%fp-24],%l0
	ld	[%l0+%l3],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 12
.L1623:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L1624
	nop

	! block 13
.L1625:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L1626
	std	%f4,[%fp-112]

	! block 14
.L1624:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L1627
	nop

	! block 15
.L1628:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L1629
	std	%f4,[%fp-120]

	! block 16
.L1627:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-120]

	! block 17
.L1629:
	ldd	[%fp-120],%f4
	std	%f4,[%fp-112]

	! block 18
.L1626:
	ldd	[%fp-112],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-92]

	! block 19
.L1630:
	ld	[%fp-92],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-96]

	! block 20
.L1631:
	ld	[%fp-96],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 21
.L1632:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 22
.L1633:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 23
.L1634:
.L1636:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L1635
	nop

	! block 24
.L1637:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L1635
	nop

	! block 25
.L1638:
.L1639:
.L1640:
.L1641:
	ba	.L1603
	nop

	! block 26
.L1642:
.L1643:
.L1635:
.L1644:
.L1645:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 27
.L1646:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-60]

	! block 28
.L1647:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-64]

	! block 29
.L1648:
.L1650:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L1649
	nop

	! block 30
.L1651:
.L1652:
.L1653:
.L1654:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 31
.L1655:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 32
.L1656:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 33
.L1657:
.L1658:
	ba	.L1659
	nop

	! block 34
.L1649:
.L1660:
.L1661:
.L1662:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 35
.L1663:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 36
.L1664:
.L1665:
.L1659:
.L1666:
.L1667:
.L1669:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L1668
	nop

	! block 37
.L1670:
.L1671:
.L1672:
.L1673:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 38
.L1674:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 39
.L1675:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 40
.L1676:
.L1677:
	ba	.L1678
	nop

	! block 41
.L1668:
.L1679:
.L1680:
.L1681:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 42
.L1682:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 43
.L1683:
.L1684:
.L1678:
.L1685:
.L1686:
.L1688:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L1687
	nop

	! block 44
.L1689:
.L1690:
.L1691:
.L1692:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-128]

	! block 45
.L1693:
	ld	[%fp-128],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 46
.L1694:
	ld	[%fp-132],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 47
.L1695:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 48
.L1696:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 49
.L1697:
.L1698:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L1701
	st	%g0,[%fp-124]

	! block 50
.L1702:
.L1699:
.L1703:
.L1704:
.L1705:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-138]

	! block 51
.L1706:
.L1708:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-138],%l1
	andcc	%l0,%l1,%l0
	be	.L1707
	nop

	! block 52
.L1709:
.L1710:
.L1711:
.L1712:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-140]

	! block 53
.L1713:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-144]

	! block 54
.L1714:
	ld	[%fp-36],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-152]

	! block 55
.L1715:
	ld	[%fp-36],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-156]

	! block 56
.L1716:
.L1717:
	ld	[%fp-152],%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	bg	.L1720
	nop

	! block 57
.L1721:
.L1718:
.L1722:
.L1723:
.L1724:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-148],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-140],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-144],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 58
.L1725:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L1726
	nop

	! block 59
.L1727:
.L1728:
.L1729:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 60
.L1730:
.L1731:
.L1726:
.L1732:
.L1733:
.L1734:
.L1735:
	ld	[%fp-148],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	ble	.L1718
	nop

	! block 61
.L1736:
.L1720:
.L1737:
.L1738:
.L1739:
.L1707:
.L1740:
.L1741:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 62
.L1742:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 63
.L1743:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 64
.L1744:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 65
.L1745:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 66
.L1746:
.L1748:
	ld	[%fp-132],%l0
	cmp	%l0,0
	bge	.L1747
	nop

	! block 67
.L1749:
.L1750:
.L1751:
.L1752:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 68
.L1753:
.L1754:
	ba	.L1755
	nop

	! block 69
.L1747:
.L1756:
.L1757:
.L1758:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 70
.L1759:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 71
.L1760:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 72
.L1761:
.L1762:
.L1755:
.L1763:
.L1764:
.L1765:
.L1766:
	ld	[%fp-124],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-124]
	ld	[%fp-124],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L1699
	nop

	! block 73
.L1767:
.L1701:
.L1768:
.L1769:
.L1770:
	ba	.L1771
	nop

	! block 74
.L1687:
.L1772:
.L1773:
.L1774:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-128]

	! block 75
.L1775:
	ld	[%fp-128],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 76
.L1776:
	ld	[%fp-132],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 77
.L1777:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 78
.L1778:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 79
.L1779:
.L1780:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L1783
	st	%g0,[%fp-124]

	! block 80
.L1784:
.L1781:
.L1785:
.L1786:
.L1787:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-138]

	! block 81
.L1788:
.L1790:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-138],%l1
	andcc	%l0,%l1,%l0
	be	.L1789
	nop

	! block 82
.L1791:
.L1792:
.L1793:
.L1794:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-140]

	! block 83
.L1795:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-144]

	! block 84
.L1796:
	ld	[%fp-28],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-152]

	! block 85
.L1797:
	ld	[%fp-28],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-156]

	! block 86
.L1798:
.L1799:
	ld	[%fp-152],%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	bg	.L1802
	nop

	! block 87
.L1803:
.L1800:
.L1804:
.L1805:
.L1806:
	ld	[%fp-148],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-140],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-144],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 88
.L1807:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L1808
	nop

	! block 89
.L1809:
.L1810:
.L1811:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 90
.L1812:
.L1813:
.L1808:
.L1814:
.L1815:
.L1816:
.L1817:
	ld	[%fp-148],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	ble	.L1800
	nop

	! block 91
.L1818:
.L1802:
.L1819:
.L1820:
.L1821:
.L1789:
.L1822:
.L1823:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 92
.L1824:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 93
.L1825:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 94
.L1826:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 95
.L1827:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 96
.L1828:
.L1830:
	ld	[%fp-132],%l0
	cmp	%l0,0
	bge	.L1829
	nop

	! block 97
.L1831:
.L1832:
.L1833:
.L1834:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 98
.L1835:
.L1836:
	ba	.L1837
	nop

	! block 99
.L1829:
.L1838:
.L1839:
.L1840:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 100
.L1841:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 101
.L1842:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 102
.L1843:
.L1844:
.L1837:
.L1845:
.L1846:
.L1847:
.L1848:
	ld	[%fp-124],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-124]
	ld	[%fp-124],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L1781
	nop

	! block 103
.L1849:
.L1783:
.L1850:
.L1851:
.L1852:
.L1771:
.L1853:
.L1854:
.L1855:
.L1856:
	ba	.L1857
	nop

	! block 104
.L1613:
.L1858:
.L1859:
.L1860:
.L1862:

! File lines.c:
!  474	      /* stippled */
!  475	#define INTERP_XY 1
!  476	#define INTERP_Z 1
!  477	#define INTERP_INDEX 1
!  478	#define WIDE 1
!  479	#define STIPPLE 1
!  480	#define PLOT(X,Y)		\
!  481		pbx[count] = X;		\
!  482		pby[count] = Y;		\
!  483		pbz[count] = Z;		\
!  484		pbi[count] = I;		\
!  485		count++;		\
!  486		CHECK_FULL(count);
!  487	#include "linetemp.h"
!  488	   }
!  489	   else {
!  490	      /* unstippled */
!  491	      if (ctx->Line.Width==2.0F) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg8),%l0
	ld	[%l0+%lo(.L_cseg8)],%f4
	fcmps	%f5,%f4
	fbne	.L1861
	nop

	! block 105
.L1863:
.L1864:
.L1865:
.L1866:
.L1867:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 106
.L1868:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-32]

	! block 107
.L1869:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-40]

	! block 108
.L1870:
	ld	[%fp-24],%l0
	sethi	%hi(0xad44),%l3
	or	%l3,%lo(0xad44),%l3
	ld	[%l0+%l3],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	st	%l0,[%fp-84]
	ld	[%fp-24],%l0
	ld	[%l0+%l3],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 109
.L1871:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 110
.L1872:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 111
.L1873:
.L1875:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L1874
	nop

	! block 112
.L1876:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L1874
	nop

	! block 113
.L1877:
.L1878:
.L1879:
.L1880:
	ba	.L1603
	nop

	! block 114
.L1881:
.L1882:
.L1874:
.L1883:
.L1884:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 115
.L1885:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-60]

	! block 116
.L1886:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-64]

	! block 117
.L1887:
.L1889:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L1888
	nop

	! block 118
.L1890:
.L1891:
.L1892:
.L1893:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 119
.L1894:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 120
.L1895:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 121
.L1896:
.L1897:
	ba	.L1898
	nop

	! block 122
.L1888:
.L1899:
.L1900:
.L1901:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 123
.L1902:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 124
.L1903:
.L1904:
.L1898:
.L1905:
.L1906:
.L1908:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L1907
	nop

	! block 125
.L1909:
.L1910:
.L1911:
.L1912:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 126
.L1913:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 127
.L1914:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 128
.L1915:
.L1916:
	ba	.L1917
	nop

	! block 129
.L1907:
.L1918:
.L1919:
.L1920:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 130
.L1921:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 131
.L1922:
.L1923:
.L1917:
.L1924:
.L1925:
.L1927:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L1926
	nop

	! block 132
.L1928:
.L1929:
.L1930:
.L1931:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-96]

	! block 133
.L1932:
	ld	[%fp-96],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 134
.L1933:
	ld	[%fp-100],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 135
.L1934:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 136
.L1935:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 137
.L1936:
.L1937:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L1940
	st	%g0,[%fp-92]

	! block 138
.L1941:
.L1938:
.L1942:
.L1943:
.L1944:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-106]

	! block 139
.L1945:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-112]

	! block 140
.L1946:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l0
	add	%l0,1,%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 141
.L1947:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 142
.L1948:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 143
.L1949:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 144
.L1950:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 145
.L1951:
.L1953:
	ld	[%fp-100],%l0
	cmp	%l0,0
	bge	.L1952
	nop

	! block 146
.L1954:
.L1955:
.L1956:
.L1957:
	ld	[%fp-100],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 147
.L1958:
.L1959:
	ba	.L1960
	nop

	! block 148
.L1952:
.L1961:
.L1962:
.L1963:
	ld	[%fp-100],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 149
.L1964:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 150
.L1965:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 151
.L1966:
.L1967:
.L1960:
.L1968:
.L1969:
.L1970:
.L1971:
	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L1938
	nop

	! block 152
.L1972:
.L1940:
.L1973:
.L1974:
.L1975:
	ba	.L1976
	nop

	! block 153
.L1926:
.L1977:
.L1978:
.L1979:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-96]

	! block 154
.L1980:
	ld	[%fp-96],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 155
.L1981:
	ld	[%fp-100],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 156
.L1982:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 157
.L1983:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 158
.L1984:
.L1985:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L1988
	st	%g0,[%fp-92]

	! block 159
.L1989:
.L1986:
.L1990:
.L1991:
.L1992:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-106]

	! block 160
.L1993:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-112]

	! block 161
.L1994:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l0
	add	%l0,1,%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-106],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-112],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 162
.L1995:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 163
.L1996:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 164
.L1997:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 165
.L1998:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 166
.L1999:
.L2001:
	ld	[%fp-100],%l0
	cmp	%l0,0
	bge	.L2000
	nop

	! block 167
.L2002:
.L2003:
.L2004:
.L2005:
	ld	[%fp-100],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 168
.L2006:
.L2007:
	ba	.L2008
	nop

	! block 169
.L2000:
.L2009:
.L2010:
.L2011:
	ld	[%fp-100],%l0
	ld	[%fp-104],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 170
.L2012:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 171
.L2013:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 172
.L2014:
.L2015:
.L2008:
.L2016:
.L2017:
.L2018:
.L2019:
	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L1986
	nop

	! block 173
.L2020:
.L1988:
.L2021:
.L2022:
.L2023:
.L1976:
.L2024:
.L2025:
.L2026:
.L2027:
	ba	.L2028
	nop

	! block 174
.L1861:
.L2029:
.L2030:
.L2031:
.L2032:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 175
.L2033:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-32]

	! block 176
.L2034:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-40]

	! block 177
.L2035:
	ld	[%fp-24],%l0
	sethi	%hi(0xad44),%l3
	or	%l3,%lo(0xad44),%l3
	ld	[%l0+%l3],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	st	%l0,[%fp-84]
	ld	[%fp-24],%l0
	ld	[%l0+%l3],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sll	%l0,8,%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 178
.L2036:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L2037
	nop

	! block 179
.L2038:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L2039
	std	%f4,[%fp-112]

	! block 180
.L2037:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L2040
	nop

	! block 181
.L2041:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L2042
	std	%f4,[%fp-120]

	! block 182
.L2040:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-120]

	! block 183
.L2042:
	ldd	[%fp-120],%f4
	std	%f4,[%fp-112]

	! block 184
.L2039:
	ldd	[%fp-112],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-92]

	! block 185
.L2043:
	ld	[%fp-92],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-96]

	! block 186
.L2044:
	ld	[%fp-96],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 187
.L2045:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 188
.L2046:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 189
.L2047:
.L2049:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L2048
	nop

	! block 190
.L2050:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L2048
	nop

	! block 191
.L2051:
.L2052:
.L2053:
.L2054:
	ba	.L1603
	nop

	! block 192
.L2055:
.L2056:
.L2048:
.L2057:
.L2058:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 193
.L2059:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-60]

	! block 194
.L2060:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-160]
	ld	[%fp-160],%l0
	st	%l0,[%fp-64]

	! block 195
.L2061:
.L2063:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L2062
	nop

	! block 196
.L2064:
.L2065:
.L2066:
.L2067:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 197
.L2068:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 198
.L2069:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 199
.L2070:
.L2071:
	ba	.L2072
	nop

	! block 200
.L2062:
.L2073:
.L2074:
.L2075:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 201
.L2076:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 202
.L2077:
.L2078:
.L2072:
.L2079:
.L2080:
.L2082:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L2081
	nop

	! block 203
.L2083:
.L2084:
.L2085:
.L2086:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 204
.L2087:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 205
.L2088:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 206
.L2089:
.L2090:
	ba	.L2091
	nop

	! block 207
.L2081:
.L2092:
.L2093:
.L2094:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 208
.L2095:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 209
.L2096:
.L2097:
.L2091:
.L2098:
.L2099:
.L2101:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L2100
	nop

	! block 210
.L2102:
.L2103:
.L2104:
.L2105:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-128]

	! block 211
.L2106:
	ld	[%fp-128],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 212
.L2107:
	ld	[%fp-132],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 213
.L2108:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 214
.L2109:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 215
.L2110:
.L2111:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L2114
	st	%g0,[%fp-124]

	! block 216
.L2115:
.L2112:
.L2116:
.L2117:
.L2118:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-138]

	! block 217
.L2119:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-144]

	! block 218
.L2120:
	ld	[%fp-36],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-152]

	! block 219
.L2121:
	ld	[%fp-36],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-156]

	! block 220
.L2122:
.L2123:
	ld	[%fp-152],%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	bg	.L2126
	nop

	! block 221
.L2127:
.L2124:
.L2128:
.L2129:
.L2130:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-148],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-138],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-144],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 222
.L2131:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2132
	nop

	! block 223
.L2133:
.L2134:
.L2135:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 224
.L2136:
.L2137:
.L2132:
.L2138:
.L2139:
.L2140:
.L2141:
	ld	[%fp-148],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	ble	.L2124
	nop

	! block 225
.L2142:
.L2126:
.L2143:
.L2144:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 226
.L2145:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 227
.L2146:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 228
.L2147:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 229
.L2148:
.L2150:
	ld	[%fp-132],%l0
	cmp	%l0,0
	bge	.L2149
	nop

	! block 230
.L2151:
.L2152:
.L2153:
.L2154:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 231
.L2155:
.L2156:
	ba	.L2157
	nop

	! block 232
.L2149:
.L2158:
.L2159:
.L2160:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 233
.L2161:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 234
.L2162:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 235
.L2163:
.L2164:
.L2157:
.L2165:
.L2166:
.L2167:
.L2168:
	ld	[%fp-124],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-124]
	ld	[%fp-124],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L2112
	nop

	! block 236
.L2169:
.L2114:
.L2170:
.L2171:
.L2172:
	ba	.L2173
	nop

	! block 237
.L2100:
.L2174:
.L2175:
.L2176:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-128]

	! block 238
.L2177:
	ld	[%fp-128],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 239
.L2178:
	ld	[%fp-132],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 240
.L2179:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 241
.L2180:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-88]

	! block 242
.L2181:
.L2182:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L2185
	st	%g0,[%fp-124]

	! block 243
.L2186:
.L2183:
.L2187:
.L2188:
.L2189:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-138]

	! block 244
.L2190:
	ld	[%fp-84],%l0
	sra	%l0,8,%l0
	st	%l0,[%fp-144]

	! block 245
.L2191:
	ld	[%fp-28],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-152]

	! block 246
.L2192:
	ld	[%fp-28],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-156]

	! block 247
.L2193:
.L2194:
	ld	[%fp-152],%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	bg	.L2197
	nop

	! block 248
.L2198:
.L2195:
.L2199:
.L2200:
.L2201:
	ld	[%fp-148],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-138],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-144],%l3
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 249
.L2202:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2203
	nop

	! block 250
.L2204:
.L2205:
.L2206:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 251
.L2207:
.L2208:
.L2203:
.L2209:
.L2210:
.L2211:
.L2212:
	ld	[%fp-148],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp-156],%l0
	cmp	%l1,%l0
	ble	.L2195
	nop

	! block 252
.L2213:
.L2197:
.L2214:
.L2215:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 253
.L2216:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 254
.L2217:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 255
.L2218:
	ld	[%fp-84],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 256
.L2219:
.L2221:
	ld	[%fp-132],%l0
	cmp	%l0,0
	bge	.L2220
	nop

	! block 257
.L2222:
.L2223:
.L2224:
.L2225:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 258
.L2226:
.L2227:
	ba	.L2228
	nop

	! block 259
.L2220:
.L2229:
.L2230:
.L2231:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 260
.L2232:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 261
.L2233:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 262
.L2234:
.L2235:
.L2228:
.L2236:
.L2237:
.L2238:
.L2239:
	ld	[%fp-124],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-124]
	ld	[%fp-124],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L2183
	nop

	! block 263
.L2240:
.L2185:
.L2241:
.L2242:
.L2243:
.L2173:
.L2244:
.L2245:
.L2246:
.L2247:
.L2028:
.L2248:
.L2249:
.L2250:
.L1857:
.L2251:
.L2252:

! File lines.c:
!  492	         /* special case: unstippled and width=2 */
!  493	#define INTERP_XY 1
!  494	#define INTERP_Z 1
!  495	#define INTERP_INDEX 1
!  496	#define XMAJOR_PLOT(X,Y)			\
!  497		pbx[count] = X;  pbx[count+1] = X;	\
!  498		pby[count] = Y;  pby[count+1] = Y+1;	\
!  499		pbz[count] = Z;  pbz[count+1] = Z;	\
!  500		pbi[count] = I;  pbi[count+1] = I;	\
!  501		count += 2;
!  502	#define YMAJOR_PLOT(X,Y)			\
!  503		pbx[count] = X;  pbx[count+1] = X+1;	\
!  504		pby[count] = Y;  pby[count+1] = Y;	\
!  505		pbz[count] = Z;  pbz[count+1] = Z;	\
!  506		pbi[count] = I;  pbi[count+1] = I;	\
!  507		count += 2;
!  508	#include "linetemp.h"
!  509	      }
!  510	      else {
!  511	         /* unstippled, any width */
!  512	#define INTERP_XY 1
!  513	#define INTERP_Z 1
!  514	#define INTERP_INDEX 1
!  515	#define WIDE 1
!  516	#define PLOT(X,Y)		\
!  517		pbx[count] = X;		\
!  518		pby[count] = Y;		\
!  519		pbz[count] = Z;		\
!  520		pbi[count] = I;		\
!  521		count++;		\
!  522		CHECK_FULL(count);
!  523	#include "linetemp.h"
!  524	      }
!  525	   }
!  526	
!  527	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 264
.L2253:
.L2255:

!  528	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L2254
	nop

	! block 265
.L2256:
.L2257:
.L2258:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 266
.L2259:
.L2260:
.L2254:
.L2261:

	! block 267
.L2262:
.L2263:
.L1603:
	jmp	%i7+8
	restore
	.size	general_smooth_ci_line,(.-general_smooth_ci_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	general_flat_ci_line,#function
general_flat_ci_line:
	save	%sp,-240,%sp

	! block 1
.L2266:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L2267:
.L2269:

! File lines.c:
!  529	}
!  530	
!  532	/* Flat shaded, color index, any width, maybe stippled */
!  533	static void general_flat_ci_line( GLcontext *ctx,
!  534	                                  GLuint vert0, GLuint vert1, GLuint pvert )
!  535	{
!  536	   GLint count;
!  537	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L2270:

!  538	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L2271:

!  539	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L2272:
.L2274:

!  540	   PB_SET_INDEX( ctx, ctx->PB, ctx->VB->Index[pvert] );

	ld	[%fp+68],%l2
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	ld	[%l0+%l1],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	cmp	%l3,%l0
	bne	.L2275
	nop

	! block 6
.L2276:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L2273
	nop

	! block 7
.L2277:
.L2275:
.L2278:
.L2279:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 8
.L2280:
.L2281:
.L2273:
.L2282:
	ld	[%fp+68],%l3
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l3+%l1],%l0
	sethi	%hi(0xad44),%l1
	or	%l1,%lo(0xad44),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l5
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l3+%l2],%l0
	sethi	%hi(0x27d90),%l1
	or	%l1,%lo(0x27d90),%l1
	st	%l5,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 9
.L2283:

!  541	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 10
.L2284:
.L2286:

!  543	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2285
	nop

	! block 11
.L2287:
.L2288:
.L2289:
.L2290:
.L2291:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 12
.L2292:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-28]

	! block 13
.L2293:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-36]

	! block 14
.L2294:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L2295
	nop

	! block 15
.L2296:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L2297
	std	%f4,[%fp-96]

	! block 16
.L2295:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L2298
	nop

	! block 17
.L2299:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L2300
	std	%f4,[%fp-104]

	! block 18
.L2298:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-104]

	! block 19
.L2300:
	ldd	[%fp-104],%f4
	std	%f4,[%fp-96]

	! block 20
.L2297:
	ldd	[%fp-96],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-80]

	! block 21
.L2301:
	ld	[%fp-80],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-84]

	! block 22
.L2302:
	ld	[%fp-84],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 23
.L2303:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 24
.L2304:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 25
.L2305:
.L2307:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L2306
	nop

	! block 26
.L2308:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L2306
	nop

	! block 27
.L2309:
.L2310:
.L2311:
.L2312:
	ba	.L2265
	nop

	! block 28
.L2313:
.L2314:
.L2306:
.L2315:
.L2316:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-32],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-24],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-76]

	! block 29
.L2317:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-56]

	! block 30
.L2318:
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-60]

	! block 31
.L2319:
.L2321:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L2320
	nop

	! block 32
.L2322:
.L2323:
.L2324:
.L2325:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 33
.L2326:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 34
.L2327:
	mov	-2,%l0
	st	%l0,[%fp-68]

	! block 35
.L2328:
.L2329:
	ba	.L2330
	nop

	! block 36
.L2320:
.L2331:
.L2332:
.L2333:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 37
.L2334:
	mov	2,%l0
	st	%l0,[%fp-68]

	! block 38
.L2335:
.L2336:
.L2330:
.L2337:
.L2338:
.L2340:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L2339
	nop

	! block 39
.L2341:
.L2342:
.L2343:
.L2344:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 40
.L2345:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 41
.L2346:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 42
.L2347:
.L2348:
	ba	.L2349
	nop

	! block 43
.L2339:
.L2350:
.L2351:
.L2352:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 44
.L2353:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 45
.L2354:
.L2355:
.L2349:
.L2356:
.L2357:
.L2359:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L2358
	nop

	! block 46
.L2360:
.L2361:
.L2362:
.L2363:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-112]

	! block 47
.L2364:
	ld	[%fp-112],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 48
.L2365:
	ld	[%fp-116],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 49
.L2366:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-40],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 50
.L2367:
.L2368:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L2371
	st	%g0,[%fp-108]

	! block 51
.L2372:
.L2369:
.L2373:
.L2374:
.L2375:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-122]

	! block 52
.L2376:
.L2378:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-122],%l1
	andcc	%l0,%l1,%l0
	be	.L2377
	nop

	! block 53
.L2379:
.L2380:
.L2381:
.L2382:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-124]

	! block 54
.L2383:
	ld	[%fp-32],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 55
.L2384:
	ld	[%fp-32],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 56
.L2385:
.L2386:
	ld	[%fp-132],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	bg	.L2389
	nop

	! block 57
.L2390:
.L2387:
.L2391:
.L2392:
.L2393:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-124],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 58
.L2394:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2395
	nop

	! block 59
.L2396:
.L2397:
.L2398:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 60
.L2399:
.L2400:
.L2395:
.L2401:
.L2402:
.L2403:
.L2404:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	ble	.L2387
	nop

	! block 61
.L2405:
.L2389:
.L2406:
.L2407:
.L2408:
.L2377:
.L2409:
.L2410:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 62
.L2411:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 63
.L2412:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 64
.L2413:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 65
.L2414:
.L2416:
	ld	[%fp-116],%l0
	cmp	%l0,0
	bge	.L2415
	nop

	! block 66
.L2417:
.L2418:
.L2419:
.L2420:
	ld	[%fp-116],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 67
.L2421:
.L2422:
	ba	.L2423
	nop

	! block 68
.L2415:
.L2424:
.L2425:
.L2426:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 69
.L2427:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 70
.L2428:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 71
.L2429:
.L2430:
.L2423:
.L2431:
.L2432:
.L2433:
.L2434:
	ld	[%fp-108],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-108]
	ld	[%fp-108],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L2369
	nop

	! block 72
.L2435:
.L2371:
.L2436:
.L2437:
.L2438:
	ba	.L2439
	nop

	! block 73
.L2358:
.L2440:
.L2441:
.L2442:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-112]

	! block 74
.L2443:
	ld	[%fp-112],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 75
.L2444:
	ld	[%fp-116],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 76
.L2445:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 77
.L2446:
.L2447:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L2450
	st	%g0,[%fp-108]

	! block 78
.L2451:
.L2448:
.L2452:
.L2453:
.L2454:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-122]

	! block 79
.L2455:
.L2457:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-122],%l1
	andcc	%l0,%l1,%l0
	be	.L2456
	nop

	! block 80
.L2458:
.L2459:
.L2460:
.L2461:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-124]

	! block 81
.L2462:
	ld	[%fp-24],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 82
.L2463:
	ld	[%fp-24],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 83
.L2464:
.L2465:
	ld	[%fp-132],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	bg	.L2468
	nop

	! block 84
.L2469:
.L2466:
.L2470:
.L2471:
.L2472:
	ld	[%fp-128],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-124],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 85
.L2473:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2474
	nop

	! block 86
.L2475:
.L2476:
.L2477:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 87
.L2478:
.L2479:
.L2474:
.L2480:
.L2481:
.L2482:
.L2483:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	ble	.L2466
	nop

	! block 88
.L2484:
.L2468:
.L2485:
.L2486:
.L2487:
.L2456:
.L2488:
.L2489:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 89
.L2490:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 90
.L2491:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 91
.L2492:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 92
.L2493:
.L2495:
	ld	[%fp-116],%l0
	cmp	%l0,0
	bge	.L2494
	nop

	! block 93
.L2496:
.L2497:
.L2498:
.L2499:
	ld	[%fp-116],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 94
.L2500:
.L2501:
	ba	.L2502
	nop

	! block 95
.L2494:
.L2503:
.L2504:
.L2505:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 96
.L2506:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 97
.L2507:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 98
.L2508:
.L2509:
.L2502:
.L2510:
.L2511:
.L2512:
.L2513:
	ld	[%fp-108],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-108]
	ld	[%fp-108],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L2448
	nop

	! block 99
.L2514:
.L2450:
.L2515:
.L2516:
.L2517:
.L2439:
.L2518:
.L2519:
.L2520:
.L2521:
	ba	.L2522
	nop

	! block 100
.L2285:
.L2523:
.L2524:
.L2525:
.L2527:

! File lines.c:
!  544	      /* stippled, any width */
!  545	#define INTERP_XY 1
!  546	#define INTERP_Z 1
!  547	#define WIDE 1
!  548	#define STIPPLE 1
!  549	#define PLOT(X,Y)		\
!  550		pbx[count] = X;		\
!  551		pby[count] = Y;		\
!  552		pbz[count] = Z;		\
!  553		count++;		\
!  554		CHECK_FULL(count);
!  555	#include "linetemp.h"
!  556	   }
!  557	   else {
!  558	      /* unstippled */
!  559	      if (ctx->Line.Width==2.0F) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg8),%l0
	ld	[%l0+%lo(.L_cseg8)],%f4
	fcmps	%f5,%f4
	fbne	.L2526
	nop

	! block 101
.L2528:
.L2529:
.L2530:
.L2531:
.L2532:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 102
.L2533:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-28]

	! block 103
.L2534:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-36]

	! block 104
.L2535:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 105
.L2536:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 106
.L2537:
.L2539:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L2538
	nop

	! block 107
.L2540:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L2538
	nop

	! block 108
.L2541:
.L2542:
.L2543:
.L2544:
	ba	.L2265
	nop

	! block 109
.L2545:
.L2546:
.L2538:
.L2547:
.L2548:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-32],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-24],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-76]

	! block 110
.L2549:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-56]

	! block 111
.L2550:
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-60]

	! block 112
.L2551:
.L2553:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L2552
	nop

	! block 113
.L2554:
.L2555:
.L2556:
.L2557:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 114
.L2558:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 115
.L2559:
	mov	-2,%l0
	st	%l0,[%fp-68]

	! block 116
.L2560:
.L2561:
	ba	.L2562
	nop

	! block 117
.L2552:
.L2563:
.L2564:
.L2565:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 118
.L2566:
	mov	2,%l0
	st	%l0,[%fp-68]

	! block 119
.L2567:
.L2568:
.L2562:
.L2569:
.L2570:
.L2572:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L2571
	nop

	! block 120
.L2573:
.L2574:
.L2575:
.L2576:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 121
.L2577:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 122
.L2578:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 123
.L2579:
.L2580:
	ba	.L2581
	nop

	! block 124
.L2571:
.L2582:
.L2583:
.L2584:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 125
.L2585:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 126
.L2586:
.L2587:
.L2581:
.L2588:
.L2589:
.L2591:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L2590
	nop

	! block 127
.L2592:
.L2593:
.L2594:
.L2595:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-84]

	! block 128
.L2596:
	ld	[%fp-84],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 129
.L2597:
	ld	[%fp-88],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 130
.L2598:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-40],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 131
.L2599:
.L2600:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L2603
	st	%g0,[%fp-80]

	! block 132
.L2604:
.L2601:
.L2605:
.L2606:
.L2607:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-94]

	! block 133
.L2608:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l0
	add	%l0,1,%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 134
.L2609:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 135
.L2610:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 136
.L2611:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 137
.L2612:
.L2614:
	ld	[%fp-88],%l0
	cmp	%l0,0
	bge	.L2613
	nop

	! block 138
.L2615:
.L2616:
.L2617:
.L2618:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 139
.L2619:
.L2620:
	ba	.L2621
	nop

	! block 140
.L2613:
.L2622:
.L2623:
.L2624:
	ld	[%fp-88],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 141
.L2625:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 142
.L2626:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 143
.L2627:
.L2628:
.L2621:
.L2629:
.L2630:
.L2631:
.L2632:
	ld	[%fp-80],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-80]
	ld	[%fp-80],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L2601
	nop

	! block 144
.L2633:
.L2603:
.L2634:
.L2635:
.L2636:
	ba	.L2637
	nop

	! block 145
.L2590:
.L2638:
.L2639:
.L2640:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-84]

	! block 146
.L2641:
	ld	[%fp-84],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 147
.L2642:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 148
.L2643:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 149
.L2644:
.L2645:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L2648
	st	%g0,[%fp-80]

	! block 150
.L2649:
.L2646:
.L2650:
.L2651:
.L2652:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-94]

	! block 151
.L2653:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-24],%l0
	add	%l0,1,%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-94],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 152
.L2654:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 153
.L2655:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 154
.L2656:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 155
.L2657:
.L2659:
	ld	[%fp-88],%l0
	cmp	%l0,0
	bge	.L2658
	nop

	! block 156
.L2660:
.L2661:
.L2662:
.L2663:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 157
.L2664:
.L2665:
	ba	.L2666
	nop

	! block 158
.L2658:
.L2667:
.L2668:
.L2669:
	ld	[%fp-88],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-88]

	! block 159
.L2670:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 160
.L2671:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 161
.L2672:
.L2673:
.L2666:
.L2674:
.L2675:
.L2676:
.L2677:
	ld	[%fp-80],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-80]
	ld	[%fp-80],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L2646
	nop

	! block 162
.L2678:
.L2648:
.L2679:
.L2680:
.L2681:
.L2637:
.L2682:
.L2683:
.L2684:
.L2685:
	ba	.L2686
	nop

	! block 163
.L2526:
.L2687:
.L2688:
.L2689:
.L2690:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-20]

	! block 164
.L2691:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-24]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-28]

	! block 165
.L2692:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-32]
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-36]

	! block 166
.L2693:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L2694
	nop

	! block 167
.L2695:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L2696
	std	%f4,[%fp-96]

	! block 168
.L2694:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L2697
	nop

	! block 169
.L2698:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L2699
	std	%f4,[%fp-104]

	! block 170
.L2697:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-104]

	! block 171
.L2699:
	ldd	[%fp-104],%f4
	std	%f4,[%fp-96]

	! block 172
.L2696:
	ldd	[%fp-96],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-80]

	! block 173
.L2700:
	ld	[%fp-80],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-84]

	! block 174
.L2701:
	ld	[%fp-84],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 175
.L2702:
	ld	[%fp-28],%l0
	ld	[%fp-24],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 176
.L2703:
	ld	[%fp-36],%l0
	ld	[%fp-32],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 177
.L2704:
.L2706:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bne	.L2705
	nop

	! block 178
.L2707:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L2705
	nop

	! block 179
.L2708:
.L2709:
.L2710:
.L2711:
	ba	.L2265
	nop

	! block 180
.L2712:
.L2713:
.L2705:
.L2714:
.L2715:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-32],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-24],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-76]

	! block 181
.L2716:
	ld	[%fp-20],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-56]

	! block 182
.L2717:
	ld	[%fp-20],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-140]
	ld	[%fp-140],%l0
	st	%l0,[%fp-60]

	! block 183
.L2718:
.L2720:
	ld	[%fp-40],%l0
	cmp	%l0,0
	bge	.L2719
	nop

	! block 184
.L2721:
.L2722:
.L2723:
.L2724:
	ld	[%fp-40],%l0
	neg	%l0,%l0
	st	%l0,[%fp-40]

	! block 185
.L2725:
	mov	-1,%l0
	st	%l0,[%fp-48]

	! block 186
.L2726:
	mov	-2,%l0
	st	%l0,[%fp-68]

	! block 187
.L2727:
.L2728:
	ba	.L2729
	nop

	! block 188
.L2719:
.L2730:
.L2731:
.L2732:
	mov	1,%l0
	st	%l0,[%fp-48]

	! block 189
.L2733:
	mov	2,%l0
	st	%l0,[%fp-68]

	! block 190
.L2734:
.L2735:
.L2729:
.L2736:
.L2737:
.L2739:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L2738
	nop

	! block 191
.L2740:
.L2741:
.L2742:
.L2743:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 192
.L2744:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 193
.L2745:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 194
.L2746:
.L2747:
	ba	.L2748
	nop

	! block 195
.L2738:
.L2749:
.L2750:
.L2751:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 196
.L2752:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 197
.L2753:
.L2754:
.L2748:
.L2755:
.L2756:
.L2758:
	ld	[%fp-40],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	ble	.L2757
	nop

	! block 198
.L2759:
.L2760:
.L2761:
.L2762:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-112]

	! block 199
.L2763:
	ld	[%fp-112],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 200
.L2764:
	ld	[%fp-116],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 201
.L2765:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-40],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 202
.L2766:
.L2767:
	ld	[%fp-40],%l0
	cmp	%g0,%l0
	bge	.L2770
	st	%g0,[%fp-108]

	! block 203
.L2771:
.L2768:
.L2772:
.L2773:
.L2774:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-122]

	! block 204
.L2775:
	ld	[%fp-32],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 205
.L2776:
	ld	[%fp-32],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 206
.L2777:
.L2778:
	ld	[%fp-132],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	bg	.L2781
	nop

	! block 207
.L2782:
.L2779:
.L2783:
.L2784:
.L2785:
	ld	[%fp-24],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-122],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 208
.L2786:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2787
	nop

	! block 209
.L2788:
.L2789:
.L2790:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 210
.L2791:
.L2792:
.L2787:
.L2793:
.L2794:
.L2795:
.L2796:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	ble	.L2779
	nop

	! block 211
.L2797:
.L2781:
.L2798:
.L2799:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 212
.L2800:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 213
.L2801:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 214
.L2802:
.L2804:
	ld	[%fp-116],%l0
	cmp	%l0,0
	bge	.L2803
	nop

	! block 215
.L2805:
.L2806:
.L2807:
.L2808:
	ld	[%fp-116],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 216
.L2809:
.L2810:
	ba	.L2811
	nop

	! block 217
.L2803:
.L2812:
.L2813:
.L2814:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 218
.L2815:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 219
.L2816:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 220
.L2817:
.L2818:
.L2811:
.L2819:
.L2820:
.L2821:
.L2822:
	ld	[%fp-108],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-108]
	ld	[%fp-108],%l1
	ld	[%fp-40],%l0
	cmp	%l1,%l0
	bl	.L2768
	nop

	! block 221
.L2823:
.L2770:
.L2824:
.L2825:
.L2826:
	ba	.L2827
	nop

	! block 222
.L2757:
.L2828:
.L2829:
.L2830:
	ld	[%fp-40],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-112]

	! block 223
.L2831:
	ld	[%fp-112],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 224
.L2832:
	ld	[%fp-116],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 225
.L2833:
	ld	[%fp-60],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-64]

	! block 226
.L2834:
.L2835:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L2838
	st	%g0,[%fp-108]

	! block 227
.L2839:
.L2836:
.L2840:
.L2841:
.L2842:
	ld	[%fp-56],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-122]

	! block 228
.L2843:
	ld	[%fp-24],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 229
.L2844:
	ld	[%fp-24],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 230
.L2845:
.L2846:
	ld	[%fp-132],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	bg	.L2849
	nop

	! block 231
.L2850:
.L2847:
.L2851:
.L2852:
.L2853:
	ld	[%fp-128],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-32],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-122],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 232
.L2854:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L2855
	nop

	! block 233
.L2856:
.L2857:
.L2858:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 234
.L2859:
.L2860:
.L2855:
.L2861:
.L2862:
.L2863:
.L2864:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-136],%l0
	cmp	%l1,%l0
	ble	.L2847
	nop

	! block 235
.L2865:
.L2849:
.L2866:
.L2867:
	ld	[%fp-32],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 236
.L2868:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 237
.L2869:
	ld	[%fp-56],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 238
.L2870:
.L2872:
	ld	[%fp-116],%l0
	cmp	%l0,0
	bge	.L2871
	nop

	! block 239
.L2873:
.L2874:
.L2875:
.L2876:
	ld	[%fp-116],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 240
.L2877:
.L2878:
	ba	.L2879
	nop

	! block 241
.L2871:
.L2880:
.L2881:
.L2882:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 242
.L2883:
	ld	[%fp-24],%l0
	ld	[%fp-48],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 243
.L2884:
	ld	[%fp-76],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-76]

	! block 244
.L2885:
.L2886:
.L2879:
.L2887:
.L2888:
.L2889:
.L2890:
	ld	[%fp-108],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-108]
	ld	[%fp-108],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L2836
	nop

	! block 245
.L2891:
.L2838:
.L2892:
.L2893:
.L2894:
.L2827:
.L2895:
.L2896:
.L2897:
.L2898:
.L2686:
.L2899:
.L2900:
.L2901:
.L2522:
.L2902:
.L2903:

! File lines.c:
!  560	         /* special case: unstippled and width=2 */
!  561	#define INTERP_XY 1
!  562	#define INTERP_Z 1
!  563	#define XMAJOR_PLOT(X,Y)			\
!  564		pbx[count] = X;  pbx[count+1] = X;	\
!  565		pby[count] = Y;  pby[count+1] = Y+1;	\
!  566		pbz[count] = Z;  pbz[count+1] = Z;	\
!  567		count += 2;
!  568	#define YMAJOR_PLOT(X,Y)			\
!  569		pbx[count] = X;  pbx[count+1] = X+1;	\
!  570		pby[count] = Y;  pby[count+1] = Y;	\
!  571		pbz[count] = Z;  pbz[count+1] = Z;	\
!  572		count += 2;
!  573	#include "linetemp.h"
!  574	      }
!  575	      else {
!  576	         /* unstippled, any width */
!  577	#define INTERP_XY 1
!  578	#define INTERP_Z 1
!  579	#define WIDE 1
!  580	#define PLOT(X,Y)		\
!  581		pbx[count] = X;		\
!  582		pby[count] = Y;		\
!  583		pbz[count] = Z;		\
!  584		count++;		\
!  585		CHECK_FULL(count);
!  586	#include "linetemp.h"
!  587	      }
!  588	   }
!  589	
!  590	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 246
.L2904:
.L2906:

!  591	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L2905
	nop

	! block 247
.L2907:
.L2908:
.L2909:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 248
.L2910:
.L2911:
.L2905:
.L2912:

	! block 249
.L2913:
.L2914:
.L2265:
	jmp	%i7+8
	restore
	.size	general_flat_ci_line,(.-general_flat_ci_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	general_smooth_rgba_line,#function
general_smooth_rgba_line:
	save	%sp,-288,%sp

	! block 1
.L2917:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L2918:
.L2920:

! File lines.c:
!  592	}
!  593	
!  596	static void general_smooth_rgba_line( GLcontext *ctx,
!  597	                                      GLuint vert0, GLuint vert1, GLuint pvert)
!  598	{
!  599	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L2921:

!  600	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L2922:

!  601	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L2923:

!  602	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L2924:

!  603	   GLubyte *pbr = ctx->PB->r;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xbb80),%l1
	or	%l1,%lo(0xbb80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L2925:

!  604	   GLubyte *pbg = ctx->PB->g;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xce40),%l1
	or	%l1,%lo(0xce40),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 8
.L2926:

!  605	   GLubyte *pbb = ctx->PB->b;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 9
.L2927:

!  606	   GLubyte *pba = ctx->PB->a;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xf3c0),%l1
	or	%l1,%lo(0xf3c0),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 10
.L2928:
.L2930:

!  608	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2929
	nop

	! block 11
.L2931:
.L2932:
.L2933:
.L2934:
.L2935:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 12
.L2936:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-44]

	! block 13
.L2937:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-52]

	! block 14
.L2938:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-96]

	! block 15
.L2939:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-96],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 16
.L2940:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-104]

	! block 17
.L2941:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-104],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 18
.L2942:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-112]

	! block 19
.L2943:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-112],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 20
.L2944:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-120]

	! block 21
.L2945:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-120],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 22
.L2946:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L2947
	nop

	! block 23
.L2948:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L2949
	std	%f4,[%fp-144]

	! block 24
.L2947:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L2950
	nop

	! block 25
.L2951:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L2952
	std	%f4,[%fp-152]

	! block 26
.L2950:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-152]

	! block 27
.L2952:
	ldd	[%fp-152],%f4
	std	%f4,[%fp-144]

	! block 28
.L2949:
	ldd	[%fp-144],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-128]

	! block 29
.L2953:
	ld	[%fp-128],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-132]

	! block 30
.L2954:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-136]

	! block 31
.L2955:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 32
.L2956:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 33
.L2957:
.L2959:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L2958
	nop

	! block 34
.L2960:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L2958
	nop

	! block 35
.L2961:
.L2962:
.L2963:
.L2964:
	ba	.L2916
	nop

	! block 36
.L2965:
.L2966:
.L2958:
.L2967:
.L2968:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 37
.L2969:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-72]

	! block 38
.L2970:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-76]

	! block 39
.L2971:
.L2973:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L2972
	nop

	! block 40
.L2974:
.L2975:
.L2976:
.L2977:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 41
.L2978:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 42
.L2979:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 43
.L2980:
.L2981:
	ba	.L2982
	nop

	! block 44
.L2972:
.L2983:
.L2984:
.L2985:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 45
.L2986:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 46
.L2987:
.L2988:
.L2982:
.L2989:
.L2990:
.L2992:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L2991
	nop

	! block 47
.L2993:
.L2994:
.L2995:
.L2996:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 48
.L2997:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 49
.L2998:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 50
.L2999:
.L3000:
	ba	.L3001
	nop

	! block 51
.L2991:
.L3002:
.L3003:
.L3004:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 52
.L3005:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 53
.L3006:
.L3007:
.L3001:
.L3008:
.L3009:
.L3011:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L3010
	nop

	! block 54
.L3012:
.L3013:
.L3014:
.L3015:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-160]

	! block 55
.L3016:
	ld	[%fp-160],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 56
.L3017:
	ld	[%fp-164],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-168]

	! block 57
.L3018:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 58
.L3019:
	ld	[%fp-100],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 59
.L3020:
	ld	[%fp-108],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 60
.L3021:
	ld	[%fp-116],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 61
.L3022:
	ld	[%fp-124],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 62
.L3023:
.L3024:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L3027
	st	%g0,[%fp-156]

	! block 63
.L3028:
.L3025:
.L3029:
.L3030:
.L3031:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-170]

	! block 64
.L3032:
.L3034:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-170],%l1
	andcc	%l0,%l1,%l0
	be	.L3033
	nop

	! block 65
.L3035:
.L3036:
.L3037:
.L3038:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-172]

	! block 66
.L3039:
	ld	[%fp-48],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-180]

	! block 67
.L3040:
	ld	[%fp-48],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-184]

	! block 68
.L3041:
.L3042:
	ld	[%fp-180],%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	bg	.L3045
	nop

	! block 69
.L3046:
.L3043:
.L3047:
.L3048:
.L3049:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-176],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-172],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 70
.L3050:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3051
	nop

	! block 71
.L3052:
.L3053:
.L3054:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 72
.L3055:
.L3056:
.L3051:
.L3057:
.L3058:
.L3059:
.L3060:
	ld	[%fp-176],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	ble	.L3043
	nop

	! block 73
.L3061:
.L3045:
.L3062:
.L3063:
.L3064:
.L3033:
.L3065:
.L3066:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 74
.L3067:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 75
.L3068:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 76
.L3069:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 77
.L3070:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 78
.L3071:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 79
.L3072:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 80
.L3073:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 81
.L3074:
.L3076:
	ld	[%fp-164],%l0
	cmp	%l0,0
	bge	.L3075
	nop

	! block 82
.L3077:
.L3078:
.L3079:
.L3080:
	ld	[%fp-164],%l0
	ld	[%fp-160],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 83
.L3081:
.L3082:
	ba	.L3083
	nop

	! block 84
.L3075:
.L3084:
.L3085:
.L3086:
	ld	[%fp-164],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 85
.L3087:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 86
.L3088:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 87
.L3089:
.L3090:
.L3083:
.L3091:
.L3092:
.L3093:
.L3094:
	ld	[%fp-156],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-156]
	ld	[%fp-156],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L3025
	nop

	! block 88
.L3095:
.L3027:
.L3096:
.L3097:
.L3098:
	ba	.L3099
	nop

	! block 89
.L3010:
.L3100:
.L3101:
.L3102:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-160]

	! block 90
.L3103:
	ld	[%fp-160],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 91
.L3104:
	ld	[%fp-164],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-168]

	! block 92
.L3105:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 93
.L3106:
	ld	[%fp-100],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 94
.L3107:
	ld	[%fp-108],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 95
.L3108:
	ld	[%fp-116],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 96
.L3109:
	ld	[%fp-124],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 97
.L3110:
.L3111:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L3114
	st	%g0,[%fp-156]

	! block 98
.L3115:
.L3112:
.L3116:
.L3117:
.L3118:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-170]

	! block 99
.L3119:
.L3121:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-170],%l1
	andcc	%l0,%l1,%l0
	be	.L3120
	nop

	! block 100
.L3122:
.L3123:
.L3124:
.L3125:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-172]

	! block 101
.L3126:
	ld	[%fp-40],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-180]

	! block 102
.L3127:
	ld	[%fp-40],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-184]

	! block 103
.L3128:
.L3129:
	ld	[%fp-180],%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	bg	.L3132
	nop

	! block 104
.L3133:
.L3130:
.L3134:
.L3135:
.L3136:
	ld	[%fp-176],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-172],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 105
.L3137:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3138
	nop

	! block 106
.L3139:
.L3140:
.L3141:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 107
.L3142:
.L3143:
.L3138:
.L3144:
.L3145:
.L3146:
.L3147:
	ld	[%fp-176],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	ble	.L3130
	nop

	! block 108
.L3148:
.L3132:
.L3149:
.L3150:
.L3151:
.L3120:
.L3152:
.L3153:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 109
.L3154:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 110
.L3155:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 111
.L3156:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 112
.L3157:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 113
.L3158:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 114
.L3159:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 115
.L3160:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 116
.L3161:
.L3163:
	ld	[%fp-164],%l0
	cmp	%l0,0
	bge	.L3162
	nop

	! block 117
.L3164:
.L3165:
.L3166:
.L3167:
	ld	[%fp-164],%l0
	ld	[%fp-160],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 118
.L3168:
.L3169:
	ba	.L3170
	nop

	! block 119
.L3162:
.L3171:
.L3172:
.L3173:
	ld	[%fp-164],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 120
.L3174:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 121
.L3175:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 122
.L3176:
.L3177:
.L3170:
.L3178:
.L3179:
.L3180:
.L3181:
	ld	[%fp-156],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-156]
	ld	[%fp-156],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L3112
	nop

	! block 123
.L3182:
.L3114:
.L3183:
.L3184:
.L3185:
.L3099:
.L3186:
.L3187:
.L3188:
.L3189:
	ba	.L3190
	nop

	! block 124
.L2929:
.L3191:
.L3192:
.L3193:
.L3195:

! File lines.c:
!  609	      /* stippled */
!  610	#define INTERP_XY 1
!  611	#define INTERP_Z 1
!  612	#define INTERP_RGB 1
!  613	#define INTERP_ALPHA 1
!  614	#define WIDE 1
!  615	#define STIPPLE 1
!  616	#define PLOT(X,Y)			\
!  617		pbx[count] = X;			\
!  618		pby[count] = Y;			\
!  619		pbz[count] = Z;			\
!  620		pbr[count] = FixedToInt(r0);	\
!  621		pbg[count] = FixedToInt(g0);	\
!  622		pbb[count] = FixedToInt(b0);	\
!  623		pba[count] = FixedToInt(a0);	\
!  624		count++;			\
!  625		CHECK_FULL(count);
!  626	#include "linetemp.h"
!  627	   }
!  628	   else {
!  629	      /* unstippled */
!  630	      if (ctx->Line.Width==2.0F) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg8),%l0
	ld	[%l0+%lo(.L_cseg8)],%f4
	fcmps	%f5,%f4
	fbne	.L3194
	nop

	! block 125
.L3196:
.L3197:
.L3198:
.L3199:
.L3200:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 126
.L3201:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-44]

	! block 127
.L3202:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-52]

	! block 128
.L3203:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-96]

	! block 129
.L3204:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-96],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 130
.L3205:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-104]

	! block 131
.L3206:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-104],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 132
.L3207:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-112]

	! block 133
.L3208:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-112],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 134
.L3209:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-120]

	! block 135
.L3210:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-120],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 136
.L3211:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 137
.L3212:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 138
.L3213:
.L3215:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L3214
	nop

	! block 139
.L3216:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L3214
	nop

	! block 140
.L3217:
.L3218:
.L3219:
.L3220:
	ba	.L2916
	nop

	! block 141
.L3221:
.L3222:
.L3214:
.L3223:
.L3224:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 142
.L3225:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-72]

	! block 143
.L3226:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-76]

	! block 144
.L3227:
.L3229:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L3228
	nop

	! block 145
.L3230:
.L3231:
.L3232:
.L3233:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 146
.L3234:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 147
.L3235:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 148
.L3236:
.L3237:
	ba	.L3238
	nop

	! block 149
.L3228:
.L3239:
.L3240:
.L3241:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 150
.L3242:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 151
.L3243:
.L3244:
.L3238:
.L3245:
.L3246:
.L3248:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L3247
	nop

	! block 152
.L3249:
.L3250:
.L3251:
.L3252:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 153
.L3253:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 154
.L3254:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 155
.L3255:
.L3256:
	ba	.L3257
	nop

	! block 156
.L3247:
.L3258:
.L3259:
.L3260:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 157
.L3261:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 158
.L3262:
.L3263:
.L3257:
.L3264:
.L3265:
.L3267:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L3266
	nop

	! block 159
.L3268:
.L3269:
.L3270:
.L3271:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-132]

	! block 160
.L3272:
	ld	[%fp-132],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 161
.L3273:
	ld	[%fp-136],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 162
.L3274:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 163
.L3275:
	ld	[%fp-100],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 164
.L3276:
	ld	[%fp-108],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 165
.L3277:
	ld	[%fp-116],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 166
.L3278:
	ld	[%fp-124],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 167
.L3279:
.L3280:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L3283
	st	%g0,[%fp-128]

	! block 168
.L3284:
.L3281:
.L3285:
.L3286:
.L3287:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-142]

	! block 169
.L3288:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l0
	add	%l0,1,%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 170
.L3289:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 171
.L3290:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 172
.L3291:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 173
.L3292:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 174
.L3293:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 175
.L3294:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 176
.L3295:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 177
.L3296:
.L3298:
	ld	[%fp-136],%l0
	cmp	%l0,0
	bge	.L3297
	nop

	! block 178
.L3299:
.L3300:
.L3301:
.L3302:
	ld	[%fp-136],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 179
.L3303:
.L3304:
	ba	.L3305
	nop

	! block 180
.L3297:
.L3306:
.L3307:
.L3308:
	ld	[%fp-136],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 181
.L3309:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 182
.L3310:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 183
.L3311:
.L3312:
.L3305:
.L3313:
.L3314:
.L3315:
.L3316:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L3281
	nop

	! block 184
.L3317:
.L3283:
.L3318:
.L3319:
.L3320:
	ba	.L3321
	nop

	! block 185
.L3266:
.L3322:
.L3323:
.L3324:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-132]

	! block 186
.L3325:
	ld	[%fp-132],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 187
.L3326:
	ld	[%fp-136],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 188
.L3327:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 189
.L3328:
	ld	[%fp-100],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 190
.L3329:
	ld	[%fp-108],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 191
.L3330:
	ld	[%fp-116],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 192
.L3331:
	ld	[%fp-124],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 193
.L3332:
.L3333:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L3336
	st	%g0,[%fp-128]

	! block 194
.L3337:
.L3334:
.L3338:
.L3339:
.L3340:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-142]

	! block 195
.L3341:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-40],%l0
	add	%l0,1,%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-142],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	stb	%l2,[%l0+1]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 196
.L3342:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 197
.L3343:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 198
.L3344:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 199
.L3345:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 200
.L3346:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 201
.L3347:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 202
.L3348:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 203
.L3349:
.L3351:
	ld	[%fp-136],%l0
	cmp	%l0,0
	bge	.L3350
	nop

	! block 204
.L3352:
.L3353:
.L3354:
.L3355:
	ld	[%fp-136],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 205
.L3356:
.L3357:
	ba	.L3358
	nop

	! block 206
.L3350:
.L3359:
.L3360:
.L3361:
	ld	[%fp-136],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 207
.L3362:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 208
.L3363:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 209
.L3364:
.L3365:
.L3358:
.L3366:
.L3367:
.L3368:
.L3369:
	ld	[%fp-128],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L3334
	nop

	! block 210
.L3370:
.L3336:
.L3371:
.L3372:
.L3373:
.L3321:
.L3374:
.L3375:
.L3376:
.L3377:
	ba	.L3378
	nop

	! block 211
.L3194:
.L3379:
.L3380:
.L3381:
.L3382:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 212
.L3383:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-44]

	! block 213
.L3384:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-52]

	! block 214
.L3385:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-96]

	! block 215
.L3386:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-96],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 216
.L3387:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-104]

	! block 217
.L3388:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-104],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 218
.L3389:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-112]

	! block 219
.L3390:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-112],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 220
.L3391:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-120]

	! block 221
.L3392:
	ld	[%fp-36],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-120],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 222
.L3393:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L3394
	nop

	! block 223
.L3395:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L3396
	std	%f4,[%fp-144]

	! block 224
.L3394:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L3397
	nop

	! block 225
.L3398:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L3399
	std	%f4,[%fp-152]

	! block 226
.L3397:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-152]

	! block 227
.L3399:
	ldd	[%fp-152],%f4
	std	%f4,[%fp-144]

	! block 228
.L3396:
	ldd	[%fp-144],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-128]

	! block 229
.L3400:
	ld	[%fp-128],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-132]

	! block 230
.L3401:
	ld	[%fp-132],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-136]

	! block 231
.L3402:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 232
.L3403:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 233
.L3404:
.L3406:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L3405
	nop

	! block 234
.L3407:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L3405
	nop

	! block 235
.L3408:
.L3409:
.L3410:
.L3411:
	ba	.L2916
	nop

	! block 236
.L3412:
.L3413:
.L3405:
.L3414:
.L3415:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 237
.L3416:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-72]

	! block 238
.L3417:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-188]
	ld	[%fp-188],%l0
	st	%l0,[%fp-76]

	! block 239
.L3418:
.L3420:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L3419
	nop

	! block 240
.L3421:
.L3422:
.L3423:
.L3424:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 241
.L3425:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 242
.L3426:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 243
.L3427:
.L3428:
	ba	.L3429
	nop

	! block 244
.L3419:
.L3430:
.L3431:
.L3432:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 245
.L3433:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 246
.L3434:
.L3435:
.L3429:
.L3436:
.L3437:
.L3439:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L3438
	nop

	! block 247
.L3440:
.L3441:
.L3442:
.L3443:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 248
.L3444:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 249
.L3445:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 250
.L3446:
.L3447:
	ba	.L3448
	nop

	! block 251
.L3438:
.L3449:
.L3450:
.L3451:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 252
.L3452:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 253
.L3453:
.L3454:
.L3448:
.L3455:
.L3456:
.L3458:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L3457
	nop

	! block 254
.L3459:
.L3460:
.L3461:
.L3462:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-160]

	! block 255
.L3463:
	ld	[%fp-160],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 256
.L3464:
	ld	[%fp-164],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-168]

	! block 257
.L3465:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 258
.L3466:
	ld	[%fp-100],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 259
.L3467:
	ld	[%fp-108],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 260
.L3468:
	ld	[%fp-116],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 261
.L3469:
	ld	[%fp-124],%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 262
.L3470:
.L3471:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L3474
	st	%g0,[%fp-156]

	! block 263
.L3475:
.L3472:
.L3476:
.L3477:
.L3478:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-170]

	! block 264
.L3479:
	ld	[%fp-48],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-180]

	! block 265
.L3480:
	ld	[%fp-48],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-184]

	! block 266
.L3481:
.L3482:
	ld	[%fp-180],%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	bg	.L3485
	nop

	! block 267
.L3486:
.L3483:
.L3487:
.L3488:
.L3489:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-176],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-170],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 268
.L3490:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3491
	nop

	! block 269
.L3492:
.L3493:
.L3494:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 270
.L3495:
.L3496:
.L3491:
.L3497:
.L3498:
.L3499:
.L3500:
	ld	[%fp-176],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	ble	.L3483
	nop

	! block 271
.L3501:
.L3485:
.L3502:
.L3503:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 272
.L3504:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 273
.L3505:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 274
.L3506:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 275
.L3507:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 276
.L3508:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 277
.L3509:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 278
.L3510:
.L3512:
	ld	[%fp-164],%l0
	cmp	%l0,0
	bge	.L3511
	nop

	! block 279
.L3513:
.L3514:
.L3515:
.L3516:
	ld	[%fp-164],%l0
	ld	[%fp-160],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 280
.L3517:
.L3518:
	ba	.L3519
	nop

	! block 281
.L3511:
.L3520:
.L3521:
.L3522:
	ld	[%fp-164],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 282
.L3523:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 283
.L3524:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 284
.L3525:
.L3526:
.L3519:
.L3527:
.L3528:
.L3529:
.L3530:
	ld	[%fp-156],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-156]
	ld	[%fp-156],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L3472
	nop

	! block 285
.L3531:
.L3474:
.L3532:
.L3533:
.L3534:
	ba	.L3535
	nop

	! block 286
.L3457:
.L3536:
.L3537:
.L3538:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-160]

	! block 287
.L3539:
	ld	[%fp-160],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 288
.L3540:
	ld	[%fp-164],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-168]

	! block 289
.L3541:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 290
.L3542:
	ld	[%fp-100],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-100]

	! block 291
.L3543:
	ld	[%fp-108],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-108]

	! block 292
.L3544:
	ld	[%fp-116],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-116]

	! block 293
.L3545:
	ld	[%fp-124],%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-124]

	! block 294
.L3546:
.L3547:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L3550
	st	%g0,[%fp-156]

	! block 295
.L3551:
.L3548:
.L3552:
.L3553:
.L3554:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-170]

	! block 296
.L3555:
	ld	[%fp-40],%l0
	ld	[%fp-132],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-180]

	! block 297
.L3556:
	ld	[%fp-40],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-184]

	! block 298
.L3557:
.L3558:
	ld	[%fp-180],%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	bg	.L3561
	nop

	! block 299
.L3562:
.L3559:
.L3563:
.L3564:
.L3565:
	ld	[%fp-176],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-170],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%l0
	sra	%l0,11,%l2
	ld	[%fp-20],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-104],%l0
	sra	%l0,11,%l2
	ld	[%fp-24],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-112],%l0
	sra	%l0,11,%l2
	ld	[%fp-28],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-120],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 300
.L3566:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3567
	nop

	! block 301
.L3568:
.L3569:
.L3570:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 302
.L3571:
.L3572:
.L3567:
.L3573:
.L3574:
.L3575:
.L3576:
	ld	[%fp-176],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-176]
	ld	[%fp-176],%l1
	ld	[%fp-184],%l0
	cmp	%l1,%l0
	ble	.L3559
	nop

	! block 303
.L3577:
.L3561:
.L3578:
.L3579:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 304
.L3580:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 305
.L3581:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 306
.L3582:
	ld	[%fp-96],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 307
.L3583:
	ld	[%fp-104],%l0
	ld	[%fp-108],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 308
.L3584:
	ld	[%fp-112],%l0
	ld	[%fp-116],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 309
.L3585:
	ld	[%fp-120],%l0
	ld	[%fp-124],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 310
.L3586:
.L3588:
	ld	[%fp-164],%l0
	cmp	%l0,0
	bge	.L3587
	nop

	! block 311
.L3589:
.L3590:
.L3591:
.L3592:
	ld	[%fp-164],%l0
	ld	[%fp-160],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 312
.L3593:
.L3594:
	ba	.L3595
	nop

	! block 313
.L3587:
.L3596:
.L3597:
.L3598:
	ld	[%fp-164],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-164]

	! block 314
.L3599:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 315
.L3600:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 316
.L3601:
.L3602:
.L3595:
.L3603:
.L3604:
.L3605:
.L3606:
	ld	[%fp-156],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-156]
	ld	[%fp-156],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L3548
	nop

	! block 317
.L3607:
.L3550:
.L3608:
.L3609:
.L3610:
.L3535:
.L3611:
.L3612:
.L3613:
.L3614:
.L3378:
.L3615:
.L3616:
.L3617:
.L3190:
.L3618:
.L3619:

! File lines.c:
!  631	         /* special case: unstippled and width=2 */
!  632	#define INTERP_XY 1
!  633	#define INTERP_Z 1
!  634	#define INTERP_RGB 1
!  635	#define INTERP_ALPHA 1
!  636	#define XMAJOR_PLOT(X,Y)						\
!  637		pbx[count] = X;  pbx[count+1] = X;				\
!  638		pby[count] = Y;  pby[count+1] = Y+1;				\
!  639		pbz[count] = Z;  pbz[count+1] = Z;				\
!  640		pbr[count] = FixedToInt(r0);  pbr[count+1] = FixedToInt(r0);	\
!  641		pbg[count] = FixedToInt(g0);  pbg[count+1] = FixedToInt(g0);	\
!  642		pbb[count] = FixedToInt(b0);  pbb[count+1] = FixedToInt(b0);	\
!  643		pba[count] = FixedToInt(a0);  pba[count+1] = FixedToInt(a0);	\
!  644		count += 2;
!  645	#define YMAJOR_PLOT(X,Y)						\
!  646		pbx[count] = X;  pbx[count+1] = X+1;				\
!  647		pby[count] = Y;  pby[count+1] = Y;				\
!  648		pbz[count] = Z;  pbz[count+1] = Z;				\
!  649		pbr[count] = FixedToInt(r0);  pbr[count+1] = FixedToInt(r0);	\
!  650		pbg[count] = FixedToInt(g0);  pbg[count+1] = FixedToInt(g0);	\
!  651		pbb[count] = FixedToInt(b0);  pbb[count+1] = FixedToInt(b0);	\
!  652		pba[count] = FixedToInt(a0);  pba[count+1] = FixedToInt(a0);	\
!  653		count += 2;
!  654	#include "linetemp.h"
!  655	      }
!  656	      else {
!  657	         /* unstippled, any width */
!  658	#define INTERP_XY 1
!  659	#define INTERP_Z 1
!  660	#define INTERP_RGB 1
!  661	#define INTERP_ALPHA 1
!  662	#define WIDE 1
!  663	#define PLOT(X,Y)			\
!  664		pbx[count] = X;			\
!  665		pby[count] = Y;			\
!  666		pbz[count] = Z;			\
!  667		pbr[count] = FixedToInt(r0);	\
!  668		pbg[count] = FixedToInt(g0);	\
!  669		pbb[count] = FixedToInt(b0);	\
!  670		pba[count] = FixedToInt(a0);	\
!  671		count++;			\
!  672		CHECK_FULL(count);
!  673	#include "linetemp.h"
!  674	      }
!  675	   }
!  676	
!  677	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 318
.L3620:
.L3622:

!  678	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L3621
	nop

	! block 319
.L3623:
.L3624:
.L3625:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 320
.L3626:
.L3627:
.L3621:
.L3628:

	! block 321
.L3629:
.L3630:
.L2916:
	jmp	%i7+8
	restore
	.size	general_smooth_rgba_line,(.-general_smooth_rgba_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	general_flat_rgba_line,#function
general_flat_rgba_line:
	save	%sp,-248,%sp

	! block 1
.L3633:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L3634:
.L3636:

! File lines.c:
!  679	}
!  680	
!  682	static void general_flat_rgba_line( GLcontext *ctx,
!  683	                                    GLuint vert0, GLuint vert1, GLuint pvert )
!  684	{
!  685	   GLint count;
!  686	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L3637:

!  687	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L3638:

!  688	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L3639:

!  689	   GLubyte *color = ctx->VB->Color[pvert];

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 6
.L3640:
.L3642:

!  690	   PB_SET_COLOR( ctx, ctx->PB, color[0], color[1], color[2], color[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+0],%l0
	cmp	%l1,%l0
	bne	.L3643
	nop

	! block 7
.L3644:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+1],%l0
	cmp	%l1,%l0
	bne	.L3643
	nop

	! block 8
.L3645:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+2],%l0
	cmp	%l1,%l0
	bne	.L3643
	nop

	! block 9
.L3646:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-20],%l0
	ldub	[%l0+3],%l0
	cmp	%l1,%l0
	bne	.L3643
	nop

	! block 10
.L3647:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L3641
	nop

	! block 11
.L3648:
.L3643:
.L3649:
.L3650:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 12
.L3651:
.L3652:
.L3641:
.L3653:
	ld	[%fp-20],%l0
	ldub	[%l0+0],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+1],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+2],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-20],%l0
	ldub	[%l0+3],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	st	%l3,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 13
.L3654:

!  691	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 14
.L3655:
.L3657:

!  693	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L3656
	nop

	! block 15
.L3658:
.L3659:
.L3660:
.L3661:
.L3662:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 16
.L3663:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-32]

	! block 17
.L3664:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-40]

	! block 18
.L3665:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L3666
	nop

	! block 19
.L3667:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L3668
	std	%f4,[%fp-104]

	! block 20
.L3666:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L3669
	nop

	! block 21
.L3670:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L3671
	std	%f4,[%fp-112]

	! block 22
.L3669:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-112]

	! block 23
.L3671:
	ldd	[%fp-112],%f4
	std	%f4,[%fp-104]

	! block 24
.L3668:
	ldd	[%fp-104],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-84]

	! block 25
.L3672:
	ld	[%fp-84],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 26
.L3673:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-92]

	! block 27
.L3674:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 28
.L3675:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 29
.L3676:
.L3678:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L3677
	nop

	! block 30
.L3679:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L3677
	nop

	! block 31
.L3680:
.L3681:
.L3682:
.L3683:
	ba	.L3632
	nop

	! block 32
.L3684:
.L3685:
.L3677:
.L3686:
.L3687:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 33
.L3688:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-60]

	! block 34
.L3689:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-64]

	! block 35
.L3690:
.L3692:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L3691
	nop

	! block 36
.L3693:
.L3694:
.L3695:
.L3696:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 37
.L3697:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 38
.L3698:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 39
.L3699:
.L3700:
	ba	.L3701
	nop

	! block 40
.L3691:
.L3702:
.L3703:
.L3704:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 41
.L3705:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 42
.L3706:
.L3707:
.L3701:
.L3708:
.L3709:
.L3711:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L3710
	nop

	! block 43
.L3712:
.L3713:
.L3714:
.L3715:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 44
.L3716:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 45
.L3717:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 46
.L3718:
.L3719:
	ba	.L3720
	nop

	! block 47
.L3710:
.L3721:
.L3722:
.L3723:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 48
.L3724:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 49
.L3725:
.L3726:
.L3720:
.L3727:
.L3728:
.L3730:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L3729
	nop

	! block 50
.L3731:
.L3732:
.L3733:
.L3734:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-120]

	! block 51
.L3735:
	ld	[%fp-120],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 52
.L3736:
	ld	[%fp-124],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 53
.L3737:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 54
.L3738:
.L3739:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L3742
	st	%g0,[%fp-116]

	! block 55
.L3743:
.L3740:
.L3744:
.L3745:
.L3746:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-130]

	! block 56
.L3747:
.L3749:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-130],%l1
	andcc	%l0,%l1,%l0
	be	.L3748
	nop

	! block 57
.L3750:
.L3751:
.L3752:
.L3753:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-132]

	! block 58
.L3754:
	ld	[%fp-36],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 59
.L3755:
	ld	[%fp-36],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-144]

	! block 60
.L3756:
.L3757:
	ld	[%fp-140],%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	bg	.L3760
	nop

	! block 61
.L3761:
.L3758:
.L3762:
.L3763:
.L3764:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-136],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-132],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 62
.L3765:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3766
	nop

	! block 63
.L3767:
.L3768:
.L3769:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 64
.L3770:
.L3771:
.L3766:
.L3772:
.L3773:
.L3774:
.L3775:
	ld	[%fp-136],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	ble	.L3758
	nop

	! block 65
.L3776:
.L3760:
.L3777:
.L3778:
.L3779:
.L3748:
.L3780:
.L3781:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 66
.L3782:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 67
.L3783:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 68
.L3784:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 69
.L3785:
.L3787:
	ld	[%fp-124],%l0
	cmp	%l0,0
	bge	.L3786
	nop

	! block 70
.L3788:
.L3789:
.L3790:
.L3791:
	ld	[%fp-124],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 71
.L3792:
.L3793:
	ba	.L3794
	nop

	! block 72
.L3786:
.L3795:
.L3796:
.L3797:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 73
.L3798:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 74
.L3799:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 75
.L3800:
.L3801:
.L3794:
.L3802:
.L3803:
.L3804:
.L3805:
	ld	[%fp-116],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L3740
	nop

	! block 76
.L3806:
.L3742:
.L3807:
.L3808:
.L3809:
	ba	.L3810
	nop

	! block 77
.L3729:
.L3811:
.L3812:
.L3813:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-120]

	! block 78
.L3814:
	ld	[%fp-120],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 79
.L3815:
	ld	[%fp-124],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 80
.L3816:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 81
.L3817:
.L3818:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L3821
	st	%g0,[%fp-116]

	! block 82
.L3822:
.L3819:
.L3823:
.L3824:
.L3825:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-130]

	! block 83
.L3826:
.L3828:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-130],%l1
	andcc	%l0,%l1,%l0
	be	.L3827
	nop

	! block 84
.L3829:
.L3830:
.L3831:
.L3832:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-132]

	! block 85
.L3833:
	ld	[%fp-28],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 86
.L3834:
	ld	[%fp-28],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-144]

	! block 87
.L3835:
.L3836:
	ld	[%fp-140],%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	bg	.L3839
	nop

	! block 88
.L3840:
.L3837:
.L3841:
.L3842:
.L3843:
	ld	[%fp-136],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-132],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 89
.L3844:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L3845
	nop

	! block 90
.L3846:
.L3847:
.L3848:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 91
.L3849:
.L3850:
.L3845:
.L3851:
.L3852:
.L3853:
.L3854:
	ld	[%fp-136],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	ble	.L3837
	nop

	! block 92
.L3855:
.L3839:
.L3856:
.L3857:
.L3858:
.L3827:
.L3859:
.L3860:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 93
.L3861:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 94
.L3862:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 95
.L3863:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 96
.L3864:
.L3866:
	ld	[%fp-124],%l0
	cmp	%l0,0
	bge	.L3865
	nop

	! block 97
.L3867:
.L3868:
.L3869:
.L3870:
	ld	[%fp-124],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 98
.L3871:
.L3872:
	ba	.L3873
	nop

	! block 99
.L3865:
.L3874:
.L3875:
.L3876:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 100
.L3877:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 101
.L3878:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 102
.L3879:
.L3880:
.L3873:
.L3881:
.L3882:
.L3883:
.L3884:
	ld	[%fp-116],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L3819
	nop

	! block 103
.L3885:
.L3821:
.L3886:
.L3887:
.L3888:
.L3810:
.L3889:
.L3890:
.L3891:
.L3892:
	ba	.L3893
	nop

	! block 104
.L3656:
.L3894:
.L3895:
.L3896:
.L3898:

! File lines.c:
!  694	      /* stippled */
!  695	#define INTERP_XY 1
!  696	#define INTERP_Z 1
!  697	#define WIDE 1
!  698	#define STIPPLE 1
!  699	#define PLOT(X,Y)			\
!  700		pbx[count] = X;			\
!  701		pby[count] = Y;			\
!  702		pbz[count] = Z;			\
!  703		count++;			\
!  704		CHECK_FULL(count);
!  705	#include "linetemp.h"
!  706	   }
!  707	   else {
!  708	      /* unstippled */
!  709	      if (ctx->Line.Width==2.0F) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg8),%l0
	ld	[%l0+%lo(.L_cseg8)],%f4
	fcmps	%f5,%f4
	fbne	.L3897
	nop

	! block 105
.L3899:
.L3900:
.L3901:
.L3902:
.L3903:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 106
.L3904:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-32]

	! block 107
.L3905:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-40]

	! block 108
.L3906:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 109
.L3907:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 110
.L3908:
.L3910:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L3909
	nop

	! block 111
.L3911:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L3909
	nop

	! block 112
.L3912:
.L3913:
.L3914:
.L3915:
	ba	.L3632
	nop

	! block 113
.L3916:
.L3917:
.L3909:
.L3918:
.L3919:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 114
.L3920:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-60]

	! block 115
.L3921:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-64]

	! block 116
.L3922:
.L3924:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L3923
	nop

	! block 117
.L3925:
.L3926:
.L3927:
.L3928:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 118
.L3929:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 119
.L3930:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 120
.L3931:
.L3932:
	ba	.L3933
	nop

	! block 121
.L3923:
.L3934:
.L3935:
.L3936:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 122
.L3937:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 123
.L3938:
.L3939:
.L3933:
.L3940:
.L3941:
.L3943:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L3942
	nop

	! block 124
.L3944:
.L3945:
.L3946:
.L3947:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 125
.L3948:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 126
.L3949:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 127
.L3950:
.L3951:
	ba	.L3952
	nop

	! block 128
.L3942:
.L3953:
.L3954:
.L3955:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 129
.L3956:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 130
.L3957:
.L3958:
.L3952:
.L3959:
.L3960:
.L3962:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L3961
	nop

	! block 131
.L3963:
.L3964:
.L3965:
.L3966:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-88]

	! block 132
.L3967:
	ld	[%fp-88],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 133
.L3968:
	ld	[%fp-92],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 134
.L3969:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 135
.L3970:
.L3971:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L3974
	st	%g0,[%fp-84]

	! block 136
.L3975:
.L3972:
.L3976:
.L3977:
.L3978:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-98]

	! block 137
.L3979:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l0
	add	%l0,1,%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 138
.L3980:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 139
.L3981:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 140
.L3982:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 141
.L3983:
.L3985:
	ld	[%fp-92],%l0
	cmp	%l0,0
	bge	.L3984
	nop

	! block 142
.L3986:
.L3987:
.L3988:
.L3989:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 143
.L3990:
.L3991:
	ba	.L3992
	nop

	! block 144
.L3984:
.L3993:
.L3994:
.L3995:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 145
.L3996:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 146
.L3997:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 147
.L3998:
.L3999:
.L3992:
.L4000:
.L4001:
.L4002:
.L4003:
	ld	[%fp-84],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L3972
	nop

	! block 148
.L4004:
.L3974:
.L4005:
.L4006:
.L4007:
	ba	.L4008
	nop

	! block 149
.L3961:
.L4009:
.L4010:
.L4011:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-88]

	! block 150
.L4012:
	ld	[%fp-88],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 151
.L4013:
	ld	[%fp-92],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-96]

	! block 152
.L4014:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 153
.L4015:
.L4016:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L4019
	st	%g0,[%fp-84]

	! block 154
.L4020:
.L4017:
.L4021:
.L4022:
.L4023:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-98]

	! block 155
.L4024:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-28],%l0
	add	%l0,1,%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+4]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	lduh	[%fp-98],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	sth	%l3,[%l0+2]
	ld	[%fp-4],%l0
	add	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 156
.L4025:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 157
.L4026:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 158
.L4027:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 159
.L4028:
.L4030:
	ld	[%fp-92],%l0
	cmp	%l0,0
	bge	.L4029
	nop

	! block 160
.L4031:
.L4032:
.L4033:
.L4034:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 161
.L4035:
.L4036:
	ba	.L4037
	nop

	! block 162
.L4029:
.L4038:
.L4039:
.L4040:
	ld	[%fp-92],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 163
.L4041:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 164
.L4042:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 165
.L4043:
.L4044:
.L4037:
.L4045:
.L4046:
.L4047:
.L4048:
	ld	[%fp-84],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L4017
	nop

	! block 166
.L4049:
.L4019:
.L4050:
.L4051:
.L4052:
.L4008:
.L4053:
.L4054:
.L4055:
.L4056:
	ba	.L4057
	nop

	! block 167
.L3897:
.L4058:
.L4059:
.L4060:
.L4061:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-24]

	! block 168
.L4062:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-28]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-32]

	! block 169
.L4063:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-36]
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-40]

	! block 170
.L4064:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L4065
	nop

	! block 171
.L4066:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L4067
	std	%f4,[%fp-104]

	! block 172
.L4065:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L4068
	nop

	! block 173
.L4069:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L4070
	std	%f4,[%fp-112]

	! block 174
.L4068:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-112]

	! block 175
.L4070:
	ldd	[%fp-112],%f4
	std	%f4,[%fp-104]

	! block 176
.L4067:
	ldd	[%fp-104],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-84]

	! block 177
.L4071:
	ld	[%fp-84],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 178
.L4072:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-92]

	! block 179
.L4073:
	ld	[%fp-32],%l0
	ld	[%fp-28],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 180
.L4074:
	ld	[%fp-40],%l0
	ld	[%fp-36],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 181
.L4075:
.L4077:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bne	.L4076
	nop

	! block 182
.L4078:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bne	.L4076
	nop

	! block 183
.L4079:
.L4080:
.L4081:
.L4082:
	ba	.L3632
	nop

	! block 184
.L4083:
.L4084:
.L4076:
.L4085:
.L4086:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-36],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-28],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-80]

	! block 185
.L4087:
	ld	[%fp-24],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-60]

	! block 186
.L4088:
	ld	[%fp-24],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-148]
	ld	[%fp-148],%l0
	st	%l0,[%fp-64]

	! block 187
.L4089:
.L4091:
	ld	[%fp-44],%l0
	cmp	%l0,0
	bge	.L4090
	nop

	! block 188
.L4092:
.L4093:
.L4094:
.L4095:
	ld	[%fp-44],%l0
	neg	%l0,%l0
	st	%l0,[%fp-44]

	! block 189
.L4096:
	mov	-1,%l0
	st	%l0,[%fp-52]

	! block 190
.L4097:
	mov	-2,%l0
	st	%l0,[%fp-72]

	! block 191
.L4098:
.L4099:
	ba	.L4100
	nop

	! block 192
.L4090:
.L4101:
.L4102:
.L4103:
	mov	1,%l0
	st	%l0,[%fp-52]

	! block 193
.L4104:
	mov	2,%l0
	st	%l0,[%fp-72]

	! block 194
.L4105:
.L4106:
.L4100:
.L4107:
.L4108:
.L4110:
	ld	[%fp-48],%l0
	cmp	%l0,0
	bge	.L4109
	nop

	! block 195
.L4111:
.L4112:
.L4113:
.L4114:
	ld	[%fp-48],%l0
	neg	%l0,%l0
	st	%l0,[%fp-48]

	! block 196
.L4115:
	mov	-1,%l0
	st	%l0,[%fp-56]

	! block 197
.L4116:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 198
.L4117:
.L4118:
	ba	.L4119
	nop

	! block 199
.L4109:
.L4120:
.L4121:
.L4122:
	mov	1,%l0
	st	%l0,[%fp-56]

	! block 200
.L4123:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 201
.L4124:
.L4125:
.L4119:
.L4126:
.L4127:
.L4129:
	ld	[%fp-44],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	ble	.L4128
	nop

	! block 202
.L4130:
.L4131:
.L4132:
.L4133:
	ld	[%fp-48],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-120]

	! block 203
.L4134:
	ld	[%fp-120],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 204
.L4135:
	ld	[%fp-124],%l0
	ld	[%fp-44],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 205
.L4136:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-44],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 206
.L4137:
.L4138:
	ld	[%fp-44],%l0
	cmp	%g0,%l0
	bge	.L4141
	st	%g0,[%fp-116]

	! block 207
.L4142:
.L4139:
.L4143:
.L4144:
.L4145:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-130]

	! block 208
.L4146:
	ld	[%fp-36],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 209
.L4147:
	ld	[%fp-36],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-144]

	! block 210
.L4148:
.L4149:
	ld	[%fp-140],%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	bg	.L4152
	nop

	! block 211
.L4153:
.L4150:
.L4154:
.L4155:
.L4156:
	ld	[%fp-28],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-136],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-130],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 212
.L4157:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4158
	nop

	! block 213
.L4159:
.L4160:
.L4161:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 214
.L4162:
.L4163:
.L4158:
.L4164:
.L4165:
.L4166:
.L4167:
	ld	[%fp-136],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	ble	.L4150
	nop

	! block 215
.L4168:
.L4152:
.L4169:
.L4170:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 216
.L4171:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 217
.L4172:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 218
.L4173:
.L4175:
	ld	[%fp-124],%l0
	cmp	%l0,0
	bge	.L4174
	nop

	! block 219
.L4176:
.L4177:
.L4178:
.L4179:
	ld	[%fp-124],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 220
.L4180:
.L4181:
	ba	.L4182
	nop

	! block 221
.L4174:
.L4183:
.L4184:
.L4185:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 222
.L4186:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 223
.L4187:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 224
.L4188:
.L4189:
.L4182:
.L4190:
.L4191:
.L4192:
.L4193:
	ld	[%fp-116],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%l1
	ld	[%fp-44],%l0
	cmp	%l1,%l0
	bl	.L4139
	nop

	! block 225
.L4194:
.L4141:
.L4195:
.L4196:
.L4197:
	ba	.L4198
	nop

	! block 226
.L4128:
.L4199:
.L4200:
.L4201:
	ld	[%fp-44],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-120]

	! block 227
.L4202:
	ld	[%fp-120],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 228
.L4203:
	ld	[%fp-124],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 229
.L4204:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-48],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-68]

	! block 230
.L4205:
.L4206:
	ld	[%fp-48],%l0
	cmp	%g0,%l0
	bge	.L4209
	st	%g0,[%fp-116]

	! block 231
.L4210:
.L4207:
.L4211:
.L4212:
.L4213:
	ld	[%fp-60],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-130]

	! block 232
.L4214:
	ld	[%fp-28],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-140]

	! block 233
.L4215:
	ld	[%fp-28],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-144]

	! block 234
.L4216:
.L4217:
	ld	[%fp-140],%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	bg	.L4220
	nop

	! block 235
.L4221:
.L4218:
.L4222:
.L4223:
.L4224:
	ld	[%fp-136],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-36],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-130],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 236
.L4225:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4226
	nop

	! block 237
.L4227:
.L4228:
.L4229:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 238
.L4230:
.L4231:
.L4226:
.L4232:
.L4233:
.L4234:
.L4235:
	ld	[%fp-136],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp-144],%l0
	cmp	%l1,%l0
	ble	.L4218
	nop

	! block 239
.L4236:
.L4220:
.L4237:
.L4238:
	ld	[%fp-36],%l0
	ld	[%fp-56],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 240
.L4239:
	ld	[%fp-80],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 241
.L4240:
	ld	[%fp-60],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 242
.L4241:
.L4243:
	ld	[%fp-124],%l0
	cmp	%l0,0
	bge	.L4242
	nop

	! block 243
.L4244:
.L4245:
.L4246:
.L4247:
	ld	[%fp-124],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 244
.L4248:
.L4249:
	ba	.L4250
	nop

	! block 245
.L4242:
.L4251:
.L4252:
.L4253:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 246
.L4254:
	ld	[%fp-28],%l0
	ld	[%fp-52],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 247
.L4255:
	ld	[%fp-80],%l0
	ld	[%fp-72],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-80]

	! block 248
.L4256:
.L4257:
.L4250:
.L4258:
.L4259:
.L4260:
.L4261:
	ld	[%fp-116],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%l1
	ld	[%fp-48],%l0
	cmp	%l1,%l0
	bl	.L4207
	nop

	! block 249
.L4262:
.L4209:
.L4263:
.L4264:
.L4265:
.L4198:
.L4266:
.L4267:
.L4268:
.L4269:
.L4057:
.L4270:
.L4271:
.L4272:
.L3893:
.L4273:
.L4274:

! File lines.c:
!  710	         /* special case: unstippled and width=2 */
!  711	#define INTERP_XY 1
!  712	#define INTERP_Z 1
!  713	#define XMAJOR_PLOT(X,Y)			\
!  714		pbx[count] = X;  pbx[count+1] = X;	\
!  715		pby[count] = Y;  pby[count+1] = Y+1;	\
!  716		pbz[count] = Z;  pbz[count+1] = Z;	\
!  717		count += 2;
!  718	#define YMAJOR_PLOT(X,Y)			\
!  719		pbx[count] = X;  pbx[count+1] = X+1;	\
!  720		pby[count] = Y;  pby[count+1] = Y;	\
!  721		pbz[count] = Z;  pbz[count+1] = Z;	\
!  722		count += 2;
!  723	#include "linetemp.h"
!  724	      }
!  725	      else {
!  726	         /* unstippled, any width */
!  727	#define INTERP_XY 1
!  728	#define INTERP_Z 1
!  729	#define WIDE 1
!  730	#define PLOT(X,Y)			\
!  731		pbx[count] = X;			\
!  732		pby[count] = Y;			\
!  733		pbz[count] = Z;			\
!  734		count++;			\
!  735		CHECK_FULL(count);
!  736	#include "linetemp.h"
!  737	      }
!  738	   }
!  739	
!  740	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 250
.L4275:
.L4277:

!  741	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L4276
	nop

	! block 251
.L4278:
.L4279:
.L4280:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 252
.L4281:
.L4282:
.L4276:
.L4283:

	! block 253
.L4284:
.L4285:
.L3632:
	jmp	%i7+8
	restore
	.size	general_flat_rgba_line,(.-general_flat_rgba_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	flat_textured_line,#function
flat_textured_line:
	save	%sp,-296,%sp

	! block 1
.L4288:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L4289:
.L4291:

! File lines.c:
!  742	}
!  743	
!  746	/* Flat-shaded, textured, any width, maybe stippled */
!  747	static void flat_textured_line( GLcontext *ctx,
!  748	                                GLuint vert0, GLuint vert1, GLuint pv )
!  749	{
!  750	   GLint count;
!  751	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 3
.L4292:

!  752	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 4
.L4293:

!  753	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 5
.L4294:

!  754	   GLfloat *pbs = ctx->PB->s;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x15180),%l1
	or	%l1,%lo(0x15180),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 6
.L4295:

!  755	   GLfloat *pbt = ctx->PB->t;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x19c80),%l1
	or	%l1,%lo(0x19c80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 7
.L4296:

!  756	   GLfloat *pbu = ctx->PB->u;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x1e780),%l1
	or	%l1,%lo(0x1e780),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 8
.L4297:

!  757	   GLubyte *color = ctx->VB->Color[pv];

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-32]

	! block 9
.L4298:
.L4300:

!  758	   PB_SET_COLOR( ctx, ctx->PB, color[0], color[1], color[2], color[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-32],%l0
	ldub	[%l0+0],%l0
	cmp	%l1,%l0
	bne	.L4301
	nop

	! block 10
.L4302:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-32],%l0
	ldub	[%l0+1],%l0
	cmp	%l1,%l0
	bne	.L4301
	nop

	! block 11
.L4303:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-32],%l0
	ldub	[%l0+2],%l0
	cmp	%l1,%l0
	bne	.L4301
	nop

	! block 12
.L4304:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp-32],%l0
	ldub	[%l0+3],%l0
	cmp	%l1,%l0
	bne	.L4301
	nop

	! block 13
.L4305:
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L4299
	nop

	! block 14
.L4306:
.L4301:
.L4307:
.L4308:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 15
.L4309:
.L4310:
.L4299:
.L4311:
	ld	[%fp-32],%l0
	ldub	[%l0+0],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l2
	or	%l2,%lo(0xe138),%l2
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d80),%l1
	or	%l1,%lo(0x27d80),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-32],%l0
	ldub	[%l0+1],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d84),%l1
	or	%l1,%lo(0x27d84),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-32],%l0
	ldub	[%l0+2],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d88),%l1
	or	%l1,%lo(0x27d88),%l1
	st	%l3,[%l0+%l1]
	ld	[%fp-32],%l0
	ldub	[%l0+3],%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d8c),%l1
	or	%l1,%lo(0x27d8c),%l1
	st	%l3,[%l0+%l1]
	mov	1,%l3
	ld	[%fp+68],%l0
	ld	[%l0+%l2],%l0
	sethi	%hi(0x27d98),%l1
	or	%l1,%lo(0x27d98),%l1
	stb	%l3,[%l0+%l1]

	! block 16
.L4312:

!  759	   count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 17
.L4313:
.L4315:

!  761	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L4314
	nop

	! block 18
.L4316:
.L4317:
.L4318:
.L4319:
.L4320:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 19
.L4321:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-44]

	! block 20
.L4322:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-52]

	! block 21
.L4323:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l3
	or	%l3,%lo(0xaf40),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-96]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-96],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 22
.L4324:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l3
	or	%l3,%lo(0xaf44),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-104]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-104],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 23
.L4325:
	sethi	%hi(.L_cseg3),%l3
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l5
	or	%l5,%lo(0x3f0c),%l5
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-112]
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f5
	ld	[%fp-112],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 24
.L4326:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l3
	or	%l3,%lo(0xaf48),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-120]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-120],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 25
.L4327:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l3
	or	%l3,%lo(0xaf4c),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-128]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-128],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 26
.L4328:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L4329
	nop

	! block 27
.L4330:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L4331
	std	%f4,[%fp-152]

	! block 28
.L4329:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L4332
	nop

	! block 29
.L4333:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L4334
	std	%f4,[%fp-160]

	! block 30
.L4332:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-160]

	! block 31
.L4334:
	ldd	[%fp-160],%f4
	std	%f4,[%fp-152]

	! block 32
.L4331:
	ldd	[%fp-152],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-136]

	! block 33
.L4335:
	ld	[%fp-136],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-140]

	! block 34
.L4336:
	ld	[%fp-140],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-144]

	! block 35
.L4337:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 36
.L4338:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 37
.L4339:
.L4341:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L4340
	nop

	! block 38
.L4342:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L4340
	nop

	! block 39
.L4343:
.L4344:
.L4345:
.L4346:
	ba	.L4287
	nop

	! block 40
.L4347:
.L4348:
.L4340:
.L4349:
.L4350:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 41
.L4351:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-72]

	! block 42
.L4352:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-76]

	! block 43
.L4353:
.L4355:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L4354
	nop

	! block 44
.L4356:
.L4357:
.L4358:
.L4359:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 45
.L4360:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 46
.L4361:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 47
.L4362:
.L4363:
	ba	.L4364
	nop

	! block 48
.L4354:
.L4365:
.L4366:
.L4367:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 49
.L4368:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 50
.L4369:
.L4370:
.L4364:
.L4371:
.L4372:
.L4374:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L4373
	nop

	! block 51
.L4375:
.L4376:
.L4377:
.L4378:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 52
.L4379:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 53
.L4380:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 54
.L4381:
.L4382:
	ba	.L4383
	nop

	! block 55
.L4373:
.L4384:
.L4385:
.L4386:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 56
.L4387:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 57
.L4388:
.L4389:
.L4383:
.L4390:
.L4391:
.L4393:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L4392
	nop

	! block 58
.L4394:
.L4395:
.L4396:
.L4397:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-168]

	! block 59
.L4398:
	ld	[%fp-168],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 60
.L4399:
	ld	[%fp-172],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-176]

	! block 61
.L4400:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 62
.L4401:
.L4402:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-56],%l0
	st	%l0,[%fp-196]
	ld	[%fp-196],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-180]

	! block 63
.L4403:
	ld	[%fp-100],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 64
.L4404:
	ld	[%fp-108],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 65
.L4405:
	ld	[%fp-116],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 66
.L4406:
	ld	[%fp-124],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 67
.L4407:
	ld	[%fp-132],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 68
.L4408:
.L4409:
.L4410:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L4413
	st	%g0,[%fp-164]

	! block 69
.L4414:
.L4411:
.L4415:
.L4416:
.L4417:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-178]

	! block 70
.L4418:
.L4420:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-178],%l1
	andcc	%l0,%l1,%l0
	be	.L4419
	nop

	! block 71
.L4421:
.L4422:
.L4423:
.L4424:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-180]

	! block 72
.L4425:
	ld	[%fp-48],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-188]

	! block 73
.L4426:
	ld	[%fp-48],%l0
	ld	[%fp-144],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-192]

	! block 74
.L4427:
.L4428:
	ld	[%fp-188],%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	bg	.L4431
	nop

	! block 75
.L4432:
.L4429:
.L4433:
.L4434:
.L4435:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-184],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-180],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-104],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-120],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 76
.L4436:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4437
	nop

	! block 77
.L4438:
.L4439:
.L4440:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 78
.L4441:
.L4442:
.L4437:
.L4443:
.L4444:
.L4445:
.L4446:
	ld	[%fp-184],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	ble	.L4429
	nop

	! block 79
.L4447:
.L4431:
.L4448:
.L4449:
.L4450:
.L4419:
.L4451:
.L4452:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 80
.L4453:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 81
.L4454:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 82
.L4455:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 83
.L4456:
	ld	[%fp-96],%f5
	ld	[%fp-100],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-96]

	! block 84
.L4457:
	ld	[%fp-104],%f5
	ld	[%fp-108],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-104]

	! block 85
.L4458:
	ld	[%fp-112],%f5
	ld	[%fp-116],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-112]

	! block 86
.L4459:
	ld	[%fp-120],%f5
	ld	[%fp-124],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-120]

	! block 87
.L4460:
	ld	[%fp-128],%f5
	ld	[%fp-132],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-128]

	! block 88
.L4461:
.L4463:
	ld	[%fp-172],%l0
	cmp	%l0,0
	bge	.L4462
	nop

	! block 89
.L4464:
.L4465:
.L4466:
.L4467:
	ld	[%fp-172],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 90
.L4468:
.L4469:
	ba	.L4470
	nop

	! block 91
.L4462:
.L4471:
.L4472:
.L4473:
	ld	[%fp-172],%l0
	ld	[%fp-176],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 92
.L4474:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 93
.L4475:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 94
.L4476:
.L4477:
.L4470:
.L4478:
.L4479:
.L4480:
.L4481:
	ld	[%fp-164],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-164]
	ld	[%fp-164],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L4411
	nop

	! block 95
.L4482:
.L4413:
.L4483:
.L4484:
.L4485:
	ba	.L4486
	nop

	! block 96
.L4392:
.L4487:
.L4488:
.L4489:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-168]

	! block 97
.L4490:
	ld	[%fp-168],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 98
.L4491:
	ld	[%fp-172],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-176]

	! block 99
.L4492:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 100
.L4493:
.L4494:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-60],%l0
	st	%l0,[%fp-196]
	ld	[%fp-196],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-180]

	! block 101
.L4495:
	ld	[%fp-100],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 102
.L4496:
	ld	[%fp-108],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 103
.L4497:
	ld	[%fp-116],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 104
.L4498:
	ld	[%fp-124],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 105
.L4499:
	ld	[%fp-132],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 106
.L4500:
.L4501:
.L4502:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L4505
	st	%g0,[%fp-164]

	! block 107
.L4506:
.L4503:
.L4507:
.L4508:
.L4509:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-178]

	! block 108
.L4510:
.L4512:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-178],%l1
	andcc	%l0,%l1,%l0
	be	.L4511
	nop

	! block 109
.L4513:
.L4514:
.L4515:
.L4516:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-180]

	! block 110
.L4517:
	ld	[%fp-40],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-188]

	! block 111
.L4518:
	ld	[%fp-40],%l0
	ld	[%fp-144],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-192]

	! block 112
.L4519:
.L4520:
	ld	[%fp-188],%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	bg	.L4523
	nop

	! block 113
.L4524:
.L4521:
.L4525:
.L4526:
.L4527:
	ld	[%fp-184],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-180],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-104],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-120],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 114
.L4528:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4529
	nop

	! block 115
.L4530:
.L4531:
.L4532:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 116
.L4533:
.L4534:
.L4529:
.L4535:
.L4536:
.L4537:
.L4538:
	ld	[%fp-184],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	ble	.L4521
	nop

	! block 117
.L4539:
.L4523:
.L4540:
.L4541:
.L4542:
.L4511:
.L4543:
.L4544:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 118
.L4545:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 119
.L4546:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 120
.L4547:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 121
.L4548:
	ld	[%fp-96],%f5
	ld	[%fp-100],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-96]

	! block 122
.L4549:
	ld	[%fp-104],%f5
	ld	[%fp-108],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-104]

	! block 123
.L4550:
	ld	[%fp-112],%f5
	ld	[%fp-116],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-112]

	! block 124
.L4551:
	ld	[%fp-120],%f5
	ld	[%fp-124],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-120]

	! block 125
.L4552:
	ld	[%fp-128],%f5
	ld	[%fp-132],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-128]

	! block 126
.L4553:
.L4555:
	ld	[%fp-172],%l0
	cmp	%l0,0
	bge	.L4554
	nop

	! block 127
.L4556:
.L4557:
.L4558:
.L4559:
	ld	[%fp-172],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 128
.L4560:
.L4561:
	ba	.L4562
	nop

	! block 129
.L4554:
.L4563:
.L4564:
.L4565:
	ld	[%fp-172],%l0
	ld	[%fp-176],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 130
.L4566:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 131
.L4567:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 132
.L4568:
.L4569:
.L4562:
.L4570:
.L4571:
.L4572:
.L4573:
	ld	[%fp-164],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-164]
	ld	[%fp-164],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L4503
	nop

	! block 133
.L4574:
.L4505:
.L4575:
.L4576:
.L4577:
.L4486:
.L4578:
.L4579:
.L4580:
.L4581:
	ba	.L4582
	nop

	! block 134
.L4314:
.L4583:
.L4584:
.L4585:
.L4586:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-36]

	! block 135
.L4587:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-40]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-44]

	! block 136
.L4588:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-48]
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-52]

	! block 137
.L4589:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l3
	or	%l3,%lo(0xaf40),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-96]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-96],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 138
.L4590:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l3
	or	%l3,%lo(0xaf44),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-104]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-104],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 139
.L4591:
	sethi	%hi(.L_cseg3),%l3
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l5
	or	%l5,%lo(0x3f0c),%l5
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-112]
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f5
	ld	[%fp-112],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 140
.L4592:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l3
	or	%l3,%lo(0xaf48),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-120]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-120],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 141
.L4593:
	ld	[%fp-36],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l3
	or	%l3,%lo(0xaf4c),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-128]
	ld	[%fp-36],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-128],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 142
.L4594:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L4595
	nop

	! block 143
.L4596:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L4597
	std	%f4,[%fp-152]

	! block 144
.L4595:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L4598
	nop

	! block 145
.L4599:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L4600
	std	%f4,[%fp-160]

	! block 146
.L4598:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-160]

	! block 147
.L4600:
	ldd	[%fp-160],%f4
	std	%f4,[%fp-152]

	! block 148
.L4597:
	ldd	[%fp-152],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-136]

	! block 149
.L4601:
	ld	[%fp-136],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-140]

	! block 150
.L4602:
	ld	[%fp-140],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-144]

	! block 151
.L4603:
	ld	[%fp-44],%l0
	ld	[%fp-40],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-56]

	! block 152
.L4604:
	ld	[%fp-52],%l0
	ld	[%fp-48],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 153
.L4605:
.L4607:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bne	.L4606
	nop

	! block 154
.L4608:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bne	.L4606
	nop

	! block 155
.L4609:
.L4610:
.L4611:
.L4612:
	ba	.L4287
	nop

	! block 156
.L4613:
.L4614:
.L4606:
.L4615:
.L4616:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-48],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-40],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-92]

	! block 157
.L4617:
	ld	[%fp-36],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-72]

	! block 158
.L4618:
	ld	[%fp-36],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-196]
	ld	[%fp-196],%l0
	st	%l0,[%fp-76]

	! block 159
.L4619:
.L4621:
	ld	[%fp-56],%l0
	cmp	%l0,0
	bge	.L4620
	nop

	! block 160
.L4622:
.L4623:
.L4624:
.L4625:
	ld	[%fp-56],%l0
	neg	%l0,%l0
	st	%l0,[%fp-56]

	! block 161
.L4626:
	mov	-1,%l0
	st	%l0,[%fp-64]

	! block 162
.L4627:
	mov	-2,%l0
	st	%l0,[%fp-84]

	! block 163
.L4628:
.L4629:
	ba	.L4630
	nop

	! block 164
.L4620:
.L4631:
.L4632:
.L4633:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 165
.L4634:
	mov	2,%l0
	st	%l0,[%fp-84]

	! block 166
.L4635:
.L4636:
.L4630:
.L4637:
.L4638:
.L4640:
	ld	[%fp-60],%l0
	cmp	%l0,0
	bge	.L4639
	nop

	! block 167
.L4641:
.L4642:
.L4643:
.L4644:
	ld	[%fp-60],%l0
	neg	%l0,%l0
	st	%l0,[%fp-60]

	! block 168
.L4645:
	mov	-1,%l0
	st	%l0,[%fp-68]

	! block 169
.L4646:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 170
.L4647:
.L4648:
	ba	.L4649
	nop

	! block 171
.L4639:
.L4650:
.L4651:
.L4652:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 172
.L4653:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 173
.L4654:
.L4655:
.L4649:
.L4656:
.L4657:
.L4659:
	ld	[%fp-56],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	ble	.L4658
	nop

	! block 174
.L4660:
.L4661:
.L4662:
.L4663:
	ld	[%fp-60],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-168]

	! block 175
.L4664:
	ld	[%fp-168],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 176
.L4665:
	ld	[%fp-172],%l0
	ld	[%fp-56],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-176]

	! block 177
.L4666:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-56],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 178
.L4667:
.L4668:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-56],%l0
	st	%l0,[%fp-196]
	ld	[%fp-196],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-180]

	! block 179
.L4669:
	ld	[%fp-100],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 180
.L4670:
	ld	[%fp-108],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 181
.L4671:
	ld	[%fp-116],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 182
.L4672:
	ld	[%fp-124],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 183
.L4673:
	ld	[%fp-132],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 184
.L4674:
.L4675:
.L4676:
	ld	[%fp-56],%l0
	cmp	%g0,%l0
	bge	.L4679
	st	%g0,[%fp-164]

	! block 185
.L4680:
.L4677:
.L4681:
.L4682:
.L4683:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-178]

	! block 186
.L4684:
	ld	[%fp-48],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-188]

	! block 187
.L4685:
	ld	[%fp-48],%l0
	ld	[%fp-144],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-192]

	! block 188
.L4686:
.L4687:
	ld	[%fp-188],%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	bg	.L4690
	nop

	! block 189
.L4691:
.L4688:
.L4692:
.L4693:
.L4694:
	ld	[%fp-40],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-184],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-178],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-104],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-120],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 190
.L4695:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4696
	nop

	! block 191
.L4697:
.L4698:
.L4699:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 192
.L4700:
.L4701:
.L4696:
.L4702:
.L4703:
.L4704:
.L4705:
	ld	[%fp-184],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	ble	.L4688
	nop

	! block 193
.L4706:
.L4690:
.L4707:
.L4708:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 194
.L4709:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 195
.L4710:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 196
.L4711:
	ld	[%fp-96],%f5
	ld	[%fp-100],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-96]

	! block 197
.L4712:
	ld	[%fp-104],%f5
	ld	[%fp-108],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-104]

	! block 198
.L4713:
	ld	[%fp-112],%f5
	ld	[%fp-116],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-112]

	! block 199
.L4714:
	ld	[%fp-120],%f5
	ld	[%fp-124],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-120]

	! block 200
.L4715:
	ld	[%fp-128],%f5
	ld	[%fp-132],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-128]

	! block 201
.L4716:
.L4718:
	ld	[%fp-172],%l0
	cmp	%l0,0
	bge	.L4717
	nop

	! block 202
.L4719:
.L4720:
.L4721:
.L4722:
	ld	[%fp-172],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 203
.L4723:
.L4724:
	ba	.L4725
	nop

	! block 204
.L4717:
.L4726:
.L4727:
.L4728:
	ld	[%fp-172],%l0
	ld	[%fp-176],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 205
.L4729:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 206
.L4730:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 207
.L4731:
.L4732:
.L4725:
.L4733:
.L4734:
.L4735:
.L4736:
	ld	[%fp-164],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-164]
	ld	[%fp-164],%l1
	ld	[%fp-56],%l0
	cmp	%l1,%l0
	bl	.L4677
	nop

	! block 208
.L4737:
.L4679:
.L4738:
.L4739:
.L4740:
	ba	.L4741
	nop

	! block 209
.L4658:
.L4742:
.L4743:
.L4744:
	ld	[%fp-56],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-168]

	! block 210
.L4745:
	ld	[%fp-168],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 211
.L4746:
	ld	[%fp-172],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-176]

	! block 212
.L4747:
	ld	[%fp-76],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-60],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-80]

	! block 213
.L4748:
.L4749:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-60],%l0
	st	%l0,[%fp-196]
	ld	[%fp-196],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-180]

	! block 214
.L4750:
	ld	[%fp-100],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-100]

	! block 215
.L4751:
	ld	[%fp-108],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-108]

	! block 216
.L4752:
	ld	[%fp-116],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-116]

	! block 217
.L4753:
	ld	[%fp-124],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-124]

	! block 218
.L4754:
	ld	[%fp-132],%f5
	ld	[%fp-180],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-132]

	! block 219
.L4755:
.L4756:
.L4757:
	ld	[%fp-60],%l0
	cmp	%g0,%l0
	bge	.L4760
	st	%g0,[%fp-164]

	! block 220
.L4761:
.L4758:
.L4762:
.L4763:
.L4764:
	ld	[%fp-72],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-178]

	! block 221
.L4765:
	ld	[%fp-40],%l0
	ld	[%fp-140],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-188]

	! block 222
.L4766:
	ld	[%fp-40],%l0
	ld	[%fp-144],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-192]

	! block 223
.L4767:
.L4768:
	ld	[%fp-188],%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	bg	.L4771
	nop

	! block 224
.L4772:
.L4769:
.L4773:
.L4774:
.L4775:
	ld	[%fp-184],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-48],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-178],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-96],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-104],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-120],%f5
	ld	[%fp-112],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 225
.L4776:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4777
	nop

	! block 226
.L4778:
.L4779:
.L4780:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 227
.L4781:
.L4782:
.L4777:
.L4783:
.L4784:
.L4785:
.L4786:
	ld	[%fp-184],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-184]
	ld	[%fp-184],%l1
	ld	[%fp-192],%l0
	cmp	%l1,%l0
	ble	.L4769
	nop

	! block 228
.L4787:
.L4771:
.L4788:
.L4789:
	ld	[%fp-48],%l0
	ld	[%fp-68],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-48]

	! block 229
.L4790:
	ld	[%fp-92],%l0
	ld	[%fp-88],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 230
.L4791:
	ld	[%fp-72],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 231
.L4792:
	ld	[%fp-96],%f5
	ld	[%fp-100],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-96]

	! block 232
.L4793:
	ld	[%fp-104],%f5
	ld	[%fp-108],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-104]

	! block 233
.L4794:
	ld	[%fp-112],%f5
	ld	[%fp-116],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-112]

	! block 234
.L4795:
	ld	[%fp-120],%f5
	ld	[%fp-124],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-120]

	! block 235
.L4796:
	ld	[%fp-128],%f5
	ld	[%fp-132],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-128]

	! block 236
.L4797:
.L4799:
	ld	[%fp-172],%l0
	cmp	%l0,0
	bge	.L4798
	nop

	! block 237
.L4800:
.L4801:
.L4802:
.L4803:
	ld	[%fp-172],%l0
	ld	[%fp-168],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 238
.L4804:
.L4805:
	ba	.L4806
	nop

	! block 239
.L4798:
.L4807:
.L4808:
.L4809:
	ld	[%fp-172],%l0
	ld	[%fp-176],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-172]

	! block 240
.L4810:
	ld	[%fp-40],%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 241
.L4811:
	ld	[%fp-92],%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-92]

	! block 242
.L4812:
.L4813:
.L4806:
.L4814:
.L4815:
.L4816:
.L4817:
	ld	[%fp-164],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-164]
	ld	[%fp-164],%l1
	ld	[%fp-60],%l0
	cmp	%l1,%l0
	bl	.L4758
	nop

	! block 243
.L4818:
.L4760:
.L4819:
.L4820:
.L4821:
.L4741:
.L4822:
.L4823:
.L4824:
.L4825:
.L4582:
.L4826:
.L4827:

! File lines.c:
!  762	      /* stippled */
!  763	#define INTERP_XY 1
!  764	#define INTERP_Z 1
!  765	#define INTERP_STW 1
!  766	#define INTERP_UV 1
!  767	#define WIDE 1
!  768	#define STIPPLE 1
!  769	#define PLOT(X,Y)			\
!  770		pbx[count] = X;			\
!  771		pby[count] = Y;			\
!  772		pbz[count] = Z;			\
!  773		pbs[count] = s0 / w0;		\
!  774		pbt[count] = t0 / w0;		\
!  775		pbu[count] = u0 / w0;		\
!  776		count++;			\
!  777		CHECK_FULL(count);
!  778	#include "linetemp.h"
!  779	   }
!  780	   else {
!  781	      /* unstippled */
!  782	#define INTERP_XY 1
!  783	#define INTERP_Z 1
!  784	#define INTERP_STW 1
!  785	#define INTERP_UV 1
!  786	#define WIDE 1
!  787	#define PLOT(X,Y)			\
!  788		pbx[count] = X;			\
!  789		pby[count] = Y;			\
!  790		pbz[count] = Z;			\
!  791		pbs[count] = s0 / w0;		\
!  792		pbt[count] = t0 / w0;		\
!  793		pbu[count] = u0 / w0;		\
!  794		count++;			\
!  795		CHECK_FULL(count);
!  796	#include "linetemp.h"
!  797	   }
!  798	
!  799	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 244
.L4828:
.L4830:

!  800	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L4829
	nop

	! block 245
.L4831:
.L4832:
.L4833:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 246
.L4834:
.L4835:
.L4829:
.L4836:

	! block 247
.L4837:
.L4838:
.L4287:
	jmp	%i7+8
	restore
	.size	flat_textured_line,(.-flat_textured_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	smooth_textured_line,#function
smooth_textured_line:
	save	%sp,-344,%sp

	! block 1
.L4841:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L4842:
.L4844:

! File lines.c:
!  801	}
!  802	
!  805	/* Smooth-shaded, textured, any width, maybe stippled */
!  806	static void smooth_textured_line( GLcontext *ctx,
!  807	                                  GLuint vert0, GLuint vert1, GLuint pv )
!  808	{
!  809	   GLint count = ctx->PB->count;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-4]

	! block 3
.L4845:

!  810	   GLint *pbx = ctx->PB->x;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-8]

	! block 4
.L4846:

!  811	   GLint *pby = ctx->PB->y;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x4b00),%l1
	or	%l1,%lo(0x4b00),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L4847:

!  812	   GLdepth *pbz = ctx->PB->z;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x9600),%l1
	or	%l1,%lo(0x9600),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L4848:

!  813	   GLfloat *pbs = ctx->PB->s;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x15180),%l1
	or	%l1,%lo(0x15180),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 7
.L4849:

!  814	   GLfloat *pbt = ctx->PB->t;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x19c80),%l1
	or	%l1,%lo(0x19c80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-24]

	! block 8
.L4850:

!  815	   GLfloat *pbu = ctx->PB->u;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x1e780),%l1
	or	%l1,%lo(0x1e780),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]

	! block 9
.L4851:

!  816	   GLubyte *pbr = ctx->PB->r;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xbb80),%l1
	or	%l1,%lo(0xbb80),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-32]

	! block 10
.L4852:

!  817	   GLubyte *pbg = ctx->PB->g;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xce40),%l1
	or	%l1,%lo(0xce40),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-36]

	! block 11
.L4853:

!  818	   GLubyte *pbb = ctx->PB->b;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-40]

	! block 12
.L4854:

!  819	   GLubyte *pba = ctx->PB->a;

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0xf3c0),%l1
	or	%l1,%lo(0xf3c0),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-44]

	! block 13
.L4855:
.L4857:

!  821	   if (ctx->Line.StippleFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L4856
	nop

	! block 14
.L4858:
.L4859:
.L4860:
.L4861:
.L4862:

! File linetemp.h:

	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-48]

	! block 15
.L4863:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-52]
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-56]

	! block 16
.L4864:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-60]
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-64]

	! block 17
.L4865:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-108]

	! block 18
.L4866:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-108],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 19
.L4867:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-116]

	! block 20
.L4868:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-116],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 21
.L4869:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-124]

	! block 22
.L4870:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-124],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 23
.L4871:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-132]

	! block 24
.L4872:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-132],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 25
.L4873:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l3
	or	%l3,%lo(0xaf40),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-140]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-140],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 26
.L4874:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l3
	or	%l3,%lo(0xaf44),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-148]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-148],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 27
.L4875:
	sethi	%hi(.L_cseg3),%l3
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l5
	or	%l5,%lo(0x3f0c),%l5
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-156]
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f5
	ld	[%fp-156],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 28
.L4876:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l3
	or	%l3,%lo(0xaf48),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-164]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-164],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 29
.L4877:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l3
	or	%l3,%lo(0xaf4c),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-172]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-172],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 30
.L4878:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L4879
	nop

	! block 31
.L4880:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L4881
	std	%f4,[%fp-200]

	! block 32
.L4879:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L4882
	nop

	! block 33
.L4883:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L4884
	std	%f4,[%fp-208]

	! block 34
.L4882:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-208]

	! block 35
.L4884:
	ldd	[%fp-208],%f4
	std	%f4,[%fp-200]

	! block 36
.L4881:
	ldd	[%fp-200],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-180]

	! block 37
.L4885:
	ld	[%fp-180],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-184]

	! block 38
.L4886:
	ld	[%fp-184],%l0
	ld	[%fp-180],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-188]

	! block 39
.L4887:
	ld	[%fp-56],%l0
	ld	[%fp-52],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 40
.L4888:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 41
.L4889:
.L4891:
	ld	[%fp-68],%l0
	cmp	%l0,0
	bne	.L4890
	nop

	! block 42
.L4892:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bne	.L4890
	nop

	! block 43
.L4893:
.L4894:
.L4895:
.L4896:
	ba	.L4840
	nop

	! block 44
.L4897:
.L4898:
.L4890:
.L4899:
.L4900:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-60],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-52],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-104]

	! block 45
.L4901:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-84]

	! block 46
.L4902:
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-88]

	! block 47
.L4903:
.L4905:
	ld	[%fp-68],%l0
	cmp	%l0,0
	bge	.L4904
	nop

	! block 48
.L4906:
.L4907:
.L4908:
.L4909:
	ld	[%fp-68],%l0
	neg	%l0,%l0
	st	%l0,[%fp-68]

	! block 49
.L4910:
	mov	-1,%l0
	st	%l0,[%fp-76]

	! block 50
.L4911:
	mov	-2,%l0
	st	%l0,[%fp-96]

	! block 51
.L4912:
.L4913:
	ba	.L4914
	nop

	! block 52
.L4904:
.L4915:
.L4916:
.L4917:
	mov	1,%l0
	st	%l0,[%fp-76]

	! block 53
.L4918:
	mov	2,%l0
	st	%l0,[%fp-96]

	! block 54
.L4919:
.L4920:
.L4914:
.L4921:
.L4922:
.L4924:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bge	.L4923
	nop

	! block 55
.L4925:
.L4926:
.L4927:
.L4928:
	ld	[%fp-72],%l0
	neg	%l0,%l0
	st	%l0,[%fp-72]

	! block 56
.L4929:
	mov	-1,%l0
	st	%l0,[%fp-80]

	! block 57
.L4930:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 58
.L4931:
.L4932:
	ba	.L4933
	nop

	! block 59
.L4923:
.L4934:
.L4935:
.L4936:
	mov	1,%l0
	st	%l0,[%fp-80]

	! block 60
.L4937:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 61
.L4938:
.L4939:
.L4933:
.L4940:
.L4941:
.L4943:
	ld	[%fp-68],%l1
	ld	[%fp-72],%l0
	cmp	%l1,%l0
	ble	.L4942
	nop

	! block 62
.L4944:
.L4945:
.L4946:
.L4947:
	ld	[%fp-72],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-216]

	! block 63
.L4948:
	ld	[%fp-216],%l0
	ld	[%fp-68],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 64
.L4949:
	ld	[%fp-220],%l0
	ld	[%fp-68],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-224]

	! block 65
.L4950:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-92]

	! block 66
.L4951:
	ld	[%fp-112],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-112]

	! block 67
.L4952:
	ld	[%fp-120],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-120]

	! block 68
.L4953:
	ld	[%fp-128],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-128]

	! block 69
.L4954:
	ld	[%fp-136],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-136]

	! block 70
.L4955:
.L4956:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-68],%l0
	st	%l0,[%fp-244]
	ld	[%fp-244],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-228]

	! block 71
.L4957:
	ld	[%fp-144],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 72
.L4958:
	ld	[%fp-152],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 73
.L4959:
	ld	[%fp-160],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 74
.L4960:
	ld	[%fp-168],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 75
.L4961:
	ld	[%fp-176],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 76
.L4962:
.L4963:
.L4964:
	ld	[%fp-68],%l0
	cmp	%g0,%l0
	bge	.L4967
	st	%g0,[%fp-212]

	! block 77
.L4968:
.L4965:
.L4969:
.L4970:
.L4971:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-226]

	! block 78
.L4972:
.L4974:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-226],%l1
	andcc	%l0,%l1,%l0
	be	.L4973
	nop

	! block 79
.L4975:
.L4976:
.L4977:
.L4978:
	ld	[%fp-84],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-228]

	! block 80
.L4979:
	ld	[%fp-60],%l0
	ld	[%fp-184],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-236]

	! block 81
.L4980:
	ld	[%fp-60],%l0
	ld	[%fp-188],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-240]

	! block 82
.L4981:
.L4982:
	ld	[%fp-236],%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	bg	.L4985
	nop

	! block 83
.L4986:
.L4983:
.L4987:
.L4988:
.L4989:
	ld	[%fp-52],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-232],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-228],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-140],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-148],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-164],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-108],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-116],%l0
	sra	%l0,11,%l2
	ld	[%fp-36],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-124],%l0
	sra	%l0,11,%l2
	ld	[%fp-40],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-132],%l0
	sra	%l0,11,%l2
	ld	[%fp-44],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 84
.L4990:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L4991
	nop

	! block 85
.L4992:
.L4993:
.L4994:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 86
.L4995:
.L4996:
.L4991:
.L4997:
.L4998:
.L4999:
.L5000:
	ld	[%fp-232],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	ble	.L4983
	nop

	! block 87
.L5001:
.L4985:
.L5002:
.L5003:
.L5004:
.L4973:
.L5005:
.L5006:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 88
.L5007:
	ld	[%fp-52],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-52]

	! block 89
.L5008:
	ld	[%fp-104],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 90
.L5009:
	ld	[%fp-84],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 91
.L5010:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 92
.L5011:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 93
.L5012:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 94
.L5013:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 95
.L5014:
	ld	[%fp-140],%f5
	ld	[%fp-144],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-140]

	! block 96
.L5015:
	ld	[%fp-148],%f5
	ld	[%fp-152],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-148]

	! block 97
.L5016:
	ld	[%fp-156],%f5
	ld	[%fp-160],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-156]

	! block 98
.L5017:
	ld	[%fp-164],%f5
	ld	[%fp-168],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-164]

	! block 99
.L5018:
	ld	[%fp-172],%f5
	ld	[%fp-176],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-172]

	! block 100
.L5019:
.L5021:
	ld	[%fp-220],%l0
	cmp	%l0,0
	bge	.L5020
	nop

	! block 101
.L5022:
.L5023:
.L5024:
.L5025:
	ld	[%fp-220],%l0
	ld	[%fp-216],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 102
.L5026:
.L5027:
	ba	.L5028
	nop

	! block 103
.L5020:
.L5029:
.L5030:
.L5031:
	ld	[%fp-220],%l0
	ld	[%fp-224],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 104
.L5032:
	ld	[%fp-60],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 105
.L5033:
	ld	[%fp-104],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 106
.L5034:
.L5035:
.L5028:
.L5036:
.L5037:
.L5038:
.L5039:
	ld	[%fp-212],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-212]
	ld	[%fp-212],%l1
	ld	[%fp-68],%l0
	cmp	%l1,%l0
	bl	.L4965
	nop

	! block 107
.L5040:
.L4967:
.L5041:
.L5042:
.L5043:
	ba	.L5044
	nop

	! block 108
.L4942:
.L5045:
.L5046:
.L5047:
	ld	[%fp-68],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-216]

	! block 109
.L5048:
	ld	[%fp-216],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 110
.L5049:
	ld	[%fp-220],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-224]

	! block 111
.L5050:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-92]

	! block 112
.L5051:
	ld	[%fp-112],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-112]

	! block 113
.L5052:
	ld	[%fp-120],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-120]

	! block 114
.L5053:
	ld	[%fp-128],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-128]

	! block 115
.L5054:
	ld	[%fp-136],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-136]

	! block 116
.L5055:
.L5056:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-72],%l0
	st	%l0,[%fp-244]
	ld	[%fp-244],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-228]

	! block 117
.L5057:
	ld	[%fp-144],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 118
.L5058:
	ld	[%fp-152],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 119
.L5059:
	ld	[%fp-160],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 120
.L5060:
	ld	[%fp-168],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 121
.L5061:
	ld	[%fp-176],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 122
.L5062:
.L5063:
.L5064:
	ld	[%fp-72],%l0
	cmp	%g0,%l0
	bge	.L5067
	st	%g0,[%fp-212]

	! block 123
.L5068:
.L5065:
.L5069:
.L5070:
.L5071:
	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	ld	[%l0+%l1],%l2
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l2,%l1,%l0
	and	%l0,15,%l1
	sll	%l3,%l1,%l0
	sth	%l0,[%fp-226]

	! block 124
.L5072:
.L5074:
	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	lduh	[%fp-226],%l1
	andcc	%l0,%l1,%l0
	be	.L5073
	nop

	! block 125
.L5075:
.L5076:
.L5077:
.L5078:
	ld	[%fp-84],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-228]

	! block 126
.L5079:
	ld	[%fp-52],%l0
	ld	[%fp-184],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-236]

	! block 127
.L5080:
	ld	[%fp-52],%l0
	ld	[%fp-188],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-240]

	! block 128
.L5081:
.L5082:
	ld	[%fp-236],%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	bg	.L5085
	nop

	! block 129
.L5086:
.L5083:
.L5087:
.L5088:
.L5089:
	ld	[%fp-232],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-60],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-228],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-140],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-148],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-164],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-108],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-116],%l0
	sra	%l0,11,%l2
	ld	[%fp-36],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-124],%l0
	sra	%l0,11,%l2
	ld	[%fp-40],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-132],%l0
	sra	%l0,11,%l2
	ld	[%fp-44],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 130
.L5090:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L5091
	nop

	! block 131
.L5092:
.L5093:
.L5094:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 132
.L5095:
.L5096:
.L5091:
.L5097:
.L5098:
.L5099:
.L5100:
	ld	[%fp-232],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	ble	.L5083
	nop

	! block 133
.L5101:
.L5085:
.L5102:
.L5103:
.L5104:
.L5073:
.L5105:
.L5106:
	ld	[%fp+68],%l0
	sethi	%hi(0xe100),%l1
	or	%l1,%lo(0xe100),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	add	%l0,1,%l0
	st	%l0,[%l1+0]

	! block 134
.L5107:
	ld	[%fp-60],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 135
.L5108:
	ld	[%fp-104],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 136
.L5109:
	ld	[%fp-84],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 137
.L5110:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 138
.L5111:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 139
.L5112:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 140
.L5113:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 141
.L5114:
	ld	[%fp-140],%f5
	ld	[%fp-144],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-140]

	! block 142
.L5115:
	ld	[%fp-148],%f5
	ld	[%fp-152],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-148]

	! block 143
.L5116:
	ld	[%fp-156],%f5
	ld	[%fp-160],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-156]

	! block 144
.L5117:
	ld	[%fp-164],%f5
	ld	[%fp-168],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-164]

	! block 145
.L5118:
	ld	[%fp-172],%f5
	ld	[%fp-176],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-172]

	! block 146
.L5119:
.L5121:
	ld	[%fp-220],%l0
	cmp	%l0,0
	bge	.L5120
	nop

	! block 147
.L5122:
.L5123:
.L5124:
.L5125:
	ld	[%fp-220],%l0
	ld	[%fp-216],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 148
.L5126:
.L5127:
	ba	.L5128
	nop

	! block 149
.L5120:
.L5129:
.L5130:
.L5131:
	ld	[%fp-220],%l0
	ld	[%fp-224],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 150
.L5132:
	ld	[%fp-52],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-52]

	! block 151
.L5133:
	ld	[%fp-104],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 152
.L5134:
.L5135:
.L5128:
.L5136:
.L5137:
.L5138:
.L5139:
	ld	[%fp-212],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-212]
	ld	[%fp-212],%l1
	ld	[%fp-72],%l0
	cmp	%l1,%l0
	bl	.L5065
	nop

	! block 153
.L5140:
.L5067:
.L5141:
.L5142:
.L5143:
.L5044:
.L5144:
.L5145:
.L5146:
.L5147:
	ba	.L5148
	nop

	! block 154
.L4856:
.L5149:
.L5150:
.L5151:
.L5152:
	ld	[%fp+68],%l0
	sethi	%hi(0xe134),%l1
	or	%l1,%lo(0xe134),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-48]

	! block 155
.L5153:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e80),%l5
	or	%l5,%lo(0x5e80),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-52]
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-56]

	! block 156
.L5154:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e84),%l5
	or	%l5,%lo(0x5e84),%l5
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-60]
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%l0+%l5],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-64]

	! block 157
.L5155:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-108]

	! block 158
.L5156:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	sll	%l0,11,%l0
	ld	[%fp-108],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-112]

	! block 159
.L5157:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-116]

	! block 160
.L5158:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	sll	%l0,11,%l0
	ld	[%fp-116],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-120]

	! block 161
.L5159:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-124]

	! block 162
.L5160:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	sll	%l0,11,%l0
	ld	[%fp-124],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-128]

	! block 163
.L5161:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+72],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	st	%l0,[%fp-132]

	! block 164
.L5162:
	ld	[%fp-48],%l0
	sethi	%hi(0x9d80),%l1
	or	%l1,%lo(0x9d80),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	sll	%l0,11,%l0
	ld	[%fp-132],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-136]

	! block 165
.L5163:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf40),%l3
	or	%l3,%lo(0xaf40),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-140]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-140],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 166
.L5164:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf44),%l3
	or	%l3,%lo(0xaf44),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-148]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-148],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 167
.L5165:
	sethi	%hi(.L_cseg3),%l3
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x3f0c),%l5
	or	%l5,%lo(0x3f0c),%l5
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-156]
	ld	[%l3+%lo(.L_cseg3)],%f5
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l5],%f4
	fdivs	%f5,%f4,%f5
	ld	[%fp-156],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 168
.L5166:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf48),%l3
	or	%l3,%lo(0xaf48),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-164]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-164],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 169
.L5167:
	ld	[%fp-48],%l2
	ld	[%fp+72],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xaf4c),%l3
	or	%l3,%lo(0xaf4c),%l3
	ld	[%l0+%l3],%f4
	st	%f4,[%fp-172]
	ld	[%fp-48],%l2
	ld	[%fp+76],%l0
	sll	%l0,4,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l3],%f5
	ld	[%fp-172],%f4
	fsubs	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 170
.L5168:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmped	%f6,%f4
	fbuge	.L5169
	nop

	! block 171
.L5170:
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ba	.L5171
	std	%f4,[%fp-200]

	! block 172
.L5169:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	fcmped	%f6,%f4
	fbule	.L5172
	nop

	! block 173
.L5173:
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ba	.L5174
	std	%f4,[%fp-208]

	! block 174
.L5172:
	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	std	%f4,[%fp-208]

	! block 175
.L5174:
	ldd	[%fp-208],%f4
	std	%f4,[%fp-200]

	! block 176
.L5171:
	ldd	[%fp-200],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-180]

	! block 177
.L5175:
	ld	[%fp-180],%l0
	neg	%l0,%l2
	sra	%l2,31,%l0
	and	%l0,1,%l1
	add	%l2,%l1,%l0
	sra	%l0,1,%l0
	st	%l0,[%fp-184]

	! block 178
.L5176:
	ld	[%fp-184],%l0
	ld	[%fp-180],%l1
	add	%l0,%l1,%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-188]

	! block 179
.L5177:
	ld	[%fp-56],%l0
	ld	[%fp-52],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-68]

	! block 180
.L5178:
	ld	[%fp-64],%l0
	ld	[%fp-60],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-72]

	! block 181
.L5179:
.L5181:
	ld	[%fp-68],%l0
	cmp	%l0,0
	bne	.L5180
	nop

	! block 182
.L5182:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bne	.L5180
	nop

	! block 183
.L5183:
.L5184:
.L5185:
.L5186:
	ba	.L4840
	nop

	! block 184
.L5187:
.L5188:
.L5180:
.L5189:
.L5190:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+12],%l2
	ld	[%l0+4],%l0
	ld	[%fp-60],%l1
	smul	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l2
	ld	[%fp-52],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-104]

	! block 185
.L5191:
	ld	[%fp-48],%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-84]

	! block 186
.L5192:
	ld	[%fp-48],%l3
	ld	[%fp+76],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x5e88),%l1
	or	%l1,%lo(0x5e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg6),%l0
	ld	[%l0+%lo(.L_cseg6)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-244]
	ld	[%fp-244],%l0
	st	%l0,[%fp-88]

	! block 187
.L5193:
.L5195:
	ld	[%fp-68],%l0
	cmp	%l0,0
	bge	.L5194
	nop

	! block 188
.L5196:
.L5197:
.L5198:
.L5199:
	ld	[%fp-68],%l0
	neg	%l0,%l0
	st	%l0,[%fp-68]

	! block 189
.L5200:
	mov	-1,%l0
	st	%l0,[%fp-76]

	! block 190
.L5201:
	mov	-2,%l0
	st	%l0,[%fp-96]

	! block 191
.L5202:
.L5203:
	ba	.L5204
	nop

	! block 192
.L5194:
.L5205:
.L5206:
.L5207:
	mov	1,%l0
	st	%l0,[%fp-76]

	! block 193
.L5208:
	mov	2,%l0
	st	%l0,[%fp-96]

	! block 194
.L5209:
.L5210:
.L5204:
.L5211:
.L5212:
.L5214:
	ld	[%fp-72],%l0
	cmp	%l0,0
	bge	.L5213
	nop

	! block 195
.L5215:
.L5216:
.L5217:
.L5218:
	ld	[%fp-72],%l0
	neg	%l0,%l0
	st	%l0,[%fp-72]

	! block 196
.L5219:
	mov	-1,%l0
	st	%l0,[%fp-80]

	! block 197
.L5220:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	neg	%l0,%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 198
.L5221:
.L5222:
	ba	.L5223
	nop

	! block 199
.L5213:
.L5224:
.L5225:
.L5226:
	mov	1,%l0
	st	%l0,[%fp-80]

	! block 200
.L5227:
	ld	[%fp+68],%l0
	ld	[%l0+2204],%l0
	ld	[%l0+4],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-100]

	! block 201
.L5228:
.L5229:
.L5223:
.L5230:
.L5231:
.L5233:
	ld	[%fp-68],%l1
	ld	[%fp-72],%l0
	cmp	%l1,%l0
	ble	.L5232
	nop

	! block 202
.L5234:
.L5235:
.L5236:
.L5237:
	ld	[%fp-72],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-216]

	! block 203
.L5238:
	ld	[%fp-216],%l0
	ld	[%fp-68],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 204
.L5239:
	ld	[%fp-220],%l0
	ld	[%fp-68],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-224]

	! block 205
.L5240:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-92]

	! block 206
.L5241:
	ld	[%fp-112],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-112]

	! block 207
.L5242:
	ld	[%fp-120],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-120]

	! block 208
.L5243:
	ld	[%fp-128],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-128]

	! block 209
.L5244:
	ld	[%fp-136],%l0
	ld	[%fp-68],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-136]

	! block 210
.L5245:
.L5246:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-68],%l0
	st	%l0,[%fp-244]
	ld	[%fp-244],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-228]

	! block 211
.L5247:
	ld	[%fp-144],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 212
.L5248:
	ld	[%fp-152],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 213
.L5249:
	ld	[%fp-160],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 214
.L5250:
	ld	[%fp-168],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 215
.L5251:
	ld	[%fp-176],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 216
.L5252:
.L5253:
.L5254:
	ld	[%fp-68],%l0
	cmp	%g0,%l0
	bge	.L5257
	st	%g0,[%fp-212]

	! block 217
.L5258:
.L5255:
.L5259:
.L5260:
.L5261:
	ld	[%fp-84],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-226]

	! block 218
.L5262:
	ld	[%fp-60],%l0
	ld	[%fp-184],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-236]

	! block 219
.L5263:
	ld	[%fp-60],%l0
	ld	[%fp-188],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-240]

	! block 220
.L5264:
.L5265:
	ld	[%fp-236],%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	bg	.L5268
	nop

	! block 221
.L5269:
.L5266:
.L5270:
.L5271:
.L5272:
	ld	[%fp-52],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-232],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-226],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-140],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-148],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-164],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-108],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-116],%l0
	sra	%l0,11,%l2
	ld	[%fp-36],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-124],%l0
	sra	%l0,11,%l2
	ld	[%fp-40],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-132],%l0
	sra	%l0,11,%l2
	ld	[%fp-44],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 222
.L5273:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L5274
	nop

	! block 223
.L5275:
.L5276:
.L5277:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 224
.L5278:
.L5279:
.L5274:
.L5280:
.L5281:
.L5282:
.L5283:
	ld	[%fp-232],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	ble	.L5266
	nop

	! block 225
.L5284:
.L5268:
.L5285:
.L5286:
	ld	[%fp-52],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-52]

	! block 226
.L5287:
	ld	[%fp-104],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 227
.L5288:
	ld	[%fp-84],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 228
.L5289:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 229
.L5290:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 230
.L5291:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 231
.L5292:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 232
.L5293:
	ld	[%fp-140],%f5
	ld	[%fp-144],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-140]

	! block 233
.L5294:
	ld	[%fp-148],%f5
	ld	[%fp-152],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-148]

	! block 234
.L5295:
	ld	[%fp-156],%f5
	ld	[%fp-160],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-156]

	! block 235
.L5296:
	ld	[%fp-164],%f5
	ld	[%fp-168],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-164]

	! block 236
.L5297:
	ld	[%fp-172],%f5
	ld	[%fp-176],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-172]

	! block 237
.L5298:
.L5300:
	ld	[%fp-220],%l0
	cmp	%l0,0
	bge	.L5299
	nop

	! block 238
.L5301:
.L5302:
.L5303:
.L5304:
	ld	[%fp-220],%l0
	ld	[%fp-216],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 239
.L5305:
.L5306:
	ba	.L5307
	nop

	! block 240
.L5299:
.L5308:
.L5309:
.L5310:
	ld	[%fp-220],%l0
	ld	[%fp-224],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 241
.L5311:
	ld	[%fp-60],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 242
.L5312:
	ld	[%fp-104],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 243
.L5313:
.L5314:
.L5307:
.L5315:
.L5316:
.L5317:
.L5318:
	ld	[%fp-212],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-212]
	ld	[%fp-212],%l1
	ld	[%fp-68],%l0
	cmp	%l1,%l0
	bl	.L5255
	nop

	! block 244
.L5319:
.L5257:
.L5320:
.L5321:
.L5322:
	ba	.L5323
	nop

	! block 245
.L5232:
.L5324:
.L5325:
.L5326:
	ld	[%fp-68],%l0
	add	%l0,%l0,%l0
	st	%l0,[%fp-216]

	! block 246
.L5327:
	ld	[%fp-216],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 247
.L5328:
	ld	[%fp-220],%l0
	ld	[%fp-72],%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-224]

	! block 248
.L5329:
	ld	[%fp-88],%l0
	ld	[%fp-84],%l1
	sub	%l0,%l1,%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-92]

	! block 249
.L5330:
	ld	[%fp-112],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-112]

	! block 250
.L5331:
	ld	[%fp-120],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-120]

	! block 251
.L5332:
	ld	[%fp-128],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-128]

	! block 252
.L5333:
	ld	[%fp-136],%l0
	ld	[%fp-72],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%l0
	bvs,a	.+8
	sethi	%hi(0x80000000),%l0
	st	%l0,[%fp-136]

	! block 253
.L5334:
.L5335:
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f5
	ld	[%fp-72],%l0
	st	%l0,[%fp-244]
	ld	[%fp-244],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-228]

	! block 254
.L5336:
	ld	[%fp-144],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-144]

	! block 255
.L5337:
	ld	[%fp-152],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-152]

	! block 256
.L5338:
	ld	[%fp-160],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-160]

	! block 257
.L5339:
	ld	[%fp-168],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-168]

	! block 258
.L5340:
	ld	[%fp-176],%f5
	ld	[%fp-228],%f4
	fmuls	%f5,%f4,%f4
	st	%f4,[%fp-176]

	! block 259
.L5341:
.L5342:
.L5343:
	ld	[%fp-72],%l0
	cmp	%g0,%l0
	bge	.L5346
	st	%g0,[%fp-212]

	! block 260
.L5347:
.L5344:
.L5348:
.L5349:
.L5350:
	ld	[%fp-84],%l0
	sra	%l0,11,%l0
	sth	%l0,[%fp-226]

	! block 261
.L5351:
	ld	[%fp-52],%l0
	ld	[%fp-184],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-236]

	! block 262
.L5352:
	ld	[%fp-52],%l0
	ld	[%fp-188],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-240]

	! block 263
.L5353:
.L5354:
	ld	[%fp-236],%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	bg	.L5357
	nop

	! block 264
.L5358:
.L5355:
.L5359:
.L5360:
.L5361:
	ld	[%fp-232],%l3
	ld	[%fp-8],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	ld	[%fp-60],%l3
	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]
	lduh	[%fp-226],%l3
	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	sll	%l0,1,%l1
	sth	%l3,[%l2+%l1]
	ld	[%fp-140],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-148],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-164],%f5
	ld	[%fp-156],%f4
	fdivs	%f5,%f4,%f4
	ld	[%fp-28],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]
	ld	[%fp-108],%l0
	sra	%l0,11,%l2
	ld	[%fp-32],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-116],%l0
	sra	%l0,11,%l2
	ld	[%fp-36],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-124],%l0
	sra	%l0,11,%l2
	ld	[%fp-40],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-132],%l0
	sra	%l0,11,%l2
	ld	[%fp-44],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]

	! block 265
.L5362:
	ld	[%fp-4],%l0
	cmp	%l0,3200
	bl	.L5363
	nop

	! block 266
.L5364:
.L5365:
.L5366:
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l3
	or	%l3,%lo(0xe138),%l3
	ld	[%l0+%l3],%l0
	sethi	%hi(0x27d94),%l2
	or	%l2,%lo(0x27d94),%l2
	st	%l1,[%l0+%l2]
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0
	ld	[%fp+68],%l0
	ld	[%l0+%l3],%l0
	ld	[%l0+%l2],%l0
	st	%l0,[%fp-4]

	! block 267
.L5367:
.L5368:
.L5363:
.L5369:
.L5370:
.L5371:
.L5372:
	ld	[%fp-232],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-232]
	ld	[%fp-232],%l1
	ld	[%fp-240],%l0
	cmp	%l1,%l0
	ble	.L5355
	nop

	! block 268
.L5373:
.L5357:
.L5374:
.L5375:
	ld	[%fp-60],%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-60]

	! block 269
.L5376:
	ld	[%fp-104],%l0
	ld	[%fp-100],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 270
.L5377:
	ld	[%fp-84],%l0
	ld	[%fp-92],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-84]

	! block 271
.L5378:
	ld	[%fp-108],%l0
	ld	[%fp-112],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-108]

	! block 272
.L5379:
	ld	[%fp-116],%l0
	ld	[%fp-120],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-116]

	! block 273
.L5380:
	ld	[%fp-124],%l0
	ld	[%fp-128],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-124]

	! block 274
.L5381:
	ld	[%fp-132],%l0
	ld	[%fp-136],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-132]

	! block 275
.L5382:
	ld	[%fp-140],%f5
	ld	[%fp-144],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-140]

	! block 276
.L5383:
	ld	[%fp-148],%f5
	ld	[%fp-152],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-148]

	! block 277
.L5384:
	ld	[%fp-156],%f5
	ld	[%fp-160],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-156]

	! block 278
.L5385:
	ld	[%fp-164],%f5
	ld	[%fp-168],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-164]

	! block 279
.L5386:
	ld	[%fp-172],%f5
	ld	[%fp-176],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-172]

	! block 280
.L5387:
.L5389:
	ld	[%fp-220],%l0
	cmp	%l0,0
	bge	.L5388
	nop

	! block 281
.L5390:
.L5391:
.L5392:
.L5393:
	ld	[%fp-220],%l0
	ld	[%fp-216],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 282
.L5394:
.L5395:
	ba	.L5396
	nop

	! block 283
.L5388:
.L5397:
.L5398:
.L5399:
	ld	[%fp-220],%l0
	ld	[%fp-224],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-220]

	! block 284
.L5400:
	ld	[%fp-52],%l0
	ld	[%fp-76],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-52]

	! block 285
.L5401:
	ld	[%fp-104],%l0
	ld	[%fp-96],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 286
.L5402:
.L5403:
.L5396:
.L5404:
.L5405:
.L5406:
.L5407:
	ld	[%fp-212],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-212]
	ld	[%fp-212],%l1
	ld	[%fp-72],%l0
	cmp	%l1,%l0
	bl	.L5344
	nop

	! block 287
.L5408:
.L5346:
.L5409:
.L5410:
.L5411:
.L5323:
.L5412:
.L5413:
.L5414:
.L5415:
.L5148:
.L5416:
.L5417:

! File lines.c:
!  822	      /* stippled */
!  823	#define INTERP_XY 1
!  824	#define INTERP_Z 1
!  825	#define INTERP_RGB 1
!  826	#define INTERP_ALPHA 1
!  827	#define INTERP_STW 1
!  828	#define INTERP_UV 1
!  829	#define WIDE 1
!  830	#define STIPPLE 1
!  831	#define PLOT(X,Y)			\
!  832		pbx[count] = X;			\
!  833		pby[count] = Y;			\
!  834		pbz[count] = Z;			\
!  835		pbs[count] = s0 / w0;		\
!  836		pbt[count] = t0 / w0;		\
!  837		pbu[count] = u0 / w0;		\
!  838		pbr[count] = FixedToInt(r0);	\
!  839		pbg[count] = FixedToInt(g0);	\
!  840		pbb[count] = FixedToInt(b0);	\
!  841		pba[count] = FixedToInt(a0);	\
!  842		count++;			\
!  843		CHECK_FULL(count);
!  844	#include "linetemp.h"
!  845	   }
!  846	   else {
!  847	      /* unstippled */
!  848	#define INTERP_XY 1
!  849	#define INTERP_Z 1
!  850	#define INTERP_RGB 1
!  851	#define INTERP_ALPHA 1
!  852	#define INTERP_STW 1
!  853	#define INTERP_UV 1
!  854	#define WIDE 1
!  855	#define PLOT(X,Y)			\
!  856		pbx[count] = X;			\
!  857		pby[count] = Y;			\
!  858		pbz[count] = Z;			\
!  859		pbs[count] = s0 / w0;		\
!  860		pbt[count] = t0 / w0;		\
!  861		pbu[count] = u0 / w0;		\
!  862		pbr[count] = FixedToInt(r0);	\
!  863		pbg[count] = FixedToInt(g0);	\
!  864		pbb[count] = FixedToInt(b0);	\
!  865		pba[count] = FixedToInt(a0);	\
!  866		count++;			\
!  867		CHECK_FULL(count);
!  868	#include "linetemp.h"
!  869	   }
!  870	
!  871	   ctx->PB->count = count;

	ld	[%fp-4],%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	st	%l2,[%l0+%l1]

	! block 288
.L5418:
.L5420:

!  872	   PB_CHECK_FLUSH( ctx, ctx->PB );

	ld	[%fp+68],%l0
	sethi	%hi(0xe138),%l1
	or	%l1,%lo(0xe138),%l1
	ld	[%l0+%l1],%l0
	sethi	%hi(0x27d94),%l1
	or	%l1,%lo(0x27d94),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,3200
	blu	.L5419
	nop

	! block 289
.L5421:
.L5422:
.L5423:
	ld	[%fp+68],%l0
	call	gl_flush_pb
	mov	%l0,%o0

	! block 290
.L5424:
.L5425:
.L5419:
.L5426:

	! block 291
.L5427:
.L5428:
.L4840:
	jmp	%i7+8
	restore
	.size	smooth_textured_line,(.-smooth_textured_line)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	null_line,#function
null_line:
	save	%sp,-96,%sp

	! block 1
.L5431:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L5432:

	! block 3
.L5434:
.L5435:
.L5430:
	jmp	%i7+8
	restore
	.size	null_line,(.-null_line)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_set_line_function
	.type	gl_set_line_function,#function
gl_set_line_function:
	save	%sp,-104,%sp

	! block 1
.L5438:
	st	%i0,[%fp+68]

	! block 2
.L5439:
.L5441:

! File lines.c:
!  873	}
!  874	
!  877	/*
!  878	 * Null rasterizer for measuring transformation speed.
!  879	 */
!  880	static void null_line( GLcontext *ctx, GLuint v1, GLuint v2, GLuint pv )
!  881	{
!  882	}
!  883	
!  886	/*
!  887	 * Determine which line drawing function to use given the current
!  888	 * rendering context.
!  889	 */
!  890	void gl_set_line_function( GLcontext *ctx )
!  891	{
!  892	   GLboolean rgbmode = ctx->Visual->RGBAflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l0
	stb	%l0,[%fp-1]

	! block 3
.L5442:
.L5444:

!  893	   /* TODO: antialiased lines */
!  894	
!  895	   if (ctx->RenderMode==GL_RENDER) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1c00),%l0
	cmp	%l1,%l0
	bne	.L5443
	nop

	! block 4
.L5445:
.L5446:
.L5447:
.L5448:
.L5450:

!  896	      if (ctx->NoRaster) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe13c),%l1
	or	%l1,%lo(0xe13c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L5449
	nop

	! block 5
.L5451:
.L5452:
.L5453:
.L5454:

!  897	         ctx->Driver.LineFunc = null_line;

	sethi	%hi(null_line),%l1
	or	%l1,%lo(null_line),%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 6
.L5455:

!  898	         return;

	ba	.L5437
	nop

	! block 7
.L5456:
.L5457:
.L5449:
.L5458:
.L5459:
.L5461:

!  899	      }
!  900	      if (ctx->Driver.LineFunc) {

	ld	[%fp+68],%l0
	ld	[%l0+2352],%l0
	cmp	%l0,%g0
	be	.L5460
	nop

	! block 8
.L5462:
.L5463:
.L5464:
.L5465:

!  901	         /* Device driver will draw lines. */
!  902	         ctx->Driver.LineFunc = ctx->Driver.LineFunc;

	ld	[%fp+68],%l0
	add	%l0,2352,%l0
	ld	[%l0+0],%l1
	st	%l1,[%l0+0]

	! block 9
.L5466:
.L5467:
	ba	.L5468
	nop

	! block 10
.L5460:
.L5469:
.L5470:
.L5472:

!  903	      }
!  904	      else if (ctx->Texture.Enabled) {

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L5471
	nop

	! block 11
.L5473:
.L5474:
.L5475:
.L5476:
.L5478:

!  905	         if (ctx->Light.ShadeModel==GL_SMOOTH) {

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1d01),%l0
	or	%l0,%lo(0x1d01),%l0
	cmp	%l1,%l0
	bne	.L5477
	nop

	! block 12
.L5479:
.L5480:
.L5481:
.L5482:

!  906	            ctx->Driver.LineFunc = smooth_textured_line;

	sethi	%hi(smooth_textured_line),%l1
	or	%l1,%lo(smooth_textured_line),%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 13
.L5483:
.L5484:
	ba	.L5485
	nop

	! block 14
.L5477:
.L5486:
.L5487:
.L5488:

!  907	         }
!  908	         else {
!  909	            ctx->Driver.LineFunc = flat_textured_line;

	sethi	%hi(flat_textured_line),%l1
	or	%l1,%lo(flat_textured_line),%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 15
.L5489:
.L5490:
.L5485:
.L5491:
.L5492:
.L5493:
	ba	.L5494
	nop

	! block 16
.L5471:
.L5495:
.L5496:
.L5498:

!  910	         }
!  911	      }
!  912	      else if (ctx->Line.Width!=1.0 || ctx->Line.StippleFlag
!  913	               || ctx->Line.SmoothFlag || ctx->Texture.Enabled) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fcmpd	%f6,%f4
	fbne	.L5499
	nop

	! block 17
.L5500:
	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L5499
	nop

	! block 18
.L5501:
	ld	[%fp+68],%l0
	sethi	%hi(0xae08),%l1
	or	%l1,%lo(0xae08),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L5499
	nop

	! block 19
.L5502:
	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L5497
	nop

	! block 20
.L5503:
.L5499:
.L5504:
.L5505:
.L5506:
.L5508:

!  914	         if (ctx->Light.ShadeModel==GL_SMOOTH) {

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1d01),%l0
	or	%l0,%lo(0x1d01),%l0
	cmp	%l1,%l0
	bne	.L5507
	nop

	! block 21
.L5509:
.L5510:
.L5511:
.L5512:

!  915	            ctx->Driver.LineFunc = rgbmode ? general_smooth_rgba_line
!  916	                                           : general_smooth_ci_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5513
	nop

	! block 22
.L5514:
	sethi	%hi(general_smooth_rgba_line),%l0
	or	%l0,%lo(general_smooth_rgba_line),%l0
	ba	.L5515
	st	%l0,[%fp-8]

	! block 23
.L5513:
	sethi	%hi(general_smooth_ci_line),%l0
	or	%l0,%lo(general_smooth_ci_line),%l0
	st	%l0,[%fp-8]

	! block 24
.L5515:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 25
.L5516:
.L5517:
	ba	.L5518
	nop

	! block 26
.L5507:
.L5519:
.L5520:
.L5521:

!  917	         }
!  918	         else {
!  919	            ctx->Driver.LineFunc = rgbmode ? general_flat_rgba_line
!  920	                                           : general_flat_ci_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5522
	nop

	! block 27
.L5523:
	sethi	%hi(general_flat_rgba_line),%l0
	or	%l0,%lo(general_flat_rgba_line),%l0
	ba	.L5524
	st	%l0,[%fp-8]

	! block 28
.L5522:
	sethi	%hi(general_flat_ci_line),%l0
	or	%l0,%lo(general_flat_ci_line),%l0
	st	%l0,[%fp-8]

	! block 29
.L5524:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 30
.L5525:
.L5526:
.L5518:
.L5527:
.L5528:
.L5529:
	ba	.L5530
	nop

	! block 31
.L5497:
.L5531:
.L5532:
.L5533:
.L5535:

!  921	         }
!  922	      }
!  923	      else {
!  924		 if (ctx->Light.ShadeModel==GL_SMOOTH) {

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1d01),%l0
	or	%l0,%lo(0x1d01),%l0
	cmp	%l1,%l0
	bne	.L5534
	nop

	! block 32
.L5536:
.L5537:
.L5538:
.L5539:
.L5541:

!  925		    /* Width==1, non-stippled, smooth-shaded */
!  926	            if (ctx->Depth.Test
!  927		        || (ctx->Fog.Enabled && ctx->Hint.Fog==GL_NICEST)) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L5542
	nop

	! block 33
.L5543:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L5540
	nop

	! block 34
.L5544:
	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1102),%l0
	or	%l0,%lo(0x1102),%l0
	cmp	%l1,%l0
	bne	.L5540
	nop

	! block 35
.L5545:
.L5542:
.L5546:
.L5547:
.L5548:

!  928	               ctx->Driver.LineFunc = rgbmode ? smooth_rgba_z_line
!  929	                                              : smooth_ci_z_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5549
	nop

	! block 36
.L5550:
	sethi	%hi(smooth_rgba_z_line),%l0
	or	%l0,%lo(smooth_rgba_z_line),%l0
	ba	.L5551
	st	%l0,[%fp-8]

	! block 37
.L5549:
	sethi	%hi(smooth_ci_z_line),%l0
	or	%l0,%lo(smooth_ci_z_line),%l0
	st	%l0,[%fp-8]

	! block 38
.L5551:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 39
.L5552:
.L5553:
	ba	.L5554
	nop

	! block 40
.L5540:
.L5555:
.L5556:
.L5557:

!  930	            }
!  931	            else {
!  932	               ctx->Driver.LineFunc = rgbmode ? smooth_rgba_line
!  933	                                              : smooth_ci_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5558
	nop

	! block 41
.L5559:
	sethi	%hi(smooth_rgba_line),%l0
	or	%l0,%lo(smooth_rgba_line),%l0
	ba	.L5560
	st	%l0,[%fp-8]

	! block 42
.L5558:
	sethi	%hi(smooth_ci_line),%l0
	or	%l0,%lo(smooth_ci_line),%l0
	st	%l0,[%fp-8]

	! block 43
.L5560:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 44
.L5561:
.L5562:
.L5554:
.L5563:
.L5564:
.L5565:
	ba	.L5566
	nop

	! block 45
.L5534:
.L5567:
.L5568:
.L5569:
.L5571:

!  934	            }
!  935		 }
!  936	         else {
!  937		    /* Width==1, non-stippled, flat-shaded */
!  938	            if (ctx->Depth.Test
!  939	                || (ctx->Fog.Enabled && ctx->Hint.Fog==GL_NICEST)) {

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	bne	.L5572
	nop

	! block 46
.L5573:
	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L5570
	nop

	! block 47
.L5574:
	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1102),%l0
	or	%l0,%lo(0x1102),%l0
	cmp	%l1,%l0
	bne	.L5570
	nop

	! block 48
.L5575:
.L5572:
.L5576:
.L5577:
.L5578:

!  940	               ctx->Driver.LineFunc = rgbmode ? flat_rgba_z_line
!  941	                                              : flat_ci_z_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5579
	nop

	! block 49
.L5580:
	sethi	%hi(flat_rgba_z_line),%l0
	or	%l0,%lo(flat_rgba_z_line),%l0
	ba	.L5581
	st	%l0,[%fp-8]

	! block 50
.L5579:
	sethi	%hi(flat_ci_z_line),%l0
	or	%l0,%lo(flat_ci_z_line),%l0
	st	%l0,[%fp-8]

	! block 51
.L5581:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 52
.L5582:
.L5583:
	ba	.L5584
	nop

	! block 53
.L5570:
.L5585:
.L5586:
.L5587:

!  942	            }
!  943	            else {
!  944	               ctx->Driver.LineFunc = rgbmode ? flat_rgba_line
!  945	                                              : flat_ci_line;

	ldub	[%fp-1],%l0
	cmp	%l0,%g0
	be	.L5588
	nop

	! block 54
.L5589:
	sethi	%hi(flat_rgba_line),%l0
	or	%l0,%lo(flat_rgba_line),%l0
	ba	.L5590
	st	%l0,[%fp-8]

	! block 55
.L5588:
	sethi	%hi(flat_ci_line),%l0
	or	%l0,%lo(flat_ci_line),%l0
	st	%l0,[%fp-8]

	! block 56
.L5590:
	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 57
.L5591:
.L5592:
.L5584:
.L5593:
.L5594:
.L5595:
.L5566:
.L5596:
.L5597:
.L5598:
.L5530:
.L5599:
.L5600:
.L5494:
.L5601:
.L5602:
.L5468:
.L5603:
.L5604:
.L5605:
	ba	.L5606
	nop

	! block 58
.L5443:
.L5607:
.L5608:
.L5610:

!  946	            }
!  947	         }
!  948	      }
!  949	   }
!  950	   else if (ctx->RenderMode==GL_FEEDBACK) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1c01),%l0
	or	%l0,%lo(0x1c01),%l0
	cmp	%l1,%l0
	bne	.L5609
	nop

	! block 59
.L5611:
.L5612:
.L5613:
.L5614:

!  951	      ctx->Driver.LineFunc = feedback_line;

	sethi	%hi(feedback_line),%l1
	or	%l1,%lo(feedback_line),%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 60
.L5615:
.L5616:
	ba	.L5617
	nop

	! block 61
.L5609:
.L5618:
.L5619:
.L5620:

!  952	   }
!  953	   else {
!  954	      /* GL_SELECT mode */
!  955	      ctx->Driver.LineFunc = select_line;

	sethi	%hi(select_line),%l1
	or	%l1,%lo(select_line),%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+2352]

	! block 62
.L5621:
.L5622:
.L5617:
.L5623:
.L5624:
.L5606:
.L5625:

	! block 63
.L5626:
.L5627:
.L5437:
	jmp	%i7+8
	restore
	.size	gl_set_line_function,(.-gl_set_line_function)
	.align	8

	.section	".rodata1",#alloc
	.align	4
.L23:
	.ascii	"glLineWidth\000"
	.type	.L23,#object
	.size	.L23,12
	.align	4
.L35:
	.ascii	"glLineWidth\000"
	.type	.L35,#object
	.size	.L35,12

	.section	".rodata",#alloc
	.align	8
Drodata.rodata:
.L_cseg0:
	.skip	8
	.type	.L_cseg0,#object
	.size	.L_cseg0,8

	.section	".rodata1",#alloc
	.align	4
.L56:
	.ascii	"glLineStipple\000"
	.type	.L56,#object
	.size	.L56,14

	.section	".rodata",#alloc
	.align	4
.L_cseg1:
	.word	0x477fff00
	.type	.L_cseg1,#object
	.size	.L_cseg1,4
	.align	8
.L_cseg2:
	.word	0x3ff00000,0x0
	.type	.L_cseg2,#object
	.size	.L_cseg2,8
	.align	4
.L_cseg3:
	.word	0x3f800000
	.type	.L_cseg3,#object
	.size	.L_cseg3,4
	.align	4
.L_cseg4:
	.word	0x44e0e000
	.type	.L_cseg4,#object
	.size	.L_cseg4,4
	.align	4
.L_cseg5:
	.word	0x44e04000
	.type	.L_cseg5,#object
	.size	.L_cseg5,4
	.align	4
.L_cseg6:
	.word	0x45000000
	.type	.L_cseg6,#object
	.size	.L_cseg6,4
	.align	8
.L_cseg7:
	.word	0x40240000,0x0
	.type	.L_cseg7,#object
	.size	.L_cseg7,8
	.align	4
.L_cseg8:
	.word	0x40000000
	.type	.L_cseg8,#object
	.size	.L_cseg8,4
	.section	".bss",#alloc,#write
Bbss.bss:
	.section	".data",#alloc,#write
Ddata.data:

	.file	"lines.c"
	.ident	"@(#)math.h	2.24	04/10/23 SMI"
	.ident	"@(#)math_iso.h	1.9	04/10/23 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)math_c99.h	1.9	04/11/01 SMI"
	.ident	"@(#)floatingpoint.h	2.9	04/10/23 SMI"
	.ident	"@(#)stdio_tag.h	1.4	04/09/28 SMI"
	.ident	"@(#)ieeefp.h	2.12	04/10/23 SMI"
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
!   reloc[1]: knd=2, off=253, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=275, siz=4, lab1=gl_LineWidth, lab2=, loff=0
!   reloc[3]: knd=0, off=279, siz=4, lab1=.L43, lab2=, loff=0
!   reloc[4]: knd=0, off=39512, siz=4, lab1=gl_LineStipple, lab2=, loff=0
!   reloc[5]: knd=0, off=39516, siz=4, lab1=.L71, lab2=, loff=0
!   reloc[6]: knd=0, off=39599, siz=4, lab1=feedback_line, lab2=, loff=0
!   reloc[7]: knd=0, off=39603, siz=4, lab1=.L148, lab2=, loff=0
!   reloc[8]: knd=0, off=39950, siz=4, lab1=.L138, lab2=, loff=0
!   reloc[9]: knd=0, off=39954, siz=4, lab1=.L145, lab2=, loff=0
!   reloc[10]: knd=0, off=40045, siz=4, lab1=select_line, lab2=, loff=0
!   reloc[11]: knd=0, off=40049, siz=4, lab1=.L157, lab2=, loff=0
!   reloc[12]: knd=0, off=40136, siz=4, lab1=flat_ci_line, lab2=, loff=0
!   reloc[13]: knd=0, off=40140, siz=4, lab1=.L324, lab2=, loff=0
!   reloc[14]: knd=0, off=40266, siz=4, lab1=.L177, lab2=, loff=0
!   reloc[15]: knd=0, off=40270, siz=4, lab1=.L312, lab2=, loff=0
!   reloc[16]: knd=0, off=40407, siz=4, lab1=.L228, lab2=, loff=0
!   reloc[17]: knd=0, off=40411, siz=4, lab1=.L311, lab2=, loff=0
!   reloc[18]: knd=0, off=40416, siz=4, lab1=.L232, lab2=, loff=0
!   reloc[19]: knd=0, off=40420, siz=4, lab1=.L270, lab2=, loff=0
!   reloc[20]: knd=0, off=40425, siz=4, lab1=.L233, lab2=, loff=0
!   reloc[21]: knd=0, off=40429, siz=4, lab1=.L269, lab2=, loff=0
!   reloc[22]: knd=0, off=40506, siz=4, lab1=.L272, lab2=, loff=0
!   reloc[23]: knd=0, off=40510, siz=4, lab1=.L310, lab2=, loff=0
!   reloc[24]: knd=0, off=40515, siz=4, lab1=.L273, lab2=, loff=0
!   reloc[25]: knd=0, off=40519, siz=4, lab1=.L309, lab2=, loff=0
!   reloc[26]: knd=0, off=40626, siz=4, lab1=flat_ci_z_line, lab2=, loff=0
!   reloc[27]: knd=0, off=40630, siz=4, lab1=.L509, lab2=, loff=0
!   reloc[28]: knd=0, off=40771, siz=4, lab1=.L345, lab2=, loff=0
!   reloc[29]: knd=0, off=40775, siz=4, lab1=.L497, lab2=, loff=0
!   reloc[30]: knd=0, off=41015, siz=4, lab1=.L403, lab2=, loff=0
!   reloc[31]: knd=0, off=41019, siz=4, lab1=.L496, lab2=, loff=0
!   reloc[32]: knd=0, off=41024, siz=4, lab1=.L407, lab2=, loff=0
!   reloc[33]: knd=0, off=41028, siz=4, lab1=.L450, lab2=, loff=0
!   reloc[34]: knd=0, off=41033, siz=4, lab1=.L408, lab2=, loff=0
!   reloc[35]: knd=0, off=41037, siz=4, lab1=.L449, lab2=, loff=0
!   reloc[36]: knd=0, off=41116, siz=4, lab1=.L413, lab2=, loff=0
!   reloc[37]: knd=0, off=41120, siz=4, lab1=.L448, lab2=, loff=0
!   reloc[38]: knd=0, off=41125, siz=4, lab1=.L419, lab2=, loff=0
!   reloc[39]: knd=0, off=41129, siz=4, lab1=.L445, lab2=, loff=0
!   reloc[40]: knd=0, off=41134, siz=4, lab1=.L420, lab2=, loff=0
!   reloc[41]: knd=0, off=41138, siz=4, lab1=.L444, lab2=, loff=0
!   reloc[42]: knd=0, off=41163, siz=4, lab1=.L452, lab2=, loff=0
!   reloc[43]: knd=0, off=41167, siz=4, lab1=.L495, lab2=, loff=0
!   reloc[44]: knd=0, off=41172, siz=4, lab1=.L453, lab2=, loff=0
!   reloc[45]: knd=0, off=41176, siz=4, lab1=.L494, lab2=, loff=0
!   reloc[46]: knd=0, off=41259, siz=4, lab1=.L458, lab2=, loff=0
!   reloc[47]: knd=0, off=41263, siz=4, lab1=.L493, lab2=, loff=0
!   reloc[48]: knd=0, off=41268, siz=4, lab1=.L464, lab2=, loff=0
!   reloc[49]: knd=0, off=41272, siz=4, lab1=.L490, lab2=, loff=0
!   reloc[50]: knd=0, off=41277, siz=4, lab1=.L465, lab2=, loff=0
!   reloc[51]: knd=0, off=41281, siz=4, lab1=.L489, lab2=, loff=0
!   reloc[52]: knd=0, off=41328, siz=4, lab1=flat_rgba_line, lab2=, loff=0
!   reloc[53]: knd=0, off=41332, siz=4, lab1=.L680, lab2=, loff=0
!   reloc[54]: knd=0, off=41483, siz=4, lab1=.L533, lab2=, loff=0
!   reloc[55]: knd=0, off=41487, siz=4, lab1=.L668, lab2=, loff=0
!   reloc[56]: knd=0, off=41624, siz=4, lab1=.L584, lab2=, loff=0
!   reloc[57]: knd=0, off=41628, siz=4, lab1=.L667, lab2=, loff=0
!   reloc[58]: knd=0, off=41633, siz=4, lab1=.L588, lab2=, loff=0
!   reloc[59]: knd=0, off=41637, siz=4, lab1=.L626, lab2=, loff=0
!   reloc[60]: knd=0, off=41642, siz=4, lab1=.L589, lab2=, loff=0
!   reloc[61]: knd=0, off=41646, siz=4, lab1=.L625, lab2=, loff=0
!   reloc[62]: knd=0, off=41724, siz=4, lab1=.L628, lab2=, loff=0
!   reloc[63]: knd=0, off=41728, siz=4, lab1=.L666, lab2=, loff=0
!   reloc[64]: knd=0, off=41733, siz=4, lab1=.L629, lab2=, loff=0
!   reloc[65]: knd=0, off=41737, siz=4, lab1=.L665, lab2=, loff=0
!   reloc[66]: knd=0, off=41843, siz=4, lab1=flat_rgba_z_line, lab2=, loff=0
!   reloc[67]: knd=0, off=41847, siz=4, lab1=.L869, lab2=, loff=0
!   reloc[68]: knd=0, off=42014, siz=4, lab1=.L705, lab2=, loff=0
!   reloc[69]: knd=0, off=42018, siz=4, lab1=.L857, lab2=, loff=0
!   reloc[70]: knd=0, off=42259, siz=4, lab1=.L763, lab2=, loff=0
!   reloc[71]: knd=0, off=42263, siz=4, lab1=.L856, lab2=, loff=0
!   reloc[72]: knd=0, off=42268, siz=4, lab1=.L767, lab2=, loff=0
!   reloc[73]: knd=0, off=42272, siz=4, lab1=.L810, lab2=, loff=0
!   reloc[74]: knd=0, off=42277, siz=4, lab1=.L768, lab2=, loff=0
!   reloc[75]: knd=0, off=42281, siz=4, lab1=.L809, lab2=, loff=0
!   reloc[76]: knd=0, off=42360, siz=4, lab1=.L773, lab2=, loff=0
!   reloc[77]: knd=0, off=42364, siz=4, lab1=.L808, lab2=, loff=0
!   reloc[78]: knd=0, off=42369, siz=4, lab1=.L779, lab2=, loff=0
!   reloc[79]: knd=0, off=42373, siz=4, lab1=.L805, lab2=, loff=0
!   reloc[80]: knd=0, off=42378, siz=4, lab1=.L780, lab2=, loff=0
!   reloc[81]: knd=0, off=42382, siz=4, lab1=.L804, lab2=, loff=0
!   reloc[82]: knd=0, off=42407, siz=4, lab1=.L812, lab2=, loff=0
!   reloc[83]: knd=0, off=42411, siz=4, lab1=.L855, lab2=, loff=0
!   reloc[84]: knd=0, off=42416, siz=4, lab1=.L813, lab2=, loff=0
!   reloc[85]: knd=0, off=42420, siz=4, lab1=.L854, lab2=, loff=0
!   reloc[86]: knd=0, off=42503, siz=4, lab1=.L818, lab2=, loff=0
!   reloc[87]: knd=0, off=42507, siz=4, lab1=.L853, lab2=, loff=0
!   reloc[88]: knd=0, off=42512, siz=4, lab1=.L824, lab2=, loff=0
!   reloc[89]: knd=0, off=42516, siz=4, lab1=.L850, lab2=, loff=0
!   reloc[90]: knd=0, off=42521, siz=4, lab1=.L825, lab2=, loff=0
!   reloc[91]: knd=0, off=42525, siz=4, lab1=.L849, lab2=, loff=0
!   reloc[92]: knd=0, off=42572, siz=4, lab1=smooth_ci_line, lab2=, loff=0
!   reloc[93]: knd=0, off=42576, siz=4, lab1=.L1033, lab2=, loff=0
!   reloc[94]: knd=0, off=42725, siz=4, lab1=.L879, lab2=, loff=0
!   reloc[95]: knd=0, off=42729, siz=4, lab1=.L1021, lab2=, loff=0
!   reloc[96]: knd=0, off=42894, siz=4, lab1=.L931, lab2=, loff=0
!   reloc[97]: knd=0, off=42898, siz=4, lab1=.L1020, lab2=, loff=0
!   reloc[98]: knd=0, off=42903, siz=4, lab1=.L935, lab2=, loff=0
!   reloc[99]: knd=0, off=42907, siz=4, lab1=.L976, lab2=, loff=0
!   reloc[100]: knd=0, off=42912, siz=4, lab1=.L936, lab2=, loff=0
!   reloc[101]: knd=0, off=42916, siz=4, lab1=.L975, lab2=, loff=0
!   reloc[102]: knd=0, off=42994, siz=4, lab1=.L941, lab2=, loff=0
!   reloc[103]: knd=0, off=42998, siz=4, lab1=.L974, lab2=, loff=0
!   reloc[104]: knd=0, off=43003, siz=4, lab1=.L947, lab2=, loff=0
!   reloc[105]: knd=0, off=43007, siz=4, lab1=.L971, lab2=, loff=0
!   reloc[106]: knd=0, off=43012, siz=4, lab1=.L948, lab2=, loff=0
!   reloc[107]: knd=0, off=43016, siz=4, lab1=.L970, lab2=, loff=0
!   reloc[108]: knd=0, off=43041, siz=4, lab1=.L978, lab2=, loff=0
!   reloc[109]: knd=0, off=43045, siz=4, lab1=.L1019, lab2=, loff=0
!   reloc[110]: knd=0, off=43050, siz=4, lab1=.L979, lab2=, loff=0
!   reloc[111]: knd=0, off=43054, siz=4, lab1=.L1018, lab2=, loff=0
!   reloc[112]: knd=0, off=43136, siz=4, lab1=.L984, lab2=, loff=0
!   reloc[113]: knd=0, off=43140, siz=4, lab1=.L1017, lab2=, loff=0
!   reloc[114]: knd=0, off=43145, siz=4, lab1=.L990, lab2=, loff=0
!   reloc[115]: knd=0, off=43149, siz=4, lab1=.L1014, lab2=, loff=0
!   reloc[116]: knd=0, off=43154, siz=4, lab1=.L991, lab2=, loff=0
!   reloc[117]: knd=0, off=43158, siz=4, lab1=.L1013, lab2=, loff=0
!   reloc[118]: knd=0, off=43207, siz=4, lab1=smooth_ci_z_line, lab2=, loff=0
!   reloc[119]: knd=0, off=43211, siz=4, lab1=.L1215, lab2=, loff=0
!   reloc[120]: knd=0, off=43376, siz=4, lab1=.L1044, lab2=, loff=0
!   reloc[121]: knd=0, off=43380, siz=4, lab1=.L1203, lab2=, loff=0
!   reloc[122]: knd=0, off=43651, siz=4, lab1=.L1103, lab2=, loff=0
!   reloc[123]: knd=0, off=43655, siz=4, lab1=.L1202, lab2=, loff=0
!   reloc[124]: knd=0, off=43660, siz=4, lab1=.L1107, lab2=, loff=0
!   reloc[125]: knd=0, off=43664, siz=4, lab1=.L1153, lab2=, loff=0
!   reloc[126]: knd=0, off=43669, siz=4, lab1=.L1108, lab2=, loff=0
!   reloc[127]: knd=0, off=43673, siz=4, lab1=.L1152, lab2=, loff=0
!   reloc[128]: knd=0, off=43752, siz=4, lab1=.L1114, lab2=, loff=0
!   reloc[129]: knd=0, off=43756, siz=4, lab1=.L1151, lab2=, loff=0
!   reloc[130]: knd=0, off=43761, siz=4, lab1=.L1120, lab2=, loff=0
!   reloc[131]: knd=0, off=43765, siz=4, lab1=.L1148, lab2=, loff=0
!   reloc[132]: knd=0, off=43770, siz=4, lab1=.L1121, lab2=, loff=0
!   reloc[133]: knd=0, off=43774, siz=4, lab1=.L1147, lab2=, loff=0
!   reloc[134]: knd=0, off=43814, siz=4, lab1=.L1155, lab2=, loff=0
!   reloc[135]: knd=0, off=43818, siz=4, lab1=.L1201, lab2=, loff=0
!   reloc[136]: knd=0, off=43823, siz=4, lab1=.L1156, lab2=, loff=0
!   reloc[137]: knd=0, off=43827, siz=4, lab1=.L1200, lab2=, loff=0
!   reloc[138]: knd=0, off=43910, siz=4, lab1=.L1162, lab2=, loff=0
!   reloc[139]: knd=0, off=43914, siz=4, lab1=.L1199, lab2=, loff=0
!   reloc[140]: knd=0, off=43919, siz=4, lab1=.L1168, lab2=, loff=0
!   reloc[141]: knd=0, off=43923, siz=4, lab1=.L1196, lab2=, loff=0
!   reloc[142]: knd=0, off=43928, siz=4, lab1=.L1169, lab2=, loff=0
!   reloc[143]: knd=0, off=43932, siz=4, lab1=.L1195, lab2=, loff=0
!   reloc[144]: knd=0, off=43996, siz=4, lab1=smooth_rgba_line, lab2=, loff=0
!   reloc[145]: knd=0, off=44000, siz=4, lab1=.L1399, lab2=, loff=0
!   reloc[146]: knd=0, off=44197, siz=4, lab1=.L1228, lab2=, loff=0
!   reloc[147]: knd=0, off=44201, siz=4, lab1=.L1387, lab2=, loff=0
!   reloc[148]: knd=0, off=44458, siz=4, lab1=.L1287, lab2=, loff=0
!   reloc[149]: knd=0, off=44462, siz=4, lab1=.L1386, lab2=, loff=0
!   reloc[150]: knd=0, off=44467, siz=4, lab1=.L1291, lab2=, loff=0
!   reloc[151]: knd=0, off=44471, siz=4, lab1=.L1337, lab2=, loff=0
!   reloc[152]: knd=0, off=44476, siz=4, lab1=.L1292, lab2=, loff=0
!   reloc[153]: knd=0, off=44480, siz=4, lab1=.L1336, lab2=, loff=0
!   reloc[154]: knd=0, off=44561, siz=4, lab1=.L1339, lab2=, loff=0
!   reloc[155]: knd=0, off=44565, siz=4, lab1=.L1385, lab2=, loff=0
!   reloc[156]: knd=0, off=44570, siz=4, lab1=.L1340, lab2=, loff=0
!   reloc[157]: knd=0, off=44574, siz=4, lab1=.L1384, lab2=, loff=0
!   reloc[158]: knd=0, off=44699, siz=4, lab1=smooth_rgba_z_line, lab2=, loff=0
!   reloc[159]: knd=0, off=44703, siz=4, lab1=.L1601, lab2=, loff=0
!   reloc[160]: knd=0, off=44916, siz=4, lab1=.L1413, lab2=, loff=0
!   reloc[161]: knd=0, off=44920, siz=4, lab1=.L1589, lab2=, loff=0
!   reloc[162]: knd=0, off=45284, siz=4, lab1=.L1479, lab2=, loff=0
!   reloc[163]: knd=0, off=45288, siz=4, lab1=.L1588, lab2=, loff=0
!   reloc[164]: knd=0, off=45293, siz=4, lab1=.L1483, lab2=, loff=0
!   reloc[165]: knd=0, off=45297, siz=4, lab1=.L1534, lab2=, loff=0
!   reloc[166]: knd=0, off=45302, siz=4, lab1=.L1484, lab2=, loff=0
!   reloc[167]: knd=0, off=45306, siz=4, lab1=.L1533, lab2=, loff=0
!   reloc[168]: knd=0, off=45385, siz=4, lab1=.L1493, lab2=, loff=0
!   reloc[169]: knd=0, off=45389, siz=4, lab1=.L1532, lab2=, loff=0
!   reloc[170]: knd=0, off=45394, siz=4, lab1=.L1499, lab2=, loff=0
!   reloc[171]: knd=0, off=45398, siz=4, lab1=.L1529, lab2=, loff=0
!   reloc[172]: knd=0, off=45403, siz=4, lab1=.L1500, lab2=, loff=0
!   reloc[173]: knd=0, off=45407, siz=4, lab1=.L1528, lab2=, loff=0
!   reloc[174]: knd=0, off=45432, siz=4, lab1=.L1536, lab2=, loff=0
!   reloc[175]: knd=0, off=45436, siz=4, lab1=.L1587, lab2=, loff=0
!   reloc[176]: knd=0, off=45441, siz=4, lab1=.L1537, lab2=, loff=0
!   reloc[177]: knd=0, off=45445, siz=4, lab1=.L1586, lab2=, loff=0
!   reloc[178]: knd=0, off=45528, siz=4, lab1=.L1546, lab2=, loff=0
!   reloc[179]: knd=0, off=45532, siz=4, lab1=.L1585, lab2=, loff=0
!   reloc[180]: knd=0, off=45537, siz=4, lab1=.L1552, lab2=, loff=0
!   reloc[181]: knd=0, off=45541, siz=4, lab1=.L1582, lab2=, loff=0
!   reloc[182]: knd=0, off=45546, siz=4, lab1=.L1553, lab2=, loff=0
!   reloc[183]: knd=0, off=45550, siz=4, lab1=.L1581, lab2=, loff=0
!   reloc[184]: knd=0, off=45605, siz=4, lab1=general_smooth_ci_line, lab2=, loff=0
!   reloc[185]: knd=0, off=45609, siz=4, lab1=.L2263, lab2=, loff=0
!   reloc[186]: knd=0, off=45774, siz=4, lab1=.L1612, lab2=, loff=0
!   reloc[187]: knd=0, off=45778, siz=4, lab1=.L2251, lab2=, loff=0
!   reloc[188]: knd=0, off=45783, siz=4, lab1=.L1616, lab2=, loff=0
!   reloc[189]: knd=0, off=45787, siz=4, lab1=.L1856, lab2=, loff=0
!   reloc[190]: knd=0, off=45792, siz=4, lab1=.L1617, lab2=, loff=0
!   reloc[191]: knd=0, off=45796, siz=4, lab1=.L1855, lab2=, loff=0
!   reloc[192]: knd=0, off=45801, siz=4, lab1=.L1618, lab2=, loff=0
!   reloc[193]: knd=0, off=45805, siz=4, lab1=.L1854, lab2=, loff=0
!   reloc[194]: knd=0, off=46126, siz=4, lab1=.L1686, lab2=, loff=0
!   reloc[195]: knd=0, off=46130, siz=4, lab1=.L1853, lab2=, loff=0
!   reloc[196]: knd=0, off=46135, siz=4, lab1=.L1690, lab2=, loff=0
!   reloc[197]: knd=0, off=46139, siz=4, lab1=.L1770, lab2=, loff=0
!   reloc[198]: knd=0, off=46144, siz=4, lab1=.L1691, lab2=, loff=0
!   reloc[199]: knd=0, off=46148, siz=4, lab1=.L1769, lab2=, loff=0
!   reloc[200]: knd=0, off=46227, siz=4, lab1=.L1697, lab2=, loff=0
!   reloc[201]: knd=0, off=46231, siz=4, lab1=.L1768, lab2=, loff=0
!   reloc[202]: knd=0, off=46236, siz=4, lab1=.L1703, lab2=, loff=0
!   reloc[203]: knd=0, off=46240, siz=4, lab1=.L1765, lab2=, loff=0
!   reloc[204]: knd=0, off=46245, siz=4, lab1=.L1704, lab2=, loff=0
!   reloc[205]: knd=0, off=46249, siz=4, lab1=.L1764, lab2=, loff=0
!   reloc[206]: knd=0, off=46269, siz=4, lab1=.L1706, lab2=, loff=0
!   reloc[207]: knd=0, off=46273, siz=4, lab1=.L1740, lab2=, loff=0
!   reloc[208]: knd=0, off=46278, siz=4, lab1=.L1710, lab2=, loff=0
!   reloc[209]: knd=0, off=46282, siz=4, lab1=.L1739, lab2=, loff=0
!   reloc[210]: knd=0, off=46287, siz=4, lab1=.L1711, lab2=, loff=0
!   reloc[211]: knd=0, off=46291, siz=4, lab1=.L1738, lab2=, loff=0
!   reloc[212]: knd=0, off=46386, siz=4, lab1=.L1772, lab2=, loff=0
!   reloc[213]: knd=0, off=46390, siz=4, lab1=.L1852, lab2=, loff=0
!   reloc[214]: knd=0, off=46395, siz=4, lab1=.L1773, lab2=, loff=0
!   reloc[215]: knd=0, off=46399, siz=4, lab1=.L1851, lab2=, loff=0
!   reloc[216]: knd=0, off=46482, siz=4, lab1=.L1779, lab2=, loff=0
!   reloc[217]: knd=0, off=46486, siz=4, lab1=.L1850, lab2=, loff=0
!   reloc[218]: knd=0, off=46491, siz=4, lab1=.L1785, lab2=, loff=0
!   reloc[219]: knd=0, off=46495, siz=4, lab1=.L1847, lab2=, loff=0
!   reloc[220]: knd=0, off=46500, siz=4, lab1=.L1786, lab2=, loff=0
!   reloc[221]: knd=0, off=46504, siz=4, lab1=.L1846, lab2=, loff=0
!   reloc[222]: knd=0, off=46524, siz=4, lab1=.L1788, lab2=, loff=0
!   reloc[223]: knd=0, off=46528, siz=4, lab1=.L1822, lab2=, loff=0
!   reloc[224]: knd=0, off=46533, siz=4, lab1=.L1792, lab2=, loff=0
!   reloc[225]: knd=0, off=46537, siz=4, lab1=.L1821, lab2=, loff=0
!   reloc[226]: knd=0, off=46542, siz=4, lab1=.L1793, lab2=, loff=0
!   reloc[227]: knd=0, off=46546, siz=4, lab1=.L1820, lab2=, loff=0
!   reloc[228]: knd=0, off=46645, siz=4, lab1=.L1858, lab2=, loff=0
!   reloc[229]: knd=0, off=46649, siz=4, lab1=.L2250, lab2=, loff=0
!   reloc[230]: knd=0, off=46654, siz=4, lab1=.L1859, lab2=, loff=0
!   reloc[231]: knd=0, off=46658, siz=4, lab1=.L2249, lab2=, loff=0
!   reloc[232]: knd=0, off=46663, siz=4, lab1=.L1860, lab2=, loff=0
!   reloc[233]: knd=0, off=46667, siz=4, lab1=.L2248, lab2=, loff=0
!   reloc[234]: knd=0, off=46672, siz=4, lab1=.L1864, lab2=, loff=0
!   reloc[235]: knd=0, off=46676, siz=4, lab1=.L2027, lab2=, loff=0
!   reloc[236]: knd=0, off=46681, siz=4, lab1=.L1865, lab2=, loff=0
!   reloc[237]: knd=0, off=46685, siz=4, lab1=.L2026, lab2=, loff=0
!   reloc[238]: knd=0, off=46690, siz=4, lab1=.L1866, lab2=, loff=0
!   reloc[239]: knd=0, off=46694, siz=4, lab1=.L2025, lab2=, loff=0
!   reloc[240]: knd=0, off=46965, siz=4, lab1=.L1925, lab2=, loff=0
!   reloc[241]: knd=0, off=46969, siz=4, lab1=.L2024, lab2=, loff=0
!   reloc[242]: knd=0, off=46974, siz=4, lab1=.L1929, lab2=, loff=0
!   reloc[243]: knd=0, off=46978, siz=4, lab1=.L1975, lab2=, loff=0
!   reloc[244]: knd=0, off=46983, siz=4, lab1=.L1930, lab2=, loff=0
!   reloc[245]: knd=0, off=46987, siz=4, lab1=.L1974, lab2=, loff=0
!   reloc[246]: knd=0, off=47066, siz=4, lab1=.L1936, lab2=, loff=0
!   reloc[247]: knd=0, off=47070, siz=4, lab1=.L1973, lab2=, loff=0
!   reloc[248]: knd=0, off=47075, siz=4, lab1=.L1942, lab2=, loff=0
!   reloc[249]: knd=0, off=47079, siz=4, lab1=.L1970, lab2=, loff=0
!   reloc[250]: knd=0, off=47084, siz=4, lab1=.L1943, lab2=, loff=0
!   reloc[251]: knd=0, off=47088, siz=4, lab1=.L1969, lab2=, loff=0
!   reloc[252]: knd=0, off=47128, siz=4, lab1=.L1977, lab2=, loff=0
!   reloc[253]: knd=0, off=47132, siz=4, lab1=.L2023, lab2=, loff=0
!   reloc[254]: knd=0, off=47137, siz=4, lab1=.L1978, lab2=, loff=0
!   reloc[255]: knd=0, off=47141, siz=4, lab1=.L2022, lab2=, loff=0
!   reloc[256]: knd=0, off=47224, siz=4, lab1=.L1984, lab2=, loff=0
!   reloc[257]: knd=0, off=47228, siz=4, lab1=.L2021, lab2=, loff=0
!   reloc[258]: knd=0, off=47233, siz=4, lab1=.L1990, lab2=, loff=0
!   reloc[259]: knd=0, off=47237, siz=4, lab1=.L2018, lab2=, loff=0
!   reloc[260]: knd=0, off=47242, siz=4, lab1=.L1991, lab2=, loff=0
!   reloc[261]: knd=0, off=47246, siz=4, lab1=.L2017, lab2=, loff=0
!   reloc[262]: knd=0, off=47290, siz=4, lab1=.L2029, lab2=, loff=0
!   reloc[263]: knd=0, off=47294, siz=4, lab1=.L2247, lab2=, loff=0
!   reloc[264]: knd=0, off=47299, siz=4, lab1=.L2030, lab2=, loff=0
!   reloc[265]: knd=0, off=47303, siz=4, lab1=.L2246, lab2=, loff=0
!   reloc[266]: knd=0, off=47308, siz=4, lab1=.L2031, lab2=, loff=0
!   reloc[267]: knd=0, off=47312, siz=4, lab1=.L2245, lab2=, loff=0
!   reloc[268]: knd=0, off=47633, siz=4, lab1=.L2099, lab2=, loff=0
!   reloc[269]: knd=0, off=47637, siz=4, lab1=.L2244, lab2=, loff=0
!   reloc[270]: knd=0, off=47642, siz=4, lab1=.L2103, lab2=, loff=0
!   reloc[271]: knd=0, off=47646, siz=4, lab1=.L2172, lab2=, loff=0
!   reloc[272]: knd=0, off=47651, siz=4, lab1=.L2104, lab2=, loff=0
!   reloc[273]: knd=0, off=47655, siz=4, lab1=.L2171, lab2=, loff=0
!   reloc[274]: knd=0, off=47734, siz=4, lab1=.L2110, lab2=, loff=0
!   reloc[275]: knd=0, off=47738, siz=4, lab1=.L2170, lab2=, loff=0
!   reloc[276]: knd=0, off=47743, siz=4, lab1=.L2116, lab2=, loff=0
!   reloc[277]: knd=0, off=47747, siz=4, lab1=.L2167, lab2=, loff=0
!   reloc[278]: knd=0, off=47752, siz=4, lab1=.L2117, lab2=, loff=0
!   reloc[279]: knd=0, off=47756, siz=4, lab1=.L2166, lab2=, loff=0
!   reloc[280]: knd=0, off=47848, siz=4, lab1=.L2174, lab2=, loff=0
!   reloc[281]: knd=0, off=47852, siz=4, lab1=.L2243, lab2=, loff=0
!   reloc[282]: knd=0, off=47857, siz=4, lab1=.L2175, lab2=, loff=0
!   reloc[283]: knd=0, off=47861, siz=4, lab1=.L2242, lab2=, loff=0
!   reloc[284]: knd=0, off=47944, siz=4, lab1=.L2181, lab2=, loff=0
!   reloc[285]: knd=0, off=47948, siz=4, lab1=.L2241, lab2=, loff=0
!   reloc[286]: knd=0, off=47953, siz=4, lab1=.L2187, lab2=, loff=0
!   reloc[287]: knd=0, off=47957, siz=4, lab1=.L2238, lab2=, loff=0
!   reloc[288]: knd=0, off=47962, siz=4, lab1=.L2188, lab2=, loff=0
!   reloc[289]: knd=0, off=47966, siz=4, lab1=.L2237, lab2=, loff=0
!   reloc[290]: knd=0, off=48092, siz=4, lab1=general_flat_ci_line, lab2=, loff=0
!   reloc[291]: knd=0, off=48096, siz=4, lab1=.L2914, lab2=, loff=0
!   reloc[292]: knd=0, off=48245, siz=4, lab1=.L2284, lab2=, loff=0
!   reloc[293]: knd=0, off=48249, siz=4, lab1=.L2902, lab2=, loff=0
!   reloc[294]: knd=0, off=48254, siz=4, lab1=.L2288, lab2=, loff=0
!   reloc[295]: knd=0, off=48258, siz=4, lab1=.L2521, lab2=, loff=0
!   reloc[296]: knd=0, off=48263, siz=4, lab1=.L2289, lab2=, loff=0
!   reloc[297]: knd=0, off=48267, siz=4, lab1=.L2520, lab2=, loff=0
!   reloc[298]: knd=0, off=48272, siz=4, lab1=.L2290, lab2=, loff=0
!   reloc[299]: knd=0, off=48276, siz=4, lab1=.L2519, lab2=, loff=0
!   reloc[300]: knd=0, off=48566, siz=4, lab1=.L2357, lab2=, loff=0
!   reloc[301]: knd=0, off=48570, siz=4, lab1=.L2518, lab2=, loff=0
!   reloc[302]: knd=0, off=48575, siz=4, lab1=.L2361, lab2=, loff=0
!   reloc[303]: knd=0, off=48579, siz=4, lab1=.L2438, lab2=, loff=0
!   reloc[304]: knd=0, off=48584, siz=4, lab1=.L2362, lab2=, loff=0
!   reloc[305]: knd=0, off=48588, siz=4, lab1=.L2437, lab2=, loff=0
!   reloc[306]: knd=0, off=48667, siz=4, lab1=.L2367, lab2=, loff=0
!   reloc[307]: knd=0, off=48671, siz=4, lab1=.L2436, lab2=, loff=0
!   reloc[308]: knd=0, off=48676, siz=4, lab1=.L2373, lab2=, loff=0
!   reloc[309]: knd=0, off=48680, siz=4, lab1=.L2433, lab2=, loff=0
!   reloc[310]: knd=0, off=48685, siz=4, lab1=.L2374, lab2=, loff=0
!   reloc[311]: knd=0, off=48689, siz=4, lab1=.L2432, lab2=, loff=0
!   reloc[312]: knd=0, off=48709, siz=4, lab1=.L2376, lab2=, loff=0
!   reloc[313]: knd=0, off=48713, siz=4, lab1=.L2409, lab2=, loff=0
!   reloc[314]: knd=0, off=48718, siz=4, lab1=.L2380, lab2=, loff=0
!   reloc[315]: knd=0, off=48722, siz=4, lab1=.L2408, lab2=, loff=0
!   reloc[316]: knd=0, off=48727, siz=4, lab1=.L2381, lab2=, loff=0
!   reloc[317]: knd=0, off=48731, siz=4, lab1=.L2407, lab2=, loff=0
!   reloc[318]: knd=0, off=48811, siz=4, lab1=.L2440, lab2=, loff=0
!   reloc[319]: knd=0, off=48815, siz=4, lab1=.L2517, lab2=, loff=0
!   reloc[320]: knd=0, off=48820, siz=4, lab1=.L2441, lab2=, loff=0
!   reloc[321]: knd=0, off=48824, siz=4, lab1=.L2516, lab2=, loff=0
!   reloc[322]: knd=0, off=48907, siz=4, lab1=.L2446, lab2=, loff=0
!   reloc[323]: knd=0, off=48911, siz=4, lab1=.L2515, lab2=, loff=0
!   reloc[324]: knd=0, off=48916, siz=4, lab1=.L2452, lab2=, loff=0
!   reloc[325]: knd=0, off=48920, siz=4, lab1=.L2512, lab2=, loff=0
!   reloc[326]: knd=0, off=48925, siz=4, lab1=.L2453, lab2=, loff=0
!   reloc[327]: knd=0, off=48929, siz=4, lab1=.L2511, lab2=, loff=0
!   reloc[328]: knd=0, off=48949, siz=4, lab1=.L2455, lab2=, loff=0
!   reloc[329]: knd=0, off=48953, siz=4, lab1=.L2488, lab2=, loff=0
!   reloc[330]: knd=0, off=48958, siz=4, lab1=.L2459, lab2=, loff=0
!   reloc[331]: knd=0, off=48962, siz=4, lab1=.L2487, lab2=, loff=0
!   reloc[332]: knd=0, off=48967, siz=4, lab1=.L2460, lab2=, loff=0
!   reloc[333]: knd=0, off=48971, siz=4, lab1=.L2486, lab2=, loff=0
!   reloc[334]: knd=0, off=49055, siz=4, lab1=.L2523, lab2=, loff=0
!   reloc[335]: knd=0, off=49059, siz=4, lab1=.L2901, lab2=, loff=0
!   reloc[336]: knd=0, off=49064, siz=4, lab1=.L2524, lab2=, loff=0
!   reloc[337]: knd=0, off=49068, siz=4, lab1=.L2900, lab2=, loff=0
!   reloc[338]: knd=0, off=49073, siz=4, lab1=.L2525, lab2=, loff=0
!   reloc[339]: knd=0, off=49077, siz=4, lab1=.L2899, lab2=, loff=0
!   reloc[340]: knd=0, off=49082, siz=4, lab1=.L2529, lab2=, loff=0
!   reloc[341]: knd=0, off=49086, siz=4, lab1=.L2685, lab2=, loff=0
!   reloc[342]: knd=0, off=49091, siz=4, lab1=.L2530, lab2=, loff=0
!   reloc[343]: knd=0, off=49095, siz=4, lab1=.L2684, lab2=, loff=0
!   reloc[344]: knd=0, off=49100, siz=4, lab1=.L2531, lab2=, loff=0
!   reloc[345]: knd=0, off=49104, siz=4, lab1=.L2683, lab2=, loff=0
!   reloc[346]: knd=0, off=49344, siz=4, lab1=.L2589, lab2=, loff=0
!   reloc[347]: knd=0, off=49348, siz=4, lab1=.L2682, lab2=, loff=0
!   reloc[348]: knd=0, off=49353, siz=4, lab1=.L2593, lab2=, loff=0
!   reloc[349]: knd=0, off=49357, siz=4, lab1=.L2636, lab2=, loff=0
!   reloc[350]: knd=0, off=49362, siz=4, lab1=.L2594, lab2=, loff=0
!   reloc[351]: knd=0, off=49366, siz=4, lab1=.L2635, lab2=, loff=0
!   reloc[352]: knd=0, off=49445, siz=4, lab1=.L2599, lab2=, loff=0
!   reloc[353]: knd=0, off=49449, siz=4, lab1=.L2634, lab2=, loff=0
!   reloc[354]: knd=0, off=49454, siz=4, lab1=.L2605, lab2=, loff=0
!   reloc[355]: knd=0, off=49458, siz=4, lab1=.L2631, lab2=, loff=0
!   reloc[356]: knd=0, off=49463, siz=4, lab1=.L2606, lab2=, loff=0
!   reloc[357]: knd=0, off=49467, siz=4, lab1=.L2630, lab2=, loff=0
!   reloc[358]: knd=0, off=49492, siz=4, lab1=.L2638, lab2=, loff=0
!   reloc[359]: knd=0, off=49496, siz=4, lab1=.L2681, lab2=, loff=0
!   reloc[360]: knd=0, off=49501, siz=4, lab1=.L2639, lab2=, loff=0
!   reloc[361]: knd=0, off=49505, siz=4, lab1=.L2680, lab2=, loff=0
!   reloc[362]: knd=0, off=49588, siz=4, lab1=.L2644, lab2=, loff=0
!   reloc[363]: knd=0, off=49592, siz=4, lab1=.L2679, lab2=, loff=0
!   reloc[364]: knd=0, off=49597, siz=4, lab1=.L2650, lab2=, loff=0
!   reloc[365]: knd=0, off=49601, siz=4, lab1=.L2676, lab2=, loff=0
!   reloc[366]: knd=0, off=49606, siz=4, lab1=.L2651, lab2=, loff=0
!   reloc[367]: knd=0, off=49610, siz=4, lab1=.L2675, lab2=, loff=0
!   reloc[368]: knd=0, off=49639, siz=4, lab1=.L2687, lab2=, loff=0
!   reloc[369]: knd=0, off=49643, siz=4, lab1=.L2898, lab2=, loff=0
!   reloc[370]: knd=0, off=49648, siz=4, lab1=.L2688, lab2=, loff=0
!   reloc[371]: knd=0, off=49652, siz=4, lab1=.L2897, lab2=, loff=0
!   reloc[372]: knd=0, off=49657, siz=4, lab1=.L2689, lab2=, loff=0
!   reloc[373]: knd=0, off=49661, siz=4, lab1=.L2896, lab2=, loff=0
!   reloc[374]: knd=0, off=49951, siz=4, lab1=.L2756, lab2=, loff=0
!   reloc[375]: knd=0, off=49955, siz=4, lab1=.L2895, lab2=, loff=0
!   reloc[376]: knd=0, off=49960, siz=4, lab1=.L2760, lab2=, loff=0
!   reloc[377]: knd=0, off=49964, siz=4, lab1=.L2826, lab2=, loff=0
!   reloc[378]: knd=0, off=49969, siz=4, lab1=.L2761, lab2=, loff=0
!   reloc[379]: knd=0, off=49973, siz=4, lab1=.L2825, lab2=, loff=0
!   reloc[380]: knd=0, off=50052, siz=4, lab1=.L2766, lab2=, loff=0
!   reloc[381]: knd=0, off=50056, siz=4, lab1=.L2824, lab2=, loff=0
!   reloc[382]: knd=0, off=50061, siz=4, lab1=.L2772, lab2=, loff=0
!   reloc[383]: knd=0, off=50065, siz=4, lab1=.L2821, lab2=, loff=0
!   reloc[384]: knd=0, off=50070, siz=4, lab1=.L2773, lab2=, loff=0
!   reloc[385]: knd=0, off=50074, siz=4, lab1=.L2820, lab2=, loff=0
!   reloc[386]: knd=0, off=50151, siz=4, lab1=.L2828, lab2=, loff=0
!   reloc[387]: knd=0, off=50155, siz=4, lab1=.L2894, lab2=, loff=0
!   reloc[388]: knd=0, off=50160, siz=4, lab1=.L2829, lab2=, loff=0
!   reloc[389]: knd=0, off=50164, siz=4, lab1=.L2893, lab2=, loff=0
!   reloc[390]: knd=0, off=50247, siz=4, lab1=.L2834, lab2=, loff=0
!   reloc[391]: knd=0, off=50251, siz=4, lab1=.L2892, lab2=, loff=0
!   reloc[392]: knd=0, off=50256, siz=4, lab1=.L2840, lab2=, loff=0
!   reloc[393]: knd=0, off=50260, siz=4, lab1=.L2889, lab2=, loff=0
!   reloc[394]: knd=0, off=50265, siz=4, lab1=.L2841, lab2=, loff=0
!   reloc[395]: knd=0, off=50269, siz=4, lab1=.L2888, lab2=, loff=0
!   reloc[396]: knd=0, off=50384, siz=4, lab1=general_smooth_rgba_line, lab2=, loff=0
!   reloc[397]: knd=0, off=50388, siz=4, lab1=.L3630, lab2=, loff=0
!   reloc[398]: knd=0, off=50601, siz=4, lab1=.L2928, lab2=, loff=0
!   reloc[399]: knd=0, off=50605, siz=4, lab1=.L3618, lab2=, loff=0
!   reloc[400]: knd=0, off=50610, siz=4, lab1=.L2932, lab2=, loff=0
!   reloc[401]: knd=0, off=50614, siz=4, lab1=.L3189, lab2=, loff=0
!   reloc[402]: knd=0, off=50619, siz=4, lab1=.L2933, lab2=, loff=0
!   reloc[403]: knd=0, off=50623, siz=4, lab1=.L3188, lab2=, loff=0
!   reloc[404]: knd=0, off=50628, siz=4, lab1=.L2934, lab2=, loff=0
!   reloc[405]: knd=0, off=50632, siz=4, lab1=.L3187, lab2=, loff=0
!   reloc[406]: knd=0, off=51046, siz=4, lab1=.L3009, lab2=, loff=0
!   reloc[407]: knd=0, off=51050, siz=4, lab1=.L3186, lab2=, loff=0
!   reloc[408]: knd=0, off=51055, siz=4, lab1=.L3013, lab2=, loff=0
!   reloc[409]: knd=0, off=51059, siz=4, lab1=.L3098, lab2=, loff=0
!   reloc[410]: knd=0, off=51064, siz=4, lab1=.L3014, lab2=, loff=0
!   reloc[411]: knd=0, off=51068, siz=4, lab1=.L3097, lab2=, loff=0
!   reloc[412]: knd=0, off=51147, siz=4, lab1=.L3023, lab2=, loff=0
!   reloc[413]: knd=0, off=51151, siz=4, lab1=.L3096, lab2=, loff=0
!   reloc[414]: knd=0, off=51156, siz=4, lab1=.L3029, lab2=, loff=0
!   reloc[415]: knd=0, off=51160, siz=4, lab1=.L3093, lab2=, loff=0
!   reloc[416]: knd=0, off=51165, siz=4, lab1=.L3030, lab2=, loff=0
!   reloc[417]: knd=0, off=51169, siz=4, lab1=.L3092, lab2=, loff=0
!   reloc[418]: knd=0, off=51189, siz=4, lab1=.L3032, lab2=, loff=0
!   reloc[419]: knd=0, off=51193, siz=4, lab1=.L3065, lab2=, loff=0
!   reloc[420]: knd=0, off=51198, siz=4, lab1=.L3036, lab2=, loff=0
!   reloc[421]: knd=0, off=51202, siz=4, lab1=.L3064, lab2=, loff=0
!   reloc[422]: knd=0, off=51207, siz=4, lab1=.L3037, lab2=, loff=0
!   reloc[423]: knd=0, off=51211, siz=4, lab1=.L3063, lab2=, loff=0
!   reloc[424]: knd=0, off=51291, siz=4, lab1=.L3100, lab2=, loff=0
!   reloc[425]: knd=0, off=51295, siz=4, lab1=.L3185, lab2=, loff=0
!   reloc[426]: knd=0, off=51300, siz=4, lab1=.L3101, lab2=, loff=0
!   reloc[427]: knd=0, off=51304, siz=4, lab1=.L3184, lab2=, loff=0
!   reloc[428]: knd=0, off=51387, siz=4, lab1=.L3110, lab2=, loff=0
!   reloc[429]: knd=0, off=51391, siz=4, lab1=.L3183, lab2=, loff=0
!   reloc[430]: knd=0, off=51396, siz=4, lab1=.L3116, lab2=, loff=0
!   reloc[431]: knd=0, off=51400, siz=4, lab1=.L3180, lab2=, loff=0
!   reloc[432]: knd=0, off=51405, siz=4, lab1=.L3117, lab2=, loff=0
!   reloc[433]: knd=0, off=51409, siz=4, lab1=.L3179, lab2=, loff=0
!   reloc[434]: knd=0, off=51429, siz=4, lab1=.L3119, lab2=, loff=0
!   reloc[435]: knd=0, off=51433, siz=4, lab1=.L3152, lab2=, loff=0
!   reloc[436]: knd=0, off=51438, siz=4, lab1=.L3123, lab2=, loff=0
!   reloc[437]: knd=0, off=51442, siz=4, lab1=.L3151, lab2=, loff=0
!   reloc[438]: knd=0, off=51447, siz=4, lab1=.L3124, lab2=, loff=0
!   reloc[439]: knd=0, off=51451, siz=4, lab1=.L3150, lab2=, loff=0
!   reloc[440]: knd=0, off=51535, siz=4, lab1=.L3191, lab2=, loff=0
!   reloc[441]: knd=0, off=51539, siz=4, lab1=.L3617, lab2=, loff=0
!   reloc[442]: knd=0, off=51544, siz=4, lab1=.L3192, lab2=, loff=0
!   reloc[443]: knd=0, off=51548, siz=4, lab1=.L3616, lab2=, loff=0
!   reloc[444]: knd=0, off=51553, siz=4, lab1=.L3193, lab2=, loff=0
!   reloc[445]: knd=0, off=51557, siz=4, lab1=.L3615, lab2=, loff=0
!   reloc[446]: knd=0, off=51562, siz=4, lab1=.L3197, lab2=, loff=0
!   reloc[447]: knd=0, off=51566, siz=4, lab1=.L3377, lab2=, loff=0
!   reloc[448]: knd=0, off=51571, siz=4, lab1=.L3198, lab2=, loff=0
!   reloc[449]: knd=0, off=51575, siz=4, lab1=.L3376, lab2=, loff=0
!   reloc[450]: knd=0, off=51580, siz=4, lab1=.L3199, lab2=, loff=0
!   reloc[451]: knd=0, off=51584, siz=4, lab1=.L3375, lab2=, loff=0
!   reloc[452]: knd=0, off=51948, siz=4, lab1=.L3265, lab2=, loff=0
!   reloc[453]: knd=0, off=51952, siz=4, lab1=.L3374, lab2=, loff=0
!   reloc[454]: knd=0, off=51957, siz=4, lab1=.L3269, lab2=, loff=0
!   reloc[455]: knd=0, off=51961, siz=4, lab1=.L3320, lab2=, loff=0
!   reloc[456]: knd=0, off=51966, siz=4, lab1=.L3270, lab2=, loff=0
!   reloc[457]: knd=0, off=51970, siz=4, lab1=.L3319, lab2=, loff=0
!   reloc[458]: knd=0, off=52049, siz=4, lab1=.L3279, lab2=, loff=0
!   reloc[459]: knd=0, off=52053, siz=4, lab1=.L3318, lab2=, loff=0
!   reloc[460]: knd=0, off=52058, siz=4, lab1=.L3285, lab2=, loff=0
!   reloc[461]: knd=0, off=52062, siz=4, lab1=.L3315, lab2=, loff=0
!   reloc[462]: knd=0, off=52067, siz=4, lab1=.L3286, lab2=, loff=0
!   reloc[463]: knd=0, off=52071, siz=4, lab1=.L3314, lab2=, loff=0
!   reloc[464]: knd=0, off=52096, siz=4, lab1=.L3322, lab2=, loff=0
!   reloc[465]: knd=0, off=52100, siz=4, lab1=.L3373, lab2=, loff=0
!   reloc[466]: knd=0, off=52105, siz=4, lab1=.L3323, lab2=, loff=0
!   reloc[467]: knd=0, off=52109, siz=4, lab1=.L3372, lab2=, loff=0
!   reloc[468]: knd=0, off=52192, siz=4, lab1=.L3332, lab2=, loff=0
!   reloc[469]: knd=0, off=52196, siz=4, lab1=.L3371, lab2=, loff=0
!   reloc[470]: knd=0, off=52201, siz=4, lab1=.L3338, lab2=, loff=0
!   reloc[471]: knd=0, off=52205, siz=4, lab1=.L3368, lab2=, loff=0
!   reloc[472]: knd=0, off=52210, siz=4, lab1=.L3339, lab2=, loff=0
!   reloc[473]: knd=0, off=52214, siz=4, lab1=.L3367, lab2=, loff=0
!   reloc[474]: knd=0, off=52243, siz=4, lab1=.L3379, lab2=, loff=0
!   reloc[475]: knd=0, off=52247, siz=4, lab1=.L3614, lab2=, loff=0
!   reloc[476]: knd=0, off=52252, siz=4, lab1=.L3380, lab2=, loff=0
!   reloc[477]: knd=0, off=52256, siz=4, lab1=.L3613, lab2=, loff=0
!   reloc[478]: knd=0, off=52261, siz=4, lab1=.L3381, lab2=, loff=0
!   reloc[479]: knd=0, off=52265, siz=4, lab1=.L3612, lab2=, loff=0
!   reloc[480]: knd=0, off=52679, siz=4, lab1=.L3456, lab2=, loff=0
!   reloc[481]: knd=0, off=52683, siz=4, lab1=.L3611, lab2=, loff=0
!   reloc[482]: knd=0, off=52688, siz=4, lab1=.L3460, lab2=, loff=0
!   reloc[483]: knd=0, off=52692, siz=4, lab1=.L3534, lab2=, loff=0
!   reloc[484]: knd=0, off=52697, siz=4, lab1=.L3461, lab2=, loff=0
!   reloc[485]: knd=0, off=52701, siz=4, lab1=.L3533, lab2=, loff=0
!   reloc[486]: knd=0, off=52780, siz=4, lab1=.L3470, lab2=, loff=0
!   reloc[487]: knd=0, off=52784, siz=4, lab1=.L3532, lab2=, loff=0
!   reloc[488]: knd=0, off=52789, siz=4, lab1=.L3476, lab2=, loff=0
!   reloc[489]: knd=0, off=52793, siz=4, lab1=.L3529, lab2=, loff=0
!   reloc[490]: knd=0, off=52798, siz=4, lab1=.L3477, lab2=, loff=0
!   reloc[491]: knd=0, off=52802, siz=4, lab1=.L3528, lab2=, loff=0
!   reloc[492]: knd=0, off=52879, siz=4, lab1=.L3536, lab2=, loff=0
!   reloc[493]: knd=0, off=52883, siz=4, lab1=.L3610, lab2=, loff=0
!   reloc[494]: knd=0, off=52888, siz=4, lab1=.L3537, lab2=, loff=0
!   reloc[495]: knd=0, off=52892, siz=4, lab1=.L3609, lab2=, loff=0
!   reloc[496]: knd=0, off=52975, siz=4, lab1=.L3546, lab2=, loff=0
!   reloc[497]: knd=0, off=52979, siz=4, lab1=.L3608, lab2=, loff=0
!   reloc[498]: knd=0, off=52984, siz=4, lab1=.L3552, lab2=, loff=0
!   reloc[499]: knd=0, off=52988, siz=4, lab1=.L3605, lab2=, loff=0
!   reloc[500]: knd=0, off=52993, siz=4, lab1=.L3553, lab2=, loff=0
!   reloc[501]: knd=0, off=52997, siz=4, lab1=.L3604, lab2=, loff=0
!   reloc[502]: knd=0, off=53110, siz=4, lab1=general_flat_rgba_line, lab2=, loff=0
!   reloc[503]: knd=0, off=53114, siz=4, lab1=.L4285, lab2=, loff=0
!   reloc[504]: knd=0, off=53281, siz=4, lab1=.L3655, lab2=, loff=0
!   reloc[505]: knd=0, off=53285, siz=4, lab1=.L4273, lab2=, loff=0
!   reloc[506]: knd=0, off=53290, siz=4, lab1=.L3659, lab2=, loff=0
!   reloc[507]: knd=0, off=53294, siz=4, lab1=.L3892, lab2=, loff=0
!   reloc[508]: knd=0, off=53299, siz=4, lab1=.L3660, lab2=, loff=0
!   reloc[509]: knd=0, off=53303, siz=4, lab1=.L3891, lab2=, loff=0
!   reloc[510]: knd=0, off=53308, siz=4, lab1=.L3661, lab2=, loff=0
!   reloc[511]: knd=0, off=53312, siz=4, lab1=.L3890, lab2=, loff=0
!   reloc[512]: knd=0, off=53603, siz=4, lab1=.L3728, lab2=, loff=0
!   reloc[513]: knd=0, off=53607, siz=4, lab1=.L3889, lab2=, loff=0
!   reloc[514]: knd=0, off=53612, siz=4, lab1=.L3732, lab2=, loff=0
!   reloc[515]: knd=0, off=53616, siz=4, lab1=.L3809, lab2=, loff=0
!   reloc[516]: knd=0, off=53621, siz=4, lab1=.L3733, lab2=, loff=0
!   reloc[517]: knd=0, off=53625, siz=4, lab1=.L3808, lab2=, loff=0
!   reloc[518]: knd=0, off=53704, siz=4, lab1=.L3738, lab2=, loff=0
!   reloc[519]: knd=0, off=53708, siz=4, lab1=.L3807, lab2=, loff=0
!   reloc[520]: knd=0, off=53713, siz=4, lab1=.L3744, lab2=, loff=0
!   reloc[521]: knd=0, off=53717, siz=4, lab1=.L3804, lab2=, loff=0
!   reloc[522]: knd=0, off=53722, siz=4, lab1=.L3745, lab2=, loff=0
!   reloc[523]: knd=0, off=53726, siz=4, lab1=.L3803, lab2=, loff=0
!   reloc[524]: knd=0, off=53746, siz=4, lab1=.L3747, lab2=, loff=0
!   reloc[525]: knd=0, off=53750, siz=4, lab1=.L3780, lab2=, loff=0
!   reloc[526]: knd=0, off=53755, siz=4, lab1=.L3751, lab2=, loff=0
!   reloc[527]: knd=0, off=53759, siz=4, lab1=.L3779, lab2=, loff=0
!   reloc[528]: knd=0, off=53764, siz=4, lab1=.L3752, lab2=, loff=0
!   reloc[529]: knd=0, off=53768, siz=4, lab1=.L3778, lab2=, loff=0
!   reloc[530]: knd=0, off=53848, siz=4, lab1=.L3811, lab2=, loff=0
!   reloc[531]: knd=0, off=53852, siz=4, lab1=.L3888, lab2=, loff=0
!   reloc[532]: knd=0, off=53857, siz=4, lab1=.L3812, lab2=, loff=0
!   reloc[533]: knd=0, off=53861, siz=4, lab1=.L3887, lab2=, loff=0
!   reloc[534]: knd=0, off=53944, siz=4, lab1=.L3817, lab2=, loff=0
!   reloc[535]: knd=0, off=53948, siz=4, lab1=.L3886, lab2=, loff=0
!   reloc[536]: knd=0, off=53953, siz=4, lab1=.L3823, lab2=, loff=0
!   reloc[537]: knd=0, off=53957, siz=4, lab1=.L3883, lab2=, loff=0
!   reloc[538]: knd=0, off=53962, siz=4, lab1=.L3824, lab2=, loff=0
!   reloc[539]: knd=0, off=53966, siz=4, lab1=.L3882, lab2=, loff=0
!   reloc[540]: knd=0, off=53986, siz=4, lab1=.L3826, lab2=, loff=0
!   reloc[541]: knd=0, off=53990, siz=4, lab1=.L3859, lab2=, loff=0
!   reloc[542]: knd=0, off=53995, siz=4, lab1=.L3830, lab2=, loff=0
!   reloc[543]: knd=0, off=53999, siz=4, lab1=.L3858, lab2=, loff=0
!   reloc[544]: knd=0, off=54004, siz=4, lab1=.L3831, lab2=, loff=0
!   reloc[545]: knd=0, off=54008, siz=4, lab1=.L3857, lab2=, loff=0
!   reloc[546]: knd=0, off=54092, siz=4, lab1=.L3894, lab2=, loff=0
!   reloc[547]: knd=0, off=54096, siz=4, lab1=.L4272, lab2=, loff=0
!   reloc[548]: knd=0, off=54101, siz=4, lab1=.L3895, lab2=, loff=0
!   reloc[549]: knd=0, off=54105, siz=4, lab1=.L4271, lab2=, loff=0
!   reloc[550]: knd=0, off=54110, siz=4, lab1=.L3896, lab2=, loff=0
!   reloc[551]: knd=0, off=54114, siz=4, lab1=.L4270, lab2=, loff=0
!   reloc[552]: knd=0, off=54119, siz=4, lab1=.L3900, lab2=, loff=0
!   reloc[553]: knd=0, off=54123, siz=4, lab1=.L4056, lab2=, loff=0
!   reloc[554]: knd=0, off=54128, siz=4, lab1=.L3901, lab2=, loff=0
!   reloc[555]: knd=0, off=54132, siz=4, lab1=.L4055, lab2=, loff=0
!   reloc[556]: knd=0, off=54137, siz=4, lab1=.L3902, lab2=, loff=0
!   reloc[557]: knd=0, off=54141, siz=4, lab1=.L4054, lab2=, loff=0
!   reloc[558]: knd=0, off=54382, siz=4, lab1=.L3960, lab2=, loff=0
!   reloc[559]: knd=0, off=54386, siz=4, lab1=.L4053, lab2=, loff=0
!   reloc[560]: knd=0, off=54391, siz=4, lab1=.L3964, lab2=, loff=0
!   reloc[561]: knd=0, off=54395, siz=4, lab1=.L4007, lab2=, loff=0
!   reloc[562]: knd=0, off=54400, siz=4, lab1=.L3965, lab2=, loff=0
!   reloc[563]: knd=0, off=54404, siz=4, lab1=.L4006, lab2=, loff=0
!   reloc[564]: knd=0, off=54483, siz=4, lab1=.L3970, lab2=, loff=0
!   reloc[565]: knd=0, off=54487, siz=4, lab1=.L4005, lab2=, loff=0
!   reloc[566]: knd=0, off=54492, siz=4, lab1=.L3976, lab2=, loff=0
!   reloc[567]: knd=0, off=54496, siz=4, lab1=.L4002, lab2=, loff=0
!   reloc[568]: knd=0, off=54501, siz=4, lab1=.L3977, lab2=, loff=0
!   reloc[569]: knd=0, off=54505, siz=4, lab1=.L4001, lab2=, loff=0
!   reloc[570]: knd=0, off=54530, siz=4, lab1=.L4009, lab2=, loff=0
!   reloc[571]: knd=0, off=54534, siz=4, lab1=.L4052, lab2=, loff=0
!   reloc[572]: knd=0, off=54539, siz=4, lab1=.L4010, lab2=, loff=0
!   reloc[573]: knd=0, off=54543, siz=4, lab1=.L4051, lab2=, loff=0
!   reloc[574]: knd=0, off=54626, siz=4, lab1=.L4015, lab2=, loff=0
!   reloc[575]: knd=0, off=54630, siz=4, lab1=.L4050, lab2=, loff=0
!   reloc[576]: knd=0, off=54635, siz=4, lab1=.L4021, lab2=, loff=0
!   reloc[577]: knd=0, off=54639, siz=4, lab1=.L4047, lab2=, loff=0
!   reloc[578]: knd=0, off=54644, siz=4, lab1=.L4022, lab2=, loff=0
!   reloc[579]: knd=0, off=54648, siz=4, lab1=.L4046, lab2=, loff=0
!   reloc[580]: knd=0, off=54677, siz=4, lab1=.L4058, lab2=, loff=0
!   reloc[581]: knd=0, off=54681, siz=4, lab1=.L4269, lab2=, loff=0
!   reloc[582]: knd=0, off=54686, siz=4, lab1=.L4059, lab2=, loff=0
!   reloc[583]: knd=0, off=54690, siz=4, lab1=.L4268, lab2=, loff=0
!   reloc[584]: knd=0, off=54695, siz=4, lab1=.L4060, lab2=, loff=0
!   reloc[585]: knd=0, off=54699, siz=4, lab1=.L4267, lab2=, loff=0
!   reloc[586]: knd=0, off=54990, siz=4, lab1=.L4127, lab2=, loff=0
!   reloc[587]: knd=0, off=54994, siz=4, lab1=.L4266, lab2=, loff=0
!   reloc[588]: knd=0, off=54999, siz=4, lab1=.L4131, lab2=, loff=0
!   reloc[589]: knd=0, off=55003, siz=4, lab1=.L4197, lab2=, loff=0
!   reloc[590]: knd=0, off=55008, siz=4, lab1=.L4132, lab2=, loff=0
!   reloc[591]: knd=0, off=55012, siz=4, lab1=.L4196, lab2=, loff=0
!   reloc[592]: knd=0, off=55091, siz=4, lab1=.L4137, lab2=, loff=0
!   reloc[593]: knd=0, off=55095, siz=4, lab1=.L4195, lab2=, loff=0
!   reloc[594]: knd=0, off=55100, siz=4, lab1=.L4143, lab2=, loff=0
!   reloc[595]: knd=0, off=55104, siz=4, lab1=.L4192, lab2=, loff=0
!   reloc[596]: knd=0, off=55109, siz=4, lab1=.L4144, lab2=, loff=0
!   reloc[597]: knd=0, off=55113, siz=4, lab1=.L4191, lab2=, loff=0
!   reloc[598]: knd=0, off=55190, siz=4, lab1=.L4199, lab2=, loff=0
!   reloc[599]: knd=0, off=55194, siz=4, lab1=.L4265, lab2=, loff=0
!   reloc[600]: knd=0, off=55199, siz=4, lab1=.L4200, lab2=, loff=0
!   reloc[601]: knd=0, off=55203, siz=4, lab1=.L4264, lab2=, loff=0
!   reloc[602]: knd=0, off=55286, siz=4, lab1=.L4205, lab2=, loff=0
!   reloc[603]: knd=0, off=55290, siz=4, lab1=.L4263, lab2=, loff=0
!   reloc[604]: knd=0, off=55295, siz=4, lab1=.L4211, lab2=, loff=0
!   reloc[605]: knd=0, off=55299, siz=4, lab1=.L4260, lab2=, loff=0
!   reloc[606]: knd=0, off=55304, siz=4, lab1=.L4212, lab2=, loff=0
!   reloc[607]: knd=0, off=55308, siz=4, lab1=.L4259, lab2=, loff=0
!   reloc[608]: knd=0, off=55417, siz=4, lab1=flat_textured_line, lab2=, loff=0
!   reloc[609]: knd=0, off=55421, siz=4, lab1=.L4838, lab2=, loff=0
!   reloc[610]: knd=0, off=55633, siz=4, lab1=.L4313, lab2=, loff=0
!   reloc[611]: knd=0, off=55637, siz=4, lab1=.L4826, lab2=, loff=0
!   reloc[612]: knd=0, off=55642, siz=4, lab1=.L4317, lab2=, loff=0
!   reloc[613]: knd=0, off=55646, siz=4, lab1=.L4581, lab2=, loff=0
!   reloc[614]: knd=0, off=55651, siz=4, lab1=.L4318, lab2=, loff=0
!   reloc[615]: knd=0, off=55655, siz=4, lab1=.L4580, lab2=, loff=0
!   reloc[616]: knd=0, off=55660, siz=4, lab1=.L4319, lab2=, loff=0
!   reloc[617]: knd=0, off=55664, siz=4, lab1=.L4579, lab2=, loff=0
!   reloc[618]: knd=0, off=56108, siz=4, lab1=.L4391, lab2=, loff=0
!   reloc[619]: knd=0, off=56112, siz=4, lab1=.L4578, lab2=, loff=0
!   reloc[620]: knd=0, off=56117, siz=4, lab1=.L4395, lab2=, loff=0
!   reloc[621]: knd=0, off=56121, siz=4, lab1=.L4485, lab2=, loff=0
!   reloc[622]: knd=0, off=56126, siz=4, lab1=.L4396, lab2=, loff=0
!   reloc[623]: knd=0, off=56130, siz=4, lab1=.L4484, lab2=, loff=0
!   reloc[624]: knd=0, off=56209, siz=4, lab1=.L4401, lab2=, loff=0
!   reloc[625]: knd=0, off=56213, siz=4, lab1=.L4408, lab2=, loff=0
!   reloc[626]: knd=0, off=56239, siz=4, lab1=.L4409, lab2=, loff=0
!   reloc[627]: knd=0, off=56243, siz=4, lab1=.L4483, lab2=, loff=0
!   reloc[628]: knd=0, off=56248, siz=4, lab1=.L4415, lab2=, loff=0
!   reloc[629]: knd=0, off=56252, siz=4, lab1=.L4480, lab2=, loff=0
!   reloc[630]: knd=0, off=56257, siz=4, lab1=.L4416, lab2=, loff=0
!   reloc[631]: knd=0, off=56261, siz=4, lab1=.L4479, lab2=, loff=0
!   reloc[632]: knd=0, off=56281, siz=4, lab1=.L4418, lab2=, loff=0
!   reloc[633]: knd=0, off=56285, siz=4, lab1=.L4451, lab2=, loff=0
!   reloc[634]: knd=0, off=56290, siz=4, lab1=.L4422, lab2=, loff=0
!   reloc[635]: knd=0, off=56294, siz=4, lab1=.L4450, lab2=, loff=0
!   reloc[636]: knd=0, off=56299, siz=4, lab1=.L4423, lab2=, loff=0
!   reloc[637]: knd=0, off=56303, siz=4, lab1=.L4449, lab2=, loff=0
!   reloc[638]: knd=0, off=56383, siz=4, lab1=.L4487, lab2=, loff=0
!   reloc[639]: knd=0, off=56387, siz=4, lab1=.L4577, lab2=, loff=0
!   reloc[640]: knd=0, off=56392, siz=4, lab1=.L4488, lab2=, loff=0
!   reloc[641]: knd=0, off=56396, siz=4, lab1=.L4576, lab2=, loff=0
!   reloc[642]: knd=0, off=56479, siz=4, lab1=.L4493, lab2=, loff=0
!   reloc[643]: knd=0, off=56483, siz=4, lab1=.L4500, lab2=, loff=0
!   reloc[644]: knd=0, off=56509, siz=4, lab1=.L4501, lab2=, loff=0
!   reloc[645]: knd=0, off=56513, siz=4, lab1=.L4575, lab2=, loff=0
!   reloc[646]: knd=0, off=56518, siz=4, lab1=.L4507, lab2=, loff=0
!   reloc[647]: knd=0, off=56522, siz=4, lab1=.L4572, lab2=, loff=0
!   reloc[648]: knd=0, off=56527, siz=4, lab1=.L4508, lab2=, loff=0
!   reloc[649]: knd=0, off=56531, siz=4, lab1=.L4571, lab2=, loff=0
!   reloc[650]: knd=0, off=56551, siz=4, lab1=.L4510, lab2=, loff=0
!   reloc[651]: knd=0, off=56555, siz=4, lab1=.L4543, lab2=, loff=0
!   reloc[652]: knd=0, off=56560, siz=4, lab1=.L4514, lab2=, loff=0
!   reloc[653]: knd=0, off=56564, siz=4, lab1=.L4542, lab2=, loff=0
!   reloc[654]: knd=0, off=56569, siz=4, lab1=.L4515, lab2=, loff=0
!   reloc[655]: knd=0, off=56573, siz=4, lab1=.L4541, lab2=, loff=0
!   reloc[656]: knd=0, off=56657, siz=4, lab1=.L4583, lab2=, loff=0
!   reloc[657]: knd=0, off=56661, siz=4, lab1=.L4825, lab2=, loff=0
!   reloc[658]: knd=0, off=56666, siz=4, lab1=.L4584, lab2=, loff=0
!   reloc[659]: knd=0, off=56670, siz=4, lab1=.L4824, lab2=, loff=0
!   reloc[660]: knd=0, off=56675, siz=4, lab1=.L4585, lab2=, loff=0
!   reloc[661]: knd=0, off=56679, siz=4, lab1=.L4823, lab2=, loff=0
!   reloc[662]: knd=0, off=57123, siz=4, lab1=.L4657, lab2=, loff=0
!   reloc[663]: knd=0, off=57127, siz=4, lab1=.L4822, lab2=, loff=0
!   reloc[664]: knd=0, off=57132, siz=4, lab1=.L4661, lab2=, loff=0
!   reloc[665]: knd=0, off=57136, siz=4, lab1=.L4740, lab2=, loff=0
!   reloc[666]: knd=0, off=57141, siz=4, lab1=.L4662, lab2=, loff=0
!   reloc[667]: knd=0, off=57145, siz=4, lab1=.L4739, lab2=, loff=0
!   reloc[668]: knd=0, off=57224, siz=4, lab1=.L4667, lab2=, loff=0
!   reloc[669]: knd=0, off=57228, siz=4, lab1=.L4674, lab2=, loff=0
!   reloc[670]: knd=0, off=57254, siz=4, lab1=.L4675, lab2=, loff=0
!   reloc[671]: knd=0, off=57258, siz=4, lab1=.L4738, lab2=, loff=0
!   reloc[672]: knd=0, off=57263, siz=4, lab1=.L4681, lab2=, loff=0
!   reloc[673]: knd=0, off=57267, siz=4, lab1=.L4735, lab2=, loff=0
!   reloc[674]: knd=0, off=57272, siz=4, lab1=.L4682, lab2=, loff=0
!   reloc[675]: knd=0, off=57276, siz=4, lab1=.L4734, lab2=, loff=0
!   reloc[676]: knd=0, off=57353, siz=4, lab1=.L4742, lab2=, loff=0
!   reloc[677]: knd=0, off=57357, siz=4, lab1=.L4821, lab2=, loff=0
!   reloc[678]: knd=0, off=57362, siz=4, lab1=.L4743, lab2=, loff=0
!   reloc[679]: knd=0, off=57366, siz=4, lab1=.L4820, lab2=, loff=0
!   reloc[680]: knd=0, off=57449, siz=4, lab1=.L4748, lab2=, loff=0
!   reloc[681]: knd=0, off=57453, siz=4, lab1=.L4755, lab2=, loff=0
!   reloc[682]: knd=0, off=57479, siz=4, lab1=.L4756, lab2=, loff=0
!   reloc[683]: knd=0, off=57483, siz=4, lab1=.L4819, lab2=, loff=0
!   reloc[684]: knd=0, off=57488, siz=4, lab1=.L4762, lab2=, loff=0
!   reloc[685]: knd=0, off=57492, siz=4, lab1=.L4816, lab2=, loff=0
!   reloc[686]: knd=0, off=57497, siz=4, lab1=.L4763, lab2=, loff=0
!   reloc[687]: knd=0, off=57501, siz=4, lab1=.L4815, lab2=, loff=0
!   reloc[688]: knd=0, off=57609, siz=4, lab1=smooth_textured_line, lab2=, loff=0
!   reloc[689]: knd=0, off=57613, siz=4, lab1=.L5428, lab2=, loff=0
!   reloc[690]: knd=0, off=57871, siz=4, lab1=.L4855, lab2=, loff=0
!   reloc[691]: knd=0, off=57875, siz=4, lab1=.L5416, lab2=, loff=0
!   reloc[692]: knd=0, off=57880, siz=4, lab1=.L4859, lab2=, loff=0
!   reloc[693]: knd=0, off=57884, siz=4, lab1=.L5147, lab2=, loff=0
!   reloc[694]: knd=0, off=57889, siz=4, lab1=.L4860, lab2=, loff=0
!   reloc[695]: knd=0, off=57893, siz=4, lab1=.L5146, lab2=, loff=0
!   reloc[696]: knd=0, off=57898, siz=4, lab1=.L4861, lab2=, loff=0
!   reloc[697]: knd=0, off=57902, siz=4, lab1=.L5145, lab2=, loff=0
!   reloc[698]: knd=0, off=58469, siz=4, lab1=.L4941, lab2=, loff=0
!   reloc[699]: knd=0, off=58473, siz=4, lab1=.L5144, lab2=, loff=0
!   reloc[700]: knd=0, off=58478, siz=4, lab1=.L4945, lab2=, loff=0
!   reloc[701]: knd=0, off=58482, siz=4, lab1=.L5043, lab2=, loff=0
!   reloc[702]: knd=0, off=58487, siz=4, lab1=.L4946, lab2=, loff=0
!   reloc[703]: knd=0, off=58491, siz=4, lab1=.L5042, lab2=, loff=0
!   reloc[704]: knd=0, off=58570, siz=4, lab1=.L4955, lab2=, loff=0
!   reloc[705]: knd=0, off=58574, siz=4, lab1=.L4962, lab2=, loff=0
!   reloc[706]: knd=0, off=58600, siz=4, lab1=.L4963, lab2=, loff=0
!   reloc[707]: knd=0, off=58604, siz=4, lab1=.L5041, lab2=, loff=0
!   reloc[708]: knd=0, off=58609, siz=4, lab1=.L4969, lab2=, loff=0
!   reloc[709]: knd=0, off=58613, siz=4, lab1=.L5038, lab2=, loff=0
!   reloc[710]: knd=0, off=58618, siz=4, lab1=.L4970, lab2=, loff=0
!   reloc[711]: knd=0, off=58622, siz=4, lab1=.L5037, lab2=, loff=0
!   reloc[712]: knd=0, off=58642, siz=4, lab1=.L4972, lab2=, loff=0
!   reloc[713]: knd=0, off=58646, siz=4, lab1=.L5005, lab2=, loff=0
!   reloc[714]: knd=0, off=58651, siz=4, lab1=.L4976, lab2=, loff=0
!   reloc[715]: knd=0, off=58655, siz=4, lab1=.L5004, lab2=, loff=0
!   reloc[716]: knd=0, off=58660, siz=4, lab1=.L4977, lab2=, loff=0
!   reloc[717]: knd=0, off=58664, siz=4, lab1=.L5003, lab2=, loff=0
!   reloc[718]: knd=0, off=58744, siz=4, lab1=.L5045, lab2=, loff=0
!   reloc[719]: knd=0, off=58748, siz=4, lab1=.L5143, lab2=, loff=0
!   reloc[720]: knd=0, off=58753, siz=4, lab1=.L5046, lab2=, loff=0
!   reloc[721]: knd=0, off=58757, siz=4, lab1=.L5142, lab2=, loff=0
!   reloc[722]: knd=0, off=58840, siz=4, lab1=.L5055, lab2=, loff=0
!   reloc[723]: knd=0, off=58844, siz=4, lab1=.L5062, lab2=, loff=0
!   reloc[724]: knd=0, off=58870, siz=4, lab1=.L5063, lab2=, loff=0
!   reloc[725]: knd=0, off=58874, siz=4, lab1=.L5141, lab2=, loff=0
!   reloc[726]: knd=0, off=58879, siz=4, lab1=.L5069, lab2=, loff=0
!   reloc[727]: knd=0, off=58883, siz=4, lab1=.L5138, lab2=, loff=0
!   reloc[728]: knd=0, off=58888, siz=4, lab1=.L5070, lab2=, loff=0
!   reloc[729]: knd=0, off=58892, siz=4, lab1=.L5137, lab2=, loff=0
!   reloc[730]: knd=0, off=58912, siz=4, lab1=.L5072, lab2=, loff=0
!   reloc[731]: knd=0, off=58916, siz=4, lab1=.L5105, lab2=, loff=0
!   reloc[732]: knd=0, off=58921, siz=4, lab1=.L5076, lab2=, loff=0
!   reloc[733]: knd=0, off=58925, siz=4, lab1=.L5104, lab2=, loff=0
!   reloc[734]: knd=0, off=58930, siz=4, lab1=.L5077, lab2=, loff=0
!   reloc[735]: knd=0, off=58934, siz=4, lab1=.L5103, lab2=, loff=0
!   reloc[736]: knd=0, off=59018, siz=4, lab1=.L5149, lab2=, loff=0
!   reloc[737]: knd=0, off=59022, siz=4, lab1=.L5415, lab2=, loff=0
!   reloc[738]: knd=0, off=59027, siz=4, lab1=.L5150, lab2=, loff=0
!   reloc[739]: knd=0, off=59031, siz=4, lab1=.L5414, lab2=, loff=0
!   reloc[740]: knd=0, off=59036, siz=4, lab1=.L5151, lab2=, loff=0
!   reloc[741]: knd=0, off=59040, siz=4, lab1=.L5413, lab2=, loff=0
!   reloc[742]: knd=0, off=59607, siz=4, lab1=.L5231, lab2=, loff=0
!   reloc[743]: knd=0, off=59611, siz=4, lab1=.L5412, lab2=, loff=0
!   reloc[744]: knd=0, off=59616, siz=4, lab1=.L5235, lab2=, loff=0
!   reloc[745]: knd=0, off=59620, siz=4, lab1=.L5322, lab2=, loff=0
!   reloc[746]: knd=0, off=59625, siz=4, lab1=.L5236, lab2=, loff=0
!   reloc[747]: knd=0, off=59629, siz=4, lab1=.L5321, lab2=, loff=0
!   reloc[748]: knd=0, off=59708, siz=4, lab1=.L5245, lab2=, loff=0
!   reloc[749]: knd=0, off=59712, siz=4, lab1=.L5252, lab2=, loff=0
!   reloc[750]: knd=0, off=59738, siz=4, lab1=.L5253, lab2=, loff=0
!   reloc[751]: knd=0, off=59742, siz=4, lab1=.L5320, lab2=, loff=0
!   reloc[752]: knd=0, off=59747, siz=4, lab1=.L5259, lab2=, loff=0
!   reloc[753]: knd=0, off=59751, siz=4, lab1=.L5317, lab2=, loff=0
!   reloc[754]: knd=0, off=59756, siz=4, lab1=.L5260, lab2=, loff=0
!   reloc[755]: knd=0, off=59760, siz=4, lab1=.L5316, lab2=, loff=0
!   reloc[756]: knd=0, off=59837, siz=4, lab1=.L5324, lab2=, loff=0
!   reloc[757]: knd=0, off=59841, siz=4, lab1=.L5411, lab2=, loff=0
!   reloc[758]: knd=0, off=59846, siz=4, lab1=.L5325, lab2=, loff=0
!   reloc[759]: knd=0, off=59850, siz=4, lab1=.L5410, lab2=, loff=0
!   reloc[760]: knd=0, off=59933, siz=4, lab1=.L5334, lab2=, loff=0
!   reloc[761]: knd=0, off=59937, siz=4, lab1=.L5341, lab2=, loff=0
!   reloc[762]: knd=0, off=59963, siz=4, lab1=.L5342, lab2=, loff=0
!   reloc[763]: knd=0, off=59967, siz=4, lab1=.L5409, lab2=, loff=0
!   reloc[764]: knd=0, off=59972, siz=4, lab1=.L5348, lab2=, loff=0
!   reloc[765]: knd=0, off=59976, siz=4, lab1=.L5406, lab2=, loff=0
!   reloc[766]: knd=0, off=59981, siz=4, lab1=.L5349, lab2=, loff=0
!   reloc[767]: knd=0, off=59985, siz=4, lab1=.L5405, lab2=, loff=0
!   reloc[768]: knd=0, off=60082, siz=4, lab1=null_line, lab2=, loff=0
!   reloc[769]: knd=0, off=60086, siz=4, lab1=.L5435, lab2=, loff=0
!   reloc[770]: knd=0, off=60187, siz=4, lab1=gl_set_line_function, lab2=, loff=0
!   reloc[771]: knd=0, off=60191, siz=4, lab1=.L5627, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0xec,0x10,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "lines.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  lines.c -W0,-xp\\$XAa59JCRsd3LG3K.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCRsd3LG3K.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_LineWidth\0"
	.byte 0x01,0x02,0x01,0x65
	.uaword gl_LineWidth
	.uaword .L43
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x44
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x64,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x8a
	.ascii "width\0"
	.byte 0x01,0x64,0x03,0x91,0xc8,0x00,0x00,0x04
	.ascii "int\0"
	.byte 0x05,0x04,0x05,0x00,0x00,0x01,0x44
	.ascii "GLint\0"
	.byte 0x03,0x06
	.ascii "HashTable\0"
	.byte 0x01,0x07,0x00,0x00,0x01,0x57,0x04
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x05,0x00,0x00,0x01,0x68
	.ascii "GLuint\0"
	.byte 0x03,0x04
	.ascii "float\0"
	.byte 0x04,0x04,0x05,0x00,0x00,0x01,0x81
	.ascii "GLfloat\0"
	.byte 0x03,0x04
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x01,0x4b,0x10
	.byte 0x00,0x00,0x01,0xb1,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x0a,0x04,0x03,0x00,0x00
	.byte 0x31,0x4d,0x0b
	.ascii "GL_FALSE\0"
	.byte 0x00,0x0b
	.ascii "GL_TRUE\0"
	.byte 0x01,0x0b
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x0b
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x0b
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x0b
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x0b
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x0b
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x0b
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x0b
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x0b
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x0b
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x0b
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x0b
	.ascii "GL_LINES\0"
	.byte 0x01,0x0b
	.ascii "GL_POINTS\0"
	.byte 0x00,0x0b
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x0b
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x0b
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x0b
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x0b
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x0b
	.ascii "GL_QUADS\0"
	.byte 0x07,0x0b
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x0b
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x0b
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x0b
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x0b
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x0b
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x0b
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x0b
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x0b
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x0b
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x0b
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x0b
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x0b
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x0b
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x0b
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x0b
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x0b
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x0b
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x0b
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x0b
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x0b
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x0b
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x0b
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x0b
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x0b
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x0b
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x0b
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x0b
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x0b
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x0b
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x0b
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x0b
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x0b
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x0b
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x0b
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x0b
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x0b
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x0b
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x0b
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x0b
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x0b
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x0b
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x0b
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x0b
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x0b
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x0b
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x0b
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x0b
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x0b
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x0b
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x0b
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x0b
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x0b
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x0b
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x0b
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x0b
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x0b
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x0b
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x0b
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x0b
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x0b
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x0b
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x0b
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x0b
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x0b
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x0b
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x0b
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x0b
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x0b
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x0b
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x0b
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x0b
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x0b
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x0b
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x0b
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x0b
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x0b
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x0b
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x0b
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x0b
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x0b
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x0b
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x0b
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x0b
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x0b
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x0b
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x0b
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x0b
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x0b
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x0b
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x0b
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x0b
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x0b
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x0b
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x0b
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x0b
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x0b
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x0b
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x0b
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x0b
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x0b
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x0b
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x0b
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x0b
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x0b
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x0b
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x0b
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x0b
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x0b
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x0b
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x0b
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x0b
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x0b
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x0b
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x0b
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x0b
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x0b
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x0b
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x0b
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x0b
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x0b
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x0b
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x0b
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x0b
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x0b
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x0b
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x0b
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x0b
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x0b
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x0b
	.ascii "GL_ZERO\0"
	.byte 0x00,0x0b
	.ascii "GL_ONE\0"
	.byte 0x01,0x0b
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x0b
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x0b
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x0b
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x0b
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x0b
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x0b
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x0b
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x0b
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x0b
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x0b
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x0b
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x0b
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x0b
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x0b
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x0b
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x0b
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x0b
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x0b
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x0b
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x0b
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x0b
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x0b
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x0b
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x0b
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x0b
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x0b
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x0b
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x0b
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x0b
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x0b
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x0b
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x0b
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x0b
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x0b
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x0b
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x0b
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x0b
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x0b
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x0b
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x0b
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x0b
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x0b
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0b
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0b
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x0b
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x0b
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x0b
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x0b
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x0b
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x0b
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x0b
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x0b
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x0b
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x0b
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x0b
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x0b
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x0b
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x0b
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x0b
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x0b
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x0b
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x0b
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x0b
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x0b
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x0b
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x0b
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x0b
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x0b
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x0b
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x0b
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x0b
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x0b
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x0b
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x0b
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x0b
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x0b
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x0b
	.ascii "GL_NONE\0"
	.byte 0x00,0x0b
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x0b
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x0b
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x0b
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x0b
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x0b
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x0b
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x0b
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x0b
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x0b
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x0b
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x0b
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x0b
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x0b
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x0b
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x0b
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x0b
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x0b
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x0b
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x0b
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x0b
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x0b
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x0b
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x0b
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x0b
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x0b
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x0b
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x0b
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x0b
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x0b
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x0b
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x0b
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x0b
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x0b
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x0b
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x0b
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x0b
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x0b
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x0b
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x0b
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x0b
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x0b
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x0b
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x0b
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x0b
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x0b
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x0b
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x0b
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x0b
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x0b
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x0b
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x0b
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x0b
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x0b
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x0b
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x0b
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x0b
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x0b
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x0b
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x0b
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x0b
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x0b
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x0b
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x0b
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x0b
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x0b
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x0b
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x0b
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x0b
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x0b
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x0b
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x0b
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x0b
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x0b
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x0b
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x0b
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x0b
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x0b
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x0b
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x0b
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x0b
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x0b
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x0b
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x0b
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x0b
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x0b
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x0b
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x0b
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x0b
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x0b
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x0b
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x0b
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x0b
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x0b
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x0b
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x0b
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x0b
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x0b
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x0b
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x0b
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x0b
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x0b
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x0b
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x0b
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x0b
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x0b
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x0b
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x0b
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x0b
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x0b
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x0b
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x0b
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x0b
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x0b
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x0b
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x0b
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x0b
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x0b
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x0b
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x0b
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x0b
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x0b
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x0b
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x0b
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x0b
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x0b
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x0b
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x0b
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x0b
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x0b
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x0b
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x0b
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x0b
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x0b
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x0b
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x0b
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x0b
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x0b
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x0b
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x0b
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x0b
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x0b
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x0b
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x0b
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x0b
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x0b
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x0b
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x0b
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x0b
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x0b
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x0b
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x0b
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x0b
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x0b
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x0b
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x0b
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x0b
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x0b
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x0b
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x0b
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x0b
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x0b
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x0b
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x0b
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x0b
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x0b
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x0b
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x0b
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x0b
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x0b
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x0b
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x0b
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x0b
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x0b
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x0b
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x0b
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x0b
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x0b
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x0b
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x0b
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x0b
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x0b
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x0b
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x0b
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x0b
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x0b
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x0b
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x0b
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x0b
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x0b
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x0b
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x0b
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x0b
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x0b
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x0b
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x0b
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x0b
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x0b
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x0b
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x0b
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x0b
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x0b
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x0b
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x0b
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x0b
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x0b
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x0b
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x0b
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x0b
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x0b
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x0b
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x0b
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x0b
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x0b
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x0b
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x0b
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x0b
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x0b
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x0b
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x0b
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x0b
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x0b
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x0b
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x0b
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x0b
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x0b
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x0b
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x0b
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x0b
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x0b
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x0b
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x0b
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x0b
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x0b
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x0b
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x0b
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x0b
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x0b
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x0b
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x0b
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x0b
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x0b
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x0b
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x0b
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x0b
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x0b
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x0b
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x0b
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x0b
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x0b
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x0b
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x0b
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x0b
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x0b
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x0b
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x05,0x00,0x00,0x01
	.byte 0xb1
	.ascii "GLenum\0"
	.byte 0x03,0x04
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x05,0x00,0x00,0x31,0x5a
	.ascii "GLubyte\0"
	.byte 0x03,0x07,0x00,0x00,0x31,0x6b,0x04
	.ascii "void\0"
	.byte 0x05,0x00,0x07,0x00,0x00,0x31,0x7e,0x0c
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x02,0x00,0x00,0x32,0x94,0x0d
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "Border\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x08,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x0c,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x10,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x14,0x0d
	.ascii "Width2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x18,0x0d
	.ascii "Height2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x1c,0x0d
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x20,0x0d
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x24,0x0d
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x28,0x0d
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x2c,0x0d
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x30,0x0d
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0x79,0x02,0x23,0x34,0x0d
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x38,0x00
	.byte 0x07,0x00,0x00,0x31,0x8b,0x08,0x00,0x00
	.byte 0x32,0x94,0x2c,0x00,0x00,0x32,0xaa,0x09
	.byte 0x00,0x00,0x01,0x98,0x0a,0x00,0x0e,0x00
	.byte 0x00,0x31,0x6b,0x04,0x00,0x00,0x00,0x32
	.byte 0xbd,0x0f,0x00,0x00,0x01,0x98,0x03,0xff
	.byte 0x00,0x05,0x00,0x00,0x31,0x5a
	.ascii "GLboolean\0"
	.byte 0x03,0x10
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x02,0x00,0x00,0x34,0x5c,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "Name\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x04,0x0d
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x08,0x0d
	.ascii "Priority\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x0c,0x0d
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x01,0xa0,0x02,0x23,0x10,0x0d
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x20,0x0d
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x24,0x0d
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x28,0x0d
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x2c,0x0d
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x30,0x0d
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x34,0x0d
	.ascii "Image\0"
	.byte 0x00,0x00,0x32,0x99,0x02,0x23,0x38,0x0d
	.ascii "Palette\0"
	.byte 0x00,0x00,0x32,0xaa,0x02,0x23,0x64,0x0d
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xe4,0x08
	.byte 0x0d
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x4d,0x03,0x23,0xe8,0x08
	.byte 0x0d
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x4d,0x03,0x23,0xec,0x08
	.byte 0x0d
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xf0,0x08
	.byte 0x0d
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x86,0x03,0x23,0xf4,0x08
	.byte 0x0d
	.ascii "Complete\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xf8,0x08
	.byte 0x0d
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x34,0xd2,0x03,0x23,0xfc,0x08
	.byte 0x0d
	.ascii "Next\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0x80,0x09
	.byte 0x00,0x11,0x00,0x00,0x32,0xcd,0x07,0x00
	.byte 0x00,0x34,0x5c,0x11,0x00,0x00,0x01,0x81
	.byte 0x07,0x00,0x00,0x34,0x66,0x11,0x00,0x00
	.byte 0x01,0x81,0x07,0x00,0x00,0x34,0x70,0x11
	.byte 0x00,0x00,0x01,0x81,0x07,0x00,0x00,0x34
	.byte 0x7a,0x11,0x00,0x00,0x01,0x81,0x07,0x00
	.byte 0x00,0x34,0x84,0x07,0x00,0x00,0x31,0x5a
	.byte 0x12,0x01,0x01,0x00,0x00,0x34,0xcd,0x13
	.byte 0x00,0x00,0x34,0x61,0x13,0x00,0x00,0x01
	.byte 0x68,0x13,0x00,0x00,0x34,0x6b,0x13,0x00
	.byte 0x00,0x34,0x75,0x13,0x00,0x00,0x34,0x7f
	.byte 0x13,0x00,0x00,0x34,0x89,0x13,0x00,0x00
	.byte 0x34,0x8e,0x13,0x00,0x00,0x34,0x8e,0x13
	.byte 0x00,0x00,0x34,0x8e,0x13,0x00,0x00,0x34
	.byte 0x8e,0x00,0x07,0x00,0x00,0x34,0x93,0x05
	.byte 0x00,0x00,0x34,0xcd
	.ascii "TextureSampleFunc\0"
	.byte 0x02,0x07,0x00,0x00,0x32,0xcd,0x0c
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x02,0x00,0x00,0x35,0x8b,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x01,0x63,0x02,0x23,0x04,0x0d
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x01,0x63,0x02,0x23,0x08,0x0d
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x34,0xea,0x02,0x23,0x0c,0x0d
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x34,0xea,0x02,0x23,0x10,0x0d
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x34,0xea,0x02,0x23,0x14,0x0d
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x34,0xea,0x02,0x23,0x18,0x00
	.byte 0x07,0x00,0x00,0x34,0xef,0x10
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x02,0x00,0x00,0x3c,0x5d,0x0d
	.ascii "Shared\0"
	.byte 0x00,0x00,0x35,0x8b,0x02,0x23,0x00,0x0d
	.ascii "API\0"
	.byte 0x00,0x00,0x55,0x48,0x02,0x23,0x04,0x0d
	.ascii "Save\0"
	.byte 0x00,0x00,0x55,0x48,0x03,0x23,0xe0,0x05
	.byte 0x0d
	.ascii "Exec\0"
	.byte 0x00,0x00,0x55,0x48,0x03,0x23,0xbc,0x0b
	.byte 0x0d
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xa3,0x03,0x23,0x98,0x11
	.byte 0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x66,0xd7,0x03,0x23,0x9c,0x11
	.byte 0x0d
	.ascii "Driver\0"
	.byte 0x00,0x00,0x6f,0xe6,0x03,0x23,0xa0,0x11
	.byte 0x0d
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x31,0x86,0x03,0x23,0xf4,0x12
	.byte 0x0d
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x31,0x86,0x03,0x23,0xf8,0x12
	.byte 0x0d
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xfc,0x12
	.byte 0x0d
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0x80,0x13
	.byte 0x0d
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x74,0x4e,0x03,0x23,0x84,0x13
	.byte 0x0d
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x74,0x5f,0x03,0x23,0xc4,0x13
	.byte 0x0d
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0x84,0x14
	.byte 0x0d
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x74,0x81,0x03,0x23,0x88,0x14
	.byte 0x0d
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0x88,0x24
	.byte 0x0d
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0x8c,0x24
	.byte 0x0d
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x74,0x93,0x03,0x23,0x90,0x24
	.byte 0x0d
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xd0,0x24
	.byte 0x0d
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x74,0xb5,0x03,0x23,0xd4,0x24
	.byte 0x0d
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x74,0xd8,0x03,0x23,0xd4,0x34
	.byte 0x0d
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xd4,0x36
	.byte 0x0d
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xd8,0x36
	.byte 0x0d
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x74,0xea,0x03,0x23,0xdc,0x36
	.byte 0x0d
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0x9c,0x37
	.byte 0x0d
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x75,0x0c,0x03,0x23,0xa0,0x37
	.byte 0x0d
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xa0,0x3c
	.byte 0x0d
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xa4,0x3c
	.byte 0x0d
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xa5,0x3c
	.byte 0x0d
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xa8,0x3c
	.byte 0x0d
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x75,0x72,0x03,0x23,0xac,0x3c
	.byte 0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x75,0x94,0x03,0x23,0xec,0x3c
	.byte 0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x75,0xe1,0x03,0x23,0xfc,0x3c
	.byte 0x0d
	.ascii "Current\0"
	.byte 0x00,0x00,0x77,0xf6,0x03,0x23,0xd4,0x3d
	.byte 0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x78,0xe0,0x03,0x23,0xb4,0x3e
	.byte 0x0d
	.ascii "Eval\0"
	.byte 0x00,0x00,0x79,0x33,0x03,0x23,0xc0,0x3e
	.byte 0x0d
	.ascii "Fog\0"
	.byte 0x00,0x00,0x7b,0xa9,0x03,0x23,0xf8,0x3e
	.byte 0x0d
	.ascii "Hint\0"
	.byte 0x00,0x00,0x7c,0x22,0x03,0x23,0xa0,0x3f
	.byte 0x0d
	.ascii "Light\0"
	.byte 0x00,0x00,0x81,0x2d,0x03,0x23,0xb4,0x3f
	.byte 0x0d
	.ascii "Line\0"
	.byte 0x00,0x00,0x82,0x5d,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0d
	.ascii "List\0"
	.byte 0x00,0x00,0x82,0xd6,0x04,0x23,0x94,0xdc
	.byte 0x02,0x0d
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x83,0xbc,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0d
	.ascii "Point\0"
	.byte 0x00,0x00,0x86,0x8c,0x04,0x23,0x80,0xad
	.byte 0x03,0x0d
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x87,0x05,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0d
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x88,0x38,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0d
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x88,0x57,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0d
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x88,0xb2,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0d
	.ascii "Texture\0"
	.byte 0x00,0x00,0x8a,0x0c,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0d
	.ascii "Transform\0"
	.byte 0x00,0x00,0x8c,0x6e,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0d
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x8c,0xe8,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0d
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0d
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x8d,0x8f,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0d
	.ascii "Array\0"
	.byte 0x00,0x00,0x8d,0xa5,0x04,0x23,0xac,0xba
	.byte 0x03,0x0d
	.ascii "Pack\0"
	.byte 0x00,0x00,0x90,0x50,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0d
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x90,0x50,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0d
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x91,0xd2,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0d
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x93,0x5c,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0d
	.ascii "Select\0"
	.byte 0x00,0x00,0x93,0xd1,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0d
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0d
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0d
	.ascii "NewState\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0d
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0d
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0d
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0d
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0d
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0d
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0d
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0d
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x01,0x8a,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0d
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x01,0x8a,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0d
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x01,0x8a,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0d
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0d
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0d
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0d
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0d
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x21,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0d
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x54,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0d
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x8a,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0d
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xc9,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0d
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xff,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0d
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0d
	.ascii "PB\0"
	.byte 0x00,0x00,0x9a,0x2a,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0d
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0d
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x07,0x00,0x00,0x35,0x90,0x12
	.byte 0x01,0x01,0x00,0x00,0x3c,0x79,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0x81,0x00,0x07,0x00
	.byte 0x00,0x3c,0x62,0x12,0x01,0x01,0x00,0x00
	.byte 0x3c,0x95,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0x81,0x00,0x07,0x00,0x00,0x3c,0x7e,0x11
	.byte 0x00,0x00,0x01,0x68,0x07,0x00,0x00,0x3c
	.byte 0x9a,0x14,0x01,0x00,0x00,0x31,0x5a,0x01
	.byte 0x00,0x00,0x3c,0xc4,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x3c,0x9f,0x13,0x00,0x00,0x34,0x8e
	.byte 0x00,0x07,0x00,0x00,0x3c,0xa4,0x12,0x01
	.byte 0x01,0x00,0x00,0x3c,0xdb,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x44,0x00
	.byte 0x07,0x00,0x00,0x3c,0xc9,0x12,0x01,0x01
	.byte 0x00,0x00,0x3c,0xf2,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x00,0x07
	.byte 0x00,0x00,0x3c,0xe0,0x12,0x01,0x01,0x00
	.byte 0x00,0x3d,0x0e,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0x68,0x00,0x07,0x00,0x00,0x3c,0xf7
	.byte 0x05,0x00,0x00,0x31,0x7e
	.ascii "GLvoid\0"
	.byte 0x03,0x07,0x00,0x00,0x3d,0x13,0x0c
	.ascii "gl_image\0"
	.byte 0x24,0x02,0x00,0x00,0x3d,0xc2,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x08,0x0d
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x0c,0x0d
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x10,0x0d
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x14,0x0d
	.ascii "Data\0"
	.byte 0x00,0x00,0x3d,0x20,0x02,0x23,0x18,0x0d
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x1c,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x20,0x00
	.byte 0x11,0x00,0x00,0x3d,0x25,0x07,0x00,0x00
	.byte 0x3d,0xc2,0x12,0x01,0x01,0x00,0x00,0x3d
	.byte 0xfc,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x3d
	.byte 0xc7,0x00,0x07,0x00,0x00,0x3d,0xcc,0x12
	.byte 0x01,0x01,0x00,0x00,0x3e,0x22,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x00
	.byte 0x07,0x00,0x00,0x3e,0x01,0x12,0x01,0x01
	.byte 0x00,0x00,0x3e,0x39,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x00,0x07
	.byte 0x00,0x00,0x3e,0x27,0x12,0x01,0x01,0x00
	.byte 0x00,0x3e,0x55,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x00,0x07,0x00,0x00,0x3e,0x3e
	.byte 0x12,0x01,0x01,0x00,0x00,0x3e,0x6c,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x00,0x07,0x00,0x00,0x3e,0x5a,0x11
	.byte 0x00,0x00,0x31,0x7e,0x07,0x00,0x00,0x3e
	.byte 0x71,0x12,0x01,0x01,0x00,0x00,0x3e,0x97
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x3e,0x76,0x00,0x07,0x00,0x00
	.byte 0x3e,0x7b,0x12,0x01,0x01,0x00,0x00,0x3e
	.byte 0xae,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x00,0x07,0x00,0x00,0x3e
	.byte 0x9c,0x12,0x01,0x01,0x00,0x00,0x3e,0xd4
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x00,0x07,0x00,0x00,0x3e,0xb3,0x12
	.byte 0x01,0x01,0x00,0x00,0x3e,0xfa,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x00
	.byte 0x07,0x00,0x00,0x3e,0xd9,0x04
	.ascii "double\0"
	.byte 0x04,0x08,0x12,0x01,0x01,0x00,0x00,0x3f
	.byte 0x1b,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x3e,0xff,0x00,0x07,0x00,0x00,0x3f
	.byte 0x09,0x12,0x01,0x01,0x00,0x00,0x3f,0x32
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x00,0x07,0x00,0x00,0x3f,0x20
	.byte 0x12,0x01,0x01,0x00,0x00,0x3f,0x49,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x00,0x07,0x00,0x00,0x3f,0x37,0x11
	.byte 0x00,0x00,0x01,0x81,0x07,0x00,0x00,0x3f
	.byte 0x4e,0x12,0x01,0x01,0x00,0x00,0x3f,0x6f
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x3f,0x53,0x00
	.byte 0x07,0x00,0x00,0x3f,0x58,0x12,0x01,0x01
	.byte 0x00,0x00,0x3f,0x90,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x00,0x07,0x00,0x00,0x3f,0x74,0x11,0x00
	.byte 0x00,0x01,0x81,0x07
	.byte 0x00,0x00,0x3f,0x95,0x12,0x01,0x01,0x00
	.byte 0x00,0x3f,0xb1,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x3f,0x9a,0x00,0x07,0x00
	.byte 0x00,0x3f,0x9f,0x12,0x01,0x01,0x00,0x00
	.byte 0x3f,0xd7,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x00,0x07,0x00,0x00,0x3f
	.byte 0xb6,0x11,0x00,0x00,0x01,0x81,0x07,0x00
	.byte 0x00,0x3f,0xdc,0x12,0x01,0x01,0x00,0x00
	.byte 0x3f,0xf8,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x3f,0xe1,0x00,0x07,0x00,0x00
	.byte 0x3f,0xe6,0x12,0x01,0x01,0x00,0x00,0x40
	.byte 0x1e,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x31,0x5a,0x13,0x00,0x00,0x31,0x5a
	.byte 0x13,0x00,0x00,0x31,0x5a,0x13,0x00,0x00
	.byte 0x31,0x5a,0x00,0x07,0x00,0x00,0x3f,0xfd
	.byte 0x11,0x00,0x00,0x31,0x5a,0x07,0x00,0x00
	.byte 0x40,0x23,0x12,0x01,0x01,0x00,0x00,0x40
	.byte 0x3f,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x40,0x28,0x00,0x07,0x00,0x00,0x40
	.byte 0x2d,0x12,0x01,0x01,0x00,0x00,0x40,0x65
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x31,0x5a,0x13,0x00,0x00,0x31,0x5a,0x13
	.byte 0x00,0x00,0x31,0x5a,0x13,0x00,0x00,0x31
	.byte 0x5a,0x00,0x07,0x00,0x00,0x40,0x44,0x12
	.byte 0x01,0x01,0x00,0x00,0x40,0x81,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x40,0x6a,0x11,0x00,0x00,0x31,0x7e
	.byte 0x07,0x00,0x00,0x40,0x86,0x12,0x01,0x01
	.byte 0x00,0x00,0x40,0xb1,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x40,0x8b,0x00,0x07,0x00
	.byte 0x00,0x40,0x90,0x07,0x00,0x00,0x3d,0x25
	.byte 0x12,0x01,0x01,0x00,0x00,0x40,0xd7,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x40,0xb6,0x00,0x07,0x00,0x00,0x40
	.byte 0xbb,0x12,0x01,0x01,0x00,0x00,0x40,0xf8
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x40,0xb6,0x00,0x07,0x00,0x00
	.byte 0x40,0xdc,0x12,0x01,0x01,0x00,0x00,0x41
	.byte 0x23,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0xb1,0x00
	.byte 0x07,0x00,0x00,0x40,0xfd,0x12,0x01,0x01
	.byte 0x00,0x00,0x41,0x58,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x00,0x07,0x00,0x00
	.byte 0x41,0x28,0x12,0x01,0x01,0x00,0x00,0x41
	.byte 0x92,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x00,0x07
	.byte 0x00,0x00,0x41,0x5d,0x12,0x01,0x01,0x00
	.byte 0x00,0x41,0xc2,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x00,0x07
	.byte 0x00,0x00,0x41,0x97,0x12,0x01,0x01,0x00
	.byte 0x00,0x41,0xfc,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x00,0x07,0x00,0x00,0x41,0xc7,0x12,0x01
	.byte 0x01,0x00,0x00,0x42,0x3b,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x00
	.byte 0x07,0x00,0x00,0x42,0x01,0x12,0x01,0x01
	.byte 0x00,0x00,0x42,0x52,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x00,0x07
	.byte 0x00,0x00,0x42,0x40,0x12,0x01,0x01,0x00
	.byte 0x00,0x42,0x6e,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x68,0x13,0x00,0x00
	.byte 0x01,0x44,0x00,0x07,0x00,0x00,0x42,0x57
	.byte 0x11,0x00,0x00,0x01,0x68,0x07,0x00,0x00
	.byte 0x42,0x73,0x12,0x01,0x01,0x00,0x00,0x42
	.byte 0x94,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x42,0x78
	.byte 0x00,0x07,0x00,0x00,0x42,0x7d,0x12,0x01
	.byte 0x01,0x00,0x00,0x42,0xab,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x00
	.byte 0x07,0x00,0x00,0x42,0x99,0x12,0x01,0x01
	.byte 0x00,0x00,0x42,0xc2,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x31,0x5a,0x00,0x07
	.byte 0x00,0x00,0x42,0xb0,0x12,0x01,0x01,0x00
	.byte 0x00,0x42,0xde,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x3e,0xff,0x13,0x00,0x00
	.byte 0x3e,0xff,0x00,0x07,0x00,0x00,0x42,0xc7
	.byte 0x12,0x01,0x01,0x00,0x00,0x42,0xf5,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x00,0x07,0x00,0x00,0x42,0xe3,0x12
	.byte 0x01,0x01,0x00,0x00,0x43,0x0c,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x00,0x07,0x00,0x00,0x42,0xfa,0x12,0x01
	.byte 0x01,0x00,0x00,0x43,0x2d,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x00,0x07,0x00,0x00,0x43,0x11,0x12
	.byte 0x01,0x01,0x00,0x00,0x43,0x44,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x00,0x07,0x00,0x00,0x43,0x32,0x11,0x00
	.byte 0x00,0x31,0x7e,0x07,0x00,0x00,0x43,0x49
	.byte 0x12,0x01,0x01,0x00,0x00,0x43,0x74,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x43,0x4e
	.byte 0x00,0x07,0x00,0x00,0x43,0x53,0x11,0x00
	.byte 0x00,0x31,0x7e,0x07,0x00,0x00,0x43,0x79
	.byte 0x12,0x01,0x01,0x00,0x00,0x43,0xa9,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x43,0x7e,0x00,0x07,0x00
	.byte 0x00,0x43,0x83,0x12,0x01,0x01,0x00,0x00
	.byte 0x43,0xc0,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x31,0x5a,0x00,0x07,0x00,0x00
	.byte 0x43,0xae,0x11,0x00,0x00,0x31,0x5a,0x07
	.byte 0x00,0x00,0x43,0xc5,0x12,0x01,0x01,0x00
	.byte 0x00,0x43,0xe6,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x43,0xca,0x00,0x07,0x00,0x00,0x43,0xcf
	.byte 0x12,0x01,0x01,0x00,0x00,0x43,0xfd,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x00,0x07,0x00,0x00,0x43,0xeb,0x12
	.byte 0x01,0x01,0x00,0x00,0x44,0x14,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x00,0x07,0x00,0x00,0x44,0x02,0x12,0x01
	.byte 0x01,0x00,0x00,0x44,0x26,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x00,0x07,0x00,0x00,0x44,0x19
	.byte 0x12,0x01,0x01,0x00,0x00,0x44,0x38,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x00,0x07,0x00,0x00
	.byte 0x44,0x2b,0x12,0x01,0x01,0x00,0x00,0x44
	.byte 0x4f,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x81,0x00,0x07,0x00,0x00,0x44
	.byte 0x3d,0x12,0x01,0x01,0x00,0x00,0x44,0x6b
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x00
	.byte 0x07,0x00,0x00,0x44,0x54,0x12,0x01,0x01
	.byte 0x00,0x00,0x44,0x8c,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x00,0x07,0x00,0x00,0x44,0x70,0x12,0x01
	.byte 0x01,0x00,0x00,0x44,0xb7,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x00,0x07,0x00,0x00,0x44
	.byte 0x91,0x12,0x01,0x01,0x00,0x00,0x44,0xce
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x44,0x00,0x07,0x00,0x00,0x44,0xbc
	.byte 0x12,0x01,0x01,0x00,0x00,0x44,0xea,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x00,0x07
	.byte 0x00,0x00,0x44,0xd3,0x07,0x00,0x00,0x01
	.byte 0x81,0x12,0x01,0x01,0x00,0x00,0x45,0x10
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x44,0xef,0x00,0x07,0x00,0x00
	.byte 0x44,0xf4,0x12,0x01,0x01,0x00,0x00,0x45
	.byte 0x22,0x13,0x00,0x00,0x3c,0x5d,0x00,0x07
	.byte 0x00,0x00,0x45,0x15,0x12,0x01,0x01,0x00
	.byte 0x00,0x45,0x34,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x00,0x07,0x00,0x00,0x45,0x27,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x45,0x39
	.byte 0x12,0x01,0x01,0x00,0x00,0x45,0x5a,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x45,0x3e,0x00,0x07
	.byte 0x00,0x00,0x45,0x43,0x12,0x01,0x01,0x00
	.byte 0x00,0x45,0x71,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x45,0x5f,0x12,0x01,0x01,0x00,0x00
	.byte 0x45,0xa1,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x3e,0xff,0x13,0x00,0x00,0x3e
	.byte 0xff,0x13,0x00,0x00,0x3e,0xff,0x13,0x00
	.byte 0x00,0x3e,0xff,0x13,0x00,0x00,0x3e,0xff
	.byte 0x13,0x00,0x00,0x3e,0xff,0x00,0x07,0x00
	.byte 0x00,0x45,0x76,0x14,0x01,0x00,0x00,0x01
	.byte 0x68,0x01,0x00,0x00,0x45,0xbc,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x44
	.byte 0x00,0x07,0x00,0x00,0x45,0xa6,0x07,0x00
	.byte 0x00,0x01,0x68,0x12,0x01,0x01,0x00,0x00
	.byte 0x45,0xdd,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x45
	.byte 0xc1,0x00,0x07,0x00,0x00,0x45,0xc6,0x12
	.byte 0x01,0x01,0x00,0x00,0x45,0xf9,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x34,0x8e,0x00,0x07,0x00
	.byte 0x00,0x45,0xe2,0x07,0x00,0x00,0x3e,0xff
	.byte 0x12,0x01,0x01,0x00,0x00,0x46,0x1a,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x45,0xfe,0x00,0x07
	.byte 0x00,0x00,0x46,0x03,0x12,0x01,0x01,0x00
	.byte 0x00,0x46,0x40,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x31,0x86,0x00,0x07,0x00,0x00
	.byte 0x46,0x1f,0x07,0x00,0x00,0x01,0x44,0x12
	.byte 0x01,0x01,0x00,0x00,0x46,0x66,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x46,0x45,0x00,0x07,0x00,0x00,0x46,0x4a
	.byte 0x12,0x01,0x01,0x00,0x00,0x46,0x82,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x45,0xfe,0x00,0x07
	.byte 0x00,0x00,0x46,0x6b,0x14,0x01,0x00,0x00
	.byte 0x01,0xb1,0x01,0x00,0x00,0x46,0x98,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x00,0x07,0x00,0x00
	.byte 0x46,0x87,0x12,0x01,0x01,0x00,0x00,0x46
	.byte 0xb4,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x44,0xef
	.byte 0x00,0x07,0x00,0x00,0x46,0x9d,0x12,0x01
	.byte 0x01,0x00,0x00,0x46,0xd0,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x46,0x45,0x00,0x07,0x00,0x00
	.byte 0x46,0xb9,0x11,0x00,0x00,0x31,0x5a,0x07
	.byte 0x00,0x00,0x46,0xd5,0x14,0x01,0x00,0x00
	.byte 0x46,0xda,0x01,0x00,0x00,0x46,0xf5,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x00,0x07,0x00,0x00,0x46,0xdf,0x12
	.byte 0x01,0x01,0x00,0x00,0x47,0x16,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x44,0xef,0x00,0x07,0x00,0x00,0x46,0xfa
	.byte 0x12,0x01,0x01,0x00,0x00,0x47,0x37,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x46,0x45,0x00,0x07,0x00,0x00,0x47
	.byte 0x1b,0x12,0x01,0x01,0x00,0x00,0x47,0x58
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x45,0xfe,0x00,0x07,0x00,0x00
	.byte 0x47,0x3c,0x12,0x01,0x01,0x00,0x00,0x47
	.byte 0x79,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x44,0xef,0x00,0x07,0x00
	.byte 0x00,0x47,0x5d,0x12,0x01,0x01,0x00,0x00
	.byte 0x47,0x9a,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x46,0x45,0x00,0x07
	.byte 0x00,0x00,0x47,0x7e,0x12,0x01,0x01,0x00
	.byte 0x00,0x47,0xbb,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x44,0xef,0x00
	.byte 0x07,0x00,0x00,0x47,0x9f,0x12,0x01,0x01
	.byte 0x00,0x00,0x47,0xdc,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x46,0x45
	.byte 0x00,0x07,0x00,0x00,0x47,0xc0,0x12,0x01
	.byte 0x01,0x00,0x00,0x47,0xf8,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x44,0xef,0x00,0x07,0x00,0x00
	.byte 0x47,0xe1,0x12,0x01,0x01,0x00,0x00,0x48
	.byte 0x14,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x45,0xc1
	.byte 0x00,0x07,0x00,0x00,0x47,0xfd,0x04
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x07,0x00,0x00,0x48,0x19,0x12
	.byte 0x01,0x01,0x00,0x00,0x48,0x47,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x48,0x2b,0x00,0x07,0x00
	.byte 0x00,0x48,0x30,0x07,0x00,0x00,0x31,0x86
	.byte 0x12,0x01,0x01,0x00,0x00,0x48,0x68,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x48,0x4c,0x00,0x07
	.byte 0x00,0x00,0x48,0x51,0x12,0x01,0x01,0x00
	.byte 0x00,0x48,0x7f,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x34,0x8e,0x00,0x07,0x00
	.byte 0x00,0x48,0x6d,0x11,0x00,0x00,0x01,0x68
	.byte 0x07,0x00,0x00,0x48,0x84,0x11,0x00,0x00
	.byte 0x01,0x81,0x07,0x00,0x00,0x48,0x8e,0x12
	.byte 0x01,0x01,0x00,0x00,0x48,0xb4,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x48,0x89,0x13,0x00,0x00
	.byte 0x48,0x93,0x00,0x07,0x00,0x00,0x48,0x98
	.byte 0x12,0x01,0x01,0x00,0x00,0x48,0xd5,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x44,0xef,0x00,0x07,0x00,0x00,0x48
	.byte 0xb9,0x12,0x01,0x01,0x00,0x00,0x48,0xf6
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x46,0x45,0x00,0x07,0x00,0x00
	.byte 0x48,0xda,0x12,0x01,0x01,0x00,0x00,0x49
	.byte 0x17,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x45,0xfe,0x00,0x07,0x00
	.byte 0x00,0x48,0xfb,0x12,0x01,0x01,0x00,0x00
	.byte 0x49,0x38,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x44,0xef,0x00,0x07
	.byte 0x00,0x00,0x49,0x1c,0x12,0x01,0x01,0x00
	.byte 0x00,0x49,0x59,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x46,0x45,0x00
	.byte 0x07,0x00,0x00,0x49,0x3d,0x12,0x01,0x01
	.byte 0x00,0x00,0x49,0x84,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x31,0x86,0x00,0x07,0x00,0x00,0x49,0x5e
	.byte 0x12,0x01,0x01,0x00,0x00,0x49,0xaa,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x44,0xef
	.byte 0x00,0x07,0x00,0x00,0x49,0x89,0x12,0x01
	.byte 0x01,0x00,0x00,0x49,0xd0,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x46,0x45,0x00,0x07
	.byte 0x00,0x00,0x49,0xaf,0x12,0x01,0x01,0x00
	.byte 0x00,0x49,0xf1,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x44,0xef,0x00
	.byte 0x07,0x00,0x00,0x49,0xd5,0x12,0x01,0x01
	.byte 0x00,0x00,0x4a,0x12,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x46,0x45
	.byte 0x00,0x07,0x00,0x00,0x49,0xf6,0x12,0x01
	.byte 0x01,0x00,0x00,0x4a,0x2e,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0xb1,0x00,0x07,0x00,0x00
	.byte 0x4a,0x17,0x12,0x01,0x01,0x00,0x00,0x4a
	.byte 0x45,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x00,0x07,0x00,0x00,0x4a
	.byte 0x33,0x12,0x01,0x01,0x00,0x00,0x4a,0x5c
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x00,0x07,0x00,0x00,0x4a,0x4a
	.byte 0x12,0x01,0x01,0x00,0x00,0x4a,0x73,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x00,0x07,0x00,0x00,0x4a,0x61,0x11
	.byte 0x00,0x00,0x31,0x7e,0x07,0x00,0x00,0x4a
	.byte 0x78,0x12,0x01,0x01,0x00,0x00,0x4a,0x9e
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x4a,0x7d,0x00,0x07,0x00,0x00
	.byte 0x4a,0x82,0x12,0x01,0x01,0x00,0x00,0x4a
	.byte 0xb0,0x13,0x00,0x00,0x3c,0x5d,0x00,0x07
	.byte 0x00,0x00,0x4a,0xa3,0x11,0x00,0x00,0x31
	.byte 0x7e,0x07,0x00,0x00,0x4a,0xb5,0x12,0x01
	.byte 0x01,0x00,0x00,0x4a,0xdb,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x4a
	.byte 0xba,0x00,0x07,0x00,0x00,0x4a,0xbf,0x14
	.byte 0x01,0x00,0x00,0x31,0x5a,0x01,0x00,0x00
	.byte 0x4a,0xf6,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x00,0x07,0x00,0x00
	.byte 0x4a,0xe0,0x14,0x01,0x00,0x00,0x31,0x5a
	.byte 0x01,0x00,0x00,0x4b,0x11,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x68,0x00
	.byte 0x07,0x00,0x00,0x4a,0xfb,0x14,0x01,0x00
	.byte 0x00,0x31,0x5a,0x01,0x00,0x00,0x4b,0x2c
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x00,0x07,0x00,0x00,0x4b,0x16
	.byte 0x11,0x00,0x00,0x01,0x81,0x07,0x00,0x00
	.byte 0x4b,0x31,0x12,0x01,0x01,0x00,0x00,0x4b
	.byte 0x52,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x4b,0x36
	.byte 0x00,0x07,0x00,0x00,0x4b,0x3b,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x4b,0x57
	.byte 0x12,0x01,0x01,0x00,0x00,0x4b,0x82,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x4b,0x5c,0x13,0x00,0x00,0x01,0x44
	.byte 0x00,0x07,0x00,0x00,0x4b,0x61,0x12,0x01
	.byte 0x01,0x00,0x00,0x4b,0x9e,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x48,0x19,0x00,0x07,0x00,0x00
	.byte 0x4b,0x87,0x12,0x01,0x01,0x00,0x00,0x4b
	.byte 0xb5,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x81,0x00,0x07,0x00,0x00,0x4b
	.byte 0xa3,0x12,0x01,0x01,0x00,0x00,0x4b,0xcc
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x00,0x07,0x00,0x00,0x4b,0xba
	.byte 0x12,0x01,0x01,0x00,0x00,0x4b,0xde,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x00,0x07,0x00,0x00
	.byte 0x4b,0xd1,0x11,0x00,0x00,0x01,0x81,0x07
	.byte 0x00,0x00,0x4b,0xe3,0x12,0x01,0x01,0x00
	.byte 0x00,0x4b,0xff,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x4b,0xe8,0x00,0x07,0x00
	.byte 0x00,0x4b,0xed,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0x16,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x68,0x00,0x07,0x00,0x00
	.byte 0x4c,0x04,0x12,0x01,0x01,0x00,0x00,0x4c
	.byte 0x2d,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x00,0x07,0x00,0x00,0x4c
	.byte 0x1b,0x11,0x00,0x00,0x01,0x81,0x07,0x00
	.byte 0x00,0x4c,0x32,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0x6c,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x4c,0x37,0x13,0x00,0x00
	.byte 0x31,0x5a,0x00,0x07,0x00,0x00,0x4c,0x3c
	.byte 0x11,0x00,0x00,0x01,0x81,0x07,0x00,0x00
	.byte 0x4c,0x71,0x12,0x01,0x01,0x00,0x00,0x4c
	.byte 0xbf,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x4c,0x76
	.byte 0x13,0x00,0x00,0x31,0x5a,0x00,0x07,0x00
	.byte 0x00,0x4c,0x7b,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0xe0,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x00,0x07
	.byte 0x00,0x00,0x4c,0xc4,0x12,0x01,0x01,0x00
	.byte 0x00,0x4d,0x10,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x00,0x07
	.byte 0x00,0x00,0x4c,0xe5,0x11,0x00,0x00,0x01
	.byte 0x81,0x07,0x00,0x00,0x4d,0x15,0x12,0x01
	.byte 0x01,0x00,0x00,0x4d,0x3b,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x4d
	.byte 0x1a,0x00,0x07,0x00,0x00,0x4d,0x1f,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0x52,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x00,0x07,0x00,0x00,0x4d,0x40,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x4d,0x57
	.byte 0x12,0x01,0x01,0x00,0x00,0x4d,0x73,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x4d
	.byte 0x5c,0x00,0x07,0x00,0x00,0x4d,0x61,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0x8f,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x68
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x4d,0x78,0x12,0x01,0x01,0x00,0x00
	.byte 0x4d,0xb0,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x00,0x07
	.byte 0x00,0x00,0x4d,0x94,0x11,0x00,0x00,0x01
	.byte 0x81,0x07,0x00,0x00,0x4d,0xb5,0x12,0x01
	.byte 0x01,0x00,0x00,0x4d,0xd1,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x4d,0xba,0x00
	.byte 0x07,0x00,0x00,0x4d,0xbf,0x11,0x00,0x00
	.byte 0x31,0x7e,0x07,0x00,0x00,0x4d,0xd6,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0xfc,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x4d,0xdb,0x00,0x07,0x00,0x00,0x4d,0xe0
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0x2c,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x3e
	.byte 0xff,0x13,0x00,0x00,0x3e,0xff,0x13,0x00
	.byte 0x00,0x3e,0xff,0x13,0x00,0x00,0x3e,0xff
	.byte 0x13,0x00,0x00,0x3e,0xff,0x13,0x00,0x00
	.byte 0x3e,0xff,0x00,0x07,0x00,0x00,0x4e,0x01
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0x43,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x81,0x00,0x07,0x00,0x00,0x4e,0x31,0x11
	.byte 0x00,0x00,0x01,0x81,0x07,0x00,0x00,0x4e
	.byte 0x48,0x12,0x01,0x01,0x00,0x00,0x4e,0x6e
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x4e,0x4d,0x00,0x07,0x00,0x00
	.byte 0x4e,0x52,0x12,0x01,0x01,0x00,0x00,0x4e
	.byte 0x8a,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0x44
	.byte 0x00,0x07,0x00,0x00,0x4e,0x73,0x12,0x01
	.byte 0x01,0x00,0x00,0x4e,0xa6,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x81,0x00,0x07,0x00,0x00
	.byte 0x4e,0x8f,0x12,0x01,0x01,0x00,0x00,0x4e
	.byte 0xc2,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x00,0x07,0x00,0x00,0x4e,0xab,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x4e,0xc7
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0xe8,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x4e,0xcc,0x00,0x07
	.byte 0x00,0x00,0x4e,0xd1,0x12,0x01,0x01,0x00
	.byte 0x00,0x4e,0xff,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x81,0x00,0x07,0x00
	.byte 0x00,0x4e,0xed,0x12,0x01,0x01,0x00,0x00
	.byte 0x4f,0x1b,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x00,0x07,0x00,0x00,0x4f,0x04,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0x37,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x00,0x07,0x00
	.byte 0x00,0x4f,0x20,0x11,0x00,0x00,0x31,0x5a
	.byte 0x07,0x00,0x00,0x4f,0x3c,0x12,0x01,0x01
	.byte 0x00,0x00,0x4f,0x58,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x4f,0x41,0x00,0x07
	.byte 0x00,0x00,0x4f,0x46,0x12,0x01,0x01,0x00
	.byte 0x00,0x4f,0x6a,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x00,0x07,0x00,0x00,0x4f,0x5d,0x12,0x01
	.byte 0x01,0x00,0x00,0x4f,0x7c,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x00,0x07,0x00,0x00,0x4f,0x6f
	.byte 0x12,0x01,0x01
	.byte 0x00,0x00,0x4f,0x8e,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x00,0x07,0x00,0x00,0x4f,0x81,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0xa0,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x00,0x07,0x00,0x00,0x4f
	.byte 0x93,0x12,0x01,0x01,0x00,0x00,0x4f,0xb7
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x00,0x07,0x00,0x00,0x4f,0xa5
	.byte 0x12,0x01,0x01,0x00,0x00,0x4f,0xce,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x00,0x07,0x00,0x00,0x4f,0xbc,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0xe0,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x00,0x07,0x00,0x00,0x4f
	.byte 0xd3,0x12,0x01,0x01,0x00,0x00,0x4f,0xf7
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x00,0x07,0x00,0x00,0x4f,0xe5
	.byte 0x12,0x01,0x01,0x00,0x00,0x50,0x1d,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x00,0x07,0x00,0x00,0x4f,0xfc,0x12,0x01
	.byte 0x01,0x00,0x00,0x50,0x34,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x00
	.byte 0x07,0x00,0x00,0x50,0x22,0x12,0x01,0x01
	.byte 0x00,0x00,0x50,0x69,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x31,0x86,0x00,0x07,0x00,0x00
	.byte 0x50,0x39,0x12,0x01,0x01,0x00,0x00,0x50
	.byte 0x8f,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x00,0x07,0x00,0x00,0x50,0x6e
	.byte 0x14,0x01,0x00,0x00,0x01,0x44,0x01,0x00
	.byte 0x00,0x50,0xaa,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x50,0x94,0x12,0x01,0x01,0x00,0x00
	.byte 0x50,0xd0,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x00,0x07,0x00,0x00,0x50
	.byte 0xaf,0x12,0x01,0x01,0x00,0x00,0x50,0xf1
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x00,0x07,0x00,0x00
	.byte 0x50,0xd5,0x12,0x01,0x01,0x00,0x00,0x51
	.byte 0x17,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x00,0x07,0x00,0x00,0x50,0xf6
	.byte 0x12,0x01,0x01,0x00,0x00,0x51,0x33,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x45,0xc1,0x00,0x07
	.byte 0x00,0x00,0x51,0x1c,0x12,0x01,0x01,0x00
	.byte 0x00,0x51,0x4a,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x51,0x38,0x12,0x01,0x01,0x00,0x00
	.byte 0x51,0x6b,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x68,0x00,0x07
	.byte 0x00,0x00,0x51,0x4f,0x12,0x01,0x01,0x00
	.byte 0x00,0x51,0x82,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x68,0x00,0x07,0x00
	.byte 0x00,0x51,0x70,0x12,0x01,0x01,0x00,0x00
	.byte 0x51,0xa3,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x00,0x07
	.byte 0x00,0x00,0x51,0x87,0x12,0x01,0x01,0x00
	.byte 0x00,0x51,0xbf,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x00,0x07,0x00,0x00,0x51,0xa8
	.byte 0x12,0x01,0x01,0x00,0x00,0x51,0xe5,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x00,0x07,0x00,0x00,0x51,0xc4,0x11,0x00
	.byte 0x00,0x31,0x7e,0x07,0x00,0x00,0x51,0xea
	.byte 0x12,0x01,0x01,0x00,0x00,0x52,0x15,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x51,0xef
	.byte 0x00,0x07,0x00,0x00,0x51,0xf4,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x52,0x1a
	.byte 0x12,0x01,0x01,0x00,0x00,0x52,0x40,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x52,0x1f,0x00,0x07,0x00,0x00,0x52
	.byte 0x24,0x11,0x00,0x00,0x01,0x81,0x07,0x00
	.byte 0x00,0x52,0x45,0x12,0x01,0x01,0x00,0x00
	.byte 0x52,0x6b,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x52,0x4a,0x00,0x07
	.byte 0x00,0x00,0x52,0x4f,0x12,0x01,0x01,0x00
	.byte 0x00,0x52,0xa5,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x40,0xb6
	.byte 0x00,0x07,0x00,0x00,0x52,0x70,0x12,0x01
	.byte 0x01,0x00,0x00,0x52,0xe4,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x40,0xb6,0x00
	.byte 0x07,0x00,0x00,0x52,0xaa,0x12,0x01,0x01
	.byte 0x00,0x00,0x53,0x19,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x40,0xb6,0x00,0x07,0x00,0x00
	.byte 0x52,0xe9,0x12,0x01,0x01,0x00,0x00,0x53
	.byte 0x58,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x40,0xb6,0x00,0x07,0x00,0x00,0x53
	.byte 0x1e,0x12,0x01,0x01,0x00,0x00,0x53,0x9c
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x01,0xb1,0x13,0x00,0x00,0x40,0xb6,0x00
	.byte 0x07,0x00,0x00,0x53,0x5d,0x12,0x01,0x01
	.byte 0x00,0x00,0x53,0xe5,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x40,0xb6
	.byte 0x00,0x07,0x00,0x00,0x53,0xa1,0x11,0x00
	.byte 0x00,0x01,0x81,0x07,0x00,0x00,0x53,0xea
	.byte 0x12,0x01,0x01,0x00,0x00,0x54,0x10,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x53,0xef,0x00,0x07,0x00,0x00,0x53
	.byte 0xf4,0x12,0x01,0x01,0x00,0x00,0x54,0x31
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x00,0x07,0x00,0x00
	.byte 0x54,0x15,0x12,0x01,0x01,0x00,0x00,0x54
	.byte 0x4d,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0x01,0x81
	.byte 0x00,0x07,0x00,0x00,0x54,0x36,0x12,0x01
	.byte 0x01,0x00,0x00,0x54,0x6e,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x00,0x07,0x00,0x00,0x54,0x52,0x12
	.byte 0x01,0x01,0x00,0x00,0x54,0x94,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x81
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x00
	.byte 0x07,0x00,0x00,0x54,0x73,0x11,0x00,0x00
	.byte 0x01,0x81,0x07,0x00,0x00,0x54,0x99,0x12
	.byte 0x01,0x01,0x00,0x00,0x54,0xb5,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x54,0x9e
	.byte 0x00,0x07,0x00,0x00,0x54,0xa3,0x11,0x00
	.byte 0x00,0x31,0x7e,0x07,0x00,0x00,0x54,0xba
	.byte 0x12,0x01,0x01,0x00,0x00,0x54,0xe5,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x54,0xbf
	.byte 0x00,0x07,0x00,0x00,0x54,0xc4,0x12,0x01
	.byte 0x01,0x00,0x00,0x55,0x0b,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x00,0x07
	.byte 0x00,0x00,0x54,0xea,0x12,0x01,0x01,0x00
	.byte 0x00,0x55,0x31,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x81,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x00,0x07,0x00,0x00
	.byte 0x55,0x10,0x12,0x01,0x01,0x00,0x00,0x55
	.byte 0x43,0x13,0x00,0x00,0x3c,0x5d,0x00,0x07
	.byte 0x00,0x00,0x55,0x36,0x10
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x02,0x00,0x00,0x63,0xec,0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x3c,0x79,0x02,0x23,0x00,0x0d
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x3c,0x95,0x02,0x23,0x04,0x0d
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x3c,0xc4,0x02,0x23,0x08,0x0d
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x3c,0xdb,0x02,0x23,0x0c,0x0d
	.ascii "Begin\0"
	.byte 0x00,0x00,0x3c,0xf2,0x02,0x23,0x10,0x0d
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x3d,0x0e,0x02,0x23,0x14,0x0d
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x3d,0xfc,0x02,0x23,0x18,0x0d
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x3e,0x22,0x02,0x23,0x1c,0x0d
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x3e,0x39,0x02,0x23,0x20,0x0d
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x3e,0x55,0x02,0x23,0x24,0x0d
	.ascii "CallList\0"
	.byte 0x00,0x00,0x3e,0x6c,0x02,0x23,0x28,0x0d
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x3e,0x97,0x02,0x23,0x2c,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x3e,0xae,0x02,0x23,0x30,0x0d
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x3e,0xd4,0x02,0x23,0x34,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x3e,0xfa,0x02,0x23,0x38,0x0d
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x3f,0x1b,0x02,0x23,0x3c,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x3f,0x32,0x02,0x23,0x40,0x0d
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x3f,0x49,0x02,0x23,0x44,0x0d
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x3f,0x6f,0x02,0x23,0x48,0x0d
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x3f,0x90,0x02,0x23,0x4c,0x0d
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x3f,0xb1,0x02,0x23,0x50,0x0d
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x3f,0xd7,0x02,0x23,0x54,0x0d
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x3f,0xf8,0x02,0x23,0x58,0x0d
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x40,0x1e,0x02,0x23,0x5c,0x0d
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x40,0x3f,0x02,0x23,0x60,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x40,0x65,0x02,0x23,0x64,0x0d
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x40,0x81,0x02,0x23,0x68,0x0d
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x40,0xb1,0x02,0x23,0x6c,0x0d
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x40,0xd7,0x02,0x23,0x70,0x0d
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x40,0xf8,0x02,0x23,0x74,0x0d
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x41,0x23,0x02,0x23,0x78,0x0d
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x41,0x58,0x02,0x23,0x7c,0x0d
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x41,0x92,0x03,0x23,0x80,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x41,0xc2,0x03,0x23,0x84,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x41,0xfc,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x42,0x3b,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x42,0x52,0x03,0x23,0x90,0x01
	.byte 0x0d
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x42,0x6e,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x42,0x94,0x03,0x23,0x98,0x01
	.byte 0x0d
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x42,0xab,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x42,0xc2,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x42,0xde,0x03,0x23,0xa4,0x01
	.byte 0x0d
	.ascii "Disable\0"
	.byte 0x00,0x00,0x42,0xf5,0x03,0x23,0xa8,0x01
	.byte 0x0d
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x43,0x0c,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x43,0x2d,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x43,0x44,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x43,0x74,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x43,0xa9,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x43,0xc0,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x43,0xe6,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "Enable\0"
	.byte 0x00,0x00,0x43,0xfd,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x44,0x14,0x03,0x23,0xcc,0x01
	.byte 0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x44,0x26,0x03,0x23,0xd0,0x01
	.byte 0x0d
	.ascii "EndList\0"
	.byte 0x00,0x00,0x44,0x38,0x03,0x23,0xd4,0x01
	.byte 0x0d
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x44,0x4f,0x03,0x23,0xd8,0x01
	.byte 0x0d
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x44,0x6b,0x03,0x23,0xdc,0x01
	.byte 0x0d
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x44,0x8c,0x03,0x23,0xe0,0x01
	.byte 0x0d
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x44,0xb7,0x03,0x23,0xe4,0x01
	.byte 0x0d
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x44,0xce,0x03,0x23,0xe8,0x01
	.byte 0x0d
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x44,0xea,0x03,0x23,0xec,0x01
	.byte 0x0d
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x45,0x10,0x03,0x23,0xf0,0x01
	.byte 0x0d
	.ascii "Finish\0"
	.byte 0x00,0x00,0x45,0x22,0x03,0x23,0xf4,0x01
	.byte 0x0d
	.ascii "Flush\0"
	.byte 0x00,0x00,0x45,0x34,0x03,0x23,0xf8,0x01
	.byte 0x0d
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x45,0x5a,0x03,0x23,0xfc,0x01
	.byte 0x0d
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x45,0x71,0x03,0x23,0x80,0x02
	.byte 0x0d
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x45,0xa1,0x03,0x23,0x84,0x02
	.byte 0x0d
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x45,0xbc,0x03,0x23,0x88,0x02
	.byte 0x0d
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x45,0xdd,0x03,0x23,0x8c,0x02
	.byte 0x0d
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x45,0xf9,0x03,0x23,0x90,0x02
	.byte 0x0d
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x46,0x1a,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x46,0x40,0x03,0x23,0x98,0x02
	.byte 0x0d
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x46,0x66,0x03,0x23,0x9c,0x02
	.byte 0x0d
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x46,0x82,0x03,0x23,0xa0,0x02
	.byte 0x0d
	.ascii "GetError\0"
	.byte 0x00,0x00,0x46,0x98,0x03,0x23,0xa4,0x02
	.byte 0x0d
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x46,0xb4,0x03,0x23,0xa8,0x02
	.byte 0x0d
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x46,0xd0,0x03,0x23,0xac,0x02
	.byte 0x0d
	.ascii "GetString\0"
	.byte 0x00,0x00,0x46,0xf5,0x03,0x23,0xb0,0x02
	.byte 0x0d
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x47,0x16,0x03,0x23,0xb4,0x02
	.byte 0x0d
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x47,0x37,0x03,0x23,0xb8,0x02
	.byte 0x0d
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x47,0x58,0x03,0x23,0xbc,0x02
	.byte 0x0d
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x47,0x79,0x03,0x23,0xc0,0x02
	.byte 0x0d
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x47,0x9a,0x03,0x23,0xc4,0x02
	.byte 0x0d
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x47,0xbb,0x03,0x23,0xc8,0x02
	.byte 0x0d
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x47,0xdc,0x03,0x23,0xcc,0x02
	.byte 0x0d
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x47,0xf8,0x03,0x23,0xd0,0x02
	.byte 0x0d
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x48,0x14,0x03,0x23,0xd4,0x02
	.byte 0x0d
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x48,0x47,0x03,0x23,0xd8,0x02
	.byte 0x0d
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x48,0x68,0x03,0x23,0xdc,0x02
	.byte 0x0d
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x48,0x7f,0x03,0x23,0xe0,0x02
	.byte 0x0d
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x48,0xb4,0x03,0x23,0xe4,0x02
	.byte 0x0d
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x48,0xd5,0x03,0x23,0xe8,0x02
	.byte 0x0d
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x48,0xf6,0x03,0x23,0xec,0x02
	.byte 0x0d
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x49,0x17,0x03,0x23,0xf0,0x02
	.byte 0x0d
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x49,0x38,0x03,0x23,0xf4,0x02
	.byte 0x0d
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x49,0x59,0x03,0x23,0xf8,0x02
	.byte 0x0d
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x49,0x84,0x03,0x23,0xfc,0x02
	.byte 0x0d
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x49,0xaa,0x03,0x23,0x80,0x03
	.byte 0x0d
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x49,0xd0,0x03,0x23,0x84,0x03
	.byte 0x0d
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x49,0xf1,0x03,0x23,0x88,0x03
	.byte 0x0d
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x4a,0x12,0x03,0x23,0x8c,0x03
	.byte 0x0d
	.ascii "Hint\0"
	.byte 0x00,0x00,0x4a,0x2e,0x03,0x23,0x90,0x03
	.byte 0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x4a,0x45,0x03,0x23,0x94,0x03
	.byte 0x0d
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x4a,0x5c,0x03,0x23,0x98,0x03
	.byte 0x0d
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x4a,0x73,0x03,0x23,0x9c,0x03
	.byte 0x0d
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x4a,0x9e,0x03,0x23,0xa0,0x03
	.byte 0x0d
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x4a,0xb0,0x03,0x23,0xa4,0x03
	.byte 0x0d
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x4a,0xdb,0x03,0x23,0xa8,0x03
	.byte 0x0d
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x4a,0xf6,0x03,0x23,0xac,0x03
	.byte 0x0d
	.ascii "IsList\0"
	.byte 0x00,0x00,0x4b,0x11,0x03,0x23,0xb0,0x03
	.byte 0x0d
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x4b,0x2c,0x03,0x23,0xb4,0x03
	.byte 0x0d
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x4b,0x52,0x03,0x23,0xb8,0x03
	.byte 0x0d
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x4b,0x82,0x03,0x23,0xbc,0x03
	.byte 0x0d
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x4b,0x9e,0x03,0x23,0xc0,0x03
	.byte 0x0d
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x4b,0xb5,0x03,0x23,0xc4,0x03
	.byte 0x0d
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x4b,0xcc,0x03,0x23,0xc8,0x03
	.byte 0x0d
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x4b,0xde,0x03,0x23,0xcc,0x03
	.byte 0x0d
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x4b,0xff,0x03,0x23,0xd0,0x03
	.byte 0x0d
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x4c,0x16,0x03,0x23,0xd4,0x03
	.byte 0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x4c,0x2d,0x03,0x23,0xd8,0x03
	.byte 0x0d
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x4c,0x6c,0x03,0x23,0xdc,0x03
	.byte 0x0d
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x4c,0xbf,0x03,0x23,0xe0,0x03
	.byte 0x0d
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x4c,0xe0,0x03,0x23,0xe4,0x03
	.byte 0x0d
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x4d,0x10,0x03,0x23,0xe8,0x03
	.byte 0x0d
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x4d,0x3b,0x03,0x23,0xec,0x03
	.byte 0x0d
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x4d,0x52,0x03,0x23,0xf0,0x03
	.byte 0x0d
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x4d,0x73,0x03,0x23,0xf4,0x03
	.byte 0x0d
	.ascii "NewList\0"
	.byte 0x00,0x00,0x4d,0x8f,0x03,0x23,0xf8,0x03
	.byte 0x0d
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x4d,0xb0,0x03,0x23,0xfc,0x03
	.byte 0x0d
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x4d,0xd1,0x03,0x23,0x80,0x04
	.byte 0x0d
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x4d,0xfc,0x03,0x23,0x84,0x04
	.byte 0x0d
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x4e,0x2c,0x03,0x23,0x88,0x04
	.byte 0x0d
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x4e,0x43,0x03,0x23,0x8c,0x04
	.byte 0x0d
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x4e,0x6e,0x03,0x23,0x90,0x04
	.byte 0x0d
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x4e,0x8a,0x03,0x23,0x94,0x04
	.byte 0x0d
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x4e,0xa6,0x03,0x23,0x98,0x04
	.byte 0x0d
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x4e,0xc2,0x03,0x23,0x9c,0x04
	.byte 0x0d
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x4e,0xe8,0x03,0x23,0xa0,0x04
	.byte 0x0d
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x4e,0xff,0x03,0x23,0xa4,0x04
	.byte 0x0d
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x4f,0x1b,0x03,0x23,0xa8,0x04
	.byte 0x0d
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x4f,0x37,0x03,0x23,0xac,0x04
	.byte 0x0d
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x4f,0x58,0x03,0x23,0xb0,0x04
	.byte 0x0d
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x4f,0x6a,0x03,0x23,0xb4,0x04
	.byte 0x0d
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x4f,0x7c,0x03,0x23,0xb8,0x04
	.byte 0x0d
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x4f,0x8e,0x03,0x23,0xbc,0x04
	.byte 0x0d
	.ascii "PopName\0"
	.byte 0x00,0x00,0x4f,0xa0,0x03,0x23,0xc0,0x04
	.byte 0x0d
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x4f,0xb7,0x03,0x23,0xc4,0x04
	.byte 0x0d
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x4f,0xce,0x03,0x23,0xc8,0x04
	.byte 0x0d
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x4f,0xe0,0x03,0x23,0xcc,0x04
	.byte 0x0d
	.ascii "PushName\0"
	.byte 0x00,0x00,0x4f,0xf7,0x03,0x23,0xd0,0x04
	.byte 0x0d
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x50,0x1d,0x03,0x23,0xd4,0x04
	.byte 0x0d
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x50,0x34,0x03,0x23,0xd8,0x04
	.byte 0x0d
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x50,0x69,0x03,0x23,0xdc,0x04
	.byte 0x0d
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x50,0x8f,0x03,0x23,0xe0,0x04
	.byte 0x0d
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x50,0xaa,0x03,0x23,0xe4,0x04
	.byte 0x0d
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x50,0xd0,0x03,0x23,0xe8,0x04
	.byte 0x0d
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x50,0xf1,0x03,0x23,0xec,0x04
	.byte 0x0d
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x51,0x17,0x03,0x23,0xf0,0x04
	.byte 0x0d
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x51,0x33,0x03,0x23,0xf4,0x04
	.byte 0x0d
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x51,0x4a,0x03,0x23,0xf8,0x04
	.byte 0x0d
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x51,0x6b,0x03,0x23,0xfc,0x04
	.byte 0x0d
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x51,0x82,0x03,0x23,0x80,0x05
	.byte 0x0d
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x51,0xa3,0x03,0x23,0x84,0x05
	.byte 0x0d
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x51,0xbf,0x03,0x23,0x88,0x05
	.byte 0x0d
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x51,0xe5,0x03,0x23,0x8c,0x05
	.byte 0x0d
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x52,0x15,0x03,0x23,0x90,0x05
	.byte 0x0d
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x52,0x40,0x03,0x23,0x94,0x05
	.byte 0x0d
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x52,0x6b,0x03,0x23,0x98,0x05
	.byte 0x0d
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x52,0xa5,0x03,0x23,0x9c,0x05
	.byte 0x0d
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x52,0xe4,0x03,0x23,0xa0,0x05
	.byte 0x0d
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x53,0x19,0x03,0x23,0xa4,0x05
	.byte 0x0d
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x53,0x58,0x03,0x23,0xa8,0x05
	.byte 0x0d
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x53,0x9c,0x03,0x23,0xac,0x05
	.byte 0x0d
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x53,0xe5,0x03,0x23,0xb0,0x05
	.byte 0x0d
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x54,0x10,0x03,0x23,0xb4,0x05
	.byte 0x0d
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x54,0x31,0x03,0x23,0xb8,0x05
	.byte 0x0d
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x54,0x4d,0x03,0x23,0xbc,0x05
	.byte 0x0d
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x54,0x6e,0x03,0x23,0xc0,0x05
	.byte 0x0d
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x54,0x94,0x03,0x23,0xc4,0x05
	.byte 0x0d
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x54,0xb5,0x03,0x23,0xc8,0x05
	.byte 0x0d
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x54,0xe5,0x03,0x23,0xcc,0x05
	.byte 0x0d
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x55,0x0b,0x03,0x23,0xd0,0x05
	.byte 0x0d
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x55,0x31,0x03,0x23,0xd4,0x05
	.byte 0x0d
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x55,0x43,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0c
	.ascii "gl_visual\0"
	.byte 0x4c,0x02,0x00,0x00,0x65,0x94,0x0d
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x01,0x0d
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x04,0x0d
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x08,0x0d
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x0c,0x0d
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x10,0x0d
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x14,0x0d
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x20,0x0d
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x24,0x0d
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x28,0x0d
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x2c,0x0d
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x30,0x0d
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x34,0x0d
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x38,0x0d
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x3c,0x0d
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x40,0x0d
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x44,0x0d
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x48,0x0d
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x49,0x00
	.byte 0x05,0x00,0x00,0x63,0xec
	.ascii "GLvisual\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0x94,0x05,0x00
	.byte 0x00,0x48,0x19
	.ascii "GLdepth\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0xa8,0x05,0x00
	.byte 0x00,0x31,0x5a
	.ascii "GLstencil\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0xbb,0x04
	.ascii "short\0"
	.byte 0x05,0x02,0x05,0x00,0x00,0x65,0xd0
	.ascii "GLaccum\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0xd9,0x0c
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x02,0x00,0x00,0x66,0xc3,0x0d
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xa3,0x02,0x23,0x00,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x08,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x65,0xb6,0x02,0x23,0x0c,0x0d
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x65,0xcb,0x02,0x23,0x10,0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x65,0xe7,0x02,0x23,0x14,0x0d
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0x79,0x02,0x23,0x18,0x0d
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0x79,0x02,0x23,0x1c,0x0d
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0x79,0x02,0x23,0x20,0x0d
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x24,0x0d
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x28,0x0d
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x2c,0x0d
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x30,0x00
	.byte 0x05,0x00,0x00,0x65,0xec
	.ascii "GLframebuffer\0"
	.byte 0x02,0x07,0x00,0x00,0x66,0xc3,0x04
	.ascii "char\0"
	.byte 0x06,0x01,0x11,0x00,0x00,0x66,0xdc,0x07
	.byte 0x00,0x00,0x66,0xe4,0x15,0x01,0x00,0x00
	.byte 0x66,0xe9,0x01,0x07,0x00,0x00,0x66,0xee
	.byte 0x12,0x01,0x01,0x00,0x00,0x67,0x07,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x00,0x07,0x00,0x00
	.byte 0x66,0xfa,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0x1e,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x00,0x07,0x00,0x00,0x67
	.byte 0x0c,0x12,0x01,0x01,0x00,0x00,0x67,0x44
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x31,0x5a,0x13,0x00,0x00,0x31,0x5a,0x13
	.byte 0x00,0x00,0x31,0x5a,0x13,0x00,0x00,0x31
	.byte 0x5a,0x00,0x07,0x00,0x00,0x67,0x23,0x12
	.byte 0x01,0x01,0x00,0x00,0x67,0x6f,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x31,0x5a
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x00,0x07,0x00,0x00
	.byte 0x67,0x49,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0x86,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x00,0x07,0x00,0x00,0x67
	.byte 0x74,0x12,0x01,0x01,0x00,0x00,0x67,0xac
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x31,0x5a,0x13,0x00,0x00,0x31,0x5a,0x13
	.byte 0x00,0x00,0x31,0x5a,0x13,0x00,0x00,0x31
	.byte 0x5a,0x00,0x07,0x00,0x00,0x67,0x8b,0x14
	.byte 0x01,0x00,0x00,0x31,0x5a,0x01,0x00,0x00
	.byte 0x67,0xc7,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0xb1,0x00,0x07,0x00,0x00
	.byte 0x67,0xb1,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0xe3,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x45,0xc1,0x13,0x00,0x00,0x45,0xc1
	.byte 0x00,0x07,0x00,0x00,0x67,0xcc,0x11,0x00
	.byte 0x00,0x31,0x5a,0x07,0x00,0x00,0x67,0xe8
	.byte 0x11,0x00,0x00,0x31,0x5a,0x07,0x00,0x00
	.byte 0x67,0xf2,0x11,0x00,0x00,0x31,0x5a,0x07
	.byte 0x00,0x00,0x67,0xfc,0x11,0x00,0x00,0x31
	.byte 0x5a,0x07,0x00,0x00,0x68,0x06,0x11,0x00
	.byte 0x00,0x31,0x5a,0x07,0x00,0x00,0x68,0x10
	.byte 0x12,0x01,0x01,0x00,0x00,0x68,0x4f,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x67,0xed
	.byte 0x13,0x00,0x00,0x67,0xf7,0x13,0x00,0x00
	.byte 0x68,0x01,0x13,0x00,0x00,0x68,0x0b,0x13
	.byte 0x00,0x00,0x68,0x15,0x00,0x07,0x00,0x00
	.byte 0x68,0x1a,0x11,0x00,0x00,0x31,0x5a,0x07
	.byte 0x00,0x00,0x68,0x54,0x12,0x01,0x01,0x00
	.byte 0x00,0x68,0x7f,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x68,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x68,0x59,0x00,0x07,0x00,0x00
	.byte 0x68,0x5e,0x11,0x00,0x00,0x01,0x44,0x07
	.byte 0x00,0x00,0x68,0x84,0x11,0x00,0x00,0x01
	.byte 0x44,0x07,0x00,0x00,0x68,0x8e,0x11,0x00
	.byte 0x00,0x31,0x5a,0x07,0x00,0x00,0x68,0x98
	.byte 0x11,0x00,0x00,0x31,0x5a,0x07,0x00,0x00
	.byte 0x68,0xa2,0x11,0x00,0x00,0x31,0x5a,0x07
	.byte 0x00,0x00,0x68,0xac,0x11,0x00,0x00,0x31
	.byte 0x5a,0x07,0x00,0x00,0x68,0xb6,0x11,0x00
	.byte 0x00,0x31,0x5a,0x07,0x00,0x00,0x68,0xc0
	.byte 0x12,0x01,0x01,0x00,0x00,0x68,0xff,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x13,0x00,0x00,0x68,0x89,0x13,0x00
	.byte 0x00,0x68,0x93,0x13,0x00,0x00,0x68,0x9d
	.byte 0x13,0x00,0x00,0x68,0xa7,0x13,0x00,0x00
	.byte 0x68,0xb1,0x13,0x00,0x00,0x68,0xbb,0x13
	.byte 0x00,0x00,0x68,0xc5,0x00,0x07,0x00,0x00
	.byte 0x68,0xca,0x11,0x00,0x00,0x01,0x44,0x07
	.byte 0x00,0x00,0x69,0x04,0x11,0x00,0x00,0x01
	.byte 0x44,0x07,0x00,0x00,0x69,0x0e,0x11,0x00
	.byte 0x00,0x31,0x5a,0x07,0x00,0x00,0x69,0x18
	.byte 0x12,0x01,0x01,0x00,0x00,0x69,0x43,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x13,0x00,0x00,0x69,0x09,0x13,0x00
	.byte 0x00,0x69,0x13,0x13,0x00,0x00,0x69,0x1d
	.byte 0x00,0x07,0x00,0x00,0x69,0x22,0x11,0x00
	.byte 0x00,0x01,0x68,0x07,0x00,0x00,0x69,0x48
	.byte 0x11,0x00,0x00,0x31,0x5a,0x07,0x00,0x00
	.byte 0x69,0x52,0x12,0x01,0x01,0x00,0x00,0x69
	.byte 0x82,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x69,0x4d,0x13,0x00,0x00,0x69,0x57,0x00
	.byte 0x07,0x00,0x00,0x69,0x5c,0x11,0x00,0x00
	.byte 0x31,0x5a,0x07,0x00,0x00,0x69,0x87,0x12
	.byte 0x01,0x01,0x00,0x00,0x69,0xb2,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x68
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x69,0x8c,0x00
	.byte 0x07,0x00,0x00,0x69,0x91,0x11,0x00,0x00
	.byte 0x01,0x44,0x07,0x00,0x00,0x69,0xb7,0x11
	.byte 0x00,0x00,0x01,0x44,0x07,0x00,0x00,0x69
	.byte 0xc1,0x11,0x00,0x00,0x01,0x68,0x07,0x00
	.byte 0x00,0x69,0xcb,0x11,0x00,0x00,0x31,0x5a
	.byte 0x07,0x00,0x00,0x69,0xd5,0x12,0x01,0x01
	.byte 0x00,0x00,0x6a,0x05,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x68,0x13,0x00
	.byte 0x00,0x69,0xbc,0x13,0x00,0x00,0x69,0xc6
	.byte 0x13,0x00,0x00,0x69,0xd0,0x13,0x00,0x00
	.byte 0x69,0xda,0x00,0x07,0x00,0x00,0x69,0xdf
	.byte 0x11,0x00,0x00,0x01,0x44,0x07,0x00,0x00
	.byte 0x6a,0x0a,0x11,0x00,0x00,0x01,0x44,0x07
	.byte 0x00,0x00,0x6a,0x14,0x11,0x00,0x00,0x31
	.byte 0x5a,0x07,0x00,0x00,0x6a,0x1e,0x12,0x01
	.byte 0x01,0x00,0x00,0x6a,0x49,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x68,0x13
	.byte 0x00,0x00,0x6a,0x0f,0x13,0x00,0x00,0x6a
	.byte 0x19,0x13,0x00,0x00,0x6a,0x23,0x00,0x07
	.byte 0x00,0x00,0x6a,0x28,0x12,0x01,0x01,0x00
	.byte 0x00,0x6a,0x6f,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x68,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x45,0xc1,0x00,0x07,0x00,0x00
	.byte 0x6a,0x4e,0x12,0x01,0x01,0x00,0x00,0x6a
	.byte 0xa4,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0x68,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x34,0x8e,0x13,0x00,0x00,0x34,0x8e,0x13
	.byte 0x00,0x00,0x34,0x8e,0x13,0x00,0x00,0x34
	.byte 0x8e,0x00,0x07,0x00,0x00,0x6a,0x74,0x11
	.byte 0x00,0x00,0x01,0x44,0x07,0x00,0x00,0x6a
	.byte 0xa9,0x11,0x00,0x00,0x01,0x44,0x07,0x00
	.byte 0x00,0x6a,0xb3,0x11,0x00,0x00,0x31,0x5a
	.byte 0x07,0x00,0x00,0x6a,0xbd,0x12,0x01,0x01
	.byte 0x00,0x00,0x6a,0xed,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x68,0x13,0x00
	.byte 0x00,0x6a,0xae,0x13,0x00,0x00,0x6a,0xb8
	.byte 0x13,0x00,0x00,0x45,0xc1,0x13,0x00,0x00
	.byte 0x6a,0xc2,0x00,0x07,0x00,0x00,0x6a,0xc7
	.byte 0x11,0x00,0x00,0x01,0x44,0x07,0x00,0x00
	.byte 0x6a,0xf2,0x11,0x00,0x00,0x01,0x44,0x07
	.byte 0x00,0x00,0x6a,0xfc,0x11,0x00,0x00,0x31
	.byte 0x5a,0x07,0x00,0x00,0x6b,0x06,0x12,0x01
	.byte 0x01,0x00,0x00,0x6b,0x45,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0x68,0x13
	.byte 0x00,0x00,0x6a,0xf7,0x13,0x00,0x00,0x6b
	.byte 0x01,0x13,0x00,0x00,0x34,0x8e,0x13,0x00
	.byte 0x00,0x34,0x8e,0x13,0x00,0x00,0x34,0x8e
	.byte 0x13,0x00,0x00,0x34,0x8e,0x13,0x00,0x00
	.byte 0x6b,0x0b,0x00,0x07,0x00,0x00,0x6b,0x10
	.byte 0x12,0x01,0x01,0x00,0x00,0x6b,0x57,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x00,0x07,0x00,0x00
	.byte 0x6b,0x4a,0x12,0x01,0x01,0x00,0x00,0x6b
	.byte 0x69,0x13,0x00,0x00,0x3c,0x5d,0x00,0x07
	.byte 0x00,0x00,0x6b,0x5c,0x14,0x01,0x00,0x00
	.byte 0x31,0x5a,0x01,0x00,0x00,0x6b,0x84,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0x68,0x00,0x07,0x00,0x00,0x6b,0x6e,0x14
	.byte 0x01,0x00,0x00,0x31,0x5a,0x01,0x00,0x00
	.byte 0x6b,0xae,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x31,0x5a,0x13,0x00,0x00,0x31
	.byte 0x5a,0x13,0x00,0x00,0x31,0x5a,0x13,0x00
	.byte 0x00,0x31,0x5a,0x00,0x07,0x00,0x00,0x6b
	.byte 0x89,0x14,0x01,0x00,0x00,0x31,0x5a,0x01
	.byte 0x00,0x00,0x6b,0xc9,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x00,0x07
	.byte 0x00,0x00,0x6b,0xb3,0x12,0x01,0x01,0x00
	.byte 0x00,0x6b,0xe0,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x31,0x5a,0x00,0x07,0x00
	.byte 0x00,0x6b,0xce,0x12,0x01,0x01,0x00,0x00
	.byte 0x6b,0xf2,0x13,0x00,0x00,0x3c,0x5d,0x00
	.byte 0x07,0x00,0x00,0x6b,0xe5,0x12,0x01,0x01
	.byte 0x00,0x00,0x6c,0x0e,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x81,0x13,0x00
	.byte 0x00,0x01,0x81,0x00,0x07,0x00,0x00,0x6b
	.byte 0xf7,0x12,0x01,0x01,0x00,0x00,0x6c,0x20
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x00,0x07,0x00
	.byte 0x00,0x6c,0x13,0x12,0x01,0x01,0x00,0x00
	.byte 0x6c,0x32,0x13,0x00,0x00,0x3c,0x5d,0x00
	.byte 0x07,0x00,0x00,0x6c,0x25,0x11,0x00,0x00
	.byte 0x48,0x19,0x07,0x00,0x00,0x6c,0x37,0x14
	.byte 0x01,0x00,0x00,0x01,0x68,0x01,0x00,0x00
	.byte 0x6c,0x6b,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x68,0x13,0x00,0x00,0x01
	.byte 0x44,0x13,0x00,0x00,0x01,0x44,0x13,0x00
	.byte 0x00,0x6c,0x3c,0x13,0x00,0x00,0x34,0x8e
	.byte 0x00,0x07,0x00,0x00,0x6c,0x41,0x11,0x00
	.byte 0x00,0x01,0x44,0x07,0x00,0x00,0x6c,0x70
	.byte 0x11,0x00,0x00,0x01,0x44,0x07,0x00,0x00
	.byte 0x6c,0x7a,0x11,0x00,0x00,0x48,0x19,0x07
	.byte 0x00,0x00,0x6c,0x84,0x12,0x01,0x01,0x00
	.byte 0x00,0x6c,0xb4,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0x68,0x13,0x00,0x00
	.byte 0x6c,0x75,0x13,0x00,0x00,0x6c,0x7f,0x13
	.byte 0x00,0x00,0x6c,0x89,0x13,0x00,0x00,0x34
	.byte 0x8e,0x00,0x07,0x00,0x00,0x6c,0x8e,0x12
	.byte 0x01,0x01,0x00,0x00,0x6c,0xda,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x68
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x44,0xef,0x00
	.byte 0x07,0x00,0x00,0x6c,0xb9,0x12,0x01,0x01
	.byte 0x00,0x00,0x6d,0x00,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x68,0x13,0x00
	.byte 0x00,0x01,0x44,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x48,0x2b,0x00,0x07,0x00
	.byte 0x00,0x6c,0xdf,0x12,0x01,0x01,0x00,0x00
	.byte 0x6d,0x1c,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x01,0x68,0x13,0x00,0x00,0x01
	.byte 0x68,0x00,0x07,0x00,0x00,0x6d,0x05,0x05
	.byte 0x00,0x00,0x6d,0x1c
	.ascii "points_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0x4f
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x13,0x00,0x00,0x01,0x68,0x13
	.byte 0x00,0x00,0x01,0x68,0x00,0x07,0x00,0x00
	.byte 0x6d,0x33,0x05,0x00,0x00,0x6d,0x4f
	.ascii "line_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0x85
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x13,0x00,0x00,0x01,0x68,0x13
	.byte 0x00,0x00,0x01,0x68,0x13,0x00,0x00,0x01
	.byte 0x68,0x00,0x07,0x00,0x00,0x6d,0x64,0x05
	.byte 0x00,0x00,0x6d,0x85
	.ascii "triangle_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0xc4
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x68,0x13,0x00,0x00,0x01,0x68,0x13
	.byte 0x00,0x00,0x01,0x68,0x13,0x00,0x00,0x01
	.byte 0x68,0x13,0x00,0x00,0x01,0x68,0x00,0x07
	.byte 0x00,0x00,0x6d,0x9e,0x05,0x00,0x00,0x6d
	.byte 0xc4
	.ascii "quad_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0xfa
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x01
	.byte 0x44,0x00,0x07,0x00,0x00,0x6d,0xd9,0x05
	.byte 0x00,0x00,0x6d,0xfa
	.ascii "rect_func\0"
	.byte 0x02,0x11,0x00,0x00,0x31,0x7e,0x07,0x00
	.byte 0x00,0x6e,0x0f,0x14,0x01,0x00,0x00,0x31
	.byte 0x5a,0x01,0x00,0x00,0x6e,0x52,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x44,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0xb1,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x31,0x5a,0x13,0x00
	.byte 0x00,0x6e,0x14,0x00,0x07,0x00,0x00,0x6e
	.byte 0x19,0x11,0x00,0x00,0x3d,0x25,0x07,0x00
	.byte 0x00,0x6e,0x57,0x14,0x01,0x00,0x00,0x31
	.byte 0x5a,0x01,0x00,0x00,0x6e,0x95,0x13,0x00
	.byte 0x00,0x3c,0x5d,0x13,0x00,0x00,0x01,0x44
	.byte 0x13,0x00,0x00,0x01,0x44,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0x6e,0x5c,0x00,0x07
	.byte 0x00,0x00,0x6e,0x61,0x12,0x01,0x01,0x00
	.byte 0x00,0x6e,0xac,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x00,0x07,0x00
	.byte 0x00,0x6e,0x9a,0x12,0x01,0x01,0x00,0x00
	.byte 0x6e,0xbe,0x13,0x00,0x00,0x3c,0x5d,0x00
	.byte 0x07,0x00,0x00,0x6e,0xb1,0x12,0x01,0x01
	.byte 0x00,0x00,0x6e,0xda,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0x68,0x13,0x00
	.byte 0x00,0x01,0x68,0x00,0x07,0x00,0x00,0x6e
	.byte 0xc3,0x14,0x01,0x00,0x00,0x31,0x5a,0x01
	.byte 0x00,0x00,0x6e,0xf5,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x31,0x5a,0x00,0x07
	.byte 0x00,0x00,0x6e,0xdf,0x11,0x00,0x00,0x01
	.byte 0x81,0x07,0x00,0x00,0x6e,0xfa,0x12,0x01
	.byte 0x01,0x00,0x00,0x6f,0x1b,0x13,0x00,0x00
	.byte 0x3c,0x5d,0x13,0x00,0x00,0x01,0xb1,0x13
	.byte 0x00,0x00,0x6e,0xff,0x00,0x07,0x00,0x00
	.byte 0x6f,0x04,0x11,0x00,0x00,0x31,0x8b,0x07
	.byte 0x00,0x00,0x6f,0x20,0x12,0x01,0x01,0x00
	.byte 0x00,0x6f,0x50,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x34,0xea,0x13,0x00,0x00,0x01,0x44,0x13
	.byte 0x00,0x00,0x01,0x44,0x13,0x00,0x00,0x6f
	.byte 0x25,0x00,0x07,0x00,0x00,0x6f,0x2a
	.byte 0x11,0x00,0x00,0x01,0x81,0x07,0x00,0x00
	.byte 0x6f,0x55,0x12,0x01,0x01,0x00,0x00,0x6f
	.byte 0x80,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x01,0xb1,0x13,0x00,0x00,0x34,0xea
	.byte 0x13,0x00,0x00,0x01,0xb1,0x13,0x00,0x00
	.byte 0x6f,0x5a,0x00,0x07,0x00,0x00,0x6f,0x5f
	.byte 0x12,0x01,0x01,0x00,0x00,0x6f,0x9c,0x13
	.byte 0x00,0x00,0x3c,0x5d,0x13,0x00,0x00,0x01
	.byte 0xb1,0x13,0x00,0x00,0x34,0xea,0x00,0x07
	.byte 0x00,0x00,0x6f,0x85,0x12,0x01,0x01,0x00
	.byte 0x00,0x6f,0xb3,0x13,0x00,0x00,0x3c,0x5d
	.byte 0x13,0x00,0x00,0x34,0xea,0x00,0x07,0x00
	.byte 0x00,0x6f,0xa1,0x12,0x01,0x01,0x00,0x00
	.byte 0x6f,0xca,0x13,0x00,0x00,0x3c,0x5d,0x13
	.byte 0x00,0x00,0x34,0xea,0x00,0x07,0x00,0x00
	.byte 0x6f,0xb8,0x12,0x01,0x01,0x00,0x00,0x6f
	.byte 0xe1,0x13,0x00,0x00,0x3c,0x5d,0x13,0x00
	.byte 0x00,0x31,0x5a,0x00,0x07,0x00,0x00,0x6f
	.byte 0xcf,0x0c
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x74,0x4e,0x0d
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x66,0xf5,0x02,0x23,0x00,0x0d
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x67,0x07,0x02,0x23,0x04,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x67,0x1e,0x02,0x23,0x08,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x67,0x44,0x02,0x23,0x0c,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x67,0x6f,0x02,0x23,0x10,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x67,0x86,0x02,0x23,0x14,0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x67,0xac,0x02,0x23,0x18,0x0d
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x67,0xc7,0x02,0x23,0x1c,0x0d
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x67,0xe3,0x02,0x23,0x20,0x0d
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x68,0x4f,0x02,0x23,0x24,0x0d
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x68,0x7f,0x02,0x23,0x28,0x0d
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x68,0xff,0x02,0x23,0x2c,0x0d
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x69,0x43,0x02,0x23,0x30,0x0d
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x69,0x82,0x02,0x23,0x34,0x0d
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x69,0xb2,0x02,0x23,0x38,0x0d
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x6a,0x05,0x02,0x23,0x3c,0x0d
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x6a,0x49,0x02,0x23,0x40,0x0d
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x6a,0x6f,0x02,0x23,0x44,0x0d
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x6a,0xa4,0x02,0x23,0x48,0x0d
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x6a,0xed,0x02,0x23,0x4c,0x0d
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x6b,0x45,0x02,0x23,0x50,0x0d
	.ascii "Finish\0"
	.byte 0x00,0x00,0x6b,0x57,0x02,0x23,0x54,0x0d
	.ascii "Flush\0"
	.byte 0x00,0x00,0x6b,0x69,0x02,0x23,0x58,0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x6b,0x84,0x02,0x23,0x5c,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x6b,0xae,0x02,0x23,0x60,0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x6b,0xc9,0x02,0x23,0x64,0x0d
	.ascii "Dither\0"
	.byte 0x00,0x00,0x6b,0xe0,0x02,0x23,0x68,0x0d
	.ascii "Error\0"
	.byte 0x00,0x00,0x6b,0xf2,0x02,0x23,0x6c,0x0d
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x6c,0x0e,0x02,0x23,0x70,0x0d
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x20,0x02,0x23,0x74,0x0d
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x32,0x02,0x23,0x78,0x0d
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x6c,0x6b,0x02,0x23,0x7c,0x0d
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x6c,0xb4,0x03,0x23,0x80,0x01
	.byte 0x0d
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x6c,0xda,0x03,0x23,0x84,0x01
	.byte 0x0d
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x6d,0x00,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x21,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x54,0x03,0x23,0x90,0x01
	.byte 0x0d
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x8a,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xc9,0x03,0x23,0x98,0x01
	.byte 0x0d
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xff,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x6e,0x52,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x6e,0x95,0x03,0x23,0xa4,0x01
	.byte 0x0d
	.ascii "Begin\0"
	.byte 0x00,0x00,0x6e,0xac,0x03,0x23,0xa8,0x01
	.byte 0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x6e,0xbe,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x6e,0xda,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x6e,0xf5,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x6f,0x1b,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x6f,0x50,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x6f,0x80,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x6f,0x9c,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x6f,0xb3,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xca,0x03,0x23,0xcc,0x01
	.byte 0x0d
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xe1,0x03,0x23,0xd0,0x01
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x40,0x00
	.byte 0x00,0x74,0x5f,0x09,0x00,0x00,0x01,0x98
	.byte 0x0f,0x00,0x08,0x00,0x00,0x01,0x8a,0x40
	.byte 0x00,0x00,0x74,0x70,0x09,0x00,0x00,0x01
	.byte 0x98,0x0f,0x00,0x08,0x00,0x00,0x01,0x81
	.byte 0x40,0x00,0x00,0x74,0x81,0x09,0x00,0x00
	.byte 0x01,0x98,0x0f,0x00,0x0e,0x00,0x00,0x74
	.byte 0x70,0x08,0x00,0x00,0x00,0x74,0x93,0x09
	.byte 0x00,0x00,0x01,0x98,0x1f,0x00,0x08,0x00
	.byte 0x00,0x01,0x8a,0x40,0x00,0x00,0x74,0xa4
	.byte 0x09,0x00,0x00,0x01,0x98,0x0f,0x00,0x08
	.byte 0x00,0x00,0x01,0x81,0x40,0x00,0x00,0x74
	.byte 0xb5,0x09,0x00,0x00,0x01,0x98,0x0f,0x00
	.byte 0x0e,0x00,0x00,0x74,0xa4,0x08,0x00,0x00
	.byte 0x00,0x74,0xc7,0x09,0x00,0x00,0x01,0x98
	.byte 0x1f,0x00,0x08,0x00,0x00,0x01,0x81,0x08
	.byte 0x00,0x00,0x74,0xd8,0x09,0x00,0x00,0x01
	.byte 0x98,0x01,0x00,0x0e,0x00,0x00,0x74,0xc7
	.byte 0x01,0x00,0x00,0x00,0x74,0xea,0x09,0x00
	.byte 0x00,0x01,0x98,0x1f,0x00,0x08,0x00,0x00
	.byte 0x01,0x8a,0x40,0x00,0x00,0x74,0xfb,0x09
	.byte 0x00,0x00,0x01,0x98,0x0f,0x00,0x08,0x00
	.byte 0x00,0x01,0x81,0x40,0x00,0x00,0x75,0x0c
	.byte 0x09,0x00,0x00,0x01,0x98,0x0f,0x00,0x0e
	.byte 0x00,0x00,0x74,0xfb,0x02,0x80,0x00,0x00
	.byte 0x75,0x1e,0x09,0x00,0x00,0x01,0x98,0x09
	.byte 0x00,0x05,0x00,0x00,0x01,0x68
	.ascii "GLbitfield\0"
	.byte 0x03,0x07,0x00,0x00,0x75,0x34,0x0c
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x02,0x00,0x00,0x75,0x72,0x0d
	.ascii "kind\0"
	.byte 0x00,0x00,0x75,0x1e,0x02,0x23,0x00,0x0d
	.ascii "data\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x04,0x0d
	.ascii "next\0"
	.byte 0x00,0x00,0x75,0x2f,0x02,0x23,0x08,0x00
	.byte 0x08,0x00,0x00,0x75,0x2f,0x40,0x00,0x00
	.byte 0x75,0x83,0x09,0x00,0x00,0x01,0x98,0x0f
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x10,0x00
	.byte 0x00,0x75,0x94,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x0c
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x02,0x00,0x00,0x75,0xbf,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0x83,0x02,0x23,0x00,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x75,0xd0,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x10,0x00
	.byte 0x00,0x75,0xe1,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x0c
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x02,0x00,0x00,0x77,0x90,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x00,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xbf,0x02,0x23,0x04,0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x14,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x18,0x0d
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x1c,0x0d
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x20,0x0d
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x24,0x0d
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x28,0x0d
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x2c,0x0d
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0x6b,0x02,0x23,0x30,0x0d
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x31,0x0d
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x34,0x0d
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x38,0x0d
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x3c,0x0d
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x75,0xd0,0x02,0x23,0x40,0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x50,0x0d
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x54,0x0d
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x55,0x0d
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x56,0x0d
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x57,0x00
	.byte 0x08,0x00,0x00,0x31,0x6b,0x04,0x00,0x00
	.byte 0x77,0xa1,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x0c,0x00
	.byte 0x00,0x77,0xb2,0x09,0x00,0x00,0x01,0x98
	.byte 0x02,0x00,0x08,0x00,0x00,0x01,0x8a,0x10
	.byte 0x00,0x00,0x77,0xc3,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x08,0x00,0x00,0x01,0x8a
	.byte 0x10,0x00,0x00,0x77,0xd4,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x8a,0x10,0x00,0x00,0x77,0xe5,0x09,0x00
	.byte 0x00,0x01,0x98,0x03,0x00,0x08,0x00,0x00
	.byte 0x01,0x8a,0x10,0x00,0x00,0x77,0xf6,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x0c
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x02,0x00,0x00,0x78,0xe0,0x0d
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x77,0x90,0x02,0x23,0x00,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x04,0x0d
	.ascii "Normal\0"
	.byte 0x00,0x00,0x77,0xa1,0x02,0x23,0x08,0x0d
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x77,0xb2,0x02,0x23,0x14,0x0d
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x77,0xc3,0x02,0x23,0x24,0x0d
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x34,0x0d
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x77,0xd4,0x02,0x23,0x38,0x0d
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x48,0x0d
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x77,0xe5,0x02,0x23,0x4c,0x0d
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x5c,0x0d
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x5d,0x00
	.byte 0x0c
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x79,0x33,0x0d
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x04,0x0d
	.ascii "Test\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x08,0x0d
	.ascii "Mask\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x09,0x00
	.byte 0x0c
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x02,0x00,0x00,0x7b,0x98,0x0d
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x01,0x0d
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x02,0x0d
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x03,0x0d
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x04,0x0d
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x05,0x0d
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x06,0x0d
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x07,0x0d
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x08,0x0d
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x09,0x0d
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0a,0x0d
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0b,0x0d
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0c,0x0d
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0d,0x0d
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0e,0x0d
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0f,0x0d
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x10,0x0d
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x11,0x0d
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x12,0x0d
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x14,0x0d
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x20,0x0d
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x24,0x0d
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x28,0x0d
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x2c,0x0d
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x30,0x0d
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x34,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x7b,0xa9,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x0c
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x7c,0x22,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x7b,0x98,0x02,0x23,0x04,0x0d
	.ascii "Density\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x14,0x0d
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x20,0x0d
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x24,0x00
	.byte 0x0c
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x7c,0xa0,0x0d
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x08,0x0d
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x0c,0x0d
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x10,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x7c,0xb1,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x10,0x00
	.byte 0x00,0x7c,0xc2,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x8a,0x10
	.byte 0x00,0x00,0x7c,0xd3,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x08,0x00,0x00,0x01,0x8a
	.byte 0x10,0x00,0x00,0x7c,0xe4,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x8a,0x10,0x00,0x00,0x7c,0xf5,0x09,0x00
	.byte 0x00,0x01,0x98,0x03,0x00,0x10
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x02,0x00,0x00,0x7e,0xb7,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7c,0xa0,0x02,0x23,0x00,0x0d
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7c,0xb1,0x02,0x23,0x10,0x0d
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7c,0xc2,0x02,0x23,0x20,0x0d
	.ascii "Position\0"
	.byte 0x00,0x00,0x7c,0xd3,0x02,0x23,0x30,0x0d
	.ascii "Direction\0"
	.byte 0x00,0x00,0x7c,0xe4,0x02,0x23,0x40,0x0d
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x50,0x0d
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x54,0x0d
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x58,0x0d
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x5c,0x0d
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x60,0x0d
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x64,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x68,0x0d
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x7e,0xb7,0x02,0x23,0x6c,0x0d
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xbc,0x02,0x23,0x70,0x0d
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xcd,0x02,0x23,0x7c,0x0d
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x7e,0xde,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x7f,0x00,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x7f,0x24,0x03,0x23,0x94,0x21
	.byte 0x0d
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x7f,0x46,0x03,0x23,0xac,0x21
	.byte 0x0d
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x7f,0x68,0x03,0x23,0xc4,0x21
	.byte 0x0d
	.ascii "dli\0"
	.byte 0x00,0x00,0x01,0x8a,0x03,0x23,0xdc,0x21
	.byte 0x0d
	.ascii "sli\0"
	.byte 0x00,0x00,0x01,0x8a,0x03,0x23,0xe0,0x21
	.byte 0x00,0x07,0x00,0x00,0x7c,0xf5,0x08,0x00
	.byte 0x00,0x01,0x8a,0x0c,0x00,0x00,0x7e,0xcd
	.byte 0x09,0x00,0x00,0x01,0x98,0x02,0x00,0x08
	.byte 0x00,0x00,0x01,0x8a,0x0c,0x00,0x00,0x7e
	.byte 0xde,0x09,0x00,0x00,0x01,0x98,0x02,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x0c,0x00,0x00
	.byte 0x7e,0xef,0x09,0x00,0x00,0x01,0x98,0x02
	.byte 0x00,0x08,0x00,0x00,0x01,0x81,0x08,0x00
	.byte 0x00,0x7f,0x00,0x09,0x00,0x00,0x01,0x98
	.byte 0x01,0x00,0x0e,0x00,0x00,0x7e,0xef,0x10
	.byte 0x00,0x00,0x00,0x7f,0x13,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xff,0x00,0x08,0x00,0x00
	.byte 0x01,0x81,0x0c,0x00,0x00,0x7f,0x24,0x09
	.byte 0x00,0x00,0x01,0x98,0x02,0x00,0x08,0x00
	.byte 0x00,0x7f,0x13,0x18,0x00,0x00,0x7f,0x35
	.byte 0x09,0x00,0x00,0x01,0x98,0x01,0x00,0x08
	.byte 0x00,0x00,0x01,0x81,0x0c,0x00,0x00,0x7f
	.byte 0x46,0x09
	.byte 0x00,0x00,0x01,0x98,0x02,0x00,0x08,0x00
	.byte 0x00,0x7f,0x35,0x18,0x00,0x00,0x7f,0x57
	.byte 0x09,0x00,0x00,0x01,0x98,0x01,0x00,0x08
	.byte 0x00,0x00,0x01,0x81,0x0c,0x00,0x00,0x7f
	.byte 0x68,0x09,0x00,0x00,0x01,0x98,0x02,0x00
	.byte 0x08,0x00,0x00,0x7f,0x57,0x18,0x00,0x00
	.byte 0x7f,0x79,0x09,0x00,0x00,0x01,0x98,0x01
	.byte 0x00,0x0e,0x00,0x00,0x7c,0xf5,0x87,0x20
	.byte 0x00,0x00,0x7f,0x8b,0x09,0x00,0x00,0x01
	.byte 0x98,0x07,0x00,0x08,0x00,0x00,0x01,0x8a
	.byte 0x10,0x00,0x00,0x7f,0x9c,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x0c
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x02,0x00,0x00,0x7f,0xe6,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0x8b,0x02,0x23,0x00,0x0d
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x10,0x0d
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x11,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x7f,0xf7,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x10,0x00
	.byte 0x00,0x80,0x08,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x8a,0x10
	.byte 0x00,0x00,0x80,0x19,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x08,0x00,0x00,0x01,0x8a
	.byte 0x10,0x00,0x00,0x80,0x2a,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x0e,0x00,0x00,0x01
	.byte 0x8a,0x03,0x20,0x00,0x00,0x80,0x3d,0x0f
	.byte 0x00,0x00,0x01,0x98,0x00,0xc7,0x00,0x10
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x02,0x00,0x00,0x80,0xf9,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0xe6,0x02,0x23,0x00,0x0d
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7f,0xf7,0x02,0x23,0x10,0x0d
	.ascii "Specular\0"
	.byte 0x00,0x00,0x80,0x08,0x02,0x23,0x20,0x0d
	.ascii "Emission\0"
	.byte 0x00,0x00,0x80,0x19,0x02,0x23,0x30,0x0d
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x40,0x0d
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x44,0x0d
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x48,0x0d
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x4c,0x0d
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x80,0x2a,0x02,0x23,0x50,0x00
	.byte 0x0e,0x00,0x00,0x80,0x3d,0x06,0xe0,0x00
	.byte 0x00,0x81,0x0b,0x09,0x00,0x00,0x01,0x98
	.byte 0x01,0x00,0x08,0x00,0x00,0x01,0x81,0x10
	.byte 0x00,0x00,0x81,0x1c,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x08,0x00,0x00,0x81,0x0b
	.byte 0x20,0x00,0x00,0x81,0x2d,0x09,0x00,0x00
	.byte 0x01,0x98,0x01,0x00,0x10
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x02,0x00,0x00,0x82,0x4e,0x0d
	.ascii "Light\0"
	.byte 0x00,0x00,0x7f,0x79,0x02,0x23,0x00,0x0d
	.ascii "Model\0"
	.byte 0x00,0x00,0x7f,0x9c,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0d
	.ascii "Material\0"
	.byte 0x00,0x00,0x80,0xf9,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0d
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0d
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x7e,0xb7,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0d
	.ascii "Fast\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0d
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x81,0x1c,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x05,0x00,0x00,0x48,0x19
	.ascii "GLushort\0"
	.byte 0x03,0x0c
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x82,0xd6,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x01,0x0d
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x82,0x4e,0x02,0x23,0x02,0x0d
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x08,0x00
	.byte 0x0c
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x02,0x00,0x00,0x82,0xfe,0x0d
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x00,0x00
	.byte 0x0e,0x00,0x00,0x01,0x4b,0x04,0x00,0x00
	.byte 0x00,0x83,0x11,0x0f,0x00,0x00,0x01,0x98
	.byte 0x00,0xff,0x00,0x0e,0x00,0x00,0x01,0x4b
	.byte 0x04,0x00,0x00,0x00,0x83,0x24,0x0f,0x00
	.byte 0x00,0x01,0x98,0x00,0xff,0x00,0x0e,0x00
	.byte 0x00,0x01,0x8a,0x04,0x00,0x00,0x00,0x83
	.byte 0x37,0x0f,0x00,0x00,0x01,0x98,0x00,0xff
	.byte 0x00,0x0e,0x00,0x00,0x01,0x8a,0x04,0x00
	.byte 0x00,0x00,0x83,0x4a,0x0f,0x00,0x00,0x01
	.byte 0x98,0x00,0xff,0x00,0x0e,0x00,0x00,0x01
	.byte 0x8a,0x04,0x00,0x00,0x00,0x83,0x5d,0x0f
	.byte 0x00,0x00,0x01,0x98,0x00,0xff,0x00,0x0e
	.byte 0x00,0x00,0x01,0x8a,0x04,0x00,0x00,0x00
	.byte 0x83,0x70,0x0f,0x00,0x00,0x01,0x98,0x00
	.byte 0xff,0x00,0x0e,0x00,0x00,0x01,0x8a,0x04
	.byte 0x00,0x00,0x00,0x83,0x83,0x0f,0x00,0x00
	.byte 0x01,0x98,0x00,0xff,0x00,0x0e,0x00,0x00
	.byte 0x01,0x8a,0x04,0x00,0x00,0x00,0x83,0x96
	.byte 0x0f,0x00,0x00,0x01,0x98,0x00,0xff,0x00
	.byte 0x0e,0x00,0x00,0x01,0x8a,0x04,0x00,0x00
	.byte 0x00,0x83,0xa9,0x0f,0x00,0x00,0x01,0x98
	.byte 0x00,0xff,0x00,0x0e,0x00,0x00,0x01,0x8a
	.byte 0x04,0x00,0x00,0x00,0x83,0xbc,0x0f,0x00
	.byte 0x00,0x01,0x98,0x00,0xff,0x00,0x10
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x02,0x00,0x00,0x86,0x7b,0x0d
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x04,0x0d
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x08,0x0d
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x0c,0x0d
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x10,0x0d
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x14,0x0d
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x20,0x0d
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x24,0x0d
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x28,0x0d
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x2c,0x0d
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x30,0x0d
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x34,0x0d
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x35,0x0d
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x38,0x0d
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x3c,0x0d
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x40,0x0d
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x44,0x0d
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x48,0x0d
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x4c,0x0d
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x50,0x0d
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x54,0x0d
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x58,0x0d
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x5c,0x0d
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x60,0x0d
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x64,0x0d
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x82,0xfe,0x02,0x23,0x68,0x0d
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x83,0x11,0x03,0x23,0xe8,0x08
	.byte 0x0d
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x83,0x24,0x03,0x23,0xe8,0x10
	.byte 0x0d
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x83,0x37,0x03,0x23,0xe8,0x18
	.byte 0x0d
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x83,0x4a,0x03,0x23,0xe8,0x20
	.byte 0x0d
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x83,0x5d,0x03,0x23,0xe8,0x28
	.byte 0x0d
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x83,0x70,0x03,0x23,0xe8,0x30
	.byte 0x0d
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x83,0x83,0x03,0x23,0xe8,0x38
	.byte 0x0d
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x83,0x96,0x03,0x23,0xe8,0x40
	.byte 0x0d
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x83,0xa9,0x03,0x23,0xe8,0x48
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x0c,0x00
	.byte 0x00,0x86,0x8c,0x09,0x00,0x00,0x01,0x98
	.byte 0x02,0x00,0x0c
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x02,0x00,0x00,0x87,0x05,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "Size\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x04,0x0d
	.ascii "Params\0"
	.byte 0x00,0x00,0x86,0x7b,0x02,0x23,0x08,0x0d
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x14,0x0d
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x00
	.byte 0x0c
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x88,0x38,0x0d
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x08,0x0d
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0c,0x0d
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x0d,0x0d
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x10,0x0d
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x14,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x18,0x0d
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x19,0x0d
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x20,0x0d
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x24,0x0d
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x25,0x0d
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x26,0x0d
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x27,0x00
	.byte 0x08,0x00,0x00,0x01,0x74,0x80,0x00,0x00
	.byte 0x88,0x49,0x09,0x00,0x00,0x01,0x98,0x1f
	.byte 0x00,0x05,0x00,0x00,0x01,0x44
	.ascii "GLsizei\0"
	.byte 0x03,0x0c
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x88,0xb2,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x08,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x0c,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x10,0x00
	.byte 0x0c
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x02,0x00,0x00,0x89,0x60,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x00,0x0d
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x08,0x0d
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x0c,0x0d
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x10,0x0d
	.ascii "Ref\0"
	.byte 0x00,0x00,0x65,0xbb,0x02,0x23,0x14,0x0d
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x65,0xbb,0x02,0x23,0x15,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x65,0xbb,0x02,0x23,0x16,0x0d
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x65,0xbb,0x02,0x23,0x17,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x89,0x71,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x8a,0x10,0x00
	.byte 0x00,0x89,0x82,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x8a,0x10
	.byte 0x00,0x00,0x89,0x93,0x09,0x00,0x00,0x01
	.byte 0x98,0x03,0x00,0x08,0x00,0x00,0x01,0x8a
	.byte 0x10,0x00,0x00,0x89,0xa4,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x8a,0x10,0x00,0x00,0x89,0xb5,0x09,0x00
	.byte 0x00,0x01,0x98,0x03,0x00,0x08,0x00,0x00
	.byte 0x01,0x8a,0x10,0x00,0x00,0x89,0xc6,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x08,0x00
	.byte 0x00,0x01,0x8a,0x10,0x00,0x00,0x89,0xd7
	.byte 0x09,0x00,0x00,0x01,0x98,0x03,0x00,0x08
	.byte 0x00,0x00,0x01,0x8a,0x10,0x00,0x00,0x89
	.byte 0xe8,0x09,0x00,0x00,0x01,0x98,0x03,0x00
	.byte 0x08,0x00,0x00,0x01,0x8a,0x10,0x00,0x00
	.byte 0x89,0xf9,0x09,0x00,0x00,0x01,0x98,0x03
	.byte 0x00,0x0e,0x00,0x00,0x31,0x6b,0x04,0x00
	.byte 0x00,0x00,0x8a,0x0c,0x0f,0x00,0x00,0x01
	.byte 0x98,0x03,0xff,0x00,0x10
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x02,0x00,0x00,0x8c,0x3b,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x00,0x0d
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x89,0x60,0x02,0x23,0x08,0x0d
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x18,0x0d
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x1c,0x0d
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x20,0x0d
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x24,0x0d
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x28,0x0d
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x89,0x71,0x02,0x23,0x2c,0x0d
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x89,0x82,0x02,0x23,0x3c,0x0d
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x89,0x93,0x02,0x23,0x4c,0x0d
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x89,0xa4,0x02,0x23,0x5c,0x0d
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x89,0xb5,0x02,0x23,0x6c,0x0d
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x89,0xc6,0x02,0x23,0x7c,0x0d
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x89,0xd7,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x89,0xe8,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "Current\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x34,0xea,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "Palette\0"
	.byte 0x00,0x00,0x89,0xf9,0x03,0x23,0xc9,0x01
	.byte 0x0d
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x74,0x03,0x23,0xcc,0x09
	.byte 0x0d
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x4d,0x03,0x23,0xd0,0x09
	.byte 0x0d
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x4d,0x03,0x23,0xd4,0x09
	.byte 0x00,0x08,0x00,0x00,0x01,0x81,0x10,0x00
	.byte 0x00,0x8c,0x4c,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x08,0x00,0x00,0x8c,0x3b,0x60
	.byte 0x00,0x00,0x8c,0x5d,0x09,0x00,0x00,0x01
	.byte 0x98,0x05,0x00,0x08,0x00,0x00,0x32,0xbd
	.byte 0x06,0x00,0x00,0x8c,0x6e,0x09,0x00,0x00
	.byte 0x01,0x98,0x05,0x00,0x0c
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x02,0x00,0x00,0x8c,0xe8,0x0d
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x8c,0x4c,0x02,0x23,0x04,0x0d
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x8c,0x5d,0x02,0x23,0x64,0x0d
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x6a,0x0d
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x6b,0x00
	.byte 0x0c
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x02,0x00,0x00,0x8d,0x8f,0x0d
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x08,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x0c,0x0d
	.ascii "Near\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x10,0x0d
	.ascii "Far\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x14,0x0d
	.ascii "Sx\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x18,0x0d
	.ascii "Sy\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x1c,0x0d
	.ascii "Sz\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x20,0x0d
	.ascii "Tx\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x24,0x0d
	.ascii "Ty\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x28,0x0d
	.ascii "Tz\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x2c,0x00
	.byte 0x08,0x00,0x00,0x75,0x2f,0x40,0x00,0x00
	.byte 0x8d,0xa0,0x09,0x00,0x00,0x01,0x98,0x0f
	.byte 0x00,0x07,0x00,0x00,0x32,0xbd,0x0c
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x02,0x00,0x00,0x90,0x50,0x0d
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x04,0x0d
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x08,0x0d
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x0c,0x0d
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x10,0x0d
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x14,0x0d
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x18,0x0d
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x1c,0x0d
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x20,0x0d
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x24,0x0d
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x28,0x0d
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x2c,0x0d
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x30,0x0d
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x34,0x0d
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x38,0x0d
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x3c,0x0d
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x40,0x0d
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x44,0x0d
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x48,0x0d
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x4c,0x0d
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x50,0x0d
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x54,0x0d
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x58,0x0d
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x5c,0x0d
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x60,0x0d
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x64,0x0d
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x31,0x86,0x02,0x23,0x68,0x0d
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x6c,0x0d
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x70,0x0d
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x88,0x49,0x02,0x23,0x74,0x0d
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x8d,0xa0,0x02,0x23,0x78,0x0d
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x7c,0x00
	.byte 0x0c
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x02,0x00,0x00,0x90,0xff,0x0d
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x00,0x0d
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x04,0x0d
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x08,0x0d
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x0c,0x0d
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x10,0x0d
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0x4b,0x02,0x23,0x14,0x0d
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x18,0x0d
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x19,0x00
	.byte 0x07,0x00,0x00,0x01,0x8a,0x0c
	.ascii "gl_1d_map\0"
	.byte 0x14,0x02,0x00,0x00,0x91,0x58,0x0d
	.ascii "Order\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x00,0x0d
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x04,0x0d
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x08,0x0d
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xff,0x02,0x23,0x0c,0x0d
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x10,0x00
	.byte 0x0c
	.ascii "gl_2d_map\0"
	.byte 0x20,0x02,0x00,0x00,0x91,0xd2,0x0d
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x00,0x0d
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x04,0x0d
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x08,0x0d
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x0c,0x0d
	.ascii "v1\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x10,0x0d
	.ascii "v2\0"
	.byte 0x00,0x00,0x01,0x8a,0x02,0x23,0x14,0x0d
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xff,0x02,0x23,0x18,0x0d
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xbd,0x02,0x23,0x1c,0x00
	.byte 0x10
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x02,0x00,0x00,0x93,0x5c,0x0d
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x00,0x0d
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x14,0x0d
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x28,0x0d
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x3c,0x0d
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x50,0x0d
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x64,0x0d
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x91,0x04,0x02,0x23,0x78,0x0d
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x91,0x04,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x91,0x04,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xd4,0x01
	.byte 0x0d
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xf4,0x01
	.byte 0x0d
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xb4,0x02
	.byte 0x0d
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xd4,0x02
	.byte 0x0d
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xf4,0x02
	.byte 0x0d
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0x94,0x03
	.byte 0x0d
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x91,0x58,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0c
	.ascii "gl_feedback\0"
	.byte 0x14,0x02,0x00,0x00,0x93,0xba,0x0d
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x4d,0x02,0x23,0x00,0x0d
	.ascii "Mask\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x04,0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x90,0xff,0x02,0x23,0x08,0x0d
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x0c,0x0d
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x10,0x00
	.byte 0x07,0x00,0x00,0x01,0x74,0x0e,0x00,0x00
	.byte 0x01,0x74,0x01,0x00,0x00,0x00,0x93,0xd1
	.byte 0x09,0x00,0x00,0x01,0x98,0x3f,0x00,0x10
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x02,0x00,0x00,0x94,0x86,0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x93,0xba,0x02,0x23,0x00,0x0d
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x04,0x0d
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x08,0x0d
	.ascii "Hits\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x0c,0x0d
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x01,0x74,0x02,0x23,0x10,0x0d
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x93,0xbf,0x02,0x23,0x14,0x0d
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x32,0xbd,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x01,0x8a,0x03,0x23,0x98,0x02
	.byte 0x0d
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x01,0x8a,0x03,0x23,0x9c,0x02
	.byte 0x00,0x08,0x00,0x00,0x01,0x81,0x10,0x00
	.byte 0x00,0x94,0x97,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x0e,0x00,0x00,0x94,0x86,0x1f
	.byte 0x80,0x00,0x00,0x94,0xaa,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xf7,0x00,0x08,0x00,0x00
	.byte 0x01,0x81,0x10,0x00,0x00,0x94,0xbb,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x0e,0x00
	.byte 0x00,0x94,0xaa,0x1f,0x80,0x00,0x00,0x94
	.byte 0xce,0x0f,0x00,0x00,0x01,0x98,0x01,0xf7
	.byte 0x00,0x08,0x00,0x00,0x01,0x81,0x10,0x00
	.byte 0x00,0x94,0xdf,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x0e,0x00,0x00,0x94,0xce,0x1f
	.byte 0x80,0x00,0x00,0x94,0xf2,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xf7,0x00,0x08,0x00,0x00
	.byte 0x01,0x81,0x0c,0x00,0x00,0x95,0x03,0x09
	.byte 0x00,0x00,0x01,0x98,0x02,0x00,0x0e,0x00
	.byte 0x00,0x94,0xf2,0x17,0xa0,0x00,0x00,0x95
	.byte 0x16,0x0f,0x00,0x00,0x01,0x98,0x01,0xf7
	.byte 0x00,0x08,0x00,0x00,0x01,0x81,0x0c,0x00
	.byte 0x00,0x95,0x27,0x09,0x00,0x00,0x01,0x98
	.byte 0x02,0x00,0x0e,0x00,0x00,0x95,0x16,0x17
	.byte 0xa0,0x00,0x00,0x95,0x3a,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xf7,0x00,0x08,0x00,0x00
	.byte 0x31,0x5a,0x04,0x00,0x00,0x95,0x4b,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x0e,0x00
	.byte 0x00,0x95,0x3a,0x07,0xe0,0x00,0x00,0x95
	.byte 0x5e,0x0f,0x00,0x00,0x01,0x98,0x01,0xf7
	.byte 0x00,0x08,0x00,0x00,0x31,0x5a,0x04,0x00
	.byte 0x00,0x95,0x6f,0x09,0x00,0x00,0x01,0x98
	.byte 0x03,0x00,0x0e,0x00,0x00,0x95,0x5e,0x07
	.byte 0xe0,0x00,0x00,0x95,0x82,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xf7,0x00,0x08,0x00,0x00
	.byte 0x31,0x5a,0x04,0x00,0x00,0x95,0x93,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x07,0x00
	.byte 0x00,0x95,0x82,0x0e,0x00,0x00,0x01,0x74
	.byte 0x07,0xe0,0x00,0x00,0x95,0xab,0x0f,0x00
	.byte 0x00,0x01,0x98,0x01,0xf7,0x00,0x0e,0x00
	.byte 0x00,0x01,0x74,0x07,0xe0,0x00,0x00,0x95
	.byte 0xbe,0x0f,0x00,0x00,0x01,0x98,0x01,0xf7
	.byte 0x00,0x0e,0x00,0x00,0x32,0xbd,0x01,0xf8
	.byte 0x00,0x00,0x95,0xd1,0x0f,0x00,0x00,0x01
	.byte 0x98,0x01,0xf7,0x00,0x08,0x00,0x00,0x01
	.byte 0x81,0x10,0x00,0x00,0x95,0xe2,0x09,0x00
	.byte 0x00,0x01,0x98,0x03,0x00,0x0e,0x00,0x00
	.byte 0x95,0xd1,0x1f,0x80,0x00,0x00,0x95,0xf5
	.byte 0x0f,0x00,0x00,0x01,0x98,0x01,0xf7,0x00
	.byte 0x0e,0x00,0x00,0x31,0x6b,0x01,0xf8,0x00
	.byte 0x00,0x96,0x08,0x0f,0x00,0x00,0x01,0x98
	.byte 0x01,0xf7,0x00,0x0e,0x00,0x00,0x01,0x74
	.byte 0x07,0xe0,0x00,0x00,0x96,0x1b,0x0f,0x00
	.byte 0x00,0x01,0x98,0x01,0xf7,0x00,0x0e,0x00
	.byte 0x00,0x80,0x3d,0x06,0xe0,0x00,0x00,0x96
	.byte 0x2d,0x09,0x00,0x00,0x01,0x98,0x01,0x00
	.byte 0x16,0x00,0x00,0x96,0x1b,0x00,0x0d,0x89
	.byte 0x00,0x00,0x00,0x96,0x42,0x0f,0x00,0x00
	.byte 0x01,0x98,0x01,0xf7,0x00,0x17
	.ascii "vertex_buffer\0"
	.byte 0x00,0x0e,0x61,0xb4,0x05,0x00,0x00,0x98
	.byte 0x32,0x0d
	.ascii "Obj\0"
	.byte 0x00,0x00,0x94,0x97,0x02,0x23,0x00,0x0d
	.ascii "Eye\0"
	.byte 0x00,0x00,0x94,0xbb,0x03,0x23,0x80,0x3f
	.byte 0x0d
	.ascii "Clip\0"
	.byte 0x00,0x00,0x94,0xdf,0x03,0x23,0x80,0x7e
	.byte 0x0d
	.ascii "Win\0"
	.byte 0x00,0x00,0x95,0x03,0x04,0x23,0x80,0xbd
	.byte 0x01,0x0d
	.ascii "Normal\0"
	.byte 0x00,0x00,0x95,0x27,0x04,0x23,0xa0,0xec
	.byte 0x01,0x0d
	.ascii "Fcolor\0"
	.byte 0x00,0x00,0x95,0x4b,0x04,0x23,0xc0,0x9b
	.byte 0x02,0x0d
	.ascii "Bcolor\0"
	.byte 0x00,0x00,0x95,0x6f,0x04,0x23,0xa0,0xab
	.byte 0x02,0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x95,0x93,0x04,0x23,0x80,0xbb
	.byte 0x02,0x0d
	.ascii "Findex\0"
	.byte 0x00,0x00,0x95,0x98,0x04,0x23,0x84,0xbb
	.byte 0x02,0x0d
	.ascii "Bindex\0"
	.byte 0x00,0x00,0x95,0xab,0x04,0x23,0xe4,0xca
	.byte 0x02,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x93,0xba,0x04,0x23,0xc4,0xda
	.byte 0x02,0x0d
	.ascii "Edgeflag\0"
	.byte 0x00,0x00,0x95,0xbe,0x04,0x23,0xc8,0xda
	.byte 0x02,0x0d
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x95,0xe2,0x04,0x23,0xc0,0xde
	.byte 0x02,0x0d
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x95,0xf5,0x04,0x23,0xc0,0x9d
	.byte 0x03,0x0d
	.ascii "ClipOrMask\0"
	.byte 0x00,0x00,0x31,0x6b,0x04,0x23,0xb8,0xa1
	.byte 0x03,0x0d
	.ascii "ClipAndMask\0"
	.byte 0x00,0x00,0x31,0x6b,0x04,0x23,0xb9,0xa1
	.byte 0x03,0x0d
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xbc,0xa1
	.byte 0x03,0x0d
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xc0,0xa1
	.byte 0x03,0x0d
	.ascii "Free\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xc4,0xa1
	.byte 0x03,0x0d
	.ascii "VertexSizeMask\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xc8,0xa1
	.byte 0x03,0x0d
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0xcc,0xa1
	.byte 0x03,0x0d
	.ascii "MonoColor\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xd0,0xa1
	.byte 0x03,0x0d
	.ascii "MonoNormal\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xd1,0xa1
	.byte 0x03,0x0d
	.ascii "MonoMaterial\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0xd2,0xa1
	.byte 0x03,0x0d
	.ascii "MaterialMask\0"
	.byte 0x00,0x00,0x96,0x08,0x04,0x23,0xd4,0xa1
	.byte 0x03,0x0d
	.ascii "Material\0"
	.byte 0x00,0x00,0x96,0x2d,0x04,0x23,0xb4,0xb1
	.byte 0x03,0x00,0x07,0x00,0x00,0x96,0x42,0x0e
	.byte 0x00,0x00,0x01,0x4b,0x4b,0x00,0x00,0x00
	.byte 0x98,0x4a,0x0f,0x00,0x00,0x01,0x98,0x12
	.byte 0xbf,0x00,0x0e,0x00,0x00,0x01,0x4b,0x4b
	.byte 0x00,0x00,0x00,0x98,0x5d,0x0f,0x00,0x00
	.byte 0x01,0x98,0x12,0xbf,0x00,0x0e,0x00,0x00
	.byte 0x65,0xa8,0x25,0x80,0x00,0x00,0x98,0x70
	.byte 0x0f,0x00,0x00,0x01,0x98,0x12,0xbf,0x00
	.byte 0x0e,0x00,0x00,0x31,0x6b,0x12,0xc0,0x00
	.byte 0x00,0x98,0x83,0x0f,0x00,0x00,0x01,0x98
	.byte 0x12,0xbf,0x00,0x0e,0x00,0x00,0x31,0x6b
	.byte 0x12,0xc0,0x00,0x00,0x98,0x96,0x0f,0x00
	.byte 0x00,0x01,0x98,0x12,0xbf,0x00,0x0e,0x00
	.byte 0x00,0x31,0x6b,0x12,0xc0,0x00,0x00,0x98
	.byte 0xa9,0x0f,0x00,0x00,0x01,0x98,0x12,0xbf
	.byte 0x00,0x0e,0x00,0x00,0x31,0x6b,0x12,0xc0
	.byte 0x00,0x00,0x98,0xbc,0x0f,0x00,0x00,0x01
	.byte 0x98,0x12,0xbf,0x00,0x0e,0x00,0x00,0x01
	.byte 0x74,0x4b,0x00,0x00,0x00,0x98,0xcf,0x0f
	.byte 0x00,0x00,0x01,0x98,0x12,0xbf,0x00,0x0e
	.byte 0x00,0x00,0x01,0x8a,0x4b,0x00,0x00,0x00
	.byte 0x98,0xe2,0x0f,0x00,0x00,0x01,0x98,0x12
	.byte 0xbf,0x00,0x0e,0x00,0x00,0x01,0x8a,0x4b
	.byte 0x00,0x00,0x00,0x98,0xf5,0x0f,0x00,0x00
	.byte 0x01,0x98,0x12,0xbf,0x00,0x0e,0x00,0x00
	.byte 0x01,0x8a,0x4b,0x00,0x00,0x00,0x99,0x08
	.byte 0x0f,0x00,0x00,0x01,0x98,0x12,0xbf,0x00
	.byte 0x0e,0x00,0x00,0x01,0x8a,0x4b,0x00,0x00
	.byte 0x00,0x99,0x1b,0x0f,0x00,0x00,0x01,0x98
	.byte 0x12,0xbf,0x00,0x08,0x00,0x00,0x01,0x4b
	.byte 0x10,0x00,0x00,0x99,0x2c,0x09,0x00,0x00
	.byte 0x01,0x98,0x03,0x00,0x17
	.ascii "pixel_buffer\0"
	.byte 0x00,0x02,0x7d,0xa0,0x06,0x00,0x00,0x9a
	.byte 0x2a,0x0d
	.ascii "x\0"
	.byte 0x00,0x00,0x98,0x37,0x02,0x23,0x00,0x0d
	.ascii "y\0"
	.byte 0x00,0x00,0x98,0x4a,0x04,0x23,0x80,0x96
	.byte 0x01,0x0d
	.ascii "z\0"
	.byte 0x00,0x00,0x98,0x5d,0x04,0x23,0x80,0xac
	.byte 0x02,0x0d
	.ascii "r\0"
	.byte 0x00,0x00,0x98,0x70,0x04,0x23,0x80,0xf7
	.byte 0x02,0x0d
	.ascii "g\0"
	.byte 0x00,0x00,0x98,0x83,0x04,0x23,0xc0,0x9c
	.byte 0x03,0x0d
	.ascii "b\0"
	.byte 0x00,0x00,0x98,0x96,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0d
	.ascii "a\0"
	.byte 0x00,0x00,0x98,0xa9,0x04,0x23,0xc0,0xe7
	.byte 0x03,0x0d
	.ascii "i\0"
	.byte 0x00,0x00,0x98,0xbc,0x04,0x23,0x80,0x8d
	.byte 0x04,0x0d
	.ascii "s\0"
	.byte 0x00,0x00,0x98,0xcf,0x04,0x23,0x80,0xa3
	.byte 0x05,0x0d
	.ascii "t\0"
	.byte 0x00,0x00,0x98,0xe2,0x04,0x23,0x80,0xb9
	.byte 0x06,0x0d
	.ascii "u\0"
	.byte 0x00,0x00,0x98,0xf5,0x04,0x23,0x80,0xcf
	.byte 0x07,0x0d
	.ascii "lambda\0"
	.byte 0x00,0x00,0x99,0x08,0x04,0x23,0x80,0xe5
	.byte 0x08,0x0d
	.ascii "color\0"
	.byte 0x00,0x00,0x99,0x1b,0x04,0x23,0x80,0xfb
	.byte 0x09,0x0d
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0x90,0xfb
	.byte 0x09,0x0d
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x74,0x04,0x23,0x94,0xfb
	.byte 0x09,0x0d
	.ascii "mono\0"
	.byte 0x00,0x00,0x32,0xbd,0x04,0x23,0x98,0xfb
	.byte 0x09,0x0d
	.ascii "primitive\0"
	.byte 0x00,0x00,0x31,0x4d,0x04,0x23,0x9c,0xfb
	.byte 0x09,0x00,0x07,0x00,0x00,0x99,0x2c,0x05
	.byte 0x00,0x00,0x35,0x90
	.ascii "GLcontext\0"
	.byte 0x02,0x07,0x00,0x00,0x9a,0x2f,0x02
	.ascii "gl_LineStipple\0"
	.byte 0x01,0x02,0x01,0x75
	.uaword gl_LineStipple
	.uaword .L71
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9a,0x9d
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x74,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x4b
	.ascii "factor\0"
	.byte 0x01,0x74,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x82,0x4e
	.ascii "pattern\0"
	.byte 0x01,0x74,0x03,0x91,0xce,0x00,0x00,0x18
	.ascii "feedback_line\0"
	.byte 0x03,0x01,0x98
	.uaword feedback_line
	.uaword .L148
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9c,0x2a
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x97,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "v1\0"
	.byte 0x01,0x97,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "v2\0"
	.byte 0x01,0x97,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "pv\0"
	.byte 0x01,0x97,0x03,0x91,0xd0,0x00,0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x01,0x99,0x02
	.byte 0x91,0x7c,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9a,0x02
	.byte 0x91,0x78,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9a,0x02
	.byte 0x91,0x74,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9a,0x02
	.byte 0x91,0x70,0x19
	.ascii "w1\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9a,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x2\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9b,0x02
	.byte 0x91,0x68,0x19
	.ascii "y2\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9b,0x02
	.byte 0x91,0x64,0x19
	.ascii "z2\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9b,0x02
	.byte 0x91,0x60,0x19
	.ascii "w2\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9b,0x02
	.byte 0x91,0x5c,0x19
	.ascii "tex1\0"
	.byte 0x00,0x00,0x9c,0x2a,0x01,0x01,0x9c,0x02
	.byte 0x91,0x4c,0x19
	.ascii "tex2\0"
	.byte 0x00,0x00,0x9c,0x3b,0x01,0x01,0x9c,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "invq\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9c,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "invRedScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9d,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "invGreenScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9e,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "invBlueScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0x9f,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "invAlphaScale\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x01,0xa0,0x03
	.byte 0x91,0xa8,0x7f,0x1a
	.uaword .L138
	.uaword .L145
	.byte 0x19
	.ascii "color\0"
	.byte 0x00,0x00,0x9c,0x4c,0x01,0x01,0xbf,0x03
	.byte 0x91,0x88,0x7f,0x00,0x00,0x08,0x00,0x00
	.byte 0x01,0x8a,0x10,0x00,0x00,0x9c,0x3b,0x09
	.byte 0x00,0x00,0x01,0x98,0x03,0x00,0x08,0x00
	.byte 0x00,0x01,0x8a,0x10,0x00,0x00,0x9c,0x4c
	.byte 0x09,0x00,0x00,0x01,0x98,0x03,0x00,0x08
	.byte 0x00,0x00,0x01,0x8a,0x10,0x00,0x00,0x9c
	.byte 0x5d,0x09,0x00,0x00,0x01,0x98,0x03,0x00
	.byte 0x18
	.ascii "select_line\0"
	.byte 0x03,0x01,0xd1
	.uaword select_line
	.uaword .L157
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9c,0xb7
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0xd0,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "v1\0"
	.byte 0x01,0xd0,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "v2\0"
	.byte 0x01,0xd0,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "pv\0"
	.byte 0x01,0xd0,0x03,0x91,0xd0,0x00,0x00,0x18
	.ascii "flat_ci_line\0"
	.byte 0x03,0x01,0xe2
	.uaword flat_ci_line
	.uaword .L324
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9e,0x9a
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0xe0,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0xe1,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0xe1,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0xe1,0x03,0x91,0xd0,0x00,0x19
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0xe3,0x02
	.byte 0x91,0x7c,0x19
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0xe4,0x02
	.byte 0x91,0x78,0x19
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0xe5,0x02
	.byte 0x91,0x74,0x1a
	.uaword .L177
	.uaword .L312
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x07,0x57,0x02
	.byte 0x91,0x70,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5c,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5d,0x02
	.byte 0x91,0x64,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5e,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x60,0x02
	.byte 0x91,0x54,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x60,0x02
	.byte 0x91,0x50,0x1a
	.uaword .L228
	.uaword .L311
	.byte 0x1a
	.uaword .L232
	.uaword .L270
	.byte 0x1a
	.uaword .L233
	.uaword .L269
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0xfc,0x02
	.byte 0x91,0x4c,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0xfd,0x02
	.byte 0x91,0x48,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0xfe,0x02
	.byte 0x91,0x44,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0xff,0x02
	.byte 0x91,0x40,0x00,0x00,0x1a
	.uaword .L272
	.uaword .L310
	.byte 0x1a
	.uaword .L273
	.uaword .L309
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x01,0x77
	.byte 0x02,0x91,0x4c,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x01,0x78
	.byte 0x02,0x91,0x48,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x01,0x79
	.byte 0x02,0x91,0x44,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x07,0x01,0x7a
	.byte 0x02,0x91,0x40,0x00,0x00,0x00,0x00,0x00
	.byte 0x07,0x00,0x00,0x01,0x4b,0x18
	.ascii "flat_ci_z_line\0"
	.byte 0x03,0x01,0xfb
	.uaword flat_ci_z_line
	.uaword .L509
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa1,0x5c
	.byte 0x03,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0xf9,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0xfa,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0xfa,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0xfa,0x03,0x91,0xd0,0x00,0x19
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0xfc,0x02
	.byte 0x91,0x7c,0x19
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0xfd,0x02
	.byte 0x91,0x78,0x19
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0xfe,0x02
	.byte 0x91,0x74,0x19
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0xff,0x02
	.byte 0x91,0x70,0x1a
	.uaword .L345
	.uaword .L497
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x08,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x63,0x02
	.byte 0x91,0x48,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x08,0x64,0x03
	.byte 0x91,0xb4,0x7f,0x1a
	.uaword .L403
	.uaword .L496
	.byte 0x1a
	.uaword .L407
	.uaword .L450
	.byte 0x1a
	.uaword .L408
	.uaword .L449
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0xfc,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0xfd,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0xfe,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0xff,0x03
	.byte 0x91,0xa4,0x7f,0x1a
	.uaword .L413
	.uaword .L448
	.byte 0x1a
	.uaword .L419
	.uaword .L445
	.byte 0x1a
	.uaword .L420
	.uaword .L444
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x08,0x01,0x26
	.byte 0x03,0x91,0xa2,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L452
	.uaword .L495
	.byte 0x1a
	.uaword .L453
	.uaword .L494
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x01,0x77
	.byte 0x03,0x91,0xb0,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x01,0x78
	.byte 0x03,0x91,0xac,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x01,0x79
	.byte 0x03,0x91,0xa8,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x08,0x01,0x7a
	.byte 0x03,0x91,0xa4,0x7f,0x1a
	.uaword .L458
	.uaword .L493
	.byte 0x1a
	.uaword .L464
	.uaword .L490
	.byte 0x1a
	.uaword .L465
	.uaword .L489
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x08,0x01,0xa1
	.byte 0x03,0x91,0xa2,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1c
	.ascii "flat_rgba_line\0"
	.byte 0x03,0x01,0x01,0x17
	.uaword flat_rgba_line
	.uaword .L680
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa3,0x5d
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0x15,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0x16,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0x16,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0x16,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0x18
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x19
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x1a
	.byte 0x02,0x91,0x74,0x1b
	.ascii "color\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x1b
	.byte 0x02,0x91,0x70,0x1a
	.uaword .L533
	.uaword .L668
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x09,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x60,0x02
	.byte 0x91,0x4c,0x1a
	.uaword .L584
	.uaword .L667
	.byte 0x1a
	.uaword .L588
	.uaword .L626
	.byte 0x1a
	.uaword .L589
	.uaword .L625
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0xfc,0x02
	.byte 0x91,0x48,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0xfd,0x02
	.byte 0x91,0x44,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0xfe,0x02
	.byte 0x91,0x40,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0xff,0x03
	.byte 0x91,0xbc,0x7f,0x00,0x00,0x1a
	.uaword .L628
	.uaword .L666
	.byte 0x1a
	.uaword .L629
	.uaword .L665
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x01,0x77
	.byte 0x02,0x91,0x48,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x01,0x78
	.byte 0x02,0x91,0x44,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x01,0x79
	.byte 0x02,0x91,0x40,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x09,0x01,0x7a
	.byte 0x03,0x91,0xbc,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1c
	.ascii "flat_rgba_z_line\0"
	.byte 0x03,0x01,0x01,0x31
	.uaword flat_rgba_z_line
	.uaword .L869
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa6,0x38
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0x2f,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0x30,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0x30,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0x30,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0x32
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x33
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x34
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x01,0x35
	.byte 0x02,0x91,0x70,0x1b
	.ascii "color\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x36
	.byte 0x02,0x91,0x6c,0x1a
	.uaword .L705
	.uaword .L857
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x0a,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x0a,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x1a
	.uaword .L763
	.uaword .L856
	.byte 0x1a
	.uaword .L767
	.uaword .L810
	.byte 0x1a
	.uaword .L768
	.uaword .L809
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0xfc,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0xfd,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0xfe,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0xff,0x03
	.byte 0x91,0xa0,0x7f,0x1a
	.uaword .L773
	.uaword .L808
	.byte 0x1a
	.uaword .L779
	.uaword .L805
	.byte 0x1a
	.uaword .L780
	.uaword .L804
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0a,0x01,0x26
	.byte 0x03,0x91,0x9e,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L812
	.uaword .L855
	.byte 0x1a
	.uaword .L813
	.uaword .L854
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x01,0x77
	.byte 0x03,0x91,0xac,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x01,0x78
	.byte 0x03,0x91,0xa8,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x01,0x79
	.byte 0x03,0x91,0xa4,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0a,0x01,0x7a
	.byte 0x03,0x91,0xa0,0x7f,0x1a
	.uaword .L818
	.uaword .L853
	.byte 0x1a
	.uaword .L824
	.uaword .L850
	.byte 0x1a
	.uaword .L825
	.uaword .L849
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0a,0x01,0xa1
	.byte 0x03,0x91,0x9e,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1c
	.ascii "smooth_ci_line\0"
	.byte 0x03,0x01,0x01,0x4e
	.uaword smooth_ci_line
	.uaword .L1033
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa8,0xb1
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0x4c,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0x4d,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0x4d,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0x4d,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0x4f
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x50
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x51
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbi\0"
	.byte 0x00,0x00,0x93,0xba,0x01,0x01,0x01,0x52
	.byte 0x02,0x91,0x70,0x1a
	.uaword .L879
	.uaword .L1021
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x0b,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "i0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x73,0x02
	.byte 0x91,0x48,0x19
	.ascii "di\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x73,0x02
	.byte 0x91,0x44,0x1a
	.uaword .L931
	.uaword .L1020
	.byte 0x1a
	.uaword .L935
	.uaword .L976
	.byte 0x1a
	.uaword .L936
	.uaword .L975
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0xfc,0x02
	.byte 0x91,0x40,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0xfd,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0xfe,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0xff,0x03
	.byte 0x91,0xb4,0x7f,0x1a
	.uaword .L941
	.uaword .L974
	.byte 0x1a
	.uaword .L947
	.uaword .L971
	.byte 0x1a
	.uaword .L948
	.uaword .L970
	.byte 0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0x2c
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L978
	.uaword .L1019
	.byte 0x1a
	.uaword .L979
	.uaword .L1018
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0x77
	.byte 0x02,0x91,0x40,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0x78
	.byte 0x03,0x91,0xbc,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0x79
	.byte 0x03,0x91,0xb8,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0x7a
	.byte 0x03,0x91,0xb4,0x7f,0x1a
	.uaword .L984
	.uaword .L1017
	.byte 0x1a
	.uaword .L990
	.uaword .L1014
	.byte 0x1a
	.uaword .L991
	.uaword .L1013
	.byte 0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0b,0x01,0xa7
	.byte 0x03,0x91,0xb0,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1c
	.ascii "smooth_ci_z_line\0"
	.byte 0x03,0x01,0x01,0x68
	.uaword smooth_ci_z_line
	.uaword .L1215
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xab,0xc6
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0x66,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0x67,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0x67,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0x67,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0x69
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x6a
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x6b
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x01,0x6c
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbi\0"
	.byte 0x00,0x00,0x93,0xba,0x01,0x01,0x01,0x6d
	.byte 0x02,0x91,0x6c,0x1a
	.uaword .L1044
	.uaword .L1203
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x0c,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x0c,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "i0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x73,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "di\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x73,0x03
	.byte 0x91,0xa8,0x7f,0x1a
	.uaword .L1103
	.uaword .L1202
	.byte 0x1a
	.uaword .L1107
	.uaword .L1153
	.byte 0x1a
	.uaword .L1108
	.uaword .L1152
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0xfc,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0xfd,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0xfe,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0xff,0x03
	.byte 0x91,0x98,0x7f,0x1a
	.uaword .L1114
	.uaword .L1151
	.byte 0x1a
	.uaword .L1120
	.uaword .L1148
	.byte 0x1a
	.uaword .L1121
	.uaword .L1147
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0c,0x01,0x26
	.byte 0x03,0x91,0x96,0x7f,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0x2c
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L1155
	.uaword .L1201
	.byte 0x1a
	.uaword .L1156
	.uaword .L1200
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0x77
	.byte 0x03,0x91,0xa4,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0x78
	.byte 0x03,0x91,0xa0,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0x79
	.byte 0x03,0x91,0x9c,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0x7a
	.byte 0x03,0x91,0x98,0x7f,0x1a
	.uaword .L1162
	.uaword .L1199
	.byte 0x1a
	.uaword .L1168
	.uaword .L1196
	.byte 0x1a
	.uaword .L1169
	.uaword .L1195
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0c,0x01,0xa1
	.byte 0x03,0x91,0x96,0x7f,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0c,0x01,0xa7
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1c
	.ascii "smooth_rgba_line\0"
	.byte 0x03,0x01,0x01,0x85
	.uaword smooth_rgba_line
	.uaword .L1399
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xae,0x75
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0x83,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0x84,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0x84,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0x84,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0x86
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x87
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0x88
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbr\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x89
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbg\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x8a
	.byte 0x02,0x91,0x6c,0x1b
	.ascii "pbb\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x8b
	.byte 0x02,0x91,0x68,0x1b
	.ascii "pba\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0x8c
	.byte 0x02,0x91,0x64,0x1a
	.uaword .L1228
	.uaword .L1387
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x0d,0x57,0x02
	.byte 0x91,0x60,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5c,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5d,0x02
	.byte 0x91,0x54,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5e,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x60,0x02
	.byte 0x91,0x44,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x67,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x68,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x69,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x6a,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x6b,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x6c,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x6f,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0d,0x70,0x03
	.byte 0x91,0xa0,0x7f,0x1a
	.uaword .L1287
	.uaword .L1386
	.byte 0x1a
	.uaword .L1291
	.uaword .L1337
	.byte 0x1a
	.uaword .L1292
	.uaword .L1336
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0xfc,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0xfd,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0xfe,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0xff,0x03
	.byte 0x91,0x90,0x7f,0x00,0x00,0x1a
	.uaword .L1339
	.uaword .L1385
	.byte 0x1a
	.uaword .L1340
	.uaword .L1384
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x01,0x77
	.byte 0x03,0x91,0x9c,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x01,0x78
	.byte 0x03,0x91,0x98,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x01,0x79
	.byte 0x03,0x91,0x94,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0d,0x01,0x7a
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x05,0x00,0x00,0x01,0x44
	.ascii "GLfixed\0"
	.byte 0x0e,0x1c
	.ascii "smooth_rgba_z_line\0"
	.byte 0x03,0x01,0x01,0xa6
	.uaword smooth_rgba_z_line
	.uaword .L1601
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xb2,0x09
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0xa4,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0xa5,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0xa5,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0xa5,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0xa7
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0xa8
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0xa9
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x01,0xaa
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbr\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0xab
	.byte 0x02,0x91,0x6c,0x1b
	.ascii "pbg\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0xac
	.byte 0x02,0x91,0x68,0x1b
	.ascii "pbb\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0xad
	.byte 0x02,0x91,0x64,0x1b
	.ascii "pba\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x01,0xae
	.byte 0x02,0x91,0x60,0x1a
	.uaword .L1413
	.uaword .L1589
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x0f,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x0f,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x67,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x68,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x69,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x6a,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x6b,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x6c,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x6f,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x0f,0x70,0x03
	.byte 0x91,0x84,0x7f,0x1a
	.uaword .L1479
	.uaword .L1588
	.byte 0x1a
	.uaword .L1483
	.uaword .L1534
	.byte 0x1a
	.uaword .L1484
	.uaword .L1533
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0xfc,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0xfd,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0xfe,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0xff,0x03
	.byte 0x91,0xf4,0x7e,0x1a
	.uaword .L1493
	.uaword .L1532
	.byte 0x1a
	.uaword .L1499
	.uaword .L1529
	.byte 0x1a
	.uaword .L1500
	.uaword .L1528
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0f,0x01,0x26
	.byte 0x03,0x91,0xf2,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L1536
	.uaword .L1587
	.byte 0x1a
	.uaword .L1537
	.uaword .L1586
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x01,0x77
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x01,0x78
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x01,0x79
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x0f,0x01,0x7a
	.byte 0x03,0x91,0xf4,0x7e,0x1a
	.uaword .L1546
	.uaword .L1585
	.byte 0x1a
	.uaword .L1552
	.uaword .L1582
	.byte 0x1a
	.uaword .L1553
	.uaword .L1581
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x0f,0x01,0xa1
	.byte 0x03,0x91,0xf2,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1c
	.ascii "general_smooth_ci_line\0"
	.byte 0x03,0x01,0x01,0xd2
	.uaword general_smooth_ci_line
	.uaword .L2263
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xbb,0xc2
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x01,0xd0,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x01,0xd1,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x01,0xd1,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x01,0xd1,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x01,0xd3
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0xd4
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x01,0xd5
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x01,0xd6
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbi\0"
	.byte 0x00,0x00,0x93,0xba,0x01,0x01,0x01,0xd7
	.byte 0x02,0x91,0x6c,0x1a
	.uaword .L1612
	.uaword .L2251
	.byte 0x1a
	.uaword .L1616
	.uaword .L1856
	.byte 0x1a
	.uaword .L1617
	.uaword .L1855
	.byte 0x1a
	.uaword .L1618
	.uaword .L1854
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x10,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x10,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "i0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x73,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "di\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x73,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x8a,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x8a,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x8a,0x03
	.byte 0x91,0x9c,0x7f,0x1a
	.uaword .L1686
	.uaword .L1853
	.byte 0x1a
	.uaword .L1690
	.uaword .L1770
	.byte 0x1a
	.uaword .L1691
	.uaword .L1769
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0xfc,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0xfd,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0xfe,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0xff,0x03
	.byte 0x91,0xf8,0x7e,0x1a
	.uaword .L1697
	.uaword .L1768
	.byte 0x1a
	.uaword .L1703
	.uaword .L1765
	.byte 0x1a
	.uaword .L1704
	.uaword .L1764
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x10,0x01,0x20
	.byte 0x03,0x91,0xf6,0x7e,0x1a
	.uaword .L1706
	.uaword .L1740
	.byte 0x1a
	.uaword .L1710
	.uaword .L1739
	.byte 0x1a
	.uaword .L1711
	.uaword .L1738
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x10,0x01,0x26
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x2c
	.byte 0x03,0x91,0xf0,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x2f
	.byte 0x03,0x91,0xec,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x30
	.byte 0x03,0x91,0xe8,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x31
	.byte 0x03,0x91,0xe4,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L1772
	.uaword .L1852
	.byte 0x1a
	.uaword .L1773
	.uaword .L1851
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x77
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x78
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x79
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0x7a
	.byte 0x03,0x91,0xf8,0x7e,0x1a
	.uaword .L1779
	.uaword .L1850
	.byte 0x1a
	.uaword .L1785
	.uaword .L1847
	.byte 0x1a
	.uaword .L1786
	.uaword .L1846
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x10,0x01,0x9b
	.byte 0x03,0x91,0xf6,0x7e,0x1a
	.uaword .L1788
	.uaword .L1822
	.byte 0x1a
	.uaword .L1792
	.uaword .L1821
	.byte 0x1a
	.uaword .L1793
	.uaword .L1820
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x10,0x01,0xa1
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0xa7
	.byte 0x03,0x91,0xf0,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0xaa
	.byte 0x03,0x91,0xec,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0xab
	.byte 0x03,0x91,0xe8,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x10,0x01,0xac
	.byte 0x03,0x91,0xe4,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L1858
	.uaword .L2250
	.byte 0x1a
	.uaword .L1859
	.uaword .L2249
	.byte 0x1a
	.uaword .L1860
	.uaword .L2248
	.byte 0x1a
	.uaword .L1864
	.uaword .L2027
	.byte 0x1a
	.uaword .L1865
	.uaword .L2026
	.byte 0x1a
	.uaword .L1866
	.uaword .L2025
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x11,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x11,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "i0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x73,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "di\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x73,0x03
	.byte 0x91,0xa8,0x7f,0x1a
	.uaword .L1925
	.uaword .L2024
	.byte 0x1a
	.uaword .L1929
	.uaword .L1975
	.byte 0x1a
	.uaword .L1930
	.uaword .L1974
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0xfc,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0xfd,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0xfe,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0xff,0x03
	.byte 0x91,0x98,0x7f,0x1a
	.uaword .L1936
	.uaword .L1973
	.byte 0x1a
	.uaword .L1942
	.uaword .L1970
	.byte 0x1a
	.uaword .L1943
	.uaword .L1969
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x11,0x01,0x26
	.byte 0x03,0x91,0x96,0x7f,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0x2c
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L1977
	.uaword .L2023
	.byte 0x1a
	.uaword .L1978
	.uaword .L2022
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0x77
	.byte 0x03,0x91,0xa4,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0x78
	.byte 0x03,0x91,0xa0,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0x79
	.byte 0x03,0x91,0x9c,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0x7a
	.byte 0x03,0x91,0x98,0x7f,0x1a
	.uaword .L1984
	.uaword .L2021
	.byte 0x1a
	.uaword .L1990
	.uaword .L2018
	.byte 0x1a
	.uaword .L1991
	.uaword .L2017
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x11,0x01,0xa1
	.byte 0x03,0x91,0x96,0x7f,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x11,0x01,0xa7
	.byte 0x03,0x91,0x90,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x1a
	.uaword .L2029
	.uaword .L2247
	.byte 0x1a
	.uaword .L2030
	.uaword .L2246
	.byte 0x1a
	.uaword .L2031
	.uaword .L2245
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x12,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x12,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "i0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x73,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "di\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x73,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x8a,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x8a,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x8a,0x03
	.byte 0x91,0x9c,0x7f,0x1a
	.uaword .L2099
	.uaword .L2244
	.byte 0x1a
	.uaword .L2103
	.uaword .L2172
	.byte 0x1a
	.uaword .L2104
	.uaword .L2171
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0xfc,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0xfd,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0xfe,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0xff,0x03
	.byte 0x91,0xf8,0x7e,0x1a
	.uaword .L2110
	.uaword .L2170
	.byte 0x1a
	.uaword .L2116
	.uaword .L2167
	.byte 0x1a
	.uaword .L2117
	.uaword .L2166
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x12,0x01,0x26
	.byte 0x03,0x91,0xf6,0x7e,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x2c
	.byte 0x03,0x91,0xf0,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x2f
	.byte 0x03,0x91,0xec,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x30
	.byte 0x03,0x91,0xe8,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x31
	.byte 0x03,0x91,0xe4,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L2174
	.uaword .L2243
	.byte 0x1a
	.uaword .L2175
	.uaword .L2242
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x77
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x78
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x79
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0x7a
	.byte 0x03,0x91,0xf8,0x7e,0x1a
	.uaword .L2181
	.uaword .L2241
	.byte 0x1a
	.uaword .L2187
	.uaword .L2238
	.byte 0x1a
	.uaword .L2188
	.uaword .L2237
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x12,0x01,0xa1
	.byte 0x03,0x91,0xf6,0x7e,0x1b
	.ascii "I\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0xa7
	.byte 0x03,0x91,0xf0,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0xaa
	.byte 0x03,0x91,0xec,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0xab
	.byte 0x03,0x91,0xe8,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x12,0x01,0xac
	.byte 0x03,0x91,0xe4,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x1c
	.ascii "general_flat_ci_line\0"
	.byte 0x03,0x01,0x02,0x17
	.uaword general_flat_ci_line
	.uaword .L2914
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xc4,0xb2
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x02,0x15,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x02,0x16,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x02,0x16,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x02,0x16,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x02,0x18
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0x19
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0x1a
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x02,0x1b
	.byte 0x02,0x91,0x70,0x1a
	.uaword .L2284
	.uaword .L2902
	.byte 0x1a
	.uaword .L2288
	.uaword .L2521
	.byte 0x1a
	.uaword .L2289
	.uaword .L2520
	.byte 0x1a
	.uaword .L2290
	.uaword .L2519
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x13,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x63,0x02
	.byte 0x91,0x48,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x13,0x64,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x8a,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x8a,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x8a,0x03
	.byte 0x91,0xa8,0x7f,0x1a
	.uaword .L2357
	.uaword .L2518
	.byte 0x1a
	.uaword .L2361
	.uaword .L2438
	.byte 0x1a
	.uaword .L2362
	.uaword .L2437
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0xfc,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0xfd,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0xfe,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0xff,0x03
	.byte 0x91,0x88,0x7f,0x1a
	.uaword .L2367
	.uaword .L2436
	.byte 0x1a
	.uaword .L2373
	.uaword .L2433
	.byte 0x1a
	.uaword .L2374
	.uaword .L2432
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x13,0x01,0x20
	.byte 0x03,0x91,0x86,0x7f,0x1a
	.uaword .L2376
	.uaword .L2409
	.byte 0x1a
	.uaword .L2380
	.uaword .L2408
	.byte 0x1a
	.uaword .L2381
	.uaword .L2407
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x13,0x01,0x26
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x2f
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x30
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x31
	.byte 0x03,0x91,0xf8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L2440
	.uaword .L2517
	.byte 0x1a
	.uaword .L2441
	.uaword .L2516
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x77
	.byte 0x03,0x91,0x94,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x78
	.byte 0x03,0x91,0x90,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x79
	.byte 0x03,0x91,0x8c,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0x7a
	.byte 0x03,0x91,0x88,0x7f,0x1a
	.uaword .L2446
	.uaword .L2515
	.byte 0x1a
	.uaword .L2452
	.uaword .L2512
	.byte 0x1a
	.uaword .L2453
	.uaword .L2511
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x13,0x01,0x9b
	.byte 0x03,0x91,0x86,0x7f,0x1a
	.uaword .L2455
	.uaword .L2488
	.byte 0x1a
	.uaword .L2459
	.uaword .L2487
	.byte 0x1a
	.uaword .L2460
	.uaword .L2486
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x13,0x01,0xa1
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0xaa
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0xab
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x13,0x01,0xac
	.byte 0x03,0x91,0xf8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L2523
	.uaword .L2901
	.byte 0x1a
	.uaword .L2524
	.uaword .L2900
	.byte 0x1a
	.uaword .L2525
	.uaword .L2899
	.byte 0x1a
	.uaword .L2529
	.uaword .L2685
	.byte 0x1a
	.uaword .L2530
	.uaword .L2684
	.byte 0x1a
	.uaword .L2531
	.uaword .L2683
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x14,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x63,0x02
	.byte 0x91,0x48,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x14,0x64,0x03
	.byte 0x91,0xb4,0x7f,0x1a
	.uaword .L2589
	.uaword .L2682
	.byte 0x1a
	.uaword .L2593
	.uaword .L2636
	.byte 0x1a
	.uaword .L2594
	.uaword .L2635
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0xfc,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0xfd,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0xfe,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0xff,0x03
	.byte 0x91,0xa4,0x7f,0x1a
	.uaword .L2599
	.uaword .L2634
	.byte 0x1a
	.uaword .L2605
	.uaword .L2631
	.byte 0x1a
	.uaword .L2606
	.uaword .L2630
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x14,0x01,0x26
	.byte 0x03,0x91,0xa2,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L2638
	.uaword .L2681
	.byte 0x1a
	.uaword .L2639
	.uaword .L2680
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x01,0x77
	.byte 0x03,0x91,0xb0,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x01,0x78
	.byte 0x03,0x91,0xac,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x01,0x79
	.byte 0x03,0x91,0xa8,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x14,0x01,0x7a
	.byte 0x03,0x91,0xa4,0x7f,0x1a
	.uaword .L2644
	.uaword .L2679
	.byte 0x1a
	.uaword .L2650
	.uaword .L2676
	.byte 0x1a
	.uaword .L2651
	.uaword .L2675
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x14,0x01,0xa1
	.byte 0x03,0x91,0xa2,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x1a
	.uaword .L2687
	.uaword .L2898
	.byte 0x1a
	.uaword .L2688
	.uaword .L2897
	.byte 0x1a
	.uaword .L2689
	.uaword .L2896
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x15,0x57,0x02
	.byte 0x91,0x6c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5c,0x02
	.byte 0x91,0x68,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5d,0x02
	.byte 0x91,0x60,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5e,0x02
	.byte 0x91,0x58,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x60,0x02
	.byte 0x91,0x50,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x63,0x02
	.byte 0x91,0x48,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x15,0x64,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x8a,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x8a,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x8a,0x03
	.byte 0x91,0xa8,0x7f,0x1a
	.uaword .L2756
	.uaword .L2895
	.byte 0x1a
	.uaword .L2760
	.uaword .L2826
	.byte 0x1a
	.uaword .L2761
	.uaword .L2825
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0xfc,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0xfd,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0xfe,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0xff,0x03
	.byte 0x91,0x88,0x7f,0x1a
	.uaword .L2766
	.uaword .L2824
	.byte 0x1a
	.uaword .L2772
	.uaword .L2821
	.byte 0x1a
	.uaword .L2773
	.uaword .L2820
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x15,0x01,0x26
	.byte 0x03,0x91,0x86,0x7f,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x2f
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x30
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x31
	.byte 0x03,0x91,0xf8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L2828
	.uaword .L2894
	.byte 0x1a
	.uaword .L2829
	.uaword .L2893
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x77
	.byte 0x03,0x91,0x94,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x78
	.byte 0x03,0x91,0x90,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x79
	.byte 0x03,0x91,0x8c,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0x7a
	.byte 0x03,0x91,0x88,0x7f,0x1a
	.uaword .L2834
	.uaword .L2892
	.byte 0x1a
	.uaword .L2840
	.uaword .L2889
	.byte 0x1a
	.uaword .L2841
	.uaword .L2888
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x15,0x01,0xa1
	.byte 0x03,0x91,0x86,0x7f,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0xaa
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0xab
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x15,0x01,0xac
	.byte 0x03,0x91,0xf8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x1c
	.ascii "general_smooth_rgba_line\0"
	.byte 0x03,0x01,0x02,0x56
	.uaword general_smooth_rgba_line
	.uaword .L3630
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xcf,0x5a
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x02,0x54,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x02,0x55,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x02,0x55,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x02,0x55,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x02,0x57
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0x58
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0x59
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x02,0x5a
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbr\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0x5b
	.byte 0x02,0x91,0x6c,0x1b
	.ascii "pbg\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0x5c
	.byte 0x02,0x91,0x68,0x1b
	.ascii "pbb\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0x5d
	.byte 0x02,0x91,0x64,0x1b
	.ascii "pba\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0x5e
	.byte 0x02,0x91,0x60,0x1a
	.uaword .L2928
	.uaword .L3618
	.byte 0x1a
	.uaword .L2932
	.uaword .L3189
	.byte 0x1a
	.uaword .L2933
	.uaword .L3188
	.byte 0x1a
	.uaword .L2934
	.uaword .L3187
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x16,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x16,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x67,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x68,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x69,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x6a,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x6b,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x6c,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x6f,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x16,0x70,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x8a,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x8a,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x8a,0x03
	.byte 0x91,0xf8,0x7e,0x1a
	.uaword .L3009
	.uaword .L3186
	.byte 0x1a
	.uaword .L3013
	.uaword .L3098
	.byte 0x1a
	.uaword .L3014
	.uaword .L3097
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0xfc,0x03
	.byte 0x91,0xe4,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0xfd,0x03
	.byte 0x91,0xe0,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0xfe,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0xff,0x03
	.byte 0x91,0xd8,0x7e,0x1a
	.uaword .L3023
	.uaword .L3096
	.byte 0x1a
	.uaword .L3029
	.uaword .L3093
	.byte 0x1a
	.uaword .L3030
	.uaword .L3092
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x16,0x01,0x20
	.byte 0x03,0x91,0xd6,0x7e,0x1a
	.uaword .L3032
	.uaword .L3065
	.byte 0x1a
	.uaword .L3036
	.uaword .L3064
	.byte 0x1a
	.uaword .L3037
	.uaword .L3063
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x16,0x01,0x26
	.byte 0x03,0x91,0xd4,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x2f
	.byte 0x03,0x91,0xd0,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x30
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x31
	.byte 0x03,0x91,0xc8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L3100
	.uaword .L3185
	.byte 0x1a
	.uaword .L3101
	.uaword .L3184
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x77
	.byte 0x03,0x91,0xe4,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x78
	.byte 0x03,0x91,0xe0,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x79
	.byte 0x03,0x91,0xdc,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0x7a
	.byte 0x03,0x91,0xd8,0x7e,0x1a
	.uaword .L3110
	.uaword .L3183
	.byte 0x1a
	.uaword .L3116
	.uaword .L3180
	.byte 0x1a
	.uaword .L3117
	.uaword .L3179
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x16,0x01,0x9b
	.byte 0x03,0x91,0xd6,0x7e,0x1a
	.uaword .L3119
	.uaword .L3152
	.byte 0x1a
	.uaword .L3123
	.uaword .L3151
	.byte 0x1a
	.uaword .L3124
	.uaword .L3150
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x16,0x01,0xa1
	.byte 0x03,0x91,0xd4,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0xaa
	.byte 0x03,0x91,0xd0,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0xab
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x16,0x01,0xac
	.byte 0x03,0x91,0xc8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L3191
	.uaword .L3617
	.byte 0x1a
	.uaword .L3192
	.uaword .L3616
	.byte 0x1a
	.uaword .L3193
	.uaword .L3615
	.byte 0x1a
	.uaword .L3197
	.uaword .L3377
	.byte 0x1a
	.uaword .L3198
	.uaword .L3376
	.byte 0x1a
	.uaword .L3199
	.uaword .L3375
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x17,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x17,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x67,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x68,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x69,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x6a,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x6b,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x6c,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x6f,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x17,0x70,0x03
	.byte 0x91,0x84,0x7f,0x1a
	.uaword .L3265
	.uaword .L3374
	.byte 0x1a
	.uaword .L3269
	.uaword .L3320
	.byte 0x1a
	.uaword .L3270
	.uaword .L3319
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0xfc,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0xfd,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0xfe,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0xff,0x03
	.byte 0x91,0xf4,0x7e,0x1a
	.uaword .L3279
	.uaword .L3318
	.byte 0x1a
	.uaword .L3285
	.uaword .L3315
	.byte 0x1a
	.uaword .L3286
	.uaword .L3314
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x17,0x01,0x26
	.byte 0x03,0x91,0xf2,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L3322
	.uaword .L3373
	.byte 0x1a
	.uaword .L3323
	.uaword .L3372
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x01,0x77
	.byte 0x03,0x91,0x80,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x01,0x78
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x01,0x79
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x17,0x01,0x7a
	.byte 0x03,0x91,0xf4,0x7e,0x1a
	.uaword .L3332
	.uaword .L3371
	.byte 0x1a
	.uaword .L3338
	.uaword .L3368
	.byte 0x1a
	.uaword .L3339
	.uaword .L3367
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x17,0x01,0xa1
	.byte 0x03,0x91,0xf2,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x1a
	.uaword .L3379
	.uaword .L3614
	.byte 0x1a
	.uaword .L3380
	.uaword .L3613
	.byte 0x1a
	.uaword .L3381
	.uaword .L3612
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x18,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x18,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x67,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x68,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x69,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x6a,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x6b,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x6c,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x6f,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x18,0x70,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x8a,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x8a,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x8a,0x03
	.byte 0x91,0xf8,0x7e,0x1a
	.uaword .L3456
	.uaword .L3611
	.byte 0x1a
	.uaword .L3460
	.uaword .L3534
	.byte 0x1a
	.uaword .L3461
	.uaword .L3533
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0xfc,0x03
	.byte 0x91,0xe4,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0xfd,0x03
	.byte 0x91,0xe0,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0xfe,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0xff,0x03
	.byte 0x91,0xd8,0x7e,0x1a
	.uaword .L3470
	.uaword .L3532
	.byte 0x1a
	.uaword .L3476
	.uaword .L3529
	.byte 0x1a
	.uaword .L3477
	.uaword .L3528
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x18,0x01,0x26
	.byte 0x03,0x91,0xd6,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x2f
	.byte 0x03,0x91,0xd0,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x30
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x31
	.byte 0x03,0x91,0xc8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L3536
	.uaword .L3610
	.byte 0x1a
	.uaword .L3537
	.uaword .L3609
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x77
	.byte 0x03,0x91,0xe4,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x78
	.byte 0x03,0x91,0xe0,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x79
	.byte 0x03,0x91,0xdc,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0x7a
	.byte 0x03,0x91,0xd8,0x7e,0x1a
	.uaword .L3546
	.uaword .L3608
	.byte 0x1a
	.uaword .L3552
	.uaword .L3605
	.byte 0x1a
	.uaword .L3553
	.uaword .L3604
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x18,0x01,0xa1
	.byte 0x03,0x91,0xd6,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0xaa
	.byte 0x03,0x91,0xd0,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0xab
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x18,0x01,0xac
	.byte 0x03,0x91,0xc8,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x1c
	.ascii "general_flat_rgba_line\0"
	.byte 0x03,0x01,0x02,0xac
	.uaword general_flat_rgba_line
	.uaword .L4285
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xd8,0x61
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x02,0xaa,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x02,0xab,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x02,0xab,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pvert\0"
	.byte 0x01,0x02,0xab,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x02,0xad
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0xae
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0xaf
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x02,0xb0
	.byte 0x02,0x91,0x70,0x1b
	.ascii "color\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0xb1
	.byte 0x02,0x91,0x6c,0x1a
	.uaword .L3655
	.uaword .L4273
	.byte 0x1a
	.uaword .L3659
	.uaword .L3892
	.byte 0x1a
	.uaword .L3660
	.uaword .L3891
	.byte 0x1a
	.uaword .L3661
	.uaword .L3890
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x19,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x19,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x8a,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x8a,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x8a,0x03
	.byte 0x91,0xa4,0x7f,0x1a
	.uaword .L3728
	.uaword .L3889
	.byte 0x1a
	.uaword .L3732
	.uaword .L3809
	.byte 0x1a
	.uaword .L3733
	.uaword .L3808
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0xfc,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0xfd,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0xfe,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0xff,0x03
	.byte 0x91,0x80,0x7f,0x1a
	.uaword .L3738
	.uaword .L3807
	.byte 0x1a
	.uaword .L3744
	.uaword .L3804
	.byte 0x1a
	.uaword .L3745
	.uaword .L3803
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x19,0x01,0x20
	.byte 0x03,0x91,0xfe,0x7e,0x1a
	.uaword .L3747
	.uaword .L3780
	.byte 0x1a
	.uaword .L3751
	.uaword .L3779
	.byte 0x1a
	.uaword .L3752
	.uaword .L3778
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x19,0x01,0x26
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x2f
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x30
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x31
	.byte 0x03,0x91,0xf0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L3811
	.uaword .L3888
	.byte 0x1a
	.uaword .L3812
	.uaword .L3887
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x77
	.byte 0x03,0x91,0x8c,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x78
	.byte 0x03,0x91,0x88,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x79
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0x7a
	.byte 0x03,0x91,0x80,0x7f,0x1a
	.uaword .L3817
	.uaword .L3886
	.byte 0x1a
	.uaword .L3823
	.uaword .L3883
	.byte 0x1a
	.uaword .L3824
	.uaword .L3882
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x19,0x01,0x9b
	.byte 0x03,0x91,0xfe,0x7e,0x1a
	.uaword .L3826
	.uaword .L3859
	.byte 0x1a
	.uaword .L3830
	.uaword .L3858
	.byte 0x1a
	.uaword .L3831
	.uaword .L3857
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x19,0x01,0xa1
	.byte 0x03,0x91,0xfc,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0xaa
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0xab
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x19,0x01,0xac
	.byte 0x03,0x91,0xf0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L3894
	.uaword .L4272
	.byte 0x1a
	.uaword .L3895
	.uaword .L4271
	.byte 0x1a
	.uaword .L3896
	.uaword .L4270
	.byte 0x1a
	.uaword .L3900
	.uaword .L4056
	.byte 0x1a
	.uaword .L3901
	.uaword .L4055
	.byte 0x1a
	.uaword .L3902
	.uaword .L4054
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1a,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1a,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x1a
	.uaword .L3960
	.uaword .L4053
	.byte 0x1a
	.uaword .L3964
	.uaword .L4007
	.byte 0x1a
	.uaword .L3965
	.uaword .L4006
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0xfc,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0xfd,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0xfe,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0xff,0x03
	.byte 0x91,0xa0,0x7f,0x1a
	.uaword .L3970
	.uaword .L4005
	.byte 0x1a
	.uaword .L3976
	.uaword .L4002
	.byte 0x1a
	.uaword .L3977
	.uaword .L4001
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1a,0x01,0x26
	.byte 0x03,0x91,0x9e,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L4009
	.uaword .L4052
	.byte 0x1a
	.uaword .L4010
	.uaword .L4051
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x01,0x77
	.byte 0x03,0x91,0xac,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x01,0x78
	.byte 0x03,0x91,0xa8,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x01,0x79
	.byte 0x03,0x91,0xa4,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1a,0x01,0x7a
	.byte 0x03,0x91,0xa0,0x7f,0x1a
	.uaword .L4015
	.uaword .L4050
	.byte 0x1a
	.uaword .L4021
	.uaword .L4047
	.byte 0x1a
	.uaword .L4022
	.uaword .L4046
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1a,0x01,0xa1
	.byte 0x03,0x91,0x9e,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x1a
	.uaword .L4058
	.uaword .L4269
	.byte 0x1a
	.uaword .L4059
	.uaword .L4268
	.byte 0x1a
	.uaword .L4060
	.uaword .L4267
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1b,0x57,0x02
	.byte 0x91,0x68,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5c,0x02
	.byte 0x91,0x64,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5c,0x02
	.byte 0x91,0x60,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5d,0x02
	.byte 0x91,0x5c,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5d,0x02
	.byte 0x91,0x58,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5e,0x02
	.byte 0x91,0x54,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x5e,0x02
	.byte 0x91,0x50,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x60,0x02
	.byte 0x91,0x4c,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x60,0x02
	.byte 0x91,0x48,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x63,0x02
	.byte 0x91,0x44,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x63,0x02
	.byte 0x91,0x40,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x63,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1b,0x64,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x8a,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x8a,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x8a,0x03
	.byte 0x91,0xa4,0x7f,0x1a
	.uaword .L4127
	.uaword .L4266
	.byte 0x1a
	.uaword .L4131
	.uaword .L4197
	.byte 0x1a
	.uaword .L4132
	.uaword .L4196
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0xfc,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0xfd,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0xfe,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0xff,0x03
	.byte 0x91,0x80,0x7f,0x1a
	.uaword .L4137
	.uaword .L4195
	.byte 0x1a
	.uaword .L4143
	.uaword .L4192
	.byte 0x1a
	.uaword .L4144
	.uaword .L4191
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1b,0x01,0x26
	.byte 0x03,0x91,0xfe,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x2f
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x30
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x31
	.byte 0x03,0x91,0xf0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L4199
	.uaword .L4265
	.byte 0x1a
	.uaword .L4200
	.uaword .L4264
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x77
	.byte 0x03,0x91,0x8c,0x7f,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x78
	.byte 0x03,0x91,0x88,0x7f,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x79
	.byte 0x03,0x91,0x84,0x7f,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0x7a
	.byte 0x03,0x91,0x80,0x7f,0x1a
	.uaword .L4205
	.uaword .L4263
	.byte 0x1a
	.uaword .L4211
	.uaword .L4260
	.byte 0x1a
	.uaword .L4212
	.uaword .L4259
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1b,0x01,0xa1
	.byte 0x03,0x91,0xfe,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0xaa
	.byte 0x03,0x91,0xf8,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0xab
	.byte 0x03,0x91,0xf4,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1b,0x01,0xac
	.byte 0x03,0x91,0xf0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x1c
	.ascii "flat_textured_line\0"
	.byte 0x03,0x01,0x02,0xed
	.uaword flat_textured_line
	.uaword .L4838
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xe0,0xef
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x02,0xeb,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x02,0xec,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x02,0xec,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pv\0"
	.byte 0x01,0x02,0xec,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x02,0xee
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0xef
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x02,0xf0
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x02,0xf1
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbs\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x02,0xf2
	.byte 0x02,0x91,0x6c,0x1b
	.ascii "pbt\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x02,0xf3
	.byte 0x02,0x91,0x68,0x1b
	.ascii "pbu\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x02,0xf4
	.byte 0x02,0x91,0x64,0x1b
	.ascii "color\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x02,0xf5
	.byte 0x02,0x91,0x60,0x1a
	.uaword .L4313
	.uaword .L4826
	.byte 0x1a
	.uaword .L4317
	.uaword .L4581
	.byte 0x1a
	.uaword .L4318
	.uaword .L4580
	.byte 0x1a
	.uaword .L4319
	.uaword .L4579
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1c,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1c,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "s0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7c,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "ds\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7c,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "t0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7d,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dt\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7d,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "w0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7e,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "dw\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x7e,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "u0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x81,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "du\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x81,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "v0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x82,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "dv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x82,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x8a,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x8a,0x03
	.byte 0x91,0xf4,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x8a,0x03
	.byte 0x91,0xf0,0x7e,0x1a
	.uaword .L4391
	.uaword .L4578
	.byte 0x1a
	.uaword .L4395
	.uaword .L4485
	.byte 0x1a
	.uaword .L4396
	.uaword .L4484
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0xfc,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0xfd,0x03
	.byte 0x91,0xd8,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0xfe,0x03
	.byte 0x91,0xd4,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0xff,0x03
	.byte 0x91,0xd0,0x7e,0x1a
	.uaword .L4401
	.uaword .L4408
	.byte 0x1b
	.ascii "fdxinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x01,0x14
	.byte 0x03,0x91,0xcc,0x7e,0x00,0x1a
	.uaword .L4409
	.uaword .L4483
	.byte 0x1a
	.uaword .L4415
	.uaword .L4480
	.byte 0x1a
	.uaword .L4416
	.uaword .L4479
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x1c,0x01,0x20
	.byte 0x03,0x91,0xce,0x7e,0x1a
	.uaword .L4418
	.uaword .L4451
	.byte 0x1a
	.uaword .L4422
	.uaword .L4450
	.byte 0x1a
	.uaword .L4423
	.uaword .L4449
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1c,0x01,0x26
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x2f
	.byte 0x03,0x91,0xc8,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x30
	.byte 0x03,0x91,0xc4,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x31
	.byte 0x03,0x91,0xc0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L4487
	.uaword .L4577
	.byte 0x1a
	.uaword .L4488
	.uaword .L4576
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x77
	.byte 0x03,0x91,0xdc,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x78
	.byte 0x03,0x91,0xd8,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x79
	.byte 0x03,0x91,0xd4,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0x7a
	.byte 0x03,0x91,0xd0,0x7e,0x1a
	.uaword .L4493
	.uaword .L4500
	.byte 0x1b
	.ascii "fdyinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1c,0x01,0x8f
	.byte 0x03,0x91,0xcc,0x7e,0x00,0x1a
	.uaword .L4501
	.uaword .L4575
	.byte 0x1a
	.uaword .L4507
	.uaword .L4572
	.byte 0x1a
	.uaword .L4508
	.uaword .L4571
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x1c,0x01,0x9b
	.byte 0x03,0x91,0xce,0x7e,0x1a
	.uaword .L4510
	.uaword .L4543
	.byte 0x1a
	.uaword .L4514
	.uaword .L4542
	.byte 0x1a
	.uaword .L4515
	.uaword .L4541
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1c,0x01,0xa1
	.byte 0x03,0x91,0xcc,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0xaa
	.byte 0x03,0x91,0xc8,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0xab
	.byte 0x03,0x91,0xc4,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1c,0x01,0xac
	.byte 0x03,0x91,0xc0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L4583
	.uaword .L4825
	.byte 0x1a
	.uaword .L4584
	.uaword .L4824
	.byte 0x1a
	.uaword .L4585
	.uaword .L4823
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1d,0x57,0x02
	.byte 0x91,0x5c,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5c,0x02
	.byte 0x91,0x58,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5c,0x02
	.byte 0x91,0x54,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5d,0x02
	.byte 0x91,0x50,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5d,0x02
	.byte 0x91,0x4c,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5e,0x02
	.byte 0x91,0x48,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x5e,0x02
	.byte 0x91,0x44,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x60,0x02
	.byte 0x91,0x40,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x60,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x63,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x63,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x63,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1d,0x64,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "s0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7c,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "ds\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7c,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "t0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7d,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "dt\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7d,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "w0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7e,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "dw\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x7e
	.byte 0x03,0x91,0x8c,0x7f,0x19
	.ascii "u0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x81,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "du\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x81,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "v0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x82,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "dv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x82,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x8a,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x8a,0x03
	.byte 0x91,0xf4,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x8a,0x03
	.byte 0x91,0xf0,0x7e,0x1a
	.uaword .L4657
	.uaword .L4822
	.byte 0x1a
	.uaword .L4661
	.uaword .L4740
	.byte 0x1a
	.uaword .L4662
	.uaword .L4739
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0xfc,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0xfd,0x03
	.byte 0x91,0xd8,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0xfe,0x03
	.byte 0x91,0xd4,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0xff,0x03
	.byte 0x91,0xd0,0x7e,0x1a
	.uaword .L4667
	.uaword .L4674
	.byte 0x1b
	.ascii "fdxinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x01,0x14
	.byte 0x03,0x91,0xcc,0x7e,0x00,0x1a
	.uaword .L4675
	.uaword .L4738
	.byte 0x1a
	.uaword .L4681
	.uaword .L4735
	.byte 0x1a
	.uaword .L4682
	.uaword .L4734
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1d,0x01,0x26
	.byte 0x03,0x91,0xce,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x2f
	.byte 0x03,0x91,0xc8,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x30
	.byte 0x03,0x91,0xc4,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x31
	.byte 0x03,0x91,0xc0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L4742
	.uaword .L4821
	.byte 0x1a
	.uaword .L4743
	.uaword .L4820
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x77
	.byte 0x03,0x91,0xdc,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x78
	.byte 0x03,0x91,0xd8,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x79
	.byte 0x03,0x91,0xd4,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0x7a
	.byte 0x03,0x91,0xd0,0x7e,0x1a
	.uaword .L4748
	.uaword .L4755
	.byte 0x1b
	.ascii "fdyinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1d,0x01,0x8f
	.byte 0x03,0x91,0xcc,0x7e,0x00,0x1a
	.uaword .L4756
	.uaword .L4819
	.byte 0x1a
	.uaword .L4762
	.uaword .L4816
	.byte 0x1a
	.uaword .L4763
	.uaword .L4815
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1d,0x01,0xa1
	.byte 0x03,0x91,0xce,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0xaa
	.byte 0x03,0x91,0xc8,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0xab
	.byte 0x03,0x91,0xc4,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1d,0x01,0xac
	.byte 0x03,0x91,0xc0,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1c
	.ascii "smooth_textured_line\0"
	.byte 0x03,0x01,0x03,0x28
	.uaword smooth_textured_line
	.uaword .L5428
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xea,0xa3
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x03,0x26,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert0\0"
	.byte 0x01,0x03,0x27,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "vert1\0"
	.byte 0x01,0x03,0x27,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pv\0"
	.byte 0x01,0x03,0x27,0x03,0x91,0xd0,0x00,0x1b
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x01,0x03,0x29
	.byte 0x02,0x91,0x7c,0x1b
	.ascii "pbx\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x03,0x2a
	.byte 0x02,0x91,0x78,0x1b
	.ascii "pby\0"
	.byte 0x00,0x00,0x9e,0x9a,0x01,0x01,0x03,0x2b
	.byte 0x02,0x91,0x74,0x1b
	.ascii "pbz\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x01,0x03,0x2c
	.byte 0x02,0x91,0x70,0x1b
	.ascii "pbs\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x03,0x2d
	.byte 0x02,0x91,0x6c,0x1b
	.ascii "pbt\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x03,0x2e
	.byte 0x02,0x91,0x68,0x1b
	.ascii "pbu\0"
	.byte 0x00,0x00,0x90,0xff,0x01,0x01,0x03,0x2f
	.byte 0x02,0x91,0x64,0x1b
	.ascii "pbr\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x03,0x30
	.byte 0x02,0x91,0x60,0x1b
	.ascii "pbg\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x03,0x31
	.byte 0x02,0x91,0x5c,0x1b
	.ascii "pbb\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x03,0x32
	.byte 0x02,0x91,0x58,0x1b
	.ascii "pba\0"
	.byte 0x00,0x00,0x31,0x79,0x01,0x01,0x03,0x33
	.byte 0x02,0x91,0x54,0x1a
	.uaword .L4855
	.uaword .L5416
	.byte 0x1a
	.uaword .L4859
	.uaword .L5147
	.byte 0x1a
	.uaword .L4860
	.uaword .L5146
	.byte 0x1a
	.uaword .L4861
	.uaword .L5145
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1e,0x57,0x02
	.byte 0x91,0x50,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5c,0x02
	.byte 0x91,0x4c,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5c,0x02
	.byte 0x91,0x48,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5d,0x02
	.byte 0x91,0x44,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5d,0x02
	.byte 0x91,0x40,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5e,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x5e,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x60,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x60,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x63,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x63,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x63,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1e,0x64,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x67,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x68,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x69,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x6a,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x6b,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x6c,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x6f,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1e,0x70,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "s0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7c,0x03
	.byte 0x91,0xf4,0x7e,0x19
	.ascii "ds\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7c,0x03
	.byte 0x91,0xf0,0x7e,0x19
	.ascii "t0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7d,0x03
	.byte 0x91,0xec,0x7e,0x19
	.ascii "dt\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7d,0x03
	.byte 0x91,0xe8,0x7e,0x19
	.ascii "w0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7e,0x03
	.byte 0x91,0xe4,0x7e,0x19
	.ascii "dw\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x7e,0x03
	.byte 0x91,0xe0,0x7e,0x19
	.ascii "u0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x81,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "du\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x81,0x03
	.byte 0x91,0xd8,0x7e,0x19
	.ascii "v0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x82,0x03
	.byte 0x91,0xd4,0x7e,0x19
	.ascii "dv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x82,0x03
	.byte 0x91,0xd0,0x7e,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x8a,0x03
	.byte 0x91,0xcc,0x7e,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x8a,0x03
	.byte 0x91,0xc8,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x8a,0x03
	.byte 0x91,0xc4,0x7e,0x1a
	.uaword .L4941
	.uaword .L5144
	.byte 0x1a
	.uaword .L4945
	.uaword .L5043
	.byte 0x1a
	.uaword .L4946
	.uaword .L5042
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0xfc,0x03
	.byte 0x91,0xac,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0xfd,0x03
	.byte 0x91,0xa8,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0xfe,0x03
	.byte 0x91,0xa4,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0xff,0x03
	.byte 0x91,0xa0,0x7e,0x1a
	.uaword .L4955
	.uaword .L4962
	.byte 0x1b
	.ascii "fdxinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x01,0x14
	.byte 0x03,0x91,0x9c,0x7e,0x00,0x1a
	.uaword .L4963
	.uaword .L5041
	.byte 0x1a
	.uaword .L4969
	.uaword .L5038
	.byte 0x1a
	.uaword .L4970
	.uaword .L5037
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x1e,0x01,0x20
	.byte 0x03,0x91,0x9e,0x7e,0x1a
	.uaword .L4972
	.uaword .L5005
	.byte 0x1a
	.uaword .L4976
	.uaword .L5004
	.byte 0x1a
	.uaword .L4977
	.uaword .L5003
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1e,0x01,0x26
	.byte 0x03,0x91,0x9c,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x2f
	.byte 0x03,0x91,0x98,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x30
	.byte 0x03,0x91,0x94,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x31
	.byte 0x03,0x91,0x90,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x1a
	.uaword .L5045
	.uaword .L5143
	.byte 0x1a
	.uaword .L5046
	.uaword .L5142
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x77
	.byte 0x03,0x91,0xac,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x78
	.byte 0x03,0x91,0xa8,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x79
	.byte 0x03,0x91,0xa4,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0x7a
	.byte 0x03,0x91,0xa0,0x7e,0x1a
	.uaword .L5055
	.uaword .L5062
	.byte 0x1b
	.ascii "fdyinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1e,0x01,0x8f
	.byte 0x03,0x91,0x9c,0x7e,0x00,0x1a
	.uaword .L5063
	.uaword .L5141
	.byte 0x1a
	.uaword .L5069
	.uaword .L5138
	.byte 0x1a
	.uaword .L5070
	.uaword .L5137
	.byte 0x1b
	.ascii "m\0"
	.byte 0x00,0x00,0x82,0x4e,0x01,0x1e,0x01,0x9b
	.byte 0x03,0x91,0x9e,0x7e,0x1a
	.uaword .L5072
	.uaword .L5105
	.byte 0x1a
	.uaword .L5076
	.uaword .L5104
	.byte 0x1a
	.uaword .L5077
	.uaword .L5103
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1e,0x01,0xa1
	.byte 0x03,0x91,0x9c,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0xaa
	.byte 0x03,0x91,0x98,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0xab
	.byte 0x03,0x91,0x94,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1e,0x01,0xac
	.byte 0x03,0x91,0x90,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x1a
	.uaword .L5149
	.uaword .L5415
	.byte 0x1a
	.uaword .L5150
	.uaword .L5414
	.byte 0x1a
	.uaword .L5151
	.uaword .L5413
	.byte 0x19
	.ascii "VB\0"
	.byte 0x00,0x00,0x98,0x32,0x01,0x1f,0x57,0x02
	.byte 0x91,0x50,0x19
	.ascii "x0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5c,0x02
	.byte 0x91,0x4c,0x19
	.ascii "x1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5c,0x02
	.byte 0x91,0x48,0x19
	.ascii "y0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5d,0x02
	.byte 0x91,0x44,0x19
	.ascii "y1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5d,0x02
	.byte 0x91,0x40,0x19
	.ascii "dx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5e,0x03
	.byte 0x91,0xbc,0x7f,0x19
	.ascii "dy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x5e,0x03
	.byte 0x91,0xb8,0x7f,0x19
	.ascii "xstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x60,0x03
	.byte 0x91,0xb4,0x7f,0x19
	.ascii "ystep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x60,0x03
	.byte 0x91,0xb0,0x7f,0x19
	.ascii "z0\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x63,0x03
	.byte 0x91,0xac,0x7f,0x19
	.ascii "z1\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x63,0x03
	.byte 0x91,0xa8,0x7f,0x19
	.ascii "dz\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x63,0x03
	.byte 0x91,0xa4,0x7f,0x19
	.ascii "zPtrXstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x63,0x03
	.byte 0x91,0xa0,0x7f,0x19
	.ascii "zPtrYstep\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x63,0x03
	.byte 0x91,0x9c,0x7f,0x19
	.ascii "zPtr\0"
	.byte 0x00,0x00,0x65,0xb6,0x01,0x1f,0x64,0x03
	.byte 0x91,0x98,0x7f,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x67,0x03
	.byte 0x91,0x94,0x7f,0x19
	.ascii "dr\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x68,0x03
	.byte 0x91,0x90,0x7f,0x19
	.ascii "g0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x69,0x03
	.byte 0x91,0x8c,0x7f,0x19
	.ascii "dg\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x6a,0x03
	.byte 0x91,0x88,0x7f,0x19
	.ascii "b0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x6b,0x03
	.byte 0x91,0x84,0x7f,0x19
	.ascii "db\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x6c,0x03
	.byte 0x91,0x80,0x7f,0x19
	.ascii "a0\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x6f,0x03
	.byte 0x91,0xfc,0x7e,0x19
	.ascii "da\0"
	.byte 0x00,0x00,0xae,0x75,0x01,0x1f,0x70,0x03
	.byte 0x91,0xf8,0x7e,0x19
	.ascii "s0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7c,0x03
	.byte 0x91,0xf4,0x7e,0x19
	.ascii "ds\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7c,0x03
	.byte 0x91,0xf0,0x7e,0x19
	.ascii "t0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7d,0x03
	.byte 0x91,0xec,0x7e,0x19
	.ascii "dt\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7d,0x03
	.byte 0x91,0xe8,0x7e,0x19
	.ascii "w0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7e,0x03
	.byte 0x91,0xe4,0x7e,0x19
	.ascii "dw\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x7e,0x03
	.byte 0x91,0xe0,0x7e,0x19
	.ascii "u0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x81,0x03
	.byte 0x91,0xdc,0x7e,0x19
	.ascii "du\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x81,0x03
	.byte 0x91,0xd8,0x7e,0x19
	.ascii "v0\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x82,0x03
	.byte 0x91,0xd4,0x7e,0x19
	.ascii "dv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x82,0x03
	.byte 0x91,0xd0,0x7e,0x19
	.ascii "width\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x8a,0x03
	.byte 0x91,0xcc,0x7e,0x19
	.ascii "min\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x8a,0x03
	.byte 0x91,0xc8,0x7e,0x19
	.ascii "max\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x8a,0x03
	.byte 0x91,0xc4,0x7e,0x1a
	.uaword .L5231
	.uaword .L5412
	.byte 0x1a
	.uaword .L5235
	.uaword .L5322
	.byte 0x1a
	.uaword .L5236
	.uaword .L5321
	.byte 0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0xfc,0x03
	.byte 0x91,0xac,0x7e,0x19
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0xfd,0x03
	.byte 0x91,0xa8,0x7e,0x19
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0xfe,0x03
	.byte 0x91,0xa4,0x7e,0x19
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0xff,0x03
	.byte 0x91,0xa0,0x7e,0x1a
	.uaword .L5245
	.uaword .L5252
	.byte 0x1b
	.ascii "fdxinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x01,0x14
	.byte 0x03,0x91,0x9c,0x7e,0x00,0x1a
	.uaword .L5253
	.uaword .L5320
	.byte 0x1a
	.uaword .L5259
	.uaword .L5317
	.byte 0x1a
	.uaword .L5260
	.uaword .L5316
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1f,0x01,0x26
	.byte 0x03,0x91,0x9e,0x7e,0x1b
	.ascii "yy\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x2f
	.byte 0x03,0x91,0x98,0x7e,0x1b
	.ascii "ymin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x30
	.byte 0x03,0x91,0x94,0x7e,0x1b
	.ascii "ymax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x31
	.byte 0x03,0x91,0x90,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x1a
	.uaword .L5324
	.uaword .L5411
	.byte 0x1a
	.uaword .L5325
	.uaword .L5410
	.byte 0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x77
	.byte 0x03,0x91,0xac,0x7e,0x1b
	.ascii "errorInc\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x78
	.byte 0x03,0x91,0xa8,0x7e,0x1b
	.ascii "error\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x79
	.byte 0x03,0x91,0xa4,0x7e,0x1b
	.ascii "errorDec\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0x7a
	.byte 0x03,0x91,0xa0,0x7e,0x1a
	.uaword .L5334
	.uaword .L5341
	.byte 0x1b
	.ascii "fdyinv\0"
	.byte 0x00,0x00,0x01,0x8a,0x01,0x1f,0x01,0x8f
	.byte 0x03,0x91,0x9c,0x7e,0x00,0x1a
	.uaword .L5342
	.uaword .L5409
	.byte 0x1a
	.uaword .L5348
	.uaword .L5406
	.byte 0x1a
	.uaword .L5349
	.uaword .L5405
	.byte 0x1b
	.ascii "Z\0"
	.byte 0x00,0x00,0x65,0xa8,0x01,0x1f,0x01,0xa1
	.byte 0x03,0x91,0x9e,0x7e,0x1b
	.ascii "xx\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0xaa
	.byte 0x03,0x91,0x98,0x7e,0x1b
	.ascii "xmin\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0xab
	.byte 0x03,0x91,0x94,0x7e,0x1b
	.ascii "xmax\0"
	.byte 0x00,0x00,0x01,0x4b,0x01,0x1f,0x01,0xac
	.byte 0x03,0x91,0x90,0x7e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x1c
	.ascii "null_line\0"
	.byte 0x03,0x01,0x03,0x71
	.uaword null_line
	.uaword .L5435
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xeb,0x00
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xc4,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "v1\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xc8,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "v2\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xcc,0x00,0x1d
	.byte 0x00,0x00,0x01,0x74
	.ascii "pv\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xd0,0x00,0x00
	.byte 0x1e
	.ascii "gl_set_line_function\0"
	.byte 0x01,0x02,0x01,0x03,0x7b
	.uaword gl_set_line_function
	.uaword .L5627
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xeb,0x50
	.byte 0x1d,0x00,0x00,0x9a,0x3f
	.ascii "ctx\0"
	.byte 0x01,0x03,0x7a,0x03,0x91,0xc4,0x00,0x1b
	.ascii "rgbmode\0"
	.byte 0x00,0x00,0x32,0xbd,0x01,0x01,0x03,0x7c
	.byte 0x02,0x91,0x7f,0x00,0x1f
	.ascii "gl_flush_pb\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xeb,0x6b
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x00,0x1f
	.ascii "gl_update_hitflag\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xeb,0x91
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x00,0x11,0x00,0x00,0x01,0x81
	.byte 0x07,0x00,0x00,0xeb,0x91,0x11,0x00,0x00
	.byte 0x01,0x81,0x07,0x00,0x00,0xeb,0x9b,0x1f
	.ascii "gl_feedback_vertex\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xeb,0xea
	.byte 0x13,0x00,0x00,0x3c,0x5d,0x13,0x00,0x00
	.byte 0x01,0x81,0x13,0x00,0x00,0x01,0x81,0x13
	.byte 0x00,0x00,0x01,0x81,0x13,0x00,0x00,0x01
	.byte 0x81,0x13,0x00,0x00,0xeb,0x96,0x13,0x00
	.byte 0x00,0x01,0x81,0x13,0x00,0x00,0xeb,0xa0
	.byte 0x00,0x11,0x00,0x00,0x66,0xdc,0x07,0x00
	.byte 0x00,0xeb,0xea,0x20
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x13,0x00,0x00,0x3c
	.byte 0x5d,0x13,0x00,0x00,0x01,0xb1,0x13,0x00
	.byte 0x00,0xeb,0xef,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=488, siz=4, lab1=gl_LineWidth, lab2=, loff=0
!   reloc[1]: knd=0, off=495, siz=4, lab1=.L18, lab2=, loff=0
!   reloc[2]: knd=0, off=507, siz=4, lab1=.L22, lab2=, loff=0
!   reloc[3]: knd=0, off=515, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[4]: knd=0, off=523, siz=4, lab1=.L30, lab2=, loff=0
!   reloc[5]: knd=0, off=531, siz=4, lab1=.L34, lab2=, loff=0
!   reloc[6]: knd=0, off=539, siz=4, lab1=.L36, lab2=, loff=0
!   reloc[7]: knd=0, off=547, siz=4, lab1=.L40, lab2=, loff=0
!   reloc[8]: knd=0, off=555, siz=4, lab1=.L41, lab2=, loff=0
!   reloc[9]: knd=0, off=563, siz=4, lab1=.L42, lab2=, loff=0
!   reloc[10]: knd=0, off=576, siz=4, lab1=gl_LineStipple, lab2=, loff=0
!   reloc[11]: knd=0, off=583, siz=4, lab1=.L51, lab2=, loff=0
!   reloc[12]: knd=0, off=595, siz=4, lab1=.L55, lab2=, loff=0
!   reloc[13]: knd=0, off=603, siz=4, lab1=.L57, lab2=, loff=0
!   reloc[14]: knd=0, off=611, siz=4, lab1=.L61, lab2=, loff=0
!   reloc[15]: knd=0, off=619, siz=4, lab1=.L68, lab2=, loff=0
!   reloc[16]: knd=0, off=627, siz=4, lab1=.L69, lab2=, loff=0
!   reloc[17]: knd=0, off=635, siz=4, lab1=.L70, lab2=, loff=0
!   reloc[18]: knd=0, off=648, siz=4, lab1=feedback_line, lab2=, loff=0
!   reloc[19]: knd=0, off=655, siz=4, lab1=.L77, lab2=, loff=0
!   reloc[20]: knd=0, off=667, siz=4, lab1=.L78, lab2=, loff=0
!   reloc[21]: knd=0, off=677, siz=4, lab1=.L79, lab2=, loff=0
!   reloc[22]: knd=0, off=685, siz=4, lab1=.L80, lab2=, loff=0
!   reloc[23]: knd=0, off=693, siz=4, lab1=.L81, lab2=, loff=0
!   reloc[24]: knd=0, off=701, siz=4, lab1=.L82, lab2=, loff=0
!   reloc[25]: knd=0, off=709, siz=4, lab1=.L83, lab2=, loff=0
!   reloc[26]: knd=0, off=717, siz=4, lab1=.L84, lab2=, loff=0
!   reloc[27]: knd=0, off=725, siz=4, lab1=.L85, lab2=, loff=0
!   reloc[28]: knd=0, off=733, siz=4, lab1=.L86, lab2=, loff=0
!   reloc[29]: knd=0, off=741, siz=4, lab1=.L87, lab2=, loff=0
!   reloc[30]: knd=0, off=749, siz=4, lab1=.L88, lab2=, loff=0
!   reloc[31]: knd=0, off=757, siz=4, lab1=.L89, lab2=, loff=0
!   reloc[32]: knd=0, off=765, siz=4, lab1=.L90, lab2=, loff=0
!   reloc[33]: knd=0, off=773, siz=4, lab1=.L94, lab2=, loff=0
!   reloc[34]: knd=0, off=781, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[35]: knd=0, off=789, siz=4, lab1=.L96, lab2=, loff=0
!   reloc[36]: knd=0, off=797, siz=4, lab1=.L97, lab2=, loff=0
!   reloc[37]: knd=0, off=805, siz=4, lab1=.L98, lab2=, loff=0
!   reloc[38]: knd=0, off=813, siz=4, lab1=.L102, lab2=, loff=0
!   reloc[39]: knd=0, off=821, siz=4, lab1=.L103, lab2=, loff=0
!   reloc[40]: knd=0, off=829, siz=4, lab1=.L104, lab2=, loff=0
!   reloc[41]: knd=0, off=837, siz=4, lab1=.L105, lab2=, loff=0
!   reloc[42]: knd=0, off=845, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[43]: knd=0, off=853, siz=4, lab1=.L114, lab2=, loff=0
!   reloc[44]: knd=0, off=861, siz=4, lab1=.L128, lab2=, loff=0
!   reloc[45]: knd=0, off=871, siz=4, lab1=.L139, lab2=, loff=0
!   reloc[46]: knd=0, off=881, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[47]: knd=0, off=889, siz=4, lab1=.L141, lab2=, loff=0
!   reloc[48]: knd=0, off=897, siz=4, lab1=.L142, lab2=, loff=0
!   reloc[49]: knd=0, off=905, siz=4, lab1=.L143, lab2=, loff=0
!   reloc[50]: knd=0, off=913, siz=4, lab1=.L144, lab2=, loff=0
!   reloc[51]: knd=0, off=921, siz=4, lab1=.L146, lab2=, loff=0
!   reloc[52]: knd=0, off=931, siz=4, lab1=.L147, lab2=, loff=0
!   reloc[53]: knd=0, off=944, siz=4, lab1=select_line, lab2=, loff=0
!   reloc[54]: knd=0, off=951, siz=4, lab1=.L154, lab2=, loff=0
!   reloc[55]: knd=0, off=963, siz=4, lab1=.L155, lab2=, loff=0
!   reloc[56]: knd=0, off=971, siz=4, lab1=.L156, lab2=, loff=0
!   reloc[57]: knd=0, off=984, siz=4, lab1=flat_ci_line, lab2=, loff=0
!   reloc[58]: knd=0, off=991, siz=4, lab1=.L163, lab2=, loff=0
!   reloc[59]: knd=0, off=1003, siz=4, lab1=.L164, lab2=, loff=0
!   reloc[60]: knd=0, off=1011, siz=4, lab1=.L167, lab2=, loff=0
!   reloc[61]: knd=0, off=1019, siz=4, lab1=.L176, lab2=, loff=0
!   reloc[62]: knd=0, off=1027, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[63]: knd=0, off=1040, siz=4, lab1=.L179, lab2=, loff=0
!   reloc[64]: knd=0, off=1050, siz=4, lab1=.L180, lab2=, loff=0
!   reloc[65]: knd=0, off=1058, siz=4, lab1=.L181, lab2=, loff=0
!   reloc[66]: knd=0, off=1069, siz=4, lab1=.L182, lab2=, loff=0
!   reloc[67]: knd=0, off=1077, siz=4, lab1=.L185, lab2=, loff=0
!   reloc[68]: knd=0, off=1085, siz=4, lab1=.L190, lab2=, loff=0
!   reloc[69]: knd=0, off=1093, siz=4, lab1=.L196, lab2=, loff=0
!   reloc[70]: knd=0, off=1103, siz=4, lab1=.L200, lab2=, loff=0
!   reloc[71]: knd=0, off=1111, siz=4, lab1=.L201, lab2=, loff=0
!   reloc[72]: knd=0, off=1119, siz=4, lab1=.L207, lab2=, loff=0
!   reloc[73]: knd=0, off=1129, siz=4, lab1=.L213, lab2=, loff=0
!   reloc[74]: knd=0, off=1139, siz=4, lab1=.L217, lab2=, loff=0
!   reloc[75]: knd=0, off=1147, siz=4, lab1=.L218, lab2=, loff=0
!   reloc[76]: knd=0, off=1155, siz=4, lab1=.L224, lab2=, loff=0
!   reloc[77]: knd=0, off=1165, siz=4, lab1=.L230, lab2=, loff=0
!   reloc[78]: knd=0, off=1175, siz=4, lab1=.L234, lab2=, loff=0
!   reloc[79]: knd=0, off=1185, siz=4, lab1=.L235, lab2=, loff=0
!   reloc[80]: knd=0, off=1193, siz=4, lab1=.L236, lab2=, loff=0
!   reloc[81]: knd=0, off=1201, siz=4, lab1=.L238, lab2=, loff=0
!   reloc[82]: knd=0, off=1211, siz=4, lab1=.L245, lab2=, loff=0
!   reloc[83]: knd=0, off=1221, siz=4, lab1=.L246, lab2=, loff=0
!   reloc[84]: knd=0, off=1231, siz=4, lab1=.L249, lab2=, loff=0
!   reloc[85]: knd=0, off=1241, siz=4, lab1=.L253, lab2=, loff=0
!   reloc[86]: knd=0, off=1249, siz=4, lab1=.L259, lab2=, loff=0
!   reloc[87]: knd=0, off=1259, siz=4, lab1=.L260, lab2=, loff=0
!   reloc[88]: knd=0, off=1267, siz=4, lab1=.L266, lab2=, loff=0
!   reloc[89]: knd=0, off=1278, siz=4, lab1=.L274, lab2=, loff=0
!   reloc[90]: knd=0, off=1289, siz=4, lab1=.L275, lab2=, loff=0
!   reloc[91]: knd=0, off=1297, siz=4, lab1=.L276, lab2=, loff=0
!   reloc[92]: knd=0, off=1305, siz=4, lab1=.L278, lab2=, loff=0
!   reloc[93]: knd=0, off=1315, siz=4, lab1=.L285, lab2=, loff=0
!   reloc[94]: knd=0, off=1325, siz=4, lab1=.L286, lab2=, loff=0
!   reloc[95]: knd=0, off=1335, siz=4, lab1=.L289, lab2=, loff=0
!   reloc[96]: knd=0, off=1345, siz=4, lab1=.L293, lab2=, loff=0
!   reloc[97]: knd=0, off=1353, siz=4, lab1=.L299, lab2=, loff=0
!   reloc[98]: knd=0, off=1363, siz=4, lab1=.L300, lab2=, loff=0
!   reloc[99]: knd=0, off=1371, siz=4, lab1=.L306, lab2=, loff=0
!   reloc[100]: knd=0, off=1382, siz=4, lab1=.L313, lab2=, loff=0
!   reloc[101]: knd=0, off=1395, siz=4, lab1=.L316, lab2=, loff=0
!   reloc[102]: knd=0, off=1403, siz=4, lab1=.L323, lab2=, loff=0
!   reloc[103]: knd=0, off=1416, siz=4, lab1=flat_ci_z_line, lab2=, loff=0
!   reloc[104]: knd=0, off=1423, siz=4, lab1=.L330, lab2=, loff=0
!   reloc[105]: knd=0, off=1435, siz=4, lab1=.L331, lab2=, loff=0
!   reloc[106]: knd=0, off=1443, siz=4, lab1=.L332, lab2=, loff=0
!   reloc[107]: knd=0, off=1451, siz=4, lab1=.L335, lab2=, loff=0
!   reloc[108]: knd=0, off=1459, siz=4, lab1=.L344, lab2=, loff=0
!   reloc[109]: knd=0, off=1467, siz=4, lab1=.L346, lab2=, loff=0
!   reloc[110]: knd=0, off=1480, siz=4, lab1=.L347, lab2=, loff=0
!   reloc[111]: knd=0, off=1490, siz=4, lab1=.L348, lab2=, loff=0
!   reloc[112]: knd=0, off=1498, siz=4, lab1=.L349, lab2=, loff=0
!   reloc[113]: knd=0, off=1509, siz=4, lab1=.L350, lab2=, loff=0
!   reloc[114]: knd=0, off=1517, siz=4, lab1=.L353, lab2=, loff=0
!   reloc[115]: knd=0, off=1525, siz=4, lab1=.L358, lab2=, loff=0
!   reloc[116]: knd=0, off=1533, siz=4, lab1=.L362, lab2=, loff=0
!   reloc[117]: knd=0, off=1543, siz=4, lab1=.L363, lab2=, loff=0
!   reloc[118]: knd=0, off=1551, siz=4, lab1=.L364, lab2=, loff=0
!   reloc[119]: knd=0, off=1559, siz=4, lab1=.L367, lab2=, loff=0
!   reloc[120]: knd=0, off=1569, siz=4, lab1=.L371, lab2=, loff=0
!   reloc[121]: knd=0, off=1577, siz=4, lab1=.L372, lab2=, loff=0
!   reloc[122]: knd=0, off=1585, siz=4, lab1=.L373, lab2=, loff=0
!   reloc[123]: knd=0, off=1595, siz=4, lab1=.L379, lab2=, loff=0
!   reloc[124]: knd=0, off=1605, siz=4, lab1=.L380, lab2=, loff=0
!   reloc[125]: knd=0, off=1615, siz=4, lab1=.L386, lab2=, loff=0
!   reloc[126]: knd=0, off=1625, siz=4, lab1=.L390, lab2=, loff=0
!   reloc[127]: knd=0, off=1633, siz=4, lab1=.L391, lab2=, loff=0
!   reloc[128]: knd=0, off=1641, siz=4, lab1=.L392, lab2=, loff=0
!   reloc[129]: knd=0, off=1651, siz=4, lab1=.L398, lab2=, loff=0
!   reloc[130]: knd=0, off=1661, siz=4, lab1=.L399, lab2=, loff=0
!   reloc[131]: knd=0, off=1671, siz=4, lab1=.L405, lab2=, loff=0
!   reloc[132]: knd=0, off=1681, siz=4, lab1=.L409, lab2=, loff=0
!   reloc[133]: knd=0, off=1691, siz=4, lab1=.L410, lab2=, loff=0
!   reloc[134]: knd=0, off=1699, siz=4, lab1=.L411, lab2=, loff=0
!   reloc[135]: knd=0, off=1707, siz=4, lab1=.L412, lab2=, loff=0
!   reloc[136]: knd=0, off=1715, siz=4, lab1=.L414, lab2=, loff=0
!   reloc[137]: knd=0, off=1725, siz=4, lab1=.L421, lab2=, loff=0
!   reloc[138]: knd=0, off=1735, siz=4, lab1=.L422, lab2=, loff=0
!   reloc[139]: knd=0, off=1745, siz=4, lab1=.L423, lab2=, loff=0
!   reloc[140]: knd=0, off=1755, siz=4, lab1=.L424, lab2=, loff=0
!   reloc[141]: knd=0, off=1765, siz=4, lab1=.L425, lab2=, loff=0
!   reloc[142]: knd=0, off=1773, siz=4, lab1=.L428, lab2=, loff=0
!   reloc[143]: knd=0, off=1783, siz=4, lab1=.L432, lab2=, loff=0
!   reloc[144]: knd=0, off=1791, siz=4, lab1=.L438, lab2=, loff=0
!   reloc[145]: knd=0, off=1801, siz=4, lab1=.L439, lab2=, loff=0
!   reloc[146]: knd=0, off=1809, siz=4, lab1=.L440, lab2=, loff=0
!   reloc[147]: knd=0, off=1819, siz=4, lab1=.L446, lab2=, loff=0
!   reloc[148]: knd=0, off=1830, siz=4, lab1=.L454, lab2=, loff=0
!   reloc[149]: knd=0, off=1841, siz=4, lab1=.L455, lab2=, loff=0
!   reloc[150]: knd=0, off=1849, siz=4, lab1=.L456, lab2=, loff=0
!   reloc[151]: knd=0, off=1857, siz=4, lab1=.L457, lab2=, loff=0
!   reloc[152]: knd=0, off=1865, siz=4, lab1=.L459, lab2=, loff=0
!   reloc[153]: knd=0, off=1875, siz=4, lab1=.L466, lab2=, loff=0
!   reloc[154]: knd=0, off=1885, siz=4, lab1=.L467, lab2=, loff=0
!   reloc[155]: knd=0, off=1895, siz=4, lab1=.L468, lab2=, loff=0
!   reloc[156]: knd=0, off=1905, siz=4, lab1=.L469, lab2=, loff=0
!   reloc[157]: knd=0, off=1915, siz=4, lab1=.L470, lab2=, loff=0
!   reloc[158]: knd=0, off=1923, siz=4, lab1=.L473, lab2=, loff=0
!   reloc[159]: knd=0, off=1933, siz=4, lab1=.L477, lab2=, loff=0
!   reloc[160]: knd=0, off=1941, siz=4, lab1=.L483, lab2=, loff=0
!   reloc[161]: knd=0, off=1951, siz=4, lab1=.L484, lab2=, loff=0
!   reloc[162]: knd=0, off=1959, siz=4, lab1=.L485, lab2=, loff=0
!   reloc[163]: knd=0, off=1969, siz=4, lab1=.L491, lab2=, loff=0
!   reloc[164]: knd=0, off=1980, siz=4, lab1=.L498, lab2=, loff=0
!   reloc[165]: knd=0, off=1993, siz=4, lab1=.L501, lab2=, loff=0
!   reloc[166]: knd=0, off=2001, siz=4, lab1=.L508, lab2=, loff=0
!   reloc[167]: knd=0, off=2014, siz=4, lab1=flat_rgba_line, lab2=, loff=0
!   reloc[168]: knd=0, off=2021, siz=4, lab1=.L515, lab2=, loff=0
!   reloc[169]: knd=0, off=2033, siz=4, lab1=.L516, lab2=, loff=0
!   reloc[170]: knd=0, off=2041, siz=4, lab1=.L517, lab2=, loff=0
!   reloc[171]: knd=0, off=2049, siz=4, lab1=.L520, lab2=, loff=0
!   reloc[172]: knd=0, off=2057, siz=4, lab1=.L532, lab2=, loff=0
!   reloc[173]: knd=0, off=2065, siz=4, lab1=.L534, lab2=, loff=0
!   reloc[174]: knd=0, off=2078, siz=4, lab1=.L535, lab2=, loff=0
!   reloc[175]: knd=0, off=2088, siz=4, lab1=.L536, lab2=, loff=0
!   reloc[176]: knd=0, off=2096, siz=4, lab1=.L537, lab2=, loff=0
!   reloc[177]: knd=0, off=2107, siz=4, lab1=.L538, lab2=, loff=0
!   reloc[178]: knd=0, off=2115, siz=4, lab1=.L541, lab2=, loff=0
!   reloc[179]: knd=0, off=2123, siz=4, lab1=.L546, lab2=, loff=0
!   reloc[180]: knd=0, off=2131, siz=4, lab1=.L552, lab2=, loff=0
!   reloc[181]: knd=0, off=2141, siz=4, lab1=.L556, lab2=, loff=0
!   reloc[182]: knd=0, off=2149, siz=4, lab1=.L557, lab2=, loff=0
!   reloc[183]: knd=0, off=2157, siz=4, lab1=.L563, lab2=, loff=0
!   reloc[184]: knd=0, off=2167, siz=4, lab1=.L569, lab2=, loff=0
!   reloc[185]: knd=0, off=2177, siz=4, lab1=.L573, lab2=, loff=0
!   reloc[186]: knd=0, off=2185, siz=4, lab1=.L574, lab2=, loff=0
!   reloc[187]: knd=0, off=2193, siz=4, lab1=.L580, lab2=, loff=0
!   reloc[188]: knd=0, off=2203, siz=4, lab1=.L586, lab2=, loff=0
!   reloc[189]: knd=0, off=2213, siz=4, lab1=.L590, lab2=, loff=0
!   reloc[190]: knd=0, off=2223, siz=4, lab1=.L591, lab2=, loff=0
!   reloc[191]: knd=0, off=2231, siz=4, lab1=.L592, lab2=, loff=0
!   reloc[192]: knd=0, off=2239, siz=4, lab1=.L594, lab2=, loff=0
!   reloc[193]: knd=0, off=2249, siz=4, lab1=.L601, lab2=, loff=0
!   reloc[194]: knd=0, off=2259, siz=4, lab1=.L602, lab2=, loff=0
!   reloc[195]: knd=0, off=2269, siz=4, lab1=.L605, lab2=, loff=0
!   reloc[196]: knd=0, off=2279, siz=4, lab1=.L609, lab2=, loff=0
!   reloc[197]: knd=0, off=2287, siz=4, lab1=.L615, lab2=, loff=0
!   reloc[198]: knd=0, off=2297, siz=4, lab1=.L616, lab2=, loff=0
!   reloc[199]: knd=0, off=2305, siz=4, lab1=.L622, lab2=, loff=0
!   reloc[200]: knd=0, off=2316, siz=4, lab1=.L630, lab2=, loff=0
!   reloc[201]: knd=0, off=2327, siz=4, lab1=.L631, lab2=, loff=0
!   reloc[202]: knd=0, off=2335, siz=4, lab1=.L632, lab2=, loff=0
!   reloc[203]: knd=0, off=2343, siz=4, lab1=.L634, lab2=, loff=0
!   reloc[204]: knd=0, off=2353, siz=4, lab1=.L641, lab2=, loff=0
!   reloc[205]: knd=0, off=2363, siz=4, lab1=.L642, lab2=, loff=0
!   reloc[206]: knd=0, off=2373, siz=4, lab1=.L645, lab2=, loff=0
!   reloc[207]: knd=0, off=2383, siz=4, lab1=.L649, lab2=, loff=0
!   reloc[208]: knd=0, off=2391, siz=4, lab1=.L655, lab2=, loff=0
!   reloc[209]: knd=0, off=2401, siz=4, lab1=.L656, lab2=, loff=0
!   reloc[210]: knd=0, off=2409, siz=4, lab1=.L662, lab2=, loff=0
!   reloc[211]: knd=0, off=2420, siz=4, lab1=.L669, lab2=, loff=0
!   reloc[212]: knd=0, off=2433, siz=4, lab1=.L672, lab2=, loff=0
!   reloc[213]: knd=0, off=2441, siz=4, lab1=.L679, lab2=, loff=0
!   reloc[214]: knd=0, off=2454, siz=4, lab1=flat_rgba_z_line, lab2=, loff=0
!   reloc[215]: knd=0, off=2461, siz=4, lab1=.L686, lab2=, loff=0
!   reloc[216]: knd=0, off=2473, siz=4, lab1=.L687, lab2=, loff=0
!   reloc[217]: knd=0, off=2481, siz=4, lab1=.L688, lab2=, loff=0
!   reloc[218]: knd=0, off=2489, siz=4, lab1=.L689, lab2=, loff=0
!   reloc[219]: knd=0, off=2497, siz=4, lab1=.L692, lab2=, loff=0
!   reloc[220]: knd=0, off=2505, siz=4, lab1=.L704, lab2=, loff=0
!   reloc[221]: knd=0, off=2513, siz=4, lab1=.L706, lab2=, loff=0
!   reloc[222]: knd=0, off=2526, siz=4, lab1=.L707, lab2=, loff=0
!   reloc[223]: knd=0, off=2536, siz=4, lab1=.L708, lab2=, loff=0
!   reloc[224]: knd=0, off=2544, siz=4, lab1=.L709, lab2=, loff=0
!   reloc[225]: knd=0, off=2555, siz=4, lab1=.L710, lab2=, loff=0
!   reloc[226]: knd=0, off=2563, siz=4, lab1=.L713, lab2=, loff=0
!   reloc[227]: knd=0, off=2571, siz=4, lab1=.L718, lab2=, loff=0
!   reloc[228]: knd=0, off=2579, siz=4, lab1=.L722, lab2=, loff=0
!   reloc[229]: knd=0, off=2589, siz=4, lab1=.L723, lab2=, loff=0
!   reloc[230]: knd=0, off=2597, siz=4, lab1=.L724, lab2=, loff=0
!   reloc[231]: knd=0, off=2605, siz=4, lab1=.L727, lab2=, loff=0
!   reloc[232]: knd=0, off=2615, siz=4, lab1=.L731, lab2=, loff=0
!   reloc[233]: knd=0, off=2623, siz=4, lab1=.L732, lab2=, loff=0
!   reloc[234]: knd=0, off=2631, siz=4, lab1=.L733, lab2=, loff=0
!   reloc[235]: knd=0, off=2641, siz=4, lab1=.L739, lab2=, loff=0
!   reloc[236]: knd=0, off=2651, siz=4, lab1=.L740, lab2=, loff=0
!   reloc[237]: knd=0, off=2661, siz=4, lab1=.L746, lab2=, loff=0
!   reloc[238]: knd=0, off=2671, siz=4, lab1=.L750, lab2=, loff=0
!   reloc[239]: knd=0, off=2679, siz=4, lab1=.L751, lab2=, loff=0
!   reloc[240]: knd=0, off=2687, siz=4, lab1=.L752, lab2=, loff=0
!   reloc[241]: knd=0, off=2697, siz=4, lab1=.L758, lab2=, loff=0
!   reloc[242]: knd=0, off=2707, siz=4, lab1=.L759, lab2=, loff=0
!   reloc[243]: knd=0, off=2717, siz=4, lab1=.L765, lab2=, loff=0
!   reloc[244]: knd=0, off=2727, siz=4, lab1=.L769, lab2=, loff=0
!   reloc[245]: knd=0, off=2737, siz=4, lab1=.L770, lab2=, loff=0
!   reloc[246]: knd=0, off=2745, siz=4, lab1=.L771, lab2=, loff=0
!   reloc[247]: knd=0, off=2753, siz=4, lab1=.L772, lab2=, loff=0
!   reloc[248]: knd=0, off=2761, siz=4, lab1=.L774, lab2=, loff=0
!   reloc[249]: knd=0, off=2771, siz=4, lab1=.L781, lab2=, loff=0
!   reloc[250]: knd=0, off=2781, siz=4, lab1=.L782, lab2=, loff=0
!   reloc[251]: knd=0, off=2791, siz=4, lab1=.L783, lab2=, loff=0
!   reloc[252]: knd=0, off=2801, siz=4, lab1=.L784, lab2=, loff=0
!   reloc[253]: knd=0, off=2811, siz=4, lab1=.L785, lab2=, loff=0
!   reloc[254]: knd=0, off=2819, siz=4, lab1=.L788, lab2=, loff=0
!   reloc[255]: knd=0, off=2829, siz=4, lab1=.L792, lab2=, loff=0
!   reloc[256]: knd=0, off=2837, siz=4, lab1=.L798, lab2=, loff=0
!   reloc[257]: knd=0, off=2847, siz=4, lab1=.L799, lab2=, loff=0
!   reloc[258]: knd=0, off=2855, siz=4, lab1=.L800, lab2=, loff=0
!   reloc[259]: knd=0, off=2865, siz=4, lab1=.L806, lab2=, loff=0
!   reloc[260]: knd=0, off=2876, siz=4, lab1=.L814, lab2=, loff=0
!   reloc[261]: knd=0, off=2887, siz=4, lab1=.L815, lab2=, loff=0
!   reloc[262]: knd=0, off=2895, siz=4, lab1=.L816, lab2=, loff=0
!   reloc[263]: knd=0, off=2903, siz=4, lab1=.L817, lab2=, loff=0
!   reloc[264]: knd=0, off=2911, siz=4, lab1=.L819, lab2=, loff=0
!   reloc[265]: knd=0, off=2921, siz=4, lab1=.L826, lab2=, loff=0
!   reloc[266]: knd=0, off=2931, siz=4, lab1=.L827, lab2=, loff=0
!   reloc[267]: knd=0, off=2941, siz=4, lab1=.L828, lab2=, loff=0
!   reloc[268]: knd=0, off=2951, siz=4, lab1=.L829, lab2=, loff=0
!   reloc[269]: knd=0, off=2961, siz=4, lab1=.L830, lab2=, loff=0
!   reloc[270]: knd=0, off=2969, siz=4, lab1=.L833, lab2=, loff=0
!   reloc[271]: knd=0, off=2979, siz=4, lab1=.L837, lab2=, loff=0
!   reloc[272]: knd=0, off=2987, siz=4, lab1=.L843, lab2=, loff=0
!   reloc[273]: knd=0, off=2997, siz=4, lab1=.L844, lab2=, loff=0
!   reloc[274]: knd=0, off=3005, siz=4, lab1=.L845, lab2=, loff=0
!   reloc[275]: knd=0, off=3015, siz=4, lab1=.L851, lab2=, loff=0
!   reloc[276]: knd=0, off=3026, siz=4, lab1=.L858, lab2=, loff=0
!   reloc[277]: knd=0, off=3039, siz=4, lab1=.L861, lab2=, loff=0
!   reloc[278]: knd=0, off=3047, siz=4, lab1=.L868, lab2=, loff=0
!   reloc[279]: knd=0, off=3060, siz=4, lab1=smooth_ci_line, lab2=, loff=0
!   reloc[280]: knd=0, off=3067, siz=4, lab1=.L875, lab2=, loff=0
!   reloc[281]: knd=0, off=3079, siz=4, lab1=.L876, lab2=, loff=0
!   reloc[282]: knd=0, off=3087, siz=4, lab1=.L877, lab2=, loff=0
!   reloc[283]: knd=0, off=3095, siz=4, lab1=.L878, lab2=, loff=0
!   reloc[284]: knd=0, off=3103, siz=4, lab1=.L880, lab2=, loff=0
!   reloc[285]: knd=0, off=3116, siz=4, lab1=.L881, lab2=, loff=0
!   reloc[286]: knd=0, off=3126, siz=4, lab1=.L882, lab2=, loff=0
!   reloc[287]: knd=0, off=3134, siz=4, lab1=.L883, lab2=, loff=0
!   reloc[288]: knd=0, off=3144, siz=4, lab1=.L884, lab2=, loff=0
!   reloc[289]: knd=0, off=3154, siz=4, lab1=.L885, lab2=, loff=0
!   reloc[290]: knd=0, off=3162, siz=4, lab1=.L888, lab2=, loff=0
!   reloc[291]: knd=0, off=3170, siz=4, lab1=.L893, lab2=, loff=0
!   reloc[292]: knd=0, off=3178, siz=4, lab1=.L899, lab2=, loff=0
!   reloc[293]: knd=0, off=3188, siz=4, lab1=.L903, lab2=, loff=0
!   reloc[294]: knd=0, off=3196, siz=4, lab1=.L904, lab2=, loff=0
!   reloc[295]: knd=0, off=3204, siz=4, lab1=.L910, lab2=, loff=0
!   reloc[296]: knd=0, off=3214, siz=4, lab1=.L916, lab2=, loff=0
!   reloc[297]: knd=0, off=3224, siz=4, lab1=.L920, lab2=, loff=0
!   reloc[298]: knd=0, off=3232, siz=4, lab1=.L921, lab2=, loff=0
!   reloc[299]: knd=0, off=3240, siz=4, lab1=.L927, lab2=, loff=0
!   reloc[300]: knd=0, off=3250, siz=4, lab1=.L933, lab2=, loff=0
!   reloc[301]: knd=0, off=3260, siz=4, lab1=.L937, lab2=, loff=0
!   reloc[302]: knd=0, off=3270, siz=4, lab1=.L938, lab2=, loff=0
!   reloc[303]: knd=0, off=3278, siz=4, lab1=.L939, lab2=, loff=0
!   reloc[304]: knd=0, off=3286, siz=4, lab1=.L940, lab2=, loff=0
!   reloc[305]: knd=0, off=3296, siz=4, lab1=.L942, lab2=, loff=0
!   reloc[306]: knd=0, off=3306, siz=4, lab1=.L949, lab2=, loff=0
!   reloc[307]: knd=0, off=3316, siz=4, lab1=.L950, lab2=, loff=0
!   reloc[308]: knd=0, off=3326, siz=4, lab1=.L951, lab2=, loff=0
!   reloc[309]: knd=0, off=3336, siz=4, lab1=.L952, lab2=, loff=0
!   reloc[310]: knd=0, off=3346, siz=4, lab1=.L955, lab2=, loff=0
!   reloc[311]: knd=0, off=3356, siz=4, lab1=.L959, lab2=, loff=0
!   reloc[312]: knd=0, off=3364, siz=4, lab1=.L965, lab2=, loff=0
!   reloc[313]: knd=0, off=3374, siz=4, lab1=.L966, lab2=, loff=0
!   reloc[314]: knd=0, off=3382, siz=4, lab1=.L972, lab2=, loff=0
!   reloc[315]: knd=0, off=3393, siz=4, lab1=.L980, lab2=, loff=0
!   reloc[316]: knd=0, off=3404, siz=4, lab1=.L981, lab2=, loff=0
!   reloc[317]: knd=0, off=3412, siz=4, lab1=.L982, lab2=, loff=0
!   reloc[318]: knd=0, off=3420, siz=4, lab1=.L983, lab2=, loff=0
!   reloc[319]: knd=0, off=3430, siz=4, lab1=.L985, lab2=, loff=0
!   reloc[320]: knd=0, off=3440, siz=4, lab1=.L992, lab2=, loff=0
!   reloc[321]: knd=0, off=3450, siz=4, lab1=.L993, lab2=, loff=0
!   reloc[322]: knd=0, off=3460, siz=4, lab1=.L994, lab2=, loff=0
!   reloc[323]: knd=0, off=3470, siz=4, lab1=.L995, lab2=, loff=0
!   reloc[324]: knd=0, off=3480, siz=4, lab1=.L998, lab2=, loff=0
!   reloc[325]: knd=0, off=3490, siz=4, lab1=.L1002, lab2=, loff=0
!   reloc[326]: knd=0, off=3498, siz=4, lab1=.L1008, lab2=, loff=0
!   reloc[327]: knd=0, off=3508, siz=4, lab1=.L1009, lab2=, loff=0
!   reloc[328]: knd=0, off=3516, siz=4, lab1=.L1015, lab2=, loff=0
!   reloc[329]: knd=0, off=3527, siz=4, lab1=.L1022, lab2=, loff=0
!   reloc[330]: knd=0, off=3539, siz=4, lab1=.L1025, lab2=, loff=0
!   reloc[331]: knd=0, off=3547, siz=4, lab1=.L1032, lab2=, loff=0
!   reloc[332]: knd=0, off=3560, siz=4, lab1=smooth_ci_z_line, lab2=, loff=0
!   reloc[333]: knd=0, off=3567, siz=4, lab1=.L1039, lab2=, loff=0
!   reloc[334]: knd=0, off=3579, siz=4, lab1=.L1040, lab2=, loff=0
!   reloc[335]: knd=0, off=3587, siz=4, lab1=.L1041, lab2=, loff=0
!   reloc[336]: knd=0, off=3595, siz=4, lab1=.L1042, lab2=, loff=0
!   reloc[337]: knd=0, off=3603, siz=4, lab1=.L1043, lab2=, loff=0
!   reloc[338]: knd=0, off=3611, siz=4, lab1=.L1045, lab2=, loff=0
!   reloc[339]: knd=0, off=3624, siz=4, lab1=.L1046, lab2=, loff=0
!   reloc[340]: knd=0, off=3634, siz=4, lab1=.L1047, lab2=, loff=0
!   reloc[341]: knd=0, off=3642, siz=4, lab1=.L1048, lab2=, loff=0
!   reloc[342]: knd=0, off=3652, siz=4, lab1=.L1049, lab2=, loff=0
!   reloc[343]: knd=0, off=3662, siz=4, lab1=.L1050, lab2=, loff=0
!   reloc[344]: knd=0, off=3670, siz=4, lab1=.L1053, lab2=, loff=0
!   reloc[345]: knd=0, off=3678, siz=4, lab1=.L1058, lab2=, loff=0
!   reloc[346]: knd=0, off=3686, siz=4, lab1=.L1062, lab2=, loff=0
!   reloc[347]: knd=0, off=3696, siz=4, lab1=.L1063, lab2=, loff=0
!   reloc[348]: knd=0, off=3704, siz=4, lab1=.L1064, lab2=, loff=0
!   reloc[349]: knd=0, off=3712, siz=4, lab1=.L1067, lab2=, loff=0
!   reloc[350]: knd=0, off=3722, siz=4, lab1=.L1071, lab2=, loff=0
!   reloc[351]: knd=0, off=3730, siz=4, lab1=.L1072, lab2=, loff=0
!   reloc[352]: knd=0, off=3738, siz=4, lab1=.L1073, lab2=, loff=0
!   reloc[353]: knd=0, off=3748, siz=4, lab1=.L1079, lab2=, loff=0
!   reloc[354]: knd=0, off=3758, siz=4, lab1=.L1080, lab2=, loff=0
!   reloc[355]: knd=0, off=3768, siz=4, lab1=.L1086, lab2=, loff=0
!   reloc[356]: knd=0, off=3778, siz=4, lab1=.L1090, lab2=, loff=0
!   reloc[357]: knd=0, off=3786, siz=4, lab1=.L1091, lab2=, loff=0
!   reloc[358]: knd=0, off=3794, siz=4, lab1=.L1092, lab2=, loff=0
!   reloc[359]: knd=0, off=3804, siz=4, lab1=.L1098, lab2=, loff=0
!   reloc[360]: knd=0, off=3814, siz=4, lab1=.L1099, lab2=, loff=0
!   reloc[361]: knd=0, off=3824, siz=4, lab1=.L1105, lab2=, loff=0
!   reloc[362]: knd=0, off=3834, siz=4, lab1=.L1109, lab2=, loff=0
!   reloc[363]: knd=0, off=3844, siz=4, lab1=.L1110, lab2=, loff=0
!   reloc[364]: knd=0, off=3852, siz=4, lab1=.L1111, lab2=, loff=0
!   reloc[365]: knd=0, off=3860, siz=4, lab1=.L1112, lab2=, loff=0
!   reloc[366]: knd=0, off=3868, siz=4, lab1=.L1113, lab2=, loff=0
!   reloc[367]: knd=0, off=3878, siz=4, lab1=.L1115, lab2=, loff=0
!   reloc[368]: knd=0, off=3888, siz=4, lab1=.L1122, lab2=, loff=0
!   reloc[369]: knd=0, off=3898, siz=4, lab1=.L1123, lab2=, loff=0
!   reloc[370]: knd=0, off=3908, siz=4, lab1=.L1124, lab2=, loff=0
!   reloc[371]: knd=0, off=3918, siz=4, lab1=.L1125, lab2=, loff=0
!   reloc[372]: knd=0, off=3928, siz=4, lab1=.L1126, lab2=, loff=0
!   reloc[373]: knd=0, off=3938, siz=4, lab1=.L1127, lab2=, loff=0
!   reloc[374]: knd=0, off=3946, siz=4, lab1=.L1128, lab2=, loff=0
!   reloc[375]: knd=0, off=3956, siz=4, lab1=.L1131, lab2=, loff=0
!   reloc[376]: knd=0, off=3966, siz=4, lab1=.L1135, lab2=, loff=0
!   reloc[377]: knd=0, off=3974, siz=4, lab1=.L1141, lab2=, loff=0
!   reloc[378]: knd=0, off=3984, siz=4, lab1=.L1142, lab2=, loff=0
!   reloc[379]: knd=0, off=3992, siz=4, lab1=.L1143, lab2=, loff=0
!   reloc[380]: knd=0, off=4002, siz=4, lab1=.L1149, lab2=, loff=0
!   reloc[381]: knd=0, off=4013, siz=4, lab1=.L1157, lab2=, loff=0
!   reloc[382]: knd=0, off=4024, siz=4, lab1=.L1158, lab2=, loff=0
!   reloc[383]: knd=0, off=4032, siz=4, lab1=.L1159, lab2=, loff=0
!   reloc[384]: knd=0, off=4040, siz=4, lab1=.L1160, lab2=, loff=0
!   reloc[385]: knd=0, off=4048, siz=4, lab1=.L1161, lab2=, loff=0
!   reloc[386]: knd=0, off=4058, siz=4, lab1=.L1163, lab2=, loff=0
!   reloc[387]: knd=0, off=4068, siz=4, lab1=.L1170, lab2=, loff=0
!   reloc[388]: knd=0, off=4078, siz=4, lab1=.L1171, lab2=, loff=0
!   reloc[389]: knd=0, off=4088, siz=4, lab1=.L1172, lab2=, loff=0
!   reloc[390]: knd=0, off=4098, siz=4, lab1=.L1173, lab2=, loff=0
!   reloc[391]: knd=0, off=4108, siz=4, lab1=.L1174, lab2=, loff=0
!   reloc[392]: knd=0, off=4118, siz=4, lab1=.L1175, lab2=, loff=0
!   reloc[393]: knd=0, off=4126, siz=4, lab1=.L1176, lab2=, loff=0
!   reloc[394]: knd=0, off=4136, siz=4, lab1=.L1179, lab2=, loff=0
!   reloc[395]: knd=0, off=4146, siz=4, lab1=.L1183, lab2=, loff=0
!   reloc[396]: knd=0, off=4154, siz=4, lab1=.L1189, lab2=, loff=0
!   reloc[397]: knd=0, off=4164, siz=4, lab1=.L1190, lab2=, loff=0
!   reloc[398]: knd=0, off=4172, siz=4, lab1=.L1191, lab2=, loff=0
!   reloc[399]: knd=0, off=4182, siz=4, lab1=.L1197, lab2=, loff=0
!   reloc[400]: knd=0, off=4193, siz=4, lab1=.L1204, lab2=, loff=0
!   reloc[401]: knd=0, off=4205, siz=4, lab1=.L1207, lab2=, loff=0
!   reloc[402]: knd=0, off=4213, siz=4, lab1=.L1214, lab2=, loff=0
!   reloc[403]: knd=0, off=4226, siz=4, lab1=smooth_rgba_line, lab2=, loff=0
!   reloc[404]: knd=0, off=4233, siz=4, lab1=.L1221, lab2=, loff=0
!   reloc[405]: knd=0, off=4245, siz=4, lab1=.L1222, lab2=, loff=0
!   reloc[406]: knd=0, off=4253, siz=4, lab1=.L1223, lab2=, loff=0
!   reloc[407]: knd=0, off=4261, siz=4, lab1=.L1224, lab2=, loff=0
!   reloc[408]: knd=0, off=4269, siz=4, lab1=.L1225, lab2=, loff=0
!   reloc[409]: knd=0, off=4277, siz=4, lab1=.L1226, lab2=, loff=0
!   reloc[410]: knd=0, off=4285, siz=4, lab1=.L1227, lab2=, loff=0
!   reloc[411]: knd=0, off=4293, siz=4, lab1=.L1229, lab2=, loff=0
!   reloc[412]: knd=0, off=4306, siz=4, lab1=.L1230, lab2=, loff=0
!   reloc[413]: knd=0, off=4316, siz=4, lab1=.L1231, lab2=, loff=0
!   reloc[414]: knd=0, off=4324, siz=4, lab1=.L1232, lab2=, loff=0
!   reloc[415]: knd=0, off=4334, siz=4, lab1=.L1233, lab2=, loff=0
!   reloc[416]: knd=0, off=4342, siz=4, lab1=.L1234, lab2=, loff=0
!   reloc[417]: knd=0, off=4350, siz=4, lab1=.L1235, lab2=, loff=0
!   reloc[418]: knd=0, off=4358, siz=4, lab1=.L1236, lab2=, loff=0
!   reloc[419]: knd=0, off=4366, siz=4, lab1=.L1237, lab2=, loff=0
!   reloc[420]: knd=0, off=4374, siz=4, lab1=.L1238, lab2=, loff=0
!   reloc[421]: knd=0, off=4384, siz=4, lab1=.L1239, lab2=, loff=0
!   reloc[422]: knd=0, off=4392, siz=4, lab1=.L1240, lab2=, loff=0
!   reloc[423]: knd=0, off=4402, siz=4, lab1=.L1241, lab2=, loff=0
!   reloc[424]: knd=0, off=4410, siz=4, lab1=.L1244, lab2=, loff=0
!   reloc[425]: knd=0, off=4418, siz=4, lab1=.L1249, lab2=, loff=0
!   reloc[426]: knd=0, off=4426, siz=4, lab1=.L1255, lab2=, loff=0
!   reloc[427]: knd=0, off=4436, siz=4, lab1=.L1259, lab2=, loff=0
!   reloc[428]: knd=0, off=4444, siz=4, lab1=.L1260, lab2=, loff=0
!   reloc[429]: knd=0, off=4452, siz=4, lab1=.L1266, lab2=, loff=0
!   reloc[430]: knd=0, off=4462, siz=4, lab1=.L1272, lab2=, loff=0
!   reloc[431]: knd=0, off=4472, siz=4, lab1=.L1276, lab2=, loff=0
!   reloc[432]: knd=0, off=4480, siz=4, lab1=.L1277, lab2=, loff=0
!   reloc[433]: knd=0, off=4488, siz=4, lab1=.L1283, lab2=, loff=0
!   reloc[434]: knd=0, off=4498, siz=4, lab1=.L1289, lab2=, loff=0
!   reloc[435]: knd=0, off=4508, siz=4, lab1=.L1293, lab2=, loff=0
!   reloc[436]: knd=0, off=4518, siz=4, lab1=.L1294, lab2=, loff=0
!   reloc[437]: knd=0, off=4526, siz=4, lab1=.L1295, lab2=, loff=0
!   reloc[438]: knd=0, off=4534, siz=4, lab1=.L1296, lab2=, loff=0
!   reloc[439]: knd=0, off=4544, siz=4, lab1=.L1297, lab2=, loff=0
!   reloc[440]: knd=0, off=4552, siz=4, lab1=.L1298, lab2=, loff=0
!   reloc[441]: knd=0, off=4560, siz=4, lab1=.L1299, lab2=, loff=0
!   reloc[442]: knd=0, off=4570, siz=4, lab1=.L1301, lab2=, loff=0
!   reloc[443]: knd=0, off=4580, siz=4, lab1=.L1308, lab2=, loff=0
!   reloc[444]: knd=0, off=4590, siz=4, lab1=.L1309, lab2=, loff=0
!   reloc[445]: knd=0, off=4600, siz=4, lab1=.L1310, lab2=, loff=0
!   reloc[446]: knd=0, off=4610, siz=4, lab1=.L1311, lab2=, loff=0
!   reloc[447]: knd=0, off=4618, siz=4, lab1=.L1312, lab2=, loff=0
!   reloc[448]: knd=0, off=4626, siz=4, lab1=.L1313, lab2=, loff=0
!   reloc[449]: knd=0, off=4636, siz=4, lab1=.L1316, lab2=, loff=0
!   reloc[450]: knd=0, off=4646, siz=4, lab1=.L1320, lab2=, loff=0
!   reloc[451]: knd=0, off=4654, siz=4, lab1=.L1326, lab2=, loff=0
!   reloc[452]: knd=0, off=4664, siz=4, lab1=.L1327, lab2=, loff=0
!   reloc[453]: knd=0, off=4672, siz=4, lab1=.L1333, lab2=, loff=0
!   reloc[454]: knd=0, off=4683, siz=4, lab1=.L1341, lab2=, loff=0
!   reloc[455]: knd=0, off=4694, siz=4, lab1=.L1342, lab2=, loff=0
!   reloc[456]: knd=0, off=4702, siz=4, lab1=.L1343, lab2=, loff=0
!   reloc[457]: knd=0, off=4710, siz=4, lab1=.L1344, lab2=, loff=0
!   reloc[458]: knd=0, off=4720, siz=4, lab1=.L1345, lab2=, loff=0
!   reloc[459]: knd=0, off=4728, siz=4, lab1=.L1346, lab2=, loff=0
!   reloc[460]: knd=0, off=4736, siz=4, lab1=.L1347, lab2=, loff=0
!   reloc[461]: knd=0, off=4746, siz=4, lab1=.L1349, lab2=, loff=0
!   reloc[462]: knd=0, off=4756, siz=4, lab1=.L1356, lab2=, loff=0
!   reloc[463]: knd=0, off=4766, siz=4, lab1=.L1357, lab2=, loff=0
!   reloc[464]: knd=0, off=4776, siz=4, lab1=.L1358, lab2=, loff=0
!   reloc[465]: knd=0, off=4786, siz=4, lab1=.L1359, lab2=, loff=0
!   reloc[466]: knd=0, off=4794, siz=4, lab1=.L1360, lab2=, loff=0
!   reloc[467]: knd=0, off=4802, siz=4, lab1=.L1361, lab2=, loff=0
!   reloc[468]: knd=0, off=4812, siz=4, lab1=.L1364, lab2=, loff=0
!   reloc[469]: knd=0, off=4822, siz=4, lab1=.L1368, lab2=, loff=0
!   reloc[470]: knd=0, off=4830, siz=4, lab1=.L1374, lab2=, loff=0
!   reloc[471]: knd=0, off=4840, siz=4, lab1=.L1375, lab2=, loff=0
!   reloc[472]: knd=0, off=4848, siz=4, lab1=.L1381, lab2=, loff=0
!   reloc[473]: knd=0, off=4859, siz=4, lab1=.L1388, lab2=, loff=0
!   reloc[474]: knd=0, off=4871, siz=4, lab1=.L1391, lab2=, loff=0
!   reloc[475]: knd=0, off=4879, siz=4, lab1=.L1398, lab2=, loff=0
!   reloc[476]: knd=0, off=4892, siz=4, lab1=smooth_rgba_z_line, lab2=, loff=0
!   reloc[477]: knd=0, off=4899, siz=4, lab1=.L1405, lab2=, loff=0
!   reloc[478]: knd=0, off=4911, siz=4, lab1=.L1406, lab2=, loff=0
!   reloc[479]: knd=0, off=4919, siz=4, lab1=.L1407, lab2=, loff=0
!   reloc[480]: knd=0, off=4927, siz=4, lab1=.L1408, lab2=, loff=0
!   reloc[481]: knd=0, off=4935, siz=4, lab1=.L1409, lab2=, loff=0
!   reloc[482]: knd=0, off=4943, siz=4, lab1=.L1410, lab2=, loff=0
!   reloc[483]: knd=0, off=4951, siz=4, lab1=.L1411, lab2=, loff=0
!   reloc[484]: knd=0, off=4959, siz=4, lab1=.L1412, lab2=, loff=0
!   reloc[485]: knd=0, off=4967, siz=4, lab1=.L1414, lab2=, loff=0
!   reloc[486]: knd=0, off=4980, siz=4, lab1=.L1415, lab2=, loff=0
!   reloc[487]: knd=0, off=4990, siz=4, lab1=.L1416, lab2=, loff=0
!   reloc[488]: knd=0, off=4998, siz=4, lab1=.L1417, lab2=, loff=0
!   reloc[489]: knd=0, off=5008, siz=4, lab1=.L1418, lab2=, loff=0
!   reloc[490]: knd=0, off=5016, siz=4, lab1=.L1419, lab2=, loff=0
!   reloc[491]: knd=0, off=5024, siz=4, lab1=.L1420, lab2=, loff=0
!   reloc[492]: knd=0, off=5032, siz=4, lab1=.L1421, lab2=, loff=0
!   reloc[493]: knd=0, off=5040, siz=4, lab1=.L1422, lab2=, loff=0
!   reloc[494]: knd=0, off=5048, siz=4, lab1=.L1423, lab2=, loff=0
!   reloc[495]: knd=0, off=5058, siz=4, lab1=.L1424, lab2=, loff=0
!   reloc[496]: knd=0, off=5066, siz=4, lab1=.L1425, lab2=, loff=0
!   reloc[497]: knd=0, off=5076, siz=4, lab1=.L1426, lab2=, loff=0
!   reloc[498]: knd=0, off=5084, siz=4, lab1=.L1429, lab2=, loff=0
!   reloc[499]: knd=0, off=5092, siz=4, lab1=.L1434, lab2=, loff=0
!   reloc[500]: knd=0, off=5100, siz=4, lab1=.L1438, lab2=, loff=0
!   reloc[501]: knd=0, off=5110, siz=4, lab1=.L1439, lab2=, loff=0
!   reloc[502]: knd=0, off=5118, siz=4, lab1=.L1440, lab2=, loff=0
!   reloc[503]: knd=0, off=5126, siz=4, lab1=.L1443, lab2=, loff=0
!   reloc[504]: knd=0, off=5136, siz=4, lab1=.L1447, lab2=, loff=0
!   reloc[505]: knd=0, off=5144, siz=4, lab1=.L1448, lab2=, loff=0
!   reloc[506]: knd=0, off=5152, siz=4, lab1=.L1449, lab2=, loff=0
!   reloc[507]: knd=0, off=5162, siz=4, lab1=.L1455, lab2=, loff=0
!   reloc[508]: knd=0, off=5172, siz=4, lab1=.L1456, lab2=, loff=0
!   reloc[509]: knd=0, off=5182, siz=4, lab1=.L1462, lab2=, loff=0
!   reloc[510]: knd=0, off=5192, siz=4, lab1=.L1466, lab2=, loff=0
!   reloc[511]: knd=0, off=5200, siz=4, lab1=.L1467, lab2=, loff=0
!   reloc[512]: knd=0, off=5208, siz=4, lab1=.L1468, lab2=, loff=0
!   reloc[513]: knd=0, off=5218, siz=4, lab1=.L1474, lab2=, loff=0
!   reloc[514]: knd=0, off=5228, siz=4, lab1=.L1475, lab2=, loff=0
!   reloc[515]: knd=0, off=5238, siz=4, lab1=.L1481, lab2=, loff=0
!   reloc[516]: knd=0, off=5248, siz=4, lab1=.L1485, lab2=, loff=0
!   reloc[517]: knd=0, off=5258, siz=4, lab1=.L1486, lab2=, loff=0
!   reloc[518]: knd=0, off=5266, siz=4, lab1=.L1487, lab2=, loff=0
!   reloc[519]: knd=0, off=5274, siz=4, lab1=.L1488, lab2=, loff=0
!   reloc[520]: knd=0, off=5282, siz=4, lab1=.L1489, lab2=, loff=0
!   reloc[521]: knd=0, off=5292, siz=4, lab1=.L1490, lab2=, loff=0
!   reloc[522]: knd=0, off=5300, siz=4, lab1=.L1491, lab2=, loff=0
!   reloc[523]: knd=0, off=5308, siz=4, lab1=.L1492, lab2=, loff=0
!   reloc[524]: knd=0, off=5318, siz=4, lab1=.L1494, lab2=, loff=0
!   reloc[525]: knd=0, off=5328, siz=4, lab1=.L1501, lab2=, loff=0
!   reloc[526]: knd=0, off=5338, siz=4, lab1=.L1502, lab2=, loff=0
!   reloc[527]: knd=0, off=5348, siz=4, lab1=.L1503, lab2=, loff=0
!   reloc[528]: knd=0, off=5358, siz=4, lab1=.L1504, lab2=, loff=0
!   reloc[529]: knd=0, off=5368, siz=4, lab1=.L1505, lab2=, loff=0
!   reloc[530]: knd=0, off=5376, siz=4, lab1=.L1506, lab2=, loff=0
!   reloc[531]: knd=0, off=5386, siz=4, lab1=.L1507, lab2=, loff=0
!   reloc[532]: knd=0, off=5394, siz=4, lab1=.L1508, lab2=, loff=0
!   reloc[533]: knd=0, off=5402, siz=4, lab1=.L1509, lab2=, loff=0
!   reloc[534]: knd=0, off=5412, siz=4, lab1=.L1512, lab2=, loff=0
!   reloc[535]: knd=0, off=5422, siz=4, lab1=.L1516, lab2=, loff=0
!   reloc[536]: knd=0, off=5430, siz=4, lab1=.L1522, lab2=, loff=0
!   reloc[537]: knd=0, off=5440, siz=4, lab1=.L1523, lab2=, loff=0
!   reloc[538]: knd=0, off=5448, siz=4, lab1=.L1524, lab2=, loff=0
!   reloc[539]: knd=0, off=5458, siz=4, lab1=.L1530, lab2=, loff=0
!   reloc[540]: knd=0, off=5469, siz=4, lab1=.L1538, lab2=, loff=0
!   reloc[541]: knd=0, off=5480, siz=4, lab1=.L1539, lab2=, loff=0
!   reloc[542]: knd=0, off=5488, siz=4, lab1=.L1540, lab2=, loff=0
!   reloc[543]: knd=0, off=5496, siz=4, lab1=.L1541, lab2=, loff=0
!   reloc[544]: knd=0, off=5504, siz=4, lab1=.L1542, lab2=, loff=0
!   reloc[545]: knd=0, off=5514, siz=4, lab1=.L1543, lab2=, loff=0
!   reloc[546]: knd=0, off=5522, siz=4, lab1=.L1544, lab2=, loff=0
!   reloc[547]: knd=0, off=5530, siz=4, lab1=.L1545, lab2=, loff=0
!   reloc[548]: knd=0, off=5540, siz=4, lab1=.L1547, lab2=, loff=0
!   reloc[549]: knd=0, off=5550, siz=4, lab1=.L1554, lab2=, loff=0
!   reloc[550]: knd=0, off=5560, siz=4, lab1=.L1555, lab2=, loff=0
!   reloc[551]: knd=0, off=5570, siz=4, lab1=.L1556, lab2=, loff=0
!   reloc[552]: knd=0, off=5580, siz=4, lab1=.L1557, lab2=, loff=0
!   reloc[553]: knd=0, off=5590, siz=4, lab1=.L1558, lab2=, loff=0
!   reloc[554]: knd=0, off=5598, siz=4, lab1=.L1559, lab2=, loff=0
!   reloc[555]: knd=0, off=5608, siz=4, lab1=.L1560, lab2=, loff=0
!   reloc[556]: knd=0, off=5616, siz=4, lab1=.L1561, lab2=, loff=0
!   reloc[557]: knd=0, off=5624, siz=4, lab1=.L1562, lab2=, loff=0
!   reloc[558]: knd=0, off=5634, siz=4, lab1=.L1565, lab2=, loff=0
!   reloc[559]: knd=0, off=5644, siz=4, lab1=.L1569, lab2=, loff=0
!   reloc[560]: knd=0, off=5652, siz=4, lab1=.L1575, lab2=, loff=0
!   reloc[561]: knd=0, off=5662, siz=4, lab1=.L1576, lab2=, loff=0
!   reloc[562]: knd=0, off=5670, siz=4, lab1=.L1577, lab2=, loff=0
!   reloc[563]: knd=0, off=5680, siz=4, lab1=.L1583, lab2=, loff=0
!   reloc[564]: knd=0, off=5691, siz=4, lab1=.L1590, lab2=, loff=0
!   reloc[565]: knd=0, off=5703, siz=4, lab1=.L1593, lab2=, loff=0
!   reloc[566]: knd=0, off=5711, siz=4, lab1=.L1600, lab2=, loff=0
!   reloc[567]: knd=0, off=5724, siz=4, lab1=general_smooth_ci_line, lab2=, loff=0
!   reloc[568]: knd=0, off=5731, siz=4, lab1=.L1607, lab2=, loff=0
!   reloc[569]: knd=0, off=5743, siz=4, lab1=.L1608, lab2=, loff=0
!   reloc[570]: knd=0, off=5751, siz=4, lab1=.L1609, lab2=, loff=0
!   reloc[571]: knd=0, off=5759, siz=4, lab1=.L1610, lab2=, loff=0
!   reloc[572]: knd=0, off=5767, siz=4, lab1=.L1611, lab2=, loff=0
!   reloc[573]: knd=0, off=5775, siz=4, lab1=.L1614, lab2=, loff=0
!   reloc[574]: knd=0, off=5783, siz=4, lab1=.L1619, lab2=, loff=0
!   reloc[575]: knd=0, off=5796, siz=4, lab1=.L1620, lab2=, loff=0
!   reloc[576]: knd=0, off=5806, siz=4, lab1=.L1621, lab2=, loff=0
!   reloc[577]: knd=0, off=5814, siz=4, lab1=.L1622, lab2=, loff=0
!   reloc[578]: knd=0, off=5824, siz=4, lab1=.L1623, lab2=, loff=0
!   reloc[579]: knd=0, off=5834, siz=4, lab1=.L1630, lab2=, loff=0
!   reloc[580]: knd=0, off=5842, siz=4, lab1=.L1631, lab2=, loff=0
!   reloc[581]: knd=0, off=5850, siz=4, lab1=.L1632, lab2=, loff=0
!   reloc[582]: knd=0, off=5860, siz=4, lab1=.L1633, lab2=, loff=0
!   reloc[583]: knd=0, off=5868, siz=4, lab1=.L1636, lab2=, loff=0
!   reloc[584]: knd=0, off=5876, siz=4, lab1=.L1641, lab2=, loff=0
!   reloc[585]: knd=0, off=5884, siz=4, lab1=.L1645, lab2=, loff=0
!   reloc[586]: knd=0, off=5894, siz=4, lab1=.L1646, lab2=, loff=0
!   reloc[587]: knd=0, off=5902, siz=4, lab1=.L1647, lab2=, loff=0
!   reloc[588]: knd=0, off=5910, siz=4, lab1=.L1650, lab2=, loff=0
!   reloc[589]: knd=0, off=5920, siz=4, lab1=.L1654, lab2=, loff=0
!   reloc[590]: knd=0, off=5928, siz=4, lab1=.L1655, lab2=, loff=0
!   reloc[591]: knd=0, off=5936, siz=4, lab1=.L1656, lab2=, loff=0
!   reloc[592]: knd=0, off=5946, siz=4, lab1=.L1662, lab2=, loff=0
!   reloc[593]: knd=0, off=5956, siz=4, lab1=.L1663, lab2=, loff=0
!   reloc[594]: knd=0, off=5966, siz=4, lab1=.L1669, lab2=, loff=0
!   reloc[595]: knd=0, off=5976, siz=4, lab1=.L1673, lab2=, loff=0
!   reloc[596]: knd=0, off=5984, siz=4, lab1=.L1674, lab2=, loff=0
!   reloc[597]: knd=0, off=5992, siz=4, lab1=.L1675, lab2=, loff=0
!   reloc[598]: knd=0, off=6002, siz=4, lab1=.L1681, lab2=, loff=0
!   reloc[599]: knd=0, off=6012, siz=4, lab1=.L1682, lab2=, loff=0
!   reloc[600]: knd=0, off=6022, siz=4, lab1=.L1688, lab2=, loff=0
!   reloc[601]: knd=0, off=6032, siz=4, lab1=.L1692, lab2=, loff=0
!   reloc[602]: knd=0, off=6042, siz=4, lab1=.L1693, lab2=, loff=0
!   reloc[603]: knd=0, off=6050, siz=4, lab1=.L1694, lab2=, loff=0
!   reloc[604]: knd=0, off=6058, siz=4, lab1=.L1695, lab2=, loff=0
!   reloc[605]: knd=0, off=6066, siz=4, lab1=.L1696, lab2=, loff=0
!   reloc[606]: knd=0, off=6076, siz=4, lab1=.L1698, lab2=, loff=0
!   reloc[607]: knd=0, off=6086, siz=4, lab1=.L1705, lab2=, loff=0
!   reloc[608]: knd=0, off=6096, siz=4, lab1=.L1708, lab2=, loff=0
!   reloc[609]: knd=0, off=6104, siz=4, lab1=.L1712, lab2=, loff=0
!   reloc[610]: knd=0, off=6114, siz=4, lab1=.L1713, lab2=, loff=0
!   reloc[611]: knd=0, off=6124, siz=4, lab1=.L1714, lab2=, loff=0
!   reloc[612]: knd=0, off=6134, siz=4, lab1=.L1715, lab2=, loff=0
!   reloc[613]: knd=0, off=6142, siz=4, lab1=.L1717, lab2=, loff=0
!   reloc[614]: knd=0, off=6150, siz=4, lab1=.L1724, lab2=, loff=0
!   reloc[615]: knd=0, off=6158, siz=4, lab1=.L1735, lab2=, loff=0
!   reloc[616]: knd=0, off=6166, siz=4, lab1=.L1741, lab2=, loff=0
!   reloc[617]: knd=0, off=6176, siz=4, lab1=.L1742, lab2=, loff=0
!   reloc[618]: knd=0, off=6186, siz=4, lab1=.L1743, lab2=, loff=0
!   reloc[619]: knd=0, off=6196, siz=4, lab1=.L1744, lab2=, loff=0
!   reloc[620]: knd=0, off=6204, siz=4, lab1=.L1745, lab2=, loff=0
!   reloc[621]: knd=0, off=6214, siz=4, lab1=.L1748, lab2=, loff=0
!   reloc[622]: knd=0, off=6224, siz=4, lab1=.L1752, lab2=, loff=0
!   reloc[623]: knd=0, off=6232, siz=4, lab1=.L1758, lab2=, loff=0
!   reloc[624]: knd=0, off=6242, siz=4, lab1=.L1759, lab2=, loff=0
!   reloc[625]: knd=0, off=6250, siz=4, lab1=.L1760, lab2=, loff=0
!   reloc[626]: knd=0, off=6260, siz=4, lab1=.L1766, lab2=, loff=0
!   reloc[627]: knd=0, off=6271, siz=4, lab1=.L1774, lab2=, loff=0
!   reloc[628]: knd=0, off=6282, siz=4, lab1=.L1775, lab2=, loff=0
!   reloc[629]: knd=0, off=6290, siz=4, lab1=.L1776, lab2=, loff=0
!   reloc[630]: knd=0, off=6298, siz=4, lab1=.L1777, lab2=, loff=0
!   reloc[631]: knd=0, off=6306, siz=4, lab1=.L1778, lab2=, loff=0
!   reloc[632]: knd=0, off=6316, siz=4, lab1=.L1780, lab2=, loff=0
!   reloc[633]: knd=0, off=6326, siz=4, lab1=.L1787, lab2=, loff=0
!   reloc[634]: knd=0, off=6336, siz=4, lab1=.L1790, lab2=, loff=0
!   reloc[635]: knd=0, off=6344, siz=4, lab1=.L1794, lab2=, loff=0
!   reloc[636]: knd=0, off=6354, siz=4, lab1=.L1795, lab2=, loff=0
!   reloc[637]: knd=0, off=6364, siz=4, lab1=.L1796, lab2=, loff=0
!   reloc[638]: knd=0, off=6374, siz=4, lab1=.L1797, lab2=, loff=0
!   reloc[639]: knd=0, off=6382, siz=4, lab1=.L1799, lab2=, loff=0
!   reloc[640]: knd=0, off=6390, siz=4, lab1=.L1806, lab2=, loff=0
!   reloc[641]: knd=0, off=6398, siz=4, lab1=.L1817, lab2=, loff=0
!   reloc[642]: knd=0, off=6406, siz=4, lab1=.L1823, lab2=, loff=0
!   reloc[643]: knd=0, off=6416, siz=4, lab1=.L1824, lab2=, loff=0
!   reloc[644]: knd=0, off=6426, siz=4, lab1=.L1825, lab2=, loff=0
!   reloc[645]: knd=0, off=6436, siz=4, lab1=.L1826, lab2=, loff=0
!   reloc[646]: knd=0, off=6444, siz=4, lab1=.L1827, lab2=, loff=0
!   reloc[647]: knd=0, off=6454, siz=4, lab1=.L1830, lab2=, loff=0
!   reloc[648]: knd=0, off=6464, siz=4, lab1=.L1834, lab2=, loff=0
!   reloc[649]: knd=0, off=6472, siz=4, lab1=.L1840, lab2=, loff=0
!   reloc[650]: knd=0, off=6482, siz=4, lab1=.L1841, lab2=, loff=0
!   reloc[651]: knd=0, off=6490, siz=4, lab1=.L1842, lab2=, loff=0
!   reloc[652]: knd=0, off=6500, siz=4, lab1=.L1848, lab2=, loff=0
!   reloc[653]: knd=0, off=6511, siz=4, lab1=.L1862, lab2=, loff=0
!   reloc[654]: knd=0, off=6524, siz=4, lab1=.L1867, lab2=, loff=0
!   reloc[655]: knd=0, off=6537, siz=4, lab1=.L1868, lab2=, loff=0
!   reloc[656]: knd=0, off=6547, siz=4, lab1=.L1869, lab2=, loff=0
!   reloc[657]: knd=0, off=6555, siz=4, lab1=.L1870, lab2=, loff=0
!   reloc[658]: knd=0, off=6565, siz=4, lab1=.L1871, lab2=, loff=0
!   reloc[659]: knd=0, off=6575, siz=4, lab1=.L1872, lab2=, loff=0
!   reloc[660]: knd=0, off=6583, siz=4, lab1=.L1875, lab2=, loff=0
!   reloc[661]: knd=0, off=6591, siz=4, lab1=.L1880, lab2=, loff=0
!   reloc[662]: knd=0, off=6599, siz=4, lab1=.L1884, lab2=, loff=0
!   reloc[663]: knd=0, off=6609, siz=4, lab1=.L1885, lab2=, loff=0
!   reloc[664]: knd=0, off=6617, siz=4, lab1=.L1886, lab2=, loff=0
!   reloc[665]: knd=0, off=6625, siz=4, lab1=.L1889, lab2=, loff=0
!   reloc[666]: knd=0, off=6635, siz=4, lab1=.L1893, lab2=, loff=0
!   reloc[667]: knd=0, off=6643, siz=4, lab1=.L1894, lab2=, loff=0
!   reloc[668]: knd=0, off=6651, siz=4, lab1=.L1895, lab2=, loff=0
!   reloc[669]: knd=0, off=6661, siz=4, lab1=.L1901, lab2=, loff=0
!   reloc[670]: knd=0, off=6671, siz=4, lab1=.L1902, lab2=, loff=0
!   reloc[671]: knd=0, off=6681, siz=4, lab1=.L1908, lab2=, loff=0
!   reloc[672]: knd=0, off=6691, siz=4, lab1=.L1912, lab2=, loff=0
!   reloc[673]: knd=0, off=6699, siz=4, lab1=.L1913, lab2=, loff=0
!   reloc[674]: knd=0, off=6707, siz=4, lab1=.L1914, lab2=, loff=0
!   reloc[675]: knd=0, off=6717, siz=4, lab1=.L1920, lab2=, loff=0
!   reloc[676]: knd=0, off=6727, siz=4, lab1=.L1921, lab2=, loff=0
!   reloc[677]: knd=0, off=6737, siz=4, lab1=.L1927, lab2=, loff=0
!   reloc[678]: knd=0, off=6747, siz=4, lab1=.L1931, lab2=, loff=0
!   reloc[679]: knd=0, off=6757, siz=4, lab1=.L1932, lab2=, loff=0
!   reloc[680]: knd=0, off=6765, siz=4, lab1=.L1933, lab2=, loff=0
!   reloc[681]: knd=0, off=6773, siz=4, lab1=.L1934, lab2=, loff=0
!   reloc[682]: knd=0, off=6781, siz=4, lab1=.L1935, lab2=, loff=0
!   reloc[683]: knd=0, off=6791, siz=4, lab1=.L1937, lab2=, loff=0
!   reloc[684]: knd=0, off=6801, siz=4, lab1=.L1944, lab2=, loff=0
!   reloc[685]: knd=0, off=6811, siz=4, lab1=.L1945, lab2=, loff=0
!   reloc[686]: knd=0, off=6821, siz=4, lab1=.L1946, lab2=, loff=0
!   reloc[687]: knd=0, off=6831, siz=4, lab1=.L1947, lab2=, loff=0
!   reloc[688]: knd=0, off=6841, siz=4, lab1=.L1948, lab2=, loff=0
!   reloc[689]: knd=0, off=6851, siz=4, lab1=.L1949, lab2=, loff=0
!   reloc[690]: knd=0, off=6859, siz=4, lab1=.L1950, lab2=, loff=0
!   reloc[691]: knd=0, off=6869, siz=4, lab1=.L1953, lab2=, loff=0
!   reloc[692]: knd=0, off=6879, siz=4, lab1=.L1957, lab2=, loff=0
!   reloc[693]: knd=0, off=6887, siz=4, lab1=.L1963, lab2=, loff=0
!   reloc[694]: knd=0, off=6897, siz=4, lab1=.L1964, lab2=, loff=0
!   reloc[695]: knd=0, off=6905, siz=4, lab1=.L1965, lab2=, loff=0
!   reloc[696]: knd=0, off=6915, siz=4, lab1=.L1971, lab2=, loff=0
!   reloc[697]: knd=0, off=6926, siz=4, lab1=.L1979, lab2=, loff=0
!   reloc[698]: knd=0, off=6937, siz=4, lab1=.L1980, lab2=, loff=0
!   reloc[699]: knd=0, off=6945, siz=4, lab1=.L1981, lab2=, loff=0
!   reloc[700]: knd=0, off=6953, siz=4, lab1=.L1982, lab2=, loff=0
!   reloc[701]: knd=0, off=6961, siz=4, lab1=.L1983, lab2=, loff=0
!   reloc[702]: knd=0, off=6971, siz=4, lab1=.L1985, lab2=, loff=0
!   reloc[703]: knd=0, off=6981, siz=4, lab1=.L1992, lab2=, loff=0
!   reloc[704]: knd=0, off=6991, siz=4, lab1=.L1993, lab2=, loff=0
!   reloc[705]: knd=0, off=7001, siz=4, lab1=.L1994, lab2=, loff=0
!   reloc[706]: knd=0, off=7011, siz=4, lab1=.L1995, lab2=, loff=0
!   reloc[707]: knd=0, off=7021, siz=4, lab1=.L1996, lab2=, loff=0
!   reloc[708]: knd=0, off=7031, siz=4, lab1=.L1997, lab2=, loff=0
!   reloc[709]: knd=0, off=7039, siz=4, lab1=.L1998, lab2=, loff=0
!   reloc[710]: knd=0, off=7049, siz=4, lab1=.L2001, lab2=, loff=0
!   reloc[711]: knd=0, off=7059, siz=4, lab1=.L2005, lab2=, loff=0
!   reloc[712]: knd=0, off=7067, siz=4, lab1=.L2011, lab2=, loff=0
!   reloc[713]: knd=0, off=7077, siz=4, lab1=.L2012, lab2=, loff=0
!   reloc[714]: knd=0, off=7085, siz=4, lab1=.L2013, lab2=, loff=0
!   reloc[715]: knd=0, off=7095, siz=4, lab1=.L2019, lab2=, loff=0
!   reloc[716]: knd=0, off=7106, siz=4, lab1=.L2032, lab2=, loff=0
!   reloc[717]: knd=0, off=7119, siz=4, lab1=.L2033, lab2=, loff=0
!   reloc[718]: knd=0, off=7129, siz=4, lab1=.L2034, lab2=, loff=0
!   reloc[719]: knd=0, off=7137, siz=4, lab1=.L2035, lab2=, loff=0
!   reloc[720]: knd=0, off=7147, siz=4, lab1=.L2036, lab2=, loff=0
!   reloc[721]: knd=0, off=7157, siz=4, lab1=.L2043, lab2=, loff=0
!   reloc[722]: knd=0, off=7165, siz=4, lab1=.L2044, lab2=, loff=0
!   reloc[723]: knd=0, off=7173, siz=4, lab1=.L2045, lab2=, loff=0
!   reloc[724]: knd=0, off=7183, siz=4, lab1=.L2046, lab2=, loff=0
!   reloc[725]: knd=0, off=7191, siz=4, lab1=.L2049, lab2=, loff=0
!   reloc[726]: knd=0, off=7199, siz=4, lab1=.L2054, lab2=, loff=0
!   reloc[727]: knd=0, off=7207, siz=4, lab1=.L2058, lab2=, loff=0
!   reloc[728]: knd=0, off=7217, siz=4, lab1=.L2059, lab2=, loff=0
!   reloc[729]: knd=0, off=7225, siz=4, lab1=.L2060, lab2=, loff=0
!   reloc[730]: knd=0, off=7233, siz=4, lab1=.L2063, lab2=, loff=0
!   reloc[731]: knd=0, off=7243, siz=4, lab1=.L2067, lab2=, loff=0
!   reloc[732]: knd=0, off=7251, siz=4, lab1=.L2068, lab2=, loff=0
!   reloc[733]: knd=0, off=7259, siz=4, lab1=.L2069, lab2=, loff=0
!   reloc[734]: knd=0, off=7269, siz=4, lab1=.L2075, lab2=, loff=0
!   reloc[735]: knd=0, off=7279, siz=4, lab1=.L2076, lab2=, loff=0
!   reloc[736]: knd=0, off=7289, siz=4, lab1=.L2082, lab2=, loff=0
!   reloc[737]: knd=0, off=7299, siz=4, lab1=.L2086, lab2=, loff=0
!   reloc[738]: knd=0, off=7307, siz=4, lab1=.L2087, lab2=, loff=0
!   reloc[739]: knd=0, off=7315, siz=4, lab1=.L2088, lab2=, loff=0
!   reloc[740]: knd=0, off=7325, siz=4, lab1=.L2094, lab2=, loff=0
!   reloc[741]: knd=0, off=7335, siz=4, lab1=.L2095, lab2=, loff=0
!   reloc[742]: knd=0, off=7345, siz=4, lab1=.L2101, lab2=, loff=0
!   reloc[743]: knd=0, off=7355, siz=4, lab1=.L2105, lab2=, loff=0
!   reloc[744]: knd=0, off=7365, siz=4, lab1=.L2106, lab2=, loff=0
!   reloc[745]: knd=0, off=7373, siz=4, lab1=.L2107, lab2=, loff=0
!   reloc[746]: knd=0, off=7381, siz=4, lab1=.L2108, lab2=, loff=0
!   reloc[747]: knd=0, off=7389, siz=4, lab1=.L2109, lab2=, loff=0
!   reloc[748]: knd=0, off=7399, siz=4, lab1=.L2111, lab2=, loff=0
!   reloc[749]: knd=0, off=7409, siz=4, lab1=.L2118, lab2=, loff=0
!   reloc[750]: knd=0, off=7419, siz=4, lab1=.L2119, lab2=, loff=0
!   reloc[751]: knd=0, off=7429, siz=4, lab1=.L2120, lab2=, loff=0
!   reloc[752]: knd=0, off=7439, siz=4, lab1=.L2121, lab2=, loff=0
!   reloc[753]: knd=0, off=7447, siz=4, lab1=.L2123, lab2=, loff=0
!   reloc[754]: knd=0, off=7455, siz=4, lab1=.L2130, lab2=, loff=0
!   reloc[755]: knd=0, off=7463, siz=4, lab1=.L2141, lab2=, loff=0
!   reloc[756]: knd=0, off=7471, siz=4, lab1=.L2144, lab2=, loff=0
!   reloc[757]: knd=0, off=7481, siz=4, lab1=.L2145, lab2=, loff=0
!   reloc[758]: knd=0, off=7491, siz=4, lab1=.L2146, lab2=, loff=0
!   reloc[759]: knd=0, off=7499, siz=4, lab1=.L2147, lab2=, loff=0
!   reloc[760]: knd=0, off=7509, siz=4, lab1=.L2150, lab2=, loff=0
!   reloc[761]: knd=0, off=7519, siz=4, lab1=.L2154, lab2=, loff=0
!   reloc[762]: knd=0, off=7527, siz=4, lab1=.L2160, lab2=, loff=0
!   reloc[763]: knd=0, off=7537, siz=4, lab1=.L2161, lab2=, loff=0
!   reloc[764]: knd=0, off=7545, siz=4, lab1=.L2162, lab2=, loff=0
!   reloc[765]: knd=0, off=7555, siz=4, lab1=.L2168, lab2=, loff=0
!   reloc[766]: knd=0, off=7566, siz=4, lab1=.L2176, lab2=, loff=0
!   reloc[767]: knd=0, off=7577, siz=4, lab1=.L2177, lab2=, loff=0
!   reloc[768]: knd=0, off=7585, siz=4, lab1=.L2178, lab2=, loff=0
!   reloc[769]: knd=0, off=7593, siz=4, lab1=.L2179, lab2=, loff=0
!   reloc[770]: knd=0, off=7601, siz=4, lab1=.L2180, lab2=, loff=0
!   reloc[771]: knd=0, off=7611, siz=4, lab1=.L2182, lab2=, loff=0
!   reloc[772]: knd=0, off=7621, siz=4, lab1=.L2189, lab2=, loff=0
!   reloc[773]: knd=0, off=7631, siz=4, lab1=.L2190, lab2=, loff=0
!   reloc[774]: knd=0, off=7641, siz=4, lab1=.L2191, lab2=, loff=0
!   reloc[775]: knd=0, off=7651, siz=4, lab1=.L2192, lab2=, loff=0
!   reloc[776]: knd=0, off=7659, siz=4, lab1=.L2194, lab2=, loff=0
!   reloc[777]: knd=0, off=7667, siz=4, lab1=.L2201, lab2=, loff=0
!   reloc[778]: knd=0, off=7675, siz=4, lab1=.L2212, lab2=, loff=0
!   reloc[779]: knd=0, off=7683, siz=4, lab1=.L2215, lab2=, loff=0
!   reloc[780]: knd=0, off=7693, siz=4, lab1=.L2216, lab2=, loff=0
!   reloc[781]: knd=0, off=7703, siz=4, lab1=.L2217, lab2=, loff=0
!   reloc[782]: knd=0, off=7711, siz=4, lab1=.L2218, lab2=, loff=0
!   reloc[783]: knd=0, off=7721, siz=4, lab1=.L2221, lab2=, loff=0
!   reloc[784]: knd=0, off=7731, siz=4, lab1=.L2225, lab2=, loff=0
!   reloc[785]: knd=0, off=7739, siz=4, lab1=.L2231, lab2=, loff=0
!   reloc[786]: knd=0, off=7749, siz=4, lab1=.L2232, lab2=, loff=0
!   reloc[787]: knd=0, off=7757, siz=4, lab1=.L2233, lab2=, loff=0
!   reloc[788]: knd=0, off=7767, siz=4, lab1=.L2239, lab2=, loff=0
!   reloc[789]: knd=0, off=7778, siz=4, lab1=.L2252, lab2=, loff=0
!   reloc[790]: knd=0, off=7791, siz=4, lab1=.L2255, lab2=, loff=0
!   reloc[791]: knd=0, off=7799, siz=4, lab1=.L2262, lab2=, loff=0
!   reloc[792]: knd=0, off=7812, siz=4, lab1=general_flat_ci_line, lab2=, loff=0
!   reloc[793]: knd=0, off=7819, siz=4, lab1=.L2269, lab2=, loff=0
!   reloc[794]: knd=0, off=7831, siz=4, lab1=.L2270, lab2=, loff=0
!   reloc[795]: knd=0, off=7839, siz=4, lab1=.L2271, lab2=, loff=0
!   reloc[796]: knd=0, off=7847, siz=4, lab1=.L2274, lab2=, loff=0
!   reloc[797]: knd=0, off=7855, siz=4, lab1=.L2283, lab2=, loff=0
!   reloc[798]: knd=0, off=7863, siz=4, lab1=.L2286, lab2=, loff=0
!   reloc[799]: knd=0, off=7871, siz=4, lab1=.L2291, lab2=, loff=0
!   reloc[800]: knd=0, off=7884, siz=4, lab1=.L2292, lab2=, loff=0
!   reloc[801]: knd=0, off=7894, siz=4, lab1=.L2293, lab2=, loff=0
!   reloc[802]: knd=0, off=7902, siz=4, lab1=.L2294, lab2=, loff=0
!   reloc[803]: knd=0, off=7912, siz=4, lab1=.L2301, lab2=, loff=0
!   reloc[804]: knd=0, off=7920, siz=4, lab1=.L2302, lab2=, loff=0
!   reloc[805]: knd=0, off=7928, siz=4, lab1=.L2303, lab2=, loff=0
!   reloc[806]: knd=0, off=7938, siz=4, lab1=.L2304, lab2=, loff=0
!   reloc[807]: knd=0, off=7946, siz=4, lab1=.L2307, lab2=, loff=0
!   reloc[808]: knd=0, off=7954, siz=4, lab1=.L2312, lab2=, loff=0
!   reloc[809]: knd=0, off=7962, siz=4, lab1=.L2316, lab2=, loff=0
!   reloc[810]: knd=0, off=7972, siz=4, lab1=.L2317, lab2=, loff=0
!   reloc[811]: knd=0, off=7980, siz=4, lab1=.L2318, lab2=, loff=0
!   reloc[812]: knd=0, off=7988, siz=4, lab1=.L2321, lab2=, loff=0
!   reloc[813]: knd=0, off=7998, siz=4, lab1=.L2325, lab2=, loff=0
!   reloc[814]: knd=0, off=8006, siz=4, lab1=.L2326, lab2=, loff=0
!   reloc[815]: knd=0, off=8014, siz=4, lab1=.L2327, lab2=, loff=0
!   reloc[816]: knd=0, off=8024, siz=4, lab1=.L2333, lab2=, loff=0
!   reloc[817]: knd=0, off=8034, siz=4, lab1=.L2334, lab2=, loff=0
!   reloc[818]: knd=0, off=8044, siz=4, lab1=.L2340, lab2=, loff=0
!   reloc[819]: knd=0, off=8054, siz=4, lab1=.L2344, lab2=, loff=0
!   reloc[820]: knd=0, off=8062, siz=4, lab1=.L2345, lab2=, loff=0
!   reloc[821]: knd=0, off=8070, siz=4, lab1=.L2346, lab2=, loff=0
!   reloc[822]: knd=0, off=8080, siz=4, lab1=.L2352, lab2=, loff=0
!   reloc[823]: knd=0, off=8090, siz=4, lab1=.L2353, lab2=, loff=0
!   reloc[824]: knd=0, off=8100, siz=4, lab1=.L2359, lab2=, loff=0
!   reloc[825]: knd=0, off=8110, siz=4, lab1=.L2363, lab2=, loff=0
!   reloc[826]: knd=0, off=8120, siz=4, lab1=.L2364, lab2=, loff=0
!   reloc[827]: knd=0, off=8128, siz=4, lab1=.L2365, lab2=, loff=0
!   reloc[828]: knd=0, off=8136, siz=4, lab1=.L2366, lab2=, loff=0
!   reloc[829]: knd=0, off=8144, siz=4, lab1=.L2368, lab2=, loff=0
!   reloc[830]: knd=0, off=8154, siz=4, lab1=.L2375, lab2=, loff=0
!   reloc[831]: knd=0, off=8164, siz=4, lab1=.L2378, lab2=, loff=0
!   reloc[832]: knd=0, off=8172, siz=4, lab1=.L2382, lab2=, loff=0
!   reloc[833]: knd=0, off=8182, siz=4, lab1=.L2383, lab2=, loff=0
!   reloc[834]: knd=0, off=8192, siz=4, lab1=.L2384, lab2=, loff=0
!   reloc[835]: knd=0, off=8200, siz=4, lab1=.L2386, lab2=, loff=0
!   reloc[836]: knd=0, off=8208, siz=4, lab1=.L2393, lab2=, loff=0
!   reloc[837]: knd=0, off=8216, siz=4, lab1=.L2404, lab2=, loff=0
!   reloc[838]: knd=0, off=8224, siz=4, lab1=.L2410, lab2=, loff=0
!   reloc[839]: knd=0, off=8234, siz=4, lab1=.L2411, lab2=, loff=0
!   reloc[840]: knd=0, off=8244, siz=4, lab1=.L2412, lab2=, loff=0
!   reloc[841]: knd=0, off=8254, siz=4, lab1=.L2413, lab2=, loff=0
!   reloc[842]: knd=0, off=8262, siz=4, lab1=.L2416, lab2=, loff=0
!   reloc[843]: knd=0, off=8272, siz=4, lab1=.L2420, lab2=, loff=0
!   reloc[844]: knd=0, off=8280, siz=4, lab1=.L2426, lab2=, loff=0
!   reloc[845]: knd=0, off=8290, siz=4, lab1=.L2427, lab2=, loff=0
!   reloc[846]: knd=0, off=8298, siz=4, lab1=.L2428, lab2=, loff=0
!   reloc[847]: knd=0, off=8308, siz=4, lab1=.L2434, lab2=, loff=0
!   reloc[848]: knd=0, off=8319, siz=4, lab1=.L2442, lab2=, loff=0
!   reloc[849]: knd=0, off=8330, siz=4, lab1=.L2443, lab2=, loff=0
!   reloc[850]: knd=0, off=8338, siz=4, lab1=.L2444, lab2=, loff=0
!   reloc[851]: knd=0, off=8346, siz=4, lab1=.L2445, lab2=, loff=0
!   reloc[852]: knd=0, off=8354, siz=4, lab1=.L2447, lab2=, loff=0
!   reloc[853]: knd=0, off=8364, siz=4, lab1=.L2454, lab2=, loff=0
!   reloc[854]: knd=0, off=8374, siz=4, lab1=.L2457, lab2=, loff=0
!   reloc[855]: knd=0, off=8382, siz=4, lab1=.L2461, lab2=, loff=0
!   reloc[856]: knd=0, off=8392, siz=4, lab1=.L2462, lab2=, loff=0
!   reloc[857]: knd=0, off=8402, siz=4, lab1=.L2463, lab2=, loff=0
!   reloc[858]: knd=0, off=8410, siz=4, lab1=.L2465, lab2=, loff=0
!   reloc[859]: knd=0, off=8418, siz=4, lab1=.L2472, lab2=, loff=0
!   reloc[860]: knd=0, off=8426, siz=4, lab1=.L2483, lab2=, loff=0
!   reloc[861]: knd=0, off=8434, siz=4, lab1=.L2489, lab2=, loff=0
!   reloc[862]: knd=0, off=8444, siz=4, lab1=.L2490, lab2=, loff=0
!   reloc[863]: knd=0, off=8454, siz=4, lab1=.L2491, lab2=, loff=0
!   reloc[864]: knd=0, off=8464, siz=4, lab1=.L2492, lab2=, loff=0
!   reloc[865]: knd=0, off=8472, siz=4, lab1=.L2495, lab2=, loff=0
!   reloc[866]: knd=0, off=8482, siz=4, lab1=.L2499, lab2=, loff=0
!   reloc[867]: knd=0, off=8490, siz=4, lab1=.L2505, lab2=, loff=0
!   reloc[868]: knd=0, off=8500, siz=4, lab1=.L2506, lab2=, loff=0
!   reloc[869]: knd=0, off=8508, siz=4, lab1=.L2507, lab2=, loff=0
!   reloc[870]: knd=0, off=8518, siz=4, lab1=.L2513, lab2=, loff=0
!   reloc[871]: knd=0, off=8529, siz=4, lab1=.L2527, lab2=, loff=0
!   reloc[872]: knd=0, off=8542, siz=4, lab1=.L2532, lab2=, loff=0
!   reloc[873]: knd=0, off=8555, siz=4, lab1=.L2533, lab2=, loff=0
!   reloc[874]: knd=0, off=8565, siz=4, lab1=.L2534, lab2=, loff=0
!   reloc[875]: knd=0, off=8573, siz=4, lab1=.L2535, lab2=, loff=0
!   reloc[876]: knd=0, off=8584, siz=4, lab1=.L2536, lab2=, loff=0
!   reloc[877]: knd=0, off=8592, siz=4, lab1=.L2539, lab2=, loff=0
!   reloc[878]: knd=0, off=8600, siz=4, lab1=.L2544, lab2=, loff=0
!   reloc[879]: knd=0, off=8608, siz=4, lab1=.L2548, lab2=, loff=0
!   reloc[880]: knd=0, off=8618, siz=4, lab1=.L2549, lab2=, loff=0
!   reloc[881]: knd=0, off=8626, siz=4, lab1=.L2550, lab2=, loff=0
!   reloc[882]: knd=0, off=8634, siz=4, lab1=.L2553, lab2=, loff=0
!   reloc[883]: knd=0, off=8644, siz=4, lab1=.L2557, lab2=, loff=0
!   reloc[884]: knd=0, off=8652, siz=4, lab1=.L2558, lab2=, loff=0
!   reloc[885]: knd=0, off=8660, siz=4, lab1=.L2559, lab2=, loff=0
!   reloc[886]: knd=0, off=8670, siz=4, lab1=.L2565, lab2=, loff=0
!   reloc[887]: knd=0, off=8680, siz=4, lab1=.L2566, lab2=, loff=0
!   reloc[888]: knd=0, off=8690, siz=4, lab1=.L2572, lab2=, loff=0
!   reloc[889]: knd=0, off=8700, siz=4, lab1=.L2576, lab2=, loff=0
!   reloc[890]: knd=0, off=8708, siz=4, lab1=.L2577, lab2=, loff=0
!   reloc[891]: knd=0, off=8716, siz=4, lab1=.L2578, lab2=, loff=0
!   reloc[892]: knd=0, off=8726, siz=4, lab1=.L2584, lab2=, loff=0
!   reloc[893]: knd=0, off=8736, siz=4, lab1=.L2585, lab2=, loff=0
!   reloc[894]: knd=0, off=8746, siz=4, lab1=.L2591, lab2=, loff=0
!   reloc[895]: knd=0, off=8756, siz=4, lab1=.L2595, lab2=, loff=0
!   reloc[896]: knd=0, off=8766, siz=4, lab1=.L2596, lab2=, loff=0
!   reloc[897]: knd=0, off=8774, siz=4, lab1=.L2597, lab2=, loff=0
!   reloc[898]: knd=0, off=8782, siz=4, lab1=.L2598, lab2=, loff=0
!   reloc[899]: knd=0, off=8790, siz=4, lab1=.L2600, lab2=, loff=0
!   reloc[900]: knd=0, off=8800, siz=4, lab1=.L2607, lab2=, loff=0
!   reloc[901]: knd=0, off=8810, siz=4, lab1=.L2608, lab2=, loff=0
!   reloc[902]: knd=0, off=8820, siz=4, lab1=.L2609, lab2=, loff=0
!   reloc[903]: knd=0, off=8830, siz=4, lab1=.L2610, lab2=, loff=0
!   reloc[904]: knd=0, off=8840, siz=4, lab1=.L2611, lab2=, loff=0
!   reloc[905]: knd=0, off=8848, siz=4, lab1=.L2614, lab2=, loff=0
!   reloc[906]: knd=0, off=8858, siz=4, lab1=.L2618, lab2=, loff=0
!   reloc[907]: knd=0, off=8866, siz=4, lab1=.L2624, lab2=, loff=0
!   reloc[908]: knd=0, off=8876, siz=4, lab1=.L2625, lab2=, loff=0
!   reloc[909]: knd=0, off=8884, siz=4, lab1=.L2626, lab2=, loff=0
!   reloc[910]: knd=0, off=8894, siz=4, lab1=.L2632, lab2=, loff=0
!   reloc[911]: knd=0, off=8905, siz=4, lab1=.L2640, lab2=, loff=0
!   reloc[912]: knd=0, off=8916, siz=4, lab1=.L2641, lab2=, loff=0
!   reloc[913]: knd=0, off=8924, siz=4, lab1=.L2642, lab2=, loff=0
!   reloc[914]: knd=0, off=8932, siz=4, lab1=.L2643, lab2=, loff=0
!   reloc[915]: knd=0, off=8940, siz=4, lab1=.L2645, lab2=, loff=0
!   reloc[916]: knd=0, off=8950, siz=4, lab1=.L2652, lab2=, loff=0
!   reloc[917]: knd=0, off=8960, siz=4, lab1=.L2653, lab2=, loff=0
!   reloc[918]: knd=0, off=8970, siz=4, lab1=.L2654, lab2=, loff=0
!   reloc[919]: knd=0, off=8980, siz=4, lab1=.L2655, lab2=, loff=0
!   reloc[920]: knd=0, off=8990, siz=4, lab1=.L2656, lab2=, loff=0
!   reloc[921]: knd=0, off=8998, siz=4, lab1=.L2659, lab2=, loff=0
!   reloc[922]: knd=0, off=9008, siz=4, lab1=.L2663, lab2=, loff=0
!   reloc[923]: knd=0, off=9016, siz=4, lab1=.L2669, lab2=, loff=0
!   reloc[924]: knd=0, off=9026, siz=4, lab1=.L2670, lab2=, loff=0
!   reloc[925]: knd=0, off=9034, siz=4, lab1=.L2671, lab2=, loff=0
!   reloc[926]: knd=0, off=9044, siz=4, lab1=.L2677, lab2=, loff=0
!   reloc[927]: knd=0, off=9055, siz=4, lab1=.L2690, lab2=, loff=0
!   reloc[928]: knd=0, off=9068, siz=4, lab1=.L2691, lab2=, loff=0
!   reloc[929]: knd=0, off=9078, siz=4, lab1=.L2692, lab2=, loff=0
!   reloc[930]: knd=0, off=9086, siz=4, lab1=.L2693, lab2=, loff=0
!   reloc[931]: knd=0, off=9096, siz=4, lab1=.L2700, lab2=, loff=0
!   reloc[932]: knd=0, off=9104, siz=4, lab1=.L2701, lab2=, loff=0
!   reloc[933]: knd=0, off=9112, siz=4, lab1=.L2702, lab2=, loff=0
!   reloc[934]: knd=0, off=9122, siz=4, lab1=.L2703, lab2=, loff=0
!   reloc[935]: knd=0, off=9130, siz=4, lab1=.L2706, lab2=, loff=0
!   reloc[936]: knd=0, off=9138, siz=4, lab1=.L2711, lab2=, loff=0
!   reloc[937]: knd=0, off=9146, siz=4, lab1=.L2715, lab2=, loff=0
!   reloc[938]: knd=0, off=9156, siz=4, lab1=.L2716, lab2=, loff=0
!   reloc[939]: knd=0, off=9164, siz=4, lab1=.L2717, lab2=, loff=0
!   reloc[940]: knd=0, off=9172, siz=4, lab1=.L2720, lab2=, loff=0
!   reloc[941]: knd=0, off=9182, siz=4, lab1=.L2724, lab2=, loff=0
!   reloc[942]: knd=0, off=9190, siz=4, lab1=.L2725, lab2=, loff=0
!   reloc[943]: knd=0, off=9198, siz=4, lab1=.L2726, lab2=, loff=0
!   reloc[944]: knd=0, off=9208, siz=4, lab1=.L2732, lab2=, loff=0
!   reloc[945]: knd=0, off=9218, siz=4, lab1=.L2733, lab2=, loff=0
!   reloc[946]: knd=0, off=9228, siz=4, lab1=.L2739, lab2=, loff=0
!   reloc[947]: knd=0, off=9238, siz=4, lab1=.L2743, lab2=, loff=0
!   reloc[948]: knd=0, off=9246, siz=4, lab1=.L2744, lab2=, loff=0
!   reloc[949]: knd=0, off=9254, siz=4, lab1=.L2745, lab2=, loff=0
!   reloc[950]: knd=0, off=9264, siz=4, lab1=.L2751, lab2=, loff=0
!   reloc[951]: knd=0, off=9274, siz=4, lab1=.L2752, lab2=, loff=0
!   reloc[952]: knd=0, off=9284, siz=4, lab1=.L2758, lab2=, loff=0
!   reloc[953]: knd=0, off=9294, siz=4, lab1=.L2762, lab2=, loff=0
!   reloc[954]: knd=0, off=9304, siz=4, lab1=.L2763, lab2=, loff=0
!   reloc[955]: knd=0, off=9312, siz=4, lab1=.L2764, lab2=, loff=0
!   reloc[956]: knd=0, off=9320, siz=4, lab1=.L2765, lab2=, loff=0
!   reloc[957]: knd=0, off=9328, siz=4, lab1=.L2767, lab2=, loff=0
!   reloc[958]: knd=0, off=9338, siz=4, lab1=.L2774, lab2=, loff=0
!   reloc[959]: knd=0, off=9348, siz=4, lab1=.L2775, lab2=, loff=0
!   reloc[960]: knd=0, off=9358, siz=4, lab1=.L2776, lab2=, loff=0
!   reloc[961]: knd=0, off=9366, siz=4, lab1=.L2778, lab2=, loff=0
!   reloc[962]: knd=0, off=9374, siz=4, lab1=.L2785, lab2=, loff=0
!   reloc[963]: knd=0, off=9382, siz=4, lab1=.L2796, lab2=, loff=0
!   reloc[964]: knd=0, off=9390, siz=4, lab1=.L2799, lab2=, loff=0
!   reloc[965]: knd=0, off=9400, siz=4, lab1=.L2800, lab2=, loff=0
!   reloc[966]: knd=0, off=9410, siz=4, lab1=.L2801, lab2=, loff=0
!   reloc[967]: knd=0, off=9418, siz=4, lab1=.L2804, lab2=, loff=0
!   reloc[968]: knd=0, off=9428, siz=4, lab1=.L2808, lab2=, loff=0
!   reloc[969]: knd=0, off=9436, siz=4, lab1=.L2814, lab2=, loff=0
!   reloc[970]: knd=0, off=9446, siz=4, lab1=.L2815, lab2=, loff=0
!   reloc[971]: knd=0, off=9454, siz=4, lab1=.L2816, lab2=, loff=0
!   reloc[972]: knd=0, off=9464, siz=4, lab1=.L2822, lab2=, loff=0
!   reloc[973]: knd=0, off=9475, siz=4, lab1=.L2830, lab2=, loff=0
!   reloc[974]: knd=0, off=9486, siz=4, lab1=.L2831, lab2=, loff=0
!   reloc[975]: knd=0, off=9494, siz=4, lab1=.L2832, lab2=, loff=0
!   reloc[976]: knd=0, off=9502, siz=4, lab1=.L2833, lab2=, loff=0
!   reloc[977]: knd=0, off=9510, siz=4, lab1=.L2835, lab2=, loff=0
!   reloc[978]: knd=0, off=9520, siz=4, lab1=.L2842, lab2=, loff=0
!   reloc[979]: knd=0, off=9530, siz=4, lab1=.L2843, lab2=, loff=0
!   reloc[980]: knd=0, off=9540, siz=4, lab1=.L2844, lab2=, loff=0
!   reloc[981]: knd=0, off=9548, siz=4, lab1=.L2846, lab2=, loff=0
!   reloc[982]: knd=0, off=9556, siz=4, lab1=.L2853, lab2=, loff=0
!   reloc[983]: knd=0, off=9564, siz=4, lab1=.L2864, lab2=, loff=0
!   reloc[984]: knd=0, off=9572, siz=4, lab1=.L2867, lab2=, loff=0
!   reloc[985]: knd=0, off=9582, siz=4, lab1=.L2868, lab2=, loff=0
!   reloc[986]: knd=0, off=9592, siz=4, lab1=.L2869, lab2=, loff=0
!   reloc[987]: knd=0, off=9600, siz=4, lab1=.L2872, lab2=, loff=0
!   reloc[988]: knd=0, off=9610, siz=4, lab1=.L2876, lab2=, loff=0
!   reloc[989]: knd=0, off=9618, siz=4, lab1=.L2882, lab2=, loff=0
!   reloc[990]: knd=0, off=9628, siz=4, lab1=.L2883, lab2=, loff=0
!   reloc[991]: knd=0, off=9636, siz=4, lab1=.L2884, lab2=, loff=0
!   reloc[992]: knd=0, off=9646, siz=4, lab1=.L2890, lab2=, loff=0
!   reloc[993]: knd=0, off=9657, siz=4, lab1=.L2903, lab2=, loff=0
!   reloc[994]: knd=0, off=9670, siz=4, lab1=.L2906, lab2=, loff=0
!   reloc[995]: knd=0, off=9678, siz=4, lab1=.L2913, lab2=, loff=0
!   reloc[996]: knd=0, off=9691, siz=4, lab1=general_smooth_rgba_line, lab2=, loff=0
!   reloc[997]: knd=0, off=9698, siz=4, lab1=.L2920, lab2=, loff=0
!   reloc[998]: knd=0, off=9710, siz=4, lab1=.L2921, lab2=, loff=0
!   reloc[999]: knd=0, off=9718, siz=4, lab1=.L2922, lab2=, loff=0
!   reloc[1000]: knd=0, off=9726, siz=4, lab1=.L2923, lab2=, loff=0
!   reloc[1001]: knd=0, off=9734, siz=4, lab1=.L2924, lab2=, loff=0
!   reloc[1002]: knd=0, off=9742, siz=4, lab1=.L2925, lab2=, loff=0
!   reloc[1003]: knd=0, off=9750, siz=4, lab1=.L2926, lab2=, loff=0
!   reloc[1004]: knd=0, off=9758, siz=4, lab1=.L2927, lab2=, loff=0
!   reloc[1005]: knd=0, off=9766, siz=4, lab1=.L2930, lab2=, loff=0
!   reloc[1006]: knd=0, off=9774, siz=4, lab1=.L2935, lab2=, loff=0
!   reloc[1007]: knd=0, off=9787, siz=4, lab1=.L2936, lab2=, loff=0
!   reloc[1008]: knd=0, off=9797, siz=4, lab1=.L2937, lab2=, loff=0
!   reloc[1009]: knd=0, off=9805, siz=4, lab1=.L2938, lab2=, loff=0
!   reloc[1010]: knd=0, off=9815, siz=4, lab1=.L2939, lab2=, loff=0
!   reloc[1011]: knd=0, off=9823, siz=4, lab1=.L2940, lab2=, loff=0
!   reloc[1012]: knd=0, off=9831, siz=4, lab1=.L2941, lab2=, loff=0
!   reloc[1013]: knd=0, off=9839, siz=4, lab1=.L2942, lab2=, loff=0
!   reloc[1014]: knd=0, off=9847, siz=4, lab1=.L2943, lab2=, loff=0
!   reloc[1015]: knd=0, off=9855, siz=4, lab1=.L2944, lab2=, loff=0
!   reloc[1016]: knd=0, off=9865, siz=4, lab1=.L2945, lab2=, loff=0
!   reloc[1017]: knd=0, off=9873, siz=4, lab1=.L2946, lab2=, loff=0
!   reloc[1018]: knd=0, off=9883, siz=4, lab1=.L2953, lab2=, loff=0
!   reloc[1019]: knd=0, off=9891, siz=4, lab1=.L2954, lab2=, loff=0
!   reloc[1020]: knd=0, off=9899, siz=4, lab1=.L2955, lab2=, loff=0
!   reloc[1021]: knd=0, off=9909, siz=4, lab1=.L2956, lab2=, loff=0
!   reloc[1022]: knd=0, off=9917, siz=4, lab1=.L2959, lab2=, loff=0
!   reloc[1023]: knd=0, off=9925, siz=4, lab1=.L2964, lab2=, loff=0
!   reloc[1024]: knd=0, off=9933, siz=4, lab1=.L2968, lab2=, loff=0
!   reloc[1025]: knd=0, off=9943, siz=4, lab1=.L2969, lab2=, loff=0
!   reloc[1026]: knd=0, off=9951, siz=4, lab1=.L2970, lab2=, loff=0
!   reloc[1027]: knd=0, off=9959, siz=4, lab1=.L2973, lab2=, loff=0
!   reloc[1028]: knd=0, off=9969, siz=4, lab1=.L2977, lab2=, loff=0
!   reloc[1029]: knd=0, off=9977, siz=4, lab1=.L2978, lab2=, loff=0
!   reloc[1030]: knd=0, off=9985, siz=4, lab1=.L2979, lab2=, loff=0
!   reloc[1031]: knd=0, off=9995, siz=4, lab1=.L2985, lab2=, loff=0
!   reloc[1032]: knd=0, off=10005, siz=4, lab1=.L2986, lab2=, loff=0
!   reloc[1033]: knd=0, off=10015, siz=4, lab1=.L2992, lab2=, loff=0
!   reloc[1034]: knd=0, off=10025, siz=4, lab1=.L2996, lab2=, loff=0
!   reloc[1035]: knd=0, off=10033, siz=4, lab1=.L2997, lab2=, loff=0
!   reloc[1036]: knd=0, off=10041, siz=4, lab1=.L2998, lab2=, loff=0
!   reloc[1037]: knd=0, off=10051, siz=4, lab1=.L3004, lab2=, loff=0
!   reloc[1038]: knd=0, off=10061, siz=4, lab1=.L3005, lab2=, loff=0
!   reloc[1039]: knd=0, off=10071, siz=4, lab1=.L3011, lab2=, loff=0
!   reloc[1040]: knd=0, off=10081, siz=4, lab1=.L3015, lab2=, loff=0
!   reloc[1041]: knd=0, off=10091, siz=4, lab1=.L3016, lab2=, loff=0
!   reloc[1042]: knd=0, off=10099, siz=4, lab1=.L3017, lab2=, loff=0
!   reloc[1043]: knd=0, off=10107, siz=4, lab1=.L3018, lab2=, loff=0
!   reloc[1044]: knd=0, off=10115, siz=4, lab1=.L3019, lab2=, loff=0
!   reloc[1045]: knd=0, off=10125, siz=4, lab1=.L3020, lab2=, loff=0
!   reloc[1046]: knd=0, off=10133, siz=4, lab1=.L3021, lab2=, loff=0
!   reloc[1047]: knd=0, off=10141, siz=4, lab1=.L3022, lab2=, loff=0
!   reloc[1048]: knd=0, off=10151, siz=4, lab1=.L3024, lab2=, loff=0
!   reloc[1049]: knd=0, off=10161, siz=4, lab1=.L3031, lab2=, loff=0
!   reloc[1050]: knd=0, off=10171, siz=4, lab1=.L3034, lab2=, loff=0
!   reloc[1051]: knd=0, off=10179, siz=4, lab1=.L3038, lab2=, loff=0
!   reloc[1052]: knd=0, off=10189, siz=4, lab1=.L3039, lab2=, loff=0
!   reloc[1053]: knd=0, off=10199, siz=4, lab1=.L3040, lab2=, loff=0
!   reloc[1054]: knd=0, off=10207, siz=4, lab1=.L3042, lab2=, loff=0
!   reloc[1055]: knd=0, off=10215, siz=4, lab1=.L3049, lab2=, loff=0
!   reloc[1056]: knd=0, off=10223, siz=4, lab1=.L3060, lab2=, loff=0
!   reloc[1057]: knd=0, off=10231, siz=4, lab1=.L3066, lab2=, loff=0
!   reloc[1058]: knd=0, off=10241, siz=4, lab1=.L3067, lab2=, loff=0
!   reloc[1059]: knd=0, off=10251, siz=4, lab1=.L3068, lab2=, loff=0
!   reloc[1060]: knd=0, off=10261, siz=4, lab1=.L3069, lab2=, loff=0
!   reloc[1061]: knd=0, off=10269, siz=4, lab1=.L3070, lab2=, loff=0
!   reloc[1062]: knd=0, off=10279, siz=4, lab1=.L3071, lab2=, loff=0
!   reloc[1063]: knd=0, off=10287, siz=4, lab1=.L3072, lab2=, loff=0
!   reloc[1064]: knd=0, off=10295, siz=4, lab1=.L3073, lab2=, loff=0
!   reloc[1065]: knd=0, off=10305, siz=4, lab1=.L3076, lab2=, loff=0
!   reloc[1066]: knd=0, off=10315, siz=4, lab1=.L3080, lab2=, loff=0
!   reloc[1067]: knd=0, off=10323, siz=4, lab1=.L3086, lab2=, loff=0
!   reloc[1068]: knd=0, off=10333, siz=4, lab1=.L3087, lab2=, loff=0
!   reloc[1069]: knd=0, off=10341, siz=4, lab1=.L3088, lab2=, loff=0
!   reloc[1070]: knd=0, off=10351, siz=4, lab1=.L3094, lab2=, loff=0
!   reloc[1071]: knd=0, off=10362, siz=4, lab1=.L3102, lab2=, loff=0
!   reloc[1072]: knd=0, off=10373, siz=4, lab1=.L3103, lab2=, loff=0
!   reloc[1073]: knd=0, off=10381, siz=4, lab1=.L3104, lab2=, loff=0
!   reloc[1074]: knd=0, off=10389, siz=4, lab1=.L3105, lab2=, loff=0
!   reloc[1075]: knd=0, off=10397, siz=4, lab1=.L3106, lab2=, loff=0
!   reloc[1076]: knd=0, off=10407, siz=4, lab1=.L3107, lab2=, loff=0
!   reloc[1077]: knd=0, off=10415, siz=4, lab1=.L3108, lab2=, loff=0
!   reloc[1078]: knd=0, off=10423, siz=4, lab1=.L3109, lab2=, loff=0
!   reloc[1079]: knd=0, off=10433, siz=4, lab1=.L3111, lab2=, loff=0
!   reloc[1080]: knd=0, off=10443, siz=4, lab1=.L3118, lab2=, loff=0
!   reloc[1081]: knd=0, off=10453, siz=4, lab1=.L3121, lab2=, loff=0
!   reloc[1082]: knd=0, off=10461, siz=4, lab1=.L3125, lab2=, loff=0
!   reloc[1083]: knd=0, off=10471, siz=4, lab1=.L3126, lab2=, loff=0
!   reloc[1084]: knd=0, off=10481, siz=4, lab1=.L3127, lab2=, loff=0
!   reloc[1085]: knd=0, off=10489, siz=4, lab1=.L3129, lab2=, loff=0
!   reloc[1086]: knd=0, off=10497, siz=4, lab1=.L3136, lab2=, loff=0
!   reloc[1087]: knd=0, off=10505, siz=4, lab1=.L3147, lab2=, loff=0
!   reloc[1088]: knd=0, off=10513, siz=4, lab1=.L3153, lab2=, loff=0
!   reloc[1089]: knd=0, off=10523, siz=4, lab1=.L3154, lab2=, loff=0
!   reloc[1090]: knd=0, off=10533, siz=4, lab1=.L3155, lab2=, loff=0
!   reloc[1091]: knd=0, off=10543, siz=4, lab1=.L3156, lab2=, loff=0
!   reloc[1092]: knd=0, off=10551, siz=4, lab1=.L3157, lab2=, loff=0
!   reloc[1093]: knd=0, off=10561, siz=4, lab1=.L3158, lab2=, loff=0
!   reloc[1094]: knd=0, off=10569, siz=4, lab1=.L3159, lab2=, loff=0
!   reloc[1095]: knd=0, off=10577, siz=4, lab1=.L3160, lab2=, loff=0
!   reloc[1096]: knd=0, off=10587, siz=4, lab1=.L3163, lab2=, loff=0
!   reloc[1097]: knd=0, off=10597, siz=4, lab1=.L3167, lab2=, loff=0
!   reloc[1098]: knd=0, off=10605, siz=4, lab1=.L3173, lab2=, loff=0
!   reloc[1099]: knd=0, off=10615, siz=4, lab1=.L3174, lab2=, loff=0
!   reloc[1100]: knd=0, off=10623, siz=4, lab1=.L3175, lab2=, loff=0
!   reloc[1101]: knd=0, off=10633, siz=4, lab1=.L3181, lab2=, loff=0
!   reloc[1102]: knd=0, off=10644, siz=4, lab1=.L3195, lab2=, loff=0
!   reloc[1103]: knd=0, off=10657, siz=4, lab1=.L3200, lab2=, loff=0
!   reloc[1104]: knd=0, off=10670, siz=4, lab1=.L3201, lab2=, loff=0
!   reloc[1105]: knd=0, off=10680, siz=4, lab1=.L3202, lab2=, loff=0
!   reloc[1106]: knd=0, off=10688, siz=4, lab1=.L3203, lab2=, loff=0
!   reloc[1107]: knd=0, off=10698, siz=4, lab1=.L3204, lab2=, loff=0
!   reloc[1108]: knd=0, off=10706, siz=4, lab1=.L3205, lab2=, loff=0
!   reloc[1109]: knd=0, off=10714, siz=4, lab1=.L3206, lab2=, loff=0
!   reloc[1110]: knd=0, off=10722, siz=4, lab1=.L3207, lab2=, loff=0
!   reloc[1111]: knd=0, off=10730, siz=4, lab1=.L3208, lab2=, loff=0
!   reloc[1112]: knd=0, off=10738, siz=4, lab1=.L3209, lab2=, loff=0
!   reloc[1113]: knd=0, off=10748, siz=4, lab1=.L3210, lab2=, loff=0
!   reloc[1114]: knd=0, off=10756, siz=4, lab1=.L3211, lab2=, loff=0
!   reloc[1115]: knd=0, off=10766, siz=4, lab1=.L3212, lab2=, loff=0
!   reloc[1116]: knd=0, off=10774, siz=4, lab1=.L3215, lab2=, loff=0
!   reloc[1117]: knd=0, off=10782, siz=4, lab1=.L3220, lab2=, loff=0
!   reloc[1118]: knd=0, off=10790, siz=4, lab1=.L3224, lab2=, loff=0
!   reloc[1119]: knd=0, off=10800, siz=4, lab1=.L3225, lab2=, loff=0
!   reloc[1120]: knd=0, off=10808, siz=4, lab1=.L3226, lab2=, loff=0
!   reloc[1121]: knd=0, off=10816, siz=4, lab1=.L3229, lab2=, loff=0
!   reloc[1122]: knd=0, off=10826, siz=4, lab1=.L3233, lab2=, loff=0
!   reloc[1123]: knd=0, off=10834, siz=4, lab1=.L3234, lab2=, loff=0
!   reloc[1124]: knd=0, off=10842, siz=4, lab1=.L3235, lab2=, loff=0
!   reloc[1125]: knd=0, off=10852, siz=4, lab1=.L3241, lab2=, loff=0
!   reloc[1126]: knd=0, off=10862, siz=4, lab1=.L3242, lab2=, loff=0
!   reloc[1127]: knd=0, off=10872, siz=4, lab1=.L3248, lab2=, loff=0
!   reloc[1128]: knd=0, off=10882, siz=4, lab1=.L3252, lab2=, loff=0
!   reloc[1129]: knd=0, off=10890, siz=4, lab1=.L3253, lab2=, loff=0
!   reloc[1130]: knd=0, off=10898, siz=4, lab1=.L3254, lab2=, loff=0
!   reloc[1131]: knd=0, off=10908, siz=4, lab1=.L3260, lab2=, loff=0
!   reloc[1132]: knd=0, off=10918, siz=4, lab1=.L3261, lab2=, loff=0
!   reloc[1133]: knd=0, off=10928, siz=4, lab1=.L3267, lab2=, loff=0
!   reloc[1134]: knd=0, off=10938, siz=4, lab1=.L3271, lab2=, loff=0
!   reloc[1135]: knd=0, off=10948, siz=4, lab1=.L3272, lab2=, loff=0
!   reloc[1136]: knd=0, off=10956, siz=4, lab1=.L3273, lab2=, loff=0
!   reloc[1137]: knd=0, off=10964, siz=4, lab1=.L3274, lab2=, loff=0
!   reloc[1138]: knd=0, off=10972, siz=4, lab1=.L3275, lab2=, loff=0
!   reloc[1139]: knd=0, off=10982, siz=4, lab1=.L3276, lab2=, loff=0
!   reloc[1140]: knd=0, off=10990, siz=4, lab1=.L3277, lab2=, loff=0
!   reloc[1141]: knd=0, off=10998, siz=4, lab1=.L3278, lab2=, loff=0
!   reloc[1142]: knd=0, off=11008, siz=4, lab1=.L3280, lab2=, loff=0
!   reloc[1143]: knd=0, off=11018, siz=4, lab1=.L3287, lab2=, loff=0
!   reloc[1144]: knd=0, off=11028, siz=4, lab1=.L3288, lab2=, loff=0
!   reloc[1145]: knd=0, off=11038, siz=4, lab1=.L3289, lab2=, loff=0
!   reloc[1146]: knd=0, off=11048, siz=4, lab1=.L3290, lab2=, loff=0
!   reloc[1147]: knd=0, off=11058, siz=4, lab1=.L3291, lab2=, loff=0
!   reloc[1148]: knd=0, off=11066, siz=4, lab1=.L3292, lab2=, loff=0
!   reloc[1149]: knd=0, off=11076, siz=4, lab1=.L3293, lab2=, loff=0
!   reloc[1150]: knd=0, off=11084, siz=4, lab1=.L3294, lab2=, loff=0
!   reloc[1151]: knd=0, off=11092, siz=4, lab1=.L3295, lab2=, loff=0
!   reloc[1152]: knd=0, off=11102, siz=4, lab1=.L3298, lab2=, loff=0
!   reloc[1153]: knd=0, off=11112, siz=4, lab1=.L3302, lab2=, loff=0
!   reloc[1154]: knd=0, off=11120, siz=4, lab1=.L3308, lab2=, loff=0
!   reloc[1155]: knd=0, off=11130, siz=4, lab1=.L3309, lab2=, loff=0
!   reloc[1156]: knd=0, off=11138, siz=4, lab1=.L3310, lab2=, loff=0
!   reloc[1157]: knd=0, off=11148, siz=4, lab1=.L3316, lab2=, loff=0
!   reloc[1158]: knd=0, off=11159, siz=4, lab1=.L3324, lab2=, loff=0
!   reloc[1159]: knd=0, off=11170, siz=4, lab1=.L3325, lab2=, loff=0
!   reloc[1160]: knd=0, off=11178, siz=4, lab1=.L3326, lab2=, loff=0
!   reloc[1161]: knd=0, off=11186, siz=4, lab1=.L3327, lab2=, loff=0
!   reloc[1162]: knd=0, off=11194, siz=4, lab1=.L3328, lab2=, loff=0
!   reloc[1163]: knd=0, off=11204, siz=4, lab1=.L3329, lab2=, loff=0
!   reloc[1164]: knd=0, off=11212, siz=4, lab1=.L3330, lab2=, loff=0
!   reloc[1165]: knd=0, off=11220, siz=4, lab1=.L3331, lab2=, loff=0
!   reloc[1166]: knd=0, off=11230, siz=4, lab1=.L3333, lab2=, loff=0
!   reloc[1167]: knd=0, off=11240, siz=4, lab1=.L3340, lab2=, loff=0
!   reloc[1168]: knd=0, off=11250, siz=4, lab1=.L3341, lab2=, loff=0
!   reloc[1169]: knd=0, off=11260, siz=4, lab1=.L3342, lab2=, loff=0
!   reloc[1170]: knd=0, off=11270, siz=4, lab1=.L3343, lab2=, loff=0
!   reloc[1171]: knd=0, off=11280, siz=4, lab1=.L3344, lab2=, loff=0
!   reloc[1172]: knd=0, off=11288, siz=4, lab1=.L3345, lab2=, loff=0
!   reloc[1173]: knd=0, off=11298, siz=4, lab1=.L3346, lab2=, loff=0
!   reloc[1174]: knd=0, off=11306, siz=4, lab1=.L3347, lab2=, loff=0
!   reloc[1175]: knd=0, off=11314, siz=4, lab1=.L3348, lab2=, loff=0
!   reloc[1176]: knd=0, off=11324, siz=4, lab1=.L3351, lab2=, loff=0
!   reloc[1177]: knd=0, off=11334, siz=4, lab1=.L3355, lab2=, loff=0
!   reloc[1178]: knd=0, off=11342, siz=4, lab1=.L3361, lab2=, loff=0
!   reloc[1179]: knd=0, off=11352, siz=4, lab1=.L3362, lab2=, loff=0
!   reloc[1180]: knd=0, off=11360, siz=4, lab1=.L3363, lab2=, loff=0
!   reloc[1181]: knd=0, off=11370, siz=4, lab1=.L3369, lab2=, loff=0
!   reloc[1182]: knd=0, off=11381, siz=4, lab1=.L3382, lab2=, loff=0
!   reloc[1183]: knd=0, off=11394, siz=4, lab1=.L3383, lab2=, loff=0
!   reloc[1184]: knd=0, off=11404, siz=4, lab1=.L3384, lab2=, loff=0
!   reloc[1185]: knd=0, off=11412, siz=4, lab1=.L3385, lab2=, loff=0
!   reloc[1186]: knd=0, off=11422, siz=4, lab1=.L3386, lab2=, loff=0
!   reloc[1187]: knd=0, off=11430, siz=4, lab1=.L3387, lab2=, loff=0
!   reloc[1188]: knd=0, off=11438, siz=4, lab1=.L3388, lab2=, loff=0
!   reloc[1189]: knd=0, off=11446, siz=4, lab1=.L3389, lab2=, loff=0
!   reloc[1190]: knd=0, off=11454, siz=4, lab1=.L3390, lab2=, loff=0
!   reloc[1191]: knd=0, off=11462, siz=4, lab1=.L3391, lab2=, loff=0
!   reloc[1192]: knd=0, off=11472, siz=4, lab1=.L3392, lab2=, loff=0
!   reloc[1193]: knd=0, off=11480, siz=4, lab1=.L3393, lab2=, loff=0
!   reloc[1194]: knd=0, off=11490, siz=4, lab1=.L3400, lab2=, loff=0
!   reloc[1195]: knd=0, off=11498, siz=4, lab1=.L3401, lab2=, loff=0
!   reloc[1196]: knd=0, off=11506, siz=4, lab1=.L3402, lab2=, loff=0
!   reloc[1197]: knd=0, off=11516, siz=4, lab1=.L3403, lab2=, loff=0
!   reloc[1198]: knd=0, off=11524, siz=4, lab1=.L3406, lab2=, loff=0
!   reloc[1199]: knd=0, off=11532, siz=4, lab1=.L3411, lab2=, loff=0
!   reloc[1200]: knd=0, off=11540, siz=4, lab1=.L3415, lab2=, loff=0
!   reloc[1201]: knd=0, off=11550, siz=4, lab1=.L3416, lab2=, loff=0
!   reloc[1202]: knd=0, off=11558, siz=4, lab1=.L3417, lab2=, loff=0
!   reloc[1203]: knd=0, off=11566, siz=4, lab1=.L3420, lab2=, loff=0
!   reloc[1204]: knd=0, off=11576, siz=4, lab1=.L3424, lab2=, loff=0
!   reloc[1205]: knd=0, off=11584, siz=4, lab1=.L3425, lab2=, loff=0
!   reloc[1206]: knd=0, off=11592, siz=4, lab1=.L3426, lab2=, loff=0
!   reloc[1207]: knd=0, off=11602, siz=4, lab1=.L3432, lab2=, loff=0
!   reloc[1208]: knd=0, off=11612, siz=4, lab1=.L3433, lab2=, loff=0
!   reloc[1209]: knd=0, off=11622, siz=4, lab1=.L3439, lab2=, loff=0
!   reloc[1210]: knd=0, off=11632, siz=4, lab1=.L3443, lab2=, loff=0
!   reloc[1211]: knd=0, off=11640, siz=4, lab1=.L3444, lab2=, loff=0
!   reloc[1212]: knd=0, off=11648, siz=4, lab1=.L3445, lab2=, loff=0
!   reloc[1213]: knd=0, off=11658, siz=4, lab1=.L3451, lab2=, loff=0
!   reloc[1214]: knd=0, off=11668, siz=4, lab1=.L3452, lab2=, loff=0
!   reloc[1215]: knd=0, off=11678, siz=4, lab1=.L3458, lab2=, loff=0
!   reloc[1216]: knd=0, off=11688, siz=4, lab1=.L3462, lab2=, loff=0
!   reloc[1217]: knd=0, off=11698, siz=4, lab1=.L3463, lab2=, loff=0
!   reloc[1218]: knd=0, off=11706, siz=4, lab1=.L3464, lab2=, loff=0
!   reloc[1219]: knd=0, off=11714, siz=4, lab1=.L3465, lab2=, loff=0
!   reloc[1220]: knd=0, off=11722, siz=4, lab1=.L3466, lab2=, loff=0
!   reloc[1221]: knd=0, off=11732, siz=4, lab1=.L3467, lab2=, loff=0
!   reloc[1222]: knd=0, off=11740, siz=4, lab1=.L3468, lab2=, loff=0
!   reloc[1223]: knd=0, off=11748, siz=4, lab1=.L3469, lab2=, loff=0
!   reloc[1224]: knd=0, off=11758, siz=4, lab1=.L3471, lab2=, loff=0
!   reloc[1225]: knd=0, off=11768, siz=4, lab1=.L3478, lab2=, loff=0
!   reloc[1226]: knd=0, off=11778, siz=4, lab1=.L3479, lab2=, loff=0
!   reloc[1227]: knd=0, off=11788, siz=4, lab1=.L3480, lab2=, loff=0
!   reloc[1228]: knd=0, off=11796, siz=4, lab1=.L3482, lab2=, loff=0
!   reloc[1229]: knd=0, off=11804, siz=4, lab1=.L3489, lab2=, loff=0
!   reloc[1230]: knd=0, off=11812, siz=4, lab1=.L3500, lab2=, loff=0
!   reloc[1231]: knd=0, off=11820, siz=4, lab1=.L3503, lab2=, loff=0
!   reloc[1232]: knd=0, off=11830, siz=4, lab1=.L3504, lab2=, loff=0
!   reloc[1233]: knd=0, off=11840, siz=4, lab1=.L3505, lab2=, loff=0
!   reloc[1234]: knd=0, off=11848, siz=4, lab1=.L3506, lab2=, loff=0
!   reloc[1235]: knd=0, off=11858, siz=4, lab1=.L3507, lab2=, loff=0
!   reloc[1236]: knd=0, off=11866, siz=4, lab1=.L3508, lab2=, loff=0
!   reloc[1237]: knd=0, off=11874, siz=4, lab1=.L3509, lab2=, loff=0
!   reloc[1238]: knd=0, off=11884, siz=4, lab1=.L3512, lab2=, loff=0
!   reloc[1239]: knd=0, off=11894, siz=4, lab1=.L3516, lab2=, loff=0
!   reloc[1240]: knd=0, off=11902, siz=4, lab1=.L3522, lab2=, loff=0
!   reloc[1241]: knd=0, off=11912, siz=4, lab1=.L3523, lab2=, loff=0
!   reloc[1242]: knd=0, off=11920, siz=4, lab1=.L3524, lab2=, loff=0
!   reloc[1243]: knd=0, off=11930, siz=4, lab1=.L3530, lab2=, loff=0
!   reloc[1244]: knd=0, off=11941, siz=4, lab1=.L3538, lab2=, loff=0
!   reloc[1245]: knd=0, off=11952, siz=4, lab1=.L3539, lab2=, loff=0
!   reloc[1246]: knd=0, off=11960, siz=4, lab1=.L3540, lab2=, loff=0
!   reloc[1247]: knd=0, off=11968, siz=4, lab1=.L3541, lab2=, loff=0
!   reloc[1248]: knd=0, off=11976, siz=4, lab1=.L3542, lab2=, loff=0
!   reloc[1249]: knd=0, off=11986, siz=4, lab1=.L3543, lab2=, loff=0
!   reloc[1250]: knd=0, off=11994, siz=4, lab1=.L3544, lab2=, loff=0
!   reloc[1251]: knd=0, off=12002, siz=4, lab1=.L3545, lab2=, loff=0
!   reloc[1252]: knd=0, off=12012, siz=4, lab1=.L3547, lab2=, loff=0
!   reloc[1253]: knd=0, off=12022, siz=4, lab1=.L3554, lab2=, loff=0
!   reloc[1254]: knd=0, off=12032, siz=4, lab1=.L3555, lab2=, loff=0
!   reloc[1255]: knd=0, off=12042, siz=4, lab1=.L3556, lab2=, loff=0
!   reloc[1256]: knd=0, off=12050, siz=4, lab1=.L3558, lab2=, loff=0
!   reloc[1257]: knd=0, off=12058, siz=4, lab1=.L3565, lab2=, loff=0
!   reloc[1258]: knd=0, off=12066, siz=4, lab1=.L3576, lab2=, loff=0
!   reloc[1259]: knd=0, off=12074, siz=4, lab1=.L3579, lab2=, loff=0
!   reloc[1260]: knd=0, off=12084, siz=4, lab1=.L3580, lab2=, loff=0
!   reloc[1261]: knd=0, off=12094, siz=4, lab1=.L3581, lab2=, loff=0
!   reloc[1262]: knd=0, off=12102, siz=4, lab1=.L3582, lab2=, loff=0
!   reloc[1263]: knd=0, off=12112, siz=4, lab1=.L3583, lab2=, loff=0
!   reloc[1264]: knd=0, off=12120, siz=4, lab1=.L3584, lab2=, loff=0
!   reloc[1265]: knd=0, off=12128, siz=4, lab1=.L3585, lab2=, loff=0
!   reloc[1266]: knd=0, off=12138, siz=4, lab1=.L3588, lab2=, loff=0
!   reloc[1267]: knd=0, off=12148, siz=4, lab1=.L3592, lab2=, loff=0
!   reloc[1268]: knd=0, off=12156, siz=4, lab1=.L3598, lab2=, loff=0
!   reloc[1269]: knd=0, off=12166, siz=4, lab1=.L3599, lab2=, loff=0
!   reloc[1270]: knd=0, off=12174, siz=4, lab1=.L3600, lab2=, loff=0
!   reloc[1271]: knd=0, off=12184, siz=4, lab1=.L3606, lab2=, loff=0
!   reloc[1272]: knd=0, off=12195, siz=4, lab1=.L3619, lab2=, loff=0
!   reloc[1273]: knd=0, off=12208, siz=4, lab1=.L3622, lab2=, loff=0
!   reloc[1274]: knd=0, off=12216, siz=4, lab1=.L3629, lab2=, loff=0
!   reloc[1275]: knd=0, off=12229, siz=4, lab1=general_flat_rgba_line, lab2=, loff=0
!   reloc[1276]: knd=0, off=12236, siz=4, lab1=.L3636, lab2=, loff=0
!   reloc[1277]: knd=0, off=12248, siz=4, lab1=.L3637, lab2=, loff=0
!   reloc[1278]: knd=0, off=12256, siz=4, lab1=.L3638, lab2=, loff=0
!   reloc[1279]: knd=0, off=12264, siz=4, lab1=.L3639, lab2=, loff=0
!   reloc[1280]: knd=0, off=12272, siz=4, lab1=.L3642, lab2=, loff=0
!   reloc[1281]: knd=0, off=12280, siz=4, lab1=.L3654, lab2=, loff=0
!   reloc[1282]: knd=0, off=12288, siz=4, lab1=.L3657, lab2=, loff=0
!   reloc[1283]: knd=0, off=12296, siz=4, lab1=.L3662, lab2=, loff=0
!   reloc[1284]: knd=0, off=12309, siz=4, lab1=.L3663, lab2=, loff=0
!   reloc[1285]: knd=0, off=12319, siz=4, lab1=.L3664, lab2=, loff=0
!   reloc[1286]: knd=0, off=12327, siz=4, lab1=.L3665, lab2=, loff=0
!   reloc[1287]: knd=0, off=12337, siz=4, lab1=.L3672, lab2=, loff=0
!   reloc[1288]: knd=0, off=12345, siz=4, lab1=.L3673, lab2=, loff=0
!   reloc[1289]: knd=0, off=12353, siz=4, lab1=.L3674, lab2=, loff=0
!   reloc[1290]: knd=0, off=12363, siz=4, lab1=.L3675, lab2=, loff=0
!   reloc[1291]: knd=0, off=12371, siz=4, lab1=.L3678, lab2=, loff=0
!   reloc[1292]: knd=0, off=12379, siz=4, lab1=.L3683, lab2=, loff=0
!   reloc[1293]: knd=0, off=12387, siz=4, lab1=.L3687, lab2=, loff=0
!   reloc[1294]: knd=0, off=12397, siz=4, lab1=.L3688, lab2=, loff=0
!   reloc[1295]: knd=0, off=12405, siz=4, lab1=.L3689, lab2=, loff=0
!   reloc[1296]: knd=0, off=12413, siz=4, lab1=.L3692, lab2=, loff=0
!   reloc[1297]: knd=0, off=12423, siz=4, lab1=.L3696, lab2=, loff=0
!   reloc[1298]: knd=0, off=12431, siz=4, lab1=.L3697, lab2=, loff=0
!   reloc[1299]: knd=0, off=12439, siz=4, lab1=.L3698, lab2=, loff=0
!   reloc[1300]: knd=0, off=12449, siz=4, lab1=.L3704, lab2=, loff=0
!   reloc[1301]: knd=0, off=12459, siz=4, lab1=.L3705, lab2=, loff=0
!   reloc[1302]: knd=0, off=12469, siz=4, lab1=.L3711, lab2=, loff=0
!   reloc[1303]: knd=0, off=12479, siz=4, lab1=.L3715, lab2=, loff=0
!   reloc[1304]: knd=0, off=12487, siz=4, lab1=.L3716, lab2=, loff=0
!   reloc[1305]: knd=0, off=12495, siz=4, lab1=.L3717, lab2=, loff=0
!   reloc[1306]: knd=0, off=12505, siz=4, lab1=.L3723, lab2=, loff=0
!   reloc[1307]: knd=0, off=12515, siz=4, lab1=.L3724, lab2=, loff=0
!   reloc[1308]: knd=0, off=12525, siz=4, lab1=.L3730, lab2=, loff=0
!   reloc[1309]: knd=0, off=12535, siz=4, lab1=.L3734, lab2=, loff=0
!   reloc[1310]: knd=0, off=12545, siz=4, lab1=.L3735, lab2=, loff=0
!   reloc[1311]: knd=0, off=12553, siz=4, lab1=.L3736, lab2=, loff=0
!   reloc[1312]: knd=0, off=12561, siz=4, lab1=.L3737, lab2=, loff=0
!   reloc[1313]: knd=0, off=12569, siz=4, lab1=.L3739, lab2=, loff=0
!   reloc[1314]: knd=0, off=12579, siz=4, lab1=.L3746, lab2=, loff=0
!   reloc[1315]: knd=0, off=12589, siz=4, lab1=.L3749, lab2=, loff=0
!   reloc[1316]: knd=0, off=12597, siz=4, lab1=.L3753, lab2=, loff=0
!   reloc[1317]: knd=0, off=12607, siz=4, lab1=.L3754, lab2=, loff=0
!   reloc[1318]: knd=0, off=12617, siz=4, lab1=.L3755, lab2=, loff=0
!   reloc[1319]: knd=0, off=12625, siz=4, lab1=.L3757, lab2=, loff=0
!   reloc[1320]: knd=0, off=12633, siz=4, lab1=.L3764, lab2=, loff=0
!   reloc[1321]: knd=0, off=12641, siz=4, lab1=.L3775, lab2=, loff=0
!   reloc[1322]: knd=0, off=12649, siz=4, lab1=.L3781, lab2=, loff=0
!   reloc[1323]: knd=0, off=12659, siz=4, lab1=.L3782, lab2=, loff=0
!   reloc[1324]: knd=0, off=12669, siz=4, lab1=.L3783, lab2=, loff=0
!   reloc[1325]: knd=0, off=12679, siz=4, lab1=.L3784, lab2=, loff=0
!   reloc[1326]: knd=0, off=12687, siz=4, lab1=.L3787, lab2=, loff=0
!   reloc[1327]: knd=0, off=12697, siz=4, lab1=.L3791, lab2=, loff=0
!   reloc[1328]: knd=0, off=12705, siz=4, lab1=.L3797, lab2=, loff=0
!   reloc[1329]: knd=0, off=12715, siz=4, lab1=.L3798, lab2=, loff=0
!   reloc[1330]: knd=0, off=12723, siz=4, lab1=.L3799, lab2=, loff=0
!   reloc[1331]: knd=0, off=12733, siz=4, lab1=.L3805, lab2=, loff=0
!   reloc[1332]: knd=0, off=12744, siz=4, lab1=.L3813, lab2=, loff=0
!   reloc[1333]: knd=0, off=12755, siz=4, lab1=.L3814, lab2=, loff=0
!   reloc[1334]: knd=0, off=12763, siz=4, lab1=.L3815, lab2=, loff=0
!   reloc[1335]: knd=0, off=12771, siz=4, lab1=.L3816, lab2=, loff=0
!   reloc[1336]: knd=0, off=12779, siz=4, lab1=.L3818, lab2=, loff=0
!   reloc[1337]: knd=0, off=12789, siz=4, lab1=.L3825, lab2=, loff=0
!   reloc[1338]: knd=0, off=12799, siz=4, lab1=.L3828, lab2=, loff=0
!   reloc[1339]: knd=0, off=12807, siz=4, lab1=.L3832, lab2=, loff=0
!   reloc[1340]: knd=0, off=12817, siz=4, lab1=.L3833, lab2=, loff=0
!   reloc[1341]: knd=0, off=12827, siz=4, lab1=.L3834, lab2=, loff=0
!   reloc[1342]: knd=0, off=12835, siz=4, lab1=.L3836, lab2=, loff=0
!   reloc[1343]: knd=0, off=12843, siz=4, lab1=.L3843, lab2=, loff=0
!   reloc[1344]: knd=0, off=12851, siz=4, lab1=.L3854, lab2=, loff=0
!   reloc[1345]: knd=0, off=12859, siz=4, lab1=.L3860, lab2=, loff=0
!   reloc[1346]: knd=0, off=12869, siz=4, lab1=.L3861, lab2=, loff=0
!   reloc[1347]: knd=0, off=12879, siz=4, lab1=.L3862, lab2=, loff=0
!   reloc[1348]: knd=0, off=12889, siz=4, lab1=.L3863, lab2=, loff=0
!   reloc[1349]: knd=0, off=12897, siz=4, lab1=.L3866, lab2=, loff=0
!   reloc[1350]: knd=0, off=12907, siz=4, lab1=.L3870, lab2=, loff=0
!   reloc[1351]: knd=0, off=12915, siz=4, lab1=.L3876, lab2=, loff=0
!   reloc[1352]: knd=0, off=12925, siz=4, lab1=.L3877, lab2=, loff=0
!   reloc[1353]: knd=0, off=12933, siz=4, lab1=.L3878, lab2=, loff=0
!   reloc[1354]: knd=0, off=12943, siz=4, lab1=.L3884, lab2=, loff=0
!   reloc[1355]: knd=0, off=12954, siz=4, lab1=.L3898, lab2=, loff=0
!   reloc[1356]: knd=0, off=12967, siz=4, lab1=.L3903, lab2=, loff=0
!   reloc[1357]: knd=0, off=12980, siz=4, lab1=.L3904, lab2=, loff=0
!   reloc[1358]: knd=0, off=12990, siz=4, lab1=.L3905, lab2=, loff=0
!   reloc[1359]: knd=0, off=12998, siz=4, lab1=.L3906, lab2=, loff=0
!   reloc[1360]: knd=0, off=13009, siz=4, lab1=.L3907, lab2=, loff=0
!   reloc[1361]: knd=0, off=13017, siz=4, lab1=.L3910, lab2=, loff=0
!   reloc[1362]: knd=0, off=13025, siz=4, lab1=.L3915, lab2=, loff=0
!   reloc[1363]: knd=0, off=13033, siz=4, lab1=.L3919, lab2=, loff=0
!   reloc[1364]: knd=0, off=13043, siz=4, lab1=.L3920, lab2=, loff=0
!   reloc[1365]: knd=0, off=13051, siz=4, lab1=.L3921, lab2=, loff=0
!   reloc[1366]: knd=0, off=13059, siz=4, lab1=.L3924, lab2=, loff=0
!   reloc[1367]: knd=0, off=13069, siz=4, lab1=.L3928, lab2=, loff=0
!   reloc[1368]: knd=0, off=13077, siz=4, lab1=.L3929, lab2=, loff=0
!   reloc[1369]: knd=0, off=13085, siz=4, lab1=.L3930, lab2=, loff=0
!   reloc[1370]: knd=0, off=13095, siz=4, lab1=.L3936, lab2=, loff=0
!   reloc[1371]: knd=0, off=13105, siz=4, lab1=.L3937, lab2=, loff=0
!   reloc[1372]: knd=0, off=13115, siz=4, lab1=.L3943, lab2=, loff=0
!   reloc[1373]: knd=0, off=13125, siz=4, lab1=.L3947, lab2=, loff=0
!   reloc[1374]: knd=0, off=13133, siz=4, lab1=.L3948, lab2=, loff=0
!   reloc[1375]: knd=0, off=13141, siz=4, lab1=.L3949, lab2=, loff=0
!   reloc[1376]: knd=0, off=13151, siz=4, lab1=.L3955, lab2=, loff=0
!   reloc[1377]: knd=0, off=13161, siz=4, lab1=.L3956, lab2=, loff=0
!   reloc[1378]: knd=0, off=13171, siz=4, lab1=.L3962, lab2=, loff=0
!   reloc[1379]: knd=0, off=13181, siz=4, lab1=.L3966, lab2=, loff=0
!   reloc[1380]: knd=0, off=13191, siz=4, lab1=.L3967, lab2=, loff=0
!   reloc[1381]: knd=0, off=13199, siz=4, lab1=.L3968, lab2=, loff=0
!   reloc[1382]: knd=0, off=13207, siz=4, lab1=.L3969, lab2=, loff=0
!   reloc[1383]: knd=0, off=13215, siz=4, lab1=.L3971, lab2=, loff=0
!   reloc[1384]: knd=0, off=13225, siz=4, lab1=.L3978, lab2=, loff=0
!   reloc[1385]: knd=0, off=13235, siz=4, lab1=.L3979, lab2=, loff=0
!   reloc[1386]: knd=0, off=13245, siz=4, lab1=.L3980, lab2=, loff=0
!   reloc[1387]: knd=0, off=13255, siz=4, lab1=.L3981, lab2=, loff=0
!   reloc[1388]: knd=0, off=13265, siz=4, lab1=.L3982, lab2=, loff=0
!   reloc[1389]: knd=0, off=13273, siz=4, lab1=.L3985, lab2=, loff=0
!   reloc[1390]: knd=0, off=13283, siz=4, lab1=.L3989, lab2=, loff=0
!   reloc[1391]: knd=0, off=13291, siz=4, lab1=.L3995, lab2=, loff=0
!   reloc[1392]: knd=0, off=13301, siz=4, lab1=.L3996, lab2=, loff=0
!   reloc[1393]: knd=0, off=13309, siz=4, lab1=.L3997, lab2=, loff=0
!   reloc[1394]: knd=0, off=13319, siz=4, lab1=.L4003, lab2=, loff=0
!   reloc[1395]: knd=0, off=13330, siz=4, lab1=.L4011, lab2=, loff=0
!   reloc[1396]: knd=0, off=13341, siz=4, lab1=.L4012, lab2=, loff=0
!   reloc[1397]: knd=0, off=13349, siz=4, lab1=.L4013, lab2=, loff=0
!   reloc[1398]: knd=0, off=13357, siz=4, lab1=.L4014, lab2=, loff=0
!   reloc[1399]: knd=0, off=13365, siz=4, lab1=.L4016, lab2=, loff=0
!   reloc[1400]: knd=0, off=13375, siz=4, lab1=.L4023, lab2=, loff=0
!   reloc[1401]: knd=0, off=13385, siz=4, lab1=.L4024, lab2=, loff=0
!   reloc[1402]: knd=0, off=13395, siz=4, lab1=.L4025, lab2=, loff=0
!   reloc[1403]: knd=0, off=13405, siz=4, lab1=.L4026, lab2=, loff=0
!   reloc[1404]: knd=0, off=13415, siz=4, lab1=.L4027, lab2=, loff=0
!   reloc[1405]: knd=0, off=13423, siz=4, lab1=.L4030, lab2=, loff=0
!   reloc[1406]: knd=0, off=13433, siz=4, lab1=.L4034, lab2=, loff=0
!   reloc[1407]: knd=0, off=13441, siz=4, lab1=.L4040, lab2=, loff=0
!   reloc[1408]: knd=0, off=13451, siz=4, lab1=.L4041, lab2=, loff=0
!   reloc[1409]: knd=0, off=13459, siz=4, lab1=.L4042, lab2=, loff=0
!   reloc[1410]: knd=0, off=13469, siz=4, lab1=.L4048, lab2=, loff=0
!   reloc[1411]: knd=0, off=13480, siz=4, lab1=.L4061, lab2=, loff=0
!   reloc[1412]: knd=0, off=13493, siz=4, lab1=.L4062, lab2=, loff=0
!   reloc[1413]: knd=0, off=13503, siz=4, lab1=.L4063, lab2=, loff=0
!   reloc[1414]: knd=0, off=13511, siz=4, lab1=.L4064, lab2=, loff=0
!   reloc[1415]: knd=0, off=13521, siz=4, lab1=.L4071, lab2=, loff=0
!   reloc[1416]: knd=0, off=13529, siz=4, lab1=.L4072, lab2=, loff=0
!   reloc[1417]: knd=0, off=13537, siz=4, lab1=.L4073, lab2=, loff=0
!   reloc[1418]: knd=0, off=13547, siz=4, lab1=.L4074, lab2=, loff=0
!   reloc[1419]: knd=0, off=13555, siz=4, lab1=.L4077, lab2=, loff=0
!   reloc[1420]: knd=0, off=13563, siz=4, lab1=.L4082, lab2=, loff=0
!   reloc[1421]: knd=0, off=13571, siz=4, lab1=.L4086, lab2=, loff=0
!   reloc[1422]: knd=0, off=13581, siz=4, lab1=.L4087, lab2=, loff=0
!   reloc[1423]: knd=0, off=13589, siz=4, lab1=.L4088, lab2=, loff=0
!   reloc[1424]: knd=0, off=13597, siz=4, lab1=.L4091, lab2=, loff=0
!   reloc[1425]: knd=0, off=13607, siz=4, lab1=.L4095, lab2=, loff=0
!   reloc[1426]: knd=0, off=13615, siz=4, lab1=.L4096, lab2=, loff=0
!   reloc[1427]: knd=0, off=13623, siz=4, lab1=.L4097, lab2=, loff=0
!   reloc[1428]: knd=0, off=13633, siz=4, lab1=.L4103, lab2=, loff=0
!   reloc[1429]: knd=0, off=13643, siz=4, lab1=.L4104, lab2=, loff=0
!   reloc[1430]: knd=0, off=13653, siz=4, lab1=.L4110, lab2=, loff=0
!   reloc[1431]: knd=0, off=13663, siz=4, lab1=.L4114, lab2=, loff=0
!   reloc[1432]: knd=0, off=13671, siz=4, lab1=.L4115, lab2=, loff=0
!   reloc[1433]: knd=0, off=13679, siz=4, lab1=.L4116, lab2=, loff=0
!   reloc[1434]: knd=0, off=13689, siz=4, lab1=.L4122, lab2=, loff=0
!   reloc[1435]: knd=0, off=13699, siz=4, lab1=.L4123, lab2=, loff=0
!   reloc[1436]: knd=0, off=13709, siz=4, lab1=.L4129, lab2=, loff=0
!   reloc[1437]: knd=0, off=13719, siz=4, lab1=.L4133, lab2=, loff=0
!   reloc[1438]: knd=0, off=13729, siz=4, lab1=.L4134, lab2=, loff=0
!   reloc[1439]: knd=0, off=13737, siz=4, lab1=.L4135, lab2=, loff=0
!   reloc[1440]: knd=0, off=13745, siz=4, lab1=.L4136, lab2=, loff=0
!   reloc[1441]: knd=0, off=13753, siz=4, lab1=.L4138, lab2=, loff=0
!   reloc[1442]: knd=0, off=13763, siz=4, lab1=.L4145, lab2=, loff=0
!   reloc[1443]: knd=0, off=13773, siz=4, lab1=.L4146, lab2=, loff=0
!   reloc[1444]: knd=0, off=13783, siz=4, lab1=.L4147, lab2=, loff=0
!   reloc[1445]: knd=0, off=13791, siz=4, lab1=.L4149, lab2=, loff=0
!   reloc[1446]: knd=0, off=13799, siz=4, lab1=.L4156, lab2=, loff=0
!   reloc[1447]: knd=0, off=13807, siz=4, lab1=.L4167, lab2=, loff=0
!   reloc[1448]: knd=0, off=13815, siz=4, lab1=.L4170, lab2=, loff=0
!   reloc[1449]: knd=0, off=13825, siz=4, lab1=.L4171, lab2=, loff=0
!   reloc[1450]: knd=0, off=13835, siz=4, lab1=.L4172, lab2=, loff=0
!   reloc[1451]: knd=0, off=13843, siz=4, lab1=.L4175, lab2=, loff=0
!   reloc[1452]: knd=0, off=13853, siz=4, lab1=.L4179, lab2=, loff=0
!   reloc[1453]: knd=0, off=13861, siz=4, lab1=.L4185, lab2=, loff=0
!   reloc[1454]: knd=0, off=13871, siz=4, lab1=.L4186, lab2=, loff=0
!   reloc[1455]: knd=0, off=13879, siz=4, lab1=.L4187, lab2=, loff=0
!   reloc[1456]: knd=0, off=13889, siz=4, lab1=.L4193, lab2=, loff=0
!   reloc[1457]: knd=0, off=13900, siz=4, lab1=.L4201, lab2=, loff=0
!   reloc[1458]: knd=0, off=13911, siz=4, lab1=.L4202, lab2=, loff=0
!   reloc[1459]: knd=0, off=13919, siz=4, lab1=.L4203, lab2=, loff=0
!   reloc[1460]: knd=0, off=13927, siz=4, lab1=.L4204, lab2=, loff=0
!   reloc[1461]: knd=0, off=13935, siz=4, lab1=.L4206, lab2=, loff=0
!   reloc[1462]: knd=0, off=13945, siz=4, lab1=.L4213, lab2=, loff=0
!   reloc[1463]: knd=0, off=13955, siz=4, lab1=.L4214, lab2=, loff=0
!   reloc[1464]: knd=0, off=13965, siz=4, lab1=.L4215, lab2=, loff=0
!   reloc[1465]: knd=0, off=13973, siz=4, lab1=.L4217, lab2=, loff=0
!   reloc[1466]: knd=0, off=13981, siz=4, lab1=.L4224, lab2=, loff=0
!   reloc[1467]: knd=0, off=13989, siz=4, lab1=.L4235, lab2=, loff=0
!   reloc[1468]: knd=0, off=13997, siz=4, lab1=.L4238, lab2=, loff=0
!   reloc[1469]: knd=0, off=14007, siz=4, lab1=.L4239, lab2=, loff=0
!   reloc[1470]: knd=0, off=14017, siz=4, lab1=.L4240, lab2=, loff=0
!   reloc[1471]: knd=0, off=14025, siz=4, lab1=.L4243, lab2=, loff=0
!   reloc[1472]: knd=0, off=14035, siz=4, lab1=.L4247, lab2=, loff=0
!   reloc[1473]: knd=0, off=14043, siz=4, lab1=.L4253, lab2=, loff=0
!   reloc[1474]: knd=0, off=14053, siz=4, lab1=.L4254, lab2=, loff=0
!   reloc[1475]: knd=0, off=14061, siz=4, lab1=.L4255, lab2=, loff=0
!   reloc[1476]: knd=0, off=14071, siz=4, lab1=.L4261, lab2=, loff=0
!   reloc[1477]: knd=0, off=14082, siz=4, lab1=.L4274, lab2=, loff=0
!   reloc[1478]: knd=0, off=14095, siz=4, lab1=.L4277, lab2=, loff=0
!   reloc[1479]: knd=0, off=14103, siz=4, lab1=.L4284, lab2=, loff=0
!   reloc[1480]: knd=0, off=14116, siz=4, lab1=flat_textured_line, lab2=, loff=0
!   reloc[1481]: knd=0, off=14123, siz=4, lab1=.L4291, lab2=, loff=0
!   reloc[1482]: knd=0, off=14135, siz=4, lab1=.L4292, lab2=, loff=0
!   reloc[1483]: knd=0, off=14143, siz=4, lab1=.L4293, lab2=, loff=0
!   reloc[1484]: knd=0, off=14151, siz=4, lab1=.L4294, lab2=, loff=0
!   reloc[1485]: knd=0, off=14159, siz=4, lab1=.L4295, lab2=, loff=0
!   reloc[1486]: knd=0, off=14167, siz=4, lab1=.L4296, lab2=, loff=0
!   reloc[1487]: knd=0, off=14175, siz=4, lab1=.L4297, lab2=, loff=0
!   reloc[1488]: knd=0, off=14183, siz=4, lab1=.L4300, lab2=, loff=0
!   reloc[1489]: knd=0, off=14191, siz=4, lab1=.L4312, lab2=, loff=0
!   reloc[1490]: knd=0, off=14199, siz=4, lab1=.L4315, lab2=, loff=0
!   reloc[1491]: knd=0, off=14207, siz=4, lab1=.L4320, lab2=, loff=0
!   reloc[1492]: knd=0, off=14220, siz=4, lab1=.L4321, lab2=, loff=0
!   reloc[1493]: knd=0, off=14230, siz=4, lab1=.L4322, lab2=, loff=0
!   reloc[1494]: knd=0, off=14238, siz=4, lab1=.L4323, lab2=, loff=0
!   reloc[1495]: knd=0, off=14248, siz=4, lab1=.L4324, lab2=, loff=0
!   reloc[1496]: knd=0, off=14256, siz=4, lab1=.L4325, lab2=, loff=0
!   reloc[1497]: knd=0, off=14264, siz=4, lab1=.L4326, lab2=, loff=0
!   reloc[1498]: knd=0, off=14274, siz=4, lab1=.L4327, lab2=, loff=0
!   reloc[1499]: knd=0, off=14282, siz=4, lab1=.L4328, lab2=, loff=0
!   reloc[1500]: knd=0, off=14292, siz=4, lab1=.L4335, lab2=, loff=0
!   reloc[1501]: knd=0, off=14300, siz=4, lab1=.L4336, lab2=, loff=0
!   reloc[1502]: knd=0, off=14308, siz=4, lab1=.L4337, lab2=, loff=0
!   reloc[1503]: knd=0, off=14318, siz=4, lab1=.L4338, lab2=, loff=0
!   reloc[1504]: knd=0, off=14326, siz=4, lab1=.L4341, lab2=, loff=0
!   reloc[1505]: knd=0, off=14334, siz=4, lab1=.L4346, lab2=, loff=0
!   reloc[1506]: knd=0, off=14342, siz=4, lab1=.L4350, lab2=, loff=0
!   reloc[1507]: knd=0, off=14352, siz=4, lab1=.L4351, lab2=, loff=0
!   reloc[1508]: knd=0, off=14360, siz=4, lab1=.L4352, lab2=, loff=0
!   reloc[1509]: knd=0, off=14368, siz=4, lab1=.L4355, lab2=, loff=0
!   reloc[1510]: knd=0, off=14378, siz=4, lab1=.L4359, lab2=, loff=0
!   reloc[1511]: knd=0, off=14386, siz=4, lab1=.L4360, lab2=, loff=0
!   reloc[1512]: knd=0, off=14394, siz=4, lab1=.L4361, lab2=, loff=0
!   reloc[1513]: knd=0, off=14404, siz=4, lab1=.L4367, lab2=, loff=0
!   reloc[1514]: knd=0, off=14414, siz=4, lab1=.L4368, lab2=, loff=0
!   reloc[1515]: knd=0, off=14424, siz=4, lab1=.L4374, lab2=, loff=0
!   reloc[1516]: knd=0, off=14434, siz=4, lab1=.L4378, lab2=, loff=0
!   reloc[1517]: knd=0, off=14442, siz=4, lab1=.L4379, lab2=, loff=0
!   reloc[1518]: knd=0, off=14450, siz=4, lab1=.L4380, lab2=, loff=0
!   reloc[1519]: knd=0, off=14460, siz=4, lab1=.L4386, lab2=, loff=0
!   reloc[1520]: knd=0, off=14470, siz=4, lab1=.L4387, lab2=, loff=0
!   reloc[1521]: knd=0, off=14480, siz=4, lab1=.L4393, lab2=, loff=0
!   reloc[1522]: knd=0, off=14490, siz=4, lab1=.L4397, lab2=, loff=0
!   reloc[1523]: knd=0, off=14500, siz=4, lab1=.L4398, lab2=, loff=0
!   reloc[1524]: knd=0, off=14508, siz=4, lab1=.L4399, lab2=, loff=0
!   reloc[1525]: knd=0, off=14516, siz=4, lab1=.L4400, lab2=, loff=0
!   reloc[1526]: knd=0, off=14524, siz=4, lab1=.L4402, lab2=, loff=0
!   reloc[1527]: knd=0, off=14534, siz=4, lab1=.L4403, lab2=, loff=0
!   reloc[1528]: knd=0, off=14542, siz=4, lab1=.L4404, lab2=, loff=0
!   reloc[1529]: knd=0, off=14550, siz=4, lab1=.L4405, lab2=, loff=0
!   reloc[1530]: knd=0, off=14558, siz=4, lab1=.L4406, lab2=, loff=0
!   reloc[1531]: knd=0, off=14566, siz=4, lab1=.L4407, lab2=, loff=0
!   reloc[1532]: knd=0, off=14574, siz=4, lab1=.L4410, lab2=, loff=0
!   reloc[1533]: knd=0, off=14584, siz=4, lab1=.L4417, lab2=, loff=0
!   reloc[1534]: knd=0, off=14594, siz=4, lab1=.L4420, lab2=, loff=0
!   reloc[1535]: knd=0, off=14602, siz=4, lab1=.L4424, lab2=, loff=0
!   reloc[1536]: knd=0, off=14612, siz=4, lab1=.L4425, lab2=, loff=0
!   reloc[1537]: knd=0, off=14622, siz=4, lab1=.L4426, lab2=, loff=0
!   reloc[1538]: knd=0, off=14630, siz=4, lab1=.L4428, lab2=, loff=0
!   reloc[1539]: knd=0, off=14638, siz=4, lab1=.L4435, lab2=, loff=0
!   reloc[1540]: knd=0, off=14646, siz=4, lab1=.L4446, lab2=, loff=0
!   reloc[1541]: knd=0, off=14654, siz=4, lab1=.L4452, lab2=, loff=0
!   reloc[1542]: knd=0, off=14664, siz=4, lab1=.L4453, lab2=, loff=0
!   reloc[1543]: knd=0, off=14674, siz=4, lab1=.L4454, lab2=, loff=0
!   reloc[1544]: knd=0, off=14684, siz=4, lab1=.L4455, lab2=, loff=0
!   reloc[1545]: knd=0, off=14692, siz=4, lab1=.L4456, lab2=, loff=0
!   reloc[1546]: knd=0, off=14702, siz=4, lab1=.L4457, lab2=, loff=0
!   reloc[1547]: knd=0, off=14710, siz=4, lab1=.L4458, lab2=, loff=0
!   reloc[1548]: knd=0, off=14718, siz=4, lab1=.L4459, lab2=, loff=0
!   reloc[1549]: knd=0, off=14728, siz=4, lab1=.L4460, lab2=, loff=0
!   reloc[1550]: knd=0, off=14736, siz=4, lab1=.L4463, lab2=, loff=0
!   reloc[1551]: knd=0, off=14746, siz=4, lab1=.L4467, lab2=, loff=0
!   reloc[1552]: knd=0, off=14754, siz=4, lab1=.L4473, lab2=, loff=0
!   reloc[1553]: knd=0, off=14764, siz=4, lab1=.L4474, lab2=, loff=0
!   reloc[1554]: knd=0, off=14772, siz=4, lab1=.L4475, lab2=, loff=0
!   reloc[1555]: knd=0, off=14782, siz=4, lab1=.L4481, lab2=, loff=0
!   reloc[1556]: knd=0, off=14793, siz=4, lab1=.L4489, lab2=, loff=0
!   reloc[1557]: knd=0, off=14804, siz=4, lab1=.L4490, lab2=, loff=0
!   reloc[1558]: knd=0, off=14812, siz=4, lab1=.L4491, lab2=, loff=0
!   reloc[1559]: knd=0, off=14820, siz=4, lab1=.L4492, lab2=, loff=0
!   reloc[1560]: knd=0, off=14828, siz=4, lab1=.L4494, lab2=, loff=0
!   reloc[1561]: knd=0, off=14838, siz=4, lab1=.L4495, lab2=, loff=0
!   reloc[1562]: knd=0, off=14846, siz=4, lab1=.L4496, lab2=, loff=0
!   reloc[1563]: knd=0, off=14854, siz=4, lab1=.L4497, lab2=, loff=0
!   reloc[1564]: knd=0, off=14862, siz=4, lab1=.L4498, lab2=, loff=0
!   reloc[1565]: knd=0, off=14870, siz=4, lab1=.L4499, lab2=, loff=0
!   reloc[1566]: knd=0, off=14878, siz=4, lab1=.L4502, lab2=, loff=0
!   reloc[1567]: knd=0, off=14888, siz=4, lab1=.L4509, lab2=, loff=0
!   reloc[1568]: knd=0, off=14898, siz=4, lab1=.L4512, lab2=, loff=0
!   reloc[1569]: knd=0, off=14906, siz=4, lab1=.L4516, lab2=, loff=0
!   reloc[1570]: knd=0, off=14916, siz=4, lab1=.L4517, lab2=, loff=0
!   reloc[1571]: knd=0, off=14926, siz=4, lab1=.L4518, lab2=, loff=0
!   reloc[1572]: knd=0, off=14934, siz=4, lab1=.L4520, lab2=, loff=0
!   reloc[1573]: knd=0, off=14942, siz=4, lab1=.L4527, lab2=, loff=0
!   reloc[1574]: knd=0, off=14950, siz=4, lab1=.L4538, lab2=, loff=0
!   reloc[1575]: knd=0, off=14958, siz=4, lab1=.L4544, lab2=, loff=0
!   reloc[1576]: knd=0, off=14968, siz=4, lab1=.L4545, lab2=, loff=0
!   reloc[1577]: knd=0, off=14978, siz=4, lab1=.L4546, lab2=, loff=0
!   reloc[1578]: knd=0, off=14988, siz=4, lab1=.L4547, lab2=, loff=0
!   reloc[1579]: knd=0, off=14996, siz=4, lab1=.L4548, lab2=, loff=0
!   reloc[1580]: knd=0, off=15006, siz=4, lab1=.L4549, lab2=, loff=0
!   reloc[1581]: knd=0, off=15014, siz=4, lab1=.L4550, lab2=, loff=0
!   reloc[1582]: knd=0, off=15022, siz=4, lab1=.L4551, lab2=, loff=0
!   reloc[1583]: knd=0, off=15032, siz=4, lab1=.L4552, lab2=, loff=0
!   reloc[1584]: knd=0, off=15040, siz=4, lab1=.L4555, lab2=, loff=0
!   reloc[1585]: knd=0, off=15050, siz=4, lab1=.L4559, lab2=, loff=0
!   reloc[1586]: knd=0, off=15058, siz=4, lab1=.L4565, lab2=, loff=0
!   reloc[1587]: knd=0, off=15068, siz=4, lab1=.L4566, lab2=, loff=0
!   reloc[1588]: knd=0, off=15076, siz=4, lab1=.L4567, lab2=, loff=0
!   reloc[1589]: knd=0, off=15086, siz=4, lab1=.L4573, lab2=, loff=0
!   reloc[1590]: knd=0, off=15097, siz=4, lab1=.L4586, lab2=, loff=0
!   reloc[1591]: knd=0, off=15110, siz=4, lab1=.L4587, lab2=, loff=0
!   reloc[1592]: knd=0, off=15120, siz=4, lab1=.L4588, lab2=, loff=0
!   reloc[1593]: knd=0, off=15128, siz=4, lab1=.L4589, lab2=, loff=0
!   reloc[1594]: knd=0, off=15138, siz=4, lab1=.L4590, lab2=, loff=0
!   reloc[1595]: knd=0, off=15146, siz=4, lab1=.L4591, lab2=, loff=0
!   reloc[1596]: knd=0, off=15154, siz=4, lab1=.L4592, lab2=, loff=0
!   reloc[1597]: knd=0, off=15164, siz=4, lab1=.L4593, lab2=, loff=0
!   reloc[1598]: knd=0, off=15172, siz=4, lab1=.L4594, lab2=, loff=0
!   reloc[1599]: knd=0, off=15182, siz=4, lab1=.L4601, lab2=, loff=0
!   reloc[1600]: knd=0, off=15190, siz=4, lab1=.L4602, lab2=, loff=0
!   reloc[1601]: knd=0, off=15198, siz=4, lab1=.L4603, lab2=, loff=0
!   reloc[1602]: knd=0, off=15208, siz=4, lab1=.L4604, lab2=, loff=0
!   reloc[1603]: knd=0, off=15216, siz=4, lab1=.L4607, lab2=, loff=0
!   reloc[1604]: knd=0, off=15224, siz=4, lab1=.L4612, lab2=, loff=0
!   reloc[1605]: knd=0, off=15232, siz=4, lab1=.L4616, lab2=, loff=0
!   reloc[1606]: knd=0, off=15242, siz=4, lab1=.L4617, lab2=, loff=0
!   reloc[1607]: knd=0, off=15250, siz=4, lab1=.L4618, lab2=, loff=0
!   reloc[1608]: knd=0, off=15258, siz=4, lab1=.L4621, lab2=, loff=0
!   reloc[1609]: knd=0, off=15268, siz=4, lab1=.L4625, lab2=, loff=0
!   reloc[1610]: knd=0, off=15276, siz=4, lab1=.L4626, lab2=, loff=0
!   reloc[1611]: knd=0, off=15284, siz=4, lab1=.L4627, lab2=, loff=0
!   reloc[1612]: knd=0, off=15294, siz=4, lab1=.L4633, lab2=, loff=0
!   reloc[1613]: knd=0, off=15304, siz=4, lab1=.L4634, lab2=, loff=0
!   reloc[1614]: knd=0, off=15314, siz=4, lab1=.L4640, lab2=, loff=0
!   reloc[1615]: knd=0, off=15324, siz=4, lab1=.L4644, lab2=, loff=0
!   reloc[1616]: knd=0, off=15332, siz=4, lab1=.L4645, lab2=, loff=0
!   reloc[1617]: knd=0, off=15340, siz=4, lab1=.L4646, lab2=, loff=0
!   reloc[1618]: knd=0, off=15350, siz=4, lab1=.L4652, lab2=, loff=0
!   reloc[1619]: knd=0, off=15360, siz=4, lab1=.L4653, lab2=, loff=0
!   reloc[1620]: knd=0, off=15370, siz=4, lab1=.L4659, lab2=, loff=0
!   reloc[1621]: knd=0, off=15380, siz=4, lab1=.L4663, lab2=, loff=0
!   reloc[1622]: knd=0, off=15390, siz=4, lab1=.L4664, lab2=, loff=0
!   reloc[1623]: knd=0, off=15398, siz=4, lab1=.L4665, lab2=, loff=0
!   reloc[1624]: knd=0, off=15406, siz=4, lab1=.L4666, lab2=, loff=0
!   reloc[1625]: knd=0, off=15414, siz=4, lab1=.L4668, lab2=, loff=0
!   reloc[1626]: knd=0, off=15424, siz=4, lab1=.L4669, lab2=, loff=0
!   reloc[1627]: knd=0, off=15432, siz=4, lab1=.L4670, lab2=, loff=0
!   reloc[1628]: knd=0, off=15440, siz=4, lab1=.L4671, lab2=, loff=0
!   reloc[1629]: knd=0, off=15448, siz=4, lab1=.L4672, lab2=, loff=0
!   reloc[1630]: knd=0, off=15456, siz=4, lab1=.L4673, lab2=, loff=0
!   reloc[1631]: knd=0, off=15464, siz=4, lab1=.L4676, lab2=, loff=0
!   reloc[1632]: knd=0, off=15474, siz=4, lab1=.L4683, lab2=, loff=0
!   reloc[1633]: knd=0, off=15484, siz=4, lab1=.L4684, lab2=, loff=0
!   reloc[1634]: knd=0, off=15494, siz=4, lab1=.L4685, lab2=, loff=0
!   reloc[1635]: knd=0, off=15502, siz=4, lab1=.L4687, lab2=, loff=0
!   reloc[1636]: knd=0, off=15510, siz=4, lab1=.L4694, lab2=, loff=0
!   reloc[1637]: knd=0, off=15518, siz=4, lab1=.L4705, lab2=, loff=0
!   reloc[1638]: knd=0, off=15526, siz=4, lab1=.L4708, lab2=, loff=0
!   reloc[1639]: knd=0, off=15536, siz=4, lab1=.L4709, lab2=, loff=0
!   reloc[1640]: knd=0, off=15546, siz=4, lab1=.L4710, lab2=, loff=0
!   reloc[1641]: knd=0, off=15554, siz=4, lab1=.L4711, lab2=, loff=0
!   reloc[1642]: knd=0, off=15564, siz=4, lab1=.L4712, lab2=, loff=0
!   reloc[1643]: knd=0, off=15572, siz=4, lab1=.L4713, lab2=, loff=0
!   reloc[1644]: knd=0, off=15580, siz=4, lab1=.L4714, lab2=, loff=0
!   reloc[1645]: knd=0, off=15590, siz=4, lab1=.L4715, lab2=, loff=0
!   reloc[1646]: knd=0, off=15598, siz=4, lab1=.L4718, lab2=, loff=0
!   reloc[1647]: knd=0, off=15608, siz=4, lab1=.L4722, lab2=, loff=0
!   reloc[1648]: knd=0, off=15616, siz=4, lab1=.L4728, lab2=, loff=0
!   reloc[1649]: knd=0, off=15626, siz=4, lab1=.L4729, lab2=, loff=0
!   reloc[1650]: knd=0, off=15634, siz=4, lab1=.L4730, lab2=, loff=0
!   reloc[1651]: knd=0, off=15644, siz=4, lab1=.L4736, lab2=, loff=0
!   reloc[1652]: knd=0, off=15655, siz=4, lab1=.L4744, lab2=, loff=0
!   reloc[1653]: knd=0, off=15666, siz=4, lab1=.L4745, lab2=, loff=0
!   reloc[1654]: knd=0, off=15674, siz=4, lab1=.L4746, lab2=, loff=0
!   reloc[1655]: knd=0, off=15682, siz=4, lab1=.L4747, lab2=, loff=0
!   reloc[1656]: knd=0, off=15690, siz=4, lab1=.L4749, lab2=, loff=0
!   reloc[1657]: knd=0, off=15700, siz=4, lab1=.L4750, lab2=, loff=0
!   reloc[1658]: knd=0, off=15708, siz=4, lab1=.L4751, lab2=, loff=0
!   reloc[1659]: knd=0, off=15716, siz=4, lab1=.L4752, lab2=, loff=0
!   reloc[1660]: knd=0, off=15724, siz=4, lab1=.L4753, lab2=, loff=0
!   reloc[1661]: knd=0, off=15732, siz=4, lab1=.L4754, lab2=, loff=0
!   reloc[1662]: knd=0, off=15740, siz=4, lab1=.L4757, lab2=, loff=0
!   reloc[1663]: knd=0, off=15750, siz=4, lab1=.L4764, lab2=, loff=0
!   reloc[1664]: knd=0, off=15760, siz=4, lab1=.L4765, lab2=, loff=0
!   reloc[1665]: knd=0, off=15770, siz=4, lab1=.L4766, lab2=, loff=0
!   reloc[1666]: knd=0, off=15778, siz=4, lab1=.L4768, lab2=, loff=0
!   reloc[1667]: knd=0, off=15786, siz=4, lab1=.L4775, lab2=, loff=0
!   reloc[1668]: knd=0, off=15794, siz=4, lab1=.L4786, lab2=, loff=0
!   reloc[1669]: knd=0, off=15802, siz=4, lab1=.L4789, lab2=, loff=0
!   reloc[1670]: knd=0, off=15812, siz=4, lab1=.L4790, lab2=, loff=0
!   reloc[1671]: knd=0, off=15822, siz=4, lab1=.L4791, lab2=, loff=0
!   reloc[1672]: knd=0, off=15830, siz=4, lab1=.L4792, lab2=, loff=0
!   reloc[1673]: knd=0, off=15840, siz=4, lab1=.L4793, lab2=, loff=0
!   reloc[1674]: knd=0, off=15848, siz=4, lab1=.L4794, lab2=, loff=0
!   reloc[1675]: knd=0, off=15856, siz=4, lab1=.L4795, lab2=, loff=0
!   reloc[1676]: knd=0, off=15866, siz=4, lab1=.L4796, lab2=, loff=0
!   reloc[1677]: knd=0, off=15874, siz=4, lab1=.L4799, lab2=, loff=0
!   reloc[1678]: knd=0, off=15884, siz=4, lab1=.L4803, lab2=, loff=0
!   reloc[1679]: knd=0, off=15892, siz=4, lab1=.L4809, lab2=, loff=0
!   reloc[1680]: knd=0, off=15902, siz=4, lab1=.L4810, lab2=, loff=0
!   reloc[1681]: knd=0, off=15910, siz=4, lab1=.L4811, lab2=, loff=0
!   reloc[1682]: knd=0, off=15920, siz=4, lab1=.L4817, lab2=, loff=0
!   reloc[1683]: knd=0, off=15931, siz=4, lab1=.L4827, lab2=, loff=0
!   reloc[1684]: knd=0, off=15944, siz=4, lab1=.L4830, lab2=, loff=0
!   reloc[1685]: knd=0, off=15952, siz=4, lab1=.L4837, lab2=, loff=0
!   reloc[1686]: knd=0, off=15965, siz=4, lab1=smooth_textured_line, lab2=, loff=0
!   reloc[1687]: knd=0, off=15972, siz=4, lab1=.L4844, lab2=, loff=0
!   reloc[1688]: knd=0, off=15984, siz=4, lab1=.L4845, lab2=, loff=0
!   reloc[1689]: knd=0, off=15992, siz=4, lab1=.L4846, lab2=, loff=0
!   reloc[1690]: knd=0, off=16000, siz=4, lab1=.L4847, lab2=, loff=0
!   reloc[1691]: knd=0, off=16008, siz=4, lab1=.L4848, lab2=, loff=0
!   reloc[1692]: knd=0, off=16016, siz=4, lab1=.L4849, lab2=, loff=0
!   reloc[1693]: knd=0, off=16024, siz=4, lab1=.L4850, lab2=, loff=0
!   reloc[1694]: knd=0, off=16032, siz=4, lab1=.L4851, lab2=, loff=0
!   reloc[1695]: knd=0, off=16040, siz=4, lab1=.L4852, lab2=, loff=0
!   reloc[1696]: knd=0, off=16048, siz=4, lab1=.L4853, lab2=, loff=0
!   reloc[1697]: knd=0, off=16056, siz=4, lab1=.L4854, lab2=, loff=0
!   reloc[1698]: knd=0, off=16064, siz=4, lab1=.L4857, lab2=, loff=0
!   reloc[1699]: knd=0, off=16072, siz=4, lab1=.L4862, lab2=, loff=0
!   reloc[1700]: knd=0, off=16085, siz=4, lab1=.L4863, lab2=, loff=0
!   reloc[1701]: knd=0, off=16095, siz=4, lab1=.L4864, lab2=, loff=0
!   reloc[1702]: knd=0, off=16103, siz=4, lab1=.L4865, lab2=, loff=0
!   reloc[1703]: knd=0, off=16113, siz=4, lab1=.L4866, lab2=, loff=0
!   reloc[1704]: knd=0, off=16121, siz=4, lab1=.L4867, lab2=, loff=0
!   reloc[1705]: knd=0, off=16129, siz=4, lab1=.L4868, lab2=, loff=0
!   reloc[1706]: knd=0, off=16137, siz=4, lab1=.L4869, lab2=, loff=0
!   reloc[1707]: knd=0, off=16145, siz=4, lab1=.L4870, lab2=, loff=0
!   reloc[1708]: knd=0, off=16153, siz=4, lab1=.L4871, lab2=, loff=0
!   reloc[1709]: knd=0, off=16163, siz=4, lab1=.L4872, lab2=, loff=0
!   reloc[1710]: knd=0, off=16171, siz=4, lab1=.L4873, lab2=, loff=0
!   reloc[1711]: knd=0, off=16181, siz=4, lab1=.L4874, lab2=, loff=0
!   reloc[1712]: knd=0, off=16189, siz=4, lab1=.L4875, lab2=, loff=0
!   reloc[1713]: knd=0, off=16197, siz=4, lab1=.L4876, lab2=, loff=0
!   reloc[1714]: knd=0, off=16207, siz=4, lab1=.L4877, lab2=, loff=0
!   reloc[1715]: knd=0, off=16215, siz=4, lab1=.L4878, lab2=, loff=0
!   reloc[1716]: knd=0, off=16225, siz=4, lab1=.L4885, lab2=, loff=0
!   reloc[1717]: knd=0, off=16233, siz=4, lab1=.L4886, lab2=, loff=0
!   reloc[1718]: knd=0, off=16241, siz=4, lab1=.L4887, lab2=, loff=0
!   reloc[1719]: knd=0, off=16251, siz=4, lab1=.L4888, lab2=, loff=0
!   reloc[1720]: knd=0, off=16259, siz=4, lab1=.L4891, lab2=, loff=0
!   reloc[1721]: knd=0, off=16267, siz=4, lab1=.L4896, lab2=, loff=0
!   reloc[1722]: knd=0, off=16275, siz=4, lab1=.L4900, lab2=, loff=0
!   reloc[1723]: knd=0, off=16285, siz=4, lab1=.L4901, lab2=, loff=0
!   reloc[1724]: knd=0, off=16293, siz=4, lab1=.L4902, lab2=, loff=0
!   reloc[1725]: knd=0, off=16301, siz=4, lab1=.L4905, lab2=, loff=0
!   reloc[1726]: knd=0, off=16311, siz=4, lab1=.L4909, lab2=, loff=0
!   reloc[1727]: knd=0, off=16319, siz=4, lab1=.L4910, lab2=, loff=0
!   reloc[1728]: knd=0, off=16327, siz=4, lab1=.L4911, lab2=, loff=0
!   reloc[1729]: knd=0, off=16337, siz=4, lab1=.L4917, lab2=, loff=0
!   reloc[1730]: knd=0, off=16347, siz=4, lab1=.L4918, lab2=, loff=0
!   reloc[1731]: knd=0, off=16357, siz=4, lab1=.L4924, lab2=, loff=0
!   reloc[1732]: knd=0, off=16367, siz=4, lab1=.L4928, lab2=, loff=0
!   reloc[1733]: knd=0, off=16375, siz=4, lab1=.L4929, lab2=, loff=0
!   reloc[1734]: knd=0, off=16383, siz=4, lab1=.L4930, lab2=, loff=0
!   reloc[1735]: knd=0, off=16393, siz=4, lab1=.L4936, lab2=, loff=0
!   reloc[1736]: knd=0, off=16403, siz=4, lab1=.L4937, lab2=, loff=0
!   reloc[1737]: knd=0, off=16413, siz=4, lab1=.L4943, lab2=, loff=0
!   reloc[1738]: knd=0, off=16423, siz=4, lab1=.L4947, lab2=, loff=0
!   reloc[1739]: knd=0, off=16433, siz=4, lab1=.L4948, lab2=, loff=0
!   reloc[1740]: knd=0, off=16441, siz=4, lab1=.L4949, lab2=, loff=0
!   reloc[1741]: knd=0, off=16449, siz=4, lab1=.L4950, lab2=, loff=0
!   reloc[1742]: knd=0, off=16457, siz=4, lab1=.L4951, lab2=, loff=0
!   reloc[1743]: knd=0, off=16467, siz=4, lab1=.L4952, lab2=, loff=0
!   reloc[1744]: knd=0, off=16475, siz=4, lab1=.L4953, lab2=, loff=0
!   reloc[1745]: knd=0, off=16483, siz=4, lab1=.L4954, lab2=, loff=0
!   reloc[1746]: knd=0, off=16493, siz=4, lab1=.L4956, lab2=, loff=0
!   reloc[1747]: knd=0, off=16503, siz=4, lab1=.L4957, lab2=, loff=0
!   reloc[1748]: knd=0, off=16511, siz=4, lab1=.L4958, lab2=, loff=0
!   reloc[1749]: knd=0, off=16519, siz=4, lab1=.L4959, lab2=, loff=0
!   reloc[1750]: knd=0, off=16527, siz=4, lab1=.L4960, lab2=, loff=0
!   reloc[1751]: knd=0, off=16535, siz=4, lab1=.L4961, lab2=, loff=0
!   reloc[1752]: knd=0, off=16543, siz=4, lab1=.L4964, lab2=, loff=0
!   reloc[1753]: knd=0, off=16553, siz=4, lab1=.L4971, lab2=, loff=0
!   reloc[1754]: knd=0, off=16563, siz=4, lab1=.L4974, lab2=, loff=0
!   reloc[1755]: knd=0, off=16571, siz=4, lab1=.L4978, lab2=, loff=0
!   reloc[1756]: knd=0, off=16581, siz=4, lab1=.L4979, lab2=, loff=0
!   reloc[1757]: knd=0, off=16591, siz=4, lab1=.L4980, lab2=, loff=0
!   reloc[1758]: knd=0, off=16599, siz=4, lab1=.L4982, lab2=, loff=0
!   reloc[1759]: knd=0, off=16607, siz=4, lab1=.L4989, lab2=, loff=0
!   reloc[1760]: knd=0, off=16615, siz=4, lab1=.L5000, lab2=, loff=0
!   reloc[1761]: knd=0, off=16623, siz=4, lab1=.L5006, lab2=, loff=0
!   reloc[1762]: knd=0, off=16633, siz=4, lab1=.L5007, lab2=, loff=0
!   reloc[1763]: knd=0, off=16643, siz=4, lab1=.L5008, lab2=, loff=0
!   reloc[1764]: knd=0, off=16653, siz=4, lab1=.L5009, lab2=, loff=0
!   reloc[1765]: knd=0, off=16661, siz=4, lab1=.L5010, lab2=, loff=0
!   reloc[1766]: knd=0, off=16671, siz=4, lab1=.L5011, lab2=, loff=0
!   reloc[1767]: knd=0, off=16679, siz=4, lab1=.L5012, lab2=, loff=0
!   reloc[1768]: knd=0, off=16687, siz=4, lab1=.L5013, lab2=, loff=0
!   reloc[1769]: knd=0, off=16697, siz=4, lab1=.L5014, lab2=, loff=0
!   reloc[1770]: knd=0, off=16707, siz=4, lab1=.L5015, lab2=, loff=0
!   reloc[1771]: knd=0, off=16715, siz=4, lab1=.L5016, lab2=, loff=0
!   reloc[1772]: knd=0, off=16723, siz=4, lab1=.L5017, lab2=, loff=0
!   reloc[1773]: knd=0, off=16733, siz=4, lab1=.L5018, lab2=, loff=0
!   reloc[1774]: knd=0, off=16741, siz=4, lab1=.L5021, lab2=, loff=0
!   reloc[1775]: knd=0, off=16751, siz=4, lab1=.L5025, lab2=, loff=0
!   reloc[1776]: knd=0, off=16759, siz=4, lab1=.L5031, lab2=, loff=0
!   reloc[1777]: knd=0, off=16769, siz=4, lab1=.L5032, lab2=, loff=0
!   reloc[1778]: knd=0, off=16777, siz=4, lab1=.L5033, lab2=, loff=0
!   reloc[1779]: knd=0, off=16787, siz=4, lab1=.L5039, lab2=, loff=0
!   reloc[1780]: knd=0, off=16798, siz=4, lab1=.L5047, lab2=, loff=0
!   reloc[1781]: knd=0, off=16809, siz=4, lab1=.L5048, lab2=, loff=0
!   reloc[1782]: knd=0, off=16817, siz=4, lab1=.L5049, lab2=, loff=0
!   reloc[1783]: knd=0, off=16825, siz=4, lab1=.L5050, lab2=, loff=0
!   reloc[1784]: knd=0, off=16833, siz=4, lab1=.L5051, lab2=, loff=0
!   reloc[1785]: knd=0, off=16843, siz=4, lab1=.L5052, lab2=, loff=0
!   reloc[1786]: knd=0, off=16851, siz=4, lab1=.L5053, lab2=, loff=0
!   reloc[1787]: knd=0, off=16859, siz=4, lab1=.L5054, lab2=, loff=0
!   reloc[1788]: knd=0, off=16869, siz=4, lab1=.L5056, lab2=, loff=0
!   reloc[1789]: knd=0, off=16879, siz=4, lab1=.L5057, lab2=, loff=0
!   reloc[1790]: knd=0, off=16887, siz=4, lab1=.L5058, lab2=, loff=0
!   reloc[1791]: knd=0, off=16895, siz=4, lab1=.L5059, lab2=, loff=0
!   reloc[1792]: knd=0, off=16903, siz=4, lab1=.L5060, lab2=, loff=0
!   reloc[1793]: knd=0, off=16911, siz=4, lab1=.L5061, lab2=, loff=0
!   reloc[1794]: knd=0, off=16919, siz=4, lab1=.L5064, lab2=, loff=0
!   reloc[1795]: knd=0, off=16929, siz=4, lab1=.L5071, lab2=, loff=0
!   reloc[1796]: knd=0, off=16939, siz=4, lab1=.L5074, lab2=, loff=0
!   reloc[1797]: knd=0, off=16947, siz=4, lab1=.L5078, lab2=, loff=0
!   reloc[1798]: knd=0, off=16957, siz=4, lab1=.L5079, lab2=, loff=0
!   reloc[1799]: knd=0, off=16967, siz=4, lab1=.L5080, lab2=, loff=0
!   reloc[1800]: knd=0, off=16975, siz=4, lab1=.L5082, lab2=, loff=0
!   reloc[1801]: knd=0, off=16983, siz=4, lab1=.L5089, lab2=, loff=0
!   reloc[1802]: knd=0, off=16991, siz=4, lab1=.L5100, lab2=, loff=0
!   reloc[1803]: knd=0, off=16999, siz=4, lab1=.L5106, lab2=, loff=0
!   reloc[1804]: knd=0, off=17009, siz=4, lab1=.L5107, lab2=, loff=0
!   reloc[1805]: knd=0, off=17019, siz=4, lab1=.L5108, lab2=, loff=0
!   reloc[1806]: knd=0, off=17029, siz=4, lab1=.L5109, lab2=, loff=0
!   reloc[1807]: knd=0, off=17037, siz=4, lab1=.L5110, lab2=, loff=0
!   reloc[1808]: knd=0, off=17047, siz=4, lab1=.L5111, lab2=, loff=0
!   reloc[1809]: knd=0, off=17055, siz=4, lab1=.L5112, lab2=, loff=0
!   reloc[1810]: knd=0, off=17063, siz=4, lab1=.L5113, lab2=, loff=0
!   reloc[1811]: knd=0, off=17073, siz=4, lab1=.L5114, lab2=, loff=0
!   reloc[1812]: knd=0, off=17083, siz=4, lab1=.L5115, lab2=, loff=0
!   reloc[1813]: knd=0, off=17091, siz=4, lab1=.L5116, lab2=, loff=0
!   reloc[1814]: knd=0, off=17099, siz=4, lab1=.L5117, lab2=, loff=0
!   reloc[1815]: knd=0, off=17109, siz=4, lab1=.L5118, lab2=, loff=0
!   reloc[1816]: knd=0, off=17117, siz=4, lab1=.L5121, lab2=, loff=0
!   reloc[1817]: knd=0, off=17127, siz=4, lab1=.L5125, lab2=, loff=0
!   reloc[1818]: knd=0, off=17135, siz=4, lab1=.L5131, lab2=, loff=0
!   reloc[1819]: knd=0, off=17145, siz=4, lab1=.L5132, lab2=, loff=0
!   reloc[1820]: knd=0, off=17153, siz=4, lab1=.L5133, lab2=, loff=0
!   reloc[1821]: knd=0, off=17163, siz=4, lab1=.L5139, lab2=, loff=0
!   reloc[1822]: knd=0, off=17174, siz=4, lab1=.L5152, lab2=, loff=0
!   reloc[1823]: knd=0, off=17187, siz=4, lab1=.L5153, lab2=, loff=0
!   reloc[1824]: knd=0, off=17197, siz=4, lab1=.L5154, lab2=, loff=0
!   reloc[1825]: knd=0, off=17205, siz=4, lab1=.L5155, lab2=, loff=0
!   reloc[1826]: knd=0, off=17215, siz=4, lab1=.L5156, lab2=, loff=0
!   reloc[1827]: knd=0, off=17223, siz=4, lab1=.L5157, lab2=, loff=0
!   reloc[1828]: knd=0, off=17231, siz=4, lab1=.L5158, lab2=, loff=0
!   reloc[1829]: knd=0, off=17239, siz=4, lab1=.L5159, lab2=, loff=0
!   reloc[1830]: knd=0, off=17247, siz=4, lab1=.L5160, lab2=, loff=0
!   reloc[1831]: knd=0, off=17255, siz=4, lab1=.L5161, lab2=, loff=0
!   reloc[1832]: knd=0, off=17265, siz=4, lab1=.L5162, lab2=, loff=0
!   reloc[1833]: knd=0, off=17273, siz=4, lab1=.L5163, lab2=, loff=0
!   reloc[1834]: knd=0, off=17283, siz=4, lab1=.L5164, lab2=, loff=0
!   reloc[1835]: knd=0, off=17291, siz=4, lab1=.L5165, lab2=, loff=0
!   reloc[1836]: knd=0, off=17299, siz=4, lab1=.L5166, lab2=, loff=0
!   reloc[1837]: knd=0, off=17309, siz=4, lab1=.L5167, lab2=, loff=0
!   reloc[1838]: knd=0, off=17317, siz=4, lab1=.L5168, lab2=, loff=0
!   reloc[1839]: knd=0, off=17327, siz=4, lab1=.L5175, lab2=, loff=0
!   reloc[1840]: knd=0, off=17335, siz=4, lab1=.L5176, lab2=, loff=0
!   reloc[1841]: knd=0, off=17343, siz=4, lab1=.L5177, lab2=, loff=0
!   reloc[1842]: knd=0, off=17353, siz=4, lab1=.L5178, lab2=, loff=0
!   reloc[1843]: knd=0, off=17361, siz=4, lab1=.L5181, lab2=, loff=0
!   reloc[1844]: knd=0, off=17369, siz=4, lab1=.L5186, lab2=, loff=0
!   reloc[1845]: knd=0, off=17377, siz=4, lab1=.L5190, lab2=, loff=0
!   reloc[1846]: knd=0, off=17387, siz=4, lab1=.L5191, lab2=, loff=0
!   reloc[1847]: knd=0, off=17395, siz=4, lab1=.L5192, lab2=, loff=0
!   reloc[1848]: knd=0, off=17403, siz=4, lab1=.L5195, lab2=, loff=0
!   reloc[1849]: knd=0, off=17413, siz=4, lab1=.L5199, lab2=, loff=0
!   reloc[1850]: knd=0, off=17421, siz=4, lab1=.L5200, lab2=, loff=0
!   reloc[1851]: knd=0, off=17429, siz=4, lab1=.L5201, lab2=, loff=0
!   reloc[1852]: knd=0, off=17439, siz=4, lab1=.L5207, lab2=, loff=0
!   reloc[1853]: knd=0, off=17449, siz=4, lab1=.L5208, lab2=, loff=0
!   reloc[1854]: knd=0, off=17459, siz=4, lab1=.L5214, lab2=, loff=0
!   reloc[1855]: knd=0, off=17469, siz=4, lab1=.L5218, lab2=, loff=0
!   reloc[1856]: knd=0, off=17477, siz=4, lab1=.L5219, lab2=, loff=0
!   reloc[1857]: knd=0, off=17485, siz=4, lab1=.L5220, lab2=, loff=0
!   reloc[1858]: knd=0, off=17495, siz=4, lab1=.L5226, lab2=, loff=0
!   reloc[1859]: knd=0, off=17505, siz=4, lab1=.L5227, lab2=, loff=0
!   reloc[1860]: knd=0, off=17515, siz=4, lab1=.L5233, lab2=, loff=0
!   reloc[1861]: knd=0, off=17525, siz=4, lab1=.L5237, lab2=, loff=0
!   reloc[1862]: knd=0, off=17535, siz=4, lab1=.L5238, lab2=, loff=0
!   reloc[1863]: knd=0, off=17543, siz=4, lab1=.L5239, lab2=, loff=0
!   reloc[1864]: knd=0, off=17551, siz=4, lab1=.L5240, lab2=, loff=0
!   reloc[1865]: knd=0, off=17559, siz=4, lab1=.L5241, lab2=, loff=0
!   reloc[1866]: knd=0, off=17569, siz=4, lab1=.L5242, lab2=, loff=0
!   reloc[1867]: knd=0, off=17577, siz=4, lab1=.L5243, lab2=, loff=0
!   reloc[1868]: knd=0, off=17585, siz=4, lab1=.L5244, lab2=, loff=0
!   reloc[1869]: knd=0, off=17595, siz=4, lab1=.L5246, lab2=, loff=0
!   reloc[1870]: knd=0, off=17605, siz=4, lab1=.L5247, lab2=, loff=0
!   reloc[1871]: knd=0, off=17613, siz=4, lab1=.L5248, lab2=, loff=0
!   reloc[1872]: knd=0, off=17621, siz=4, lab1=.L5249, lab2=, loff=0
!   reloc[1873]: knd=0, off=17629, siz=4, lab1=.L5250, lab2=, loff=0
!   reloc[1874]: knd=0, off=17637, siz=4, lab1=.L5251, lab2=, loff=0
!   reloc[1875]: knd=0, off=17645, siz=4, lab1=.L5254, lab2=, loff=0
!   reloc[1876]: knd=0, off=17655, siz=4, lab1=.L5261, lab2=, loff=0
!   reloc[1877]: knd=0, off=17665, siz=4, lab1=.L5262, lab2=, loff=0
!   reloc[1878]: knd=0, off=17675, siz=4, lab1=.L5263, lab2=, loff=0
!   reloc[1879]: knd=0, off=17683, siz=4, lab1=.L5265, lab2=, loff=0
!   reloc[1880]: knd=0, off=17691, siz=4, lab1=.L5272, lab2=, loff=0
!   reloc[1881]: knd=0, off=17699, siz=4, lab1=.L5283, lab2=, loff=0
!   reloc[1882]: knd=0, off=17707, siz=4, lab1=.L5286, lab2=, loff=0
!   reloc[1883]: knd=0, off=17717, siz=4, lab1=.L5287, lab2=, loff=0
!   reloc[1884]: knd=0, off=17727, siz=4, lab1=.L5288, lab2=, loff=0
!   reloc[1885]: knd=0, off=17735, siz=4, lab1=.L5289, lab2=, loff=0
!   reloc[1886]: knd=0, off=17745, siz=4, lab1=.L5290, lab2=, loff=0
!   reloc[1887]: knd=0, off=17753, siz=4, lab1=.L5291, lab2=, loff=0
!   reloc[1888]: knd=0, off=17761, siz=4, lab1=.L5292, lab2=, loff=0
!   reloc[1889]: knd=0, off=17771, siz=4, lab1=.L5293, lab2=, loff=0
!   reloc[1890]: knd=0, off=17781, siz=4, lab1=.L5294, lab2=, loff=0
!   reloc[1891]: knd=0, off=17789, siz=4, lab1=.L5295, lab2=, loff=0
!   reloc[1892]: knd=0, off=17797, siz=4, lab1=.L5296, lab2=, loff=0
!   reloc[1893]: knd=0, off=17807, siz=4, lab1=.L5297, lab2=, loff=0
!   reloc[1894]: knd=0, off=17815, siz=4, lab1=.L5300, lab2=, loff=0
!   reloc[1895]: knd=0, off=17825, siz=4, lab1=.L5304, lab2=, loff=0
!   reloc[1896]: knd=0, off=17833, siz=4, lab1=.L5310, lab2=, loff=0
!   reloc[1897]: knd=0, off=17843, siz=4, lab1=.L5311, lab2=, loff=0
!   reloc[1898]: knd=0, off=17851, siz=4, lab1=.L5312, lab2=, loff=0
!   reloc[1899]: knd=0, off=17861, siz=4, lab1=.L5318, lab2=, loff=0
!   reloc[1900]: knd=0, off=17872, siz=4, lab1=.L5326, lab2=, loff=0
!   reloc[1901]: knd=0, off=17883, siz=4, lab1=.L5327, lab2=, loff=0
!   reloc[1902]: knd=0, off=17891, siz=4, lab1=.L5328, lab2=, loff=0
!   reloc[1903]: knd=0, off=17899, siz=4, lab1=.L5329, lab2=, loff=0
!   reloc[1904]: knd=0, off=17907, siz=4, lab1=.L5330, lab2=, loff=0
!   reloc[1905]: knd=0, off=17917, siz=4, lab1=.L5331, lab2=, loff=0
!   reloc[1906]: knd=0, off=17925, siz=4, lab1=.L5332, lab2=, loff=0
!   reloc[1907]: knd=0, off=17933, siz=4, lab1=.L5333, lab2=, loff=0
!   reloc[1908]: knd=0, off=17943, siz=4, lab1=.L5335, lab2=, loff=0
!   reloc[1909]: knd=0, off=17953, siz=4, lab1=.L5336, lab2=, loff=0
!   reloc[1910]: knd=0, off=17961, siz=4, lab1=.L5337, lab2=, loff=0
!   reloc[1911]: knd=0, off=17969, siz=4, lab1=.L5338, lab2=, loff=0
!   reloc[1912]: knd=0, off=17977, siz=4, lab1=.L5339, lab2=, loff=0
!   reloc[1913]: knd=0, off=17985, siz=4, lab1=.L5340, lab2=, loff=0
!   reloc[1914]: knd=0, off=17993, siz=4, lab1=.L5343, lab2=, loff=0
!   reloc[1915]: knd=0, off=18003, siz=4, lab1=.L5350, lab2=, loff=0
!   reloc[1916]: knd=0, off=18013, siz=4, lab1=.L5351, lab2=, loff=0
!   reloc[1917]: knd=0, off=18023, siz=4, lab1=.L5352, lab2=, loff=0
!   reloc[1918]: knd=0, off=18031, siz=4, lab1=.L5354, lab2=, loff=0
!   reloc[1919]: knd=0, off=18039, siz=4, lab1=.L5361, lab2=, loff=0
!   reloc[1920]: knd=0, off=18047, siz=4, lab1=.L5372, lab2=, loff=0
!   reloc[1921]: knd=0, off=18055, siz=4, lab1=.L5375, lab2=, loff=0
!   reloc[1922]: knd=0, off=18065, siz=4, lab1=.L5376, lab2=, loff=0
!   reloc[1923]: knd=0, off=18075, siz=4, lab1=.L5377, lab2=, loff=0
!   reloc[1924]: knd=0, off=18083, siz=4, lab1=.L5378, lab2=, loff=0
!   reloc[1925]: knd=0, off=18093, siz=4, lab1=.L5379, lab2=, loff=0
!   reloc[1926]: knd=0, off=18101, siz=4, lab1=.L5380, lab2=, loff=0
!   reloc[1927]: knd=0, off=18109, siz=4, lab1=.L5381, lab2=, loff=0
!   reloc[1928]: knd=0, off=18119, siz=4, lab1=.L5382, lab2=, loff=0
!   reloc[1929]: knd=0, off=18129, siz=4, lab1=.L5383, lab2=, loff=0
!   reloc[1930]: knd=0, off=18137, siz=4, lab1=.L5384, lab2=, loff=0
!   reloc[1931]: knd=0, off=18145, siz=4, lab1=.L5385, lab2=, loff=0
!   reloc[1932]: knd=0, off=18155, siz=4, lab1=.L5386, lab2=, loff=0
!   reloc[1933]: knd=0, off=18163, siz=4, lab1=.L5389, lab2=, loff=0
!   reloc[1934]: knd=0, off=18173, siz=4, lab1=.L5393, lab2=, loff=0
!   reloc[1935]: knd=0, off=18181, siz=4, lab1=.L5399, lab2=, loff=0
!   reloc[1936]: knd=0, off=18191, siz=4, lab1=.L5400, lab2=, loff=0
!   reloc[1937]: knd=0, off=18199, siz=4, lab1=.L5401, lab2=, loff=0
!   reloc[1938]: knd=0, off=18209, siz=4, lab1=.L5407, lab2=, loff=0
!   reloc[1939]: knd=0, off=18220, siz=4, lab1=.L5417, lab2=, loff=0
!   reloc[1940]: knd=0, off=18233, siz=4, lab1=.L5420, lab2=, loff=0
!   reloc[1941]: knd=0, off=18241, siz=4, lab1=.L5427, lab2=, loff=0
!   reloc[1942]: knd=0, off=18254, siz=4, lab1=null_line, lab2=, loff=0
!   reloc[1943]: knd=0, off=18261, siz=4, lab1=.L5434, lab2=, loff=0
!   reloc[1944]: knd=0, off=18278, siz=4, lab1=gl_set_line_function, lab2=, loff=0
!   reloc[1945]: knd=0, off=18285, siz=4, lab1=.L5441, lab2=, loff=0
!   reloc[1946]: knd=0, off=18297, siz=4, lab1=.L5444, lab2=, loff=0
!   reloc[1947]: knd=0, off=18307, siz=4, lab1=.L5450, lab2=, loff=0
!   reloc[1948]: knd=0, off=18315, siz=4, lab1=.L5454, lab2=, loff=0
!   reloc[1949]: knd=0, off=18323, siz=4, lab1=.L5455, lab2=, loff=0
!   reloc[1950]: knd=0, off=18331, siz=4, lab1=.L5461, lab2=, loff=0
!   reloc[1951]: knd=0, off=18339, siz=4, lab1=.L5465, lab2=, loff=0
!   reloc[1952]: knd=0, off=18347, siz=4, lab1=.L5472, lab2=, loff=0
!   reloc[1953]: knd=0, off=18355, siz=4, lab1=.L5478, lab2=, loff=0
!   reloc[1954]: knd=0, off=18363, siz=4, lab1=.L5482, lab2=, loff=0
!   reloc[1955]: knd=0, off=18371, siz=4, lab1=.L5488, lab2=, loff=0
!   reloc[1956]: knd=0, off=18381, siz=4, lab1=.L5498, lab2=, loff=0
!   reloc[1957]: knd=0, off=18391, siz=4, lab1=.L5508, lab2=, loff=0
!   reloc[1958]: knd=0, off=18399, siz=4, lab1=.L5512, lab2=, loff=0
!   reloc[1959]: knd=0, off=18407, siz=4, lab1=.L5521, lab2=, loff=0
!   reloc[1960]: knd=0, off=18417, siz=4, lab1=.L5535, lab2=, loff=0
!   reloc[1961]: knd=0, off=18427, siz=4, lab1=.L5541, lab2=, loff=0
!   reloc[1962]: knd=0, off=18437, siz=4, lab1=.L5548, lab2=, loff=0
!   reloc[1963]: knd=0, off=18445, siz=4, lab1=.L5557, lab2=, loff=0
!   reloc[1964]: knd=0, off=18455, siz=4, lab1=.L5571, lab2=, loff=0
!   reloc[1965]: knd=0, off=18465, siz=4, lab1=.L5578, lab2=, loff=0
!   reloc[1966]: knd=0, off=18473, siz=4, lab1=.L5587, lab2=, loff=0
!   reloc[1967]: knd=0, off=18483, siz=4, lab1=.L5610, lab2=, loff=0
!   reloc[1968]: knd=0, off=18493, siz=4, lab1=.L5614, lab2=, loff=0
!   reloc[1969]: knd=0, off=18501, siz=4, lab1=.L5620, lab2=, loff=0
!   reloc[1970]: knd=0, off=18511, siz=4, lab1=.L5626, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x48,0x55,0x00,0x02,0x00,0x00
	.byte 0x01,0xdb,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x6c,0x69,0x6e,0x65,0x73
	.byte 0x2e,0x63,0x00,0x01,0x00,0x00,0x74,0x79
	.byte 0x70,0x65,0x73,0x2e,0x68,0x00,0x01,0x00
	.byte 0x00,0x67,0x6c,0x2e,0x68,0x00,0x02,0x00
	.byte 0x00,0x64,0x64,0x2e,0x68,0x00,0x01,0x00
	.byte 0x00,0x76,0x62,0x2e,0x68,0x00,0x01,0x00
	.byte 0x00,0x70,0x62,0x2e,0x68,0x00,0x01,0x00
	.byte 0x00,0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d
	.byte 0x70,0x2e,0x68,0x00,0x01,0x00,0x00,0x6c
	.byte 0x69,0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e
	.byte 0x68,0x00,0x01,0x00,0x00,0x6c,0x69,0x6e
	.byte 0x65,0x74,0x65,0x6d,0x70,0x2e,0x68,0x00
	.byte 0x01,0x00,0x00,0x6c,0x69,0x6e,0x65,0x74
	.byte 0x65,0x6d,0x70,0x2e,0x68,0x00,0x01,0x00
	.byte 0x00,0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d
	.byte 0x70,0x2e,0x68,0x00,0x01,0x00,0x00,0x6c
	.byte 0x69,0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e
	.byte 0x68,0x00,0x01,0x00,0x00,0x6c,0x69,0x6e
	.byte 0x65,0x74,0x65,0x6d,0x70,0x2e,0x68,0x00
	.byte 0x01,0x00,0x00,0x66,0x69,0x78,0x65,0x64
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x6c,0x69
	.byte 0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x6c,0x69,0x6e,0x65
	.byte 0x74,0x65,0x6d,0x70,0x2e,0x68,0x00,0x01
	.byte 0x00,0x00,0x6c,0x69,0x6e,0x65,0x74,0x65
	.byte 0x6d,0x70,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d,0x70
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x6c,0x69
	.byte 0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x6c,0x69,0x6e,0x65
	.byte 0x74,0x65,0x6d,0x70,0x2e,0x68,0x00,0x01
	.byte 0x00,0x00,0x6c,0x69,0x6e,0x65,0x74,0x65
	.byte 0x6d,0x70,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d,0x70
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x6c,0x69
	.byte 0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x6c,0x69,0x6e,0x65
	.byte 0x74,0x65,0x6d,0x70,0x2e,0x68,0x00,0x01
	.byte 0x00,0x00,0x6c,0x69,0x6e,0x65,0x74,0x65
	.byte 0x6d,0x70,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d,0x70
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x6c,0x69
	.byte 0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x6c,0x69,0x6e,0x65
	.byte 0x74,0x65,0x6d,0x70,0x2e,0x68,0x00,0x01
	.byte 0x00,0x00,0x6c,0x69,0x6e,0x65,0x74,0x65
	.byte 0x6d,0x70,0x2e,0x68,0x00,0x01,0x00,0x00
	.byte 0x6c,0x69,0x6e,0x65,0x74,0x65,0x6d,0x70
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x6c,0x69
	.byte 0x6e,0x65,0x74,0x65,0x6d,0x70,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x00,0x00,0x05,0x02
	.uaword gl_LineWidth
	.byte 0x00,0x05,0x02
	.uaword .L18
	.byte 0x06,0x03,0xe5,0x00,0x01,0x00,0x05,0x02
	.uaword .L22
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L24
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L30
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L34
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L36
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L40
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L41
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L42
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_LineStipple
	.byte 0x00,0x05,0x02
	.uaword .L51
	.byte 0x06,0x03,0xf5,0x00,0x01,0x00,0x05,0x02
	.uaword .L55
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L57
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L61
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L68
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L69
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L70
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword feedback_line
	.byte 0x00,0x05,0x02
	.uaword .L77
	.byte 0x06,0x03,0x98,0x01,0x01,0x00,0x05,0x02
	.uaword .L78
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L79
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L80
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L81
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L82
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L83
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L84
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L85
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L86
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L87
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L88
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L89
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L90
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L94
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L95
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L96
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L97
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L98
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L102
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L103
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L104
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L105
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L108
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L128
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L139
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L141
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L142
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L143
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L144
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L146
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L147
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword select_line
	.byte 0x00,0x05,0x02
	.uaword .L154
	.byte 0x06,0x03,0xd1,0x01,0x01,0x00,0x05,0x02
	.uaword .L155
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L156
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword flat_ci_line
	.byte 0x00,0x05,0x02
	.uaword .L163
	.byte 0x06,0x03,0xe3,0x01,0x01,0x00,0x05,0x02
	.uaword .L164
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L178
	.byte 0x04,0x07,0x03,0xf0,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L179
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L180
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L181
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L185
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L190
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L196
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L200
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L201
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L207
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L213
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L217
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L218
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L224
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L230
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L234
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L235
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L238
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L245
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L246
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L249
	.byte 0x03,0x21,0x01,0x00,0x05,0x02
	.uaword .L253
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L259
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L260
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L266
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L274
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L275
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L276
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L278
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L285
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L286
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L289
	.byte 0x03,0x21,0x01,0x00,0x05,0x02
	.uaword .L293
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L299
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L300
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L306
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L313
	.byte 0x04,0x01,0x03,0xd9,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L316
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L323
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword flat_ci_z_line
	.byte 0x00,0x05,0x02
	.uaword .L330
	.byte 0x06,0x03,0xfc,0x01,0x01,0x00,0x05,0x02
	.uaword .L331
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L335
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L346
	.byte 0x04,0x08,0x03,0xd6,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L347
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L349
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L350
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L353
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L358
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L362
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L363
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L367
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L371
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L372
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L373
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L379
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L380
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L386
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L390
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L391
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L392
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L398
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L399
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L405
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L409
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L410
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L411
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L412
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L414
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L421
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L422
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L423
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L424
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L425
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L428
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L432
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L438
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L439
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L440
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L446
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L454
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L455
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L456
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L457
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L459
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L466
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L467
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L468
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L469
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L470
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L473
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L477
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L483
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L484
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L485
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L491
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L498
	.byte 0x04,0x01,0x03,0xf5,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L501
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L508
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword flat_rgba_line
	.byte 0x00,0x05,0x02
	.uaword .L515
	.byte 0x06,0x03,0x98,0x02,0x01,0x00,0x05,0x02
	.uaword .L516
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L517
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L520
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L532
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L534
	.byte 0x04,0x09,0x03,0xba,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L535
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L536
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L537
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L538
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L541
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L546
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L552
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L556
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L557
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L563
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L569
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L573
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L574
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L580
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L586
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L590
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L591
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L592
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L594
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L601
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L602
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L605
	.byte 0x03,0x21,0x01,0x00,0x05,0x02
	.uaword .L609
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L615
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L616
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L622
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L630
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L631
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L632
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L634
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L641
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L642
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L645
	.byte 0x03,0x21,0x01,0x00,0x05,0x02
	.uaword .L649
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L655
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L656
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L662
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L669
	.byte 0x04,0x01,0x03,0x8f,0x7f,0x01,0x00,0x05
	.byte 0x02
	.uaword .L672
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L679
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword flat_rgba_z_line
	.byte 0x00,0x05,0x02
	.uaword .L686
	.byte 0x06,0x03,0xb2,0x02,0x01,0x00,0x05,0x02
	.uaword .L687
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L688
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L689
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L704
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L706
	.byte 0x04,0x0a,0x03,0x9f,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L707
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L709
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L710
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L713
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L718
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L722
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L723
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L724
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L727
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L731
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L732
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L733
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L739
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L740
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L746
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L751
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L752
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L758
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L759
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L765
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L769
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L770
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L771
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L772
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L774
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L781
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L782
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L783
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L784
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L785
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L788
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L792
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L798
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L799
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L800
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L806
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L814
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L815
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L816
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L817
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L819
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L826
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L827
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L828
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L829
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L833
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L837
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L843
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L844
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L845
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L851
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L858
	.byte 0x04,0x01,0x03,0xac,0x7f,0x01,0x00,0x05
	.byte 0x02
	.uaword .L861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L868
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword smooth_ci_line
	.byte 0x00,0x05,0x02
	.uaword .L875
	.byte 0x06,0x03,0xce,0x02,0x01,0x00,0x05,0x02
	.uaword .L876
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L877
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L878
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L880
	.byte 0x04,0x0b,0x03,0x85,0x7e,0x01,0x00,0x05
	.byte 0x02
	.uaword .L881
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L882
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L883
	.byte 0x03,0x16,0x01,0x00,0x05,0x02
	.uaword .L884
	.byte 0x03,0x36,0x01,0x00,0x05,0x02
	.uaword .L885
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L888
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L893
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L899
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L903
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L904
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L910
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L916
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L920
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L921
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L927
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L933
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L937
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L938
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L939
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L940
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L942
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L949
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L950
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L951
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L952
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L955
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L965
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L966
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L972
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L980
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L981
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L983
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L985
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L992
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L993
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L994
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L995
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L998
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1002
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1008
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1009
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1015
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1022
	.byte 0x04,0x01,0x03,0x46,0x01,0x00,0x05,0x02
	.uaword .L1025
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1032
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword smooth_ci_z_line
	.byte 0x00,0x05,0x02
	.uaword .L1039
	.byte 0x06,0x03,0xe8,0x02,0x01,0x00,0x05,0x02
	.uaword .L1040
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1041
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1042
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1043
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1045
	.byte 0x04,0x0c,0x03,0xea,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1046
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1048
	.byte 0x03,0x16,0x01,0x00,0x05,0x02
	.uaword .L1049
	.byte 0x03,0x36,0x01,0x00,0x05,0x02
	.uaword .L1050
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1053
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1058
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1062
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1063
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1064
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1067
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1071
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1072
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1073
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1079
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1080
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1086
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1090
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1091
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1092
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1098
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1099
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1105
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1109
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1110
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1111
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1112
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1113
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1115
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1122
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1123
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1124
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L1125
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1126
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1127
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1128
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1131
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1141
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1142
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1143
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1149
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1157
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L1158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1159
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1160
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1161
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1163
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1170
	.byte 0x03,0x08,0x01,0x00
	.byte 0x05,0x02
	.uaword .L1171
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1172
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L1173
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1174
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1175
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1176
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1179
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1183
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1189
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1190
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1191
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1197
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1204
	.byte 0x04,0x01,0x03,0x63,0x01,0x00,0x05,0x02
	.uaword .L1207
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1214
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword smooth_rgba_line
	.byte 0x00,0x05,0x02
	.uaword .L1221
	.byte 0x06,0x03,0x85,0x03,0x01,0x00,0x05,0x02
	.uaword .L1222
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1223
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1224
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1225
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1226
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1229
	.byte 0x04,0x0d,0x03,0xcb,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1230
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1232
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1233
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1234
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1235
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1237
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1238
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1240
	.byte 0x03,0x39,0x01,0x00,0x05,0x02
	.uaword .L1241
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1244
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1249
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1255
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L1259
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1260
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1266
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1272
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1276
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1277
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1283
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1289
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L1293
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1295
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1296
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1298
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1299
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1301
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1308
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L1309
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1310
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1311
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1313
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1316
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1320
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1326
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1327
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1333
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1341
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L1342
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1343
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1344
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1345
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1346
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1347
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1349
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1356
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L1357
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1358
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1359
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1360
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1361
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1364
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1368
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1374
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1375
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1381
	.byte 0x03,0xb6,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1388
	.byte 0x04,0x01,0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1391
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1398
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword smooth_rgba_z_line
	.byte 0x00,0x05,0x02
	.uaword .L1405
	.byte 0x06,0x03,0xa6,0x03,0x01,0x00,0x05,0x02
	.uaword .L1406
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1408
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1409
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1410
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1411
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1412
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1414
	.byte 0x04,0x0f,0x03,0xa9,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1415
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1416
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1417
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1418
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1419
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1421
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1422
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1423
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1424
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1425
	.byte 0x03,0x39,0x01,0x00,0x05,0x02
	.uaword .L1426
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1429
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1434
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1438
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1439
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1440
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1443
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1448
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1449
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1455
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1456
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1462
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1466
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1467
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1468
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1474
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1475
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1481
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1485
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1486
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1487
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1488
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1489
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1490
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1491
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1492
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1494
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1501
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1502
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L1503
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1504
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1505
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1506
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1507
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1509
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1512
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1516
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1522
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1524
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1530
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1538
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L1539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1540
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1542
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1543
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1545
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1547
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1554
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1555
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L1556
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1557
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1558
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1559
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1560
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1561
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1562
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1565
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L1569
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1575
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1576
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1577
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1583
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1590
	.byte 0x04,0x01,0x03,0x28,0x01,0x00,0x05,0x02
	.uaword .L1593
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1600
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword general_smooth_ci_line
	.byte 0x00,0x05,0x02
	.uaword .L1607
	.byte 0x06,0x03,0xd2,0x03,0x01,0x00,0x05,0x02
	.uaword .L1608
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1609
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1610
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1611
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1614
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1619
	.byte 0x04,0x10,0x03,0xfe,0x7c,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1620
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1621
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1622
	.byte 0x03,0x16,0x01,0x00,0x05,0x02
	.uaword .L1623
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L1630
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1631
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1632
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L1633
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1636
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1641
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1645
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1646
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1647
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1650
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1654
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1655
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1656
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1662
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1663
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1669
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1674
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1675
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1681
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1682
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1688
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1692
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1693
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1694
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1695
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1696
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1698
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1705
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1712
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1713
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1714
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1717
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1724
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1735
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1741
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L1742
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1743
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1744
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1745
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1748
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1752
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1758
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1759
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1760
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1766
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1774
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L1775
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1776
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1777
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1778
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1780
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1787
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1790
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1794
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1795
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1796
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1797
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1799
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1806
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1817
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1823
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L1824
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1825
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1827
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1830
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1840
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1841
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1842
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1848
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1862
	.byte 0x04,0x01,0x03,0xd2,0x00,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1867
	.byte 0x04,0x11,0x03,0xec,0x7c,0x01,0x00,0x05
	.byte 0x02
	.uaword .L1868
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1869
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1870
	.byte 0x03,0x16,0x01,0x00,0x05,0x02
	.uaword .L1871
	.byte 0x03,0x36,0x01,0x00,0x05,0x02
	.uaword .L1872
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1875
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1880
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1884
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1885
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1886
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1889
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1893
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1894
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1895
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1901
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1902
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1908
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1912
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1913
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1914
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1920
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1921
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1927
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1931
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1932
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1933
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1934
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1935
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1937
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1944
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1945
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1946
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1947
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1948
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1949
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1950
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1953
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1957
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1963
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1964
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1965
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1971
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L1979
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L1980
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1981
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1982
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1983
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1985
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L1992
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L1993
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L1994
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1995
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1996
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1997
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1998
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2001
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L2005
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2011
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2012
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2013
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2019
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2032
	.byte 0x04,0x12,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2033
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2035
	.byte 0x03,0x16,0x01,0x00,0x05,0x02
	.uaword .L2036
	.byte 0x03,0x18,0x01,0x00,0x05,0x02
	.uaword .L2043
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2044
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2045
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L2046
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2054
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2058
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2059
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2060
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2063
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2067
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2068
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2069
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2075
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2076
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2082
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2086
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2087
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2088
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2094
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2095
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2101
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2105
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2106
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2107
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2108
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2109
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2111
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L2118
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2119
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L2120
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2121
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2123
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2130
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2141
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2144
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L2145
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2146
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2147
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2150
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L2154
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2160
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2161
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2162
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2168
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2176
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L2177
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2178
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2179
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2180
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2182
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L2189
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2190
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L2191
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2192
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2194
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2201
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2212
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2215
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L2216
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2217
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2218
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2221
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L2225
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2231
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2232
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2233
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2239
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2252
	.byte 0x04,0x01,0x03,0xf6,0x00,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2255
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2262
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword general_flat_ci_line
	.byte 0x00,0x05,0x02
	.uaword .L2269
	.byte 0x06,0x03,0x98,0x04,0x01,0x00,0x05,0x02
	.uaword .L2270
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2271
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2274
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2283
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2286
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2291
	.byte 0x04,0x13,0x03,0xb8,0x7c,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2292
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2293
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2294
	.byte 0x03,0x2e,0x01,0x00,0x05,0x02
	.uaword .L2301
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2302
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2303
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L2304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2307
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2316
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2317
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2321
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2325
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2326
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2327
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2333
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2334
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2340
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2345
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2346
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2352
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2353
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2359
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2363
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2365
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2366
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2368
	.byte 0x03,0x1d,0x01,0x00
	.byte 0x05,0x02
	.uaword .L2375
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2378
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2382
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2383
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2393
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2404
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2410
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L2411
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2412
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2413
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2416
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2426
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2427
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2428
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2434
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2442
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L2443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2444
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2445
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2447
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2454
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2461
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2462
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2463
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2465
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2483
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2489
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L2490
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2491
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2492
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2495
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2499
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2505
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2506
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2507
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2513
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2527
	.byte 0x04,0x01,0x03,0x96,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2532
	.byte 0x04,0x14,0x03,0xa8,0x7c,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2533
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2534
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2535
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L2536
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2548
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2549
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2550
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2553
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2557
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2558
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2559
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2565
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2566
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2572
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2576
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2577
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2578
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2584
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2585
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2591
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2595
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2596
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2598
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2600
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2607
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2608
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L2609
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2610
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2611
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2614
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2618
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2624
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2625
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2626
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2632
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2640
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L2641
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2642
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2643
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2645
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2652
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2653
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L2654
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2655
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2656
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2659
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2663
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2669
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2670
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2671
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2677
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2690
	.byte 0x04,0x15,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2691
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2693
	.byte 0x03,0x2e,0x01,0x00,0x05,0x02
	.uaword .L2700
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2701
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2702
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L2703
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2706
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2711
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2715
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2716
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2717
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2720
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2724
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2725
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2726
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2732
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2733
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2739
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2743
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2744
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2745
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2751
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2752
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2758
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2762
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2763
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2764
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2765
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2767
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2774
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2775
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2776
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2778
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2785
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2796
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2799
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L2800
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2804
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2814
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2815
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2816
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2822
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2830
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L2831
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2832
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2833
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2835
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2842
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2843
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2844
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2846
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2853
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2864
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2867
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L2868
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2869
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2872
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L2876
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2882
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2883
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2884
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2890
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L2903
	.byte 0x04,0x01,0x03,0xb5,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2906
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2913
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword general_smooth_rgba_line
	.byte 0x00,0x05,0x02
	.uaword .L2920
	.byte 0x06,0x03,0xd6,0x04,0x01,0x00,0x05,0x02
	.uaword .L2921
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2922
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2923
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2924
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2925
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2926
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2927
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2930
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2935
	.byte 0x04,0x16,0x03,0xf7,0x7b,0x01,0x00,0x05
	.byte 0x02
	.uaword .L2936
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2937
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2938
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2939
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2940
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2942
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2943
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2944
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2945
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2946
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L2953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2954
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2955
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L2956
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2964
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2968
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2969
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2970
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2973
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2977
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2978
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2979
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2985
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2986
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2992
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2997
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2998
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3004
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3005
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3011
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3015
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3017
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3018
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3019
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3020
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3021
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3022
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3024
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3031
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3038
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3039
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3040
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3042
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3060
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3066
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L3067
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3068
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3069
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3070
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3071
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3072
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3073
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3076
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3080
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3086
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3087
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3088
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3094
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3102
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L3103
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3104
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3105
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3106
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3107
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3108
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3109
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3111
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3118
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3121
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3125
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3126
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3127
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3129
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3147
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3153
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L3154
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3155
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3157
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3159
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3160
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3163
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3173
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3174
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3175
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3181
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3195
	.byte 0x04,0x01,0x03,0xdd,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3200
	.byte 0x04,0x17,0x03,0xe1,0x7b,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3201
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3202
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3203
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3204
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3205
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3206
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3207
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3208
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3209
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3210
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3211
	.byte 0x03,0x39,0x01,0x00,0x05,0x02
	.uaword .L3212
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3220
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3224
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3225
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3226
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3229
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3233
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3234
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3235
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3241
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3242
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3248
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3252
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3253
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3254
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3260
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3261
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3267
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3271
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3272
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3273
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3274
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3275
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3276
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3277
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3278
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3280
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3287
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3288
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L3289
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3290
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3291
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3292
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3293
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3295
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3298
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3302
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3308
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3309
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3310
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3316
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3324
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L3325
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3327
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3328
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3329
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3331
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3333
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3340
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3341
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L3342
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3343
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3345
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3346
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3347
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3348
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3351
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3355
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3361
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3362
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3363
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3369
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3382
	.byte 0x04,0x18,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3383
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3385
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3387
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3388
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3389
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3390
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3391
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3392
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3393
	.byte 0x03,0x1b,0x01,0x00,0x05,0x02
	.uaword .L3400
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3401
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3402
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L3403
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3406
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3411
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3415
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3416
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3417
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3420
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3424
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3425
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3426
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3432
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3433
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3439
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3444
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3445
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3451
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3452
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3458
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3462
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3463
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3464
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3465
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3466
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3467
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3468
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3469
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3471
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3478
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3479
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3480
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3482
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3489
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3500
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3503
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L3504
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3505
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3506
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3507
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3509
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3512
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3516
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3522
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3524
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3530
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3538
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L3539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3540
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3542
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3543
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3545
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3547
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3554
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3555
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3556
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3558
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3576
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3579
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L3580
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3581
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3582
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3583
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3584
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3585
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3588
	.byte 0x03,0x15,0x01,0x00,0x05,0x02
	.uaword .L3592
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3598
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3599
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3600
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3606
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3619
	.byte 0x04,0x01,0x03,0x8c,0x02,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3622
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3629
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword general_flat_rgba_line
	.byte 0x00,0x05,0x02
	.uaword .L3636
	.byte 0x06,0x03,0xad,0x05,0x01,0x00,0x05,0x02
	.uaword .L3637
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3638
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3639
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3642
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3654
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3657
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3662
	.byte 0x04,0x19,0x03,0xa2,0x7b,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3663
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3665
	.byte 0x03,0x2e,0x01,0x00,0x05,0x02
	.uaword .L3672
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3674
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L3675
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3678
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3687
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3688
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3689
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3692
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3696
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3697
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3698
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3704
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3705
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3711
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3716
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3717
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3723
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3724
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3730
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3734
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3735
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3736
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3737
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3739
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3746
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3749
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3753
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3754
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3755
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3757
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3764
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3775
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3781
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L3782
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3783
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3784
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3787
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3791
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3797
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3798
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3799
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3805
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3813
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L3814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3815
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3816
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3818
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3825
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3828
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3832
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3833
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3836
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3843
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3854
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3860
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L3861
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3862
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3863
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3866
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3876
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3877
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3878
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3884
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L3898
	.byte 0x04,0x01,0x03,0xac,0x02,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3903
	.byte 0x04,0x1a,0x03,0x92,0x7b,0x01,0x00,0x05
	.byte 0x02
	.uaword .L3904
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3905
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3906
	.byte 0x03,0xcc,0x00,0x01,0x00,0x05,0x02
	.uaword .L3907
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3910
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3915
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3919
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3920
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3921
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3924
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3928
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3929
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3930
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3936
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3937
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3943
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3947
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3948
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3949
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3955
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3956
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3962
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L3966
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3967
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3968
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3969
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3971
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3978
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3979
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L3980
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L3981
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3985
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L3989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3995
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3996
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3997
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4003
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4011
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L4012
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4013
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4014
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4016
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4023
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4024
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L4025
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4026
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4027
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4030
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4040
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4041
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4042
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4048
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4061
	.byte 0x04,0x1b,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4062
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4063
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4064
	.byte 0x03,0x2e,0x01,0x00,0x05,0x02
	.uaword .L4071
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4072
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4073
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L4074
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4077
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4082
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4086
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4087
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4088
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4091
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4095
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4096
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4097
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4103
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4104
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4110
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L4114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4115
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4116
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4122
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4123
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4129
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4133
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4134
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4136
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4138
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4145
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4146
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4147
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4149
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4167
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4170
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L4171
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4172
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4175
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4179
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4185
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4186
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4187
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4193
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4201
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L4202
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4203
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4204
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4206
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4213
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4214
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4217
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4224
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4235
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4238
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L4239
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4240
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4243
	.byte 0x03,0x1d,0x01,0x00,0x05,0x02
	.uaword .L4247
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4253
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4254
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4255
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4261
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4274
	.byte 0x04,0x01,0x03,0xcb,0x02,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4277
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4284
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword flat_textured_line
	.byte 0x00,0x05,0x02
	.uaword .L4291
	.byte 0x06,0x03,0xee,0x05,0x01,0x00,0x05,0x02
	.uaword .L4292
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4293
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4295
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4296
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4300
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4315
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4320
	.byte 0x04,0x1c,0x03,0xde,0x7a,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4321
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4322
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4323
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L4324
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4325
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4326
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4328
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L4335
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4336
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4337
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L4338
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4341
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4346
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4350
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4351
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4355
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4359
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4360
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4361
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4367
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4368
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4374
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L4378
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4379
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4380
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4386
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4387
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4393
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4397
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4398
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4399
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4400
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4402
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L4403
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4404
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4405
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4406
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4410
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4417
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4424
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4425
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4426
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4428
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4435
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4446
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4452
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L4453
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4454
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4455
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4456
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L4457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4458
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4459
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4460
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4463
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4467
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4473
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4474
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4475
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4481
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4489
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L4490
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4491
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4492
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4494
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L4495
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4496
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4497
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4498
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4499
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4502
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4509
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4512
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4516
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4517
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4518
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4520
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4538
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4544
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L4545
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4546
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4547
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4548
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L4549
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4550
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4551
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4552
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4555
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4559
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4565
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4566
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4567
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4573
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4586
	.byte 0x04,0x1d,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4587
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4588
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4589
	.byte 0x03,0x1f,0x01,0x00,0x05,0x02
	.uaword .L4590
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4591
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4592
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4593
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4594
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L4601
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4603
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L4604
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4607
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4612
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4616
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4617
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4618
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4621
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4625
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4626
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4627
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4633
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4634
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4640
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L4644
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4645
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4646
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4652
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4653
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4659
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4663
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4666
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4668
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L4669
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4670
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4671
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4672
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4676
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4683
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4684
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4685
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4687
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4694
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4705
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4708
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L4709
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4710
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4711
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L4712
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4713
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4714
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4718
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4722
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4728
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4729
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4730
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4736
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4744
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L4745
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4746
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4747
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4749
	.byte 0x03,0x13,0x01,0x00,0x05,0x02
	.uaword .L4750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4751
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4752
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4753
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4754
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4757
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4764
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4765
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4766
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4768
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4775
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4786
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4789
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L4790
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4791
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4792
	.byte 0x03,0x12,0x01,0x00,0x05,0x02
	.uaword .L4793
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4795
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4799
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4803
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4809
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4810
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4811
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4817
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L4827
	.byte 0x04,0x01,0x03,0x86,0x03,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4837
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword smooth_textured_line
	.byte 0x00,0x05,0x02
	.uaword .L4844
	.byte 0x06,0x03,0xa8,0x06,0x01,0x00,0x05,0x02
	.uaword .L4845
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4846
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4847
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4849
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4850
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4852
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4853
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4854
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4857
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4862
	.byte 0x04,0x1e,0x03,0xa2,0x7a,0x01,0x00,0x05
	.byte 0x02
	.uaword .L4863
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4864
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4865
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4866
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4867
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4868
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4869
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4871
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4872
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4873
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L4874
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4875
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4876
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4877
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4878
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L4885
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4886
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4887
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L4888
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4891
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4896
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4900
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4901
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4902
	.byte 0x0c,0x00,0x05
	.byte 0x02
	.uaword .L4905
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4909
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4910
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4911
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4917
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4918
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4924
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L4928
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4929
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4930
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4936
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L4937
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4943
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4947
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L4948
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4949
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4950
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4951
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4952
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4954
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4956
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L4957
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4958
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4960
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4961
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4964
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4971
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4974
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4978
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L4979
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L4980
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5000
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L5006
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L5007
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5008
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5009
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5010
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5011
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5012
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5013
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5014
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5015
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5017
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5018
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5021
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5025
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5031
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5032
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5033
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5039
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L5047
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L5048
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5050
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5051
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5052
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5053
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5054
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5056
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L5057
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5058
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5059
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5060
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5061
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5064
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5071
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5074
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5078
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5079
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5080
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5082
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5089
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5100
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L5106
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L5107
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5108
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5109
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5110
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5111
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5112
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5113
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5114
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5115
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5116
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5117
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5118
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5121
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5125
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5131
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5132
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5133
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5139
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L5152
	.byte 0x04,0x1f,0x03,0xbe,0x7d,0x01,0x00,0x05
	.byte 0x02
	.uaword .L5153
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5154
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5155
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5157
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5159
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5160
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5161
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5163
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L5164
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5165
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5166
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5168
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L5175
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5177
	.byte 0x03,0x1c,0x01,0x00,0x05,0x02
	.uaword .L5178
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5181
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5186
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5190
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L5191
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5192
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5195
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5199
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5200
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5201
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5207
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L5208
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5214
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L5218
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5219
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5220
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5226
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L5227
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5233
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L5237
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5238
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5240
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5241
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5242
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5243
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5244
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5246
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L5247
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5248
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5249
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5250
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5251
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5254
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5261
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L5262
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5263
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5265
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5272
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5283
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L5286
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L5287
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5288
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5289
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5290
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5291
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5292
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5293
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5295
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5296
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5300
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5310
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5311
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5312
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5318
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L5326
	.byte 0x03,0xda,0x00,0x01,0x00,0x05,0x02
	.uaword .L5327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5328
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5329
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5330
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5331
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5333
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5335
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L5336
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5337
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5338
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5339
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5340
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5343
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5350
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L5351
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5354
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5361
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5372
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L5375
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L5376
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5377
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5378
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5379
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5380
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5381
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5382
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L5383
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5385
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5389
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5393
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5399
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5400
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5401
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5407
	.byte 0x03,0xb3,0x7f,0x01,0x00,0x05,0x02
	.uaword .L5417
	.byte 0x04,0x01,0x03,0xce,0x03,0x01,0x00,0x05
	.byte 0x02
	.uaword .L5420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5427
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword null_line
	.byte 0x00,0x05,0x02
	.uaword .L5434
	.byte 0x06,0x03,0xf1,0x06,0x01,0x02,0x01,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_set_line_function
	.byte 0x00,0x05,0x02
	.uaword .L5441
	.byte 0x06,0x03,0xfb,0x06,0x01,0x00,0x05,0x02
	.uaword .L5444
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5450
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5454
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5455
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5461
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5465
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5472
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5478
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5482
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5488
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5498
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5512
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5521
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5535
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5541
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L5548
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5557
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5571
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L5578
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L5587
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5610
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L5614
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L5620
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L5626
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
	.byte 0x04,0x24,0x00,0x03,0x08,0x3e,0x0b,0x0b
	.byte 0x0b,0x00,0x00,0x05,0x16,0x00,0x49,0x13
	.byte 0x03,0x08,0x3a,0x0b,0x00,0x00,0x06,0x13
	.byte 0x00,0x03,0x08,0x3c,0x0c,0x00,0x00,0x07
	.byte 0x0f,0x00,0x49,0x13,0x00,0x00,0x08,0x01
	.byte 0x01,0x49,0x13,0x0b,0x0b,0x01,0x13,0x00
	.byte 0x00,0x09,0x21,0x00,0x49,0x13,0x2f,0x0b
	.byte 0x00,0x00,0x0a,0x04,0x01,0x0b,0x0b,0x3a
	.byte 0x0b,0x01,0x13,0x00,0x00,0x0b,0x28,0x00
	.byte 0x03,0x08,0x1c,0x0d,0x00,0x00,0x0c,0x13
	.byte 0x01,0x03,0x08,0x0b,0x0b,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x0d,0x0d,0x00,0x03,0x08
	.byte 0x49,0x13,0x38,0x0a,0x00,0x00,0x0e,0x01
	.byte 0x01,0x49,0x13,0x0b,0x05,0x01,0x13,0x00
	.byte 0x00,0x0f,0x21,0x00,0x49,0x13,0x2f,0x05
	.byte 0x00,0x00,0x10,0x13,0x01,0x03,0x08,0x0b
	.byte 0x05,0x3a,0x0b,0x01,0x13,0x00,0x00,0x11
	.byte 0x26,0x00,0x49,0x13,0x00,0x00,0x12,0x15
	.byte 0x01,0x27,0x0c,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x13,0x05,0x00,0x49,0x13,0x00
	.byte 0x00,0x14,0x15,0x01,0x27,0x0c,0x49,0x13
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x15
	.byte 0x15,0x00,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x00,0x00,0x16,0x01,0x01,0x49,0x13
	.byte 0x0b,0x06,0x01,0x13,0x00,0x00,0x17,0x13
	.byte 0x01,0x03,0x08,0x0b,0x06,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x18,0x2e,0x01,0x03,0x08
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x11,0x01
	.byte 0x12,0x01,0x40,0x0a,0x27,0x0c,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x19,0x34,0x00
	.byte 0x03,0x08,0x49,0x13,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x1a,0x0b
	.byte 0x01,0x11,0x01,0x12,0x01,0x00,0x00,0x1b
	.byte 0x34,0x00,0x03,0x08,0x49,0x13,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x02,0x0a,0x00,0x00
	.byte 0x1c,0x2e,0x01,0x03,0x08,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x05,0x11,0x01,0x12,0x01,0x40
	.byte 0x0a,0x27,0x0c,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x1d,0x05,0x00,0x49,0x13,0x03
	.byte 0x08,0x3a,0x0b,0x3b,0x05,0x02,0x0a,0x00
	.byte 0x00,0x1e,0x2e,0x01,0x03,0x08,0x3f,0x0c
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x11,0x01
	.byte 0x12,0x01,0x40,0x0a,0x27,0x0c,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x1f,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x20
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c
	.byte 0x27,0x0c,0x88,0x44,0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x4c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xec,0x14,0x00,0x00,0x01,0x01
	.byte 0x67,0x6c,0x5f,0x4c,0x69,0x6e,0x65,0x57
	.byte 0x69,0x64,0x74,0x68,0x00,0x00,0x00,0x9a
	.byte 0x44,0x67,0x6c,0x5f,0x4c,0x69,0x6e,0x65
	.byte 0x53,0x74,0x69,0x70,0x70,0x6c,0x65,0x00
	.byte 0x00,0x00,0xeb,0x00,0x67,0x6c,0x5f,0x73
	.byte 0x65,0x74,0x5f,0x6c,0x69,0x6e,0x65,0x5f
	.byte 0x66,0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x01,0x7c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xec,0x14,0x00,0x00,0x9a,0x9d
	.byte 0x66,0x65,0x65,0x64,0x62,0x61,0x63,0x6b
	.byte 0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00,0x00
	.byte 0x9c,0x5d,0x73,0x65,0x6c,0x65,0x63,0x74
	.byte 0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00,0x00
	.byte 0x9c,0xb7,0x66,0x6c,0x61,0x74,0x5f,0x63
	.byte 0x69,0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00
	.byte 0x00,0x9e,0x9f,0x66,0x6c,0x61,0x74,0x5f
	.byte 0x63,0x69,0x5f,0x7a,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xa1,0x5c,0x66,0x6c
	.byte 0x61,0x74,0x5f,0x72,0x67,0x62,0x61,0x5f
	.byte 0x6c,0x69,0x6e,0x65,0x00,0x00,0x00,0xa3
	.byte 0x5d,0x66,0x6c,0x61,0x74,0x5f,0x72,0x67
	.byte 0x62,0x61,0x5f,0x7a,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xa6,0x38,0x73,0x6d
	.byte 0x6f,0x6f,0x74,0x68,0x5f,0x63,0x69,0x5f
	.byte 0x6c,0x69,0x6e,0x65,0x00,0x00,0x00,0xa8
	.byte 0xb1,0x73,0x6d,0x6f,0x6f,0x74,0x68,0x5f
	.byte 0x63,0x69,0x5f,0x7a,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xab,0xc6,0x73,0x6d
	.byte 0x6f,0x6f,0x74,0x68,0x5f,0x72,0x67,0x62
	.byte 0x61,0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00
	.byte 0x00,0xae,0x83,0x73,0x6d,0x6f,0x6f,0x74
	.byte 0x68,0x5f,0x72,0x67,0x62,0x61,0x5f,0x7a
	.byte 0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00,0x00
	.byte 0xb2,0x09,0x67,0x65,0x6e,0x65,0x72,0x61
	.byte 0x6c,0x5f,0x73,0x6d,0x6f,0x6f,0x74,0x68
	.byte 0x5f,0x63,0x69,0x5f,0x6c,0x69,0x6e,0x65
	.byte 0x00,0x00,0x00,0xbb,0xc2,0x67,0x65,0x6e
	.byte 0x65,0x72,0x61,0x6c,0x5f,0x66,0x6c,0x61
	.byte 0x74,0x5f,0x63,0x69,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xc4,0xb2,0x67,0x65
	.byte 0x6e,0x65,0x72,0x61,0x6c,0x5f,0x73,0x6d
	.byte 0x6f,0x6f,0x74,0x68,0x5f,0x72,0x67,0x62
	.byte 0x61,0x5f,0x6c,0x69,0x6e,0x65,0x00,0x00
	.byte 0x00,0xcf,0x5a,0x67,0x65,0x6e,0x65,0x72
	.byte 0x61,0x6c,0x5f,0x66,0x6c,0x61,0x74,0x5f
	.byte 0x72,0x67,0x62,0x61,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xd8,0x61,0x66,0x6c
	.byte 0x61,0x74,0x5f,0x74,0x65,0x78,0x74,0x75
	.byte 0x72,0x65,0x64,0x5f,0x6c,0x69,0x6e,0x65
	.byte 0x00,0x00,0x00,0xe0,0xef,0x73,0x6d,0x6f
	.byte 0x6f,0x74,0x68,0x5f,0x74,0x65,0x78,0x74
	.byte 0x75,0x72,0x65,0x64,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x00,0x00,0x00,0xea,0xa3,0x6e,0x75
	.byte 0x6c,0x6c,0x5f,0x6c,0x69,0x6e,0x65,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x54,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xec,0x14,0x00,0x00,0x01,0x4b
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x01,0x74,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x01,0x8a,0x47,0x4c,0x66
	.byte 0x6c,0x6f,0x61,0x74,0x00,0x00,0x00,0x01
	.byte 0xb1,0x00,0x00,0x00,0x31,0x4d,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x31
	.byte 0x6b,0x47,0x4c,0x75,0x62,0x79,0x74,0x65
	.byte 0x00,0x00,0x00,0x31,0x8b,0x67,0x6c,0x5f
	.byte 0x74,0x65,0x78,0x74,0x75,0x72,0x65,0x5f
	.byte 0x69,0x6d,0x61,0x67,0x65,0x00,0x00,0x00
	.byte 0x32,0xbd,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x34,0xd2
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x32,0xcd,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x34,0xef,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x3d,0x13
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x3d,0x25,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x55,0x48
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x63
	.byte 0xec,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x65,0x94,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x65,0xa8,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x65,0xbb
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x65,0xd9,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x65,0xec,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x66,0xc3,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x6d,0x21
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0x54
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0x8a,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0xc9
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0xff,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x6f,0xe6,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x75,0x1e,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x75
	.byte 0x34,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x75,0x94,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x75,0xe1
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x77,0xf6,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x78,0xe0
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x79,0x33,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7b,0xa9,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x7c,0x22,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7c,0xf5,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x7f,0x9c,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x80
	.byte 0x3d,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x81
	.byte 0x2d,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0x4e,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x82,0x5d,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0xd6,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x83,0xbc
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x86,0x8c,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x87,0x05
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x88,0x49,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x88,0x57,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x88,0xb2
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8a,0x0c,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0x6e,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0xe8,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x8d,0xa5,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x90,0x50,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x91,0x04
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x91,0x58,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x91,0xd2,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x93,0x5c,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x93,0xd1,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x96,0x42,0x76
	.byte 0x65,0x72,0x74,0x65,0x78,0x5f,0x62,0x75
	.byte 0x66,0x66,0x65,0x72,0x00,0x00,0x00,0x99
	.byte 0x2c,0x70,0x69,0x78,0x65,0x6c,0x5f,0x62
	.byte 0x75,0x66,0x66,0x65,0x72,0x00,0x00,0x00
	.byte 0x35,0x90,0x67,0x6c,0x5f,0x63,0x6f,0x6e
	.byte 0x74,0x65,0x78,0x74,0x00,0x00,0x00,0x9a
	.byte 0x2f,0x47,0x4c,0x63,0x6f,0x6e,0x74,0x65
	.byte 0x78,0x74,0x00,0x00,0x00,0xae,0x75,0x47
	.byte 0x4c,0x66,0x69,0x78,0x65,0x64,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
