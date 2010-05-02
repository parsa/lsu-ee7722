
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	gl_GetBooleanv
	.type	gl_GetBooleanv,#function
gl_GetBooleanv:
	save	%sp,-944,%sp

	! block 1
.L13:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L14:
.L16:
.L18:

! File get.c:
!    1	/* $Id: get.c,v 1.16 1997/10/29 01:29:09 brianp Exp $ */
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
!   25	 * $Log: get.c,v $
!   26	 * Revision 1.16  1997/10/29 01:29:09  brianp
!   27	 * added GL_EXT_point_parameters extension from Daniel Barrero
!   28	 *
!   29	 * Revision 1.15  1997/10/16 01:59:08  brianp
!   30	 * added GL_EXT_shared_texture_palette extension
!   31	 *
!   32	 * Revision 1.14  1997/07/24 01:25:18  brianp
!   33	 * changed precompiled header symbol from PCH to PC_HEADER
!   34	 *
!   35	 * Revision 1.13  1997/06/20 02:00:27  brianp
!   36	 * replaced Current.IntColor with Current.ByteColor
!   37	 *
!   38	 * Revision 1.12  1997/05/28 03:24:54  brianp
!   39	 * added precompiled header (PCH) support
!   40	 *
!   41	 * Revision 1.11  1997/05/26 21:13:42  brianp
!   42	 * rewrite code for GL_RED/GREEN/BLUE/ALPHA_BITS
!   43	 *
!   44	 * Revision 1.10  1997/04/26 04:33:11  brianp
!   45	 * glGet(accum, stencil, depth bits) always returned non-zero values- wrong
!   46	 *
!   47	 * Revision 1.9  1997/03/11 00:57:38  brianp
!   48	 * removed redundant GL_POLYGON_OFFSET_FACTOR_EXT cases
!   49	 *
!   50	 * Revision 1.8  1997/02/10 21:15:59  brianp
!   51	 * renamed GL_TEXTURE_BINDING_3D_EXT to GL_TEXTURE_3D_BINDING_EXT
!   52	 *
!   53	 * Revision 1.7  1997/02/09 19:53:43  brianp
!   54	 * now use TEXTURE_xD enable constants
!   55	 *
!   56	 * Revision 1.6  1997/02/09 18:49:23  brianp
!   57	 * added GL_EXT_texture3D support
!   58	 *
!   59	 * Revision 1.5  1997/01/30 21:05:20  brianp
!   60	 * moved in gl_GetPointerv() from varray.c
!   61	 * added some missing GLenums to the glGet*() functions
!   62	 *
!   63	 * Revision 1.4  1997/01/28 22:13:42  brianp
!   64	 * now there's separate state for CI and RGBA logic op enabled
!   65	 *
!   66	 * Revision 1.3  1996/10/11 03:43:34  brianp
!   67	 * replaced old texture _EXT symbols
!   68	 * added GL_EXT_polygon_offset stuff
!   69	 *
!   70	 * Revision 1.2  1996/09/15 14:17:30  brianp
!   71	 * now use GLframebuffer and GLvisual
!   72	 *
!   73	 * Revision 1.1  1996/09/13 01:38:16  brianp
!   74	 * Initial revision
!   75	 *
!   76	 */
!   77	
!   79	#ifdef PC_HEADER
!   80	#include "all.h"
!   81	#else
!   82	#include <string.h>
!   83	#include "context.h"
!   84	#include "get.h"
!   85	#include "dlist.h"
!   86	#include "macros.h"
!   87	#include "types.h"
!   88	#endif
!   89	
!   92	#define FLOAT_TO_BOOL(X)	( (X)==0.0F ? GL_FALSE : GL_TRUE )
!   93	#define INT_TO_BOOL(I)		( (I)==0 ? GL_FALSE : GL_TRUE )
!   94	#define ENUM_TO_BOOL(E)		( (E)==0 ? GL_FALSE : GL_TRUE )
!   95	/*#define FLOAT_TO_INT(I)		((GLint) (I * 2147483647.0))*/
!   96	
!   99	void gl_GetBooleanv( GLcontext *ctx, GLenum pname, GLboolean *params )
!  100	{
!  101	   GLuint i;
!  102	
!  103	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L17
	nop

	! block 3
.L19:
.L20:
.L21:
.L22:

!  104	      gl_error( ctx, GL_INVALID_OPERATION, "glGetBooleanv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L23),%l1
	or	%l1,%lo(.L23),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L24:

!  105	      return;

	ba	.L12
	nop

	! block 5
.L25:
.L26:
.L17:
.L27:
.L28:
.L31:

!  106	   }
!  107	
!  108	   switch (pname) {

	ba	.L30
	nop

	! block 6
.L32:
.L33:
.L34:
.L35:
.L36:
.L37:
.L38:

!  109	      case GL_ACCUM_RED_BITS:
!  110	      case GL_ACCUM_GREEN_BITS:
!  111	      case GL_ACCUM_BLUE_BITS:
!  112	      case GL_ACCUM_ALPHA_BITS:
!  113	         *params = INT_TO_BOOL(ctx->Visual->AccumBits);

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+60],%l0
	cmp	%g0,%l0

	! block 7
.L40:

	! block 8
.L39:

	! block 9
.L41:
	addx	%g0,0,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 10
.L42:

!  114	         break;

	ba	.L29
	nop

	! block 11
.L43:
.L44:

!  115	      case GL_ACCUM_CLEAR_VALUE:
!  116	         params[0] = FLOAT_TO_BOOL(ctx->Accum.ClearColor[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L45
	nop

	! block 12
.L46:
	ba	.L47
	st	%g0,[%fp-12]

	! block 13
.L45:
	mov	1,%l0
	st	%l0,[%fp-12]

	! block 14
.L47:
	ld	[%fp-12],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 15
.L48:

!  117	         params[1] = FLOAT_TO_BOOL(ctx->Accum.ClearColor[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L49
	nop

	! block 16
.L50:
	ba	.L51
	st	%g0,[%fp-16]

	! block 17
.L49:
	mov	1,%l0
	st	%l0,[%fp-16]

	! block 18
.L51:
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 19
.L52:

!  118	         params[2] = FLOAT_TO_BOOL(ctx->Accum.ClearColor[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L53
	nop

	! block 20
.L54:
	ba	.L55
	st	%g0,[%fp-20]

	! block 21
.L53:
	mov	1,%l0
	st	%l0,[%fp-20]

	! block 22
.L55:
	ld	[%fp-20],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 23
.L56:

!  119	         params[3] = FLOAT_TO_BOOL(ctx->Accum.ClearColor[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L57
	nop

	! block 24
.L58:
	ba	.L59
	st	%g0,[%fp-24]

	! block 25
.L57:
	mov	1,%l0
	st	%l0,[%fp-24]

	! block 26
.L59:
	ld	[%fp-24],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 27
.L60:

!  120	         break;

	ba	.L29
	nop

	! block 28
.L61:
.L62:

!  121	      case GL_ALPHA_BIAS:
!  122	         *params = FLOAT_TO_BOOL(ctx->Pixel.AlphaBias);

	ld	[%fp+68],%l0
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L63
	nop

	! block 29
.L64:
	ba	.L65
	st	%g0,[%fp-28]

	! block 30
.L63:
	mov	1,%l0
	st	%l0,[%fp-28]

	! block 31
.L65:
	ld	[%fp-28],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 32
.L66:

!  123	         break;

	ba	.L29
	nop

	! block 33
.L67:
.L68:

!  124	      case GL_ALPHA_BITS:
!  125	         *params = INT_TO_BOOL(ctx->Visual->AlphaBits);

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+52],%l0
	cmp	%g0,%l0

	! block 34
.L70:

	! block 35
.L69:

	! block 36
.L71:
	addx	%g0,0,%l0
	st	%l0,[%fp-32]
	ld	[%fp-32],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 37
.L72:

!  126	         break;

	ba	.L29
	nop

	! block 38
.L73:
.L74:

!  127	      case GL_ALPHA_SCALE:
!  128	         *params = FLOAT_TO_BOOL(ctx->Pixel.AlphaScale);

	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L75
	nop

	! block 39
.L76:
	ba	.L77
	st	%g0,[%fp-36]

	! block 40
.L75:
	mov	1,%l0
	st	%l0,[%fp-36]

	! block 41
.L77:
	ld	[%fp-36],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 42
.L78:

!  129	         break;

	ba	.L29
	nop

	! block 43
.L79:
.L80:

!  130	      case GL_ALPHA_TEST:
!  131	         *params = ctx->Color.AlphaEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea0),%l1
	or	%l1,%lo(0x1ea0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 44
.L81:

!  132	         break;

	ba	.L29
	nop

	! block 45
.L82:
.L83:

!  133	      case GL_ALPHA_TEST_FUNC:
!  134	         *params = ENUM_TO_BOOL(ctx->Color.AlphaFunc);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea4),%l1
	or	%l1,%lo(0x1ea4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 46
.L85:

	! block 47
.L84:

	! block 48
.L86:
	addx	%g0,0,%l0
	st	%l0,[%fp-40]
	ld	[%fp-40],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 49
.L87:

!  135	         break;

	ba	.L29
	nop

	! block 50
.L88:
.L89:

!  136	      case GL_ALPHA_TEST_REF:
!  137	         *params = FLOAT_TO_BOOL(ctx->Color.AlphaRef);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea8),%l1
	or	%l1,%lo(0x1ea8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L90
	nop

	! block 51
.L91:
	ba	.L92
	st	%g0,[%fp-44]

	! block 52
.L90:
	mov	1,%l0
	st	%l0,[%fp-44]

	! block 53
.L92:
	ld	[%fp-44],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 54
.L93:

!  138	         break;

	ba	.L29
	nop

	! block 55
.L94:
.L95:

!  139	      case GL_ATTRIB_STACK_DEPTH:
!  140	         *params = INT_TO_BOOL(ctx->AttribStackDepth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e28),%l1
	or	%l1,%lo(0x1e28),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 56
.L97:

	! block 57
.L96:

	! block 58
.L98:
	addx	%g0,0,%l0
	st	%l0,[%fp-48]
	ld	[%fp-48],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 59
.L99:

!  141	         break;

	ba	.L29
	nop

	! block 60
.L100:
.L101:

!  142	      case GL_AUTO_NORMAL:
!  143	         *params = ctx->Eval.AutoNormal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 61
.L102:

!  144	         break;

	ba	.L29
	nop

	! block 62
.L103:
.L104:

!  145	      case GL_AUX_BUFFERS:
!  146	         *params = (NUM_AUX_BUFFERS) ? GL_TRUE : GL_FALSE;

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 63
.L105:

!  147	         break;

	ba	.L29
	nop

	! block 64
.L106:
.L107:

!  148	      case GL_BLEND:
!  149	         *params = ctx->Color.BlendEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ead),%l1
	or	%l1,%lo(0x1ead),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 65
.L108:

!  150	         break;

	ba	.L29
	nop

	! block 66
.L109:
.L110:

!  151	      case GL_BLEND_DST:
!  152	         *params = ENUM_TO_BOOL(ctx->Color.BlendDst);

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb4),%l1
	or	%l1,%lo(0x1eb4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 67
.L112:

	! block 68
.L111:

	! block 69
.L113:
	addx	%g0,0,%l0
	st	%l0,[%fp-52]
	ld	[%fp-52],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 70
.L114:

!  153	         break;

	ba	.L29
	nop

	! block 71
.L115:
.L116:

!  154	      case GL_BLEND_SRC:
!  155	         *params = ENUM_TO_BOOL(ctx->Color.BlendSrc);

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb0),%l1
	or	%l1,%lo(0x1eb0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 72
.L118:

	! block 73
.L117:

	! block 74
.L119:
	addx	%g0,0,%l0
	st	%l0,[%fp-56]
	ld	[%fp-56],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 75
.L120:

!  156	         break;

	ba	.L29
	nop

	! block 76
.L121:
.L122:

!  157	      case GL_BLEND_EQUATION_EXT:
!  158		 *params = ENUM_TO_BOOL( ctx->Color.BlendEquation );

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb8),%l1
	or	%l1,%lo(0x1eb8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 77
.L124:

	! block 78
.L123:

	! block 79
.L125:
	addx	%g0,0,%l0
	st	%l0,[%fp-60]
	ld	[%fp-60],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 80
.L126:

!  159		 break;

	ba	.L29
	nop

	! block 81
.L127:
.L128:

!  160	      case GL_BLEND_COLOR_EXT:
!  161		 params[0] = FLOAT_TO_BOOL( ctx->Color.BlendColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ebc),%l1
	or	%l1,%lo(0x1ebc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L129
	nop

	! block 82
.L130:
	ba	.L131
	st	%g0,[%fp-64]

	! block 83
.L129:
	mov	1,%l0
	st	%l0,[%fp-64]

	! block 84
.L131:
	ld	[%fp-64],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 85
.L132:

!  162		 params[1] = FLOAT_TO_BOOL( ctx->Color.BlendColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec0),%l1
	or	%l1,%lo(0x1ec0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L133
	nop

	! block 86
.L134:
	ba	.L135
	st	%g0,[%fp-68]

	! block 87
.L133:
	mov	1,%l0
	st	%l0,[%fp-68]

	! block 88
.L135:
	ld	[%fp-68],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 89
.L136:

!  163		 params[2] = FLOAT_TO_BOOL( ctx->Color.BlendColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec4),%l1
	or	%l1,%lo(0x1ec4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L137
	nop

	! block 90
.L138:
	ba	.L139
	st	%g0,[%fp-72]

	! block 91
.L137:
	mov	1,%l0
	st	%l0,[%fp-72]

	! block 92
.L139:
	ld	[%fp-72],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 93
.L140:

!  164		 params[3] = FLOAT_TO_BOOL( ctx->Color.BlendColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec8),%l1
	or	%l1,%lo(0x1ec8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L141
	nop

	! block 94
.L142:
	ba	.L143
	st	%g0,[%fp-76]

	! block 95
.L141:
	mov	1,%l0
	st	%l0,[%fp-76]

	! block 96
.L143:
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 97
.L144:

!  165		 break;

	ba	.L29
	nop

	! block 98
.L145:
.L146:

!  166	      case GL_BLUE_BIAS:
!  167	         *params = FLOAT_TO_BOOL(ctx->Pixel.BlueBias);

	ld	[%fp+68],%l0
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L147
	nop

	! block 99
.L148:
	ba	.L149
	st	%g0,[%fp-80]

	! block 100
.L147:
	mov	1,%l0
	st	%l0,[%fp-80]

	! block 101
.L149:
	ld	[%fp-80],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 102
.L150:

!  168	         break;

	ba	.L29
	nop

	! block 103
.L151:
.L152:

!  169	      case GL_BLUE_BITS:
!  170	         *params = INT_TO_BOOL( ctx->Visual->BlueBits );

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+48],%l0
	cmp	%g0,%l0

	! block 104
.L154:

	! block 105
.L153:

	! block 106
.L155:
	addx	%g0,0,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 107
.L156:

!  171	         break;

	ba	.L29
	nop

	! block 108
.L157:
.L158:

!  172	      case GL_BLUE_SCALE:
!  173	         *params = FLOAT_TO_BOOL(ctx->Pixel.BlueScale);

	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L159
	nop

	! block 109
.L160:
	ba	.L161
	st	%g0,[%fp-88]

	! block 110
.L159:
	mov	1,%l0
	st	%l0,[%fp-88]

	! block 111
.L161:
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 112
.L162:

!  174	         break;

	ba	.L29
	nop

	! block 113
.L163:
.L164:

!  175	      case GL_CLIENT_ATTRIB_STACK_DEPTH:
!  176	         *params = INT_TO_BOOL(ctx->ClientAttribStackDepth);

	ld	[%fp+68],%l0
	sethi	%hi(0xdce8),%l1
	or	%l1,%lo(0xdce8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 114
.L166:

	! block 115
.L165:

	! block 116
.L167:
	addx	%g0,0,%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 117
.L168:

!  177	         break;

	ba	.L29
	nop

	! block 118
.L169:
.L170:
.L171:
.L172:
.L173:
.L174:
.L175:

!  178	      case GL_CLIP_PLANE0:
!  179	      case GL_CLIP_PLANE1:
!  180	      case GL_CLIP_PLANE2:
!  181	      case GL_CLIP_PLANE3:
!  182	      case GL_CLIP_PLANE4:
!  183	      case GL_CLIP_PLANE5:
!  184	         *params = ctx->Transform.ClipEnabled[pname-GL_CLIP_PLANE0];

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb0),%l1
	or	%l1,%lo(0xdcb0),%l1
	add	%l0,%l1,%l0
	ld	[%fp+72],%l1
	add	%l0,%l1,%l0
	sethi	%hi(0x3000),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 119
.L176:

!  185	         break;

	ba	.L29
	nop

	! block 120
.L177:
.L178:

!  186	      case GL_COLOR_CLEAR_VALUE:
!  187	         params[0] = FLOAT_TO_BOOL(ctx->Color.ClearColor[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e80),%l1
	or	%l1,%lo(0x1e80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L179
	nop

	! block 121
.L180:
	ba	.L181
	st	%g0,[%fp-96]

	! block 122
.L179:
	mov	1,%l0
	st	%l0,[%fp-96]

	! block 123
.L181:
	ld	[%fp-96],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 124
.L182:

!  188	         params[1] = FLOAT_TO_BOOL(ctx->Color.ClearColor[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e84),%l1
	or	%l1,%lo(0x1e84),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L183
	nop

	! block 125
.L184:
	ba	.L185
	st	%g0,[%fp-100]

	! block 126
.L183:
	mov	1,%l0
	st	%l0,[%fp-100]

	! block 127
.L185:
	ld	[%fp-100],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 128
.L186:

!  189	         params[2] = FLOAT_TO_BOOL(ctx->Color.ClearColor[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e88),%l1
	or	%l1,%lo(0x1e88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L187
	nop

	! block 129
.L188:
	ba	.L189
	st	%g0,[%fp-104]

	! block 130
.L187:
	mov	1,%l0
	st	%l0,[%fp-104]

	! block 131
.L189:
	ld	[%fp-104],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 132
.L190:

!  190	         params[3] = FLOAT_TO_BOOL(ctx->Color.ClearColor[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e8c),%l1
	or	%l1,%lo(0x1e8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L191
	nop

	! block 133
.L192:
	ba	.L193
	st	%g0,[%fp-108]

	! block 134
.L191:
	mov	1,%l0
	st	%l0,[%fp-108]

	! block 135
.L193:
	ld	[%fp-108],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 136
.L194:

!  191	         break;

	ba	.L29
	nop

	! block 137
.L195:
.L196:

!  192	      case GL_COLOR_MATERIAL:
!  193	         *params = ctx->Light.ColorMaterialEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xaddc),%l1
	or	%l1,%lo(0xaddc),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 138
.L197:

!  194	         break;

	ba	.L29
	nop

	! block 139
.L198:
.L199:

!  195	      case GL_COLOR_MATERIAL_FACE:
!  196	         *params = ENUM_TO_BOOL(ctx->Light.ColorMaterialFace);

	ld	[%fp+68],%l0
	sethi	%hi(0xadd0),%l1
	or	%l1,%lo(0xadd0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 140
.L201:

	! block 141
.L200:

	! block 142
.L202:
	addx	%g0,0,%l0
	st	%l0,[%fp-112]
	ld	[%fp-112],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 143
.L203:

!  197	         break;

	ba	.L29
	nop

	! block 144
.L204:
.L205:

!  198	      case GL_COLOR_MATERIAL_PARAMETER:
!  199	         *params = ENUM_TO_BOOL(ctx->Light.ColorMaterialMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xadd4),%l1
	or	%l1,%lo(0xadd4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 145
.L207:

	! block 146
.L206:

	! block 147
.L208:
	addx	%g0,0,%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 148
.L209:

!  200	         break;

	ba	.L29
	nop

	! block 149
.L210:
.L211:

!  201	      case GL_COLOR_WRITEMASK:
!  202	         params[0] = (ctx->Color.ColorMask & 8) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,8,%l0
	cmp	%g0,%l0

	! block 150
.L213:

	! block 151
.L212:

	! block 152
.L214:
	addx	%g0,0,%l0
	st	%l0,[%fp-120]
	ld	[%fp-120],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 153
.L215:

!  203	         params[1] = (ctx->Color.ColorMask & 4) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,4,%l0
	cmp	%g0,%l0

	! block 154
.L217:

	! block 155
.L216:

	! block 156
.L218:
	addx	%g0,0,%l0
	st	%l0,[%fp-124]
	ld	[%fp-124],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 157
.L219:

!  204	         params[2] = (ctx->Color.ColorMask & 2) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,2,%l0
	cmp	%g0,%l0

	! block 158
.L221:

	! block 159
.L220:

	! block 160
.L222:
	addx	%g0,0,%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 161
.L223:

!  205	         params[3] = (ctx->Color.ColorMask & 1) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,1,%l0
	cmp	%g0,%l0

	! block 162
.L225:

	! block 163
.L224:

	! block 164
.L226:
	addx	%g0,0,%l0
	st	%l0,[%fp-132]
	ld	[%fp-132],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 165
.L227:

!  206	         break;

	ba	.L29
	nop

	! block 166
.L228:
.L229:

!  207	      case GL_CULL_FACE:
!  208	         *params = ctx->Polygon.CullFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6ad),%l1
	or	%l1,%lo(0xd6ad),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 167
.L230:

!  209	         break;

	ba	.L29
	nop

	! block 168
.L231:
.L232:

!  210	      case GL_CULL_FACE_MODE:
!  211	         *params = ENUM_TO_BOOL(ctx->Polygon.CullFaceMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b0),%l1
	or	%l1,%lo(0xd6b0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 169
.L234:

	! block 170
.L233:

	! block 171
.L235:
	addx	%g0,0,%l0
	st	%l0,[%fp-136]
	ld	[%fp-136],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 172
.L236:

!  212	         break;

	ba	.L29
	nop

	! block 173
.L237:
.L238:

!  213	      case GL_CURRENT_COLOR:
!  214	         params[0] = INT_TO_BOOL(ctx->Current.ByteColor[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 174
.L240:

	! block 175
.L239:

	! block 176
.L241:
	addx	%g0,0,%l0
	st	%l0,[%fp-140]
	ld	[%fp-140],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 177
.L242:

!  215	         params[1] = INT_TO_BOOL(ctx->Current.ByteColor[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+1],%l0
	cmp	%g0,%l0

	! block 178
.L244:

	! block 179
.L243:

	! block 180
.L245:
	addx	%g0,0,%l0
	st	%l0,[%fp-144]
	ld	[%fp-144],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 181
.L246:

!  216	         params[2] = INT_TO_BOOL(ctx->Current.ByteColor[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+2],%l0
	cmp	%g0,%l0

	! block 182
.L248:

	! block 183
.L247:

	! block 184
.L249:
	addx	%g0,0,%l0
	st	%l0,[%fp-148]
	ld	[%fp-148],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 185
.L250:

!  217	         params[3] = INT_TO_BOOL(ctx->Current.ByteColor[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+3],%l0
	cmp	%g0,%l0

	! block 186
.L252:

	! block 187
.L251:

	! block 188
.L253:
	addx	%g0,0,%l0
	st	%l0,[%fp-152]
	ld	[%fp-152],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 189
.L254:

!  218	         break;

	ba	.L29
	nop

	! block 190
.L255:
.L256:

!  219	      case GL_CURRENT_INDEX:
!  220	         *params = INT_TO_BOOL(ctx->Current.Index);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 191
.L258:

	! block 192
.L257:

	! block 193
.L259:
	addx	%g0,0,%l0
	st	%l0,[%fp-156]
	ld	[%fp-156],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 194
.L260:

!  221	         break;

	ba	.L29
	nop

	! block 195
.L261:
.L262:

!  222	      case GL_CURRENT_NORMAL:
!  223	         params[0] = FLOAT_TO_BOOL(ctx->Current.Normal[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L263
	nop

	! block 196
.L264:
	ba	.L265
	st	%g0,[%fp-160]

	! block 197
.L263:
	mov	1,%l0
	st	%l0,[%fp-160]

	! block 198
.L265:
	ld	[%fp-160],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 199
.L266:

!  224	         params[1] = FLOAT_TO_BOOL(ctx->Current.Normal[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L267
	nop

	! block 200
.L268:
	ba	.L269
	st	%g0,[%fp-164]

	! block 201
.L267:
	mov	1,%l0
	st	%l0,[%fp-164]

	! block 202
.L269:
	ld	[%fp-164],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 203
.L270:

!  225	         params[2] = FLOAT_TO_BOOL(ctx->Current.Normal[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L271
	nop

	! block 204
.L272:
	ba	.L273
	st	%g0,[%fp-168]

	! block 205
.L271:
	mov	1,%l0
	st	%l0,[%fp-168]

	! block 206
.L273:
	ld	[%fp-168],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 207
.L274:

!  226	         break;

	ba	.L29
	nop

	! block 208
.L275:
.L276:

!  227	      case GL_CURRENT_RASTER_COLOR:
!  228		 params[0] = FLOAT_TO_BOOL(ctx->Current.RasterColor[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f0c),%l1
	or	%l1,%lo(0x1f0c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L277
	nop

	! block 209
.L278:
	ba	.L279
	st	%g0,[%fp-172]

	! block 210
.L277:
	mov	1,%l0
	st	%l0,[%fp-172]

	! block 211
.L279:
	ld	[%fp-172],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 212
.L280:

!  229		 params[1] = FLOAT_TO_BOOL(ctx->Current.RasterColor[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f10),%l1
	or	%l1,%lo(0x1f10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L281
	nop

	! block 213
.L282:
	ba	.L283
	st	%g0,[%fp-176]

	! block 214
.L281:
	mov	1,%l0
	st	%l0,[%fp-176]

	! block 215
.L283:
	ld	[%fp-176],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 216
.L284:

!  230		 params[2] = FLOAT_TO_BOOL(ctx->Current.RasterColor[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f14),%l1
	or	%l1,%lo(0x1f14),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L285
	nop

	! block 217
.L286:
	ba	.L287
	st	%g0,[%fp-180]

	! block 218
.L285:
	mov	1,%l0
	st	%l0,[%fp-180]

	! block 219
.L287:
	ld	[%fp-180],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 220
.L288:

!  231		 params[3] = FLOAT_TO_BOOL(ctx->Current.RasterColor[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f18),%l1
	or	%l1,%lo(0x1f18),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L289
	nop

	! block 221
.L290:
	ba	.L291
	st	%g0,[%fp-184]

	! block 222
.L289:
	mov	1,%l0
	st	%l0,[%fp-184]

	! block 223
.L291:
	ld	[%fp-184],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 224
.L292:

!  232		 break;

	ba	.L29
	nop

	! block 225
.L293:
.L294:

!  233	      case GL_CURRENT_RASTER_DISTANCE:
!  234		 *params = FLOAT_TO_BOOL(ctx->Current.RasterDistance);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f08),%l1
	or	%l1,%lo(0x1f08),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L295
	nop

	! block 226
.L296:
	ba	.L297
	st	%g0,[%fp-188]

	! block 227
.L295:
	mov	1,%l0
	st	%l0,[%fp-188]

	! block 228
.L297:
	ld	[%fp-188],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 229
.L298:

!  235		 break;

	ba	.L29
	nop

	! block 230
.L299:
.L300:

!  236	      case GL_CURRENT_RASTER_INDEX:
!  237		 *params = FLOAT_TO_BOOL(ctx->Current.RasterIndex);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f1c),%l1
	or	%l1,%lo(0x1f1c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-848]
	st	%l1,[%fp-844]
	ldd	[%fp-848],%f6
	mov	0,%l0
	st	%l0,[%fp-844]
	ldd	[%fp-848],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L301
	nop

	! block 231
.L302:
	ba	.L303
	st	%g0,[%fp-192]

	! block 232
.L301:
	mov	1,%l0
	st	%l0,[%fp-192]

	! block 233
.L303:
	ld	[%fp-192],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 234
.L304:

!  238		 break;

	ba	.L29
	nop

	! block 235
.L305:
.L306:

!  239	      case GL_CURRENT_RASTER_POSITION:
!  240		 params[0] = FLOAT_TO_BOOL(ctx->Current.RasterPos[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef8),%l1
	or	%l1,%lo(0x1ef8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L307
	nop

	! block 236
.L308:
	ba	.L309
	st	%g0,[%fp-196]

	! block 237
.L307:
	mov	1,%l0
	st	%l0,[%fp-196]

	! block 238
.L309:
	ld	[%fp-196],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 239
.L310:

!  241		 params[1] = FLOAT_TO_BOOL(ctx->Current.RasterPos[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1efc),%l1
	or	%l1,%lo(0x1efc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L311
	nop

	! block 240
.L312:
	ba	.L313
	st	%g0,[%fp-200]

	! block 241
.L311:
	mov	1,%l0
	st	%l0,[%fp-200]

	! block 242
.L313:
	ld	[%fp-200],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 243
.L314:

!  242		 params[2] = FLOAT_TO_BOOL(ctx->Current.RasterPos[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f00),%l1
	or	%l1,%lo(0x1f00),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L315
	nop

	! block 244
.L316:
	ba	.L317
	st	%g0,[%fp-204]

	! block 245
.L315:
	mov	1,%l0
	st	%l0,[%fp-204]

	! block 246
.L317:
	ld	[%fp-204],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 247
.L318:

!  243		 params[3] = FLOAT_TO_BOOL(ctx->Current.RasterPos[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f04),%l1
	or	%l1,%lo(0x1f04),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L319
	nop

	! block 248
.L320:
	ba	.L321
	st	%g0,[%fp-208]

	! block 249
.L319:
	mov	1,%l0
	st	%l0,[%fp-208]

	! block 250
.L321:
	ld	[%fp-208],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 251
.L322:

!  244		 break;

	ba	.L29
	nop

	! block 252
.L323:
.L324:

!  245	      case GL_CURRENT_RASTER_TEXTURE_COORDS:
!  246	         params[0] = FLOAT_TO_BOOL(ctx->Current.RasterTexCoord[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f20),%l1
	or	%l1,%lo(0x1f20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L325
	nop

	! block 253
.L326:
	ba	.L327
	st	%g0,[%fp-212]

	! block 254
.L325:
	mov	1,%l0
	st	%l0,[%fp-212]

	! block 255
.L327:
	ld	[%fp-212],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 256
.L328:

!  247	         params[1] = FLOAT_TO_BOOL(ctx->Current.RasterTexCoord[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f24),%l1
	or	%l1,%lo(0x1f24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L329
	nop

	! block 257
.L330:
	ba	.L331
	st	%g0,[%fp-216]

	! block 258
.L329:
	mov	1,%l0
	st	%l0,[%fp-216]

	! block 259
.L331:
	ld	[%fp-216],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 260
.L332:

!  248	         params[2] = FLOAT_TO_BOOL(ctx->Current.RasterTexCoord[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f28),%l1
	or	%l1,%lo(0x1f28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L333
	nop

	! block 261
.L334:
	ba	.L335
	st	%g0,[%fp-220]

	! block 262
.L333:
	mov	1,%l0
	st	%l0,[%fp-220]

	! block 263
.L335:
	ld	[%fp-220],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 264
.L336:

!  249	         params[3] = FLOAT_TO_BOOL(ctx->Current.RasterTexCoord[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f2c),%l1
	or	%l1,%lo(0x1f2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L337
	nop

	! block 265
.L338:
	ba	.L339
	st	%g0,[%fp-224]

	! block 266
.L337:
	mov	1,%l0
	st	%l0,[%fp-224]

	! block 267
.L339:
	ld	[%fp-224],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 268
.L340:

!  250		 break;

	ba	.L29
	nop

	! block 269
.L341:
.L342:

!  251	      case GL_CURRENT_RASTER_POSITION_VALID:
!  252	         *params = ctx->Current.RasterPosValid;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f30),%l1
	or	%l1,%lo(0x1f30),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 270
.L343:

!  253		 break;

	ba	.L29
	nop

	! block 271
.L344:
.L345:

!  254	      case GL_CURRENT_TEXTURE_COORDS:
!  255	         params[0] = FLOAT_TO_BOOL(ctx->Current.TexCoord[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L346
	nop

	! block 272
.L347:
	ba	.L348
	st	%g0,[%fp-228]

	! block 273
.L346:
	mov	1,%l0
	st	%l0,[%fp-228]

	! block 274
.L348:
	ld	[%fp-228],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 275
.L349:

!  256	         params[1] = FLOAT_TO_BOOL(ctx->Current.TexCoord[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L350
	nop

	! block 276
.L351:
	ba	.L352
	st	%g0,[%fp-232]

	! block 277
.L350:
	mov	1,%l0
	st	%l0,[%fp-232]

	! block 278
.L352:
	ld	[%fp-232],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 279
.L353:

!  257	         params[2] = FLOAT_TO_BOOL(ctx->Current.TexCoord[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 280
.L355:
	ba	.L356
	st	%g0,[%fp-236]

	! block 281
.L354:
	mov	1,%l0
	st	%l0,[%fp-236]

	! block 282
.L356:
	ld	[%fp-236],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 283
.L357:

!  258	         params[3] = FLOAT_TO_BOOL(ctx->Current.TexCoord[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L358
	nop

	! block 284
.L359:
	ba	.L360
	st	%g0,[%fp-240]

	! block 285
.L358:
	mov	1,%l0
	st	%l0,[%fp-240]

	! block 286
.L360:
	ld	[%fp-240],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 287
.L361:

!  259		 break;

	ba	.L29
	nop

	! block 288
.L362:
.L363:

!  260	      case GL_DEPTH_BIAS:
!  261	         *params = FLOAT_TO_BOOL(ctx->Pixel.DepthBias);

	ld	[%fp+68],%l0
	sethi	%hi(0xae3c),%l1
	or	%l1,%lo(0xae3c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L364
	nop

	! block 289
.L365:
	ba	.L366
	st	%g0,[%fp-244]

	! block 290
.L364:
	mov	1,%l0
	st	%l0,[%fp-244]

	! block 291
.L366:
	ld	[%fp-244],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 292
.L367:

!  262		 break;

	ba	.L29
	nop

	! block 293
.L368:
.L369:

!  263	      case GL_DEPTH_BITS:
!  264		 *params = INT_TO_BOOL(ctx->Visual->DepthBits);

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+64],%l0
	cmp	%g0,%l0

	! block 294
.L371:

	! block 295
.L370:

	! block 296
.L372:
	addx	%g0,0,%l0
	st	%l0,[%fp-248]
	ld	[%fp-248],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 297
.L373:

!  265		 break;

	ba	.L29
	nop

	! block 298
.L374:
.L375:

!  266	      case GL_DEPTH_CLEAR_VALUE:
!  267	         *params = FLOAT_TO_BOOL(ctx->Depth.Clear);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f38),%l1
	or	%l1,%lo(0x1f38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L376
	nop

	! block 299
.L377:
	ba	.L378
	st	%g0,[%fp-252]

	! block 300
.L376:
	mov	1,%l0
	st	%l0,[%fp-252]

	! block 301
.L378:
	ld	[%fp-252],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 302
.L379:

!  268		 break;

	ba	.L29
	nop

	! block 303
.L380:
.L381:

!  269	      case GL_DEPTH_FUNC:
!  270	         *params = ENUM_TO_BOOL(ctx->Depth.Func);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f34),%l1
	or	%l1,%lo(0x1f34),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 304
.L383:

	! block 305
.L382:

	! block 306
.L384:
	addx	%g0,0,%l0
	st	%l0,[%fp-256]
	ld	[%fp-256],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 307
.L385:

!  271		 break;

	ba	.L29
	nop

	! block 308
.L386:
.L387:

!  272	      case GL_DEPTH_RANGE:
!  273	         params[0] = FLOAT_TO_BOOL(ctx->Viewport.Near);

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc8),%l1
	or	%l1,%lo(0xdcc8),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L388
	nop

	! block 309
.L389:
	ba	.L390
	st	%g0,[%fp-260]

	! block 310
.L388:
	mov	1,%l0
	st	%l0,[%fp-260]

	! block 311
.L390:
	ld	[%fp-260],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 312
.L391:

!  274	         params[1] = FLOAT_TO_BOOL(ctx->Viewport.Far);

	ld	[%fp+68],%l0
	sethi	%hi(0xdccc),%l1
	or	%l1,%lo(0xdccc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L392
	nop

	! block 313
.L393:
	ba	.L394
	st	%g0,[%fp-264]

	! block 314
.L392:
	mov	1,%l0
	st	%l0,[%fp-264]

	! block 315
.L394:
	ld	[%fp-264],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 316
.L395:

!  275		 break;

	ba	.L29
	nop

	! block 317
.L396:
.L397:

!  276	      case GL_DEPTH_SCALE:
!  277	         *params = FLOAT_TO_BOOL(ctx->Pixel.DepthScale);

	ld	[%fp+68],%l0
	sethi	%hi(0xae40),%l1
	or	%l1,%lo(0xae40),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L398
	nop

	! block 318
.L399:
	ba	.L400
	st	%g0,[%fp-268]

	! block 319
.L398:
	mov	1,%l0
	st	%l0,[%fp-268]

	! block 320
.L400:
	ld	[%fp-268],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 321
.L401:

!  278		 break;

	ba	.L29
	nop

	! block 322
.L402:
.L403:

!  279	      case GL_DEPTH_TEST:
!  280	         *params = ctx->Depth.Test;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 323
.L404:

!  281		 break;

	ba	.L29
	nop

	! block 324
.L405:
.L406:

!  282	      case GL_DEPTH_WRITEMASK:
!  283		 *params = ctx->Depth.Mask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3d),%l1
	or	%l1,%lo(0x1f3d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 325
.L407:

!  284		 break;

	ba	.L29
	nop

	! block 326
.L408:
.L409:

!  285	      case GL_DITHER:
!  286		 *params = ctx->Color.DitherFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed3),%l1
	or	%l1,%lo(0x1ed3),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 327
.L410:

!  287		 break;

	ba	.L29
	nop

	! block 328
.L411:
.L412:

!  288	      case GL_DOUBLEBUFFER:
!  289		 *params = ctx->Visual->DBflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 329
.L413:

!  290		 break;

	ba	.L29
	nop

	! block 330
.L414:
.L415:

!  291	      case GL_DRAW_BUFFER:
!  292		 *params = ENUM_TO_BOOL(ctx->Color.DrawBuffer);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e9c),%l1
	or	%l1,%lo(0x1e9c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 331
.L417:

	! block 332
.L416:

	! block 333
.L418:
	addx	%g0,0,%l0
	st	%l0,[%fp-272]
	ld	[%fp-272],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 334
.L419:

!  293		 break;

	ba	.L29
	nop

	! block 335
.L420:
.L421:

!  294	      case GL_EDGE_FLAG:
!  295		 *params = ctx->Current.EdgeFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f31),%l1
	or	%l1,%lo(0x1f31),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 336
.L422:

!  296		 break;

	ba	.L29
	nop

	! block 337
.L423:
.L424:

!  297	      case GL_FEEDBACK_BUFFER_SIZE:
!  298	         /* TODO: is this right?  Or, return number of entries in buffer? */
!  299	         *params = INT_TO_BOOL(ctx->Feedback.BufferSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 338
.L426:

	! block 339
.L425:

	! block 340
.L427:
	addx	%g0,0,%l0
	st	%l0,[%fp-276]
	ld	[%fp-276],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 341
.L428:

!  300	         break;

	ba	.L29
	nop

	! block 342
.L429:
.L430:

!  301	      case GL_FEEDBACK_BUFFER_TYPE:
!  302	         *params = INT_TO_BOOL(ctx->Feedback.Type);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb8),%l1
	or	%l1,%lo(0xdfb8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 343
.L432:

	! block 344
.L431:

	! block 345
.L433:
	addx	%g0,0,%l0
	st	%l0,[%fp-280]
	ld	[%fp-280],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 346
.L434:

!  303	         break;

	ba	.L29
	nop

	! block 347
.L435:
.L436:

!  304	      case GL_FOG:
!  305		 *params = ctx->Fog.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 348
.L437:

!  306		 break;

	ba	.L29
	nop

	! block 349
.L438:
.L439:

!  307	      case GL_FOG_COLOR:
!  308	         params[0] = FLOAT_TO_BOOL(ctx->Fog.Color[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f7c),%l1
	or	%l1,%lo(0x1f7c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L440
	nop

	! block 350
.L441:
	ba	.L442
	st	%g0,[%fp-284]

	! block 351
.L440:
	mov	1,%l0
	st	%l0,[%fp-284]

	! block 352
.L442:
	ld	[%fp-284],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 353
.L443:

!  309	         params[1] = FLOAT_TO_BOOL(ctx->Fog.Color[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f80),%l1
	or	%l1,%lo(0x1f80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L444
	nop

	! block 354
.L445:
	ba	.L446
	st	%g0,[%fp-288]

	! block 355
.L444:
	mov	1,%l0
	st	%l0,[%fp-288]

	! block 356
.L446:
	ld	[%fp-288],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 357
.L447:

!  310	         params[2] = FLOAT_TO_BOOL(ctx->Fog.Color[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f84),%l1
	or	%l1,%lo(0x1f84),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L448
	nop

	! block 358
.L449:
	ba	.L450
	st	%g0,[%fp-292]

	! block 359
.L448:
	mov	1,%l0
	st	%l0,[%fp-292]

	! block 360
.L450:
	ld	[%fp-292],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 361
.L451:

!  311	         params[3] = FLOAT_TO_BOOL(ctx->Fog.Color[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f88),%l1
	or	%l1,%lo(0x1f88),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L452
	nop

	! block 362
.L453:
	ba	.L454
	st	%g0,[%fp-296]

	! block 363
.L452:
	mov	1,%l0
	st	%l0,[%fp-296]

	! block 364
.L454:
	ld	[%fp-296],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 365
.L455:

!  312		 break;

	ba	.L29
	nop

	! block 366
.L456:
.L457:

!  313	      case GL_FOG_DENSITY:
!  314	         *params = FLOAT_TO_BOOL(ctx->Fog.Density);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f8c),%l1
	or	%l1,%lo(0x1f8c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L458
	nop

	! block 367
.L459:
	ba	.L460
	st	%g0,[%fp-300]

	! block 368
.L458:
	mov	1,%l0
	st	%l0,[%fp-300]

	! block 369
.L460:
	ld	[%fp-300],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 370
.L461:

!  315		 break;

	ba	.L29
	nop

	! block 371
.L462:
.L463:

!  316	      case GL_FOG_END:
!  317	         *params = FLOAT_TO_BOOL(ctx->Fog.End);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f94),%l1
	or	%l1,%lo(0x1f94),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L464
	nop

	! block 372
.L465:
	ba	.L466
	st	%g0,[%fp-304]

	! block 373
.L464:
	mov	1,%l0
	st	%l0,[%fp-304]

	! block 374
.L466:
	ld	[%fp-304],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 375
.L467:

!  318		 break;

	ba	.L29
	nop

	! block 376
.L468:
.L469:

!  319	      case GL_FOG_HINT:
!  320		 *params = ENUM_TO_BOOL(ctx->Hint.Fog);

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 377
.L471:

	! block 378
.L470:

	! block 379
.L472:
	addx	%g0,0,%l0
	st	%l0,[%fp-308]
	ld	[%fp-308],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 380
.L473:

!  321		 break;

	ba	.L29
	nop

	! block 381
.L474:
.L475:

!  322	      case GL_FOG_INDEX:
!  323		 *params = FLOAT_TO_BOOL(ctx->Fog.Index);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f98),%l1
	or	%l1,%lo(0x1f98),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L476
	nop

	! block 382
.L477:
	ba	.L478
	st	%g0,[%fp-312]

	! block 383
.L476:
	mov	1,%l0
	st	%l0,[%fp-312]

	! block 384
.L478:
	ld	[%fp-312],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 385
.L479:

!  324		 break;

	ba	.L29
	nop

	! block 386
.L480:
.L481:

!  325	      case GL_FOG_MODE:
!  326		 *params = ENUM_TO_BOOL(ctx->Fog.Mode);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f9c),%l1
	or	%l1,%lo(0x1f9c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 387
.L483:

	! block 388
.L482:

	! block 389
.L484:
	addx	%g0,0,%l0
	st	%l0,[%fp-316]
	ld	[%fp-316],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 390
.L485:

!  327		 break;

	ba	.L29
	nop

	! block 391
.L486:
.L487:

!  328	      case GL_FOG_START:
!  329	         *params = FLOAT_TO_BOOL(ctx->Fog.End);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f94),%l1
	or	%l1,%lo(0x1f94),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L488
	nop

	! block 392
.L489:
	ba	.L490
	st	%g0,[%fp-320]

	! block 393
.L488:
	mov	1,%l0
	st	%l0,[%fp-320]

	! block 394
.L490:
	ld	[%fp-320],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 395
.L491:

!  330		 break;

	ba	.L29
	nop

	! block 396
.L492:
.L493:

!  331	      case GL_FRONT_FACE:
!  332		 *params = ENUM_TO_BOOL(ctx->Polygon.FrontFace);

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a0),%l1
	or	%l1,%lo(0xd6a0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 397
.L495:

	! block 398
.L494:

	! block 399
.L496:
	addx	%g0,0,%l0
	st	%l0,[%fp-324]
	ld	[%fp-324],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 400
.L497:

!  333		 break;

	ba	.L29
	nop

	! block 401
.L498:
.L499:

!  334	      case GL_GREEN_BIAS:
!  335	         *params = FLOAT_TO_BOOL(ctx->Pixel.GreenBias);

	ld	[%fp+68],%l0
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L500
	nop

	! block 402
.L501:
	ba	.L502
	st	%g0,[%fp-328]

	! block 403
.L500:
	mov	1,%l0
	st	%l0,[%fp-328]

	! block 404
.L502:
	ld	[%fp-328],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 405
.L503:

!  336		 break;

	ba	.L29
	nop

	! block 406
.L504:
.L505:

!  337	      case GL_GREEN_BITS:
!  338	         *params = INT_TO_BOOL( ctx->Visual->GreenBits );

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+44],%l0
	cmp	%g0,%l0

	! block 407
.L507:

	! block 408
.L506:

	! block 409
.L508:
	addx	%g0,0,%l0
	st	%l0,[%fp-332]
	ld	[%fp-332],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 410
.L509:

!  339		 break;

	ba	.L29
	nop

	! block 411
.L510:
.L511:

!  340	      case GL_GREEN_SCALE:
!  341	         *params = FLOAT_TO_BOOL(ctx->Pixel.GreenScale);

	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L512
	nop

	! block 412
.L513:
	ba	.L514
	st	%g0,[%fp-336]

	! block 413
.L512:
	mov	1,%l0
	st	%l0,[%fp-336]

	! block 414
.L514:
	ld	[%fp-336],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 415
.L515:

!  342		 break;

	ba	.L29
	nop

	! block 416
.L516:
.L517:

!  343	      case GL_INDEX_BITS:
!  344	         *params = INT_TO_BOOL( ctx->Visual->IndexBits );

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+56],%l0
	cmp	%g0,%l0

	! block 417
.L519:

	! block 418
.L518:

	! block 419
.L520:
	addx	%g0,0,%l0
	st	%l0,[%fp-340]
	ld	[%fp-340],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 420
.L521:

!  345		 break;

	ba	.L29
	nop

	! block 421
.L522:
.L523:

!  346	      case GL_INDEX_CLEAR_VALUE:
!  347		 *params = INT_TO_BOOL(ctx->Color.ClearIndex);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e7c),%l1
	or	%l1,%lo(0x1e7c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 422
.L525:

	! block 423
.L524:

	! block 424
.L526:
	addx	%g0,0,%l0
	st	%l0,[%fp-344]
	ld	[%fp-344],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 425
.L527:

!  348		 break;

	ba	.L29
	nop

	! block 426
.L528:
.L529:

!  349	      case GL_INDEX_MODE:
!  350		 *params = ctx->Visual->RGBAflag ? GL_FALSE : GL_TRUE;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l0
	cmp	%g0,%l0

	! block 427
.L531:

	! block 428
.L530:

	! block 429
.L532:
	subx	%g0,-1,%l0
	st	%l0,[%fp-348]
	ld	[%fp-348],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 430
.L533:

!  351		 break;

	ba	.L29
	nop

	! block 431
.L534:
.L535:

!  352	      case GL_INDEX_OFFSET:
!  353		 *params = INT_TO_BOOL(ctx->Pixel.IndexOffset);

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 432
.L537:

	! block 433
.L536:

	! block 434
.L538:
	addx	%g0,0,%l0
	st	%l0,[%fp-352]
	ld	[%fp-352],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 435
.L539:

!  354		 break;

	ba	.L29
	nop

	! block 436
.L540:
.L541:

!  355	      case GL_INDEX_SHIFT:
!  356		 *params = INT_TO_BOOL(ctx->Pixel.IndexShift);

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 437
.L543:

	! block 438
.L542:

	! block 439
.L544:
	addx	%g0,0,%l0
	st	%l0,[%fp-356]
	ld	[%fp-356],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 440
.L545:

!  357		 break;

	ba	.L29
	nop

	! block 441
.L546:
.L547:

!  358	      case GL_INDEX_WRITEMASK:
!  359		 *params = INT_TO_BOOL(ctx->Color.IndexMask);

	ld	[%fp+68],%l0
	sethi	%hi(0x1e90),%l1
	or	%l1,%lo(0x1e90),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 442
.L549:

	! block 443
.L548:

	! block 444
.L550:
	addx	%g0,0,%l0
	st	%l0,[%fp-360]
	ld	[%fp-360],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 445
.L551:

!  360		 break;

	ba	.L29
	nop

	! block 446
.L552:
.L553:
.L554:
.L555:
.L556:
.L557:
.L558:
.L559:
.L560:

!  361	      case GL_LIGHT0:
!  362	      case GL_LIGHT1:
!  363	      case GL_LIGHT2:
!  364	      case GL_LIGHT3:
!  365	      case GL_LIGHT4:
!  366	      case GL_LIGHT5:
!  367	      case GL_LIGHT6:
!  368	      case GL_LIGHT7:
!  369		 *params = ctx->Light.Light[pname-GL_LIGHT0].Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb4),%l1
	or	%l1,%lo(0x1fb4),%l1
	add	%l0,%l1,%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,5,%l1
	add	%l2,%l1,%l2
	sll	%l0,6,%l1
	add	%l2,%l1,%l2
	sll	%l0,7,%l1
	add	%l2,%l1,%l2
	sll	%l0,12,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x438ff98),%l1
	or	%l1,%lo(0x438ff98),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 447
.L561:

!  370		 break;

	ba	.L29
	nop

	! block 448
.L562:
.L563:

!  371	      case GL_LIGHTING:
!  372		 *params = ctx->Light.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xadc8),%l1
	or	%l1,%lo(0xadc8),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 449
.L564:

!  373		 break;

	ba	.L29
	nop

	! block 450
.L565:
.L566:

!  374	      case GL_LIGHT_MODEL_AMBIENT:
!  375		 params[0] = FLOAT_TO_BOOL(ctx->Light.Model.Ambient[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L567
	nop

	! block 451
.L568:
	ba	.L569
	st	%g0,[%fp-364]

	! block 452
.L567:
	mov	1,%l0
	st	%l0,[%fp-364]

	! block 453
.L569:
	ld	[%fp-364],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 454
.L570:

!  376		 params[1] = FLOAT_TO_BOOL(ctx->Light.Model.Ambient[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L571
	nop

	! block 455
.L572:
	ba	.L573
	st	%g0,[%fp-368]

	! block 456
.L571:
	mov	1,%l0
	st	%l0,[%fp-368]

	! block 457
.L573:
	ld	[%fp-368],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 458
.L574:

!  377		 params[2] = FLOAT_TO_BOOL(ctx->Light.Model.Ambient[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L575
	nop

	! block 459
.L576:
	ba	.L577
	st	%g0,[%fp-372]

	! block 460
.L575:
	mov	1,%l0
	st	%l0,[%fp-372]

	! block 461
.L577:
	ld	[%fp-372],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 462
.L578:

!  378		 params[3] = FLOAT_TO_BOOL(ctx->Light.Model.Ambient[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L579
	nop

	! block 463
.L580:
	ba	.L581
	st	%g0,[%fp-376]

	! block 464
.L579:
	mov	1,%l0
	st	%l0,[%fp-376]

	! block 465
.L581:
	ld	[%fp-376],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 466
.L582:

!  379		 break;

	ba	.L29
	nop

	! block 467
.L583:
.L584:

!  380	      case GL_LIGHT_MODEL_LOCAL_VIEWER:
!  381		 *params = ctx->Light.Model.LocalViewer;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e4),%l1
	or	%l1,%lo(0xa6e4),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 468
.L585:

!  382		 break;

	ba	.L29
	nop

	! block 469
.L586:
.L587:

!  383	      case GL_LIGHT_MODEL_TWO_SIDE:
!  384		 *params = ctx->Light.Model.TwoSide;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e5),%l1
	or	%l1,%lo(0xa6e5),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 470
.L588:

!  385		 break;

	ba	.L29
	nop

	! block 471
.L589:
.L590:

!  386	      case GL_LINE_SMOOTH:
!  387		 *params = ctx->Line.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae08),%l1
	or	%l1,%lo(0xae08),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 472
.L591:

!  388		 break;

	ba	.L29
	nop

	! block 473
.L592:
.L593:

!  389	      case GL_LINE_SMOOTH_HINT:
!  390		 *params = ENUM_TO_BOOL(ctx->Hint.LineSmooth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa8),%l1
	or	%l1,%lo(0x1fa8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 474
.L595:

	! block 475
.L594:

	! block 476
.L596:
	addx	%g0,0,%l0
	st	%l0,[%fp-380]
	ld	[%fp-380],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 477
.L597:

!  391		 break;

	ba	.L29
	nop

	! block 478
.L598:
.L599:

!  392	      case GL_LINE_STIPPLE:
!  393		 *params = ctx->Line.StippleFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 479
.L600:

!  394		 break;

	ba	.L29
	nop

	! block 480
.L601:
.L602:

!  395	      case GL_LINE_STIPPLE_PATTERN:
!  396		 *params = INT_TO_BOOL(ctx->Line.StipplePattern);

	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 481
.L604:

	! block 482
.L603:

	! block 483
.L605:
	addx	%g0,0,%l0
	st	%l0,[%fp-384]
	ld	[%fp-384],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 484
.L606:

!  397		 break;

	ba	.L29
	nop

	! block 485
.L607:
.L608:

!  398	      case GL_LINE_STIPPLE_REPEAT:
!  399		 *params = INT_TO_BOOL(ctx->Line.StippleFactor);

	ld	[%fp+68],%l0
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 486
.L610:

	! block 487
.L609:

	! block 488
.L611:
	addx	%g0,0,%l0
	st	%l0,[%fp-388]
	ld	[%fp-388],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 489
.L612:

!  400		 break;

	ba	.L29
	nop

	! block 490
.L613:
.L614:

!  401	      case GL_LINE_WIDTH:
!  402		 *params = FLOAT_TO_BOOL(ctx->Line.Width);

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L615
	nop

	! block 491
.L616:
	ba	.L617
	st	%g0,[%fp-392]

	! block 492
.L615:
	mov	1,%l0
	st	%l0,[%fp-392]

	! block 493
.L617:
	ld	[%fp-392],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 494
.L618:

!  403		 break;

	ba	.L29
	nop

	! block 495
.L619:
.L620:

!  404	      case GL_LINE_WIDTH_GRANULARITY:
!  405		 *params = FLOAT_TO_BOOL(LINE_WIDTH_GRANULARITY);

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L621
	nop

	! block 496
.L622:
	ba	.L623
	st	%g0,[%fp-396]

	! block 497
.L621:
	mov	1,%l0
	st	%l0,[%fp-396]

	! block 498
.L623:
	ld	[%fp-396],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 499
.L624:

!  406		 break;

	ba	.L29
	nop

	! block 500
.L625:
.L626:

!  407	      case GL_LINE_WIDTH_RANGE:
!  408		 params[0] = FLOAT_TO_BOOL(MIN_LINE_WIDTH);

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L627
	nop

	! block 501
.L628:
	ba	.L629
	st	%g0,[%fp-400]

	! block 502
.L627:
	mov	1,%l0
	st	%l0,[%fp-400]

	! block 503
.L629:
	ld	[%fp-400],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 504
.L630:

!  409		 params[1] = FLOAT_TO_BOOL(MAX_LINE_WIDTH);

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L631
	nop

	! block 505
.L632:
	ba	.L633
	st	%g0,[%fp-404]

	! block 506
.L631:
	mov	1,%l0
	st	%l0,[%fp-404]

	! block 507
.L633:
	ld	[%fp-404],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 508
.L634:

!  410		 break;

	ba	.L29
	nop

	! block 509
.L635:
.L636:

!  411	      case GL_LIST_BASE:
!  412		 *params = INT_TO_BOOL(ctx->List.ListBase);

	ld	[%fp+68],%l0
	sethi	%hi(0xae14),%l1
	or	%l1,%lo(0xae14),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 510
.L638:

	! block 511
.L637:

	! block 512
.L639:
	addx	%g0,0,%l0
	st	%l0,[%fp-408]
	ld	[%fp-408],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 513
.L640:

!  413		 break;

	ba	.L29
	nop

	! block 514
.L641:
.L642:

!  414	      case GL_LIST_INDEX:
!  415		 *params = INT_TO_BOOL( gl_list_index() );

	call	gl_list_index
	nop
	cmp	%g0,%o0

	! block 515
.L644:

	! block 516
.L643:

	! block 517
.L645:
	addx	%g0,0,%l0
	st	%l0,[%fp-412]
	ld	[%fp-412],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 518
.L646:

!  416		 break;

	ba	.L29
	nop

	! block 519
.L647:
.L648:

!  417	      case GL_LIST_MODE:
!  418		 *params = ENUM_TO_BOOL( ctx->ExecuteFlag
!  419					  ? GL_COMPILE_AND_EXECUTE : GL_COMPILE );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e24),%l1
	or	%l1,%lo(0x1e24),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 520
.L651:

	! block 521
.L650:

	! block 522
.L652:
	addx	%g0,0,%l0
	sethi	%hi(0x1300),%l1
	or	%l1,%lo(0x1300),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-416]
	ld	[%fp-416],%l0
	cmp	%g0,%l0

	! block 523
.L653:

	! block 524
.L649:

	! block 525
.L654:
	addx	%g0,0,%l0
	st	%l0,[%fp-420]
	ld	[%fp-420],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 526
.L655:

!  420		 break;

	ba	.L29
	nop

	! block 527
.L656:
.L657:

!  421	      case GL_INDEX_LOGIC_OP:
!  422		 *params = ctx->Color.IndexLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed0),%l1
	or	%l1,%lo(0x1ed0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 528
.L658:

!  423		 break;

	ba	.L29
	nop

	! block 529
.L659:
.L660:

!  424	      case GL_COLOR_LOGIC_OP:
!  425		 *params = ctx->Color.ColorLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed1),%l1
	or	%l1,%lo(0x1ed1),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 530
.L661:

!  426		 break;

	ba	.L29
	nop

	! block 531
.L662:
.L663:

!  427	      case GL_LOGIC_OP_MODE:
!  428		 *params = ENUM_TO_BOOL(ctx->Color.LogicOp);

	ld	[%fp+68],%l0
	sethi	%hi(0x1ecc),%l1
	or	%l1,%lo(0x1ecc),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 532
.L665:

	! block 533
.L664:

	! block 534
.L666:
	addx	%g0,0,%l0
	st	%l0,[%fp-424]
	ld	[%fp-424],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 535
.L667:

!  429		 break;

	ba	.L29
	nop

	! block 536
.L668:
.L669:

!  430	      case GL_MAP1_COLOR_4:
!  431		 *params = ctx->Eval.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f40),%l1
	or	%l1,%lo(0x1f40),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 537
.L670:

!  432		 break;

	ba	.L29
	nop

	! block 538
.L671:
.L672:

!  433	      case GL_MAP1_GRID_DOMAIN:
!  434		 params[0] = FLOAT_TO_BOOL(ctx->Eval.MapGrid1u1);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L673
	nop

	! block 539
.L674:
	ba	.L675
	st	%g0,[%fp-428]

	! block 540
.L673:
	mov	1,%l0
	st	%l0,[%fp-428]

	! block 541
.L675:
	ld	[%fp-428],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 542
.L676:

!  435		 params[1] = FLOAT_TO_BOOL(ctx->Eval.MapGrid1u2);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L677
	nop

	! block 543
.L678:
	ba	.L679
	st	%g0,[%fp-432]

	! block 544
.L677:
	mov	1,%l0
	st	%l0,[%fp-432]

	! block 545
.L679:
	ld	[%fp-432],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 546
.L680:

!  436		 break;

	ba	.L29
	nop

	! block 547
.L681:
.L682:

!  437	      case GL_MAP1_GRID_SEGMENTS:
!  438		 *params = INT_TO_BOOL(ctx->Eval.MapGrid1un);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 548
.L684:

	! block 549
.L683:

	! block 550
.L685:
	addx	%g0,0,%l0
	st	%l0,[%fp-436]
	ld	[%fp-436],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 551
.L686:

!  439		 break;

	ba	.L29
	nop

	! block 552
.L687:
.L688:

!  440	      case GL_MAP1_INDEX:
!  441		 *params = ctx->Eval.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f41),%l1
	or	%l1,%lo(0x1f41),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 553
.L689:

!  442		 break;

	ba	.L29
	nop

	! block 554
.L690:
.L691:

!  443	      case GL_MAP1_NORMAL:
!  444		 *params = ctx->Eval.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f42),%l1
	or	%l1,%lo(0x1f42),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 555
.L692:

!  445		 break;

	ba	.L29
	nop

	! block 556
.L693:
.L694:

!  446	      case GL_MAP1_TEXTURE_COORD_1:
!  447		 *params = ctx->Eval.Map1TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f43),%l1
	or	%l1,%lo(0x1f43),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 557
.L695:

!  448		 break;

	ba	.L29
	nop

	! block 558
.L696:
.L697:

!  449	      case GL_MAP1_TEXTURE_COORD_2:
!  450		 *params = ctx->Eval.Map1TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f44),%l1
	or	%l1,%lo(0x1f44),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 559
.L698:

!  451		 break;

	ba	.L29
	nop

	! block 560
.L699:
.L700:

!  452	      case GL_MAP1_TEXTURE_COORD_3:
!  453		 *params = ctx->Eval.Map1TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f45),%l1
	or	%l1,%lo(0x1f45),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 561
.L701:

!  454		 break;

	ba	.L29
	nop

	! block 562
.L702:
.L703:

!  455	      case GL_MAP1_TEXTURE_COORD_4:
!  456		 *params = ctx->Eval.Map1TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f46),%l1
	or	%l1,%lo(0x1f46),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 563
.L704:

!  457		 break;

	ba	.L29
	nop

	! block 564
.L705:
.L706:

!  458	      case GL_MAP1_VERTEX_3:
!  459		 *params = ctx->Eval.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f47),%l1
	or	%l1,%lo(0x1f47),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 565
.L707:

!  460		 break;

	ba	.L29
	nop

	! block 566
.L708:
.L709:

!  461	      case GL_MAP1_VERTEX_4:
!  462		 *params = ctx->Eval.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f48),%l1
	or	%l1,%lo(0x1f48),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 567
.L710:

!  463		 break;

	ba	.L29
	nop

	! block 568
.L711:
.L712:

!  464	      case GL_MAP2_COLOR_4:
!  465		 *params = ctx->Eval.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f49),%l1
	or	%l1,%lo(0x1f49),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 569
.L713:

!  466		 break;

	ba	.L29
	nop

	! block 570
.L714:
.L715:

!  467	      case GL_MAP2_GRID_DOMAIN:
!  468		 params[0] = FLOAT_TO_BOOL(ctx->Eval.MapGrid2u1);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L716
	nop

	! block 571
.L717:
	ba	.L718
	st	%g0,[%fp-440]

	! block 572
.L716:
	mov	1,%l0
	st	%l0,[%fp-440]

	! block 573
.L718:
	ld	[%fp-440],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 574
.L719:

!  469		 params[1] = FLOAT_TO_BOOL(ctx->Eval.MapGrid2u2);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L720
	nop

	! block 575
.L721:
	ba	.L722
	st	%g0,[%fp-444]

	! block 576
.L720:
	mov	1,%l0
	st	%l0,[%fp-444]

	! block 577
.L722:
	ld	[%fp-444],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 578
.L723:

!  470		 params[2] = FLOAT_TO_BOOL(ctx->Eval.MapGrid2v1);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L724
	nop

	! block 579
.L725:
	ba	.L726
	st	%g0,[%fp-448]

	! block 580
.L724:
	mov	1,%l0
	st	%l0,[%fp-448]

	! block 581
.L726:
	ld	[%fp-448],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 582
.L727:

!  471		 params[3] = FLOAT_TO_BOOL(ctx->Eval.MapGrid2v2);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L728
	nop

	! block 583
.L729:
	ba	.L730
	st	%g0,[%fp-452]

	! block 584
.L728:
	mov	1,%l0
	st	%l0,[%fp-452]

	! block 585
.L730:
	ld	[%fp-452],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 586
.L731:

!  472		 break;

	ba	.L29
	nop

	! block 587
.L732:
.L733:

!  473	      case GL_MAP2_GRID_SEGMENTS:
!  474		 params[0] = INT_TO_BOOL(ctx->Eval.MapGrid2un);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 588
.L735:

	! block 589
.L734:

	! block 590
.L736:
	addx	%g0,0,%l0
	st	%l0,[%fp-456]
	ld	[%fp-456],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 591
.L737:

!  475		 params[1] = INT_TO_BOOL(ctx->Eval.MapGrid2vn);

	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 592
.L739:

	! block 593
.L738:

	! block 594
.L740:
	addx	%g0,0,%l0
	st	%l0,[%fp-460]
	ld	[%fp-460],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 595
.L741:

!  476		 break;

	ba	.L29
	nop

	! block 596
.L742:
.L743:

!  477	      case GL_MAP2_INDEX:
!  478		 *params = ctx->Eval.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4a),%l1
	or	%l1,%lo(0x1f4a),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 597
.L744:

!  479		 break;

	ba	.L29
	nop

	! block 598
.L745:
.L746:

!  480	      case GL_MAP2_NORMAL:
!  481		 *params = ctx->Eval.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4b),%l1
	or	%l1,%lo(0x1f4b),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 599
.L747:

!  482		 break;

	ba	.L29
	nop

	! block 600
.L748:
.L749:

!  483	      case GL_MAP2_TEXTURE_COORD_1:
!  484		 *params = ctx->Eval.Map2TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4c),%l1
	or	%l1,%lo(0x1f4c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 601
.L750:

!  485		 break;

	ba	.L29
	nop

	! block 602
.L751:
.L752:

!  486	      case GL_MAP2_TEXTURE_COORD_2:
!  487		 *params = ctx->Eval.Map2TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4d),%l1
	or	%l1,%lo(0x1f4d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 603
.L753:

!  488		 break;

	ba	.L29
	nop

	! block 604
.L754:
.L755:

!  489	      case GL_MAP2_TEXTURE_COORD_3:
!  490		 *params = ctx->Eval.Map2TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4e),%l1
	or	%l1,%lo(0x1f4e),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 605
.L756:

!  491		 break;

	ba	.L29
	nop

	! block 606
.L757:
.L758:

!  492	      case GL_MAP2_TEXTURE_COORD_4:
!  493		 *params = ctx->Eval.Map2TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4f),%l1
	or	%l1,%lo(0x1f4f),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 607
.L759:

!  494		 break;

	ba	.L29
	nop

	! block 608
.L760:
.L761:

!  495	      case GL_MAP2_VERTEX_3:
!  496		 *params = ctx->Eval.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 609
.L762:

!  497		 break;

	ba	.L29
	nop

	! block 610
.L763:
.L764:

!  498	      case GL_MAP2_VERTEX_4:
!  499		 *params = ctx->Eval.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 611
.L765:

!  500		 break;

	ba	.L29
	nop

	! block 612
.L766:
.L767:

!  501	      case GL_MAP_COLOR:
!  502		 *params = ctx->Pixel.MapColorFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 613
.L768:

!  503		 break;

	ba	.L29
	nop

	! block 614
.L769:
.L770:

!  504	      case GL_MAP_STENCIL:
!  505		 *params = ctx->Pixel.MapStencilFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4d),%l1
	or	%l1,%lo(0xae4d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 615
.L771:

!  506		 break;

	ba	.L29
	nop

	! block 616
.L772:
.L773:

!  507	      case GL_MATRIX_MODE:
!  508		 *params = ENUM_TO_BOOL( ctx->Transform.MatrixMode );

	ld	[%fp+68],%l0
	sethi	%hi(0xdc4c),%l1
	or	%l1,%lo(0xdc4c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 617
.L775:

	! block 618
.L774:

	! block 619
.L776:
	addx	%g0,0,%l0
	st	%l0,[%fp-464]
	ld	[%fp-464],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 620
.L777:

!  509		 break;

	ba	.L29
	nop

	! block 621
.L778:
.L779:

!  510	      case GL_MAX_ATTRIB_STACK_DEPTH:
!  511		 *params = INT_TO_BOOL(MAX_ATTRIB_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 622
.L780:

!  512		 break;

	ba	.L29
	nop

	! block 623
.L781:
.L782:

!  513	      case GL_MAX_CLIENT_ATTRIB_STACK_DEPTH:
!  514	         *params = INT_TO_BOOL( MAX_CLIENT_ATTRIB_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 624
.L783:

!  515	         break;

	ba	.L29
	nop

	! block 625
.L784:
.L785:

!  516	      case GL_MAX_CLIP_PLANES:
!  517		 *params = INT_TO_BOOL(MAX_CLIP_PLANES);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 626
.L786:

!  518		 break;

	ba	.L29
	nop

	! block 627
.L787:
.L788:

!  519	      case GL_MAX_EVAL_ORDER:
!  520		 *params = INT_TO_BOOL(MAX_EVAL_ORDER);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 628
.L789:

!  521		 break;

	ba	.L29
	nop

	! block 629
.L790:
.L791:

!  522	      case GL_MAX_LIGHTS:
!  523		 *params = INT_TO_BOOL(MAX_LIGHTS);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 630
.L792:

!  524		 break;

	ba	.L29
	nop

	! block 631
.L793:
.L794:

!  525	      case GL_MAX_LIST_NESTING:
!  526		 *params = INT_TO_BOOL(MAX_LIST_NESTING);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 632
.L795:

!  527		 break;

	ba	.L29
	nop

	! block 633
.L796:
.L797:

!  528	      case GL_MAX_MODELVIEW_STACK_DEPTH:
!  529		 *params = INT_TO_BOOL(MAX_MODELVIEW_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 634
.L798:

!  530		 break;

	ba	.L29
	nop

	! block 635
.L799:
.L800:

!  531	      case GL_MAX_NAME_STACK_DEPTH:
!  532		 *params = INT_TO_BOOL(MAX_NAME_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 636
.L801:

!  533		 break;

	ba	.L29
	nop

	! block 637
.L802:
.L803:

!  534	      case GL_MAX_PIXEL_MAP_TABLE:
!  535		 *params = INT_TO_BOOL(MAX_PIXEL_MAP_TABLE);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 638
.L804:

!  536		 break;

	ba	.L29
	nop

	! block 639
.L805:
.L806:

!  537	      case GL_MAX_PROJECTION_STACK_DEPTH:
!  538		 *params = INT_TO_BOOL(MAX_PROJECTION_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 640
.L807:

!  539		 break;

	ba	.L29
	nop

	! block 641
.L808:
.L809:

!  540	      case GL_MAX_TEXTURE_SIZE:
!  541		 *params = INT_TO_BOOL(MAX_TEXTURE_SIZE);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 642
.L810:

!  542		 break;

	ba	.L29
	nop

	! block 643
.L811:
.L812:

!  543	      case GL_MAX_TEXTURE_STACK_DEPTH:
!  544		 *params = INT_TO_BOOL(MAX_TEXTURE_STACK_DEPTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 644
.L813:

!  545		 break;

	ba	.L29
	nop

	! block 645
.L814:
.L815:

!  546	      case GL_MAX_VIEWPORT_DIMS:
!  547		 params[0] = INT_TO_BOOL(MAX_WIDTH);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 646
.L816:

!  548		 params[1] = INT_TO_BOOL(MAX_HEIGHT);

	mov	1,%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 647
.L817:

!  549		 break;

	ba	.L29
	nop

	! block 648
.L818:
.L819:
.L820:

!  550	      case GL_MODELVIEW_MATRIX:
!  551		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 649
.L824:
.L821:
.L825:
.L826:
.L827:

!  552		    params[i] = FLOAT_TO_BOOL(ctx->ModelViewMatrix[i]);

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+2436],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L828
	nop

	! block 650
.L829:
	ba	.L830
	st	%g0,[%fp-468]

	! block 651
.L828:
	mov	1,%l0
	st	%l0,[%fp-468]

	! block 652
.L830:
	ld	[%fp-468],%l2
	ld	[%fp+76],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 653
.L831:
.L832:
.L833:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L821
	nop

	! block 654
.L834:
.L823:
.L835:
.L836:

!  553		 }
!  554		 break;

	ba	.L29
	nop

	! block 655
.L837:
.L838:

!  555	      case GL_MODELVIEW_STACK_DEPTH:
!  556		 *params = INT_TO_BOOL(ctx->ModelViewStackDepth);

	ld	[%fp+68],%l0
	ld	[%l0+2564],%l0
	cmp	%g0,%l0

	! block 656
.L840:

	! block 657
.L839:

	! block 658
.L841:
	addx	%g0,0,%l0
	st	%l0,[%fp-468]
	ld	[%fp-468],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 659
.L842:

!  557		 break;

	ba	.L29
	nop

	! block 660
.L843:
.L844:

!  558	      case GL_NAME_STACK_DEPTH:
!  559		 *params = INT_TO_BOOL(ctx->Select.NameStackDepth);

	ld	[%fp+68],%l0
	sethi	%hi(0xdfdc),%l1
	or	%l1,%lo(0xdfdc),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 661
.L846:

	! block 662
.L845:

	! block 663
.L847:
	addx	%g0,0,%l0
	st	%l0,[%fp-472]
	ld	[%fp-472],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 664
.L848:

!  560		 break;

	ba	.L29
	nop

	! block 665
.L849:
.L850:

!  561	      case GL_NORMALIZE:
!  562		 *params = ctx->Transform.Normalize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb7),%l1
	or	%l1,%lo(0xdcb7),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 666
.L851:

!  563		 break;

	ba	.L29
	nop

	! block 667
.L852:
.L853:

!  564	      case GL_PACK_ALIGNMENT:
!  565		 *params = INT_TO_BOOL(ctx->Pack.Alignment);

	ld	[%fp+68],%l0
	sethi	%hi(0xddac),%l1
	or	%l1,%lo(0xddac),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 668
.L855:

	! block 669
.L854:

	! block 670
.L856:
	addx	%g0,0,%l0
	st	%l0,[%fp-476]
	ld	[%fp-476],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 671
.L857:

!  566		 break;

	ba	.L29
	nop

	! block 672
.L858:
.L859:

!  567	      case GL_PACK_LSB_FIRST:
!  568		 *params = ctx->Pack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc5),%l1
	or	%l1,%lo(0xddc5),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 673
.L860:

!  569		 break;

	ba	.L29
	nop

	! block 674
.L861:
.L862:

!  570	      case GL_PACK_ROW_LENGTH:
!  571		 *params = INT_TO_BOOL(ctx->Pack.RowLength);

	ld	[%fp+68],%l0
	sethi	%hi(0xddb0),%l1
	or	%l1,%lo(0xddb0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 675
.L864:

	! block 676
.L863:

	! block 677
.L865:
	addx	%g0,0,%l0
	st	%l0,[%fp-480]
	ld	[%fp-480],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 678
.L866:

!  572		 break;

	ba	.L29
	nop

	! block 679
.L867:
.L868:

!  573	      case GL_PACK_SKIP_PIXELS:
!  574		 *params = INT_TO_BOOL(ctx->Pack.SkipPixels);

	ld	[%fp+68],%l0
	sethi	%hi(0xddb4),%l1
	or	%l1,%lo(0xddb4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 680
.L870:

	! block 681
.L869:

	! block 682
.L871:
	addx	%g0,0,%l0
	st	%l0,[%fp-484]
	ld	[%fp-484],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 683
.L872:

!  575		 break;

	ba	.L29
	nop

	! block 684
.L873:
.L874:

!  576	      case GL_PACK_SKIP_ROWS:
!  577		 *params = INT_TO_BOOL(ctx->Pack.SkipRows);

	ld	[%fp+68],%l0
	sethi	%hi(0xddb8),%l1
	or	%l1,%lo(0xddb8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 685
.L876:

	! block 686
.L875:

	! block 687
.L877:
	addx	%g0,0,%l0
	st	%l0,[%fp-488]
	ld	[%fp-488],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 688
.L878:

!  578		 break;

	ba	.L29
	nop

	! block 689
.L879:
.L880:

!  579	      case GL_PACK_SWAP_BYTES:
!  580		 *params = ctx->Pack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc4),%l1
	or	%l1,%lo(0xddc4),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 690
.L881:

!  581		 break;

	ba	.L29
	nop

	! block 691
.L882:
.L883:

!  582	      case GL_PACK_SKIP_IMAGES_EXT:
!  583	         *params = ctx->Pack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc0),%l1
	or	%l1,%lo(0xddc0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 692
.L884:

!  584	         break;

	ba	.L29
	nop

	! block 693
.L885:
.L886:

!  585	      case GL_PACK_IMAGE_HEIGHT_EXT:
!  586	         *params = ctx->Pack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddbc),%l1
	or	%l1,%lo(0xddbc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 694
.L887:

!  587	         break;

	ba	.L29
	nop

	! block 695
.L888:
.L889:

!  588	      case GL_PERSPECTIVE_CORRECTION_HINT:
!  589		 *params = ENUM_TO_BOOL(ctx->Hint.PerspectiveCorrection);

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa0),%l1
	or	%l1,%lo(0x1fa0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 696
.L891:

	! block 697
.L890:

	! block 698
.L892:
	addx	%g0,0,%l0
	st	%l0,[%fp-492]
	ld	[%fp-492],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 699
.L893:

!  590		 break;

	ba	.L29
	nop

	! block 700
.L894:
.L895:

!  591	      case GL_PIXEL_MAP_A_TO_A_SIZE:
!  592		 *params = INT_TO_BOOL(ctx->Pixel.MapAtoAsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 701
.L897:

	! block 702
.L896:

	! block 703
.L898:
	addx	%g0,0,%l0
	st	%l0,[%fp-496]
	ld	[%fp-496],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 704
.L899:

!  593		 break;

	ba	.L29
	nop

	! block 705
.L900:
.L901:

!  594	      case GL_PIXEL_MAP_B_TO_B_SIZE:
!  595		 *params = INT_TO_BOOL(ctx->Pixel.MapBtoBsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 706
.L903:

	! block 707
.L902:

	! block 708
.L904:
	addx	%g0,0,%l0
	st	%l0,[%fp-500]
	ld	[%fp-500],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 709
.L905:

!  596		 break;

	ba	.L29
	nop

	! block 710
.L906:
.L907:

!  597	      case GL_PIXEL_MAP_G_TO_G_SIZE:
!  598		 *params = INT_TO_BOOL(ctx->Pixel.MapGtoGsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 711
.L909:

	! block 712
.L908:

	! block 713
.L910:
	addx	%g0,0,%l0
	st	%l0,[%fp-504]
	ld	[%fp-504],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 714
.L911:

!  599		 break;

	ba	.L29
	nop

	! block 715
.L912:
.L913:

!  600	      case GL_PIXEL_MAP_I_TO_A_SIZE:
!  601		 *params = INT_TO_BOOL(ctx->Pixel.MapItoAsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 716
.L915:

	! block 717
.L914:

	! block 718
.L916:
	addx	%g0,0,%l0
	st	%l0,[%fp-508]
	ld	[%fp-508],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 719
.L917:

!  602		 break;

	ba	.L29
	nop

	! block 720
.L918:
.L919:

!  603	      case GL_PIXEL_MAP_I_TO_B_SIZE:
!  604		 *params = INT_TO_BOOL(ctx->Pixel.MapItoBsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 721
.L921:

	! block 722
.L920:

	! block 723
.L922:
	addx	%g0,0,%l0
	st	%l0,[%fp-512]
	ld	[%fp-512],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 724
.L923:

!  605		 break;

	ba	.L29
	nop

	! block 725
.L924:
.L925:

!  606	      case GL_PIXEL_MAP_I_TO_G_SIZE:
!  607		 *params = INT_TO_BOOL(ctx->Pixel.MapItoGsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 726
.L927:

	! block 727
.L926:

	! block 728
.L928:
	addx	%g0,0,%l0
	st	%l0,[%fp-516]
	ld	[%fp-516],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 729
.L929:

!  608		 break;

	ba	.L29
	nop

	! block 730
.L930:
.L931:

!  609	      case GL_PIXEL_MAP_I_TO_I_SIZE:
!  610		 *params = INT_TO_BOOL(ctx->Pixel.MapItoIsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae5c),%l1
	or	%l1,%lo(0xae5c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 731
.L933:

	! block 732
.L932:

	! block 733
.L934:
	addx	%g0,0,%l0
	st	%l0,[%fp-520]
	ld	[%fp-520],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 734
.L935:

!  611		 break;

	ba	.L29
	nop

	! block 735
.L936:
.L937:

!  612	      case GL_PIXEL_MAP_I_TO_R_SIZE:
!  613		 *params = INT_TO_BOOL(ctx->Pixel.MapItoRsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 736
.L939:

	! block 737
.L938:

	! block 738
.L940:
	addx	%g0,0,%l0
	st	%l0,[%fp-524]
	ld	[%fp-524],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 739
.L941:

!  614		 break;

	ba	.L29
	nop

	! block 740
.L942:
.L943:

!  615	      case GL_PIXEL_MAP_R_TO_R_SIZE:
!  616		 *params = INT_TO_BOOL(ctx->Pixel.MapRtoRsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 741
.L945:

	! block 742
.L944:

	! block 743
.L946:
	addx	%g0,0,%l0
	st	%l0,[%fp-528]
	ld	[%fp-528],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 744
.L947:

!  617		 break;

	ba	.L29
	nop

	! block 745
.L948:
.L949:

!  618	      case GL_PIXEL_MAP_S_TO_S_SIZE:
!  619		 *params = INT_TO_BOOL(ctx->Pixel.MapStoSsize);

	ld	[%fp+68],%l0
	sethi	%hi(0xae58),%l1
	or	%l1,%lo(0xae58),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 746
.L951:

	! block 747
.L950:

	! block 748
.L952:
	addx	%g0,0,%l0
	st	%l0,[%fp-532]
	ld	[%fp-532],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 749
.L953:

!  620		 break;

	ba	.L29
	nop

	! block 750
.L954:
.L955:

!  621	      case GL_POINT_SIZE:
!  622		 *params = FLOAT_TO_BOOL(ctx->Point.Size );

	ld	[%fp+68],%l0
	sethi	%hi(0xd684),%l1
	or	%l1,%lo(0xd684),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L956
	nop

	! block 751
.L957:
	ba	.L958
	st	%g0,[%fp-536]

	! block 752
.L956:
	mov	1,%l0
	st	%l0,[%fp-536]

	! block 753
.L958:
	ld	[%fp-536],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 754
.L959:

!  623		 break;

	ba	.L29
	nop

	! block 755
.L960:
.L961:

!  624	      case GL_POINT_SIZE_GRANULARITY:
!  625		 *params = FLOAT_TO_BOOL(POINT_SIZE_GRANULARITY );

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L962
	nop

	! block 756
.L963:
	ba	.L964
	st	%g0,[%fp-540]

	! block 757
.L962:
	mov	1,%l0
	st	%l0,[%fp-540]

	! block 758
.L964:
	ld	[%fp-540],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 759
.L965:

!  626		 break;

	ba	.L29
	nop

	! block 760
.L966:
.L967:

!  627	      case GL_POINT_SIZE_RANGE:
!  628		 params[0] = FLOAT_TO_BOOL(MIN_POINT_SIZE );

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L968
	nop

	! block 761
.L969:
	ba	.L970
	st	%g0,[%fp-544]

	! block 762
.L968:
	mov	1,%l0
	st	%l0,[%fp-544]

	! block 763
.L970:
	ld	[%fp-544],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 764
.L971:

!  629		 params[1] = FLOAT_TO_BOOL(MAX_POINT_SIZE );

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fstod	%f4,%f4
	fcmpd	%f6,%f4
	fbne	.L972
	nop

	! block 765
.L973:
	ba	.L974
	st	%g0,[%fp-548]

	! block 766
.L972:
	mov	1,%l0
	st	%l0,[%fp-548]

	! block 767
.L974:
	ld	[%fp-548],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 768
.L975:

!  630		 break;

	ba	.L29
	nop

	! block 769
.L976:
.L977:

!  631	      case GL_POINT_SMOOTH:
!  632		 *params = ctx->Point.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd680),%l1
	or	%l1,%lo(0xd680),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 770
.L978:

!  633		 break;

	ba	.L29
	nop

	! block 771
.L979:
.L980:

!  634	      case GL_POINT_SMOOTH_HINT:
!  635		 *params = ENUM_TO_BOOL(ctx->Hint.PointSmooth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa4),%l1
	or	%l1,%lo(0x1fa4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 772
.L982:

	! block 773
.L981:

	! block 774
.L983:
	addx	%g0,0,%l0
	st	%l0,[%fp-552]
	ld	[%fp-552],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 775
.L984:

!  636		 break;

	ba	.L29
	nop

	! block 776
.L985:
.L986:

!  637	      case GL_POINT_SIZE_MIN_EXT:
!  638		 *params = FLOAT_TO_BOOL(ctx->Point.MinSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd694),%l1
	or	%l1,%lo(0xd694),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L987
	nop

	! block 777
.L988:
	ba	.L989
	st	%g0,[%fp-556]

	! block 778
.L987:
	mov	1,%l0
	st	%l0,[%fp-556]

	! block 779
.L989:
	ld	[%fp-556],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 780
.L990:

!  639		 break;

	ba	.L29
	nop

	! block 781
.L991:
.L992:

!  640	      case GL_POINT_SIZE_MAX_EXT:
!  641		 *params = FLOAT_TO_BOOL(ctx->Point.MaxSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd698),%l1
	or	%l1,%lo(0xd698),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L993
	nop

	! block 782
.L994:
	ba	.L995
	st	%g0,[%fp-560]

	! block 783
.L993:
	mov	1,%l0
	st	%l0,[%fp-560]

	! block 784
.L995:
	ld	[%fp-560],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 785
.L996:

!  642		 break;

	ba	.L29
	nop

	! block 786
.L997:
.L998:

!  643	      case GL_POINT_FADE_THRESHOLD_SIZE_EXT:
!  644		 *params = FLOAT_TO_BOOL(ctx->Point.Threshold);

	ld	[%fp+68],%l0
	sethi	%hi(0xd69c),%l1
	or	%l1,%lo(0xd69c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L999
	nop

	! block 787
.L1000:
	ba	.L1001
	st	%g0,[%fp-564]

	! block 788
.L999:
	mov	1,%l0
	st	%l0,[%fp-564]

	! block 789
.L1001:
	ld	[%fp-564],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 790
.L1002:

!  645		 break;

	ba	.L29
	nop

	! block 791
.L1003:
.L1004:

!  646	      case GL_DISTANCE_ATTENUATION_EXT:
!  647		 params[0] = FLOAT_TO_BOOL(ctx->Point.Params[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd688),%l1
	or	%l1,%lo(0xd688),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1005
	nop

	! block 792
.L1006:
	ba	.L1007
	st	%g0,[%fp-568]

	! block 793
.L1005:
	mov	1,%l0
	st	%l0,[%fp-568]

	! block 794
.L1007:
	ld	[%fp-568],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 795
.L1008:

!  648		 params[1] = FLOAT_TO_BOOL(ctx->Point.Params[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd68c),%l1
	or	%l1,%lo(0xd68c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1009
	nop

	! block 796
.L1010:
	ba	.L1011
	st	%g0,[%fp-572]

	! block 797
.L1009:
	mov	1,%l0
	st	%l0,[%fp-572]

	! block 798
.L1011:
	ld	[%fp-572],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 799
.L1012:

!  649		 params[2] = FLOAT_TO_BOOL(ctx->Point.Params[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd690),%l1
	or	%l1,%lo(0xd690),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1013
	nop

	! block 800
.L1014:
	ba	.L1015
	st	%g0,[%fp-576]

	! block 801
.L1013:
	mov	1,%l0
	st	%l0,[%fp-576]

	! block 802
.L1015:
	ld	[%fp-576],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 803
.L1016:

!  650		 break;

	ba	.L29
	nop

	! block 804
.L1017:
.L1018:

!  651	      case GL_POLYGON_MODE:
!  652		 params[0] = ENUM_TO_BOOL(ctx->Polygon.FrontMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a4),%l1
	or	%l1,%lo(0xd6a4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 805
.L1020:

	! block 806
.L1019:

	! block 807
.L1021:
	addx	%g0,0,%l0
	st	%l0,[%fp-580]
	ld	[%fp-580],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 808
.L1022:

!  653		 params[1] = ENUM_TO_BOOL(ctx->Polygon.BackMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a8),%l1
	or	%l1,%lo(0xd6a8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 809
.L1024:

	! block 810
.L1023:

	! block 811
.L1025:
	addx	%g0,0,%l0
	st	%l0,[%fp-584]
	ld	[%fp-584],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 812
.L1026:

!  654		 break;

	ba	.L29
	nop

	! block 813
.L1027:
.L1028:

!  655	#ifdef GL_EXT_polygon_offset
!  656	      case GL_POLYGON_OFFSET_BIAS_EXT:
!  657	         *params = FLOAT_TO_BOOL( ctx->Polygon.OffsetUnits );

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1029
	nop

	! block 814
.L1030:
	ba	.L1031
	st	%g0,[%fp-588]

	! block 815
.L1029:
	mov	1,%l0
	st	%l0,[%fp-588]

	! block 816
.L1031:
	ld	[%fp-588],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 817
.L1032:

!  658	         break;

	ba	.L29
	nop

	! block 818
.L1033:
.L1034:

!  659	#endif
!  660	      case GL_POLYGON_OFFSET_FACTOR:
!  661	         *params = FLOAT_TO_BOOL( ctx->Polygon.OffsetFactor );

	ld	[%fp+68],%l0
	sethi	%hi(0xd6bc),%l1
	or	%l1,%lo(0xd6bc),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1035
	nop

	! block 819
.L1036:
	ba	.L1037
	st	%g0,[%fp-592]

	! block 820
.L1035:
	mov	1,%l0
	st	%l0,[%fp-592]

	! block 821
.L1037:
	ld	[%fp-592],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 822
.L1038:

!  662	         break;

	ba	.L29
	nop

	! block 823
.L1039:
.L1040:

!  663	      case GL_POLYGON_OFFSET_UNITS:
!  664	         *params = FLOAT_TO_BOOL( ctx->Polygon.OffsetUnits );

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1041
	nop

	! block 824
.L1042:
	ba	.L1043
	st	%g0,[%fp-596]

	! block 825
.L1041:
	mov	1,%l0
	st	%l0,[%fp-596]

	! block 826
.L1043:
	ld	[%fp-596],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 827
.L1044:

!  665	         break;

	ba	.L29
	nop

	! block 828
.L1045:
.L1046:

!  666	      case GL_POLYGON_SMOOTH:
!  667		 *params = ctx->Polygon.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b8),%l1
	or	%l1,%lo(0xd6b8),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 829
.L1047:

!  668		 break;

	ba	.L29
	nop

	! block 830
.L1048:
.L1049:

!  669	      case GL_POLYGON_SMOOTH_HINT:
!  670		 *params = ENUM_TO_BOOL(ctx->Hint.PolygonSmooth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1fac),%l1
	or	%l1,%lo(0x1fac),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 831
.L1051:

	! block 832
.L1050:

	! block 833
.L1052:
	addx	%g0,0,%l0
	st	%l0,[%fp-600]
	ld	[%fp-600],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 834
.L1053:

!  671		 break;

	ba	.L29
	nop

	! block 835
.L1054:
.L1055:

!  672	      case GL_POLYGON_STIPPLE:
!  673		 *params = ctx->Polygon.StippleFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b9),%l1
	or	%l1,%lo(0xd6b9),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 836
.L1056:

!  674		 break;

	ba	.L29
	nop

	! block 837
.L1057:
.L1058:
.L1059:

!  675	      case GL_PROJECTION_MATRIX:
!  676		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 838
.L1063:
.L1060:
.L1064:
.L1065:
.L1066:

!  677		    params[i] = FLOAT_TO_BOOL(ctx->ProjectionMatrix[i]);

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x1210),%l1
	or	%l1,%lo(0x1210),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1067
	nop

	! block 839
.L1068:
	ba	.L1069
	st	%g0,[%fp-604]

	! block 840
.L1067:
	mov	1,%l0
	st	%l0,[%fp-604]

	! block 841
.L1069:
	ld	[%fp-604],%l2
	ld	[%fp+76],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 842
.L1070:
.L1071:
.L1072:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L1060
	nop

	! block 843
.L1073:
.L1062:
.L1074:
.L1075:

!  678		 }
!  679		 break;

	ba	.L29
	nop

	! block 844
.L1076:
.L1077:

!  680	      case GL_PROJECTION_STACK_DEPTH:
!  681		 *params = INT_TO_BOOL(ctx->ProjectionStackDepth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1250),%l1
	or	%l1,%lo(0x1250),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 845
.L1079:

	! block 846
.L1078:

	! block 847
.L1080:
	addx	%g0,0,%l0
	st	%l0,[%fp-604]
	ld	[%fp-604],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 848
.L1081:

!  682		 break;

	ba	.L29
	nop

	! block 849
.L1082:
.L1083:

!  683	      case GL_READ_BUFFER:
!  684		 *params = ENUM_TO_BOOL(ctx->Pixel.ReadBuffer);

	ld	[%fp+68],%l0
	sethi	%hi(0xae18),%l1
	or	%l1,%lo(0xae18),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 850
.L1085:

	! block 851
.L1084:

	! block 852
.L1086:
	addx	%g0,0,%l0
	st	%l0,[%fp-608]
	ld	[%fp-608],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 853
.L1087:

!  685		 break;

	ba	.L29
	nop

	! block 854
.L1088:
.L1089:

!  686	      case GL_RED_BIAS:
!  687	         *params = FLOAT_TO_BOOL(ctx->Pixel.RedBias);

	ld	[%fp+68],%l0
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1090
	nop

	! block 855
.L1091:
	ba	.L1092
	st	%g0,[%fp-612]

	! block 856
.L1090:
	mov	1,%l0
	st	%l0,[%fp-612]

	! block 857
.L1092:
	ld	[%fp-612],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 858
.L1093:

!  688		 break;

	ba	.L29
	nop

	! block 859
.L1094:
.L1095:

!  689	      case GL_RED_BITS:
!  690	         *params = INT_TO_BOOL( ctx->Visual->RedBits );

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+40],%l0
	cmp	%g0,%l0

	! block 860
.L1097:

	! block 861
.L1096:

	! block 862
.L1098:
	addx	%g0,0,%l0
	st	%l0,[%fp-616]
	ld	[%fp-616],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 863
.L1099:

!  691		 break;

	ba	.L29
	nop

	! block 864
.L1100:
.L1101:

!  692	      case GL_RED_SCALE:
!  693	         *params = FLOAT_TO_BOOL(ctx->Pixel.RedScale);

	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1102
	nop

	! block 865
.L1103:
	ba	.L1104
	st	%g0,[%fp-620]

	! block 866
.L1102:
	mov	1,%l0
	st	%l0,[%fp-620]

	! block 867
.L1104:
	ld	[%fp-620],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 868
.L1105:

!  694		 break;

	ba	.L29
	nop

	! block 869
.L1106:
.L1107:

!  695	      case GL_RENDER_MODE:
!  696		 *params = ENUM_TO_BOOL(ctx->RenderMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 870
.L1109:

	! block 871
.L1108:

	! block 872
.L1110:
	addx	%g0,0,%l0
	st	%l0,[%fp-624]
	ld	[%fp-624],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 873
.L1111:

!  697		 break;

	ba	.L29
	nop

	! block 874
.L1112:
.L1113:

!  698	      case GL_RGBA_MODE:
!  699	         *params = ctx->Visual->RGBAflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 875
.L1114:

!  700		 break;

	ba	.L29
	nop

	! block 876
.L1115:
.L1116:

!  701	      case GL_SCISSOR_BOX:
!  702		 params[0] = INT_TO_BOOL(ctx->Scissor.X);

	ld	[%fp+68],%l0
	sethi	%hi(0xd74c),%l1
	or	%l1,%lo(0xd74c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 877
.L1118:

	! block 878
.L1117:

	! block 879
.L1119:
	addx	%g0,0,%l0
	st	%l0,[%fp-628]
	ld	[%fp-628],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 880
.L1120:

!  703		 params[1] = INT_TO_BOOL(ctx->Scissor.Y);

	ld	[%fp+68],%l0
	sethi	%hi(0xd750),%l1
	or	%l1,%lo(0xd750),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 881
.L1122:

	! block 882
.L1121:

	! block 883
.L1123:
	addx	%g0,0,%l0
	st	%l0,[%fp-632]
	ld	[%fp-632],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 884
.L1124:

!  704		 params[2] = INT_TO_BOOL(ctx->Scissor.Width);

	ld	[%fp+68],%l0
	sethi	%hi(0xd754),%l1
	or	%l1,%lo(0xd754),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 885
.L1126:

	! block 886
.L1125:

	! block 887
.L1127:
	addx	%g0,0,%l0
	st	%l0,[%fp-636]
	ld	[%fp-636],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 888
.L1128:

!  705		 params[3] = INT_TO_BOOL(ctx->Scissor.Height);

	ld	[%fp+68],%l0
	sethi	%hi(0xd758),%l1
	or	%l1,%lo(0xd758),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 889
.L1130:

	! block 890
.L1129:

	! block 891
.L1131:
	addx	%g0,0,%l0
	st	%l0,[%fp-640]
	ld	[%fp-640],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 892
.L1132:

!  706		 break;

	ba	.L29
	nop

	! block 893
.L1133:
.L1134:

!  707	      case GL_SCISSOR_TEST:
!  708		 *params = ctx->Scissor.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd748),%l1
	or	%l1,%lo(0xd748),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 894
.L1135:

!  709		 break;

	ba	.L29
	nop

	! block 895
.L1136:
.L1137:

!  710	      case GL_SHADE_MODEL:
!  711		 *params = ENUM_TO_BOOL(ctx->Light.ShadeModel);

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 896
.L1139:

	! block 897
.L1138:

	! block 898
.L1140:
	addx	%g0,0,%l0
	st	%l0,[%fp-644]
	ld	[%fp-644],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 899
.L1141:

!  712		 break;

	ba	.L29
	nop

	! block 900
.L1142:
.L1143:

!  713	      case GL_SHARED_TEXTURE_PALETTE_EXT:
!  714	         *params = ctx->Texture.SharedPalette;

	ld	[%fp+68],%l0
	sethi	%hi(0xd83c),%l1
	or	%l1,%lo(0xd83c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 901
.L1144:

!  715	         break;

	ba	.L29
	nop

	! block 902
.L1145:
.L1146:

!  716	      case GL_STENCIL_BITS:
!  717		 *params = INT_TO_BOOL(ctx->Visual->StencilBits);

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+68],%l0
	cmp	%g0,%l0

	! block 903
.L1148:

	! block 904
.L1147:

	! block 905
.L1149:
	addx	%g0,0,%l0
	st	%l0,[%fp-648]
	ld	[%fp-648],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 906
.L1150:

!  718		 break;

	ba	.L29
	nop

	! block 907
.L1151:
.L1152:

!  719	      case GL_STENCIL_CLEAR_VALUE:
!  720		 *params = INT_TO_BOOL(ctx->Stencil.Clear);

	ld	[%fp+68],%l0
	sethi	%hi(0xd772),%l1
	or	%l1,%lo(0xd772),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 908
.L1154:

	! block 909
.L1153:

	! block 910
.L1155:
	addx	%g0,0,%l0
	st	%l0,[%fp-652]
	ld	[%fp-652],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 911
.L1156:

!  721		 break;

	ba	.L29
	nop

	! block 912
.L1157:
.L1158:

!  722	      case GL_STENCIL_FAIL:
!  723		 *params = ENUM_TO_BOOL(ctx->Stencil.FailFunc);

	ld	[%fp+68],%l0
	sethi	%hi(0xd764),%l1
	or	%l1,%lo(0xd764),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 913
.L1160:

	! block 914
.L1159:

	! block 915
.L1161:
	addx	%g0,0,%l0
	st	%l0,[%fp-656]
	ld	[%fp-656],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 916
.L1162:

!  724		 break;

	ba	.L29
	nop

	! block 917
.L1163:
.L1164:

!  725	      case GL_STENCIL_FUNC:
!  726		 *params = ENUM_TO_BOOL(ctx->Stencil.Function);

	ld	[%fp+68],%l0
	sethi	%hi(0xd760),%l1
	or	%l1,%lo(0xd760),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 918
.L1166:

	! block 919
.L1165:

	! block 920
.L1167:
	addx	%g0,0,%l0
	st	%l0,[%fp-660]
	ld	[%fp-660],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 921
.L1168:

!  727		 break;

	ba	.L29
	nop

	! block 922
.L1169:
.L1170:

!  728	      case GL_STENCIL_PASS_DEPTH_FAIL:
!  729		 *params = ENUM_TO_BOOL(ctx->Stencil.ZFailFunc);

	ld	[%fp+68],%l0
	sethi	%hi(0xd76c),%l1
	or	%l1,%lo(0xd76c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 923
.L1172:

	! block 924
.L1171:

	! block 925
.L1173:
	addx	%g0,0,%l0
	st	%l0,[%fp-664]
	ld	[%fp-664],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 926
.L1174:

!  730		 break;

	ba	.L29
	nop

	! block 927
.L1175:
.L1176:

!  731	      case GL_STENCIL_PASS_DEPTH_PASS:
!  732		 *params = ENUM_TO_BOOL(ctx->Stencil.ZPassFunc);

	ld	[%fp+68],%l0
	sethi	%hi(0xd768),%l1
	or	%l1,%lo(0xd768),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 928
.L1178:

	! block 929
.L1177:

	! block 930
.L1179:
	addx	%g0,0,%l0
	st	%l0,[%fp-668]
	ld	[%fp-668],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 931
.L1180:

!  733		 break;

	ba	.L29
	nop

	! block 932
.L1181:
.L1182:

!  734	      case GL_STENCIL_REF:
!  735		 *params = INT_TO_BOOL(ctx->Stencil.Ref);

	ld	[%fp+68],%l0
	sethi	%hi(0xd770),%l1
	or	%l1,%lo(0xd770),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 933
.L1184:

	! block 934
.L1183:

	! block 935
.L1185:
	addx	%g0,0,%l0
	st	%l0,[%fp-672]
	ld	[%fp-672],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 936
.L1186:

!  736		 break;

	ba	.L29
	nop

	! block 937
.L1187:
.L1188:

!  737	      case GL_STENCIL_TEST:
!  738		 *params = ctx->Stencil.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd75c),%l1
	or	%l1,%lo(0xd75c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 938
.L1189:

!  739		 break;

	ba	.L29
	nop

	! block 939
.L1190:
.L1191:

!  740	      case GL_STENCIL_VALUE_MASK:
!  741		 *params = INT_TO_BOOL(ctx->Stencil.ValueMask);

	ld	[%fp+68],%l0
	sethi	%hi(0xd771),%l1
	or	%l1,%lo(0xd771),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 940
.L1193:

	! block 941
.L1192:

	! block 942
.L1194:
	addx	%g0,0,%l0
	st	%l0,[%fp-676]
	ld	[%fp-676],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 943
.L1195:

!  742		 break;

	ba	.L29
	nop

	! block 944
.L1196:
.L1197:

!  743	      case GL_STENCIL_WRITEMASK:
!  744		 *params = INT_TO_BOOL(ctx->Stencil.WriteMask);

	ld	[%fp+68],%l0
	sethi	%hi(0xd773),%l1
	or	%l1,%lo(0xd773),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 945
.L1199:

	! block 946
.L1198:

	! block 947
.L1200:
	addx	%g0,0,%l0
	st	%l0,[%fp-680]
	ld	[%fp-680],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 948
.L1201:

!  745		 break;

	ba	.L29
	nop

	! block 949
.L1202:
.L1203:

!  746	      case GL_STEREO:
!  747		 *params = GL_FALSE;    /* TODO */

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 950
.L1204:

!  748		 break;

	ba	.L29
	nop

	! block 951
.L1205:
.L1206:

!  749	      case GL_SUBPIXEL_BITS:
!  750		 *params = INT_TO_BOOL(0);  /* TODO */

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 952
.L1207:

!  751		 break;

	ba	.L29
	nop

	! block 953
.L1208:
.L1209:

!  752	      case GL_TEXTURE_1D:
!  753		 *params = (ctx->Texture.Enabled & TEXTURE_1D) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	and	%l0,1,%l0
	cmp	%g0,%l0

	! block 954
.L1211:

	! block 955
.L1210:

	! block 956
.L1212:
	addx	%g0,0,%l0
	st	%l0,[%fp-684]
	ld	[%fp-684],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 957
.L1213:

!  754		 break;

	ba	.L29
	nop

	! block 958
.L1214:
.L1215:

!  755	      case GL_TEXTURE_2D:
!  756		 *params = (ctx->Texture.Enabled & TEXTURE_2D) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	and	%l0,2,%l0
	cmp	%g0,%l0

	! block 959
.L1217:

	! block 960
.L1216:

	! block 961
.L1218:
	addx	%g0,0,%l0
	st	%l0,[%fp-688]
	ld	[%fp-688],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 962
.L1219:

!  757		 break;

	ba	.L29
	nop

	! block 963
.L1220:
.L1221:

!  758	      case GL_TEXTURE_3D_EXT:
!  759		 *params = (ctx->Texture.Enabled & TEXTURE_3D) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	and	%l0,4,%l0
	cmp	%g0,%l0

	! block 964
.L1223:

	! block 965
.L1222:

	! block 966
.L1224:
	addx	%g0,0,%l0
	st	%l0,[%fp-692]
	ld	[%fp-692],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 967
.L1225:

!  760		 break;

	ba	.L29
	nop

	! block 968
.L1226:
.L1227:

!  761	      case GL_TEXTURE_ENV_COLOR:
!  762		 params[0] = FLOAT_TO_BOOL(ctx->Texture.EnvColor[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd77c),%l1
	or	%l1,%lo(0xd77c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1228
	nop

	! block 969
.L1229:
	ba	.L1230
	st	%g0,[%fp-696]

	! block 970
.L1228:
	mov	1,%l0
	st	%l0,[%fp-696]

	! block 971
.L1230:
	ld	[%fp-696],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 972
.L1231:

!  763		 params[1] = FLOAT_TO_BOOL(ctx->Texture.EnvColor[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd780),%l1
	or	%l1,%lo(0xd780),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1232
	nop

	! block 973
.L1233:
	ba	.L1234
	st	%g0,[%fp-700]

	! block 974
.L1232:
	mov	1,%l0
	st	%l0,[%fp-700]

	! block 975
.L1234:
	ld	[%fp-700],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 976
.L1235:

!  764		 params[2] = FLOAT_TO_BOOL(ctx->Texture.EnvColor[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd784),%l1
	or	%l1,%lo(0xd784),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1236
	nop

	! block 977
.L1237:
	ba	.L1238
	st	%g0,[%fp-704]

	! block 978
.L1236:
	mov	1,%l0
	st	%l0,[%fp-704]

	! block 979
.L1238:
	ld	[%fp-704],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 980
.L1239:

!  765		 params[3] = FLOAT_TO_BOOL(ctx->Texture.EnvColor[3]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd788),%l1
	or	%l1,%lo(0xd788),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1240
	nop

	! block 981
.L1241:
	ba	.L1242
	st	%g0,[%fp-708]

	! block 982
.L1240:
	mov	1,%l0
	st	%l0,[%fp-708]

	! block 983
.L1242:
	ld	[%fp-708],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 984
.L1243:

!  766		 break;

	ba	.L29
	nop

	! block 985
.L1244:
.L1245:

!  767	      case GL_TEXTURE_ENV_MODE:
!  768		 *params = ENUM_TO_BOOL(ctx->Texture.EnvMode);

	ld	[%fp+68],%l0
	sethi	%hi(0xd778),%l1
	or	%l1,%lo(0xd778),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 986
.L1247:

	! block 987
.L1246:

	! block 988
.L1248:
	addx	%g0,0,%l0
	st	%l0,[%fp-712]
	ld	[%fp-712],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 989
.L1249:

!  769		 break;

	ba	.L29
	nop

	! block 990
.L1250:
.L1251:

!  770	      case GL_TEXTURE_GEN_S:
!  771		 *params = (ctx->Texture.TexGenEnabled & S_BIT) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,4,%l0
	cmp	%g0,%l0

	! block 991
.L1253:

	! block 992
.L1252:

	! block 993
.L1254:
	addx	%g0,0,%l0
	st	%l0,[%fp-716]
	ld	[%fp-716],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 994
.L1255:

!  772		 break;

	ba	.L29
	nop

	! block 995
.L1256:
.L1257:

!  773	      case GL_TEXTURE_GEN_T:
!  774		 *params = (ctx->Texture.TexGenEnabled & T_BIT) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,8,%l0
	cmp	%g0,%l0

	! block 996
.L1259:

	! block 997
.L1258:

	! block 998
.L1260:
	addx	%g0,0,%l0
	st	%l0,[%fp-720]
	ld	[%fp-720],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 999
.L1261:

!  775		 break;

	ba	.L29
	nop

	! block 1000
.L1262:
.L1263:

!  776	      case GL_TEXTURE_GEN_R:
!  777		 *params = (ctx->Texture.TexGenEnabled & R_BIT) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,2,%l0
	cmp	%g0,%l0

	! block 1001
.L1265:

	! block 1002
.L1264:

	! block 1003
.L1266:
	addx	%g0,0,%l0
	st	%l0,[%fp-724]
	ld	[%fp-724],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1004
.L1267:

!  778		 break;

	ba	.L29
	nop

	! block 1005
.L1268:
.L1269:

!  779	      case GL_TEXTURE_GEN_Q:
!  780		 *params = (ctx->Texture.TexGenEnabled & Q_BIT) ? GL_TRUE : GL_FALSE;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,1,%l0
	cmp	%g0,%l0

	! block 1006
.L1271:

	! block 1007
.L1270:

	! block 1008
.L1272:
	addx	%g0,0,%l0
	st	%l0,[%fp-728]
	ld	[%fp-728],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1009
.L1273:

!  781		 break;

	ba	.L29
	nop

	! block 1010
.L1274:
.L1275:
.L1276:

!  782	      case GL_TEXTURE_MATRIX:
!  783		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 1011
.L1280:
.L1277:
.L1281:
.L1282:
.L1283:

!  784		    params[i] = FLOAT_TO_BOOL(ctx->TextureMatrix[i]);

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0x1b5c),%l1
	or	%l1,%lo(0x1b5c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1284
	nop

	! block 1012
.L1285:
	ba	.L1286
	st	%g0,[%fp-732]

	! block 1013
.L1284:
	mov	1,%l0
	st	%l0,[%fp-732]

	! block 1014
.L1286:
	ld	[%fp-732],%l2
	ld	[%fp+76],%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 1015
.L1287:
.L1288:
.L1289:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L1277
	nop

	! block 1016
.L1290:
.L1279:
.L1291:
.L1292:

!  785		 }
!  786		 break;

	ba	.L29
	nop

	! block 1017
.L1293:
.L1294:

!  787	      case GL_TEXTURE_STACK_DEPTH:
!  788		 *params = INT_TO_BOOL(ctx->TextureStackDepth);

	ld	[%fp+68],%l0
	sethi	%hi(0x1b9c),%l1
	or	%l1,%lo(0x1b9c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1018
.L1296:

	! block 1019
.L1295:

	! block 1020
.L1297:
	addx	%g0,0,%l0
	st	%l0,[%fp-732]
	ld	[%fp-732],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1021
.L1298:

!  789		 break;

	ba	.L29
	nop

	! block 1022
.L1299:
.L1300:

!  790	      case GL_UNPACK_ALIGNMENT:
!  791		 *params = INT_TO_BOOL(ctx->Unpack.Alignment);

	ld	[%fp+68],%l0
	sethi	%hi(0xddc8),%l1
	or	%l1,%lo(0xddc8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1023
.L1302:

	! block 1024
.L1301:

	! block 1025
.L1303:
	addx	%g0,0,%l0
	st	%l0,[%fp-736]
	ld	[%fp-736],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1026
.L1304:

!  792		 break;

	ba	.L29
	nop

	! block 1027
.L1305:
.L1306:

!  793	      case GL_UNPACK_LSB_FIRST:
!  794		 *params = ctx->Unpack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde1),%l1
	or	%l1,%lo(0xdde1),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1028
.L1307:

!  795		 break;

	ba	.L29
	nop

	! block 1029
.L1308:
.L1309:

!  796	      case GL_UNPACK_ROW_LENGTH:
!  797		 *params = INT_TO_BOOL(ctx->Unpack.RowLength);

	ld	[%fp+68],%l0
	sethi	%hi(0xddcc),%l1
	or	%l1,%lo(0xddcc),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1030
.L1311:

	! block 1031
.L1310:

	! block 1032
.L1312:
	addx	%g0,0,%l0
	st	%l0,[%fp-740]
	ld	[%fp-740],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1033
.L1313:

!  798		 break;

	ba	.L29
	nop

	! block 1034
.L1314:
.L1315:

!  799	      case GL_UNPACK_SKIP_PIXELS:
!  800		 *params = INT_TO_BOOL(ctx->Unpack.SkipPixels);

	ld	[%fp+68],%l0
	sethi	%hi(0xddd0),%l1
	or	%l1,%lo(0xddd0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1035
.L1317:

	! block 1036
.L1316:

	! block 1037
.L1318:
	addx	%g0,0,%l0
	st	%l0,[%fp-744]
	ld	[%fp-744],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1038
.L1319:

!  801		 break;

	ba	.L29
	nop

	! block 1039
.L1320:
.L1321:

!  802	      case GL_UNPACK_SKIP_ROWS:
!  803		 *params = INT_TO_BOOL(ctx->Unpack.SkipRows);

	ld	[%fp+68],%l0
	sethi	%hi(0xddd4),%l1
	or	%l1,%lo(0xddd4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1040
.L1323:

	! block 1041
.L1322:

	! block 1042
.L1324:
	addx	%g0,0,%l0
	st	%l0,[%fp-748]
	ld	[%fp-748],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1043
.L1325:

!  804		 break;

	ba	.L29
	nop

	! block 1044
.L1326:
.L1327:

!  805	      case GL_UNPACK_SWAP_BYTES:
!  806		 *params = ctx->Unpack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde0),%l1
	or	%l1,%lo(0xdde0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1045
.L1328:

!  807		 break;

	ba	.L29
	nop

	! block 1046
.L1329:
.L1330:

!  808	      case GL_UNPACK_SKIP_IMAGES_EXT:
!  809	         *params = ctx->Unpack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xdddc),%l1
	or	%l1,%lo(0xdddc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1047
.L1331:

!  810	         break;

	ba	.L29
	nop

	! block 1048
.L1332:
.L1333:

!  811	      case GL_UNPACK_IMAGE_HEIGHT_EXT:
!  812	         *params = ctx->Unpack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd8),%l1
	or	%l1,%lo(0xddd8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1049
.L1334:

!  813	         break;

	ba	.L29
	nop

	! block 1050
.L1335:
.L1336:

!  814	      case GL_VIEWPORT:
!  815		 params[0] = INT_TO_BOOL(ctx->Viewport.X);

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb8),%l1
	or	%l1,%lo(0xdcb8),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1051
.L1338:

	! block 1052
.L1337:

	! block 1053
.L1339:
	addx	%g0,0,%l0
	st	%l0,[%fp-752]
	ld	[%fp-752],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1054
.L1340:

!  816		 params[1] = INT_TO_BOOL(ctx->Viewport.Y);

	ld	[%fp+68],%l0
	sethi	%hi(0xdcbc),%l1
	or	%l1,%lo(0xdcbc),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1055
.L1342:

	! block 1056
.L1341:

	! block 1057
.L1343:
	addx	%g0,0,%l0
	st	%l0,[%fp-756]
	ld	[%fp-756],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+1]

	! block 1058
.L1344:

!  817		 params[2] = INT_TO_BOOL(ctx->Viewport.Width);

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc0),%l1
	or	%l1,%lo(0xdcc0),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1059
.L1346:

	! block 1060
.L1345:

	! block 1061
.L1347:
	addx	%g0,0,%l0
	st	%l0,[%fp-760]
	ld	[%fp-760],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+2]

	! block 1062
.L1348:

!  818		 params[3] = INT_TO_BOOL(ctx->Viewport.Height);

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc4),%l1
	or	%l1,%lo(0xdcc4),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1063
.L1350:

	! block 1064
.L1349:

	! block 1065
.L1351:
	addx	%g0,0,%l0
	st	%l0,[%fp-764]
	ld	[%fp-764],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+3]

	! block 1066
.L1352:

!  819		 break;

	ba	.L29
	nop

	! block 1067
.L1353:
.L1354:

!  820	      case GL_ZOOM_X:
!  821		 *params = FLOAT_TO_BOOL(ctx->Pixel.ZoomX);

	ld	[%fp+68],%l0
	sethi	%hi(0xae50),%l1
	or	%l1,%lo(0xae50),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1355
	nop

	! block 1068
.L1356:
	ba	.L1357
	st	%g0,[%fp-768]

	! block 1069
.L1355:
	mov	1,%l0
	st	%l0,[%fp-768]

	! block 1070
.L1357:
	ld	[%fp-768],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1071
.L1358:

!  822		 break;

	ba	.L29
	nop

	! block 1072
.L1359:
.L1360:

!  823	      case GL_ZOOM_Y:
!  824		 *params = FLOAT_TO_BOOL(ctx->Pixel.ZoomY);

	ld	[%fp+68],%l0
	sethi	%hi(0xae54),%l1
	or	%l1,%lo(0xae54),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L1361
	nop

	! block 1073
.L1362:
	ba	.L1363
	st	%g0,[%fp-772]

	! block 1074
.L1361:
	mov	1,%l0
	st	%l0,[%fp-772]

	! block 1075
.L1363:
	ld	[%fp-772],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1076
.L1364:

!  825		 break;

	ba	.L29
	nop

	! block 1077
.L1365:
.L1366:

!  826	      case GL_VERTEX_ARRAY_SIZE:
!  827	         *params = INT_TO_BOOL(ctx->Array.VertexSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd2c),%l1
	or	%l1,%lo(0xdd2c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1078
.L1368:

	! block 1079
.L1367:

	! block 1080
.L1369:
	addx	%g0,0,%l0
	st	%l0,[%fp-776]
	ld	[%fp-776],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1081
.L1370:

!  828	         break;

	ba	.L29
	nop

	! block 1082
.L1371:
.L1372:

!  829	      case GL_VERTEX_ARRAY_TYPE:
!  830	         *params = ENUM_TO_BOOL(ctx->Array.VertexType);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd30),%l1
	or	%l1,%lo(0xdd30),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1083
.L1374:

	! block 1084
.L1373:

	! block 1085
.L1375:
	addx	%g0,0,%l0
	st	%l0,[%fp-780]
	ld	[%fp-780],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1086
.L1376:

!  831	         break;

	ba	.L29
	nop

	! block 1087
.L1377:
.L1378:

!  832	      case GL_VERTEX_ARRAY_STRIDE:
!  833	         *params = INT_TO_BOOL(ctx->Array.VertexStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd34),%l1
	or	%l1,%lo(0xdd34),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1088
.L1380:

	! block 1089
.L1379:

	! block 1090
.L1381:
	addx	%g0,0,%l0
	st	%l0,[%fp-784]
	ld	[%fp-784],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1091
.L1382:

!  834	         break;

	ba	.L29
	nop

	! block 1092
.L1383:
.L1384:

!  835	      case GL_VERTEX_ARRAY_COUNT_EXT:
!  836	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1093
.L1385:

!  837	         break;

	ba	.L29
	nop

	! block 1094
.L1386:
.L1387:

!  838	      case GL_NORMAL_ARRAY_TYPE:
!  839	         *params = ENUM_TO_BOOL(ctx->Array.NormalType);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd44),%l1
	or	%l1,%lo(0xdd44),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1095
.L1389:

	! block 1096
.L1388:

	! block 1097
.L1390:
	addx	%g0,0,%l0
	st	%l0,[%fp-788]
	ld	[%fp-788],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1098
.L1391:

!  840	         break;

	ba	.L29
	nop

	! block 1099
.L1392:
.L1393:

!  841	      case GL_NORMAL_ARRAY_STRIDE:
!  842	         *params = INT_TO_BOOL(ctx->Array.NormalStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd48),%l1
	or	%l1,%lo(0xdd48),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1100
.L1395:

	! block 1101
.L1394:

	! block 1102
.L1396:
	addx	%g0,0,%l0
	st	%l0,[%fp-792]
	ld	[%fp-792],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1103
.L1397:

!  843	         break;

	ba	.L29
	nop

	! block 1104
.L1398:
.L1399:

!  844	      case GL_NORMAL_ARRAY_COUNT_EXT:
!  845	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1105
.L1400:

!  846	         break;

	ba	.L29
	nop

	! block 1106
.L1401:
.L1402:

!  847	      case GL_COLOR_ARRAY_SIZE:
!  848	         *params = INT_TO_BOOL(ctx->Array.ColorSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd58),%l1
	or	%l1,%lo(0xdd58),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1107
.L1404:

	! block 1108
.L1403:

	! block 1109
.L1405:
	addx	%g0,0,%l0
	st	%l0,[%fp-796]
	ld	[%fp-796],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1110
.L1406:

!  849	         break;

	ba	.L29
	nop

	! block 1111
.L1407:
.L1408:

!  850	      case GL_COLOR_ARRAY_TYPE:
!  851	         *params = ENUM_TO_BOOL(ctx->Array.ColorType);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd5c),%l1
	or	%l1,%lo(0xdd5c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1112
.L1410:

	! block 1113
.L1409:

	! block 1114
.L1411:
	addx	%g0,0,%l0
	st	%l0,[%fp-800]
	ld	[%fp-800],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1115
.L1412:

!  852	         break;

	ba	.L29
	nop

	! block 1116
.L1413:
.L1414:

!  853	      case GL_COLOR_ARRAY_STRIDE:
!  854	         *params = INT_TO_BOOL(ctx->Array.ColorStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd60),%l1
	or	%l1,%lo(0xdd60),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1117
.L1416:

	! block 1118
.L1415:

	! block 1119
.L1417:
	addx	%g0,0,%l0
	st	%l0,[%fp-804]
	ld	[%fp-804],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1120
.L1418:

!  855	         break;

	ba	.L29
	nop

	! block 1121
.L1419:
.L1420:

!  856	      case GL_COLOR_ARRAY_COUNT_EXT:
!  857	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1122
.L1421:

!  858	         break;

	ba	.L29
	nop

	! block 1123
.L1422:
.L1423:

!  859	      case GL_INDEX_ARRAY_TYPE:
!  860	         *params = ENUM_TO_BOOL(ctx->Array.IndexType);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd70),%l1
	or	%l1,%lo(0xdd70),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1124
.L1425:

	! block 1125
.L1424:

	! block 1126
.L1426:
	addx	%g0,0,%l0
	st	%l0,[%fp-808]
	ld	[%fp-808],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1127
.L1427:

!  861	         break;

	ba	.L29
	nop

	! block 1128
.L1428:
.L1429:

!  862	      case GL_INDEX_ARRAY_STRIDE:
!  863	         *params = INT_TO_BOOL(ctx->Array.IndexStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd74),%l1
	or	%l1,%lo(0xdd74),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1129
.L1431:

	! block 1130
.L1430:

	! block 1131
.L1432:
	addx	%g0,0,%l0
	st	%l0,[%fp-812]
	ld	[%fp-812],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1132
.L1433:

!  864	         break;

	ba	.L29
	nop

	! block 1133
.L1434:
.L1435:

!  865	      case GL_INDEX_ARRAY_COUNT_EXT:
!  866	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1134
.L1436:

!  867	         break;

	ba	.L29
	nop

	! block 1135
.L1437:
.L1438:

!  868	      case GL_TEXTURE_COORD_ARRAY_SIZE:
!  869	         *params = INT_TO_BOOL(ctx->Array.TexCoordSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd84),%l1
	or	%l1,%lo(0xdd84),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1136
.L1440:

	! block 1137
.L1439:

	! block 1138
.L1441:
	addx	%g0,0,%l0
	st	%l0,[%fp-816]
	ld	[%fp-816],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1139
.L1442:

!  870	         break;

	ba	.L29
	nop

	! block 1140
.L1443:
.L1444:

!  871	      case GL_TEXTURE_COORD_ARRAY_TYPE:
!  872	         *params = ENUM_TO_BOOL(ctx->Array.TexCoordType);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd88),%l1
	or	%l1,%lo(0xdd88),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1141
.L1446:

	! block 1142
.L1445:

	! block 1143
.L1447:
	addx	%g0,0,%l0
	st	%l0,[%fp-820]
	ld	[%fp-820],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1144
.L1448:

!  873	         break;

	ba	.L29
	nop

	! block 1145
.L1449:
.L1450:

!  874	      case GL_TEXTURE_COORD_ARRAY_STRIDE:
!  875	         *params = INT_TO_BOOL(ctx->Array.TexCoordStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd8c),%l1
	or	%l1,%lo(0xdd8c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1146
.L1452:

	! block 1147
.L1451:

	! block 1148
.L1453:
	addx	%g0,0,%l0
	st	%l0,[%fp-824]
	ld	[%fp-824],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1149
.L1454:

!  876	         break;

	ba	.L29
	nop

	! block 1150
.L1455:
.L1456:

!  877	      case GL_TEXTURE_COORD_ARRAY_COUNT_EXT:
!  878	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1151
.L1457:

!  879	         break;

	ba	.L29
	nop

	! block 1152
.L1458:
.L1459:

!  880	      case GL_EDGE_FLAG_ARRAY_STRIDE:
!  881	         *params = INT_TO_BOOL(ctx->Array.EdgeFlagStride);

	ld	[%fp+68],%l0
	sethi	%hi(0xdd9c),%l1
	or	%l1,%lo(0xdd9c),%l1
	ld	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 1153
.L1461:

	! block 1154
.L1460:

	! block 1155
.L1462:
	addx	%g0,0,%l0
	st	%l0,[%fp-828]
	ld	[%fp-828],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1156
.L1463:

!  882	         break;

	ba	.L29
	nop

	! block 1157
.L1464:
.L1465:

!  883	      case GL_EDGE_FLAG_ARRAY_EXT:
!  884	         *params = INT_TO_BOOL(0);

	ld	[%fp+76],%l0
	stb	%g0,[%l0+0]

	! block 1158
.L1466:

!  885	         break;

	ba	.L29
	nop

	! block 1159
.L1467:
.L1468:

!  886	      case GL_TEXTURE_BINDING_1D:
!  887	         *params = INT_TO_BOOL(ctx->Texture.Current1D->Name);

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l0
	cmp	%g0,%l0

	! block 1160
.L1470:

	! block 1161
.L1469:

	! block 1162
.L1471:
	addx	%g0,0,%l0
	st	%l0,[%fp-832]
	ld	[%fp-832],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1163
.L1472:

!  888	          break;

	ba	.L29
	nop

	! block 1164
.L1473:
.L1474:

!  889	      case GL_TEXTURE_BINDING_2D:
!  890	         *params = INT_TO_BOOL(ctx->Texture.Current2D->Name);

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l0
	cmp	%g0,%l0

	! block 1165
.L1476:

	! block 1166
.L1475:

	! block 1167
.L1477:
	addx	%g0,0,%l0
	st	%l0,[%fp-836]
	ld	[%fp-836],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1168
.L1478:

!  891	          break;

	ba	.L29
	nop

	! block 1169
.L1479:
.L1480:

!  892	      case GL_TEXTURE_3D_BINDING_EXT:
!  893	         *params = INT_TO_BOOL(ctx->Texture.Current2D->Name);

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l0
	cmp	%g0,%l0

	! block 1170
.L1482:

	! block 1171
.L1481:

	! block 1172
.L1483:
	addx	%g0,0,%l0
	st	%l0,[%fp-840]
	ld	[%fp-840],%l1
	ld	[%fp+76],%l0
	stb	%l1,[%l0+0]

	! block 1173
.L1484:

!  894	          break;

	ba	.L29
	nop

	! block 1174
.L1485:
.L1486:

!  895	      default:
!  896	         gl_error( ctx, GL_INVALID_ENUM, "glGetBooleanv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1487),%l1
	or	%l1,%lo(.L1487),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 1175
.L1488:
.L1489:
	ba	.L29
	nop

	! block 1176
.L30:
.L1490:
	ld	[%fp+72],%l2
	cmp	%l2,3344
	bge	.L_y0
	nop

	! block 1177
	cmp	%l2,2976
	bge	.L_y1
	nop

	! block 1178
	cmp	%l2,2896
	bge	.L_y2
	nop

	! block 1179
	cmp	%l2,2848
	bge	.L_y3
	nop

	! block 1180
	sub	%l2,2816,%l0
	cmp	%l0,19
	bgu	.L1485
	nop

	! block 1181
	sll	%l0,2,%l1
	sethi	%hi(.L_y4-80),%l0
	or	%l0,%lo(.L_y4-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1182
.L_y3:
	cmp	%l2,2880
	bge	.L_y5
	nop

	! block 1183
	cmp	%l2,2864
	bge	.L_y6
	nop

	! block 1184
	sub	%l2,2848,%l0
	cmp	%l0,6
	bgu	.L1485
	nop

	! block 1185
	sll	%l0,2,%l1
	sethi	%hi(.L_y7-28),%l0
	or	%l0,%lo(.L_y7-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1186
.L_y6:
	sub	%l2,2864,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1187
	sll	%l0,2,%l1
	sethi	%hi(.L_y8-16),%l0
	or	%l0,%lo(.L_y8-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1188
.L_y5:
	sub	%l2,2880,%l0
	cmp	%l0,6
	bgu	.L1485
	nop

	! block 1189
	sll	%l0,2,%l1
	sethi	%hi(.L_y9-28),%l0
	or	%l0,%lo(.L_y9-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1190
.L_y2:
	cmp	%l2,2928
	bge	.L_y10
	nop

	! block 1191
	cmp	%l2,2912
	bge	.L_y11
	nop

	! block 1192
	sub	%l2,2896,%l0
	cmp	%l0,7
	bgu	.L1485
	nop

	! block 1193
	sll	%l0,2,%l1
	sethi	%hi(.L_y12-32),%l0
	or	%l0,%lo(.L_y12-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1194
.L_y11:
	sub	%l2,2912,%l0
	cmp	%l0,6
	bgu	.L1485
	nop

	! block 1195
	sll	%l0,2,%l1
	sethi	%hi(.L_y13-28),%l0
	or	%l0,%lo(.L_y13-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1196
.L_y10:
	cmp	%l2,2960
	bge	.L_y14
	nop

	! block 1197
	cmp	%l2,2944
	bge	.L_y15
	nop

	! block 1198
	sub	%l2,2928,%l0
	cmp	%l0,4
	bgu	.L1485
	nop

	! block 1199
	sll	%l0,2,%l1
	sethi	%hi(.L_y16-20),%l0
	or	%l0,%lo(.L_y16-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1200
.L_y15:
	be	.L43
	nop

	! block 1201
	ba	.L1485
	nop

	! block 1202
.L_y14:
	sub	%l2,2960,%l0
	cmp	%l0,8
	bgu	.L1485
	nop

	! block 1203
	sll	%l0,2,%l1
	sethi	%hi(.L_y17-36),%l0
	or	%l0,%lo(.L_y17-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1204
.L_y1:
	cmp	%l2,3136
	bge	.L_y18
	nop

	! block 1205
	cmp	%l2,3056
	bge	.L_y19
	nop

	! block 1206
	cmp	%l2,2992
	bge	.L_y20
	nop

	! block 1207
	sub	%l2,2976,%l0
	cmp	%l0,8
	bgu	.L1485
	nop

	! block 1208
	sll	%l0,2,%l1
	sethi	%hi(.L_y21-36),%l0
	or	%l0,%lo(.L_y21-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1209
.L_y20:
	cmp	%l2,3024
	bge	.L_y22
	nop

	! block 1210
	cmp	%l2,3008
	bge	.L_y23
	nop

	! block 1211
	cmp	%l2,2992
	be	.L94
	nop

	! block 1212
	cmp	%l2,2993
	be	.L163
	nop

	! block 1213
	ba	.L1485
	nop

	! block 1214
.L_y23:
	sub	%l2,3008,%l0
	cmp	%l0,2
	bgu	.L1485
	nop

	! block 1215
	sll	%l0,2,%l1
	sethi	%hi(.L_y24-12),%l0
	or	%l0,%lo(.L_y24-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1216
.L_y22:
	cmp	%l2,3040
	bge	.L_y25
	nop

	! block 1217
	cmp	%l2,3024
	be	.L408
	nop

	! block 1218
	ba	.L1485
	nop

	! block 1219
.L_y25:
	sub	%l2,3040,%l0
	cmp	%l0,2
	bgu	.L1485
	nop

	! block 1220
	sll	%l0,2,%l1
	sethi	%hi(.L_y26-12),%l0
	or	%l0,%lo(.L_y26-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1221
.L_y19:
	cmp	%l2,3104
	bge	.L_y27
	nop

	! block 1222
	cmp	%l2,3072
	bge	.L_y28
	nop

	! block 1223
	sub	%l2,3056,%l0
	cmp	%l0,2
	bgu	.L1485
	nop

	! block 1224
	sll	%l0,2,%l1
	sethi	%hi(.L_y29-12),%l0
	or	%l0,%lo(.L_y29-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1225
.L_y28:
	cmp	%l2,3088
	bge	.L_y30
	nop

	! block 1226
	sub	%l2,3072,%l0
	cmp	%l0,2
	bgu	.L1485
	nop

	! block 1227
	sll	%l0,2,%l1
	sethi	%hi(.L_y31-12),%l0
	or	%l0,%lo(.L_y31-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1228
.L_y30:
	be	.L1115
	nop

	! block 1229
	cmp	%l2,3089
	be	.L1133
	nop

	! block 1230
	ba	.L1485
	nop

	! block 1231
.L_y27:
	cmp	%l2,3120
	bge	.L_y32
	nop

	! block 1232
	sub	%l2,3104,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1233
	sll	%l0,2,%l1
	sethi	%hi(.L_y33-16),%l0
	or	%l0,%lo(.L_y33-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1234
.L_y32:
	sub	%l2,3120,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1235
	sll	%l0,2,%l1
	sethi	%hi(.L_y34-16),%l0
	or	%l0,%lo(.L_y34-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1236
.L_y18:
	cmp	%l2,3312
	bge	.L_y35
	nop

	! block 1237
	cmp	%l2,3248
	bge	.L_y36
	nop

	! block 1238
	cmp	%l2,3168
	bge	.L_y37
	nop

	! block 1239
	cmp	%l2,3152
	bge	.L_y38
	nop

	! block 1240
	cmp	%l2,3136
	be	.L1106
	nop

	! block 1241
	ba	.L1485
	nop

	! block 1242
.L_y38:
	sub	%l2,3152,%l0
	cmp	%l0,4
	bgu	.L1485
	nop

	! block 1243
	sll	%l0,2,%l1
	sethi	%hi(.L_y39-20),%l0
	or	%l0,%lo(.L_y39-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1244
.L_y37:
	sub	%l2,3168,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1245
	sll	%l0,2,%l1
	sethi	%hi(.L_y40-16),%l0
	or	%l0,%lo(.L_y40-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1246
.L_y36:
	sub	%l2,3248,%l0
	cmp	%l0,9
	bgu	.L1485
	nop

	! block 1247
	sll	%l0,2,%l1
	sethi	%hi(.L_y41-40),%l0
	or	%l0,%lo(.L_y41-40),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1248
.L_y35:
	cmp	%l2,3328
	bge	.L_y42
	nop

	! block 1249
	sub	%l2,3312,%l0
	cmp	%l0,5
	bgu	.L1485
	nop

	! block 1250
	sll	%l0,2,%l1
	sethi	%hi(.L_y43-24),%l0
	or	%l0,%lo(.L_y43-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1251
.L_y42:
	sub	%l2,3328,%l0
	cmp	%l0,5
	bgu	.L1485
	nop

	! block 1252
	sll	%l0,2,%l1
	sethi	%hi(.L_y44-24),%l0
	or	%l0,%lo(.L_y44-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1253
.L_y0:
	cmp	%l2,3536
	bge	.L_y45
	nop

	! block 1254
	cmp	%l2,3408
	bge	.L_y46
	nop

	! block 1255
	cmp	%l2,3376
	bge	.L_y47
	nop

	! block 1256
	sub	%l2,3344,%l0
	cmp	%l0,15
	bgu	.L1485
	nop

	! block 1257
	sll	%l0,2,%l1
	sethi	%hi(.L_y48-64),%l0
	or	%l0,%lo(.L_y48-64),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1258
.L_y47:
	sub	%l2,3376,%l0
	cmp	%l0,11
	bgu	.L1485
	nop

	! block 1259
	sll	%l0,2,%l1
	sethi	%hi(.L_y49-48),%l0
	or	%l0,%lo(.L_y49-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1260
.L_y46:
	cmp	%l2,3472
	bge	.L_y50
	nop

	! block 1261
	cmp	%l2,3440
	bge	.L_y51
	nop

	! block 1262
	sub	%l2,3408,%l0
	cmp	%l0,11
	bgu	.L1485
	nop

	! block 1263
	sll	%l0,2,%l1
	sethi	%hi(.L_y52-48),%l0
	or	%l0,%lo(.L_y52-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1264
.L_y51:
	be	.L843
	nop

	! block 1265
	cmp	%l2,3456
	be	.L100
	nop

	! block 1266
	ba	.L1485
	nop

	! block 1267
.L_y50:
	cmp	%l2,3504
	bge	.L_y53
	nop

	! block 1268
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L1485
	nop

	! block 1269
	sll	%l0,2,%l1
	sethi	%hi(.L_y54-36),%l0
	or	%l0,%lo(.L_y54-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1270
.L_y53:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L1485
	nop

	! block 1271
	sll	%l0,2,%l1
	sethi	%hi(.L_y55-36),%l0
	or	%l0,%lo(.L_y55-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1272
.L_y45:
	sethi	%hi(0x8068),%l0
	or	%l0,%lo(0x8068),%l0
	cmp	%l2,%l0
	bge	.L_y56
	nop

	! block 1273
	sethi	%hi(0x4000),%l0
	cmp	%l2,%l0
	bge	.L_y57
	nop

	! block 1274
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	bge	.L_y58
	nop

	! block 1275
	cmp	%l2,3552
	bge	.L_y59
	nop

	! block 1276
	sub	%l2,3536,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1277
	sll	%l0,2,%l1
	sethi	%hi(.L_y60-16),%l0
	or	%l0,%lo(.L_y60-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1278
.L_y59:
	cmp	%l2,3569
	bge	.L_y61
	nop

	! block 1279
	cmp	%l2,3552
	be	.L1208
	nop

	! block 1280
	cmp	%l2,3553
	be	.L1214
	nop

	! block 1281
	ba	.L1485
	nop

	! block 1282
.L_y61:
	be	.L423
	nop

	! block 1283
	cmp	%l2,3570
	be	.L429
	nop

	! block 1284
	ba	.L1485
	nop

	! block 1285
.L_y58:
	sethi	%hi(0x3000),%l0
	cmp	%l2,%l0
	bge	.L_y62
	nop

	! block 1286
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	bge	.L_y63
	nop

	! block 1287
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	be	.L1244
	nop

	! block 1288
	sethi	%hi(0x2201),%l0
	or	%l0,%lo(0x2201),%l0
	cmp	%l2,%l0
	be	.L1226
	nop

	! block 1289
	ba	.L1485
	nop

	! block 1290
.L_y63:
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	be	.L1039
	nop

	! block 1291
	ba	.L1485
	nop

	! block 1292
.L_y62:
	sethi	%hi(0x3000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L1485
	nop

	! block 1293
	sll	%l0,2,%l1
	sethi	%hi(.L_y64-24),%l0
	or	%l0,%lo(.L_y64-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1294
.L_y57:
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	bge	.L_y65
	nop

	! block 1295
	sethi	%hi(0x4000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L1485
	nop

	! block 1296
	sll	%l0,2,%l1
	sethi	%hi(.L_y66-32),%l0
	or	%l0,%lo(.L_y66-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1297
.L_y65:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	bge	.L_y67
	nop

	! block 1298
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	be	.L127
	nop

	! block 1299
	sethi	%hi(0x8009),%l0
	or	%l0,%lo(0x8009),%l0
	cmp	%l2,%l0
	be	.L121
	nop

	! block 1300
	ba	.L1485
	nop

	! block 1301
.L_y67:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	be	.L1033
	nop

	! block 1302
	sethi	%hi(0x8039),%l0
	or	%l0,%lo(0x8039),%l0
	cmp	%l2,%l0
	be	.L1027
	nop

	! block 1303
	ba	.L1485
	nop

	! block 1304
.L_y56:
	sethi	%hi(0x8079),%l0
	or	%l0,%lo(0x8079),%l0
	cmp	%l2,%l0
	bge	.L_y68
	nop

	! block 1305
	sethi	%hi(0x8068),%l1
	or	%l1,%lo(0x8068),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L1485
	nop

	! block 1306
	sll	%l0,2,%l1
	sethi	%hi(.L_y69-32),%l0
	or	%l0,%lo(.L_y69-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1307
.L_y68:
	sethi	%hi(0x8126),%l0
	or	%l0,%lo(0x8126),%l0
	cmp	%l2,%l0
	bge	.L_y70
	nop

	! block 1308
	sethi	%hi(0x8079),%l1
	or	%l1,%lo(0x8079),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,19
	bgu	.L1485
	nop

	! block 1309
	sll	%l0,2,%l1
	sethi	%hi(.L_y71-80),%l0
	or	%l0,%lo(.L_y71-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1310
.L_y70:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	bge	.L_y72
	nop

	! block 1311
	sethi	%hi(0x8126),%l1
	or	%l1,%lo(0x8126),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,3
	bgu	.L1485
	nop

	! block 1312
	sll	%l0,2,%l1
	sethi	%hi(.L_y73-16),%l0
	or	%l0,%lo(.L_y73-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 1313
.L_y72:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	be	.L1142
	nop

	! block 1314
	ba	.L1485
	nop

	! block 1315
.L1491:
.L29:
.L1492:

	! block 1316
.L1493:
.L1494:
.L12:
	jmp	%i7+8
	restore
	.size	gl_GetBooleanv,(.-gl_GetBooleanv)

	.word	.L237
	.word	.L255
	.word	.L261
	.word	.L344
	.word	.L275
	.word	.L299
	.word	.L323
	.word	.L305
	.word	.L341
	.word	.L293
	.word	.L1485
	.word	.L1485
	.word	.L1485
	.word	.L1485
	.word	.L1485
	.word	.L1485
	.word	.L976
	.word	.L954
	.word	.L966
	.word	.L960
.L_y4:
	.word	.L589
	.word	.L613
	.word	.L625
	.word	.L619
	.word	.L598
	.word	.L601
	.word	.L607
.L_y7:
	.word	.L647
	.word	.L793
	.word	.L635
	.word	.L641
.L_y8:
	.word	.L1017
	.word	.L1045
	.word	.L1054
	.word	.L420
	.word	.L228
	.word	.L231
	.word	.L492
.L_y9:
	.word	.L562
	.word	.L583
	.word	.L586
	.word	.L565
	.word	.L1136
	.word	.L198
	.word	.L204
	.word	.L195
.L_y12:
	.word	.L435
	.word	.L474
	.word	.L456
	.word	.L486
	.word	.L462
	.word	.L480
	.word	.L438
.L_y13:
	.word	.L386
	.word	.L402
	.word	.L405
	.word	.L374
	.word	.L380
.L_y16:
	.word	.L1187
	.word	.L1151
	.word	.L1163
	.word	.L1190
	.word	.L1157
	.word	.L1169
	.word	.L1175
	.word	.L1181
	.word	.L1196
.L_y17:
	.word	.L772
	.word	.L849
	.word	.L1335
	.word	.L837
	.word	.L1076
	.word	.L1293
	.word	.L818
	.word	.L1057
	.word	.L1274
.L_y21:
	.word	.L79
	.word	.L82
	.word	.L88
.L_y24:
	.word	.L109
	.word	.L115
	.word	.L106
.L_y26:
	.word	.L662
	.word	.L656
	.word	.L659
.L_y29:
	.word	.L103
	.word	.L414
	.word	.L1082
.L_y31:
	.word	.L522
	.word	.L546
	.word	.L177
	.word	.L210
.L_y33:
	.word	.L528
	.word	.L1112
	.word	.L411
	.word	.L1202
.L_y34:
	.word	.L888
	.word	.L979
	.word	.L592
	.word	.L1048
	.word	.L468
.L_y39:
	.word	.L1250
	.word	.L1256
	.word	.L1262
	.word	.L1268
.L_y40:
	.word	.L930
	.word	.L948
	.word	.L936
	.word	.L924
	.word	.L918
	.word	.L912
	.word	.L942
	.word	.L906
	.word	.L900
	.word	.L894
.L_y41:
	.word	.L1326
	.word	.L1305
	.word	.L1308
	.word	.L1320
	.word	.L1314
	.word	.L1299
.L_y43:
	.word	.L879
	.word	.L858
	.word	.L861
	.word	.L873
	.word	.L867
	.word	.L852
.L_y44:
	.word	.L766
	.word	.L769
	.word	.L540
	.word	.L534
	.word	.L1100
	.word	.L1088
	.word	.L1353
	.word	.L1359
	.word	.L510
	.word	.L498
	.word	.L157
	.word	.L145
	.word	.L73
	.word	.L61
	.word	.L396
	.word	.L362
.L_y48:
	.word	.L787
	.word	.L790
	.word	.L784
	.word	.L808
	.word	.L802
	.word	.L778
	.word	.L796
	.word	.L799
	.word	.L805
	.word	.L811
	.word	.L814
	.word	.L781
.L_y49:
	.word	.L1205
	.word	.L516
	.word	.L1094
	.word	.L504
	.word	.L151
	.word	.L67
	.word	.L368
	.word	.L1145
	.word	.L34
	.word	.L35
	.word	.L36
	.word	.L37
.L_y52:
	.word	.L668
	.word	.L687
	.word	.L690
	.word	.L693
	.word	.L696
	.word	.L699
	.word	.L702
	.word	.L705
	.word	.L708
.L_y54:
	.word	.L711
	.word	.L742
	.word	.L745
	.word	.L748
	.word	.L751
	.word	.L754
	.word	.L757
	.word	.L760
	.word	.L763
.L_y55:
	.word	.L671
	.word	.L681
	.word	.L714
	.word	.L732
.L_y60:
	.word	.L169
	.word	.L170
	.word	.L171
	.word	.L172
	.word	.L173
	.word	.L174
.L_y64:
	.word	.L552
	.word	.L553
	.word	.L554
	.word	.L555
	.word	.L556
	.word	.L557
	.word	.L558
	.word	.L559
.L_y66:
	.word	.L1467
	.word	.L1473
	.word	.L1479
	.word	.L882
	.word	.L885
	.word	.L1329
	.word	.L1332
	.word	.L1220
.L_y69:
	.word	.L1464
	.word	.L1365
	.word	.L1371
	.word	.L1377
	.word	.L1383
	.word	.L1386
	.word	.L1392
	.word	.L1398
	.word	.L1401
	.word	.L1407
	.word	.L1413
	.word	.L1419
	.word	.L1422
	.word	.L1428
	.word	.L1434
	.word	.L1437
	.word	.L1443
	.word	.L1449
	.word	.L1455
	.word	.L1458
.L_y71:
	.word	.L985
	.word	.L991
	.word	.L997
	.word	.L1003
.L_y73:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetDoublev
	.type	gl_GetDoublev,#function
gl_GetDoublev:
	save	%sp,-224,%sp

	! block 1
.L1497:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L1498:
.L1500:
.L1502:

! File get.c:
!  897	   }
!  898	}
!  899	
!  903	void gl_GetDoublev( GLcontext *ctx, GLenum pname, GLdouble *params )
!  904	{
!  905	   GLuint i;
!  906	
!  907	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1501
	nop

	! block 3
.L1503:
.L1504:
.L1505:
.L1506:

!  908	      gl_error( ctx, GL_INVALID_OPERATION, "glGetDoublev" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1507),%l1
	or	%l1,%lo(.L1507),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1508:

!  909	      return;

	ba	.L1496
	nop

	! block 5
.L1509:
.L1510:
.L1501:
.L1511:
.L1512:
.L1515:

!  910	   }
!  911	
!  912	   switch (pname) {

	ba	.L1514
	nop

	! block 6
.L1516:
.L1517:
.L1518:
.L1519:
.L1520:
.L1521:
.L1522:

!  913	      case GL_ACCUM_RED_BITS:
!  914	      case GL_ACCUM_GREEN_BITS:
!  915	      case GL_ACCUM_BLUE_BITS:
!  916	      case GL_ACCUM_ALPHA_BITS:
!  917	         *params = (GLdouble) ctx->Visual->AccumBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+60],%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 7
.L1523:

!  918	         break;

	ba	.L1513
	nop

	! block 8
.L1524:
.L1525:

!  919	      case GL_ACCUM_CLEAR_VALUE:
!  920	         params[0] = (GLdouble) ctx->Accum.ClearColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 9
.L1526:

!  921	         params[1] = (GLdouble) ctx->Accum.ClearColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 10
.L1527:

!  922	         params[2] = (GLdouble) ctx->Accum.ClearColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 11
.L1528:

!  923	         params[3] = (GLdouble) ctx->Accum.ClearColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 12
.L1529:

!  924	         break;

	ba	.L1513
	nop

	! block 13
.L1530:
.L1531:

!  925	      case GL_ALPHA_BIAS:
!  926	         *params = (GLdouble) ctx->Pixel.AlphaBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 14
.L1532:

!  927	         break;

	ba	.L1513
	nop

	! block 15
.L1533:
.L1534:

!  928	      case GL_ALPHA_BITS:
!  929	         *params = (GLdouble) ctx->Visual->AlphaBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-116]
	ld	[%fp-116],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 16
.L1535:

!  930	         break;

	ba	.L1513
	nop

	! block 17
.L1536:
.L1537:

!  931	      case GL_ALPHA_SCALE:
!  932	         *params = (GLdouble) ctx->Pixel.AlphaScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 18
.L1538:

!  933	         break;

	ba	.L1513
	nop

	! block 19
.L1539:
.L1540:

!  934	      case GL_ALPHA_TEST:
!  935	         *params = (GLdouble) ctx->Color.AlphaEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea0),%l1
	or	%l1,%lo(0x1ea0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 20
.L1541:

!  936	         break;

	ba	.L1513
	nop

	! block 21
.L1542:
.L1543:

!  937	      case GL_ALPHA_TEST_FUNC:
!  938	         *params = (GLdouble) ctx->Color.AlphaFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea4),%l1
	or	%l1,%lo(0x1ea4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 22
.L1544:

!  939	         break;

	ba	.L1513
	nop

	! block 23
.L1545:
.L1546:

!  940	      case GL_ALPHA_TEST_REF:
!  941	         *params = (GLdouble) ctx->Color.AlphaRef;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea8),%l1
	or	%l1,%lo(0x1ea8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 24
.L1547:

!  942	         break;

	ba	.L1513
	nop

	! block 25
.L1548:
.L1549:

!  943	      case GL_ATTRIB_STACK_DEPTH:
!  944	         *params = (GLdouble ) ctx->AttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e28),%l1
	or	%l1,%lo(0x1e28),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 26
.L1550:

!  945	         break;

	ba	.L1513
	nop

	! block 27
.L1551:
.L1552:

!  946	      case GL_AUTO_NORMAL:
!  947	         *params = (GLdouble) ctx->Eval.AutoNormal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 28
.L1553:

!  948	         break;

	ba	.L1513
	nop

	! block 29
.L1554:
.L1555:

!  949	      case GL_AUX_BUFFERS:
!  950	         *params = (GLdouble) NUM_AUX_BUFFERS;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 30
.L1556:

!  951	         break;

	ba	.L1513
	nop

	! block 31
.L1557:
.L1558:

!  952	      case GL_BLEND:
!  953	         *params = (GLdouble) ctx->Color.BlendEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ead),%l1
	or	%l1,%lo(0x1ead),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 32
.L1559:

!  954	         break;

	ba	.L1513
	nop

	! block 33
.L1560:
.L1561:

!  955	      case GL_BLEND_DST:
!  956	         *params = (GLdouble) ctx->Color.BlendDst;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb4),%l1
	or	%l1,%lo(0x1eb4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 34
.L1562:

!  957	         break;

	ba	.L1513
	nop

	! block 35
.L1563:
.L1564:

!  958	      case GL_BLEND_SRC:
!  959	         *params = (GLdouble) ctx->Color.BlendSrc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb0),%l1
	or	%l1,%lo(0x1eb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 36
.L1565:

!  960	         break;

	ba	.L1513
	nop

	! block 37
.L1566:
.L1567:

!  961	      case GL_BLEND_EQUATION_EXT:
!  962		 *params = (GLdouble) ctx->Color.BlendEquation;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb8),%l1
	or	%l1,%lo(0x1eb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 38
.L1568:

!  963		 break;

	ba	.L1513
	nop

	! block 39
.L1569:
.L1570:

!  964	      case GL_BLEND_COLOR_EXT:
!  965		 params[0] = (GLdouble) ctx->Color.BlendColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ebc),%l1
	or	%l1,%lo(0x1ebc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 40
.L1571:

!  966		 params[1] = (GLdouble) ctx->Color.BlendColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec0),%l1
	or	%l1,%lo(0x1ec0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 41
.L1572:

!  967		 params[2] = (GLdouble) ctx->Color.BlendColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec4),%l1
	or	%l1,%lo(0x1ec4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 42
.L1573:

!  968		 params[3] = (GLdouble) ctx->Color.BlendColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec8),%l1
	or	%l1,%lo(0x1ec8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 43
.L1574:

!  969		 break;

	ba	.L1513
	nop

	! block 44
.L1575:
.L1576:

!  970	      case GL_BLUE_BIAS:
!  971	         *params = (GLdouble) ctx->Pixel.BlueBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 45
.L1577:

!  972	         break;

	ba	.L1513
	nop

	! block 46
.L1578:
.L1579:

!  973	      case GL_BLUE_BITS:
!  974	         *params = (GLdouble) ctx->Visual->BlueBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+48],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 47
.L1580:

!  975	         break;

	ba	.L1513
	nop

	! block 48
.L1581:
.L1582:

!  976	      case GL_BLUE_SCALE:
!  977	         *params = (GLdouble) ctx->Pixel.BlueScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 49
.L1583:

!  978	         break;

	ba	.L1513
	nop

	! block 50
.L1584:
.L1585:

!  979	      case GL_CLIENT_ATTRIB_STACK_DEPTH:
!  980	         *params = (GLdouble) ctx->ClientAttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdce8),%l1
	or	%l1,%lo(0xdce8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 51
.L1586:

!  981	         break;

	ba	.L1513
	nop

	! block 52
.L1587:
.L1588:
.L1589:
.L1590:
.L1591:
.L1592:
.L1593:

!  982	      case GL_CLIP_PLANE0:
!  983	      case GL_CLIP_PLANE1:
!  984	      case GL_CLIP_PLANE2:
!  985	      case GL_CLIP_PLANE3:
!  986	      case GL_CLIP_PLANE4:
!  987	      case GL_CLIP_PLANE5:
!  988	         *params = (GLdouble) ctx->Transform.ClipEnabled[pname-GL_CLIP_PLANE0];

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb0),%l1
	or	%l1,%lo(0xdcb0),%l1
	add	%l0,%l1,%l0
	ld	[%fp+72],%l1
	add	%l0,%l1,%l0
	sethi	%hi(0x3000),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 53
.L1594:

!  989	         break;

	ba	.L1513
	nop

	! block 54
.L1595:
.L1596:

!  990	      case GL_COLOR_CLEAR_VALUE:
!  991	         params[0] = (GLdouble) ctx->Color.ClearColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e80),%l1
	or	%l1,%lo(0x1e80),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 55
.L1597:

!  992	         params[1] = (GLdouble) ctx->Color.ClearColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e84),%l1
	or	%l1,%lo(0x1e84),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 56
.L1598:

!  993	         params[2] = (GLdouble) ctx->Color.ClearColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e88),%l1
	or	%l1,%lo(0x1e88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 57
.L1599:

!  994	         params[3] = (GLdouble) ctx->Color.ClearColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e8c),%l1
	or	%l1,%lo(0x1e8c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 58
.L1600:

!  995	         break;

	ba	.L1513
	nop

	! block 59
.L1601:
.L1602:

!  996	      case GL_COLOR_MATERIAL:
!  997	         *params = (GLdouble) ctx->Light.ColorMaterialEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xaddc),%l1
	or	%l1,%lo(0xaddc),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 60
.L1603:

!  998	         break;

	ba	.L1513
	nop

	! block 61
.L1604:
.L1605:

!  999	      case GL_COLOR_MATERIAL_FACE:
! 1000	         *params = (GLdouble) ctx->Light.ColorMaterialFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd0),%l1
	or	%l1,%lo(0xadd0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 62
.L1606:

! 1001	         break;

	ba	.L1513
	nop

	! block 63
.L1607:
.L1608:

! 1002	      case GL_COLOR_MATERIAL_PARAMETER:
! 1003	         *params = (GLdouble) ctx->Light.ColorMaterialMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd4),%l1
	or	%l1,%lo(0xadd4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 64
.L1609:

! 1004	         break;

	ba	.L1513
	nop

	! block 65
.L1610:
.L1611:

! 1005	      case GL_COLOR_WRITEMASK:
! 1006	         params[0] = (ctx->Color.ColorMask & 8) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,8,%l0
	be	.L1612
	nop

	! block 66
.L1613:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L1614
	std	%f4,[%fp-16]

	! block 67
.L1612:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-16]

	! block 68
.L1614:
	ldd	[%fp-16],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 69
.L1615:

! 1007	         params[1] = (ctx->Color.ColorMask & 4) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L1616
	nop

	! block 70
.L1617:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L1618
	std	%f4,[%fp-24]

	! block 71
.L1616:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-24]

	! block 72
.L1618:
	ldd	[%fp-24],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 73
.L1619:

! 1008	         params[2] = (ctx->Color.ColorMask & 2) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L1620
	nop

	! block 74
.L1621:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L1622
	std	%f4,[%fp-32]

	! block 75
.L1620:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-32]

	! block 76
.L1622:
	ldd	[%fp-32],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 77
.L1623:

! 1009	         params[3] = (ctx->Color.ColorMask & 1) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L1624
	nop

	! block 78
.L1625:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L1626
	std	%f4,[%fp-40]

	! block 79
.L1624:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-40]

	! block 80
.L1626:
	ldd	[%fp-40],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 81
.L1627:

! 1010	         break;

	ba	.L1513
	nop

	! block 82
.L1628:
.L1629:

! 1011	      case GL_CULL_FACE:
! 1012	         *params = (GLdouble) ctx->Polygon.CullFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6ad),%l1
	or	%l1,%lo(0xd6ad),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 83
.L1630:

! 1013	         break;

	ba	.L1513
	nop

	! block 84
.L1631:
.L1632:

! 1014	      case GL_CULL_FACE_MODE:
! 1015	         *params = (GLdouble) ctx->Polygon.CullFaceMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b0),%l1
	or	%l1,%lo(0xd6b0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 85
.L1633:

! 1016	         break;

	ba	.L1513
	nop

	! block 86
.L1634:
.L1635:

! 1017	      case GL_CURRENT_COLOR:
! 1018	         params[0] = ctx->Current.ByteColor[0] * ctx->Visual->InvRedScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l1
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
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 87
.L1636:

! 1019	         params[1] = ctx->Current.ByteColor[1] * ctx->Visual->InvGreenScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
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
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 88
.L1637:

! 1020	         params[2] = ctx->Current.ByteColor[2] * ctx->Visual->InvBlueScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
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
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 89
.L1638:

! 1021	         params[3] = ctx->Current.ByteColor[3] * ctx->Visual->InvAlphaScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
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
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 90
.L1639:

! 1022	         break;

	ba	.L1513
	nop

	! block 91
.L1640:
.L1641:

! 1023	      case GL_CURRENT_INDEX:
! 1024	         *params = (GLdouble) ctx->Current.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 92
.L1642:

! 1025	         break;

	ba	.L1513
	nop

	! block 93
.L1643:
.L1644:

! 1026	      case GL_CURRENT_NORMAL:
! 1027	         params[0] = (GLdouble) ctx->Current.Normal[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 94
.L1645:

! 1028	         params[1] = (GLdouble) ctx->Current.Normal[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 95
.L1646:

! 1029	         params[2] = (GLdouble) ctx->Current.Normal[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 96
.L1647:

! 1030	         break;

	ba	.L1513
	nop

	! block 97
.L1648:
.L1649:

! 1031	      case GL_CURRENT_RASTER_COLOR:
! 1032		 params[0] = (GLdouble) ctx->Current.RasterColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f0c),%l1
	or	%l1,%lo(0x1f0c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 98
.L1650:

! 1033		 params[1] = (GLdouble) ctx->Current.RasterColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f10),%l1
	or	%l1,%lo(0x1f10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 99
.L1651:

! 1034		 params[2] = (GLdouble) ctx->Current.RasterColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f14),%l1
	or	%l1,%lo(0x1f14),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 100
.L1652:

! 1035		 params[3] = (GLdouble) ctx->Current.RasterColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f18),%l1
	or	%l1,%lo(0x1f18),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 101
.L1653:

! 1036		 break;

	ba	.L1513
	nop

	! block 102
.L1654:
.L1655:

! 1037	      case GL_CURRENT_RASTER_DISTANCE:
! 1038		 params[0] = (GLdouble) ctx->Current.RasterDistance;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f08),%l1
	or	%l1,%lo(0x1f08),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 103
.L1656:

! 1039		 break;

	ba	.L1513
	nop

	! block 104
.L1657:
.L1658:

! 1040	      case GL_CURRENT_RASTER_INDEX:
! 1041		 *params = (GLdouble) ctx->Current.RasterIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f1c),%l1
	or	%l1,%lo(0x1f1c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 105
.L1659:

! 1042		 break;

	ba	.L1513
	nop

	! block 106
.L1660:
.L1661:

! 1043	      case GL_CURRENT_RASTER_POSITION:
! 1044		 params[0] = (GLdouble) ctx->Current.RasterPos[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef8),%l1
	or	%l1,%lo(0x1ef8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 107
.L1662:

! 1045		 params[1] = (GLdouble) ctx->Current.RasterPos[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1efc),%l1
	or	%l1,%lo(0x1efc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 108
.L1663:

! 1046		 params[2] = (GLdouble) ctx->Current.RasterPos[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f00),%l1
	or	%l1,%lo(0x1f00),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 109
.L1664:

! 1047		 params[3] = (GLdouble) ctx->Current.RasterPos[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f04),%l1
	or	%l1,%lo(0x1f04),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 110
.L1665:

! 1048		 break;

	ba	.L1513
	nop

	! block 111
.L1666:
.L1667:

! 1049	      case GL_CURRENT_RASTER_TEXTURE_COORDS:
! 1050		 params[0] = (GLdouble) ctx->Current.RasterTexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f20),%l1
	or	%l1,%lo(0x1f20),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 112
.L1668:

! 1051		 params[1] = (GLdouble) ctx->Current.RasterTexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f24),%l1
	or	%l1,%lo(0x1f24),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 113
.L1669:

! 1052		 params[2] = (GLdouble) ctx->Current.RasterTexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f28),%l1
	or	%l1,%lo(0x1f28),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 114
.L1670:

! 1053		 params[3] = (GLdouble) ctx->Current.RasterTexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f2c),%l1
	or	%l1,%lo(0x1f2c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 115
.L1671:

! 1054		 break;

	ba	.L1513
	nop

	! block 116
.L1672:
.L1673:

! 1055	      case GL_CURRENT_RASTER_POSITION_VALID:
! 1056		 *params = (GLdouble) ctx->Current.RasterPosValid;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f30),%l1
	or	%l1,%lo(0x1f30),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 117
.L1674:

! 1057		 break;

	ba	.L1513
	nop

	! block 118
.L1675:
.L1676:

! 1058	      case GL_CURRENT_TEXTURE_COORDS:
! 1059		 params[0] = (GLdouble) ctx->Current.TexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 119
.L1677:

! 1060		 params[1] = (GLdouble) ctx->Current.TexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 120
.L1678:

! 1061		 params[2] = (GLdouble) ctx->Current.TexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 121
.L1679:

! 1062		 params[3] = (GLdouble) ctx->Current.TexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 122
.L1680:

! 1063		 break;

	ba	.L1513
	nop

	! block 123
.L1681:
.L1682:

! 1064	      case GL_DEPTH_BIAS:
! 1065		 *params = (GLdouble) ctx->Pixel.DepthBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae3c),%l1
	or	%l1,%lo(0xae3c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 124
.L1683:

! 1066		 break;

	ba	.L1513
	nop

	! block 125
.L1684:
.L1685:

! 1067	      case GL_DEPTH_BITS:
! 1068		 *params = (GLdouble) ctx->Visual->DepthBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+64],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 126
.L1686:

! 1069		 break;

	ba	.L1513
	nop

	! block 127
.L1687:
.L1688:

! 1070	      case GL_DEPTH_CLEAR_VALUE:
! 1071		 *params = (GLdouble) ctx->Depth.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f38),%l1
	or	%l1,%lo(0x1f38),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 128
.L1689:

! 1072		 break;

	ba	.L1513
	nop

	! block 129
.L1690:
.L1691:

! 1073	      case GL_DEPTH_FUNC:
! 1074		 *params = (GLdouble) ctx->Depth.Func;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f34),%l1
	or	%l1,%lo(0x1f34),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 130
.L1692:

! 1075		 break;

	ba	.L1513
	nop

	! block 131
.L1693:
.L1694:

! 1076	      case GL_DEPTH_RANGE:
! 1077	         params[0] = (GLdouble) ctx->Viewport.Near;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc8),%l1
	or	%l1,%lo(0xdcc8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 132
.L1695:

! 1078	         params[1] = (GLdouble) ctx->Viewport.Far;

	ld	[%fp+68],%l0
	sethi	%hi(0xdccc),%l1
	or	%l1,%lo(0xdccc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 133
.L1696:

! 1079		 break;

	ba	.L1513
	nop

	! block 134
.L1697:
.L1698:

! 1080	      case GL_DEPTH_SCALE:
! 1081		 *params = (GLdouble) ctx->Pixel.DepthScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae40),%l1
	or	%l1,%lo(0xae40),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 135
.L1699:

! 1082		 break;

	ba	.L1513
	nop

	! block 136
.L1700:
.L1701:

! 1083	      case GL_DEPTH_TEST:
! 1084		 *params = (GLdouble) ctx->Depth.Test;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 137
.L1702:

! 1085		 break;

	ba	.L1513
	nop

	! block 138
.L1703:
.L1704:

! 1086	      case GL_DEPTH_WRITEMASK:
! 1087		 *params = (GLdouble) ctx->Depth.Mask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3d),%l1
	or	%l1,%lo(0x1f3d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 139
.L1705:

! 1088		 break;

	ba	.L1513
	nop

	! block 140
.L1706:
.L1707:

! 1089	      case GL_DITHER:
! 1090		 *params = (GLdouble) ctx->Color.DitherFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed3),%l1
	or	%l1,%lo(0x1ed3),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 141
.L1708:

! 1091		 break;

	ba	.L1513
	nop

	! block 142
.L1709:
.L1710:

! 1092	      case GL_DOUBLEBUFFER:
! 1093		 *params = (GLdouble) ctx->Visual->DBflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
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
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 143
.L1711:

! 1094		 break;

	ba	.L1513
	nop

	! block 144
.L1712:
.L1713:

! 1095	      case GL_DRAW_BUFFER:
! 1096		 *params = (GLdouble) ctx->Color.DrawBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e9c),%l1
	or	%l1,%lo(0x1e9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 145
.L1714:

! 1097		 break;

	ba	.L1513
	nop

	! block 146
.L1715:
.L1716:

! 1098	      case GL_EDGE_FLAG:
! 1099		 *params = (GLdouble) ctx->Current.EdgeFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f31),%l1
	or	%l1,%lo(0x1f31),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 147
.L1717:

! 1100		 break;

	ba	.L1513
	nop

	! block 148
.L1718:
.L1719:

! 1101	      case GL_FEEDBACK_BUFFER_SIZE:
! 1102	         /* TODO: is this right?  Or, return number of entries in buffer? */
! 1103	         *params = (GLdouble) ctx->Feedback.BufferSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 149
.L1720:

! 1104	         break;

	ba	.L1513
	nop

	! block 150
.L1721:
.L1722:

! 1105	      case GL_FEEDBACK_BUFFER_TYPE:
! 1106	         *params = (GLdouble) ctx->Feedback.Type;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb8),%l1
	or	%l1,%lo(0xdfb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 151
.L1723:

! 1107	         break;

	ba	.L1513
	nop

	! block 152
.L1724:
.L1725:

! 1108	      case GL_FOG:
! 1109		 *params = (GLdouble) ctx->Fog.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 153
.L1726:

! 1110		 break;

	ba	.L1513
	nop

	! block 154
.L1727:
.L1728:

! 1111	      case GL_FOG_COLOR:
! 1112		 params[0] = (GLdouble) ctx->Fog.Color[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f7c),%l1
	or	%l1,%lo(0x1f7c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 155
.L1729:

! 1113		 params[1] = (GLdouble) ctx->Fog.Color[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f80),%l1
	or	%l1,%lo(0x1f80),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 156
.L1730:

! 1114		 params[2] = (GLdouble) ctx->Fog.Color[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f84),%l1
	or	%l1,%lo(0x1f84),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 157
.L1731:

! 1115		 params[3] = (GLdouble) ctx->Fog.Color[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f88),%l1
	or	%l1,%lo(0x1f88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 158
.L1732:

! 1116		 break;

	ba	.L1513
	nop

	! block 159
.L1733:
.L1734:

! 1117	      case GL_FOG_DENSITY:
! 1118		 *params = (GLdouble) ctx->Fog.Density;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f8c),%l1
	or	%l1,%lo(0x1f8c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 160
.L1735:

! 1119		 break;

	ba	.L1513
	nop

	! block 161
.L1736:
.L1737:

! 1120	      case GL_FOG_END:
! 1121		 *params = (GLdouble) ctx->Fog.End;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f94),%l1
	or	%l1,%lo(0x1f94),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 162
.L1738:

! 1122		 break;

	ba	.L1513
	nop

	! block 163
.L1739:
.L1740:

! 1123	      case GL_FOG_HINT:
! 1124		 *params = (GLdouble) ctx->Hint.Fog;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 164
.L1741:

! 1125		 break;

	ba	.L1513
	nop

	! block 165
.L1742:
.L1743:

! 1126	      case GL_FOG_INDEX:
! 1127		 *params = (GLdouble) ctx->Fog.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f98),%l1
	or	%l1,%lo(0x1f98),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 166
.L1744:

! 1128		 break;

	ba	.L1513
	nop

	! block 167
.L1745:
.L1746:

! 1129	      case GL_FOG_MODE:
! 1130		 *params = (GLdouble) ctx->Fog.Mode;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f9c),%l1
	or	%l1,%lo(0x1f9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 168
.L1747:

! 1131		 break;

	ba	.L1513
	nop

	! block 169
.L1748:
.L1749:

! 1132	      case GL_FOG_START:
! 1133		 *params = (GLdouble) ctx->Fog.Start;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f90),%l1
	or	%l1,%lo(0x1f90),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 170
.L1750:

! 1134		 break;

	ba	.L1513
	nop

	! block 171
.L1751:
.L1752:

! 1135	      case GL_FRONT_FACE:
! 1136		 *params = (GLdouble) ctx->Polygon.FrontFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a0),%l1
	or	%l1,%lo(0xd6a0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 172
.L1753:

! 1137		 break;

	ba	.L1513
	nop

	! block 173
.L1754:
.L1755:

! 1138	      case GL_GREEN_BIAS:
! 1139	         *params = (GLdouble) ctx->Pixel.GreenBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 174
.L1756:

! 1140	         break;

	ba	.L1513
	nop

	! block 175
.L1757:
.L1758:

! 1141	      case GL_GREEN_BITS:
! 1142	         *params = (GLdouble) ctx->Visual->GreenBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+44],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 176
.L1759:

! 1143	         break;

	ba	.L1513
	nop

	! block 177
.L1760:
.L1761:

! 1144	      case GL_GREEN_SCALE:
! 1145	         *params = (GLdouble) ctx->Pixel.GreenScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 178
.L1762:

! 1146	         break;

	ba	.L1513
	nop

	! block 179
.L1763:
.L1764:

! 1147	      case GL_INDEX_BITS:
! 1148	         *params = (GLdouble) ctx->Visual->IndexBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 180
.L1765:

! 1149		 break;

	ba	.L1513
	nop

	! block 181
.L1766:
.L1767:

! 1150	      case GL_INDEX_CLEAR_VALUE:
! 1151	         *params = (GLdouble) ctx->Color.ClearIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e7c),%l1
	or	%l1,%lo(0x1e7c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 182
.L1768:

! 1152		 break;

	ba	.L1513
	nop

	! block 183
.L1769:
.L1770:

! 1153	      case GL_INDEX_MODE:
! 1154		 *params = ctx->Visual->RGBAflag ? 0.0 : 1.0;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l0
	cmp	%l0,%g0
	be	.L1771
	nop

	! block 184
.L1772:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ba	.L1773
	std	%f4,[%fp-48]

	! block 185
.L1771:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	std	%f4,[%fp-48]

	! block 186
.L1773:
	ldd	[%fp-48],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 187
.L1774:

! 1155		 break;

	ba	.L1513
	nop

	! block 188
.L1775:
.L1776:

! 1156	      case GL_INDEX_OFFSET:
! 1157		 *params = (GLdouble) ctx->Pixel.IndexOffset;

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 189
.L1777:

! 1158		 break;

	ba	.L1513
	nop

	! block 190
.L1778:
.L1779:

! 1159	      case GL_INDEX_SHIFT:
! 1160		 *params = (GLdouble) ctx->Pixel.IndexShift;

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 191
.L1780:

! 1161		 break;

	ba	.L1513
	nop

	! block 192
.L1781:
.L1782:

! 1162	      case GL_INDEX_WRITEMASK:
! 1163		 *params = (GLdouble) ctx->Color.IndexMask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e90),%l1
	or	%l1,%lo(0x1e90),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 193
.L1783:

! 1164		 break;

	ba	.L1513
	nop

	! block 194
.L1784:
.L1785:
.L1786:
.L1787:
.L1788:
.L1789:
.L1790:
.L1791:
.L1792:

! 1165	      case GL_LIGHT0:
! 1166	      case GL_LIGHT1:
! 1167	      case GL_LIGHT2:
! 1168	      case GL_LIGHT3:
! 1169	      case GL_LIGHT4:
! 1170	      case GL_LIGHT5:
! 1171	      case GL_LIGHT6:
! 1172	      case GL_LIGHT7:
! 1173		 *params = (GLdouble) ctx->Light.Light[pname-GL_LIGHT0].Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb4),%l1
	or	%l1,%lo(0x1fb4),%l1
	add	%l0,%l1,%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,5,%l1
	add	%l2,%l1,%l2
	sll	%l0,6,%l1
	add	%l2,%l1,%l2
	sll	%l0,7,%l1
	add	%l2,%l1,%l2
	sll	%l0,12,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x438ff98),%l1
	or	%l1,%lo(0x438ff98),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 195
.L1793:

! 1174		 break;

	ba	.L1513
	nop

	! block 196
.L1794:
.L1795:

! 1175	      case GL_LIGHTING:
! 1176		 *params = (GLdouble) ctx->Light.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xadc8),%l1
	or	%l1,%lo(0xadc8),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 197
.L1796:

! 1177		 break;

	ba	.L1513
	nop

	! block 198
.L1797:
.L1798:

! 1178	      case GL_LIGHT_MODEL_AMBIENT:
! 1179		 params[0] = (GLdouble) ctx->Light.Model.Ambient[0];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 199
.L1799:

! 1180		 params[1] = (GLdouble) ctx->Light.Model.Ambient[1];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 200
.L1800:

! 1181		 params[2] = (GLdouble) ctx->Light.Model.Ambient[2];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 201
.L1801:

! 1182		 params[3] = (GLdouble) ctx->Light.Model.Ambient[3];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 202
.L1802:

! 1183		 break;

	ba	.L1513
	nop

	! block 203
.L1803:
.L1804:

! 1184	      case GL_LIGHT_MODEL_LOCAL_VIEWER:
! 1185		 *params = (GLdouble) ctx->Light.Model.LocalViewer;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e4),%l1
	or	%l1,%lo(0xa6e4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 204
.L1805:

! 1186		 break;

	ba	.L1513
	nop

	! block 205
.L1806:
.L1807:

! 1187	      case GL_LIGHT_MODEL_TWO_SIDE:
! 1188		 *params = (GLdouble) ctx->Light.Model.TwoSide;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e5),%l1
	or	%l1,%lo(0xa6e5),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 206
.L1808:

! 1189		 break;

	ba	.L1513
	nop

	! block 207
.L1809:
.L1810:

! 1190	      case GL_LINE_SMOOTH:
! 1191		 *params = (GLdouble) ctx->Line.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae08),%l1
	or	%l1,%lo(0xae08),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 208
.L1811:

! 1192		 break;

	ba	.L1513
	nop

	! block 209
.L1812:
.L1813:

! 1193	      case GL_LINE_SMOOTH_HINT:
! 1194		 *params = (GLdouble) ctx->Hint.LineSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa8),%l1
	or	%l1,%lo(0x1fa8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 210
.L1814:

! 1195		 break;

	ba	.L1513
	nop

	! block 211
.L1815:
.L1816:

! 1196	      case GL_LINE_STIPPLE:
! 1197		 *params = (GLdouble) ctx->Line.StippleFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 212
.L1817:

! 1198		 break;

	ba	.L1513
	nop

	! block 213
.L1818:
.L1819:

! 1199	      case GL_LINE_STIPPLE_PATTERN:
! 1200	         *params = (GLdouble) ctx->Line.StipplePattern;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 214
.L1820:

! 1201	         break;

	ba	.L1513
	nop

	! block 215
.L1821:
.L1822:

! 1202	      case GL_LINE_STIPPLE_REPEAT:
! 1203	         *params = (GLdouble) ctx->Line.StippleFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 216
.L1823:

! 1204	         break;

	ba	.L1513
	nop

	! block 217
.L1824:
.L1825:

! 1205	      case GL_LINE_WIDTH:
! 1206		 *params = (GLdouble) ctx->Line.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 218
.L1826:

! 1207		 break;

	ba	.L1513
	nop

	! block 219
.L1827:
.L1828:

! 1208	      case GL_LINE_WIDTH_GRANULARITY:
! 1209		 *params = (GLdouble) LINE_WIDTH_GRANULARITY;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 220
.L1829:

! 1210		 break;

	ba	.L1513
	nop

	! block 221
.L1830:
.L1831:

! 1211	      case GL_LINE_WIDTH_RANGE:
! 1212		 params[0] = (GLdouble) MIN_LINE_WIDTH;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 222
.L1832:

! 1213		 params[1] = (GLdouble) MAX_LINE_WIDTH;

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 223
.L1833:

! 1214		 break;

	ba	.L1513
	nop

	! block 224
.L1834:
.L1835:

! 1215	      case GL_LIST_BASE:
! 1216		 *params = (GLdouble) ctx->List.ListBase;

	ld	[%fp+68],%l0
	sethi	%hi(0xae14),%l1
	or	%l1,%lo(0xae14),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 225
.L1836:

! 1217		 break;

	ba	.L1513
	nop

	! block 226
.L1837:
.L1838:

! 1218	      case GL_LIST_INDEX:
! 1219		 *params = (GLdouble) gl_list_index();

	call	gl_list_index
	nop
	st	%o0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 227
.L1839:

! 1220		 break;

	ba	.L1513
	nop

	! block 228
.L1840:
.L1841:

! 1221	      case GL_LIST_MODE:
! 1222		 *params = ctx->ExecuteFlag ? (GLdouble) GL_COMPILE_AND_EXECUTE
! 1223		   			  : (GLdouble) GL_COMPILE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e24),%l1
	or	%l1,%lo(0x1e24),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L1842
	nop

	! block 229
.L1843:
	sethi	%hi(.L_cseg5),%l0
	ldd	[%l0+%lo(.L_cseg5)],%f4
	ba	.L1844
	std	%f4,[%fp-56]

	! block 230
.L1842:
	sethi	%hi(.L_cseg6),%l0
	ldd	[%l0+%lo(.L_cseg6)],%f4
	std	%f4,[%fp-56]

	! block 231
.L1844:
	ldd	[%fp-56],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 232
.L1845:

! 1224		 break;

	ba	.L1513
	nop

	! block 233
.L1846:
.L1847:

! 1225	      case GL_INDEX_LOGIC_OP:
! 1226		 *params = (GLdouble) ctx->Color.IndexLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed0),%l1
	or	%l1,%lo(0x1ed0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 234
.L1848:

! 1227		 break;

	ba	.L1513
	nop

	! block 235
.L1849:
.L1850:

! 1228	      case GL_COLOR_LOGIC_OP:
! 1229		 *params = (GLdouble) ctx->Color.ColorLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed1),%l1
	or	%l1,%lo(0x1ed1),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 236
.L1851:

! 1230		 break;

	ba	.L1513
	nop

	! block 237
.L1852:
.L1853:

! 1231	      case GL_LOGIC_OP_MODE:
! 1232	         *params = (GLdouble) ctx->Color.LogicOp;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ecc),%l1
	or	%l1,%lo(0x1ecc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 238
.L1854:

! 1233		 break;

	ba	.L1513
	nop

	! block 239
.L1855:
.L1856:

! 1234	      case GL_MAP1_COLOR_4:
! 1235		 *params = (GLdouble) ctx->Eval.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f40),%l1
	or	%l1,%lo(0x1f40),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 240
.L1857:

! 1236		 break;

	ba	.L1513
	nop

	! block 241
.L1858:
.L1859:

! 1237	      case GL_MAP1_GRID_DOMAIN:
! 1238		 params[0] = (GLdouble) ctx->Eval.MapGrid1u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 242
.L1860:

! 1239		 params[1] = (GLdouble) ctx->Eval.MapGrid1u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 243
.L1861:

! 1240		 break;

	ba	.L1513
	nop

	! block 244
.L1862:
.L1863:

! 1241	      case GL_MAP1_GRID_SEGMENTS:
! 1242		 *params = (GLdouble) ctx->Eval.MapGrid1un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 245
.L1864:

! 1243		 break;

	ba	.L1513
	nop

	! block 246
.L1865:
.L1866:

! 1244	      case GL_MAP1_INDEX:
! 1245		 *params = (GLdouble) ctx->Eval.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f41),%l1
	or	%l1,%lo(0x1f41),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 247
.L1867:

! 1246		 break;

	ba	.L1513
	nop

	! block 248
.L1868:
.L1869:

! 1247	      case GL_MAP1_NORMAL:
! 1248		 *params = (GLdouble) ctx->Eval.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f42),%l1
	or	%l1,%lo(0x1f42),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 249
.L1870:

! 1249		 break;

	ba	.L1513
	nop

	! block 250
.L1871:
.L1872:

! 1250	      case GL_MAP1_TEXTURE_COORD_1:
! 1251		 *params = (GLdouble) ctx->Eval.Map1TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f43),%l1
	or	%l1,%lo(0x1f43),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 251
.L1873:

! 1252		 break;

	ba	.L1513
	nop

	! block 252
.L1874:
.L1875:

! 1253	      case GL_MAP1_TEXTURE_COORD_2:
! 1254		 *params = (GLdouble) ctx->Eval.Map1TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f44),%l1
	or	%l1,%lo(0x1f44),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 253
.L1876:

! 1255		 break;

	ba	.L1513
	nop

	! block 254
.L1877:
.L1878:

! 1256	      case GL_MAP1_TEXTURE_COORD_3:
! 1257		 *params = (GLdouble) ctx->Eval.Map1TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f45),%l1
	or	%l1,%lo(0x1f45),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 255
.L1879:

! 1258		 break;

	ba	.L1513
	nop

	! block 256
.L1880:
.L1881:

! 1259	      case GL_MAP1_TEXTURE_COORD_4:
! 1260		 *params = (GLdouble) ctx->Eval.Map1TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f46),%l1
	or	%l1,%lo(0x1f46),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 257
.L1882:

! 1261		 break;

	ba	.L1513
	nop

	! block 258
.L1883:
.L1884:

! 1262	      case GL_MAP1_VERTEX_3:
! 1263		 *params = (GLdouble) ctx->Eval.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f47),%l1
	or	%l1,%lo(0x1f47),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 259
.L1885:

! 1264		 break;

	ba	.L1513
	nop

	! block 260
.L1886:
.L1887:

! 1265	      case GL_MAP1_VERTEX_4:
! 1266		 *params = (GLdouble) ctx->Eval.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f48),%l1
	or	%l1,%lo(0x1f48),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 261
.L1888:

! 1267		 break;

	ba	.L1513
	nop

	! block 262
.L1889:
.L1890:

! 1268	      case GL_MAP2_COLOR_4:
! 1269		 *params = (GLdouble) ctx->Eval.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f49),%l1
	or	%l1,%lo(0x1f49),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 263
.L1891:

! 1270		 break;

	ba	.L1513
	nop

	! block 264
.L1892:
.L1893:

! 1271	      case GL_MAP2_GRID_DOMAIN:
! 1272		 params[0] = (GLdouble) ctx->Eval.MapGrid2u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 265
.L1894:

! 1273		 params[1] = (GLdouble) ctx->Eval.MapGrid2u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 266
.L1895:

! 1274		 params[2] = (GLdouble) ctx->Eval.MapGrid2v1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 267
.L1896:

! 1275		 params[3] = (GLdouble) ctx->Eval.MapGrid2v2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 268
.L1897:

! 1276		 break;

	ba	.L1513
	nop

	! block 269
.L1898:
.L1899:

! 1277	      case GL_MAP2_GRID_SEGMENTS:
! 1278		 params[0] = (GLdouble) ctx->Eval.MapGrid2un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 270
.L1900:

! 1279		 params[1] = (GLdouble) ctx->Eval.MapGrid2vn;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 271
.L1901:

! 1280		 break;

	ba	.L1513
	nop

	! block 272
.L1902:
.L1903:

! 1281	      case GL_MAP2_INDEX:
! 1282		 *params = (GLdouble) ctx->Eval.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4a),%l1
	or	%l1,%lo(0x1f4a),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 273
.L1904:

! 1283		 break;

	ba	.L1513
	nop

	! block 274
.L1905:
.L1906:

! 1284	      case GL_MAP2_NORMAL:
! 1285		 *params = (GLdouble) ctx->Eval.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4b),%l1
	or	%l1,%lo(0x1f4b),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 275
.L1907:

! 1286		 break;

	ba	.L1513
	nop

	! block 276
.L1908:
.L1909:

! 1287	      case GL_MAP2_TEXTURE_COORD_1:
! 1288		 *params = (GLdouble) ctx->Eval.Map2TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4c),%l1
	or	%l1,%lo(0x1f4c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 277
.L1910:

! 1289		 break;

	ba	.L1513
	nop

	! block 278
.L1911:
.L1912:

! 1290	      case GL_MAP2_TEXTURE_COORD_2:
! 1291		 *params = (GLdouble) ctx->Eval.Map2TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4d),%l1
	or	%l1,%lo(0x1f4d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 279
.L1913:

! 1292		 break;

	ba	.L1513
	nop

	! block 280
.L1914:
.L1915:

! 1293	      case GL_MAP2_TEXTURE_COORD_3:
! 1294		 *params = (GLdouble) ctx->Eval.Map2TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4e),%l1
	or	%l1,%lo(0x1f4e),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 281
.L1916:

! 1295		 break;

	ba	.L1513
	nop

	! block 282
.L1917:
.L1918:

! 1296	      case GL_MAP2_TEXTURE_COORD_4:
! 1297		 *params = (GLdouble) ctx->Eval.Map2TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4f),%l1
	or	%l1,%lo(0x1f4f),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 283
.L1919:

! 1298		 break;

	ba	.L1513
	nop

	! block 284
.L1920:
.L1921:

! 1299	      case GL_MAP2_VERTEX_3:
! 1300		 *params = (GLdouble) ctx->Eval.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 285
.L1922:

! 1301		 break;

	ba	.L1513
	nop

	! block 286
.L1923:
.L1924:

! 1302	      case GL_MAP2_VERTEX_4:
! 1303		 *params = (GLdouble) ctx->Eval.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 287
.L1925:

! 1304		 break;

	ba	.L1513
	nop

	! block 288
.L1926:
.L1927:

! 1305	      case GL_MAP_COLOR:
! 1306		 *params = (GLdouble) ctx->Pixel.MapColorFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 289
.L1928:

! 1307		 break;

	ba	.L1513
	nop

	! block 290
.L1929:
.L1930:

! 1308	      case GL_MAP_STENCIL:
! 1309		 *params = (GLdouble) ctx->Pixel.MapStencilFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4d),%l1
	or	%l1,%lo(0xae4d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 291
.L1931:

! 1310		 break;

	ba	.L1513
	nop

	! block 292
.L1932:
.L1933:

! 1311	      case GL_MATRIX_MODE:
! 1312		 *params = (GLdouble) ctx->Transform.MatrixMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xdc4c),%l1
	or	%l1,%lo(0xdc4c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 293
.L1934:

! 1313		 break;

	ba	.L1513
	nop

	! block 294
.L1935:
.L1936:

! 1314	      case GL_MAX_ATTRIB_STACK_DEPTH:
! 1315		 *params = (GLdouble) MAX_ATTRIB_STACK_DEPTH;

	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 295
.L1937:

! 1316		 break;

	ba	.L1513
	nop

	! block 296
.L1938:
.L1939:

! 1317	      case GL_MAX_CLIENT_ATTRIB_STACK_DEPTH:
! 1318	         *params = (GLdouble) MAX_CLIENT_ATTRIB_STACK_DEPTH;

	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 297
.L1940:

! 1319	         break;

	ba	.L1513
	nop

	! block 298
.L1941:
.L1942:

! 1320	      case GL_MAX_CLIP_PLANES:
! 1321		 *params = (GLdouble) MAX_CLIP_PLANES;

	sethi	%hi(.L_cseg8),%l0
	ldd	[%l0+%lo(.L_cseg8)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 299
.L1943:

! 1322		 break;

	ba	.L1513
	nop

	! block 300
.L1944:
.L1945:

! 1323	      case GL_MAX_EVAL_ORDER:
! 1324		 *params = (GLdouble) MAX_EVAL_ORDER;

	sethi	%hi(.L_cseg9),%l0
	ldd	[%l0+%lo(.L_cseg9)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 301
.L1946:

! 1325		 break;

	ba	.L1513
	nop

	! block 302
.L1947:
.L1948:

! 1326	      case GL_MAX_LIGHTS:
! 1327		 *params = (GLdouble) MAX_LIGHTS;

	sethi	%hi(.L_cseg10),%l0
	ldd	[%l0+%lo(.L_cseg10)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 303
.L1949:

! 1328		 break;

	ba	.L1513
	nop

	! block 304
.L1950:
.L1951:

! 1329	      case GL_MAX_LIST_NESTING:
! 1330		 *params = (GLdouble) MAX_LIST_NESTING;

	sethi	%hi(.L_cseg11),%l0
	ldd	[%l0+%lo(.L_cseg11)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 305
.L1952:

! 1331		 break;

	ba	.L1513
	nop

	! block 306
.L1953:
.L1954:

! 1332	      case GL_MAX_MODELVIEW_STACK_DEPTH:
! 1333		 *params = (GLdouble) MAX_MODELVIEW_STACK_DEPTH;

	sethi	%hi(.L_cseg12),%l0
	ldd	[%l0+%lo(.L_cseg12)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 307
.L1955:

! 1334		 break;

	ba	.L1513
	nop

	! block 308
.L1956:
.L1957:

! 1335	      case GL_MAX_NAME_STACK_DEPTH:
! 1336		 *params = (GLdouble) MAX_NAME_STACK_DEPTH;

	sethi	%hi(.L_cseg11),%l0
	ldd	[%l0+%lo(.L_cseg11)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 309
.L1958:

! 1337		 break;

	ba	.L1513
	nop

	! block 310
.L1959:
.L1960:

! 1338	      case GL_MAX_PIXEL_MAP_TABLE:
! 1339		 *params = (GLdouble) MAX_PIXEL_MAP_TABLE;

	sethi	%hi(.L_cseg13),%l0
	ldd	[%l0+%lo(.L_cseg13)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 311
.L1961:

! 1340		 break;

	ba	.L1513
	nop

	! block 312
.L1962:
.L1963:

! 1341	      case GL_MAX_PROJECTION_STACK_DEPTH:
! 1342		 *params = (GLdouble) MAX_PROJECTION_STACK_DEPTH;

	sethi	%hi(.L_cseg12),%l0
	ldd	[%l0+%lo(.L_cseg12)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 313
.L1964:

! 1343		 break;

	ba	.L1513
	nop

	! block 314
.L1965:
.L1966:

! 1344	      case GL_MAX_TEXTURE_SIZE:
! 1345		 *params = (GLdouble) MAX_TEXTURE_SIZE;

	sethi	%hi(.L_cseg14),%l0
	ldd	[%l0+%lo(.L_cseg14)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 315
.L1967:

! 1346		 break;

	ba	.L1513
	nop

	! block 316
.L1968:
.L1969:

! 1347	      case GL_MAX_TEXTURE_STACK_DEPTH:
! 1348		 *params = (GLdouble) MAX_TEXTURE_STACK_DEPTH;

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 317
.L1970:

! 1349		 break;

	ba	.L1513
	nop

	! block 318
.L1971:
.L1972:

! 1350	      case GL_MAX_VIEWPORT_DIMS:
! 1351	         params[0] = (GLdouble) MAX_WIDTH;

	sethi	%hi(.L_cseg15),%l0
	ldd	[%l0+%lo(.L_cseg15)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 319
.L1973:

! 1352	         params[1] = (GLdouble) MAX_HEIGHT;

	sethi	%hi(.L_cseg16),%l0
	ldd	[%l0+%lo(.L_cseg16)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 320
.L1974:

! 1353	         break;

	ba	.L1513
	nop

	! block 321
.L1975:
.L1976:
.L1977:

! 1354	      case GL_MODELVIEW_MATRIX:
! 1355		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 322
.L1981:
.L1978:
.L1982:
.L1983:
.L1984:

! 1356		    params[i] = (GLdouble) ctx->ModelViewMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l3
	sll	%l3,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+2436],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	sll	%l3,3,%l1
	add	%l0,%l1,%g1
	st	%f4,[%g1]
	st	%f5,[%g1+4]

	! block 323
.L1985:
.L1986:
.L1987:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L1978
	nop

	! block 324
.L1988:
.L1980:
.L1989:
.L1990:

! 1357		 }
! 1358		 break;

	ba	.L1513
	nop

	! block 325
.L1991:
.L1992:

! 1359	      case GL_MODELVIEW_STACK_DEPTH:
! 1360		 *params = (GLdouble) ctx->ModelViewStackDepth;

	ld	[%fp+68],%l0
	ld	[%l0+2564],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 326
.L1993:

! 1361		 break;

	ba	.L1513
	nop

	! block 327
.L1994:
.L1995:

! 1362	      case GL_NAME_STACK_DEPTH:
! 1363		 *params = (GLdouble) ctx->Select.NameStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfdc),%l1
	or	%l1,%lo(0xdfdc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 328
.L1996:

! 1364		 break;

	ba	.L1513
	nop

	! block 329
.L1997:
.L1998:

! 1365	      case GL_NORMALIZE:
! 1366		 *params = (GLdouble) ctx->Transform.Normalize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb7),%l1
	or	%l1,%lo(0xdcb7),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 330
.L1999:

! 1367		 break;

	ba	.L1513
	nop

	! block 331
.L2000:
.L2001:

! 1368	      case GL_PACK_ALIGNMENT:
! 1369		 *params = (GLdouble) ctx->Pack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddac),%l1
	or	%l1,%lo(0xddac),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 332
.L2002:

! 1370		 break;

	ba	.L1513
	nop

	! block 333
.L2003:
.L2004:

! 1371	      case GL_PACK_LSB_FIRST:
! 1372		 *params = (GLdouble) ctx->Pack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc5),%l1
	or	%l1,%lo(0xddc5),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 334
.L2005:

! 1373		 break;

	ba	.L1513
	nop

	! block 335
.L2006:
.L2007:

! 1374	      case GL_PACK_ROW_LENGTH:
! 1375		 *params = (GLdouble) ctx->Pack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb0),%l1
	or	%l1,%lo(0xddb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 336
.L2008:

! 1376		 break;

	ba	.L1513
	nop

	! block 337
.L2009:
.L2010:

! 1377	      case GL_PACK_SKIP_PIXELS:
! 1378		 *params = (GLdouble) ctx->Pack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb4),%l1
	or	%l1,%lo(0xddb4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 338
.L2011:

! 1379		 break;

	ba	.L1513
	nop

	! block 339
.L2012:
.L2013:

! 1380	      case GL_PACK_SKIP_ROWS:
! 1381		 *params = (GLdouble) ctx->Pack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb8),%l1
	or	%l1,%lo(0xddb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 340
.L2014:

! 1382		 break;

	ba	.L1513
	nop

	! block 341
.L2015:
.L2016:

! 1383	      case GL_PACK_SWAP_BYTES:
! 1384		 *params = (GLdouble) ctx->Pack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc4),%l1
	or	%l1,%lo(0xddc4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 342
.L2017:

! 1385		 break;

	ba	.L1513
	nop

	! block 343
.L2018:
.L2019:

! 1386	      case GL_PACK_SKIP_IMAGES_EXT:
! 1387	         *params = (GLdouble) ctx->Pack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc0),%l1
	or	%l1,%lo(0xddc0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 344
.L2020:

! 1388	         break;

	ba	.L1513
	nop

	! block 345
.L2021:
.L2022:

! 1389	      case GL_PACK_IMAGE_HEIGHT_EXT:
! 1390	         *params = (GLdouble) ctx->Pack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddbc),%l1
	or	%l1,%lo(0xddbc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 346
.L2023:

! 1391	         break;

	ba	.L1513
	nop

	! block 347
.L2024:
.L2025:

! 1392	      case GL_PERSPECTIVE_CORRECTION_HINT:
! 1393		 *params = (GLdouble) ctx->Hint.PerspectiveCorrection;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa0),%l1
	or	%l1,%lo(0x1fa0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 348
.L2026:

! 1394		 break;

	ba	.L1513
	nop

	! block 349
.L2027:
.L2028:

! 1395	      case GL_PIXEL_MAP_A_TO_A_SIZE:
! 1396		 *params = (GLdouble) ctx->Pixel.MapAtoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 350
.L2029:

! 1397		 break;

	ba	.L1513
	nop

	! block 351
.L2030:
.L2031:

! 1398	      case GL_PIXEL_MAP_B_TO_B_SIZE:
! 1399		 *params = (GLdouble) ctx->Pixel.MapBtoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 352
.L2032:

! 1400		 break;

	ba	.L1513
	nop

	! block 353
.L2033:
.L2034:

! 1401	      case GL_PIXEL_MAP_G_TO_G_SIZE:
! 1402		 *params = (GLdouble) ctx->Pixel.MapGtoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 354
.L2035:

! 1403		 break;

	ba	.L1513
	nop

	! block 355
.L2036:
.L2037:

! 1404	      case GL_PIXEL_MAP_I_TO_A_SIZE:
! 1405		 *params = (GLdouble) ctx->Pixel.MapItoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 356
.L2038:

! 1406		 break;

	ba	.L1513
	nop

	! block 357
.L2039:
.L2040:

! 1407	      case GL_PIXEL_MAP_I_TO_B_SIZE:
! 1408		 *params = (GLdouble) ctx->Pixel.MapItoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 358
.L2041:

! 1409		 break;

	ba	.L1513
	nop

	! block 359
.L2042:
.L2043:

! 1410	      case GL_PIXEL_MAP_I_TO_G_SIZE:
! 1411		 *params = (GLdouble) ctx->Pixel.MapItoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 360
.L2044:

! 1412		 break;

	ba	.L1513
	nop

	! block 361
.L2045:
.L2046:

! 1413	      case GL_PIXEL_MAP_I_TO_I_SIZE:
! 1414		 *params = (GLdouble) ctx->Pixel.MapItoIsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae5c),%l1
	or	%l1,%lo(0xae5c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 362
.L2047:

! 1415		 break;

	ba	.L1513
	nop

	! block 363
.L2048:
.L2049:

! 1416	      case GL_PIXEL_MAP_I_TO_R_SIZE:
! 1417		 *params = (GLdouble) ctx->Pixel.MapItoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 364
.L2050:

! 1418		 break;

	ba	.L1513
	nop

	! block 365
.L2051:
.L2052:

! 1419	      case GL_PIXEL_MAP_R_TO_R_SIZE:
! 1420		 *params = (GLdouble) ctx->Pixel.MapRtoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 366
.L2053:

! 1421		 break;

	ba	.L1513
	nop

	! block 367
.L2054:
.L2055:

! 1422	      case GL_PIXEL_MAP_S_TO_S_SIZE:
! 1423		 *params = (GLdouble) ctx->Pixel.MapStoSsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae58),%l1
	or	%l1,%lo(0xae58),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 368
.L2056:

! 1424		 break;

	ba	.L1513
	nop

	! block 369
.L2057:
.L2058:

! 1425	      case GL_POINT_SIZE:
! 1426	         *params = (GLdouble) ctx->Point.Size;

	ld	[%fp+68],%l0
	sethi	%hi(0xd684),%l1
	or	%l1,%lo(0xd684),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 370
.L2059:

! 1427	         break;

	ba	.L1513
	nop

	! block 371
.L2060:
.L2061:

! 1428	      case GL_POINT_SIZE_GRANULARITY:
! 1429		 *params = (GLdouble) POINT_SIZE_GRANULARITY;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 372
.L2062:

! 1430		 break;

	ba	.L1513
	nop

	! block 373
.L2063:
.L2064:

! 1431	      case GL_POINT_SIZE_RANGE:
! 1432		 params[0] = (GLdouble) MIN_POINT_SIZE;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 374
.L2065:

! 1433		 params[1] = (GLdouble) MAX_POINT_SIZE;

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 375
.L2066:

! 1434		 break;

	ba	.L1513
	nop

	! block 376
.L2067:
.L2068:

! 1435	      case GL_POINT_SMOOTH:
! 1436		 *params = (GLdouble) ctx->Point.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd680),%l1
	or	%l1,%lo(0xd680),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 377
.L2069:

! 1437		 break;

	ba	.L1513
	nop

	! block 378
.L2070:
.L2071:

! 1438	      case GL_POINT_SMOOTH_HINT:
! 1439		 *params = (GLdouble) ctx->Hint.PointSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa4),%l1
	or	%l1,%lo(0x1fa4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 379
.L2072:

! 1440		 break;

	ba	.L1513
	nop

	! block 380
.L2073:
.L2074:

! 1441	      case GL_POINT_SIZE_MIN_EXT:
! 1442		 *params = (GLdouble) (ctx->Point.MinSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd694),%l1
	or	%l1,%lo(0xd694),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 381
.L2075:

! 1443		 break;

	ba	.L1513
	nop

	! block 382
.L2076:
.L2077:

! 1444	      case GL_POINT_SIZE_MAX_EXT:
! 1445		 *params = (GLdouble) (ctx->Point.MaxSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd698),%l1
	or	%l1,%lo(0xd698),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 383
.L2078:

! 1446		 break;

	ba	.L1513
	nop

	! block 384
.L2079:
.L2080:

! 1447	      case GL_POINT_FADE_THRESHOLD_SIZE_EXT:
! 1448		 *params = (GLdouble) (ctx->Point.Threshold);

	ld	[%fp+68],%l0
	sethi	%hi(0xd69c),%l1
	or	%l1,%lo(0xd69c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 385
.L2081:

! 1449		 break;

	ba	.L1513
	nop

	! block 386
.L2082:
.L2083:

! 1450	      case GL_DISTANCE_ATTENUATION_EXT:
! 1451		 params[0] = (GLdouble) (ctx->Point.Params[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd688),%l1
	or	%l1,%lo(0xd688),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 387
.L2084:

! 1452		 params[1] = (GLdouble) (ctx->Point.Params[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd68c),%l1
	or	%l1,%lo(0xd68c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 388
.L2085:

! 1453		 params[2] = (GLdouble) (ctx->Point.Params[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd690),%l1
	or	%l1,%lo(0xd690),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 389
.L2086:

! 1454		 break;

	ba	.L1513
	nop

	! block 390
.L2087:
.L2088:

! 1455	      case GL_POLYGON_MODE:
! 1456		 params[0] = (GLdouble) ctx->Polygon.FrontMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a4),%l1
	or	%l1,%lo(0xd6a4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 391
.L2089:

! 1457		 params[1] = (GLdouble) ctx->Polygon.BackMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a8),%l1
	or	%l1,%lo(0xd6a8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 392
.L2090:

! 1458		 break;

	ba	.L1513
	nop

	! block 393
.L2091:
.L2092:

! 1459	#ifdef GL_EXT_polygon_offset
! 1460	      case GL_POLYGON_OFFSET_BIAS_EXT:
! 1461	         *params = (GLdouble) ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 394
.L2093:

! 1462	         break;

	ba	.L1513
	nop

	! block 395
.L2094:
.L2095:

! 1463	#endif
! 1464	      case GL_POLYGON_OFFSET_FACTOR:
! 1465	         *params = (GLdouble) ctx->Polygon.OffsetFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6bc),%l1
	or	%l1,%lo(0xd6bc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 396
.L2096:

! 1466	         break;

	ba	.L1513
	nop

	! block 397
.L2097:
.L2098:

! 1467	      case GL_POLYGON_OFFSET_UNITS:
! 1468	         *params = (GLdouble) ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 398
.L2099:

! 1469	         break;

	ba	.L1513
	nop

	! block 399
.L2100:
.L2101:

! 1470	      case GL_POLYGON_SMOOTH:
! 1471		 *params = (GLdouble) ctx->Polygon.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b8),%l1
	or	%l1,%lo(0xd6b8),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 400
.L2102:

! 1472		 break;

	ba	.L1513
	nop

	! block 401
.L2103:
.L2104:

! 1473	      case GL_POLYGON_SMOOTH_HINT:
! 1474		 *params = (GLdouble) ctx->Hint.PolygonSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fac),%l1
	or	%l1,%lo(0x1fac),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 402
.L2105:

! 1475		 break;

	ba	.L1513
	nop

	! block 403
.L2106:
.L2107:
.L2108:

! 1476	      case GL_POLYGON_STIPPLE:
! 1477		 for (i=0;i<32;i++) {		/* RIGHT? */

	st	%g0,[%fp-4]

	! block 404
.L_y298:
	mov	0,%l3
	sethi	%hi(0x43300000),%l5
	sethi	%hi(0xd6c8),%l4
	or	%l4,%lo(0xd6c8),%l4
.L2112:
.L2109:
.L2113:
.L2114:
.L2115:

! 1478		    params[i] = (GLdouble) ctx->PolygonStipple[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%l0
	st	%l5,[%fp-128]
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f6
	st	%l3,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-4],%l0
	sll	%l0,3,%l1
	add	%l2,%l1,%g1
	st	%f4,[%g1]
	st	%f5,[%g1+4]

	! block 405
.L2116:
.L2117:
.L2118:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,32
	blu	.L2109
	nop

	! block 406
.L2119:
.L2111:
.L2120:
.L2121:

! 1479		 }
! 1480		 break;

	ba	.L1513
	nop

	! block 407
.L2122:
.L2123:
.L2124:

! 1481	      case GL_PROJECTION_MATRIX:
! 1482		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 408
.L_y299:
	sethi	%hi(0x1210),%l4
	or	%l4,%lo(0x1210),%l4
.L2128:
.L2125:
.L2129:
.L2130:
.L2131:

! 1483		    params[i] = (GLdouble) ctx->ProjectionMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l3
	sll	%l3,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	sll	%l3,3,%l1
	add	%l0,%l1,%g1
	st	%f4,[%g1]
	st	%f5,[%g1+4]

	! block 409
.L2132:
.L2133:
.L2134:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L2125
	nop

	! block 410
.L2135:
.L2127:
.L2136:
.L2137:

! 1484		 }
! 1485		 break;

	ba	.L1513
	nop

	! block 411
.L2138:
.L2139:

! 1486	      case GL_PROJECTION_STACK_DEPTH:
! 1487		 *params = (GLdouble) ctx->ProjectionStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1250),%l1
	or	%l1,%lo(0x1250),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 412
.L2140:

! 1488		 break;

	ba	.L1513
	nop

	! block 413
.L2141:
.L2142:

! 1489	      case GL_READ_BUFFER:
! 1490		 *params = (GLdouble) ctx->Pixel.ReadBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0xae18),%l1
	or	%l1,%lo(0xae18),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 414
.L2143:

! 1491		 break;

	ba	.L1513
	nop

	! block 415
.L2144:
.L2145:

! 1492	      case GL_RED_BIAS:
! 1493	         *params = (GLdouble) ctx->Pixel.RedBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 416
.L2146:

! 1494	         break;

	ba	.L1513
	nop

	! block 417
.L2147:
.L2148:

! 1495	      case GL_RED_BITS:
! 1496	         *params = (GLdouble) ctx->Visual->RedBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+40],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 418
.L2149:

! 1497	         break;

	ba	.L1513
	nop

	! block 419
.L2150:
.L2151:

! 1498	      case GL_RED_SCALE:
! 1499	         *params = (GLdouble) ctx->Pixel.RedScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 420
.L2152:

! 1500	         break;

	ba	.L1513
	nop

	! block 421
.L2153:
.L2154:

! 1501	      case GL_RENDER_MODE:
! 1502		 *params = (GLdouble) ctx->RenderMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 422
.L2155:

! 1503		 break;

	ba	.L1513
	nop

	! block 423
.L2156:
.L2157:

! 1504	      case GL_RGBA_MODE:
! 1505		 *params = (GLdouble) ctx->Visual->RGBAflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 424
.L2158:

! 1506		 break;

	ba	.L1513
	nop

	! block 425
.L2159:
.L2160:

! 1507	      case GL_SCISSOR_BOX:
! 1508		 params[0] = (GLdouble) ctx->Scissor.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xd74c),%l1
	or	%l1,%lo(0xd74c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 426
.L2161:

! 1509		 params[1] = (GLdouble) ctx->Scissor.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xd750),%l1
	or	%l1,%lo(0xd750),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 427
.L2162:

! 1510		 params[2] = (GLdouble) ctx->Scissor.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xd754),%l1
	or	%l1,%lo(0xd754),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 428
.L2163:

! 1511		 params[3] = (GLdouble) ctx->Scissor.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xd758),%l1
	or	%l1,%lo(0xd758),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 429
.L2164:

! 1512		 break;

	ba	.L1513
	nop

	! block 430
.L2165:
.L2166:

! 1513	      case GL_SCISSOR_TEST:
! 1514		 *params = (GLdouble) ctx->Scissor.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd748),%l1
	or	%l1,%lo(0xd748),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 431
.L2167:

! 1515		 break;

	ba	.L1513
	nop

	! block 432
.L2168:
.L2169:

! 1516	      case GL_SHADE_MODEL:
! 1517		 *params = (GLdouble) ctx->Light.ShadeModel;

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 433
.L2170:

! 1518		 break;

	ba	.L1513
	nop

	! block 434
.L2171:
.L2172:

! 1519	      case GL_SHARED_TEXTURE_PALETTE_EXT:
! 1520	         *params = (GLdouble) ctx->Texture.SharedPalette;

	ld	[%fp+68],%l0
	sethi	%hi(0xd83c),%l1
	or	%l1,%lo(0xd83c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 435
.L2173:

! 1521	         break;

	ba	.L1513
	nop

	! block 436
.L2174:
.L2175:

! 1522	      case GL_STENCIL_BITS:
! 1523	         *params = (GLdouble) ctx->Visual->StencilBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+68],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 437
.L2176:

! 1524	         break;

	ba	.L1513
	nop

	! block 438
.L2177:
.L2178:

! 1525	      case GL_STENCIL_CLEAR_VALUE:
! 1526		 *params = (GLdouble) ctx->Stencil.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0xd772),%l1
	or	%l1,%lo(0xd772),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 439
.L2179:

! 1527		 break;

	ba	.L1513
	nop

	! block 440
.L2180:
.L2181:

! 1528	      case GL_STENCIL_FAIL:
! 1529		 *params = (GLdouble) ctx->Stencil.FailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd764),%l1
	or	%l1,%lo(0xd764),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 441
.L2182:

! 1530		 break;

	ba	.L1513
	nop

	! block 442
.L2183:
.L2184:

! 1531	      case GL_STENCIL_FUNC:
! 1532		 *params = (GLdouble) ctx->Stencil.Function;

	ld	[%fp+68],%l0
	sethi	%hi(0xd760),%l1
	or	%l1,%lo(0xd760),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 443
.L2185:

! 1533		 break;

	ba	.L1513
	nop

	! block 444
.L2186:
.L2187:

! 1534	      case GL_STENCIL_PASS_DEPTH_FAIL:
! 1535		 *params = (GLdouble) ctx->Stencil.ZFailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd76c),%l1
	or	%l1,%lo(0xd76c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 445
.L2188:

! 1536		 break;

	ba	.L1513
	nop

	! block 446
.L2189:
.L2190:

! 1537	      case GL_STENCIL_PASS_DEPTH_PASS:
! 1538		 *params = (GLdouble) ctx->Stencil.ZPassFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd768),%l1
	or	%l1,%lo(0xd768),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 447
.L2191:

! 1539		 break;

	ba	.L1513
	nop

	! block 448
.L2192:
.L2193:

! 1540	      case GL_STENCIL_REF:
! 1541		 *params = (GLdouble) ctx->Stencil.Ref;

	ld	[%fp+68],%l0
	sethi	%hi(0xd770),%l1
	or	%l1,%lo(0xd770),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 449
.L2194:

! 1542		 break;

	ba	.L1513
	nop

	! block 450
.L2195:
.L2196:

! 1543	      case GL_STENCIL_TEST:
! 1544		 *params = (GLdouble) ctx->Stencil.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd75c),%l1
	or	%l1,%lo(0xd75c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 451
.L2197:

! 1545		 break;

	ba	.L1513
	nop

	! block 452
.L2198:
.L2199:

! 1546	      case GL_STENCIL_VALUE_MASK:
! 1547		 *params = (GLdouble) ctx->Stencil.ValueMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd771),%l1
	or	%l1,%lo(0xd771),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 453
.L2200:

! 1548		 break;

	ba	.L1513
	nop

	! block 454
.L2201:
.L2202:

! 1549	      case GL_STENCIL_WRITEMASK:
! 1550		 *params = (GLdouble) ctx->Stencil.WriteMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd773),%l1
	or	%l1,%lo(0xd773),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 455
.L2203:

! 1551		 break;

	ba	.L1513
	nop

	! block 456
.L2204:
.L2205:

! 1552	      case GL_STEREO:
! 1553		 *params = 0.0;   /* TODO */

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 457
.L2206:

! 1554		 break;

	ba	.L1513
	nop

	! block 458
.L2207:
.L2208:

! 1555	      case GL_SUBPIXEL_BITS:
! 1556		 *params = 0.0;   /* TODO */

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 459
.L2209:

! 1557		 break;

	ba	.L1513
	nop

	! block 460
.L2210:
.L2211:

! 1558	      case GL_TEXTURE_1D:
! 1559		 *params = (ctx->Texture.Enabled & TEXTURE_1D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L2212
	nop

	! block 461
.L2213:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2214
	std	%f4,[%fp-64]

	! block 462
.L2212:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-64]

	! block 463
.L2214:
	ldd	[%fp-64],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 464
.L2215:

! 1560		 break;

	ba	.L1513
	nop

	! block 465
.L2216:
.L2217:

! 1561	      case GL_TEXTURE_2D:
! 1562		 *params = (ctx->Texture.Enabled & TEXTURE_2D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L2218
	nop

	! block 466
.L2219:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2220
	std	%f4,[%fp-72]

	! block 467
.L2218:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-72]

	! block 468
.L2220:
	ldd	[%fp-72],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 469
.L2221:

! 1563		 break;

	ba	.L1513
	nop

	! block 470
.L2222:
.L2223:

! 1564	      case GL_TEXTURE_3D_EXT:
! 1565		 *params = (ctx->Texture.Enabled & TEXTURE_3D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L2224
	nop

	! block 471
.L2225:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2226
	std	%f4,[%fp-80]

	! block 472
.L2224:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-80]

	! block 473
.L2226:
	ldd	[%fp-80],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 474
.L2227:

! 1566		 break;

	ba	.L1513
	nop

	! block 475
.L2228:
.L2229:

! 1567	      case GL_TEXTURE_ENV_COLOR:
! 1568		 params[0] = (GLdouble) ctx->Texture.EnvColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0xd77c),%l1
	or	%l1,%lo(0xd77c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 476
.L2230:

! 1569		 params[1] = (GLdouble) ctx->Texture.EnvColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0xd780),%l1
	or	%l1,%lo(0xd780),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 477
.L2231:

! 1570		 params[2] = (GLdouble) ctx->Texture.EnvColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0xd784),%l1
	or	%l1,%lo(0xd784),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 478
.L2232:

! 1571		 params[3] = (GLdouble) ctx->Texture.EnvColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0xd788),%l1
	or	%l1,%lo(0xd788),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 479
.L2233:

! 1572		 break;

	ba	.L1513
	nop

	! block 480
.L2234:
.L2235:

! 1573	      case GL_TEXTURE_ENV_MODE:
! 1574		 *params = (GLdouble) ctx->Texture.EnvMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd778),%l1
	or	%l1,%lo(0xd778),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 481
.L2236:

! 1575		 break;

	ba	.L1513
	nop

	! block 482
.L2237:
.L2238:

! 1576	      case GL_TEXTURE_GEN_S:
! 1577		 *params = (ctx->Texture.TexGenEnabled & S_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L2239
	nop

	! block 483
.L2240:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2241
	std	%f4,[%fp-88]

	! block 484
.L2239:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-88]

	! block 485
.L2241:
	ldd	[%fp-88],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 486
.L2242:

! 1578		 break;

	ba	.L1513
	nop

	! block 487
.L2243:
.L2244:

! 1579	      case GL_TEXTURE_GEN_T:
! 1580		 *params = (ctx->Texture.TexGenEnabled & T_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,8,%l0
	be	.L2245
	nop

	! block 488
.L2246:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2247
	std	%f4,[%fp-96]

	! block 489
.L2245:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-96]

	! block 490
.L2247:
	ldd	[%fp-96],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 491
.L2248:

! 1581		 break;

	ba	.L1513
	nop

	! block 492
.L2249:
.L2250:

! 1582	      case GL_TEXTURE_GEN_R:
! 1583		 *params = (ctx->Texture.TexGenEnabled & R_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L2251
	nop

	! block 493
.L2252:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2253
	std	%f4,[%fp-104]

	! block 494
.L2251:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-104]

	! block 495
.L2253:
	ldd	[%fp-104],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 496
.L2254:

! 1584		 break;

	ba	.L1513
	nop

	! block 497
.L2255:
.L2256:

! 1585	      case GL_TEXTURE_GEN_Q:
! 1586		 *params = (ctx->Texture.TexGenEnabled & Q_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L2257
	nop

	! block 498
.L2258:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L2259
	std	%f4,[%fp-112]

	! block 499
.L2257:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-112]

	! block 500
.L2259:
	ldd	[%fp-112],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 501
.L2260:

! 1587		 break;

	ba	.L1513
	nop

	! block 502
.L2261:
.L2262:
.L2263:

! 1588	      case GL_TEXTURE_MATRIX:
! 1589	         for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 503
.L_y300:
	sethi	%hi(0x1b5c),%l4
	or	%l4,%lo(0x1b5c),%l4
.L2267:
.L2264:
.L2268:
.L2269:
.L2270:

! 1590		    params[i] = (GLdouble) ctx->TextureMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l3
	sll	%l3,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	sll	%l3,3,%l1
	add	%l0,%l1,%g1
	st	%f4,[%g1]
	st	%f5,[%g1+4]

	! block 504
.L2271:
.L2272:
.L2273:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L2264
	nop

	! block 505
.L2274:
.L2266:
.L2275:
.L2276:

! 1591		 }
! 1592		 break;

	ba	.L1513
	nop

	! block 506
.L2277:
.L2278:

! 1593	      case GL_TEXTURE_STACK_DEPTH:
! 1594		 *params = (GLdouble) ctx->TextureStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1b9c),%l1
	or	%l1,%lo(0x1b9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 507
.L2279:

! 1595		 break;

	ba	.L1513
	nop

	! block 508
.L2280:
.L2281:

! 1596	      case GL_UNPACK_ALIGNMENT:
! 1597		 *params = (GLdouble) ctx->Unpack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc8),%l1
	or	%l1,%lo(0xddc8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 509
.L2282:

! 1598		 break;

	ba	.L1513
	nop

	! block 510
.L2283:
.L2284:

! 1599	      case GL_UNPACK_LSB_FIRST:
! 1600		 *params = (GLdouble) ctx->Unpack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde1),%l1
	or	%l1,%lo(0xdde1),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 511
.L2285:

! 1601		 break;

	ba	.L1513
	nop

	! block 512
.L2286:
.L2287:

! 1602	      case GL_UNPACK_ROW_LENGTH:
! 1603		 *params = (GLdouble) ctx->Unpack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddcc),%l1
	or	%l1,%lo(0xddcc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 513
.L2288:

! 1604		 break;

	ba	.L1513
	nop

	! block 514
.L2289:
.L2290:

! 1605	      case GL_UNPACK_SKIP_PIXELS:
! 1606		 *params = (GLdouble) ctx->Unpack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd0),%l1
	or	%l1,%lo(0xddd0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 515
.L2291:

! 1607		 break;

	ba	.L1513
	nop

	! block 516
.L2292:
.L2293:

! 1608	      case GL_UNPACK_SKIP_ROWS:
! 1609		 *params = (GLdouble) ctx->Unpack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd4),%l1
	or	%l1,%lo(0xddd4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 517
.L2294:

! 1610		 break;

	ba	.L1513
	nop

	! block 518
.L2295:
.L2296:

! 1611	      case GL_UNPACK_SWAP_BYTES:
! 1612		 *params = (GLdouble) ctx->Unpack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde0),%l1
	or	%l1,%lo(0xdde0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 519
.L2297:

! 1613		 break;

	ba	.L1513
	nop

	! block 520
.L2298:
.L2299:

! 1614	      case GL_UNPACK_SKIP_IMAGES_EXT:
! 1615	         *params = (GLdouble) ctx->Unpack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xdddc),%l1
	or	%l1,%lo(0xdddc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 521
.L2300:

! 1616	         break;

	ba	.L1513
	nop

	! block 522
.L2301:
.L2302:

! 1617	      case GL_UNPACK_IMAGE_HEIGHT_EXT:
! 1618	         *params = (GLdouble) ctx->Unpack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd8),%l1
	or	%l1,%lo(0xddd8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 523
.L2303:

! 1619	         break;

	ba	.L1513
	nop

	! block 524
.L2304:
.L2305:

! 1620	      case GL_VIEWPORT:
! 1621		 params[0] = (GLdouble) ctx->Viewport.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb8),%l1
	or	%l1,%lo(0xdcb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 525
.L2306:

! 1622		 params[1] = (GLdouble) ctx->Viewport.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcbc),%l1
	or	%l1,%lo(0xdcbc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]
	st	%f5,[%l0+12]

	! block 526
.L2307:

! 1623		 params[2] = (GLdouble) ctx->Viewport.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc0),%l1
	or	%l1,%lo(0xdcc0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+16]
	st	%f5,[%l0+20]

	! block 527
.L2308:

! 1624		 params[3] = (GLdouble) ctx->Viewport.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc4),%l1
	or	%l1,%lo(0xdcc4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+24]
	st	%f5,[%l0+28]

	! block 528
.L2309:

! 1625		 break;

	ba	.L1513
	nop

	! block 529
.L2310:
.L2311:

! 1626	      case GL_ZOOM_X:
! 1627		 *params = (GLdouble) ctx->Pixel.ZoomX;

	ld	[%fp+68],%l0
	sethi	%hi(0xae50),%l1
	or	%l1,%lo(0xae50),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 530
.L2312:

! 1628		 break;

	ba	.L1513
	nop

	! block 531
.L2313:
.L2314:

! 1629	      case GL_ZOOM_Y:
! 1630		 *params = (GLdouble) ctx->Pixel.ZoomY;

	ld	[%fp+68],%l0
	sethi	%hi(0xae54),%l1
	or	%l1,%lo(0xae54),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 532
.L2315:

! 1631		 break;

	ba	.L1513
	nop

	! block 533
.L2316:
.L2317:

! 1632	      case GL_VERTEX_ARRAY_SIZE:
! 1633	         *params = (GLdouble) ctx->Array.VertexSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd2c),%l1
	or	%l1,%lo(0xdd2c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 534
.L2318:

! 1634	         break;

	ba	.L1513
	nop

	! block 535
.L2319:
.L2320:

! 1635	      case GL_VERTEX_ARRAY_TYPE:
! 1636	         *params = (GLdouble) ctx->Array.VertexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd30),%l1
	or	%l1,%lo(0xdd30),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 536
.L2321:

! 1637	         break;

	ba	.L1513
	nop

	! block 537
.L2322:
.L2323:

! 1638	      case GL_VERTEX_ARRAY_STRIDE:
! 1639	         *params = (GLdouble) ctx->Array.VertexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd34),%l1
	or	%l1,%lo(0xdd34),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 538
.L2324:

! 1640	         break;

	ba	.L1513
	nop

	! block 539
.L2325:
.L2326:

! 1641	      case GL_VERTEX_ARRAY_COUNT_EXT:
! 1642	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 540
.L2327:

! 1643	         break;

	ba	.L1513
	nop

	! block 541
.L2328:
.L2329:

! 1644	      case GL_NORMAL_ARRAY_TYPE:
! 1645	         *params = (GLdouble) ctx->Array.NormalType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd44),%l1
	or	%l1,%lo(0xdd44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 542
.L2330:

! 1646	         break;

	ba	.L1513
	nop

	! block 543
.L2331:
.L2332:

! 1647	      case GL_NORMAL_ARRAY_STRIDE:
! 1648	         *params = (GLdouble) ctx->Array.NormalStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd48),%l1
	or	%l1,%lo(0xdd48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 544
.L2333:

! 1649	         break;

	ba	.L1513
	nop

	! block 545
.L2334:
.L2335:

! 1650	      case GL_NORMAL_ARRAY_COUNT_EXT:
! 1651	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 546
.L2336:

! 1652	         break;

	ba	.L1513
	nop

	! block 547
.L2337:
.L2338:

! 1653	      case GL_COLOR_ARRAY_SIZE:
! 1654	         *params = (GLdouble) ctx->Array.ColorSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd58),%l1
	or	%l1,%lo(0xdd58),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 548
.L2339:

! 1655	         break;

	ba	.L1513
	nop

	! block 549
.L2340:
.L2341:

! 1656	      case GL_COLOR_ARRAY_TYPE:
! 1657	         *params = (GLdouble) ctx->Array.ColorType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd5c),%l1
	or	%l1,%lo(0xdd5c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 550
.L2342:

! 1658	         break;

	ba	.L1513
	nop

	! block 551
.L2343:
.L2344:

! 1659	      case GL_COLOR_ARRAY_STRIDE:
! 1660	         *params = (GLdouble) ctx->Array.ColorStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd60),%l1
	or	%l1,%lo(0xdd60),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 552
.L2345:

! 1661	         break;

	ba	.L1513
	nop

	! block 553
.L2346:
.L2347:

! 1662	      case GL_COLOR_ARRAY_COUNT_EXT:
! 1663	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 554
.L2348:

! 1664	         break;

	ba	.L1513
	nop

	! block 555
.L2349:
.L2350:

! 1665	      case GL_INDEX_ARRAY_TYPE:
! 1666	         *params = (GLdouble) ctx->Array.IndexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd70),%l1
	or	%l1,%lo(0xdd70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 556
.L2351:

! 1667	         break;

	ba	.L1513
	nop

	! block 557
.L2352:
.L2353:

! 1668	      case GL_INDEX_ARRAY_STRIDE:
! 1669	         *params = (GLdouble) ctx->Array.IndexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd74),%l1
	or	%l1,%lo(0xdd74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 558
.L2354:

! 1670	         break;

	ba	.L1513
	nop

	! block 559
.L2355:
.L2356:

! 1671	      case GL_INDEX_ARRAY_COUNT_EXT:
! 1672	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 560
.L2357:

! 1673	         break;

	ba	.L1513
	nop

	! block 561
.L2358:
.L2359:

! 1674	      case GL_TEXTURE_COORD_ARRAY_SIZE:
! 1675	         *params = (GLdouble) ctx->Array.TexCoordSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd84),%l1
	or	%l1,%lo(0xdd84),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 562
.L2360:

! 1676	         break;

	ba	.L1513
	nop

	! block 563
.L2361:
.L2362:

! 1677	      case GL_TEXTURE_COORD_ARRAY_TYPE:
! 1678	         *params = (GLdouble) ctx->Array.TexCoordType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd88),%l1
	or	%l1,%lo(0xdd88),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 564
.L2363:

! 1679	         break;

	ba	.L1513
	nop

	! block 565
.L2364:
.L2365:

! 1680	      case GL_TEXTURE_COORD_ARRAY_STRIDE:
! 1681	         *params = (GLdouble) ctx->Array.TexCoordStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd8c),%l1
	or	%l1,%lo(0xdd8c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 566
.L2366:

! 1682	         break;

	ba	.L1513
	nop

	! block 567
.L2367:
.L2368:

! 1683	      case GL_TEXTURE_COORD_ARRAY_COUNT_EXT:
! 1684	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 568
.L2369:

! 1685	         break;

	ba	.L1513
	nop

	! block 569
.L2370:
.L2371:

! 1686	      case GL_EDGE_FLAG_ARRAY_STRIDE:
! 1687	         *params = (GLdouble) ctx->Array.EdgeFlagStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd9c),%l1
	or	%l1,%lo(0xdd9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitod	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 570
.L2372:

! 1688	         break;

	ba	.L1513
	nop

	! block 571
.L2373:
.L2374:

! 1689	      case GL_EDGE_FLAG_ARRAY_COUNT_EXT:
! 1690	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 572
.L2375:

! 1691	         break;

	ba	.L1513
	nop

	! block 573
.L2376:
.L2377:

! 1692	      case GL_TEXTURE_BINDING_1D:
! 1693	         *params = (GLdouble) ctx->Texture.Current1D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 574
.L2378:

! 1694	          break;

	ba	.L1513
	nop

	! block 575
.L2379:
.L2380:

! 1695	      case GL_TEXTURE_BINDING_2D:
! 1696	         *params = (GLdouble) ctx->Texture.Current2D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 576
.L2381:

! 1697	          break;

	ba	.L1513
	nop

	! block 577
.L2382:
.L2383:

! 1698	      case GL_TEXTURE_3D_BINDING_EXT:
! 1699	         *params = (GLdouble) ctx->Texture.Current3D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]
	st	%f5,[%l0+4]

	! block 578
.L2384:

! 1700	          break;

	ba	.L1513
	nop

	! block 579
.L2385:
.L2386:

! 1702	      default:
! 1703	         gl_error( ctx, GL_INVALID_ENUM, "glGetDoublev" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2387),%l1
	or	%l1,%lo(.L2387),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 580
.L2388:
.L2389:
	ba	.L1513
	nop

	! block 581
.L1514:
.L2390:
	ld	[%fp+72],%l2
	cmp	%l2,3344
	bge	.L_y74
	nop

	! block 582
	cmp	%l2,2976
	bge	.L_y75
	nop

	! block 583
	cmp	%l2,2896
	bge	.L_y76
	nop

	! block 584
	cmp	%l2,2848
	bge	.L_y77
	nop

	! block 585
	sub	%l2,2816,%l0
	cmp	%l0,19
	bgu	.L2385
	nop

	! block 586
	sll	%l0,2,%l1
	sethi	%hi(.L_y78-80),%l0
	or	%l0,%lo(.L_y78-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 587
.L_y77:
	cmp	%l2,2880
	bge	.L_y79
	nop

	! block 588
	cmp	%l2,2864
	bge	.L_y80
	nop

	! block 589
	sub	%l2,2848,%l0
	cmp	%l0,6
	bgu	.L2385
	nop

	! block 590
	sll	%l0,2,%l1
	sethi	%hi(.L_y81-28),%l0
	or	%l0,%lo(.L_y81-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 591
.L_y80:
	sub	%l2,2864,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 592
	sll	%l0,2,%l1
	sethi	%hi(.L_y82-16),%l0
	or	%l0,%lo(.L_y82-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 593
.L_y79:
	sub	%l2,2880,%l0
	cmp	%l0,6
	bgu	.L2385
	nop

	! block 594
	sll	%l0,2,%l1
	sethi	%hi(.L_y83-28),%l0
	or	%l0,%lo(.L_y83-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 595
.L_y76:
	cmp	%l2,2928
	bge	.L_y84
	nop

	! block 596
	cmp	%l2,2912
	bge	.L_y85
	nop

	! block 597
	sub	%l2,2896,%l0
	cmp	%l0,7
	bgu	.L2385
	nop

	! block 598
	sll	%l0,2,%l1
	sethi	%hi(.L_y86-32),%l0
	or	%l0,%lo(.L_y86-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 599
.L_y85:
	sub	%l2,2912,%l0
	cmp	%l0,6
	bgu	.L2385
	nop

	! block 600
	sll	%l0,2,%l1
	sethi	%hi(.L_y87-28),%l0
	or	%l0,%lo(.L_y87-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 601
.L_y84:
	cmp	%l2,2960
	bge	.L_y88
	nop

	! block 602
	cmp	%l2,2944
	bge	.L_y89
	nop

	! block 603
	sub	%l2,2928,%l0
	cmp	%l0,4
	bgu	.L2385
	nop

	! block 604
	sll	%l0,2,%l1
	sethi	%hi(.L_y90-20),%l0
	or	%l0,%lo(.L_y90-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 605
.L_y89:
	be	.L1524
	nop

	! block 606
	ba	.L2385
	nop

	! block 607
.L_y88:
	sub	%l2,2960,%l0
	cmp	%l0,8
	bgu	.L2385
	nop

	! block 608
	sll	%l0,2,%l1
	sethi	%hi(.L_y91-36),%l0
	or	%l0,%lo(.L_y91-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 609
.L_y75:
	cmp	%l2,3136
	bge	.L_y92
	nop

	! block 610
	cmp	%l2,3056
	bge	.L_y93
	nop

	! block 611
	cmp	%l2,2992
	bge	.L_y94
	nop

	! block 612
	sub	%l2,2976,%l0
	cmp	%l0,8
	bgu	.L2385
	nop

	! block 613
	sll	%l0,2,%l1
	sethi	%hi(.L_y95-36),%l0
	or	%l0,%lo(.L_y95-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 614
.L_y94:
	cmp	%l2,3024
	bge	.L_y96
	nop

	! block 615
	cmp	%l2,3008
	bge	.L_y97
	nop

	! block 616
	cmp	%l2,2992
	be	.L1548
	nop

	! block 617
	cmp	%l2,2993
	be	.L1584
	nop

	! block 618
	ba	.L2385
	nop

	! block 619
.L_y97:
	sub	%l2,3008,%l0
	cmp	%l0,2
	bgu	.L2385
	nop

	! block 620
	sll	%l0,2,%l1
	sethi	%hi(.L_y98-12),%l0
	or	%l0,%lo(.L_y98-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 621
.L_y96:
	cmp	%l2,3040
	bge	.L_y99
	nop

	! block 622
	cmp	%l2,3024
	be	.L1706
	nop

	! block 623
	ba	.L2385
	nop

	! block 624
.L_y99:
	sub	%l2,3040,%l0
	cmp	%l0,2
	bgu	.L2385
	nop

	! block 625
	sll	%l0,2,%l1
	sethi	%hi(.L_y100-12),%l0
	or	%l0,%lo(.L_y100-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 626
.L_y93:
	cmp	%l2,3104
	bge	.L_y101
	nop

	! block 627
	cmp	%l2,3072
	bge	.L_y102
	nop

	! block 628
	sub	%l2,3056,%l0
	cmp	%l0,2
	bgu	.L2385
	nop

	! block 629
	sll	%l0,2,%l1
	sethi	%hi(.L_y103-12),%l0
	or	%l0,%lo(.L_y103-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 630
.L_y102:
	cmp	%l2,3088
	bge	.L_y104
	nop

	! block 631
	sub	%l2,3072,%l0
	cmp	%l0,2
	bgu	.L2385
	nop

	! block 632
	sll	%l0,2,%l1
	sethi	%hi(.L_y105-12),%l0
	or	%l0,%lo(.L_y105-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 633
.L_y104:
	be	.L2159
	nop

	! block 634
	cmp	%l2,3089
	be	.L2165
	nop

	! block 635
	ba	.L2385
	nop

	! block 636
.L_y101:
	cmp	%l2,3120
	bge	.L_y106
	nop

	! block 637
	sub	%l2,3104,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 638
	sll	%l0,2,%l1
	sethi	%hi(.L_y107-16),%l0
	or	%l0,%lo(.L_y107-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 639
.L_y106:
	sub	%l2,3120,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 640
	sll	%l0,2,%l1
	sethi	%hi(.L_y108-16),%l0
	or	%l0,%lo(.L_y108-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 641
.L_y92:
	cmp	%l2,3312
	bge	.L_y109
	nop

	! block 642
	cmp	%l2,3248
	bge	.L_y110
	nop

	! block 643
	cmp	%l2,3168
	bge	.L_y111
	nop

	! block 644
	cmp	%l2,3152
	bge	.L_y112
	nop

	! block 645
	cmp	%l2,3136
	be	.L2153
	nop

	! block 646
	ba	.L2385
	nop

	! block 647
.L_y112:
	sub	%l2,3152,%l0
	cmp	%l0,4
	bgu	.L2385
	nop

	! block 648
	sll	%l0,2,%l1
	sethi	%hi(.L_y113-20),%l0
	or	%l0,%lo(.L_y113-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 649
.L_y111:
	sub	%l2,3168,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 650
	sll	%l0,2,%l1
	sethi	%hi(.L_y114-16),%l0
	or	%l0,%lo(.L_y114-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 651
.L_y110:
	sub	%l2,3248,%l0
	cmp	%l0,9
	bgu	.L2385
	nop

	! block 652
	sll	%l0,2,%l1
	sethi	%hi(.L_y115-40),%l0
	or	%l0,%lo(.L_y115-40),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 653
.L_y109:
	cmp	%l2,3328
	bge	.L_y116
	nop

	! block 654
	sub	%l2,3312,%l0
	cmp	%l0,5
	bgu	.L2385
	nop

	! block 655
	sll	%l0,2,%l1
	sethi	%hi(.L_y117-24),%l0
	or	%l0,%lo(.L_y117-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 656
.L_y116:
	sub	%l2,3328,%l0
	cmp	%l0,5
	bgu	.L2385
	nop

	! block 657
	sll	%l0,2,%l1
	sethi	%hi(.L_y118-24),%l0
	or	%l0,%lo(.L_y118-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 658
.L_y74:
	cmp	%l2,3536
	bge	.L_y119
	nop

	! block 659
	cmp	%l2,3408
	bge	.L_y120
	nop

	! block 660
	cmp	%l2,3376
	bge	.L_y121
	nop

	! block 661
	sub	%l2,3344,%l0
	cmp	%l0,15
	bgu	.L2385
	nop

	! block 662
	sll	%l0,2,%l1
	sethi	%hi(.L_y122-64),%l0
	or	%l0,%lo(.L_y122-64),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 663
.L_y121:
	sub	%l2,3376,%l0
	cmp	%l0,11
	bgu	.L2385
	nop

	! block 664
	sll	%l0,2,%l1
	sethi	%hi(.L_y123-48),%l0
	or	%l0,%lo(.L_y123-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 665
.L_y120:
	cmp	%l2,3472
	bge	.L_y124
	nop

	! block 666
	cmp	%l2,3440
	bge	.L_y125
	nop

	! block 667
	sub	%l2,3408,%l0
	cmp	%l0,11
	bgu	.L2385
	nop

	! block 668
	sll	%l0,2,%l1
	sethi	%hi(.L_y126-48),%l0
	or	%l0,%lo(.L_y126-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 669
.L_y125:
	be	.L1994
	nop

	! block 670
	cmp	%l2,3456
	be	.L1551
	nop

	! block 671
	ba	.L2385
	nop

	! block 672
.L_y124:
	cmp	%l2,3504
	bge	.L_y127
	nop

	! block 673
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L2385
	nop

	! block 674
	sll	%l0,2,%l1
	sethi	%hi(.L_y128-36),%l0
	or	%l0,%lo(.L_y128-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 675
.L_y127:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L2385
	nop

	! block 676
	sll	%l0,2,%l1
	sethi	%hi(.L_y129-36),%l0
	or	%l0,%lo(.L_y129-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 677
.L_y119:
	sethi	%hi(0x8068),%l0
	or	%l0,%lo(0x8068),%l0
	cmp	%l2,%l0
	bge	.L_y130
	nop

	! block 678
	sethi	%hi(0x4000),%l0
	cmp	%l2,%l0
	bge	.L_y131
	nop

	! block 679
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	bge	.L_y132
	nop

	! block 680
	cmp	%l2,3552
	bge	.L_y133
	nop

	! block 681
	sub	%l2,3536,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 682
	sll	%l0,2,%l1
	sethi	%hi(.L_y134-16),%l0
	or	%l0,%lo(.L_y134-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 683
.L_y133:
	cmp	%l2,3569
	bge	.L_y135
	nop

	! block 684
	cmp	%l2,3552
	be	.L2210
	nop

	! block 685
	cmp	%l2,3553
	be	.L2216
	nop

	! block 686
	ba	.L2385
	nop

	! block 687
.L_y135:
	be	.L1718
	nop

	! block 688
	cmp	%l2,3570
	be	.L1721
	nop

	! block 689
	ba	.L2385
	nop

	! block 690
.L_y132:
	sethi	%hi(0x3000),%l0
	cmp	%l2,%l0
	bge	.L_y136
	nop

	! block 691
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	bge	.L_y137
	nop

	! block 692
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	be	.L2234
	nop

	! block 693
	sethi	%hi(0x2201),%l0
	or	%l0,%lo(0x2201),%l0
	cmp	%l2,%l0
	be	.L2228
	nop

	! block 694
	ba	.L2385
	nop

	! block 695
.L_y137:
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	be	.L2097
	nop

	! block 696
	ba	.L2385
	nop

	! block 697
.L_y136:
	sethi	%hi(0x3000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L2385
	nop

	! block 698
	sll	%l0,2,%l1
	sethi	%hi(.L_y138-24),%l0
	or	%l0,%lo(.L_y138-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 699
.L_y131:
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	bge	.L_y139
	nop

	! block 700
	sethi	%hi(0x4000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L2385
	nop

	! block 701
	sll	%l0,2,%l1
	sethi	%hi(.L_y140-32),%l0
	or	%l0,%lo(.L_y140-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 702
.L_y139:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	bge	.L_y141
	nop

	! block 703
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	be	.L1569
	nop

	! block 704
	sethi	%hi(0x8009),%l0
	or	%l0,%lo(0x8009),%l0
	cmp	%l2,%l0
	be	.L1566
	nop

	! block 705
	ba	.L2385
	nop

	! block 706
.L_y141:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	be	.L2094
	nop

	! block 707
	sethi	%hi(0x8039),%l0
	or	%l0,%lo(0x8039),%l0
	cmp	%l2,%l0
	be	.L2091
	nop

	! block 708
	ba	.L2385
	nop

	! block 709
.L_y130:
	sethi	%hi(0x807a),%l0
	or	%l0,%lo(0x807a),%l0
	cmp	%l2,%l0
	bge	.L_y142
	nop

	! block 710
	sethi	%hi(0x8068),%l1
	or	%l1,%lo(0x8068),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L2385
	nop

	! block 711
	sll	%l0,2,%l1
	sethi	%hi(.L_y143-32),%l0
	or	%l0,%lo(.L_y143-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 712
.L_y142:
	sethi	%hi(0x8126),%l0
	or	%l0,%lo(0x8126),%l0
	cmp	%l2,%l0
	bge	.L_y144
	nop

	! block 713
	sethi	%hi(0x807a),%l1
	or	%l1,%lo(0x807a),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,19
	bgu	.L2385
	nop

	! block 714
	sll	%l0,2,%l1
	sethi	%hi(.L_y145-80),%l0
	or	%l0,%lo(.L_y145-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 715
.L_y144:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	bge	.L_y146
	nop

	! block 716
	sethi	%hi(0x8126),%l1
	or	%l1,%lo(0x8126),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,3
	bgu	.L2385
	nop

	! block 717
	sll	%l0,2,%l1
	sethi	%hi(.L_y147-16),%l0
	or	%l0,%lo(.L_y147-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 718
.L_y146:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	be	.L2171
	nop

	! block 719
	ba	.L2385
	nop

	! block 720
.L2391:
.L1513:
.L2392:

	! block 721
.L2393:
.L2394:
.L1496:
	jmp	%i7+8
	restore
	.size	gl_GetDoublev,(.-gl_GetDoublev)

	.word	.L1634
	.word	.L1640
	.word	.L1643
	.word	.L1675
	.word	.L1648
	.word	.L1657
	.word	.L1666
	.word	.L1660
	.word	.L1672
	.word	.L1654
	.word	.L2385
	.word	.L2385
	.word	.L2385
	.word	.L2385
	.word	.L2385
	.word	.L2385
	.word	.L2067
	.word	.L2057
	.word	.L2063
	.word	.L2060
.L_y78:
	.word	.L1809
	.word	.L1824
	.word	.L1830
	.word	.L1827
	.word	.L1815
	.word	.L1818
	.word	.L1821
.L_y81:
	.word	.L1840
	.word	.L1950
	.word	.L1834
	.word	.L1837
.L_y82:
	.word	.L2087
	.word	.L2100
	.word	.L2106
	.word	.L1715
	.word	.L1628
	.word	.L1631
	.word	.L1751
.L_y83:
	.word	.L1794
	.word	.L1803
	.word	.L1806
	.word	.L1797
	.word	.L2168
	.word	.L1604
	.word	.L1607
	.word	.L1601
.L_y86:
	.word	.L1724
	.word	.L1742
	.word	.L1733
	.word	.L1748
	.word	.L1736
	.word	.L1745
	.word	.L1727
.L_y87:
	.word	.L1693
	.word	.L1700
	.word	.L1703
	.word	.L1687
	.word	.L1690
.L_y90:
	.word	.L2195
	.word	.L2177
	.word	.L2183
	.word	.L2198
	.word	.L2180
	.word	.L2186
	.word	.L2189
	.word	.L2192
	.word	.L2201
.L_y91:
	.word	.L1932
	.word	.L1997
	.word	.L2304
	.word	.L1991
	.word	.L2138
	.word	.L2277
	.word	.L1975
	.word	.L2122
	.word	.L2261
.L_y95:
	.word	.L1539
	.word	.L1542
	.word	.L1545
.L_y98:
	.word	.L1560
	.word	.L1563
	.word	.L1557
.L_y100:
	.word	.L1852
	.word	.L1846
	.word	.L1849
.L_y103:
	.word	.L1554
	.word	.L1712
	.word	.L2141
.L_y105:
	.word	.L1766
	.word	.L1781
	.word	.L1595
	.word	.L1610
.L_y107:
	.word	.L1769
	.word	.L2156
	.word	.L1709
	.word	.L2204
.L_y108:
	.word	.L2024
	.word	.L2070
	.word	.L1812
	.word	.L2103
	.word	.L1739
.L_y113:
	.word	.L2237
	.word	.L2243
	.word	.L2249
	.word	.L2255
.L_y114:
	.word	.L2045
	.word	.L2054
	.word	.L2048
	.word	.L2042
	.word	.L2039
	.word	.L2036
	.word	.L2051
	.word	.L2033
	.word	.L2030
	.word	.L2027
.L_y115:
	.word	.L2295
	.word	.L2283
	.word	.L2286
	.word	.L2292
	.word	.L2289
	.word	.L2280
.L_y117:
	.word	.L2015
	.word	.L2003
	.word	.L2006
	.word	.L2012
	.word	.L2009
	.word	.L2000
.L_y118:
	.word	.L1926
	.word	.L1929
	.word	.L1778
	.word	.L1775
	.word	.L2150
	.word	.L2144
	.word	.L2310
	.word	.L2313
	.word	.L1760
	.word	.L1754
	.word	.L1581
	.word	.L1575
	.word	.L1536
	.word	.L1530
	.word	.L1697
	.word	.L1681
.L_y122:
	.word	.L1944
	.word	.L1947
	.word	.L1941
	.word	.L1965
	.word	.L1959
	.word	.L1935
	.word	.L1953
	.word	.L1956
	.word	.L1962
	.word	.L1968
	.word	.L1971
	.word	.L1938
.L_y123:
	.word	.L2207
	.word	.L1763
	.word	.L2147
	.word	.L1757
	.word	.L1578
	.word	.L1533
	.word	.L1684
	.word	.L2174
	.word	.L1518
	.word	.L1519
	.word	.L1520
	.word	.L1521
.L_y126:
	.word	.L1855
	.word	.L1865
	.word	.L1868
	.word	.L1871
	.word	.L1874
	.word	.L1877
	.word	.L1880
	.word	.L1883
	.word	.L1886
.L_y128:
	.word	.L1889
	.word	.L1902
	.word	.L1905
	.word	.L1908
	.word	.L1911
	.word	.L1914
	.word	.L1917
	.word	.L1920
	.word	.L1923
.L_y129:
	.word	.L1858
	.word	.L1862
	.word	.L1892
	.word	.L1898
.L_y134:
	.word	.L1587
	.word	.L1588
	.word	.L1589
	.word	.L1590
	.word	.L1591
	.word	.L1592
.L_y138:
	.word	.L1784
	.word	.L1785
	.word	.L1786
	.word	.L1787
	.word	.L1788
	.word	.L1789
	.word	.L1790
	.word	.L1791
.L_y140:
	.word	.L2376
	.word	.L2379
	.word	.L2382
	.word	.L2018
	.word	.L2021
	.word	.L2298
	.word	.L2301
	.word	.L2222
.L_y143:
	.word	.L2316
	.word	.L2319
	.word	.L2322
	.word	.L2325
	.word	.L2328
	.word	.L2331
	.word	.L2334
	.word	.L2337
	.word	.L2340
	.word	.L2343
	.word	.L2346
	.word	.L2349
	.word	.L2352
	.word	.L2355
	.word	.L2358
	.word	.L2361
	.word	.L2364
	.word	.L2367
	.word	.L2370
	.word	.L2373
.L_y145:
	.word	.L2073
	.word	.L2076
	.word	.L2079
	.word	.L2082
.L_y147:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetFloatv
	.type	gl_GetFloatv,#function
gl_GetFloatv:
	save	%sp,-200,%sp

	! block 1
.L2397:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L2398:
.L2400:
.L2402:

! File get.c:
! 1704	   }
! 1705	}
! 1706	
! 1710	void gl_GetFloatv( GLcontext *ctx, GLenum pname, GLfloat *params )
! 1711	{
! 1712	   GLuint i;
! 1713	
! 1714	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L2401
	nop

	! block 3
.L2403:
.L2404:
.L2405:
.L2406:

! 1715	      gl_error( ctx, GL_INVALID_OPERATION, "glGetFloatv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2407),%l1
	or	%l1,%lo(.L2407),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L2408:

! 1716	      return;

	ba	.L2396
	nop

	! block 5
.L2409:
.L2410:
.L2401:
.L2411:
.L2412:
.L2415:

! 1717	   }
! 1718	   switch (pname) {

	ba	.L2414
	nop

	! block 6
.L2416:
.L2417:
.L2418:
.L2419:
.L2420:
.L2421:
.L2422:

! 1719	      case GL_ACCUM_RED_BITS:
! 1720	      case GL_ACCUM_GREEN_BITS:
! 1721	      case GL_ACCUM_BLUE_BITS:
! 1722	      case GL_ACCUM_ALPHA_BITS:
! 1723	         *params = (GLfloat) ctx->Visual->AccumBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+60],%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 7
.L2423:

! 1724	         break;

	ba	.L2413
	nop

	! block 8
.L2424:
.L2425:

! 1725	      case GL_ACCUM_CLEAR_VALUE:
! 1726	         params[0] = ctx->Accum.ClearColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 9
.L2426:

! 1727	         params[1] = ctx->Accum.ClearColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 10
.L2427:

! 1728	         params[2] = ctx->Accum.ClearColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 11
.L2428:

! 1729	         params[3] = ctx->Accum.ClearColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 12
.L2429:

! 1730	         break;

	ba	.L2413
	nop

	! block 13
.L2430:
.L2431:

! 1731	      case GL_ALPHA_BIAS:
! 1732	         *params = ctx->Pixel.AlphaBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 14
.L2432:

! 1733	         break;

	ba	.L2413
	nop

	! block 15
.L2433:
.L2434:

! 1734	      case GL_ALPHA_BITS:
! 1735	         *params = (GLfloat) ctx->Visual->AlphaBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-92]
	ld	[%fp-92],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 16
.L2435:

! 1736	         break;

	ba	.L2413
	nop

	! block 17
.L2436:
.L2437:

! 1737	      case GL_ALPHA_SCALE:
! 1738	         *params = ctx->Pixel.AlphaScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 18
.L2438:

! 1739	         break;

	ba	.L2413
	nop

	! block 19
.L2439:
.L2440:

! 1740	      case GL_ALPHA_TEST:
! 1741	         *params = (GLfloat) ctx->Color.AlphaEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea0),%l1
	or	%l1,%lo(0x1ea0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 20
.L2441:

! 1742	         break;

	ba	.L2413
	nop

	! block 21
.L2442:
.L2443:

! 1743	      case GL_ALPHA_TEST_FUNC:
! 1744	         *params = (GLfloat) ctx->Color.AlphaFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea4),%l1
	or	%l1,%lo(0x1ea4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 22
.L2444:

! 1745	         break;

	ba	.L2413
	nop

	! block 23
.L2445:
.L2446:

! 1746	      case GL_ALPHA_TEST_REF:
! 1747	         *params = (GLfloat) ctx->Color.AlphaRef;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea8),%l1
	or	%l1,%lo(0x1ea8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 24
.L2447:

! 1748	         break;

	ba	.L2413
	nop

	! block 25
.L2448:
.L2449:

! 1749	      case GL_ATTRIB_STACK_DEPTH:
! 1750	         *params = (GLfloat ) ctx->AttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e28),%l1
	or	%l1,%lo(0x1e28),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 26
.L2450:

! 1751	         break;

	ba	.L2413
	nop

	! block 27
.L2451:
.L2452:

! 1752	      case GL_AUTO_NORMAL:
! 1753	         *params = (GLfloat) ctx->Eval.AutoNormal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 28
.L2453:

! 1754	         break;

	ba	.L2413
	nop

	! block 29
.L2454:
.L2455:

! 1755	      case GL_AUX_BUFFERS:
! 1756	         *params = (GLfloat) NUM_AUX_BUFFERS;

	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 30
.L2456:

! 1757	         break;

	ba	.L2413
	nop

	! block 31
.L2457:
.L2458:

! 1758	      case GL_BLEND:
! 1759	         *params = (GLfloat) ctx->Color.BlendEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ead),%l1
	or	%l1,%lo(0x1ead),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 32
.L2459:

! 1760	         break;

	ba	.L2413
	nop

	! block 33
.L2460:
.L2461:

! 1761	      case GL_BLEND_DST:
! 1762	         *params = (GLfloat) ctx->Color.BlendDst;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb4),%l1
	or	%l1,%lo(0x1eb4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 34
.L2462:

! 1763	         break;

	ba	.L2413
	nop

	! block 35
.L2463:
.L2464:

! 1764	      case GL_BLEND_SRC:
! 1765	         *params = (GLfloat) ctx->Color.BlendSrc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb0),%l1
	or	%l1,%lo(0x1eb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 36
.L2465:

! 1766	         break;

	ba	.L2413
	nop

	! block 37
.L2466:
.L2467:

! 1767	      case GL_BLEND_EQUATION_EXT:
! 1768		 *params = (GLfloat) ctx->Color.BlendEquation;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb8),%l1
	or	%l1,%lo(0x1eb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 38
.L2468:

! 1769		 break;

	ba	.L2413
	nop

	! block 39
.L2469:
.L2470:

! 1770	      case GL_BLEND_COLOR_EXT:
! 1771		 params[0] = ctx->Color.BlendColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ebc),%l1
	or	%l1,%lo(0x1ebc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 40
.L2471:

! 1772		 params[1] = ctx->Color.BlendColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec0),%l1
	or	%l1,%lo(0x1ec0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 41
.L2472:

! 1773		 params[2] = ctx->Color.BlendColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec4),%l1
	or	%l1,%lo(0x1ec4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 42
.L2473:

! 1774		 params[3] = ctx->Color.BlendColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec8),%l1
	or	%l1,%lo(0x1ec8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 43
.L2474:

! 1775		 break;

	ba	.L2413
	nop

	! block 44
.L2475:
.L2476:

! 1776	      case GL_BLUE_BIAS:
! 1777	         *params = ctx->Pixel.BlueBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 45
.L2477:

! 1778	         break;

	ba	.L2413
	nop

	! block 46
.L2478:
.L2479:

! 1779	      case GL_BLUE_BITS:
! 1780	         *params = (GLfloat) ctx->Visual->BlueBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+48],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 47
.L2480:

! 1781	         break;

	ba	.L2413
	nop

	! block 48
.L2481:
.L2482:

! 1782	      case GL_BLUE_SCALE:
! 1783	         *params = ctx->Pixel.BlueScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 49
.L2483:

! 1784	         break;

	ba	.L2413
	nop

	! block 50
.L2484:
.L2485:

! 1785	      case GL_CLIENT_ATTRIB_STACK_DEPTH:
! 1786	         *params = (GLfloat) ctx->ClientAttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdce8),%l1
	or	%l1,%lo(0xdce8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 51
.L2486:

! 1787	         break;

	ba	.L2413
	nop

	! block 52
.L2487:
.L2488:
.L2489:
.L2490:
.L2491:
.L2492:
.L2493:

! 1788	      case GL_CLIP_PLANE0:
! 1789	      case GL_CLIP_PLANE1:
! 1790	      case GL_CLIP_PLANE2:
! 1791	      case GL_CLIP_PLANE3:
! 1792	      case GL_CLIP_PLANE4:
! 1793	      case GL_CLIP_PLANE5:
! 1794	         *params = (GLfloat) ctx->Transform.ClipEnabled[pname-GL_CLIP_PLANE0];

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb0),%l1
	or	%l1,%lo(0xdcb0),%l1
	add	%l0,%l1,%l0
	ld	[%fp+72],%l1
	add	%l0,%l1,%l0
	sethi	%hi(0x3000),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 53
.L2494:

! 1795	         break;

	ba	.L2413
	nop

	! block 54
.L2495:
.L2496:

! 1796	      case GL_COLOR_CLEAR_VALUE:
! 1797	         params[0] = (GLfloat) ctx->Color.ClearColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e80),%l1
	or	%l1,%lo(0x1e80),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 55
.L2497:

! 1798	         params[1] = (GLfloat) ctx->Color.ClearColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e84),%l1
	or	%l1,%lo(0x1e84),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 56
.L2498:

! 1799	         params[2] = (GLfloat) ctx->Color.ClearColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e88),%l1
	or	%l1,%lo(0x1e88),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 57
.L2499:

! 1800	         params[3] = (GLfloat) ctx->Color.ClearColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1e8c),%l1
	or	%l1,%lo(0x1e8c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 58
.L2500:

! 1801	         break;

	ba	.L2413
	nop

	! block 59
.L2501:
.L2502:

! 1802	      case GL_COLOR_MATERIAL:
! 1803	         *params = (GLfloat) ctx->Light.ColorMaterialEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xaddc),%l1
	or	%l1,%lo(0xaddc),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 60
.L2503:

! 1804	         break;

	ba	.L2413
	nop

	! block 61
.L2504:
.L2505:

! 1805	      case GL_COLOR_MATERIAL_FACE:
! 1806	         *params = (GLfloat) ctx->Light.ColorMaterialFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd0),%l1
	or	%l1,%lo(0xadd0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 62
.L2506:

! 1807	         break;

	ba	.L2413
	nop

	! block 63
.L2507:
.L2508:

! 1808	      case GL_COLOR_MATERIAL_PARAMETER:
! 1809	         *params = (GLfloat) ctx->Light.ColorMaterialMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd4),%l1
	or	%l1,%lo(0xadd4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 64
.L2509:

! 1810	         break;

	ba	.L2413
	nop

	! block 65
.L2510:
.L2511:

! 1811	      case GL_COLOR_WRITEMASK:
! 1812	         params[0] = (ctx->Color.ColorMask & 8) ? 1.0F : 0.0F;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,8,%l0
	be	.L2512
	nop

	! block 66
.L2513:
	sethi	%hi(.L_cseg17),%l0
	ld	[%l0+%lo(.L_cseg17)],%f4
	ba	.L2514
	st	%f4,[%fp-8]

	! block 67
.L2512:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	st	%f4,[%fp-8]

	! block 68
.L2514:
	ld	[%fp-8],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 69
.L2515:

! 1813	         params[1] = (ctx->Color.ColorMask & 4) ? 1.0F : 0.0F;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L2516
	nop

	! block 70
.L2517:
	sethi	%hi(.L_cseg17),%l0
	ld	[%l0+%lo(.L_cseg17)],%f4
	ba	.L2518
	st	%f4,[%fp-12]

	! block 71
.L2516:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	st	%f4,[%fp-12]

	! block 72
.L2518:
	ld	[%fp-12],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 73
.L2519:

! 1814	         params[2] = (ctx->Color.ColorMask & 2) ? 1.0F : 0.0F;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L2520
	nop

	! block 74
.L2521:
	sethi	%hi(.L_cseg17),%l0
	ld	[%l0+%lo(.L_cseg17)],%f4
	ba	.L2522
	st	%f4,[%fp-16]

	! block 75
.L2520:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	st	%f4,[%fp-16]

	! block 76
.L2522:
	ld	[%fp-16],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 77
.L2523:

! 1815	         params[3] = (ctx->Color.ColorMask & 1) ? 1.0F : 0.0F;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L2524
	nop

	! block 78
.L2525:
	sethi	%hi(.L_cseg17),%l0
	ld	[%l0+%lo(.L_cseg17)],%f4
	ba	.L2526
	st	%f4,[%fp-20]

	! block 79
.L2524:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	st	%f4,[%fp-20]

	! block 80
.L2526:
	ld	[%fp-20],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 81
.L2527:

! 1816	         break;

	ba	.L2413
	nop

	! block 82
.L2528:
.L2529:

! 1817	      case GL_CULL_FACE:
! 1818	         *params = (GLfloat) ctx->Polygon.CullFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6ad),%l1
	or	%l1,%lo(0xd6ad),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 83
.L2530:

! 1819	         break;

	ba	.L2413
	nop

	! block 84
.L2531:
.L2532:

! 1820	      case GL_CULL_FACE_MODE:
! 1821	         *params = (GLfloat) ctx->Polygon.CullFaceMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b0),%l1
	or	%l1,%lo(0xd6b0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 85
.L2533:

! 1822	         break;

	ba	.L2413
	nop

	! block 86
.L2534:
.L2535:

! 1823	      case GL_CURRENT_COLOR:
! 1824	         params[0] = ctx->Current.ByteColor[0] * ctx->Visual->InvRedScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f4
	fmuls	%f5,%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 87
.L2536:

! 1825	         params[1] = ctx->Current.ByteColor[1] * ctx->Visual->InvGreenScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f4
	fmuls	%f5,%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 88
.L2537:

! 1826	         params[2] = ctx->Current.ByteColor[2] * ctx->Visual->InvBlueScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+2],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f4
	fmuls	%f5,%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 89
.L2538:

! 1827	         params[3] = ctx->Current.ByteColor[3] * ctx->Visual->InvAlphaScale;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+3],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f4
	fmuls	%f5,%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 90
.L2539:

! 1828	         break;

	ba	.L2413
	nop

	! block 91
.L2540:
.L2541:

! 1829	      case GL_CURRENT_INDEX:
! 1830	         *params = (GLfloat) ctx->Current.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 92
.L2542:

! 1831	         break;

	ba	.L2413
	nop

	! block 93
.L2543:
.L2544:

! 1832	      case GL_CURRENT_NORMAL:
! 1833	         params[0] = ctx->Current.Normal[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 94
.L2545:

! 1834	         params[1] = ctx->Current.Normal[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 95
.L2546:

! 1835	         params[2] = ctx->Current.Normal[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 96
.L2547:

! 1836	         break;

	ba	.L2413
	nop

	! block 97
.L2548:
.L2549:

! 1837	      case GL_CURRENT_RASTER_COLOR:
! 1838		 params[0] = ctx->Current.RasterColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f0c),%l1
	or	%l1,%lo(0x1f0c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 98
.L2550:

! 1839		 params[1] = ctx->Current.RasterColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f10),%l1
	or	%l1,%lo(0x1f10),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 99
.L2551:

! 1840		 params[2] = ctx->Current.RasterColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f14),%l1
	or	%l1,%lo(0x1f14),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 100
.L2552:

! 1841		 params[3] = ctx->Current.RasterColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f18),%l1
	or	%l1,%lo(0x1f18),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 101
.L2553:

! 1842		 break;

	ba	.L2413
	nop

	! block 102
.L2554:
.L2555:

! 1843	      case GL_CURRENT_RASTER_DISTANCE:
! 1844		 params[0] = ctx->Current.RasterDistance;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f08),%l1
	or	%l1,%lo(0x1f08),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 103
.L2556:

! 1845		 break;

	ba	.L2413
	nop

	! block 104
.L2557:
.L2558:

! 1846	      case GL_CURRENT_RASTER_INDEX:
! 1847		 *params = (GLfloat) ctx->Current.RasterIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f1c),%l1
	or	%l1,%lo(0x1f1c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 105
.L2559:

! 1848		 break;

	ba	.L2413
	nop

	! block 106
.L2560:
.L2561:

! 1849	      case GL_CURRENT_RASTER_POSITION:
! 1850		 params[0] = ctx->Current.RasterPos[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef8),%l1
	or	%l1,%lo(0x1ef8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 107
.L2562:

! 1851		 params[1] = ctx->Current.RasterPos[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1efc),%l1
	or	%l1,%lo(0x1efc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 108
.L2563:

! 1852		 params[2] = ctx->Current.RasterPos[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f00),%l1
	or	%l1,%lo(0x1f00),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 109
.L2564:

! 1853		 params[3] = ctx->Current.RasterPos[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f04),%l1
	or	%l1,%lo(0x1f04),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 110
.L2565:

! 1854		 break;

	ba	.L2413
	nop

	! block 111
.L2566:
.L2567:

! 1855	      case GL_CURRENT_RASTER_TEXTURE_COORDS:
! 1856		 params[0] = ctx->Current.RasterTexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f20),%l1
	or	%l1,%lo(0x1f20),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 112
.L2568:

! 1857		 params[1] = ctx->Current.RasterTexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f24),%l1
	or	%l1,%lo(0x1f24),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 113
.L2569:

! 1858		 params[2] = ctx->Current.RasterTexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f28),%l1
	or	%l1,%lo(0x1f28),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 114
.L2570:

! 1859		 params[3] = ctx->Current.RasterTexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f2c),%l1
	or	%l1,%lo(0x1f2c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 115
.L2571:

! 1860		 break;

	ba	.L2413
	nop

	! block 116
.L2572:
.L2573:

! 1861	      case GL_CURRENT_RASTER_POSITION_VALID:
! 1862		 *params = (GLfloat) ctx->Current.RasterPosValid;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f30),%l1
	or	%l1,%lo(0x1f30),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 117
.L2574:

! 1863		 break;

	ba	.L2413
	nop

	! block 118
.L2575:
.L2576:

! 1864	      case GL_CURRENT_TEXTURE_COORDS:
! 1865		 params[0] = (GLfloat) ctx->Current.TexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 119
.L2577:

! 1866		 params[1] = (GLfloat) ctx->Current.TexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 120
.L2578:

! 1867		 params[2] = (GLfloat) ctx->Current.TexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 121
.L2579:

! 1868		 params[3] = (GLfloat) ctx->Current.TexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 122
.L2580:

! 1869		 break;

	ba	.L2413
	nop

	! block 123
.L2581:
.L2582:

! 1870	      case GL_DEPTH_BIAS:
! 1871		 *params = (GLfloat) ctx->Pixel.DepthBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae3c),%l1
	or	%l1,%lo(0xae3c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 124
.L2583:

! 1872		 break;

	ba	.L2413
	nop

	! block 125
.L2584:
.L2585:

! 1873	      case GL_DEPTH_BITS:
! 1874		 *params = (GLfloat) ctx->Visual->DepthBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+64],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 126
.L2586:

! 1875		 break;

	ba	.L2413
	nop

	! block 127
.L2587:
.L2588:

! 1876	      case GL_DEPTH_CLEAR_VALUE:
! 1877		 *params = (GLfloat) ctx->Depth.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f38),%l1
	or	%l1,%lo(0x1f38),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 128
.L2589:

! 1878		 break;

	ba	.L2413
	nop

	! block 129
.L2590:
.L2591:

! 1879	      case GL_DEPTH_FUNC:
! 1880		 *params = (GLfloat) ctx->Depth.Func;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f34),%l1
	or	%l1,%lo(0x1f34),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 130
.L2592:

! 1881		 break;

	ba	.L2413
	nop

	! block 131
.L2593:
.L2594:

! 1882	      case GL_DEPTH_RANGE:
! 1883	         params[0] = (GLfloat) ctx->Viewport.Near;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc8),%l1
	or	%l1,%lo(0xdcc8),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 132
.L2595:

! 1884	         params[1] = (GLfloat) ctx->Viewport.Far;

	ld	[%fp+68],%l0
	sethi	%hi(0xdccc),%l1
	or	%l1,%lo(0xdccc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 133
.L2596:

! 1885		 break;

	ba	.L2413
	nop

	! block 134
.L2597:
.L2598:

! 1886	      case GL_DEPTH_SCALE:
! 1887		 *params = (GLfloat) ctx->Pixel.DepthScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae40),%l1
	or	%l1,%lo(0xae40),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 135
.L2599:

! 1888		 break;

	ba	.L2413
	nop

	! block 136
.L2600:
.L2601:

! 1889	      case GL_DEPTH_TEST:
! 1890		 *params = (GLfloat) ctx->Depth.Test;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 137
.L2602:

! 1891		 break;

	ba	.L2413
	nop

	! block 138
.L2603:
.L2604:

! 1892	      case GL_DEPTH_WRITEMASK:
! 1893		 *params = (GLfloat) ctx->Depth.Mask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3d),%l1
	or	%l1,%lo(0x1f3d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 139
.L2605:

! 1894		 break;

	ba	.L2413
	nop

	! block 140
.L2606:
.L2607:

! 1895	      case GL_DITHER:
! 1896		 *params = (GLfloat) ctx->Color.DitherFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed3),%l1
	or	%l1,%lo(0x1ed3),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 141
.L2608:

! 1897		 break;

	ba	.L2413
	nop

	! block 142
.L2609:
.L2610:

! 1898	      case GL_DOUBLEBUFFER:
! 1899		 *params = (GLfloat) ctx->Visual->DBflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 143
.L2611:

! 1900		 break;

	ba	.L2413
	nop

	! block 144
.L2612:
.L2613:

! 1901	      case GL_DRAW_BUFFER:
! 1902		 *params = (GLfloat) ctx->Color.DrawBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e9c),%l1
	or	%l1,%lo(0x1e9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 145
.L2614:

! 1903		 break;

	ba	.L2413
	nop

	! block 146
.L2615:
.L2616:

! 1904	      case GL_EDGE_FLAG:
! 1905		 *params = (GLfloat) ctx->Current.EdgeFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f31),%l1
	or	%l1,%lo(0x1f31),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 147
.L2617:

! 1906		 break;

	ba	.L2413
	nop

	! block 148
.L2618:
.L2619:

! 1907	      case GL_FEEDBACK_BUFFER_SIZE:
! 1908	         /* TODO: is this right?  Or, return number of entries in buffer? */
! 1909	         *params = (GLfloat) ctx->Feedback.BufferSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 149
.L2620:

! 1910	         break;

	ba	.L2413
	nop

	! block 150
.L2621:
.L2622:

! 1911	      case GL_FEEDBACK_BUFFER_TYPE:
! 1912	         *params = (GLfloat) ctx->Feedback.Type;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb8),%l1
	or	%l1,%lo(0xdfb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 151
.L2623:

! 1913	         break;

	ba	.L2413
	nop

	! block 152
.L2624:
.L2625:

! 1914	      case GL_FOG:
! 1915		 *params = (GLfloat) ctx->Fog.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 153
.L2626:

! 1916		 break;

	ba	.L2413
	nop

	! block 154
.L2627:
.L2628:

! 1917	      case GL_FOG_COLOR:
! 1918		 params[0] = ctx->Fog.Color[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f7c),%l1
	or	%l1,%lo(0x1f7c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 155
.L2629:

! 1919		 params[1] = ctx->Fog.Color[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f80),%l1
	or	%l1,%lo(0x1f80),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 156
.L2630:

! 1920		 params[2] = ctx->Fog.Color[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f84),%l1
	or	%l1,%lo(0x1f84),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 157
.L2631:

! 1921		 params[3] = ctx->Fog.Color[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f88),%l1
	or	%l1,%lo(0x1f88),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 158
.L2632:

! 1922		 break;

	ba	.L2413
	nop

	! block 159
.L2633:
.L2634:

! 1923	      case GL_FOG_DENSITY:
! 1924		 *params = ctx->Fog.Density;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f8c),%l1
	or	%l1,%lo(0x1f8c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 160
.L2635:

! 1925		 break;

	ba	.L2413
	nop

	! block 161
.L2636:
.L2637:

! 1926	      case GL_FOG_END:
! 1927		 *params = ctx->Fog.End;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f94),%l1
	or	%l1,%lo(0x1f94),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 162
.L2638:

! 1928		 break;

	ba	.L2413
	nop

	! block 163
.L2639:
.L2640:

! 1929	      case GL_FOG_HINT:
! 1930		 *params = (GLfloat) ctx->Hint.Fog;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 164
.L2641:

! 1931		 break;

	ba	.L2413
	nop

	! block 165
.L2642:
.L2643:

! 1932	      case GL_FOG_INDEX:
! 1933		 *params = ctx->Fog.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f98),%l1
	or	%l1,%lo(0x1f98),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 166
.L2644:

! 1934		 break;

	ba	.L2413
	nop

	! block 167
.L2645:
.L2646:

! 1935	      case GL_FOG_MODE:
! 1936		 *params = (GLfloat) ctx->Fog.Mode;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f9c),%l1
	or	%l1,%lo(0x1f9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 168
.L2647:

! 1937		 break;

	ba	.L2413
	nop

	! block 169
.L2648:
.L2649:

! 1938	      case GL_FOG_START:
! 1939		 *params = ctx->Fog.Start;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f90),%l1
	or	%l1,%lo(0x1f90),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 170
.L2650:

! 1940		 break;

	ba	.L2413
	nop

	! block 171
.L2651:
.L2652:

! 1941	      case GL_FRONT_FACE:
! 1942		 *params = (GLfloat) ctx->Polygon.FrontFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a0),%l1
	or	%l1,%lo(0xd6a0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 172
.L2653:

! 1943		 break;

	ba	.L2413
	nop

	! block 173
.L2654:
.L2655:

! 1944	      case GL_GREEN_BIAS:
! 1945	         *params = (GLfloat) ctx->Pixel.GreenBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 174
.L2656:

! 1946	         break;

	ba	.L2413
	nop

	! block 175
.L2657:
.L2658:

! 1947	      case GL_GREEN_BITS:
! 1948	         *params = (GLfloat) ctx->Visual->GreenBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+44],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 176
.L2659:

! 1949	         break;

	ba	.L2413
	nop

	! block 177
.L2660:
.L2661:

! 1950	      case GL_GREEN_SCALE:
! 1951	         *params = (GLfloat) ctx->Pixel.GreenScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 178
.L2662:

! 1952	         break;

	ba	.L2413
	nop

	! block 179
.L2663:
.L2664:

! 1953	      case GL_INDEX_BITS:
! 1954	         *params = (GLfloat) ctx->Visual->IndexBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 180
.L2665:

! 1955		 break;

	ba	.L2413
	nop

	! block 181
.L2666:
.L2667:

! 1956	      case GL_INDEX_CLEAR_VALUE:
! 1957	         *params = (GLfloat) ctx->Color.ClearIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e7c),%l1
	or	%l1,%lo(0x1e7c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 182
.L2668:

! 1958		 break;

	ba	.L2413
	nop

	! block 183
.L2669:
.L2670:

! 1959	      case GL_INDEX_MODE:
! 1960		 *params = ctx->Visual->RGBAflag ? 0.0F : 1.0F;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l0
	cmp	%l0,%g0
	be	.L2671
	nop

	! block 184
.L2672:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L2673
	st	%f4,[%fp-24]

	! block 185
.L2671:
	sethi	%hi(.L_cseg17),%l0
	ld	[%l0+%lo(.L_cseg17)],%f4
	st	%f4,[%fp-24]

	! block 186
.L2673:
	ld	[%fp-24],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 187
.L2674:

! 1961		 break;

	ba	.L2413
	nop

	! block 188
.L2675:
.L2676:

! 1962	      case GL_INDEX_OFFSET:
! 1963		 *params = (GLfloat) ctx->Pixel.IndexOffset;

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 189
.L2677:

! 1964		 break;

	ba	.L2413
	nop

	! block 190
.L2678:
.L2679:

! 1965	      case GL_INDEX_SHIFT:
! 1966		 *params = (GLfloat) ctx->Pixel.IndexShift;

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 191
.L2680:

! 1967		 break;

	ba	.L2413
	nop

	! block 192
.L2681:
.L2682:

! 1968	      case GL_INDEX_WRITEMASK:
! 1969		 *params = (GLfloat) ctx->Color.IndexMask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e90),%l1
	or	%l1,%lo(0x1e90),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 193
.L2683:

! 1970		 break;

	ba	.L2413
	nop

	! block 194
.L2684:
.L2685:
.L2686:
.L2687:
.L2688:
.L2689:
.L2690:
.L2691:
.L2692:

! 1971	      case GL_LIGHT0:
! 1972	      case GL_LIGHT1:
! 1973	      case GL_LIGHT2:
! 1974	      case GL_LIGHT3:
! 1975	      case GL_LIGHT4:
! 1976	      case GL_LIGHT5:
! 1977	      case GL_LIGHT6:
! 1978	      case GL_LIGHT7:
! 1979		 *params = (GLfloat) ctx->Light.Light[pname-GL_LIGHT0].Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb4),%l1
	or	%l1,%lo(0x1fb4),%l1
	add	%l0,%l1,%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,5,%l1
	add	%l2,%l1,%l2
	sll	%l0,6,%l1
	add	%l2,%l1,%l2
	sll	%l0,7,%l1
	add	%l2,%l1,%l2
	sll	%l0,12,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x438ff98),%l1
	or	%l1,%lo(0x438ff98),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 195
.L2693:

! 1980		 break;

	ba	.L2413
	nop

	! block 196
.L2694:
.L2695:

! 1981	      case GL_LIGHTING:
! 1982		 *params = (GLfloat) ctx->Light.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xadc8),%l1
	or	%l1,%lo(0xadc8),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 197
.L2696:

! 1983		 break;

	ba	.L2413
	nop

	! block 198
.L2697:
.L2698:

! 1984	      case GL_LIGHT_MODEL_AMBIENT:
! 1985		 params[0] = ctx->Light.Model.Ambient[0];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 199
.L2699:

! 1986		 params[1] = ctx->Light.Model.Ambient[1];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 200
.L2700:

! 1987		 params[2] = ctx->Light.Model.Ambient[2];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 201
.L2701:

! 1988		 params[3] = ctx->Light.Model.Ambient[3];

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 202
.L2702:

! 1989		 break;

	ba	.L2413
	nop

	! block 203
.L2703:
.L2704:

! 1990	      case GL_LIGHT_MODEL_LOCAL_VIEWER:
! 1991		 *params = (GLfloat) ctx->Light.Model.LocalViewer;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e4),%l1
	or	%l1,%lo(0xa6e4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 204
.L2705:

! 1992		 break;

	ba	.L2413
	nop

	! block 205
.L2706:
.L2707:

! 1993	      case GL_LIGHT_MODEL_TWO_SIDE:
! 1994		 *params = (GLfloat) ctx->Light.Model.TwoSide;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e5),%l1
	or	%l1,%lo(0xa6e5),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 206
.L2708:

! 1995		 break;

	ba	.L2413
	nop

	! block 207
.L2709:
.L2710:

! 1996	      case GL_LINE_SMOOTH:
! 1997		 *params = (GLfloat) ctx->Line.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae08),%l1
	or	%l1,%lo(0xae08),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 208
.L2711:

! 1998		 break;

	ba	.L2413
	nop

	! block 209
.L2712:
.L2713:

! 1999	      case GL_LINE_SMOOTH_HINT:
! 2000		 *params = (GLfloat) ctx->Hint.LineSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa8),%l1
	or	%l1,%lo(0x1fa8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 210
.L2714:

! 2001		 break;

	ba	.L2413
	nop

	! block 211
.L2715:
.L2716:

! 2002	      case GL_LINE_STIPPLE:
! 2003		 *params = (GLfloat) ctx->Line.StippleFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 212
.L2717:

! 2004		 break;

	ba	.L2413
	nop

	! block 213
.L2718:
.L2719:

! 2005	      case GL_LINE_STIPPLE_PATTERN:
! 2006	         *params = (GLfloat) ctx->Line.StipplePattern;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 214
.L2720:

! 2007	         break;

	ba	.L2413
	nop

	! block 215
.L2721:
.L2722:

! 2008	      case GL_LINE_STIPPLE_REPEAT:
! 2009	         *params = (GLfloat) ctx->Line.StippleFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 216
.L2723:

! 2010	         break;

	ba	.L2413
	nop

	! block 217
.L2724:
.L2725:

! 2011	      case GL_LINE_WIDTH:
! 2012		 *params = (GLfloat) ctx->Line.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 218
.L2726:

! 2013		 break;

	ba	.L2413
	nop

	! block 219
.L2727:
.L2728:

! 2014	      case GL_LINE_WIDTH_GRANULARITY:
! 2015		 *params = (GLfloat) LINE_WIDTH_GRANULARITY;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 220
.L2729:

! 2016		 break;

	ba	.L2413
	nop

	! block 221
.L2730:
.L2731:

! 2017	      case GL_LINE_WIDTH_RANGE:
! 2018		 params[0] = (GLfloat) MIN_LINE_WIDTH;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 222
.L2732:

! 2019		 params[1] = (GLfloat) MAX_LINE_WIDTH;

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 223
.L2733:

! 2020		 break;

	ba	.L2413
	nop

	! block 224
.L2734:
.L2735:

! 2021	      case GL_LIST_BASE:
! 2022		 *params = (GLfloat) ctx->List.ListBase;

	ld	[%fp+68],%l0
	sethi	%hi(0xae14),%l1
	or	%l1,%lo(0xae14),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 225
.L2736:

! 2023		 break;

	ba	.L2413
	nop

	! block 226
.L2737:
.L2738:

! 2024	      case GL_LIST_INDEX:
! 2025		 *params = (GLfloat) gl_list_index();

	call	gl_list_index
	nop
	st	%o0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 227
.L2739:

! 2026		 break;

	ba	.L2413
	nop

	! block 228
.L2740:
.L2741:

! 2027	      case GL_LIST_MODE:
! 2028		 *params = ctx->ExecuteFlag ? (GLfloat) GL_COMPILE_AND_EXECUTE
! 2029		   			  : (GLfloat) GL_COMPILE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e24),%l1
	or	%l1,%lo(0x1e24),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L2742
	nop

	! block 229
.L2743:
	sethi	%hi(.L_cseg18),%l0
	ld	[%l0+%lo(.L_cseg18)],%f4
	ba	.L2744
	st	%f4,[%fp-28]

	! block 230
.L2742:
	sethi	%hi(.L_cseg19),%l0
	ld	[%l0+%lo(.L_cseg19)],%f4
	st	%f4,[%fp-28]

	! block 231
.L2744:
	ld	[%fp-28],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 232
.L2745:

! 2030		 break;

	ba	.L2413
	nop

	! block 233
.L2746:
.L2747:

! 2031	      case GL_INDEX_LOGIC_OP:
! 2032		 *params = (GLfloat) ctx->Color.IndexLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed0),%l1
	or	%l1,%lo(0x1ed0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 234
.L2748:

! 2033		 break;

	ba	.L2413
	nop

	! block 235
.L2749:
.L2750:

! 2034	      case GL_COLOR_LOGIC_OP:
! 2035		 *params = (GLfloat) ctx->Color.ColorLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed1),%l1
	or	%l1,%lo(0x1ed1),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 236
.L2751:

! 2036		 break;

	ba	.L2413
	nop

	! block 237
.L2752:
.L2753:

! 2037	      case GL_LOGIC_OP_MODE:
! 2038	         *params = (GLfloat) ctx->Color.LogicOp;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ecc),%l1
	or	%l1,%lo(0x1ecc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 238
.L2754:

! 2039		 break;

	ba	.L2413
	nop

	! block 239
.L2755:
.L2756:

! 2040	      case GL_MAP1_COLOR_4:
! 2041		 *params = (GLfloat) ctx->Eval.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f40),%l1
	or	%l1,%lo(0x1f40),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 240
.L2757:

! 2042		 break;

	ba	.L2413
	nop

	! block 241
.L2758:
.L2759:

! 2043	      case GL_MAP1_GRID_DOMAIN:
! 2044		 params[0] = ctx->Eval.MapGrid1u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 242
.L2760:

! 2045		 params[1] = ctx->Eval.MapGrid1u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 243
.L2761:

! 2046		 break;

	ba	.L2413
	nop

	! block 244
.L2762:
.L2763:

! 2047	      case GL_MAP1_GRID_SEGMENTS:
! 2048		 *params = (GLfloat) ctx->Eval.MapGrid1un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 245
.L2764:

! 2049		 break;

	ba	.L2413
	nop

	! block 246
.L2765:
.L2766:

! 2050	      case GL_MAP1_INDEX:
! 2051		 *params = (GLfloat) ctx->Eval.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f41),%l1
	or	%l1,%lo(0x1f41),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 247
.L2767:

! 2052		 break;

	ba	.L2413
	nop

	! block 248
.L2768:
.L2769:

! 2053	      case GL_MAP1_NORMAL:
! 2054		 *params = (GLfloat) ctx->Eval.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f42),%l1
	or	%l1,%lo(0x1f42),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 249
.L2770:

! 2055		 break;

	ba	.L2413
	nop

	! block 250
.L2771:
.L2772:

! 2056	      case GL_MAP1_TEXTURE_COORD_1:
! 2057		 *params = (GLfloat) ctx->Eval.Map1TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f43),%l1
	or	%l1,%lo(0x1f43),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 251
.L2773:

! 2058		 break;

	ba	.L2413
	nop

	! block 252
.L2774:
.L2775:

! 2059	      case GL_MAP1_TEXTURE_COORD_2:
! 2060		 *params = (GLfloat) ctx->Eval.Map1TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f44),%l1
	or	%l1,%lo(0x1f44),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 253
.L2776:

! 2061		 break;

	ba	.L2413
	nop

	! block 254
.L2777:
.L2778:

! 2062	      case GL_MAP1_TEXTURE_COORD_3:
! 2063		 *params = (GLfloat) ctx->Eval.Map1TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f45),%l1
	or	%l1,%lo(0x1f45),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 255
.L2779:

! 2064		 break;

	ba	.L2413
	nop

	! block 256
.L2780:
.L2781:

! 2065	      case GL_MAP1_TEXTURE_COORD_4:
! 2066		 *params = (GLfloat) ctx->Eval.Map1TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f46),%l1
	or	%l1,%lo(0x1f46),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 257
.L2782:

! 2067		 break;

	ba	.L2413
	nop

	! block 258
.L2783:
.L2784:

! 2068	      case GL_MAP1_VERTEX_3:
! 2069		 *params = (GLfloat) ctx->Eval.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f47),%l1
	or	%l1,%lo(0x1f47),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 259
.L2785:

! 2070		 break;

	ba	.L2413
	nop

	! block 260
.L2786:
.L2787:

! 2071	      case GL_MAP1_VERTEX_4:
! 2072		 *params = (GLfloat) ctx->Eval.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f48),%l1
	or	%l1,%lo(0x1f48),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 261
.L2788:

! 2073		 break;

	ba	.L2413
	nop

	! block 262
.L2789:
.L2790:

! 2074	      case GL_MAP2_COLOR_4:
! 2075		 *params = (GLfloat) ctx->Eval.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f49),%l1
	or	%l1,%lo(0x1f49),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 263
.L2791:

! 2076		 break;

	ba	.L2413
	nop

	! block 264
.L2792:
.L2793:

! 2077	      case GL_MAP2_GRID_DOMAIN:
! 2078		 params[0] = ctx->Eval.MapGrid2u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 265
.L2794:

! 2079		 params[1] = ctx->Eval.MapGrid2u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 266
.L2795:

! 2080		 params[2] = ctx->Eval.MapGrid2v1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 267
.L2796:

! 2081		 params[3] = ctx->Eval.MapGrid2v2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 268
.L2797:

! 2082		 break;

	ba	.L2413
	nop

	! block 269
.L2798:
.L2799:

! 2083	      case GL_MAP2_GRID_SEGMENTS:
! 2084		 params[0] = (GLfloat) ctx->Eval.MapGrid2un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 270
.L2800:

! 2085		 params[1] = (GLfloat) ctx->Eval.MapGrid2vn;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 271
.L2801:

! 2086		 break;

	ba	.L2413
	nop

	! block 272
.L2802:
.L2803:

! 2087	      case GL_MAP2_INDEX:
! 2088		 *params = (GLfloat) ctx->Eval.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4a),%l1
	or	%l1,%lo(0x1f4a),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 273
.L2804:

! 2089		 break;

	ba	.L2413
	nop

	! block 274
.L2805:
.L2806:

! 2090	      case GL_MAP2_NORMAL:
! 2091		 *params = (GLfloat) ctx->Eval.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4b),%l1
	or	%l1,%lo(0x1f4b),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 275
.L2807:

! 2092		 break;

	ba	.L2413
	nop

	! block 276
.L2808:
.L2809:

! 2093	      case GL_MAP2_TEXTURE_COORD_1:
! 2094		 *params = ctx->Eval.Map2TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4c),%l1
	or	%l1,%lo(0x1f4c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 277
.L2810:

! 2095		 break;

	ba	.L2413
	nop

	! block 278
.L2811:
.L2812:

! 2096	      case GL_MAP2_TEXTURE_COORD_2:
! 2097		 *params = ctx->Eval.Map2TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4d),%l1
	or	%l1,%lo(0x1f4d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 279
.L2813:

! 2098		 break;

	ba	.L2413
	nop

	! block 280
.L2814:
.L2815:

! 2099	      case GL_MAP2_TEXTURE_COORD_3:
! 2100		 *params = ctx->Eval.Map2TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4e),%l1
	or	%l1,%lo(0x1f4e),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 281
.L2816:

! 2101		 break;

	ba	.L2413
	nop

	! block 282
.L2817:
.L2818:

! 2102	      case GL_MAP2_TEXTURE_COORD_4:
! 2103		 *params = ctx->Eval.Map2TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4f),%l1
	or	%l1,%lo(0x1f4f),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 283
.L2819:

! 2104		 break;

	ba	.L2413
	nop

	! block 284
.L2820:
.L2821:

! 2105	      case GL_MAP2_VERTEX_3:
! 2106		 *params = (GLfloat) ctx->Eval.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 285
.L2822:

! 2107		 break;

	ba	.L2413
	nop

	! block 286
.L2823:
.L2824:

! 2108	      case GL_MAP2_VERTEX_4:
! 2109		 *params = (GLfloat) ctx->Eval.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 287
.L2825:

! 2110		 break;

	ba	.L2413
	nop

	! block 288
.L2826:
.L2827:

! 2111	      case GL_MAP_COLOR:
! 2112		 *params = (GLfloat) ctx->Pixel.MapColorFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 289
.L2828:

! 2113		 break;

	ba	.L2413
	nop

	! block 290
.L2829:
.L2830:

! 2114	      case GL_MAP_STENCIL:
! 2115		 *params = (GLfloat) ctx->Pixel.MapStencilFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4d),%l1
	or	%l1,%lo(0xae4d),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 291
.L2831:

! 2116		 break;

	ba	.L2413
	nop

	! block 292
.L2832:
.L2833:

! 2117	      case GL_MATRIX_MODE:
! 2118		 *params = (GLfloat) ctx->Transform.MatrixMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xdc4c),%l1
	or	%l1,%lo(0xdc4c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 293
.L2834:

! 2119		 break;

	ba	.L2413
	nop

	! block 294
.L2835:
.L2836:

! 2120	      case GL_MAX_ATTRIB_STACK_DEPTH:
! 2121		 *params = (GLfloat) MAX_ATTRIB_STACK_DEPTH;

	sethi	%hi(.L_cseg20),%l0
	ld	[%l0+%lo(.L_cseg20)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 295
.L2837:

! 2122		 break;

	ba	.L2413
	nop

	! block 296
.L2838:
.L2839:

! 2123	      case GL_MAX_CLIENT_ATTRIB_STACK_DEPTH:
! 2124	         *params = (GLfloat) MAX_CLIENT_ATTRIB_STACK_DEPTH;

	sethi	%hi(.L_cseg20),%l0
	ld	[%l0+%lo(.L_cseg20)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 297
.L2840:

! 2125	         break;

	ba	.L2413
	nop

	! block 298
.L2841:
.L2842:

! 2126	      case GL_MAX_CLIP_PLANES:
! 2127		 *params = (GLfloat) MAX_CLIP_PLANES;

	sethi	%hi(.L_cseg21),%l0
	ld	[%l0+%lo(.L_cseg21)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 299
.L2843:

! 2128		 break;

	ba	.L2413
	nop

	! block 300
.L2844:
.L2845:

! 2129	      case GL_MAX_EVAL_ORDER:
! 2130		 *params = (GLfloat) MAX_EVAL_ORDER;

	sethi	%hi(.L_cseg22),%l0
	ld	[%l0+%lo(.L_cseg22)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 301
.L2846:

! 2131		 break;

	ba	.L2413
	nop

	! block 302
.L2847:
.L2848:

! 2132	      case GL_MAX_LIGHTS:
! 2133		 *params = (GLfloat) MAX_LIGHTS;

	sethi	%hi(.L_cseg23),%l0
	ld	[%l0+%lo(.L_cseg23)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 303
.L2849:

! 2134		 break;

	ba	.L2413
	nop

	! block 304
.L2850:
.L2851:

! 2135	      case GL_MAX_LIST_NESTING:
! 2136		 *params = (GLfloat) MAX_LIST_NESTING;

	sethi	%hi(.L_cseg24),%l0
	ld	[%l0+%lo(.L_cseg24)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 305
.L2852:

! 2137		 break;

	ba	.L2413
	nop

	! block 306
.L2853:
.L2854:

! 2138	      case GL_MAX_MODELVIEW_STACK_DEPTH:
! 2139		 *params = (GLfloat) MAX_MODELVIEW_STACK_DEPTH;

	sethi	%hi(.L_cseg25),%l0
	ld	[%l0+%lo(.L_cseg25)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 307
.L2855:

! 2140		 break;

	ba	.L2413
	nop

	! block 308
.L2856:
.L2857:

! 2141	      case GL_MAX_NAME_STACK_DEPTH:
! 2142		 *params = (GLfloat) MAX_NAME_STACK_DEPTH;

	sethi	%hi(.L_cseg24),%l0
	ld	[%l0+%lo(.L_cseg24)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 309
.L2858:

! 2143		 break;

	ba	.L2413
	nop

	! block 310
.L2859:
.L2860:

! 2144	      case GL_MAX_PIXEL_MAP_TABLE:
! 2145		 *params = (GLfloat) MAX_PIXEL_MAP_TABLE;

	sethi	%hi(.L_cseg26),%l0
	ld	[%l0+%lo(.L_cseg26)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 311
.L2861:

! 2146		 break;

	ba	.L2413
	nop

	! block 312
.L2862:
.L2863:

! 2147	      case GL_MAX_PROJECTION_STACK_DEPTH:
! 2148		 *params = (GLfloat) MAX_PROJECTION_STACK_DEPTH;

	sethi	%hi(.L_cseg25),%l0
	ld	[%l0+%lo(.L_cseg25)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 313
.L2864:

! 2149		 break;

	ba	.L2413
	nop

	! block 314
.L2865:
.L2866:

! 2150	      case GL_MAX_TEXTURE_SIZE:
! 2151		 *params = (GLfloat) MAX_TEXTURE_SIZE;

	sethi	%hi(.L_cseg27),%l0
	ld	[%l0+%lo(.L_cseg27)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 315
.L2867:

! 2152		 break;

	ba	.L2413
	nop

	! block 316
.L2868:
.L2869:

! 2153	      case GL_MAX_TEXTURE_STACK_DEPTH:
! 2154		 *params = (GLfloat) MAX_TEXTURE_STACK_DEPTH;

	sethi	%hi(.L_cseg28),%l0
	ld	[%l0+%lo(.L_cseg28)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 317
.L2870:

! 2155		 break;

	ba	.L2413
	nop

	! block 318
.L2871:
.L2872:

! 2156	      case GL_MAX_VIEWPORT_DIMS:
! 2157	         params[0] = (GLfloat) MAX_WIDTH;

	sethi	%hi(.L_cseg29),%l0
	ld	[%l0+%lo(.L_cseg29)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 319
.L2873:

! 2158	         params[1] = (GLfloat) MAX_HEIGHT;

	sethi	%hi(.L_cseg30),%l0
	ld	[%l0+%lo(.L_cseg30)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 320
.L2874:

! 2159	         break;

	ba	.L2413
	nop

	! block 321
.L2875:
.L2876:
.L2877:

! 2160	      case GL_MODELVIEW_MATRIX:
! 2161		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 322
.L2881:
.L2878:
.L2882:
.L2883:
.L2884:

! 2162		    params[i] = ctx->ModelViewMatrix[i];

	ld	[%fp+68],%l1
	ld	[%fp-4],%l0
	sll	%l0,2,%l2
	add	%l1,%l2,%l0
	ld	[%l0+2436],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+%l2]

	! block 323
.L2885:
.L2886:
.L2887:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L2878
	nop

	! block 324
.L2888:
.L2880:
.L2889:
.L2890:

! 2163		 }
! 2164		 break;

	ba	.L2413
	nop

	! block 325
.L2891:
.L2892:

! 2165	      case GL_MODELVIEW_STACK_DEPTH:
! 2166		 *params = (GLfloat) ctx->ModelViewStackDepth;

	ld	[%fp+68],%l0
	ld	[%l0+2564],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 326
.L2893:

! 2167		 break;

	ba	.L2413
	nop

	! block 327
.L2894:
.L2895:

! 2168	      case GL_NAME_STACK_DEPTH:
! 2169		 *params = (GLfloat) ctx->Select.NameStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfdc),%l1
	or	%l1,%lo(0xdfdc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 328
.L2896:

! 2170		 break;

	ba	.L2413
	nop

	! block 329
.L2897:
.L2898:

! 2171	      case GL_NORMALIZE:
! 2172		 *params = (GLfloat) ctx->Transform.Normalize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb7),%l1
	or	%l1,%lo(0xdcb7),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 330
.L2899:

! 2173		 break;

	ba	.L2413
	nop

	! block 331
.L2900:
.L2901:

! 2174	      case GL_PACK_ALIGNMENT:
! 2175		 *params = (GLfloat) ctx->Pack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddac),%l1
	or	%l1,%lo(0xddac),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 332
.L2902:

! 2176		 break;

	ba	.L2413
	nop

	! block 333
.L2903:
.L2904:

! 2177	      case GL_PACK_LSB_FIRST:
! 2178		 *params = (GLfloat) ctx->Pack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc5),%l1
	or	%l1,%lo(0xddc5),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 334
.L2905:

! 2179		 break;

	ba	.L2413
	nop

	! block 335
.L2906:
.L2907:

! 2180	      case GL_PACK_ROW_LENGTH:
! 2181		 *params = (GLfloat) ctx->Pack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb0),%l1
	or	%l1,%lo(0xddb0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 336
.L2908:

! 2182		 break;

	ba	.L2413
	nop

	! block 337
.L2909:
.L2910:

! 2183	      case GL_PACK_SKIP_PIXELS:
! 2184		 *params = (GLfloat) ctx->Pack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb4),%l1
	or	%l1,%lo(0xddb4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 338
.L2911:

! 2185		 break;

	ba	.L2413
	nop

	! block 339
.L2912:
.L2913:

! 2186	      case GL_PACK_SKIP_ROWS:
! 2187		 *params = (GLfloat) ctx->Pack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb8),%l1
	or	%l1,%lo(0xddb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 340
.L2914:

! 2188		 break;

	ba	.L2413
	nop

	! block 341
.L2915:
.L2916:

! 2189	      case GL_PACK_SWAP_BYTES:
! 2190		 *params = (GLfloat) ctx->Pack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc4),%l1
	or	%l1,%lo(0xddc4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 342
.L2917:

! 2191		 break;

	ba	.L2413
	nop

	! block 343
.L2918:
.L2919:

! 2192	      case GL_PACK_SKIP_IMAGES_EXT:
! 2193	         *params = (GLfloat) ctx->Pack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc0),%l1
	or	%l1,%lo(0xddc0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 344
.L2920:

! 2194	         break;

	ba	.L2413
	nop

	! block 345
.L2921:
.L2922:

! 2195	      case GL_PACK_IMAGE_HEIGHT_EXT:
! 2196	         *params = (GLfloat) ctx->Pack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddbc),%l1
	or	%l1,%lo(0xddbc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 346
.L2923:

! 2197	         break;

	ba	.L2413
	nop

	! block 347
.L2924:
.L2925:

! 2198	      case GL_PERSPECTIVE_CORRECTION_HINT:
! 2199		 *params = (GLfloat) ctx->Hint.PerspectiveCorrection;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa0),%l1
	or	%l1,%lo(0x1fa0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 348
.L2926:

! 2200		 break;

	ba	.L2413
	nop

	! block 349
.L2927:
.L2928:

! 2201	      case GL_PIXEL_MAP_A_TO_A_SIZE:
! 2202		 *params = (GLfloat) ctx->Pixel.MapAtoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 350
.L2929:

! 2203		 break;

	ba	.L2413
	nop

	! block 351
.L2930:
.L2931:

! 2204	      case GL_PIXEL_MAP_B_TO_B_SIZE:
! 2205		 *params = (GLfloat) ctx->Pixel.MapBtoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 352
.L2932:

! 2206		 break;

	ba	.L2413
	nop

	! block 353
.L2933:
.L2934:

! 2207	      case GL_PIXEL_MAP_G_TO_G_SIZE:
! 2208		 *params = (GLfloat) ctx->Pixel.MapGtoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 354
.L2935:

! 2209		 break;

	ba	.L2413
	nop

	! block 355
.L2936:
.L2937:

! 2210	      case GL_PIXEL_MAP_I_TO_A_SIZE:
! 2211		 *params = (GLfloat) ctx->Pixel.MapItoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 356
.L2938:

! 2212		 break;

	ba	.L2413
	nop

	! block 357
.L2939:
.L2940:

! 2213	      case GL_PIXEL_MAP_I_TO_B_SIZE:
! 2214		 *params = (GLfloat) ctx->Pixel.MapItoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 358
.L2941:

! 2215		 break;

	ba	.L2413
	nop

	! block 359
.L2942:
.L2943:

! 2216	      case GL_PIXEL_MAP_I_TO_G_SIZE:
! 2217		 *params = (GLfloat) ctx->Pixel.MapItoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 360
.L2944:

! 2218		 break;

	ba	.L2413
	nop

	! block 361
.L2945:
.L2946:

! 2219	      case GL_PIXEL_MAP_I_TO_I_SIZE:
! 2220		 *params = (GLfloat) ctx->Pixel.MapItoIsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae5c),%l1
	or	%l1,%lo(0xae5c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 362
.L2947:

! 2221		 break;

	ba	.L2413
	nop

	! block 363
.L2948:
.L2949:

! 2222	      case GL_PIXEL_MAP_I_TO_R_SIZE:
! 2223		 *params = (GLfloat) ctx->Pixel.MapItoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 364
.L2950:

! 2224		 break;

	ba	.L2413
	nop

	! block 365
.L2951:
.L2952:

! 2225	      case GL_PIXEL_MAP_R_TO_R_SIZE:
! 2226		 *params = (GLfloat) ctx->Pixel.MapRtoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 366
.L2953:

! 2227		 break;

	ba	.L2413
	nop

	! block 367
.L2954:
.L2955:

! 2228	      case GL_PIXEL_MAP_S_TO_S_SIZE:
! 2229		 *params = (GLfloat) ctx->Pixel.MapStoSsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae58),%l1
	or	%l1,%lo(0xae58),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 368
.L2956:

! 2230		 break;

	ba	.L2413
	nop

	! block 369
.L2957:
.L2958:

! 2231	      case GL_POINT_SIZE:
! 2232	         *params = (GLfloat) ctx->Point.Size;

	ld	[%fp+68],%l0
	sethi	%hi(0xd684),%l1
	or	%l1,%lo(0xd684),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 370
.L2959:

! 2233	         break;

	ba	.L2413
	nop

	! block 371
.L2960:
.L2961:

! 2234	      case GL_POINT_SIZE_GRANULARITY:
! 2235		 *params = (GLfloat) POINT_SIZE_GRANULARITY;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 372
.L2962:

! 2236		 break;

	ba	.L2413
	nop

	! block 373
.L2963:
.L2964:

! 2237	      case GL_POINT_SIZE_RANGE:
! 2238		 params[0] = (GLfloat) MIN_POINT_SIZE;

	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 374
.L2965:

! 2239		 params[1] = (GLfloat) MAX_POINT_SIZE;

	sethi	%hi(.L_cseg2),%l0
	ldd	[%l0+%lo(.L_cseg2)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 375
.L2966:

! 2240		 break;

	ba	.L2413
	nop

	! block 376
.L2967:
.L2968:

! 2241	      case GL_POINT_SMOOTH:
! 2242		 *params = (GLfloat) ctx->Point.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd680),%l1
	or	%l1,%lo(0xd680),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 377
.L2969:

! 2243		 break;

	ba	.L2413
	nop

	! block 378
.L2970:
.L2971:

! 2244	      case GL_POINT_SMOOTH_HINT:
! 2245		 *params = (GLfloat) ctx->Hint.PointSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa4),%l1
	or	%l1,%lo(0x1fa4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 379
.L2972:

! 2246		 break;

	ba	.L2413
	nop

	! block 380
.L2973:
.L2974:

! 2247	      case GL_POINT_SIZE_MIN_EXT:
! 2248		 *params = (GLfloat) (ctx->Point.MinSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd694),%l1
	or	%l1,%lo(0xd694),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 381
.L2975:

! 2249		 break;

	ba	.L2413
	nop

	! block 382
.L2976:
.L2977:

! 2250	      case GL_POINT_SIZE_MAX_EXT:
! 2251		 *params = (GLfloat) (ctx->Point.MaxSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd698),%l1
	or	%l1,%lo(0xd698),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 383
.L2978:

! 2252		 break;

	ba	.L2413
	nop

	! block 384
.L2979:
.L2980:

! 2253	      case GL_POINT_FADE_THRESHOLD_SIZE_EXT:
! 2254		 *params = (GLfloat) (ctx->Point.Threshold);

	ld	[%fp+68],%l0
	sethi	%hi(0xd69c),%l1
	or	%l1,%lo(0xd69c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 385
.L2981:

! 2255		 break;

	ba	.L2413
	nop

	! block 386
.L2982:
.L2983:

! 2256	      case GL_DISTANCE_ATTENUATION_EXT:
! 2257		 params[0] = (GLfloat) (ctx->Point.Params[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd688),%l1
	or	%l1,%lo(0xd688),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 387
.L2984:

! 2258		 params[1] = (GLfloat) (ctx->Point.Params[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd68c),%l1
	or	%l1,%lo(0xd68c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 388
.L2985:

! 2259		 params[2] = (GLfloat) (ctx->Point.Params[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd690),%l1
	or	%l1,%lo(0xd690),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 389
.L2986:

! 2260		 break;

	ba	.L2413
	nop

	! block 390
.L2987:
.L2988:

! 2261	      case GL_POLYGON_MODE:
! 2262		 params[0] = (GLfloat) ctx->Polygon.FrontMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a4),%l1
	or	%l1,%lo(0xd6a4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 391
.L2989:

! 2263		 params[1] = (GLfloat) ctx->Polygon.BackMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a8),%l1
	or	%l1,%lo(0xd6a8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 392
.L2990:

! 2264		 break;

	ba	.L2413
	nop

	! block 393
.L2991:
.L2992:

! 2265	#ifdef GL_EXT_polygon_offset
! 2266	      case GL_POLYGON_OFFSET_BIAS_EXT:
! 2267	         *params = ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 394
.L2993:

! 2268	         break;

	ba	.L2413
	nop

	! block 395
.L2994:
.L2995:

! 2269	#endif
! 2270	      case GL_POLYGON_OFFSET_FACTOR:
! 2271	         *params = ctx->Polygon.OffsetFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6bc),%l1
	or	%l1,%lo(0xd6bc),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 396
.L2996:

! 2272	         break;

	ba	.L2413
	nop

	! block 397
.L2997:
.L2998:

! 2273	      case GL_POLYGON_OFFSET_UNITS:
! 2274	         *params = ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 398
.L2999:

! 2275	         break;

	ba	.L2413
	nop

	! block 399
.L3000:
.L3001:

! 2276	      case GL_POLYGON_SMOOTH:
! 2277		 *params = (GLfloat) ctx->Polygon.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b8),%l1
	or	%l1,%lo(0xd6b8),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 400
.L3002:

! 2278		 break;

	ba	.L2413
	nop

	! block 401
.L3003:
.L3004:

! 2279	      case GL_POLYGON_SMOOTH_HINT:
! 2280		 *params = (GLfloat) ctx->Hint.PolygonSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fac),%l1
	or	%l1,%lo(0x1fac),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 402
.L3005:

! 2281		 break;

	ba	.L2413
	nop

	! block 403
.L3006:
.L3007:
.L3008:

! 2282	      case GL_POLYGON_STIPPLE:
! 2283		 for (i=0;i<32;i++) {		/* RIGHT? */

	st	%g0,[%fp-4]

	! block 404
.L_y301:
	mov	0,%l3
	sethi	%hi(0x43300000),%l5
	sethi	%hi(0xd6c8),%l4
	or	%l4,%lo(0xd6c8),%l4
.L3012:
.L3009:
.L3013:
.L3014:
.L3015:

! 2284		    params[i] = (GLfloat) ctx->PolygonStipple[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%l0
	st	%l5,[%fp-104]
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f6
	st	%l3,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 405
.L3016:
.L3017:
.L3018:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,32
	blu	.L3009
	nop

	! block 406
.L3019:
.L3011:
.L3020:
.L3021:

! 2285		 }
! 2286		 break;

	ba	.L2413
	nop

	! block 407
.L3022:
.L3023:
.L3024:

! 2287	      case GL_PROJECTION_MATRIX:
! 2288		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 408
.L_y302:
	sethi	%hi(0x1210),%l2
	or	%l2,%lo(0x1210),%l2
.L3028:
.L3025:
.L3029:
.L3030:
.L3031:

! 2289		    params[i] = ctx->ProjectionMatrix[i];

	ld	[%fp+68],%l1
	ld	[%fp-4],%l0
	sll	%l0,2,%l3
	add	%l1,%l3,%l0
	ld	[%l0+%l2],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+%l3]

	! block 409
.L3032:
.L3033:
.L3034:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L3025
	nop

	! block 410
.L3035:
.L3027:
.L3036:
.L3037:

! 2290		 }
! 2291		 break;

	ba	.L2413
	nop

	! block 411
.L3038:
.L3039:

! 2292	      case GL_PROJECTION_STACK_DEPTH:
! 2293		 *params = (GLfloat) ctx->ProjectionStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1250),%l1
	or	%l1,%lo(0x1250),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 412
.L3040:

! 2294		 break;

	ba	.L2413
	nop

	! block 413
.L3041:
.L3042:

! 2295	      case GL_READ_BUFFER:
! 2296		 *params = (GLfloat) ctx->Pixel.ReadBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0xae18),%l1
	or	%l1,%lo(0xae18),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 414
.L3043:

! 2297		 break;

	ba	.L2413
	nop

	! block 415
.L3044:
.L3045:

! 2298	      case GL_RED_BIAS:
! 2299	         *params = ctx->Pixel.RedBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 416
.L3046:

! 2300	         break;

	ba	.L2413
	nop

	! block 417
.L3047:
.L3048:

! 2301	      case GL_RED_BITS:
! 2302	         *params = (GLfloat) ctx->Visual->RedBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+40],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 418
.L3049:

! 2303	         break;

	ba	.L2413
	nop

	! block 419
.L3050:
.L3051:

! 2304	      case GL_RED_SCALE:
! 2305	         *params = ctx->Pixel.RedScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 420
.L3052:

! 2306	         break;

	ba	.L2413
	nop

	! block 421
.L3053:
.L3054:

! 2307	      case GL_RENDER_MODE:
! 2308		 *params = (GLfloat) ctx->RenderMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 422
.L3055:

! 2309		 break;

	ba	.L2413
	nop

	! block 423
.L3056:
.L3057:

! 2310	      case GL_RGBA_MODE:
! 2311		 *params = (GLfloat) ctx->Visual->RGBAflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 424
.L3058:

! 2312		 break;

	ba	.L2413
	nop

	! block 425
.L3059:
.L3060:

! 2313	      case GL_SCISSOR_BOX:
! 2314		 params[0] = (GLfloat) ctx->Scissor.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xd74c),%l1
	or	%l1,%lo(0xd74c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 426
.L3061:

! 2315		 params[1] = (GLfloat) ctx->Scissor.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xd750),%l1
	or	%l1,%lo(0xd750),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 427
.L3062:

! 2316		 params[2] = (GLfloat) ctx->Scissor.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xd754),%l1
	or	%l1,%lo(0xd754),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 428
.L3063:

! 2317		 params[3] = (GLfloat) ctx->Scissor.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xd758),%l1
	or	%l1,%lo(0xd758),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 429
.L3064:

! 2318		 break;

	ba	.L2413
	nop

	! block 430
.L3065:
.L3066:

! 2319	      case GL_SCISSOR_TEST:
! 2320		 *params = (GLfloat) ctx->Scissor.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd748),%l1
	or	%l1,%lo(0xd748),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 431
.L3067:

! 2321		 break;

	ba	.L2413
	nop

	! block 432
.L3068:
.L3069:

! 2322	      case GL_SHADE_MODEL:
! 2323		 *params = (GLfloat) ctx->Light.ShadeModel;

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 433
.L3070:

! 2324		 break;

	ba	.L2413
	nop

	! block 434
.L3071:
.L3072:

! 2325	      case GL_SHARED_TEXTURE_PALETTE_EXT:
! 2326	         *params = (GLfloat) ctx->Texture.SharedPalette;

	ld	[%fp+68],%l0
	sethi	%hi(0xd83c),%l1
	or	%l1,%lo(0xd83c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 435
.L3073:

! 2327	         break;

	ba	.L2413
	nop

	! block 436
.L3074:
.L3075:

! 2328	      case GL_STENCIL_BITS:
! 2329	         *params = (GLfloat) ctx->Visual->StencilBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+68],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 437
.L3076:

! 2330	         break;

	ba	.L2413
	nop

	! block 438
.L3077:
.L3078:

! 2331	      case GL_STENCIL_CLEAR_VALUE:
! 2332		 *params = (GLfloat) ctx->Stencil.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0xd772),%l1
	or	%l1,%lo(0xd772),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 439
.L3079:

! 2333		 break;

	ba	.L2413
	nop

	! block 440
.L3080:
.L3081:

! 2334	      case GL_STENCIL_FAIL:
! 2335		 *params = (GLfloat) ctx->Stencil.FailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd764),%l1
	or	%l1,%lo(0xd764),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 441
.L3082:

! 2336		 break;

	ba	.L2413
	nop

	! block 442
.L3083:
.L3084:

! 2337	      case GL_STENCIL_FUNC:
! 2338		 *params = (GLfloat) ctx->Stencil.Function;

	ld	[%fp+68],%l0
	sethi	%hi(0xd760),%l1
	or	%l1,%lo(0xd760),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 443
.L3085:

! 2339		 break;

	ba	.L2413
	nop

	! block 444
.L3086:
.L3087:

! 2340	      case GL_STENCIL_PASS_DEPTH_FAIL:
! 2341		 *params = (GLfloat) ctx->Stencil.ZFailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd76c),%l1
	or	%l1,%lo(0xd76c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 445
.L3088:

! 2342		 break;

	ba	.L2413
	nop

	! block 446
.L3089:
.L3090:

! 2343	      case GL_STENCIL_PASS_DEPTH_PASS:
! 2344		 *params = (GLfloat) ctx->Stencil.ZPassFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd768),%l1
	or	%l1,%lo(0xd768),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 447
.L3091:

! 2345		 break;

	ba	.L2413
	nop

	! block 448
.L3092:
.L3093:

! 2346	      case GL_STENCIL_REF:
! 2347		 *params = (GLfloat) ctx->Stencil.Ref;

	ld	[%fp+68],%l0
	sethi	%hi(0xd770),%l1
	or	%l1,%lo(0xd770),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 449
.L3094:

! 2348		 break;

	ba	.L2413
	nop

	! block 450
.L3095:
.L3096:

! 2349	      case GL_STENCIL_TEST:
! 2350		 *params = (GLfloat) ctx->Stencil.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd75c),%l1
	or	%l1,%lo(0xd75c),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 451
.L3097:

! 2351		 break;

	ba	.L2413
	nop

	! block 452
.L3098:
.L3099:

! 2352	      case GL_STENCIL_VALUE_MASK:
! 2353		 *params = (GLfloat) ctx->Stencil.ValueMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd771),%l1
	or	%l1,%lo(0xd771),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 453
.L3100:

! 2354		 break;

	ba	.L2413
	nop

	! block 454
.L3101:
.L3102:

! 2355	      case GL_STENCIL_WRITEMASK:
! 2356		 *params = (GLfloat) ctx->Stencil.WriteMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd773),%l1
	or	%l1,%lo(0xd773),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 455
.L3103:

! 2357		 break;

	ba	.L2413
	nop

	! block 456
.L3104:
.L3105:

! 2358	      case GL_STEREO:
! 2359		 *params = 0.0F;  /* TODO */

	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 457
.L3106:

! 2360		 break;

	ba	.L2413
	nop

	! block 458
.L3107:
.L3108:

! 2361	      case GL_SUBPIXEL_BITS:
! 2362		 *params = 0.0F;  /* TODO */

	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 459
.L3109:

! 2363		 break;

	ba	.L2413
	nop

	! block 460
.L3110:
.L3111:

! 2364	      case GL_TEXTURE_1D:
! 2365		 *params = (ctx->Texture.Enabled & TEXTURE_1D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L3112
	nop

	! block 461
.L3113:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3114
	std	%f4,[%fp-40]

	! block 462
.L3112:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-40]

	! block 463
.L3114:
	ldd	[%fp-40],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 464
.L3115:

! 2366		 break;

	ba	.L2413
	nop

	! block 465
.L3116:
.L3117:

! 2367	      case GL_TEXTURE_2D:
! 2368		 *params = (ctx->Texture.Enabled & TEXTURE_2D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L3118
	nop

	! block 466
.L3119:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3120
	std	%f4,[%fp-48]

	! block 467
.L3118:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-48]

	! block 468
.L3120:
	ldd	[%fp-48],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 469
.L3121:

! 2369		 break;

	ba	.L2413
	nop

	! block 470
.L3122:
.L3123:

! 2370	      case GL_TEXTURE_3D_EXT:
! 2371		 *params = (ctx->Texture.Enabled & TEXTURE_3D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L3124
	nop

	! block 471
.L3125:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3126
	std	%f4,[%fp-56]

	! block 472
.L3124:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-56]

	! block 473
.L3126:
	ldd	[%fp-56],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 474
.L3127:

! 2372		 break;

	ba	.L2413
	nop

	! block 475
.L3128:
.L3129:

! 2373	      case GL_TEXTURE_ENV_COLOR:
! 2374		 params[0] = ctx->Texture.EnvColor[0];

	ld	[%fp+68],%l0
	sethi	%hi(0xd77c),%l1
	or	%l1,%lo(0xd77c),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 476
.L3130:

! 2375		 params[1] = ctx->Texture.EnvColor[1];

	ld	[%fp+68],%l0
	sethi	%hi(0xd780),%l1
	or	%l1,%lo(0xd780),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 477
.L3131:

! 2376		 params[2] = ctx->Texture.EnvColor[2];

	ld	[%fp+68],%l0
	sethi	%hi(0xd784),%l1
	or	%l1,%lo(0xd784),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 478
.L3132:

! 2377		 params[3] = ctx->Texture.EnvColor[3];

	ld	[%fp+68],%l0
	sethi	%hi(0xd788),%l1
	or	%l1,%lo(0xd788),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 479
.L3133:

! 2378		 break;

	ba	.L2413
	nop

	! block 480
.L3134:
.L3135:

! 2379	      case GL_TEXTURE_ENV_MODE:
! 2380		 *params = (GLfloat) ctx->Texture.EnvMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd778),%l1
	or	%l1,%lo(0xd778),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 481
.L3136:

! 2381		 break;

	ba	.L2413
	nop

	! block 482
.L3137:
.L3138:

! 2382	      case GL_TEXTURE_GEN_S:
! 2383		 *params = (ctx->Texture.TexGenEnabled & S_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L3139
	nop

	! block 483
.L3140:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3141
	std	%f4,[%fp-64]

	! block 484
.L3139:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-64]

	! block 485
.L3141:
	ldd	[%fp-64],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 486
.L3142:

! 2384		 break;

	ba	.L2413
	nop

	! block 487
.L3143:
.L3144:

! 2385	      case GL_TEXTURE_GEN_T:
! 2386		 *params = (ctx->Texture.TexGenEnabled & T_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,8,%l0
	be	.L3145
	nop

	! block 488
.L3146:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3147
	std	%f4,[%fp-72]

	! block 489
.L3145:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-72]

	! block 490
.L3147:
	ldd	[%fp-72],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 491
.L3148:

! 2387		 break;

	ba	.L2413
	nop

	! block 492
.L3149:
.L3150:

! 2388	      case GL_TEXTURE_GEN_R:
! 2389		 *params = (ctx->Texture.TexGenEnabled & R_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L3151
	nop

	! block 493
.L3152:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3153
	std	%f4,[%fp-80]

	! block 494
.L3151:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-80]

	! block 495
.L3153:
	ldd	[%fp-80],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 496
.L3154:

! 2390		 break;

	ba	.L2413
	nop

	! block 497
.L3155:
.L3156:

! 2391	      case GL_TEXTURE_GEN_Q:
! 2392		 *params = (ctx->Texture.TexGenEnabled & Q_BIT) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L3157
	nop

	! block 498
.L3158:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L3159
	std	%f4,[%fp-88]

	! block 499
.L3157:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-88]

	! block 500
.L3159:
	ldd	[%fp-88],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 501
.L3160:

! 2393		 break;

	ba	.L2413
	nop

	! block 502
.L3161:
.L3162:
.L3163:

! 2394	      case GL_TEXTURE_MATRIX:
! 2395	         for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 503
.L_y303:
	sethi	%hi(0x1b5c),%l2
	or	%l2,%lo(0x1b5c),%l2
.L3167:
.L3164:
.L3168:
.L3169:
.L3170:

! 2396		    params[i] = ctx->TextureMatrix[i];

	ld	[%fp+68],%l1
	ld	[%fp-4],%l0
	sll	%l0,2,%l3
	add	%l1,%l3,%l0
	ld	[%l0+%l2],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+%l3]

	! block 504
.L3171:
.L3172:
.L3173:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L3164
	nop

	! block 505
.L3174:
.L3166:
.L3175:
.L3176:

! 2397		 }
! 2398		 break;

	ba	.L2413
	nop

	! block 506
.L3177:
.L3178:

! 2399	      case GL_TEXTURE_STACK_DEPTH:
! 2400		 *params = (GLfloat) ctx->TextureStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1b9c),%l1
	or	%l1,%lo(0x1b9c),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 507
.L3179:

! 2401		 break;

	ba	.L2413
	nop

	! block 508
.L3180:
.L3181:

! 2402	      case GL_UNPACK_ALIGNMENT:
! 2403		 *params = (GLfloat) ctx->Unpack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc8),%l1
	or	%l1,%lo(0xddc8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 509
.L3182:

! 2404		 break;

	ba	.L2413
	nop

	! block 510
.L3183:
.L3184:

! 2405	      case GL_UNPACK_LSB_FIRST:
! 2406		 *params = (GLfloat) ctx->Unpack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde1),%l1
	or	%l1,%lo(0xdde1),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 511
.L3185:

! 2407		 break;

	ba	.L2413
	nop

	! block 512
.L3186:
.L3187:

! 2408	      case GL_UNPACK_ROW_LENGTH:
! 2409		 *params = (GLfloat) ctx->Unpack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddcc),%l1
	or	%l1,%lo(0xddcc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 513
.L3188:

! 2410		 break;

	ba	.L2413
	nop

	! block 514
.L3189:
.L3190:

! 2411	      case GL_UNPACK_SKIP_PIXELS:
! 2412		 *params = (GLfloat) ctx->Unpack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd0),%l1
	or	%l1,%lo(0xddd0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 515
.L3191:

! 2413		 break;

	ba	.L2413
	nop

	! block 516
.L3192:
.L3193:

! 2414	      case GL_UNPACK_SKIP_ROWS:
! 2415		 *params = (GLfloat) ctx->Unpack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd4),%l1
	or	%l1,%lo(0xddd4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 517
.L3194:

! 2416		 break;

	ba	.L2413
	nop

	! block 518
.L3195:
.L3196:

! 2417	      case GL_UNPACK_SWAP_BYTES:
! 2418		 *params = (GLfloat) ctx->Unpack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde0),%l1
	or	%l1,%lo(0xdde0),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 519
.L3197:

! 2419		 break;

	ba	.L2413
	nop

	! block 520
.L3198:
.L3199:

! 2420	      case GL_UNPACK_SKIP_IMAGES_EXT:
! 2421	         *params = (GLfloat) ctx->Unpack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xdddc),%l1
	or	%l1,%lo(0xdddc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 521
.L3200:

! 2422	         break;

	ba	.L2413
	nop

	! block 522
.L3201:
.L3202:

! 2423	      case GL_UNPACK_IMAGE_HEIGHT_EXT:
! 2424	         *params = (GLfloat) ctx->Unpack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd8),%l1
	or	%l1,%lo(0xddd8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 523
.L3203:

! 2425	         break;

	ba	.L2413
	nop

	! block 524
.L3204:
.L3205:

! 2426	      case GL_VIEWPORT:
! 2427		 params[0] = (GLfloat) ctx->Viewport.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb8),%l1
	or	%l1,%lo(0xdcb8),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 525
.L3206:

! 2428		 params[1] = (GLfloat) ctx->Viewport.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcbc),%l1
	or	%l1,%lo(0xdcbc),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+4]

	! block 526
.L3207:

! 2429		 params[2] = (GLfloat) ctx->Viewport.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc0),%l1
	or	%l1,%lo(0xdcc0),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+8]

	! block 527
.L3208:

! 2430		 params[3] = (GLfloat) ctx->Viewport.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc4),%l1
	or	%l1,%lo(0xdcc4),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+12]

	! block 528
.L3209:

! 2431		 break;

	ba	.L2413
	nop

	! block 529
.L3210:
.L3211:

! 2432	      case GL_ZOOM_X:
! 2433		 *params = (GLfloat) ctx->Pixel.ZoomX;

	ld	[%fp+68],%l0
	sethi	%hi(0xae50),%l1
	or	%l1,%lo(0xae50),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 530
.L3212:

! 2434		 break;

	ba	.L2413
	nop

	! block 531
.L3213:
.L3214:

! 2435	      case GL_ZOOM_Y:
! 2436		 *params = (GLfloat) ctx->Pixel.ZoomY;

	ld	[%fp+68],%l0
	sethi	%hi(0xae54),%l1
	or	%l1,%lo(0xae54),%l1
	ld	[%l0+%l1],%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 532
.L3215:

! 2437		 break;

	ba	.L2413
	nop

	! block 533
.L3216:
.L3217:

! 2438	      case GL_VERTEX_ARRAY_SIZE:
! 2439	         *params = (GLfloat) ctx->Array.VertexSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd2c),%l1
	or	%l1,%lo(0xdd2c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 534
.L3218:

! 2440	         break;

	ba	.L2413
	nop

	! block 535
.L3219:
.L3220:

! 2441	      case GL_VERTEX_ARRAY_TYPE:
! 2442	         *params = (GLfloat) ctx->Array.VertexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd30),%l1
	or	%l1,%lo(0xdd30),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 536
.L3221:

! 2443	         break;

	ba	.L2413
	nop

	! block 537
.L3222:
.L3223:

! 2444	      case GL_VERTEX_ARRAY_STRIDE:
! 2445	         *params = (GLfloat) ctx->Array.VertexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd34),%l1
	or	%l1,%lo(0xdd34),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 538
.L3224:

! 2446	         break;

	ba	.L2413
	nop

	! block 539
.L3225:
.L3226:

! 2447	      case GL_VERTEX_ARRAY_COUNT_EXT:
! 2448	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 540
.L3227:

! 2449	         break;

	ba	.L2413
	nop

	! block 541
.L3228:
.L3229:

! 2450	      case GL_NORMAL_ARRAY_TYPE:
! 2451	         *params = (GLfloat) ctx->Array.NormalType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd44),%l1
	or	%l1,%lo(0xdd44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 542
.L3230:

! 2452	         break;

	ba	.L2413
	nop

	! block 543
.L3231:
.L3232:

! 2453	      case GL_NORMAL_ARRAY_STRIDE:
! 2454	         *params = (GLfloat) ctx->Array.NormalStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd48),%l1
	or	%l1,%lo(0xdd48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 544
.L3233:

! 2455	         break;

	ba	.L2413
	nop

	! block 545
.L3234:
.L3235:

! 2456	      case GL_NORMAL_ARRAY_COUNT_EXT:
! 2457	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 546
.L3236:

! 2458	         break;

	ba	.L2413
	nop

	! block 547
.L3237:
.L3238:

! 2459	      case GL_COLOR_ARRAY_SIZE:
! 2460	         *params = (GLfloat) ctx->Array.ColorSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd58),%l1
	or	%l1,%lo(0xdd58),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 548
.L3239:

! 2461	         break;

	ba	.L2413
	nop

	! block 549
.L3240:
.L3241:

! 2462	      case GL_COLOR_ARRAY_TYPE:
! 2463	         *params = (GLfloat) ctx->Array.ColorType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd5c),%l1
	or	%l1,%lo(0xdd5c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 550
.L3242:

! 2464	         break;

	ba	.L2413
	nop

	! block 551
.L3243:
.L3244:

! 2465	      case GL_COLOR_ARRAY_STRIDE:
! 2466	         *params = (GLfloat) ctx->Array.ColorStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd60),%l1
	or	%l1,%lo(0xdd60),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 552
.L3245:

! 2467	         break;

	ba	.L2413
	nop

	! block 553
.L3246:
.L3247:

! 2468	      case GL_COLOR_ARRAY_COUNT_EXT:
! 2469	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 554
.L3248:

! 2470	         break;

	ba	.L2413
	nop

	! block 555
.L3249:
.L3250:

! 2471	      case GL_INDEX_ARRAY_TYPE:
! 2472	         *params = (GLfloat) ctx->Array.IndexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd70),%l1
	or	%l1,%lo(0xdd70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 556
.L3251:

! 2473	         break;

	ba	.L2413
	nop

	! block 557
.L3252:
.L3253:

! 2474	      case GL_INDEX_ARRAY_STRIDE:
! 2475	         *params = (GLfloat) ctx->Array.IndexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd74),%l1
	or	%l1,%lo(0xdd74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 558
.L3254:

! 2476	         break;

	ba	.L2413
	nop

	! block 559
.L3255:
.L3256:

! 2477	      case GL_INDEX_ARRAY_COUNT_EXT:
! 2478	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 560
.L3257:

! 2479	         break;

	ba	.L2413
	nop

	! block 561
.L3258:
.L3259:

! 2480	      case GL_TEXTURE_COORD_ARRAY_SIZE:
! 2481	         *params = (GLfloat) ctx->Array.TexCoordSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd84),%l1
	or	%l1,%lo(0xdd84),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 562
.L3260:

! 2482	         break;

	ba	.L2413
	nop

	! block 563
.L3261:
.L3262:

! 2483	      case GL_TEXTURE_COORD_ARRAY_TYPE:
! 2484	         *params = (GLfloat) ctx->Array.TexCoordType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd88),%l1
	or	%l1,%lo(0xdd88),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 564
.L3263:

! 2485	         break;

	ba	.L2413
	nop

	! block 565
.L3264:
.L3265:

! 2486	      case GL_TEXTURE_COORD_ARRAY_STRIDE:
! 2487	         *params = (GLfloat) ctx->Array.TexCoordStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd8c),%l1
	or	%l1,%lo(0xdd8c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 566
.L3266:

! 2488	         break;

	ba	.L2413
	nop

	! block 567
.L3267:
.L3268:

! 2489	      case GL_TEXTURE_COORD_ARRAY_COUNT_EXT:
! 2490	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 568
.L3269:

! 2491	         break;

	ba	.L2413
	nop

	! block 569
.L3270:
.L3271:

! 2492	      case GL_EDGE_FLAG_ARRAY_STRIDE:
! 2493	         *params = (GLfloat) ctx->Array.EdgeFlagStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd9c),%l1
	or	%l1,%lo(0xdd9c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-104]
	ld	[%fp-104],%f4
	fitos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 570
.L3272:

! 2494	         break;

	ba	.L2413
	nop

	! block 571
.L3273:
.L3274:

! 2495	      case GL_EDGE_FLAG_ARRAY_COUNT_EXT:
! 2496	         *params = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 572
.L3275:

! 2497	         break;

	ba	.L2413
	nop

	! block 573
.L3276:
.L3277:

! 2498	      case GL_TEXTURE_BINDING_1D:
! 2499	         *params = (GLfloat) ctx->Texture.Current1D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 574
.L3278:

! 2500	          break;

	ba	.L2413
	nop

	! block 575
.L3279:
.L3280:

! 2501	      case GL_TEXTURE_BINDING_2D:
! 2502	         *params = (GLfloat) ctx->Texture.Current2D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 576
.L3281:

! 2503	          break;

	ba	.L2413
	nop

	! block 577
.L3282:
.L3283:

! 2504	      case GL_TEXTURE_3D_BINDING_EXT:
! 2505	         *params = (GLfloat) ctx->Texture.Current2D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-104]
	st	%l1,[%fp-100]
	ldd	[%fp-104],%f6
	mov	0,%l0
	st	%l0,[%fp-100]
	ldd	[%fp-104],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f4
	ld	[%fp+76],%l0
	st	%f4,[%l0+0]

	! block 578
.L3284:

! 2506	          break;

	ba	.L2413
	nop

	! block 579
.L3285:
.L3286:

! 2508	      default:
! 2509	         gl_error( ctx, GL_INVALID_ENUM, "glGetFloatv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3287),%l1
	or	%l1,%lo(.L3287),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 580
.L3288:
.L3289:
	ba	.L2413
	nop

	! block 581
.L2414:
.L3290:
	ld	[%fp+72],%l2
	cmp	%l2,3344
	bge	.L_y148
	nop

	! block 582
	cmp	%l2,2976
	bge	.L_y149
	nop

	! block 583
	cmp	%l2,2896
	bge	.L_y150
	nop

	! block 584
	cmp	%l2,2848
	bge	.L_y151
	nop

	! block 585
	sub	%l2,2816,%l0
	cmp	%l0,19
	bgu	.L3285
	nop

	! block 586
	sll	%l0,2,%l1
	sethi	%hi(.L_y152-80),%l0
	or	%l0,%lo(.L_y152-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 587
.L_y151:
	cmp	%l2,2880
	bge	.L_y153
	nop

	! block 588
	cmp	%l2,2864
	bge	.L_y154
	nop

	! block 589
	sub	%l2,2848,%l0
	cmp	%l0,6
	bgu	.L3285
	nop

	! block 590
	sll	%l0,2,%l1
	sethi	%hi(.L_y155-28),%l0
	or	%l0,%lo(.L_y155-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 591
.L_y154:
	sub	%l2,2864,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 592
	sll	%l0,2,%l1
	sethi	%hi(.L_y156-16),%l0
	or	%l0,%lo(.L_y156-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 593
.L_y153:
	sub	%l2,2880,%l0
	cmp	%l0,6
	bgu	.L3285
	nop

	! block 594
	sll	%l0,2,%l1
	sethi	%hi(.L_y157-28),%l0
	or	%l0,%lo(.L_y157-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 595
.L_y150:
	cmp	%l2,2928
	bge	.L_y158
	nop

	! block 596
	cmp	%l2,2912
	bge	.L_y159
	nop

	! block 597
	sub	%l2,2896,%l0
	cmp	%l0,7
	bgu	.L3285
	nop

	! block 598
	sll	%l0,2,%l1
	sethi	%hi(.L_y160-32),%l0
	or	%l0,%lo(.L_y160-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 599
.L_y159:
	sub	%l2,2912,%l0
	cmp	%l0,6
	bgu	.L3285
	nop

	! block 600
	sll	%l0,2,%l1
	sethi	%hi(.L_y161-28),%l0
	or	%l0,%lo(.L_y161-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 601
.L_y158:
	cmp	%l2,2960
	bge	.L_y162
	nop

	! block 602
	cmp	%l2,2944
	bge	.L_y163
	nop

	! block 603
	sub	%l2,2928,%l0
	cmp	%l0,4
	bgu	.L3285
	nop

	! block 604
	sll	%l0,2,%l1
	sethi	%hi(.L_y164-20),%l0
	or	%l0,%lo(.L_y164-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 605
.L_y163:
	be	.L2424
	nop

	! block 606
	ba	.L3285
	nop

	! block 607
.L_y162:
	sub	%l2,2960,%l0
	cmp	%l0,8
	bgu	.L3285
	nop

	! block 608
	sll	%l0,2,%l1
	sethi	%hi(.L_y165-36),%l0
	or	%l0,%lo(.L_y165-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 609
.L_y149:
	cmp	%l2,3136
	bge	.L_y166
	nop

	! block 610
	cmp	%l2,3056
	bge	.L_y167
	nop

	! block 611
	cmp	%l2,2992
	bge	.L_y168
	nop

	! block 612
	sub	%l2,2976,%l0
	cmp	%l0,8
	bgu	.L3285
	nop

	! block 613
	sll	%l0,2,%l1
	sethi	%hi(.L_y169-36),%l0
	or	%l0,%lo(.L_y169-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 614
.L_y168:
	cmp	%l2,3024
	bge	.L_y170
	nop

	! block 615
	cmp	%l2,3008
	bge	.L_y171
	nop

	! block 616
	cmp	%l2,2992
	be	.L2448
	nop

	! block 617
	cmp	%l2,2993
	be	.L2484
	nop

	! block 618
	ba	.L3285
	nop

	! block 619
.L_y171:
	sub	%l2,3008,%l0
	cmp	%l0,2
	bgu	.L3285
	nop

	! block 620
	sll	%l0,2,%l1
	sethi	%hi(.L_y172-12),%l0
	or	%l0,%lo(.L_y172-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 621
.L_y170:
	cmp	%l2,3040
	bge	.L_y173
	nop

	! block 622
	cmp	%l2,3024
	be	.L2606
	nop

	! block 623
	ba	.L3285
	nop

	! block 624
.L_y173:
	sub	%l2,3040,%l0
	cmp	%l0,2
	bgu	.L3285
	nop

	! block 625
	sll	%l0,2,%l1
	sethi	%hi(.L_y174-12),%l0
	or	%l0,%lo(.L_y174-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 626
.L_y167:
	cmp	%l2,3104
	bge	.L_y175
	nop

	! block 627
	cmp	%l2,3072
	bge	.L_y176
	nop

	! block 628
	sub	%l2,3056,%l0
	cmp	%l0,2
	bgu	.L3285
	nop

	! block 629
	sll	%l0,2,%l1
	sethi	%hi(.L_y177-12),%l0
	or	%l0,%lo(.L_y177-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 630
.L_y176:
	cmp	%l2,3088
	bge	.L_y178
	nop

	! block 631
	sub	%l2,3072,%l0
	cmp	%l0,2
	bgu	.L3285
	nop

	! block 632
	sll	%l0,2,%l1
	sethi	%hi(.L_y179-12),%l0
	or	%l0,%lo(.L_y179-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 633
.L_y178:
	be	.L3059
	nop

	! block 634
	cmp	%l2,3089
	be	.L3065
	nop

	! block 635
	ba	.L3285
	nop

	! block 636
.L_y175:
	cmp	%l2,3120
	bge	.L_y180
	nop

	! block 637
	sub	%l2,3104,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 638
	sll	%l0,2,%l1
	sethi	%hi(.L_y181-16),%l0
	or	%l0,%lo(.L_y181-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 639
.L_y180:
	sub	%l2,3120,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 640
	sll	%l0,2,%l1
	sethi	%hi(.L_y182-16),%l0
	or	%l0,%lo(.L_y182-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 641
.L_y166:
	cmp	%l2,3312
	bge	.L_y183
	nop

	! block 642
	cmp	%l2,3248
	bge	.L_y184
	nop

	! block 643
	cmp	%l2,3168
	bge	.L_y185
	nop

	! block 644
	cmp	%l2,3152
	bge	.L_y186
	nop

	! block 645
	cmp	%l2,3136
	be	.L3053
	nop

	! block 646
	ba	.L3285
	nop

	! block 647
.L_y186:
	sub	%l2,3152,%l0
	cmp	%l0,4
	bgu	.L3285
	nop

	! block 648
	sll	%l0,2,%l1
	sethi	%hi(.L_y187-20),%l0
	or	%l0,%lo(.L_y187-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 649
.L_y185:
	sub	%l2,3168,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 650
	sll	%l0,2,%l1
	sethi	%hi(.L_y188-16),%l0
	or	%l0,%lo(.L_y188-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 651
.L_y184:
	sub	%l2,3248,%l0
	cmp	%l0,9
	bgu	.L3285
	nop

	! block 652
	sll	%l0,2,%l1
	sethi	%hi(.L_y189-40),%l0
	or	%l0,%lo(.L_y189-40),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 653
.L_y183:
	cmp	%l2,3328
	bge	.L_y190
	nop

	! block 654
	sub	%l2,3312,%l0
	cmp	%l0,5
	bgu	.L3285
	nop

	! block 655
	sll	%l0,2,%l1
	sethi	%hi(.L_y191-24),%l0
	or	%l0,%lo(.L_y191-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 656
.L_y190:
	sub	%l2,3328,%l0
	cmp	%l0,5
	bgu	.L3285
	nop

	! block 657
	sll	%l0,2,%l1
	sethi	%hi(.L_y192-24),%l0
	or	%l0,%lo(.L_y192-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 658
.L_y148:
	cmp	%l2,3536
	bge	.L_y193
	nop

	! block 659
	cmp	%l2,3408
	bge	.L_y194
	nop

	! block 660
	cmp	%l2,3376
	bge	.L_y195
	nop

	! block 661
	sub	%l2,3344,%l0
	cmp	%l0,15
	bgu	.L3285
	nop

	! block 662
	sll	%l0,2,%l1
	sethi	%hi(.L_y196-64),%l0
	or	%l0,%lo(.L_y196-64),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 663
.L_y195:
	sub	%l2,3376,%l0
	cmp	%l0,11
	bgu	.L3285
	nop

	! block 664
	sll	%l0,2,%l1
	sethi	%hi(.L_y197-48),%l0
	or	%l0,%lo(.L_y197-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 665
.L_y194:
	cmp	%l2,3472
	bge	.L_y198
	nop

	! block 666
	cmp	%l2,3440
	bge	.L_y199
	nop

	! block 667
	sub	%l2,3408,%l0
	cmp	%l0,11
	bgu	.L3285
	nop

	! block 668
	sll	%l0,2,%l1
	sethi	%hi(.L_y200-48),%l0
	or	%l0,%lo(.L_y200-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 669
.L_y199:
	be	.L2894
	nop

	! block 670
	cmp	%l2,3456
	be	.L2451
	nop

	! block 671
	ba	.L3285
	nop

	! block 672
.L_y198:
	cmp	%l2,3504
	bge	.L_y201
	nop

	! block 673
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L3285
	nop

	! block 674
	sll	%l0,2,%l1
	sethi	%hi(.L_y202-36),%l0
	or	%l0,%lo(.L_y202-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 675
.L_y201:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L3285
	nop

	! block 676
	sll	%l0,2,%l1
	sethi	%hi(.L_y203-36),%l0
	or	%l0,%lo(.L_y203-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 677
.L_y193:
	sethi	%hi(0x8068),%l0
	or	%l0,%lo(0x8068),%l0
	cmp	%l2,%l0
	bge	.L_y204
	nop

	! block 678
	sethi	%hi(0x4000),%l0
	cmp	%l2,%l0
	bge	.L_y205
	nop

	! block 679
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	bge	.L_y206
	nop

	! block 680
	cmp	%l2,3552
	bge	.L_y207
	nop

	! block 681
	sub	%l2,3536,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 682
	sll	%l0,2,%l1
	sethi	%hi(.L_y208-16),%l0
	or	%l0,%lo(.L_y208-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 683
.L_y207:
	cmp	%l2,3569
	bge	.L_y209
	nop

	! block 684
	cmp	%l2,3552
	be	.L3110
	nop

	! block 685
	cmp	%l2,3553
	be	.L3116
	nop

	! block 686
	ba	.L3285
	nop

	! block 687
.L_y209:
	be	.L2618
	nop

	! block 688
	cmp	%l2,3570
	be	.L2621
	nop

	! block 689
	ba	.L3285
	nop

	! block 690
.L_y206:
	sethi	%hi(0x3000),%l0
	cmp	%l2,%l0
	bge	.L_y210
	nop

	! block 691
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	bge	.L_y211
	nop

	! block 692
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	be	.L3134
	nop

	! block 693
	sethi	%hi(0x2201),%l0
	or	%l0,%lo(0x2201),%l0
	cmp	%l2,%l0
	be	.L3128
	nop

	! block 694
	ba	.L3285
	nop

	! block 695
.L_y211:
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	be	.L2997
	nop

	! block 696
	ba	.L3285
	nop

	! block 697
.L_y210:
	sethi	%hi(0x3000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L3285
	nop

	! block 698
	sll	%l0,2,%l1
	sethi	%hi(.L_y212-24),%l0
	or	%l0,%lo(.L_y212-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 699
.L_y205:
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	bge	.L_y213
	nop

	! block 700
	sethi	%hi(0x4000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L3285
	nop

	! block 701
	sll	%l0,2,%l1
	sethi	%hi(.L_y214-32),%l0
	or	%l0,%lo(.L_y214-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 702
.L_y213:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	bge	.L_y215
	nop

	! block 703
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	be	.L2469
	nop

	! block 704
	sethi	%hi(0x8009),%l0
	or	%l0,%lo(0x8009),%l0
	cmp	%l2,%l0
	be	.L2466
	nop

	! block 705
	ba	.L3285
	nop

	! block 706
.L_y215:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	be	.L2994
	nop

	! block 707
	sethi	%hi(0x8039),%l0
	or	%l0,%lo(0x8039),%l0
	cmp	%l2,%l0
	be	.L2991
	nop

	! block 708
	ba	.L3285
	nop

	! block 709
.L_y204:
	sethi	%hi(0x807a),%l0
	or	%l0,%lo(0x807a),%l0
	cmp	%l2,%l0
	bge	.L_y216
	nop

	! block 710
	sethi	%hi(0x8068),%l1
	or	%l1,%lo(0x8068),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L3285
	nop

	! block 711
	sll	%l0,2,%l1
	sethi	%hi(.L_y217-32),%l0
	or	%l0,%lo(.L_y217-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 712
.L_y216:
	sethi	%hi(0x8126),%l0
	or	%l0,%lo(0x8126),%l0
	cmp	%l2,%l0
	bge	.L_y218
	nop

	! block 713
	sethi	%hi(0x807a),%l1
	or	%l1,%lo(0x807a),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,19
	bgu	.L3285
	nop

	! block 714
	sll	%l0,2,%l1
	sethi	%hi(.L_y219-80),%l0
	or	%l0,%lo(.L_y219-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 715
.L_y218:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	bge	.L_y220
	nop

	! block 716
	sethi	%hi(0x8126),%l1
	or	%l1,%lo(0x8126),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,3
	bgu	.L3285
	nop

	! block 717
	sll	%l0,2,%l1
	sethi	%hi(.L_y221-16),%l0
	or	%l0,%lo(.L_y221-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 718
.L_y220:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	be	.L3071
	nop

	! block 719
	ba	.L3285
	nop

	! block 720
.L3291:
.L2413:
.L3292:

	! block 721
.L3293:
.L3294:
.L2396:
	jmp	%i7+8
	restore
	.size	gl_GetFloatv,(.-gl_GetFloatv)

	.word	.L2534
	.word	.L2540
	.word	.L2543
	.word	.L2575
	.word	.L2548
	.word	.L2557
	.word	.L2566
	.word	.L2560
	.word	.L2572
	.word	.L2554
	.word	.L3285
	.word	.L3285
	.word	.L3285
	.word	.L3285
	.word	.L3285
	.word	.L3285
	.word	.L2967
	.word	.L2957
	.word	.L2963
	.word	.L2960
.L_y152:
	.word	.L2709
	.word	.L2724
	.word	.L2730
	.word	.L2727
	.word	.L2715
	.word	.L2718
	.word	.L2721
.L_y155:
	.word	.L2740
	.word	.L2850
	.word	.L2734
	.word	.L2737
.L_y156:
	.word	.L2987
	.word	.L3000
	.word	.L3006
	.word	.L2615
	.word	.L2528
	.word	.L2531
	.word	.L2651
.L_y157:
	.word	.L2694
	.word	.L2703
	.word	.L2706
	.word	.L2697
	.word	.L3068
	.word	.L2504
	.word	.L2507
	.word	.L2501
.L_y160:
	.word	.L2624
	.word	.L2642
	.word	.L2633
	.word	.L2648
	.word	.L2636
	.word	.L2645
	.word	.L2627
.L_y161:
	.word	.L2593
	.word	.L2600
	.word	.L2603
	.word	.L2587
	.word	.L2590
.L_y164:
	.word	.L3095
	.word	.L3077
	.word	.L3083
	.word	.L3098
	.word	.L3080
	.word	.L3086
	.word	.L3089
	.word	.L3092
	.word	.L3101
.L_y165:
	.word	.L2832
	.word	.L2897
	.word	.L3204
	.word	.L2891
	.word	.L3038
	.word	.L3177
	.word	.L2875
	.word	.L3022
	.word	.L3161
.L_y169:
	.word	.L2439
	.word	.L2442
	.word	.L2445
.L_y172:
	.word	.L2460
	.word	.L2463
	.word	.L2457
.L_y174:
	.word	.L2752
	.word	.L2746
	.word	.L2749
.L_y177:
	.word	.L2454
	.word	.L2612
	.word	.L3041
.L_y179:
	.word	.L2666
	.word	.L2681
	.word	.L2495
	.word	.L2510
.L_y181:
	.word	.L2669
	.word	.L3056
	.word	.L2609
	.word	.L3104
.L_y182:
	.word	.L2924
	.word	.L2970
	.word	.L2712
	.word	.L3003
	.word	.L2639
.L_y187:
	.word	.L3137
	.word	.L3143
	.word	.L3149
	.word	.L3155
.L_y188:
	.word	.L2945
	.word	.L2954
	.word	.L2948
	.word	.L2942
	.word	.L2939
	.word	.L2936
	.word	.L2951
	.word	.L2933
	.word	.L2930
	.word	.L2927
.L_y189:
	.word	.L3195
	.word	.L3183
	.word	.L3186
	.word	.L3192
	.word	.L3189
	.word	.L3180
.L_y191:
	.word	.L2915
	.word	.L2903
	.word	.L2906
	.word	.L2912
	.word	.L2909
	.word	.L2900
.L_y192:
	.word	.L2826
	.word	.L2829
	.word	.L2678
	.word	.L2675
	.word	.L3050
	.word	.L3044
	.word	.L3210
	.word	.L3213
	.word	.L2660
	.word	.L2654
	.word	.L2481
	.word	.L2475
	.word	.L2436
	.word	.L2430
	.word	.L2597
	.word	.L2581
.L_y196:
	.word	.L2844
	.word	.L2847
	.word	.L2841
	.word	.L2865
	.word	.L2859
	.word	.L2835
	.word	.L2853
	.word	.L2856
	.word	.L2862
	.word	.L2868
	.word	.L2871
	.word	.L2838
.L_y197:
	.word	.L3107
	.word	.L2663
	.word	.L3047
	.word	.L2657
	.word	.L2478
	.word	.L2433
	.word	.L2584
	.word	.L3074
	.word	.L2418
	.word	.L2419
	.word	.L2420
	.word	.L2421
.L_y200:
	.word	.L2755
	.word	.L2765
	.word	.L2768
	.word	.L2771
	.word	.L2774
	.word	.L2777
	.word	.L2780
	.word	.L2783
	.word	.L2786
.L_y202:
	.word	.L2789
	.word	.L2802
	.word	.L2805
	.word	.L2808
	.word	.L2811
	.word	.L2814
	.word	.L2817
	.word	.L2820
	.word	.L2823
.L_y203:
	.word	.L2758
	.word	.L2762
	.word	.L2792
	.word	.L2798
.L_y208:
	.word	.L2487
	.word	.L2488
	.word	.L2489
	.word	.L2490
	.word	.L2491
	.word	.L2492
.L_y212:
	.word	.L2684
	.word	.L2685
	.word	.L2686
	.word	.L2687
	.word	.L2688
	.word	.L2689
	.word	.L2690
	.word	.L2691
.L_y214:
	.word	.L3276
	.word	.L3279
	.word	.L3282
	.word	.L2918
	.word	.L2921
	.word	.L3198
	.word	.L3201
	.word	.L3122
.L_y217:
	.word	.L3216
	.word	.L3219
	.word	.L3222
	.word	.L3225
	.word	.L3228
	.word	.L3231
	.word	.L3234
	.word	.L3237
	.word	.L3240
	.word	.L3243
	.word	.L3246
	.word	.L3249
	.word	.L3252
	.word	.L3255
	.word	.L3258
	.word	.L3261
	.word	.L3264
	.word	.L3267
	.word	.L3270
	.word	.L3273
.L_y219:
	.word	.L2973
	.word	.L2976
	.word	.L2979
	.word	.L2982
.L_y221:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetIntegerv
	.type	gl_GetIntegerv,#function
gl_GetIntegerv:
	save	%sp,-184,%sp

	! block 1
.L3297:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L3298:
.L3300:
.L3302:

! File get.c:
! 2510	   }
! 2511	}
! 2512	
! 2516	void gl_GetIntegerv( GLcontext *ctx, GLenum pname, GLint *params )
! 2517	{
! 2518	   GLuint i;
! 2519	
! 2520	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3301
	nop

	! block 3
.L3303:
.L3304:
.L3305:
.L3306:

! 2521	      gl_error( ctx, GL_INVALID_OPERATION, "glGetIntegerv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3307),%l1
	or	%l1,%lo(.L3307),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3308:

! 2522	      return;

	ba	.L3296
	nop

	! block 5
.L3309:
.L3310:
.L3301:
.L3311:
.L3312:
.L3315:

! 2523	   }
! 2524	   switch (pname) {

	ba	.L3314
	nop

	! block 6
.L3316:
.L3317:
.L3318:
.L3319:
.L3320:
.L3321:
.L3322:

! 2525	      case GL_ACCUM_RED_BITS:
! 2526	      case GL_ACCUM_GREEN_BITS:
! 2527	      case GL_ACCUM_BLUE_BITS:
! 2528	      case GL_ACCUM_ALPHA_BITS:
! 2529	         *params = (GLint) ctx->Visual->AccumBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+60],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 7
.L3323:

! 2530	         break;

	ba	.L3313
	nop

	! block 8
.L3324:
.L3325:

! 2531	      case GL_ACCUM_CLEAR_VALUE:
! 2532	         params[0] = FLOAT_TO_INT( ctx->Accum.ClearColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 9
.L3326:

! 2533	         params[1] = FLOAT_TO_INT( ctx->Accum.ClearColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 10
.L3327:

! 2534	         params[2] = FLOAT_TO_INT( ctx->Accum.ClearColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 11
.L3328:

! 2535	         params[3] = FLOAT_TO_INT( ctx->Accum.ClearColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e6c),%l1
	or	%l1,%lo(0x1e6c),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 12
.L3329:

! 2536	         break;

	ba	.L3313
	nop

	! block 13
.L3330:
.L3331:

! 2537	      case GL_ALPHA_BIAS:
! 2538	         *params = (GLint) ctx->Pixel.AlphaBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 14
.L3332:

! 2539	         break;

	ba	.L3313
	nop

	! block 15
.L3333:
.L3334:

! 2540	      case GL_ALPHA_BITS:
! 2541	         *params = ctx->Visual->AlphaBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+52],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 16
.L3335:

! 2542	         break;

	ba	.L3313
	nop

	! block 17
.L3336:
.L3337:

! 2543	      case GL_ALPHA_SCALE:
! 2544	         *params = (GLint) ctx->Pixel.AlphaScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 18
.L3338:

! 2545	         break;

	ba	.L3313
	nop

	! block 19
.L3339:
.L3340:

! 2546	      case GL_ALPHA_TEST:
! 2547	         *params = (GLint) ctx->Color.AlphaEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea0),%l1
	or	%l1,%lo(0x1ea0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 20
.L3341:

! 2548	         break;

	ba	.L3313
	nop

	! block 21
.L3342:
.L3343:

! 2549	      case GL_ALPHA_TEST_REF:
! 2550	         *params = FLOAT_TO_INT( ctx->Color.AlphaRef );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea8),%l1
	or	%l1,%lo(0x1ea8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 22
.L3344:

! 2551	         break;

	ba	.L3313
	nop

	! block 23
.L3345:
.L3346:

! 2552	      case GL_ALPHA_TEST_FUNC:
! 2553	         *params = (GLint) ctx->Color.AlphaFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ea4),%l1
	or	%l1,%lo(0x1ea4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 24
.L3347:

! 2554	         break;

	ba	.L3313
	nop

	! block 25
.L3348:
.L3349:

! 2555	      case GL_ATTRIB_STACK_DEPTH:
! 2556	         *params = (GLint) ctx->AttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e28),%l1
	or	%l1,%lo(0x1e28),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 26
.L3350:

! 2557	         break;

	ba	.L3313
	nop

	! block 27
.L3351:
.L3352:

! 2558	      case GL_AUTO_NORMAL:
! 2559	         *params = (GLint) ctx->Eval.AutoNormal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f52),%l1
	or	%l1,%lo(0x1f52),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 28
.L3353:

! 2560	         break;

	ba	.L3313
	nop

	! block 29
.L3354:
.L3355:

! 2561	      case GL_AUX_BUFFERS:
! 2562	         *params = (GLint) NUM_AUX_BUFFERS;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 30
.L3356:

! 2563	         break;

	ba	.L3313
	nop

	! block 31
.L3357:
.L3358:

! 2564	      case GL_BLEND:
! 2565	         *params = (GLint) ctx->Color.BlendEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ead),%l1
	or	%l1,%lo(0x1ead),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 32
.L3359:

! 2566	         break;

	ba	.L3313
	nop

	! block 33
.L3360:
.L3361:

! 2567	      case GL_BLEND_DST:
! 2568	         *params = (GLint) ctx->Color.BlendDst;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb4),%l1
	or	%l1,%lo(0x1eb4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 34
.L3362:

! 2569	         break;

	ba	.L3313
	nop

	! block 35
.L3363:
.L3364:

! 2570	      case GL_BLEND_SRC:
! 2571	         *params = (GLint) ctx->Color.BlendSrc;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb0),%l1
	or	%l1,%lo(0x1eb0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 36
.L3365:

! 2572	         break;

	ba	.L3313
	nop

	! block 37
.L3366:
.L3367:

! 2573	      case GL_BLEND_EQUATION_EXT:
! 2574		 *params = (GLint) ctx->Color.BlendEquation;

	ld	[%fp+68],%l0
	sethi	%hi(0x1eb8),%l1
	or	%l1,%lo(0x1eb8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 38
.L3368:

! 2575		 break;

	ba	.L3313
	nop

	! block 39
.L3369:
.L3370:

! 2576	      case GL_BLEND_COLOR_EXT:
! 2577		 params[0] = FLOAT_TO_INT( ctx->Color.BlendColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ebc),%l1
	or	%l1,%lo(0x1ebc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 40
.L3371:

! 2578		 params[1] = FLOAT_TO_INT( ctx->Color.BlendColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec0),%l1
	or	%l1,%lo(0x1ec0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 41
.L3372:

! 2579		 params[2] = FLOAT_TO_INT( ctx->Color.BlendColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec4),%l1
	or	%l1,%lo(0x1ec4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 42
.L3373:

! 2580		 params[3] = FLOAT_TO_INT( ctx->Color.BlendColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ec8),%l1
	or	%l1,%lo(0x1ec8),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 43
.L3374:

! 2581		 break;

	ba	.L3313
	nop

	! block 44
.L3375:
.L3376:

! 2582	      case GL_BLUE_BIAS:
! 2583	         *params = (GLint) ctx->Pixel.BlueBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 45
.L3377:

! 2584	         break;

	ba	.L3313
	nop

	! block 46
.L3378:
.L3379:

! 2585	      case GL_BLUE_BITS:
! 2586	         *params = (GLint) ctx->Visual->BlueBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+48],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 47
.L3380:

! 2587	         break;

	ba	.L3313
	nop

	! block 48
.L3381:
.L3382:

! 2588	      case GL_BLUE_SCALE:
! 2589	         *params = (GLint) ctx->Pixel.BlueScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 49
.L3383:

! 2590	         break;

	ba	.L3313
	nop

	! block 50
.L3384:
.L3385:

! 2591	      case GL_CLIENT_ATTRIB_STACK_DEPTH:
! 2592	         *params = ctx->ClientAttribStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdce8),%l1
	or	%l1,%lo(0xdce8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 51
.L3386:

! 2593	         break;

	ba	.L3313
	nop

	! block 52
.L3387:
.L3388:
.L3389:
.L3390:
.L3391:
.L3392:
.L3393:

! 2594	      case GL_CLIP_PLANE0:
! 2595	      case GL_CLIP_PLANE1:
! 2596	      case GL_CLIP_PLANE2:
! 2597	      case GL_CLIP_PLANE3:
! 2598	      case GL_CLIP_PLANE4:
! 2599	      case GL_CLIP_PLANE5:
! 2600	         i = (GLint) (pname - GL_CLIP_PLANE0);

	ld	[%fp+72],%l0
	sethi	%hi(0x3000),%l1
	sub	%l0,%l1,%l0
	st	%l0,[%fp-4]

	! block 53
.L3394:

! 2601	         *params = (GLint) ctx->Transform.ClipEnabled[i];

	ld	[%fp+68],%l0
	ld	[%fp-4],%l1
	add	%l0,%l1,%l0
	sethi	%hi(0xdcb0),%l1
	or	%l1,%lo(0xdcb0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 54
.L3395:

! 2602	         break;

	ba	.L3313
	nop

	! block 55
.L3396:
.L3397:

! 2603	      case GL_COLOR_CLEAR_VALUE:
! 2604	         params[0] = FLOAT_TO_INT( ctx->Color.ClearColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e80),%l1
	or	%l1,%lo(0x1e80),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 56
.L3398:

! 2605	         params[1] = FLOAT_TO_INT( ctx->Color.ClearColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e84),%l1
	or	%l1,%lo(0x1e84),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 57
.L3399:

! 2606	         params[2] = FLOAT_TO_INT( ctx->Color.ClearColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e88),%l1
	or	%l1,%lo(0x1e88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 58
.L3400:

! 2607	         params[3] = FLOAT_TO_INT( ctx->Color.ClearColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1e8c),%l1
	or	%l1,%lo(0x1e8c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-76]
	ld	[%fp-76],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 59
.L3401:

! 2608	         break;

	ba	.L3313
	nop

	! block 60
.L3402:
.L3403:

! 2609	      case GL_COLOR_MATERIAL:
! 2610	         *params = (GLint) ctx->Light.ColorMaterialEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xaddc),%l1
	or	%l1,%lo(0xaddc),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 61
.L3404:

! 2611	         break;

	ba	.L3313
	nop

	! block 62
.L3405:
.L3406:

! 2612	      case GL_COLOR_MATERIAL_FACE:
! 2613	         *params = (GLint) ctx->Light.ColorMaterialFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd0),%l1
	or	%l1,%lo(0xadd0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 63
.L3407:

! 2614	         break;

	ba	.L3313
	nop

	! block 64
.L3408:
.L3409:

! 2615	      case GL_COLOR_MATERIAL_PARAMETER:
! 2616	         *params = (GLint) ctx->Light.ColorMaterialMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xadd4),%l1
	or	%l1,%lo(0xadd4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 65
.L3410:

! 2617	         break;

	ba	.L3313
	nop

	! block 66
.L3411:
.L3412:

! 2618	      case GL_COLOR_WRITEMASK:
! 2619	         params[0] = (ctx->Color.ColorMask & 8) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,8,%l0
	cmp	%g0,%l0

	! block 67
.L3414:

	! block 68
.L3413:

	! block 69
.L3415:
	addx	%g0,0,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 70
.L3416:

! 2620	         params[1] = (ctx->Color.ColorMask & 4) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,4,%l0
	cmp	%g0,%l0

	! block 71
.L3418:

	! block 72
.L3417:

	! block 73
.L3419:
	addx	%g0,0,%l0
	st	%l0,[%fp-12]
	ld	[%fp-12],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 74
.L3420:

! 2621	         params[2] = (ctx->Color.ColorMask & 2) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,2,%l0
	cmp	%g0,%l0

	! block 75
.L3422:

	! block 76
.L3421:

	! block 77
.L3423:
	addx	%g0,0,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 78
.L3424:

! 2622	         params[3] = (ctx->Color.ColorMask & 1) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e94),%l1
	or	%l1,%lo(0x1e94),%l1
	ld	[%l0+%l1],%l0
	and	%l0,1,%l0
	cmp	%g0,%l0

	! block 79
.L3426:

	! block 80
.L3425:

	! block 81
.L3427:
	addx	%g0,0,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 82
.L3428:

! 2623	         break;

	ba	.L3313
	nop

	! block 83
.L3429:
.L3430:

! 2624	      case GL_CULL_FACE:
! 2625	         *params = (GLint) ctx->Polygon.CullFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6ad),%l1
	or	%l1,%lo(0xd6ad),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 84
.L3431:

! 2626	         break;

	ba	.L3313
	nop

	! block 85
.L3432:
.L3433:

! 2627	      case GL_CULL_FACE_MODE:
! 2628	         *params = (GLint) ctx->Polygon.CullFaceMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b0),%l1
	or	%l1,%lo(0xd6b0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 86
.L3434:

! 2629	         break;

	ba	.L3313
	nop

	! block 87
.L3435:
.L3436:

! 2630	      case GL_CURRENT_COLOR:
! 2631	         params[0] = FLOAT_TO_INT( (ctx->Current.ByteColor[0]*ctx->Visual->InvRedScale) );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-88]
	st	%l1,[%fp-84]
	ldd	[%fp-88],%f6
	mov	0,%l0
	st	%l0,[%fp-84]
	ldd	[%fp-88],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 88
.L3437:

! 2632	         params[1] = FLOAT_TO_INT( (ctx->Current.ByteColor[1]*ctx->Visual->InvGreenScale) );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+1],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-88]
	st	%l1,[%fp-84]
	ldd	[%fp-88],%f6
	mov	0,%l0
	st	%l0,[%fp-84]
	ldd	[%fp-88],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 89
.L3438:

! 2633	         params[2] = FLOAT_TO_INT( (ctx->Current.ByteColor[2]*ctx->Visual->InvBlueScale) );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+2],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-88]
	st	%l1,[%fp-84]
	ldd	[%fp-88],%f6
	mov	0,%l0
	st	%l0,[%fp-84]
	ldd	[%fp-88],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 90
.L3439:

! 2634	         params[3] = FLOAT_TO_INT( (ctx->Current.ByteColor[3]*ctx->Visual->InvAlphaScale) );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed4),%l1
	or	%l1,%lo(0x1ed4),%l1
	add	%l0,%l1,%l0
	ldub	[%l0+3],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-88]
	st	%l1,[%fp-84]
	ldd	[%fp-88],%f6
	mov	0,%l0
	st	%l0,[%fp-84]
	ldd	[%fp-88],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f4
	fmuls	%f5,%f4,%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 91
.L3440:

! 2635	         break;

	ba	.L3313
	nop

	! block 92
.L3441:
.L3442:

! 2636	      case GL_CURRENT_INDEX:
! 2637	         *params = (GLint) ctx->Current.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed8),%l1
	or	%l1,%lo(0x1ed8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 93
.L3443:

! 2638	         break;

	ba	.L3313
	nop

	! block 94
.L3444:
.L3445:

! 2639	      case GL_CURRENT_NORMAL:
! 2640	         params[0] = FLOAT_TO_INT( ctx->Current.Normal[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1edc),%l1
	or	%l1,%lo(0x1edc),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 95
.L3446:

! 2641	         params[1] = FLOAT_TO_INT( ctx->Current.Normal[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee0),%l1
	or	%l1,%lo(0x1ee0),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 96
.L3447:

! 2642	         params[2] = FLOAT_TO_INT( ctx->Current.Normal[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee4),%l1
	or	%l1,%lo(0x1ee4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 97
.L3448:

! 2643	         break;

	ba	.L3313
	nop

	! block 98
.L3449:
.L3450:

! 2644	      case GL_CURRENT_RASTER_COLOR:
! 2645		 params[0] = FLOAT_TO_INT( ctx->Current.RasterColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f0c),%l1
	or	%l1,%lo(0x1f0c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 99
.L3451:

! 2646		 params[1] = FLOAT_TO_INT( ctx->Current.RasterColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f10),%l1
	or	%l1,%lo(0x1f10),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 100
.L3452:

! 2647		 params[2] = FLOAT_TO_INT( ctx->Current.RasterColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f14),%l1
	or	%l1,%lo(0x1f14),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 101
.L3453:

! 2648		 params[3] = FLOAT_TO_INT( ctx->Current.RasterColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f18),%l1
	or	%l1,%lo(0x1f18),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 102
.L3454:

! 2649		 break;

	ba	.L3313
	nop

	! block 103
.L3455:
.L3456:

! 2650	      case GL_CURRENT_RASTER_DISTANCE:
! 2651		 params[0] = (GLint) ctx->Current.RasterDistance;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f08),%l1
	or	%l1,%lo(0x1f08),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 104
.L3457:

! 2652		 break;

	ba	.L3313
	nop

	! block 105
.L3458:
.L3459:

! 2653	      case GL_CURRENT_RASTER_INDEX:
! 2654		 *params = (GLint) ctx->Current.RasterIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f1c),%l1
	or	%l1,%lo(0x1f1c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 106
.L3460:

! 2655		 break;

	ba	.L3313
	nop

	! block 107
.L3461:
.L3462:

! 2656	      case GL_CURRENT_RASTER_POSITION:
! 2657		 params[0] = (GLint) ctx->Current.RasterPos[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef8),%l1
	or	%l1,%lo(0x1ef8),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 108
.L3463:

! 2658		 params[1] = (GLint) ctx->Current.RasterPos[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1efc),%l1
	or	%l1,%lo(0x1efc),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 109
.L3464:

! 2659		 params[2] = (GLint) ctx->Current.RasterPos[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f00),%l1
	or	%l1,%lo(0x1f00),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 110
.L3465:

! 2660		 params[3] = (GLint) ctx->Current.RasterPos[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f04),%l1
	or	%l1,%lo(0x1f04),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 111
.L3466:

! 2661		 break;

	ba	.L3313
	nop

	! block 112
.L3467:
.L3468:

! 2662	      case GL_CURRENT_RASTER_TEXTURE_COORDS:
! 2663		 params[0] = (GLint) ctx->Current.RasterTexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f20),%l1
	or	%l1,%lo(0x1f20),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 113
.L3469:

! 2664		 params[1] = (GLint) ctx->Current.RasterTexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f24),%l1
	or	%l1,%lo(0x1f24),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 114
.L3470:

! 2665		 params[2] = (GLint) ctx->Current.RasterTexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f28),%l1
	or	%l1,%lo(0x1f28),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 115
.L3471:

! 2666		 params[3] = (GLint) ctx->Current.RasterTexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1f2c),%l1
	or	%l1,%lo(0x1f2c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 116
.L3472:

! 2667		 break;

	ba	.L3313
	nop

	! block 117
.L3473:
.L3474:

! 2668	      case GL_CURRENT_RASTER_POSITION_VALID:
! 2669		 *params = (GLint) ctx->Current.RasterPosValid;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f30),%l1
	or	%l1,%lo(0x1f30),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 118
.L3475:

! 2670		 break;

	ba	.L3313
	nop

	! block 119
.L3476:
.L3477:

! 2671	      case GL_CURRENT_TEXTURE_COORDS:
! 2672	         params[0] = (GLint) ctx->Current.TexCoord[0];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ee8),%l1
	or	%l1,%lo(0x1ee8),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 120
.L3478:

! 2673	         params[1] = (GLint) ctx->Current.TexCoord[1];

	ld	[%fp+68],%l0
	sethi	%hi(0x1eec),%l1
	or	%l1,%lo(0x1eec),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 121
.L3479:

! 2674	         params[2] = (GLint) ctx->Current.TexCoord[2];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef0),%l1
	or	%l1,%lo(0x1ef0),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 122
.L3480:

! 2675	         params[3] = (GLint) ctx->Current.TexCoord[3];

	ld	[%fp+68],%l0
	sethi	%hi(0x1ef4),%l1
	or	%l1,%lo(0x1ef4),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 123
.L3481:

! 2676		 break;

	ba	.L3313
	nop

	! block 124
.L3482:
.L3483:

! 2677	      case GL_DEPTH_BIAS:
! 2678	         *params = (GLint) ctx->Pixel.DepthBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae3c),%l1
	or	%l1,%lo(0xae3c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 125
.L3484:

! 2679		 break;

	ba	.L3313
	nop

	! block 126
.L3485:
.L3486:

! 2680	      case GL_DEPTH_BITS:
! 2681		 *params = ctx->Visual->DepthBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+64],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 127
.L3487:

! 2682		 break;

	ba	.L3313
	nop

	! block 128
.L3488:
.L3489:

! 2683	      case GL_DEPTH_CLEAR_VALUE:
! 2684	         *params = (GLint) ctx->Depth.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f38),%l1
	or	%l1,%lo(0x1f38),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 129
.L3490:

! 2685		 break;

	ba	.L3313
	nop

	! block 130
.L3491:
.L3492:

! 2686	      case GL_DEPTH_FUNC:
! 2687	         *params = (GLint) ctx->Depth.Func;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f34),%l1
	or	%l1,%lo(0x1f34),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 131
.L3493:

! 2688		 break;

	ba	.L3313
	nop

	! block 132
.L3494:
.L3495:

! 2689	      case GL_DEPTH_RANGE:
! 2690	         params[0] = (GLint) ctx->Viewport.Near;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc8),%l1
	or	%l1,%lo(0xdcc8),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 133
.L3496:

! 2691	         params[1] = (GLint) ctx->Viewport.Far;

	ld	[%fp+68],%l0
	sethi	%hi(0xdccc),%l1
	or	%l1,%lo(0xdccc),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 134
.L3497:

! 2692		 break;

	ba	.L3313
	nop

	! block 135
.L3498:
.L3499:

! 2693	      case GL_DEPTH_SCALE:
! 2694	         *params = (GLint) ctx->Pixel.DepthScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae40),%l1
	or	%l1,%lo(0xae40),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 136
.L3500:

! 2695		 break;

	ba	.L3313
	nop

	! block 137
.L3501:
.L3502:

! 2696	      case GL_DEPTH_TEST:
! 2697	         *params = (GLint) ctx->Depth.Test;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3c),%l1
	or	%l1,%lo(0x1f3c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 138
.L3503:

! 2698		 break;

	ba	.L3313
	nop

	! block 139
.L3504:
.L3505:

! 2699	      case GL_DEPTH_WRITEMASK:
! 2700		 *params = (GLint) ctx->Depth.Mask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f3d),%l1
	or	%l1,%lo(0x1f3d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 140
.L3506:

! 2701		 break;

	ba	.L3313
	nop

	! block 141
.L3507:
.L3508:

! 2702	      case GL_DITHER:
! 2703		 *params = (GLint) ctx->Color.DitherFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed3),%l1
	or	%l1,%lo(0x1ed3),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 142
.L3509:

! 2704		 break;

	ba	.L3313
	nop

	! block 143
.L3510:
.L3511:

! 2705	      case GL_DOUBLEBUFFER:
! 2706		 *params = (GLint) ctx->Visual->DBflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 144
.L3512:

! 2707		 break;

	ba	.L3313
	nop

	! block 145
.L3513:
.L3514:

! 2708	      case GL_DRAW_BUFFER:
! 2709		 *params = (GLint) ctx->Color.DrawBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e9c),%l1
	or	%l1,%lo(0x1e9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 146
.L3515:

! 2710		 break;

	ba	.L3313
	nop

	! block 147
.L3516:
.L3517:

! 2711	      case GL_EDGE_FLAG:
! 2712		 *params = (GLint) ctx->Current.EdgeFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f31),%l1
	or	%l1,%lo(0x1f31),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 148
.L3518:

! 2713		 break;

	ba	.L3313
	nop

	! block 149
.L3519:
.L3520:

! 2714	      case GL_FEEDBACK_BUFFER_SIZE:
! 2715	         /* TODO: is this right?  Or, return number of entries in buffer? */
! 2716	         *params = ctx->Feedback.BufferSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc4),%l1
	or	%l1,%lo(0xdfc4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 150
.L3521:

! 2717	         break;

	ba	.L3313
	nop

	! block 151
.L3522:
.L3523:

! 2718	      case GL_FEEDBACK_BUFFER_TYPE:
! 2719	         *params = ctx->Feedback.Type;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfb8),%l1
	or	%l1,%lo(0xdfb8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 152
.L3524:

! 2720	         break;

	ba	.L3313
	nop

	! block 153
.L3525:
.L3526:

! 2721	      case GL_FOG:
! 2722		 *params = (GLint) ctx->Fog.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f78),%l1
	or	%l1,%lo(0x1f78),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 154
.L3527:

! 2723		 break;

	ba	.L3313
	nop

	! block 155
.L3528:
.L3529:

! 2724	      case GL_FOG_COLOR:
! 2725		 params[0] = FLOAT_TO_INT( ctx->Fog.Color[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f7c),%l1
	or	%l1,%lo(0x1f7c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 156
.L3530:

! 2726		 params[1] = FLOAT_TO_INT( ctx->Fog.Color[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f80),%l1
	or	%l1,%lo(0x1f80),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 157
.L3531:

! 2727		 params[2] = FLOAT_TO_INT( ctx->Fog.Color[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f84),%l1
	or	%l1,%lo(0x1f84),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 158
.L3532:

! 2728		 params[3] = FLOAT_TO_INT( ctx->Fog.Color[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0x1f88),%l1
	or	%l1,%lo(0x1f88),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 159
.L3533:

! 2729		 break;

	ba	.L3313
	nop

	! block 160
.L3534:
.L3535:

! 2730	      case GL_FOG_DENSITY:
! 2731		 *params = (GLint) ctx->Fog.Density;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f8c),%l1
	or	%l1,%lo(0x1f8c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 161
.L3536:

! 2732		 break;

	ba	.L3313
	nop

	! block 162
.L3537:
.L3538:

! 2733	      case GL_FOG_END:
! 2734		 *params = (GLint) ctx->Fog.End;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f94),%l1
	or	%l1,%lo(0x1f94),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 163
.L3539:

! 2735		 break;

	ba	.L3313
	nop

	! block 164
.L3540:
.L3541:

! 2736	      case GL_FOG_HINT:
! 2737		 *params = (GLint) ctx->Hint.Fog;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb0),%l1
	or	%l1,%lo(0x1fb0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 165
.L3542:

! 2738		 break;

	ba	.L3313
	nop

	! block 166
.L3543:
.L3544:

! 2739	      case GL_FOG_INDEX:
! 2740		 *params = (GLint) ctx->Fog.Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f98),%l1
	or	%l1,%lo(0x1f98),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 167
.L3545:

! 2741		 break;

	ba	.L3313
	nop

	! block 168
.L3546:
.L3547:

! 2742	      case GL_FOG_MODE:
! 2743		 *params = (GLint) ctx->Fog.Mode;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f9c),%l1
	or	%l1,%lo(0x1f9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 169
.L3548:

! 2744		 break;

	ba	.L3313
	nop

	! block 170
.L3549:
.L3550:

! 2745	      case GL_FOG_START:
! 2746		 *params = (GLint) ctx->Fog.Start;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f90),%l1
	or	%l1,%lo(0x1f90),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 171
.L3551:

! 2747		 break;

	ba	.L3313
	nop

	! block 172
.L3552:
.L3553:

! 2748	      case GL_FRONT_FACE:
! 2749		 *params = (GLint) ctx->Polygon.FrontFace;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a0),%l1
	or	%l1,%lo(0xd6a0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 173
.L3554:

! 2750		 break;

	ba	.L3313
	nop

	! block 174
.L3555:
.L3556:

! 2751	      case GL_GREEN_BIAS:
! 2752	         *params = (GLint) ctx->Pixel.GreenBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 175
.L3557:

! 2753	         break;

	ba	.L3313
	nop

	! block 176
.L3558:
.L3559:

! 2754	      case GL_GREEN_BITS:
! 2755	         *params = (GLint) ctx->Visual->GreenBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+44],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 177
.L3560:

! 2756	         break;

	ba	.L3313
	nop

	! block 178
.L3561:
.L3562:

! 2757	      case GL_GREEN_SCALE:
! 2758	         *params = (GLint) ctx->Pixel.GreenScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 179
.L3563:

! 2759	         break;

	ba	.L3313
	nop

	! block 180
.L3564:
.L3565:

! 2760	      case GL_INDEX_BITS:
! 2761	         *params = (GLint) ctx->Visual->IndexBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+56],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 181
.L3566:

! 2762	         break;

	ba	.L3313
	nop

	! block 182
.L3567:
.L3568:

! 2763	      case GL_INDEX_CLEAR_VALUE:
! 2764	         *params = (GLint) ctx->Color.ClearIndex;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e7c),%l1
	or	%l1,%lo(0x1e7c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 183
.L3569:

! 2765	         break;

	ba	.L3313
	nop

	! block 184
.L3570:
.L3571:

! 2766	      case GL_INDEX_MODE:
! 2767		 *params = ctx->Visual->RGBAflag ? 0 : 1;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l0
	cmp	%g0,%l0

	! block 185
.L3573:

	! block 186
.L3572:

	! block 187
.L3574:
	subx	%g0,-1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 188
.L3575:

! 2768		 break;

	ba	.L3313
	nop

	! block 189
.L3576:
.L3577:

! 2769	      case GL_INDEX_OFFSET:
! 2770		 *params = ctx->Pixel.IndexOffset;

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 190
.L3578:

! 2771		 break;

	ba	.L3313
	nop

	! block 191
.L3579:
.L3580:

! 2772	      case GL_INDEX_SHIFT:
! 2773		 *params = ctx->Pixel.IndexShift;

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 192
.L3581:

! 2774		 break;

	ba	.L3313
	nop

	! block 193
.L3582:
.L3583:

! 2775	      case GL_INDEX_WRITEMASK:
! 2776		 *params = (GLint) ctx->Color.IndexMask;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e90),%l1
	or	%l1,%lo(0x1e90),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 194
.L3584:

! 2777		 break;

	ba	.L3313
	nop

	! block 195
.L3585:
.L3586:
.L3587:
.L3588:
.L3589:
.L3590:
.L3591:
.L3592:
.L3593:

! 2778	      case GL_LIGHT0:
! 2779	      case GL_LIGHT1:
! 2780	      case GL_LIGHT2:
! 2781	      case GL_LIGHT3:
! 2782	      case GL_LIGHT4:
! 2783	      case GL_LIGHT5:
! 2784	      case GL_LIGHT6:
! 2785	      case GL_LIGHT7:
! 2786		 *params = (GLint) ctx->Light.Light[pname-GL_LIGHT0].Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fb4),%l1
	or	%l1,%lo(0x1fb4),%l1
	add	%l0,%l1,%l3
	ld	[%fp+72],%l0
	sll	%l0,2,%l2
	sll	%l0,5,%l1
	add	%l2,%l1,%l2
	sll	%l0,6,%l1
	add	%l2,%l1,%l2
	sll	%l0,7,%l1
	add	%l2,%l1,%l2
	sll	%l0,12,%l1
	add	%l2,%l1,%l1
	add	%l3,%l1,%l0
	sethi	%hi(0x438ff98),%l1
	or	%l1,%lo(0x438ff98),%l1
	sub	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 196
.L3594:

! 2787		 break;

	ba	.L3313
	nop

	! block 197
.L3595:
.L3596:

! 2788	      case GL_LIGHTING:
! 2789		 *params = (GLint) ctx->Light.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xadc8),%l1
	or	%l1,%lo(0xadc8),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 198
.L3597:

! 2790		 break;

	ba	.L3313
	nop

	! block 199
.L3598:
.L3599:

! 2791	      case GL_LIGHT_MODEL_AMBIENT:
! 2792		 params[0] = FLOAT_TO_INT( ctx->Light.Model.Ambient[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 200
.L3600:

! 2793		 params[1] = FLOAT_TO_INT( ctx->Light.Model.Ambient[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+4],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 201
.L3601:

! 2794		 params[2] = FLOAT_TO_INT( ctx->Light.Model.Ambient[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+8],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 202
.L3602:

! 2795		 params[3] = FLOAT_TO_INT( ctx->Light.Model.Ambient[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xa6d4),%l1
	or	%l1,%lo(0xa6d4),%l1
	add	%l0,%l1,%l0
	ld	[%l0+12],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 203
.L3603:

! 2796		 break;

	ba	.L3313
	nop

	! block 204
.L3604:
.L3605:

! 2797	      case GL_LIGHT_MODEL_LOCAL_VIEWER:
! 2798		 *params = (GLint) ctx->Light.Model.LocalViewer;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e4),%l1
	or	%l1,%lo(0xa6e4),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 205
.L3606:

! 2799		 break;

	ba	.L3313
	nop

	! block 206
.L3607:
.L3608:

! 2800	      case GL_LIGHT_MODEL_TWO_SIDE:
! 2801		 *params = (GLint) ctx->Light.Model.TwoSide;

	ld	[%fp+68],%l0
	sethi	%hi(0xa6e5),%l1
	or	%l1,%lo(0xa6e5),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 207
.L3609:

! 2802		 break;

	ba	.L3313
	nop

	! block 208
.L3610:
.L3611:

! 2803	      case GL_LINE_SMOOTH:
! 2804		 *params = (GLint) ctx->Line.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae08),%l1
	or	%l1,%lo(0xae08),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 209
.L3612:

! 2805		 break;

	ba	.L3313
	nop

	! block 210
.L3613:
.L3614:

! 2806	      case GL_LINE_SMOOTH_HINT:
! 2807		 *params = (GLint) ctx->Hint.LineSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa8),%l1
	or	%l1,%lo(0x1fa8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 211
.L3615:

! 2808		 break;

	ba	.L3313
	nop

	! block 212
.L3616:
.L3617:

! 2809	      case GL_LINE_STIPPLE:
! 2810		 *params = (GLint) ctx->Line.StippleFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae09),%l1
	or	%l1,%lo(0xae09),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 213
.L3618:

! 2811		 break;

	ba	.L3313
	nop

	! block 214
.L3619:
.L3620:

! 2812	      case GL_LINE_STIPPLE_PATTERN:
! 2813	         *params = (GLint) ctx->Line.StipplePattern;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0a),%l1
	or	%l1,%lo(0xae0a),%l1
	lduh	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 215
.L3621:

! 2814	         break;

	ba	.L3313
	nop

	! block 216
.L3622:
.L3623:

! 2815	      case GL_LINE_STIPPLE_REPEAT:
! 2816	         *params = (GLint) ctx->Line.StippleFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xae0c),%l1
	or	%l1,%lo(0xae0c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 217
.L3624:

! 2817	         break;

	ba	.L3313
	nop

	! block 218
.L3625:
.L3626:

! 2818	      case GL_LINE_WIDTH:
! 2819		 *params = (GLint) ctx->Line.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xae10),%l1
	or	%l1,%lo(0xae10),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 219
.L3627:

! 2820		 break;

	ba	.L3313
	nop

	! block 220
.L3628:
.L3629:

! 2821	      case GL_LINE_WIDTH_GRANULARITY:
! 2822		 *params = (GLint) LINE_WIDTH_GRANULARITY;

	mov	1,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 221
.L3630:

! 2823		 break;

	ba	.L3313
	nop

	! block 222
.L3631:
.L3632:

! 2824	      case GL_LINE_WIDTH_RANGE:
! 2825		 params[0] = (GLint) MIN_LINE_WIDTH;

	mov	1,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 223
.L3633:

! 2826		 params[1] = (GLint) MAX_LINE_WIDTH;

	mov	10,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 224
.L3634:

! 2827		 break;

	ba	.L3313
	nop

	! block 225
.L3635:
.L3636:

! 2828	      case GL_LIST_BASE:
! 2829		 *params = (GLint) ctx->List.ListBase;

	ld	[%fp+68],%l0
	sethi	%hi(0xae14),%l1
	or	%l1,%lo(0xae14),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 226
.L3637:

! 2830		 break;

	ba	.L3313
	nop

	! block 227
.L3638:
.L3639:

! 2831	      case GL_LIST_INDEX:
! 2832		 *params = (GLint) gl_list_index();

	call	gl_list_index
	nop
	ld	[%fp+76],%l0
	st	%o0,[%l0+0]

	! block 228
.L3640:

! 2833		 break;

	ba	.L3313
	nop

	! block 229
.L3641:
.L3642:

! 2834	      case GL_LIST_MODE:
! 2835		 *params = ctx->ExecuteFlag ? (GLint) GL_COMPILE_AND_EXECUTE
! 2836		   			  : (GLint) GL_COMPILE;

	ld	[%fp+68],%l0
	sethi	%hi(0x1e24),%l1
	or	%l1,%lo(0x1e24),%l1
	ldub	[%l0+%l1],%l0
	cmp	%g0,%l0

	! block 230
.L3644:

	! block 231
.L3643:

	! block 232
.L3645:
	addx	%g0,0,%l0
	sethi	%hi(0x1300),%l1
	or	%l1,%lo(0x1300),%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 233
.L3646:

! 2837		 break;

	ba	.L3313
	nop

	! block 234
.L3647:
.L3648:

! 2838	      case GL_INDEX_LOGIC_OP:
! 2839		 *params = (GLint) ctx->Color.IndexLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed0),%l1
	or	%l1,%lo(0x1ed0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 235
.L3649:

! 2840		 break;

	ba	.L3313
	nop

	! block 236
.L3650:
.L3651:

! 2841	      case GL_COLOR_LOGIC_OP:
! 2842		 *params = (GLint) ctx->Color.ColorLogicOpEnabled;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ed1),%l1
	or	%l1,%lo(0x1ed1),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 237
.L3652:

! 2843		 break;

	ba	.L3313
	nop

	! block 238
.L3653:
.L3654:

! 2844	      case GL_LOGIC_OP_MODE:
! 2845	         *params = (GLint) ctx->Color.LogicOp;

	ld	[%fp+68],%l0
	sethi	%hi(0x1ecc),%l1
	or	%l1,%lo(0x1ecc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 239
.L3655:

! 2846	         break;

	ba	.L3313
	nop

	! block 240
.L3656:
.L3657:

! 2847	      case GL_MAP1_COLOR_4:
! 2848		 *params = (GLint) ctx->Eval.Map1Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f40),%l1
	or	%l1,%lo(0x1f40),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 241
.L3658:

! 2849		 break;

	ba	.L3313
	nop

	! block 242
.L3659:
.L3660:

! 2850	      case GL_MAP1_GRID_DOMAIN:
! 2851		 params[0] = (GLint) ctx->Eval.MapGrid1u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f58),%l1
	or	%l1,%lo(0x1f58),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 243
.L3661:

! 2852		 params[1] = (GLint) ctx->Eval.MapGrid1u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f5c),%l1
	or	%l1,%lo(0x1f5c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 244
.L3662:

! 2853		 break;

	ba	.L3313
	nop

	! block 245
.L3663:
.L3664:

! 2854	      case GL_MAP1_GRID_SEGMENTS:
! 2855		 *params = (GLint) ctx->Eval.MapGrid1un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f54),%l1
	or	%l1,%lo(0x1f54),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 246
.L3665:

! 2856		 break;

	ba	.L3313
	nop

	! block 247
.L3666:
.L3667:

! 2857	      case GL_MAP1_INDEX:
! 2858		 *params = (GLint) ctx->Eval.Map1Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f41),%l1
	or	%l1,%lo(0x1f41),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 248
.L3668:

! 2859		 break;

	ba	.L3313
	nop

	! block 249
.L3669:
.L3670:

! 2860	      case GL_MAP1_NORMAL:
! 2861		 *params = (GLint) ctx->Eval.Map1Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f42),%l1
	or	%l1,%lo(0x1f42),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 250
.L3671:

! 2862		 break;

	ba	.L3313
	nop

	! block 251
.L3672:
.L3673:

! 2863	      case GL_MAP1_TEXTURE_COORD_1:
! 2864		 *params = (GLint) ctx->Eval.Map1TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f43),%l1
	or	%l1,%lo(0x1f43),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 252
.L3674:

! 2865		 break;

	ba	.L3313
	nop

	! block 253
.L3675:
.L3676:

! 2866	      case GL_MAP1_TEXTURE_COORD_2:
! 2867		 *params = (GLint) ctx->Eval.Map1TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f44),%l1
	or	%l1,%lo(0x1f44),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 254
.L3677:

! 2868		 break;

	ba	.L3313
	nop

	! block 255
.L3678:
.L3679:

! 2869	      case GL_MAP1_TEXTURE_COORD_3:
! 2870		 *params = (GLint) ctx->Eval.Map1TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f45),%l1
	or	%l1,%lo(0x1f45),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 256
.L3680:

! 2871		 break;

	ba	.L3313
	nop

	! block 257
.L3681:
.L3682:

! 2872	      case GL_MAP1_TEXTURE_COORD_4:
! 2873		 *params = (GLint) ctx->Eval.Map1TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f46),%l1
	or	%l1,%lo(0x1f46),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 258
.L3683:

! 2874		 break;

	ba	.L3313
	nop

	! block 259
.L3684:
.L3685:

! 2875	      case GL_MAP1_VERTEX_3:
! 2876		 *params = (GLint) ctx->Eval.Map1Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f47),%l1
	or	%l1,%lo(0x1f47),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 260
.L3686:

! 2877		 break;

	ba	.L3313
	nop

	! block 261
.L3687:
.L3688:

! 2878	      case GL_MAP1_VERTEX_4:
! 2879		 *params = (GLint) ctx->Eval.Map1Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f48),%l1
	or	%l1,%lo(0x1f48),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 262
.L3689:

! 2880		 break;

	ba	.L3313
	nop

	! block 263
.L3690:
.L3691:

! 2881	      case GL_MAP2_COLOR_4:
! 2882		 *params = (GLint) ctx->Eval.Map2Color4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f49),%l1
	or	%l1,%lo(0x1f49),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 264
.L3692:

! 2883		 break;

	ba	.L3313
	nop

	! block 265
.L3693:
.L3694:

! 2884	      case GL_MAP2_GRID_DOMAIN:
! 2885		 params[0] = (GLint) ctx->Eval.MapGrid2u1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f68),%l1
	or	%l1,%lo(0x1f68),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 266
.L3695:

! 2886		 params[1] = (GLint) ctx->Eval.MapGrid2u2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f6c),%l1
	or	%l1,%lo(0x1f6c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 267
.L3696:

! 2887		 params[2] = (GLint) ctx->Eval.MapGrid2v1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f70),%l1
	or	%l1,%lo(0x1f70),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 268
.L3697:

! 2888		 params[3] = (GLint) ctx->Eval.MapGrid2v2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f74),%l1
	or	%l1,%lo(0x1f74),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 269
.L3698:

! 2889		 break;

	ba	.L3313
	nop

	! block 270
.L3699:
.L3700:

! 2890	      case GL_MAP2_GRID_SEGMENTS:
! 2891		 params[0] = (GLint) ctx->Eval.MapGrid2un;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f60),%l1
	or	%l1,%lo(0x1f60),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 271
.L3701:

! 2892		 params[1] = (GLint) ctx->Eval.MapGrid2vn;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f64),%l1
	or	%l1,%lo(0x1f64),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 272
.L3702:

! 2893		 break;

	ba	.L3313
	nop

	! block 273
.L3703:
.L3704:

! 2894	      case GL_MAP2_INDEX:
! 2895		 *params = (GLint) ctx->Eval.Map2Index;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4a),%l1
	or	%l1,%lo(0x1f4a),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 274
.L3705:

! 2896		 break;

	ba	.L3313
	nop

	! block 275
.L3706:
.L3707:

! 2897	      case GL_MAP2_NORMAL:
! 2898		 *params = (GLint) ctx->Eval.Map2Normal;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4b),%l1
	or	%l1,%lo(0x1f4b),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 276
.L3708:

! 2899		 break;

	ba	.L3313
	nop

	! block 277
.L3709:
.L3710:

! 2900	      case GL_MAP2_TEXTURE_COORD_1:
! 2901		 *params = (GLint) ctx->Eval.Map2TextureCoord1;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4c),%l1
	or	%l1,%lo(0x1f4c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 278
.L3711:

! 2902		 break;

	ba	.L3313
	nop

	! block 279
.L3712:
.L3713:

! 2903	      case GL_MAP2_TEXTURE_COORD_2:
! 2904		 *params = (GLint) ctx->Eval.Map2TextureCoord2;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4d),%l1
	or	%l1,%lo(0x1f4d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 280
.L3714:

! 2905		 break;

	ba	.L3313
	nop

	! block 281
.L3715:
.L3716:

! 2906	      case GL_MAP2_TEXTURE_COORD_3:
! 2907		 *params = (GLint) ctx->Eval.Map2TextureCoord3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4e),%l1
	or	%l1,%lo(0x1f4e),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 282
.L3717:

! 2908		 break;

	ba	.L3313
	nop

	! block 283
.L3718:
.L3719:

! 2909	      case GL_MAP2_TEXTURE_COORD_4:
! 2910		 *params = (GLint) ctx->Eval.Map2TextureCoord4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f4f),%l1
	or	%l1,%lo(0x1f4f),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 284
.L3720:

! 2911		 break;

	ba	.L3313
	nop

	! block 285
.L3721:
.L3722:

! 2912	      case GL_MAP2_VERTEX_3:
! 2913		 *params = (GLint) ctx->Eval.Map2Vertex3;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f50),%l1
	or	%l1,%lo(0x1f50),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 286
.L3723:

! 2914		 break;

	ba	.L3313
	nop

	! block 287
.L3724:
.L3725:

! 2915	      case GL_MAP2_VERTEX_4:
! 2916		 *params = (GLint) ctx->Eval.Map2Vertex4;

	ld	[%fp+68],%l0
	sethi	%hi(0x1f51),%l1
	or	%l1,%lo(0x1f51),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 288
.L3726:

! 2917		 break;

	ba	.L3313
	nop

	! block 289
.L3727:
.L3728:

! 2918	      case GL_MAP_COLOR:
! 2919		 *params = (GLint) ctx->Pixel.MapColorFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 290
.L3729:

! 2920		 break;

	ba	.L3313
	nop

	! block 291
.L3730:
.L3731:

! 2921	      case GL_MAP_STENCIL:
! 2922		 *params = (GLint) ctx->Pixel.MapStencilFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xae4d),%l1
	or	%l1,%lo(0xae4d),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 292
.L3732:

! 2923		 break;

	ba	.L3313
	nop

	! block 293
.L3733:
.L3734:

! 2924	      case GL_MATRIX_MODE:
! 2925		 *params = (GLint) ctx->Transform.MatrixMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xdc4c),%l1
	or	%l1,%lo(0xdc4c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 294
.L3735:

! 2926		 break;

	ba	.L3313
	nop

	! block 295
.L3736:
.L3737:

! 2927	      case GL_MAX_ATTRIB_STACK_DEPTH:
! 2928	         *params = (GLint) MAX_ATTRIB_STACK_DEPTH;

	mov	16,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 296
.L3738:

! 2929	         break;

	ba	.L3313
	nop

	! block 297
.L3739:
.L3740:

! 2930	      case GL_MAX_CLIENT_ATTRIB_STACK_DEPTH:
! 2931	         *params = (GLint) MAX_CLIENT_ATTRIB_STACK_DEPTH;

	mov	16,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 298
.L3741:

! 2932	         break;

	ba	.L3313
	nop

	! block 299
.L3742:
.L3743:

! 2933	      case GL_MAX_CLIP_PLANES:
! 2934	         *params = (GLint) MAX_CLIP_PLANES;

	mov	6,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 300
.L3744:

! 2935	         break;

	ba	.L3313
	nop

	! block 301
.L3745:
.L3746:

! 2936	      case GL_MAX_EVAL_ORDER:
! 2937		 *params = (GLint) MAX_EVAL_ORDER;

	mov	30,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 302
.L3747:

! 2938		 break;

	ba	.L3313
	nop

	! block 303
.L3748:
.L3749:

! 2939	      case GL_MAX_LIGHTS:
! 2940	         *params = (GLint) MAX_LIGHTS;

	mov	8,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 304
.L3750:

! 2941	         break;

	ba	.L3313
	nop

	! block 305
.L3751:
.L3752:

! 2942	      case GL_MAX_LIST_NESTING:
! 2943	         *params = (GLint) MAX_LIST_NESTING;

	mov	64,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 306
.L3753:

! 2944	         break;

	ba	.L3313
	nop

	! block 307
.L3754:
.L3755:

! 2945	      case GL_MAX_MODELVIEW_STACK_DEPTH:
! 2946	         *params = (GLint) MAX_MODELVIEW_STACK_DEPTH;

	mov	32,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 308
.L3756:

! 2947	         break;

	ba	.L3313
	nop

	! block 309
.L3757:
.L3758:

! 2948	      case GL_MAX_NAME_STACK_DEPTH:
! 2949		 *params = (GLint) MAX_NAME_STACK_DEPTH;

	mov	64,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 310
.L3759:

! 2950		 break;

	ba	.L3313
	nop

	! block 311
.L3760:
.L3761:

! 2951	      case GL_MAX_PIXEL_MAP_TABLE:
! 2952		 *params = (GLint) MAX_PIXEL_MAP_TABLE;

	mov	256,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 312
.L3762:

! 2953		 break;

	ba	.L3313
	nop

	! block 313
.L3763:
.L3764:

! 2954	      case GL_MAX_PROJECTION_STACK_DEPTH:
! 2955	         *params = (GLint) MAX_PROJECTION_STACK_DEPTH;

	mov	32,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 314
.L3765:

! 2956	         break;

	ba	.L3313
	nop

	! block 315
.L3766:
.L3767:

! 2957	      case GL_MAX_TEXTURE_SIZE:
! 2958		 *params = (GLint) MAX_TEXTURE_SIZE;

	mov	1024,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 316
.L3768:

! 2959		 break;

	ba	.L3313
	nop

	! block 317
.L3769:
.L3770:

! 2960	      case GL_MAX_TEXTURE_STACK_DEPTH:
! 2961		 *params = (GLint) MAX_TEXTURE_STACK_DEPTH;

	mov	10,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 318
.L3771:

! 2962		 break;

	ba	.L3313
	nop

	! block 319
.L3772:
.L3773:

! 2963	      case GL_MAX_VIEWPORT_DIMS:
! 2964	         params[0] = (GLint) MAX_WIDTH;

	mov	1600,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 320
.L3774:

! 2965	         params[1] = (GLint) MAX_HEIGHT;

	mov	1200,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 321
.L3775:

! 2966	         break;

	ba	.L3313
	nop

	! block 322
.L3776:
.L3777:
.L3778:

! 2967	      case GL_MODELVIEW_MATRIX:
! 2968		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 323
.L3782:
.L3779:
.L3783:
.L3784:
.L3785:

! 2969		    params[i] = (GLint) ctx->ModelViewMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+2436],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l3
	ld	[%fp+76],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 324
.L3786:
.L3787:
.L3788:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L3779
	nop

	! block 325
.L3789:
.L3781:
.L3790:
.L3791:

! 2970		 }
! 2971		 break;

	ba	.L3313
	nop

	! block 326
.L3792:
.L3793:

! 2972	      case GL_MODELVIEW_STACK_DEPTH:
! 2973		 *params = (GLint) ctx->ModelViewStackDepth;

	ld	[%fp+68],%l0
	ld	[%l0+2564],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 327
.L3794:

! 2974		 break;

	ba	.L3313
	nop

	! block 328
.L3795:
.L3796:

! 2975	      case GL_NAME_STACK_DEPTH:
! 2976		 *params = (GLint) ctx->Select.NameStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfdc),%l1
	or	%l1,%lo(0xdfdc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 329
.L3797:

! 2977		 break;

	ba	.L3313
	nop

	! block 330
.L3798:
.L3799:

! 2978	      case GL_NORMALIZE:
! 2979		 *params = (GLint) ctx->Transform.Normalize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb7),%l1
	or	%l1,%lo(0xdcb7),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 331
.L3800:

! 2980		 break;

	ba	.L3313
	nop

	! block 332
.L3801:
.L3802:

! 2981	      case GL_PACK_ALIGNMENT:
! 2982		 *params = ctx->Pack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddac),%l1
	or	%l1,%lo(0xddac),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 333
.L3803:

! 2983		 break;

	ba	.L3313
	nop

	! block 334
.L3804:
.L3805:

! 2984	      case GL_PACK_LSB_FIRST:
! 2985		 *params = (GLint) ctx->Pack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc5),%l1
	or	%l1,%lo(0xddc5),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 335
.L3806:

! 2986		 break;

	ba	.L3313
	nop

	! block 336
.L3807:
.L3808:

! 2987	      case GL_PACK_ROW_LENGTH:
! 2988		 *params = ctx->Pack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb0),%l1
	or	%l1,%lo(0xddb0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 337
.L3809:

! 2989		 break;

	ba	.L3313
	nop

	! block 338
.L3810:
.L3811:

! 2990	      case GL_PACK_SKIP_PIXELS:
! 2991		 *params = ctx->Pack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb4),%l1
	or	%l1,%lo(0xddb4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 339
.L3812:

! 2992		 break;

	ba	.L3313
	nop

	! block 340
.L3813:
.L3814:

! 2993	      case GL_PACK_SKIP_ROWS:
! 2994		 *params = ctx->Pack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddb8),%l1
	or	%l1,%lo(0xddb8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 341
.L3815:

! 2995		 break;

	ba	.L3313
	nop

	! block 342
.L3816:
.L3817:

! 2996	      case GL_PACK_SWAP_BYTES:
! 2997		 *params = (GLint) ctx->Pack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc4),%l1
	or	%l1,%lo(0xddc4),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 343
.L3818:

! 2998		 break;

	ba	.L3313
	nop

	! block 344
.L3819:
.L3820:

! 2999	      case GL_PACK_SKIP_IMAGES_EXT:
! 3000	         *params = ctx->Pack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc0),%l1
	or	%l1,%lo(0xddc0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 345
.L3821:

! 3001	         break;

	ba	.L3313
	nop

	! block 346
.L3822:
.L3823:

! 3002	      case GL_PACK_IMAGE_HEIGHT_EXT:
! 3003	         *params = ctx->Pack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddbc),%l1
	or	%l1,%lo(0xddbc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 347
.L3824:

! 3004	         break;

	ba	.L3313
	nop

	! block 348
.L3825:
.L3826:

! 3005	      case GL_PERSPECTIVE_CORRECTION_HINT:
! 3006		 *params = (GLint) ctx->Hint.PerspectiveCorrection;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa0),%l1
	or	%l1,%lo(0x1fa0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 349
.L3827:

! 3007		 break;

	ba	.L3313
	nop

	! block 350
.L3828:
.L3829:

! 3008	      case GL_PIXEL_MAP_A_TO_A_SIZE:
! 3009		 *params = ctx->Pixel.MapAtoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 351
.L3830:

! 3010		 break;

	ba	.L3313
	nop

	! block 352
.L3831:
.L3832:

! 3011	      case GL_PIXEL_MAP_B_TO_B_SIZE:
! 3012		 *params = ctx->Pixel.MapBtoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 353
.L3833:

! 3013		 break;

	ba	.L3313
	nop

	! block 354
.L3834:
.L3835:

! 3014	      case GL_PIXEL_MAP_G_TO_G_SIZE:
! 3015		 *params = ctx->Pixel.MapGtoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 355
.L3836:

! 3016		 break;

	ba	.L3313
	nop

	! block 356
.L3837:
.L3838:

! 3017	      case GL_PIXEL_MAP_I_TO_A_SIZE:
! 3018		 *params = ctx->Pixel.MapItoAsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 357
.L3839:

! 3019		 break;

	ba	.L3313
	nop

	! block 358
.L3840:
.L3841:

! 3020	      case GL_PIXEL_MAP_I_TO_B_SIZE:
! 3021		 *params = ctx->Pixel.MapItoBsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 359
.L3842:

! 3022		 break;

	ba	.L3313
	nop

	! block 360
.L3843:
.L3844:

! 3023	      case GL_PIXEL_MAP_I_TO_G_SIZE:
! 3024		 *params = ctx->Pixel.MapItoGsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 361
.L3845:

! 3025		 break;

	ba	.L3313
	nop

	! block 362
.L3846:
.L3847:

! 3026	      case GL_PIXEL_MAP_I_TO_I_SIZE:
! 3027		 *params = ctx->Pixel.MapItoIsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae5c),%l1
	or	%l1,%lo(0xae5c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 363
.L3848:

! 3028		 break;

	ba	.L3313
	nop

	! block 364
.L3849:
.L3850:

! 3029	      case GL_PIXEL_MAP_I_TO_R_SIZE:
! 3030		 *params = ctx->Pixel.MapItoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 365
.L3851:

! 3031		 break;

	ba	.L3313
	nop

	! block 366
.L3852:
.L3853:

! 3032	      case GL_PIXEL_MAP_R_TO_R_SIZE:
! 3033		 *params = ctx->Pixel.MapRtoRsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 367
.L3854:

! 3034		 break;

	ba	.L3313
	nop

	! block 368
.L3855:
.L3856:

! 3035	      case GL_PIXEL_MAP_S_TO_S_SIZE:
! 3036		 *params = ctx->Pixel.MapStoSsize;

	ld	[%fp+68],%l0
	sethi	%hi(0xae58),%l1
	or	%l1,%lo(0xae58),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 369
.L3857:

! 3037		 break;

	ba	.L3313
	nop

	! block 370
.L3858:
.L3859:

! 3038	      case GL_POINT_SIZE:
! 3039	         *params = (GLint) ctx->Point.Size;

	ld	[%fp+68],%l0
	sethi	%hi(0xd684),%l1
	or	%l1,%lo(0xd684),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 371
.L3860:

! 3040	         break;

	ba	.L3313
	nop

	! block 372
.L3861:
.L3862:

! 3041	      case GL_POINT_SIZE_GRANULARITY:
! 3042		 *params = (GLint) POINT_SIZE_GRANULARITY;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 373
.L3863:

! 3043		 break;

	ba	.L3313
	nop

	! block 374
.L3864:
.L3865:

! 3044	      case GL_POINT_SIZE_RANGE:
! 3045		 params[0] = (GLint) MIN_POINT_SIZE;

	mov	1,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 375
.L3866:

! 3046		 params[1] = (GLint) MAX_POINT_SIZE;

	mov	10,%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 376
.L3867:

! 3047		 break;

	ba	.L3313
	nop

	! block 377
.L3868:
.L3869:

! 3048	      case GL_POINT_SMOOTH:
! 3049		 *params = (GLint) ctx->Point.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd680),%l1
	or	%l1,%lo(0xd680),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 378
.L3870:

! 3050		 break;

	ba	.L3313
	nop

	! block 379
.L3871:
.L3872:

! 3051	      case GL_POINT_SMOOTH_HINT:
! 3052		 *params = (GLint) ctx->Hint.PointSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fa4),%l1
	or	%l1,%lo(0x1fa4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 380
.L3873:

! 3053		 break;

	ba	.L3313
	nop

	! block 381
.L3874:
.L3875:

! 3054	      case GL_POINT_SIZE_MIN_EXT:
! 3055		 *params = (GLint) (ctx->Point.MinSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd694),%l1
	or	%l1,%lo(0xd694),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 382
.L3876:

! 3056		 break;

	ba	.L3313
	nop

	! block 383
.L3877:
.L3878:

! 3057	      case GL_POINT_SIZE_MAX_EXT:
! 3058		 *params = (GLint) (ctx->Point.MaxSize);

	ld	[%fp+68],%l0
	sethi	%hi(0xd698),%l1
	or	%l1,%lo(0xd698),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 384
.L3879:

! 3059		 break;

	ba	.L3313
	nop

	! block 385
.L3880:
.L3881:

! 3060	      case GL_POINT_FADE_THRESHOLD_SIZE_EXT:
! 3061		 *params = (GLint) (ctx->Point.Threshold);

	ld	[%fp+68],%l0
	sethi	%hi(0xd69c),%l1
	or	%l1,%lo(0xd69c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 386
.L3882:

! 3062		 break;

	ba	.L3313
	nop

	! block 387
.L3883:
.L3884:

! 3063	      case GL_DISTANCE_ATTENUATION_EXT:
! 3064		 params[0] = (GLint) (ctx->Point.Params[0]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd688),%l1
	or	%l1,%lo(0xd688),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 388
.L3885:

! 3065		 params[1] = (GLint) (ctx->Point.Params[1]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd68c),%l1
	or	%l1,%lo(0xd68c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 389
.L3886:

! 3066		 params[2] = (GLint) (ctx->Point.Params[2]);

	ld	[%fp+68],%l0
	sethi	%hi(0xd690),%l1
	or	%l1,%lo(0xd690),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 390
.L3887:

! 3067		 break;

	ba	.L3313
	nop

	! block 391
.L3888:
.L3889:

! 3068	      case GL_POLYGON_MODE:
! 3069		 params[0] = (GLint) ctx->Polygon.FrontMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a4),%l1
	or	%l1,%lo(0xd6a4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 392
.L3890:

! 3070		 params[1] = (GLint) ctx->Polygon.BackMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6a8),%l1
	or	%l1,%lo(0xd6a8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 393
.L3891:

! 3071		 break;

	ba	.L3313
	nop

	! block 394
.L3892:
.L3893:

! 3072	#ifdef GL_EXT_polygon_offset
! 3073	      case GL_POLYGON_OFFSET_BIAS_EXT:
! 3074	         *params = (GLint) ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 395
.L3894:

! 3075	         break;

	ba	.L3313
	nop

	! block 396
.L3895:
.L3896:

! 3076	#endif
! 3077	      case GL_POLYGON_OFFSET_FACTOR:
! 3078	         *params = (GLint) ctx->Polygon.OffsetFactor;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6bc),%l1
	or	%l1,%lo(0xd6bc),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 397
.L3897:

! 3079	         break;

	ba	.L3313
	nop

	! block 398
.L3898:
.L3899:

! 3080	      case GL_POLYGON_OFFSET_UNITS:
! 3081	         *params = (GLint) ctx->Polygon.OffsetUnits;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6c0),%l1
	or	%l1,%lo(0xd6c0),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 399
.L3900:

! 3082	         break;

	ba	.L3313
	nop

	! block 400
.L3901:
.L3902:

! 3083	      case GL_POLYGON_SMOOTH:
! 3084		 *params = (GLint) ctx->Polygon.SmoothFlag;

	ld	[%fp+68],%l0
	sethi	%hi(0xd6b8),%l1
	or	%l1,%lo(0xd6b8),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 401
.L3903:

! 3085		 break;

	ba	.L3313
	nop

	! block 402
.L3904:
.L3905:

! 3086	      case GL_POLYGON_SMOOTH_HINT:
! 3087		 *params = (GLint) ctx->Hint.PolygonSmooth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1fac),%l1
	or	%l1,%lo(0x1fac),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 403
.L3906:

! 3088		 break;

	ba	.L3313
	nop

	! block 404
.L3907:
.L3908:
.L3909:

! 3089	      case GL_POLYGON_STIPPLE:
! 3090		 for (i=0;i<32;i++) {		/* RIGHT? */

	st	%g0,[%fp-4]

	! block 405
.L_y304:
	sethi	%hi(0xd6c8),%l2
	or	%l2,%lo(0xd6c8),%l2
.L3913:
.L3910:
.L3914:
.L3915:
.L3916:

! 3091		    params[i] = (GLint) ctx->PolygonStipple[i];

	ld	[%fp+68],%l1
	ld	[%fp-4],%l0
	sll	%l0,2,%l3
	add	%l1,%l3,%l0
	ld	[%l0+%l2],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+%l3]

	! block 406
.L3917:
.L3918:
.L3919:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,32
	blu	.L3910
	nop

	! block 407
.L3920:
.L3912:
.L3921:
.L3922:

! 3092		 }
! 3093		 break;

	ba	.L3313
	nop

	! block 408
.L3923:
.L3924:
.L3925:

! 3094	      case GL_PROJECTION_MATRIX:
! 3095		 for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 409
.L_y305:
	sethi	%hi(0x1210),%l4
	or	%l4,%lo(0x1210),%l4
.L3929:
.L3926:
.L3930:
.L3931:
.L3932:

! 3096		    params[i] = (GLint) ctx->ProjectionMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l3
	ld	[%fp+76],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 410
.L3933:
.L3934:
.L3935:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L3926
	nop

	! block 411
.L3936:
.L3928:
.L3937:
.L3938:

! 3097		 }
! 3098		 break;

	ba	.L3313
	nop

	! block 412
.L3939:
.L3940:

! 3099	      case GL_PROJECTION_STACK_DEPTH:
! 3100		 *params = (GLint) ctx->ProjectionStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1250),%l1
	or	%l1,%lo(0x1250),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 413
.L3941:

! 3101		 break;

	ba	.L3313
	nop

	! block 414
.L3942:
.L3943:

! 3102	      case GL_READ_BUFFER:
! 3103		 *params = (GLint) ctx->Pixel.ReadBuffer;

	ld	[%fp+68],%l0
	sethi	%hi(0xae18),%l1
	or	%l1,%lo(0xae18),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 415
.L3944:

! 3104		 break;

	ba	.L3313
	nop

	! block 416
.L3945:
.L3946:

! 3105	      case GL_RED_BIAS:
! 3106	         *params = (GLint) ctx->Pixel.RedBias;

	ld	[%fp+68],%l0
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 417
.L3947:

! 3107	         break;

	ba	.L3313
	nop

	! block 418
.L3948:
.L3949:

! 3108	      case GL_RED_BITS:
! 3109	         *params = (GLint) ctx->Visual->RedBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+40],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 419
.L3950:

! 3110	         break;

	ba	.L3313
	nop

	! block 420
.L3951:
.L3952:

! 3111	      case GL_RED_SCALE:
! 3112	         *params = (GLint) ctx->Pixel.RedScale;

	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 421
.L3953:

! 3113	         break;

	ba	.L3313
	nop

	! block 422
.L3954:
.L3955:

! 3114	      case GL_RENDER_MODE:
! 3115		 *params = (GLint) ctx->RenderMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f8),%l1
	or	%l1,%lo(0xe0f8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 423
.L3956:

! 3116		 break;

	ba	.L3313
	nop

	! block 424
.L3957:
.L3958:

! 3117	      case GL_RGBA_MODE:
! 3118		 *params = (GLint) ctx->Visual->RGBAflag;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+0],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 425
.L3959:

! 3119		 break;

	ba	.L3313
	nop

	! block 426
.L3960:
.L3961:

! 3120	      case GL_SCISSOR_BOX:
! 3121		 params[0] = (GLint) ctx->Scissor.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xd74c),%l1
	or	%l1,%lo(0xd74c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 427
.L3962:

! 3122		 params[1] = (GLint) ctx->Scissor.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xd750),%l1
	or	%l1,%lo(0xd750),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 428
.L3963:

! 3123		 params[2] = (GLint) ctx->Scissor.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xd754),%l1
	or	%l1,%lo(0xd754),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 429
.L3964:

! 3124		 params[3] = (GLint) ctx->Scissor.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xd758),%l1
	or	%l1,%lo(0xd758),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 430
.L3965:

! 3125		 break;

	ba	.L3313
	nop

	! block 431
.L3966:
.L3967:

! 3126	      case GL_SCISSOR_TEST:
! 3127		 *params = (GLint) ctx->Scissor.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd748),%l1
	or	%l1,%lo(0xd748),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 432
.L3968:

! 3128		 break;

	ba	.L3313
	nop

	! block 433
.L3969:
.L3970:

! 3129	      case GL_SHADE_MODEL:
! 3130		 *params = (GLint) ctx->Light.ShadeModel;

	ld	[%fp+68],%l0
	sethi	%hi(0xadcc),%l1
	or	%l1,%lo(0xadcc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 434
.L3971:

! 3131		 break;

	ba	.L3313
	nop

	! block 435
.L3972:
.L3973:

! 3132	      case GL_SHARED_TEXTURE_PALETTE_EXT:
! 3133	         *params = (GLint) ctx->Texture.SharedPalette;

	ld	[%fp+68],%l0
	sethi	%hi(0xd83c),%l1
	or	%l1,%lo(0xd83c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 436
.L3974:

! 3134	         break;

	ba	.L3313
	nop

	! block 437
.L3975:
.L3976:

! 3135	      case GL_STENCIL_BITS:
! 3136	         *params = ctx->Visual->StencilBits;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+68],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 438
.L3977:

! 3137	         break;

	ba	.L3313
	nop

	! block 439
.L3978:
.L3979:

! 3138	      case GL_STENCIL_CLEAR_VALUE:
! 3139		 *params = (GLint) ctx->Stencil.Clear;

	ld	[%fp+68],%l0
	sethi	%hi(0xd772),%l1
	or	%l1,%lo(0xd772),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 440
.L3980:

! 3140		 break;

	ba	.L3313
	nop

	! block 441
.L3981:
.L3982:

! 3141	      case GL_STENCIL_FAIL:
! 3142		 *params = (GLint) ctx->Stencil.FailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd764),%l1
	or	%l1,%lo(0xd764),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 442
.L3983:

! 3143		 break;

	ba	.L3313
	nop

	! block 443
.L3984:
.L3985:

! 3144	      case GL_STENCIL_FUNC:
! 3145		 *params = (GLint) ctx->Stencil.Function;

	ld	[%fp+68],%l0
	sethi	%hi(0xd760),%l1
	or	%l1,%lo(0xd760),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 444
.L3986:

! 3146		 break;

	ba	.L3313
	nop

	! block 445
.L3987:
.L3988:

! 3147	      case GL_STENCIL_PASS_DEPTH_FAIL:
! 3148		 *params = (GLint) ctx->Stencil.ZFailFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd76c),%l1
	or	%l1,%lo(0xd76c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 446
.L3989:

! 3149		 break;

	ba	.L3313
	nop

	! block 447
.L3990:
.L3991:

! 3150	      case GL_STENCIL_PASS_DEPTH_PASS:
! 3151		 *params = (GLint) ctx->Stencil.ZPassFunc;

	ld	[%fp+68],%l0
	sethi	%hi(0xd768),%l1
	or	%l1,%lo(0xd768),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 448
.L3992:

! 3152		 break;

	ba	.L3313
	nop

	! block 449
.L3993:
.L3994:

! 3153	      case GL_STENCIL_REF:
! 3154		 *params = (GLint) ctx->Stencil.Ref;

	ld	[%fp+68],%l0
	sethi	%hi(0xd770),%l1
	or	%l1,%lo(0xd770),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 450
.L3995:

! 3155		 break;

	ba	.L3313
	nop

	! block 451
.L3996:
.L3997:

! 3156	      case GL_STENCIL_TEST:
! 3157		 *params = (GLint) ctx->Stencil.Enabled;

	ld	[%fp+68],%l0
	sethi	%hi(0xd75c),%l1
	or	%l1,%lo(0xd75c),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 452
.L3998:

! 3158		 break;

	ba	.L3313
	nop

	! block 453
.L3999:
.L4000:

! 3159	      case GL_STENCIL_VALUE_MASK:
! 3160		 *params = (GLint) ctx->Stencil.ValueMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd771),%l1
	or	%l1,%lo(0xd771),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 454
.L4001:

! 3161		 break;

	ba	.L3313
	nop

	! block 455
.L4002:
.L4003:

! 3162	      case GL_STENCIL_WRITEMASK:
! 3163		 *params = (GLint) ctx->Stencil.WriteMask;

	ld	[%fp+68],%l0
	sethi	%hi(0xd773),%l1
	or	%l1,%lo(0xd773),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 456
.L4004:

! 3164		 break;

	ba	.L3313
	nop

	! block 457
.L4005:
.L4006:

! 3165	      case GL_STEREO:
! 3166		 *params = 0;  /* TODO */

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 458
.L4007:

! 3167		 break;

	ba	.L3313
	nop

	! block 459
.L4008:
.L4009:

! 3168	      case GL_SUBPIXEL_BITS:
! 3169		 *params = 0;  /* TODO */

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 460
.L4010:

! 3170		 break;

	ba	.L3313
	nop

	! block 461
.L4011:
.L4012:

! 3171	      case GL_TEXTURE_1D:
! 3172		 *params = (ctx->Texture.Enabled & TEXTURE_1D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,1,%l0
	be	.L4013
	nop

	! block 462
.L4014:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L4015
	std	%f4,[%fp-40]

	! block 463
.L4013:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-40]

	! block 464
.L4015:
	ldd	[%fp-40],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 465
.L4016:

! 3173		 break;

	ba	.L3313
	nop

	! block 466
.L4017:
.L4018:

! 3174	      case GL_TEXTURE_2D:
! 3175		 *params = (ctx->Texture.Enabled & TEXTURE_2D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,2,%l0
	be	.L4019
	nop

	! block 467
.L4020:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L4021
	std	%f4,[%fp-48]

	! block 468
.L4019:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-48]

	! block 469
.L4021:
	ldd	[%fp-48],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 470
.L4022:

! 3176		 break;

	ba	.L3313
	nop

	! block 471
.L4023:
.L4024:

! 3177	      case GL_TEXTURE_3D_EXT:
! 3178		 *params = (ctx->Texture.Enabled & TEXTURE_3D) ? 1.0 : 0.0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd774),%l1
	or	%l1,%lo(0xd774),%l1
	ld	[%l0+%l1],%l0
	andcc	%l0,4,%l0
	be	.L4025
	nop

	! block 472
.L4026:
	sethi	%hi(.L_cseg1),%l0
	ldd	[%l0+%lo(.L_cseg1)],%f4
	ba	.L4027
	std	%f4,[%fp-56]

	! block 473
.L4025:
	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	std	%f4,[%fp-56]

	! block 474
.L4027:
	ldd	[%fp-56],%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 475
.L4028:

! 3179		 break;

	ba	.L3313
	nop

	! block 476
.L4029:
.L4030:

! 3180	      case GL_TEXTURE_ENV_COLOR:
! 3181		 params[0] = FLOAT_TO_INT( ctx->Texture.EnvColor[0] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd77c),%l1
	or	%l1,%lo(0xd77c),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 477
.L4031:

! 3182		 params[1] = FLOAT_TO_INT( ctx->Texture.EnvColor[1] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd780),%l1
	or	%l1,%lo(0xd780),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 478
.L4032:

! 3183		 params[2] = FLOAT_TO_INT( ctx->Texture.EnvColor[2] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd784),%l1
	or	%l1,%lo(0xd784),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 479
.L4033:

! 3184		 params[3] = FLOAT_TO_INT( ctx->Texture.EnvColor[3] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd788),%l1
	or	%l1,%lo(0xd788),%l1
	ld	[%l0+%l1],%f4
	fstod	%f4,%f6
	sethi	%hi(.L_cseg31),%l0
	ldd	[%l0+%lo(.L_cseg31)],%f4
	fmuld	%f6,%f4,%f4
	fdtoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 480
.L4034:

! 3185		 break;

	ba	.L3313
	nop

	! block 481
.L4035:
.L4036:

! 3186	      case GL_TEXTURE_ENV_MODE:
! 3187		 *params = (GLint) ctx->Texture.EnvMode;

	ld	[%fp+68],%l0
	sethi	%hi(0xd778),%l1
	or	%l1,%lo(0xd778),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 482
.L4037:

! 3188		 break;

	ba	.L3313
	nop

	! block 483
.L4038:
.L4039:

! 3189	      case GL_TEXTURE_GEN_S:
! 3190		 *params = (ctx->Texture.TexGenEnabled & S_BIT) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,4,%l0
	cmp	%g0,%l0

	! block 484
.L4041:

	! block 485
.L4040:

	! block 486
.L4042:
	addx	%g0,0,%l0
	st	%l0,[%fp-60]
	ld	[%fp-60],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 487
.L4043:

! 3191		 break;

	ba	.L3313
	nop

	! block 488
.L4044:
.L4045:

! 3192	      case GL_TEXTURE_GEN_T:
! 3193		 *params = (ctx->Texture.TexGenEnabled & T_BIT) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,8,%l0
	cmp	%g0,%l0

	! block 489
.L4047:

	! block 490
.L4046:

	! block 491
.L4048:
	addx	%g0,0,%l0
	st	%l0,[%fp-64]
	ld	[%fp-64],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 492
.L4049:

! 3194		 break;

	ba	.L3313
	nop

	! block 493
.L4050:
.L4051:

! 3195	      case GL_TEXTURE_GEN_R:
! 3196		 *params = (ctx->Texture.TexGenEnabled & R_BIT) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,2,%l0
	cmp	%g0,%l0

	! block 494
.L4053:

	! block 495
.L4052:

	! block 496
.L4054:
	addx	%g0,0,%l0
	st	%l0,[%fp-68]
	ld	[%fp-68],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 497
.L4055:

! 3197		 break;

	ba	.L3313
	nop

	! block 498
.L4056:
.L4057:

! 3198	      case GL_TEXTURE_GEN_Q:
! 3199		 *params = (ctx->Texture.TexGenEnabled & Q_BIT) ? 1 : 0;

	ld	[%fp+68],%l0
	sethi	%hi(0xd78c),%l1
	or	%l1,%lo(0xd78c),%l1
	ld	[%l0+%l1],%l0
	and	%l0,1,%l0
	cmp	%g0,%l0

	! block 499
.L4059:

	! block 500
.L4058:

	! block 501
.L4060:
	addx	%g0,0,%l0
	st	%l0,[%fp-72]
	ld	[%fp-72],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 502
.L4061:

! 3200		 break;

	ba	.L3313
	nop

	! block 503
.L4062:
.L4063:
.L4064:

! 3201	      case GL_TEXTURE_MATRIX:
! 3202	         for (i=0;i<16;i++) {

	st	%g0,[%fp-4]

	! block 504
.L_y306:
	sethi	%hi(0x1b5c),%l4
	or	%l4,%lo(0x1b5c),%l4
.L4068:
.L4065:
.L4069:
.L4070:
.L4071:

! 3203		    params[i] = (GLint) ctx->TextureMatrix[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+%l4],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l3
	ld	[%fp+76],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 505
.L4072:
.L4073:
.L4074:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,16
	blu	.L4065
	nop

	! block 506
.L4075:
.L4067:
.L4076:
.L4077:

! 3204		 }
! 3205		 break;

	ba	.L3313
	nop

	! block 507
.L4078:
.L4079:

! 3206	      case GL_TEXTURE_STACK_DEPTH:
! 3207		 *params = (GLint) ctx->TextureStackDepth;

	ld	[%fp+68],%l0
	sethi	%hi(0x1b9c),%l1
	or	%l1,%lo(0x1b9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 508
.L4080:

! 3208		 break;

	ba	.L3313
	nop

	! block 509
.L4081:
.L4082:

! 3209	      case GL_UNPACK_ALIGNMENT:
! 3210		 *params = ctx->Unpack.Alignment;

	ld	[%fp+68],%l0
	sethi	%hi(0xddc8),%l1
	or	%l1,%lo(0xddc8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 510
.L4083:

! 3211		 break;

	ba	.L3313
	nop

	! block 511
.L4084:
.L4085:

! 3212	      case GL_UNPACK_LSB_FIRST:
! 3213		 *params = (GLint) ctx->Unpack.LsbFirst;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde1),%l1
	or	%l1,%lo(0xdde1),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 512
.L4086:

! 3214		 break;

	ba	.L3313
	nop

	! block 513
.L4087:
.L4088:

! 3215	      case GL_UNPACK_ROW_LENGTH:
! 3216		 *params = ctx->Unpack.RowLength;

	ld	[%fp+68],%l0
	sethi	%hi(0xddcc),%l1
	or	%l1,%lo(0xddcc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 514
.L4089:

! 3217		 break;

	ba	.L3313
	nop

	! block 515
.L4090:
.L4091:

! 3218	      case GL_UNPACK_SKIP_PIXELS:
! 3219		 *params = ctx->Unpack.SkipPixels;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd0),%l1
	or	%l1,%lo(0xddd0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 516
.L4092:

! 3220		 break;

	ba	.L3313
	nop

	! block 517
.L4093:
.L4094:

! 3221	      case GL_UNPACK_SKIP_ROWS:
! 3222		 *params = ctx->Unpack.SkipRows;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd4),%l1
	or	%l1,%lo(0xddd4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 518
.L4095:

! 3223		 break;

	ba	.L3313
	nop

	! block 519
.L4096:
.L4097:

! 3224	      case GL_UNPACK_SWAP_BYTES:
! 3225		 *params = (GLint) ctx->Unpack.SwapBytes;

	ld	[%fp+68],%l0
	sethi	%hi(0xdde0),%l1
	or	%l1,%lo(0xdde0),%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 520
.L4098:

! 3226		 break;

	ba	.L3313
	nop

	! block 521
.L4099:
.L4100:

! 3227	      case GL_UNPACK_SKIP_IMAGES_EXT:
! 3228	         *params = ctx->Unpack.SkipImages;

	ld	[%fp+68],%l0
	sethi	%hi(0xdddc),%l1
	or	%l1,%lo(0xdddc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 522
.L4101:

! 3229	         break;

	ba	.L3313
	nop

	! block 523
.L4102:
.L4103:

! 3230	      case GL_UNPACK_IMAGE_HEIGHT_EXT:
! 3231	         *params = ctx->Unpack.ImageHeight;

	ld	[%fp+68],%l0
	sethi	%hi(0xddd8),%l1
	or	%l1,%lo(0xddd8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 524
.L4104:

! 3232	         break;

	ba	.L3313
	nop

	! block 525
.L4105:
.L4106:

! 3233	      case GL_VIEWPORT:
! 3234	         params[0] = (GLint) ctx->Viewport.X;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcb8),%l1
	or	%l1,%lo(0xdcb8),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 526
.L4107:

! 3235	         params[1] = (GLint) ctx->Viewport.Y;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcbc),%l1
	or	%l1,%lo(0xdcbc),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+4]

	! block 527
.L4108:

! 3236	         params[2] = (GLint) ctx->Viewport.Width;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc0),%l1
	or	%l1,%lo(0xdcc0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+8]

	! block 528
.L4109:

! 3237	         params[3] = (GLint) ctx->Viewport.Height;

	ld	[%fp+68],%l0
	sethi	%hi(0xdcc4),%l1
	or	%l1,%lo(0xdcc4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+12]

	! block 529
.L4110:

! 3238	         break;

	ba	.L3313
	nop

	! block 530
.L4111:
.L4112:

! 3239	      case GL_ZOOM_X:
! 3240		 *params = (GLint) ctx->Pixel.ZoomX;

	ld	[%fp+68],%l0
	sethi	%hi(0xae50),%l1
	or	%l1,%lo(0xae50),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 531
.L4113:

! 3241		 break;

	ba	.L3313
	nop

	! block 532
.L4114:
.L4115:

! 3242	      case GL_ZOOM_Y:
! 3243		 *params = (GLint) ctx->Pixel.ZoomY;

	ld	[%fp+68],%l0
	sethi	%hi(0xae54),%l1
	or	%l1,%lo(0xae54),%l1
	ld	[%l0+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 533
.L4116:

! 3244		 break;

	ba	.L3313
	nop

	! block 534
.L4117:
.L4118:

! 3245	      case GL_VERTEX_ARRAY_SIZE:
! 3246	         *params = ctx->Array.VertexSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd2c),%l1
	or	%l1,%lo(0xdd2c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 535
.L4119:

! 3247	         break;

	ba	.L3313
	nop

	! block 536
.L4120:
.L4121:

! 3248	      case GL_VERTEX_ARRAY_TYPE:
! 3249	         *params = ctx->Array.VertexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd30),%l1
	or	%l1,%lo(0xdd30),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 537
.L4122:

! 3250	         break;

	ba	.L3313
	nop

	! block 538
.L4123:
.L4124:

! 3251	      case GL_VERTEX_ARRAY_STRIDE:
! 3252	         *params = ctx->Array.VertexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd34),%l1
	or	%l1,%lo(0xdd34),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 539
.L4125:

! 3253	         break;

	ba	.L3313
	nop

	! block 540
.L4126:
.L4127:

! 3254	      case GL_VERTEX_ARRAY_COUNT_EXT:
! 3255	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 541
.L4128:

! 3256	         break;

	ba	.L3313
	nop

	! block 542
.L4129:
.L4130:

! 3257	      case GL_NORMAL_ARRAY_TYPE:
! 3258	         *params = ctx->Array.NormalType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd44),%l1
	or	%l1,%lo(0xdd44),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 543
.L4131:

! 3259	         break;

	ba	.L3313
	nop

	! block 544
.L4132:
.L4133:

! 3260	      case GL_NORMAL_ARRAY_STRIDE:
! 3261	         *params = ctx->Array.NormalStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd48),%l1
	or	%l1,%lo(0xdd48),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 545
.L4134:

! 3262	         break;

	ba	.L3313
	nop

	! block 546
.L4135:
.L4136:

! 3263	      case GL_NORMAL_ARRAY_COUNT_EXT:
! 3264	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 547
.L4137:

! 3265	         break;

	ba	.L3313
	nop

	! block 548
.L4138:
.L4139:

! 3266	      case GL_COLOR_ARRAY_SIZE:
! 3267	         *params = ctx->Array.ColorSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd58),%l1
	or	%l1,%lo(0xdd58),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 549
.L4140:

! 3268	         break;

	ba	.L3313
	nop

	! block 550
.L4141:
.L4142:

! 3269	      case GL_COLOR_ARRAY_TYPE:
! 3270	         *params = ctx->Array.ColorType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd5c),%l1
	or	%l1,%lo(0xdd5c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 551
.L4143:

! 3271	         break;

	ba	.L3313
	nop

	! block 552
.L4144:
.L4145:

! 3272	      case GL_COLOR_ARRAY_STRIDE:
! 3273	         *params = ctx->Array.ColorStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd60),%l1
	or	%l1,%lo(0xdd60),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 553
.L4146:

! 3274	         break;

	ba	.L3313
	nop

	! block 554
.L4147:
.L4148:

! 3275	      case GL_COLOR_ARRAY_COUNT_EXT:
! 3276	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 555
.L4149:

! 3277	         break;

	ba	.L3313
	nop

	! block 556
.L4150:
.L4151:

! 3278	      case GL_INDEX_ARRAY_TYPE:
! 3279	         *params = ctx->Array.IndexType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd70),%l1
	or	%l1,%lo(0xdd70),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 557
.L4152:

! 3280	         break;

	ba	.L3313
	nop

	! block 558
.L4153:
.L4154:

! 3281	      case GL_INDEX_ARRAY_STRIDE:
! 3282	         *params = ctx->Array.IndexStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd74),%l1
	or	%l1,%lo(0xdd74),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 559
.L4155:

! 3283	         break;

	ba	.L3313
	nop

	! block 560
.L4156:
.L4157:

! 3284	      case GL_INDEX_ARRAY_COUNT_EXT:
! 3285	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 561
.L4158:

! 3286	         break;

	ba	.L3313
	nop

	! block 562
.L4159:
.L4160:

! 3287	      case GL_TEXTURE_COORD_ARRAY_SIZE:
! 3288	         *params = ctx->Array.TexCoordSize;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd84),%l1
	or	%l1,%lo(0xdd84),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 563
.L4161:

! 3289	         break;

	ba	.L3313
	nop

	! block 564
.L4162:
.L4163:

! 3290	      case GL_TEXTURE_COORD_ARRAY_TYPE:
! 3291	         *params = ctx->Array.TexCoordType;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd88),%l1
	or	%l1,%lo(0xdd88),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 565
.L4164:

! 3292	         break;

	ba	.L3313
	nop

	! block 566
.L4165:
.L4166:

! 3293	      case GL_TEXTURE_COORD_ARRAY_STRIDE:
! 3294	         *params = ctx->Array.TexCoordStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd8c),%l1
	or	%l1,%lo(0xdd8c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 567
.L4167:

! 3295	         break;

	ba	.L3313
	nop

	! block 568
.L4168:
.L4169:

! 3296	      case GL_TEXTURE_COORD_ARRAY_COUNT_EXT:
! 3297	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 569
.L4170:

! 3298	         break;

	ba	.L3313
	nop

	! block 570
.L4171:
.L4172:

! 3299	      case GL_EDGE_FLAG_ARRAY_STRIDE:
! 3300	         *params = ctx->Array.EdgeFlagStride;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd9c),%l1
	or	%l1,%lo(0xdd9c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 571
.L4173:

! 3301	         break;

	ba	.L3313
	nop

	! block 572
.L4174:
.L4175:

! 3302	      case GL_EDGE_FLAG_ARRAY_COUNT_EXT:
! 3303	         *params = 0;

	ld	[%fp+76],%l0
	st	%g0,[%l0+0]

	! block 573
.L4176:

! 3304	         break;

	ba	.L3313
	nop

	! block 574
.L4177:
.L4178:

! 3305	      case GL_TEXTURE_BINDING_1D:
! 3306	         *params = ctx->Texture.Current1D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 575
.L4179:

! 3307	          break;

	ba	.L3313
	nop

	! block 576
.L4180:
.L4181:

! 3308	      case GL_TEXTURE_BINDING_2D:
! 3309	         *params = ctx->Texture.Current2D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 577
.L4182:

! 3310	          break;

	ba	.L3313
	nop

	! block 578
.L4183:
.L4184:

! 3311	      case GL_TEXTURE_3D_BINDING_EXT:
! 3312	         *params = ctx->Texture.Current3D->Name;

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l0
	ld	[%l0+4],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 579
.L4185:

! 3313	          break;

	ba	.L3313
	nop

	! block 580
.L4186:
.L4187:

! 3315	      default:
! 3316	         gl_error( ctx, GL_INVALID_ENUM, "glGetIntegerv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L4188),%l1
	or	%l1,%lo(.L4188),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 581
.L4189:
.L4190:
	ba	.L3313
	nop

	! block 582
.L3314:
.L4191:
	ld	[%fp+72],%l2
	cmp	%l2,3344
	bge	.L_y222
	nop

	! block 583
	cmp	%l2,2976
	bge	.L_y223
	nop

	! block 584
	cmp	%l2,2896
	bge	.L_y224
	nop

	! block 585
	cmp	%l2,2848
	bge	.L_y225
	nop

	! block 586
	sub	%l2,2816,%l0
	cmp	%l0,19
	bgu	.L4186
	nop

	! block 587
	sll	%l0,2,%l1
	sethi	%hi(.L_y226-80),%l0
	or	%l0,%lo(.L_y226-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 588
.L_y225:
	cmp	%l2,2880
	bge	.L_y227
	nop

	! block 589
	cmp	%l2,2864
	bge	.L_y228
	nop

	! block 590
	sub	%l2,2848,%l0
	cmp	%l0,6
	bgu	.L4186
	nop

	! block 591
	sll	%l0,2,%l1
	sethi	%hi(.L_y229-28),%l0
	or	%l0,%lo(.L_y229-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 592
.L_y228:
	sub	%l2,2864,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 593
	sll	%l0,2,%l1
	sethi	%hi(.L_y230-16),%l0
	or	%l0,%lo(.L_y230-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 594
.L_y227:
	sub	%l2,2880,%l0
	cmp	%l0,6
	bgu	.L4186
	nop

	! block 595
	sll	%l0,2,%l1
	sethi	%hi(.L_y231-28),%l0
	or	%l0,%lo(.L_y231-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 596
.L_y224:
	cmp	%l2,2928
	bge	.L_y232
	nop

	! block 597
	cmp	%l2,2912
	bge	.L_y233
	nop

	! block 598
	sub	%l2,2896,%l0
	cmp	%l0,7
	bgu	.L4186
	nop

	! block 599
	sll	%l0,2,%l1
	sethi	%hi(.L_y234-32),%l0
	or	%l0,%lo(.L_y234-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 600
.L_y233:
	sub	%l2,2912,%l0
	cmp	%l0,6
	bgu	.L4186
	nop

	! block 601
	sll	%l0,2,%l1
	sethi	%hi(.L_y235-28),%l0
	or	%l0,%lo(.L_y235-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 602
.L_y232:
	cmp	%l2,2960
	bge	.L_y236
	nop

	! block 603
	cmp	%l2,2944
	bge	.L_y237
	nop

	! block 604
	sub	%l2,2928,%l0
	cmp	%l0,4
	bgu	.L4186
	nop

	! block 605
	sll	%l0,2,%l1
	sethi	%hi(.L_y238-20),%l0
	or	%l0,%lo(.L_y238-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 606
.L_y237:
	be	.L3324
	nop

	! block 607
	ba	.L4186
	nop

	! block 608
.L_y236:
	sub	%l2,2960,%l0
	cmp	%l0,8
	bgu	.L4186
	nop

	! block 609
	sll	%l0,2,%l1
	sethi	%hi(.L_y239-36),%l0
	or	%l0,%lo(.L_y239-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 610
.L_y223:
	cmp	%l2,3136
	bge	.L_y240
	nop

	! block 611
	cmp	%l2,3056
	bge	.L_y241
	nop

	! block 612
	cmp	%l2,2992
	bge	.L_y242
	nop

	! block 613
	sub	%l2,2976,%l0
	cmp	%l0,8
	bgu	.L4186
	nop

	! block 614
	sll	%l0,2,%l1
	sethi	%hi(.L_y243-36),%l0
	or	%l0,%lo(.L_y243-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 615
.L_y242:
	cmp	%l2,3024
	bge	.L_y244
	nop

	! block 616
	cmp	%l2,3008
	bge	.L_y245
	nop

	! block 617
	cmp	%l2,2992
	be	.L3348
	nop

	! block 618
	cmp	%l2,2993
	be	.L3384
	nop

	! block 619
	ba	.L4186
	nop

	! block 620
.L_y245:
	sub	%l2,3008,%l0
	cmp	%l0,2
	bgu	.L4186
	nop

	! block 621
	sll	%l0,2,%l1
	sethi	%hi(.L_y246-12),%l0
	or	%l0,%lo(.L_y246-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 622
.L_y244:
	cmp	%l2,3040
	bge	.L_y247
	nop

	! block 623
	cmp	%l2,3024
	be	.L3507
	nop

	! block 624
	ba	.L4186
	nop

	! block 625
.L_y247:
	sub	%l2,3040,%l0
	cmp	%l0,2
	bgu	.L4186
	nop

	! block 626
	sll	%l0,2,%l1
	sethi	%hi(.L_y248-12),%l0
	or	%l0,%lo(.L_y248-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 627
.L_y241:
	cmp	%l2,3104
	bge	.L_y249
	nop

	! block 628
	cmp	%l2,3072
	bge	.L_y250
	nop

	! block 629
	sub	%l2,3056,%l0
	cmp	%l0,2
	bgu	.L4186
	nop

	! block 630
	sll	%l0,2,%l1
	sethi	%hi(.L_y251-12),%l0
	or	%l0,%lo(.L_y251-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 631
.L_y250:
	cmp	%l2,3088
	bge	.L_y252
	nop

	! block 632
	sub	%l2,3072,%l0
	cmp	%l0,2
	bgu	.L4186
	nop

	! block 633
	sll	%l0,2,%l1
	sethi	%hi(.L_y253-12),%l0
	or	%l0,%lo(.L_y253-12),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 634
.L_y252:
	be	.L3960
	nop

	! block 635
	cmp	%l2,3089
	be	.L3966
	nop

	! block 636
	ba	.L4186
	nop

	! block 637
.L_y249:
	cmp	%l2,3120
	bge	.L_y254
	nop

	! block 638
	sub	%l2,3104,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 639
	sll	%l0,2,%l1
	sethi	%hi(.L_y255-16),%l0
	or	%l0,%lo(.L_y255-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 640
.L_y254:
	sub	%l2,3120,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 641
	sll	%l0,2,%l1
	sethi	%hi(.L_y256-16),%l0
	or	%l0,%lo(.L_y256-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 642
.L_y240:
	cmp	%l2,3312
	bge	.L_y257
	nop

	! block 643
	cmp	%l2,3248
	bge	.L_y258
	nop

	! block 644
	cmp	%l2,3168
	bge	.L_y259
	nop

	! block 645
	cmp	%l2,3152
	bge	.L_y260
	nop

	! block 646
	cmp	%l2,3136
	be	.L3954
	nop

	! block 647
	ba	.L4186
	nop

	! block 648
.L_y260:
	sub	%l2,3152,%l0
	cmp	%l0,4
	bgu	.L4186
	nop

	! block 649
	sll	%l0,2,%l1
	sethi	%hi(.L_y261-20),%l0
	or	%l0,%lo(.L_y261-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 650
.L_y259:
	sub	%l2,3168,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 651
	sll	%l0,2,%l1
	sethi	%hi(.L_y262-16),%l0
	or	%l0,%lo(.L_y262-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 652
.L_y258:
	sub	%l2,3248,%l0
	cmp	%l0,9
	bgu	.L4186
	nop

	! block 653
	sll	%l0,2,%l1
	sethi	%hi(.L_y263-40),%l0
	or	%l0,%lo(.L_y263-40),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 654
.L_y257:
	cmp	%l2,3328
	bge	.L_y264
	nop

	! block 655
	sub	%l2,3312,%l0
	cmp	%l0,5
	bgu	.L4186
	nop

	! block 656
	sll	%l0,2,%l1
	sethi	%hi(.L_y265-24),%l0
	or	%l0,%lo(.L_y265-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 657
.L_y264:
	sub	%l2,3328,%l0
	cmp	%l0,5
	bgu	.L4186
	nop

	! block 658
	sll	%l0,2,%l1
	sethi	%hi(.L_y266-24),%l0
	or	%l0,%lo(.L_y266-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 659
.L_y222:
	cmp	%l2,3536
	bge	.L_y267
	nop

	! block 660
	cmp	%l2,3408
	bge	.L_y268
	nop

	! block 661
	cmp	%l2,3376
	bge	.L_y269
	nop

	! block 662
	sub	%l2,3344,%l0
	cmp	%l0,15
	bgu	.L4186
	nop

	! block 663
	sll	%l0,2,%l1
	sethi	%hi(.L_y270-64),%l0
	or	%l0,%lo(.L_y270-64),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 664
.L_y269:
	sub	%l2,3376,%l0
	cmp	%l0,11
	bgu	.L4186
	nop

	! block 665
	sll	%l0,2,%l1
	sethi	%hi(.L_y271-48),%l0
	or	%l0,%lo(.L_y271-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 666
.L_y268:
	cmp	%l2,3472
	bge	.L_y272
	nop

	! block 667
	cmp	%l2,3440
	bge	.L_y273
	nop

	! block 668
	sub	%l2,3408,%l0
	cmp	%l0,11
	bgu	.L4186
	nop

	! block 669
	sll	%l0,2,%l1
	sethi	%hi(.L_y274-48),%l0
	or	%l0,%lo(.L_y274-48),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 670
.L_y273:
	be	.L3795
	nop

	! block 671
	cmp	%l2,3456
	be	.L3351
	nop

	! block 672
	ba	.L4186
	nop

	! block 673
.L_y272:
	cmp	%l2,3504
	bge	.L_y275
	nop

	! block 674
	sub	%l2,3472,%l0
	cmp	%l0,8
	bgu	.L4186
	nop

	! block 675
	sll	%l0,2,%l1
	sethi	%hi(.L_y276-36),%l0
	or	%l0,%lo(.L_y276-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 676
.L_y275:
	sub	%l2,3504,%l0
	cmp	%l0,8
	bgu	.L4186
	nop

	! block 677
	sll	%l0,2,%l1
	sethi	%hi(.L_y277-36),%l0
	or	%l0,%lo(.L_y277-36),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 678
.L_y267:
	sethi	%hi(0x8068),%l0
	or	%l0,%lo(0x8068),%l0
	cmp	%l2,%l0
	bge	.L_y278
	nop

	! block 679
	sethi	%hi(0x4000),%l0
	cmp	%l2,%l0
	bge	.L_y279
	nop

	! block 680
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	bge	.L_y280
	nop

	! block 681
	cmp	%l2,3552
	bge	.L_y281
	nop

	! block 682
	sub	%l2,3536,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 683
	sll	%l0,2,%l1
	sethi	%hi(.L_y282-16),%l0
	or	%l0,%lo(.L_y282-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 684
.L_y281:
	cmp	%l2,3569
	bge	.L_y283
	nop

	! block 685
	cmp	%l2,3552
	be	.L4011
	nop

	! block 686
	cmp	%l2,3553
	be	.L4017
	nop

	! block 687
	ba	.L4186
	nop

	! block 688
.L_y283:
	be	.L3519
	nop

	! block 689
	cmp	%l2,3570
	be	.L3522
	nop

	! block 690
	ba	.L4186
	nop

	! block 691
.L_y280:
	sethi	%hi(0x3000),%l0
	cmp	%l2,%l0
	bge	.L_y284
	nop

	! block 692
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	bge	.L_y285
	nop

	! block 693
	sethi	%hi(0x2200),%l0
	or	%l0,%lo(0x2200),%l0
	cmp	%l2,%l0
	be	.L4035
	nop

	! block 694
	sethi	%hi(0x2201),%l0
	or	%l0,%lo(0x2201),%l0
	cmp	%l2,%l0
	be	.L4029
	nop

	! block 695
	ba	.L4186
	nop

	! block 696
.L_y285:
	sethi	%hi(0x2a00),%l0
	or	%l0,%lo(0x2a00),%l0
	cmp	%l2,%l0
	be	.L3898
	nop

	! block 697
	ba	.L4186
	nop

	! block 698
.L_y284:
	sethi	%hi(0x3000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L4186
	nop

	! block 699
	sll	%l0,2,%l1
	sethi	%hi(.L_y286-24),%l0
	or	%l0,%lo(.L_y286-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 700
.L_y279:
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	bge	.L_y287
	nop

	! block 701
	sethi	%hi(0x4000),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L4186
	nop

	! block 702
	sll	%l0,2,%l1
	sethi	%hi(.L_y288-32),%l0
	or	%l0,%lo(.L_y288-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 703
.L_y287:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	bge	.L_y289
	nop

	! block 704
	sethi	%hi(0x8005),%l0
	or	%l0,%lo(0x8005),%l0
	cmp	%l2,%l0
	be	.L3369
	nop

	! block 705
	sethi	%hi(0x8009),%l0
	or	%l0,%lo(0x8009),%l0
	cmp	%l2,%l0
	be	.L3366
	nop

	! block 706
	ba	.L4186
	nop

	! block 707
.L_y289:
	sethi	%hi(0x8038),%l0
	or	%l0,%lo(0x8038),%l0
	cmp	%l2,%l0
	be	.L3895
	nop

	! block 708
	sethi	%hi(0x8039),%l0
	or	%l0,%lo(0x8039),%l0
	cmp	%l2,%l0
	be	.L3892
	nop

	! block 709
	ba	.L4186
	nop

	! block 710
.L_y278:
	sethi	%hi(0x807a),%l0
	or	%l0,%lo(0x807a),%l0
	cmp	%l2,%l0
	bge	.L_y290
	nop

	! block 711
	sethi	%hi(0x8068),%l1
	or	%l1,%lo(0x8068),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,7
	bgu	.L4186
	nop

	! block 712
	sll	%l0,2,%l1
	sethi	%hi(.L_y291-32),%l0
	or	%l0,%lo(.L_y291-32),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 713
.L_y290:
	sethi	%hi(0x8126),%l0
	or	%l0,%lo(0x8126),%l0
	cmp	%l2,%l0
	bge	.L_y292
	nop

	! block 714
	sethi	%hi(0x807a),%l1
	or	%l1,%lo(0x807a),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,19
	bgu	.L4186
	nop

	! block 715
	sll	%l0,2,%l1
	sethi	%hi(.L_y293-80),%l0
	or	%l0,%lo(.L_y293-80),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 716
.L_y292:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	bge	.L_y294
	nop

	! block 717
	sethi	%hi(0x8126),%l1
	or	%l1,%lo(0x8126),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,3
	bgu	.L4186
	nop

	! block 718
	sll	%l0,2,%l1
	sethi	%hi(.L_y295-16),%l0
	or	%l0,%lo(.L_y295-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 719
.L_y294:
	sethi	%hi(0x81fb),%l0
	or	%l0,%lo(0x81fb),%l0
	cmp	%l2,%l0
	be	.L3972
	nop

	! block 720
	ba	.L4186
	nop

	! block 721
.L4192:
.L3313:
.L4193:

	! block 722
.L4194:
.L4195:
.L3296:
	jmp	%i7+8
	restore
	.size	gl_GetIntegerv,(.-gl_GetIntegerv)

	.word	.L3435
	.word	.L3441
	.word	.L3444
	.word	.L3476
	.word	.L3449
	.word	.L3458
	.word	.L3467
	.word	.L3461
	.word	.L3473
	.word	.L3455
	.word	.L4186
	.word	.L4186
	.word	.L4186
	.word	.L4186
	.word	.L4186
	.word	.L4186
	.word	.L3868
	.word	.L3858
	.word	.L3864
	.word	.L3861
.L_y226:
	.word	.L3610
	.word	.L3625
	.word	.L3631
	.word	.L3628
	.word	.L3616
	.word	.L3619
	.word	.L3622
.L_y229:
	.word	.L3641
	.word	.L3751
	.word	.L3635
	.word	.L3638
.L_y230:
	.word	.L3888
	.word	.L3901
	.word	.L3907
	.word	.L3516
	.word	.L3429
	.word	.L3432
	.word	.L3552
.L_y231:
	.word	.L3595
	.word	.L3604
	.word	.L3607
	.word	.L3598
	.word	.L3969
	.word	.L3405
	.word	.L3408
	.word	.L3402
.L_y234:
	.word	.L3525
	.word	.L3543
	.word	.L3534
	.word	.L3549
	.word	.L3537
	.word	.L3546
	.word	.L3528
.L_y235:
	.word	.L3494
	.word	.L3501
	.word	.L3504
	.word	.L3488
	.word	.L3491
.L_y238:
	.word	.L3996
	.word	.L3978
	.word	.L3984
	.word	.L3999
	.word	.L3981
	.word	.L3987
	.word	.L3990
	.word	.L3993
	.word	.L4002
.L_y239:
	.word	.L3733
	.word	.L3798
	.word	.L4105
	.word	.L3792
	.word	.L3939
	.word	.L4078
	.word	.L3776
	.word	.L3923
	.word	.L4062
.L_y243:
	.word	.L3339
	.word	.L3345
	.word	.L3342
.L_y246:
	.word	.L3360
	.word	.L3363
	.word	.L3357
.L_y248:
	.word	.L3653
	.word	.L3647
	.word	.L3650
.L_y251:
	.word	.L3354
	.word	.L3513
	.word	.L3942
.L_y253:
	.word	.L3567
	.word	.L3582
	.word	.L3396
	.word	.L3411
.L_y255:
	.word	.L3570
	.word	.L3957
	.word	.L3510
	.word	.L4005
.L_y256:
	.word	.L3825
	.word	.L3871
	.word	.L3613
	.word	.L3904
	.word	.L3540
.L_y261:
	.word	.L4038
	.word	.L4044
	.word	.L4050
	.word	.L4056
.L_y262:
	.word	.L3846
	.word	.L3855
	.word	.L3849
	.word	.L3843
	.word	.L3840
	.word	.L3837
	.word	.L3852
	.word	.L3834
	.word	.L3831
	.word	.L3828
.L_y263:
	.word	.L4096
	.word	.L4084
	.word	.L4087
	.word	.L4093
	.word	.L4090
	.word	.L4081
.L_y265:
	.word	.L3816
	.word	.L3804
	.word	.L3807
	.word	.L3813
	.word	.L3810
	.word	.L3801
.L_y266:
	.word	.L3727
	.word	.L3730
	.word	.L3579
	.word	.L3576
	.word	.L3951
	.word	.L3945
	.word	.L4111
	.word	.L4114
	.word	.L3561
	.word	.L3555
	.word	.L3381
	.word	.L3375
	.word	.L3336
	.word	.L3330
	.word	.L3498
	.word	.L3482
.L_y270:
	.word	.L3745
	.word	.L3748
	.word	.L3742
	.word	.L3766
	.word	.L3760
	.word	.L3736
	.word	.L3754
	.word	.L3757
	.word	.L3763
	.word	.L3769
	.word	.L3772
	.word	.L3739
.L_y271:
	.word	.L4008
	.word	.L3564
	.word	.L3948
	.word	.L3558
	.word	.L3378
	.word	.L3333
	.word	.L3485
	.word	.L3975
	.word	.L3318
	.word	.L3319
	.word	.L3320
	.word	.L3321
.L_y274:
	.word	.L3656
	.word	.L3666
	.word	.L3669
	.word	.L3672
	.word	.L3675
	.word	.L3678
	.word	.L3681
	.word	.L3684
	.word	.L3687
.L_y276:
	.word	.L3690
	.word	.L3703
	.word	.L3706
	.word	.L3709
	.word	.L3712
	.word	.L3715
	.word	.L3718
	.word	.L3721
	.word	.L3724
.L_y277:
	.word	.L3659
	.word	.L3663
	.word	.L3693
	.word	.L3699
.L_y282:
	.word	.L3387
	.word	.L3388
	.word	.L3389
	.word	.L3390
	.word	.L3391
	.word	.L3392
.L_y286:
	.word	.L3585
	.word	.L3586
	.word	.L3587
	.word	.L3588
	.word	.L3589
	.word	.L3590
	.word	.L3591
	.word	.L3592
.L_y288:
	.word	.L4177
	.word	.L4180
	.word	.L4183
	.word	.L3819
	.word	.L3822
	.word	.L4099
	.word	.L4102
	.word	.L4023
.L_y291:
	.word	.L4117
	.word	.L4120
	.word	.L4123
	.word	.L4126
	.word	.L4129
	.word	.L4132
	.word	.L4135
	.word	.L4138
	.word	.L4141
	.word	.L4144
	.word	.L4147
	.word	.L4150
	.word	.L4153
	.word	.L4156
	.word	.L4159
	.word	.L4162
	.word	.L4165
	.word	.L4168
	.word	.L4171
	.word	.L4174
.L_y293:
	.word	.L3874
	.word	.L3877
	.word	.L3880
	.word	.L3883
.L_y295:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetPointerv
	.type	gl_GetPointerv,#function
gl_GetPointerv:
	save	%sp,-96,%sp

	! block 1
.L4198:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L4199:
.L4201:
.L4204:

! File get.c:
! 3317	   }
! 3318	}
! 3319	
! 3322	void gl_GetPointerv( GLcontext *ctx, GLenum pname, GLvoid **params )
! 3323	{
! 3324	   switch (pname) {

	ba	.L4203
	nop

	! block 3
.L4205:
.L4206:
.L4207:
.L4208:

! 3325	      case GL_VERTEX_ARRAY_POINTER:
! 3326	         *params = ctx->Array.VertexPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd3c),%l1
	or	%l1,%lo(0xdd3c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 4
.L4209:

! 3327	         break;

	ba	.L4202
	nop

	! block 5
.L4210:
.L4211:

! 3328	      case GL_NORMAL_ARRAY_POINTER:
! 3329	         *params = ctx->Array.NormalPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd50),%l1
	or	%l1,%lo(0xdd50),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 6
.L4212:

! 3330	         break;

	ba	.L4202
	nop

	! block 7
.L4213:
.L4214:

! 3331	      case GL_COLOR_ARRAY_POINTER:
! 3332	         *params = ctx->Array.ColorPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd68),%l1
	or	%l1,%lo(0xdd68),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 8
.L4215:

! 3333	         break;

	ba	.L4202
	nop

	! block 9
.L4216:
.L4217:

! 3334	      case GL_INDEX_ARRAY_POINTER:
! 3335	         *params = ctx->Array.IndexPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd7c),%l1
	or	%l1,%lo(0xdd7c),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 10
.L4218:

! 3336	         break;

	ba	.L4202
	nop

	! block 11
.L4219:
.L4220:

! 3337	      case GL_TEXTURE_COORD_ARRAY_POINTER:
! 3338	         *params = ctx->Array.TexCoordPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdd94),%l1
	or	%l1,%lo(0xdd94),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 12
.L4221:

! 3339	         break;

	ba	.L4202
	nop

	! block 13
.L4222:
.L4223:

! 3340	      case GL_EDGE_FLAG_ARRAY_POINTER:
! 3341	         *params = ctx->Array.EdgeFlagPtr;

	ld	[%fp+68],%l0
	sethi	%hi(0xdda4),%l1
	or	%l1,%lo(0xdda4),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 14
.L4224:

! 3342	         break;

	ba	.L4202
	nop

	! block 15
.L4225:
.L4226:

! 3343	      case GL_FEEDBACK_BUFFER_POINTER:
! 3344	         *params = ctx->Feedback.Buffer;

	ld	[%fp+68],%l0
	sethi	%hi(0xdfc0),%l1
	or	%l1,%lo(0xdfc0),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l0
	st	%l1,[%l0+0]

	! block 16
.L4227:

! 3345	         break;

	ba	.L4202
	nop

	! block 17
.L4228:
.L4229:

! 3346	      default:
! 3347	         gl_error( ctx, GL_INVALID_ENUM, "glGetPointerv" );

	ld	[%fp+68],%l0
	sethi	%hi(.L4230),%l1
	or	%l1,%lo(.L4230),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L4231:

! 3348	         return;

	ba	.L4197
	nop

	! block 19
.L4232:
.L4233:
.L4203:
.L4234:
	ld	[%fp+72],%l2
	sethi	%hi(0x808e),%l0
	or	%l0,%lo(0x808e),%l0
	cmp	%l2,%l0
	bge	.L_y296
	nop

	! block 20
	cmp	%l2,3568
	be	.L4225
	nop

	! block 21
	ba	.L4228
	nop

	! block 22
.L_y296:
	sethi	%hi(0x808e),%l1
	or	%l1,%lo(0x808e),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L4228
	nop

	! block 23
	sll	%l0,2,%l1
	sethi	%hi(.L_y297-24),%l0
	or	%l0,%lo(.L_y297-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 24
.L4235:
.L4202:
.L4236:

	! block 25
.L4237:
.L4238:
.L4197:
	jmp	%i7+8
	restore
	.size	gl_GetPointerv,(.-gl_GetPointerv)

	.word	.L4207
	.word	.L4210
	.word	.L4213
	.word	.L4216
	.word	.L4219
	.word	.L4222
.L_y297:
	.align	8

	.section	".rodata1",#alloc
	.align	4
.L23:
	.ascii	"glGetBooleanv\000"
	.skip	2
	.type	.L23,#object
	.size	.L23,16
	.align	4
.L1487:
	.ascii	"glGetBooleanv\000"
	.skip	2
	.type	.L1487,#object
	.size	.L1487,16

	.section	".rodata",#alloc
	.align	4
Drodata.rodata:
.L_cseg0:
	.skip	4
	.type	.L_cseg0,#object
	.size	.L_cseg0,4
	.align	8
.L_cseg1:
	.word	0x3ff00000,0x0
	.type	.L_cseg1,#object
	.size	.L_cseg1,8
	.align	8
.L_cseg2:
	.word	0x40240000,0x0
	.type	.L_cseg2,#object
	.size	.L_cseg2,8
	.align	8
.L_cseg3:
	.word	0x3fb99999,0x9999999a
	.type	.L_cseg3,#object
	.size	.L_cseg3,8

	.section	".rodata1",#alloc
	.align	4
.L1507:
	.ascii	"glGetDoublev\000"
	.skip	3
	.type	.L1507,#object
	.size	.L1507,16
	.align	4
.L2387:
	.ascii	"glGetDoublev\000"
	.skip	3
	.type	.L2387,#object
	.size	.L2387,16

	.section	".rodata",#alloc
	.align	8
.L_cseg4:
	.skip	8
	.type	.L_cseg4,#object
	.size	.L_cseg4,8
	.align	8
.L_cseg5:
	.word	0x40b30100,0x0
	.type	.L_cseg5,#object
	.size	.L_cseg5,8
	.align	8
.L_cseg6:
	.word	0x40b30000,0x0
	.type	.L_cseg6,#object
	.size	.L_cseg6,8
	.align	8
.L_cseg7:
	.word	0x40300000,0x0
	.type	.L_cseg7,#object
	.size	.L_cseg7,8
	.align	8
.L_cseg8:
	.word	0x40180000,0x0
	.type	.L_cseg8,#object
	.size	.L_cseg8,8
	.align	8
.L_cseg9:
	.word	0x403e0000,0x0
	.type	.L_cseg9,#object
	.size	.L_cseg9,8
	.align	8
.L_cseg10:
	.word	0x40200000,0x0
	.type	.L_cseg10,#object
	.size	.L_cseg10,8
	.align	8
.L_cseg11:
	.word	0x40500000,0x0
	.type	.L_cseg11,#object
	.size	.L_cseg11,8
	.align	8
.L_cseg12:
	.word	0x40400000,0x0
	.type	.L_cseg12,#object
	.size	.L_cseg12,8
	.align	8
.L_cseg13:
	.word	0x40700000,0x0
	.type	.L_cseg13,#object
	.size	.L_cseg13,8
	.align	8
.L_cseg14:
	.word	0x40900000,0x0
	.type	.L_cseg14,#object
	.size	.L_cseg14,8
	.align	8
.L_cseg15:
	.word	0x40990000,0x0
	.type	.L_cseg15,#object
	.size	.L_cseg15,8
	.align	8
.L_cseg16:
	.word	0x4092c000,0x0
	.type	.L_cseg16,#object
	.size	.L_cseg16,8

	.section	".rodata1",#alloc
	.align	4
.L2407:
	.ascii	"glGetFloatv\000"
	.type	.L2407,#object
	.size	.L2407,12
	.align	4
.L3287:
	.ascii	"glGetFloatv\000"
	.type	.L3287,#object
	.size	.L3287,12

	.section	".rodata",#alloc
	.align	4
.L_cseg17:
	.word	0x3f800000
	.type	.L_cseg17,#object
	.size	.L_cseg17,4
	.align	4
.L_cseg18:
	.word	0x45980800
	.type	.L_cseg18,#object
	.size	.L_cseg18,4
	.align	4
.L_cseg19:
	.word	0x45980000
	.type	.L_cseg19,#object
	.size	.L_cseg19,4
	.align	4
.L_cseg20:
	.word	0x41800000
	.type	.L_cseg20,#object
	.size	.L_cseg20,4
	.align	4
.L_cseg21:
	.word	0x40c00000
	.type	.L_cseg21,#object
	.size	.L_cseg21,4
	.align	4
.L_cseg22:
	.word	0x41f00000
	.type	.L_cseg22,#object
	.size	.L_cseg22,4
	.align	4
.L_cseg23:
	.word	0x41000000
	.type	.L_cseg23,#object
	.size	.L_cseg23,4
	.align	4
.L_cseg24:
	.word	0x42800000
	.type	.L_cseg24,#object
	.size	.L_cseg24,4
	.align	4
.L_cseg25:
	.word	0x42000000
	.type	.L_cseg25,#object
	.size	.L_cseg25,4
	.align	4
.L_cseg26:
	.word	0x43800000
	.type	.L_cseg26,#object
	.size	.L_cseg26,4
	.align	4
.L_cseg27:
	.word	0x44800000
	.type	.L_cseg27,#object
	.size	.L_cseg27,4
	.align	4
.L_cseg28:
	.word	0x41200000
	.type	.L_cseg28,#object
	.size	.L_cseg28,4
	.align	4
.L_cseg29:
	.word	0x44c80000
	.type	.L_cseg29,#object
	.size	.L_cseg29,4
	.align	4
.L_cseg30:
	.word	0x44960000
	.type	.L_cseg30,#object
	.size	.L_cseg30,4

	.section	".rodata1",#alloc
	.align	4
.L3307:
	.ascii	"glGetIntegerv\000"
	.skip	2
	.type	.L3307,#object
	.size	.L3307,16
	.align	4
.L4188:
	.ascii	"glGetIntegerv\000"
	.skip	2
	.type	.L4188,#object
	.size	.L4188,16

	.section	".rodata",#alloc
	.align	8
.L_cseg31:
	.word	0x41dfffff,0xffc00000
	.type	.L_cseg31,#object
	.size	.L_cseg31,8

	.section	".rodata1",#alloc
	.align	4
.L4230:
	.ascii	"glGetPointerv\000"
	.type	.L4230,#object
	.size	.L4230,14
	.section	".bss",#alloc,#write
Bbss.bss:
	.section	".data",#alloc,#write
Ddata.data:

	.file	"get.c"
	.ident	"@(#)string.h	1.27	07/01/14 SMI"
	.ident	"@(#)string_iso.h	1.5	04/06/18 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)math.h	2.24	04/10/23 SMI"
	.ident	"@(#)math_iso.h	1.9	04/10/23 SMI"
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
!   reloc[1]: knd=2, off=249, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=273, siz=4, lab1=gl_GetBooleanv, lab2=, loff=0
!   reloc[3]: knd=0, off=277, siz=4, lab1=.L1494, lab2=, loff=0
!   reloc[4]: knd=0, off=38133, siz=4, lab1=gl_GetDoublev, lab2=, loff=0
!   reloc[5]: knd=0, off=38137, siz=4, lab1=.L2394, lab2=, loff=0
!   reloc[6]: knd=0, off=38256, siz=4, lab1=gl_GetFloatv, lab2=, loff=0
!   reloc[7]: knd=0, off=38260, siz=4, lab1=.L3294, lab2=, loff=0
!   reloc[8]: knd=0, off=38361, siz=4, lab1=gl_GetIntegerv, lab2=, loff=0
!   reloc[9]: knd=0, off=38365, siz=4, lab1=.L4195, lab2=, loff=0
!   reloc[10]: knd=0, off=38471, siz=4, lab1=gl_GetPointerv, lab2=, loff=0
!   reloc[11]: knd=0, off=38475, siz=4, lab1=.L4238, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x96,0xd0,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "get.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  get.c -W0,-xp\\$XAa59JCRsd3L20K.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCRsd3L20K.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_GetBooleanv\0"
	.byte 0x01,0x02,0x01,0x64
	.uaword gl_GetBooleanv
	.uaword .L1494
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x61
	.byte 0x03,0x00,0x00,0x94,0xdc
	.ascii "ctx\0"
	.byte 0x01,0x63,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x31,0x6a
	.ascii "pname\0"
	.byte 0x01,0x63,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x8d,0xbd
	.ascii "params\0"
	.byte 0x01,0x63,0x03,0x91,0xcc,0x00,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x91,0x01,0x01,0x65,0x02
	.byte 0x91,0x7c,0x00,0x05
	.ascii "int\0"
	.byte 0x05,0x04,0x06,0x00,0x00,0x01,0x61
	.ascii "GLint\0"
	.byte 0x03,0x07
	.ascii "HashTable\0"
	.byte 0x01,0x08,0x00,0x00,0x01,0x74,0x05
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x06,0x00,0x00,0x01,0x85
	.ascii "GLuint\0"
	.byte 0x03,0x05
	.ascii "float\0"
	.byte 0x04,0x04,0x06,0x00,0x00,0x01,0x9e
	.ascii "GLfloat\0"
	.byte 0x03,0x05
	.ascii "long\0"
	.byte 0x05,0x04,0x09,0x00,0x00,0x01,0x68,0x10
	.byte 0x00,0x00,0x01,0xce,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x0b,0x04,0x03,0x00,0x00
	.byte 0x31,0x6a,0x0c
	.ascii "GL_FALSE\0"
	.byte 0x00,0x0c
	.ascii "GL_TRUE\0"
	.byte 0x01,0x0c
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x0c
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x0c
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x0c
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x0c
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x0c
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x0c
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x0c
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x0c
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x0c
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x0c
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x0c
	.ascii "GL_LINES\0"
	.byte 0x01,0x0c
	.ascii "GL_POINTS\0"
	.byte 0x00,0x0c
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x0c
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x0c
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x0c
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x0c
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x0c
	.ascii "GL_QUADS\0"
	.byte 0x07,0x0c
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x0c
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x0c
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x0c
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x0c
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x0c
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x0c
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x0c
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x0c
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x0c
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x0c
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x0c
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x0c
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x0c
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x0c
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x0c
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x0c
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x0c
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x0c
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x0c
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x0c
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x0c
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x0c
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x0c
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x0c
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x0c
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x0c
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x0c
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x0c
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x0c
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x0c
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x0c
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x0c
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x0c
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x0c
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x0c
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x0c
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x0c
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x0c
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x0c
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x0c
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x0c
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x0c
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x0c
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x0c
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x0c
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x0c
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x0c
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x0c
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x0c
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x0c
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x0c
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x0c
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x0c
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x0c
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x0c
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x0c
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x0c
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x0c
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x0c
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x0c
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x0c
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x0c
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x0c
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x0c
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x0c
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x0c
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x0c
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x0c
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x0c
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x0c
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x0c
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x0c
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x0c
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x0c
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x0c
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x0c
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x0c
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x0c
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x0c
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x0c
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x0c
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x0c
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x0c
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x0c
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x0c
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x0c
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x0c
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x0c
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x0c
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x0c
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x0c
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x0c
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x0c
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x0c
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x0c
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x0c
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x0c
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x0c
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x0c
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x0c
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x0c
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x0c
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x0c
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x0c
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x0c
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x0c
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x0c
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x0c
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x0c
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x0c
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x0c
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x0c
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x0c
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x0c
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x0c
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x0c
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x0c
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x0c
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x0c
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x0c
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x0c
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x0c
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x0c
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x0c
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x0c
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x0c
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x0c
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x0c
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x0c
	.ascii "GL_ZERO\0"
	.byte 0x00,0x0c
	.ascii "GL_ONE\0"
	.byte 0x01,0x0c
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x0c
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x0c
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x0c
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x0c
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x0c
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x0c
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x0c
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x0c
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x0c
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x0c
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x0c
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x0c
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x0c
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x0c
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x0c
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x0c
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x0c
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x0c
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x0c
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x0c
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x0c
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x0c
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x0c
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x0c
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x0c
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x0c
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x0c
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x0c
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x0c
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x0c
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x0c
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x0c
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x0c
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x0c
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x0c
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x0c
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x0c
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x0c
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x0c
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x0c
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x0c
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x0c
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0c
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0c
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x0c
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x0c
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x0c
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x0c
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x0c
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x0c
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x0c
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x0c
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x0c
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x0c
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x0c
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x0c
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x0c
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x0c
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x0c
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x0c
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x0c
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x0c
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x0c
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x0c
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x0c
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x0c
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x0c
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x0c
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x0c
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x0c
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x0c
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x0c
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x0c
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x0c
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x0c
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x0c
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x0c
	.ascii "GL_NONE\0"
	.byte 0x00,0x0c
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x0c
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x0c
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x0c
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x0c
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x0c
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x0c
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x0c
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x0c
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x0c
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x0c
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x0c
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x0c
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x0c
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x0c
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x0c
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x0c
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x0c
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x0c
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x0c
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x0c
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x0c
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x0c
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x0c
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x0c
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x0c
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x0c
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x0c
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x0c
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x0c
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x0c
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x0c
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x0c
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x0c
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x0c
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x0c
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x0c
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x0c
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x0c
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x0c
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x0c
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x0c
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x0c
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x0c
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x0c
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x0c
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x0c
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x0c
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x0c
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x0c
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x0c
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x0c
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x0c
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x0c
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x0c
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x0c
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x0c
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x0c
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x0c
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x0c
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x0c
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x0c
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x0c
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x0c
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x0c
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x0c
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x0c
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x0c
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x0c
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x0c
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x0c
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x0c
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x0c
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x0c
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x0c
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x0c
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x0c
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x0c
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x0c
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x0c
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x0c
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x0c
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x0c
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x0c
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x0c
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x0c
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x0c
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x0c
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x0c
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x0c
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x0c
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x0c
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x0c
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x0c
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x0c
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x0c
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x0c
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x0c
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x0c
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x0c
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x0c
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x0c
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x0c
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x0c
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x0c
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x0c
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x0c
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x0c
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x0c
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x0c
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x0c
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x0c
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x0c
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x0c
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x0c
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x0c
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x0c
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x0c
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x0c
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x0c
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x0c
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x0c
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x0c
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x0c
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x0c
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x0c
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x0c
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x0c
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x0c
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x0c
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x0c
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x0c
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x0c
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x0c
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x0c
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x0c
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x0c
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x0c
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x0c
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x0c
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x0c
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x0c
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x0c
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x0c
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x0c
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x0c
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x0c
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x0c
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x0c
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x0c
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x0c
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x0c
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x0c
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x0c
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x0c
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x0c
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x0c
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x0c
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x0c
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x0c
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x0c
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x0c
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x0c
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x0c
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x0c
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x0c
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x0c
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x0c
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x0c
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x0c
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x0c
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x0c
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x0c
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x0c
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x0c
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x0c
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x0c
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x0c
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x0c
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x0c
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x0c
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x0c
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x0c
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x0c
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x0c
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x0c
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x0c
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x0c
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x0c
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x0c
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x0c
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x0c
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x0c
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x0c
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x0c
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x0c
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x0c
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x0c
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x0c
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x0c
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x0c
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x0c
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x0c
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x0c
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x0c
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x0c
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x0c
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x0c
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x0c
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x0c
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x0c
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x0c
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x0c
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x0c
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x0c
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x0c
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x0c
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x0c
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x0c
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x0c
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x0c
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x0c
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x0c
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x0c
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x0c
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x0c
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x0c
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x0c
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x0c
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x0c
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x0c
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x0c
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x0c
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x0c
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x0c
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x0c
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x0c
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x0c
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x0c
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x0c
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x0c
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x0c
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x0c
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x0c
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x0c
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x0c
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x0c
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x0c
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x0c
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x0c
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x0c
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x0c
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x0c
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x0c
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x0c
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x06,0x00,0x00,0x01
	.byte 0xce
	.ascii "GLenum\0"
	.byte 0x03,0x05
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x06,0x00,0x00,0x31,0x77
	.ascii "GLubyte\0"
	.byte 0x03,0x08,0x00,0x00,0x31,0x88,0x05
	.ascii "void\0"
	.byte 0x05,0x00,0x08,0x00,0x00,0x31,0x9b,0x0d
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x02,0x00,0x00,0x32,0xb1,0x0e
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "Border\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x08,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x0c,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x10,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x14,0x0e
	.ascii "Width2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x18,0x0e
	.ascii "Height2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x1c,0x0e
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x20,0x0e
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x24,0x0e
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x28,0x0e
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x2c,0x0e
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x30,0x0e
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0x96,0x02,0x23,0x34,0x0e
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x38,0x00
	.byte 0x08,0x00,0x00,0x31,0xa8,0x09,0x00,0x00
	.byte 0x32,0xb1,0x2c,0x00,0x00,0x32,0xc7,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x0a,0x00,0x0f,0x00
	.byte 0x00,0x31,0x88,0x04,0x00,0x00,0x00,0x32
	.byte 0xda,0x10,0x00,0x00,0x01,0xb5,0x03,0xff
	.byte 0x00,0x06,0x00,0x00,0x31,0x77
	.ascii "GLboolean\0"
	.byte 0x03,0x11
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x02,0x00,0x00,0x34,0x79,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "Name\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x04,0x0e
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x08,0x0e
	.ascii "Priority\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x0c,0x0e
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x01,0xbd,0x02,0x23,0x10,0x0e
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x20,0x0e
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x24,0x0e
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x28,0x0e
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x2c,0x0e
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x30,0x0e
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x34,0x0e
	.ascii "Image\0"
	.byte 0x00,0x00,0x32,0xb6,0x02,0x23,0x38,0x0e
	.ascii "Palette\0"
	.byte 0x00,0x00,0x32,0xc7,0x02,0x23,0x64,0x0e
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xe4,0x08
	.byte 0x0e
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x6a,0x03,0x23,0xe8,0x08
	.byte 0x0e
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x6a,0x03,0x23,0xec,0x08
	.byte 0x0e
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xf0,0x08
	.byte 0x0e
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0xa3,0x03,0x23,0xf4,0x08
	.byte 0x0e
	.ascii "Complete\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xf8,0x08
	.byte 0x0e
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x34,0xef,0x03,0x23,0xfc,0x08
	.byte 0x0e
	.ascii "Next\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0x80,0x09
	.byte 0x00,0x12,0x00,0x00,0x32,0xea,0x08,0x00
	.byte 0x00,0x34,0x79,0x12,0x00,0x00,0x01,0x9e
	.byte 0x08,0x00,0x00,0x34,0x83,0x12,0x00,0x00
	.byte 0x01,0x9e,0x08,0x00,0x00,0x34,0x8d,0x12
	.byte 0x00,0x00,0x01,0x9e,0x08,0x00,0x00,0x34
	.byte 0x97,0x12,0x00,0x00,0x01,0x9e,0x08,0x00
	.byte 0x00,0x34,0xa1,0x08,0x00,0x00,0x31,0x77
	.byte 0x13,0x01,0x01,0x00,0x00,0x34,0xea,0x14
	.byte 0x00,0x00,0x34,0x7e,0x14,0x00,0x00,0x01
	.byte 0x85,0x14,0x00,0x00,0x34,0x88,0x14,0x00
	.byte 0x00,0x34,0x92,0x14,0x00,0x00,0x34,0x9c
	.byte 0x14,0x00,0x00,0x34,0xa6,0x14,0x00,0x00
	.byte 0x34,0xab,0x14,0x00,0x00,0x34,0xab,0x14
	.byte 0x00,0x00,0x34,0xab,0x14,0x00,0x00,0x34
	.byte 0xab,0x00,0x08,0x00,0x00,0x34,0xb0,0x06
	.byte 0x00,0x00,0x34,0xea
	.ascii "TextureSampleFunc\0"
	.byte 0x02,0x08,0x00,0x00,0x32,0xea,0x0d
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x02,0x00,0x00,0x35,0xa8,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0e
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x0e
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x35,0x07,0x02,0x23,0x0c,0x0e
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x35,0x07,0x02,0x23,0x10,0x0e
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x35,0x07,0x02,0x23,0x14,0x0e
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x35,0x07,0x02,0x23,0x18,0x00
	.byte 0x08,0x00,0x00,0x35,0x0c,0x11
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x02,0x00,0x00,0x3c,0x7a,0x0e
	.ascii "Shared\0"
	.byte 0x00,0x00,0x35,0xa8,0x02,0x23,0x00,0x0e
	.ascii "API\0"
	.byte 0x00,0x00,0x55,0x65,0x02,0x23,0x04,0x0e
	.ascii "Save\0"
	.byte 0x00,0x00,0x55,0x65,0x03,0x23,0xe0,0x05
	.byte 0x0e
	.ascii "Exec\0"
	.byte 0x00,0x00,0x55,0x65,0x03,0x23,0xbc,0x0b
	.byte 0x0e
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xc0,0x03,0x23,0x98,0x11
	.byte 0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x66,0xf4,0x03,0x23,0x9c,0x11
	.byte 0x0e
	.ascii "Driver\0"
	.byte 0x00,0x00,0x70,0x03,0x03,0x23,0xa0,0x11
	.byte 0x0e
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x31,0xa3,0x03,0x23,0xf4,0x12
	.byte 0x0e
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x31,0xa3,0x03,0x23,0xf8,0x12
	.byte 0x0e
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xfc,0x12
	.byte 0x0e
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0x80,0x13
	.byte 0x0e
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x74,0x6b,0x03,0x23,0x84,0x13
	.byte 0x0e
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x74,0x7c,0x03,0x23,0xc4,0x13
	.byte 0x0e
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0x84,0x14
	.byte 0x0e
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x74,0x9e,0x03,0x23,0x88,0x14
	.byte 0x0e
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0x88,0x24
	.byte 0x0e
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0x8c,0x24
	.byte 0x0e
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x74,0xb0,0x03,0x23,0x90,0x24
	.byte 0x0e
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xd0,0x24
	.byte 0x0e
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x74,0xd2,0x03,0x23,0xd4,0x24
	.byte 0x0e
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x74,0xf5,0x03,0x23,0xd4,0x34
	.byte 0x0e
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xd4,0x36
	.byte 0x0e
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xd8,0x36
	.byte 0x0e
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x75,0x07,0x03,0x23,0xdc,0x36
	.byte 0x0e
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0x9c,0x37
	.byte 0x0e
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x75,0x29,0x03,0x23,0xa0,0x37
	.byte 0x0e
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xa0,0x3c
	.byte 0x0e
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xa4,0x3c
	.byte 0x0e
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xa5,0x3c
	.byte 0x0e
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xa8,0x3c
	.byte 0x0e
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x75,0x8f,0x03,0x23,0xac,0x3c
	.byte 0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x75,0xb1,0x03,0x23,0xec,0x3c
	.byte 0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x75,0xfe,0x03,0x23,0xfc,0x3c
	.byte 0x0e
	.ascii "Current\0"
	.byte 0x00,0x00,0x78,0x13,0x03,0x23,0xd4,0x3d
	.byte 0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x78,0xfd,0x03,0x23,0xb4,0x3e
	.byte 0x0e
	.ascii "Eval\0"
	.byte 0x00,0x00,0x79,0x50,0x03,0x23,0xc0,0x3e
	.byte 0x0e
	.ascii "Fog\0"
	.byte 0x00,0x00,0x7b,0xc6,0x03,0x23,0xf8,0x3e
	.byte 0x0e
	.ascii "Hint\0"
	.byte 0x00,0x00,0x7c,0x3f,0x03,0x23,0xa0,0x3f
	.byte 0x0e
	.ascii "Light\0"
	.byte 0x00,0x00,0x81,0x4a,0x03,0x23,0xb4,0x3f
	.byte 0x0e
	.ascii "Line\0"
	.byte 0x00,0x00,0x82,0x7a,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0e
	.ascii "List\0"
	.byte 0x00,0x00,0x82,0xf3,0x04,0x23,0x94,0xdc
	.byte 0x02,0x0e
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x83,0xd9,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0e
	.ascii "Point\0"
	.byte 0x00,0x00,0x86,0xa9,0x04,0x23,0x80,0xad
	.byte 0x03,0x0e
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x87,0x22,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0e
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x88,0x55,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0e
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x88,0x74,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0e
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x88,0xcf,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0e
	.ascii "Texture\0"
	.byte 0x00,0x00,0x8a,0x29,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0e
	.ascii "Transform\0"
	.byte 0x00,0x00,0x8c,0x8b,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0e
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x8d,0x05,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0e
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0e
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x8d,0xac,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0e
	.ascii "Array\0"
	.byte 0x00,0x00,0x8d,0xc2,0x04,0x23,0xac,0xba
	.byte 0x03,0x0e
	.ascii "Pack\0"
	.byte 0x00,0x00,0x90,0x6d,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0e
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x90,0x6d,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0e
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x91,0xef,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0e
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x93,0x79,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0e
	.ascii "Select\0"
	.byte 0x00,0x00,0x93,0xee,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0e
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0e
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0e
	.ascii "NewState\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0e
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0e
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0e
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0e
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0e
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0e
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0e
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0e
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x01,0xa7,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0e
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x01,0xa7,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0e
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x01,0xa7,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0e
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0e
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0e
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0e
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0e
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x3e,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0e
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x71,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0e
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0xa7,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0e
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xe6,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0e
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6e,0x1c,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0e
	.ascii "VB\0"
	.byte 0x00,0x00,0x94,0xb3,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0e
	.ascii "PB\0"
	.byte 0x00,0x00,0x94,0xc7,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0e
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0e
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x08,0x00,0x00,0x35,0xad,0x13
	.byte 0x01,0x01,0x00,0x00,0x3c,0x96,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x3c,0x7f,0x13,0x01,0x01,0x00,0x00
	.byte 0x3c,0xb2,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x3c,0x9b,0x12
	.byte 0x00,0x00,0x01,0x85,0x08,0x00,0x00,0x3c
	.byte 0xb7,0x15,0x01,0x00,0x00,0x31,0x77,0x01
	.byte 0x00,0x00,0x3c,0xe1,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x3c,0xbc,0x14,0x00,0x00,0x34,0xab
	.byte 0x00,0x08,0x00,0x00,0x3c,0xc1,0x13,0x01
	.byte 0x01,0x00,0x00,0x3c,0xf8,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x61,0x00
	.byte 0x08,0x00,0x00,0x3c,0xe6,0x13,0x01,0x01
	.byte 0x00,0x00,0x3d,0x0f,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x00,0x08
	.byte 0x00,0x00,0x3c,0xfd,0x13,0x01,0x01,0x00
	.byte 0x00,0x3d,0x2b,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0x85,0x00,0x08,0x00,0x00,0x3d,0x14
	.byte 0x06,0x00,0x00,0x31,0x9b
	.ascii "GLvoid\0"
	.byte 0x03,0x08,0x00,0x00,0x3d,0x30,0x0d
	.ascii "gl_image\0"
	.byte 0x24,0x02,0x00,0x00,0x3d,0xdf,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x08,0x0e
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x0c,0x0e
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x10,0x0e
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x14,0x0e
	.ascii "Data\0"
	.byte 0x00,0x00,0x3d,0x3d,0x02,0x23,0x18,0x0e
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x1c,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x20,0x00
	.byte 0x12,0x00,0x00,0x3d,0x42,0x08,0x00,0x00
	.byte 0x3d,0xdf,0x13,0x01,0x01,0x00,0x00,0x3e
	.byte 0x19,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x3d
	.byte 0xe4,0x00,0x08,0x00,0x00,0x3d,0xe9,0x13
	.byte 0x01,0x01,0x00,0x00,0x3e,0x3f,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x00
	.byte 0x08,0x00,0x00,0x3e,0x1e,0x13,0x01,0x01
	.byte 0x00,0x00,0x3e,0x56,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x00,0x08
	.byte 0x00,0x00,0x3e,0x44,0x13,0x01,0x01,0x00
	.byte 0x00,0x3e,0x72,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x00,0x08,0x00,0x00,0x3e,0x5b
	.byte 0x13,0x01,0x01,0x00,0x00,0x3e,0x89,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x85,0x00,0x08,0x00,0x00,0x3e,0x77,0x12
	.byte 0x00,0x00,0x31,0x9b,0x08,0x00,0x00,0x3e
	.byte 0x8e,0x13,0x01,0x01,0x00,0x00,0x3e,0xb4
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x3e,0x93,0x00,0x08,0x00,0x00
	.byte 0x3e,0x98,0x13,0x01,0x01,0x00,0x00,0x3e
	.byte 0xcb,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x3e
	.byte 0xb9,0x13,0x01,0x01,0x00,0x00,0x3e,0xf1
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x3e,0xd0,0x13
	.byte 0x01,0x01,0x00,0x00,0x3f,0x17,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x00
	.byte 0x08,0x00,0x00,0x3e,0xf6,0x05
	.ascii "double\0"
	.byte 0x04,0x08,0x13,0x01,0x01,0x00,0x00,0x3f
	.byte 0x38,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x3f,0x1c,0x00,0x08,0x00,0x00,0x3f
	.byte 0x26,0x13,0x01,0x01,0x00,0x00,0x3f,0x4f
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x9e,0x00,0x08,0x00,0x00,0x3f,0x3d
	.byte 0x13,0x01,0x01,0x00,0x00,0x3f,0x66,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x3f,0x54,0x12
	.byte 0x00,0x00,0x01,0x9e,0x08,0x00,0x00,0x3f
	.byte 0x6b,0x13,0x01,0x01,0x00,0x00,0x3f,0x8c
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x3f,0x70,0x00
	.byte 0x08,0x00,0x00,0x3f,0x75,0x13,0x01,0x01
	.byte 0x00,0x00,0x3f,0xad,0x14,0x00,0x00,0x3c
	.byte 0x7a
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x00
	.byte 0x08,0x00,0x00,0x3f,0x91,0x12,0x00,0x00
	.byte 0x01,0x9e,0x08,0x00,0x00,0x3f,0xb2,0x13
	.byte 0x01,0x01,0x00,0x00,0x3f,0xce,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x3f,0xb7
	.byte 0x00,0x08,0x00,0x00,0x3f,0xbc,0x13,0x01
	.byte 0x01,0x00,0x00,0x3f,0xf4,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x00,0x08
	.byte 0x00,0x00,0x3f,0xd3,0x12,0x00,0x00,0x01
	.byte 0x9e,0x08,0x00,0x00,0x3f,0xf9,0x13,0x01
	.byte 0x01,0x00,0x00,0x40,0x15,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x3f,0xfe,0x00
	.byte 0x08,0x00,0x00,0x40,0x03,0x13,0x01,0x01
	.byte 0x00,0x00,0x40,0x3b,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x31,0x77,0x14,0x00
	.byte 0x00,0x31,0x77,0x14,0x00,0x00,0x31,0x77
	.byte 0x14,0x00,0x00,0x31,0x77,0x00,0x08,0x00
	.byte 0x00,0x40,0x1a,0x12,0x00,0x00,0x31,0x77
	.byte 0x08,0x00,0x00,0x40,0x40,0x13,0x01,0x01
	.byte 0x00,0x00,0x40,0x5c,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x40,0x45,0x00,0x08
	.byte 0x00,0x00,0x40,0x4a,0x13,0x01,0x01,0x00
	.byte 0x00,0x40,0x82,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x31,0x77,0x14,0x00,0x00
	.byte 0x31,0x77,0x14,0x00,0x00,0x31,0x77,0x14
	.byte 0x00,0x00,0x31,0x77,0x00,0x08,0x00,0x00
	.byte 0x40,0x61,0x13,0x01,0x01,0x00,0x00,0x40
	.byte 0x9e,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x00,0x08,0x00,0x00,0x40,0x87,0x12,0x00
	.byte 0x00,0x31,0x9b,0x08,0x00,0x00,0x40,0xa3
	.byte 0x13,0x01,0x01,0x00,0x00,0x40,0xce,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x40,0xa8
	.byte 0x00,0x08,0x00,0x00,0x40,0xad,0x08,0x00
	.byte 0x00,0x3d,0x42,0x13,0x01,0x01,0x00,0x00
	.byte 0x40,0xf4,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x40,0xd3,0x00,0x08
	.byte 0x00,0x00,0x40,0xd8,0x13,0x01,0x01,0x00
	.byte 0x00,0x41,0x15,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x40,0xd3,0x00
	.byte 0x08,0x00,0x00,0x40,0xf9,0x13,0x01,0x01
	.byte 0x00,0x00,0x41,0x40,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0xce,0x00,0x08,0x00,0x00,0x41,0x1a
	.byte 0x13,0x01,0x01,0x00,0x00,0x41,0x75,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x00
	.byte 0x08,0x00,0x00,0x41,0x45,0x13,0x01,0x01
	.byte 0x00,0x00,0x41,0xaf,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x41,0x7a,0x13
	.byte 0x01,0x01,0x00,0x00,0x41,0xdf,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x41,0xb4,0x13
	.byte 0x01,0x01,0x00,0x00,0x42,0x19,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x00,0x08,0x00,0x00,0x41
	.byte 0xe4,0x13,0x01,0x01,0x00,0x00,0x42,0x58
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x00,0x08,0x00,0x00,0x42,0x1e
	.byte 0x13,0x01,0x01,0x00,0x00,0x42,0x6f,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x00,0x08,0x00,0x00,0x42,0x5d,0x13
	.byte 0x01,0x01,0x00,0x00,0x42,0x8b,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x85
	.byte 0x14,0x00,0x00,0x01,0x61,0x00,0x08,0x00
	.byte 0x00,0x42,0x74,0x12,0x00,0x00,0x01,0x85
	.byte 0x08,0x00,0x00,0x42,0x90,0x13,0x01,0x01
	.byte 0x00,0x00,0x42,0xb1,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x42,0x95,0x00,0x08,0x00,0x00,0x42
	.byte 0x9a,0x13,0x01,0x01,0x00,0x00,0x42,0xc8
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x00,0x08,0x00,0x00,0x42,0xb6
	.byte 0x13,0x01,0x01,0x00,0x00,0x42,0xdf,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x31
	.byte 0x77,0x00,0x08,0x00,0x00,0x42,0xcd,0x13
	.byte 0x01,0x01,0x00,0x00,0x42,0xfb,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x3f,0x1c
	.byte 0x14,0x00,0x00,0x3f,0x1c,0x00,0x08,0x00
	.byte 0x00,0x42,0xe4,0x13,0x01,0x01,0x00,0x00
	.byte 0x43,0x12,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x43,0x00,0x13,0x01,0x01,0x00,0x00,0x43
	.byte 0x29,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x00,0x08,0x00,0x00,0x43
	.byte 0x17,0x13,0x01,0x01,0x00,0x00,0x43,0x4a
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x00,0x08,0x00,0x00
	.byte 0x43,0x2e,0x13,0x01,0x01,0x00,0x00,0x43
	.byte 0x61,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x00,0x08,0x00,0x00,0x43
	.byte 0x4f,0x12,0x00,0x00,0x31,0x9b,0x08,0x00
	.byte 0x00,0x43,0x66,0x13,0x01,0x01,0x00,0x00
	.byte 0x43,0x91,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x43,0x6b,0x00,0x08,0x00,0x00,0x43
	.byte 0x70,0x12,0x00,0x00,0x31,0x9b,0x08,0x00
	.byte 0x00,0x43,0x96,0x13,0x01,0x01,0x00,0x00
	.byte 0x43,0xc6,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x43,0x9b
	.byte 0x00,0x08,0x00,0x00,0x43,0xa0,0x13,0x01
	.byte 0x01,0x00,0x00,0x43,0xdd,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x31,0x77,0x00
	.byte 0x08,0x00,0x00,0x43,0xcb,0x12,0x00,0x00
	.byte 0x31,0x77,0x08,0x00,0x00,0x43,0xe2,0x13
	.byte 0x01,0x01,0x00,0x00,0x44,0x03,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x43,0xe7,0x00,0x08,0x00
	.byte 0x00,0x43,0xec,0x13,0x01,0x01,0x00,0x00
	.byte 0x44,0x1a,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x44,0x08,0x13,0x01,0x01,0x00,0x00,0x44
	.byte 0x31,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x00,0x08,0x00,0x00,0x44
	.byte 0x1f,0x13,0x01,0x01,0x00,0x00,0x44,0x43
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x00,0x08,0x00
	.byte 0x00,0x44,0x36,0x13,0x01,0x01,0x00,0x00
	.byte 0x44,0x55,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x44,0x48,0x13,0x01,0x01
	.byte 0x00,0x00,0x44,0x6c,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x9e,0x00,0x08
	.byte 0x00,0x00,0x44,0x5a,0x13,0x01,0x01,0x00
	.byte 0x00,0x44,0x88,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x00,0x08,0x00,0x00,0x44,0x71
	.byte 0x13,0x01,0x01,0x00,0x00,0x44,0xa9,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x00,0x08,0x00,0x00,0x44
	.byte 0x8d,0x13,0x01,0x01,0x00,0x00,0x44,0xd4
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x00,0x08
	.byte 0x00,0x00,0x44,0xae,0x13,0x01,0x01,0x00
	.byte 0x00,0x44,0xeb,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x61,0x00,0x08,0x00
	.byte 0x00,0x44,0xd9,0x13,0x01,0x01,0x00,0x00
	.byte 0x45,0x07,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x44,0xf0,0x08
	.byte 0x00,0x00,0x01,0x9e,0x13,0x01,0x01,0x00
	.byte 0x00,0x45,0x2d,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x45,0x0c,0x00
	.byte 0x08,0x00,0x00,0x45,0x11,0x13,0x01,0x01
	.byte 0x00,0x00,0x45,0x3f,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x00,0x08,0x00,0x00,0x45,0x32,0x13
	.byte 0x01,0x01,0x00,0x00,0x45,0x51,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x00,0x08,0x00,0x00,0x45
	.byte 0x44,0x12,0x00,0x00,0x01,0x9e,0x08,0x00
	.byte 0x00,0x45,0x56,0x13,0x01,0x01,0x00,0x00
	.byte 0x45,0x77,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x45
	.byte 0x5b,0x00,0x08,0x00,0x00,0x45,0x60,0x13
	.byte 0x01,0x01,0x00,0x00,0x45,0x8e,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x00,0x08,0x00,0x00,0x45,0x7c,0x13,0x01
	.byte 0x01,0x00,0x00,0x45,0xbe,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x3f,0x1c,0x14
	.byte 0x00,0x00,0x3f,0x1c,0x14,0x00,0x00,0x3f
	.byte 0x1c,0x14,0x00,0x00,0x3f,0x1c,0x14,0x00
	.byte 0x00,0x3f,0x1c,0x14,0x00,0x00,0x3f,0x1c
	.byte 0x00,0x08,0x00,0x00,0x45,0x93,0x15,0x01
	.byte 0x00,0x00,0x01,0x85,0x01,0x00,0x00,0x45
	.byte 0xd9,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x61,0x00,0x08,0x00,0x00,0x45
	.byte 0xc3,0x08,0x00,0x00,0x01,0x85,0x13,0x01
	.byte 0x01,0x00,0x00,0x45,0xfa,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x45,0xde,0x00,0x08,0x00,0x00
	.byte 0x45,0xe3,0x13,0x01,0x01,0x00,0x00,0x46
	.byte 0x16,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x34,0xab
	.byte 0x00,0x08,0x00,0x00,0x45,0xff,0x08,0x00
	.byte 0x00,0x3f,0x1c,0x13,0x01,0x01,0x00,0x00
	.byte 0x46,0x37,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x46
	.byte 0x1b,0x00,0x08,0x00,0x00,0x46,0x20,0x13
	.byte 0x01,0x01,0x00,0x00,0x46,0x5d,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x31,0xa3,0x00
	.byte 0x08,0x00,0x00,0x46,0x3c,0x08,0x00,0x00
	.byte 0x01,0x61,0x13,0x01,0x01,0x00,0x00,0x46
	.byte 0x83,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x46,0x62,0x00,0x08,0x00
	.byte 0x00,0x46,0x67,0x13,0x01,0x01,0x00,0x00
	.byte 0x46,0x9f,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x46
	.byte 0x1b,0x00,0x08,0x00,0x00,0x46,0x88,0x15
	.byte 0x01,0x00,0x00,0x01,0xce,0x01,0x00,0x00
	.byte 0x46,0xb5,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x46,0xa4,0x13,0x01,0x01
	.byte 0x00,0x00,0x46,0xd1,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x45,0x0c,0x00,0x08,0x00,0x00,0x46
	.byte 0xba,0x13,0x01,0x01,0x00,0x00,0x46,0xed
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x46,0x62,0x00
	.byte 0x08,0x00,0x00,0x46,0xd6,0x12,0x00,0x00
	.byte 0x31,0x77,0x08,0x00,0x00,0x46,0xf2,0x15
	.byte 0x01,0x00,0x00,0x46,0xf7,0x01,0x00,0x00
	.byte 0x47,0x12,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x46,0xfc,0x13,0x01,0x01,0x00,0x00,0x47
	.byte 0x33,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x45,0x0c,0x00,0x08,0x00
	.byte 0x00,0x47,0x17,0x13,0x01,0x01,0x00,0x00
	.byte 0x47,0x54,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x46,0x62,0x00,0x08
	.byte 0x00,0x00,0x47,0x38,0x13,0x01,0x01,0x00
	.byte 0x00,0x47,0x75,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x46,0x1b,0x00
	.byte 0x08,0x00,0x00,0x47,0x59,0x13,0x01,0x01
	.byte 0x00,0x00,0x47,0x96,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x45,0x0c
	.byte 0x00,0x08,0x00,0x00,0x47,0x7a,0x13,0x01
	.byte 0x01,0x00,0x00,0x47,0xb7,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x46
	.byte 0x62,0x00,0x08,0x00,0x00,0x47,0x9b,0x13
	.byte 0x01,0x01,0x00,0x00,0x47,0xd8,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x45,0x0c,0x00,0x08,0x00,0x00,0x47,0xbc
	.byte 0x13,0x01,0x01,0x00,0x00,0x47,0xf9,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x46,0x62,0x00,0x08,0x00,0x00,0x47
	.byte 0xdd,0x13,0x01,0x01,0x00,0x00,0x48,0x15
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x45,0x0c,0x00
	.byte 0x08,0x00,0x00,0x47,0xfe,0x13,0x01,0x01
	.byte 0x00,0x00,0x48,0x31,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x45,0xde,0x00,0x08,0x00,0x00,0x48
	.byte 0x1a,0x05
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x08,0x00,0x00,0x48,0x36,0x13
	.byte 0x01,0x01,0x00,0x00,0x48,0x64,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x48,0x48,0x00,0x08,0x00
	.byte 0x00,0x48,0x4d,0x08,0x00,0x00,0x31,0xa3
	.byte 0x13,0x01,0x01,0x00,0x00,0x48,0x85,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x48,0x69,0x00,0x08
	.byte 0x00,0x00,0x48,0x6e,0x13,0x01,0x01,0x00
	.byte 0x00,0x48,0x9c,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x34,0xab,0x00,0x08,0x00
	.byte 0x00,0x48,0x8a,0x12,0x00,0x00,0x01,0x85
	.byte 0x08,0x00,0x00,0x48,0xa1,0x12,0x00,0x00
	.byte 0x01,0x9e,0x08,0x00,0x00,0x48,0xab,0x13
	.byte 0x01,0x01,0x00,0x00,0x48,0xd1,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x48,0xa6,0x14,0x00,0x00
	.byte 0x48,0xb0,0x00,0x08,0x00,0x00,0x48,0xb5
	.byte 0x13,0x01,0x01,0x00,0x00,0x48,0xf2,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x45,0x0c,0x00,0x08,0x00,0x00,0x48
	.byte 0xd6,0x13,0x01,0x01,0x00,0x00,0x49,0x13
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x46,0x62,0x00,0x08,0x00,0x00
	.byte 0x48,0xf7,0x13,0x01,0x01,0x00,0x00,0x49
	.byte 0x34,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x46,0x1b,0x00,0x08,0x00
	.byte 0x00,0x49,0x18,0x13,0x01,0x01,0x00,0x00
	.byte 0x49,0x55,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x45,0x0c,0x00,0x08
	.byte 0x00,0x00,0x49,0x39,0x13,0x01,0x01,0x00
	.byte 0x00,0x49,0x76,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x46,0x62,0x00
	.byte 0x08,0x00,0x00,0x49,0x5a,0x13,0x01,0x01
	.byte 0x00,0x00,0x49,0xa1,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x31,0xa3,0x00,0x08,0x00,0x00,0x49,0x7b
	.byte 0x13,0x01,0x01,0x00,0x00,0x49,0xc7,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x45,0x0c
	.byte 0x00,0x08,0x00,0x00,0x49,0xa6,0x13,0x01
	.byte 0x01,0x00,0x00,0x49,0xed,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x46,0x62,0x00,0x08
	.byte 0x00,0x00,0x49,0xcc,0x13,0x01,0x01,0x00
	.byte 0x00,0x4a,0x0e,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x45,0x0c,0x00
	.byte 0x08,0x00,0x00,0x49,0xf2,0x13,0x01,0x01
	.byte 0x00,0x00,0x4a,0x2f,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x46,0x62
	.byte 0x00,0x08,0x00,0x00,0x4a,0x13,0x13,0x01
	.byte 0x01,0x00,0x00,0x4a,0x4b,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x4a,0x34,0x13,0x01,0x01,0x00,0x00,0x4a
	.byte 0x62,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x4a
	.byte 0x50,0x13,0x01,0x01,0x00,0x00,0x4a,0x79
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x9e,0x00,0x08,0x00,0x00,0x4a,0x67
	.byte 0x13,0x01,0x01,0x00,0x00,0x4a,0x90,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x4a,0x7e,0x12
	.byte 0x00,0x00,0x31,0x9b,0x08,0x00,0x00,0x4a
	.byte 0x95,0x13,0x01,0x01,0x00,0x00,0x4a,0xbb
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x4a,0x9a,0x00,0x08,0x00,0x00
	.byte 0x4a,0x9f,0x13,0x01,0x01,0x00,0x00,0x4a
	.byte 0xcd,0x14,0x00,0x00,0x3c,0x7a,0x00,0x08
	.byte 0x00,0x00,0x4a,0xc0,0x12,0x00,0x00,0x31
	.byte 0x9b,0x08,0x00,0x00,0x4a,0xd2,0x13,0x01
	.byte 0x01,0x00,0x00,0x4a,0xf8,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x4a
	.byte 0xd7,0x00,0x08,0x00,0x00,0x4a,0xdc,0x15
	.byte 0x01,0x00,0x00,0x31,0x77,0x01,0x00,0x00
	.byte 0x4b,0x13,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x4a,0xfd,0x15,0x01,0x00,0x00,0x31,0x77
	.byte 0x01,0x00,0x00,0x4b,0x2e,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x85,0x00
	.byte 0x08,0x00,0x00,0x4b,0x18,0x15,0x01,0x00
	.byte 0x00,0x31,0x77,0x01,0x00,0x00,0x4b,0x49
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x00,0x08,0x00,0x00,0x4b,0x33
	.byte 0x12,0x00,0x00,0x01,0x9e,0x08,0x00,0x00
	.byte 0x4b,0x4e,0x13,0x01,0x01,0x00,0x00,0x4b
	.byte 0x6f,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x4b,0x53
	.byte 0x00,0x08,0x00,0x00,0x4b,0x58,0x12,0x00
	.byte 0x00,0x01,0x9e,0x08,0x00,0x00,0x4b,0x74
	.byte 0x13,0x01,0x01,0x00,0x00,0x4b,0x9f,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x4b,0x79,0x14,0x00,0x00,0x01,0x61
	.byte 0x00,0x08,0x00,0x00,0x4b,0x7e,0x13,0x01
	.byte 0x01,0x00,0x00,0x4b,0xbb,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x48,0x36,0x00,0x08,0x00,0x00
	.byte 0x4b,0xa4,0x13,0x01,0x01,0x00,0x00,0x4b
	.byte 0xd2,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x9e,0x00,0x08,0x00,0x00,0x4b
	.byte 0xc0,0x13,0x01,0x01,0x00,0x00,0x4b,0xe9
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x00,0x08,0x00,0x00,0x4b,0xd7
	.byte 0x13,0x01,0x01,0x00,0x00,0x4b,0xfb,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x00,0x08,0x00,0x00
	.byte 0x4b,0xee,0x12,0x00,0x00,0x01,0x9e,0x08
	.byte 0x00,0x00,0x4c,0x00,0x13,0x01,0x01,0x00
	.byte 0x00,0x4c,0x1c,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x4c,0x05,0x00,0x08,0x00
	.byte 0x00,0x4c,0x0a,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0x33,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x85,0x00,0x08,0x00,0x00
	.byte 0x4c,0x21,0x13,0x01,0x01,0x00,0x00,0x4c
	.byte 0x4a,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x00,0x08,0x00,0x00,0x4c
	.byte 0x38,0x12,0x00,0x00,0x01,0x9e,0x08,0x00
	.byte 0x00,0x4c,0x4f,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0x89,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x4c,0x54,0x14,0x00,0x00
	.byte 0x31,0x77,0x00,0x08,0x00,0x00,0x4c,0x59
	.byte 0x12,0x00,0x00,0x01,0x9e,0x08,0x00,0x00
	.byte 0x4c,0x8e,0x13,0x01,0x01,0x00,0x00,0x4c
	.byte 0xdc,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x4c,0x93
	.byte 0x14,0x00,0x00,0x31,0x77,0x00,0x08,0x00
	.byte 0x00,0x4c,0x98,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0xfd,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x00,0x08
	.byte 0x00,0x00,0x4c,0xe1,0x13,0x01,0x01,0x00
	.byte 0x00,0x4d,0x2d,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x00,0x08
	.byte 0x00,0x00,0x4d,0x02,0x12,0x00,0x00,0x01
	.byte 0x9e,0x08,0x00,0x00,0x4d,0x32,0x13,0x01
	.byte 0x01,0x00,0x00,0x4d,0x58,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x4d
	.byte 0x37,0x00,0x08,0x00,0x00,0x4d,0x3c,0x13
	.byte 0x01,0x01,0x00,0x00,0x4d,0x6f,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x00,0x08,0x00,0x00,0x4d,0x5d,0x12,0x00
	.byte 0x00,0x01,0x9e,0x08,0x00,0x00,0x4d,0x74
	.byte 0x13,0x01,0x01,0x00,0x00,0x4d,0x90,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x4d
	.byte 0x79,0x00,0x08,0x00,0x00,0x4d,0x7e,0x13
	.byte 0x01,0x01,0x00,0x00,0x4d,0xac,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x85
	.byte 0x14,0x00,0x00,0x01,0xce,0x00,0x08,0x00
	.byte 0x00,0x4d,0x95,0x13,0x01,0x01,0x00,0x00
	.byte 0x4d,0xcd,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x00,0x08
	.byte 0x00,0x00,0x4d,0xb1,0x12,0x00,0x00,0x01
	.byte 0x9e,0x08,0x00,0x00,0x4d,0xd2,0x13,0x01
	.byte 0x01,0x00,0x00,0x4d,0xee,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x4d,0xd7,0x00
	.byte 0x08,0x00,0x00,0x4d,0xdc,0x12,0x00,0x00
	.byte 0x31,0x9b,0x08,0x00,0x00,0x4d,0xf3,0x13
	.byte 0x01,0x01,0x00,0x00,0x4e,0x19,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x4d,0xf8,0x00,0x08,0x00,0x00,0x4d,0xfd
	.byte 0x13,0x01,0x01,0x00,0x00,0x4e,0x49,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x3f
	.byte 0x1c,0x14,0x00,0x00,0x3f,0x1c,0x14,0x00
	.byte 0x00,0x3f,0x1c,0x14,0x00,0x00,0x3f,0x1c
	.byte 0x14,0x00,0x00,0x3f,0x1c,0x14,0x00,0x00
	.byte 0x3f,0x1c,0x00,0x08,0x00,0x00,0x4e,0x1e
	.byte 0x13,0x01,0x01,0x00,0x00,0x4e,0x60,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x4e,0x4e,0x12
	.byte 0x00,0x00,0x01,0x9e,0x08,0x00,0x00,0x4e
	.byte 0x65,0x13,0x01,0x01,0x00,0x00,0x4e,0x8b
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x4e,0x6a,0x00,0x08,0x00,0x00
	.byte 0x4e,0x6f,0x13,0x01,0x01,0x00,0x00,0x4e
	.byte 0xa7,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0x61
	.byte 0x00,0x08,0x00,0x00,0x4e,0x90,0x13,0x01
	.byte 0x01,0x00,0x00,0x4e,0xc3,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x9e,0x00,0x08,0x00,0x00
	.byte 0x4e,0xac,0x13,0x01,0x01,0x00,0x00,0x4e
	.byte 0xdf,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x9e,0x14,0x00,0x00,0x01,0x9e
	.byte 0x00,0x08,0x00,0x00,0x4e,0xc8,0x12,0x00
	.byte 0x00,0x01,0x9e,0x08,0x00,0x00,0x4e,0xe4
	.byte 0x13,0x01,0x01,0x00,0x00,0x4f,0x05,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x4e,0xe9,0x00,0x08
	.byte 0x00,0x00,0x4e,0xee,0x13,0x01,0x01,0x00
	.byte 0x00,0x4f,0x1c,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x4f,0x0a,0x13,0x01,0x01,0x00,0x00
	.byte 0x4f,0x38,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0xce,0x00,0x08,0x00,0x00,0x4f,0x21,0x13
	.byte 0x01,0x01,0x00,0x00,0x4f,0x54,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x4f,0x3d,0x12,0x00,0x00,0x31,0x77
	.byte 0x08,0x00,0x00,0x4f,0x59,0x13,0x01,0x01
	.byte 0x00,0x00,0x4f,0x75,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x4f,0x5e,0x00,0x08
	.byte 0x00,0x00,0x4f,0x63,0x13,0x01,0x01,0x00
	.byte 0x00,0x4f,0x87,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x00,0x08
	.byte 0x00,0x00,0x4f,0x7a,0x13,0x01,0x01,0x00
	.byte 0x00,0x4f,0x99,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x00,0x08,0x00,0x00,0x4f,0x8c,0x13,0x01
	.byte 0x01,0x00,0x00,0x4f,0xab,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x00,0x08,0x00,0x00,0x4f,0x9e
	.byte 0x13,0x01,0x01,0x00,0x00,0x4f,0xbd,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x00,0x08,0x00,0x00
	.byte 0x4f,0xb0,0x13,0x01,0x01,0x00,0x00,0x4f
	.byte 0xd4,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x4f
	.byte 0xc2,0x13,0x01,0x01,0x00,0x00,0x4f,0xeb
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x00,0x08,0x00,0x00,0x4f,0xd9
	.byte 0x13,0x01,0x01,0x00,0x00,0x4f,0xfd,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x00,0x08,0x00,0x00
	.byte 0x4f,0xf0,0x13,0x01,0x01,0x00,0x00,0x50
	.byte 0x14,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x50
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x50,0x3a
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x50,0x19,0x13
	.byte 0x01,0x01,0x00,0x00,0x50,0x51,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x00,0x08,0x00,0x00,0x50,0x3f,0x13,0x01
	.byte 0x01,0x00,0x00,0x50,0x86,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x31,0xa3,0x00,0x08,0x00
	.byte 0x00,0x50,0x56,0x13,0x01,0x01,0x00,0x00
	.byte 0x50,0xac,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x9e,0x00,0x08,0x00,0x00,0x50
	.byte 0x8b,0x15,0x01,0x00,0x00,0x01,0x61,0x01
	.byte 0x00,0x00,0x50,0xc7,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x00,0x08
	.byte 0x00,0x00,0x50,0xb1,0x13,0x01,0x01,0x00
	.byte 0x00,0x50,0xed,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x00,0x08,0x00,0x00
	.byte 0x50,0xcc,0x13,0x01,0x01,0x00,0x00,0x51
	.byte 0x0e,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x9e,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x50,0xf2,0x13,0x01,0x01,0x00,0x00
	.byte 0x51,0x34,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x00,0x08,0x00,0x00,0x51
	.byte 0x13,0x13,0x01,0x01,0x00,0x00,0x51,0x50
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x45,0xde,0x00
	.byte 0x08,0x00,0x00,0x51,0x39,0x13,0x01,0x01
	.byte 0x00,0x00,0x51,0x67,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x00,0x08
	.byte 0x00,0x00,0x51,0x55,0x13,0x01,0x01,0x00
	.byte 0x00,0x51,0x88,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x85,0x00
	.byte 0x08,0x00,0x00,0x51,0x6c,0x13,0x01,0x01
	.byte 0x00,0x00,0x51,0x9f,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x85,0x00,0x08
	.byte 0x00,0x00,0x51,0x8d,0x13,0x01,0x01,0x00
	.byte 0x00,0x51,0xc0,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0xce,0x00
	.byte 0x08,0x00,0x00,0x51,0xa4,0x13,0x01,0x01
	.byte 0x00,0x00,0x51,0xdc,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x9e,0x00,0x08,0x00,0x00,0x51
	.byte 0xc5,0x13,0x01,0x01,0x00,0x00,0x52,0x02
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x51,0xe1,0x12
	.byte 0x00,0x00,0x31,0x9b,0x08,0x00,0x00,0x52
	.byte 0x07,0x13,0x01,0x01,0x00,0x00,0x52,0x32
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x52
	.byte 0x0c,0x00,0x08,0x00,0x00,0x52,0x11,0x12
	.byte 0x00,0x00,0x01,0x9e,0x08,0x00,0x00,0x52
	.byte 0x37,0x13,0x01,0x01,0x00,0x00,0x52,0x5d
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x52,0x3c,0x00,0x08,0x00,0x00
	.byte 0x52,0x41,0x12,0x00,0x00,0x01,0x9e,0x08
	.byte 0x00,0x00,0x52,0x62,0x13,0x01,0x01,0x00
	.byte 0x00,0x52,0x88,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x52,0x67,0x00
	.byte 0x08,0x00,0x00,0x52,0x6c,0x13,0x01,0x01
	.byte 0x00,0x00,0x52,0xc2,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x40
	.byte 0xd3,0x00,0x08,0x00,0x00,0x52,0x8d,0x13
	.byte 0x01,0x01,0x00,0x00,0x53,0x01,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x40,0xd3
	.byte 0x00,0x08,0x00,0x00,0x52,0xc7,0x13,0x01
	.byte 0x01,0x00,0x00,0x53,0x36,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0xce
	.byte 0x14,0x00,0x00,0x40,0xd3,0x00,0x08,0x00
	.byte 0x00,0x53,0x06,0x13,0x01,0x01,0x00,0x00
	.byte 0x53,0x75,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x40,0xd3,0x00,0x08,0x00,0x00
	.byte 0x53,0x3b,0x13,0x01,0x01,0x00,0x00,0x53
	.byte 0xb9,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x01,0xce,0x14,0x00,0x00,0x40,0xd3
	.byte 0x00,0x08,0x00,0x00,0x53,0x7a,0x13,0x01
	.byte 0x01,0x00,0x00,0x54,0x02,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x40
	.byte 0xd3,0x00,0x08,0x00,0x00,0x53,0xbe,0x12
	.byte 0x00,0x00,0x01,0x9e,0x08,0x00,0x00,0x54
	.byte 0x07,0x13,0x01,0x01,0x00,0x00,0x54,0x2d
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0xce,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x54,0x0c,0x00,0x08,0x00,0x00
	.byte 0x54,0x11,0x13,0x01,0x01,0x00,0x00,0x54
	.byte 0x4e,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x9e,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x54,0x32,0x13,0x01,0x01,0x00,0x00
	.byte 0x54,0x6a,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x00,0x08,0x00,0x00,0x54,0x53,0x13
	.byte 0x01,0x01,0x00,0x00,0x54,0x8b,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x14,0x00,0x00
	.byte 0x01,0x9e,0x00,0x08,0x00,0x00,0x54,0x6f
	.byte 0x13,0x01,0x01,0x00,0x00,0x54,0xb1,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x9e,0x14,0x00,0x00,0x01,0x9e
	.byte 0x00,0x08,0x00,0x00,0x54,0x90,0x12,0x00
	.byte 0x00,0x01,0x9e,0x08,0x00,0x00,0x54,0xb6
	.byte 0x13,0x01,0x01,0x00,0x00,0x54,0xd2,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x54
	.byte 0xbb,0x00,0x08,0x00,0x00,0x54,0xc0,0x12
	.byte 0x00,0x00,0x31,0x9b,0x08,0x00,0x00,0x54
	.byte 0xd7,0x13,0x01,0x01,0x00,0x00,0x55,0x02
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x54
	.byte 0xdc,0x00,0x08,0x00,0x00,0x54,0xe1,0x13
	.byte 0x01,0x01,0x00,0x00,0x55,0x28,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x00
	.byte 0x08,0x00,0x00,0x55,0x07,0x13,0x01,0x01
	.byte 0x00,0x00,0x55,0x4e,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x9e,0x14,0x00,0x00,0x01,0x9e
	.byte 0x14,0x00,0x00,0x01,0x9e,0x00,0x08,0x00
	.byte 0x00,0x55,0x2d,0x13,0x01,0x01,0x00,0x00
	.byte 0x55,0x60,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x55,0x53,0x11
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x02,0x00,0x00,0x64,0x09,0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x3c,0x96,0x02,0x23,0x00,0x0e
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x3c,0xb2,0x02,0x23,0x04,0x0e
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x3c,0xe1,0x02,0x23,0x08,0x0e
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x3c,0xf8,0x02,0x23,0x0c,0x0e
	.ascii "Begin\0"
	.byte 0x00,0x00,0x3d,0x0f,0x02,0x23,0x10,0x0e
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x3d,0x2b,0x02,0x23,0x14,0x0e
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x3e,0x19,0x02,0x23,0x18,0x0e
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x3e,0x3f,0x02,0x23,0x1c,0x0e
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x3e,0x56,0x02,0x23,0x20,0x0e
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x3e,0x72,0x02,0x23,0x24,0x0e
	.ascii "CallList\0"
	.byte 0x00,0x00,0x3e,0x89,0x02,0x23,0x28,0x0e
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x3e,0xb4,0x02,0x23,0x2c,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x3e,0xcb,0x02,0x23,0x30,0x0e
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x3e,0xf1,0x02,0x23,0x34,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x3f,0x17,0x02,0x23,0x38,0x0e
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x3f,0x38,0x02,0x23,0x3c,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x3f,0x4f,0x02,0x23,0x40,0x0e
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x3f,0x66,0x02,0x23,0x44,0x0e
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x3f,0x8c,0x02,0x23,0x48,0x0e
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x3f,0xad,0x02,0x23,0x4c,0x0e
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x3f,0xce,0x02,0x23,0x50,0x0e
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x3f,0xf4,0x02,0x23,0x54,0x0e
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x40,0x15,0x02,0x23,0x58,0x0e
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x40,0x3b,0x02,0x23,0x5c,0x0e
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x40,0x5c,0x02,0x23,0x60,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x40,0x82,0x02,0x23,0x64,0x0e
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x40,0x9e,0x02,0x23,0x68,0x0e
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x40,0xce,0x02,0x23,0x6c,0x0e
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x40,0xf4,0x02,0x23,0x70,0x0e
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x41,0x15,0x02,0x23,0x74,0x0e
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x41,0x40,0x02,0x23,0x78,0x0e
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x41,0x75,0x02,0x23,0x7c,0x0e
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x41,0xaf,0x03,0x23,0x80,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x41,0xdf,0x03,0x23,0x84,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x42,0x19,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x42,0x58,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x42,0x6f,0x03,0x23,0x90,0x01
	.byte 0x0e
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x42,0x8b,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x42,0xb1,0x03,0x23,0x98,0x01
	.byte 0x0e
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x42,0xc8,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x42,0xdf,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x42,0xfb,0x03,0x23,0xa4,0x01
	.byte 0x0e
	.ascii "Disable\0"
	.byte 0x00,0x00,0x43,0x12,0x03,0x23,0xa8,0x01
	.byte 0x0e
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x43,0x29,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x43,0x4a,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x43,0x61,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x43,0x91,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x43,0xc6,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x43,0xdd,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x44,0x03,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "Enable\0"
	.byte 0x00,0x00,0x44,0x1a,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x44,0x31,0x03,0x23,0xcc,0x01
	.byte 0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x44,0x43,0x03,0x23,0xd0,0x01
	.byte 0x0e
	.ascii "EndList\0"
	.byte 0x00,0x00,0x44,0x55,0x03,0x23,0xd4,0x01
	.byte 0x0e
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x44,0x6c,0x03,0x23,0xd8,0x01
	.byte 0x0e
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x44,0x88,0x03,0x23,0xdc,0x01
	.byte 0x0e
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x44,0xa9,0x03,0x23,0xe0,0x01
	.byte 0x0e
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x44,0xd4,0x03,0x23,0xe4,0x01
	.byte 0x0e
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x44,0xeb,0x03,0x23,0xe8,0x01
	.byte 0x0e
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x45,0x07,0x03,0x23,0xec,0x01
	.byte 0x0e
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x45,0x2d,0x03,0x23,0xf0,0x01
	.byte 0x0e
	.ascii "Finish\0"
	.byte 0x00,0x00,0x45,0x3f,0x03,0x23,0xf4,0x01
	.byte 0x0e
	.ascii "Flush\0"
	.byte 0x00,0x00,0x45,0x51,0x03,0x23,0xf8,0x01
	.byte 0x0e
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x45,0x77,0x03,0x23,0xfc,0x01
	.byte 0x0e
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x45,0x8e,0x03,0x23,0x80,0x02
	.byte 0x0e
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x45,0xbe,0x03,0x23,0x84,0x02
	.byte 0x0e
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x45,0xd9,0x03,0x23,0x88,0x02
	.byte 0x0e
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x45,0xfa,0x03,0x23,0x8c,0x02
	.byte 0x0e
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x46,0x16,0x03,0x23,0x90,0x02
	.byte 0x0e
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x46,0x37,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x46,0x5d,0x03,0x23,0x98,0x02
	.byte 0x0e
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x46,0x83,0x03,0x23,0x9c,0x02
	.byte 0x0e
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x46,0x9f,0x03,0x23,0xa0,0x02
	.byte 0x0e
	.ascii "GetError\0"
	.byte 0x00,0x00,0x46,0xb5,0x03,0x23,0xa4,0x02
	.byte 0x0e
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x46,0xd1,0x03,0x23,0xa8,0x02
	.byte 0x0e
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x46,0xed,0x03,0x23,0xac,0x02
	.byte 0x0e
	.ascii "GetString\0"
	.byte 0x00,0x00,0x47,0x12,0x03,0x23,0xb0,0x02
	.byte 0x0e
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x47,0x33,0x03,0x23,0xb4,0x02
	.byte 0x0e
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x47,0x54,0x03,0x23,0xb8,0x02
	.byte 0x0e
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x47,0x75,0x03,0x23,0xbc,0x02
	.byte 0x0e
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x47,0x96,0x03,0x23,0xc0,0x02
	.byte 0x0e
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x47,0xb7,0x03,0x23,0xc4,0x02
	.byte 0x0e
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x47,0xd8,0x03,0x23,0xc8,0x02
	.byte 0x0e
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x47,0xf9,0x03,0x23,0xcc,0x02
	.byte 0x0e
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x48,0x15,0x03,0x23,0xd0,0x02
	.byte 0x0e
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x48,0x31,0x03,0x23,0xd4,0x02
	.byte 0x0e
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x48,0x64,0x03,0x23,0xd8,0x02
	.byte 0x0e
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x48,0x85,0x03,0x23,0xdc,0x02
	.byte 0x0e
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x48,0x9c,0x03,0x23,0xe0,0x02
	.byte 0x0e
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x48,0xd1,0x03,0x23,0xe4,0x02
	.byte 0x0e
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x48,0xf2,0x03,0x23,0xe8,0x02
	.byte 0x0e
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x49,0x13,0x03,0x23,0xec,0x02
	.byte 0x0e
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x49,0x34,0x03,0x23,0xf0,0x02
	.byte 0x0e
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x49,0x55,0x03,0x23,0xf4,0x02
	.byte 0x0e
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x49,0x76,0x03,0x23,0xf8,0x02
	.byte 0x0e
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x49,0xa1,0x03,0x23,0xfc,0x02
	.byte 0x0e
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x49,0xc7,0x03,0x23,0x80,0x03
	.byte 0x0e
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x49,0xed,0x03,0x23,0x84,0x03
	.byte 0x0e
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x4a,0x0e,0x03,0x23,0x88,0x03
	.byte 0x0e
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x4a,0x2f,0x03,0x23,0x8c,0x03
	.byte 0x0e
	.ascii "Hint\0"
	.byte 0x00,0x00,0x4a,0x4b,0x03,0x23,0x90,0x03
	.byte 0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x4a,0x62,0x03,0x23,0x94,0x03
	.byte 0x0e
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x4a,0x79,0x03,0x23,0x98,0x03
	.byte 0x0e
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x4a,0x90,0x03,0x23,0x9c,0x03
	.byte 0x0e
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x4a,0xbb,0x03,0x23,0xa0,0x03
	.byte 0x0e
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x4a,0xcd,0x03,0x23,0xa4,0x03
	.byte 0x0e
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x4a,0xf8,0x03,0x23,0xa8,0x03
	.byte 0x0e
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x4b,0x13,0x03,0x23,0xac,0x03
	.byte 0x0e
	.ascii "IsList\0"
	.byte 0x00,0x00,0x4b,0x2e,0x03,0x23,0xb0,0x03
	.byte 0x0e
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x4b,0x49,0x03,0x23,0xb4,0x03
	.byte 0x0e
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x4b,0x6f,0x03,0x23,0xb8,0x03
	.byte 0x0e
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x4b,0x9f,0x03,0x23,0xbc,0x03
	.byte 0x0e
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x4b,0xbb,0x03,0x23,0xc0,0x03
	.byte 0x0e
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x4b,0xd2,0x03,0x23,0xc4,0x03
	.byte 0x0e
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x4b,0xe9,0x03,0x23,0xc8,0x03
	.byte 0x0e
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x4b,0xfb,0x03,0x23,0xcc,0x03
	.byte 0x0e
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x4c,0x1c,0x03,0x23,0xd0,0x03
	.byte 0x0e
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x4c,0x33,0x03,0x23,0xd4,0x03
	.byte 0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x4c,0x4a,0x03,0x23,0xd8,0x03
	.byte 0x0e
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x4c,0x89,0x03,0x23,0xdc,0x03
	.byte 0x0e
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x4c,0xdc,0x03,0x23,0xe0,0x03
	.byte 0x0e
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x4c,0xfd,0x03,0x23,0xe4,0x03
	.byte 0x0e
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x4d,0x2d,0x03,0x23,0xe8,0x03
	.byte 0x0e
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x4d,0x58,0x03,0x23,0xec,0x03
	.byte 0x0e
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x4d,0x6f,0x03,0x23,0xf0,0x03
	.byte 0x0e
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x4d,0x90,0x03,0x23,0xf4,0x03
	.byte 0x0e
	.ascii "NewList\0"
	.byte 0x00,0x00,0x4d,0xac,0x03,0x23,0xf8,0x03
	.byte 0x0e
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x4d,0xcd,0x03,0x23,0xfc,0x03
	.byte 0x0e
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x4d,0xee,0x03,0x23,0x80,0x04
	.byte 0x0e
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x4e,0x19,0x03,0x23,0x84,0x04
	.byte 0x0e
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x4e,0x49,0x03,0x23,0x88,0x04
	.byte 0x0e
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x4e,0x60,0x03,0x23,0x8c,0x04
	.byte 0x0e
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x4e,0x8b,0x03,0x23,0x90,0x04
	.byte 0x0e
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x4e,0xa7,0x03,0x23,0x94,0x04
	.byte 0x0e
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x4e,0xc3,0x03,0x23,0x98,0x04
	.byte 0x0e
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x4e,0xdf,0x03,0x23,0x9c,0x04
	.byte 0x0e
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x4f,0x05,0x03,0x23,0xa0,0x04
	.byte 0x0e
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x4f,0x1c,0x03,0x23,0xa4,0x04
	.byte 0x0e
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x4f,0x38,0x03,0x23,0xa8,0x04
	.byte 0x0e
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x4f,0x54,0x03,0x23,0xac,0x04
	.byte 0x0e
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x4f,0x75,0x03,0x23,0xb0,0x04
	.byte 0x0e
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x4f,0x87,0x03,0x23,0xb4,0x04
	.byte 0x0e
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x4f,0x99,0x03,0x23,0xb8,0x04
	.byte 0x0e
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x4f,0xab,0x03,0x23,0xbc,0x04
	.byte 0x0e
	.ascii "PopName\0"
	.byte 0x00,0x00,0x4f,0xbd,0x03,0x23,0xc0,0x04
	.byte 0x0e
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x4f,0xd4,0x03,0x23,0xc4,0x04
	.byte 0x0e
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x4f,0xeb,0x03,0x23,0xc8,0x04
	.byte 0x0e
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x4f,0xfd,0x03,0x23,0xcc,0x04
	.byte 0x0e
	.ascii "PushName\0"
	.byte 0x00,0x00,0x50,0x14,0x03,0x23,0xd0,0x04
	.byte 0x0e
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x50,0x3a,0x03,0x23,0xd4,0x04
	.byte 0x0e
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x50,0x51,0x03,0x23,0xd8,0x04
	.byte 0x0e
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x50,0x86,0x03,0x23,0xdc,0x04
	.byte 0x0e
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x50,0xac,0x03,0x23,0xe0,0x04
	.byte 0x0e
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x50,0xc7,0x03,0x23,0xe4,0x04
	.byte 0x0e
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x50,0xed,0x03,0x23,0xe8,0x04
	.byte 0x0e
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x51,0x0e,0x03,0x23,0xec,0x04
	.byte 0x0e
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x51,0x34,0x03,0x23,0xf0,0x04
	.byte 0x0e
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x51,0x50,0x03,0x23,0xf4,0x04
	.byte 0x0e
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x51,0x67,0x03,0x23,0xf8,0x04
	.byte 0x0e
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x51,0x88,0x03,0x23,0xfc,0x04
	.byte 0x0e
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x51,0x9f,0x03,0x23,0x80,0x05
	.byte 0x0e
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x51,0xc0,0x03,0x23,0x84,0x05
	.byte 0x0e
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x51,0xdc,0x03,0x23,0x88,0x05
	.byte 0x0e
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x52,0x02,0x03,0x23,0x8c,0x05
	.byte 0x0e
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x52,0x32,0x03,0x23,0x90,0x05
	.byte 0x0e
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x52,0x5d,0x03,0x23,0x94,0x05
	.byte 0x0e
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x52,0x88,0x03,0x23,0x98,0x05
	.byte 0x0e
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x52,0xc2,0x03,0x23,0x9c,0x05
	.byte 0x0e
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x53,0x01,0x03,0x23,0xa0,0x05
	.byte 0x0e
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x53,0x36,0x03,0x23,0xa4,0x05
	.byte 0x0e
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x53,0x75,0x03,0x23,0xa8,0x05
	.byte 0x0e
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x53,0xb9,0x03,0x23,0xac,0x05
	.byte 0x0e
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x54,0x02,0x03,0x23,0xb0,0x05
	.byte 0x0e
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x54,0x2d,0x03,0x23,0xb4,0x05
	.byte 0x0e
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x54,0x4e,0x03,0x23,0xb8,0x05
	.byte 0x0e
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x54,0x6a,0x03,0x23,0xbc,0x05
	.byte 0x0e
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x54,0x8b,0x03,0x23,0xc0,0x05
	.byte 0x0e
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x54,0xb1,0x03,0x23,0xc4,0x05
	.byte 0x0e
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x54,0xd2,0x03,0x23,0xc8,0x05
	.byte 0x0e
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x55,0x02,0x03,0x23,0xcc,0x05
	.byte 0x0e
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x55,0x28,0x03,0x23,0xd0,0x05
	.byte 0x0e
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x55,0x4e,0x03,0x23,0xd4,0x05
	.byte 0x0e
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x55,0x60,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0d
	.ascii "gl_visual\0"
	.byte 0x4c,0x02,0x00,0x00,0x65,0xb1,0x0e
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x01,0x0e
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x04,0x0e
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x08,0x0e
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x0c,0x0e
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x10,0x0e
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x14,0x0e
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x20,0x0e
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x24,0x0e
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x28,0x0e
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x2c,0x0e
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x30,0x0e
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x34,0x0e
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x38,0x0e
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x3c,0x0e
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x40,0x0e
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x44,0x0e
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x48,0x0e
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x49,0x00
	.byte 0x06,0x00,0x00,0x64,0x09
	.ascii "GLvisual\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xb1,0x06,0x00
	.byte 0x00,0x48,0x36
	.ascii "GLdepth\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xc5,0x06,0x00
	.byte 0x00,0x31,0x77
	.ascii "GLstencil\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xd8,0x05
	.ascii "short\0"
	.byte 0x05,0x02,0x06,0x00,0x00,0x65,0xed
	.ascii "GLaccum\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xf6,0x0d
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x02,0x00,0x00,0x66,0xe0,0x0e
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xc0,0x02,0x23,0x00,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x08,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x65,0xd3,0x02,0x23,0x0c,0x0e
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x65,0xe8,0x02,0x23,0x10,0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x66,0x04,0x02,0x23,0x14,0x0e
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0x96,0x02,0x23,0x18,0x0e
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0x96,0x02,0x23,0x1c,0x0e
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0x96,0x02,0x23,0x20,0x0e
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x24,0x0e
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x28,0x0e
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x2c,0x0e
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x30,0x00
	.byte 0x06,0x00,0x00,0x66,0x09
	.ascii "GLframebuffer\0"
	.byte 0x02,0x08,0x00,0x00,0x66,0xe0,0x05
	.ascii "char\0"
	.byte 0x06,0x01,0x12,0x00,0x00,0x66,0xf9,0x08
	.byte 0x00,0x00,0x67,0x01,0x16,0x01,0x00,0x00
	.byte 0x67,0x06,0x01,0x08,0x00,0x00,0x67,0x0b
	.byte 0x13,0x01,0x01,0x00,0x00,0x67,0x24,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x00,0x08,0x00,0x00
	.byte 0x67,0x17,0x13,0x01,0x01,0x00,0x00,0x67
	.byte 0x3b,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x67
	.byte 0x29,0x13,0x01,0x01,0x00,0x00,0x67,0x61
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x31,0x77,0x14,0x00,0x00,0x31,0x77,0x14
	.byte 0x00,0x00,0x31,0x77,0x14,0x00,0x00,0x31
	.byte 0x77,0x00,0x08,0x00,0x00,0x67,0x40,0x13
	.byte 0x01,0x01,0x00,0x00,0x67,0x8c,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x31,0x77
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x00,0x08,0x00,0x00
	.byte 0x67,0x66,0x13,0x01,0x01,0x00,0x00,0x67
	.byte 0xa3,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x67
	.byte 0x91,0x13,0x01,0x01,0x00,0x00,0x67,0xc9
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x31,0x77,0x14,0x00,0x00,0x31,0x77,0x14
	.byte 0x00,0x00,0x31,0x77,0x14,0x00,0x00,0x31
	.byte 0x77,0x00,0x08,0x00,0x00,0x67,0xa8,0x15
	.byte 0x01,0x00,0x00,0x31,0x77,0x01,0x00,0x00
	.byte 0x67,0xe4,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0xce,0x00,0x08,0x00,0x00
	.byte 0x67,0xce,0x13,0x01,0x01,0x00,0x00,0x68
	.byte 0x00,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x45,0xde,0x14,0x00,0x00,0x45,0xde
	.byte 0x00,0x08,0x00,0x00,0x67,0xe9,0x12,0x00
	.byte 0x00,0x31,0x77,0x08,0x00,0x00,0x68,0x05
	.byte 0x12,0x00,0x00,0x31,0x77,0x08,0x00,0x00
	.byte 0x68,0x0f,0x12,0x00,0x00,0x31,0x77,0x08
	.byte 0x00,0x00,0x68,0x19,0x12,0x00,0x00,0x31
	.byte 0x77,0x08,0x00,0x00,0x68,0x23,0x12,0x00
	.byte 0x00,0x31,0x77,0x08,0x00,0x00,0x68,0x2d
	.byte 0x13,0x01,0x01,0x00,0x00,0x68,0x6c,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x85,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x68,0x0a
	.byte 0x14,0x00,0x00,0x68,0x14,0x14,0x00,0x00
	.byte 0x68,0x1e,0x14,0x00,0x00,0x68,0x28,0x14
	.byte 0x00,0x00,0x68,0x32,0x00,0x08,0x00,0x00
	.byte 0x68,0x37,0x12,0x00,0x00,0x31,0x77,0x08
	.byte 0x00,0x00,0x68,0x71,0x13,0x01,0x01,0x00
	.byte 0x00,0x68,0x9c,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x85,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x68,0x76,0x00,0x08,0x00,0x00
	.byte 0x68,0x7b,0x12,0x00,0x00,0x01,0x61,0x08
	.byte 0x00,0x00,0x68,0xa1,0x12,0x00,0x00,0x01
	.byte 0x61,0x08,0x00,0x00,0x68,0xab,0x12,0x00
	.byte 0x00,0x31,0x77,0x08,0x00,0x00,0x68,0xb5
	.byte 0x12,0x00,0x00,0x31,0x77,0x08,0x00,0x00
	.byte 0x68,0xbf,0x12,0x00,0x00,0x31,0x77,0x08
	.byte 0x00,0x00,0x68,0xc9,0x12,0x00,0x00,0x31
	.byte 0x77,0x08,0x00,0x00,0x68,0xd3,0x12,0x00
	.byte 0x00,0x31,0x77,0x08,0x00,0x00,0x68,0xdd
	.byte 0x13,0x01,0x01,0x00,0x00,0x69,0x1c,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x85,0x14,0x00,0x00,0x68,0xa6,0x14,0x00
	.byte 0x00,0x68,0xb0,0x14,0x00,0x00,0x68,0xba
	.byte 0x14,0x00,0x00,0x68,0xc4,0x14,0x00,0x00
	.byte 0x68,0xce,0x14,0x00,0x00,0x68,0xd8,0x14
	.byte 0x00,0x00,0x68,0xe2,0x00,0x08,0x00,0x00
	.byte 0x68,0xe7,0x12,0x00,0x00,0x01,0x61,0x08
	.byte 0x00,0x00,0x69,0x21,0x12,0x00,0x00,0x01
	.byte 0x61,0x08,0x00,0x00,0x69,0x2b,0x12,0x00
	.byte 0x00,0x31,0x77,0x08,0x00,0x00,0x69,0x35
	.byte 0x13,0x01,0x01,0x00,0x00,0x69,0x60,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x85,0x14,0x00,0x00,0x69,0x26,0x14,0x00
	.byte 0x00,0x69,0x30,0x14,0x00,0x00,0x69,0x3a
	.byte 0x00,0x08,0x00,0x00,0x69,0x3f,0x12,0x00
	.byte 0x00,0x01,0x85,0x08,0x00,0x00,0x69,0x65
	.byte 0x12,0x00,0x00,0x31,0x77,0x08,0x00,0x00
	.byte 0x69,0x6f,0x13,0x01,0x01,0x00,0x00,0x69
	.byte 0x9f,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x69,0x6a,0x14,0x00,0x00,0x69,0x74,0x00
	.byte 0x08,0x00,0x00,0x69,0x79,0x12,0x00,0x00
	.byte 0x31,0x77,0x08,0x00,0x00,0x69,0xa4,0x13
	.byte 0x01,0x01,0x00,0x00,0x69,0xcf,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x85
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x69,0xa9,0x00
	.byte 0x08,0x00,0x00,0x69,0xae,0x12,0x00,0x00
	.byte 0x01,0x61,0x08,0x00,0x00,0x69,0xd4,0x12
	.byte 0x00,0x00,0x01,0x61,0x08,0x00,0x00,0x69
	.byte 0xde,0x12,0x00,0x00,0x01,0x85,0x08,0x00
	.byte 0x00,0x69,0xe8,0x12,0x00,0x00,0x31,0x77
	.byte 0x08,0x00,0x00,0x69,0xf2,0x13,0x01,0x01
	.byte 0x00,0x00,0x6a,0x22,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x85,0x14,0x00
	.byte 0x00,0x69,0xd9,0x14,0x00,0x00,0x69,0xe3
	.byte 0x14,0x00,0x00,0x69,0xed,0x14,0x00,0x00
	.byte 0x69,0xf7,0x00,0x08,0x00,0x00,0x69,0xfc
	.byte 0x12,0x00,0x00,0x01,0x61,0x08,0x00,0x00
	.byte 0x6a,0x27,0x12,0x00,0x00,0x01,0x61,0x08
	.byte 0x00,0x00,0x6a,0x31,0x12,0x00,0x00,0x31
	.byte 0x77,0x08,0x00,0x00,0x6a,0x3b,0x13,0x01
	.byte 0x01,0x00,0x00,0x6a,0x66,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x85,0x14
	.byte 0x00,0x00,0x6a,0x2c,0x14,0x00,0x00,0x6a
	.byte 0x36,0x14,0x00,0x00,0x6a,0x40,0x00,0x08
	.byte 0x00,0x00,0x6a,0x45,0x13,0x01,0x01,0x00
	.byte 0x00,0x6a,0x8c,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x85,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x45,0xde,0x00,0x08,0x00,0x00
	.byte 0x6a,0x6b,0x13,0x01,0x01,0x00,0x00,0x6a
	.byte 0xc1,0x14,0x00,0x00,0x3c,0x7a,0x14,0x00
	.byte 0x00,0x01,0x85,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x34,0xab,0x14,0x00,0x00,0x34,0xab,0x14
	.byte 0x00,0x00,0x34,0xab,0x14,0x00,0x00,0x34
	.byte 0xab,0x00,0x08,0x00,0x00,0x6a,0x91,0x12
	.byte 0x00,0x00,0x01,0x61,0x08,0x00,0x00,0x6a
	.byte 0xc6,0x12,0x00,0x00,0x01,0x61,0x08,0x00
	.byte 0x00,0x6a,0xd0,0x12,0x00,0x00,0x31,0x77
	.byte 0x08,0x00,0x00,0x6a,0xda,0x13,0x01,0x01
	.byte 0x00,0x00,0x6b,0x0a,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x85,0x14,0x00
	.byte 0x00,0x6a,0xcb,0x14,0x00,0x00,0x6a,0xd5
	.byte 0x14,0x00,0x00,0x45,0xde,0x14,0x00,0x00
	.byte 0x6a,0xdf,0x00,0x08,0x00,0x00,0x6a,0xe4
	.byte 0x12,0x00,0x00,0x01,0x61,0x08,0x00,0x00
	.byte 0x6b,0x0f,0x12,0x00,0x00,0x01,0x61,0x08
	.byte 0x00,0x00,0x6b,0x19,0x12,0x00,0x00,0x31
	.byte 0x77,0x08,0x00,0x00,0x6b,0x23,0x13,0x01
	.byte 0x01,0x00,0x00,0x6b,0x62,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0x85,0x14
	.byte 0x00,0x00,0x6b,0x14,0x14,0x00,0x00,0x6b
	.byte 0x1e,0x14,0x00,0x00,0x34,0xab,0x14,0x00
	.byte 0x00,0x34,0xab,0x14,0x00,0x00,0x34,0xab
	.byte 0x14,0x00,0x00,0x34,0xab,0x14,0x00,0x00
	.byte 0x6b,0x28,0x00,0x08,0x00,0x00,0x6b,0x2d
	.byte 0x13,0x01,0x01,0x00,0x00,0x6b,0x74,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x00,0x08,0x00,0x00
	.byte 0x6b,0x67,0x13,0x01,0x01,0x00,0x00,0x6b
	.byte 0x86,0x14,0x00,0x00,0x3c,0x7a,0x00,0x08
	.byte 0x00,0x00,0x6b,0x79,0x15,0x01,0x00,0x00
	.byte 0x31,0x77,0x01,0x00,0x00,0x6b,0xa1,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x01
	.byte 0x85,0x00,0x08,0x00,0x00,0x6b,0x8b,0x15
	.byte 0x01,0x00,0x00,0x31,0x77,0x01,0x00,0x00
	.byte 0x6b,0xcb,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x31,0x77,0x14,0x00,0x00,0x31
	.byte 0x77,0x14,0x00,0x00,0x31,0x77,0x14,0x00
	.byte 0x00,0x31,0x77,0x00,0x08,0x00,0x00,0x6b
	.byte 0xa6,0x15,0x01,0x00,0x00,0x31,0x77,0x01
	.byte 0x00,0x00,0x6b,0xe6,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x00,0x08
	.byte 0x00,0x00,0x6b,0xd0,0x13,0x01,0x01,0x00
	.byte 0x00,0x6b,0xfd,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x31,0x77,0x00,0x08,0x00
	.byte 0x00,0x6b,0xeb,0x13,0x01,0x01,0x00,0x00
	.byte 0x6c,0x0f,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x6c,0x02,0x13,0x01,0x01
	.byte 0x00,0x00,0x6c,0x2b,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x9e,0x14,0x00
	.byte 0x00,0x01,0x9e,0x00,0x08,0x00,0x00,0x6c
	.byte 0x14,0x13,0x01,0x01,0x00,0x00,0x6c,0x3d
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x00,0x08,0x00
	.byte 0x00,0x6c,0x30,0x13,0x01,0x01,0x00,0x00
	.byte 0x6c,0x4f,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x6c,0x42,0x12,0x00,0x00
	.byte 0x48,0x36,0x08,0x00,0x00,0x6c,0x54,0x15
	.byte 0x01,0x00,0x00,0x01,0x85,0x01,0x00,0x00
	.byte 0x6c,0x88,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x85,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x01,0x61,0x14,0x00
	.byte 0x00,0x6c,0x59,0x14,0x00,0x00,0x34,0xab
	.byte 0x00,0x08,0x00,0x00,0x6c,0x5e,0x12,0x00
	.byte 0x00,0x01,0x61,0x08,0x00,0x00,0x6c,0x8d
	.byte 0x12,0x00,0x00,0x01,0x61,0x08,0x00,0x00
	.byte 0x6c,0x97,0x12,0x00,0x00,0x48,0x36,0x08
	.byte 0x00,0x00,0x6c,0xa1,0x13,0x01,0x01,0x00
	.byte 0x00,0x6c,0xd1,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0x85,0x14,0x00,0x00
	.byte 0x6c,0x92,0x14,0x00,0x00,0x6c,0x9c,0x14
	.byte 0x00,0x00,0x6c,0xa6,0x14,0x00,0x00,0x34
	.byte 0xab,0x00,0x08,0x00,0x00,0x6c,0xab,0x13
	.byte 0x01,0x01,0x00,0x00,0x6c,0xf7,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x85
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x45,0x0c,0x00
	.byte 0x08,0x00,0x00,0x6c,0xd6,0x13,0x01,0x01
	.byte 0x00,0x00,0x6d,0x1d,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x85,0x14,0x00
	.byte 0x00,0x01,0x61,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x48,0x48,0x00,0x08,0x00
	.byte 0x00,0x6c,0xfc,0x13,0x01,0x01,0x00,0x00
	.byte 0x6d,0x39,0x14,0x00,0x00,0x3c,0x7a,0x14
	.byte 0x00,0x00,0x01,0x85,0x14,0x00,0x00,0x01
	.byte 0x85,0x00,0x08,0x00,0x00,0x6d,0x22,0x06
	.byte 0x00,0x00,0x6d,0x39
	.ascii "points_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0x6c
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x14,0x00,0x00,0x01,0x85,0x14
	.byte 0x00,0x00,0x01,0x85,0x00,0x08,0x00,0x00
	.byte 0x6d,0x50,0x06,0x00,0x00,0x6d,0x6c
	.ascii "line_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0xa2
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x14,0x00,0x00,0x01,0x85,0x14
	.byte 0x00,0x00,0x01,0x85,0x14,0x00,0x00,0x01
	.byte 0x85,0x00,0x08,0x00,0x00,0x6d,0x81,0x06
	.byte 0x00,0x00,0x6d,0xa2
	.ascii "triangle_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0xe1
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x85,0x14,0x00,0x00,0x01,0x85,0x14
	.byte 0x00,0x00,0x01,0x85,0x14,0x00,0x00,0x01
	.byte 0x85,0x14,0x00,0x00,0x01,0x85,0x00,0x08
	.byte 0x00,0x00,0x6d,0xbb,0x06,0x00,0x00,0x6d
	.byte 0xe1
	.ascii "quad_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6e,0x17
	.byte 0x14,0x00,0x00,0x3c,0x7a,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x00,0x08,0x00,0x00,0x6d,0xf6,0x06
	.byte 0x00,0x00,0x6e,0x17
	.ascii "rect_func\0"
	.byte 0x02,0x12,0x00,0x00,0x31,0x9b,0x08,0x00
	.byte 0x00,0x6e,0x2c,0x15,0x01,0x00,0x00,0x31
	.byte 0x77,0x01,0x00,0x00,0x6e,0x6f,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x61,0x14,0x00,0x00,0x01,0x61,0x14
	.byte 0x00,0x00,0x01,0xce,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x31,0x77,0x14,0x00
	.byte 0x00,0x6e,0x31,0x00,0x08,0x00,0x00,0x6e
	.byte 0x36,0x12,0x00,0x00,0x3d,0x42,0x08,0x00
	.byte 0x00,0x6e,0x74,0x15,0x01,0x00,0x00,0x31
	.byte 0x77,0x01,0x00,0x00,0x6e,0xb2,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x01,0x61
	.byte 0x14,0x00,0x00,0x01,0x61,0x14,0x00,0x00
	.byte 0x01,0x9e,0x14,0x00,0x00,0x01,0x9e,0x14
	.byte 0x00,0x00,0x01,0x9e,0x14,0x00,0x00,0x01
	.byte 0x9e,0x14,0x00,0x00,0x6e,0x79,0x00,0x08
	.byte 0x00,0x00,0x6e,0x7e,0x13,0x01,0x01,0x00
	.byte 0x00,0x6e,0xc9,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x00,0x08,0x00
	.byte 0x00,0x6e,0xb7,0x13,0x01,0x01,0x00,0x00
	.byte 0x6e,0xdb,0x14,0x00,0x00,0x3c,0x7a,0x00
	.byte 0x08,0x00,0x00,0x6e,0xce,0x13,0x01,0x01
	.byte 0x00,0x00,0x6e,0xf7,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0x85,0x14,0x00
	.byte 0x00,0x01,0x85,0x00,0x08,0x00,0x00,0x6e
	.byte 0xe0,0x15,0x01,0x00,0x00,0x31,0x77,0x01
	.byte 0x00,0x00,0x6f,0x12,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x31,0x77,0x00,0x08
	.byte 0x00,0x00,0x6e,0xfc,0x12,0x00,0x00,0x01
	.byte 0x9e,0x08,0x00,0x00,0x6f,0x17,0x13,0x01
	.byte 0x01,0x00,0x00,0x6f,0x38,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x6f,0x1c,0x00,0x08,0x00,0x00
	.byte 0x6f,0x21,0x12,0x00,0x00,0x31,0xa8,0x08
	.byte 0x00,0x00,0x6f,0x3d,0x13,0x01,0x01,0x00
	.byte 0x00,0x6f,0x6d,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x35,0x07,0x14
	.byte 0x00,0x00,0x01,0x61,0x14,0x00,0x00,0x01
	.byte 0x61,0x14,0x00,0x00,0x6f,0x42,0x00,0x08
	.byte 0x00,0x00,0x6f,0x47,0x12,0x00,0x00,0x01
	.byte 0x9e,0x08,0x00,0x00,0x6f,0x72,0x13,0x01
	.byte 0x01,0x00,0x00,0x6f,0x9d,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x01,0xce,0x14
	.byte 0x00,0x00,0x35,0x07,0x14,0x00,0x00,0x01
	.byte 0xce,0x14,0x00,0x00,0x6f,0x77,0x00,0x08
	.byte 0x00,0x00,0x6f,0x7c,0x13,0x01,0x01,0x00
	.byte 0x00,0x6f,0xb9,0x14,0x00,0x00,0x3c,0x7a
	.byte 0x14,0x00,0x00,0x01,0xce,0x14,0x00,0x00
	.byte 0x35,0x07,0x00,0x08,0x00,0x00,0x6f,0xa2
	.byte 0x13,0x01,0x01,0x00,0x00,0x6f,0xd0,0x14
	.byte 0x00,0x00,0x3c,0x7a,0x14,0x00,0x00,0x35
	.byte 0x07,0x00,0x08,0x00,0x00,0x6f,0xbe,0x13
	.byte 0x01,0x01,0x00,0x00,0x6f,0xe7,0x14,0x00
	.byte 0x00,0x3c,0x7a,0x14,0x00,0x00,0x35,0x07
	.byte 0x00,0x08,0x00,0x00,0x6f,0xd5,0x13,0x01
	.byte 0x01,0x00,0x00,0x6f,0xfe,0x14,0x00,0x00
	.byte 0x3c,0x7a,0x14,0x00,0x00,0x31,0x77,0x00
	.byte 0x08,0x00,0x00,0x6f,0xec,0x0d
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x74,0x6b,0x0e
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x67,0x12,0x02,0x23,0x00,0x0e
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x67,0x24,0x02,0x23,0x04,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x67,0x3b,0x02,0x23,0x08,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x67,0x61,0x02,0x23,0x0c,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x67,0x8c,0x02,0x23,0x10,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x67,0xa3,0x02,0x23,0x14,0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x67,0xc9,0x02,0x23,0x18,0x0e
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x67,0xe4,0x02,0x23,0x1c,0x0e
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x68,0x00,0x02,0x23,0x20,0x0e
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x68,0x6c,0x02,0x23,0x24,0x0e
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x68,0x9c,0x02,0x23,0x28,0x0e
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x69,0x1c,0x02,0x23,0x2c,0x0e
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x69,0x60,0x02,0x23,0x30,0x0e
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x69,0x9f,0x02,0x23,0x34,0x0e
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x69,0xcf,0x02,0x23,0x38,0x0e
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x6a,0x22,0x02,0x23,0x3c,0x0e
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x6a,0x66,0x02,0x23,0x40,0x0e
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x6a,0x8c,0x02,0x23,0x44,0x0e
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x6a,0xc1,0x02,0x23,0x48,0x0e
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x6b,0x0a,0x02,0x23,0x4c,0x0e
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x6b,0x62,0x02,0x23,0x50,0x0e
	.ascii "Finish\0"
	.byte 0x00,0x00,0x6b,0x74,0x02,0x23,0x54,0x0e
	.ascii "Flush\0"
	.byte 0x00,0x00,0x6b,0x86,0x02,0x23,0x58,0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x6b,0xa1,0x02,0x23,0x5c,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x6b,0xcb,0x02,0x23,0x60,0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x6b,0xe6,0x02,0x23,0x64,0x0e
	.ascii "Dither\0"
	.byte 0x00,0x00,0x6b,0xfd,0x02,0x23,0x68,0x0e
	.ascii "Error\0"
	.byte 0x00,0x00,0x6c,0x0f,0x02,0x23,0x6c,0x0e
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x6c,0x2b,0x02,0x23,0x70,0x0e
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x3d,0x02,0x23,0x74,0x0e
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x4f,0x02,0x23,0x78,0x0e
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x6c,0x88,0x02,0x23,0x7c,0x0e
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x6c,0xd1,0x03,0x23,0x80,0x01
	.byte 0x0e
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x6c,0xf7,0x03,0x23,0x84,0x01
	.byte 0x0e
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x6d,0x1d,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x3e,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x71,0x03,0x23,0x90,0x01
	.byte 0x0e
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0xa7,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xe6,0x03,0x23,0x98,0x01
	.byte 0x0e
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6e,0x1c,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x6e,0x6f,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x6e,0xb2,0x03,0x23,0xa4,0x01
	.byte 0x0e
	.ascii "Begin\0"
	.byte 0x00,0x00,0x6e,0xc9,0x03,0x23,0xa8,0x01
	.byte 0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x6e,0xdb,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x6e,0xf7,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x6f,0x12,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x6f,0x38,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x6f,0x6d,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x6f,0x9d,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x6f,0xb9,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x6f,0xd0,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xe7,0x03,0x23,0xcc,0x01
	.byte 0x0e
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xfe,0x03,0x23,0xd0,0x01
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x40,0x00
	.byte 0x00,0x74,0x7c,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x0f,0x00,0x09,0x00,0x00,0x01,0xa7,0x40
	.byte 0x00,0x00,0x74,0x8d,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x0f,0x00,0x09,0x00,0x00,0x01,0x9e
	.byte 0x40,0x00,0x00,0x74,0x9e,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x0f,0x00,0x0f,0x00,0x00,0x74
	.byte 0x8d,0x08,0x00,0x00,0x00,0x74,0xb0,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x1f,0x00,0x09,0x00
	.byte 0x00,0x01,0xa7,0x40,0x00,0x00,0x74,0xc1
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x0f,0x00,0x09
	.byte 0x00,0x00,0x01,0x9e,0x40,0x00,0x00,0x74
	.byte 0xd2,0x0a,0x00,0x00,0x01,0xb5,0x0f,0x00
	.byte 0x0f,0x00,0x00,0x74,0xc1,0x08,0x00,0x00
	.byte 0x00,0x74,0xe4,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x1f,0x00,0x09,0x00,0x00,0x01,0x9e,0x08
	.byte 0x00,0x00,0x74,0xf5,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x01,0x00,0x0f,0x00,0x00,0x74,0xe4
	.byte 0x01,0x00,0x00,0x00,0x75,0x07,0x0a,0x00
	.byte 0x00,0x01,0xb5,0x1f,0x00,0x09,0x00,0x00
	.byte 0x01,0xa7,0x40,0x00,0x00,0x75,0x18,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x0f,0x00,0x09,0x00
	.byte 0x00,0x01,0x9e,0x40,0x00,0x00,0x75,0x29
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x0f,0x00,0x0f
	.byte 0x00,0x00,0x75,0x18,0x02,0x80,0x00,0x00
	.byte 0x75,0x3b,0x0a,0x00,0x00,0x01,0xb5,0x09
	.byte 0x00,0x06,0x00,0x00,0x01,0x85
	.ascii "GLbitfield\0"
	.byte 0x03,0x08,0x00,0x00,0x75,0x51,0x0d
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x02,0x00,0x00,0x75,0x8f,0x0e
	.ascii "kind\0"
	.byte 0x00,0x00,0x75,0x3b,0x02,0x23,0x00,0x0e
	.ascii "data\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x04,0x0e
	.ascii "next\0"
	.byte 0x00,0x00,0x75,0x4c,0x02,0x23,0x08,0x00
	.byte 0x09,0x00,0x00,0x75,0x4c,0x40,0x00,0x00
	.byte 0x75,0xa0,0x0a,0x00,0x00,0x01,0xb5,0x0f
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x75,0xb1,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x0d
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x02,0x00,0x00,0x75,0xdc,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xa0,0x02,0x23,0x00,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x75,0xed,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x75,0xfe,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x0d
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x02,0x00,0x00,0x77,0xad,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x00,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xdc,0x02,0x23,0x04,0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x14,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x18,0x0e
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x1c,0x0e
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x20,0x0e
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x24,0x0e
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x28,0x0e
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x2c,0x0e
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0x88,0x02,0x23,0x30,0x0e
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x31,0x0e
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x34,0x0e
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x38,0x0e
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x3c,0x0e
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x75,0xed,0x02,0x23,0x40,0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x50,0x0e
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x54,0x0e
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x55,0x0e
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x56,0x0e
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x57,0x00
	.byte 0x09,0x00,0x00,0x31,0x88,0x04,0x00,0x00
	.byte 0x77,0xbe,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x0c,0x00
	.byte 0x00,0x77,0xcf,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x02,0x00,0x09,0x00,0x00,0x01,0xa7,0x10
	.byte 0x00,0x00,0x77,0xe0,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x09,0x00,0x00,0x01,0xa7
	.byte 0x10,0x00,0x00,0x77,0xf1,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0xa7,0x10,0x00,0x00,0x78,0x02,0x0a,0x00
	.byte 0x00,0x01,0xb5,0x03,0x00,0x09,0x00,0x00
	.byte 0x01,0xa7,0x10,0x00,0x00,0x78,0x13,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x03,0x00,0x0d
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x02,0x00,0x00,0x78,0xfd,0x0e
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x77,0xad,0x02,0x23,0x00,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x04,0x0e
	.ascii "Normal\0"
	.byte 0x00,0x00,0x77,0xbe,0x02,0x23,0x08,0x0e
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x77,0xcf,0x02,0x23,0x14,0x0e
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x77,0xe0,0x02,0x23,0x24,0x0e
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x34,0x0e
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x77,0xf1,0x02,0x23,0x38,0x0e
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x48,0x0e
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x78,0x02,0x02,0x23,0x4c,0x0e
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x5c,0x0e
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x5d,0x00
	.byte 0x0d
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x79,0x50,0x0e
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x04,0x0e
	.ascii "Test\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x08,0x0e
	.ascii "Mask\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x09,0x00
	.byte 0x0d
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x02,0x00,0x00,0x7b,0xb5,0x0e
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x01,0x0e
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x02,0x0e
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x03,0x0e
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x04,0x0e
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x05,0x0e
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x06,0x0e
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x07,0x0e
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x08,0x0e
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x09,0x0e
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0a,0x0e
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0b,0x0e
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0c,0x0e
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0d,0x0e
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0e,0x0e
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0f,0x0e
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x10,0x0e
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x11,0x0e
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x12,0x0e
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x14,0x0e
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x20,0x0e
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x24,0x0e
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x28,0x0e
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x2c,0x0e
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x30,0x0e
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x34,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x7b,0xc6,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x0d
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x7c,0x3f,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x7b,0xb5,0x02,0x23,0x04,0x0e
	.ascii "Density\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x14,0x0e
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x20,0x0e
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x24,0x00
	.byte 0x0d
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x7c,0xbd,0x0e
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x08,0x0e
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x0c,0x0e
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x10,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x7c,0xce,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x7c,0xdf,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0xa7,0x10
	.byte 0x00,0x00,0x7c,0xf0,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x09,0x00,0x00,0x01,0xa7
	.byte 0x10,0x00,0x00,0x7d,0x01,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0xa7,0x10,0x00,0x00,0x7d,0x12,0x0a,0x00
	.byte 0x00,0x01,0xb5,0x03,0x00,0x11
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x02,0x00,0x00,0x7e,0xd4,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7c,0xbd,0x02,0x23,0x00,0x0e
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7c,0xce,0x02,0x23,0x10,0x0e
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7c,0xdf,0x02,0x23,0x20,0x0e
	.ascii "Position\0"
	.byte 0x00,0x00,0x7c,0xf0,0x02,0x23,0x30,0x0e
	.ascii "Direction\0"
	.byte 0x00,0x00,0x7d,0x01,0x02,0x23,0x40,0x0e
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x50,0x0e
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x54,0x0e
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x58,0x0e
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x5c,0x0e
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x60,0x0e
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x64,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x68,0x0e
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x7e,0xd4,0x02,0x23,0x6c,0x0e
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xd9,0x02,0x23,0x70,0x0e
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xea,0x02,0x23,0x7c,0x0e
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x7e,0xfb,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x7f,0x1d,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x7f,0x41,0x03,0x23,0x94,0x21
	.byte 0x0e
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x7f,0x63,0x03,0x23,0xac,0x21
	.byte 0x0e
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x7f,0x85,0x03,0x23,0xc4,0x21
	.byte 0x0e
	.ascii "dli\0"
	.byte 0x00,0x00,0x01,0xa7,0x03,0x23,0xdc,0x21
	.byte 0x0e
	.ascii "sli\0"
	.byte 0x00,0x00,0x01,0xa7,0x03,0x23,0xe0,0x21
	.byte 0x00,0x08,0x00,0x00,0x7d,0x12,0x09,0x00
	.byte 0x00,0x01,0xa7,0x0c,0x00,0x00,0x7e,0xea
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x02,0x00,0x09
	.byte 0x00,0x00,0x01,0xa7,0x0c,0x00,0x00,0x7e
	.byte 0xfb,0x0a,0x00,0x00,0x01,0xb5,0x02,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x0c,0x00,0x00
	.byte 0x7f,0x0c,0x0a,0x00,0x00,0x01,0xb5,0x02
	.byte 0x00,0x09,0x00,0x00,0x01,0x9e,0x08,0x00
	.byte 0x00,0x7f,0x1d,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x01,0x00,0x0f,0x00,0x00,0x7f,0x0c,0x10
	.byte 0x00,0x00,0x00,0x7f,0x30,0x10,0x00,0x00
	.byte 0x01,0xb5,0x01,0xff,0x00,0x09,0x00,0x00
	.byte 0x01,0x9e,0x0c,0x00,0x00,0x7f,0x41,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x02,0x00,0x09,0x00
	.byte 0x00,0x7f,0x30,0x18
	.byte 0x00,0x00,0x7f,0x52,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x01,0x00,0x09,0x00,0x00,0x01,0x9e
	.byte 0x0c,0x00,0x00,0x7f,0x63,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x02,0x00,0x09,0x00,0x00,0x7f
	.byte 0x52,0x18,0x00,0x00,0x7f,0x74,0x0a,0x00
	.byte 0x00,0x01,0xb5,0x01,0x00,0x09,0x00,0x00
	.byte 0x01,0x9e,0x0c,0x00,0x00,0x7f,0x85,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x02,0x00,0x09,0x00
	.byte 0x00,0x7f,0x74,0x18,0x00,0x00,0x7f,0x96
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x01,0x00,0x0f
	.byte 0x00,0x00,0x7d,0x12,0x87,0x20,0x00,0x00
	.byte 0x7f,0xa8,0x0a,0x00,0x00,0x01,0xb5,0x07
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x7f,0xb9,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x0d
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x02,0x00,0x00,0x80,0x03,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0xa8,0x02,0x23,0x00,0x0e
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x10,0x0e
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x11,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x80,0x14,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x80,0x25,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0xa7,0x10
	.byte 0x00,0x00,0x80,0x36,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x09,0x00,0x00,0x01,0xa7
	.byte 0x10,0x00,0x00,0x80,0x47,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x03,0x00,0x0f,0x00,0x00,0x01
	.byte 0xa7,0x03,0x20,0x00,0x00,0x80,0x5a,0x10
	.byte 0x00,0x00,0x01,0xb5,0x00,0xc7,0x00,0x11
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x02,0x00,0x00,0x81,0x16,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x80,0x03,0x02,0x23,0x00,0x0e
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x80,0x14,0x02,0x23,0x10,0x0e
	.ascii "Specular\0"
	.byte 0x00,0x00,0x80,0x25,0x02,0x23,0x20,0x0e
	.ascii "Emission\0"
	.byte 0x00,0x00,0x80,0x36,0x02,0x23,0x30,0x0e
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x40,0x0e
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x44,0x0e
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x48,0x0e
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x4c,0x0e
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x80,0x47,0x02,0x23,0x50,0x00
	.byte 0x0f,0x00,0x00,0x80,0x5a,0x06,0xe0,0x00
	.byte 0x00,0x81,0x28,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x01,0x00,0x09,0x00,0x00,0x01,0x9e,0x10
	.byte 0x00,0x00,0x81,0x39,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x09,0x00,0x00,0x81,0x28
	.byte 0x20,0x00,0x00,0x81,0x4a,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x01,0x00,0x11
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x02,0x00,0x00,0x82,0x6b,0x0e
	.ascii "Light\0"
	.byte 0x00,0x00,0x7f,0x96,0x02,0x23,0x00,0x0e
	.ascii "Model\0"
	.byte 0x00,0x00,0x7f,0xb9,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0e
	.ascii "Material\0"
	.byte 0x00,0x00,0x81,0x16,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0e
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x01,0x91,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0e
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x7e,0xd4,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0e
	.ascii "Fast\0"
	.byte 0x00,0x00,0x32,0xda,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0e
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x81,0x39,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x06,0x00,0x00,0x48,0x36
	.ascii "GLushort\0"
	.byte 0x03,0x0d
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x82,0xf3,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x01,0x0e
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x82,0x6b,0x02,0x23,0x02,0x0e
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x08,0x00
	.byte 0x0d
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x02,0x00,0x00,0x83,0x1b,0x0e
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x00,0x00
	.byte 0x0f,0x00,0x00,0x01,0x68,0x04,0x00,0x00
	.byte 0x00,0x83,0x2e,0x10,0x00,0x00,0x01,0xb5
	.byte 0x00,0xff,0x00,0x0f,0x00,0x00,0x01,0x68
	.byte 0x04,0x00,0x00,0x00,0x83,0x41,0x10,0x00
	.byte 0x00,0x01,0xb5,0x00,0xff,0x00,0x0f,0x00
	.byte 0x00,0x01,0xa7,0x04,0x00,0x00,0x00,0x83
	.byte 0x54,0x10,0x00,0x00,0x01,0xb5,0x00,0xff
	.byte 0x00,0x0f,0x00,0x00,0x01,0xa7,0x04,0x00
	.byte 0x00,0x00,0x83,0x67,0x10,0x00,0x00,0x01
	.byte 0xb5,0x00,0xff,0x00,0x0f,0x00,0x00,0x01
	.byte 0xa7,0x04,0x00,0x00,0x00,0x83,0x7a,0x10
	.byte 0x00,0x00,0x01,0xb5,0x00,0xff,0x00,0x0f
	.byte 0x00,0x00,0x01,0xa7,0x04,0x00,0x00,0x00
	.byte 0x83,0x8d,0x10,0x00,0x00,0x01,0xb5,0x00
	.byte 0xff,0x00,0x0f,0x00,0x00,0x01,0xa7,0x04
	.byte 0x00,0x00,0x00,0x83,0xa0,0x10,0x00,0x00
	.byte 0x01,0xb5,0x00,0xff,0x00,0x0f,0x00,0x00
	.byte 0x01,0xa7,0x04,0x00,0x00,0x00,0x83,0xb3
	.byte 0x10,0x00,0x00,0x01,0xb5,0x00,0xff,0x00
	.byte 0x0f,0x00,0x00,0x01,0xa7,0x04,0x00,0x00
	.byte 0x00,0x83,0xc6,0x10,0x00,0x00,0x01,0xb5
	.byte 0x00,0xff,0x00,0x0f,0x00,0x00,0x01,0xa7
	.byte 0x04,0x00,0x00,0x00,0x83,0xd9,0x10,0x00
	.byte 0x00,0x01,0xb5,0x00,0xff,0x00,0x11
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x02,0x00,0x00,0x86,0x98,0x0e
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x04,0x0e
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x08,0x0e
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x0c,0x0e
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x10,0x0e
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x14,0x0e
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x20,0x0e
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x24,0x0e
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x28,0x0e
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x2c,0x0e
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x30,0x0e
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x34,0x0e
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x35,0x0e
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x38,0x0e
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x3c,0x0e
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x40,0x0e
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x44,0x0e
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x48,0x0e
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x4c,0x0e
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x50,0x0e
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x54,0x0e
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x58,0x0e
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x5c,0x0e
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x60,0x0e
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x64,0x0e
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x83,0x1b,0x02,0x23,0x68,0x0e
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x83,0x2e,0x03,0x23,0xe8,0x08
	.byte 0x0e
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x83,0x41,0x03,0x23,0xe8,0x10
	.byte 0x0e
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x83,0x54,0x03,0x23,0xe8,0x18
	.byte 0x0e
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x83,0x67,0x03,0x23,0xe8,0x20
	.byte 0x0e
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x83,0x7a,0x03,0x23,0xe8,0x28
	.byte 0x0e
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x83,0x8d,0x03,0x23,0xe8,0x30
	.byte 0x0e
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x83,0xa0,0x03,0x23,0xe8,0x38
	.byte 0x0e
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x83,0xb3,0x03,0x23,0xe8,0x40
	.byte 0x0e
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x83,0xc6,0x03,0x23,0xe8,0x48
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x0c,0x00
	.byte 0x00,0x86,0xa9,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x02,0x00,0x0d
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x02,0x00,0x00,0x87,0x22,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "Size\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x04,0x0e
	.ascii "Params\0"
	.byte 0x00,0x00,0x86,0x98,0x02,0x23,0x08,0x0e
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x14,0x0e
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x00
	.byte 0x0d
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x88,0x55,0x0e
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x08,0x0e
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0c,0x0e
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x0d,0x0e
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x10,0x0e
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x14,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x18,0x0e
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x19,0x0e
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x20,0x0e
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x24,0x0e
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x25,0x0e
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x26,0x0e
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x27,0x00
	.byte 0x09,0x00,0x00,0x01,0x91,0x80,0x00,0x00
	.byte 0x88,0x66,0x0a,0x00,0x00,0x01,0xb5,0x1f
	.byte 0x00,0x06,0x00,0x00,0x01,0x61
	.ascii "GLsizei\0"
	.byte 0x03,0x0d
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x88,0xcf,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x08,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x0c,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x10,0x00
	.byte 0x0d
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x02,0x00,0x00,0x89,0x7d,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x00,0x0e
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x08,0x0e
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x0c,0x0e
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x10,0x0e
	.ascii "Ref\0"
	.byte 0x00,0x00,0x65,0xd8,0x02,0x23,0x14,0x0e
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x65,0xd8,0x02,0x23,0x15,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x65,0xd8,0x02,0x23,0x16,0x0e
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x65,0xd8,0x02,0x23,0x17,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x89,0x8e,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0xa7,0x10,0x00
	.byte 0x00,0x89,0x9f,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0xa7,0x10
	.byte 0x00,0x00,0x89,0xb0,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x03,0x00,0x09,0x00,0x00,0x01,0xa7
	.byte 0x10,0x00,0x00,0x89,0xc1,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0xa7,0x10,0x00,0x00,0x89,0xd2,0x0a,0x00
	.byte 0x00,0x01,0xb5,0x03,0x00,0x09,0x00,0x00
	.byte 0x01,0xa7,0x10,0x00,0x00,0x89,0xe3,0x0a
	.byte 0x00,0x00,0x01,0xb5,0x03,0x00,0x09,0x00
	.byte 0x00,0x01,0xa7,0x10,0x00,0x00,0x89,0xf4
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x03,0x00,0x09
	.byte 0x00,0x00,0x01,0xa7,0x10,0x00,0x00,0x8a
	.byte 0x05,0x0a,0x00,0x00,0x01,0xb5,0x03,0x00
	.byte 0x09,0x00,0x00,0x01,0xa7,0x10,0x00,0x00
	.byte 0x8a,0x16,0x0a,0x00,0x00,0x01,0xb5,0x03
	.byte 0x00,0x0f,0x00,0x00,0x31,0x88,0x04,0x00
	.byte 0x00,0x00,0x8a,0x29,0x10,0x00,0x00,0x01
	.byte 0xb5,0x03,0xff,0x00,0x11
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x02,0x00,0x00,0x8c,0x58,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x00,0x0e
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x89,0x7d,0x02,0x23,0x08,0x0e
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x18,0x0e
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x1c,0x0e
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x20,0x0e
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x24,0x0e
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x28,0x0e
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x89,0x8e,0x02,0x23,0x2c,0x0e
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x89,0x9f,0x02,0x23,0x3c,0x0e
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x89,0xb0,0x02,0x23,0x4c,0x0e
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x89,0xc1,0x02,0x23,0x5c,0x0e
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x89,0xd2,0x02,0x23,0x6c,0x0e
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x89,0xe3,0x02,0x23,0x7c,0x0e
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x89,0xf4,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x8a,0x05,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "Current\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x35,0x07,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "Palette\0"
	.byte 0x00,0x00,0x8a,0x16,0x03,0x23,0xc9,0x01
	.byte 0x0e
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x91,0x03,0x23,0xcc,0x09
	.byte 0x0e
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x6a,0x03,0x23,0xd0,0x09
	.byte 0x0e
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x6a,0x03,0x23,0xd4,0x09
	.byte 0x00,0x09,0x00,0x00,0x01,0x9e,0x10,0x00
	.byte 0x00,0x8c,0x69,0x0a,0x00,0x00,0x01,0xb5
	.byte 0x03,0x00,0x09,0x00,0x00,0x8c,0x58,0x60
	.byte 0x00,0x00,0x8c,0x7a,0x0a,0x00,0x00,0x01
	.byte 0xb5,0x05,0x00,0x09,0x00,0x00,0x32,0xda
	.byte 0x06,0x00,0x00,0x8c,0x8b,0x0a,0x00,0x00
	.byte 0x01,0xb5,0x05,0x00,0x0d
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x02,0x00,0x00,0x8d,0x05,0x0e
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x8c,0x69,0x02,0x23,0x04,0x0e
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x8c,0x7a,0x02,0x23,0x64,0x0e
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x6a,0x0e
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x6b,0x00
	.byte 0x0d
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x02,0x00,0x00,0x8d,0xac,0x0e
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x08,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x0c,0x0e
	.ascii "Near\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x10,0x0e
	.ascii "Far\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x14,0x0e
	.ascii "Sx\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x18,0x0e
	.ascii "Sy\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x1c,0x0e
	.ascii "Sz\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x20,0x0e
	.ascii "Tx\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x24,0x0e
	.ascii "Ty\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x28,0x0e
	.ascii "Tz\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x2c,0x00
	.byte 0x09,0x00,0x00,0x75,0x4c,0x40,0x00,0x00
	.byte 0x8d,0xbd,0x0a,0x00,0x00,0x01,0xb5,0x0f
	.byte 0x00,0x08,0x00,0x00,0x32,0xda,0x0d
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x02,0x00,0x00,0x90,0x6d,0x0e
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x04,0x0e
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x08,0x0e
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x0c,0x0e
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x10,0x0e
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x14,0x0e
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x18,0x0e
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x1c,0x0e
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x20,0x0e
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x24,0x0e
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x28,0x0e
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x2c,0x0e
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x30,0x0e
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x34,0x0e
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x38,0x0e
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x3c,0x0e
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x40,0x0e
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x44,0x0e
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x48,0x0e
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x4c,0x0e
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x50,0x0e
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x54,0x0e
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x58,0x0e
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x5c,0x0e
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x60,0x0e
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x64,0x0e
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x31,0xa3,0x02,0x23,0x68,0x0e
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x6c,0x0e
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x70,0x0e
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x88,0x66,0x02,0x23,0x74,0x0e
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x8d,0xbd,0x02,0x23,0x78,0x0e
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x7c,0x00
	.byte 0x0d
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x02,0x00,0x00,0x91,0x1c,0x0e
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x00,0x0e
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x04,0x0e
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x08,0x0e
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x0c,0x0e
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x10,0x0e
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0x68,0x02,0x23,0x14,0x0e
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x18,0x0e
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x19,0x00
	.byte 0x08,0x00,0x00,0x01,0xa7,0x0d
	.ascii "gl_1d_map\0"
	.byte 0x14,0x02,0x00,0x00,0x91,0x75,0x0e
	.ascii "Order\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x00,0x0e
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x04,0x0e
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x08,0x0e
	.ascii "Points\0"
	.byte 0x00,0x00,0x91,0x1c,0x02,0x23,0x0c,0x0e
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x10,0x00
	.byte 0x0d
	.ascii "gl_2d_map\0"
	.byte 0x20,0x02,0x00,0x00,0x91,0xef,0x0e
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x00,0x0e
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x04,0x0e
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x08,0x0e
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x0c,0x0e
	.ascii "v1\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x10,0x0e
	.ascii "v2\0"
	.byte 0x00,0x00,0x01,0xa7,0x02,0x23,0x14,0x0e
	.ascii "Points\0"
	.byte 0x00,0x00,0x91,0x1c,0x02,0x23,0x18,0x0e
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xda,0x02,0x23,0x1c,0x00
	.byte 0x11
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x02,0x00,0x00,0x93,0x79,0x0e
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x00,0x0e
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x14,0x0e
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x28,0x0e
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x3c,0x0e
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x50,0x0e
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x64,0x0e
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x91,0x21,0x02,0x23,0x78,0x0e
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x91,0x21,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x91,0x21,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xd4,0x01
	.byte 0x0e
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xf4,0x01
	.byte 0x0e
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xb4,0x02
	.byte 0x0e
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xd4,0x02
	.byte 0x0e
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xf4,0x02
	.byte 0x0e
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0x94,0x03
	.byte 0x0e
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x91,0x75,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0d
	.ascii "gl_feedback\0"
	.byte 0x14,0x02,0x00,0x00,0x93,0xd7,0x0e
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x6a,0x02,0x23,0x00,0x0e
	.ascii "Mask\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x04,0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x91,0x1c,0x02,0x23,0x08,0x0e
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x0c,0x0e
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x10,0x00
	.byte 0x08,0x00,0x00,0x01,0x91,0x0f,0x00,0x00
	.byte 0x01,0x91,0x01,0x00,0x00,0x00,0x93,0xee
	.byte 0x0a,0x00,0x00,0x01,0xb5,0x3f,0x00,0x11
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x02,0x00,0x00,0x94,0xa3,0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x93,0xd7,0x02,0x23,0x00,0x0e
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x04,0x0e
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x08,0x0e
	.ascii "Hits\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x0c,0x0e
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x01,0x91,0x02,0x23,0x10,0x0e
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x93,0xdc,0x02,0x23,0x14,0x0e
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x32,0xda,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x01,0xa7,0x03,0x23,0x98,0x02
	.byte 0x0e
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x01,0xa7,0x03,0x23,0x9c,0x02
	.byte 0x00,0x07
	.ascii "vertex_buffer\0"
	.byte 0x01,0x08,0x00,0x00,0x94,0xa3,0x07
	.ascii "pixel_buffer\0"
	.byte 0x01,0x08,0x00,0x00,0x94,0xb8,0x06,0x00
	.byte 0x00,0x35,0xad
	.ascii "GLcontext\0"
	.byte 0x02,0x08,0x00,0x00,0x94,0xcc,0x17
	.ascii "gl_GetDoublev\0"
	.byte 0x01,0x02,0x01,0x03,0x88
	.uaword gl_GetDoublev
	.uaword .L2394
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x95,0x49
	.byte 0x18,0x00,0x00,0x94,0xdc
	.ascii "ctx\0"
	.byte 0x01,0x03,0x87,0x03,0x91,0xc4,0x00,0x18
	.byte 0x00,0x00,0x31,0x6a
	.ascii "pname\0"
	.byte 0x01,0x03,0x87,0x03,0x91,0xc8,0x00,0x18
	.byte 0x00,0x00,0x95,0x58
	.ascii "params\0"
	.byte 0x01,0x03,0x87,0x03,0x91,0xcc,0x00,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x91,0x01,0x01,0x03,0x89
	.byte 0x02,0x91,0x7c,0x00,0x06,0x00,0x00,0x3f
	.byte 0x1c
	.ascii "GLdouble\0"
	.byte 0x03,0x08,0x00,0x00,0x95,0x49,0x17
	.ascii "gl_GetFloatv\0"
	.byte 0x01,0x02,0x01,0x06,0xaf
	.uaword gl_GetFloatv
	.uaword .L3294
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x95,0xc4
	.byte 0x18,0x00,0x00,0x94,0xdc
	.ascii "ctx\0"
	.byte 0x01,0x06,0xae,0x03,0x91,0xc4,0x00,0x18
	.byte 0x00,0x00,0x31,0x6a
	.ascii "pname\0"
	.byte 0x01,0x06,0xae,0x03,0x91,0xc8,0x00,0x18
	.byte 0x00,0x00,0x91,0x1c
	.ascii "params\0"
	.byte 0x01,0x06,0xae,0x03,0x91,0xcc,0x00,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x91,0x01,0x01,0x06,0xb0
	.byte 0x02,0x91,0x7c,0x00,0x17
	.ascii "gl_GetIntegerv\0"
	.byte 0x01,0x02,0x01,0x09,0xd5
	.uaword gl_GetIntegerv
	.uaword .L4195
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x96,0x2d
	.byte 0x18,0x00,0x00,0x94,0xdc
	.ascii "ctx\0"
	.byte 0x01,0x09,0xd4,0x03,0x91,0xc4,0x00,0x18
	.byte 0x00,0x00,0x31,0x6a
	.ascii "pname\0"
	.byte 0x01,0x09,0xd4,0x03,0x91,0xc8,0x00,0x18
	.byte 0x00,0x00,0x96,0x2d
	.ascii "params\0"
	.byte 0x01,0x09,0xd4,0x03,0x91,0xcc,0x00,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x91,0x01,0x01,0x09,0xd6
	.byte 0x02,0x91,0x7c,0x00,0x08,0x00,0x00,0x01
	.byte 0x68,0x17
	.ascii "gl_GetPointerv\0"
	.byte 0x01,0x02,0x01,0x0c,0xfb
	.uaword gl_GetPointerv
	.uaword .L4238
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x96,0x8d
	.byte 0x18,0x00,0x00,0x94,0xdc
	.ascii "ctx\0"
	.byte 0x01,0x0c,0xfa,0x03,0x91,0xc4,0x00,0x18
	.byte 0x00,0x00,0x31,0x6a
	.ascii "pname\0"
	.byte 0x01,0x0c,0xfa,0x03,0x91,0xc8,0x00,0x18
	.byte 0x00,0x00,0x96,0x8d
	.ascii "params\0"
	.byte 0x01,0x0c,0xfa,0x03,0x91,0xcc,0x00,0x00
	.byte 0x08,0x00,0x00,0x3d,0x3d,0x1a
	.ascii "gl_list_index\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x68,0x01
	.byte 0x12,0x00,0x00,0x66,0xf9,0x08,0x00,0x00
	.byte 0x96,0xa9,0x1b
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x14,0x00,0x00,0x3c
	.byte 0x7a,0x14,0x00,0x00,0x01,0xce,0x14,0x00
	.byte 0x00,0x96,0xae,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=123, siz=4, lab1=gl_GetBooleanv, lab2=, loff=0
!   reloc[1]: knd=0, off=130, siz=4, lab1=.L18, lab2=, loff=0
!   reloc[2]: knd=0, off=142, siz=4, lab1=.L22, lab2=, loff=0
!   reloc[3]: knd=0, off=150, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[4]: knd=0, off=158, siz=4, lab1=.L31, lab2=, loff=0
!   reloc[5]: knd=0, off=168, siz=4, lab1=.L38, lab2=, loff=0
!   reloc[6]: knd=0, off=178, siz=4, lab1=.L42, lab2=, loff=0
!   reloc[7]: knd=0, off=186, siz=4, lab1=.L44, lab2=, loff=0
!   reloc[8]: knd=0, off=194, siz=4, lab1=.L48, lab2=, loff=0
!   reloc[9]: knd=0, off=202, siz=4, lab1=.L52, lab2=, loff=0
!   reloc[10]: knd=0, off=210, siz=4, lab1=.L56, lab2=, loff=0
!   reloc[11]: knd=0, off=218, siz=4, lab1=.L60, lab2=, loff=0
!   reloc[12]: knd=0, off=226, siz=4, lab1=.L62, lab2=, loff=0
!   reloc[13]: knd=0, off=234, siz=4, lab1=.L66, lab2=, loff=0
!   reloc[14]: knd=0, off=242, siz=4, lab1=.L68, lab2=, loff=0
!   reloc[15]: knd=0, off=250, siz=4, lab1=.L72, lab2=, loff=0
!   reloc[16]: knd=0, off=258, siz=4, lab1=.L74, lab2=, loff=0
!   reloc[17]: knd=0, off=266, siz=4, lab1=.L78, lab2=, loff=0
!   reloc[18]: knd=0, off=274, siz=4, lab1=.L80, lab2=, loff=0
!   reloc[19]: knd=0, off=282, siz=4, lab1=.L81, lab2=, loff=0
!   reloc[20]: knd=0, off=290, siz=4, lab1=.L83, lab2=, loff=0
!   reloc[21]: knd=0, off=298, siz=4, lab1=.L87, lab2=, loff=0
!   reloc[22]: knd=0, off=306, siz=4, lab1=.L89, lab2=, loff=0
!   reloc[23]: knd=0, off=314, siz=4, lab1=.L93, lab2=, loff=0
!   reloc[24]: knd=0, off=322, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[25]: knd=0, off=330, siz=4, lab1=.L99, lab2=, loff=0
!   reloc[26]: knd=0, off=338, siz=4, lab1=.L101, lab2=, loff=0
!   reloc[27]: knd=0, off=346, siz=4, lab1=.L102, lab2=, loff=0
!   reloc[28]: knd=0, off=354, siz=4, lab1=.L104, lab2=, loff=0
!   reloc[29]: knd=0, off=362, siz=4, lab1=.L105, lab2=, loff=0
!   reloc[30]: knd=0, off=370, siz=4, lab1=.L107, lab2=, loff=0
!   reloc[31]: knd=0, off=378, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[32]: knd=0, off=386, siz=4, lab1=.L110, lab2=, loff=0
!   reloc[33]: knd=0, off=394, siz=4, lab1=.L114, lab2=, loff=0
!   reloc[34]: knd=0, off=402, siz=4, lab1=.L116, lab2=, loff=0
!   reloc[35]: knd=0, off=410, siz=4, lab1=.L120, lab2=, loff=0
!   reloc[36]: knd=0, off=418, siz=4, lab1=.L122, lab2=, loff=0
!   reloc[37]: knd=0, off=426, siz=4, lab1=.L126, lab2=, loff=0
!   reloc[38]: knd=0, off=434, siz=4, lab1=.L128, lab2=, loff=0
!   reloc[39]: knd=0, off=442, siz=4, lab1=.L132, lab2=, loff=0
!   reloc[40]: knd=0, off=450, siz=4, lab1=.L136, lab2=, loff=0
!   reloc[41]: knd=0, off=458, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[42]: knd=0, off=466, siz=4, lab1=.L144, lab2=, loff=0
!   reloc[43]: knd=0, off=474, siz=4, lab1=.L146, lab2=, loff=0
!   reloc[44]: knd=0, off=482, siz=4, lab1=.L150, lab2=, loff=0
!   reloc[45]: knd=0, off=490, siz=4, lab1=.L152, lab2=, loff=0
!   reloc[46]: knd=0, off=498, siz=4, lab1=.L156, lab2=, loff=0
!   reloc[47]: knd=0, off=506, siz=4, lab1=.L158, lab2=, loff=0
!   reloc[48]: knd=0, off=514, siz=4, lab1=.L162, lab2=, loff=0
!   reloc[49]: knd=0, off=522, siz=4, lab1=.L164, lab2=, loff=0
!   reloc[50]: knd=0, off=530, siz=4, lab1=.L168, lab2=, loff=0
!   reloc[51]: knd=0, off=538, siz=4, lab1=.L175, lab2=, loff=0
!   reloc[52]: knd=0, off=548, siz=4, lab1=.L176, lab2=, loff=0
!   reloc[53]: knd=0, off=556, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[54]: knd=0, off=564, siz=4, lab1=.L182, lab2=, loff=0
!   reloc[55]: knd=0, off=572, siz=4, lab1=.L186, lab2=, loff=0
!   reloc[56]: knd=0, off=580, siz=4, lab1=.L190, lab2=, loff=0
!   reloc[57]: knd=0, off=588, siz=4, lab1=.L194, lab2=, loff=0
!   reloc[58]: knd=0, off=596, siz=4, lab1=.L196, lab2=, loff=0
!   reloc[59]: knd=0, off=604, siz=4, lab1=.L197, lab2=, loff=0
!   reloc[60]: knd=0, off=612, siz=4, lab1=.L199, lab2=, loff=0
!   reloc[61]: knd=0, off=620, siz=4, lab1=.L203, lab2=, loff=0
!   reloc[62]: knd=0, off=628, siz=4, lab1=.L205, lab2=, loff=0
!   reloc[63]: knd=0, off=636, siz=4, lab1=.L209, lab2=, loff=0
!   reloc[64]: knd=0, off=644, siz=4, lab1=.L211, lab2=, loff=0
!   reloc[65]: knd=0, off=652, siz=4, lab1=.L215, lab2=, loff=0
!   reloc[66]: knd=0, off=660, siz=4, lab1=.L219, lab2=, loff=0
!   reloc[67]: knd=0, off=668, siz=4, lab1=.L223, lab2=, loff=0
!   reloc[68]: knd=0, off=676, siz=4, lab1=.L227, lab2=, loff=0
!   reloc[69]: knd=0, off=684, siz=4, lab1=.L229, lab2=, loff=0
!   reloc[70]: knd=0, off=692, siz=4, lab1=.L230, lab2=, loff=0
!   reloc[71]: knd=0, off=700, siz=4, lab1=.L232, lab2=, loff=0
!   reloc[72]: knd=0, off=708, siz=4, lab1=.L236, lab2=, loff=0
!   reloc[73]: knd=0, off=716, siz=4, lab1=.L238, lab2=, loff=0
!   reloc[74]: knd=0, off=724, siz=4, lab1=.L242, lab2=, loff=0
!   reloc[75]: knd=0, off=732, siz=4, lab1=.L246, lab2=, loff=0
!   reloc[76]: knd=0, off=740, siz=4, lab1=.L250, lab2=, loff=0
!   reloc[77]: knd=0, off=748, siz=4, lab1=.L254, lab2=, loff=0
!   reloc[78]: knd=0, off=756, siz=4, lab1=.L256, lab2=, loff=0
!   reloc[79]: knd=0, off=764, siz=4, lab1=.L260, lab2=, loff=0
!   reloc[80]: knd=0, off=772, siz=4, lab1=.L262, lab2=, loff=0
!   reloc[81]: knd=0, off=780, siz=4, lab1=.L266, lab2=, loff=0
!   reloc[82]: knd=0, off=788, siz=4, lab1=.L270, lab2=, loff=0
!   reloc[83]: knd=0, off=796, siz=4, lab1=.L274, lab2=, loff=0
!   reloc[84]: knd=0, off=804, siz=4, lab1=.L276, lab2=, loff=0
!   reloc[85]: knd=0, off=812, siz=4, lab1=.L280, lab2=, loff=0
!   reloc[86]: knd=0, off=820, siz=4, lab1=.L284, lab2=, loff=0
!   reloc[87]: knd=0, off=828, siz=4, lab1=.L288, lab2=, loff=0
!   reloc[88]: knd=0, off=836, siz=4, lab1=.L292, lab2=, loff=0
!   reloc[89]: knd=0, off=844, siz=4, lab1=.L294, lab2=, loff=0
!   reloc[90]: knd=0, off=852, siz=4, lab1=.L298, lab2=, loff=0
!   reloc[91]: knd=0, off=860, siz=4, lab1=.L300, lab2=, loff=0
!   reloc[92]: knd=0, off=868, siz=4, lab1=.L304, lab2=, loff=0
!   reloc[93]: knd=0, off=876, siz=4, lab1=.L306, lab2=, loff=0
!   reloc[94]: knd=0, off=884, siz=4, lab1=.L310, lab2=, loff=0
!   reloc[95]: knd=0, off=892, siz=4, lab1=.L314, lab2=, loff=0
!   reloc[96]: knd=0, off=900, siz=4, lab1=.L318, lab2=, loff=0
!   reloc[97]: knd=0, off=908, siz=4, lab1=.L322, lab2=, loff=0
!   reloc[98]: knd=0, off=916, siz=4, lab1=.L324, lab2=, loff=0
!   reloc[99]: knd=0, off=924, siz=4, lab1=.L328, lab2=, loff=0
!   reloc[100]: knd=0, off=932, siz=4, lab1=.L332, lab2=, loff=0
!   reloc[101]: knd=0, off=940, siz=4, lab1=.L336, lab2=, loff=0
!   reloc[102]: knd=0, off=948, siz=4, lab1=.L340, lab2=, loff=0
!   reloc[103]: knd=0, off=956, siz=4, lab1=.L342, lab2=, loff=0
!   reloc[104]: knd=0, off=964, siz=4, lab1=.L343, lab2=, loff=0
!   reloc[105]: knd=0, off=972, siz=4, lab1=.L345, lab2=, loff=0
!   reloc[106]: knd=0, off=980, siz=4, lab1=.L349, lab2=, loff=0
!   reloc[107]: knd=0, off=988, siz=4, lab1=.L353, lab2=, loff=0
!   reloc[108]: knd=0, off=996, siz=4, lab1=.L357, lab2=, loff=0
!   reloc[109]: knd=0, off=1004, siz=4, lab1=.L361, lab2=, loff=0
!   reloc[110]: knd=0, off=1012, siz=4, lab1=.L363, lab2=, loff=0
!   reloc[111]: knd=0, off=1020, siz=4, lab1=.L367, lab2=, loff=0
!   reloc[112]: knd=0, off=1028, siz=4, lab1=.L369, lab2=, loff=0
!   reloc[113]: knd=0, off=1036, siz=4, lab1=.L373, lab2=, loff=0
!   reloc[114]: knd=0, off=1044, siz=4, lab1=.L375, lab2=, loff=0
!   reloc[115]: knd=0, off=1052, siz=4, lab1=.L379, lab2=, loff=0
!   reloc[116]: knd=0, off=1060, siz=4, lab1=.L381, lab2=, loff=0
!   reloc[117]: knd=0, off=1068, siz=4, lab1=.L385, lab2=, loff=0
!   reloc[118]: knd=0, off=1076, siz=4, lab1=.L387, lab2=, loff=0
!   reloc[119]: knd=0, off=1084, siz=4, lab1=.L391, lab2=, loff=0
!   reloc[120]: knd=0, off=1092, siz=4, lab1=.L395, lab2=, loff=0
!   reloc[121]: knd=0, off=1100, siz=4, lab1=.L397, lab2=, loff=0
!   reloc[122]: knd=0, off=1108, siz=4, lab1=.L401, lab2=, loff=0
!   reloc[123]: knd=0, off=1116, siz=4, lab1=.L403, lab2=, loff=0
!   reloc[124]: knd=0, off=1124, siz=4, lab1=.L404, lab2=, loff=0
!   reloc[125]: knd=0, off=1132, siz=4, lab1=.L406, lab2=, loff=0
!   reloc[126]: knd=0, off=1140, siz=4, lab1=.L407, lab2=, loff=0
!   reloc[127]: knd=0, off=1148, siz=4, lab1=.L409, lab2=, loff=0
!   reloc[128]: knd=0, off=1156, siz=4, lab1=.L410, lab2=, loff=0
!   reloc[129]: knd=0, off=1164, siz=4, lab1=.L412, lab2=, loff=0
!   reloc[130]: knd=0, off=1172, siz=4, lab1=.L413, lab2=, loff=0
!   reloc[131]: knd=0, off=1180, siz=4, lab1=.L415, lab2=, loff=0
!   reloc[132]: knd=0, off=1188, siz=4, lab1=.L419, lab2=, loff=0
!   reloc[133]: knd=0, off=1196, siz=4, lab1=.L421, lab2=, loff=0
!   reloc[134]: knd=0, off=1204, siz=4, lab1=.L422, lab2=, loff=0
!   reloc[135]: knd=0, off=1212, siz=4, lab1=.L424, lab2=, loff=0
!   reloc[136]: knd=0, off=1222, siz=4, lab1=.L428, lab2=, loff=0
!   reloc[137]: knd=0, off=1230, siz=4, lab1=.L430, lab2=, loff=0
!   reloc[138]: knd=0, off=1238, siz=4, lab1=.L434, lab2=, loff=0
!   reloc[139]: knd=0, off=1246, siz=4, lab1=.L436, lab2=, loff=0
!   reloc[140]: knd=0, off=1254, siz=4, lab1=.L437, lab2=, loff=0
!   reloc[141]: knd=0, off=1262, siz=4, lab1=.L439, lab2=, loff=0
!   reloc[142]: knd=0, off=1270, siz=4, lab1=.L443, lab2=, loff=0
!   reloc[143]: knd=0, off=1278, siz=4, lab1=.L447, lab2=, loff=0
!   reloc[144]: knd=0, off=1286, siz=4, lab1=.L451, lab2=, loff=0
!   reloc[145]: knd=0, off=1294, siz=4, lab1=.L455, lab2=, loff=0
!   reloc[146]: knd=0, off=1302, siz=4, lab1=.L457, lab2=, loff=0
!   reloc[147]: knd=0, off=1310, siz=4, lab1=.L461, lab2=, loff=0
!   reloc[148]: knd=0, off=1318, siz=4, lab1=.L463, lab2=, loff=0
!   reloc[149]: knd=0, off=1326, siz=4, lab1=.L467, lab2=, loff=0
!   reloc[150]: knd=0, off=1334, siz=4, lab1=.L469, lab2=, loff=0
!   reloc[151]: knd=0, off=1342, siz=4, lab1=.L473, lab2=, loff=0
!   reloc[152]: knd=0, off=1350, siz=4, lab1=.L475, lab2=, loff=0
!   reloc[153]: knd=0, off=1358, siz=4, lab1=.L479, lab2=, loff=0
!   reloc[154]: knd=0, off=1366, siz=4, lab1=.L481, lab2=, loff=0
!   reloc[155]: knd=0, off=1374, siz=4, lab1=.L485, lab2=, loff=0
!   reloc[156]: knd=0, off=1382, siz=4, lab1=.L487, lab2=, loff=0
!   reloc[157]: knd=0, off=1390, siz=4, lab1=.L491, lab2=, loff=0
!   reloc[158]: knd=0, off=1398, siz=4, lab1=.L493, lab2=, loff=0
!   reloc[159]: knd=0, off=1406, siz=4, lab1=.L497, lab2=, loff=0
!   reloc[160]: knd=0, off=1414, siz=4, lab1=.L499, lab2=, loff=0
!   reloc[161]: knd=0, off=1422, siz=4, lab1=.L503, lab2=, loff=0
!   reloc[162]: knd=0, off=1430, siz=4, lab1=.L505, lab2=, loff=0
!   reloc[163]: knd=0, off=1438, siz=4, lab1=.L509, lab2=, loff=0
!   reloc[164]: knd=0, off=1446, siz=4, lab1=.L511, lab2=, loff=0
!   reloc[165]: knd=0, off=1454, siz=4, lab1=.L515, lab2=, loff=0
!   reloc[166]: knd=0, off=1462, siz=4, lab1=.L517, lab2=, loff=0
!   reloc[167]: knd=0, off=1470, siz=4, lab1=.L521, lab2=, loff=0
!   reloc[168]: knd=0, off=1478, siz=4, lab1=.L523, lab2=, loff=0
!   reloc[169]: knd=0, off=1486, siz=4, lab1=.L527, lab2=, loff=0
!   reloc[170]: knd=0, off=1494, siz=4, lab1=.L529, lab2=, loff=0
!   reloc[171]: knd=0, off=1502, siz=4, lab1=.L533, lab2=, loff=0
!   reloc[172]: knd=0, off=1510, siz=4, lab1=.L535, lab2=, loff=0
!   reloc[173]: knd=0, off=1518, siz=4, lab1=.L539, lab2=, loff=0
!   reloc[174]: knd=0, off=1526, siz=4, lab1=.L541, lab2=, loff=0
!   reloc[175]: knd=0, off=1534, siz=4, lab1=.L545, lab2=, loff=0
!   reloc[176]: knd=0, off=1542, siz=4, lab1=.L547, lab2=, loff=0
!   reloc[177]: knd=0, off=1550, siz=4, lab1=.L551, lab2=, loff=0
!   reloc[178]: knd=0, off=1558, siz=4, lab1=.L560, lab2=, loff=0
!   reloc[179]: knd=0, off=1568, siz=4, lab1=.L561, lab2=, loff=0
!   reloc[180]: knd=0, off=1576, siz=4, lab1=.L563, lab2=, loff=0
!   reloc[181]: knd=0, off=1584, siz=4, lab1=.L564, lab2=, loff=0
!   reloc[182]: knd=0, off=1592, siz=4, lab1=.L566, lab2=, loff=0
!   reloc[183]: knd=0, off=1600, siz=4, lab1=.L570, lab2=, loff=0
!   reloc[184]: knd=0, off=1608, siz=4, lab1=.L574, lab2=, loff=0
!   reloc[185]: knd=0, off=1616, siz=4, lab1=.L578, lab2=, loff=0
!   reloc[186]: knd=0, off=1624, siz=4, lab1=.L582, lab2=, loff=0
!   reloc[187]: knd=0, off=1632, siz=4, lab1=.L584, lab2=, loff=0
!   reloc[188]: knd=0, off=1640, siz=4, lab1=.L585, lab2=, loff=0
!   reloc[189]: knd=0, off=1648, siz=4, lab1=.L587, lab2=, loff=0
!   reloc[190]: knd=0, off=1656, siz=4, lab1=.L588, lab2=, loff=0
!   reloc[191]: knd=0, off=1664, siz=4, lab1=.L590, lab2=, loff=0
!   reloc[192]: knd=0, off=1672, siz=4, lab1=.L591, lab2=, loff=0
!   reloc[193]: knd=0, off=1680, siz=4, lab1=.L593, lab2=, loff=0
!   reloc[194]: knd=0, off=1688, siz=4, lab1=.L597, lab2=, loff=0
!   reloc[195]: knd=0, off=1696, siz=4, lab1=.L599, lab2=, loff=0
!   reloc[196]: knd=0, off=1704, siz=4, lab1=.L600, lab2=, loff=0
!   reloc[197]: knd=0, off=1712, siz=4, lab1=.L602, lab2=, loff=0
!   reloc[198]: knd=0, off=1720, siz=4, lab1=.L606, lab2=, loff=0
!   reloc[199]: knd=0, off=1728, siz=4, lab1=.L608, lab2=, loff=0
!   reloc[200]: knd=0, off=1736, siz=4, lab1=.L612, lab2=, loff=0
!   reloc[201]: knd=0, off=1744, siz=4, lab1=.L614, lab2=, loff=0
!   reloc[202]: knd=0, off=1752, siz=4, lab1=.L618, lab2=, loff=0
!   reloc[203]: knd=0, off=1760, siz=4, lab1=.L620, lab2=, loff=0
!   reloc[204]: knd=0, off=1768, siz=4, lab1=.L624, lab2=, loff=0
!   reloc[205]: knd=0, off=1776, siz=4, lab1=.L626, lab2=, loff=0
!   reloc[206]: knd=0, off=1784, siz=4, lab1=.L630, lab2=, loff=0
!   reloc[207]: knd=0, off=1792, siz=4, lab1=.L634, lab2=, loff=0
!   reloc[208]: knd=0, off=1800, siz=4, lab1=.L636, lab2=, loff=0
!   reloc[209]: knd=0, off=1808, siz=4, lab1=.L640, lab2=, loff=0
!   reloc[210]: knd=0, off=1816, siz=4, lab1=.L642, lab2=, loff=0
!   reloc[211]: knd=0, off=1824, siz=4, lab1=.L646, lab2=, loff=0
!   reloc[212]: knd=0, off=1832, siz=4, lab1=.L648, lab2=, loff=0
!   reloc[213]: knd=0, off=1842, siz=4, lab1=.L655, lab2=, loff=0
!   reloc[214]: knd=0, off=1850, siz=4, lab1=.L657, lab2=, loff=0
!   reloc[215]: knd=0, off=1858, siz=4, lab1=.L658, lab2=, loff=0
!   reloc[216]: knd=0, off=1866, siz=4, lab1=.L660, lab2=, loff=0
!   reloc[217]: knd=0, off=1874, siz=4, lab1=.L661, lab2=, loff=0
!   reloc[218]: knd=0, off=1882, siz=4, lab1=.L663, lab2=, loff=0
!   reloc[219]: knd=0, off=1890, siz=4, lab1=.L667, lab2=, loff=0
!   reloc[220]: knd=0, off=1898, siz=4, lab1=.L669, lab2=, loff=0
!   reloc[221]: knd=0, off=1906, siz=4, lab1=.L670, lab2=, loff=0
!   reloc[222]: knd=0, off=1914, siz=4, lab1=.L672, lab2=, loff=0
!   reloc[223]: knd=0, off=1922, siz=4, lab1=.L676, lab2=, loff=0
!   reloc[224]: knd=0, off=1930, siz=4, lab1=.L680, lab2=, loff=0
!   reloc[225]: knd=0, off=1938, siz=4, lab1=.L682, lab2=, loff=0
!   reloc[226]: knd=0, off=1946, siz=4, lab1=.L686, lab2=, loff=0
!   reloc[227]: knd=0, off=1954, siz=4, lab1=.L688, lab2=, loff=0
!   reloc[228]: knd=0, off=1962, siz=4, lab1=.L689, lab2=, loff=0
!   reloc[229]: knd=0, off=1970, siz=4, lab1=.L691, lab2=, loff=0
!   reloc[230]: knd=0, off=1978, siz=4, lab1=.L692, lab2=, loff=0
!   reloc[231]: knd=0, off=1986, siz=4, lab1=.L694, lab2=, loff=0
!   reloc[232]: knd=0, off=1994, siz=4, lab1=.L695, lab2=, loff=0
!   reloc[233]: knd=0, off=2002, siz=4, lab1=.L697, lab2=, loff=0
!   reloc[234]: knd=0, off=2010, siz=4, lab1=.L698, lab2=, loff=0
!   reloc[235]: knd=0, off=2018, siz=4, lab1=.L700, lab2=, loff=0
!   reloc[236]: knd=0, off=2026, siz=4, lab1=.L701, lab2=, loff=0
!   reloc[237]: knd=0, off=2034, siz=4, lab1=.L703, lab2=, loff=0
!   reloc[238]: knd=0, off=2042, siz=4, lab1=.L704, lab2=, loff=0
!   reloc[239]: knd=0, off=2050, siz=4, lab1=.L706, lab2=, loff=0
!   reloc[240]: knd=0, off=2058, siz=4, lab1=.L707, lab2=, loff=0
!   reloc[241]: knd=0, off=2066, siz=4, lab1=.L709, lab2=, loff=0
!   reloc[242]: knd=0, off=2074, siz=4, lab1=.L710, lab2=, loff=0
!   reloc[243]: knd=0, off=2082, siz=4, lab1=.L712, lab2=, loff=0
!   reloc[244]: knd=0, off=2090, siz=4, lab1=.L713, lab2=, loff=0
!   reloc[245]: knd=0, off=2098, siz=4, lab1=.L715, lab2=, loff=0
!   reloc[246]: knd=0, off=2106, siz=4, lab1=.L719, lab2=, loff=0
!   reloc[247]: knd=0, off=2114, siz=4, lab1=.L723, lab2=, loff=0
!   reloc[248]: knd=0, off=2122, siz=4, lab1=.L727, lab2=, loff=0
!   reloc[249]: knd=0, off=2130, siz=4, lab1=.L731, lab2=, loff=0
!   reloc[250]: knd=0, off=2138, siz=4, lab1=.L733, lab2=, loff=0
!   reloc[251]: knd=0, off=2146, siz=4, lab1=.L737, lab2=, loff=0
!   reloc[252]: knd=0, off=2154, siz=4, lab1=.L741, lab2=, loff=0
!   reloc[253]: knd=0, off=2162, siz=4, lab1=.L743, lab2=, loff=0
!   reloc[254]: knd=0, off=2170, siz=4, lab1=.L744, lab2=, loff=0
!   reloc[255]: knd=0, off=2178, siz=4, lab1=.L746, lab2=, loff=0
!   reloc[256]: knd=0, off=2186, siz=4, lab1=.L747, lab2=, loff=0
!   reloc[257]: knd=0, off=2194, siz=4, lab1=.L749, lab2=, loff=0
!   reloc[258]: knd=0, off=2202, siz=4, lab1=.L750, lab2=, loff=0
!   reloc[259]: knd=0, off=2210, siz=4, lab1=.L752, lab2=, loff=0
!   reloc[260]: knd=0, off=2218, siz=4, lab1=.L753, lab2=, loff=0
!   reloc[261]: knd=0, off=2226, siz=4, lab1=.L755, lab2=, loff=0
!   reloc[262]: knd=0, off=2234, siz=4, lab1=.L756, lab2=, loff=0
!   reloc[263]: knd=0, off=2242, siz=4, lab1=.L758, lab2=, loff=0
!   reloc[264]: knd=0, off=2250, siz=4, lab1=.L759, lab2=, loff=0
!   reloc[265]: knd=0, off=2258, siz=4, lab1=.L761, lab2=, loff=0
!   reloc[266]: knd=0, off=2266, siz=4, lab1=.L762, lab2=, loff=0
!   reloc[267]: knd=0, off=2274, siz=4, lab1=.L764, lab2=, loff=0
!   reloc[268]: knd=0, off=2282, siz=4, lab1=.L765, lab2=, loff=0
!   reloc[269]: knd=0, off=2290, siz=4, lab1=.L767, lab2=, loff=0
!   reloc[270]: knd=0, off=2298, siz=4, lab1=.L768, lab2=, loff=0
!   reloc[271]: knd=0, off=2306, siz=4, lab1=.L770, lab2=, loff=0
!   reloc[272]: knd=0, off=2314, siz=4, lab1=.L771, lab2=, loff=0
!   reloc[273]: knd=0, off=2322, siz=4, lab1=.L773, lab2=, loff=0
!   reloc[274]: knd=0, off=2330, siz=4, lab1=.L777, lab2=, loff=0
!   reloc[275]: knd=0, off=2338, siz=4, lab1=.L779, lab2=, loff=0
!   reloc[276]: knd=0, off=2346, siz=4, lab1=.L780, lab2=, loff=0
!   reloc[277]: knd=0, off=2354, siz=4, lab1=.L782, lab2=, loff=0
!   reloc[278]: knd=0, off=2362, siz=4, lab1=.L783, lab2=, loff=0
!   reloc[279]: knd=0, off=2370, siz=4, lab1=.L785, lab2=, loff=0
!   reloc[280]: knd=0, off=2378, siz=4, lab1=.L786, lab2=, loff=0
!   reloc[281]: knd=0, off=2386, siz=4, lab1=.L788, lab2=, loff=0
!   reloc[282]: knd=0, off=2394, siz=4, lab1=.L789, lab2=, loff=0
!   reloc[283]: knd=0, off=2402, siz=4, lab1=.L791, lab2=, loff=0
!   reloc[284]: knd=0, off=2410, siz=4, lab1=.L792, lab2=, loff=0
!   reloc[285]: knd=0, off=2418, siz=4, lab1=.L794, lab2=, loff=0
!   reloc[286]: knd=0, off=2426, siz=4, lab1=.L795, lab2=, loff=0
!   reloc[287]: knd=0, off=2434, siz=4, lab1=.L797, lab2=, loff=0
!   reloc[288]: knd=0, off=2442, siz=4, lab1=.L798, lab2=, loff=0
!   reloc[289]: knd=0, off=2450, siz=4, lab1=.L800, lab2=, loff=0
!   reloc[290]: knd=0, off=2458, siz=4, lab1=.L801, lab2=, loff=0
!   reloc[291]: knd=0, off=2466, siz=4, lab1=.L803, lab2=, loff=0
!   reloc[292]: knd=0, off=2474, siz=4, lab1=.L804, lab2=, loff=0
!   reloc[293]: knd=0, off=2482, siz=4, lab1=.L806, lab2=, loff=0
!   reloc[294]: knd=0, off=2490, siz=4, lab1=.L807, lab2=, loff=0
!   reloc[295]: knd=0, off=2498, siz=4, lab1=.L809, lab2=, loff=0
!   reloc[296]: knd=0, off=2506, siz=4, lab1=.L810, lab2=, loff=0
!   reloc[297]: knd=0, off=2514, siz=4, lab1=.L812, lab2=, loff=0
!   reloc[298]: knd=0, off=2522, siz=4, lab1=.L813, lab2=, loff=0
!   reloc[299]: knd=0, off=2530, siz=4, lab1=.L815, lab2=, loff=0
!   reloc[300]: knd=0, off=2538, siz=4, lab1=.L816, lab2=, loff=0
!   reloc[301]: knd=0, off=2546, siz=4, lab1=.L817, lab2=, loff=0
!   reloc[302]: knd=0, off=2554, siz=4, lab1=.L820, lab2=, loff=0
!   reloc[303]: knd=0, off=2562, siz=4, lab1=.L827, lab2=, loff=0
!   reloc[304]: knd=0, off=2570, siz=4, lab1=.L833, lab2=, loff=0
!   reloc[305]: knd=0, off=2578, siz=4, lab1=.L836, lab2=, loff=0
!   reloc[306]: knd=0, off=2588, siz=4, lab1=.L838, lab2=, loff=0
!   reloc[307]: knd=0, off=2596, siz=4, lab1=.L842, lab2=, loff=0
!   reloc[308]: knd=0, off=2604, siz=4, lab1=.L844, lab2=, loff=0
!   reloc[309]: knd=0, off=2612, siz=4, lab1=.L848, lab2=, loff=0
!   reloc[310]: knd=0, off=2620, siz=4, lab1=.L850, lab2=, loff=0
!   reloc[311]: knd=0, off=2628, siz=4, lab1=.L851, lab2=, loff=0
!   reloc[312]: knd=0, off=2636, siz=4, lab1=.L853, lab2=, loff=0
!   reloc[313]: knd=0, off=2644, siz=4, lab1=.L857, lab2=, loff=0
!   reloc[314]: knd=0, off=2652, siz=4, lab1=.L859, lab2=, loff=0
!   reloc[315]: knd=0, off=2660, siz=4, lab1=.L860, lab2=, loff=0
!   reloc[316]: knd=0, off=2668, siz=4, lab1=.L862, lab2=, loff=0
!   reloc[317]: knd=0, off=2676, siz=4, lab1=.L866, lab2=, loff=0
!   reloc[318]: knd=0, off=2684, siz=4, lab1=.L868, lab2=, loff=0
!   reloc[319]: knd=0, off=2692, siz=4, lab1=.L872, lab2=, loff=0
!   reloc[320]: knd=0, off=2700, siz=4, lab1=.L874, lab2=, loff=0
!   reloc[321]: knd=0, off=2708, siz=4, lab1=.L878, lab2=, loff=0
!   reloc[322]: knd=0, off=2716, siz=4, lab1=.L880, lab2=, loff=0
!   reloc[323]: knd=0, off=2724, siz=4, lab1=.L881, lab2=, loff=0
!   reloc[324]: knd=0, off=2732, siz=4, lab1=.L883, lab2=, loff=0
!   reloc[325]: knd=0, off=2740, siz=4, lab1=.L884, lab2=, loff=0
!   reloc[326]: knd=0, off=2748, siz=4, lab1=.L886, lab2=, loff=0
!   reloc[327]: knd=0, off=2756, siz=4, lab1=.L887, lab2=, loff=0
!   reloc[328]: knd=0, off=2764, siz=4, lab1=.L889, lab2=, loff=0
!   reloc[329]: knd=0, off=2772, siz=4, lab1=.L893, lab2=, loff=0
!   reloc[330]: knd=0, off=2780, siz=4, lab1=.L895, lab2=, loff=0
!   reloc[331]: knd=0, off=2788, siz=4, lab1=.L899, lab2=, loff=0
!   reloc[332]: knd=0, off=2796, siz=4, lab1=.L901, lab2=, loff=0
!   reloc[333]: knd=0, off=2804, siz=4, lab1=.L905, lab2=, loff=0
!   reloc[334]: knd=0, off=2812, siz=4, lab1=.L907, lab2=, loff=0
!   reloc[335]: knd=0, off=2820, siz=4, lab1=.L911, lab2=, loff=0
!   reloc[336]: knd=0, off=2828, siz=4, lab1=.L913, lab2=, loff=0
!   reloc[337]: knd=0, off=2836, siz=4, lab1=.L917, lab2=, loff=0
!   reloc[338]: knd=0, off=2844, siz=4, lab1=.L919, lab2=, loff=0
!   reloc[339]: knd=0, off=2852, siz=4, lab1=.L923, lab2=, loff=0
!   reloc[340]: knd=0, off=2860, siz=4, lab1=.L925, lab2=, loff=0
!   reloc[341]: knd=0, off=2868, siz=4, lab1=.L929, lab2=, loff=0
!   reloc[342]: knd=0, off=2876, siz=4, lab1=.L931, lab2=, loff=0
!   reloc[343]: knd=0, off=2884, siz=4, lab1=.L935, lab2=, loff=0
!   reloc[344]: knd=0, off=2892, siz=4, lab1=.L937, lab2=, loff=0
!   reloc[345]: knd=0, off=2900, siz=4, lab1=.L941, lab2=, loff=0
!   reloc[346]: knd=0, off=2908, siz=4, lab1=.L943, lab2=, loff=0
!   reloc[347]: knd=0, off=2916, siz=4, lab1=.L947, lab2=, loff=0
!   reloc[348]: knd=0, off=2924, siz=4, lab1=.L949, lab2=, loff=0
!   reloc[349]: knd=0, off=2932, siz=4, lab1=.L953, lab2=, loff=0
!   reloc[350]: knd=0, off=2940, siz=4, lab1=.L955, lab2=, loff=0
!   reloc[351]: knd=0, off=2948, siz=4, lab1=.L959, lab2=, loff=0
!   reloc[352]: knd=0, off=2956, siz=4, lab1=.L961, lab2=, loff=0
!   reloc[353]: knd=0, off=2964, siz=4, lab1=.L965, lab2=, loff=0
!   reloc[354]: knd=0, off=2972, siz=4, lab1=.L967, lab2=, loff=0
!   reloc[355]: knd=0, off=2980, siz=4, lab1=.L971, lab2=, loff=0
!   reloc[356]: knd=0, off=2988, siz=4, lab1=.L975, lab2=, loff=0
!   reloc[357]: knd=0, off=2996, siz=4, lab1=.L977, lab2=, loff=0
!   reloc[358]: knd=0, off=3004, siz=4, lab1=.L978, lab2=, loff=0
!   reloc[359]: knd=0, off=3012, siz=4, lab1=.L980, lab2=, loff=0
!   reloc[360]: knd=0, off=3020, siz=4, lab1=.L984, lab2=, loff=0
!   reloc[361]: knd=0, off=3028, siz=4, lab1=.L986, lab2=, loff=0
!   reloc[362]: knd=0, off=3036, siz=4, lab1=.L990, lab2=, loff=0
!   reloc[363]: knd=0, off=3044, siz=4, lab1=.L992, lab2=, loff=0
!   reloc[364]: knd=0, off=3052, siz=4, lab1=.L996, lab2=, loff=0
!   reloc[365]: knd=0, off=3060, siz=4, lab1=.L998, lab2=, loff=0
!   reloc[366]: knd=0, off=3068, siz=4, lab1=.L1002, lab2=, loff=0
!   reloc[367]: knd=0, off=3076, siz=4, lab1=.L1004, lab2=, loff=0
!   reloc[368]: knd=0, off=3084, siz=4, lab1=.L1008, lab2=, loff=0
!   reloc[369]: knd=0, off=3092, siz=4, lab1=.L1012, lab2=, loff=0
!   reloc[370]: knd=0, off=3100, siz=4, lab1=.L1016, lab2=, loff=0
!   reloc[371]: knd=0, off=3108, siz=4, lab1=.L1018, lab2=, loff=0
!   reloc[372]: knd=0, off=3116, siz=4, lab1=.L1022, lab2=, loff=0
!   reloc[373]: knd=0, off=3124, siz=4, lab1=.L1026, lab2=, loff=0
!   reloc[374]: knd=0, off=3132, siz=4, lab1=.L1028, lab2=, loff=0
!   reloc[375]: knd=0, off=3142, siz=4, lab1=.L1032, lab2=, loff=0
!   reloc[376]: knd=0, off=3150, siz=4, lab1=.L1034, lab2=, loff=0
!   reloc[377]: knd=0, off=3160, siz=4, lab1=.L1038, lab2=, loff=0
!   reloc[378]: knd=0, off=3168, siz=4, lab1=.L1040, lab2=, loff=0
!   reloc[379]: knd=0, off=3176, siz=4, lab1=.L1044, lab2=, loff=0
!   reloc[380]: knd=0, off=3184, siz=4, lab1=.L1046, lab2=, loff=0
!   reloc[381]: knd=0, off=3192, siz=4, lab1=.L1047, lab2=, loff=0
!   reloc[382]: knd=0, off=3200, siz=4, lab1=.L1049, lab2=, loff=0
!   reloc[383]: knd=0, off=3208, siz=4, lab1=.L1053, lab2=, loff=0
!   reloc[384]: knd=0, off=3216, siz=4, lab1=.L1055, lab2=, loff=0
!   reloc[385]: knd=0, off=3224, siz=4, lab1=.L1056, lab2=, loff=0
!   reloc[386]: knd=0, off=3232, siz=4, lab1=.L1059, lab2=, loff=0
!   reloc[387]: knd=0, off=3240, siz=4, lab1=.L1066, lab2=, loff=0
!   reloc[388]: knd=0, off=3248, siz=4, lab1=.L1072, lab2=, loff=0
!   reloc[389]: knd=0, off=3256, siz=4, lab1=.L1075, lab2=, loff=0
!   reloc[390]: knd=0, off=3266, siz=4, lab1=.L1077, lab2=, loff=0
!   reloc[391]: knd=0, off=3274, siz=4, lab1=.L1081, lab2=, loff=0
!   reloc[392]: knd=0, off=3282, siz=4, lab1=.L1083, lab2=, loff=0
!   reloc[393]: knd=0, off=3290, siz=4, lab1=.L1087, lab2=, loff=0
!   reloc[394]: knd=0, off=3298, siz=4, lab1=.L1089, lab2=, loff=0
!   reloc[395]: knd=0, off=3306, siz=4, lab1=.L1093, lab2=, loff=0
!   reloc[396]: knd=0, off=3314, siz=4, lab1=.L1095, lab2=, loff=0
!   reloc[397]: knd=0, off=3322, siz=4, lab1=.L1099, lab2=, loff=0
!   reloc[398]: knd=0, off=3330, siz=4, lab1=.L1101, lab2=, loff=0
!   reloc[399]: knd=0, off=3338, siz=4, lab1=.L1105, lab2=, loff=0
!   reloc[400]: knd=0, off=3346, siz=4, lab1=.L1107, lab2=, loff=0
!   reloc[401]: knd=0, off=3354, siz=4, lab1=.L1111, lab2=, loff=0
!   reloc[402]: knd=0, off=3362, siz=4, lab1=.L1113, lab2=, loff=0
!   reloc[403]: knd=0, off=3370, siz=4, lab1=.L1114, lab2=, loff=0
!   reloc[404]: knd=0, off=3378, siz=4, lab1=.L1116, lab2=, loff=0
!   reloc[405]: knd=0, off=3386, siz=4, lab1=.L1120, lab2=, loff=0
!   reloc[406]: knd=0, off=3394, siz=4, lab1=.L1124, lab2=, loff=0
!   reloc[407]: knd=0, off=3402, siz=4, lab1=.L1128, lab2=, loff=0
!   reloc[408]: knd=0, off=3410, siz=4, lab1=.L1132, lab2=, loff=0
!   reloc[409]: knd=0, off=3418, siz=4, lab1=.L1134, lab2=, loff=0
!   reloc[410]: knd=0, off=3426, siz=4, lab1=.L1135, lab2=, loff=0
!   reloc[411]: knd=0, off=3434, siz=4, lab1=.L1137, lab2=, loff=0
!   reloc[412]: knd=0, off=3442, siz=4, lab1=.L1141, lab2=, loff=0
!   reloc[413]: knd=0, off=3450, siz=4, lab1=.L1143, lab2=, loff=0
!   reloc[414]: knd=0, off=3458, siz=4, lab1=.L1144, lab2=, loff=0
!   reloc[415]: knd=0, off=3466, siz=4, lab1=.L1146, lab2=, loff=0
!   reloc[416]: knd=0, off=3474, siz=4, lab1=.L1150, lab2=, loff=0
!   reloc[417]: knd=0, off=3482, siz=4, lab1=.L1152, lab2=, loff=0
!   reloc[418]: knd=0, off=3490, siz=4, lab1=.L1156, lab2=, loff=0
!   reloc[419]: knd=0, off=3498, siz=4, lab1=.L1158, lab2=, loff=0
!   reloc[420]: knd=0, off=3506, siz=4, lab1=.L1162, lab2=, loff=0
!   reloc[421]: knd=0, off=3514, siz=4, lab1=.L1164, lab2=, loff=0
!   reloc[422]: knd=0, off=3522, siz=4, lab1=.L1168, lab2=, loff=0
!   reloc[423]: knd=0, off=3530, siz=4, lab1=.L1170, lab2=, loff=0
!   reloc[424]: knd=0, off=3538, siz=4, lab1=.L1174, lab2=, loff=0
!   reloc[425]: knd=0, off=3546, siz=4, lab1=.L1176, lab2=, loff=0
!   reloc[426]: knd=0, off=3554, siz=4, lab1=.L1180, lab2=, loff=0
!   reloc[427]: knd=0, off=3562, siz=4, lab1=.L1182, lab2=, loff=0
!   reloc[428]: knd=0, off=3570, siz=4, lab1=.L1186, lab2=, loff=0
!   reloc[429]: knd=0, off=3578, siz=4, lab1=.L1188, lab2=, loff=0
!   reloc[430]: knd=0, off=3586, siz=4, lab1=.L1189, lab2=, loff=0
!   reloc[431]: knd=0, off=3594, siz=4, lab1=.L1191, lab2=, loff=0
!   reloc[432]: knd=0, off=3602, siz=4, lab1=.L1195, lab2=, loff=0
!   reloc[433]: knd=0, off=3610, siz=4, lab1=.L1197, lab2=, loff=0
!   reloc[434]: knd=0, off=3618, siz=4, lab1=.L1201, lab2=, loff=0
!   reloc[435]: knd=0, off=3626, siz=4, lab1=.L1203, lab2=, loff=0
!   reloc[436]: knd=0, off=3634, siz=4, lab1=.L1204, lab2=, loff=0
!   reloc[437]: knd=0, off=3642, siz=4, lab1=.L1206, lab2=, loff=0
!   reloc[438]: knd=0, off=3650, siz=4, lab1=.L1207, lab2=, loff=0
!   reloc[439]: knd=0, off=3658, siz=4, lab1=.L1209, lab2=, loff=0
!   reloc[440]: knd=0, off=3666, siz=4, lab1=.L1213, lab2=, loff=0
!   reloc[441]: knd=0, off=3674, siz=4, lab1=.L1215, lab2=, loff=0
!   reloc[442]: knd=0, off=3682, siz=4, lab1=.L1219, lab2=, loff=0
!   reloc[443]: knd=0, off=3690, siz=4, lab1=.L1221, lab2=, loff=0
!   reloc[444]: knd=0, off=3698, siz=4, lab1=.L1225, lab2=, loff=0
!   reloc[445]: knd=0, off=3706, siz=4, lab1=.L1227, lab2=, loff=0
!   reloc[446]: knd=0, off=3714, siz=4, lab1=.L1231, lab2=, loff=0
!   reloc[447]: knd=0, off=3722, siz=4, lab1=.L1235, lab2=, loff=0
!   reloc[448]: knd=0, off=3730, siz=4, lab1=.L1239, lab2=, loff=0
!   reloc[449]: knd=0, off=3738, siz=4, lab1=.L1243, lab2=, loff=0
!   reloc[450]: knd=0, off=3746, siz=4, lab1=.L1245, lab2=, loff=0
!   reloc[451]: knd=0, off=3754, siz=4, lab1=.L1249, lab2=, loff=0
!   reloc[452]: knd=0, off=3762, siz=4, lab1=.L1251, lab2=, loff=0
!   reloc[453]: knd=0, off=3770, siz=4, lab1=.L1255, lab2=, loff=0
!   reloc[454]: knd=0, off=3778, siz=4, lab1=.L1257, lab2=, loff=0
!   reloc[455]: knd=0, off=3786, siz=4, lab1=.L1261, lab2=, loff=0
!   reloc[456]: knd=0, off=3794, siz=4, lab1=.L1263, lab2=, loff=0
!   reloc[457]: knd=0, off=3802, siz=4, lab1=.L1267, lab2=, loff=0
!   reloc[458]: knd=0, off=3810, siz=4, lab1=.L1269, lab2=, loff=0
!   reloc[459]: knd=0, off=3818, siz=4, lab1=.L1273, lab2=, loff=0
!   reloc[460]: knd=0, off=3826, siz=4, lab1=.L1276, lab2=, loff=0
!   reloc[461]: knd=0, off=3834, siz=4, lab1=.L1283, lab2=, loff=0
!   reloc[462]: knd=0, off=3842, siz=4, lab1=.L1289, lab2=, loff=0
!   reloc[463]: knd=0, off=3850, siz=4, lab1=.L1292, lab2=, loff=0
!   reloc[464]: knd=0, off=3860, siz=4, lab1=.L1294, lab2=, loff=0
!   reloc[465]: knd=0, off=3868, siz=4, lab1=.L1298, lab2=, loff=0
!   reloc[466]: knd=0, off=3876, siz=4, lab1=.L1300, lab2=, loff=0
!   reloc[467]: knd=0, off=3884, siz=4, lab1=.L1304, lab2=, loff=0
!   reloc[468]: knd=0, off=3892, siz=4, lab1=.L1306, lab2=, loff=0
!   reloc[469]: knd=0, off=3900, siz=4, lab1=.L1307, lab2=, loff=0
!   reloc[470]: knd=0, off=3908, siz=4, lab1=.L1309, lab2=, loff=0
!   reloc[471]: knd=0, off=3916, siz=4, lab1=.L1313, lab2=, loff=0
!   reloc[472]: knd=0, off=3924, siz=4, lab1=.L1315, lab2=, loff=0
!   reloc[473]: knd=0, off=3932, siz=4, lab1=.L1319, lab2=, loff=0
!   reloc[474]: knd=0, off=3940, siz=4, lab1=.L1321, lab2=, loff=0
!   reloc[475]: knd=0, off=3948, siz=4, lab1=.L1325, lab2=, loff=0
!   reloc[476]: knd=0, off=3956, siz=4, lab1=.L1327, lab2=, loff=0
!   reloc[477]: knd=0, off=3964, siz=4, lab1=.L1328, lab2=, loff=0
!   reloc[478]: knd=0, off=3972, siz=4, lab1=.L1330, lab2=, loff=0
!   reloc[479]: knd=0, off=3980, siz=4, lab1=.L1331, lab2=, loff=0
!   reloc[480]: knd=0, off=3988, siz=4, lab1=.L1333, lab2=, loff=0
!   reloc[481]: knd=0, off=3996, siz=4, lab1=.L1334, lab2=, loff=0
!   reloc[482]: knd=0, off=4004, siz=4, lab1=.L1336, lab2=, loff=0
!   reloc[483]: knd=0, off=4012, siz=4, lab1=.L1340, lab2=, loff=0
!   reloc[484]: knd=0, off=4020, siz=4, lab1=.L1344, lab2=, loff=0
!   reloc[485]: knd=0, off=4028, siz=4, lab1=.L1348, lab2=, loff=0
!   reloc[486]: knd=0, off=4036, siz=4, lab1=.L1352, lab2=, loff=0
!   reloc[487]: knd=0, off=4044, siz=4, lab1=.L1354, lab2=, loff=0
!   reloc[488]: knd=0, off=4052, siz=4, lab1=.L1358, lab2=, loff=0
!   reloc[489]: knd=0, off=4060, siz=4, lab1=.L1360, lab2=, loff=0
!   reloc[490]: knd=0, off=4068, siz=4, lab1=.L1364, lab2=, loff=0
!   reloc[491]: knd=0, off=4076, siz=4, lab1=.L1366, lab2=, loff=0
!   reloc[492]: knd=0, off=4084, siz=4, lab1=.L1370, lab2=, loff=0
!   reloc[493]: knd=0, off=4092, siz=4, lab1=.L1372, lab2=, loff=0
!   reloc[494]: knd=0, off=4100, siz=4, lab1=.L1376, lab2=, loff=0
!   reloc[495]: knd=0, off=4108, siz=4, lab1=.L1378, lab2=, loff=0
!   reloc[496]: knd=0, off=4116, siz=4, lab1=.L1382, lab2=, loff=0
!   reloc[497]: knd=0, off=4124, siz=4, lab1=.L1384, lab2=, loff=0
!   reloc[498]: knd=0, off=4132, siz=4, lab1=.L1385, lab2=, loff=0
!   reloc[499]: knd=0, off=4140, siz=4, lab1=.L1387, lab2=, loff=0
!   reloc[500]: knd=0, off=4148, siz=4, lab1=.L1391, lab2=, loff=0
!   reloc[501]: knd=0, off=4156, siz=4, lab1=.L1393, lab2=, loff=0
!   reloc[502]: knd=0, off=4164, siz=4, lab1=.L1397, lab2=, loff=0
!   reloc[503]: knd=0, off=4172, siz=4, lab1=.L1399, lab2=, loff=0
!   reloc[504]: knd=0, off=4180, siz=4, lab1=.L1400, lab2=, loff=0
!   reloc[505]: knd=0, off=4188, siz=4, lab1=.L1402, lab2=, loff=0
!   reloc[506]: knd=0, off=4196, siz=4, lab1=.L1406, lab2=, loff=0
!   reloc[507]: knd=0, off=4204, siz=4, lab1=.L1408, lab2=, loff=0
!   reloc[508]: knd=0, off=4212, siz=4, lab1=.L1412, lab2=, loff=0
!   reloc[509]: knd=0, off=4220, siz=4, lab1=.L1414, lab2=, loff=0
!   reloc[510]: knd=0, off=4228, siz=4, lab1=.L1418, lab2=, loff=0
!   reloc[511]: knd=0, off=4236, siz=4, lab1=.L1420, lab2=, loff=0
!   reloc[512]: knd=0, off=4244, siz=4, lab1=.L1421, lab2=, loff=0
!   reloc[513]: knd=0, off=4252, siz=4, lab1=.L1423, lab2=, loff=0
!   reloc[514]: knd=0, off=4260, siz=4, lab1=.L1427, lab2=, loff=0
!   reloc[515]: knd=0, off=4268, siz=4, lab1=.L1429, lab2=, loff=0
!   reloc[516]: knd=0, off=4276, siz=4, lab1=.L1433, lab2=, loff=0
!   reloc[517]: knd=0, off=4284, siz=4, lab1=.L1435, lab2=, loff=0
!   reloc[518]: knd=0, off=4292, siz=4, lab1=.L1436, lab2=, loff=0
!   reloc[519]: knd=0, off=4300, siz=4, lab1=.L1438, lab2=, loff=0
!   reloc[520]: knd=0, off=4308, siz=4, lab1=.L1442, lab2=, loff=0
!   reloc[521]: knd=0, off=4316, siz=4, lab1=.L1444, lab2=, loff=0
!   reloc[522]: knd=0, off=4324, siz=4, lab1=.L1448, lab2=, loff=0
!   reloc[523]: knd=0, off=4332, siz=4, lab1=.L1450, lab2=, loff=0
!   reloc[524]: knd=0, off=4340, siz=4, lab1=.L1454, lab2=, loff=0
!   reloc[525]: knd=0, off=4348, siz=4, lab1=.L1456, lab2=, loff=0
!   reloc[526]: knd=0, off=4356, siz=4, lab1=.L1457, lab2=, loff=0
!   reloc[527]: knd=0, off=4364, siz=4, lab1=.L1459, lab2=, loff=0
!   reloc[528]: knd=0, off=4372, siz=4, lab1=.L1463, lab2=, loff=0
!   reloc[529]: knd=0, off=4380, siz=4, lab1=.L1465, lab2=, loff=0
!   reloc[530]: knd=0, off=4388, siz=4, lab1=.L1466, lab2=, loff=0
!   reloc[531]: knd=0, off=4396, siz=4, lab1=.L1468, lab2=, loff=0
!   reloc[532]: knd=0, off=4404, siz=4, lab1=.L1472, lab2=, loff=0
!   reloc[533]: knd=0, off=4412, siz=4, lab1=.L1474, lab2=, loff=0
!   reloc[534]: knd=0, off=4420, siz=4, lab1=.L1478, lab2=, loff=0
!   reloc[535]: knd=0, off=4428, siz=4, lab1=.L1480, lab2=, loff=0
!   reloc[536]: knd=0, off=4436, siz=4, lab1=.L1484, lab2=, loff=0
!   reloc[537]: knd=0, off=4444, siz=4, lab1=.L1486, lab2=, loff=0
!   reloc[538]: knd=0, off=4452, siz=4, lab1=.L1490, lab2=, loff=0
!   reloc[539]: knd=0, off=4463, siz=4, lab1=.L1493, lab2=, loff=0
!   reloc[540]: knd=0, off=4479, siz=4, lab1=gl_GetDoublev, lab2=, loff=0
!   reloc[541]: knd=0, off=4486, siz=4, lab1=.L1502, lab2=, loff=0
!   reloc[542]: knd=0, off=4498, siz=4, lab1=.L1506, lab2=, loff=0
!   reloc[543]: knd=0, off=4506, siz=4, lab1=.L1508, lab2=, loff=0
!   reloc[544]: knd=0, off=4514, siz=4, lab1=.L1515, lab2=, loff=0
!   reloc[545]: knd=0, off=4524, siz=4, lab1=.L1522, lab2=, loff=0
!   reloc[546]: knd=0, off=4534, siz=4, lab1=.L1523, lab2=, loff=0
!   reloc[547]: knd=0, off=4542, siz=4, lab1=.L1525, lab2=, loff=0
!   reloc[548]: knd=0, off=4550, siz=4, lab1=.L1526, lab2=, loff=0
!   reloc[549]: knd=0, off=4558, siz=4, lab1=.L1527, lab2=, loff=0
!   reloc[550]: knd=0, off=4566, siz=4, lab1=.L1528, lab2=, loff=0
!   reloc[551]: knd=0, off=4574, siz=4, lab1=.L1529, lab2=, loff=0
!   reloc[552]: knd=0, off=4582, siz=4, lab1=.L1531, lab2=, loff=0
!   reloc[553]: knd=0, off=4590, siz=4, lab1=.L1532, lab2=, loff=0
!   reloc[554]: knd=0, off=4598, siz=4, lab1=.L1534, lab2=, loff=0
!   reloc[555]: knd=0, off=4606, siz=4, lab1=.L1535, lab2=, loff=0
!   reloc[556]: knd=0, off=4614, siz=4, lab1=.L1537, lab2=, loff=0
!   reloc[557]: knd=0, off=4622, siz=4, lab1=.L1538, lab2=, loff=0
!   reloc[558]: knd=0, off=4630, siz=4, lab1=.L1540, lab2=, loff=0
!   reloc[559]: knd=0, off=4638, siz=4, lab1=.L1541, lab2=, loff=0
!   reloc[560]: knd=0, off=4646, siz=4, lab1=.L1543, lab2=, loff=0
!   reloc[561]: knd=0, off=4654, siz=4, lab1=.L1544, lab2=, loff=0
!   reloc[562]: knd=0, off=4662, siz=4, lab1=.L1546, lab2=, loff=0
!   reloc[563]: knd=0, off=4670, siz=4, lab1=.L1547, lab2=, loff=0
!   reloc[564]: knd=0, off=4678, siz=4, lab1=.L1549, lab2=, loff=0
!   reloc[565]: knd=0, off=4686, siz=4, lab1=.L1550, lab2=, loff=0
!   reloc[566]: knd=0, off=4694, siz=4, lab1=.L1552, lab2=, loff=0
!   reloc[567]: knd=0, off=4702, siz=4, lab1=.L1553, lab2=, loff=0
!   reloc[568]: knd=0, off=4710, siz=4, lab1=.L1555, lab2=, loff=0
!   reloc[569]: knd=0, off=4718, siz=4, lab1=.L1556, lab2=, loff=0
!   reloc[570]: knd=0, off=4726, siz=4, lab1=.L1558, lab2=, loff=0
!   reloc[571]: knd=0, off=4734, siz=4, lab1=.L1559, lab2=, loff=0
!   reloc[572]: knd=0, off=4742, siz=4, lab1=.L1561, lab2=, loff=0
!   reloc[573]: knd=0, off=4750, siz=4, lab1=.L1562, lab2=, loff=0
!   reloc[574]: knd=0, off=4758, siz=4, lab1=.L1564, lab2=, loff=0
!   reloc[575]: knd=0, off=4766, siz=4, lab1=.L1565, lab2=, loff=0
!   reloc[576]: knd=0, off=4774, siz=4, lab1=.L1567, lab2=, loff=0
!   reloc[577]: knd=0, off=4782, siz=4, lab1=.L1568, lab2=, loff=0
!   reloc[578]: knd=0, off=4790, siz=4, lab1=.L1570, lab2=, loff=0
!   reloc[579]: knd=0, off=4798, siz=4, lab1=.L1571, lab2=, loff=0
!   reloc[580]: knd=0, off=4806, siz=4, lab1=.L1572, lab2=, loff=0
!   reloc[581]: knd=0, off=4814, siz=4, lab1=.L1573, lab2=, loff=0
!   reloc[582]: knd=0, off=4822, siz=4, lab1=.L1574, lab2=, loff=0
!   reloc[583]: knd=0, off=4830, siz=4, lab1=.L1576, lab2=, loff=0
!   reloc[584]: knd=0, off=4838, siz=4, lab1=.L1577, lab2=, loff=0
!   reloc[585]: knd=0, off=4846, siz=4, lab1=.L1579, lab2=, loff=0
!   reloc[586]: knd=0, off=4854, siz=4, lab1=.L1580, lab2=, loff=0
!   reloc[587]: knd=0, off=4862, siz=4, lab1=.L1582, lab2=, loff=0
!   reloc[588]: knd=0, off=4870, siz=4, lab1=.L1583, lab2=, loff=0
!   reloc[589]: knd=0, off=4878, siz=4, lab1=.L1585, lab2=, loff=0
!   reloc[590]: knd=0, off=4886, siz=4, lab1=.L1586, lab2=, loff=0
!   reloc[591]: knd=0, off=4894, siz=4, lab1=.L1593, lab2=, loff=0
!   reloc[592]: knd=0, off=4904, siz=4, lab1=.L1594, lab2=, loff=0
!   reloc[593]: knd=0, off=4912, siz=4, lab1=.L1596, lab2=, loff=0
!   reloc[594]: knd=0, off=4920, siz=4, lab1=.L1597, lab2=, loff=0
!   reloc[595]: knd=0, off=4928, siz=4, lab1=.L1598, lab2=, loff=0
!   reloc[596]: knd=0, off=4936, siz=4, lab1=.L1599, lab2=, loff=0
!   reloc[597]: knd=0, off=4944, siz=4, lab1=.L1600, lab2=, loff=0
!   reloc[598]: knd=0, off=4952, siz=4, lab1=.L1602, lab2=, loff=0
!   reloc[599]: knd=0, off=4960, siz=4, lab1=.L1603, lab2=, loff=0
!   reloc[600]: knd=0, off=4968, siz=4, lab1=.L1605, lab2=, loff=0
!   reloc[601]: knd=0, off=4976, siz=4, lab1=.L1606, lab2=, loff=0
!   reloc[602]: knd=0, off=4984, siz=4, lab1=.L1608, lab2=, loff=0
!   reloc[603]: knd=0, off=4992, siz=4, lab1=.L1609, lab2=, loff=0
!   reloc[604]: knd=0, off=5000, siz=4, lab1=.L1611, lab2=, loff=0
!   reloc[605]: knd=0, off=5008, siz=4, lab1=.L1615, lab2=, loff=0
!   reloc[606]: knd=0, off=5016, siz=4, lab1=.L1619, lab2=, loff=0
!   reloc[607]: knd=0, off=5024, siz=4, lab1=.L1623, lab2=, loff=0
!   reloc[608]: knd=0, off=5032, siz=4, lab1=.L1627, lab2=, loff=0
!   reloc[609]: knd=0, off=5040, siz=4, lab1=.L1629, lab2=, loff=0
!   reloc[610]: knd=0, off=5048, siz=4, lab1=.L1630, lab2=, loff=0
!   reloc[611]: knd=0, off=5056, siz=4, lab1=.L1632, lab2=, loff=0
!   reloc[612]: knd=0, off=5064, siz=4, lab1=.L1633, lab2=, loff=0
!   reloc[613]: knd=0, off=5072, siz=4, lab1=.L1635, lab2=, loff=0
!   reloc[614]: knd=0, off=5080, siz=4, lab1=.L1636, lab2=, loff=0
!   reloc[615]: knd=0, off=5088, siz=4, lab1=.L1637, lab2=, loff=0
!   reloc[616]: knd=0, off=5096, siz=4, lab1=.L1638, lab2=, loff=0
!   reloc[617]: knd=0, off=5104, siz=4, lab1=.L1639, lab2=, loff=0
!   reloc[618]: knd=0, off=5112, siz=4, lab1=.L1641, lab2=, loff=0
!   reloc[619]: knd=0, off=5120, siz=4, lab1=.L1642, lab2=, loff=0
!   reloc[620]: knd=0, off=5128, siz=4, lab1=.L1644, lab2=, loff=0
!   reloc[621]: knd=0, off=5136, siz=4, lab1=.L1645, lab2=, loff=0
!   reloc[622]: knd=0, off=5144, siz=4, lab1=.L1646, lab2=, loff=0
!   reloc[623]: knd=0, off=5152, siz=4, lab1=.L1647, lab2=, loff=0
!   reloc[624]: knd=0, off=5160, siz=4, lab1=.L1649, lab2=, loff=0
!   reloc[625]: knd=0, off=5168, siz=4, lab1=.L1650, lab2=, loff=0
!   reloc[626]: knd=0, off=5176, siz=4, lab1=.L1651, lab2=, loff=0
!   reloc[627]: knd=0, off=5184, siz=4, lab1=.L1652, lab2=, loff=0
!   reloc[628]: knd=0, off=5192, siz=4, lab1=.L1653, lab2=, loff=0
!   reloc[629]: knd=0, off=5200, siz=4, lab1=.L1655, lab2=, loff=0
!   reloc[630]: knd=0, off=5208, siz=4, lab1=.L1656, lab2=, loff=0
!   reloc[631]: knd=0, off=5216, siz=4, lab1=.L1658, lab2=, loff=0
!   reloc[632]: knd=0, off=5224, siz=4, lab1=.L1659, lab2=, loff=0
!   reloc[633]: knd=0, off=5232, siz=4, lab1=.L1661, lab2=, loff=0
!   reloc[634]: knd=0, off=5240, siz=4, lab1=.L1662, lab2=, loff=0
!   reloc[635]: knd=0, off=5248, siz=4, lab1=.L1663, lab2=, loff=0
!   reloc[636]: knd=0, off=5256, siz=4, lab1=.L1664, lab2=, loff=0
!   reloc[637]: knd=0, off=5264, siz=4, lab1=.L1665, lab2=, loff=0
!   reloc[638]: knd=0, off=5272, siz=4, lab1=.L1667, lab2=, loff=0
!   reloc[639]: knd=0, off=5280, siz=4, lab1=.L1668, lab2=, loff=0
!   reloc[640]: knd=0, off=5288, siz=4, lab1=.L1669, lab2=, loff=0
!   reloc[641]: knd=0, off=5296, siz=4, lab1=.L1670, lab2=, loff=0
!   reloc[642]: knd=0, off=5304, siz=4, lab1=.L1671, lab2=, loff=0
!   reloc[643]: knd=0, off=5312, siz=4, lab1=.L1673, lab2=, loff=0
!   reloc[644]: knd=0, off=5320, siz=4, lab1=.L1674, lab2=, loff=0
!   reloc[645]: knd=0, off=5328, siz=4, lab1=.L1676, lab2=, loff=0
!   reloc[646]: knd=0, off=5336, siz=4, lab1=.L1677, lab2=, loff=0
!   reloc[647]: knd=0, off=5344, siz=4, lab1=.L1678, lab2=, loff=0
!   reloc[648]: knd=0, off=5352, siz=4, lab1=.L1679, lab2=, loff=0
!   reloc[649]: knd=0, off=5360, siz=4, lab1=.L1680, lab2=, loff=0
!   reloc[650]: knd=0, off=5368, siz=4, lab1=.L1682, lab2=, loff=0
!   reloc[651]: knd=0, off=5376, siz=4, lab1=.L1683, lab2=, loff=0
!   reloc[652]: knd=0, off=5384, siz=4, lab1=.L1685, lab2=, loff=0
!   reloc[653]: knd=0, off=5392, siz=4, lab1=.L1686, lab2=, loff=0
!   reloc[654]: knd=0, off=5400, siz=4, lab1=.L1688, lab2=, loff=0
!   reloc[655]: knd=0, off=5408, siz=4, lab1=.L1689, lab2=, loff=0
!   reloc[656]: knd=0, off=5416, siz=4, lab1=.L1691, lab2=, loff=0
!   reloc[657]: knd=0, off=5424, siz=4, lab1=.L1692, lab2=, loff=0
!   reloc[658]: knd=0, off=5432, siz=4, lab1=.L1694, lab2=, loff=0
!   reloc[659]: knd=0, off=5440, siz=4, lab1=.L1695, lab2=, loff=0
!   reloc[660]: knd=0, off=5448, siz=4, lab1=.L1696, lab2=, loff=0
!   reloc[661]: knd=0, off=5456, siz=4, lab1=.L1698, lab2=, loff=0
!   reloc[662]: knd=0, off=5464, siz=4, lab1=.L1699, lab2=, loff=0
!   reloc[663]: knd=0, off=5472, siz=4, lab1=.L1701, lab2=, loff=0
!   reloc[664]: knd=0, off=5480, siz=4, lab1=.L1702, lab2=, loff=0
!   reloc[665]: knd=0, off=5488, siz=4, lab1=.L1704, lab2=, loff=0
!   reloc[666]: knd=0, off=5496, siz=4, lab1=.L1705, lab2=, loff=0
!   reloc[667]: knd=0, off=5504, siz=4, lab1=.L1707, lab2=, loff=0
!   reloc[668]: knd=0, off=5512, siz=4, lab1=.L1708, lab2=, loff=0
!   reloc[669]: knd=0, off=5520, siz=4, lab1=.L1710, lab2=, loff=0
!   reloc[670]: knd=0, off=5528, siz=4, lab1=.L1711, lab2=, loff=0
!   reloc[671]: knd=0, off=5536, siz=4, lab1=.L1713, lab2=, loff=0
!   reloc[672]: knd=0, off=5544, siz=4, lab1=.L1714, lab2=, loff=0
!   reloc[673]: knd=0, off=5552, siz=4, lab1=.L1716, lab2=, loff=0
!   reloc[674]: knd=0, off=5560, siz=4, lab1=.L1717, lab2=, loff=0
!   reloc[675]: knd=0, off=5568, siz=4, lab1=.L1719, lab2=, loff=0
!   reloc[676]: knd=0, off=5578, siz=4, lab1=.L1720, lab2=, loff=0
!   reloc[677]: knd=0, off=5586, siz=4, lab1=.L1722, lab2=, loff=0
!   reloc[678]: knd=0, off=5594, siz=4, lab1=.L1723, lab2=, loff=0
!   reloc[679]: knd=0, off=5602, siz=4, lab1=.L1725, lab2=, loff=0
!   reloc[680]: knd=0, off=5610, siz=4, lab1=.L1726, lab2=, loff=0
!   reloc[681]: knd=0, off=5618, siz=4, lab1=.L1728, lab2=, loff=0
!   reloc[682]: knd=0, off=5626, siz=4, lab1=.L1729, lab2=, loff=0
!   reloc[683]: knd=0, off=5634, siz=4, lab1=.L1730, lab2=, loff=0
!   reloc[684]: knd=0, off=5642, siz=4, lab1=.L1731, lab2=, loff=0
!   reloc[685]: knd=0, off=5650, siz=4, lab1=.L1732, lab2=, loff=0
!   reloc[686]: knd=0, off=5658, siz=4, lab1=.L1734, lab2=, loff=0
!   reloc[687]: knd=0, off=5666, siz=4, lab1=.L1735, lab2=, loff=0
!   reloc[688]: knd=0, off=5674, siz=4, lab1=.L1737, lab2=, loff=0
!   reloc[689]: knd=0, off=5682, siz=4, lab1=.L1738, lab2=, loff=0
!   reloc[690]: knd=0, off=5690, siz=4, lab1=.L1740, lab2=, loff=0
!   reloc[691]: knd=0, off=5698, siz=4, lab1=.L1741, lab2=, loff=0
!   reloc[692]: knd=0, off=5706, siz=4, lab1=.L1743, lab2=, loff=0
!   reloc[693]: knd=0, off=5714, siz=4, lab1=.L1744, lab2=, loff=0
!   reloc[694]: knd=0, off=5722, siz=4, lab1=.L1746, lab2=, loff=0
!   reloc[695]: knd=0, off=5730, siz=4, lab1=.L1747, lab2=, loff=0
!   reloc[696]: knd=0, off=5738, siz=4, lab1=.L1749, lab2=, loff=0
!   reloc[697]: knd=0, off=5746, siz=4, lab1=.L1750, lab2=, loff=0
!   reloc[698]: knd=0, off=5754, siz=4, lab1=.L1752, lab2=, loff=0
!   reloc[699]: knd=0, off=5762, siz=4, lab1=.L1753, lab2=, loff=0
!   reloc[700]: knd=0, off=5770, siz=4, lab1=.L1755, lab2=, loff=0
!   reloc[701]: knd=0, off=5778, siz=4, lab1=.L1756, lab2=, loff=0
!   reloc[702]: knd=0, off=5786, siz=4, lab1=.L1758, lab2=, loff=0
!   reloc[703]: knd=0, off=5794, siz=4, lab1=.L1759, lab2=, loff=0
!   reloc[704]: knd=0, off=5802, siz=4, lab1=.L1761, lab2=, loff=0
!   reloc[705]: knd=0, off=5810, siz=4, lab1=.L1762, lab2=, loff=0
!   reloc[706]: knd=0, off=5818, siz=4, lab1=.L1764, lab2=, loff=0
!   reloc[707]: knd=0, off=5826, siz=4, lab1=.L1765, lab2=, loff=0
!   reloc[708]: knd=0, off=5834, siz=4, lab1=.L1767, lab2=, loff=0
!   reloc[709]: knd=0, off=5842, siz=4, lab1=.L1768, lab2=, loff=0
!   reloc[710]: knd=0, off=5850, siz=4, lab1=.L1770, lab2=, loff=0
!   reloc[711]: knd=0, off=5858, siz=4, lab1=.L1774, lab2=, loff=0
!   reloc[712]: knd=0, off=5866, siz=4, lab1=.L1776, lab2=, loff=0
!   reloc[713]: knd=0, off=5874, siz=4, lab1=.L1777, lab2=, loff=0
!   reloc[714]: knd=0, off=5882, siz=4, lab1=.L1779, lab2=, loff=0
!   reloc[715]: knd=0, off=5890, siz=4, lab1=.L1780, lab2=, loff=0
!   reloc[716]: knd=0, off=5898, siz=4, lab1=.L1782, lab2=, loff=0
!   reloc[717]: knd=0, off=5906, siz=4, lab1=.L1783, lab2=, loff=0
!   reloc[718]: knd=0, off=5914, siz=4, lab1=.L1792, lab2=, loff=0
!   reloc[719]: knd=0, off=5924, siz=4, lab1=.L1793, lab2=, loff=0
!   reloc[720]: knd=0, off=5932, siz=4, lab1=.L1795, lab2=, loff=0
!   reloc[721]: knd=0, off=5940, siz=4, lab1=.L1796, lab2=, loff=0
!   reloc[722]: knd=0, off=5948, siz=4, lab1=.L1798, lab2=, loff=0
!   reloc[723]: knd=0, off=5956, siz=4, lab1=.L1799, lab2=, loff=0
!   reloc[724]: knd=0, off=5964, siz=4, lab1=.L1800, lab2=, loff=0
!   reloc[725]: knd=0, off=5972, siz=4, lab1=.L1801, lab2=, loff=0
!   reloc[726]: knd=0, off=5980, siz=4, lab1=.L1802, lab2=, loff=0
!   reloc[727]: knd=0, off=5988, siz=4, lab1=.L1804, lab2=, loff=0
!   reloc[728]: knd=0, off=5996, siz=4, lab1=.L1805, lab2=, loff=0
!   reloc[729]: knd=0, off=6004, siz=4, lab1=.L1807, lab2=, loff=0
!   reloc[730]: knd=0, off=6012, siz=4, lab1=.L1808, lab2=, loff=0
!   reloc[731]: knd=0, off=6020, siz=4, lab1=.L1810, lab2=, loff=0
!   reloc[732]: knd=0, off=6028, siz=4, lab1=.L1811, lab2=, loff=0
!   reloc[733]: knd=0, off=6036, siz=4, lab1=.L1813, lab2=, loff=0
!   reloc[734]: knd=0, off=6044, siz=4, lab1=.L1814, lab2=, loff=0
!   reloc[735]: knd=0, off=6052, siz=4, lab1=.L1816, lab2=, loff=0
!   reloc[736]: knd=0, off=6060, siz=4, lab1=.L1817, lab2=, loff=0
!   reloc[737]: knd=0, off=6068, siz=4, lab1=.L1819, lab2=, loff=0
!   reloc[738]: knd=0, off=6076, siz=4, lab1=.L1820, lab2=, loff=0
!   reloc[739]: knd=0, off=6084, siz=4, lab1=.L1822, lab2=, loff=0
!   reloc[740]: knd=0, off=6092, siz=4, lab1=.L1823, lab2=, loff=0
!   reloc[741]: knd=0, off=6100, siz=4, lab1=.L1825, lab2=, loff=0
!   reloc[742]: knd=0, off=6108, siz=4, lab1=.L1826, lab2=, loff=0
!   reloc[743]: knd=0, off=6116, siz=4, lab1=.L1828, lab2=, loff=0
!   reloc[744]: knd=0, off=6124, siz=4, lab1=.L1829, lab2=, loff=0
!   reloc[745]: knd=0, off=6132, siz=4, lab1=.L1831, lab2=, loff=0
!   reloc[746]: knd=0, off=6140, siz=4, lab1=.L1832, lab2=, loff=0
!   reloc[747]: knd=0, off=6148, siz=4, lab1=.L1833, lab2=, loff=0
!   reloc[748]: knd=0, off=6156, siz=4, lab1=.L1835, lab2=, loff=0
!   reloc[749]: knd=0, off=6164, siz=4, lab1=.L1836, lab2=, loff=0
!   reloc[750]: knd=0, off=6172, siz=4, lab1=.L1838, lab2=, loff=0
!   reloc[751]: knd=0, off=6180, siz=4, lab1=.L1839, lab2=, loff=0
!   reloc[752]: knd=0, off=6188, siz=4, lab1=.L1841, lab2=, loff=0
!   reloc[753]: knd=0, off=6198, siz=4, lab1=.L1845, lab2=, loff=0
!   reloc[754]: knd=0, off=6206, siz=4, lab1=.L1847, lab2=, loff=0
!   reloc[755]: knd=0, off=6214, siz=4, lab1=.L1848, lab2=, loff=0
!   reloc[756]: knd=0, off=6222, siz=4, lab1=.L1850, lab2=, loff=0
!   reloc[757]: knd=0, off=6230, siz=4, lab1=.L1851, lab2=, loff=0
!   reloc[758]: knd=0, off=6238, siz=4, lab1=.L1853, lab2=, loff=0
!   reloc[759]: knd=0, off=6246, siz=4, lab1=.L1854, lab2=, loff=0
!   reloc[760]: knd=0, off=6254, siz=4, lab1=.L1856, lab2=, loff=0
!   reloc[761]: knd=0, off=6262, siz=4, lab1=.L1857, lab2=, loff=0
!   reloc[762]: knd=0, off=6270, siz=4, lab1=.L1859, lab2=, loff=0
!   reloc[763]: knd=0, off=6278, siz=4, lab1=.L1860, lab2=, loff=0
!   reloc[764]: knd=0, off=6286, siz=4, lab1=.L1861, lab2=, loff=0
!   reloc[765]: knd=0, off=6294, siz=4, lab1=.L1863, lab2=, loff=0
!   reloc[766]: knd=0, off=6302, siz=4, lab1=.L1864, lab2=, loff=0
!   reloc[767]: knd=0, off=6310, siz=4, lab1=.L1866, lab2=, loff=0
!   reloc[768]: knd=0, off=6318, siz=4, lab1=.L1867, lab2=, loff=0
!   reloc[769]: knd=0, off=6326, siz=4, lab1=.L1869, lab2=, loff=0
!   reloc[770]: knd=0, off=6334, siz=4, lab1=.L1870, lab2=, loff=0
!   reloc[771]: knd=0, off=6342, siz=4, lab1=.L1872, lab2=, loff=0
!   reloc[772]: knd=0, off=6350, siz=4, lab1=.L1873, lab2=, loff=0
!   reloc[773]: knd=0, off=6358, siz=4, lab1=.L1875, lab2=, loff=0
!   reloc[774]: knd=0, off=6366, siz=4, lab1=.L1876, lab2=, loff=0
!   reloc[775]: knd=0, off=6374, siz=4, lab1=.L1878, lab2=, loff=0
!   reloc[776]: knd=0, off=6382, siz=4, lab1=.L1879, lab2=, loff=0
!   reloc[777]: knd=0, off=6390, siz=4, lab1=.L1881, lab2=, loff=0
!   reloc[778]: knd=0, off=6398, siz=4, lab1=.L1882, lab2=, loff=0
!   reloc[779]: knd=0, off=6406, siz=4, lab1=.L1884, lab2=, loff=0
!   reloc[780]: knd=0, off=6414, siz=4, lab1=.L1885, lab2=, loff=0
!   reloc[781]: knd=0, off=6422, siz=4, lab1=.L1887, lab2=, loff=0
!   reloc[782]: knd=0, off=6430, siz=4, lab1=.L1888, lab2=, loff=0
!   reloc[783]: knd=0, off=6438, siz=4, lab1=.L1890, lab2=, loff=0
!   reloc[784]: knd=0, off=6446, siz=4, lab1=.L1891, lab2=, loff=0
!   reloc[785]: knd=0, off=6454, siz=4, lab1=.L1893, lab2=, loff=0
!   reloc[786]: knd=0, off=6462, siz=4, lab1=.L1894, lab2=, loff=0
!   reloc[787]: knd=0, off=6470, siz=4, lab1=.L1895, lab2=, loff=0
!   reloc[788]: knd=0, off=6478, siz=4, lab1=.L1896, lab2=, loff=0
!   reloc[789]: knd=0, off=6486, siz=4, lab1=.L1897, lab2=, loff=0
!   reloc[790]: knd=0, off=6494, siz=4, lab1=.L1899, lab2=, loff=0
!   reloc[791]: knd=0, off=6502, siz=4, lab1=.L1900, lab2=, loff=0
!   reloc[792]: knd=0, off=6510, siz=4, lab1=.L1901, lab2=, loff=0
!   reloc[793]: knd=0, off=6518, siz=4, lab1=.L1903, lab2=, loff=0
!   reloc[794]: knd=0, off=6526, siz=4, lab1=.L1904, lab2=, loff=0
!   reloc[795]: knd=0, off=6534, siz=4, lab1=.L1906, lab2=, loff=0
!   reloc[796]: knd=0, off=6542, siz=4, lab1=.L1907, lab2=, loff=0
!   reloc[797]: knd=0, off=6550, siz=4, lab1=.L1909, lab2=, loff=0
!   reloc[798]: knd=0, off=6558, siz=4, lab1=.L1910, lab2=, loff=0
!   reloc[799]: knd=0, off=6566, siz=4, lab1=.L1912, lab2=, loff=0
!   reloc[800]: knd=0, off=6574, siz=4, lab1=.L1913, lab2=, loff=0
!   reloc[801]: knd=0, off=6582, siz=4, lab1=.L1915, lab2=, loff=0
!   reloc[802]: knd=0, off=6590, siz=4, lab1=.L1916, lab2=, loff=0
!   reloc[803]: knd=0, off=6598, siz=4, lab1=.L1918, lab2=, loff=0
!   reloc[804]: knd=0, off=6606, siz=4, lab1=.L1919, lab2=, loff=0
!   reloc[805]: knd=0, off=6614, siz=4, lab1=.L1921, lab2=, loff=0
!   reloc[806]: knd=0, off=6622, siz=4, lab1=.L1922, lab2=, loff=0
!   reloc[807]: knd=0, off=6630, siz=4, lab1=.L1924, lab2=, loff=0
!   reloc[808]: knd=0, off=6638, siz=4, lab1=.L1925, lab2=, loff=0
!   reloc[809]: knd=0, off=6646, siz=4, lab1=.L1927, lab2=, loff=0
!   reloc[810]: knd=0, off=6654, siz=4, lab1=.L1928, lab2=, loff=0
!   reloc[811]: knd=0, off=6662, siz=4, lab1=.L1930, lab2=, loff=0
!   reloc[812]: knd=0, off=6670, siz=4, lab1=.L1931, lab2=, loff=0
!   reloc[813]: knd=0, off=6678, siz=4, lab1=.L1933, lab2=, loff=0
!   reloc[814]: knd=0, off=6686, siz=4, lab1=.L1934, lab2=, loff=0
!   reloc[815]: knd=0, off=6694, siz=4, lab1=.L1936, lab2=, loff=0
!   reloc[816]: knd=0, off=6702, siz=4, lab1=.L1937, lab2=, loff=0
!   reloc[817]: knd=0, off=6710, siz=4, lab1=.L1939, lab2=, loff=0
!   reloc[818]: knd=0, off=6718, siz=4, lab1=.L1940, lab2=, loff=0
!   reloc[819]: knd=0, off=6726, siz=4, lab1=.L1942, lab2=, loff=0
!   reloc[820]: knd=0, off=6734, siz=4, lab1=.L1943, lab2=, loff=0
!   reloc[821]: knd=0, off=6742, siz=4, lab1=.L1945, lab2=, loff=0
!   reloc[822]: knd=0, off=6750, siz=4, lab1=.L1946, lab2=, loff=0
!   reloc[823]: knd=0, off=6758, siz=4, lab1=.L1948, lab2=, loff=0
!   reloc[824]: knd=0, off=6766, siz=4, lab1=.L1949, lab2=, loff=0
!   reloc[825]: knd=0, off=6774, siz=4, lab1=.L1951, lab2=, loff=0
!   reloc[826]: knd=0, off=6782, siz=4, lab1=.L1952, lab2=, loff=0
!   reloc[827]: knd=0, off=6790, siz=4, lab1=.L1954, lab2=, loff=0
!   reloc[828]: knd=0, off=6798, siz=4, lab1=.L1955, lab2=, loff=0
!   reloc[829]: knd=0, off=6806, siz=4, lab1=.L1957, lab2=, loff=0
!   reloc[830]: knd=0, off=6814, siz=4, lab1=.L1958, lab2=, loff=0
!   reloc[831]: knd=0, off=6822, siz=4, lab1=.L1960, lab2=, loff=0
!   reloc[832]: knd=0, off=6830, siz=4, lab1=.L1961, lab2=, loff=0
!   reloc[833]: knd=0, off=6838, siz=4, lab1=.L1963, lab2=, loff=0
!   reloc[834]: knd=0, off=6846, siz=4, lab1=.L1964, lab2=, loff=0
!   reloc[835]: knd=0, off=6854, siz=4, lab1=.L1966, lab2=, loff=0
!   reloc[836]: knd=0, off=6862, siz=4, lab1=.L1967, lab2=, loff=0
!   reloc[837]: knd=0, off=6870, siz=4, lab1=.L1969, lab2=, loff=0
!   reloc[838]: knd=0, off=6878, siz=4, lab1=.L1970, lab2=, loff=0
!   reloc[839]: knd=0, off=6886, siz=4, lab1=.L1972, lab2=, loff=0
!   reloc[840]: knd=0, off=6894, siz=4, lab1=.L1973, lab2=, loff=0
!   reloc[841]: knd=0, off=6902, siz=4, lab1=.L1974, lab2=, loff=0
!   reloc[842]: knd=0, off=6910, siz=4, lab1=.L1977, lab2=, loff=0
!   reloc[843]: knd=0, off=6918, siz=4, lab1=.L1984, lab2=, loff=0
!   reloc[844]: knd=0, off=6926, siz=4, lab1=.L1987, lab2=, loff=0
!   reloc[845]: knd=0, off=6934, siz=4, lab1=.L1990, lab2=, loff=0
!   reloc[846]: knd=0, off=6944, siz=4, lab1=.L1992, lab2=, loff=0
!   reloc[847]: knd=0, off=6952, siz=4, lab1=.L1993, lab2=, loff=0
!   reloc[848]: knd=0, off=6960, siz=4, lab1=.L1995, lab2=, loff=0
!   reloc[849]: knd=0, off=6968, siz=4, lab1=.L1996, lab2=, loff=0
!   reloc[850]: knd=0, off=6976, siz=4, lab1=.L1998, lab2=, loff=0
!   reloc[851]: knd=0, off=6984, siz=4, lab1=.L1999, lab2=, loff=0
!   reloc[852]: knd=0, off=6992, siz=4, lab1=.L2001, lab2=, loff=0
!   reloc[853]: knd=0, off=7000, siz=4, lab1=.L2002, lab2=, loff=0
!   reloc[854]: knd=0, off=7008, siz=4, lab1=.L2004, lab2=, loff=0
!   reloc[855]: knd=0, off=7016, siz=4, lab1=.L2005, lab2=, loff=0
!   reloc[856]: knd=0, off=7024, siz=4, lab1=.L2007, lab2=, loff=0
!   reloc[857]: knd=0, off=7032, siz=4, lab1=.L2008, lab2=, loff=0
!   reloc[858]: knd=0, off=7040, siz=4, lab1=.L2010, lab2=, loff=0
!   reloc[859]: knd=0, off=7048, siz=4, lab1=.L2011, lab2=, loff=0
!   reloc[860]: knd=0, off=7056, siz=4, lab1=.L2013, lab2=, loff=0
!   reloc[861]: knd=0, off=7064, siz=4, lab1=.L2014, lab2=, loff=0
!   reloc[862]: knd=0, off=7072, siz=4, lab1=.L2016, lab2=, loff=0
!   reloc[863]: knd=0, off=7080, siz=4, lab1=.L2017, lab2=, loff=0
!   reloc[864]: knd=0, off=7088, siz=4, lab1=.L2019, lab2=, loff=0
!   reloc[865]: knd=0, off=7096, siz=4, lab1=.L2020, lab2=, loff=0
!   reloc[866]: knd=0, off=7104, siz=4, lab1=.L2022, lab2=, loff=0
!   reloc[867]: knd=0, off=7112, siz=4, lab1=.L2023, lab2=, loff=0
!   reloc[868]: knd=0, off=7120, siz=4, lab1=.L2025, lab2=, loff=0
!   reloc[869]: knd=0, off=7128, siz=4, lab1=.L2026, lab2=, loff=0
!   reloc[870]: knd=0, off=7136, siz=4, lab1=.L2028, lab2=, loff=0
!   reloc[871]: knd=0, off=7144, siz=4, lab1=.L2029, lab2=, loff=0
!   reloc[872]: knd=0, off=7152, siz=4, lab1=.L2031, lab2=, loff=0
!   reloc[873]: knd=0, off=7160, siz=4, lab1=.L2032, lab2=, loff=0
!   reloc[874]: knd=0, off=7168, siz=4, lab1=.L2034, lab2=, loff=0
!   reloc[875]: knd=0, off=7176, siz=4, lab1=.L2035, lab2=, loff=0
!   reloc[876]: knd=0, off=7184, siz=4, lab1=.L2037, lab2=, loff=0
!   reloc[877]: knd=0, off=7192, siz=4, lab1=.L2038, lab2=, loff=0
!   reloc[878]: knd=0, off=7200, siz=4, lab1=.L2040, lab2=, loff=0
!   reloc[879]: knd=0, off=7208, siz=4, lab1=.L2041, lab2=, loff=0
!   reloc[880]: knd=0, off=7216, siz=4, lab1=.L2043, lab2=, loff=0
!   reloc[881]: knd=0, off=7224, siz=4, lab1=.L2044, lab2=, loff=0
!   reloc[882]: knd=0, off=7232, siz=4, lab1=.L2046, lab2=, loff=0
!   reloc[883]: knd=0, off=7240, siz=4, lab1=.L2047, lab2=, loff=0
!   reloc[884]: knd=0, off=7248, siz=4, lab1=.L2049, lab2=, loff=0
!   reloc[885]: knd=0, off=7256, siz=4, lab1=.L2050, lab2=, loff=0
!   reloc[886]: knd=0, off=7264, siz=4, lab1=.L2052, lab2=, loff=0
!   reloc[887]: knd=0, off=7272, siz=4, lab1=.L2053, lab2=, loff=0
!   reloc[888]: knd=0, off=7280, siz=4, lab1=.L2055, lab2=, loff=0
!   reloc[889]: knd=0, off=7288, siz=4, lab1=.L2056, lab2=, loff=0
!   reloc[890]: knd=0, off=7296, siz=4, lab1=.L2058, lab2=, loff=0
!   reloc[891]: knd=0, off=7304, siz=4, lab1=.L2059, lab2=, loff=0
!   reloc[892]: knd=0, off=7312, siz=4, lab1=.L2061, lab2=, loff=0
!   reloc[893]: knd=0, off=7320, siz=4, lab1=.L2062, lab2=, loff=0
!   reloc[894]: knd=0, off=7328, siz=4, lab1=.L2064, lab2=, loff=0
!   reloc[895]: knd=0, off=7336, siz=4, lab1=.L2065, lab2=, loff=0
!   reloc[896]: knd=0, off=7344, siz=4, lab1=.L2066, lab2=, loff=0
!   reloc[897]: knd=0, off=7352, siz=4, lab1=.L2068, lab2=, loff=0
!   reloc[898]: knd=0, off=7360, siz=4, lab1=.L2069, lab2=, loff=0
!   reloc[899]: knd=0, off=7368, siz=4, lab1=.L2071, lab2=, loff=0
!   reloc[900]: knd=0, off=7376, siz=4, lab1=.L2072, lab2=, loff=0
!   reloc[901]: knd=0, off=7384, siz=4, lab1=.L2074, lab2=, loff=0
!   reloc[902]: knd=0, off=7392, siz=4, lab1=.L2075, lab2=, loff=0
!   reloc[903]: knd=0, off=7400, siz=4, lab1=.L2077, lab2=, loff=0
!   reloc[904]: knd=0, off=7408, siz=4, lab1=.L2078, lab2=, loff=0
!   reloc[905]: knd=0, off=7416, siz=4, lab1=.L2080, lab2=, loff=0
!   reloc[906]: knd=0, off=7424, siz=4, lab1=.L2081, lab2=, loff=0
!   reloc[907]: knd=0, off=7432, siz=4, lab1=.L2083, lab2=, loff=0
!   reloc[908]: knd=0, off=7440, siz=4, lab1=.L2084, lab2=, loff=0
!   reloc[909]: knd=0, off=7448, siz=4, lab1=.L2085, lab2=, loff=0
!   reloc[910]: knd=0, off=7456, siz=4, lab1=.L2086, lab2=, loff=0
!   reloc[911]: knd=0, off=7464, siz=4, lab1=.L2088, lab2=, loff=0
!   reloc[912]: knd=0, off=7472, siz=4, lab1=.L2089, lab2=, loff=0
!   reloc[913]: knd=0, off=7480, siz=4, lab1=.L2090, lab2=, loff=0
!   reloc[914]: knd=0, off=7488, siz=4, lab1=.L2092, lab2=, loff=0
!   reloc[915]: knd=0, off=7498, siz=4, lab1=.L2093, lab2=, loff=0
!   reloc[916]: knd=0, off=7506, siz=4, lab1=.L2095, lab2=, loff=0
!   reloc[917]: knd=0, off=7516, siz=4, lab1=.L2096, lab2=, loff=0
!   reloc[918]: knd=0, off=7524, siz=4, lab1=.L2098, lab2=, loff=0
!   reloc[919]: knd=0, off=7532, siz=4, lab1=.L2099, lab2=, loff=0
!   reloc[920]: knd=0, off=7540, siz=4, lab1=.L2101, lab2=, loff=0
!   reloc[921]: knd=0, off=7548, siz=4, lab1=.L2102, lab2=, loff=0
!   reloc[922]: knd=0, off=7556, siz=4, lab1=.L2104, lab2=, loff=0
!   reloc[923]: knd=0, off=7564, siz=4, lab1=.L2105, lab2=, loff=0
!   reloc[924]: knd=0, off=7572, siz=4, lab1=.L2108, lab2=, loff=0
!   reloc[925]: knd=0, off=7580, siz=4, lab1=.L2115, lab2=, loff=0
!   reloc[926]: knd=0, off=7588, siz=4, lab1=.L2118, lab2=, loff=0
!   reloc[927]: knd=0, off=7596, siz=4, lab1=.L2121, lab2=, loff=0
!   reloc[928]: knd=0, off=7606, siz=4, lab1=.L2124, lab2=, loff=0
!   reloc[929]: knd=0, off=7614, siz=4, lab1=.L2131, lab2=, loff=0
!   reloc[930]: knd=0, off=7622, siz=4, lab1=.L2134, lab2=, loff=0
!   reloc[931]: knd=0, off=7630, siz=4, lab1=.L2137, lab2=, loff=0
!   reloc[932]: knd=0, off=7640, siz=4, lab1=.L2139, lab2=, loff=0
!   reloc[933]: knd=0, off=7648, siz=4, lab1=.L2140, lab2=, loff=0
!   reloc[934]: knd=0, off=7656, siz=4, lab1=.L2142, lab2=, loff=0
!   reloc[935]: knd=0, off=7664, siz=4, lab1=.L2143, lab2=, loff=0
!   reloc[936]: knd=0, off=7672, siz=4, lab1=.L2145, lab2=, loff=0
!   reloc[937]: knd=0, off=7680, siz=4, lab1=.L2146, lab2=, loff=0
!   reloc[938]: knd=0, off=7688, siz=4, lab1=.L2148, lab2=, loff=0
!   reloc[939]: knd=0, off=7696, siz=4, lab1=.L2149, lab2=, loff=0
!   reloc[940]: knd=0, off=7704, siz=4, lab1=.L2151, lab2=, loff=0
!   reloc[941]: knd=0, off=7712, siz=4, lab1=.L2152, lab2=, loff=0
!   reloc[942]: knd=0, off=7720, siz=4, lab1=.L2154, lab2=, loff=0
!   reloc[943]: knd=0, off=7728, siz=4, lab1=.L2155, lab2=, loff=0
!   reloc[944]: knd=0, off=7736, siz=4, lab1=.L2157, lab2=, loff=0
!   reloc[945]: knd=0, off=7744, siz=4, lab1=.L2158, lab2=, loff=0
!   reloc[946]: knd=0, off=7752, siz=4, lab1=.L2160, lab2=, loff=0
!   reloc[947]: knd=0, off=7760, siz=4, lab1=.L2161, lab2=, loff=0
!   reloc[948]: knd=0, off=7768, siz=4, lab1=.L2162, lab2=, loff=0
!   reloc[949]: knd=0, off=7776, siz=4, lab1=.L2163, lab2=, loff=0
!   reloc[950]: knd=0, off=7784, siz=4, lab1=.L2164, lab2=, loff=0
!   reloc[951]: knd=0, off=7792, siz=4, lab1=.L2166, lab2=, loff=0
!   reloc[952]: knd=0, off=7800, siz=4, lab1=.L2167, lab2=, loff=0
!   reloc[953]: knd=0, off=7808, siz=4, lab1=.L2169, lab2=, loff=0
!   reloc[954]: knd=0, off=7816, siz=4, lab1=.L2170, lab2=, loff=0
!   reloc[955]: knd=0, off=7824, siz=4, lab1=.L2172, lab2=, loff=0
!   reloc[956]: knd=0, off=7832, siz=4, lab1=.L2173, lab2=, loff=0
!   reloc[957]: knd=0, off=7840, siz=4, lab1=.L2175, lab2=, loff=0
!   reloc[958]: knd=0, off=7848, siz=4, lab1=.L2176, lab2=, loff=0
!   reloc[959]: knd=0, off=7856, siz=4, lab1=.L2178, lab2=, loff=0
!   reloc[960]: knd=0, off=7864, siz=4, lab1=.L2179, lab2=, loff=0
!   reloc[961]: knd=0, off=7872, siz=4, lab1=.L2181, lab2=, loff=0
!   reloc[962]: knd=0, off=7880, siz=4, lab1=.L2182, lab2=, loff=0
!   reloc[963]: knd=0, off=7888, siz=4, lab1=.L2184, lab2=, loff=0
!   reloc[964]: knd=0, off=7896, siz=4, lab1=.L2185, lab2=, loff=0
!   reloc[965]: knd=0, off=7904, siz=4, lab1=.L2187, lab2=, loff=0
!   reloc[966]: knd=0, off=7912, siz=4, lab1=.L2188, lab2=, loff=0
!   reloc[967]: knd=0, off=7920, siz=4, lab1=.L2190, lab2=, loff=0
!   reloc[968]: knd=0, off=7928, siz=4, lab1=.L2191, lab2=, loff=0
!   reloc[969]: knd=0, off=7936, siz=4, lab1=.L2193, lab2=, loff=0
!   reloc[970]: knd=0, off=7944, siz=4, lab1=.L2194, lab2=, loff=0
!   reloc[971]: knd=0, off=7952, siz=4, lab1=.L2196, lab2=, loff=0
!   reloc[972]: knd=0, off=7960, siz=4, lab1=.L2197, lab2=, loff=0
!   reloc[973]: knd=0, off=7968, siz=4, lab1=.L2199, lab2=, loff=0
!   reloc[974]: knd=0, off=7976, siz=4, lab1=.L2200, lab2=, loff=0
!   reloc[975]: knd=0, off=7984, siz=4, lab1=.L2202, lab2=, loff=0
!   reloc[976]: knd=0, off=7992, siz=4, lab1=.L2203, lab2=, loff=0
!   reloc[977]: knd=0, off=8000, siz=4, lab1=.L2205, lab2=, loff=0
!   reloc[978]: knd=0, off=8008, siz=4, lab1=.L2206, lab2=, loff=0
!   reloc[979]: knd=0, off=8016, siz=4, lab1=.L2208, lab2=, loff=0
!   reloc[980]: knd=0, off=8024, siz=4, lab1=.L2209, lab2=, loff=0
!   reloc[981]: knd=0, off=8032, siz=4, lab1=.L2211, lab2=, loff=0
!   reloc[982]: knd=0, off=8040, siz=4, lab1=.L2215, lab2=, loff=0
!   reloc[983]: knd=0, off=8048, siz=4, lab1=.L2217, lab2=, loff=0
!   reloc[984]: knd=0, off=8056, siz=4, lab1=.L2221, lab2=, loff=0
!   reloc[985]: knd=0, off=8064, siz=4, lab1=.L2223, lab2=, loff=0
!   reloc[986]: knd=0, off=8072, siz=4, lab1=.L2227, lab2=, loff=0
!   reloc[987]: knd=0, off=8080, siz=4, lab1=.L2229, lab2=, loff=0
!   reloc[988]: knd=0, off=8088, siz=4, lab1=.L2230, lab2=, loff=0
!   reloc[989]: knd=0, off=8096, siz=4, lab1=.L2231, lab2=, loff=0
!   reloc[990]: knd=0, off=8104, siz=4, lab1=.L2232, lab2=, loff=0
!   reloc[991]: knd=0, off=8112, siz=4, lab1=.L2233, lab2=, loff=0
!   reloc[992]: knd=0, off=8120, siz=4, lab1=.L2235, lab2=, loff=0
!   reloc[993]: knd=0, off=8128, siz=4, lab1=.L2236, lab2=, loff=0
!   reloc[994]: knd=0, off=8136, siz=4, lab1=.L2238, lab2=, loff=0
!   reloc[995]: knd=0, off=8144, siz=4, lab1=.L2242, lab2=, loff=0
!   reloc[996]: knd=0, off=8152, siz=4, lab1=.L2244, lab2=, loff=0
!   reloc[997]: knd=0, off=8160, siz=4, lab1=.L2248, lab2=, loff=0
!   reloc[998]: knd=0, off=8168, siz=4, lab1=.L2250, lab2=, loff=0
!   reloc[999]: knd=0, off=8176, siz=4, lab1=.L2254, lab2=, loff=0
!   reloc[1000]: knd=0, off=8184, siz=4, lab1=.L2256, lab2=, loff=0
!   reloc[1001]: knd=0, off=8192, siz=4, lab1=.L2260, lab2=, loff=0
!   reloc[1002]: knd=0, off=8200, siz=4, lab1=.L2263, lab2=, loff=0
!   reloc[1003]: knd=0, off=8208, siz=4, lab1=.L2270, lab2=, loff=0
!   reloc[1004]: knd=0, off=8216, siz=4, lab1=.L2273, lab2=, loff=0
!   reloc[1005]: knd=0, off=8224, siz=4, lab1=.L2276, lab2=, loff=0
!   reloc[1006]: knd=0, off=8234, siz=4, lab1=.L2278, lab2=, loff=0
!   reloc[1007]: knd=0, off=8242, siz=4, lab1=.L2279, lab2=, loff=0
!   reloc[1008]: knd=0, off=8250, siz=4, lab1=.L2281, lab2=, loff=0
!   reloc[1009]: knd=0, off=8258, siz=4, lab1=.L2282, lab2=, loff=0
!   reloc[1010]: knd=0, off=8266, siz=4, lab1=.L2284, lab2=, loff=0
!   reloc[1011]: knd=0, off=8274, siz=4, lab1=.L2285, lab2=, loff=0
!   reloc[1012]: knd=0, off=8282, siz=4, lab1=.L2287, lab2=, loff=0
!   reloc[1013]: knd=0, off=8290, siz=4, lab1=.L2288, lab2=, loff=0
!   reloc[1014]: knd=0, off=8298, siz=4, lab1=.L2290, lab2=, loff=0
!   reloc[1015]: knd=0, off=8306, siz=4, lab1=.L2291, lab2=, loff=0
!   reloc[1016]: knd=0, off=8314, siz=4, lab1=.L2293, lab2=, loff=0
!   reloc[1017]: knd=0, off=8322, siz=4, lab1=.L2294, lab2=, loff=0
!   reloc[1018]: knd=0, off=8330, siz=4, lab1=.L2296, lab2=, loff=0
!   reloc[1019]: knd=0, off=8338, siz=4, lab1=.L2297, lab2=, loff=0
!   reloc[1020]: knd=0, off=8346, siz=4, lab1=.L2299, lab2=, loff=0
!   reloc[1021]: knd=0, off=8354, siz=4, lab1=.L2300, lab2=, loff=0
!   reloc[1022]: knd=0, off=8362, siz=4, lab1=.L2302, lab2=, loff=0
!   reloc[1023]: knd=0, off=8370, siz=4, lab1=.L2303, lab2=, loff=0
!   reloc[1024]: knd=0, off=8378, siz=4, lab1=.L2305, lab2=, loff=0
!   reloc[1025]: knd=0, off=8386, siz=4, lab1=.L2306, lab2=, loff=0
!   reloc[1026]: knd=0, off=8394, siz=4, lab1=.L2307, lab2=, loff=0
!   reloc[1027]: knd=0, off=8402, siz=4, lab1=.L2308, lab2=, loff=0
!   reloc[1028]: knd=0, off=8410, siz=4, lab1=.L2309, lab2=, loff=0
!   reloc[1029]: knd=0, off=8418, siz=4, lab1=.L2311, lab2=, loff=0
!   reloc[1030]: knd=0, off=8426, siz=4, lab1=.L2312, lab2=, loff=0
!   reloc[1031]: knd=0, off=8434, siz=4, lab1=.L2314, lab2=, loff=0
!   reloc[1032]: knd=0, off=8442, siz=4, lab1=.L2315, lab2=, loff=0
!   reloc[1033]: knd=0, off=8450, siz=4, lab1=.L2317, lab2=, loff=0
!   reloc[1034]: knd=0, off=8458, siz=4, lab1=.L2318, lab2=, loff=0
!   reloc[1035]: knd=0, off=8466, siz=4, lab1=.L2320, lab2=, loff=0
!   reloc[1036]: knd=0, off=8474, siz=4, lab1=.L2321, lab2=, loff=0
!   reloc[1037]: knd=0, off=8482, siz=4, lab1=.L2323, lab2=, loff=0
!   reloc[1038]: knd=0, off=8490, siz=4, lab1=.L2324, lab2=, loff=0
!   reloc[1039]: knd=0, off=8498, siz=4, lab1=.L2326, lab2=, loff=0
!   reloc[1040]: knd=0, off=8506, siz=4, lab1=.L2327, lab2=, loff=0
!   reloc[1041]: knd=0, off=8514, siz=4, lab1=.L2329, lab2=, loff=0
!   reloc[1042]: knd=0, off=8522, siz=4, lab1=.L2330, lab2=, loff=0
!   reloc[1043]: knd=0, off=8530, siz=4, lab1=.L2332, lab2=, loff=0
!   reloc[1044]: knd=0, off=8538, siz=4, lab1=.L2333, lab2=, loff=0
!   reloc[1045]: knd=0, off=8546, siz=4, lab1=.L2335, lab2=, loff=0
!   reloc[1046]: knd=0, off=8554, siz=4, lab1=.L2336, lab2=, loff=0
!   reloc[1047]: knd=0, off=8562, siz=4, lab1=.L2338, lab2=, loff=0
!   reloc[1048]: knd=0, off=8570, siz=4, lab1=.L2339, lab2=, loff=0
!   reloc[1049]: knd=0, off=8578, siz=4, lab1=.L2341, lab2=, loff=0
!   reloc[1050]: knd=0, off=8586, siz=4, lab1=.L2342, lab2=, loff=0
!   reloc[1051]: knd=0, off=8594, siz=4, lab1=.L2344, lab2=, loff=0
!   reloc[1052]: knd=0, off=8602, siz=4, lab1=.L2345, lab2=, loff=0
!   reloc[1053]: knd=0, off=8610, siz=4, lab1=.L2347, lab2=, loff=0
!   reloc[1054]: knd=0, off=8618, siz=4, lab1=.L2348, lab2=, loff=0
!   reloc[1055]: knd=0, off=8626, siz=4, lab1=.L2350, lab2=, loff=0
!   reloc[1056]: knd=0, off=8634, siz=4, lab1=.L2351, lab2=, loff=0
!   reloc[1057]: knd=0, off=8642, siz=4, lab1=.L2353, lab2=, loff=0
!   reloc[1058]: knd=0, off=8650, siz=4, lab1=.L2354, lab2=, loff=0
!   reloc[1059]: knd=0, off=8658, siz=4, lab1=.L2356, lab2=, loff=0
!   reloc[1060]: knd=0, off=8666, siz=4, lab1=.L2357, lab2=, loff=0
!   reloc[1061]: knd=0, off=8674, siz=4, lab1=.L2359, lab2=, loff=0
!   reloc[1062]: knd=0, off=8682, siz=4, lab1=.L2360, lab2=, loff=0
!   reloc[1063]: knd=0, off=8690, siz=4, lab1=.L2362, lab2=, loff=0
!   reloc[1064]: knd=0, off=8698, siz=4, lab1=.L2363, lab2=, loff=0
!   reloc[1065]: knd=0, off=8706, siz=4, lab1=.L2365, lab2=, loff=0
!   reloc[1066]: knd=0, off=8714, siz=4, lab1=.L2366, lab2=, loff=0
!   reloc[1067]: knd=0, off=8722, siz=4, lab1=.L2368, lab2=, loff=0
!   reloc[1068]: knd=0, off=8730, siz=4, lab1=.L2369, lab2=, loff=0
!   reloc[1069]: knd=0, off=8738, siz=4, lab1=.L2371, lab2=, loff=0
!   reloc[1070]: knd=0, off=8746, siz=4, lab1=.L2372, lab2=, loff=0
!   reloc[1071]: knd=0, off=8754, siz=4, lab1=.L2374, lab2=, loff=0
!   reloc[1072]: knd=0, off=8762, siz=4, lab1=.L2375, lab2=, loff=0
!   reloc[1073]: knd=0, off=8770, siz=4, lab1=.L2377, lab2=, loff=0
!   reloc[1074]: knd=0, off=8778, siz=4, lab1=.L2378, lab2=, loff=0
!   reloc[1075]: knd=0, off=8786, siz=4, lab1=.L2380, lab2=, loff=0
!   reloc[1076]: knd=0, off=8794, siz=4, lab1=.L2381, lab2=, loff=0
!   reloc[1077]: knd=0, off=8802, siz=4, lab1=.L2383, lab2=, loff=0
!   reloc[1078]: knd=0, off=8810, siz=4, lab1=.L2384, lab2=, loff=0
!   reloc[1079]: knd=0, off=8818, siz=4, lab1=.L2386, lab2=, loff=0
!   reloc[1080]: knd=0, off=8828, siz=4, lab1=.L2390, lab2=, loff=0
!   reloc[1081]: knd=0, off=8839, siz=4, lab1=.L2393, lab2=, loff=0
!   reloc[1082]: knd=0, off=8855, siz=4, lab1=gl_GetFloatv, lab2=, loff=0
!   reloc[1083]: knd=0, off=8862, siz=4, lab1=.L2402, lab2=, loff=0
!   reloc[1084]: knd=0, off=8874, siz=4, lab1=.L2406, lab2=, loff=0
!   reloc[1085]: knd=0, off=8882, siz=4, lab1=.L2408, lab2=, loff=0
!   reloc[1086]: knd=0, off=8890, siz=4, lab1=.L2415, lab2=, loff=0
!   reloc[1087]: knd=0, off=8898, siz=4, lab1=.L2422, lab2=, loff=0
!   reloc[1088]: knd=0, off=8908, siz=4, lab1=.L2423, lab2=, loff=0
!   reloc[1089]: knd=0, off=8916, siz=4, lab1=.L2425, lab2=, loff=0
!   reloc[1090]: knd=0, off=8924, siz=4, lab1=.L2426, lab2=, loff=0
!   reloc[1091]: knd=0, off=8932, siz=4, lab1=.L2427, lab2=, loff=0
!   reloc[1092]: knd=0, off=8940, siz=4, lab1=.L2428, lab2=, loff=0
!   reloc[1093]: knd=0, off=8948, siz=4, lab1=.L2429, lab2=, loff=0
!   reloc[1094]: knd=0, off=8956, siz=4, lab1=.L2431, lab2=, loff=0
!   reloc[1095]: knd=0, off=8964, siz=4, lab1=.L2432, lab2=, loff=0
!   reloc[1096]: knd=0, off=8972, siz=4, lab1=.L2434, lab2=, loff=0
!   reloc[1097]: knd=0, off=8980, siz=4, lab1=.L2435, lab2=, loff=0
!   reloc[1098]: knd=0, off=8988, siz=4, lab1=.L2437, lab2=, loff=0
!   reloc[1099]: knd=0, off=8996, siz=4, lab1=.L2438, lab2=, loff=0
!   reloc[1100]: knd=0, off=9004, siz=4, lab1=.L2440, lab2=, loff=0
!   reloc[1101]: knd=0, off=9012, siz=4, lab1=.L2441, lab2=, loff=0
!   reloc[1102]: knd=0, off=9020, siz=4, lab1=.L2443, lab2=, loff=0
!   reloc[1103]: knd=0, off=9028, siz=4, lab1=.L2444, lab2=, loff=0
!   reloc[1104]: knd=0, off=9036, siz=4, lab1=.L2446, lab2=, loff=0
!   reloc[1105]: knd=0, off=9044, siz=4, lab1=.L2447, lab2=, loff=0
!   reloc[1106]: knd=0, off=9052, siz=4, lab1=.L2449, lab2=, loff=0
!   reloc[1107]: knd=0, off=9060, siz=4, lab1=.L2450, lab2=, loff=0
!   reloc[1108]: knd=0, off=9068, siz=4, lab1=.L2452, lab2=, loff=0
!   reloc[1109]: knd=0, off=9076, siz=4, lab1=.L2453, lab2=, loff=0
!   reloc[1110]: knd=0, off=9084, siz=4, lab1=.L2455, lab2=, loff=0
!   reloc[1111]: knd=0, off=9092, siz=4, lab1=.L2456, lab2=, loff=0
!   reloc[1112]: knd=0, off=9100, siz=4, lab1=.L2458, lab2=, loff=0
!   reloc[1113]: knd=0, off=9108, siz=4, lab1=.L2459, lab2=, loff=0
!   reloc[1114]: knd=0, off=9116, siz=4, lab1=.L2461, lab2=, loff=0
!   reloc[1115]: knd=0, off=9124, siz=4, lab1=.L2462, lab2=, loff=0
!   reloc[1116]: knd=0, off=9132, siz=4, lab1=.L2464, lab2=, loff=0
!   reloc[1117]: knd=0, off=9140, siz=4, lab1=.L2465, lab2=, loff=0
!   reloc[1118]: knd=0, off=9148, siz=4, lab1=.L2467, lab2=, loff=0
!   reloc[1119]: knd=0, off=9156, siz=4, lab1=.L2468, lab2=, loff=0
!   reloc[1120]: knd=0, off=9164, siz=4, lab1=.L2470, lab2=, loff=0
!   reloc[1121]: knd=0, off=9172, siz=4, lab1=.L2471, lab2=, loff=0
!   reloc[1122]: knd=0, off=9180, siz=4, lab1=.L2472, lab2=, loff=0
!   reloc[1123]: knd=0, off=9188, siz=4, lab1=.L2473, lab2=, loff=0
!   reloc[1124]: knd=0, off=9196, siz=4, lab1=.L2474, lab2=, loff=0
!   reloc[1125]: knd=0, off=9204, siz=4, lab1=.L2476, lab2=, loff=0
!   reloc[1126]: knd=0, off=9212, siz=4, lab1=.L2477, lab2=, loff=0
!   reloc[1127]: knd=0, off=9220, siz=4, lab1=.L2479, lab2=, loff=0
!   reloc[1128]: knd=0, off=9228, siz=4, lab1=.L2480, lab2=, loff=0
!   reloc[1129]: knd=0, off=9236, siz=4, lab1=.L2482, lab2=, loff=0
!   reloc[1130]: knd=0, off=9244, siz=4, lab1=.L2483, lab2=, loff=0
!   reloc[1131]: knd=0, off=9252, siz=4, lab1=.L2485, lab2=, loff=0
!   reloc[1132]: knd=0, off=9260, siz=4, lab1=.L2486, lab2=, loff=0
!   reloc[1133]: knd=0, off=9268, siz=4, lab1=.L2493, lab2=, loff=0
!   reloc[1134]: knd=0, off=9278, siz=4, lab1=.L2494, lab2=, loff=0
!   reloc[1135]: knd=0, off=9286, siz=4, lab1=.L2496, lab2=, loff=0
!   reloc[1136]: knd=0, off=9294, siz=4, lab1=.L2497, lab2=, loff=0
!   reloc[1137]: knd=0, off=9302, siz=4, lab1=.L2498, lab2=, loff=0
!   reloc[1138]: knd=0, off=9310, siz=4, lab1=.L2499, lab2=, loff=0
!   reloc[1139]: knd=0, off=9318, siz=4, lab1=.L2500, lab2=, loff=0
!   reloc[1140]: knd=0, off=9326, siz=4, lab1=.L2502, lab2=, loff=0
!   reloc[1141]: knd=0, off=9334, siz=4, lab1=.L2503, lab2=, loff=0
!   reloc[1142]: knd=0, off=9342, siz=4, lab1=.L2505, lab2=, loff=0
!   reloc[1143]: knd=0, off=9350, siz=4, lab1=.L2506, lab2=, loff=0
!   reloc[1144]: knd=0, off=9358, siz=4, lab1=.L2508, lab2=, loff=0
!   reloc[1145]: knd=0, off=9366, siz=4, lab1=.L2509, lab2=, loff=0
!   reloc[1146]: knd=0, off=9374, siz=4, lab1=.L2511, lab2=, loff=0
!   reloc[1147]: knd=0, off=9382, siz=4, lab1=.L2515, lab2=, loff=0
!   reloc[1148]: knd=0, off=9390, siz=4, lab1=.L2519, lab2=, loff=0
!   reloc[1149]: knd=0, off=9398, siz=4, lab1=.L2523, lab2=, loff=0
!   reloc[1150]: knd=0, off=9406, siz=4, lab1=.L2527, lab2=, loff=0
!   reloc[1151]: knd=0, off=9414, siz=4, lab1=.L2529, lab2=, loff=0
!   reloc[1152]: knd=0, off=9422, siz=4, lab1=.L2530, lab2=, loff=0
!   reloc[1153]: knd=0, off=9430, siz=4, lab1=.L2532, lab2=, loff=0
!   reloc[1154]: knd=0, off=9438, siz=4, lab1=.L2533, lab2=, loff=0
!   reloc[1155]: knd=0, off=9446, siz=4, lab1=.L2535, lab2=, loff=0
!   reloc[1156]: knd=0, off=9454, siz=4, lab1=.L2536, lab2=, loff=0
!   reloc[1157]: knd=0, off=9462, siz=4, lab1=.L2537, lab2=, loff=0
!   reloc[1158]: knd=0, off=9470, siz=4, lab1=.L2538, lab2=, loff=0
!   reloc[1159]: knd=0, off=9478, siz=4, lab1=.L2539, lab2=, loff=0
!   reloc[1160]: knd=0, off=9486, siz=4, lab1=.L2541, lab2=, loff=0
!   reloc[1161]: knd=0, off=9494, siz=4, lab1=.L2542, lab2=, loff=0
!   reloc[1162]: knd=0, off=9502, siz=4, lab1=.L2544, lab2=, loff=0
!   reloc[1163]: knd=0, off=9510, siz=4, lab1=.L2545, lab2=, loff=0
!   reloc[1164]: knd=0, off=9518, siz=4, lab1=.L2546, lab2=, loff=0
!   reloc[1165]: knd=0, off=9526, siz=4, lab1=.L2547, lab2=, loff=0
!   reloc[1166]: knd=0, off=9534, siz=4, lab1=.L2549, lab2=, loff=0
!   reloc[1167]: knd=0, off=9542, siz=4, lab1=.L2550, lab2=, loff=0
!   reloc[1168]: knd=0, off=9550, siz=4, lab1=.L2551, lab2=, loff=0
!   reloc[1169]: knd=0, off=9558, siz=4, lab1=.L2552, lab2=, loff=0
!   reloc[1170]: knd=0, off=9566, siz=4, lab1=.L2553, lab2=, loff=0
!   reloc[1171]: knd=0, off=9574, siz=4, lab1=.L2555, lab2=, loff=0
!   reloc[1172]: knd=0, off=9582, siz=4, lab1=.L2556, lab2=, loff=0
!   reloc[1173]: knd=0, off=9590, siz=4, lab1=.L2558, lab2=, loff=0
!   reloc[1174]: knd=0, off=9598, siz=4, lab1=.L2559, lab2=, loff=0
!   reloc[1175]: knd=0, off=9606, siz=4, lab1=.L2561, lab2=, loff=0
!   reloc[1176]: knd=0, off=9614, siz=4, lab1=.L2562, lab2=, loff=0
!   reloc[1177]: knd=0, off=9622, siz=4, lab1=.L2563, lab2=, loff=0
!   reloc[1178]: knd=0, off=9630, siz=4, lab1=.L2564, lab2=, loff=0
!   reloc[1179]: knd=0, off=9638, siz=4, lab1=.L2565, lab2=, loff=0
!   reloc[1180]: knd=0, off=9646, siz=4, lab1=.L2567, lab2=, loff=0
!   reloc[1181]: knd=0, off=9654, siz=4, lab1=.L2568, lab2=, loff=0
!   reloc[1182]: knd=0, off=9662, siz=4, lab1=.L2569, lab2=, loff=0
!   reloc[1183]: knd=0, off=9670, siz=4, lab1=.L2570, lab2=, loff=0
!   reloc[1184]: knd=0, off=9678, siz=4, lab1=.L2571, lab2=, loff=0
!   reloc[1185]: knd=0, off=9686, siz=4, lab1=.L2573, lab2=, loff=0
!   reloc[1186]: knd=0, off=9694, siz=4, lab1=.L2574, lab2=, loff=0
!   reloc[1187]: knd=0, off=9702, siz=4, lab1=.L2576, lab2=, loff=0
!   reloc[1188]: knd=0, off=9710, siz=4, lab1=.L2577, lab2=, loff=0
!   reloc[1189]: knd=0, off=9718, siz=4, lab1=.L2578, lab2=, loff=0
!   reloc[1190]: knd=0, off=9726, siz=4, lab1=.L2579, lab2=, loff=0
!   reloc[1191]: knd=0, off=9734, siz=4, lab1=.L2580, lab2=, loff=0
!   reloc[1192]: knd=0, off=9742, siz=4, lab1=.L2582, lab2=, loff=0
!   reloc[1193]: knd=0, off=9750, siz=4, lab1=.L2583, lab2=, loff=0
!   reloc[1194]: knd=0, off=9758, siz=4, lab1=.L2585, lab2=, loff=0
!   reloc[1195]: knd=0, off=9766, siz=4, lab1=.L2586, lab2=, loff=0
!   reloc[1196]: knd=0, off=9774, siz=4, lab1=.L2588, lab2=, loff=0
!   reloc[1197]: knd=0, off=9782, siz=4, lab1=.L2589, lab2=, loff=0
!   reloc[1198]: knd=0, off=9790, siz=4, lab1=.L2591, lab2=, loff=0
!   reloc[1199]: knd=0, off=9798, siz=4, lab1=.L2592, lab2=, loff=0
!   reloc[1200]: knd=0, off=9806, siz=4, lab1=.L2594, lab2=, loff=0
!   reloc[1201]: knd=0, off=9814, siz=4, lab1=.L2595, lab2=, loff=0
!   reloc[1202]: knd=0, off=9822, siz=4, lab1=.L2596, lab2=, loff=0
!   reloc[1203]: knd=0, off=9830, siz=4, lab1=.L2598, lab2=, loff=0
!   reloc[1204]: knd=0, off=9838, siz=4, lab1=.L2599, lab2=, loff=0
!   reloc[1205]: knd=0, off=9846, siz=4, lab1=.L2601, lab2=, loff=0
!   reloc[1206]: knd=0, off=9854, siz=4, lab1=.L2602, lab2=, loff=0
!   reloc[1207]: knd=0, off=9862, siz=4, lab1=.L2604, lab2=, loff=0
!   reloc[1208]: knd=0, off=9870, siz=4, lab1=.L2605, lab2=, loff=0
!   reloc[1209]: knd=0, off=9878, siz=4, lab1=.L2607, lab2=, loff=0
!   reloc[1210]: knd=0, off=9886, siz=4, lab1=.L2608, lab2=, loff=0
!   reloc[1211]: knd=0, off=9894, siz=4, lab1=.L2610, lab2=, loff=0
!   reloc[1212]: knd=0, off=9902, siz=4, lab1=.L2611, lab2=, loff=0
!   reloc[1213]: knd=0, off=9910, siz=4, lab1=.L2613, lab2=, loff=0
!   reloc[1214]: knd=0, off=9918, siz=4, lab1=.L2614, lab2=, loff=0
!   reloc[1215]: knd=0, off=9926, siz=4, lab1=.L2616, lab2=, loff=0
!   reloc[1216]: knd=0, off=9934, siz=4, lab1=.L2617, lab2=, loff=0
!   reloc[1217]: knd=0, off=9942, siz=4, lab1=.L2619, lab2=, loff=0
!   reloc[1218]: knd=0, off=9952, siz=4, lab1=.L2620, lab2=, loff=0
!   reloc[1219]: knd=0, off=9960, siz=4, lab1=.L2622, lab2=, loff=0
!   reloc[1220]: knd=0, off=9968, siz=4, lab1=.L2623, lab2=, loff=0
!   reloc[1221]: knd=0, off=9976, siz=4, lab1=.L2625, lab2=, loff=0
!   reloc[1222]: knd=0, off=9984, siz=4, lab1=.L2626, lab2=, loff=0
!   reloc[1223]: knd=0, off=9992, siz=4, lab1=.L2628, lab2=, loff=0
!   reloc[1224]: knd=0, off=10000, siz=4, lab1=.L2629, lab2=, loff=0
!   reloc[1225]: knd=0, off=10008, siz=4, lab1=.L2630, lab2=, loff=0
!   reloc[1226]: knd=0, off=10016, siz=4, lab1=.L2631, lab2=, loff=0
!   reloc[1227]: knd=0, off=10024, siz=4, lab1=.L2632, lab2=, loff=0
!   reloc[1228]: knd=0, off=10032, siz=4, lab1=.L2634, lab2=, loff=0
!   reloc[1229]: knd=0, off=10040, siz=4, lab1=.L2635, lab2=, loff=0
!   reloc[1230]: knd=0, off=10048, siz=4, lab1=.L2637, lab2=, loff=0
!   reloc[1231]: knd=0, off=10056, siz=4, lab1=.L2638, lab2=, loff=0
!   reloc[1232]: knd=0, off=10064, siz=4, lab1=.L2640, lab2=, loff=0
!   reloc[1233]: knd=0, off=10072, siz=4, lab1=.L2641, lab2=, loff=0
!   reloc[1234]: knd=0, off=10080, siz=4, lab1=.L2643, lab2=, loff=0
!   reloc[1235]: knd=0, off=10088, siz=4, lab1=.L2644, lab2=, loff=0
!   reloc[1236]: knd=0, off=10096, siz=4, lab1=.L2646, lab2=, loff=0
!   reloc[1237]: knd=0, off=10104, siz=4, lab1=.L2647, lab2=, loff=0
!   reloc[1238]: knd=0, off=10112, siz=4, lab1=.L2649, lab2=, loff=0
!   reloc[1239]: knd=0, off=10120, siz=4, lab1=.L2650, lab2=, loff=0
!   reloc[1240]: knd=0, off=10128, siz=4, lab1=.L2652, lab2=, loff=0
!   reloc[1241]: knd=0, off=10136, siz=4, lab1=.L2653, lab2=, loff=0
!   reloc[1242]: knd=0, off=10144, siz=4, lab1=.L2655, lab2=, loff=0
!   reloc[1243]: knd=0, off=10152, siz=4, lab1=.L2656, lab2=, loff=0
!   reloc[1244]: knd=0, off=10160, siz=4, lab1=.L2658, lab2=, loff=0
!   reloc[1245]: knd=0, off=10168, siz=4, lab1=.L2659, lab2=, loff=0
!   reloc[1246]: knd=0, off=10176, siz=4, lab1=.L2661, lab2=, loff=0
!   reloc[1247]: knd=0, off=10184, siz=4, lab1=.L2662, lab2=, loff=0
!   reloc[1248]: knd=0, off=10192, siz=4, lab1=.L2664, lab2=, loff=0
!   reloc[1249]: knd=0, off=10200, siz=4, lab1=.L2665, lab2=, loff=0
!   reloc[1250]: knd=0, off=10208, siz=4, lab1=.L2667, lab2=, loff=0
!   reloc[1251]: knd=0, off=10216, siz=4, lab1=.L2668, lab2=, loff=0
!   reloc[1252]: knd=0, off=10224, siz=4, lab1=.L2670, lab2=, loff=0
!   reloc[1253]: knd=0, off=10232, siz=4, lab1=.L2674, lab2=, loff=0
!   reloc[1254]: knd=0, off=10240, siz=4, lab1=.L2676, lab2=, loff=0
!   reloc[1255]: knd=0, off=10248, siz=4, lab1=.L2677, lab2=, loff=0
!   reloc[1256]: knd=0, off=10256, siz=4, lab1=.L2679, lab2=, loff=0
!   reloc[1257]: knd=0, off=10264, siz=4, lab1=.L2680, lab2=, loff=0
!   reloc[1258]: knd=0, off=10272, siz=4, lab1=.L2682, lab2=, loff=0
!   reloc[1259]: knd=0, off=10280, siz=4, lab1=.L2683, lab2=, loff=0
!   reloc[1260]: knd=0, off=10288, siz=4, lab1=.L2692, lab2=, loff=0
!   reloc[1261]: knd=0, off=10298, siz=4, lab1=.L2693, lab2=, loff=0
!   reloc[1262]: knd=0, off=10306, siz=4, lab1=.L2695, lab2=, loff=0
!   reloc[1263]: knd=0, off=10314, siz=4, lab1=.L2696, lab2=, loff=0
!   reloc[1264]: knd=0, off=10322, siz=4, lab1=.L2698, lab2=, loff=0
!   reloc[1265]: knd=0, off=10330, siz=4, lab1=.L2699, lab2=, loff=0
!   reloc[1266]: knd=0, off=10338, siz=4, lab1=.L2700, lab2=, loff=0
!   reloc[1267]: knd=0, off=10346, siz=4, lab1=.L2701, lab2=, loff=0
!   reloc[1268]: knd=0, off=10354, siz=4, lab1=.L2702, lab2=, loff=0
!   reloc[1269]: knd=0, off=10362, siz=4, lab1=.L2704, lab2=, loff=0
!   reloc[1270]: knd=0, off=10370, siz=4, lab1=.L2705, lab2=, loff=0
!   reloc[1271]: knd=0, off=10378, siz=4, lab1=.L2707, lab2=, loff=0
!   reloc[1272]: knd=0, off=10386, siz=4, lab1=.L2708, lab2=, loff=0
!   reloc[1273]: knd=0, off=10394, siz=4, lab1=.L2710, lab2=, loff=0
!   reloc[1274]: knd=0, off=10402, siz=4, lab1=.L2711, lab2=, loff=0
!   reloc[1275]: knd=0, off=10410, siz=4, lab1=.L2713, lab2=, loff=0
!   reloc[1276]: knd=0, off=10418, siz=4, lab1=.L2714, lab2=, loff=0
!   reloc[1277]: knd=0, off=10426, siz=4, lab1=.L2716, lab2=, loff=0
!   reloc[1278]: knd=0, off=10434, siz=4, lab1=.L2717, lab2=, loff=0
!   reloc[1279]: knd=0, off=10442, siz=4, lab1=.L2719, lab2=, loff=0
!   reloc[1280]: knd=0, off=10450, siz=4, lab1=.L2720, lab2=, loff=0
!   reloc[1281]: knd=0, off=10458, siz=4, lab1=.L2722, lab2=, loff=0
!   reloc[1282]: knd=0, off=10466, siz=4, lab1=.L2723, lab2=, loff=0
!   reloc[1283]: knd=0, off=10474, siz=4, lab1=.L2725, lab2=, loff=0
!   reloc[1284]: knd=0, off=10482, siz=4, lab1=.L2726, lab2=, loff=0
!   reloc[1285]: knd=0, off=10490, siz=4, lab1=.L2728, lab2=, loff=0
!   reloc[1286]: knd=0, off=10498, siz=4, lab1=.L2729, lab2=, loff=0
!   reloc[1287]: knd=0, off=10506, siz=4, lab1=.L2731, lab2=, loff=0
!   reloc[1288]: knd=0, off=10514, siz=4, lab1=.L2732, lab2=, loff=0
!   reloc[1289]: knd=0, off=10522, siz=4, lab1=.L2733, lab2=, loff=0
!   reloc[1290]: knd=0, off=10530, siz=4, lab1=.L2735, lab2=, loff=0
!   reloc[1291]: knd=0, off=10538, siz=4, lab1=.L2736, lab2=, loff=0
!   reloc[1292]: knd=0, off=10546, siz=4, lab1=.L2738, lab2=, loff=0
!   reloc[1293]: knd=0, off=10554, siz=4, lab1=.L2739, lab2=, loff=0
!   reloc[1294]: knd=0, off=10562, siz=4, lab1=.L2741, lab2=, loff=0
!   reloc[1295]: knd=0, off=10572, siz=4, lab1=.L2745, lab2=, loff=0
!   reloc[1296]: knd=0, off=10580, siz=4, lab1=.L2747, lab2=, loff=0
!   reloc[1297]: knd=0, off=10588, siz=4, lab1=.L2748, lab2=, loff=0
!   reloc[1298]: knd=0, off=10596, siz=4, lab1=.L2750, lab2=, loff=0
!   reloc[1299]: knd=0, off=10604, siz=4, lab1=.L2751, lab2=, loff=0
!   reloc[1300]: knd=0, off=10612, siz=4, lab1=.L2753, lab2=, loff=0
!   reloc[1301]: knd=0, off=10620, siz=4, lab1=.L2754, lab2=, loff=0
!   reloc[1302]: knd=0, off=10628, siz=4, lab1=.L2756, lab2=, loff=0
!   reloc[1303]: knd=0, off=10636, siz=4, lab1=.L2757, lab2=, loff=0
!   reloc[1304]: knd=0, off=10644, siz=4, lab1=.L2759, lab2=, loff=0
!   reloc[1305]: knd=0, off=10652, siz=4, lab1=.L2760, lab2=, loff=0
!   reloc[1306]: knd=0, off=10660, siz=4, lab1=.L2761, lab2=, loff=0
!   reloc[1307]: knd=0, off=10668, siz=4, lab1=.L2763, lab2=, loff=0
!   reloc[1308]: knd=0, off=10676, siz=4, lab1=.L2764, lab2=, loff=0
!   reloc[1309]: knd=0, off=10684, siz=4, lab1=.L2766, lab2=, loff=0
!   reloc[1310]: knd=0, off=10692, siz=4, lab1=.L2767, lab2=, loff=0
!   reloc[1311]: knd=0, off=10700, siz=4, lab1=.L2769, lab2=, loff=0
!   reloc[1312]: knd=0, off=10708, siz=4, lab1=.L2770, lab2=, loff=0
!   reloc[1313]: knd=0, off=10716, siz=4, lab1=.L2772, lab2=, loff=0
!   reloc[1314]: knd=0, off=10724, siz=4, lab1=.L2773, lab2=, loff=0
!   reloc[1315]: knd=0, off=10732, siz=4, lab1=.L2775, lab2=, loff=0
!   reloc[1316]: knd=0, off=10740, siz=4, lab1=.L2776, lab2=, loff=0
!   reloc[1317]: knd=0, off=10748, siz=4, lab1=.L2778, lab2=, loff=0
!   reloc[1318]: knd=0, off=10756, siz=4, lab1=.L2779, lab2=, loff=0
!   reloc[1319]: knd=0, off=10764, siz=4, lab1=.L2781, lab2=, loff=0
!   reloc[1320]: knd=0, off=10772, siz=4, lab1=.L2782, lab2=, loff=0
!   reloc[1321]: knd=0, off=10780, siz=4, lab1=.L2784, lab2=, loff=0
!   reloc[1322]: knd=0, off=10788, siz=4, lab1=.L2785, lab2=, loff=0
!   reloc[1323]: knd=0, off=10796, siz=4, lab1=.L2787, lab2=, loff=0
!   reloc[1324]: knd=0, off=10804, siz=4, lab1=.L2788, lab2=, loff=0
!   reloc[1325]: knd=0, off=10812, siz=4, lab1=.L2790, lab2=, loff=0
!   reloc[1326]: knd=0, off=10820, siz=4, lab1=.L2791, lab2=, loff=0
!   reloc[1327]: knd=0, off=10828, siz=4, lab1=.L2793, lab2=, loff=0
!   reloc[1328]: knd=0, off=10836, siz=4, lab1=.L2794, lab2=, loff=0
!   reloc[1329]: knd=0, off=10844, siz=4, lab1=.L2795, lab2=, loff=0
!   reloc[1330]: knd=0, off=10852, siz=4, lab1=.L2796, lab2=, loff=0
!   reloc[1331]: knd=0, off=10860, siz=4, lab1=.L2797, lab2=, loff=0
!   reloc[1332]: knd=0, off=10868, siz=4, lab1=.L2799, lab2=, loff=0
!   reloc[1333]: knd=0, off=10876, siz=4, lab1=.L2800, lab2=, loff=0
!   reloc[1334]: knd=0, off=10884, siz=4, lab1=.L2801, lab2=, loff=0
!   reloc[1335]: knd=0, off=10892, siz=4, lab1=.L2803, lab2=, loff=0
!   reloc[1336]: knd=0, off=10900, siz=4, lab1=.L2804, lab2=, loff=0
!   reloc[1337]: knd=0, off=10908, siz=4, lab1=.L2806, lab2=, loff=0
!   reloc[1338]: knd=0, off=10916, siz=4, lab1=.L2807, lab2=, loff=0
!   reloc[1339]: knd=0, off=10924, siz=4, lab1=.L2809, lab2=, loff=0
!   reloc[1340]: knd=0, off=10932, siz=4, lab1=.L2810, lab2=, loff=0
!   reloc[1341]: knd=0, off=10940, siz=4, lab1=.L2812, lab2=, loff=0
!   reloc[1342]: knd=0, off=10948, siz=4, lab1=.L2813, lab2=, loff=0
!   reloc[1343]: knd=0, off=10956, siz=4, lab1=.L2815, lab2=, loff=0
!   reloc[1344]: knd=0, off=10964, siz=4, lab1=.L2816, lab2=, loff=0
!   reloc[1345]: knd=0, off=10972, siz=4, lab1=.L2818, lab2=, loff=0
!   reloc[1346]: knd=0, off=10980, siz=4, lab1=.L2819, lab2=, loff=0
!   reloc[1347]: knd=0, off=10988, siz=4, lab1=.L2821, lab2=, loff=0
!   reloc[1348]: knd=0, off=10996, siz=4, lab1=.L2822, lab2=, loff=0
!   reloc[1349]: knd=0, off=11004, siz=4, lab1=.L2824, lab2=, loff=0
!   reloc[1350]: knd=0, off=11012, siz=4, lab1=.L2825, lab2=, loff=0
!   reloc[1351]: knd=0, off=11020, siz=4, lab1=.L2827, lab2=, loff=0
!   reloc[1352]: knd=0, off=11028, siz=4, lab1=.L2828, lab2=, loff=0
!   reloc[1353]: knd=0, off=11036, siz=4, lab1=.L2830, lab2=, loff=0
!   reloc[1354]: knd=0, off=11044, siz=4, lab1=.L2831, lab2=, loff=0
!   reloc[1355]: knd=0, off=11052, siz=4, lab1=.L2833, lab2=, loff=0
!   reloc[1356]: knd=0, off=11060, siz=4, lab1=.L2834, lab2=, loff=0
!   reloc[1357]: knd=0, off=11068, siz=4, lab1=.L2836, lab2=, loff=0
!   reloc[1358]: knd=0, off=11076, siz=4, lab1=.L2837, lab2=, loff=0
!   reloc[1359]: knd=0, off=11084, siz=4, lab1=.L2839, lab2=, loff=0
!   reloc[1360]: knd=0, off=11092, siz=4, lab1=.L2840, lab2=, loff=0
!   reloc[1361]: knd=0, off=11100, siz=4, lab1=.L2842, lab2=, loff=0
!   reloc[1362]: knd=0, off=11108, siz=4, lab1=.L2843, lab2=, loff=0
!   reloc[1363]: knd=0, off=11116, siz=4, lab1=.L2845, lab2=, loff=0
!   reloc[1364]: knd=0, off=11124, siz=4, lab1=.L2846, lab2=, loff=0
!   reloc[1365]: knd=0, off=11132, siz=4, lab1=.L2848, lab2=, loff=0
!   reloc[1366]: knd=0, off=11140, siz=4, lab1=.L2849, lab2=, loff=0
!   reloc[1367]: knd=0, off=11148, siz=4, lab1=.L2851, lab2=, loff=0
!   reloc[1368]: knd=0, off=11156, siz=4, lab1=.L2852, lab2=, loff=0
!   reloc[1369]: knd=0, off=11164, siz=4, lab1=.L2854, lab2=, loff=0
!   reloc[1370]: knd=0, off=11172, siz=4, lab1=.L2855, lab2=, loff=0
!   reloc[1371]: knd=0, off=11180, siz=4, lab1=.L2857, lab2=, loff=0
!   reloc[1372]: knd=0, off=11188, siz=4, lab1=.L2858, lab2=, loff=0
!   reloc[1373]: knd=0, off=11196, siz=4, lab1=.L2860, lab2=, loff=0
!   reloc[1374]: knd=0, off=11204, siz=4, lab1=.L2861, lab2=, loff=0
!   reloc[1375]: knd=0, off=11212, siz=4, lab1=.L2863, lab2=, loff=0
!   reloc[1376]: knd=0, off=11220, siz=4, lab1=.L2864, lab2=, loff=0
!   reloc[1377]: knd=0, off=11228, siz=4, lab1=.L2866, lab2=, loff=0
!   reloc[1378]: knd=0, off=11236, siz=4, lab1=.L2867, lab2=, loff=0
!   reloc[1379]: knd=0, off=11244, siz=4, lab1=.L2869, lab2=, loff=0
!   reloc[1380]: knd=0, off=11252, siz=4, lab1=.L2870, lab2=, loff=0
!   reloc[1381]: knd=0, off=11260, siz=4, lab1=.L2872, lab2=, loff=0
!   reloc[1382]: knd=0, off=11268, siz=4, lab1=.L2873, lab2=, loff=0
!   reloc[1383]: knd=0, off=11276, siz=4, lab1=.L2874, lab2=, loff=0
!   reloc[1384]: knd=0, off=11284, siz=4, lab1=.L2877, lab2=, loff=0
!   reloc[1385]: knd=0, off=11292, siz=4, lab1=.L2884, lab2=, loff=0
!   reloc[1386]: knd=0, off=11300, siz=4, lab1=.L2887, lab2=, loff=0
!   reloc[1387]: knd=0, off=11308, siz=4, lab1=.L2890, lab2=, loff=0
!   reloc[1388]: knd=0, off=11318, siz=4, lab1=.L2892, lab2=, loff=0
!   reloc[1389]: knd=0, off=11326, siz=4, lab1=.L2893, lab2=, loff=0
!   reloc[1390]: knd=0, off=11334, siz=4, lab1=.L2895, lab2=, loff=0
!   reloc[1391]: knd=0, off=11342, siz=4, lab1=.L2896, lab2=, loff=0
!   reloc[1392]: knd=0, off=11350, siz=4, lab1=.L2898, lab2=, loff=0
!   reloc[1393]: knd=0, off=11358, siz=4, lab1=.L2899, lab2=, loff=0
!   reloc[1394]: knd=0, off=11366, siz=4, lab1=.L2901, lab2=, loff=0
!   reloc[1395]: knd=0, off=11374, siz=4, lab1=.L2902, lab2=, loff=0
!   reloc[1396]: knd=0, off=11382, siz=4, lab1=.L2904, lab2=, loff=0
!   reloc[1397]: knd=0, off=11390, siz=4, lab1=.L2905, lab2=, loff=0
!   reloc[1398]: knd=0, off=11398, siz=4, lab1=.L2907, lab2=, loff=0
!   reloc[1399]: knd=0, off=11406, siz=4, lab1=.L2908, lab2=, loff=0
!   reloc[1400]: knd=0, off=11414, siz=4, lab1=.L2910, lab2=, loff=0
!   reloc[1401]: knd=0, off=11422, siz=4, lab1=.L2911, lab2=, loff=0
!   reloc[1402]: knd=0, off=11430, siz=4, lab1=.L2913, lab2=, loff=0
!   reloc[1403]: knd=0, off=11438, siz=4, lab1=.L2914, lab2=, loff=0
!   reloc[1404]: knd=0, off=11446, siz=4, lab1=.L2916, lab2=, loff=0
!   reloc[1405]: knd=0, off=11454, siz=4, lab1=.L2917, lab2=, loff=0
!   reloc[1406]: knd=0, off=11462, siz=4, lab1=.L2919, lab2=, loff=0
!   reloc[1407]: knd=0, off=11470, siz=4, lab1=.L2920, lab2=, loff=0
!   reloc[1408]: knd=0, off=11478, siz=4, lab1=.L2922, lab2=, loff=0
!   reloc[1409]: knd=0, off=11486, siz=4, lab1=.L2923, lab2=, loff=0
!   reloc[1410]: knd=0, off=11494, siz=4, lab1=.L2925, lab2=, loff=0
!   reloc[1411]: knd=0, off=11502, siz=4, lab1=.L2926, lab2=, loff=0
!   reloc[1412]: knd=0, off=11510, siz=4, lab1=.L2928, lab2=, loff=0
!   reloc[1413]: knd=0, off=11518, siz=4, lab1=.L2929, lab2=, loff=0
!   reloc[1414]: knd=0, off=11526, siz=4, lab1=.L2931, lab2=, loff=0
!   reloc[1415]: knd=0, off=11534, siz=4, lab1=.L2932, lab2=, loff=0
!   reloc[1416]: knd=0, off=11542, siz=4, lab1=.L2934, lab2=, loff=0
!   reloc[1417]: knd=0, off=11550, siz=4, lab1=.L2935, lab2=, loff=0
!   reloc[1418]: knd=0, off=11558, siz=4, lab1=.L2937, lab2=, loff=0
!   reloc[1419]: knd=0, off=11566, siz=4, lab1=.L2938, lab2=, loff=0
!   reloc[1420]: knd=0, off=11574, siz=4, lab1=.L2940, lab2=, loff=0
!   reloc[1421]: knd=0, off=11582, siz=4, lab1=.L2941, lab2=, loff=0
!   reloc[1422]: knd=0, off=11590, siz=4, lab1=.L2943, lab2=, loff=0
!   reloc[1423]: knd=0, off=11598, siz=4, lab1=.L2944, lab2=, loff=0
!   reloc[1424]: knd=0, off=11606, siz=4, lab1=.L2946, lab2=, loff=0
!   reloc[1425]: knd=0, off=11614, siz=4, lab1=.L2947, lab2=, loff=0
!   reloc[1426]: knd=0, off=11622, siz=4, lab1=.L2949, lab2=, loff=0
!   reloc[1427]: knd=0, off=11630, siz=4, lab1=.L2950, lab2=, loff=0
!   reloc[1428]: knd=0, off=11638, siz=4, lab1=.L2952, lab2=, loff=0
!   reloc[1429]: knd=0, off=11646, siz=4, lab1=.L2953, lab2=, loff=0
!   reloc[1430]: knd=0, off=11654, siz=4, lab1=.L2955, lab2=, loff=0
!   reloc[1431]: knd=0, off=11662, siz=4, lab1=.L2956, lab2=, loff=0
!   reloc[1432]: knd=0, off=11670, siz=4, lab1=.L2958, lab2=, loff=0
!   reloc[1433]: knd=0, off=11678, siz=4, lab1=.L2959, lab2=, loff=0
!   reloc[1434]: knd=0, off=11686, siz=4, lab1=.L2961, lab2=, loff=0
!   reloc[1435]: knd=0, off=11694, siz=4, lab1=.L2962, lab2=, loff=0
!   reloc[1436]: knd=0, off=11702, siz=4, lab1=.L2964, lab2=, loff=0
!   reloc[1437]: knd=0, off=11710, siz=4, lab1=.L2965, lab2=, loff=0
!   reloc[1438]: knd=0, off=11718, siz=4, lab1=.L2966, lab2=, loff=0
!   reloc[1439]: knd=0, off=11726, siz=4, lab1=.L2968, lab2=, loff=0
!   reloc[1440]: knd=0, off=11734, siz=4, lab1=.L2969, lab2=, loff=0
!   reloc[1441]: knd=0, off=11742, siz=4, lab1=.L2971, lab2=, loff=0
!   reloc[1442]: knd=0, off=11750, siz=4, lab1=.L2972, lab2=, loff=0
!   reloc[1443]: knd=0, off=11758, siz=4, lab1=.L2974, lab2=, loff=0
!   reloc[1444]: knd=0, off=11766, siz=4, lab1=.L2975, lab2=, loff=0
!   reloc[1445]: knd=0, off=11774, siz=4, lab1=.L2977, lab2=, loff=0
!   reloc[1446]: knd=0, off=11782, siz=4, lab1=.L2978, lab2=, loff=0
!   reloc[1447]: knd=0, off=11790, siz=4, lab1=.L2980, lab2=, loff=0
!   reloc[1448]: knd=0, off=11798, siz=4, lab1=.L2981, lab2=, loff=0
!   reloc[1449]: knd=0, off=11806, siz=4, lab1=.L2983, lab2=, loff=0
!   reloc[1450]: knd=0, off=11814, siz=4, lab1=.L2984, lab2=, loff=0
!   reloc[1451]: knd=0, off=11822, siz=4, lab1=.L2985, lab2=, loff=0
!   reloc[1452]: knd=0, off=11830, siz=4, lab1=.L2986, lab2=, loff=0
!   reloc[1453]: knd=0, off=11838, siz=4, lab1=.L2988, lab2=, loff=0
!   reloc[1454]: knd=0, off=11846, siz=4, lab1=.L2989, lab2=, loff=0
!   reloc[1455]: knd=0, off=11854, siz=4, lab1=.L2990, lab2=, loff=0
!   reloc[1456]: knd=0, off=11862, siz=4, lab1=.L2992, lab2=, loff=0
!   reloc[1457]: knd=0, off=11872, siz=4, lab1=.L2993, lab2=, loff=0
!   reloc[1458]: knd=0, off=11880, siz=4, lab1=.L2995, lab2=, loff=0
!   reloc[1459]: knd=0, off=11890, siz=4, lab1=.L2996, lab2=, loff=0
!   reloc[1460]: knd=0, off=11898, siz=4, lab1=.L2998, lab2=, loff=0
!   reloc[1461]: knd=0, off=11906, siz=4, lab1=.L2999, lab2=, loff=0
!   reloc[1462]: knd=0, off=11914, siz=4, lab1=.L3001, lab2=, loff=0
!   reloc[1463]: knd=0, off=11922, siz=4, lab1=.L3002, lab2=, loff=0
!   reloc[1464]: knd=0, off=11930, siz=4, lab1=.L3004, lab2=, loff=0
!   reloc[1465]: knd=0, off=11938, siz=4, lab1=.L3005, lab2=, loff=0
!   reloc[1466]: knd=0, off=11946, siz=4, lab1=.L3008, lab2=, loff=0
!   reloc[1467]: knd=0, off=11954, siz=4, lab1=.L3015, lab2=, loff=0
!   reloc[1468]: knd=0, off=11962, siz=4, lab1=.L3018, lab2=, loff=0
!   reloc[1469]: knd=0, off=11970, siz=4, lab1=.L3021, lab2=, loff=0
!   reloc[1470]: knd=0, off=11980, siz=4, lab1=.L3024, lab2=, loff=0
!   reloc[1471]: knd=0, off=11988, siz=4, lab1=.L3031, lab2=, loff=0
!   reloc[1472]: knd=0, off=11996, siz=4, lab1=.L3034, lab2=, loff=0
!   reloc[1473]: knd=0, off=12004, siz=4, lab1=.L3037, lab2=, loff=0
!   reloc[1474]: knd=0, off=12014, siz=4, lab1=.L3039, lab2=, loff=0
!   reloc[1475]: knd=0, off=12022, siz=4, lab1=.L3040, lab2=, loff=0
!   reloc[1476]: knd=0, off=12030, siz=4, lab1=.L3042, lab2=, loff=0
!   reloc[1477]: knd=0, off=12038, siz=4, lab1=.L3043, lab2=, loff=0
!   reloc[1478]: knd=0, off=12046, siz=4, lab1=.L3045, lab2=, loff=0
!   reloc[1479]: knd=0, off=12054, siz=4, lab1=.L3046, lab2=, loff=0
!   reloc[1480]: knd=0, off=12062, siz=4, lab1=.L3048, lab2=, loff=0
!   reloc[1481]: knd=0, off=12070, siz=4, lab1=.L3049, lab2=, loff=0
!   reloc[1482]: knd=0, off=12078, siz=4, lab1=.L3051, lab2=, loff=0
!   reloc[1483]: knd=0, off=12086, siz=4, lab1=.L3052, lab2=, loff=0
!   reloc[1484]: knd=0, off=12094, siz=4, lab1=.L3054, lab2=, loff=0
!   reloc[1485]: knd=0, off=12102, siz=4, lab1=.L3055, lab2=, loff=0
!   reloc[1486]: knd=0, off=12110, siz=4, lab1=.L3057, lab2=, loff=0
!   reloc[1487]: knd=0, off=12118, siz=4, lab1=.L3058, lab2=, loff=0
!   reloc[1488]: knd=0, off=12126, siz=4, lab1=.L3060, lab2=, loff=0
!   reloc[1489]: knd=0, off=12134, siz=4, lab1=.L3061, lab2=, loff=0
!   reloc[1490]: knd=0, off=12142, siz=4, lab1=.L3062, lab2=, loff=0
!   reloc[1491]: knd=0, off=12150, siz=4, lab1=.L3063, lab2=, loff=0
!   reloc[1492]: knd=0, off=12158, siz=4, lab1=.L3064, lab2=, loff=0
!   reloc[1493]: knd=0, off=12166, siz=4, lab1=.L3066, lab2=, loff=0
!   reloc[1494]: knd=0, off=12174, siz=4, lab1=.L3067, lab2=, loff=0
!   reloc[1495]: knd=0, off=12182, siz=4, lab1=.L3069, lab2=, loff=0
!   reloc[1496]: knd=0, off=12190, siz=4, lab1=.L3070, lab2=, loff=0
!   reloc[1497]: knd=0, off=12198, siz=4, lab1=.L3072, lab2=, loff=0
!   reloc[1498]: knd=0, off=12206, siz=4, lab1=.L3073, lab2=, loff=0
!   reloc[1499]: knd=0, off=12214, siz=4, lab1=.L3075, lab2=, loff=0
!   reloc[1500]: knd=0, off=12222, siz=4, lab1=.L3076, lab2=, loff=0
!   reloc[1501]: knd=0, off=12230, siz=4, lab1=.L3078, lab2=, loff=0
!   reloc[1502]: knd=0, off=12238, siz=4, lab1=.L3079, lab2=, loff=0
!   reloc[1503]: knd=0, off=12246, siz=4, lab1=.L3081, lab2=, loff=0
!   reloc[1504]: knd=0, off=12254, siz=4, lab1=.L3082, lab2=, loff=0
!   reloc[1505]: knd=0, off=12262, siz=4, lab1=.L3084, lab2=, loff=0
!   reloc[1506]: knd=0, off=12270, siz=4, lab1=.L3085, lab2=, loff=0
!   reloc[1507]: knd=0, off=12278, siz=4, lab1=.L3087, lab2=, loff=0
!   reloc[1508]: knd=0, off=12286, siz=4, lab1=.L3088, lab2=, loff=0
!   reloc[1509]: knd=0, off=12294, siz=4, lab1=.L3090, lab2=, loff=0
!   reloc[1510]: knd=0, off=12302, siz=4, lab1=.L3091, lab2=, loff=0
!   reloc[1511]: knd=0, off=12310, siz=4, lab1=.L3093, lab2=, loff=0
!   reloc[1512]: knd=0, off=12318, siz=4, lab1=.L3094, lab2=, loff=0
!   reloc[1513]: knd=0, off=12326, siz=4, lab1=.L3096, lab2=, loff=0
!   reloc[1514]: knd=0, off=12334, siz=4, lab1=.L3097, lab2=, loff=0
!   reloc[1515]: knd=0, off=12342, siz=4, lab1=.L3099, lab2=, loff=0
!   reloc[1516]: knd=0, off=12350, siz=4, lab1=.L3100, lab2=, loff=0
!   reloc[1517]: knd=0, off=12358, siz=4, lab1=.L3102, lab2=, loff=0
!   reloc[1518]: knd=0, off=12366, siz=4, lab1=.L3103, lab2=, loff=0
!   reloc[1519]: knd=0, off=12374, siz=4, lab1=.L3105, lab2=, loff=0
!   reloc[1520]: knd=0, off=12382, siz=4, lab1=.L3106, lab2=, loff=0
!   reloc[1521]: knd=0, off=12390, siz=4, lab1=.L3108, lab2=, loff=0
!   reloc[1522]: knd=0, off=12398, siz=4, lab1=.L3109, lab2=, loff=0
!   reloc[1523]: knd=0, off=12406, siz=4, lab1=.L3111, lab2=, loff=0
!   reloc[1524]: knd=0, off=12414, siz=4, lab1=.L3115, lab2=, loff=0
!   reloc[1525]: knd=0, off=12422, siz=4, lab1=.L3117, lab2=, loff=0
!   reloc[1526]: knd=0, off=12430, siz=4, lab1=.L3121, lab2=, loff=0
!   reloc[1527]: knd=0, off=12438, siz=4, lab1=.L3123, lab2=, loff=0
!   reloc[1528]: knd=0, off=12446, siz=4, lab1=.L3127, lab2=, loff=0
!   reloc[1529]: knd=0, off=12454, siz=4, lab1=.L3129, lab2=, loff=0
!   reloc[1530]: knd=0, off=12462, siz=4, lab1=.L3130, lab2=, loff=0
!   reloc[1531]: knd=0, off=12470, siz=4, lab1=.L3131, lab2=, loff=0
!   reloc[1532]: knd=0, off=12478, siz=4, lab1=.L3132, lab2=, loff=0
!   reloc[1533]: knd=0, off=12486, siz=4, lab1=.L3133, lab2=, loff=0
!   reloc[1534]: knd=0, off=12494, siz=4, lab1=.L3135, lab2=, loff=0
!   reloc[1535]: knd=0, off=12502, siz=4, lab1=.L3136, lab2=, loff=0
!   reloc[1536]: knd=0, off=12510, siz=4, lab1=.L3138, lab2=, loff=0
!   reloc[1537]: knd=0, off=12518, siz=4, lab1=.L3142, lab2=, loff=0
!   reloc[1538]: knd=0, off=12526, siz=4, lab1=.L3144, lab2=, loff=0
!   reloc[1539]: knd=0, off=12534, siz=4, lab1=.L3148, lab2=, loff=0
!   reloc[1540]: knd=0, off=12542, siz=4, lab1=.L3150, lab2=, loff=0
!   reloc[1541]: knd=0, off=12550, siz=4, lab1=.L3154, lab2=, loff=0
!   reloc[1542]: knd=0, off=12558, siz=4, lab1=.L3156, lab2=, loff=0
!   reloc[1543]: knd=0, off=12566, siz=4, lab1=.L3160, lab2=, loff=0
!   reloc[1544]: knd=0, off=12574, siz=4, lab1=.L3163, lab2=, loff=0
!   reloc[1545]: knd=0, off=12582, siz=4, lab1=.L3170, lab2=, loff=0
!   reloc[1546]: knd=0, off=12590, siz=4, lab1=.L3173, lab2=, loff=0
!   reloc[1547]: knd=0, off=12598, siz=4, lab1=.L3176, lab2=, loff=0
!   reloc[1548]: knd=0, off=12608, siz=4, lab1=.L3178, lab2=, loff=0
!   reloc[1549]: knd=0, off=12616, siz=4, lab1=.L3179, lab2=, loff=0
!   reloc[1550]: knd=0, off=12624, siz=4, lab1=.L3181, lab2=, loff=0
!   reloc[1551]: knd=0, off=12632, siz=4, lab1=.L3182, lab2=, loff=0
!   reloc[1552]: knd=0, off=12640, siz=4, lab1=.L3184, lab2=, loff=0
!   reloc[1553]: knd=0, off=12648, siz=4, lab1=.L3185, lab2=, loff=0
!   reloc[1554]: knd=0, off=12656, siz=4, lab1=.L3187, lab2=, loff=0
!   reloc[1555]: knd=0, off=12664, siz=4, lab1=.L3188, lab2=, loff=0
!   reloc[1556]: knd=0, off=12672, siz=4, lab1=.L3190, lab2=, loff=0
!   reloc[1557]: knd=0, off=12680, siz=4, lab1=.L3191, lab2=, loff=0
!   reloc[1558]: knd=0, off=12688, siz=4, lab1=.L3193, lab2=, loff=0
!   reloc[1559]: knd=0, off=12696, siz=4, lab1=.L3194, lab2=, loff=0
!   reloc[1560]: knd=0, off=12704, siz=4, lab1=.L3196, lab2=, loff=0
!   reloc[1561]: knd=0, off=12712, siz=4, lab1=.L3197, lab2=, loff=0
!   reloc[1562]: knd=0, off=12720, siz=4, lab1=.L3199, lab2=, loff=0
!   reloc[1563]: knd=0, off=12728, siz=4, lab1=.L3200, lab2=, loff=0
!   reloc[1564]: knd=0, off=12736, siz=4, lab1=.L3202, lab2=, loff=0
!   reloc[1565]: knd=0, off=12744, siz=4, lab1=.L3203, lab2=, loff=0
!   reloc[1566]: knd=0, off=12752, siz=4, lab1=.L3205, lab2=, loff=0
!   reloc[1567]: knd=0, off=12760, siz=4, lab1=.L3206, lab2=, loff=0
!   reloc[1568]: knd=0, off=12768, siz=4, lab1=.L3207, lab2=, loff=0
!   reloc[1569]: knd=0, off=12776, siz=4, lab1=.L3208, lab2=, loff=0
!   reloc[1570]: knd=0, off=12784, siz=4, lab1=.L3209, lab2=, loff=0
!   reloc[1571]: knd=0, off=12792, siz=4, lab1=.L3211, lab2=, loff=0
!   reloc[1572]: knd=0, off=12800, siz=4, lab1=.L3212, lab2=, loff=0
!   reloc[1573]: knd=0, off=12808, siz=4, lab1=.L3214, lab2=, loff=0
!   reloc[1574]: knd=0, off=12816, siz=4, lab1=.L3215, lab2=, loff=0
!   reloc[1575]: knd=0, off=12824, siz=4, lab1=.L3217, lab2=, loff=0
!   reloc[1576]: knd=0, off=12832, siz=4, lab1=.L3218, lab2=, loff=0
!   reloc[1577]: knd=0, off=12840, siz=4, lab1=.L3220, lab2=, loff=0
!   reloc[1578]: knd=0, off=12848, siz=4, lab1=.L3221, lab2=, loff=0
!   reloc[1579]: knd=0, off=12856, siz=4, lab1=.L3223, lab2=, loff=0
!   reloc[1580]: knd=0, off=12864, siz=4, lab1=.L3224, lab2=, loff=0
!   reloc[1581]: knd=0, off=12872, siz=4, lab1=.L3226, lab2=, loff=0
!   reloc[1582]: knd=0, off=12880, siz=4, lab1=.L3227, lab2=, loff=0
!   reloc[1583]: knd=0, off=12888, siz=4, lab1=.L3229, lab2=, loff=0
!   reloc[1584]: knd=0, off=12896, siz=4, lab1=.L3230, lab2=, loff=0
!   reloc[1585]: knd=0, off=12904, siz=4, lab1=.L3232, lab2=, loff=0
!   reloc[1586]: knd=0, off=12912, siz=4, lab1=.L3233, lab2=, loff=0
!   reloc[1587]: knd=0, off=12920, siz=4, lab1=.L3235, lab2=, loff=0
!   reloc[1588]: knd=0, off=12928, siz=4, lab1=.L3236, lab2=, loff=0
!   reloc[1589]: knd=0, off=12936, siz=4, lab1=.L3238, lab2=, loff=0
!   reloc[1590]: knd=0, off=12944, siz=4, lab1=.L3239, lab2=, loff=0
!   reloc[1591]: knd=0, off=12952, siz=4, lab1=.L3241, lab2=, loff=0
!   reloc[1592]: knd=0, off=12960, siz=4, lab1=.L3242, lab2=, loff=0
!   reloc[1593]: knd=0, off=12968, siz=4, lab1=.L3244, lab2=, loff=0
!   reloc[1594]: knd=0, off=12976, siz=4, lab1=.L3245, lab2=, loff=0
!   reloc[1595]: knd=0, off=12984, siz=4, lab1=.L3247, lab2=, loff=0
!   reloc[1596]: knd=0, off=12992, siz=4, lab1=.L3248, lab2=, loff=0
!   reloc[1597]: knd=0, off=13000, siz=4, lab1=.L3250, lab2=, loff=0
!   reloc[1598]: knd=0, off=13008, siz=4, lab1=.L3251, lab2=, loff=0
!   reloc[1599]: knd=0, off=13016, siz=4, lab1=.L3253, lab2=, loff=0
!   reloc[1600]: knd=0, off=13024, siz=4, lab1=.L3254, lab2=, loff=0
!   reloc[1601]: knd=0, off=13032, siz=4, lab1=.L3256, lab2=, loff=0
!   reloc[1602]: knd=0, off=13040, siz=4, lab1=.L3257, lab2=, loff=0
!   reloc[1603]: knd=0, off=13048, siz=4, lab1=.L3259, lab2=, loff=0
!   reloc[1604]: knd=0, off=13056, siz=4, lab1=.L3260, lab2=, loff=0
!   reloc[1605]: knd=0, off=13064, siz=4, lab1=.L3262, lab2=, loff=0
!   reloc[1606]: knd=0, off=13072, siz=4, lab1=.L3263, lab2=, loff=0
!   reloc[1607]: knd=0, off=13080, siz=4, lab1=.L3265, lab2=, loff=0
!   reloc[1608]: knd=0, off=13088, siz=4, lab1=.L3266, lab2=, loff=0
!   reloc[1609]: knd=0, off=13096, siz=4, lab1=.L3268, lab2=, loff=0
!   reloc[1610]: knd=0, off=13104, siz=4, lab1=.L3269, lab2=, loff=0
!   reloc[1611]: knd=0, off=13112, siz=4, lab1=.L3271, lab2=, loff=0
!   reloc[1612]: knd=0, off=13120, siz=4, lab1=.L3272, lab2=, loff=0
!   reloc[1613]: knd=0, off=13128, siz=4, lab1=.L3274, lab2=, loff=0
!   reloc[1614]: knd=0, off=13136, siz=4, lab1=.L3275, lab2=, loff=0
!   reloc[1615]: knd=0, off=13144, siz=4, lab1=.L3277, lab2=, loff=0
!   reloc[1616]: knd=0, off=13152, siz=4, lab1=.L3278, lab2=, loff=0
!   reloc[1617]: knd=0, off=13160, siz=4, lab1=.L3280, lab2=, loff=0
!   reloc[1618]: knd=0, off=13168, siz=4, lab1=.L3281, lab2=, loff=0
!   reloc[1619]: knd=0, off=13176, siz=4, lab1=.L3283, lab2=, loff=0
!   reloc[1620]: knd=0, off=13184, siz=4, lab1=.L3284, lab2=, loff=0
!   reloc[1621]: knd=0, off=13192, siz=4, lab1=.L3286, lab2=, loff=0
!   reloc[1622]: knd=0, off=13202, siz=4, lab1=.L3290, lab2=, loff=0
!   reloc[1623]: knd=0, off=13213, siz=4, lab1=.L3293, lab2=, loff=0
!   reloc[1624]: knd=0, off=13229, siz=4, lab1=gl_GetIntegerv, lab2=, loff=0
!   reloc[1625]: knd=0, off=13236, siz=4, lab1=.L3302, lab2=, loff=0
!   reloc[1626]: knd=0, off=13248, siz=4, lab1=.L3306, lab2=, loff=0
!   reloc[1627]: knd=0, off=13256, siz=4, lab1=.L3308, lab2=, loff=0
!   reloc[1628]: knd=0, off=13264, siz=4, lab1=.L3315, lab2=, loff=0
!   reloc[1629]: knd=0, off=13272, siz=4, lab1=.L3322, lab2=, loff=0
!   reloc[1630]: knd=0, off=13282, siz=4, lab1=.L3323, lab2=, loff=0
!   reloc[1631]: knd=0, off=13290, siz=4, lab1=.L3325, lab2=, loff=0
!   reloc[1632]: knd=0, off=13298, siz=4, lab1=.L3326, lab2=, loff=0
!   reloc[1633]: knd=0, off=13306, siz=4, lab1=.L3327, lab2=, loff=0
!   reloc[1634]: knd=0, off=13314, siz=4, lab1=.L3328, lab2=, loff=0
!   reloc[1635]: knd=0, off=13322, siz=4, lab1=.L3329, lab2=, loff=0
!   reloc[1636]: knd=0, off=13330, siz=4, lab1=.L3331, lab2=, loff=0
!   reloc[1637]: knd=0, off=13338, siz=4, lab1=.L3332, lab2=, loff=0
!   reloc[1638]: knd=0, off=13346, siz=4, lab1=.L3334, lab2=, loff=0
!   reloc[1639]: knd=0, off=13354, siz=4, lab1=.L3335, lab2=, loff=0
!   reloc[1640]: knd=0, off=13362, siz=4, lab1=.L3337, lab2=, loff=0
!   reloc[1641]: knd=0, off=13370, siz=4, lab1=.L3338, lab2=, loff=0
!   reloc[1642]: knd=0, off=13378, siz=4, lab1=.L3340, lab2=, loff=0
!   reloc[1643]: knd=0, off=13386, siz=4, lab1=.L3341, lab2=, loff=0
!   reloc[1644]: knd=0, off=13394, siz=4, lab1=.L3343, lab2=, loff=0
!   reloc[1645]: knd=0, off=13402, siz=4, lab1=.L3344, lab2=, loff=0
!   reloc[1646]: knd=0, off=13410, siz=4, lab1=.L3346, lab2=, loff=0
!   reloc[1647]: knd=0, off=13418, siz=4, lab1=.L3347, lab2=, loff=0
!   reloc[1648]: knd=0, off=13426, siz=4, lab1=.L3349, lab2=, loff=0
!   reloc[1649]: knd=0, off=13434, siz=4, lab1=.L3350, lab2=, loff=0
!   reloc[1650]: knd=0, off=13442, siz=4, lab1=.L3352, lab2=, loff=0
!   reloc[1651]: knd=0, off=13450, siz=4, lab1=.L3353, lab2=, loff=0
!   reloc[1652]: knd=0, off=13458, siz=4, lab1=.L3355, lab2=, loff=0
!   reloc[1653]: knd=0, off=13466, siz=4, lab1=.L3356, lab2=, loff=0
!   reloc[1654]: knd=0, off=13474, siz=4, lab1=.L3358, lab2=, loff=0
!   reloc[1655]: knd=0, off=13482, siz=4, lab1=.L3359, lab2=, loff=0
!   reloc[1656]: knd=0, off=13490, siz=4, lab1=.L3361, lab2=, loff=0
!   reloc[1657]: knd=0, off=13498, siz=4, lab1=.L3362, lab2=, loff=0
!   reloc[1658]: knd=0, off=13506, siz=4, lab1=.L3364, lab2=, loff=0
!   reloc[1659]: knd=0, off=13514, siz=4, lab1=.L3365, lab2=, loff=0
!   reloc[1660]: knd=0, off=13522, siz=4, lab1=.L3367, lab2=, loff=0
!   reloc[1661]: knd=0, off=13530, siz=4, lab1=.L3368, lab2=, loff=0
!   reloc[1662]: knd=0, off=13538, siz=4, lab1=.L3370, lab2=, loff=0
!   reloc[1663]: knd=0, off=13546, siz=4, lab1=.L3371, lab2=, loff=0
!   reloc[1664]: knd=0, off=13554, siz=4, lab1=.L3372, lab2=, loff=0
!   reloc[1665]: knd=0, off=13562, siz=4, lab1=.L3373, lab2=, loff=0
!   reloc[1666]: knd=0, off=13570, siz=4, lab1=.L3374, lab2=, loff=0
!   reloc[1667]: knd=0, off=13578, siz=4, lab1=.L3376, lab2=, loff=0
!   reloc[1668]: knd=0, off=13586, siz=4, lab1=.L3377, lab2=, loff=0
!   reloc[1669]: knd=0, off=13594, siz=4, lab1=.L3379, lab2=, loff=0
!   reloc[1670]: knd=0, off=13602, siz=4, lab1=.L3380, lab2=, loff=0
!   reloc[1671]: knd=0, off=13610, siz=4, lab1=.L3382, lab2=, loff=0
!   reloc[1672]: knd=0, off=13618, siz=4, lab1=.L3383, lab2=, loff=0
!   reloc[1673]: knd=0, off=13626, siz=4, lab1=.L3385, lab2=, loff=0
!   reloc[1674]: knd=0, off=13634, siz=4, lab1=.L3386, lab2=, loff=0
!   reloc[1675]: knd=0, off=13642, siz=4, lab1=.L3393, lab2=, loff=0
!   reloc[1676]: knd=0, off=13652, siz=4, lab1=.L3394, lab2=, loff=0
!   reloc[1677]: knd=0, off=13660, siz=4, lab1=.L3395, lab2=, loff=0
!   reloc[1678]: knd=0, off=13668, siz=4, lab1=.L3397, lab2=, loff=0
!   reloc[1679]: knd=0, off=13676, siz=4, lab1=.L3398, lab2=, loff=0
!   reloc[1680]: knd=0, off=13684, siz=4, lab1=.L3399, lab2=, loff=0
!   reloc[1681]: knd=0, off=13692, siz=4, lab1=.L3400, lab2=, loff=0
!   reloc[1682]: knd=0, off=13700, siz=4, lab1=.L3401, lab2=, loff=0
!   reloc[1683]: knd=0, off=13708, siz=4, lab1=.L3403, lab2=, loff=0
!   reloc[1684]: knd=0, off=13716, siz=4, lab1=.L3404, lab2=, loff=0
!   reloc[1685]: knd=0, off=13724, siz=4, lab1=.L3406, lab2=, loff=0
!   reloc[1686]: knd=0, off=13732, siz=4, lab1=.L3407, lab2=, loff=0
!   reloc[1687]: knd=0, off=13740, siz=4, lab1=.L3409, lab2=, loff=0
!   reloc[1688]: knd=0, off=13748, siz=4, lab1=.L3410, lab2=, loff=0
!   reloc[1689]: knd=0, off=13756, siz=4, lab1=.L3412, lab2=, loff=0
!   reloc[1690]: knd=0, off=13764, siz=4, lab1=.L3416, lab2=, loff=0
!   reloc[1691]: knd=0, off=13772, siz=4, lab1=.L3420, lab2=, loff=0
!   reloc[1692]: knd=0, off=13780, siz=4, lab1=.L3424, lab2=, loff=0
!   reloc[1693]: knd=0, off=13788, siz=4, lab1=.L3428, lab2=, loff=0
!   reloc[1694]: knd=0, off=13796, siz=4, lab1=.L3430, lab2=, loff=0
!   reloc[1695]: knd=0, off=13804, siz=4, lab1=.L3431, lab2=, loff=0
!   reloc[1696]: knd=0, off=13812, siz=4, lab1=.L3433, lab2=, loff=0
!   reloc[1697]: knd=0, off=13820, siz=4, lab1=.L3434, lab2=, loff=0
!   reloc[1698]: knd=0, off=13828, siz=4, lab1=.L3436, lab2=, loff=0
!   reloc[1699]: knd=0, off=13836, siz=4, lab1=.L3437, lab2=, loff=0
!   reloc[1700]: knd=0, off=13844, siz=4, lab1=.L3438, lab2=, loff=0
!   reloc[1701]: knd=0, off=13852, siz=4, lab1=.L3439, lab2=, loff=0
!   reloc[1702]: knd=0, off=13860, siz=4, lab1=.L3440, lab2=, loff=0
!   reloc[1703]: knd=0, off=13868, siz=4, lab1=.L3442, lab2=, loff=0
!   reloc[1704]: knd=0, off=13876, siz=4, lab1=.L3443, lab2=, loff=0
!   reloc[1705]: knd=0, off=13884, siz=4, lab1=.L3445, lab2=, loff=0
!   reloc[1706]: knd=0, off=13892, siz=4, lab1=.L3446, lab2=, loff=0
!   reloc[1707]: knd=0, off=13900, siz=4, lab1=.L3447, lab2=, loff=0
!   reloc[1708]: knd=0, off=13908, siz=4, lab1=.L3448, lab2=, loff=0
!   reloc[1709]: knd=0, off=13916, siz=4, lab1=.L3450, lab2=, loff=0
!   reloc[1710]: knd=0, off=13924, siz=4, lab1=.L3451, lab2=, loff=0
!   reloc[1711]: knd=0, off=13932, siz=4, lab1=.L3452, lab2=, loff=0
!   reloc[1712]: knd=0, off=13940, siz=4, lab1=.L3453, lab2=, loff=0
!   reloc[1713]: knd=0, off=13948, siz=4, lab1=.L3454, lab2=, loff=0
!   reloc[1714]: knd=0, off=13956, siz=4, lab1=.L3456, lab2=, loff=0
!   reloc[1715]: knd=0, off=13964, siz=4, lab1=.L3457, lab2=, loff=0
!   reloc[1716]: knd=0, off=13972, siz=4, lab1=.L3459, lab2=, loff=0
!   reloc[1717]: knd=0, off=13980, siz=4, lab1=.L3460, lab2=, loff=0
!   reloc[1718]: knd=0, off=13988, siz=4, lab1=.L3462, lab2=, loff=0
!   reloc[1719]: knd=0, off=13996, siz=4, lab1=.L3463, lab2=, loff=0
!   reloc[1720]: knd=0, off=14004, siz=4, lab1=.L3464, lab2=, loff=0
!   reloc[1721]: knd=0, off=14012, siz=4, lab1=.L3465, lab2=, loff=0
!   reloc[1722]: knd=0, off=14020, siz=4, lab1=.L3466, lab2=, loff=0
!   reloc[1723]: knd=0, off=14028, siz=4, lab1=.L3468, lab2=, loff=0
!   reloc[1724]: knd=0, off=14036, siz=4, lab1=.L3469, lab2=, loff=0
!   reloc[1725]: knd=0, off=14044, siz=4, lab1=.L3470, lab2=, loff=0
!   reloc[1726]: knd=0, off=14052, siz=4, lab1=.L3471, lab2=, loff=0
!   reloc[1727]: knd=0, off=14060, siz=4, lab1=.L3472, lab2=, loff=0
!   reloc[1728]: knd=0, off=14068, siz=4, lab1=.L3474, lab2=, loff=0
!   reloc[1729]: knd=0, off=14076, siz=4, lab1=.L3475, lab2=, loff=0
!   reloc[1730]: knd=0, off=14084, siz=4, lab1=.L3477, lab2=, loff=0
!   reloc[1731]: knd=0, off=14092, siz=4, lab1=.L3478, lab2=, loff=0
!   reloc[1732]: knd=0, off=14100, siz=4, lab1=.L3479, lab2=, loff=0
!   reloc[1733]: knd=0, off=14108, siz=4, lab1=.L3480, lab2=, loff=0
!   reloc[1734]: knd=0, off=14116, siz=4, lab1=.L3481, lab2=, loff=0
!   reloc[1735]: knd=0, off=14124, siz=4, lab1=.L3483, lab2=, loff=0
!   reloc[1736]: knd=0, off=14132, siz=4, lab1=.L3484, lab2=, loff=0
!   reloc[1737]: knd=0, off=14140, siz=4, lab1=.L3486, lab2=, loff=0
!   reloc[1738]: knd=0, off=14148, siz=4, lab1=.L3487, lab2=, loff=0
!   reloc[1739]: knd=0, off=14156, siz=4, lab1=.L3489, lab2=, loff=0
!   reloc[1740]: knd=0, off=14164, siz=4, lab1=.L3490, lab2=, loff=0
!   reloc[1741]: knd=0, off=14172, siz=4, lab1=.L3492, lab2=, loff=0
!   reloc[1742]: knd=0, off=14180, siz=4, lab1=.L3493, lab2=, loff=0
!   reloc[1743]: knd=0, off=14188, siz=4, lab1=.L3495, lab2=, loff=0
!   reloc[1744]: knd=0, off=14196, siz=4, lab1=.L3496, lab2=, loff=0
!   reloc[1745]: knd=0, off=14204, siz=4, lab1=.L3497, lab2=, loff=0
!   reloc[1746]: knd=0, off=14212, siz=4, lab1=.L3499, lab2=, loff=0
!   reloc[1747]: knd=0, off=14220, siz=4, lab1=.L3500, lab2=, loff=0
!   reloc[1748]: knd=0, off=14228, siz=4, lab1=.L3502, lab2=, loff=0
!   reloc[1749]: knd=0, off=14236, siz=4, lab1=.L3503, lab2=, loff=0
!   reloc[1750]: knd=0, off=14244, siz=4, lab1=.L3505, lab2=, loff=0
!   reloc[1751]: knd=0, off=14252, siz=4, lab1=.L3506, lab2=, loff=0
!   reloc[1752]: knd=0, off=14260, siz=4, lab1=.L3508, lab2=, loff=0
!   reloc[1753]: knd=0, off=14268, siz=4, lab1=.L3509, lab2=, loff=0
!   reloc[1754]: knd=0, off=14276, siz=4, lab1=.L3511, lab2=, loff=0
!   reloc[1755]: knd=0, off=14284, siz=4, lab1=.L3512, lab2=, loff=0
!   reloc[1756]: knd=0, off=14292, siz=4, lab1=.L3514, lab2=, loff=0
!   reloc[1757]: knd=0, off=14300, siz=4, lab1=.L3515, lab2=, loff=0
!   reloc[1758]: knd=0, off=14308, siz=4, lab1=.L3517, lab2=, loff=0
!   reloc[1759]: knd=0, off=14316, siz=4, lab1=.L3518, lab2=, loff=0
!   reloc[1760]: knd=0, off=14324, siz=4, lab1=.L3520, lab2=, loff=0
!   reloc[1761]: knd=0, off=14334, siz=4, lab1=.L3521, lab2=, loff=0
!   reloc[1762]: knd=0, off=14342, siz=4, lab1=.L3523, lab2=, loff=0
!   reloc[1763]: knd=0, off=14350, siz=4, lab1=.L3524, lab2=, loff=0
!   reloc[1764]: knd=0, off=14358, siz=4, lab1=.L3526, lab2=, loff=0
!   reloc[1765]: knd=0, off=14366, siz=4, lab1=.L3527, lab2=, loff=0
!   reloc[1766]: knd=0, off=14374, siz=4, lab1=.L3529, lab2=, loff=0
!   reloc[1767]: knd=0, off=14382, siz=4, lab1=.L3530, lab2=, loff=0
!   reloc[1768]: knd=0, off=14390, siz=4, lab1=.L3531, lab2=, loff=0
!   reloc[1769]: knd=0, off=14398, siz=4, lab1=.L3532, lab2=, loff=0
!   reloc[1770]: knd=0, off=14406, siz=4, lab1=.L3533, lab2=, loff=0
!   reloc[1771]: knd=0, off=14414, siz=4, lab1=.L3535, lab2=, loff=0
!   reloc[1772]: knd=0, off=14422, siz=4, lab1=.L3536, lab2=, loff=0
!   reloc[1773]: knd=0, off=14430, siz=4, lab1=.L3538, lab2=, loff=0
!   reloc[1774]: knd=0, off=14438, siz=4, lab1=.L3539, lab2=, loff=0
!   reloc[1775]: knd=0, off=14446, siz=4, lab1=.L3541, lab2=, loff=0
!   reloc[1776]: knd=0, off=14454, siz=4, lab1=.L3542, lab2=, loff=0
!   reloc[1777]: knd=0, off=14462, siz=4, lab1=.L3544, lab2=, loff=0
!   reloc[1778]: knd=0, off=14470, siz=4, lab1=.L3545, lab2=, loff=0
!   reloc[1779]: knd=0, off=14478, siz=4, lab1=.L3547, lab2=, loff=0
!   reloc[1780]: knd=0, off=14486, siz=4, lab1=.L3548, lab2=, loff=0
!   reloc[1781]: knd=0, off=14494, siz=4, lab1=.L3550, lab2=, loff=0
!   reloc[1782]: knd=0, off=14502, siz=4, lab1=.L3551, lab2=, loff=0
!   reloc[1783]: knd=0, off=14510, siz=4, lab1=.L3553, lab2=, loff=0
!   reloc[1784]: knd=0, off=14518, siz=4, lab1=.L3554, lab2=, loff=0
!   reloc[1785]: knd=0, off=14526, siz=4, lab1=.L3556, lab2=, loff=0
!   reloc[1786]: knd=0, off=14534, siz=4, lab1=.L3557, lab2=, loff=0
!   reloc[1787]: knd=0, off=14542, siz=4, lab1=.L3559, lab2=, loff=0
!   reloc[1788]: knd=0, off=14550, siz=4, lab1=.L3560, lab2=, loff=0
!   reloc[1789]: knd=0, off=14558, siz=4, lab1=.L3562, lab2=, loff=0
!   reloc[1790]: knd=0, off=14566, siz=4, lab1=.L3563, lab2=, loff=0
!   reloc[1791]: knd=0, off=14574, siz=4, lab1=.L3565, lab2=, loff=0
!   reloc[1792]: knd=0, off=14582, siz=4, lab1=.L3566, lab2=, loff=0
!   reloc[1793]: knd=0, off=14590, siz=4, lab1=.L3568, lab2=, loff=0
!   reloc[1794]: knd=0, off=14598, siz=4, lab1=.L3569, lab2=, loff=0
!   reloc[1795]: knd=0, off=14606, siz=4, lab1=.L3571, lab2=, loff=0
!   reloc[1796]: knd=0, off=14614, siz=4, lab1=.L3575, lab2=, loff=0
!   reloc[1797]: knd=0, off=14622, siz=4, lab1=.L3577, lab2=, loff=0
!   reloc[1798]: knd=0, off=14630, siz=4, lab1=.L3578, lab2=, loff=0
!   reloc[1799]: knd=0, off=14638, siz=4, lab1=.L3580, lab2=, loff=0
!   reloc[1800]: knd=0, off=14646, siz=4, lab1=.L3581, lab2=, loff=0
!   reloc[1801]: knd=0, off=14654, siz=4, lab1=.L3583, lab2=, loff=0
!   reloc[1802]: knd=0, off=14662, siz=4, lab1=.L3584, lab2=, loff=0
!   reloc[1803]: knd=0, off=14670, siz=4, lab1=.L3593, lab2=, loff=0
!   reloc[1804]: knd=0, off=14680, siz=4, lab1=.L3594, lab2=, loff=0
!   reloc[1805]: knd=0, off=14688, siz=4, lab1=.L3596, lab2=, loff=0
!   reloc[1806]: knd=0, off=14696, siz=4, lab1=.L3597, lab2=, loff=0
!   reloc[1807]: knd=0, off=14704, siz=4, lab1=.L3599, lab2=, loff=0
!   reloc[1808]: knd=0, off=14712, siz=4, lab1=.L3600, lab2=, loff=0
!   reloc[1809]: knd=0, off=14720, siz=4, lab1=.L3601, lab2=, loff=0
!   reloc[1810]: knd=0, off=14728, siz=4, lab1=.L3602, lab2=, loff=0
!   reloc[1811]: knd=0, off=14736, siz=4, lab1=.L3603, lab2=, loff=0
!   reloc[1812]: knd=0, off=14744, siz=4, lab1=.L3605, lab2=, loff=0
!   reloc[1813]: knd=0, off=14752, siz=4, lab1=.L3606, lab2=, loff=0
!   reloc[1814]: knd=0, off=14760, siz=4, lab1=.L3608, lab2=, loff=0
!   reloc[1815]: knd=0, off=14768, siz=4, lab1=.L3609, lab2=, loff=0
!   reloc[1816]: knd=0, off=14776, siz=4, lab1=.L3611, lab2=, loff=0
!   reloc[1817]: knd=0, off=14784, siz=4, lab1=.L3612, lab2=, loff=0
!   reloc[1818]: knd=0, off=14792, siz=4, lab1=.L3614, lab2=, loff=0
!   reloc[1819]: knd=0, off=14800, siz=4, lab1=.L3615, lab2=, loff=0
!   reloc[1820]: knd=0, off=14808, siz=4, lab1=.L3617, lab2=, loff=0
!   reloc[1821]: knd=0, off=14816, siz=4, lab1=.L3618, lab2=, loff=0
!   reloc[1822]: knd=0, off=14824, siz=4, lab1=.L3620, lab2=, loff=0
!   reloc[1823]: knd=0, off=14832, siz=4, lab1=.L3621, lab2=, loff=0
!   reloc[1824]: knd=0, off=14840, siz=4, lab1=.L3623, lab2=, loff=0
!   reloc[1825]: knd=0, off=14848, siz=4, lab1=.L3624, lab2=, loff=0
!   reloc[1826]: knd=0, off=14856, siz=4, lab1=.L3626, lab2=, loff=0
!   reloc[1827]: knd=0, off=14864, siz=4, lab1=.L3627, lab2=, loff=0
!   reloc[1828]: knd=0, off=14872, siz=4, lab1=.L3629, lab2=, loff=0
!   reloc[1829]: knd=0, off=14880, siz=4, lab1=.L3630, lab2=, loff=0
!   reloc[1830]: knd=0, off=14888, siz=4, lab1=.L3632, lab2=, loff=0
!   reloc[1831]: knd=0, off=14896, siz=4, lab1=.L3633, lab2=, loff=0
!   reloc[1832]: knd=0, off=14904, siz=4, lab1=.L3634, lab2=, loff=0
!   reloc[1833]: knd=0, off=14912, siz=4, lab1=.L3636, lab2=, loff=0
!   reloc[1834]: knd=0, off=14920, siz=4, lab1=.L3637, lab2=, loff=0
!   reloc[1835]: knd=0, off=14928, siz=4, lab1=.L3639, lab2=, loff=0
!   reloc[1836]: knd=0, off=14936, siz=4, lab1=.L3640, lab2=, loff=0
!   reloc[1837]: knd=0, off=14944, siz=4, lab1=.L3642, lab2=, loff=0
!   reloc[1838]: knd=0, off=14954, siz=4, lab1=.L3646, lab2=, loff=0
!   reloc[1839]: knd=0, off=14962, siz=4, lab1=.L3648, lab2=, loff=0
!   reloc[1840]: knd=0, off=14970, siz=4, lab1=.L3649, lab2=, loff=0
!   reloc[1841]: knd=0, off=14978, siz=4, lab1=.L3651, lab2=, loff=0
!   reloc[1842]: knd=0, off=14986, siz=4, lab1=.L3652, lab2=, loff=0
!   reloc[1843]: knd=0, off=14994, siz=4, lab1=.L3654, lab2=, loff=0
!   reloc[1844]: knd=0, off=15002, siz=4, lab1=.L3655, lab2=, loff=0
!   reloc[1845]: knd=0, off=15010, siz=4, lab1=.L3657, lab2=, loff=0
!   reloc[1846]: knd=0, off=15018, siz=4, lab1=.L3658, lab2=, loff=0
!   reloc[1847]: knd=0, off=15026, siz=4, lab1=.L3660, lab2=, loff=0
!   reloc[1848]: knd=0, off=15034, siz=4, lab1=.L3661, lab2=, loff=0
!   reloc[1849]: knd=0, off=15042, siz=4, lab1=.L3662, lab2=, loff=0
!   reloc[1850]: knd=0, off=15050, siz=4, lab1=.L3664, lab2=, loff=0
!   reloc[1851]: knd=0, off=15058, siz=4, lab1=.L3665, lab2=, loff=0
!   reloc[1852]: knd=0, off=15066, siz=4, lab1=.L3667, lab2=, loff=0
!   reloc[1853]: knd=0, off=15074, siz=4, lab1=.L3668, lab2=, loff=0
!   reloc[1854]: knd=0, off=15082, siz=4, lab1=.L3670, lab2=, loff=0
!   reloc[1855]: knd=0, off=15090, siz=4, lab1=.L3671, lab2=, loff=0
!   reloc[1856]: knd=0, off=15098, siz=4, lab1=.L3673, lab2=, loff=0
!   reloc[1857]: knd=0, off=15106, siz=4, lab1=.L3674, lab2=, loff=0
!   reloc[1858]: knd=0, off=15114, siz=4, lab1=.L3676, lab2=, loff=0
!   reloc[1859]: knd=0, off=15122, siz=4, lab1=.L3677, lab2=, loff=0
!   reloc[1860]: knd=0, off=15130, siz=4, lab1=.L3679, lab2=, loff=0
!   reloc[1861]: knd=0, off=15138, siz=4, lab1=.L3680, lab2=, loff=0
!   reloc[1862]: knd=0, off=15146, siz=4, lab1=.L3682, lab2=, loff=0
!   reloc[1863]: knd=0, off=15154, siz=4, lab1=.L3683, lab2=, loff=0
!   reloc[1864]: knd=0, off=15162, siz=4, lab1=.L3685, lab2=, loff=0
!   reloc[1865]: knd=0, off=15170, siz=4, lab1=.L3686, lab2=, loff=0
!   reloc[1866]: knd=0, off=15178, siz=4, lab1=.L3688, lab2=, loff=0
!   reloc[1867]: knd=0, off=15186, siz=4, lab1=.L3689, lab2=, loff=0
!   reloc[1868]: knd=0, off=15194, siz=4, lab1=.L3691, lab2=, loff=0
!   reloc[1869]: knd=0, off=15202, siz=4, lab1=.L3692, lab2=, loff=0
!   reloc[1870]: knd=0, off=15210, siz=4, lab1=.L3694, lab2=, loff=0
!   reloc[1871]: knd=0, off=15218, siz=4, lab1=.L3695, lab2=, loff=0
!   reloc[1872]: knd=0, off=15226, siz=4, lab1=.L3696, lab2=, loff=0
!   reloc[1873]: knd=0, off=15234, siz=4, lab1=.L3697, lab2=, loff=0
!   reloc[1874]: knd=0, off=15242, siz=4, lab1=.L3698, lab2=, loff=0
!   reloc[1875]: knd=0, off=15250, siz=4, lab1=.L3700, lab2=, loff=0
!   reloc[1876]: knd=0, off=15258, siz=4, lab1=.L3701, lab2=, loff=0
!   reloc[1877]: knd=0, off=15266, siz=4, lab1=.L3702, lab2=, loff=0
!   reloc[1878]: knd=0, off=15274, siz=4, lab1=.L3704, lab2=, loff=0
!   reloc[1879]: knd=0, off=15282, siz=4, lab1=.L3705, lab2=, loff=0
!   reloc[1880]: knd=0, off=15290, siz=4, lab1=.L3707, lab2=, loff=0
!   reloc[1881]: knd=0, off=15298, siz=4, lab1=.L3708, lab2=, loff=0
!   reloc[1882]: knd=0, off=15306, siz=4, lab1=.L3710, lab2=, loff=0
!   reloc[1883]: knd=0, off=15314, siz=4, lab1=.L3711, lab2=, loff=0
!   reloc[1884]: knd=0, off=15322, siz=4, lab1=.L3713, lab2=, loff=0
!   reloc[1885]: knd=0, off=15330, siz=4, lab1=.L3714, lab2=, loff=0
!   reloc[1886]: knd=0, off=15338, siz=4, lab1=.L3716, lab2=, loff=0
!   reloc[1887]: knd=0, off=15346, siz=4, lab1=.L3717, lab2=, loff=0
!   reloc[1888]: knd=0, off=15354, siz=4, lab1=.L3719, lab2=, loff=0
!   reloc[1889]: knd=0, off=15362, siz=4, lab1=.L3720, lab2=, loff=0
!   reloc[1890]: knd=0, off=15370, siz=4, lab1=.L3722, lab2=, loff=0
!   reloc[1891]: knd=0, off=15378, siz=4, lab1=.L3723, lab2=, loff=0
!   reloc[1892]: knd=0, off=15386, siz=4, lab1=.L3725, lab2=, loff=0
!   reloc[1893]: knd=0, off=15394, siz=4, lab1=.L3726, lab2=, loff=0
!   reloc[1894]: knd=0, off=15402, siz=4, lab1=.L3728, lab2=, loff=0
!   reloc[1895]: knd=0, off=15410, siz=4, lab1=.L3729, lab2=, loff=0
!   reloc[1896]: knd=0, off=15418, siz=4, lab1=.L3731, lab2=, loff=0
!   reloc[1897]: knd=0, off=15426, siz=4, lab1=.L3732, lab2=, loff=0
!   reloc[1898]: knd=0, off=15434, siz=4, lab1=.L3734, lab2=, loff=0
!   reloc[1899]: knd=0, off=15442, siz=4, lab1=.L3735, lab2=, loff=0
!   reloc[1900]: knd=0, off=15450, siz=4, lab1=.L3737, lab2=, loff=0
!   reloc[1901]: knd=0, off=15458, siz=4, lab1=.L3738, lab2=, loff=0
!   reloc[1902]: knd=0, off=15466, siz=4, lab1=.L3740, lab2=, loff=0
!   reloc[1903]: knd=0, off=15474, siz=4, lab1=.L3741, lab2=, loff=0
!   reloc[1904]: knd=0, off=15482, siz=4, lab1=.L3743, lab2=, loff=0
!   reloc[1905]: knd=0, off=15490, siz=4, lab1=.L3744, lab2=, loff=0
!   reloc[1906]: knd=0, off=15498, siz=4, lab1=.L3746, lab2=, loff=0
!   reloc[1907]: knd=0, off=15506, siz=4, lab1=.L3747, lab2=, loff=0
!   reloc[1908]: knd=0, off=15514, siz=4, lab1=.L3749, lab2=, loff=0
!   reloc[1909]: knd=0, off=15522, siz=4, lab1=.L3750, lab2=, loff=0
!   reloc[1910]: knd=0, off=15530, siz=4, lab1=.L3752, lab2=, loff=0
!   reloc[1911]: knd=0, off=15538, siz=4, lab1=.L3753, lab2=, loff=0
!   reloc[1912]: knd=0, off=15546, siz=4, lab1=.L3755, lab2=, loff=0
!   reloc[1913]: knd=0, off=15554, siz=4, lab1=.L3756, lab2=, loff=0
!   reloc[1914]: knd=0, off=15562, siz=4, lab1=.L3758, lab2=, loff=0
!   reloc[1915]: knd=0, off=15570, siz=4, lab1=.L3759, lab2=, loff=0
!   reloc[1916]: knd=0, off=15578, siz=4, lab1=.L3761, lab2=, loff=0
!   reloc[1917]: knd=0, off=15586, siz=4, lab1=.L3762, lab2=, loff=0
!   reloc[1918]: knd=0, off=15594, siz=4, lab1=.L3764, lab2=, loff=0
!   reloc[1919]: knd=0, off=15602, siz=4, lab1=.L3765, lab2=, loff=0
!   reloc[1920]: knd=0, off=15610, siz=4, lab1=.L3767, lab2=, loff=0
!   reloc[1921]: knd=0, off=15618, siz=4, lab1=.L3768, lab2=, loff=0
!   reloc[1922]: knd=0, off=15626, siz=4, lab1=.L3770, lab2=, loff=0
!   reloc[1923]: knd=0, off=15634, siz=4, lab1=.L3771, lab2=, loff=0
!   reloc[1924]: knd=0, off=15642, siz=4, lab1=.L3773, lab2=, loff=0
!   reloc[1925]: knd=0, off=15650, siz=4, lab1=.L3774, lab2=, loff=0
!   reloc[1926]: knd=0, off=15658, siz=4, lab1=.L3775, lab2=, loff=0
!   reloc[1927]: knd=0, off=15666, siz=4, lab1=.L3778, lab2=, loff=0
!   reloc[1928]: knd=0, off=15674, siz=4, lab1=.L3785, lab2=, loff=0
!   reloc[1929]: knd=0, off=15682, siz=4, lab1=.L3788, lab2=, loff=0
!   reloc[1930]: knd=0, off=15690, siz=4, lab1=.L3791, lab2=, loff=0
!   reloc[1931]: knd=0, off=15700, siz=4, lab1=.L3793, lab2=, loff=0
!   reloc[1932]: knd=0, off=15708, siz=4, lab1=.L3794, lab2=, loff=0
!   reloc[1933]: knd=0, off=15716, siz=4, lab1=.L3796, lab2=, loff=0
!   reloc[1934]: knd=0, off=15724, siz=4, lab1=.L3797, lab2=, loff=0
!   reloc[1935]: knd=0, off=15732, siz=4, lab1=.L3799, lab2=, loff=0
!   reloc[1936]: knd=0, off=15740, siz=4, lab1=.L3800, lab2=, loff=0
!   reloc[1937]: knd=0, off=15748, siz=4, lab1=.L3802, lab2=, loff=0
!   reloc[1938]: knd=0, off=15756, siz=4, lab1=.L3803, lab2=, loff=0
!   reloc[1939]: knd=0, off=15764, siz=4, lab1=.L3805, lab2=, loff=0
!   reloc[1940]: knd=0, off=15772, siz=4, lab1=.L3806, lab2=, loff=0
!   reloc[1941]: knd=0, off=15780, siz=4, lab1=.L3808, lab2=, loff=0
!   reloc[1942]: knd=0, off=15788, siz=4, lab1=.L3809, lab2=, loff=0
!   reloc[1943]: knd=0, off=15796, siz=4, lab1=.L3811, lab2=, loff=0
!   reloc[1944]: knd=0, off=15804, siz=4, lab1=.L3812, lab2=, loff=0
!   reloc[1945]: knd=0, off=15812, siz=4, lab1=.L3814, lab2=, loff=0
!   reloc[1946]: knd=0, off=15820, siz=4, lab1=.L3815, lab2=, loff=0
!   reloc[1947]: knd=0, off=15828, siz=4, lab1=.L3817, lab2=, loff=0
!   reloc[1948]: knd=0, off=15836, siz=4, lab1=.L3818, lab2=, loff=0
!   reloc[1949]: knd=0, off=15844, siz=4, lab1=.L3820, lab2=, loff=0
!   reloc[1950]: knd=0, off=15852, siz=4, lab1=.L3821, lab2=, loff=0
!   reloc[1951]: knd=0, off=15860, siz=4, lab1=.L3823, lab2=, loff=0
!   reloc[1952]: knd=0, off=15868, siz=4, lab1=.L3824, lab2=, loff=0
!   reloc[1953]: knd=0, off=15876, siz=4, lab1=.L3826, lab2=, loff=0
!   reloc[1954]: knd=0, off=15884, siz=4, lab1=.L3827, lab2=, loff=0
!   reloc[1955]: knd=0, off=15892, siz=4, lab1=.L3829, lab2=, loff=0
!   reloc[1956]: knd=0, off=15900, siz=4, lab1=.L3830, lab2=, loff=0
!   reloc[1957]: knd=0, off=15908, siz=4, lab1=.L3832, lab2=, loff=0
!   reloc[1958]: knd=0, off=15916, siz=4, lab1=.L3833, lab2=, loff=0
!   reloc[1959]: knd=0, off=15924, siz=4, lab1=.L3835, lab2=, loff=0
!   reloc[1960]: knd=0, off=15932, siz=4, lab1=.L3836, lab2=, loff=0
!   reloc[1961]: knd=0, off=15940, siz=4, lab1=.L3838, lab2=, loff=0
!   reloc[1962]: knd=0, off=15948, siz=4, lab1=.L3839, lab2=, loff=0
!   reloc[1963]: knd=0, off=15956, siz=4, lab1=.L3841, lab2=, loff=0
!   reloc[1964]: knd=0, off=15964, siz=4, lab1=.L3842, lab2=, loff=0
!   reloc[1965]: knd=0, off=15972, siz=4, lab1=.L3844, lab2=, loff=0
!   reloc[1966]: knd=0, off=15980, siz=4, lab1=.L3845, lab2=, loff=0
!   reloc[1967]: knd=0, off=15988, siz=4, lab1=.L3847, lab2=, loff=0
!   reloc[1968]: knd=0, off=15996, siz=4, lab1=.L3848, lab2=, loff=0
!   reloc[1969]: knd=0, off=16004, siz=4, lab1=.L3850, lab2=, loff=0
!   reloc[1970]: knd=0, off=16012, siz=4, lab1=.L3851, lab2=, loff=0
!   reloc[1971]: knd=0, off=16020, siz=4, lab1=.L3853, lab2=, loff=0
!   reloc[1972]: knd=0, off=16028, siz=4, lab1=.L3854, lab2=, loff=0
!   reloc[1973]: knd=0, off=16036, siz=4, lab1=.L3856, lab2=, loff=0
!   reloc[1974]: knd=0, off=16044, siz=4, lab1=.L3857, lab2=, loff=0
!   reloc[1975]: knd=0, off=16052, siz=4, lab1=.L3859, lab2=, loff=0
!   reloc[1976]: knd=0, off=16060, siz=4, lab1=.L3860, lab2=, loff=0
!   reloc[1977]: knd=0, off=16068, siz=4, lab1=.L3862, lab2=, loff=0
!   reloc[1978]: knd=0, off=16076, siz=4, lab1=.L3863, lab2=, loff=0
!   reloc[1979]: knd=0, off=16084, siz=4, lab1=.L3865, lab2=, loff=0
!   reloc[1980]: knd=0, off=16092, siz=4, lab1=.L3866, lab2=, loff=0
!   reloc[1981]: knd=0, off=16100, siz=4, lab1=.L3867, lab2=, loff=0
!   reloc[1982]: knd=0, off=16108, siz=4, lab1=.L3869, lab2=, loff=0
!   reloc[1983]: knd=0, off=16116, siz=4, lab1=.L3870, lab2=, loff=0
!   reloc[1984]: knd=0, off=16124, siz=4, lab1=.L3872, lab2=, loff=0
!   reloc[1985]: knd=0, off=16132, siz=4, lab1=.L3873, lab2=, loff=0
!   reloc[1986]: knd=0, off=16140, siz=4, lab1=.L3875, lab2=, loff=0
!   reloc[1987]: knd=0, off=16148, siz=4, lab1=.L3876, lab2=, loff=0
!   reloc[1988]: knd=0, off=16156, siz=4, lab1=.L3878, lab2=, loff=0
!   reloc[1989]: knd=0, off=16164, siz=4, lab1=.L3879, lab2=, loff=0
!   reloc[1990]: knd=0, off=16172, siz=4, lab1=.L3881, lab2=, loff=0
!   reloc[1991]: knd=0, off=16180, siz=4, lab1=.L3882, lab2=, loff=0
!   reloc[1992]: knd=0, off=16188, siz=4, lab1=.L3884, lab2=, loff=0
!   reloc[1993]: knd=0, off=16196, siz=4, lab1=.L3885, lab2=, loff=0
!   reloc[1994]: knd=0, off=16204, siz=4, lab1=.L3886, lab2=, loff=0
!   reloc[1995]: knd=0, off=16212, siz=4, lab1=.L3887, lab2=, loff=0
!   reloc[1996]: knd=0, off=16220, siz=4, lab1=.L3889, lab2=, loff=0
!   reloc[1997]: knd=0, off=16228, siz=4, lab1=.L3890, lab2=, loff=0
!   reloc[1998]: knd=0, off=16236, siz=4, lab1=.L3891, lab2=, loff=0
!   reloc[1999]: knd=0, off=16244, siz=4, lab1=.L3893, lab2=, loff=0
!   reloc[2000]: knd=0, off=16254, siz=4, lab1=.L3894, lab2=, loff=0
!   reloc[2001]: knd=0, off=16262, siz=4, lab1=.L3896, lab2=, loff=0
!   reloc[2002]: knd=0, off=16272, siz=4, lab1=.L3897, lab2=, loff=0
!   reloc[2003]: knd=0, off=16280, siz=4, lab1=.L3899, lab2=, loff=0
!   reloc[2004]: knd=0, off=16288, siz=4, lab1=.L3900, lab2=, loff=0
!   reloc[2005]: knd=0, off=16296, siz=4, lab1=.L3902, lab2=, loff=0
!   reloc[2006]: knd=0, off=16304, siz=4, lab1=.L3903, lab2=, loff=0
!   reloc[2007]: knd=0, off=16312, siz=4, lab1=.L3905, lab2=, loff=0
!   reloc[2008]: knd=0, off=16320, siz=4, lab1=.L3906, lab2=, loff=0
!   reloc[2009]: knd=0, off=16328, siz=4, lab1=.L3909, lab2=, loff=0
!   reloc[2010]: knd=0, off=16336, siz=4, lab1=.L3916, lab2=, loff=0
!   reloc[2011]: knd=0, off=16344, siz=4, lab1=.L3919, lab2=, loff=0
!   reloc[2012]: knd=0, off=16352, siz=4, lab1=.L3922, lab2=, loff=0
!   reloc[2013]: knd=0, off=16362, siz=4, lab1=.L3925, lab2=, loff=0
!   reloc[2014]: knd=0, off=16370, siz=4, lab1=.L3932, lab2=, loff=0
!   reloc[2015]: knd=0, off=16378, siz=4, lab1=.L3935, lab2=, loff=0
!   reloc[2016]: knd=0, off=16386, siz=4, lab1=.L3938, lab2=, loff=0
!   reloc[2017]: knd=0, off=16396, siz=4, lab1=.L3940, lab2=, loff=0
!   reloc[2018]: knd=0, off=16404, siz=4, lab1=.L3941, lab2=, loff=0
!   reloc[2019]: knd=0, off=16412, siz=4, lab1=.L3943, lab2=, loff=0
!   reloc[2020]: knd=0, off=16420, siz=4, lab1=.L3944, lab2=, loff=0
!   reloc[2021]: knd=0, off=16428, siz=4, lab1=.L3946, lab2=, loff=0
!   reloc[2022]: knd=0, off=16436, siz=4, lab1=.L3947, lab2=, loff=0
!   reloc[2023]: knd=0, off=16444, siz=4, lab1=.L3949, lab2=, loff=0
!   reloc[2024]: knd=0, off=16452, siz=4, lab1=.L3950, lab2=, loff=0
!   reloc[2025]: knd=0, off=16460, siz=4, lab1=.L3952, lab2=, loff=0
!   reloc[2026]: knd=0, off=16468, siz=4, lab1=.L3953, lab2=, loff=0
!   reloc[2027]: knd=0, off=16476, siz=4, lab1=.L3955, lab2=, loff=0
!   reloc[2028]: knd=0, off=16484, siz=4, lab1=.L3956, lab2=, loff=0
!   reloc[2029]: knd=0, off=16492, siz=4, lab1=.L3958, lab2=, loff=0
!   reloc[2030]: knd=0, off=16500, siz=4, lab1=.L3959, lab2=, loff=0
!   reloc[2031]: knd=0, off=16508, siz=4, lab1=.L3961, lab2=, loff=0
!   reloc[2032]: knd=0, off=16516, siz=4, lab1=.L3962, lab2=, loff=0
!   reloc[2033]: knd=0, off=16524, siz=4, lab1=.L3963, lab2=, loff=0
!   reloc[2034]: knd=0, off=16532, siz=4, lab1=.L3964, lab2=, loff=0
!   reloc[2035]: knd=0, off=16540, siz=4, lab1=.L3965, lab2=, loff=0
!   reloc[2036]: knd=0, off=16548, siz=4, lab1=.L3967, lab2=, loff=0
!   reloc[2037]: knd=0, off=16556, siz=4, lab1=.L3968, lab2=, loff=0
!   reloc[2038]: knd=0, off=16564, siz=4, lab1=.L3970, lab2=, loff=0
!   reloc[2039]: knd=0, off=16572, siz=4, lab1=.L3971, lab2=, loff=0
!   reloc[2040]: knd=0, off=16580, siz=4, lab1=.L3973, lab2=, loff=0
!   reloc[2041]: knd=0, off=16588, siz=4, lab1=.L3974, lab2=, loff=0
!   reloc[2042]: knd=0, off=16596, siz=4, lab1=.L3976, lab2=, loff=0
!   reloc[2043]: knd=0, off=16604, siz=4, lab1=.L3977, lab2=, loff=0
!   reloc[2044]: knd=0, off=16612, siz=4, lab1=.L3979, lab2=, loff=0
!   reloc[2045]: knd=0, off=16620, siz=4, lab1=.L3980, lab2=, loff=0
!   reloc[2046]: knd=0, off=16628, siz=4, lab1=.L3982, lab2=, loff=0
!   reloc[2047]: knd=0, off=16636, siz=4, lab1=.L3983, lab2=, loff=0
!   reloc[2048]: knd=0, off=16644, siz=4, lab1=.L3985, lab2=, loff=0
!   reloc[2049]: knd=0, off=16652, siz=4, lab1=.L3986, lab2=, loff=0
!   reloc[2050]: knd=0, off=16660, siz=4, lab1=.L3988, lab2=, loff=0
!   reloc[2051]: knd=0, off=16668, siz=4, lab1=.L3989, lab2=, loff=0
!   reloc[2052]: knd=0, off=16676, siz=4, lab1=.L3991, lab2=, loff=0
!   reloc[2053]: knd=0, off=16684, siz=4, lab1=.L3992, lab2=, loff=0
!   reloc[2054]: knd=0, off=16692, siz=4, lab1=.L3994, lab2=, loff=0
!   reloc[2055]: knd=0, off=16700, siz=4, lab1=.L3995, lab2=, loff=0
!   reloc[2056]: knd=0, off=16708, siz=4, lab1=.L3997, lab2=, loff=0
!   reloc[2057]: knd=0, off=16716, siz=4, lab1=.L3998, lab2=, loff=0
!   reloc[2058]: knd=0, off=16724, siz=4, lab1=.L4000, lab2=, loff=0
!   reloc[2059]: knd=0, off=16732, siz=4, lab1=.L4001, lab2=, loff=0
!   reloc[2060]: knd=0, off=16740, siz=4, lab1=.L4003, lab2=, loff=0
!   reloc[2061]: knd=0, off=16748, siz=4, lab1=.L4004, lab2=, loff=0
!   reloc[2062]: knd=0, off=16756, siz=4, lab1=.L4006, lab2=, loff=0
!   reloc[2063]: knd=0, off=16764, siz=4, lab1=.L4007, lab2=, loff=0
!   reloc[2064]: knd=0, off=16772, siz=4, lab1=.L4009, lab2=, loff=0
!   reloc[2065]: knd=0, off=16780, siz=4, lab1=.L4010, lab2=, loff=0
!   reloc[2066]: knd=0, off=16788, siz=4, lab1=.L4012, lab2=, loff=0
!   reloc[2067]: knd=0, off=16796, siz=4, lab1=.L4016, lab2=, loff=0
!   reloc[2068]: knd=0, off=16804, siz=4, lab1=.L4018, lab2=, loff=0
!   reloc[2069]: knd=0, off=16812, siz=4, lab1=.L4022, lab2=, loff=0
!   reloc[2070]: knd=0, off=16820, siz=4, lab1=.L4024, lab2=, loff=0
!   reloc[2071]: knd=0, off=16828, siz=4, lab1=.L4028, lab2=, loff=0
!   reloc[2072]: knd=0, off=16836, siz=4, lab1=.L4030, lab2=, loff=0
!   reloc[2073]: knd=0, off=16844, siz=4, lab1=.L4031, lab2=, loff=0
!   reloc[2074]: knd=0, off=16852, siz=4, lab1=.L4032, lab2=, loff=0
!   reloc[2075]: knd=0, off=16860, siz=4, lab1=.L4033, lab2=, loff=0
!   reloc[2076]: knd=0, off=16868, siz=4, lab1=.L4034, lab2=, loff=0
!   reloc[2077]: knd=0, off=16876, siz=4, lab1=.L4036, lab2=, loff=0
!   reloc[2078]: knd=0, off=16884, siz=4, lab1=.L4037, lab2=, loff=0
!   reloc[2079]: knd=0, off=16892, siz=4, lab1=.L4039, lab2=, loff=0
!   reloc[2080]: knd=0, off=16900, siz=4, lab1=.L4043, lab2=, loff=0
!   reloc[2081]: knd=0, off=16908, siz=4, lab1=.L4045, lab2=, loff=0
!   reloc[2082]: knd=0, off=16916, siz=4, lab1=.L4049, lab2=, loff=0
!   reloc[2083]: knd=0, off=16924, siz=4, lab1=.L4051, lab2=, loff=0
!   reloc[2084]: knd=0, off=16932, siz=4, lab1=.L4055, lab2=, loff=0
!   reloc[2085]: knd=0, off=16940, siz=4, lab1=.L4057, lab2=, loff=0
!   reloc[2086]: knd=0, off=16948, siz=4, lab1=.L4061, lab2=, loff=0
!   reloc[2087]: knd=0, off=16956, siz=4, lab1=.L4064, lab2=, loff=0
!   reloc[2088]: knd=0, off=16964, siz=4, lab1=.L4071, lab2=, loff=0
!   reloc[2089]: knd=0, off=16972, siz=4, lab1=.L4074, lab2=, loff=0
!   reloc[2090]: knd=0, off=16980, siz=4, lab1=.L4077, lab2=, loff=0
!   reloc[2091]: knd=0, off=16990, siz=4, lab1=.L4079, lab2=, loff=0
!   reloc[2092]: knd=0, off=16998, siz=4, lab1=.L4080, lab2=, loff=0
!   reloc[2093]: knd=0, off=17006, siz=4, lab1=.L4082, lab2=, loff=0
!   reloc[2094]: knd=0, off=17014, siz=4, lab1=.L4083, lab2=, loff=0
!   reloc[2095]: knd=0, off=17022, siz=4, lab1=.L4085, lab2=, loff=0
!   reloc[2096]: knd=0, off=17030, siz=4, lab1=.L4086, lab2=, loff=0
!   reloc[2097]: knd=0, off=17038, siz=4, lab1=.L4088, lab2=, loff=0
!   reloc[2098]: knd=0, off=17046, siz=4, lab1=.L4089, lab2=, loff=0
!   reloc[2099]: knd=0, off=17054, siz=4, lab1=.L4091, lab2=, loff=0
!   reloc[2100]: knd=0, off=17062, siz=4, lab1=.L4092, lab2=, loff=0
!   reloc[2101]: knd=0, off=17070, siz=4, lab1=.L4094, lab2=, loff=0
!   reloc[2102]: knd=0, off=17078, siz=4, lab1=.L4095, lab2=, loff=0
!   reloc[2103]: knd=0, off=17086, siz=4, lab1=.L4097, lab2=, loff=0
!   reloc[2104]: knd=0, off=17094, siz=4, lab1=.L4098, lab2=, loff=0
!   reloc[2105]: knd=0, off=17102, siz=4, lab1=.L4100, lab2=, loff=0
!   reloc[2106]: knd=0, off=17110, siz=4, lab1=.L4101, lab2=, loff=0
!   reloc[2107]: knd=0, off=17118, siz=4, lab1=.L4103, lab2=, loff=0
!   reloc[2108]: knd=0, off=17126, siz=4, lab1=.L4104, lab2=, loff=0
!   reloc[2109]: knd=0, off=17134, siz=4, lab1=.L4106, lab2=, loff=0
!   reloc[2110]: knd=0, off=17142, siz=4, lab1=.L4107, lab2=, loff=0
!   reloc[2111]: knd=0, off=17150, siz=4, lab1=.L4108, lab2=, loff=0
!   reloc[2112]: knd=0, off=17158, siz=4, lab1=.L4109, lab2=, loff=0
!   reloc[2113]: knd=0, off=17166, siz=4, lab1=.L4110, lab2=, loff=0
!   reloc[2114]: knd=0, off=17174, siz=4, lab1=.L4112, lab2=, loff=0
!   reloc[2115]: knd=0, off=17182, siz=4, lab1=.L4113, lab2=, loff=0
!   reloc[2116]: knd=0, off=17190, siz=4, lab1=.L4115, lab2=, loff=0
!   reloc[2117]: knd=0, off=17198, siz=4, lab1=.L4116, lab2=, loff=0
!   reloc[2118]: knd=0, off=17206, siz=4, lab1=.L4118, lab2=, loff=0
!   reloc[2119]: knd=0, off=17214, siz=4, lab1=.L4119, lab2=, loff=0
!   reloc[2120]: knd=0, off=17222, siz=4, lab1=.L4121, lab2=, loff=0
!   reloc[2121]: knd=0, off=17230, siz=4, lab1=.L4122, lab2=, loff=0
!   reloc[2122]: knd=0, off=17238, siz=4, lab1=.L4124, lab2=, loff=0
!   reloc[2123]: knd=0, off=17246, siz=4, lab1=.L4125, lab2=, loff=0
!   reloc[2124]: knd=0, off=17254, siz=4, lab1=.L4127, lab2=, loff=0
!   reloc[2125]: knd=0, off=17262, siz=4, lab1=.L4128, lab2=, loff=0
!   reloc[2126]: knd=0, off=17270, siz=4, lab1=.L4130, lab2=, loff=0
!   reloc[2127]: knd=0, off=17278, siz=4, lab1=.L4131, lab2=, loff=0
!   reloc[2128]: knd=0, off=17286, siz=4, lab1=.L4133, lab2=, loff=0
!   reloc[2129]: knd=0, off=17294, siz=4, lab1=.L4134, lab2=, loff=0
!   reloc[2130]: knd=0, off=17302, siz=4, lab1=.L4136, lab2=, loff=0
!   reloc[2131]: knd=0, off=17310, siz=4, lab1=.L4137, lab2=, loff=0
!   reloc[2132]: knd=0, off=17318, siz=4, lab1=.L4139, lab2=, loff=0
!   reloc[2133]: knd=0, off=17326, siz=4, lab1=.L4140, lab2=, loff=0
!   reloc[2134]: knd=0, off=17334, siz=4, lab1=.L4142, lab2=, loff=0
!   reloc[2135]: knd=0, off=17342, siz=4, lab1=.L4143, lab2=, loff=0
!   reloc[2136]: knd=0, off=17350, siz=4, lab1=.L4145, lab2=, loff=0
!   reloc[2137]: knd=0, off=17358, siz=4, lab1=.L4146, lab2=, loff=0
!   reloc[2138]: knd=0, off=17366, siz=4, lab1=.L4148, lab2=, loff=0
!   reloc[2139]: knd=0, off=17374, siz=4, lab1=.L4149, lab2=, loff=0
!   reloc[2140]: knd=0, off=17382, siz=4, lab1=.L4151, lab2=, loff=0
!   reloc[2141]: knd=0, off=17390, siz=4, lab1=.L4152, lab2=, loff=0
!   reloc[2142]: knd=0, off=17398, siz=4, lab1=.L4154, lab2=, loff=0
!   reloc[2143]: knd=0, off=17406, siz=4, lab1=.L4155, lab2=, loff=0
!   reloc[2144]: knd=0, off=17414, siz=4, lab1=.L4157, lab2=, loff=0
!   reloc[2145]: knd=0, off=17422, siz=4, lab1=.L4158, lab2=, loff=0
!   reloc[2146]: knd=0, off=17430, siz=4, lab1=.L4160, lab2=, loff=0
!   reloc[2147]: knd=0, off=17438, siz=4, lab1=.L4161, lab2=, loff=0
!   reloc[2148]: knd=0, off=17446, siz=4, lab1=.L4163, lab2=, loff=0
!   reloc[2149]: knd=0, off=17454, siz=4, lab1=.L4164, lab2=, loff=0
!   reloc[2150]: knd=0, off=17462, siz=4, lab1=.L4166, lab2=, loff=0
!   reloc[2151]: knd=0, off=17470, siz=4, lab1=.L4167, lab2=, loff=0
!   reloc[2152]: knd=0, off=17478, siz=4, lab1=.L4169, lab2=, loff=0
!   reloc[2153]: knd=0, off=17486, siz=4, lab1=.L4170, lab2=, loff=0
!   reloc[2154]: knd=0, off=17494, siz=4, lab1=.L4172, lab2=, loff=0
!   reloc[2155]: knd=0, off=17502, siz=4, lab1=.L4173, lab2=, loff=0
!   reloc[2156]: knd=0, off=17510, siz=4, lab1=.L4175, lab2=, loff=0
!   reloc[2157]: knd=0, off=17518, siz=4, lab1=.L4176, lab2=, loff=0
!   reloc[2158]: knd=0, off=17526, siz=4, lab1=.L4178, lab2=, loff=0
!   reloc[2159]: knd=0, off=17534, siz=4, lab1=.L4179, lab2=, loff=0
!   reloc[2160]: knd=0, off=17542, siz=4, lab1=.L4181, lab2=, loff=0
!   reloc[2161]: knd=0, off=17550, siz=4, lab1=.L4182, lab2=, loff=0
!   reloc[2162]: knd=0, off=17558, siz=4, lab1=.L4184, lab2=, loff=0
!   reloc[2163]: knd=0, off=17566, siz=4, lab1=.L4185, lab2=, loff=0
!   reloc[2164]: knd=0, off=17574, siz=4, lab1=.L4187, lab2=, loff=0
!   reloc[2165]: knd=0, off=17584, siz=4, lab1=.L4191, lab2=, loff=0
!   reloc[2166]: knd=0, off=17595, siz=4, lab1=.L4194, lab2=, loff=0
!   reloc[2167]: knd=0, off=17611, siz=4, lab1=gl_GetPointerv, lab2=, loff=0
!   reloc[2168]: knd=0, off=17618, siz=4, lab1=.L4204, lab2=, loff=0
!   reloc[2169]: knd=0, off=17630, siz=4, lab1=.L4208, lab2=, loff=0
!   reloc[2170]: knd=0, off=17638, siz=4, lab1=.L4209, lab2=, loff=0
!   reloc[2171]: knd=0, off=17646, siz=4, lab1=.L4211, lab2=, loff=0
!   reloc[2172]: knd=0, off=17654, siz=4, lab1=.L4212, lab2=, loff=0
!   reloc[2173]: knd=0, off=17662, siz=4, lab1=.L4214, lab2=, loff=0
!   reloc[2174]: knd=0, off=17670, siz=4, lab1=.L4215, lab2=, loff=0
!   reloc[2175]: knd=0, off=17678, siz=4, lab1=.L4217, lab2=, loff=0
!   reloc[2176]: knd=0, off=17686, siz=4, lab1=.L4218, lab2=, loff=0
!   reloc[2177]: knd=0, off=17694, siz=4, lab1=.L4220, lab2=, loff=0
!   reloc[2178]: knd=0, off=17702, siz=4, lab1=.L4221, lab2=, loff=0
!   reloc[2179]: knd=0, off=17710, siz=4, lab1=.L4223, lab2=, loff=0
!   reloc[2180]: knd=0, off=17718, siz=4, lab1=.L4224, lab2=, loff=0
!   reloc[2181]: knd=0, off=17726, siz=4, lab1=.L4226, lab2=, loff=0
!   reloc[2182]: knd=0, off=17734, siz=4, lab1=.L4227, lab2=, loff=0
!   reloc[2183]: knd=0, off=17742, siz=4, lab1=.L4229, lab2=, loff=0
!   reloc[2184]: knd=0, off=17750, siz=4, lab1=.L4231, lab2=, loff=0
!   reloc[2185]: knd=0, off=17758, siz=4, lab1=.L4234, lab2=, loff=0
!   reloc[2186]: knd=0, off=17768, siz=4, lab1=.L4237, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x45,0x70,0x00,0x02,0x00,0x00
	.byte 0x00,0x6e,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x67,0x65,0x74,0x2e,0x63
	.byte 0x00,0x01,0x00,0x00,0x74,0x79,0x70,0x65
	.byte 0x73,0x2e,0x68,0x00,0x01,0x00,0x00,0x67
	.byte 0x6c,0x2e,0x68,0x00,0x02,0x00,0x00,0x64
	.byte 0x64,0x2e,0x68,0x00,0x01,0x00,0x00,0x00
	.byte 0x00,0x05,0x02
	.uaword gl_GetBooleanv
	.byte 0x00,0x05,0x02
	.uaword .L18
	.byte 0x06,0x03,0xe6,0x00,0x01,0x00,0x05,0x02
	.uaword .L22
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L24
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L31
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L38
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L42
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L44
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L48
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L52
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L56
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L60
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L62
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L66
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L68
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L72
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L74
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L78
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L80
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L81
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L83
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L87
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L89
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L93
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L95
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L99
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L101
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L102
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L104
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L105
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L107
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L108
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L110
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L116
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L120
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L122
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L126
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L128
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L144
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L146
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L150
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L152
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L158
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L164
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L175
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L186
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L190
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L194
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L196
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L197
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L199
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L203
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L205
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L209
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L219
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L223
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L229
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L232
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L238
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L242
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L246
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L250
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L254
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L256
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L260
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L262
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L266
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L270
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L274
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L276
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L280
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L288
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L292
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L294
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L298
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L300
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L306
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L310
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L314
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L322
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L324
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L328
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L336
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L340
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L342
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L343
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L345
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L349
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L353
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L357
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L361
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L363
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L367
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L369
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L373
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L375
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L379
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L381
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L385
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L387
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L391
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L395
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L397
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L401
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L403
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L404
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L406
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L409
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L410
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L412
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L413
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L415
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L419
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L421
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L422
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L424
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L428
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L430
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L434
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L436
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L437
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L439
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L451
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L455
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L457
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L461
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L463
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L467
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L469
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L475
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L479
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L481
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L485
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L487
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L491
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L493
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L497
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L499
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L503
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L505
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L509
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L511
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L517
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L521
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L529
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L533
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L535
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L545
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L547
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L551
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L560
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L561
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L563
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L564
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L566
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L570
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L574
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L582
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L584
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L585
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L587
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L588
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L590
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L591
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L593
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L599
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L600
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L602
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L606
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L608
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L612
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L614
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L618
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L620
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L624
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L626
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L630
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L634
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L636
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L640
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L642
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L646
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L648
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L655
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L657
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L658
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L660
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L661
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L663
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L667
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L669
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L670
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L672
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L676
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L682
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L686
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L688
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L689
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L691
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L694
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L695
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L697
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L698
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L700
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L701
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L703
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L704
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L706
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L707
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L709
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L710
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L712
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L713
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L715
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L719
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L723
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L727
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L731
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L733
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L737
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L741
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L743
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L744
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L746
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L747
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L749
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L752
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L753
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L755
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L756
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L758
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L759
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L761
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L764
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L765
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L767
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L768
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L770
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L771
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L773
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L777
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L779
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L780
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L782
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L783
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L785
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L786
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L788
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L789
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L791
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L792
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L794
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L795
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L797
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L798
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L800
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L803
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L804
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L806
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L807
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L809
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L810
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L812
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L813
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L815
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L816
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L817
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L820
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L827
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L833
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L836
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L838
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L842
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L844
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L853
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L857
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L859
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L860
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L862
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L866
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L868
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L872
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L874
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L878
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L880
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L881
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L883
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L884
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L886
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L887
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L889
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L893
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L895
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L899
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L901
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L905
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L907
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L911
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L913
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L919
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L923
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L925
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L929
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L931
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L935
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L937
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L943
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L947
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L949
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L955
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L961
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L965
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L967
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L971
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L975
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L977
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L978
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L980
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L984
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L986
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L990
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L992
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L998
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1002
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1004
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1008
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1012
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1018
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1022
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1026
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1028
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1032
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1034
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1038
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1040
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1044
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1046
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1049
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1053
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1055
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1056
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1059
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1066
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1072
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1075
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1077
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1081
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1083
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1087
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1089
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1093
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1095
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1099
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1101
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1105
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1107
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1111
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1113
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1114
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1116
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1120
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1124
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1128
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1134
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1137
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1141
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1143
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1144
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1146
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1150
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1152
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1158
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1164
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1170
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1174
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1176
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1180
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1182
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1186
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1188
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1189
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1191
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1195
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1197
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1201
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1203
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1204
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1206
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1207
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1209
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1213
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1215
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1219
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1221
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1225
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1227
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1235
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1243
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1245
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1249
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1251
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1255
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1257
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1261
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1263
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1267
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1269
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1273
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1276
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1283
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1289
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1292
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1294
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1298
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1300
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1306
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1307
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1309
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1315
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1319
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1321
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1325
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1327
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1328
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1330
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1331
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1333
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1334
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1336
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1340
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1354
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1358
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1360
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1364
	.byte 0x0c,0x00,0x05
	.byte 0x02
	.uaword .L1366
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1370
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1372
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1376
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1378
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1382
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1384
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1385
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1387
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1391
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1393
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1397
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1399
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1400
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1402
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1406
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1408
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1412
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1414
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1418
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1420
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1421
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1423
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1427
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1429
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1433
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1435
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1436
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1438
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1442
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1444
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1448
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1450
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1454
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1456
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1459
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1463
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1465
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1466
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1468
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1474
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1478
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1480
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1484
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1486
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1490
	.byte 0x03,0xec,0x79,0x01,0x00,0x05,0x02
	.uaword .L1493
	.byte 0x03,0x96,0x06,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetDoublev
	.byte 0x00,0x05,0x02
	.uaword .L1502
	.byte 0x06,0x03,0x8a,0x07,0x01,0x00,0x05,0x02
	.uaword .L1506
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1515
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1522
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1523
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1525
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1526
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1528
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1529
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1531
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1532
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1534
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1535
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1537
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1538
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1540
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1541
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1543
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1546
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1547
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1549
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1550
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1552
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1553
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1555
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1556
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1558
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1559
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1561
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1562
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1564
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1567
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1568
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1570
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1571
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1572
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1573
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1574
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1576
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1579
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1580
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1582
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1583
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1585
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1586
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1593
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1594
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1596
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1598
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1599
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1600
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1602
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1603
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1605
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1606
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1608
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1609
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1611
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1615
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1619
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1623
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1627
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1629
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1630
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1632
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1633
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1635
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1636
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1637
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1638
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1639
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1641
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1642
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1644
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1645
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1646
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1647
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1649
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1650
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1651
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1652
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1653
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1655
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1656
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1658
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1659
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1661
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1662
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1663
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1667
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1669
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1670
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1671
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1673
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1674
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1676
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1677
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1678
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1679
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1682
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1685
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1686
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1688
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1689
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1691
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1694
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1695
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1696
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1698
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1699
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1701
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1702
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1704
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1707
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1710
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1711
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1713
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1716
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1717
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1719
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1720
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1722
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1723
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1725
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1726
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1728
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1729
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1730
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1731
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1732
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1734
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1735
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1737
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1738
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1740
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1741
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1743
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1744
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1746
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1747
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1749
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1752
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1753
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1755
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1756
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1758
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1759
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1761
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1764
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1765
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1767
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1768
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1770
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1774
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1776
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1777
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1779
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1780
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1782
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1783
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1792
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L1793
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1795
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1798
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1799
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1800
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1802
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1804
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1805
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1807
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1810
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1811
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1813
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1816
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1817
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1819
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1820
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1822
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1823
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1825
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1828
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1829
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1831
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1832
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1833
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1835
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1836
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1838
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1839
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1841
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1845
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1847
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1853
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1854
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1856
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1857
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1859
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1860
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1863
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1864
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1866
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1867
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1869
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1872
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1873
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1875
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1876
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1878
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1879
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1881
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1882
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1884
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1885
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1887
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1888
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1890
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1891
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1893
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1894
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1895
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1896
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1897
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1899
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1900
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1901
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1903
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1904
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1906
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1907
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1909
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1910
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1912
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1913
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1915
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1916
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1918
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1919
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1921
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1922
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1924
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1925
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1927
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1928
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1930
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1931
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1933
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1934
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1936
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1937
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1939
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1940
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1942
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1943
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1945
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1946
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1948
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1949
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1951
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1952
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1954
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1955
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1957
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1958
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1960
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1961
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1963
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1964
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1966
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1967
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1969
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1970
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1972
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1973
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1974
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1977
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1984
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1987
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1990
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1992
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1993
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1995
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1998
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1999
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2001
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2002
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2004
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2005
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2007
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2008
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2010
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2011
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2013
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2014
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2016
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2017
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2019
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2020
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2022
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2023
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2025
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2026
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2028
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2029
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2031
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2032
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2034
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2035
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2037
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2038
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2040
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2041
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2043
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2044
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2046
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2049
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2050
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2052
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2053
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2055
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2056
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2058
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2059
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2061
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2062
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2064
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2065
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2066
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2068
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2069
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2071
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2072
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2074
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2075
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2077
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2078
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2080
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2081
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2083
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2084
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2085
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2086
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2088
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2089
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2090
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2092
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2093
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2095
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2096
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2098
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2099
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2101
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2102
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2104
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2105
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2108
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2115
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2118
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2121
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2124
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2134
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2137
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2139
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2142
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2143
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2145
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2146
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2148
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2149
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2151
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2152
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2154
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2155
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2157
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2160
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2161
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2162
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2163
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2164
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2166
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2169
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2170
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2172
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2173
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2175
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2179
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2181
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2184
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2185
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2187
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2188
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2190
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2191
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2193
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2194
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2196
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2197
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2199
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2200
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2202
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2203
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2205
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2206
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2208
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2209
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2217
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2221
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2223
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2229
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2232
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2233
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2235
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2238
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2242
	.byte 0x0c,0x00,0x05
	.byte 0x02
	.uaword .L2244
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2248
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2250
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2254
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2256
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2260
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2263
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2270
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2273
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2276
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2278
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2279
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2281
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2284
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2285
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2287
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2288
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2290
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2291
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2293
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2294
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2296
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2299
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2300
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2302
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2303
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2305
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2306
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2307
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2308
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2309
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2311
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2314
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2315
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2317
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2320
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2321
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2323
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2324
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2326
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2329
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2332
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2333
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2335
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2336
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2338
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2339
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2341
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2342
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2344
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2345
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2347
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2350
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2351
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2353
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2354
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2356
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2357
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2359
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2360
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2362
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2363
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2365
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2366
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2368
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2369
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2371
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2372
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2374
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2375
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2377
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2378
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2380
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2381
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2383
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2386
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2390
	.byte 0x03,0xe9,0x79,0x01,0x00,0x05,0x02
	.uaword .L2393
	.byte 0x03,0x99,0x06,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetFloatv
	.byte 0x00,0x05,0x02
	.uaword .L2402
	.byte 0x06,0x03,0xb1,0x0d,0x01,0x00,0x05,0x02
	.uaword .L2406
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2408
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2415
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2422
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2423
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2425
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2426
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2427
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2428
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2429
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2431
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2432
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2434
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2435
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2437
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2438
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2440
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2441
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2443
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2444
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2446
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2449
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2450
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2452
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2453
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2455
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2456
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2458
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2459
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2461
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2462
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2464
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2465
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2467
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2468
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2470
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2471
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2474
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2476
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2477
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2479
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2480
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2482
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2483
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2485
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2486
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2493
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2494
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2496
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2497
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2498
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2499
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2500
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2502
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2503
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2505
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2506
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2508
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2509
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2511
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2519
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2523
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2529
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2530
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2532
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2533
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2535
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2536
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2537
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2538
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2542
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2544
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2545
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2546
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2547
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2549
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2550
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2551
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2552
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2553
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2555
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2556
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2558
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2559
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2561
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2562
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2563
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2564
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2567
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2568
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2569
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2570
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2571
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2573
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2574
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2576
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2579
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2580
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2582
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2583
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2585
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2586
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2588
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2589
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2591
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2592
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2594
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2595
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2596
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2598
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2599
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2601
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2604
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2605
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2607
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2608
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2610
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2611
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2613
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2614
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2616
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2617
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2619
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2620
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2622
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2623
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2625
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2626
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2628
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2629
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2630
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2631
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2632
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2634
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2635
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2637
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2638
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2640
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2641
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2643
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2644
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2646
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2647
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2649
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2650
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2652
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2653
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2655
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2656
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2658
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2659
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2661
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2662
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2664
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2667
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2670
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2674
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2676
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2677
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2679
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2682
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2692
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L2693
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2695
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2696
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2698
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2699
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2700
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2701
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2702
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2704
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2707
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2710
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2711
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2713
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2716
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2717
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2719
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2720
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2722
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2723
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2725
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2726
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2728
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2729
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2731
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2732
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2733
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2735
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2736
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2738
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2739
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2741
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2745
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2747
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2748
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2750
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2751
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2753
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2754
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2756
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2757
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2759
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2760
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2761
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2763
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2764
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2766
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2767
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2769
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2770
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2772
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2773
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2775
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2776
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2778
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2779
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2781
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2782
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2784
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2785
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2787
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2788
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2790
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2791
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2793
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2795
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2797
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2799
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2800
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2803
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2804
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2806
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2807
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2809
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2810
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2812
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2813
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2815
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2816
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2818
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2819
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2821
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2822
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2824
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2825
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2827
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2828
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2830
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2831
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2833
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2836
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2837
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2839
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2840
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2842
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2843
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2845
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2846
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2848
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2849
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2851
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2852
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2854
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2855
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2857
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2858
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2860
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2863
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2864
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2866
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2867
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2869
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2872
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2873
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2874
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2877
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2884
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2887
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L2890
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2892
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2893
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2895
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2896
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2898
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2899
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2901
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2902
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2904
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2905
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2907
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2908
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2910
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2911
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2913
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2914
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2916
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2919
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2920
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2922
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2923
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2925
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2926
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2928
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2929
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2931
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2932
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2934
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2935
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2937
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2938
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2940
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2943
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2944
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2946
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2947
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2949
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2950
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2952
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2955
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2956
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2958
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2961
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2962
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2964
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2965
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2966
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2968
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2969
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2971
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2972
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2974
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2975
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2977
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2978
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2980
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2981
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2983
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2984
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2985
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2986
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2988
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2990
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2992
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2993
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2995
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2998
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2999
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3001
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3002
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3004
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3005
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3008
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3015
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3018
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3021
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3024
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3031
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3034
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3037
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3039
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3040
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3042
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3043
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3045
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3046
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3048
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3051
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3052
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3054
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3055
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3057
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3058
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3060
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3061
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3062
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3063
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3064
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3066
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3067
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3069
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3070
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3072
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3073
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3075
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3076
	.byte 0x0c
	.byte 0x00,0x05,0x02
	.uaword .L3078
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3079
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3081
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3082
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3084
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3085
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3087
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3088
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3090
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3091
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3093
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3094
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3096
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3097
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3099
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3100
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3102
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3103
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3105
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3106
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3108
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3109
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3111
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3115
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3117
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3121
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3123
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3127
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3129
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3130
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3133
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3135
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3138
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3142
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3144
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3148
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3150
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3154
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3156
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3160
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3163
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3170
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3173
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3176
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3179
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3181
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3184
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3185
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3187
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3188
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3190
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3191
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3193
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3194
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3196
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3197
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3199
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3200
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3202
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3203
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3205
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3206
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3207
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3208
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3209
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3212
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3214
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3217
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3218
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3220
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3221
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3223
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3224
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3226
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3229
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3232
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3233
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3235
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3236
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3238
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3241
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3242
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3244
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3245
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3247
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3248
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3250
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3251
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3253
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3254
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3256
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3257
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3259
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3260
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3262
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3263
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3265
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3266
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3268
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3269
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3271
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3272
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3274
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3275
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3277
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3278
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3280
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3281
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3283
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3286
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3290
	.byte 0x03,0xe9,0x79,0x01,0x00,0x05,0x02
	.uaword .L3293
	.byte 0x03,0x99,0x06,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetIntegerv
	.byte 0x00,0x05,0x02
	.uaword .L3302
	.byte 0x06,0x03,0xd7,0x13,0x01,0x00,0x05,0x02
	.uaword .L3306
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3308
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3315
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3322
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3323
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3325
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3328
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3329
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3331
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3334
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3335
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3337
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3338
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3340
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3341
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3343
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3346
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3347
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3349
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3350
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3352
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3353
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3355
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3356
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3358
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3359
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3361
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3364
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3365
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3367
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3368
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3370
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3371
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3372
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3373
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3374
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3376
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3377
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3379
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3380
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3382
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3383
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3385
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3393
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L3394
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3395
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3397
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3398
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3399
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3400
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3401
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3403
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3404
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3406
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3409
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3410
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3412
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3416
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3420
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3424
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3428
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3430
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3431
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3433
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3434
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3436
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3437
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3438
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3439
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3440
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3442
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3445
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3446
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3448
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3450
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3451
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3452
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3453
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3454
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3456
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3459
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3460
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3462
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3463
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3464
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3465
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3466
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3468
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3469
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3470
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3471
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3474
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3475
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3477
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3478
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3479
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3480
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3481
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3483
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3484
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3486
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3487
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3489
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3490
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3492
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3493
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3495
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3496
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3497
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3499
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3500
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3502
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3503
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3505
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3506
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3508
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3509
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3511
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3512
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3514
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3517
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3518
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3520
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3521
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3524
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3526
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3529
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3530
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3531
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3532
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3533
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3535
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3536
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3538
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3539
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3541
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3542
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3544
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3545
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3547
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3548
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3550
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3551
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3553
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3554
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3556
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3557
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3559
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3560
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3562
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3563
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3565
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3566
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3568
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3569
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3571
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3575
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3577
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3580
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3581
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3583
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3584
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3593
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L3594
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3596
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3599
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3600
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3601
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3602
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3603
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3605
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3606
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3608
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3609
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3611
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3612
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3614
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3615
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3617
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3618
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3620
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3621
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3623
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3624
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3626
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3627
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3629
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3630
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3632
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3633
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3634
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3636
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3637
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3639
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3640
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3642
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3646
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3648
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3649
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3651
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3652
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3654
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3655
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3657
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3658
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3660
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3661
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3662
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3664
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3667
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3670
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3671
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3673
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3674
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3676
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3677
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3679
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3682
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3685
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3686
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3688
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3689
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3691
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3694
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3695
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3696
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3697
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3698
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3700
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3701
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3702
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3704
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3707
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3710
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3711
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3713
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3716
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3717
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3719
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3720
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3722
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3723
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3725
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3726
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3728
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3729
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3731
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3732
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3734
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3735
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3737
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3738
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3740
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3741
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3743
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3744
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3746
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3747
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3749
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3750
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3752
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3753
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3755
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3756
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3758
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3759
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3761
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3764
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3765
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3767
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3768
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3770
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3771
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3773
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3774
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3775
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3778
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3785
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3788
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3791
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3793
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3796
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3797
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3799
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3800
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3802
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3803
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3805
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3806
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3808
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3809
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3811
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3814
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3815
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3817
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3818
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3820
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3821
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3823
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3824
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3826
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3827
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3829
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3832
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3833
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3835
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3836
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3838
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3839
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3841
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3842
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3844
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3845
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3847
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3850
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3853
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3854
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3856
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3857
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3859
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3860
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3862
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3863
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3865
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3866
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3867
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3869
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3870
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3872
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3873
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3875
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3876
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3878
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3879
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3881
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3882
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3884
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3885
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3886
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3887
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3889
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3890
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3891
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3893
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3894
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3896
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3897
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3899
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3900
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3902
	.byte 0x0d,0x00,0x05
	.byte 0x02
	.uaword .L3903
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3905
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3906
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3909
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3916
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3919
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3922
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3925
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3932
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3935
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3938
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3940
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3943
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3944
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3946
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3947
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3949
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3950
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3952
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3953
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3955
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3956
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3958
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3961
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3962
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3963
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3964
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3965
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3967
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3968
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3970
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3971
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3973
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3974
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3976
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3977
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3979
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3980
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3982
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3983
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3985
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3986
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3988
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3991
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3992
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3994
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3995
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3997
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3998
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4000
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4001
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4003
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4004
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4006
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4007
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4009
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4010
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4012
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4018
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4022
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4024
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4028
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4030
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4031
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4032
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4033
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4034
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4036
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4037
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4039
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4043
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4045
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4051
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4055
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4057
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4061
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4064
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4071
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4074
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L4077
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4079
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4080
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4082
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4083
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4085
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4086
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4088
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4089
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4091
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4092
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4094
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4095
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4097
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4098
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4100
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4101
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4103
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4104
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4106
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4107
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4108
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4109
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4110
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4112
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4113
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4115
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4116
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4118
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4119
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4121
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4122
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4124
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4125
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4127
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4128
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4130
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4133
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4134
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4136
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4137
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4139
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4142
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4143
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4145
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4146
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4148
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4149
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4151
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4152
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4154
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4155
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4157
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4158
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4160
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4161
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4163
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4164
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4166
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4169
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4170
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4172
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4173
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4175
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4176
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4179
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4181
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4182
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4184
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4185
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4187
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L4191
	.byte 0x03,0xe8,0x79,0x01,0x00,0x05,0x02
	.uaword .L4194
	.byte 0x03,0x9a,0x06,0x01,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword gl_GetPointerv
	.byte 0x00,0x05,0x02
	.uaword .L4204
	.byte 0x06,0x03,0xfb,0x19,0x01,0x00,0x05,0x02
	.uaword .L4208
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4209
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4212
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4214
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4217
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4218
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4220
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4221
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4223
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4224
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4226
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4227
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4229
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L4231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L4234
	.byte 0x03,0x68,0x01,0x00,0x05,0x02
	.uaword .L4237
	.byte 0x03,0x1a,0x01,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x00,0x05,0x24,0x00,0x03,0x08,0x3e,0x0b
	.byte 0x0b,0x0b,0x00,0x00,0x06,0x16,0x00,0x49
	.byte 0x13,0x03,0x08,0x3a,0x0b,0x00,0x00,0x07
	.byte 0x13,0x00,0x03,0x08,0x3c,0x0c,0x00,0x00
	.byte 0x08,0x0f,0x00,0x49,0x13,0x00,0x00,0x09
	.byte 0x01,0x01,0x49,0x13,0x0b,0x0b,0x01,0x13
	.byte 0x00,0x00,0x0a,0x21,0x00,0x49,0x13,0x2f
	.byte 0x0b,0x00,0x00,0x0b,0x04,0x01,0x0b,0x0b
	.byte 0x3a,0x0b,0x01,0x13,0x00,0x00,0x0c,0x28
	.byte 0x00,0x03,0x08,0x1c,0x0d,0x00,0x00,0x0d
	.byte 0x13,0x01,0x03,0x08,0x0b,0x0b,0x3a,0x0b
	.byte 0x01,0x13,0x00,0x00,0x0e,0x0d,0x00,0x03
	.byte 0x08,0x49,0x13,0x38,0x0a,0x00,0x00,0x0f
	.byte 0x01,0x01,0x49,0x13,0x0b,0x05,0x01,0x13
	.byte 0x00,0x00,0x10,0x21,0x00,0x49,0x13,0x2f
	.byte 0x05,0x00,0x00,0x11,0x13,0x01,0x03,0x08
	.byte 0x0b,0x05,0x3a,0x0b,0x01,0x13,0x00,0x00
	.byte 0x12,0x26,0x00,0x49,0x13,0x00,0x00,0x13
	.byte 0x15,0x01,0x27,0x0c,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x14,0x05,0x00,0x49,0x13
	.byte 0x00,0x00,0x15,0x15,0x01,0x27,0x0c,0x49
	.byte 0x13,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x16,0x15,0x00,0x27,0x0c,0x49,0x13,0x88
	.byte 0x44,0x0b,0x00,0x00,0x17,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b
	.byte 0x05,0x11,0x01,0x12,0x01,0x40,0x0a,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x18,0x05,0x00,0x49,0x13,0x03,0x08,0x3a
	.byte 0x0b,0x3b,0x05,0x02,0x0a,0x00,0x00,0x19
	.byte 0x34,0x00,0x03,0x08,0x49,0x13,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x02,0x0a,0x00,0x00
	.byte 0x1a,0x2e,0x00,0x03,0x08,0x3f,0x0c,0x3c
	.byte 0x0c,0x27,0x0c,0x49,0x13,0x88,0x44,0x0b
	.byte 0x00,0x00,0x1b,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x3c,0x0c,0x27,0x0c,0x88,0x44,0x0b
	.byte 0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x6c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x96,0xd4,0x00,0x00,0x00,0xfd
	.byte 0x67,0x6c,0x5f,0x47,0x65,0x74,0x42,0x6f
	.byte 0x6f,0x6c,0x65,0x61,0x6e,0x76,0x00,0x00
	.byte 0x00,0x94,0xe1,0x67,0x6c,0x5f,0x47,0x65
	.byte 0x74,0x44,0x6f,0x75,0x62,0x6c,0x65,0x76
	.byte 0x00,0x00,0x00,0x95,0x5d,0x67,0x6c,0x5f
	.byte 0x47,0x65,0x74,0x46,0x6c,0x6f,0x61,0x74
	.byte 0x76,0x00,0x00,0x00,0x95,0xc4,0x67,0x6c
	.byte 0x5f,0x47,0x65,0x74,0x49,0x6e,0x74,0x65
	.byte 0x67,0x65,0x72,0x76,0x00,0x00,0x00,0x96
	.byte 0x32,0x67,0x6c,0x5f,0x47,0x65,0x74,0x50
	.byte 0x6f,0x69,0x6e,0x74,0x65,0x72,0x76,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x30,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x96,0xd4,0x00,0x00,0x01,0x68
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x01,0x91,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x01,0xa7,0x47,0x4c,0x66
	.byte 0x6c,0x6f,0x61,0x74,0x00,0x00,0x00,0x01
	.byte 0xce,0x00,0x00,0x00,0x31,0x6a,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x31
	.byte 0x88,0x47,0x4c,0x75,0x62,0x79,0x74,0x65
	.byte 0x00,0x00,0x00,0x31,0xa8,0x67,0x6c,0x5f
	.byte 0x74,0x65,0x78,0x74,0x75,0x72,0x65,0x5f
	.byte 0x69,0x6d,0x61,0x67,0x65,0x00,0x00,0x00
	.byte 0x32,0xda,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x34,0xef
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x32,0xea,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x35,0x0c,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x3d,0x30
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x3d,0x42,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x55,0x65
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x64
	.byte 0x09,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x65,0xb1,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x65,0xc5,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x65,0xd8
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x65,0xf6,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x66,0x09,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x66,0xe0,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x6d,0x3e
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0x71
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0xa7,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0xe6
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6e,0x1c,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x70,0x03,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x75,0x3b,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x75
	.byte 0x51,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x75,0xb1,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x75,0xfe
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x78,0x13,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x78,0xfd
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x79,0x50,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7b,0xc6,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x7c,0x3f,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7d,0x12,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x7f,0xb9,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x80
	.byte 0x5a,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x81
	.byte 0x4a,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0x6b,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x82,0x7a,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0xf3,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x83,0xd9
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x86,0xa9,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x87,0x22
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x88,0x66,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x88,0x74,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x88,0xcf
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8a,0x29,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0x8b,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8d,0x05,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x8d,0xc2,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x90,0x6d,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x91,0x21
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x91,0x75,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x91,0xef,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x93,0x79,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x93,0xee,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x35,0xad,0x67
	.byte 0x6c,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
	.byte 0x74,0x00,0x00,0x00,0x94,0xcc,0x47,0x4c
	.byte 0x63,0x6f,0x6e,0x74,0x65,0x78,0x74,0x00
	.byte 0x00,0x00,0x95,0x49,0x47,0x4c,0x64,0x6f
	.byte 0x75,0x62,0x6c,0x65,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
