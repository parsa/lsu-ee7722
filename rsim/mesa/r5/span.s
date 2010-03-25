
	.section	".text",#alloc,#execinstr,#progbits
	.file	"span.c"

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
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4
! FILE span.c

!    1		      !/* $Id: span.c,v 1.12 1997/08/14 01:12:37 brianp Exp $ */
!    3		      !/*
!    4		      ! * Mesa 3-D graphics library
!    5		      ! * Version:  2.4
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
!   25		      ! * $Log: span.c,v $
!   26		      ! * Revision 1.12  1997/08/14 01:12:37  brianp
!   27		      ! * replaced a few for loops with MEMSET calls
!   28		      ! *
!   29		      ! * Revision 1.11  1997/07/24 01:21:56  brianp
!   30		      ! * changed precompiled header symbol from PCH to PC_HEADER
!   31		      ! *
!   32		      ! * Revision 1.10  1997/05/28 03:26:29  brianp
!   33		      ! * added precompiled header (PCH) support
!   34		      ! *
!   35		      ! * Revision 1.9  1997/05/03 00:51:30  brianp
!   36		      ! * new texturing function call: gl_texture_pixels()
!   37		      ! *
!   38		      ! * Revision 1.8  1997/04/16 23:54:11  brianp
!   39		      ! * do per-pixel fog if texturing is enabled
!   40		      ! *
!   41		      ! * Revision 1.7  1997/02/09 19:53:43  brianp
!   42		      ! * now use TEXTURE_xD enable constants
!   43		      ! *
!   44		      ! * Revision 1.6  1997/02/09 18:43:34  brianp
!   45		      ! * added GL_EXT_texture3D support
!   46		      ! *
!   47		      ! * Revision 1.5  1997/01/28 22:17:44  brianp
!   48		      ! * new RGBA mode logic op support
!   49		      ! *
!   50		      ! * Revision 1.4  1996/09/25 03:22:05  brianp
!   51		      ! * added NO_DRAW_BIT support
!   52		      ! *
!   53		      ! * Revision 1.3  1996/09/15 14:18:55  brianp
!   54		      ! * now use GLframebuffer and GLvisual
!   55		      ! *
!   56		      ! * Revision 1.2  1996/09/15 01:48:58  brianp
!   57		      ! * removed #define NULL 0
!   58		      ! *
!   59		      ! * Revision 1.1  1996/09/13 01:38:16  brianp
!   60		      ! * Initial revision
!   61		      ! *
!   62		      ! */
!   65		      !/*
!   66		      ! * pixel span rasterization:
!   67		      ! * These functions simulate the rasterization pipeline.
!   68		      ! */
!   71		      !#ifdef PC_HEADER
!   72		      !#include "all.h"
!   73		      !#else
!   74		      !#include <string.h>
!   75		      !#include "alpha.h"
!   76		      !#include "alphabuf.h"
!   77		      !#include "blend.h"
!   78		      !#include "depth.h"
!   79		      !#include "fog.h"
!   80		      !#include "logic.h"
!   81		      !#include "macros.h"
!   82		      !#include "masking.h"
!   83		      !#include "scissor.h"
!   84		      !#include "span.h"
!   85		      !#include "stencil.h"
!   86		      !#include "texture.h"
!   87		      !#include "types.h"
!   88		      !#endif
!   93		      !/*
!   94		      ! * Apply the current polygon stipple pattern to a span of pixels.
!   95		      ! */
!   96		      !static void stipple_polygon_span( GLcontext *ctx,
!   97		      !                                  GLuint n, GLint x, GLint y, GLubyte mask[] )
!   98		      !{

!
! SUBROUTINE stipple_polygon_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       

			stipple_polygon_span:
/* 000000	  98 */		orcc	%g0,%o1,%g0

!   99		      !   register GLuint i, m, stipple, highbit=0x80000000;
!  101		      !   stipple = ctx->PolygonStipple[y % 32];
!  102		      !   m = highbit >> (GLuint) (x % 32);
!  104		      !   for (i=0;i<n;i++) {

/* 0x0004	 104 */		bleu,pn	%icc,.L77001808
/* 0x0008	 101 */		cmp	%o1,2

! Registers live out of stipple_polygon_span: 
! o0 o1 o2 o3 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: stipple_polygon_span

			.L77001811:
/* 0x000c	 101 */		sra	%o3,31,%g5
/* 0x0010	     */		and	%g5,31,%g4
/* 0x0014	     */		add	%o3,%g4,%g3
/* 0x0018	     */		andn	%g3,31,%g1
/* 0x001c	 102 */		sra	%o2,31,%g5
/* 0x0020	 101 */		sub	%o3,%g1,%o5
/* 0x0024	 102 */		and	%g5,31,%g4
/* 0x0028	 101 */		sll	%o5,2,%g2
/* 0x002c	 102 */		add	%o2,%g4,%o3
/* 0x0030	 101 */		add	%o0,%g2,%g3
/* 0x0034	     */		sethi	%hi(0xd400),%o5
/* 0x0038	 102 */		andn	%o3,31,%g1
/* 0x003c	 101 */		add	%o5,712,%o0
/* 0x0040	 102 */		sub	%o2,%g1,%o2
/* 0x0044	   0 */		sethi	%hi(0x80000000),%g4
/* 0x0048	 102 */		srl	%g4,%o2,%g5
/* 0x004c	 101 */		ld	[%g3+%o0],%g3
/* 0x0050	     */		bl,a,pn	%icc,.L77001814
/* 0x0054	 104 */		or	%g0,0,%g2

! Registers live out of .L77001811: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001811

			.L77001822:
/* 0x0058	 104 */		sethi	%hi(0x7ffffc00),%o5
/* 0x005c	     */		add	%o5,1022,%o5
/* 0x0060	     */		srl	%o1,0,%o3
/* 0x0064	     */		sub	%o3,%o5,%o2
/* 0x0068	     */		srlx	%o2,63,%o0
/* 0x006c	     */		andcc	%o0,1,%g0
/* 0x0070	     */		be,a,pn	%icc,.L77001814
/* 0x0074	     */		or	%g0,0,%g2

! Registers live out of .L77001822: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001822

			.L77001829:
/* 0x0078	 104 */		add	%o1,-1,%o1
/* 0x007c	     */		or	%g0,0,%g2

!  105		      !      if ((m & stipple)==0) {

/* 0x0080	 105 */		andcc	%g5,%g3,%g0

! Registers live out of .L77001829: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001799 .L77001829

			.L900000112:
/* 0x0084	 105 */		bne,pn	%icc,.L77001799
/* 0x0088	 108 */		srl	%g5,1,%g5

! Registers live out of .L900000112: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		
!  106		      !	 mask[i] = 0;

                       
! predecessor blocks: .L900000112

			.L77001797:
/* 0x008c	 106 */		stb	%g0,[%g2+%o4]

! Registers live out of .L77001797: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		
!  107		      !      }
!  108		      !      m = m >> 1;
!  109		      !      if (m==0) {

                       
! predecessor blocks: .L77001797 .L900000112

			.L77001799:
/* 0x0090	 109 */		cmp	%g5,0
/* 0x0094	   0 */		move	%icc,%g4,%g5
/* 0x0098	 104 */		add	%g2,1,%g2
/* 0x009c	     */		cmp	%g2,%o1
/* 0x00a0	     */		ble,pt	%icc,.L900000112
/* 0x00a4	 105 */		andcc	%g5,%g3,%g0

! Registers live out of .L77001799: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001799

			.L900000109:
/* 0x00a8	 104 */		retl	! Result = 
/* 0x00ac	     */		nop
                       
! predecessor blocks: .L77001811 .L77001822

			.L77001814:
/* 0x00b0	 105 */		andcc	%g5,%g3,%g0

! Registers live out of .L77001814: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001814 .L77001818

			.L900000111:
/* 0x00b4	 105 */		bne,pn	%icc,.L77001818
/* 0x00b8	 108 */		srl	%g5,1,%g5

! Registers live out of .L900000111: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000111

			.L77001815:
/* 0x00bc	 106 */		stb	%g0,[%g2+%o4]

! Registers live out of .L77001815: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001815 .L900000111

			.L77001818:
/* 0x00c0	 109 */		cmp	%g5,0
/* 0x00c4	   0 */		move	%icc,%g4,%g5
/* 0x00c8	 104 */		add	%g2,1,%g2
/* 0x00cc	     */		cmp	%g2,%o1
/* 0x00d0	     */		bcs,pt	%icc,.L900000111
/* 0x00d4	 105 */		andcc	%g5,%g3,%g0

! Registers live out of .L77001818: 
! g2 g3 g4 g5 o1 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001818 stipple_polygon_span

			.L77001808:
/* 0x00d8	 104 */		retl	! Result = 
/* 0x00dc	     */		nop
/* 0x00e0	   0 */		.type	stipple_polygon_span,2
/* 0x00e0	   0 */		.size	stipple_polygon_span,(.-stipple_polygon_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  110		      !	 m = 0x80000000;
!  111		      !      }
!  112		      !   }
!  113		      !}
!  117		      !/*
!  118		      ! * Clip a pixel span to the current buffer/window boundaries.
!  119		      ! * Return:  0 = all pixels clipped
!  120		      ! *          1 = at least one pixel is visible
!  121		      ! */
!  122		      !static GLuint clip_span( GLcontext *ctx,
!  123		      !                         GLint n, GLint x, GLint y, GLubyte mask[] )
!  124		      !{

!
! SUBROUTINE clip_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       

			clip_span:
/* 000000	 124 */		orcc	%g0,%o3,%o3

!  125		      !   GLint i;
!  127		      !   /* Clip to top and bottom */
!  128		      !   if (y<0 || y>=ctx->Buffer->Height) {

/* 0x0004	 128 */		bl,a,pn	%icc,.L77001901
/* 0x0008	 129 */		or	%g0,0,%o0

! Registers live out of clip_span: 
! g4 o0 o1 o2 o3 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: clip_span

			.L77001864:
/* 0x000c	 128 */		ld	[%o0+2204],%g1
/* 0x0010	     */		ld	[%g1+8],%o5
/* 0x0014	     */		cmp	%o3,%o5
/* 0x0018	     */		bge,pn	%icc,.L77001868
/* 0x001c	 124 */		orcc	%g0,%o2,%o5

! Registers live out of .L77001864: 
! g1 g4 o0 o1 o2 o4 o5 sp o7 fp gsr 
! 
		
!  129		      !      return 0;
!  130		      !   }
!  132		      !   /* Clip to left and right */
!  133		      !   if (x>=0 && x+n<=ctx->Buffer->Width) {

                       
! predecessor blocks: .L77001864

			.L77001870:
/* 0x0020	 133 */		bl,pn	%icc,.L77001876
/* 0x0024	     */		add	%o2,%o1,%g2

! Registers live out of .L77001870: 
! g1 g2 g4 o0 o1 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001870

			.L77001872:
/* 0x0028	 133 */		ld	[%g1+4],%g3
/* 0x002c	     */		cmp	%g2,%g3
/* 0x0030	     */		bg,pn	%icc,.L900000207
/* 0x0034	 137 */		cmp	%g2,0

! Registers live out of .L77001872: 
! g1 g4 o0 o1 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001872

			.L77001874:
/* 0x0038	 152 */		retl	! Result =  %o0

!  134		      !      /* no clipping needed */
!  135		      !      return 1;

/* 0x003c	 135 */		or	%g0,1,%o0

!  136		      !   }
!  137		      !   else if (x+n<=0) {

                       
! predecessor blocks: .L77001870

			.L77001876:
/* 0x0040	 137 */		cmp	%g2,0

! Registers live out of .L77001876: 
! g1 g4 o0 o1 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001872 .L77001876

			.L900000207:
/* 0x0044	 137 */		bg,a,pn	%icc,.L900000206
/* 0x0048	 141 */		ld	[%g1+4],%g4

! Registers live out of .L900000207: 
! g4 o0 o1 o2 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000207

			.L77001878:
/* 0x004c	 152 */		retl	! Result =  %o0

!  138		      !      /* completely off left side */
!  139		      !      return 0;

/* 0x0050	 139 */		or	%g0,0,%o0

!  140		      !   }
!  141		      !   else if (x>=ctx->Buffer->Width) {

                       
! predecessor blocks: .L900000207

			.L900000206:
/* 0x0054	 141 */		cmp	%o2,%g4
/* 0x0058	     */		bl,pn	%icc,.L900000205
/* 0x005c	 147 */		cmp	%o1,0

! Registers live out of .L900000206: 
! o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000206

			.L77001882:
/* 0x0060	 152 */		retl	! Result =  %o0

!  142		      !      /* completely off right side */
!  143		      !      return 0;

/* 0x0064	 143 */		or	%g0,0,%o0

!  144		      !   }
!  145		      !   else {
!  146		      !      /* clip-test each pixel, this could be done better */
!  147		      !      for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000206

			.L900000205:
/* 0x0068	 147 */		ble,a,pn	%icc,.L77001901
/* 0x006c	 152 */		or	%g0,1,%o0

! Registers live out of .L900000205: 
! o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000205

			.L77001910:
/* 0x0070	 147 */		or	%g0,0,%g5
/* 0x0074	     */		add	%o1,-1,%o1

!  148		      !         if (x+i<0 || x+i>=ctx->Buffer->Width) {

/* 0x0078	 148 */		cmp	%o5,0

! Registers live out of .L77001910: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001910 .L900000204

			.L900000203:
/* 0x007c	 148 */		bl,a,pn	%icc,.L77001896
/* 0x0080	 149 */		stb	%g0,[%o4]

! Registers live out of .L900000203: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000203

			.L77001890:
/* 0x0084	 148 */		ld	[%o0+2204],%o3
/* 0x0088	     */		ld	[%o3+4],%o2
/* 0x008c	     */		cmp	%o5,%o2
/* 0x0090	     */		bl,a,pt	%icc,.L900000204
/* 0x0094	 147 */		add	%g5,1,%g5

! Registers live out of .L77001890: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		
!  149		      !            mask[i] = 0;

                       
! predecessor blocks: .L77001890

			.L77001894:
/* 0x0098	 149 */		stb	%g0,[%o4]

! Registers live out of .L77001894: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001894 .L900000203

			.L77001896:
/* 0x009c	 147 */		add	%g5,1,%g5

! Registers live out of .L77001896: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77001890 .L77001896

			.L900000204:
/* 0x00a0	 147 */		cmp	%g5,%o1
/* 0x00a4	     */		add	%o5,1,%o5
/* 0x00a8	     */		add	%o4,1,%o4
/* 0x00ac	     */		ble,pt	%icc,.L900000203
/* 0x00b0	 148 */		cmp	%o5,0

! Registers live out of .L900000204: 
! g5 o0 o1 o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L900000204

			.L77001900:
/* 0x00b4	 152 */		retl	! Result =  %o0
/* 0x00b8	     */		or	%g0,1,%o0
                       
! predecessor blocks: .L77001864

			.L77001868:
/* 0x00bc	 129 */		or	%g0,0,%o0

! Registers live out of .L77001868: 
! o0 sp o7 fp gsr 
! 
		
!  150		      !         }
!  151		      !      }
!  152		      !      return 1;

                       
! predecessor blocks: .L77001868 clip_span .L900000205

			.L77001901:
/* 0x00c0	 152 */		retl	! Result =  %o0
/* 0x00c4	     */		nop
/* 0x00c8	   0 */		.type	clip_span,2
/* 0x00c8	   0 */		.size	clip_span,(.-clip_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  153		      !   }
!  154		      !}
!  158		      !/*
!  159		      ! * Write a horizontal span of color index pixels to the frame buffer.
!  160		      ! * Stenciling, Depth-testing, etc. are done as needed.
!  161		      ! * Input:  n - number of pixels in the span
!  162		      ! *         x, y - location of leftmost pixel in the span
!  163		      ! *         z - array of [n] z-values
!  164		      ! *         index - array of [n] color indexes
!  165		      ! *         primitive - either GL_POINT, GL_LINE, GL_POLYGON, or GL_BITMAP
!  166		      ! */
!  167		      !void gl_write_index_span( GLcontext *ctx,
!  168		      !                          GLuint n, GLint x, GLint y, GLdepth z[],
!  169		      !			  GLuint index[], GLenum primitive )
!  170		      !{

!
! SUBROUTINE gl_write_index_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_index_span
                       

			gl_write_index_span:
/* 000000	 170 */		sethi	%hi(0x1c00),%g1
/* 0x0004	     */		xor	%g1,-928,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  171		      !   GLubyte mask[MAX_WIDTH];
!  172		      !   GLuint index_save[MAX_WIDTH];
!  174		      !   /* init mask to 1's (all pixels are to be written) */
!  175		      !   MEMSET(mask, 1, n);

/* 0x000c	 175 */		or	%g0,%i1,%o2
/* 0x0010	     */		cmp	%o2,32
/* 0x0014	 170 */		ld	[%fp+92],%l0
/* 0x0018	 175 */		ble	.L900000337
/* 0x001c	     */		or	%g0,1,%o1

! Registers live out of gl_write_index_span: 
! g1 o0 o1 o2 o4 sp l0 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_index_span

			.L900000336:
/* 0x0020	 175 */		call	memset	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0024	     */		add	%fp,-1600,%o0
/* 0x0028	     */		ba	.L900000403
/* 0x002c	 177 */		sethi	%hi(0xe000),%o1

! Registers live out of .L900000336: 
! g1 o0 o1 o2 o4 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_index_span

			.L900000337:
/* 0x0030	 175 */		sethi	%hi(0x1010000),%o7
/* 0x0034	     */		add	%fp,-1600,%l7
/* 0x0038	     */		add	%o7,257,%o5
/* 0x003c	     */		cmp	%o2,3

! Registers live out of .L900000337: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000337 .L900000340

			.L900000404:
/* 0x0040	 175 */		bleu	.L900000342
/* 0x0044	     */		nop

! Registers live out of .L900000404: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000404

			.L900000340:
/* 0x0048	 175 */		sub	%o2,4,%o2
/* 0x004c	     */		st	%o5,[%l7]
/* 0x0050	     */		add	%l7,4,%l7
/* 0x0054	     */		ba	.L900000404
/* 0x0058	     */		cmp	%o2,3

! Registers live out of .L900000340: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000404

			.L900000342:
/* 0x005c	 175 */		andcc	%o2,3,%g0
/* 0x0060	     */		be	.L900000346
/* 0x0064	     */		cmp	%o2,0

! Registers live out of .L900000342: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000342

			.L900000381:
/* 0x0068	 175 */		bl,a	.L900000402
/* 0x006c	     */		subcc	%o2,1,%o2

! Registers live out of .L900000381: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000381

			.L900000384:
/* 0x0070	 175 */		cmp	%o2,2
/* 0x0074	     */		bl	.L900000380
/* 0x0078	     */		nop

! Registers live out of .L900000384: 
! g1 o0 o1 o2 o4 o5 sp l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000384

			.L900000385:
/* 0x007c	 175 */		or	%g0,%o2,%o7

! Registers live out of .L900000385: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000383 .L900000385

			.L900000383:
/* 0x0080	 175 */		stb	%o1,[%l7]
/* 0x0084	     */		sub	%o7,2,%o7
/* 0x0088	     */		add	%l7,2,%l7
/* 0x008c	     */		cmp	%o7,1
/* 0x0090	     */		bg	.L900000383
/* 0x0094	     */		stb	%o1,[%l7-1]

! Registers live out of .L900000383: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000383

			.L900000386:
/* 0x0098	 175 */		cmp	%o7,0
/* 0x009c	     */		ble	.L900000382
/* 0x00a0	     */		nop

! Registers live out of .L900000386: 
! g1 o0 o1 o2 o4 o5 sp l0 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000384 .L900000386

			.L900000380:
/* 0x00a4	 175 */		stb	%o1,[%l7]

! Registers live out of .L900000380: 
! g1 o0 o2 o4 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000380 .L900000386

			.L900000382:
/* 0x00a8	 175 */		ba	.L900000403
/* 0x00ac	 177 */		sethi	%hi(0xe000),%o1

! Registers live out of .L900000382: 
! g1 o0 o1 o2 o4 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000344 .L900000381

			.L900000402:
/* 0x00b0	 175 */		be	.L900000346
/* 0x00b4	     */		stb	%o1,[%l7]

! Registers live out of .L900000402: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000402

			.L900000344:
/* 0x00b8	 175 */		add	%l7,1,%l7
/* 0x00bc	     */		subcc	%o2,1,%o2
/* 0x00c0	     */		stb	%o1,[%l7]
/* 0x00c4	     */		add	%l7,1,%l7
/* 0x00c8	     */		bne	.L900000402
/* 0x00cc	     */		subcc	%o2,1,%o2

! Registers live out of .L900000344: 
! g1 o0 o1 o2 o4 o5 sp o7 l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  177		      !   if ((ctx->RasterMask & WINCLIP_BIT) || primitive==GL_BITMAP) {

                       
! predecessor blocks: .L900000342 .L900000344 .L900000402

			.L900000346:
/* 0x00d0	 177 */		sethi	%hi(0xe000),%o1

! Registers live out of .L900000346: 
! g1 o0 o1 o2 o4 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000336 .L900000346 .L900000382

			.L900000403:
/* 0x00d4	 177 */		add	%o1,264,%l3
/* 0x00d8	     */		ld	[%i0+%l3],%l7
/* 0x00dc	     */		andcc	%l7,512,%g0
/* 0x00e0	     */		bne,pn	%icc,.L77001937
/* 0x00e4	     */		sethi	%hi(0x1800),%l2

! Registers live out of .L900000403: 
! g1 o0 o2 o4 o5 sp l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000403

			.L77001933:
/* 0x00e8	 177 */		add	%l2,512,%g5
/* 0x00ec	     */		cmp	%l0,%g5
/* 0x00f0	     */		bne,pn	%icc,.L900000401
/* 0x00f4	   0 */		sethi	%hi(0x1c00),%l2

! Registers live out of .L77001933: 
! g1 o0 o2 o4 o5 sp l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001933 .L900000403

			.L77001937:
/* 0x00f8	 128 */		cmp	%i3,0
/* 0x00fc	     */		bl,pn	%icc,.L77002014
/* 0x0100	     */		nop

! Registers live out of .L77001937: 
! g1 o0 o2 o4 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001937

			.L77002018:
/* 0x0104	 128 */		ld	[%i0+2204],%o7
/* 0x0108	     */		ld	[%o7+8],%o1
/* 0x010c	     */		cmp	%i3,%o1
/* 0x0110	     */		bge,pn	%icc,.L77002014
/* 0x0114	 133 */		cmp	%i2,0

! Registers live out of .L77002018: 
! g1 o0 o2 o4 o5 sp o7 l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002018

			.L77002024:
/* 0x0118	 133 */		bl,pn	%icc,.L77002030
/* 0x011c	     */		add	%i2,%i1,%l7

! Registers live out of .L77002024: 
! g1 o0 o2 o4 o5 sp o7 l0 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002024

			.L77002026:
/* 0x0120	 133 */		ld	[%o7+4],%g2
/* 0x0124	     */		cmp	%l7,%g2
/* 0x0128	     */		ble,pn	%icc,.L900000401
/* 0x012c	   0 */		sethi	%hi(0x1c00),%l2

! Registers live out of .L77002026: 
! g1 o0 o2 o4 o5 sp o7 l0 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002024 .L77002026

			.L77002030:
/* 0x0130	 137 */		cmp	%l7,0
/* 0x0134	     */		ble,pn	%icc,.L77002014
/* 0x0138	     */		nop

! Registers live out of .L77002030: 
! g1 o0 o2 o4 o5 sp o7 l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002030

			.L77002034:
/* 0x013c	 141 */		ld	[%o7+4],%g3
/* 0x0140	     */		cmp	%i2,%g3
/* 0x0144	     */		bge,pn	%icc,.L77002014
/* 0x0148	 147 */		cmp	%i1,0

! Registers live out of .L77002034: 
! g1 o0 o2 o4 o5 sp o7 l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002034

			.L77002101:
/* 0x014c	 147 */		ble,pn	%icc,.L77001943
/* 0x0150	     */		or	%g0,0,%l5

! Registers live out of .L77002101: 
! g1 o0 o2 o4 o5 sp o7 l0 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  178		      !      if (clip_span(ctx,n,x,y,mask)==0) {

                       
! predecessor blocks: .L77002101

			.L77002110:
/* 0x0154	 178 */		or	%g0,%i2,%g4
/* 0x0158	 147 */		add	%i1,-1,%l4
/* 0x015c	 178 */		add	%fp,-1600,%l2
/* 0x0160	 148 */		cmp	%g4,0

! Registers live out of .L77002110: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002110 .L900000400

			.L900000399:
/* 0x0164	 148 */		bl,a,pn	%icc,.L77002050
/* 0x0168	 149 */		stb	%g0,[%l2]

! Registers live out of .L900000399: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000399

			.L77002044:
/* 0x016c	 148 */		ld	[%i0+2204],%l1
/* 0x0170	     */		ld	[%l1+4],%g5
/* 0x0174	     */		cmp	%g4,%g5
/* 0x0178	     */		bl,a,pt	%icc,.L900000400
/* 0x017c	 147 */		add	%l5,1,%l5

! Registers live out of .L77002044: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002044

			.L77002048:
/* 0x0180	 149 */		stb	%g0,[%l2]

! Registers live out of .L77002048: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002048 .L900000399

			.L77002050:
/* 0x0184	 147 */		add	%l5,1,%l5

! Registers live out of .L77002050: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002044 .L77002050

			.L900000400:
/* 0x0188	 147 */		cmp	%l5,%l4
/* 0x018c	     */		add	%g4,1,%g4
/* 0x0190	     */		add	%l2,1,%l2
/* 0x0194	     */		ble,pt	%icc,.L900000399
/* 0x0198	 148 */		cmp	%g4,0

! Registers live out of .L900000400: 
! g1 g4 o0 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002101 .L900000400

			.L77001943:
/* 0x019c	   0 */		sethi	%hi(0x1c00),%l2

! Registers live out of .L77001943: 
! g1 o0 o4 o5 sp l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  179		      !	 return;
!  180		      !      }
!  181		      !   }
!  183		      !   /* Per-pixel fog */
!  184		      !   if (ctx->Fog.Enabled
!  185		      !       && (ctx->Hint.Fog==GL_NICEST || primitive==GL_BITMAP)) {

                       
! predecessor blocks: .L77001933 .L77001943 .L77002026

			.L900000401:
/* 0x01a0	 185 */		add	%l2,888,%o3
/* 0x01a4	     */		ldub	[%i0+%o3],%l1
/* 0x01a8	     */		cmp	%l1,0
/* 0x01ac	     */		be,pn	%icc,.L77001953
/* 0x01b0	     */		add	%l2,944,%o2

! Registers live out of .L900000401: 
! g1 o0 o2 o4 o5 sp l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000401

			.L77001945:
/* 0x01b4	 185 */		sethi	%hi(0x1000),%l6
/* 0x01b8	     */		ld	[%i0+%o2],%o4
/* 0x01bc	     */		add	%l6,258,%o0
/* 0x01c0	     */		cmp	%o4,%o0
/* 0x01c4	     */		be,pn	%icc,.L77001951
/* 0x01c8	     */		sethi	%hi(0x1800),%o7

! Registers live out of .L77001945: 
! g1 o0 o4 sp o7 l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001945

			.L77001947:
/* 0x01cc	 185 */		add	%o7,512,%o5
/* 0x01d0	     */		cmp	%l0,%o5
/* 0x01d4	     */		bne,pn	%icc,.L900000398
/* 0x01d8	   0 */		sethi	%hi(0xd400),%l1

! Registers live out of .L77001947: 
! g1 o0 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  186		      !      gl_fog_index_pixels( ctx, n, z, index );

                       
! predecessor blocks: .L77001945 .L77001947

			.L77001951:
/* 0x01dc	 186 */		or	%g0,%i5,%o3
/* 0x01e0	     */		or	%g0,%i4,%o2
/* 0x01e4	     */		or	%g0,%i1,%o1
/* 0x01e8	     */		call	gl_fog_index_pixels	! params =  %o0 %o1 %o2 %o3	! Result = 
/* 0x01ec	     */		or	%g0,%i0,%o0

! Registers live out of .L77001951: 
! g1 o0 o4 o5 sp l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001951 .L900000401

			.L77001953:
/* 0x01f0	   0 */		sethi	%hi(0xd400),%l1

! Registers live out of .L77001953: 
! g1 o0 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  187		      !   }
!  189		      !   /* Do the scissor test */
!  190		      !   if (ctx->Scissor.Enabled) {

                       
! predecessor blocks: .L77001947 .L77001953

			.L900000398:
/* 0x01f4	 190 */		add	%l1,840,%l7
/* 0x01f8	     */		ldub	[%i0+%l7],%o1
/* 0x01fc	     */		cmp	%o1,0
/* 0x0200	     */		be,pn	%icc,.L77001961
/* 0x0204	 191 */		or	%g0,%i3,%o3

! Registers live out of .L900000398: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  191		      !      if (gl_scissor_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900000398

			.L77001955:
/* 0x0208	 191 */		or	%g0,%i2,%o2
/* 0x020c	     */		or	%g0,%i1,%o1
/* 0x0210	     */		or	%g0,%i0,%o0
/* 0x0214	     */		call	gl_scissor_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0218	     */		add	%fp,-1600,%o4
/* 0x021c	     */		orcc	%g0,%o0,%g0
/* 0x0220	     */		be,pn	%icc,.L77002014
/* 0x0224	     */		nop

! Registers live out of .L77001955: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  192		      !	 return;
!  193		      !      }
!  194		      !   }
!  196		      !   /* Polygon Stippling */
!  197		      !   if (ctx->Polygon.StippleFlag && primitive==GL_POLYGON) {

                       
! predecessor blocks: .L77001955 .L900000398

			.L77001961:
/* 0x0228	 197 */		add	%l1,697,%g3
/* 0x022c	     */		ldub	[%i0+%g3],%g2
/* 0x0230	     */		cmp	%g2,0
/* 0x0234	     */		be,pn	%icc,.L77001967
/* 0x0238	     */		cmp	%l0,9

! Registers live out of .L77001961: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001961

			.L77001963:
/* 0x023c	 197 */		bne,pn	%icc,.L77001967
/* 0x0240	 104 */		cmp	%i1,0

! Registers live out of .L77001963: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001963

			.L77001965:
/* 0x0244	 104 */		bleu,pn	%icc,.L77001967
/* 0x0248	 101 */		cmp	%i1,2

! Registers live out of .L77001965: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001965

			.L77002080:
/* 0x024c	 101 */		sra	%i3,31,%l6
/* 0x0250	     */		and	%l6,31,%o2
/* 0x0254	     */		add	%i3,%o2,%o0
/* 0x0258	     */		andn	%o0,31,%g5
/* 0x025c	 102 */		sra	%i2,31,%l5
/* 0x0260	 101 */		sub	%i3,%g5,%g4
/* 0x0264	 102 */		and	%l5,31,%g3
/* 0x0268	 101 */		sll	%g4,2,%l4
/* 0x026c	 102 */		add	%i2,%g3,%g2
/* 0x0270	 101 */		add	%i0,%l4,%o5
/* 0x0274	     */		add	%l1,712,%o7
/* 0x0278	 102 */		andn	%g2,31,%l7
/* 0x027c	     */		sub	%i2,%l7,%o1
/* 0x0280	   0 */		sethi	%hi(0x80000000),%o2
/* 0x0284	 101 */		ld	[%o5+%o7],%o0
/* 0x0288	     */		bl,pn	%icc,.L77002155
/* 0x028c	 102 */		srl	%o2,%o1,%l6

! Registers live out of .L77002080: 
! g1 g3 o0 o2 o3 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002080

			.L77002092:
/* 0x0290	 104 */		sethi	%hi(0x7ffffc00),%o1
/* 0x0294	     */		add	%o1,1022,%o7
/* 0x0298	     */		srl	%i1,0,%o5
/* 0x029c	     */		sub	%o5,%o7,%o4
/* 0x02a0	     */		srlx	%o4,63,%l0
/* 0x02a4	     */		andcc	%l0,1,%g0
/* 0x02a8	     */		be,a,pn	%icc,.L77002109
/* 0x02ac	     */		or	%g0,0,%o3

! Registers live out of .L77002092: 
! g1 g3 o0 o2 o3 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002092

			.L77002100:
/* 0x02b0	 104 */		add	%i1,-1,%l0
/* 0x02b4	     */		or	%g0,0,%o3

!  198		      !      stipple_polygon_span( ctx, n, x, y, mask );

/* 0x02b8	 198 */		add	%fp,-1600,%o4
/* 0x02bc	 105 */		andcc	%l6,%o0,%g0

! Registers live out of .L77002100: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002067 .L77002100

			.L900000397:
/* 0x02c0	 105 */		bne,pn	%icc,.L77002067
/* 0x02c4	 108 */		srl	%l6,1,%l6

! Registers live out of .L900000397: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000397

			.L77002065:
/* 0x02c8	 106 */		stb	%g0,[%o3+%o4]

! Registers live out of .L77002065: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002065 .L900000397

			.L77002067:
/* 0x02cc	 109 */		cmp	%l6,0
/* 0x02d0	   0 */		move	%icc,%o2,%l6
/* 0x02d4	 104 */		add	%o3,1,%o3
/* 0x02d8	     */		cmp	%o3,%l0
/* 0x02dc	     */		ble,pt	%icc,.L900000397
/* 0x02e0	 105 */		andcc	%l6,%o0,%g0

! Registers live out of .L77002067: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002067

			.L900000361:
/* 0x02e4	 104 */		ba	.L900000396
/* 0x02e8	 201 */		add	%l1,860,%l4

! Registers live out of .L900000361: 
! o0 o4 o5 sp l2 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002080

			.L77002155:
/* 0x02ec	 104 */		or	%g0,0,%o3

! Registers live out of .L77002155: 
! g1 g3 o0 o2 o3 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002092 .L77002155

			.L77002109:
/* 0x02f0	 198 */		add	%fp,-1600,%o4
/* 0x02f4	 105 */		andcc	%l6,%o0,%g0

! Registers live out of .L77002109: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002088 .L77002109

			.L900000395:
/* 0x02f8	 105 */		bne,pn	%icc,.L77002088
/* 0x02fc	 108 */		srl	%l6,1,%l6

! Registers live out of .L900000395: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000395

			.L77002085:
/* 0x0300	 106 */		stb	%g0,[%o3+%o4]

! Registers live out of .L77002085: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002085 .L900000395

			.L77002088:
/* 0x0304	 109 */		cmp	%l6,0
/* 0x0308	   0 */		move	%icc,%o2,%l6
/* 0x030c	 104 */		add	%o3,1,%o3
/* 0x0310	     */		cmp	%o3,%i1
/* 0x0314	     */		bcs,pt	%icc,.L900000395
/* 0x0318	 105 */		andcc	%l6,%o0,%g0

! Registers live out of .L77002088: 
! g1 g3 o0 o2 o3 o4 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  199		      !   }
!  201		      !   if (ctx->Stencil.Enabled) {

                       
! predecessor blocks: .L77001961 .L77001963 .L77001965 .L77002088

			.L77001967:
/* 0x031c	 201 */		add	%l1,860,%l4

! Registers live out of .L77001967: 
! o0 o4 o5 sp l2 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001967 .L900000361

			.L900000396:
/* 0x0320	 201 */		ldub	[%i0+%l4],%l5
/* 0x0324	     */		cmp	%l5,0
/* 0x0328	     */		be,pn	%icc,.L77001975
/* 0x032c	 203 */		or	%g0,%i3,%o3

! Registers live out of .L900000396: 
! o0 o3 o4 o5 sp l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  202		      !      /* first stencil test */
!  203		      !      if (gl_stencil_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900000396

			.L77001969:
/* 0x0330	 203 */		or	%g0,%i2,%o2
/* 0x0334	     */		or	%g0,%i1,%o1
/* 0x0338	     */		or	%g0,%i0,%o0
/* 0x033c	     */		call	gl_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0340	     */		add	%fp,-1600,%o4
/* 0x0344	     */		orcc	%g0,%o0,%g0
/* 0x0348	     */		be,pn	%icc,.L77002014
/* 0x034c	 207 */		or	%g0,%i4,%o4

! Registers live out of .L77001969: 
! o4 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  204		      !	 return;
!  205		      !      }
!  206		      !      /* depth buffering w/ stencil */
!  207		      !      gl_depth_stencil_span( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77001969

			.L77001973:
/* 0x0350	 207 */		or	%g0,%i3,%o3
/* 0x0354	     */		or	%g0,%i2,%o2
/* 0x0358	     */		or	%g0,%i1,%o1
/* 0x035c	     */		or	%g0,%i0,%o0
/* 0x0360	     */		call	gl_depth_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0364	     */		add	%fp,-1600,%o5
/* 0x0368	     */		ba	.L900000394
/* 0x036c	 214 */		ld	[%i0+%l3],%l0

! Registers live out of .L77001973: 
! o0 o5 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  208		      !   }
!  209		      !   else if (ctx->Depth.Test) {

                       
! predecessor blocks: .L900000396

			.L77001975:
/* 0x0370	 209 */		add	%l2,828,%g5
/* 0x0374	     */		ldub	[%i0+%g5],%g4
/* 0x0378	     */		cmp	%g4,0
/* 0x037c	     */		be,pn	%icc,.L77001985
/* 0x0380	 211 */		or	%g0,%i4,%o4

! Registers live out of .L77001975: 
! o0 o4 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  210		      !      /* regular depth testing */
!  211		      !      if ((*ctx->Driver.DepthTestSpan)( ctx, n, x, y, z, mask )==0)  return;

                       
! predecessor blocks: .L77001975

			.L77001977:
/* 0x0384	 211 */		or	%g0,%i3,%o3
/* 0x0388	     */		or	%g0,%i2,%o2
/* 0x038c	     */		or	%g0,%i1,%o1
/* 0x0390	     */		or	%g0,%i0,%o0
/* 0x0394	     */		ld	[%i0+2332],%l1
/* 0x0398	     */		jmpl	%l1,%o7
/* 0x039c	     */		add	%fp,-1600,%o5
/* 0x03a0	     */		orcc	%g0,%o0,%g0
/* 0x03a4	     */		be,pn	%icc,.L77002014
/* 0x03a8	     */		nop

! Registers live out of .L77001977: 
! o0 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  212		      !   }
!  214		      !   if (ctx->RasterMask & NO_DRAW_BIT) {

                       
! predecessor blocks: .L77001975 .L77001977

			.L77001985:
/* 0x03ac	 214 */		ld	[%i0+%l3],%l0

! Registers live out of .L77001985: 
! o0 o5 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001973 .L77001985

			.L900000394:
/* 0x03b0	 214 */		andcc	%l0,2048,%g0
/* 0x03b4	     */		bne,pn	%icc,.L77002014
/* 0x03b8	 219 */		andcc	%l0,1024,%g0

! Registers live out of .L900000394: 
! o0 o5 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  215		      !      /* write no pixels */
!  216		      !      return;
!  217		      !   }
!  219		      !   if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

                       
! predecessor blocks: .L900000394

			.L77001989:
/* 0x03bc	 219 */		be,pn	%icc,.L77001993
/* 0x03c0	 223 */		sll	%i1,2,%o3

! Registers live out of .L77001989: 
! o0 o3 o5 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  220		      !      /* Save a copy of the indexes since LogicOp and IndexMask
!  221		      !       * may change them
!  222		      !       */
!  223		      !      MEMCPY( index_save, index, n * sizeof(GLuint) );

                       
! predecessor blocks: .L77001989

			.L77001991:
/* 0x03c4	 223 */		cmp	%o3,32
/* 0x03c8	     */		or	%g0,%i5,%o1
/* 0x03cc	     */		or	%g0,%o3,%o2
/* 0x03d0	     */		bg	.L900000332
/* 0x03d4	     */		sethi	%hi(0x1c00),%g1

! Registers live out of .L77001991: 
! g1 o0 o1 o2 o3 o5 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001991

			.L900000320:
/* 0x03d8	 223 */		and	%o1,3,%l1
/* 0x03dc	     */		xor	%g1,-832,%g1
/* 0x03e0	     */		orcc	%l1,0,%g0
/* 0x03e4	     */		add	%g1,%fp,%g1
/* 0x03e8	     */		be	.L900000325
/* 0x03ec	     */		or	%g0,%g1,%l1

! Registers live out of .L900000320: 
! o1 o2 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000320

			.L900000321:
/* 0x03f0	 223 */		subcc	%o3,2,%o2
/* 0x03f4	     */		bl	.L900000323
/* 0x03f8	     */		srl	%o3,31,%g3

! Registers live out of .L900000321: 
! g3 o1 o2 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000321

			.L900000377:
/* 0x03fc	 223 */		add	%o3,%g3,%g2
/* 0x0400	     */		sra	%g2,1,%l7
/* 0x0404	     */		cmp	%l7,1
/* 0x0408	     */		bl	.L900000322
/* 0x040c	     */		nop

! Registers live out of .L900000377: 
! o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000377

			.L900000378:
/* 0x0410	 223 */		sethi	%hi(0x1c00),%g1
/* 0x0414	     */		xor	%g1,-832,%g1
/* 0x0418	     */		or	%g0,%o2,%o7
/* 0x041c	     */		add	%g1,%fp,%i4
/* 0x0420	     */		or	%g0,%o1,%o5

! Registers live out of .L900000378: 
! o5 sp o7 l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000376 .L900000378

			.L900000376:
/* 0x0424	 223 */		sub	%o7,2,%o7
/* 0x0428	     */		add	%i4,2,%i4
/* 0x042c	     */		ldub	[%o5],%o0
/* 0x0430	     */		cmp	%o7,0
/* 0x0434	     */		add	%o5,2,%o5
/* 0x0438	     */		stb	%o0,[%i4-2]
/* 0x043c	     */		ldub	[%o5-1],%g5
/* 0x0440	     */		bge	.L900000376
/* 0x0444	     */		stb	%g5,[%i4-1]

! Registers live out of .L900000376: 
! o5 sp o7 l0 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000376

			.L900000379:
/* 0x0448	 223 */		or	%g0,%o7,%o2
/* 0x044c	     */		or	%g0,%i4,%l1
/* 0x0450	     */		or	%g0,%o5,%o1
/* 0x0454	     */		ba	.L900000323
/* 0x0458	     */		nop

! Registers live out of .L900000379: 
! o1 o2 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000377

			.L900000322:
/* 0x045c	 223 */		subcc	%o2,2,%o2

! Registers live out of .L900000322: 
! o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000322 .L900000393

			.L900000393:
/* 0x0460	 223 */		ldub	[%o1],%o0
/* 0x0464	     */		stb	%o0,[%l1]
/* 0x0468	     */		ldub	[%o1+1],%g5
/* 0x046c	     */		add	%o1,2,%o1
/* 0x0470	     */		stb	%g5,[%l1+1]
/* 0x0474	     */		add	%l1,2,%l1
/* 0x0478	     */		bge,a	.L900000393
/* 0x047c	     */		subcc	%o2,2,%o2

! Registers live out of .L900000393: 
! o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000321 .L900000379 .L900000393

			.L900000323:
/* 0x0480	 223 */		cmp	%o2,-1
/* 0x0484	     */		bl,a	.L900000391
/* 0x0488	 226 */		add	%l2,722,%l1

! Registers live out of .L900000323: 
! o1 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000323

			.L900000324:
/* 0x048c	 223 */		ldub	[%o1],%o2
/* 0x0490	     */		stb	%o2,[%l1]
/* 0x0494	     */		ba	.L900000391
/* 0x0498	 226 */		add	%l2,722,%l1

! Registers live out of .L900000324: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000320

			.L900000325:
/* 0x049c	 223 */		subcc	%o3,4,%o0
/* 0x04a0	     */		bl	.L900000328
/* 0x04a4	     */		sra	%o3,1,%l0

! Registers live out of .L900000325: 
! o0 o1 o2 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000325

			.L900000365:
/* 0x04a8	 223 */		srl	%l0,30,%l4
/* 0x04ac	     */		add	%o3,%l4,%g3
/* 0x04b0	     */		sra	%g3,2,%g2
/* 0x04b4	     */		cmp	%g2,1
/* 0x04b8	     */		bl	.L900000326
/* 0x04bc	     */		nop

! Registers live out of .L900000365: 
! o0 o1 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000364 .L900000365

			.L900000364:
/* 0x04c0	 223 */		sub	%o0,4,%o0
/* 0x04c4	     */		add	%l1,4,%l1
/* 0x04c8	     */		ld	[%o1],%f0
/* 0x04cc	     */		cmp	%o0,0
/* 0x04d0	     */		add	%o1,4,%o1
/* 0x04d4	     */		bge	.L900000364
/* 0x04d8	     */		st	%f0,[%l1-4]

! Registers live out of .L900000364: 
! o0 o1 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000364

			.L900000367:
/* 0x04dc	 223 */		ba	.L900000327
/* 0x04e0	     */		nop

! Registers live out of .L900000367: 
! o0 o1 o3 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000365

			.L900000326:
/* 0x04e4	 223 */		subcc	%o0,4,%o0

! Registers live out of .L900000326: 
! o0 o1 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000326 .L900000392

			.L900000392:
/* 0x04e8	 223 */		ld	[%o1],%f0
/* 0x04ec	     */		add	%o1,4,%o1
/* 0x04f0	     */		st	%f0,[%l1]
/* 0x04f4	     */		add	%l1,4,%l1
/* 0x04f8	     */		bge,a	.L900000392
/* 0x04fc	     */		subcc	%o0,4,%o0

! Registers live out of .L900000392: 
! o0 o1 o3 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000367 .L900000392

			.L900000327:
/* 0x0500	 223 */		add	%o0,4,%o2

! Registers live out of .L900000327: 
! o1 o2 o3 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000325 .L900000327

			.L900000328:
/* 0x0504	 223 */		andcc	%o3,3,%g0
/* 0x0508	     */		be	.L77001993
/* 0x050c	     */		subcc	%o2,1,%o2

! Registers live out of .L900000328: 
! o1 o2 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000328

			.L900000329:
/* 0x0510	 223 */		ldub	[%o1],%o3
/* 0x0514	     */		ble	.L77001993
/* 0x0518	     */		stb	%o3,[%l1]

! Registers live out of .L900000329: 
! o1 o2 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000329

			.L900000330:
/* 0x051c	 223 */		ldub	[%o1+1],%l6
/* 0x0520	     */		subcc	%o2,1,%o2
/* 0x0524	     */		ble	.L77001993
/* 0x0528	     */		stb	%l6,[%l1+1]

! Registers live out of .L900000330: 
! o1 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000330

			.L900000331:
/* 0x052c	 223 */		ldub	[%o1+2],%o4
/* 0x0530	     */		stb	%o4,[%l1+2]
/* 0x0534	     */		ba	.L900000391
/* 0x0538	 226 */		add	%l2,722,%l1

! Registers live out of .L900000331: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001991

			.L900000332:
/* 0x053c	 223 */		xor	%g1,-832,%g1
/* 0x0540	     */		add	%g1,%fp,%g1
/* 0x0544	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0548	     */		or	%g0,%g1,%o0

! Registers live out of .L900000332: 
! o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  224		      !   }
!  226		      !   if (ctx->Color.SWLogicOpEnabled) {

                       
! predecessor blocks: .L77001989 .L900000328 .L900000329 .L900000330 .L900000332

			.L77001993:
/* 0x054c	 226 */		add	%l2,722,%l1

! Registers live out of .L77001993: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001993 .L900000323 .L900000324 .L900000331

			.L900000391:
/* 0x0550	 226 */		ldub	[%i0+%l1],%o4
/* 0x0554	     */		cmp	%o4,0
/* 0x0558	     */		be,pn	%icc,.L77001997
/* 0x055c	 229 */		add	%l2,664,%l2

! Registers live out of .L900000391: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  227		      !      gl_logicop_ci_span( ctx, n, x, y, index, mask );

                       
! predecessor blocks: .L900000391

			.L77001995:
/* 0x0560	 227 */		or	%g0,%i5,%o4
/* 0x0564	     */		or	%g0,%i3,%o3
/* 0x0568	     */		or	%g0,%i2,%o2
/* 0x056c	     */		or	%g0,%i1,%o1
/* 0x0570	     */		or	%g0,%i0,%o0
/* 0x0574	     */		call	gl_logicop_ci_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0578	     */		add	%fp,-1600,%o5

! Registers live out of .L77001995: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  228		      !   }
!  229		      !   if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77001995 .L900000391

			.L77001997:
/* 0x057c	 229 */		ldub	[%i0+%l2],%o0
/* 0x0580	     */		cmp	%o0,0
/* 0x0584	     */		be,pn	%icc,.L77002001
/* 0x0588	 230 */		or	%g0,%i5,%o4

! Registers live out of .L77001997: 
! o0 o4 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  230		      !      gl_mask_index_span( ctx, n, x, y, index );

                       
! predecessor blocks: .L77001997

			.L77001999:
/* 0x058c	 230 */		or	%g0,%i3,%o3
/* 0x0590	     */		or	%g0,%i2,%o2
/* 0x0594	     */		or	%g0,%i1,%o1
/* 0x0598	     */		call	gl_mask_index_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result = 
/* 0x059c	     */		or	%g0,%i0,%o0

! Registers live out of .L77001999: 
! o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  231		      !   }
!  233		      !   /* write pixels */
!  234		      !   (*ctx->Driver.WriteIndexSpan)( ctx, n, x, y, index, mask );

                       
! predecessor blocks: .L77001997 .L77001999

			.L77002001:
/* 0x05a0	 234 */		or	%g0,%i5,%o4
/* 0x05a4	     */		or	%g0,%i3,%o3
/* 0x05a8	     */		or	%g0,%i2,%o2
/* 0x05ac	     */		or	%g0,%i1,%o1
/* 0x05b0	     */		or	%g0,%i0,%o0
/* 0x05b4	     */		ld	[%i0+2260],%l6
/* 0x05b8	     */		jmpl	%l6,%o7
/* 0x05bc	     */		add	%fp,-1600,%o5

!  237		      !   if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

/* 0x05c0	 237 */		ld	[%i0+%l3],%o2
/* 0x05c4	     */		andcc	%o2,1024,%g0
/* 0x05c8	     */		be,pn	%icc,.L77002014

!  238		      !      /*** Also draw to back buffer ***/
!  239		      !      (*ctx->Driver.SetBuffer)( ctx, GL_BACK );

/* 0x05cc	 239 */		or	%g0,1029,%o1

! Registers live out of .L77002001: 
! o0 o1 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002001

			.L77002003:
/* 0x05d0	 239 */		ld	[%i0+2236],%i4
/* 0x05d4	     */		jmpl	%i4,%o7
/* 0x05d8	     */		or	%g0,%i0,%o0

!  240		      !      MEMCPY( index, index_save, n * sizeof(GLuint) );

/* 0x05dc	 240 */		sethi	%hi(0x1c00),%g1
/* 0x05e0	     */		sll	%i1,2,%o5
/* 0x05e4	     */		xor	%g1,-832,%g1
/* 0x05e8	     */		cmp	%o5,32
/* 0x05ec	     */		add	%g1,%fp,%o1
/* 0x05f0	     */		bg	.L900000316
/* 0x05f4	     */		or	%g0,%o5,%o2

! Registers live out of .L77002003: 
! o0 o1 o2 o4 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002003

			.L900000304:
/* 0x05f8	 240 */		and	%i5,3,%l7
/* 0x05fc	     */		orcc	%l7,0,%g0
/* 0x0600	     */		be	.L900000309
/* 0x0604	     */		or	%g0,%i5,%l0

! Registers live out of .L900000304: 
! o0 o1 o2 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000304

			.L900000305:
/* 0x0608	 240 */		subcc	%o5,2,%o2
/* 0x060c	     */		bl	.L900000307
/* 0x0610	     */		or	%g0,%o5,%o7

! Registers live out of .L900000305: 
! o0 o1 o2 o5 sp o7 l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000305

			.L900000373:
/* 0x0614	 240 */		srl	%o5,31,%o5
/* 0x0618	     */		add	%o7,%o5,%o4
/* 0x061c	     */		sra	%o4,1,%l6
/* 0x0620	     */		cmp	%l6,1
/* 0x0624	     */		bl	.L900000306
/* 0x0628	     */		nop

! Registers live out of .L900000373: 
! o0 o1 o2 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000373

			.L900000374:
/* 0x062c	 240 */		sethi	%hi(0x1c00),%g1
/* 0x0630	     */		xor	%g1,-832,%g1
/* 0x0634	     */		or	%g0,%o2,%o4
/* 0x0638	     */		or	%g0,%i5,%l6
/* 0x063c	     */		add	%g1,%fp,%o3

! Registers live out of .L900000374: 
! o0 o3 o4 o5 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000372 .L900000374

			.L900000372:
/* 0x0640	 240 */		sub	%o4,2,%o4
/* 0x0644	     */		add	%l6,2,%l6
/* 0x0648	     */		ldub	[%o3],%g2
/* 0x064c	     */		cmp	%o4,0
/* 0x0650	     */		add	%o3,2,%o3
/* 0x0654	     */		stb	%g2,[%l6-2]
/* 0x0658	     */		ldub	[%o3-1],%i4
/* 0x065c	     */		bge	.L900000372
/* 0x0660	     */		stb	%i4,[%l6-1]

! Registers live out of .L900000372: 
! o0 o3 o4 o5 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000372

			.L900000375:
/* 0x0664	 240 */		or	%g0,%o4,%o2
/* 0x0668	     */		or	%g0,%l6,%l0
/* 0x066c	     */		or	%g0,%o3,%o1
/* 0x0670	     */		ba	.L900000307
/* 0x0674	     */		nop

! Registers live out of .L900000375: 
! o0 o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000373

			.L900000306:
/* 0x0678	 240 */		subcc	%o2,2,%o2

! Registers live out of .L900000306: 
! o0 o1 o2 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000306 .L900000390

			.L900000390:
/* 0x067c	 240 */		ldub	[%o1],%g2
/* 0x0680	     */		stb	%g2,[%l0]
/* 0x0684	     */		ldub	[%o1+1],%i4
/* 0x0688	     */		add	%o1,2,%o1
/* 0x068c	     */		stb	%i4,[%l0+1]
/* 0x0690	     */		add	%l0,2,%l0
/* 0x0694	     */		bge,a	.L900000390
/* 0x0698	     */		subcc	%o2,2,%o2

! Registers live out of .L900000390: 
! o0 o1 o2 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000305 .L900000375 .L900000390

			.L900000307:
/* 0x069c	 240 */		cmp	%o2,-1
/* 0x06a0	     */		bl,a	.L900000388
/* 0x06a4	 241 */		ldub	[%i0+%l1],%l3

! Registers live out of .L900000307: 
! o0 o1 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000307

			.L900000308:
/* 0x06a8	 240 */		ldub	[%o1],%g3
/* 0x06ac	     */		stb	%g3,[%l0]
/* 0x06b0	     */		ba	.L900000388
/* 0x06b4	 241 */		ldub	[%i0+%l1],%l3

! Registers live out of .L900000308: 
! o0 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000304

			.L900000309:
/* 0x06b8	 240 */		subcc	%o5,4,%l5
/* 0x06bc	     */		bl	.L900000312
/* 0x06c0	     */		sra	%o5,1,%o3

! Registers live out of .L900000309: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000309

			.L900000369:
/* 0x06c4	 240 */		srl	%o3,30,%o2
/* 0x06c8	     */		add	%o5,%o2,%g5
/* 0x06cc	     */		sra	%g5,2,%g4
/* 0x06d0	     */		cmp	%g4,1
/* 0x06d4	     */		bl	.L900000310
/* 0x06d8	     */		nop

! Registers live out of .L900000369: 
! o0 o1 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000369

			.L900000370:
/* 0x06dc	 240 */		sethi	%hi(0x1c00),%g1
/* 0x06e0	     */		xor	%g1,-832,%g1
/* 0x06e4	     */		add	%g1,%fp,%o2

! Registers live out of .L900000370: 
! o0 o2 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000368 .L900000370

			.L900000368:
/* 0x06e8	 240 */		sub	%l5,4,%l5
/* 0x06ec	     */		add	%l0,4,%l0
/* 0x06f0	     */		ld	[%o2],%f0
/* 0x06f4	     */		cmp	%l5,0
/* 0x06f8	     */		add	%o2,4,%o2
/* 0x06fc	     */		bge	.L900000368
/* 0x0700	     */		st	%f0,[%l0-4]

! Registers live out of .L900000368: 
! o0 o2 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000368

			.L900000371:
/* 0x0704	 240 */		or	%g0,%o2,%o1
/* 0x0708	     */		ba	.L900000311
/* 0x070c	     */		nop

! Registers live out of .L900000371: 
! o0 o1 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000369

			.L900000310:
/* 0x0710	 240 */		subcc	%l5,4,%l5

! Registers live out of .L900000310: 
! o0 o1 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000310 .L900000389

			.L900000389:
/* 0x0714	 240 */		ld	[%o1],%f0
/* 0x0718	     */		add	%o1,4,%o1
/* 0x071c	     */		st	%f0,[%l0]
/* 0x0720	     */		add	%l0,4,%l0
/* 0x0724	     */		bge,a	.L900000389
/* 0x0728	     */		subcc	%l5,4,%l5

! Registers live out of .L900000389: 
! o0 o1 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000371 .L900000389

			.L900000311:
/* 0x072c	 240 */		add	%l5,4,%o2

! Registers live out of .L900000311: 
! o0 o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000309 .L900000311

			.L900000312:
/* 0x0730	 240 */		andcc	%o5,3,%g0
/* 0x0734	     */		be	.L900000318
/* 0x0738	     */		subcc	%o2,1,%o2

! Registers live out of .L900000312: 
! o0 o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000312

			.L900000313:
/* 0x073c	 240 */		ldub	[%o1],%l5
/* 0x0740	     */		ble	.L900000318
/* 0x0744	     */		stb	%l5,[%l0]

! Registers live out of .L900000313: 
! o0 o1 o2 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000313

			.L900000314:
/* 0x0748	 240 */		ldub	[%o1+1],%l4
/* 0x074c	     */		subcc	%o2,1,%o2
/* 0x0750	     */		ble	.L900000318
/* 0x0754	     */		stb	%l4,[%l0+1]

! Registers live out of .L900000314: 
! o0 o1 o5 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000314

			.L900000315:
/* 0x0758	 240 */		ldub	[%o1+2],%g4
/* 0x075c	     */		stb	%g4,[%l0+2]
/* 0x0760	     */		ba	.L900000388
/* 0x0764	 241 */		ldub	[%i0+%l1],%l3

! Registers live out of .L900000315: 
! o0 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002003

			.L900000316:
/* 0x0768	 240 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x076c	     */		or	%g0,%i5,%o0

! Registers live out of .L900000316: 
! o0 o5 sp l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  241		      !      if (ctx->Color.SWLogicOpEnabled) {

                       
! predecessor blocks: .L900000312 .L900000313 .L900000314 .L900000316

			.L900000318:
/* 0x0770	 241 */		ldub	[%i0+%l1],%l3

! Registers live out of .L900000318: 
! o0 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000307 .L900000308 .L900000315 .L900000318

			.L900000388:
/* 0x0774	 241 */		cmp	%l3,0
/* 0x0778	     */		be,pn	%icc,.L77002007
/* 0x077c	 242 */		or	%g0,%i5,%o4

! Registers live out of .L900000388: 
! o0 o4 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  242		      !         gl_logicop_ci_span( ctx, n, x, y, index, mask );

                       
! predecessor blocks: .L900000388

			.L77002005:
/* 0x0780	 242 */		or	%g0,%i3,%o3
/* 0x0784	     */		or	%g0,%i2,%o2
/* 0x0788	     */		or	%g0,%i1,%o1
/* 0x078c	     */		or	%g0,%i0,%o0
/* 0x0790	     */		call	gl_logicop_ci_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0794	     */		add	%fp,-1600,%o5

! Registers live out of .L77002005: 
! o0 o5 sp l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  243		      !      }
!  244		      !      if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77002005 .L900000388

			.L77002007:
/* 0x0798	 244 */		ldub	[%i0+%l2],%l3
/* 0x079c	     */		cmp	%l3,0
/* 0x07a0	     */		be,pn	%icc,.L77002011
/* 0x07a4	 245 */		or	%g0,%i5,%o4

! Registers live out of .L77002007: 
! o0 o4 o5 sp i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  245		      !         gl_mask_index_span( ctx, n, x, y, index );

                       
! predecessor blocks: .L77002007

			.L77002009:
/* 0x07a8	 245 */		or	%g0,%i3,%o3
/* 0x07ac	     */		or	%g0,%i2,%o2
/* 0x07b0	     */		or	%g0,%i1,%o1
/* 0x07b4	     */		call	gl_mask_index_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result = 
/* 0x07b8	     */		or	%g0,%i0,%o0

! Registers live out of .L77002009: 
! o5 sp i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  246		      !      }
!  247		      !      (*ctx->Driver.WriteIndexSpan)( ctx, n, x, y, index, mask );

                       
! predecessor blocks: .L77002007 .L77002009

			.L77002011:
/* 0x07bc	 247 */		or	%g0,%i1,%o1
/* 0x07c0	     */		or	%g0,%i5,%o4
/* 0x07c4	     */		or	%g0,%i3,%o3
/* 0x07c8	     */		or	%g0,%i2,%o2
/* 0x07cc	     */		or	%g0,%i0,%o0
/* 0x07d0	     */		ld	[%i0+2260],%i1
/* 0x07d4	     */		jmpl	%i1,%o7
/* 0x07d8	     */		add	%fp,-1600,%o5

!  248		      !      (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );

/* 0x07dc	 248 */		or	%g0,1028,%o1
/* 0x07e0	     */		ld	[%i0+2236],%i5
/* 0x07e4	     */		jmpl	%i5,%o7
/* 0x07e8	     */		or	%g0,%i0,%o0

! Registers live out of .L77002011: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77001937 .L77001955 .L77001969 .L77001977 .L77002001 .L77002011 .L77002018 .L77002030 .L77002034 .L900000394

			.L77002014:
/* 0x07ec	 179 */		ret	! Result = 
/* 0x07f0	     */		restore	%g0,0,%g0
/* 0x07f4	   0 */		.type	gl_write_index_span,2
/* 0x07f4	   0 */		.size	gl_write_index_span,(.-gl_write_index_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  249		      !   }
!  250		      !}
!  255		      !void gl_write_monoindex_span( GLcontext *ctx,
!  256		      !                              GLuint n, GLint x, GLint y, GLdepth z[],
!  257		      !			      GLuint index, GLenum primitive )
!  258		      !{

!
! SUBROUTINE gl_write_monoindex_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_monoindex_span
                       

			gl_write_monoindex_span:
/* 000000	 258 */		sethi	%hi(0x3800),%g1
/* 0x0004	     */		xor	%g1,-160,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  259		      !   GLuint i;
!  260		      !   GLubyte mask[MAX_WIDTH];
!  261		      !   GLuint index_save[MAX_WIDTH];
!  263		      !   /* init mask to 1's (all pixels are to be written) */
!  264		      !   MEMSET(mask, 1, n);

/* 0x000c	 264 */		or	%g0,%i1,%o2
/* 0x0010	     */		cmp	%o2,32
/* 0x0014	 258 */		or	%g0,%i5,%l1
/* 0x0018	     */		ld	[%fp+92],%l3
/* 0x001c	 264 */		ble	.L900000521
/* 0x0020	     */		or	%g0,1,%o1

! Registers live out of gl_write_monoindex_span: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_monoindex_span

			.L900000520:
/* 0x0024	 264 */		call	memset	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0028	     */		add	%fp,-1600,%o0
/* 0x002c	     */		ba	.L900000602
/* 0x0030	 266 */		sethi	%hi(0xe000),%l4

! Registers live out of .L900000520: 
! g4 o2 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_monoindex_span

			.L900000521:
/* 0x0034	 264 */		sethi	%hi(0x1010000),%g4
/* 0x0038	     */		add	%fp,-1600,%i5
/* 0x003c	     */		add	%g4,257,%g3
/* 0x0040	     */		cmp	%o2,3

! Registers live out of .L900000521: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000521 .L900000524

			.L900000603:
/* 0x0044	 264 */		bleu	.L900000526
/* 0x0048	     */		nop

! Registers live out of .L900000603: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000603

			.L900000524:
/* 0x004c	 264 */		sub	%o2,4,%o2
/* 0x0050	     */		st	%g3,[%i5]
/* 0x0054	     */		add	%i5,4,%i5
/* 0x0058	     */		ba	.L900000603
/* 0x005c	     */		cmp	%o2,3

! Registers live out of .L900000524: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000603

			.L900000526:
/* 0x0060	 264 */		andcc	%o2,3,%g0
/* 0x0064	     */		be	.L900000530
/* 0x0068	     */		cmp	%o2,0

! Registers live out of .L900000526: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000526

			.L900000578:
/* 0x006c	 264 */		bl,a	.L900000601
/* 0x0070	     */		subcc	%o2,1,%o2

! Registers live out of .L900000578: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000578

			.L900000581:
/* 0x0074	 264 */		cmp	%o2,2
/* 0x0078	     */		bl	.L900000577
/* 0x007c	     */		nop

! Registers live out of .L900000581: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000581

			.L900000582:
/* 0x0080	 264 */		or	%g0,%o2,%o7

! Registers live out of .L900000582: 
! g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000580 .L900000582

			.L900000580:
/* 0x0084	 264 */		stb	%o1,[%i5]
/* 0x0088	     */		sub	%o7,2,%o7
/* 0x008c	     */		add	%i5,2,%i5
/* 0x0090	     */		cmp	%o7,1
/* 0x0094	     */		bg	.L900000580
/* 0x0098	     */		stb	%o1,[%i5-1]

! Registers live out of .L900000580: 
! g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000580

			.L900000583:
/* 0x009c	 264 */		cmp	%o7,0
/* 0x00a0	     */		ble	.L900000579
/* 0x00a4	     */		nop

! Registers live out of .L900000583: 
! g4 o1 o2 o4 o5 sp l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000581 .L900000583

			.L900000577:
/* 0x00a8	 264 */		stb	%o1,[%i5]

! Registers live out of .L900000577: 
! g4 o2 o4 o5 sp l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000577 .L900000583

			.L900000579:
/* 0x00ac	 264 */		ba	.L900000602
/* 0x00b0	 266 */		sethi	%hi(0xe000),%l4

! Registers live out of .L900000579: 
! g4 o2 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000528 .L900000578

			.L900000601:
/* 0x00b4	 264 */		be	.L900000530
/* 0x00b8	     */		stb	%o1,[%i5]

! Registers live out of .L900000601: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000601

			.L900000528:
/* 0x00bc	 264 */		add	%i5,1,%i5
/* 0x00c0	     */		subcc	%o2,1,%o2
/* 0x00c4	     */		stb	%o1,[%i5]
/* 0x00c8	     */		add	%i5,1,%i5
/* 0x00cc	     */		bne	.L900000601
/* 0x00d0	     */		subcc	%o2,1,%o2

! Registers live out of .L900000528: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  266		      !   if ((ctx->RasterMask & WINCLIP_BIT) || primitive==GL_BITMAP) {

                       
! predecessor blocks: .L900000526 .L900000528 .L900000601

			.L900000530:
/* 0x00d4	 266 */		sethi	%hi(0xe000),%l4

! Registers live out of .L900000530: 
! g4 o2 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000520 .L900000530 .L900000579

			.L900000602:
/* 0x00d8	 266 */		add	%l4,264,%l5
/* 0x00dc	     */		ld	[%i0+%l5],%o1
/* 0x00e0	     */		andcc	%o1,512,%g0
/* 0x00e4	     */		bne,pn	%icc,.L77002209
/* 0x00e8	     */		sethi	%hi(0x1800),%o0

! Registers live out of .L900000602: 
! g4 o0 o1 o2 o4 o5 sp l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000602

			.L77002205:
/* 0x00ec	 266 */		add	%o0,512,%o2
/* 0x00f0	     */		cmp	%l3,%o2
/* 0x00f4	     */		bne,pn	%icc,.L900000600
/* 0x00f8	   0 */		sethi	%hi(0xd400),%l0

! Registers live out of .L77002205: 
! g4 o0 o1 o2 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002205 .L900000602

			.L77002209:
/* 0x00fc	 128 */		cmp	%i3,0
/* 0x0100	     */		bl,pn	%icc,.L77002324
/* 0x0104	     */		nop

! Registers live out of .L77002209: 
! g4 o0 o1 o2 o4 o5 sp l1 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002209

			.L77002330:
/* 0x0108	 128 */		ld	[%i0+2204],%o3
/* 0x010c	     */		ld	[%o3+8],%o7
/* 0x0110	     */		cmp	%i3,%o7
/* 0x0114	     */		bge,pn	%icc,.L77002324
/* 0x0118	 133 */		cmp	%i2,0

! Registers live out of .L77002330: 
! g4 o0 o1 o2 o3 o4 o5 sp l1 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002330

			.L77002336:
/* 0x011c	 133 */		bl,pn	%icc,.L77002342
/* 0x0120	     */		add	%i2,%i1,%i5

! Registers live out of .L77002336: 
! g4 o0 o1 o2 o3 o4 o5 sp l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002336

			.L77002338:
/* 0x0124	 133 */		ld	[%o3+4],%l7
/* 0x0128	     */		cmp	%i5,%l7
/* 0x012c	     */		ble,pn	%icc,.L900000600
/* 0x0130	   0 */		sethi	%hi(0xd400),%l0

! Registers live out of .L77002338: 
! g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002336 .L77002338

			.L77002342:
/* 0x0134	 137 */		cmp	%i5,0
/* 0x0138	     */		ble,pn	%icc,.L77002324
/* 0x013c	     */		nop

! Registers live out of .L77002342: 
! g4 o0 o1 o2 o3 sp l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002342

			.L77002346:
/* 0x0140	 141 */		ld	[%o3+4],%o4
/* 0x0144	     */		cmp	%i2,%o4
/* 0x0148	     */		bge,pn	%icc,.L77002324
/* 0x014c	 147 */		cmp	%i1,0

! Registers live out of .L77002346: 
! g4 o0 o1 o2 o3 o4 sp l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002346

			.L77002443:
/* 0x0150	 147 */		ble,pn	%icc,.L77002215
/* 0x0154	     */		or	%g0,0,%o5

! Registers live out of .L77002443: 
! g4 o0 o1 o2 o3 o4 o5 sp l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  267		      !      if (clip_span( ctx,n,x,y,mask)==0) {

                       
! predecessor blocks: .L77002443

			.L77002464:
/* 0x0158	 267 */		or	%g0,%i2,%g2
/* 0x015c	 147 */		add	%i1,-1,%l4
/* 0x0160	 267 */		add	%fp,-1600,%l0
/* 0x0164	 148 */		cmp	%g2,0

! Registers live out of .L77002464: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002464 .L900000599

			.L900000598:
/* 0x0168	 148 */		bl,a,pn	%icc,.L77002362
/* 0x016c	 149 */		stb	%g0,[%l0]

! Registers live out of .L900000598: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000598

			.L77002356:
/* 0x0170	 148 */		ld	[%i0+2204],%o1
/* 0x0174	     */		ld	[%o1+4],%g4
/* 0x0178	     */		cmp	%g2,%g4
/* 0x017c	     */		bl,a,pt	%icc,.L900000599
/* 0x0180	 147 */		add	%o5,1,%o5

! Registers live out of .L77002356: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002356

			.L77002360:
/* 0x0184	 149 */		stb	%g0,[%l0]

! Registers live out of .L77002360: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002360 .L900000598

			.L77002362:
/* 0x0188	 147 */		add	%o5,1,%o5

! Registers live out of .L77002362: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002356 .L77002362

			.L900000599:
/* 0x018c	 147 */		cmp	%o5,%l4
/* 0x0190	     */		add	%g2,1,%g2
/* 0x0194	     */		add	%l0,1,%l0
/* 0x0198	     */		ble,pt	%icc,.L900000598
/* 0x019c	 148 */		cmp	%g2,0

! Registers live out of .L900000599: 
! g2 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002443 .L900000599

			.L77002215:
/* 0x01a0	   0 */		sethi	%hi(0xd400),%l0

! Registers live out of .L77002215: 
! o0 o1 o2 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  268		      !	 return;
!  269		      !      }
!  270		      !   }
!  272		      !   /* Do the scissor test */
!  273		      !   if (ctx->Scissor.Enabled) {

                       
! predecessor blocks: .L77002205 .L77002215 .L77002338

			.L900000600:
/* 0x01a4	 273 */		add	%l0,840,%l2
/* 0x01a8	     */		ldub	[%i0+%l2],%g5
/* 0x01ac	     */		cmp	%g5,0
/* 0x01b0	     */		be,pn	%icc,.L77002223
/* 0x01b4	 274 */		or	%g0,%i3,%o3

! Registers live out of .L900000600: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  274		      !      if (gl_scissor_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900000600

			.L77002217:
/* 0x01b8	 274 */		or	%g0,%i2,%o2
/* 0x01bc	     */		or	%g0,%i1,%o1
/* 0x01c0	     */		or	%g0,%i0,%o0
/* 0x01c4	     */		call	gl_scissor_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x01c8	     */		add	%fp,-1600,%o4
/* 0x01cc	     */		orcc	%g0,%o0,%g0
/* 0x01d0	     */		be,pn	%icc,.L77002324
/* 0x01d4	     */		nop

! Registers live out of .L77002217: 
! o0 o1 o2 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  275		      !	 return;
!  276		      !      }
!  277		      !   }
!  279		      !   /* Polygon Stippling */
!  280		      !   if (ctx->Polygon.StippleFlag && primitive==GL_POLYGON) {

                       
! predecessor blocks: .L77002217 .L900000600

			.L77002223:
/* 0x01d8	 280 */		add	%l0,697,%o7
/* 0x01dc	     */		ldub	[%i0+%o7],%o3
/* 0x01e0	     */		cmp	%o3,0
/* 0x01e4	     */		be,pn	%icc,.L77002229
/* 0x01e8	     */		cmp	%l3,9

! Registers live out of .L77002223: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002223

			.L77002225:
/* 0x01ec	 280 */		bne,pn	%icc,.L77002229
/* 0x01f0	 104 */		cmp	%i1,0

! Registers live out of .L77002225: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002225

			.L77002227:
/* 0x01f4	 104 */		bleu,pn	%icc,.L77002229
/* 0x01f8	 101 */		cmp	%i1,2

! Registers live out of .L77002227: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002227

			.L77002394:
/* 0x01fc	 101 */		sra	%i3,31,%l2
/* 0x0200	     */		and	%l2,31,%g5
/* 0x0204	     */		add	%i3,%g5,%o1
/* 0x0208	     */		andn	%o1,31,%l4
/* 0x020c	 102 */		sra	%i2,31,%g2
/* 0x0210	 101 */		sub	%i3,%l4,%g4
/* 0x0214	 102 */		and	%g2,31,%o5
/* 0x0218	 101 */		sll	%g4,2,%g3
/* 0x021c	 102 */		add	%i2,%o5,%o4
/* 0x0220	 101 */		add	%i0,%g3,%o3
/* 0x0224	     */		add	%l0,712,%o7
/* 0x0228	 102 */		andn	%o4,31,%l7
/* 0x022c	     */		sub	%i2,%l7,%i5
/* 0x0230	   0 */		sethi	%hi(0x80000000),%l6
/* 0x0234	 101 */		ld	[%o3+%o7],%l2
/* 0x0238	     */		bl,pn	%icc,.L77002507
/* 0x023c	 102 */		srl	%l6,%i5,%g3

! Registers live out of .L77002394: 
! g3 g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002394

			.L77002422:
/* 0x0240	 104 */		sethi	%hi(0x7ffffc00),%o0
/* 0x0244	     */		add	%o0,1022,%o2
/* 0x0248	     */		srl	%i1,0,%g5
/* 0x024c	     */		sub	%g5,%o2,%o1
/* 0x0250	     */		srlx	%o1,63,%l4
/* 0x0254	     */		andcc	%l4,1,%g0
/* 0x0258	     */		be,a,pn	%icc,.L77002459
/* 0x025c	     */		or	%g0,0,%g4

! Registers live out of .L77002422: 
! g3 g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002422

			.L77002438:
/* 0x0260	 104 */		add	%i1,-1,%o2
/* 0x0264	     */		or	%g0,0,%g5

!  281		      !      stipple_polygon_span( ctx, n, x, y, mask );

/* 0x0268	 281 */		add	%fp,-1600,%o0
/* 0x026c	 105 */		andcc	%g3,%l2,%g0

! Registers live out of .L77002438: 
! g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002379 .L77002438

			.L900000597:
/* 0x0270	 105 */		bne,pn	%icc,.L77002379
/* 0x0274	 108 */		srl	%g3,1,%g3

! Registers live out of .L900000597: 
! g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000597

			.L77002377:
/* 0x0278	 106 */		stb	%g0,[%g5+%o0]

! Registers live out of .L77002377: 
! g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002377 .L900000597

			.L77002379:
/* 0x027c	 109 */		cmp	%g3,0
/* 0x0280	   0 */		move	%icc,%l6,%g3
/* 0x0284	 104 */		add	%g5,1,%g5
/* 0x0288	     */		cmp	%g5,%o2
/* 0x028c	     */		ble,pt	%icc,.L900000597
/* 0x0290	 105 */		andcc	%g3,%l2,%g0

! Registers live out of .L77002379: 
! g3 g4 g5 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002379

			.L900000558:
/* 0x0294	 104 */		ba	.L900000596
/* 0x0298	 284 */		add	%l0,860,%l4

! Registers live out of .L900000558: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002394

			.L77002507:
/* 0x029c	 104 */		or	%g0,0,%g4

! Registers live out of .L77002507: 
! g3 g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002422 .L77002507

			.L77002459:
/* 0x02a0	 281 */		add	%fp,-1600,%o0
/* 0x02a4	 105 */		andcc	%g3,%l2,%g0

! Registers live out of .L77002459: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002418 .L77002459

			.L900000595:
/* 0x02a8	 105 */		bne,pn	%icc,.L77002418
/* 0x02ac	 108 */		srl	%g3,1,%g3

! Registers live out of .L900000595: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000595

			.L77002415:
/* 0x02b0	 106 */		stb	%g0,[%g4+%o0]

! Registers live out of .L77002415: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002415 .L900000595

			.L77002418:
/* 0x02b4	 109 */		cmp	%g3,0
/* 0x02b8	   0 */		move	%icc,%l6,%g3
/* 0x02bc	 104 */		add	%g4,1,%g4
/* 0x02c0	     */		cmp	%g4,%i1
/* 0x02c4	     */		bcs,pt	%icc,.L900000595
/* 0x02c8	 105 */		andcc	%g3,%l2,%g0

! Registers live out of .L77002418: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  282		      !   }
!  284		      !   if (ctx->Stencil.Enabled) {

                       
! predecessor blocks: .L77002223 .L77002225 .L77002227 .L77002418

			.L77002229:
/* 0x02cc	 284 */		add	%l0,860,%l4

! Registers live out of .L77002229: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002229 .L900000558

			.L900000596:
/* 0x02d0	 284 */		ldub	[%i0+%l4],%g3
/* 0x02d4	     */		cmp	%g3,0
/* 0x02d8	     */		be,pn	%icc,.L77002237
/* 0x02dc	   0 */		sethi	%hi(0x1c00),%l4

! Registers live out of .L900000596: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  285		      !      /* first stencil test */
!  286		      !      if (gl_stencil_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900000596

			.L77002231:
/* 0x02e0	 286 */		or	%g0,%i3,%o3
/* 0x02e4	     */		or	%g0,%i2,%o2
/* 0x02e8	     */		or	%g0,%i1,%o1
/* 0x02ec	     */		or	%g0,%i0,%o0
/* 0x02f0	     */		call	gl_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x02f4	     */		add	%fp,-1600,%o4
/* 0x02f8	     */		orcc	%g0,%o0,%g0
/* 0x02fc	     */		be,pn	%icc,.L77002324
/* 0x0300	 290 */		or	%g0,%i4,%o4

! Registers live out of .L77002231: 
! o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  287		      !	 return;
!  288		      !      }
!  289		      !      /* depth buffering w/ stencil */
!  290		      !      gl_depth_stencil_span( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77002231

			.L77002235:
/* 0x0304	 290 */		or	%g0,%i3,%o3
/* 0x0308	     */		or	%g0,%i2,%o2
/* 0x030c	     */		or	%g0,%i1,%o1
/* 0x0310	     */		or	%g0,%i0,%o0
/* 0x0314	     */		call	gl_depth_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0318	     */		add	%fp,-1600,%o5
/* 0x031c	     */		ba	.L900000594
/* 0x0320	 297 */		ld	[%i0+%l5],%o5

! Registers live out of .L77002235: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  291		      !   }
!  292		      !   else if (ctx->Depth.Test) {

                       
! predecessor blocks: .L900000596

			.L77002237:
/* 0x0324	 292 */		add	%l4,828,%o4
/* 0x0328	     */		ldub	[%i0+%o4],%i5
/* 0x032c	     */		cmp	%i5,0
/* 0x0330	     */		be,pn	%icc,.L77002247
/* 0x0334	 294 */		or	%g0,%i4,%o4

! Registers live out of .L77002237: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  293		      !      /* regular depth testing */
!  294		      !      if ((*ctx->Driver.DepthTestSpan)( ctx, n, x, y, z, mask )==0)  return;

                       
! predecessor blocks: .L77002237

			.L77002239:
/* 0x0338	 294 */		or	%g0,%i3,%o3
/* 0x033c	     */		or	%g0,%i2,%o2
/* 0x0340	     */		or	%g0,%i1,%o1
/* 0x0344	     */		or	%g0,%i0,%o0
/* 0x0348	     */		ld	[%i0+2332],%l7
/* 0x034c	     */		jmpl	%l7,%o7
/* 0x0350	     */		add	%fp,-1600,%o5
/* 0x0354	     */		orcc	%g0,%o0,%g0
/* 0x0358	     */		be,pn	%icc,.L77002324
/* 0x035c	     */		nop

! Registers live out of .L77002239: 
! o0 o1 o2 o3 o4 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  295		      !   }
!  297		      !   if (ctx->RasterMask & NO_DRAW_BIT) {

                       
! predecessor blocks: .L77002237 .L77002239

			.L77002247:
/* 0x0360	 297 */		ld	[%i0+%l5],%o5

! Registers live out of .L77002247: 
! o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002235 .L77002247

			.L900000594:
/* 0x0364	 297 */		andcc	%o5,2048,%g0
/* 0x0368	     */		bne,pn	%icc,.L77002324
/* 0x036c	 303 */		add	%l4,888,%g3

! Registers live out of .L900000594: 
! g3 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  298		      !      /* write no pixels */
!  299		      !      return;
!  300		      !   }
!  302		      !   if ((ctx->Fog.Enabled && (ctx->Hint.Fog==GL_NICEST || primitive==GL_BITMAP))
!  303		      !        || ctx->Color.SWLogicOpEnabled || ctx->Color.SWmasking) {

                       
! predecessor blocks: .L900000594

			.L77002251:
/* 0x0370	 303 */		ldub	[%i0+%g3],%l6
/* 0x0374	     */		cmp	%l6,0
/* 0x0378	     */		be,pn	%icc,.L77002259
/* 0x037c	     */		add	%l4,944,%g4

! Registers live out of .L77002251: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002251

			.L77002253:
/* 0x0380	 303 */		sethi	%hi(0x1000),%o1
/* 0x0384	     */		ld	[%i0+%g4],%g2
/* 0x0388	     */		add	%o1,258,%l0
/* 0x038c	     */		cmp	%g2,%l0
/* 0x0390	     */		be,pn	%icc,.L77002265
/* 0x0394	     */		sethi	%hi(0x1800),%o0

! Registers live out of .L77002253: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002253

			.L77002255:
/* 0x0398	 303 */		add	%o0,512,%o2
/* 0x039c	     */		cmp	%l3,%o2
/* 0x03a0	     */		be,pn	%icc,.L900000593
/* 0x03a4	 306 */		cmp	%i1,0

! Registers live out of .L77002255: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002251 .L77002255

			.L77002259:
/* 0x03a8	 303 */		add	%l4,722,%l2
/* 0x03ac	     */		ldub	[%i0+%l2],%g5
/* 0x03b0	     */		cmp	%g5,0
/* 0x03b4	     */		bne,pn	%icc,.L77002265
/* 0x03b8	     */		add	%l4,664,%o7

! Registers live out of .L77002259: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002259

			.L77002261:
/* 0x03bc	 303 */		ldub	[%i0+%o7],%o3
/* 0x03c0	     */		cmp	%o3,0
/* 0x03c4	     */		bne,pn	%icc,.L77002265
/* 0x03c8	 346 */		or	%g0,%i3,%o3

! Registers live out of .L77002261: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  304		      !      GLuint ispan[MAX_WIDTH];
!  305		      !      /* index may change, replicate single index into an array */
!  306		      !      for (i=0;i<n;i++) {
!  307		      !	 ispan[i] = index;
!  308		      !      }
!  310		      !      if (ctx->Fog.Enabled
!  311		      !          && (ctx->Hint.Fog==GL_NICEST || primitive==GL_BITMAP)) {
!  312		      !	 gl_fog_index_pixels( ctx, n, z, ispan );
!  313		      !      }
!  315		      !      if (ctx->RasterMask & FRONT_AND_BACK_BIT) {
!  316		      !         MEMCPY( index_save, index, n * sizeof(GLuint) );
!  317		      !      }
!  319		      !      if (ctx->Color.SWLogicOpEnabled) {
!  320		      !	 gl_logicop_ci_span( ctx, n, x, y, ispan, mask );
!  321		      !      }
!  323		      !      if (ctx->Color.SWmasking) {
!  324		      !         gl_mask_index_span( ctx, n, x, y, ispan );
!  325		      !      }
!  327		      !      (*ctx->Driver.WriteIndexSpan)( ctx, n, x, y, ispan, mask );
!  329		      !      if (ctx->RasterMask & FRONT_AND_BACK_BIT) {
!  330		      !         /*** Also draw to back buffer ***/
!  331		      !         (*ctx->Driver.SetBuffer)( ctx, GL_BACK );
!  332		      !         for (i=0;i<n;i++) {
!  333		      !            ispan[i] = index;
!  334		      !         }
!  335		      !         if (ctx->Color.SWLogicOpEnabled) {
!  336		      !            gl_logicop_ci_span( ctx, n, x, y, ispan, mask );
!  337		      !         }
!  338		      !         if (ctx->Color.SWmasking) {
!  339		      !            gl_mask_index_span( ctx, n, x, y, ispan );
!  340		      !         }
!  341		      !         (*ctx->Driver.WriteIndexSpan)( ctx, n, x, y, ispan, mask );
!  342		      !         (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );
!  343		      !      }
!  344		      !   }
!  345		      !   else {
!  346		      !      (*ctx->Driver.WriteMonoindexSpan)( ctx, n, x, y, mask );

                       
! predecessor blocks: .L77002261

			.L77002317:
/* 0x03cc	 346 */		or	%g0,%i2,%o2
/* 0x03d0	     */		or	%g0,%i1,%o1
/* 0x03d4	     */		or	%g0,%i0,%o0
/* 0x03d8	     */		ld	[%i0+2264],%l3
/* 0x03dc	     */		jmpl	%l3,%o7
/* 0x03e0	     */		add	%fp,-1600,%o4

!  348		      !      if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

/* 0x03e4	 348 */		ld	[%i0+%l5],%l5
/* 0x03e8	     */		andcc	%l5,1024,%g0
/* 0x03ec	     */		be,pn	%icc,.L77002324

!  349		      !         /*** Also draw to back buffer ***/
!  350		      !         (*ctx->Driver.SetBuffer)( ctx, GL_BACK );

/* 0x03f0	 350 */		or	%g0,1029,%o1

! Registers live out of .L77002317: 
! o0 o1 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002317

			.L77002319:
/* 0x03f4	 350 */		ld	[%i0+2236],%l1
/* 0x03f8	     */		jmpl	%l1,%o7
/* 0x03fc	     */		or	%g0,%i0,%o0

!  351		      !         (*ctx->Driver.WriteMonoindexSpan)( ctx, n, x, y, mask );

/* 0x0400	 351 */		or	%g0,%i1,%o1
/* 0x0404	     */		ld	[%i0+2264],%i1
/* 0x0408	     */		or	%g0,%i2,%o2
/* 0x040c	     */		or	%g0,%i0,%o0
/* 0x0410	     */		or	%g0,%i3,%o3
/* 0x0414	     */		jmpl	%i1,%o7
/* 0x0418	     */		add	%fp,-1600,%o4

!  352		      !         (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );

/* 0x041c	 352 */		ld	[%i0+2236],%i3
/* 0x0420	     */		or	%g0,1028,%o1
/* 0x0424	     */		jmpl	%i3,%o7
/* 0x0428	     */		or	%g0,%i0,%o0
/* 0x042c	 268 */		ret	! Result = 
/* 0x0430	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77002253 .L77002259 .L77002261

			.L77002265:
/* 0x0434	 306 */		cmp	%i1,0

! Registers live out of .L77002265: 
! g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002255 .L77002265

			.L900000593:
/* 0x0438	   0 */		sethi	%hi(0x1c00),%g1
/* 0x043c	   0 */		xor	%g1,-832,%g1
/* 0x0440	   0 */		add	%g1,%fp,%g1
/* 0x0444	 306 */		bleu,pn	%icc,.L77002273
/* 0x0448	   0 */		or	%g0,%g1,%l2

! Registers live out of .L900000593: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000593

			.L77002391:
/* 0x044c	 306 */		cmp	%i1,2
/* 0x0450	     */		bl,pn	%icc,.L77002551
/* 0x0454	     */		sethi	%hi(0x7ffffc00),%o7

! Registers live out of .L77002391: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002391

			.L77002402:
/* 0x0458	 306 */		add	%o7,1022,%o5
/* 0x045c	     */		srl	%i1,0,%o4
/* 0x0460	     */		sub	%o4,%o5,%o3
/* 0x0464	     */		srlx	%o3,63,%o0
/* 0x0468	     */		andcc	%o0,1,%g0
/* 0x046c	     */		be,a,pn	%icc,.L77002398
/* 0x0470	     */		or	%g0,0,%o2

! Registers live out of .L77002402: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002402

			.L77002439:
/* 0x0474	 306 */		cmp	%i1,0
/* 0x0478	     */		ble,pn	%icc,.L77002273
/* 0x047c	     */		add	%i1,-1,%l0

! Registers live out of .L77002439: 
! g3 g4 o0 o1 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002439

			.L77002460:
/* 0x0480	 306 */		sethi	%hi(0x1c00),%g1
/* 0x0484	     */		xor	%g1,-832,%g1
/* 0x0488	     */		add	%g1,%fp,%g1
/* 0x048c	     */		or	%g0,0,%l6
/* 0x0490	     */		or	%g0,%g1,%l7
/* 0x0494	 307 */		add	%i1,-2,%i5
/* 0x0498	     */		nop

! Registers live out of .L77002460: 
! g1 g3 g4 o0 o1 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002460 .L900000573

			.L900000573:
/* 0x049c	 307 */		st	%l1,[%l7]
/* 0x04a0	 306 */		add	%l6,2,%l6
/* 0x04a4	     */		add	%l7,8,%l7
/* 0x04a8	     */		cmp	%l6,%i5
/* 0x04ac	     */		ble,pt	%icc,.L900000573
/* 0x04b0	 307 */		st	%l1,[%l7-4]

! Registers live out of .L900000573: 
! g1 g3 g4 o0 o1 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000573

			.L900000576:
/* 0x04b4	 306 */		cmp	%l6,%l0
/* 0x04b8	     */		bg,pn	%icc,.L77002471
/* 0x04bc	 307 */		nop

! Registers live out of .L900000576: 
! g3 o0 o1 o3 o4 sp l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000576

			.L77002440:
/* 0x04c0	 307 */		st	%l1,[%l7]

! Registers live out of .L77002440: 
! g3 o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002440 .L900000576

			.L77002471:
/* 0x04c4	 306 */		ldub	[%i0+%g3],%l6
/* 0x04c8	     */		ba	.L900000592
/* 0x04cc	 311 */		cmp	%l6,0

! Registers live out of .L77002471: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002391

			.L77002551:
/* 0x04d0	 306 */		or	%g0,0,%o2

! Registers live out of .L77002551: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002402 .L77002551

			.L77002398:
/* 0x04d4	 307 */		sll	%o2,2,%l6

! Registers live out of .L77002398: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002398 .L900000591

			.L900000591:
/* 0x04d8	 306 */		add	%o2,1,%o2
/* 0x04dc	     */		cmp	%o2,%i1
/* 0x04e0	 307 */		st	%l1,[%l6+%l2]
/* 0x04e4	 306 */		bcs,pt	%icc,.L900000591
/* 0x04e8	 307 */		sll	%o2,2,%l6

! Registers live out of .L900000591: 
! g1 g3 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000591

			.L77002469:
/* 0x04ec	 306 */		ldub	[%i0+%g3],%l6

! Registers live out of .L77002469: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002439 .L77002469 .L900000593

			.L77002273:
/* 0x04f0	 311 */		cmp	%l6,0

! Registers live out of .L77002273: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002273 .L77002471

			.L900000592:
/* 0x04f4	 311 */		be,pn	%icc,.L77002283
/* 0x04f8	     */		add	%l4,944,%o5

! Registers live out of .L900000592: 
! o0 o1 o3 o4 o5 sp l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000592

			.L77002275:
/* 0x04fc	 311 */		sethi	%hi(0x1000),%o4
/* 0x0500	     */		ld	[%i0+%o5],%i5
/* 0x0504	     */		add	%o4,258,%l7
/* 0x0508	     */		cmp	%i5,%l7
/* 0x050c	     */		be,pn	%icc,.L77002281
/* 0x0510	     */		sethi	%hi(0x1800),%l0

! Registers live out of .L77002275: 
! o0 o1 o3 o4 sp l0 l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002275

			.L77002277:
/* 0x0514	 311 */		add	%l0,512,%g2
/* 0x0518	     */		cmp	%l3,%g2
/* 0x051c	     */		bne,a,pn	%icc,.L900000590
/* 0x0520	 315 */		ld	[%i0+%l5],%o1

! Registers live out of .L77002277: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002275 .L77002277

			.L77002281:
/* 0x0524	 312 */		sethi	%hi(0x1c00),%g1
/* 0x0528	     */		xor	%g1,-832,%g1
/* 0x052c	     */		add	%g1,%fp,%g1
/* 0x0530	     */		or	%g0,%i4,%o2
/* 0x0534	     */		or	%g0,%i1,%o1
/* 0x0538	     */		or	%g0,%i0,%o0
/* 0x053c	     */		call	gl_fog_index_pixels	! params =  %o0 %o1 %o2 %o3	! Result = 
/* 0x0540	     */		or	%g0,%g1,%o3

! Registers live out of .L77002281: 
! o0 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002281 .L900000592

			.L77002283:
/* 0x0544	 315 */		ld	[%i0+%l5],%o1

! Registers live out of .L77002283: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002277 .L77002283

			.L900000590:
/* 0x0548	 315 */		andcc	%o1,1024,%g0
/* 0x054c	     */		be,pn	%icc,.L77002287
/* 0x0550	 316 */		sll	%i1,2,%g4

! Registers live out of .L900000590: 
! g4 o0 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000590

			.L77002285:
/* 0x0554	 316 */		cmp	%g4,32
/* 0x0558	     */		or	%g0,%l1,%o1
/* 0x055c	     */		or	%g0,%g4,%o2
/* 0x0560	     */		bg	.L900000516
/* 0x0564	     */		sethi	%hi(0x3800),%g1

! Registers live out of .L77002285: 
! g1 g4 o0 o1 o2 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002285

			.L900000504:
/* 0x0568	 316 */		and	%o1,3,%o7
/* 0x056c	     */		xor	%g1,-64,%g1
/* 0x0570	     */		orcc	%o7,0,%g0
/* 0x0574	     */		add	%g1,%fp,%g1
/* 0x0578	     */		be	.L900000509
/* 0x057c	     */		or	%g0,%g1,%o7

! Registers live out of .L900000504: 
! g4 o1 o2 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000504

			.L900000505:
/* 0x0580	 316 */		subcc	%g4,2,%o2
/* 0x0584	     */		bl	.L900000507
/* 0x0588	     */		srl	%g4,31,%i4

! Registers live out of .L900000505: 
! g4 o1 o2 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000505

			.L900000570:
/* 0x058c	 316 */		add	%g4,%i4,%l3
/* 0x0590	     */		sra	%l3,1,%l6
/* 0x0594	     */		cmp	%l6,1
/* 0x0598	     */		bl	.L900000506
/* 0x059c	     */		nop

! Registers live out of .L900000570: 
! o1 o2 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000570

			.L900000571:
/* 0x05a0	 316 */		sethi	%hi(0x3800),%g1
/* 0x05a4	     */		xor	%g1,-64,%g1
/* 0x05a8	     */		or	%g0,%o2,%o3
/* 0x05ac	     */		add	%g1,%fp,%o0

! Registers live out of .L900000571: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000569 .L900000571

			.L900000569:
/* 0x05b0	 316 */		sub	%o3,2,%o3
/* 0x05b4	     */		add	%o0,2,%o0
/* 0x05b8	     */		ldub	[%o1],%l0
/* 0x05bc	     */		cmp	%o3,0
/* 0x05c0	     */		add	%o1,2,%o1
/* 0x05c4	     */		stb	%l0,[%o0-2]
/* 0x05c8	     */		ldub	[%o1-1],%i4
/* 0x05cc	     */		bge	.L900000569
/* 0x05d0	     */		stb	%i4,[%o0-1]

! Registers live out of .L900000569: 
! o0 o1 o3 o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000569

			.L900000572:
/* 0x05d4	 316 */		or	%g0,%o3,%o2
/* 0x05d8	     */		or	%g0,%o0,%o7
/* 0x05dc	     */		ba	.L900000507
/* 0x05e0	     */		nop

! Registers live out of .L900000572: 
! o1 o2 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000570

			.L900000506:
/* 0x05e4	 316 */		subcc	%o2,2,%o2

! Registers live out of .L900000506: 
! o1 o2 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000506 .L900000589

			.L900000589:
/* 0x05e8	 316 */		ldub	[%o1],%l0
/* 0x05ec	     */		stb	%l0,[%o7]
/* 0x05f0	     */		ldub	[%o1+1],%i4
/* 0x05f4	     */		add	%o1,2,%o1
/* 0x05f8	     */		stb	%i4,[%o7+1]
/* 0x05fc	     */		add	%o7,2,%o7
/* 0x0600	     */		bge,a	.L900000589
/* 0x0604	     */		subcc	%o2,2,%o2

! Registers live out of .L900000589: 
! o1 o2 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000505 .L900000572 .L900000589

			.L900000507:
/* 0x0608	 316 */		cmp	%o2,-1
/* 0x060c	     */		bl	.L900000587
/* 0x0610	 319 */		add	%l4,722,%l3

! Registers live out of .L900000507: 
! o1 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000507

			.L900000508:
/* 0x0614	 316 */		ldub	[%o1],%i5
/* 0x0618	     */		stb	%i5,[%o7]
/* 0x061c	     */		ba	.L900000587
/* 0x0620	 319 */		add	%l4,722,%l3

! Registers live out of .L900000508: 
! o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000504

			.L900000509:
/* 0x0624	 316 */		subcc	%g4,4,%g3
/* 0x0628	     */		bl	.L900000512
/* 0x062c	     */		sra	%g4,1,%l7

! Registers live out of .L900000509: 
! g3 g4 o1 o2 o4 sp o7 l1 l2 l4 l5 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000509

			.L900000562:
/* 0x0630	 316 */		srl	%l7,30,%o3
/* 0x0634	     */		add	%g4,%o3,%o2
/* 0x0638	     */		sra	%o2,2,%g5
/* 0x063c	     */		cmp	%g5,1
/* 0x0640	     */		bl	.L900000510
/* 0x0644	     */		nop

! Registers live out of .L900000562: 
! g3 g4 o1 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000562

			.L900000563:
/* 0x0648	 316 */		or	%g0,%o1,%o5

! Registers live out of .L900000563: 
! g3 g4 o3 o4 o5 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000561 .L900000563

			.L900000561:
/* 0x064c	 316 */		sub	%g3,4,%g3
/* 0x0650	     */		add	%o7,4,%o7
/* 0x0654	     */		ld	[%o5],%f0
/* 0x0658	     */		cmp	%g3,0
/* 0x065c	     */		add	%o5,4,%o5
/* 0x0660	     */		bge	.L900000561
/* 0x0664	     */		st	%f0,[%o7-4]

! Registers live out of .L900000561: 
! g3 g4 o3 o4 o5 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000561

			.L900000564:
/* 0x0668	 316 */		or	%g0,%o5,%o1
/* 0x066c	     */		ba	.L900000511
/* 0x0670	     */		nop

! Registers live out of .L900000564: 
! g3 g4 o1 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000562

			.L900000510:
/* 0x0674	 316 */		subcc	%g3,4,%g3

! Registers live out of .L900000510: 
! g3 g4 o1 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000510 .L900000588

			.L900000588:
/* 0x0678	 316 */		ld	[%o1],%f0
/* 0x067c	     */		add	%o1,4,%o1
/* 0x0680	     */		st	%f0,[%o7]
/* 0x0684	     */		add	%o7,4,%o7
/* 0x0688	     */		bge,a	.L900000588
/* 0x068c	     */		subcc	%g3,4,%g3

! Registers live out of .L900000588: 
! g3 g4 o1 o3 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000564 .L900000588

			.L900000511:
/* 0x0690	 316 */		add	%g3,4,%o2

! Registers live out of .L900000511: 
! g4 o1 o2 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000509 .L900000511

			.L900000512:
/* 0x0694	 316 */		andcc	%g4,3,%g0
/* 0x0698	     */		be	.L77002287
/* 0x069c	     */		subcc	%o2,1,%o2

! Registers live out of .L900000512: 
! o1 o2 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000512

			.L900000513:
/* 0x06a0	 316 */		ldub	[%o1],%o4
/* 0x06a4	     */		ble	.L77002287
/* 0x06a8	     */		stb	%o4,[%o7]

! Registers live out of .L900000513: 
! o1 o2 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000513

			.L900000514:
/* 0x06ac	 316 */		ldub	[%o1+1],%o5
/* 0x06b0	     */		subcc	%o2,1,%o2
/* 0x06b4	     */		ble	.L77002287
/* 0x06b8	     */		stb	%o5,[%o7+1]

! Registers live out of .L900000514: 
! o1 o4 sp o7 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000514

			.L900000515:
/* 0x06bc	 316 */		ldub	[%o1+2],%g2
/* 0x06c0	     */		stb	%g2,[%o7+2]
/* 0x06c4	     */		ba	.L900000587
/* 0x06c8	 319 */		add	%l4,722,%l3

! Registers live out of .L900000515: 
! o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002285

			.L900000516:
/* 0x06cc	 316 */		xor	%g1,-64,%g1
/* 0x06d0	     */		add	%g1,%fp,%g1
/* 0x06d4	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x06d8	     */		or	%g0,%g1,%o0

! Registers live out of .L900000516: 
! o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000512 .L900000513 .L900000514 .L900000516 .L900000590

			.L77002287:
/* 0x06dc	 319 */		add	%l4,722,%l3

! Registers live out of .L77002287: 
! o4 sp l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002287 .L900000507 .L900000508 .L900000515

			.L900000587:
/* 0x06e0	 319 */		ldub	[%i0+%l3],%l6
/* 0x06e4	     */		cmp	%l6,0
/* 0x06e8	     */		be,pn	%icc,.L77002291
/* 0x06ec	 323 */		add	%l4,664,%l6

! Registers live out of .L900000587: 
! o4 sp l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000587

			.L77002289:
/* 0x06f0	 320 */		sethi	%hi(0x1c00),%g1
/* 0x06f4	     */		xor	%g1,-832,%g1
/* 0x06f8	     */		add	%fp,-1600,%o5
/* 0x06fc	     */		add	%g1,%fp,%g1
/* 0x0700	     */		or	%g0,%i3,%o3
/* 0x0704	     */		or	%g0,%i2,%o2
/* 0x0708	     */		or	%g0,%i1,%o1
/* 0x070c	     */		or	%g0,%i0,%o0
/* 0x0710	     */		call	gl_logicop_ci_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0714	     */		or	%g0,%g1,%o4

! Registers live out of .L77002289: 
! o4 sp l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002289 .L900000587

			.L77002291:
/* 0x0718	 323 */		ldub	[%i0+%l6],%o2
/* 0x071c	     */		cmp	%o2,0
/* 0x0720	     */		be,pn	%icc,.L77002295
/* 0x0724	 324 */		or	%g0,%i3,%o3

! Registers live out of .L77002291: 
! o3 o4 sp l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002291

			.L77002293:
/* 0x0728	 324 */		sethi	%hi(0x1c00),%g1
/* 0x072c	     */		xor	%g1,-832,%g1
/* 0x0730	     */		add	%g1,%fp,%g1
/* 0x0734	     */		or	%g0,%i2,%o2
/* 0x0738	     */		or	%g0,%i1,%o1
/* 0x073c	     */		or	%g0,%i0,%o0
/* 0x0740	     */		call	gl_mask_index_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result = 
/* 0x0744	     */		or	%g0,%g1,%o4

! Registers live out of .L77002293: 
! o4 sp l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002291 .L77002293

			.L77002295:
/* 0x0748	 327 */		sethi	%hi(0x1c00),%g1
/* 0x074c	     */		xor	%g1,-832,%g1
/* 0x0750	     */		add	%fp,-1600,%o5
/* 0x0754	     */		add	%g1,%fp,%g1
/* 0x0758	     */		or	%g0,%i3,%o3
/* 0x075c	     */		or	%g0,%i2,%o2
/* 0x0760	     */		or	%g0,%i1,%o1
/* 0x0764	     */		or	%g0,%i0,%o0
/* 0x0768	     */		ld	[%i0+2260],%g5
/* 0x076c	     */		jmpl	%g5,%o7
/* 0x0770	     */		or	%g0,%g1,%o4
/* 0x0774	 329 */		ld	[%i0+%l5],%o0
/* 0x0778	     */		andcc	%o0,1024,%g0
/* 0x077c	     */		be,pn	%icc,.L77002324
/* 0x0780	 331 */		or	%g0,1029,%o1

! Registers live out of .L77002295: 
! o0 o1 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002295

			.L77002297:
/* 0x0784	 331 */		ld	[%i0+2236],%g3
/* 0x0788	     */		jmpl	%g3,%o7
/* 0x078c	     */		or	%g0,%i0,%o0
/* 0x0790	 332 */		cmp	%i1,0
/* 0x0794	     */		bleu,pn	%icc,.L77002305
/* 0x0798	     */		cmp	%i1,2

! Registers live out of .L77002297: 
! o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002297

			.L77002392:
/* 0x079c	 332 */		bl,pn	%icc,.L77002587
/* 0x07a0	     */		sethi	%hi(0x7ffffc00),%g3

! Registers live out of .L77002392: 
! g3 o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002392

			.L77002410:
/* 0x07a4	 332 */		add	%g3,1022,%g2
/* 0x07a8	     */		srl	%i1,0,%o5
/* 0x07ac	     */		sub	%o5,%g2,%o4
/* 0x07b0	     */		srlx	%o4,63,%l7
/* 0x07b4	     */		andcc	%l7,1,%g0
/* 0x07b8	     */		be,a,pn	%icc,.L77002406
/* 0x07bc	     */		or	%g0,0,%i5

! Registers live out of .L77002410: 
! o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002410

			.L77002441:
/* 0x07c0	 332 */		cmp	%i1,0
/* 0x07c4	     */		ble,pn	%icc,.L77002305
/* 0x07c8	     */		or	%g0,0,%g5

! Registers live out of .L77002441: 
! g5 o3 o4 sp l1 l2 l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002441

			.L77002462:
/* 0x07cc	 332 */		sethi	%hi(0x1c00),%g1
/* 0x07d0	     */		xor	%g1,-832,%g1
/* 0x07d4	     */		add	%i1,-1,%o2
/* 0x07d8	     */		add	%g1,%fp,%g4
/* 0x07dc	 333 */		add	%i1,-2,%i4
/* 0x07e0	     */		nop

! Registers live out of .L77002462: 
! g4 g5 o2 o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002462 .L900000565

			.L900000565:
/* 0x07e4	 333 */		st	%l1,[%g4]
/* 0x07e8	 332 */		add	%g5,2,%g5
/* 0x07ec	     */		add	%g4,8,%g4
/* 0x07f0	     */		cmp	%g5,%i4
/* 0x07f4	     */		ble,pt	%icc,.L900000565
/* 0x07f8	 333 */		st	%l1,[%g4-4]

! Registers live out of .L900000565: 
! g4 g5 o2 o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000565

			.L900000568:
/* 0x07fc	 332 */		cmp	%g5,%o2
/* 0x0800	     */		bg,pn	%icc,.L900000557
/* 0x0804	 333 */		nop

! Registers live out of .L900000568: 
! g4 o4 sp l1 l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000568

			.L77002442:
/* 0x0808	 333 */		st	%l1,[%g4]

! Registers live out of .L77002442: 
! o4 sp l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002442 .L900000568

			.L900000557:
/* 0x080c	 332 */		ba	.L900000586
/* 0x0810	 335 */		ldub	[%i0+%l3],%l2

! Registers live out of .L900000557: 
! o4 sp l2 l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002392

			.L77002587:
/* 0x0814	 332 */		or	%g0,0,%i5

! Registers live out of .L77002587: 
! o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002410 .L77002587

			.L77002406:
/* 0x0818	 333 */		sll	%i5,2,%i4

! Registers live out of .L77002406: 
! o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002406 .L900000585

			.L900000585:
/* 0x081c	 332 */		add	%i5,1,%i5
/* 0x0820	     */		cmp	%i5,%i1
/* 0x0824	 333 */		st	%l1,[%i4+%l2]
/* 0x0828	 332 */		bcs,pt	%icc,.L900000585
/* 0x082c	 333 */		sll	%i5,2,%i4

! Registers live out of .L900000585: 
! o3 o4 sp l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002297 .L77002441 .L900000585

			.L77002305:
/* 0x0830	 335 */		ldub	[%i0+%l3],%l2

! Registers live out of .L77002305: 
! o4 sp l2 l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002305 .L900000557

			.L900000586:
/* 0x0834	 335 */		cmp	%l2,0
/* 0x0838	     */		be,pn	%icc,.L77002309
/* 0x083c	 336 */		or	%g0,%i3,%o3

! Registers live out of .L900000586: 
! o3 o4 sp l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000586

			.L77002307:
/* 0x0840	 336 */		sethi	%hi(0x1c00),%g1
/* 0x0844	     */		xor	%g1,-832,%g1
/* 0x0848	     */		add	%fp,-1600,%o5
/* 0x084c	     */		add	%g1,%fp,%g1
/* 0x0850	     */		or	%g0,%i2,%o2
/* 0x0854	     */		or	%g0,%i1,%o1
/* 0x0858	     */		or	%g0,%i0,%o0
/* 0x085c	     */		call	gl_logicop_ci_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0860	     */		or	%g0,%g1,%o4

! Registers live out of .L77002307: 
! o4 sp l6 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002307 .L900000586

			.L77002309:
/* 0x0864	 338 */		ldub	[%i0+%l6],%i4
/* 0x0868	     */		cmp	%i4,0
/* 0x086c	     */		be,pn	%icc,.L77002313
/* 0x0870	 339 */		or	%g0,%i3,%o3

! Registers live out of .L77002309: 
! o3 o4 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002309

			.L77002311:
/* 0x0874	 339 */		sethi	%hi(0x1c00),%g1
/* 0x0878	     */		xor	%g1,-832,%g1
/* 0x087c	     */		add	%g1,%fp,%g1
/* 0x0880	     */		or	%g0,%i2,%o2
/* 0x0884	     */		or	%g0,%i1,%o1
/* 0x0888	     */		or	%g0,%i0,%o0
/* 0x088c	     */		call	gl_mask_index_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result = 
/* 0x0890	     */		or	%g0,%g1,%o4

! Registers live out of .L77002311: 
! o4 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002309 .L77002311

			.L77002313:
/* 0x0894	 341 */		sethi	%hi(0x1c00),%g1
/* 0x0898	     */		or	%g0,%i2,%o2
/* 0x089c	     */		xor	%g1,-832,%g1
/* 0x08a0	     */		or	%g0,%i0,%o0
/* 0x08a4	     */		add	%fp,-1600,%o5
/* 0x08a8	     */		add	%g1,%fp,%g1
/* 0x08ac	     */		or	%g0,%i3,%o3
/* 0x08b0	     */		or	%g0,%i1,%o1
/* 0x08b4	     */		ld	[%i0+2260],%i2
/* 0x08b8	     */		jmpl	%i2,%o7
/* 0x08bc	     */		or	%g0,%g1,%o4
/* 0x08c0	 342 */		or	%g0,%i0,%o0
/* 0x08c4	     */		ld	[%i0+2236],%i0
/* 0x08c8	     */		jmpl	%i0,%o7
/* 0x08cc	     */		or	%g0,1028,%o1

! Registers live out of .L77002313: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002209 .L77002217 .L77002231 .L77002239 .L77002295 .L77002313 .L77002317 .L77002330 .L77002342 .L77002346
! predecessor blocks: .L900000594

			.L77002324:
/* 0x08d0	 268 */		ret	! Result = 
/* 0x08d4	     */		restore	%g0,0,%g0
/* 0x08d8	   0 */		.type	gl_write_monoindex_span,2
/* 0x08d8	   0 */		.size	gl_write_monoindex_span,(.-gl_write_monoindex_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  353		      !      }
!  354		      !   }
!  355		      !}
!  359		      !void gl_write_color_span( GLcontext *ctx,
!  360		      !                          GLuint n, GLint x, GLint y, GLdepth z[],
!  361		      !			  GLubyte r[], GLubyte g[],
!  362		      !			  GLubyte b[], GLubyte a[],
!  363		      !			  GLenum primitive )
!  364		      !{

!
! SUBROUTINE gl_write_color_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_color_span
                       

			gl_write_color_span:
/* 000000	 364 */		sethi	%hi(0x2000),%g1
/* 0x0004	     */		xor	%g1,-104,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  365		      !   GLubyte mask[MAX_WIDTH];
!  366		      !   GLboolean write_all = GL_TRUE;
!  367		      !   GLubyte rtmp[MAX_WIDTH], gtmp[MAX_WIDTH], btmp[MAX_WIDTH], atmp[MAX_WIDTH];
!  368		      !   GLubyte *red, *green, *blue, *alpha;
!  370		      !   /* init mask to 1's (all pixels are to be written) */
!  371		      !   MEMSET(mask, 1, n);

/* 0x000c	 371 */		or	%g0,%i1,%o2
/* 0x0010	 364 */		st	%i5,[%sp+108]
/* 0x0014	 371 */		cmp	%o2,32
/* 0x0018	 364 */		ld	[%fp+104],%l7
/* 0x001c	 371 */		ble	.L900000833
/* 0x0020	     */		or	%g0,1,%o1

! Registers live out of gl_write_color_span: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_color_span

			.L900000832:
/* 0x0024	 371 */		call	memset	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0028	     */		add	%fp,-1600,%o0
/* 0x002c	     */		ba	.L900000980
/* 0x0030	   0 */		sethi	%hi(0xe000),%o4

! Registers live out of .L900000832: 
! g1 g2 o0 o2 o3 o4 sp o7 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_color_span

			.L900000833:
/* 0x0034	 371 */		sethi	%hi(0x1010000),%o1
/* 0x0038	     */		add	%o1,257,%o4
/* 0x003c	     */		add	%fp,-1600,%l3
/* 0x0040	     */		or	%g0,1,%o1
/* 0x0044	     */		cmp	%o2,3

! Registers live out of .L900000833: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000833 .L900000836

			.L900000981:
/* 0x0048	 371 */		bleu	.L900000838
/* 0x004c	     */		nop

! Registers live out of .L900000981: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000981

			.L900000836:
/* 0x0050	 371 */		sub	%o2,4,%o2
/* 0x0054	     */		st	%o4,[%l3]
/* 0x0058	     */		add	%l3,4,%l3
/* 0x005c	     */		ba	.L900000981
/* 0x0060	     */		cmp	%o2,3

! Registers live out of .L900000836: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000981

			.L900000838:
/* 0x0064	 371 */		andcc	%o2,3,%g0
/* 0x0068	     */		be	.L900000842
/* 0x006c	     */		cmp	%o2,0

! Registers live out of .L900000838: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000838

			.L900000933:
/* 0x0070	 371 */		bl,a	.L900000979
/* 0x0074	     */		subcc	%o2,1,%o2

! Registers live out of .L900000933: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000933

			.L900000936:
/* 0x0078	 371 */		cmp	%o2,2
/* 0x007c	     */		bl	.L900000932
/* 0x0080	     */		nop

! Registers live out of .L900000936: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000936

			.L900000937:
/* 0x0084	 371 */		or	%g0,%o2,%o3

! Registers live out of .L900000937: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000935 .L900000937

			.L900000935:
/* 0x0088	 371 */		stb	%o1,[%l3]
/* 0x008c	     */		sub	%o3,2,%o3
/* 0x0090	     */		add	%l3,2,%l3
/* 0x0094	     */		cmp	%o3,1
/* 0x0098	     */		bg	.L900000935
/* 0x009c	     */		stb	%o1,[%l3-1]

! Registers live out of .L900000935: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000935

			.L900000938:
/* 0x00a0	 371 */		cmp	%o3,0
/* 0x00a4	     */		ble	.L900000934
/* 0x00a8	     */		nop

! Registers live out of .L900000938: 
! g1 g2 o0 o1 o2 o3 sp o7 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000936 .L900000938

			.L900000932:
/* 0x00ac	 371 */		stb	%o1,[%l3]

! Registers live out of .L900000932: 
! g1 g2 o0 o2 o3 sp o7 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000932 .L900000938

			.L900000934:
/* 0x00b0	 371 */		ba	.L900000980
/* 0x00b4	   0 */		sethi	%hi(0xe000),%o4

! Registers live out of .L900000934: 
! g1 g2 o0 o2 o3 o4 sp o7 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000840 .L900000933

			.L900000979:
/* 0x00b8	 371 */		be	.L900000842
/* 0x00bc	     */		stb	%o1,[%l3]

! Registers live out of .L900000979: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000979

			.L900000840:
/* 0x00c0	 371 */		add	%l3,1,%l3
/* 0x00c4	     */		subcc	%o2,1,%o2
/* 0x00c8	     */		stb	%o1,[%l3]
/* 0x00cc	     */		add	%l3,1,%l3
/* 0x00d0	     */		bne	.L900000979
/* 0x00d4	     */		subcc	%o2,1,%o2

! Registers live out of .L900000840: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp o7 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000838 .L900000840 .L900000979

			.L900000842:
/* 0x00d8	   0 */		sethi	%hi(0xe000),%o4

! Registers live out of .L900000842: 
! g1 g2 o0 o2 o3 o4 sp o7 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  373		      !   if ((ctx->RasterMask & WINCLIP_BIT) || primitive==GL_BITMAP) {

                       
! predecessor blocks: .L900000832 .L900000842 .L900000934

			.L900000980:
/* 0x00dc	 373 */		add	%o4,264,%l0
/* 0x00e0	     */		ld	[%i0+%l0],%l6
/* 0x00e4	     */		andcc	%l6,512,%g0
/* 0x00e8	     */		bne,pn	%icc,.L77002611
/* 0x00ec	     */		sethi	%hi(0x1800),%l3

! Registers live out of .L900000980: 
! g1 g2 o0 o2 o3 o4 sp o7 l0 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000980

			.L77002607:
/* 0x00f0	 373 */		add	%l3,512,%l5
/* 0x00f4	     */		cmp	%l7,%l5
/* 0x00f8	     */		bne,pt	%icc,.L900000978
/* 0x00fc	 366 */		or	%g0,1,%l6

! Registers live out of .L77002607: 
! g1 g2 o0 o2 o3 o4 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002607 .L900000980

			.L77002611:
/* 0x0100	 128 */		cmp	%i3,0
/* 0x0104	     */		bl,pn	%icc,.L77002756
/* 0x0108	     */		nop

! Registers live out of .L77002611: 
! g1 g2 o0 o2 o3 o4 sp o7 l0 l1 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002611

			.L77002760:
/* 0x010c	 128 */		ld	[%i0+2204],%o5
/* 0x0110	     */		ld	[%o5+8],%l6
/* 0x0114	     */		cmp	%i3,%l6
/* 0x0118	     */		bge,pn	%icc,.L77002756
/* 0x011c	 133 */		cmp	%i2,0

! Registers live out of .L77002760: 
! g1 g2 o0 o2 o3 o4 o5 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002760

			.L77002766:
/* 0x0120	 133 */		bl,pn	%icc,.L77002772
/* 0x0124	     */		add	%i2,%i1,%g5

! Registers live out of .L77002766: 
! g1 g2 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002766

			.L77002768:
/* 0x0128	 133 */		ld	[%o5+4],%l5
/* 0x012c	     */		cmp	%g5,%l5
/* 0x0130	     */		bg,pn	%icc,.L77002772
/* 0x0134	 147 */		ld	[%fp+92],%l3

! Registers live out of .L77002768: 
! g1 g2 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002768

			.L77002770:
/* 0x0138	 147 */		ldx	[%fp+96],%o2

!  374		      !      if (clip_span( ctx,n,x,y,mask)==0) {
!  375		      !	 return;
!  376		      !      }
!  377		      !      write_all = GL_FALSE;

/* 0x013c	 377 */		or	%g0,0,%l6
/* 0x0140	 147 */		st	%o2,[%sp+104]
/* 0x0144	     */		srlx	%o2,32,%l5
/* 0x0148	 135 */		ba	.L900000975
/* 0x014c	 381 */		sethi	%hi(0x1800),%l1

! Registers live out of .L77002770: 
! g1 o0 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002766 .L77002768

			.L77002772:
/* 0x0150	 137 */		cmp	%g5,0
/* 0x0154	     */		ble,pn	%icc,.L77002756
/* 0x0158	     */		nop

! Registers live out of .L77002772: 
! g1 g2 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002772

			.L77002776:
/* 0x015c	 141 */		ld	[%o5+4],%l3
/* 0x0160	     */		cmp	%i2,%l3
/* 0x0164	     */		bge,pn	%icc,.L77002756
/* 0x0168	 147 */		cmp	%i1,0

! Registers live out of .L77002776: 
! g1 g2 g5 o0 o2 o3 o4 sp o7 l0 l1 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002776

			.L77002844:
/* 0x016c	 141 */		ldx	[%fp+96],%o5
/* 0x0170	     */		st	%o5,[%sp+104]
/* 0x0174	     */		ld	[%fp+92],%l3
/* 0x0178	     */		srlx	%o5,32,%l5
/* 0x017c	 147 */		ble,a,pn	%icc,.L77002617
/* 0x0180	 377 */		or	%g0,0,%l6

! Registers live out of .L77002844: 
! g1 g2 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002844

			.L77002863:
/* 0x0184	 147 */		or	%g0,0,%g3
/* 0x0188	     */		add	%i1,-1,%i5
/* 0x018c	 374 */		or	%g0,%i2,%l4
/* 0x0190	     */		add	%fp,-1600,%l2
/* 0x0194	 148 */		cmp	%i2,0

! Registers live out of .L77002863: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002863 .L900000977

			.L900000976:
/* 0x0198	 148 */		bl,a,pn	%icc,.L77002792
/* 0x019c	 149 */		stb	%g0,[%l2]

! Registers live out of .L900000976: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000976

			.L77002786:
/* 0x01a0	 148 */		ld	[%i0+2204],%l0
/* 0x01a4	     */		ld	[%l0+4],%l1
/* 0x01a8	     */		cmp	%l4,%l1
/* 0x01ac	     */		bl,a,pt	%icc,.L900000977
/* 0x01b0	 147 */		add	%g3,1,%g3

! Registers live out of .L77002786: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002786

			.L77002790:
/* 0x01b4	 149 */		stb	%g0,[%l2]

! Registers live out of .L77002790: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002790 .L900000976

			.L77002792:
/* 0x01b8	 147 */		add	%g3,1,%g3

! Registers live out of .L77002792: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002786 .L77002792

			.L900000977:
/* 0x01bc	 147 */		cmp	%g3,%i5
/* 0x01c0	     */		add	%l4,1,%l4
/* 0x01c4	     */		add	%l2,1,%l2
/* 0x01c8	     */		ble,pt	%icc,.L900000976
/* 0x01cc	 148 */		cmp	%l4,0

! Registers live out of .L900000977: 
! g1 g2 g3 g5 o0 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000977

			.L77002615:
/* 0x01d0	 377 */		or	%g0,0,%l6
/* 0x01d4	     */		ba	.L900000975
/* 0x01d8	 381 */		sethi	%hi(0x1800),%l1

! Registers live out of .L77002615: 
! g1 o0 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002607

			.L900000978:
/* 0x01dc	 366 */		ldx	[%fp+96],%g5
/* 0x01e0	     */		ld	[%fp+92],%l3
/* 0x01e4	     */		st	%g5,[%sp+104]
/* 0x01e8	     */		srlx	%g5,32,%l5

! Registers live out of .L900000978: 
! g1 o0 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  378		      !   }
!  380		      !   if ((primitive==GL_BITMAP && ctx->MutablePixels)
!  381		      !       || (ctx->RasterMask & FRONT_AND_BACK_BIT)) {

                       
! predecessor blocks: .L77002844 .L900000978

			.L77002617:
/* 0x01ec	 381 */		sethi	%hi(0x1800),%l1

! Registers live out of .L77002617: 
! g1 o0 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002615 .L77002617 .L77002770

			.L900000975:
/* 0x01f0	 381 */		add	%l1,512,%l4
/* 0x01f4	     */		cmp	%l7,%l4
/* 0x01f8	     */		bne,pn	%icc,.L77002623
/* 0x01fc	     */		add	%o4,286,%i5

! Registers live out of .L900000975: 
! g1 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000975

			.L77002619:
/* 0x0200	 381 */		ldub	[%i0+%i5],%l0
/* 0x0204	     */		cmp	%l0,0
/* 0x0208	     */		bne,pn	%icc,.L900000974
/* 0x020c	 383 */		or	%g0,%i1,%o2

! Registers live out of .L77002619: 
! g1 o0 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002619 .L900000975

			.L77002623:
/* 0x0210	 381 */		add	%o4,264,%l1
/* 0x0214	     */		ld	[%i0+%l1],%l2
/* 0x0218	     */		andcc	%l2,1024,%g0
/* 0x021c	     */		be,a,pt	%icc,.L900000973
/* 0x0220	 393 */		ld	[%sp+108],%l1

! Registers live out of .L77002623: 
! g1 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  382		      !      /* must make a copy of the colors since they may be modified */
!  383		      !      MEMCPY( rtmp, r, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L77002623

			.L77002627:
/* 0x0224	 383 */		or	%g0,%i1,%o2

! Registers live out of .L77002627: 
! g1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002619 .L77002627

			.L900000974:
/* 0x0228	 383 */		ld	[%sp+108],%o1
/* 0x022c	     */		cmp	%o2,32
/* 0x0230	     */		bg	.L900000828
/* 0x0234	     */		and	%o1,3,%o0

! Registers live out of .L900000974: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000974

			.L900000816:
/* 0x0238	 383 */		orcc	%o0,0,%g0
/* 0x023c	     */		be	.L900000821
/* 0x0240	     */		add	%fp,-3200,%g2

! Registers live out of .L900000816: 
! g1 g2 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000816

			.L900000817:
/* 0x0244	 383 */		subcc	%o2,2,%o2
/* 0x0248	     */		bl	.L900000819
/* 0x024c	     */		sub	%o2,-2,%g5

! Registers live out of .L900000817: 
! g1 g2 g5 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000817

			.L900000929:
/* 0x0250	 383 */		srl	%g5,31,%g3
/* 0x0254	     */		add	%g5,%g3,%g5
/* 0x0258	     */		sra	%g5,1,%i5
/* 0x025c	     */		cmp	%i5,1
/* 0x0260	     */		bl	.L900000818
/* 0x0264	     */		nop

! Registers live out of .L900000929: 
! g1 g2 o0 o1 o2 o4 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000929

			.L900000930:
/* 0x0268	 383 */		or	%g0,%o2,%o5
/* 0x026c	     */		add	%fp,-3200,%o0
/* 0x0270	     */		or	%g0,%o1,%g3

! Registers live out of .L900000930: 
! g1 g3 o0 o4 o5 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000928 .L900000930

			.L900000928:
/* 0x0274	 383 */		sub	%o5,2,%o5
/* 0x0278	     */		add	%o0,2,%o0
/* 0x027c	     */		ldub	[%g3],%o3
/* 0x0280	     */		cmp	%o5,0
/* 0x0284	     */		add	%g3,2,%g3
/* 0x0288	     */		stb	%o3,[%o0-2]
/* 0x028c	     */		ldub	[%g3-1],%o7
/* 0x0290	     */		bge	.L900000928
/* 0x0294	     */		stb	%o7,[%o0-1]

! Registers live out of .L900000928: 
! g1 g3 o0 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000928

			.L900000931:
/* 0x0298	 383 */		or	%g0,%o5,%o2
/* 0x029c	     */		or	%g0,%o0,%g2
/* 0x02a0	     */		or	%g0,%g3,%o1
/* 0x02a4	     */		ba	.L900000819
/* 0x02a8	     */		nop

! Registers live out of .L900000931: 
! g2 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000929

			.L900000818:
/* 0x02ac	 383 */		subcc	%o2,2,%o2

! Registers live out of .L900000818: 
! g1 g2 o0 o1 o2 o4 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000818 .L900000972

			.L900000972:
/* 0x02b0	 383 */		ldub	[%o1],%o3
/* 0x02b4	     */		stb	%o3,[%g2]
/* 0x02b8	     */		ldub	[%o1+1],%o7
/* 0x02bc	     */		add	%o1,2,%o1
/* 0x02c0	     */		stb	%o7,[%g2+1]
/* 0x02c4	     */		add	%g2,2,%g2
/* 0x02c8	     */		bge,a	.L900000972
/* 0x02cc	     */		subcc	%o2,2,%o2

! Registers live out of .L900000972: 
! g1 g2 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000817 .L900000931 .L900000972

			.L900000819:
/* 0x02d0	 383 */		cmp	%o2,-1
/* 0x02d4	     */		bl	.L900000970
/* 0x02d8	 384 */		or	%g0,%i1,%o2

! Registers live out of .L900000819: 
! g2 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000819

			.L900000820:
/* 0x02dc	 383 */		ldub	[%o1],%o2
/* 0x02e0	     */		stb	%o2,[%g2]
/* 0x02e4	     */		ba	.L900000970
/* 0x02e8	 384 */		or	%g0,%i1,%o2

! Registers live out of .L900000820: 
! o0 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000816

			.L900000821:
/* 0x02ec	 383 */		subcc	%o2,4,%o3
/* 0x02f0	     */		bl	.L900000824
/* 0x02f4	     */		sra	%i1,1,%o5

! Registers live out of .L900000821: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000821

			.L900000869:
/* 0x02f8	 383 */		srl	%o5,30,%l4
/* 0x02fc	     */		add	%i1,%l4,%g3
/* 0x0300	     */		sra	%g3,2,%g5
/* 0x0304	     */		cmp	%g5,1
/* 0x0308	     */		bl	.L900000822
/* 0x030c	     */		nop

! Registers live out of .L900000869: 
! g1 g2 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000869

			.L900000870:
/* 0x0310	 383 */		or	%g0,%o1,%o0

! Registers live out of .L900000870: 
! g1 g2 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000868 .L900000870

			.L900000868:
/* 0x0314	 383 */		sub	%o3,4,%o3
/* 0x0318	     */		add	%g2,4,%g2
/* 0x031c	     */		ld	[%o0],%f0
/* 0x0320	     */		cmp	%o3,0
/* 0x0324	     */		add	%o0,4,%o0
/* 0x0328	     */		bge	.L900000868
/* 0x032c	     */		st	%f0,[%g2-4]

! Registers live out of .L900000868: 
! g1 g2 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000868

			.L900000871:
/* 0x0330	 383 */		or	%g0,%o0,%o1
/* 0x0334	     */		ba	.L900000823
/* 0x0338	     */		nop

! Registers live out of .L900000871: 
! g2 o0 o1 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000869

			.L900000822:
/* 0x033c	 383 */		subcc	%o3,4,%o3

! Registers live out of .L900000822: 
! g1 g2 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000822 .L900000971

			.L900000971:
/* 0x0340	 383 */		ld	[%o1],%f0
/* 0x0344	     */		add	%o1,4,%o1
/* 0x0348	     */		st	%f0,[%g2]
/* 0x034c	     */		add	%g2,4,%g2
/* 0x0350	     */		bge,a	.L900000971
/* 0x0354	     */		subcc	%o3,4,%o3

! Registers live out of .L900000971: 
! g1 g2 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000871 .L900000971

			.L900000823:
/* 0x0358	 383 */		add	%o3,4,%o2

! Registers live out of .L900000823: 
! g2 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000821 .L900000823

			.L900000824:
/* 0x035c	 383 */		andcc	%i1,3,%g0
/* 0x0360	     */		be	.L900000830
/* 0x0364	     */		subcc	%o2,1,%o2

! Registers live out of .L900000824: 
! g2 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000824

			.L900000825:
/* 0x0368	 383 */		ldub	[%o1],%g4
/* 0x036c	     */		ble	.L900000830
/* 0x0370	     */		stb	%g4,[%g2]

! Registers live out of .L900000825: 
! g2 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000825

			.L900000826:
/* 0x0374	 383 */		ldub	[%o1+1],%l0
/* 0x0378	     */		subcc	%o2,1,%o2
/* 0x037c	     */		ble	.L900000830
/* 0x0380	     */		stb	%l0,[%g2+1]

! Registers live out of .L900000826: 
! g2 o0 o1 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000826

			.L900000827:
/* 0x0384	 383 */		ldub	[%o1+2],%i5
/* 0x0388	     */		stb	%i5,[%g2+2]
/* 0x038c	     */		ba	.L900000970
/* 0x0390	 384 */		or	%g0,%i1,%o2

! Registers live out of .L900000827: 
! o0 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000974

			.L900000828:
/* 0x0394	 383 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0398	     */		add	%fp,-3200,%o0

! Registers live out of .L900000828: 
! o0 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  384		      !      MEMCPY( gtmp, g, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000824 .L900000825 .L900000826 .L900000828

			.L900000830:
/* 0x039c	 384 */		or	%g0,%i1,%o2

! Registers live out of .L900000830: 
! o0 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000819 .L900000820 .L900000827 .L900000830

			.L900000970:
/* 0x03a0	 384 */		cmp	%o2,32
/* 0x03a4	     */		or	%g0,%l3,%o1
/* 0x03a8	     */		bg	.L900000812
/* 0x03ac	     */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000970: 
! g1 o0 o1 o2 o3 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000970

			.L900000800:
/* 0x03b0	 384 */		and	%o1,3,%o5
/* 0x03b4	     */		xor	%g1,-704,%g1
/* 0x03b8	     */		orcc	%o5,0,%g0
/* 0x03bc	     */		add	%g1,%fp,%g1
/* 0x03c0	     */		be	.L900000805
/* 0x03c4	     */		or	%g0,%g1,%o5

! Registers live out of .L900000800: 
! g1 o0 o1 o2 o3 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000800

			.L900000801:
/* 0x03c8	 384 */		subcc	%o2,2,%o2
/* 0x03cc	     */		bl	.L900000803
/* 0x03d0	     */		sub	%o2,-2,%o4

! Registers live out of .L900000801: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000801

			.L900000925:
/* 0x03d4	 384 */		srl	%o4,31,%l1
/* 0x03d8	     */		add	%o4,%l1,%l4
/* 0x03dc	     */		sra	%l4,1,%o4
/* 0x03e0	     */		cmp	%o4,1
/* 0x03e4	     */		bl	.L900000802
/* 0x03e8	     */		nop

! Registers live out of .L900000925: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000925

			.L900000926:
/* 0x03ec	 384 */		sethi	%hi(0x1000),%g1
/* 0x03f0	     */		xor	%g1,-704,%g1
/* 0x03f4	     */		add	%g1,%fp,%g1
/* 0x03f8	     */		or	%g0,%o2,%o3
/* 0x03fc	     */		or	%g0,%g1,%o7
/* 0x0400	     */		or	%g0,%o1,%o0

! Registers live out of .L900000926: 
! g1 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000924 .L900000926

			.L900000924:
/* 0x0404	 384 */		sub	%o3,2,%o3
/* 0x0408	     */		add	%o7,2,%o7
/* 0x040c	     */		ldub	[%o0],%g3
/* 0x0410	     */		cmp	%o3,0
/* 0x0414	     */		add	%o0,2,%o0
/* 0x0418	     */		stb	%g3,[%o7-2]
/* 0x041c	     */		ldub	[%o0-1],%g5
/* 0x0420	     */		bge	.L900000924
/* 0x0424	     */		stb	%g5,[%o7-1]

! Registers live out of .L900000924: 
! g1 o0 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000924

			.L900000927:
/* 0x0428	 384 */		or	%g0,%o3,%o2
/* 0x042c	     */		or	%g0,%o7,%o5
/* 0x0430	     */		or	%g0,%o0,%o1
/* 0x0434	     */		ba	.L900000803
/* 0x0438	     */		nop

! Registers live out of .L900000927: 
! o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000925

			.L900000802:
/* 0x043c	 384 */		subcc	%o2,2,%o2

! Registers live out of .L900000802: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000802 .L900000969

			.L900000969:
/* 0x0440	 384 */		ldub	[%o1],%g3
/* 0x0444	     */		stb	%g3,[%o5]
/* 0x0448	     */		ldub	[%o1+1],%g5
/* 0x044c	     */		add	%o1,2,%o1
/* 0x0450	     */		stb	%g5,[%o5+1]
/* 0x0454	     */		add	%o5,2,%o5
/* 0x0458	     */		bge,a	.L900000969
/* 0x045c	     */		subcc	%o2,2,%o2

! Registers live out of .L900000969: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000801 .L900000927 .L900000969

			.L900000803:
/* 0x0460	 384 */		cmp	%o2,-1
/* 0x0464	     */		bl	.L900000967
/* 0x0468	 385 */		or	%g0,%i1,%o2

! Registers live out of .L900000803: 
! o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000803

			.L900000804:
/* 0x046c	 384 */		ldub	[%o1],%l2
/* 0x0470	     */		stb	%l2,[%o5]
/* 0x0474	     */		ba	.L900000967
/* 0x0478	 385 */		or	%g0,%i1,%o2

! Registers live out of .L900000804: 
! o0 o2 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000800

			.L900000805:
/* 0x047c	 384 */		subcc	%o2,4,%o4
/* 0x0480	     */		bl	.L900000808
/* 0x0484	     */		sra	%o2,1,%o0

! Registers live out of .L900000805: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000805

			.L900000873:
/* 0x0488	 384 */		srl	%o0,30,%o3
/* 0x048c	     */		add	%o2,%o3,%o7
/* 0x0490	     */		sra	%o7,2,%l1
/* 0x0494	     */		cmp	%l1,1
/* 0x0498	     */		bl	.L900000806
/* 0x049c	     */		nop

! Registers live out of .L900000873: 
! g1 o0 o1 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000873

			.L900000874:
/* 0x04a0	 384 */		or	%g0,%o1,%g4

! Registers live out of .L900000874: 
! g1 g4 o0 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000872 .L900000874

			.L900000872:
/* 0x04a4	 384 */		sub	%o4,4,%o4
/* 0x04a8	     */		add	%o5,4,%o5
/* 0x04ac	     */		ld	[%g4],%f0
/* 0x04b0	     */		cmp	%o4,0
/* 0x04b4	     */		add	%g4,4,%g4
/* 0x04b8	     */		bge	.L900000872
/* 0x04bc	     */		st	%f0,[%o5-4]

! Registers live out of .L900000872: 
! g1 g4 o0 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000872

			.L900000875:
/* 0x04c0	 384 */		or	%g0,%g4,%o1
/* 0x04c4	     */		ba	.L900000807
/* 0x04c8	     */		nop

! Registers live out of .L900000875: 
! o0 o1 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000873

			.L900000806:
/* 0x04cc	 384 */		subcc	%o4,4,%o4

! Registers live out of .L900000806: 
! g1 o0 o1 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000806 .L900000968

			.L900000968:
/* 0x04d0	 384 */		ld	[%o1],%f0
/* 0x04d4	     */		add	%o1,4,%o1
/* 0x04d8	     */		st	%f0,[%o5]
/* 0x04dc	     */		add	%o5,4,%o5
/* 0x04e0	     */		bge,a	.L900000968
/* 0x04e4	     */		subcc	%o4,4,%o4

! Registers live out of .L900000968: 
! g1 o0 o1 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000875 .L900000968

			.L900000807:
/* 0x04e8	 384 */		add	%o4,4,%o2

! Registers live out of .L900000807: 
! o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000805 .L900000807

			.L900000808:
/* 0x04ec	 384 */		andcc	%i1,3,%g0
/* 0x04f0	     */		be	.L900000814
/* 0x04f4	     */		subcc	%o2,1,%o2

! Registers live out of .L900000808: 
! o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000808

			.L900000809:
/* 0x04f8	 384 */		ldub	[%o1],%l4
/* 0x04fc	     */		ble	.L900000814
/* 0x0500	     */		stb	%l4,[%o5]

! Registers live out of .L900000809: 
! o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000809

			.L900000810:
/* 0x0504	 384 */		ldub	[%o1+1],%l1
/* 0x0508	     */		subcc	%o2,1,%o2
/* 0x050c	     */		ble	.L900000814
/* 0x0510	     */		stb	%l1,[%o5+1]

! Registers live out of .L900000810: 
! o0 o1 o3 o4 o5 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000810

			.L900000811:
/* 0x0514	 384 */		ldub	[%o1+2],%g2
/* 0x0518	     */		stb	%g2,[%o5+2]
/* 0x051c	     */		ba	.L900000967
/* 0x0520	 385 */		or	%g0,%i1,%o2

! Registers live out of .L900000811: 
! o0 o2 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000970

			.L900000812:
/* 0x0524	 384 */		xor	%g1,-704,%g1
/* 0x0528	     */		add	%g1,%fp,%g1
/* 0x052c	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0530	     */		or	%g0,%g1,%o0

! Registers live out of .L900000812: 
! o0 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  385		      !      MEMCPY( btmp, b, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000808 .L900000809 .L900000810 .L900000812

			.L900000814:
/* 0x0534	 385 */		or	%g0,%i1,%o2

! Registers live out of .L900000814: 
! o0 o2 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000803 .L900000804 .L900000811 .L900000814

			.L900000967:
/* 0x0538	 385 */		cmp	%o2,32
/* 0x053c	     */		or	%g0,%l5,%o1
/* 0x0540	     */		bg	.L900000796
/* 0x0544	     */		sethi	%hi(0x1800),%g1

! Registers live out of .L900000967: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000967

			.L900000784:
/* 0x0548	 385 */		and	%o1,3,%g4
/* 0x054c	     */		xor	%g1,-256,%g1
/* 0x0550	     */		orcc	%g4,0,%g0
/* 0x0554	     */		add	%g1,%fp,%g1
/* 0x0558	     */		be	.L900000789
/* 0x055c	     */		or	%g0,%g1,%l4

! Registers live out of .L900000784: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000784

			.L900000785:
/* 0x0560	 385 */		subcc	%o2,2,%o2
/* 0x0564	     */		bl	.L900000787
/* 0x0568	     */		sub	%o2,-2,%o5

! Registers live out of .L900000785: 
! g1 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000785

			.L900000921:
/* 0x056c	 385 */		srl	%o5,31,%o3
/* 0x0570	     */		add	%o5,%o3,%o5
/* 0x0574	     */		sra	%o5,1,%o0
/* 0x0578	     */		cmp	%o0,1
/* 0x057c	     */		bl	.L900000786
/* 0x0580	     */		nop

! Registers live out of .L900000921: 
! g1 o1 o2 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000921

			.L900000922:
/* 0x0584	 385 */		sethi	%hi(0x1800),%g1
/* 0x0588	     */		xor	%g1,-256,%g1
/* 0x058c	     */		add	%g1,%fp,%g1
/* 0x0590	     */		or	%g0,%o2,%o7
/* 0x0594	     */		or	%g0,%g1,%g2
/* 0x0598	     */		or	%g0,%o1,%g4

! Registers live out of .L900000922: 
! g1 g2 g4 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000920 .L900000922

			.L900000920:
/* 0x059c	 385 */		sub	%o7,2,%o7
/* 0x05a0	     */		add	%g2,2,%g2
/* 0x05a4	     */		ldub	[%g4],%o3
/* 0x05a8	     */		cmp	%o7,0
/* 0x05ac	     */		add	%g4,2,%g4
/* 0x05b0	     */		stb	%o3,[%g2-2]
/* 0x05b4	     */		ldub	[%g4-1],%o0
/* 0x05b8	     */		bge	.L900000920
/* 0x05bc	     */		stb	%o0,[%g2-1]

! Registers live out of .L900000920: 
! g1 g2 g4 o0 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000920

			.L900000923:
/* 0x05c0	 385 */		or	%g0,%o7,%o2
/* 0x05c4	     */		or	%g0,%g2,%l4
/* 0x05c8	     */		or	%g0,%g4,%o1
/* 0x05cc	     */		ba	.L900000787
/* 0x05d0	     */		nop

! Registers live out of .L900000923: 
! o0 o1 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000921

			.L900000786:
/* 0x05d4	 385 */		subcc	%o2,2,%o2

! Registers live out of .L900000786: 
! g1 o1 o2 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000786 .L900000966

			.L900000966:
/* 0x05d8	 385 */		ldub	[%o1],%o3
/* 0x05dc	     */		stb	%o3,[%l4]
/* 0x05e0	     */		ldub	[%o1+1],%o0
/* 0x05e4	     */		add	%o1,2,%o1
/* 0x05e8	     */		stb	%o0,[%l4+1]
/* 0x05ec	     */		add	%l4,2,%l4
/* 0x05f0	     */		bge,a	.L900000966
/* 0x05f4	     */		subcc	%o2,2,%o2

! Registers live out of .L900000966: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000785 .L900000923 .L900000966

			.L900000787:
/* 0x05f8	 385 */		cmp	%o2,-1
/* 0x05fc	     */		bl	.L900000964
/* 0x0600	 386 */		or	%g0,%i1,%o2

! Registers live out of .L900000787: 
! o0 o1 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000787

			.L900000788:
/* 0x0604	 385 */		ldub	[%o1],%l0
/* 0x0608	     */		stb	%l0,[%l4]
/* 0x060c	     */		ba	.L900000964
/* 0x0610	 386 */		or	%g0,%i1,%o2

! Registers live out of .L900000788: 
! o0 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000784

			.L900000789:
/* 0x0614	 385 */		subcc	%o2,4,%l1
/* 0x0618	     */		bl	.L900000792
/* 0x061c	     */		sra	%o2,1,%i5

! Registers live out of .L900000789: 
! g1 o0 o1 o2 o3 o4 sp o7 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000789

			.L900000877:
/* 0x0620	 385 */		srl	%i5,30,%l0
/* 0x0624	     */		add	%o2,%l0,%g4
/* 0x0628	     */		sra	%g4,2,%o2
/* 0x062c	     */		cmp	%o2,1
/* 0x0630	     */		bl	.L900000790
/* 0x0634	     */		nop

! Registers live out of .L900000877: 
! g1 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000876 .L900000877

			.L900000876:
/* 0x0638	 385 */		sub	%l1,4,%l1
/* 0x063c	     */		add	%l4,4,%l4
/* 0x0640	     */		ld	[%o1],%f2
/* 0x0644	     */		cmp	%l1,0
/* 0x0648	     */		add	%o1,4,%o1
/* 0x064c	     */		bge	.L900000876
/* 0x0650	     */		st	%f2,[%l4-4]

! Registers live out of .L900000876: 
! g1 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000876

			.L900000879:
/* 0x0654	 385 */		ba	.L900000791
/* 0x0658	     */		nop

! Registers live out of .L900000879: 
! o0 o1 o3 o4 sp o7 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000877

			.L900000790:
/* 0x065c	 385 */		subcc	%l1,4,%l1

! Registers live out of .L900000790: 
! g1 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000790 .L900000965

			.L900000965:
/* 0x0660	 385 */		ld	[%o1],%f2
/* 0x0664	     */		add	%o1,4,%o1
/* 0x0668	     */		st	%f2,[%l4]
/* 0x066c	     */		add	%l4,4,%l4
/* 0x0670	     */		bge,a	.L900000965
/* 0x0674	     */		subcc	%l1,4,%l1

! Registers live out of .L900000965: 
! g1 o0 o1 o3 o4 sp o7 l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000879 .L900000965

			.L900000791:
/* 0x0678	 385 */		add	%l1,4,%o2

! Registers live out of .L900000791: 
! o0 o1 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000789 .L900000791

			.L900000792:
/* 0x067c	 385 */		andcc	%i1,3,%g0
/* 0x0680	     */		be	.L900000798
/* 0x0684	     */		subcc	%o2,1,%o2

! Registers live out of .L900000792: 
! o0 o1 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000792

			.L900000793:
/* 0x0688	 385 */		ldub	[%o1],%i5
/* 0x068c	     */		ble	.L900000798
/* 0x0690	     */		stb	%i5,[%l4]

! Registers live out of .L900000793: 
! o0 o1 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000793

			.L900000794:
/* 0x0694	 385 */		ldub	[%o1+1],%o4
/* 0x0698	     */		subcc	%o2,1,%o2
/* 0x069c	     */		ble	.L900000798
/* 0x06a0	     */		stb	%o4,[%l4+1]

! Registers live out of .L900000794: 
! o0 o1 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000794

			.L900000795:
/* 0x06a4	 385 */		ldub	[%o1+2],%o1
/* 0x06a8	     */		stb	%o1,[%l4+2]
/* 0x06ac	     */		ba	.L900000964
/* 0x06b0	 386 */		or	%g0,%i1,%o2

! Registers live out of .L900000795: 
! o0 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000967

			.L900000796:
/* 0x06b4	 385 */		xor	%g1,-256,%g1
/* 0x06b8	     */		add	%g1,%fp,%g1
/* 0x06bc	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x06c0	     */		or	%g0,%g1,%o0

! Registers live out of .L900000796: 
! o0 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  386		      !      MEMCPY( atmp, a, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000792 .L900000793 .L900000794 .L900000796

			.L900000798:
/* 0x06c4	 386 */		or	%g0,%i1,%o2

! Registers live out of .L900000798: 
! o0 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000787 .L900000788 .L900000795 .L900000798

			.L900000964:
/* 0x06c8	 386 */		cmp	%o2,32
/* 0x06cc	     */		ld	[%sp+104],%o1
/* 0x06d0	     */		bg	.L900000780
/* 0x06d4	     */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000964: 
! g1 o0 o1 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000964

			.L900000768:
/* 0x06d8	 386 */		and	%o1,3,%g3
/* 0x06dc	     */		xor	%g1,-832,%g1
/* 0x06e0	     */		orcc	%g3,0,%g0
/* 0x06e4	     */		add	%g1,%fp,%g1
/* 0x06e8	     */		be	.L900000773
/* 0x06ec	     */		or	%g0,%g1,%l0

! Registers live out of .L900000768: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000768

			.L900000769:
/* 0x06f0	 386 */		subcc	%o2,2,%o2
/* 0x06f4	     */		bl	.L900000771
/* 0x06f8	     */		sub	%o2,-2,%g3

! Registers live out of .L900000769: 
! g1 g3 o0 o1 o2 o3 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000769

			.L900000917:
/* 0x06fc	 386 */		srl	%g3,31,%o7
/* 0x0700	     */		add	%g3,%o7,%l2
/* 0x0704	     */		sra	%l2,1,%g3
/* 0x0708	     */		cmp	%g3,1
/* 0x070c	     */		bl	.L900000770
/* 0x0710	     */		nop

! Registers live out of .L900000917: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000917

			.L900000918:
/* 0x0714	 386 */		sethi	%hi(0x1c00),%g1
/* 0x0718	     */		xor	%g1,-832,%g1
/* 0x071c	     */		add	%g1,%fp,%g1
/* 0x0720	     */		or	%g0,%g1,%g4
/* 0x0724	     */		or	%g0,%o1,%g2

! Registers live out of .L900000918: 
! g1 g2 g4 o0 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000916 .L900000918

			.L900000916:
/* 0x0728	 386 */		sub	%o2,2,%o2
/* 0x072c	     */		add	%g4,2,%g4
/* 0x0730	     */		ldub	[%g2],%l4
/* 0x0734	     */		cmp	%o2,0
/* 0x0738	     */		add	%g2,2,%g2
/* 0x073c	     */		stb	%l4,[%g4-2]
/* 0x0740	     */		ldub	[%g2-1],%l2
/* 0x0744	     */		bge	.L900000916
/* 0x0748	     */		stb	%l2,[%g4-1]

! Registers live out of .L900000916: 
! g1 g2 g4 o0 o2 o3 o4 sp o7 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000916

			.L900000919:
/* 0x074c	 386 */		or	%g0,%g4,%l0
/* 0x0750	     */		or	%g0,%g2,%o1
/* 0x0754	     */		ba	.L900000771
/* 0x0758	     */		nop

! Registers live out of .L900000919: 
! o0 o1 o2 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000917

			.L900000770:
/* 0x075c	 386 */		subcc	%o2,2,%o2

! Registers live out of .L900000770: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000770 .L900000963

			.L900000963:
/* 0x0760	 386 */		ldub	[%o1],%l4
/* 0x0764	     */		stb	%l4,[%l0]
/* 0x0768	     */		ldub	[%o1+1],%l2
/* 0x076c	     */		add	%o1,2,%o1
/* 0x0770	     */		stb	%l2,[%l0+1]
/* 0x0774	     */		add	%l0,2,%l0
/* 0x0778	     */		bge,a	.L900000963
/* 0x077c	     */		subcc	%o2,2,%o2

! Registers live out of .L900000963: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000769 .L900000919 .L900000963

			.L900000771:
/* 0x0780	 386 */		cmp	%o2,-1
/* 0x0784	     */		bl	.L900000961
/* 0x0788	 390 */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000771: 
! g1 o0 o1 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000771

			.L900000772:
/* 0x078c	 386 */		ldub	[%o1],%l1
/* 0x0790	     */		stb	%l1,[%l0]
/* 0x0794	     */		ba	.L900000961
/* 0x0798	 390 */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000772: 
! g1 o0 o4 sp l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000768

			.L900000773:
/* 0x079c	 386 */		subcc	%o2,4,%i5
/* 0x07a0	     */		bl	.L900000776
/* 0x07a4	     */		sra	%i1,1,%l1

! Registers live out of .L900000773: 
! g1 o0 o1 o2 o3 o4 sp o7 l0 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000773

			.L900000881:
/* 0x07a8	 386 */		srl	%l1,30,%l4
/* 0x07ac	     */		add	%i1,%l4,%g3
/* 0x07b0	     */		sra	%g3,2,%g5
/* 0x07b4	     */		cmp	%g5,1
/* 0x07b8	     */		bl	.L900000774
/* 0x07bc	     */		nop

! Registers live out of .L900000881: 
! g1 o0 o1 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000881

			.L900000882:
/* 0x07c0	 386 */		or	%g0,%o1,%o2

! Registers live out of .L900000882: 
! g1 o0 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000880 .L900000882

			.L900000880:
/* 0x07c4	 386 */		sub	%i5,4,%i5
/* 0x07c8	     */		add	%l0,4,%l0
/* 0x07cc	     */		ld	[%o2],%f4
/* 0x07d0	     */		cmp	%i5,0
/* 0x07d4	     */		add	%o2,4,%o2
/* 0x07d8	     */		bge	.L900000880
/* 0x07dc	     */		st	%f4,[%l0-4]

! Registers live out of .L900000880: 
! g1 o0 o2 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000880

			.L900000883:
/* 0x07e0	 386 */		or	%g0,%o2,%o1
/* 0x07e4	     */		ba	.L900000775
/* 0x07e8	     */		nop

! Registers live out of .L900000883: 
! o0 o1 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000881

			.L900000774:
/* 0x07ec	 386 */		subcc	%i5,4,%i5

! Registers live out of .L900000774: 
! g1 o0 o1 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000774 .L900000962

			.L900000962:
/* 0x07f0	 386 */		ld	[%o1],%f4
/* 0x07f4	     */		add	%o1,4,%o1
/* 0x07f8	     */		st	%f4,[%l0]
/* 0x07fc	     */		add	%l0,4,%l0
/* 0x0800	     */		bge,a	.L900000962
/* 0x0804	     */		subcc	%i5,4,%i5

! Registers live out of .L900000962: 
! g1 o0 o1 o3 o4 sp o7 l0 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000883 .L900000962

			.L900000775:
/* 0x0808	 386 */		add	%i5,4,%o2

! Registers live out of .L900000775: 
! o0 o1 o2 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000773 .L900000775

			.L900000776:
/* 0x080c	 386 */		andcc	%i1,3,%g0
/* 0x0810	     */		be	.L900000782
/* 0x0814	     */		subcc	%o2,1,%o2

! Registers live out of .L900000776: 
! o0 o1 o2 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000776

			.L900000777:
/* 0x0818	 386 */		ldub	[%o1],%g2
/* 0x081c	     */		ble	.L900000782
/* 0x0820	     */		stb	%g2,[%l0]

! Registers live out of .L900000777: 
! o0 o1 o2 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000777

			.L900000778:
/* 0x0824	 386 */		ldub	[%o1+1],%o7
/* 0x0828	     */		subcc	%o2,1,%o2
/* 0x082c	     */		ble	.L900000782
/* 0x0830	     */		stb	%o7,[%l0+1]

! Registers live out of .L900000778: 
! o0 o1 o4 sp l0 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000778

			.L900000779:
/* 0x0834	 386 */		ldub	[%o1+2],%o2
/* 0x0838	     */		stb	%o2,[%l0+2]
/* 0x083c	     */		ba	.L900000961
/* 0x0840	 390 */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000779: 
! g1 o0 o4 sp l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000964

			.L900000780:
/* 0x0844	 386 */		xor	%g1,-832,%g1
/* 0x0848	     */		add	%g1,%fp,%g1
/* 0x084c	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0850	     */		or	%g0,%g1,%o0

! Registers live out of .L900000780: 
! o0 o4 sp l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  387		      !      red = rtmp;
!  388		      !      green = gtmp;
!  389		      !      blue = btmp;
!  390		      !      alpha = atmp;

                       
! predecessor blocks: .L900000776 .L900000777 .L900000778 .L900000780

			.L900000782:
/* 0x0854	 390 */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000782: 
! g1 o0 o4 sp l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000771 .L900000772 .L900000779 .L900000782

			.L900000961:
/* 0x0858	 390 */		xor	%g1,-832,%g1
/* 0x085c	     */		add	%g1,%fp,%l2
/* 0x0860	 389 */		sethi	%hi(0x1800),%g1
/* 0x0864	     */		xor	%g1,-256,%g1
/* 0x0868	     */		add	%g1,%fp,%i5
/* 0x086c	 388 */		sethi	%hi(0x1000),%g1
/* 0x0870	     */		xor	%g1,-704,%g1
/* 0x0874	     */		add	%g1,%fp,%l0
/* 0x0878	 387 */		add	%fp,-3200,%l1
/* 0x087c	 390 */		ba	.L900000960
/* 0x0880	 401 */		sethi	%hi(0x1c00),%o1

! Registers live out of .L900000961: 
! o0 o1 o4 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  391		      !   }
!  392		      !   else {
!  393		      !      red   = r;
!  394		      !      green = g;

                       
! predecessor blocks: .L77002623

			.L900000973:
/* 0x0884	 394 */		or	%g0,%l3,%l0

!  395		      !      blue  = b;

/* 0x0888	 395 */		or	%g0,%l5,%i5

!  396		      !      alpha = a;

/* 0x088c	 396 */		ld	[%sp+104],%l2

!  397		      !   }
!  399		      !   /* Per-pixel fog */
!  400		      !   if (ctx->Fog.Enabled && (ctx->Hint.Fog==GL_NICEST || primitive==GL_BITMAP
!  401		      !                            || ctx->Texture.Enabled)) {

/* 0x0890	 401 */		sethi	%hi(0x1c00),%o1

! Registers live out of .L900000973: 
! o0 o1 o4 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000961 .L900000973

			.L900000960:
/* 0x0894	 401 */		add	%o1,888,%l4
/* 0x0898	     */		ldub	[%i0+%l4],%o1
/* 0x089c	     */		cmp	%o1,0
/* 0x08a0	     */		be,pn	%icc,.L77002643
/* 0x08a4	   0 */		sethi	%hi(0xd400),%l4

! Registers live out of .L900000960: 
! o0 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000960

			.L77002633:
/* 0x08a8	 401 */		sethi	%hi(0x1c00),%g3
/* 0x08ac	     */		add	%g3,944,%g3
/* 0x08b0	     */		sethi	%hi(0x1000),%o5
/* 0x08b4	     */		ld	[%i0+%g3],%o2
/* 0x08b8	     */		add	%o5,258,%g5
/* 0x08bc	     */		cmp	%o2,%g5
/* 0x08c0	     */		be,pn	%icc,.L77002641
/* 0x08c4	     */		sethi	%hi(0x1800),%g5

! Registers live out of .L77002633: 
! g5 o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002633

			.L77002635:
/* 0x08c8	 401 */		add	%g5,512,%o5
/* 0x08cc	     */		cmp	%l7,%o5
/* 0x08d0	     */		be,pn	%icc,.L77002641
/* 0x08d4	     */		add	%l4,884,%o0

! Registers live out of .L77002635: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002635

			.L77002637:
/* 0x08d8	 401 */		ld	[%i0+%o0],%o4
/* 0x08dc	     */		cmp	%o4,0
/* 0x08e0	     */		be,pt	%icc,.L900000959
/* 0x08e4	 406 */		add	%l4,840,%o7

! Registers live out of .L77002637: 
! o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  402		      !      gl_fog_color_pixels( ctx, n, z, red, green, blue, alpha );

                       
! predecessor blocks: .L77002633 .L77002635 .L77002637

			.L77002641:
/* 0x08e8	 402 */		or	%g0,%i5,%o5
/* 0x08ec	     */		or	%g0,%l0,%o4
/* 0x08f0	     */		or	%g0,%l1,%o3
/* 0x08f4	     */		or	%g0,%i4,%o2
/* 0x08f8	     */		or	%g0,%i1,%o1
/* 0x08fc	     */		st	%l2,[%sp+92]
/* 0x0900	     */		call	gl_fog_color_pixels	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92	! Result = 
/* 0x0904	     */		or	%g0,%i0,%o0

! Registers live out of .L77002641: 
! o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  403		      !   }
!  405		      !   /* Do the scissor test */
!  406		      !   if (ctx->Scissor.Enabled) {

                       
! predecessor blocks: .L77002641 .L900000960

			.L77002643:
/* 0x0908	 406 */		add	%l4,840,%o7

! Registers live out of .L77002643: 
! o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002637 .L77002643

			.L900000959:
/* 0x090c	 406 */		ldub	[%i0+%o7],%g2
/* 0x0910	     */		cmp	%g2,0
/* 0x0914	     */		be,pn	%icc,.L77002651
/* 0x0918	 407 */		or	%g0,%i3,%o3

! Registers live out of .L900000959: 
! o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  407		      !      if (gl_scissor_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900000959

			.L77002645:
/* 0x091c	 407 */		or	%g0,%i2,%o2
/* 0x0920	     */		or	%g0,%i1,%o1
/* 0x0924	     */		or	%g0,%i0,%o0
/* 0x0928	     */		call	gl_scissor_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x092c	     */		add	%fp,-1600,%o4
/* 0x0930	     */		orcc	%g0,%o0,%g0
/* 0x0934	     */		be,pn	%icc,.L77002756

!  408		      !	 return;
!  409		      !      }
!  410		      !      write_all = GL_FALSE;

/* 0x0938	 410 */		or	%g0,0,%l6

! Registers live out of .L77002645: 
! sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  411		      !   }
!  413		      !   /* Polygon Stippling */
!  414		      !   if (ctx->Polygon.StippleFlag && primitive==GL_POLYGON) {

                       
! predecessor blocks: .L77002645 .L900000959

			.L77002651:
/* 0x093c	 414 */		add	%l4,697,%o3
/* 0x0940	     */		ldub	[%i0+%o3],%g4
/* 0x0944	     */		cmp	%g4,0
/* 0x0948	     */		be,pn	%icc,.L77002657
/* 0x094c	     */		cmp	%l7,9

! Registers live out of .L77002651: 
! o3 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002651

			.L77002653:
/* 0x0950	 414 */		bne,pn	%icc,.L77002657
/* 0x0954	 104 */		cmp	%i1,0

! Registers live out of .L77002653: 
! o3 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002653

			.L77002655:
/* 0x0958	 104 */		bleu,pn	%icc,.L77002820
/* 0x095c	 101 */		cmp	%i1,2

! Registers live out of .L77002655: 
! o3 sp l0 l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002655

			.L77002822:
/* 0x0960	 101 */		sra	%i3,31,%o4
/* 0x0964	     */		and	%o4,31,%o0
/* 0x0968	     */		add	%i3,%o0,%l7
/* 0x096c	     */		andn	%l7,31,%g4
/* 0x0970	 102 */		sra	%i2,31,%o2
/* 0x0974	 101 */		sub	%i3,%g4,%g2
/* 0x0978	 102 */		and	%o2,31,%o7
/* 0x097c	 101 */		sll	%g2,2,%g3
/* 0x0980	 102 */		add	%i2,%o7,%g5
/* 0x0984	 101 */		add	%i0,%g3,%o3
/* 0x0988	     */		add	%l4,712,%o1
/* 0x098c	 102 */		andn	%g5,31,%l6
/* 0x0990	     */		sub	%i2,%l6,%o5
/* 0x0994	   0 */		sethi	%hi(0x80000000),%o0
/* 0x0998	 101 */		ld	[%o3+%o1],%g4
/* 0x099c	     */		bl,pn	%icc,.L77002924
/* 0x09a0	 102 */		srl	%o0,%o5,%o7

! Registers live out of .L77002822: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002822

			.L77002835:
/* 0x09a4	 104 */		sethi	%hi(0x7ffffc00),%o2
/* 0x09a8	     */		add	%o2,1022,%o1
/* 0x09ac	     */		srl	%i1,0,%g3
/* 0x09b0	     */		sub	%g3,%o1,%g2
/* 0x09b4	     */		srlx	%g2,63,%o1
/* 0x09b8	     */		andcc	%o1,1,%g0
/* 0x09bc	     */		be,a,pn	%icc,.L77002827
/* 0x09c0	     */		or	%g0,0,%o3

! Registers live out of .L77002835: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002835

			.L77002843:
/* 0x09c4	 104 */		add	%i1,-1,%l7
/* 0x09c8	     */		or	%g0,0,%g2
/* 0x09cc	 105 */		andcc	%o7,%g4,%g0

! Registers live out of .L77002843: 
! g2 g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002809 .L77002843

			.L900000958:
/* 0x09d0	 105 */		bne,pn	%icc,.L77002809
/* 0x09d4	 108 */		srl	%o7,1,%o7

! Registers live out of .L900000958: 
! g2 g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000958

			.L77002807:
/* 0x09d8	 106 */		add	%fp,-1600,%o4
/* 0x09dc	     */		stb	%g0,[%g2+%o4]

! Registers live out of .L77002807: 
! g2 g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002807 .L900000958

			.L77002809:
/* 0x09e0	 109 */		cmp	%o7,0
/* 0x09e4	   0 */		move	%icc,%o0,%o7
/* 0x09e8	 104 */		add	%g2,1,%g2
/* 0x09ec	     */		cmp	%g2,%l7
/* 0x09f0	     */		ble,pt	%icc,.L900000958
/* 0x09f4	 105 */		andcc	%o7,%g4,%g0

! Registers live out of .L77002809: 
! g2 g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002809

			.L900000865:
/* 0x09f8	 104 */		ba	.L77002657

!  415		      !      stipple_polygon_span( ctx, n, x, y, mask );
!  416		      !      write_all = GL_FALSE;

/* 0x09fc	 416 */		or	%g0,0,%l6

! Registers live out of .L900000865: 
! o3 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002822

			.L77002924:
/* 0x0a00	 104 */		or	%g0,0,%o3

! Registers live out of .L77002924: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002835 .L77002924

			.L77002827:
/* 0x0a04	 105 */		andcc	%o7,%g4,%g0

! Registers live out of .L77002827: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002827 .L77002831

			.L900000957:
/* 0x0a08	 105 */		bne,pn	%icc,.L77002831
/* 0x0a0c	 108 */		srl	%o7,1,%o7

! Registers live out of .L900000957: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000957

			.L77002828:
/* 0x0a10	 106 */		add	%fp,-1600,%l6
/* 0x0a14	     */		stb	%g0,[%o3+%l6]

! Registers live out of .L77002828: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002828 .L900000957

			.L77002831:
/* 0x0a18	 109 */		cmp	%o7,0
/* 0x0a1c	   0 */		move	%icc,%o0,%o7
/* 0x0a20	 104 */		add	%o3,1,%o3
/* 0x0a24	     */		cmp	%o3,%i1
/* 0x0a28	     */		bcs,pt	%icc,.L900000957
/* 0x0a2c	 105 */		andcc	%o7,%g4,%g0

! Registers live out of .L77002831: 
! g4 o0 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002655 .L77002831

			.L77002820:
/* 0x0a30	 416 */		or	%g0,0,%l6

! Registers live out of .L77002820: 
! o3 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  417		      !   }
!  419		      !   /* Do the alpha test */
!  420		      !   if (ctx->Color.AlphaEnabled) {

                       
! predecessor blocks: .L77002651 .L77002653 .L77002820 .L900000865

			.L77002657:
/* 0x0a34	 420 */		sethi	%hi(0x1c00),%o4
/* 0x0a38	     */		add	%o4,672,%o2
/* 0x0a3c	     */		ldub	[%i0+%o2],%o1
/* 0x0a40	     */		cmp	%o1,0
/* 0x0a44	     */		be,pn	%icc,.L77002665
/* 0x0a48	 421 */		or	%g0,%l2,%o2

! Registers live out of .L77002657: 
! o2 o3 o4 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  421		      !      if (gl_alpha_test( ctx, n, alpha, mask )==0) {

                       
! predecessor blocks: .L77002657

			.L77002659:
/* 0x0a4c	 421 */		or	%g0,%i1,%o1
/* 0x0a50	     */		or	%g0,%i0,%o0
/* 0x0a54	     */		call	gl_alpha_test	! params =  %o0 %o1 %o2 %o3	! Result =  %o0
/* 0x0a58	     */		add	%fp,-1600,%o3
/* 0x0a5c	     */		orcc	%g0,%o0,%g0
/* 0x0a60	     */		be,pn	%icc,.L77002756

!  422		      !	 return;
!  423		      !      }
!  424		      !      write_all = GL_FALSE;

/* 0x0a64	 424 */		or	%g0,0,%l6

! Registers live out of .L77002659: 
! o4 sp l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  425		      !   }
!  427		      !   if (ctx->Stencil.Enabled) {

                       
! predecessor blocks: .L77002657 .L77002659

			.L77002665:
/* 0x0a68	 427 */		add	%l4,860,%o5
/* 0x0a6c	     */		ldub	[%i0+%o5],%g5
/* 0x0a70	     */		cmp	%g5,0
/* 0x0a74	     */		be,pn	%icc,.L77002673
/* 0x0a78	 429 */		or	%g0,%i3,%o3

! Registers live out of .L77002665: 
! o3 o4 o5 sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  428		      !      /* first stencil test */
!  429		      !      if (gl_stencil_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L77002665

			.L77002667:
/* 0x0a7c	 429 */		or	%g0,%i2,%o2
/* 0x0a80	     */		or	%g0,%i1,%o1
/* 0x0a84	     */		or	%g0,%i0,%o0
/* 0x0a88	     */		call	gl_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0a8c	     */		add	%fp,-1600,%o4
/* 0x0a90	     */		orcc	%g0,%o0,%g0
/* 0x0a94	     */		be,pn	%icc,.L77002756
/* 0x0a98	 433 */		or	%g0,%i4,%o4

! Registers live out of .L77002667: 
! o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  430		      !	 return;
!  431		      !      }
!  432		      !      /* depth buffering w/ stencil */
!  433		      !      gl_depth_stencil_span( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77002667

			.L77002671:
/* 0x0a9c	 433 */		or	%g0,%i3,%o3
/* 0x0aa0	     */		or	%g0,%i2,%o2
/* 0x0aa4	     */		or	%g0,%i1,%o1
/* 0x0aa8	     */		or	%g0,%i0,%o0

!  434		      !      write_all = GL_FALSE;

/* 0x0aac	 434 */		or	%g0,0,%l6
/* 0x0ab0	 433 */		call	gl_depth_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0ab4	     */		add	%fp,-1600,%o5
/* 0x0ab8	 434 */		ba	.L900000956
/* 0x0abc	 447 */		sethi	%hi(0xe000),%g4

! Registers live out of .L77002671: 
! g4 sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  435		      !   }
!  436		      !   else if (ctx->Depth.Test) {

                       
! predecessor blocks: .L77002665

			.L77002673:
/* 0x0ac0	 436 */		sethi	%hi(0x1c00),%g2
/* 0x0ac4	     */		add	%g2,828,%o4
/* 0x0ac8	     */		ldub	[%i0+%o4],%g3
/* 0x0acc	     */		cmp	%g3,0
/* 0x0ad0	     */		be,pn	%icc,.L77002687
/* 0x0ad4	 438 */		or	%g0,%i4,%o4

! Registers live out of .L77002673: 
! o4 o5 sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  437		      !      /* regular depth testing */
!  438		      !      GLuint m = (*ctx->Driver.DepthTestSpan)( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77002673

			.L77002675:
/* 0x0ad8	 438 */		or	%g0,%i3,%o3
/* 0x0adc	     */		or	%g0,%i2,%o2
/* 0x0ae0	     */		or	%g0,%i1,%o1
/* 0x0ae4	     */		or	%g0,%i0,%o0
/* 0x0ae8	     */		ld	[%i0+2332],%l4
/* 0x0aec	     */		jmpl	%l4,%o7
/* 0x0af0	     */		add	%fp,-1600,%o5
/* 0x0af4	     */		orcc	%g0,%o0,%g0

!  439		      !      if (m==0) {

/* 0x0af8	 439 */		be,pn	%icc,.L77002756
/* 0x0afc	 443 */		srl	%o0,0,%o2

! Registers live out of .L77002675: 
! o2 sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  440		      !         return;
!  441		      !      }
!  442		      !      if (m<n) {
!  443		      !         write_all = GL_FALSE;

                       
! predecessor blocks: .L77002675

			.L77002679:
/* 0x0b00	 443 */		srl	%i1,0,%g4
/* 0x0b04	     */		sub	%o2,%g4,%o4
/* 0x0b08	     */		srlx	%o4,63,%l7
/* 0x0b0c	     */		xor	%l7,1,%g2
/* 0x0b10	     */		and	%g2,%l6,%l6
/* 0x0b14	     */		and	%l6,255,%l6

! Registers live out of .L77002679: 
! sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  444		      !      }
!  445		      !   }
!  447		      !   if (ctx->RasterMask & NO_DRAW_BIT) {

                       
! predecessor blocks: .L77002673 .L77002679

			.L77002687:
/* 0x0b18	 447 */		sethi	%hi(0xe000),%g4

! Registers live out of .L77002687: 
! g4 sp l0 l1 l2 l5 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002671 .L77002687

			.L900000956:
/* 0x0b1c	 447 */		add	%g4,264,%o2
/* 0x0b20	     */		ld	[%i0+%o2],%o7
/* 0x0b24	     */		andcc	%o7,2048,%g0
/* 0x0b28	     */		bne,pn	%icc,.L77002756
/* 0x0b2c	 453 */		sethi	%hi(0x1c00),%l7

! Registers live out of .L900000956: 
! sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  448		      !      /* write no pixels */
!  449		      !      return;
!  450		      !   }
!  452		      !   /* logic op or blending */
!  453		      !   if (ctx->Color.SWLogicOpEnabled) {

                       
! predecessor blocks: .L900000956

			.L77002691:
/* 0x0b30	 453 */		add	%l7,722,%l7
/* 0x0b34	     */		ldub	[%i0+%l7],%g4
/* 0x0b38	     */		cmp	%g4,0
/* 0x0b3c	     */		be,pn	%icc,.L77002695
/* 0x0b40	 454 */		add	%fp,-1600,%o7

! Registers live out of .L77002691: 
! sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  454		      !      gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77002691

			.L77002693:
/* 0x0b44	 454 */		srl	%o7,0,%o3
/* 0x0b48	     */		sllx	%l2,32,%o0
/* 0x0b4c	     */		or	%o0,%o3,%o1
/* 0x0b50	     */		or	%g0,%l0,%o5
/* 0x0b54	     */		or	%g0,%l1,%o4
/* 0x0b58	     */		or	%g0,%i3,%o3
/* 0x0b5c	     */		or	%g0,%i2,%o2
/* 0x0b60	     */		stx	%o1,[%sp+96]
/* 0x0b64	     */		or	%g0,%i1,%o1
/* 0x0b68	     */		st	%i5,[%sp+92]
/* 0x0b6c	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0b70	     */		or	%g0,%i0,%o0
/* 0x0b74	     */		ba	.L900000955
/* 0x0b78	 461 */		sethi	%hi(0x1c00),%l4

! Registers live out of .L77002693: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  455		      !   }
!  456		      !   else if (ctx->Color.BlendEnabled) {

                       
! predecessor blocks: .L77002691

			.L77002695:
/* 0x0b7c	 456 */		sethi	%hi(0x1c00),%o0
/* 0x0b80	     */		add	%o0,685,%o3
/* 0x0b84	     */		ldub	[%i0+%o3],%o0
/* 0x0b88	     */		cmp	%o0,0
/* 0x0b8c	     */		be,pn	%icc,.L77002701
/* 0x0b90	 457 */		add	%fp,-1600,%o3

! Registers live out of .L77002695: 
! o0 o3 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  457		      !      gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77002695

			.L77002697:
/* 0x0b94	 457 */		srl	%o3,0,%g5
/* 0x0b98	     */		sllx	%l2,32,%o5
/* 0x0b9c	     */		or	%o5,%g5,%g2
/* 0x0ba0	     */		or	%g0,%l0,%o5
/* 0x0ba4	     */		or	%g0,%l1,%o4
/* 0x0ba8	     */		or	%g0,%i3,%o3
/* 0x0bac	     */		or	%g0,%i2,%o2
/* 0x0bb0	     */		stx	%g2,[%sp+96]
/* 0x0bb4	     */		or	%g0,%i1,%o1
/* 0x0bb8	     */		st	%i5,[%sp+92]
/* 0x0bbc	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0bc0	     */		or	%g0,%i0,%o0

! Registers live out of .L77002697: 
! o0 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  458		      !   }
!  460		      !   /* Color component masking */
!  461		      !   if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77002695 .L77002697

			.L77002701:
/* 0x0bc4	 461 */		sethi	%hi(0x1c00),%l4

! Registers live out of .L77002701: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002693 .L77002701

			.L900000955:
/* 0x0bc8	 461 */		add	%l4,664,%l4
/* 0x0bcc	     */		ldub	[%i0+%l4],%o1
/* 0x0bd0	     */		cmp	%o1,0
/* 0x0bd4	     */		be,pn	%icc,.L77002705
/* 0x0bd8	 462 */		or	%g0,%l0,%o5

! Registers live out of .L900000955: 
! o0 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  462		      !      gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );

                       
! predecessor blocks: .L900000955

			.L77002703:
/* 0x0bdc	 462 */		or	%g0,%l1,%o4
/* 0x0be0	     */		or	%g0,%i3,%o3
/* 0x0be4	     */		or	%g0,%i2,%o2
/* 0x0be8	     */		st	%i5,[%sp+92]
/* 0x0bec	     */		or	%g0,%i1,%o1
/* 0x0bf0	     */		st	%l2,[%sp+96]
/* 0x0bf4	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0bf8	     */		or	%g0,%i0,%o0

! Registers live out of .L77002703: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  463		      !   }
!  465		      !   /* write pixels */
!  466		      !   (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  467		      !                                  write_all ? NULL : mask );

                       
! predecessor blocks: .L77002703 .L900000955

			.L77002705:
/* 0x0bfc	 467 */		cmp	%l6,0
/* 0x0c00	     */		be,pn	%icc,.L77002709
/* 0x0c04	     */		or	%g0,%l0,%o5

! Registers live out of .L77002705: 
! o0 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002705

			.L77002707:
/* 0x0c08	 467 */		sllx	%l2,32,%o2
/* 0x0c0c	     */		or	%g0,%l1,%o4
/* 0x0c10	     */		or	%g0,%i3,%o3
/* 0x0c14	     */		or	%g0,%i1,%o1
/* 0x0c18	     */		ld	[%i0+2244],%i4
/* 0x0c1c	     */		stx	%o2,[%sp+96]
/* 0x0c20	     */		or	%g0,%i2,%o2
/* 0x0c24	     */		st	%i5,[%sp+92]
/* 0x0c28	     */		jmpl	%i4,%o7
/* 0x0c2c	     */		or	%g0,%i0,%o0

!  468		      !   if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x0c30	 468 */		sethi	%hi(0xe000),%i4
/* 0x0c34	     */		add	%i4,264,%o1
/* 0x0c38	     */		ld	[%i0+%o1],%o2
/* 0x0c3c	     */		andcc	%o2,256,%g0
/* 0x0c40	     */		be,pn	%icc,.L77002721

!  469		      !      gl_write_alpha_span( ctx, n, x, y, alpha, write_all ? NULL : mask );

/* 0x0c44	 469 */		or	%g0,0,%o5

! Registers live out of .L77002707: 
! g1 g4 o0 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002707

			.L77002715:
/* 0x0c48	 469 */		ba	.L900000954
/* 0x0c4c	     */		or	%g0,%l2,%o4

! Registers live out of .L77002715: 
! o0 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002705

			.L77002709:
/* 0x0c50	 467 */		add	%fp,-1600,%g5
/* 0x0c54	     */		srl	%g5,0,%o7
/* 0x0c58	     */		sllx	%l2,32,%o4
/* 0x0c5c	     */		or	%o4,%o7,%g4
/* 0x0c60	     */		or	%g0,%l1,%o4
/* 0x0c64	     */		or	%g0,%i3,%o3
/* 0x0c68	     */		or	%g0,%i2,%o2
/* 0x0c6c	     */		ld	[%i0+2244],%g5
/* 0x0c70	     */		or	%g0,%i1,%o1
/* 0x0c74	     */		stx	%g4,[%sp+96]
/* 0x0c78	     */		st	%i5,[%sp+92]
/* 0x0c7c	     */		jmpl	%g5,%o7
/* 0x0c80	     */		or	%g0,%i0,%o0
/* 0x0c84	 468 */		sethi	%hi(0xe000),%o5
/* 0x0c88	     */		add	%o5,264,%g3
/* 0x0c8c	     */		ld	[%i0+%g3],%o2
/* 0x0c90	     */		andcc	%o2,256,%g0
/* 0x0c94	     */		be,pn	%icc,.L77002721
/* 0x0c98	 469 */		add	%fp,-1600,%o5

! Registers live out of .L77002709: 
! g1 g4 o0 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002709

			.L77002719:
/* 0x0c9c	 469 */		or	%g0,%l2,%o4

! Registers live out of .L77002719: 
! o0 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002715 .L77002719

			.L900000954:
/* 0x0ca0	 469 */		or	%g0,%i3,%o3
/* 0x0ca4	     */		or	%g0,%i2,%o2
/* 0x0ca8	     */		or	%g0,%i1,%o1
/* 0x0cac	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0cb0	     */		or	%g0,%i0,%o0
/* 0x0cb4	     */		sethi	%hi(0xe000),%g2
/* 0x0cb8	     */		add	%g2,264,%o4
/* 0x0cbc	     */		ld	[%i0+%o4],%o2

! Registers live out of .L900000954: 
! g1 g4 o0 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  470		      !   }
!  472		      !   if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

                       
! predecessor blocks: .L77002707 .L77002709 .L900000954

			.L77002721:
/* 0x0cc0	 472 */		andcc	%o2,1024,%g0
/* 0x0cc4	     */		be,pn	%icc,.L77002756
/* 0x0cc8	 474 */		ld	[%sp+108],%o1

! Registers live out of .L77002721: 
! g1 g4 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  473		      !      /*** Also render to back buffer ***/
!  474		      !      MEMCPY( rtmp, r, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L77002721

			.L77002723:
/* 0x0ccc	 474 */		or	%g0,%i1,%o2
/* 0x0cd0	     */		cmp	%o2,32
/* 0x0cd4	     */		bg	.L900000764
/* 0x0cd8	     */		and	%o1,3,%o4

! Registers live out of .L77002723: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002723

			.L900000752:
/* 0x0cdc	 474 */		orcc	%o4,0,%g0
/* 0x0ce0	     */		be	.L900000757
/* 0x0ce4	     */		add	%fp,-3200,%g3

! Registers live out of .L900000752: 
! g1 g3 g4 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000752

			.L900000753:
/* 0x0ce8	 474 */		subcc	%o2,2,%o2
/* 0x0cec	     */		bl	.L900000755
/* 0x0cf0	     */		sub	%o2,-2,%o0

! Registers live out of .L900000753: 
! g1 g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000753

			.L900000913:
/* 0x0cf4	 474 */		srl	%o0,31,%g5
/* 0x0cf8	     */		add	%o0,%g5,%o4
/* 0x0cfc	     */		sra	%o4,1,%g4
/* 0x0d00	     */		cmp	%g4,1
/* 0x0d04	     */		bl	.L900000754
/* 0x0d08	     */		nop

! Registers live out of .L900000913: 
! g1 g3 g4 g5 o1 o2 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000913

			.L900000914:
/* 0x0d0c	 474 */		or	%g0,%o2,%o5
/* 0x0d10	     */		add	%fp,-3200,%g5
/* 0x0d14	     */		or	%g0,%o1,%o4

! Registers live out of .L900000914: 
! g1 g4 g5 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000912 .L900000914

			.L900000912:
/* 0x0d18	 474 */		sub	%o5,2,%o5
/* 0x0d1c	     */		add	%g5,2,%g5
/* 0x0d20	     */		ldub	[%o4],%o3
/* 0x0d24	     */		cmp	%o5,0
/* 0x0d28	     */		add	%o4,2,%o4
/* 0x0d2c	     */		stb	%o3,[%g5-2]
/* 0x0d30	     */		ldub	[%o4-1],%o0
/* 0x0d34	     */		bge	.L900000912
/* 0x0d38	     */		stb	%o0,[%g5-1]

! Registers live out of .L900000912: 
! g1 g4 g5 o0 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000912

			.L900000915:
/* 0x0d3c	 474 */		or	%g0,%o5,%o2
/* 0x0d40	     */		or	%g0,%g5,%g3
/* 0x0d44	     */		or	%g0,%o4,%o1
/* 0x0d48	     */		ba	.L900000755
/* 0x0d4c	     */		nop

! Registers live out of .L900000915: 
! g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000913

			.L900000754:
/* 0x0d50	 474 */		subcc	%o2,2,%o2

! Registers live out of .L900000754: 
! g1 g3 g4 g5 o1 o2 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000754 .L900000953

			.L900000953:
/* 0x0d54	 474 */		ldub	[%o1],%o3
/* 0x0d58	     */		stb	%o3,[%g3]
/* 0x0d5c	     */		ldub	[%o1+1],%o0
/* 0x0d60	     */		add	%o1,2,%o1
/* 0x0d64	     */		stb	%o0,[%g3+1]
/* 0x0d68	     */		add	%g3,2,%g3
/* 0x0d6c	     */		bge,a	.L900000953
/* 0x0d70	     */		subcc	%o2,2,%o2

! Registers live out of .L900000953: 
! g1 g3 g4 g5 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000753 .L900000915 .L900000953

			.L900000755:
/* 0x0d74	 474 */		cmp	%o2,-1
/* 0x0d78	     */		bl,a	.L900000951
/* 0x0d7c	 475 */		or	%g0,%l3,%o1

! Registers live out of .L900000755: 
! g3 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000755

			.L900000756:
/* 0x0d80	 474 */		ldub	[%o1],%o1
/* 0x0d84	     */		stb	%o1,[%g3]
/* 0x0d88	     */		ba	.L900000951
/* 0x0d8c	 475 */		or	%g0,%l3,%o1

! Registers live out of .L900000756: 
! o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000752

			.L900000757:
/* 0x0d90	 474 */		subcc	%o2,4,%g5
/* 0x0d94	     */		bl	.L900000760
/* 0x0d98	     */		sra	%o2,1,%o5

! Registers live out of .L900000757: 
! g1 g3 g4 g5 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000757

			.L900000885:
/* 0x0d9c	 474 */		srl	%o5,30,%o0
/* 0x0da0	     */		add	%o2,%o0,%g2
/* 0x0da4	     */		sra	%g2,2,%o7
/* 0x0da8	     */		cmp	%o7,1
/* 0x0dac	     */		bl	.L900000758
/* 0x0db0	     */		nop

! Registers live out of .L900000885: 
! g1 g3 g4 g5 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000885

			.L900000886:
/* 0x0db4	 474 */		or	%g0,%o1,%o5

! Registers live out of .L900000886: 
! g1 g3 g4 g5 o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000884 .L900000886

			.L900000884:
/* 0x0db8	 474 */		sub	%g5,4,%g5
/* 0x0dbc	     */		add	%g3,4,%g3
/* 0x0dc0	     */		ld	[%o5],%f6
/* 0x0dc4	     */		cmp	%g5,0
/* 0x0dc8	     */		add	%o5,4,%o5
/* 0x0dcc	     */		bge	.L900000884
/* 0x0dd0	     */		st	%f6,[%g3-4]

! Registers live out of .L900000884: 
! g1 g3 g4 g5 o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000884

			.L900000887:
/* 0x0dd4	 474 */		or	%g0,%o5,%o1
/* 0x0dd8	     */		ba	.L900000759
/* 0x0ddc	     */		nop

! Registers live out of .L900000887: 
! g3 g5 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000885

			.L900000758:
/* 0x0de0	 474 */		subcc	%g5,4,%g5

! Registers live out of .L900000758: 
! g1 g3 g4 g5 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000758 .L900000952

			.L900000952:
/* 0x0de4	 474 */		ld	[%o1],%f6
/* 0x0de8	     */		add	%o1,4,%o1
/* 0x0dec	     */		st	%f6,[%g3]
/* 0x0df0	     */		add	%g3,4,%g3
/* 0x0df4	     */		bge,a	.L900000952
/* 0x0df8	     */		subcc	%g5,4,%g5

! Registers live out of .L900000952: 
! g1 g3 g4 g5 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000887 .L900000952

			.L900000759:
/* 0x0dfc	 474 */		add	%g5,4,%o2

! Registers live out of .L900000759: 
! g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000757 .L900000759

			.L900000760:
/* 0x0e00	 474 */		andcc	%i1,3,%g0
/* 0x0e04	     */		be	.L900000766
/* 0x0e08	     */		subcc	%o2,1,%o2

! Registers live out of .L900000760: 
! g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000760

			.L900000761:
/* 0x0e0c	 474 */		ldub	[%o1],%o5
/* 0x0e10	     */		ble	.L900000766
/* 0x0e14	     */		stb	%o5,[%g3]

! Registers live out of .L900000761: 
! g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000761

			.L900000762:
/* 0x0e18	 474 */		ldub	[%o1+1],%g5
/* 0x0e1c	     */		subcc	%o2,1,%o2
/* 0x0e20	     */		ble	.L900000766
/* 0x0e24	     */		stb	%g5,[%g3+1]

! Registers live out of .L900000762: 
! g3 o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000762

			.L900000763:
/* 0x0e28	 474 */		ldub	[%o1+2],%i4
/* 0x0e2c	     */		stb	%i4,[%g3+2]
/* 0x0e30	     */		ba	.L900000951
/* 0x0e34	 475 */		or	%g0,%l3,%o1

! Registers live out of .L900000763: 
! o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002723

			.L900000764:
/* 0x0e38	 474 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0e3c	     */		add	%fp,-3200,%o0

! Registers live out of .L900000764: 
! o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  475		      !      MEMCPY( gtmp, g, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000760 .L900000761 .L900000762 .L900000764

			.L900000766:
/* 0x0e40	 475 */		or	%g0,%l3,%o1

! Registers live out of .L900000766: 
! o0 o1 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000755 .L900000756 .L900000763 .L900000766

			.L900000951:
/* 0x0e44	 475 */		or	%g0,%i1,%o2
/* 0x0e48	     */		cmp	%o2,32
/* 0x0e4c	     */		bg	.L900000748
/* 0x0e50	     */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000951: 
! g1 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000951

			.L900000736:
/* 0x0e54	 475 */		and	%o1,3,%o7
/* 0x0e58	     */		xor	%g1,-704,%g1
/* 0x0e5c	     */		orcc	%o7,0,%g0
/* 0x0e60	     */		add	%g1,%fp,%g1
/* 0x0e64	     */		be	.L900000741
/* 0x0e68	     */		or	%g0,%g1,%o7

! Registers live out of .L900000736: 
! g1 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000736

			.L900000737:
/* 0x0e6c	 475 */		subcc	%o2,2,%o2
/* 0x0e70	     */		bl	.L900000739
/* 0x0e74	     */		sub	%o2,-2,%g4

! Registers live out of .L900000737: 
! g1 g4 o0 o1 o2 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000737

			.L900000909:
/* 0x0e78	 475 */		srl	%g4,31,%o3
/* 0x0e7c	     */		add	%g4,%o3,%o5
/* 0x0e80	     */		sra	%o5,1,%o0
/* 0x0e84	     */		cmp	%o0,1
/* 0x0e88	     */		bl	.L900000738
/* 0x0e8c	     */		nop

! Registers live out of .L900000909: 
! g1 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000909

			.L900000910:
/* 0x0e90	 475 */		sethi	%hi(0x1000),%g1
/* 0x0e94	     */		xor	%g1,-704,%g1
/* 0x0e98	     */		add	%g1,%fp,%g1
/* 0x0e9c	     */		or	%g0,%o2,%o5
/* 0x0ea0	     */		or	%g0,%g1,%o4
/* 0x0ea4	     */		or	%g0,%o1,%o3

! Registers live out of .L900000910: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000908 .L900000910

			.L900000908:
/* 0x0ea8	 475 */		sub	%o5,2,%o5
/* 0x0eac	     */		add	%o4,2,%o4
/* 0x0eb0	     */		ldub	[%o3],%g3
/* 0x0eb4	     */		cmp	%o5,0
/* 0x0eb8	     */		add	%o3,2,%o3
/* 0x0ebc	     */		stb	%g3,[%o4-2]
/* 0x0ec0	     */		ldub	[%o3-1],%i4
/* 0x0ec4	     */		bge	.L900000908
/* 0x0ec8	     */		stb	%i4,[%o4-1]

! Registers live out of .L900000908: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000908

			.L900000911:
/* 0x0ecc	 475 */		or	%g0,%o5,%o2
/* 0x0ed0	     */		or	%g0,%o4,%o7
/* 0x0ed4	     */		or	%g0,%o3,%o1
/* 0x0ed8	     */		ba	.L900000739
/* 0x0edc	     */		nop

! Registers live out of .L900000911: 
! o0 o1 o2 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000909

			.L900000738:
/* 0x0ee0	 475 */		subcc	%o2,2,%o2

! Registers live out of .L900000738: 
! g1 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000738 .L900000950

			.L900000950:
/* 0x0ee4	 475 */		ldub	[%o1],%g3
/* 0x0ee8	     */		stb	%g3,[%o7]
/* 0x0eec	     */		ldub	[%o1+1],%i4
/* 0x0ef0	     */		add	%o1,2,%o1
/* 0x0ef4	     */		stb	%i4,[%o7+1]
/* 0x0ef8	     */		add	%o7,2,%o7
/* 0x0efc	     */		bge,a	.L900000950
/* 0x0f00	     */		subcc	%o2,2,%o2

! Registers live out of .L900000950: 
! g1 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000737 .L900000911 .L900000950

			.L900000739:
/* 0x0f04	 475 */		cmp	%o2,-1
/* 0x0f08	     */		bl,a	.L900000948
/* 0x0f0c	 476 */		or	%g0,%l5,%o1

! Registers live out of .L900000739: 
! o0 o1 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000739

			.L900000740:
/* 0x0f10	 475 */		ldub	[%o1],%o2
/* 0x0f14	     */		stb	%o2,[%o7]
/* 0x0f18	     */		ba	.L900000948
/* 0x0f1c	 476 */		or	%g0,%l5,%o1

! Registers live out of .L900000740: 
! o0 o1 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000736

			.L900000741:
/* 0x0f20	 475 */		subcc	%o2,4,%g2
/* 0x0f24	     */		bl	.L900000744
/* 0x0f28	     */		sra	%o2,1,%g5

! Registers live out of .L900000741: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000741

			.L900000889:
/* 0x0f2c	 475 */		srl	%g5,30,%o4
/* 0x0f30	     */		add	%o2,%o4,%o2
/* 0x0f34	     */		sra	%o2,2,%l3
/* 0x0f38	     */		cmp	%l3,1
/* 0x0f3c	     */		bl	.L900000742
/* 0x0f40	     */		nop

! Registers live out of .L900000889: 
! g1 g2 o0 o1 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000888 .L900000889

			.L900000888:
/* 0x0f44	 475 */		sub	%g2,4,%g2
/* 0x0f48	     */		add	%o7,4,%o7
/* 0x0f4c	     */		ld	[%o1],%f8
/* 0x0f50	     */		cmp	%g2,0
/* 0x0f54	     */		add	%o1,4,%o1
/* 0x0f58	     */		bge	.L900000888
/* 0x0f5c	     */		st	%f8,[%o7-4]

! Registers live out of .L900000888: 
! g1 g2 o0 o1 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000888

			.L900000891:
/* 0x0f60	 475 */		ba	.L900000743
/* 0x0f64	     */		nop

! Registers live out of .L900000891: 
! g2 o0 o1 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000889

			.L900000742:
/* 0x0f68	 475 */		subcc	%g2,4,%g2

! Registers live out of .L900000742: 
! g1 g2 o0 o1 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000742 .L900000949

			.L900000949:
/* 0x0f6c	 475 */		ld	[%o1],%f8
/* 0x0f70	     */		add	%o1,4,%o1
/* 0x0f74	     */		st	%f8,[%o7]
/* 0x0f78	     */		add	%o7,4,%o7
/* 0x0f7c	     */		bge,a	.L900000949
/* 0x0f80	     */		subcc	%g2,4,%g2

! Registers live out of .L900000949: 
! g1 g2 o0 o1 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000891 .L900000949

			.L900000743:
/* 0x0f84	 475 */		add	%g2,4,%o2

! Registers live out of .L900000743: 
! o0 o1 o2 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000741 .L900000743

			.L900000744:
/* 0x0f88	 475 */		andcc	%i1,3,%g0
/* 0x0f8c	     */		be	.L900000750
/* 0x0f90	     */		subcc	%o2,1,%o2

! Registers live out of .L900000744: 
! o0 o1 o2 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000744

			.L900000745:
/* 0x0f94	 475 */		ldub	[%o1],%g2
/* 0x0f98	     */		ble	.L900000750
/* 0x0f9c	     */		stb	%g2,[%o7]

! Registers live out of .L900000745: 
! o0 o1 o2 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000745

			.L900000746:
/* 0x0fa0	 475 */		ldub	[%o1+1],%g4
/* 0x0fa4	     */		subcc	%o2,1,%o2
/* 0x0fa8	     */		ble	.L900000750
/* 0x0fac	     */		stb	%g4,[%o7+1]

! Registers live out of .L900000746: 
! o0 o1 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000746

			.L900000747:
/* 0x0fb0	 475 */		ldub	[%o1+2],%l3
/* 0x0fb4	     */		stb	%l3,[%o7+2]
/* 0x0fb8	     */		ba	.L900000948
/* 0x0fbc	 476 */		or	%g0,%l5,%o1

! Registers live out of .L900000747: 
! o0 o1 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000951

			.L900000748:
/* 0x0fc0	 475 */		xor	%g1,-704,%g1
/* 0x0fc4	     */		add	%g1,%fp,%g1
/* 0x0fc8	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0fcc	     */		or	%g0,%g1,%o0

! Registers live out of .L900000748: 
! o0 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  476		      !      MEMCPY( btmp, b, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000744 .L900000745 .L900000746 .L900000748

			.L900000750:
/* 0x0fd0	 476 */		or	%g0,%l5,%o1

! Registers live out of .L900000750: 
! o0 o1 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000739 .L900000740 .L900000747 .L900000750

			.L900000948:
/* 0x0fd4	 476 */		or	%g0,%i1,%o2
/* 0x0fd8	     */		cmp	%o2,32
/* 0x0fdc	     */		bg	.L900000732
/* 0x0fe0	     */		sethi	%hi(0x1800),%g1

! Registers live out of .L900000948: 
! g1 o0 o1 o2 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000948

			.L900000720:
/* 0x0fe4	 476 */		and	%o1,3,%o0
/* 0x0fe8	     */		xor	%g1,-256,%g1
/* 0x0fec	     */		orcc	%o0,0,%g0
/* 0x0ff0	     */		add	%g1,%fp,%g1
/* 0x0ff4	     */		be	.L900000725
/* 0x0ff8	     */		or	%g0,%g1,%o0

! Registers live out of .L900000720: 
! g1 o0 o1 o2 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000720

			.L900000721:
/* 0x0ffc	 476 */		subcc	%o2,2,%o2
/* 0x1000	     */		bl	.L900000723
/* 0x1004	     */		sub	%o2,-2,%o3

! Registers live out of .L900000721: 
! g1 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000721

			.L900000905:
/* 0x1008	 476 */		srl	%o3,31,%g2
/* 0x100c	     */		add	%o3,%g2,%o7
/* 0x1010	     */		sra	%o7,1,%g3
/* 0x1014	     */		cmp	%g3,1
/* 0x1018	     */		bl	.L900000722
/* 0x101c	     */		nop

! Registers live out of .L900000905: 
! g1 o0 o1 o2 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000905

			.L900000906:
/* 0x1020	 476 */		sethi	%hi(0x1800),%g1
/* 0x1024	     */		xor	%g1,-256,%g1
/* 0x1028	     */		add	%g1,%fp,%g1
/* 0x102c	     */		or	%g0,%o2,%g2
/* 0x1030	     */		or	%g0,%g1,%l5

! Registers live out of .L900000906: 
! g1 g2 o1 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000904 .L900000906

			.L900000904:
/* 0x1034	 476 */		sub	%g2,2,%g2
/* 0x1038	     */		add	%l5,2,%l5
/* 0x103c	     */		ldub	[%o1],%o3
/* 0x1040	     */		cmp	%g2,0
/* 0x1044	     */		add	%o1,2,%o1
/* 0x1048	     */		stb	%o3,[%l5-2]
/* 0x104c	     */		ldub	[%o1-1],%o4
/* 0x1050	     */		bge	.L900000904
/* 0x1054	     */		stb	%o4,[%l5-1]

! Registers live out of .L900000904: 
! g1 g2 o1 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000904

			.L900000907:
/* 0x1058	 476 */		or	%g0,%g2,%o2
/* 0x105c	     */		or	%g0,%l5,%o0
/* 0x1060	     */		ba	.L900000723
/* 0x1064	     */		nop

! Registers live out of .L900000907: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000905

			.L900000722:
/* 0x1068	 476 */		subcc	%o2,2,%o2

! Registers live out of .L900000722: 
! g1 o0 o1 o2 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000722 .L900000947

			.L900000947:
/* 0x106c	 476 */		ldub	[%o1],%o3
/* 0x1070	     */		stb	%o3,[%o0]
/* 0x1074	     */		ldub	[%o1+1],%o4
/* 0x1078	     */		add	%o1,2,%o1
/* 0x107c	     */		stb	%o4,[%o0+1]
/* 0x1080	     */		add	%o0,2,%o0
/* 0x1084	     */		bge,a	.L900000947
/* 0x1088	     */		subcc	%o2,2,%o2

! Registers live out of .L900000947: 
! g1 o0 o1 o2 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000721 .L900000907 .L900000947

			.L900000723:
/* 0x108c	 476 */		cmp	%o2,-1
/* 0x1090	     */		bl,a	.L900000945
/* 0x1094	 477 */		ld	[%sp+104],%o1

! Registers live out of .L900000723: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000723

			.L900000724:
/* 0x1098	 476 */		ldub	[%o1],%o1
/* 0x109c	     */		stb	%o1,[%o0]
/* 0x10a0	     */		ba	.L900000945
/* 0x10a4	 477 */		ld	[%sp+104],%o1

! Registers live out of .L900000724: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000720

			.L900000725:
/* 0x10a8	 476 */		subcc	%o2,4,%l3
/* 0x10ac	     */		bl	.L900000728
/* 0x10b0	     */		sra	%o2,1,%o3

! Registers live out of .L900000725: 
! g1 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000725

			.L900000893:
/* 0x10b4	 476 */		srl	%o3,30,%g2
/* 0x10b8	     */		add	%o2,%g2,%g3
/* 0x10bc	     */		sra	%g3,2,%i4
/* 0x10c0	     */		cmp	%i4,1
/* 0x10c4	     */		bl	.L900000726
/* 0x10c8	     */		nop

! Registers live out of .L900000893: 
! g1 o0 o1 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000893

			.L900000894:
/* 0x10cc	 476 */		or	%g0,%o1,%g2

! Registers live out of .L900000894: 
! g1 g2 o0 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000892 .L900000894

			.L900000892:
/* 0x10d0	 476 */		sub	%l3,4,%l3
/* 0x10d4	     */		add	%o0,4,%o0
/* 0x10d8	     */		ld	[%g2],%f10
/* 0x10dc	     */		cmp	%l3,0
/* 0x10e0	     */		add	%g2,4,%g2
/* 0x10e4	     */		bge	.L900000892
/* 0x10e8	     */		st	%f10,[%o0-4]

! Registers live out of .L900000892: 
! g1 g2 o0 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000892

			.L900000895:
/* 0x10ec	 476 */		or	%g0,%g2,%o1
/* 0x10f0	     */		ba	.L900000727
/* 0x10f4	     */		nop

! Registers live out of .L900000895: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000893

			.L900000726:
/* 0x10f8	 476 */		subcc	%l3,4,%l3

! Registers live out of .L900000726: 
! g1 o0 o1 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000726 .L900000946

			.L900000946:
/* 0x10fc	 476 */		ld	[%o1],%f10
/* 0x1100	     */		add	%o1,4,%o1
/* 0x1104	     */		st	%f10,[%o0]
/* 0x1108	     */		add	%o0,4,%o0
/* 0x110c	     */		bge,a	.L900000946
/* 0x1110	     */		subcc	%l3,4,%l3

! Registers live out of .L900000946: 
! g1 o0 o1 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000895 .L900000946

			.L900000727:
/* 0x1114	 476 */		add	%l3,4,%o2

! Registers live out of .L900000727: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000725 .L900000727

			.L900000728:
/* 0x1118	 476 */		andcc	%i1,3,%g0
/* 0x111c	     */		be	.L900000734
/* 0x1120	     */		subcc	%o2,1,%o2

! Registers live out of .L900000728: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000728

			.L900000729:
/* 0x1124	 476 */		ldub	[%o1],%o5
/* 0x1128	     */		ble	.L900000734
/* 0x112c	     */		stb	%o5,[%o0]

! Registers live out of .L900000729: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000729

			.L900000730:
/* 0x1130	 476 */		ldub	[%o1+1],%g5
/* 0x1134	     */		subcc	%o2,1,%o2
/* 0x1138	     */		ble	.L900000734
/* 0x113c	     */		stb	%g5,[%o0+1]

! Registers live out of .L900000730: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000730

			.L900000731:
/* 0x1140	 476 */		ldub	[%o1+2],%l5
/* 0x1144	     */		stb	%l5,[%o0+2]
/* 0x1148	     */		ba	.L900000945
/* 0x114c	 477 */		ld	[%sp+104],%o1

! Registers live out of .L900000731: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000948

			.L900000732:
/* 0x1150	 476 */		xor	%g1,-256,%g1
/* 0x1154	     */		add	%g1,%fp,%g1
/* 0x1158	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x115c	     */		or	%g0,%g1,%o0

! Registers live out of .L900000732: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  477		      !      MEMCPY( atmp, a, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900000728 .L900000729 .L900000730 .L900000732

			.L900000734:
/* 0x1160	 477 */		ld	[%sp+104],%o1

! Registers live out of .L900000734: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000723 .L900000724 .L900000731 .L900000734

			.L900000945:
/* 0x1164	 477 */		or	%g0,%i1,%o2
/* 0x1168	     */		cmp	%o2,32
/* 0x116c	     */		bg	.L900000716
/* 0x1170	     */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900000945: 
! g1 o0 o1 o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000945

			.L900000704:
/* 0x1174	 477 */		and	%o1,3,%l5
/* 0x1178	     */		xor	%g1,-832,%g1
/* 0x117c	     */		orcc	%l5,0,%g0
/* 0x1180	     */		add	%g1,%fp,%g1
/* 0x1184	     */		be	.L900000709
/* 0x1188	     */		or	%g0,%g1,%o3

! Registers live out of .L900000704: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000704

			.L900000705:
/* 0x118c	 477 */		subcc	%o2,2,%o2
/* 0x1190	     */		bl	.L900000707
/* 0x1194	     */		sub	%o2,-2,%o0

! Registers live out of .L900000705: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000705

			.L900000901:
/* 0x1198	 477 */		srl	%o0,31,%g5
/* 0x119c	     */		add	%o0,%g5,%o4
/* 0x11a0	     */		sra	%o4,1,%g4
/* 0x11a4	     */		cmp	%g4,1
/* 0x11a8	     */		bl	.L900000706
/* 0x11ac	     */		nop

! Registers live out of .L900000901: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000901

			.L900000902:
/* 0x11b0	 477 */		sethi	%hi(0x1c00),%g1
/* 0x11b4	     */		xor	%g1,-832,%g1
/* 0x11b8	     */		or	%g0,%o2,%o4
/* 0x11bc	     */		add	%g1,%fp,%o5
/* 0x11c0	     */		or	%g0,%o1,%g3

! Registers live out of .L900000902: 
! g3 o0 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000900 .L900000902

			.L900000900:
/* 0x11c4	 477 */		sub	%o4,2,%o4
/* 0x11c8	     */		add	%o5,2,%o5
/* 0x11cc	     */		ldub	[%g3],%i4
/* 0x11d0	     */		cmp	%o4,0
/* 0x11d4	     */		add	%g3,2,%g3
/* 0x11d8	     */		stb	%i4,[%o5-2]
/* 0x11dc	     */		ldub	[%g3-1],%o7
/* 0x11e0	     */		bge	.L900000900
/* 0x11e4	     */		stb	%o7,[%o5-1]

! Registers live out of .L900000900: 
! g3 o0 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000900

			.L900000903:
/* 0x11e8	 477 */		or	%g0,%o4,%o2
/* 0x11ec	     */		or	%g0,%o5,%o3
/* 0x11f0	     */		or	%g0,%g3,%o1
/* 0x11f4	     */		ba	.L900000707
/* 0x11f8	     */		nop

! Registers live out of .L900000903: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000901

			.L900000706:
/* 0x11fc	 477 */		subcc	%o2,2,%o2

! Registers live out of .L900000706: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000706 .L900000944

			.L900000944:
/* 0x1200	 477 */		ldub	[%o1],%i4
/* 0x1204	     */		stb	%i4,[%o3]
/* 0x1208	     */		ldub	[%o1+1],%o7
/* 0x120c	     */		add	%o1,2,%o1
/* 0x1210	     */		stb	%o7,[%o3+1]
/* 0x1214	     */		add	%o3,2,%o3
/* 0x1218	     */		bge,a	.L900000944
/* 0x121c	     */		subcc	%o2,2,%o2

! Registers live out of .L900000944: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000705 .L900000903 .L900000944

			.L900000707:
/* 0x1220	 477 */		cmp	%o2,-1
/* 0x1224	     */		bl,a	.L900000942
/* 0x1228	 478 */		or	%g0,1029,%o1

! Registers live out of .L900000707: 
! o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000707

			.L900000708:
/* 0x122c	 477 */		ldub	[%o1],%o2
/* 0x1230	     */		stb	%o2,[%o3]
/* 0x1234	     */		ba	.L900000942

!  478		      !      (*ctx->Driver.SetBuffer)( ctx, GL_BACK );

/* 0x1238	 478 */		or	%g0,1029,%o1

! Registers live out of .L900000708: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000704

			.L900000709:
/* 0x123c	 477 */		subcc	%o2,4,%g3
/* 0x1240	     */		bl	.L900000712
/* 0x1244	     */		or	%g0,%o2,%o5

! Registers live out of .L900000709: 
! g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000709

			.L900000897:
/* 0x1248	 477 */		sra	%o2,1,%o2
/* 0x124c	     */		srl	%o2,30,%l3
/* 0x1250	     */		add	%o5,%l3,%o0
/* 0x1254	     */		sra	%o0,2,%l5
/* 0x1258	     */		cmp	%l5,1
/* 0x125c	     */		bl	.L900000710
/* 0x1260	     */		nop

! Registers live out of .L900000897: 
! g3 o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000897

			.L900000898:
/* 0x1264	 477 */		or	%g0,%o1,%o2

! Registers live out of .L900000898: 
! g3 o0 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000896 .L900000898

			.L900000896:
/* 0x1268	 477 */		sub	%g3,4,%g3
/* 0x126c	     */		add	%o3,4,%o3
/* 0x1270	     */		ld	[%o2],%f12
/* 0x1274	     */		cmp	%g3,0
/* 0x1278	     */		add	%o2,4,%o2
/* 0x127c	     */		bge	.L900000896
/* 0x1280	     */		st	%f12,[%o3-4]

! Registers live out of .L900000896: 
! g3 o0 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000896

			.L900000899:
/* 0x1284	 477 */		or	%g0,%o2,%o1
/* 0x1288	     */		ba	.L900000711
/* 0x128c	     */		nop

! Registers live out of .L900000899: 
! g3 o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000897

			.L900000710:
/* 0x1290	 477 */		subcc	%g3,4,%g3

! Registers live out of .L900000710: 
! g3 o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000710 .L900000943

			.L900000943:
/* 0x1294	 477 */		ld	[%o1],%f12
/* 0x1298	     */		add	%o1,4,%o1
/* 0x129c	     */		st	%f12,[%o3]
/* 0x12a0	     */		add	%o3,4,%o3
/* 0x12a4	     */		bge,a	.L900000943
/* 0x12a8	     */		subcc	%g3,4,%g3

! Registers live out of .L900000943: 
! g3 o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000899 .L900000943

			.L900000711:
/* 0x12ac	 477 */		add	%g3,4,%o2

! Registers live out of .L900000711: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000709 .L900000711

			.L900000712:
/* 0x12b0	 477 */		andcc	%i1,3,%g0
/* 0x12b4	     */		be	.L900000718
/* 0x12b8	     */		subcc	%o2,1,%o2

! Registers live out of .L900000712: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000712

			.L900000713:
/* 0x12bc	 477 */		ldub	[%o1],%g3
/* 0x12c0	     */		ble	.L900000718
/* 0x12c4	     */		stb	%g3,[%o3]

! Registers live out of .L900000713: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000713

			.L900000714:
/* 0x12c8	 477 */		ldub	[%o1+1],%g2
/* 0x12cc	     */		subcc	%o2,1,%o2
/* 0x12d0	     */		ble	.L900000718
/* 0x12d4	     */		stb	%g2,[%o3+1]

! Registers live out of .L900000714: 
! o0 o1 o3 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000714

			.L900000715:
/* 0x12d8	 477 */		ldub	[%o1+2],%g4
/* 0x12dc	     */		stb	%g4,[%o3+2]
/* 0x12e0	     */		ba	.L900000942
/* 0x12e4	 478 */		or	%g0,1029,%o1

! Registers live out of .L900000715: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000945

			.L900000716:
/* 0x12e8	 477 */		xor	%g1,-832,%g1
/* 0x12ec	     */		add	%g1,%fp,%g1
/* 0x12f0	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x12f4	     */		or	%g0,%g1,%o0

! Registers live out of .L900000716: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000712 .L900000713 .L900000714 .L900000716

			.L900000718:
/* 0x12f8	 478 */		or	%g0,1029,%o1

! Registers live out of .L900000718: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000707 .L900000708 .L900000715 .L900000718

			.L900000942:
/* 0x12fc	 478 */		ld	[%i0+2236],%l3
/* 0x1300	     */		jmpl	%l3,%o7
/* 0x1304	     */		or	%g0,%i0,%o0

!  479		      !      if (ctx->Color.SWLogicOpEnabled) {

/* 0x1308	 479 */		ldub	[%i0+%l7],%l7
/* 0x130c	     */		cmp	%l7,0
/* 0x1310	     */		be,pn	%icc,.L77002727
/* 0x1314	 480 */		add	%fp,-1600,%g4

! Registers live out of .L900000942: 
! g4 o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  480		      !         gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L900000942

			.L77002725:
/* 0x1318	 480 */		srl	%g4,0,%o7
/* 0x131c	     */		sllx	%l2,32,%g4
/* 0x1320	     */		or	%g4,%o7,%g5
/* 0x1324	     */		or	%g0,%l0,%o5
/* 0x1328	     */		or	%g0,%l1,%o4
/* 0x132c	     */		or	%g0,%i3,%o3
/* 0x1330	     */		or	%g0,%i2,%o2
/* 0x1334	     */		stx	%g5,[%sp+96]
/* 0x1338	     */		or	%g0,%i1,%o1
/* 0x133c	     */		st	%i5,[%sp+92]
/* 0x1340	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x1344	     */		or	%g0,%i0,%o0
/* 0x1348	     */		ba	.L900000941
/* 0x134c	 485 */		ldub	[%i0+%l4],%l4

! Registers live out of .L77002725: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  481		      !      }
!  482		      !      else  if (ctx->Color.BlendEnabled) {

                       
! predecessor blocks: .L900000942

			.L77002727:
/* 0x1350	 482 */		sethi	%hi(0x1c00),%o7
/* 0x1354	     */		add	%o7,685,%o4
/* 0x1358	     */		ldub	[%i0+%o4],%g3
/* 0x135c	     */		cmp	%g3,0
/* 0x1360	     */		be,pn	%icc,.L77002733
/* 0x1364	 483 */		add	%fp,-1600,%o0

! Registers live out of .L77002727: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  483		      !         gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77002727

			.L77002729:
/* 0x1368	 483 */		srl	%o0,0,%o3
/* 0x136c	     */		sllx	%l2,32,%o0
/* 0x1370	     */		or	%o0,%o3,%o7
/* 0x1374	     */		or	%g0,%l0,%o5
/* 0x1378	     */		or	%g0,%l1,%o4
/* 0x137c	     */		or	%g0,%i3,%o3
/* 0x1380	     */		or	%g0,%i2,%o2
/* 0x1384	     */		stx	%o7,[%sp+96]
/* 0x1388	     */		or	%g0,%i1,%o1
/* 0x138c	     */		st	%i5,[%sp+92]
/* 0x1390	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x1394	     */		or	%g0,%i0,%o0

! Registers live out of .L77002729: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  484		      !      }
!  485		      !      if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77002727 .L77002729

			.L77002733:
/* 0x1398	 485 */		ldub	[%i0+%l4],%l4

! Registers live out of .L77002733: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002725 .L77002733

			.L900000941:
/* 0x139c	 485 */		cmp	%l4,0
/* 0x13a0	     */		be,pn	%icc,.L77002737
/* 0x13a4	 486 */		or	%g0,%l0,%o5

! Registers live out of .L900000941: 
! o0 o5 sp l0 l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  486		      !         gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );

                       
! predecessor blocks: .L900000941

			.L77002735:
/* 0x13a8	 486 */		or	%g0,%l1,%o4
/* 0x13ac	     */		or	%g0,%i3,%o3
/* 0x13b0	     */		or	%g0,%i2,%o2
/* 0x13b4	     */		st	%i5,[%sp+92]
/* 0x13b8	     */		or	%g0,%i1,%o1
/* 0x13bc	     */		st	%l2,[%sp+96]
/* 0x13c0	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x13c4	     */		or	%g0,%i0,%o0

! Registers live out of .L77002735: 
! o0 sp l0 l1 l2 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  487		      !      }
!  488		      !      (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  489		      !                              write_all ? NULL : mask );

                       
! predecessor blocks: .L77002735 .L900000941

			.L77002737:
/* 0x13c8	 489 */		cmp	%l6,0
/* 0x13cc	     */		be,pn	%icc,.L77002741
/* 0x13d0	     */		or	%g0,%l1,%o4

! Registers live out of .L77002737: 
! o0 o4 sp l0 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002737

			.L77002739:
/* 0x13d4	 489 */		or	%g0,%l0,%o5
/* 0x13d8	     */		sllx	%l2,32,%g2
/* 0x13dc	     */		or	%g0,%i3,%o3
/* 0x13e0	     */		or	%g0,%i2,%o2
/* 0x13e4	     */		ld	[%i0+2244],%l0
/* 0x13e8	     */		or	%g0,%i1,%o1
/* 0x13ec	     */		stx	%g2,[%sp+96]
/* 0x13f0	     */		st	%i5,[%sp+92]
/* 0x13f4	     */		jmpl	%l0,%o7
/* 0x13f8	     */		or	%g0,%i0,%o0

!  490		      !      if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x13fc	 490 */		sethi	%hi(0xe000),%o1
/* 0x1400	     */		add	%o1,264,%o3
/* 0x1404	     */		ld	[%i0+%o3],%l1
/* 0x1408	     */		andcc	%l1,256,%g0
/* 0x140c	     */		be,pn	%icc,.L77002753

!  491		      !         ctx->Buffer->Alpha = ctx->Buffer->BackAlpha;
!  492		      !         gl_write_alpha_span( ctx, n, x, y, alpha, write_all ? NULL : mask );

/* 0x1410	 492 */		or	%g0,0,%o5

! Registers live out of .L77002739: 
! o0 o5 sp l2 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002739

			.L77002745:
/* 0x1414	 491 */		ld	[%i0+2204],%o1
/* 0x1418	     */		ld	[%o1+28],%i4
/* 0x141c	     */		st	%i4,[%o1+32]
/* 0x1420	 492 */		ba	.L900000940
/* 0x1424	     */		or	%g0,%l2,%o4

! Registers live out of .L77002745: 
! o0 o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002737

			.L77002741:
/* 0x1428	 489 */		add	%fp,-1600,%o5
/* 0x142c	     */		srl	%o5,0,%o3
/* 0x1430	     */		sllx	%l2,32,%o0
/* 0x1434	     */		or	%o0,%o3,%g4
/* 0x1438	     */		or	%g0,%l0,%o5
/* 0x143c	     */		or	%g0,%i3,%o3
/* 0x1440	     */		or	%g0,%i2,%o2
/* 0x1444	     */		ld	[%i0+2244],%o7
/* 0x1448	     */		or	%g0,%i1,%o1
/* 0x144c	     */		stx	%g4,[%sp+96]
/* 0x1450	     */		st	%i5,[%sp+92]
/* 0x1454	     */		jmpl	%o7,%o7
/* 0x1458	     */		or	%g0,%i0,%o0
/* 0x145c	 490 */		sethi	%hi(0xe000),%g3
/* 0x1460	     */		add	%g3,264,%i4
/* 0x1464	     */		ld	[%i0+%i4],%l7
/* 0x1468	     */		andcc	%l7,256,%g0
/* 0x146c	     */		be,pn	%icc,.L77002753
/* 0x1470	 492 */		add	%fp,-1600,%o5

! Registers live out of .L77002741: 
! o0 o5 sp l2 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002741

			.L77002854:
/* 0x1474	 491 */		ld	[%i0+2204],%i5
/* 0x1478	 492 */		or	%g0,%l2,%o4
/* 0x147c	 491 */		ld	[%i5+28],%l6
/* 0x1480	     */		st	%l6,[%i5+32]

! Registers live out of .L77002854: 
! o0 o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002745 .L77002854

			.L900000940:
/* 0x1484	 492 */		or	%g0,%i3,%o3
/* 0x1488	     */		or	%g0,%i2,%o2
/* 0x148c	     */		or	%g0,%i1,%o1
/* 0x1490	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x1494	     */		or	%g0,%i0,%o0

!  493		      !         ctx->Buffer->Alpha = ctx->Buffer->FrontAlpha;

/* 0x1498	 493 */		ld	[%i0+2204],%i2
/* 0x149c	     */		ld	[%i2+24],%i3
/* 0x14a0	     */		st	%i3,[%i2+32]

! Registers live out of .L900000940: 
! o0 sp i0 fp i7 gsr 
! 
		
!  494		      !      }
!  495		      !      (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );

                       
! predecessor blocks: .L77002739 .L77002741 .L900000940

			.L77002753:
/* 0x14a4	 495 */		or	%g0,1028,%o1
/* 0x14a8	     */		ld	[%i0+2236],%i1
/* 0x14ac	     */		jmpl	%i1,%o7
/* 0x14b0	     */		or	%g0,%i0,%o0

! Registers live out of .L77002753: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002611 .L77002645 .L77002659 .L77002667 .L77002675 .L77002721 .L77002753 .L77002760 .L77002772 .L77002776
! predecessor blocks: .L900000956

			.L77002756:
/* 0x14b4	 375 */		ret	! Result = 
/* 0x14b8	     */		restore	%g0,0,%g0
/* 0x14bc	   0 */		.type	gl_write_color_span,2
/* 0x14bc	   0 */		.size	gl_write_color_span,(.-gl_write_color_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  496		      !   }
!  498		      !}
!  502		      !/*
!  503		      ! * Write a horizontal span of color pixels to the frame buffer.
!  504		      ! * The color is initially constant for the whole span.
!  505		      ! * Alpha-testing, stenciling, depth-testing, and blending are done as needed.
!  506		      ! * Input:  n - number of pixels in the span
!  507		      ! *         x, y - location of leftmost pixel in the span
!  508		      ! *         z - array of [n] z-values
!  509		      ! *         r, g, b, a - the color of the pixels
!  510		      ! *         primitive - either GL_POINT, GL_LINE, GL_POLYGON or GL_BITMAP.
!  511		      ! */
!  512		      !void gl_write_monocolor_span( GLcontext *ctx,
!  513		      !                              GLuint n, GLint x, GLint y, GLdepth z[],
!  514		      !			      GLint r, GLint g, GLint b, GLint a,
!  515		      !                              GLenum primitive )
!  516		      !{

!
! SUBROUTINE gl_write_monocolor_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_monocolor_span
                       

			gl_write_monocolor_span:
/* 000000	 516 */		sethi	%hi(0x2400),%g1
/* 0x0004	     */		xor	%g1,-664,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  517		      !   GLuint i;
!  518		      !   GLubyte mask[MAX_WIDTH];
!  519		      !   GLboolean write_all = GL_TRUE;
!  520		      !   GLubyte red[MAX_WIDTH], green[MAX_WIDTH], blue[MAX_WIDTH], alpha[MAX_WIDTH];
!  522		      !   /* init mask to 1's (all pixels are to be written) */
!  523		      !   MEMSET(mask, 1, n);

/* 0x000c	 523 */		or	%g0,%i1,%o2
/* 0x0010	     */		cmp	%o2,32
/* 0x0014	   0 */		add	%fp,-1600,%l3
/* 0x0018	 516 */		ld	[%fp+104],%l1
/* 0x001c	 523 */		ble	.L900001005
/* 0x0020	     */		or	%g0,1,%o1

! Registers live out of gl_write_monocolor_span: 
! g4 o0 o1 o2 o3 o5 sp o7 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_monocolor_span

			.L900001004:
/* 0x0024	 523 */		call	memset	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0028	     */		add	%fp,-1600,%o0
/* 0x002c	     */		ba	.L900001121
/* 0x0030	 525 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001004: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_monocolor_span

			.L900001005:
/* 0x0034	 523 */		sethi	%hi(0x1010000),%g5
/* 0x0038	     */		add	%fp,-1600,%l0
/* 0x003c	     */		add	%g5,257,%o4
/* 0x0040	     */		cmp	%o2,3

! Registers live out of .L900001005: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001005 .L900001008

			.L900001122:
/* 0x0044	 523 */		bleu	.L900001010
/* 0x0048	     */		nop

! Registers live out of .L900001122: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001122

			.L900001008:
/* 0x004c	 523 */		sub	%o2,4,%o2
/* 0x0050	     */		st	%o4,[%l0]
/* 0x0054	     */		add	%l0,4,%l0
/* 0x0058	     */		ba	.L900001122
/* 0x005c	     */		cmp	%o2,3

! Registers live out of .L900001008: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001122

			.L900001010:
/* 0x0060	 523 */		andcc	%o2,3,%g0
/* 0x0064	     */		be	.L900001014
/* 0x0068	     */		cmp	%o2,0

! Registers live out of .L900001010: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001010

			.L900001088:
/* 0x006c	 523 */		bl,a	.L900001120
/* 0x0070	     */		subcc	%o2,1,%o2

! Registers live out of .L900001088: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001088

			.L900001091:
/* 0x0074	 523 */		cmp	%o2,2
/* 0x0078	     */		bl	.L900001087
/* 0x007c	     */		nop

! Registers live out of .L900001091: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001091

			.L900001092:
/* 0x0080	 523 */		or	%g0,%o2,%o7

! Registers live out of .L900001092: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001090 .L900001092

			.L900001090:
/* 0x0084	 523 */		stb	%o1,[%l0]
/* 0x0088	     */		sub	%o7,2,%o7
/* 0x008c	     */		add	%l0,2,%l0
/* 0x0090	     */		cmp	%o7,1
/* 0x0094	     */		bg	.L900001090
/* 0x0098	     */		stb	%o1,[%l0-1]

! Registers live out of .L900001090: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001090

			.L900001093:
/* 0x009c	 523 */		cmp	%o7,0
/* 0x00a0	     */		ble	.L900001089
/* 0x00a4	     */		nop

! Registers live out of .L900001093: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001091 .L900001093

			.L900001087:
/* 0x00a8	 523 */		stb	%o1,[%l0]

! Registers live out of .L900001087: 
! g4 o2 o3 o4 o5 sp l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001087 .L900001093

			.L900001089:
/* 0x00ac	 523 */		ba	.L900001121
/* 0x00b0	 525 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001089: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001012 .L900001088

			.L900001120:
/* 0x00b4	 523 */		be	.L900001014
/* 0x00b8	     */		stb	%o1,[%l0]

! Registers live out of .L900001120: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001120

			.L900001012:
/* 0x00bc	 523 */		add	%l0,1,%l0
/* 0x00c0	     */		subcc	%o2,1,%o2
/* 0x00c4	     */		stb	%o1,[%l0]
/* 0x00c8	     */		add	%l0,1,%l0
/* 0x00cc	     */		bne	.L900001120
/* 0x00d0	     */		subcc	%o2,1,%o2

! Registers live out of .L900001012: 
! g4 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  525		      !   if ((ctx->RasterMask & WINCLIP_BIT) || primitive==GL_BITMAP) {

                       
! predecessor blocks: .L900001010 .L900001012 .L900001120

			.L900001014:
/* 0x00d4	 525 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001014: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001004 .L900001014 .L900001089

			.L900001121:
/* 0x00d8	 525 */		add	%l7,264,%l7
/* 0x00dc	     */		ld	[%i0+%l7],%l4
/* 0x00e0	     */		andcc	%l4,512,%g0
/* 0x00e4	     */		bne,pn	%icc,.L77002976
/* 0x00e8	     */		sethi	%hi(0x1800),%l0

! Registers live out of .L900001121: 
! g4 o2 o3 o4 o5 sp l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001121

			.L77002972:
/* 0x00ec	 525 */		add	%l0,512,%o5
/* 0x00f0	     */		cmp	%l1,%o5
/* 0x00f4	     */		bne,pt	%icc,.L77002982
/* 0x00f8	 519 */		or	%g0,1,%l2

! Registers live out of .L77002972: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002972 .L900001121

			.L77002976:
/* 0x00fc	 128 */		cmp	%i3,0
/* 0x0100	     */		bl,pn	%icc,.L77003163
/* 0x0104	     */		nop

! Registers live out of .L77002976: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002976

			.L77003170:
/* 0x0108	 128 */		ld	[%i0+2204],%l5
/* 0x010c	     */		ld	[%l5+8],%l6
/* 0x0110	     */		cmp	%i3,%l6
/* 0x0114	     */		bge,pn	%icc,.L77003163
/* 0x0118	 133 */		cmp	%i2,0

! Registers live out of .L77003170: 
! g4 o2 o3 o4 o5 sp l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003170

			.L77003176:
/* 0x011c	 133 */		bl,pn	%icc,.L77003182
/* 0x0120	     */		add	%i2,%i1,%o7

! Registers live out of .L77003176: 
! g4 o2 o3 o4 o5 sp o7 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003176

			.L77003178:
/* 0x0124	 133 */		ld	[%l5+4],%g4
/* 0x0128	     */		cmp	%o7,%g4
/* 0x012c	     */		ble,a,pn	%icc,.L77002982
/* 0x0130	 529 */		or	%g0,0,%l2

! Registers live out of .L77003178: 
! g4 o2 o3 o4 o5 sp o7 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003176 .L77003178

			.L77003182:
/* 0x0134	 137 */		cmp	%o7,0
/* 0x0138	     */		ble,pn	%icc,.L77003163
/* 0x013c	     */		nop

! Registers live out of .L77003182: 
! g4 o2 o3 o4 o5 sp l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003182

			.L77003186:
/* 0x0140	 141 */		ld	[%l5+4],%g2
/* 0x0144	     */		cmp	%i2,%g2
/* 0x0148	     */		bge,pn	%icc,.L77003163
/* 0x014c	 147 */		cmp	%i1,0

! Registers live out of .L77003186: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003186

			.L77003299:
/* 0x0150	 147 */		ble,a,pn	%icc,.L77002982
/* 0x0154	 529 */		or	%g0,0,%l2

! Registers live out of .L77003299: 
! g4 o2 o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003299

			.L77003349:
/* 0x0158	 147 */		or	%g0,0,%g3
/* 0x015c	     */		add	%i1,-1,%g5

!  526		      !      if (clip_span( ctx,n,x,y,mask)==0) {

/* 0x0160	 526 */		or	%g0,%i2,%l4
/* 0x0164	     */		add	%fp,-1600,%o0
/* 0x0168	 148 */		cmp	%i2,0

! Registers live out of .L77003349: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003349 .L900001119

			.L900001118:
/* 0x016c	 148 */		bl,a,pn	%icc,.L77003202
/* 0x0170	 149 */		stb	%g0,[%o0]

! Registers live out of .L900001118: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001118

			.L77003196:
/* 0x0174	 148 */		ld	[%i0+2204],%l0
/* 0x0178	     */		ld	[%l0+4],%o4
/* 0x017c	     */		cmp	%l4,%o4
/* 0x0180	     */		bl,a,pt	%icc,.L900001119
/* 0x0184	 147 */		add	%g3,1,%g3

! Registers live out of .L77003196: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003196

			.L77003200:
/* 0x0188	 149 */		stb	%g0,[%o0]

! Registers live out of .L77003200: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003200 .L900001118

			.L77003202:
/* 0x018c	 147 */		add	%g3,1,%g3

! Registers live out of .L77003202: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003196 .L77003202

			.L900001119:
/* 0x0190	 147 */		cmp	%g3,%g5
/* 0x0194	     */		add	%l4,1,%l4
/* 0x0198	     */		add	%o0,1,%o0
/* 0x019c	     */		ble,pt	%icc,.L900001118
/* 0x01a0	 148 */		cmp	%l4,0

! Registers live out of .L900001119: 
! g3 g4 g5 o0 o2 o3 o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  527		      !	 return;
!  528		      !      }
!  529		      !      write_all = GL_FALSE;

                       
! predecessor blocks: .L900001119

			.L77002980:
/* 0x01a4	 529 */		or	%g0,0,%l2

! Registers live out of .L77002980: 
! g4 o2 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002972 .L77002980 .L77003178 .L77003299

			.L77002982:
/* 0x01a8	   0 */		sethi	%hi(0xd400),%l0

!  530		      !   }
!  532		      !   /* Do the scissor test */
!  533		      !   if (ctx->Scissor.Enabled) {

/* 0x01ac	 533 */		add	%l0,840,%o1
/* 0x01b0	     */		ldub	[%i0+%o1],%o7
/* 0x01b4	     */		cmp	%o7,0
/* 0x01b8	     */		be,pn	%icc,.L77002990
/* 0x01bc	 534 */		or	%g0,%i3,%o3

! Registers live out of .L77002982: 
! g4 o2 o3 o4 o5 sp l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  534		      !      if (gl_scissor_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L77002982

			.L77002984:
/* 0x01c0	 534 */		or	%g0,%i2,%o2
/* 0x01c4	     */		or	%g0,%i1,%o1
/* 0x01c8	     */		or	%g0,%i0,%o0
/* 0x01cc	     */		call	gl_scissor_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x01d0	     */		add	%fp,-1600,%o4
/* 0x01d4	     */		orcc	%g0,%o0,%g0
/* 0x01d8	     */		be,pn	%icc,.L77003163

!  535		      !	 return;
!  536		      !      }
!  537		      !      write_all = GL_FALSE;

/* 0x01dc	 537 */		or	%g0,0,%l2

! Registers live out of .L77002984: 
! g4 o2 o4 o5 sp l0 l1 l2 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  538		      !   }
!  540		      !   /* Polygon Stippling */
!  541		      !   if (ctx->Polygon.StippleFlag && primitive==GL_POLYGON) {

                       
! predecessor blocks: .L77002982 .L77002984

			.L77002990:
/* 0x01e0	 541 */		add	%l0,697,%l4
/* 0x01e4	     */		ldub	[%i0+%l4],%l6
/* 0x01e8	     */		cmp	%l6,0
/* 0x01ec	     */		be,pn	%icc,.L77002996
/* 0x01f0	   0 */		sethi	%hi(0x1c00),%l4

! Registers live out of .L77002990: 
! g4 o2 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002990

			.L77002992:
/* 0x01f4	 541 */		cmp	%l1,9
/* 0x01f8	     */		bne,pn	%icc,.L77002996
/* 0x01fc	 104 */		cmp	%i1,0

! Registers live out of .L77002992: 
! g4 o2 o4 o5 sp l0 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002992

			.L77002994:
/* 0x0200	 104 */		bleu,pn	%icc,.L77003322
/* 0x0204	 101 */		cmp	%i1,2

! Registers live out of .L77002994: 
! g4 o2 o4 o5 sp l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002994

			.L77003235:
/* 0x0208	 101 */		sra	%i3,31,%l2
/* 0x020c	     */		and	%l2,31,%o7
/* 0x0210	     */		add	%i3,%o7,%o5
/* 0x0214	     */		andn	%o5,31,%l1
/* 0x0218	 102 */		sra	%i2,31,%o2
/* 0x021c	 101 */		sub	%i3,%l1,%o4
/* 0x0220	 102 */		and	%o2,31,%o1
/* 0x0224	 101 */		sll	%o4,2,%o3
/* 0x0228	 102 */		add	%i2,%o1,%o0
/* 0x022c	 101 */		add	%i0,%o3,%l5
/* 0x0230	     */		add	%l0,712,%g2
/* 0x0234	 102 */		andn	%o0,31,%g5
/* 0x0238	     */		sub	%i2,%g5,%g3
/* 0x023c	   0 */		sethi	%hi(0x80000000),%o3
/* 0x0240	 101 */		ld	[%l5+%g2],%o2
/* 0x0244	     */		bl,pn	%icc,.L77003392
/* 0x0248	 102 */		srl	%o3,%g3,%o1

! Registers live out of .L77003235: 
! g4 o1 o2 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003235

			.L77003276:
/* 0x024c	 104 */		sethi	%hi(0x7ffffc00),%o7
/* 0x0250	     */		add	%o7,1022,%g5
/* 0x0254	     */		srl	%i1,0,%g3
/* 0x0258	     */		sub	%g3,%g5,%o5
/* 0x025c	     */		srlx	%o5,63,%l1
/* 0x0260	     */		andcc	%l1,1,%g0
/* 0x0264	     */		bne,pn	%icc,.L77003294
/* 0x0268	     */		or	%g0,0,%o4

! Registers live out of .L77003276: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003276

			.L77003402:
/* 0x026c	 104 */		ba	.L900001114
/* 0x0270	 105 */		andcc	%o1,%o2,%g0

! Registers live out of .L77003402: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  542		      !      stipple_polygon_span( ctx, n, x, y, mask );
!  543		      !      write_all = GL_FALSE;

                       
! predecessor blocks: .L77003276

			.L77003294:
/* 0x0274	 543 */		add	%i1,-1,%o5
/* 0x0278	     */		or	%g0,0,%l1
/* 0x027c	 105 */		andcc	%o1,%o2,%g0

! Registers live out of .L77003294: 
! o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003219 .L77003294

			.L900001116:
/* 0x0280	 105 */		bne,pn	%icc,.L77003219
/* 0x0284	 108 */		srl	%o1,1,%o1

! Registers live out of .L900001116: 
! o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001116

			.L77003217:
/* 0x0288	 106 */		stb	%g0,[%l1+%l3]

! Registers live out of .L77003217: 
! o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003217 .L900001116

			.L77003219:
/* 0x028c	 109 */		cmp	%o1,0
/* 0x0290	   0 */		move	%icc,%o3,%o1
/* 0x0294	 104 */		add	%l1,1,%l1
/* 0x0298	     */		cmp	%l1,%o5
/* 0x029c	     */		ble,pt	%icc,.L900001116
/* 0x02a0	 105 */		andcc	%o1,%o2,%g0

! Registers live out of .L77003219: 
! o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  544		      !   }
!  546		      !   /* Do the alpha test */
!  547		      !   if (ctx->Color.AlphaEnabled) {

                       
! predecessor blocks: .L77003219

			.L77003326:
/* 0x02a4	 547 */		add	%l4,672,%g3
/* 0x02a8	     */		ldub	[%i0+%g3],%g4
/* 0x02ac	     */		cmp	%g4,0
/* 0x02b0	     */		bne,pn	%icc,.L77003295
/* 0x02b4	 543 */		or	%g0,0,%l2

! Registers live out of .L77003326: 
! g4 o2 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003326

			.L77003468:
/* 0x02b8	 543 */		ld	[%fp+100],%l1
/* 0x02bc	     */		ba	.L900001113
/* 0x02c0	 558 */		add	%l0,860,%o3

! Registers live out of .L77003468: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003235

			.L77003392:
/* 0x02c4	 104 */		or	%g0,0,%o4
/* 0x02c8	 105 */		andcc	%o1,%o2,%g0

! Registers live out of .L77003392: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003272 .L77003392 .L77003402

			.L900001114:
/* 0x02cc	 105 */		bne,pn	%icc,.L77003272
/* 0x02d0	 108 */		srl	%o1,1,%o1

! Registers live out of .L900001114: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001114

			.L77003269:
/* 0x02d4	 106 */		stb	%g0,[%o4+%l3]

! Registers live out of .L77003269: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003269 .L900001114

			.L77003272:
/* 0x02d8	 109 */		cmp	%o1,0
/* 0x02dc	   0 */		move	%icc,%o3,%o1
/* 0x02e0	 104 */		add	%o4,1,%o4
/* 0x02e4	     */		cmp	%o4,%i1
/* 0x02e8	     */		bcs,pt	%icc,.L900001114
/* 0x02ec	 105 */		andcc	%o1,%o2,%g0

! Registers live out of .L77003272: 
! g4 o1 o2 o3 o4 o5 sp l0 l1 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003272

			.L77003230:
/* 0x02f0	 547 */		add	%l4,672,%l6
/* 0x02f4	     */		ldub	[%i0+%l6],%l2
/* 0x02f8	     */		cmp	%l2,0
/* 0x02fc	     */		bne,pn	%icc,.L77003231
/* 0x0300	 543 */		or	%g0,0,%l2

! Registers live out of .L77003230: 
! g4 o2 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003230

			.L77003448:
/* 0x0304	 543 */		ld	[%fp+100],%l1
/* 0x0308	     */		ba	.L900001113
/* 0x030c	 558 */		add	%l0,860,%o3

! Registers live out of .L77003448: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002994

			.L77003322:
/* 0x0310	 547 */		add	%l4,672,%g2
/* 0x0314	     */		ldub	[%i0+%g2],%l5
/* 0x0318	     */		cmp	%l5,0
/* 0x031c	     */		be,pn	%icc,.L77003390
/* 0x0320	 543 */		ld	[%fp+100],%l1

! Registers live out of .L77003322: 
! g4 o2 o4 o5 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  548		      !      GLubyte alpha[MAX_WIDTH];
!  549		      !      for (i=0;i<n;i++) {

                       
! predecessor blocks: .L77003322

			.L77003319:
/* 0x0324	 549 */		ba	.L900001109
/* 0x0328	 552 */		or	%g0,%i1,%o1

! Registers live out of .L77003319: 
! o1 o2 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003322

			.L77003390:
/* 0x032c	 543 */		or	%g0,0,%l2
/* 0x0330	     */		ba	.L900001113
/* 0x0334	 558 */		add	%l0,860,%o3

! Registers live out of .L77003390: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002990 .L77002992

			.L77002996:
/* 0x0338	 547 */		add	%l4,672,%l1
/* 0x033c	     */		ldub	[%i0+%l1],%l5
/* 0x0340	     */		cmp	%l5,0
/* 0x0344	     */		bne,pn	%icc,.L77002998
/* 0x0348	     */		ld	[%fp+100],%l1

! Registers live out of .L77002996: 
! g4 o2 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002996

			.L77003372:
/* 0x034c	 547 */		ba	.L900001113
/* 0x0350	 558 */		add	%l0,860,%o3

! Registers live out of .L77003372: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002996

			.L77002998:
/* 0x0354	 549 */		cmp	%i1,0
/* 0x0358	     */		bleu,a,pt	%icc,.L77003006
/* 0x035c	     */		ld	[%fp+100],%l1

! Registers live out of .L77002998: 
! o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002998 .L77003230

			.L77003231:
/* 0x0360	 549 */		cmp	%i1,2
/* 0x0364	     */		bl,a,pt	%icc,.L900001112
/* 0x0368	     */		ld	[%fp+100],%l1

! Registers live out of .L77003231: 
! o2 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003231

			.L77003244:
/* 0x036c	 549 */		sethi	%hi(0x7ffffc00),%g3
/* 0x0370	     */		add	%g3,1022,%g4
/* 0x0374	     */		srl	%i1,0,%g2
/* 0x0378	     */		sub	%g2,%g4,%g4
/* 0x037c	     */		srlx	%g4,63,%l6
/* 0x0380	     */		andcc	%l6,1,%g0
/* 0x0384	     */		be,pt	%icc,.L900001111
/* 0x0388	     */		or	%g0,0,%l5

! Registers live out of .L77003244: 
! o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003244 .L77003326

			.L77003295:
/* 0x038c	 549 */		cmp	%i1,0
/* 0x0390	     */		ble,a,pn	%icc,.L77003006
/* 0x0394	     */		ld	[%fp+100],%l1

! Registers live out of .L77003295: 
! o2 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003295

			.L77003302:
/* 0x0398	 549 */		or	%g0,0,%o1
/* 0x039c	     */		add	%i1,-1,%o3
/* 0x03a0	     */		add	%fp,-3200,%o0
/* 0x03a4	     */		ld	[%fp+100],%o2

!  550		      !         alpha[i] = a;

/* 0x03a8	 550 */		add	%i1,-2,%l2
/* 0x03ac	     */		nop
/* 0x03b0	 549 */		or	%g0,%o2,%l1

! Registers live out of .L77003302: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003302 .L900001083

			.L900001083:
/* 0x03b4	 550 */		stb	%o2,[%o0]
/* 0x03b8	 549 */		add	%o1,2,%o1
/* 0x03bc	     */		add	%o0,2,%o0
/* 0x03c0	     */		cmp	%o1,%l2
/* 0x03c4	     */		ble,pt	%icc,.L900001083
/* 0x03c8	 550 */		stb	%o2,[%o0-1]

! Registers live out of .L900001083: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001083

			.L900001086:
/* 0x03cc	 549 */		cmp	%o1,%o3
/* 0x03d0	     */		bg,pn	%icc,.L900001080
/* 0x03d4	 550 */		nop

! Registers live out of .L900001086: 
! o0 o2 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001086

			.L77003296:
/* 0x03d8	 550 */		stb	%o2,[%o0]

! Registers live out of .L77003296: 
! o2 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003296 .L900001086

			.L900001080:
/* 0x03dc	 549 */		ba	.L900001109
/* 0x03e0	 552 */		or	%g0,%i1,%o1

! Registers live out of .L900001080: 
! o1 o2 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003244

			.L900001111:
/* 0x03e4	 549 */		ld	[%fp+100],%l1
/* 0x03e8	     */		ba	.L900001095
/* 0x03ec	 550 */		add	%fp,-3200,%g2

! Registers live out of .L900001111: 
! g2 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003231

			.L900001112:
/* 0x03f0	 549 */		or	%g0,0,%l5
/* 0x03f4	 550 */		add	%fp,-3200,%g2

! Registers live out of .L900001112: 
! g2 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001111 .L900001112

			.L900001095:
/* 0x03f8	 550 */		stb	%l1,[%l5+%g2]

! Registers live out of .L900001095: 
! g2 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003240 .L900001095

			.L900001110:
/* 0x03fc	 549 */		add	%l5,1,%l5
/* 0x0400	     */		cmp	%l5,%i1
/* 0x0404	     */		bcc,pn	%icc,.L900001109
/* 0x0408	 552 */		or	%g0,%i1,%o1

! Registers live out of .L900001110: 
! g2 o1 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001110

			.L77003240:
/* 0x040c	 550 */		stb	%l1,[%l5+%g2]
/* 0x0410	 549 */		add	%l5,1,%l5
/* 0x0414	     */		cmp	%l5,%i1
/* 0x0418	     */		bcs,a,pt	%icc,.L900001110
/* 0x041c	 550 */		stb	%l1,[%l5+%g2]

! Registers live out of .L77003240: 
! g2 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  551		      !      }
!  552		      !      if (gl_alpha_test( ctx, n, alpha, mask )==0) {

                       
! predecessor blocks: .L77002998 .L77003240 .L77003295

			.L77003006:
/* 0x0420	 552 */		or	%g0,%i1,%o1

! Registers live out of .L77003006: 
! o1 o2 sp l0 l1 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003006 .L77003319 .L900001080 .L900001110

			.L900001109:
/* 0x0424	 552 */		add	%fp,-1600,%o3
/* 0x0428	     */		or	%g0,%i0,%o0
/* 0x042c	     */		call	gl_alpha_test	! params =  %o0 %o1 %o2 %o3	! Result =  %o0
/* 0x0430	     */		add	%fp,-3200,%o2
/* 0x0434	     */		orcc	%g0,%o0,%g0
/* 0x0438	     */		be,pn	%icc,.L77003163

!  553		      !	 return;
!  554		      !      }
!  555		      !      write_all = GL_FALSE;

/* 0x043c	 555 */		or	%g0,0,%l2

! Registers live out of .L900001109: 
! g4 o4 o5 sp l0 l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  556		      !   }
!  558		      !   if (ctx->Stencil.Enabled) {

                       
! predecessor blocks: .L900001109

			.L77003012:
/* 0x0440	 558 */		add	%l0,860,%o3

! Registers live out of .L77003012: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003012 .L77003372 .L77003390 .L77003448 .L77003468

			.L900001113:
/* 0x0444	 558 */		ldub	[%i0+%o3],%o2
/* 0x0448	     */		cmp	%o2,0
/* 0x044c	     */		be,pn	%icc,.L77003020
/* 0x0450	 560 */		or	%g0,%i3,%o3

! Registers live out of .L900001113: 
! g4 o3 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  559		      !      /* first stencil test */
!  560		      !      if (gl_stencil_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900001113

			.L77003014:
/* 0x0454	 560 */		or	%g0,%i2,%o2
/* 0x0458	     */		or	%g0,%i1,%o1
/* 0x045c	     */		or	%g0,%i0,%o0
/* 0x0460	     */		call	gl_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0464	     */		add	%fp,-1600,%o4
/* 0x0468	     */		orcc	%g0,%o0,%g0
/* 0x046c	     */		be,pn	%icc,.L77003163
/* 0x0470	 564 */		or	%g0,%i4,%o4

! Registers live out of .L77003014: 
! o4 o5 sp l1 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  561		      !	 return;
!  562		      !      }
!  563		      !      /* depth buffering w/ stencil */
!  564		      !      gl_depth_stencil_span( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77003014

			.L77003018:
/* 0x0474	 564 */		or	%g0,%i3,%o3
/* 0x0478	     */		or	%g0,%i2,%o2
/* 0x047c	     */		or	%g0,%i1,%o1
/* 0x0480	     */		or	%g0,%i0,%o0
/* 0x0484	     */		call	gl_depth_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0488	     */		add	%fp,-1600,%o5

!  565		      !      write_all = GL_FALSE;

/* 0x048c	 565 */		or	%g0,0,%l2
/* 0x0490	     */		ba	.L900001108
/* 0x0494	 578 */		ld	[%i0+%l7],%o7

! Registers live out of .L77003018: 
! g4 o4 sp o7 l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  566		      !   }
!  567		      !   else if (ctx->Depth.Test) {

                       
! predecessor blocks: .L900001113

			.L77003020:
/* 0x0498	 567 */		add	%l4,828,%g5
/* 0x049c	     */		ldub	[%i0+%g5],%o4
/* 0x04a0	     */		cmp	%o4,0
/* 0x04a4	     */		be,pn	%icc,.L77003034
/* 0x04a8	 569 */		or	%g0,%i4,%o4

! Registers live out of .L77003020: 
! g4 o4 o5 sp l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  568		      !      /* regular depth testing */
!  569		      !      GLuint m = (*ctx->Driver.DepthTestSpan)( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77003020

			.L77003022:
/* 0x04ac	 569 */		or	%g0,%i3,%o3
/* 0x04b0	     */		or	%g0,%i2,%o2
/* 0x04b4	     */		or	%g0,%i1,%o1
/* 0x04b8	     */		or	%g0,%i0,%o0
/* 0x04bc	     */		ld	[%i0+2332],%g4
/* 0x04c0	     */		jmpl	%g4,%o7
/* 0x04c4	     */		add	%fp,-1600,%o5
/* 0x04c8	     */		orcc	%g0,%o0,%g0

!  570		      !      if (m==0) {

/* 0x04cc	 570 */		be,pn	%icc,.L77003163
/* 0x04d0	 574 */		srl	%o0,0,%o3

! Registers live out of .L77003022: 
! g4 o3 sp l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  571		      !         return;
!  572		      !      }
!  573		      !      if (m<n) {
!  574		      !         write_all = GL_FALSE;

                       
! predecessor blocks: .L77003022

			.L77003026:
/* 0x04d4	 574 */		srl	%i1,0,%o4
/* 0x04d8	     */		sub	%o3,%o4,%o5
/* 0x04dc	     */		srlx	%o5,63,%g2
/* 0x04e0	     */		xor	%g2,1,%g3
/* 0x04e4	     */		and	%g3,%l2,%l2
/* 0x04e8	     */		and	%l2,255,%l2

! Registers live out of .L77003026: 
! g4 o4 sp l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  575		      !      }
!  576		      !   }
!  578		      !   if (ctx->RasterMask & NO_DRAW_BIT) {

                       
! predecessor blocks: .L77003020 .L77003026

			.L77003034:
/* 0x04ec	 578 */		ld	[%i0+%l7],%o7

! Registers live out of .L77003034: 
! g4 o4 sp o7 l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003018 .L77003034

			.L900001108:
/* 0x04f0	 578 */		andcc	%o7,2048,%g0
/* 0x04f4	     */		bne,pn	%icc,.L77003163
/* 0x04f8	 584 */		add	%l4,685,%i4

! Registers live out of .L900001108: 
! g4 o4 sp l1 l2 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  579		      !      /* write no pixels */
!  580		      !      return;
!  581		      !   }
!  583		      !   if (ctx->Color.BlendEnabled || ctx->Color.SWLogicOpEnabled
!  584		      !       || ctx->Color.SWmasking) {

                       
! predecessor blocks: .L900001108

			.L77003038:
/* 0x04fc	 584 */		ldub	[%i0+%i4],%o1
/* 0x0500	     */		cmp	%o1,0
/* 0x0504	     */		bne,pn	%icc,.L77003046
/* 0x0508	     */		add	%l4,722,%l0

! Registers live out of .L77003038: 
! g4 o4 sp l0 l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003038

			.L77003040:
/* 0x050c	 584 */		ldub	[%i0+%l0],%l6
/* 0x0510	     */		cmp	%l6,0
/* 0x0514	     */		bne,pn	%icc,.L77003046
/* 0x0518	     */		add	%l4,664,%l5

! Registers live out of .L77003040: 
! g4 o4 sp l1 l2 l4 l5 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003040

			.L77003042:
/* 0x051c	 584 */		ldub	[%i0+%l5],%i4
/* 0x0520	     */		cmp	%i4,0
/* 0x0524	     */		bne,pn	%icc,.L77003046
/* 0x0528	 646 */		or	%g0,%i3,%o3

! Registers live out of .L77003042: 
! g4 o3 o4 sp l1 l2 l4 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  585		      !      /* assign same color to each pixel */
!  586		      !      for (i=0;i<n;i++) {
!  587		      !	 if (mask[i]) {
!  588		      !	    red[i]   = r;
!  589		      !	    green[i] = g;
!  590		      !	    blue[i]  = b;
!  591		      !	    alpha[i] = a;
!  592		      !	 }
!  593		      !      }
!  595		      !      if (ctx->Color.SWLogicOpEnabled) {
!  596		      !         gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask );
!  597		      !      }
!  598		      !      else if (ctx->Color.BlendEnabled) {
!  599		      !         gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );
!  600		      !      }
!  602		      !      /* Color component masking */
!  603		      !      if (ctx->Color.SWmasking) {
!  604		      !         gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );
!  605		      !      }
!  607		      !      /* write pixels */
!  608		      !      (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  609		      !                                     write_all ? NULL : mask );
!  610		      !      if (ctx->RasterMask & ALPHABUF_BIT) {
!  611		      !         gl_write_alpha_span( ctx, n, x, y, alpha, write_all ? NULL : mask );
!  612		      !      }
!  614		      !      if (ctx->RasterMask & FRONT_AND_BACK_BIT) {
!  615		      !         /*** Also draw to back buffer ***/
!  616		      !         for (i=0;i<n;i++) {
!  617		      !            if (mask[i]) {
!  618		      !               red[i]   = r;
!  619		      !               green[i] = g;
!  620		      !               blue[i]  = b;
!  621		      !               alpha[i] = a;
!  622		      !            }
!  623		      !         }
!  624		      !         (*ctx->Driver.SetBuffer)( ctx, GL_BACK );
!  625		      !         if (ctx->Color.SWLogicOpEnabled) {
!  626		      !            gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask);
!  627		      !         }
!  628		      !         else if (ctx->Color.BlendEnabled) {
!  629		      !            gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );
!  630		      !         }
!  631		      !         if (ctx->Color.SWmasking) {
!  632		      !            gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );
!  633		      !         }
!  634		      !         (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  635		      !                                        write_all ? NULL : mask );
!  636		      !         (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );
!  637		      !         if (ctx->RasterMask & ALPHABUF_BIT) {
!  638		      !            ctx->Buffer->Alpha = ctx->Buffer->BackAlpha;
!  639		      !            gl_write_alpha_span( ctx, n, x, y, alpha,
!  640		      !                                 write_all ? NULL : mask );
!  641		      !            ctx->Buffer->Alpha = ctx->Buffer->FrontAlpha;
!  642		      !         }
!  643		      !      }
!  644		      !   }
!  645		      !   else {
!  646		      !      (*ctx->Driver.WriteMonocolorSpan)( ctx, n, x, y, mask );

                       
! predecessor blocks: .L77003042

			.L77003136:
/* 0x052c	 646 */		or	%g0,%i2,%o2
/* 0x0530	     */		or	%g0,%i1,%o1
/* 0x0534	     */		ld	[%i0+2248],%l0
/* 0x0538	     */		or	%g0,%i0,%o0
/* 0x053c	     */		jmpl	%l0,%o7
/* 0x0540	     */		add	%fp,-1600,%o4

!  647		      !      if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x0544	 647 */		ld	[%i0+%l7],%o1
/* 0x0548	     */		andcc	%o1,256,%g0
/* 0x054c	     */		be,pn	%icc,.L77003146
/* 0x0550	 648 */		cmp	%l2,0

! Registers live out of .L77003136: 
! o0 o1 o4 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  648		      !         gl_write_mono_alpha_span( ctx, n, x, y, a, write_all ? NULL : mask );

                       
! predecessor blocks: .L77003136

			.L77003138:
/* 0x0554	 648 */		be,pn	%icc,.L77003142
/* 0x0558	     */		or	%g0,0,%o5

! Registers live out of .L77003138: 
! o4 o5 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003138

			.L77003140:
/* 0x055c	 648 */		ba	.L900001107
/* 0x0560	     */		or	%g0,%i3,%o3

! Registers live out of .L77003140: 
! o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003138

			.L77003142:
/* 0x0564	 648 */		add	%fp,-1600,%o5
/* 0x0568	     */		or	%g0,%i3,%o3

! Registers live out of .L77003142: 
! o3 o4 o5 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003140 .L77003142

			.L900001107:
/* 0x056c	 648 */		or	%g0,%i2,%o2
/* 0x0570	     */		or	%g0,%i1,%o1
/* 0x0574	     */		or	%g0,%i0,%o0
/* 0x0578	     */		call	gl_write_mono_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x057c	     */		and	%l1,255,%o4
/* 0x0580	     */		ld	[%i0+%l7],%o1

! Registers live out of .L900001107: 
! o0 o1 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  649		      !      }
!  650		      !      if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

                       
! predecessor blocks: .L77003136 .L900001107

			.L77003146:
/* 0x0584	 650 */		andcc	%o1,1024,%g0
/* 0x0588	     */		be,pn	%icc,.L77003163

!  651		      !         /* Also draw to back buffer */
!  652		      !         (*ctx->Driver.SetBuffer)( ctx, GL_BACK );

/* 0x058c	 652 */		or	%g0,1029,%o1

! Registers live out of .L77003146: 
! o0 o1 sp l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003146

			.L77003148:
/* 0x0590	 652 */		ld	[%i0+2236],%i5
/* 0x0594	     */		jmpl	%i5,%o7
/* 0x0598	     */		or	%g0,%i0,%o0

!  653		      !         (*ctx->Driver.WriteMonocolorSpan)( ctx, n, x, y, mask );

/* 0x059c	 653 */		or	%g0,%i3,%o3
/* 0x05a0	     */		or	%g0,%i2,%o2
/* 0x05a4	     */		or	%g0,%i1,%o1
/* 0x05a8	     */		or	%g0,%i0,%o0
/* 0x05ac	     */		ld	[%i0+2248],%i4
/* 0x05b0	     */		jmpl	%i4,%o7
/* 0x05b4	     */		add	%fp,-1600,%o4

!  654		      !         (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );

/* 0x05b8	 654 */		ld	[%i0+2236],%o3
/* 0x05bc	     */		or	%g0,1028,%o1
/* 0x05c0	     */		jmpl	%o3,%o7
/* 0x05c4	     */		or	%g0,%i0,%o0

!  655		      !         if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x05c8	 655 */		ld	[%i0+%l7],%o2
/* 0x05cc	     */		andcc	%o2,256,%g0
/* 0x05d0	     */		be,pn	%icc,.L77003163
/* 0x05d4	 658 */		cmp	%l2,0

! Registers live out of .L77003148: 
! o0 sp l1 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  656		      !            ctx->Buffer->Alpha = ctx->Buffer->BackAlpha;

                       
! predecessor blocks: .L77003148

			.L77003150:
/* 0x05d8	 656 */		ld	[%i0+2204],%l3
/* 0x05dc	     */		ld	[%l3+28],%l7

!  657		      !            gl_write_mono_alpha_span( ctx, n, x, y, a,
!  658		      !                                      write_all ? NULL : mask );

/* 0x05e0	 658 */		be,pn	%icc,.L77003154
/* 0x05e4	 656 */		st	%l7,[%l3+32]

! Registers live out of .L77003150: 
! o0 sp l1 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003150

			.L77003152:
/* 0x05e8	 658 */		or	%g0,0,%o5
/* 0x05ec	     */		ba	.L900001106
/* 0x05f0	     */		or	%g0,%i3,%o3

! Registers live out of .L77003152: 
! o0 o3 o5 sp l1 i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003150

			.L77003154:
/* 0x05f4	 658 */		add	%fp,-1600,%o5
/* 0x05f8	     */		or	%g0,%i3,%o3

! Registers live out of .L77003154: 
! o0 o3 o5 sp l1 i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003152 .L77003154

			.L900001106:
/* 0x05fc	 658 */		or	%g0,%i2,%o2
/* 0x0600	     */		and	%l1,255,%o4
/* 0x0604	     */		or	%g0,%i1,%o1
/* 0x0608	     */		call	gl_write_mono_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x060c	     */		or	%g0,%i0,%o0

!  659		      !            ctx->Buffer->Alpha = ctx->Buffer->FrontAlpha;

/* 0x0610	 659 */		ld	[%i0+2204],%i1
/* 0x0614	     */		ld	[%i1+24],%i3
/* 0x0618	     */		st	%i3,[%i1+32]
/* 0x061c	 527 */		ret	! Result = 
/* 0x0620	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003038 .L77003040 .L77003042

			.L77003046:
/* 0x0624	   0 */		sethi	%hi(0x1c00),%g1
/* 0x0628	   0 */		xor	%g1,-832,%g1
/* 0x062c	   0 */		add	%g1,%fp,%l5
/* 0x0630	   0 */		sethi	%hi(0x1800),%g1
/* 0x0634	   0 */		xor	%g1,-256,%g1
/* 0x0638	 586 */		cmp	%i1,0
/* 0x063c	   0 */		add	%g1,%fp,%g1
/* 0x0640	 586 */		bleu,pn	%icc,.L77003420
/* 0x0644	   0 */		or	%g0,%g1,%l6

! Registers live out of .L77003046: 
! g4 o4 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003046

			.L77003232:
/* 0x0648	   0 */		sethi	%hi(0x2400),%g1
/* 0x064c	   0 */		xor	%g1,-384,%g1
/* 0x0650	 586 */		cmp	%i1,2
/* 0x0654	   0 */		add	%g1,%fp,%g1
/* 0x0658	 586 */		bl,pn	%icc,.L77003434
/* 0x065c	   0 */		or	%g0,%g1,%o7

! Registers live out of .L77003232: 
! g4 o4 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003232

			.L77003254:
/* 0x0660	 586 */		sethi	%hi(0x7ffffc00),%o1
/* 0x0664	     */		add	%o1,1022,%o5
/* 0x0668	     */		srl	%i1,0,%o4
/* 0x066c	     */		sub	%o4,%o5,%o0
/* 0x0670	     */		srlx	%o0,63,%i4
/* 0x0674	     */		andcc	%i4,1,%g0
/* 0x0678	     */		be,pn	%icc,.L77003442
/* 0x067c	     */		cmp	%i1,0

! Registers live out of .L77003254: 
! g4 o4 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003254

			.L77003297:
/* 0x0680	 586 */		ble,pn	%icc,.L77003454
/* 0x0684	     */		ld	[%fp+92],%i4

! Registers live out of .L77003297: 
! o4 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003297

			.L77003345:
/* 0x0688	 586 */		sethi	%hi(0x1000),%g1
/* 0x068c	     */		xor	%g1,-704,%g1
/* 0x0690	     */		add	%g1,%fp,%o4
/* 0x0694	     */		sethi	%hi(0x1800),%g1
/* 0x0698	     */		xor	%g1,-256,%g1
/* 0x069c	     */		add	%g1,%fp,%g5
/* 0x06a0	     */		sethi	%hi(0x1c00),%g1
/* 0x06a4	     */		xor	%g1,-832,%g1
/* 0x06a8	     */		add	%g1,%fp,%g4
/* 0x06ac	     */		sethi	%hi(0x2400),%g1
/* 0x06b0	     */		xor	%g1,-384,%g1
/* 0x06b4	     */		add	%fp,-1600,%o3
/* 0x06b8	     */		add	%g1,%fp,%g1
/* 0x06bc	     */		ld	[%fp+96],%l0
/* 0x06c0	     */		or	%g0,0,%o0
/* 0x06c4	     */		add	%i1,-1,%o2
/* 0x06c8	 587 */		ldub	[%o3],%g2
/* 0x06cc	 586 */		or	%g0,%g1,%g3

! Registers live out of .L77003345: 
! g1 g2 g3 g4 g5 o0 o2 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003054 .L77003345

			.L900001105:
/* 0x06d0	 587 */		cmp	%g2,0
/* 0x06d4	     */		be,pn	%icc,.L77003054
/* 0x06d8	 586 */		add	%o0,1,%o0

! Registers live out of .L900001105: 
! g1 g2 g3 g4 g5 o0 o2 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001105

			.L77003052:
/* 0x06dc	 588 */		stb	%i5,[%o4]
/* 0x06e0	 589 */		stb	%i4,[%g5]
/* 0x06e4	 590 */		stb	%l0,[%g4]
/* 0x06e8	 591 */		stb	%l1,[%g3]

! Registers live out of .L77003052: 
! g1 g2 g3 g4 g5 o0 o2 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003052 .L900001105

			.L77003054:
/* 0x06ec	 586 */		cmp	%o0,%o2
/* 0x06f0	     */		add	%o3,1,%o3
/* 0x06f4	     */		add	%g3,1,%g3
/* 0x06f8	     */		add	%g4,1,%g4
/* 0x06fc	     */		add	%g5,1,%g5
/* 0x0700	     */		add	%o4,1,%o4
/* 0x0704	     */		ble,a,pt	%icc,.L900001105
/* 0x0708	 587 */		ldub	[%o3],%g2

! Registers live out of .L77003054: 
! g1 g2 g3 g4 g5 o0 o2 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003054

			.L900001078:
/* 0x070c	 586 */		ba	.L900001103
/* 0x0710	 595 */		sethi	%hi(0x1c00),%g4

! Registers live out of .L900001078: 
! g4 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003297

			.L77003454:
/* 0x0714	 586 */		ld	[%fp+96],%l0
/* 0x0718	     */		ba	.L900001103
/* 0x071c	 595 */		sethi	%hi(0x1c00),%g4

! Registers live out of .L77003454: 
! g4 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003254

			.L77003442:
/* 0x0720	 586 */		ld	[%fp+92],%i4
/* 0x0724	     */		ld	[%fp+96],%l0
/* 0x0728	     */		or	%g0,0,%g5
/* 0x072c	     */		ba	.L900001104
/* 0x0730	 587 */		ldub	[%g0+%l3],%o0

! Registers live out of .L77003442: 
! g4 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003232

			.L77003434:
/* 0x0734	 586 */		ld	[%fp+92],%i4
/* 0x0738	     */		ld	[%fp+96],%l0
/* 0x073c	 587 */		ldub	[%g0+%l3],%o0
/* 0x0740	 586 */		or	%g0,0,%g5

! Registers live out of .L77003434: 
! g4 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003250 .L77003434 .L77003442

			.L900001104:
/* 0x0744	 587 */		cmp	%o0,0
/* 0x0748	     */		be,pn	%icc,.L77003250
/* 0x074c	 588 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900001104: 
! g1 g4 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001104

			.L77003249:
/* 0x0750	 589 */		stb	%i4,[%g5+%l6]
/* 0x0754	 590 */		stb	%l0,[%g5+%l5]
/* 0x0758	 591 */		stb	%l1,[%g5+%o7]
/* 0x075c	 588 */		xor	%g1,-704,%g1
/* 0x0760	     */		add	%g1,%fp,%o1
/* 0x0764	     */		stb	%i5,[%g5+%o1]

! Registers live out of .L77003249: 
! g4 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003249 .L900001104

			.L77003250:
/* 0x0768	 586 */		add	%g5,1,%g5
/* 0x076c	     */		cmp	%g5,%i1
/* 0x0770	     */		bcs,a,pt	%icc,.L900001104
/* 0x0774	 587 */		ldub	[%g5+%l3],%o0

! Registers live out of .L77003250: 
! g4 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003250

			.L900001077:
/* 0x0778	 586 */		ba	.L900001103
/* 0x077c	 595 */		sethi	%hi(0x1c00),%g4

! Registers live out of .L900001077: 
! g4 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003046

			.L77003420:
/* 0x0780	 586 */		ld	[%fp+92],%i4
/* 0x0784	     */		ld	[%fp+96],%l0
/* 0x0788	 595 */		sethi	%hi(0x1c00),%g4

! Registers live out of .L77003420: 
! g4 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003420 .L77003454 .L900001077 .L900001078

			.L900001103:
/* 0x078c	 595 */		add	%g4,722,%g2
/* 0x0790	     */		ldub	[%i0+%g2],%o5
/* 0x0794	     */		cmp	%o5,0
/* 0x0798	     */		be,pn	%icc,.L77003062
/* 0x079c	 596 */		sethi	%hi(0x2400),%g1

! Registers live out of .L900001103: 
! g1 g4 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001103

			.L77003060:
/* 0x07a0	 596 */		xor	%g1,-384,%g1
/* 0x07a4	     */		add	%g1,%fp,%o7
/* 0x07a8	     */		sethi	%hi(0x1800),%g1
/* 0x07ac	     */		xor	%g1,-256,%g1
/* 0x07b0	     */		add	%g1,%fp,%o5
/* 0x07b4	     */		sllx	%o7,32,%g5
/* 0x07b8	     */		srl	%l3,0,%o0
/* 0x07bc	     */		sethi	%hi(0x1000),%g1
/* 0x07c0	     */		or	%g5,%o0,%g3
/* 0x07c4	     */		xor	%g1,-704,%g1
/* 0x07c8	     */		add	%g1,%fp,%g1
/* 0x07cc	     */		or	%g0,%i3,%o3
/* 0x07d0	     */		or	%g0,%i2,%o2
/* 0x07d4	     */		or	%g0,%i1,%o1
/* 0x07d8	     */		or	%g0,%i0,%o0
/* 0x07dc	     */		stx	%g3,[%sp+96]
/* 0x07e0	     */		st	%l5,[%sp+92]
/* 0x07e4	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x07e8	     */		or	%g0,%g1,%o4
/* 0x07ec	     */		ba	.L900001102
/* 0x07f0	 603 */		add	%l4,664,%l4

! Registers live out of .L77003060: 
! o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001103

			.L77003062:
/* 0x07f4	 598 */		add	%g4,685,%g3
/* 0x07f8	     */		ldub	[%i0+%g3],%o1
/* 0x07fc	     */		cmp	%o1,0
/* 0x0800	     */		be,pn	%icc,.L77003068
/* 0x0804	 599 */		sethi	%hi(0x2400),%g1

! Registers live out of .L77003062: 
! g1 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003062

			.L77003064:
/* 0x0808	 599 */		xor	%g1,-384,%g1
/* 0x080c	     */		add	%g1,%fp,%o2
/* 0x0810	     */		sethi	%hi(0x1800),%g1
/* 0x0814	     */		xor	%g1,-256,%g1
/* 0x0818	     */		sllx	%o2,32,%o1
/* 0x081c	     */		add	%g1,%fp,%o5
/* 0x0820	     */		srl	%l3,0,%o2
/* 0x0824	     */		sethi	%hi(0x1000),%g1
/* 0x0828	     */		or	%o1,%o2,%g4
/* 0x082c	     */		xor	%g1,-704,%g1
/* 0x0830	     */		add	%g1,%fp,%g1
/* 0x0834	     */		or	%g0,%i3,%o3
/* 0x0838	     */		or	%g0,%i2,%o2
/* 0x083c	     */		or	%g0,%i1,%o1
/* 0x0840	     */		stx	%g4,[%sp+96]
/* 0x0844	     */		or	%g0,%i0,%o0
/* 0x0848	     */		st	%l5,[%sp+92]
/* 0x084c	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0850	     */		or	%g0,%g1,%o4

! Registers live out of .L77003064: 
! o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003062 .L77003064

			.L77003068:
/* 0x0854	 603 */		add	%l4,664,%l4

! Registers live out of .L77003068: 
! o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003060 .L77003068

			.L900001102:
/* 0x0858	 603 */		ldub	[%i0+%l4],%o3
/* 0x085c	     */		cmp	%o3,0
/* 0x0860	     */		be,pn	%icc,.L77003072
/* 0x0864	 604 */		sethi	%hi(0x2400),%g1

! Registers live out of .L900001102: 
! g1 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001102

			.L77003070:
/* 0x0868	 604 */		xor	%g1,-384,%g1
/* 0x086c	     */		add	%g1,%fp,%g4
/* 0x0870	     */		sethi	%hi(0x1800),%g1
/* 0x0874	     */		xor	%g1,-256,%g1
/* 0x0878	     */		add	%g1,%fp,%o5
/* 0x087c	     */		sethi	%hi(0x1000),%g1
/* 0x0880	     */		xor	%g1,-704,%g1
/* 0x0884	     */		add	%g1,%fp,%g1
/* 0x0888	     */		or	%g0,%i3,%o3
/* 0x088c	     */		or	%g0,%i2,%o2
/* 0x0890	     */		or	%g0,%i1,%o1
/* 0x0894	     */		st	%g4,[%sp+96]
/* 0x0898	     */		or	%g0,%i0,%o0
/* 0x089c	     */		st	%l5,[%sp+92]
/* 0x08a0	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x08a4	     */		or	%g0,%g1,%o4

! Registers live out of .L77003070: 
! o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003070 .L900001102

			.L77003072:
/* 0x08a8	 609 */		cmp	%l2,0
/* 0x08ac	     */		be,pn	%icc,.L77003076
/* 0x08b0	     */		sethi	%hi(0x2400),%g1

! Registers live out of .L77003072: 
! g1 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003072

			.L77003074:
/* 0x08b4	 609 */		xor	%g1,-384,%g1
/* 0x08b8	     */		add	%g1,%fp,%o0
/* 0x08bc	     */		sethi	%hi(0x1800),%g1
/* 0x08c0	     */		xor	%g1,-256,%g1
/* 0x08c4	     */		add	%g1,%fp,%o5
/* 0x08c8	     */		sllx	%o0,32,%o2
/* 0x08cc	     */		sethi	%hi(0x1000),%g1
/* 0x08d0	     */		xor	%g1,-704,%g1
/* 0x08d4	     */		add	%g1,%fp,%g1
/* 0x08d8	     */		or	%g0,%i3,%o3
/* 0x08dc	     */		stx	%o2,[%sp+96]
/* 0x08e0	     */		or	%g0,%i2,%o2
/* 0x08e4	     */		or	%g0,%i1,%o1
/* 0x08e8	     */		ld	[%i0+2244],%g3
/* 0x08ec	     */		or	%g0,%i0,%o0
/* 0x08f0	     */		st	%l5,[%sp+92]
/* 0x08f4	     */		jmpl	%g3,%o7
/* 0x08f8	     */		or	%g0,%g1,%o4
/* 0x08fc	 610 */		ld	[%i0+%l7],%g2
/* 0x0900	     */		andcc	%g2,256,%g0
/* 0x0904	     */		be,pn	%icc,.L77003088
/* 0x0908	 611 */		or	%g0,0,%o5

! Registers live out of .L77003074: 
! g2 o0 o1 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003074

			.L77003082:
/* 0x090c	 611 */		ba	.L900001101
/* 0x0910	     */		or	%g0,%i3,%o3

! Registers live out of .L77003082: 
! o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003072

			.L77003076:
/* 0x0914	 609 */		xor	%g1,-384,%g1
/* 0x0918	     */		add	%g1,%fp,%o4
/* 0x091c	     */		sethi	%hi(0x1800),%g1
/* 0x0920	     */		sllx	%o4,32,%o3
/* 0x0924	     */		xor	%g1,-256,%g1
/* 0x0928	     */		add	%g1,%fp,%o5
/* 0x092c	     */		srl	%l3,0,%o4
/* 0x0930	     */		or	%o3,%o4,%o3
/* 0x0934	     */		sethi	%hi(0x1000),%g1
/* 0x0938	     */		xor	%g1,-704,%g1
/* 0x093c	     */		add	%g1,%fp,%g1
/* 0x0940	     */		or	%g0,%i2,%o2
/* 0x0944	     */		stx	%o3,[%sp+96]
/* 0x0948	     */		or	%g0,%i3,%o3
/* 0x094c	     */		or	%g0,%i1,%o1
/* 0x0950	     */		ld	[%i0+2244],%g5
/* 0x0954	     */		or	%g0,%i0,%o0
/* 0x0958	     */		st	%l5,[%sp+92]
/* 0x095c	     */		jmpl	%g5,%o7
/* 0x0960	     */		or	%g0,%g1,%o4
/* 0x0964	 610 */		ld	[%i0+%l7],%g2
/* 0x0968	     */		andcc	%g2,256,%g0
/* 0x096c	     */		be,pn	%icc,.L77003088
/* 0x0970	 611 */		add	%fp,-1600,%o5

! Registers live out of .L77003076: 
! g2 o0 o1 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003076

			.L77003086:
/* 0x0974	 611 */		or	%g0,%i3,%o3

! Registers live out of .L77003086: 
! o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003082 .L77003086

			.L900001101:
/* 0x0978	 611 */		sethi	%hi(0x2400),%g1
/* 0x097c	     */		xor	%g1,-384,%g1
/* 0x0980	     */		add	%g1,%fp,%g1
/* 0x0984	     */		or	%g0,%i2,%o2
/* 0x0988	     */		or	%g0,%i1,%o1
/* 0x098c	     */		or	%g0,%i0,%o0
/* 0x0990	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0994	     */		or	%g0,%g1,%o4
/* 0x0998	     */		ld	[%i0+%l7],%g2

! Registers live out of .L900001101: 
! g2 o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003074 .L77003076 .L900001101

			.L77003088:
/* 0x099c	 614 */		andcc	%g2,1024,%g0
/* 0x09a0	     */		be,pn	%icc,.L77003163
/* 0x09a4	 616 */		cmp	%i1,0

! Registers live out of .L77003088: 
! o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003088

			.L77003090:
/* 0x09a8	 616 */		bleu,pn	%icc,.L77003102
/* 0x09ac	     */		cmp	%i1,2

! Registers live out of .L77003090: 
! o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003090

			.L77003233:
/* 0x09b0	   0 */		sethi	%hi(0x2400),%g1
/* 0x09b4	   0 */		xor	%g1,-384,%g1
/* 0x09b8	   0 */		add	%g1,%fp,%g1
/* 0x09bc	 616 */		bl,pn	%icc,.L77003484
/* 0x09c0	   0 */		or	%g0,%g1,%g4

! Registers live out of .L77003233: 
! g4 o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003233

			.L77003264:
/* 0x09c4	 616 */		sethi	%hi(0x7ffffc00),%g2
/* 0x09c8	     */		add	%g2,1022,%o7
/* 0x09cc	     */		srl	%i1,0,%o5
/* 0x09d0	     */		sub	%o5,%o7,%o7
/* 0x09d4	     */		srlx	%o7,63,%o3
/* 0x09d8	     */		andcc	%o3,1,%g0
/* 0x09dc	     */		be,a,pn	%icc,.L77003258
/* 0x09e0	     */		or	%g0,0,%o1

! Registers live out of .L77003264: 
! g4 o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003264

			.L77003298:
/* 0x09e4	 616 */		cmp	%i1,0
/* 0x09e8	     */		ble,pn	%icc,.L77003102
/* 0x09ec	     */		or	%g0,0,%l6

! Registers live out of .L77003298: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003298

			.L77003347:
/* 0x09f0	 616 */		sethi	%hi(0x1000),%g1
/* 0x09f4	     */		xor	%g1,-704,%g1
/* 0x09f8	     */		add	%g1,%fp,%o1
/* 0x09fc	     */		sethi	%hi(0x1800),%g1
/* 0x0a00	     */		xor	%g1,-256,%g1
/* 0x0a04	     */		add	%g1,%fp,%o2
/* 0x0a08	     */		sethi	%hi(0x1c00),%g1
/* 0x0a0c	     */		xor	%g1,-832,%g1
/* 0x0a10	     */		add	%g1,%fp,%g4
/* 0x0a14	     */		sethi	%hi(0x2400),%g1
/* 0x0a18	     */		add	%fp,-1600,%o5
/* 0x0a1c	     */		xor	%g1,-384,%g1
/* 0x0a20	     */		add	%i1,-1,%o7
/* 0x0a24	 617 */		ldub	[%o5],%g2
/* 0x0a28	 616 */		add	%g1,%fp,%o3

! Registers live out of .L77003347: 
! g2 g4 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003098 .L77003347

			.L900001100:
/* 0x0a2c	 617 */		cmp	%g2,0
/* 0x0a30	     */		be,pn	%icc,.L77003098
/* 0x0a34	 616 */		add	%l6,1,%l6

! Registers live out of .L900001100: 
! g2 g4 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001100

			.L77003096:
/* 0x0a38	 618 */		stb	%i5,[%o1]
/* 0x0a3c	 619 */		stb	%i4,[%o2]
/* 0x0a40	 620 */		stb	%l0,[%g4]
/* 0x0a44	 621 */		stb	%l1,[%o3]

! Registers live out of .L77003096: 
! g2 g4 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003096 .L900001100

			.L77003098:
/* 0x0a48	 616 */		cmp	%l6,%o7
/* 0x0a4c	     */		add	%o5,1,%o5
/* 0x0a50	     */		add	%o3,1,%o3
/* 0x0a54	     */		add	%g4,1,%g4
/* 0x0a58	     */		add	%o2,1,%o2
/* 0x0a5c	     */		add	%o1,1,%o1
/* 0x0a60	     */		ble,a,pt	%icc,.L900001100
/* 0x0a64	 617 */		ldub	[%o5],%g2

! Registers live out of .L77003098: 
! g2 g4 o0 o1 o2 o3 o5 sp o7 l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003098

			.L900001076:
/* 0x0a68	 616 */		ba	.L900001099
/* 0x0a6c	 624 */		or	%g0,1029,%o1

! Registers live out of .L900001076: 
! o0 o1 sp l2 l4 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003233

			.L77003484:
/* 0x0a70	 616 */		or	%g0,0,%o1

! Registers live out of .L77003484: 
! g4 o0 o1 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003264 .L77003484

			.L77003258:
/* 0x0a74	 617 */		ldub	[%o1+%l3],%o2

! Registers live out of .L77003258: 
! g4 o0 o1 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003258 .L77003260

			.L900001098:
/* 0x0a78	 617 */		cmp	%o2,0
/* 0x0a7c	     */		be,pn	%icc,.L77003260
/* 0x0a80	 618 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900001098: 
! g1 g4 o0 o1 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001098

			.L77003259:
/* 0x0a84	 619 */		stb	%i4,[%o1+%l6]
/* 0x0a88	 620 */		stb	%l0,[%o1+%l5]
/* 0x0a8c	 621 */		stb	%l1,[%o1+%g4]
/* 0x0a90	 618 */		xor	%g1,-704,%g1
/* 0x0a94	     */		add	%g1,%fp,%o2
/* 0x0a98	     */		stb	%i5,[%o1+%o2]

! Registers live out of .L77003259: 
! g4 o0 o1 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003259 .L900001098

			.L77003260:
/* 0x0a9c	 616 */		add	%o1,1,%o1
/* 0x0aa0	     */		cmp	%o1,%i1
/* 0x0aa4	     */		bcs,a,pt	%icc,.L900001098
/* 0x0aa8	 617 */		ldub	[%o1+%l3],%o2

! Registers live out of .L77003260: 
! g4 o0 o1 o2 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003090 .L77003260 .L77003298

			.L77003102:
/* 0x0aac	 624 */		or	%g0,1029,%o1

! Registers live out of .L77003102: 
! o0 o1 sp l2 l4 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003102 .L900001076

			.L900001099:
/* 0x0ab0	 624 */		ld	[%i0+2236],%g5
/* 0x0ab4	     */		jmpl	%g5,%o7
/* 0x0ab8	     */		or	%g0,%i0,%o0
/* 0x0abc	 625 */		sethi	%hi(0x1c00),%o0
/* 0x0ac0	     */		add	%o0,722,%l6
/* 0x0ac4	     */		ldub	[%i0+%l6],%g3
/* 0x0ac8	     */		cmp	%g3,0
/* 0x0acc	     */		be,pn	%icc,.L77003106
/* 0x0ad0	 626 */		sethi	%hi(0x2400),%g1

! Registers live out of .L900001099: 
! g1 o0 o4 sp l2 l4 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001099

			.L77003104:
/* 0x0ad4	 626 */		xor	%g1,-384,%g1
/* 0x0ad8	     */		add	%g1,%fp,%l1
/* 0x0adc	     */		sllx	%l1,32,%o0
/* 0x0ae0	     */		srl	%l3,0,%o4
/* 0x0ae4	     */		or	%o0,%o4,%o5
/* 0x0ae8	     */		sethi	%hi(0x1800),%g1
/* 0x0aec	     */		xor	%g1,-256,%g1
/* 0x0af0	     */		or	%g0,%i3,%o3
/* 0x0af4	     */		or	%g0,%i2,%o2
/* 0x0af8	     */		or	%g0,%i1,%o1
/* 0x0afc	     */		or	%g0,%i0,%o0
/* 0x0b00	     */		stx	%o5,[%sp+96]
/* 0x0b04	     */		add	%g1,%fp,%o5
/* 0x0b08	     */		sethi	%hi(0x1000),%g1
/* 0x0b0c	     */		xor	%g1,-704,%g1
/* 0x0b10	     */		add	%g1,%fp,%g1
/* 0x0b14	     */		st	%l5,[%sp+92]
/* 0x0b18	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0b1c	     */		or	%g0,%g1,%o4
/* 0x0b20	     */		ba	.L900001097
/* 0x0b24	 631 */		ldub	[%i0+%l4],%i4

! Registers live out of .L77003104: 
! o4 sp l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001099

			.L77003106:
/* 0x0b28	 628 */		add	%o0,685,%i5
/* 0x0b2c	     */		ldub	[%i0+%i5],%l0
/* 0x0b30	     */		cmp	%l0,0
/* 0x0b34	     */		be,pn	%icc,.L77003112
/* 0x0b38	 629 */		sethi	%hi(0x2400),%g1

! Registers live out of .L77003106: 
! g1 o4 sp l2 l4 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003106

			.L77003108:
/* 0x0b3c	 629 */		xor	%g1,-384,%g1
/* 0x0b40	     */		add	%g1,%fp,%o3
/* 0x0b44	     */		sethi	%hi(0x1800),%g1
/* 0x0b48	     */		xor	%g1,-256,%g1
/* 0x0b4c	     */		add	%g1,%fp,%o5
/* 0x0b50	     */		sllx	%o3,32,%o1
/* 0x0b54	     */		srl	%l3,0,%o2
/* 0x0b58	     */		sethi	%hi(0x1000),%g1
/* 0x0b5c	     */		or	%o1,%o2,%o7
/* 0x0b60	     */		xor	%g1,-704,%g1
/* 0x0b64	     */		add	%g1,%fp,%g1
/* 0x0b68	     */		or	%g0,%i3,%o3
/* 0x0b6c	     */		or	%g0,%i2,%o2
/* 0x0b70	     */		or	%g0,%i1,%o1
/* 0x0b74	     */		stx	%o7,[%sp+96]
/* 0x0b78	     */		or	%g0,%i0,%o0
/* 0x0b7c	     */		st	%l5,[%sp+92]
/* 0x0b80	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0b84	     */		or	%g0,%g1,%o4

! Registers live out of .L77003108: 
! o4 sp l2 l4 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003106 .L77003108

			.L77003112:
/* 0x0b88	 631 */		ldub	[%i0+%l4],%i4

! Registers live out of .L77003112: 
! o4 sp l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003104 .L77003112

			.L900001097:
/* 0x0b8c	 631 */		cmp	%i4,0
/* 0x0b90	     */		be,pn	%icc,.L77003116
/* 0x0b94	 632 */		sethi	%hi(0x2400),%g1

! Registers live out of .L900001097: 
! g1 o4 sp l2 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001097

			.L77003114:
/* 0x0b98	 632 */		xor	%g1,-384,%g1
/* 0x0b9c	     */		add	%g1,%fp,%i5
/* 0x0ba0	     */		sethi	%hi(0x1800),%g1
/* 0x0ba4	     */		xor	%g1,-256,%g1
/* 0x0ba8	     */		add	%g1,%fp,%o5
/* 0x0bac	     */		sethi	%hi(0x1000),%g1
/* 0x0bb0	     */		xor	%g1,-704,%g1
/* 0x0bb4	     */		add	%g1,%fp,%g1
/* 0x0bb8	     */		or	%g0,%i3,%o3
/* 0x0bbc	     */		or	%g0,%i2,%o2
/* 0x0bc0	     */		or	%g0,%i1,%o1
/* 0x0bc4	     */		st	%l5,[%sp+92]
/* 0x0bc8	     */		or	%g0,%i0,%o0
/* 0x0bcc	     */		st	%i5,[%sp+96]
/* 0x0bd0	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0bd4	     */		or	%g0,%g1,%o4

! Registers live out of .L77003114: 
! o4 sp l2 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003114 .L900001097

			.L77003116:
/* 0x0bd8	 635 */		cmp	%l2,0
/* 0x0bdc	     */		be,pn	%icc,.L77003120
/* 0x0be0	     */		sethi	%hi(0x2400),%g1

! Registers live out of .L77003116: 
! g1 o4 sp l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003116

			.L77003118:
/* 0x0be4	 635 */		xor	%g1,-384,%g1
/* 0x0be8	     */		add	%g1,%fp,%o7
/* 0x0bec	     */		sllx	%o7,32,%o5
/* 0x0bf0	     */		sethi	%hi(0x1800),%g1
/* 0x0bf4	     */		xor	%g1,-256,%g1
/* 0x0bf8	     */		or	%g0,%i3,%o3
/* 0x0bfc	     */		or	%g0,%i2,%o2
/* 0x0c00	     */		or	%g0,%i1,%o1
/* 0x0c04	     */		or	%g0,%i0,%o0
/* 0x0c08	     */		stx	%o5,[%sp+96]
/* 0x0c0c	     */		add	%g1,%fp,%o5
/* 0x0c10	     */		sethi	%hi(0x1000),%g1
/* 0x0c14	     */		xor	%g1,-704,%g1
/* 0x0c18	     */		ld	[%i0+2244],%l6
/* 0x0c1c	     */		add	%g1,%fp,%g1
/* 0x0c20	     */		st	%l5,[%sp+92]
/* 0x0c24	     */		jmpl	%l6,%o7
/* 0x0c28	     */		or	%g0,%g1,%o4
/* 0x0c2c	 636 */		or	%g0,1028,%o1
/* 0x0c30	     */		ld	[%i0+2236],%l5
/* 0x0c34	     */		jmpl	%l5,%o7
/* 0x0c38	     */		or	%g0,%i0,%o0
/* 0x0c3c	 637 */		ld	[%i0+%l7],%l7
/* 0x0c40	     */		andcc	%l7,256,%g0
/* 0x0c44	     */		be,pn	%icc,.L77003163
/* 0x0c48	 640 */		or	%g0,0,%o5

! Registers live out of .L77003118: 
! o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003118

			.L77003124:
/* 0x0c4c	 638 */		ld	[%i0+2204],%l1
/* 0x0c50	     */		ld	[%l1+28],%l2
/* 0x0c54	     */		st	%l2,[%l1+32]
/* 0x0c58	 640 */		ba	.L900001096
/* 0x0c5c	     */		or	%g0,%i3,%o3

! Registers live out of .L77003124: 
! o3 o4 o5 sp i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003116

			.L77003120:
/* 0x0c60	 635 */		xor	%g1,-384,%g1
/* 0x0c64	     */		add	%g1,%fp,%o4
/* 0x0c68	     */		sethi	%hi(0x1800),%g1
/* 0x0c6c	     */		xor	%g1,-256,%g1
/* 0x0c70	     */		add	%g1,%fp,%o5
/* 0x0c74	     */		sllx	%o4,32,%g5
/* 0x0c78	     */		srl	%l3,0,%o0
/* 0x0c7c	     */		sethi	%hi(0x1000),%g1
/* 0x0c80	     */		or	%g5,%o0,%g3
/* 0x0c84	     */		xor	%g1,-704,%g1
/* 0x0c88	     */		add	%g1,%fp,%g1
/* 0x0c8c	     */		or	%g0,%i3,%o3
/* 0x0c90	     */		ld	[%i0+2244],%l4
/* 0x0c94	     */		or	%g0,%i2,%o2
/* 0x0c98	     */		or	%g0,%i1,%o1
/* 0x0c9c	     */		or	%g0,%i0,%o0
/* 0x0ca0	     */		stx	%g3,[%sp+96]
/* 0x0ca4	     */		st	%l5,[%sp+92]
/* 0x0ca8	     */		jmpl	%l4,%o7
/* 0x0cac	     */		or	%g0,%g1,%o4
/* 0x0cb0	 636 */		or	%g0,1028,%o1
/* 0x0cb4	     */		ld	[%i0+2236],%g2
/* 0x0cb8	     */		jmpl	%g2,%o7
/* 0x0cbc	     */		or	%g0,%i0,%o0
/* 0x0cc0	 637 */		ld	[%i0+%l7],%g4
/* 0x0cc4	     */		andcc	%g4,256,%g0
/* 0x0cc8	     */		be,pn	%icc,.L77003163
/* 0x0ccc	 640 */		add	%fp,-1600,%o5

! Registers live out of .L77003120: 
! o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003120

			.L77003330:
/* 0x0cd0	 638 */		ld	[%i0+2204],%i5
/* 0x0cd4	 640 */		or	%g0,%i3,%o3
/* 0x0cd8	 638 */		ld	[%i5+28],%l3
/* 0x0cdc	     */		st	%l3,[%i5+32]

! Registers live out of .L77003330: 
! o3 o4 o5 sp i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003124 .L77003330

			.L900001096:
/* 0x0ce0	 640 */		sethi	%hi(0x2400),%g1
/* 0x0ce4	     */		xor	%g1,-384,%g1
/* 0x0ce8	     */		or	%g0,%i2,%o2
/* 0x0cec	     */		or	%g0,%i0,%o0
/* 0x0cf0	     */		add	%g1,%fp,%g1
/* 0x0cf4	     */		or	%g0,%i1,%o1
/* 0x0cf8	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0cfc	     */		or	%g0,%g1,%o4
/* 0x0d00	 641 */		ld	[%i0+2204],%i0
/* 0x0d04	     */		ld	[%i0+24],%i2
/* 0x0d08	     */		st	%i2,[%i0+32]

! Registers live out of .L900001096: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002976 .L77002984 .L77003014 .L77003022 .L77003088 .L77003118 .L77003120 .L77003146 .L77003148 .L77003170
! predecessor blocks: .L77003182 .L77003186 .L900001096 .L900001108 .L900001109

			.L77003163:
/* 0x0d0c	 527 */		ret	! Result = 
/* 0x0d10	     */		restore	%g0,0,%g0
/* 0x0d14	   0 */		.type	gl_write_monocolor_span,2
/* 0x0d14	   0 */		.size	gl_write_monocolor_span,(.-gl_write_monocolor_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  660		      !         }
!  661		      !      }
!  662		      !   }
!  663		      !}
!  667		      !/*
!  668		      ! * Write a horizontal span of textured pixels to the frame buffer.
!  669		      ! * The color of each pixel is different.
!  670		      ! * Alpha-testing, stenciling, depth-testing, and blending are done
!  671		      ! * as needed.
!  672		      ! * Input:  n - number of pixels in the span
!  673		      ! *         x, y - location of leftmost pixel in the span
!  674		      ! *         z - array of [n] z-values
!  675		      ! *         s, t - array of (s,t) texture coordinates for each pixel
!  676		      ! *         lambda - array of texture lambda values
!  677		      ! *         red, green, blue, alpha - array of [n] color components
!  678		      ! *         primitive - either GL_POINT, GL_LINE, GL_POLYGON or GL_BITMAP.
!  679		      ! */
!  680		      !void gl_write_texture_span( GLcontext *ctx,
!  681		      !                            GLuint n, GLint x, GLint y, GLdepth z[],
!  682		      !			    GLfloat s[], GLfloat t[], GLfloat u[],
!  683		      !                            GLfloat lambda[],
!  684		      !			    GLubyte r[], GLubyte g[],
!  685		      !			    GLubyte b[], GLubyte a[],
!  686		      !			    GLenum primitive )
!  687		      !{

!
! SUBROUTINE gl_write_texture_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_texture_span
                       

			gl_write_texture_span:
/* 000000	 687 */		sethi	%hi(0x2000),%g1
/* 0x0004	     */		xor	%g1,-144,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  688		      !   GLubyte mask[MAX_WIDTH];
!  689		      !   GLboolean write_all = GL_TRUE;
!  690		      !   GLubyte rtmp[MAX_WIDTH], gtmp[MAX_WIDTH], btmp[MAX_WIDTH], atmp[MAX_WIDTH];
!  691		      !   GLubyte *red, *green, *blue, *alpha;
!  693		      !   /* init mask to 1's (all pixels are to be written) */
!  694		      !   MEMSET(mask, 1, n);

/* 0x000c	 694 */		or	%g0,%i1,%o2
/* 0x0010	     */		cmp	%o2,32
/* 0x0014	 687 */		ld	[%fp+120],%l5
/* 0x0018	 694 */		ble	.L900001333
/* 0x001c	     */		or	%g0,1,%o1

! Registers live out of gl_write_texture_span: 
! g1 g2 o0 o1 o2 o4 o5 sp o7 l0 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_texture_span

			.L900001332:
/* 0x0020	 694 */		call	memset	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0024	     */		add	%fp,-1600,%o0
/* 0x0028	     */		ba	.L900001478
/* 0x002c	   0 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001332: 
! g1 g2 o0 o3 o4 o5 sp l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_write_texture_span

			.L900001333:
/* 0x0030	 694 */		sethi	%hi(0x1010000),%o3
/* 0x0034	     */		add	%fp,-1600,%l7
/* 0x0038	     */		add	%o3,257,%g4
/* 0x003c	     */		cmp	%o2,3

! Registers live out of .L900001333: 
! g1 g2 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001333 .L900001336

			.L900001479:
/* 0x0040	 694 */		bleu	.L900001338
/* 0x0044	     */		nop

! Registers live out of .L900001479: 
! g1 g2 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001479

			.L900001336:
/* 0x0048	 694 */		sub	%o2,4,%o2
/* 0x004c	     */		st	%g4,[%l7]
/* 0x0050	     */		add	%l7,4,%l7
/* 0x0054	     */		ba	.L900001479
/* 0x0058	     */		cmp	%o2,3

! Registers live out of .L900001336: 
! g1 g2 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001479

			.L900001338:
/* 0x005c	 694 */		andcc	%o2,3,%g0
/* 0x0060	     */		be	.L900001342
/* 0x0064	     */		cmp	%o2,0

! Registers live out of .L900001338: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001338

			.L900001433:
/* 0x0068	 694 */		bl,a	.L900001477
/* 0x006c	     */		subcc	%o2,1,%o2

! Registers live out of .L900001433: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001433

			.L900001436:
/* 0x0070	 694 */		cmp	%o2,2
/* 0x0074	     */		bl	.L900001432
/* 0x0078	     */		nop

! Registers live out of .L900001436: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001436

			.L900001437:
/* 0x007c	 694 */		or	%g0,%o2,%g5

! Registers live out of .L900001437: 
! g1 g2 g5 o0 o1 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001435 .L900001437

			.L900001435:
/* 0x0080	 694 */		stb	%o1,[%l7]
/* 0x0084	     */		sub	%g5,2,%g5
/* 0x0088	     */		add	%l7,2,%l7
/* 0x008c	     */		cmp	%g5,1
/* 0x0090	     */		bg	.L900001435
/* 0x0094	     */		stb	%o1,[%l7-1]

! Registers live out of .L900001435: 
! g1 g2 g5 o0 o1 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001435

			.L900001438:
/* 0x0098	 694 */		cmp	%g5,0
/* 0x009c	     */		ble	.L900001434
/* 0x00a0	     */		nop

! Registers live out of .L900001438: 
! g1 g2 o0 o1 o3 o4 o5 sp l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001436 .L900001438

			.L900001432:
/* 0x00a4	 694 */		stb	%o1,[%l7]

! Registers live out of .L900001432: 
! g1 g2 o0 o3 o4 o5 sp l0 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001432 .L900001438

			.L900001434:
/* 0x00a8	 694 */		ba	.L900001478
/* 0x00ac	   0 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001434: 
! g1 g2 o0 o3 o4 o5 sp l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001340 .L900001433

			.L900001477:
/* 0x00b0	 694 */		be	.L900001342
/* 0x00b4	     */		stb	%o1,[%l7]

! Registers live out of .L900001477: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001477

			.L900001340:
/* 0x00b8	 694 */		add	%l7,1,%l7
/* 0x00bc	     */		subcc	%o2,1,%o2
/* 0x00c0	     */		stb	%o1,[%l7]
/* 0x00c4	     */		add	%l7,1,%l7
/* 0x00c8	     */		bne	.L900001477
/* 0x00cc	     */		subcc	%o2,1,%o2

! Registers live out of .L900001340: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l2 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001338 .L900001340 .L900001477

			.L900001342:
/* 0x00d0	   0 */		sethi	%hi(0xe000),%l7

! Registers live out of .L900001342: 
! g1 g2 o0 o3 o4 o5 sp l0 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  696		      !   if ((ctx->RasterMask & WINCLIP_BIT) || primitive==GL_BITMAP) {

                       
! predecessor blocks: .L900001332 .L900001342 .L900001434

			.L900001478:
/* 0x00d4	 696 */		add	%l7,264,%l1
/* 0x00d8	     */		ld	[%i0+%l1],%o1
/* 0x00dc	     */		andcc	%o1,512,%g0
/* 0x00e0	     */		bne,pn	%icc,.L77003516
/* 0x00e4	     */		sethi	%hi(0x1800),%l4

! Registers live out of .L900001478: 
! g1 g2 o0 o3 o4 o5 sp l0 l1 l2 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001478

			.L77003512:
/* 0x00e8	 696 */		add	%l4,512,%l0
/* 0x00ec	     */		cmp	%l5,%l0
/* 0x00f0	     */		bne,pt	%icc,.L900001476
/* 0x00f4	 689 */		or	%g0,1,%l7

! Registers live out of .L77003512: 
! g1 g2 o0 o3 o4 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003512 .L900001478

			.L77003516:
/* 0x00f8	 128 */		cmp	%i3,0
/* 0x00fc	     */		bl,pn	%icc,.L77003657
/* 0x0100	     */		nop

! Registers live out of .L77003516: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003516

			.L77003661:
/* 0x0104	 128 */		ld	[%i0+2204],%g2
/* 0x0108	     */		ld	[%g2+8],%g3
/* 0x010c	     */		cmp	%i3,%g3
/* 0x0110	     */		bge,pn	%icc,.L77003657
/* 0x0114	 133 */		cmp	%i2,0

! Registers live out of .L77003661: 
! g1 g2 o0 o3 o4 o5 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003661

			.L77003667:
/* 0x0118	 133 */		bl,pn	%icc,.L77003673
/* 0x011c	     */		add	%i2,%i1,%l7

! Registers live out of .L77003667: 
! g1 g2 o0 o3 o4 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003667

			.L77003669:
/* 0x0120	 133 */		ld	[%g2+4],%l4
/* 0x0124	     */		cmp	%l7,%l4
/* 0x0128	     */		bg,pn	%icc,.L77003673
/* 0x012c	 147 */		ldx	[%fp+104],%o1

! Registers live out of .L77003669: 
! g1 g2 o0 o1 o3 o4 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  697		      !      if (clip_span( ctx,n,x,y,mask)==0) {
!  698		      !	 return;
!  699		      !      }
!  700		      !      write_all = GL_FALSE;

                       
! predecessor blocks: .L77003669

			.L77003671:
/* 0x0130	 700 */		or	%g0,0,%l7
/* 0x0134	 147 */		ldx	[%fp+112],%g4
/* 0x0138	     */		srl	%o1,0,%l6
/* 0x013c	     */		st	%g4,[%sp+108]
/* 0x0140	     */		srlx	%g4,32,%o7
/* 0x0144	     */		srlx	%o1,32,%l4
/* 0x0148	     */		st	%o7,[%sp+112]
/* 0x014c	 135 */		ba	.L900001473
/* 0x0150	 704 */		sethi	%hi(0x1800),%l2

! Registers live out of .L77003671: 
! g1 g2 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003667 .L77003669

			.L77003673:
/* 0x0154	 137 */		cmp	%l7,0
/* 0x0158	     */		ble,pn	%icc,.L77003657
/* 0x015c	     */		nop

! Registers live out of .L77003673: 
! g1 g2 o0 o3 o4 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003673

			.L77003677:
/* 0x0160	 141 */		ld	[%g2+4],%l6
/* 0x0164	     */		cmp	%i2,%l6
/* 0x0168	     */		bge,pn	%icc,.L77003657
/* 0x016c	 147 */		cmp	%i1,0

! Registers live out of .L77003677: 
! g1 o0 o3 o4 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003677

			.L77003745:
/* 0x0170	 141 */		ldx	[%fp+112],%g4
/* 0x0174	     */		ldx	[%fp+104],%o1
/* 0x0178	     */		st	%g4,[%sp+108]
/* 0x017c	     */		srlx	%g4,32,%g2
/* 0x0180	     */		srl	%o1,0,%l6
/* 0x0184	     */		srlx	%o1,32,%l4
/* 0x0188	     */		st	%g2,[%sp+112]
/* 0x018c	 147 */		ble,a,pn	%icc,.L77003522
/* 0x0190	 700 */		or	%g0,0,%l7

! Registers live out of .L77003745: 
! g1 g2 o0 o1 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003745

			.L77003764:
/* 0x0194	 147 */		or	%g0,0,%o7
/* 0x0198	     */		add	%i1,-1,%o2
/* 0x019c	 697 */		or	%g0,%i2,%l1
/* 0x01a0	     */		add	%fp,-1600,%l3
/* 0x01a4	 148 */		cmp	%i2,0

! Registers live out of .L77003764: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003764 .L900001475

			.L900001474:
/* 0x01a8	 148 */		bl,a,pn	%icc,.L77003693
/* 0x01ac	 149 */		stb	%g0,[%l3]

! Registers live out of .L900001474: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001474

			.L77003687:
/* 0x01b0	 148 */		ld	[%i0+2204],%l2
/* 0x01b4	     */		ld	[%l2+4],%l0
/* 0x01b8	     */		cmp	%l1,%l0
/* 0x01bc	     */		bl,a,pt	%icc,.L900001475
/* 0x01c0	 147 */		add	%o7,1,%o7

! Registers live out of .L77003687: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003687

			.L77003691:
/* 0x01c4	 149 */		stb	%g0,[%l3]

! Registers live out of .L77003691: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003691 .L900001474

			.L77003693:
/* 0x01c8	 147 */		add	%o7,1,%o7

! Registers live out of .L77003693: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003687 .L77003693

			.L900001475:
/* 0x01cc	 147 */		cmp	%o7,%o2
/* 0x01d0	     */		add	%l1,1,%l1
/* 0x01d4	     */		add	%l3,1,%l3
/* 0x01d8	     */		ble,pt	%icc,.L900001474
/* 0x01dc	 148 */		cmp	%l1,0

! Registers live out of .L900001475: 
! g1 g2 o0 o1 o2 o3 o4 o5 sp o7 l0 l1 l2 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001475

			.L77003520:
/* 0x01e0	 700 */		or	%g0,0,%l7
/* 0x01e4	     */		ba	.L900001473
/* 0x01e8	 704 */		sethi	%hi(0x1800),%l2

! Registers live out of .L77003520: 
! g1 g2 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003512

			.L900001476:
/* 0x01ec	 689 */		ldx	[%fp+112],%o5
/* 0x01f0	     */		ldx	[%fp+104],%o7
/* 0x01f4	     */		st	%o5,[%sp+108]
/* 0x01f8	     */		srlx	%o5,32,%o3
/* 0x01fc	     */		srlx	%o7,32,%l4
/* 0x0200	     */		st	%o3,[%sp+112]
/* 0x0204	     */		srl	%o7,0,%l6

! Registers live out of .L900001476: 
! g1 g2 o0 o3 o5 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  701		      !   }
!  704		      !   if (primitive==GL_BITMAP || (ctx->RasterMask & FRONT_AND_BACK_BIT)) {

                       
! predecessor blocks: .L77003745 .L900001476

			.L77003522:
/* 0x0208	 704 */		sethi	%hi(0x1800),%l2

! Registers live out of .L77003522: 
! g1 g2 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003520 .L77003522 .L77003671

			.L900001473:
/* 0x020c	 704 */		add	%l2,512,%l3
/* 0x0210	     */		cmp	%l5,%l3
/* 0x0214	     */		be,pn	%icc,.L77003528
/* 0x0218	     */		sethi	%hi(0xe000),%l0

! Registers live out of .L900001473: 
! g1 g2 o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001473

			.L77003524:
/* 0x021c	 704 */		add	%l0,264,%l1
/* 0x0220	     */		ld	[%i0+%l1],%l3
/* 0x0224	     */		andcc	%l3,1024,%g0
/* 0x0228	     */		bne,pn	%icc,.L77003528
/* 0x022c	 719 */		ld	[%sp+108],%l3

! Registers live out of .L77003524: 
! g1 g2 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  705		      !      /* must make a copy of the colors since they may be modified */
!  706		      !      MEMCPY( rtmp, r, n * sizeof(GLubyte) );
!  707		      !      MEMCPY( gtmp, g, n * sizeof(GLubyte) );
!  708		      !      MEMCPY( btmp, b, n * sizeof(GLubyte) );
!  709		      !      MEMCPY( atmp, a, n * sizeof(GLubyte) );
!  710		      !      red = rtmp;
!  711		      !      green = gtmp;
!  712		      !      blue = btmp;
!  713		      !      alpha = atmp;
!  714		      !   }
!  715		      !   else {
!  716		      !      red   = r;
!  717		      !      green = g;
!  718		      !      blue  = b;

                       
! predecessor blocks: .L77003524

			.L77003530:
/* 0x0230	 718 */		ld	[%sp+112],%l0
/* 0x0234	 717 */		or	%g0,%l6,%l1
/* 0x0238	 716 */		or	%g0,%l4,%l2

!  719		      !      alpha = a;

/* 0x023c	 719 */		ba	.L900001472
/* 0x0240	 724 */		st	%l4,[%sp+92]

! Registers live out of .L77003530: 
! o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003524 .L900001473

			.L77003528:
/* 0x0244	 706 */		or	%g0,%i1,%o2
/* 0x0248	     */		cmp	%o2,32
/* 0x024c	     */		bg	.L900001328
/* 0x0250	     */		or	%g0,%l4,%o1

! Registers live out of .L77003528: 
! g1 g2 o0 o1 o2 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003528

			.L900001316:
/* 0x0254	 706 */		and	%o1,3,%g5
/* 0x0258	     */		orcc	%g5,0,%g0
/* 0x025c	     */		be	.L900001321
/* 0x0260	     */		add	%fp,-3200,%g5

! Registers live out of .L900001316: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001316

			.L900001317:
/* 0x0264	 706 */		subcc	%o2,2,%o2
/* 0x0268	     */		bl	.L900001319
/* 0x026c	     */		sub	%o2,-2,%o4

! Registers live out of .L900001317: 
! g1 g2 g5 o0 o1 o2 o3 o4 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001317

			.L900001429:
/* 0x0270	 706 */		srl	%o4,31,%o0
/* 0x0274	     */		add	%o4,%o0,%l0
/* 0x0278	     */		sra	%l0,1,%l1
/* 0x027c	     */		cmp	%l1,1
/* 0x0280	     */		bl	.L900001318
/* 0x0284	     */		nop

! Registers live out of .L900001429: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001429

			.L900001430:
/* 0x0288	 706 */		or	%g0,%o2,%o3
/* 0x028c	     */		add	%fp,-3200,%o7
/* 0x0290	     */		or	%g0,%o1,%o0

! Registers live out of .L900001430: 
! g1 g2 o0 o3 o5 sp o7 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001428 .L900001430

			.L900001428:
/* 0x0294	 706 */		sub	%o3,2,%o3
/* 0x0298	     */		add	%o7,2,%o7
/* 0x029c	     */		ldub	[%o0],%l2
/* 0x02a0	     */		cmp	%o3,0
/* 0x02a4	     */		add	%o0,2,%o0
/* 0x02a8	     */		stb	%l2,[%o7-2]
/* 0x02ac	     */		ldub	[%o0-1],%l3
/* 0x02b0	     */		bge	.L900001428
/* 0x02b4	     */		stb	%l3,[%o7-1]

! Registers live out of .L900001428: 
! g1 g2 o0 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001428

			.L900001431:
/* 0x02b8	 706 */		or	%g0,%o3,%o2
/* 0x02bc	     */		or	%g0,%o7,%g5
/* 0x02c0	     */		or	%g0,%o0,%o1
/* 0x02c4	     */		ba	.L900001319
/* 0x02c8	     */		nop

! Registers live out of .L900001431: 
! g5 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001429

			.L900001318:
/* 0x02cc	 706 */		subcc	%o2,2,%o2

! Registers live out of .L900001318: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001318 .L900001471

			.L900001471:
/* 0x02d0	 706 */		ldub	[%o1],%l2
/* 0x02d4	     */		stb	%l2,[%g5]
/* 0x02d8	     */		ldub	[%o1+1],%l3
/* 0x02dc	     */		add	%o1,2,%o1
/* 0x02e0	     */		stb	%l3,[%g5+1]
/* 0x02e4	     */		add	%g5,2,%g5
/* 0x02e8	     */		bge,a	.L900001471
/* 0x02ec	     */		subcc	%o2,2,%o2

! Registers live out of .L900001471: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001317 .L900001431 .L900001471

			.L900001319:
/* 0x02f0	 706 */		cmp	%o2,-1
/* 0x02f4	     */		bl	.L900001469
/* 0x02f8	 707 */		or	%g0,%i1,%o2

! Registers live out of .L900001319: 
! g5 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001319

			.L900001320:
/* 0x02fc	 706 */		ldub	[%o1],%g3
/* 0x0300	     */		stb	%g3,[%g5]
/* 0x0304	     */		ba	.L900001469
/* 0x0308	 707 */		or	%g0,%i1,%o2

! Registers live out of .L900001320: 
! o0 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001316

			.L900001321:
/* 0x030c	 706 */		subcc	%o2,4,%o3
/* 0x0310	     */		bl	.L900001324
/* 0x0314	     */		sra	%o2,1,%o7

! Registers live out of .L900001321: 
! g1 g2 g5 o0 o1 o2 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001321

			.L900001369:
/* 0x0318	 706 */		srl	%o7,30,%o4
/* 0x031c	     */		add	%o2,%o4,%l1
/* 0x0320	     */		sra	%l1,2,%l0
/* 0x0324	     */		cmp	%l0,1
/* 0x0328	     */		bl	.L900001322
/* 0x032c	     */		nop

! Registers live out of .L900001369: 
! g1 g2 g5 o0 o1 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001369

			.L900001370:
/* 0x0330	 706 */		or	%g0,%o1,%g3

! Registers live out of .L900001370: 
! g1 g2 g3 g5 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001368 .L900001370

			.L900001368:
/* 0x0334	 706 */		sub	%o3,4,%o3
/* 0x0338	     */		add	%g5,4,%g5
/* 0x033c	     */		ld	[%g3],%f0
/* 0x0340	     */		cmp	%o3,0
/* 0x0344	     */		add	%g3,4,%g3
/* 0x0348	     */		bge	.L900001368
/* 0x034c	     */		st	%f0,[%g5-4]

! Registers live out of .L900001368: 
! g1 g2 g3 g5 o0 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001368

			.L900001371:
/* 0x0350	 706 */		or	%g0,%g3,%o1
/* 0x0354	     */		ba	.L900001323
/* 0x0358	     */		nop

! Registers live out of .L900001371: 
! g5 o0 o1 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001369

			.L900001322:
/* 0x035c	 706 */		subcc	%o3,4,%o3

! Registers live out of .L900001322: 
! g1 g2 g5 o0 o1 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001322 .L900001470

			.L900001470:
/* 0x0360	 706 */		ld	[%o1],%f0
/* 0x0364	     */		add	%o1,4,%o1
/* 0x0368	     */		st	%f0,[%g5]
/* 0x036c	     */		add	%g5,4,%g5
/* 0x0370	     */		bge,a	.L900001470
/* 0x0374	     */		subcc	%o3,4,%o3

! Registers live out of .L900001470: 
! g1 g2 g5 o0 o1 o3 o5 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001371 .L900001470

			.L900001323:
/* 0x0378	 706 */		add	%o3,4,%o2

! Registers live out of .L900001323: 
! g5 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001321 .L900001323

			.L900001324:
/* 0x037c	 706 */		andcc	%i1,3,%g0
/* 0x0380	     */		be	.L900001330
/* 0x0384	     */		subcc	%o2,1,%o2

! Registers live out of .L900001324: 
! g5 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001324

			.L900001325:
/* 0x0388	 706 */		ldub	[%o1],%g2
/* 0x038c	     */		ble	.L900001330
/* 0x0390	     */		stb	%g2,[%g5]

! Registers live out of .L900001325: 
! g5 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001325

			.L900001326:
/* 0x0394	 706 */		ldub	[%o1+1],%o5
/* 0x0398	     */		subcc	%o2,1,%o2
/* 0x039c	     */		ble	.L900001330
/* 0x03a0	     */		stb	%o5,[%g5+1]

! Registers live out of .L900001326: 
! g5 o0 o1 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001326

			.L900001327:
/* 0x03a4	 706 */		ldub	[%o1+2],%o2
/* 0x03a8	     */		stb	%o2,[%g5+2]
/* 0x03ac	     */		ba	.L900001469
/* 0x03b0	 707 */		or	%g0,%i1,%o2

! Registers live out of .L900001327: 
! o0 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003528

			.L900001328:
/* 0x03b4	 706 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x03b8	     */		add	%fp,-3200,%o0

! Registers live out of .L900001328: 
! o0 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001324 .L900001325 .L900001326 .L900001328

			.L900001330:
/* 0x03bc	 707 */		or	%g0,%i1,%o2

! Registers live out of .L900001330: 
! o0 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001319 .L900001320 .L900001327 .L900001330

			.L900001469:
/* 0x03c0	 707 */		cmp	%o2,32
/* 0x03c4	     */		or	%g0,%l6,%o1
/* 0x03c8	     */		bg	.L900001312
/* 0x03cc	     */		sethi	%hi(0x1000),%g1

! Registers live out of .L900001469: 
! g1 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001469

			.L900001300:
/* 0x03d0	 707 */		and	%o1,3,%o7
/* 0x03d4	     */		xor	%g1,-704,%g1
/* 0x03d8	     */		orcc	%o7,0,%g0
/* 0x03dc	     */		add	%g1,%fp,%g1
/* 0x03e0	     */		be	.L900001305
/* 0x03e4	     */		or	%g0,%g1,%o7

! Registers live out of .L900001300: 
! g1 o0 o1 o2 o3 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001300

			.L900001301:
/* 0x03e8	 707 */		subcc	%o2,2,%o2
/* 0x03ec	     */		bl	.L900001303
/* 0x03f0	     */		sub	%o2,-2,%o5

! Registers live out of .L900001301: 
! g1 o0 o1 o2 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001301

			.L900001425:
/* 0x03f4	 707 */		srl	%o5,31,%g2
/* 0x03f8	     */		add	%o5,%g2,%g4
/* 0x03fc	     */		sra	%g4,1,%o5
/* 0x0400	     */		cmp	%o5,1
/* 0x0404	     */		bl	.L900001302
/* 0x0408	     */		nop

! Registers live out of .L900001425: 
! g1 o0 o1 o2 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001425

			.L900001426:
/* 0x040c	 707 */		sethi	%hi(0x1000),%g1
/* 0x0410	     */		xor	%g1,-704,%g1
/* 0x0414	     */		add	%g1,%fp,%g1
/* 0x0418	     */		or	%g0,%o2,%g2
/* 0x041c	     */		or	%g0,%g1,%g4
/* 0x0420	     */		or	%g0,%o1,%g3

! Registers live out of .L900001426: 
! g1 g2 g3 g4 o0 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001424 .L900001426

			.L900001424:
/* 0x0424	 707 */		sub	%g2,2,%g2
/* 0x0428	     */		add	%g4,2,%g4
/* 0x042c	     */		ldub	[%g3],%o3
/* 0x0430	     */		cmp	%g2,0
/* 0x0434	     */		add	%g3,2,%g3
/* 0x0438	     */		stb	%o3,[%g4-2]
/* 0x043c	     */		ldub	[%g3-1],%o5
/* 0x0440	     */		bge	.L900001424
/* 0x0444	     */		stb	%o5,[%g4-1]

! Registers live out of .L900001424: 
! g1 g2 g3 g4 o0 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001424

			.L900001427:
/* 0x0448	 707 */		or	%g0,%g2,%o2
/* 0x044c	     */		or	%g0,%g4,%o7
/* 0x0450	     */		or	%g0,%g3,%o1
/* 0x0454	     */		ba	.L900001303
/* 0x0458	     */		nop

! Registers live out of .L900001427: 
! o0 o1 o2 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001425

			.L900001302:
/* 0x045c	 707 */		subcc	%o2,2,%o2

! Registers live out of .L900001302: 
! g1 o0 o1 o2 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001302 .L900001468

			.L900001468:
/* 0x0460	 707 */		ldub	[%o1],%o3
/* 0x0464	     */		stb	%o3,[%o7]
/* 0x0468	     */		ldub	[%o1+1],%o5
/* 0x046c	     */		add	%o1,2,%o1
/* 0x0470	     */		stb	%o5,[%o7+1]
/* 0x0474	     */		add	%o7,2,%o7
/* 0x0478	     */		bge,a	.L900001468
/* 0x047c	     */		subcc	%o2,2,%o2

! Registers live out of .L900001468: 
! g1 o0 o1 o2 o3 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001301 .L900001427 .L900001468

			.L900001303:
/* 0x0480	 707 */		cmp	%o2,-1
/* 0x0484	     */		bl	.L900001466
/* 0x0488	 708 */		or	%g0,%i1,%o2

! Registers live out of .L900001303: 
! o0 o1 o2 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001303

			.L900001304:
/* 0x048c	 707 */		ldub	[%o1],%l0
/* 0x0490	     */		stb	%l0,[%o7]
/* 0x0494	     */		ba	.L900001466
/* 0x0498	 708 */		or	%g0,%i1,%o2

! Registers live out of .L900001304: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001300

			.L900001305:
/* 0x049c	 707 */		subcc	%o2,4,%o5
/* 0x04a0	     */		bl	.L900001308
/* 0x04a4	     */		sra	%o2,1,%g2

! Registers live out of .L900001305: 
! g1 g2 o0 o1 o2 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001305

			.L900001373:
/* 0x04a8	 707 */		srl	%g2,30,%g3
/* 0x04ac	     */		add	%o2,%g3,%l2
/* 0x04b0	     */		sra	%l2,2,%l3
/* 0x04b4	     */		cmp	%l3,1
/* 0x04b8	     */		bl	.L900001306
/* 0x04bc	     */		nop

! Registers live out of .L900001373: 
! g1 o0 o1 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001373

			.L900001374:
/* 0x04c0	 707 */		or	%g0,%o1,%g4

! Registers live out of .L900001374: 
! g1 g4 o0 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001372 .L900001374

			.L900001372:
/* 0x04c4	 707 */		sub	%o5,4,%o5
/* 0x04c8	     */		add	%o7,4,%o7
/* 0x04cc	     */		ld	[%g4],%f0
/* 0x04d0	     */		cmp	%o5,0
/* 0x04d4	     */		add	%g4,4,%g4
/* 0x04d8	     */		bge	.L900001372
/* 0x04dc	     */		st	%f0,[%o7-4]

! Registers live out of .L900001372: 
! g1 g4 o0 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001372

			.L900001375:
/* 0x04e0	 707 */		or	%g0,%g4,%o1
/* 0x04e4	     */		ba	.L900001307
/* 0x04e8	     */		nop

! Registers live out of .L900001375: 
! o0 o1 o3 o5 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001373

			.L900001306:
/* 0x04ec	 707 */		subcc	%o5,4,%o5

! Registers live out of .L900001306: 
! g1 o0 o1 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001306 .L900001467

			.L900001467:
/* 0x04f0	 707 */		ld	[%o1],%f0
/* 0x04f4	     */		add	%o1,4,%o1
/* 0x04f8	     */		st	%f0,[%o7]
/* 0x04fc	     */		add	%o7,4,%o7
/* 0x0500	     */		bge,a	.L900001467
/* 0x0504	     */		subcc	%o5,4,%o5

! Registers live out of .L900001467: 
! g1 o0 o1 o3 o5 sp o7 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001375 .L900001467

			.L900001307:
/* 0x0508	 707 */		add	%o5,4,%o2

! Registers live out of .L900001307: 
! o0 o1 o2 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001305 .L900001307

			.L900001308:
/* 0x050c	 707 */		andcc	%i1,3,%g0
/* 0x0510	     */		be	.L900001314
/* 0x0514	     */		subcc	%o2,1,%o2

! Registers live out of .L900001308: 
! o0 o1 o2 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001308

			.L900001309:
/* 0x0518	 707 */		ldub	[%o1],%l1
/* 0x051c	     */		ble	.L900001314
/* 0x0520	     */		stb	%l1,[%o7]

! Registers live out of .L900001309: 
! o0 o1 o2 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001309

			.L900001310:
/* 0x0524	 707 */		ldub	[%o1+1],%o0
/* 0x0528	     */		subcc	%o2,1,%o2
/* 0x052c	     */		ble	.L900001314
/* 0x0530	     */		stb	%o0,[%o7+1]

! Registers live out of .L900001310: 
! o0 o1 o3 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001310

			.L900001311:
/* 0x0534	 707 */		ldub	[%o1+2],%o4
/* 0x0538	     */		stb	%o4,[%o7+2]
/* 0x053c	     */		ba	.L900001466
/* 0x0540	 708 */		or	%g0,%i1,%o2

! Registers live out of .L900001311: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001469

			.L900001312:
/* 0x0544	 707 */		xor	%g1,-704,%g1
/* 0x0548	     */		add	%g1,%fp,%g1
/* 0x054c	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0550	     */		or	%g0,%g1,%o0

! Registers live out of .L900001312: 
! o0 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001308 .L900001309 .L900001310 .L900001312

			.L900001314:
/* 0x0554	 708 */		or	%g0,%i1,%o2

! Registers live out of .L900001314: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001303 .L900001304 .L900001311 .L900001314

			.L900001466:
/* 0x0558	 708 */		cmp	%o2,32
/* 0x055c	     */		ld	[%sp+112],%o1
/* 0x0560	     */		bg	.L900001296
/* 0x0564	     */		sethi	%hi(0x1800),%g1

! Registers live out of .L900001466: 
! g1 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001466

			.L900001284:
/* 0x0568	 708 */		and	%o1,3,%g2
/* 0x056c	     */		xor	%g1,-256,%g1
/* 0x0570	     */		orcc	%g2,0,%g0
/* 0x0574	     */		add	%g1,%fp,%g1
/* 0x0578	     */		be	.L900001289
/* 0x057c	     */		or	%g0,%g1,%g2

! Registers live out of .L900001284: 
! g1 g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001284

			.L900001285:
/* 0x0580	 708 */		subcc	%o2,2,%o2
/* 0x0584	     */		bl	.L900001287
/* 0x0588	     */		sub	%o2,-2,%o3

! Registers live out of .L900001285: 
! g1 g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001285

			.L900001421:
/* 0x058c	 708 */		srl	%o3,31,%g3
/* 0x0590	     */		add	%o3,%g3,%o3
/* 0x0594	     */		sra	%o3,1,%g5
/* 0x0598	     */		cmp	%g5,1
/* 0x059c	     */		bl	.L900001286
/* 0x05a0	     */		nop

! Registers live out of .L900001421: 
! g1 g2 o0 o1 o2 o3 sp l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001421

			.L900001422:
/* 0x05a4	 708 */		sethi	%hi(0x1800),%g1
/* 0x05a8	     */		xor	%g1,-256,%g1
/* 0x05ac	     */		add	%g1,%fp,%g1
/* 0x05b0	     */		or	%g0,%g1,%o4
/* 0x05b4	     */		or	%g0,%o1,%o7

! Registers live out of .L900001422: 
! g1 o0 o2 o3 o4 sp o7 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001420 .L900001422

			.L900001420:
/* 0x05b8	 708 */		sub	%o2,2,%o2
/* 0x05bc	     */		add	%o4,2,%o4
/* 0x05c0	     */		ldub	[%o7],%l2
/* 0x05c4	     */		cmp	%o2,0
/* 0x05c8	     */		add	%o7,2,%o7
/* 0x05cc	     */		stb	%l2,[%o4-2]
/* 0x05d0	     */		ldub	[%o7-1],%l3
/* 0x05d4	     */		bge	.L900001420
/* 0x05d8	     */		stb	%l3,[%o4-1]

! Registers live out of .L900001420: 
! g1 o0 o2 o3 o4 sp o7 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001420

			.L900001423:
/* 0x05dc	 708 */		or	%g0,%o4,%g2
/* 0x05e0	     */		or	%g0,%o7,%o1
/* 0x05e4	     */		ba	.L900001287
/* 0x05e8	     */		nop

! Registers live out of .L900001423: 
! g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001421

			.L900001286:
/* 0x05ec	 708 */		subcc	%o2,2,%o2

! Registers live out of .L900001286: 
! g1 g2 o0 o1 o2 o3 sp l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001286 .L900001465

			.L900001465:
/* 0x05f0	 708 */		ldub	[%o1],%l2
/* 0x05f4	     */		stb	%l2,[%g2]
/* 0x05f8	     */		ldub	[%o1+1],%l3
/* 0x05fc	     */		add	%o1,2,%o1
/* 0x0600	     */		stb	%l3,[%g2+1]
/* 0x0604	     */		add	%g2,2,%g2
/* 0x0608	     */		bge,a	.L900001465
/* 0x060c	     */		subcc	%o2,2,%o2

! Registers live out of .L900001465: 
! g1 g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001285 .L900001423 .L900001465

			.L900001287:
/* 0x0610	 708 */		cmp	%o2,-1
/* 0x0614	     */		bl	.L900001463
/* 0x0618	 709 */		or	%g0,%i1,%o2

! Registers live out of .L900001287: 
! g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001287

			.L900001288:
/* 0x061c	 708 */		ldub	[%o1],%o2
/* 0x0620	     */		stb	%o2,[%g2]
/* 0x0624	     */		ba	.L900001463
/* 0x0628	 709 */		or	%g0,%i1,%o2

! Registers live out of .L900001288: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001284

			.L900001289:
/* 0x062c	 708 */		subcc	%o2,4,%l2
/* 0x0630	     */		bl	.L900001292
/* 0x0634	     */		sra	%o2,1,%l1

! Registers live out of .L900001289: 
! g1 g2 o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001289

			.L900001377:
/* 0x0638	 708 */		srl	%l1,30,%l0
/* 0x063c	     */		add	%o2,%l0,%o2
/* 0x0640	     */		sra	%o2,2,%o5
/* 0x0644	     */		cmp	%o5,1
/* 0x0648	     */		bl	.L900001290
/* 0x064c	     */		nop

! Registers live out of .L900001377: 
! g1 g2 o0 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001377

			.L900001378:
/* 0x0650	 708 */		or	%g0,%o1,%o2

! Registers live out of .L900001378: 
! g1 g2 o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001376 .L900001378

			.L900001376:
/* 0x0654	 708 */		sub	%l2,4,%l2
/* 0x0658	     */		add	%g2,4,%g2
/* 0x065c	     */		ld	[%o2],%f2
/* 0x0660	     */		cmp	%l2,0
/* 0x0664	     */		add	%o2,4,%o2
/* 0x0668	     */		bge	.L900001376
/* 0x066c	     */		st	%f2,[%g2-4]

! Registers live out of .L900001376: 
! g1 g2 o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001376

			.L900001379:
/* 0x0670	 708 */		or	%g0,%o2,%o1
/* 0x0674	     */		ba	.L900001291
/* 0x0678	     */		nop

! Registers live out of .L900001379: 
! g2 o0 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001377

			.L900001290:
/* 0x067c	 708 */		subcc	%l2,4,%l2

! Registers live out of .L900001290: 
! g1 g2 o0 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001290 .L900001464

			.L900001464:
/* 0x0680	 708 */		ld	[%o1],%f2
/* 0x0684	     */		add	%o1,4,%o1
/* 0x0688	     */		st	%f2,[%g2]
/* 0x068c	     */		add	%g2,4,%g2
/* 0x0690	     */		bge,a	.L900001464
/* 0x0694	     */		subcc	%l2,4,%l2

! Registers live out of .L900001464: 
! g1 g2 o0 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001379 .L900001464

			.L900001291:
/* 0x0698	 708 */		add	%l2,4,%o2

! Registers live out of .L900001291: 
! g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001289 .L900001291

			.L900001292:
/* 0x069c	 708 */		andcc	%i1,3,%g0
/* 0x06a0	     */		be	.L900001298
/* 0x06a4	     */		subcc	%o2,1,%o2

! Registers live out of .L900001292: 
! g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001292

			.L900001293:
/* 0x06a8	 708 */		ldub	[%o1],%g3
/* 0x06ac	     */		ble	.L900001298
/* 0x06b0	     */		stb	%g3,[%g2]

! Registers live out of .L900001293: 
! g2 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001293

			.L900001294:
/* 0x06b4	 708 */		ldub	[%o1+1],%g4
/* 0x06b8	     */		subcc	%o2,1,%o2
/* 0x06bc	     */		ble	.L900001298
/* 0x06c0	     */		stb	%g4,[%g2+1]

! Registers live out of .L900001294: 
! g2 o0 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001294

			.L900001295:
/* 0x06c4	 708 */		ldub	[%o1+2],%o1
/* 0x06c8	     */		stb	%o1,[%g2+2]
/* 0x06cc	     */		ba	.L900001463
/* 0x06d0	 709 */		or	%g0,%i1,%o2

! Registers live out of .L900001295: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001466

			.L900001296:
/* 0x06d4	 708 */		xor	%g1,-256,%g1
/* 0x06d8	     */		add	%g1,%fp,%g1
/* 0x06dc	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x06e0	     */		or	%g0,%g1,%o0

! Registers live out of .L900001296: 
! o0 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001292 .L900001293 .L900001294 .L900001296

			.L900001298:
/* 0x06e4	 709 */		or	%g0,%i1,%o2

! Registers live out of .L900001298: 
! o0 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001287 .L900001288 .L900001295 .L900001298

			.L900001463:
/* 0x06e8	 709 */		cmp	%o2,32
/* 0x06ec	     */		ld	[%sp+108],%o1
/* 0x06f0	     */		bg	.L900001280
/* 0x06f4	     */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900001463: 
! g1 o0 o1 o2 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001463

			.L900001268:
/* 0x06f8	 709 */		and	%o1,3,%l1
/* 0x06fc	     */		xor	%g1,-832,%g1
/* 0x0700	     */		orcc	%l1,0,%g0
/* 0x0704	     */		add	%g1,%fp,%g1
/* 0x0708	     */		be	.L900001273
/* 0x070c	     */		or	%g0,%g1,%l1

! Registers live out of .L900001268: 
! o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001268

			.L900001269:
/* 0x0710	 709 */		subcc	%o2,2,%o2
/* 0x0714	     */		bl	.L900001271
/* 0x0718	     */		sub	%o2,-2,%o0

! Registers live out of .L900001269: 
! o0 o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001269

			.L900001417:
/* 0x071c	 709 */		srl	%o0,31,%l3
/* 0x0720	     */		add	%o0,%l3,%o0
/* 0x0724	     */		sra	%o0,1,%l0
/* 0x0728	     */		cmp	%l0,1
/* 0x072c	     */		bl	.L900001270
/* 0x0730	     */		nop

! Registers live out of .L900001417: 
! o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001417

			.L900001418:
/* 0x0734	 709 */		sethi	%hi(0x1c00),%g1
/* 0x0738	     */		xor	%g1,-832,%g1
/* 0x073c	     */		or	%g0,%o2,%g4
/* 0x0740	     */		add	%g1,%fp,%o3

! Registers live out of .L900001418: 
! g4 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001416 .L900001418

			.L900001416:
/* 0x0744	 709 */		sub	%g4,2,%g4
/* 0x0748	     */		add	%o3,2,%o3
/* 0x074c	     */		ldub	[%o1],%o5
/* 0x0750	     */		cmp	%g4,0
/* 0x0754	     */		add	%o1,2,%o1
/* 0x0758	     */		stb	%o5,[%o3-2]
/* 0x075c	     */		ldub	[%o1-1],%o7
/* 0x0760	     */		bge	.L900001416
/* 0x0764	     */		stb	%o7,[%o3-1]

! Registers live out of .L900001416: 
! g4 o1 o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001416

			.L900001419:
/* 0x0768	 709 */		or	%g0,%g4,%o2
/* 0x076c	     */		or	%g0,%o3,%l1
/* 0x0770	     */		ba	.L900001271
/* 0x0774	     */		nop

! Registers live out of .L900001419: 
! o1 o2 o3 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001417

			.L900001270:
/* 0x0778	 709 */		subcc	%o2,2,%o2

! Registers live out of .L900001270: 
! o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001270 .L900001462

			.L900001462:
/* 0x077c	 709 */		ldub	[%o1],%o5
/* 0x0780	     */		stb	%o5,[%l1]
/* 0x0784	     */		ldub	[%o1+1],%o7
/* 0x0788	     */		add	%o1,2,%o1
/* 0x078c	     */		stb	%o7,[%l1+1]
/* 0x0790	     */		add	%l1,2,%l1
/* 0x0794	     */		bge,a	.L900001462
/* 0x0798	     */		subcc	%o2,2,%o2

! Registers live out of .L900001462: 
! o1 o2 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001269 .L900001419 .L900001462

			.L900001271:
/* 0x079c	 709 */		cmp	%o2,-1
/* 0x07a0	     */		bl	.L900001460
/* 0x07a4	 710 */		add	%fp,-3200,%l2

! Registers live out of .L900001271: 
! o1 o3 sp l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001271

			.L900001272:
/* 0x07a8	 709 */		ldub	[%o1],%l0
/* 0x07ac	     */		stb	%l0,[%l1]
/* 0x07b0	     */		ba	.L900001460
/* 0x07b4	 710 */		add	%fp,-3200,%l2

! Registers live out of .L900001272: 
! o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001268

			.L900001273:
/* 0x07b8	 709 */		subcc	%o2,4,%l0
/* 0x07bc	     */		bl	.L900001276
/* 0x07c0	     */		sra	%o2,1,%l2

! Registers live out of .L900001273: 
! o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001273

			.L900001381:
/* 0x07c4	 709 */		srl	%l2,30,%l3
/* 0x07c8	     */		add	%o2,%l3,%o0
/* 0x07cc	     */		sra	%o0,2,%o3
/* 0x07d0	     */		cmp	%o3,1
/* 0x07d4	     */		bl	.L900001274
/* 0x07d8	     */		nop

! Registers live out of .L900001381: 
! o1 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001380 .L900001381

			.L900001380:
/* 0x07dc	 709 */		sub	%l0,4,%l0
/* 0x07e0	     */		add	%l1,4,%l1
/* 0x07e4	     */		ld	[%o1],%f4
/* 0x07e8	     */		cmp	%l0,0
/* 0x07ec	     */		add	%o1,4,%o1
/* 0x07f0	     */		bge	.L900001380
/* 0x07f4	     */		st	%f4,[%l1-4]

! Registers live out of .L900001380: 
! o1 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001380

			.L900001383:
/* 0x07f8	 709 */		ba	.L900001275
/* 0x07fc	     */		nop

! Registers live out of .L900001383: 
! o1 o3 sp l0 l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001381

			.L900001274:
/* 0x0800	 709 */		subcc	%l0,4,%l0

! Registers live out of .L900001274: 
! o1 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001274 .L900001461

			.L900001461:
/* 0x0804	 709 */		ld	[%o1],%f4
/* 0x0808	     */		add	%o1,4,%o1
/* 0x080c	     */		st	%f4,[%l1]
/* 0x0810	     */		add	%l1,4,%l1
/* 0x0814	     */		bge,a	.L900001461
/* 0x0818	     */		subcc	%l0,4,%l0

! Registers live out of .L900001461: 
! o1 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001383 .L900001461

			.L900001275:
/* 0x081c	 709 */		add	%l0,4,%o2

! Registers live out of .L900001275: 
! o1 o2 o3 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001273 .L900001275

			.L900001276:
/* 0x0820	 709 */		andcc	%i1,3,%g0
/* 0x0824	     */		be	.L900001282
/* 0x0828	     */		subcc	%o2,1,%o2

! Registers live out of .L900001276: 
! o1 o2 o3 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001276

			.L900001277:
/* 0x082c	 709 */		ldub	[%o1],%o0
/* 0x0830	     */		ble	.L900001282
/* 0x0834	     */		stb	%o0,[%l1]

! Registers live out of .L900001277: 
! o1 o2 o3 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001277

			.L900001278:
/* 0x0838	 709 */		ldub	[%o1+1],%o4
/* 0x083c	     */		subcc	%o2,1,%o2
/* 0x0840	     */		ble	.L900001282
/* 0x0844	     */		stb	%o4,[%l1+1]

! Registers live out of .L900001278: 
! o1 o3 sp l1 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001278

			.L900001279:
/* 0x0848	 709 */		ldub	[%o1+2],%g5
/* 0x084c	     */		stb	%g5,[%l1+2]
/* 0x0850	     */		ba	.L900001460
/* 0x0854	 710 */		add	%fp,-3200,%l2

! Registers live out of .L900001279: 
! o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001463

			.L900001280:
/* 0x0858	 709 */		xor	%g1,-832,%g1
/* 0x085c	     */		add	%g1,%fp,%g1
/* 0x0860	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0864	     */		or	%g0,%g1,%o0

! Registers live out of .L900001280: 
! o3 sp l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001276 .L900001277 .L900001278 .L900001280

			.L900001282:
/* 0x0868	 710 */		add	%fp,-3200,%l2

! Registers live out of .L900001282: 
! o3 sp l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001271 .L900001272 .L900001279 .L900001282

			.L900001460:
/* 0x086c	 711 */		sethi	%hi(0x1000),%g1
/* 0x0870	     */		xor	%g1,-704,%g1
/* 0x0874	     */		add	%g1,%fp,%l1
/* 0x0878	 712 */		sethi	%hi(0x1800),%g1
/* 0x087c	     */		xor	%g1,-256,%g1
/* 0x0880	     */		add	%g1,%fp,%l0
/* 0x0884	 713 */		sethi	%hi(0x1c00),%g1
/* 0x0888	     */		xor	%g1,-832,%g1

!  720		      !   }
!  722		      !   /* Texture */
!  723		      !   ASSERT(ctx->Texture.Enabled);
!  724		      !   gl_texture_pixels( ctx, n, s, t, u, lambda, red, green, blue, alpha );

/* 0x088c	 724 */		st	%l2,[%sp+92]
/* 0x0890	 713 */		add	%g1,%fp,%l3

! Registers live out of .L900001460: 
! o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003530 .L900001460

			.L900001472:
/* 0x0894	 724 */		srl	%l0,0,%o1
/* 0x0898	     */		sllx	%l1,32,%o0
/* 0x089c	     */		or	%o0,%o1,%g5
/* 0x08a0	     */		or	%g0,%i5,%o2
/* 0x08a4	     */		or	%g0,%i1,%o1
/* 0x08a8	     */		ldx	[%fp+96],%o7
/* 0x08ac	     */		or	%g0,%i0,%o0
/* 0x08b0	     */		stx	%g5,[%sp+96]
/* 0x08b4	     */		srl	%o7,0,%o5
/* 0x08b8	     */		srlx	%o7,32,%o4
/* 0x08bc	     */		st	%l3,[%sp+104]
/* 0x08c0	     */		call	gl_texture_pixels	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+104 %sp+96	! Result = 
/* 0x08c4	     */		ld	[%fp+92],%o3

!  726		      !   /* Per-pixel fog */
!  727		      !   if (ctx->Fog.Enabled && (ctx->Hint.Fog==GL_NICEST || primitive==GL_BITMAP
!  728		      !                            || ctx->Texture.Enabled)) {

/* 0x08c8	 728 */		sethi	%hi(0x1c00),%o2
/* 0x08cc	     */		add	%o2,888,%i5
/* 0x08d0	     */		ldub	[%i0+%i5],%g5
/* 0x08d4	     */		cmp	%g5,0
/* 0x08d8	     */		be,pn	%icc,.L77003544
/* 0x08dc	   0 */		sethi	%hi(0xd400),%i5

! Registers live out of .L900001472: 
! o0 o2 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001472

			.L77003534:
/* 0x08e0	 728 */		add	%o2,944,%o1
/* 0x08e4	     */		sethi	%hi(0x1000),%o5
/* 0x08e8	     */		ld	[%i0+%o1],%g3
/* 0x08ec	     */		add	%o5,258,%g2
/* 0x08f0	     */		cmp	%g3,%g2
/* 0x08f4	     */		be,pn	%icc,.L77003542
/* 0x08f8	     */		sethi	%hi(0x1800),%o0

! Registers live out of .L77003534: 
! o0 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003534

			.L77003536:
/* 0x08fc	 728 */		add	%o0,512,%g2
/* 0x0900	     */		cmp	%l5,%g2
/* 0x0904	     */		be,pn	%icc,.L77003542
/* 0x0908	     */		add	%i5,884,%o0

! Registers live out of .L77003536: 
! o0 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003536

			.L77003538:
/* 0x090c	 728 */		ld	[%i0+%o0],%g4
/* 0x0910	     */		cmp	%g4,0
/* 0x0914	     */		be,pt	%icc,.L900001459
/* 0x0918	 733 */		add	%i5,840,%o3

! Registers live out of .L77003538: 
! o0 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  729		      !      gl_fog_color_pixels( ctx, n, z, red, green, blue, alpha );

                       
! predecessor blocks: .L77003534 .L77003536 .L77003538

			.L77003542:
/* 0x091c	 729 */		or	%g0,%l0,%o5
/* 0x0920	     */		or	%g0,%l1,%o4
/* 0x0924	     */		or	%g0,%l2,%o3
/* 0x0928	     */		or	%g0,%i4,%o2
/* 0x092c	     */		or	%g0,%i1,%o1
/* 0x0930	     */		st	%l3,[%sp+92]
/* 0x0934	     */		call	gl_fog_color_pixels	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92	! Result = 
/* 0x0938	     */		or	%g0,%i0,%o0

! Registers live out of .L77003542: 
! o0 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  730		      !   }
!  732		      !   /* Do the scissor test */
!  733		      !   if (ctx->Scissor.Enabled) {

                       
! predecessor blocks: .L77003542 .L900001472

			.L77003544:
/* 0x093c	 733 */		add	%i5,840,%o3

! Registers live out of .L77003544: 
! o0 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003538 .L77003544

			.L900001459:
/* 0x0940	 733 */		ldub	[%i0+%o3],%o7
/* 0x0944	     */		cmp	%o7,0
/* 0x0948	     */		be,pn	%icc,.L77003552
/* 0x094c	 734 */		or	%g0,%i3,%o3

! Registers live out of .L900001459: 
! o0 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  734		      !      if (gl_scissor_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L900001459

			.L77003546:
/* 0x0950	 734 */		or	%g0,%i2,%o2
/* 0x0954	     */		or	%g0,%i1,%o1
/* 0x0958	     */		or	%g0,%i0,%o0
/* 0x095c	     */		call	gl_scissor_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0960	     */		add	%fp,-1600,%o4
/* 0x0964	     */		orcc	%g0,%o0,%g0
/* 0x0968	     */		be,pn	%icc,.L77003657

!  735		      !	 return;
!  736		      !      }
!  737		      !      write_all = GL_FALSE;

/* 0x096c	 737 */		or	%g0,0,%l7

! Registers live out of .L77003546: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  738		      !   }
!  740		      !   /* Polygon Stippling */
!  741		      !   if (ctx->Polygon.StippleFlag && primitive==GL_POLYGON) {

                       
! predecessor blocks: .L77003546 .L900001459

			.L77003552:
/* 0x0970	 741 */		add	%i5,697,%o2
/* 0x0974	     */		ldub	[%i0+%o2],%o4
/* 0x0978	     */		cmp	%o4,0
/* 0x097c	     */		be,pn	%icc,.L77003558
/* 0x0980	     */		cmp	%l5,9

! Registers live out of .L77003552: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003552

			.L77003554:
/* 0x0984	 741 */		bne,pn	%icc,.L77003558
/* 0x0988	 104 */		cmp	%i1,0

! Registers live out of .L77003554: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003554

			.L77003556:
/* 0x098c	 104 */		bleu,pn	%icc,.L77003721
/* 0x0990	 101 */		cmp	%i1,2

! Registers live out of .L77003556: 
! o0 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003556

			.L77003723:
/* 0x0994	 101 */		sra	%i3,31,%o3
/* 0x0998	     */		and	%o3,31,%o2
/* 0x099c	     */		add	%i3,%o2,%g5
/* 0x09a0	     */		andn	%g5,31,%o4
/* 0x09a4	 102 */		sra	%i2,31,%o7
/* 0x09a8	 101 */		sub	%i3,%o4,%o0
/* 0x09ac	 102 */		and	%o7,31,%l5
/* 0x09b0	 101 */		sll	%o0,2,%o5
/* 0x09b4	 102 */		add	%i2,%l5,%l7
/* 0x09b8	 101 */		add	%i0,%o5,%g2
/* 0x09bc	     */		add	%i5,712,%g3
/* 0x09c0	 102 */		andn	%l7,31,%g4
/* 0x09c4	     */		sub	%i2,%g4,%o1
/* 0x09c8	   0 */		sethi	%hi(0x80000000),%o4
/* 0x09cc	 101 */		ld	[%g2+%g3],%g5
/* 0x09d0	     */		bl,pn	%icc,.L77003817
/* 0x09d4	 102 */		srl	%o4,%o1,%o0

! Registers live out of .L77003723: 
! g5 o0 o2 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003723

			.L77003736:
/* 0x09d8	 104 */		sethi	%hi(0x7ffffc00),%o3
/* 0x09dc	     */		srl	%i1,0,%g3
/* 0x09e0	     */		add	%o3,1022,%o2
/* 0x09e4	     */		sub	%g3,%o2,%g2
/* 0x09e8	     */		srlx	%g2,63,%g3
/* 0x09ec	     */		andcc	%g3,1,%g0
/* 0x09f0	     */		be,a,pn	%icc,.L77003728
/* 0x09f4	     */		or	%g0,0,%g2

! Registers live out of .L77003736: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003736

			.L77003744:
/* 0x09f8	 104 */		add	%i1,-1,%o3
/* 0x09fc	     */		or	%g0,0,%o5
/* 0x0a00	 105 */		andcc	%o0,%g5,%g0

! Registers live out of .L77003744: 
! g5 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003710 .L77003744

			.L900001458:
/* 0x0a04	 105 */		bne,pn	%icc,.L77003710
/* 0x0a08	 108 */		srl	%o0,1,%o0

! Registers live out of .L900001458: 
! g5 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001458

			.L77003708:
/* 0x0a0c	 106 */		add	%fp,-1600,%o2
/* 0x0a10	     */		stb	%g0,[%o5+%o2]

! Registers live out of .L77003708: 
! g5 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003708 .L900001458

			.L77003710:
/* 0x0a14	 109 */		cmp	%o0,0
/* 0x0a18	   0 */		move	%icc,%o4,%o0
/* 0x0a1c	 104 */		add	%o5,1,%o5
/* 0x0a20	     */		cmp	%o5,%o3
/* 0x0a24	     */		ble,pt	%icc,.L900001458
/* 0x0a28	 105 */		andcc	%o0,%g5,%g0

! Registers live out of .L77003710: 
! g5 o0 o2 o3 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003710

			.L900001365:
/* 0x0a2c	 104 */		ba	.L77003558

!  742		      !      stipple_polygon_span( ctx, n, x, y, mask );
!  743		      !      write_all = GL_FALSE;

/* 0x0a30	 743 */		or	%g0,0,%l7

! Registers live out of .L900001365: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003723

			.L77003817:
/* 0x0a34	 104 */		or	%g0,0,%g2

! Registers live out of .L77003817: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003736 .L77003817

			.L77003728:
/* 0x0a38	 105 */		andcc	%o0,%g5,%g0

! Registers live out of .L77003728: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003728 .L77003732

			.L900001457:
/* 0x0a3c	 105 */		bne,pn	%icc,.L77003732
/* 0x0a40	 108 */		srl	%o0,1,%o0

! Registers live out of .L900001457: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001457

			.L77003729:
/* 0x0a44	 106 */		add	%fp,-1600,%g3
/* 0x0a48	     */		stb	%g0,[%g2+%g3]

! Registers live out of .L77003729: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003729 .L900001457

			.L77003732:
/* 0x0a4c	 109 */		cmp	%o0,0
/* 0x0a50	   0 */		move	%icc,%o4,%o0
/* 0x0a54	 104 */		add	%g2,1,%g2
/* 0x0a58	     */		cmp	%g2,%i1
/* 0x0a5c	     */		bcs,pt	%icc,.L900001457
/* 0x0a60	 105 */		andcc	%o0,%g5,%g0

! Registers live out of .L77003732: 
! g2 g5 o0 o2 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003556 .L77003732

			.L77003721:
/* 0x0a64	 743 */		or	%g0,0,%l7

! Registers live out of .L77003721: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  744		      !   }
!  746		      !   /* Do the alpha test */
!  747		      !   if (ctx->Color.AlphaEnabled) {

                       
! predecessor blocks: .L77003552 .L77003554 .L77003721 .L900001365

			.L77003558:
/* 0x0a68	 747 */		sethi	%hi(0x1c00),%o3
/* 0x0a6c	     */		add	%o3,672,%g2
/* 0x0a70	     */		ldub	[%i0+%g2],%g5
/* 0x0a74	     */		cmp	%g5,0
/* 0x0a78	     */		be,pn	%icc,.L77003566
/* 0x0a7c	 748 */		or	%g0,%l3,%o2

! Registers live out of .L77003558: 
! o0 o2 o3 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  748		      !      if (gl_alpha_test( ctx, n, alpha, mask )==0) {

                       
! predecessor blocks: .L77003558

			.L77003560:
/* 0x0a80	 748 */		or	%g0,%i1,%o1
/* 0x0a84	     */		or	%g0,%i0,%o0
/* 0x0a88	     */		call	gl_alpha_test	! params =  %o0 %o1 %o2 %o3	! Result =  %o0
/* 0x0a8c	     */		add	%fp,-1600,%o3
/* 0x0a90	     */		orcc	%g0,%o0,%g0
/* 0x0a94	     */		be,pn	%icc,.L77003657

!  749		      !	 return;
!  750		      !      }
!  751		      !      write_all = GL_FALSE;

/* 0x0a98	 751 */		or	%g0,0,%l7

! Registers live out of .L77003560: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  752		      !   }
!  754		      !   if (ctx->Stencil.Enabled) {

                       
! predecessor blocks: .L77003558 .L77003560

			.L77003566:
/* 0x0a9c	 754 */		add	%i5,860,%o5
/* 0x0aa0	     */		ldub	[%i0+%o5],%g3
/* 0x0aa4	     */		cmp	%g3,0
/* 0x0aa8	     */		be,pn	%icc,.L77003574
/* 0x0aac	 756 */		or	%g0,%i3,%o3

! Registers live out of .L77003566: 
! o0 o3 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  755		      !      /* first stencil test */
!  756		      !      if (gl_stencil_span( ctx, n, x, y, mask )==0) {

                       
! predecessor blocks: .L77003566

			.L77003568:
/* 0x0ab0	 756 */		or	%g0,%i2,%o2
/* 0x0ab4	     */		or	%g0,%i1,%o1
/* 0x0ab8	     */		or	%g0,%i0,%o0
/* 0x0abc	     */		call	gl_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result =  %o0
/* 0x0ac0	     */		add	%fp,-1600,%o4
/* 0x0ac4	     */		orcc	%g0,%o0,%g0
/* 0x0ac8	     */		be,pn	%icc,.L77003657
/* 0x0acc	 760 */		or	%g0,%i4,%o4

! Registers live out of .L77003568: 
! o4 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  757		      !	 return;
!  758		      !      }
!  759		      !      /* depth buffering w/ stencil */
!  760		      !      gl_depth_stencil_span( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77003568

			.L77003572:
/* 0x0ad0	 760 */		or	%g0,%i3,%o3
/* 0x0ad4	     */		or	%g0,%i2,%o2
/* 0x0ad8	     */		or	%g0,%i1,%o1
/* 0x0adc	     */		or	%g0,%i0,%o0

!  761		      !      write_all = GL_FALSE;

/* 0x0ae0	 761 */		or	%g0,0,%l7
/* 0x0ae4	 760 */		call	gl_depth_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0ae8	     */		add	%fp,-1600,%o5
/* 0x0aec	 761 */		ba	.L900001456
/* 0x0af0	 774 */		sethi	%hi(0xe000),%o4

! Registers live out of .L77003572: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  762		      !   }
!  763		      !   else if (ctx->Depth.Test) {

                       
! predecessor blocks: .L77003566

			.L77003574:
/* 0x0af4	 763 */		sethi	%hi(0x1c00),%o5
/* 0x0af8	     */		add	%o5,828,%g4
/* 0x0afc	     */		ldub	[%i0+%g4],%o1
/* 0x0b00	     */		cmp	%o1,0
/* 0x0b04	     */		be,pn	%icc,.L77003588
/* 0x0b08	 765 */		or	%g0,%i4,%o4

! Registers live out of .L77003574: 
! o0 o4 o5 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  764		      !      /* regular depth testing */
!  765		      !      GLuint m = (*ctx->Driver.DepthTestSpan)( ctx, n, x, y, z, mask );

                       
! predecessor blocks: .L77003574

			.L77003576:
/* 0x0b0c	 765 */		or	%g0,%i3,%o3
/* 0x0b10	     */		or	%g0,%i2,%o2
/* 0x0b14	     */		or	%g0,%i1,%o1
/* 0x0b18	     */		or	%g0,%i0,%o0
/* 0x0b1c	     */		ld	[%i0+2332],%o7
/* 0x0b20	     */		jmpl	%o7,%o7
/* 0x0b24	     */		add	%fp,-1600,%o5
/* 0x0b28	     */		orcc	%g0,%o0,%g0

!  766		      !      if (m==0) {

/* 0x0b2c	 766 */		be,pn	%icc,.L77003657
/* 0x0b30	 770 */		srl	%o0,0,%o0

! Registers live out of .L77003576: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  767		      !         return;
!  768		      !      }
!  769		      !      if (m<n) {
!  770		      !         write_all = GL_FALSE;

                       
! predecessor blocks: .L77003576

			.L77003580:
/* 0x0b34	 770 */		srl	%i1,0,%o1
/* 0x0b38	     */		sub	%o0,%o1,%o5
/* 0x0b3c	     */		srlx	%o5,63,%o4
/* 0x0b40	     */		xor	%o4,1,%o3
/* 0x0b44	     */		and	%o3,%l7,%l7
/* 0x0b48	     */		and	%l7,255,%l7

! Registers live out of .L77003580: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  771		      !      }
!  772		      !   }
!  774		      !   if (ctx->RasterMask & NO_DRAW_BIT) {

                       
! predecessor blocks: .L77003574 .L77003580

			.L77003588:
/* 0x0b4c	 774 */		sethi	%hi(0xe000),%o4

! Registers live out of .L77003588: 
! o0 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003572 .L77003588

			.L900001456:
/* 0x0b50	 774 */		add	%o4,264,%i4
/* 0x0b54	     */		ld	[%i0+%i4],%i4
/* 0x0b58	     */		andcc	%i4,2048,%g0
/* 0x0b5c	     */		bne,pn	%icc,.L77003657
/* 0x0b60	 780 */		sethi	%hi(0x1c00),%o1

! Registers live out of .L900001456: 
! o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  775		      !      /* write no pixels */
!  776		      !      return;
!  777		      !   }
!  779		      !   /* blending */
!  780		      !   if (ctx->Color.SWLogicOpEnabled) {

                       
! predecessor blocks: .L900001456

			.L77003592:
/* 0x0b64	 780 */		add	%o1,722,%i4
/* 0x0b68	     */		ldub	[%i0+%i4],%l5
/* 0x0b6c	     */		cmp	%l5,0
/* 0x0b70	     */		be,pn	%icc,.L77003596
/* 0x0b74	 781 */		add	%fp,-1600,%g4

! Registers live out of .L77003592: 
! g4 o0 o1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  781		      !      gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77003592

			.L77003594:
/* 0x0b78	 781 */		srl	%g4,0,%o2
/* 0x0b7c	     */		sllx	%l3,32,%o7
/* 0x0b80	     */		or	%o7,%o2,%o4
/* 0x0b84	     */		or	%g0,%l1,%o5
/* 0x0b88	     */		or	%g0,%i3,%o3
/* 0x0b8c	     */		or	%g0,%i2,%o2
/* 0x0b90	     */		or	%g0,%i1,%o1
/* 0x0b94	     */		stx	%o4,[%sp+96]
/* 0x0b98	     */		or	%g0,%l2,%o4
/* 0x0b9c	     */		st	%l0,[%sp+92]
/* 0x0ba0	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0ba4	     */		or	%g0,%i0,%o0
/* 0x0ba8	     */		ba	.L900001455
/* 0x0bac	 787 */		sethi	%hi(0x1c00),%o7

! Registers live out of .L77003594: 
! o0 sp o7 l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  782		      !   }
!  783		      !   else  if (ctx->Color.BlendEnabled) {

                       
! predecessor blocks: .L77003592

			.L77003596:
/* 0x0bb0	 783 */		add	%o1,685,%o0
/* 0x0bb4	     */		ldub	[%i0+%o0],%o2
/* 0x0bb8	     */		cmp	%o2,0
/* 0x0bbc	     */		be,pn	%icc,.L77003602
/* 0x0bc0	 784 */		add	%fp,-1600,%i5

! Registers live out of .L77003596: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  784		      !      gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77003596

			.L77003598:
/* 0x0bc4	 784 */		srl	%i5,0,%o5
/* 0x0bc8	     */		sllx	%l3,32,%o3
/* 0x0bcc	     */		or	%o3,%o5,%g4
/* 0x0bd0	     */		or	%g0,%l1,%o5
/* 0x0bd4	     */		or	%g0,%l2,%o4
/* 0x0bd8	     */		or	%g0,%i3,%o3
/* 0x0bdc	     */		or	%g0,%i2,%o2
/* 0x0be0	     */		stx	%g4,[%sp+96]
/* 0x0be4	     */		or	%g0,%i1,%o1
/* 0x0be8	     */		st	%l0,[%sp+92]
/* 0x0bec	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0bf0	     */		or	%g0,%i0,%o0

! Registers live out of .L77003598: 
! o0 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  785		      !   }
!  787		      !   if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77003596 .L77003598

			.L77003602:
/* 0x0bf4	 787 */		sethi	%hi(0x1c00),%o7

! Registers live out of .L77003602: 
! o0 sp o7 l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003594 .L77003602

			.L900001455:
/* 0x0bf8	 787 */		add	%o7,664,%l5
/* 0x0bfc	     */		ldub	[%i0+%l5],%g5
/* 0x0c00	     */		cmp	%g5,0
/* 0x0c04	     */		be,pn	%icc,.L77003606
/* 0x0c08	 788 */		or	%g0,%l1,%o5

! Registers live out of .L900001455: 
! o0 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  788		      !      gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );

                       
! predecessor blocks: .L900001455

			.L77003604:
/* 0x0c0c	 788 */		or	%g0,%l2,%o4
/* 0x0c10	     */		or	%g0,%i3,%o3
/* 0x0c14	     */		or	%g0,%i2,%o2
/* 0x0c18	     */		st	%l0,[%sp+92]
/* 0x0c1c	     */		or	%g0,%i1,%o1
/* 0x0c20	     */		st	%l3,[%sp+96]
/* 0x0c24	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0c28	     */		or	%g0,%i0,%o0

! Registers live out of .L77003604: 
! o0 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  789		      !   }
!  791		      !   /* write pixels */
!  792		      !   (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  793		      !                                  write_all ? NULL : mask );

                       
! predecessor blocks: .L77003604 .L900001455

			.L77003606:
/* 0x0c2c	 793 */		cmp	%l7,0
/* 0x0c30	     */		be,pn	%icc,.L77003610
/* 0x0c34	     */		or	%g0,%l1,%o5

! Registers live out of .L77003606: 
! o0 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003606

			.L77003608:
/* 0x0c38	 793 */		sllx	%l3,32,%o1
/* 0x0c3c	     */		or	%g0,%l2,%o4
/* 0x0c40	     */		or	%g0,%i3,%o3
/* 0x0c44	     */		or	%g0,%i2,%o2
/* 0x0c48	     */		stx	%o1,[%sp+96]
/* 0x0c4c	     */		or	%g0,%i1,%o1
/* 0x0c50	     */		ld	[%i0+2244],%g2
/* 0x0c54	     */		st	%l0,[%sp+92]
/* 0x0c58	     */		jmpl	%g2,%o7
/* 0x0c5c	     */		or	%g0,%i0,%o0

!  794		      !   if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x0c60	 794 */		sethi	%hi(0xe000),%o2
/* 0x0c64	     */		add	%o2,264,%g5
/* 0x0c68	     */		ld	[%i0+%g5],%i5
/* 0x0c6c	     */		andcc	%i5,256,%g0
/* 0x0c70	     */		be,pn	%icc,.L77003622

!  795		      !      gl_write_alpha_span( ctx, n, x, y, alpha, write_all ? NULL : mask );

/* 0x0c74	 795 */		or	%g0,0,%o5

! Registers live out of .L77003608: 
! g1 g3 o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003608

			.L77003616:
/* 0x0c78	 795 */		ba	.L900001454
/* 0x0c7c	     */		or	%g0,%l3,%o4

! Registers live out of .L77003616: 
! o0 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003606

			.L77003610:
/* 0x0c80	 793 */		add	%fp,-1600,%o0
/* 0x0c84	     */		srl	%o0,0,%g4
/* 0x0c88	     */		sllx	%l3,32,%o4
/* 0x0c8c	     */		or	%o4,%g4,%o7
/* 0x0c90	     */		or	%g0,%l2,%o4
/* 0x0c94	     */		or	%g0,%i3,%o3
/* 0x0c98	     */		or	%g0,%i2,%o2
/* 0x0c9c	     */		ld	[%i0+2244],%g3
/* 0x0ca0	     */		or	%g0,%i1,%o1
/* 0x0ca4	     */		stx	%o7,[%sp+96]
/* 0x0ca8	     */		st	%l0,[%sp+92]
/* 0x0cac	     */		jmpl	%g3,%o7
/* 0x0cb0	     */		or	%g0,%i0,%o0
/* 0x0cb4	 794 */		sethi	%hi(0xe000),%g2
/* 0x0cb8	     */		add	%g2,264,%g3
/* 0x0cbc	     */		ld	[%i0+%g3],%i5
/* 0x0cc0	     */		andcc	%i5,256,%g0
/* 0x0cc4	     */		be,pn	%icc,.L77003622
/* 0x0cc8	 795 */		add	%fp,-1600,%o5

! Registers live out of .L77003610: 
! g1 g3 o0 o3 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003610

			.L77003620:
/* 0x0ccc	 795 */		or	%g0,%l3,%o4

! Registers live out of .L77003620: 
! o0 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003616 .L77003620

			.L900001454:
/* 0x0cd0	 795 */		or	%g0,%i3,%o3
/* 0x0cd4	     */		or	%g0,%i2,%o2
/* 0x0cd8	     */		or	%g0,%i1,%o1
/* 0x0cdc	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x0ce0	     */		or	%g0,%i0,%o0
/* 0x0ce4	     */		sethi	%hi(0xe000),%o5
/* 0x0ce8	     */		add	%o5,264,%o3
/* 0x0cec	     */		ld	[%i0+%o3],%i5

! Registers live out of .L900001454: 
! g1 g3 o0 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  796		      !   }
!  798		      !   if (ctx->RasterMask & FRONT_AND_BACK_BIT) {

                       
! predecessor blocks: .L77003608 .L77003610 .L900001454

			.L77003622:
/* 0x0cf0	 798 */		andcc	%i5,1024,%g0
/* 0x0cf4	     */		be,pn	%icc,.L77003657
/* 0x0cf8	 800 */		or	%g0,%i1,%o2

! Registers live out of .L77003622: 
! g1 g3 o0 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  799		      !      /* Also draw to back buffer */
!  800		      !      MEMCPY( rtmp, r, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L77003622

			.L77003624:
/* 0x0cfc	 800 */		cmp	%o2,32
/* 0x0d00	     */		bg	.L900001264
/* 0x0d04	     */		or	%g0,%l4,%o1

! Registers live out of .L77003624: 
! g1 g3 o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003624

			.L900001252:
/* 0x0d08	 800 */		and	%o1,3,%g2
/* 0x0d0c	     */		orcc	%g2,0,%g0
/* 0x0d10	     */		be	.L900001257
/* 0x0d14	     */		add	%fp,-3200,%o0

! Registers live out of .L900001252: 
! g1 g2 g3 o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001252

			.L900001253:
/* 0x0d18	 800 */		subcc	%o2,2,%o2
/* 0x0d1c	     */		bl	.L900001255
/* 0x0d20	     */		sub	%o2,-2,%o5

! Registers live out of .L900001253: 
! g1 g2 g3 o0 o1 o2 o3 o5 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001253

			.L900001413:
/* 0x0d24	 800 */		srl	%o5,31,%l4
/* 0x0d28	     */		add	%o5,%l4,%g2
/* 0x0d2c	     */		sra	%g2,1,%g4
/* 0x0d30	     */		cmp	%g4,1
/* 0x0d34	     */		bl	.L900001254
/* 0x0d38	     */		nop

! Registers live out of .L900001413: 
! g1 g2 o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001413

			.L900001414:
/* 0x0d3c	 800 */		or	%g0,%o2,%o5
/* 0x0d40	     */		add	%fp,-3200,%l4
/* 0x0d44	     */		or	%g0,%o1,%o4

! Registers live out of .L900001414: 
! g1 g2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001412 .L900001414

			.L900001412:
/* 0x0d48	 800 */		sub	%o5,2,%o5
/* 0x0d4c	     */		add	%l4,2,%l4
/* 0x0d50	     */		ldub	[%o4],%g4
/* 0x0d54	     */		cmp	%o5,0
/* 0x0d58	     */		add	%o4,2,%o4
/* 0x0d5c	     */		stb	%g4,[%l4-2]
/* 0x0d60	     */		ldub	[%o4-1],%g3
/* 0x0d64	     */		bge	.L900001412
/* 0x0d68	     */		stb	%g3,[%l4-1]

! Registers live out of .L900001412: 
! g1 g2 g3 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001412

			.L900001415:
/* 0x0d6c	 800 */		or	%g0,%o5,%o2
/* 0x0d70	     */		or	%g0,%l4,%o0
/* 0x0d74	     */		or	%g0,%o4,%o1
/* 0x0d78	     */		ba	.L900001255
/* 0x0d7c	     */		nop

! Registers live out of .L900001415: 
! g2 g3 o0 o1 o2 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001413

			.L900001254:
/* 0x0d80	 800 */		subcc	%o2,2,%o2

! Registers live out of .L900001254: 
! g1 g2 o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001254 .L900001453

			.L900001453:
/* 0x0d84	 800 */		ldub	[%o1],%g4
/* 0x0d88	     */		stb	%g4,[%o0]
/* 0x0d8c	     */		ldub	[%o1+1],%g3
/* 0x0d90	     */		add	%o1,2,%o1
/* 0x0d94	     */		stb	%g3,[%o0+1]
/* 0x0d98	     */		add	%o0,2,%o0
/* 0x0d9c	     */		bge,a	.L900001453
/* 0x0da0	     */		subcc	%o2,2,%o2

! Registers live out of .L900001453: 
! g1 g2 g3 o0 o1 o2 o3 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001253 .L900001415 .L900001453

			.L900001255:
/* 0x0da4	 800 */		cmp	%o2,-1
/* 0x0da8	     */		bl,a	.L900001451
/* 0x0dac	 801 */		or	%g0,%l6,%o1

! Registers live out of .L900001255: 
! g2 g3 o0 o1 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001255

			.L900001256:
/* 0x0db0	 800 */		ldub	[%o1],%o1
/* 0x0db4	     */		stb	%o1,[%o0]
/* 0x0db8	     */		ba	.L900001451
/* 0x0dbc	 801 */		or	%g0,%l6,%o1

! Registers live out of .L900001256: 
! g2 g3 o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001252

			.L900001257:
/* 0x0dc0	 800 */		subcc	%o2,4,%o4
/* 0x0dc4	     */		bl	.L900001260
/* 0x0dc8	     */		sra	%o2,1,%o5

! Registers live out of .L900001257: 
! g1 g2 g3 o0 o1 o2 o3 o4 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001257

			.L900001385:
/* 0x0dcc	 800 */		srl	%o5,30,%g3
/* 0x0dd0	     */		add	%o2,%g3,%o7
/* 0x0dd4	     */		sra	%o7,2,%i5
/* 0x0dd8	     */		cmp	%i5,1
/* 0x0ddc	     */		bl	.L900001258
/* 0x0de0	     */		nop

! Registers live out of .L900001385: 
! g1 g2 g3 o0 o1 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001385

			.L900001386:
/* 0x0de4	 800 */		or	%g0,%o1,%g2

! Registers live out of .L900001386: 
! g1 g2 g3 o0 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001384 .L900001386

			.L900001384:
/* 0x0de8	 800 */		sub	%o4,4,%o4
/* 0x0dec	     */		add	%o0,4,%o0
/* 0x0df0	     */		ld	[%g2],%f6
/* 0x0df4	     */		cmp	%o4,0
/* 0x0df8	     */		add	%g2,4,%g2
/* 0x0dfc	     */		bge	.L900001384
/* 0x0e00	     */		st	%f6,[%o0-4]

! Registers live out of .L900001384: 
! g1 g2 g3 o0 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001384

			.L900001387:
/* 0x0e04	 800 */		or	%g0,%g2,%o1
/* 0x0e08	     */		ba	.L900001259
/* 0x0e0c	     */		nop

! Registers live out of .L900001387: 
! g2 g3 o0 o1 o4 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001385

			.L900001258:
/* 0x0e10	 800 */		subcc	%o4,4,%o4

! Registers live out of .L900001258: 
! g1 g2 g3 o0 o1 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001258 .L900001452

			.L900001452:
/* 0x0e14	 800 */		ld	[%o1],%f6
/* 0x0e18	     */		add	%o1,4,%o1
/* 0x0e1c	     */		st	%f6,[%o0]
/* 0x0e20	     */		add	%o0,4,%o0
/* 0x0e24	     */		bge,a	.L900001452
/* 0x0e28	     */		subcc	%o4,4,%o4

! Registers live out of .L900001452: 
! g1 g2 g3 o0 o1 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001387 .L900001452

			.L900001259:
/* 0x0e2c	 800 */		add	%o4,4,%o2

! Registers live out of .L900001259: 
! g2 g3 o0 o1 o2 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001257 .L900001259

			.L900001260:
/* 0x0e30	 800 */		andcc	%i1,3,%g0
/* 0x0e34	     */		be	.L900001266
/* 0x0e38	     */		subcc	%o2,1,%o2

! Registers live out of .L900001260: 
! g2 g3 o0 o1 o2 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001260

			.L900001261:
/* 0x0e3c	 800 */		ldub	[%o1],%o3
/* 0x0e40	     */		ble	.L900001266
/* 0x0e44	     */		stb	%o3,[%o0]

! Registers live out of .L900001261: 
! g2 g3 o0 o1 o2 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001261

			.L900001262:
/* 0x0e48	 800 */		ldub	[%o1+1],%i5
/* 0x0e4c	     */		subcc	%o2,1,%o2
/* 0x0e50	     */		ble	.L900001266
/* 0x0e54	     */		stb	%i5,[%o0+1]

! Registers live out of .L900001262: 
! g2 g3 o0 o1 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001262

			.L900001263:
/* 0x0e58	 800 */		ldub	[%o1+2],%l4
/* 0x0e5c	     */		stb	%l4,[%o0+2]
/* 0x0e60	     */		ba	.L900001451
/* 0x0e64	 801 */		or	%g0,%l6,%o1

! Registers live out of .L900001263: 
! g2 g3 o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003624

			.L900001264:
/* 0x0e68	 800 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0e6c	     */		add	%fp,-3200,%o0

! Registers live out of .L900001264: 
! g2 g3 o0 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  801		      !      MEMCPY( gtmp, g, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900001260 .L900001261 .L900001262 .L900001264

			.L900001266:
/* 0x0e70	 801 */		or	%g0,%l6,%o1

! Registers live out of .L900001266: 
! g2 g3 o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001255 .L900001256 .L900001263 .L900001266

			.L900001451:
/* 0x0e74	 801 */		or	%g0,%i1,%o2
/* 0x0e78	     */		cmp	%o2,32
/* 0x0e7c	     */		bg	.L900001248
/* 0x0e80	     */		sethi	%hi(0x1000),%g1

! Registers live out of .L900001451: 
! g1 g2 g3 o0 o1 o2 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001451

			.L900001236:
/* 0x0e84	 801 */		and	%o1,3,%o7
/* 0x0e88	     */		xor	%g1,-704,%g1
/* 0x0e8c	     */		orcc	%o7,0,%g0
/* 0x0e90	     */		add	%g1,%fp,%g1
/* 0x0e94	     */		be	.L900001241
/* 0x0e98	     */		or	%g0,%g1,%l4

! Registers live out of .L900001236: 
! g1 g2 g3 o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001236

			.L900001237:
/* 0x0e9c	 801 */		subcc	%o2,2,%o2
/* 0x0ea0	     */		bl	.L900001239
/* 0x0ea4	     */		sub	%o2,-2,%o0

! Registers live out of .L900001237: 
! g1 g2 o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001237

			.L900001409:
/* 0x0ea8	 801 */		srl	%o0,31,%o5
/* 0x0eac	     */		add	%o0,%o5,%o7
/* 0x0eb0	     */		sra	%o7,1,%g3
/* 0x0eb4	     */		cmp	%g3,1
/* 0x0eb8	     */		bl	.L900001238
/* 0x0ebc	     */		nop

! Registers live out of .L900001409: 
! g1 g2 g3 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001409

			.L900001410:
/* 0x0ec0	 801 */		sethi	%hi(0x1000),%g1
/* 0x0ec4	     */		xor	%g1,-704,%g1
/* 0x0ec8	     */		add	%g1,%fp,%g1
/* 0x0ecc	     */		or	%g0,%o2,%g2
/* 0x0ed0	     */		or	%g0,%g1,%l6
/* 0x0ed4	     */		or	%g0,%o1,%g3

! Registers live out of .L900001410: 
! g1 g2 g3 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001408 .L900001410

			.L900001408:
/* 0x0ed8	 801 */		sub	%g2,2,%g2
/* 0x0edc	     */		add	%l6,2,%l6
/* 0x0ee0	     */		ldub	[%g3],%o0
/* 0x0ee4	     */		cmp	%g2,0
/* 0x0ee8	     */		add	%g3,2,%g3
/* 0x0eec	     */		stb	%o0,[%l6-2]
/* 0x0ef0	     */		ldub	[%g3-1],%o5
/* 0x0ef4	     */		bge	.L900001408
/* 0x0ef8	     */		stb	%o5,[%l6-1]

! Registers live out of .L900001408: 
! g1 g2 g3 o0 sp o7 l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001408

			.L900001411:
/* 0x0efc	 801 */		or	%g0,%g2,%o2
/* 0x0f00	     */		or	%g0,%l6,%l4
/* 0x0f04	     */		or	%g0,%g3,%o1
/* 0x0f08	     */		ba	.L900001239
/* 0x0f0c	     */		nop

! Registers live out of .L900001411: 
! o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001409

			.L900001238:
/* 0x0f10	 801 */		subcc	%o2,2,%o2

! Registers live out of .L900001238: 
! g1 g2 g3 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001238 .L900001450

			.L900001450:
/* 0x0f14	 801 */		ldub	[%o1],%o0
/* 0x0f18	     */		stb	%o0,[%l4]
/* 0x0f1c	     */		ldub	[%o1+1],%o5
/* 0x0f20	     */		add	%o1,2,%o1
/* 0x0f24	     */		stb	%o5,[%l4+1]
/* 0x0f28	     */		add	%l4,2,%l4
/* 0x0f2c	     */		bge,a	.L900001450
/* 0x0f30	     */		subcc	%o2,2,%o2

! Registers live out of .L900001450: 
! g1 g2 g3 o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001237 .L900001411 .L900001450

			.L900001239:
/* 0x0f34	 801 */		cmp	%o2,-1
/* 0x0f38	     */		bl,a	.L900001448
/* 0x0f3c	 802 */		ld	[%sp+112],%o1

! Registers live out of .L900001239: 
! o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001239

			.L900001240:
/* 0x0f40	 801 */		ldub	[%o1],%o4
/* 0x0f44	     */		stb	%o4,[%l4]
/* 0x0f48	     */		ba	.L900001448
/* 0x0f4c	 802 */		ld	[%sp+112],%o1

! Registers live out of .L900001240: 
! o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001236

			.L900001241:
/* 0x0f50	 801 */		subcc	%o2,4,%g5
/* 0x0f54	     */		bl	.L900001244
/* 0x0f58	     */		sra	%o2,1,%o3

! Registers live out of .L900001241: 
! g1 g3 g5 o0 o1 o2 o3 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001241

			.L900001389:
/* 0x0f5c	 801 */		srl	%o3,30,%g2
/* 0x0f60	     */		add	%o2,%g2,%o2
/* 0x0f64	     */		sra	%o2,2,%l6
/* 0x0f68	     */		cmp	%l6,1
/* 0x0f6c	     */		bl	.L900001242
/* 0x0f70	     */		nop

! Registers live out of .L900001389: 
! g1 g2 g3 g5 o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001389

			.L900001390:
/* 0x0f74	 801 */		or	%g0,%o1,%o4

! Registers live out of .L900001390: 
! g1 g2 g3 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001388 .L900001390

			.L900001388:
/* 0x0f78	 801 */		sub	%g5,4,%g5
/* 0x0f7c	     */		add	%l4,4,%l4
/* 0x0f80	     */		ld	[%o4],%f8
/* 0x0f84	     */		cmp	%g5,0
/* 0x0f88	     */		add	%o4,4,%o4
/* 0x0f8c	     */		bge	.L900001388
/* 0x0f90	     */		st	%f8,[%l4-4]

! Registers live out of .L900001388: 
! g1 g2 g3 g5 o0 o4 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001388

			.L900001391:
/* 0x0f94	 801 */		or	%g0,%o4,%o1
/* 0x0f98	     */		ba	.L900001243
/* 0x0f9c	     */		nop

! Registers live out of .L900001391: 
! g5 o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001389

			.L900001242:
/* 0x0fa0	 801 */		subcc	%g5,4,%g5

! Registers live out of .L900001242: 
! g1 g2 g3 g5 o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001242 .L900001449

			.L900001449:
/* 0x0fa4	 801 */		ld	[%o1],%f8
/* 0x0fa8	     */		add	%o1,4,%o1
/* 0x0fac	     */		st	%f8,[%l4]
/* 0x0fb0	     */		add	%l4,4,%l4
/* 0x0fb4	     */		bge,a	.L900001449
/* 0x0fb8	     */		subcc	%g5,4,%g5

! Registers live out of .L900001449: 
! g1 g2 g3 g5 o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001391 .L900001449

			.L900001243:
/* 0x0fbc	 801 */		add	%g5,4,%o2

! Registers live out of .L900001243: 
! o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001241 .L900001243

			.L900001244:
/* 0x0fc0	 801 */		andcc	%i1,3,%g0
/* 0x0fc4	     */		be	.L900001250
/* 0x0fc8	     */		subcc	%o2,1,%o2

! Registers live out of .L900001244: 
! o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001244

			.L900001245:
/* 0x0fcc	 801 */		ldub	[%o1],%g5
/* 0x0fd0	     */		ble	.L900001250
/* 0x0fd4	     */		stb	%g5,[%l4]

! Registers live out of .L900001245: 
! o0 o1 o2 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001245

			.L900001246:
/* 0x0fd8	 801 */		subcc	%o2,1,%o2
/* 0x0fdc	     */		ldub	[%o1+1],%o2
/* 0x0fe0	     */		ble	.L900001250
/* 0x0fe4	     */		stb	%o2,[%l4+1]

! Registers live out of .L900001246: 
! o0 o1 sp o7 l0 l1 l2 l4 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001246

			.L900001247:
/* 0x0fe8	 801 */		ldub	[%o1+2],%l6
/* 0x0fec	     */		stb	%l6,[%l4+2]
/* 0x0ff0	     */		ba	.L900001448
/* 0x0ff4	 802 */		ld	[%sp+112],%o1

! Registers live out of .L900001247: 
! o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001451

			.L900001248:
/* 0x0ff8	 801 */		xor	%g1,-704,%g1
/* 0x0ffc	     */		add	%g1,%fp,%g1
/* 0x1000	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x1004	     */		or	%g0,%g1,%o0

! Registers live out of .L900001248: 
! o0 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  802		      !      MEMCPY( btmp, b, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900001244 .L900001245 .L900001246 .L900001248

			.L900001250:
/* 0x1008	 802 */		ld	[%sp+112],%o1

! Registers live out of .L900001250: 
! o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001239 .L900001240 .L900001247 .L900001250

			.L900001448:
/* 0x100c	 802 */		or	%g0,%i1,%o2
/* 0x1010	     */		cmp	%o2,32
/* 0x1014	     */		bg	.L900001232
/* 0x1018	     */		sethi	%hi(0x1800),%g1

! Registers live out of .L900001448: 
! g1 o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001448

			.L900001220:
/* 0x101c	 802 */		and	%o1,3,%o3
/* 0x1020	     */		xor	%g1,-256,%g1
/* 0x1024	     */		orcc	%o3,0,%g0
/* 0x1028	     */		add	%g1,%fp,%g1
/* 0x102c	     */		be	.L900001225
/* 0x1030	     */		or	%g0,%g1,%o3

! Registers live out of .L900001220: 
! g1 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001220

			.L900001221:
/* 0x1034	 802 */		subcc	%o2,2,%o2
/* 0x1038	     */		bl	.L900001223
/* 0x103c	     */		sub	%o2,-2,%g2

! Registers live out of .L900001221: 
! g1 g2 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001221

			.L900001405:
/* 0x1040	 802 */		srl	%g2,31,%o4
/* 0x1044	     */		add	%g2,%o4,%o0
/* 0x1048	     */		sra	%o0,1,%i5
/* 0x104c	     */		cmp	%i5,1
/* 0x1050	     */		bl	.L900001222
/* 0x1054	     */		nop

! Registers live out of .L900001405: 
! g1 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001405

			.L900001406:
/* 0x1058	 802 */		sethi	%hi(0x1800),%g1
/* 0x105c	     */		xor	%g1,-256,%g1
/* 0x1060	     */		add	%g1,%fp,%g1
/* 0x1064	     */		or	%g0,%o2,%g4
/* 0x1068	     */		or	%g0,%g1,%o5
/* 0x106c	     */		or	%g0,%o1,%o4

! Registers live out of .L900001406: 
! g1 g4 o0 o4 o5 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001404 .L900001406

			.L900001404:
/* 0x1070	 802 */		sub	%g4,2,%g4
/* 0x1074	     */		add	%o5,2,%o5
/* 0x1078	     */		ldub	[%o4],%g3
/* 0x107c	     */		cmp	%g4,0
/* 0x1080	     */		add	%o4,2,%o4
/* 0x1084	     */		stb	%g3,[%o5-2]
/* 0x1088	     */		ldub	[%o4-1],%g2
/* 0x108c	     */		bge	.L900001404
/* 0x1090	     */		stb	%g2,[%o5-1]

! Registers live out of .L900001404: 
! g1 g4 o0 o4 o5 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001404

			.L900001407:
/* 0x1094	 802 */		or	%g0,%g4,%o2
/* 0x1098	     */		or	%g0,%o5,%o3
/* 0x109c	     */		or	%g0,%o4,%o1
/* 0x10a0	     */		ba	.L900001223
/* 0x10a4	     */		nop

! Registers live out of .L900001407: 
! o0 o1 o2 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001405

			.L900001222:
/* 0x10a8	 802 */		subcc	%o2,2,%o2

! Registers live out of .L900001222: 
! g1 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001222 .L900001447

			.L900001447:
/* 0x10ac	 802 */		ldub	[%o1],%g3
/* 0x10b0	     */		stb	%g3,[%o3]
/* 0x10b4	     */		ldub	[%o1+1],%g2
/* 0x10b8	     */		add	%o1,2,%o1
/* 0x10bc	     */		stb	%g2,[%o3+1]
/* 0x10c0	     */		add	%o3,2,%o3
/* 0x10c4	     */		bge,a	.L900001447
/* 0x10c8	     */		subcc	%o2,2,%o2

! Registers live out of .L900001447: 
! g1 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001221 .L900001407 .L900001447

			.L900001223:
/* 0x10cc	 802 */		cmp	%o2,-1
/* 0x10d0	     */		bl,a	.L900001445
/* 0x10d4	 803 */		ld	[%sp+108],%o1

! Registers live out of .L900001223: 
! o0 o1 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001223

			.L900001224:
/* 0x10d8	 802 */		ldub	[%o1],%o1
/* 0x10dc	     */		stb	%o1,[%o3]
/* 0x10e0	     */		ba	.L900001445
/* 0x10e4	 803 */		ld	[%sp+108],%o1

! Registers live out of .L900001224: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001220

			.L900001225:
/* 0x10e8	 802 */		subcc	%o2,4,%g3
/* 0x10ec	     */		bl	.L900001228
/* 0x10f0	     */		sra	%o2,1,%o7

! Registers live out of .L900001225: 
! g1 g3 o0 o1 o2 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001225

			.L900001393:
/* 0x10f4	 802 */		srl	%o7,30,%o4
/* 0x10f8	     */		add	%o2,%o4,%i5
/* 0x10fc	     */		sra	%i5,2,%l4
/* 0x1100	     */		cmp	%l4,1
/* 0x1104	     */		bl	.L900001226
/* 0x1108	     */		nop

! Registers live out of .L900001393: 
! g1 g3 o0 o1 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001392 .L900001393

			.L900001392:
/* 0x110c	 802 */		sub	%g3,4,%g3
/* 0x1110	     */		add	%o3,4,%o3
/* 0x1114	     */		ld	[%o1],%f10
/* 0x1118	     */		cmp	%g3,0
/* 0x111c	     */		add	%o1,4,%o1
/* 0x1120	     */		bge	.L900001392
/* 0x1124	     */		st	%f10,[%o3-4]

! Registers live out of .L900001392: 
! g1 g3 o0 o1 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001392

			.L900001395:
/* 0x1128	 802 */		ba	.L900001227
/* 0x112c	     */		nop

! Registers live out of .L900001395: 
! g3 o0 o1 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001393

			.L900001226:
/* 0x1130	 802 */		subcc	%g3,4,%g3

! Registers live out of .L900001226: 
! g1 g3 o0 o1 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001226 .L900001446

			.L900001446:
/* 0x1134	 802 */		ld	[%o1],%f10
/* 0x1138	     */		add	%o1,4,%o1
/* 0x113c	     */		st	%f10,[%o3]
/* 0x1140	     */		add	%o3,4,%o3
/* 0x1144	     */		bge,a	.L900001446
/* 0x1148	     */		subcc	%g3,4,%g3

! Registers live out of .L900001446: 
! g1 g3 o0 o1 o3 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001395 .L900001446

			.L900001227:
/* 0x114c	 802 */		add	%g3,4,%o2

! Registers live out of .L900001227: 
! o0 o1 o2 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001225 .L900001227

			.L900001228:
/* 0x1150	 802 */		andcc	%i1,3,%g0
/* 0x1154	     */		be	.L900001234
/* 0x1158	     */		subcc	%o2,1,%o2

! Registers live out of .L900001228: 
! o0 o1 o2 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001228

			.L900001229:
/* 0x115c	 802 */		ldub	[%o1],%g4
/* 0x1160	     */		ble	.L900001234
/* 0x1164	     */		stb	%g4,[%o3]

! Registers live out of .L900001229: 
! o0 o1 o2 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001229

			.L900001230:
/* 0x1168	 802 */		ldub	[%o1+1],%i5
/* 0x116c	     */		subcc	%o2,1,%o2
/* 0x1170	     */		ble	.L900001234
/* 0x1174	     */		stb	%i5,[%o3+1]

! Registers live out of .L900001230: 
! o0 o1 o3 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001230

			.L900001231:
/* 0x1178	 802 */		ldub	[%o1+2],%l4
/* 0x117c	     */		stb	%l4,[%o3+2]
/* 0x1180	     */		ba	.L900001445
/* 0x1184	 803 */		ld	[%sp+108],%o1

! Registers live out of .L900001231: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001448

			.L900001232:
/* 0x1188	 802 */		xor	%g1,-256,%g1
/* 0x118c	     */		add	%g1,%fp,%g1
/* 0x1190	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x1194	     */		or	%g0,%g1,%o0

! Registers live out of .L900001232: 
! o0 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  803		      !      MEMCPY( atmp, a, n * sizeof(GLubyte) );

                       
! predecessor blocks: .L900001228 .L900001229 .L900001230 .L900001232

			.L900001234:
/* 0x1198	 803 */		ld	[%sp+108],%o1

! Registers live out of .L900001234: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001223 .L900001224 .L900001231 .L900001234

			.L900001445:
/* 0x119c	 803 */		or	%g0,%i1,%o2
/* 0x11a0	     */		cmp	%o2,32
/* 0x11a4	     */		bg	.L900001216
/* 0x11a8	     */		sethi	%hi(0x1c00),%g1

! Registers live out of .L900001445: 
! g1 o0 o1 o2 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001445

			.L900001204:
/* 0x11ac	 803 */		and	%o1,3,%o5
/* 0x11b0	     */		xor	%g1,-832,%g1
/* 0x11b4	     */		orcc	%o5,0,%g0
/* 0x11b8	     */		add	%g1,%fp,%g1
/* 0x11bc	     */		be	.L900001209
/* 0x11c0	     */		or	%g0,%g1,%o7

! Registers live out of .L900001204: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001204

			.L900001205:
/* 0x11c4	 803 */		subcc	%o2,2,%o2
/* 0x11c8	     */		bl	.L900001207
/* 0x11cc	     */		sub	%o2,-2,%g3

! Registers live out of .L900001205: 
! g3 o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001205

			.L900001401:
/* 0x11d0	 803 */		srl	%g3,31,%l4
/* 0x11d4	     */		add	%g3,%l4,%g2
/* 0x11d8	     */		sra	%g2,1,%g4
/* 0x11dc	     */		cmp	%g4,1
/* 0x11e0	     */		bl	.L900001206
/* 0x11e4	     */		nop

! Registers live out of .L900001401: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001401

			.L900001402:
/* 0x11e8	 803 */		sethi	%hi(0x1c00),%g1
/* 0x11ec	     */		xor	%g1,-832,%g1
/* 0x11f0	     */		or	%g0,%o2,%o5
/* 0x11f4	     */		add	%g1,%fp,%o0
/* 0x11f8	     */		or	%g0,%o1,%o3

! Registers live out of .L900001402: 
! o0 o3 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001400 .L900001402

			.L900001400:
/* 0x11fc	 803 */		sub	%o5,2,%o5
/* 0x1200	     */		add	%o0,2,%o0
/* 0x1204	     */		ldub	[%o3],%l4
/* 0x1208	     */		cmp	%o5,0
/* 0x120c	     */		add	%o3,2,%o3
/* 0x1210	     */		stb	%l4,[%o0-2]
/* 0x1214	     */		ldub	[%o3-1],%i5
/* 0x1218	     */		bge	.L900001400
/* 0x121c	     */		stb	%i5,[%o0-1]

! Registers live out of .L900001400: 
! o0 o3 o5 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001400

			.L900001403:
/* 0x1220	 803 */		or	%g0,%o5,%o2
/* 0x1224	     */		or	%g0,%o0,%o7
/* 0x1228	     */		or	%g0,%o3,%o1
/* 0x122c	     */		ba	.L900001207
/* 0x1230	     */		nop

! Registers live out of .L900001403: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001401

			.L900001206:
/* 0x1234	 803 */		subcc	%o2,2,%o2

! Registers live out of .L900001206: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001206 .L900001444

			.L900001444:
/* 0x1238	 803 */		ldub	[%o1],%l4
/* 0x123c	     */		stb	%l4,[%o7]
/* 0x1240	     */		ldub	[%o1+1],%i5
/* 0x1244	     */		add	%o1,2,%o1
/* 0x1248	     */		stb	%i5,[%o7+1]
/* 0x124c	     */		add	%o7,2,%o7
/* 0x1250	     */		bge,a	.L900001444
/* 0x1254	     */		subcc	%o2,2,%o2

! Registers live out of .L900001444: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001205 .L900001403 .L900001444

			.L900001207:
/* 0x1258	 803 */		cmp	%o2,-1
/* 0x125c	     */		bl,a	.L900001442
/* 0x1260	 804 */		or	%g0,1029,%o1

! Registers live out of .L900001207: 
! o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001207

			.L900001208:
/* 0x1264	 803 */		ldub	[%o1],%o0
/* 0x1268	     */		stb	%o0,[%o7]
/* 0x126c	     */		ba	.L900001442

!  804		      !      (*ctx->Driver.SetBuffer)( ctx, GL_BACK );

/* 0x1270	 804 */		or	%g0,1029,%o1

! Registers live out of .L900001208: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001204

			.L900001209:
/* 0x1274	 803 */		subcc	%o2,4,%g2
/* 0x1278	     */		bl	.L900001212
/* 0x127c	     */		or	%g0,%o2,%o5

! Registers live out of .L900001209: 
! g2 o0 o1 o2 o5 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001209

			.L900001397:
/* 0x1280	 803 */		sra	%o2,1,%o2
/* 0x1284	     */		srl	%o2,30,%l6
/* 0x1288	     */		add	%o5,%l6,%g3
/* 0x128c	     */		sra	%g3,2,%g5
/* 0x1290	     */		cmp	%g5,1
/* 0x1294	     */		bl	.L900001210
/* 0x1298	     */		nop

! Registers live out of .L900001397: 
! g2 o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001397

			.L900001398:
/* 0x129c	 803 */		or	%g0,%o1,%g4

! Registers live out of .L900001398: 
! g2 g4 o0 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001396 .L900001398

			.L900001396:
/* 0x12a0	 803 */		sub	%g2,4,%g2
/* 0x12a4	     */		add	%o7,4,%o7
/* 0x12a8	     */		ld	[%g4],%f12
/* 0x12ac	     */		cmp	%g2,0
/* 0x12b0	     */		add	%g4,4,%g4
/* 0x12b4	     */		bge	.L900001396
/* 0x12b8	     */		st	%f12,[%o7-4]

! Registers live out of .L900001396: 
! g2 g4 o0 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001396

			.L900001399:
/* 0x12bc	 803 */		or	%g0,%g4,%o1
/* 0x12c0	     */		ba	.L900001211
/* 0x12c4	     */		nop

! Registers live out of .L900001399: 
! g2 o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001397

			.L900001210:
/* 0x12c8	 803 */		subcc	%g2,4,%g2

! Registers live out of .L900001210: 
! g2 o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001210 .L900001443

			.L900001443:
/* 0x12cc	 803 */		ld	[%o1],%f12
/* 0x12d0	     */		add	%o1,4,%o1
/* 0x12d4	     */		st	%f12,[%o7]
/* 0x12d8	     */		add	%o7,4,%o7
/* 0x12dc	     */		bge,a	.L900001443
/* 0x12e0	     */		subcc	%g2,4,%g2

! Registers live out of .L900001443: 
! g2 o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001399 .L900001443

			.L900001211:
/* 0x12e4	 803 */		add	%g2,4,%o2

! Registers live out of .L900001211: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001209 .L900001211

			.L900001212:
/* 0x12e8	 803 */		andcc	%i1,3,%g0
/* 0x12ec	     */		be	.L900001218
/* 0x12f0	     */		subcc	%o2,1,%o2

! Registers live out of .L900001212: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001212

			.L900001213:
/* 0x12f4	 803 */		ldub	[%o1],%o4
/* 0x12f8	     */		ble	.L900001218
/* 0x12fc	     */		stb	%o4,[%o7]

! Registers live out of .L900001213: 
! o0 o1 o2 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001213

			.L900001214:
/* 0x1300	 803 */		ldub	[%o1+1],%g5
/* 0x1304	     */		subcc	%o2,1,%o2
/* 0x1308	     */		ble	.L900001218
/* 0x130c	     */		stb	%g5,[%o7+1]

! Registers live out of .L900001214: 
! o0 o1 sp o7 l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001214

			.L900001215:
/* 0x1310	 803 */		ldub	[%o1+2],%o2
/* 0x1314	     */		stb	%o2,[%o7+2]
/* 0x1318	     */		ba	.L900001442
/* 0x131c	 804 */		or	%g0,1029,%o1

! Registers live out of .L900001215: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001445

			.L900001216:
/* 0x1320	 803 */		xor	%g1,-832,%g1
/* 0x1324	     */		add	%g1,%fp,%g1
/* 0x1328	     */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x132c	     */		or	%g0,%g1,%o0

! Registers live out of .L900001216: 
! o0 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001212 .L900001213 .L900001214 .L900001216

			.L900001218:
/* 0x1330	 804 */		or	%g0,1029,%o1

! Registers live out of .L900001218: 
! o0 o1 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001207 .L900001208 .L900001215 .L900001218

			.L900001442:
/* 0x1334	 804 */		ld	[%i0+2236],%l6
/* 0x1338	     */		jmpl	%l6,%o7
/* 0x133c	     */		or	%g0,%i0,%o0

!  805		      !      if (ctx->Color.SWLogicOpEnabled) {

/* 0x1340	 805 */		ldub	[%i0+%i4],%i4
/* 0x1344	     */		cmp	%i4,0
/* 0x1348	     */		be,pn	%icc,.L77003628
/* 0x134c	 806 */		add	%fp,-1600,%l6

! Registers live out of .L900001442: 
! o0 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  806		      !         gl_logicop_rgba_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L900001442

			.L77003626:
/* 0x1350	 806 */		srl	%l6,0,%o2
/* 0x1354	     */		sllx	%l3,32,%o7
/* 0x1358	     */		or	%o7,%o2,%o2
/* 0x135c	     */		or	%g0,%l1,%o5
/* 0x1360	     */		or	%g0,%l2,%o4
/* 0x1364	     */		stx	%o2,[%sp+96]
/* 0x1368	     */		or	%g0,%i3,%o3
/* 0x136c	     */		or	%g0,%i2,%o2
/* 0x1370	     */		or	%g0,%i1,%o1
/* 0x1374	     */		st	%l0,[%sp+92]
/* 0x1378	     */		call	gl_logicop_rgba_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x137c	     */		or	%g0,%i0,%o0
/* 0x1380	     */		ba	.L900001441
/* 0x1384	 811 */		ldub	[%i0+%l5],%l6

! Registers live out of .L77003626: 
! o0 sp l0 l1 l2 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  807		      !      }
!  808		      !      else if (ctx->Color.BlendEnabled) {

                       
! predecessor blocks: .L900001442

			.L77003628:
/* 0x1388	 808 */		sethi	%hi(0x1c00),%l4
/* 0x138c	     */		add	%l4,685,%g4
/* 0x1390	     */		ldub	[%i0+%g4],%o1
/* 0x1394	     */		cmp	%o1,0
/* 0x1398	     */		be,pn	%icc,.L77003634
/* 0x139c	 809 */		add	%fp,-1600,%i4

! Registers live out of .L77003628: 
! o0 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  809		      !         gl_blend_span( ctx, n, x, y, red, green, blue, alpha, mask );

                       
! predecessor blocks: .L77003628

			.L77003630:
/* 0x13a0	 809 */		sllx	%l3,32,%g3
/* 0x13a4	     */		srl	%i4,0,%g5
/* 0x13a8	     */		or	%g3,%g5,%g5
/* 0x13ac	     */		or	%g0,%l1,%o5
/* 0x13b0	     */		or	%g0,%l2,%o4
/* 0x13b4	     */		or	%g0,%i3,%o3
/* 0x13b8	     */		or	%g0,%i2,%o2
/* 0x13bc	     */		stx	%g5,[%sp+96]
/* 0x13c0	     */		or	%g0,%i1,%o1
/* 0x13c4	     */		st	%l0,[%sp+92]
/* 0x13c8	     */		call	gl_blend_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x13cc	     */		or	%g0,%i0,%o0

! Registers live out of .L77003630: 
! o0 sp l0 l1 l2 l5 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  810		      !      }
!  811		      !      if (ctx->Color.SWmasking) {

                       
! predecessor blocks: .L77003628 .L77003630

			.L77003634:
/* 0x13d0	 811 */		ldub	[%i0+%l5],%l6

! Registers live out of .L77003634: 
! o0 sp l0 l1 l2 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003626 .L77003634

			.L900001441:
/* 0x13d4	 811 */		cmp	%l6,0
/* 0x13d8	     */		be,pn	%icc,.L77003638
/* 0x13dc	 812 */		or	%g0,%l1,%o5

! Registers live out of .L900001441: 
! o0 o5 sp l0 l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  812		      !         gl_mask_color_span( ctx, n, x, y, red, green, blue, alpha );

                       
! predecessor blocks: .L900001441

			.L77003636:
/* 0x13e0	 812 */		or	%g0,%l2,%o4
/* 0x13e4	     */		or	%g0,%i3,%o3
/* 0x13e8	     */		or	%g0,%i2,%o2
/* 0x13ec	     */		st	%l0,[%sp+92]
/* 0x13f0	     */		or	%g0,%i1,%o1
/* 0x13f4	     */		st	%l3,[%sp+96]
/* 0x13f8	     */		call	gl_mask_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x13fc	     */		or	%g0,%i0,%o0

! Registers live out of .L77003636: 
! o0 sp l0 l1 l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  813		      !      }
!  814		      !      (*ctx->Driver.WriteColorSpan)( ctx, n, x, y, red, green, blue, alpha,
!  815		      !                                     write_all ? NULL : mask );

                       
! predecessor blocks: .L77003636 .L900001441

			.L77003638:
/* 0x1400	 815 */		cmp	%l7,0
/* 0x1404	     */		be,pn	%icc,.L77003642
/* 0x1408	     */		or	%g0,%l1,%o5

! Registers live out of .L77003638: 
! o0 o5 sp l0 l2 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003638

			.L77003640:
/* 0x140c	 815 */		or	%g0,%l2,%o4
/* 0x1410	     */		sllx	%l3,32,%o7
/* 0x1414	     */		or	%g0,%i3,%o3
/* 0x1418	     */		or	%g0,%i2,%o2
/* 0x141c	     */		ld	[%i0+2244],%l2
/* 0x1420	     */		or	%g0,%i1,%o1
/* 0x1424	     */		stx	%o7,[%sp+96]
/* 0x1428	     */		st	%l0,[%sp+92]
/* 0x142c	     */		jmpl	%l2,%o7
/* 0x1430	     */		or	%g0,%i0,%o0

!  816		      !      (*ctx->Driver.SetBuffer)( ctx, GL_FRONT );

/* 0x1434	 816 */		or	%g0,1028,%o1
/* 0x1438	     */		ld	[%i0+2236],%l0
/* 0x143c	     */		jmpl	%l0,%o7
/* 0x1440	     */		or	%g0,%i0,%o0

!  817		      !      if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x1444	 817 */		sethi	%hi(0xe000),%o1
/* 0x1448	     */		add	%o1,264,%o4
/* 0x144c	     */		ld	[%i0+%o4],%l1
/* 0x1450	     */		andcc	%l1,256,%g0
/* 0x1454	     */		be,pn	%icc,.L77003657

!  818		      !         ctx->Buffer->Alpha = ctx->Buffer->BackAlpha;
!  819		      !         gl_write_alpha_span( ctx, n, x, y, alpha, write_all ? NULL : mask );

/* 0x1458	 819 */		or	%g0,0,%o5

! Registers live out of .L77003640: 
! o0 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003640

			.L77003646:
/* 0x145c	 818 */		ld	[%i0+2204],%i5
/* 0x1460	     */		ld	[%i5+28],%i4
/* 0x1464	     */		st	%i4,[%i5+32]
/* 0x1468	 819 */		ba	.L900001440
/* 0x146c	     */		or	%g0,%l3,%o4

! Registers live out of .L77003646: 
! o0 o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003638

			.L77003642:
/* 0x1470	 815 */		add	%fp,-1600,%i5
/* 0x1474	     */		srl	%i5,0,%g5
/* 0x1478	     */		sllx	%l3,32,%o0
/* 0x147c	     */		or	%o0,%g5,%o2
/* 0x1480	     */		or	%g0,%l2,%o4
/* 0x1484	     */		or	%g0,%i3,%o3
/* 0x1488	     */		or	%g0,%i1,%o1
/* 0x148c	     */		stx	%o2,[%sp+96]
/* 0x1490	     */		or	%g0,%i2,%o2
/* 0x1494	     */		ld	[%i0+2244],%l5
/* 0x1498	     */		st	%l0,[%sp+92]
/* 0x149c	     */		jmpl	%l5,%o7
/* 0x14a0	     */		or	%g0,%i0,%o0
/* 0x14a4	 816 */		or	%g0,1028,%o1
/* 0x14a8	 817 */		sethi	%hi(0xe000),%l5
/* 0x14ac	 816 */		ld	[%i0+2236],%o4
/* 0x14b0	     */		jmpl	%o4,%o7
/* 0x14b4	     */		or	%g0,%i0,%o0
/* 0x14b8	 817 */		add	%l5,264,%g4
/* 0x14bc	     */		ld	[%i0+%g4],%o3
/* 0x14c0	     */		andcc	%o3,256,%g0
/* 0x14c4	     */		be,pn	%icc,.L77003657
/* 0x14c8	 819 */		add	%fp,-1600,%o5

! Registers live out of .L77003642: 
! o0 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003642

			.L77003755:
/* 0x14cc	 818 */		ld	[%i0+2204],%l7
/* 0x14d0	 819 */		or	%g0,%l3,%o4
/* 0x14d4	 818 */		ld	[%l7+28],%l5
/* 0x14d8	     */		st	%l5,[%l7+32]

! Registers live out of .L77003755: 
! o0 o4 o5 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003646 .L77003755

			.L900001440:
/* 0x14dc	 819 */		or	%g0,%i3,%o3
/* 0x14e0	     */		or	%g0,%i1,%o1
/* 0x14e4	     */		or	%g0,%i2,%o2
/* 0x14e8	     */		call	gl_write_alpha_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x14ec	     */		or	%g0,%i0,%o0

!  820		      !         ctx->Buffer->Alpha = ctx->Buffer->FrontAlpha;

/* 0x14f0	 820 */		ld	[%i0+2204],%i1
/* 0x14f4	     */		ld	[%i1+24],%i3
/* 0x14f8	     */		st	%i3,[%i1+32]

! Registers live out of .L900001440: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003516 .L77003546 .L77003560 .L77003568 .L77003576 .L77003622 .L77003640 .L77003642 .L77003661 .L77003673
! predecessor blocks: .L77003677 .L900001440 .L900001456

			.L77003657:
/* 0x14fc	 698 */		ret	! Result = 
/* 0x1500	     */		restore	%g0,0,%g0
/* 0x1504	   0 */		.type	gl_write_texture_span,2
/* 0x1504	   0 */		.size	gl_write_texture_span,(.-gl_write_texture_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  821		      !      }
!  822		      !   }
!  823		      !}
!  827		      !/*
!  828		      ! * Read RGBA pixels from frame buffer.  Clipping will be done to prevent
!  829		      ! * reading ouside the buffer's boundaries.
!  830		      ! */
!  831		      !void gl_read_color_span( GLcontext *ctx,
!  832		      !                         GLuint n, GLint x, GLint y,
!  833		      !			 GLubyte red[], GLubyte green[],
!  834		      !			 GLubyte blue[], GLubyte alpha[] )
!  835		      !{

!
! SUBROUTINE gl_read_color_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_read_color_span
                       

			gl_read_color_span:
/* 000000	 835 */		save	%sp,-104,%sp
/* 0x0004	     */		orcc	%g0,%i3,%i3
/* 0x0008	     */		or	%g0,%i5,%l7

!  836		      !   register GLuint i;
!  838		      !   if (y<0 || y>=ctx->Buffer->Height || x>=ctx->Buffer->Width) {

/* 0x000c	 838 */		bl,pn	%icc,.L77003875
/* 0x0010	 835 */		or	%g0,%i4,%l1

! Registers live out of gl_read_color_span: 
! o3 sp l0 l1 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_read_color_span

			.L77003869:
/* 0x0014	 838 */		ld	[%i0+2204],%g2
/* 0x0018	     */		ld	[%g2+8],%g3
/* 0x001c	     */		cmp	%i3,%g3
/* 0x0020	     */		bge,pn	%icc,.L900001515
/* 0x0024	 840 */		cmp	%i1,0

! Registers live out of .L77003869: 
! g2 o3 sp l0 l1 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003869

			.L77003871:
/* 0x0028	 838 */		ld	[%g2+4],%o1
/* 0x002c	     */		cmp	%i2,%o1
/* 0x0030	     */		bge,pn	%icc,.L77003875
/* 0x0034	 840 */		ld	[%fp+92],%i5

! Registers live out of .L77003871: 
! o1 o3 sp l0 l1 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  839		      !      /* completely above, below, or right */
!  840		      !      for (i=0;i<n;i++) {
!  841		      !	 red[i] = green[i] = blue[i] = alpha[i] = 0;
!  842		      !      }
!  843		      !   }
!  844		      !   else {
!  845		      !      if (x>=0 && x+n<=ctx->Buffer->Width) {

                       
! predecessor blocks: .L77003871

			.L77003885:
/* 0x0038	 845 */		cmp	%i2,0
/* 0x003c	 840 */		ld	[%fp+96],%i4
/* 0x0040	 845 */		bl,pn	%icc,.L77003895
/* 0x0044	     */		add	%i2,%i1,%o0

! Registers live out of .L77003885: 
! o0 o1 o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003885

			.L77003887:
/* 0x0048	 845 */		cmp	%o0,%o1
/* 0x004c	     */		bgu,a,pn	%icc,.L77003913
/* 0x0050	 853 */		or	%g0,0,%o3

! Registers live out of .L77003887: 
! o0 o1 o3 sp l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  846		      !	 /* OK */
!  847		      !	 (*ctx->Driver.ReadColorSpan)( ctx, n, x, y, red, green, blue, alpha );

                       
! predecessor blocks: .L77003887

			.L77003889:
/* 0x0054	 847 */		or	%g0,%l7,%o5
/* 0x0058	     */		or	%g0,%l1,%o4
/* 0x005c	     */		or	%g0,%i3,%o3
/* 0x0060	     */		or	%g0,%i2,%o2
/* 0x0064	     */		ld	[%i0+2280],%l4
/* 0x0068	     */		or	%g0,%i1,%o1
/* 0x006c	     */		st	%i5,[%sp+92]
/* 0x0070	     */		st	%i4,[%sp+96]
/* 0x0074	     */		jmpl	%l4,%o7
/* 0x0078	     */		or	%g0,%i0,%o0

!  848		      !         if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x007c	 848 */		sethi	%hi(0xe000),%o2
/* 0x0080	     */		add	%o2,264,%g4
/* 0x0084	     */		ld	[%i0+%g4],%g5
/* 0x0088	     */		andcc	%g5,256,%g0
/* 0x008c	     */		be,pn	%icc,.L77003928
/* 0x0090	     */		nop

! Registers live out of .L77003889: 
! sp i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  849		      !            gl_read_alpha_span( ctx, n, x, y, alpha );

                       
! predecessor blocks: .L77003889

			.L77003891:
/* 0x0094	 849 */		call	gl_read_alpha_span	! params =  %i0 %i1 %i2 %i3 %i4	! Result = 	! (tail call)
/* 0x0098	     */		restore	%g0,0,%g0

!  850		      !         }
!  851		      !      }
!  852		      !      else {
!  853		      !	 i = 0;
!  854		      !	 if (x<0) {
!  855		      !	    while (x<0 && n>0) {

                       
! predecessor blocks: .L77003885

			.L77003895:
/* 0x009c	 855 */		cmp	%i1,0
/* 0x00a0	     */		bleu,pn	%icc,.L77003913
/* 0x00a4	 853 */		or	%g0,0,%o3

! Registers live out of .L77003895: 
! o1 o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  856		      !	       red[i] = green[i] =  blue[i] = alpha[i] = 0;

                       
! predecessor blocks: .L77003895

			.L77003903:
/* 0x00a8	 856 */		stb	%g0,[%o3+%i4]

! Registers live out of .L77003903: 
! o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003903 .L77003905

			.L900001514:
/* 0x00ac	 856 */		stb	%g0,[%o3+%i5]
/* 0x00b0	     */		stb	%g0,[%o3+%l7]

!  857		      !	       x++;

/* 0x00b4	 857 */		addcc	%i2,1,%i2

!  858		      !	       n--;

/* 0x00b8	 858 */		sub	%i1,1,%i1
/* 0x00bc	 856 */		stb	%g0,[%o3+%l1]
/* 0x00c0	 855 */		bge,pn	%icc,.L77003975

!  859		      !	       i++;

/* 0x00c4	 859 */		add	%o3,1,%o3

! Registers live out of .L900001514: 
! o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001514

			.L77003905:
/* 0x00c8	 855 */		cmp	%i1,0
/* 0x00cc	     */		bgu,a,pt	%icc,.L900001514
/* 0x00d0	 856 */		stb	%g0,[%o3+%i4]

! Registers live out of .L77003905: 
! o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003905

			.L77003973:
/* 0x00d4	 855 */		ld	[%i0+2204],%l5
/* 0x00d8	     */		ld	[%l5+4],%o1
/* 0x00dc	     */		ba	.L900001513
/* 0x00e0	 862 */		sub	%o1,%i2,%l0

! Registers live out of .L77003973: 
! o1 o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001514

			.L77003975:
/* 0x00e4	 855 */		ld	[%i0+2204],%l6
/* 0x00e8	     */		ld	[%l6+4],%o1

! Registers live out of .L77003975: 
! o1 o3 sp l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  860		      !	    }
!  861		      !	 }
!  862		      !	 n = MIN2( n, ctx->Buffer->Width - x );

                       
! predecessor blocks: .L77003887 .L77003895 .L77003975

			.L77003913:
/* 0x00ec	 862 */		sub	%o1,%i2,%l0

! Registers live out of .L77003913: 
! o1 o3 sp l0 l1 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  863		      !	 (*ctx->Driver.ReadColorSpan)( ctx, n, x, y, red+i, green+i, blue+i, alpha+i);

                       
! predecessor blocks: .L77003913 .L77003973

			.L900001513:
/* 0x00f0	 863 */		add	%l7,%o3,%o5
/* 0x00f4	     */		add	%l1,%o3,%o4
/* 0x00f8	     */		add	%i4,%o3,%i4
/* 0x00fc	     */		add	%i5,%o3,%i5
/* 0x0100	 862 */		cmp	%i1,%l0
/* 0x0104	     */		movcc	%icc,%l0,%i1
/* 0x0108	 863 */		or	%g0,%i3,%o3
/* 0x010c	     */		or	%g0,%i2,%o2
/* 0x0110	     */		ld	[%i0+2280],%l7
/* 0x0114	     */		or	%g0,%i0,%o0

!  864		      !         if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x0118	 864 */		sethi	%hi(0xe000),%l1
/* 0x011c	 863 */		st	%i5,[%sp+92]
/* 0x0120	 864 */		add	%l1,264,%l2
/* 0x0124	 863 */		st	%i4,[%sp+96]
/* 0x0128	     */		jmpl	%l7,%o7
/* 0x012c	     */		or	%g0,%i1,%o1
/* 0x0130	 864 */		ld	[%i0+%l2],%l3
/* 0x0134	     */		andcc	%l3,256,%g0
/* 0x0138	     */		be,pn	%icc,.L77003928
/* 0x013c	     */		nop

! Registers live out of .L900001513: 
! sp i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  865		      !            gl_read_alpha_span( ctx, n, x, y, alpha+i );

                       
! predecessor blocks: .L900001513

			.L77003921:
/* 0x0140	 865 */		call	gl_read_alpha_span	! params =  %i0 %i1 %i2 %i3 %i4	! Result = 	! (tail call)
/* 0x0144	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003871 gl_read_color_span

			.L77003875:
/* 0x0148	 840 */		cmp	%i1,0

! Registers live out of .L77003875: 
! sp l1 l7 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003869 .L77003875

			.L900001515:
/* 0x014c	 840 */		bleu,pn	%icc,.L77003928
/* 0x0150	     */		ld	[%fp+92],%i5

! Registers live out of .L900001515: 
! sp l1 l7 i1 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001515

			.L77003932:
/* 0x0154	 840 */		ld	[%fp+96],%i4
/* 0x0158	     */		cmp	%i1,14
/* 0x015c	     */		bl,pn	%icc,.L77003983
/* 0x0160	     */		sub	%i4,%l7,%l0

! Registers live out of .L77003932: 
! sp l0 l1 l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003932

			.L77003938:
/* 0x0164	 840 */		sra	%l0,31,%o5
/* 0x0168	     */		sub	%i4,%l1,%o4
/* 0x016c	     */		sub	%i4,%i5,%l2
/* 0x0170	     */		sub	%i5,%l7,%l3
/* 0x0174	     */		xor	%l0,%o5,%o7
/* 0x0178	     */		sra	%o4,31,%o2
/* 0x017c	     */		sra	%l2,31,%o0
/* 0x0180	     */		sra	%l3,31,%g4
/* 0x0184	     */		sub	%i5,%l1,%l4
/* 0x0188	     */		sub	%l7,%l1,%g1
/* 0x018c	     */		sub	%o7,%o5,%l5
/* 0x0190	     */		xor	%o4,%o2,%o3
/* 0x0194	     */		xor	%l2,%o0,%o1
/* 0x0198	     */		xor	%l3,%g4,%g5
/* 0x019c	     */		sra	%l4,31,%g2
/* 0x01a0	     */		sra	%g1,31,%i2
/* 0x01a4	     */		sub	%o3,%o2,%l6
/* 0x01a8	     */		sub	%o1,%o0,%l0
/* 0x01ac	     */		sub	%g5,%g4,%o7
/* 0x01b0	     */		xor	%l4,%g2,%g3
/* 0x01b4	     */		xor	%g1,%i2,%i3
/* 0x01b8	     */		sra	%i1,0,%o1
/* 0x01bc	     */		sub	%g3,%g2,%o5
/* 0x01c0	     */		sub	%i3,%i2,%i0
/* 0x01c4	     */		sra	%l5,0,%o4
/* 0x01c8	     */		sra	%l6,0,%o3
/* 0x01cc	     */		sra	%o7,0,%g4
/* 0x01d0	     */		sub	%o4,%o1,%g3
/* 0x01d4	     */		sub	%o3,%o1,%g2
/* 0x01d8	     */		sub	%g4,%o1,%o7
/* 0x01dc	     */		sra	%l0,0,%o2
/* 0x01e0	     */		sra	%o5,0,%g5
/* 0x01e4	     */		sra	%i0,0,%o0
/* 0x01e8	     */		sub	%o2,%o1,%g1
/* 0x01ec	     */		sub	%g5,%o1,%o5
/* 0x01f0	     */		sub	%o0,%o1,%o4
/* 0x01f4	     */		srlx	%g3,63,%l5
/* 0x01f8	     */		srlx	%g2,63,%i2
/* 0x01fc	     */		sethi	%hi(0x7ffffc00),%g4
/* 0x0200	     */		xor	%l5,1,%l6
/* 0x0204	     */		srlx	%g1,63,%i3
/* 0x0208	     */		xor	%i2,1,%l0
/* 0x020c	     */		add	%g4,1022,%g5
/* 0x0210	     */		srl	%i1,0,%o0
/* 0x0214	     */		and	%l0,%l6,%g1
/* 0x0218	     */		srlx	%o7,63,%l2
/* 0x021c	     */		srlx	%o5,63,%l3
/* 0x0220	     */		xor	%i3,1,%g3
/* 0x0224	     */		sub	%o0,%g5,%o1
/* 0x0228	     */		srlx	%o4,63,%l4
/* 0x022c	     */		xor	%l2,1,%i0
/* 0x0230	     */		xor	%l3,1,%o3
/* 0x0234	     */		srlx	%o1,63,%g2
/* 0x0238	     */		and	%g1,%g3,%o7
/* 0x023c	     */		and	%o3,%i0,%o5
/* 0x0240	     */		xor	%l4,1,%o2
/* 0x0244	     */		and	%o7,%g2,%o4
/* 0x0248	     */		and	%o2,1,%l5
/* 0x024c	     */		and	%o4,%o5,%i2
/* 0x0250	     */		andcc	%i2,%l5,%g0
/* 0x0254	     */		be,a,pn	%icc,.L77003934
/* 0x0258	     */		or	%g0,0,%l6

! Registers live out of .L77003938: 
! sp l1 l6 l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003938

			.L77003947:
/* 0x025c	 841 */		add	%i1,0,%i0
/* 0x0260	     */		cmp	%i0,4
/* 0x0264	 840 */		add	%i1,-1,%i1
/* 0x0268	     */		or	%g0,0,%i2
/* 0x026c	 841 */		bl,pn	%icc,.L77003949
/* 0x0270	     */		nop

! Registers live out of .L77003947: 
! sp l1 l7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003947

			.L900001509:
/* 0x0274	 841 */		sub	%i1,3,%i3

! Registers live out of .L900001509: 
! sp l1 l7 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001507 .L900001509

			.L900001507:
/* 0x0278	 841 */		prefetch	[%i4+66],2
/* 0x027c	     */		prefetch	[%i5+66],2
/* 0x0280	     */		stb	%g0,[%i4]
/* 0x0284	 840 */		add	%i2,4,%i2
/* 0x0288	     */		add	%i4,4,%i4
/* 0x028c	 841 */		stb	%g0,[%i5]
/* 0x0290	 840 */		cmp	%i2,%i3
/* 0x0294	     */		add	%i5,4,%i5
/* 0x0298	 841 */		stb	%g0,[%l7]
/* 0x029c	 840 */		add	%l7,4,%l7
/* 0x02a0	     */		add	%l1,4,%l1
/* 0x02a4	 841 */		stb	%g0,[%l1-4]
/* 0x02a8	     */		stb	%g0,[%i4-3]
/* 0x02ac	     */		stb	%g0,[%i5-3]
/* 0x02b0	     */		stb	%g0,[%l7-3]
/* 0x02b4	     */		stb	%g0,[%l1-3]
/* 0x02b8	     */		prefetch	[%l7+64],2
/* 0x02bc	     */		prefetch	[%l1+64],2
/* 0x02c0	     */		stb	%g0,[%i4-2]
/* 0x02c4	     */		stb	%g0,[%i5-2]
/* 0x02c8	     */		stb	%g0,[%l7-2]
/* 0x02cc	     */		stb	%g0,[%l1-2]
/* 0x02d0	     */		stb	%g0,[%i4-1]
/* 0x02d4	     */		stb	%g0,[%i5-1]
/* 0x02d8	     */		stb	%g0,[%l7-1]
/* 0x02dc	 840 */		ble,pt	%icc,.L900001507
/* 0x02e0	 841 */		stb	%g0,[%l1-1]

! Registers live out of .L900001507: 
! sp l1 l7 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001507

			.L900001510:
/* 0x02e4	 840 */		cmp	%i2,%i1
/* 0x02e8	     */		bg,pn	%icc,.L77003935
/* 0x02ec	 841 */		nop

! Registers live out of .L900001510: 
! sp l1 l7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003947 .L900001510

			.L77003949:
/* 0x02f0	 840 */		add	%i2,1,%i2

! Registers live out of .L77003949: 
! sp l1 l7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003949 .L900001512

			.L900001512:
/* 0x02f4	 841 */		stb	%g0,[%l1]
/* 0x02f8	 840 */		cmp	%i2,%i1
/* 0x02fc	 841 */		stb	%g0,[%l7]
/* 0x0300	 840 */		add	%l7,1,%l7
/* 0x0304	     */		add	%l1,1,%l1
/* 0x0308	 841 */		stb	%g0,[%i5]
/* 0x030c	 840 */		add	%i5,1,%i5
/* 0x0310	 841 */		stb	%g0,[%i4]
/* 0x0314	 840 */		add	%i4,1,%i4
/* 0x0318	     */		ble,pt	%icc,.L900001512
/* 0x031c	     */		add	%i2,1,%i2

! Registers live out of .L900001512: 
! sp l1 l7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001510 .L900001512

			.L77003935:
/* 0x0320	 865 */		ret	! Result = 
/* 0x0324	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003932

			.L77003983:
/* 0x0328	 840 */		or	%g0,0,%l6

! Registers live out of .L77003983: 
! sp l1 l6 l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003938 .L77003983

			.L77003934:
/* 0x032c	 841 */		stb	%g0,[%l6+%i4]

! Registers live out of .L77003934: 
! sp l1 l6 l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003934 .L900001511

			.L900001511:
/* 0x0330	 841 */		stb	%g0,[%l6+%i5]
/* 0x0334	     */		stb	%g0,[%l6+%l7]
/* 0x0338	     */		stb	%g0,[%l6+%l1]
/* 0x033c	 840 */		add	%l6,1,%l6
/* 0x0340	     */		cmp	%l6,%i1
/* 0x0344	     */		bcs,a,pt	%icc,.L900001511
/* 0x0348	 841 */		stb	%g0,[%l6+%i4]

! Registers live out of .L900001511: 
! sp l1 l6 l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003889 .L900001511 .L900001513 .L900001515

			.L77003928:
/* 0x034c	 865 */		ret	! Result = 
/* 0x0350	     */		restore	%g0,0,%g0
/* 0x0354	   0 */		.type	gl_read_color_span,2
/* 0x0354	   0 */		.size	gl_read_color_span,(.-gl_read_color_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  866		      !         }
!  867		      !      }
!  868		      !   }
!  869		      !}
!  874		      !/*
!  875		      ! * Read CI pixels from frame buffer.  Clipping will be done to prevent
!  876		      ! * reading ouside the buffer's boundaries.
!  877		      ! */
!  878		      !void gl_read_index_span( GLcontext *ctx,
!  879		      !                         GLuint n, GLint x, GLint y, GLuint indx[] )
!  880		      !{

!
! SUBROUTINE gl_read_index_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_read_index_span
                       

			gl_read_index_span:
/* 000000	 880 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i3,%i3

!  881		      !   register GLuint i;
!  883		      !   if (y<0 || y>=ctx->Buffer->Height || x>=ctx->Buffer->Width) {

/* 0x0008	 883 */		bl,pn	%icc,.L77004013
/* 0x000c	 880 */		or	%g0,%i1,%i5

! Registers live out of gl_read_index_span: 
! sp l0 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_read_index_span

			.L77004007:
/* 0x0010	 883 */		ld	[%i0+2204],%o0
/* 0x0014	     */		ld	[%o0+8],%o1
/* 0x0018	     */		cmp	%i3,%o1
/* 0x001c	     */		bge,pn	%icc,.L900001614
/* 0x0020	 885 */		cmp	%i1,0

! Registers live out of .L77004007: 
! o0 sp l0 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004007

			.L77004009:
/* 0x0024	 883 */		ld	[%o0+4],%l1
/* 0x0028	     */		cmp	%i2,%l1
/* 0x002c	     */		bge,pn	%icc,.L77004013
/* 0x0030	 890 */		cmp	%i2,0

! Registers live out of .L77004009: 
! o0 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  884		      !      /* completely above, below, or right */
!  885		      !      for (i=0;i<n;i++) {
!  886		      !	 indx[i] = 0;
!  887		      !      }
!  888		      !   }
!  889		      !   else {
!  890		      !      if (x>=0 && x+n<=ctx->Buffer->Width) {

                       
! predecessor blocks: .L77004009

			.L77004023:
/* 0x0034	 890 */		bl,pn	%icc,.L77004029
/* 0x0038	     */		add	%i2,%i1,%o2

! Registers live out of .L77004023: 
! o0 o2 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004023

			.L77004025:
/* 0x003c	 890 */		cmp	%o2,%l1
/* 0x0040	     */		bgu,a,pn	%icc,.L77004047
/* 0x0044	 895 */		or	%g0,0,%l0

! Registers live out of .L77004025: 
! sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  891		      !	 /* OK */
!  892		      !	 (*ctx->Driver.ReadIndexSpan)( ctx, n, x, y, indx );

                       
! predecessor blocks: .L77004025

			.L77004027:
/* 0x0048	 892 */		ld	[%i0+2276],%l2
/* 0x004c	     */		jmpl	%l2,%g0
/* 0x0050	     */		restore	%g0,0,%g0

!  893		      !      }
!  894		      !      else {
!  895		      !	 i = 0;
!  896		      !	 if (x<0) {
!  897		      !	    while (x<0 && n>0) {

                       
! predecessor blocks: .L77004023

			.L77004029:
/* 0x0054	 897 */		cmp	%i1,0
/* 0x0058	     */		bleu,pn	%icc,.L77004047
/* 0x005c	 895 */		or	%g0,0,%l0

! Registers live out of .L77004029: 
! o0 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  898		      !	       indx[i] = 0;
!  899		      !	       x++;

                       
! predecessor blocks: .L77004029

			.L77004037:
/* 0x0060	 899 */		addcc	%i2,1,%i2

! Registers live out of .L77004037: 
! o0 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004037 .L77004039

			.L900001613:
/* 0x0064	 898 */		sll	%l0,2,%l3

!  900		      !	       n--;

/* 0x0068	 900 */		sub	%i5,1,%i5

!  901		      !	       i++;

/* 0x006c	 901 */		add	%l0,1,%l0
/* 0x0070	 897 */		bge,pn	%icc,.L77004092
/* 0x0074	 898 */		st	%g0,[%l3+%i4]

! Registers live out of .L900001613: 
! o0 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001613

			.L77004039:
/* 0x0078	 897 */		cmp	%i5,0
/* 0x007c	     */		bgu,a,pt	%icc,.L900001613
/* 0x0080	 899 */		addcc	%i2,1,%i2

! Registers live out of .L77004039: 
! o0 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004039

			.L77004090:
/* 0x0084	 897 */		ld	[%o0+4],%l1
/* 0x0088	     */		ba	.L900001612
/* 0x008c	 904 */		sub	%l1,%i2,%i1

! Registers live out of .L77004090: 
! sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001613

			.L77004092:
/* 0x0090	 897 */		ld	[%o0+4],%l1

! Registers live out of .L77004092: 
! sp l0 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  902		      !	    }
!  903		      !	 }
!  904		      !	 n = MIN2( n, ctx->Buffer->Width - x );

                       
! predecessor blocks: .L77004025 .L77004029 .L77004092

			.L77004047:
/* 0x0094	 904 */		sub	%l1,%i2,%i1

! Registers live out of .L77004047: 
! sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  905		      !	 (*ctx->Driver.ReadIndexSpan)( ctx, n, x, y, indx+i );

                       
! predecessor blocks: .L77004047 .L77004090

			.L900001612:
/* 0x0098	 905 */		sll	%l0,2,%l5
/* 0x009c	     */		ld	[%i0+2276],%l4
/* 0x00a0	 904 */		cmp	%i5,%i1
/* 0x00a4	     */		movcs	%icc,%i5,%i1
/* 0x00a8	 905 */		add	%i4,%l5,%i4
/* 0x00ac	     */		jmpl	%l4,%g0
/* 0x00b0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004009 gl_read_index_span

			.L77004013:
/* 0x00b4	 885 */		cmp	%i1,0

! Registers live out of .L77004013: 
! sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004007 .L77004013

			.L900001614:
/* 0x00b8	 885 */		bleu,pn	%icc,.L77004058
/* 0x00bc	     */		cmp	%i1,2

! Registers live out of .L900001614: 
! sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001614

			.L77004062:
/* 0x00c0	 885 */		bl,pn	%icc,.L77004100
/* 0x00c4	     */		sethi	%hi(0x7ffffc00),%o7

! Registers live out of .L77004062: 
! sp o7 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004062

			.L77004068:
/* 0x00c8	 885 */		add	%o7,1022,%o5
/* 0x00cc	     */		srl	%i1,0,%o4
/* 0x00d0	     */		sub	%o4,%o5,%o3
/* 0x00d4	     */		srlx	%o3,63,%i0
/* 0x00d8	     */		andcc	%i0,1,%g0
/* 0x00dc	     */		be,a,pn	%icc,.L77004064
/* 0x00e0	     */		or	%g0,0,%l6

! Registers live out of .L77004068: 
! sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004068

			.L77004077:
/* 0x00e4	 886 */		cmp	%i1,4
/* 0x00e8	 885 */		add	%i1,-1,%i3
/* 0x00ec	     */		or	%g0,0,%i2
/* 0x00f0	 886 */		bl,pn	%icc,.L77004078
/* 0x00f4	     */		nop

! Registers live out of .L77004077: 
! sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004077

			.L900001608:
/* 0x00f8	 886 */		add	%i5,-4,%i5

! Registers live out of .L900001608: 
! sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001606 .L900001608

			.L900001606:
/* 0x00fc	 886 */		prefetch	[%i4+264],2
/* 0x0100	     */		st	%g0,[%i4]
/* 0x0104	 885 */		add	%i2,4,%i2
/* 0x0108	     */		add	%i4,16,%i4
/* 0x010c	 886 */		st	%g0,[%i4-12]
/* 0x0110	 885 */		cmp	%i2,%i5
/* 0x0114	 886 */		st	%g0,[%i4-8]
/* 0x0118	 885 */		ble,pt	%icc,.L900001606
/* 0x011c	 886 */		st	%g0,[%i4-4]

! Registers live out of .L900001606: 
! sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001606

			.L900001609:
/* 0x0120	 885 */		cmp	%i2,%i3
/* 0x0124	     */		bg,pn	%icc,.L900001604
/* 0x0128	 886 */		nop

! Registers live out of .L900001609: 
! sp i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004077 .L900001609

			.L77004078:
/* 0x012c	 885 */		add	%i2,1,%i2

! Registers live out of .L77004078: 
! sp i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004078 .L900001611

			.L900001611:
/* 0x0130	 885 */		cmp	%i2,%i3
/* 0x0134	 886 */		st	%g0,[%i4]
/* 0x0138	 885 */		add	%i4,4,%i4
/* 0x013c	     */		ble,pt	%icc,.L900001611
/* 0x0140	     */		add	%i2,1,%i2

! Registers live out of .L900001611: 
! sp i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001609 .L900001611

			.L900001604:
/* 0x0144	 905 */		ret	! Result = 
/* 0x0148	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004062

			.L77004100:
/* 0x014c	 885 */		or	%g0,0,%l6

! Registers live out of .L77004100: 
! sp l6 i1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004068 .L77004100

			.L77004064:
/* 0x0150	 886 */		sll	%l6,2,%l7

! Registers live out of .L77004064: 
! sp l6 l7 i1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004064 .L900001610

			.L900001610:
/* 0x0154	 885 */		add	%l6,1,%l6
/* 0x0158	     */		cmp	%l6,%i1
/* 0x015c	 886 */		st	%g0,[%l7+%i4]
/* 0x0160	 885 */		bcs,pt	%icc,.L900001610
/* 0x0164	 886 */		sll	%l6,2,%l7

! Registers live out of .L900001610: 
! sp l6 l7 i1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001610 .L900001614

			.L77004058:
/* 0x0168	 905 */		ret	! Result = 
/* 0x016c	     */		restore	%g0,0,%g0
/* 0x0170	   0 */		.type	gl_read_index_span,2
/* 0x0170	   0 */		.size	gl_read_index_span,(.-gl_read_index_span)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	335
/* 0x000c	   0 */		.word	1166
/* 0x0010	   0 */		.word	117
/* 0x0014	   0 */		.word	788
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	104
/* 0x0024	   0 */		.word	65571
/* 0x0028	   0 */		.word	1
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.align	4
/* 0x0030	   0 */		.word	-1
/* 0x0034	   0 */		.word	-1
/* 0x0038	   0 */		.word	104
/* 0x003c	   0 */		.word	4148
/* 0x0040	   0 */		.word	3
/* 0x0044	   0 */		.word	1
/* 0x0048	   0 */		.align	4
/* 0x0048	   0 */		.word	-1
/* 0x004c	   0 */		.word	-1
/* 0x0050	   0 */		.word	147
/* 0x0054	   0 */		.word	65571
/* 0x0058	   0 */		.word	1
/* 0x005c	   0 */		.word	4
/* 0x0060	   0 */		.align	4
/* 0x0060	   0 */		.word	-1
/* 0x0064	   0 */		.word	-1
/* 0x0068	   0 */		.word	186
/* 0x006c	   0 */		.word	16414
/* 0x0070	   0 */		.word	1
/* 0x0074	   0 */		.word	5
/* 0x0078	   0 */		.align	4
/* 0x0078	   0 */		.word	-1
/* 0x007c	   0 */		.word	-1
/* 0x0080	   0 */		.word	191
/* 0x0084	   0 */		.word	16414
/* 0x0088	   0 */		.word	1
/* 0x008c	   0 */		.word	6
/* 0x0090	   0 */		.align	4
/* 0x0090	   0 */		.word	-1
/* 0x0094	   0 */		.word	-1
/* 0x0098	   0 */		.word	203
/* 0x009c	   0 */		.word	16414
/* 0x00a0	   0 */		.word	1
/* 0x00a4	   0 */		.word	7
/* 0x00a8	   0 */		.align	4
/* 0x00a8	   0 */		.word	-1
/* 0x00ac	   0 */		.word	-1
/* 0x00b0	   0 */		.word	207
/* 0x00b4	   0 */		.word	16414
/* 0x00b8	   0 */		.word	1
/* 0x00bc	   0 */		.word	8
/* 0x00c0	   0 */		.align	4
/* 0x00c0	   0 */		.word	-1
/* 0x00c4	   0 */		.word	-1
/* 0x00c8	   0 */		.word	227
/* 0x00cc	   0 */		.word	16414
/* 0x00d0	   0 */		.word	1
/* 0x00d4	   0 */		.word	9
/* 0x00d8	   0 */		.align	4
/* 0x00d8	   0 */		.word	-1
/* 0x00dc	   0 */		.word	-1
/* 0x00e0	   0 */		.word	230
/* 0x00e4	   0 */		.word	16414
/* 0x00e8	   0 */		.word	1
/* 0x00ec	   0 */		.word	10
/* 0x00f0	   0 */		.align	4
/* 0x00f0	   0 */		.word	-1
/* 0x00f4	   0 */		.word	-1
/* 0x00f8	   0 */		.word	242
/* 0x00fc	   0 */		.word	16414
/* 0x0100	   0 */		.word	1
/* 0x0104	   0 */		.word	11
/* 0x0108	   0 */		.align	4
/* 0x0108	   0 */		.word	-1
/* 0x010c	   0 */		.word	-1
/* 0x0110	   0 */		.word	245
/* 0x0114	   0 */		.word	16414
/* 0x0118	   0 */		.word	1
/* 0x011c	   0 */		.word	12
/* 0x0120	   0 */		.align	4
/* 0x0120	   0 */		.word	-1
/* 0x0124	   0 */		.word	-1
/* 0x0128	   0 */		.word	178
/* 0x012c	   0 */		.word	16409
/* 0x0130	   0 */		.word	3
/* 0x0134	   0 */		.word	13
/* 0x0138	   0 */		.align	4
/* 0x0138	   0 */		.word	-1
/* 0x013c	   0 */		.word	-1
/* 0x0140	   0 */		.word	178
/* 0x0144	   0 */		.word	16411
/* 0x0148	   0 */		.word	3
/* 0x014c	   0 */		.word	16
/* 0x0150	   0 */		.align	4
/* 0x0150	   0 */		.word	-1
/* 0x0154	   0 */		.word	-1
/* 0x0158	   0 */		.word	198
/* 0x015c	   0 */		.word	16409
/* 0x0160	   0 */		.word	3
/* 0x0164	   0 */		.word	19
/* 0x0168	   0 */		.align	4
/* 0x0168	   0 */		.word	-1
/* 0x016c	   0 */		.word	-1
/* 0x0170	   0 */		.word	198
/* 0x0174	   0 */		.word	16411
/* 0x0178	   0 */		.word	3
/* 0x017c	   0 */		.word	22
/* 0x0180	   0 */		.align	4
/* 0x0180	   0 */		.word	-1
/* 0x0184	   0 */		.word	-1
/* 0x0188	   0 */		.word	198
/* 0x018c	   0 */		.word	4148
/* 0x0190	   0 */		.word	3
/* 0x0194	   0 */		.word	25
/* 0x0198	   0 */		.align	4
/* 0x0198	   0 */		.word	-1
/* 0x019c	   0 */		.word	-1
/* 0x01a0	   0 */		.word	240
/* 0x01a4	   0 */		.word	131089
/* 0x01a8	   0 */		.word	4
/* 0x01ac	   0 */		.word	28
/* 0x01b0	   0 */		.align	4
/* 0x01b0	   0 */		.word	-1
/* 0x01b4	   0 */		.word	-1
/* 0x01b8	   0 */		.word	223
/* 0x01bc	   0 */		.word	131089
/* 0x01c0	   0 */		.word	4
/* 0x01c4	   0 */		.word	32
/* 0x01c8	   0 */		.align	4
/* 0x01c8	   0 */		.word	-1
/* 0x01cc	   0 */		.word	-1
/* 0x01d0	   0 */		.word	175
/* 0x01d4	   0 */		.word	131089
/* 0x01d8	   0 */		.word	4
/* 0x01dc	   0 */		.word	36
/* 0x01e0	   0 */		.align	4
/* 0x01e0	   0 */		.word	-1
/* 0x01e4	   0 */		.word	-1
/* 0x01e8	   0 */		.word	223
/* 0x01ec	   0 */		.word	8218
/* 0x01f0	   0 */		.word	2
/* 0x01f4	   0 */		.word	40
/* 0x01f8	   0 */		.align	4
/* 0x01f8	   0 */		.word	-1
/* 0x01fc	   0 */		.word	-1
/* 0x0200	   0 */		.word	223
/* 0x0204	   0 */		.word	4122
/* 0x0208	   0 */		.word	2
/* 0x020c	   0 */		.word	42
/* 0x0210	   0 */		.align	4
/* 0x0210	   0 */		.word	-1
/* 0x0214	   0 */		.word	-1
/* 0x0218	   0 */		.word	223
/* 0x021c	   0 */		.word	4123
/* 0x0220	   0 */		.word	7
/* 0x0224	   0 */		.word	44
/* 0x0228	   0 */		.align	4
/* 0x0228	   0 */		.word	-1
/* 0x022c	   0 */		.word	-1
/* 0x0230	   0 */		.word	223
/* 0x0234	   0 */		.word	4145
/* 0x0238	   0 */		.word	7
/* 0x023c	   0 */		.word	51
/* 0x0240	   0 */		.align	4
/* 0x0240	   0 */		.word	-1
/* 0x0244	   0 */		.word	-1
/* 0x0248	   0 */		.word	240
/* 0x024c	   0 */		.word	8218
/* 0x0250	   0 */		.word	2
/* 0x0254	   0 */		.word	58
/* 0x0258	   0 */		.align	4
/* 0x0258	   0 */		.word	-1
/* 0x025c	   0 */		.word	-1
/* 0x0260	   0 */		.word	240
/* 0x0264	   0 */		.word	4122
/* 0x0268	   0 */		.word	2
/* 0x026c	   0 */		.word	60
/* 0x0270	   0 */		.align	4
/* 0x0270	   0 */		.word	-1
/* 0x0274	   0 */		.word	-1
/* 0x0278	   0 */		.word	240
/* 0x027c	   0 */		.word	4123
/* 0x0280	   0 */		.word	7
/* 0x0284	   0 */		.word	62
/* 0x0288	   0 */		.align	4
/* 0x0288	   0 */		.word	-1
/* 0x028c	   0 */		.word	-1
/* 0x0290	   0 */		.word	240
/* 0x0294	   0 */		.word	4145
/* 0x0298	   0 */		.word	7
/* 0x029c	   0 */		.word	69
/* 0x02a0	   0 */		.align	4
/* 0x02a0	   0 */		.word	-1
/* 0x02a4	   0 */		.word	-1
/* 0x02a8	   0 */		.word	240
/* 0x02ac	   0 */		.word	8218
/* 0x02b0	   0 */		.word	2
/* 0x02b4	   0 */		.word	76
/* 0x02b8	   0 */		.align	4
/* 0x02b8	   0 */		.word	-1
/* 0x02bc	   0 */		.word	-1
/* 0x02c0	   0 */		.word	240
/* 0x02c4	   0 */		.word	4122
/* 0x02c8	   0 */		.word	2
/* 0x02cc	   0 */		.word	78
/* 0x02d0	   0 */		.align	4
/* 0x02d0	   0 */		.word	-1
/* 0x02d4	   0 */		.word	-1
/* 0x02d8	   0 */		.word	240
/* 0x02dc	   0 */		.word	4123
/* 0x02e0	   0 */		.word	7
/* 0x02e4	   0 */		.word	80
/* 0x02e8	   0 */		.align	4
/* 0x02e8	   0 */		.word	-1
/* 0x02ec	   0 */		.word	-1
/* 0x02f0	   0 */		.word	240
/* 0x02f4	   0 */		.word	4145
/* 0x02f8	   0 */		.word	7
/* 0x02fc	   0 */		.word	87
/* 0x0300	   0 */		.align	4
/* 0x0300	   0 */		.word	-1
/* 0x0304	   0 */		.word	-1
/* 0x0308	   0 */		.word	223
/* 0x030c	   0 */		.word	8218
/* 0x0310	   0 */		.word	2
/* 0x0314	   0 */		.word	94
/* 0x0318	   0 */		.align	4
/* 0x0318	   0 */		.word	-1
/* 0x031c	   0 */		.word	-1
/* 0x0320	   0 */		.word	223
/* 0x0324	   0 */		.word	4122
/* 0x0328	   0 */		.word	2
/* 0x032c	   0 */		.word	96
/* 0x0330	   0 */		.align	4
/* 0x0330	   0 */		.word	-1
/* 0x0334	   0 */		.word	-1
/* 0x0338	   0 */		.word	223
/* 0x033c	   0 */		.word	4123
/* 0x0340	   0 */		.word	7
/* 0x0344	   0 */		.word	98
/* 0x0348	   0 */		.align	4
/* 0x0348	   0 */		.word	-1
/* 0x034c	   0 */		.word	-1
/* 0x0350	   0 */		.word	223
/* 0x0354	   0 */		.word	4145
/* 0x0358	   0 */		.word	7
/* 0x035c	   0 */		.word	105
/* 0x0360	   0 */		.align	4
/* 0x0360	   0 */		.word	-1
/* 0x0364	   0 */		.word	-1
/* 0x0368	   0 */		.word	175
/* 0x036c	   0 */		.word	4148
/* 0x0370	   0 */		.word	3
/* 0x0374	   0 */		.word	112
/* 0x0378	   0 */		.align	4
/* 0x0378	   0 */		.word	-1
/* 0x037c	   0 */		.word	-1
/* 0x0380	   0 */		.word	175
/* 0x0384	   0 */		.word	8218
/* 0x0388	   0 */		.word	2
/* 0x038c	   0 */		.word	115
/* 0x0390	   0 */		.align	4
/* 0x0390	   0 */		.word	-1
/* 0x0394	   0 */		.word	-1
/* 0x0398	   0 */		.word	175
/* 0x039c	   0 */		.word	4122
/* 0x03a0	   0 */		.word	2
/* 0x03a4	   0 */		.word	117
/* 0x03a8	   0 */		.align	4
/* 0x03a8	   0 */		.word	-1
/* 0x03ac	   0 */		.word	-1
/* 0x03b0	   0 */		.word	175
/* 0x03b4	   0 */		.word	4123
/* 0x03b8	   0 */		.word	7
/* 0x03bc	   0 */		.word	119
/* 0x03c0	   0 */		.align	4
/* 0x03c0	   0 */		.word	-1
/* 0x03c4	   0 */		.word	-1
/* 0x03c8	   0 */		.word	175
/* 0x03cc	   0 */		.word	4145
/* 0x03d0	   0 */		.word	7
/* 0x03d4	   0 */		.word	126
/* 0x03d8	   0 */		.align	4
/* 0x03d8	   0 */		.word	-1
/* 0x03dc	   0 */		.word	-1
/* 0x03e0	   0 */		.word	274
/* 0x03e4	   0 */		.word	16414
/* 0x03e8	   0 */		.word	1
/* 0x03ec	   0 */		.word	133
/* 0x03f0	   0 */		.align	4
/* 0x03f0	   0 */		.word	-1
/* 0x03f4	   0 */		.word	-1
/* 0x03f8	   0 */		.word	286
/* 0x03fc	   0 */		.word	16414
/* 0x0400	   0 */		.word	1
/* 0x0404	   0 */		.word	134
/* 0x0408	   0 */		.align	4
/* 0x0408	   0 */		.word	-1
/* 0x040c	   0 */		.word	-1
/* 0x0410	   0 */		.word	290
/* 0x0414	   0 */		.word	16414
/* 0x0418	   0 */		.word	1
/* 0x041c	   0 */		.word	135
/* 0x0420	   0 */		.align	4
/* 0x0420	   0 */		.word	-1
/* 0x0424	   0 */		.word	-1
/* 0x0428	   0 */		.word	312
/* 0x042c	   0 */		.word	16414
/* 0x0430	   0 */		.word	1
/* 0x0434	   0 */		.word	136
/* 0x0438	   0 */		.align	4
/* 0x0438	   0 */		.word	-1
/* 0x043c	   0 */		.word	-1
/* 0x0440	   0 */		.word	320
/* 0x0444	   0 */		.word	16414
/* 0x0448	   0 */		.word	1
/* 0x044c	   0 */		.word	137
/* 0x0450	   0 */		.align	4
/* 0x0450	   0 */		.word	-1
/* 0x0454	   0 */		.word	-1
/* 0x0458	   0 */		.word	324
/* 0x045c	   0 */		.word	16414
/* 0x0460	   0 */		.word	1
/* 0x0464	   0 */		.word	138
/* 0x0468	   0 */		.align	4
/* 0x0468	   0 */		.word	-1
/* 0x046c	   0 */		.word	-1
/* 0x0470	   0 */		.word	336
/* 0x0474	   0 */		.word	16414
/* 0x0478	   0 */		.word	1
/* 0x047c	   0 */		.word	139
/* 0x0480	   0 */		.align	4
/* 0x0480	   0 */		.word	-1
/* 0x0484	   0 */		.word	-1
/* 0x0488	   0 */		.word	339
/* 0x048c	   0 */		.word	16414
/* 0x0490	   0 */		.word	1
/* 0x0494	   0 */		.word	140
/* 0x0498	   0 */		.align	4
/* 0x0498	   0 */		.word	-1
/* 0x049c	   0 */		.word	-1
/* 0x04a0	   0 */		.word	267
/* 0x04a4	   0 */		.word	16409
/* 0x04a8	   0 */		.word	3
/* 0x04ac	   0 */		.word	141
/* 0x04b0	   0 */		.align	4
/* 0x04b0	   0 */		.word	-1
/* 0x04b4	   0 */		.word	-1
/* 0x04b8	   0 */		.word	267
/* 0x04bc	   0 */		.word	16411
/* 0x04c0	   0 */		.word	3
/* 0x04c4	   0 */		.word	144
/* 0x04c8	   0 */		.align	4
/* 0x04c8	   0 */		.word	-1
/* 0x04cc	   0 */		.word	-1
/* 0x04d0	   0 */		.word	281
/* 0x04d4	   0 */		.word	16409
/* 0x04d8	   0 */		.word	3
/* 0x04dc	   0 */		.word	147
/* 0x04e0	   0 */		.align	4
/* 0x04e0	   0 */		.word	-1
/* 0x04e4	   0 */		.word	-1
/* 0x04e8	   0 */		.word	281
/* 0x04ec	   0 */		.word	16411
/* 0x04f0	   0 */		.word	3
/* 0x04f4	   0 */		.word	150
/* 0x04f8	   0 */		.align	4
/* 0x04f8	   0 */		.word	-1
/* 0x04fc	   0 */		.word	-1
/* 0x0500	   0 */		.word	306
/* 0x0504	   0 */		.word	65571
/* 0x0508	   0 */		.word	1
/* 0x050c	   0 */		.word	153
/* 0x0510	   0 */		.align	4
/* 0x0510	   0 */		.word	-1
/* 0x0514	   0 */		.word	-1
/* 0x0518	   0 */		.word	332
/* 0x051c	   0 */		.word	65571
/* 0x0520	   0 */		.word	1
/* 0x0524	   0 */		.word	154
/* 0x0528	   0 */		.align	4
/* 0x0528	   0 */		.word	-1
/* 0x052c	   0 */		.word	-1
/* 0x0530	   0 */		.word	306
/* 0x0534	   0 */		.word	4148
/* 0x0538	   0 */		.word	3
/* 0x053c	   0 */		.word	155
/* 0x0540	   0 */		.align	4
/* 0x0540	   0 */		.word	-1
/* 0x0544	   0 */		.word	-1
/* 0x0548	   0 */		.word	332
/* 0x054c	   0 */		.word	4148
/* 0x0550	   0 */		.word	3
/* 0x0554	   0 */		.word	158
/* 0x0558	   0 */		.align	4
/* 0x0558	   0 */		.word	-1
/* 0x055c	   0 */		.word	-1
/* 0x0560	   0 */		.word	281
/* 0x0564	   0 */		.word	4148
/* 0x0568	   0 */		.word	3
/* 0x056c	   0 */		.word	161
/* 0x0570	   0 */		.align	4
/* 0x0570	   0 */		.word	-1
/* 0x0574	   0 */		.word	-1
/* 0x0578	   0 */		.word	316
/* 0x057c	   0 */		.word	131089
/* 0x0580	   0 */		.word	4
/* 0x0584	   0 */		.word	164
/* 0x0588	   0 */		.align	4
/* 0x0588	   0 */		.word	-1
/* 0x058c	   0 */		.word	-1
/* 0x0590	   0 */		.word	264
/* 0x0594	   0 */		.word	131089
/* 0x0598	   0 */		.word	4
/* 0x059c	   0 */		.word	168
/* 0x05a0	   0 */		.align	4
/* 0x05a0	   0 */		.word	-1
/* 0x05a4	   0 */		.word	-1
/* 0x05a8	   0 */		.word	306
/* 0x05ac	   0 */		.word	8229
/* 0x05b0	   0 */		.word	1
/* 0x05b4	   0 */		.word	172
/* 0x05b8	   0 */		.align	4
/* 0x05b8	   0 */		.word	-1
/* 0x05bc	   0 */		.word	-1
/* 0x05c0	   0 */		.word	316
/* 0x05c4	   0 */		.word	8218
/* 0x05c8	   0 */		.word	2
/* 0x05cc	   0 */		.word	173
/* 0x05d0	   0 */		.align	4
/* 0x05d0	   0 */		.word	-1
/* 0x05d4	   0 */		.word	-1
/* 0x05d8	   0 */		.word	316
/* 0x05dc	   0 */		.word	4122
/* 0x05e0	   0 */		.word	2
/* 0x05e4	   0 */		.word	175
/* 0x05e8	   0 */		.align	4
/* 0x05e8	   0 */		.word	-1
/* 0x05ec	   0 */		.word	-1
/* 0x05f0	   0 */		.word	316
/* 0x05f4	   0 */		.word	4123
/* 0x05f8	   0 */		.word	7
/* 0x05fc	   0 */		.word	177
/* 0x0600	   0 */		.align	4
/* 0x0600	   0 */		.word	-1
/* 0x0604	   0 */		.word	-1
/* 0x0608	   0 */		.word	316
/* 0x060c	   0 */		.word	4145
/* 0x0610	   0 */		.word	7
/* 0x0614	   0 */		.word	184
/* 0x0618	   0 */		.align	4
/* 0x0618	   0 */		.word	-1
/* 0x061c	   0 */		.word	-1
/* 0x0620	   0 */		.word	332
/* 0x0624	   0 */		.word	8229
/* 0x0628	   0 */		.word	1
/* 0x062c	   0 */		.word	191
/* 0x0630	   0 */		.align	4
/* 0x0630	   0 */		.word	-1
/* 0x0634	   0 */		.word	-1
/* 0x0638	   0 */		.word	332
/* 0x063c	   0 */		.word	8218
/* 0x0640	   0 */		.word	2
/* 0x0644	   0 */		.word	192
/* 0x0648	   0 */		.align	4
/* 0x0648	   0 */		.word	-1
/* 0x064c	   0 */		.word	-1
/* 0x0650	   0 */		.word	332
/* 0x0654	   0 */		.word	4122
/* 0x0658	   0 */		.word	2
/* 0x065c	   0 */		.word	194
/* 0x0660	   0 */		.align	4
/* 0x0660	   0 */		.word	-1
/* 0x0664	   0 */		.word	-1
/* 0x0668	   0 */		.word	332
/* 0x066c	   0 */		.word	4123
/* 0x0670	   0 */		.word	7
/* 0x0674	   0 */		.word	196
/* 0x0678	   0 */		.align	4
/* 0x0678	   0 */		.word	-1
/* 0x067c	   0 */		.word	-1
/* 0x0680	   0 */		.word	332
/* 0x0684	   0 */		.word	4145
/* 0x0688	   0 */		.word	7
/* 0x068c	   0 */		.word	203
/* 0x0690	   0 */		.align	4
/* 0x0690	   0 */		.word	-1
/* 0x0694	   0 */		.word	-1
/* 0x0698	   0 */		.word	316
/* 0x069c	   0 */		.word	8218
/* 0x06a0	   0 */		.word	2
/* 0x06a4	   0 */		.word	210
/* 0x06a8	   0 */		.align	4
/* 0x06a8	   0 */		.word	-1
/* 0x06ac	   0 */		.word	-1
/* 0x06b0	   0 */		.word	316
/* 0x06b4	   0 */		.word	4122
/* 0x06b8	   0 */		.word	2
/* 0x06bc	   0 */		.word	212
/* 0x06c0	   0 */		.align	4
/* 0x06c0	   0 */		.word	-1
/* 0x06c4	   0 */		.word	-1
/* 0x06c8	   0 */		.word	316
/* 0x06cc	   0 */		.word	4123
/* 0x06d0	   0 */		.word	7
/* 0x06d4	   0 */		.word	214
/* 0x06d8	   0 */		.align	4
/* 0x06d8	   0 */		.word	-1
/* 0x06dc	   0 */		.word	-1
/* 0x06e0	   0 */		.word	316
/* 0x06e4	   0 */		.word	4145
/* 0x06e8	   0 */		.word	7
/* 0x06ec	   0 */		.word	221
/* 0x06f0	   0 */		.align	4
/* 0x06f0	   0 */		.word	-1
/* 0x06f4	   0 */		.word	-1
/* 0x06f8	   0 */		.word	306
/* 0x06fc	   0 */		.word	8218
/* 0x0700	   0 */		.word	2
/* 0x0704	   0 */		.word	228
/* 0x0708	   0 */		.align	4
/* 0x0708	   0 */		.word	-1
/* 0x070c	   0 */		.word	-1
/* 0x0710	   0 */		.word	306
/* 0x0714	   0 */		.word	4122
/* 0x0718	   0 */		.word	2
/* 0x071c	   0 */		.word	230
/* 0x0720	   0 */		.align	4
/* 0x0720	   0 */		.word	-1
/* 0x0724	   0 */		.word	-1
/* 0x0728	   0 */		.word	306
/* 0x072c	   0 */		.word	4123
/* 0x0730	   0 */		.word	7
/* 0x0734	   0 */		.word	232
/* 0x0738	   0 */		.align	4
/* 0x0738	   0 */		.word	-1
/* 0x073c	   0 */		.word	-1
/* 0x0740	   0 */		.word	306
/* 0x0744	   0 */		.word	4145
/* 0x0748	   0 */		.word	7
/* 0x074c	   0 */		.word	239
/* 0x0750	   0 */		.align	4
/* 0x0750	   0 */		.word	-1
/* 0x0754	   0 */		.word	-1
/* 0x0758	   0 */		.word	264
/* 0x075c	   0 */		.word	4148
/* 0x0760	   0 */		.word	3
/* 0x0764	   0 */		.word	246
/* 0x0768	   0 */		.align	4
/* 0x0768	   0 */		.word	-1
/* 0x076c	   0 */		.word	-1
/* 0x0770	   0 */		.word	264
/* 0x0774	   0 */		.word	8218
/* 0x0778	   0 */		.word	2
/* 0x077c	   0 */		.word	249
/* 0x0780	   0 */		.align	4
/* 0x0780	   0 */		.word	-1
/* 0x0784	   0 */		.word	-1
/* 0x0788	   0 */		.word	264
/* 0x078c	   0 */		.word	4122
/* 0x0790	   0 */		.word	2
/* 0x0794	   0 */		.word	251
/* 0x0798	   0 */		.align	4
/* 0x0798	   0 */		.word	-1
/* 0x079c	   0 */		.word	-1
/* 0x07a0	   0 */		.word	264
/* 0x07a4	   0 */		.word	4123
/* 0x07a8	   0 */		.word	7
/* 0x07ac	   0 */		.word	253
/* 0x07b0	   0 */		.align	4
/* 0x07b0	   0 */		.word	-1
/* 0x07b4	   0 */		.word	-1
/* 0x07b8	   0 */		.word	264
/* 0x07bc	   0 */		.word	4145
/* 0x07c0	   0 */		.word	7
/* 0x07c4	   0 */		.word	260
/* 0x07c8	   0 */		.align	4
/* 0x07c8	   0 */		.word	-1
/* 0x07cc	   0 */		.word	-1
/* 0x07d0	   0 */		.word	402
/* 0x07d4	   0 */		.word	16414
/* 0x07d8	   0 */		.word	1
/* 0x07dc	   0 */		.word	267
/* 0x07e0	   0 */		.align	4
/* 0x07e0	   0 */		.word	-1
/* 0x07e4	   0 */		.word	-1
/* 0x07e8	   0 */		.word	407
/* 0x07ec	   0 */		.word	16414
/* 0x07f0	   0 */		.word	1
/* 0x07f4	   0 */		.word	268
/* 0x07f8	   0 */		.align	4
/* 0x07f8	   0 */		.word	-1
/* 0x07fc	   0 */		.word	-1
/* 0x0800	   0 */		.word	421
/* 0x0804	   0 */		.word	16414
/* 0x0808	   0 */		.word	1
/* 0x080c	   0 */		.word	269
/* 0x0810	   0 */		.align	4
/* 0x0810	   0 */		.word	-1
/* 0x0814	   0 */		.word	-1
/* 0x0818	   0 */		.word	429
/* 0x081c	   0 */		.word	16414
/* 0x0820	   0 */		.word	1
/* 0x0824	   0 */		.word	270
/* 0x0828	   0 */		.align	4
/* 0x0828	   0 */		.word	-1
/* 0x082c	   0 */		.word	-1
/* 0x0830	   0 */		.word	433
/* 0x0834	   0 */		.word	16414
/* 0x0838	   0 */		.word	1
/* 0x083c	   0 */		.word	271
/* 0x0840	   0 */		.align	4
/* 0x0840	   0 */		.word	-1
/* 0x0844	   0 */		.word	-1
/* 0x0848	   0 */		.word	454
/* 0x084c	   0 */		.word	16414
/* 0x0850	   0 */		.word	1
/* 0x0854	   0 */		.word	272
/* 0x0858	   0 */		.align	4
/* 0x0858	   0 */		.word	-1
/* 0x085c	   0 */		.word	-1
/* 0x0860	   0 */		.word	457
/* 0x0864	   0 */		.word	16414
/* 0x0868	   0 */		.word	1
/* 0x086c	   0 */		.word	273
/* 0x0870	   0 */		.align	4
/* 0x0870	   0 */		.word	-1
/* 0x0874	   0 */		.word	-1
/* 0x0878	   0 */		.word	462
/* 0x087c	   0 */		.word	16414
/* 0x0880	   0 */		.word	1
/* 0x0884	   0 */		.word	274
/* 0x0888	   0 */		.align	4
/* 0x0888	   0 */		.word	-1
/* 0x088c	   0 */		.word	-1
/* 0x0890	   0 */		.word	469
/* 0x0894	   0 */		.word	16414
/* 0x0898	   0 */		.word	1
/* 0x089c	   0 */		.word	275
/* 0x08a0	   0 */		.align	4
/* 0x08a0	   0 */		.word	-1
/* 0x08a4	   0 */		.word	-1
/* 0x08a8	   0 */		.word	480
/* 0x08ac	   0 */		.word	16414
/* 0x08b0	   0 */		.word	1
/* 0x08b4	   0 */		.word	276
/* 0x08b8	   0 */		.align	4
/* 0x08b8	   0 */		.word	-1
/* 0x08bc	   0 */		.word	-1
/* 0x08c0	   0 */		.word	483
/* 0x08c4	   0 */		.word	16414
/* 0x08c8	   0 */		.word	1
/* 0x08cc	   0 */		.word	277
/* 0x08d0	   0 */		.align	4
/* 0x08d0	   0 */		.word	-1
/* 0x08d4	   0 */		.word	-1
/* 0x08d8	   0 */		.word	486
/* 0x08dc	   0 */		.word	16414
/* 0x08e0	   0 */		.word	1
/* 0x08e4	   0 */		.word	278
/* 0x08e8	   0 */		.align	4
/* 0x08e8	   0 */		.word	-1
/* 0x08ec	   0 */		.word	-1
/* 0x08f0	   0 */		.word	492
/* 0x08f4	   0 */		.word	16414
/* 0x08f8	   0 */		.word	1
/* 0x08fc	   0 */		.word	279
/* 0x0900	   0 */		.align	4
/* 0x0900	   0 */		.word	-1
/* 0x0904	   0 */		.word	-1
/* 0x0908	   0 */		.word	374
/* 0x090c	   0 */		.word	16409
/* 0x0910	   0 */		.word	3
/* 0x0914	   0 */		.word	280
/* 0x0918	   0 */		.align	4
/* 0x0918	   0 */		.word	-1
/* 0x091c	   0 */		.word	-1
/* 0x0920	   0 */		.word	374
/* 0x0924	   0 */		.word	16411
/* 0x0928	   0 */		.word	3
/* 0x092c	   0 */		.word	283
/* 0x0930	   0 */		.align	4
/* 0x0930	   0 */		.word	-1
/* 0x0934	   0 */		.word	-1
/* 0x0938	   0 */		.word	415
/* 0x093c	   0 */		.word	16409
/* 0x0940	   0 */		.word	3
/* 0x0944	   0 */		.word	286
/* 0x0948	   0 */		.align	4
/* 0x0948	   0 */		.word	-1
/* 0x094c	   0 */		.word	-1
/* 0x0950	   0 */		.word	415
/* 0x0954	   0 */		.word	16411
/* 0x0958	   0 */		.word	3
/* 0x095c	   0 */		.word	289
/* 0x0960	   0 */		.align	4
/* 0x0960	   0 */		.word	-1
/* 0x0964	   0 */		.word	-1
/* 0x0968	   0 */		.word	415
/* 0x096c	   0 */		.word	4148
/* 0x0970	   0 */		.word	3
/* 0x0974	   0 */		.word	292
/* 0x0978	   0 */		.align	4
/* 0x0978	   0 */		.word	-1
/* 0x097c	   0 */		.word	-1
/* 0x0980	   0 */		.word	477
/* 0x0984	   0 */		.word	131089
/* 0x0988	   0 */		.word	4
/* 0x098c	   0 */		.word	295
/* 0x0990	   0 */		.align	4
/* 0x0990	   0 */		.word	-1
/* 0x0994	   0 */		.word	-1
/* 0x0998	   0 */		.word	476
/* 0x099c	   0 */		.word	131089
/* 0x09a0	   0 */		.word	4
/* 0x09a4	   0 */		.word	299
/* 0x09a8	   0 */		.align	4
/* 0x09a8	   0 */		.word	-1
/* 0x09ac	   0 */		.word	-1
/* 0x09b0	   0 */		.word	475
/* 0x09b4	   0 */		.word	131089
/* 0x09b8	   0 */		.word	4
/* 0x09bc	   0 */		.word	303
/* 0x09c0	   0 */		.align	4
/* 0x09c0	   0 */		.word	-1
/* 0x09c4	   0 */		.word	-1
/* 0x09c8	   0 */		.word	474
/* 0x09cc	   0 */		.word	131089
/* 0x09d0	   0 */		.word	4
/* 0x09d4	   0 */		.word	307
/* 0x09d8	   0 */		.align	4
/* 0x09d8	   0 */		.word	-1
/* 0x09dc	   0 */		.word	-1
/* 0x09e0	   0 */		.word	386
/* 0x09e4	   0 */		.word	131089
/* 0x09e8	   0 */		.word	4
/* 0x09ec	   0 */		.word	311
/* 0x09f0	   0 */		.align	4
/* 0x09f0	   0 */		.word	-1
/* 0x09f4	   0 */		.word	-1
/* 0x09f8	   0 */		.word	385
/* 0x09fc	   0 */		.word	131089
/* 0x0a00	   0 */		.word	4
/* 0x0a04	   0 */		.word	315
/* 0x0a08	   0 */		.align	4
/* 0x0a08	   0 */		.word	-1
/* 0x0a0c	   0 */		.word	-1
/* 0x0a10	   0 */		.word	384
/* 0x0a14	   0 */		.word	131089
/* 0x0a18	   0 */		.word	4
/* 0x0a1c	   0 */		.word	319
/* 0x0a20	   0 */		.align	4
/* 0x0a20	   0 */		.word	-1
/* 0x0a24	   0 */		.word	-1
/* 0x0a28	   0 */		.word	383
/* 0x0a2c	   0 */		.word	131089
/* 0x0a30	   0 */		.word	4
/* 0x0a34	   0 */		.word	323
/* 0x0a38	   0 */		.align	4
/* 0x0a38	   0 */		.word	-1
/* 0x0a3c	   0 */		.word	-1
/* 0x0a40	   0 */		.word	371
/* 0x0a44	   0 */		.word	131089
/* 0x0a48	   0 */		.word	4
/* 0x0a4c	   0 */		.word	327
/* 0x0a50	   0 */		.align	4
/* 0x0a50	   0 */		.word	-1
/* 0x0a54	   0 */		.word	-1
/* 0x0a58	   0 */		.word	383
/* 0x0a5c	   0 */		.word	8218
/* 0x0a60	   0 */		.word	2
/* 0x0a64	   0 */		.word	331
/* 0x0a68	   0 */		.align	4
/* 0x0a68	   0 */		.word	-1
/* 0x0a6c	   0 */		.word	-1
/* 0x0a70	   0 */		.word	383
/* 0x0a74	   0 */		.word	4122
/* 0x0a78	   0 */		.word	2
/* 0x0a7c	   0 */		.word	333
/* 0x0a80	   0 */		.align	4
/* 0x0a80	   0 */		.word	-1
/* 0x0a84	   0 */		.word	-1
/* 0x0a88	   0 */		.word	383
/* 0x0a8c	   0 */		.word	4123
/* 0x0a90	   0 */		.word	7
/* 0x0a94	   0 */		.word	335
/* 0x0a98	   0 */		.align	4
/* 0x0a98	   0 */		.word	-1
/* 0x0a9c	   0 */		.word	-1
/* 0x0aa0	   0 */		.word	383
/* 0x0aa4	   0 */		.word	4145
/* 0x0aa8	   0 */		.word	7
/* 0x0aac	   0 */		.word	342
/* 0x0ab0	   0 */		.align	4
/* 0x0ab0	   0 */		.word	-1
/* 0x0ab4	   0 */		.word	-1
/* 0x0ab8	   0 */		.word	384
/* 0x0abc	   0 */		.word	8218
/* 0x0ac0	   0 */		.word	2
/* 0x0ac4	   0 */		.word	349
/* 0x0ac8	   0 */		.align	4
/* 0x0ac8	   0 */		.word	-1
/* 0x0acc	   0 */		.word	-1
/* 0x0ad0	   0 */		.word	384
/* 0x0ad4	   0 */		.word	4122
/* 0x0ad8	   0 */		.word	2
/* 0x0adc	   0 */		.word	351
/* 0x0ae0	   0 */		.align	4
/* 0x0ae0	   0 */		.word	-1
/* 0x0ae4	   0 */		.word	-1
/* 0x0ae8	   0 */		.word	384
/* 0x0aec	   0 */		.word	4123
/* 0x0af0	   0 */		.word	7
/* 0x0af4	   0 */		.word	353
/* 0x0af8	   0 */		.align	4
/* 0x0af8	   0 */		.word	-1
/* 0x0afc	   0 */		.word	-1
/* 0x0b00	   0 */		.word	384
/* 0x0b04	   0 */		.word	4145
/* 0x0b08	   0 */		.word	7
/* 0x0b0c	   0 */		.word	360
/* 0x0b10	   0 */		.align	4
/* 0x0b10	   0 */		.word	-1
/* 0x0b14	   0 */		.word	-1
/* 0x0b18	   0 */		.word	385
/* 0x0b1c	   0 */		.word	8218
/* 0x0b20	   0 */		.word	2
/* 0x0b24	   0 */		.word	367
/* 0x0b28	   0 */		.align	4
/* 0x0b28	   0 */		.word	-1
/* 0x0b2c	   0 */		.word	-1
/* 0x0b30	   0 */		.word	385
/* 0x0b34	   0 */		.word	4122
/* 0x0b38	   0 */		.word	2
/* 0x0b3c	   0 */		.word	369
/* 0x0b40	   0 */		.align	4
/* 0x0b40	   0 */		.word	-1
/* 0x0b44	   0 */		.word	-1
/* 0x0b48	   0 */		.word	385
/* 0x0b4c	   0 */		.word	4123
/* 0x0b50	   0 */		.word	7
/* 0x0b54	   0 */		.word	371
/* 0x0b58	   0 */		.align	4
/* 0x0b58	   0 */		.word	-1
/* 0x0b5c	   0 */		.word	-1
/* 0x0b60	   0 */		.word	385
/* 0x0b64	   0 */		.word	4145
/* 0x0b68	   0 */		.word	7
/* 0x0b6c	   0 */		.word	378
/* 0x0b70	   0 */		.align	4
/* 0x0b70	   0 */		.word	-1
/* 0x0b74	   0 */		.word	-1
/* 0x0b78	   0 */		.word	386
/* 0x0b7c	   0 */		.word	8218
/* 0x0b80	   0 */		.word	2
/* 0x0b84	   0 */		.word	385
/* 0x0b88	   0 */		.align	4
/* 0x0b88	   0 */		.word	-1
/* 0x0b8c	   0 */		.word	-1
/* 0x0b90	   0 */		.word	386
/* 0x0b94	   0 */		.word	4122
/* 0x0b98	   0 */		.word	2
/* 0x0b9c	   0 */		.word	387
/* 0x0ba0	   0 */		.align	4
/* 0x0ba0	   0 */		.word	-1
/* 0x0ba4	   0 */		.word	-1
/* 0x0ba8	   0 */		.word	386
/* 0x0bac	   0 */		.word	4123
/* 0x0bb0	   0 */		.word	7
/* 0x0bb4	   0 */		.word	389
/* 0x0bb8	   0 */		.align	4
/* 0x0bb8	   0 */		.word	-1
/* 0x0bbc	   0 */		.word	-1
/* 0x0bc0	   0 */		.word	386
/* 0x0bc4	   0 */		.word	4145
/* 0x0bc8	   0 */		.word	7
/* 0x0bcc	   0 */		.word	396
/* 0x0bd0	   0 */		.align	4
/* 0x0bd0	   0 */		.word	-1
/* 0x0bd4	   0 */		.word	-1
/* 0x0bd8	   0 */		.word	474
/* 0x0bdc	   0 */		.word	8218
/* 0x0be0	   0 */		.word	2
/* 0x0be4	   0 */		.word	403
/* 0x0be8	   0 */		.align	4
/* 0x0be8	   0 */		.word	-1
/* 0x0bec	   0 */		.word	-1
/* 0x0bf0	   0 */		.word	474
/* 0x0bf4	   0 */		.word	4122
/* 0x0bf8	   0 */		.word	2
/* 0x0bfc	   0 */		.word	405
/* 0x0c00	   0 */		.align	4
/* 0x0c00	   0 */		.word	-1
/* 0x0c04	   0 */		.word	-1
/* 0x0c08	   0 */		.word	474
/* 0x0c0c	   0 */		.word	4123
/* 0x0c10	   0 */		.word	7
/* 0x0c14	   0 */		.word	407
/* 0x0c18	   0 */		.align	4
/* 0x0c18	   0 */		.word	-1
/* 0x0c1c	   0 */		.word	-1
/* 0x0c20	   0 */		.word	474
/* 0x0c24	   0 */		.word	4145
/* 0x0c28	   0 */		.word	7
/* 0x0c2c	   0 */		.word	414
/* 0x0c30	   0 */		.align	4
/* 0x0c30	   0 */		.word	-1
/* 0x0c34	   0 */		.word	-1
/* 0x0c38	   0 */		.word	475
/* 0x0c3c	   0 */		.word	8218
/* 0x0c40	   0 */		.word	2
/* 0x0c44	   0 */		.word	421
/* 0x0c48	   0 */		.align	4
/* 0x0c48	   0 */		.word	-1
/* 0x0c4c	   0 */		.word	-1
/* 0x0c50	   0 */		.word	475
/* 0x0c54	   0 */		.word	4122
/* 0x0c58	   0 */		.word	2
/* 0x0c5c	   0 */		.word	423
/* 0x0c60	   0 */		.align	4
/* 0x0c60	   0 */		.word	-1
/* 0x0c64	   0 */		.word	-1
/* 0x0c68	   0 */		.word	475
/* 0x0c6c	   0 */		.word	4123
/* 0x0c70	   0 */		.word	7
/* 0x0c74	   0 */		.word	425
/* 0x0c78	   0 */		.align	4
/* 0x0c78	   0 */		.word	-1
/* 0x0c7c	   0 */		.word	-1
/* 0x0c80	   0 */		.word	475
/* 0x0c84	   0 */		.word	4145
/* 0x0c88	   0 */		.word	7
/* 0x0c8c	   0 */		.word	432
/* 0x0c90	   0 */		.align	4
/* 0x0c90	   0 */		.word	-1
/* 0x0c94	   0 */		.word	-1
/* 0x0c98	   0 */		.word	476
/* 0x0c9c	   0 */		.word	8218
/* 0x0ca0	   0 */		.word	2
/* 0x0ca4	   0 */		.word	439
/* 0x0ca8	   0 */		.align	4
/* 0x0ca8	   0 */		.word	-1
/* 0x0cac	   0 */		.word	-1
/* 0x0cb0	   0 */		.word	476
/* 0x0cb4	   0 */		.word	4122
/* 0x0cb8	   0 */		.word	2
/* 0x0cbc	   0 */		.word	441
/* 0x0cc0	   0 */		.align	4
/* 0x0cc0	   0 */		.word	-1
/* 0x0cc4	   0 */		.word	-1
/* 0x0cc8	   0 */		.word	476
/* 0x0ccc	   0 */		.word	4123
/* 0x0cd0	   0 */		.word	7
/* 0x0cd4	   0 */		.word	443
/* 0x0cd8	   0 */		.align	4
/* 0x0cd8	   0 */		.word	-1
/* 0x0cdc	   0 */		.word	-1
/* 0x0ce0	   0 */		.word	476
/* 0x0ce4	   0 */		.word	4145
/* 0x0ce8	   0 */		.word	7
/* 0x0cec	   0 */		.word	450
/* 0x0cf0	   0 */		.align	4
/* 0x0cf0	   0 */		.word	-1
/* 0x0cf4	   0 */		.word	-1
/* 0x0cf8	   0 */		.word	477
/* 0x0cfc	   0 */		.word	8218
/* 0x0d00	   0 */		.word	2
/* 0x0d04	   0 */		.word	457
/* 0x0d08	   0 */		.align	4
/* 0x0d08	   0 */		.word	-1
/* 0x0d0c	   0 */		.word	-1
/* 0x0d10	   0 */		.word	477
/* 0x0d14	   0 */		.word	4122
/* 0x0d18	   0 */		.word	2
/* 0x0d1c	   0 */		.word	459
/* 0x0d20	   0 */		.align	4
/* 0x0d20	   0 */		.word	-1
/* 0x0d24	   0 */		.word	-1
/* 0x0d28	   0 */		.word	477
/* 0x0d2c	   0 */		.word	4123
/* 0x0d30	   0 */		.word	7
/* 0x0d34	   0 */		.word	461
/* 0x0d38	   0 */		.align	4
/* 0x0d38	   0 */		.word	-1
/* 0x0d3c	   0 */		.word	-1
/* 0x0d40	   0 */		.word	477
/* 0x0d44	   0 */		.word	4145
/* 0x0d48	   0 */		.word	7
/* 0x0d4c	   0 */		.word	468
/* 0x0d50	   0 */		.align	4
/* 0x0d50	   0 */		.word	-1
/* 0x0d54	   0 */		.word	-1
/* 0x0d58	   0 */		.word	477
/* 0x0d5c	   0 */		.word	8218
/* 0x0d60	   0 */		.word	2
/* 0x0d64	   0 */		.word	475
/* 0x0d68	   0 */		.align	4
/* 0x0d68	   0 */		.word	-1
/* 0x0d6c	   0 */		.word	-1
/* 0x0d70	   0 */		.word	477
/* 0x0d74	   0 */		.word	4122
/* 0x0d78	   0 */		.word	2
/* 0x0d7c	   0 */		.word	477
/* 0x0d80	   0 */		.align	4
/* 0x0d80	   0 */		.word	-1
/* 0x0d84	   0 */		.word	-1
/* 0x0d88	   0 */		.word	477
/* 0x0d8c	   0 */		.word	4123
/* 0x0d90	   0 */		.word	7
/* 0x0d94	   0 */		.word	479
/* 0x0d98	   0 */		.align	4
/* 0x0d98	   0 */		.word	-1
/* 0x0d9c	   0 */		.word	-1
/* 0x0da0	   0 */		.word	477
/* 0x0da4	   0 */		.word	4145
/* 0x0da8	   0 */		.word	7
/* 0x0dac	   0 */		.word	486
/* 0x0db0	   0 */		.align	4
/* 0x0db0	   0 */		.word	-1
/* 0x0db4	   0 */		.word	-1
/* 0x0db8	   0 */		.word	476
/* 0x0dbc	   0 */		.word	8218
/* 0x0dc0	   0 */		.word	2
/* 0x0dc4	   0 */		.word	493
/* 0x0dc8	   0 */		.align	4
/* 0x0dc8	   0 */		.word	-1
/* 0x0dcc	   0 */		.word	-1
/* 0x0dd0	   0 */		.word	476
/* 0x0dd4	   0 */		.word	4122
/* 0x0dd8	   0 */		.word	2
/* 0x0ddc	   0 */		.word	495
/* 0x0de0	   0 */		.align	4
/* 0x0de0	   0 */		.word	-1
/* 0x0de4	   0 */		.word	-1
/* 0x0de8	   0 */		.word	476
/* 0x0dec	   0 */		.word	4123
/* 0x0df0	   0 */		.word	7
/* 0x0df4	   0 */		.word	497
/* 0x0df8	   0 */		.align	4
/* 0x0df8	   0 */		.word	-1
/* 0x0dfc	   0 */		.word	-1
/* 0x0e00	   0 */		.word	476
/* 0x0e04	   0 */		.word	4145
/* 0x0e08	   0 */		.word	7
/* 0x0e0c	   0 */		.word	504
/* 0x0e10	   0 */		.align	4
/* 0x0e10	   0 */		.word	-1
/* 0x0e14	   0 */		.word	-1
/* 0x0e18	   0 */		.word	475
/* 0x0e1c	   0 */		.word	8218
/* 0x0e20	   0 */		.word	2
/* 0x0e24	   0 */		.word	511
/* 0x0e28	   0 */		.align	4
/* 0x0e28	   0 */		.word	-1
/* 0x0e2c	   0 */		.word	-1
/* 0x0e30	   0 */		.word	475
/* 0x0e34	   0 */		.word	4122
/* 0x0e38	   0 */		.word	2
/* 0x0e3c	   0 */		.word	513
/* 0x0e40	   0 */		.align	4
/* 0x0e40	   0 */		.word	-1
/* 0x0e44	   0 */		.word	-1
/* 0x0e48	   0 */		.word	475
/* 0x0e4c	   0 */		.word	4123
/* 0x0e50	   0 */		.word	7
/* 0x0e54	   0 */		.word	515
/* 0x0e58	   0 */		.align	4
/* 0x0e58	   0 */		.word	-1
/* 0x0e5c	   0 */		.word	-1
/* 0x0e60	   0 */		.word	475
/* 0x0e64	   0 */		.word	4145
/* 0x0e68	   0 */		.word	7
/* 0x0e6c	   0 */		.word	522
/* 0x0e70	   0 */		.align	4
/* 0x0e70	   0 */		.word	-1
/* 0x0e74	   0 */		.word	-1
/* 0x0e78	   0 */		.word	474
/* 0x0e7c	   0 */		.word	8218
/* 0x0e80	   0 */		.word	2
/* 0x0e84	   0 */		.word	529
/* 0x0e88	   0 */		.align	4
/* 0x0e88	   0 */		.word	-1
/* 0x0e8c	   0 */		.word	-1
/* 0x0e90	   0 */		.word	474
/* 0x0e94	   0 */		.word	4122
/* 0x0e98	   0 */		.word	2
/* 0x0e9c	   0 */		.word	531
/* 0x0ea0	   0 */		.align	4
/* 0x0ea0	   0 */		.word	-1
/* 0x0ea4	   0 */		.word	-1
/* 0x0ea8	   0 */		.word	474
/* 0x0eac	   0 */		.word	4123
/* 0x0eb0	   0 */		.word	7
/* 0x0eb4	   0 */		.word	533
/* 0x0eb8	   0 */		.align	4
/* 0x0eb8	   0 */		.word	-1
/* 0x0ebc	   0 */		.word	-1
/* 0x0ec0	   0 */		.word	474
/* 0x0ec4	   0 */		.word	4145
/* 0x0ec8	   0 */		.word	7
/* 0x0ecc	   0 */		.word	540
/* 0x0ed0	   0 */		.align	4
/* 0x0ed0	   0 */		.word	-1
/* 0x0ed4	   0 */		.word	-1
/* 0x0ed8	   0 */		.word	386
/* 0x0edc	   0 */		.word	8218
/* 0x0ee0	   0 */		.word	2
/* 0x0ee4	   0 */		.word	547
/* 0x0ee8	   0 */		.align	4
/* 0x0ee8	   0 */		.word	-1
/* 0x0eec	   0 */		.word	-1
/* 0x0ef0	   0 */		.word	386
/* 0x0ef4	   0 */		.word	4122
/* 0x0ef8	   0 */		.word	2
/* 0x0efc	   0 */		.word	549
/* 0x0f00	   0 */		.align	4
/* 0x0f00	   0 */		.word	-1
/* 0x0f04	   0 */		.word	-1
/* 0x0f08	   0 */		.word	386
/* 0x0f0c	   0 */		.word	4123
/* 0x0f10	   0 */		.word	7
/* 0x0f14	   0 */		.word	551
/* 0x0f18	   0 */		.align	4
/* 0x0f18	   0 */		.word	-1
/* 0x0f1c	   0 */		.word	-1
/* 0x0f20	   0 */		.word	386
/* 0x0f24	   0 */		.word	4145
/* 0x0f28	   0 */		.word	7
/* 0x0f2c	   0 */		.word	558
/* 0x0f30	   0 */		.align	4
/* 0x0f30	   0 */		.word	-1
/* 0x0f34	   0 */		.word	-1
/* 0x0f38	   0 */		.word	385
/* 0x0f3c	   0 */		.word	8218
/* 0x0f40	   0 */		.word	2
/* 0x0f44	   0 */		.word	565
/* 0x0f48	   0 */		.align	4
/* 0x0f48	   0 */		.word	-1
/* 0x0f4c	   0 */		.word	-1
/* 0x0f50	   0 */		.word	385
/* 0x0f54	   0 */		.word	4122
/* 0x0f58	   0 */		.word	2
/* 0x0f5c	   0 */		.word	567
/* 0x0f60	   0 */		.align	4
/* 0x0f60	   0 */		.word	-1
/* 0x0f64	   0 */		.word	-1
/* 0x0f68	   0 */		.word	385
/* 0x0f6c	   0 */		.word	4123
/* 0x0f70	   0 */		.word	7
/* 0x0f74	   0 */		.word	569
/* 0x0f78	   0 */		.align	4
/* 0x0f78	   0 */		.word	-1
/* 0x0f7c	   0 */		.word	-1
/* 0x0f80	   0 */		.word	385
/* 0x0f84	   0 */		.word	4145
/* 0x0f88	   0 */		.word	7
/* 0x0f8c	   0 */		.word	576
/* 0x0f90	   0 */		.align	4
/* 0x0f90	   0 */		.word	-1
/* 0x0f94	   0 */		.word	-1
/* 0x0f98	   0 */		.word	384
/* 0x0f9c	   0 */		.word	8218
/* 0x0fa0	   0 */		.word	2
/* 0x0fa4	   0 */		.word	583
/* 0x0fa8	   0 */		.align	4
/* 0x0fa8	   0 */		.word	-1
/* 0x0fac	   0 */		.word	-1
/* 0x0fb0	   0 */		.word	384
/* 0x0fb4	   0 */		.word	4122
/* 0x0fb8	   0 */		.word	2
/* 0x0fbc	   0 */		.word	585
/* 0x0fc0	   0 */		.align	4
/* 0x0fc0	   0 */		.word	-1
/* 0x0fc4	   0 */		.word	-1
/* 0x0fc8	   0 */		.word	384
/* 0x0fcc	   0 */		.word	4123
/* 0x0fd0	   0 */		.word	7
/* 0x0fd4	   0 */		.word	587
/* 0x0fd8	   0 */		.align	4
/* 0x0fd8	   0 */		.word	-1
/* 0x0fdc	   0 */		.word	-1
/* 0x0fe0	   0 */		.word	384
/* 0x0fe4	   0 */		.word	4145
/* 0x0fe8	   0 */		.word	7
/* 0x0fec	   0 */		.word	594
/* 0x0ff0	   0 */		.align	4
/* 0x0ff0	   0 */		.word	-1
/* 0x0ff4	   0 */		.word	-1
/* 0x0ff8	   0 */		.word	383
/* 0x0ffc	   0 */		.word	8218
/* 0x1000	   0 */		.word	2
/* 0x1004	   0 */		.word	601
/* 0x1008	   0 */		.align	4
/* 0x1008	   0 */		.word	-1
/* 0x100c	   0 */		.word	-1
/* 0x1010	   0 */		.word	383
/* 0x1014	   0 */		.word	4122
/* 0x1018	   0 */		.word	2
/* 0x101c	   0 */		.word	603
/* 0x1020	   0 */		.align	4
/* 0x1020	   0 */		.word	-1
/* 0x1024	   0 */		.word	-1
/* 0x1028	   0 */		.word	383
/* 0x102c	   0 */		.word	4123
/* 0x1030	   0 */		.word	7
/* 0x1034	   0 */		.word	605
/* 0x1038	   0 */		.align	4
/* 0x1038	   0 */		.word	-1
/* 0x103c	   0 */		.word	-1
/* 0x1040	   0 */		.word	383
/* 0x1044	   0 */		.word	4145
/* 0x1048	   0 */		.word	7
/* 0x104c	   0 */		.word	612
/* 0x1050	   0 */		.align	4
/* 0x1050	   0 */		.word	-1
/* 0x1054	   0 */		.word	-1
/* 0x1058	   0 */		.word	371
/* 0x105c	   0 */		.word	4148
/* 0x1060	   0 */		.word	3
/* 0x1064	   0 */		.word	619
/* 0x1068	   0 */		.align	4
/* 0x1068	   0 */		.word	-1
/* 0x106c	   0 */		.word	-1
/* 0x1070	   0 */		.word	371
/* 0x1074	   0 */		.word	8218
/* 0x1078	   0 */		.word	2
/* 0x107c	   0 */		.word	622
/* 0x1080	   0 */		.align	4
/* 0x1080	   0 */		.word	-1
/* 0x1084	   0 */		.word	-1
/* 0x1088	   0 */		.word	371
/* 0x108c	   0 */		.word	4122
/* 0x1090	   0 */		.word	2
/* 0x1094	   0 */		.word	624
/* 0x1098	   0 */		.align	4
/* 0x1098	   0 */		.word	-1
/* 0x109c	   0 */		.word	-1
/* 0x10a0	   0 */		.word	371
/* 0x10a4	   0 */		.word	4123
/* 0x10a8	   0 */		.word	7
/* 0x10ac	   0 */		.word	626
/* 0x10b0	   0 */		.align	4
/* 0x10b0	   0 */		.word	-1
/* 0x10b4	   0 */		.word	-1
/* 0x10b8	   0 */		.word	371
/* 0x10bc	   0 */		.word	4145
/* 0x10c0	   0 */		.word	7
/* 0x10c4	   0 */		.word	633
/* 0x10c8	   0 */		.align	4
/* 0x10c8	   0 */		.word	-1
/* 0x10cc	   0 */		.word	-1
/* 0x10d0	   0 */		.word	534
/* 0x10d4	   0 */		.word	16414
/* 0x10d8	   0 */		.word	1
/* 0x10dc	   0 */		.word	640
/* 0x10e0	   0 */		.align	4
/* 0x10e0	   0 */		.word	-1
/* 0x10e4	   0 */		.word	-1
/* 0x10e8	   0 */		.word	552
/* 0x10ec	   0 */		.word	16414
/* 0x10f0	   0 */		.word	1
/* 0x10f4	   0 */		.word	641
/* 0x10f8	   0 */		.align	4
/* 0x10f8	   0 */		.word	-1
/* 0x10fc	   0 */		.word	-1
/* 0x1100	   0 */		.word	560
/* 0x1104	   0 */		.word	16414
/* 0x1108	   0 */		.word	1
/* 0x110c	   0 */		.word	642
/* 0x1110	   0 */		.align	4
/* 0x1110	   0 */		.word	-1
/* 0x1114	   0 */		.word	-1
/* 0x1118	   0 */		.word	564
/* 0x111c	   0 */		.word	16414
/* 0x1120	   0 */		.word	1
/* 0x1124	   0 */		.word	643
/* 0x1128	   0 */		.align	4
/* 0x1128	   0 */		.word	-1
/* 0x112c	   0 */		.word	-1
/* 0x1130	   0 */		.word	596
/* 0x1134	   0 */		.word	16414
/* 0x1138	   0 */		.word	1
/* 0x113c	   0 */		.word	644
/* 0x1140	   0 */		.align	4
/* 0x1140	   0 */		.word	-1
/* 0x1144	   0 */		.word	-1
/* 0x1148	   0 */		.word	599
/* 0x114c	   0 */		.word	16414
/* 0x1150	   0 */		.word	1
/* 0x1154	   0 */		.word	645
/* 0x1158	   0 */		.align	4
/* 0x1158	   0 */		.word	-1
/* 0x115c	   0 */		.word	-1
/* 0x1160	   0 */		.word	604
/* 0x1164	   0 */		.word	16414
/* 0x1168	   0 */		.word	1
/* 0x116c	   0 */		.word	646
/* 0x1170	   0 */		.align	4
/* 0x1170	   0 */		.word	-1
/* 0x1174	   0 */		.word	-1
/* 0x1178	   0 */		.word	611
/* 0x117c	   0 */		.word	16414
/* 0x1180	   0 */		.word	1
/* 0x1184	   0 */		.word	647
/* 0x1188	   0 */		.align	4
/* 0x1188	   0 */		.word	-1
/* 0x118c	   0 */		.word	-1
/* 0x1190	   0 */		.word	626
/* 0x1194	   0 */		.word	16414
/* 0x1198	   0 */		.word	1
/* 0x119c	   0 */		.word	648
/* 0x11a0	   0 */		.align	4
/* 0x11a0	   0 */		.word	-1
/* 0x11a4	   0 */		.word	-1
/* 0x11a8	   0 */		.word	629
/* 0x11ac	   0 */		.word	16414
/* 0x11b0	   0 */		.word	1
/* 0x11b4	   0 */		.word	649
/* 0x11b8	   0 */		.align	4
/* 0x11b8	   0 */		.word	-1
/* 0x11bc	   0 */		.word	-1
/* 0x11c0	   0 */		.word	632
/* 0x11c4	   0 */		.word	16414
/* 0x11c8	   0 */		.word	1
/* 0x11cc	   0 */		.word	650
/* 0x11d0	   0 */		.align	4
/* 0x11d0	   0 */		.word	-1
/* 0x11d4	   0 */		.word	-1
/* 0x11d8	   0 */		.word	640
/* 0x11dc	   0 */		.word	16414
/* 0x11e0	   0 */		.word	1
/* 0x11e4	   0 */		.word	651
/* 0x11e8	   0 */		.align	4
/* 0x11e8	   0 */		.word	-1
/* 0x11ec	   0 */		.word	-1
/* 0x11f0	   0 */		.word	648
/* 0x11f4	   0 */		.word	16414
/* 0x11f8	   0 */		.word	1
/* 0x11fc	   0 */		.word	652
/* 0x1200	   0 */		.align	4
/* 0x1200	   0 */		.word	-1
/* 0x1204	   0 */		.word	-1
/* 0x1208	   0 */		.word	658
/* 0x120c	   0 */		.word	16414
/* 0x1210	   0 */		.word	1
/* 0x1214	   0 */		.word	653
/* 0x1218	   0 */		.align	4
/* 0x1218	   0 */		.word	-1
/* 0x121c	   0 */		.word	-1
/* 0x1220	   0 */		.word	526
/* 0x1224	   0 */		.word	16409
/* 0x1228	   0 */		.word	3
/* 0x122c	   0 */		.word	654
/* 0x1230	   0 */		.align	4
/* 0x1230	   0 */		.word	-1
/* 0x1234	   0 */		.word	-1
/* 0x1238	   0 */		.word	526
/* 0x123c	   0 */		.word	16411
/* 0x1240	   0 */		.word	3
/* 0x1244	   0 */		.word	657
/* 0x1248	   0 */		.align	4
/* 0x1248	   0 */		.word	-1
/* 0x124c	   0 */		.word	-1
/* 0x1250	   0 */		.word	542
/* 0x1254	   0 */		.word	16409
/* 0x1258	   0 */		.word	3
/* 0x125c	   0 */		.word	660
/* 0x1260	   0 */		.align	4
/* 0x1260	   0 */		.word	-1
/* 0x1264	   0 */		.word	-1
/* 0x1268	   0 */		.word	542
/* 0x126c	   0 */		.word	16411
/* 0x1270	   0 */		.word	3
/* 0x1274	   0 */		.word	663
/* 0x1278	   0 */		.align	4
/* 0x1278	   0 */		.word	-1
/* 0x127c	   0 */		.word	-1
/* 0x1280	   0 */		.word	549
/* 0x1284	   0 */		.word	65571
/* 0x1288	   0 */		.word	1
/* 0x128c	   0 */		.word	666
/* 0x1290	   0 */		.align	4
/* 0x1290	   0 */		.word	-1
/* 0x1294	   0 */		.word	-1
/* 0x1298	   0 */		.word	586
/* 0x129c	   0 */		.word	65571
/* 0x12a0	   0 */		.word	1
/* 0x12a4	   0 */		.word	667
/* 0x12a8	   0 */		.align	4
/* 0x12a8	   0 */		.word	-1
/* 0x12ac	   0 */		.word	-1
/* 0x12b0	   0 */		.word	616
/* 0x12b4	   0 */		.word	65571
/* 0x12b8	   0 */		.word	1
/* 0x12bc	   0 */		.word	668
/* 0x12c0	   0 */		.align	4
/* 0x12c0	   0 */		.word	-1
/* 0x12c4	   0 */		.word	-1
/* 0x12c8	   0 */		.word	549
/* 0x12cc	   0 */		.word	4148
/* 0x12d0	   0 */		.word	3
/* 0x12d4	   0 */		.word	669
/* 0x12d8	   0 */		.align	4
/* 0x12d8	   0 */		.word	-1
/* 0x12dc	   0 */		.word	-1
/* 0x12e0	   0 */		.word	586
/* 0x12e4	   0 */		.word	4148
/* 0x12e8	   0 */		.word	3
/* 0x12ec	   0 */		.word	672
/* 0x12f0	   0 */		.align	4
/* 0x12f0	   0 */		.word	-1
/* 0x12f4	   0 */		.word	-1
/* 0x12f8	   0 */		.word	616
/* 0x12fc	   0 */		.word	4148
/* 0x1300	   0 */		.word	3
/* 0x1304	   0 */		.word	675
/* 0x1308	   0 */		.align	4
/* 0x1308	   0 */		.word	-1
/* 0x130c	   0 */		.word	-1
/* 0x1310	   0 */		.word	542
/* 0x1314	   0 */		.word	4148
/* 0x1318	   0 */		.word	3
/* 0x131c	   0 */		.word	678
/* 0x1320	   0 */		.align	4
/* 0x1320	   0 */		.word	-1
/* 0x1324	   0 */		.word	-1
/* 0x1328	   0 */		.word	523
/* 0x132c	   0 */		.word	131089
/* 0x1330	   0 */		.word	4
/* 0x1334	   0 */		.word	681
/* 0x1338	   0 */		.align	4
/* 0x1338	   0 */		.word	-1
/* 0x133c	   0 */		.word	-1
/* 0x1340	   0 */		.word	549
/* 0x1344	   0 */		.word	8218
/* 0x1348	   0 */		.word	2
/* 0x134c	   0 */		.word	685
/* 0x1350	   0 */		.align	4
/* 0x1350	   0 */		.word	-1
/* 0x1354	   0 */		.word	-1
/* 0x1358	   0 */		.word	549
/* 0x135c	   0 */		.word	4122
/* 0x1360	   0 */		.word	2
/* 0x1364	   0 */		.word	687
/* 0x1368	   0 */		.align	4
/* 0x1368	   0 */		.word	-1
/* 0x136c	   0 */		.word	-1
/* 0x1370	   0 */		.word	549
/* 0x1374	   0 */		.word	4123
/* 0x1378	   0 */		.word	7
/* 0x137c	   0 */		.word	689
/* 0x1380	   0 */		.align	4
/* 0x1380	   0 */		.word	-1
/* 0x1384	   0 */		.word	-1
/* 0x1388	   0 */		.word	549
/* 0x138c	   0 */		.word	4145
/* 0x1390	   0 */		.word	7
/* 0x1394	   0 */		.word	696
/* 0x1398	   0 */		.align	4
/* 0x1398	   0 */		.word	-1
/* 0x139c	   0 */		.word	-1
/* 0x13a0	   0 */		.word	549
/* 0x13a4	   0 */		.word	8229
/* 0x13a8	   0 */		.word	1
/* 0x13ac	   0 */		.word	703
/* 0x13b0	   0 */		.align	4
/* 0x13b0	   0 */		.word	-1
/* 0x13b4	   0 */		.word	-1
/* 0x13b8	   0 */		.word	523
/* 0x13bc	   0 */		.word	4148
/* 0x13c0	   0 */		.word	3
/* 0x13c4	   0 */		.word	704
/* 0x13c8	   0 */		.align	4
/* 0x13c8	   0 */		.word	-1
/* 0x13cc	   0 */		.word	-1
/* 0x13d0	   0 */		.word	523
/* 0x13d4	   0 */		.word	8218
/* 0x13d8	   0 */		.word	2
/* 0x13dc	   0 */		.word	707
/* 0x13e0	   0 */		.align	4
/* 0x13e0	   0 */		.word	-1
/* 0x13e4	   0 */		.word	-1
/* 0x13e8	   0 */		.word	523
/* 0x13ec	   0 */		.word	4122
/* 0x13f0	   0 */		.word	2
/* 0x13f4	   0 */		.word	709
/* 0x13f8	   0 */		.align	4
/* 0x13f8	   0 */		.word	-1
/* 0x13fc	   0 */		.word	-1
/* 0x1400	   0 */		.word	523
/* 0x1404	   0 */		.word	4123
/* 0x1408	   0 */		.word	7
/* 0x140c	   0 */		.word	711
/* 0x1410	   0 */		.align	4
/* 0x1410	   0 */		.word	-1
/* 0x1414	   0 */		.word	-1
/* 0x1418	   0 */		.word	523
/* 0x141c	   0 */		.word	4145
/* 0x1420	   0 */		.word	7
/* 0x1424	   0 */		.word	718
/* 0x1428	   0 */		.align	4
/* 0x1428	   0 */		.word	-1
/* 0x142c	   0 */		.word	-1
/* 0x1430	   0 */		.word	724
/* 0x1434	   0 */		.word	16414
/* 0x1438	   0 */		.word	1
/* 0x143c	   0 */		.word	725
/* 0x1440	   0 */		.align	4
/* 0x1440	   0 */		.word	-1
/* 0x1444	   0 */		.word	-1
/* 0x1448	   0 */		.word	729
/* 0x144c	   0 */		.word	16414
/* 0x1450	   0 */		.word	1
/* 0x1454	   0 */		.word	726
/* 0x1458	   0 */		.align	4
/* 0x1458	   0 */		.word	-1
/* 0x145c	   0 */		.word	-1
/* 0x1460	   0 */		.word	734
/* 0x1464	   0 */		.word	16414
/* 0x1468	   0 */		.word	1
/* 0x146c	   0 */		.word	727
/* 0x1470	   0 */		.align	4
/* 0x1470	   0 */		.word	-1
/* 0x1474	   0 */		.word	-1
/* 0x1478	   0 */		.word	748
/* 0x147c	   0 */		.word	16414
/* 0x1480	   0 */		.word	1
/* 0x1484	   0 */		.word	728
/* 0x1488	   0 */		.align	4
/* 0x1488	   0 */		.word	-1
/* 0x148c	   0 */		.word	-1
/* 0x1490	   0 */		.word	756
/* 0x1494	   0 */		.word	16414
/* 0x1498	   0 */		.word	1
/* 0x149c	   0 */		.word	729
/* 0x14a0	   0 */		.align	4
/* 0x14a0	   0 */		.word	-1
/* 0x14a4	   0 */		.word	-1
/* 0x14a8	   0 */		.word	760
/* 0x14ac	   0 */		.word	16414
/* 0x14b0	   0 */		.word	1
/* 0x14b4	   0 */		.word	730
/* 0x14b8	   0 */		.align	4
/* 0x14b8	   0 */		.word	-1
/* 0x14bc	   0 */		.word	-1
/* 0x14c0	   0 */		.word	781
/* 0x14c4	   0 */		.word	16414
/* 0x14c8	   0 */		.word	1
/* 0x14cc	   0 */		.word	731
/* 0x14d0	   0 */		.align	4
/* 0x14d0	   0 */		.word	-1
/* 0x14d4	   0 */		.word	-1
/* 0x14d8	   0 */		.word	784
/* 0x14dc	   0 */		.word	16414
/* 0x14e0	   0 */		.word	1
/* 0x14e4	   0 */		.word	732
/* 0x14e8	   0 */		.align	4
/* 0x14e8	   0 */		.word	-1
/* 0x14ec	   0 */		.word	-1
/* 0x14f0	   0 */		.word	788
/* 0x14f4	   0 */		.word	16414
/* 0x14f8	   0 */		.word	1
/* 0x14fc	   0 */		.word	733
/* 0x1500	   0 */		.align	4
/* 0x1500	   0 */		.word	-1
/* 0x1504	   0 */		.word	-1
/* 0x1508	   0 */		.word	795
/* 0x150c	   0 */		.word	16414
/* 0x1510	   0 */		.word	1
/* 0x1514	   0 */		.word	734
/* 0x1518	   0 */		.align	4
/* 0x1518	   0 */		.word	-1
/* 0x151c	   0 */		.word	-1
/* 0x1520	   0 */		.word	806
/* 0x1524	   0 */		.word	16414
/* 0x1528	   0 */		.word	1
/* 0x152c	   0 */		.word	735
/* 0x1530	   0 */		.align	4
/* 0x1530	   0 */		.word	-1
/* 0x1534	   0 */		.word	-1
/* 0x1538	   0 */		.word	809
/* 0x153c	   0 */		.word	16414
/* 0x1540	   0 */		.word	1
/* 0x1544	   0 */		.word	736
/* 0x1548	   0 */		.align	4
/* 0x1548	   0 */		.word	-1
/* 0x154c	   0 */		.word	-1
/* 0x1550	   0 */		.word	812
/* 0x1554	   0 */		.word	16414
/* 0x1558	   0 */		.word	1
/* 0x155c	   0 */		.word	737
/* 0x1560	   0 */		.align	4
/* 0x1560	   0 */		.word	-1
/* 0x1564	   0 */		.word	-1
/* 0x1568	   0 */		.word	819
/* 0x156c	   0 */		.word	16414
/* 0x1570	   0 */		.word	1
/* 0x1574	   0 */		.word	738
/* 0x1578	   0 */		.align	4
/* 0x1578	   0 */		.word	-1
/* 0x157c	   0 */		.word	-1
/* 0x1580	   0 */		.word	697
/* 0x1584	   0 */		.word	16409
/* 0x1588	   0 */		.word	3
/* 0x158c	   0 */		.word	739
/* 0x1590	   0 */		.align	4
/* 0x1590	   0 */		.word	-1
/* 0x1594	   0 */		.word	-1
/* 0x1598	   0 */		.word	697
/* 0x159c	   0 */		.word	16411
/* 0x15a0	   0 */		.word	3
/* 0x15a4	   0 */		.word	742
/* 0x15a8	   0 */		.align	4
/* 0x15a8	   0 */		.word	-1
/* 0x15ac	   0 */		.word	-1
/* 0x15b0	   0 */		.word	742
/* 0x15b4	   0 */		.word	16409
/* 0x15b8	   0 */		.word	3
/* 0x15bc	   0 */		.word	745
/* 0x15c0	   0 */		.align	4
/* 0x15c0	   0 */		.word	-1
/* 0x15c4	   0 */		.word	-1
/* 0x15c8	   0 */		.word	742
/* 0x15cc	   0 */		.word	16411
/* 0x15d0	   0 */		.word	3
/* 0x15d4	   0 */		.word	748
/* 0x15d8	   0 */		.align	4
/* 0x15d8	   0 */		.word	-1
/* 0x15dc	   0 */		.word	-1
/* 0x15e0	   0 */		.word	742
/* 0x15e4	   0 */		.word	4148
/* 0x15e8	   0 */		.word	3
/* 0x15ec	   0 */		.word	751
/* 0x15f0	   0 */		.align	4
/* 0x15f0	   0 */		.word	-1
/* 0x15f4	   0 */		.word	-1
/* 0x15f8	   0 */		.word	803
/* 0x15fc	   0 */		.word	131089
/* 0x1600	   0 */		.word	4
/* 0x1604	   0 */		.word	754
/* 0x1608	   0 */		.align	4
/* 0x1608	   0 */		.word	-1
/* 0x160c	   0 */		.word	-1
/* 0x1610	   0 */		.word	802
/* 0x1614	   0 */		.word	131089
/* 0x1618	   0 */		.word	4
/* 0x161c	   0 */		.word	758
/* 0x1620	   0 */		.align	4
/* 0x1620	   0 */		.word	-1
/* 0x1624	   0 */		.word	-1
/* 0x1628	   0 */		.word	801
/* 0x162c	   0 */		.word	131089
/* 0x1630	   0 */		.word	4
/* 0x1634	   0 */		.word	762
/* 0x1638	   0 */		.align	4
/* 0x1638	   0 */		.word	-1
/* 0x163c	   0 */		.word	-1
/* 0x1640	   0 */		.word	800
/* 0x1644	   0 */		.word	131089
/* 0x1648	   0 */		.word	4
/* 0x164c	   0 */		.word	766
/* 0x1650	   0 */		.align	4
/* 0x1650	   0 */		.word	-1
/* 0x1654	   0 */		.word	-1
/* 0x1658	   0 */		.word	709
/* 0x165c	   0 */		.word	131089
/* 0x1660	   0 */		.word	4
/* 0x1664	   0 */		.word	770
/* 0x1668	   0 */		.align	4
/* 0x1668	   0 */		.word	-1
/* 0x166c	   0 */		.word	-1
/* 0x1670	   0 */		.word	708
/* 0x1674	   0 */		.word	131089
/* 0x1678	   0 */		.word	4
/* 0x167c	   0 */		.word	774
/* 0x1680	   0 */		.align	4
/* 0x1680	   0 */		.word	-1
/* 0x1684	   0 */		.word	-1
/* 0x1688	   0 */		.word	707
/* 0x168c	   0 */		.word	131089
/* 0x1690	   0 */		.word	4
/* 0x1694	   0 */		.word	778
/* 0x1698	   0 */		.align	4
/* 0x1698	   0 */		.word	-1
/* 0x169c	   0 */		.word	-1
/* 0x16a0	   0 */		.word	706
/* 0x16a4	   0 */		.word	131089
/* 0x16a8	   0 */		.word	4
/* 0x16ac	   0 */		.word	782
/* 0x16b0	   0 */		.align	4
/* 0x16b0	   0 */		.word	-1
/* 0x16b4	   0 */		.word	-1
/* 0x16b8	   0 */		.word	694
/* 0x16bc	   0 */		.word	131089
/* 0x16c0	   0 */		.word	4
/* 0x16c4	   0 */		.word	786
/* 0x16c8	   0 */		.align	4
/* 0x16c8	   0 */		.word	-1
/* 0x16cc	   0 */		.word	-1
/* 0x16d0	   0 */		.word	706
/* 0x16d4	   0 */		.word	8218
/* 0x16d8	   0 */		.word	2
/* 0x16dc	   0 */		.word	790
/* 0x16e0	   0 */		.align	4
/* 0x16e0	   0 */		.word	-1
/* 0x16e4	   0 */		.word	-1
/* 0x16e8	   0 */		.word	706
/* 0x16ec	   0 */		.word	4122
/* 0x16f0	   0 */		.word	2
/* 0x16f4	   0 */		.word	792
/* 0x16f8	   0 */		.align	4
/* 0x16f8	   0 */		.word	-1
/* 0x16fc	   0 */		.word	-1
/* 0x1700	   0 */		.word	706
/* 0x1704	   0 */		.word	4123
/* 0x1708	   0 */		.word	7
/* 0x170c	   0 */		.word	794
/* 0x1710	   0 */		.align	4
/* 0x1710	   0 */		.word	-1
/* 0x1714	   0 */		.word	-1
/* 0x1718	   0 */		.word	706
/* 0x171c	   0 */		.word	4145
/* 0x1720	   0 */		.word	7
/* 0x1724	   0 */		.word	801
/* 0x1728	   0 */		.align	4
/* 0x1728	   0 */		.word	-1
/* 0x172c	   0 */		.word	-1
/* 0x1730	   0 */		.word	707
/* 0x1734	   0 */		.word	8218
/* 0x1738	   0 */		.word	2
/* 0x173c	   0 */		.word	808
/* 0x1740	   0 */		.align	4
/* 0x1740	   0 */		.word	-1
/* 0x1744	   0 */		.word	-1
/* 0x1748	   0 */		.word	707
/* 0x174c	   0 */		.word	4122
/* 0x1750	   0 */		.word	2
/* 0x1754	   0 */		.word	810
/* 0x1758	   0 */		.align	4
/* 0x1758	   0 */		.word	-1
/* 0x175c	   0 */		.word	-1
/* 0x1760	   0 */		.word	707
/* 0x1764	   0 */		.word	4123
/* 0x1768	   0 */		.word	7
/* 0x176c	   0 */		.word	812
/* 0x1770	   0 */		.align	4
/* 0x1770	   0 */		.word	-1
/* 0x1774	   0 */		.word	-1
/* 0x1778	   0 */		.word	707
/* 0x177c	   0 */		.word	4145
/* 0x1780	   0 */		.word	7
/* 0x1784	   0 */		.word	819
/* 0x1788	   0 */		.align	4
/* 0x1788	   0 */		.word	-1
/* 0x178c	   0 */		.word	-1
/* 0x1790	   0 */		.word	708
/* 0x1794	   0 */		.word	8218
/* 0x1798	   0 */		.word	2
/* 0x179c	   0 */		.word	826
/* 0x17a0	   0 */		.align	4
/* 0x17a0	   0 */		.word	-1
/* 0x17a4	   0 */		.word	-1
/* 0x17a8	   0 */		.word	708
/* 0x17ac	   0 */		.word	4122
/* 0x17b0	   0 */		.word	2
/* 0x17b4	   0 */		.word	828
/* 0x17b8	   0 */		.align	4
/* 0x17b8	   0 */		.word	-1
/* 0x17bc	   0 */		.word	-1
/* 0x17c0	   0 */		.word	708
/* 0x17c4	   0 */		.word	4123
/* 0x17c8	   0 */		.word	7
/* 0x17cc	   0 */		.word	830
/* 0x17d0	   0 */		.align	4
/* 0x17d0	   0 */		.word	-1
/* 0x17d4	   0 */		.word	-1
/* 0x17d8	   0 */		.word	708
/* 0x17dc	   0 */		.word	4145
/* 0x17e0	   0 */		.word	7
/* 0x17e4	   0 */		.word	837
/* 0x17e8	   0 */		.align	4
/* 0x17e8	   0 */		.word	-1
/* 0x17ec	   0 */		.word	-1
/* 0x17f0	   0 */		.word	709
/* 0x17f4	   0 */		.word	8218
/* 0x17f8	   0 */		.word	2
/* 0x17fc	   0 */		.word	844
/* 0x1800	   0 */		.align	4
/* 0x1800	   0 */		.word	-1
/* 0x1804	   0 */		.word	-1
/* 0x1808	   0 */		.word	709
/* 0x180c	   0 */		.word	4122
/* 0x1810	   0 */		.word	2
/* 0x1814	   0 */		.word	846
/* 0x1818	   0 */		.align	4
/* 0x1818	   0 */		.word	-1
/* 0x181c	   0 */		.word	-1
/* 0x1820	   0 */		.word	709
/* 0x1824	   0 */		.word	4123
/* 0x1828	   0 */		.word	7
/* 0x182c	   0 */		.word	848
/* 0x1830	   0 */		.align	4
/* 0x1830	   0 */		.word	-1
/* 0x1834	   0 */		.word	-1
/* 0x1838	   0 */		.word	709
/* 0x183c	   0 */		.word	4145
/* 0x1840	   0 */		.word	7
/* 0x1844	   0 */		.word	855
/* 0x1848	   0 */		.align	4
/* 0x1848	   0 */		.word	-1
/* 0x184c	   0 */		.word	-1
/* 0x1850	   0 */		.word	800
/* 0x1854	   0 */		.word	8218
/* 0x1858	   0 */		.word	2
/* 0x185c	   0 */		.word	862
/* 0x1860	   0 */		.align	4
/* 0x1860	   0 */		.word	-1
/* 0x1864	   0 */		.word	-1
/* 0x1868	   0 */		.word	800
/* 0x186c	   0 */		.word	4122
/* 0x1870	   0 */		.word	2
/* 0x1874	   0 */		.word	864
/* 0x1878	   0 */		.align	4
/* 0x1878	   0 */		.word	-1
/* 0x187c	   0 */		.word	-1
/* 0x1880	   0 */		.word	800
/* 0x1884	   0 */		.word	4123
/* 0x1888	   0 */		.word	7
/* 0x188c	   0 */		.word	866
/* 0x1890	   0 */		.align	4
/* 0x1890	   0 */		.word	-1
/* 0x1894	   0 */		.word	-1
/* 0x1898	   0 */		.word	800
/* 0x189c	   0 */		.word	4145
/* 0x18a0	   0 */		.word	7
/* 0x18a4	   0 */		.word	873
/* 0x18a8	   0 */		.align	4
/* 0x18a8	   0 */		.word	-1
/* 0x18ac	   0 */		.word	-1
/* 0x18b0	   0 */		.word	801
/* 0x18b4	   0 */		.word	8218
/* 0x18b8	   0 */		.word	2
/* 0x18bc	   0 */		.word	880
/* 0x18c0	   0 */		.align	4
/* 0x18c0	   0 */		.word	-1
/* 0x18c4	   0 */		.word	-1
/* 0x18c8	   0 */		.word	801
/* 0x18cc	   0 */		.word	4122
/* 0x18d0	   0 */		.word	2
/* 0x18d4	   0 */		.word	882
/* 0x18d8	   0 */		.align	4
/* 0x18d8	   0 */		.word	-1
/* 0x18dc	   0 */		.word	-1
/* 0x18e0	   0 */		.word	801
/* 0x18e4	   0 */		.word	4123
/* 0x18e8	   0 */		.word	7
/* 0x18ec	   0 */		.word	884
/* 0x18f0	   0 */		.align	4
/* 0x18f0	   0 */		.word	-1
/* 0x18f4	   0 */		.word	-1
/* 0x18f8	   0 */		.word	801
/* 0x18fc	   0 */		.word	4145
/* 0x1900	   0 */		.word	7
/* 0x1904	   0 */		.word	891
/* 0x1908	   0 */		.align	4
/* 0x1908	   0 */		.word	-1
/* 0x190c	   0 */		.word	-1
/* 0x1910	   0 */		.word	802
/* 0x1914	   0 */		.word	8218
/* 0x1918	   0 */		.word	2
/* 0x191c	   0 */		.word	898
/* 0x1920	   0 */		.align	4
/* 0x1920	   0 */		.word	-1
/* 0x1924	   0 */		.word	-1
/* 0x1928	   0 */		.word	802
/* 0x192c	   0 */		.word	4122
/* 0x1930	   0 */		.word	2
/* 0x1934	   0 */		.word	900
/* 0x1938	   0 */		.align	4
/* 0x1938	   0 */		.word	-1
/* 0x193c	   0 */		.word	-1
/* 0x1940	   0 */		.word	802
/* 0x1944	   0 */		.word	4123
/* 0x1948	   0 */		.word	7
/* 0x194c	   0 */		.word	902
/* 0x1950	   0 */		.align	4
/* 0x1950	   0 */		.word	-1
/* 0x1954	   0 */		.word	-1
/* 0x1958	   0 */		.word	802
/* 0x195c	   0 */		.word	4145
/* 0x1960	   0 */		.word	7
/* 0x1964	   0 */		.word	909
/* 0x1968	   0 */		.align	4
/* 0x1968	   0 */		.word	-1
/* 0x196c	   0 */		.word	-1
/* 0x1970	   0 */		.word	803
/* 0x1974	   0 */		.word	8218
/* 0x1978	   0 */		.word	2
/* 0x197c	   0 */		.word	916
/* 0x1980	   0 */		.align	4
/* 0x1980	   0 */		.word	-1
/* 0x1984	   0 */		.word	-1
/* 0x1988	   0 */		.word	803
/* 0x198c	   0 */		.word	4122
/* 0x1990	   0 */		.word	2
/* 0x1994	   0 */		.word	918
/* 0x1998	   0 */		.align	4
/* 0x1998	   0 */		.word	-1
/* 0x199c	   0 */		.word	-1
/* 0x19a0	   0 */		.word	803
/* 0x19a4	   0 */		.word	4123
/* 0x19a8	   0 */		.word	7
/* 0x19ac	   0 */		.word	920
/* 0x19b0	   0 */		.align	4
/* 0x19b0	   0 */		.word	-1
/* 0x19b4	   0 */		.word	-1
/* 0x19b8	   0 */		.word	803
/* 0x19bc	   0 */		.word	4145
/* 0x19c0	   0 */		.word	7
/* 0x19c4	   0 */		.word	927
/* 0x19c8	   0 */		.align	4
/* 0x19c8	   0 */		.word	-1
/* 0x19cc	   0 */		.word	-1
/* 0x19d0	   0 */		.word	803
/* 0x19d4	   0 */		.word	8218
/* 0x19d8	   0 */		.word	2
/* 0x19dc	   0 */		.word	934
/* 0x19e0	   0 */		.align	4
/* 0x19e0	   0 */		.word	-1
/* 0x19e4	   0 */		.word	-1
/* 0x19e8	   0 */		.word	803
/* 0x19ec	   0 */		.word	4122
/* 0x19f0	   0 */		.word	2
/* 0x19f4	   0 */		.word	936
/* 0x19f8	   0 */		.align	4
/* 0x19f8	   0 */		.word	-1
/* 0x19fc	   0 */		.word	-1
/* 0x1a00	   0 */		.word	803
/* 0x1a04	   0 */		.word	4123
/* 0x1a08	   0 */		.word	7
/* 0x1a0c	   0 */		.word	938
/* 0x1a10	   0 */		.align	4
/* 0x1a10	   0 */		.word	-1
/* 0x1a14	   0 */		.word	-1
/* 0x1a18	   0 */		.word	803
/* 0x1a1c	   0 */		.word	4145
/* 0x1a20	   0 */		.word	7
/* 0x1a24	   0 */		.word	945
/* 0x1a28	   0 */		.align	4
/* 0x1a28	   0 */		.word	-1
/* 0x1a2c	   0 */		.word	-1
/* 0x1a30	   0 */		.word	802
/* 0x1a34	   0 */		.word	8218
/* 0x1a38	   0 */		.word	2
/* 0x1a3c	   0 */		.word	952
/* 0x1a40	   0 */		.align	4
/* 0x1a40	   0 */		.word	-1
/* 0x1a44	   0 */		.word	-1
/* 0x1a48	   0 */		.word	802
/* 0x1a4c	   0 */		.word	4122
/* 0x1a50	   0 */		.word	2
/* 0x1a54	   0 */		.word	954
/* 0x1a58	   0 */		.align	4
/* 0x1a58	   0 */		.word	-1
/* 0x1a5c	   0 */		.word	-1
/* 0x1a60	   0 */		.word	802
/* 0x1a64	   0 */		.word	4123
/* 0x1a68	   0 */		.word	7
/* 0x1a6c	   0 */		.word	956
/* 0x1a70	   0 */		.align	4
/* 0x1a70	   0 */		.word	-1
/* 0x1a74	   0 */		.word	-1
/* 0x1a78	   0 */		.word	802
/* 0x1a7c	   0 */		.word	4145
/* 0x1a80	   0 */		.word	7
/* 0x1a84	   0 */		.word	963
/* 0x1a88	   0 */		.align	4
/* 0x1a88	   0 */		.word	-1
/* 0x1a8c	   0 */		.word	-1
/* 0x1a90	   0 */		.word	801
/* 0x1a94	   0 */		.word	8218
/* 0x1a98	   0 */		.word	2
/* 0x1a9c	   0 */		.word	970
/* 0x1aa0	   0 */		.align	4
/* 0x1aa0	   0 */		.word	-1
/* 0x1aa4	   0 */		.word	-1
/* 0x1aa8	   0 */		.word	801
/* 0x1aac	   0 */		.word	4122
/* 0x1ab0	   0 */		.word	2
/* 0x1ab4	   0 */		.word	972
/* 0x1ab8	   0 */		.align	4
/* 0x1ab8	   0 */		.word	-1
/* 0x1abc	   0 */		.word	-1
/* 0x1ac0	   0 */		.word	801
/* 0x1ac4	   0 */		.word	4123
/* 0x1ac8	   0 */		.word	7
/* 0x1acc	   0 */		.word	974
/* 0x1ad0	   0 */		.align	4
/* 0x1ad0	   0 */		.word	-1
/* 0x1ad4	   0 */		.word	-1
/* 0x1ad8	   0 */		.word	801
/* 0x1adc	   0 */		.word	4145
/* 0x1ae0	   0 */		.word	7
/* 0x1ae4	   0 */		.word	981
/* 0x1ae8	   0 */		.align	4
/* 0x1ae8	   0 */		.word	-1
/* 0x1aec	   0 */		.word	-1
/* 0x1af0	   0 */		.word	800
/* 0x1af4	   0 */		.word	8218
/* 0x1af8	   0 */		.word	2
/* 0x1afc	   0 */		.word	988
/* 0x1b00	   0 */		.align	4
/* 0x1b00	   0 */		.word	-1
/* 0x1b04	   0 */		.word	-1
/* 0x1b08	   0 */		.word	800
/* 0x1b0c	   0 */		.word	4122
/* 0x1b10	   0 */		.word	2
/* 0x1b14	   0 */		.word	990
/* 0x1b18	   0 */		.align	4
/* 0x1b18	   0 */		.word	-1
/* 0x1b1c	   0 */		.word	-1
/* 0x1b20	   0 */		.word	800
/* 0x1b24	   0 */		.word	4123
/* 0x1b28	   0 */		.word	7
/* 0x1b2c	   0 */		.word	992
/* 0x1b30	   0 */		.align	4
/* 0x1b30	   0 */		.word	-1
/* 0x1b34	   0 */		.word	-1
/* 0x1b38	   0 */		.word	800
/* 0x1b3c	   0 */		.word	4145
/* 0x1b40	   0 */		.word	7
/* 0x1b44	   0 */		.word	999
/* 0x1b48	   0 */		.align	4
/* 0x1b48	   0 */		.word	-1
/* 0x1b4c	   0 */		.word	-1
/* 0x1b50	   0 */		.word	709
/* 0x1b54	   0 */		.word	8218
/* 0x1b58	   0 */		.word	2
/* 0x1b5c	   0 */		.word	1006
/* 0x1b60	   0 */		.align	4
/* 0x1b60	   0 */		.word	-1
/* 0x1b64	   0 */		.word	-1
/* 0x1b68	   0 */		.word	709
/* 0x1b6c	   0 */		.word	4122
/* 0x1b70	   0 */		.word	2
/* 0x1b74	   0 */		.word	1008
/* 0x1b78	   0 */		.align	4
/* 0x1b78	   0 */		.word	-1
/* 0x1b7c	   0 */		.word	-1
/* 0x1b80	   0 */		.word	709
/* 0x1b84	   0 */		.word	4123
/* 0x1b88	   0 */		.word	7
/* 0x1b8c	   0 */		.word	1010
/* 0x1b90	   0 */		.align	4
/* 0x1b90	   0 */		.word	-1
/* 0x1b94	   0 */		.word	-1
/* 0x1b98	   0 */		.word	709
/* 0x1b9c	   0 */		.word	4145
/* 0x1ba0	   0 */		.word	7
/* 0x1ba4	   0 */		.word	1017
/* 0x1ba8	   0 */		.align	4
/* 0x1ba8	   0 */		.word	-1
/* 0x1bac	   0 */		.word	-1
/* 0x1bb0	   0 */		.word	708
/* 0x1bb4	   0 */		.word	8218
/* 0x1bb8	   0 */		.word	2
/* 0x1bbc	   0 */		.word	1024
/* 0x1bc0	   0 */		.align	4
/* 0x1bc0	   0 */		.word	-1
/* 0x1bc4	   0 */		.word	-1
/* 0x1bc8	   0 */		.word	708
/* 0x1bcc	   0 */		.word	4122
/* 0x1bd0	   0 */		.word	2
/* 0x1bd4	   0 */		.word	1026
/* 0x1bd8	   0 */		.align	4
/* 0x1bd8	   0 */		.word	-1
/* 0x1bdc	   0 */		.word	-1
/* 0x1be0	   0 */		.word	708
/* 0x1be4	   0 */		.word	4123
/* 0x1be8	   0 */		.word	7
/* 0x1bec	   0 */		.word	1028
/* 0x1bf0	   0 */		.align	4
/* 0x1bf0	   0 */		.word	-1
/* 0x1bf4	   0 */		.word	-1
/* 0x1bf8	   0 */		.word	708
/* 0x1bfc	   0 */		.word	4145
/* 0x1c00	   0 */		.word	7
/* 0x1c04	   0 */		.word	1035
/* 0x1c08	   0 */		.align	4
/* 0x1c08	   0 */		.word	-1
/* 0x1c0c	   0 */		.word	-1
/* 0x1c10	   0 */		.word	707
/* 0x1c14	   0 */		.word	8218
/* 0x1c18	   0 */		.word	2
/* 0x1c1c	   0 */		.word	1042
/* 0x1c20	   0 */		.align	4
/* 0x1c20	   0 */		.word	-1
/* 0x1c24	   0 */		.word	-1
/* 0x1c28	   0 */		.word	707
/* 0x1c2c	   0 */		.word	4122
/* 0x1c30	   0 */		.word	2
/* 0x1c34	   0 */		.word	1044
/* 0x1c38	   0 */		.align	4
/* 0x1c38	   0 */		.word	-1
/* 0x1c3c	   0 */		.word	-1
/* 0x1c40	   0 */		.word	707
/* 0x1c44	   0 */		.word	4123
/* 0x1c48	   0 */		.word	7
/* 0x1c4c	   0 */		.word	1046
/* 0x1c50	   0 */		.align	4
/* 0x1c50	   0 */		.word	-1
/* 0x1c54	   0 */		.word	-1
/* 0x1c58	   0 */		.word	707
/* 0x1c5c	   0 */		.word	4145
/* 0x1c60	   0 */		.word	7
/* 0x1c64	   0 */		.word	1053
/* 0x1c68	   0 */		.align	4
/* 0x1c68	   0 */		.word	-1
/* 0x1c6c	   0 */		.word	-1
/* 0x1c70	   0 */		.word	706
/* 0x1c74	   0 */		.word	8218
/* 0x1c78	   0 */		.word	2
/* 0x1c7c	   0 */		.word	1060
/* 0x1c80	   0 */		.align	4
/* 0x1c80	   0 */		.word	-1
/* 0x1c84	   0 */		.word	-1
/* 0x1c88	   0 */		.word	706
/* 0x1c8c	   0 */		.word	4122
/* 0x1c90	   0 */		.word	2
/* 0x1c94	   0 */		.word	1062
/* 0x1c98	   0 */		.align	4
/* 0x1c98	   0 */		.word	-1
/* 0x1c9c	   0 */		.word	-1
/* 0x1ca0	   0 */		.word	706
/* 0x1ca4	   0 */		.word	4123
/* 0x1ca8	   0 */		.word	7
/* 0x1cac	   0 */		.word	1064
/* 0x1cb0	   0 */		.align	4
/* 0x1cb0	   0 */		.word	-1
/* 0x1cb4	   0 */		.word	-1
/* 0x1cb8	   0 */		.word	706
/* 0x1cbc	   0 */		.word	4145
/* 0x1cc0	   0 */		.word	7
/* 0x1cc4	   0 */		.word	1071
/* 0x1cc8	   0 */		.align	4
/* 0x1cc8	   0 */		.word	-1
/* 0x1ccc	   0 */		.word	-1
/* 0x1cd0	   0 */		.word	694
/* 0x1cd4	   0 */		.word	4148
/* 0x1cd8	   0 */		.word	3
/* 0x1cdc	   0 */		.word	1078
/* 0x1ce0	   0 */		.align	4
/* 0x1ce0	   0 */		.word	-1
/* 0x1ce4	   0 */		.word	-1
/* 0x1ce8	   0 */		.word	694
/* 0x1cec	   0 */		.word	8218
/* 0x1cf0	   0 */		.word	2
/* 0x1cf4	   0 */		.word	1081
/* 0x1cf8	   0 */		.align	4
/* 0x1cf8	   0 */		.word	-1
/* 0x1cfc	   0 */		.word	-1
/* 0x1d00	   0 */		.word	694
/* 0x1d04	   0 */		.word	4122
/* 0x1d08	   0 */		.word	2
/* 0x1d0c	   0 */		.word	1083
/* 0x1d10	   0 */		.align	4
/* 0x1d10	   0 */		.word	-1
/* 0x1d14	   0 */		.word	-1
/* 0x1d18	   0 */		.word	694
/* 0x1d1c	   0 */		.word	4123
/* 0x1d20	   0 */		.word	7
/* 0x1d24	   0 */		.word	1085
/* 0x1d28	   0 */		.align	4
/* 0x1d28	   0 */		.word	-1
/* 0x1d2c	   0 */		.word	-1
/* 0x1d30	   0 */		.word	694
/* 0x1d34	   0 */		.word	4145
/* 0x1d38	   0 */		.word	7
/* 0x1d3c	   0 */		.word	1092
/* 0x1d40	   0 */		.align	4
/* 0x1d40	   0 */		.word	-1
/* 0x1d44	   0 */		.word	-1
/* 0x1d48	   0 */		.word	849
/* 0x1d4c	   0 */		.word	16414
/* 0x1d50	   0 */		.word	1
/* 0x1d54	   0 */		.word	1099
/* 0x1d58	   0 */		.align	4
/* 0x1d58	   0 */		.word	-1
/* 0x1d5c	   0 */		.word	-1
/* 0x1d60	   0 */		.word	865
/* 0x1d64	   0 */		.word	16414
/* 0x1d68	   0 */		.word	1
/* 0x1d6c	   0 */		.word	1100
/* 0x1d70	   0 */		.align	4
/* 0x1d70	   0 */		.word	-1
/* 0x1d74	   0 */		.word	-1
/* 0x1d78	   0 */		.word	840
/* 0x1d7c	   0 */		.word	65571
/* 0x1d80	   0 */		.word	1
/* 0x1d84	   0 */		.word	1101
/* 0x1d88	   0 */		.align	4
/* 0x1d88	   0 */		.word	-1
/* 0x1d8c	   0 */		.word	-1
/* 0x1d90	   0 */		.word	855
/* 0x1d94	   0 */		.word	65572
/* 0x1d98	   0 */		.word	1
/* 0x1d9c	   0 */		.word	1102
/* 0x1da0	   0 */		.align	4
/* 0x1da0	   0 */		.word	-1
/* 0x1da4	   0 */		.word	-1
/* 0x1da8	   0 */		.word	840
/* 0x1dac	   0 */		.word	4148
/* 0x1db0	   0 */		.word	3
/* 0x1db4	   0 */		.word	1103
/* 0x1db8	   0 */		.align	4
/* 0x1db8	   0 */		.word	-1
/* 0x1dbc	   0 */		.word	-1
/* 0x1dc0	   0 */		.word	840
/* 0x1dc4	   0 */		.word	4125
/* 0x1dc8	   0 */		.word	6
/* 0x1dcc	   0 */		.word	1106
/* 0x1dd0	   0 */		.align	4
/* 0x1dd0	   0 */		.word	-1
/* 0x1dd4	   0 */		.word	-1
/* 0x1dd8	   0 */		.word	840
/* 0x1ddc	   0 */		.word	4136
/* 0x1de0	   0 */		.word	3
/* 0x1de4	   0 */		.word	1112
/* 0x1de8	   0 */		.align	4
/* 0x1de8	   0 */		.word	-1
/* 0x1dec	   0 */		.word	-1
/* 0x1df0	   0 */		.word	840
/* 0x1df4	   0 */		.word	4136
/* 0x1df8	   0 */		.word	3
/* 0x1dfc	   0 */		.word	1115
/* 0x1e00	   0 */		.align	4
/* 0x1e00	   0 */		.word	-1
/* 0x1e04	   0 */		.word	-1
/* 0x1e08	   0 */		.word	840
/* 0x1e0c	   0 */		.word	4136
/* 0x1e10	   0 */		.word	3
/* 0x1e14	   0 */		.word	1118
/* 0x1e18	   0 */		.align	4
/* 0x1e18	   0 */		.word	-1
/* 0x1e1c	   0 */		.word	-1
/* 0x1e20	   0 */		.word	849
/* 0x1e24	   0 */		.word	131075
/* 0x1e28	   0 */		.word	1
/* 0x1e2c	   0 */		.word	1121
/* 0x1e30	   0 */		.align	4
/* 0x1e30	   0 */		.word	-1
/* 0x1e34	   0 */		.word	-1
/* 0x1e38	   0 */		.word	865
/* 0x1e3c	   0 */		.word	131075
/* 0x1e40	   0 */		.word	1
/* 0x1e44	   0 */		.word	1122
/* 0x1e48	   0 */		.align	4
/* 0x1e48	   0 */		.word	-1
/* 0x1e4c	   0 */		.word	-1
/* 0x1e50	   0 */		.word	840
/* 0x1e54	   0 */		.word	8229
/* 0x1e58	   0 */		.word	1
/* 0x1e5c	   0 */		.word	1123
/* 0x1e60	   0 */		.align	4
/* 0x1e60	   0 */		.word	-1
/* 0x1e64	   0 */		.word	-1
/* 0x1e68	   0 */		.word	840
/* 0x1e6c	   0 */		.word	8218
/* 0x1e70	   0 */		.word	2
/* 0x1e74	   0 */		.word	1124
/* 0x1e78	   0 */		.align	4
/* 0x1e78	   0 */		.word	-1
/* 0x1e7c	   0 */		.word	-1
/* 0x1e80	   0 */		.word	840
/* 0x1e84	   0 */		.word	4122
/* 0x1e88	   0 */		.word	2
/* 0x1e8c	   0 */		.word	1126
/* 0x1e90	   0 */		.align	4
/* 0x1e90	   0 */		.word	-1
/* 0x1e94	   0 */		.word	-1
/* 0x1e98	   0 */		.word	840
/* 0x1e9c	   0 */		.word	4123
/* 0x1ea0	   0 */		.word	7
/* 0x1ea4	   0 */		.word	1128
/* 0x1ea8	   0 */		.align	4
/* 0x1ea8	   0 */		.word	-1
/* 0x1eac	   0 */		.word	-1
/* 0x1eb0	   0 */		.word	840
/* 0x1eb4	   0 */		.word	4145
/* 0x1eb8	   0 */		.word	7
/* 0x1ebc	   0 */		.word	1135
/* 0x1ec0	   0 */		.align	4
/* 0x1ec0	   0 */		.word	-1
/* 0x1ec4	   0 */		.word	-1
/* 0x1ec8	   0 */		.word	885
/* 0x1ecc	   0 */		.word	65571
/* 0x1ed0	   0 */		.word	1
/* 0x1ed4	   0 */		.word	1142
/* 0x1ed8	   0 */		.align	4
/* 0x1ed8	   0 */		.word	-1
/* 0x1edc	   0 */		.word	-1
/* 0x1ee0	   0 */		.word	897
/* 0x1ee4	   0 */		.word	65572
/* 0x1ee8	   0 */		.word	1
/* 0x1eec	   0 */		.word	1143
/* 0x1ef0	   0 */		.align	4
/* 0x1ef0	   0 */		.word	-1
/* 0x1ef4	   0 */		.word	-1
/* 0x1ef8	   0 */		.word	885
/* 0x1efc	   0 */		.word	4148
/* 0x1f00	   0 */		.word	3
/* 0x1f04	   0 */		.word	1144
/* 0x1f08	   0 */		.align	4
/* 0x1f08	   0 */		.word	-1
/* 0x1f0c	   0 */		.word	-1
/* 0x1f10	   0 */		.word	885
/* 0x1f14	   0 */		.word	8229
/* 0x1f18	   0 */		.word	1
/* 0x1f1c	   0 */		.word	1147
/* 0x1f20	   0 */		.align	4
/* 0x1f20	   0 */		.word	-1
/* 0x1f24	   0 */		.word	-1
/* 0x1f28	   0 */		.word	885
/* 0x1f2c	   0 */		.word	8218
/* 0x1f30	   0 */		.word	2
/* 0x1f34	   0 */		.word	1148
/* 0x1f38	   0 */		.align	4
/* 0x1f38	   0 */		.word	-1
/* 0x1f3c	   0 */		.word	-1
/* 0x1f40	   0 */		.word	885
/* 0x1f44	   0 */		.word	4122
/* 0x1f48	   0 */		.word	2
/* 0x1f4c	   0 */		.word	1150
/* 0x1f50	   0 */		.align	4
/* 0x1f50	   0 */		.word	-1
/* 0x1f54	   0 */		.word	-1
/* 0x1f58	   0 */		.word	885
/* 0x1f5c	   0 */		.word	4123
/* 0x1f60	   0 */		.word	7
/* 0x1f64	   0 */		.word	1152
/* 0x1f68	   0 */		.align	4
/* 0x1f68	   0 */		.word	-1
/* 0x1f6c	   0 */		.word	-1
/* 0x1f70	   0 */		.word	885
/* 0x1f74	   0 */		.word	4145
/* 0x1f78	   0 */		.word	7
/* 0x1f7c	   0 */		.word	1159
/* 0x1f80	   0 */		.word	7
/* 0x1f84	   0 */		.word	7
/* 0x1f88	   0 */		.word	10
/* 0x1f8c	   0 */		.word	32
/* 0x1f90	   0 */		.word	36
/* 0x1f94	   0 */		.word	39
/* 0x1f98	   0 */		.word	59
/* 0x1f9c	   0 */		.word	75
/* 0x1fa0	   0 */		.word	91
/* 0x1fa4	   0 */		.word	113
/* 0x1fa8	   0 */		.word	132
/* 0x1fac	   0 */		.word	113
/* 0x1fb0	   0 */		.word	132
/* 0x1fb4	   0 */		.word	151
/* 0x1fb8	   0 */		.word	0
/* 0x1fbc	   0 */		.word	1
/* 0x1fc0	   0 */		.word	151
/* 0x1fc4	   0 */		.word	147
/* 0x1fc8	   0 */		.word	161
/* 0x1fcc	   0 */		.word	165
/* 0x1fd0	   0 */		.word	0
/* 0x1fd4	   0 */		.word	1
/* 0x1fd8	   0 */		.word	165
/* 0x1fdc	   0 */		.word	104
/* 0x1fe0	   0 */		.word	186
/* 0x1fe4	   0 */		.word	186
/* 0x1fe8	   0 */		.word	10
/* 0x1fec	   0 */		.word	190
/* 0x1ff0	   0 */		.word	194
/* 0x1ff4	   0 */		.word	2
/* 0x1ff8	   0 */		.word	201
/* 0x1ffc	   0 */		.word	205
/* 0x2000	   0 */		.word	194
/* 0x2004	   0 */		.word	2
/* 0x2008	   0 */		.word	209
/* 0x200c	   0 */		.word	213
/* 0x2010	   0 */		.word	217
/* 0x2014	   0 */		.word	2
/* 0x2018	   0 */		.word	224
/* 0x201c	   0 */		.word	228
/* 0x2020	   0 */		.word	213
/* 0x2024	   0 */		.word	3
/* 0x2028	   0 */		.word	213
/* 0x202c	   0 */		.word	1
/* 0x2030	   0 */		.word	213
/* 0x2034	   0 */		.word	1
/* 0x2038	   0 */		.word	1
/* 0x203c	   0 */		.word	0
/* 0x2040	   0 */		.word	0
/* 0x2044	   0 */		.word	0
/* 0x2048	   0 */		.word	0
/* 0x204c	   0 */		.word	213
/* 0x2050	   0 */		.word	0
/* 0x2054	   0 */		.word	0
/* 0x2058	   0 */		.word	4
/* 0x205c	   0 */		.word	0
/* 0x2060	   0 */		.word	0
/* 0x2064	   0 */		.word	0
/* 0x2068	   0 */		.word	205
/* 0x206c	   0 */		.word	3
/* 0x2070	   0 */		.word	205
/* 0x2074	   0 */		.word	1
/* 0x2078	   0 */		.word	205
/* 0x207c	   0 */		.word	1
/* 0x2080	   0 */		.word	1
/* 0x2084	   0 */		.word	0
/* 0x2088	   0 */		.word	0
/* 0x208c	   0 */		.word	0
/* 0x2090	   0 */		.word	0
/* 0x2094	   0 */		.word	205
/* 0x2098	   0 */		.word	0
/* 0x209c	   0 */		.word	0
/* 0x20a0	   0 */		.word	4
/* 0x20a4	   0 */		.word	0
/* 0x20a8	   0 */		.word	0
/* 0x20ac	   0 */		.word	0
/* 0x20b0	   0 */		.word	201
/* 0x20b4	   0 */		.word	6
/* 0x20b8	   0 */		.word	201
/* 0x20bc	   0 */		.word	1
/* 0x20c0	   0 */		.word	201
/* 0x20c4	   0 */		.word	0
/* 0x20c8	   0 */		.word	0
/* 0x20cc	   0 */		.word	0
/* 0x20d0	   0 */		.word	0
/* 0x20d4	   0 */		.word	0
/* 0x20d8	   0 */		.word	0
/* 0x20dc	   0 */		.word	201
/* 0x20e0	   0 */		.word	2
/* 0x20e4	   0 */		.word	2
/* 0x20e8	   0 */		.word	4
/* 0x20ec	   0 */		.word	0
/* 0x20f0	   0 */		.word	0
/* 0x20f4	   0 */		.word	0
/* 0x20f8	   0 */		.word	209
/* 0x20fc	   0 */		.word	6
/* 0x2100	   0 */		.word	209
/* 0x2104	   0 */		.word	1
/* 0x2108	   0 */		.word	209
/* 0x210c	   0 */		.word	0
/* 0x2110	   0 */		.word	0
/* 0x2114	   0 */		.word	0
/* 0x2118	   0 */		.word	0
/* 0x211c	   0 */		.word	0
/* 0x2120	   0 */		.word	0
/* 0x2124	   0 */		.word	209
/* 0x2128	   0 */		.word	2
/* 0x212c	   0 */		.word	2
/* 0x2130	   0 */		.word	4
/* 0x2134	   0 */		.word	0
/* 0x2138	   0 */		.word	0
/* 0x213c	   0 */		.word	0
/* 0x2140	   0 */		.word	228
/* 0x2144	   0 */		.word	232
/* 0x2148	   0 */		.word	261
/* 0x214c	   0 */		.word	261
/* 0x2150	   0 */		.word	1
/* 0x2154	   0 */		.word	261
/* 0x2158	   0 */		.word	2
/* 0x215c	   0 */		.word	261
/* 0x2160	   0 */		.word	0
/* 0x2164	   0 */		.word	0
/* 0x2168	   0 */		.word	0
/* 0x216c	   0 */		.word	0
/* 0x2170	   0 */		.word	0
/* 0x2174	   0 */		.word	0
/* 0x2178	   0 */		.word	261
/* 0x217c	   0 */		.word	0
/* 0x2180	   0 */		.word	1
/* 0x2184	   0 */		.word	3
/* 0x2188	   0 */		.word	0
/* 0x218c	   0 */		.word	0
/* 0x2190	   0 */		.word	0
/* 0x2194	   0 */		.word	59
/* 0x2198	   0 */		.word	75
/* 0x219c	   0 */		.word	91
/* 0x21a0	   0 */		.word	39
/* 0x21a4	   0 */		.word	113
/* 0x21a8	   0 */		.word	132
/* 0x21ac	   0 */		.word	113
/* 0x21b0	   0 */		.word	132
/* 0x21b4	   0 */		.word	151
/* 0x21b8	   0 */		.word	0
/* 0x21bc	   0 */		.word	1
/* 0x21c0	   0 */		.word	151
/* 0x21c4	   0 */		.word	147
/* 0x21c8	   0 */		.word	265
/* 0x21cc	   0 */		.word	165
/* 0x21d0	   0 */		.word	0
/* 0x21d4	   0 */		.word	1
/* 0x21d8	   0 */		.word	165
/* 0x21dc	   0 */		.word	104
/* 0x21e0	   0 */		.word	269
/* 0x21e4	   0 */		.word	273
/* 0x21e8	   0 */		.word	276
/* 0x21ec	   0 */		.word	273
/* 0x21f0	   0 */		.word	10
/* 0x21f4	   0 */		.word	279
/* 0x21f8	   0 */		.word	276
/* 0x21fc	   0 */		.word	10
/* 0x2200	   0 */		.word	283
/* 0x2204	   0 */		.word	269
/* 0x2208	   0 */		.word	10
/* 0x220c	   0 */		.word	287
/* 0x2210	   0 */		.word	194
/* 0x2214	   0 */		.word	2
/* 0x2218	   0 */		.word	291
/* 0x221c	   0 */		.word	295
/* 0x2220	   0 */		.word	217
/* 0x2224	   0 */		.word	2
/* 0x2228	   0 */		.word	299
/* 0x222c	   0 */		.word	303
/* 0x2230	   0 */		.word	273
/* 0x2234	   0 */		.word	295
/* 0x2238	   0 */		.word	3
/* 0x223c	   0 */		.word	295
/* 0x2240	   0 */		.word	1
/* 0x2244	   0 */		.word	295
/* 0x2248	   0 */		.word	1
/* 0x224c	   0 */		.word	1
/* 0x2250	   0 */		.word	0
/* 0x2254	   0 */		.word	0
/* 0x2258	   0 */		.word	0
/* 0x225c	   0 */		.word	0
/* 0x2260	   0 */		.word	295
/* 0x2264	   0 */		.word	0
/* 0x2268	   0 */		.word	0
/* 0x226c	   0 */		.word	4
/* 0x2270	   0 */		.word	0
/* 0x2274	   0 */		.word	0
/* 0x2278	   0 */		.word	0
/* 0x227c	   0 */		.word	276
/* 0x2280	   0 */		.word	283
/* 0x2284	   0 */		.word	1
/* 0x2288	   0 */		.word	283
/* 0x228c	   0 */		.word	2
/* 0x2290	   0 */		.word	283
/* 0x2294	   0 */		.word	0
/* 0x2298	   0 */		.word	0
/* 0x229c	   0 */		.word	0
/* 0x22a0	   0 */		.word	0
/* 0x22a4	   0 */		.word	0
/* 0x22a8	   0 */		.word	0
/* 0x22ac	   0 */		.word	283
/* 0x22b0	   0 */		.word	0
/* 0x22b4	   0 */		.word	1
/* 0x22b8	   0 */		.word	3
/* 0x22bc	   0 */		.word	0
/* 0x22c0	   0 */		.word	0
/* 0x22c4	   0 */		.word	0
/* 0x22c8	   0 */		.word	291
/* 0x22cc	   0 */		.word	6
/* 0x22d0	   0 */		.word	291
/* 0x22d4	   0 */		.word	1
/* 0x22d8	   0 */		.word	291
/* 0x22dc	   0 */		.word	0
/* 0x22e0	   0 */		.word	0
/* 0x22e4	   0 */		.word	0
/* 0x22e8	   0 */		.word	0
/* 0x22ec	   0 */		.word	0
/* 0x22f0	   0 */		.word	0
/* 0x22f4	   0 */		.word	291
/* 0x22f8	   0 */		.word	2
/* 0x22fc	   0 */		.word	2
/* 0x2300	   0 */		.word	4
/* 0x2304	   0 */		.word	0
/* 0x2308	   0 */		.word	0
/* 0x230c	   0 */		.word	0
/* 0x2310	   0 */		.word	279
/* 0x2314	   0 */		.word	1
/* 0x2318	   0 */		.word	279
/* 0x231c	   0 */		.word	2
/* 0x2320	   0 */		.word	279
/* 0x2324	   0 */		.word	0
/* 0x2328	   0 */		.word	0
/* 0x232c	   0 */		.word	0
/* 0x2330	   0 */		.word	0
/* 0x2334	   0 */		.word	0
/* 0x2338	   0 */		.word	0
/* 0x233c	   0 */		.word	279
/* 0x2340	   0 */		.word	0
/* 0x2344	   0 */		.word	1
/* 0x2348	   0 */		.word	3
/* 0x234c	   0 */		.word	0
/* 0x2350	   0 */		.word	0
/* 0x2354	   0 */		.word	0
/* 0x2358	   0 */		.word	303
/* 0x235c	   0 */		.word	232
/* 0x2360	   0 */		.word	307
/* 0x2364	   0 */		.word	307
/* 0x2368	   0 */		.word	1
/* 0x236c	   0 */		.word	307
/* 0x2370	   0 */		.word	2
/* 0x2374	   0 */		.word	307
/* 0x2378	   0 */		.word	0
/* 0x237c	   0 */		.word	0
/* 0x2380	   0 */		.word	0
/* 0x2384	   0 */		.word	0
/* 0x2388	   0 */		.word	0
/* 0x238c	   0 */		.word	0
/* 0x2390	   0 */		.word	307
/* 0x2394	   0 */		.word	0
/* 0x2398	   0 */		.word	1
/* 0x239c	   0 */		.word	3
/* 0x23a0	   0 */		.word	0
/* 0x23a4	   0 */		.word	0
/* 0x23a8	   0 */		.word	0
/* 0x23ac	   0 */		.word	311
/* 0x23b0	   0 */		.word	59
/* 0x23b4	   0 */		.word	331
/* 0x23b8	   0 */		.word	75
/* 0x23bc	   0 */		.word	91
/* 0x23c0	   0 */		.word	345
/* 0x23c4	   0 */		.word	366
/* 0x23c8	   0 */		.word	380
/* 0x23cc	   0 */		.word	399
/* 0x23d0	   0 */		.word	345
/* 0x23d4	   0 */		.word	366
/* 0x23d8	   0 */		.word	380
/* 0x23dc	   0 */		.word	399
/* 0x23e0	   0 */		.word	151
/* 0x23e4	   0 */		.word	0
/* 0x23e8	   0 */		.word	1
/* 0x23ec	   0 */		.word	151
/* 0x23f0	   0 */		.word	147
/* 0x23f4	   0 */		.word	419
/* 0x23f8	   0 */		.word	165
/* 0x23fc	   0 */		.word	0
/* 0x2400	   0 */		.word	1
/* 0x2404	   0 */		.word	165
/* 0x2408	   0 */		.word	104
/* 0x240c	   0 */		.word	423
/* 0x2410	   0 */		.word	423
/* 0x2414	   0 */		.word	10
/* 0x2418	   0 */		.word	427
/* 0x241c	   0 */		.word	194
/* 0x2420	   0 */		.word	2
/* 0x2424	   0 */		.word	431
/* 0x2428	   0 */		.word	435
/* 0x242c	   0 */		.word	194
/* 0x2430	   0 */		.word	2
/* 0x2434	   0 */		.word	439
/* 0x2438	   0 */		.word	443
/* 0x243c	   0 */		.word	194
/* 0x2440	   0 */		.word	2
/* 0x2444	   0 */		.word	447
/* 0x2448	   0 */		.word	451
/* 0x244c	   0 */		.word	194
/* 0x2450	   0 */		.word	2
/* 0x2454	   0 */		.word	455
/* 0x2458	   0 */		.word	459
/* 0x245c	   0 */		.word	194
/* 0x2460	   0 */		.word	2
/* 0x2464	   0 */		.word	463
/* 0x2468	   0 */		.word	467
/* 0x246c	   0 */		.word	194
/* 0x2470	   0 */		.word	2
/* 0x2474	   0 */		.word	471
/* 0x2478	   0 */		.word	475
/* 0x247c	   0 */		.word	194
/* 0x2480	   0 */		.word	2
/* 0x2484	   0 */		.word	479
/* 0x2488	   0 */		.word	483
/* 0x248c	   0 */		.word	194
/* 0x2490	   0 */		.word	2
/* 0x2494	   0 */		.word	487
/* 0x2498	   0 */		.word	491
/* 0x249c	   0 */		.word	217
/* 0x24a0	   0 */		.word	2
/* 0x24a4	   0 */		.word	495
/* 0x24a8	   0 */		.word	499
/* 0x24ac	   0 */		.word	491
/* 0x24b0	   0 */		.word	3
/* 0x24b4	   0 */		.word	491
/* 0x24b8	   0 */		.word	1
/* 0x24bc	   0 */		.word	491
/* 0x24c0	   0 */		.word	1
/* 0x24c4	   0 */		.word	1
/* 0x24c8	   0 */		.word	0
/* 0x24cc	   0 */		.word	0
/* 0x24d0	   0 */		.word	0
/* 0x24d4	   0 */		.word	0
/* 0x24d8	   0 */		.word	491
/* 0x24dc	   0 */		.word	0
/* 0x24e0	   0 */		.word	0
/* 0x24e4	   0 */		.word	4
/* 0x24e8	   0 */		.word	0
/* 0x24ec	   0 */		.word	0
/* 0x24f0	   0 */		.word	0
/* 0x24f4	   0 */		.word	483
/* 0x24f8	   0 */		.word	3
/* 0x24fc	   0 */		.word	483
/* 0x2500	   0 */		.word	1
/* 0x2504	   0 */		.word	483
/* 0x2508	   0 */		.word	1
/* 0x250c	   0 */		.word	1
/* 0x2510	   0 */		.word	0
/* 0x2514	   0 */		.word	0
/* 0x2518	   0 */		.word	0
/* 0x251c	   0 */		.word	0
/* 0x2520	   0 */		.word	483
/* 0x2524	   0 */		.word	0
/* 0x2528	   0 */		.word	0
/* 0x252c	   0 */		.word	4
/* 0x2530	   0 */		.word	0
/* 0x2534	   0 */		.word	0
/* 0x2538	   0 */		.word	0
/* 0x253c	   0 */		.word	475
/* 0x2540	   0 */		.word	3
/* 0x2544	   0 */		.word	475
/* 0x2548	   0 */		.word	1
/* 0x254c	   0 */		.word	475
/* 0x2550	   0 */		.word	1
/* 0x2554	   0 */		.word	1
/* 0x2558	   0 */		.word	0
/* 0x255c	   0 */		.word	0
/* 0x2560	   0 */		.word	0
/* 0x2564	   0 */		.word	0
/* 0x2568	   0 */		.word	475
/* 0x256c	   0 */		.word	0
/* 0x2570	   0 */		.word	0
/* 0x2574	   0 */		.word	4
/* 0x2578	   0 */		.word	0
/* 0x257c	   0 */		.word	0
/* 0x2580	   0 */		.word	0
/* 0x2584	   0 */		.word	467
/* 0x2588	   0 */		.word	3
/* 0x258c	   0 */		.word	467
/* 0x2590	   0 */		.word	1
/* 0x2594	   0 */		.word	467
/* 0x2598	   0 */		.word	1
/* 0x259c	   0 */		.word	1
/* 0x25a0	   0 */		.word	0
/* 0x25a4	   0 */		.word	0
/* 0x25a8	   0 */		.word	0
/* 0x25ac	   0 */		.word	0
/* 0x25b0	   0 */		.word	467
/* 0x25b4	   0 */		.word	0
/* 0x25b8	   0 */		.word	0
/* 0x25bc	   0 */		.word	4
/* 0x25c0	   0 */		.word	0
/* 0x25c4	   0 */		.word	0
/* 0x25c8	   0 */		.word	0
/* 0x25cc	   0 */		.word	459
/* 0x25d0	   0 */		.word	3
/* 0x25d4	   0 */		.word	459
/* 0x25d8	   0 */		.word	1
/* 0x25dc	   0 */		.word	459
/* 0x25e0	   0 */		.word	1
/* 0x25e4	   0 */		.word	1
/* 0x25e8	   0 */		.word	0
/* 0x25ec	   0 */		.word	0
/* 0x25f0	   0 */		.word	0
/* 0x25f4	   0 */		.word	0
/* 0x25f8	   0 */		.word	459
/* 0x25fc	   0 */		.word	0
/* 0x2600	   0 */		.word	0
/* 0x2604	   0 */		.word	4
/* 0x2608	   0 */		.word	0
/* 0x260c	   0 */		.word	0
/* 0x2610	   0 */		.word	0
/* 0x2614	   0 */		.word	451
/* 0x2618	   0 */		.word	3
/* 0x261c	   0 */		.word	451
/* 0x2620	   0 */		.word	1
/* 0x2624	   0 */		.word	451
/* 0x2628	   0 */		.word	1
/* 0x262c	   0 */		.word	1
/* 0x2630	   0 */		.word	0
/* 0x2634	   0 */		.word	0
/* 0x2638	   0 */		.word	0
/* 0x263c	   0 */		.word	0
/* 0x2640	   0 */		.word	451
/* 0x2644	   0 */		.word	0
/* 0x2648	   0 */		.word	0
/* 0x264c	   0 */		.word	4
/* 0x2650	   0 */		.word	0
/* 0x2654	   0 */		.word	0
/* 0x2658	   0 */		.word	0
/* 0x265c	   0 */		.word	443
/* 0x2660	   0 */		.word	3
/* 0x2664	   0 */		.word	443
/* 0x2668	   0 */		.word	1
/* 0x266c	   0 */		.word	443
/* 0x2670	   0 */		.word	1
/* 0x2674	   0 */		.word	1
/* 0x2678	   0 */		.word	0
/* 0x267c	   0 */		.word	0
/* 0x2680	   0 */		.word	0
/* 0x2684	   0 */		.word	0
/* 0x2688	   0 */		.word	443
/* 0x268c	   0 */		.word	0
/* 0x2690	   0 */		.word	0
/* 0x2694	   0 */		.word	4
/* 0x2698	   0 */		.word	0
/* 0x269c	   0 */		.word	0
/* 0x26a0	   0 */		.word	0
/* 0x26a4	   0 */		.word	435
/* 0x26a8	   0 */		.word	3
/* 0x26ac	   0 */		.word	435
/* 0x26b0	   0 */		.word	1
/* 0x26b4	   0 */		.word	435
/* 0x26b8	   0 */		.word	1
/* 0x26bc	   0 */		.word	1
/* 0x26c0	   0 */		.word	0
/* 0x26c4	   0 */		.word	0
/* 0x26c8	   0 */		.word	0
/* 0x26cc	   0 */		.word	0
/* 0x26d0	   0 */		.word	435
/* 0x26d4	   0 */		.word	0
/* 0x26d8	   0 */		.word	0
/* 0x26dc	   0 */		.word	4
/* 0x26e0	   0 */		.word	0
/* 0x26e4	   0 */		.word	0
/* 0x26e8	   0 */		.word	0
/* 0x26ec	   0 */		.word	431
/* 0x26f0	   0 */		.word	6
/* 0x26f4	   0 */		.word	431
/* 0x26f8	   0 */		.word	1
/* 0x26fc	   0 */		.word	431
/* 0x2700	   0 */		.word	0
/* 0x2704	   0 */		.word	0
/* 0x2708	   0 */		.word	0
/* 0x270c	   0 */		.word	0
/* 0x2710	   0 */		.word	0
/* 0x2714	   0 */		.word	0
/* 0x2718	   0 */		.word	431
/* 0x271c	   0 */		.word	2
/* 0x2720	   0 */		.word	2
/* 0x2724	   0 */		.word	4
/* 0x2728	   0 */		.word	0
/* 0x272c	   0 */		.word	0
/* 0x2730	   0 */		.word	0
/* 0x2734	   0 */		.word	439
/* 0x2738	   0 */		.word	6
/* 0x273c	   0 */		.word	439
/* 0x2740	   0 */		.word	1
/* 0x2744	   0 */		.word	439
/* 0x2748	   0 */		.word	0
/* 0x274c	   0 */		.word	0
/* 0x2750	   0 */		.word	0
/* 0x2754	   0 */		.word	0
/* 0x2758	   0 */		.word	0
/* 0x275c	   0 */		.word	0
/* 0x2760	   0 */		.word	439
/* 0x2764	   0 */		.word	2
/* 0x2768	   0 */		.word	2
/* 0x276c	   0 */		.word	4
/* 0x2770	   0 */		.word	0
/* 0x2774	   0 */		.word	0
/* 0x2778	   0 */		.word	0
/* 0x277c	   0 */		.word	447
/* 0x2780	   0 */		.word	6
/* 0x2784	   0 */		.word	447
/* 0x2788	   0 */		.word	1
/* 0x278c	   0 */		.word	447
/* 0x2790	   0 */		.word	0
/* 0x2794	   0 */		.word	0
/* 0x2798	   0 */		.word	0
/* 0x279c	   0 */		.word	0
/* 0x27a0	   0 */		.word	0
/* 0x27a4	   0 */		.word	0
/* 0x27a8	   0 */		.word	447
/* 0x27ac	   0 */		.word	2
/* 0x27b0	   0 */		.word	2
/* 0x27b4	   0 */		.word	4
/* 0x27b8	   0 */		.word	0
/* 0x27bc	   0 */		.word	0
/* 0x27c0	   0 */		.word	0
/* 0x27c4	   0 */		.word	455
/* 0x27c8	   0 */		.word	6
/* 0x27cc	   0 */		.word	455
/* 0x27d0	   0 */		.word	1
/* 0x27d4	   0 */		.word	455
/* 0x27d8	   0 */		.word	0
/* 0x27dc	   0 */		.word	0
/* 0x27e0	   0 */		.word	0
/* 0x27e4	   0 */		.word	0
/* 0x27e8	   0 */		.word	0
/* 0x27ec	   0 */		.word	0
/* 0x27f0	   0 */		.word	455
/* 0x27f4	   0 */		.word	2
/* 0x27f8	   0 */		.word	2
/* 0x27fc	   0 */		.word	4
/* 0x2800	   0 */		.word	0
/* 0x2804	   0 */		.word	0
/* 0x2808	   0 */		.word	0
/* 0x280c	   0 */		.word	463
/* 0x2810	   0 */		.word	6
/* 0x2814	   0 */		.word	463
/* 0x2818	   0 */		.word	1
/* 0x281c	   0 */		.word	463
/* 0x2820	   0 */		.word	0
/* 0x2824	   0 */		.word	0
/* 0x2828	   0 */		.word	0
/* 0x282c	   0 */		.word	0
/* 0x2830	   0 */		.word	0
/* 0x2834	   0 */		.word	0
/* 0x2838	   0 */		.word	463
/* 0x283c	   0 */		.word	2
/* 0x2840	   0 */		.word	2
/* 0x2844	   0 */		.word	4
/* 0x2848	   0 */		.word	0
/* 0x284c	   0 */		.word	0
/* 0x2850	   0 */		.word	0
/* 0x2854	   0 */		.word	471
/* 0x2858	   0 */		.word	6
/* 0x285c	   0 */		.word	471
/* 0x2860	   0 */		.word	1
/* 0x2864	   0 */		.word	471
/* 0x2868	   0 */		.word	0
/* 0x286c	   0 */		.word	0
/* 0x2870	   0 */		.word	0
/* 0x2874	   0 */		.word	0
/* 0x2878	   0 */		.word	0
/* 0x287c	   0 */		.word	0
/* 0x2880	   0 */		.word	471
/* 0x2884	   0 */		.word	2
/* 0x2888	   0 */		.word	2
/* 0x288c	   0 */		.word	4
/* 0x2890	   0 */		.word	0
/* 0x2894	   0 */		.word	0
/* 0x2898	   0 */		.word	0
/* 0x289c	   0 */		.word	479
/* 0x28a0	   0 */		.word	6
/* 0x28a4	   0 */		.word	479
/* 0x28a8	   0 */		.word	1
/* 0x28ac	   0 */		.word	479
/* 0x28b0	   0 */		.word	0
/* 0x28b4	   0 */		.word	0
/* 0x28b8	   0 */		.word	0
/* 0x28bc	   0 */		.word	0
/* 0x28c0	   0 */		.word	0
/* 0x28c4	   0 */		.word	0
/* 0x28c8	   0 */		.word	479
/* 0x28cc	   0 */		.word	2
/* 0x28d0	   0 */		.word	2
/* 0x28d4	   0 */		.word	4
/* 0x28d8	   0 */		.word	0
/* 0x28dc	   0 */		.word	0
/* 0x28e0	   0 */		.word	0
/* 0x28e4	   0 */		.word	487
/* 0x28e8	   0 */		.word	6
/* 0x28ec	   0 */		.word	487
/* 0x28f0	   0 */		.word	1
/* 0x28f4	   0 */		.word	487
/* 0x28f8	   0 */		.word	0
/* 0x28fc	   0 */		.word	0
/* 0x2900	   0 */		.word	0
/* 0x2904	   0 */		.word	0
/* 0x2908	   0 */		.word	0
/* 0x290c	   0 */		.word	0
/* 0x2910	   0 */		.word	487
/* 0x2914	   0 */		.word	2
/* 0x2918	   0 */		.word	2
/* 0x291c	   0 */		.word	4
/* 0x2920	   0 */		.word	0
/* 0x2924	   0 */		.word	0
/* 0x2928	   0 */		.word	0
/* 0x292c	   0 */		.word	499
/* 0x2930	   0 */		.word	232
/* 0x2934	   0 */		.word	503
/* 0x2938	   0 */		.word	503
/* 0x293c	   0 */		.word	1
/* 0x2940	   0 */		.word	503
/* 0x2944	   0 */		.word	2
/* 0x2948	   0 */		.word	503
/* 0x294c	   0 */		.word	0
/* 0x2950	   0 */		.word	0
/* 0x2954	   0 */		.word	0
/* 0x2958	   0 */		.word	0
/* 0x295c	   0 */		.word	0
/* 0x2960	   0 */		.word	0
/* 0x2964	   0 */		.word	503
/* 0x2968	   0 */		.word	0
/* 0x296c	   0 */		.word	1
/* 0x2970	   0 */		.word	3
/* 0x2974	   0 */		.word	0
/* 0x2978	   0 */		.word	0
/* 0x297c	   0 */		.word	0
/* 0x2980	   0 */		.word	59
/* 0x2984	   0 */		.word	331
/* 0x2988	   0 */		.word	75
/* 0x298c	   0 */		.word	91
/* 0x2990	   0 */		.word	345
/* 0x2994	   0 */		.word	366
/* 0x2998	   0 */		.word	380
/* 0x299c	   0 */		.word	399
/* 0x29a0	   0 */		.word	345
/* 0x29a4	   0 */		.word	366
/* 0x29a8	   0 */		.word	380
/* 0x29ac	   0 */		.word	399
/* 0x29b0	   0 */		.word	507
/* 0x29b4	   0 */		.word	507
/* 0x29b8	   0 */		.word	151
/* 0x29bc	   0 */		.word	0
/* 0x29c0	   0 */		.word	1
/* 0x29c4	   0 */		.word	151
/* 0x29c8	   0 */		.word	147
/* 0x29cc	   0 */		.word	532
/* 0x29d0	   0 */		.word	165
/* 0x29d4	   0 */		.word	0
/* 0x29d8	   0 */		.word	1
/* 0x29dc	   0 */		.word	165
/* 0x29e0	   0 */		.word	104
/* 0x29e4	   0 */		.word	536
/* 0x29e8	   0 */		.word	540
/* 0x29ec	   0 */		.word	543
/* 0x29f0	   0 */		.word	546
/* 0x29f4	   0 */		.word	540
/* 0x29f8	   0 */		.word	10
/* 0x29fc	   0 */		.word	549
/* 0x2a00	   0 */		.word	543
/* 0x2a04	   0 */		.word	10
/* 0x2a08	   0 */		.word	553
/* 0x2a0c	   0 */		.word	546
/* 0x2a10	   0 */		.word	10
/* 0x2a14	   0 */		.word	557
/* 0x2a18	   0 */		.word	536
/* 0x2a1c	   0 */		.word	10
/* 0x2a20	   0 */		.word	561
/* 0x2a24	   0 */		.word	217
/* 0x2a28	   0 */		.word	2
/* 0x2a2c	   0 */		.word	565
/* 0x2a30	   0 */		.word	569
/* 0x2a34	   0 */		.word	549
/* 0x2a38	   0 */		.word	1
/* 0x2a3c	   0 */		.word	549
/* 0x2a40	   0 */		.word	2
/* 0x2a44	   0 */		.word	549
/* 0x2a48	   0 */		.word	0
/* 0x2a4c	   0 */		.word	0
/* 0x2a50	   0 */		.word	0
/* 0x2a54	   0 */		.word	0
/* 0x2a58	   0 */		.word	0
/* 0x2a5c	   0 */		.word	0
/* 0x2a60	   0 */		.word	549
/* 0x2a64	   0 */		.word	0
/* 0x2a68	   0 */		.word	1
/* 0x2a6c	   0 */		.word	3
/* 0x2a70	   0 */		.word	0
/* 0x2a74	   0 */		.word	0
/* 0x2a78	   0 */		.word	0
/* 0x2a7c	   0 */		.word	540
/* 0x2a80	   0 */		.word	569
/* 0x2a84	   0 */		.word	232
/* 0x2a88	   0 */		.word	573
/* 0x2a8c	   0 */		.word	573
/* 0x2a90	   0 */		.word	1
/* 0x2a94	   0 */		.word	573
/* 0x2a98	   0 */		.word	2
/* 0x2a9c	   0 */		.word	573
/* 0x2aa0	   0 */		.word	0
/* 0x2aa4	   0 */		.word	0
/* 0x2aa8	   0 */		.word	0
/* 0x2aac	   0 */		.word	0
/* 0x2ab0	   0 */		.word	0
/* 0x2ab4	   0 */		.word	0
/* 0x2ab8	   0 */		.word	573
/* 0x2abc	   0 */		.word	0
/* 0x2ac0	   0 */		.word	1
/* 0x2ac4	   0 */		.word	3
/* 0x2ac8	   0 */		.word	0
/* 0x2acc	   0 */		.word	0
/* 0x2ad0	   0 */		.word	0
/* 0x2ad4	   0 */		.word	577
/* 0x2ad8	   0 */		.word	311
/* 0x2adc	   0 */		.word	59
/* 0x2ae0	   0 */		.word	331
/* 0x2ae4	   0 */		.word	75
/* 0x2ae8	   0 */		.word	91
/* 0x2aec	   0 */		.word	345
/* 0x2af0	   0 */		.word	366
/* 0x2af4	   0 */		.word	380
/* 0x2af8	   0 */		.word	399
/* 0x2afc	   0 */		.word	345
/* 0x2b00	   0 */		.word	366
/* 0x2b04	   0 */		.word	380
/* 0x2b08	   0 */		.word	399
/* 0x2b0c	   0 */		.word	151
/* 0x2b10	   0 */		.word	0
/* 0x2b14	   0 */		.word	1
/* 0x2b18	   0 */		.word	151
/* 0x2b1c	   0 */		.word	147
/* 0x2b20	   0 */		.word	595
/* 0x2b24	   0 */		.word	165
/* 0x2b28	   0 */		.word	0
/* 0x2b2c	   0 */		.word	1
/* 0x2b30	   0 */		.word	165
/* 0x2b34	   0 */		.word	104
/* 0x2b38	   0 */		.word	599
/* 0x2b3c	   0 */		.word	599
/* 0x2b40	   0 */		.word	10
/* 0x2b44	   0 */		.word	603
/* 0x2b48	   0 */		.word	194
/* 0x2b4c	   0 */		.word	2
/* 0x2b50	   0 */		.word	607
/* 0x2b54	   0 */		.word	611
/* 0x2b58	   0 */		.word	194
/* 0x2b5c	   0 */		.word	2
/* 0x2b60	   0 */		.word	615
/* 0x2b64	   0 */		.word	619
/* 0x2b68	   0 */		.word	194
/* 0x2b6c	   0 */		.word	2
/* 0x2b70	   0 */		.word	623
/* 0x2b74	   0 */		.word	627
/* 0x2b78	   0 */		.word	194
/* 0x2b7c	   0 */		.word	2
/* 0x2b80	   0 */		.word	631
/* 0x2b84	   0 */		.word	635
/* 0x2b88	   0 */		.word	194
/* 0x2b8c	   0 */		.word	2
/* 0x2b90	   0 */		.word	639
/* 0x2b94	   0 */		.word	643
/* 0x2b98	   0 */		.word	194
/* 0x2b9c	   0 */		.word	2
/* 0x2ba0	   0 */		.word	647
/* 0x2ba4	   0 */		.word	651
/* 0x2ba8	   0 */		.word	194
/* 0x2bac	   0 */		.word	2
/* 0x2bb0	   0 */		.word	655
/* 0x2bb4	   0 */		.word	660
/* 0x2bb8	   0 */		.word	194
/* 0x2bbc	   0 */		.word	2
/* 0x2bc0	   0 */		.word	665
/* 0x2bc4	   0 */		.word	670
/* 0x2bc8	   0 */		.word	217
/* 0x2bcc	   0 */		.word	2
/* 0x2bd0	   0 */		.word	675
/* 0x2bd4	   0 */		.word	680
/* 0x2bd8	   0 */		.word	670
/* 0x2bdc	   0 */		.word	3
/* 0x2be0	   0 */		.word	670
/* 0x2be4	   0 */		.word	1
/* 0x2be8	   0 */		.word	670
/* 0x2bec	   0 */		.word	1
/* 0x2bf0	   0 */		.word	1
/* 0x2bf4	   0 */		.word	0
/* 0x2bf8	   0 */		.word	0
/* 0x2bfc	   0 */		.word	0
/* 0x2c00	   0 */		.word	0
/* 0x2c04	   0 */		.word	670
/* 0x2c08	   0 */		.word	0
/* 0x2c0c	   0 */		.word	0
/* 0x2c10	   0 */		.word	4
/* 0x2c14	   0 */		.word	0
/* 0x2c18	   0 */		.word	0
/* 0x2c1c	   0 */		.word	0
/* 0x2c20	   0 */		.word	660
/* 0x2c24	   0 */		.word	3
/* 0x2c28	   0 */		.word	660
/* 0x2c2c	   0 */		.word	1
/* 0x2c30	   0 */		.word	660
/* 0x2c34	   0 */		.word	1
/* 0x2c38	   0 */		.word	1
/* 0x2c3c	   0 */		.word	0
/* 0x2c40	   0 */		.word	0
/* 0x2c44	   0 */		.word	0
/* 0x2c48	   0 */		.word	0
/* 0x2c4c	   0 */		.word	660
/* 0x2c50	   0 */		.word	0
/* 0x2c54	   0 */		.word	0
/* 0x2c58	   0 */		.word	4
/* 0x2c5c	   0 */		.word	0
/* 0x2c60	   0 */		.word	0
/* 0x2c64	   0 */		.word	0
/* 0x2c68	   0 */		.word	651
/* 0x2c6c	   0 */		.word	3
/* 0x2c70	   0 */		.word	651
/* 0x2c74	   0 */		.word	1
/* 0x2c78	   0 */		.word	651
/* 0x2c7c	   0 */		.word	1
/* 0x2c80	   0 */		.word	1
/* 0x2c84	   0 */		.word	0
/* 0x2c88	   0 */		.word	0
/* 0x2c8c	   0 */		.word	0
/* 0x2c90	   0 */		.word	0
/* 0x2c94	   0 */		.word	651
/* 0x2c98	   0 */		.word	0
/* 0x2c9c	   0 */		.word	0
/* 0x2ca0	   0 */		.word	4
/* 0x2ca4	   0 */		.word	0
/* 0x2ca8	   0 */		.word	0
/* 0x2cac	   0 */		.word	0
/* 0x2cb0	   0 */		.word	643
/* 0x2cb4	   0 */		.word	3
/* 0x2cb8	   0 */		.word	643
/* 0x2cbc	   0 */		.word	1
/* 0x2cc0	   0 */		.word	643
/* 0x2cc4	   0 */		.word	1
/* 0x2cc8	   0 */		.word	1
/* 0x2ccc	   0 */		.word	0
/* 0x2cd0	   0 */		.word	0
/* 0x2cd4	   0 */		.word	0
/* 0x2cd8	   0 */		.word	0
/* 0x2cdc	   0 */		.word	643
/* 0x2ce0	   0 */		.word	0
/* 0x2ce4	   0 */		.word	0
/* 0x2ce8	   0 */		.word	4
/* 0x2cec	   0 */		.word	0
/* 0x2cf0	   0 */		.word	0
/* 0x2cf4	   0 */		.word	0
/* 0x2cf8	   0 */		.word	635
/* 0x2cfc	   0 */		.word	3
/* 0x2d00	   0 */		.word	635
/* 0x2d04	   0 */		.word	1
/* 0x2d08	   0 */		.word	635
/* 0x2d0c	   0 */		.word	1
/* 0x2d10	   0 */		.word	1
/* 0x2d14	   0 */		.word	0
/* 0x2d18	   0 */		.word	0
/* 0x2d1c	   0 */		.word	0
/* 0x2d20	   0 */		.word	0
/* 0x2d24	   0 */		.word	635
/* 0x2d28	   0 */		.word	0
/* 0x2d2c	   0 */		.word	0
/* 0x2d30	   0 */		.word	4
/* 0x2d34	   0 */		.word	0
/* 0x2d38	   0 */		.word	0
/* 0x2d3c	   0 */		.word	0
/* 0x2d40	   0 */		.word	627
/* 0x2d44	   0 */		.word	3
/* 0x2d48	   0 */		.word	627
/* 0x2d4c	   0 */		.word	1
/* 0x2d50	   0 */		.word	627
/* 0x2d54	   0 */		.word	1
/* 0x2d58	   0 */		.word	1
/* 0x2d5c	   0 */		.word	0
/* 0x2d60	   0 */		.word	0
/* 0x2d64	   0 */		.word	0
/* 0x2d68	   0 */		.word	0
/* 0x2d6c	   0 */		.word	627
/* 0x2d70	   0 */		.word	0
/* 0x2d74	   0 */		.word	0
/* 0x2d78	   0 */		.word	4
/* 0x2d7c	   0 */		.word	0
/* 0x2d80	   0 */		.word	0
/* 0x2d84	   0 */		.word	0
/* 0x2d88	   0 */		.word	619
/* 0x2d8c	   0 */		.word	3
/* 0x2d90	   0 */		.word	619
/* 0x2d94	   0 */		.word	1
/* 0x2d98	   0 */		.word	619
/* 0x2d9c	   0 */		.word	1
/* 0x2da0	   0 */		.word	1
/* 0x2da4	   0 */		.word	0
/* 0x2da8	   0 */		.word	0
/* 0x2dac	   0 */		.word	0
/* 0x2db0	   0 */		.word	0
/* 0x2db4	   0 */		.word	619
/* 0x2db8	   0 */		.word	0
/* 0x2dbc	   0 */		.word	0
/* 0x2dc0	   0 */		.word	4
/* 0x2dc4	   0 */		.word	0
/* 0x2dc8	   0 */		.word	0
/* 0x2dcc	   0 */		.word	0
/* 0x2dd0	   0 */		.word	611
/* 0x2dd4	   0 */		.word	3
/* 0x2dd8	   0 */		.word	611
/* 0x2ddc	   0 */		.word	1
/* 0x2de0	   0 */		.word	611
/* 0x2de4	   0 */		.word	1
/* 0x2de8	   0 */		.word	1
/* 0x2dec	   0 */		.word	0
/* 0x2df0	   0 */		.word	0
/* 0x2df4	   0 */		.word	0
/* 0x2df8	   0 */		.word	0
/* 0x2dfc	   0 */		.word	611
/* 0x2e00	   0 */		.word	0
/* 0x2e04	   0 */		.word	0
/* 0x2e08	   0 */		.word	4
/* 0x2e0c	   0 */		.word	0
/* 0x2e10	   0 */		.word	0
/* 0x2e14	   0 */		.word	0
/* 0x2e18	   0 */		.word	607
/* 0x2e1c	   0 */		.word	6
/* 0x2e20	   0 */		.word	607
/* 0x2e24	   0 */		.word	1
/* 0x2e28	   0 */		.word	607
/* 0x2e2c	   0 */		.word	0
/* 0x2e30	   0 */		.word	0
/* 0x2e34	   0 */		.word	0
/* 0x2e38	   0 */		.word	0
/* 0x2e3c	   0 */		.word	0
/* 0x2e40	   0 */		.word	0
/* 0x2e44	   0 */		.word	607
/* 0x2e48	   0 */		.word	2
/* 0x2e4c	   0 */		.word	2
/* 0x2e50	   0 */		.word	4
/* 0x2e54	   0 */		.word	0
/* 0x2e58	   0 */		.word	0
/* 0x2e5c	   0 */		.word	0
/* 0x2e60	   0 */		.word	615
/* 0x2e64	   0 */		.word	6
/* 0x2e68	   0 */		.word	615
/* 0x2e6c	   0 */		.word	1
/* 0x2e70	   0 */		.word	615
/* 0x2e74	   0 */		.word	0
/* 0x2e78	   0 */		.word	0
/* 0x2e7c	   0 */		.word	0
/* 0x2e80	   0 */		.word	0
/* 0x2e84	   0 */		.word	0
/* 0x2e88	   0 */		.word	0
/* 0x2e8c	   0 */		.word	615
/* 0x2e90	   0 */		.word	2
/* 0x2e94	   0 */		.word	2
/* 0x2e98	   0 */		.word	4
/* 0x2e9c	   0 */		.word	0
/* 0x2ea0	   0 */		.word	0
/* 0x2ea4	   0 */		.word	0
/* 0x2ea8	   0 */		.word	623
/* 0x2eac	   0 */		.word	6
/* 0x2eb0	   0 */		.word	623
/* 0x2eb4	   0 */		.word	1
/* 0x2eb8	   0 */		.word	623
/* 0x2ebc	   0 */		.word	0
/* 0x2ec0	   0 */		.word	0
/* 0x2ec4	   0 */		.word	0
/* 0x2ec8	   0 */		.word	0
/* 0x2ecc	   0 */		.word	0
/* 0x2ed0	   0 */		.word	0
/* 0x2ed4	   0 */		.word	623
/* 0x2ed8	   0 */		.word	2
/* 0x2edc	   0 */		.word	2
/* 0x2ee0	   0 */		.word	4
/* 0x2ee4	   0 */		.word	0
/* 0x2ee8	   0 */		.word	0
/* 0x2eec	   0 */		.word	0
/* 0x2ef0	   0 */		.word	631
/* 0x2ef4	   0 */		.word	6
/* 0x2ef8	   0 */		.word	631
/* 0x2efc	   0 */		.word	1
/* 0x2f00	   0 */		.word	631
/* 0x2f04	   0 */		.word	0
/* 0x2f08	   0 */		.word	0
/* 0x2f0c	   0 */		.word	0
/* 0x2f10	   0 */		.word	0
/* 0x2f14	   0 */		.word	0
/* 0x2f18	   0 */		.word	0
/* 0x2f1c	   0 */		.word	631
/* 0x2f20	   0 */		.word	2
/* 0x2f24	   0 */		.word	2
/* 0x2f28	   0 */		.word	4
/* 0x2f2c	   0 */		.word	0
/* 0x2f30	   0 */		.word	0
/* 0x2f34	   0 */		.word	0
/* 0x2f38	   0 */		.word	639
/* 0x2f3c	   0 */		.word	6
/* 0x2f40	   0 */		.word	639
/* 0x2f44	   0 */		.word	1
/* 0x2f48	   0 */		.word	639
/* 0x2f4c	   0 */		.word	0
/* 0x2f50	   0 */		.word	0
/* 0x2f54	   0 */		.word	0
/* 0x2f58	   0 */		.word	0
/* 0x2f5c	   0 */		.word	0
/* 0x2f60	   0 */		.word	0
/* 0x2f64	   0 */		.word	639
/* 0x2f68	   0 */		.word	2
/* 0x2f6c	   0 */		.word	2
/* 0x2f70	   0 */		.word	4
/* 0x2f74	   0 */		.word	0
/* 0x2f78	   0 */		.word	0
/* 0x2f7c	   0 */		.word	0
/* 0x2f80	   0 */		.word	647
/* 0x2f84	   0 */		.word	6
/* 0x2f88	   0 */		.word	647
/* 0x2f8c	   0 */		.word	1
/* 0x2f90	   0 */		.word	647
/* 0x2f94	   0 */		.word	0
/* 0x2f98	   0 */		.word	0
/* 0x2f9c	   0 */		.word	0
/* 0x2fa0	   0 */		.word	0
/* 0x2fa4	   0 */		.word	0
/* 0x2fa8	   0 */		.word	0
/* 0x2fac	   0 */		.word	647
/* 0x2fb0	   0 */		.word	2
/* 0x2fb4	   0 */		.word	2
/* 0x2fb8	   0 */		.word	4
/* 0x2fbc	   0 */		.word	0
/* 0x2fc0	   0 */		.word	0
/* 0x2fc4	   0 */		.word	0
/* 0x2fc8	   0 */		.word	655
/* 0x2fcc	   0 */		.word	6
/* 0x2fd0	   0 */		.word	655
/* 0x2fd4	   0 */		.word	1
/* 0x2fd8	   0 */		.word	655
/* 0x2fdc	   0 */		.word	0
/* 0x2fe0	   0 */		.word	0
/* 0x2fe4	   0 */		.word	0
/* 0x2fe8	   0 */		.word	0
/* 0x2fec	   0 */		.word	0
/* 0x2ff0	   0 */		.word	0
/* 0x2ff4	   0 */		.word	655
/* 0x2ff8	   0 */		.word	2
/* 0x2ffc	   0 */		.word	2
/* 0x3000	   0 */		.word	4
/* 0x3004	   0 */		.word	0
/* 0x3008	   0 */		.word	0
/* 0x300c	   0 */		.word	0
/* 0x3010	   0 */		.word	665
/* 0x3014	   0 */		.word	6
/* 0x3018	   0 */		.word	665
/* 0x301c	   0 */		.word	1
/* 0x3020	   0 */		.word	665
/* 0x3024	   0 */		.word	0
/* 0x3028	   0 */		.word	0
/* 0x302c	   0 */		.word	0
/* 0x3030	   0 */		.word	0
/* 0x3034	   0 */		.word	0
/* 0x3038	   0 */		.word	0
/* 0x303c	   0 */		.word	665
/* 0x3040	   0 */		.word	2
/* 0x3044	   0 */		.word	2
/* 0x3048	   0 */		.word	4
/* 0x304c	   0 */		.word	0
/* 0x3050	   0 */		.word	0
/* 0x3054	   0 */		.word	0
/* 0x3058	   0 */		.word	680
/* 0x305c	   0 */		.word	232
/* 0x3060	   0 */		.word	685
/* 0x3064	   0 */		.word	685
/* 0x3068	   0 */		.word	1
/* 0x306c	   0 */		.word	685
/* 0x3070	   0 */		.word	2
/* 0x3074	   0 */		.word	685
/* 0x3078	   0 */		.word	0
/* 0x307c	   0 */		.word	0
/* 0x3080	   0 */		.word	0
/* 0x3084	   0 */		.word	0
/* 0x3088	   0 */		.word	0
/* 0x308c	   0 */		.word	0
/* 0x3090	   0 */		.word	685
/* 0x3094	   0 */		.word	0
/* 0x3098	   0 */		.word	1
/* 0x309c	   0 */		.word	3
/* 0x30a0	   0 */		.word	0
/* 0x30a4	   0 */		.word	0
/* 0x30a8	   0 */		.word	0
/* 0x30ac	   0 */		.word	690
/* 0x30b0	   0 */		.word	690
/* 0x30b4	   0 */		.word	709
/* 0x30b8	   0 */		.word	712
/* 0x30bc	   0 */		.word	709
/* 0x30c0	   0 */		.word	716
/* 0x30c4	   0 */		.word	745
/* 0x30c8	   0 */		.word	745
/* 0x30cc	   0 */		.word	4
/* 0x30d0	   0 */		.word	749
/* 0x30d4	   0 */		.word	753
/* 0x30d8	   0 */		.word	757
/* 0x30dc	   0 */		.word	761
/* 0x30e0	   0 */		.word	749
/* 0x30e4	   0 */		.word	765
/* 0x30e8	   0 */		.word	769
/* 0x30ec	   0 */		.word	753
/* 0x30f0	   0 */		.word	757
/* 0x30f4	   0 */		.word	773
/* 0x30f8	   0 */		.word	761
/* 0x30fc	   0 */		.word	773
/* 0x3100	   0 */		.word	765
/* 0x3104	   0 */		.word	690
/* 0x3108	   0 */		.word	690
/* 0x310c	   0 */		.word	709
/* 0x3110	   0 */		.word	769
/* 0x3114	   0 */		.word	4
/* 0x3118	   0 */		.word	769
/* 0x311c	   0 */		.word	4
/* 0x3120	   0 */		.word	769
/* 0x3124	   0 */		.word	0
/* 0x3128	   0 */		.word	0
/* 0x312c	   0 */		.word	4
/* 0x3130	   0 */		.word	0
/* 0x3134	   0 */		.word	0
/* 0x3138	   0 */		.word	0
/* 0x313c	   0 */		.word	769
/* 0x3140	   0 */		.word	0
/* 0x3144	   0 */		.word	4
/* 0x3148	   0 */		.word	6
/* 0x314c	   0 */		.word	0
/* 0x3150	   0 */		.word	0
/* 0x3154	   0 */		.word	0
/* 0x3158	   0 */		.word	777
/* 0x315c	   0 */		.word	780
/* 0x3160	   0 */		.word	777
/* 0x3164	   0 */		.word	10
/* 0x3168	   0 */		.word	784
/* 0x316c	   0 */		.word	777
/* 0x3170	   0 */		.word	784
/* 0x3174	   0 */		.word	1
/* 0x3178	   0 */		.word	784
/* 0x317c	   0 */		.word	4
/* 0x3180	   0 */		.word	784
/* 0x3184	   0 */		.word	0
/* 0x3188	   0 */		.word	0
/* 0x318c	   0 */		.word	1
/* 0x3190	   0 */		.word	0
/* 0x3194	   0 */		.word	0
/* 0x3198	   0 */		.word	0
/* 0x319c	   0 */		.word	784
/* 0x31a0	   0 */		.word	0
/* 0x31a4	   0 */		.word	1
/* 0x31a8	   0 */		.word	3
/* 0x31ac	   0 */		.word	0
/* 0x31b0	   0 */		.word	0
/* 0x31b4	   0 */		.word	0
/* 0x31b8	   0 */		.asciz	"span.c"
/* 0x31bf	   0 */		.asciz	"L1"
/* 0x31c2	   0 */		.asciz	"improved-signed-index"
/* 0x31d8	   0 */		.asciz	"L10"
/* 0x31dc	   0 */		.asciz	"L2"
/* 0x31df	   0 */		.asciz	"gl_fog_index_pixels"
/* 0x31f3	   0 */		.asciz	"gl_scissor_span"
/* 0x3203	   0 */		.asciz	"gl_stencil_span"
/* 0x3213	   0 */		.asciz	"gl_depth_stencil_span"
/* 0x3229	   0 */		.asciz	"gl_logicop_ci_span"
/* 0x323c	   0 */		.asciz	"gl_mask_index_span"
/* 0x324f	   0 */		.asciz	"clip_span"
/* 0x3259	   0 */		.asciz	"L13"
/* 0x325d	   0 */		.asciz	"stipple_polygon_span"
/* 0x3272	   0 */		.asciz	"L12"
/* 0x3276	   0 */		.asciz	"L14"
/* 0x327a	   0 */		.asciz	"memcpy"
/* 0x3281	   0 */		.asciz	"L54"
/* 0x3285	   0 */		.asciz	"L55"
/* 0x3289	   0 */		.asciz	"L56"
/* 0x328d	   0 */		.asciz	"L57"
/* 0x3291	   0 */		.asciz	"memset"
/* 0x3298	   0 */		.asciz	"L58"
/* 0x329c	   0 */		.asciz	"L59"
/* 0x32a0	   0 */		.asciz	"pipelinable-termination-test"
/* 0x32bd	   0 */		.asciz	"L60"
/* 0x32c1	   0 */		.asciz	"L17"
/* 0x32c5	   0 */		.asciz	"L16"
/* 0x32c9	   0 */		.asciz	"L3"
/* 0x32cc	   0 */		.asciz	"L4"
/* 0x32cf	   0 */		.asciz	"L18"
/* 0x32d3	   0 */		.asciz	"L20"
/* 0x32d7	   0 */		.asciz	"L22"
/* 0x32db	   0 */		.asciz	"L61"
/* 0x32df	   0 */		.asciz	"L62"
/* 0x32e3	   0 */		.asciz	"L63"
/* 0x32e7	   0 */		.asciz	"L64"
/* 0x32eb	   0 */		.asciz	"L65"
/* 0x32ef	   0 */		.asciz	"gl_fog_color_pixels"
/* 0x3303	   0 */		.asciz	"gl_alpha_test"
/* 0x3311	   0 */		.asciz	"gl_logicop_rgba_span"
/* 0x3326	   0 */		.asciz	"gl_blend_span"
/* 0x3334	   0 */		.asciz	"gl_mask_color_span"
/* 0x3347	   0 */		.asciz	"gl_write_alpha_span"
/* 0x335b	   0 */		.asciz	"L25"
/* 0x335f	   0 */		.asciz	"L24"
/* 0x3363	   0 */		.asciz	"L26"
/* 0x3367	   0 */		.asciz	"L66"
/* 0x336b	   0 */		.asciz	"L67"
/* 0x336f	   0 */		.asciz	"L68"
/* 0x3373	   0 */		.asciz	"L69"
/* 0x3377	   0 */		.asciz	"L70"
/* 0x337b	   0 */		.asciz	"L71"
/* 0x337f	   0 */		.asciz	"L72"
/* 0x3383	   0 */		.asciz	"L73"
/* 0x3387	   0 */		.asciz	"L74"
/* 0x338b	   0 */		.asciz	"L75"
/* 0x338f	   0 */		.asciz	"L76"
/* 0x3393	   0 */		.asciz	"L77"
/* 0x3397	   0 */		.asciz	"L78"
/* 0x339b	   0 */		.asciz	"L79"
/* 0x339f	   0 */		.asciz	"L80"
/* 0x33a3	   0 */		.asciz	"L81"
/* 0x33a7	   0 */		.asciz	"L82"
/* 0x33ab	   0 */		.asciz	"L83"
/* 0x33af	   0 */		.asciz	"L84"
/* 0x33b3	   0 */		.asciz	"gl_write_mono_alpha_span"
/* 0x33cc	   0 */		.asciz	"L29"
/* 0x33d0	   0 */		.asciz	"L28"
/* 0x33d4	   0 */		.asciz	"L5"
/* 0x33d7	   0 */		.asciz	"L6"
/* 0x33da	   0 */		.asciz	"L7"
/* 0x33dd	   0 */		.asciz	"L30"
/* 0x33e1	   0 */		.asciz	"L32"
/* 0x33e5	   0 */		.asciz	"L34"
/* 0x33e9	   0 */		.asciz	"L36"
/* 0x33ed	   0 */		.asciz	"L85"
/* 0x33f1	   0 */		.asciz	"L86"
/* 0x33f5	   0 */		.asciz	"L87"
/* 0x33f9	   0 */		.asciz	"gl_texture_pixels"
/* 0x340b	   0 */		.asciz	"L39"
/* 0x340f	   0 */		.asciz	"L38"
/* 0x3413	   0 */		.asciz	"L40"
/* 0x3417	   0 */		.asciz	"L88"
/* 0x341b	   0 */		.asciz	"L89"
/* 0x341f	   0 */		.asciz	"L90"
/* 0x3423	   0 */		.asciz	"L91"
/* 0x3427	   0 */		.asciz	"L92"
/* 0x342b	   0 */		.asciz	"L93"
/* 0x342f	   0 */		.asciz	"L94"
/* 0x3433	   0 */		.asciz	"L95"
/* 0x3437	   0 */		.asciz	"L96"
/* 0x343b	   0 */		.asciz	"L97"
/* 0x343f	   0 */		.asciz	"L98"
/* 0x3443	   0 */		.asciz	"L99"
/* 0x3447	   0 */		.asciz	"L100"
/* 0x344c	   0 */		.asciz	"L101"
/* 0x3451	   0 */		.asciz	"L102"
/* 0x3456	   0 */		.asciz	"L103"
/* 0x345b	   0 */		.asciz	"L104"
/* 0x3460	   0 */		.asciz	"L105"
/* 0x3465	   0 */		.asciz	"L106"
/* 0x346a	   0 */		.asciz	"gl_read_alpha_span"
/* 0x347d	   0 */		.asciz	"L8"
/* 0x3480	   0 */		.asciz	"L42"
/* 0x3484	   0 */		.asciz	"dynamic-alias-disambiguation"
/* 0x34a1	   0 */		.asciz	"L43"
/* 0x34a5	   0 */		.asciz	"L45"
/* 0x34a9	   0 */		.asciz	"L46"
/* 0x34ad	   0 */		.asciz	"L47"
/* 0x34b1	   0 */		.asciz	"L48"
/* 0x34b5	   0 */		.asciz	"L50"
/* 0x34b9	   0 */		.asciz	"L51"
/* 0x34bd	   0 */		.asciz	"L49"
/* 0x34c1	   0 */		.asciz	"L9"
/* 0x34c4	   0 */		.asciz	"L52"
/* 0x34c8	   0 */		.asciz	"L53"

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
!   reloc[1]: knd=2, off=248, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=277, siz=4, lab1=stipple_polygon_span, lab2=, loff=0
!   reloc[3]: knd=0, off=281, siz=4, lab1=stipple_polygon_span, lab2=, loff=224
!   reloc[4]: knd=0, off=38195, siz=4, lab1=clip_span, lab2=, loff=0
!   reloc[5]: knd=0, off=38199, siz=4, lab1=clip_span, lab2=, loff=200
!   reloc[6]: knd=0, off=38319, siz=4, lab1=gl_write_index_span, lab2=, loff=0
!   reloc[7]: knd=0, off=38323, siz=4, lab1=gl_write_index_span, lab2=, loff=2036
!   reloc[8]: knd=0, off=38541, siz=4, lab1=gl_write_monoindex_span, lab2=, loff=0
!   reloc[9]: knd=0, off=38545, siz=4, lab1=gl_write_monoindex_span, lab2=, loff=2264
!   reloc[10]: knd=0, off=38819, siz=4, lab1=gl_write_color_span, lab2=, loff=0
!   reloc[11]: knd=0, off=38823, siz=4, lab1=gl_write_color_span, lab2=, loff=5308
!   reloc[12]: knd=0, off=39315, siz=4, lab1=gl_write_monocolor_span, lab2=, loff=0
!   reloc[13]: knd=0, off=39319, siz=4, lab1=gl_write_monocolor_span, lab2=, loff=3348
!   reloc[14]: knd=0, off=39773, siz=4, lab1=gl_write_texture_span, lab2=, loff=0
!   reloc[15]: knd=0, off=39777, siz=4, lab1=gl_write_texture_span, lab2=, loff=5380
!   reloc[16]: knd=0, off=40329, siz=4, lab1=gl_read_color_span, lab2=, loff=0
!   reloc[17]: knd=0, off=40333, siz=4, lab1=gl_read_color_span, lab2=, loff=852
!   reloc[18]: knd=0, off=40501, siz=4, lab1=gl_read_index_span, lab2=, loff=0
!   reloc[19]: knd=0, off=40505, siz=4, lab1=gl_read_index_span, lab2=, loff=368
	.section ".debug_info"
	.byte 0x00,0x00,0xa2,0xd8,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "span.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  span.c -W0,-xp\\$XAa59JChgJdL26r.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JChgJdL26r.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "stipple_polygon_span\0"
	.byte 0x03,0x01,0x62
	.uaword stipple_polygon_span
	.uaword stipple_polygon_span+224
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0xa5
	.byte 0x03,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x60,0x01,0x58,0x03,0x00,0x00,0x01
	.byte 0xd5
	.ascii "n\0"
	.byte 0x01,0x61,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x61,0x01,0x5a,0x03,0x00,0x00,0x01
	.byte 0xac
	.ascii "y\0"
	.byte 0x01,0x61,0x01,0x5b,0x03,0x00,0x00,0x31
	.byte 0xda
	.ascii "mask\0"
	.byte 0x01,0x61,0x01,0x5c,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x63,0x01
	.byte 0x52,0x04
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x63,0x01
	.byte 0x58,0x04
	.ascii "stipple\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x63,0x01
	.byte 0x55,0x04
	.ascii "highbit\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x63,0x02
	.byte 0x91,0x70,0x05,0x44,0x01,0x04,0x00,0x06
	.ascii "int\0"
	.byte 0x05,0x04,0x07,0x00,0x00,0x01,0xa5
	.ascii "GLint\0"
	.byte 0x03,0x08
	.ascii "HashTable\0"
	.byte 0x01,0x09,0x00,0x00,0x01,0xb8,0x06
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x07,0x00,0x00,0x01,0xc9
	.ascii "GLuint\0"
	.byte 0x03,0x06
	.ascii "float\0"
	.byte 0x04,0x04,0x07,0x00,0x00,0x01,0xe2
	.ascii "GLfloat\0"
	.byte 0x03,0x06
	.ascii "long\0"
	.byte 0x05,0x04,0x0a,0x00,0x00,0x01,0xac,0x10
	.byte 0x00,0x00,0x02,0x12,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0c,0x04,0x03,0x00,0x00
	.byte 0x31,0xae,0x0d
	.ascii "GL_FALSE\0"
	.byte 0x00,0x0d
	.ascii "GL_TRUE\0"
	.byte 0x01,0x0d
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x0d
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x0d
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x0d
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x0d
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x0d
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x0d
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x0d
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x0d
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x0d
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x0d
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x0d
	.ascii "GL_LINES\0"
	.byte 0x01,0x0d
	.ascii "GL_POINTS\0"
	.byte 0x00,0x0d
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x0d
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x0d
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x0d
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x0d
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x0d
	.ascii "GL_QUADS\0"
	.byte 0x07,0x0d
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x0d
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x0d
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x0d
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x0d
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x0d
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x0d
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x0d
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x0d
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x0d
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x0d
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x0d
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x0d
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x0d
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x0d
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x0d
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x0d
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x0d
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x0d
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x0d
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x0d
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x0d
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x0d
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x0d
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x0d
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x0d
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x0d
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x0d
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x0d
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x0d
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x0d
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x0d
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x0d
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x0d
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x0d
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x0d
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x0d
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x0d
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x0d
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x0d
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x0d
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x0d
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x0d
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x0d
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x0d
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x0d
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x0d
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x0d
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x0d
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x0d
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x0d
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x0d
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x0d
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x0d
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x0d
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x0d
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x0d
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x0d
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x0d
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x0d
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x0d
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x0d
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x0d
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x0d
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x0d
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x0d
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x0d
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x0d
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x0d
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x0d
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x0d
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x0d
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x0d
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x0d
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x0d
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x0d
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x0d
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x0d
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x0d
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x0d
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x0d
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x0d
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x0d
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x0d
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x0d
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x0d
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x0d
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x0d
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x0d
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x0d
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x0d
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x0d
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x0d
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x0d
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x0d
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x0d
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x0d
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x0d
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x0d
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x0d
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x0d
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x0d
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x0d
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x0d
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x0d
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x0d
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x0d
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x0d
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x0d
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x0d
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x0d
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x0d
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x0d
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x0d
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x0d
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x0d
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x0d
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x0d
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x0d
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x0d
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x0d
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x0d
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x0d
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x0d
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x0d
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x0d
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x0d
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x0d
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x0d
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x0d
	.ascii "GL_ZERO\0"
	.byte 0x00,0x0d
	.ascii "GL_ONE\0"
	.byte 0x01,0x0d
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x0d
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x0d
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x0d
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x0d
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x0d
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x0d
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x0d
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x0d
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x0d
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x0d
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x0d
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x0d
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x0d
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x0d
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x0d
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x0d
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x0d
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x0d
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x0d
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x0d
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x0d
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x0d
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x0d
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x0d
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x0d
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x0d
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x0d
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x0d
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x0d
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x0d
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x0d
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x0d
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x0d
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x0d
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x0d
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x0d
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x0d
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x0d
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x0d
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x0d
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x0d
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x0d
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0d
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x0d
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x0d
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x0d
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x0d
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x0d
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x0d
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x0d
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x0d
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x0d
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x0d
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x0d
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x0d
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x0d
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x0d
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x0d
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x0d
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x0d
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x0d
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x0d
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x0d
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x0d
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x0d
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x0d
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x0d
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x0d
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x0d
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x0d
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x0d
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x0d
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x0d
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x0d
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x0d
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x0d
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x0d
	.ascii "GL_NONE\0"
	.byte 0x00,0x0d
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x0d
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x0d
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x0d
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x0d
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x0d
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x0d
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x0d
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x0d
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x0d
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x0d
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x0d
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x0d
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x0d
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x0d
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x0d
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x0d
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x0d
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x0d
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x0d
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x0d
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x0d
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x0d
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x0d
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x0d
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x0d
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x0d
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x0d
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x0d
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x0d
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x0d
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x0d
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x0d
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x0d
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x0d
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x0d
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x0d
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x0d
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x0d
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x0d
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x0d
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x0d
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x0d
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x0d
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x0d
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x0d
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x0d
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x0d
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x0d
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x0d
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x0d
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x0d
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x0d
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x0d
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x0d
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x0d
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x0d
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x0d
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x0d
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x0d
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x0d
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x0d
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x0d
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x0d
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x0d
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x0d
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x0d
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x0d
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x0d
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x0d
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x0d
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x0d
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x0d
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x0d
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x0d
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x0d
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x0d
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x0d
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x0d
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x0d
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x0d
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x0d
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x0d
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x0d
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x0d
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x0d
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x0d
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x0d
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x0d
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x0d
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x0d
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x0d
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x0d
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x0d
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x0d
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x0d
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x0d
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x0d
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x0d
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x0d
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x0d
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x0d
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x0d
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x0d
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x0d
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x0d
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x0d
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x0d
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x0d
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x0d
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x0d
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x0d
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x0d
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x0d
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x0d
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x0d
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x0d
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x0d
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x0d
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x0d
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x0d
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x0d
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x0d
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x0d
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x0d
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x0d
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x0d
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x0d
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x0d
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x0d
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x0d
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x0d
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x0d
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x0d
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x0d
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x0d
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x0d
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x0d
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x0d
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x0d
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x0d
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x0d
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x0d
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x0d
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x0d
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x0d
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x0d
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x0d
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x0d
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x0d
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x0d
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x0d
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x0d
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x0d
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x0d
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x0d
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x0d
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x0d
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x0d
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x0d
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x0d
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x0d
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x0d
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x0d
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x0d
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x0d
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x0d
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x0d
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x0d
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x0d
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x0d
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x0d
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x0d
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x0d
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x0d
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x0d
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x0d
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x0d
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x0d
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x0d
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x0d
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x0d
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x0d
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x0d
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x0d
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x0d
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x0d
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x0d
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x0d
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x0d
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x0d
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x0d
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x0d
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x0d
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x0d
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x0d
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x0d
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x0d
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x0d
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x0d
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x0d
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x0d
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x0d
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x0d
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x0d
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x0d
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x0d
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x0d
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x0d
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x0d
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x0d
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x0d
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x0d
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x0d
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x0d
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x0d
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x0d
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x0d
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x0d
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x0d
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x0d
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x0d
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x0d
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x0d
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x0d
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x0d
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x0d
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x0d
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x0d
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x0d
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x0d
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x0d
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x0d
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x0d
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x0d
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x0d
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x0d
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x0d
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x0d
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x0d
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x0d
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x0d
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x0d
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x0d
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x0d
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x0d
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x0d
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x0d
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x0d
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x0d
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x0d
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x0d
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x0d
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x0d
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x0d
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x07,0x00,0x00,0x02
	.byte 0x12
	.ascii "GLenum\0"
	.byte 0x03,0x06
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x07,0x00,0x00,0x31,0xbb
	.ascii "GLubyte\0"
	.byte 0x03,0x09,0x00,0x00,0x31,0xcc,0x06
	.ascii "void\0"
	.byte 0x05,0x00,0x09,0x00,0x00,0x31,0xdf,0x0e
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x02,0x00,0x00,0x32,0xf5,0x0f
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "Border\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x08,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x0c,0x0f
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x10,0x0f
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x14,0x0f
	.ascii "Width2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x18,0x0f
	.ascii "Height2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x1c,0x0f
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x20,0x0f
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x24,0x0f
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x28,0x0f
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x2c,0x0f
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x30,0x0f
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0xda,0x02,0x23,0x34,0x0f
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x38,0x00
	.byte 0x09,0x00,0x00,0x31,0xec,0x0a,0x00,0x00
	.byte 0x32,0xf5,0x2c,0x00,0x00,0x33,0x0b,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x0a,0x00,0x10,0x00
	.byte 0x00,0x31,0xcc,0x04,0x00,0x00,0x00,0x33
	.byte 0x1e,0x11,0x00,0x00,0x01,0xf9,0x03,0xff
	.byte 0x00,0x07,0x00,0x00,0x31,0xbb
	.ascii "GLboolean\0"
	.byte 0x03,0x12
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x02,0x00,0x00,0x34,0xbd,0x0f
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "Name\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x04,0x0f
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x08,0x0f
	.ascii "Priority\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x0c,0x0f
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x02,0x01,0x02,0x23,0x10,0x0f
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x20,0x0f
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x24,0x0f
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x28,0x0f
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x2c,0x0f
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x30,0x0f
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x34,0x0f
	.ascii "Image\0"
	.byte 0x00,0x00,0x32,0xfa,0x02,0x23,0x38,0x0f
	.ascii "Palette\0"
	.byte 0x00,0x00,0x33,0x0b,0x02,0x23,0x64,0x0f
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xe4,0x08
	.byte 0x0f
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0xae,0x03,0x23,0xe8,0x08
	.byte 0x0f
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0xae,0x03,0x23,0xec,0x08
	.byte 0x0f
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xf0,0x08
	.byte 0x0f
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0xe7,0x03,0x23,0xf4,0x08
	.byte 0x0f
	.ascii "Complete\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xf8,0x08
	.byte 0x0f
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x35,0x33,0x03,0x23,0xfc,0x08
	.byte 0x0f
	.ascii "Next\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0x80,0x09
	.byte 0x00,0x13,0x00,0x00,0x33,0x2e,0x09,0x00
	.byte 0x00,0x34,0xbd,0x13,0x00,0x00,0x01,0xe2
	.byte 0x09,0x00,0x00,0x34,0xc7,0x13,0x00,0x00
	.byte 0x01,0xe2,0x09,0x00,0x00,0x34,0xd1,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x34
	.byte 0xdb,0x13,0x00,0x00,0x01,0xe2,0x09,0x00
	.byte 0x00,0x34,0xe5,0x09,0x00,0x00,0x31,0xbb
	.byte 0x14,0x01,0x01,0x00,0x00,0x35,0x2e,0x15
	.byte 0x00,0x00,0x34,0xc2,0x15,0x00,0x00,0x01
	.byte 0xc9,0x15,0x00,0x00,0x34,0xcc,0x15,0x00
	.byte 0x00,0x34,0xd6,0x15,0x00,0x00,0x34,0xe0
	.byte 0x15,0x00,0x00,0x34,0xea,0x15,0x00,0x00
	.byte 0x34,0xef,0x15,0x00,0x00,0x34,0xef,0x15
	.byte 0x00,0x00,0x34,0xef,0x15,0x00,0x00,0x34
	.byte 0xef,0x00,0x09,0x00,0x00,0x34,0xf4,0x07
	.byte 0x00,0x00,0x35,0x2e
	.ascii "TextureSampleFunc\0"
	.byte 0x02,0x09,0x00,0x00,0x33,0x2e,0x0e
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x02,0x00,0x00,0x35,0xec,0x0f
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x01,0xc4,0x02,0x23,0x04,0x0f
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x01,0xc4,0x02,0x23,0x08,0x0f
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x35,0x4b,0x02,0x23,0x0c,0x0f
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x35,0x4b,0x02,0x23,0x10,0x0f
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x35,0x4b,0x02,0x23,0x14,0x0f
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x35,0x4b,0x02,0x23,0x18,0x00
	.byte 0x09,0x00,0x00,0x35,0x50,0x12
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x02,0x00,0x00,0x3c,0xbe,0x0f
	.ascii "Shared\0"
	.byte 0x00,0x00,0x35,0xec,0x02,0x23,0x00,0x0f
	.ascii "API\0"
	.byte 0x00,0x00,0x55,0xa9,0x02,0x23,0x04,0x0f
	.ascii "Save\0"
	.byte 0x00,0x00,0x55,0xa9,0x03,0x23,0xe0,0x05
	.byte 0x0f
	.ascii "Exec\0"
	.byte 0x00,0x00,0x55,0xa9,0x03,0x23,0xbc,0x0b
	.byte 0x0f
	.ascii "Visual\0"
	.byte 0x00,0x00,0x66,0x04,0x03,0x23,0x98,0x11
	.byte 0x0f
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x67,0x38,0x03,0x23,0x9c,0x11
	.byte 0x0f
	.ascii "Driver\0"
	.byte 0x00,0x00,0x70,0x47,0x03,0x23,0xa0,0x11
	.byte 0x0f
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x31,0xe7,0x03,0x23,0xf4,0x12
	.byte 0x0f
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x31,0xe7,0x03,0x23,0xf8,0x12
	.byte 0x0f
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xfc,0x12
	.byte 0x0f
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0x80,0x13
	.byte 0x0f
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x74,0xaf,0x03,0x23,0x84,0x13
	.byte 0x0f
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x74,0xc0,0x03,0x23,0xc4,0x13
	.byte 0x0f
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0x84,0x14
	.byte 0x0f
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x74,0xe2,0x03,0x23,0x88,0x14
	.byte 0x0f
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0x88,0x24
	.byte 0x0f
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0x8c,0x24
	.byte 0x0f
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x74,0xf4,0x03,0x23,0x90,0x24
	.byte 0x0f
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xd0,0x24
	.byte 0x0f
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x75,0x16,0x03,0x23,0xd4,0x24
	.byte 0x0f
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x75,0x39,0x03,0x23,0xd4,0x34
	.byte 0x0f
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xd4,0x36
	.byte 0x0f
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xd8,0x36
	.byte 0x0f
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x75,0x4b,0x03,0x23,0xdc,0x36
	.byte 0x0f
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0x9c,0x37
	.byte 0x0f
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x75,0x6d,0x03,0x23,0xa0,0x37
	.byte 0x0f
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xa0,0x3c
	.byte 0x0f
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xa4,0x3c
	.byte 0x0f
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xa5,0x3c
	.byte 0x0f
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xa8,0x3c
	.byte 0x0f
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x75,0xd3,0x03,0x23,0xac,0x3c
	.byte 0x0f
	.ascii "Accum\0"
	.byte 0x00,0x00,0x75,0xf5,0x03,0x23,0xec,0x3c
	.byte 0x0f
	.ascii "Color\0"
	.byte 0x00,0x00,0x76,0x42,0x03,0x23,0xfc,0x3c
	.byte 0x0f
	.ascii "Current\0"
	.byte 0x00,0x00,0x78,0x57,0x03,0x23,0xd4,0x3d
	.byte 0x0f
	.ascii "Depth\0"
	.byte 0x00,0x00,0x79,0x41,0x03,0x23,0xb4,0x3e
	.byte 0x0f
	.ascii "Eval\0"
	.byte 0x00,0x00,0x79,0x94,0x03,0x23,0xc0,0x3e
	.byte 0x0f
	.ascii "Fog\0"
	.byte 0x00,0x00,0x7c,0x0a,0x03,0x23,0xf8,0x3e
	.byte 0x0f
	.ascii "Hint\0"
	.byte 0x00,0x00,0x7c,0x83,0x03,0x23,0xa0,0x3f
	.byte 0x0f
	.ascii "Light\0"
	.byte 0x00,0x00,0x81,0x8e,0x03,0x23,0xb4,0x3f
	.byte 0x0f
	.ascii "Line\0"
	.byte 0x00,0x00,0x82,0xbe,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0f
	.ascii "List\0"
	.byte 0x00,0x00,0x83,0x37,0x04,0x23,0x94,0xdc
	.byte 0x02,0x0f
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x84,0x1d,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0f
	.ascii "Point\0"
	.byte 0x00,0x00,0x86,0xed,0x04,0x23,0x80,0xad
	.byte 0x03,0x0f
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x87,0x66,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0f
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x88,0x99,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0f
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x88,0xb8,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0f
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x89,0x13,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0f
	.ascii "Texture\0"
	.byte 0x00,0x00,0x8a,0x6d,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0f
	.ascii "Transform\0"
	.byte 0x00,0x00,0x8c,0xcf,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0f
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x8d,0x49,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0f
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0f
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x8d,0xf0,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0f
	.ascii "Array\0"
	.byte 0x00,0x00,0x8e,0x06,0x04,0x23,0xac,0xba
	.byte 0x03,0x0f
	.ascii "Pack\0"
	.byte 0x00,0x00,0x90,0xb1,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0f
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x90,0xb1,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0f
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x92,0x33,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0f
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x93,0xbd,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0f
	.ascii "Select\0"
	.byte 0x00,0x00,0x94,0x32,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0f
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0f
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0f
	.ascii "NewState\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0f
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0f
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0f
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0f
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0f
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0f
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0f
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0f
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x01,0xeb,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0f
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x01,0xeb,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0f
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x01,0xeb,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0f
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0f
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0f
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0f
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0f
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x82,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0f
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0xb5,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0f
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0xeb,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0f
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6e,0x2a,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0f
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6e,0x60,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0f
	.ascii "VB\0"
	.byte 0x00,0x00,0x94,0xf7,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0f
	.ascii "PB\0"
	.byte 0x00,0x00,0x95,0x0b,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0f
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0f
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x09,0x00,0x00,0x35,0xf1,0x14
	.byte 0x01,0x01,0x00,0x00,0x3c,0xda,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x3c,0xc3,0x14,0x01,0x01,0x00,0x00
	.byte 0x3c,0xf6,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x3c,0xdf,0x13
	.byte 0x00,0x00,0x01,0xc9,0x09,0x00,0x00,0x3c
	.byte 0xfb,0x16,0x01,0x00,0x00,0x31,0xbb,0x01
	.byte 0x00,0x00,0x3d,0x25,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x3d,0x00,0x15,0x00,0x00,0x34,0xef
	.byte 0x00,0x09,0x00,0x00,0x3d,0x05,0x14,0x01
	.byte 0x01,0x00,0x00,0x3d,0x3c,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5,0x00
	.byte 0x09,0x00,0x00,0x3d,0x2a,0x14,0x01,0x01
	.byte 0x00,0x00,0x3d,0x53,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x3d,0x41,0x14,0x01,0x01,0x00
	.byte 0x00,0x3d,0x6f,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x01,0xc9,0x00,0x09,0x00,0x00,0x3d,0x58
	.byte 0x07,0x00,0x00,0x31,0xdf
	.ascii "GLvoid\0"
	.byte 0x03,0x09,0x00,0x00,0x3d,0x74,0x0e
	.ascii "gl_image\0"
	.byte 0x24,0x02,0x00,0x00,0x3e,0x23,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x08,0x0f
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x0c,0x0f
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x10,0x0f
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x14,0x0f
	.ascii "Data\0"
	.byte 0x00,0x00,0x3d,0x81,0x02,0x23,0x18,0x0f
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x1c,0x0f
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x20,0x00
	.byte 0x13,0x00,0x00,0x3d,0x86,0x09,0x00,0x00
	.byte 0x3e,0x23,0x14,0x01,0x01,0x00,0x00,0x3e
	.byte 0x5d,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x3e
	.byte 0x28,0x00,0x09,0x00,0x00,0x3e,0x2d,0x14
	.byte 0x01,0x01,0x00,0x00,0x3e,0x83,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x00
	.byte 0x09,0x00,0x00,0x3e,0x62,0x14,0x01,0x01
	.byte 0x00,0x00,0x3e,0x9a,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x3e,0x88,0x14,0x01,0x01,0x00
	.byte 0x00,0x3e,0xb6,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x00,0x09,0x00,0x00,0x3e,0x9f
	.byte 0x14,0x01,0x01,0x00,0x00,0x3e,0xcd,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xc9,0x00,0x09,0x00,0x00,0x3e,0xbb,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x3e
	.byte 0xd2,0x14,0x01,0x01,0x00,0x00,0x3e,0xf8
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x3e,0xd7,0x00,0x09,0x00,0x00
	.byte 0x3e,0xdc,0x14,0x01,0x01,0x00,0x00,0x3f
	.byte 0x0f,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x3e
	.byte 0xfd,0x14,0x01,0x01,0x00,0x00,0x3f,0x35
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x3f,0x14,0x14
	.byte 0x01,0x01,0x00,0x00,0x3f,0x5b,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x00
	.byte 0x09,0x00,0x00,0x3f,0x3a,0x06
	.ascii "double\0"
	.byte 0x04,0x08,0x14,0x01,0x01,0x00,0x00,0x3f
	.byte 0x7c,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x3f,0x60,0x00,0x09,0x00,0x00,0x3f
	.byte 0x6a,0x14,0x01,0x01,0x00,0x00,0x3f,0x93
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xe2,0x00,0x09,0x00,0x00,0x3f,0x81
	.byte 0x14,0x01,0x01
	.byte 0x00,0x00,0x3f,0xaa,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xa5,0x00,0x09
	.byte 0x00,0x00,0x3f,0x98,0x13,0x00,0x00,0x01
	.byte 0xe2,0x09,0x00,0x00,0x3f,0xaf,0x14,0x01
	.byte 0x01,0x00,0x00,0x3f,0xd0,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x3f,0xb4,0x00,0x09,0x00,0x00
	.byte 0x3f,0xb9,0x14,0x01,0x01,0x00,0x00,0x3f
	.byte 0xf1,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x3f,0xd5,0x13,0x00,0x00,0x01,0xe2
	.byte 0x09,0x00,0x00,0x3f,0xf6,0x14,0x01,0x01
	.byte 0x00,0x00,0x40,0x12,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x3f,0xfb,0x00,0x09
	.byte 0x00,0x00,0x40,0x00,0x14,0x01,0x01,0x00
	.byte 0x00,0x40,0x38,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x00,0x09,0x00,0x00
	.byte 0x40,0x17,0x13,0x00,0x00,0x01,0xe2,0x09
	.byte 0x00,0x00,0x40,0x3d,0x14,0x01,0x01,0x00
	.byte 0x00,0x40,0x59,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x40,0x42,0x00,0x09,0x00
	.byte 0x00,0x40,0x47,0x14,0x01,0x01,0x00,0x00
	.byte 0x40,0x7f,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x31,0xbb,0x15,0x00,0x00,0x31
	.byte 0xbb,0x15,0x00,0x00,0x31,0xbb,0x15,0x00
	.byte 0x00,0x31,0xbb,0x00,0x09,0x00,0x00,0x40
	.byte 0x5e,0x13,0x00,0x00,0x31,0xbb,0x09,0x00
	.byte 0x00,0x40,0x84,0x14,0x01,0x01,0x00,0x00
	.byte 0x40,0xa0,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x40,0x89,0x00,0x09,0x00,0x00
	.byte 0x40,0x8e,0x14,0x01,0x01,0x00,0x00,0x40
	.byte 0xc6,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x31,0xbb,0x15,0x00,0x00,0x31,0xbb
	.byte 0x15,0x00,0x00,0x31,0xbb,0x15,0x00,0x00
	.byte 0x31,0xbb,0x00,0x09,0x00,0x00,0x40,0xa5
	.byte 0x14,0x01,0x01,0x00,0x00,0x40,0xe2,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x40,0xcb,0x13,0x00,0x00,0x31
	.byte 0xdf,0x09,0x00,0x00,0x40,0xe7,0x14,0x01
	.byte 0x01,0x00,0x00,0x41,0x12,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x40,0xec,0x00,0x09
	.byte 0x00,0x00,0x40,0xf1,0x09,0x00,0x00,0x3d
	.byte 0x86,0x14,0x01,0x01,0x00,0x00,0x41,0x38
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x41,0x17,0x00,0x09,0x00,0x00
	.byte 0x41,0x1c,0x14,0x01,0x01,0x00,0x00,0x41
	.byte 0x59,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x41,0x17,0x00,0x09,0x00
	.byte 0x00,0x41,0x3d,0x14,0x01,0x01,0x00,0x00
	.byte 0x41,0x84,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x02,0x12
	.byte 0x00,0x09,0x00,0x00,0x41,0x5e,0x14,0x01
	.byte 0x01,0x00,0x00,0x41,0xb9,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x00,0x09,0x00
	.byte 0x00,0x41,0x89,0x14,0x01,0x01,0x00,0x00
	.byte 0x41,0xf3,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x00
	.byte 0x09,0x00,0x00,0x41,0xbe,0x14,0x01,0x01
	.byte 0x00,0x00,0x42,0x23,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x00
	.byte 0x09,0x00,0x00,0x41,0xf8,0x14,0x01,0x01
	.byte 0x00,0x00,0x42,0x5d,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x00,0x09,0x00,0x00,0x42,0x28,0x14
	.byte 0x01,0x01,0x00,0x00,0x42,0x9c,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x00,0x09,0x00,0x00,0x42,0x62,0x14,0x01
	.byte 0x01,0x00,0x00,0x42,0xb3,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x00
	.byte 0x09,0x00,0x00,0x42,0xa1,0x14,0x01,0x01
	.byte 0x00,0x00,0x42,0xcf,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x01,0xa5,0x00,0x09,0x00,0x00,0x42
	.byte 0xb8,0x13,0x00,0x00,0x01,0xc9,0x09,0x00
	.byte 0x00,0x42,0xd4,0x14,0x01,0x01,0x00,0x00
	.byte 0x42,0xf5,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x42
	.byte 0xd9,0x00,0x09,0x00,0x00,0x42,0xde,0x14
	.byte 0x01,0x01,0x00,0x00,0x43,0x0c,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x00,0x09,0x00,0x00,0x42,0xfa,0x14,0x01
	.byte 0x01,0x00,0x00,0x43,0x23,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x31,0xbb,0x00
	.byte 0x09,0x00,0x00,0x43,0x11,0x14,0x01,0x01
	.byte 0x00,0x00,0x43,0x3f,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x3f,0x60,0x15,0x00
	.byte 0x00,0x3f,0x60,0x00,0x09,0x00,0x00,0x43
	.byte 0x28,0x14,0x01,0x01,0x00,0x00,0x43,0x56
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x00,0x09,0x00,0x00,0x43,0x44
	.byte 0x14,0x01,0x01,0x00,0x00,0x43,0x6d,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x00,0x09,0x00,0x00,0x43,0x5b,0x14
	.byte 0x01,0x01,0x00,0x00,0x43,0x8e,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x00,0x09,0x00,0x00,0x43,0x72
	.byte 0x14,0x01,0x01,0x00,0x00,0x43,0xa5,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x00,0x09,0x00,0x00,0x43,0x93,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x43
	.byte 0xaa,0x14,0x01,0x01,0x00,0x00,0x43,0xd5
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x43
	.byte 0xaf,0x00,0x09,0x00,0x00,0x43,0xb4,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x43
	.byte 0xda,0x14,0x01,0x01,0x00,0x00,0x44,0x0a
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x43,0xdf,0x00,0x09
	.byte 0x00,0x00,0x43,0xe4,0x14,0x01,0x01,0x00
	.byte 0x00,0x44,0x21,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x31,0xbb,0x00,0x09,0x00
	.byte 0x00,0x44,0x0f,0x13,0x00,0x00,0x31,0xbb
	.byte 0x09,0x00,0x00,0x44,0x26,0x14,0x01,0x01
	.byte 0x00,0x00,0x44,0x47,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x44,0x2b,0x00,0x09,0x00,0x00,0x44
	.byte 0x30,0x14,0x01,0x01,0x00,0x00,0x44,0x5e
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x00,0x09,0x00,0x00,0x44,0x4c
	.byte 0x14,0x01,0x01,0x00,0x00,0x44,0x75,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x00,0x09,0x00,0x00,0x44,0x63,0x14
	.byte 0x01,0x01,0x00,0x00,0x44,0x87,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x00,0x09,0x00,0x00,0x44
	.byte 0x7a,0x14,0x01,0x01,0x00,0x00,0x44,0x99
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x00,0x09,0x00
	.byte 0x00,0x44,0x8c,0x14,0x01,0x01,0x00,0x00
	.byte 0x44,0xb0,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xe2,0x00,0x09,0x00,0x00
	.byte 0x44,0x9e,0x14,0x01,0x01,0x00,0x00,0x44
	.byte 0xcc,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x00,0x09,0x00,0x00,0x44,0xb5,0x14,0x01
	.byte 0x01,0x00,0x00,0x44,0xed,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x00,0x09,0x00,0x00,0x44,0xd1,0x14
	.byte 0x01,0x01,0x00,0x00,0x45,0x18,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x00,0x09,0x00,0x00
	.byte 0x44,0xf2,0x14,0x01,0x01,0x00,0x00,0x45
	.byte 0x2f,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xa5,0x00,0x09,0x00,0x00,0x45
	.byte 0x1d,0x14,0x01,0x01,0x00,0x00,0x45,0x4b
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x00
	.byte 0x09,0x00,0x00,0x45,0x34,0x09,0x00,0x00
	.byte 0x01,0xe2,0x14,0x01,0x01,0x00,0x00,0x45
	.byte 0x71,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x45,0x50,0x00,0x09,0x00
	.byte 0x00,0x45,0x55,0x14,0x01,0x01,0x00,0x00
	.byte 0x45,0x83,0x15,0x00,0x00,0x3c,0xbe,0x00
	.byte 0x09,0x00,0x00,0x45,0x76,0x14,0x01,0x01
	.byte 0x00,0x00,0x45,0x95,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x00,0x09,0x00,0x00,0x45,0x88,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x45
	.byte 0x9a,0x14,0x01,0x01,0x00,0x00,0x45,0xbb
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x45,0x9f,0x00
	.byte 0x09,0x00,0x00,0x45,0xa4,0x14,0x01,0x01
	.byte 0x00,0x00,0x45,0xd2,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x45,0xc0,0x14,0x01,0x01,0x00
	.byte 0x00,0x46,0x02,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x3f,0x60,0x15,0x00,0x00
	.byte 0x3f,0x60,0x15,0x00,0x00,0x3f,0x60,0x15
	.byte 0x00,0x00,0x3f,0x60,0x15,0x00,0x00,0x3f
	.byte 0x60,0x15,0x00,0x00,0x3f,0x60,0x00,0x09
	.byte 0x00,0x00,0x45,0xd7,0x16,0x01,0x00,0x00
	.byte 0x01,0xc9,0x01,0x00,0x00,0x46,0x1d,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xa5,0x00,0x09,0x00,0x00,0x46,0x07,0x09
	.byte 0x00,0x00,0x01,0xc9,0x14,0x01,0x01,0x00
	.byte 0x00,0x46,0x3e,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x46,0x22,0x00,0x09,0x00,0x00,0x46,0x27
	.byte 0x14,0x01,0x01,0x00,0x00,0x46,0x5a,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x34,0xef,0x00,0x09
	.byte 0x00,0x00,0x46,0x43,0x09,0x00,0x00,0x3f
	.byte 0x60,0x14,0x01,0x01,0x00,0x00,0x46,0x7b
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x46,0x5f,0x00
	.byte 0x09,0x00,0x00,0x46,0x64,0x14,0x01,0x01
	.byte 0x00,0x00,0x46,0xa1,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x31,0xe7,0x00,0x09,0x00
	.byte 0x00,0x46,0x80,0x09,0x00,0x00,0x01,0xa5
	.byte 0x14,0x01,0x01,0x00,0x00,0x46,0xc7,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x46,0xa6,0x00,0x09,0x00,0x00,0x46
	.byte 0xab,0x14,0x01,0x01,0x00,0x00,0x46,0xe3
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x46,0x5f,0x00
	.byte 0x09,0x00,0x00,0x46,0xcc,0x16,0x01,0x00
	.byte 0x00,0x02,0x12,0x01,0x00,0x00,0x46,0xf9
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x00,0x09,0x00
	.byte 0x00,0x46,0xe8,0x14,0x01,0x01,0x00,0x00
	.byte 0x47,0x15,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x45
	.byte 0x50,0x00,0x09,0x00,0x00,0x46,0xfe,0x14
	.byte 0x01,0x01,0x00,0x00,0x47,0x31,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x46,0xa6,0x00,0x09,0x00
	.byte 0x00,0x47,0x1a,0x13,0x00,0x00,0x31,0xbb
	.byte 0x09,0x00,0x00,0x47,0x36,0x16,0x01,0x00
	.byte 0x00,0x47,0x3b,0x01,0x00,0x00,0x47,0x56
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x00,0x09,0x00,0x00,0x47,0x40
	.byte 0x14,0x01,0x01,0x00,0x00,0x47,0x77,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x45,0x50,0x00,0x09,0x00,0x00,0x47
	.byte 0x5b,0x14,0x01,0x01,0x00,0x00,0x47,0x98
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x46,0xa6,0x00,0x09,0x00,0x00
	.byte 0x47,0x7c,0x14,0x01,0x01,0x00,0x00,0x47
	.byte 0xb9,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x46,0x5f,0x00,0x09,0x00
	.byte 0x00,0x47,0x9d,0x14,0x01,0x01,0x00,0x00
	.byte 0x47,0xda,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x45,0x50,0x00,0x09
	.byte 0x00,0x00,0x47,0xbe,0x14,0x01,0x01,0x00
	.byte 0x00,0x47,0xfb,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x46,0xa6,0x00
	.byte 0x09,0x00,0x00,0x47,0xdf,0x14,0x01,0x01
	.byte 0x00,0x00,0x48,0x1c,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x45,0x50
	.byte 0x00,0x09,0x00,0x00,0x48,0x00,0x14,0x01
	.byte 0x01,0x00,0x00,0x48,0x3d,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x46
	.byte 0xa6,0x00,0x09,0x00,0x00,0x48,0x21,0x14
	.byte 0x01,0x01,0x00,0x00,0x48,0x59,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x45,0x50,0x00,0x09,0x00
	.byte 0x00,0x48,0x42,0x14,0x01,0x01,0x00,0x00
	.byte 0x48,0x75,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x46
	.byte 0x22,0x00,0x09,0x00,0x00,0x48,0x5e,0x06
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x09,0x00,0x00,0x48,0x7a,0x14
	.byte 0x01,0x01,0x00,0x00,0x48,0xa8,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x48,0x8c,0x00,0x09,0x00
	.byte 0x00,0x48,0x91,0x09,0x00,0x00,0x31,0xe7
	.byte 0x14,0x01,0x01,0x00,0x00,0x48,0xc9,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x48,0xad,0x00,0x09
	.byte 0x00,0x00,0x48,0xb2,0x14,0x01,0x01,0x00
	.byte 0x00,0x48,0xe0,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x34,0xef,0x00,0x09,0x00
	.byte 0x00,0x48,0xce,0x13,0x00,0x00,0x01,0xc9
	.byte 0x09,0x00,0x00,0x48,0xe5,0x13,0x00,0x00
	.byte 0x01,0xe2,0x09,0x00,0x00,0x48,0xef,0x14
	.byte 0x01,0x01,0x00,0x00,0x49,0x15,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x48,0xea,0x15,0x00,0x00
	.byte 0x48,0xf4,0x00,0x09,0x00,0x00,0x48,0xf9
	.byte 0x14,0x01,0x01,0x00,0x00,0x49,0x36,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x45,0x50,0x00,0x09,0x00,0x00,0x49
	.byte 0x1a,0x14,0x01,0x01,0x00,0x00,0x49,0x57
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x46,0xa6,0x00,0x09,0x00,0x00
	.byte 0x49,0x3b,0x14,0x01,0x01,0x00,0x00,0x49
	.byte 0x78,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x46,0x5f,0x00,0x09,0x00
	.byte 0x00,0x49,0x5c,0x14,0x01,0x01,0x00,0x00
	.byte 0x49,0x99,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x45,0x50,0x00,0x09
	.byte 0x00,0x00,0x49,0x7d,0x14,0x01,0x01,0x00
	.byte 0x00,0x49,0xba,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x46,0xa6,0x00
	.byte 0x09,0x00,0x00,0x49,0x9e,0x14,0x01,0x01
	.byte 0x00,0x00,0x49,0xe5,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x31,0xe7,0x00,0x09,0x00,0x00,0x49,0xbf
	.byte 0x14,0x01,0x01,0x00,0x00,0x4a,0x0b,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x45,0x50
	.byte 0x00,0x09,0x00,0x00,0x49,0xea,0x14,0x01
	.byte 0x01,0x00,0x00,0x4a,0x31,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x46,0xa6,0x00,0x09
	.byte 0x00,0x00,0x4a,0x10,0x14,0x01,0x01,0x00
	.byte 0x00,0x4a,0x52,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x45,0x50,0x00
	.byte 0x09,0x00,0x00,0x4a,0x36,0x14,0x01,0x01
	.byte 0x00,0x00,0x4a,0x73,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x46,0xa6
	.byte 0x00,0x09,0x00,0x00,0x4a,0x57,0x14,0x01
	.byte 0x01,0x00,0x00,0x4a,0x8f,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x02,0x12,0x00,0x09,0x00,0x00
	.byte 0x4a,0x78,0x14,0x01,0x01,0x00,0x00,0x4a
	.byte 0xa6,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x4a
	.byte 0x94,0x14,0x01,0x01,0x00,0x00,0x4a,0xbd
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xe2,0x00,0x09,0x00,0x00,0x4a,0xab
	.byte 0x14,0x01,0x01,0x00,0x00,0x4a,0xd4,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xa5,0x00,0x09,0x00,0x00,0x4a,0xc2,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x4a
	.byte 0xd9,0x14,0x01,0x01,0x00,0x00,0x4a,0xff
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x4a,0xde,0x00,0x09,0x00,0x00
	.byte 0x4a,0xe3,0x14,0x01,0x01,0x00,0x00,0x4b
	.byte 0x11,0x15,0x00,0x00,0x3c,0xbe,0x00,0x09
	.byte 0x00,0x00,0x4b,0x04,0x13,0x00,0x00,0x31
	.byte 0xdf,0x09,0x00,0x00,0x4b,0x16,0x14,0x01
	.byte 0x01,0x00,0x00,0x4b,0x3c,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x4b
	.byte 0x1b,0x00,0x09,0x00,0x00,0x4b,0x20,0x16
	.byte 0x01,0x00,0x00,0x31,0xbb,0x01,0x00,0x00
	.byte 0x4b,0x57,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x00,0x09,0x00,0x00
	.byte 0x4b,0x41,0x16,0x01,0x00,0x00,0x31,0xbb
	.byte 0x01,0x00,0x00,0x4b,0x72,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9,0x00
	.byte 0x09,0x00,0x00,0x4b,0x5c,0x16,0x01,0x00
	.byte 0x00,0x31,0xbb,0x01,0x00,0x00,0x4b,0x8d
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x00,0x09,0x00,0x00,0x4b,0x77
	.byte 0x13,0x00,0x00,0x01,0xe2,0x09,0x00,0x00
	.byte 0x4b,0x92,0x14,0x01,0x01,0x00,0x00,0x4b
	.byte 0xb3,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x4b,0x97
	.byte 0x00,0x09,0x00,0x00,0x4b,0x9c,0x13,0x00
	.byte 0x00,0x01,0xe2,0x09,0x00,0x00,0x4b,0xb8
	.byte 0x14,0x01,0x01,0x00,0x00,0x4b,0xe3,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x4b,0xbd,0x15,0x00,0x00,0x01,0xa5
	.byte 0x00,0x09,0x00,0x00,0x4b,0xc2,0x14,0x01
	.byte 0x01,0x00,0x00,0x4b,0xff,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x48,0x7a,0x00,0x09,0x00,0x00
	.byte 0x4b,0xe8,0x14,0x01,0x01,0x00,0x00,0x4c
	.byte 0x16,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x00,0x09,0x00,0x00,0x4c
	.byte 0x04,0x14,0x01,0x01,0x00,0x00,0x4c,0x2d
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x00,0x09,0x00,0x00,0x4c,0x1b
	.byte 0x14,0x01,0x01,0x00,0x00,0x4c,0x3f,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x00,0x09,0x00,0x00
	.byte 0x4c,0x32,0x13,0x00,0x00,0x01,0xe2,0x09
	.byte 0x00,0x00,0x4c,0x44,0x14,0x01,0x01,0x00
	.byte 0x00,0x4c,0x60,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x4c,0x49,0x00,0x09,0x00
	.byte 0x00,0x4c,0x4e,0x14,0x01,0x01,0x00,0x00
	.byte 0x4c,0x77,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xc9,0x00,0x09,0x00,0x00
	.byte 0x4c,0x65,0x14,0x01,0x01,0x00,0x00,0x4c
	.byte 0x8e,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x00,0x09,0x00,0x00,0x4c
	.byte 0x7c,0x13,0x00,0x00,0x01,0xe2,0x09,0x00
	.byte 0x00,0x4c,0x93,0x14,0x01,0x01,0x00,0x00
	.byte 0x4c,0xcd,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x4c,0x98,0x15,0x00,0x00
	.byte 0x31,0xbb,0x00,0x09,0x00,0x00,0x4c,0x9d
	.byte 0x13,0x00,0x00,0x01,0xe2,0x09,0x00,0x00
	.byte 0x4c,0xd2,0x14,0x01,0x01,0x00,0x00,0x4d
	.byte 0x20,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x4c,0xd7
	.byte 0x15,0x00,0x00,0x31,0xbb,0x00,0x09,0x00
	.byte 0x00,0x4c,0xdc,0x14,0x01,0x01,0x00,0x00
	.byte 0x4d,0x41,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x00,0x09
	.byte 0x00,0x00,0x4d,0x25,0x14,0x01,0x01,0x00
	.byte 0x00,0x4d,0x71,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x00,0x09
	.byte 0x00,0x00,0x4d,0x46,0x13,0x00,0x00,0x01
	.byte 0xe2,0x09,0x00,0x00,0x4d,0x76,0x14,0x01
	.byte 0x01,0x00,0x00,0x4d,0x9c,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x4d
	.byte 0x7b,0x00,0x09,0x00,0x00,0x4d,0x80,0x14
	.byte 0x01,0x01,0x00,0x00,0x4d,0xb3,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x00,0x09,0x00,0x00,0x4d,0xa1,0x13,0x00
	.byte 0x00,0x01,0xe2,0x09,0x00,0x00,0x4d,0xb8
	.byte 0x14,0x01,0x01,0x00,0x00,0x4d,0xd4,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x4d
	.byte 0xbd,0x00,0x09,0x00,0x00,0x4d,0xc2,0x14
	.byte 0x01,0x01,0x00,0x00,0x4d,0xf0,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9
	.byte 0x15,0x00,0x00,0x02,0x12,0x00,0x09,0x00
	.byte 0x00,0x4d,0xd9,0x14,0x01,0x01,0x00,0x00
	.byte 0x4e,0x11,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x00,0x09
	.byte 0x00,0x00,0x4d,0xf5,0x13,0x00,0x00,0x01
	.byte 0xe2,0x09,0x00,0x00,0x4e,0x16,0x14,0x01
	.byte 0x01,0x00,0x00,0x4e,0x32,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x4e,0x1b,0x00
	.byte 0x09,0x00,0x00,0x4e,0x20,0x13,0x00,0x00
	.byte 0x31,0xdf,0x09,0x00,0x00,0x4e,0x37,0x14
	.byte 0x01,0x01,0x00,0x00,0x4e,0x5d,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x4e,0x3c,0x00,0x09,0x00,0x00,0x4e,0x41
	.byte 0x14,0x01,0x01,0x00,0x00,0x4e,0x8d,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x3f
	.byte 0x60,0x15,0x00,0x00,0x3f,0x60,0x15,0x00
	.byte 0x00,0x3f,0x60,0x15,0x00,0x00,0x3f,0x60
	.byte 0x15,0x00,0x00,0x3f,0x60,0x15,0x00,0x00
	.byte 0x3f,0x60,0x00,0x09,0x00,0x00,0x4e,0x62
	.byte 0x14,0x01,0x01,0x00,0x00,0x4e,0xa4,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x4e,0x92,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x4e
	.byte 0xa9,0x14,0x01,0x01,0x00,0x00,0x4e,0xcf
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x4e,0xae,0x00,0x09,0x00,0x00
	.byte 0x4e,0xb3,0x14,0x01,0x01,0x00,0x00,0x4e
	.byte 0xeb,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x01,0xa5
	.byte 0x00,0x09,0x00,0x00,0x4e,0xd4,0x14,0x01
	.byte 0x01,0x00,0x00,0x4f,0x07,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xe2,0x00,0x09,0x00,0x00
	.byte 0x4e,0xf0,0x14,0x01,0x01,0x00,0x00,0x4f
	.byte 0x23,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x00,0x09,0x00,0x00,0x4f,0x0c,0x13,0x00
	.byte 0x00,0x01,0xe2,0x09,0x00,0x00,0x4f,0x28
	.byte 0x14,0x01,0x01,0x00,0x00,0x4f,0x49,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x4f,0x2d,0x00,0x09
	.byte 0x00,0x00,0x4f,0x32,0x14,0x01,0x01,0x00
	.byte 0x00,0x4f,0x60,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x4f,0x4e,0x14,0x01,0x01,0x00,0x00
	.byte 0x4f,0x7c,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x02
	.byte 0x12,0x00,0x09,0x00,0x00,0x4f,0x65,0x14
	.byte 0x01,0x01
	.byte 0x00,0x00,0x4f,0x98,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x00,0x09,0x00,0x00,0x4f
	.byte 0x81,0x13,0x00,0x00,0x31,0xbb,0x09,0x00
	.byte 0x00,0x4f,0x9d,0x14,0x01,0x01,0x00,0x00
	.byte 0x4f,0xb9,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x4f,0xa2,0x00,0x09,0x00,0x00
	.byte 0x4f,0xa7,0x14,0x01,0x01,0x00,0x00,0x4f
	.byte 0xcb,0x15,0x00,0x00,0x3c,0xbe,0x00,0x09
	.byte 0x00,0x00,0x4f,0xbe,0x14,0x01,0x01,0x00
	.byte 0x00,0x4f,0xdd,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x00,0x09,0x00,0x00,0x4f,0xd0,0x14,0x01
	.byte 0x01,0x00,0x00,0x4f,0xef,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x00,0x09,0x00,0x00,0x4f,0xe2
	.byte 0x14,0x01,0x01,0x00,0x00,0x50,0x01,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x00,0x09,0x00,0x00
	.byte 0x4f,0xf4,0x14,0x01,0x01,0x00,0x00,0x50
	.byte 0x18,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x50
	.byte 0x06,0x14,0x01,0x01,0x00,0x00,0x50,0x2f
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x00,0x09,0x00,0x00,0x50,0x1d
	.byte 0x14,0x01,0x01,0x00,0x00,0x50,0x41,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x00,0x09,0x00,0x00
	.byte 0x50,0x34,0x14,0x01,0x01,0x00,0x00,0x50
	.byte 0x58,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x50
	.byte 0x46,0x14,0x01,0x01,0x00,0x00,0x50,0x7e
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x50,0x5d,0x14
	.byte 0x01,0x01,0x00,0x00,0x50,0x95,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x00,0x09,0x00,0x00,0x50,0x83,0x14,0x01
	.byte 0x01,0x00,0x00,0x50,0xca,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x31,0xe7,0x00,0x09,0x00
	.byte 0x00,0x50,0x9a,0x14,0x01,0x01,0x00,0x00
	.byte 0x50,0xf0,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x00,0x09,0x00,0x00,0x50
	.byte 0xcf,0x16,0x01,0x00,0x00,0x01,0xa5,0x01
	.byte 0x00,0x00,0x51,0x0b,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x50,0xf5,0x14,0x01,0x01,0x00
	.byte 0x00,0x51,0x31,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x00,0x09,0x00,0x00
	.byte 0x51,0x10,0x14,0x01,0x01,0x00,0x00,0x51
	.byte 0x52,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x51,0x36,0x14,0x01,0x01,0x00,0x00
	.byte 0x51,0x78,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x00,0x09,0x00,0x00,0x51
	.byte 0x57,0x14,0x01,0x01,0x00,0x00,0x51,0x94
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x46,0x22,0x00
	.byte 0x09,0x00,0x00,0x51,0x7d,0x14,0x01,0x01
	.byte 0x00,0x00,0x51,0xab,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x51,0x99,0x14,0x01,0x01,0x00
	.byte 0x00,0x51,0xcc,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xc9,0x00
	.byte 0x09,0x00,0x00,0x51,0xb0,0x14,0x01,0x01
	.byte 0x00,0x00,0x51,0xe3,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x00,0x09
	.byte 0x00,0x00,0x51,0xd1,0x14,0x01,0x01,0x00
	.byte 0x00,0x52,0x04,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x00
	.byte 0x09,0x00,0x00,0x51,0xe8,0x14,0x01,0x01
	.byte 0x00,0x00,0x52,0x20,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x00,0x09,0x00,0x00,0x52
	.byte 0x09,0x14,0x01,0x01,0x00,0x00,0x52,0x46
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x52,0x25,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x52
	.byte 0x4b,0x14,0x01,0x01,0x00,0x00,0x52,0x76
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x52
	.byte 0x50,0x00,0x09,0x00,0x00,0x52,0x55,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x52
	.byte 0x7b,0x14,0x01,0x01,0x00,0x00,0x52,0xa1
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x52,0x80,0x00,0x09,0x00,0x00
	.byte 0x52,0x85,0x13,0x00,0x00,0x01,0xe2,0x09
	.byte 0x00,0x00,0x52,0xa6,0x14,0x01,0x01,0x00
	.byte 0x00,0x52,0xcc,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x52,0xab,0x00
	.byte 0x09,0x00,0x00,0x52,0xb0,0x14,0x01,0x01
	.byte 0x00,0x00,0x53,0x06,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x41
	.byte 0x17,0x00,0x09,0x00,0x00,0x52,0xd1,0x14
	.byte 0x01,0x01,0x00,0x00,0x53,0x45,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x41,0x17
	.byte 0x00,0x09,0x00,0x00,0x53,0x0b,0x14,0x01
	.byte 0x01,0x00,0x00,0x53,0x7a,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x02,0x12
	.byte 0x15,0x00,0x00,0x41,0x17,0x00,0x09,0x00
	.byte 0x00,0x53,0x4a,0x14,0x01,0x01,0x00,0x00
	.byte 0x53,0xb9,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x41,0x17,0x00,0x09,0x00,0x00
	.byte 0x53,0x7f,0x14,0x01,0x01,0x00,0x00,0x53
	.byte 0xfd,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x02,0x12,0x15,0x00,0x00,0x41,0x17
	.byte 0x00,0x09,0x00,0x00,0x53,0xbe,0x14,0x01
	.byte 0x01,0x00,0x00,0x54,0x46,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x41
	.byte 0x17,0x00,0x09,0x00,0x00,0x54,0x02,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x54
	.byte 0x4b,0x14,0x01,0x01,0x00,0x00,0x54,0x71
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x54,0x50,0x00,0x09,0x00,0x00
	.byte 0x54,0x55,0x14,0x01,0x01,0x00,0x00,0x54
	.byte 0x92,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x54,0x76,0x14,0x01,0x01,0x00,0x00
	.byte 0x54,0xae,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x00,0x09,0x00,0x00,0x54,0x97,0x14
	.byte 0x01,0x01,0x00,0x00,0x54,0xcf,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x15,0x00,0x00
	.byte 0x01,0xe2,0x00,0x09,0x00,0x00,0x54,0xb3
	.byte 0x14,0x01,0x01,0x00,0x00,0x54,0xf5,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x00,0x09,0x00,0x00,0x54,0xd4,0x13,0x00
	.byte 0x00,0x01,0xe2,0x09,0x00,0x00,0x54,0xfa
	.byte 0x14,0x01,0x01,0x00,0x00,0x55,0x16,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x54
	.byte 0xff,0x00,0x09,0x00,0x00,0x55,0x04,0x13
	.byte 0x00,0x00,0x31,0xdf,0x09,0x00,0x00,0x55
	.byte 0x1b,0x14,0x01,0x01,0x00,0x00,0x55,0x46
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x55
	.byte 0x20,0x00,0x09,0x00,0x00,0x55,0x25,0x14
	.byte 0x01,0x01,0x00,0x00,0x55,0x6c,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x00
	.byte 0x09,0x00,0x00,0x55,0x4b,0x14,0x01,0x01
	.byte 0x00,0x00,0x55,0x92,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x15,0x00,0x00,0x01,0xe2
	.byte 0x15,0x00,0x00,0x01,0xe2,0x00,0x09,0x00
	.byte 0x00,0x55,0x71,0x14,0x01,0x01,0x00,0x00
	.byte 0x55,0xa4,0x15,0x00,0x00,0x3c,0xbe,0x00
	.byte 0x09,0x00,0x00,0x55,0x97,0x12
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x02,0x00,0x00,0x64,0x4d,0x0f
	.ascii "Accum\0"
	.byte 0x00,0x00,0x3c,0xda,0x02,0x23,0x00,0x0f
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x3c,0xf6,0x02,0x23,0x04,0x0f
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x3d,0x25,0x02,0x23,0x08,0x0f
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x3d,0x3c,0x02,0x23,0x0c,0x0f
	.ascii "Begin\0"
	.byte 0x00,0x00,0x3d,0x53,0x02,0x23,0x10,0x0f
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x3d,0x6f,0x02,0x23,0x14,0x0f
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x3e,0x5d,0x02,0x23,0x18,0x0f
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x3e,0x83,0x02,0x23,0x1c,0x0f
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x3e,0x9a,0x02,0x23,0x20,0x0f
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x3e,0xb6,0x02,0x23,0x24,0x0f
	.ascii "CallList\0"
	.byte 0x00,0x00,0x3e,0xcd,0x02,0x23,0x28,0x0f
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x3e,0xf8,0x02,0x23,0x2c,0x0f
	.ascii "Clear\0"
	.byte 0x00,0x00,0x3f,0x0f,0x02,0x23,0x30,0x0f
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x3f,0x35,0x02,0x23,0x34,0x0f
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x3f,0x5b,0x02,0x23,0x38,0x0f
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x3f,0x7c,0x02,0x23,0x3c,0x0f
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x3f,0x93,0x02,0x23,0x40,0x0f
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x3f,0xaa,0x02,0x23,0x44,0x0f
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x3f,0xd0,0x02,0x23,0x48,0x0f
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x3f,0xf1,0x02,0x23,0x4c,0x0f
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x40,0x12,0x02,0x23,0x50,0x0f
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x40,0x38,0x02,0x23,0x54,0x0f
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x40,0x59,0x02,0x23,0x58,0x0f
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x40,0x7f,0x02,0x23,0x5c,0x0f
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x40,0xa0,0x02,0x23,0x60,0x0f
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x40,0xc6,0x02,0x23,0x64,0x0f
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x40,0xe2,0x02,0x23,0x68,0x0f
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x41,0x12,0x02,0x23,0x6c,0x0f
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x41,0x38,0x02,0x23,0x70,0x0f
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x41,0x59,0x02,0x23,0x74,0x0f
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x41,0x84,0x02,0x23,0x78,0x0f
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x41,0xb9,0x02,0x23,0x7c,0x0f
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x41,0xf3,0x03,0x23,0x80,0x01
	.byte 0x0f
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x42,0x23,0x03,0x23,0x84,0x01
	.byte 0x0f
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x42,0x5d,0x03,0x23,0x88,0x01
	.byte 0x0f
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x42,0x9c,0x03,0x23,0x8c,0x01
	.byte 0x0f
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x42,0xb3,0x03,0x23,0x90,0x01
	.byte 0x0f
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x42,0xcf,0x03,0x23,0x94,0x01
	.byte 0x0f
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x42,0xf5,0x03,0x23,0x98,0x01
	.byte 0x0f
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x43,0x0c,0x03,0x23,0x9c,0x01
	.byte 0x0f
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x43,0x23,0x03,0x23,0xa0,0x01
	.byte 0x0f
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x43,0x3f,0x03,0x23,0xa4,0x01
	.byte 0x0f
	.ascii "Disable\0"
	.byte 0x00,0x00,0x43,0x56,0x03,0x23,0xa8,0x01
	.byte 0x0f
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x43,0x6d,0x03,0x23,0xac,0x01
	.byte 0x0f
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x43,0x8e,0x03,0x23,0xb0,0x01
	.byte 0x0f
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x43,0xa5,0x03,0x23,0xb4,0x01
	.byte 0x0f
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x43,0xd5,0x03,0x23,0xb8,0x01
	.byte 0x0f
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x44,0x0a,0x03,0x23,0xbc,0x01
	.byte 0x0f
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x44,0x21,0x03,0x23,0xc0,0x01
	.byte 0x0f
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x44,0x47,0x03,0x23,0xc4,0x01
	.byte 0x0f
	.ascii "Enable\0"
	.byte 0x00,0x00,0x44,0x5e,0x03,0x23,0xc8,0x01
	.byte 0x0f
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x44,0x75,0x03,0x23,0xcc,0x01
	.byte 0x0f
	.ascii "End\0"
	.byte 0x00,0x00,0x44,0x87,0x03,0x23,0xd0,0x01
	.byte 0x0f
	.ascii "EndList\0"
	.byte 0x00,0x00,0x44,0x99,0x03,0x23,0xd4,0x01
	.byte 0x0f
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x44,0xb0,0x03,0x23,0xd8,0x01
	.byte 0x0f
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x44,0xcc,0x03,0x23,0xdc,0x01
	.byte 0x0f
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x44,0xed,0x03,0x23,0xe0,0x01
	.byte 0x0f
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x45,0x18,0x03,0x23,0xe4,0x01
	.byte 0x0f
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x45,0x2f,0x03,0x23,0xe8,0x01
	.byte 0x0f
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x45,0x4b,0x03,0x23,0xec,0x01
	.byte 0x0f
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x45,0x71,0x03,0x23,0xf0,0x01
	.byte 0x0f
	.ascii "Finish\0"
	.byte 0x00,0x00,0x45,0x83,0x03,0x23,0xf4,0x01
	.byte 0x0f
	.ascii "Flush\0"
	.byte 0x00,0x00,0x45,0x95,0x03,0x23,0xf8,0x01
	.byte 0x0f
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x45,0xbb,0x03,0x23,0xfc,0x01
	.byte 0x0f
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x45,0xd2,0x03,0x23,0x80,0x02
	.byte 0x0f
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x46,0x02,0x03,0x23,0x84,0x02
	.byte 0x0f
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x46,0x1d,0x03,0x23,0x88,0x02
	.byte 0x0f
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x46,0x3e,0x03,0x23,0x8c,0x02
	.byte 0x0f
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x46,0x5a,0x03,0x23,0x90,0x02
	.byte 0x0f
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x46,0x7b,0x03,0x23,0x94,0x02
	.byte 0x0f
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x46,0xa1,0x03,0x23,0x98,0x02
	.byte 0x0f
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x46,0xc7,0x03,0x23,0x9c,0x02
	.byte 0x0f
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x46,0xe3,0x03,0x23,0xa0,0x02
	.byte 0x0f
	.ascii "GetError\0"
	.byte 0x00,0x00,0x46,0xf9,0x03,0x23,0xa4,0x02
	.byte 0x0f
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x47,0x15,0x03,0x23,0xa8,0x02
	.byte 0x0f
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x47,0x31,0x03,0x23,0xac,0x02
	.byte 0x0f
	.ascii "GetString\0"
	.byte 0x00,0x00,0x47,0x56,0x03,0x23,0xb0,0x02
	.byte 0x0f
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x47,0x77,0x03,0x23,0xb4,0x02
	.byte 0x0f
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x47,0x98,0x03,0x23,0xb8,0x02
	.byte 0x0f
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x47,0xb9,0x03,0x23,0xbc,0x02
	.byte 0x0f
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x47,0xda,0x03,0x23,0xc0,0x02
	.byte 0x0f
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x47,0xfb,0x03,0x23,0xc4,0x02
	.byte 0x0f
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x48,0x1c,0x03,0x23,0xc8,0x02
	.byte 0x0f
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x48,0x3d,0x03,0x23,0xcc,0x02
	.byte 0x0f
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x48,0x59,0x03,0x23,0xd0,0x02
	.byte 0x0f
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x48,0x75,0x03,0x23,0xd4,0x02
	.byte 0x0f
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x48,0xa8,0x03,0x23,0xd8,0x02
	.byte 0x0f
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x48,0xc9,0x03,0x23,0xdc,0x02
	.byte 0x0f
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x48,0xe0,0x03,0x23,0xe0,0x02
	.byte 0x0f
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x49,0x15,0x03,0x23,0xe4,0x02
	.byte 0x0f
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x49,0x36,0x03,0x23,0xe8,0x02
	.byte 0x0f
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x49,0x57,0x03,0x23,0xec,0x02
	.byte 0x0f
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x49,0x78,0x03,0x23,0xf0,0x02
	.byte 0x0f
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x49,0x99,0x03,0x23,0xf4,0x02
	.byte 0x0f
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x49,0xba,0x03,0x23,0xf8,0x02
	.byte 0x0f
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x49,0xe5,0x03,0x23,0xfc,0x02
	.byte 0x0f
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x4a,0x0b,0x03,0x23,0x80,0x03
	.byte 0x0f
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x4a,0x31,0x03,0x23,0x84,0x03
	.byte 0x0f
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x4a,0x52,0x03,0x23,0x88,0x03
	.byte 0x0f
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x4a,0x73,0x03,0x23,0x8c,0x03
	.byte 0x0f
	.ascii "Hint\0"
	.byte 0x00,0x00,0x4a,0x8f,0x03,0x23,0x90,0x03
	.byte 0x0f
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x4a,0xa6,0x03,0x23,0x94,0x03
	.byte 0x0f
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x4a,0xbd,0x03,0x23,0x98,0x03
	.byte 0x0f
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x4a,0xd4,0x03,0x23,0x9c,0x03
	.byte 0x0f
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x4a,0xff,0x03,0x23,0xa0,0x03
	.byte 0x0f
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x4b,0x11,0x03,0x23,0xa4,0x03
	.byte 0x0f
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x4b,0x3c,0x03,0x23,0xa8,0x03
	.byte 0x0f
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x4b,0x57,0x03,0x23,0xac,0x03
	.byte 0x0f
	.ascii "IsList\0"
	.byte 0x00,0x00,0x4b,0x72,0x03,0x23,0xb0,0x03
	.byte 0x0f
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x4b,0x8d,0x03,0x23,0xb4,0x03
	.byte 0x0f
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x4b,0xb3,0x03,0x23,0xb8,0x03
	.byte 0x0f
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x4b,0xe3,0x03,0x23,0xbc,0x03
	.byte 0x0f
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x4b,0xff,0x03,0x23,0xc0,0x03
	.byte 0x0f
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x4c,0x16,0x03,0x23,0xc4,0x03
	.byte 0x0f
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x4c,0x2d,0x03,0x23,0xc8,0x03
	.byte 0x0f
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x4c,0x3f,0x03,0x23,0xcc,0x03
	.byte 0x0f
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x4c,0x60,0x03,0x23,0xd0,0x03
	.byte 0x0f
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x4c,0x77,0x03,0x23,0xd4,0x03
	.byte 0x0f
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x4c,0x8e,0x03,0x23,0xd8,0x03
	.byte 0x0f
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x4c,0xcd,0x03,0x23,0xdc,0x03
	.byte 0x0f
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x4d,0x20,0x03,0x23,0xe0,0x03
	.byte 0x0f
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x4d,0x41,0x03,0x23,0xe4,0x03
	.byte 0x0f
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x4d,0x71,0x03,0x23,0xe8,0x03
	.byte 0x0f
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x4d,0x9c,0x03,0x23,0xec,0x03
	.byte 0x0f
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x4d,0xb3,0x03,0x23,0xf0,0x03
	.byte 0x0f
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x4d,0xd4,0x03,0x23,0xf4,0x03
	.byte 0x0f
	.ascii "NewList\0"
	.byte 0x00,0x00,0x4d,0xf0,0x03,0x23,0xf8,0x03
	.byte 0x0f
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x4e,0x11,0x03,0x23,0xfc,0x03
	.byte 0x0f
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x4e,0x32,0x03,0x23,0x80,0x04
	.byte 0x0f
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x4e,0x5d,0x03,0x23,0x84,0x04
	.byte 0x0f
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x4e,0x8d,0x03,0x23,0x88,0x04
	.byte 0x0f
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x4e,0xa4,0x03,0x23,0x8c,0x04
	.byte 0x0f
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x4e,0xcf,0x03,0x23,0x90,0x04
	.byte 0x0f
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x4e,0xeb,0x03,0x23,0x94,0x04
	.byte 0x0f
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x4f,0x07,0x03,0x23,0x98,0x04
	.byte 0x0f
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x4f,0x23,0x03,0x23,0x9c,0x04
	.byte 0x0f
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x4f,0x49,0x03,0x23,0xa0,0x04
	.byte 0x0f
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x4f,0x60,0x03,0x23,0xa4,0x04
	.byte 0x0f
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x4f,0x7c,0x03,0x23,0xa8,0x04
	.byte 0x0f
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x4f,0x98,0x03,0x23,0xac,0x04
	.byte 0x0f
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x4f,0xb9,0x03,0x23,0xb0,0x04
	.byte 0x0f
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x4f,0xcb,0x03,0x23,0xb4,0x04
	.byte 0x0f
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x4f,0xdd,0x03,0x23,0xb8,0x04
	.byte 0x0f
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x4f,0xef,0x03,0x23,0xbc,0x04
	.byte 0x0f
	.ascii "PopName\0"
	.byte 0x00,0x00,0x50,0x01,0x03,0x23,0xc0,0x04
	.byte 0x0f
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x50,0x18,0x03,0x23,0xc4,0x04
	.byte 0x0f
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x50,0x2f,0x03,0x23,0xc8,0x04
	.byte 0x0f
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x50,0x41,0x03,0x23,0xcc,0x04
	.byte 0x0f
	.ascii "PushName\0"
	.byte 0x00,0x00,0x50,0x58,0x03,0x23,0xd0,0x04
	.byte 0x0f
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x50,0x7e,0x03,0x23,0xd4,0x04
	.byte 0x0f
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x50,0x95,0x03,0x23,0xd8,0x04
	.byte 0x0f
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x50,0xca,0x03,0x23,0xdc,0x04
	.byte 0x0f
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x50,0xf0,0x03,0x23,0xe0,0x04
	.byte 0x0f
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x51,0x0b,0x03,0x23,0xe4,0x04
	.byte 0x0f
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x51,0x31,0x03,0x23,0xe8,0x04
	.byte 0x0f
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x51,0x52,0x03,0x23,0xec,0x04
	.byte 0x0f
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x51,0x78,0x03,0x23,0xf0,0x04
	.byte 0x0f
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x51,0x94,0x03,0x23,0xf4,0x04
	.byte 0x0f
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x51,0xab,0x03,0x23,0xf8,0x04
	.byte 0x0f
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x51,0xcc,0x03,0x23,0xfc,0x04
	.byte 0x0f
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x51,0xe3,0x03,0x23,0x80,0x05
	.byte 0x0f
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x52,0x04,0x03,0x23,0x84,0x05
	.byte 0x0f
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x52,0x20,0x03,0x23,0x88,0x05
	.byte 0x0f
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x52,0x46,0x03,0x23,0x8c,0x05
	.byte 0x0f
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x52,0x76,0x03,0x23,0x90,0x05
	.byte 0x0f
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x52,0xa1,0x03,0x23,0x94,0x05
	.byte 0x0f
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x52,0xcc,0x03,0x23,0x98,0x05
	.byte 0x0f
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x53,0x06,0x03,0x23,0x9c,0x05
	.byte 0x0f
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x53,0x45,0x03,0x23,0xa0,0x05
	.byte 0x0f
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x53,0x7a,0x03,0x23,0xa4,0x05
	.byte 0x0f
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x53,0xb9,0x03,0x23,0xa8,0x05
	.byte 0x0f
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x53,0xfd,0x03,0x23,0xac,0x05
	.byte 0x0f
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x54,0x46,0x03,0x23,0xb0,0x05
	.byte 0x0f
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x54,0x71,0x03,0x23,0xb4,0x05
	.byte 0x0f
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x54,0x92,0x03,0x23,0xb8,0x05
	.byte 0x0f
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x54,0xae,0x03,0x23,0xbc,0x05
	.byte 0x0f
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x54,0xcf,0x03,0x23,0xc0,0x05
	.byte 0x0f
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x54,0xf5,0x03,0x23,0xc4,0x05
	.byte 0x0f
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x55,0x16,0x03,0x23,0xc8,0x05
	.byte 0x0f
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x55,0x46,0x03,0x23,0xcc,0x05
	.byte 0x0f
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x55,0x6c,0x03,0x23,0xd0,0x05
	.byte 0x0f
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x55,0x92,0x03,0x23,0xd4,0x05
	.byte 0x0f
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x55,0xa4,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0e
	.ascii "gl_visual\0"
	.byte 0x4c,0x02,0x00,0x00,0x65,0xf5,0x0f
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x01,0x0f
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x04,0x0f
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x08,0x0f
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x0c,0x0f
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x10,0x0f
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x14,0x0f
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x20,0x0f
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x24,0x0f
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x28,0x0f
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x2c,0x0f
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x30,0x0f
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x34,0x0f
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x38,0x0f
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x3c,0x0f
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x40,0x0f
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x44,0x0f
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x48,0x0f
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x49,0x00
	.byte 0x07,0x00,0x00,0x64,0x4d
	.ascii "GLvisual\0"
	.byte 0x02,0x09,0x00,0x00,0x65,0xf5,0x07,0x00
	.byte 0x00,0x48,0x7a
	.ascii "GLdepth\0"
	.byte 0x02,0x09,0x00,0x00,0x66,0x09,0x07,0x00
	.byte 0x00,0x31,0xbb
	.ascii "GLstencil\0"
	.byte 0x02,0x09,0x00,0x00,0x66,0x1c,0x06
	.ascii "short\0"
	.byte 0x05,0x02,0x07,0x00,0x00,0x66,0x31
	.ascii "GLaccum\0"
	.byte 0x02,0x09,0x00,0x00,0x66,0x3a,0x0e
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x02,0x00,0x00,0x67,0x24,0x0f
	.ascii "Visual\0"
	.byte 0x00,0x00,0x66,0x04,0x02,0x23,0x00,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x08,0x0f
	.ascii "Depth\0"
	.byte 0x00,0x00,0x66,0x17,0x02,0x23,0x0c,0x0f
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x66,0x2c,0x02,0x23,0x10,0x0f
	.ascii "Accum\0"
	.byte 0x00,0x00,0x66,0x48,0x02,0x23,0x14,0x0f
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0xda,0x02,0x23,0x18,0x0f
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0xda,0x02,0x23,0x1c,0x0f
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0xda,0x02,0x23,0x20,0x0f
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x24,0x0f
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x28,0x0f
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x2c,0x0f
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x30,0x00
	.byte 0x07,0x00,0x00,0x66,0x4d
	.ascii "GLframebuffer\0"
	.byte 0x02,0x09,0x00,0x00,0x67,0x24,0x06
	.ascii "char\0"
	.byte 0x06,0x01,0x13,0x00,0x00,0x67,0x3d,0x09
	.byte 0x00,0x00,0x67,0x45,0x17,0x01,0x00,0x00
	.byte 0x67,0x4a,0x01,0x09,0x00,0x00,0x67,0x4f
	.byte 0x14,0x01,0x01,0x00,0x00,0x67,0x68,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x00,0x09,0x00,0x00
	.byte 0x67,0x5b,0x14,0x01,0x01,0x00,0x00,0x67
	.byte 0x7f,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x67
	.byte 0x6d,0x14,0x01,0x01,0x00,0x00,0x67,0xa5
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x31,0xbb,0x15,0x00,0x00,0x31,0xbb,0x15
	.byte 0x00,0x00,0x31,0xbb,0x15,0x00,0x00,0x31
	.byte 0xbb,0x00,0x09,0x00,0x00,0x67,0x84,0x14
	.byte 0x01,0x01,0x00,0x00,0x67,0xd0,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x31,0xbb
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x00,0x09,0x00,0x00
	.byte 0x67,0xaa,0x14,0x01,0x01,0x00,0x00,0x67
	.byte 0xe7,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x67
	.byte 0xd5,0x14,0x01,0x01,0x00,0x00,0x68,0x0d
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x31,0xbb,0x15,0x00,0x00,0x31,0xbb,0x15
	.byte 0x00,0x00,0x31,0xbb,0x15,0x00,0x00,0x31
	.byte 0xbb,0x00,0x09,0x00,0x00,0x67,0xec,0x16
	.byte 0x01,0x00,0x00,0x31,0xbb,0x01,0x00,0x00
	.byte 0x68,0x28,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x00,0x09,0x00,0x00
	.byte 0x68,0x12,0x14,0x01,0x01,0x00,0x00,0x68
	.byte 0x44,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x46,0x22,0x15,0x00,0x00,0x46,0x22
	.byte 0x00,0x09,0x00,0x00,0x68,0x2d,0x13,0x00
	.byte 0x00,0x31,0xbb,0x09,0x00,0x00,0x68,0x49
	.byte 0x13,0x00,0x00,0x31,0xbb,0x09,0x00,0x00
	.byte 0x68,0x53,0x13,0x00,0x00,0x31,0xbb,0x09
	.byte 0x00,0x00,0x68,0x5d,0x13,0x00,0x00,0x31
	.byte 0xbb,0x09,0x00,0x00,0x68,0x67,0x13,0x00
	.byte 0x00,0x31,0xbb,0x09,0x00,0x00,0x68,0x71
	.byte 0x14,0x01,0x01,0x00,0x00,0x68,0xb0,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xc9,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x68,0x4e
	.byte 0x15,0x00,0x00,0x68,0x58,0x15,0x00,0x00
	.byte 0x68,0x62,0x15,0x00,0x00,0x68,0x6c,0x15
	.byte 0x00,0x00,0x68,0x76,0x00,0x09,0x00,0x00
	.byte 0x68,0x7b,0x13,0x00,0x00,0x31,0xbb,0x09
	.byte 0x00,0x00,0x68,0xb5,0x14,0x01,0x01,0x00
	.byte 0x00,0x68,0xe0,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xc9,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x68,0xba,0x00,0x09,0x00,0x00
	.byte 0x68,0xbf,0x13,0x00,0x00,0x01,0xa5,0x09
	.byte 0x00,0x00,0x68,0xe5,0x13,0x00,0x00,0x01
	.byte 0xa5,0x09,0x00,0x00,0x68,0xef,0x13,0x00
	.byte 0x00,0x31,0xbb,0x09,0x00,0x00,0x68,0xf9
	.byte 0x13,0x00,0x00,0x31,0xbb,0x09,0x00,0x00
	.byte 0x69,0x03,0x13,0x00,0x00,0x31,0xbb,0x09
	.byte 0x00,0x00,0x69,0x0d,0x13,0x00,0x00,0x31
	.byte 0xbb,0x09,0x00,0x00,0x69,0x17,0x13,0x00
	.byte 0x00,0x31,0xbb,0x09,0x00,0x00,0x69,0x21
	.byte 0x14,0x01,0x01,0x00,0x00,0x69,0x60,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xc9,0x15,0x00,0x00,0x68,0xea,0x15,0x00
	.byte 0x00,0x68,0xf4,0x15,0x00,0x00,0x68,0xfe
	.byte 0x15,0x00,0x00,0x69,0x08,0x15,0x00,0x00
	.byte 0x69,0x12,0x15,0x00,0x00,0x69,0x1c,0x15
	.byte 0x00,0x00,0x69,0x26,0x00,0x09,0x00,0x00
	.byte 0x69,0x2b,0x13,0x00,0x00,0x01,0xa5,0x09
	.byte 0x00,0x00,0x69,0x65,0x13,0x00,0x00,0x01
	.byte 0xa5,0x09,0x00,0x00,0x69,0x6f,0x13,0x00
	.byte 0x00,0x31,0xbb,0x09,0x00,0x00,0x69,0x79
	.byte 0x14,0x01,0x01,0x00,0x00,0x69,0xa4,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xc9,0x15,0x00,0x00,0x69,0x6a,0x15,0x00
	.byte 0x00,0x69,0x74,0x15,0x00,0x00,0x69,0x7e
	.byte 0x00,0x09,0x00,0x00,0x69,0x83,0x13,0x00
	.byte 0x00,0x01,0xc9,0x09,0x00,0x00,0x69,0xa9
	.byte 0x13,0x00,0x00,0x31,0xbb,0x09,0x00,0x00
	.byte 0x69,0xb3,0x14,0x01,0x01,0x00,0x00,0x69
	.byte 0xe3,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x69,0xae,0x15,0x00,0x00,0x69,0xb8,0x00
	.byte 0x09,0x00,0x00,0x69,0xbd,0x13,0x00,0x00
	.byte 0x31,0xbb,0x09,0x00,0x00,0x69,0xe8,0x14
	.byte 0x01,0x01,0x00,0x00,0x6a,0x13,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x69,0xed,0x00
	.byte 0x09,0x00,0x00,0x69,0xf2,0x13,0x00,0x00
	.byte 0x01,0xa5,0x09,0x00,0x00,0x6a,0x18,0x13
	.byte 0x00,0x00,0x01,0xa5,0x09,0x00,0x00,0x6a
	.byte 0x22,0x13,0x00,0x00,0x01,0xc9,0x09,0x00
	.byte 0x00,0x6a,0x2c,0x13,0x00,0x00,0x31,0xbb
	.byte 0x09,0x00,0x00,0x6a,0x36,0x14,0x01,0x01
	.byte 0x00,0x00,0x6a,0x66,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x6a,0x1d,0x15,0x00,0x00,0x6a,0x27
	.byte 0x15,0x00,0x00,0x6a,0x31,0x15,0x00,0x00
	.byte 0x6a,0x3b,0x00,0x09,0x00,0x00,0x6a,0x40
	.byte 0x13,0x00,0x00,0x01,0xa5,0x09,0x00,0x00
	.byte 0x6a,0x6b,0x13,0x00,0x00,0x01,0xa5,0x09
	.byte 0x00,0x00,0x6a,0x75,0x13,0x00,0x00,0x31
	.byte 0xbb,0x09,0x00,0x00,0x6a,0x7f,0x14,0x01
	.byte 0x01,0x00,0x00,0x6a,0xaa,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9,0x15
	.byte 0x00,0x00,0x6a,0x70,0x15,0x00,0x00,0x6a
	.byte 0x7a,0x15,0x00,0x00,0x6a,0x84,0x00,0x09
	.byte 0x00,0x00,0x6a,0x89,0x14,0x01,0x01,0x00
	.byte 0x00,0x6a,0xd0,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xc9,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x46,0x22,0x00,0x09,0x00,0x00
	.byte 0x6a,0xaf,0x14,0x01,0x01,0x00,0x00,0x6b
	.byte 0x05,0x15,0x00,0x00,0x3c,0xbe,0x15,0x00
	.byte 0x00,0x01,0xc9,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x34,0xef,0x15,0x00,0x00,0x34,0xef,0x15
	.byte 0x00,0x00,0x34,0xef,0x15,0x00,0x00,0x34
	.byte 0xef,0x00,0x09,0x00,0x00,0x6a,0xd5,0x13
	.byte 0x00,0x00,0x01,0xa5,0x09,0x00,0x00,0x6b
	.byte 0x0a,0x13,0x00,0x00,0x01,0xa5,0x09,0x00
	.byte 0x00,0x6b,0x14,0x13,0x00,0x00,0x31,0xbb
	.byte 0x09,0x00,0x00,0x6b,0x1e,0x14,0x01,0x01
	.byte 0x00,0x00,0x6b,0x4e,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x6b,0x0f,0x15,0x00,0x00,0x6b,0x19
	.byte 0x15,0x00,0x00,0x46,0x22,0x15,0x00,0x00
	.byte 0x6b,0x23,0x00,0x09,0x00,0x00,0x6b,0x28
	.byte 0x13,0x00,0x00,0x01,0xa5,0x09,0x00,0x00
	.byte 0x6b,0x53,0x13,0x00,0x00,0x01,0xa5,0x09
	.byte 0x00,0x00,0x6b,0x5d,0x13,0x00,0x00,0x31
	.byte 0xbb,0x09,0x00,0x00,0x6b,0x67,0x14,0x01
	.byte 0x01,0x00,0x00,0x6b,0xa6,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9,0x15
	.byte 0x00,0x00,0x6b,0x58,0x15,0x00,0x00,0x6b
	.byte 0x62,0x15,0x00,0x00,0x34,0xef,0x15,0x00
	.byte 0x00,0x34,0xef,0x15,0x00,0x00,0x34,0xef
	.byte 0x15,0x00,0x00,0x34,0xef,0x15,0x00,0x00
	.byte 0x6b,0x6c,0x00,0x09,0x00,0x00,0x6b,0x71
	.byte 0x14,0x01,0x01,0x00,0x00,0x6b,0xb8,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x00,0x09,0x00,0x00
	.byte 0x6b,0xab,0x14,0x01,0x01,0x00,0x00,0x6b
	.byte 0xca,0x15,0x00,0x00,0x3c,0xbe,0x00,0x09
	.byte 0x00,0x00,0x6b,0xbd,0x16,0x01,0x00,0x00
	.byte 0x31,0xbb,0x01,0x00,0x00,0x6b,0xe5,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x01
	.byte 0xc9,0x00,0x09,0x00,0x00,0x6b,0xcf,0x16
	.byte 0x01,0x00,0x00,0x31,0xbb,0x01,0x00,0x00
	.byte 0x6c,0x0f,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x31,0xbb,0x15,0x00,0x00,0x31
	.byte 0xbb,0x15,0x00,0x00,0x31,0xbb,0x15,0x00
	.byte 0x00,0x31,0xbb,0x00,0x09,0x00,0x00,0x6b
	.byte 0xea,0x16,0x01,0x00,0x00,0x31,0xbb,0x01
	.byte 0x00,0x00,0x6c,0x2a,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x02,0x12,0x00,0x09
	.byte 0x00,0x00,0x6c,0x14,0x14,0x01,0x01,0x00
	.byte 0x00,0x6c,0x41,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x31,0xbb,0x00,0x09,0x00
	.byte 0x00,0x6c,0x2f,0x14,0x01,0x01,0x00,0x00
	.byte 0x6c,0x53,0x15,0x00,0x00,0x3c,0xbe,0x00
	.byte 0x09,0x00,0x00,0x6c,0x46,0x14,0x01,0x01
	.byte 0x00,0x00,0x6c,0x6f,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xe2,0x15,0x00
	.byte 0x00,0x01,0xe2,0x00,0x09,0x00,0x00,0x6c
	.byte 0x58,0x14,0x01,0x01,0x00,0x00,0x6c,0x81
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x00,0x09,0x00
	.byte 0x00,0x6c,0x74,0x14,0x01,0x01,0x00,0x00
	.byte 0x6c,0x93,0x15,0x00,0x00,0x3c,0xbe,0x00
	.byte 0x09,0x00,0x00,0x6c,0x86,0x13,0x00,0x00
	.byte 0x48,0x7a,0x09,0x00,0x00,0x6c,0x98,0x16
	.byte 0x01,0x00,0x00,0x01,0xc9,0x01,0x00,0x00
	.byte 0x6c,0xcc,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xc9,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x6c,0x9d,0x15,0x00,0x00,0x34,0xef
	.byte 0x00,0x09,0x00,0x00,0x6c,0xa2,0x13,0x00
	.byte 0x00,0x01,0xa5,0x09,0x00,0x00,0x6c,0xd1
	.byte 0x13,0x00,0x00,0x01,0xa5,0x09,0x00,0x00
	.byte 0x6c,0xdb,0x13,0x00,0x00,0x48,0x7a,0x09
	.byte 0x00,0x00,0x6c,0xe5,0x14,0x01,0x01,0x00
	.byte 0x00,0x6d,0x15,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x01,0xc9,0x15,0x00,0x00
	.byte 0x6c,0xd6,0x15,0x00,0x00,0x6c,0xe0,0x15
	.byte 0x00,0x00,0x6c,0xea,0x15,0x00,0x00,0x34
	.byte 0xef,0x00,0x09,0x00,0x00,0x6c,0xef,0x14
	.byte 0x01,0x01,0x00,0x00,0x6d,0x3b,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xc9
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x45,0x50,0x00
	.byte 0x09,0x00,0x00,0x6d,0x1a,0x14,0x01,0x01
	.byte 0x00,0x00,0x6d,0x61,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x01,0xa5,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x48,0x8c,0x00,0x09,0x00
	.byte 0x00,0x6d,0x40,0x14,0x01,0x01,0x00,0x00
	.byte 0x6d,0x7d,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x01,0xc9,0x15,0x00,0x00,0x01
	.byte 0xc9,0x00,0x09,0x00,0x00,0x6d,0x66,0x07
	.byte 0x00,0x00,0x6d,0x7d
	.ascii "points_func\0"
	.byte 0x02,0x14,0x01,0x01,0x00,0x00,0x6d,0xb0
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xc9,0x15
	.byte 0x00,0x00,0x01,0xc9,0x00,0x09,0x00,0x00
	.byte 0x6d,0x94,0x07,0x00,0x00,0x6d,0xb0
	.ascii "line_func\0"
	.byte 0x02,0x14,0x01,0x01,0x00,0x00,0x6d,0xe6
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xc9,0x15
	.byte 0x00,0x00,0x01,0xc9,0x15,0x00,0x00,0x01
	.byte 0xc9,0x00,0x09,0x00,0x00,0x6d,0xc5,0x07
	.byte 0x00,0x00,0x6d,0xe6
	.ascii "triangle_func\0"
	.byte 0x02,0x14,0x01,0x01,0x00,0x00,0x6e,0x25
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xc9,0x15
	.byte 0x00,0x00,0x01,0xc9,0x15,0x00,0x00,0x01
	.byte 0xc9,0x15,0x00,0x00,0x01,0xc9,0x00,0x09
	.byte 0x00,0x00,0x6d,0xff,0x07,0x00,0x00,0x6e
	.byte 0x25
	.ascii "quad_func\0"
	.byte 0x02,0x14,0x01,0x01,0x00,0x00,0x6e,0x5b
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x01
	.byte 0xa5,0x00,0x09,0x00,0x00,0x6e,0x3a,0x07
	.byte 0x00,0x00,0x6e,0x5b
	.ascii "rect_func\0"
	.byte 0x02,0x13,0x00,0x00,0x31,0xdf,0x09,0x00
	.byte 0x00,0x6e,0x70,0x16,0x01,0x00,0x00,0x31
	.byte 0xbb,0x01,0x00,0x00,0x6e,0xb3,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xa5,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x31,0xbb,0x15,0x00
	.byte 0x00,0x6e,0x75,0x00,0x09,0x00,0x00,0x6e
	.byte 0x7a,0x13,0x00,0x00,0x3d,0x86,0x09,0x00
	.byte 0x00,0x6e,0xb8,0x16,0x01,0x00,0x00,0x31
	.byte 0xbb,0x01,0x00,0x00,0x6e,0xf6,0x15,0x00
	.byte 0x00,0x3c,0xbe,0x15,0x00,0x00,0x01,0xa5
	.byte 0x15,0x00,0x00,0x01,0xa5,0x15,0x00,0x00
	.byte 0x01,0xe2,0x15,0x00,0x00,0x01,0xe2,0x15
	.byte 0x00,0x00,0x01,0xe2,0x15,0x00,0x00,0x01
	.byte 0xe2,0x15,0x00,0x00,0x6e,0xbd,0x00,0x09
	.byte 0x00,0x00,0x6e,0xc2,0x14,0x01,0x01,0x00
	.byte 0x00,0x6f,0x0d,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x02,0x12,0x00,0x09,0x00
	.byte 0x00,0x6e,0xfb,0x14,0x01,0x01,0x00,0x00
	.byte 0x6f,0x1f,0x15,0x00,0x00,0x3c,0xbe,0x00
	.byte 0x09,0x00,0x00,0x6f,0x12,0x14,0x01,0x01
	.byte 0x00,0x00,0x6f,0x3b,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x09,0x00,0x00,0x6f
	.byte 0x24,0x16,0x01,0x00,0x00,0x31,0xbb,0x01
	.byte 0x00,0x00,0x6f,0x56,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x31,0xbb
	.byte 0x00,0x09,0x00,0x00,0x6f,0x40,0x13,0x00
	.byte 0x00,0x01,0xe2,0x09,0x00,0x00,0x6f,0x5b
	.byte 0x14,0x01,0x01,0x00,0x00,0x6f,0x7c,0x15
	.byte 0x00,0x00,0x3c,0xbe,0x15,0x00,0x00,0x02
	.byte 0x12,0x15,0x00,0x00,0x6f,0x60,0x00,0x09
	.byte 0x00,0x00,0x6f,0x65,0x13,0x00,0x00,0x31
	.byte 0xec,0x09,0x00,0x00,0x6f,0x81,0x14,0x01
	.byte 0x01,0x00,0x00,0x6f,0xb1,0x15,0x00,0x00
	.byte 0x3c,0xbe,0x15,0x00,0x00,0x02,0x12,0x15
	.byte 0x00,0x00,0x35,0x4b,0x15,0x00,0x00,0x01
	.byte 0xa5,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x6f,0x86,0x00,0x09,0x00,0x00,0x6f
	.byte 0x8b,0x13,0x00,0x00,0x01,0xe2,0x09,0x00
	.byte 0x00,0x6f,0xb6,0x14,0x01,0x01,0x00,0x00
	.byte 0x6f,0xe1,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x02,0x12,0x15,0x00,0x00,0x35
	.byte 0x4b,0x15,0x00,0x00,0x02,0x12,0x15,0x00
	.byte 0x00,0x6f,0xbb,0x00,0x09,0x00,0x00,0x6f
	.byte 0xc0,0x14,0x01,0x01,0x00,0x00,0x6f,0xfd
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x02,0x12,0x15,0x00,0x00,0x35,0x4b,0x00
	.byte 0x09,0x00,0x00,0x6f,0xe6,0x14,0x01,0x01
	.byte 0x00,0x00,0x70,0x14,0x15,0x00,0x00,0x3c
	.byte 0xbe,0x15,0x00,0x00,0x35,0x4b,0x00,0x09
	.byte 0x00,0x00,0x70,0x02,0x14,0x01,0x01,0x00
	.byte 0x00,0x70,0x2b,0x15,0x00,0x00,0x3c,0xbe
	.byte 0x15,0x00,0x00,0x35,0x4b,0x00,0x09,0x00
	.byte 0x00,0x70,0x19,0x14,0x01,0x01,0x00,0x00
	.byte 0x70,0x42,0x15,0x00,0x00,0x3c,0xbe,0x15
	.byte 0x00,0x00,0x31,0xbb,0x00,0x09,0x00,0x00
	.byte 0x70,0x30,0x0e
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x74,0xaf,0x0f
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x67,0x56,0x02,0x23,0x00,0x0f
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x67,0x68,0x02,0x23,0x04,0x0f
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x67,0x7f,0x02,0x23,0x08,0x0f
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x67,0xa5,0x02,0x23,0x0c,0x0f
	.ascii "Clear\0"
	.byte 0x00,0x00,0x67,0xd0,0x02,0x23,0x10,0x0f
	.ascii "Index\0"
	.byte 0x00,0x00,0x67,0xe7,0x02,0x23,0x14,0x0f
	.ascii "Color\0"
	.byte 0x00,0x00,0x68,0x0d,0x02,0x23,0x18,0x0f
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x68,0x28,0x02,0x23,0x1c,0x0f
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x68,0x44,0x02,0x23,0x20,0x0f
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x68,0xb0,0x02,0x23,0x24,0x0f
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x68,0xe0,0x02,0x23,0x28,0x0f
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x69,0x60,0x02,0x23,0x2c,0x0f
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x69,0xa4,0x02,0x23,0x30,0x0f
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x69,0xe3,0x02,0x23,0x34,0x0f
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x6a,0x13,0x02,0x23,0x38,0x0f
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x6a,0x66,0x02,0x23,0x3c,0x0f
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x6a,0xaa,0x02,0x23,0x40,0x0f
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x6a,0xd0,0x02,0x23,0x44,0x0f
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x6b,0x05,0x02,0x23,0x48,0x0f
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x6b,0x4e,0x02,0x23,0x4c,0x0f
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x6b,0xa6,0x02,0x23,0x50,0x0f
	.ascii "Finish\0"
	.byte 0x00,0x00,0x6b,0xb8,0x02,0x23,0x54,0x0f
	.ascii "Flush\0"
	.byte 0x00,0x00,0x6b,0xca,0x02,0x23,0x58,0x0f
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x6b,0xe5,0x02,0x23,0x5c,0x0f
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x6c,0x0f,0x02,0x23,0x60,0x0f
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x6c,0x2a,0x02,0x23,0x64,0x0f
	.ascii "Dither\0"
	.byte 0x00,0x00,0x6c,0x41,0x02,0x23,0x68,0x0f
	.ascii "Error\0"
	.byte 0x00,0x00,0x6c,0x53,0x02,0x23,0x6c,0x0f
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x6c,0x6f,0x02,0x23,0x70,0x0f
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x81,0x02,0x23,0x74,0x0f
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x93,0x02,0x23,0x78,0x0f
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x6c,0xcc,0x02,0x23,0x7c,0x0f
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x6d,0x15,0x03,0x23,0x80,0x01
	.byte 0x0f
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x6d,0x3b,0x03,0x23,0x84,0x01
	.byte 0x0f
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x6d,0x61,0x03,0x23,0x88,0x01
	.byte 0x0f
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x82,0x03,0x23,0x8c,0x01
	.byte 0x0f
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0xb5,0x03,0x23,0x90,0x01
	.byte 0x0f
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0xeb,0x03,0x23,0x94,0x01
	.byte 0x0f
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6e,0x2a,0x03,0x23,0x98,0x01
	.byte 0x0f
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6e,0x60,0x03,0x23,0x9c,0x01
	.byte 0x0f
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x6e,0xb3,0x03,0x23,0xa0,0x01
	.byte 0x0f
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x6e,0xf6,0x03,0x23,0xa4,0x01
	.byte 0x0f
	.ascii "Begin\0"
	.byte 0x00,0x00,0x6f,0x0d,0x03,0x23,0xa8,0x01
	.byte 0x0f
	.ascii "End\0"
	.byte 0x00,0x00,0x6f,0x1f,0x03,0x23,0xac,0x01
	.byte 0x0f
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x6f,0x3b,0x03,0x23,0xb0,0x01
	.byte 0x0f
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x6f,0x56,0x03,0x23,0xb4,0x01
	.byte 0x0f
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x6f,0x7c,0x03,0x23,0xb8,0x01
	.byte 0x0f
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x6f,0xb1,0x03,0x23,0xbc,0x01
	.byte 0x0f
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x6f,0xe1,0x03,0x23,0xc0,0x01
	.byte 0x0f
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x6f,0xfd,0x03,0x23,0xc4,0x01
	.byte 0x0f
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x70,0x14,0x03,0x23,0xc8,0x01
	.byte 0x0f
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x70,0x2b,0x03,0x23,0xcc,0x01
	.byte 0x0f
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x70,0x42,0x03,0x23,0xd0,0x01
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x40,0x00
	.byte 0x00,0x74,0xc0,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x0f,0x00,0x0a,0x00,0x00,0x01,0xeb,0x40
	.byte 0x00,0x00,0x74,0xd1,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x0f,0x00,0x0a,0x00,0x00,0x01,0xe2
	.byte 0x40,0x00,0x00,0x74,0xe2,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x0f,0x00,0x10,0x00,0x00,0x74
	.byte 0xd1,0x08,0x00,0x00,0x00,0x74,0xf4,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x1f,0x00,0x0a,0x00
	.byte 0x00,0x01,0xeb,0x40,0x00,0x00,0x75,0x05
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x0f,0x00,0x0a
	.byte 0x00,0x00,0x01,0xe2,0x40,0x00,0x00,0x75
	.byte 0x16,0x0b,0x00,0x00,0x01,0xf9,0x0f,0x00
	.byte 0x10,0x00,0x00,0x75,0x05,0x08,0x00,0x00
	.byte 0x00,0x75,0x28,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x1f,0x00,0x0a,0x00,0x00,0x01,0xe2,0x08
	.byte 0x00,0x00,0x75,0x39,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x01,0x00,0x10,0x00,0x00,0x75,0x28
	.byte 0x01,0x00,0x00,0x00,0x75,0x4b,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x1f,0x00,0x0a,0x00,0x00
	.byte 0x01,0xeb,0x40,0x00,0x00,0x75,0x5c,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x0f,0x00,0x0a,0x00
	.byte 0x00,0x01,0xe2,0x40,0x00,0x00,0x75,0x6d
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x0f,0x00,0x10
	.byte 0x00,0x00,0x75,0x5c,0x02,0x80,0x00,0x00
	.byte 0x75,0x7f,0x0b,0x00,0x00,0x01,0xf9,0x09
	.byte 0x00,0x07,0x00,0x00,0x01,0xc9
	.ascii "GLbitfield\0"
	.byte 0x03,0x09,0x00,0x00,0x75,0x95,0x0e
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x02,0x00,0x00,0x75,0xd3,0x0f
	.ascii "kind\0"
	.byte 0x00,0x00,0x75,0x7f,0x02,0x23,0x00,0x0f
	.ascii "data\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x04,0x0f
	.ascii "next\0"
	.byte 0x00,0x00,0x75,0x90,0x02,0x23,0x08,0x00
	.byte 0x0a,0x00,0x00,0x75,0x90,0x40,0x00,0x00
	.byte 0x75,0xe4,0x0b,0x00,0x00,0x01,0xf9,0x0f
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x10,0x00
	.byte 0x00,0x75,0xf5,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0e
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x02,0x00,0x00,0x76,0x20,0x0f
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xe4,0x02,0x23,0x00,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x76,0x31,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x10,0x00
	.byte 0x00,0x76,0x42,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0e
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x02,0x00,0x00,0x77,0xf1,0x0f
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x00,0x0f
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x76,0x20,0x02,0x23,0x04,0x0f
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x14,0x0f
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x18,0x0f
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x1c,0x0f
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x20,0x0f
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x24,0x0f
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x28,0x0f
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x2c,0x0f
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0xcc,0x02,0x23,0x30,0x0f
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x31,0x0f
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x34,0x0f
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x38,0x0f
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x3c,0x0f
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x76,0x31,0x02,0x23,0x40,0x0f
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x50,0x0f
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x54,0x0f
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x55,0x0f
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x56,0x0f
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x57,0x00
	.byte 0x0a,0x00,0x00,0x31,0xcc,0x04,0x00,0x00
	.byte 0x78,0x02,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x0c,0x00
	.byte 0x00,0x78,0x13,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x02,0x00,0x0a,0x00,0x00,0x01,0xeb,0x10
	.byte 0x00,0x00,0x78,0x24,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0a,0x00,0x00,0x01,0xeb
	.byte 0x10,0x00,0x00,0x78,0x35,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x03,0x00,0x0a,0x00,0x00,0x01
	.byte 0xeb,0x10,0x00,0x00,0x78,0x46,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x03,0x00,0x0a,0x00,0x00
	.byte 0x01,0xeb,0x10,0x00,0x00,0x78,0x57,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x03,0x00,0x0e
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x02,0x00,0x00,0x79,0x41,0x0f
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x77,0xf1,0x02,0x23,0x00,0x0f
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x04,0x0f
	.ascii "Normal\0"
	.byte 0x00,0x00,0x78,0x02,0x02,0x23,0x08,0x0f
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x78,0x13,0x02,0x23,0x14,0x0f
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x78,0x24,0x02,0x23,0x24,0x0f
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x34,0x0f
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x78,0x35,0x02,0x23,0x38,0x0f
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x48,0x0f
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x78,0x46,0x02,0x23,0x4c,0x0f
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x5c,0x0f
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x5d,0x00
	.byte 0x0e
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x79,0x94,0x0f
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "Clear\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x04,0x0f
	.ascii "Test\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x08,0x0f
	.ascii "Mask\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x09,0x00
	.byte 0x0e
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x02,0x00,0x00,0x7b,0xf9,0x0f
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x01,0x0f
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x02,0x0f
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x03,0x0f
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x04,0x0f
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x05,0x0f
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x06,0x0f
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x07,0x0f
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x08,0x0f
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x09,0x0f
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0a,0x0f
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0b,0x0f
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0c,0x0f
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0d,0x0f
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0e,0x0f
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0f,0x0f
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x10,0x0f
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x11,0x0f
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x12,0x0f
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x14,0x0f
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x20,0x0f
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x24,0x0f
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x28,0x0f
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x2c,0x0f
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x30,0x0f
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x34,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x7c,0x0a,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0e
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x7c,0x83,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "Color\0"
	.byte 0x00,0x00,0x7b,0xf9,0x02,0x23,0x04,0x0f
	.ascii "Density\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x14,0x0f
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "End\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x20,0x0f
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x24,0x00
	.byte 0x0e
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x7d,0x01,0x0f
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x08,0x0f
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x0c,0x0f
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x10,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x7d,0x12,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x10,0x00
	.byte 0x00,0x7d,0x23,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0a,0x00,0x00,0x01,0xeb,0x10
	.byte 0x00,0x00,0x7d,0x34,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0a,0x00,0x00,0x01,0xeb
	.byte 0x10,0x00,0x00,0x7d,0x45,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x03,0x00,0x0a,0x00,0x00,0x01
	.byte 0xeb,0x10,0x00,0x00,0x7d,0x56,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x03,0x00,0x12
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x02,0x00,0x00,0x7f,0x18,0x0f
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7d,0x01,0x02,0x23,0x00,0x0f
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7d,0x12,0x02,0x23,0x10,0x0f
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7d,0x23,0x02,0x23,0x20,0x0f
	.ascii "Position\0"
	.byte 0x00,0x00,0x7d,0x34,0x02,0x23,0x30,0x0f
	.ascii "Direction\0"
	.byte 0x00,0x00,0x7d,0x45,0x02,0x23,0x40,0x0f
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x50,0x0f
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x54,0x0f
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x58,0x0f
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x5c,0x0f
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x60,0x0f
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x64,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x68,0x0f
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x7f,0x18,0x02,0x23,0x6c,0x0f
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x7f,0x1d,0x02,0x23,0x70,0x0f
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x7f,0x2e,0x02,0x23,0x7c,0x0f
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x7f,0x3f,0x03,0x23,0x88,0x01
	.byte 0x0f
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x7f,0x61,0x03,0x23,0x94,0x01
	.byte 0x0f
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x7f,0x85,0x03,0x23,0x94,0x21
	.byte 0x0f
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x7f,0xa7,0x03,0x23,0xac,0x21
	.byte 0x0f
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x7f,0xc9,0x03,0x23,0xc4,0x21
	.byte 0x0f
	.ascii "dli\0"
	.byte 0x00,0x00,0x01,0xeb,0x03,0x23,0xdc,0x21
	.byte 0x0f
	.ascii "sli\0"
	.byte 0x00,0x00,0x01,0xeb,0x03,0x23,0xe0,0x21
	.byte 0x00,0x09,0x00,0x00,0x7d,0x56,0x0a,0x00
	.byte 0x00,0x01,0xeb,0x0c,0x00,0x00,0x7f,0x2e
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x02,0x00,0x0a
	.byte 0x00,0x00,0x01,0xeb,0x0c,0x00,0x00,0x7f
	.byte 0x3f,0x0b,0x00,0x00,0x01,0xf9,0x02,0x00
	.byte 0x0a
	.byte 0x00,0x00,0x01,0xeb,0x0c,0x00,0x00,0x7f
	.byte 0x50,0x0b,0x00,0x00,0x01,0xf9,0x02,0x00
	.byte 0x0a,0x00,0x00,0x01,0xe2,0x08,0x00,0x00
	.byte 0x7f,0x61,0x0b,0x00,0x00,0x01,0xf9,0x01
	.byte 0x00,0x10,0x00,0x00,0x7f,0x50,0x10,0x00
	.byte 0x00,0x00,0x7f,0x74,0x11,0x00,0x00,0x01
	.byte 0xf9,0x01,0xff,0x00,0x0a,0x00,0x00,0x01
	.byte 0xe2,0x0c,0x00,0x00,0x7f,0x85,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x02,0x00,0x0a,0x00,0x00
	.byte 0x7f,0x74,0x18,0x00,0x00,0x7f,0x96,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x01,0x00,0x0a,0x00
	.byte 0x00,0x01,0xe2,0x0c,0x00,0x00,0x7f,0xa7
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x02,0x00,0x0a
	.byte 0x00,0x00,0x7f,0x96,0x18,0x00,0x00,0x7f
	.byte 0xb8,0x0b,0x00,0x00,0x01,0xf9,0x01,0x00
	.byte 0x0a,0x00,0x00,0x01,0xe2,0x0c,0x00,0x00
	.byte 0x7f,0xc9,0x0b,0x00,0x00,0x01,0xf9,0x02
	.byte 0x00,0x0a,0x00,0x00,0x7f,0xb8,0x18,0x00
	.byte 0x00,0x7f,0xda,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x01,0x00,0x10,0x00,0x00,0x7d,0x56,0x87
	.byte 0x20,0x00,0x00,0x7f,0xec,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x07,0x00,0x0a,0x00,0x00,0x01
	.byte 0xeb,0x10,0x00,0x00,0x7f,0xfd,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x03,0x00,0x0e
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x02,0x00,0x00,0x80,0x47,0x0f
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0xec,0x02,0x23,0x00,0x0f
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x10,0x0f
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x11,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x80,0x58,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x10,0x00
	.byte 0x00,0x80,0x69,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0a,0x00,0x00,0x01,0xeb,0x10
	.byte 0x00,0x00,0x80,0x7a,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0a,0x00,0x00,0x01,0xeb
	.byte 0x10,0x00,0x00,0x80,0x8b,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x03,0x00,0x10,0x00,0x00,0x01
	.byte 0xeb,0x03,0x20,0x00,0x00,0x80,0x9e,0x11
	.byte 0x00,0x00,0x01,0xf9,0x00,0xc7,0x00,0x12
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x02,0x00,0x00,0x81,0x5a,0x0f
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x80,0x47,0x02,0x23,0x00,0x0f
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x80,0x58,0x02,0x23,0x10,0x0f
	.ascii "Specular\0"
	.byte 0x00,0x00,0x80,0x69,0x02,0x23,0x20,0x0f
	.ascii "Emission\0"
	.byte 0x00,0x00,0x80,0x7a,0x02,0x23,0x30,0x0f
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x40,0x0f
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x44,0x0f
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x48,0x0f
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x4c,0x0f
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x80,0x8b,0x02,0x23,0x50,0x00
	.byte 0x10,0x00,0x00,0x80,0x9e,0x06,0xe0,0x00
	.byte 0x00,0x81,0x6c,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x01,0x00,0x0a,0x00,0x00,0x01,0xe2,0x10
	.byte 0x00,0x00,0x81,0x7d,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0a,0x00,0x00,0x81,0x6c
	.byte 0x20,0x00,0x00,0x81,0x8e,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x01,0x00,0x12
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x02,0x00,0x00,0x82,0xaf,0x0f
	.ascii "Light\0"
	.byte 0x00,0x00,0x7f,0xda,0x02,0x23,0x00,0x0f
	.ascii "Model\0"
	.byte 0x00,0x00,0x7f,0xfd,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0f
	.ascii "Material\0"
	.byte 0x00,0x00,0x81,0x5a,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0f
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0f
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0f
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0xae,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0f
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x01,0xd5,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0f
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0f
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x7f,0x18,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0f
	.ascii "Fast\0"
	.byte 0x00,0x00,0x33,0x1e,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0f
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x81,0x7d,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x07,0x00,0x00,0x48,0x7a
	.ascii "GLushort\0"
	.byte 0x03,0x0e
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x83,0x37,0x0f
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x01,0x0f
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x82,0xaf,0x02,0x23,0x02,0x0f
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x08,0x00
	.byte 0x0e
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x02,0x00,0x00,0x83,0x5f,0x0f
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x00,0x00
	.byte 0x10,0x00,0x00,0x01,0xac,0x04,0x00,0x00
	.byte 0x00,0x83,0x72,0x11,0x00,0x00,0x01,0xf9
	.byte 0x00,0xff,0x00,0x10,0x00,0x00,0x01,0xac
	.byte 0x04,0x00,0x00,0x00,0x83,0x85,0x11,0x00
	.byte 0x00,0x01,0xf9,0x00,0xff,0x00,0x10,0x00
	.byte 0x00,0x01,0xeb,0x04,0x00,0x00,0x00,0x83
	.byte 0x98,0x11,0x00,0x00,0x01,0xf9,0x00,0xff
	.byte 0x00,0x10,0x00,0x00,0x01,0xeb,0x04,0x00
	.byte 0x00,0x00,0x83,0xab,0x11,0x00,0x00,0x01
	.byte 0xf9,0x00,0xff,0x00,0x10,0x00,0x00,0x01
	.byte 0xeb,0x04,0x00,0x00,0x00,0x83,0xbe,0x11
	.byte 0x00,0x00,0x01,0xf9,0x00,0xff,0x00,0x10
	.byte 0x00,0x00,0x01,0xeb,0x04,0x00,0x00,0x00
	.byte 0x83,0xd1,0x11,0x00,0x00,0x01,0xf9,0x00
	.byte 0xff,0x00,0x10,0x00,0x00,0x01,0xeb,0x04
	.byte 0x00,0x00,0x00,0x83,0xe4,0x11,0x00,0x00
	.byte 0x01,0xf9,0x00,0xff,0x00,0x10,0x00,0x00
	.byte 0x01,0xeb,0x04,0x00,0x00,0x00,0x83,0xf7
	.byte 0x11,0x00,0x00,0x01,0xf9,0x00,0xff,0x00
	.byte 0x10,0x00,0x00,0x01,0xeb,0x04,0x00,0x00
	.byte 0x00,0x84,0x0a,0x11,0x00,0x00,0x01,0xf9
	.byte 0x00,0xff,0x00,0x10,0x00,0x00,0x01,0xeb
	.byte 0x04,0x00,0x00,0x00,0x84,0x1d,0x11,0x00
	.byte 0x00,0x01,0xf9,0x00,0xff,0x00,0x12
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x02,0x00,0x00,0x86,0xdc,0x0f
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x04,0x0f
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x08,0x0f
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x0c,0x0f
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x10,0x0f
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x14,0x0f
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x20,0x0f
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x24,0x0f
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x28,0x0f
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x2c,0x0f
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x30,0x0f
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x34,0x0f
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x35,0x0f
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x38,0x0f
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x3c,0x0f
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x40,0x0f
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x44,0x0f
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x48,0x0f
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x4c,0x0f
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x50,0x0f
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x54,0x0f
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x58,0x0f
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x5c,0x0f
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x60,0x0f
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x64,0x0f
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x83,0x5f,0x02,0x23,0x68,0x0f
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x83,0x72,0x03,0x23,0xe8,0x08
	.byte 0x0f
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x83,0x85,0x03,0x23,0xe8,0x10
	.byte 0x0f
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x83,0x98,0x03,0x23,0xe8,0x18
	.byte 0x0f
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x83,0xab,0x03,0x23,0xe8,0x20
	.byte 0x0f
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x83,0xbe,0x03,0x23,0xe8,0x28
	.byte 0x0f
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x83,0xd1,0x03,0x23,0xe8,0x30
	.byte 0x0f
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x83,0xe4,0x03,0x23,0xe8,0x38
	.byte 0x0f
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x83,0xf7,0x03,0x23,0xe8,0x40
	.byte 0x0f
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x84,0x0a,0x03,0x23,0xe8,0x48
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x0c,0x00
	.byte 0x00,0x86,0xed,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x02,0x00,0x0e
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x02,0x00,0x00,0x87,0x66,0x0f
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "Size\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x04,0x0f
	.ascii "Params\0"
	.byte 0x00,0x00,0x86,0xdc,0x02,0x23,0x08,0x0f
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x14,0x0f
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x00
	.byte 0x0e
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x88,0x99,0x0f
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x08,0x0f
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0c,0x0f
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x0d,0x0f
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x10,0x0f
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x14,0x0f
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x18,0x0f
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x19,0x0f
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x20,0x0f
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x24,0x0f
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x25,0x0f
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x26,0x0f
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x27,0x00
	.byte 0x0a,0x00,0x00,0x01,0xd5,0x80,0x00,0x00
	.byte 0x88,0xaa,0x0b,0x00,0x00,0x01,0xf9,0x1f
	.byte 0x00,0x07,0x00,0x00,0x01,0xa5
	.ascii "GLsizei\0"
	.byte 0x03,0x0e
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x89,0x13,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x08,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x0c,0x0f
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x10,0x00
	.byte 0x0e
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x02,0x00,0x00,0x89,0xc1,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x00,0x0f
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x08,0x0f
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x0c,0x0f
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x10,0x0f
	.ascii "Ref\0"
	.byte 0x00,0x00,0x66,0x1c,0x02,0x23,0x14,0x0f
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x66,0x1c,0x02,0x23,0x15,0x0f
	.ascii "Clear\0"
	.byte 0x00,0x00,0x66,0x1c,0x02,0x23,0x16,0x0f
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x66,0x1c,0x02,0x23,0x17,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x89,0xd2,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x0a,0x00,0x00,0x01,0xeb,0x10,0x00
	.byte 0x00,0x89,0xe3,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0a,0x00,0x00,0x01,0xeb,0x10
	.byte 0x00,0x00,0x89,0xf4,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x03,0x00,0x0a,0x00,0x00,0x01,0xeb
	.byte 0x10,0x00,0x00,0x8a,0x05,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x03,0x00,0x0a,0x00,0x00,0x01
	.byte 0xeb,0x10,0x00,0x00,0x8a,0x16,0x0b,0x00
	.byte 0x00,0x01,0xf9,0x03,0x00,0x0a,0x00,0x00
	.byte 0x01,0xeb,0x10,0x00,0x00,0x8a,0x27,0x0b
	.byte 0x00,0x00,0x01,0xf9,0x03,0x00,0x0a,0x00
	.byte 0x00,0x01,0xeb,0x10,0x00,0x00,0x8a,0x38
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x03,0x00,0x0a
	.byte 0x00,0x00,0x01,0xeb,0x10,0x00,0x00,0x8a
	.byte 0x49,0x0b,0x00,0x00,0x01,0xf9,0x03,0x00
	.byte 0x0a,0x00,0x00,0x01,0xeb,0x10,0x00,0x00
	.byte 0x8a,0x5a,0x0b,0x00,0x00,0x01,0xf9,0x03
	.byte 0x00,0x10,0x00,0x00,0x31,0xcc,0x04,0x00
	.byte 0x00,0x00,0x8a,0x6d,0x11,0x00,0x00,0x01
	.byte 0xf9,0x03,0xff,0x00,0x12
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x02,0x00,0x00,0x8c,0x9c,0x0f
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x00,0x0f
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x89,0xc1,0x02,0x23,0x08,0x0f
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x18,0x0f
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x1c,0x0f
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x20,0x0f
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x24,0x0f
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x28,0x0f
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x89,0xd2,0x02,0x23,0x2c,0x0f
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x89,0xe3,0x02,0x23,0x3c,0x0f
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x89,0xf4,0x02,0x23,0x4c,0x0f
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x8a,0x05,0x02,0x23,0x5c,0x0f
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x8a,0x16,0x02,0x23,0x6c,0x0f
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x8a,0x27,0x02,0x23,0x7c,0x0f
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x8a,0x38,0x03,0x23,0x8c,0x01
	.byte 0x0f
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x8a,0x49,0x03,0x23,0x9c,0x01
	.byte 0x0f
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xac,0x01
	.byte 0x0f
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xb0,0x01
	.byte 0x0f
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xb4,0x01
	.byte 0x0f
	.ascii "Current\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xb8,0x01
	.byte 0x0f
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xbc,0x01
	.byte 0x0f
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xc0,0x01
	.byte 0x0f
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x35,0x4b,0x03,0x23,0xc4,0x01
	.byte 0x0f
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0xc8,0x01
	.byte 0x0f
	.ascii "Palette\0"
	.byte 0x00,0x00,0x8a,0x5a,0x03,0x23,0xc9,0x01
	.byte 0x0f
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0xd5,0x03,0x23,0xcc,0x09
	.byte 0x0f
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0xae,0x03,0x23,0xd0,0x09
	.byte 0x0f
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0xae,0x03,0x23,0xd4,0x09
	.byte 0x00,0x0a,0x00,0x00,0x01,0xe2,0x10,0x00
	.byte 0x00,0x8c,0xad,0x0b,0x00,0x00,0x01,0xf9
	.byte 0x03,0x00,0x0a,0x00,0x00,0x8c,0x9c,0x60
	.byte 0x00,0x00,0x8c,0xbe,0x0b,0x00,0x00,0x01
	.byte 0xf9,0x05,0x00,0x0a,0x00,0x00,0x33,0x1e
	.byte 0x06,0x00,0x00,0x8c,0xcf,0x0b,0x00,0x00
	.byte 0x01,0xf9,0x05,0x00,0x0e
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x02,0x00,0x00,0x8d,0x49,0x0f
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x8c,0xad,0x02,0x23,0x04,0x0f
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x8c,0xbe,0x02,0x23,0x64,0x0f
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x6a,0x0f
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x6b,0x00
	.byte 0x0e
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x02,0x00,0x00,0x8d,0xf0,0x0f
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x08,0x0f
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x0c,0x0f
	.ascii "Near\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x10,0x0f
	.ascii "Far\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x14,0x0f
	.ascii "Sx\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x18,0x0f
	.ascii "Sy\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x1c,0x0f
	.ascii "Sz\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x20,0x0f
	.ascii "Tx\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x24,0x0f
	.ascii "Ty\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x28,0x0f
	.ascii "Tz\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x2c,0x00
	.byte 0x0a,0x00,0x00,0x75,0x90,0x40,0x00,0x00
	.byte 0x8e,0x01,0x0b,0x00,0x00,0x01,0xf9,0x0f
	.byte 0x00,0x09,0x00,0x00,0x33,0x1e,0x0e
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x02,0x00,0x00,0x90,0xb1,0x0f
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x04,0x0f
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x08,0x0f
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x0c,0x0f
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x10,0x0f
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x14,0x0f
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x18,0x0f
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x1c,0x0f
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x20,0x0f
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x24,0x0f
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x28,0x0f
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x2c,0x0f
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x30,0x0f
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x34,0x0f
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x38,0x0f
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x3c,0x0f
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x40,0x0f
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x44,0x0f
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x48,0x0f
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x4c,0x0f
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x50,0x0f
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x54,0x0f
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x58,0x0f
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x5c,0x0f
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x60,0x0f
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x64,0x0f
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x31,0xe7,0x02,0x23,0x68,0x0f
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x6c,0x0f
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x70,0x0f
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x88,0xaa,0x02,0x23,0x74,0x0f
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x8e,0x01,0x02,0x23,0x78,0x0f
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x7c,0x00
	.byte 0x0e
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x02,0x00,0x00,0x91,0x60,0x0f
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x00,0x0f
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x04,0x0f
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x08,0x0f
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x0c,0x0f
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x10,0x0f
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0xac,0x02,0x23,0x14,0x0f
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x18,0x0f
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x19,0x00
	.byte 0x09,0x00,0x00,0x01,0xeb,0x0e
	.ascii "gl_1d_map\0"
	.byte 0x14,0x02,0x00,0x00,0x91,0xb9,0x0f
	.ascii "Order\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x00,0x0f
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x04,0x0f
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x08,0x0f
	.ascii "Points\0"
	.byte 0x00,0x00,0x91,0x60,0x02,0x23,0x0c,0x0f
	.ascii "Retain\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x10,0x00
	.byte 0x0e
	.ascii "gl_2d_map\0"
	.byte 0x20,0x02,0x00,0x00,0x92,0x33,0x0f
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x00,0x0f
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x04,0x0f
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x08,0x0f
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x0c,0x0f
	.ascii "v1\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x10,0x0f
	.ascii "v2\0"
	.byte 0x00,0x00,0x01,0xeb,0x02,0x23,0x14,0x0f
	.ascii "Points\0"
	.byte 0x00,0x00,0x91,0x60,0x02,0x23,0x18,0x0f
	.ascii "Retain\0"
	.byte 0x00,0x00,0x33,0x1e,0x02,0x23,0x1c,0x00
	.byte 0x12
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x02,0x00,0x00,0x93,0xbd,0x0f
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x00,0x0f
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x14,0x0f
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x28,0x0f
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x3c,0x0f
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x50,0x0f
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x64,0x0f
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x91,0x65,0x02,0x23,0x78,0x0f
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x91,0x65,0x03,0x23,0x8c,0x01
	.byte 0x0f
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x91,0x65,0x03,0x23,0xa0,0x01
	.byte 0x0f
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xb4,0x01
	.byte 0x0f
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xd4,0x01
	.byte 0x0f
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xf4,0x01
	.byte 0x0f
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0x94,0x02
	.byte 0x0f
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xb4,0x02
	.byte 0x0f
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xd4,0x02
	.byte 0x0f
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xf4,0x02
	.byte 0x0f
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0x94,0x03
	.byte 0x0f
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x91,0xb9,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0e
	.ascii "gl_feedback\0"
	.byte 0x14,0x02,0x00,0x00,0x94,0x1b,0x0f
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0xae,0x02,0x23,0x00,0x0f
	.ascii "Mask\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x04,0x0f
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x91,0x60,0x02,0x23,0x08,0x0f
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x0c,0x0f
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x10,0x00
	.byte 0x09,0x00,0x00,0x01,0xd5,0x10,0x00,0x00
	.byte 0x01,0xd5,0x01,0x00,0x00,0x00,0x94,0x32
	.byte 0x0b,0x00,0x00,0x01,0xf9,0x3f,0x00,0x12
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x02,0x00,0x00,0x94,0xe7,0x0f
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x94,0x1b,0x02,0x23,0x00,0x0f
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x04,0x0f
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x08,0x0f
	.ascii "Hits\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x0c,0x0f
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x01,0xd5,0x02,0x23,0x10,0x0f
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x94,0x20,0x02,0x23,0x14,0x0f
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x33,0x1e,0x03,0x23,0x94,0x02
	.byte 0x0f
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x01,0xeb,0x03,0x23,0x98,0x02
	.byte 0x0f
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x01,0xeb,0x03,0x23,0x9c,0x02
	.byte 0x00,0x08
	.ascii "vertex_buffer\0"
	.byte 0x01,0x09,0x00,0x00,0x94,0xe7,0x08
	.ascii "pixel_buffer\0"
	.byte 0x01,0x09,0x00,0x00,0x94,0xfc,0x07,0x00
	.byte 0x00,0x35,0xf1
	.ascii "GLcontext\0"
	.byte 0x02,0x09,0x00,0x00,0x95,0x10,0x18
	.ascii "clip_span\0"
	.byte 0x03,0x01,0x7c
	.uaword clip_span
	.uaword clip_span+200
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0xd5,0x01
	.byte 0x00,0x00,0x95,0x96,0x03,0x00,0x00,0x95
	.byte 0x20
	.ascii "ctx\0"
	.byte 0x01,0x7a,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0xac
	.ascii "n\0"
	.byte 0x01,0x7b,0x01,0x59,0x03,0x00,0x00,0x01
	.byte 0xac
	.ascii "x\0"
	.byte 0x01,0x7b,0x01,0x5d,0x03,0x00,0x00,0x01
	.byte 0xac
	.ascii "y\0"
	.byte 0x01,0x7b,0x01,0x5b,0x03,0x00,0x00,0x31
	.byte 0xda
	.ascii "mask\0"
	.byte 0x01,0x7b,0x01,0x5c,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xac,0x01,0x01,0x7d,0x01
	.byte 0x5f,0x05,0x44,0x01,0x04,0x00,0x19
	.ascii "gl_write_index_span\0"
	.byte 0x01,0x02,0x01,0xaa
	.uaword gl_write_index_span
	.uaword gl_write_index_span+2036
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x96,0x49
	.byte 0x03,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0xa7,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0xa8,0x01,0x69,0x03,0x00,0x00,0x01
	.byte 0xac
	.ascii "x\0"
	.byte 0x01,0xa8,0x01,0x6a,0x03,0x00,0x00,0x01
	.byte 0xac
	.ascii "y\0"
	.byte 0x01,0xa8,0x01,0x6b,0x03,0x00,0x00,0x66
	.byte 0x17
	.ascii "z\0"
	.byte 0x01,0xa8,0x01,0x6c,0x03,0x00,0x00,0x94
	.byte 0x1b
	.ascii "index\0"
	.byte 0x01,0xa9,0x01,0x6d,0x03,0x00,0x00,0x31
	.byte 0xae
	.ascii "primitive\0"
	.byte 0x01,0xa9,0x01,0x60,0x04
	.ascii "mask\0"
	.byte 0x00,0x00,0x96,0x49,0x01,0x01,0xab,0x03
	.byte 0x91,0xc0,0x73,0x04
	.ascii "index_save\0"
	.byte 0x00,0x00,0x96,0x5c,0x01,0x01,0xac,0x03
	.byte 0x91,0xc0,0x41,0x05,0x44,0x01,0x0c,0x00
	.byte 0x10,0x00,0x00,0x31,0xcc,0x06,0x40,0x00
	.byte 0x00,0x96,0x5c,0x11,0x00,0x00,0x01,0xf9
	.byte 0x06,0x3f,0x00,0x10,0x00,0x00,0x01,0xd5
	.byte 0x19,0x00,0x00,0x00,0x96,0x6f,0x11,0x00
	.byte 0x00,0x01,0xf9,0x06,0x3f,0x00,0x1a
	.ascii "gl_write_monoindex_span\0"
	.byte 0x01,0x02,0x01,0x01,0x02
	.uaword gl_write_monoindex_span
	.uaword gl_write_monoindex_span+2264
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x97,0x50
	.byte 0x03,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0xff,0x03,0x91,0xc4,0x00,0x1b,0x00
	.byte 0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x01,0x00,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x01,0x00,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x01,0x00,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x66,0x17
	.ascii "z\0"
	.byte 0x01,0x01,0x00,0x01,0x6c,0x1b,0x00,0x00
	.byte 0x01,0xd5
	.ascii "index\0"
	.byte 0x01,0x01,0x01,0x01,0x61,0x1b,0x00,0x00
	.byte 0x31,0xae
	.ascii "primitive\0"
	.byte 0x01,0x01,0x01,0x01,0x63,0x1c
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x01,0x03
	.byte 0x01,0x6d,0x1c
	.ascii "mask\0"
	.byte 0x00,0x00,0x97,0x50,0x01,0x01,0x01,0x04
	.byte 0x03,0x91,0xc0,0x73,0x1c
	.ascii "index_save\0"
	.byte 0x00,0x00,0x97,0x63,0x01,0x01,0x01,0x05
	.byte 0x04,0x91,0xc0,0x8f,0x7f,0x1c
	.ascii "ispan\0"
	.byte 0x00,0x00,0x97,0x76,0x01,0x01,0x01,0x30
	.byte 0x03,0x91,0xc0,0x41,0x05,0x44,0x01,0x0c
	.byte 0x00,0x10,0x00,0x00,0x31,0xcc,0x06,0x40
	.byte 0x00,0x00,0x97,0x63,0x11,0x00,0x00,0x01
	.byte 0xf9,0x06,0x3f,0x00,0x10,0x00,0x00,0x01
	.byte 0xd5,0x19,0x00,0x00,0x00,0x97,0x76,0x11
	.byte 0x00,0x00,0x01,0xf9,0x06,0x3f,0x00,0x10
	.byte 0x00,0x00,0x01,0xd5,0x19,0x00,0x00,0x00
	.byte 0x97,0x89,0x11,0x00,0x00,0x01,0xf9,0x06
	.byte 0x3f,0x00,0x1a
	.ascii "gl_write_color_span\0"
	.byte 0x01,0x02,0x01,0x01,0x6c
	.uaword gl_write_color_span
	.uaword gl_write_color_span+5308
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x99,0x16
	.byte 0x1b,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x01,0x67,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x01,0x68,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x01,0x68,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x01,0x68,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x66,0x17
	.ascii "z\0"
	.byte 0x01,0x01,0x68,0x01,0x6c,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "r\0"
	.byte 0x01,0x01,0x69,0x03,0x91,0xd8,0x00,0x1b
	.byte 0x00,0x00,0x31,0xda
	.ascii "g\0"
	.byte 0x01,0x01,0x69,0x01,0x63,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "b\0"
	.byte 0x01,0x01,0x6a,0x01,0x65,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "a\0"
	.byte 0x01,0x01,0x6a,0x03,0x91,0xe4,0x00,0x1b
	.byte 0x00,0x00,0x31,0xae
	.ascii "primitive\0"
	.byte 0x01,0x01,0x6b,0x01,0x67,0x1c
	.ascii "mask\0"
	.byte 0x00,0x00,0x99,0x16,0x01,0x01,0x01,0x6d
	.byte 0x03,0x91,0xc0,0x73,0x1c
	.ascii "write_all\0"
	.byte 0x00,0x00,0x33,0x1e,0x01,0x01,0x01,0x6e
	.byte 0x01,0x66,0x1c
	.ascii "rtmp\0"
	.byte 0x00,0x00,0x99,0x29,0x01,0x01,0x01,0x6f
	.byte 0x03,0x91,0x80,0x67,0x1c
	.ascii "gtmp\0"
	.byte 0x00,0x00,0x99,0x3c,0x01,0x01,0x01,0x6f
	.byte 0x03,0x91,0xc0,0x5a,0x1c
	.ascii "btmp\0"
	.byte 0x00,0x00,0x99,0x4f,0x01,0x01,0x01,0x6f
	.byte 0x03,0x91,0x80,0x4e,0x1c
	.ascii "atmp\0"
	.byte 0x00,0x00,0x99,0x62,0x01,0x01,0x01,0x6f
	.byte 0x03,0x91,0xc0,0x41,0x1c
	.ascii "red\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x01,0x70
	.byte 0x01,0x61,0x1c
	.ascii "green\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x01,0x70
	.byte 0x01,0x60,0x1c
	.ascii "blue\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x01,0x70
	.byte 0x01,0x6d,0x1c
	.ascii "alpha\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x01,0x70
	.byte 0x01,0x62,0x1c
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x01,0xb6
	.byte 0x03,0x91,0xa8,0x41,0x05,0x42,0x14,0x10
	.byte 0xb0,0x02,0x30,0xf4,0x00,0x3c,0x08,0xa4
	.byte 0x09,0xc0,0x03,0xbc,0x08,0xcc,0x07,0x10
	.byte 0xa8,0x01,0x14,0x05,0x44,0x01,0x0c,0x00
	.byte 0x10,0x00,0x00,0x31,0xcc,0x06,0x40,0x00
	.byte 0x00,0x99,0x29,0x11,0x00,0x00,0x01,0xf9
	.byte 0x06,0x3f,0x00,0x10,0x00,0x00,0x31,0xcc
	.byte 0x06,0x40,0x00,0x00,0x99,0x3c,0x11,0x00
	.byte 0x00,0x01,0xf9,0x06,0x3f,0x00,0x10,0x00
	.byte 0x00,0x31,0xcc,0x06,0x40,0x00,0x00,0x99
	.byte 0x4f,0x11,0x00,0x00,0x01,0xf9,0x06,0x3f
	.byte 0x00,0x10,0x00,0x00,0x31,0xcc,0x06,0x40
	.byte 0x00,0x00,0x99,0x62,0x11,0x00,0x00,0x01
	.byte 0xf9,0x06,0x3f,0x00,0x10,0x00,0x00,0x31
	.byte 0xcc,0x06,0x40,0x00,0x00,0x99,0x75,0x11
	.byte 0x00,0x00,0x01,0xf9,0x06,0x3f,0x00,0x1a
	.ascii "gl_write_monocolor_span\0"
	.byte 0x01,0x02,0x01,0x02,0x04
	.uaword gl_write_monocolor_span
	.uaword gl_write_monocolor_span+3348
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9a,0xcf
	.byte 0x1b,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x02,0x00,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x02,0x01,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x02,0x01,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x02,0x01,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x66,0x17
	.ascii "z\0"
	.byte 0x01,0x02,0x01,0x01,0x6c,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "r\0"
	.byte 0x01,0x02,0x02,0x03,0x91,0xd8,0x00,0x1b
	.byte 0x00,0x00,0x01,0xac
	.ascii "g\0"
	.byte 0x01,0x02,0x02,0x01,0x6c,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "b\0"
	.byte 0x01,0x02,0x02,0x01,0x60,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "a\0"
	.byte 0x01,0x02,0x02,0x01,0x61,0x1b,0x00,0x00
	.byte 0x31,0xae
	.ascii "primitive\0"
	.byte 0x01,0x02,0x03,0x01,0x61,0x1c
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x02,0x05
	.byte 0x01,0x65,0x1c
	.ascii "mask\0"
	.byte 0x00,0x00,0x9a,0xcf,0x01,0x01,0x02,0x06
	.byte 0x03,0x91,0xc0,0x73,0x1c
	.ascii "write_all\0"
	.byte 0x00,0x00,0x33,0x1e,0x01,0x01,0x02,0x07
	.byte 0x01,0x62,0x1c
	.ascii "red\0"
	.byte 0x00,0x00,0x9a,0xe2,0x01,0x01,0x02,0x08
	.byte 0x03,0x91,0xc0,0x5a,0x1c
	.ascii "green\0"
	.byte 0x00,0x00,0x9a,0xf5,0x01,0x01,0x02,0x08
	.byte 0x03,0x91,0x80,0x4e,0x1c
	.ascii "blue\0"
	.byte 0x00,0x00,0x9b,0x08,0x01,0x01,0x02,0x08
	.byte 0x03,0x91,0xc0,0x41,0x1c
	.ascii "alpha\0"
	.byte 0x00,0x00,0x9b,0x1b,0x01,0x01,0x02,0x08
	.byte 0x04,0x91,0x80,0xb5,0x7f,0x1c
	.ascii "alpha\0"
	.byte 0x00,0x00,0x9b,0x2e,0x01,0x01,0x02,0x24
	.byte 0x03,0x91,0x80,0x67,0x1c
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x02,0x39
	.byte 0x04,0x91,0xf4,0xb4,0x7f,0x05,0x44,0x01
	.byte 0x0c,0x00,0x10,0x00,0x00,0x31,0xcc,0x06
	.byte 0x40,0x00,0x00,0x9a,0xe2,0x11,0x00,0x00
	.byte 0x01,0xf9,0x06,0x3f,0x00,0x10,0x00,0x00
	.byte 0x31,0xcc,0x06,0x40,0x00,0x00,0x9a,0xf5
	.byte 0x11,0x00,0x00,0x01,0xf9,0x06,0x3f,0x00
	.byte 0x10,0x00,0x00,0x31,0xcc,0x06,0x40,0x00
	.byte 0x00,0x9b,0x08,0x11,0x00,0x00,0x01,0xf9
	.byte 0x06,0x3f,0x00,0x10,0x00,0x00,0x31,0xcc
	.byte 0x06,0x40,0x00,0x00,0x9b,0x1b,0x11,0x00
	.byte 0x00,0x01,0xf9,0x06,0x3f,0x00,0x10,0x00
	.byte 0x00,0x31,0xcc,0x06,0x40,0x00,0x00,0x9b
	.byte 0x2e,0x11,0x00,0x00,0x01,0xf9,0x06,0x3f
	.byte 0x00,0x10,0x00,0x00,0x31,0xcc,0x06,0x40
	.byte 0x00,0x00,0x9b,0x41,0x11,0x00,0x00,0x01
	.byte 0xf9,0x06,0x3f,0x00,0x1a
	.ascii "gl_write_texture_span\0"
	.byte 0x01,0x02,0x01,0x02,0xaf
	.uaword gl_write_texture_span
	.uaword gl_write_texture_span+5380
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9d,0x11
	.byte 0x1b,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x02,0xa8,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x02,0xa9,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x02,0xa9,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x02,0xa9,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x66,0x17
	.ascii "z\0"
	.byte 0x01,0x02,0xa9,0x01,0x6c,0x1b,0x00,0x00
	.byte 0x91,0x60
	.ascii "s\0"
	.byte 0x01,0x02,0xaa,0x01,0x6d,0x1b,0x00,0x00
	.byte 0x91,0x60
	.ascii "t\0"
	.byte 0x01,0x02,0xaa,0x03,0x91,0xdc,0x00,0x1b
	.byte 0x00,0x00,0x91,0x60
	.ascii "u\0"
	.byte 0x01,0x02,0xaa,0x03,0x91,0xe0,0x00,0x1b
	.byte 0x00,0x00,0x91,0x60
	.ascii "lambda\0"
	.byte 0x01,0x02,0xab,0x03,0x91,0xe4,0x00,0x1b
	.byte 0x00,0x00,0x31,0xda
	.ascii "r\0"
	.byte 0x01,0x02,0xac,0x01,0x64,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "g\0"
	.byte 0x01,0x02,0xac,0x01,0x66,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "b\0"
	.byte 0x01,0x02,0xad,0x03,0x91,0xf0,0x00,0x1b
	.byte 0x00,0x00,0x31,0xda
	.ascii "a\0"
	.byte 0x01,0x02,0xad,0x03,0x91,0xf4,0x00,0x1b
	.byte 0x00,0x00,0x31,0xae
	.ascii "primitive\0"
	.byte 0x01,0x02,0xae,0x01,0x65,0x1c
	.ascii "mask\0"
	.byte 0x00,0x00,0x9d,0x11,0x01,0x01,0x02,0xb0
	.byte 0x03,0x91,0xc0,0x73,0x1c
	.ascii "write_all\0"
	.byte 0x00,0x00,0x33,0x1e,0x01,0x01,0x02,0xb1
	.byte 0x01,0x67,0x1c
	.ascii "rtmp\0"
	.byte 0x00,0x00,0x9d,0x24,0x01,0x01,0x02,0xb2
	.byte 0x03,0x91,0x80,0x67,0x1c
	.ascii "gtmp\0"
	.byte 0x00,0x00,0x9d,0x37,0x01,0x01,0x02,0xb2
	.byte 0x03,0x91,0xc0,0x5a,0x1c
	.ascii "btmp\0"
	.byte 0x00,0x00,0x9d,0x4a,0x01,0x01,0x02,0xb2
	.byte 0x03,0x91,0x80,0x4e,0x1c
	.ascii "atmp\0"
	.byte 0x00,0x00,0x9d,0x5d,0x01,0x01,0x02,0xb2
	.byte 0x03,0x91,0xc0,0x41,0x1c
	.ascii "red\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x02,0xb3
	.byte 0x01,0x62,0x1c
	.ascii "green\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x02,0xb3
	.byte 0x01,0x61,0x1c
	.ascii "blue\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x02,0xb3
	.byte 0x01,0x60,0x1c
	.ascii "alpha\0"
	.byte 0x00,0x00,0x31,0xda,0x01,0x01,0x02,0xb3
	.byte 0x01,0x63,0x1c
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x02,0xfd
	.byte 0x03,0x91,0xa8,0x41,0x05,0x42,0x1a,0xbc
	.byte 0x02,0x0c,0x30,0x10,0xec,0x00,0x0c,0x2c
	.byte 0x04,0xac,0x06,0x90,0x03,0xd0,0x10,0x10
	.byte 0xa8,0x01,0x14,0xcc,0x01,0x10,0xa0,0x01
	.byte 0x14,0x05,0x44,0x01,0x0c,0x00,0x10,0x00
	.byte 0x00,0x31,0xcc,0x06,0x40,0x00,0x00,0x9d
	.byte 0x24,0x11,0x00,0x00,0x01,0xf9,0x06,0x3f
	.byte 0x00,0x10,0x00,0x00,0x31,0xcc,0x06,0x40
	.byte 0x00,0x00,0x9d,0x37,0x11,0x00,0x00,0x01
	.byte 0xf9,0x06,0x3f,0x00,0x10,0x00,0x00,0x31
	.byte 0xcc,0x06,0x40,0x00,0x00,0x9d,0x4a,0x11
	.byte 0x00,0x00,0x01,0xf9,0x06,0x3f,0x00,0x10
	.byte 0x00,0x00,0x31,0xcc,0x06,0x40,0x00,0x00
	.byte 0x9d,0x5d,0x11,0x00,0x00,0x01,0xf9,0x06
	.byte 0x3f,0x00,0x10,0x00,0x00,0x31,0xcc,0x06
	.byte 0x40,0x00,0x00,0x9d,0x70,0x11,0x00,0x00
	.byte 0x01,0xf9,0x06,0x3f,0x00,0x1a
	.ascii "gl_read_color_span\0"
	.byte 0x01,0x02,0x01,0x03,0x43
	.uaword gl_read_color_span
	.uaword gl_read_color_span+852
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9e,0x1c
	.byte 0x1b,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x03,0x3f,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x03,0x40,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x03,0x40,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x03,0x40,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "red\0"
	.byte 0x01,0x03,0x41,0x01,0x61,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "green\0"
	.byte 0x01,0x03,0x41,0x01,0x67,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "blue\0"
	.byte 0x01,0x03,0x42,0x01,0x6d,0x1b,0x00,0x00
	.byte 0x31,0xda
	.ascii "alpha\0"
	.byte 0x01,0x03,0x42,0x01,0x6c,0x1c
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x03,0x44
	.byte 0x01,0x66,0x05,0x44,0x01,0x0c,0x00,0x1a
	.ascii "gl_read_index_span\0"
	.byte 0x01,0x02,0x01,0x03,0x70
	.uaword gl_read_index_span
	.uaword gl_read_index_span+368
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9e,0x9a
	.byte 0x1b,0x00,0x00,0x95,0x20
	.ascii "ctx\0"
	.byte 0x01,0x03,0x6e,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0xd5
	.ascii "n\0"
	.byte 0x01,0x03,0x6f,0x01,0x6d,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "x\0"
	.byte 0x01,0x03,0x6f,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0xac
	.ascii "y\0"
	.byte 0x01,0x03,0x6f,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x94,0x1b
	.ascii "indx\0"
	.byte 0x01,0x03,0x6f,0x01,0x6c,0x1c
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0xd5,0x01,0x01,0x03,0x71
	.byte 0x01,0x66,0x05,0x44,0x01,0x08,0x00,0x13
	.byte 0x00,0x00,0x01,0xe2,0x09,0x00,0x00,0x9e
	.byte 0x9a,0x13,0x00,0x00,0x01,0xe2,0x09,0x00
	.byte 0x00,0x9e,0xa4,0x13,0x00,0x00,0x01,0xe2
	.byte 0x09,0x00,0x00,0x9e,0xae,0x13,0x00,0x00
	.byte 0x01,0xe2,0x09,0x00,0x00,0x9e,0xb8,0x1d
	.ascii "gl_texture_pixels\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9f,0x10
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x9e,0x9f,0x15
	.byte 0x00,0x00,0x9e,0xa9,0x15,0x00,0x00,0x9e
	.byte 0xb3,0x15,0x00,0x00,0x9e,0xbd,0x15,0x00
	.byte 0x00,0x34,0xef,0x15,0x00,0x00,0x34,0xef
	.byte 0x15,0x00,0x00,0x34,0xef,0x15
	.byte 0x00,0x00,0x34,0xef,0x00,0x13,0x00,0x00
	.byte 0x48,0x7a,0x09,0x00,0x00,0x9f,0x10,0x1d
	.ascii "gl_depth_stencil_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9f,0x58
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x9f
	.byte 0x15,0x15,0x00,0x00,0x34,0xef,0x00,0x09
	.byte 0x00,0x00,0x35,0xf1,0x09,0x00,0x00,0x31
	.byte 0xbb,0x1e
	.ascii "gl_stencil_span\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0xac,0x01
	.byte 0x00,0x00,0x9f,0x99,0x15,0x00,0x00,0x9f
	.byte 0x58,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x01,0xac,0x15,0x00,0x00,0x01,0xac
	.byte 0x15,0x00,0x00,0x9f,0x5d,0x00,0x1e
	.ascii "gl_scissor_span\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0xac,0x01
	.byte 0x00,0x00,0x9f,0xd0,0x15,0x00,0x00,0x9f
	.byte 0x58,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0x01,0xac,0x15,0x00,0x00,0x01,0xac
	.byte 0x15,0x00,0x00,0x9f,0x5d,0x00,0x1d
	.ascii "gl_mask_index_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0x06
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x46
	.byte 0x22,0x00,0x1d
	.ascii "gl_mask_color_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0x4b
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x34
	.byte 0xef,0x15,0x00,0x00,0x34,0xef,0x15,0x00
	.byte 0x00,0x34,0xef,0x15,0x00,0x00,0x34,0xef
	.byte 0x00,0x1d
	.ascii "gl_logicop_rgba_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0x97
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x34
	.byte 0xef,0x15,0x00,0x00,0x34,0xef,0x15,0x00
	.byte 0x00,0x34,0xef,0x15,0x00,0x00,0x34,0xef
	.byte 0x15,0x00,0x00,0x34,0xef,0x00,0x1d
	.ascii "gl_logicop_ci_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0xd2
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x46
	.byte 0x22,0x15,0x00,0x00,0x34,0xef,0x00,0x13
	.byte 0x00,0x00,0x48,0x7a,0x09,0x00,0x00,0xa0
	.byte 0xd2,0x1d
	.ascii "gl_fog_index_pixels\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa1,0x0e
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0xa0,0xd7,0x15
	.byte 0x00,0x00,0x46,0x22,0x00,0x13,0x00,0x00
	.byte 0x48,0x7a,0x09,0x00,0x00,0xa1,0x0e,0x1d
	.ascii "gl_fog_color_pixels\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa1,0x59
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0xa1,0x13,0x15
	.byte 0x00,0x00,0x34,0xef,0x15,0x00,0x00,0x34
	.byte 0xef,0x15,0x00,0x00,0x34,0xef,0x15,0x00
	.byte 0x00,0x34,0xef,0x00,0x1d
	.ascii "gl_blend_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa1,0x9e
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x34
	.byte 0xef,0x15,0x00,0x00,0x34,0xef,0x15,0x00
	.byte 0x00,0x34,0xef,0x15,0x00,0x00,0x34,0xef
	.byte 0x15,0x00,0x00,0x34,0xef,0x00,0x1d
	.ascii "gl_read_alpha_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa1,0xd4
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x34
	.byte 0xef,0x00,0x1d
	.ascii "gl_write_mono_alpha_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa2,0x15
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x31
	.byte 0xbb,0x15,0x00,0x00,0x34,0xef,0x00,0x1d
	.ascii "gl_write_alpha_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa2,0x51
	.byte 0x15,0x00,0x00,0x3c,0xbe,0x15,0x00,0x00
	.byte 0x01,0xc9,0x15,0x00,0x00,0x01,0xa5,0x15
	.byte 0x00,0x00,0x01,0xa5,0x15,0x00,0x00,0x34
	.byte 0xef,0x15,0x00,0x00,0x34,0xef,0x00,0x13
	.byte 0x00,0x00,0x31,0xbb,0x09,0x00,0x00,0xa2
	.byte 0x51,0x1e
	.ascii "gl_alpha_test\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0xac,0x01
	.byte 0x00,0x00,0xa2,0x8b,0x15,0x00,0x00,0x9f
	.byte 0x58,0x15,0x00,0x00,0x01,0xc9,0x15,0x00
	.byte 0x00,0xa2,0x56,0x15,0x00,0x00,0x9f,0x5d
	.byte 0x00,0x1e
	.ascii "memset\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x31,0xe7,0x01
	.byte 0x00,0x00,0xa2,0xaf,0x15,0x00,0x00,0x31
	.byte 0xe7,0x15,0x00,0x00,0x01,0xa5,0x15,0x00
	.byte 0x00,0x01,0xc9,0x00,0x13,0x00,0x00,0x31
	.byte 0xdf,0x09,0x00,0x00,0xa2,0xaf,0x1f
	.ascii "memcpy\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x31,0xe7,0x01
	.byte 0x15,0x00,0x00,0x31,0xe7,0x15,0x00,0x00
	.byte 0xa2,0xb4,0x15,0x00,0x00,0x01,0xc9,0x00
	.byte 0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=113, siz=4, lab1=stipple_polygon_span, lab2=, loff=0
!   reloc[1]: knd=0, off=198, siz=4, lab1=clip_span, lab2=, loff=0
!   reloc[2]: knd=0, off=312, siz=4, lab1=gl_write_index_span, lab2=, loff=0
!   reloc[3]: knd=0, off=641, siz=4, lab1=gl_write_monoindex_span, lab2=, loff=0
!   reloc[4]: knd=0, off=1044, siz=4, lab1=gl_write_color_span, lab2=, loff=0
!   reloc[5]: knd=0, off=1577, siz=4, lab1=gl_write_monocolor_span, lab2=, loff=0
!   reloc[6]: knd=0, off=2212, siz=4, lab1=gl_write_texture_span, lab2=, loff=0
!   reloc[7]: knd=0, off=2715, siz=4, lab1=gl_read_color_span, lab2=, loff=0
!   reloc[8]: knd=0, off=2877, siz=4, lab1=gl_read_index_span, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x0b,0xb7,0x00,0x02,0x00,0x00
	.byte 0x00,0x64,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x73,0x70,0x61,0x6e,0x2e,0x63,0x00,0x01
	.byte 0x00,0x00,0x74,0x79,0x70,0x65,0x73,0x2e
	.byte 0x68,0x00,0x01,0x00,0x00,0x67,0x6c,0x2e
	.byte 0x68,0x00,0x02,0x00,0x00,0x64,0x64,0x2e
	.byte 0x68,0x00,0x01,0x00,0x00,0x00,0x00,0x05
	.byte 0x02
	.uaword stipple_polygon_span
	.byte 0x06,0x02,0x01,0x03,0xe7,0x00,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x20,0x0e,0x10,0x0e
	.byte 0x10,0x0e,0x14,0x0e,0x10,0x16,0x02,0x02
	.byte 0x03,0x03,0x01,0x38,0x02,0x02,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x02,0x03,0x7b,0x01
	.byte 0x18,0x0e,0x14,0x02,0x02,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7e,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x02,0x02,0x03,0x7b,0x01,0x18
	.byte 0x0e,0x02,0x02,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword clip_span
	.byte 0x06,0x02,0x01,0x03,0xff,0x00,0x01,0x10
	.byte 0x0e,0x02,0x05,0x03,0x05,0x01,0x02,0x05
	.byte 0x03,0x04,0x01,0x02,0x01,0x03,0x0f,0x01
	.byte 0x02,0x01,0x03,0x6f,0x01,0x11,0x02,0x02
	.byte 0x03,0x04,0x01,0x02,0x01,0x03,0x0b,0x01
	.byte 0x02,0x01,0x03,0x73,0x01,0x11,0x02,0x02
	.byte 0x03,0x06,0x01,0x02,0x01,0x03,0x05,0x01
	.byte 0x02,0x01,0x03,0x77,0x01,0x02,0x01,0x03
	.byte 0x04,0x01,0x02,0x01,0x03,0x05,0x01,0x02
	.byte 0x01,0x03,0x7b,0x01,0x14,0x14,0x0e,0x1a
	.byte 0x11,0x02,0x01,0x03,0x7e,0x01,0x20,0x02
	.byte 0x01,0x03,0x04,0x01,0x02,0x02,0x03,0x69
	.byte 0x01,0x02,0x01,0x03,0x17,0x01,0x02,0x02
	.byte 0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_index_span
	.byte 0x06,0x02,0x03,0x03,0xae,0x01,0x01,0x02
	.byte 0x02,0x03,0x7b,0x01,0x02,0x01,0x03,0x05
	.byte 0x01,0x21,0x02,0x01,0x03,0x7e,0x01,0x89
	.byte 0x02,0x01,0x03,0x7e,0x01,0x2d,0x02,0x0a
	.byte 0x03,0x4f,0x01,0x02,0x07,0x03,0x05,0x01
	.byte 0x02,0x07,0x03,0x04,0x01,0x02,0x03,0x03
	.byte 0x04,0x01,0x02,0x03,0x03,0x06,0x01,0x02
	.byte 0x03,0x03,0x1f,0x01,0x02,0x01,0x03,0x61
	.byte 0x01,0x02,0x01,0x03,0x1f,0x01,0x02,0x01
	.byte 0x03,0x62,0x01,0x14,0x0e,0x1a,0x11,0x02
	.byte 0x01,0x03,0x7e,0x01,0x20,0x02,0x02,0x03
	.byte 0x25,0x01,0x48,0x02,0x06,0x03,0x04,0x01
	.byte 0x1c,0x02,0x09,0x03,0x06,0x01,0x02,0x06
	.byte 0x03,0xa3,0x7f,0x01,0x02,0x02,0x03,0x7d
	.byte 0x01,0x20,0x0e,0x10,0x0e,0x10,0x0e,0x14
	.byte 0x16,0x14,0x11,0x02,0x0a,0x03,0xde,0x00
	.byte 0x01,0x02,0x01,0x03,0xa3,0x7f,0x01,0x02
	.byte 0x02,0x03,0x03,0x01,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x02,0x02
	.byte 0x03,0x7b,0x01,0x18,0x0e,0x02,0x01,0x03
	.byte 0xe1,0x00,0x01,0x02,0x01,0x03,0x9f,0x7f
	.byte 0x01,0x02,0x01,0x03,0xde,0x00,0x01,0x02
	.byte 0x01,0x03,0xa3,0x7f,0x01,0x02,0x02,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x02,0x02,0x03,0x7b
	.byte 0x01,0x18,0x02,0x01,0x03,0xe0,0x00,0x01
	.byte 0x1d,0x02,0x08,0x03,0x04,0x01,0x02,0x08
	.byte 0x03,0x07,0x01,0x02,0x01,0x03,0x7b,0x01
	.byte 0x1d,0x02,0x0b,0x03,0x03,0x01,0x02,0x03
	.byte 0x03,0x05,0x01,0x02,0x02,0x03,0x04,0x01
	.byte 0x02,0x32,0x03,0x03,0x01,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x03,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x27,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x02,0x04
	.byte 0x03,0x03,0x01,0x02,0x04,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7e,0x01,0x29,0x18,0x02
	.byte 0x06,0x03,0x04,0x01,0x02,0x08,0x03,0x03
	.byte 0x01,0x19,0x1c,0xd4,0x0e,0x18,0x0e,0xb8
	.byte 0x0e,0x14,0x18,0x29,0x18,0x25,0x2c,0x02
	.byte 0x04,0x03,0xbb,0x7f,0x01,0x02,0x02,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_monoindex_span
	.byte 0x06,0x02,0x03,0x03,0x87,0x02,0x01,0x1b
	.byte 0x21,0x02,0x01,0x03,0x7e,0x01,0x89,0x02
	.byte 0x01,0x03,0x7e,0x01,0x2d,0x02,0x0a,0x03
	.byte 0xf6,0x7e,0x01,0x02,0x07,0x03,0x05,0x01
	.byte 0x02,0x07,0x03,0x04,0x01,0x02,0x03,0x03
	.byte 0x04,0x01,0x02,0x03,0x03,0x06,0x01,0x02
	.byte 0x03,0x03,0xf8,0x00,0x01,0x02,0x01,0x03
	.byte 0x88,0x7f,0x01,0x02,0x01,0x03,0xf8,0x00
	.byte 0x01,0x02,0x01,0x03,0x89,0x7f,0x01,0x14
	.byte 0x0e,0x1a,0x11,0x02,0x01,0x03,0x7e,0x01
	.byte 0x20,0x02,0x02,0x03,0xfd,0x00,0x01,0x1c
	.byte 0x02,0x09,0x03,0x06,0x01,0x02,0x06,0x03
	.byte 0xd0,0x7e,0x01,0x02,0x02,0x03,0x7d,0x01
	.byte 0x20,0x0e,0x10,0x0e,0x10,0x0e,0x14,0x16
	.byte 0x14,0x11,0x02,0x0a,0x03,0xb1,0x01,0x01
	.byte 0x02,0x01,0x03,0xd0,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x02,0x01,0x03,0x03,0x01,0x02,0x02,0x03
	.byte 0x7b,0x01,0x18,0x0e,0x02,0x01,0x03,0xb4
	.byte 0x01,0x01,0x02,0x01,0x03,0xcc,0x7e,0x01
	.byte 0x02,0x01,0x03,0xb1,0x01,0x01,0x02,0x01
	.byte 0x03,0xd0,0x7e,0x01,0x02,0x02,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x02,0x03,0x7b,0x01
	.byte 0x18,0x02,0x01,0x03,0xb3,0x01,0x01,0x21
	.byte 0x02,0x08,0x03,0x04,0x01,0x02,0x08,0x03
	.byte 0x07,0x01,0x02,0x01,0x03,0x7b,0x01,0x1d
	.byte 0x02,0x0b,0x03,0x03,0x01,0x02,0x03,0x03
	.byte 0x06,0x01,0x02,0x0e,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x08,0x03,0x2b
	.byte 0x01,0x29,0x19,0x1c,0x28,0x02,0x04,0x03
	.byte 0xac,0x7f,0x01,0x02,0x02,0x03,0x26,0x01
	.byte 0x6c,0x16,0x1c,0x0e,0x14,0x12,0x02,0x02
	.byte 0x03,0x05,0x01,0x02,0x01,0x03,0x7b,0x01
	.byte 0x10,0x0e,0x14,0x0e,0x10,0x0e,0x02,0x01
	.byte 0x03,0x05,0x01,0x02,0x0c,0x03,0x04,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x08,0x03
	.byte 0x03,0x01,0x18,0x02,0x30,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x03,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7d,0x01,0x02
	.byte 0x29,0x03,0x03,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x02,0x04,0x03,0x03,0x01,0x02,0x04
	.byte 0x03,0x04,0x01,0x02,0x01,0x03,0x7d,0x01
	.byte 0x02,0x0a,0x03,0x03,0x01,0x18,0x02,0x09
	.byte 0x03,0x03,0x01,0x39,0x19,0x1c,0x58,0x16
	.byte 0x1c,0x0e,0x14,0x12,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x10,0x0e
	.byte 0x14,0x0e,0x10,0x11,0x18,0x35,0x18,0x31
	.byte 0x38,0x02,0x04,0x03,0xb6,0x7f,0x01,0x02
	.byte 0x02,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_color_span
	.byte 0x06,0x02,0x03,0x03,0xf2,0x02,0x01,0x02
	.byte 0x01,0x03,0x79,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x01,0x03,0x79,0x01,0x02,0x01
	.byte 0x03,0x07,0x01,0xcd,0x02,0x08,0x03,0x79
	.byte 0x01,0x02,0x01,0x03,0x92,0x7e,0x01,0x02
	.byte 0x07,0x03,0x05,0x01,0x02,0x06,0x03,0x0e
	.byte 0x01,0x02,0x02,0x03,0xe6,0x01,0x01,0x02
	.byte 0x01,0x03,0x9a,0x7e,0x01,0x02,0x02,0x03
	.byte 0x74,0x01,0x02,0x01,0x03,0xf6,0x01,0x01
	.byte 0x02,0x01,0x03,0x8c,0x7e,0x01,0x02,0x03
	.byte 0x03,0x04,0x01,0x02,0x03,0x03,0x06,0x01
	.byte 0x02,0x01,0x03,0x7a,0x01,0x02,0x04,0x03
	.byte 0x06,0x01,0x02,0x01,0x03,0xe6,0x01,0x01
	.byte 0x02,0x01,0x03,0x9a,0x7e,0x01,0x02,0x02
	.byte 0x03,0xe3,0x01,0x01,0x02,0x02,0x03,0x9e
	.byte 0x7e,0x01,0x14,0x0e,0x1a,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x20,0x02,0x01,0x03,0xe5
	.byte 0x01,0x01,0x02,0x02,0x03,0x04,0x01,0x02
	.byte 0x01,0x03,0x71,0x01,0x02,0x04,0x03,0x0f
	.byte 0x01,0x2d,0x02,0x01,0x03,0x7e,0x01,0x02
	.byte 0x04,0x03,0x0c,0x01,0x02,0x01,0x03,0x76
	.byte 0x01,0xc0,0x0e,0x18,0x0e,0xb0,0x0e,0x14
	.byte 0xd8,0x0e,0x18,0x0e,0xb0,0x0e,0x1c,0xd8
	.byte 0x0e,0x18,0x0e,0xa8,0x0e,0x1c,0x02,0x31
	.byte 0x03,0x04,0x01,0x02,0x01,0x03,0x7c,0x01
	.byte 0x02,0x03,0x03,0x04,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x02,0x29,0x03,0x04,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x04,0x03,0x04
	.byte 0x01,0x16,0x16,0x16,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x0b,0x01,0x02,0x01
	.byte 0x03,0x79,0x01,0x10,0x10,0x02,0x01,0x03
	.byte 0x05,0x01,0x02,0x15,0x03,0x05,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x08,0x03,0x04
	.byte 0x01,0x1c,0x02,0x08,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x02,0x06,0x03,0xca
	.byte 0x7d,0x01,0x02,0x02,0x03,0x7d,0x01,0x20
	.byte 0x0e,0x10,0x0e,0x10,0x0e,0x14,0x16,0x14
	.byte 0x11,0x34,0x02,0x02,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7e,0x01,0x02,0x02,0x03,0x03
	.byte 0x01,0x02,0x02,0x03,0x7b,0x01,0x18,0x0e
	.byte 0x02,0x01,0x03,0xb8,0x02,0x01,0x02,0x01
	.byte 0x03,0xc8,0x7d,0x01,0x10,0x02,0x02,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7e,0x01,0x02
	.byte 0x02,0x03,0x03,0x01,0x02,0x02,0x03,0x7b
	.byte 0x01,0x18,0x02,0x01,0x03,0xb7,0x02,0x01
	.byte 0x02,0x01,0x03,0x04,0x01,0x20,0x02,0x07
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x1d,0x02,0x08,0x03,0x04,0x01,0x20,0x0e
	.byte 0x14,0x02,0x01,0x03,0x0d,0x01,0x02,0x01
	.byte 0x03,0x75,0x01,0x21,0x30,0x02,0x01,0x03
	.byte 0x04,0x01,0x02,0x07,0x03,0x04,0x01,0x02
	.byte 0x05,0x03,0x06,0x01,0x20,0x02,0x0e,0x03
	.byte 0x07,0x01,0x02,0x01,0x03,0x7b,0x01,0x20
	.byte 0x02,0x0d,0x03,0x04,0x01,0x20,0x02,0x09
	.byte 0x03,0x05,0x01,0x40,0x20,0x02,0x03,0x03
	.byte 0x7e,0x01,0x40,0x20,0x02,0x0a,0x03,0x03
	.byte 0x01,0x15,0xc0,0x0e,0x18,0x0e,0xb0,0x0e
	.byte 0x14,0xd8,0x0e,0x18,0x0e,0xa8,0x0e,0x1c
	.byte 0xd0,0x0e,0x18,0x0e,0xb0,0x0e,0x1c,0xd4
	.byte 0x0e,0x18,0x0e,0xb4,0x0e,0x1c,0x1c,0x18
	.byte 0x02,0x0e,0x03,0x05,0x01,0x02,0x01,0x03
	.byte 0x7d,0x01,0x20,0x41,0x18,0x02,0x09,0x03
	.byte 0x03,0x01,0x40,0x21,0x0e,0x18,0x02,0x02
	.byte 0x03,0x7d,0x01,0x40,0x21,0x0e,0x10,0x0e
	.byte 0x14,0x20,0x19,0x02,0x04,0x03,0x88,0x7f
	.byte 0x01,0x02,0x02,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_write_monocolor_span
	.byte 0x06,0x02,0x03,0x03,0x8a,0x04,0x01,0x02
	.byte 0x03,0x03,0x79,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x21,0x02,0x01,0x03,0x7e,0x01,0x89
	.byte 0x02,0x01,0x03,0x7e,0x01,0x2d,0x02,0x09
	.byte 0x03,0x7a,0x01,0x02,0x01,0x03,0xf9,0x7c
	.byte 0x01,0x02,0x07,0x03,0x05,0x01,0x02,0x06
	.byte 0x03,0x8c,0x03,0x01,0x02,0x01,0x03,0xf8
	.byte 0x7c,0x01,0x02,0x03,0x03,0x04,0x01,0x02
	.byte 0x03,0x03,0x06,0x01,0x02,0x02,0x03,0xfe
	.byte 0x02,0x01,0x02,0x01,0x03,0x82,0x7d,0x01
	.byte 0x02,0x02,0x03,0xfb,0x02,0x01,0x02,0x02
	.byte 0x03,0x86,0x7d,0x01,0x14,0x0e,0x1a,0x11
	.byte 0x02,0x01,0x03,0x7e,0x01,0x20,0x02,0x01
	.byte 0x03,0xfd,0x02,0x01,0x02,0x02,0x03,0x04
	.byte 0x01,0x1c,0x02,0x08,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x02,0x07,0x03,0xcb
	.byte 0x7c,0x01,0x02,0x02,0x03,0x7d,0x01,0x20
	.byte 0x0e,0x10,0x0e,0x10,0x0e,0x14,0x16,0x14
	.byte 0x11,0x30,0x02,0x01,0x03,0xb6,0x03,0x01
	.byte 0x02,0x02,0x03,0xca,0x7c,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x02,0x01,0x03,0x03,0x01,0x02,0x02,0x03
	.byte 0x7b,0x01,0x18,0x02,0x01,0x03,0xba,0x03
	.byte 0x01,0x02,0x04,0x03,0x7c,0x01,0x02,0x03
	.byte 0x03,0x0f,0x01,0x02,0x01,0x03,0xba,0x7c
	.byte 0x01,0x10,0x02,0x02,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7e,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x02,0x03,0x7b,0x01,0x18,0x02
	.byte 0x01,0x03,0xba,0x03,0x01,0x02,0x04,0x03
	.byte 0x7c,0x01,0x02,0x03,0x03,0x0f,0x01,0x02
	.byte 0x01,0x03,0x75,0x01,0x02,0x04,0x03,0x7c
	.byte 0x01,0x02,0x01,0x03,0x06,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x77,0x01
	.byte 0x02,0x02,0x03,0x0f,0x01,0x02,0x01,0x03
	.byte 0x75,0x01,0x02,0x06,0x03,0x0b,0x01,0x02
	.byte 0x01,0x03,0x77,0x01,0x60,0x12,0x10,0x0e
	.byte 0x1c,0x0e,0x14,0x12,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x14,0x0e
	.byte 0x10,0x12,0x02,0x03,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7e,0x01,0x0e,0x18,0x11,0x02
	.byte 0x07,0x03,0x03,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x1d,0x02,0x08,0x03,0x04,0x01,0x28
	.byte 0x02,0x02,0x03,0x0d,0x01,0x02,0x01,0x03
	.byte 0x75,0x01,0x1d,0x30,0x02,0x01,0x03,0x04
	.byte 0x01,0x02,0x07,0x03,0x04,0x01,0x02,0x03
	.byte 0x03,0x06,0x01,0x02,0x0c,0x03,0x3e,0x01
	.byte 0x28,0x18,0x41,0x15,0x1c,0x28,0x1c,0x02
	.byte 0x03,0x03,0x03,0x01,0x02,0x01,0x03,0x7e
	.byte 0x01,0x15,0x02,0x01,0x03,0x7e,0x01,0x11
	.byte 0x34,0x02,0x03,0x03,0xfc,0x7e,0x01,0x02
	.byte 0x07,0x03,0x3b,0x01,0x9c,0x0e,0x10,0x12
	.byte 0x11,0x10,0x10,0x10,0x02,0x01,0x03,0x7b
	.byte 0x01,0x28,0x0e,0x02,0x01,0x03,0x09,0x01
	.byte 0x02,0x01,0x03,0x77,0x01,0x02,0x02,0x03
	.byte 0x09,0x01,0x02,0x01,0x03,0x77,0x01,0x1c
	.byte 0x0e,0x14,0x0e,0x10,0x14,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x03,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x01,0x03,0x09
	.byte 0x01,0x02,0x01,0x03,0x77,0x01,0x02,0x02
	.byte 0x03,0x09,0x01,0x20,0x02,0x15,0x03,0x07
	.byte 0x01,0x02,0x01,0x03,0x7b,0x01,0x1c,0x02
	.byte 0x14,0x03,0x04,0x01,0x1c,0x02,0x11,0x03
	.byte 0x05,0x01,0x60,0x18,0x02,0x03,0x03,0x7e
	.byte 0x01,0x5c,0x18,0x02,0x0b,0x03,0x03,0x01
	.byte 0x15,0x8c,0x0e,0x10,0x12,0x11,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7b,0x01,0x28,0x0e
	.byte 0x02,0x01,0x03,0x08,0x01,0x02,0x01,0x03
	.byte 0x78,0x01,0x10,0x18,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x03,0x03,0x7e
	.byte 0x01,0x18,0x02,0x01,0x03,0x07,0x01,0x1c
	.byte 0x20,0x02,0x15,0x03,0x05,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x1c,0x5d,0x18,0x02,0x11
	.byte 0x03,0x03,0x01,0x60,0x1c,0x02,0x03,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7e,0x01,0x19
	.byte 0x02,0x02,0x03,0x7b,0x01,0x5c,0x1c,0x02
	.byte 0x03,0x03,0x03,0x01,0x02,0x01,0x03,0x7e
	.byte 0x01,0x11,0x02,0x01,0x03,0x7e,0x01,0x15
	.byte 0x2c,0x02,0x03,0x03,0x8e,0x7f,0x01,0x02
	.byte 0x02,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_texture_span
	.byte 0x06,0x02,0x03,0x03,0xb5,0x05,0x01,0x02
	.byte 0x02,0x03,0x79,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0xc9,0x02,0x08,0x03,0x79,0x01,0x02
	.byte 0x01,0x03,0xcf,0x7b,0x01,0x02,0x07,0x03
	.byte 0x05,0x01,0x02,0x06,0x03,0x0e,0x01,0x02
	.byte 0x01,0x03,0xa9,0x04,0x01,0x02,0x01,0x03
	.byte 0xd7,0x7b,0x01,0x02,0x06,0x03,0x74,0x01
	.byte 0x02,0x01,0x03,0xb9,0x04,0x01,0x02,0x01
	.byte 0x03,0xc9,0x7b,0x01,0x02,0x03,0x03,0x04
	.byte 0x01,0x02,0x03,0x03,0x06,0x01,0x02,0x01
	.byte 0x03,0x7a,0x01,0x02,0x07,0x03,0x06,0x01
	.byte 0x02,0x01,0x03,0xa9,0x04,0x01,0x02,0x01
	.byte 0x03,0xd7,0x7b,0x01,0x02,0x02,0x03,0xa6
	.byte 0x04,0x01,0x02,0x02,0x03,0xdb,0x7b,0x01
	.byte 0x14,0x0e,0x1a,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x20,0x02,0x01,0x03,0xa8,0x04,0x01
	.byte 0x02,0x02,0x03,0x04,0x01,0x02,0x01,0x03
	.byte 0x71,0x01,0x02,0x07,0x03,0x0f,0x01,0x02
	.byte 0x09,0x03,0x0f,0x01,0x0e,0x0e,0x0e,0x02
	.byte 0x01,0x03,0x03,0x01,0x02,0x01,0x03,0x05
	.byte 0x01,0x02,0x01,0x03,0x6e,0x01,0xc0,0x0e
	.byte 0x18,0x0e,0xb0,0x0e,0x14,0xd8,0x0e,0x18
	.byte 0x0e,0xb0,0x0e,0x1c,0xd0,0x0e,0x18,0x0e
	.byte 0xb0,0x0e,0x1c,0xcc,0x0e,0x18,0x0e,0xa8
	.byte 0x0e,0x1c,0x10,0x18,0x18,0x02,0x02,0x03
	.byte 0x0b,0x01,0x02,0x01,0x03,0x75,0x01,0x02
	.byte 0x01,0x03,0x0b,0x01,0x02,0x0d,0x03,0x04
	.byte 0x01,0x02,0x14,0x03,0x05,0x01,0x02,0x01
	.byte 0x03,0x7c,0x01,0x02,0x08,0x03,0x04,0x01
	.byte 0x1c,0x02,0x08,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x04,0x01,0x02,0x06,0x03,0x83,0x7b
	.byte 0x01,0x02,0x02,0x03,0x7d,0x01,0x20,0x0e
	.byte 0x10,0x0e,0x10,0x0e,0x14,0x16,0x14,0x11
	.byte 0x34,0x02,0x02,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x02,0x02,0x03,0x7b,0x01,0x18,0x0e,0x02
	.byte 0x01,0x03,0xff,0x04,0x01,0x02,0x01,0x03
	.byte 0x81,0x7b,0x01,0x10,0x02,0x02,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x02,0x03,0x7b,0x01
	.byte 0x18,0x02,0x01,0x03,0xfe,0x04,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x20,0x02,0x07,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x03,0x01,0x1d
	.byte 0x02,0x08,0x03,0x04,0x01,0x20,0x0e,0x14
	.byte 0x02,0x01,0x03,0x0d,0x01,0x02,0x01,0x03
	.byte 0x75,0x01,0x21,0x30,0x02,0x01,0x03,0x04
	.byte 0x01,0x02,0x07,0x03,0x04,0x01,0x02,0x05
	.byte 0x03,0x06,0x01,0x20,0x02,0x0e,0x03,0x06
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x1c,0x02
	.byte 0x0d,0x03,0x03,0x01,0x20,0x02,0x09,0x03
	.byte 0x05,0x01,0x40,0x20,0x02,0x03,0x03,0x7e
	.byte 0x01,0x40,0x20,0x02,0x0a,0x03,0x03,0x01
	.byte 0x15,0xc0,0x0e,0x18,0x0e,0xb0,0x0e,0x14
	.byte 0xd8,0x0e,0x18,0x0e,0xb0,0x0e,0x1c,0xd8
	.byte 0x0e,0x18,0x0e,0xa8,0x0e,0x1c,0xd4,0x0e
	.byte 0x18,0x0e,0xb4,0x0e,0x1c,0x1c,0x18,0x02
	.byte 0x0e,0x03,0x05,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x20,0x41,0x18,0x02,0x09,0x03,0x03
	.byte 0x01,0x40,0x1c,0x21,0x0e,0x18,0x02,0x02
	.byte 0x03,0x7c,0x01,0x40,0x10,0x0e,0x18,0x1d
	.byte 0x0e,0x10,0x0e,0x14,0x20,0x02,0x03,0x03
	.byte 0x86,0x7f,0x01,0x02,0x02,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_read_color_span
	.byte 0x06,0x02,0x03,0x03,0xc5,0x06,0x01,0x13
	.byte 0x1d,0x02,0x01,0x03,0x7e,0x01,0x19,0x02
	.byte 0x01,0x03,0x05,0x01,0x02,0x01,0x03,0x7b
	.byte 0x01,0x02,0x01,0x03,0x05,0x01,0x02,0x04
	.byte 0x03,0x08,0x01,0x02,0x01,0x03,0x7a,0x01
	.byte 0x34,0x24,0x02,0x02,0x03,0x06,0x01,0x02
	.byte 0x02,0x03,0x7e,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x18,0x10,0x02,0x01,0x03,0x7e,0x01
	.byte 0x0e,0x02,0x01,0x03,0x04,0x01,0x02,0x01
	.byte 0x03,0x7c,0x01,0x14,0x0e,0x02,0x03,0x03
	.byte 0x07,0x01,0x02,0x01,0x03,0x79,0x01,0x02
	.byte 0x02,0x03,0x07,0x01,0x10,0x1a,0x14,0x1c
	.byte 0x0e,0x10,0x0e,0x18,0x1c,0x02,0x02,0x03
	.byte 0x67,0x01,0x02,0x45,0x03,0x01,0x01,0x12
	.byte 0x14,0x22,0x14,0x0e,0x14,0x0e,0x14,0x42
	.byte 0x10,0x0e,0x14,0x0e,0x10,0x0e,0x10,0x0e
	.byte 0x14,0x0e,0x10,0x0e,0x02,0x03,0x03,0x19
	.byte 0x01,0x02,0x02,0x03,0x67,0x01,0x10,0x1a
	.byte 0x18,0x02,0x01,0x03,0x18,0x01,0x02,0x02
	.byte 0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_read_index_span
	.byte 0x06,0x02,0x02,0x03,0xf2,0x06,0x01,0x13
	.byte 0x1d,0x02,0x01,0x03,0x7e,0x01,0x02,0x03
	.byte 0x03,0x07,0x01,0x02,0x05,0x03,0x05,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x03,0x03
	.byte 0x05,0x01,0x02,0x02,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x0e,0x11,0x10,0x02
	.byte 0x01,0x03,0x7c,0x01,0x10,0x0e,0x15,0x02
	.byte 0x01,0x03,0x7e,0x01,0x02,0x02,0x03,0x07
	.byte 0x01,0x02,0x01,0x03,0x79,0x01,0x02,0x01
	.byte 0x03,0x07,0x01,0x10,0x12,0x14,0x02,0x03
	.byte 0x03,0x6c,0x01,0x3c,0x0e,0x14,0x1e,0x14
	.byte 0x0e,0x10,0x0e,0x10,0x0e,0x14,0x0e,0x14
	.byte 0x0e,0x02,0x03,0x03,0x14,0x01,0x02,0x02
	.byte 0x03,0x6c,0x01,0x10,0x0e,0x14,0x0e,0x10
	.byte 0x02,0x01,0x03,0x13,0x01,0x02,0x02,0x00
	.byte 0x01,0x01
!  End sdCreateSection
!  Begin sdCreateSection : .debug_abbrev
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_abbrev"
	.byte 0x01,0x11,0x01,0x03,0x08,0x13,0x0b,0x1b
	.byte 0x08,0x85,0x44,0x08,0x87,0x44,0x08,0x25
	.byte 0x08,0x10,0x06,0x00,0x00,0x02,0x2e,0x01
	.byte 0x03,0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x0b
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x03
	.byte 0x05,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x04,0x34
	.byte 0x00,0x03,0x08,0x49,0x13,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x0b,0x02,0x0a,0x00,0x00,0x05
	.byte 0x86,0x84,0x01,0x00,0x92,0x44,0x0b,0x91
	.byte 0x44,0x09,0x00,0x00,0x06,0x24,0x00,0x03
	.byte 0x08,0x3e,0x0b,0x0b,0x0b,0x00,0x00,0x07
	.byte 0x16,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x00,0x00,0x08,0x13,0x00,0x03,0x08,0x3c
	.byte 0x0c,0x00,0x00,0x09,0x0f,0x00,0x49,0x13
	.byte 0x00,0x00,0x0a,0x01,0x01,0x49,0x13,0x0b
	.byte 0x0b,0x01,0x13,0x00,0x00,0x0b,0x21,0x00
	.byte 0x49,0x13,0x2f,0x0b,0x00,0x00,0x0c,0x04
	.byte 0x01,0x0b,0x0b,0x3a,0x0b,0x01,0x13,0x00
	.byte 0x00,0x0d,0x28,0x00,0x03,0x08,0x1c,0x0d
	.byte 0x00,0x00,0x0e,0x13,0x01,0x03,0x08,0x0b
	.byte 0x0b,0x3a,0x0b,0x01,0x13,0x00,0x00,0x0f
	.byte 0x0d,0x00,0x03,0x08,0x49,0x13,0x38,0x0a
	.byte 0x00,0x00,0x10,0x01,0x01,0x49,0x13,0x0b
	.byte 0x05,0x01,0x13,0x00,0x00,0x11,0x21,0x00
	.byte 0x49,0x13,0x2f,0x05,0x00,0x00,0x12,0x13
	.byte 0x01,0x03,0x08,0x0b,0x05,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x13,0x26,0x00,0x49,0x13
	.byte 0x00,0x00,0x14,0x15,0x01,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x15,0x05
	.byte 0x00,0x49,0x13,0x00,0x00,0x16,0x15,0x01
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x17,0x15,0x00,0x27,0x0c
	.byte 0x49,0x13,0x88,0x44,0x0b,0x00,0x00,0x18
	.byte 0x2e,0x01,0x03,0x08,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x11,0x01,0x12,0x01,0x40,0x0a
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x19,0x2e,0x01,0x03,0x08
	.byte 0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b,0x0b
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x1a
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12,0x01
	.byte 0x40,0x0a,0x27,0x0c,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x1b,0x05,0x00,0x49,0x13
	.byte 0x03,0x08,0x3a,0x0b,0x3b,0x05,0x02,0x0a
	.byte 0x00,0x00,0x1c,0x34,0x00,0x03,0x08,0x49
	.byte 0x13,0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x02
	.byte 0x0a,0x00,0x00,0x1d,0x2e,0x01,0x03,0x08
	.byte 0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x1e,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c
	.byte 0x49,0x13,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x1f,0x2e,0x01,0x03,0x08,0x3f,0x0c
	.byte 0x3c,0x0c,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0xc0,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa2,0xdc,0x00,0x00,0x95,0x96
	.byte 0x67,0x6c,0x5f,0x77,0x72,0x69,0x74,0x65
	.byte 0x5f,0x69,0x6e,0x64,0x65,0x78,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x96,0x6f
	.byte 0x67,0x6c,0x5f,0x77,0x72,0x69,0x74,0x65
	.byte 0x5f,0x6d,0x6f,0x6e,0x6f,0x69,0x6e,0x64
	.byte 0x65,0x78,0x5f,0x73,0x70,0x61,0x6e,0x00
	.byte 0x00,0x00,0x97,0x89,0x67,0x6c,0x5f,0x77
	.byte 0x72,0x69,0x74,0x65,0x5f,0x63,0x6f,0x6c
	.byte 0x6f,0x72,0x5f,0x73,0x70,0x61,0x6e,0x00
	.byte 0x00,0x00,0x99,0x75,0x67,0x6c,0x5f,0x77
	.byte 0x72,0x69,0x74,0x65,0x5f,0x6d,0x6f,0x6e
	.byte 0x6f,0x63,0x6f,0x6c,0x6f,0x72,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x9b,0x41
	.byte 0x67,0x6c,0x5f,0x77,0x72,0x69,0x74,0x65
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x73,0x70,0x61,0x6e,0x00,0x00,0x00
	.byte 0x9d,0x70,0x67,0x6c,0x5f,0x72,0x65,0x61
	.byte 0x64,0x5f,0x63,0x6f,0x6c,0x6f,0x72,0x5f
	.byte 0x73,0x70,0x61,0x6e,0x00,0x00,0x00,0x9e
	.byte 0x1c,0x67,0x6c,0x5f,0x72,0x65,0x61,0x64
	.byte 0x5f,0x69,0x6e,0x64,0x65,0x78,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0x38,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa2,0xdc,0x00,0x00,0x00,0xfc
	.byte 0x73,0x74,0x69,0x70,0x70,0x6c,0x65,0x5f
	.byte 0x70,0x6f,0x6c,0x79,0x67,0x6f,0x6e,0x5f
	.byte 0x73,0x70,0x61,0x6e,0x00,0x00,0x00,0x95
	.byte 0x25,0x63,0x6c,0x69,0x70,0x5f,0x73,0x70
	.byte 0x61,0x6e,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x24,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa2,0xdc,0x00,0x00,0x01,0xac
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x01,0xd5,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x01,0xeb,0x47,0x4c,0x66
	.byte 0x6c,0x6f,0x61,0x74,0x00,0x00,0x00,0x02
	.byte 0x12,0x00,0x00,0x00,0x31,0xae,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x31
	.byte 0xcc,0x47,0x4c,0x75,0x62,0x79,0x74,0x65
	.byte 0x00,0x00,0x00,0x31,0xec,0x67,0x6c,0x5f
	.byte 0x74,0x65,0x78,0x74,0x75,0x72,0x65,0x5f
	.byte 0x69,0x6d,0x61,0x67,0x65,0x00,0x00,0x00
	.byte 0x33,0x1e,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x35,0x33
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x33,0x2e,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x35,0x50,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x3d,0x74
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x3d,0x86,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x55,0xa9
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x64
	.byte 0x4d,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x65,0xf5,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x66,0x09,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x66,0x1c
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x66,0x3a,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x66,0x4d,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x67,0x24,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x6d,0x82
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0xb5
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0xeb,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6e,0x2a
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6e,0x60,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x70,0x47,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x75,0x7f,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x75
	.byte 0x95,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x75,0xf5,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x76,0x42
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x78,0x57,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x79,0x41
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x79,0x94,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7c,0x0a,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x7c,0x83,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7d,0x56,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x7f,0xfd,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x80
	.byte 0x9e,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x81
	.byte 0x8e,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0xaf,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x82,0xbe,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x83,0x37,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x84,0x1d
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x86,0xed,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x87,0x66
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x88,0xaa,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x88,0xb8,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x89,0x13
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8a,0x6d,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0xcf,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8d,0x49,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x8e,0x06,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x90,0xb1,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x91,0x65
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x91,0xb9,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x92,0x33,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x93,0xbd,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x94,0x32,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x35,0xf1,0x67
	.byte 0x6c,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
	.byte 0x74,0x00,0x00,0x00,0x95,0x10,0x47,0x4c
	.byte 0x63,0x6f,0x6e,0x74,0x65,0x78,0x74,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)string.h\t1.27\t07/01/14 SMI"	! (/tmp/acompAAA.11240.nfaa9v:8)
	.ident	"@(#)string_iso.h\t1.5\t04/06/18 SMI"	! (/tmp/acompAAA.11240.nfaa9v:9)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11240.nfaa9v:10)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11240.nfaa9v:11)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11240.nfaa9v:12)
	.ident	"@(#)math.h\t2.24\t04/10/23 SMI"	! (/tmp/acompAAA.11240.nfaa9v:13)
	.ident	"@(#)math_iso.h\t1.9\t04/10/23 SMI"	! (/tmp/acompAAA.11240.nfaa9v:14)
	.ident	"@(#)math_c99.h\t1.9\t04/11/01 SMI"	! (/tmp/acompAAA.11240.nfaa9v:15)
	.ident	"@(#)floatingpoint.h\t2.9\t04/10/23 SMI"	! (/tmp/acompAAA.11240.nfaa9v:16)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11240.nfaa9v:17)
	.ident	"@(#)ieeefp.h\t2.12\t04/10/23 SMI"	! (/tmp/acompAAA.11240.nfaa9v:18)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11240.nfaa9v:19)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11240.nfaa9v:20)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
