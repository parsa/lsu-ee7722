
	.section	".text",#alloc,#execinstr,#progbits
	.file	"pixel.c"

	.section	".bss",#alloc,#write,#nobits

Bbss.bss:

	.section	".data",#alloc,#write,#progbits

Ddata.data:

	.section	".rodata",#alloc,#progbits
!
! CONSTANT POOL
!

Drodata.rodata:

	.section	".rodata1",#alloc,#progbits
	.align	4
!
! CONSTANT POOL
!

.L43:
	.ascii	"glPixelZoom\000"
	.align	4
!
! CONSTANT POOL
!

.L79:
	.ascii	"m <= MAX_WIDTH\000"
	.align	4
!
! CONSTANT POOL
!

.L80:
	.ascii	"pixel.c\000"
	.align	4
!
! CONSTANT POOL
!

.L137:
	.ascii	"m <= MAX_WIDTH\000"
	.align	4
!
! CONSTANT POOL
!

.L138:
	.ascii	"pixel.c\000"
	.align	4
!
! CONSTANT POOL
!

.L195:
	.ascii	"m <= MAX_WIDTH\000"
	.align	4
!
! CONSTANT POOL
!

.L196:
	.ascii	"pixel.c\000"
	.align	4
!
! CONSTANT POOL
!

.L225:
	.ascii	"glPixelStore\000"
	.align	4
!
! CONSTANT POOL
!

.L239:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L244:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L249:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L259:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L271:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L276:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L281:
	.ascii	"glPixelStore(param)\000"
	.align	4
!
! CONSTANT POOL
!

.L291:
	.ascii	"glPixelStore\000"
	.align	4
!
! CONSTANT POOL
!

.L293:
	.ascii	"glPixelStore\000"
	.align	4
!
! CONSTANT POOL
!

.L302:
	.ascii	"glPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L307:
	.ascii	"glPixelMapfv(mapsize)\000"
	.align	4
!
! CONSTANT POOL
!

.L320:
	.ascii	"glPixelMapfv(mapsize)\000"
	.align	4
!
! CONSTANT POOL
!

.L432:
	.ascii	"glPixelMapfv(map)\000"
	.align	4
!
! CONSTANT POOL
!

.L441:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L465:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L474:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L528:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L537:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L601:
	.ascii	"glGetPixelMapfv\000"
	.align	4
!
! CONSTANT POOL
!

.L610:
	.ascii	"glPixelTransfer\000"
	.align	4
!
! CONSTANT POOL
!

.L634:
	.ascii	"glPixelTransfer(pname)\000"
	.align	4
!
! CONSTANT POOL
!

.L643:
	.ascii	"internal error in gl_unpack(type)\000"
	.align	4
!
! CONSTANT POOL
!

.L646:
	.ascii	"gl_unpack_pixels(format)\000"

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000101:
/* 000000	   0 */		.word	1072693248,0
/* 0x0008	   0 */		.type	___const_seg_900000101,1
/* 0x0008	   0 */		.size	___const_seg_900000101,(.-___const_seg_900000101)
/* 0x0008	   0 */		.align	4
! FILE pixel.c

!    1		      !/* $Id: pixel.c,v 1.8 1997/07/24 01:23:44 brianp Exp $ */
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
!   25		      ! * $Log: pixel.c,v $
!   26		      ! * Revision 1.8  1997/07/24 01:23:44  brianp
!   27		      ! * changed precompiled header symbol from PCH to PC_HEADER
!   28		      ! *
!   29		      ! * Revision 1.7  1997/05/28 03:26:02  brianp
!   30		      ! * added precompiled header (PCH) support
!   31		      ! *
!   32		      ! * Revision 1.6  1997/02/09 20:05:03  brianp
!   33		      ! * new arguments for gl_pixel_addr_in_image()
!   34		      ! *
!   35		      ! * Revision 1.5  1997/02/09 18:52:37  brianp
!   36		      ! * added GL_EXT_texture3D support
!   37		      ! *
!   38		      ! * Revision 1.4  1996/11/06 04:09:37  brianp
!   39		      ! * added a missing return after a gl_error() call
!   40		      ! *
!   41		      ! * Revision 1.3  1996/09/26 22:35:10  brianp
!   42		      ! * fixed a few compiler warnings from IRIX 6 -n32 and -64 compiler
!   43		      ! *
!   44		      ! * Revision 1.2  1996/09/15 14:18:55  brianp
!   45		      ! * now use GLframebuffer and GLvisual
!   46		      ! *
!   47		      ! * Revision 1.1  1996/09/13 01:38:16  brianp
!   48		      ! * Initial revision
!   49		      ! *
!   50		      ! */
!   53		      !/*
!   54		      ! * glPixelStore, glPixelTransfer, glPixelMap, glPixelZoom, etc.
!   55		      ! */
!   58		      !#ifdef PC_HEADER
!   59		      !#include "all.h"
!   60		      !#else
!   61		      !#include <assert.h>
!   62		      !#include <stdio.h>
!   63		      !#include <stdlib.h>
!   64		      !#include <string.h>
!   65		      !#include "context.h"
!   66		      !#include "dlist.h"
!   67		      !#include "macros.h"
!   68		      !#include "pixel.h"
!   69		      !#include "image.h"
!   70		      !#include "span.h"
!   71		      !#include "stencil.h"
!   72		      !#include "types.h"
!   73		      !#endif
!   77		      !/*
!   78		      ! * Determine if we can use the optimized glDrawPixels function.
!   79		      ! */
!   80		      !static void update_drawpixels_state( GLcontext *ctx )
!   81		      !{
!   82		      !   if (ctx->Visual->RGBAflag==GL_TRUE &&
!   83		      !       ctx->Visual->EightBitColor &&
!   84		      !       ctx->Pixel.RedBias==0.0   && ctx->Pixel.RedScale==1.0 &&
!   85		      !       ctx->Pixel.GreenBias==0.0 && ctx->Pixel.GreenScale==1.0 &&
!   86		      !       ctx->Pixel.BlueBias==0.0  && ctx->Pixel.BlueScale==1.0 &&
!   87		      !       ctx->Pixel.AlphaBias==0.0 && ctx->Pixel.AlphaScale==1.0 &&
!   88		      !       ctx->Pixel.MapColorFlag==GL_FALSE &&
!   89		      !       ctx->Pixel.ZoomX==1.0 && ctx->Pixel.ZoomY==1.0 &&
!   90		      !/*       ctx->Unpack.Alignment==4 &&*/
!   91		      !       ctx->Unpack.RowLength==0 &&
!   92		      !       ctx->Unpack.SkipPixels==0 &&
!   93		      !       ctx->Unpack.SkipRows==0 &&
!   94		      !       ctx->Unpack.SwapBytes==0 &&
!   95		      !       ctx->Unpack.LsbFirst==0) {

!
! SUBROUTINE update_drawpixels_state
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       

			update_drawpixels_state:
/* 000000	  95 */		ld	[%o0+2200],%o3
/* 0x0004	     */		ldub	[%o3],%o5
/* 0x0008	     */		cmp	%o5,1
/* 0x000c	     */		bne,pn	%icc,.L900000108
/* 0x0010	  99 */		sethi	%hi(0xe000),%o5

! Registers live out of update_drawpixels_state: 
! o0 o3 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: update_drawpixels_state

			.L77002305:
/* 0x0014	  95 */		ldub	[%o3+20],%o2
/* 0x0018	     */		cmp	%o2,0
/* 0x001c	     */		be,pn	%icc,.L77002341
/* 0x0020	   0 */		sethi	%hi(0xac00),%g2

! Registers live out of .L77002305: 
! g2 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002305

			.L77002307:
/* 0x0024	  95 */		add	%g2,540,%o4
/* 0x0028	     */		ld	[%o0+%o4],%f16
/* 0x002c	     */		fzero	%f56
/* 0x0030	     */		fstod	%f16,%f54
/* 0x0034	     */		fcmpd	%fcc0,%f54,%f56
/* 0x0038	     */		fbne,pn	%fcc0,.L77002341
/* 0x003c	     */		add	%g2,544,%g3

! Registers live out of .L77002307: 
! g2 g3 o0 sp o7 fp gsr 
! f24 
		                       
! predecessor blocks: .L77002307

			.L77002309:
/* 0x0040	  95 */		ld	[%o0+%g3],%f14
/* 0x0044	   0 */		sethi	%hi(___const_seg_900000101),%o5
/* 0x0048	  95 */		ldd	[%o5+%lo(___const_seg_900000101)],%f50
/* 0x004c	     */		fstod	%f14,%f52
/* 0x0050	     */		fcmpd	%fcc1,%f52,%f50
/* 0x0054	     */		fbne,pn	%fcc1,.L77002341
/* 0x0058	     */		add	%g2,548,%g1

! Registers live out of .L77002309: 
! g1 g2 o0 sp o7 fp gsr 
! f18 f24 
		                       
! predecessor blocks: .L77002309

			.L77002311:
/* 0x005c	  95 */		ld	[%o0+%g1],%f12
/* 0x0060	     */		fstod	%f12,%f48
/* 0x0064	     */		fcmpd	%fcc2,%f48,%f56
/* 0x0068	     */		fbne,pn	%fcc2,.L77002341
/* 0x006c	     */		add	%g2,552,%g4

! Registers live out of .L77002311: 
! g2 g4 o0 sp o7 fp gsr 
! f18 f24 
		                       
! predecessor blocks: .L77002311

			.L77002313:
/* 0x0070	  95 */		ld	[%o0+%g4],%f10
/* 0x0074	     */		fstod	%f10,%f30
/* 0x0078	     */		fcmpd	%fcc3,%f30,%f50
/* 0x007c	     */		fbne,pn	%fcc3,.L77002341
/* 0x0080	     */		add	%g2,556,%g5

! Registers live out of .L77002313: 
! g2 g5 o0 sp o7 fp gsr 
! f18 f24 
		                       
! predecessor blocks: .L77002313

			.L77002315:
/* 0x0084	  95 */		ld	[%o0+%g5],%f8
/* 0x0088	     */		fstod	%f8,%f28
/* 0x008c	     */		fcmpd	%fcc0,%f28,%f56
/* 0x0090	     */		fbne,pn	%fcc0,.L77002341
/* 0x0094	     */		add	%g2,560,%o1

! Registers live out of .L77002315: 
! g2 o0 o1 sp o7 fp gsr 
! f18 f24 
		                       
! predecessor blocks: .L77002315

			.L77002317:
/* 0x0098	  95 */		ld	[%o0+%o1],%f6
/* 0x009c	     */		fstod	%f6,%f26
/* 0x00a0	     */		fcmpd	%fcc1,%f26,%f50
/* 0x00a4	     */		fbne,pn	%fcc1,.L77002341
/* 0x00a8	     */		add	%g2,564,%o2

! Registers live out of .L77002317: 
! g2 o0 o2 sp o7 fp gsr 
! f18 f24 
		                       
! predecessor blocks: .L77002317

			.L77002319:
/* 0x00ac	  95 */		ld	[%o0+%o2],%f4
/* 0x00b0	     */		fstod	%f4,%f24
/* 0x00b4	     */		fcmpd	%fcc2,%f24,%f56
/* 0x00b8	     */		fbne,pn	%fcc2,.L77002341
/* 0x00bc	     */		add	%g2,568,%o3

! Registers live out of .L77002319: 
! g2 o0 o3 sp o7 fp gsr 
! f18 
		                       
! predecessor blocks: .L77002319

			.L77002321:
/* 0x00c0	  95 */		ld	[%o0+%o3],%f2
/* 0x00c4	     */		fstod	%f2,%f22
/* 0x00c8	     */		fcmpd	%fcc3,%f22,%f50
/* 0x00cc	     */		fbne,pn	%fcc3,.L77002341
/* 0x00d0	     */		add	%g2,588,%o5

! Registers live out of .L77002321: 
! g2 o0 o5 sp o7 fp gsr 
! f18 
		                       
! predecessor blocks: .L77002321

			.L77002323:
/* 0x00d4	  95 */		ldub	[%o0+%o5],%o4
/* 0x00d8	     */		cmp	%o4,0
/* 0x00dc	     */		bne,pn	%icc,.L77002341
/* 0x00e0	     */		add	%g2,592,%g1

! Registers live out of .L77002323: 
! g1 g2 o0 sp o7 fp gsr 
! f18 
		                       
! predecessor blocks: .L77002323

			.L77002325:
/* 0x00e4	  95 */		ld	[%o0+%g1],%f0
/* 0x00e8	     */		fstod	%f0,%f20
/* 0x00ec	     */		fcmpd	%fcc0,%f20,%f50
/* 0x00f0	     */		fbne,pn	%fcc0,.L77002341
/* 0x00f4	     */		add	%g2,596,%g2

! Registers live out of .L77002325: 
! g2 o0 sp o7 fp gsr 
! f18 
		                       
! predecessor blocks: .L77002325

			.L77002327:
/* 0x00f8	  95 */		ld	[%o0+%g2],%f0
/* 0x00fc	     */		fstod	%f0,%f18
/* 0x0100	     */		fcmpd	%fcc1,%f18,%f50
/* 0x0104	     */		fbne,pn	%fcc1,.L77002341
/* 0x0108	   0 */		sethi	%hi(0xdc00),%g3

! Registers live out of .L77002327: 
! g3 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002327

			.L77002329:
/* 0x010c	  95 */		add	%g3,460,%g5
/* 0x0110	     */		ld	[%o0+%g5],%g4
/* 0x0114	     */		cmp	%g4,0
/* 0x0118	     */		bne,pn	%icc,.L77002341
/* 0x011c	     */		add	%g3,464,%o2

! Registers live out of .L77002329: 
! g3 o0 o2 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002329

			.L77002331:
/* 0x0120	  95 */		ld	[%o0+%o2],%o1
/* 0x0124	     */		cmp	%o1,0
/* 0x0128	     */		bne,pn	%icc,.L77002341
/* 0x012c	     */		add	%g3,468,%o4

! Registers live out of .L77002331: 
! g3 o0 o4 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002331

			.L77002333:
/* 0x0130	  95 */		ld	[%o0+%o4],%o3
/* 0x0134	     */		cmp	%o3,0
/* 0x0138	     */		bne,pn	%icc,.L77002341
/* 0x013c	     */		add	%g3,480,%g1

! Registers live out of .L77002333: 
! g1 g3 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002333

			.L77002335:
/* 0x0140	  95 */		ldub	[%o0+%g1],%o5
/* 0x0144	     */		cmp	%o5,0
/* 0x0148	     */		bne,pn	%icc,.L77002341
/* 0x014c	  96 */		add	%g3,481,%o3

! Registers live out of .L77002335: 
! o0 o3 sp o7 fp gsr 
! 
		
!   96		      !      ctx->FastDrawPixels = GL_TRUE;

                       
! predecessor blocks: .L77002335

			.L77002337:
/* 0x0150	  96 */		sethi	%hi(0xe000),%o2
/* 0x0154	     */		ldub	[%o0+%o3],%o1
/* 0x0158	     */		add	%o2,285,%g2
/* 0x015c	     */		sub	%g0,%o1,%g5
/* 0x0160	     */		srlx	%g5,63,%g4
/* 0x0164	     */		xor	%g4,1,%g3
/* 0x0168	  99 */		retl	! Result = 
/* 0x016c	  96 */		stb	%g3,[%o0+%g2]

!   97		      !   }
!   98		      !   else {
!   99		      !      ctx->FastDrawPixels = GL_FALSE;

                       
! predecessor blocks: .L77002305 .L77002307 .L77002309 .L77002311 .L77002313 .L77002315 .L77002317 .L77002319 .L77002321 .L77002323
! predecessor blocks: .L77002325 .L77002327 .L77002329 .L77002331 .L77002333 .L77002335

			.L77002341:
/* 0x0170	  99 */		sethi	%hi(0xe000),%o5

! Registers live out of .L77002341: 
! o0 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002341 update_drawpixels_state

			.L900000108:
/* 0x0174	  99 */		add	%o5,285,%o4
/* 0x0178	     */		retl	! Result = 
/* 0x017c	     */		stb	%g0,[%o0+%o4]
/* 0x0180	   0 */		.type	update_drawpixels_state,2
/* 0x0180	   0 */		.size	update_drawpixels_state,(.-update_drawpixels_state)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000201:
/* 000000	   0 */		.word	1072693248,0
/* 0x0008	   0 */		.type	___const_seg_900000201,1
/* 0x0008	   0 */		.size	___const_seg_900000201,(.-___const_seg_900000201)
/* 0x0008	   0 */		.align	4

!  100		      !   }
!  101		      !}
!  106		      !/**********************************************************************/
!  107		      !/*****                    glPixelZoom                             *****/
!  108		      !/**********************************************************************/
!  112		      !void gl_PixelZoom( GLcontext *ctx, GLfloat xfactor, GLfloat yfactor )
!  113		      !{
!  114		      !   if (INSIDE_BEGIN_END(ctx)) {

!
! SUBROUTINE gl_PixelZoom
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_PixelZoom
                       

			gl_PixelZoom:
/* 000000	 114 */		sethi	%hi(0xe000),%g5
/* 0x0004	     */		add	%g5,252,%o3
/* 0x0008	     */		sethi	%hi(0x1800),%o5
/* 0x000c	     */		add	%o5,512,%g4
/* 0x0010	 113 */		sllx	%o1,32,%o4
/* 0x0014	 114 */		ld	[%o0+%o3],%g3
/* 0x0018	 113 */		srl	%o2,0,%o5
/* 0x001c	     */		or	%o4,%o5,%o1
/* 0x0020	 114 */		cmp	%g3,%g4
/* 0x0024	     */		be,pn	%icc,.L77002384
/* 0x0028	 113 */		stx	%o1,[%sp+72]

! Registers live out of gl_PixelZoom: 
! g5 o0 o2 sp o7 fp gsr 
! 
		
!  115		      !      gl_error( ctx, GL_INVALID_OPERATION, "glPixelZoom" );

                       
! predecessor blocks: gl_PixelZoom

			.L77002382:
/* 0x002c	 115 */		sethi	%hi(.L43),%g5
/* 0x0030	     */		add	%g5,%lo(.L43),%o2
/* 0x0034	     */		or	%g0,%o7,%g1
/* 0x0038	     */		or	%g0,1282,%o1
/* 0x003c	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 	! (tail call)
/* 0x0040	     */		or	%g0,%g1,%o7
                       
! predecessor blocks: gl_PixelZoom

			.L77002384:
/* 0x0044	  95 */		ld	[%o0+2200],%g4

!  116		      !      return;

/* 0x0048	 116 */		ld	[%sp+72],%f2
/* 0x004c	   0 */		sethi	%hi(0xac00),%g2
/* 0x0050	  95 */		ldub	[%g4],%o3

!  117		      !   }
!  118		      !   ctx->Pixel.ZoomX = xfactor;
!  119		      !   ctx->Pixel.ZoomY = yfactor;

/* 0x0054	 119 */		add	%g2,596,%o4
/* 0x0058	     */		st	%o2,[%o0+%o4]
/* 0x005c	  95 */		cmp	%o3,1
/* 0x0060	 116 */		ld	[%sp+76],%f18
/* 0x0064	 118 */		add	%g2,592,%o1
/* 0x0068	  95 */		bne,pn	%icc,.L77002425
/* 0x006c	 118 */		st	%f2,[%o0+%o1]

! Registers live out of .L77002384: 
! g2 g4 g5 o0 sp o7 fp gsr 
! f2 f18 
		                       
! predecessor blocks: .L77002384

			.L77002389:
/* 0x0070	  95 */		ldub	[%g4+20],%o5
/* 0x0074	     */		cmp	%o5,0
/* 0x0078	     */		be,pn	%icc,.L77002425
/* 0x007c	     */		add	%g2,540,%g1

! Registers live out of .L77002389: 
! g1 g2 g5 o0 sp o7 fp gsr 
! f2 f18 
		                       
! predecessor blocks: .L77002389

			.L77002391:
/* 0x0080	  95 */		ld	[%o0+%g1],%f16
/* 0x0084	     */		fzero	%f54
/* 0x0088	     */		fstod	%f16,%f52
/* 0x008c	     */		fcmpd	%fcc2,%f52,%f54
/* 0x0090	     */		fbne,pn	%fcc2,.L77002425
/* 0x0094	     */		add	%g2,544,%g4

! Registers live out of .L77002391: 
! g2 g4 g5 o0 sp o7 fp gsr 
! f2 f18 f22 
		                       
! predecessor blocks: .L77002391

			.L77002393:
/* 0x0098	  95 */		ld	[%o0+%g4],%f14
/* 0x009c	   0 */		sethi	%hi(___const_seg_900000201),%g3
/* 0x00a0	  95 */		ldd	[%g3+%lo(___const_seg_900000201)],%f48
/* 0x00a4	     */		fstod	%f14,%f50
/* 0x00a8	     */		fcmpd	%fcc3,%f50,%f48
/* 0x00ac	     */		fbne,pn	%fcc3,.L77002425
/* 0x00b0	     */		add	%g2,548,%o1

! Registers live out of .L77002393: 
! g2 g5 o0 o1 sp o7 fp gsr 
! f2 f16 f18 f22 
		                       
! predecessor blocks: .L77002393

			.L77002395:
/* 0x00b4	  95 */		ld	[%o0+%o1],%f12
/* 0x00b8	     */		fstod	%f12,%f46
/* 0x00bc	     */		fcmpd	%fcc0,%f46,%f54
/* 0x00c0	     */		fbne,pn	%fcc0,.L77002425
/* 0x00c4	     */		add	%g2,552,%o3

! Registers live out of .L77002395: 
! g2 g5 o0 o3 sp o7 fp gsr 
! f2 f16 f18 f22 
		                       
! predecessor blocks: .L77002395

			.L77002397:
/* 0x00c8	  95 */		ld	[%o0+%o3],%f10
/* 0x00cc	     */		fstod	%f10,%f30
/* 0x00d0	     */		fcmpd	%fcc1,%f30,%f48
/* 0x00d4	     */		fbne,pn	%fcc1,.L77002425
/* 0x00d8	     */		add	%g2,556,%o4

! Registers live out of .L77002397: 
! g2 g5 o0 o4 sp o7 fp gsr 
! f2 f16 f18 f22 
		                       
! predecessor blocks: .L77002397

			.L77002399:
/* 0x00dc	  95 */		ld	[%o0+%o4],%f8
/* 0x00e0	     */		fstod	%f8,%f28
/* 0x00e4	     */		fcmpd	%fcc2,%f28,%f54
/* 0x00e8	     */		fbne,pn	%fcc2,.L77002425
/* 0x00ec	     */		add	%g2,560,%o5

! Registers live out of .L77002399: 
! g2 g5 o0 o5 sp o7 fp gsr 
! f2 f16 f18 f22 
		                       
! predecessor blocks: .L77002399

			.L77002401:
/* 0x00f0	  95 */		ld	[%o0+%o5],%f6
/* 0x00f4	     */		fstod	%f6,%f26
/* 0x00f8	     */		fcmpd	%fcc3,%f26,%f48
/* 0x00fc	     */		fbne,pn	%fcc3,.L77002425
/* 0x0100	     */		add	%g2,564,%g1

! Registers live out of .L77002401: 
! g1 g2 g5 o0 sp o7 fp gsr 
! f2 f16 f18 f22 
		                       
! predecessor blocks: .L77002401

			.L77002403:
/* 0x0104	  95 */		ld	[%o0+%g1],%f4
/* 0x0108	     */		fstod	%f4,%f24
/* 0x010c	     */		fcmpd	%fcc0,%f24,%f54
/* 0x0110	     */		fbne,pn	%fcc0,.L77002425
/* 0x0114	     */		add	%g2,568,%o2

! Registers live out of .L77002403: 
! g2 g5 o0 o2 sp o7 fp gsr 
! f2 f16 f18 
		                       
! predecessor blocks: .L77002403

			.L77002405:
/* 0x0118	  95 */		ld	[%o0+%o2],%f0
/* 0x011c	     */		fstod	%f0,%f22
/* 0x0120	     */		fcmpd	%fcc1,%f22,%f48
/* 0x0124	     */		fbne,pn	%fcc1,.L77002425
/* 0x0128	     */		add	%g2,588,%g4

! Registers live out of .L77002405: 
! g4 g5 o0 sp o7 fp gsr 
! f2 f16 f18 
		                       
! predecessor blocks: .L77002405

			.L77002407:
/* 0x012c	  95 */		ldub	[%o0+%g4],%g3
/* 0x0130	     */		cmp	%g3,0
/* 0x0134	     */		bne,pn	%icc,.L900000210
/* 0x0138	  99 */		add	%g5,285,%o2

! Registers live out of .L77002407: 
! g5 o0 o2 sp o7 fp gsr 
! f2 f16 f18 
		                       
! predecessor blocks: .L77002407

			.L77002409:
/* 0x013c	  95 */		fstod	%f2,%f20
/* 0x0140	     */		fcmpd	%fcc2,%f20,%f48
/* 0x0144	     */		fbne,pn	%fcc2,.L900000210
/* 0x0148	  99 */		add	%g5,285,%o2

! Registers live out of .L77002409: 
! g5 o0 o2 sp o7 fp gsr 
! f16 f18 
		                       
! predecessor blocks: .L77002409

			.L77002411:
/* 0x014c	  95 */		fstod	%f18,%f20
/* 0x0150	     */		fcmpd	%fcc3,%f20,%f48
/* 0x0154	     */		fbne,pn	%fcc3,.L77002425
/* 0x0158	   0 */		sethi	%hi(0xdc00),%g2

! Registers live out of .L77002411: 
! g2 g5 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002411

			.L77002413:
/* 0x015c	  95 */		add	%g2,460,%o3
/* 0x0160	     */		ld	[%o0+%o3],%o1
/* 0x0164	     */		cmp	%o1,0
/* 0x0168	     */		bne,pn	%icc,.L77002425
/* 0x016c	     */		add	%g2,464,%o5

! Registers live out of .L77002413: 
! g2 g5 o0 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002413

			.L77002415:
/* 0x0170	  95 */		ld	[%o0+%o5],%o4
/* 0x0174	     */		cmp	%o4,0
/* 0x0178	     */		bne,pn	%icc,.L77002425
/* 0x017c	     */		add	%g2,468,%o2

! Registers live out of .L77002415: 
! g2 g5 o0 o2 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002415

			.L77002417:
/* 0x0180	  95 */		ld	[%o0+%o2],%g1
/* 0x0184	     */		cmp	%g1,0
/* 0x0188	     */		bne,pn	%icc,.L77002425
/* 0x018c	     */		add	%g2,480,%g4

! Registers live out of .L77002417: 
! g2 g4 g5 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002417

			.L77002419:
/* 0x0190	  95 */		ldub	[%o0+%g4],%g3
/* 0x0194	     */		cmp	%g3,0
/* 0x0198	     */		bne,pn	%icc,.L77002425
/* 0x019c	  96 */		add	%g2,481,%g2

! Registers live out of .L77002419: 
! g2 g5 o0 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002419

			.L77002421:
/* 0x01a0	  96 */		ldub	[%o0+%g2],%g1
/* 0x01a4	     */		add	%g5,285,%o1
/* 0x01a8	     */		sub	%g0,%g1,%o5
/* 0x01ac	     */		srlx	%o5,63,%o4
/* 0x01b0	     */		xor	%o4,1,%o3
/* 0x01b4	 120 */		retl	! Result = 
/* 0x01b8	  96 */		stb	%o3,[%o0+%o1]
                       
! predecessor blocks: .L77002384 .L77002389 .L77002391 .L77002393 .L77002395 .L77002397 .L77002399 .L77002401 .L77002403 .L77002405
! predecessor blocks: .L77002411 .L77002413 .L77002415 .L77002417 .L77002419

			.L77002425:
/* 0x01bc	  99 */		add	%g5,285,%o2

! Registers live out of .L77002425: 
! o0 o2 sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77002407 .L77002409 .L77002425

			.L900000210:
/* 0x01c0	 120 */		retl	! Result = 
/* 0x01c4	  99 */		stb	%g0,[%o0+%o2]
/* 0x01c8	   0 */		.type	gl_PixelZoom,2
/* 0x01c8	   0 */		.size	gl_PixelZoom,(.-gl_PixelZoom)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000301:
/* 000000	   0 */		.word	1127219200,0
/* 0x0008	     */		.word	-1082130432
/* 0x000c	     */		.word	1065353216
/* 0x0010	     */		.word	1127219200
/* 0x0014	   0 */		.align	8
/* 0x0018	   0 */		.word	1072693248,0
/* 0x0020	   0 */		.type	___const_seg_900000301,1
/* 0x0020	   0 */		.size	___const_seg_900000301,(.-___const_seg_900000301)
/* 0x0020	   0 */		.align	4

!  120		      !   update_drawpixels_state( ctx );
!  121		      !}
!  126		      !/*
!  127		      ! * Write a span of pixels to the frame buffer while applying a pixel zoom.
!  128		      ! * This is only used by glDrawPixels and glCopyPixels.
!  129		      ! * Input:  n - number of pixels in input row
!  130		      ! *         x, y - destination of the span
!  131		      ! *         z - depth values for the span
!  132		      ! *         red, green, blue, alpha - array of colors
!  133		      ! *         y0 - location of first row in the image we're drawing.
!  134		      ! */
!  135		      !void
!  136		      !gl_write_zoomed_color_span( GLcontext *ctx,
!  137		      !                            GLuint n, GLint x, GLint y, const GLdepth z[],
!  138		      !                            const GLubyte red[], const GLubyte green[],
!  139		      !                            const GLubyte blue[], const GLubyte alpha[],
!  140		      !                            GLint y0 )
!  141		      !{

!
! SUBROUTINE gl_write_zoomed_color_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_zoomed_color_span
                       

			gl_write_zoomed_color_span:
/* 000000	 141 */		sethi	%hi(0x2400),%g1
/* 0x0004	     */		xor	%g1,-696,%g1
/* 0x0008	     */		save	%sp,%g1,%sp
/* 0x000c	     */		st	%i1,[%sp+132]

!  142		      !   GLint m;
!  143		      !   GLint r0, r1, row, r;
!  144		      !   GLint i, j, skipcol;
!  145		      !   GLubyte zred[MAX_WIDTH], zgreen[MAX_WIDTH];  /* zoomed pixel colors */
!  146		      !   GLubyte zblue[MAX_WIDTH], zalpha[MAX_WIDTH];
!  147		      !   GLdepth zdepth[MAX_WIDTH];  /* zoomed depth values */
!  148		      !   GLint maxwidth = MIN2( ctx->Buffer->Width, MAX_WIDTH );
!  150		      !   /* compute width of output row */
!  151		      !   m = (GLint) ABSF( n * ctx->Pixel.ZoomX );

/* 0x0010	 151 */		sethi	%hi(___const_seg_900000301+16),%l0
/* 0x0014	     */		sethi	%hi(___const_seg_900000301),%i1
/* 0x0018	     */		ld	[%l0+%lo(___const_seg_900000301+16)],%f30
/* 0x001c	     */		ldd	[%i1+%lo(___const_seg_900000301)],%f44
/* 0x0020	     */		ld	[%sp+132],%f31
/* 0x0024	     */		sethi	%hi(0xac00),%l3
/* 0x0028	     */		add	%l3,592,%l6
/* 0x002c	     */		fsubd	%f30,%f44,%f46
/* 0x0030	 141 */		srl	%i0,0,%g4
/* 0x0034	 151 */		ld	[%g4+%l6],%f4
/* 0x0038	 141 */		st	%i0,[%sp+108]
/* 0x003c	 151 */		fdtos	%f46,%f1
/* 0x0040	     */		fmuls	%f1,%f4,%f3
/* 0x0044	     */		fabss	%f3,%f5
/* 0x0048	     */		fstoi	%f5,%f7
/* 0x004c	     */		st	%f7,[%sp+152]
/* 0x0050	     */		ld	[%sp+152],%l0

!  152		      !   if (m==0) {

/* 0x0054	 152 */		cmp	%l0,0
/* 0x0058	     */		be,pn	%icc,.L77002562
/* 0x005c	     */		ld	[%fp+104],%l4

! Registers live out of gl_write_zoomed_color_span: 
! g4 o2 sp l0 l4 l6 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  153		      !      return;
!  154		      !   }
!  155		      !   if (ctx->Pixel.ZoomX<0.0) {
!  156		      !      /* adjust x coordinate for left/right mirroring */
!  157		      !      x = x - m;
!  158		      !   }
!  160		      !   /* compute which rows to draw */
!  161		      !   row = y-y0;
!  162		      !   r0 = y0 + (GLint) (row * ctx->Pixel.ZoomY);

                       
! predecessor blocks: gl_write_zoomed_color_span

			.L77002481:
/* 0x0060	 162 */		add	%l3,596,%l2
/* 0x0064	     */		ld	[%g4+%l2],%f6
/* 0x0068	 161 */		sub	%i3,%l4,%g5

!  163		      !   r1 = y0 + (GLint) ((row+1) * ctx->Pixel.ZoomY);

/* 0x006c	 163 */		add	%g5,1,%o0
/* 0x0070	     */		st	%o0,[%sp+156]
/* 0x0074	 162 */		st	%g5,[%sp+160]
/* 0x0078	 163 */		ld	[%sp+156],%f25
/* 0x007c	 162 */		ld	[%sp+160],%f27
/* 0x0080	 155 */		fstod	%f4,%f50
/* 0x0084	 163 */		fitos	%f25,%f2
/* 0x0088	 162 */		fitos	%f27,%f29
/* 0x008c	 155 */		fzero	%f48
/* 0x0090	 163 */		fmuls	%f2,%f6,%f8
/* 0x0094	 162 */		fmuls	%f29,%f6,%f0
/* 0x0098	 157 */		sub	%i2,%l0,%l1
/* 0x009c	 155 */		fcmped	%fcc0,%f50,%f48
/* 0x00a0	 157 */		or	%g0,%i2,%l7
/* 0x00a4	 163 */		fstoi	%f8,%f12
/* 0x00a8	     */		st	%f12,[%sp+168]
/* 0x00ac	 162 */		fstoi	%f0,%f10
/* 0x00b0	     */		st	%f10,[%sp+164]
/* 0x00b4	 157 */		movl	%fcc0,%l1,%l7
/* 0x00b8	 163 */		ld	[%sp+168],%i2
/* 0x00bc	 162 */		ld	[%sp+164],%o5
/* 0x00c0	 157 */		st	%l7,[%sp+112]
/* 0x00c4	 163 */		add	%l4,%i2,%o4
/* 0x00c8	 162 */		add	%l4,%o5,%i2

!  164		      !   if (r0==r1) {

/* 0x00cc	 164 */		cmp	%i2,%o4
/* 0x00d0	     */		be,pn	%icc,.L77002562
/* 0x00d4	 167 */		or	%g0,%i2,%i3

! Registers live out of .L77002481: 
! g4 o2 o4 sp l0 l6 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  165		      !      return;
!  166		      !   }
!  167		      !   else if (r1<r0) {

                       
! predecessor blocks: .L77002481

			.L77002489:
/* 0x00d8	 167 */		cmp	%o4,%i2
/* 0x00dc	 141 */		or	%g0,%i4,%i2

!  168		      !      GLint rtmp = r1;
!  169		      !      r1 = r0;

/* 0x00e0	 169 */		or	%g0,%o4,%l3

!  170		      !      r0 = rtmp;

/* 0x00e4	 170 */		or	%g0,%i3,%i4
/* 0x00e8	     */		movl	%icc,%o4,%i4
/* 0x00ec	 169 */		movl	%icc,%i3,%l3
/* 0x00f0	     */		st	%l3,[%sp+120]

!  171		      !   }
!  173		      !   /* return early if r0...r1 is above or below window */
!  174		      !   if (r0<0 && r1<0) {

/* 0x00f4	 174 */		cmp	%i4,0
/* 0x00f8	     */		bl,pn	%icc,.L77002495
/* 0x00fc	 170 */		st	%i4,[%sp+116]

! Registers live out of .L77002489: 
! g4 o2 sp l0 l6 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002489

			.L77002643:
/* 0x0100	 148 */		ld	[%g4+2204],%i0
/* 0x0104	     */		ba	.L900000361
/* 0x0108	 178 */		ld	[%i0+8],%l7

! Registers live out of .L77002643: 
! o2 sp l0 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002489

			.L77002495:
/* 0x010c	 174 */		cmp	%l3,0
/* 0x0110	     */		bl,pn	%icc,.L77002562
/* 0x0114	     */		nop

! Registers live out of .L77002495: 
! g4 o2 sp l0 l6 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002495

			.L77002647:
/* 0x0118	 148 */		ld	[%g4+2204],%i0

!  175		      !      /* below window */
!  176		      !      return;
!  177		      !   }
!  178		      !   if (r0>=ctx->Buffer->Height && r1>=ctx->Buffer->Height) {

/* 0x011c	 178 */		ld	[%i0+8],%l7

! Registers live out of .L77002647: 
! o2 sp l0 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002643 .L77002647

			.L900000361:
/* 0x0120	 178 */		cmp	%i4,%l7
/* 0x0124	     */		bge,pn	%icc,.L900000360
/* 0x0128	     */		cmp	%l3,%l7

! Registers live out of .L900000361: 
! o2 sp l0 l6 i0 i2 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000361

			.L77002649:
/* 0x012c	 148 */		ld	[%i0+4],%l1
/* 0x0130	     */		sra	%l1,0,%o0
/* 0x0134	     */		sub	%o0,1600,%o7
/* 0x0138	     */		srax	%o7,32,%l3
/* 0x013c	     */		and	%l3,%o7,%l5
/* 0x0140	     */		add	%l5,1600,%l5
/* 0x0144	     */		ba	.L900000359
/* 0x0148	 185 */		ld	[%sp+112],%i0

! Registers live out of .L77002649: 
! o2 sp l0 l5 l6 i0 i2 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000361

			.L900000360:
/* 0x014c	 178 */		bge,pn	%icc,.L77002562
/* 0x0150	     */		nop

! Registers live out of .L900000360: 
! o2 sp l0 l6 i0 i2 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000360

			.L77002653:
/* 0x0154	 148 */		ld	[%i0+4],%i4

!  179		      !      /* above window */
!  180		      !      return;
!  181		      !   }
!  183		      !   /* check if left edge is outside window */
!  184		      !   skipcol = 0;
!  185		      !   if (x<0) {

/* 0x0158	 185 */		ld	[%sp+112],%i0
/* 0x015c	 148 */		sra	%i4,0,%o1
/* 0x0160	     */		sub	%o1,1600,%g5
/* 0x0164	     */		srax	%g5,32,%l7
/* 0x0168	     */		and	%l7,%g5,%i3
/* 0x016c	     */		add	%i3,1600,%l5

! Registers live out of .L77002653: 
! o2 sp l0 l5 l6 i0 i2 i5 fp i7 gsr 
! f4 
		
!  186		      !      skipcol = -x;
!  187		      !      m += x;

                       
! predecessor blocks: .L77002649 .L77002653

			.L900000359:
/* 0x0170	 187 */		add	%l0,%i0,%i4
/* 0x0174	 185 */		cmp	%i0,0
/* 0x0178	 187 */		movl	%icc,%i4,%l0
/* 0x017c	 186 */		sub	%g0,%i0,%i4
/* 0x0180	 184 */		movge	%icc,%g0,%i4

!  188		      !   }
!  189		      !   /* make sure span isn't too long or short */
!  190		      !   if (m>maxwidth) {

/* 0x0184	 190 */		cmp	%l0,%l5
/* 0x0188	 184 */		st	%i4,[%sp+124]
/* 0x018c	 190 */		ble,pn	%icc,.L77002513
/* 0x0190	   0 */		add	%fp,-1600,%l4

! Registers live out of .L900000359: 
! o2 sp l0 l4 l5 l6 i2 i5 fp i7 gsr 
! f4 
		
!  191		      !      m = maxwidth;
!  192		      !   }
!  193		      !   else if (m<=0) {
!  194		      !      return;
!  195		      !   }
!  197		      !   assert( m <= MAX_WIDTH );

                       
! predecessor blocks: .L900000359

			.L77002511:
/* 0x0194	 197 */		cmp	%l5,1600
/* 0x0198	     */		ble,pn	%icc,.L77002527
/* 0x019c	 191 */		or	%g0,%l5,%l0

! Registers live out of .L77002511: 
! o2 sp l0 l4 l5 l6 i2 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002511

			.L77002657:
/* 0x01a0	 197 */		ldx	[%fp+96],%g2
/* 0x01a4	     */		ld	[%fp+92],%i4
/* 0x01a8	     */		srl	%g2,0,%i1
/* 0x01ac	     */		srlx	%g2,32,%i0
/* 0x01b0	     */		ba	.L900000358
/* 0x01b4	     */		sethi	%hi(.L80),%o1

! Registers live out of .L77002657: 
! o1 o2 sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  199		      !   /* zoom the span horizontally */
!  200		      !   if (ctx->Pixel.ZoomX==-1.0F) {

                       
! predecessor blocks: .L77002511

			.L77002527:
/* 0x01b8	 200 */		sethi	%hi(___const_seg_900000301+8),%i1
/* 0x01bc	     */		ld	[%i1+%lo(___const_seg_900000301+8)],%f23
/* 0x01c0	     */		fcmps	%fcc1,%f4,%f23
/* 0x01c4	     */		fbne,pn	%fcc1,.L77002614
/* 0x01c8	 202 */		cmp	%l5,0

! Registers live out of .L77002527: 
! sp l0 l4 l5 i2 i5 fp i7 gsr 
! f4 
		
!  201		      !      /* n==m */
!  202		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002527

			.L77002579:
/* 0x01cc	 202 */		ble,pn	%icc,.L77002612
/* 0x01d0	     */		add	%l5,-1,%i3

! Registers live out of .L77002579: 
! sp l0 l4 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002579

			.L77002667:
/* 0x01d4	 202 */		ldx	[%fp+96],%g4
/* 0x01d8	     */		ld	[%fp+92],%i4
/* 0x01dc	     */		srl	%g4,0,%i1
/* 0x01e0	     */		srlx	%g4,32,%i0
/* 0x01e4	     */		ba	.L900000357
/* 0x01e8	     */		cmp	%i3,71

! Registers live out of .L77002667: 
! sp l0 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  203		      !         i = n - (j+skipcol) - 1;
!  204		      !         zred[j]   = red[i];
!  205		      !         zgreen[j] = green[i];
!  206		      !         zblue[j]  = blue[i];
!  207		      !         zalpha[j] = alpha[i];
!  208		      !         zdepth[j] = z[i];
!  209		      !      }
!  210		      !   }
!  211		      !   else {
!  212		      !      GLfloat xscale = 1.0F / ctx->Pixel.ZoomX;
!  213		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002527

			.L77002614:
/* 0x01ec	 213 */		ble,pn	%icc,.L77002612
/* 0x01f0	 212 */		ld	[%fp+92],%i4

! Registers live out of .L77002614: 
! sp l0 l5 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002614

			.L77002669:
/* 0x01f4	 212 */		ldx	[%fp+96],%g3
/* 0x01f8	     */		sethi	%hi(___const_seg_900000301+12),%i0
/* 0x01fc	     */		ld	[%i0+%lo(___const_seg_900000301+12)],%f9
/* 0x0200	     */		add	%l5,-1,%o1
/* 0x0204	 213 */		or	%g0,0,%l4
/* 0x0208	 212 */		fdivs	%f9,%f4,%f4
/* 0x020c	     */		srl	%g3,0,%i1
/* 0x0210	     */		srlx	%g3,32,%i0
/* 0x0214	     */		ba	.L900000356
/* 0x0218	 213 */		ld	[%sp+132],%l6

! Registers live out of .L77002669: 
! o1 sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000359

			.L77002513:
/* 0x021c	 193 */		cmp	%l0,0
/* 0x0220	     */		ble,pn	%icc,.L77002562
/* 0x0224	 197 */		cmp	%l0,1600

! Registers live out of .L77002513: 
! sp l0 l4 l6 i2 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002513

			.L77002626:
/* 0x0228	 193 */		ldx	[%fp+96],%o2
/* 0x022c	     */		ld	[%fp+92],%i4
/* 0x0230	     */		srl	%o2,0,%i1
/* 0x0234	 197 */		bg,pn	%icc,.L77002521
/* 0x0238	 193 */		srlx	%o2,32,%i0

! Registers live out of .L77002626: 
! o2 sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002626

			.L77002625:
/* 0x023c	 200 */		sethi	%hi(___const_seg_900000301+8),%l6

! Registers live out of .L77002625: 
! sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002625 .L900000358

			.L900000348:
/* 0x0240	 200 */		ld	[%l6+%lo(___const_seg_900000301+8)],%f11
/* 0x0244	     */		fcmps	%fcc2,%f4,%f11
/* 0x0248	     */		fbne,pt	%fcc2,.L900000355
/* 0x024c	 212 */		sethi	%hi(___const_seg_900000301+12),%l2

! Registers live out of .L900000348: 
! sp l0 l2 l4 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000348

			.L77002627:
/* 0x0250	 200 */		add	%l0,-1,%i3
/* 0x0254	 202 */		cmp	%i3,71

! Registers live out of .L77002627: 
! sp l0 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002627 .L77002667

			.L900000357:
/* 0x0258	 202 */		bl,pn	%icc,.L77002585
/* 0x025c	     */		add	%i3,1,%l7

! Registers live out of .L900000357: 
! sp l0 l4 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000357

			.L77002586:
/* 0x0260	 202 */		add	%fp,-3200,%o7
/* 0x0264	     */		sub	%l4,%o7,%g2
/* 0x0268	     */		sethi	%hi(0x1000),%g1
/* 0x026c	     */		xor	%g1,-704,%g1
/* 0x0270	     */		add	%g1,%fp,%l1
/* 0x0274	     */		sub	%l4,%l1,%l5
/* 0x0278	     */		sethi	%hi(0x1800),%g1
/* 0x027c	     */		xor	%g1,-256,%g1
/* 0x0280	     */		ld	[%sp+124],%l2
/* 0x0284	     */		ld	[%sp+132],%g4
/* 0x0288	     */		sub	%g4,%l2,%o1
/* 0x028c	     */		sub	%o1,%l7,%g4
/* 0x0290	     */		add	%i1,%g4,%l3
/* 0x0294	     */		sub	%l4,%l3,%g5
/* 0x0298	     */		add	%i4,%g4,%o5
/* 0x029c	     */		add	%i0,%g4,%l6
/* 0x02a0	     */		sub	%l4,%o5,%o3
/* 0x02a4	     */		sub	%l4,%l6,%g3
/* 0x02a8	     */		add	%i5,%g4,%o0
/* 0x02ac	     */		sub	%l4,%o0,%o2
/* 0x02b0	     */		sub	%o7,%o0,%o7
/* 0x02b4	     */		st	%l3,[%sp+144]
/* 0x02b8	     */		sra	%g2,31,%l3
/* 0x02bc	     */		xor	%g2,%l3,%o4
/* 0x02c0	     */		sub	%o4,%l3,%g2
/* 0x02c4	     */		sra	%o2,31,%l3
/* 0x02c8	     */		st	%o5,[%sp+148]
/* 0x02cc	     */		sra	%g3,31,%o5
/* 0x02d0	     */		xor	%g3,%o5,%l1
/* 0x02d4	     */		xor	%o2,%l3,%g3
/* 0x02d8	     */		sub	%g3,%l3,%o2
/* 0x02dc	     */		sub	%l1,%o5,%o4
/* 0x02e0	     */		add	%g1,%fp,%g3
/* 0x02e4	     */		sub	%l4,%g3,%o5
/* 0x02e8	     */		sra	%l5,31,%l1
/* 0x02ec	     */		sra	%o5,31,%l3
/* 0x02f0	     */		xor	%l5,%l1,%l5
/* 0x02f4	     */		sub	%l5,%l1,%g3
/* 0x02f8	     */		sethi	%hi(0x2400),%g1
/* 0x02fc	     */		xor	%g1,-384,%g1
/* 0x0300	     */		sra	%o4,0,%o4
/* 0x0304	     */		sra	%o2,0,%o2
/* 0x0308	     */		sra	%g3,0,%g3
/* 0x030c	     */		st	%o1,[%sp+140]
/* 0x0310	     */		sll	%g4,1,%o1
/* 0x0314	     */		add	%i2,%o1,%l2
/* 0x0318	     */		sra	%o3,31,%o1
/* 0x031c	     */		xor	%o3,%o1,%g4
/* 0x0320	     */		sub	%g4,%o1,%o3
/* 0x0324	     */		sra	%g5,31,%g4
/* 0x0328	     */		xor	%o5,%l3,%o1
/* 0x032c	     */		sra	%o7,31,%o5
/* 0x0330	     */		xor	%g5,%g4,%g5
/* 0x0334	     */		sub	%g5,%g4,%l5
/* 0x0338	     */		xor	%o7,%o5,%l1
/* 0x033c	     */		sub	%l1,%o5,%g4
/* 0x0340	     */		sub	%o1,%l3,%g5
/* 0x0344	     */		sll	%l7,1,%l3
/* 0x0348	     */		sub	%l4,%l2,%o1
/* 0x034c	     */		sra	%o3,0,%o5
/* 0x0350	     */		st	%g4,[%sp+164]
/* 0x0354	     */		sra	%l7,0,%g4
/* 0x0358	     */		add	%g1,%fp,%l7
/* 0x035c	     */		sub	%l4,%l7,%l1
/* 0x0360	     */		sub	%l7,%l4,%l7
/* 0x0364	     */		sub	%o4,%g4,%o7
/* 0x0368	     */		sub	%o5,%g4,%o3
/* 0x036c	     */		srlx	%o3,63,%o3
/* 0x0370	     */		xor	%o3,1,%o5
/* 0x0374	     */		st	%o1,[%sp+156]
/* 0x0378	     */		sra	%g2,0,%o1
/* 0x037c	     */		sub	%o1,%g4,%g2
/* 0x0380	     */		srlx	%g2,63,%g2
/* 0x0384	     */		xor	%g2,1,%o1
/* 0x0388	     */		st	%g5,[%sp+160]
/* 0x038c	     */		sub	%l2,%l4,%g5
/* 0x0390	     */		srlx	%o7,63,%l4
/* 0x0394	     */		xor	%l4,1,%o4
/* 0x0398	     */		and	%o4,%o1,%o7
/* 0x039c	     */		sub	%o2,%g4,%o1
/* 0x03a0	     */		srlx	%o1,63,%o2
/* 0x03a4	     */		xor	%o2,1,%g2
/* 0x03a8	     */		and	%g2,%o5,%o1
/* 0x03ac	     */		and	%o1,%o7,%o2
/* 0x03b0	     */		sra	%l5,0,%o4
/* 0x03b4	     */		sub	%g3,%g4,%g2
/* 0x03b8	     */		sub	%o4,%g4,%o7
/* 0x03bc	     */		srlx	%g2,63,%g3
/* 0x03c0	     */		srlx	%o7,63,%l5
/* 0x03c4	     */		xor	%g3,1,%o3
/* 0x03c8	     */		xor	%l5,1,%l4
/* 0x03cc	     */		and	%l4,%o3,%o4
/* 0x03d0	     */		and	%o2,%o4,%l4
/* 0x03d4	     */		sra	%l3,0,%o1
/* 0x03d8	     */		sra	%l1,0,%o2
/* 0x03dc	     */		sra	%l7,0,%o5
/* 0x03e0	     */		sub	%o2,%o1,%g3
/* 0x03e4	     */		sub	%o5,%g4,%o3
/* 0x03e8	     */		srlx	%o3,63,%l7
/* 0x03ec	     */		srlx	%g3,63,%l3
/* 0x03f0	     */		xor	%l7,1,%o7
/* 0x03f4	     */		xor	%l3,1,%l1
/* 0x03f8	     */		or	%l1,%o7,%l5
/* 0x03fc	     */		sra	%g5,0,%g5
/* 0x0400	     */		sub	%g5,%g4,%g2
/* 0x0404	     */		srlx	%g2,63,%g5
/* 0x0408	     */		xor	%g5,1,%g2
/* 0x040c	     */		ld	[%sp+156],%o2
/* 0x0410	     */		ld	[%sp+164],%l1
/* 0x0414	     */		sra	%o2,0,%o4
/* 0x0418	     */		sub	%o4,%o1,%o7
/* 0x041c	     */		srlx	%o7,63,%o5
/* 0x0420	     */		xor	%o5,1,%g3
/* 0x0424	     */		or	%g3,%g2,%o3
/* 0x0428	     */		ld	[%sp+160],%o5
/* 0x042c	     */		and	%o3,%l5,%g5
/* 0x0430	     */		sra	%o5,0,%o5
/* 0x0434	     */		sub	%o5,%g4,%o3
/* 0x0438	     */		srlx	%o3,63,%o2
/* 0x043c	     */		xor	%o2,1,%l7
/* 0x0440	     */		sra	%l1,0,%o2
/* 0x0444	     */		sub	%o2,%g4,%g3
/* 0x0448	     */		srlx	%g3,63,%o4
/* 0x044c	     */		xor	%o4,1,%l3
/* 0x0450	     */		and	%l3,%l7,%o7
/* 0x0454	     */		and	%l4,%o7,%l4
/* 0x0458	     */		andcc	%l4,%g5,%g0
/* 0x045c	     */		be,pn	%icc,.L77002585
/* 0x0460	     */		sethi	%hi(0x1000),%g1

! Registers live out of .L77002586: 
! g1 g4 o0 o1 sp l0 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002586

			.L77002587:
/* 0x0464	 202 */		xor	%g1,-704,%g1
/* 0x0468	     */		add	%g1,%fp,%l4
/* 0x046c	     */		sethi	%hi(0x1800),%g1
/* 0x0470	     */		add	%fp,-3200,%g3
/* 0x0474	     */		xor	%g1,-256,%g1
/* 0x0478	     */		sub	%g3,%l4,%l5
/* 0x047c	     */		add	%g1,%fp,%l1
/* 0x0480	     */		sub	%g3,%l1,%o7
/* 0x0484	     */		sra	%l5,31,%g2
/* 0x0488	     */		sub	%g3,%l6,%l7
/* 0x048c	     */		xor	%l5,%g2,%l1
/* 0x0490	     */		sra	%l7,31,%l5
/* 0x0494	     */		sub	%l1,%g2,%g2
/* 0x0498	     */		xor	%l7,%l5,%l1
/* 0x049c	     */		sub	%l4,%o0,%o5
/* 0x04a0	     */		sethi	%hi(0x2400),%g1
/* 0x04a4	     */		xor	%g1,-384,%g1
/* 0x04a8	     */		ld	[%sp+144],%o3
/* 0x04ac	     */		ld	[%sp+148],%l3
/* 0x04b0	     */		sub	%g3,%o3,%o3
/* 0x04b4	     */		sra	%o3,31,%o4
/* 0x04b8	     */		xor	%o3,%o4,%o2
/* 0x04bc	     */		sub	%g3,%l3,%g5
/* 0x04c0	     */		sub	%l1,%l5,%o3
/* 0x04c4	     */		sra	%g5,31,%l7
/* 0x04c8	     */		sub	%l4,%l3,%l3
/* 0x04cc	     */		sub	%l4,%l6,%l5
/* 0x04d0	     */		sra	%o7,31,%l4
/* 0x04d4	     */		xor	%g5,%l7,%g5
/* 0x04d8	     */		sub	%o2,%o4,%o4
/* 0x04dc	     */		sub	%g5,%l7,%o2
/* 0x04e0	     */		xor	%o7,%l4,%o7
/* 0x04e4	     */		sub	%o7,%l4,%g5
/* 0x04e8	     */		sra	%l3,31,%o7
/* 0x04ec	     */		xor	%l3,%o7,%l7
/* 0x04f0	     */		sra	%l5,31,%l3
/* 0x04f4	     */		xor	%l5,%l3,%l5
/* 0x04f8	     */		sra	%o5,31,%l1
/* 0x04fc	     */		sub	%l5,%l3,%l5
/* 0x0500	     */		xor	%o5,%l1,%o5
/* 0x0504	     */		sub	%l7,%o7,%o7
/* 0x0508	     */		sub	%o5,%l1,%l4
/* 0x050c	     */		sub	%g3,%l2,%l7
/* 0x0510	     */		sra	%o4,0,%o4
/* 0x0514	     */		sra	%o3,0,%o3
/* 0x0518	     */		sra	%o2,0,%o2
/* 0x051c	     */		sra	%g5,0,%g5
/* 0x0520	     */		st	%l5,[%sp+160]
/* 0x0524	     */		add	%g1,%fp,%l5
/* 0x0528	     */		sub	%l5,%g3,%l3
/* 0x052c	     */		sub	%g3,%l5,%l1
/* 0x0530	     */		sub	%l2,%g3,%l5
/* 0x0534	     */		st	%o7,[%sp+156]
/* 0x0538	     */		sra	%g2,0,%o7
/* 0x053c	     */		sub	%o7,%g4,%o5
/* 0x0540	     */		srlx	%o5,63,%g3
/* 0x0544	     */		xor	%g3,1,%o5
/* 0x0548	     */		sub	%o4,%g4,%g3
/* 0x054c	     */		srlx	%g3,63,%g2
/* 0x0550	     */		xor	%g2,1,%o4
/* 0x0554	     */		sub	%o3,%g4,%g2
/* 0x0558	     */		sub	%o2,%g4,%o7
/* 0x055c	     */		and	%o4,%o5,%g3
/* 0x0560	     */		srlx	%g2,63,%o3
/* 0x0564	     */		srlx	%o7,63,%o2
/* 0x0568	     */		xor	%o3,1,%o5
/* 0x056c	     */		xor	%o2,1,%o7
/* 0x0570	     */		and	%o7,%o5,%g2
/* 0x0574	     */		and	%g2,%g3,%o3
/* 0x0578	     */		sra	%l4,0,%o4
/* 0x057c	     */		sub	%g5,%g4,%o5
/* 0x0580	     */		sub	%o4,%g4,%g3
/* 0x0584	     */		srlx	%o5,63,%g5
/* 0x0588	     */		srlx	%g3,63,%l4
/* 0x058c	     */		xor	%g5,1,%o2
/* 0x0590	     */		xor	%l4,1,%o4
/* 0x0594	     */		and	%o4,%o2,%g3
/* 0x0598	     */		and	%o3,%g3,%l4
/* 0x059c	     */		sra	%l3,0,%o3
/* 0x05a0	     */		sra	%l1,0,%o2
/* 0x05a4	     */		sub	%o3,%g4,%g2
/* 0x05a8	     */		sub	%o2,%o1,%o7
/* 0x05ac	     */		srlx	%g2,63,%l3
/* 0x05b0	     */		srlx	%o7,63,%l1
/* 0x05b4	     */		xor	%l3,1,%o5
/* 0x05b8	     */		xor	%l1,1,%o7
/* 0x05bc	     */		or	%o7,%o5,%g5
/* 0x05c0	     */		sra	%l5,0,%o5
/* 0x05c4	     */		sra	%l7,0,%g3
/* 0x05c8	     */		sub	%o5,%g4,%o4
/* 0x05cc	     */		sub	%g3,%o1,%o3
/* 0x05d0	     */		srlx	%o4,63,%l5
/* 0x05d4	     */		srlx	%o3,63,%l7
/* 0x05d8	     */		xor	%l5,1,%g2
/* 0x05dc	     */		xor	%l7,1,%o3
/* 0x05e0	     */		or	%o3,%g2,%o2
/* 0x05e4	     */		and	%o2,%g5,%l5
/* 0x05e8	     */		ld	[%sp+156],%g5
/* 0x05ec	     */		ld	[%sp+160],%o2
/* 0x05f0	     */		sra	%g5,0,%g5
/* 0x05f4	     */		sra	%o2,0,%o2
/* 0x05f8	     */		sub	%g5,%g4,%g2
/* 0x05fc	     */		sub	%o2,%g4,%o7
/* 0x0600	     */		srlx	%g2,63,%o4
/* 0x0604	     */		srlx	%o7,63,%g3
/* 0x0608	     */		xor	%o4,1,%l3
/* 0x060c	     */		xor	%g3,1,%l1
/* 0x0610	     */		and	%l1,%l3,%o5
/* 0x0614	     */		and	%l4,%o5,%l4
/* 0x0618	     */		andcc	%l4,%l5,%g0
/* 0x061c	     */		be,pn	%icc,.L77002585
/* 0x0620	     */		ld	[%sp+144],%l3

! Registers live out of .L77002587: 
! g4 o0 o1 sp l0 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002587

			.L77002588:
/* 0x0624	 202 */		sethi	%hi(0x1000),%g1
/* 0x0628	     */		xor	%g1,-704,%g1
/* 0x062c	     */		add	%g1,%fp,%g2
/* 0x0630	     */		sethi	%hi(0x1800),%g1
/* 0x0634	     */		xor	%g1,-256,%g1
/* 0x0638	     */		add	%g1,%fp,%o3
/* 0x063c	     */		sub	%g2,%l3,%l4
/* 0x0640	     */		sub	%g2,%o3,%o7
/* 0x0644	     */		sra	%l4,31,%g3
/* 0x0648	     */		sub	%o3,%o0,%o2
/* 0x064c	     */		sra	%o7,31,%o5
/* 0x0650	     */		xor	%l4,%g3,%l7
/* 0x0654	     */		xor	%o7,%o5,%l1
/* 0x0658	     */		sra	%o2,31,%l4
/* 0x065c	     */		sub	%l1,%o5,%l5
/* 0x0660	     */		xor	%o2,%l4,%g5
/* 0x0664	     */		sub	%l7,%g3,%l7
/* 0x0668	     */		sub	%g5,%l4,%o5
/* 0x066c	     */		sethi	%hi(0x2400),%g1
/* 0x0670	     */		xor	%g1,-384,%g1
/* 0x0674	     */		add	%g1,%fp,%l4
/* 0x0678	     */		sub	%o3,%l3,%l3
/* 0x067c	     */		sub	%g2,%l2,%o2
/* 0x0680	     */		sra	%o2,0,%o2
/* 0x0684	     */		sub	%o3,%l2,%l1
/* 0x0688	     */		sra	%o5,0,%o5
/* 0x068c	     */		ld	[%sp+148],%o4
/* 0x0690	     */		sub	%o3,%o4,%o4
/* 0x0694	     */		sra	%o4,31,%o7
/* 0x0698	     */		xor	%o4,%o7,%g3
/* 0x069c	     */		sub	%g3,%o7,%g5
/* 0x06a0	     */		sub	%l2,%g2,%o7
/* 0x06a4	     */		sub	%l4,%g2,%o4
/* 0x06a8	     */		sra	%o4,0,%o4
/* 0x06ac	     */		st	%g5,[%sp+156]
/* 0x06b0	     */		sub	%g2,%l4,%g5
/* 0x06b4	     */		sra	%l3,31,%g2
/* 0x06b8	     */		xor	%l3,%g2,%l3
/* 0x06bc	     */		sub	%l3,%g2,%g3
/* 0x06c0	     */		sub	%o3,%l4,%g2
/* 0x06c4	     */		sub	%l2,%o3,%l3
/* 0x06c8	     */		sub	%l4,%o3,%l4
/* 0x06cc	     */		sra	%g5,0,%g5
/* 0x06d0	     */		st	%g3,[%sp+164]
/* 0x06d4	     */		sra	%o7,0,%g3
/* 0x06d8	     */		st	%g2,[%sp+160]
/* 0x06dc	     */		sub	%g3,%g4,%g2
/* 0x06e0	     */		srlx	%g2,63,%g3
/* 0x06e4	     */		xor	%g3,1,%o7
/* 0x06e8	     */		sub	%o2,%o1,%g3
/* 0x06ec	     */		srlx	%g3,63,%o2
/* 0x06f0	     */		xor	%o2,1,%g2
/* 0x06f4	     */		or	%g2,%o7,%o2
/* 0x06f8	     */		sub	%o3,%l6,%o7
/* 0x06fc	     */		sra	%o7,31,%o3
/* 0x0700	     */		xor	%o7,%o3,%g3
/* 0x0704	     */		sub	%o4,%g4,%o7
/* 0x0708	     */		srlx	%o7,63,%o4
/* 0x070c	     */		sub	%g3,%o3,%o3
/* 0x0710	     */		xor	%o4,1,%o7
/* 0x0714	     */		sub	%g5,%o1,%g2
/* 0x0718	     */		sra	%l7,0,%g3
/* 0x071c	     */		srlx	%g2,63,%g5
/* 0x0720	     */		sub	%g3,%g4,%o4
/* 0x0724	     */		xor	%g5,1,%g2
/* 0x0728	     */		srlx	%o4,63,%l7
/* 0x072c	     */		or	%g2,%o7,%g5
/* 0x0730	     */		xor	%l7,1,%g3
/* 0x0734	     */		and	%o2,%g3,%g2
/* 0x0738	     */		sra	%l5,0,%o2
/* 0x073c	     */		sub	%o2,%g4,%o7
/* 0x0740	     */		srlx	%o7,63,%l5
/* 0x0744	     */		xor	%l5,1,%o2
/* 0x0748	     */		and	%g5,%o2,%o4
/* 0x074c	     */		and	%g2,%o4,%l5
/* 0x0750	     */		sra	%l3,0,%g5
/* 0x0754	     */		sra	%l1,0,%g3
/* 0x0758	     */		sub	%o5,%g4,%o2
/* 0x075c	     */		sub	%g5,%g4,%g2
/* 0x0760	     */		sub	%g3,%o1,%o4
/* 0x0764	     */		srlx	%o2,63,%o5
/* 0x0768	     */		srlx	%g2,63,%l3
/* 0x076c	     */		srlx	%o4,63,%l1
/* 0x0770	     */		xor	%l3,1,%o7
/* 0x0774	     */		xor	%l1,1,%g5
/* 0x0778	     */		or	%g5,%o7,%l1
/* 0x077c	     */		xor	%o5,1,%l7
/* 0x0780	     */		sra	%l4,0,%g2
/* 0x0784	     */		sra	%o3,0,%o3
/* 0x0788	     */		ld	[%sp+156],%o2
/* 0x078c	     */		sra	%o2,0,%o7
/* 0x0790	     */		sub	%o7,%g4,%g5
/* 0x0794	     */		srlx	%g5,63,%g3
/* 0x0798	     */		xor	%g3,1,%o2
/* 0x079c	     */		and	%o2,%l7,%o4
/* 0x07a0	     */		and	%l5,%o4,%l5
/* 0x07a4	     */		sub	%g2,%g4,%g3
/* 0x07a8	     */		srlx	%g3,63,%l4
/* 0x07ac	     */		xor	%l4,1,%o7
/* 0x07b0	     */		ld	[%sp+160],%l7
/* 0x07b4	     */		sra	%l7,0,%o4
/* 0x07b8	     */		sub	%o4,%o1,%o5
/* 0x07bc	     */		srlx	%o5,63,%g2
/* 0x07c0	     */		xor	%g2,1,%l3
/* 0x07c4	     */		or	%l3,%o7,%g3
/* 0x07c8	     */		ld	[%sp+164],%o5
/* 0x07cc	     */		sra	%o5,0,%o2
/* 0x07d0	     */		sub	%o2,%g4,%o7
/* 0x07d4	     */		srlx	%o7,63,%g5
/* 0x07d8	     */		xor	%g5,1,%o5
/* 0x07dc	     */		sub	%o3,%g4,%g5
/* 0x07e0	     */		srlx	%g5,63,%o3
/* 0x07e4	     */		and	%o5,%l1,%l1
/* 0x07e8	     */		xor	%o3,1,%l7
/* 0x07ec	     */		and	%l5,%l1,%o4
/* 0x07f0	     */		and	%g3,%l7,%o2
/* 0x07f4	     */		andcc	%o4,%o2,%g0
/* 0x07f8	     */		be,pn	%icc,.L77002585
/* 0x07fc	     */		sethi	%hi(0x2400),%g1

! Registers live out of .L77002588: 
! g1 g4 o0 o1 sp l0 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002588

			.L77002589:
/* 0x0800	 202 */		xor	%g1,-384,%g1
/* 0x0804	     */		add	%g1,%fp,%o4
/* 0x0808	     */		sub	%o4,%l6,%g5
/* 0x080c	     */		sub	%l6,%o4,%g2
/* 0x0810	     */		sub	%o4,%l2,%o3
/* 0x0814	     */		sub	%o0,%o4,%l3
/* 0x0818	     */		sra	%g2,0,%g2
/* 0x081c	     */		sub	%g2,%o1,%o7
/* 0x0820	     */		srlx	%o7,63,%l7
/* 0x0824	     */		ld	[%sp+144],%g3
/* 0x0828	     */		ld	[%sp+148],%l1
/* 0x082c	     */		sub	%g3,%o4,%o5
/* 0x0830	     */		sub	%o4,%g3,%l6
/* 0x0834	     */		sub	%l1,%o4,%l5
/* 0x0838	     */		sub	%o4,%l1,%l4
/* 0x083c	     */		sub	%o4,%o0,%l1
/* 0x0840	     */		sra	%o3,31,%g3
/* 0x0844	     */		xor	%o3,%g3,%o4
/* 0x0848	     */		sub	%o4,%g3,%l2
/* 0x084c	     */		sra	%g5,0,%g3
/* 0x0850	     */		sra	%o5,0,%g5
/* 0x0854	     */		sub	%g5,%o1,%o4
/* 0x0858	     */		sub	%g3,%g4,%o2
/* 0x085c	     */		srlx	%o4,63,%o3
/* 0x0860	     */		srlx	%o2,63,%o7
/* 0x0864	     */		xor	%o3,1,%o4
/* 0x0868	     */		sra	%l6,0,%o5
/* 0x086c	     */		sub	%o5,%g4,%o3
/* 0x0870	     */		xor	%o7,1,%o2
/* 0x0874	     */		srlx	%o3,63,%l6
/* 0x0878	     */		sra	%l4,0,%o7
/* 0x087c	     */		sub	%o7,%g4,%g3
/* 0x0880	     */		xor	%l7,1,%o0
/* 0x0884	     */		xor	%l6,1,%o5
/* 0x0888	     */		or	%o2,%o0,%g2
/* 0x088c	     */		or	%o5,%o4,%g5
/* 0x0890	     */		srlx	%g3,63,%l4
/* 0x0894	     */		and	%g5,%g2,%o3
/* 0x0898	     */		sra	%l5,0,%o0
/* 0x089c	     */		sra	%l3,0,%o2
/* 0x08a0	     */		sra	%l1,0,%g3
/* 0x08a4	     */		sub	%o0,%o1,%g2
/* 0x08a8	     */		sub	%o2,%o1,%g5
/* 0x08ac	     */		sub	%g3,%g4,%g4
/* 0x08b0	     */		srlx	%g2,63,%l5
/* 0x08b4	     */		srlx	%g5,63,%l3
/* 0x08b8	     */		srlx	%g4,63,%l1
/* 0x08bc	     */		xor	%l5,1,%l7
/* 0x08c0	     */		sra	%l2,0,%g2
/* 0x08c4	     */		xor	%l4,1,%o7
/* 0x08c8	     */		xor	%l3,1,%o0
/* 0x08cc	     */		xor	%l1,1,%o2
/* 0x08d0	     */		or	%o7,%l7,%l6
/* 0x08d4	     */		or	%o2,%o0,%o4
/* 0x08d8	     */		sub	%g2,%o1,%o1
/* 0x08dc	     */		and	%o4,%l6,%o5
/* 0x08e0	     */		srlx	%o1,63,%l2
/* 0x08e4	     */		and	%o5,%o3,%l5
/* 0x08e8	     */		xor	%l2,1,%g5
/* 0x08ec	     */		andcc	%l5,%g5,%g0
/* 0x08f0	     */		bne,a,pt	%icc,.L900000354
/* 0x08f4	     */		ld	[%sp+140],%o3

! Registers live out of .L77002589: 
! o3 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002586 .L77002587 .L77002588 .L77002589 .L900000357

			.L77002585:
/* 0x08f8	 202 */		sethi	%hi(0x1000),%g1
/* 0x08fc	     */		xor	%g1,-704,%g1
/* 0x0900	     */		add	%g1,%fp,%l4
/* 0x0904	     */		sethi	%hi(0x1800),%g1
/* 0x0908	     */		xor	%g1,-256,%g1
/* 0x090c	     */		add	%g1,%fp,%o7
/* 0x0910	     */		sethi	%hi(0x2400),%g1
/* 0x0914	 203 */		add	%i3,1,%l5
/* 0x0918	 202 */		xor	%g1,-384,%g1
/* 0x091c	 203 */		cmp	%l5,4
/* 0x0920	 202 */		or	%g0,0,%o5
/* 0x0924	     */		add	%fp,-1600,%o4
/* 0x0928	     */		add	%fp,-3200,%o3
/* 0x092c	     */		ld	[%sp+132],%l6
/* 0x0930	     */		ld	[%sp+124],%o0
/* 0x0934	     */		sub	%l6,%o0,%o0
/* 0x0938	     */		sub	%o0,1,%g5
/* 0x093c	     */		add	%g1,%fp,%l6
/* 0x0940	 203 */		bl,pn	%icc,.L77002611
/* 0x0944	     */		nop

! Registers live out of .L77002585: 
! g5 o3 o4 o5 sp o7 l0 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002585

			.L900000342:
/* 0x0948	 203 */		sll	%g5,1,%l3
/* 0x094c	     */		add	%i2,%l3,%g2
/* 0x0950	     */		add	%i1,%g5,%o0
/* 0x0954	     */		add	%i0,%g5,%l7
/* 0x0958	     */		add	%i4,%g5,%g4
/* 0x095c	     */		add	%i5,%g5,%g3
/* 0x0960	     */		sub	%i3,3,%o1

! Registers live out of .L900000342: 
! g2 g3 g4 o0 o1 o3 o4 o5 sp o7 l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000340 .L900000342

			.L900000340:
/* 0x0964	 203 */		prefetch	[%g3-45],0
/* 0x0968	     */		prefetch	[%g4-45],0
/* 0x096c	 202 */		add	%o5,4,%o5
/* 0x0970	 203 */		add	%g2,-8,%g2
/* 0x0974	 204 */		ldub	[%g3],%g5
/* 0x0978	 202 */		cmp	%o5,%o1
/* 0x097c	 203 */		add	%o0,-4,%o0
/* 0x0980	 204 */		stb	%g5,[%o4]
/* 0x0984	 203 */		add	%l7,-4,%l7
/* 0x0988	     */		add	%g4,-4,%g4
/* 0x098c	     */		add	%g3,-4,%g3
/* 0x0990	 202 */		add	%l6,8,%l6
/* 0x0994	 205 */		ldub	[%g4+4],%l2
/* 0x0998	 202 */		add	%o7,4,%o7
/* 0x099c	     */		add	%l4,4,%l4
/* 0x09a0	 205 */		stb	%l2,[%o3]
/* 0x09a4	 202 */		add	%o3,4,%o3
/* 0x09a8	     */		add	%o4,4,%o4
/* 0x09ac	 206 */		ldub	[%l7+4],%l1
/* 0x09b0	     */		stb	%l1,[%l4-4]
/* 0x09b4	 207 */		ldub	[%o0+4],%o2
/* 0x09b8	     */		stb	%o2,[%o7-4]
/* 0x09bc	 208 */		lduh	[%g2+8],%l3
/* 0x09c0	     */		sth	%l3,[%l6-8]
/* 0x09c4	 204 */		ldub	[%g3+3],%l5
/* 0x09c8	     */		stb	%l5,[%o4-3]
/* 0x09cc	 205 */		ldub	[%g4+3],%g5
/* 0x09d0	 203 */		prefetch	[%l7-42],0
/* 0x09d4	     */		prefetch	[%o0-42],0
/* 0x09d8	 205 */		stb	%g5,[%o3-3]
/* 0x09dc	 206 */		ldub	[%l7+3],%l2
/* 0x09e0	     */		stb	%l2,[%l4-3]
/* 0x09e4	 207 */		ldub	[%o0+3],%l1
/* 0x09e8	     */		stb	%l1,[%o7-3]
/* 0x09ec	 208 */		lduh	[%g2+6],%o2
/* 0x09f0	     */		sth	%o2,[%l6-6]
/* 0x09f4	 204 */		ldub	[%g3+2],%l3
/* 0x09f8	     */		stb	%l3,[%o4-2]
/* 0x09fc	 205 */		ldub	[%g4+2],%l5
/* 0x0a00	     */		stb	%l5,[%o3-2]
/* 0x0a04	 206 */		ldub	[%l7+2],%g5
/* 0x0a08	     */		stb	%g5,[%l4-2]
/* 0x0a0c	 207 */		ldub	[%o0+2],%l2
/* 0x0a10	 203 */		prefetch	[%g2-86],0
/* 0x0a14	 207 */		stb	%l2,[%o7-2]
/* 0x0a18	 208 */		lduh	[%g2+4],%l1
/* 0x0a1c	     */		sth	%l1,[%l6-4]
/* 0x0a20	 204 */		ldub	[%g3+1],%o2
/* 0x0a24	     */		stb	%o2,[%o4-1]
/* 0x0a28	 205 */		ldub	[%g4+1],%l3
/* 0x0a2c	     */		stb	%l3,[%o3-1]
/* 0x0a30	 206 */		ldub	[%l7+1],%l5
/* 0x0a34	     */		stb	%l5,[%l4-1]
/* 0x0a38	 207 */		ldub	[%o0+1],%g5
/* 0x0a3c	     */		stb	%g5,[%o7-1]
/* 0x0a40	 208 */		lduh	[%g2+2],%l2
/* 0x0a44	 202 */		ble,pt	%icc,.L900000340
/* 0x0a48	 208 */		sth	%l2,[%l6-2]

! Registers live out of .L900000340: 
! g2 g3 g4 o0 o1 o3 o4 o5 sp o7 l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000340

			.L900000343:
/* 0x0a4c	 202 */		cmp	%o5,%i3
/* 0x0a50	 203 */		sub	%g3,%i5,%g5
/* 0x0a54	 202 */		bg,pn	%icc,.L900000335
/* 0x0a58	 203 */		nop

! Registers live out of .L900000343: 
! g5 o3 o4 o5 sp o7 l0 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002585 .L900000343

			.L77002611:
/* 0x0a5c	 202 */		add	%o5,1,%o5

! Registers live out of .L77002611: 
! g5 o3 o4 o5 sp o7 l0 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002611 .L900000353

			.L900000353:
/* 0x0a60	 204 */		ldub	[%g5+%i5],%g3
/* 0x0a64	     */		stb	%g3,[%o4]
/* 0x0a68	 205 */		ldub	[%g5+%i4],%g4
/* 0x0a6c	     */		stb	%g4,[%o3]
/* 0x0a70	 208 */		sll	%g5,1,%l7
/* 0x0a74	 206 */		ldub	[%g5+%i0],%g2
/* 0x0a78	 202 */		cmp	%o5,%i3
/* 0x0a7c	 206 */		stb	%g2,[%l4]
/* 0x0a80	 202 */		add	%o4,1,%o4
/* 0x0a84	     */		add	%o3,1,%o3
/* 0x0a88	 207 */		ldub	[%g5+%i1],%o1
/* 0x0a8c	 202 */		add	%l4,1,%l4
/* 0x0a90	 207 */		stb	%o1,[%o7]
/* 0x0a94	 202 */		sub	%g5,1,%g5
/* 0x0a98	 208 */		lduh	[%l7+%i2],%l1
/* 0x0a9c	 202 */		add	%o7,1,%o7
/* 0x0aa0	 208 */		sth	%l1,[%l6]
/* 0x0aa4	 202 */		add	%l6,2,%l6
/* 0x0aa8	     */		ble,pt	%icc,.L900000353
/* 0x0aac	     */		add	%o5,1,%o5

! Registers live out of .L900000353: 
! g5 o3 o4 o5 sp o7 l0 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000343 .L900000353

			.L900000335:
/* 0x0ab0	 203 */		ba	.L900000351
/* 0x0ab4	 225 */		ld	[%sp+120],%i3

! Registers live out of .L900000335: 
! sp l0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002589

			.L900000354:
/* 0x0ab8	 202 */		sethi	%hi(0x1000),%g1
/* 0x0abc	     */		xor	%g1,-704,%g1
/* 0x0ac0	     */		add	%g1,%fp,%g3
/* 0x0ac4	     */		sethi	%hi(0x1800),%g1
/* 0x0ac8	     */		xor	%g1,-256,%g1
/* 0x0acc	     */		add	%g1,%fp,%g2
/* 0x0ad0	     */		sethi	%hi(0x2400),%g1
/* 0x0ad4	 203 */		add	%i3,1,%o0
/* 0x0ad8	 202 */		xor	%g1,-384,%g1
/* 0x0adc	 203 */		cmp	%o0,4
/* 0x0ae0	 202 */		sub	%o3,1,%l4
/* 0x0ae4	     */		or	%g0,0,%l6
/* 0x0ae8	     */		add	%fp,-1600,%l7
/* 0x0aec	     */		add	%fp,-3200,%g4
/* 0x0af0	     */		add	%g1,%fp,%g5
/* 0x0af4	 203 */		bl,pn	%icc,.L77002610
/* 0x0af8	     */		nop

! Registers live out of .L900000354: 
! g2 g3 g4 g5 sp l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000354

			.L900000338:
/* 0x0afc	 203 */		sll	%l4,1,%o5
/* 0x0b00	     */		add	%i2,%o5,%o0
/* 0x0b04	     */		add	%i1,%l4,%l5
/* 0x0b08	     */		add	%i0,%l4,%o1
/* 0x0b0c	     */		add	%i4,%l4,%l2
/* 0x0b10	     */		add	%i5,%l4,%l3
/* 0x0b14	     */		sub	%i3,3,%l1

! Registers live out of .L900000338: 
! g2 g3 g4 g5 o0 o1 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000336 .L900000338

			.L900000336:
/* 0x0b18	 203 */		prefetch	[%l3-45],0
/* 0x0b1c	     */		prefetch	[%l2-45],0
/* 0x0b20	 202 */		add	%l6,4,%l6
/* 0x0b24	 203 */		add	%o0,-8,%o0
/* 0x0b28	 204 */		ldub	[%l3],%o2
/* 0x0b2c	 202 */		cmp	%l6,%l1
/* 0x0b30	 203 */		add	%l5,-4,%l5
/* 0x0b34	 205 */		ldub	[%l2],%o3
/* 0x0b38	 203 */		add	%l2,-4,%l2
/* 0x0b3c	 206 */		ldub	[%o1],%o4
/* 0x0b40	 203 */		add	%o1,-4,%o1
/* 0x0b44	     */		add	%l3,-4,%l3
/* 0x0b48	 202 */		add	%g5,8,%g5
/* 0x0b4c	 207 */		ldub	[%l5+4],%l4
/* 0x0b50	 202 */		add	%g2,4,%g2
/* 0x0b54	     */		add	%g3,4,%g3
/* 0x0b58	 208 */		lduh	[%o0+8],%o7
/* 0x0b5c	 204 */		stb	%o2,[%l7]
/* 0x0b60	 202 */		add	%g4,4,%g4
/* 0x0b64	     */		add	%l7,4,%l7
/* 0x0b68	 205 */		stb	%o3,[%g4-4]
/* 0x0b6c	 206 */		stb	%o4,[%g3-4]
/* 0x0b70	 207 */		stb	%l4,[%g2-4]
/* 0x0b74	 208 */		sth	%o7,[%g5-8]
/* 0x0b78	 204 */		ldub	[%l3+3],%o2
/* 0x0b7c	 205 */		ldub	[%l2+3],%o3
/* 0x0b80	 206 */		ldub	[%o1+3],%o4
/* 0x0b84	 203 */		prefetch	[%o1-42],0
/* 0x0b88	     */		prefetch	[%l5-42],0
/* 0x0b8c	 207 */		ldub	[%l5+3],%o5
/* 0x0b90	 208 */		lduh	[%o0+6],%l4
/* 0x0b94	 204 */		stb	%o2,[%l7-3]
/* 0x0b98	 205 */		stb	%o3,[%g4-3]
/* 0x0b9c	 206 */		stb	%o4,[%g3-3]
/* 0x0ba0	 207 */		stb	%o5,[%g2-3]
/* 0x0ba4	 208 */		sth	%l4,[%g5-6]
/* 0x0ba8	 204 */		ldub	[%l3+2],%o2
/* 0x0bac	 205 */		ldub	[%l2+2],%o3
/* 0x0bb0	 206 */		ldub	[%o1+2],%o4
/* 0x0bb4	 207 */		ldub	[%l5+2],%o5
/* 0x0bb8	 208 */		lduh	[%o0+4],%o7
/* 0x0bbc	 204 */		stb	%o2,[%l7-2]
/* 0x0bc0	 203 */		prefetch	[%o0-86],0
/* 0x0bc4	 205 */		stb	%o3,[%g4-2]
/* 0x0bc8	 206 */		stb	%o4,[%g3-2]
/* 0x0bcc	 207 */		stb	%o5,[%g2-2]
/* 0x0bd0	 208 */		sth	%o7,[%g5-4]
/* 0x0bd4	 204 */		ldub	[%l3+1],%l4
/* 0x0bd8	 205 */		ldub	[%l2+1],%o2
/* 0x0bdc	 206 */		ldub	[%o1+1],%o3
/* 0x0be0	 207 */		ldub	[%l5+1],%o4
/* 0x0be4	 208 */		lduh	[%o0+2],%o5
/* 0x0be8	 204 */		stb	%l4,[%l7-1]
/* 0x0bec	 205 */		stb	%o2,[%g4-1]
/* 0x0bf0	 206 */		stb	%o3,[%g3-1]
/* 0x0bf4	 207 */		stb	%o4,[%g2-1]
/* 0x0bf8	 202 */		ble,pt	%icc,.L900000336
/* 0x0bfc	 208 */		sth	%o5,[%g5-2]

! Registers live out of .L900000336: 
! g2 g3 g4 g5 o0 o1 sp l0 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000336

			.L900000339:
/* 0x0c00	 202 */		cmp	%l6,%i3
/* 0x0c04	 203 */		sub	%l3,%i5,%l4
/* 0x0c08	 202 */		bg,pn	%icc,.L77002583
/* 0x0c0c	 203 */		nop

! Registers live out of .L900000339: 
! g2 g3 g4 g5 sp l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000339 .L900000354

			.L77002610:
/* 0x0c10	 202 */		add	%l6,1,%l6

! Registers live out of .L77002610: 
! g2 g3 g4 g5 sp l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002610 .L900000352

			.L900000352:
/* 0x0c14	 208 */		sll	%l4,1,%o7
/* 0x0c18	 207 */		ldub	[%l4+%i1],%o0
/* 0x0c1c	 206 */		ldub	[%l4+%i0],%l3
/* 0x0c20	 205 */		ldub	[%l4+%i4],%o2
/* 0x0c24	 204 */		ldub	[%l4+%i5],%l2
/* 0x0c28	 208 */		lduh	[%o7+%i2],%l5
/* 0x0c2c	 207 */		stb	%o0,[%g2]
/* 0x0c30	 202 */		cmp	%l6,%i3
/* 0x0c34	 206 */		stb	%l3,[%g3]
/* 0x0c38	 202 */		add	%g2,1,%g2
/* 0x0c3c	     */		add	%g3,1,%g3
/* 0x0c40	 208 */		sth	%l5,[%g5]
/* 0x0c44	 202 */		add	%g5,2,%g5
/* 0x0c48	     */		sub	%l4,1,%l4
/* 0x0c4c	 205 */		stb	%o2,[%g4]
/* 0x0c50	 202 */		add	%g4,1,%g4
/* 0x0c54	 204 */		stb	%l2,[%l7]
/* 0x0c58	 202 */		add	%l7,1,%l7
/* 0x0c5c	     */		ble,pt	%icc,.L900000352
/* 0x0c60	     */		add	%l6,1,%l6

! Registers live out of .L900000352: 
! g2 g3 g4 g5 sp l0 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000339 .L900000352

			.L77002583:
/* 0x0c64	 202 */		ba	.L900000351
/* 0x0c68	 225 */		ld	[%sp+120],%i3

! Registers live out of .L77002583: 
! sp l0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000348

			.L900000355:
/* 0x0c6c	 212 */		ld	[%l2+%lo(___const_seg_900000301+12)],%f13
/* 0x0c70	 213 */		ld	[%sp+132],%l6
/* 0x0c74	 212 */		add	%l0,-1,%o1
/* 0x0c78	     */		fdivs	%f13,%f4,%f4
/* 0x0c7c	 213 */		or	%g0,0,%l4

! Registers live out of .L900000355: 
! o1 sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002669 .L900000355

			.L900000356:
/* 0x0c80	 213 */		sethi	%hi(0x1000),%g1
/* 0x0c84	     */		xor	%g1,-704,%g1
/* 0x0c88	     */		sub	%l6,1,%l3
/* 0x0c8c	     */		add	%g1,%fp,%l6
/* 0x0c90	     */		sethi	%hi(0x1800),%g1
/* 0x0c94	     */		xor	%g1,-256,%g1
/* 0x0c98	     */		add	%g1,%fp,%l5
/* 0x0c9c	     */		sethi	%hi(0x2400),%g1

!  214		      !         i = (j+skipcol) * xscale;

/* 0x0ca0	 214 */		add	%o1,1,%i3
/* 0x0ca4	 213 */		xor	%g1,-384,%g1
/* 0x0ca8	 214 */		cmp	%i3,5
/* 0x0cac	 213 */		add	%fp,-1600,%g3
/* 0x0cb0	     */		add	%fp,-3200,%l7
/* 0x0cb4	     */		add	%g1,%fp,%g5
/* 0x0cb8	     */		ld	[%sp+124],%o0
/* 0x0cbc	 214 */		bl,pn	%icc,.L77002543
/* 0x0cc0	     */		nop

! Registers live out of .L900000356: 
! g3 g5 o0 o1 sp l0 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000356

			.L900000346:
/* 0x0cc4	 214 */		st	%o0,[%sp+136]
/* 0x0cc8	     */		ld	[%sp+136],%f2
/* 0x0ccc	     */		sethi	%hi(___const_seg_900000301+24),%o4
/* 0x0cd0	     */		ldd	[%o4+%lo(___const_seg_900000301+24)],%f32
/* 0x0cd4	     */		fitod	%f2,%f38
/* 0x0cd8	     */		sub	%o0,%g3,%l2
/* 0x0cdc	 213 */		or	%g0,3,%l4
/* 0x0ce0	 214 */		sub	%o1,1,%o5
/* 0x0ce4	     */		faddd	%f38,%f32,%f40
/* 0x0ce8	     */		fdtos	%f38,%f6
/* 0x0cec	     */		fdtos	%f40,%f8
/* 0x0cf0	     */		fmuls	%f6,%f4,%f10
/* 0x0cf4	     */		faddd	%f40,%f32,%f34
/* 0x0cf8	     */		fmuls	%f8,%f4,%f14
/* 0x0cfc	     */		fstoi	%f10,%f12
/* 0x0d00	     */		st	%f12,[%sp+128]
/* 0x0d04	     */		fdtos	%f34,%f18
/* 0x0d08	     */		ld	[%sp+128],%o0
/* 0x0d0c	     */		fstoi	%f14,%f16
/* 0x0d10	     */		st	%f16,[%sp+128]

!  215		      !         if (i<0)  i = n + i - 1;

/* 0x0d14	 215 */		add	%o0,%l3,%g4
/* 0x0d18	 214 */		sra	%o0,0,%o4
/* 0x0d1c	     */		fmuls	%f18,%f4,%f0
/* 0x0d20	     */		ld	[%sp+128],%l1
/* 0x0d24	 215 */		movrlz	%o4,%g4,%o0

! Registers live out of .L900000346: 
! g3 g5 o0 o1 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000344 .L900000346

			.L900000344:
/* 0x0d28	 213 */		add	%l4,2,%l4
/* 0x0d2c	     */		add	%g5,4,%g5
/* 0x0d30	 214 */		sra	%l1,0,%o7
/* 0x0d34	 215 */		add	%l1,%l3,%o2
/* 0x0d38	     */		movrgez	%o7,%l1,%o2
/* 0x0d3c	 213 */		cmp	%l4,%o5
/* 0x0d40	     */		add	%l5,2,%l5

!  216		      !         zred[j]   = red[i];

/* 0x0d44	 216 */		ldub	[%o0+%i5],%o7
/* 0x0d48	 214 */		fstoi	%f0,%f20
/* 0x0d4c	     */		st	%f20,[%sp+128]
/* 0x0d50	 213 */		add	%l6,2,%l6
/* 0x0d54	     */		add	%l7,2,%l7
/* 0x0d58	 216 */		stb	%o7,[%g3]
/* 0x0d5c	 213 */		add	%g3,2,%g3

!  217		      !         zgreen[j] = green[i];

/* 0x0d60	 217 */		ldub	[%o0+%i4],%l1
/* 0x0d64	     */		stb	%l1,[%l7-2]
/* 0x0d68	 214 */		faddd	%f34,%f32,%f42

!  218		      !         zblue[j]  = blue[i];

/* 0x0d6c	 218 */		ldub	[%o0+%i0],%o3
/* 0x0d70	     */		stb	%o3,[%l6-2]

!  219		      !         zalpha[j] = alpha[i];

/* 0x0d74	 219 */		ldub	[%o0+%i1],%g4
/* 0x0d78	 214 */		fdtos	%f42,%f22
/* 0x0d7c	     */		ld	[%sp+128],%i3
/* 0x0d80	 219 */		stb	%g4,[%l5-2]

!  220		      !         zdepth[j] = z[i];

/* 0x0d84	 220 */		sll	%o0,1,%o0
/* 0x0d88	     */		lduh	[%o0+%i2],%g2
/* 0x0d8c	     */		sth	%g2,[%g5-4]
/* 0x0d90	 214 */		fmuls	%f22,%f4,%f24
/* 0x0d94	     */		sra	%i3,0,%g4
/* 0x0d98	 215 */		add	%i3,%l3,%o0
/* 0x0d9c	     */		movrgez	%g4,%i3,%o0
/* 0x0da0	 214 */		fstoi	%f24,%f26
/* 0x0da4	 216 */		ldub	[%o2+%i5],%o7
/* 0x0da8	 214 */		st	%f26,[%sp+128]
/* 0x0dac	 216 */		stb	%o7,[%g3-1]
/* 0x0db0	 217 */		ldub	[%o2+%i4],%l1
/* 0x0db4	     */		stb	%l1,[%l7-1]
/* 0x0db8	 214 */		faddd	%f42,%f32,%f34
/* 0x0dbc	 218 */		ldub	[%o2+%i0],%o3
/* 0x0dc0	     */		stb	%o3,[%l6-1]
/* 0x0dc4	 219 */		ldub	[%o2+%i1],%g4
/* 0x0dc8	 214 */		fdtos	%f34,%f28
/* 0x0dcc	     */		ld	[%sp+128],%l1
/* 0x0dd0	 219 */		stb	%g4,[%l5-1]
/* 0x0dd4	 220 */		sll	%o2,1,%o2
/* 0x0dd8	     */		lduh	[%o2+%i2],%g2
/* 0x0ddc	     */		sth	%g2,[%g5-2]
/* 0x0de0	 213 */		ble,pt	%icc,.L900000344
/* 0x0de4	 214 */		fmuls	%f28,%f4,%f0

! Registers live out of .L900000344: 
! g3 g5 o0 o1 o5 sp l0 l1 l2 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000344

			.L900000347:
/* 0x0de8	 216 */		ldub	[%o0+%i5],%i3
/* 0x0dec	 213 */		add	%g3,3,%g3
/* 0x0df0	 216 */		stb	%i3,[%g3-3]
/* 0x0df4	 217 */		ldub	[%o0+%i4],%o2
/* 0x0df8	 213 */		add	%l7,3,%l7
/* 0x0dfc	 217 */		stb	%o2,[%l7-3]
/* 0x0e00	 218 */		ldub	[%o0+%i0],%o5
/* 0x0e04	 213 */		add	%l6,3,%l6
/* 0x0e08	 218 */		stb	%o5,[%l6-3]
/* 0x0e0c	 219 */		ldub	[%o0+%i1],%o4
/* 0x0e10	 213 */		add	%l5,3,%l5
/* 0x0e14	 219 */		stb	%o4,[%l5-3]
/* 0x0e18	 220 */		sll	%o0,1,%o7
/* 0x0e1c	     */		lduh	[%o7+%i2],%o3
/* 0x0e20	 213 */		add	%g5,6,%g5
/* 0x0e24	 220 */		sth	%o3,[%g5-6]
/* 0x0e28	 215 */		add	%l1,%l3,%g4
/* 0x0e2c	 214 */		sra	%l1,0,%g2
/* 0x0e30	 215 */		movrlz	%g2,%g4,%l1
/* 0x0e34	 216 */		ldub	[%l1+%i5],%g2
/* 0x0e38	     */		stb	%g2,[%g3-2]
/* 0x0e3c	 217 */		ldub	[%l1+%i4],%i3
/* 0x0e40	     */		stb	%i3,[%l7-2]
/* 0x0e44	 218 */		ldub	[%l1+%i0],%o2
/* 0x0e48	     */		stb	%o2,[%l6-2]
/* 0x0e4c	 219 */		ldub	[%l1+%i1],%o5
/* 0x0e50	     */		stb	%o5,[%l5-2]
/* 0x0e54	 214 */		fstoi	%f0,%f0
/* 0x0e58	     */		st	%f0,[%sp+128]
/* 0x0e5c	     */		ld	[%sp+128],%o7
/* 0x0e60	 220 */		sll	%l1,1,%l1
/* 0x0e64	     */		lduh	[%l1+%i2],%o4
/* 0x0e68	     */		sth	%o4,[%g5-4]
/* 0x0e6c	 214 */		sra	%o7,0,%o2
/* 0x0e70	 215 */		add	%o7,%l3,%g4
/* 0x0e74	 214 */		add	%g3,%l2,%o0
/* 0x0e78	 215 */		movrlz	%o2,%g4,%o7
/* 0x0e7c	 216 */		ldub	[%o7+%i5],%g2
/* 0x0e80	     */		stb	%g2,[%g3-1]
/* 0x0e84	 217 */		ldub	[%o7+%i4],%i3
/* 0x0e88	     */		stb	%i3,[%l7-1]
/* 0x0e8c	 218 */		ldub	[%o7+%i0],%o2
/* 0x0e90	     */		stb	%o2,[%l6-1]
/* 0x0e94	 219 */		ldub	[%o7+%i1],%o5
/* 0x0e98	 220 */		sll	%o7,1,%o7
/* 0x0e9c	 219 */		stb	%o5,[%l5-1]
/* 0x0ea0	 220 */		lduh	[%o7+%i2],%l1
/* 0x0ea4	 213 */		cmp	%l4,%o1
/* 0x0ea8	 220 */		sth	%l1,[%g5-2]
/* 0x0eac	 213 */		bg,pn	%icc,.L77002612
/* 0x0eb0	 214 */		nop

! Registers live out of .L900000347: 
! g3 g5 o0 o1 sp l0 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000347 .L900000356

			.L77002543:
/* 0x0eb4	 214 */		st	%o0,[%sp+136]

! Registers live out of .L77002543: 
! g3 g5 o0 o1 sp l0 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002543 .L900000350

			.L900000350:
/* 0x0eb8	 214 */		ld	[%sp+136],%f15
/* 0x0ebc	 213 */		add	%l4,1,%l4
/* 0x0ec0	     */		cmp	%l4,%o1
/* 0x0ec4	 214 */		fitos	%f15,%f17
/* 0x0ec8	 213 */		add	%o0,1,%o0
/* 0x0ecc	 214 */		fmuls	%f17,%f4,%f19
/* 0x0ed0	     */		fstoi	%f19,%f21
/* 0x0ed4	     */		st	%f21,[%sp+128]
/* 0x0ed8	     */		ld	[%sp+128],%g4
/* 0x0edc	   0 */		sra	%g4,0,%o3
/* 0x0ee0	 215 */		add	%g4,%l3,%i3
/* 0x0ee4	     */		movrlz	%o3,%i3,%g4
/* 0x0ee8	 216 */		ldub	[%g4+%i5],%l1
/* 0x0eec	     */		stb	%l1,[%g3]
/* 0x0ef0	 217 */		ldub	[%g4+%i4],%o5
/* 0x0ef4	     */		stb	%o5,[%l7]
/* 0x0ef8	 218 */		ldub	[%g4+%i0],%g2
/* 0x0efc	     */		stb	%g2,[%l6]
/* 0x0f00	 219 */		ldub	[%g4+%i1],%o3
/* 0x0f04	 220 */		sll	%g4,1,%o2
/* 0x0f08	 219 */		stb	%o3,[%l5]
/* 0x0f0c	 213 */		add	%g3,1,%g3
/* 0x0f10	 220 */		lduh	[%o2+%i2],%o4
/* 0x0f14	 213 */		add	%l7,1,%l7
/* 0x0f18	 220 */		sth	%o4,[%g5]
/* 0x0f1c	 213 */		add	%l6,1,%l6
/* 0x0f20	     */		add	%l5,1,%l5
/* 0x0f24	     */		add	%g5,2,%g5
/* 0x0f28	     */		ble,a,pt	%icc,.L900000350
/* 0x0f2c	 214 */		st	%o0,[%sp+136]

! Registers live out of .L900000350: 
! g3 g5 o0 o1 sp l0 l4 l5 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		
!  221		      !      }
!  222		      !   }
!  224		      !   /* write the span */
!  225		      !   for (r=r0; r<r1; r++) {

                       
! predecessor blocks: .L77002579 .L77002614 .L900000347 .L900000350

			.L77002612:
/* 0x0f30	 225 */		ld	[%sp+120],%i3

! Registers live out of .L77002612: 
! sp l0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002583 .L77002612 .L900000335

			.L900000351:
/* 0x0f34	 225 */		ld	[%sp+116],%i0
/* 0x0f38	     */		cmp	%i0,%i3
/* 0x0f3c	     */		bge,pn	%icc,.L77002562
/* 0x0f40	     */		ld	[%sp+112],%i1

! Registers live out of .L900000351: 
! sp l0 i1 i3 fp i7 gsr 
! 
		
!  226		      !      gl_write_color_span( ctx, m, x+skipcol, r, zdepth,
!  227		      !                           zred, zgreen, zblue, zalpha, GL_BITMAP );

                       
! predecessor blocks: .L900000351

			.L77002628:
/* 0x0f44	 227 */		sethi	%hi(0x1800),%g1
/* 0x0f48	     */		xor	%g1,-256,%g1
/* 0x0f4c	 225 */		add	%i3,-1,%i4
/* 0x0f50	     */		ld	[%sp+124],%i5
/* 0x0f54	 227 */		add	%g1,%fp,%i2
/* 0x0f58	     */		sethi	%hi(0x1800),%l4
/* 0x0f5c	 225 */		add	%i1,%i5,%i0
/* 0x0f60	     */		ld	[%sp+116],%i5

! Registers live out of .L77002628: 
! sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002628 .L900000349

			.L900000349:
/* 0x0f64	 227 */		sethi	%hi(0x1000),%g1
/* 0x0f68	     */		xor	%g1,-704,%g1
/* 0x0f6c	     */		add	%g1,%fp,%o5
/* 0x0f70	     */		sllx	%o5,32,%o4
/* 0x0f74	     */		srl	%i2,0,%o3
/* 0x0f78	     */		or	%o4,%o3,%o5
/* 0x0f7c	     */		sethi	%hi(0x2400),%g1
/* 0x0f80	     */		add	%l4,512,%i1
/* 0x0f84	     */		add	%fp,-3200,%g2
/* 0x0f88	     */		xor	%g1,-384,%g1
/* 0x0f8c	     */		or	%g0,%i5,%o3
/* 0x0f90	     */		add	%g1,%fp,%g1
/* 0x0f94	     */		or	%g0,%i0,%o2
/* 0x0f98	     */		stx	%o5,[%sp+96]
/* 0x0f9c	     */		add	%fp,-1600,%o5
/* 0x0fa0	     */		or	%g0,%l0,%o1
/* 0x0fa4	     */		ld	[%sp+108],%o0
/* 0x0fa8	 225 */		add	%i5,1,%i5
/* 0x0fac	 227 */		st	%g2,[%sp+92]
/* 0x0fb0	     */		st	%i1,[%sp+104]
/* 0x0fb4	     */		call	gl_write_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+104 %sp+96	! Result = 
/* 0x0fb8	     */		or	%g0,%g1,%o4
/* 0x0fbc	 225 */		cmp	%i5,%i4
/* 0x0fc0	     */		ble,pt	%icc,.L900000349
/* 0x0fc4	 227 */		sethi	%hi(0x1800),%l4

! Registers live out of .L900000349: 
! sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002481 .L77002495 .L77002513 gl_write_zoomed_color_span .L900000349 .L900000351 .L900000360

			.L77002562:
/* 0x0fc8	 153 */		ret	! Result = 
/* 0x0fcc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77002626

			.L77002521:
/* 0x0fd0	 197 */		sethi	%hi(.L80),%o1

! Registers live out of .L77002521: 
! o1 o2 sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002521 .L77002657

			.L900000358:
/* 0x0fd4	 197 */		sethi	%hi(.L79),%g3
/* 0x0fd8	     */		add	%g3,%lo(.L79),%o0
/* 0x0fdc	     */		add	%o1,%lo(.L80),%o1
/* 0x0fe0	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0fe4	     */		or	%g0,197,%o2
/* 0x0fe8	     */		ld	[%sp+108],%i3
/* 0x0fec	     */		ld	[%i3+%l6],%f4
/* 0x0ff0	     */		ba	.L900000348
/* 0x0ff4	 200 */		sethi	%hi(___const_seg_900000301+8),%l6

! Registers live out of .L900000358: 
! sp l0 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! f4 
		/* 0x0ff8	   0 */		.type	gl_write_zoomed_color_span,2
/* 0x0ff8	   0 */		.size	gl_write_zoomed_color_span,(.-gl_write_zoomed_color_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000401:
/* 000000	   0 */		.word	1127219200,0
/* 0x0008	     */		.word	-1082130432
/* 0x000c	     */		.word	1065353216
/* 0x0010	     */		.word	1127219200
/* 0x0014	   0 */		.align	8
/* 0x0018	   0 */		.word	1072693248,0
/* 0x0020	   0 */		.type	___const_seg_900000401,1
/* 0x0020	   0 */		.size	___const_seg_900000401,(.-___const_seg_900000401)
/* 0x0020	   0 */		.align	4

!  228		      !   }
!  229		      !}
!  233		      !/*
!  234		      ! * As above, but write CI pixels.
!  235		      ! */
!  236		      !void
!  237		      !gl_write_zoomed_index_span( GLcontext *ctx,
!  238		      !                            GLuint n, GLint x, GLint y, const GLdepth z[],
!  239		      !                            const GLuint indexes[], GLint y0 )
!  240		      !{

!
! SUBROUTINE gl_write_zoomed_index_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_zoomed_index_span
                       

			gl_write_zoomed_index_span:
/* 000000	 240 */		sethi	%hi(0x2400),%g1
/* 0x0004	     */		xor	%g1,-512,%g1
/* 0x0008	     */		save	%sp,%g1,%sp

!  241		      !   GLint m;
!  242		      !   GLint r0, r1, row, r;
!  243		      !   GLint i, j, skipcol;
!  244		      !   GLuint zindexes[MAX_WIDTH];  /* zoomed color indexes */
!  245		      !   GLdepth zdepth[MAX_WIDTH];  /* zoomed depth values */
!  246		      !   GLint maxwidth = MIN2( ctx->Buffer->Width, MAX_WIDTH );
!  248		      !   /* compute width of output row */
!  249		      !   m = (GLint) ABSF( n * ctx->Pixel.ZoomX );

/* 0x000c	 249 */		st	%i1,[%sp+104]
/* 0x0010	     */		sethi	%hi(___const_seg_900000401),%l0
/* 0x0014	     */		sethi	%hi(___const_seg_900000401+16),%l1
/* 0x0018	     */		ldd	[%l0+%lo(___const_seg_900000401)],%f46
/* 0x001c	     */		ld	[%l1+%lo(___const_seg_900000401+16)],%f0
/* 0x0020	     */		ld	[%sp+104],%f1
/* 0x0024	     */		sethi	%hi(0xac00),%l1
/* 0x0028	     */		add	%l1,592,%l3
/* 0x002c	     */		fsubd	%f0,%f46,%f48
/* 0x0030	     */		ld	[%i0+%l3],%f4
/* 0x0034	     */		fdtos	%f48,%f7
/* 0x0038	     */		fmuls	%f7,%f4,%f9
/* 0x003c	     */		fabss	%f9,%f11
/* 0x0040	     */		fstoi	%f11,%f13
/* 0x0044	     */		st	%f13,[%sp+108]
/* 0x0048	     */		ld	[%sp+108],%l0

!  250		      !   if (m==0) {

/* 0x004c	 250 */		cmp	%l0,0
/* 0x0050	     */		be,pn	%icc,.L77002799
/* 0x0054	     */		ld	[%fp+92],%o3

! Registers live out of gl_write_zoomed_index_span: 
! o3 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  251		      !      return;
!  252		      !   }
!  253		      !   if (ctx->Pixel.ZoomX<0.0) {
!  254		      !      /* adjust x coordinate for left/right mirroring */
!  255		      !      x = x - m;
!  256		      !   }
!  258		      !   /* compute which rows to draw */
!  259		      !   row = y-y0;
!  260		      !   r0 = y0 + (GLint) (row * ctx->Pixel.ZoomY);

                       
! predecessor blocks: gl_write_zoomed_index_span

			.L77002718:
/* 0x0058	 260 */		add	%l1,596,%l4
/* 0x005c	     */		ld	[%i0+%l4],%f10
/* 0x0060	 259 */		sub	%i3,%o3,%o0

!  261		      !   r1 = y0 + (GLint) ((row+1) * ctx->Pixel.ZoomY);

/* 0x0064	 261 */		add	%o0,1,%g4
/* 0x0068	 260 */		st	%o0,[%sp+116]
/* 0x006c	 261 */		st	%g4,[%sp+120]
/* 0x0070	 260 */		ld	[%sp+116],%f6
/* 0x0074	 261 */		ld	[%sp+120],%f31
/* 0x0078	 253 */		fstod	%f4,%f52
/* 0x007c	 260 */		fitos	%f6,%f8
/* 0x0080	 261 */		fitos	%f31,%f2
/* 0x0084	 253 */		fzero	%f50
/* 0x0088	 260 */		fmuls	%f8,%f10,%f12
/* 0x008c	 261 */		fmuls	%f2,%f10,%f14
/* 0x0090	 253 */		fcmped	%fcc3,%f52,%f50
/* 0x0094	 255 */		sub	%i2,%l0,%g2
/* 0x0098	 260 */		fstoi	%f12,%f16
/* 0x009c	 261 */		fstoi	%f14,%f18
/* 0x00a0	 260 */		st	%f16,[%sp+112]
/* 0x00a4	 261 */		st	%f18,[%sp+124]
/* 0x00a8	 255 */		movl	%fcc3,%g2,%i2
/* 0x00ac	 260 */		ld	[%sp+112],%g5
/* 0x00b0	 261 */		ld	[%sp+124],%o4
/* 0x00b4	 260 */		add	%o3,%g5,%i3
/* 0x00b8	 261 */		add	%o3,%o4,%l1

!  262		      !   if (r0==r1) {

/* 0x00bc	 262 */		cmp	%i3,%l1
/* 0x00c0	     */		be,pn	%icc,.L77002799
/* 0x00c4	 265 */		cmp	%l1,%i3

! Registers live out of .L77002718: 
! o4 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  263		      !      return;
!  264		      !   }
!  265		      !   else if (r1<r0) {
!  266		      !      GLint rtmp = r1;

                       
! predecessor blocks: .L77002718

			.L77002726:
/* 0x00c8	 266 */		or	%g0,%l1,%l7

!  267		      !      r1 = r0;

/* 0x00cc	 267 */		movl	%icc,%i3,%l1

!  268		      !      r0 = rtmp;

/* 0x00d0	 268 */		movl	%icc,%l7,%i3

!  269		      !   }
!  271		      !   /* return early if r0...r1 is above or below window */
!  272		      !   if (r0<0 && r1<0) {

/* 0x00d4	 272 */		cmp	%i3,0
/* 0x00d8	     */		bl,pn	%icc,.L900000456
/* 0x00dc	     */		cmp	%l1,0

! Registers live out of .L77002726: 
! o4 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002726

			.L77002877:
/* 0x00e0	 246 */		ld	[%i0+2204],%l5
/* 0x00e4	     */		ba	.L900000455
/* 0x00e8	 276 */		ld	[%l5+8],%o2

! Registers live out of .L77002877: 
! o2 o4 sp l0 l1 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002726

			.L900000456:
/* 0x00ec	 272 */		bl,pn	%icc,.L77002799
/* 0x00f0	     */		nop

! Registers live out of .L900000456: 
! o4 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000456

			.L77002881:
/* 0x00f4	 246 */		ld	[%i0+2204],%l5

!  273		      !      /* below window */
!  274		      !      return;
!  275		      !   }
!  276		      !   if (r0>=ctx->Buffer->Height && r1>=ctx->Buffer->Height) {

/* 0x00f8	 276 */		ld	[%l5+8],%o2

! Registers live out of .L77002881: 
! o2 o4 sp l0 l1 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002877 .L77002881

			.L900000455:
/* 0x00fc	 276 */		cmp	%i3,%o2
/* 0x0100	     */		bge,pn	%icc,.L900000454
/* 0x0104	     */		cmp	%l1,%o2

! Registers live out of .L900000455: 
! o2 o4 sp l0 l1 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000455

			.L77002883:
/* 0x0108	 246 */		ld	[%l5+4],%o7
/* 0x010c	     */		sra	%o7,0,%o5
/* 0x0110	     */		sub	%o5,1600,%o2
/* 0x0114	     */		srax	%o2,32,%l6
/* 0x0118	     */		and	%l6,%o2,%l5
/* 0x011c	     */		add	%l5,1600,%o1
/* 0x0120	     */		ba	.L900000453
/* 0x0124	 283 */		cmp	%i2,0

! Registers live out of .L77002883: 
! o1 o2 o4 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000455

			.L900000454:
/* 0x0128	 276 */		bge,pn	%icc,.L77002799
/* 0x012c	     */		nop

! Registers live out of .L900000454: 
! o2 sp l0 l1 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000454

			.L77002887:
/* 0x0130	 246 */		ld	[%l5+4],%l2

!  277		      !      /* above window */
!  278		      !      return;
!  279		      !   }
!  281		      !   /* check if left edge is outside window */
!  282		      !   skipcol = 0;
!  283		      !   if (x<0) {

/* 0x0134	 283 */		cmp	%i2,0
/* 0x0138	 246 */		sra	%l2,0,%g5
/* 0x013c	     */		sub	%g5,1600,%g2
/* 0x0140	     */		srax	%g2,32,%l4
/* 0x0144	     */		and	%l4,%g2,%o4
/* 0x0148	     */		add	%o4,1600,%o1

! Registers live out of .L77002887: 
! o1 o2 o4 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  284		      !      skipcol = -x;
!  285		      !      m += x;

                       
! predecessor blocks: .L77002883 .L77002887

			.L900000453:
/* 0x014c	 285 */		add	%l0,%i2,%l2
/* 0x0150	     */		movl	%icc,%l2,%l0
/* 0x0154	 284 */		sub	%g0,%i2,%l2
/* 0x0158	   0 */		sethi	%hi(0x1800),%g1
/* 0x015c	 282 */		movge	%icc,%g0,%l2
/* 0x0160	   0 */		xor	%g1,-256,%g1

!  286		      !   }
!  287		      !   /* make sure span isn't too long or short */
!  288		      !   if (m>maxwidth) {

/* 0x0164	 288 */		cmp	%l0,%o1
/* 0x0168	   0 */		add	%g1,%fp,%g1
/* 0x016c	 288 */		ble,pn	%icc,.L77002750
/* 0x0170	   0 */		or	%g0,%g1,%l5

! Registers live out of .L900000453: 
! o1 o2 o4 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  289		      !      m = maxwidth;
!  290		      !   }
!  291		      !   else if (m<=0) {
!  292		      !      return;
!  293		      !   }
!  295		      !   assert( m <= MAX_WIDTH );

                       
! predecessor blocks: .L900000453

			.L77002748:
/* 0x0174	 295 */		cmp	%o1,1600
/* 0x0178	     */		bg,pn	%icc,.L77002758
/* 0x017c	 289 */		or	%g0,%o1,%l0

! Registers live out of .L77002748: 
! o1 o2 o4 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  297		      !   /* zoom the span horizontally */
!  298		      !   if (ctx->Pixel.ZoomX==-1.0F) {

                       
! predecessor blocks: .L77002748

			.L77002764:
/* 0x0180	 298 */		sethi	%hi(___const_seg_900000401+8),%l3
/* 0x0184	     */		ld	[%l3+%lo(___const_seg_900000401+8)],%f29
/* 0x0188	     */		fcmps	%fcc0,%f4,%f29
/* 0x018c	     */		fbne,pn	%fcc0,.L77002848
/* 0x0190	 300 */		cmp	%o1,0

! Registers live out of .L77002764: 
! o1 o4 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		
!  299		      !      /* n==m */
!  300		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002764

			.L77002816:
/* 0x0194	 300 */		ble,pn	%icc,.L77002846
/* 0x0198	     */		add	%o1,-1,%l3

! Registers live out of .L77002816: 
! o4 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002816

			.L77002901:
/* 0x019c	 300 */		ba	.L900000452
/* 0x01a0	     */		cmp	%l3,11

! Registers live out of .L77002901: 
! sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  301		      !         i = n - (j+skipcol) - 1;
!  302		      !         zindexes[j] = indexes[i];
!  303		      !         zdepth[j]   = z[i];
!  304		      !      }
!  305		      !   }
!  306		      !   else {
!  307		      !      GLfloat xscale = 1.0F / ctx->Pixel.ZoomX;
!  308		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002764

			.L77002848:
/* 0x01a4	 308 */		ble,pn	%icc,.L77002846
/* 0x01a8	 307 */		add	%o1,-1,%l3

! Registers live out of .L77002848: 
! o4 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002848

			.L77002903:
/* 0x01ac	 307 */		sethi	%hi(___const_seg_900000401+12),%o1
/* 0x01b0	     */		ld	[%o1+%lo(___const_seg_900000401+12)],%f15
/* 0x01b4	 308 */		or	%g0,0,%l6
/* 0x01b8	 307 */		fdivs	%f15,%f4,%f0
/* 0x01bc	     */		ba	.L900000451
/* 0x01c0	 308 */		sub	%i1,1,%l5

! Registers live out of .L77002903: 
! sp l0 l1 l2 l5 l6 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000453

			.L77002750:
/* 0x01c4	 291 */		cmp	%l0,0
/* 0x01c8	     */		ble,pn	%icc,.L77002799
/* 0x01cc	 295 */		cmp	%l0,1600

! Registers live out of .L77002750: 
! o2 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002750

			.L77002860:
/* 0x01d0	 295 */		bg,pn	%icc,.L77002758
/* 0x01d4	     */		nop

! Registers live out of .L77002860: 
! o2 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002860

			.L77002859:
/* 0x01d8	 298 */		sethi	%hi(___const_seg_900000401+8),%l3

! Registers live out of .L77002859: 
! sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77002758 .L77002859

			.L900000444:
/* 0x01dc	 298 */		ld	[%l3+%lo(___const_seg_900000401+8)],%f17
/* 0x01e0	     */		fcmps	%fcc1,%f4,%f17
/* 0x01e4	     */		fbne,pt	%fcc1,.L77002858
/* 0x01e8	     */		add	%l0,-1,%l3

! Registers live out of .L900000444: 
! sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L900000444

			.L77002810:
/* 0x01ec	 300 */		cmp	%l3,11

! Registers live out of .L77002810: 
! sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002810 .L77002901

			.L900000452:
/* 0x01f0	 300 */		bl,pn	%icc,.L77002822
/* 0x01f4	     */		add	%l3,1,%o2

! Registers live out of .L900000452: 
! o2 sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000452

			.L77002823:
/* 0x01f8	 300 */		sub	%i1,%l2,%l4
/* 0x01fc	     */		sub	%l4,%o2,%o1
/* 0x0200	     */		sll	%o1,2,%l6
/* 0x0204	   0 */		sethi	%hi(0x2400),%g1
/* 0x0208	 300 */		add	%i5,%l6,%l7
/* 0x020c	     */		sll	%o1,1,%g2
/* 0x0210	   0 */		xor	%g1,-384,%g1
/* 0x0214	   0 */		add	%g1,%fp,%o7
/* 0x0218	 300 */		add	%i4,%g2,%o0
/* 0x021c	     */		sub	%l5,%l7,%o1
/* 0x0220	     */		sll	%o2,1,%g4
/* 0x0224	     */		sll	%o2,2,%g3
/* 0x0228	     */		sub	%o7,%l5,%o5
/* 0x022c	     */		sra	%o1,31,%l6
/* 0x0230	     */		sub	%l5,%o7,%o4
/* 0x0234	     */		sub	%o0,%l5,%o3
/* 0x0238	     */		sub	%l5,%o0,%o2
/* 0x023c	     */		sub	%o7,%o0,%g2
/* 0x0240	     */		xor	%o1,%l6,%l5
/* 0x0244	     */		sra	%g2,31,%o1
/* 0x0248	     */		sub	%l5,%l6,%l5
/* 0x024c	     */		sub	%o7,%l7,%l6
/* 0x0250	     */		xor	%g2,%o1,%o0
/* 0x0254	     */		sub	%l7,%o7,%g5
/* 0x0258	     */		sub	%o0,%o1,%l7
/* 0x025c	     */		sra	%g3,0,%o1
/* 0x0260	     */		sra	%o5,0,%o7
/* 0x0264	     */		sra	%g4,0,%o0
/* 0x0268	     */		sub	%o7,%o1,%o5
/* 0x026c	     */		srlx	%o5,63,%g4
/* 0x0270	     */		xor	%g4,1,%o5
/* 0x0274	     */		sra	%o4,0,%o4
/* 0x0278	     */		sub	%o4,%o0,%g4
/* 0x027c	     */		srlx	%g4,63,%o4
/* 0x0280	     */		xor	%o4,1,%g3
/* 0x0284	     */		or	%g3,%o5,%o7
/* 0x0288	     */		sra	%o3,0,%o3
/* 0x028c	     */		sra	%o2,0,%o2
/* 0x0290	     */		sub	%o3,%o1,%g3
/* 0x0294	     */		sub	%o2,%o0,%g2
/* 0x0298	     */		srlx	%g3,63,%o3
/* 0x029c	     */		srlx	%g2,63,%o2
/* 0x02a0	     */		xor	%o3,1,%g4
/* 0x02a4	     */		xor	%o2,1,%g2
/* 0x02a8	     */		or	%g2,%g4,%o4
/* 0x02ac	     */		and	%o7,%o4,%o3
/* 0x02b0	     */		sra	%l6,0,%o5
/* 0x02b4	     */		sra	%g5,0,%g5
/* 0x02b8	     */		sub	%g5,%o0,%o7
/* 0x02bc	     */		sub	%o5,%o1,%o4
/* 0x02c0	     */		srlx	%o7,63,%g5
/* 0x02c4	     */		srlx	%o4,63,%l6
/* 0x02c8	     */		xor	%g5,1,%g3
/* 0x02cc	     */		xor	%l6,1,%o5
/* 0x02d0	     */		or	%o5,%g3,%o7
/* 0x02d4	     */		sra	%l5,0,%g4
/* 0x02d8	     */		and	%o3,%o7,%o2
/* 0x02dc	     */		sub	%g4,%o1,%o1
/* 0x02e0	     */		sra	%l7,0,%o3
/* 0x02e4	     */		srlx	%o1,63,%l5
/* 0x02e8	     */		sub	%o3,%o0,%o0
/* 0x02ec	     */		xor	%l5,1,%o1
/* 0x02f0	     */		srlx	%o0,63,%l7
/* 0x02f4	     */		and	%o2,%o1,%g4
/* 0x02f8	     */		xor	%l7,1,%o0
/* 0x02fc	     */		andcc	%g4,%o0,%g0
/* 0x0300	     */		bne,pt	%icc,.L900000450
/* 0x0304	     */		sub	%l4,1,%o1

! Registers live out of .L77002823: 
! o1 sp l0 l1 l2 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002823 .L900000452

			.L77002822:
/* 0x0308	 300 */		sethi	%hi(0x1800),%g1
/* 0x030c	     */		xor	%g1,-256,%g1
/* 0x0310	     */		add	%g1,%fp,%o4
/* 0x0314	     */		sethi	%hi(0x2400),%g1
/* 0x0318	 301 */		add	%l3,1,%l6
/* 0x031c	 300 */		sub	%i1,%l2,%l4
/* 0x0320	     */		xor	%g1,-384,%g1
/* 0x0324	 301 */		cmp	%l6,4
/* 0x0328	 300 */		sub	%l4,1,%g2
/* 0x032c	     */		or	%g0,0,%o1
/* 0x0330	     */		add	%g1,%fp,%o7
/* 0x0334	 301 */		bl,pn	%icc,.L77002845
/* 0x0338	     */		nop

! Registers live out of .L77002822: 
! g2 o1 o4 sp o7 l0 l1 l2 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002822

			.L900000434:
/* 0x033c	 301 */		sll	%g2,1,%g3
/* 0x0340	     */		sll	%g2,2,%g4
/* 0x0344	     */		add	%i4,%g3,%l4
/* 0x0348	     */		add	%i5,%g4,%i1
/* 0x034c	     */		sub	%l3,3,%g5

! Registers live out of .L900000434: 
! g2 g5 o1 o4 sp o7 l0 l1 l2 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000432 .L900000434

			.L900000432:
/* 0x0350	 301 */		prefetch	[%i1-180],0
/* 0x0354	     */		prefetch	[%l4-90],0
/* 0x0358	 300 */		add	%o1,4,%o1
/* 0x035c	 301 */		add	%l4,-8,%l4
/* 0x0360	 302 */		ld	[%i1],%l5
/* 0x0364	 300 */		cmp	%o1,%g5
/* 0x0368	 301 */		add	%i1,-16,%i1
/* 0x036c	 302 */		st	%l5,[%o4]
/* 0x0370	 300 */		sub	%g2,4,%g2
/* 0x0374	     */		add	%o7,8,%o7
/* 0x0378	     */		add	%o4,16,%o4
/* 0x037c	 303 */		lduh	[%l4+8],%o5
/* 0x0380	     */		sth	%o5,[%o7-8]
/* 0x0384	 302 */		ld	[%i1+12],%l7
/* 0x0388	     */		st	%l7,[%o4-12]
/* 0x038c	 303 */		lduh	[%l4+6],%o2
/* 0x0390	     */		sth	%o2,[%o7-6]
/* 0x0394	 302 */		ld	[%i1+8],%o3
/* 0x0398	     */		st	%o3,[%o4-8]
/* 0x039c	 303 */		lduh	[%l4+4],%o0
/* 0x03a0	     */		sth	%o0,[%o7-4]
/* 0x03a4	 302 */		ld	[%i1+4],%g3
/* 0x03a8	     */		st	%g3,[%o4-4]
/* 0x03ac	 303 */		lduh	[%l4+2],%g4
/* 0x03b0	 300 */		ble,pt	%icc,.L900000432
/* 0x03b4	 303 */		sth	%g4,[%o7-2]

! Registers live out of .L900000432: 
! g2 g5 o1 o4 sp o7 l0 l1 l2 l4 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000432

			.L900000435:
/* 0x03b8	 300 */		cmp	%o1,%l3
/* 0x03bc	     */		bg,pn	%icc,.L900000431
/* 0x03c0	 301 */		nop

! Registers live out of .L900000435: 
! g2 o1 o4 sp o7 l0 l1 l2 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002822 .L900000435

			.L77002845:
/* 0x03c4	 300 */		add	%o1,1,%o1

! Registers live out of .L77002845: 
! g2 o1 o4 sp o7 l0 l1 l2 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002845 .L900000449

			.L900000449:
/* 0x03c8	 302 */		sll	%g2,2,%o3
/* 0x03cc	 303 */		sll	%g2,1,%g3
/* 0x03d0	 302 */		ld	[%o3+%i5],%o0
/* 0x03d4	 300 */		cmp	%o1,%l3
/* 0x03d8	 302 */		st	%o0,[%o4]
/* 0x03dc	 300 */		sub	%g2,1,%g2
/* 0x03e0	 303 */		lduh	[%g3+%i4],%g4
/* 0x03e4	 300 */		add	%o4,4,%o4
/* 0x03e8	 303 */		sth	%g4,[%o7]
/* 0x03ec	 300 */		add	%o7,2,%o7
/* 0x03f0	     */		ble,pt	%icc,.L900000449
/* 0x03f4	     */		add	%o1,1,%o1

! Registers live out of .L900000449: 
! g2 o1 o4 sp o7 l0 l1 l2 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000435 .L900000449

			.L900000431:
/* 0x03f8	 301 */		ba	.L900000447
/* 0x03fc	 317 */		cmp	%i3,%l1

! Registers live out of .L900000431: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002823

			.L900000450:
/* 0x0400	 300 */		sethi	%hi(0x1800),%g1
/* 0x0404	     */		xor	%g1,-256,%g1
/* 0x0408	     */		add	%g1,%fp,%l4
/* 0x040c	     */		sethi	%hi(0x2400),%g1
/* 0x0410	 301 */		add	%l3,1,%l6
/* 0x0414	 300 */		xor	%g1,-384,%g1
/* 0x0418	 301 */		cmp	%l6,5
/* 0x041c	 300 */		or	%g0,0,%o0
/* 0x0420	     */		add	%g1,%fp,%g2
/* 0x0424	 301 */		bl,pn	%icc,.L77002844
/* 0x0428	     */		nop

! Registers live out of .L900000450: 
! g2 o0 o1 sp l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000450

			.L900000442:
/* 0x042c	 301 */		sll	%o1,2,%o3
/* 0x0430	     */		add	%i5,%o3,%l5
/* 0x0434	     */		sll	%o1,1,%o2
/* 0x0438	 300 */		or	%g0,1,%o0
/* 0x043c	 301 */		add	%i4,%o2,%g4
/* 0x0440	     */		add	%l5,-4,%g3
/* 0x0444	 302 */		ld	[%i5+%o3],%o3
/* 0x0448	 301 */		sub	%l3,3,%o7

! Registers live out of .L900000442: 
! g2 g3 g4 o0 o1 o3 sp o7 l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000440 .L900000442

			.L900000440:
/* 0x044c	 301 */		prefetch	[%g3-180],0
/* 0x0450	     */		prefetch	[%g4-90],0
/* 0x0454	 300 */		add	%o0,4,%o0
/* 0x0458	 303 */		lduh	[%g4],%l7
/* 0x045c	 301 */		add	%g4,-8,%g4
/* 0x0460	 300 */		cmp	%o0,%o7
/* 0x0464	 302 */		ld	[%g3],%i1
/* 0x0468	 301 */		add	%g3,-16,%g3
/* 0x046c	 302 */		st	%o3,[%l4]
/* 0x0470	 300 */		sub	%o1,4,%o1
/* 0x0474	     */		add	%g2,8,%g2
/* 0x0478	 303 */		sth	%l7,[%g2-8]
/* 0x047c	 300 */		add	%l4,16,%l4
/* 0x0480	 303 */		lduh	[%g4+6],%o4
/* 0x0484	 302 */		ld	[%g3+12],%g5
/* 0x0488	     */		st	%i1,[%l4-12]
/* 0x048c	 303 */		sth	%o4,[%g2-6]
/* 0x0490	     */		lduh	[%g4+4],%o5
/* 0x0494	 302 */		ld	[%g3+8],%o2
/* 0x0498	     */		st	%g5,[%l4-8]
/* 0x049c	 303 */		sth	%o5,[%g2-4]
/* 0x04a0	     */		lduh	[%g4+2],%l5
/* 0x04a4	 302 */		ld	[%g3+4],%o3
/* 0x04a8	     */		st	%o2,[%l4-4]
/* 0x04ac	 300 */		ble,pt	%icc,.L900000440
/* 0x04b0	 303 */		sth	%l5,[%g2-2]

! Registers live out of .L900000440: 
! g2 g3 g4 o0 o1 o3 o4 sp o7 l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000440

			.L900000443:
/* 0x04b4	 300 */		add	%l4,4,%l4
/* 0x04b8	 303 */		lduh	[%g4],%o5
/* 0x04bc	 300 */		add	%g2,2,%g2
/* 0x04c0	     */		cmp	%o0,%l3
/* 0x04c4	 302 */		st	%o3,[%l4-4]
/* 0x04c8	 300 */		sub	%o1,1,%o1
/* 0x04cc	 303 */		sth	%o5,[%g2-2]
/* 0x04d0	 300 */		bg,pn	%icc,.L77002820
/* 0x04d4	 301 */		nop

! Registers live out of .L900000443: 
! g2 o0 o1 o4 sp l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000443 .L900000450

			.L77002844:
/* 0x04d8	 300 */		add	%o0,1,%o0

! Registers live out of .L77002844: 
! g2 o0 o1 sp l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002844 .L900000448

			.L900000448:
/* 0x04dc	 303 */		sll	%o1,1,%g5
/* 0x04e0	 302 */		sll	%o1,2,%o7
/* 0x04e4	 303 */		lduh	[%g5+%i4],%o4
/* 0x04e8	 300 */		cmp	%o0,%l3
/* 0x04ec	 302 */		ld	[%o7+%i5],%o5
/* 0x04f0	 300 */		sub	%o1,1,%o1
/* 0x04f4	 303 */		sth	%o4,[%g2]
/* 0x04f8	 300 */		add	%g2,2,%g2
/* 0x04fc	 302 */		st	%o5,[%l4]
/* 0x0500	 300 */		add	%l4,4,%l4
/* 0x0504	     */		ble,pt	%icc,.L900000448
/* 0x0508	     */		add	%o0,1,%o0

! Registers live out of .L900000448: 
! g2 o0 o1 o4 sp l0 l1 l2 l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000443 .L900000448

			.L77002820:
/* 0x050c	 300 */		ba	.L900000447
/* 0x0510	 317 */		cmp	%i3,%l1

! Registers live out of .L77002820: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000444

			.L77002858:
/* 0x0514	 307 */		sethi	%hi(___const_seg_900000401+12),%l7
/* 0x0518	     */		ld	[%l7+%lo(___const_seg_900000401+12)],%f19
/* 0x051c	 308 */		or	%g0,0,%l6
/* 0x0520	     */		sub	%i1,1,%l5
/* 0x0524	 307 */		fdivs	%f19,%f4,%f0

! Registers live out of .L77002858: 
! sp l0 l1 l2 l5 l6 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L77002858 .L77002903

			.L900000451:
/* 0x0528	 308 */		sethi	%hi(0x1800),%g1
/* 0x052c	     */		xor	%g1,-256,%g1
/* 0x0530	     */		add	%g1,%fp,%g3
/* 0x0534	     */		sethi	%hi(0x2400),%g1

!  309		      !         i = (j+skipcol) * xscale;

/* 0x0538	 309 */		add	%l3,1,%o1
/* 0x053c	 308 */		xor	%g1,-384,%g1
/* 0x0540	 309 */		cmp	%o1,6
/* 0x0544	 308 */		or	%g0,%l2,%l7
/* 0x0548	     */		add	%g1,%fp,%g4
/* 0x054c	 309 */		bl,pn	%icc,.L77002780
/* 0x0550	     */		nop

! Registers live out of .L900000451: 
! g3 g4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000451

			.L900000438:
/* 0x0554	 309 */		st	%l2,[%sp+100]
/* 0x0558	     */		ld	[%sp+100],%f8
/* 0x055c	     */		sethi	%hi(___const_seg_900000401+24),%l4
/* 0x0560	     */		add	%l4,%lo(___const_seg_900000401+24),%g2
/* 0x0564	     */		fitod	%f8,%f38
/* 0x0568	     */		ldd	[%g2],%f32
/* 0x056c	     */		or	%g0,%l2,%o1
/* 0x0570	 308 */		or	%g0,4,%l6
/* 0x0574	 309 */		sub	%l3,1,%o5
/* 0x0578	     */		faddd	%f38,%f32,%f40
/* 0x057c	     */		fdtos	%f38,%f10
/* 0x0580	     */		faddd	%f40,%f32,%f42
/* 0x0584	     */		fdtos	%f40,%f12
/* 0x0588	     */		fmuls	%f10,%f0,%f14
/* 0x058c	     */		fdtos	%f42,%f18
/* 0x0590	     */		fmuls	%f12,%f0,%f20
/* 0x0594	     */		fstoi	%f14,%f16
/* 0x0598	     */		st	%f16,[%sp+96]
/* 0x059c	     */		faddd	%f42,%f32,%f34
/* 0x05a0	     */		ld	[%sp+96],%l7
/* 0x05a4	     */		fmuls	%f18,%f0,%f24
/* 0x05a8	     */		fstoi	%f20,%f22
/* 0x05ac	     */		st	%f22,[%sp+96]
/* 0x05b0	     */		ld	[%sp+96],%g5

!  310		      !         if (i<0)  i = n + i - 1;

/* 0x05b4	 310 */		add	%l7,%l5,%o4
/* 0x05b8	 309 */		sra	%l7,0,%o7
/* 0x05bc	     */		fstoi	%f24,%f26
/* 0x05c0	     */		fdtos	%f34,%f4
/* 0x05c4	     */		st	%f26,[%sp+96]
/* 0x05c8	 310 */		movrlz	%o7,%o4,%l7

! Registers live out of .L900000438: 
! g3 g4 g5 o1 o5 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000436 .L900000438

			.L900000436:
/* 0x05cc	 308 */		add	%l6,2,%l6
/* 0x05d0	     */		add	%g4,4,%g4
/* 0x05d4	 309 */		sra	%g5,0,%o4
/* 0x05d8	 310 */		add	%g5,%l5,%o2
/* 0x05dc	     */		movrgez	%o4,%g5,%o2
/* 0x05e0	 309 */		fmuls	%f4,%f0,%f28

!  311		      !         zindexes[j] = indexes[i];

/* 0x05e4	 311 */		sll	%l7,2,%g5
/* 0x05e8	 308 */		cmp	%l6,%o5
/* 0x05ec	     */		add	%g3,8,%g3
/* 0x05f0	 311 */		ld	[%g5+%i5],%o7
/* 0x05f4	 309 */		faddd	%f34,%f32,%f44
/* 0x05f8	     */		ld	[%sp+96],%g2
/* 0x05fc	 311 */		st	%o7,[%g3-8]

!  312		      !         zdepth[j] = z[i];

/* 0x0600	 312 */		sll	%l7,1,%l7
/* 0x0604	 309 */		fstoi	%f28,%f30
/* 0x0608	 312 */		lduh	[%l7+%i4],%l4
/* 0x060c	 309 */		st	%f30,[%sp+96]
/* 0x0610	 312 */		sth	%l4,[%g4-4]
/* 0x0614	 309 */		fdtos	%f44,%f1
/* 0x0618	     */		sra	%g2,0,%g5
/* 0x061c	 310 */		add	%g2,%l5,%l7
/* 0x0620	     */		movrgez	%g5,%g2,%l7
/* 0x0624	 309 */		fmuls	%f1,%f0,%f3
/* 0x0628	 311 */		sll	%o2,2,%o3
/* 0x062c	     */		ld	[%o3+%i5],%i1
/* 0x0630	 309 */		faddd	%f44,%f32,%f34
/* 0x0634	     */		ld	[%sp+96],%g5
/* 0x0638	 311 */		st	%i1,[%g3-4]
/* 0x063c	 312 */		sll	%o2,1,%o0
/* 0x0640	 309 */		fstoi	%f3,%f5
/* 0x0644	 312 */		lduh	[%o0+%i4],%o7
/* 0x0648	 309 */		st	%f5,[%sp+96]
/* 0x064c	 312 */		sth	%o7,[%g4-2]
/* 0x0650	 308 */		ble,pt	%icc,.L900000436
/* 0x0654	 309 */		fdtos	%f34,%f4

! Registers live out of .L900000436: 
! g3 g4 g5 o1 o5 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000436

			.L900000439:
/* 0x0658	 311 */		sll	%l7,2,%o0
/* 0x065c	     */		ld	[%o0+%i5],%l4
/* 0x0660	 308 */		add	%g3,16,%g3
/* 0x0664	 312 */		sll	%l7,1,%o7
/* 0x0668	 309 */		or	%g0,%l6,%o3
/* 0x066c	 310 */		add	%g5,%l5,%i1
/* 0x0670	 309 */		sra	%g5,0,%o5
/* 0x0674	     */		add	%o3,%o1,%l7
/* 0x0678	 311 */		st	%l4,[%g3-16]
/* 0x067c	 312 */		lduh	[%o7+%i4],%g2
/* 0x0680	 310 */		movrlz	%o5,%i1,%g5
/* 0x0684	 308 */		add	%g4,8,%g4
/* 0x0688	 311 */		sll	%g5,2,%o5
/* 0x068c	 312 */		sth	%g2,[%g4-8]
/* 0x0690	 311 */		ld	[%o5+%i5],%o2
/* 0x0694	 309 */		ld	[%sp+96],%o4
/* 0x0698	 311 */		st	%o2,[%g3-12]
/* 0x069c	 312 */		sll	%g5,1,%g5
/* 0x06a0	 310 */		add	%o4,%l5,%o7
/* 0x06a4	 309 */		sra	%o4,0,%o2
/* 0x06a8	 312 */		lduh	[%g5+%i4],%o0
/* 0x06ac	 310 */		movrlz	%o2,%o7,%o4
/* 0x06b0	 312 */		sth	%o0,[%g4-6]
/* 0x06b4	 309 */		fmuls	%f4,%f0,%f2
/* 0x06b8	 311 */		sll	%o4,2,%g2
/* 0x06bc	     */		ld	[%g2+%i5],%o3
/* 0x06c0	     */		st	%o3,[%g3-8]
/* 0x06c4	 312 */		sll	%o4,1,%o4
/* 0x06c8	     */		lduh	[%o4+%i4],%i1
/* 0x06cc	 309 */		fstoi	%f2,%f6
/* 0x06d0	     */		st	%f6,[%sp+96]
/* 0x06d4	     */		ld	[%sp+96],%o2
/* 0x06d8	 312 */		sth	%i1,[%g4-4]
/* 0x06dc	 308 */		cmp	%l6,%l3
/* 0x06e0	 310 */		add	%o2,%l5,%o1
/* 0x06e4	 309 */		sra	%o2,0,%o3
/* 0x06e8	 310 */		movrlz	%o3,%o1,%o2
/* 0x06ec	 311 */		sll	%o2,2,%g5
/* 0x06f0	     */		ld	[%g5+%i5],%o0
/* 0x06f4	     */		st	%o0,[%g3-4]
/* 0x06f8	 312 */		sll	%o2,1,%o2
/* 0x06fc	     */		lduh	[%o2+%i4],%o7
/* 0x0700	     */		sth	%o7,[%g4-2]
/* 0x0704	 308 */		bg,pn	%icc,.L77002846
/* 0x0708	 309 */		nop

! Registers live out of .L900000439: 
! g3 g4 o4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000439 .L900000451

			.L77002780:
/* 0x070c	 309 */		st	%l7,[%sp+100]

! Registers live out of .L77002780: 
! g3 g4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L77002780 .L900000446

			.L900000446:
/* 0x0710	 309 */		ld	[%sp+100],%f21
/* 0x0714	 308 */		add	%l6,1,%l6
/* 0x0718	     */		cmp	%l6,%l3
/* 0x071c	 309 */		fitos	%f21,%f23
/* 0x0720	 308 */		add	%l7,1,%l7
/* 0x0724	 309 */		fmuls	%f23,%f0,%f25
/* 0x0728	     */		fstoi	%f25,%f27
/* 0x072c	     */		st	%f27,[%sp+96]
/* 0x0730	     */		ld	[%sp+96],%g5
/* 0x0734	 310 */		add	%g5,%l5,%i1
/* 0x0738	   0 */		sra	%g5,0,%o0
/* 0x073c	 310 */		movrlz	%o0,%i1,%g5
/* 0x0740	 311 */		sll	%g5,2,%o4
/* 0x0744	     */		ld	[%o4+%i5],%o3
/* 0x0748	     */		st	%o3,[%g3]
/* 0x074c	 312 */		sll	%g5,1,%o5
/* 0x0750	     */		lduh	[%o5+%i4],%o7
/* 0x0754	     */		sth	%o7,[%g4]
/* 0x0758	 308 */		add	%g3,4,%g3
/* 0x075c	     */		add	%g4,2,%g4
/* 0x0760	     */		ble,a,pt	%icc,.L900000446
/* 0x0764	 309 */		st	%l7,[%sp+100]

! Registers live out of .L900000446: 
! g3 g4 o4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! f0 
		
!  313		      !      }
!  314		      !   }
!  316		      !   /* write the span */
!  317		      !   for (r=r0; r<r1; r++) {

                       
! predecessor blocks: .L77002816 .L77002848 .L900000439 .L900000446

			.L77002846:
/* 0x0768	 317 */		cmp	%i3,%l1

! Registers live out of .L77002846: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002820 .L77002846 .L900000431

			.L900000447:
/* 0x076c	 317 */		bge,pn	%icc,.L77002799
/* 0x0770	     */		add	%i2,%l2,%i4

! Registers live out of .L900000447: 
! o4 sp l0 l1 i0 i3 i4 fp i7 gsr 
! 
		
!  318		      !      gl_write_index_span( ctx, m, x+skipcol, r, zdepth, zindexes, GL_BITMAP );

                       
! predecessor blocks: .L900000447

			.L77002862:
/* 0x0774	 318 */		sethi	%hi(0x1800),%i2
/* 0x0778	 317 */		add	%l1,-1,%i5
/* 0x077c	 318 */		add	%i2,512,%i1

! Registers live out of .L77002862: 
! o4 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002862 .L900000445

			.L900000445:
/* 0x0780	 318 */		sethi	%hi(0x1800),%g1
/* 0x0784	     */		xor	%g1,-256,%g1
/* 0x0788	     */		add	%g1,%fp,%o5
/* 0x078c	     */		sethi	%hi(0x2400),%g1
/* 0x0790	     */		xor	%g1,-384,%g1
/* 0x0794	     */		or	%g0,%i3,%o3
/* 0x0798	     */		add	%g1,%fp,%g1
/* 0x079c	     */		or	%g0,%i4,%o2
/* 0x07a0	     */		or	%g0,%l0,%o1
/* 0x07a4	     */		or	%g0,%i0,%o0
/* 0x07a8	 317 */		add	%i3,1,%i3
/* 0x07ac	 318 */		st	%i1,[%sp+92]
/* 0x07b0	     */		call	gl_write_index_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92	! Result = 
/* 0x07b4	     */		or	%g0,%g1,%o4
/* 0x07b8	 317 */		cmp	%i3,%i5
/* 0x07bc	     */		ble,pt	%icc,.L900000445
/* 0x07c0	 318 */		add	%i2,512,%i1

! Registers live out of .L900000445: 
! o4 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002718 .L77002750 gl_write_zoomed_index_span .L900000445 .L900000447 .L900000454 .L900000456

			.L77002799:
/* 0x07c4	 251 */		ret	! Result = 
/* 0x07c8	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77002748 .L77002860

			.L77002758:
/* 0x07cc	 295 */		sethi	%hi(.L138),%g3
/* 0x07d0	     */		sethi	%hi(.L137),%l6
/* 0x07d4	     */		add	%g3,%lo(.L138),%o1
/* 0x07d8	     */		add	%l6,%lo(.L137),%o0
/* 0x07dc	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x07e0	     */		or	%g0,295,%o2
/* 0x07e4	     */		ld	[%i0+%l3],%f4
/* 0x07e8	     */		ba	.L900000444
/* 0x07ec	 298 */		sethi	%hi(___const_seg_900000401+8),%l3

! Registers live out of .L77002758: 
! sp l0 l1 l2 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! f4 
		/* 0x07f0	   0 */		.type	gl_write_zoomed_index_span,2
/* 0x07f0	   0 */		.size	gl_write_zoomed_index_span,(.-gl_write_zoomed_index_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000501:
/* 000000	   0 */		.word	1127219200,0
/* 0x0008	     */		.word	-1082130432
/* 0x000c	     */		.word	1065353216
/* 0x0010	     */		.word	1127219200
/* 0x0014	   0 */		.align	8
/* 0x0018	   0 */		.word	1072693248,0
/* 0x0020	   0 */		.type	___const_seg_900000501,1
/* 0x0020	   0 */		.size	___const_seg_900000501,(.-___const_seg_900000501)
/* 0x0020	   0 */		.align	4

!  319		      !   }
!  320		      !}
!  324		      !/*
!  325		      ! * As above, but write stencil values.
!  326		      ! */
!  327		      !void
!  328		      !gl_write_zoomed_stencil_span( GLcontext *ctx,
!  329		      !                              GLuint n, GLint x, GLint y,
!  330		      !                              const GLubyte stencil[], GLint y0 )
!  331		      !{

!
! SUBROUTINE gl_write_zoomed_stencil_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_write_zoomed_stencil_span
                       

			gl_write_zoomed_stencil_span:
/* 000000	 331 */		save	%sp,-1720,%sp

!  332		      !   GLint m;
!  333		      !   GLint r0, r1, row, r;
!  334		      !   GLint i, j, skipcol;
!  335		      !   GLubyte zstencil[MAX_WIDTH];  /* zoomed stencil values */
!  336		      !   GLint maxwidth = MIN2( ctx->Buffer->Width, MAX_WIDTH );
!  338		      !   /* compute width of output row */
!  339		      !   m = (GLint) ABSF( n * ctx->Pixel.ZoomX );

/* 0x0004	 339 */		st	%i1,[%sp+108]
/* 0x0008	     */		sethi	%hi(___const_seg_900000501+16),%l1
/* 0x000c	     */		sethi	%hi(___const_seg_900000501),%l0
/* 0x0010	     */		ld	[%l1+%lo(___const_seg_900000501+16)],%f0
/* 0x0014	     */		ldd	[%l0+%lo(___const_seg_900000501)],%f44
/* 0x0018	     */		ld	[%sp+108],%f1
/* 0x001c	     */		sethi	%hi(0xac00),%g4
/* 0x0020	     */		add	%g4,592,%l3
/* 0x0024	     */		fsubd	%f0,%f44,%f46
/* 0x0028	     */		ld	[%i0+%l3],%f18
/* 0x002c	     */		fdtos	%f46,%f7
/* 0x0030	     */		fmuls	%f7,%f18,%f9
/* 0x0034	     */		fabss	%f9,%f11
/* 0x0038	     */		fstoi	%f11,%f13
/* 0x003c	     */		st	%f13,[%sp+104]
/* 0x0040	     */		ld	[%sp+104],%l0

!  340		      !   if (m==0) {

/* 0x0044	 340 */		cmp	%l0,0
/* 0x0048	     */		be,pn	%icc,.L77003027
/* 0x004c	 349 */		sub	%i3,%i5,%l1

! Registers live out of gl_write_zoomed_stencil_span: 
! g4 sp l0 l1 i0 i1 i2 i4 i5 fp i7 gsr 
! f18 
		
!  341		      !      return;
!  342		      !   }
!  343		      !   if (ctx->Pixel.ZoomX<0.0) {
!  344		      !      /* adjust x coordinate for left/right mirroring */
!  345		      !      x = x - m;
!  346		      !   }
!  348		      !   /* compute which rows to draw */
!  349		      !   row = y-y0;
!  350		      !   r0 = y0 + (GLint) (row * ctx->Pixel.ZoomY);
!  351		      !   r1 = y0 + (GLint) ((row+1) * ctx->Pixel.ZoomY);

                       
! predecessor blocks: gl_write_zoomed_stencil_span

			.L77002946:
/* 0x0050	 351 */		add	%l1,1,%o4
/* 0x0054	 350 */		st	%l1,[%sp+116]
/* 0x0058	 351 */		st	%o4,[%sp+108]
/* 0x005c	     */		ld	[%sp+108],%f31
/* 0x0060	 350 */		ld	[%sp+116],%f4
/* 0x0064	     */		add	%g4,596,%g3
/* 0x0068	 351 */		fitos	%f31,%f2
/* 0x006c	 350 */		fitos	%f4,%f6
/* 0x0070	     */		ld	[%i0+%g3],%f8
/* 0x0074	 343 */		fstod	%f18,%f50
/* 0x0078	     */		fzero	%f48
/* 0x007c	 350 */		fmuls	%f6,%f8,%f10
/* 0x0080	 351 */		fmuls	%f2,%f8,%f12
/* 0x0084	 343 */		fcmped	%fcc2,%f50,%f48
/* 0x0088	 345 */		sub	%i2,%l0,%g5
/* 0x008c	 350 */		fstoi	%f10,%f14
/* 0x0090	 351 */		fstoi	%f12,%f16
/* 0x0094	 350 */		st	%f14,[%sp+112]
/* 0x0098	 351 */		st	%f16,[%sp+104]
/* 0x009c	 345 */		movl	%fcc2,%g5,%i2
/* 0x00a0	 351 */		ld	[%sp+104],%o2
/* 0x00a4	 350 */		ld	[%sp+112],%o0
/* 0x00a8	 351 */		add	%i5,%o2,%l1
/* 0x00ac	 350 */		add	%i5,%o0,%i3

!  352		      !   if (r0==r1) {

/* 0x00b0	 352 */		cmp	%i3,%l1
/* 0x00b4	     */		be,pn	%icc,.L77003027
/* 0x00b8	 355 */		cmp	%l1,%i3

! Registers live out of .L77002946: 
! o2 o4 sp l0 l1 i0 i1 i2 i3 i4 fp i7 gsr 
! f18 
		
!  353		      !      return;
!  354		      !   }
!  355		      !   else if (r1<r0) {
!  356		      !      GLint rtmp = r1;

                       
! predecessor blocks: .L77002946

			.L77002954:
/* 0x00bc	 356 */		or	%g0,%l1,%o7

!  357		      !      r1 = r0;

/* 0x00c0	 357 */		movl	%icc,%i3,%l1

!  358		      !      r0 = rtmp;

/* 0x00c4	 358 */		movl	%icc,%o7,%i3

!  359		      !   }
!  361		      !   /* return early if r0...r1 is above or below window */
!  362		      !   if (r0<0 && r1<0) {

/* 0x00c8	 362 */		cmp	%i3,0
/* 0x00cc	     */		bl,pn	%icc,.L77002960
/* 0x00d0	 331 */		or	%g0,%i4,%i5

! Registers live out of .L77002954: 
! o2 o4 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77002954

			.L77003105:
/* 0x00d4	 336 */		ld	[%i0+2204],%o5
/* 0x00d8	     */		ba	.L900000541
/* 0x00dc	 366 */		ld	[%o5+8],%l4

! Registers live out of .L77003105: 
! o2 o4 o5 sp l0 l1 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77002954

			.L77002960:
/* 0x00e0	 362 */		cmp	%l1,0
/* 0x00e4	     */		bl,pn	%icc,.L77003027
/* 0x00e8	     */		nop

! Registers live out of .L77002960: 
! o2 o4 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77002960

			.L77003109:
/* 0x00ec	 336 */		ld	[%i0+2204],%o5

!  363		      !      /* below window */
!  364		      !      return;
!  365		      !   }
!  366		      !   if (r0>=ctx->Buffer->Height && r1>=ctx->Buffer->Height) {

/* 0x00f0	 366 */		ld	[%o5+8],%l4

! Registers live out of .L77003109: 
! o2 o4 o5 sp l0 l1 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77003105 .L77003109

			.L900000541:
/* 0x00f4	 366 */		cmp	%i3,%l4
/* 0x00f8	     */		bge,pn	%icc,.L900000540
/* 0x00fc	     */		cmp	%l1,%l4

! Registers live out of .L900000541: 
! o2 o4 o5 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L900000541

			.L77003111:
/* 0x0100	 336 */		ld	[%o5+4],%g4
/* 0x0104	     */		sra	%g4,0,%g3
/* 0x0108	     */		sub	%g3,1600,%g5
/* 0x010c	     */		srax	%g5,32,%i4
/* 0x0110	     */		and	%i4,%g5,%l5
/* 0x0114	     */		add	%l5,1600,%o3
/* 0x0118	     */		ba	.L900000539
/* 0x011c	 373 */		cmp	%i2,0

! Registers live out of .L77003111: 
! o2 o3 o4 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L900000541

			.L900000540:
/* 0x0120	 366 */		bge,pn	%icc,.L77003027
/* 0x0124	     */		nop

! Registers live out of .L900000540: 
! o2 o5 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L900000540

			.L77003115:
/* 0x0128	 336 */		ld	[%o5+4],%l2

!  367		      !      /* above window */
!  368		      !      return;
!  369		      !   }
!  371		      !   /* check if left edge is outside window */
!  372		      !   skipcol = 0;
!  373		      !   if (x<0) {

/* 0x012c	 373 */		cmp	%i2,0
/* 0x0130	 336 */		sra	%l2,0,%o1
/* 0x0134	     */		sub	%o1,1600,%o7
/* 0x0138	     */		srax	%o7,32,%l7
/* 0x013c	     */		and	%l7,%o7,%o4
/* 0x0140	     */		add	%o4,1600,%o3

! Registers live out of .L77003115: 
! o2 o3 o4 sp l0 l1 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		
!  374		      !      skipcol = -x;
!  375		      !      m += x;

                       
! predecessor blocks: .L77003111 .L77003115

			.L900000539:
/* 0x0144	 375 */		add	%l0,%i2,%l2
/* 0x0148	     */		movl	%icc,%l2,%l0
/* 0x014c	 374 */		sub	%g0,%i2,%l2
/* 0x0150	 372 */		movge	%icc,%g0,%l2

!  376		      !   }
!  377		      !   /* make sure span isn't too long or short */
!  378		      !   if (m>maxwidth) {

/* 0x0154	 378 */		cmp	%l0,%o3
/* 0x0158	   0 */		sethi	%hi(___const_seg_900000501+12),%l6
/* 0x015c	   0 */		add	%fp,-1600,%l4
/* 0x0160	 378 */		ble,pn	%icc,.L77002978
/* 0x0164	   0 */		add	%l6,%lo(___const_seg_900000501+12),%l7

! Registers live out of .L900000539: 
! o2 o3 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		
!  379		      !      m = maxwidth;
!  380		      !   }
!  381		      !   else if (m<=0) {
!  382		      !      return;
!  383		      !   }
!  385		      !   assert( m <= MAX_WIDTH );

                       
! predecessor blocks: .L900000539

			.L77002976:
/* 0x0168	 385 */		cmp	%o3,1600
/* 0x016c	     */		bg,pn	%icc,.L77002986
/* 0x0170	 379 */		or	%g0,%o3,%l0

! Registers live out of .L77002976: 
! o2 o3 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		
!  387		      !   /* zoom the span horizontally */
!  388		      !   if (ctx->Pixel.ZoomX==-1.0F) {

                       
! predecessor blocks: .L77002976

			.L77002992:
/* 0x0174	 388 */		ld	[%l7-4],%f29
/* 0x0178	     */		fcmps	%fcc3,%f18,%f29
/* 0x017c	     */		fbne,pn	%fcc3,.L77003076
/* 0x0180	 390 */		cmp	%o3,0

! Registers live out of .L77002992: 
! o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		
!  389		      !      /* n==m */
!  390		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002992

			.L77003044:
/* 0x0184	 390 */		ble,pn	%icc,.L77003074
/* 0x0188	     */		add	%o3,-1,%o1

! Registers live out of .L77003044: 
! o1 o4 sp l0 l1 l2 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003044

			.L77003129:
/* 0x018c	 390 */		ba	.L900000538
/* 0x0190	     */		cmp	%o1,3

! Registers live out of .L77003129: 
! o1 sp l0 l1 l2 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		
!  391		      !         i = n - (j+skipcol) - 1;
!  392		      !         zstencil[j] = stencil[i];
!  393		      !      }
!  394		      !   }
!  395		      !   else {
!  396		      !      GLfloat xscale = 1.0F / ctx->Pixel.ZoomX;
!  397		      !      for (j=0;j<m;j++) {

                       
! predecessor blocks: .L77002992

			.L77003076:
/* 0x0194	 397 */		ble,pn	%icc,.L77003074
/* 0x0198	 396 */		ld	[%l6+%lo(___const_seg_900000501+12)],%f15

! Registers live out of .L77003076: 
! o3 o4 sp l0 l1 l2 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! f15 f18 
		                       
! predecessor blocks: .L77003076

			.L77003131:
/* 0x019c	 396 */		add	%o3,-1,%o1
/* 0x01a0	 397 */		or	%g0,0,%l6
/* 0x01a4	 396 */		fdivs	%f15,%f18,%f0
/* 0x01a8	     */		ba	.L900000537
/* 0x01ac	 397 */		sub	%i1,1,%o3

! Registers live out of .L77003131: 
! o1 o3 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000539

			.L77002978:
/* 0x01b0	 381 */		cmp	%l0,0
/* 0x01b4	     */		ble,pn	%icc,.L77003027
/* 0x01b8	 385 */		cmp	%l0,1600

! Registers live out of .L77002978: 
! o2 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77002978

			.L77003088:
/* 0x01bc	 385 */		bg,pn	%icc,.L77002986
/* 0x01c0	 388 */		ld	[%l7-4],%f17

! Registers live out of .L77003088: 
! o2 o4 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr 
! f17 f18 
		                       
! predecessor blocks: .L77002986 .L77003088

			.L900000530:
/* 0x01c4	 388 */		fcmps	%fcc0,%f18,%f17
/* 0x01c8	     */		fbne,pt	%fcc0,.L77003086
/* 0x01cc	     */		add	%l0,-1,%o1

! Registers live out of .L900000530: 
! o1 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L900000530

			.L77003038:
/* 0x01d0	 390 */		cmp	%o1,3

! Registers live out of .L77003038: 
! o1 sp l0 l1 l2 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003038 .L77003129

			.L900000538:
/* 0x01d4	 390 */		bl,pn	%icc,.L77003050
/* 0x01d8	     */		add	%o1,1,%g3

! Registers live out of .L900000538: 
! g3 o1 sp l0 l1 l2 l4 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000538

			.L77003051:
/* 0x01dc	 390 */		sub	%g0,%l2,%o0
/* 0x01e0	     */		sub	%o0,%g3,%o5
/* 0x01e4	     */		add	%i5,%i1,%g2
/* 0x01e8	     */		add	%o5,%g2,%l3
/* 0x01ec	     */		sub	%l4,%l3,%l7
/* 0x01f0	     */		sra	%l7,31,%o4
/* 0x01f4	     */		xor	%l7,%o4,%o7
/* 0x01f8	     */		sub	%o7,%o4,%g4
/* 0x01fc	     */		cmp	%g4,%g3
/* 0x0200	     */		bge,pt	%icc,.L900000536
/* 0x0204	     */		sub	%i1,%l2,%o3

! Registers live out of .L77003051: 
! g3 o1 o3 o4 sp l0 l1 l2 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003051 .L900000538

			.L77003050:
/* 0x0208	 392 */		add	%o1,1,%l6
/* 0x020c	 390 */		sub	%i1,%l2,%i4
/* 0x0210	 392 */		cmp	%l6,4
/* 0x0214	 390 */		sub	%i4,1,%g5
/* 0x0218	     */		or	%g0,0,%o4
/* 0x021c	     */		add	%fp,-1600,%l3
/* 0x0220	 392 */		bl,pn	%icc,.L77003073
/* 0x0224	     */		nop

! Registers live out of .L77003050: 
! g5 o1 o4 sp l0 l1 l2 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003050

			.L900000520:
/* 0x0228	 392 */		add	%i5,%g5,%i4
/* 0x022c	     */		sub	%o1,3,%l7

! Registers live out of .L900000520: 
! o1 o4 sp l0 l1 l2 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000518 .L900000520

			.L900000518:
/* 0x0230	 392 */		prefetch	[%i4-258],0
/* 0x0234	 390 */		add	%o4,4,%o4
/* 0x0238	 392 */		ldub	[%i4],%o0
/* 0x023c	     */		add	%i4,-4,%i4
/* 0x0240	 390 */		cmp	%o4,%l7
/* 0x0244	     */		add	%l3,4,%l3
/* 0x0248	 392 */		stb	%o0,[%l3-4]
/* 0x024c	     */		ldub	[%i4+3],%g2
/* 0x0250	     */		stb	%g2,[%l3-3]
/* 0x0254	     */		ldub	[%i4+2],%o5
/* 0x0258	     */		stb	%o5,[%l3-2]
/* 0x025c	     */		ldub	[%i4+1],%l4
/* 0x0260	 390 */		ble,pt	%icc,.L900000518
/* 0x0264	 392 */		stb	%l4,[%l3-1]

! Registers live out of .L900000518: 
! o1 o4 sp l0 l1 l2 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000518

			.L900000521:
/* 0x0268	 392 */		or	%g0,%i4,%o3
/* 0x026c	 390 */		cmp	%o4,%o1
/* 0x0270	 392 */		sub	%o3,%i5,%g5
/* 0x0274	 390 */		bg,pn	%icc,.L900000517
/* 0x0278	 392 */		nop

! Registers live out of .L900000521: 
! g5 o1 o4 sp l0 l1 l2 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003050 .L900000521

			.L77003073:
/* 0x027c	 390 */		add	%o4,1,%o4

! Registers live out of .L77003073: 
! g5 o1 o4 sp l0 l1 l2 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003073 .L900000535

			.L900000535:
/* 0x0280	 390 */		cmp	%o4,%o1
/* 0x0284	 392 */		ldub	[%g5+%i5],%i1
/* 0x0288	 390 */		sub	%g5,1,%g5
/* 0x028c	 392 */		stb	%i1,[%l3]
/* 0x0290	 390 */		add	%l3,1,%l3
/* 0x0294	     */		ble,pt	%icc,.L900000535
/* 0x0298	     */		add	%o4,1,%o4

! Registers live out of .L900000535: 
! g5 o1 o4 sp l0 l1 l2 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000521 .L900000535

			.L900000517:
/* 0x029c	 392 */		ba	.L900000533
/* 0x02a0	 405 */		cmp	%i3,%l1

! Registers live out of .L900000517: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003051

			.L900000536:
/* 0x02a4	 392 */		cmp	%g3,5
/* 0x02a8	 390 */		sub	%o3,1,%l6
/* 0x02ac	     */		or	%g0,0,%l3
/* 0x02b0	     */		add	%fp,-1600,%l4
/* 0x02b4	 392 */		bl,pn	%icc,.L77003072
/* 0x02b8	     */		nop

! Registers live out of .L900000536: 
! o1 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000536

			.L900000528:
/* 0x02bc	 392 */		add	%i5,%l6,%o0
/* 0x02c0	 390 */		or	%g0,1,%l3
/* 0x02c4	 392 */		add	%o0,-1,%l5
/* 0x02c8	     */		ldub	[%o0],%o3
/* 0x02cc	     */		sub	%o1,3,%i1

! Registers live out of .L900000528: 
! o1 o3 o4 sp l0 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000526 .L900000528

			.L900000526:
/* 0x02d0	 392 */		prefetch	[%l5-258],0
/* 0x02d4	 390 */		add	%l3,4,%l3
/* 0x02d8	 392 */		ldub	[%l5],%g5
/* 0x02dc	     */		add	%l5,-4,%l5
/* 0x02e0	     */		stb	%o3,[%l4]
/* 0x02e4	 390 */		cmp	%l3,%i1
/* 0x02e8	     */		add	%l4,4,%l4
/* 0x02ec	 392 */		ldub	[%l5+3],%g2
/* 0x02f0	     */		stb	%g5,[%l4-3]
/* 0x02f4	     */		ldub	[%l5+2],%o5
/* 0x02f8	     */		stb	%g2,[%l4-2]
/* 0x02fc	     */		ldub	[%l5+1],%o3
/* 0x0300	 390 */		ble,pt	%icc,.L900000526
/* 0x0304	 392 */		stb	%o5,[%l4-1]

! Registers live out of .L900000526: 
! o1 o3 o4 sp l0 l1 l2 l4 l5 i0 i1 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000526

			.L900000529:
/* 0x0308	 390 */		cmp	%l3,%o1
/* 0x030c	 392 */		sub	%l5,%i5,%l6
/* 0x0310	     */		stb	%o3,[%l4]
/* 0x0314	 390 */		add	%l4,1,%l4
/* 0x0318	     */		bg,pn	%icc,.L77003048
/* 0x031c	 392 */		nop

! Registers live out of .L900000529: 
! o1 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000529 .L900000536

			.L77003072:
/* 0x0320	 390 */		add	%l3,1,%l3

! Registers live out of .L77003072: 
! o1 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003072 .L900000534

			.L900000534:
/* 0x0324	 390 */		cmp	%l3,%o1
/* 0x0328	 392 */		ldub	[%l6+%i5],%o2
/* 0x032c	 390 */		sub	%l6,1,%l6
/* 0x0330	 392 */		stb	%o2,[%l4]
/* 0x0334	 390 */		add	%l4,1,%l4
/* 0x0338	     */		ble,pt	%icc,.L900000534
/* 0x033c	     */		add	%l3,1,%l3

! Registers live out of .L900000534: 
! o1 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000529 .L900000534

			.L77003048:
/* 0x0340	 390 */		ba	.L900000533
/* 0x0344	 405 */		cmp	%i3,%l1

! Registers live out of .L77003048: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000530

			.L77003086:
/* 0x0348	 396 */		ld	[%l6+%lo(___const_seg_900000501+12)],%f19
/* 0x034c	 397 */		or	%g0,0,%l6
/* 0x0350	     */		sub	%i1,1,%o3
/* 0x0354	 396 */		fdivs	%f19,%f18,%f0

! Registers live out of .L77003086: 
! o1 o3 o4 sp l0 l1 l2 l4 l6 i0 i2 i3 i5 fp i7 gsr 
! f0 
		
!  398		      !         i = (j+skipcol) * xscale;

                       
! predecessor blocks: .L77003086 .L77003131

			.L900000537:
/* 0x0358	 398 */		add	%o1,1,%o7
/* 0x035c	     */		cmp	%o7,6
/* 0x0360	 397 */		or	%g0,%l2,%l5
/* 0x0364	     */		add	%fp,-1600,%l7
/* 0x0368	 398 */		bl,pn	%icc,.L77003008
/* 0x036c	     */		nop

! Registers live out of .L900000537: 
! o1 o3 o4 sp l0 l1 l2 l4 l5 l6 l7 i0 i2 i3 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000537

			.L900000524:
/* 0x0370	 398 */		st	%l2,[%sp+100]
/* 0x0374	     */		ld	[%sp+100],%f8
/* 0x0378	     */		sethi	%hi(___const_seg_900000501+24),%g2
/* 0x037c	     */		ldd	[%g2+%lo(___const_seg_900000501+24)],%f34
/* 0x0380	     */		fitod	%f8,%f32
/* 0x0384	     */		sub	%l2,%l4,%o0
/* 0x0388	 397 */		or	%g0,4,%l6
/* 0x038c	 398 */		sub	%o1,1,%o7
/* 0x0390	     */		faddd	%f32,%f34,%f36
/* 0x0394	     */		fdtos	%f32,%f10
/* 0x0398	     */		faddd	%f36,%f34,%f38
/* 0x039c	     */		fdtos	%f36,%f16
/* 0x03a0	     */		fmuls	%f10,%f0,%f12
/* 0x03a4	     */		fdtos	%f38,%f18
/* 0x03a8	     */		faddd	%f38,%f34,%f40
/* 0x03ac	     */		fstoi	%f12,%f14
/* 0x03b0	     */		st	%f14,[%sp+96]
/* 0x03b4	     */		fmuls	%f16,%f0,%f20
/* 0x03b8	     */		ld	[%sp+96],%i1
/* 0x03bc	     */		fmuls	%f18,%f0,%f24
/* 0x03c0	     */		fdtos	%f40,%f4

!  399		      !         if (i<0)  i = n + i - 1;

/* 0x03c4	 399 */		add	%i1,%o3,%l4
/* 0x03c8	 398 */		sra	%i1,0,%g5
/* 0x03cc	     */		fstoi	%f20,%f22
/* 0x03d0	     */		st	%f22,[%sp+92]
/* 0x03d4	     */		fstoi	%f24,%f26
/* 0x03d8	     */		faddd	%f40,%f34,%f32
/* 0x03dc	     */		st	%f26,[%sp+96]
/* 0x03e0	 399 */		movrlz	%g5,%l4,%i1

! Registers live out of .L900000524: 
! o0 o1 o3 sp o7 l0 l1 l2 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000522 .L900000524

			.L900000522:
/* 0x03e4	 397 */		add	%l6,2,%l6
/* 0x03e8	     */		add	%l7,2,%l7
/* 0x03ec	 398 */		ld	[%sp+92],%g3
/* 0x03f0	     */		fmuls	%f4,%f0,%f28
/* 0x03f4	 397 */		cmp	%l6,%o7

!  400		      !         zstencil[j] = stencil[i];

/* 0x03f8	 400 */		ldub	[%i1+%i5],%l3
/* 0x03fc	 398 */		fdtos	%f32,%f1
/* 0x0400	     */		fstoi	%f28,%f30
/* 0x0404	     */		st	%f30,[%sp+92]
/* 0x0408	     */		sra	%g3,0,%g2
/* 0x040c	 399 */		add	%g3,%o3,%o4
/* 0x0410	     */		movrlz	%g2,%o4,%g3
/* 0x0414	 400 */		stb	%l3,[%l7-2]
/* 0x0418	 398 */		faddd	%f32,%f34,%f42
/* 0x041c	     */		fmuls	%f1,%f0,%f3
/* 0x0420	     */		ld	[%sp+96],%l5
/* 0x0424	 400 */		ldub	[%g3+%i5],%o2
/* 0x0428	 398 */		fdtos	%f42,%f4
/* 0x042c	     */		fstoi	%f3,%f5
/* 0x0430	     */		st	%f5,[%sp+96]
/* 0x0434	     */		sra	%l5,0,%o5
/* 0x0438	 399 */		add	%l5,%o3,%i4
/* 0x043c	     */		or	%g0,%l5,%i1
/* 0x0440	     */		movrlz	%o5,%i4,%i1
/* 0x0444	 400 */		stb	%o2,[%l7-1]
/* 0x0448	 397 */		ble,pt	%icc,.L900000522
/* 0x044c	 398 */		faddd	%f42,%f34,%f32

! Registers live out of .L900000522: 
! o0 o1 o3 sp o7 l0 l1 l2 l6 l7 i0 i1 i2 i3 i5 fp i7 gsr y
! f0 f2 f4 
		                       
! predecessor blocks: .L900000522

			.L900000525:
/* 0x0450	 398 */		ld	[%sp+92],%o5
/* 0x0454	 400 */		ldub	[%i1+%i5],%l4
/* 0x0458	 397 */		add	%l7,4,%l7
/* 0x045c	 398 */		sra	%o5,0,%o2
/* 0x0460	 399 */		add	%o5,%o3,%i1
/* 0x0464	     */		movrlz	%o2,%i1,%o5
/* 0x0468	 400 */		stb	%l4,[%l7-4]
/* 0x046c	     */		ldub	[%o5+%i5],%o4
/* 0x0470	 398 */		ld	[%sp+96],%i4
/* 0x0474	     */		or	%g0,%l7,%g3
/* 0x0478	     */		fmuls	%f4,%f0,%f2
/* 0x047c	 400 */		stb	%o4,[%l7-3]
/* 0x0480	 398 */		add	%g3,%o0,%l5
/* 0x0484	 399 */		add	%i4,%o3,%g4
/* 0x0488	 398 */		sra	%i4,0,%g3
/* 0x048c	 399 */		movrlz	%g3,%g4,%i4
/* 0x0490	 398 */		fstoi	%f2,%f6
/* 0x0494	     */		st	%f6,[%sp+92]
/* 0x0498	     */		ld	[%sp+92],%o4
/* 0x049c	 400 */		ldub	[%i4+%i5],%i4
/* 0x04a0	 397 */		cmp	%l6,%o1
/* 0x04a4	 399 */		add	%o4,%o3,%o0
/* 0x04a8	 398 */		sra	%o4,0,%g4
/* 0x04ac	 400 */		stb	%i4,[%l7-2]
/* 0x04b0	 399 */		movrlz	%g4,%o0,%o4
/* 0x04b4	 400 */		ldub	[%o4+%i5],%g5
/* 0x04b8	     */		stb	%g5,[%l7-1]
/* 0x04bc	 397 */		bg,pn	%icc,.L77003074
/* 0x04c0	 398 */		nop

! Registers live out of .L900000525: 
! o1 o3 o4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L900000525 .L900000537

			.L77003008:
/* 0x04c4	 398 */		st	%l5,[%sp+100]

! Registers live out of .L77003008: 
! o1 o3 o4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i5 fp i7 gsr 
! f0 
		                       
! predecessor blocks: .L77003008 .L900000532

			.L900000532:
/* 0x04c8	 398 */		ld	[%sp+100],%f21
/* 0x04cc	 397 */		add	%l6,1,%l6
/* 0x04d0	     */		cmp	%l6,%o1
/* 0x04d4	 398 */		fitos	%f21,%f23
/* 0x04d8	 397 */		add	%l5,1,%l5
/* 0x04dc	 398 */		fmuls	%f23,%f0,%f25
/* 0x04e0	     */		fstoi	%f25,%f27
/* 0x04e4	     */		st	%f27,[%sp+104]
/* 0x04e8	     */		ld	[%sp+104],%o0
/* 0x04ec	 399 */		add	%o0,%o3,%i1
/* 0x04f0	   0 */		sra	%o0,0,%o7
/* 0x04f4	 399 */		movrlz	%o7,%i1,%o0
/* 0x04f8	 400 */		ldub	[%o0+%i5],%g2
/* 0x04fc	     */		stb	%g2,[%l7]
/* 0x0500	 397 */		add	%l7,1,%l7
/* 0x0504	     */		ble,a,pt	%icc,.L900000532
/* 0x0508	 398 */		st	%l5,[%sp+100]

! Registers live out of .L900000532: 
! o1 o3 o4 sp l0 l1 l2 l5 l6 l7 i0 i2 i3 i5 fp i7 gsr 
! f0 
		
!  401		      !      }
!  402		      !   }
!  404		      !   /* write the span */
!  405		      !   for (r=r0; r<r1; r++) {

                       
! predecessor blocks: .L77003044 .L77003076 .L900000525 .L900000532

			.L77003074:
/* 0x050c	 405 */		cmp	%i3,%l1

! Registers live out of .L77003074: 
! o4 sp l0 l1 l2 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003048 .L77003074 .L900000517

			.L900000533:
/* 0x0510	 405 */		bge,pn	%icc,.L77003027
/* 0x0514	     */		add	%i2,%l2,%i5

! Registers live out of .L900000533: 
! o4 sp l0 l1 i0 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000533

			.L77003090:
/* 0x0518	 405 */		add	%l1,-1,%i2

!  406		      !      gl_write_stencil_span( ctx, m, x+skipcol, r, zstencil );

/* 0x051c	 406 */		or	%g0,%i3,%o3

! Registers live out of .L77003090: 
! o3 o4 sp l0 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003090 .L900000531

			.L900000531:
/* 0x0520	 406 */		or	%g0,%i5,%o2
/* 0x0524	     */		or	%g0,%l0,%o1
/* 0x0528	     */		or	%g0,%i0,%o0
/* 0x052c	 405 */		add	%i3,1,%i3
/* 0x0530	 406 */		call	gl_write_stencil_span	! params =  %o0 %o1 %o2 %o3 %o4	! Result = 
/* 0x0534	     */		add	%fp,-1600,%o4
/* 0x0538	 405 */		cmp	%i3,%i2
/* 0x053c	     */		ble,pt	%icc,.L900000531
/* 0x0540	 406 */		or	%g0,%i3,%o3

! Registers live out of .L900000531: 
! o3 o4 sp l0 i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002946 .L77002960 .L77002978 gl_write_zoomed_stencil_span .L900000531 .L900000533 .L900000540

			.L77003027:
/* 0x0544	 341 */		ret	! Result = 
/* 0x0548	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77002976 .L77003088

			.L77002986:
/* 0x054c	 385 */		sethi	%hi(.L196),%o1
/* 0x0550	     */		sethi	%hi(.L195),%l5
/* 0x0554	     */		add	%o1,%lo(.L196),%o1
/* 0x0558	     */		add	%l5,%lo(.L195),%o0
/* 0x055c	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0560	     */		or	%g0,385,%o2
/* 0x0564	     */		ld	[%i0+%l3],%f18
/* 0x0568	     */		ba	.L900000530
/* 0x056c	 388 */		ld	[%l7-4],%f17

! Registers live out of .L77002986: 
! o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i5 fp i7 gsr 
! f17 f18 
		/* 0x0570	   0 */		.type	gl_write_zoomed_stencil_span,2
/* 0x0570	   0 */		.size	gl_write_zoomed_stencil_span,(.-gl_write_zoomed_stencil_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000601:
/* 000000	   0 */		.word	(.L77003220-(___const_seg_900000601+0x0))
/* 0x0004	     */		.word	(.L77003228-(___const_seg_900000601+0x0))
/* 0x0008	     */		.word	(.L77003236-(___const_seg_900000601+0x0))
/* 0x000c	     */		.word	(.L77003252-(___const_seg_900000601+0x0))
/* 0x0010	     */		.word	(.L77003244-(___const_seg_900000601+0x0))
/* 0x0014	     */		.word	(.L77003260-(___const_seg_900000601+0x0))
/* 0x0018	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x001c	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0020	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0024	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0028	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x002c	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0030	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0034	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0038	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x003c	     */		.word	(.L77003276-(___const_seg_900000601+0x0))
/* 0x0040	     */		.word	(.L77003164-(___const_seg_900000601+0x0))
/* 0x0044	     */		.word	(.L77003172-(___const_seg_900000601+0x0))
/* 0x0048	     */		.word	(.L77003180-(___const_seg_900000601+0x0))
/* 0x004c	     */		.word	(.L77003196-(___const_seg_900000601+0x0))
/* 0x0050	     */		.word	(.L77003188-(___const_seg_900000601+0x0))
/* 0x0054	     */		.word	(.L77003204-(___const_seg_900000601+0x0))
/* 0x0058	   0 */		.word	1072693248,0
/* 0x0060	   0 */		.type	___const_seg_900000601,1
/* 0x0060	   0 */		.size	___const_seg_900000601,(.-___const_seg_900000601)
/* 0x0060	   0 */		.align	4

!  407		      !   }
!  408		      !}
!  413		      !/**********************************************************************/
!  414		      !/*****                    glPixelStore                            *****/
!  415		      !/**********************************************************************/
!  418		      !void gl_PixelStorei( GLcontext *ctx, GLenum pname, GLint param )
!  419		      !{

!
! SUBROUTINE gl_PixelStorei
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_PixelStorei
                       

			gl_PixelStorei:
/* 000000	 419 */		save	%sp,-96,%sp

!  420		      !   /* NOTE: this call can't be compiled into the display list */
!  422		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 422 */		sethi	%hi(0xe000),%l3
/* 0x0008	     */		add	%l3,252,%i3
/* 0x000c	     */		sethi	%hi(0x1800),%i4
/* 0x0010	     */		ld	[%i0+%i3],%l5
/* 0x0014	     */		add	%i4,512,%l6
/* 0x0018	     */		cmp	%l5,%l6
/* 0x001c	     */		be,pn	%icc,.L900000633
/* 0x0020	 427 */		sethi	%hi(___const_seg_900000601),%g1

! Registers live out of gl_PixelStorei: 
! g1 o0 sp i0 i1 i2 fp i7 gsr 
! 
		
!  423		      !      gl_error( ctx, GL_INVALID_OPERATION, "glPixelStore" );

                       
! predecessor blocks: gl_PixelStorei

			.L77003160:
/* 0x0024	 423 */		sethi	%hi(.L225),%l3
/* 0x0028	     */		add	%l3,%lo(.L225),%i2
/* 0x002c	     */		or	%g0,1282,%i1
/* 0x0030	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0034	     */		restore	%g0,0,%g0

!  424		      !      return;
!  425		      !   }
!  427		      !   switch (pname) {

                       
! predecessor blocks: gl_PixelStorei

			.L900000633:
/* 0x0038	 427 */		sub	%i1,3312,%l7
/* 0x003c	     */		cmp	%l7,21
/* 0x0040	     */		add	%g1,%lo(___const_seg_900000601),%i3
/* 0x0044	   0 */		sethi	%hi(0xdc00),%i4
/* 0x0048	 427 */		bgu,pn	%icc,.L77003276
/* 0x004c	     */		sll	%l7,2,%i5

! Registers live out of .L900000633: 
! o0 sp i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000633

			.L900000630:
/* 0x0050	 427 */		ld	[%i5+%i3],%i1
/* 0x0054	     */		jmpl	%i1+%i3,%g0
/* 0x0058	     */		nop

! Registers live out of .L900000630: 
! o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		
!  428		      !      case GL_PACK_SWAP_BYTES:
!  429		      !         ctx->Pack.SwapBytes = param ? GL_TRUE : GL_FALSE;

                       
! predecessor blocks: .L900000630

			.L77003164:
/* 0x005c	 429 */		srl	%i2,0,%g3
/* 0x0060	     */		sub	%g0,%g3,%o3
/* 0x0064	     */		srlx	%o3,63,%g2
/* 0x0068	     */		add	%i4,452,%g1
/* 0x006c	     */		stb	%g2,[%i0+%g1]

!  430		      !	 break;

/* 0x0070	 430 */		ba	.L900000632
/* 0x0074	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003164: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  431		      !      case GL_PACK_LSB_FIRST:
!  432		      !         ctx->Pack.LsbFirst = param ? GL_TRUE : GL_FALSE;

                       
! predecessor blocks: .L900000630

			.L77003172:
/* 0x0078	 432 */		srl	%i2,0,%g4
/* 0x007c	     */		sub	%g0,%g4,%o4
/* 0x0080	     */		add	%i4,453,%l0
/* 0x0084	     */		srlx	%o4,63,%l2
/* 0x0088	     */		stb	%l2,[%i0+%l0]

!  433		      !	 break;

/* 0x008c	 433 */		ba	.L900000632
/* 0x0090	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003172: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  434		      !      case GL_PACK_ROW_LENGTH:
!  435		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003180:
/* 0x0094	 435 */		cmp	%i2,0
/* 0x0098	     */		bge,pn	%icc,.L77003184
/* 0x009c	 436 */		sethi	%hi(.L239),%o5

! Registers live out of .L77003180: 
! o0 o5 sp i0 i2 i3 i4 fp i7 gsr 
! 
		
!  436		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

                       
! predecessor blocks: .L77003180

			.L77003182:
/* 0x00a0	 436 */		add	%o5,%lo(.L239),%o2
/* 0x00a4	     */		or	%g0,1281,%o1
/* 0x00a8	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x00ac	     */		or	%g0,%i0,%o0
/* 0x00b0	     */		ba	.L900000632
/* 0x00b4	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003182: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  437		      !	 }
!  438		      !	 else {
!  439		      !	    ctx->Pack.RowLength = param;

                       
! predecessor blocks: .L77003180

			.L77003184:
/* 0x00b8	 439 */		add	%i4,432,%o7
/* 0x00bc	     */		st	%i2,[%i0+%o7]
/* 0x00c0	     */		ba	.L900000632
/* 0x00c4	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003184: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  440		      !	 }
!  441		      !	 break;
!  442		      !      case GL_PACK_SKIP_PIXELS:
!  443		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003188:
/* 0x00c8	 443 */		cmp	%i2,0
/* 0x00cc	     */		bge,pn	%icc,.L77003192

!  444		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

/* 0x00d0	 444 */		or	%g0,1281,%o1

! Registers live out of .L77003188: 
! o0 o1 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003188

			.L77003190:
/* 0x00d4	 444 */		sethi	%hi(.L244),%i2
/* 0x00d8	     */		add	%i2,%lo(.L244),%o2
/* 0x00dc	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x00e0	     */		or	%g0,%i0,%o0
/* 0x00e4	     */		ba	.L900000632
/* 0x00e8	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003190: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  445		      !	 }
!  446		      !	 else {
!  447		      !	    ctx->Pack.SkipPixels = param;

                       
! predecessor blocks: .L77003188

			.L77003192:
/* 0x00ec	 447 */		add	%i4,436,%g5
/* 0x00f0	     */		st	%i2,[%i0+%g5]
/* 0x00f4	     */		ba	.L900000632
/* 0x00f8	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003192: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  448		      !	 }
!  449		      !	 break;
!  450		      !      case GL_PACK_SKIP_ROWS:
!  451		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003196:
/* 0x00fc	 451 */		cmp	%i2,0
/* 0x0100	     */		bge,pn	%icc,.L77003200
/* 0x0104	 452 */		sethi	%hi(.L249),%l4

! Registers live out of .L77003196: 
! o0 sp l4 i0 i2 i3 i4 fp i7 gsr 
! 
		
!  452		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

                       
! predecessor blocks: .L77003196

			.L77003198:
/* 0x0108	 452 */		add	%l4,%lo(.L249),%o2
/* 0x010c	     */		or	%g0,1281,%o1
/* 0x0110	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x0114	     */		or	%g0,%i0,%o0
/* 0x0118	     */		ba	.L900000632
/* 0x011c	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003198: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  453		      !	 }
!  454		      !	 else {
!  455		      !	    ctx->Pack.SkipRows = param;

                       
! predecessor blocks: .L77003196

			.L77003200:
/* 0x0120	 455 */		add	%i4,440,%l1
/* 0x0124	     */		st	%i2,[%i0+%l1]
/* 0x0128	     */		ba	.L900000632
/* 0x012c	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003200: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  456		      !	 }
!  457		      !	 break;
!  458		      !      case GL_PACK_ALIGNMENT:
!  459		      !         if (param==1 || param==2 || param==4 || param==8) {

                       
! predecessor blocks: .L900000630

			.L77003204:
/* 0x0130	 459 */		sub	%i2,1,%l5
/* 0x0134	     */		cmp	%l5,1
/* 0x0138	     */		bleu,pn	%icc,.L77003214
/* 0x013c	     */		cmp	%i2,4

! Registers live out of .L77003204: 
! o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003204

			.L77003208:
/* 0x0140	 459 */		be,pn	%icc,.L77003214
/* 0x0144	     */		cmp	%i2,8

! Registers live out of .L77003208: 
! o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003208

			.L77003210:
/* 0x0148	 459 */		be,pn	%icc,.L77003214
/* 0x014c	 463 */		sethi	%hi(.L259),%l6

! Registers live out of .L77003210: 
! o0 sp l6 i0 i2 i3 i4 fp i7 gsr 
! 
		
!  460		      !	    ctx->Pack.Alignment = param;
!  461		      !	 }
!  462		      !	 else {
!  463		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

                       
! predecessor blocks: .L77003210

			.L77003216:
/* 0x0150	 463 */		add	%l6,%lo(.L259),%o2
/* 0x0154	     */		or	%g0,1281,%o1
/* 0x0158	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x015c	     */		or	%g0,%i0,%o0
/* 0x0160	     */		ba	.L900000632
/* 0x0164	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003216: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003204 .L77003208 .L77003210

			.L77003214:
/* 0x0168	 460 */		add	%i4,428,%o0
/* 0x016c	     */		st	%i2,[%i0+%o0]
/* 0x0170	     */		ba	.L900000632
/* 0x0174	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003214: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  464		      !	 }
!  465		      !	 break;
!  466		      !      case GL_UNPACK_SWAP_BYTES:
!  467		      !	 ctx->Unpack.SwapBytes = param ? GL_TRUE : GL_FALSE;

                       
! predecessor blocks: .L900000630

			.L77003220:
/* 0x0178	 467 */		srl	%i2,0,%o2
/* 0x017c	     */		sub	%g0,%o2,%o1
/* 0x0180	     */		add	%i4,480,%l7
/* 0x0184	     */		srlx	%o1,63,%i1
/* 0x0188	     */		stb	%i1,[%i0+%l7]

!  468		      !         break;

/* 0x018c	 468 */		ba	.L900000632
/* 0x0190	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003220: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  469		      !      case GL_UNPACK_LSB_FIRST:
!  470		      !	 ctx->Unpack.LsbFirst = param ? GL_TRUE : GL_FALSE;

                       
! predecessor blocks: .L900000630

			.L77003228:
/* 0x0194	 470 */		srl	%i2,0,%o3
/* 0x0198	     */		sub	%g0,%o3,%g2
/* 0x019c	     */		add	%i4,481,%i5
/* 0x01a0	     */		srlx	%g2,63,%g1
/* 0x01a4	     */		stb	%g1,[%i0+%i5]

!  471		      !	 break;

/* 0x01a8	 471 */		ba	.L900000632
/* 0x01ac	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003228: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  472		      !      case GL_UNPACK_ROW_LENGTH:
!  473		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003236:
/* 0x01b0	 473 */		cmp	%i2,0
/* 0x01b4	     */		bge,pn	%icc,.L77003240
/* 0x01b8	 474 */		sethi	%hi(.L271),%g3

! Registers live out of .L77003236: 
! g3 o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		
!  474		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

                       
! predecessor blocks: .L77003236

			.L77003238:
/* 0x01bc	 474 */		add	%g3,%lo(.L271),%o2
/* 0x01c0	     */		or	%g0,1281,%o1
/* 0x01c4	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x01c8	     */		or	%g0,%i0,%o0
/* 0x01cc	     */		ba	.L900000632
/* 0x01d0	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003238: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  475		      !	 }
!  476		      !	 else {
!  477		      !	    ctx->Unpack.RowLength = param;

                       
! predecessor blocks: .L77003236

			.L77003240:
/* 0x01d4	 477 */		add	%i4,460,%o4
/* 0x01d8	     */		st	%i2,[%i0+%o4]
/* 0x01dc	     */		ba	.L900000632
/* 0x01e0	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003240: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  478		      !	 }
!  479		      !	 break;
!  480		      !      case GL_UNPACK_SKIP_PIXELS:
!  481		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003244:
/* 0x01e4	 481 */		cmp	%i2,0
/* 0x01e8	     */		bge,pn	%icc,.L77003248
/* 0x01ec	 482 */		sethi	%hi(.L276),%l0

! Registers live out of .L77003244: 
! o0 sp l0 i0 i2 i3 i4 fp i7 gsr 
! 
		
!  482		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

                       
! predecessor blocks: .L77003244

			.L77003246:
/* 0x01f0	 482 */		add	%l0,%lo(.L276),%o2
/* 0x01f4	     */		or	%g0,1281,%o1
/* 0x01f8	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x01fc	     */		or	%g0,%i0,%o0
/* 0x0200	     */		ba	.L900000632
/* 0x0204	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003246: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  483		      !	 }
!  484		      !	 else {
!  485		      !	    ctx->Unpack.SkipPixels = param;

                       
! predecessor blocks: .L77003244

			.L77003248:
/* 0x0208	 485 */		add	%i4,464,%g4
/* 0x020c	     */		st	%i2,[%i0+%g4]
/* 0x0210	     */		ba	.L900000632
/* 0x0214	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003248: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  486		      !	 }
!  487		      !	 break;
!  488		      !      case GL_UNPACK_SKIP_ROWS:
!  489		      !	 if (param<0) {

                       
! predecessor blocks: .L900000630

			.L77003252:
/* 0x0218	 489 */		cmp	%i2,0
/* 0x021c	     */		bge,pn	%icc,.L77003256

!  490		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore(param)" );

/* 0x0220	 490 */		or	%g0,1281,%o1

! Registers live out of .L77003252: 
! o0 o1 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003252

			.L77003254:
/* 0x0224	 490 */		sethi	%hi(.L281),%i2
/* 0x0228	     */		add	%i2,%lo(.L281),%o2
/* 0x022c	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x0230	     */		or	%g0,%i0,%o0
/* 0x0234	     */		ba	.L900000632
/* 0x0238	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003254: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  491		      !	 }
!  492		      !	 else {
!  493		      !	    ctx->Unpack.SkipRows = param;

                       
! predecessor blocks: .L77003252

			.L77003256:
/* 0x023c	 493 */		add	%i4,468,%g5
/* 0x0240	     */		st	%i2,[%i0+%g5]
/* 0x0244	     */		ba	.L900000632
/* 0x0248	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003256: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  494		      !	 }
!  495		      !	 break;
!  496		      !      case GL_UNPACK_ALIGNMENT:
!  497		      !         if (param==1 || param==2 || param==4 || param==8) {

                       
! predecessor blocks: .L900000630

			.L77003260:
/* 0x024c	 497 */		sub	%i2,1,%l1
/* 0x0250	     */		cmp	%l1,1
/* 0x0254	     */		bleu,pn	%icc,.L77003270
/* 0x0258	     */		cmp	%i2,4

! Registers live out of .L77003260: 
! o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003260

			.L77003264:
/* 0x025c	 497 */		be,pn	%icc,.L77003270
/* 0x0260	     */		cmp	%i2,8

! Registers live out of .L77003264: 
! o0 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003264

			.L77003266:
/* 0x0264	 497 */		be,pn	%icc,.L77003270
/* 0x0268	 501 */		sethi	%hi(.L291),%o1

! Registers live out of .L77003266: 
! o0 o1 sp i0 i2 i3 i4 fp i7 gsr 
! 
		
!  498		      !	    ctx->Unpack.Alignment = param;
!  499		      !	 }
!  500		      !	 else {
!  501		      !	    gl_error( ctx, GL_INVALID_VALUE, "glPixelStore" );

                       
! predecessor blocks: .L77003266

			.L77003272:
/* 0x026c	 501 */		add	%o1,%lo(.L291),%o2
/* 0x0270	     */		or	%g0,1281,%o1
/* 0x0274	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x0278	     */		or	%g0,%i0,%o0
/* 0x027c	     */		ba	.L900000632
/* 0x0280	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003272: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003260 .L77003264 .L77003266

			.L77003270:
/* 0x0284	 498 */		add	%i4,456,%o0
/* 0x0288	     */		st	%i2,[%i0+%o0]
/* 0x028c	     */		ba	.L900000632
/* 0x0290	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003270: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		
!  502		      !	 }
!  503		      !	 break;
!  504		      !      default:
!  505		      !	 gl_error( ctx, GL_INVALID_ENUM, "glPixelStore" );

                       
! predecessor blocks: .L900000630 .L900000633

			.L77003276:
/* 0x0294	 505 */		sethi	%hi(.L293),%o2
/* 0x0298	     */		add	%o2,%lo(.L293),%o2
/* 0x029c	     */		or	%g0,1280,%o1
/* 0x02a0	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x02a4	     */		or	%g0,%i0,%o0
/* 0x02a8	  95 */		ld	[%i0+2200],%o3

! Registers live out of .L77003276: 
! o3 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003164 .L77003172 .L77003182 .L77003184 .L77003190 .L77003192 .L77003198 .L77003200 .L77003214 .L77003216
! predecessor blocks: .L77003220 .L77003228 .L77003238 .L77003240 .L77003246 .L77003248 .L77003254 .L77003256 .L77003270 .L77003272 .L77003276

			.L900000632:
/* 0x02ac	  95 */		ldub	[%o3],%o4
/* 0x02b0	     */		cmp	%o4,1
/* 0x02b4	     */		bne,pn	%icc,.L900000631
/* 0x02b8	  99 */		add	%l3,285,%i2

! Registers live out of .L900000632: 
! o3 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000632

			.L77003286:
/* 0x02bc	  95 */		ldub	[%o3+20],%l0
/* 0x02c0	     */		cmp	%l0,0
/* 0x02c4	     */		be,pn	%icc,.L77003322
/* 0x02c8	   0 */		sethi	%hi(0xac00),%i2

! Registers live out of .L77003286: 
! sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003286

			.L77003288:
/* 0x02cc	  95 */		add	%i2,540,%l1
/* 0x02d0	     */		ld	[%i0+%l1],%f16
/* 0x02d4	     */		fzero	%f58
/* 0x02d8	     */		fstod	%f16,%f18
/* 0x02dc	     */		fcmpd	%fcc1,%f18,%f58
/* 0x02e0	     */		fbne,pn	%fcc1,.L77003322
/* 0x02e4	     */		add	%i2,544,%l2

! Registers live out of .L77003288: 
! sp l2 i0 i2 i3 i4 fp i7 gsr 
! f26 
		                       
! predecessor blocks: .L77003288

			.L77003290:
/* 0x02e8	  95 */		ld	[%i0+%l2],%f14
/* 0x02ec	     */		ldd	[%i3+88],%f62
/* 0x02f0	     */		fstod	%f14,%f60
/* 0x02f4	     */		fcmpd	%fcc2,%f60,%f62
/* 0x02f8	     */		fbne,pn	%fcc2,.L77003322
/* 0x02fc	     */		add	%i2,548,%o5

! Registers live out of .L77003290: 
! o5 sp i0 i2 i4 fp i7 gsr 
! f26 f30 
		                       
! predecessor blocks: .L77003290

			.L77003292:
/* 0x0300	  95 */		ld	[%i0+%o5],%f12
/* 0x0304	     */		fstod	%f12,%f56
/* 0x0308	     */		fcmpd	%fcc3,%f56,%f58
/* 0x030c	     */		fbne,pn	%fcc3,.L77003322
/* 0x0310	     */		add	%i2,552,%o7

! Registers live out of .L77003292: 
! sp o7 i0 i2 i4 fp i7 gsr 
! f26 f30 
		                       
! predecessor blocks: .L77003292

			.L77003294:
/* 0x0314	  95 */		ld	[%i0+%o7],%f10
/* 0x0318	     */		fstod	%f10,%f54
/* 0x031c	     */		fcmpd	%fcc0,%f54,%f62
/* 0x0320	     */		fbne,pn	%fcc0,.L77003322
/* 0x0324	     */		add	%i2,556,%l4

! Registers live out of .L77003294: 
! sp l4 i0 i2 i4 fp i7 gsr 
! f26 f30 
		                       
! predecessor blocks: .L77003294

			.L77003296:
/* 0x0328	  95 */		ld	[%i0+%l4],%f8
/* 0x032c	     */		fstod	%f8,%f50
/* 0x0330	     */		fcmpd	%fcc1,%f50,%f58
/* 0x0334	     */		fbne,pn	%fcc1,.L77003322
/* 0x0338	     */		add	%i2,560,%l5

! Registers live out of .L77003296: 
! sp l5 i0 i2 i4 fp i7 gsr 
! f26 f30 
		                       
! predecessor blocks: .L77003296

			.L77003298:
/* 0x033c	  95 */		ld	[%i0+%l5],%f6
/* 0x0340	     */		fstod	%f6,%f48
/* 0x0344	     */		fcmpd	%fcc2,%f48,%f62
/* 0x0348	     */		fbne,pn	%fcc2,.L77003322
/* 0x034c	     */		add	%i2,564,%l6

! Registers live out of .L77003298: 
! sp l6 i0 i2 i4 fp i7 gsr 
! f26 f30 
		                       
! predecessor blocks: .L77003298

			.L77003300:
/* 0x0350	  95 */		ld	[%i0+%l6],%f4
/* 0x0354	     */		fstod	%f4,%f30
/* 0x0358	     */		fcmpd	%fcc3,%f30,%f58
/* 0x035c	     */		fbne,pn	%fcc3,.L77003322
/* 0x0360	     */		add	%i2,568,%l7

! Registers live out of .L77003300: 
! sp l7 i0 i2 i4 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77003300

			.L77003302:
/* 0x0364	  95 */		ld	[%i0+%l7],%f2
/* 0x0368	     */		fstod	%f2,%f28
/* 0x036c	     */		fcmpd	%fcc0,%f28,%f62
/* 0x0370	     */		fbne,pn	%fcc0,.L77003322
/* 0x0374	     */		add	%i2,588,%i5

! Registers live out of .L77003302: 
! sp i0 i2 i4 i5 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77003302

			.L77003304:
/* 0x0378	  95 */		ldub	[%i0+%i5],%i1
/* 0x037c	     */		cmp	%i1,0
/* 0x0380	     */		bne,pn	%icc,.L77003322
/* 0x0384	     */		add	%i2,592,%g1

! Registers live out of .L77003304: 
! g1 sp i0 i2 i4 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77003304

			.L77003306:
/* 0x0388	  95 */		ld	[%i0+%g1],%f0
/* 0x038c	     */		fstod	%f0,%f24
/* 0x0390	     */		fcmpd	%fcc1,%f24,%f62
/* 0x0394	     */		fbne,pn	%fcc1,.L77003322
/* 0x0398	     */		add	%i2,596,%g2

! Registers live out of .L77003306: 
! g2 sp i0 i4 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77003306

			.L77003308:
/* 0x039c	  95 */		ld	[%i0+%g2],%f0
/* 0x03a0	     */		fstod	%f0,%f20
/* 0x03a4	     */		fcmpd	%fcc2,%f20,%f62
/* 0x03a8	     */		fbne,pn	%fcc2,.L77003322
/* 0x03ac	     */		add	%i4,460,%g4

! Registers live out of .L77003308: 
! g4 sp i0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003308

			.L77003310:
/* 0x03b0	  95 */		ld	[%i0+%g4],%g3
/* 0x03b4	     */		cmp	%g3,0
/* 0x03b8	     */		bne,pn	%icc,.L77003322
/* 0x03bc	     */		add	%i4,464,%o0

! Registers live out of .L77003310: 
! o0 sp i0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003310

			.L77003312:
/* 0x03c0	  95 */		ld	[%i0+%o0],%g5
/* 0x03c4	     */		cmp	%g5,0
/* 0x03c8	     */		bne,pn	%icc,.L77003322
/* 0x03cc	     */		add	%i4,468,%o2

! Registers live out of .L77003312: 
! o2 sp i0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003312

			.L77003314:
/* 0x03d0	  95 */		ld	[%i0+%o2],%o1
/* 0x03d4	     */		cmp	%o1,0
/* 0x03d8	     */		bne,pn	%icc,.L77003322
/* 0x03dc	     */		add	%i4,480,%o4

! Registers live out of .L77003314: 
! o4 sp i0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003314

			.L77003316:
/* 0x03e0	  95 */		ldub	[%i0+%o4],%o3
/* 0x03e4	     */		cmp	%o3,0
/* 0x03e8	     */		bne,pn	%icc,.L77003322
/* 0x03ec	  96 */		add	%i4,481,%l4

! Registers live out of .L77003316: 
! sp l4 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003316

			.L77003318:
/* 0x03f0	  96 */		ldub	[%i0+%l4],%o7
/* 0x03f4	     */		add	%l3,285,%l0
/* 0x03f8	     */		sub	%g0,%o7,%o5
/* 0x03fc	     */		srlx	%o5,63,%l2
/* 0x0400	     */		xor	%l2,1,%l1
/* 0x0404	     */		stb	%l1,[%i0+%l0]
/* 0x0408	 424 */		ret	! Result = 
/* 0x040c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003286 .L77003288 .L77003290 .L77003292 .L77003294 .L77003296 .L77003298 .L77003300 .L77003302 .L77003304
! predecessor blocks: .L77003306 .L77003308 .L77003310 .L77003312 .L77003314 .L77003316

			.L77003322:
/* 0x0410	  99 */		add	%l3,285,%i2

! Registers live out of .L77003322: 
! sp i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003322 .L900000632

			.L900000631:
/* 0x0414	  99 */		stb	%g0,[%i0+%i2]
/* 0x0418	 424 */		ret	! Result = 
/* 0x041c	     */		restore	%g0,0,%g0
/* 0x0420	   0 */		.type	gl_PixelStorei,2
/* 0x0420	   0 */		.size	gl_PixelStorei,(.-gl_PixelStorei)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000701:
/* 000000	   0 */		.word	(.L77003420-(___const_seg_900000701+0x0))
/* 0x0004	     */		.word	(.L77003410-(___const_seg_900000701+0x0))
/* 0x0008	     */		.word	(.L77003430-(___const_seg_900000701+0x0))
/* 0x000c	     */		.word	(.L77003452-(___const_seg_900000701+0x0))
/* 0x0010	     */		.word	(.L77003474-(___const_seg_900000701+0x0))
/* 0x0014	     */		.word	(.L77003496-(___const_seg_900000701+0x0))
/* 0x0018	     */		.word	(.L77003518-(___const_seg_900000701+0x0))
/* 0x001c	     */		.word	(.L77003540-(___const_seg_900000701+0x0))
/* 0x0020	     */		.word	(.L77003562-(___const_seg_900000701+0x0))
/* 0x0024	     */		.word	(.L77003584-(___const_seg_900000701+0x0))
/* 0x0028	   0 */		.word	1072693248,0
/* 0x0030	   0 */		.type	___const_seg_900000701,1
/* 0x0030	   0 */		.size	___const_seg_900000701,(.-___const_seg_900000701)
/* 0x0030	   0 */		.align	4

!  506		      !   }
!  507		      !   update_drawpixels_state( ctx );
!  508		      !}
!  514		      !/**********************************************************************/
!  515		      !/*****                         glPixelMap                         *****/
!  516		      !/**********************************************************************/
!  520		      !void gl_PixelMapfv( GLcontext *ctx,
!  521		      !                    GLenum map, GLint mapsize, const GLfloat *values )
!  522		      !{

!
! SUBROUTINE gl_PixelMapfv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_PixelMapfv
                       

			gl_PixelMapfv:
/* 000000	 522 */		save	%sp,-96,%sp

!  523		      !   GLuint i;
!  525		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 525 */		sethi	%hi(0xe000),%g1
/* 0x0008	     */		add	%g1,252,%l7
/* 0x000c	     */		sethi	%hi(0x1800),%l6
/* 0x0010	     */		ld	[%i0+%l7],%l4
/* 0x0014	     */		add	%l6,512,%l5
/* 0x0018	     */		cmp	%l4,%l5
/* 0x001c	     */		be,pn	%icc,.L77003378
/* 0x0020	 526 */		sethi	%hi(.L302),%l1

! Registers live out of gl_PixelMapfv: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp l0 l1 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  526		      !      gl_error( ctx, GL_INVALID_OPERATION, "glPixelMapfv" );

                       
! predecessor blocks: gl_PixelMapfv

			.L77003376:
/* 0x0024	 526 */		add	%l1,%lo(.L302),%i2
/* 0x0028	     */		or	%g0,1282,%i1
/* 0x002c	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0030	     */		restore	%g0,0,%g0

!  527		      !      return;
!  528		      !   }
!  530		      !   if (mapsize<0 || mapsize>MAX_PIXEL_MAP_TABLE) {

                       
! predecessor blocks: gl_PixelMapfv

			.L77003378:
/* 0x0034	 530 */		cmp	%i2,256
/* 0x0038	     */		bleu,pn	%icc,.L900000820
/* 0x003c	 535 */		add	%i1,-3185,%l4

! Registers live out of .L77003378: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp l0 l4 l6 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  531		      !      gl_error( ctx, GL_INVALID_VALUE, "glPixelMapfv(mapsize)" );

                       
! predecessor blocks: .L77003378

			.L77003384:
/* 0x0040	 531 */		sethi	%hi(.L307),%i2
/* 0x0044	     */		or	%g0,1281,%i1
/* 0x0048	     */		add	%i2,%lo(.L307),%i2
/* 0x004c	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0050	     */		restore	%g0,0,%g0

!  532		      !      return;
!  533		      !   }
!  535		      !   if (map>=GL_PIXEL_MAP_S_TO_S && map<=GL_PIXEL_MAP_I_TO_A) {

                       
! predecessor blocks: .L77003378

			.L900000820:
/* 0x0054	 535 */		cmp	%l4,4
/* 0x0058	     */		bgu,pn	%icc,.L77003608

!  536		      !      /* test that mapsize is a power of two */
!  537		      !      GLuint p;
!  538		      !      GLboolean ok = GL_FALSE;
!  539		      !      for (p=1; p<=MAX_PIXEL_MAP_TABLE; p=p<<1) {

/* 0x005c	 539 */		or	%g0,1,%i4

! Registers live out of .L900000820: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp l0 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  540		      !	 if ( (p&mapsize) == p ) {

                       
! predecessor blocks: .L900000820

			.L77003394:
/* 0x0060	 540 */		and	%i4,%i2,%o7

! Registers live out of .L77003394: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003394 .L77003398

			.L900000819:
/* 0x0064	 540 */		cmp	%o7,%i4
/* 0x0068	     */		be,pn	%icc,.L77003608
/* 0x006c	     */		sll	%i4,1,%i4

! Registers live out of .L900000819: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp l0 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000819

			.L77003398:
/* 0x0070	 539 */		cmp	%i4,256
/* 0x0074	     */		bleu,pt	%icc,.L900000819
/* 0x0078	 540 */		and	%i4,%i2,%o7

! Registers live out of .L77003398: 
! g1 g4 o0 o1 o2 o3 o4 o5 sp o7 l0 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  541		      !	    ok = GL_TRUE;
!  542		      !	    break;
!  543		      !	 }
!  544		      !      }
!  545		      !      if (!ok) {
!  546		      !	 gl_error( ctx, GL_INVALID_VALUE, "glPixelMapfv(mapsize)" );

                       
! predecessor blocks: .L77003398

			.L77003404:
/* 0x007c	 546 */		sethi	%hi(.L320),%i3
/* 0x0080	     */		add	%i3,%lo(.L320),%i2
/* 0x0084	     */		or	%g0,1281,%i1
/* 0x0088	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x008c	     */		restore	%g0,0,%g0

!  547		      !         return;
!  548		      !      }
!  549		      !   }
!  551		      !   switch (map) {

                       
! predecessor blocks: .L900000819 .L900000820

			.L77003608:
/* 0x0090	 551 */		sub	%i1,3184,%g2
/* 0x0094	     */		cmp	%g2,9
/* 0x0098	     */		bgu,pn	%icc,.L77003606
/* 0x009c	     */		sll	%g2,2,%g4

! Registers live out of .L77003608: 
! g2 g4 o1 o4 o5 sp l0 l6 l7 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003608

			.L900000746:
/* 0x00a0	 551 */		sethi	%hi(___const_seg_900000701),%i4
/* 0x00a4	     */		add	%i4,%lo(___const_seg_900000701),%i4
/* 0x00a8	   0 */		sethi	%hi(0xac00),%l1
/* 0x00ac	   0 */		sethi	%hi(0x7ffffc00),%o7
/* 0x00b0	 551 */		ld	[%g4+%i4],%g3
/* 0x00b4	     */		jmpl	%g3+%i4,%g0
/* 0x00b8	     */		nop

! Registers live out of .L900000746: 
! g2 o1 o4 o5 sp o7 l0 l1 l6 l7 i0 i2 i3 i4 fp i7 gsr 
! 
		
!  552		      !      case GL_PIXEL_MAP_S_TO_S:
!  553		      !         ctx->Pixel.MapStoSsize = mapsize;
!  554		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003410:
/* 0x00bc	 554 */		cmp	%i2,0
/* 0x00c0	 553 */		add	%l1,600,%l4
/* 0x00c4	 554 */		bleu,pn	%icc,.L77003611
/* 0x00c8	 553 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003410: 
! o4 sp o7 l1 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003410

			.L77003643:
/* 0x00cc	 554 */		cmp	%i2,2
/* 0x00d0	     */		bl,pn	%icc,.L77003885
/* 0x00d4	     */		add	%o7,1022,%g1

! Registers live out of .L77003643: 
! g1 o4 sp l1 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003643

			.L77003728:
/* 0x00d8	 554 */		srl	%i2,0,%o7
/* 0x00dc	     */		sub	%o7,%g1,%o5
/* 0x00e0	     */		srlx	%o5,63,%l7
/* 0x00e4	     */		andcc	%l7,1,%g0
/* 0x00e8	     */		be,a,pn	%icc,.L77003827
/* 0x00ec	     */		or	%g0,0,%o4

! Registers live out of .L77003728: 
! o4 sp l1 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003728

			.L77003808:
/* 0x00f0	 554 */		add	%l1,640,%o0
/* 0x00f4	     */		add	%i2,-1,%l1
/* 0x00f8	     */		add	%i0,%o0,%l0

!  555		      !	    ctx->Pixel.MapStoS[i] = (GLint) values[i];

/* 0x00fc	 555 */		add	%l1,1,%o0
/* 0x0100	     */		cmp	%o0,12
/* 0x0104	 554 */		or	%g0,0,%i2
/* 0x0108	 555 */		bl,pn	%icc,.L77003809
/* 0x010c	     */		nop

! Registers live out of .L77003808: 
! sp l0 l1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003808

			.L900000753:
/* 0x0110	 555 */		ld	[%i3],%f2
/* 0x0114	     */		ld	[%i3+4],%f0
/* 0x0118	     */		ld	[%i3+12],%f8
/* 0x011c	     */		sub	%l1,7,%i5
/* 0x0120	 554 */		or	%g0,4,%i2
/* 0x0124	 555 */		ld	[%i3+8],%f6
/* 0x0128	 554 */		add	%i3,16,%i3

! Registers live out of .L900000753: 
! sp l0 l1 i2 i3 i5 fp i7 gsr 
! f0 f2 f6 f8 
		                       
! predecessor blocks: .L900000751 .L900000753

			.L900000751:
/* 0x012c	 555 */		prefetch	[%i3+144],0
/* 0x0130	     */		prefetch	[%l0+144],2
/* 0x0134	 554 */		add	%i2,8,%i2
/* 0x0138	 555 */		ld	[%i3],%f11
/* 0x013c	 554 */		add	%i3,32,%i3
/* 0x0140	 555 */		fstoi	%f2,%f1
/* 0x0144	     */		st	%f1,[%l0]
/* 0x0148	 554 */		cmp	%i2,%i5
/* 0x014c	     */		add	%l0,32,%l0
/* 0x0150	 555 */		fstoi	%f0,%f3
/* 0x0154	     */		ld	[%i3-28],%f5
/* 0x0158	     */		st	%f3,[%l0-28]
/* 0x015c	     */		fstoi	%f6,%f7
/* 0x0160	     */		ld	[%i3-24],%f17
/* 0x0164	     */		st	%f7,[%l0-24]
/* 0x0168	     */		fstoi	%f8,%f9
/* 0x016c	     */		ld	[%i3-20],%f21
/* 0x0170	     */		st	%f9,[%l0-20]
/* 0x0174	     */		fstoi	%f11,%f13
/* 0x0178	     */		ld	[%i3-16],%f2
/* 0x017c	     */		st	%f13,[%l0-16]
/* 0x0180	     */		fstoi	%f5,%f15
/* 0x0184	     */		ld	[%i3-12],%f0
/* 0x0188	     */		st	%f15,[%l0-12]
/* 0x018c	     */		fstoi	%f17,%f19
/* 0x0190	     */		ld	[%i3-8],%f6
/* 0x0194	     */		st	%f19,[%l0-8]
/* 0x0198	     */		fstoi	%f21,%f23
/* 0x019c	     */		ld	[%i3-4],%f8
/* 0x01a0	 554 */		ble,pt	%icc,.L900000751
/* 0x01a4	 555 */		st	%f23,[%l0-4]

! Registers live out of .L900000751: 
! sp l0 l1 i2 i3 i5 fp i7 gsr 
! f0 f2 f6 f8 
		                       
! predecessor blocks: .L900000751

			.L900000754:
/* 0x01a8	 555 */		fstoi	%f8,%f28
/* 0x01ac	     */		fstoi	%f6,%f26
/* 0x01b0	     */		fstoi	%f0,%f24
/* 0x01b4	     */		fstoi	%f2,%f30
/* 0x01b8	 554 */		add	%l0,16,%l0
/* 0x01bc	 555 */		st	%f30,[%l0-16]
/* 0x01c0	     */		st	%f24,[%l0-12]
/* 0x01c4	     */		st	%f26,[%l0-8]
/* 0x01c8	 554 */		cmp	%i2,%l1
/* 0x01cc	 555 */		st	%f28,[%l0-4]
/* 0x01d0	 554 */		bg,pn	%icc,.L900000744
/* 0x01d4	 555 */		nop

! Registers live out of .L900000754: 
! sp l0 l1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003808 .L900000754

			.L77003809:
/* 0x01d8	 554 */		add	%i2,1,%i2

! Registers live out of .L77003809: 
! sp l0 l1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003809 .L900000818

			.L900000818:
/* 0x01dc	 554 */		cmp	%i2,%l1
/* 0x01e0	 555 */		ld	[%i3],%f28
/* 0x01e4	 554 */		add	%i3,4,%i3
/* 0x01e8	 555 */		fstoi	%f28,%f30
/* 0x01ec	     */		st	%f30,[%l0]
/* 0x01f0	 554 */		add	%l0,4,%l0
/* 0x01f4	     */		ble,pt	%icc,.L900000818
/* 0x01f8	     */		add	%i2,1,%i2

! Registers live out of .L900000818: 
! sp l0 l1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000754 .L900000818

			.L900000744:
/* 0x01fc	 557 */		ret	! Result = 
/* 0x0200	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003643

			.L77003885:
/* 0x0204	 554 */		or	%g0,0,%o4

! Registers live out of .L77003885: 
! o4 sp l1 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003728 .L77003885

			.L77003827:
/* 0x0208	 554 */		add	%l1,640,%i5
/* 0x020c	 555 */		sll	%o4,2,%o1
/* 0x0210	     */		add	%i0,%i5,%l5

! Registers live out of .L77003827: 
! o1 o4 sp l5 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003724 .L77003827

			.L900000816:
/* 0x0214	 555 */		ld	[%o1+%i3],%f20
/* 0x0218	 554 */		add	%o4,1,%o4
/* 0x021c	     */		cmp	%o4,%i2
/* 0x0220	 555 */		fstoi	%f20,%f22
/* 0x0224	 554 */		bcc,pn	%icc,.L77003611
/* 0x0228	 555 */		st	%f22,[%l5+%o1]

! Registers live out of .L900000816: 
! o4 sp l5 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000816

			.L77003724:
/* 0x022c	 555 */		sll	%o4,2,%l6
/* 0x0230	     */		ld	[%l6+%i3],%f25
/* 0x0234	 554 */		add	%o4,1,%o4
/* 0x0238	     */		cmp	%o4,%i2
/* 0x023c	 555 */		fstoi	%f25,%f27
/* 0x0240	     */		st	%f27,[%l5+%l6]
/* 0x0244	 554 */		bcs,pt	%icc,.L900000816
/* 0x0248	 555 */		sll	%o4,2,%o1

! Registers live out of .L77003724: 
! o1 o4 sp l5 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003724

			.L900000743:
/* 0x024c	 557 */		ret	! Result = 
/* 0x0250	     */		restore	%g0,0,%g0

!  556		      !	 }
!  557		      !	 break;
!  558		      !      case GL_PIXEL_MAP_I_TO_I:
!  559		      !         ctx->Pixel.MapItoIsize = mapsize;
!  560		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003420:
/* 0x0254	 560 */		cmp	%i2,0
/* 0x0258	 559 */		add	%l1,604,%i4
/* 0x025c	 560 */		bleu,pn	%icc,.L77003611
/* 0x0260	 559 */		st	%i2,[%i0+%i4]

! Registers live out of .L77003420: 
! g2 sp o7 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003420

			.L77003644:
/* 0x0264	 560 */		cmp	%i2,2
/* 0x0268	     */		bl,pn	%icc,.L77003883
/* 0x026c	     */		add	%o7,1022,%o0

! Registers live out of .L77003644: 
! g2 o0 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003644

			.L77003736:
/* 0x0270	 560 */		srl	%i2,0,%g5
/* 0x0274	     */		sub	%g5,%o0,%g4
/* 0x0278	     */		srlx	%g4,63,%i4
/* 0x027c	     */		andcc	%i4,1,%g0
/* 0x0280	     */		be,a,pn	%icc,.L77003829
/* 0x0284	     */		or	%g0,0,%g2

! Registers live out of .L77003736: 
! g2 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003736

			.L77003810:
/* 0x0288	 560 */		sethi	%hi(0xb000),%i4

!  561		      !	    ctx->Pixel.MapItoI[i] = (GLint) values[i];

/* 0x028c	 561 */		add	%i2,0,%g5
/* 0x0290	 560 */		add	%i4,640,%o1
/* 0x0294	 561 */		cmp	%g5,12
/* 0x0298	 560 */		add	%i0,%o1,%o3
/* 0x029c	     */		add	%i2,-1,%o7
/* 0x02a0	     */		or	%g0,0,%o5
/* 0x02a4	     */		or	%g0,%i3,%o4
/* 0x02a8	 561 */		bl,pn	%icc,.L77003811
/* 0x02ac	     */		nop

! Registers live out of .L77003810: 
! o3 o4 o5 sp o7 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003810

			.L900000749:
/* 0x02b0	 561 */		ld	[%o4],%f14
/* 0x02b4	     */		ld	[%o4+4],%f10
/* 0x02b8	     */		ld	[%o4+12],%f16
/* 0x02bc	     */		add	%i2,-8,%i0
/* 0x02c0	 560 */		or	%g0,4,%o5
/* 0x02c4	 561 */		ld	[%o4+8],%f12
/* 0x02c8	 560 */		add	%o4,16,%o4

! Registers live out of .L900000749: 
! o3 o4 o5 sp o7 i0 fp i7 gsr 
! f10 f12 f14 f16 
		                       
! predecessor blocks: .L900000747 .L900000749

			.L900000747:
/* 0x02cc	 561 */		prefetch	[%o4+144],0
/* 0x02d0	     */		prefetch	[%o3+144],2
/* 0x02d4	 560 */		add	%o5,8,%o5
/* 0x02d8	 561 */		ld	[%o4],%f4
/* 0x02dc	 560 */		add	%o4,32,%o4
/* 0x02e0	 561 */		fstoi	%f14,%f0
/* 0x02e4	     */		st	%f0,[%o3]
/* 0x02e8	 560 */		cmp	%o5,%i0
/* 0x02ec	     */		add	%o3,32,%o3
/* 0x02f0	 561 */		fstoi	%f10,%f6
/* 0x02f4	     */		ld	[%o4-28],%f18
/* 0x02f8	     */		st	%f6,[%o3-28]
/* 0x02fc	     */		fstoi	%f12,%f2
/* 0x0300	     */		ld	[%o4-24],%f20
/* 0x0304	     */		st	%f2,[%o3-24]
/* 0x0308	     */		fstoi	%f16,%f8
/* 0x030c	     */		ld	[%o4-20],%f22
/* 0x0310	     */		st	%f8,[%o3-20]
/* 0x0314	     */		fstoi	%f4,%f10
/* 0x0318	     */		ld	[%o4-16],%f14
/* 0x031c	     */		st	%f10,[%o3-16]
/* 0x0320	     */		fstoi	%f18,%f12
/* 0x0324	     */		ld	[%o4-12],%f10
/* 0x0328	     */		st	%f12,[%o3-12]
/* 0x032c	     */		fstoi	%f20,%f16
/* 0x0330	     */		ld	[%o4-8],%f12
/* 0x0334	     */		st	%f16,[%o3-8]
/* 0x0338	     */		fstoi	%f22,%f24
/* 0x033c	     */		ld	[%o4-4],%f16
/* 0x0340	 560 */		ble,pt	%icc,.L900000747
/* 0x0344	 561 */		st	%f24,[%o3-4]

! Registers live out of .L900000747: 
! o3 o4 o5 sp o7 i0 fp i7 gsr 
! f10 f12 f14 f16 
		                       
! predecessor blocks: .L900000747

			.L900000750:
/* 0x0348	 561 */		fstoi	%f16,%f29
/* 0x034c	     */		fstoi	%f12,%f27
/* 0x0350	     */		fstoi	%f10,%f25
/* 0x0354	     */		fstoi	%f14,%f31
/* 0x0358	 560 */		add	%o3,16,%o3
/* 0x035c	 561 */		st	%f31,[%o3-16]
/* 0x0360	     */		st	%f25,[%o3-12]
/* 0x0364	     */		st	%f27,[%o3-8]
/* 0x0368	 560 */		cmp	%o5,%o7
/* 0x036c	 561 */		st	%f29,[%o3-4]
/* 0x0370	 560 */		bg,pn	%icc,.L900000742
/* 0x0374	 561 */		nop

! Registers live out of .L900000750: 
! o3 o4 o5 sp o7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003810 .L900000750

			.L77003811:
/* 0x0378	 560 */		add	%o5,1,%o5

! Registers live out of .L77003811: 
! o3 o4 o5 sp o7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003811 .L900000815

			.L900000815:
/* 0x037c	 560 */		cmp	%o5,%o7
/* 0x0380	 561 */		ld	[%o4],%f14
/* 0x0384	 560 */		add	%o4,4,%o4
/* 0x0388	 561 */		fstoi	%f14,%f26
/* 0x038c	     */		st	%f26,[%o3]
/* 0x0390	 560 */		add	%o3,4,%o3
/* 0x0394	     */		ble,pt	%icc,.L900000815
/* 0x0398	     */		add	%o5,1,%o5

! Registers live out of .L900000815: 
! o3 o4 o5 sp o7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000750 .L900000815

			.L900000742:
/* 0x039c	 557 */		ret	! Result = 
/* 0x03a0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003644

			.L77003883:
/* 0x03a4	 560 */		or	%g0,0,%g2

! Registers live out of .L77003883: 
! g2 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003736 .L77003883

			.L77003829:
/* 0x03a8	 560 */		sethi	%hi(0xb000),%l3
/* 0x03ac	     */		add	%l3,640,%l2
/* 0x03b0	 561 */		sll	%g2,2,%o2
/* 0x03b4	     */		add	%i0,%l2,%g3

! Registers live out of .L77003829: 
! g2 g3 o2 sp i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003732 .L77003829

			.L900000813:
/* 0x03b8	 561 */		ld	[%o2+%i3],%f4
/* 0x03bc	 560 */		add	%g2,1,%g2
/* 0x03c0	     */		cmp	%g2,%i2
/* 0x03c4	 561 */		fstoi	%f4,%f18
/* 0x03c8	 560 */		bcc,pn	%icc,.L77003611
/* 0x03cc	 561 */		st	%f18,[%g3+%o2]

! Registers live out of .L900000813: 
! g2 g3 sp i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000813

			.L77003732:
/* 0x03d0	 561 */		sll	%g2,2,%i0
/* 0x03d4	     */		ld	[%i0+%i3],%f21
/* 0x03d8	 560 */		add	%g2,1,%g2
/* 0x03dc	     */		cmp	%g2,%i2
/* 0x03e0	 561 */		fstoi	%f21,%f23
/* 0x03e4	     */		st	%f23,[%g3+%i0]
/* 0x03e8	 560 */		bcs,pt	%icc,.L900000813
/* 0x03ec	 561 */		sll	%g2,2,%o2

! Registers live out of .L77003732: 
! g2 g3 o2 sp i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003732

			.L900000741:
/* 0x03f0	 557 */		ret	! Result = 
/* 0x03f4	     */		restore	%g0,0,%g0

!  562		      !	 }
!  563		      !	 break;
!  564		      !      case GL_PIXEL_MAP_I_TO_R:
!  565		      !         ctx->Pixel.MapItoRsize = mapsize;
!  566		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003430:
/* 0x03f8	 566 */		cmp	%i2,0
/* 0x03fc	 565 */		add	%l1,608,%l1
/* 0x0400	 566 */		bleu,pn	%icc,.L77003611
/* 0x0404	 565 */		st	%i2,[%i0+%l1]

! Registers live out of .L77003430: 
! sp o7 l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003430

			.L77003642:
/* 0x0408	 566 */		cmp	%i2,4
/* 0x040c	     */		bl,pn	%icc,.L77003887
/* 0x0410	     */		add	%o7,1022,%o1

! Registers live out of .L77003642: 
! o1 sp l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003642

			.L77003720:
/* 0x0414	 566 */		sethi	%hi(0xb400),%l4
/* 0x0418	     */		add	%l4,640,%o3
/* 0x041c	     */		add	%i0,%o3,%i1
/* 0x0420	     */		sub	%i1,%i3,%o2
/* 0x0424	     */		sra	%o2,31,%i5
/* 0x0428	     */		xor	%o2,%i5,%l3
/* 0x042c	     */		sub	%l3,%i5,%l1
/* 0x0430	     */		sll	%i2,2,%l2
/* 0x0434	     */		sra	%l2,0,%o0
/* 0x0438	     */		sra	%l1,0,%g5
/* 0x043c	     */		srl	%i2,0,%g3
/* 0x0440	     */		sub	%g5,%o0,%g4
/* 0x0444	     */		sub	%g3,%o1,%g2
/* 0x0448	     */		srlx	%g4,63,%l0
/* 0x044c	     */		srlx	%g2,63,%g1
/* 0x0450	     */		xor	%l0,1,%o7
/* 0x0454	     */		and	%g1,1,%o5
/* 0x0458	     */		andcc	%o5,%o7,%g0
/* 0x045c	     */		be,a,pn	%icc,.L77003825
/* 0x0460	     */		or	%g0,0,%l6

! Registers live out of .L77003720: 
! sp l6 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003720

			.L77003806:
/* 0x0464	 566 */		ldd	[%i4+40],%f62
/* 0x0468	     */		add	%i2,-1,%l1
/* 0x046c	     */		fzero	%f60

!  567		      !	    ctx->Pixel.MapItoR[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0470	 567 */		ld	[%i3],%f9
/* 0x0474	 566 */		or	%g0,0,%i0

! Registers live out of .L77003806: 
! sp l1 i0 i1 i3 fp i7 gsr 
! f9 f28 f30 
		                       
! predecessor blocks: .L77003806 .L900000811

			.L900000810:
/* 0x0478	 567 */		fstod	%f9,%f44
/* 0x047c	     */		fcmped	%fcc3,%f44,%f60
/* 0x0480	     */		fbuge,a,pn	%fcc3,.L900000812
/* 0x0484	     */		fcmped	%fcc0,%f62,%f44

! Registers live out of .L900000810: 
! sp l1 i0 i1 i3 fp i7 gsr 
! f9 f12 f28 f30 
		                       
! predecessor blocks: .L900000810

			.L77003436:
/* 0x0488	 567 */		fmovd	%f60,%f44
/* 0x048c	     */		ba	.L900000811
/* 0x0490	 566 */		add	%i0,1,%i0

! Registers live out of .L77003436: 
! sp l1 i0 i1 i3 fp i7 gsr 
! f9 f12 f28 f30 
		                       
! predecessor blocks: .L900000810

			.L900000812:
/* 0x0494	 567 */		fmovdl	%fcc0,%f62,%f44
/* 0x0498	 566 */		add	%i0,1,%i0

! Registers live out of .L900000812: 
! sp l1 i0 i1 i3 fp i7 gsr 
! f9 f12 f28 f30 
		                       
! predecessor blocks: .L77003436 .L900000812

			.L900000811:
/* 0x049c	 566 */		cmp	%i0,%l1
/* 0x04a0	 567 */		fdtos	%f44,%f1
/* 0x04a4	     */		st	%f1,[%i1]
/* 0x04a8	 566 */		add	%i3,4,%i3
/* 0x04ac	     */		add	%i1,4,%i1
/* 0x04b0	     */		ble,a,pt	%icc,.L900000810
/* 0x04b4	 567 */		ld	[%i3],%f9

! Registers live out of .L900000811: 
! sp l1 i0 i1 i3 fp i7 gsr 
! f9 f28 f30 
		                       
! predecessor blocks: .L900000811

			.L77003717:
/* 0x04b8	 557 */		ret	! Result = 
/* 0x04bc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003642

			.L77003887:
/* 0x04c0	 566 */		or	%g0,0,%l6

! Registers live out of .L77003887: 
! sp l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003720 .L77003887

			.L77003825:
/* 0x04c4	 566 */		sethi	%hi(0xb400),%l1
/* 0x04c8	 567 */		sll	%l6,2,%l7
/* 0x04cc	 566 */		ldd	[%i4+40],%f34
/* 0x04d0	     */		fzero	%f36
/* 0x04d4	     */		add	%l1,640,%i4

! Registers live out of .L77003825: 
! sp l6 l7 i0 i2 i3 i4 fp i7 gsr 
! f2 f4 
		                       
! predecessor blocks: .L77003825 .L900000807

			.L900000806:
/* 0x04d8	 567 */		ld	[%l7+%i3],%f31
/* 0x04dc	     */		fstod	%f31,%f48
/* 0x04e0	     */		fcmped	%fcc3,%f48,%f36
/* 0x04e4	     */		fbuge,a,pn	%fcc3,.L900000808
/* 0x04e8	     */		fcmped	%fcc0,%f34,%f48

! Registers live out of .L900000806: 
! sp l6 l7 i0 i2 i3 i4 fp i7 gsr 
! f2 f4 f16 
		                       
! predecessor blocks: .L900000806

			.L77003714:
/* 0x04ec	 567 */		fmovd	%f36,%f48
/* 0x04f0	     */		ba	.L900000807
/* 0x04f4	 566 */		add	%l6,1,%l6

! Registers live out of .L77003714: 
! sp l6 l7 i0 i2 i3 i4 fp i7 gsr 
! f2 f4 f16 
		                       
! predecessor blocks: .L900000806

			.L900000808:
/* 0x04f8	 567 */		fmovdl	%fcc0,%f34,%f48
/* 0x04fc	 566 */		add	%l6,1,%l6

! Registers live out of .L900000808: 
! sp l6 l7 i0 i2 i3 i4 fp i7 gsr 
! f2 f4 f16 
		                       
! predecessor blocks: .L77003714 .L900000808

			.L900000807:
/* 0x0500	 567 */		add	%l7,%i0,%i1
/* 0x0504	 566 */		cmp	%l6,%i2
/* 0x0508	 567 */		fdtos	%f48,%f29
/* 0x050c	     */		st	%f29,[%i1+%i4]
/* 0x0510	 566 */		bcs,pt	%icc,.L900000806
/* 0x0514	 567 */		sll	%l6,2,%l7

! Registers live out of .L900000807: 
! sp l6 l7 i0 i2 i3 i4 fp i7 gsr 
! f2 f4 
		                       
! predecessor blocks: .L900000807

			.L900000740:
/* 0x0518	 557 */		ret	! Result = 
/* 0x051c	     */		restore	%g0,0,%g0

!  568		      !	 }
!  569		      !	 break;
!  570		      !      case GL_PIXEL_MAP_I_TO_G:
!  571		      !         ctx->Pixel.MapItoGsize = mapsize;
!  572		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003452:
/* 0x0520	 572 */		cmp	%i2,0
/* 0x0524	 571 */		add	%l1,612,%l4
/* 0x0528	 572 */		bleu,pn	%icc,.L77003611
/* 0x052c	 571 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003452: 
! sp o7 l7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003452

			.L77003641:
/* 0x0530	 572 */		cmp	%i2,4
/* 0x0534	     */		bl,pn	%icc,.L77003889
/* 0x0538	     */		add	%o7,1022,%o1

! Registers live out of .L77003641: 
! o1 sp l7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003641

			.L77003709:
/* 0x053c	 572 */		sethi	%hi(0xb800),%l5
/* 0x0540	     */		add	%l5,640,%o4
/* 0x0544	     */		add	%i0,%o4,%i1
/* 0x0548	     */		sub	%i1,%i3,%l4
/* 0x054c	     */		sra	%l4,31,%o2
/* 0x0550	     */		xor	%l4,%o2,%o3
/* 0x0554	     */		sub	%o3,%o2,%i5
/* 0x0558	     */		sll	%i2,2,%l3
/* 0x055c	     */		sra	%l3,0,%o0
/* 0x0560	     */		sra	%i5,0,%g5
/* 0x0564	     */		srl	%i2,0,%g3
/* 0x0568	     */		sub	%g5,%o0,%g4
/* 0x056c	     */		sub	%g3,%o1,%g2
/* 0x0570	     */		srlx	%g4,63,%l2
/* 0x0574	     */		srlx	%g2,63,%l1
/* 0x0578	     */		xor	%l2,1,%l0
/* 0x057c	     */		and	%l1,1,%g1
/* 0x0580	     */		andcc	%g1,%l0,%g0
/* 0x0584	     */		be,a,pn	%icc,.L77003823
/* 0x0588	     */		or	%g0,0,%l7

! Registers live out of .L77003709: 
! sp l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003709

			.L77003804:
/* 0x058c	 572 */		ldd	[%i4+40],%f54
/* 0x0590	     */		add	%i2,-1,%i2
/* 0x0594	     */		fzero	%f56

!  573		      !	    ctx->Pixel.MapItoG[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0598	 573 */		ld	[%i3],%f7
/* 0x059c	 572 */		or	%g0,0,%o7

! Registers live out of .L77003804: 
! sp o7 i1 i2 i3 fp i7 gsr 
! f7 f22 f24 
		                       
! predecessor blocks: .L77003804 .L900000804

			.L900000803:
/* 0x05a0	 573 */		fstod	%f7,%f42
/* 0x05a4	     */		fcmped	%fcc1,%f42,%f56
/* 0x05a8	     */		fbuge,a,pn	%fcc1,.L900000805
/* 0x05ac	     */		fcmped	%fcc2,%f54,%f42

! Registers live out of .L900000803: 
! sp o7 i1 i2 i3 fp i7 gsr 
! f7 f10 f22 f24 
		                       
! predecessor blocks: .L900000803

			.L77003458:
/* 0x05b0	 573 */		fmovd	%f56,%f42
/* 0x05b4	     */		ba	.L900000804
/* 0x05b8	 572 */		add	%o7,1,%o7

! Registers live out of .L77003458: 
! sp o7 i1 i2 i3 fp i7 gsr 
! f7 f10 f22 f24 
		                       
! predecessor blocks: .L900000803

			.L900000805:
/* 0x05bc	 573 */		fmovdl	%fcc2,%f54,%f42
/* 0x05c0	 572 */		add	%o7,1,%o7

! Registers live out of .L900000805: 
! sp o7 i1 i2 i3 fp i7 gsr 
! f7 f10 f22 f24 
		                       
! predecessor blocks: .L77003458 .L900000805

			.L900000804:
/* 0x05c4	 572 */		cmp	%o7,%i2
/* 0x05c8	 573 */		fdtos	%f42,%f3
/* 0x05cc	     */		st	%f3,[%i1]
/* 0x05d0	 572 */		add	%i3,4,%i3
/* 0x05d4	     */		add	%i1,4,%i1
/* 0x05d8	     */		ble,a,pt	%icc,.L900000803
/* 0x05dc	 573 */		ld	[%i3],%f7

! Registers live out of .L900000804: 
! sp o7 i1 i2 i3 fp i7 gsr 
! f7 f22 f24 
		                       
! predecessor blocks: .L900000804

			.L77003706:
/* 0x05e0	 557 */		ret	! Result = 
/* 0x05e4	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003641

			.L77003889:
/* 0x05e8	 572 */		or	%g0,0,%l7

! Registers live out of .L77003889: 
! sp l7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003709 .L77003889

			.L77003823:
/* 0x05ec	 572 */		sethi	%hi(0xb800),%l0
/* 0x05f0	     */		add	%l0,640,%o5
/* 0x05f4	     */		fzero	%f40
/* 0x05f8	     */		ldd	[%i4+40],%f38
/* 0x05fc	 573 */		sll	%l7,2,%i1

! Registers live out of .L77003823: 
! o5 sp l7 i0 i1 i2 i3 fp i7 gsr 
! f6 f8 
		                       
! predecessor blocks: .L77003823 .L900000800

			.L900000799:
/* 0x0600	 573 */		ld	[%i1+%i3],%f6
/* 0x0604	     */		fstod	%f6,%f50
/* 0x0608	     */		fcmped	%fcc1,%f50,%f40
/* 0x060c	     */		fbuge,a,pn	%fcc1,.L900000801
/* 0x0610	     */		fcmped	%fcc2,%f38,%f50

! Registers live out of .L900000799: 
! o5 sp l7 i0 i1 i2 i3 fp i7 gsr 
! f6 f8 f18 
		                       
! predecessor blocks: .L900000799

			.L77003703:
/* 0x0614	 573 */		fmovd	%f40,%f50
/* 0x0618	     */		ba	.L900000800
/* 0x061c	 572 */		add	%l7,1,%l7

! Registers live out of .L77003703: 
! o5 sp l7 i0 i1 i2 i3 fp i7 gsr 
! f6 f8 f18 
		                       
! predecessor blocks: .L900000799

			.L900000801:
/* 0x0620	 573 */		fmovdl	%fcc2,%f38,%f50
/* 0x0624	 572 */		add	%l7,1,%l7

! Registers live out of .L900000801: 
! o5 sp l7 i0 i1 i2 i3 fp i7 gsr 
! f6 f8 f18 
		                       
! predecessor blocks: .L77003703 .L900000801

			.L900000800:
/* 0x0628	 573 */		add	%i1,%i0,%o7
/* 0x062c	 572 */		cmp	%l7,%i2
/* 0x0630	 573 */		fdtos	%f50,%f0
/* 0x0634	     */		st	%f0,[%o7+%o5]
/* 0x0638	 572 */		bcs,pt	%icc,.L900000799
/* 0x063c	 573 */		sll	%l7,2,%i1

! Registers live out of .L900000800: 
! o5 sp l7 i0 i1 i2 i3 fp i7 gsr 
! f6 f8 
		                       
! predecessor blocks: .L900000800

			.L900000739:
/* 0x0640	 557 */		ret	! Result = 
/* 0x0644	     */		restore	%g0,0,%g0

!  574		      !	 }
!  575		      !	 break;
!  576		      !      case GL_PIXEL_MAP_I_TO_B:
!  577		      !         ctx->Pixel.MapItoBsize = mapsize;
!  578		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003474:
/* 0x0648	 578 */		cmp	%i2,0
/* 0x064c	 577 */		add	%l1,616,%l1
/* 0x0650	 578 */		bleu,pn	%icc,.L77003611
/* 0x0654	 577 */		st	%i2,[%i0+%l1]

! Registers live out of .L77003474: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003474

			.L77003640:
/* 0x0658	 578 */		cmp	%i2,4
/* 0x065c	     */		bl,pn	%icc,.L77003891
/* 0x0660	     */		add	%o7,1022,%o1

! Registers live out of .L77003640: 
! o1 o5 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003640

			.L77003698:
/* 0x0664	 578 */		sethi	%hi(0xbc00),%l6
/* 0x0668	     */		add	%l6,640,%l5
/* 0x066c	     */		add	%i0,%l5,%l7
/* 0x0670	     */		sub	%l7,%i3,%o4
/* 0x0674	     */		sra	%o4,31,%o3
/* 0x0678	     */		xor	%o4,%o3,%l4
/* 0x067c	     */		sub	%l4,%o3,%l3
/* 0x0680	     */		sll	%i2,2,%o2
/* 0x0684	     */		sra	%o2,0,%o0
/* 0x0688	     */		sra	%l3,0,%g5
/* 0x068c	     */		srl	%i2,0,%g3
/* 0x0690	     */		sub	%g5,%o0,%g4
/* 0x0694	     */		sub	%g3,%o1,%g2
/* 0x0698	     */		srlx	%g4,63,%i5
/* 0x069c	     */		srlx	%g2,63,%l2
/* 0x06a0	     */		xor	%i5,1,%l1
/* 0x06a4	     */		and	%l2,1,%l0
/* 0x06a8	     */		andcc	%l0,%l1,%g0
/* 0x06ac	     */		be,a,pn	%icc,.L77003821
/* 0x06b0	     */		or	%g0,0,%o5

! Registers live out of .L77003698: 
! o5 sp l7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003698

			.L77003802:
/* 0x06b4	 578 */		ldd	[%i4+40],%f50
/* 0x06b8	     */		add	%i2,-1,%i0
/* 0x06bc	     */		fzero	%f52

!  579		      !	    ctx->Pixel.MapItoB[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x06c0	 579 */		ld	[%i3],%f3
/* 0x06c4	 578 */		or	%g0,0,%l4

! Registers live out of .L77003802: 
! sp l4 l7 i0 i3 fp i7 gsr 
! f3 f18 f20 
		                       
! predecessor blocks: .L77003802 .L900000797

			.L900000796:
/* 0x06c8	 579 */		fstod	%f3,%f40
/* 0x06cc	     */		fcmped	%fcc3,%f40,%f52
/* 0x06d0	     */		fbuge,a,pn	%fcc3,.L900000798
/* 0x06d4	     */		fcmped	%fcc0,%f50,%f40

! Registers live out of .L900000796: 
! sp l4 l7 i0 i3 fp i7 gsr 
! f3 f8 f18 f20 
		                       
! predecessor blocks: .L900000796

			.L77003480:
/* 0x06d8	 579 */		fmovd	%f52,%f40
/* 0x06dc	     */		ba	.L900000797
/* 0x06e0	 578 */		add	%l4,1,%l4

! Registers live out of .L77003480: 
! sp l4 l7 i0 i3 fp i7 gsr 
! f3 f8 f18 f20 
		                       
! predecessor blocks: .L900000796

			.L900000798:
/* 0x06e4	 579 */		fmovdl	%fcc0,%f50,%f40
/* 0x06e8	 578 */		add	%l4,1,%l4

! Registers live out of .L900000798: 
! sp l4 l7 i0 i3 fp i7 gsr 
! f3 f8 f18 f20 
		                       
! predecessor blocks: .L77003480 .L900000798

			.L900000797:
/* 0x06ec	 578 */		cmp	%l4,%i0
/* 0x06f0	 579 */		fdtos	%f40,%f7
/* 0x06f4	     */		st	%f7,[%l7]
/* 0x06f8	 578 */		add	%i3,4,%i3
/* 0x06fc	     */		add	%l7,4,%l7
/* 0x0700	     */		ble,a,pt	%icc,.L900000796
/* 0x0704	 579 */		ld	[%i3],%f3

! Registers live out of .L900000797: 
! sp l4 l7 i0 i3 fp i7 gsr 
! f3 f18 f20 
		                       
! predecessor blocks: .L900000797

			.L77003695:
/* 0x0708	 557 */		ret	! Result = 
/* 0x070c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003640

			.L77003891:
/* 0x0710	 578 */		or	%g0,0,%o5

! Registers live out of .L77003891: 
! o5 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003698 .L77003891

			.L77003821:
/* 0x0714	 578 */		sethi	%hi(0xbc00),%o7
/* 0x0718	     */		ldd	[%i4+40],%f42
/* 0x071c	     */		add	%o7,640,%i4
/* 0x0720	     */		fzero	%f44
/* 0x0724	 579 */		sll	%o5,2,%o7

! Registers live out of .L77003821: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L77003821 .L900000793

			.L900000792:
/* 0x0728	 579 */		ld	[%o7+%i3],%f8
/* 0x072c	     */		fstod	%f8,%f52
/* 0x0730	     */		fcmped	%fcc3,%f52,%f44
/* 0x0734	     */		fbuge,a,pn	%fcc3,.L900000794
/* 0x0738	     */		fcmped	%fcc0,%f42,%f52

! Registers live out of .L900000792: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! f10 f12 f20 
		                       
! predecessor blocks: .L900000792

			.L77003692:
/* 0x073c	 579 */		fmovd	%f44,%f52
/* 0x0740	     */		ba	.L900000793
/* 0x0744	 578 */		add	%o5,1,%o5

! Registers live out of .L77003692: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! f10 f12 f20 
		                       
! predecessor blocks: .L900000792

			.L900000794:
/* 0x0748	 579 */		fmovdl	%fcc0,%f42,%f52
/* 0x074c	 578 */		add	%o5,1,%o5

! Registers live out of .L900000794: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! f10 f12 f20 
		                       
! predecessor blocks: .L77003692 .L900000794

			.L900000793:
/* 0x0750	 579 */		add	%o7,%i0,%g1
/* 0x0754	 578 */		cmp	%o5,%i2
/* 0x0758	 579 */		fdtos	%f52,%f2
/* 0x075c	     */		st	%f2,[%g1+%i4]
/* 0x0760	 578 */		bcs,pt	%icc,.L900000792
/* 0x0764	 579 */		sll	%o5,2,%o7

! Registers live out of .L900000793: 
! o5 sp o7 i0 i2 i3 i4 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L900000793

			.L900000738:
/* 0x0768	 557 */		ret	! Result = 
/* 0x076c	     */		restore	%g0,0,%g0

!  580		      !	 }
!  581		      !	 break;
!  582		      !      case GL_PIXEL_MAP_I_TO_A:
!  583		      !         ctx->Pixel.MapItoAsize = mapsize;
!  584		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003496:
/* 0x0770	 584 */		cmp	%i2,0
/* 0x0774	 583 */		add	%l1,620,%l1
/* 0x0778	 584 */		bleu,pn	%icc,.L77003611
/* 0x077c	 583 */		st	%i2,[%i0+%l1]

! Registers live out of .L77003496: 
! sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003496

			.L77003639:
/* 0x0780	 584 */		cmp	%i2,4
/* 0x0784	     */		bl,pn	%icc,.L77003893
/* 0x0788	     */		add	%o7,1022,%o2

! Registers live out of .L77003639: 
! o2 sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003639

			.L77003687:
/* 0x078c	 584 */		sethi	%hi(0xc000),%i1
/* 0x0790	     */		add	%i1,640,%l7
/* 0x0794	     */		add	%i0,%l7,%l6
/* 0x0798	     */		sub	%l6,%i3,%l5
/* 0x079c	     */		sra	%l5,31,%l4
/* 0x07a0	     */		xor	%l5,%l4,%o4
/* 0x07a4	     */		sub	%o4,%l4,%o1
/* 0x07a8	     */		sll	%i2,2,%o3
/* 0x07ac	     */		sra	%o3,0,%o0
/* 0x07b0	     */		sra	%o1,0,%g5
/* 0x07b4	     */		srl	%i2,0,%g3
/* 0x07b8	     */		sub	%g5,%o0,%g4
/* 0x07bc	     */		sub	%g3,%o2,%g2
/* 0x07c0	     */		srlx	%g4,63,%l3
/* 0x07c4	     */		srlx	%g2,63,%i5
/* 0x07c8	     */		xor	%l3,1,%l2
/* 0x07cc	     */		and	%i5,1,%l1
/* 0x07d0	     */		andcc	%l1,%l2,%g0
/* 0x07d4	     */		be,a,pn	%icc,.L77003819
/* 0x07d8	     */		or	%g0,0,%o7

! Registers live out of .L77003687: 
! sp o7 l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003687

			.L77003800:
/* 0x07dc	 584 */		ldd	[%i4+40],%f46
/* 0x07e0	     */		add	%i2,-1,%i2
/* 0x07e4	     */		fzero	%f48

!  585		      !	    ctx->Pixel.MapItoA[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x07e8	 585 */		ld	[%i3],%f1
/* 0x07ec	 584 */		or	%g0,0,%i0

! Registers live out of .L77003800: 
! sp l6 i0 i2 i3 fp i7 gsr 
! f1 f14 f16 
		                       
! predecessor blocks: .L77003800 .L900000790

			.L900000789:
/* 0x07f0	 585 */		fstod	%f1,%f38
/* 0x07f4	     */		fcmped	%fcc1,%f38,%f48
/* 0x07f8	     */		fbuge,a,pn	%fcc1,.L900000791
/* 0x07fc	     */		fcmped	%fcc2,%f46,%f38

! Registers live out of .L900000789: 
! sp l6 i0 i2 i3 fp i7 gsr 
! f1 f6 f14 f16 
		                       
! predecessor blocks: .L900000789

			.L77003502:
/* 0x0800	 585 */		fmovd	%f48,%f38
/* 0x0804	     */		ba	.L900000790
/* 0x0808	 584 */		add	%i0,1,%i0

! Registers live out of .L77003502: 
! sp l6 i0 i2 i3 fp i7 gsr 
! f1 f6 f14 f16 
		                       
! predecessor blocks: .L900000789

			.L900000791:
/* 0x080c	 585 */		fmovdl	%fcc2,%f46,%f38
/* 0x0810	 584 */		add	%i0,1,%i0

! Registers live out of .L900000791: 
! sp l6 i0 i2 i3 fp i7 gsr 
! f1 f6 f14 f16 
		                       
! predecessor blocks: .L77003502 .L900000791

			.L900000790:
/* 0x0814	 584 */		cmp	%i0,%i2
/* 0x0818	 585 */		fdtos	%f38,%f9
/* 0x081c	     */		st	%f9,[%l6]
/* 0x0820	 584 */		add	%i3,4,%i3
/* 0x0824	     */		add	%l6,4,%l6
/* 0x0828	     */		ble,a,pt	%icc,.L900000789
/* 0x082c	 585 */		ld	[%i3],%f1

! Registers live out of .L900000790: 
! sp l6 i0 i2 i3 fp i7 gsr 
! f1 f14 f16 
		                       
! predecessor blocks: .L900000790

			.L77003684:
/* 0x0830	 557 */		ret	! Result = 
/* 0x0834	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003639

			.L77003893:
/* 0x0838	 584 */		or	%g0,0,%o7

! Registers live out of .L77003893: 
! sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003687 .L77003893

			.L77003819:
/* 0x083c	 584 */		sethi	%hi(0xc000),%o5
/* 0x0840	     */		add	%o5,640,%l0
/* 0x0844	     */		fzero	%f48
/* 0x0848	     */		ldd	[%i4+40],%f46
/* 0x084c	 585 */		sll	%o7,2,%g1

! Registers live out of .L77003819: 
! g1 sp o7 l0 i0 i2 i3 fp i7 gsr 
! f14 f16 
		                       
! predecessor blocks: .L77003819 .L900000786

			.L900000785:
/* 0x0850	 585 */		ld	[%g1+%i3],%f10
/* 0x0854	     */		fstod	%f10,%f54
/* 0x0858	     */		fcmped	%fcc1,%f54,%f48
/* 0x085c	     */		fbuge,a,pn	%fcc1,.L900000787
/* 0x0860	     */		fcmped	%fcc2,%f46,%f54

! Registers live out of .L900000785: 
! g1 sp o7 l0 i0 i2 i3 fp i7 gsr 
! f14 f16 f22 
		                       
! predecessor blocks: .L900000785

			.L77003681:
/* 0x0864	 585 */		fmovd	%f48,%f54
/* 0x0868	     */		ba	.L900000786
/* 0x086c	 584 */		add	%o7,1,%o7

! Registers live out of .L77003681: 
! g1 sp o7 l0 i0 i2 i3 fp i7 gsr 
! f14 f16 f22 
		                       
! predecessor blocks: .L900000785

			.L900000787:
/* 0x0870	 585 */		fmovdl	%fcc2,%f46,%f54
/* 0x0874	 584 */		add	%o7,1,%o7

! Registers live out of .L900000787: 
! g1 sp o7 l0 i0 i2 i3 fp i7 gsr 
! f14 f16 f22 
		                       
! predecessor blocks: .L77003681 .L900000787

			.L900000786:
/* 0x0878	 585 */		add	%g1,%i0,%l6
/* 0x087c	 584 */		cmp	%o7,%i2
/* 0x0880	 585 */		fdtos	%f54,%f4
/* 0x0884	     */		st	%f4,[%l6+%l0]
/* 0x0888	 584 */		bcs,pt	%icc,.L900000785
/* 0x088c	 585 */		sll	%o7,2,%g1

! Registers live out of .L900000786: 
! g1 sp o7 l0 i0 i2 i3 fp i7 gsr 
! f14 f16 
		                       
! predecessor blocks: .L900000786

			.L900000737:
/* 0x0890	 557 */		ret	! Result = 
/* 0x0894	     */		restore	%g0,0,%g0

!  586		      !	 }
!  587		      !	 break;
!  588		      !      case GL_PIXEL_MAP_R_TO_R:
!  589		      !         ctx->Pixel.MapRtoRsize = mapsize;
!  590		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003518:
/* 0x0898	 590 */		cmp	%i2,0
/* 0x089c	 589 */		add	%l1,624,%l4
/* 0x08a0	 590 */		bleu,pn	%icc,.L77003611
/* 0x08a4	 589 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003518: 
! sp o7 l0 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003518

			.L77003638:
/* 0x08a8	 590 */		cmp	%i2,4
/* 0x08ac	     */		bl,pn	%icc,.L77003895
/* 0x08b0	     */		add	%o7,1022,%o2

! Registers live out of .L77003638: 
! o2 sp l0 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003638

			.L77003676:
/* 0x08b4	 590 */		sethi	%hi(0xc400),%o5
/* 0x08b8	     */		add	%o5,640,%i1
/* 0x08bc	     */		add	%i0,%i1,%l5
/* 0x08c0	     */		sub	%l5,%i3,%l7
/* 0x08c4	     */		sra	%l7,31,%l4
/* 0x08c8	     */		xor	%l7,%l4,%o4
/* 0x08cc	     */		sub	%o4,%l4,%o1
/* 0x08d0	     */		sll	%i2,2,%o3
/* 0x08d4	     */		sra	%o3,0,%o0
/* 0x08d8	     */		sra	%o1,0,%g5
/* 0x08dc	     */		srl	%i2,0,%g3
/* 0x08e0	     */		sub	%g5,%o0,%g4
/* 0x08e4	     */		sub	%g3,%o2,%g2
/* 0x08e8	     */		srlx	%g4,63,%l3
/* 0x08ec	     */		srlx	%g2,63,%i5
/* 0x08f0	     */		xor	%l3,1,%l2
/* 0x08f4	     */		and	%i5,1,%l1
/* 0x08f8	     */		andcc	%l1,%l2,%g0
/* 0x08fc	     */		be,a,pn	%icc,.L77003817
/* 0x0900	     */		or	%g0,0,%l0

! Registers live out of .L77003676: 
! sp l0 l5 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003676

			.L77003798:
/* 0x0904	 590 */		ldd	[%i4+40],%f42
/* 0x0908	     */		add	%i2,-1,%l1
/* 0x090c	     */		fzero	%f44

!  591		      !	    ctx->Pixel.MapRtoR[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0910	 591 */		ld	[%i3],%f30
/* 0x0914	 590 */		or	%g0,0,%i0

! Registers live out of .L77003798: 
! sp l1 l5 i0 i3 fp i7 gsr 
! f10 f12 f30 
		                       
! predecessor blocks: .L77003798 .L900000783

			.L900000782:
/* 0x0918	 591 */		fstod	%f30,%f36
/* 0x091c	     */		fcmped	%fcc3,%f36,%f44
/* 0x0920	     */		fbuge,a,pn	%fcc3,.L900000784
/* 0x0924	     */		fcmped	%fcc0,%f42,%f36

! Registers live out of .L900000782: 
! sp l1 l5 i0 i3 fp i7 gsr 
! f4 f10 f12 f30 
		                       
! predecessor blocks: .L900000782

			.L77003524:
/* 0x0928	 591 */		fmovd	%f44,%f36
/* 0x092c	     */		ba	.L900000783
/* 0x0930	 590 */		add	%i0,1,%i0

! Registers live out of .L77003524: 
! sp l1 l5 i0 i3 fp i7 gsr 
! f4 f10 f12 f30 
		                       
! predecessor blocks: .L900000782

			.L900000784:
/* 0x0934	 591 */		fmovdl	%fcc0,%f42,%f36
/* 0x0938	 590 */		add	%i0,1,%i0

! Registers live out of .L900000784: 
! sp l1 l5 i0 i3 fp i7 gsr 
! f4 f10 f12 f30 
		                       
! predecessor blocks: .L77003524 .L900000784

			.L900000783:
/* 0x093c	 590 */		cmp	%i0,%l1
/* 0x0940	 591 */		fdtos	%f36,%f11
/* 0x0944	     */		st	%f11,[%l5]
/* 0x0948	 590 */		add	%i3,4,%i3
/* 0x094c	     */		add	%l5,4,%l5
/* 0x0950	     */		ble,a,pt	%icc,.L900000782
/* 0x0954	 591 */		ld	[%i3],%f30

! Registers live out of .L900000783: 
! sp l1 l5 i0 i3 fp i7 gsr 
! f10 f12 f30 
		                       
! predecessor blocks: .L900000783

			.L77003673:
/* 0x0958	 557 */		ret	! Result = 
/* 0x095c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003638

			.L77003895:
/* 0x0960	 590 */		or	%g0,0,%l0

! Registers live out of .L77003895: 
! sp l0 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003676 .L77003895

			.L77003817:
/* 0x0964	 590 */		sethi	%hi(0xc400),%o4
/* 0x0968	 591 */		sll	%l0,2,%l6
/* 0x096c	 590 */		ldd	[%i4+40],%f50
/* 0x0970	     */		fzero	%f52
/* 0x0974	     */		add	%o4,640,%i4

! Registers live out of .L77003817: 
! sp l0 l6 i0 i2 i3 i4 fp i7 gsr 
! f18 f20 
		                       
! predecessor blocks: .L77003817 .L900000779

			.L900000778:
/* 0x0978	 591 */		ld	[%l6+%i3],%f12
/* 0x097c	     */		fstod	%f12,%f56
/* 0x0980	     */		fcmped	%fcc3,%f56,%f52
/* 0x0984	     */		fbuge,a,pn	%fcc3,.L900000780
/* 0x0988	     */		fcmped	%fcc0,%f50,%f56

! Registers live out of .L900000778: 
! sp l0 l6 i0 i2 i3 i4 fp i7 gsr 
! f18 f20 f24 
		                       
! predecessor blocks: .L900000778

			.L77003670:
/* 0x098c	 591 */		fmovd	%f52,%f56
/* 0x0990	     */		ba	.L900000779
/* 0x0994	 590 */		add	%l0,1,%l0

! Registers live out of .L77003670: 
! sp l0 l6 i0 i2 i3 i4 fp i7 gsr 
! f18 f20 f24 
		                       
! predecessor blocks: .L900000778

			.L900000780:
/* 0x0998	 591 */		fmovdl	%fcc0,%f50,%f56
/* 0x099c	 590 */		add	%l0,1,%l0

! Registers live out of .L900000780: 
! sp l0 l6 i0 i2 i3 i4 fp i7 gsr 
! f18 f20 f24 
		                       
! predecessor blocks: .L77003670 .L900000780

			.L900000779:
/* 0x09a0	 591 */		add	%l6,%i0,%l5
/* 0x09a4	 590 */		cmp	%l0,%i2
/* 0x09a8	 591 */		fdtos	%f56,%f18
/* 0x09ac	     */		st	%f18,[%l5+%i4]
/* 0x09b0	 590 */		bcs,pt	%icc,.L900000778
/* 0x09b4	 591 */		sll	%l0,2,%l6

! Registers live out of .L900000779: 
! sp l0 l6 i0 i2 i3 i4 fp i7 gsr 
! f18 f20 
		                       
! predecessor blocks: .L900000779

			.L900000736:
/* 0x09b8	 557 */		ret	! Result = 
/* 0x09bc	     */		restore	%g0,0,%g0

!  592		      !	 }
!  593		      !	 break;
!  594		      !      case GL_PIXEL_MAP_G_TO_G:
!  595		      !         ctx->Pixel.MapGtoGsize = mapsize;
!  596		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003540:
/* 0x09c0	 596 */		cmp	%i2,0
/* 0x09c4	 595 */		add	%l1,628,%l4
/* 0x09c8	 596 */		bleu,pn	%icc,.L77003611
/* 0x09cc	 595 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003540: 
! sp o7 l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003540

			.L77003637:
/* 0x09d0	 596 */		cmp	%i2,4
/* 0x09d4	     */		bl,pn	%icc,.L77003897
/* 0x09d8	     */		add	%o7,1022,%g1

! Registers live out of .L77003637: 
! g1 sp l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003637

			.L77003665:
/* 0x09dc	 596 */		sethi	%hi(0xc800),%o7
/* 0x09e0	     */		add	%o7,640,%o5
/* 0x09e4	     */		add	%i0,%o5,%l4
/* 0x09e8	     */		sub	%l4,%i3,%i1
/* 0x09ec	     */		sra	%i1,31,%o4
/* 0x09f0	     */		xor	%i1,%o4,%l7
/* 0x09f4	     */		sub	%l7,%o4,%o2
/* 0x09f8	     */		sll	%i2,2,%o3
/* 0x09fc	     */		sra	%o3,0,%o1
/* 0x0a00	     */		sra	%o2,0,%o0
/* 0x0a04	     */		srl	%i2,0,%g3
/* 0x0a08	     */		sub	%o0,%o1,%g5
/* 0x0a0c	     */		sub	%g3,%g1,%g2
/* 0x0a10	     */		srlx	%g5,63,%g4
/* 0x0a14	     */		srlx	%g2,63,%l3
/* 0x0a18	     */		xor	%g4,1,%l2
/* 0x0a1c	     */		and	%l3,1,%i5
/* 0x0a20	     */		andcc	%i5,%l2,%g0
/* 0x0a24	     */		be,a,pn	%icc,.L77003815
/* 0x0a28	     */		or	%g0,0,%l6

! Registers live out of .L77003665: 
! sp l4 l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003665

			.L77003796:
/* 0x0a2c	 596 */		ldd	[%i4+40],%f32
/* 0x0a30	     */		add	%i2,-1,%i2
/* 0x0a34	     */		fzero	%f40

!  597		      !	    ctx->Pixel.MapGtoG[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0a38	 597 */		ld	[%i3],%f28
/* 0x0a3c	 596 */		or	%g0,0,%l1

! Registers live out of .L77003796: 
! sp l1 l4 i2 i3 fp i7 gsr y
! f0 f8 f28 
		                       
! predecessor blocks: .L77003796 .L900000776

			.L900000775:
/* 0x0a40	 597 */		fstod	%f28,%f34
/* 0x0a44	     */		fcmped	%fcc1,%f34,%f40
/* 0x0a48	     */		fbuge,a,pn	%fcc1,.L900000777
/* 0x0a4c	     */		fcmped	%fcc2,%f32,%f34

! Registers live out of .L900000775: 
! sp l1 l4 i2 i3 fp i7 gsr y
! f0 f2 f8 f28 
		                       
! predecessor blocks: .L900000775

			.L77003546:
/* 0x0a50	 597 */		fmovd	%f40,%f34
/* 0x0a54	     */		ba	.L900000776
/* 0x0a58	 596 */		add	%l1,1,%l1

! Registers live out of .L77003546: 
! sp l1 l4 i2 i3 fp i7 gsr y
! f0 f2 f8 f28 
		                       
! predecessor blocks: .L900000775

			.L900000777:
/* 0x0a5c	 597 */		fmovdl	%fcc2,%f32,%f34
/* 0x0a60	 596 */		add	%l1,1,%l1

! Registers live out of .L900000777: 
! sp l1 l4 i2 i3 fp i7 gsr y
! f0 f2 f8 f28 
		                       
! predecessor blocks: .L77003546 .L900000777

			.L900000776:
/* 0x0a64	 596 */		cmp	%l1,%i2
/* 0x0a68	 597 */		fdtos	%f34,%f13
/* 0x0a6c	     */		st	%f13,[%l4]
/* 0x0a70	 596 */		add	%i3,4,%i3
/* 0x0a74	     */		add	%l4,4,%l4
/* 0x0a78	     */		ble,a,pt	%icc,.L900000775
/* 0x0a7c	 597 */		ld	[%i3],%f28

! Registers live out of .L900000776: 
! sp l1 l4 i2 i3 fp i7 gsr y
! f0 f8 f28 
		                       
! predecessor blocks: .L900000776

			.L77003662:
/* 0x0a80	 557 */		ret	! Result = 
/* 0x0a84	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003637

			.L77003897:
/* 0x0a88	 596 */		or	%g0,0,%l6

! Registers live out of .L77003897: 
! sp l6 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003665 .L77003897

			.L77003815:
/* 0x0a8c	 596 */		sethi	%hi(0xc800),%o3
/* 0x0a90	     */		add	%o3,640,%l1
/* 0x0a94	     */		fzero	%f56
/* 0x0a98	     */		ldd	[%i4+40],%f54
/* 0x0a9c	 597 */		sll	%l6,2,%l5

! Registers live out of .L77003815: 
! sp l1 l5 l6 i0 i2 i3 fp i7 gsr 
! f22 f24 
		                       
! predecessor blocks: .L77003815 .L900000772

			.L900000771:
/* 0x0aa0	 597 */		ld	[%l5+%i3],%f16
/* 0x0aa4	     */		fstod	%f16,%f62
/* 0x0aa8	     */		fcmped	%fcc1,%f62,%f56
/* 0x0aac	     */		fbuge,a,pn	%fcc1,.L900000773
/* 0x0ab0	     */		fcmped	%fcc2,%f54,%f62

! Registers live out of .L900000771: 
! sp l1 l5 l6 i0 i2 i3 fp i7 gsr 
! f22 f24 f30 
		                       
! predecessor blocks: .L900000771

			.L77003659:
/* 0x0ab4	 597 */		fmovd	%f56,%f62
/* 0x0ab8	     */		ba	.L900000772
/* 0x0abc	 596 */		add	%l6,1,%l6

! Registers live out of .L77003659: 
! sp l1 l5 l6 i0 i2 i3 fp i7 gsr 
! f22 f24 f30 
		                       
! predecessor blocks: .L900000771

			.L900000773:
/* 0x0ac0	 597 */		fmovdl	%fcc2,%f54,%f62
/* 0x0ac4	 596 */		add	%l6,1,%l6

! Registers live out of .L900000773: 
! sp l1 l5 l6 i0 i2 i3 fp i7 gsr 
! f22 f24 f30 
		                       
! predecessor blocks: .L77003659 .L900000773

			.L900000772:
/* 0x0ac8	 597 */		add	%l5,%i0,%l4
/* 0x0acc	 596 */		cmp	%l6,%i2
/* 0x0ad0	 597 */		fdtos	%f62,%f20
/* 0x0ad4	     */		st	%f20,[%l4+%l1]
/* 0x0ad8	 596 */		bcs,pt	%icc,.L900000771
/* 0x0adc	 597 */		sll	%l6,2,%l5

! Registers live out of .L900000772: 
! sp l1 l5 l6 i0 i2 i3 fp i7 gsr 
! f22 f24 
		                       
! predecessor blocks: .L900000772

			.L900000735:
/* 0x0ae0	 557 */		ret	! Result = 
/* 0x0ae4	     */		restore	%g0,0,%g0

!  598		      !	 }
!  599		      !	 break;
!  600		      !      case GL_PIXEL_MAP_B_TO_B:
!  601		      !         ctx->Pixel.MapBtoBsize = mapsize;
!  602		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003562:
/* 0x0ae8	 602 */		cmp	%i2,0
/* 0x0aec	 601 */		add	%l1,632,%l4
/* 0x0af0	 602 */		bleu,pn	%icc,.L77003611
/* 0x0af4	 601 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003562: 
! sp o7 l1 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003562

			.L77003636:
/* 0x0af8	 602 */		cmp	%i2,4
/* 0x0afc	     */		bl,pn	%icc,.L77003899
/* 0x0b00	     */		add	%o7,1022,%o3

! Registers live out of .L77003636: 
! o3 sp l1 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003636

			.L77003654:
/* 0x0b04	 602 */		sethi	%hi(0xcc00),%l0
/* 0x0b08	     */		add	%l0,640,%o7
/* 0x0b0c	     */		add	%i0,%o7,%l3
/* 0x0b10	     */		sub	%l3,%i3,%o5
/* 0x0b14	     */		sra	%o5,31,%l7
/* 0x0b18	     */		xor	%o5,%l7,%i1
/* 0x0b1c	     */		sub	%i1,%l7,%g1
/* 0x0b20	     */		sll	%i2,2,%o4
/* 0x0b24	     */		sra	%o4,0,%o2
/* 0x0b28	     */		sra	%g1,0,%o1
/* 0x0b2c	     */		srl	%i2,0,%g4
/* 0x0b30	     */		sub	%o1,%o2,%o0
/* 0x0b34	     */		sub	%g4,%o3,%g3
/* 0x0b38	     */		srlx	%o0,63,%g5
/* 0x0b3c	     */		srlx	%g3,63,%g2
/* 0x0b40	     */		xor	%g5,1,%l2
/* 0x0b44	     */		and	%g2,1,%i5
/* 0x0b48	     */		andcc	%i5,%l2,%g0
/* 0x0b4c	     */		be,a,pn	%icc,.L77003813
/* 0x0b50	     */		or	%g0,0,%l1

! Registers live out of .L77003654: 
! sp l1 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003654

			.L77003794:
/* 0x0b54	 602 */		ldd	[%i4+40],%f36
/* 0x0b58	     */		add	%i2,-1,%i0
/* 0x0b5c	     */		fzero	%f38

!  603		      !	    ctx->Pixel.MapBtoB[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0b60	 603 */		ld	[%i3],%f26
/* 0x0b64	 602 */		or	%g0,0,%l1

! Registers live out of .L77003794: 
! sp l1 i0 i3 fp i7 gsr 
! f4 f6 f26 
		                       
! predecessor blocks: .L77003794 .L900000769

			.L900000768:
/* 0x0b68	 603 */		fstod	%f26,%f32
/* 0x0b6c	     */		fcmped	%fcc3,%f32,%f38
/* 0x0b70	     */		fbuge,a,pn	%fcc3,.L900000770
/* 0x0b74	     */		fcmped	%fcc0,%f36,%f32

! Registers live out of .L900000768: 
! sp l1 i0 i3 fp i7 gsr y
! f0 f4 f6 f26 
		                       
! predecessor blocks: .L900000768

			.L77003568:
/* 0x0b78	 603 */		fmovd	%f38,%f32
/* 0x0b7c	     */		ba	.L900000769
/* 0x0b80	 602 */		add	%l1,1,%l1

! Registers live out of .L77003568: 
! sp l1 i0 i3 fp i7 gsr y
! f0 f4 f6 f26 
		                       
! predecessor blocks: .L900000768

			.L900000770:
/* 0x0b84	 603 */		fmovdl	%fcc0,%f36,%f32
/* 0x0b88	 602 */		add	%l1,1,%l1

! Registers live out of .L900000770: 
! sp l1 i0 i3 fp i7 gsr y
! f0 f4 f6 f26 
		                       
! predecessor blocks: .L77003568 .L900000770

			.L900000769:
/* 0x0b8c	 602 */		cmp	%l1,%i0
/* 0x0b90	 603 */		fdtos	%f32,%f5
/* 0x0b94	     */		st	%f5,[%l3]
/* 0x0b98	 602 */		add	%i3,4,%i3
/* 0x0b9c	     */		add	%l3,4,%l3
/* 0x0ba0	     */		ble,a,pt	%icc,.L900000768
/* 0x0ba4	 603 */		ld	[%i3],%f26

! Registers live out of .L900000769: 
! sp l1 i0 i3 fp i7 gsr 
! f4 f6 f26 
		                       
! predecessor blocks: .L900000769

			.L77003651:
/* 0x0ba8	 557 */		ret	! Result = 
/* 0x0bac	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003636

			.L77003899:
/* 0x0bb0	 602 */		or	%g0,0,%l1

! Registers live out of .L77003899: 
! sp l1 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003654 .L77003899

			.L77003813:
/* 0x0bb4	 602 */		sethi	%hi(0xcc00),%o2
/* 0x0bb8	 603 */		sll	%l1,2,%l4
/* 0x0bbc	 602 */		ldd	[%i4+40],%f62
/* 0x0bc0	     */		fzero	%f60
/* 0x0bc4	     */		add	%o2,640,%i4

! Registers live out of .L77003813: 
! sp l1 l4 i0 i2 i3 i4 fp i7 gsr 
! f28 f30 
		                       
! predecessor blocks: .L77003813 .L900000765

			.L900000764:
/* 0x0bc8	 603 */		ld	[%l4+%i3],%f24
/* 0x0bcc	     */		fstod	%f24,%f32
/* 0x0bd0	     */		fcmped	%fcc3,%f32,%f60
/* 0x0bd4	     */		fbuge,a,pn	%fcc3,.L900000766
/* 0x0bd8	     */		fcmped	%fcc0,%f62,%f32

! Registers live out of .L900000764: 
! sp l1 l4 i0 i2 i3 i4 fp i7 gsr y
! f0 f28 f30 
		                       
! predecessor blocks: .L900000764

			.L77003648:
/* 0x0bdc	 603 */		fmovd	%f60,%f32
/* 0x0be0	     */		ba	.L900000765
/* 0x0be4	 602 */		add	%l1,1,%l1

! Registers live out of .L77003648: 
! sp l1 l4 i0 i2 i3 i4 fp i7 gsr y
! f0 f28 f30 
		                       
! predecessor blocks: .L900000764

			.L900000766:
/* 0x0be8	 603 */		fmovdl	%fcc0,%f62,%f32
/* 0x0bec	 602 */		add	%l1,1,%l1

! Registers live out of .L900000766: 
! sp l1 l4 i0 i2 i3 i4 fp i7 gsr y
! f0 f28 f30 
		                       
! predecessor blocks: .L77003648 .L900000766

			.L900000765:
/* 0x0bf0	 603 */		add	%l4,%i0,%l3
/* 0x0bf4	 602 */		cmp	%l1,%i2
/* 0x0bf8	 603 */		fdtos	%f32,%f22
/* 0x0bfc	     */		st	%f22,[%l3+%i4]
/* 0x0c00	 602 */		bcs,pt	%icc,.L900000764
/* 0x0c04	 603 */		sll	%l1,2,%l4

! Registers live out of .L900000765: 
! sp l1 l4 i0 i2 i3 i4 fp i7 gsr 
! f28 f30 
		                       
! predecessor blocks: .L900000765

			.L900000734:
/* 0x0c08	 557 */		ret	! Result = 
/* 0x0c0c	     */		restore	%g0,0,%g0

!  604		      !	 }
!  605		      !	 break;
!  606		      !      case GL_PIXEL_MAP_A_TO_A:
!  607		      !         ctx->Pixel.MapAtoAsize = mapsize;
!  608		      !         for (i=0;i<mapsize;i++) {

                       
! predecessor blocks: .L900000746

			.L77003584:
/* 0x0c10	 608 */		cmp	%i2,0
/* 0x0c14	 607 */		add	%l1,636,%l4
/* 0x0c18	 608 */		bleu,pn	%icc,.L77003611
/* 0x0c1c	 607 */		st	%i2,[%i0+%l4]

! Registers live out of .L77003584: 
! o1 sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003584

			.L77003646:
/* 0x0c20	 608 */		cmp	%i2,4
/* 0x0c24	     */		bl,pn	%icc,.L77003881
/* 0x0c28	     */		add	%o7,1022,%g1

! Registers live out of .L77003646: 
! g1 o1 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003646

			.L77003747:
/* 0x0c2c	 608 */		sethi	%hi(0xd000),%g5
/* 0x0c30	     */		add	%g5,640,%g4
/* 0x0c34	     */		add	%i0,%g4,%l2
/* 0x0c38	     */		sub	%l2,%i3,%g3
/* 0x0c3c	     */		sra	%g3,31,%l7
/* 0x0c40	     */		xor	%g3,%l7,%g2
/* 0x0c44	     */		sub	%g2,%l7,%l5
/* 0x0c48	     */		sll	%i2,2,%l6
/* 0x0c4c	     */		sra	%l6,0,%o7
/* 0x0c50	     */		sra	%l5,0,%o5
/* 0x0c54	     */		srl	%i2,0,%o3
/* 0x0c58	     */		sub	%o5,%o7,%o4
/* 0x0c5c	     */		sub	%o3,%g1,%o2
/* 0x0c60	     */		srlx	%o4,63,%l4
/* 0x0c64	     */		srlx	%o2,63,%i1
/* 0x0c68	     */		xor	%l4,1,%l3
/* 0x0c6c	     */		and	%i1,1,%i5
/* 0x0c70	     */		andcc	%i5,%l3,%g0
/* 0x0c74	     */		be,a,pn	%icc,.L77003846
/* 0x0c78	     */		or	%g0,0,%o1

! Registers live out of .L77003747: 
! o1 sp l2 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003747

			.L77003792:
/* 0x0c7c	 608 */		ldd	[%i4+40],%f34
/* 0x0c80	     */		add	%i2,-1,%i2
/* 0x0c84	     */		fzero	%f58

!  609		      !	    ctx->Pixel.MapAtoA[i] = CLAMP( values[i], 0.0, 1.0 );

/* 0x0c88	 609 */		ld	[%i3],%f14
/* 0x0c8c	 608 */		or	%g0,0,%i0

! Registers live out of .L77003792: 
! sp l2 i0 i2 i3 fp i7 gsr 
! f2 f14 f26 
		                       
! predecessor blocks: .L77003792 .L900000762

			.L900000761:
/* 0x0c90	 609 */		fstod	%f14,%f32
/* 0x0c94	     */		fcmped	%fcc1,%f32,%f58
/* 0x0c98	     */		fbuge,a,pn	%fcc1,.L900000763
/* 0x0c9c	     */		fcmped	%fcc2,%f34,%f32

! Registers live out of .L900000761: 
! sp l2 i0 i2 i3 fp i7 gsr y
! f0 f2 f14 f26 
		                       
! predecessor blocks: .L900000761

			.L77003590:
/* 0x0ca0	 609 */		fmovd	%f58,%f32
/* 0x0ca4	     */		ba	.L900000762
/* 0x0ca8	 608 */		add	%i0,1,%i0

! Registers live out of .L77003590: 
! sp l2 i0 i2 i3 fp i7 gsr y
! f0 f2 f14 f26 
		                       
! predecessor blocks: .L900000761

			.L900000763:
/* 0x0cac	 609 */		fmovdl	%fcc2,%f34,%f32
/* 0x0cb0	 608 */		add	%i0,1,%i0

! Registers live out of .L900000763: 
! sp l2 i0 i2 i3 fp i7 gsr y
! f0 f2 f14 f26 
		                       
! predecessor blocks: .L77003590 .L900000763

			.L900000762:
/* 0x0cb4	 608 */		cmp	%i0,%i2
/* 0x0cb8	 609 */		fdtos	%f32,%f15
/* 0x0cbc	     */		st	%f15,[%l2]
/* 0x0cc0	 608 */		add	%i3,4,%i3
/* 0x0cc4	     */		add	%l2,4,%l2
/* 0x0cc8	     */		ble,a,pt	%icc,.L900000761
/* 0x0ccc	 609 */		ld	[%i3],%f14

! Registers live out of .L900000762: 
! sp l2 i0 i2 i3 fp i7 gsr 
! f2 f14 f26 
		                       
! predecessor blocks: .L900000762

			.L77003744:
/* 0x0cd0	 557 */		ret	! Result = 
/* 0x0cd4	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77003646

			.L77003881:
/* 0x0cd8	 608 */		or	%g0,0,%o1

! Registers live out of .L77003881: 
! o1 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003747 .L77003881

			.L77003846:
/* 0x0cdc	 608 */		sethi	%hi(0xd000),%i1
/* 0x0ce0	     */		add	%i1,640,%l1
/* 0x0ce4	     */		fzero	%f58
/* 0x0ce8	     */		ldd	[%i4+40],%f60
/* 0x0cec	 609 */		sll	%o1,2,%l0

! Registers live out of .L77003846: 
! o1 sp l0 l1 i0 i2 i3 fp i7 gsr 
! f26 f28 
		                       
! predecessor blocks: .L77003846 .L900000758

			.L900000757:
/* 0x0cf0	 609 */		ld	[%l0+%i3],%f19
/* 0x0cf4	     */		fstod	%f19,%f46
/* 0x0cf8	     */		fcmped	%fcc1,%f46,%f58
/* 0x0cfc	     */		fbuge,a,pn	%fcc1,.L900000759
/* 0x0d00	     */		fcmped	%fcc2,%f60,%f46

! Registers live out of .L900000757: 
! o1 sp l0 l1 i0 i2 i3 fp i7 gsr 
! f14 f26 f28 
		                       
! predecessor blocks: .L900000757

			.L77003741:
/* 0x0d04	 609 */		fmovd	%f58,%f46
/* 0x0d08	     */		ba	.L900000758
/* 0x0d0c	 608 */		add	%o1,1,%o1

! Registers live out of .L77003741: 
! o1 sp l0 l1 i0 i2 i3 fp i7 gsr 
! f14 f26 f28 
		                       
! predecessor blocks: .L900000757

			.L900000759:
/* 0x0d10	 609 */		fmovdl	%fcc2,%f60,%f46
/* 0x0d14	 608 */		add	%o1,1,%o1

! Registers live out of .L900000759: 
! o1 sp l0 l1 i0 i2 i3 fp i7 gsr 
! f14 f26 f28 
		                       
! predecessor blocks: .L77003741 .L900000759

			.L900000758:
/* 0x0d18	 609 */		add	%l0,%i0,%l2
/* 0x0d1c	 608 */		cmp	%o1,%i2
/* 0x0d20	 609 */		fdtos	%f46,%f17
/* 0x0d24	     */		st	%f17,[%l2+%l1]
/* 0x0d28	 608 */		bcs,pt	%icc,.L900000757
/* 0x0d2c	 609 */		sll	%o1,2,%l0

! Registers live out of .L900000758: 
! o1 sp l0 l1 i0 i2 i3 fp i7 gsr 
! f26 f28 
		                       
! predecessor blocks: .L77003410 .L77003420 .L77003430 .L77003452 .L77003474 .L77003496 .L77003518 .L77003540 .L77003562 .L77003584
! predecessor blocks: .L900000758 .L900000813 .L900000816

			.L77003611:
/* 0x0d30	 557 */		ret	! Result = 
/* 0x0d34	     */		restore	%g0,0,%g0

!  610		      !	 }
!  611		      !	 break;
!  612		      !      default:
!  613		      !         gl_error( ctx, GL_INVALID_ENUM, "glPixelMapfv(map)" );

                       
! predecessor blocks: .L77003608 .L900000746

			.L77003606:
/* 0x0d38	 613 */		sethi	%hi(.L432),%i3
/* 0x0d3c	     */		add	%i3,%lo(.L432),%i2
/* 0x0d40	     */		or	%g0,1280,%i1
/* 0x0d44	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0d48	     */		restore	%g0,0,%g0
/* 0x0d4c	   0 */		.type	gl_PixelMapfv,2
/* 0x0d4c	   0 */		.size	gl_PixelMapfv,(.-gl_PixelMapfv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000901:
/* 000000	   0 */		.word	(.L77004003-(___const_seg_900000901+0x0))
/* 0x0004	     */		.word	(.L77004013-(___const_seg_900000901+0x0))
/* 0x0008	     */		.word	(.L77004023-(___const_seg_900000901+0x0))
/* 0x000c	     */		.word	(.L77004025-(___const_seg_900000901+0x0))
/* 0x0010	     */		.word	(.L77004027-(___const_seg_900000901+0x0))
/* 0x0014	     */		.word	(.L77004029-(___const_seg_900000901+0x0))
/* 0x0018	     */		.word	(.L77004031-(___const_seg_900000901+0x0))
/* 0x001c	     */		.word	(.L77004033-(___const_seg_900000901+0x0))
/* 0x0020	     */		.word	(.L77004035-(___const_seg_900000901+0x0))
/* 0x0024	     */		.word	(.L77004037-(___const_seg_900000901+0x0))
/* 0x0028	   0 */		.type	___const_seg_900000901,1
/* 0x0028	   0 */		.size	___const_seg_900000901,(.-___const_seg_900000901)
/* 0x0028	   0 */		.align	4

!  614		      !   }
!  615		      !}
!  621		      !void gl_GetPixelMapfv( GLcontext *ctx, GLenum map, GLfloat *values )
!  622		      !{

!
! SUBROUTINE gl_GetPixelMapfv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_GetPixelMapfv
                       

			gl_GetPixelMapfv:
/* 000000	 622 */		save	%sp,-96,%sp

!  623		      !   GLuint i;
!  625		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 625 */		sethi	%hi(0xe000),%l4
/* 0x0008	     */		add	%l4,252,%o0
/* 0x000c	     */		sethi	%hi(0x1800),%g5
/* 0x0010	     */		ld	[%i0+%o0],%l7
/* 0x0014	     */		add	%g5,512,%i3
/* 0x0018	     */		cmp	%l7,%i3
/* 0x001c	     */		be,pn	%icc,.L77004041
/* 0x0020	 626 */		sethi	%hi(.L441),%l7

! Registers live out of gl_GetPixelMapfv: 
! sp l0 l7 i0 i1 i2 fp i7 gsr 
! 
		
!  626		      !      gl_error( ctx, GL_INVALID_OPERATION, "glGetPixelMapfv" );

                       
! predecessor blocks: gl_GetPixelMapfv

			.L77003999:
/* 0x0024	 626 */		add	%l7,%lo(.L441),%i2
/* 0x0028	     */		or	%g0,1282,%i1
/* 0x002c	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0030	     */		restore	%g0,0,%g0

!  627		      !      return;
!  628		      !   }
!  629		      !   switch (map) {

                       
! predecessor blocks: gl_GetPixelMapfv

			.L77004041:
/* 0x0034	 629 */		sub	%i1,3184,%l5
/* 0x0038	     */		cmp	%l5,9
/* 0x003c	     */		bgu,pn	%icc,.L77004039
/* 0x0040	     */		sethi	%hi(___const_seg_900000901),%l4

! Registers live out of .L77004041: 
! sp l0 l4 l5 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004041

			.L900001054:
/* 0x0044	 629 */		add	%l4,%lo(___const_seg_900000901),%o0
/* 0x0048	     */		sll	%l5,2,%o2
/* 0x004c	 622 */		or	%g0,%i2,%l7
/* 0x0050	   0 */		sethi	%hi(0xac00),%o3
/* 0x0054	 629 */		ld	[%o2+%o0],%o1
/* 0x0058	     */		jmpl	%o1+%o0,%g0
/* 0x005c	     */		nop

! Registers live out of .L900001054: 
! o0 o1 o3 sp l0 l7 i0 i2 fp i7 gsr 
! 
		
!  630		      !      case GL_PIXEL_MAP_I_TO_I:
!  631		      !         for (i=0;i<ctx->Pixel.MapItoIsize;i++) {

                       
! predecessor blocks: .L900001054

			.L77004003:
/* 0x0060	 631 */		add	%o3,604,%l1
/* 0x0064	     */		ld	[%i0+%l1],%g2
/* 0x0068	     */		orcc	%g0,%g2,%g0
/* 0x006c	     */		bleu,pn	%icc,.L77004044
/* 0x0070	     */		cmp	%g2,2

! Registers live out of .L77004003: 
! g2 o1 sp l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004003

			.L77004050:
/* 0x0074	 631 */		bl,pn	%icc,.L77004098
/* 0x0078	     */		sethi	%hi(0x7ffffc00),%g3

! Registers live out of .L77004050: 
! g2 g3 o1 sp l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004050

			.L77004063:
/* 0x007c	 631 */		add	%g3,1022,%o2
/* 0x0080	     */		sub	%g2,%o2,%g1
/* 0x0084	     */		srlx	%g1,63,%i4
/* 0x0088	     */		andcc	%i4,1,%g0
/* 0x008c	     */		be,a,pn	%icc,.L77004088
/* 0x0090	     */		or	%g0,0,%o1

! Registers live out of .L77004063: 
! g2 o1 sp l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004063

			.L77004077:
/* 0x0094	 631 */		sethi	%hi(0xb000),%i2
/* 0x0098	     */		add	%i2,640,%l6

!  632		      !	    values[i] = (GLfloat) ctx->Pixel.MapItoI[i];

/* 0x009c	 632 */		cmp	%g2,12
/* 0x00a0	 631 */		add	%g2,-1,%g1
/* 0x00a4	     */		add	%i0,%l6,%i4
/* 0x00a8	     */		or	%g0,0,%o7
/* 0x00ac	     */		or	%g0,%l7,%i3
/* 0x00b0	 632 */		bl,pn	%icc,.L77004078
/* 0x00b4	     */		nop

! Registers live out of .L77004077: 
! g1 g2 sp o7 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004077

			.L900001093:
/* 0x00b8	 632 */		ld	[%i4],%f2
/* 0x00bc	     */		ld	[%i4+4],%f0
/* 0x00c0	     */		ld	[%i4+12],%f8
/* 0x00c4	     */		add	%g2,-8,%i5
/* 0x00c8	 631 */		or	%g0,4,%o7
/* 0x00cc	 632 */		ld	[%i4+8],%f6
/* 0x00d0	 631 */		add	%i4,16,%i4

! Registers live out of .L900001093: 
! g1 sp o7 i3 i4 i5 fp i7 gsr 
! f0 f2 f6 f8 
		                       
! predecessor blocks: .L900001091 .L900001093

			.L900001091:
/* 0x00d4	 632 */		prefetch	[%i4+144],0
/* 0x00d8	     */		prefetch	[%i3+144],2
/* 0x00dc	 631 */		add	%o7,8,%o7
/* 0x00e0	     */		add	%i3,32,%i3
/* 0x00e4	 632 */		ld	[%i4],%f11
/* 0x00e8	     */		fitos	%f2,%f30
/* 0x00ec	     */		st	%f30,[%i3-32]
/* 0x00f0	 631 */		cmp	%o7,%i5
/* 0x00f4	     */		add	%i4,32,%i4
/* 0x00f8	 632 */		fitos	%f0,%f1
/* 0x00fc	     */		ld	[%i4-28],%f5
/* 0x0100	     */		st	%f1,[%i3-28]
/* 0x0104	     */		fitos	%f6,%f3
/* 0x0108	     */		ld	[%i4-24],%f17
/* 0x010c	     */		st	%f3,[%i3-24]
/* 0x0110	     */		fitos	%f8,%f9
/* 0x0114	     */		ld	[%i4-20],%f7
/* 0x0118	     */		st	%f9,[%i3-20]
/* 0x011c	     */		fitos	%f11,%f13
/* 0x0120	     */		ld	[%i4-16],%f2
/* 0x0124	     */		st	%f13,[%i3-16]
/* 0x0128	     */		fitos	%f5,%f15
/* 0x012c	     */		ld	[%i4-12],%f0
/* 0x0130	     */		st	%f15,[%i3-12]
/* 0x0134	     */		fitos	%f17,%f19
/* 0x0138	     */		ld	[%i4-8],%f6
/* 0x013c	     */		st	%f19,[%i3-8]
/* 0x0140	     */		fitos	%f7,%f21
/* 0x0144	     */		ld	[%i4-4],%f8
/* 0x0148	 631 */		ble,pt	%icc,.L900001091
/* 0x014c	 632 */		st	%f21,[%i3-4]

! Registers live out of .L900001091: 
! g1 sp o7 i3 i4 i5 fp i7 gsr 
! f0 f2 f6 f8 
		                       
! predecessor blocks: .L900001091

			.L900001094:
/* 0x0150	 632 */		fitos	%f8,%f26
/* 0x0154	     */		fitos	%f6,%f24
/* 0x0158	     */		fitos	%f0,%f22
/* 0x015c	     */		fitos	%f2,%f28
/* 0x0160	 631 */		add	%i3,16,%i3
/* 0x0164	 632 */		st	%f28,[%i3-16]
/* 0x0168	     */		st	%f22,[%i3-12]
/* 0x016c	     */		st	%f24,[%i3-8]
/* 0x0170	 631 */		cmp	%o7,%g1
/* 0x0174	 632 */		st	%f26,[%i3-4]
/* 0x0178	 631 */		bg,pn	%icc,.L900001052
/* 0x017c	 632 */		nop

! Registers live out of .L900001094: 
! g1 sp o7 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004077 .L900001094

			.L77004078:
/* 0x0180	 631 */		add	%o7,1,%o7

! Registers live out of .L77004078: 
! g1 sp o7 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004078 .L900001150

			.L900001150:
/* 0x0184	 631 */		cmp	%o7,%g1
/* 0x0188	 632 */		ld	[%i4],%f11
/* 0x018c	 631 */		add	%i4,4,%i4
/* 0x0190	 632 */		fitos	%f11,%f13
/* 0x0194	     */		st	%f13,[%i3]
/* 0x0198	 631 */		add	%i3,4,%i3
/* 0x019c	     */		ble,pt	%icc,.L900001150
/* 0x01a0	     */		add	%o7,1,%o7

! Registers live out of .L900001150: 
! g1 sp o7 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001094 .L900001150

			.L900001052:
/* 0x01a4	 634 */		ret	! Result = 
/* 0x01a8	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004050

			.L77004098:
/* 0x01ac	 631 */		or	%g0,0,%o1

! Registers live out of .L77004098: 
! g2 o1 sp i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004063 .L77004098

			.L77004088:
/* 0x01b0	 631 */		sethi	%hi(0xb000),%g4
/* 0x01b4	     */		add	%g4,640,%i5
/* 0x01b8	 632 */		sll	%o1,2,%i3
/* 0x01bc	     */		add	%i0,%i5,%l3

! Registers live out of .L77004088: 
! g2 o1 sp i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004059 .L77004088

			.L900001148:
/* 0x01c0	 632 */		ld	[%l3+%i3],%f18
/* 0x01c4	 631 */		add	%o1,1,%o1
/* 0x01c8	     */		cmp	%o1,%g2
/* 0x01cc	 632 */		fitos	%f18,%f20
/* 0x01d0	 631 */		bcc,pn	%icc,.L77004044
/* 0x01d4	 632 */		st	%f20,[%i3+%i2]

! Registers live out of .L900001148: 
! g2 o1 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001148

			.L77004059:
/* 0x01d8	 632 */		sll	%o1,2,%i0
/* 0x01dc	     */		ld	[%l3+%i0],%f17
/* 0x01e0	 631 */		add	%o1,1,%o1
/* 0x01e4	     */		cmp	%o1,%g2
/* 0x01e8	 632 */		fitos	%f17,%f19
/* 0x01ec	     */		st	%f19,[%i0+%i2]
/* 0x01f0	 631 */		bcs,pt	%icc,.L900001148
/* 0x01f4	 632 */		sll	%o1,2,%i3

! Registers live out of .L77004059: 
! g2 o1 sp i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004059

			.L900001051:
/* 0x01f8	 634 */		ret	! Result = 
/* 0x01fc	     */		restore	%g0,0,%g0

!  633		      !	 }
!  634		      !	 break;
!  635		      !      case GL_PIXEL_MAP_S_TO_S:
!  636		      !         for (i=0;i<ctx->Pixel.MapStoSsize;i++) {

                       
! predecessor blocks: .L900001054

			.L77004013:
/* 0x0200	 636 */		add	%o3,600,%l2
/* 0x0204	     */		ld	[%i0+%l2],%o0
/* 0x0208	     */		orcc	%g0,%o0,%g0
/* 0x020c	     */		bleu,pn	%icc,.L77004044
/* 0x0210	     */		cmp	%o0,2

! Registers live out of .L77004013: 
! o0 o3 sp l0 l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004013

			.L77004049:
/* 0x0214	 636 */		bl,pn	%icc,.L77004100
/* 0x0218	     */		sethi	%hi(0x7ffffc00),%o7

! Registers live out of .L77004049: 
! o0 o3 sp o7 l0 l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004049

			.L77004055:
/* 0x021c	 636 */		add	%o7,1022,%o5
/* 0x0220	     */		sub	%o0,%o5,%o4
/* 0x0224	     */		srlx	%o4,63,%l2
/* 0x0228	     */		andcc	%l2,1,%g0
/* 0x022c	     */		be,a,pn	%icc,.L77004090
/* 0x0230	     */		or	%g0,0,%l0

! Registers live out of .L77004055: 
! o0 o3 sp l0 l7 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004055

			.L77004075:
/* 0x0234	 636 */		add	%o3,640,%l5

!  637		      !	    values[i] = (GLfloat) ctx->Pixel.MapStoS[i];

/* 0x0238	 637 */		cmp	%o0,12
/* 0x023c	 636 */		add	%o0,-1,%o5
/* 0x0240	     */		add	%i0,%l5,%i1
/* 0x0244	     */		or	%g0,0,%i2
/* 0x0248	 637 */		bl,pn	%icc,.L77004076
/* 0x024c	     */		nop

! Registers live out of .L77004075: 
! o0 o5 sp l7 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004075

			.L900001089:
/* 0x0250	 637 */		ld	[%i1],%f12
/* 0x0254	     */		ld	[%i1+4],%f0
/* 0x0258	     */		ld	[%i1+12],%f14
/* 0x025c	     */		add	%o0,-8,%i5
/* 0x0260	 636 */		or	%g0,4,%i2
/* 0x0264	 637 */		ld	[%i1+8],%f10
/* 0x0268	 636 */		add	%i1,16,%i1

! Registers live out of .L900001089: 
! o5 sp l7 i1 i2 i5 fp i7 gsr 
! f0 f10 f12 f14 
		                       
! predecessor blocks: .L900001087 .L900001089

			.L900001087:
/* 0x026c	 637 */		prefetch	[%i1+144],0
/* 0x0270	     */		prefetch	[%l7+144],2
/* 0x0274	 636 */		add	%i2,8,%i2
/* 0x0278	     */		add	%l7,32,%l7
/* 0x027c	 637 */		ld	[%i1],%f4
/* 0x0280	     */		fitos	%f12,%f31
/* 0x0284	     */		st	%f31,[%l7-32]
/* 0x0288	 636 */		cmp	%i2,%i5
/* 0x028c	     */		add	%i1,32,%i1
/* 0x0290	 637 */		fitos	%f0,%f6
/* 0x0294	     */		ld	[%i1-28],%f16
/* 0x0298	     */		st	%f6,[%l7-28]
/* 0x029c	     */		fitos	%f10,%f2
/* 0x02a0	     */		ld	[%i1-24],%f18
/* 0x02a4	     */		st	%f2,[%l7-24]
/* 0x02a8	     */		fitos	%f14,%f8
/* 0x02ac	     */		ld	[%i1-20],%f20
/* 0x02b0	     */		st	%f8,[%l7-20]
/* 0x02b4	     */		fitos	%f4,%f0
/* 0x02b8	     */		ld	[%i1-16],%f12
/* 0x02bc	     */		st	%f0,[%l7-16]
/* 0x02c0	     */		fitos	%f16,%f10
/* 0x02c4	     */		ld	[%i1-12],%f0
/* 0x02c8	     */		st	%f10,[%l7-12]
/* 0x02cc	     */		fitos	%f18,%f14
/* 0x02d0	     */		ld	[%i1-8],%f10
/* 0x02d4	     */		st	%f14,[%l7-8]
/* 0x02d8	     */		fitos	%f20,%f22
/* 0x02dc	     */		ld	[%i1-4],%f14
/* 0x02e0	 636 */		ble,pt	%icc,.L900001087
/* 0x02e4	 637 */		st	%f22,[%l7-4]

! Registers live out of .L900001087: 
! o5 sp l7 i1 i2 i5 fp i7 gsr 
! f0 f10 f12 f14 
		                       
! predecessor blocks: .L900001087

			.L900001090:
/* 0x02e8	 637 */		fitos	%f14,%f27
/* 0x02ec	     */		fitos	%f10,%f25
/* 0x02f0	     */		fitos	%f0,%f23
/* 0x02f4	     */		fitos	%f12,%f29
/* 0x02f8	 636 */		add	%l7,16,%l7
/* 0x02fc	 637 */		st	%f29,[%l7-16]
/* 0x0300	     */		st	%f23,[%l7-12]
/* 0x0304	     */		st	%f25,[%l7-8]
/* 0x0308	 636 */		cmp	%i2,%o5
/* 0x030c	 637 */		st	%f27,[%l7-4]
/* 0x0310	 636 */		bg,pn	%icc,.L900001050
/* 0x0314	 637 */		nop

! Registers live out of .L900001090: 
! o5 sp l7 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004075 .L900001090

			.L77004076:
/* 0x0318	 636 */		add	%i2,1,%i2

! Registers live out of .L77004076: 
! o5 sp l7 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004076 .L900001147

			.L900001147:
/* 0x031c	 636 */		cmp	%i2,%o5
/* 0x0320	 637 */		ld	[%i1],%f5
/* 0x0324	 636 */		add	%i1,4,%i1
/* 0x0328	 637 */		fitos	%f5,%f15
/* 0x032c	     */		st	%f15,[%l7]
/* 0x0330	 636 */		add	%l7,4,%l7
/* 0x0334	     */		ble,pt	%icc,.L900001147
/* 0x0338	     */		add	%i2,1,%i2

! Registers live out of .L900001147: 
! o5 sp l7 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001090 .L900001147

			.L900001050:
/* 0x033c	 634 */		ret	! Result = 
/* 0x0340	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004049

			.L77004100:
/* 0x0344	 636 */		or	%g0,0,%l0

! Registers live out of .L77004100: 
! o0 o3 sp l0 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004055 .L77004100

			.L77004090:
/* 0x0348	 636 */		add	%o3,640,%i1
/* 0x034c	 637 */		add	%i0,%i1,%l1
/* 0x0350	     */		sll	%l0,2,%i0

! Registers live out of .L77004090: 
! o0 sp l0 l1 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004051 .L77004090

			.L900001145:
/* 0x0354	 637 */		ld	[%l1+%i0],%f4
/* 0x0358	 636 */		add	%l0,1,%l0
/* 0x035c	     */		cmp	%l0,%o0
/* 0x0360	 637 */		fitos	%f4,%f16
/* 0x0364	 636 */		bcc,pn	%icc,.L77004044
/* 0x0368	 637 */		st	%f16,[%i0+%i2]

! Registers live out of .L900001145: 
! o0 sp l0 l1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001145

			.L77004051:
/* 0x036c	 637 */		sll	%l0,2,%o3
/* 0x0370	     */		ld	[%l1+%o3],%f7
/* 0x0374	 636 */		add	%l0,1,%l0
/* 0x0378	     */		cmp	%l0,%o0
/* 0x037c	 637 */		fitos	%f7,%f21
/* 0x0380	     */		st	%f21,[%o3+%i2]
/* 0x0384	 636 */		bcs,pt	%icc,.L900001145
/* 0x0388	 637 */		sll	%l0,2,%i0

! Registers live out of .L77004051: 
! o0 sp l0 l1 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004051

			.L900001049:
/* 0x038c	 634 */		ret	! Result = 
/* 0x0390	     */		restore	%g0,0,%g0

!  638		      !	 }
!  639		      !	 break;
!  640		      !      case GL_PIXEL_MAP_I_TO_R:
!  641		      !         MEMCPY(values,ctx->Pixel.MapItoR,ctx->Pixel.MapItoRsize*sizeof(GLfloat))
!  641		      >;

                       
! predecessor blocks: .L900001054

			.L77004023:
/* 0x0394	 641 */		sethi	%hi(0xb400),%l3
/* 0x0398	     */		add	%l3,640,%o7
/* 0x039c	     */		add	%o3,608,%o5
/* 0x03a0	     */		add	%i0,%o7,%o1
/* 0x03a4	     */		ld	[%i0+%o5],%i0
/* 0x03a8	     */		sll	%i0,2,%o4
/* 0x03ac	     */		cmp	%o4,32
/* 0x03b0	     */		bg	.L900001028
/* 0x03b4	     */		or	%g0,%o4,%o2

! Registers live out of .L77004023: 
! o0 o1 o2 o4 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004023

			.L900001016:
/* 0x03b8	 641 */		and	%o1,3,%l2
/* 0x03bc	     */		and	%i2,3,%o5
/* 0x03c0	     */		orcc	%o5,%l2,%g0
/* 0x03c4	     */		be	.L900001021
/* 0x03c8	     */		or	%g0,%i2,%i5

! Registers live out of .L900001016: 
! o1 o2 o4 sp i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001016

			.L900001017:
/* 0x03cc	 641 */		subcc	%o4,2,%o2
/* 0x03d0	     */		bl	.L900001019
/* 0x03d4	     */		srl	%o4,31,%o5

! Registers live out of .L900001017: 
! o1 o2 o4 o5 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001017

			.L900001084:
/* 0x03d8	 641 */		add	%o4,%o5,%o3
/* 0x03dc	     */		sra	%o3,1,%l1
/* 0x03e0	     */		cmp	%l1,1
/* 0x03e4	     */		bl	.L900001018
/* 0x03e8	     */		nop

! Registers live out of .L900001084: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001084

			.L900001085:
/* 0x03ec	 641 */		or	%g0,%o2,%o4
/* 0x03f0	     */		or	%g0,%o1,%o3

! Registers live out of .L900001085: 
! o3 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001083 .L900001085

			.L900001083:
/* 0x03f4	 641 */		sub	%o4,2,%o4
/* 0x03f8	     */		add	%i5,2,%i5
/* 0x03fc	     */		ldub	[%o3],%g1
/* 0x0400	     */		cmp	%o4,0
/* 0x0404	     */		add	%o3,2,%o3
/* 0x0408	     */		stb	%g1,[%i5-2]
/* 0x040c	     */		ldub	[%o3-1],%o7
/* 0x0410	     */		bge	.L900001083
/* 0x0414	     */		stb	%o7,[%i5-1]

! Registers live out of .L900001083: 
! o3 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001083

			.L900001086:
/* 0x0418	 641 */		or	%g0,%o4,%o2
/* 0x041c	     */		or	%g0,%o3,%o1
/* 0x0420	     */		ba	.L900001019
/* 0x0424	     */		nop

! Registers live out of .L900001086: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001084

			.L900001018:
/* 0x0428	 641 */		subcc	%o2,2,%o2

! Registers live out of .L900001018: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001018 .L900001144

			.L900001144:
/* 0x042c	 641 */		ldub	[%o1],%g1
/* 0x0430	     */		stb	%g1,[%i5]
/* 0x0434	     */		ldub	[%o1+1],%o7
/* 0x0438	     */		add	%o1,2,%o1
/* 0x043c	     */		stb	%o7,[%i5+1]
/* 0x0440	     */		add	%i5,2,%i5
/* 0x0444	     */		bge,a	.L900001144
/* 0x0448	     */		subcc	%o2,2,%o2

! Registers live out of .L900001144: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001017 .L900001086 .L900001144

			.L900001019:
/* 0x044c	 641 */		cmp	%o2,-1
/* 0x0450	     */		bl	.L77004044
/* 0x0454	     */		nop

! Registers live out of .L900001019: 
! o1 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001019

			.L900001020:
/* 0x0458	 641 */		ldub	[%o1],%l3
/* 0x045c	     */		stb	%l3,[%i5]
/* 0x0460	 634 */		ret	! Result = 
/* 0x0464	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900001016

			.L900001021:
/* 0x0468	 641 */		subcc	%o4,4,%g4
/* 0x046c	     */		bl	.L900001024
/* 0x0470	     */		sra	%o4,1,%i4

! Registers live out of .L900001021: 
! g4 o1 o2 o4 sp i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001021

			.L900001096:
/* 0x0474	 641 */		srl	%i4,30,%g3
/* 0x0478	     */		add	%o4,%g3,%l4
/* 0x047c	     */		sra	%l4,2,%g1
/* 0x0480	     */		cmp	%g1,1
/* 0x0484	     */		bl	.L900001022
/* 0x0488	     */		nop

! Registers live out of .L900001096: 
! g4 o1 o4 sp i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001096

			.L900001097:
/* 0x048c	 641 */		or	%g0,%i2,%g3
/* 0x0490	     */		or	%g0,%o1,%g2

! Registers live out of .L900001097: 
! g2 g3 g4 o4 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001095 .L900001097

			.L900001095:
/* 0x0494	 641 */		sub	%g4,4,%g4
/* 0x0498	     */		add	%g3,4,%g3
/* 0x049c	     */		ld	[%g2],%f12
/* 0x04a0	     */		cmp	%g4,0
/* 0x04a4	     */		add	%g2,4,%g2
/* 0x04a8	     */		bge	.L900001095
/* 0x04ac	     */		st	%f12,[%g3-4]

! Registers live out of .L900001095: 
! g2 g3 g4 o4 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001095

			.L900001098:
/* 0x04b0	 641 */		or	%g0,%g3,%i5
/* 0x04b4	     */		or	%g0,%g2,%o1
/* 0x04b8	     */		ba	.L900001023
/* 0x04bc	     */		nop

! Registers live out of .L900001098: 
! g4 o1 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001096

			.L900001022:
/* 0x04c0	 641 */		subcc	%g4,4,%g4

! Registers live out of .L900001022: 
! g4 o1 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001022 .L900001143

			.L900001143:
/* 0x04c4	 641 */		ld	[%o1],%f12
/* 0x04c8	     */		add	%o1,4,%o1
/* 0x04cc	     */		st	%f12,[%i5]
/* 0x04d0	     */		add	%i5,4,%i5
/* 0x04d4	     */		bge,a	.L900001143
/* 0x04d8	     */		subcc	%g4,4,%g4

! Registers live out of .L900001143: 
! g4 o1 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001098 .L900001143

			.L900001023:
/* 0x04dc	 641 */		add	%g4,4,%o2

! Registers live out of .L900001023: 
! o1 o2 o4 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001021 .L900001023

			.L900001024:
/* 0x04e0	 641 */		andcc	%o4,3,%g0
/* 0x04e4	     */		be	.L77004044
/* 0x04e8	     */		subcc	%o2,1,%o2

! Registers live out of .L900001024: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001024

			.L900001025:
/* 0x04ec	 641 */		ldub	[%o1],%g2
/* 0x04f0	     */		ble	.L77004044
/* 0x04f4	     */		stb	%g2,[%i5]

! Registers live out of .L900001025: 
! o1 o2 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001025

			.L900001026:
/* 0x04f8	 641 */		ldub	[%o1+1],%i4
/* 0x04fc	     */		subcc	%o2,1,%o2
/* 0x0500	     */		ble	.L77004044
/* 0x0504	     */		stb	%i4,[%i5+1]

! Registers live out of .L900001026: 
! o1 sp i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001026

			.L900001027:
/* 0x0508	 641 */		ldub	[%o1+2],%g3
/* 0x050c	     */		stb	%g3,[%i5+2]
/* 0x0510	 634 */		ret	! Result = 
/* 0x0514	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004023

			.L900001028:
/* 0x0518	 641 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x051c	     */		or	%g0,%i2,%o0
/* 0x0520	 634 */		ret	! Result = 
/* 0x0524	     */		restore	%g0,0,%g0

!  642		      !	 break;
!  643		      !      case GL_PIXEL_MAP_I_TO_G:
!  644		      !         MEMCPY(values,ctx->Pixel.MapItoG,ctx->Pixel.MapItoGsize*sizeof(GLfloat))
!  644		      >;

                       
! predecessor blocks: .L900001054

			.L77004025:
/* 0x0528	 644 */		add	%o3,612,%g1
/* 0x052c	     */		sethi	%hi(0xb800),%l6
/* 0x0530	     */		add	%l6,640,%o2
/* 0x0534	     */		ld	[%i0+%g1],%g2
/* 0x0538	     */		add	%i0,%o2,%o1
/* 0x053c	     */		sll	%g2,2,%i4
/* 0x0540	     */		cmp	%i4,32
/* 0x0544	     */		bg	.L900001012
/* 0x0548	     */		or	%g0,%i4,%o2

! Registers live out of .L77004025: 
! o0 o1 o2 sp i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004025

			.L900001000:
/* 0x054c	 644 */		and	%o1,3,%o0
/* 0x0550	     */		and	%i2,3,%g5
/* 0x0554	     */		orcc	%g5,%o0,%g0
/* 0x0558	     */		be	.L900001005
/* 0x055c	     */		or	%g0,%i2,%l6

! Registers live out of .L900001000: 
! o1 o2 sp l6 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001000

			.L900001001:
/* 0x0560	 644 */		subcc	%i4,2,%o2
/* 0x0564	     */		bl	.L900001003
/* 0x0568	     */		sub	%o2,-2,%o0

! Registers live out of .L900001001: 
! o0 o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001001

			.L900001080:
/* 0x056c	 644 */		srl	%o0,31,%i0
/* 0x0570	     */		add	%o0,%i0,%i3
/* 0x0574	     */		sra	%i3,1,%i2
/* 0x0578	     */		cmp	%i2,1
/* 0x057c	     */		bl	.L900001002
/* 0x0580	     */		nop

! Registers live out of .L900001080: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001079 .L900001080

			.L900001079:
/* 0x0584	 644 */		sub	%o2,2,%o2
/* 0x0588	     */		add	%l6,2,%l6
/* 0x058c	     */		ldub	[%o1],%l0
/* 0x0590	     */		cmp	%o2,0
/* 0x0594	     */		add	%o1,2,%o1
/* 0x0598	     */		stb	%l0,[%l6-2]
/* 0x059c	     */		ldub	[%o1-1],%i0
/* 0x05a0	     */		bge	.L900001079
/* 0x05a4	     */		stb	%i0,[%l6-1]

! Registers live out of .L900001079: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001079

			.L900001082:
/* 0x05a8	 644 */		ba	.L900001003
/* 0x05ac	     */		nop

! Registers live out of .L900001082: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001080

			.L900001002:
/* 0x05b0	 644 */		subcc	%o2,2,%o2

! Registers live out of .L900001002: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001002 .L900001142

			.L900001142:
/* 0x05b4	 644 */		ldub	[%o1],%l0
/* 0x05b8	     */		stb	%l0,[%l6]
/* 0x05bc	     */		ldub	[%o1+1],%i0
/* 0x05c0	     */		add	%o1,2,%o1
/* 0x05c4	     */		stb	%i0,[%l6+1]
/* 0x05c8	     */		add	%l6,2,%l6
/* 0x05cc	     */		bge,a	.L900001142
/* 0x05d0	     */		subcc	%o2,2,%o2

! Registers live out of .L900001142: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001001 .L900001082 .L900001142

			.L900001003:
/* 0x05d4	 644 */		cmp	%o2,-1
/* 0x05d8	     */		bl	.L77004044
/* 0x05dc	     */		nop

! Registers live out of .L900001003: 
! o1 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001003

			.L900001004:
/* 0x05e0	 644 */		ldub	[%o1],%l1
/* 0x05e4	     */		stb	%l1,[%l6]
/* 0x05e8	 634 */		ret	! Result = 
/* 0x05ec	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900001000

			.L900001005:
/* 0x05f0	 644 */		subcc	%i4,4,%l0
/* 0x05f4	     */		bl	.L900001008
/* 0x05f8	     */		sub	%l0,-4,%g5

! Registers live out of .L900001005: 
! g5 o1 o2 sp l0 l6 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001005

			.L900001100:
/* 0x05fc	 644 */		sra	%g5,1,%o0
/* 0x0600	     */		srl	%o0,30,%l5
/* 0x0604	     */		add	%g5,%l5,%g4
/* 0x0608	     */		sra	%g4,2,%l3
/* 0x060c	     */		cmp	%l3,1
/* 0x0610	     */		bl	.L900001006
/* 0x0614	     */		nop

! Registers live out of .L900001100: 
! o1 sp l0 l6 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001100

			.L900001101:
/* 0x0618	 644 */		or	%g0,%i2,%o0
/* 0x061c	     */		or	%g0,%o1,%g5

! Registers live out of .L900001101: 
! g5 o0 sp l0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001099 .L900001101

			.L900001099:
/* 0x0620	 644 */		sub	%l0,4,%l0
/* 0x0624	     */		add	%o0,4,%o0
/* 0x0628	     */		ld	[%g5],%f24
/* 0x062c	     */		cmp	%l0,0
/* 0x0630	     */		add	%g5,4,%g5
/* 0x0634	     */		bge	.L900001099
/* 0x0638	     */		st	%f24,[%o0-4]

! Registers live out of .L900001099: 
! g5 o0 sp l0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001099

			.L900001102:
/* 0x063c	 644 */		or	%g0,%o0,%l6
/* 0x0640	     */		or	%g0,%g5,%o1
/* 0x0644	     */		ba	.L900001007
/* 0x0648	     */		nop

! Registers live out of .L900001102: 
! o1 sp l0 l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001100

			.L900001006:
/* 0x064c	 644 */		subcc	%l0,4,%l0

! Registers live out of .L900001006: 
! o1 sp l0 l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001006 .L900001141

			.L900001141:
/* 0x0650	 644 */		ld	[%o1],%f24
/* 0x0654	     */		add	%o1,4,%o1
/* 0x0658	     */		st	%f24,[%l6]
/* 0x065c	     */		add	%l6,4,%l6
/* 0x0660	     */		bge,a	.L900001141
/* 0x0664	     */		subcc	%l0,4,%l0

! Registers live out of .L900001141: 
! o1 sp l0 l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001102 .L900001141

			.L900001007:
/* 0x0668	 644 */		add	%l0,4,%o2

! Registers live out of .L900001007: 
! o1 o2 sp l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001005 .L900001007

			.L900001008:
/* 0x066c	 644 */		andcc	%i4,3,%g0
/* 0x0670	     */		be	.L77004044
/* 0x0674	     */		subcc	%o2,1,%o2

! Registers live out of .L900001008: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001008

			.L900001009:
/* 0x0678	 644 */		ldub	[%o1],%o3
/* 0x067c	     */		ble	.L77004044
/* 0x0680	     */		stb	%o3,[%l6]

! Registers live out of .L900001009: 
! o1 o2 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001009

			.L900001010:
/* 0x0684	 644 */		ldub	[%o1+1],%o4
/* 0x0688	     */		subcc	%o2,1,%o2
/* 0x068c	     */		ble	.L77004044
/* 0x0690	     */		stb	%o4,[%l6+1]

! Registers live out of .L900001010: 
! o1 sp l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001010

			.L900001011:
/* 0x0694	 644 */		ldub	[%o1+2],%l4
/* 0x0698	     */		stb	%l4,[%l6+2]
/* 0x069c	 634 */		ret	! Result = 
/* 0x06a0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004025

			.L900001012:
/* 0x06a4	 644 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x06a8	     */		or	%g0,%i2,%o0
/* 0x06ac	 634 */		ret	! Result = 
/* 0x06b0	     */		restore	%g0,0,%g0

!  645		      !	 break;
!  646		      !      case GL_PIXEL_MAP_I_TO_B:
!  647		      !         MEMCPY(values,ctx->Pixel.MapItoB,ctx->Pixel.MapItoBsize*sizeof(GLfloat))
!  647		      >;

                       
! predecessor blocks: .L900001054

			.L77004027:
/* 0x06b4	 647 */		add	%o3,616,%i2
/* 0x06b8	     */		sethi	%hi(0xbc00),%i3
/* 0x06bc	     */		add	%i3,640,%i5
/* 0x06c0	     */		ld	[%i0+%i2],%l5
/* 0x06c4	     */		add	%i0,%i5,%o1
/* 0x06c8	     */		sll	%l5,2,%g3
/* 0x06cc	     */		cmp	%g3,32
/* 0x06d0	     */		bg	.L900000996
/* 0x06d4	     */		or	%g0,%g3,%o2

! Registers live out of .L77004027: 
! g3 o0 o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004027

			.L900000984:
/* 0x06d8	 647 */		and	%l7,3,%l5
/* 0x06dc	     */		and	%o1,3,%l6
/* 0x06e0	     */		orcc	%l5,%l6,%g0
/* 0x06e4	     */		be	.L900000989
/* 0x06e8	     */		or	%g0,%l7,%l5

! Registers live out of .L900000984: 
! g3 o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000984

			.L900000985:
/* 0x06ec	 647 */		subcc	%g3,2,%o2
/* 0x06f0	     */		bl	.L900000987
/* 0x06f4	     */		srl	%g3,31,%i1

! Registers live out of .L900000985: 
! g3 o1 o2 sp l5 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000985

			.L900001076:
/* 0x06f8	 647 */		add	%g3,%i1,%i5
/* 0x06fc	     */		sra	%i5,1,%l6
/* 0x0700	     */		cmp	%l6,1
/* 0x0704	     */		bl	.L900000986
/* 0x0708	     */		nop

! Registers live out of .L900001076: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001076

			.L900001077:
/* 0x070c	 647 */		or	%g0,%o2,%o0
/* 0x0710	     */		or	%g0,%o1,%g5

! Registers live out of .L900001077: 
! g5 o0 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001075 .L900001077

			.L900001075:
/* 0x0714	 647 */		sub	%o0,2,%o0
/* 0x0718	     */		add	%l5,2,%l5
/* 0x071c	     */		ldub	[%g5],%g4
/* 0x0720	     */		cmp	%o0,0
/* 0x0724	     */		add	%g5,2,%g5
/* 0x0728	     */		stb	%g4,[%l5-2]
/* 0x072c	     */		ldub	[%g5-1],%i5
/* 0x0730	     */		bge	.L900001075
/* 0x0734	     */		stb	%i5,[%l5-1]

! Registers live out of .L900001075: 
! g5 o0 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001075

			.L900001078:
/* 0x0738	 647 */		or	%g0,%o0,%o2
/* 0x073c	     */		or	%g0,%g5,%o1
/* 0x0740	     */		ba	.L900000987
/* 0x0744	     */		nop

! Registers live out of .L900001078: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001076

			.L900000986:
/* 0x0748	 647 */		subcc	%o2,2,%o2

! Registers live out of .L900000986: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000986 .L900001140

			.L900001140:
/* 0x074c	 647 */		ldub	[%o1],%g4
/* 0x0750	     */		stb	%g4,[%l5]
/* 0x0754	     */		ldub	[%o1+1],%i5
/* 0x0758	     */		add	%o1,2,%o1
/* 0x075c	     */		stb	%i5,[%l5+1]
/* 0x0760	     */		add	%l5,2,%l5
/* 0x0764	     */		bge,a	.L900001140
/* 0x0768	     */		subcc	%o2,2,%o2

! Registers live out of .L900001140: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000985 .L900001078 .L900001140

			.L900000987:
/* 0x076c	 647 */		cmp	%o2,-1
/* 0x0770	     */		bl	.L77004044
/* 0x0774	     */		nop

! Registers live out of .L900000987: 
! o1 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000987

			.L900000988:
/* 0x0778	 647 */		ldub	[%o1],%i1
/* 0x077c	     */		stb	%i1,[%l5]
/* 0x0780	 634 */		ret	! Result = 
/* 0x0784	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000984

			.L900000989:
/* 0x0788	 647 */		subcc	%g3,4,%l2
/* 0x078c	     */		bl	.L900000992
/* 0x0790	     */		sra	%g3,1,%i2

! Registers live out of .L900000989: 
! g3 o1 o2 sp l2 l5 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000989

			.L900001104:
/* 0x0794	 647 */		srl	%i2,30,%l7
/* 0x0798	     */		add	%g3,%l7,%i5
/* 0x079c	     */		sra	%i5,2,%l6
/* 0x07a0	     */		cmp	%l6,1
/* 0x07a4	     */		bl	.L900000990
/* 0x07a8	     */		nop

! Registers live out of .L900001104: 
! g3 o1 sp l2 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001104

			.L900001105:
/* 0x07ac	 647 */		or	%g0,%l5,%l1

! Registers live out of .L900001105: 
! g3 o1 sp l1 l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001103 .L900001105

			.L900001103:
/* 0x07b0	 647 */		sub	%l2,4,%l2
/* 0x07b4	     */		add	%l1,4,%l1
/* 0x07b8	     */		ld	[%o1],%f26
/* 0x07bc	     */		cmp	%l2,0
/* 0x07c0	     */		add	%o1,4,%o1
/* 0x07c4	     */		bge	.L900001103
/* 0x07c8	     */		st	%f26,[%l1-4]

! Registers live out of .L900001103: 
! g3 o1 sp l1 l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001103

			.L900001106:
/* 0x07cc	 647 */		or	%g0,%l1,%l5
/* 0x07d0	     */		ba	.L900000991
/* 0x07d4	     */		nop

! Registers live out of .L900001106: 
! g3 o1 sp l2 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001104

			.L900000990:
/* 0x07d8	 647 */		subcc	%l2,4,%l2

! Registers live out of .L900000990: 
! g3 o1 sp l2 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000990 .L900001139

			.L900001139:
/* 0x07dc	 647 */		ld	[%o1],%f26
/* 0x07e0	     */		add	%o1,4,%o1
/* 0x07e4	     */		st	%f26,[%l5]
/* 0x07e8	     */		add	%l5,4,%l5
/* 0x07ec	     */		bge,a	.L900001139
/* 0x07f0	     */		subcc	%l2,4,%l2

! Registers live out of .L900001139: 
! g3 o1 sp l2 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001106 .L900001139

			.L900000991:
/* 0x07f4	 647 */		add	%l2,4,%o2

! Registers live out of .L900000991: 
! g3 o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000989 .L900000991

			.L900000992:
/* 0x07f8	 647 */		andcc	%g3,3,%g0
/* 0x07fc	     */		be	.L77004044
/* 0x0800	     */		subcc	%o2,1,%o2

! Registers live out of .L900000992: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000992

			.L900000993:
/* 0x0804	 647 */		ldub	[%o1],%l7
/* 0x0808	     */		ble	.L77004044
/* 0x080c	     */		stb	%l7,[%l5]

! Registers live out of .L900000993: 
! o1 o2 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000993

			.L900000994:
/* 0x0810	 647 */		ldub	[%o1+1],%i2
/* 0x0814	     */		subcc	%o2,1,%o2
/* 0x0818	     */		ble	.L77004044
/* 0x081c	     */		stb	%i2,[%l5+1]

! Registers live out of .L900000994: 
! o1 sp l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000994

			.L900000995:
/* 0x0820	 647 */		ldub	[%o1+2],%i3
/* 0x0824	     */		stb	%i3,[%l5+2]
/* 0x0828	 634 */		ret	! Result = 
/* 0x082c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004027

			.L900000996:
/* 0x0830	 647 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0834	     */		or	%g0,%l7,%o0
/* 0x0838	 634 */		ret	! Result = 
/* 0x083c	     */		restore	%g0,0,%g0

!  648		      !	 break;
!  649		      !      case GL_PIXEL_MAP_I_TO_A:
!  650		      !         MEMCPY(values,ctx->Pixel.MapItoA,ctx->Pixel.MapItoAsize*sizeof(GLfloat))
!  650		      >;

                       
! predecessor blocks: .L900001054

			.L77004029:
/* 0x0840	 650 */		add	%o3,620,%i1
/* 0x0844	     */		sethi	%hi(0xc000),%l4
/* 0x0848	     */		add	%l4,640,%o0
/* 0x084c	     */		ld	[%i0+%i1],%g5
/* 0x0850	     */		add	%i0,%o0,%o1
/* 0x0854	     */		sll	%g5,2,%g4
/* 0x0858	     */		cmp	%g4,32
/* 0x085c	     */		bg	.L900000980
/* 0x0860	     */		or	%g0,%g4,%o2

! Registers live out of .L77004029: 
! g4 o0 o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004029

			.L900000968:
/* 0x0864	 650 */		and	%o1,3,%l3
/* 0x0868	     */		and	%i2,3,%o7
/* 0x086c	     */		orcc	%o7,%l3,%g0
/* 0x0870	     */		be	.L900000973
/* 0x0874	     */		or	%g0,%i2,%l3

! Registers live out of .L900000968: 
! g4 o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000968

			.L900000969:
/* 0x0878	 650 */		subcc	%g4,2,%o2
/* 0x087c	     */		bl	.L900000971
/* 0x0880	     */		or	%g0,%g4,%g3

! Registers live out of .L900000969: 
! g3 g4 o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000969

			.L900001072:
/* 0x0884	 650 */		srl	%g4,31,%g4
/* 0x0888	     */		add	%g3,%g4,%i4
/* 0x088c	     */		sra	%i4,1,%g2
/* 0x0890	     */		cmp	%g2,1
/* 0x0894	     */		bl	.L900000970
/* 0x0898	     */		nop

! Registers live out of .L900001072: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001072

			.L900001073:
/* 0x089c	 650 */		or	%g0,%o2,%g4
/* 0x08a0	     */		or	%g0,%o1,%g3

! Registers live out of .L900001073: 
! g3 g4 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001071 .L900001073

			.L900001071:
/* 0x08a4	 650 */		sub	%g4,2,%g4
/* 0x08a8	     */		add	%l3,2,%l3
/* 0x08ac	     */		ldub	[%g3],%g2
/* 0x08b0	     */		cmp	%g4,0
/* 0x08b4	     */		add	%g3,2,%g3
/* 0x08b8	     */		stb	%g2,[%l3-2]
/* 0x08bc	     */		ldub	[%g3-1],%g1
/* 0x08c0	     */		bge	.L900001071
/* 0x08c4	     */		stb	%g1,[%l3-1]

! Registers live out of .L900001071: 
! g3 g4 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001071

			.L900001074:
/* 0x08c8	 650 */		or	%g0,%g4,%o2
/* 0x08cc	     */		or	%g0,%g3,%o1
/* 0x08d0	     */		ba	.L900000971
/* 0x08d4	     */		nop

! Registers live out of .L900001074: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001072

			.L900000970:
/* 0x08d8	 650 */		subcc	%o2,2,%o2

! Registers live out of .L900000970: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000970 .L900001138

			.L900001138:
/* 0x08dc	 650 */		ldub	[%o1],%g2
/* 0x08e0	     */		stb	%g2,[%l3]
/* 0x08e4	     */		ldub	[%o1+1],%g1
/* 0x08e8	     */		add	%o1,2,%o1
/* 0x08ec	     */		stb	%g1,[%l3+1]
/* 0x08f0	     */		add	%l3,2,%l3
/* 0x08f4	     */		bge,a	.L900001138
/* 0x08f8	     */		subcc	%o2,2,%o2

! Registers live out of .L900001138: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000969 .L900001074 .L900001138

			.L900000971:
/* 0x08fc	 650 */		cmp	%o2,-1
/* 0x0900	     */		bl	.L77004044
/* 0x0904	     */		nop

! Registers live out of .L900000971: 
! o1 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000971

			.L900000972:
/* 0x0908	 650 */		ldub	[%o1],%o1
/* 0x090c	     */		stb	%o1,[%l3]
/* 0x0910	 634 */		ret	! Result = 
/* 0x0914	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000968

			.L900000973:
/* 0x0918	 650 */		subcc	%g4,4,%l4
/* 0x091c	     */		bl	.L900000976
/* 0x0920	     */		sra	%g4,1,%l1

! Registers live out of .L900000973: 
! g4 o1 o2 sp l1 l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000973

			.L900001108:
/* 0x0924	 650 */		srl	%l1,30,%o2
/* 0x0928	     */		add	%g4,%o2,%i0
/* 0x092c	     */		sra	%i0,2,%i3
/* 0x0930	     */		cmp	%i3,1
/* 0x0934	     */		bl	.L900000974
/* 0x0938	     */		nop

! Registers live out of .L900001108: 
! g4 o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001108

			.L900001109:
/* 0x093c	 650 */		or	%g0,%o1,%o2

! Registers live out of .L900001109: 
! g4 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001107 .L900001109

			.L900001107:
/* 0x0940	 650 */		sub	%l4,4,%l4
/* 0x0944	     */		add	%l3,4,%l3
/* 0x0948	     */		ld	[%o2],%f28
/* 0x094c	     */		cmp	%l4,0
/* 0x0950	     */		add	%o2,4,%o2
/* 0x0954	     */		bge	.L900001107
/* 0x0958	     */		st	%f28,[%l3-4]

! Registers live out of .L900001107: 
! g4 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001107

			.L900001110:
/* 0x095c	 650 */		or	%g0,%o2,%o1
/* 0x0960	     */		ba	.L900000975
/* 0x0964	     */		nop

! Registers live out of .L900001110: 
! g4 o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001108

			.L900000974:
/* 0x0968	 650 */		subcc	%l4,4,%l4

! Registers live out of .L900000974: 
! g4 o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000974 .L900001137

			.L900001137:
/* 0x096c	 650 */		ld	[%o1],%f28
/* 0x0970	     */		add	%o1,4,%o1
/* 0x0974	     */		st	%f28,[%l3]
/* 0x0978	     */		add	%l3,4,%l3
/* 0x097c	     */		bge,a	.L900001137
/* 0x0980	     */		subcc	%l4,4,%l4

! Registers live out of .L900001137: 
! g4 o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001110 .L900001137

			.L900000975:
/* 0x0984	 650 */		add	%l4,4,%o2

! Registers live out of .L900000975: 
! g4 o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000973 .L900000975

			.L900000976:
/* 0x0988	 650 */		andcc	%g4,3,%g0
/* 0x098c	     */		be	.L77004044
/* 0x0990	     */		subcc	%o2,1,%o2

! Registers live out of .L900000976: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000976

			.L900000977:
/* 0x0994	 650 */		ldub	[%o1],%i4
/* 0x0998	     */		ble	.L77004044
/* 0x099c	     */		stb	%i4,[%l3]

! Registers live out of .L900000977: 
! o1 o2 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000977

			.L900000978:
/* 0x09a0	 650 */		ldub	[%o1+1],%g3
/* 0x09a4	     */		subcc	%o2,1,%o2
/* 0x09a8	     */		ble	.L77004044
/* 0x09ac	     */		stb	%g3,[%l3+1]

! Registers live out of .L900000978: 
! o1 sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000978

			.L900000979:
/* 0x09b0	 650 */		ldub	[%o1+2],%o2
/* 0x09b4	     */		stb	%o2,[%l3+2]
/* 0x09b8	 634 */		ret	! Result = 
/* 0x09bc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004029

			.L900000980:
/* 0x09c0	 650 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x09c4	     */		or	%g0,%i2,%o0
/* 0x09c8	 634 */		ret	! Result = 
/* 0x09cc	     */		restore	%g0,0,%g0

!  651		      !	 break;
!  652		      !      case GL_PIXEL_MAP_R_TO_R:
!  653		      !         MEMCPY(values,ctx->Pixel.MapRtoR,ctx->Pixel.MapRtoRsize*sizeof(GLfloat))
!  653		      >;

                       
! predecessor blocks: .L900001054

			.L77004031:
/* 0x09d0	 653 */		add	%o3,624,%o3
/* 0x09d4	     */		sethi	%hi(0xc400),%o4
/* 0x09d8	     */		add	%o4,640,%l2
/* 0x09dc	     */		ld	[%i0+%o3],%l1
/* 0x09e0	     */		add	%i0,%l2,%o1
/* 0x09e4	     */		sll	%l1,2,%l0
/* 0x09e8	     */		cmp	%l0,32
/* 0x09ec	     */		bg	.L900000964
/* 0x09f0	     */		or	%g0,%l0,%o2

! Registers live out of .L77004031: 
! o0 o1 o2 sp l0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004031

			.L900000952:
/* 0x09f4	 653 */		and	%o1,3,%l4
/* 0x09f8	     */		and	%i2,3,%i0
/* 0x09fc	     */		orcc	%i0,%l4,%g0
/* 0x0a00	     */		be	.L900000957
/* 0x0a04	     */		or	%g0,%i2,%l4

! Registers live out of .L900000952: 
! o1 o2 sp l0 l4 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000952

			.L900000953:
/* 0x0a08	 653 */		subcc	%l0,2,%o2
/* 0x0a0c	     */		bl	.L900000955
/* 0x0a10	     */		sub	%o2,-2,%o7

! Registers live out of .L900000953: 
! o1 o2 sp o7 l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000953

			.L900001068:
/* 0x0a14	 653 */		srl	%o7,31,%g1
/* 0x0a18	     */		add	%o7,%g1,%l2
/* 0x0a1c	     */		sra	%l2,1,%o5
/* 0x0a20	     */		cmp	%o5,1
/* 0x0a24	     */		bl	.L900000954
/* 0x0a28	     */		nop

! Registers live out of .L900001068: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001068

			.L900001069:
/* 0x0a2c	 653 */		or	%g0,%o2,%g2
/* 0x0a30	     */		or	%g0,%o1,%g1

! Registers live out of .L900001069: 
! g1 g2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001067 .L900001069

			.L900001067:
/* 0x0a34	 653 */		sub	%g2,2,%g2
/* 0x0a38	     */		add	%l4,2,%l4
/* 0x0a3c	     */		ldub	[%g1],%l1
/* 0x0a40	     */		cmp	%g2,0
/* 0x0a44	     */		add	%g1,2,%g1
/* 0x0a48	     */		stb	%l1,[%l4-2]
/* 0x0a4c	     */		ldub	[%g1-1],%l0
/* 0x0a50	     */		bge	.L900001067
/* 0x0a54	     */		stb	%l0,[%l4-1]

! Registers live out of .L900001067: 
! g1 g2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001067

			.L900001070:
/* 0x0a58	 653 */		or	%g0,%g2,%o2
/* 0x0a5c	     */		or	%g0,%g1,%o1
/* 0x0a60	     */		ba	.L900000955
/* 0x0a64	     */		nop

! Registers live out of .L900001070: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001068

			.L900000954:
/* 0x0a68	 653 */		subcc	%o2,2,%o2

! Registers live out of .L900000954: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000954 .L900001136

			.L900001136:
/* 0x0a6c	 653 */		ldub	[%o1],%l1
/* 0x0a70	     */		stb	%l1,[%l4]
/* 0x0a74	     */		ldub	[%o1+1],%l0
/* 0x0a78	     */		add	%o1,2,%o1
/* 0x0a7c	     */		stb	%l0,[%l4+1]
/* 0x0a80	     */		add	%l4,2,%l4
/* 0x0a84	     */		bge,a	.L900001136
/* 0x0a88	     */		subcc	%o2,2,%o2

! Registers live out of .L900001136: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000953 .L900001070 .L900001136

			.L900000955:
/* 0x0a8c	 653 */		cmp	%o2,-1
/* 0x0a90	     */		bl	.L77004044
/* 0x0a94	     */		nop

! Registers live out of .L900000955: 
! o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000955

			.L900000956:
/* 0x0a98	 653 */		ldub	[%o1],%o3
/* 0x0a9c	     */		stb	%o3,[%l4]
/* 0x0aa0	 634 */		ret	! Result = 
/* 0x0aa4	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000952

			.L900000957:
/* 0x0aa8	 653 */		subcc	%l0,4,%l6
/* 0x0aac	     */		bl	.L900000960
/* 0x0ab0	     */		sub	%l6,-4,%o5

! Registers live out of .L900000957: 
! o1 o2 o5 sp l0 l4 l6 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000957

			.L900001112:
/* 0x0ab4	 653 */		sra	%o5,1,%o7
/* 0x0ab8	     */		srl	%o7,30,%l2
/* 0x0abc	     */		add	%o5,%l2,%o4
/* 0x0ac0	     */		sra	%o4,2,%o3
/* 0x0ac4	     */		cmp	%o3,1
/* 0x0ac8	     */		bl	.L900000958
/* 0x0acc	     */		nop

! Registers live out of .L900001112: 
! o1 sp l0 l4 l6 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001112

			.L900001113:
/* 0x0ad0	 653 */		or	%g0,%i2,%l5
/* 0x0ad4	     */		or	%g0,%o1,%o3

! Registers live out of .L900001113: 
! o3 sp l0 l5 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001111 .L900001113

			.L900001111:
/* 0x0ad8	 653 */		sub	%l6,4,%l6
/* 0x0adc	     */		add	%l5,4,%l5
/* 0x0ae0	     */		ld	[%o3],%f30
/* 0x0ae4	     */		cmp	%l6,0
/* 0x0ae8	     */		add	%o3,4,%o3
/* 0x0aec	     */		bge	.L900001111
/* 0x0af0	     */		st	%f30,[%l5-4]

! Registers live out of .L900001111: 
! o3 sp l0 l5 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001111

			.L900001114:
/* 0x0af4	 653 */		or	%g0,%l5,%l4
/* 0x0af8	     */		or	%g0,%o3,%o1
/* 0x0afc	     */		ba	.L900000959
/* 0x0b00	     */		nop

! Registers live out of .L900001114: 
! o1 sp l0 l4 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001112

			.L900000958:
/* 0x0b04	 653 */		subcc	%l6,4,%l6

! Registers live out of .L900000958: 
! o1 sp l0 l4 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000958 .L900001135

			.L900001135:
/* 0x0b08	 653 */		ld	[%o1],%f30
/* 0x0b0c	     */		add	%o1,4,%o1
/* 0x0b10	     */		st	%f30,[%l4]
/* 0x0b14	     */		add	%l4,4,%l4
/* 0x0b18	     */		bge,a	.L900001135
/* 0x0b1c	     */		subcc	%l6,4,%l6

! Registers live out of .L900001135: 
! o1 sp l0 l4 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001114 .L900001135

			.L900000959:
/* 0x0b20	 653 */		add	%l6,4,%o2

! Registers live out of .L900000959: 
! o1 o2 sp l0 l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000957 .L900000959

			.L900000960:
/* 0x0b24	 653 */		andcc	%l0,3,%g0
/* 0x0b28	     */		be	.L77004044
/* 0x0b2c	     */		subcc	%o2,1,%o2

! Registers live out of .L900000960: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000960

			.L900000961:
/* 0x0b30	 653 */		ldub	[%o1],%o4
/* 0x0b34	     */		ble	.L77004044
/* 0x0b38	     */		stb	%o4,[%l4]

! Registers live out of .L900000961: 
! o1 o2 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000961

			.L900000962:
/* 0x0b3c	 653 */		ldub	[%o1+1],%o5
/* 0x0b40	     */		subcc	%o2,1,%o2
/* 0x0b44	     */		ble	.L77004044
/* 0x0b48	     */		stb	%o5,[%l4+1]

! Registers live out of .L900000962: 
! o1 sp l4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000962

			.L900000963:
/* 0x0b4c	 653 */		ldub	[%o1+2],%l2
/* 0x0b50	     */		stb	%l2,[%l4+2]
/* 0x0b54	 634 */		ret	! Result = 
/* 0x0b58	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004031

			.L900000964:
/* 0x0b5c	 653 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0b60	     */		or	%g0,%i2,%o0
/* 0x0b64	 634 */		ret	! Result = 
/* 0x0b68	     */		restore	%g0,0,%g0

!  654		      !	 break;
!  655		      !      case GL_PIXEL_MAP_G_TO_G:
!  656		      !         MEMCPY(values,ctx->Pixel.MapGtoG,ctx->Pixel.MapGtoGsize*sizeof(GLfloat))
!  656		      >;

                       
! predecessor blocks: .L900001054

			.L77004033:
/* 0x0b6c	 656 */		sethi	%hi(0xc800),%i4
/* 0x0b70	     */		add	%i4,640,%l3
/* 0x0b74	     */		add	%o3,628,%o7
/* 0x0b78	     */		add	%i0,%l3,%o1
/* 0x0b7c	     */		ld	[%i0+%o7],%i0
/* 0x0b80	     */		sll	%i0,2,%o5
/* 0x0b84	     */		cmp	%o5,32
/* 0x0b88	     */		bg	.L900000948
/* 0x0b8c	     */		or	%g0,%o5,%o2

! Registers live out of .L77004033: 
! o0 o1 o2 o5 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004033

			.L900000936:
/* 0x0b90	 656 */		and	%o1,3,%g4
/* 0x0b94	     */		and	%i2,3,%i5
/* 0x0b98	     */		orcc	%i5,%g4,%g0
/* 0x0b9c	     */		be	.L900000941
/* 0x0ba0	     */		or	%g0,%i2,%l2

! Registers live out of .L900000936: 
! o1 o2 o5 sp l2 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000936

			.L900000937:
/* 0x0ba4	 656 */		subcc	%o5,2,%o2
/* 0x0ba8	     */		bl	.L900000939
/* 0x0bac	     */		srl	%o5,31,%o4

! Registers live out of .L900000937: 
! o1 o2 o4 o5 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000937

			.L900001064:
/* 0x0bb0	 656 */		add	%o5,%o4,%l1
/* 0x0bb4	     */		sra	%l1,1,%l0
/* 0x0bb8	     */		cmp	%l0,1
/* 0x0bbc	     */		bl	.L900000938
/* 0x0bc0	     */		nop

! Registers live out of .L900001064: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001064

			.L900001065:
/* 0x0bc4	 656 */		or	%g0,%o2,%o7
/* 0x0bc8	     */		or	%g0,%o1,%o5

! Registers live out of .L900001065: 
! o5 sp o7 l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001063 .L900001065

			.L900001063:
/* 0x0bcc	 656 */		sub	%o7,2,%o7
/* 0x0bd0	     */		add	%l2,2,%l2
/* 0x0bd4	     */		ldub	[%o5],%l7
/* 0x0bd8	     */		cmp	%o7,0
/* 0x0bdc	     */		add	%o5,2,%o5
/* 0x0be0	     */		stb	%l7,[%l2-2]
/* 0x0be4	     */		ldub	[%o5-1],%i1
/* 0x0be8	     */		bge	.L900001063
/* 0x0bec	     */		stb	%i1,[%l2-1]

! Registers live out of .L900001063: 
! o5 sp o7 l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001063

			.L900001066:
/* 0x0bf0	 656 */		or	%g0,%o7,%o2
/* 0x0bf4	     */		or	%g0,%o5,%o1
/* 0x0bf8	     */		ba	.L900000939
/* 0x0bfc	     */		nop

! Registers live out of .L900001066: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001064

			.L900000938:
/* 0x0c00	 656 */		subcc	%o2,2,%o2

! Registers live out of .L900000938: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000938 .L900001134

			.L900001134:
/* 0x0c04	 656 */		ldub	[%o1],%l7
/* 0x0c08	     */		stb	%l7,[%l2]
/* 0x0c0c	     */		ldub	[%o1+1],%i1
/* 0x0c10	     */		add	%o1,2,%o1
/* 0x0c14	     */		stb	%i1,[%l2+1]
/* 0x0c18	     */		add	%l2,2,%l2
/* 0x0c1c	     */		bge,a	.L900001134
/* 0x0c20	     */		subcc	%o2,2,%o2

! Registers live out of .L900001134: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000937 .L900001066 .L900001134

			.L900000939:
/* 0x0c24	 656 */		cmp	%o2,-1
/* 0x0c28	     */		bl	.L77004044
/* 0x0c2c	     */		nop

! Registers live out of .L900000939: 
! o1 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000939

			.L900000940:
/* 0x0c30	 656 */		ldub	[%o1],%i2
/* 0x0c34	     */		stb	%i2,[%l2]
/* 0x0c38	 634 */		ret	! Result = 
/* 0x0c3c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000936

			.L900000941:
/* 0x0c40	 656 */		subcc	%o5,4,%l7
/* 0x0c44	     */		bl	.L900000944
/* 0x0c48	     */		sra	%o5,1,%i4

! Registers live out of .L900000941: 
! o1 o2 o5 sp l2 l7 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000941

			.L900001116:
/* 0x0c4c	 656 */		srl	%i4,30,%g3
/* 0x0c50	     */		add	%o5,%g3,%l4
/* 0x0c54	     */		sra	%l4,2,%g1
/* 0x0c58	     */		cmp	%g1,1
/* 0x0c5c	     */		bl	.L900000942
/* 0x0c60	     */		nop

! Registers live out of .L900001116: 
! o1 o5 sp l2 l7 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001116

			.L900001117:
/* 0x0c64	 656 */		or	%g0,%i2,%i1
/* 0x0c68	     */		or	%g0,%o1,%o4

! Registers live out of .L900001117: 
! o4 o5 sp l7 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001115 .L900001117

			.L900001115:
/* 0x0c6c	 656 */		sub	%l7,4,%l7
/* 0x0c70	     */		add	%i1,4,%i1
/* 0x0c74	     */		ld	[%o4],%f1
/* 0x0c78	     */		cmp	%l7,0
/* 0x0c7c	     */		add	%o4,4,%o4
/* 0x0c80	     */		bge	.L900001115
/* 0x0c84	     */		st	%f1,[%i1-4]

! Registers live out of .L900001115: 
! o4 o5 sp l7 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001115

			.L900001118:
/* 0x0c88	 656 */		or	%g0,%i1,%l2
/* 0x0c8c	     */		or	%g0,%o4,%o1
/* 0x0c90	     */		ba	.L900000943
/* 0x0c94	     */		nop

! Registers live out of .L900001118: 
! o1 o5 sp l2 l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001116

			.L900000942:
/* 0x0c98	 656 */		subcc	%l7,4,%l7

! Registers live out of .L900000942: 
! o1 o5 sp l2 l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000942 .L900001133

			.L900001133:
/* 0x0c9c	 656 */		ld	[%o1],%f1
/* 0x0ca0	     */		add	%o1,4,%o1
/* 0x0ca4	     */		st	%f1,[%l2]
/* 0x0ca8	     */		add	%l2,4,%l2
/* 0x0cac	     */		bge,a	.L900001133
/* 0x0cb0	     */		subcc	%l7,4,%l7

! Registers live out of .L900001133: 
! o1 o5 sp l2 l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001118 .L900001133

			.L900000943:
/* 0x0cb4	 656 */		add	%l7,4,%o2

! Registers live out of .L900000943: 
! o1 o2 o5 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000941 .L900000943

			.L900000944:
/* 0x0cb8	 656 */		andcc	%o5,3,%g0
/* 0x0cbc	     */		be	.L77004044
/* 0x0cc0	     */		subcc	%o2,1,%o2

! Registers live out of .L900000944: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000944

			.L900000945:
/* 0x0cc4	 656 */		ldub	[%o1],%i3
/* 0x0cc8	     */		ble	.L77004044
/* 0x0ccc	     */		stb	%i3,[%l2]

! Registers live out of .L900000945: 
! o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000945

			.L900000946:
/* 0x0cd0	 656 */		ldub	[%o1+1],%g5
/* 0x0cd4	     */		subcc	%o2,1,%o2
/* 0x0cd8	     */		ble	.L77004044
/* 0x0cdc	     */		stb	%g5,[%l2+1]

! Registers live out of .L900000946: 
! o1 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000946

			.L900000947:
/* 0x0ce0	 656 */		ldub	[%o1+2],%o0
/* 0x0ce4	     */		stb	%o0,[%l2+2]
/* 0x0ce8	 634 */		ret	! Result = 
/* 0x0cec	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004033

			.L900000948:
/* 0x0cf0	 656 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0cf4	     */		or	%g0,%i2,%o0
/* 0x0cf8	 634 */		ret	! Result = 
/* 0x0cfc	     */		restore	%g0,0,%g0

!  657		      !	 break;
!  658		      !      case GL_PIXEL_MAP_B_TO_B:
!  659		      !         MEMCPY(values,ctx->Pixel.MapBtoB,ctx->Pixel.MapBtoBsize*sizeof(GLfloat))
!  659		      >;

                       
! predecessor blocks: .L900001054

			.L77004035:
/* 0x0d00	 659 */		add	%o3,632,%o2
/* 0x0d04	     */		sethi	%hi(0xcc00),%l6
/* 0x0d08	     */		add	%l6,640,%g3
/* 0x0d0c	     */		ld	[%i0+%o2],%g1
/* 0x0d10	     */		add	%i0,%g3,%o1
/* 0x0d14	     */		sll	%g1,2,%g2
/* 0x0d18	     */		cmp	%g2,32
/* 0x0d1c	     */		bg	.L900000932
/* 0x0d20	     */		or	%g0,%g2,%o2

! Registers live out of .L77004035: 
! g2 o0 o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004035

			.L900000920:
/* 0x0d24	 659 */		and	%o1,3,%g1
/* 0x0d28	     */		and	%i2,3,%l3
/* 0x0d2c	     */		orcc	%l3,%g1,%g0
/* 0x0d30	     */		be	.L900000925
/* 0x0d34	     */		or	%g0,%i2,%l1

! Registers live out of .L900000920: 
! g2 o1 o2 sp l1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000920

			.L900000921:
/* 0x0d38	 659 */		subcc	%g2,2,%o2
/* 0x0d3c	     */		bl	.L900000923
/* 0x0d40	     */		srl	%g2,31,%o0

! Registers live out of .L900000921: 
! g2 o0 o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000921

			.L900001060:
/* 0x0d44	 659 */		add	%g2,%o0,%i3
/* 0x0d48	     */		sra	%i3,1,%i2
/* 0x0d4c	     */		cmp	%i2,1
/* 0x0d50	     */		bl	.L900000922
/* 0x0d54	     */		nop

! Registers live out of .L900001060: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001060

			.L900001061:
/* 0x0d58	 659 */		or	%g0,%o2,%o4
/* 0x0d5c	     */		or	%g0,%o1,%o3

! Registers live out of .L900001061: 
! o3 o4 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001059 .L900001061

			.L900001059:
/* 0x0d60	 659 */		sub	%o4,2,%o4
/* 0x0d64	     */		add	%l1,2,%l1
/* 0x0d68	     */		ldub	[%o3],%i4
/* 0x0d6c	     */		cmp	%o4,0
/* 0x0d70	     */		add	%o3,2,%o3
/* 0x0d74	     */		stb	%i4,[%l1-2]
/* 0x0d78	     */		ldub	[%o3-1],%g2
/* 0x0d7c	     */		bge	.L900001059
/* 0x0d80	     */		stb	%g2,[%l1-1]

! Registers live out of .L900001059: 
! o3 o4 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001059

			.L900001062:
/* 0x0d84	 659 */		or	%g0,%o4,%o2
/* 0x0d88	     */		or	%g0,%o3,%o1
/* 0x0d8c	     */		ba	.L900000923
/* 0x0d90	     */		nop

! Registers live out of .L900001062: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001060

			.L900000922:
/* 0x0d94	 659 */		subcc	%o2,2,%o2

! Registers live out of .L900000922: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000922 .L900001132

			.L900001132:
/* 0x0d98	 659 */		ldub	[%o1],%i4
/* 0x0d9c	     */		stb	%i4,[%l1]
/* 0x0da0	     */		ldub	[%o1+1],%g2
/* 0x0da4	     */		add	%o1,2,%o1
/* 0x0da8	     */		stb	%g2,[%l1+1]
/* 0x0dac	     */		add	%l1,2,%l1
/* 0x0db0	     */		bge,a	.L900001132
/* 0x0db4	     */		subcc	%o2,2,%o2

! Registers live out of .L900001132: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000921 .L900001062 .L900001132

			.L900000923:
/* 0x0db8	 659 */		cmp	%o2,-1
/* 0x0dbc	     */		bl	.L77004044
/* 0x0dc0	     */		nop

! Registers live out of .L900000923: 
! o1 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000923

			.L900000924:
/* 0x0dc4	 659 */		ldub	[%o1],%o2
/* 0x0dc8	     */		stb	%o2,[%l1]
/* 0x0dcc	 634 */		ret	! Result = 
/* 0x0dd0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000920

			.L900000925:
/* 0x0dd4	 659 */		subcc	%g2,4,%i4
/* 0x0dd8	     */		bl	.L900000928
/* 0x0ddc	     */		sra	%g2,1,%o0

! Registers live out of .L900000925: 
! g2 o0 o1 o2 sp l1 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000925

			.L900001120:
/* 0x0de0	 659 */		srl	%o0,30,%l5
/* 0x0de4	     */		add	%g2,%l5,%g4
/* 0x0de8	     */		sra	%g4,2,%l3
/* 0x0dec	     */		cmp	%l3,1
/* 0x0df0	     */		bl	.L900000926
/* 0x0df4	     */		nop

! Registers live out of .L900001120: 
! g2 o1 sp l1 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001120

			.L900001121:
/* 0x0df8	 659 */		or	%g0,%o1,%o5

! Registers live out of .L900001121: 
! g2 o5 sp i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001119 .L900001121

			.L900001119:
/* 0x0dfc	 659 */		sub	%i4,4,%i4
/* 0x0e00	     */		add	%i2,4,%i2
/* 0x0e04	     */		ld	[%o5],%f3
/* 0x0e08	     */		cmp	%i4,0
/* 0x0e0c	     */		add	%o5,4,%o5
/* 0x0e10	     */		bge	.L900001119
/* 0x0e14	     */		st	%f3,[%i2-4]

! Registers live out of .L900001119: 
! g2 o5 sp i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001119

			.L900001122:
/* 0x0e18	 659 */		or	%g0,%i2,%l1
/* 0x0e1c	     */		or	%g0,%o5,%o1
/* 0x0e20	     */		ba	.L900000927
/* 0x0e24	     */		nop

! Registers live out of .L900001122: 
! g2 o1 sp l1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001120

			.L900000926:
/* 0x0e28	 659 */		subcc	%i4,4,%i4

! Registers live out of .L900000926: 
! g2 o1 sp l1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000926 .L900001131

			.L900001131:
/* 0x0e2c	 659 */		ld	[%o1],%f3
/* 0x0e30	     */		add	%o1,4,%o1
/* 0x0e34	     */		st	%f3,[%l1]
/* 0x0e38	     */		add	%l1,4,%l1
/* 0x0e3c	     */		bge,a	.L900001131
/* 0x0e40	     */		subcc	%i4,4,%i4

! Registers live out of .L900001131: 
! g2 o1 sp l1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001122 .L900001131

			.L900000927:
/* 0x0e44	 659 */		add	%i4,4,%o2

! Registers live out of .L900000927: 
! g2 o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000925 .L900000927

			.L900000928:
/* 0x0e48	 659 */		andcc	%g2,3,%g0
/* 0x0e4c	     */		be	.L77004044
/* 0x0e50	     */		subcc	%o2,1,%o2

! Registers live out of .L900000928: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000928

			.L900000929:
/* 0x0e54	 659 */		ldub	[%o1],%g3
/* 0x0e58	     */		ble	.L77004044
/* 0x0e5c	     */		stb	%g3,[%l1]

! Registers live out of .L900000929: 
! o1 o2 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000929

			.L900000930:
/* 0x0e60	 659 */		ldub	[%o1+1],%l5
/* 0x0e64	     */		subcc	%o2,1,%o2
/* 0x0e68	     */		ble	.L77004044
/* 0x0e6c	     */		stb	%l5,[%l1+1]

! Registers live out of .L900000930: 
! o1 sp l1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000930

			.L900000931:
/* 0x0e70	 659 */		ldub	[%o1+2],%l6
/* 0x0e74	     */		stb	%l6,[%l1+2]
/* 0x0e78	 634 */		ret	! Result = 
/* 0x0e7c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004035

			.L900000932:
/* 0x0e80	 659 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x0e84	     */		or	%g0,%i2,%o0
/* 0x0e88	 634 */		ret	! Result = 
/* 0x0e8c	     */		restore	%g0,0,%g0

!  660		      !	 break;
!  661		      !      case GL_PIXEL_MAP_A_TO_A:
!  662		      !         MEMCPY(values,ctx->Pixel.MapAtoA,ctx->Pixel.MapAtoAsize*sizeof(GLfloat))
!  662		      >;

                       
! predecessor blocks: .L900001054

			.L77004037:
/* 0x0e90	 662 */		add	%o3,636,%i5
/* 0x0e94	     */		sethi	%hi(0xd000),%i3
/* 0x0e98	     */		add	%i3,640,%g4
/* 0x0e9c	     */		ld	[%i0+%i5],%i2
/* 0x0ea0	     */		add	%i0,%g4,%o1
/* 0x0ea4	     */		sll	%i2,2,%l5
/* 0x0ea8	     */		cmp	%l5,32
/* 0x0eac	     */		bg	.L900000916
/* 0x0eb0	     */		or	%g0,%l5,%o2

! Registers live out of .L77004037: 
! o0 o1 o2 sp l5 l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004037

			.L900000904:
/* 0x0eb4	 662 */		and	%l7,3,%l0
/* 0x0eb8	     */		and	%o1,3,%l1
/* 0x0ebc	     */		orcc	%l0,%l1,%g0
/* 0x0ec0	     */		be	.L900000909
/* 0x0ec4	     */		or	%g0,%l7,%l0

! Registers live out of .L900000904: 
! o1 o2 sp l0 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000904

			.L900000905:
/* 0x0ec8	 662 */		subcc	%l5,2,%o2
/* 0x0ecc	     */		bl	.L900000907
/* 0x0ed0	     */		sub	%o2,-2,%g4

! Registers live out of .L900000905: 
! g4 o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000905

			.L900001056:
/* 0x0ed4	 662 */		srl	%g4,31,%i1
/* 0x0ed8	     */		add	%g4,%i1,%i5
/* 0x0edc	     */		sra	%i5,1,%l6
/* 0x0ee0	     */		cmp	%l6,1
/* 0x0ee4	     */		bl	.L900000906
/* 0x0ee8	     */		nop

! Registers live out of .L900001056: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001055 .L900001056

			.L900001055:
/* 0x0eec	 662 */		sub	%o2,2,%o2
/* 0x0ef0	     */		add	%l0,2,%l0
/* 0x0ef4	     */		ldub	[%o1],%o4
/* 0x0ef8	     */		cmp	%o2,0
/* 0x0efc	     */		add	%o1,2,%o1
/* 0x0f00	     */		stb	%o4,[%l0-2]
/* 0x0f04	     */		ldub	[%o1-1],%o3
/* 0x0f08	     */		bge	.L900001055
/* 0x0f0c	     */		stb	%o3,[%l0-1]

! Registers live out of .L900001055: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001055

			.L900001058:
/* 0x0f10	 662 */		ba	.L900000907
/* 0x0f14	     */		nop

! Registers live out of .L900001058: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001056

			.L900000906:
/* 0x0f18	 662 */		subcc	%o2,2,%o2

! Registers live out of .L900000906: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000906 .L900001130

			.L900001130:
/* 0x0f1c	 662 */		ldub	[%o1],%o4
/* 0x0f20	     */		stb	%o4,[%l0]
/* 0x0f24	     */		ldub	[%o1+1],%o3
/* 0x0f28	     */		add	%o1,2,%o1
/* 0x0f2c	     */		stb	%o3,[%l0+1]
/* 0x0f30	     */		add	%l0,2,%l0
/* 0x0f34	     */		bge,a	.L900001130
/* 0x0f38	     */		subcc	%o2,2,%o2

! Registers live out of .L900001130: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000905 .L900001058 .L900001130

			.L900000907:
/* 0x0f3c	 662 */		cmp	%o2,-1
/* 0x0f40	     */		bl	.L77004044
/* 0x0f44	     */		nop

! Registers live out of .L900000907: 
! o1 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000907

			.L900000908:
/* 0x0f48	 662 */		ldub	[%o1],%o5
/* 0x0f4c	     */		stb	%o5,[%l0]
/* 0x0f50	 634 */		ret	! Result = 
/* 0x0f54	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000904

			.L900000909:
/* 0x0f58	 662 */		subcc	%l5,4,%i0
/* 0x0f5c	     */		bl	.L900000912
/* 0x0f60	     */		sra	%l5,1,%i2

! Registers live out of .L900000909: 
! o1 o2 sp l0 l5 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000909

			.L900001124:
/* 0x0f64	 662 */		srl	%i2,30,%l7
/* 0x0f68	     */		add	%l5,%l7,%i5
/* 0x0f6c	     */		sra	%i5,2,%l6
/* 0x0f70	     */		cmp	%l6,1
/* 0x0f74	     */		bl	.L900000910
/* 0x0f78	     */		nop

! Registers live out of .L900001124: 
! o1 sp l0 l5 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001124

			.L900001125:
/* 0x0f7c	 662 */		or	%g0,%l0,%i3
/* 0x0f80	     */		or	%g0,%o1,%o7

! Registers live out of .L900001125: 
! sp o7 l5 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001123 .L900001125

			.L900001123:
/* 0x0f84	 662 */		sub	%i0,4,%i0
/* 0x0f88	     */		add	%i3,4,%i3
/* 0x0f8c	     */		ld	[%o7],%f9
/* 0x0f90	     */		cmp	%i0,0
/* 0x0f94	     */		add	%o7,4,%o7
/* 0x0f98	     */		bge	.L900001123
/* 0x0f9c	     */		st	%f9,[%i3-4]

! Registers live out of .L900001123: 
! sp o7 l5 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001123

			.L900001126:
/* 0x0fa0	 662 */		or	%g0,%i3,%l0
/* 0x0fa4	     */		or	%g0,%o7,%o1
/* 0x0fa8	     */		ba	.L900000911
/* 0x0fac	     */		nop

! Registers live out of .L900001126: 
! o1 sp l0 l5 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001124

			.L900000910:
/* 0x0fb0	 662 */		subcc	%i0,4,%i0

! Registers live out of .L900000910: 
! o1 sp l0 l5 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000910 .L900001129

			.L900001129:
/* 0x0fb4	 662 */		ld	[%o1],%f9
/* 0x0fb8	     */		add	%o1,4,%o1
/* 0x0fbc	     */		st	%f9,[%l0]
/* 0x0fc0	     */		add	%l0,4,%l0
/* 0x0fc4	     */		bge,a	.L900001129
/* 0x0fc8	     */		subcc	%i0,4,%i0

! Registers live out of .L900001129: 
! o1 sp l0 l5 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001126 .L900001129

			.L900000911:
/* 0x0fcc	 662 */		add	%i0,4,%o2

! Registers live out of .L900000911: 
! o1 o2 sp l0 l5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000909 .L900000911

			.L900000912:
/* 0x0fd0	 662 */		andcc	%l5,3,%g0
/* 0x0fd4	     */		be	.L77004044
/* 0x0fd8	     */		subcc	%o2,1,%o2

! Registers live out of .L900000912: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000912

			.L900000913:
/* 0x0fdc	 662 */		ldub	[%o1],%l2
/* 0x0fe0	     */		ble	.L77004044
/* 0x0fe4	     */		stb	%l2,[%l0]

! Registers live out of .L900000913: 
! o1 o2 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000913

			.L900000914:
/* 0x0fe8	 662 */		ldub	[%o1+1],%o7
/* 0x0fec	     */		subcc	%o2,1,%o2
/* 0x0ff0	     */		ble	.L77004044
/* 0x0ff4	     */		stb	%o7,[%l0+1]

! Registers live out of .L900000914: 
! o1 sp l0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000914

			.L900000915:
/* 0x0ff8	 662 */		ldub	[%o1+2],%o1
/* 0x0ffc	     */		stb	%o1,[%l0+2]
/* 0x1000	 634 */		ret	! Result = 
/* 0x1004	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004037

			.L900000916:
/* 0x1008	 662 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x100c	     */		or	%g0,%l7,%o0

! Registers live out of .L900000916: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004003 .L77004013 .L900000907 .L900000912 .L900000913 .L900000914 .L900000916 .L900000923 .L900000928 .L900000929
! predecessor blocks: .L900000930 .L900000939 .L900000944 .L900000945 .L900000946 .L900000955 .L900000960 .L900000961 .L900000962 .L900000971 .L900000976
! predecessor blocks: .L900000977 .L900000978 .L900000987 .L900000992 .L900000993 .L900000994 .L900001003 .L900001008 .L900001009 .L900001010 .L900001019
! predecessor blocks: .L900001024 .L900001025 .L900001026 .L900001145 .L900001148

			.L77004044:
/* 0x1010	 634 */		ret	! Result = 
/* 0x1014	     */		restore	%g0,0,%g0

!  663		      !	 break;
!  664		      !      default:
!  665		      !         gl_error( ctx, GL_INVALID_ENUM, "glGetPixelMapfv" );

                       
! predecessor blocks: .L77004041 .L900001054

			.L77004039:
/* 0x1018	 665 */		sethi	%hi(.L465),%g5
/* 0x101c	     */		add	%g5,%lo(.L465),%i2
/* 0x1020	     */		or	%g0,1280,%i1
/* 0x1024	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x1028	     */		restore	%g0,0,%g0
/* 0x102c	   0 */		.type	gl_GetPixelMapfv,2
/* 0x102c	   0 */		.size	gl_GetPixelMapfv,(.-gl_GetPixelMapfv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900001201:
/* 000000	   0 */		.word	(.L77004127-(___const_seg_900001201+0x0))
/* 0x0004	     */		.word	(.L77004129-(___const_seg_900001201+0x0))
/* 0x0008	     */		.word	(.L77004131-(___const_seg_900001201+0x0))
/* 0x000c	     */		.word	(.L77004141-(___const_seg_900001201+0x0))
/* 0x0010	     */		.word	(.L77004151-(___const_seg_900001201+0x0))
/* 0x0014	     */		.word	(.L77004161-(___const_seg_900001201+0x0))
/* 0x0018	     */		.word	(.L77004171-(___const_seg_900001201+0x0))
/* 0x001c	     */		.word	(.L77004181-(___const_seg_900001201+0x0))
/* 0x0020	     */		.word	(.L77004191-(___const_seg_900001201+0x0))
/* 0x0024	     */		.word	(.L77004201-(___const_seg_900001201+0x0))
/* 0x0028	   0 */		.word	1106247679,-2097152
/* 0x0030	     */		.word	1105199104,0
/* 0x0038	   0 */		.type	___const_seg_900001201,1
/* 0x0038	   0 */		.size	___const_seg_900001201,(.-___const_seg_900001201)
/* 0x0038	   0 */		.align	4

!  666		      !   }
!  667		      !}
!  670		      !void gl_GetPixelMapuiv( GLcontext *ctx, GLenum map, GLuint *values )
!  671		      !{

!
! SUBROUTINE gl_GetPixelMapuiv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_GetPixelMapuiv
                       

			gl_GetPixelMapuiv:
/* 000000	 671 */		save	%sp,-1096,%sp

!  672		      !   GLuint i;
!  674		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 674 */		sethi	%hi(0xe000),%i5
/* 0x0008	     */		add	%i5,252,%o0
/* 0x000c	     */		sethi	%hi(0x1800),%i3
/* 0x0010	     */		ld	[%i0+%o0],%i5
/* 0x0014	     */		add	%i3,512,%g5
/* 0x0018	     */		cmp	%i5,%g5
/* 0x001c	     */		be,pn	%icc,.L900001404
/* 0x0020	 678 */		sub	%i1,3184,%l7

! Registers live out of gl_GetPixelMapuiv: 
! o0 sp l2 l6 l7 i0 i2 fp i7 gsr y
! f0 f2 f4 f6 f8 f10 f12 f14 f18 f20 f22 f24 f30 
		
!  675		      !      gl_error( ctx, GL_INVALID_OPERATION, "glGetPixelMapfv" );

                       
! predecessor blocks: gl_GetPixelMapuiv

			.L77004123:
/* 0x0024	 675 */		sethi	%hi(.L474),%i2
/* 0x0028	     */		or	%g0,1282,%i1
/* 0x002c	     */		add	%i2,%lo(.L474),%i2
/* 0x0030	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0034	     */		restore	%g0,0,%g0

!  676		      !      return;
!  677		      !   }
!  678		      !   switch (map) {

                       
! predecessor blocks: gl_GetPixelMapuiv

			.L900001404:
/* 0x0038	 678 */		cmp	%l7,9
/* 0x003c	     */		bgu,pn	%icc,.L77004211
/* 0x0040	     */		sethi	%hi(___const_seg_900001201),%g1

! Registers live out of .L900001404: 
! g1 o0 sp l2 l6 l7 i0 i2 fp i7 gsr y
! f0 f2 f4 f6 f8 f10 f12 f14 f18 f20 f22 f24 f30 
		                       
! predecessor blocks: .L900001404

			.L900001326:
/* 0x0044	 678 */		add	%g1,%lo(___const_seg_900001201),%i3
/* 0x0048	     */		sll	%l7,2,%o5
/* 0x004c	   0 */		sethi	%hi(0xac00),%g5
/* 0x0050	   0 */		sethi	%hi(0x7ffffc00),%g2
/* 0x0054	 678 */		ld	[%o5+%i3],%o4
/* 0x0058	     */		jmpl	%o4+%i3,%g0
/* 0x005c	     */		nop

! Registers live out of .L900001326: 
! g2 g5 o0 sp l2 l6 i0 i2 i3 fp i7 gsr y
! f0 f2 f4 f6 f8 f10 f12 f14 f18 f20 f22 f24 f30 
		
!  679		      !      case GL_PIXEL_MAP_I_TO_I:
!  680		      !         MEMCPY(values, ctx->Pixel.MapItoI, ctx->Pixel.MapItoIsize*sizeof(GLint))
!  680		      >;

                       
! predecessor blocks: .L900001326

			.L77004127:
/* 0x0060	 680 */		sethi	%hi(0xb000),%l6
/* 0x0064	     */		add	%l6,640,%i1
/* 0x0068	     */		add	%g5,604,%i3
/* 0x006c	     */		add	%i0,%i1,%o1
/* 0x0070	     */		ld	[%i0+%i3],%i0
/* 0x0074	     */		sll	%i0,2,%l6
/* 0x0078	     */		cmp	%l6,32
/* 0x007c	     */		bg	.L900001232
/* 0x0080	     */		or	%g0,%l6,%o2

! Registers live out of .L77004127: 
! o0 o1 o2 sp l6 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004127

			.L900001220:
/* 0x0084	 680 */		and	%o1,3,%i3
/* 0x0088	     */		and	%i2,3,%g5
/* 0x008c	     */		orcc	%g5,%i3,%g0
/* 0x0090	     */		be	.L900001225
/* 0x0094	     */		or	%g0,%i2,%l7

! Registers live out of .L900001220: 
! o1 o2 sp l6 l7 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001220

			.L900001221:
/* 0x0098	 680 */		subcc	%l6,2,%o2
/* 0x009c	     */		bl	.L900001223
/* 0x00a0	     */		sub	%o2,-2,%g3

! Registers live out of .L900001221: 
! g3 o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001221

			.L900001332:
/* 0x00a4	 680 */		srl	%g3,31,%g2
/* 0x00a8	     */		add	%g3,%g2,%g1
/* 0x00ac	     */		sra	%g1,1,%i2
/* 0x00b0	     */		cmp	%i2,1
/* 0x00b4	     */		bl	.L900001222
/* 0x00b8	     */		nop

! Registers live out of .L900001332: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001332

			.L900001333:
/* 0x00bc	 680 */		or	%g0,%o2,%o4
/* 0x00c0	     */		or	%g0,%o1,%o3

! Registers live out of .L900001333: 
! o3 o4 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001331 .L900001333

			.L900001331:
/* 0x00c4	 680 */		sub	%o4,2,%o4
/* 0x00c8	     */		add	%l7,2,%l7
/* 0x00cc	     */		ldub	[%o3],%o0
/* 0x00d0	     */		cmp	%o4,0
/* 0x00d4	     */		add	%o3,2,%o3
/* 0x00d8	     */		stb	%o0,[%l7-2]
/* 0x00dc	     */		ldub	[%o3-1],%i2
/* 0x00e0	     */		bge	.L900001331
/* 0x00e4	     */		stb	%i2,[%l7-1]

! Registers live out of .L900001331: 
! o3 o4 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001331

			.L900001334:
/* 0x00e8	 680 */		or	%g0,%o4,%o2
/* 0x00ec	     */		or	%g0,%o3,%o1
/* 0x00f0	     */		ba	.L900001223
/* 0x00f4	     */		nop

! Registers live out of .L900001334: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001332

			.L900001222:
/* 0x00f8	 680 */		subcc	%o2,2,%o2

! Registers live out of .L900001222: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001222 .L900001403

			.L900001403:
/* 0x00fc	 680 */		ldub	[%o1],%o0
/* 0x0100	     */		stb	%o0,[%l7]
/* 0x0104	     */		ldub	[%o1+1],%i2
/* 0x0108	     */		add	%o1,2,%o1
/* 0x010c	     */		stb	%i2,[%l7+1]
/* 0x0110	     */		add	%l7,2,%l7
/* 0x0114	     */		bge,a	.L900001403
/* 0x0118	     */		subcc	%o2,2,%o2

! Registers live out of .L900001403: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001221 .L900001334 .L900001403

			.L900001223:
/* 0x011c	 680 */		cmp	%o2,-1
/* 0x0120	     */		bl	.L77004216
/* 0x0124	     */		nop

! Registers live out of .L900001223: 
! o1 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001223

			.L900001224:
/* 0x0128	 680 */		ldub	[%o1],%g5
/* 0x012c	     */		stb	%g5,[%l7]
/* 0x0130	 689 */		ret	! Result = 
/* 0x0134	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900001220

			.L900001225:
/* 0x0138	 680 */		subcc	%l6,4,%i4
/* 0x013c	     */		bl	.L900001228
/* 0x0140	     */		sra	%l6,1,%l2

! Registers live out of .L900001225: 
! o1 o2 sp l2 l6 l7 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001225

			.L900001336:
/* 0x0144	 680 */		srl	%l2,30,%l1
/* 0x0148	     */		add	%l6,%l1,%o0
/* 0x014c	     */		sra	%o0,2,%g5
/* 0x0150	     */		cmp	%g5,1
/* 0x0154	     */		bl	.L900001226
/* 0x0158	     */		nop

! Registers live out of .L900001336: 
! o1 sp l6 l7 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001336

			.L900001337:
/* 0x015c	 680 */		or	%g0,%i2,%i1
/* 0x0160	     */		or	%g0,%o1,%o5

! Registers live out of .L900001337: 
! o5 sp l6 i1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001335 .L900001337

			.L900001335:
/* 0x0164	 680 */		sub	%i4,4,%i4
/* 0x0168	     */		add	%i1,4,%i1
/* 0x016c	     */		ld	[%o5],%f0
/* 0x0170	     */		cmp	%i4,0
/* 0x0174	     */		add	%o5,4,%o5
/* 0x0178	     */		bge	.L900001335
/* 0x017c	     */		st	%f0,[%i1-4]

! Registers live out of .L900001335: 
! o5 sp l6 i1 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001335

			.L900001338:
/* 0x0180	 680 */		or	%g0,%i1,%l7
/* 0x0184	     */		or	%g0,%o5,%o1
/* 0x0188	     */		ba	.L900001227
/* 0x018c	     */		nop

! Registers live out of .L900001338: 
! o1 sp l6 l7 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001336

			.L900001226:
/* 0x0190	 680 */		subcc	%i4,4,%i4

! Registers live out of .L900001226: 
! o1 sp l6 l7 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001226 .L900001402

			.L900001402:
/* 0x0194	 680 */		ld	[%o1],%f0
/* 0x0198	     */		add	%o1,4,%o1
/* 0x019c	     */		st	%f0,[%l7]
/* 0x01a0	     */		add	%l7,4,%l7
/* 0x01a4	     */		bge,a	.L900001402
/* 0x01a8	     */		subcc	%i4,4,%i4

! Registers live out of .L900001402: 
! o1 sp l6 l7 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001338 .L900001402

			.L900001227:
/* 0x01ac	 680 */		add	%i4,4,%o2

! Registers live out of .L900001227: 
! o1 o2 sp l6 l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001225 .L900001227

			.L900001228:
/* 0x01b0	 680 */		andcc	%l6,3,%g0
/* 0x01b4	     */		be	.L77004216
/* 0x01b8	     */		subcc	%o2,1,%o2

! Registers live out of .L900001228: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001228

			.L900001229:
/* 0x01bc	 680 */		ldub	[%o1],%i3
/* 0x01c0	     */		ble	.L77004216
/* 0x01c4	     */		stb	%i3,[%l7]

! Registers live out of .L900001229: 
! o1 o2 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001229

			.L900001230:
/* 0x01c8	 680 */		ldub	[%o1+1],%i5
/* 0x01cc	     */		subcc	%o2,1,%o2
/* 0x01d0	     */		ble	.L77004216
/* 0x01d4	     */		stb	%i5,[%l7+1]

! Registers live out of .L900001230: 
! o1 sp l7 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001230

			.L900001231:
/* 0x01d8	 680 */		ldub	[%o1+2],%i2
/* 0x01dc	     */		stb	%i2,[%l7+2]
/* 0x01e0	 689 */		ret	! Result = 
/* 0x01e4	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004127

			.L900001232:
/* 0x01e8	 680 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x01ec	     */		or	%g0,%i2,%o0
/* 0x01f0	 689 */		ret	! Result = 
/* 0x01f4	     */		restore	%g0,0,%g0

!  681		      !	 break;
!  682		      !      case GL_PIXEL_MAP_S_TO_S:
!  683		      !         MEMCPY(values, ctx->Pixel.MapStoS, ctx->Pixel.MapStoSsize*sizeof(GLint))
!  683		      >;

                       
! predecessor blocks: .L900001326

			.L77004129:
/* 0x01f8	 683 */		add	%g5,600,%l6
/* 0x01fc	     */		add	%g5,640,%g5
/* 0x0200	     */		add	%i0,%g5,%o1
/* 0x0204	     */		ld	[%i0+%l6],%i0
/* 0x0208	     */		sll	%i0,2,%i1
/* 0x020c	     */		cmp	%i1,32
/* 0x0210	     */		bg	.L900001216
/* 0x0214	     */		or	%g0,%i1,%o2

! Registers live out of .L77004129: 
! o0 o1 o2 sp i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004129

			.L900001204:
/* 0x0218	 683 */		and	%o1,3,%i3
/* 0x021c	     */		and	%i2,3,%g5
/* 0x0220	     */		orcc	%g5,%i3,%g0
/* 0x0224	     */		be	.L900001401
/* 0x0228	     */		subcc	%i1,4,%i5

! Registers live out of .L900001204: 
! o1 o2 sp i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001204

			.L900001205:
/* 0x022c	 683 */		subcc	%i1,2,%o2
/* 0x0230	     */		bl	.L900001207
/* 0x0234	     */		sub	%o2,-2,%o7

! Registers live out of .L900001205: 
! o1 o2 sp o7 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001205

			.L900001328:
/* 0x0238	 683 */		srl	%o7,31,%i3
/* 0x023c	     */		add	%o7,%i3,%i4
/* 0x0240	     */		sra	%i4,1,%i1
/* 0x0244	     */		cmp	%i1,1
/* 0x0248	     */		bl	.L900001206
/* 0x024c	     */		nop

! Registers live out of .L900001328: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001327 .L900001328

			.L900001327:
/* 0x0250	 683 */		sub	%o2,2,%o2
/* 0x0254	     */		add	%i2,2,%i2
/* 0x0258	     */		ldub	[%o1],%i5
/* 0x025c	     */		cmp	%o2,0
/* 0x0260	     */		add	%o1,2,%o1
/* 0x0264	     */		stb	%i5,[%i2-2]
/* 0x0268	     */		ldub	[%o1-1],%o0
/* 0x026c	     */		bge	.L900001327
/* 0x0270	     */		stb	%o0,[%i2-1]

! Registers live out of .L900001327: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001327

			.L900001330:
/* 0x0274	 683 */		ba	.L900001207
/* 0x0278	     */		nop

! Registers live out of .L900001330: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001328

			.L900001206:
/* 0x027c	 683 */		subcc	%o2,2,%o2

! Registers live out of .L900001206: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001206 .L900001400

			.L900001400:
/* 0x0280	 683 */		ldub	[%o1],%i5
/* 0x0284	     */		stb	%i5,[%i2]
/* 0x0288	     */		ldub	[%o1+1],%o0
/* 0x028c	     */		add	%o1,2,%o1
/* 0x0290	     */		stb	%o0,[%i2+1]
/* 0x0294	     */		add	%i2,2,%i2
/* 0x0298	     */		bge,a	.L900001400
/* 0x029c	     */		subcc	%o2,2,%o2

! Registers live out of .L900001400: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001205 .L900001330 .L900001400

			.L900001207:
/* 0x02a0	 683 */		cmp	%o2,-1
/* 0x02a4	     */		bl	.L77004216
/* 0x02a8	     */		nop

! Registers live out of .L900001207: 
! o1 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001207

			.L900001208:
/* 0x02ac	 683 */		ldub	[%o1],%g5
/* 0x02b0	     */		stb	%g5,[%i2]
/* 0x02b4	 689 */		ret	! Result = 
/* 0x02b8	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900001204

			.L900001401:
/* 0x02bc	 683 */		bl	.L900001212
/* 0x02c0	     */		sra	%i1,1,%i0

! Registers live out of .L900001401: 
! o1 o2 sp i0 i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001401

			.L900001340:
/* 0x02c4	 683 */		srl	%i0,30,%l6
/* 0x02c8	     */		add	%i1,%l6,%l4
/* 0x02cc	     */		sra	%l4,2,%l3
/* 0x02d0	     */		cmp	%l3,1
/* 0x02d4	     */		bl	.L900001210
/* 0x02d8	     */		nop

! Registers live out of .L900001340: 
! o1 sp i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001340

			.L900001341:
/* 0x02dc	 683 */		or	%g0,%i2,%i3
/* 0x02e0	     */		or	%g0,%o1,%o7

! Registers live out of .L900001341: 
! sp o7 i1 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001339 .L900001341

			.L900001339:
/* 0x02e4	 683 */		sub	%i5,4,%i5
/* 0x02e8	     */		add	%i3,4,%i3
/* 0x02ec	     */		ld	[%o7],%f2
/* 0x02f0	     */		cmp	%i5,0
/* 0x02f4	     */		add	%o7,4,%o7
/* 0x02f8	     */		bge	.L900001339
/* 0x02fc	     */		st	%f2,[%i3-4]

! Registers live out of .L900001339: 
! sp o7 i1 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001339

			.L900001342:
/* 0x0300	 683 */		or	%g0,%i3,%i2
/* 0x0304	     */		or	%g0,%o7,%o1
/* 0x0308	     */		ba	.L900001211
/* 0x030c	     */		nop

! Registers live out of .L900001342: 
! o1 sp i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001340

			.L900001210:
/* 0x0310	 683 */		subcc	%i5,4,%i5

! Registers live out of .L900001210: 
! o1 sp i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001210 .L900001399

			.L900001399:
/* 0x0314	 683 */		ld	[%o1],%f2
/* 0x0318	     */		add	%o1,4,%o1
/* 0x031c	     */		st	%f2,[%i2]
/* 0x0320	     */		add	%i2,4,%i2
/* 0x0324	     */		bge,a	.L900001399
/* 0x0328	     */		subcc	%i5,4,%i5

! Registers live out of .L900001399: 
! o1 sp i1 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001342 .L900001399

			.L900001211:
/* 0x032c	 683 */		add	%i5,4,%o2

! Registers live out of .L900001211: 
! o1 o2 sp i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001211 .L900001401

			.L900001212:
/* 0x0330	 683 */		andcc	%i1,3,%g0
/* 0x0334	     */		be	.L77004216
/* 0x0338	     */		subcc	%o2,1,%o2

! Registers live out of .L900001212: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001212

			.L900001213:
/* 0x033c	 683 */		ldub	[%o1],%i3
/* 0x0340	     */		ble	.L77004216
/* 0x0344	     */		stb	%i3,[%i2]

! Registers live out of .L900001213: 
! o1 o2 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001213

			.L900001214:
/* 0x0348	 683 */		ldub	[%o1+1],%o0
/* 0x034c	     */		subcc	%o2,1,%o2
/* 0x0350	     */		ble	.L77004216
/* 0x0354	     */		stb	%o0,[%i2+1]

! Registers live out of .L900001214: 
! o1 sp i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001214

			.L900001215:
/* 0x0358	 683 */		ldub	[%o1+2],%i5
/* 0x035c	     */		stb	%i5,[%i2+2]
/* 0x0360	 689 */		ret	! Result = 
/* 0x0364	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004129

			.L900001216:
/* 0x0368	 683 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x036c	     */		or	%g0,%i2,%o0
/* 0x0370	 689 */		ret	! Result = 
/* 0x0374	     */		restore	%g0,0,%g0

!  684		      !	 break;
!  685		      !      case GL_PIXEL_MAP_I_TO_R:
!  686		      !	 for (i=0;i<ctx->Pixel.MapItoRsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004131:
/* 0x0378	 686 */		add	%g5,608,%l1
/* 0x037c	     */		ld	[%i0+%l1],%o5
/* 0x0380	     */		orcc	%g0,%o5,%g0
/* 0x0384	     */		bleu,pn	%icc,.L77004216
/* 0x0388	     */		cmp	%o5,5

! Registers live out of .L77004131: 
! g2 o5 sp l1 l2 i0 i2 i3 fp i7 gsr y
! f0 
		                       
! predecessor blocks: .L77004131

			.L77004232:
/* 0x038c	 686 */		bl,pn	%icc,.L77004414
/* 0x0390	     */		add	%g2,1022,%o7

! Registers live out of .L77004232: 
! o5 sp o7 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 
		                       
! predecessor blocks: .L77004232

			.L77004279:
/* 0x0394	 686 */		add	%i0,%l1,%l7
/* 0x0398	     */		sll	%o5,2,%i4
/* 0x039c	     */		sub	%l7,%i2,%i5
/* 0x03a0	     */		sub	%i2,%l7,%l4
/* 0x03a4	     */		sra	%i4,0,%o3
/* 0x03a8	     */		sra	%i5,0,%g1
/* 0x03ac	     */		sub	%g1,%o3,%o0
/* 0x03b0	     */		sra	%l4,0,%o1
/* 0x03b4	     */		or	%g0,3,%g4
/* 0x03b8	     */		srlx	%o0,63,%g3
/* 0x03bc	     */		sub	%g4,%o1,%o4
/* 0x03c0	     */		sub	%o5,%o7,%g5
/* 0x03c4	     */		xor	%g3,1,%o2
/* 0x03c8	     */		srlx	%o4,63,%l3
/* 0x03cc	     */		srlx	%g5,63,%l6
/* 0x03d0	     */		or	%l3,%o2,%i1
/* 0x03d4	     */		andcc	%l6,%i1,%g0
/* 0x03d8	     */		be,a,pn	%icc,.L77004392
/* 0x03dc	     */		or	%g0,0,%l2

! Registers live out of .L77004279: 
! o5 sp l1 l2 i0 i2 i3 fp i7 gsr y
! f0 
		                       
! predecessor blocks: .L77004279

			.L77004345:
/* 0x03e0	 686 */		sethi	%hi(0xb400),%l2
/* 0x03e4	     */		add	%l2,640,%l1
/* 0x03e8	     */		add	%i0,%l1,%i0
/* 0x03ec	     */		ldd	[%i3+40],%f58
/* 0x03f0	     */		add	%o5,-1,%i5

!  687		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapItoR[i] );

/* 0x03f4	 687 */		ld	[%i0],%f4
/* 0x03f8	 686 */		or	%g0,0,%o7

! Registers live out of .L77004345: 
! sp o7 i0 i2 i3 i5 fp i7 gsr 
! f4 f26 
		                       
! predecessor blocks: .L77004345 .L900001397

			.L900001396:
/* 0x03fc	 687 */		fstod	%f4,%f32
/* 0x0400	     */		ldd	[%i3+48],%f34
/* 0x0404	     */		fmuld	%f32,%f58,%f36
/* 0x0408	     */		fcmpd	%f36,%f34
/* 0x040c	     */		fbuge,a,pn	%fcc0,.L900001398
/* 0x0410	     */		fsubd	%f36,%f34,%f32

! Registers live out of .L900001396: 
! sp o7 i0 i2 i3 i5 fp i7 gsr y
! f0 f4 f26 
		                       
! predecessor blocks: .L900001396

			.L900001321:
/* 0x0414	 687 */		fdtoi	%f36,%f2
/* 0x0418	     */		st	%f2,[%sp+640]
/* 0x041c	     */		ld	[%sp+640],%o1
/* 0x0420	     */		ba	.L900001397
/* 0x0424	 686 */		add	%o7,1,%o7

! Registers live out of .L900001321: 
! o1 sp o7 i0 i2 i3 i5 fp i7 gsr 
! f4 f26 
		                       
! predecessor blocks: .L900001396

			.L900001398:
/* 0x0428	 687 */		fdtoi	%f32,%f0
/* 0x042c	     */		st	%f0,[%sp+960]
/* 0x0430	     */		ld	[%sp+960],%o2
/* 0x0434	     */		sethi	%hi(0x80000000),%o3
/* 0x0438	 686 */		add	%o7,1,%o7
/* 0x043c	 687 */		or	%o2,%o3,%o1

! Registers live out of .L900001398: 
! o1 sp o7 i0 i2 i3 i5 fp i7 gsr 
! f4 f26 
		                       
! predecessor blocks: .L900001321 .L900001398

			.L900001397:
/* 0x0440	 687 */		st	%o1,[%i2]
/* 0x0444	 686 */		cmp	%o7,%i5
/* 0x0448	     */		add	%i0,4,%i0
/* 0x044c	     */		add	%i2,4,%i2
/* 0x0450	     */		ble,a,pt	%icc,.L900001396
/* 0x0454	 687 */		ld	[%i0],%f4

! Registers live out of .L900001397: 
! sp o7 i0 i2 i3 i5 fp i7 gsr 
! f4 f26 
		                       
! predecessor blocks: .L900001397

			.L77004276:
/* 0x0458	 689 */		ret	! Result = 
/* 0x045c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004232

			.L77004414:
/* 0x0460	 686 */		or	%g0,0,%l2

! Registers live out of .L77004414: 
! sp l1 l2 i0 i2 i3 fp i7 gsr y
! f0 
		                       
! predecessor blocks: .L77004279 .L77004414

			.L77004392:
/* 0x0464	 686 */		sethi	%hi(0xb400),%g5
/* 0x0468	     */		add	%g5,640,%i5
/* 0x046c	 687 */		sll	%l2,2,%l0
/* 0x0470	 686 */		ldd	[%i3+40],%f52
/* 0x0474	 687 */		add	%i0,%i5,%o7

! Registers live out of .L77004392: 
! sp o7 l0 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 f20 
		                       
! predecessor blocks: .L77004392 .L900001393

			.L900001392:
/* 0x0478	 687 */		ld	[%o7+%l0],%f24
/* 0x047c	     */		ldd	[%i3+48],%f48
/* 0x0480	     */		fstod	%f24,%f46
/* 0x0484	     */		fmuld	%f46,%f52,%f50
/* 0x0488	     */		fcmpd	%f50,%f48
/* 0x048c	     */		fbuge,a,pn	%fcc0,.L900001394
/* 0x0490	     */		fsubd	%f50,%f48,%f32

! Registers live out of .L900001392: 
! sp o7 l0 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 f18 f20 
		                       
! predecessor blocks: .L900001392

			.L900001317:
/* 0x0494	 687 */		fdtoi	%f50,%f6
/* 0x0498	     */		st	%f6,[%sp+160]
/* 0x049c	     */		ba	.L900001393
/* 0x04a0	     */		st	%f6,[%l0+%i2]

! Registers live out of .L900001317: 
! sp o7 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 f20 
		                       
! predecessor blocks: .L900001392

			.L900001394:
/* 0x04a4	 687 */		fdtoi	%f32,%f4
/* 0x04a8	     */		st	%f4,[%sp+128]
/* 0x04ac	     */		ld	[%sp+128],%l4
/* 0x04b0	     */		sethi	%hi(0x80000000),%l5
/* 0x04b4	     */		or	%l4,%l5,%l3
/* 0x04b8	     */		st	%l3,[%l0+%i2]

! Registers live out of .L900001394: 
! sp o7 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 f20 
		                       
! predecessor blocks: .L900001317 .L900001394

			.L900001393:
/* 0x04bc	 686 */		ld	[%i0+%l1],%l6
/* 0x04c0	     */		add	%l2,1,%l2
/* 0x04c4	     */		cmp	%l2,%l6
/* 0x04c8	     */		bcs,pt	%icc,.L900001392
/* 0x04cc	 687 */		sll	%l2,2,%l0

! Registers live out of .L900001393: 
! sp o7 l0 l1 l2 i0 i2 i3 fp i7 gsr y
! f0 f20 
		                       
! predecessor blocks: .L900001393

			.L900001260:
/* 0x04d0	 689 */		ret	! Result = 
/* 0x04d4	     */		restore	%g0,0,%g0

!  688		      !	 }
!  689		      !	 break;
!  690		      !      case GL_PIXEL_MAP_I_TO_G:
!  691		      !	 for (i=0;i<ctx->Pixel.MapItoGsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004141:
/* 0x04d8	 691 */		add	%g5,612,%l1
/* 0x04dc	     */		ld	[%i0+%l1],%o5
/* 0x04e0	     */		orcc	%g0,%o5,%g0
/* 0x04e4	     */		bleu,pn	%icc,.L77004216
/* 0x04e8	     */		cmp	%o5,5

! Registers live out of .L77004141: 
! g2 o5 sp l1 l2 i0 i2 i3 fp i7 gsr 
! f2 f4 
		                       
! predecessor blocks: .L77004141

			.L77004231:
/* 0x04ec	 691 */		bl,pn	%icc,.L77004416
/* 0x04f0	     */		add	%g2,1022,%g5

! Registers live out of .L77004231: 
! g5 o5 sp l1 l2 i0 i2 i3 fp i7 gsr 
! f2 f4 
		                       
! predecessor blocks: .L77004231

			.L77004271:
/* 0x04f4	 691 */		add	%i0,%l1,%l5
/* 0x04f8	     */		sll	%o5,2,%l7
/* 0x04fc	     */		sub	%l5,%i2,%i4
/* 0x0500	     */		sub	%i2,%l5,%l4
/* 0x0504	     */		sra	%l7,0,%g1
/* 0x0508	     */		sra	%i4,0,%o0
/* 0x050c	     */		sub	%o0,%g1,%g3
/* 0x0510	     */		sra	%l4,0,%o1
/* 0x0514	     */		or	%g0,3,%g4
/* 0x0518	     */		srlx	%g3,63,%i5
/* 0x051c	     */		sub	%g4,%o1,%o4
/* 0x0520	     */		sub	%o5,%g5,%o3
/* 0x0524	     */		xor	%i5,1,%o2
/* 0x0528	     */		srlx	%o4,63,%g2
/* 0x052c	     */		srlx	%o3,63,%i1
/* 0x0530	     */		or	%g2,%o2,%l3
/* 0x0534	     */		andcc	%i1,%l3,%g0
/* 0x0538	     */		be,a,pn	%icc,.L77004390
/* 0x053c	     */		or	%g0,0,%l2

! Registers live out of .L77004271: 
! o5 sp l1 l2 i0 i2 i3 fp i7 gsr 
! f2 f4 
		                       
! predecessor blocks: .L77004271

			.L77004343:
/* 0x0540	 691 */		sethi	%hi(0xb800),%i1
/* 0x0544	     */		add	%o5,-1,%o4
/* 0x0548	     */		add	%i1,640,%o0
/* 0x054c	     */		ldd	[%i3+40],%f44
/* 0x0550	     */		add	%i0,%o0,%o5

!  692		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapItoG[i] );

/* 0x0554	 692 */		ld	[%o5],%f6
/* 0x0558	 691 */		or	%g0,0,%l0

! Registers live out of .L77004343: 
! o4 o5 sp l0 i2 i3 fp i7 gsr 
! f2 f6 f12 
		                       
! predecessor blocks: .L77004343 .L900001390

			.L900001389:
/* 0x055c	 692 */		fstod	%f6,%f38
/* 0x0560	     */		ldd	[%i3+48],%f40
/* 0x0564	     */		fmuld	%f38,%f44,%f42
/* 0x0568	     */		fcmpd	%f42,%f40
/* 0x056c	     */		fbuge,a,pn	%fcc0,.L900001391
/* 0x0570	     */		fsubd	%f42,%f40,%f34

! Registers live out of .L900001389: 
! o4 o5 sp l0 i2 i3 fp i7 gsr 
! f2 f6 f10 f12 
		                       
! predecessor blocks: .L900001389

			.L900001313:
/* 0x0574	 692 */		fdtoi	%f42,%f10
/* 0x0578	     */		st	%f10,[%sp+768]
/* 0x057c	     */		ld	[%sp+768],%l1
/* 0x0580	     */		ba	.L900001390
/* 0x0584	 691 */		add	%l0,1,%l0

! Registers live out of .L900001313: 
! o4 o5 sp l0 l1 i2 i3 fp i7 gsr 
! f2 f6 f12 
		                       
! predecessor blocks: .L900001389

			.L900001391:
/* 0x0588	 692 */		fdtoi	%f34,%f8
/* 0x058c	     */		st	%f8,[%sp+736]
/* 0x0590	     */		ld	[%sp+736],%l2
/* 0x0594	     */		sethi	%hi(0x80000000),%i0
/* 0x0598	 691 */		add	%l0,1,%l0
/* 0x059c	 692 */		or	%l2,%i0,%l1

! Registers live out of .L900001391: 
! o4 o5 sp l0 l1 i2 i3 fp i7 gsr 
! f2 f6 f12 
		                       
! predecessor blocks: .L900001313 .L900001391

			.L900001390:
/* 0x05a0	 692 */		st	%l1,[%i2]
/* 0x05a4	 691 */		cmp	%l0,%o4
/* 0x05a8	     */		add	%o5,4,%o5
/* 0x05ac	     */		add	%i2,4,%i2
/* 0x05b0	     */		ble,a,pt	%icc,.L900001389
/* 0x05b4	 692 */		ld	[%o5],%f6

! Registers live out of .L900001390: 
! o4 o5 sp l0 i2 i3 fp i7 gsr 
! f2 f6 f12 
		                       
! predecessor blocks: .L900001390

			.L77004268:
/* 0x05b8	 689 */		ret	! Result = 
/* 0x05bc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004231

			.L77004416:
/* 0x05c0	 691 */		or	%g0,0,%l2

! Registers live out of .L77004416: 
! sp l1 l2 i0 i2 i3 fp i7 gsr 
! f4 
		                       
! predecessor blocks: .L77004271 .L77004416

			.L77004390:
/* 0x05c4	 691 */		sethi	%hi(0xb800),%o0
/* 0x05c8	     */		add	%o0,640,%l0
/* 0x05cc	 692 */		sll	%l2,2,%o7
/* 0x05d0	 691 */		ldd	[%i3+40],%f62
/* 0x05d4	 692 */		add	%i0,%l0,%l6

! Registers live out of .L77004390: 
! sp o7 l1 l2 l6 i0 i2 i3 fp i7 gsr 
! f4 f30 
		                       
! predecessor blocks: .L77004390 .L900001386

			.L900001385:
/* 0x05d8	 692 */		ld	[%l6+%o7],%f26
/* 0x05dc	     */		ldd	[%i3+48],%f56
/* 0x05e0	     */		fstod	%f26,%f54
/* 0x05e4	     */		fmuld	%f54,%f62,%f60
/* 0x05e8	     */		fcmpd	%f60,%f56
/* 0x05ec	     */		fbuge,a,pn	%fcc0,.L900001387
/* 0x05f0	     */		fsubd	%f60,%f56,%f36

! Registers live out of .L900001385: 
! sp o7 l1 l2 l6 i0 i2 i3 fp i7 gsr 
! f4 f28 f30 
		                       
! predecessor blocks: .L900001385

			.L900001309:
/* 0x05f4	 692 */		fdtoi	%f60,%f14
/* 0x05f8	     */		st	%f14,[%sp+224]
/* 0x05fc	     */		ba	.L900001386
/* 0x0600	     */		st	%f14,[%o7+%i2]

! Registers live out of .L900001309: 
! sp l1 l2 l6 i0 i2 i3 fp i7 gsr 
! f4 f30 
		                       
! predecessor blocks: .L900001385

			.L900001387:
/* 0x0604	 692 */		fdtoi	%f36,%f12
/* 0x0608	     */		st	%f12,[%sp+192]
/* 0x060c	     */		ld	[%sp+192],%g5
/* 0x0610	     */		sethi	%hi(0x80000000),%o0
/* 0x0614	     */		or	%g5,%o0,%g4
/* 0x0618	     */		st	%g4,[%o7+%i2]

! Registers live out of .L900001387: 
! sp l1 l2 l6 i0 i2 i3 fp i7 gsr 
! f4 f30 
		                       
! predecessor blocks: .L900001309 .L900001387

			.L900001386:
/* 0x061c	 691 */		ld	[%i0+%l1],%l0
/* 0x0620	     */		add	%l2,1,%l2
/* 0x0624	     */		cmp	%l2,%l0
/* 0x0628	     */		bcs,pt	%icc,.L900001385
/* 0x062c	 692 */		sll	%l2,2,%o7

! Registers live out of .L900001386: 
! sp o7 l1 l2 l6 i0 i2 i3 fp i7 gsr 
! f4 f30 
		                       
! predecessor blocks: .L900001386

			.L900001259:
/* 0x0630	 689 */		ret	! Result = 
/* 0x0634	     */		restore	%g0,0,%g0

!  693		      !	 }
!  694		      !	 break;
!  695		      !      case GL_PIXEL_MAP_I_TO_B:
!  696		      !	 for (i=0;i<ctx->Pixel.MapItoBsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004151:
/* 0x0638	 696 */		add	%g5,616,%l7
/* 0x063c	     */		ld	[%i0+%l7],%o0
/* 0x0640	     */		orcc	%g0,%o0,%g0
/* 0x0644	     */		bleu,pn	%icc,.L77004216
/* 0x0648	     */		cmp	%o0,5

! Registers live out of .L77004151: 
! g2 o0 sp l7 i0 i2 i3 fp i7 gsr 
! f6 f8 
		                       
! predecessor blocks: .L77004151

			.L77004230:
/* 0x064c	 696 */		bl,pn	%icc,.L77004418
/* 0x0650	     */		add	%g2,1022,%o7

! Registers live out of .L77004230: 
! o0 sp o7 l7 i0 i2 i3 fp i7 gsr 
! f6 f8 
		                       
! predecessor blocks: .L77004230

			.L77004263:
/* 0x0654	 696 */		sub	%o0,%o7,%o7
/* 0x0658	     */		srlx	%o7,63,%l2
/* 0x065c	     */		add	%i0,%l7,%o7
/* 0x0660	     */		sub	%o7,%i2,%o3
/* 0x0664	     */		sub	%i2,%o7,%l0
/* 0x0668	     */		sll	%o0,2,%g5
/* 0x066c	     */		sra	%g5,0,%o7
/* 0x0670	     */		sra	%o3,0,%g5
/* 0x0674	     */		sub	%g5,%o7,%o3
/* 0x0678	     */		srlx	%o3,63,%o7
/* 0x067c	     */		xor	%o7,1,%l5
/* 0x0680	     */		sra	%l0,0,%o3
/* 0x0684	     */		or	%g0,3,%g5
/* 0x0688	     */		sub	%g5,%o3,%o7
/* 0x068c	     */		srlx	%o7,63,%l0
/* 0x0690	     */		or	%l0,%l5,%g5
/* 0x0694	     */		andcc	%l2,%g5,%g0
/* 0x0698	     */		be,a,pn	%icc,.L77004388
/* 0x069c	     */		or	%g0,0,%l5

! Registers live out of .L77004263: 
! o0 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f6 f8 
		                       
! predecessor blocks: .L77004263

			.L77004341:
/* 0x06a0	 696 */		sethi	%hi(0xbc00),%g2
/* 0x06a4	     */		add	%g2,640,%l7
/* 0x06a8	     */		add	%i0,%l7,%g5
/* 0x06ac	     */		ldd	[%i3+40],%f52
/* 0x06b0	     */		add	%o0,-1,%i4

!  697		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapItoB[i] );

/* 0x06b4	 697 */		ld	[%g5],%f8
/* 0x06b8	 696 */		or	%g0,0,%o3

! Registers live out of .L77004341: 
! g5 o3 sp i2 i3 i4 fp i7 gsr 
! f6 f8 f20 
		                       
! predecessor blocks: .L77004341 .L900001383

			.L900001382:
/* 0x06bc	 697 */		fstod	%f8,%f46
/* 0x06c0	     */		ldd	[%i3+48],%f48
/* 0x06c4	     */		fmuld	%f46,%f52,%f50
/* 0x06c8	     */		fcmpd	%f50,%f48
/* 0x06cc	     */		fbuge,a,pn	%fcc0,.L900001384
/* 0x06d0	     */		fsubd	%f50,%f48,%f38

! Registers live out of .L900001382: 
! g5 o3 sp i2 i3 i4 fp i7 gsr 
! f6 f8 f18 f20 
		                       
! predecessor blocks: .L900001382

			.L900001305:
/* 0x06d4	 697 */		fdtoi	%f50,%f18
/* 0x06d8	     */		st	%f18,[%sp+896]
/* 0x06dc	     */		ld	[%sp+896],%g1
/* 0x06e0	     */		ba	.L900001383
/* 0x06e4	 696 */		add	%o3,1,%o3

! Registers live out of .L900001305: 
! g1 g5 o3 sp i2 i3 i4 fp i7 gsr 
! f6 f8 f20 
		                       
! predecessor blocks: .L900001382

			.L900001384:
/* 0x06e8	 697 */		fdtoi	%f38,%f16
/* 0x06ec	     */		st	%f16,[%sp+864]
/* 0x06f0	     */		ld	[%sp+864],%g3
/* 0x06f4	     */		sethi	%hi(0x80000000),%g2
/* 0x06f8	 696 */		add	%o3,1,%o3
/* 0x06fc	 697 */		or	%g3,%g2,%g1

! Registers live out of .L900001384: 
! g1 g5 o3 sp i2 i3 i4 fp i7 gsr 
! f6 f8 f20 
		                       
! predecessor blocks: .L900001305 .L900001384

			.L900001383:
/* 0x0700	 697 */		st	%g1,[%i2]
/* 0x0704	 696 */		cmp	%o3,%i4
/* 0x0708	     */		add	%g5,4,%g5
/* 0x070c	     */		add	%i2,4,%i2
/* 0x0710	     */		ble,a,pt	%icc,.L900001382
/* 0x0714	 697 */		ld	[%g5],%f8

! Registers live out of .L900001383: 
! g5 o3 sp i2 i3 i4 fp i7 gsr 
! f6 f8 f20 
		                       
! predecessor blocks: .L900001383

			.L77004260:
/* 0x0718	 689 */		ret	! Result = 
/* 0x071c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004230

			.L77004418:
/* 0x0720	 696 */		or	%g0,0,%l5

! Registers live out of .L77004418: 
! sp l5 l7 i0 i2 i3 fp i7 gsr 
! f8 
		                       
! predecessor blocks: .L77004263 .L77004418

			.L77004388:
/* 0x0724	 696 */		sethi	%hi(0xbc00),%g5
/* 0x0728	     */		add	%g5,640,%g4
/* 0x072c	 697 */		sll	%l5,2,%o3
/* 0x0730	 696 */		ldd	[%i3+40],%f58
/* 0x0734	 697 */		add	%i0,%g4,%o0

! Registers live out of .L77004388: 
! o0 o3 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L77004388 .L900001379

			.L900001378:
/* 0x0738	 697 */		ld	[%o0+%o3],%f28
/* 0x073c	     */		ldd	[%i3+48],%f34
/* 0x0740	     */		fstod	%f28,%f32
/* 0x0744	     */		fmuld	%f32,%f58,%f36
/* 0x0748	     */		fcmpd	%f36,%f34
/* 0x074c	     */		fbuge,a,pn	%fcc0,.L900001380
/* 0x0750	     */		fsubd	%f36,%f34,%f40

! Registers live out of .L900001378: 
! o0 o3 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f4 f8 f26 
		                       
! predecessor blocks: .L900001378

			.L900001301:
/* 0x0754	 697 */		fdtoi	%f36,%f22
/* 0x0758	     */		st	%f22,[%sp+96]
/* 0x075c	     */		ba	.L900001379
/* 0x0760	     */		st	%f22,[%o3+%i2]

! Registers live out of .L900001301: 
! o0 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L900001378

			.L900001380:
/* 0x0764	 697 */		fdtoi	%f40,%f20
/* 0x0768	     */		st	%f20,[%sp+256]
/* 0x076c	     */		ld	[%sp+256],%i4
/* 0x0770	     */		sethi	%hi(0x80000000),%i1
/* 0x0774	     */		or	%i4,%i1,%o5
/* 0x0778	     */		st	%o5,[%o3+%i2]

! Registers live out of .L900001380: 
! o0 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L900001301 .L900001380

			.L900001379:
/* 0x077c	 696 */		ld	[%i0+%l7],%o7
/* 0x0780	     */		add	%l5,1,%l5
/* 0x0784	     */		cmp	%l5,%o7
/* 0x0788	     */		bcs,pt	%icc,.L900001378
/* 0x078c	 697 */		sll	%l5,2,%o3

! Registers live out of .L900001379: 
! o0 o3 sp l5 l7 i0 i2 i3 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L900001379

			.L900001258:
/* 0x0790	 689 */		ret	! Result = 
/* 0x0794	     */		restore	%g0,0,%g0

!  698		      !	 }
!  699		      !	 break;
!  700		      !      case GL_PIXEL_MAP_I_TO_A:
!  701		      !	 for (i=0;i<ctx->Pixel.MapItoAsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004161:
/* 0x0798	 701 */		add	%g5,620,%g1
/* 0x079c	     */		ld	[%i0+%g1],%o5
/* 0x07a0	     */		orcc	%g0,%o5,%g0
/* 0x07a4	     */		bleu,pn	%icc,.L77004216
/* 0x07a8	     */		cmp	%o5,5

! Registers live out of .L77004161: 
! g1 g2 o5 sp i0 i2 i3 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L77004161

			.L77004229:
/* 0x07ac	 701 */		bl,pn	%icc,.L77004420
/* 0x07b0	     */		add	%g2,1022,%o7

! Registers live out of .L77004229: 
! g1 o5 sp o7 i0 i2 i3 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L77004229

			.L77004255:
/* 0x07b4	 701 */		sub	%o5,%o7,%g5
/* 0x07b8	     */		add	%i0,%g1,%l7
/* 0x07bc	     */		sub	%l7,%i2,%o3
/* 0x07c0	     */		srlx	%g5,63,%l2
/* 0x07c4	     */		sll	%o5,2,%o0
/* 0x07c8	     */		sra	%o0,0,%o7
/* 0x07cc	     */		sra	%o3,0,%g5
/* 0x07d0	     */		sub	%g5,%o7,%o0
/* 0x07d4	     */		sub	%i2,%l7,%l0
/* 0x07d8	     */		or	%g0,3,%o3
/* 0x07dc	     */		sra	%l0,0,%o7
/* 0x07e0	     */		srlx	%o0,63,%l5
/* 0x07e4	     */		sub	%o3,%o7,%g5
/* 0x07e8	     */		xor	%l5,1,%l7
/* 0x07ec	     */		srlx	%g5,63,%o0
/* 0x07f0	     */		or	%o0,%l7,%l5
/* 0x07f4	     */		andcc	%l2,%l5,%g0
/* 0x07f8	     */		be,a,pn	%icc,.L77004386
/* 0x07fc	     */		or	%g0,0,%o3

! Registers live out of .L77004255: 
! g1 o3 o5 sp i0 i2 i3 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L77004255

			.L77004339:
/* 0x0800	 701 */		sethi	%hi(0xc000),%g3
/* 0x0804	     */		add	%g3,640,%g4
/* 0x0808	     */		add	%i0,%g4,%o2
/* 0x080c	     */		ldd	[%i3+40],%f62
/* 0x0810	     */		add	%o5,-1,%g1

!  702		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapItoA[i] );

/* 0x0814	 702 */		ld	[%o2],%f10
/* 0x0818	 701 */		or	%g0,0,%l2

! Registers live out of .L77004339: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f10 f30 
		                       
! predecessor blocks: .L77004339 .L900001376

			.L900001375:
/* 0x081c	 702 */		fstod	%f10,%f54
/* 0x0820	     */		ldd	[%i3+48],%f56
/* 0x0824	     */		fmuld	%f54,%f62,%f60
/* 0x0828	     */		fcmpd	%f60,%f56
/* 0x082c	     */		fbuge,a,pn	%fcc0,.L900001377
/* 0x0830	     */		fsubd	%f60,%f56,%f42

! Registers live out of .L900001375: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f10 f28 f30 
		                       
! predecessor blocks: .L900001375

			.L900001297:
/* 0x0834	 702 */		fdtoi	%f60,%f26
/* 0x0838	     */		st	%f26,[%sp+1024]
/* 0x083c	     */		ld	[%sp+1024],%o3
/* 0x0840	     */		ba	.L900001376
/* 0x0844	 701 */		add	%l2,1,%l2

! Registers live out of .L900001297: 
! g1 o2 o3 sp l2 i2 i3 fp i7 gsr 
! f10 f30 
		                       
! predecessor blocks: .L900001375

			.L900001377:
/* 0x0848	 702 */		fdtoi	%f42,%f24
/* 0x084c	     */		st	%f24,[%sp+992]
/* 0x0850	     */		ld	[%sp+992],%l7
/* 0x0854	     */		sethi	%hi(0x80000000),%o4
/* 0x0858	 701 */		add	%l2,1,%l2
/* 0x085c	 702 */		or	%l7,%o4,%o3

! Registers live out of .L900001377: 
! g1 o2 o3 sp l2 i2 i3 fp i7 gsr 
! f10 f30 
		                       
! predecessor blocks: .L900001297 .L900001377

			.L900001376:
/* 0x0860	 702 */		st	%o3,[%i2]
/* 0x0864	 701 */		cmp	%l2,%g1
/* 0x0868	     */		add	%o2,4,%o2
/* 0x086c	     */		add	%i2,4,%i2
/* 0x0870	     */		ble,a,pt	%icc,.L900001375
/* 0x0874	 702 */		ld	[%o2],%f10

! Registers live out of .L900001376: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f10 f30 
		                       
! predecessor blocks: .L900001376

			.L77004252:
/* 0x0878	 689 */		ret	! Result = 
/* 0x087c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004229

			.L77004420:
/* 0x0880	 701 */		or	%g0,0,%o3

! Registers live out of .L77004420: 
! g1 o3 sp i0 i2 i3 fp i7 gsr 
! f12 
		                       
! predecessor blocks: .L77004255 .L77004420

			.L77004386:
/* 0x0884	 701 */		sethi	%hi(0xc000),%i5
/* 0x0888	     */		add	%i5,640,%o0
/* 0x088c	 702 */		sll	%o3,2,%l0
/* 0x0890	 701 */		ldd	[%i3+40],%f46
/* 0x0894	 702 */		add	%i0,%o0,%o5

! Registers live out of .L77004386: 
! g1 o3 o5 sp l0 i0 i2 i3 fp i7 gsr 
! f12 f14 
		                       
! predecessor blocks: .L77004386 .L900001372

			.L900001371:
/* 0x0898	 702 */		ld	[%o5+%l0],%f30
/* 0x089c	     */		ldd	[%i3+48],%f40
/* 0x08a0	     */		fstod	%f30,%f38
/* 0x08a4	     */		fmuld	%f38,%f46,%f42
/* 0x08a8	     */		fcmpd	%f42,%f40
/* 0x08ac	     */		fbuge,a,pn	%fcc0,.L900001373
/* 0x08b0	     */		fsubd	%f42,%f40,%f44

! Registers live out of .L900001371: 
! g1 o3 o5 sp l0 i0 i2 i3 fp i7 gsr 
! f10 f12 f14 
		                       
! predecessor blocks: .L900001371

			.L900001293:
/* 0x08b4	 702 */		fdtoi	%f42,%f30
/* 0x08b8	     */		st	%f30,[%sp+352]
/* 0x08bc	     */		ba	.L900001372
/* 0x08c0	     */		st	%f30,[%l0+%i2]

! Registers live out of .L900001293: 
! g1 o3 o5 sp i0 i2 i3 fp i7 gsr 
! f12 f14 
		                       
! predecessor blocks: .L900001371

			.L900001373:
/* 0x08c4	 702 */		fdtoi	%f44,%f28
/* 0x08c8	     */		st	%f28,[%sp+320]
/* 0x08cc	     */		ld	[%sp+320],%l6
/* 0x08d0	     */		sethi	%hi(0x80000000),%o1
/* 0x08d4	     */		or	%l6,%o1,%l5
/* 0x08d8	     */		st	%l5,[%l0+%i2]

! Registers live out of .L900001373: 
! g1 o3 o5 sp i0 i2 i3 fp i7 gsr 
! f12 f14 
		                       
! predecessor blocks: .L900001293 .L900001373

			.L900001372:
/* 0x08dc	 701 */		ld	[%i0+%g1],%o2
/* 0x08e0	     */		add	%o3,1,%o3
/* 0x08e4	     */		cmp	%o3,%o2
/* 0x08e8	     */		bcs,pt	%icc,.L900001371
/* 0x08ec	 702 */		sll	%o3,2,%l0

! Registers live out of .L900001372: 
! g1 o3 o5 sp l0 i0 i2 i3 fp i7 gsr 
! f12 f14 
		                       
! predecessor blocks: .L900001372

			.L900001257:
/* 0x08f0	 689 */		ret	! Result = 
/* 0x08f4	     */		restore	%g0,0,%g0

!  703		      !	 }
!  704		      !	 break;
!  705		      !      case GL_PIXEL_MAP_R_TO_R:
!  706		      !	 for (i=0;i<ctx->Pixel.MapRtoRsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004171:
/* 0x08f8	 706 */		add	%g5,624,%l4
/* 0x08fc	     */		ld	[%i0+%l4],%g3
/* 0x0900	     */		orcc	%g0,%g3,%g0
/* 0x0904	     */		bleu,pn	%icc,.L77004216
/* 0x0908	     */		cmp	%g3,5

! Registers live out of .L77004171: 
! g2 g3 sp l4 i0 i2 i3 fp i7 gsr 
! f14 
		                       
! predecessor blocks: .L77004171

			.L77004228:
/* 0x090c	 706 */		bl,pn	%icc,.L77004422
/* 0x0910	     */		add	%g2,1022,%o7

! Registers live out of .L77004228: 
! g3 sp o7 l4 i0 i2 i3 fp i7 gsr 
! f14 
		                       
! predecessor blocks: .L77004228

			.L77004247:
/* 0x0914	 706 */		add	%i0,%l4,%l7
/* 0x0918	     */		sub	%g3,%o7,%g5
/* 0x091c	     */		sub	%l7,%i2,%o0
/* 0x0920	     */		sll	%g3,2,%g1
/* 0x0924	     */		sra	%g1,0,%o5
/* 0x0928	     */		sra	%o0,0,%o3
/* 0x092c	     */		srlx	%g5,63,%l2
/* 0x0930	     */		sub	%i2,%l7,%l0
/* 0x0934	     */		sub	%o3,%o5,%o7
/* 0x0938	     */		sra	%l0,0,%g1
/* 0x093c	     */		or	%g0,3,%g5
/* 0x0940	     */		srlx	%o7,63,%l5
/* 0x0944	     */		sub	%g5,%g1,%o0
/* 0x0948	     */		xor	%l5,1,%l7
/* 0x094c	     */		srlx	%o0,63,%o5
/* 0x0950	     */		or	%o5,%l7,%o3
/* 0x0954	     */		andcc	%l2,%o3,%g0
/* 0x0958	     */		be,a,pn	%icc,.L77004384
/* 0x095c	     */		or	%g0,0,%o7

! Registers live out of .L77004247: 
! g3 sp o7 l4 i0 i2 i3 fp i7 gsr 
! f14 
		                       
! predecessor blocks: .L77004247

			.L77004337:
/* 0x0960	 706 */		sethi	%hi(0xc400),%o2
/* 0x0964	     */		add	%o2,640,%g1
/* 0x0968	     */		add	%i0,%g1,%l2
/* 0x096c	     */		ldd	[%i3+40],%f58
/* 0x0970	     */		add	%g3,-1,%o1

!  707		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapRtoR[i] );

/* 0x0974	 707 */		ld	[%l2],%f12
/* 0x0978	 706 */		or	%g0,0,%o2

! Registers live out of .L77004337: 
! o1 o2 sp l2 i2 i3 fp i7 gsr 
! f12 f14 f26 
		                       
! predecessor blocks: .L77004337 .L900001369

			.L900001368:
/* 0x097c	 707 */		fstod	%f12,%f32
/* 0x0980	     */		ldd	[%i3+48],%f34
/* 0x0984	     */		fmuld	%f32,%f58,%f36
/* 0x0988	     */		fcmpd	%f36,%f34
/* 0x098c	     */		fbuge,a,pn	%fcc0,.L900001370
/* 0x0990	     */		fsubd	%f36,%f34,%f46

! Registers live out of .L900001368: 
! o1 o2 sp l2 i2 i3 fp i7 gsr 
! f4 f12 f14 f26 
		                       
! predecessor blocks: .L900001368

			.L900001289:
/* 0x0994	 707 */		fdtoi	%f36,%f3
/* 0x0998	     */		st	%f3,[%sp+672]
/* 0x099c	     */		ld	[%sp+672],%i0
/* 0x09a0	     */		ba	.L900001369
/* 0x09a4	 706 */		add	%o2,1,%o2

! Registers live out of .L900001289: 
! o1 o2 sp l2 i0 i2 i3 fp i7 gsr 
! f12 f14 f26 
		                       
! predecessor blocks: .L900001368

			.L900001370:
/* 0x09a8	 707 */		fdtoi	%f46,%f1
/* 0x09ac	     */		st	%f1,[%sp+608]
/* 0x09b0	     */		ld	[%sp+608],%l3
/* 0x09b4	     */		sethi	%hi(0x80000000),%l4
/* 0x09b8	 706 */		add	%o2,1,%o2
/* 0x09bc	 707 */		or	%l3,%l4,%i0

! Registers live out of .L900001370: 
! o1 o2 sp l2 i0 i2 i3 fp i7 gsr 
! f12 f14 f26 
		                       
! predecessor blocks: .L900001289 .L900001370

			.L900001369:
/* 0x09c0	 707 */		st	%i0,[%i2]
/* 0x09c4	 706 */		cmp	%o2,%o1
/* 0x09c8	     */		add	%l2,4,%l2
/* 0x09cc	     */		add	%i2,4,%i2
/* 0x09d0	     */		ble,a,pt	%icc,.L900001368
/* 0x09d4	 707 */		ld	[%l2],%f12

! Registers live out of .L900001369: 
! o1 o2 sp l2 i2 i3 fp i7 gsr 
! f12 f14 f26 
		                       
! predecessor blocks: .L900001369

			.L77004244:
/* 0x09d8	 689 */		ret	! Result = 
/* 0x09dc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004228

			.L77004422:
/* 0x09e0	 706 */		or	%g0,0,%o7

! Registers live out of .L77004422: 
! sp o7 l4 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004247 .L77004422

			.L77004384:
/* 0x09e4	 706 */		sethi	%hi(0xc400),%l0
/* 0x09e8	     */		add	%l0,640,%g2
/* 0x09ec	 707 */		sll	%o7,2,%i4
/* 0x09f0	 706 */		ldd	[%i3+40],%f52
/* 0x09f4	 707 */		add	%i0,%g2,%g3

! Registers live out of .L77004384: 
! g3 sp o7 l4 i0 i2 i3 i4 fp i7 gsr 
! f20 
		                       
! predecessor blocks: .L77004384 .L900001365

			.L900001364:
/* 0x09f8	 707 */		ld	[%g3+%i4],%f1
/* 0x09fc	     */		ldd	[%i3+48],%f48
/* 0x0a00	     */		fstod	%f1,%f44
/* 0x0a04	     */		fmuld	%f44,%f52,%f50
/* 0x0a08	     */		fcmpd	%f50,%f48
/* 0x0a0c	     */		fbuge,a,pn	%fcc0,.L900001366
/* 0x0a10	     */		fsubd	%f50,%f48,%f48

! Registers live out of .L900001364: 
! g3 sp o7 l4 i0 i2 i3 i4 fp i7 gsr 
! f16 f18 f20 
		                       
! predecessor blocks: .L900001364

			.L900001285:
/* 0x0a14	 707 */		fdtoi	%f50,%f7
/* 0x0a18	     */		st	%f7,[%sp+416]
/* 0x0a1c	     */		ba	.L900001365
/* 0x0a20	     */		st	%f7,[%i4+%i2]

! Registers live out of .L900001285: 
! g3 sp o7 l4 i0 i2 i3 fp i7 gsr 
! f20 
		                       
! predecessor blocks: .L900001364

			.L900001366:
/* 0x0a24	 707 */		fdtoi	%f48,%f5
/* 0x0a28	     */		st	%f5,[%sp+384]
/* 0x0a2c	     */		ld	[%sp+384],%g5
/* 0x0a30	     */		sethi	%hi(0x80000000),%o0
/* 0x0a34	     */		or	%g5,%o0,%g4
/* 0x0a38	     */		st	%g4,[%i4+%i2]

! Registers live out of .L900001366: 
! g3 sp o7 l4 i0 i2 i3 fp i7 gsr 
! f20 
		                       
! predecessor blocks: .L900001285 .L900001366

			.L900001365:
/* 0x0a3c	 706 */		ld	[%i0+%l4],%l0
/* 0x0a40	     */		add	%o7,1,%o7
/* 0x0a44	     */		cmp	%o7,%l0
/* 0x0a48	     */		bcs,pt	%icc,.L900001364
/* 0x0a4c	 707 */		sll	%o7,2,%i4

! Registers live out of .L900001365: 
! g3 sp o7 l4 i0 i2 i3 i4 fp i7 gsr 
! f20 
		                       
! predecessor blocks: .L900001365

			.L900001256:
/* 0x0a50	 689 */		ret	! Result = 
/* 0x0a54	     */		restore	%g0,0,%g0

!  708		      !	 }
!  709		      !	 break;
!  710		      !      case GL_PIXEL_MAP_G_TO_G:
!  711		      !	 for (i=0;i<ctx->Pixel.MapGtoGsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004181:
/* 0x0a58	 711 */		add	%g5,628,%l1
/* 0x0a5c	     */		ld	[%i0+%l1],%o1
/* 0x0a60	     */		orcc	%g0,%o1,%g0
/* 0x0a64	     */		bleu,pn	%icc,.L77004216
/* 0x0a68	     */		cmp	%o1,5

! Registers live out of .L77004181: 
! g2 o1 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f18 f20 
		                       
! predecessor blocks: .L77004181

			.L77004227:
/* 0x0a6c	 711 */		bl,pn	%icc,.L77004424
/* 0x0a70	     */		add	%g2,1022,%g5

! Registers live out of .L77004227: 
! g5 o1 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f18 f20 
		                       
! predecessor blocks: .L77004227

			.L77004239:
/* 0x0a74	 711 */		add	%i0,%l1,%l5
/* 0x0a78	     */		sll	%o1,2,%o0
/* 0x0a7c	     */		sub	%l5,%i2,%i5
/* 0x0a80	     */		sub	%i2,%l5,%l0
/* 0x0a84	     */		sra	%o0,0,%g4
/* 0x0a88	     */		sra	%i5,0,%o5
/* 0x0a8c	     */		sub	%o5,%g4,%o4
/* 0x0a90	     */		sra	%l0,0,%o2
/* 0x0a94	     */		or	%g0,3,%o3
/* 0x0a98	     */		srlx	%o4,63,%l7
/* 0x0a9c	     */		sub	%o3,%o2,%g3
/* 0x0aa0	     */		sub	%o1,%g5,%g1
/* 0x0aa4	     */		xor	%l7,1,%l4
/* 0x0aa8	     */		srlx	%g3,63,%i4
/* 0x0aac	     */		srlx	%g1,63,%l2
/* 0x0ab0	     */		or	%i4,%l4,%g2
/* 0x0ab4	     */		andcc	%l2,%g2,%g0
/* 0x0ab8	     */		be,a,pn	%icc,.L77004382
/* 0x0abc	     */		or	%g0,0,%l6

! Registers live out of .L77004239: 
! o1 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f18 f20 
		                       
! predecessor blocks: .L77004239

			.L77004335:
/* 0x0ac0	 711 */		sethi	%hi(0xc800),%g1
/* 0x0ac4	     */		add	%g1,640,%l2
/* 0x0ac8	     */		add	%o1,-1,%o2
/* 0x0acc	     */		ldd	[%i3+40],%f44
/* 0x0ad0	     */		add	%i0,%l2,%o1

!  712		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapGtoG[i] );

/* 0x0ad4	 712 */		ld	[%o1],%f14
/* 0x0ad8	 711 */		or	%g0,0,%g1

! Registers live out of .L77004335: 
! g1 o1 o2 sp i2 i3 fp i7 gsr 
! f12 f14 f18 
		                       
! predecessor blocks: .L77004335 .L900001362

			.L900001361:
/* 0x0adc	 712 */		fstod	%f14,%f38
/* 0x0ae0	     */		ldd	[%i3+48],%f40
/* 0x0ae4	     */		fmuld	%f38,%f44,%f42
/* 0x0ae8	     */		fcmpd	%f42,%f40
/* 0x0aec	     */		fbuge,a,pn	%fcc0,.L900001363
/* 0x0af0	     */		fsubd	%f42,%f40,%f50

! Registers live out of .L900001361: 
! g1 o1 o2 sp i2 i3 fp i7 gsr 
! f10 f12 f14 f18 
		                       
! predecessor blocks: .L900001361

			.L900001281:
/* 0x0af4	 712 */		fdtoi	%f42,%f11
/* 0x0af8	     */		st	%f11,[%sp+928]
/* 0x0afc	     */		ld	[%sp+928],%g2
/* 0x0b00	     */		ba	.L900001362
/* 0x0b04	 711 */		add	%g1,1,%g1

! Registers live out of .L900001281: 
! g1 g2 o1 o2 sp i2 i3 fp i7 gsr 
! f12 f14 f18 
		                       
! predecessor blocks: .L900001361

			.L900001363:
/* 0x0b08	 712 */		fdtoi	%f50,%f9
/* 0x0b0c	     */		st	%f9,[%sp+832]
/* 0x0b10	     */		ld	[%sp+832],%l1
/* 0x0b14	     */		sethi	%hi(0x80000000),%l2
/* 0x0b18	 711 */		add	%g1,1,%g1
/* 0x0b1c	 712 */		or	%l1,%l2,%g2

! Registers live out of .L900001363: 
! g1 g2 o1 o2 sp i2 i3 fp i7 gsr 
! f12 f14 f18 
		                       
! predecessor blocks: .L900001281 .L900001363

			.L900001362:
/* 0x0b20	 712 */		st	%g2,[%i2]
/* 0x0b24	 711 */		cmp	%g1,%o2
/* 0x0b28	     */		add	%o1,4,%o1
/* 0x0b2c	     */		add	%i2,4,%i2
/* 0x0b30	     */		ble,a,pt	%icc,.L900001361
/* 0x0b34	 712 */		ld	[%o1],%f14

! Registers live out of .L900001362: 
! g1 o1 o2 sp i2 i3 fp i7 gsr 
! f12 f14 f18 
		                       
! predecessor blocks: .L900001362

			.L77004236:
/* 0x0b38	 689 */		ret	! Result = 
/* 0x0b3c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004227

			.L77004424:
/* 0x0b40	 711 */		or	%g0,0,%l6

! Registers live out of .L77004424: 
! sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 
		                       
! predecessor blocks: .L77004239 .L77004424

			.L77004382:
/* 0x0b44	 711 */		sethi	%hi(0xc800),%g5
/* 0x0b48	     */		add	%g5,640,%g3
/* 0x0b4c	 712 */		sll	%l6,2,%g5
/* 0x0b50	 711 */		ldd	[%i3+40],%f62
/* 0x0b54	 712 */		add	%i0,%g3,%l3

! Registers live out of .L77004382: 
! g5 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 f30 
		                       
! predecessor blocks: .L77004382 .L900001358

			.L900001357:
/* 0x0b58	 712 */		ld	[%l3+%g5],%f3
/* 0x0b5c	     */		ldd	[%i3+48],%f56
/* 0x0b60	     */		fstod	%f3,%f54
/* 0x0b64	     */		fmuld	%f54,%f62,%f60
/* 0x0b68	     */		fcmpd	%f60,%f56
/* 0x0b6c	     */		fbuge,a,pn	%fcc0,.L900001359
/* 0x0b70	     */		fsubd	%f60,%f56,%f52

! Registers live out of .L900001357: 
! g5 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 f28 f30 
		                       
! predecessor blocks: .L900001357

			.L900001277:
/* 0x0b74	 712 */		fdtoi	%f60,%f15
/* 0x0b78	     */		st	%f15,[%sp+480]
/* 0x0b7c	     */		ba	.L900001358
/* 0x0b80	     */		st	%f15,[%g5+%i2]

! Registers live out of .L900001277: 
! sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 f30 
		                       
! predecessor blocks: .L900001357

			.L900001359:
/* 0x0b84	 712 */		fdtoi	%f52,%f13
/* 0x0b88	     */		st	%f13,[%sp+288]
/* 0x0b8c	     */		ld	[%sp+288],%o7
/* 0x0b90	     */		sethi	%hi(0x80000000),%g1
/* 0x0b94	     */		or	%o7,%g1,%i1
/* 0x0b98	     */		st	%i1,[%g5+%i2]

! Registers live out of .L900001359: 
! sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 f30 
		                       
! predecessor blocks: .L900001277 .L900001359

			.L900001358:
/* 0x0b9c	 711 */		ld	[%i0+%l1],%g3
/* 0x0ba0	     */		add	%l6,1,%l6
/* 0x0ba4	     */		cmp	%l6,%g3
/* 0x0ba8	     */		bcs,pt	%icc,.L900001357
/* 0x0bac	 712 */		sll	%l6,2,%g5

! Registers live out of .L900001358: 
! g5 sp l1 l6 i0 i2 i3 fp i7 gsr 
! f20 f30 
		                       
! predecessor blocks: .L900001358

			.L900001255:
/* 0x0bb0	 689 */		ret	! Result = 
/* 0x0bb4	     */		restore	%g0,0,%g0

!  713		      !	 }
!  714		      !	 break;
!  715		      !      case GL_PIXEL_MAP_B_TO_B:
!  716		      !	 for (i=0;i<ctx->Pixel.MapBtoBsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004191:
/* 0x0bb8	 716 */		add	%g5,632,%l1
/* 0x0bbc	     */		ld	[%i0+%l1],%o5
/* 0x0bc0	     */		orcc	%g0,%o5,%g0
/* 0x0bc4	     */		bleu,pn	%icc,.L77004216
/* 0x0bc8	     */		cmp	%o5,5

! Registers live out of .L77004191: 
! g2 o5 sp l1 i0 i2 i3 fp i7 gsr 
! f22 f24 
		                       
! predecessor blocks: .L77004191

			.L77004234:
/* 0x0bcc	 716 */		bl,pn	%icc,.L77004426
/* 0x0bd0	     */		add	%g2,1022,%o1

! Registers live out of .L77004234: 
! o1 o5 sp l1 i0 i2 i3 fp i7 gsr 
! f22 f24 
		                       
! predecessor blocks: .L77004234

			.L77004295:
/* 0x0bd4	 716 */		add	%i0,%l1,%l6
/* 0x0bd8	     */		sub	%l6,%i2,%i5
/* 0x0bdc	     */		sll	%o5,2,%l5
/* 0x0be0	     */		sub	%o5,%o1,%o2
/* 0x0be4	     */		sra	%i5,0,%g1
/* 0x0be8	     */		sub	%i2,%l6,%l3
/* 0x0bec	     */		sra	%l5,0,%o7
/* 0x0bf0	     */		srlx	%o2,63,%l2
/* 0x0bf4	     */		sub	%g1,%o7,%o0
/* 0x0bf8	     */		sra	%l3,0,%o4
/* 0x0bfc	     */		or	%g0,3,%o1
/* 0x0c00	     */		srlx	%o0,63,%l4
/* 0x0c04	     */		sub	%o1,%o4,%o2
/* 0x0c08	     */		xor	%l4,1,%i1
/* 0x0c0c	     */		srlx	%o2,63,%l6
/* 0x0c10	     */		or	%l6,%i1,%l0
/* 0x0c14	     */		andcc	%l2,%l0,%g0
/* 0x0c18	     */		be,a,pn	%icc,.L77004380
/* 0x0c1c	     */		or	%g0,0,%i5

! Registers live out of .L77004295: 
! o5 sp l1 i0 i2 i3 i5 fp i7 gsr 
! f22 f24 
		                       
! predecessor blocks: .L77004295

			.L77004333:
/* 0x0c20	 716 */		sethi	%hi(0xcc00),%l2
/* 0x0c24	     */		add	%l2,640,%o1
/* 0x0c28	     */		add	%i0,%o1,%o2
/* 0x0c2c	     */		ldd	[%i3+40],%f52
/* 0x0c30	     */		add	%o5,-1,%g1

!  717		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapBtoB[i] );

/* 0x0c34	 717 */		ld	[%o2],%f16
/* 0x0c38	 716 */		or	%g0,0,%l2

! Registers live out of .L77004333: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f16 f20 f22 
		                       
! predecessor blocks: .L77004333 .L900001355

			.L900001354:
/* 0x0c3c	 717 */		fstod	%f16,%f46
/* 0x0c40	     */		ldd	[%i3+48],%f48
/* 0x0c44	     */		fmuld	%f46,%f52,%f50
/* 0x0c48	     */		fcmpd	%f50,%f48
/* 0x0c4c	     */		fbuge,a,pn	%fcc0,.L900001356
/* 0x0c50	     */		fsubd	%f50,%f48,%f54

! Registers live out of .L900001354: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f16 f18 f20 f22 
		                       
! predecessor blocks: .L900001354

			.L900001273:
/* 0x0c54	 717 */		fdtoi	%f50,%f19
/* 0x0c58	     */		st	%f19,[%sp+704]
/* 0x0c5c	     */		ld	[%sp+704],%l7
/* 0x0c60	     */		ba	.L900001355
/* 0x0c64	 716 */		add	%l2,1,%l2

! Registers live out of .L900001273: 
! g1 o2 sp l2 l7 i2 i3 fp i7 gsr 
! f16 f20 f22 
		                       
! predecessor blocks: .L900001354

			.L900001356:
/* 0x0c68	 717 */		fdtoi	%f54,%f17
/* 0x0c6c	     */		st	%f17,[%sp+1088]
/* 0x0c70	     */		ld	[%sp+1088],%o4
/* 0x0c74	     */		sethi	%hi(0x80000000),%o5
/* 0x0c78	 716 */		add	%l2,1,%l2
/* 0x0c7c	 717 */		or	%o4,%o5,%l7

! Registers live out of .L900001356: 
! g1 o2 sp l2 l7 i2 i3 fp i7 gsr 
! f16 f20 f22 
		                       
! predecessor blocks: .L900001273 .L900001356

			.L900001355:
/* 0x0c80	 717 */		st	%l7,[%i2]
/* 0x0c84	 716 */		cmp	%l2,%g1
/* 0x0c88	     */		add	%o2,4,%o2
/* 0x0c8c	     */		add	%i2,4,%i2
/* 0x0c90	     */		ble,a,pt	%icc,.L900001354
/* 0x0c94	 717 */		ld	[%o2],%f16

! Registers live out of .L900001355: 
! g1 o2 sp l2 i2 i3 fp i7 gsr 
! f16 f20 f22 
		                       
! predecessor blocks: .L900001355

			.L77004292:
/* 0x0c98	 689 */		ret	! Result = 
/* 0x0c9c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004234

			.L77004426:
/* 0x0ca0	 716 */		or	%g0,0,%i5

! Registers live out of .L77004426: 
! sp l1 i0 i2 i3 i5 fp i7 gsr 
! f24 
		                       
! predecessor blocks: .L77004295 .L77004426

			.L77004380:
/* 0x0ca4	 716 */		sethi	%hi(0xcc00),%g4
/* 0x0ca8	     */		add	%g4,640,%g1
/* 0x0cac	 717 */		sll	%i5,2,%g2
/* 0x0cb0	 716 */		ldd	[%i3+40],%f58
/* 0x0cb4	 717 */		add	%i0,%g1,%l5

! Registers live out of .L77004380: 
! g2 sp l1 l5 i0 i2 i3 i5 fp i7 gsr 
! f24 f26 
		                       
! predecessor blocks: .L77004380 .L900001351

			.L900001350:
/* 0x0cb8	 717 */		ld	[%l5+%g2],%f20
/* 0x0cbc	     */		ldd	[%i3+48],%f34
/* 0x0cc0	     */		fstod	%f20,%f32
/* 0x0cc4	     */		fmuld	%f32,%f58,%f36
/* 0x0cc8	     */		fcmpd	%f36,%f34
/* 0x0ccc	     */		fbuge,a,pn	%fcc0,.L900001352
/* 0x0cd0	     */		fsubd	%f36,%f34,%f56

! Registers live out of .L900001350: 
! g2 sp l1 l5 i0 i2 i3 i5 fp i7 gsr 
! f4 f24 f26 
		                       
! predecessor blocks: .L900001350

			.L900001269:
/* 0x0cd4	 717 */		fdtoi	%f36,%f23
/* 0x0cd8	     */		st	%f23,[%sp+448]
/* 0x0cdc	     */		ba	.L900001351
/* 0x0ce0	     */		st	%f23,[%g2+%i2]

! Registers live out of .L900001269: 
! sp l1 l5 i0 i2 i3 i5 fp i7 gsr 
! f24 f26 
		                       
! predecessor blocks: .L900001350

			.L900001352:
/* 0x0ce4	 717 */		fdtoi	%f56,%f21
/* 0x0ce8	     */		st	%f21,[%sp+512]
/* 0x0cec	     */		ld	[%sp+512],%o2
/* 0x0cf0	     */		sethi	%hi(0x80000000),%o3
/* 0x0cf4	     */		or	%o2,%o3,%o1
/* 0x0cf8	     */		st	%o1,[%g2+%i2]

! Registers live out of .L900001352: 
! sp l1 l5 i0 i2 i3 i5 fp i7 gsr 
! f24 f26 
		                       
! predecessor blocks: .L900001269 .L900001352

			.L900001351:
/* 0x0cfc	 716 */		ld	[%i0+%l1],%i4
/* 0x0d00	     */		add	%i5,1,%i5
/* 0x0d04	     */		cmp	%i5,%i4
/* 0x0d08	     */		bcs,pt	%icc,.L900001350
/* 0x0d0c	 717 */		sll	%i5,2,%g2

! Registers live out of .L900001351: 
! g2 sp l1 l5 i0 i2 i3 i5 fp i7 gsr 
! f24 f26 
		                       
! predecessor blocks: .L900001351

			.L900001254:
/* 0x0d10	 689 */		ret	! Result = 
/* 0x0d14	     */		restore	%g0,0,%g0

!  718		      !	 }
!  719		      !	 break;
!  720		      !      case GL_PIXEL_MAP_A_TO_A:
!  721		      !	 for (i=0;i<ctx->Pixel.MapAtoAsize;i++) {

                       
! predecessor blocks: .L900001326

			.L77004201:
/* 0x0d18	 721 */		add	%g5,636,%l6
/* 0x0d1c	     */		ld	[%i0+%l6],%g3
/* 0x0d20	     */		orcc	%g0,%g3,%g0
/* 0x0d24	     */		bleu,pn	%icc,.L77004216
/* 0x0d28	     */		cmp	%g3,5

! Registers live out of .L77004201: 
! g2 g3 sp l2 l6 i0 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77004201

			.L77004233:
/* 0x0d2c	 721 */		bl,pn	%icc,.L77004412
/* 0x0d30	     */		add	%g2,1022,%o7

! Registers live out of .L77004233: 
! g3 sp o7 l2 l6 i0 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77004233

			.L77004287:
/* 0x0d34	 721 */		add	%i0,%l6,%l7
/* 0x0d38	     */		sll	%g3,2,%i4
/* 0x0d3c	     */		sub	%l7,%i2,%o3
/* 0x0d40	     */		sub	%i2,%l7,%g4
/* 0x0d44	     */		sra	%i4,0,%g1
/* 0x0d48	     */		sra	%o3,0,%o0
/* 0x0d4c	     */		sub	%o0,%g1,%o5
/* 0x0d50	     */		sra	%g4,0,%o4
/* 0x0d54	     */		or	%g0,3,%o1
/* 0x0d58	     */		srlx	%o5,63,%l4
/* 0x0d5c	     */		sub	%o1,%o4,%o2
/* 0x0d60	     */		sub	%g3,%o7,%g5
/* 0x0d64	     */		xor	%l4,1,%l3
/* 0x0d68	     */		srlx	%o2,63,%i1
/* 0x0d6c	     */		srlx	%g5,63,%l0
/* 0x0d70	     */		or	%i1,%l3,%l1
/* 0x0d74	     */		andcc	%l0,%l1,%g0
/* 0x0d78	     */		be,a,pn	%icc,.L77004394
/* 0x0d7c	     */		or	%g0,0,%l2

! Registers live out of .L77004287: 
! g3 sp l2 l6 i0 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77004287

			.L77004331:
/* 0x0d80	 721 */		sethi	%hi(0xd000),%o1
/* 0x0d84	     */		add	%o1,640,%o2
/* 0x0d88	     */		add	%i0,%o2,%g1
/* 0x0d8c	     */		ldd	[%i3+40],%f62
/* 0x0d90	     */		add	%g3,-1,%l2

!  722		      !	    values[i] = FLOAT_TO_UINT( ctx->Pixel.MapAtoA[i] );

/* 0x0d94	 722 */		ld	[%g1],%f18
/* 0x0d98	 721 */		or	%g0,0,%l1

! Registers live out of .L77004331: 
! g1 sp l1 l2 i2 i3 fp i7 gsr 
! f18 f30 
		                       
! predecessor blocks: .L77004331 .L900001348

			.L900001347:
/* 0x0d9c	 722 */		fstod	%f18,%f54
/* 0x0da0	     */		ldd	[%i3+48],%f56
/* 0x0da4	     */		fmuld	%f54,%f62,%f60
/* 0x0da8	     */		fcmpd	%f60,%f56
/* 0x0dac	     */		fbuge,a,pn	%fcc0,.L900001349
/* 0x0db0	     */		fsubd	%f60,%f56,%f60

! Registers live out of .L900001347: 
! g1 sp l1 l2 i2 i3 fp i7 gsr 
! f18 f28 f30 
		                       
! predecessor blocks: .L900001347

			.L900001265:
/* 0x0db4	 722 */		fdtoi	%f60,%f27
/* 0x0db8	     */		st	%f27,[%sp+800]
/* 0x0dbc	     */		ld	[%sp+800],%l4
/* 0x0dc0	     */		ba	.L900001348
/* 0x0dc4	 721 */		add	%l1,1,%l1

! Registers live out of .L900001265: 
! g1 sp l1 l2 l4 i2 i3 fp i7 gsr 
! f18 f30 
		                       
! predecessor blocks: .L900001347

			.L900001349:
/* 0x0dc8	 722 */		fdtoi	%f60,%f25
/* 0x0dcc	     */		st	%f25,[%sp+1056]
/* 0x0dd0	     */		ld	[%sp+1056],%l5
/* 0x0dd4	     */		sethi	%hi(0x80000000),%l6
/* 0x0dd8	 721 */		add	%l1,1,%l1
/* 0x0ddc	 722 */		or	%l5,%l6,%l4

! Registers live out of .L900001349: 
! g1 sp l1 l2 l4 i2 i3 fp i7 gsr 
! f18 f30 
		                       
! predecessor blocks: .L900001265 .L900001349

			.L900001348:
/* 0x0de0	 722 */		st	%l4,[%i2]
/* 0x0de4	 721 */		cmp	%l1,%l2
/* 0x0de8	     */		add	%g1,4,%g1
/* 0x0dec	     */		add	%i2,4,%i2
/* 0x0df0	     */		ble,a,pt	%icc,.L900001347
/* 0x0df4	 722 */		ld	[%g1],%f18

! Registers live out of .L900001348: 
! g1 sp l1 l2 i2 i3 fp i7 gsr 
! f18 f30 
		                       
! predecessor blocks: .L900001348

			.L77004284:
/* 0x0df8	 689 */		ret	! Result = 
/* 0x0dfc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004233

			.L77004412:
/* 0x0e00	 721 */		or	%g0,0,%l2

! Registers live out of .L77004412: 
! sp l2 l6 i0 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77004287 .L77004412

			.L77004394:
/* 0x0e04	 721 */		sethi	%hi(0xd000),%o0
/* 0x0e08	     */		add	%o0,640,%l0
/* 0x0e0c	 722 */		sll	%l2,2,%g2
/* 0x0e10	 721 */		ldd	[%i3+40],%f44
/* 0x0e14	 722 */		add	%i0,%l0,%l5

! Registers live out of .L77004394: 
! g2 sp l2 l5 l6 i0 i2 i3 fp i7 gsr 
! f12 f30 
		                       
! predecessor blocks: .L77004394 .L900001344

			.L900001343:
/* 0x0e18	 722 */		ld	[%l5+%g2],%f22
/* 0x0e1c	     */		ldd	[%i3+48],%f40
/* 0x0e20	     */		fstod	%f22,%f38
/* 0x0e24	     */		fmuld	%f38,%f44,%f42
/* 0x0e28	     */		fcmpd	%f42,%f40
/* 0x0e2c	     */		fbuge,a,pn	%fcc0,.L900001345
/* 0x0e30	     */		fsubd	%f42,%f40,%f62

! Registers live out of .L900001343: 
! g2 sp l2 l5 l6 i0 i2 i3 fp i7 gsr 
! f10 f12 f30 
		                       
! predecessor blocks: .L900001343

			.L900001261:
/* 0x0e34	 722 */		fdtoi	%f42,%f31
/* 0x0e38	     */		st	%f31,[%sp+576]
/* 0x0e3c	     */		ba	.L900001344
/* 0x0e40	     */		st	%f31,[%g2+%i2]

! Registers live out of .L900001261: 
! sp l2 l5 l6 i0 i2 i3 fp i7 gsr 
! f12 f30 
		                       
! predecessor blocks: .L900001343

			.L900001345:
/* 0x0e44	 722 */		fdtoi	%f62,%f29
/* 0x0e48	     */		st	%f29,[%sp+544]
/* 0x0e4c	     */		ld	[%sp+544],%g5
/* 0x0e50	     */		sethi	%hi(0x80000000),%o0
/* 0x0e54	     */		or	%g5,%o0,%o0
/* 0x0e58	     */		st	%o0,[%g2+%i2]

! Registers live out of .L900001345: 
! sp l2 l5 l6 i0 i2 i3 fp i7 gsr 
! f12 f30 
		                       
! predecessor blocks: .L900001261 .L900001345

			.L900001344:
/* 0x0e5c	 721 */		ld	[%i0+%l6],%l3
/* 0x0e60	     */		add	%l2,1,%l2
/* 0x0e64	     */		cmp	%l2,%l3
/* 0x0e68	     */		bcs,pt	%icc,.L900001343
/* 0x0e6c	 722 */		sll	%l2,2,%g2

! Registers live out of .L900001344: 
! g2 sp l2 l5 l6 i0 i2 i3 fp i7 gsr 
! f12 f30 
		                       
! predecessor blocks: .L77004131 .L77004141 .L77004151 .L77004161 .L77004171 .L77004181 .L77004191 .L77004201 .L900001207 .L900001212
! predecessor blocks: .L900001213 .L900001214 .L900001223 .L900001228 .L900001229 .L900001230 .L900001344

			.L77004216:
/* 0x0e70	 689 */		ret	! Result = 
/* 0x0e74	     */		restore	%g0,0,%g0

!  723		      !	 }
!  724		      !	 break;
!  725		      !      default:
!  726		      !         gl_error( ctx, GL_INVALID_ENUM, "glGetPixelMapfv" );

                       
! predecessor blocks: .L900001326 .L900001404

			.L77004211:
/* 0x0e78	 726 */		sethi	%hi(.L528),%i2
/* 0x0e7c	     */		or	%g0,1280,%i1
/* 0x0e80	     */		add	%i2,%lo(.L528),%i2
/* 0x0e84	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0e88	     */		restore	%g0,0,%g0
/* 0x0e8c	   0 */		.type	gl_GetPixelMapuiv,2
/* 0x0e8c	   0 */		.size	gl_GetPixelMapuiv,(.-gl_GetPixelMapuiv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900001501:
/* 000000	   0 */		.word	(.L77004505-(___const_seg_900001501+0x0))
/* 0x0004	     */		.word	(.L77004515-(___const_seg_900001501+0x0))
/* 0x0008	     */		.word	(.L77004525-(___const_seg_900001501+0x0))
/* 0x000c	     */		.word	(.L77004535-(___const_seg_900001501+0x0))
/* 0x0010	     */		.word	(.L77004545-(___const_seg_900001501+0x0))
/* 0x0014	     */		.word	(.L77004555-(___const_seg_900001501+0x0))
/* 0x0018	     */		.word	(.L77004565-(___const_seg_900001501+0x0))
/* 0x001c	     */		.word	(.L77004575-(___const_seg_900001501+0x0))
/* 0x0020	     */		.word	(.L77004585-(___const_seg_900001501+0x0))
/* 0x0024	     */		.word	(.L77004595-(___const_seg_900001501+0x0))
/* 0x0028	   0 */		.word	1199570688
/* 0x002c	   0 */		.type	___const_seg_900001501,1
/* 0x002c	   0 */		.size	___const_seg_900001501,(.-___const_seg_900001501)
/* 0x002c	   0 */		.align	4

!  727		      !   }
!  728		      !}
!  731		      !void gl_GetPixelMapusv( GLcontext *ctx, GLenum map, GLushort *values )
!  732		      !{

!
! SUBROUTINE gl_GetPixelMapusv
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_GetPixelMapusv
                       

			gl_GetPixelMapusv:
/* 000000	 732 */		save	%sp,-224,%sp

!  733		      !   GLuint i;
!  735		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 735 */		sethi	%hi(0xe000),%g1
/* 0x0008	     */		add	%g1,252,%l2
/* 0x000c	     */		sethi	%hi(0x1800),%l1
/* 0x0010	     */		ld	[%i0+%l2],%l0
/* 0x0014	     */		add	%l1,512,%l5
/* 0x0018	     */		cmp	%l0,%l5
/* 0x001c	     */		be,pn	%icc,.L77004607
/* 0x0020	 736 */		sethi	%hi(.L537),%o7

! Registers live out of gl_GetPixelMapusv: 
! g5 o2 sp o7 i0 i1 i2 i4 fp i7 gsr 
! 
		
!  736		      !      gl_error( ctx, GL_INVALID_OPERATION, "glGetPixelMapfv" );

                       
! predecessor blocks: gl_GetPixelMapusv

			.L77004501:
/* 0x0024	 736 */		add	%o7,%lo(.L537),%i2
/* 0x0028	     */		or	%g0,1282,%i1
/* 0x002c	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0030	     */		restore	%g0,0,%g0

!  737		      !      return;
!  738		      !   }
!  739		      !   switch (map) {

                       
! predecessor blocks: gl_GetPixelMapusv

			.L77004607:
/* 0x0034	 739 */		sub	%i1,3184,%l6
/* 0x0038	     */		cmp	%l6,9
/* 0x003c	     */		bgu,pn	%icc,.L77004605
/* 0x0040	     */		sll	%l6,2,%g4

! Registers live out of .L77004607: 
! g4 g5 o2 sp i0 i1 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004607

			.L900001542:
/* 0x0044	 739 */		sethi	%hi(___const_seg_900001501),%o3
/* 0x0048	     */		add	%o3,%lo(___const_seg_900001501),%i3
/* 0x004c	 732 */		or	%g0,%i2,%o3
/* 0x0050	   0 */		sethi	%hi(0xac00),%o1
/* 0x0054	   0 */		sethi	%hi(0x7ffffc00),%o7
/* 0x0058	 739 */		ld	[%g4+%i3],%g2
/* 0x005c	     */		jmpl	%g2+%i3,%g0
/* 0x0060	     */		nop

! Registers live out of .L900001542: 
! g5 o1 o2 o3 sp o7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		
!  740		      !      case GL_PIXEL_MAP_I_TO_I:
!  741		      !	 for (i=0;i<ctx->Pixel.MapItoIsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004505:
/* 0x0064	 741 */		add	%o1,604,%l5
/* 0x0068	     */		ld	[%i0+%l5],%g2
/* 0x006c	     */		orcc	%g0,%g2,%g0
/* 0x0070	     */		bleu,pn	%icc,.L77004610
/* 0x0074	     */		cmp	%g2,2

! Registers live out of .L77004505: 
! g2 o3 sp o7 i0 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004505

			.L77004630:
/* 0x0078	 741 */		bl,pn	%icc,.L77004858
/* 0x007c	     */		add	%o7,1022,%g4

! Registers live out of .L77004630: 
! g2 g4 o3 sp i0 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004630

			.L77004693:
/* 0x0080	 741 */		sub	%g2,%g4,%g1
/* 0x0084	     */		srlx	%g1,63,%l6
/* 0x0088	     */		andcc	%l6,1,%g0
/* 0x008c	     */		be,a,pn	%icc,.L77004830
/* 0x0090	     */		or	%g0,0,%i4

! Registers live out of .L77004693: 
! g2 o3 sp i0 i2 i4 fp i7 gsr 
! 
		
!  742		      !	    values[i] = (GLushort) ctx->Pixel.MapItoI[i];

                       
! predecessor blocks: .L77004693

			.L77004771:
/* 0x0094	 742 */		add	%g2,0,%l5
/* 0x0098	 741 */		sethi	%hi(0xb000),%i4
/* 0x009c	     */		add	%g2,-1,%i1
/* 0x00a0	     */		add	%i4,640,%g2
/* 0x00a4	 742 */		cmp	%l5,5
/* 0x00a8	 741 */		add	%i0,%g2,%i5
/* 0x00ac	     */		or	%g0,0,%i3
/* 0x00b0	     */		or	%g0,%i2,%i4
/* 0x00b4	 742 */		bl,pn	%icc,.L77004772
/* 0x00b8	     */		nop

! Registers live out of .L77004771: 
! sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004771

			.L900001581:
/* 0x00bc	 742 */		sub	%i1,3,%l7
/* 0x00c0	 741 */		or	%g0,1,%i3
/* 0x00c4	 742 */		ld	[%i5],%i2
/* 0x00c8	 741 */		add	%i5,4,%i5

! Registers live out of .L900001581: 
! sp l7 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001579 .L900001581

			.L900001579:
/* 0x00cc	 742 */		prefetch	[%i5+180],0
/* 0x00d0	     */		prefetch	[%i4+90],2
/* 0x00d4	 741 */		add	%i3,4,%i3
/* 0x00d8	 742 */		ld	[%i5],%l0
/* 0x00dc	 741 */		add	%i5,16,%i5
/* 0x00e0	 742 */		sth	%i2,[%i4]
/* 0x00e4	 741 */		cmp	%i3,%l7
/* 0x00e8	     */		add	%i4,8,%i4
/* 0x00ec	 742 */		ld	[%i5-12],%o7
/* 0x00f0	     */		sth	%l0,[%i4-6]
/* 0x00f4	     */		ld	[%i5-8],%o5
/* 0x00f8	     */		sth	%o7,[%i4-4]
/* 0x00fc	     */		ld	[%i5-4],%i2
/* 0x0100	 741 */		ble,pt	%icc,.L900001579
/* 0x0104	 742 */		sth	%o5,[%i4-2]

! Registers live out of .L900001579: 
! sp l7 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001579

			.L900001582:
/* 0x0108	 741 */		cmp	%i3,%i1
/* 0x010c	 742 */		sth	%i2,[%i4]
/* 0x0110	 741 */		add	%i4,2,%i4
/* 0x0114	     */		bg,pn	%icc,.L900001540
/* 0x0118	 742 */		nop

! Registers live out of .L900001582: 
! sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004771 .L900001582

			.L77004772:
/* 0x011c	 741 */		add	%i3,1,%i3

! Registers live out of .L77004772: 
! sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004772 .L900001614

			.L900001614:
/* 0x0120	 741 */		cmp	%i3,%i1
/* 0x0124	 742 */		ld	[%i5],%o3
/* 0x0128	 741 */		add	%i5,4,%i5
/* 0x012c	 742 */		sth	%o3,[%i4]
/* 0x0130	 741 */		add	%i4,2,%i4
/* 0x0134	     */		ble,pt	%icc,.L900001614
/* 0x0138	     */		add	%i3,1,%i3

! Registers live out of .L900001614: 
! sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001582 .L900001614

			.L900001540:
/* 0x013c	 744 */		ret	! Result = 
/* 0x0140	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004630

			.L77004858:
/* 0x0144	 741 */		or	%g0,0,%i4

! Registers live out of .L77004858: 
! g2 o3 sp i0 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004693 .L77004858

			.L77004830:
/* 0x0148	 741 */		sethi	%hi(0xb000),%i3
/* 0x014c	     */		add	%i3,640,%o5
/* 0x0150	 742 */		sll	%i4,1,%l6
/* 0x0154	     */		add	%i0,%o5,%o7

! Registers live out of .L77004830: 
! g2 o3 sp o7 l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004689 .L77004830

			.L900001612:
/* 0x0158	 742 */		sll	%i4,2,%l2
/* 0x015c	 741 */		add	%i4,1,%i4
/* 0x0160	 742 */		ld	[%o7+%l2],%l1
/* 0x0164	 741 */		cmp	%i4,%g2
/* 0x0168	     */		bcc,pn	%icc,.L77004610
/* 0x016c	 742 */		sth	%l1,[%l6+%o3]

! Registers live out of .L900001612: 
! g2 o3 sp o7 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001612

			.L77004689:
/* 0x0170	 742 */		sll	%i4,1,%o2
/* 0x0174	     */		sll	%i4,2,%l2
/* 0x0178	     */		ld	[%o7+%l2],%l1
/* 0x017c	 741 */		add	%i4,1,%i4
/* 0x0180	     */		cmp	%i4,%g2
/* 0x0184	 742 */		sth	%l1,[%o2+%o3]
/* 0x0188	 741 */		bcs,pt	%icc,.L900001612
/* 0x018c	 742 */		sll	%i4,1,%l6

! Registers live out of .L77004689: 
! g2 o3 sp o7 l6 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004689

			.L900001539:
/* 0x0190	 744 */		ret	! Result = 
/* 0x0194	     */		restore	%g0,0,%g0

!  743		      !	 }
!  744		      !	 break;
!  745		      !      case GL_PIXEL_MAP_S_TO_S:
!  746		      !	 for (i=0;i<ctx->Pixel.MapStoSsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004515:
/* 0x0198	 746 */		add	%o1,600,%o4
/* 0x019c	     */		ld	[%i0+%o4],%o0
/* 0x01a0	     */		orcc	%g0,%o0,%g0
/* 0x01a4	     */		bleu,pn	%icc,.L77004610
/* 0x01a8	     */		cmp	%o0,2

! Registers live out of .L77004515: 
! g5 o0 o1 o3 sp o7 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004515

			.L77004629:
/* 0x01ac	 746 */		bl,pn	%icc,.L77004860
/* 0x01b0	     */		add	%o7,1022,%o5

! Registers live out of .L77004629: 
! g5 o0 o1 o3 o5 sp i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004629

			.L77004685:
/* 0x01b4	 746 */		sub	%o0,%o5,%o4
/* 0x01b8	     */		srlx	%o4,63,%l5
/* 0x01bc	     */		andcc	%l5,1,%g0
/* 0x01c0	     */		be,a,pn	%icc,.L77004828
/* 0x01c4	     */		or	%g0,0,%g5

! Registers live out of .L77004685: 
! g5 o0 o1 o3 sp i0 fp i7 gsr 
! 
		
!  747		      !	    values[i] = (GLushort) ctx->Pixel.MapStoS[i];

                       
! predecessor blocks: .L77004685

			.L77004769:
/* 0x01c8	 747 */		add	%o0,0,%o4
/* 0x01cc	 746 */		add	%o1,640,%l5
/* 0x01d0	     */		add	%o0,-1,%l2
/* 0x01d4	 747 */		cmp	%o4,5
/* 0x01d8	 746 */		add	%i0,%l5,%o0
/* 0x01dc	     */		or	%g0,0,%o2
/* 0x01e0	     */		or	%g0,%o3,%o1
/* 0x01e4	 747 */		bl,pn	%icc,.L77004770
/* 0x01e8	     */		nop

! Registers live out of .L77004769: 
! o0 o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004769

			.L900001577:
/* 0x01ec	 747 */		sub	%l2,3,%l6
/* 0x01f0	 746 */		or	%g0,1,%o2
/* 0x01f4	 747 */		ld	[%o0],%l1
/* 0x01f8	 746 */		add	%o0,4,%o0

! Registers live out of .L900001577: 
! o0 o1 o2 sp l1 l2 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001575 .L900001577

			.L900001575:
/* 0x01fc	 747 */		prefetch	[%o0+180],0
/* 0x0200	     */		prefetch	[%o1+90],2
/* 0x0204	 746 */		add	%o2,4,%o2
/* 0x0208	 747 */		ld	[%o0],%i1
/* 0x020c	 746 */		add	%o0,16,%o0
/* 0x0210	 747 */		sth	%l1,[%o1]
/* 0x0214	 746 */		cmp	%o2,%l6
/* 0x0218	     */		add	%o1,8,%o1
/* 0x021c	 747 */		ld	[%o0-12],%o3
/* 0x0220	     */		sth	%i1,[%o1-6]
/* 0x0224	     */		ld	[%o0-8],%i2
/* 0x0228	     */		sth	%o3,[%o1-4]
/* 0x022c	     */		ld	[%o0-4],%l1
/* 0x0230	 746 */		ble,pt	%icc,.L900001575
/* 0x0234	 747 */		sth	%i2,[%o1-2]

! Registers live out of .L900001575: 
! o0 o1 o2 sp l1 l2 l6 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001575

			.L900001578:
/* 0x0238	 746 */		cmp	%o2,%l2
/* 0x023c	 747 */		sth	%l1,[%o1]
/* 0x0240	 746 */		add	%o1,2,%o1
/* 0x0244	     */		bg,pn	%icc,.L900001538
/* 0x0248	 747 */		nop

! Registers live out of .L900001578: 
! o0 o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004769 .L900001578

			.L77004770:
/* 0x024c	 746 */		add	%o2,1,%o2

! Registers live out of .L77004770: 
! o0 o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004770 .L900001611

			.L900001611:
/* 0x0250	 746 */		cmp	%o2,%l2
/* 0x0254	 747 */		ld	[%o0],%l1
/* 0x0258	 746 */		add	%o0,4,%o0
/* 0x025c	 747 */		sth	%l1,[%o1]
/* 0x0260	 746 */		add	%o1,2,%o1
/* 0x0264	     */		ble,pt	%icc,.L900001611
/* 0x0268	     */		add	%o2,1,%o2

! Registers live out of .L900001611: 
! o0 o1 o2 sp l2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001578 .L900001611

			.L900001538:
/* 0x026c	 744 */		ret	! Result = 
/* 0x0270	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004629

			.L77004860:
/* 0x0274	 746 */		or	%g0,0,%g5

! Registers live out of .L77004860: 
! g5 o0 o1 o3 sp i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004685 .L77004860

			.L77004828:
/* 0x0278	 746 */		add	%o1,640,%o4
/* 0x027c	 747 */		sll	%g5,1,%l3
/* 0x0280	     */		add	%i0,%o4,%i3

! Registers live out of .L77004828: 
! g5 o0 o3 sp i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004681 .L77004828

			.L900001609:
/* 0x0284	 747 */		sll	%g5,2,%i0
/* 0x0288	 746 */		add	%g5,1,%g5
/* 0x028c	 747 */		ld	[%i3+%i0],%l4
/* 0x0290	 746 */		cmp	%g5,%o0
/* 0x0294	     */		bcc,pn	%icc,.L77004610
/* 0x0298	 747 */		sth	%l4,[%l3+%o3]

! Registers live out of .L900001609: 
! g5 o0 o3 sp i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001609

			.L77004681:
/* 0x029c	 747 */		sll	%g5,1,%i1
/* 0x02a0	     */		sll	%g5,2,%l0
/* 0x02a4	     */		ld	[%i3+%l0],%o1
/* 0x02a8	 746 */		add	%g5,1,%g5
/* 0x02ac	     */		cmp	%g5,%o0
/* 0x02b0	 747 */		sth	%o1,[%i1+%o3]
/* 0x02b4	 746 */		bcs,pt	%icc,.L900001609
/* 0x02b8	 747 */		sll	%g5,1,%l3

! Registers live out of .L77004681: 
! g5 o0 o3 sp i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004681

			.L900001537:
/* 0x02bc	 744 */		ret	! Result = 
/* 0x02c0	     */		restore	%g0,0,%g0

!  748		      !	 }
!  749		      !	 break;
!  750		      !      case GL_PIXEL_MAP_I_TO_R:
!  751		      !	 for (i=0;i<ctx->Pixel.MapItoRsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004525:
/* 0x02c4	 751 */		add	%o1,608,%l1
/* 0x02c8	     */		ld	[%i0+%l1],%g2
/* 0x02cc	     */		orcc	%g0,%g2,%g0
/* 0x02d0	     */		bleu,pn	%icc,.L77004610
/* 0x02d4	     */		cmp	%g2,2

! Registers live out of .L77004525: 
! g2 o3 sp o7 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004525

			.L77004628:
/* 0x02d8	 751 */		bl,pn	%icc,.L77004862
/* 0x02dc	     */		add	%o7,1022,%g3

! Registers live out of .L77004628: 
! g2 g3 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004628

			.L77004677:
/* 0x02e0	 751 */		sub	%g2,%g3,%g4
/* 0x02e4	     */		srlx	%g4,63,%i2
/* 0x02e8	     */		andcc	%i2,1,%g0
/* 0x02ec	     */		be,a,pn	%icc,.L77004826
/* 0x02f0	     */		or	%g0,0,%l3

! Registers live out of .L77004677: 
! g2 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004677

			.L77004767:
/* 0x02f4	 751 */		sethi	%hi(0xb400),%l0

!  752		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapItoR[i] );

/* 0x02f8	 752 */		add	%g2,0,%i5
/* 0x02fc	 751 */		add	%l0,640,%o7
/* 0x0300	     */		add	%g2,-1,%g5
/* 0x0304	 752 */		cmp	%i5,11
/* 0x0308	 751 */		add	%i0,%o7,%g1
/* 0x030c	     */		or	%g0,0,%g2
/* 0x0310	     */		or	%g0,%o3,%l0
/* 0x0314	     */		ld	[%i3+40],%f12
/* 0x0318	 752 */		bl,pn	%icc,.L77004768
/* 0x031c	     */		nop

! Registers live out of .L77004767: 
! g1 g2 g5 sp l0 fp i7 gsr 
! f12 
		                       
! predecessor blocks: .L77004767

			.L900001573:
/* 0x0320	 752 */		ld	[%g1],%f18
/* 0x0324	     */		ld	[%g1+20],%f0
/* 0x0328	     */		ld	[%g1+12],%f22
/* 0x032c	     */		ld	[%g1+8],%f20
/* 0x0330	     */		ld	[%g1+4],%f16
/* 0x0334	     */		ld	[%g1+16],%f24
/* 0x0338	     */		fmuls	%f18,%f12,%f30
/* 0x033c	     */		ld	[%g1+24],%f2
/* 0x0340	     */		fmuls	%f16,%f12,%f26
/* 0x0344	     */		fmuls	%f20,%f12,%f3
/* 0x0348	     */		fmuls	%f22,%f12,%f1
/* 0x034c	     */		fmuls	%f24,%f12,%f10
/* 0x0350	     */		fstoi	%f30,%f11
/* 0x0354	     */		st	%f11,[%sp+104]
/* 0x0358	     */		ld	[%sp+104],%g3
/* 0x035c	     */		fstoi	%f26,%f28
/* 0x0360	     */		st	%f28,[%sp+100]
/* 0x0364	     */		fstoi	%f3,%f13
/* 0x0368	     */		ld	[%sp+100],%g4
/* 0x036c	 751 */		add	%g1,28,%g1
/* 0x0370	 752 */		st	%f13,[%sp+96]
/* 0x0374	 751 */		or	%g0,7,%g2
/* 0x0378	 752 */		fstoi	%f1,%f15
/* 0x037c	     */		st	%f15,[%sp+92]
/* 0x0380	     */		sub	%g5,3,%l3

! Registers live out of .L900001573: 
! g1 g2 g3 g4 g5 sp l0 fp i7 gsr 
! f0 f2 f10 f12 
		                       
! predecessor blocks: .L900001571 .L900001573

			.L900001571:
/* 0x0384	 752 */		prefetch	[%g1+180],0
/* 0x0388	     */		prefetch	[%l0+90],2
/* 0x038c	     */		fstoi	%f10,%f17
/* 0x0390	 751 */		add	%g2,4,%g2
/* 0x0394	 752 */		ld	[%g1],%f21
/* 0x0398	     */		fmuls	%f0,%f12,%f0
/* 0x039c	     */		st	%f17,[%sp+104]
/* 0x03a0	 751 */		cmp	%g2,%l3
/* 0x03a4	     */		add	%g1,16,%g1
/* 0x03a8	     */		add	%l0,8,%l0
/* 0x03ac	 752 */		ld	[%sp+96],%l7
/* 0x03b0	     */		sth	%g3,[%l0-8]
/* 0x03b4	     */		fstoi	%f0,%f19
/* 0x03b8	     */		fmuls	%f2,%f12,%f7
/* 0x03bc	     */		ld	[%g1-12],%f27
/* 0x03c0	     */		st	%f19,[%sp+100]
/* 0x03c4	     */		ld	[%sp+92],%i0
/* 0x03c8	     */		sth	%g4,[%l0-6]
/* 0x03cc	     */		fstoi	%f7,%f23
/* 0x03d0	     */		fmuls	%f21,%f12,%f25
/* 0x03d4	     */		ld	[%g1-8],%f0
/* 0x03d8	     */		st	%f23,[%sp+96]
/* 0x03dc	     */		ld	[%sp+104],%g3
/* 0x03e0	     */		sth	%l7,[%l0-4]
/* 0x03e4	     */		fstoi	%f25,%f29
/* 0x03e8	     */		fmuls	%f27,%f12,%f10
/* 0x03ec	     */		ld	[%g1-4],%f2
/* 0x03f0	     */		st	%f29,[%sp+92]
/* 0x03f4	     */		ld	[%sp+100],%g4
/* 0x03f8	 751 */		ble,pt	%icc,.L900001571
/* 0x03fc	 752 */		sth	%i0,[%l0-2]

! Registers live out of .L900001571: 
! g1 g2 g3 g4 g5 sp l0 fp i7 gsr 
! f0 f2 f10 f12 
		                       
! predecessor blocks: .L900001571

			.L900001574:
/* 0x0400	 752 */		sth	%g3,[%l0]
/* 0x0404	     */		ld	[%sp+96],%i4
/* 0x0408	     */		sth	%g4,[%l0+2]
/* 0x040c	     */		ld	[%sp+92],%o2
/* 0x0410	     */		fmuls	%f2,%f12,%f8
/* 0x0414	     */		fmuls	%f0,%f12,%f4
/* 0x0418	     */		fstoi	%f10,%f6
/* 0x041c	     */		st	%f6,[%sp+104]
/* 0x0420	     */		ld	[%sp+104],%o1
/* 0x0424	 751 */		add	%l0,14,%l0
/* 0x0428	 752 */		sth	%i4,[%l0-10]
/* 0x042c	     */		sth	%o2,[%l0-8]
/* 0x0430	     */		sth	%o1,[%l0-6]
/* 0x0434	     */		fstoi	%f8,%f5
/* 0x0438	     */		st	%f5,[%sp+96]
/* 0x043c	     */		ld	[%sp+96],%o0
/* 0x0440	     */		fstoi	%f4,%f9
/* 0x0444	     */		st	%f9,[%sp+100]
/* 0x0448	     */		ld	[%sp+100],%i3
/* 0x044c	     */		sth	%i3,[%l0-4]
/* 0x0450	 751 */		cmp	%g2,%g5
/* 0x0454	 752 */		sth	%o0,[%l0-2]
/* 0x0458	 751 */		bg,pn	%icc,.L900001536
/* 0x045c	 752 */		nop

! Registers live out of .L900001574: 
! g1 g2 g5 sp l0 fp i7 gsr 
! f12 
		                       
! predecessor blocks: .L77004767 .L900001574

			.L77004768:
/* 0x0460	 752 */		ld	[%g1],%f10

! Registers live out of .L77004768: 
! g1 g2 g5 sp l0 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L77004768 .L900001608

			.L900001608:
/* 0x0464	 752 */		fmuls	%f10,%f12,%f19
/* 0x0468	 751 */		add	%g2,1,%g2
/* 0x046c	     */		cmp	%g2,%g5
/* 0x0470	     */		add	%g1,4,%g1
/* 0x0474	 752 */		fstoi	%f19,%f2
/* 0x0478	     */		st	%f2,[%sp+220]
/* 0x047c	     */		ld	[%sp+220],%o2
/* 0x0480	     */		sth	%o2,[%l0]
/* 0x0484	 751 */		add	%l0,2,%l0
/* 0x0488	     */		ble,a,pt	%icc,.L900001608
/* 0x048c	 752 */		ld	[%g1],%f10

! Registers live out of .L900001608: 
! g1 g2 g5 sp l0 fp i7 gsr 
! f10 f12 
		                       
! predecessor blocks: .L900001574 .L900001608

			.L900001536:
/* 0x0490	 744 */		ret	! Result = 
/* 0x0494	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004628

			.L77004862:
/* 0x0498	 751 */		or	%g0,0,%l3

! Registers live out of .L77004862: 
! g2 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004677 .L77004862

			.L77004826:
/* 0x049c	 751 */		sethi	%hi(0xb400),%i1
/* 0x04a0	     */		add	%i1,640,%i2
/* 0x04a4	 752 */		add	%i0,%i2,%l4
/* 0x04a8	 751 */		ld	[%i3+40],%f21
/* 0x04ac	 752 */		sll	%l3,2,%i0

! Registers live out of .L77004826: 
! g2 o3 sp l4 i0 fp i7 gsr 
! f21 
		                       
! predecessor blocks: .L77004826 .L900001606

			.L900001606:
/* 0x04b0	 752 */		ld	[%l4+%i0],%f10
/* 0x04b4	     */		sll	%l3,1,%i5
/* 0x04b8	 751 */		add	%l3,1,%l3
/* 0x04bc	 752 */		fmuls	%f10,%f21,%f19
/* 0x04c0	 751 */		cmp	%l3,%g2
/* 0x04c4	 752 */		fstoi	%f19,%f2
/* 0x04c8	     */		st	%f2,[%sp+220]
/* 0x04cc	     */		ld	[%sp+220],%l7
/* 0x04d0	     */		sth	%l7,[%i5+%o3]
/* 0x04d4	 751 */		bcs,pt	%icc,.L900001606
/* 0x04d8	 752 */		sll	%l3,2,%i0

! Registers live out of .L900001606: 
! g2 o3 sp l4 i0 fp i7 gsr 
! f21 
		                       
! predecessor blocks: .L900001606

			.L900001535:
/* 0x04dc	 744 */		ret	! Result = 
/* 0x04e0	     */		restore	%g0,0,%g0

!  753		      !	 }
!  754		      !	 break;
!  755		      !      case GL_PIXEL_MAP_I_TO_G:
!  756		      !	 for (i=0;i<ctx->Pixel.MapItoGsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004535:
/* 0x04e4	 756 */		add	%o1,612,%l2
/* 0x04e8	     */		ld	[%i0+%l2],%o5
/* 0x04ec	     */		orcc	%g0,%o5,%g0
/* 0x04f0	     */		bleu,pn	%icc,.L77004610
/* 0x04f4	     */		cmp	%o5,2

! Registers live out of .L77004535: 
! o3 o5 sp o7 i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004535

			.L77004627:
/* 0x04f8	 756 */		bl,pn	%icc,.L77004864
/* 0x04fc	     */		add	%o7,1022,%g1

! Registers live out of .L77004627: 
! g1 o3 o5 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004627

			.L77004669:
/* 0x0500	 756 */		sub	%o5,%g1,%o2
/* 0x0504	     */		srlx	%o2,63,%l6
/* 0x0508	     */		andcc	%l6,1,%g0
/* 0x050c	     */		be,a,pn	%icc,.L77004824
/* 0x0510	     */		or	%g0,0,%i4

! Registers live out of .L77004669: 
! o3 o5 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004669

			.L77004765:
/* 0x0514	 756 */		add	%o5,-1,%l7
/* 0x0518	     */		sethi	%hi(0xb800),%o5

!  757		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapItoG[i] );

/* 0x051c	 757 */		add	%l7,1,%l4
/* 0x0520	 756 */		add	%o5,640,%o4
/* 0x0524	 757 */		cmp	%l4,11
/* 0x0528	 756 */		add	%i0,%o4,%o5
/* 0x052c	     */		or	%g0,0,%o7
/* 0x0530	     */		ld	[%i3+40],%f18
/* 0x0534	 757 */		bl,pn	%icc,.L77004766
/* 0x0538	     */		nop

! Registers live out of .L77004765: 
! o3 o5 sp o7 l7 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77004765

			.L900001569:
/* 0x053c	 757 */		ld	[%o5],%f4
/* 0x0540	     */		ld	[%o5+20],%f0
/* 0x0544	     */		ld	[%o5+12],%f6
/* 0x0548	     */		ld	[%o5+8],%f5
/* 0x054c	     */		ld	[%o5+4],%f8
/* 0x0550	     */		ld	[%o5+16],%f20
/* 0x0554	     */		fmuls	%f4,%f18,%f9
/* 0x0558	     */		ld	[%o5+24],%f16
/* 0x055c	     */		fmuls	%f8,%f18,%f22
/* 0x0560	     */		fmuls	%f5,%f18,%f28
/* 0x0564	     */		fmuls	%f6,%f18,%f11
/* 0x0568	     */		fmuls	%f20,%f18,%f14
/* 0x056c	     */		fstoi	%f9,%f26
/* 0x0570	     */		st	%f26,[%sp+120]
/* 0x0574	     */		ld	[%sp+120],%l5
/* 0x0578	     */		fstoi	%f22,%f24
/* 0x057c	     */		st	%f24,[%sp+116]
/* 0x0580	     */		fstoi	%f28,%f30
/* 0x0584	     */		ld	[%sp+116],%l6
/* 0x0588	 756 */		add	%o5,28,%o5
/* 0x058c	 757 */		st	%f30,[%sp+112]
/* 0x0590	 756 */		or	%g0,7,%o7
/* 0x0594	 757 */		fstoi	%f11,%f3
/* 0x0598	     */		st	%f3,[%sp+108]
/* 0x059c	     */		sub	%l7,3,%o4

! Registers live out of .L900001569: 
! o3 o4 o5 sp o7 l5 l6 l7 fp i7 gsr 
! f0 f14 f16 f18 
		                       
! predecessor blocks: .L900001567 .L900001569

			.L900001567:
/* 0x05a0	 757 */		prefetch	[%o5+180],0
/* 0x05a4	     */		prefetch	[%o3+90],2
/* 0x05a8	     */		fstoi	%f14,%f13
/* 0x05ac	 756 */		add	%o7,4,%o7
/* 0x05b0	 757 */		ld	[%o5],%f17
/* 0x05b4	     */		fmuls	%f0,%f18,%f1
/* 0x05b8	     */		st	%f13,[%sp+120]
/* 0x05bc	 756 */		cmp	%o7,%o4
/* 0x05c0	     */		add	%o5,16,%o5
/* 0x05c4	     */		add	%o3,8,%o3
/* 0x05c8	 757 */		ld	[%sp+112],%l3
/* 0x05cc	     */		sth	%l5,[%o3-8]
/* 0x05d0	     */		fstoi	%f1,%f15
/* 0x05d4	     */		fmuls	%f16,%f18,%f16
/* 0x05d8	     */		ld	[%o5-12],%f21
/* 0x05dc	     */		st	%f15,[%sp+116]
/* 0x05e0	     */		ld	[%sp+108],%l2
/* 0x05e4	     */		sth	%l6,[%o3-6]
/* 0x05e8	     */		fstoi	%f16,%f19
/* 0x05ec	     */		fmuls	%f17,%f18,%f7
/* 0x05f0	     */		ld	[%o5-8],%f0
/* 0x05f4	     */		st	%f19,[%sp+112]
/* 0x05f8	     */		ld	[%sp+120],%l5
/* 0x05fc	     */		sth	%l3,[%o3-4]
/* 0x0600	     */		fstoi	%f7,%f23
/* 0x0604	     */		fmuls	%f21,%f18,%f14
/* 0x0608	     */		ld	[%o5-4],%f16
/* 0x060c	     */		st	%f23,[%sp+108]
/* 0x0610	     */		ld	[%sp+116],%l6
/* 0x0614	 756 */		ble,pt	%icc,.L900001567
/* 0x0618	 757 */		sth	%l2,[%o3-2]

! Registers live out of .L900001567: 
! o3 o4 o5 sp o7 l5 l6 l7 fp i7 gsr 
! f0 f14 f16 f18 
		                       
! predecessor blocks: .L900001567

			.L900001570:
/* 0x061c	 757 */		sth	%l5,[%o3]
/* 0x0620	     */		ld	[%sp+112],%g5
/* 0x0624	     */		sth	%l6,[%o3+2]
/* 0x0628	     */		ld	[%sp+108],%g4
/* 0x062c	     */		fmuls	%f16,%f18,%f10
/* 0x0630	     */		fmuls	%f0,%f18,%f2
/* 0x0634	     */		fstoi	%f14,%f31
/* 0x0638	     */		st	%f31,[%sp+120]
/* 0x063c	     */		ld	[%sp+120],%g3
/* 0x0640	 756 */		add	%o3,14,%o3
/* 0x0644	 757 */		sth	%g5,[%o3-10]
/* 0x0648	     */		sth	%g4,[%o3-8]
/* 0x064c	     */		sth	%g3,[%o3-6]
/* 0x0650	     */		fstoi	%f10,%f12
/* 0x0654	     */		st	%f12,[%sp+112]
/* 0x0658	     */		ld	[%sp+112],%g1
/* 0x065c	     */		fstoi	%f2,%f14
/* 0x0660	     */		st	%f14,[%sp+116]
/* 0x0664	     */		ld	[%sp+116],%g2
/* 0x0668	     */		sth	%g2,[%o3-4]
/* 0x066c	 756 */		cmp	%o7,%l7
/* 0x0670	 757 */		sth	%g1,[%o3-2]
/* 0x0674	 756 */		bg,pn	%icc,.L900001534
/* 0x0678	 757 */		nop

! Registers live out of .L900001570: 
! o3 o5 sp o7 l7 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77004765 .L900001570

			.L77004766:
/* 0x067c	 757 */		ld	[%o5],%f21

! Registers live out of .L77004766: 
! o3 o5 sp o7 l7 fp i7 gsr 
! f18 f21 
		                       
! predecessor blocks: .L77004766 .L900001605

			.L900001605:
/* 0x0680	 757 */		fmuls	%f21,%f18,%f14
/* 0x0684	 756 */		add	%o7,1,%o7
/* 0x0688	     */		cmp	%o7,%l7
/* 0x068c	     */		add	%o5,4,%o5
/* 0x0690	 757 */		fstoi	%f14,%f31
/* 0x0694	     */		st	%f31,[%sp+220]
/* 0x0698	     */		ld	[%sp+220],%i3
/* 0x069c	     */		sth	%i3,[%o3]
/* 0x06a0	 756 */		add	%o3,2,%o3
/* 0x06a4	     */		ble,a,pt	%icc,.L900001605
/* 0x06a8	 757 */		ld	[%o5],%f21

! Registers live out of .L900001605: 
! o3 o5 sp o7 l7 fp i7 gsr 
! f18 f21 
		                       
! predecessor blocks: .L900001570 .L900001605

			.L900001534:
/* 0x06ac	 744 */		ret	! Result = 
/* 0x06b0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004627

			.L77004864:
/* 0x06b4	 756 */		or	%g0,0,%i4

! Registers live out of .L77004864: 
! o3 o5 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004669 .L77004864

			.L77004824:
/* 0x06b8	 756 */		sethi	%hi(0xb800),%l7
/* 0x06bc	     */		add	%l7,640,%o1
/* 0x06c0	 757 */		sll	%i4,2,%l2
/* 0x06c4	 756 */		ld	[%i3+40],%f9
/* 0x06c8	 757 */		add	%i0,%o1,%l5

! Registers live out of .L77004824: 
! o3 o5 sp l2 l5 i4 fp i7 gsr 
! f9 
		                       
! predecessor blocks: .L77004824 .L900001603

			.L900001603:
/* 0x06cc	 757 */		ld	[%l5+%l2],%f14
/* 0x06d0	     */		sll	%i4,1,%o4
/* 0x06d4	 756 */		add	%i4,1,%i4
/* 0x06d8	 757 */		fmuls	%f14,%f9,%f31
/* 0x06dc	 756 */		cmp	%i4,%o5
/* 0x06e0	 757 */		fstoi	%f31,%f8
/* 0x06e4	     */		st	%f8,[%sp+220]
/* 0x06e8	     */		ld	[%sp+220],%l1
/* 0x06ec	     */		sth	%l1,[%o4+%o3]
/* 0x06f0	 756 */		bcs,pt	%icc,.L900001603
/* 0x06f4	 757 */		sll	%i4,2,%l2

! Registers live out of .L900001603: 
! o3 o5 sp l2 l5 i4 fp i7 gsr 
! f9 
		                       
! predecessor blocks: .L900001603

			.L900001533:
/* 0x06f8	 744 */		ret	! Result = 
/* 0x06fc	     */		restore	%g0,0,%g0

!  758		      !	 }
!  759		      !	 break;
!  760		      !      case GL_PIXEL_MAP_I_TO_B:
!  761		      !	 for (i=0;i<ctx->Pixel.MapItoBsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004545:
/* 0x0700	 761 */		add	%o1,616,%o5
/* 0x0704	     */		ld	[%i0+%o5],%g3
/* 0x0708	     */		orcc	%g0,%g3,%g0
/* 0x070c	     */		bleu,pn	%icc,.L77004610
/* 0x0710	     */		cmp	%g3,2

! Registers live out of .L77004545: 
! g3 o3 sp o7 i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004545

			.L77004626:
/* 0x0714	 761 */		bl,pn	%icc,.L77004866
/* 0x0718	     */		add	%o7,1022,%o1

! Registers live out of .L77004626: 
! g3 o1 o3 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004626

			.L77004661:
/* 0x071c	 761 */		sub	%g3,%o1,%o0
/* 0x0720	     */		srlx	%o0,63,%l0
/* 0x0724	     */		andcc	%l0,1,%g0
/* 0x0728	     */		be,a,pn	%icc,.L77004822
/* 0x072c	     */		or	%g0,0,%i2

! Registers live out of .L77004661: 
! g3 o3 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004661

			.L77004763:
/* 0x0730	 761 */		sethi	%hi(0xbc00),%i1
/* 0x0734	     */		add	%i1,640,%i2

!  762		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapItoB[i] );

/* 0x0738	 762 */		cmp	%g3,11
/* 0x073c	 761 */		add	%g3,-1,%o4
/* 0x0740	     */		add	%i0,%i2,%i5
/* 0x0744	     */		or	%g0,0,%i4
/* 0x0748	     */		ld	[%i3+40],%f26
/* 0x074c	     */		or	%g0,%o3,%i3
/* 0x0750	 762 */		bl,pn	%icc,.L77004764
/* 0x0754	     */		nop

! Registers live out of .L77004763: 
! g3 o4 sp i3 i4 i5 fp i7 gsr 
! f26 
		                       
! predecessor blocks: .L77004763

			.L900001565:
/* 0x0758	 762 */		ld	[%i5],%f10
/* 0x075c	     */		ld	[%i5+20],%f20
/* 0x0760	     */		ld	[%i5+12],%f2
/* 0x0764	     */		ld	[%i5+8],%f12
/* 0x0768	     */		ld	[%i5+4],%f31
/* 0x076c	     */		ld	[%i5+16],%f14
/* 0x0770	     */		fmuls	%f10,%f26,%f9
/* 0x0774	     */		ld	[%i5+24],%f24
/* 0x0778	     */		fmuls	%f31,%f26,%f8
/* 0x077c	     */		fmuls	%f12,%f26,%f5
/* 0x0780	     */		fmuls	%f2,%f26,%f6
/* 0x0784	     */		fmuls	%f14,%f26,%f22
/* 0x0788	     */		fstoi	%f9,%f28
/* 0x078c	     */		st	%f28,[%sp+136]
/* 0x0790	     */		ld	[%sp+136],%i2
/* 0x0794	     */		fstoi	%f8,%f4
/* 0x0798	     */		st	%f4,[%sp+132]
/* 0x079c	     */		fstoi	%f5,%f30
/* 0x07a0	     */		ld	[%sp+132],%i1
/* 0x07a4	 761 */		add	%i5,28,%i5
/* 0x07a8	 762 */		st	%f30,[%sp+128]
/* 0x07ac	 761 */		or	%g0,7,%i4
/* 0x07b0	 762 */		fstoi	%f6,%f11
/* 0x07b4	     */		st	%f11,[%sp+124]
/* 0x07b8	     */		add	%g3,-4,%l4

! Registers live out of .L900001565: 
! o4 sp l4 i1 i2 i3 i4 i5 fp i7 gsr 
! f20 f22 f24 f26 
		                       
! predecessor blocks: .L900001563 .L900001565

			.L900001563:
/* 0x07bc	 762 */		prefetch	[%i5+180],0
/* 0x07c0	     */		prefetch	[%i3+90],2
/* 0x07c4	     */		fstoi	%f22,%f22
/* 0x07c8	 761 */		add	%i4,4,%i4
/* 0x07cc	 762 */		ld	[%i5],%f13
/* 0x07d0	     */		fmuls	%f20,%f26,%f20
/* 0x07d4	     */		st	%f22,[%sp+136]
/* 0x07d8	 761 */		cmp	%i4,%l4
/* 0x07dc	     */		add	%i5,16,%i5
/* 0x07e0	     */		add	%i3,8,%i3
/* 0x07e4	 762 */		ld	[%sp+128],%o3
/* 0x07e8	     */		sth	%i2,[%i3-8]
/* 0x07ec	     */		fstoi	%f20,%f3
/* 0x07f0	     */		fmuls	%f24,%f26,%f24
/* 0x07f4	     */		ld	[%i5-12],%f16
/* 0x07f8	     */		st	%f3,[%sp+132]
/* 0x07fc	     */		ld	[%sp+124],%o2
/* 0x0800	     */		sth	%i1,[%i3-6]
/* 0x0804	     */		fstoi	%f24,%f1
/* 0x0808	     */		fmuls	%f13,%f26,%f15
/* 0x080c	     */		ld	[%i5-8],%f20
/* 0x0810	     */		st	%f1,[%sp+128]
/* 0x0814	     */		ld	[%sp+136],%i2
/* 0x0818	     */		sth	%o3,[%i3-4]
/* 0x081c	     */		fstoi	%f15,%f17
/* 0x0820	     */		fmuls	%f16,%f26,%f22
/* 0x0824	     */		ld	[%i5-4],%f24
/* 0x0828	     */		st	%f17,[%sp+124]
/* 0x082c	     */		ld	[%sp+132],%i1
/* 0x0830	 761 */		ble,pt	%icc,.L900001563
/* 0x0834	 762 */		sth	%o2,[%i3-2]

! Registers live out of .L900001563: 
! o4 sp l4 i1 i2 i3 i4 i5 fp i7 gsr 
! f20 f22 f24 f26 
		                       
! predecessor blocks: .L900001563

			.L900001566:
/* 0x0838	 762 */		sth	%i2,[%i3]
/* 0x083c	     */		ld	[%sp+128],%l6
/* 0x0840	     */		sth	%i1,[%i3+2]
/* 0x0844	     */		ld	[%sp+124],%l1
/* 0x0848	     */		fmuls	%f24,%f26,%f0
/* 0x084c	     */		fmuls	%f20,%f26,%f27
/* 0x0850	     */		fstoi	%f22,%f18
/* 0x0854	     */		st	%f18,[%sp+136]
/* 0x0858	     */		ld	[%sp+136],%l5
/* 0x085c	 761 */		add	%i3,14,%i3
/* 0x0860	 762 */		sth	%l6,[%i3-10]
/* 0x0864	     */		sth	%l1,[%i3-8]
/* 0x0868	     */		sth	%l5,[%i3-6]
/* 0x086c	     */		fstoi	%f0,%f25
/* 0x0870	     */		st	%f25,[%sp+128]
/* 0x0874	     */		ld	[%sp+128],%o7
/* 0x0878	     */		fstoi	%f27,%f29
/* 0x087c	     */		st	%f29,[%sp+132]
/* 0x0880	     */		ld	[%sp+132],%l0
/* 0x0884	     */		sth	%l0,[%i3-4]
/* 0x0888	 761 */		cmp	%i4,%o4
/* 0x088c	 762 */		sth	%o7,[%i3-2]
/* 0x0890	 761 */		bg,pn	%icc,.L900001532
/* 0x0894	 762 */		nop

! Registers live out of .L900001566: 
! o4 sp i3 i4 i5 fp i7 gsr 
! f26 
		                       
! predecessor blocks: .L77004763 .L900001566

			.L77004764:
/* 0x0898	 762 */		ld	[%i5],%f8

! Registers live out of .L77004764: 
! o4 sp i3 i4 i5 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L77004764 .L900001602

			.L900001602:
/* 0x089c	 762 */		fmuls	%f8,%f26,%f9
/* 0x08a0	 761 */		add	%i4,1,%i4
/* 0x08a4	     */		cmp	%i4,%o4
/* 0x08a8	     */		add	%i5,4,%i5
/* 0x08ac	 762 */		fstoi	%f9,%f28
/* 0x08b0	     */		st	%f28,[%sp+220]
/* 0x08b4	     */		ld	[%sp+220],%i0
/* 0x08b8	     */		sth	%i0,[%i3]
/* 0x08bc	 761 */		add	%i3,2,%i3
/* 0x08c0	     */		ble,a,pt	%icc,.L900001602
/* 0x08c4	 762 */		ld	[%i5],%f8

! Registers live out of .L900001602: 
! o4 sp i3 i4 i5 fp i7 gsr 
! f8 f26 
		                       
! predecessor blocks: .L900001566 .L900001602

			.L900001532:
/* 0x08c8	 744 */		ret	! Result = 
/* 0x08cc	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004626

			.L77004866:
/* 0x08d0	 761 */		or	%g0,0,%i2

! Registers live out of .L77004866: 
! g3 o3 sp i0 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004661 .L77004866

			.L77004822:
/* 0x08d4	 761 */		sethi	%hi(0xbc00),%i5
/* 0x08d8	     */		add	%i5,640,%o0
/* 0x08dc	 762 */		sll	%i2,2,%i1
/* 0x08e0	 761 */		ld	[%i3+40],%f30
/* 0x08e4	 762 */		add	%i0,%o0,%i3

! Registers live out of .L77004822: 
! g3 o3 sp i1 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L77004822 .L900001600

			.L900001600:
/* 0x08e8	 762 */		ld	[%i3+%i1],%f28
/* 0x08ec	     */		sll	%i2,1,%g4
/* 0x08f0	 761 */		add	%i2,1,%i2
/* 0x08f4	 762 */		fmuls	%f28,%f30,%f4
/* 0x08f8	 761 */		cmp	%i2,%g3
/* 0x08fc	 762 */		fstoi	%f4,%f23
/* 0x0900	     */		st	%f23,[%sp+220]
/* 0x0904	     */		ld	[%sp+220],%g5
/* 0x0908	     */		sth	%g5,[%g4+%o3]
/* 0x090c	 761 */		bcs,pt	%icc,.L900001600
/* 0x0910	 762 */		sll	%i2,2,%i1

! Registers live out of .L900001600: 
! g3 o3 sp i1 i2 i3 fp i7 gsr 
! f30 
		                       
! predecessor blocks: .L900001600

			.L900001531:
/* 0x0914	 744 */		ret	! Result = 
/* 0x0918	     */		restore	%g0,0,%g0

!  763		      !	 }
!  764		      !	 break;
!  765		      !      case GL_PIXEL_MAP_I_TO_A:
!  766		      !	 for (i=0;i<ctx->Pixel.MapItoAsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004555:
/* 0x091c	 766 */		add	%o1,620,%l6
/* 0x0920	     */		ld	[%i0+%l6],%g2
/* 0x0924	     */		orcc	%g0,%g2,%g0
/* 0x0928	     */		bleu,pn	%icc,.L77004610
/* 0x092c	     */		cmp	%g2,2

! Registers live out of .L77004555: 
! g2 o3 sp o7 l6 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004555

			.L77004625:
/* 0x0930	 766 */		bl,pn	%icc,.L77004868
/* 0x0934	     */		add	%o7,1022,%g1

! Registers live out of .L77004625: 
! g1 g2 o3 sp l6 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004625

			.L77004653:
/* 0x0938	 766 */		sub	%g2,%g1,%o2
/* 0x093c	     */		srlx	%o2,63,%l7
/* 0x0940	     */		andcc	%l7,1,%g0
/* 0x0944	     */		be,a,pn	%icc,.L77004820
/* 0x0948	     */		or	%g0,0,%l6

! Registers live out of .L77004653: 
! g2 o3 sp l6 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004653

			.L77004761:
/* 0x094c	 766 */		sethi	%hi(0xc000),%o1
/* 0x0950	     */		add	%o1,640,%i5

!  767		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapItoA[i] );

/* 0x0954	 767 */		cmp	%g2,11
/* 0x0958	 766 */		add	%g2,-1,%o2
/* 0x095c	     */		add	%i0,%i5,%g4
/* 0x0960	     */		or	%g0,0,%g5
/* 0x0964	     */		or	%g0,%o3,%g3
/* 0x0968	     */		ld	[%i3+40],%f3
/* 0x096c	 767 */		bl,pn	%icc,.L77004762
/* 0x0970	     */		nop

! Registers live out of .L77004761: 
! g2 g3 g4 g5 o2 sp fp i7 gsr 
! f3 
		                       
! predecessor blocks: .L77004761

			.L900001561:
/* 0x0974	 767 */		ld	[%g4],%f0
/* 0x0978	     */		ld	[%g4+20],%f28
/* 0x097c	     */		ld	[%g4+12],%f27
/* 0x0980	     */		ld	[%g4+8],%f25
/* 0x0984	     */		ld	[%g4+4],%f18
/* 0x0988	     */		ld	[%g4+16],%f29
/* 0x098c	     */		fmuls	%f0,%f3,%f12
/* 0x0990	     */		ld	[%g4+24],%f11
/* 0x0994	     */		fmuls	%f18,%f3,%f31
/* 0x0998	     */		fmuls	%f25,%f3,%f14
/* 0x099c	     */		fmuls	%f27,%f3,%f4
/* 0x09a0	     */		fmuls	%f29,%f3,%f30
/* 0x09a4	     */		fstoi	%f12,%f2
/* 0x09a8	     */		st	%f2,[%sp+152]
/* 0x09ac	     */		ld	[%sp+152],%o0
/* 0x09b0	     */		fstoi	%f31,%f10
/* 0x09b4	     */		st	%f10,[%sp+148]
/* 0x09b8	     */		fstoi	%f14,%f8
/* 0x09bc	     */		ld	[%sp+148],%o1
/* 0x09c0	 766 */		add	%g4,28,%g4
/* 0x09c4	 767 */		st	%f8,[%sp+144]
/* 0x09c8	 766 */		or	%g0,7,%g5
/* 0x09cc	 767 */		fstoi	%f4,%f9
/* 0x09d0	     */		st	%f9,[%sp+140]
/* 0x09d4	     */		add	%g2,-4,%i0

! Registers live out of .L900001561: 
! g3 g4 g5 o0 o1 o2 sp i0 fp i7 gsr 
! f3 f11 f28 f30 
		                       
! predecessor blocks: .L900001559 .L900001561

			.L900001559:
/* 0x09d8	 767 */		prefetch	[%g4+180],0
/* 0x09dc	     */		prefetch	[%g3+90],2
/* 0x09e0	     */		fstoi	%f30,%f5
/* 0x09e4	 766 */		add	%g5,4,%g5
/* 0x09e8	 767 */		ld	[%g4],%f22
/* 0x09ec	     */		fmuls	%f28,%f3,%f28
/* 0x09f0	     */		st	%f5,[%sp+152]
/* 0x09f4	 766 */		cmp	%g5,%i0
/* 0x09f8	     */		add	%g4,16,%g4
/* 0x09fc	     */		add	%g3,8,%g3
/* 0x0a00	 767 */		ld	[%sp+144],%i5
/* 0x0a04	     */		sth	%o0,[%g3-8]
/* 0x0a08	     */		fstoi	%f28,%f30
/* 0x0a0c	     */		fmuls	%f11,%f3,%f6
/* 0x0a10	     */		ld	[%g4-12],%f24
/* 0x0a14	     */		st	%f30,[%sp+148]
/* 0x0a18	     */		ld	[%sp+140],%l7
/* 0x0a1c	     */		sth	%o1,[%g3-6]
/* 0x0a20	     */		fstoi	%f6,%f11
/* 0x0a24	     */		fmuls	%f22,%f3,%f20
/* 0x0a28	     */		ld	[%g4-8],%f28
/* 0x0a2c	     */		st	%f11,[%sp+144]
/* 0x0a30	     */		ld	[%sp+152],%o0
/* 0x0a34	     */		sth	%i5,[%g3-4]
/* 0x0a38	     */		fstoi	%f20,%f13
/* 0x0a3c	     */		fmuls	%f24,%f3,%f30
/* 0x0a40	     */		ld	[%g4-4],%f11
/* 0x0a44	     */		st	%f13,[%sp+140]
/* 0x0a48	     */		ld	[%sp+148],%o1
/* 0x0a4c	 766 */		ble,pt	%icc,.L900001559
/* 0x0a50	 767 */		sth	%l7,[%g3-2]

! Registers live out of .L900001559: 
! g3 g4 g5 o0 o1 o2 sp i0 fp i7 gsr 
! f3 f11 f28 f30 
		                       
! predecessor blocks: .L900001559

			.L900001562:
/* 0x0a54	 767 */		sth	%o0,[%g3]
/* 0x0a58	     */		ld	[%sp+144],%o4
/* 0x0a5c	     */		sth	%o1,[%g3+2]
/* 0x0a60	     */		ld	[%sp+140],%i1
/* 0x0a64	     */		fmuls	%f11,%f3,%f19
/* 0x0a68	     */		fmuls	%f28,%f3,%f21
/* 0x0a6c	     */		fstoi	%f30,%f26
/* 0x0a70	     */		st	%f26,[%sp+152]
/* 0x0a74	     */		ld	[%sp+152],%i2
/* 0x0a78	 766 */		add	%g3,14,%g3
/* 0x0a7c	 767 */		sth	%o4,[%g3-10]
/* 0x0a80	     */		sth	%i1,[%g3-8]
/* 0x0a84	     */		sth	%i2,[%g3-6]
/* 0x0a88	     */		fstoi	%f19,%f7
/* 0x0a8c	     */		st	%f7,[%sp+144]
/* 0x0a90	     */		ld	[%sp+144],%i3
/* 0x0a94	     */		fstoi	%f21,%f23
/* 0x0a98	     */		st	%f23,[%sp+148]
/* 0x0a9c	     */		ld	[%sp+148],%i4
/* 0x0aa0	     */		sth	%i4,[%g3-4]
/* 0x0aa4	 766 */		cmp	%g5,%o2
/* 0x0aa8	 767 */		sth	%i3,[%g3-2]
/* 0x0aac	 766 */		bg,pn	%icc,.L900001530
/* 0x0ab0	 767 */		nop

! Registers live out of .L900001562: 
! g3 g4 g5 o2 sp fp i7 gsr 
! f3 
		                       
! predecessor blocks: .L77004761 .L900001562

			.L77004762:
/* 0x0ab4	 767 */		ld	[%g4],%f4

! Registers live out of .L77004762: 
! g3 g4 g5 o2 sp fp i7 gsr 
! f3 f4 
		                       
! predecessor blocks: .L77004762 .L900001599

			.L900001599:
/* 0x0ab8	 767 */		fmuls	%f4,%f3,%f23
/* 0x0abc	 766 */		add	%g5,1,%g5
/* 0x0ac0	     */		cmp	%g5,%o2
/* 0x0ac4	     */		add	%g4,4,%g4
/* 0x0ac8	 767 */		fstoi	%f23,%f30
/* 0x0acc	     */		st	%f30,[%sp+220]
/* 0x0ad0	     */		ld	[%sp+220],%l7
/* 0x0ad4	     */		sth	%l7,[%g3]
/* 0x0ad8	 766 */		add	%g3,2,%g3
/* 0x0adc	     */		ble,a,pt	%icc,.L900001599
/* 0x0ae0	 767 */		ld	[%g4],%f4

! Registers live out of .L900001599: 
! g3 g4 g5 o2 sp fp i7 gsr 
! f3 f4 
		                       
! predecessor blocks: .L900001562 .L900001599

			.L900001530:
/* 0x0ae4	 744 */		ret	! Result = 
/* 0x0ae8	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004625

			.L77004868:
/* 0x0aec	 766 */		or	%g0,0,%l6

! Registers live out of .L77004868: 
! g2 o3 sp l6 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004653 .L77004868

			.L77004820:
/* 0x0af0	 766 */		sethi	%hi(0xc000),%g5
/* 0x0af4	     */		add	%g5,640,%g3
/* 0x0af8	 767 */		add	%i0,%g3,%l3
/* 0x0afc	 766 */		ld	[%i3+40],%f17
/* 0x0b00	 767 */		sll	%l6,2,%i0

! Registers live out of .L77004820: 
! g2 o3 sp l6 i0 fp i7 gsr 
! f17 
		                       
! predecessor blocks: .L77004820 .L900001597

			.L900001597:
/* 0x0b04	 767 */		ld	[%l3+%i0],%f5
/* 0x0b08	     */		sll	%l6,1,%l4
/* 0x0b0c	 766 */		add	%l6,1,%l6
/* 0x0b10	 767 */		fmuls	%f5,%f17,%f6
/* 0x0b14	 766 */		cmp	%l6,%g2
/* 0x0b18	 767 */		fstoi	%f6,%f22
/* 0x0b1c	     */		st	%f22,[%sp+220]
/* 0x0b20	     */		ld	[%sp+220],%i5
/* 0x0b24	     */		sth	%i5,[%l4+%o3]
/* 0x0b28	 766 */		bcs,pt	%icc,.L900001597
/* 0x0b2c	 767 */		sll	%l6,2,%i0

! Registers live out of .L900001597: 
! g2 o3 sp l6 i0 fp i7 gsr 
! f17 
		                       
! predecessor blocks: .L900001597

			.L900001529:
/* 0x0b30	 744 */		ret	! Result = 
/* 0x0b34	     */		restore	%g0,0,%g0

!  768		      !	 }
!  769		      !	 break;
!  770		      !      case GL_PIXEL_MAP_R_TO_R:
!  771		      !	 for (i=0;i<ctx->Pixel.MapRtoRsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004565:
/* 0x0b38	 771 */		add	%o1,624,%l3
/* 0x0b3c	     */		ld	[%i0+%l3],%o1
/* 0x0b40	     */		orcc	%g0,%o1,%g0
/* 0x0b44	     */		bleu,pn	%icc,.L77004610
/* 0x0b48	     */		cmp	%o1,2

! Registers live out of .L77004565: 
! o1 o3 sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004565

			.L77004624:
/* 0x0b4c	 771 */		bl,pn	%icc,.L77004870
/* 0x0b50	     */		add	%o7,1022,%o7

! Registers live out of .L77004624: 
! o1 o3 sp o7 i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004624

			.L77004645:
/* 0x0b54	 771 */		sub	%o1,%o7,%o5
/* 0x0b58	     */		srlx	%o5,63,%l2
/* 0x0b5c	     */		andcc	%l2,1,%g0
/* 0x0b60	     */		be,a,pn	%icc,.L77004818
/* 0x0b64	     */		or	%g0,0,%i4

! Registers live out of .L77004645: 
! o1 o3 sp i0 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004645

			.L77004759:
/* 0x0b68	 771 */		sethi	%hi(0xc400),%g5
/* 0x0b6c	     */		add	%g5,640,%g3

!  772		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapRtoR[i] );

/* 0x0b70	 772 */		cmp	%o1,11
/* 0x0b74	 771 */		add	%o1,-1,%g2
/* 0x0b78	     */		add	%i0,%g3,%l5
/* 0x0b7c	     */		or	%g0,0,%l6
/* 0x0b80	     */		or	%g0,%i2,%l0
/* 0x0b84	     */		ld	[%i3+40],%f17
/* 0x0b88	 772 */		bl,pn	%icc,.L77004760
/* 0x0b8c	     */		nop

! Registers live out of .L77004759: 
! g2 o1 sp l0 l5 l6 fp i7 gsr 
! f17 
		                       
! predecessor blocks: .L77004759

			.L900001557:
/* 0x0b90	 772 */		ld	[%l5],%f21
/* 0x0b94	     */		ld	[%l5+20],%f13
/* 0x0b98	     */		ld	[%l5+12],%f18
/* 0x0b9c	     */		ld	[%l5+8],%f23
/* 0x0ba0	     */		ld	[%l5+4],%f19
/* 0x0ba4	     */		ld	[%l5+16],%f7
/* 0x0ba8	     */		fmuls	%f21,%f17,%f27
/* 0x0bac	     */		ld	[%l5+24],%f15
/* 0x0bb0	     */		fmuls	%f19,%f17,%f0
/* 0x0bb4	     */		fmuls	%f23,%f17,%f31
/* 0x0bb8	     */		fmuls	%f18,%f17,%f12
/* 0x0bbc	     */		fmuls	%f7,%f17,%f1
/* 0x0bc0	     */		fstoi	%f27,%f29
/* 0x0bc4	     */		st	%f29,[%sp+168]
/* 0x0bc8	     */		ld	[%sp+168],%l7
/* 0x0bcc	     */		fstoi	%f0,%f25
/* 0x0bd0	     */		st	%f25,[%sp+164]
/* 0x0bd4	     */		fstoi	%f31,%f10
/* 0x0bd8	     */		ld	[%sp+164],%g1
/* 0x0bdc	 771 */		add	%l5,28,%l5
/* 0x0be0	 772 */		st	%f10,[%sp+160]
/* 0x0be4	 771 */		or	%g0,7,%l6
/* 0x0be8	 772 */		fstoi	%f12,%f2
/* 0x0bec	     */		st	%f2,[%sp+156]
/* 0x0bf0	     */		add	%o1,-4,%o5

! Registers live out of .L900001557: 
! g1 g2 o5 sp l0 l5 l6 l7 fp i7 gsr 
! f1 f13 f15 f17 
		                       
! predecessor blocks: .L900001555 .L900001557

			.L900001555:
/* 0x0bf4	 772 */		prefetch	[%l5+180],0
/* 0x0bf8	     */		prefetch	[%l0+90],2
/* 0x0bfc	     */		fstoi	%f1,%f14
/* 0x0c00	 771 */		add	%l6,4,%l6
/* 0x0c04	 772 */		ld	[%l5],%f4
/* 0x0c08	     */		fmuls	%f13,%f17,%f8
/* 0x0c0c	     */		st	%f14,[%sp+168]
/* 0x0c10	 771 */		cmp	%l6,%o5
/* 0x0c14	     */		add	%l5,16,%l5
/* 0x0c18	     */		add	%l0,8,%l0
/* 0x0c1c	 772 */		ld	[%sp+160],%l4
/* 0x0c20	     */		sth	%l7,[%l0-8]
/* 0x0c24	     */		fstoi	%f8,%f9
/* 0x0c28	     */		fmuls	%f15,%f17,%f28
/* 0x0c2c	     */		ld	[%l5-12],%f5
/* 0x0c30	     */		st	%f9,[%sp+164]
/* 0x0c34	     */		ld	[%sp+156],%l3
/* 0x0c38	     */		sth	%g1,[%l0-6]
/* 0x0c3c	     */		fstoi	%f28,%f30
/* 0x0c40	     */		fmuls	%f4,%f17,%f6
/* 0x0c44	     */		ld	[%l5-8],%f13
/* 0x0c48	     */		st	%f30,[%sp+160]
/* 0x0c4c	     */		ld	[%sp+168],%l7
/* 0x0c50	     */		sth	%l4,[%l0-4]
/* 0x0c54	     */		fstoi	%f6,%f22
/* 0x0c58	     */		fmuls	%f5,%f17,%f1
/* 0x0c5c	     */		ld	[%l5-4],%f15
/* 0x0c60	     */		st	%f22,[%sp+156]
/* 0x0c64	     */		ld	[%sp+164],%g1
/* 0x0c68	 771 */		ble,pt	%icc,.L900001555
/* 0x0c6c	 772 */		sth	%l3,[%l0-2]

! Registers live out of .L900001555: 
! g1 g2 o5 sp l0 l5 l6 l7 fp i7 gsr 
! f1 f13 f15 f17 
		                       
! predecessor blocks: .L900001555

			.L900001558:
/* 0x0c70	 772 */		sth	%l7,[%l0]
/* 0x0c74	     */		ld	[%sp+160],%o0
/* 0x0c78	     */		sth	%g1,[%l0+2]
/* 0x0c7c	     */		ld	[%sp+156],%i0
/* 0x0c80	     */		fmuls	%f15,%f17,%f15
/* 0x0c84	     */		fmuls	%f13,%f17,%f16
/* 0x0c88	     */		fstoi	%f1,%f3
/* 0x0c8c	     */		st	%f3,[%sp+168]
/* 0x0c90	     */		ld	[%sp+168],%g5
/* 0x0c94	 771 */		add	%l0,14,%l0
/* 0x0c98	 772 */		sth	%o0,[%l0-10]
/* 0x0c9c	     */		sth	%i0,[%l0-8]
/* 0x0ca0	     */		sth	%g5,[%l0-6]
/* 0x0ca4	     */		fstoi	%f15,%f1
/* 0x0ca8	     */		st	%f1,[%sp+160]
/* 0x0cac	     */		ld	[%sp+160],%g3
/* 0x0cb0	     */		fstoi	%f16,%f26
/* 0x0cb4	     */		st	%f26,[%sp+164]
/* 0x0cb8	     */		ld	[%sp+164],%g4
/* 0x0cbc	     */		sth	%g4,[%l0-4]
/* 0x0cc0	 771 */		cmp	%l6,%g2
/* 0x0cc4	 772 */		sth	%g3,[%l0-2]
/* 0x0cc8	 771 */		bg,pn	%icc,.L900001528
/* 0x0ccc	 772 */		nop

! Registers live out of .L900001558: 
! g2 sp l0 l5 l6 fp i7 gsr 
! f17 
		                       
! predecessor blocks: .L77004759 .L900001558

			.L77004760:
/* 0x0cd0	 772 */		ld	[%l5],%f5

! Registers live out of .L77004760: 
! g2 sp l0 l5 l6 fp i7 gsr 
! f5 f17 
		                       
! predecessor blocks: .L77004760 .L900001596

			.L900001596:
/* 0x0cd4	 772 */		fmuls	%f5,%f17,%f6
/* 0x0cd8	 771 */		add	%l6,1,%l6
/* 0x0cdc	     */		cmp	%l6,%g2
/* 0x0ce0	     */		add	%l5,4,%l5
/* 0x0ce4	 772 */		fstoi	%f6,%f22
/* 0x0ce8	     */		st	%f22,[%sp+220]
/* 0x0cec	     */		ld	[%sp+220],%o0
/* 0x0cf0	     */		sth	%o0,[%l0]
/* 0x0cf4	 771 */		add	%l0,2,%l0
/* 0x0cf8	     */		ble,a,pt	%icc,.L900001596
/* 0x0cfc	 772 */		ld	[%l5],%f5

! Registers live out of .L900001596: 
! g2 sp l0 l5 l6 fp i7 gsr 
! f5 f17 
		                       
! predecessor blocks: .L900001558 .L900001596

			.L900001528:
/* 0x0d00	 744 */		ret	! Result = 
/* 0x0d04	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004624

			.L77004870:
/* 0x0d08	 771 */		or	%g0,0,%i4

! Registers live out of .L77004870: 
! o1 o3 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004645 .L77004870

			.L77004818:
/* 0x0d0c	 771 */		sethi	%hi(0xc400),%l4
/* 0x0d10	     */		add	%l4,640,%l3
/* 0x0d14	 772 */		sll	%i4,2,%l1
/* 0x0d18	 771 */		ld	[%i3+40],%f13
/* 0x0d1c	 772 */		add	%i0,%l3,%o0

! Registers live out of .L77004818: 
! o0 o1 o3 sp l1 i4 fp i7 gsr 
! f13 
		                       
! predecessor blocks: .L77004818 .L900001594

			.L900001594:
/* 0x0d20	 772 */		ld	[%o0+%l1],%f11
/* 0x0d24	     */		sll	%i4,1,%l5
/* 0x0d28	 771 */		add	%i4,1,%i4
/* 0x0d2c	 772 */		fmuls	%f11,%f13,%f20
/* 0x0d30	 771 */		cmp	%i4,%o1
/* 0x0d34	 772 */		fstoi	%f20,%f24
/* 0x0d38	     */		st	%f24,[%sp+220]
/* 0x0d3c	     */		ld	[%sp+220],%o4
/* 0x0d40	     */		sth	%o4,[%l5+%o3]
/* 0x0d44	 771 */		bcs,pt	%icc,.L900001594
/* 0x0d48	 772 */		sll	%i4,2,%l1

! Registers live out of .L900001594: 
! o0 o1 o3 sp l1 i4 fp i7 gsr 
! f13 
		                       
! predecessor blocks: .L900001594

			.L900001527:
/* 0x0d4c	 744 */		ret	! Result = 
/* 0x0d50	     */		restore	%g0,0,%g0

!  773		      !	 }
!  774		      !	 break;
!  775		      !      case GL_PIXEL_MAP_G_TO_G:
!  776		      !	 for (i=0;i<ctx->Pixel.MapGtoGsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004575:
/* 0x0d54	 776 */		add	%o1,628,%l4
/* 0x0d58	     */		ld	[%i0+%l4],%g1
/* 0x0d5c	     */		orcc	%g0,%g1,%g0
/* 0x0d60	     */		bleu,pn	%icc,.L77004610
/* 0x0d64	     */		cmp	%g1,2

! Registers live out of .L77004575: 
! g1 o2 o3 sp o7 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004575

			.L77004623:
/* 0x0d68	 776 */		bl,pn	%icc,.L77004872
/* 0x0d6c	     */		add	%o7,1022,%g5

! Registers live out of .L77004623: 
! g1 g5 o2 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004623

			.L77004637:
/* 0x0d70	 776 */		sub	%g1,%g5,%g3
/* 0x0d74	     */		srlx	%g3,63,%l0
/* 0x0d78	     */		andcc	%l0,1,%g0
/* 0x0d7c	     */		be,a,pn	%icc,.L77004816
/* 0x0d80	     */		or	%g0,0,%o2

! Registers live out of .L77004637: 
! g1 o2 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004637

			.L77004757:
/* 0x0d84	 776 */		sethi	%hi(0xc800),%l3
/* 0x0d88	     */		add	%l3,640,%g4

!  777		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapGtoG[i] );

/* 0x0d8c	 777 */		cmp	%g1,11
/* 0x0d90	 776 */		add	%g1,-1,%o7
/* 0x0d94	     */		add	%i0,%g4,%i2
/* 0x0d98	     */		or	%g0,0,%i1
/* 0x0d9c	     */		or	%g0,%o3,%i4
/* 0x0da0	     */		ld	[%i3+40],%f23
/* 0x0da4	 777 */		bl,pn	%icc,.L77004758
/* 0x0da8	     */		nop

! Registers live out of .L77004757: 
! g1 sp o7 i1 i2 i4 fp i7 gsr 
! f23 
		                       
! predecessor blocks: .L77004757

			.L900001553:
/* 0x0dac	 777 */		ld	[%i2],%f15
/* 0x0db0	     */		ld	[%i2+20],%f19
/* 0x0db4	     */		ld	[%i2+12],%f16
/* 0x0db8	     */		ld	[%i2+8],%f1
/* 0x0dbc	     */		ld	[%i2+4],%f3
/* 0x0dc0	     */		ld	[%i2+16],%f26
/* 0x0dc4	     */		fmuls	%f15,%f23,%f25
/* 0x0dc8	     */		ld	[%i2+24],%f21
/* 0x0dcc	     */		fmuls	%f3,%f23,%f18
/* 0x0dd0	     */		fmuls	%f1,%f23,%f29
/* 0x0dd4	     */		fmuls	%f16,%f23,%f10
/* 0x0dd8	     */		fmuls	%f26,%f23,%f7
/* 0x0ddc	     */		fstoi	%f25,%f27
/* 0x0de0	     */		st	%f27,[%sp+184]
/* 0x0de4	     */		ld	[%sp+184],%o4
/* 0x0de8	     */		fstoi	%f18,%f0
/* 0x0dec	     */		st	%f0,[%sp+180]
/* 0x0df0	     */		fstoi	%f29,%f31
/* 0x0df4	     */		ld	[%sp+180],%o5
/* 0x0df8	 776 */		add	%i2,28,%i2
/* 0x0dfc	 777 */		st	%f31,[%sp+176]
/* 0x0e00	 776 */		or	%g0,7,%i1
/* 0x0e04	 777 */		fstoi	%f10,%f12
/* 0x0e08	     */		st	%f12,[%sp+172]
/* 0x0e0c	     */		add	%g1,-4,%o3

! Registers live out of .L900001553: 
! o3 o4 o5 sp o7 i1 i2 i4 fp i7 gsr 
! f7 f19 f21 f23 
		                       
! predecessor blocks: .L900001551 .L900001553

			.L900001551:
/* 0x0e10	 777 */		prefetch	[%i2+180],0
/* 0x0e14	     */		prefetch	[%i4+90],2
/* 0x0e18	     */		fstoi	%f7,%f7
/* 0x0e1c	 776 */		add	%i1,4,%i1
/* 0x0e20	 777 */		ld	[%i2],%f14
/* 0x0e24	     */		fmuls	%f19,%f23,%f19
/* 0x0e28	     */		st	%f7,[%sp+184]
/* 0x0e2c	 776 */		cmp	%i1,%o3
/* 0x0e30	     */		add	%i2,16,%i2
/* 0x0e34	     */		add	%i4,8,%i4
/* 0x0e38	 777 */		ld	[%sp+176],%o2
/* 0x0e3c	     */		sth	%o4,[%i4-8]
/* 0x0e40	     */		fstoi	%f19,%f2
/* 0x0e44	     */		fmuls	%f21,%f23,%f21
/* 0x0e48	     */		ld	[%i2-12],%f28
/* 0x0e4c	     */		st	%f2,[%sp+180]
/* 0x0e50	     */		ld	[%sp+172],%i3
/* 0x0e54	     */		sth	%o5,[%i4-6]
/* 0x0e58	     */		fstoi	%f21,%f8
/* 0x0e5c	     */		fmuls	%f14,%f23,%f9
/* 0x0e60	     */		ld	[%i2-8],%f19
/* 0x0e64	     */		st	%f8,[%sp+176]
/* 0x0e68	     */		ld	[%sp+184],%o4
/* 0x0e6c	     */		sth	%o2,[%i4-4]
/* 0x0e70	     */		fstoi	%f9,%f4
/* 0x0e74	     */		fmuls	%f28,%f23,%f7
/* 0x0e78	     */		ld	[%i2-4],%f21
/* 0x0e7c	     */		st	%f4,[%sp+172]
/* 0x0e80	     */		ld	[%sp+180],%o5
/* 0x0e84	 776 */		ble,pt	%icc,.L900001551
/* 0x0e88	 777 */		sth	%i3,[%i4-2]

! Registers live out of .L900001551: 
! o3 o4 o5 sp o7 i1 i2 i4 fp i7 gsr 
! f7 f19 f21 f23 
		                       
! predecessor blocks: .L900001551

			.L900001554:
/* 0x0e8c	 777 */		sth	%o4,[%i4]
/* 0x0e90	     */		ld	[%sp+176],%g2
/* 0x0e94	     */		sth	%o5,[%i4+2]
/* 0x0e98	     */		ld	[%sp+172],%l6
/* 0x0e9c	     */		fmuls	%f21,%f23,%f11
/* 0x0ea0	     */		fmuls	%f19,%f23,%f24
/* 0x0ea4	     */		fstoi	%f7,%f17
/* 0x0ea8	     */		st	%f17,[%sp+184]
/* 0x0eac	     */		ld	[%sp+184],%l2
/* 0x0eb0	 776 */		add	%i4,14,%i4
/* 0x0eb4	 777 */		sth	%g2,[%i4-10]
/* 0x0eb8	     */		sth	%l6,[%i4-8]
/* 0x0ebc	     */		sth	%l2,[%i4-6]
/* 0x0ec0	     */		fstoi	%f11,%f20
/* 0x0ec4	     */		st	%f20,[%sp+176]
/* 0x0ec8	     */		ld	[%sp+176],%l5
/* 0x0ecc	     */		fstoi	%f24,%f13
/* 0x0ed0	     */		st	%f13,[%sp+180]
/* 0x0ed4	     */		ld	[%sp+180],%l1
/* 0x0ed8	     */		sth	%l1,[%i4-4]
/* 0x0edc	 776 */		cmp	%i1,%o7
/* 0x0ee0	 777 */		sth	%l5,[%i4-2]
/* 0x0ee4	 776 */		bg,pn	%icc,.L900001526
/* 0x0ee8	 777 */		nop

! Registers live out of .L900001554: 
! sp o7 i1 i2 i4 fp i7 gsr 
! f23 
		                       
! predecessor blocks: .L77004757 .L900001554

			.L77004758:
/* 0x0eec	 777 */		ld	[%i2],%f17

! Registers live out of .L77004758: 
! sp o7 i1 i2 i4 fp i7 gsr 
! f17 f23 
		                       
! predecessor blocks: .L77004758 .L900001593

			.L900001593:
/* 0x0ef0	 777 */		fmuls	%f17,%f23,%f11
/* 0x0ef4	 776 */		add	%i1,1,%i1
/* 0x0ef8	     */		cmp	%i1,%o7
/* 0x0efc	     */		add	%i2,4,%i2
/* 0x0f00	 777 */		fstoi	%f11,%f20
/* 0x0f04	     */		st	%f20,[%sp+220]
/* 0x0f08	     */		ld	[%sp+220],%l4
/* 0x0f0c	     */		sth	%l4,[%i4]
/* 0x0f10	 776 */		add	%i4,2,%i4
/* 0x0f14	     */		ble,a,pt	%icc,.L900001593
/* 0x0f18	 777 */		ld	[%i2],%f17

! Registers live out of .L900001593: 
! sp o7 i1 i2 i4 fp i7 gsr 
! f17 f23 
		                       
! predecessor blocks: .L900001554 .L900001593

			.L900001526:
/* 0x0f1c	 744 */		ret	! Result = 
/* 0x0f20	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004623

			.L77004872:
/* 0x0f24	 776 */		or	%g0,0,%o2

! Registers live out of .L77004872: 
! g1 o2 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004637 .L77004872

			.L77004816:
/* 0x0f28	 776 */		sethi	%hi(0xc800),%g4
/* 0x0f2c	     */		add	%g4,640,%l6
/* 0x0f30	 777 */		sll	%o2,2,%i1
/* 0x0f34	 776 */		ld	[%i3+40],%f1
/* 0x0f38	 777 */		add	%i0,%l6,%i3

! Registers live out of .L77004816: 
! g1 o2 o3 sp i1 i3 fp i7 gsr 
! f1 
		                       
! predecessor blocks: .L77004816 .L900001591

			.L900001591:
/* 0x0f3c	 777 */		ld	[%i3+%i1],%f3
/* 0x0f40	     */		sll	%o2,1,%i2
/* 0x0f44	 776 */		add	%o2,1,%o2
/* 0x0f48	 777 */		fmuls	%f3,%f1,%f15
/* 0x0f4c	 776 */		cmp	%o2,%g1
/* 0x0f50	 777 */		fstoi	%f15,%f16
/* 0x0f54	     */		st	%f16,[%sp+220]
/* 0x0f58	     */		ld	[%sp+220],%g4
/* 0x0f5c	     */		sth	%g4,[%i2+%o3]
/* 0x0f60	 776 */		bcs,pt	%icc,.L900001591
/* 0x0f64	 777 */		sll	%o2,2,%i1

! Registers live out of .L900001591: 
! g1 o2 o3 sp i1 i3 fp i7 gsr 
! f1 
		                       
! predecessor blocks: .L900001591

			.L900001525:
/* 0x0f68	 744 */		ret	! Result = 
/* 0x0f6c	     */		restore	%g0,0,%g0

!  778		      !	 }
!  779		      !	 break;
!  780		      !      case GL_PIXEL_MAP_B_TO_B:
!  781		      !	 for (i=0;i<ctx->Pixel.MapBtoBsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004585:
/* 0x0f70	 781 */		add	%o1,632,%g2
/* 0x0f74	     */		ld	[%i0+%g2],%o1
/* 0x0f78	     */		orcc	%g0,%o1,%g0
/* 0x0f7c	     */		bleu,pn	%icc,.L77004610
/* 0x0f80	     */		cmp	%o1,2

! Registers live out of .L77004585: 
! o1 o3 sp o7 i0 i1 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004585

			.L77004632:
/* 0x0f84	 781 */		bl,pn	%icc,.L77004874
/* 0x0f88	     */		add	%o7,1022,%o2

! Registers live out of .L77004632: 
! o1 o2 o3 sp i0 i1 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004632

			.L77004709:
/* 0x0f8c	 781 */		sub	%o1,%o2,%o7
/* 0x0f90	     */		srlx	%o7,63,%l5
/* 0x0f94	     */		andcc	%l5,1,%g0
/* 0x0f98	     */		be,a,pn	%icc,.L77004814
/* 0x0f9c	     */		or	%g0,0,%i1

! Registers live out of .L77004709: 
! o1 o3 sp i0 i1 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004709

			.L77004755:
/* 0x0fa0	 781 */		sethi	%hi(0xcc00),%g1
/* 0x0fa4	     */		add	%g1,640,%l2

!  782		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapBtoB[i] );

/* 0x0fa8	 782 */		cmp	%o1,11
/* 0x0fac	 781 */		add	%o1,-1,%o2
/* 0x0fb0	     */		add	%i0,%l2,%i5
/* 0x0fb4	     */		or	%g0,0,%o0
/* 0x0fb8	     */		or	%g0,%o3,%g5
/* 0x0fbc	 782 */		or	%g0,%o1,%i2
/* 0x0fc0	 781 */		ld	[%i3+40],%f31
/* 0x0fc4	 782 */		bl,pn	%icc,.L77004756
/* 0x0fc8	     */		nop

! Registers live out of .L77004755: 
! g5 o0 o2 sp i2 i5 fp i7 gsr 
! f31 
		                       
! predecessor blocks: .L77004755

			.L900001549:
/* 0x0fcc	 782 */		ld	[%i5],%f11
/* 0x0fd0	     */		ld	[%i5+20],%f25
/* 0x0fd4	     */		ld	[%i5+12],%f24
/* 0x0fd8	     */		ld	[%i5+8],%f20
/* 0x0fdc	     */		ld	[%i5+4],%f17
/* 0x0fe0	     */		ld	[%i5+16],%f13
/* 0x0fe4	     */		fmuls	%f11,%f31,%f1
/* 0x0fe8	     */		ld	[%i5+24],%f29
/* 0x0fec	     */		fmuls	%f17,%f31,%f3
/* 0x0ff0	     */		fmuls	%f20,%f31,%f26
/* 0x0ff4	     */		fmuls	%f24,%f31,%f0
/* 0x0ff8	     */		fmuls	%f13,%f31,%f27
/* 0x0ffc	     */		fstoi	%f1,%f16
/* 0x1000	     */		st	%f16,[%sp+200]
/* 0x1004	     */		ld	[%sp+200],%i3
/* 0x1008	     */		fstoi	%f3,%f15
/* 0x100c	     */		st	%f15,[%sp+196]
/* 0x1010	     */		fstoi	%f26,%f18
/* 0x1014	     */		ld	[%sp+196],%o1
/* 0x1018	 781 */		add	%i5,28,%i5
/* 0x101c	 782 */		st	%f18,[%sp+192]
/* 0x1020	 781 */		or	%g0,7,%o0
/* 0x1024	 782 */		fstoi	%f0,%f10
/* 0x1028	     */		st	%f10,[%sp+188]
/* 0x102c	     */		add	%i2,-4,%l5

! Registers live out of .L900001549: 
! g5 o0 o1 o2 sp l5 i3 i5 fp i7 gsr 
! f25 f27 f29 f31 
		                       
! predecessor blocks: .L900001547 .L900001549

			.L900001547:
/* 0x1030	 782 */		prefetch	[%i5+180],0
/* 0x1034	     */		prefetch	[%g5+90],2
/* 0x1038	     */		fstoi	%f27,%f27
/* 0x103c	 781 */		add	%o0,4,%o0
/* 0x1040	 782 */		ld	[%i5],%f7
/* 0x1044	     */		fmuls	%f25,%f31,%f25
/* 0x1048	     */		st	%f27,[%sp+200]
/* 0x104c	 781 */		cmp	%o0,%l5
/* 0x1050	     */		add	%i5,16,%i5
/* 0x1054	     */		add	%g5,8,%g5
/* 0x1058	 782 */		ld	[%sp+192],%i4
/* 0x105c	     */		sth	%i3,[%g5-8]
/* 0x1060	     */		fstoi	%f25,%f12
/* 0x1064	     */		fmuls	%f29,%f31,%f29
/* 0x1068	     */		ld	[%i5-12],%f21
/* 0x106c	     */		st	%f12,[%sp+196]
/* 0x1070	     */		ld	[%sp+188],%l7
/* 0x1074	     */		sth	%o1,[%g5-6]
/* 0x1078	     */		fstoi	%f29,%f19
/* 0x107c	     */		fmuls	%f7,%f31,%f2
/* 0x1080	     */		ld	[%i5-8],%f25
/* 0x1084	     */		st	%f19,[%sp+192]
/* 0x1088	     */		ld	[%sp+200],%i3
/* 0x108c	     */		sth	%i4,[%g5-4]
/* 0x1090	     */		fstoi	%f2,%f14
/* 0x1094	     */		fmuls	%f21,%f31,%f27
/* 0x1098	     */		ld	[%i5-4],%f29
/* 0x109c	     */		st	%f14,[%sp+188]
/* 0x10a0	     */		ld	[%sp+196],%o1
/* 0x10a4	 781 */		ble,pt	%icc,.L900001547
/* 0x10a8	 782 */		sth	%l7,[%g5-2]

! Registers live out of .L900001547: 
! g5 o0 o1 o2 sp l5 i3 i5 fp i7 gsr 
! f25 f27 f29 f31 
		                       
! predecessor blocks: .L900001547

			.L900001550:
/* 0x10ac	 782 */		sth	%i3,[%g5]
/* 0x10b0	     */		ld	[%sp+192],%o7
/* 0x10b4	     */		sth	%o1,[%g5+2]
/* 0x10b8	     */		ld	[%sp+188],%o5
/* 0x10bc	     */		fmuls	%f29,%f31,%f30
/* 0x10c0	     */		fmuls	%f25,%f31,%f5
/* 0x10c4	     */		fstoi	%f27,%f23
/* 0x10c8	     */		st	%f23,[%sp+200]
/* 0x10cc	     */		ld	[%sp+200],%o3
/* 0x10d0	 781 */		add	%g5,14,%g5
/* 0x10d4	 782 */		sth	%o7,[%g5-10]
/* 0x10d8	     */		sth	%o5,[%g5-8]
/* 0x10dc	     */		sth	%o3,[%g5-6]
/* 0x10e0	     */		fstoi	%f30,%f6
/* 0x10e4	     */		st	%f6,[%sp+192]
/* 0x10e8	     */		ld	[%sp+192],%i1
/* 0x10ec	     */		fstoi	%f5,%f22
/* 0x10f0	     */		st	%f22,[%sp+196]
/* 0x10f4	     */		ld	[%sp+196],%o4
/* 0x10f8	     */		sth	%o4,[%g5-4]
/* 0x10fc	 781 */		cmp	%o0,%o2
/* 0x1100	 782 */		sth	%i1,[%g5-2]
/* 0x1104	 781 */		bg,pn	%icc,.L900001524
/* 0x1108	 782 */		nop

! Registers live out of .L900001550: 
! g5 o0 o2 sp i5 fp i7 gsr 
! f31 
		                       
! predecessor blocks: .L77004755 .L900001550

			.L77004756:
/* 0x110c	 782 */		ld	[%i5],%f24

! Registers live out of .L77004756: 
! g5 o0 o2 sp i5 fp i7 gsr 
! f24 f31 
		                       
! predecessor blocks: .L77004756 .L900001590

			.L900001590:
/* 0x1110	 782 */		fmuls	%f24,%f31,%f13
/* 0x1114	 781 */		add	%o0,1,%o0
/* 0x1118	     */		cmp	%o0,%o2
/* 0x111c	     */		add	%i5,4,%i5
/* 0x1120	 782 */		fstoi	%f13,%f3
/* 0x1124	     */		st	%f3,[%sp+220]
/* 0x1128	     */		ld	[%sp+220],%l6
/* 0x112c	     */		sth	%l6,[%g5]
/* 0x1130	 781 */		add	%g5,2,%g5
/* 0x1134	     */		ble,a,pt	%icc,.L900001590
/* 0x1138	 782 */		ld	[%i5],%f24

! Registers live out of .L900001590: 
! g5 o0 o2 sp i5 fp i7 gsr 
! f24 f31 
		                       
! predecessor blocks: .L900001550 .L900001590

			.L900001524:
/* 0x113c	 744 */		ret	! Result = 
/* 0x1140	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004632

			.L77004874:
/* 0x1144	 781 */		or	%g0,0,%i1

! Registers live out of .L77004874: 
! o1 o3 sp i0 i1 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004709 .L77004874

			.L77004814:
/* 0x1148	 781 */		sethi	%hi(0xcc00),%g1
/* 0x114c	     */		add	%g1,640,%l2
/* 0x1150	 782 */		sll	%i1,2,%l0
/* 0x1154	 781 */		ld	[%i3+40],%f27
/* 0x1158	 782 */		add	%i0,%l2,%i3

! Registers live out of .L77004814: 
! o1 o3 sp l0 i1 i3 fp i7 gsr 
! f27 
		                       
! predecessor blocks: .L77004814 .L900001588

			.L900001588:
/* 0x115c	 782 */		ld	[%i3+%l0],%f26
/* 0x1160	     */		sll	%i1,1,%o4
/* 0x1164	 781 */		add	%i1,1,%i1
/* 0x1168	 782 */		fmuls	%f26,%f27,%f18
/* 0x116c	 781 */		cmp	%i1,%o1
/* 0x1170	 782 */		fstoi	%f18,%f0
/* 0x1174	     */		st	%f0,[%sp+220]
/* 0x1178	     */		ld	[%sp+220],%o5
/* 0x117c	     */		sth	%o5,[%o4+%o3]
/* 0x1180	 781 */		bcs,pt	%icc,.L900001588
/* 0x1184	 782 */		sll	%i1,2,%l0

! Registers live out of .L900001588: 
! o1 o3 sp l0 i1 i3 fp i7 gsr 
! f27 
		                       
! predecessor blocks: .L900001588

			.L900001523:
/* 0x1188	 744 */		ret	! Result = 
/* 0x118c	     */		restore	%g0,0,%g0

!  783		      !	 }
!  784		      !	 break;
!  785		      !      case GL_PIXEL_MAP_A_TO_A:
!  786		      !	 for (i=0;i<ctx->Pixel.MapAtoAsize;i++) {

                       
! predecessor blocks: .L900001542

			.L77004595:
/* 0x1190	 786 */		add	%o1,636,%i5
/* 0x1194	     */		ld	[%i0+%i5],%g3
/* 0x1198	     */		orcc	%g0,%g3,%g0
/* 0x119c	     */		bleu,pn	%icc,.L77004610
/* 0x11a0	     */		cmp	%g3,2

! Registers live out of .L77004595: 
! g3 o3 sp o7 i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004595

			.L77004631:
/* 0x11a4	 786 */		bl,pn	%icc,.L77004856
/* 0x11a8	     */		add	%o7,1022,%o0

! Registers live out of .L77004631: 
! g3 o0 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004631

			.L77004701:
/* 0x11ac	 786 */		sub	%g3,%o0,%g5
/* 0x11b0	     */		srlx	%g5,63,%i2
/* 0x11b4	     */		andcc	%i2,1,%g0
/* 0x11b8	     */		be,a,pn	%icc,.L77004832
/* 0x11bc	     */		or	%g0,0,%l3

! Registers live out of .L77004701: 
! g3 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004701

			.L77004753:
/* 0x11c0	 786 */		sethi	%hi(0xd000),%g2
/* 0x11c4	     */		add	%g2,640,%l1

!  787		      !	    values[i] = FLOAT_TO_USHORT( ctx->Pixel.MapAtoA[i] );

/* 0x11c8	 787 */		cmp	%g3,11
/* 0x11cc	 786 */		add	%g3,-1,%g4
/* 0x11d0	     */		add	%i0,%l1,%l7
/* 0x11d4	     */		or	%g0,0,%g1
/* 0x11d8	     */		ld	[%i3+40],%f14
/* 0x11dc	 787 */		bl,pn	%icc,.L77004754
/* 0x11e0	     */		nop

! Registers live out of .L77004753: 
! g1 g4 o3 sp l7 fp i7 gsr 
! f14 
		                       
! predecessor blocks: .L77004753

			.L900001545:
/* 0x11e4	 787 */		ld	[%l7],%f30
/* 0x11e8	     */		ld	[%l7+20],%f10
/* 0x11ec	     */		ld	[%l7+12],%f6
/* 0x11f0	     */		ld	[%l7+8],%f5
/* 0x11f4	     */		ld	[%l7+4],%f23
/* 0x11f8	     */		ld	[%l7+16],%f22
/* 0x11fc	     */		fmuls	%f30,%f14,%f20
/* 0x1200	     */		ld	[%l7+24],%f2
/* 0x1204	     */		fmuls	%f23,%f14,%f17
/* 0x1208	     */		fmuls	%f5,%f14,%f13
/* 0x120c	     */		fmuls	%f6,%f14,%f15
/* 0x1210	     */		fmuls	%f22,%f14,%f12
/* 0x1214	     */		fstoi	%f20,%f24
/* 0x1218	     */		st	%f24,[%sp+216]
/* 0x121c	     */		ld	[%sp+216],%g2
/* 0x1220	     */		fstoi	%f17,%f11
/* 0x1224	     */		st	%f11,[%sp+212]
/* 0x1228	     */		fstoi	%f13,%f3
/* 0x122c	     */		ld	[%sp+212],%g3
/* 0x1230	 786 */		add	%l7,28,%l7
/* 0x1234	 787 */		st	%f3,[%sp+208]
/* 0x1238	 786 */		or	%g0,7,%g1
/* 0x123c	 787 */		fstoi	%f15,%f1
/* 0x1240	     */		st	%f1,[%sp+204]
/* 0x1244	     */		sub	%g4,3,%o7

! Registers live out of .L900001545: 
! g1 g2 g3 g4 o3 sp o7 l7 fp i7 gsr 
! f2 f10 f12 f14 
		                       
! predecessor blocks: .L900001543 .L900001545

			.L900001543:
/* 0x1248	 787 */		prefetch	[%l7+180],0
/* 0x124c	     */		prefetch	[%o3+90],2
/* 0x1250	     */		fstoi	%f12,%f16
/* 0x1254	 786 */		add	%g1,4,%g1
/* 0x1258	 787 */		ld	[%l7],%f27
/* 0x125c	     */		fmuls	%f10,%f14,%f26
/* 0x1260	     */		st	%f16,[%sp+216]
/* 0x1264	 786 */		cmp	%g1,%o7
/* 0x1268	     */		add	%l7,16,%l7
/* 0x126c	     */		add	%o3,8,%o3
/* 0x1270	 787 */		ld	[%sp+208],%l4
/* 0x1274	     */		sth	%g2,[%o3-8]
/* 0x1278	     */		fstoi	%f26,%f18
/* 0x127c	     */		fmuls	%f2,%f14,%f0
/* 0x1280	     */		ld	[%l7-12],%f29
/* 0x1284	     */		st	%f18,[%sp+212]
/* 0x1288	     */		ld	[%sp+204],%l3
/* 0x128c	     */		sth	%g3,[%o3-6]
/* 0x1290	     */		fstoi	%f0,%f25
/* 0x1294	     */		fmuls	%f27,%f14,%f12
/* 0x1298	     */		ld	[%l7-8],%f10
/* 0x129c	     */		st	%f25,[%sp+208]
/* 0x12a0	     */		ld	[%sp+216],%g2
/* 0x12a4	     */		sth	%l4,[%o3-4]
/* 0x12a8	     */		fstoi	%f12,%f7
/* 0x12ac	     */		fmuls	%f29,%f14,%f12
/* 0x12b0	     */		ld	[%l7-4],%f2
/* 0x12b4	     */		st	%f7,[%sp+204]
/* 0x12b8	     */		ld	[%sp+212],%g3
/* 0x12bc	 786 */		ble,pt	%icc,.L900001543
/* 0x12c0	 787 */		sth	%l3,[%o3-2]

! Registers live out of .L900001543: 
! g1 g2 g3 g4 o3 sp o7 l7 fp i7 gsr 
! f2 f10 f12 f14 
		                       
! predecessor blocks: .L900001543

			.L900001546:
/* 0x12c4	 787 */		sth	%g2,[%o3]
/* 0x12c8	     */		ld	[%sp+208],%o1
/* 0x12cc	     */		sth	%g3,[%o3+2]
/* 0x12d0	     */		ld	[%sp+204],%i5
/* 0x12d4	     */		fmuls	%f2,%f14,%f8
/* 0x12d8	     */		fmuls	%f10,%f14,%f28
/* 0x12dc	     */		fstoi	%f12,%f31
/* 0x12e0	     */		st	%f31,[%sp+216]
/* 0x12e4	     */		ld	[%sp+216],%o0
/* 0x12e8	 786 */		add	%o3,14,%o3
/* 0x12ec	 787 */		sth	%o1,[%o3-10]
/* 0x12f0	     */		sth	%i5,[%o3-8]
/* 0x12f4	     */		sth	%o0,[%o3-6]
/* 0x12f8	     */		fstoi	%f8,%f9
/* 0x12fc	     */		st	%f9,[%sp+208]
/* 0x1300	     */		ld	[%sp+208],%g5
/* 0x1304	     */		fstoi	%f28,%f4
/* 0x1308	     */		st	%f4,[%sp+212]
/* 0x130c	     */		ld	[%sp+212],%i0
/* 0x1310	     */		sth	%i0,[%o3-4]
/* 0x1314	 786 */		cmp	%g1,%g4
/* 0x1318	 787 */		sth	%g5,[%o3-2]
/* 0x131c	 786 */		bg,pn	%icc,.L900001522
/* 0x1320	 787 */		nop

! Registers live out of .L900001546: 
! g1 g4 o3 sp l7 fp i7 gsr 
! f14 
		                       
! predecessor blocks: .L77004753 .L900001546

			.L77004754:
/* 0x1324	 787 */		ld	[%l7],%f15

! Registers live out of .L77004754: 
! g1 g4 o3 sp l7 fp i7 gsr 
! f14 f15 
		                       
! predecessor blocks: .L77004754 .L900001587

			.L900001587:
/* 0x1328	 787 */		fmuls	%f15,%f14,%f1
/* 0x132c	 786 */		add	%g1,1,%g1
/* 0x1330	     */		cmp	%g1,%g4
/* 0x1334	     */		add	%l7,4,%l7
/* 0x1338	 787 */		fstoi	%f1,%f16
/* 0x133c	     */		st	%f16,[%sp+220]
/* 0x1340	     */		ld	[%sp+220],%i4
/* 0x1344	     */		sth	%i4,[%o3]
/* 0x1348	 786 */		add	%o3,2,%o3
/* 0x134c	     */		ble,a,pt	%icc,.L900001587
/* 0x1350	 787 */		ld	[%l7],%f15

! Registers live out of .L900001587: 
! g1 g4 o3 sp l7 fp i7 gsr 
! f14 f15 
		                       
! predecessor blocks: .L900001546 .L900001587

			.L900001522:
/* 0x1354	 744 */		ret	! Result = 
/* 0x1358	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77004631

			.L77004856:
/* 0x135c	 786 */		or	%g0,0,%l3

! Registers live out of .L77004856: 
! g3 o3 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004701 .L77004856

			.L77004832:
/* 0x1360	 786 */		sethi	%hi(0xd000),%o2
/* 0x1364	     */		add	%o2,640,%o7
/* 0x1368	 787 */		add	%i0,%o7,%l4
/* 0x136c	 786 */		ld	[%i3+40],%f7
/* 0x1370	 787 */		sll	%l3,2,%i0

! Registers live out of .L77004832: 
! g3 o3 sp l4 i0 fp i7 gsr 
! f7 
		                       
! predecessor blocks: .L77004832 .L900001585

			.L900001585:
/* 0x1374	 787 */		ld	[%l4+%i0],%f25
/* 0x1378	     */		sll	%l3,1,%i5
/* 0x137c	 786 */		add	%l3,1,%l3
/* 0x1380	 787 */		fmuls	%f25,%f7,%f12
/* 0x1384	 786 */		cmp	%l3,%g3
/* 0x1388	 787 */		fstoi	%f12,%f29
/* 0x138c	     */		st	%f29,[%sp+220]
/* 0x1390	     */		ld	[%sp+220],%l7
/* 0x1394	     */		sth	%l7,[%i5+%o3]
/* 0x1398	 786 */		bcs,pt	%icc,.L900001585
/* 0x139c	 787 */		sll	%l3,2,%i0

! Registers live out of .L900001585: 
! g3 o3 sp l4 i0 fp i7 gsr 
! f7 
		                       
! predecessor blocks: .L77004505 .L77004515 .L77004525 .L77004535 .L77004545 .L77004555 .L77004565 .L77004575 .L77004585 .L77004595
! predecessor blocks: .L900001585 .L900001609 .L900001612

			.L77004610:
/* 0x13a0	 744 */		ret	! Result = 
/* 0x13a4	     */		restore	%g0,0,%g0

!  788		      !	 }
!  789		      !	 break;
!  790		      !      default:
!  791		      !         gl_error( ctx, GL_INVALID_ENUM, "glGetPixelMapfv" );

                       
! predecessor blocks: .L77004607 .L900001542

			.L77004605:
/* 0x13a8	 791 */		sethi	%hi(.L601),%l7
/* 0x13ac	     */		add	%l7,%lo(.L601),%i2
/* 0x13b0	     */		or	%g0,1280,%i1
/* 0x13b4	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x13b8	     */		restore	%g0,0,%g0
/* 0x13bc	   0 */		.type	gl_GetPixelMapusv,2
/* 0x13bc	   0 */		.size	gl_GetPixelMapusv,(.-gl_GetPixelMapusv)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900001701:
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	(.L77004989-(___const_seg_900001701+0x4))
/* 0x0008	     */		.word	(.L77004997-(___const_seg_900001701+0x4))
/* 0x000c	     */		.word	(.L77005005-(___const_seg_900001701+0x4))
/* 0x0010	     */		.word	(.L77005007-(___const_seg_900001701+0x4))
/* 0x0014	     */		.word	(.L77005009-(___const_seg_900001701+0x4))
/* 0x0018	     */		.word	(.L77005011-(___const_seg_900001701+0x4))
/* 0x001c	     */		.word	(.L77005029-(___const_seg_900001701+0x4))
/* 0x0020	     */		.word	(.L77005029-(___const_seg_900001701+0x4))
/* 0x0024	     */		.word	(.L77005013-(___const_seg_900001701+0x4))
/* 0x0028	     */		.word	(.L77005015-(___const_seg_900001701+0x4))
/* 0x002c	     */		.word	(.L77005017-(___const_seg_900001701+0x4))
/* 0x0030	     */		.word	(.L77005019-(___const_seg_900001701+0x4))
/* 0x0034	     */		.word	(.L77005021-(___const_seg_900001701+0x4))
/* 0x0038	     */		.word	(.L77005023-(___const_seg_900001701+0x4))
/* 0x003c	     */		.word	(.L77005025-(___const_seg_900001701+0x4))
/* 0x0040	     */		.word	(.L77005027-(___const_seg_900001701+0x4))
/* 0x0044	   0 */		.align	8
/* 0x0048	   0 */		.word	1072693248,0
/* 0x0050	   0 */		.type	___const_seg_900001701,1
/* 0x0050	   0 */		.size	___const_seg_900001701,(.-___const_seg_900001701)
/* 0x0050	   0 */		.align	4

!  792		      !   }
!  793		      !}
!  797		      !/**********************************************************************/
!  798		      !/*****                       glPixelTransfer                      *****/
!  799		      !/**********************************************************************/
!  802		      !/*
!  803		      ! * Implements glPixelTransfer[fi] whether called immediately or from a
!  804		      ! * display list.
!  805		      ! */
!  806		      !void gl_PixelTransferf( GLcontext *ctx, GLenum pname, GLfloat param )
!  807		      !{

!
! SUBROUTINE gl_PixelTransferf
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_PixelTransferf
                       

			gl_PixelTransferf:
/* 000000	 807 */		save	%sp,-96,%sp

!  808		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	 808 */		sethi	%hi(0xe000),%l0
/* 0x0008	     */		add	%l0,252,%i3
/* 0x000c	     */		ld	[%i0+%i3],%l6
/* 0x0010	     */		sethi	%hi(0x1800),%i4
/* 0x0014	     */		add	%i4,512,%l7
/* 0x0018	     */		cmp	%l6,%l7
/* 0x001c	     */		be,pn	%icc,.L77005031
/* 0x0020	 807 */		st	%i2,[%fp+76]

! Registers live out of gl_PixelTransferf: 
! sp l0 i0 i1 i2 fp i7 gsr 
! 
		
!  809		      !      gl_error( ctx, GL_INVALID_OPERATION, "glPixelTransfer" );

                       
! predecessor blocks: gl_PixelTransferf

			.L77004985:
/* 0x0024	 809 */		sethi	%hi(.L610),%l0
/* 0x0028	     */		add	%l0,%lo(.L610),%i2
/* 0x002c	     */		or	%g0,1282,%i1
/* 0x0030	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0034	     */		restore	%g0,0,%g0

!  810		      !      return;
!  811		      !   }
!  813		      !   switch (pname) {

                       
! predecessor blocks: gl_PixelTransferf

			.L77005031:
/* 0x0038	 813 */		sub	%i1,3344,%i1
/* 0x003c	     */		cmp	%i1,15
/* 0x0040	     */		bgu,pn	%icc,.L77005029
/* 0x0044	     */		sll	%i1,2,%i5

! Registers live out of .L77005031: 
! sp l0 i0 i2 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005031

			.L900001717:
/* 0x0048	 813 */		sethi	%hi(___const_seg_900001701+4),%i4
/* 0x004c	     */		add	%i4,%lo(___const_seg_900001701+4),%o3
/* 0x0050	   0 */		sethi	%hi(0xac00),%g4
/* 0x0054	 813 */		ld	[%i5+%o3],%i5
/* 0x0058	     */		jmpl	%i5+%o3,%g0
/* 0x005c	     */		nop

! Registers live out of .L900001717: 
! g4 sp l0 i0 i2 fp i7 gsr 
! 
		
!  814		      !      case GL_MAP_COLOR:
!  815		      !         ctx->Pixel.MapColorFlag = param ? GL_TRUE : GL_FALSE;
!  816		      !	 break;
!  817		      !      case GL_MAP_STENCIL:
!  818		      !         ctx->Pixel.MapStencilFlag = param ? GL_TRUE : GL_FALSE;
!  819		      !	 break;
!  820		      !      case GL_INDEX_SHIFT:
!  821		      !         ctx->Pixel.IndexShift = (GLint) param;
!  822		      !	 break;
!  823		      !      case GL_INDEX_OFFSET:
!  824		      !         ctx->Pixel.IndexOffset = (GLint) param;
!  825		      !	 break;
!  826		      !      case GL_RED_SCALE:
!  827		      !         ctx->Pixel.RedScale = param;
!  828		      !	 break;
!  829		      !      case GL_RED_BIAS:
!  830		      !         ctx->Pixel.RedBias = param;
!  831		      !	 break;
!  832		      !      case GL_GREEN_SCALE:
!  833		      !         ctx->Pixel.GreenScale = param;
!  834		      !	 break;
!  835		      !      case GL_GREEN_BIAS:
!  836		      !         ctx->Pixel.GreenBias = param;
!  837		      !	 break;
!  838		      !      case GL_BLUE_SCALE:
!  839		      !         ctx->Pixel.BlueScale = param;
!  840		      !	 break;
!  841		      !      case GL_BLUE_BIAS:
!  842		      !         ctx->Pixel.BlueBias = param;
!  843		      !	 break;
!  844		      !      case GL_ALPHA_SCALE:
!  845		      !         ctx->Pixel.AlphaScale = param;
!  846		      !	 break;
!  847		      !      case GL_ALPHA_BIAS:
!  848		      !         ctx->Pixel.AlphaBias = param;
!  849		      !	 break;
!  850		      !      case GL_DEPTH_SCALE:
!  851		      !         ctx->Pixel.DepthScale = param;
!  852		      !	 break;
!  853		      !      case GL_DEPTH_BIAS:
!  854		      !         ctx->Pixel.DepthBias = param;

                       
! predecessor blocks: .L900001717

			.L77005027:
/* 0x0060	 854 */		add	%g4,572,%o1
/* 0x0064	     */		st	%i2,[%i0+%o1]

!  855		      !	 break;

/* 0x0068	 855 */		ba	.L900001719
/* 0x006c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005027: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77004989:
/* 0x0070	 815 */		sethi	%hi(___const_seg_900001701),%l2
/* 0x0074	     */		ld	[%l2+%lo(___const_seg_900001701)],%f30
/* 0x0078	 819 */		ld	[%fp+76],%f1
/* 0x007c	 815 */		or	%g0,0,%l1
/* 0x0080	     */		add	%g4,588,%o4
/* 0x0084	     */		fcmps	%fcc0,%f1,%f30
/* 0x0088	     */		movne	%fcc0,1,%l1
/* 0x008c	     */		stb	%l1,[%i0+%o4]
/* 0x0090	 816 */		ba	.L900001719
/* 0x0094	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77004989: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77004997:
/* 0x0098	 818 */		sethi	%hi(___const_seg_900001701),%o5
/* 0x009c	     */		ld	[%o5+%lo(___const_seg_900001701)],%f26
/* 0x00a0	 822 */		ld	[%fp+76],%f28
/* 0x00a4	 818 */		or	%g0,0,%l4
/* 0x00a8	     */		add	%g4,589,%l3
/* 0x00ac	     */		fcmps	%fcc0,%f28,%f26
/* 0x00b0	     */		movne	%fcc0,1,%l4
/* 0x00b4	     */		stb	%l4,[%i0+%l3]
/* 0x00b8	 819 */		ba	.L900001719
/* 0x00bc	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77004997: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005005:
/* 0x00c0	 825 */		ld	[%fp+76],%f22
/* 0x00c4	 821 */		add	%g4,580,%o7
/* 0x00c8	     */		fstoi	%f22,%f24
/* 0x00cc	     */		st	%f24,[%i0+%o7]
/* 0x00d0	 822 */		ba	.L900001719
/* 0x00d4	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005005: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005007:
/* 0x00d8	 828 */		ld	[%fp+76],%f18
/* 0x00dc	 824 */		add	%g4,584,%l5
/* 0x00e0	     */		fstoi	%f18,%f20
/* 0x00e4	     */		st	%f20,[%i0+%l5]
/* 0x00e8	 825 */		ba	.L900001719
/* 0x00ec	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005007: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005009:
/* 0x00f0	 827 */		add	%g4,544,%l6
/* 0x00f4	     */		st	%i2,[%i0+%l6]
/* 0x00f8	 828 */		ba	.L900001719
/* 0x00fc	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005009: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005011:
/* 0x0100	 830 */		add	%g4,540,%l7
/* 0x0104	     */		st	%i2,[%i0+%l7]
/* 0x0108	 831 */		ba	.L900001719
/* 0x010c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005011: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005013:
/* 0x0110	 833 */		add	%g4,552,%i3
/* 0x0114	     */		st	%i2,[%i0+%i3]
/* 0x0118	 834 */		ba	.L900001719
/* 0x011c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005013: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005015:
/* 0x0120	 836 */		add	%g4,548,%i5
/* 0x0124	     */		st	%i2,[%i0+%i5]
/* 0x0128	 837 */		ba	.L900001719
/* 0x012c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005015: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005017:
/* 0x0130	 839 */		add	%g4,560,%g1
/* 0x0134	     */		st	%i2,[%i0+%g1]
/* 0x0138	 840 */		ba	.L900001719
/* 0x013c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005017: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005019:
/* 0x0140	 842 */		add	%g4,556,%g2
/* 0x0144	     */		st	%i2,[%i0+%g2]
/* 0x0148	 843 */		ba	.L900001719
/* 0x014c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005019: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005021:
/* 0x0150	 845 */		add	%g4,568,%g3
/* 0x0154	     */		st	%i2,[%i0+%g3]
/* 0x0158	 846 */		ba	.L900001719
/* 0x015c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005021: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005023:
/* 0x0160	 848 */		add	%g4,564,%g5
/* 0x0164	     */		st	%i2,[%i0+%g5]
/* 0x0168	 849 */		ba	.L900001719
/* 0x016c	  95 */		ld	[%i0+2200],%o4

! Registers live out of .L77005023: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001717

			.L77005025:
/* 0x0170	  95 */		ld	[%i0+2200],%o4
/* 0x0174	 851 */		add	%g4,576,%o0
/* 0x0178	     */		st	%i2,[%i0+%o0]

! Registers live out of .L77005025: 
! g4 o4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004989 .L77004997 .L77005005 .L77005007 .L77005009 .L77005011 .L77005013 .L77005015 .L77005017 .L77005019
! predecessor blocks: .L77005021 .L77005023 .L77005025 .L77005027

			.L900001719:
/* 0x017c	  95 */		ldub	[%o4],%l1
/* 0x0180	     */		cmp	%l1,1
/* 0x0184	     */		bne,pn	%icc,.L900001718
/* 0x0188	  99 */		add	%l0,285,%i2

! Registers live out of .L900001719: 
! g4 o4 sp l0 i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001719

			.L77005039:
/* 0x018c	  95 */		ldub	[%o4+20],%l2
/* 0x0190	     */		cmp	%l2,0
/* 0x0194	     */		be,pn	%icc,.L77005075
/* 0x0198	     */		add	%g4,540,%l3

! Registers live out of .L77005039: 
! g4 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005039

			.L77005041:
/* 0x019c	  95 */		ld	[%i0+%l3],%f16
/* 0x01a0	     */		fzero	%f56
/* 0x01a4	     */		fstod	%f16,%f54
/* 0x01a8	     */		fcmpd	%fcc3,%f54,%f56
/* 0x01ac	     */		fbne,pn	%fcc3,.L77005075
/* 0x01b0	     */		add	%g4,544,%o5

! Registers live out of .L77005041: 
! g4 o5 sp l0 i0 fp i7 gsr 
! f24 
		                       
! predecessor blocks: .L77005041

			.L77005043:
/* 0x01b4	  95 */		ld	[%i0+%o5],%f14
/* 0x01b8	   0 */		sethi	%hi(___const_seg_900001701+72),%l4
/* 0x01bc	  95 */		ldd	[%l4+%lo(___const_seg_900001701+72)],%f50
/* 0x01c0	     */		fstod	%f14,%f52
/* 0x01c4	     */		fcmpd	%fcc0,%f52,%f50
/* 0x01c8	     */		fbne,pn	%fcc0,.L77005075
/* 0x01cc	     */		add	%g4,548,%o7

! Registers live out of .L77005043: 
! g4 sp o7 l0 i0 fp i7 gsr 
! f18 f24 
		                       
! predecessor blocks: .L77005043

			.L77005045:
/* 0x01d0	  95 */		ld	[%i0+%o7],%f12
/* 0x01d4	     */		fstod	%f12,%f48
/* 0x01d8	     */		fcmpd	%fcc1,%f48,%f56
/* 0x01dc	     */		fbne,pn	%fcc1,.L77005075
/* 0x01e0	     */		add	%g4,552,%l5

! Registers live out of .L77005045: 
! g4 sp l0 l5 i0 fp i7 gsr 
! f18 f24 
		                       
! predecessor blocks: .L77005045

			.L77005047:
/* 0x01e4	  95 */		ld	[%i0+%l5],%f10
/* 0x01e8	     */		fstod	%f10,%f44
/* 0x01ec	     */		fcmpd	%fcc2,%f44,%f50
/* 0x01f0	     */		fbne,pn	%fcc2,.L77005075
/* 0x01f4	     */		add	%g4,556,%i2

! Registers live out of .L77005047: 
! g4 sp l0 i0 i2 fp i7 gsr 
! f18 f24 
		                       
! predecessor blocks: .L77005047

			.L77005049:
/* 0x01f8	  95 */		ld	[%i0+%i2],%f8
/* 0x01fc	     */		fstod	%f8,%f42
/* 0x0200	     */		fcmpd	%fcc3,%f42,%f56
/* 0x0204	     */		fbne,pn	%fcc3,.L77005075
/* 0x0208	     */		add	%g4,560,%l6

! Registers live out of .L77005049: 
! g4 sp l0 l6 i0 fp i7 gsr 
! f18 f24 
		                       
! predecessor blocks: .L77005049

			.L77005051:
/* 0x020c	  95 */		ld	[%i0+%l6],%f6
/* 0x0210	     */		fstod	%f6,%f40
/* 0x0214	     */		fcmpd	%fcc0,%f40,%f50
/* 0x0218	     */		fbne,pn	%fcc0,.L77005075
/* 0x021c	     */		add	%g4,564,%l7

! Registers live out of .L77005051: 
! g4 sp l0 l7 i0 fp i7 gsr 
! f18 f24 
		                       
! predecessor blocks: .L77005051

			.L77005053:
/* 0x0220	  95 */		ld	[%i0+%l7],%f4
/* 0x0224	     */		fstod	%f4,%f38
/* 0x0228	     */		fcmpd	%fcc1,%f38,%f56
/* 0x022c	     */		fbne,pn	%fcc1,.L77005075
/* 0x0230	     */		add	%g4,568,%i3

! Registers live out of .L77005053: 
! g4 sp l0 i0 i3 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77005053

			.L77005055:
/* 0x0234	  95 */		ld	[%i0+%i3],%f2
/* 0x0238	     */		fstod	%f2,%f36
/* 0x023c	     */		fcmpd	%fcc2,%f36,%f50
/* 0x0240	     */		fbne,pn	%fcc2,.L77005075
/* 0x0244	     */		add	%g4,588,%i5

! Registers live out of .L77005055: 
! g4 sp l0 i0 i5 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77005055

			.L77005057:
/* 0x0248	  95 */		ldub	[%i0+%i5],%i1
/* 0x024c	     */		cmp	%i1,0
/* 0x0250	     */		bne,pn	%icc,.L77005075
/* 0x0254	     */		add	%g4,592,%g1

! Registers live out of .L77005057: 
! g1 g4 sp l0 i0 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77005057

			.L77005059:
/* 0x0258	  95 */		ld	[%i0+%g1],%f0
/* 0x025c	     */		fstod	%f0,%f34
/* 0x0260	     */		fcmpd	%fcc3,%f34,%f50
/* 0x0264	     */		fbne,pn	%fcc3,.L77005075
/* 0x0268	     */		add	%g4,596,%g2

! Registers live out of .L77005059: 
! g2 sp l0 i0 fp i7 gsr 
! f18 
		                       
! predecessor blocks: .L77005059

			.L77005061:
/* 0x026c	  95 */		ld	[%i0+%g2],%f0
/* 0x0270	     */		fstod	%f0,%f32
/* 0x0274	     */		fcmpd	%fcc0,%f32,%f50
/* 0x0278	     */		fbne,pn	%fcc0,.L77005075
/* 0x027c	   0 */		sethi	%hi(0xdc00),%g3

! Registers live out of .L77005061: 
! g3 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005061

			.L77005063:
/* 0x0280	  95 */		add	%g3,460,%g5
/* 0x0284	     */		ld	[%i0+%g5],%g4
/* 0x0288	     */		cmp	%g4,0
/* 0x028c	     */		bne,pn	%icc,.L77005075
/* 0x0290	     */		add	%g3,464,%o1

! Registers live out of .L77005063: 
! g3 o1 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005063

			.L77005065:
/* 0x0294	  95 */		ld	[%i0+%o1],%o0
/* 0x0298	     */		cmp	%o0,0
/* 0x029c	     */		bne,pn	%icc,.L77005075
/* 0x02a0	     */		add	%g3,468,%o3

! Registers live out of .L77005065: 
! g3 o3 sp l0 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005065

			.L77005067:
/* 0x02a4	  95 */		ld	[%i0+%o3],%o2
/* 0x02a8	     */		cmp	%o2,0
/* 0x02ac	     */		bne,pn	%icc,.L77005075
/* 0x02b0	     */		add	%g3,480,%l1

! Registers live out of .L77005067: 
! g3 sp l0 l1 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005067

			.L77005069:
/* 0x02b4	  95 */		ldub	[%i0+%l1],%o4
/* 0x02b8	     */		cmp	%o4,0
/* 0x02bc	     */		bne,pn	%icc,.L77005075
/* 0x02c0	  96 */		add	%g3,481,%l5

! Registers live out of .L77005069: 
! sp l0 l5 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005069

			.L77005071:
/* 0x02c4	  96 */		ldub	[%i0+%l5],%o7
/* 0x02c8	     */		add	%l0,285,%l2
/* 0x02cc	     */		sub	%g0,%o7,%o5
/* 0x02d0	     */		srlx	%o5,63,%l4
/* 0x02d4	     */		xor	%l4,1,%l3
/* 0x02d8	     */		stb	%l3,[%i0+%l2]
/* 0x02dc	 810 */		ret	! Result = 
/* 0x02e0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77005039 .L77005041 .L77005043 .L77005045 .L77005047 .L77005049 .L77005051 .L77005053 .L77005055 .L77005057
! predecessor blocks: .L77005059 .L77005061 .L77005063 .L77005065 .L77005067 .L77005069

			.L77005075:
/* 0x02e4	  99 */		add	%l0,285,%i2

! Registers live out of .L77005075: 
! sp i0 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005075 .L900001719

			.L900001718:
/* 0x02e8	  99 */		stb	%g0,[%i0+%i2]
/* 0x02ec	 810 */		ret	! Result = 
/* 0x02f0	     */		restore	%g0,0,%g0

!  856		      !      default:
!  857		      !         gl_error( ctx, GL_INVALID_ENUM, "glPixelTransfer(pname)" );

                       
! predecessor blocks: .L77005031 .L900001717

			.L77005029:
/* 0x02f4	 857 */		sethi	%hi(.L634),%o2
/* 0x02f8	     */		add	%o2,%lo(.L634),%i2
/* 0x02fc	     */		or	%g0,1280,%i1
/* 0x0300	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0304	     */		restore	%g0,0,%g0
/* 0x0308	   0 */		.type	gl_PixelTransferf,2
/* 0x0308	   0 */		.size	gl_PixelTransferf,(.-gl_PixelTransferf)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  858		      !         return;
!  859		      !   }
!  860		      !   update_drawpixels_state( ctx );
!  861		      !}
!  867		      !/**********************************************************************/
!  868		      !/*****                 Pixel packing/unpacking                    *****/
!  869		      !/**********************************************************************/
!  873		      !/*
!  874		      ! * Unpack a 2-D pixel array/image.  The unpacked format will be con-
!  875		      ! * tiguous (no "empty" bytes) with byte/bit swapping applied as needed.
!  876		      ! * Input:  same as glDrawPixels
!  877		      ! * Output:  pointer to block of pixel data in same format and type as input
!  878		      ! *          or NULL if error.
!  879		      ! */
!  880		      !GLvoid *gl_unpack_pixels( GLcontext *ctx,
!  881		      !                          GLsizei width, GLsizei height,\
!  882		      !                          GLenum format, GLenum type,
!  883		      !                          const GLvoid *pixels )
!  884		      !{

!
! SUBROUTINE gl_unpack_pixels
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_unpack_pixels
                       

			gl_unpack_pixels:
/* 000000	 884 */		save	%sp,-112,%sp
/* 0x0004	     */		st	%i0,[%sp+104]
/* 0x0008	     */		st	%i3,[%sp+108]

!  885		      !   GLint s, n;
!  887		      !   s = gl_sizeof_type( type );

/* 0x000c	 887 */		call	gl_sizeof_type	! params =  %o0	! Result =  %o0
/* 0x0010	     */		or	%g0,%i4,%o0
/* 0x0014	     */		orcc	%g0,%o0,%g0

!  888		      !   if (s<0) {

/* 0x0018	 888 */		bge,pn	%icc,.L77005119

!  889		      !      gl_error( ctx, GL_INVALID_ENUM, "internal error in gl_unpack(type)" );

/* 0x001c	 889 */		or	%g0,1280,%o1

! Registers live out of gl_unpack_pixels: 
! o0 o1 o2 sp i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_unpack_pixels

			.L77005117:
/* 0x0020	 889 */		ld	[%sp+104],%o0
/* 0x0024	     */		sethi	%hi(.L643),%i2
/* 0x0028	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x002c	     */		add	%i2,%lo(.L643),%o2
/* 0x0030	 944 */		ret	! Result =  %i0
/* 0x0034	     */		restore	%g0,0,%o0
                       
! predecessor blocks: gl_unpack_pixels

			.L77005119:
/* 0x0038	 887 */		or	%g0,%o0,%l4

!  890		      !      return NULL;
!  891		      !   }
!  893		      !   n = gl_components_in_format( format );

/* 0x003c	 893 */		call	gl_components_in_format	! params =  %o0	! Result =  %o0
/* 0x0040	     */		ld	[%sp+108],%o0
/* 0x0044	     */		orcc	%g0,%o0,%g0

!  894		      !   if (n<0) {

/* 0x0048	 894 */		bge,pn	%icc,.L77005123

!  895		      !      gl_error( ctx, GL_INVALID_ENUM, "gl_unpack_pixels(format)" );

/* 0x004c	 895 */		or	%g0,1280,%o1

! Registers live out of .L77005119: 
! o0 o1 o2 sp l4 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005119

			.L77005121:
/* 0x0050	 895 */		or	%g0,%i0,%o0
/* 0x0054	     */		sethi	%hi(.L646),%i5
/* 0x0058	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x005c	     */		add	%i5,%lo(.L646),%o2
/* 0x0060	 944 */		ret	! Result =  %i0
/* 0x0064	     */		restore	%g0,0,%o0

!  896		      !      return NULL;
!  897		      !   }
!  899		      !   if (type==GL_BITMAP) {

                       
! predecessor blocks: .L77005119

			.L77005123:
/* 0x0068	 899 */		sethi	%hi(0x1800),%l2
/* 0x006c	     */		add	%l2,512,%o1
/* 0x0070	     */		cmp	%i4,%o1
/* 0x0074	     */		bne,pn	%icc,.L77005159
/* 0x0078	 906 */		mulx	%i1,%i2,%g4

! Registers live out of .L77005123: 
! g4 o0 sp l4 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  900		      !      /* BITMAP data */
!  901		      !      GLint bytes, i, width_in_bytes;
!  902		      !      GLubyte *buffer, *dst;
!  903		      !      GLvoid *src;
!  905		      !      /* Alloc dest storage */
!  906		      !      bytes = CEILING( width * height , 8 );

                       
! predecessor blocks: .L77005123

			.L77005125:
/* 0x007c	 906 */		sra	%g4,31,%g5
/* 0x0080	     */		and	%g5,7,%l0
/* 0x0084	     */		add	%g4,%l0,%i3
/* 0x0088	     */		andn	%i3,7,%l1
/* 0x008c	     */		sub	%g4,%l1,%l6
/* 0x0090	     */		sra	%i3,3,%l4
/* 0x0094	     */		cmp	%l6,0
/* 0x0098	     */		add	%l4,1,%l6
/* 0x009c	     */		move	%icc,%l4,%l6

!  907		      !      buffer = (GLubyte *) malloc( bytes );

/* 0x00a0	 907 */		call	malloc	! params =  %o0	! Result =  %o0
/* 0x00a4	     */		or	%g0,%l6,%o0
/* 0x00a8	     */		orcc	%g0,%o0,%g0

!  908		      !      if (!buffer) {

/* 0x00ac	 908 */		bne,pn	%icc,.L900001872
/* 0x00b0	 913 */		sra	%i1,31,%g3

! Registers live out of .L77005125: 
! g3 o0 sp l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005125

			.L77005133:
/* 0x00b4	 944 */		ret	! Result =  %i0
/* 0x00b8	     */		restore	%g0,0,%o0

!  909		      !	 return NULL;
!  910		      !      }
!  912		      !      /* Copy/unpack pixel data to buffer */
!  913		      !      width_in_bytes = CEILING( width, 8 );

                       
! predecessor blocks: .L77005125

			.L900001872:
/* 0x00bc	 913 */		and	%g3,7,%l3
/* 0x00c0	     */		add	%i1,%l3,%o3
/* 0x00c4	     */		andn	%o3,7,%l5
/* 0x00c8	     */		sub	%i1,%l5,%l7
/* 0x00cc	     */		sra	%o3,3,%o2
/* 0x00d0	     */		cmp	%l7,0
/* 0x00d4	     */		add	%o2,1,%l7
/* 0x00d8	     */		move	%icc,%o2,%l7

!  914		      !      dst = buffer;
!  915		      !      for (i=0;i<height;i++) {

/* 0x00dc	 915 */		cmp	%i2,0
/* 0x00e0	     */		ble,pn	%icc,.L77005153
/* 0x00e4	 907 */		or	%g0,%o0,%i0

! Registers live out of .L900001872: 
! o0 sp l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001872

			.L77005199:
/* 0x00e8	 914 */		sethi	%hi(0xdc00),%i3
/* 0x00ec	     */		add	%i3,456,%l4
/* 0x00f0	     */		ld	[%sp+104],%l5
/* 0x00f4	 915 */		or	%g0,0,%i3

!  916		      !         src = gl_pixel_addr_in_image( &ctx->Unpack, pixels, width, height,
!  917		      !                                       format, type, 0, i, 0 );

/* 0x00f8	 917 */		or	%g0,0,%g3
/* 0x00fc	 914 */		add	%l5,%l4,%l1
/* 0x0100	     */		or	%g0,%o0,%l5

! Registers live out of .L77005199: 
! g3 o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005199 .L900001869

			.L900001868:
/* 0x0104	 917 */		or	%g0,%i4,%o5
/* 0x0108	     */		or	%g0,%i2,%o3
/* 0x010c	     */		or	%g0,%i1,%o2
/* 0x0110	     */		ld	[%sp+108],%o4
/* 0x0114	     */		or	%g0,%i5,%o1
/* 0x0118	     */		stx	%g3,[%sp+96]
/* 0x011c	     */		st	%g0,[%sp+92]
/* 0x0120	     */		call	gl_pixel_addr_in_image	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result =  %o0
/* 0x0124	     */		or	%g0,%l1,%o0
/* 0x0128	     */		orcc	%g0,%o0,%g0

!  918		      !         if (!src) {

/* 0x012c	 918 */		be,pn	%icc,.L77005147
/* 0x0130	 922 */		cmp	%l7,32

! Registers live out of .L900001868: 
! o0 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  919		      !            free(buffer);
!  920		      !            return NULL;
!  921		      !         }
!  922		      !	 MEMCPY( dst, src, width_in_bytes );

                       
! predecessor blocks: .L900001868

			.L77005149:
/* 0x0134	 922 */		or	%g0,%l7,%o2
/* 0x0138	     */		bg	.L900001832
/* 0x013c	     */		or	%g0,%o0,%o1

! Registers live out of .L77005149: 
! o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005149

			.L900001820:
/* 0x0140	 922 */		and	%o0,3,%g3
/* 0x0144	     */		and	%l5,3,%l3
/* 0x0148	     */		orcc	%l3,%g3,%g0
/* 0x014c	     */		be	.L900001825
/* 0x0150	     */		or	%g0,%l5,%g3

! Registers live out of .L900001820: 
! g3 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001820

			.L900001821:
/* 0x0154	 922 */		subcc	%l7,2,%o2
/* 0x0158	     */		bl	.L900001823
/* 0x015c	     */		sub	%o2,-2,%g4

! Registers live out of .L900001821: 
! g3 g4 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001821

			.L900001846:
/* 0x0160	 922 */		srl	%g4,31,%l2
/* 0x0164	     */		add	%g4,%l2,%g5
/* 0x0168	     */		sra	%g5,1,%g4
/* 0x016c	     */		cmp	%g4,1
/* 0x0170	     */		bl	.L900001822
/* 0x0174	     */		nop

! Registers live out of .L900001846: 
! g3 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001846

			.L900001847:
/* 0x0178	 922 */		or	%g0,%o2,%o0
/* 0x017c	     */		or	%g0,%o1,%g5

! Registers live out of .L900001847: 
! g3 g5 o0 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001845 .L900001847

			.L900001845:
/* 0x0180	 922 */		sub	%o0,2,%o0
/* 0x0184	     */		add	%g3,2,%g3
/* 0x0188	     */		ldub	[%g5],%o5
/* 0x018c	     */		cmp	%o0,0
/* 0x0190	     */		add	%g5,2,%g5
/* 0x0194	     */		stb	%o5,[%g3-2]
/* 0x0198	     */		ldub	[%g5-1],%o4
/* 0x019c	     */		bge	.L900001845
/* 0x01a0	     */		stb	%o4,[%g3-1]

! Registers live out of .L900001845: 
! g3 g5 o0 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001845

			.L900001848:
/* 0x01a4	 922 */		or	%g0,%o0,%o2
/* 0x01a8	     */		or	%g0,%g5,%o1
/* 0x01ac	     */		ba	.L900001823
/* 0x01b0	     */		nop

! Registers live out of .L900001848: 
! g3 o0 o1 o2 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001846

			.L900001822:
/* 0x01b4	 922 */		subcc	%o2,2,%o2

! Registers live out of .L900001822: 
! g3 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001822 .L900001871

			.L900001871:
/* 0x01b8	 922 */		ldub	[%o1],%o5
/* 0x01bc	     */		stb	%o5,[%g3]
/* 0x01c0	     */		ldub	[%o1+1],%o4
/* 0x01c4	     */		add	%o1,2,%o1
/* 0x01c8	     */		stb	%o4,[%g3+1]
/* 0x01cc	     */		add	%g3,2,%g3
/* 0x01d0	     */		bge,a	.L900001871
/* 0x01d4	     */		subcc	%o2,2,%o2

! Registers live out of .L900001871: 
! g3 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001821 .L900001848 .L900001871

			.L900001823:
/* 0x01d8	 922 */		cmp	%o2,-1
/* 0x01dc	     */		bl,a	.L900001869
/* 0x01e0	 915 */		add	%i3,1,%i3

! Registers live out of .L900001823: 
! g3 o0 o1 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001823

			.L900001824:
/* 0x01e4	 922 */		ldub	[%o1],%o7
/* 0x01e8	     */		stb	%o7,[%g3]
/* 0x01ec	     */		ba	.L900001869
/* 0x01f0	 915 */		add	%i3,1,%i3

! Registers live out of .L900001824: 
! o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001820

			.L900001825:
/* 0x01f4	 922 */		subcc	%l7,4,%o0
/* 0x01f8	     */		bl	.L900001828
/* 0x01fc	     */		sra	%l7,1,%l3

! Registers live out of .L900001825: 
! g3 o0 o1 o2 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001825

			.L900001850:
/* 0x0200	 922 */		srl	%l3,30,%o3
/* 0x0204	     */		add	%l7,%o3,%l0
/* 0x0208	     */		sra	%l0,2,%o2
/* 0x020c	     */		cmp	%o2,1
/* 0x0210	     */		bl	.L900001826
/* 0x0214	     */		nop

! Registers live out of .L900001850: 
! g3 o0 o1 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001850

			.L900001851:
/* 0x0218	 922 */		or	%g0,%l5,%l2
/* 0x021c	     */		or	%g0,%o1,%o2

! Registers live out of .L900001851: 
! o0 o2 sp o7 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001849 .L900001851

			.L900001849:
/* 0x0220	 922 */		sub	%o0,4,%o0
/* 0x0224	     */		add	%l2,4,%l2
/* 0x0228	     */		ld	[%o2],%f0
/* 0x022c	     */		cmp	%o0,0
/* 0x0230	     */		add	%o2,4,%o2
/* 0x0234	     */		bge	.L900001849
/* 0x0238	     */		st	%f0,[%l2-4]

! Registers live out of .L900001849: 
! o0 o2 sp o7 l1 l2 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001849

			.L900001852:
/* 0x023c	 922 */		or	%g0,%l2,%g3
/* 0x0240	     */		or	%g0,%o2,%o1
/* 0x0244	     */		ba	.L900001827
/* 0x0248	     */		nop

! Registers live out of .L900001852: 
! g3 o0 o1 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001850

			.L900001826:
/* 0x024c	 922 */		subcc	%o0,4,%o0

! Registers live out of .L900001826: 
! g3 o0 o1 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001826 .L900001870

			.L900001870:
/* 0x0250	 922 */		ld	[%o1],%f0
/* 0x0254	     */		add	%o1,4,%o1
/* 0x0258	     */		st	%f0,[%g3]
/* 0x025c	     */		add	%g3,4,%g3
/* 0x0260	     */		bge,a	.L900001870
/* 0x0264	     */		subcc	%o0,4,%o0

! Registers live out of .L900001870: 
! g3 o0 o1 sp o7 l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001852 .L900001870

			.L900001827:
/* 0x0268	 922 */		add	%o0,4,%o2

! Registers live out of .L900001827: 
! g3 o0 o1 o2 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001825 .L900001827

			.L900001828:
/* 0x026c	 922 */		andcc	%l7,3,%g0
/* 0x0270	     */		be	.L900001834
/* 0x0274	     */		subcc	%o2,1,%o2

! Registers live out of .L900001828: 
! g3 o0 o1 o2 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001828

			.L900001829:
/* 0x0278	 922 */		ldub	[%o1],%g1
/* 0x027c	     */		ble	.L900001834
/* 0x0280	     */		stb	%g1,[%g3]

! Registers live out of .L900001829: 
! g3 o0 o1 o2 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001829

			.L900001830:
/* 0x0284	 922 */		ldub	[%o1+1],%g2
/* 0x0288	     */		subcc	%o2,1,%o2
/* 0x028c	     */		ble	.L900001834
/* 0x0290	     */		stb	%g2,[%g3+1]

! Registers live out of .L900001830: 
! g3 o0 o1 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001830

			.L900001831:
/* 0x0294	 922 */		ldub	[%o1+2],%o1
/* 0x0298	     */		stb	%o1,[%g3+2]
/* 0x029c	     */		ba	.L900001869
/* 0x02a0	 915 */		add	%i3,1,%i3

! Registers live out of .L900001831: 
! o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005149

			.L900001832:
/* 0x02a4	 922 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x02a8	     */		or	%g0,%l5,%o0

! Registers live out of .L900001832: 
! o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001828 .L900001829 .L900001830 .L900001832

			.L900001834:
/* 0x02ac	 915 */		add	%i3,1,%i3

! Registers live out of .L900001834: 
! o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001823 .L900001824 .L900001831 .L900001834

			.L900001869:
/* 0x02b0	 915 */		cmp	%i3,%i2

!  923		      !	 dst += width_in_bytes;

/* 0x02b4	 923 */		add	%l5,%l7,%l5
/* 0x02b8	 915 */		bl,pt	%icc,.L900001868
/* 0x02bc	 917 */		sllx	%i3,32,%g3

! Registers live out of .L900001869: 
! g3 o0 sp l1 l5 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001869

			.L900001840:
/* 0x02c0	 915 */		ba	.L900001867
/* 0x02c4	 927 */		sethi	%hi(0xdc00),%o7

! Registers live out of .L900001840: 
! o0 sp o7 l6 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001868

			.L77005147:
/* 0x02c8	 919 */		call	free	! params =  %o0	! Result = 
/* 0x02cc	     */		or	%g0,%i0,%o0
/* 0x02d0	 944 */		ret	! Result =  %i0
/* 0x02d4	     */		restore	%g0,0,%o0

!  924		      !      }
!  926		      !      /* Bit flipping */
!  927		      !      if (ctx->Unpack.LsbFirst) {

                       
! predecessor blocks: .L900001872

			.L77005153:
/* 0x02d8	 927 */		sethi	%hi(0xdc00),%o7

! Registers live out of .L77005153: 
! o0 sp o7 l6 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005153 .L900001840

			.L900001867:
/* 0x02dc	 927 */		ld	[%sp+104],%o1
/* 0x02e0	     */		add	%o7,481,%o5
/* 0x02e4	     */		ldub	[%o1+%o5],%o4
/* 0x02e8	     */		cmp	%o4,0
/* 0x02ec	     */		be,pn	%icc,.L77005192
/* 0x02f0	 928 */		or	%g0,%l6,%o1

! Registers live out of .L900001867: 
! o0 o1 sp i0 fp i7 gsr 
! 
		
!  928		      !	 gl_flip_bytes( buffer, bytes );

                       
! predecessor blocks: .L900001867

			.L77005155:
/* 0x02f4	 928 */		call	gl_flip_bytes	! params =  %o0 %o1	! Result = 
/* 0x02f8	     */		or	%g0,%i0,%o0
/* 0x02fc	 944 */		ret	! Result =  %i0
/* 0x0300	     */		restore	%g0,0,%g0

!  929		      !      }
!  930		      !      return (GLvoid *) buffer;
!  931		      !   }
!  932		      !   else {
!  933		      !      /* Non-BITMAP data */
!  934		      !      GLint width_in_bytes, bytes, i;
!  935		      !      GLubyte *buffer, *dst;
!  936		      !      GLvoid *src;
!  938		      !      width_in_bytes = width * n * s;

                       
! predecessor blocks: .L77005123

			.L77005159:
/* 0x0304	 938 */		mulx	%i1,%o0,%i0
/* 0x0308	     */		mulx	%i0,%l4,%l3

!  940		      !      /* Alloc dest storage */
!  941		      !      bytes = height * width_in_bytes;

/* 0x030c	 941 */		mulx	%i2,%l3,%l2

!  942		      !      buffer = (GLubyte *) malloc( bytes );

/* 0x0310	 942 */		call	malloc	! params =  %o0	! Result =  %o0
/* 0x0314	     */		or	%g0,%l2,%o0
/* 0x0318	     */		orcc	%g0,%o0,%g0

!  943		      !      if (!buffer) {

/* 0x031c	 943 */		bne,pn	%icc,.L900001866
/* 0x0320	 949 */		cmp	%i2,0

! Registers live out of .L77005159: 
! o0 sp l2 l4 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005159

			.L77005161:
/* 0x0324	 944 */		ret	! Result =  %i0
/* 0x0328	     */		restore	%g0,0,%o0

!  944		      !	 return NULL;
!  945		      !      }
!  947		      !      /* Copy/unpack pixel data to buffer */
!  948		      !      dst = buffer;
!  949		      !      for (i=0;i<height;i++) {

                       
! predecessor blocks: .L77005159

			.L900001866:
/* 0x032c	 949 */		ble,pn	%icc,.L77005175
/* 0x0330	 942 */		or	%g0,%o0,%i0

! Registers live out of .L900001866: 
! o0 sp l2 l4 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001866

			.L77005201:
/* 0x0334	 948 */		sethi	%hi(0xdc00),%l1
/* 0x0338	     */		add	%l1,456,%l6
/* 0x033c	     */		ld	[%sp+104],%l7
/* 0x0340	 949 */		or	%g0,0,%l1

!  950		      !         src = gl_pixel_addr_in_image( &ctx->Unpack, pixels, width, height,
!  951		      !                                       format, type, 0, i, 0 );

/* 0x0344	 951 */		or	%g0,0,%o3
/* 0x0348	 948 */		add	%l7,%l6,%i3
/* 0x034c	     */		or	%g0,%o0,%l6

! Registers live out of .L77005201: 
! o0 o3 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005201 .L900001863

			.L900001862:
/* 0x0350	 951 */		or	%g0,%i4,%o5
/* 0x0354	     */		or	%g0,%i1,%o2
/* 0x0358	     */		or	%g0,%i5,%o1
/* 0x035c	     */		stx	%o3,[%sp+96]
/* 0x0360	     */		or	%g0,%i2,%o3
/* 0x0364	     */		ld	[%sp+108],%o4
/* 0x0368	     */		st	%g0,[%sp+92]
/* 0x036c	     */		call	gl_pixel_addr_in_image	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result =  %o0
/* 0x0370	     */		or	%g0,%i3,%o0
/* 0x0374	     */		orcc	%g0,%o0,%g0

!  952		      !         if (!src) {

/* 0x0378	 952 */		be,pn	%icc,.L77005169
/* 0x037c	 956 */		cmp	%l3,32

! Registers live out of .L900001862: 
! o0 o3 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  953		      !            free(buffer);
!  954		      !            return NULL;
!  955		      !         }
!  956		      !	 MEMCPY( dst, src, width_in_bytes );

                       
! predecessor blocks: .L900001862

			.L77005171:
/* 0x0380	 956 */		or	%g0,%l3,%o2
/* 0x0384	     */		bg	.L900001816
/* 0x0388	     */		or	%g0,%o0,%o1

! Registers live out of .L77005171: 
! o0 o1 o2 o3 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005171

			.L900001804:
/* 0x038c	 956 */		and	%o0,3,%l0
/* 0x0390	     */		and	%l6,3,%g4
/* 0x0394	     */		orcc	%g4,%l0,%g0
/* 0x0398	     */		be	.L900001809
/* 0x039c	     */		or	%g0,%l6,%l0

! Registers live out of .L900001804: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001804

			.L900001805:
/* 0x03a0	 956 */		subcc	%l3,2,%o2
/* 0x03a4	     */		bl	.L900001807
/* 0x03a8	     */		sub	%o2,-2,%o4

! Registers live out of .L900001805: 
! o0 o1 o2 o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001805

			.L900001854:
/* 0x03ac	 956 */		srl	%o4,31,%o7
/* 0x03b0	     */		add	%o4,%o7,%o5
/* 0x03b4	     */		sra	%o5,1,%o4
/* 0x03b8	     */		cmp	%o4,1
/* 0x03bc	     */		bl	.L900001806
/* 0x03c0	     */		nop

! Registers live out of .L900001854: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001854

			.L900001855:
/* 0x03c4	 956 */		or	%g0,%o2,%o7
/* 0x03c8	     */		or	%g0,%o0,%o5

! Registers live out of .L900001855: 
! o3 o5 sp o7 l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001853 .L900001855

			.L900001853:
/* 0x03cc	 956 */		sub	%o7,2,%o7
/* 0x03d0	     */		add	%l0,2,%l0
/* 0x03d4	     */		ldub	[%o5],%o0
/* 0x03d8	     */		cmp	%o7,0
/* 0x03dc	     */		add	%o5,2,%o5
/* 0x03e0	     */		stb	%o0,[%l0-2]
/* 0x03e4	     */		ldub	[%o5-1],%g5
/* 0x03e8	     */		bge	.L900001853
/* 0x03ec	     */		stb	%g5,[%l0-1]

! Registers live out of .L900001853: 
! o0 o3 o5 sp o7 l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001853

			.L900001856:
/* 0x03f0	 956 */		or	%g0,%o7,%o2
/* 0x03f4	     */		or	%g0,%o5,%o1
/* 0x03f8	     */		ba	.L900001807
/* 0x03fc	     */		nop

! Registers live out of .L900001856: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001854

			.L900001806:
/* 0x0400	 956 */		subcc	%o2,2,%o2

! Registers live out of .L900001806: 
! o1 o2 o3 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001806 .L900001865

			.L900001865:
/* 0x0404	 956 */		ldub	[%o1],%o0
/* 0x0408	     */		stb	%o0,[%l0]
/* 0x040c	     */		ldub	[%o1+1],%g5
/* 0x0410	     */		add	%o1,2,%o1
/* 0x0414	     */		stb	%g5,[%l0+1]
/* 0x0418	     */		add	%l0,2,%l0
/* 0x041c	     */		bge,a	.L900001865
/* 0x0420	     */		subcc	%o2,2,%o2

! Registers live out of .L900001865: 
! o0 o1 o2 o3 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001805 .L900001856 .L900001865

			.L900001807:
/* 0x0424	 956 */		cmp	%o2,-1
/* 0x0428	     */		bl,a	.L900001863
/* 0x042c	 949 */		add	%l1,1,%l1

! Registers live out of .L900001807: 
! o0 o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001807

			.L900001808:
/* 0x0430	 956 */		ldub	[%o1],%o2
/* 0x0434	     */		stb	%o2,[%l0]
/* 0x0438	     */		ba	.L900001863
/* 0x043c	 949 */		add	%l1,1,%l1

! Registers live out of .L900001808: 
! o0 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001804

			.L900001809:
/* 0x0440	 956 */		subcc	%l3,4,%o4
/* 0x0444	     */		bl	.L900001812
/* 0x0448	     */		sra	%l3,1,%g5

! Registers live out of .L900001809: 
! g5 o0 o1 o2 o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001809

			.L900001858:
/* 0x044c	 956 */		srl	%g5,30,%g4
/* 0x0450	     */		add	%l3,%g4,%l7
/* 0x0454	     */		sra	%l7,2,%g2
/* 0x0458	     */		cmp	%g2,1
/* 0x045c	     */		bl	.L900001810
/* 0x0460	     */		nop

! Registers live out of .L900001858: 
! o0 o1 o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001858

			.L900001859:
/* 0x0464	 956 */		or	%g0,%l6,%o3
/* 0x0468	     */		or	%g0,%o0,%o5

! Registers live out of .L900001859: 
! o0 o3 o4 o5 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001857 .L900001859

			.L900001857:
/* 0x046c	 956 */		sub	%o4,4,%o4
/* 0x0470	     */		add	%o3,4,%o3
/* 0x0474	     */		ld	[%o5],%f0
/* 0x0478	     */		cmp	%o4,0
/* 0x047c	     */		add	%o5,4,%o5
/* 0x0480	     */		bge	.L900001857
/* 0x0484	     */		st	%f0,[%o3-4]

! Registers live out of .L900001857: 
! o0 o3 o4 o5 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001857

			.L900001860:
/* 0x0488	 956 */		or	%g0,%o3,%l0
/* 0x048c	     */		or	%g0,%o5,%o1
/* 0x0490	     */		ba	.L900001811
/* 0x0494	     */		nop

! Registers live out of .L900001860: 
! o0 o1 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001858

			.L900001810:
/* 0x0498	 956 */		subcc	%o4,4,%o4

! Registers live out of .L900001810: 
! o0 o1 o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001810 .L900001864

			.L900001864:
/* 0x049c	 956 */		ld	[%o1],%f0
/* 0x04a0	     */		add	%o1,4,%o1
/* 0x04a4	     */		st	%f0,[%l0]
/* 0x04a8	     */		add	%l0,4,%l0
/* 0x04ac	     */		bge,a	.L900001864
/* 0x04b0	     */		subcc	%o4,4,%o4

! Registers live out of .L900001864: 
! o0 o1 o3 o4 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001860 .L900001864

			.L900001811:
/* 0x04b4	 956 */		add	%o4,4,%o2

! Registers live out of .L900001811: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001809 .L900001811

			.L900001812:
/* 0x04b8	 956 */		andcc	%l3,3,%g0
/* 0x04bc	     */		be	.L900001818
/* 0x04c0	     */		subcc	%o2,1,%o2

! Registers live out of .L900001812: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001812

			.L900001813:
/* 0x04c4	 956 */		ldub	[%o1],%o3
/* 0x04c8	     */		ble	.L900001818
/* 0x04cc	     */		stb	%o3,[%l0]

! Registers live out of .L900001813: 
! o0 o1 o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001813

			.L900001814:
/* 0x04d0	 956 */		ldub	[%o1+1],%l7
/* 0x04d4	     */		subcc	%o2,1,%o2
/* 0x04d8	     */		ble	.L900001818
/* 0x04dc	     */		stb	%l7,[%l0+1]

! Registers live out of .L900001814: 
! o0 o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001814

			.L900001815:
/* 0x04e0	 956 */		ldub	[%o1+2],%l5
/* 0x04e4	     */		stb	%l5,[%l0+2]
/* 0x04e8	     */		ba	.L900001863
/* 0x04ec	 949 */		add	%l1,1,%l1

! Registers live out of .L900001815: 
! o0 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005171

			.L900001816:
/* 0x04f0	 956 */		call	memcpy	! params =  %o0 %o1 %o2	! Result =  %o0
/* 0x04f4	     */		or	%g0,%l6,%o0

! Registers live out of .L900001816: 
! o0 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001812 .L900001813 .L900001814 .L900001816

			.L900001818:
/* 0x04f8	 949 */		add	%l1,1,%l1

! Registers live out of .L900001818: 
! o0 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001807 .L900001808 .L900001815 .L900001818

			.L900001863:
/* 0x04fc	 949 */		cmp	%l1,%i2

!  957		      !	 dst += width_in_bytes;

/* 0x0500	 957 */		add	%l6,%l3,%l6
/* 0x0504	 949 */		bl,pt	%icc,.L900001862
/* 0x0508	 951 */		sllx	%l1,32,%o3

! Registers live out of .L900001863: 
! o0 o3 sp l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001863

			.L900001839:
/* 0x050c	 949 */		ba	.L900001861
/* 0x0510	 961 */		sethi	%hi(0xdc00),%o1

! Registers live out of .L900001839: 
! o1 sp l2 l4 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001862

			.L77005169:
/* 0x0514	 953 */		call	free	! params =  %o0	! Result = 
/* 0x0518	     */		or	%g0,%i0,%o0
/* 0x051c	 944 */		ret	! Result =  %i0
/* 0x0520	     */		restore	%g0,0,%o0

!  958		      !      }
!  960		      !      /* Byte swapping */
!  961		      !      if (ctx->Unpack.SwapBytes && s>1) {

                       
! predecessor blocks: .L900001866

			.L77005175:
/* 0x0524	 961 */		sethi	%hi(0xdc00),%o1

! Registers live out of .L77005175: 
! o1 sp l2 l4 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005175 .L900001839

			.L900001861:
/* 0x0528	 961 */		ld	[%sp+104],%l0
/* 0x052c	     */		add	%o1,480,%g2
/* 0x0530	     */		ldub	[%l0+%g2],%g1
/* 0x0534	     */		cmp	%g1,0
/* 0x0538	     */		be,pn	%icc,.L77005192
/* 0x053c	     */		cmp	%l4,1

! Registers live out of .L900001861: 
! o1 sp l2 l4 i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900001861

			.L77005177:
/* 0x0540	 961 */		ble,pn	%icc,.L77005192
/* 0x0544	 962 */		cmp	%l4,2

! Registers live out of .L77005177: 
! o1 sp l2 l4 i0 fp i7 gsr 
! 
		
!  962		      !	 if (s==2) {

                       
! predecessor blocks: .L77005177

			.L77005179:
/* 0x0548	 962 */		bne,pn	%icc,.L77005183
/* 0x054c	 963 */		srl	%l2,31,%i4

! Registers live out of .L77005179: 
! o1 sp l2 l4 i0 i4 fp i7 gsr 
! 
		
!  963		      !	    gl_swap2( (GLushort *) buffer, bytes/2 );

                       
! predecessor blocks: .L77005179

			.L77005181:
/* 0x0550	 963 */		or	%g0,%i0,%o0
/* 0x0554	     */		add	%l2,%i4,%l2
/* 0x0558	     */		call	gl_swap2	! params =  %o0 %o1	! Result = 
/* 0x055c	     */		sra	%l2,1,%o1
/* 0x0560	 944 */		ret	! Result =  %i0
/* 0x0564	     */		restore	%g0,0,%g0

!  964		      !	 }
!  965		      !	 else if (s==4) {

                       
! predecessor blocks: .L77005179

			.L77005183:
/* 0x0568	 965 */		cmp	%l4,4
/* 0x056c	     */		bne,pn	%icc,.L77005192
/* 0x0570	 966 */		sra	%l2,31,%i5

! Registers live out of .L77005183: 
! o1 sp l2 i0 i5 fp i7 gsr 
! 
		
!  966		      !	    gl_swap4( (GLuint *) buffer, bytes/4 );

                       
! predecessor blocks: .L77005183

			.L77005185:
/* 0x0574	 966 */		and	%i5,3,%i2
/* 0x0578	     */		or	%g0,%i0,%o0
/* 0x057c	     */		add	%l2,%i2,%i1
/* 0x0580	     */		call	gl_swap4	! params =  %o0 %o1	! Result = 
/* 0x0584	     */		sra	%i1,2,%o1
/* 0x0588	 944 */		ret	! Result =  %i0
/* 0x058c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L77005177 .L77005183 .L900001861 .L900001867

			.L77005192:
/* 0x0590	 944 */		ret	! Result =  %i0
/* 0x0594	     */		restore	%g0,0,%g0
/* 0x0598	   0 */		.type	gl_unpack_pixels,2
/* 0x0598	   0 */		.size	gl_unpack_pixels,(.-gl_unpack_pixels)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	354
/* 0x000c	   0 */		.word	1120
/* 0x0010	   0 */		.word	114
/* 0x0014	   0 */		.word	670
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	115
/* 0x0024	   0 */		.word	16414
/* 0x0028	   0 */		.word	1
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.align	4
/* 0x0030	   0 */		.word	-1
/* 0x0034	   0 */		.word	-1
/* 0x0038	   0 */		.word	120
/* 0x003c	   0 */		.word	16409
/* 0x0040	   0 */		.word	3
/* 0x0044	   0 */		.word	1
/* 0x0048	   0 */		.align	4
/* 0x0048	   0 */		.word	-1
/* 0x004c	   0 */		.word	-1
/* 0x0050	   0 */		.word	115
/* 0x0054	   0 */		.word	131075
/* 0x0058	   0 */		.word	1
/* 0x005c	   0 */		.word	4
/* 0x0060	   0 */		.align	4
/* 0x0060	   0 */		.word	-1
/* 0x0064	   0 */		.word	-1
/* 0x0068	   0 */		.word	227
/* 0x006c	   0 */		.word	16414
/* 0x0070	   0 */		.word	1
/* 0x0074	   0 */		.word	5
/* 0x0078	   0 */		.align	4
/* 0x0078	   0 */		.word	-1
/* 0x007c	   0 */		.word	-1
/* 0x0080	   0 */		.word	202
/* 0x0084	   0 */		.word	65571
/* 0x0088	   0 */		.word	1
/* 0x008c	   0 */		.word	6
/* 0x0090	   0 */		.align	4
/* 0x0090	   0 */		.word	-1
/* 0x0094	   0 */		.word	-1
/* 0x0098	   0 */		.word	213
/* 0x009c	   0 */		.word	65571
/* 0x00a0	   0 */		.word	1
/* 0x00a4	   0 */		.word	7
/* 0x00a8	   0 */		.align	4
/* 0x00a8	   0 */		.word	-1
/* 0x00ac	   0 */		.word	-1
/* 0x00b0	   0 */		.word	225
/* 0x00b4	   0 */		.word	65571
/* 0x00b8	   0 */		.word	1
/* 0x00bc	   0 */		.word	8
/* 0x00c0	   0 */		.align	4
/* 0x00c0	   0 */		.word	-1
/* 0x00c4	   0 */		.word	-1
/* 0x00c8	   0 */		.word	202
/* 0x00cc	   0 */		.word	4148
/* 0x00d0	   0 */		.word	3
/* 0x00d4	   0 */		.word	9
/* 0x00d8	   0 */		.align	4
/* 0x00d8	   0 */		.word	-1
/* 0x00dc	   0 */		.word	-1
/* 0x00e0	   0 */		.word	202
/* 0x00e4	   0 */		.word	8218
/* 0x00e8	   0 */		.word	2
/* 0x00ec	   0 */		.word	12
/* 0x00f0	   0 */		.align	4
/* 0x00f0	   0 */		.word	-1
/* 0x00f4	   0 */		.word	-1
/* 0x00f8	   0 */		.word	202
/* 0x00fc	   0 */		.word	4122
/* 0x0100	   0 */		.word	2
/* 0x0104	   0 */		.word	14
/* 0x0108	   0 */		.align	4
/* 0x0108	   0 */		.word	-1
/* 0x010c	   0 */		.word	-1
/* 0x0110	   0 */		.word	202
/* 0x0114	   0 */		.word	4123
/* 0x0118	   0 */		.word	7
/* 0x011c	   0 */		.word	16
/* 0x0120	   0 */		.align	4
/* 0x0120	   0 */		.word	-1
/* 0x0124	   0 */		.word	-1
/* 0x0128	   0 */		.word	202
/* 0x012c	   0 */		.word	4145
/* 0x0130	   0 */		.word	7
/* 0x0134	   0 */		.word	23
/* 0x0138	   0 */		.align	4
/* 0x0138	   0 */		.word	-1
/* 0x013c	   0 */		.word	-1
/* 0x0140	   0 */		.word	225
/* 0x0144	   0 */		.word	8219
/* 0x0148	   0 */		.word	1
/* 0x014c	   0 */		.word	30
/* 0x0150	   0 */		.align	4
/* 0x0150	   0 */		.word	-1
/* 0x0154	   0 */		.word	-1
/* 0x0158	   0 */		.word	202
/* 0x015c	   0 */		.word	8218
/* 0x0160	   0 */		.word	2
/* 0x0164	   0 */		.word	31
/* 0x0168	   0 */		.align	4
/* 0x0168	   0 */		.word	-1
/* 0x016c	   0 */		.word	-1
/* 0x0170	   0 */		.word	202
/* 0x0174	   0 */		.word	4122
/* 0x0178	   0 */		.word	2
/* 0x017c	   0 */		.word	33
/* 0x0180	   0 */		.align	4
/* 0x0180	   0 */		.word	-1
/* 0x0184	   0 */		.word	-1
/* 0x0188	   0 */		.word	202
/* 0x018c	   0 */		.word	4123
/* 0x0190	   0 */		.word	7
/* 0x0194	   0 */		.word	35
/* 0x0198	   0 */		.align	4
/* 0x0198	   0 */		.word	-1
/* 0x019c	   0 */		.word	-1
/* 0x01a0	   0 */		.word	202
/* 0x01a4	   0 */		.word	4145
/* 0x01a8	   0 */		.word	7
/* 0x01ac	   0 */		.word	42
/* 0x01b0	   0 */		.align	4
/* 0x01b0	   0 */		.word	-1
/* 0x01b4	   0 */		.word	-1
/* 0x01b8	   0 */		.word	213
/* 0x01bc	   0 */		.word	8218
/* 0x01c0	   0 */		.word	2
/* 0x01c4	   0 */		.word	49
/* 0x01c8	   0 */		.align	4
/* 0x01c8	   0 */		.word	-1
/* 0x01cc	   0 */		.word	-1
/* 0x01d0	   0 */		.word	213
/* 0x01d4	   0 */		.word	4122
/* 0x01d8	   0 */		.word	2
/* 0x01dc	   0 */		.word	51
/* 0x01e0	   0 */		.align	4
/* 0x01e0	   0 */		.word	-1
/* 0x01e4	   0 */		.word	-1
/* 0x01e8	   0 */		.word	213
/* 0x01ec	   0 */		.word	4123
/* 0x01f0	   0 */		.word	7
/* 0x01f4	   0 */		.word	53
/* 0x01f8	   0 */		.align	4
/* 0x01f8	   0 */		.word	-1
/* 0x01fc	   0 */		.word	-1
/* 0x0200	   0 */		.word	213
/* 0x0204	   0 */		.word	4145
/* 0x0208	   0 */		.word	7
/* 0x020c	   0 */		.word	60
/* 0x0210	   0 */		.align	4
/* 0x0210	   0 */		.word	-1
/* 0x0214	   0 */		.word	-1
/* 0x0218	   0 */		.word	318
/* 0x021c	   0 */		.word	16414
/* 0x0220	   0 */		.word	1
/* 0x0224	   0 */		.word	67
/* 0x0228	   0 */		.align	4
/* 0x0228	   0 */		.word	-1
/* 0x022c	   0 */		.word	-1
/* 0x0230	   0 */		.word	300
/* 0x0234	   0 */		.word	65571
/* 0x0238	   0 */		.word	1
/* 0x023c	   0 */		.word	68
/* 0x0240	   0 */		.align	4
/* 0x0240	   0 */		.word	-1
/* 0x0244	   0 */		.word	-1
/* 0x0248	   0 */		.word	308
/* 0x024c	   0 */		.word	65571
/* 0x0250	   0 */		.word	1
/* 0x0254	   0 */		.word	69
/* 0x0258	   0 */		.align	4
/* 0x0258	   0 */		.word	-1
/* 0x025c	   0 */		.word	-1
/* 0x0260	   0 */		.word	317
/* 0x0264	   0 */		.word	65571
/* 0x0268	   0 */		.word	1
/* 0x026c	   0 */		.word	70
/* 0x0270	   0 */		.align	4
/* 0x0270	   0 */		.word	-1
/* 0x0274	   0 */		.word	-1
/* 0x0278	   0 */		.word	300
/* 0x027c	   0 */		.word	4148
/* 0x0280	   0 */		.word	3
/* 0x0284	   0 */		.word	71
/* 0x0288	   0 */		.align	4
/* 0x0288	   0 */		.word	-1
/* 0x028c	   0 */		.word	-1
/* 0x0290	   0 */		.word	300
/* 0x0294	   0 */		.word	8218
/* 0x0298	   0 */		.word	2
/* 0x029c	   0 */		.word	74
/* 0x02a0	   0 */		.align	4
/* 0x02a0	   0 */		.word	-1
/* 0x02a4	   0 */		.word	-1
/* 0x02a8	   0 */		.word	300
/* 0x02ac	   0 */		.word	4122
/* 0x02b0	   0 */		.word	2
/* 0x02b4	   0 */		.word	76
/* 0x02b8	   0 */		.align	4
/* 0x02b8	   0 */		.word	-1
/* 0x02bc	   0 */		.word	-1
/* 0x02c0	   0 */		.word	300
/* 0x02c4	   0 */		.word	4123
/* 0x02c8	   0 */		.word	7
/* 0x02cc	   0 */		.word	78
/* 0x02d0	   0 */		.align	4
/* 0x02d0	   0 */		.word	-1
/* 0x02d4	   0 */		.word	-1
/* 0x02d8	   0 */		.word	300
/* 0x02dc	   0 */		.word	4145
/* 0x02e0	   0 */		.word	7
/* 0x02e4	   0 */		.word	85
/* 0x02e8	   0 */		.align	4
/* 0x02e8	   0 */		.word	-1
/* 0x02ec	   0 */		.word	-1
/* 0x02f0	   0 */		.word	317
/* 0x02f4	   0 */		.word	8219
/* 0x02f8	   0 */		.word	1
/* 0x02fc	   0 */		.word	92
/* 0x0300	   0 */		.align	4
/* 0x0300	   0 */		.word	-1
/* 0x0304	   0 */		.word	-1
/* 0x0308	   0 */		.word	308
/* 0x030c	   0 */		.word	8218
/* 0x0310	   0 */		.word	2
/* 0x0314	   0 */		.word	93
/* 0x0318	   0 */		.align	4
/* 0x0318	   0 */		.word	-1
/* 0x031c	   0 */		.word	-1
/* 0x0320	   0 */		.word	308
/* 0x0324	   0 */		.word	4122
/* 0x0328	   0 */		.word	2
/* 0x032c	   0 */		.word	95
/* 0x0330	   0 */		.align	4
/* 0x0330	   0 */		.word	-1
/* 0x0334	   0 */		.word	-1
/* 0x0338	   0 */		.word	308
/* 0x033c	   0 */		.word	4123
/* 0x0340	   0 */		.word	7
/* 0x0344	   0 */		.word	97
/* 0x0348	   0 */		.align	4
/* 0x0348	   0 */		.word	-1
/* 0x034c	   0 */		.word	-1
/* 0x0350	   0 */		.word	308
/* 0x0354	   0 */		.word	4145
/* 0x0358	   0 */		.word	7
/* 0x035c	   0 */		.word	104
/* 0x0360	   0 */		.align	4
/* 0x0360	   0 */		.word	-1
/* 0x0364	   0 */		.word	-1
/* 0x0368	   0 */		.word	300
/* 0x036c	   0 */		.word	8218
/* 0x0370	   0 */		.word	2
/* 0x0374	   0 */		.word	111
/* 0x0378	   0 */		.align	4
/* 0x0378	   0 */		.word	-1
/* 0x037c	   0 */		.word	-1
/* 0x0380	   0 */		.word	300
/* 0x0384	   0 */		.word	4122
/* 0x0388	   0 */		.word	2
/* 0x038c	   0 */		.word	113
/* 0x0390	   0 */		.align	4
/* 0x0390	   0 */		.word	-1
/* 0x0394	   0 */		.word	-1
/* 0x0398	   0 */		.word	300
/* 0x039c	   0 */		.word	4123
/* 0x03a0	   0 */		.word	7
/* 0x03a4	   0 */		.word	115
/* 0x03a8	   0 */		.align	4
/* 0x03a8	   0 */		.word	-1
/* 0x03ac	   0 */		.word	-1
/* 0x03b0	   0 */		.word	300
/* 0x03b4	   0 */		.word	4145
/* 0x03b8	   0 */		.word	7
/* 0x03bc	   0 */		.word	122
/* 0x03c0	   0 */		.align	4
/* 0x03c0	   0 */		.word	-1
/* 0x03c4	   0 */		.word	-1
/* 0x03c8	   0 */		.word	406
/* 0x03cc	   0 */		.word	16414
/* 0x03d0	   0 */		.word	1
/* 0x03d4	   0 */		.word	129
/* 0x03d8	   0 */		.align	4
/* 0x03d8	   0 */		.word	-1
/* 0x03dc	   0 */		.word	-1
/* 0x03e0	   0 */		.word	390
/* 0x03e4	   0 */		.word	65571
/* 0x03e8	   0 */		.word	1
/* 0x03ec	   0 */		.word	130
/* 0x03f0	   0 */		.align	4
/* 0x03f0	   0 */		.word	-1
/* 0x03f4	   0 */		.word	-1
/* 0x03f8	   0 */		.word	397
/* 0x03fc	   0 */		.word	65571
/* 0x0400	   0 */		.word	1
/* 0x0404	   0 */		.word	131
/* 0x0408	   0 */		.align	4
/* 0x0408	   0 */		.word	-1
/* 0x040c	   0 */		.word	-1
/* 0x0410	   0 */		.word	405
/* 0x0414	   0 */		.word	65571
/* 0x0418	   0 */		.word	1
/* 0x041c	   0 */		.word	132
/* 0x0420	   0 */		.align	4
/* 0x0420	   0 */		.word	-1
/* 0x0424	   0 */		.word	-1
/* 0x0428	   0 */		.word	390
/* 0x042c	   0 */		.word	4148
/* 0x0430	   0 */		.word	3
/* 0x0434	   0 */		.word	133
/* 0x0438	   0 */		.align	4
/* 0x0438	   0 */		.word	-1
/* 0x043c	   0 */		.word	-1
/* 0x0440	   0 */		.word	390
/* 0x0444	   0 */		.word	8218
/* 0x0448	   0 */		.word	2
/* 0x044c	   0 */		.word	136
/* 0x0450	   0 */		.align	4
/* 0x0450	   0 */		.word	-1
/* 0x0454	   0 */		.word	-1
/* 0x0458	   0 */		.word	390
/* 0x045c	   0 */		.word	4122
/* 0x0460	   0 */		.word	2
/* 0x0464	   0 */		.word	138
/* 0x0468	   0 */		.align	4
/* 0x0468	   0 */		.word	-1
/* 0x046c	   0 */		.word	-1
/* 0x0470	   0 */		.word	390
/* 0x0474	   0 */		.word	4123
/* 0x0478	   0 */		.word	7
/* 0x047c	   0 */		.word	140
/* 0x0480	   0 */		.align	4
/* 0x0480	   0 */		.word	-1
/* 0x0484	   0 */		.word	-1
/* 0x0488	   0 */		.word	390
/* 0x048c	   0 */		.word	4145
/* 0x0490	   0 */		.word	7
/* 0x0494	   0 */		.word	147
/* 0x0498	   0 */		.align	4
/* 0x0498	   0 */		.word	-1
/* 0x049c	   0 */		.word	-1
/* 0x04a0	   0 */		.word	405
/* 0x04a4	   0 */		.word	8219
/* 0x04a8	   0 */		.word	1
/* 0x04ac	   0 */		.word	154
/* 0x04b0	   0 */		.align	4
/* 0x04b0	   0 */		.word	-1
/* 0x04b4	   0 */		.word	-1
/* 0x04b8	   0 */		.word	397
/* 0x04bc	   0 */		.word	8218
/* 0x04c0	   0 */		.word	2
/* 0x04c4	   0 */		.word	155
/* 0x04c8	   0 */		.align	4
/* 0x04c8	   0 */		.word	-1
/* 0x04cc	   0 */		.word	-1
/* 0x04d0	   0 */		.word	397
/* 0x04d4	   0 */		.word	4122
/* 0x04d8	   0 */		.word	2
/* 0x04dc	   0 */		.word	157
/* 0x04e0	   0 */		.align	4
/* 0x04e0	   0 */		.word	-1
/* 0x04e4	   0 */		.word	-1
/* 0x04e8	   0 */		.word	397
/* 0x04ec	   0 */		.word	4123
/* 0x04f0	   0 */		.word	7
/* 0x04f4	   0 */		.word	159
/* 0x04f8	   0 */		.align	4
/* 0x04f8	   0 */		.word	-1
/* 0x04fc	   0 */		.word	-1
/* 0x0500	   0 */		.word	397
/* 0x0504	   0 */		.word	4145
/* 0x0508	   0 */		.word	7
/* 0x050c	   0 */		.word	166
/* 0x0510	   0 */		.align	4
/* 0x0510	   0 */		.word	-1
/* 0x0514	   0 */		.word	-1
/* 0x0518	   0 */		.word	390
/* 0x051c	   0 */		.word	8218
/* 0x0520	   0 */		.word	2
/* 0x0524	   0 */		.word	173
/* 0x0528	   0 */		.align	4
/* 0x0528	   0 */		.word	-1
/* 0x052c	   0 */		.word	-1
/* 0x0530	   0 */		.word	390
/* 0x0534	   0 */		.word	4122
/* 0x0538	   0 */		.word	2
/* 0x053c	   0 */		.word	175
/* 0x0540	   0 */		.align	4
/* 0x0540	   0 */		.word	-1
/* 0x0544	   0 */		.word	-1
/* 0x0548	   0 */		.word	390
/* 0x054c	   0 */		.word	4123
/* 0x0550	   0 */		.word	7
/* 0x0554	   0 */		.word	177
/* 0x0558	   0 */		.align	4
/* 0x0558	   0 */		.word	-1
/* 0x055c	   0 */		.word	-1
/* 0x0560	   0 */		.word	390
/* 0x0564	   0 */		.word	4145
/* 0x0568	   0 */		.word	7
/* 0x056c	   0 */		.word	184
/* 0x0570	   0 */		.align	4
/* 0x0570	   0 */		.word	-1
/* 0x0574	   0 */		.word	-1
/* 0x0578	   0 */		.word	423
/* 0x057c	   0 */		.word	16414
/* 0x0580	   0 */		.word	1
/* 0x0584	   0 */		.word	191
/* 0x0588	   0 */		.align	4
/* 0x0588	   0 */		.word	-1
/* 0x058c	   0 */		.word	-1
/* 0x0590	   0 */		.word	436
/* 0x0594	   0 */		.word	16414
/* 0x0598	   0 */		.word	1
/* 0x059c	   0 */		.word	192
/* 0x05a0	   0 */		.align	4
/* 0x05a0	   0 */		.word	-1
/* 0x05a4	   0 */		.word	-1
/* 0x05a8	   0 */		.word	444
/* 0x05ac	   0 */		.word	16414
/* 0x05b0	   0 */		.word	1
/* 0x05b4	   0 */		.word	193
/* 0x05b8	   0 */		.align	4
/* 0x05b8	   0 */		.word	-1
/* 0x05bc	   0 */		.word	-1
/* 0x05c0	   0 */		.word	452
/* 0x05c4	   0 */		.word	16414
/* 0x05c8	   0 */		.word	1
/* 0x05cc	   0 */		.word	194
/* 0x05d0	   0 */		.align	4
/* 0x05d0	   0 */		.word	-1
/* 0x05d4	   0 */		.word	-1
/* 0x05d8	   0 */		.word	463
/* 0x05dc	   0 */		.word	16414
/* 0x05e0	   0 */		.word	1
/* 0x05e4	   0 */		.word	195
/* 0x05e8	   0 */		.align	4
/* 0x05e8	   0 */		.word	-1
/* 0x05ec	   0 */		.word	-1
/* 0x05f0	   0 */		.word	474
/* 0x05f4	   0 */		.word	16414
/* 0x05f8	   0 */		.word	1
/* 0x05fc	   0 */		.word	196
/* 0x0600	   0 */		.align	4
/* 0x0600	   0 */		.word	-1
/* 0x0604	   0 */		.word	-1
/* 0x0608	   0 */		.word	482
/* 0x060c	   0 */		.word	16414
/* 0x0610	   0 */		.word	1
/* 0x0614	   0 */		.word	197
/* 0x0618	   0 */		.align	4
/* 0x0618	   0 */		.word	-1
/* 0x061c	   0 */		.word	-1
/* 0x0620	   0 */		.word	490
/* 0x0624	   0 */		.word	16414
/* 0x0628	   0 */		.word	1
/* 0x062c	   0 */		.word	198
/* 0x0630	   0 */		.align	4
/* 0x0630	   0 */		.word	-1
/* 0x0634	   0 */		.word	-1
/* 0x0638	   0 */		.word	501
/* 0x063c	   0 */		.word	16414
/* 0x0640	   0 */		.word	1
/* 0x0644	   0 */		.word	199
/* 0x0648	   0 */		.align	4
/* 0x0648	   0 */		.word	-1
/* 0x064c	   0 */		.word	-1
/* 0x0650	   0 */		.word	505
/* 0x0654	   0 */		.word	16414
/* 0x0658	   0 */		.word	1
/* 0x065c	   0 */		.word	200
/* 0x0660	   0 */		.align	4
/* 0x0660	   0 */		.word	-1
/* 0x0664	   0 */		.word	-1
/* 0x0668	   0 */		.word	507
/* 0x066c	   0 */		.word	16409
/* 0x0670	   0 */		.word	3
/* 0x0674	   0 */		.word	201
/* 0x0678	   0 */		.align	4
/* 0x0678	   0 */		.word	-1
/* 0x067c	   0 */		.word	-1
/* 0x0680	   0 */		.word	423
/* 0x0684	   0 */		.word	131075
/* 0x0688	   0 */		.word	1
/* 0x068c	   0 */		.word	204
/* 0x0690	   0 */		.align	4
/* 0x0690	   0 */		.word	-1
/* 0x0694	   0 */		.word	-1
/* 0x0698	   0 */		.word	526
/* 0x069c	   0 */		.word	16414
/* 0x06a0	   0 */		.word	1
/* 0x06a4	   0 */		.word	205
/* 0x06a8	   0 */		.align	4
/* 0x06a8	   0 */		.word	-1
/* 0x06ac	   0 */		.word	-1
/* 0x06b0	   0 */		.word	531
/* 0x06b4	   0 */		.word	16414
/* 0x06b8	   0 */		.word	1
/* 0x06bc	   0 */		.word	206
/* 0x06c0	   0 */		.align	4
/* 0x06c0	   0 */		.word	-1
/* 0x06c4	   0 */		.word	-1
/* 0x06c8	   0 */		.word	546
/* 0x06cc	   0 */		.word	16414
/* 0x06d0	   0 */		.word	1
/* 0x06d4	   0 */		.word	207
/* 0x06d8	   0 */		.align	4
/* 0x06d8	   0 */		.word	-1
/* 0x06dc	   0 */		.word	-1
/* 0x06e0	   0 */		.word	613
/* 0x06e4	   0 */		.word	16414
/* 0x06e8	   0 */		.word	1
/* 0x06ec	   0 */		.word	208
/* 0x06f0	   0 */		.align	4
/* 0x06f0	   0 */		.word	-1
/* 0x06f4	   0 */		.word	-1
/* 0x06f8	   0 */		.word	539
/* 0x06fc	   0 */		.word	65571
/* 0x0700	   0 */		.word	1
/* 0x0704	   0 */		.word	209
/* 0x0708	   0 */		.align	4
/* 0x0708	   0 */		.word	-1
/* 0x070c	   0 */		.word	-1
/* 0x0710	   0 */		.word	554
/* 0x0714	   0 */		.word	65571
/* 0x0718	   0 */		.word	1
/* 0x071c	   0 */		.word	210
/* 0x0720	   0 */		.align	4
/* 0x0720	   0 */		.word	-1
/* 0x0724	   0 */		.word	-1
/* 0x0728	   0 */		.word	560
/* 0x072c	   0 */		.word	65571
/* 0x0730	   0 */		.word	1
/* 0x0734	   0 */		.word	211
/* 0x0738	   0 */		.align	4
/* 0x0738	   0 */		.word	-1
/* 0x073c	   0 */		.word	-1
/* 0x0740	   0 */		.word	566
/* 0x0744	   0 */		.word	65571
/* 0x0748	   0 */		.word	1
/* 0x074c	   0 */		.word	212
/* 0x0750	   0 */		.align	4
/* 0x0750	   0 */		.word	-1
/* 0x0754	   0 */		.word	-1
/* 0x0758	   0 */		.word	572
/* 0x075c	   0 */		.word	65571
/* 0x0760	   0 */		.word	1
/* 0x0764	   0 */		.word	213
/* 0x0768	   0 */		.align	4
/* 0x0768	   0 */		.word	-1
/* 0x076c	   0 */		.word	-1
/* 0x0770	   0 */		.word	578
/* 0x0774	   0 */		.word	65571
/* 0x0778	   0 */		.word	1
/* 0x077c	   0 */		.word	214
/* 0x0780	   0 */		.align	4
/* 0x0780	   0 */		.word	-1
/* 0x0784	   0 */		.word	-1
/* 0x0788	   0 */		.word	584
/* 0x078c	   0 */		.word	65571
/* 0x0790	   0 */		.word	1
/* 0x0794	   0 */		.word	215
/* 0x0798	   0 */		.align	4
/* 0x0798	   0 */		.word	-1
/* 0x079c	   0 */		.word	-1
/* 0x07a0	   0 */		.word	590
/* 0x07a4	   0 */		.word	65571
/* 0x07a8	   0 */		.word	1
/* 0x07ac	   0 */		.word	216
/* 0x07b0	   0 */		.align	4
/* 0x07b0	   0 */		.word	-1
/* 0x07b4	   0 */		.word	-1
/* 0x07b8	   0 */		.word	596
/* 0x07bc	   0 */		.word	65571
/* 0x07c0	   0 */		.word	1
/* 0x07c4	   0 */		.word	217
/* 0x07c8	   0 */		.align	4
/* 0x07c8	   0 */		.word	-1
/* 0x07cc	   0 */		.word	-1
/* 0x07d0	   0 */		.word	602
/* 0x07d4	   0 */		.word	65571
/* 0x07d8	   0 */		.word	1
/* 0x07dc	   0 */		.word	218
/* 0x07e0	   0 */		.align	4
/* 0x07e0	   0 */		.word	-1
/* 0x07e4	   0 */		.word	-1
/* 0x07e8	   0 */		.word	608
/* 0x07ec	   0 */		.word	65571
/* 0x07f0	   0 */		.word	1
/* 0x07f4	   0 */		.word	219
/* 0x07f8	   0 */		.align	4
/* 0x07f8	   0 */		.word	-1
/* 0x07fc	   0 */		.word	-1
/* 0x0800	   0 */		.word	554
/* 0x0804	   0 */		.word	4148
/* 0x0808	   0 */		.word	3
/* 0x080c	   0 */		.word	220
/* 0x0810	   0 */		.align	4
/* 0x0810	   0 */		.word	-1
/* 0x0814	   0 */		.word	-1
/* 0x0818	   0 */		.word	560
/* 0x081c	   0 */		.word	4148
/* 0x0820	   0 */		.word	3
/* 0x0824	   0 */		.word	223
/* 0x0828	   0 */		.align	4
/* 0x0828	   0 */		.word	-1
/* 0x082c	   0 */		.word	-1
/* 0x0830	   0 */		.word	566
/* 0x0834	   0 */		.word	4148
/* 0x0838	   0 */		.word	3
/* 0x083c	   0 */		.word	226
/* 0x0840	   0 */		.align	4
/* 0x0840	   0 */		.word	-1
/* 0x0844	   0 */		.word	-1
/* 0x0848	   0 */		.word	572
/* 0x084c	   0 */		.word	4148
/* 0x0850	   0 */		.word	3
/* 0x0854	   0 */		.word	229
/* 0x0858	   0 */		.align	4
/* 0x0858	   0 */		.word	-1
/* 0x085c	   0 */		.word	-1
/* 0x0860	   0 */		.word	578
/* 0x0864	   0 */		.word	4148
/* 0x0868	   0 */		.word	3
/* 0x086c	   0 */		.word	232
/* 0x0870	   0 */		.align	4
/* 0x0870	   0 */		.word	-1
/* 0x0874	   0 */		.word	-1
/* 0x0878	   0 */		.word	584
/* 0x087c	   0 */		.word	4148
/* 0x0880	   0 */		.word	3
/* 0x0884	   0 */		.word	235
/* 0x0888	   0 */		.align	4
/* 0x0888	   0 */		.word	-1
/* 0x088c	   0 */		.word	-1
/* 0x0890	   0 */		.word	590
/* 0x0894	   0 */		.word	4148
/* 0x0898	   0 */		.word	3
/* 0x089c	   0 */		.word	238
/* 0x08a0	   0 */		.align	4
/* 0x08a0	   0 */		.word	-1
/* 0x08a4	   0 */		.word	-1
/* 0x08a8	   0 */		.word	596
/* 0x08ac	   0 */		.word	4148
/* 0x08b0	   0 */		.word	3
/* 0x08b4	   0 */		.word	241
/* 0x08b8	   0 */		.align	4
/* 0x08b8	   0 */		.word	-1
/* 0x08bc	   0 */		.word	-1
/* 0x08c0	   0 */		.word	602
/* 0x08c4	   0 */		.word	4148
/* 0x08c8	   0 */		.word	3
/* 0x08cc	   0 */		.word	244
/* 0x08d0	   0 */		.align	4
/* 0x08d0	   0 */		.word	-1
/* 0x08d4	   0 */		.word	-1
/* 0x08d8	   0 */		.word	608
/* 0x08dc	   0 */		.word	4148
/* 0x08e0	   0 */		.word	3
/* 0x08e4	   0 */		.word	247
/* 0x08e8	   0 */		.align	4
/* 0x08e8	   0 */		.word	-1
/* 0x08ec	   0 */		.word	-1
/* 0x08f0	   0 */		.word	526
/* 0x08f4	   0 */		.word	131075
/* 0x08f8	   0 */		.word	1
/* 0x08fc	   0 */		.word	250
/* 0x0900	   0 */		.align	4
/* 0x0900	   0 */		.word	-1
/* 0x0904	   0 */		.word	-1
/* 0x0908	   0 */		.word	531
/* 0x090c	   0 */		.word	131075
/* 0x0910	   0 */		.word	1
/* 0x0914	   0 */		.word	251
/* 0x0918	   0 */		.align	4
/* 0x0918	   0 */		.word	-1
/* 0x091c	   0 */		.word	-1
/* 0x0920	   0 */		.word	546
/* 0x0924	   0 */		.word	131075
/* 0x0928	   0 */		.word	1
/* 0x092c	   0 */		.word	252
/* 0x0930	   0 */		.align	4
/* 0x0930	   0 */		.word	-1
/* 0x0934	   0 */		.word	-1
/* 0x0938	   0 */		.word	613
/* 0x093c	   0 */		.word	131075
/* 0x0940	   0 */		.word	1
/* 0x0944	   0 */		.word	253
/* 0x0948	   0 */		.align	4
/* 0x0948	   0 */		.word	-1
/* 0x094c	   0 */		.word	-1
/* 0x0950	   0 */		.word	560
/* 0x0954	   0 */		.word	8218
/* 0x0958	   0 */		.word	2
/* 0x095c	   0 */		.word	254
/* 0x0960	   0 */		.align	4
/* 0x0960	   0 */		.word	-1
/* 0x0964	   0 */		.word	-1
/* 0x0968	   0 */		.word	560
/* 0x096c	   0 */		.word	4122
/* 0x0970	   0 */		.word	2
/* 0x0974	   0 */		.word	256
/* 0x0978	   0 */		.align	4
/* 0x0978	   0 */		.word	-1
/* 0x097c	   0 */		.word	-1
/* 0x0980	   0 */		.word	560
/* 0x0984	   0 */		.word	4123
/* 0x0988	   0 */		.word	7
/* 0x098c	   0 */		.word	258
/* 0x0990	   0 */		.align	4
/* 0x0990	   0 */		.word	-1
/* 0x0994	   0 */		.word	-1
/* 0x0998	   0 */		.word	560
/* 0x099c	   0 */		.word	4145
/* 0x09a0	   0 */		.word	7
/* 0x09a4	   0 */		.word	265
/* 0x09a8	   0 */		.align	4
/* 0x09a8	   0 */		.word	-1
/* 0x09ac	   0 */		.word	-1
/* 0x09b0	   0 */		.word	554
/* 0x09b4	   0 */		.word	8218
/* 0x09b8	   0 */		.word	2
/* 0x09bc	   0 */		.word	272
/* 0x09c0	   0 */		.align	4
/* 0x09c0	   0 */		.word	-1
/* 0x09c4	   0 */		.word	-1
/* 0x09c8	   0 */		.word	554
/* 0x09cc	   0 */		.word	4122
/* 0x09d0	   0 */		.word	2
/* 0x09d4	   0 */		.word	274
/* 0x09d8	   0 */		.align	4
/* 0x09d8	   0 */		.word	-1
/* 0x09dc	   0 */		.word	-1
/* 0x09e0	   0 */		.word	554
/* 0x09e4	   0 */		.word	4123
/* 0x09e8	   0 */		.word	7
/* 0x09ec	   0 */		.word	276
/* 0x09f0	   0 */		.align	4
/* 0x09f0	   0 */		.word	-1
/* 0x09f4	   0 */		.word	-1
/* 0x09f8	   0 */		.word	554
/* 0x09fc	   0 */		.word	4145
/* 0x0a00	   0 */		.word	7
/* 0x0a04	   0 */		.word	283
/* 0x0a08	   0 */		.align	4
/* 0x0a08	   0 */		.word	-1
/* 0x0a0c	   0 */		.word	-1
/* 0x0a10	   0 */		.word	554
/* 0x0a14	   0 */		.word	8229
/* 0x0a18	   0 */		.word	1
/* 0x0a1c	   0 */		.word	290
/* 0x0a20	   0 */		.align	4
/* 0x0a20	   0 */		.word	-1
/* 0x0a24	   0 */		.word	-1
/* 0x0a28	   0 */		.word	560
/* 0x0a2c	   0 */		.word	8229
/* 0x0a30	   0 */		.word	1
/* 0x0a34	   0 */		.word	291
/* 0x0a38	   0 */		.align	4
/* 0x0a38	   0 */		.word	-1
/* 0x0a3c	   0 */		.word	-1
/* 0x0a40	   0 */		.word	626
/* 0x0a44	   0 */		.word	16414
/* 0x0a48	   0 */		.word	1
/* 0x0a4c	   0 */		.word	292
/* 0x0a50	   0 */		.align	4
/* 0x0a50	   0 */		.word	-1
/* 0x0a54	   0 */		.word	-1
/* 0x0a58	   0 */		.word	665
/* 0x0a5c	   0 */		.word	16414
/* 0x0a60	   0 */		.word	1
/* 0x0a64	   0 */		.word	293
/* 0x0a68	   0 */		.align	4
/* 0x0a68	   0 */		.word	-1
/* 0x0a6c	   0 */		.word	-1
/* 0x0a70	   0 */		.word	631
/* 0x0a74	   0 */		.word	65571
/* 0x0a78	   0 */		.word	1
/* 0x0a7c	   0 */		.word	294
/* 0x0a80	   0 */		.align	4
/* 0x0a80	   0 */		.word	-1
/* 0x0a84	   0 */		.word	-1
/* 0x0a88	   0 */		.word	636
/* 0x0a8c	   0 */		.word	65571
/* 0x0a90	   0 */		.word	1
/* 0x0a94	   0 */		.word	295
/* 0x0a98	   0 */		.align	4
/* 0x0a98	   0 */		.word	-1
/* 0x0a9c	   0 */		.word	-1
/* 0x0aa0	   0 */		.word	631
/* 0x0aa4	   0 */		.word	4148
/* 0x0aa8	   0 */		.word	3
/* 0x0aac	   0 */		.word	296
/* 0x0ab0	   0 */		.align	4
/* 0x0ab0	   0 */		.word	-1
/* 0x0ab4	   0 */		.word	-1
/* 0x0ab8	   0 */		.word	636
/* 0x0abc	   0 */		.word	4148
/* 0x0ac0	   0 */		.word	3
/* 0x0ac4	   0 */		.word	299
/* 0x0ac8	   0 */		.align	4
/* 0x0ac8	   0 */		.word	-1
/* 0x0acc	   0 */		.word	-1
/* 0x0ad0	   0 */		.word	626
/* 0x0ad4	   0 */		.word	131075
/* 0x0ad8	   0 */		.word	1
/* 0x0adc	   0 */		.word	302
/* 0x0ae0	   0 */		.align	4
/* 0x0ae0	   0 */		.word	-1
/* 0x0ae4	   0 */		.word	-1
/* 0x0ae8	   0 */		.word	641
/* 0x0aec	   0 */		.word	131075
/* 0x0af0	   0 */		.word	1
/* 0x0af4	   0 */		.word	303
/* 0x0af8	   0 */		.align	4
/* 0x0af8	   0 */		.word	-1
/* 0x0afc	   0 */		.word	-1
/* 0x0b00	   0 */		.word	644
/* 0x0b04	   0 */		.word	131075
/* 0x0b08	   0 */		.word	1
/* 0x0b0c	   0 */		.word	304
/* 0x0b10	   0 */		.align	4
/* 0x0b10	   0 */		.word	-1
/* 0x0b14	   0 */		.word	-1
/* 0x0b18	   0 */		.word	647
/* 0x0b1c	   0 */		.word	131075
/* 0x0b20	   0 */		.word	1
/* 0x0b24	   0 */		.word	305
/* 0x0b28	   0 */		.align	4
/* 0x0b28	   0 */		.word	-1
/* 0x0b2c	   0 */		.word	-1
/* 0x0b30	   0 */		.word	650
/* 0x0b34	   0 */		.word	131075
/* 0x0b38	   0 */		.word	1
/* 0x0b3c	   0 */		.word	306
/* 0x0b40	   0 */		.align	4
/* 0x0b40	   0 */		.word	-1
/* 0x0b44	   0 */		.word	-1
/* 0x0b48	   0 */		.word	653
/* 0x0b4c	   0 */		.word	131075
/* 0x0b50	   0 */		.word	1
/* 0x0b54	   0 */		.word	307
/* 0x0b58	   0 */		.align	4
/* 0x0b58	   0 */		.word	-1
/* 0x0b5c	   0 */		.word	-1
/* 0x0b60	   0 */		.word	656
/* 0x0b64	   0 */		.word	131075
/* 0x0b68	   0 */		.word	1
/* 0x0b6c	   0 */		.word	308
/* 0x0b70	   0 */		.align	4
/* 0x0b70	   0 */		.word	-1
/* 0x0b74	   0 */		.word	-1
/* 0x0b78	   0 */		.word	659
/* 0x0b7c	   0 */		.word	131075
/* 0x0b80	   0 */		.word	1
/* 0x0b84	   0 */		.word	309
/* 0x0b88	   0 */		.align	4
/* 0x0b88	   0 */		.word	-1
/* 0x0b8c	   0 */		.word	-1
/* 0x0b90	   0 */		.word	662
/* 0x0b94	   0 */		.word	131075
/* 0x0b98	   0 */		.word	1
/* 0x0b9c	   0 */		.word	310
/* 0x0ba0	   0 */		.align	4
/* 0x0ba0	   0 */		.word	-1
/* 0x0ba4	   0 */		.word	-1
/* 0x0ba8	   0 */		.word	665
/* 0x0bac	   0 */		.word	131075
/* 0x0bb0	   0 */		.word	1
/* 0x0bb4	   0 */		.word	311
/* 0x0bb8	   0 */		.align	4
/* 0x0bb8	   0 */		.word	-1
/* 0x0bbc	   0 */		.word	-1
/* 0x0bc0	   0 */		.word	662
/* 0x0bc4	   0 */		.word	131089
/* 0x0bc8	   0 */		.word	4
/* 0x0bcc	   0 */		.word	312
/* 0x0bd0	   0 */		.align	4
/* 0x0bd0	   0 */		.word	-1
/* 0x0bd4	   0 */		.word	-1
/* 0x0bd8	   0 */		.word	659
/* 0x0bdc	   0 */		.word	131089
/* 0x0be0	   0 */		.word	4
/* 0x0be4	   0 */		.word	316
/* 0x0be8	   0 */		.align	4
/* 0x0be8	   0 */		.word	-1
/* 0x0bec	   0 */		.word	-1
/* 0x0bf0	   0 */		.word	656
/* 0x0bf4	   0 */		.word	131089
/* 0x0bf8	   0 */		.word	4
/* 0x0bfc	   0 */		.word	320
/* 0x0c00	   0 */		.align	4
/* 0x0c00	   0 */		.word	-1
/* 0x0c04	   0 */		.word	-1
/* 0x0c08	   0 */		.word	653
/* 0x0c0c	   0 */		.word	131089
/* 0x0c10	   0 */		.word	4
/* 0x0c14	   0 */		.word	324
/* 0x0c18	   0 */		.align	4
/* 0x0c18	   0 */		.word	-1
/* 0x0c1c	   0 */		.word	-1
/* 0x0c20	   0 */		.word	650
/* 0x0c24	   0 */		.word	131089
/* 0x0c28	   0 */		.word	4
/* 0x0c2c	   0 */		.word	328
/* 0x0c30	   0 */		.align	4
/* 0x0c30	   0 */		.word	-1
/* 0x0c34	   0 */		.word	-1
/* 0x0c38	   0 */		.word	647
/* 0x0c3c	   0 */		.word	131089
/* 0x0c40	   0 */		.word	4
/* 0x0c44	   0 */		.word	332
/* 0x0c48	   0 */		.align	4
/* 0x0c48	   0 */		.word	-1
/* 0x0c4c	   0 */		.word	-1
/* 0x0c50	   0 */		.word	644
/* 0x0c54	   0 */		.word	131089
/* 0x0c58	   0 */		.word	4
/* 0x0c5c	   0 */		.word	336
/* 0x0c60	   0 */		.align	4
/* 0x0c60	   0 */		.word	-1
/* 0x0c64	   0 */		.word	-1
/* 0x0c68	   0 */		.word	641
/* 0x0c6c	   0 */		.word	131089
/* 0x0c70	   0 */		.word	4
/* 0x0c74	   0 */		.word	340
/* 0x0c78	   0 */		.align	4
/* 0x0c78	   0 */		.word	-1
/* 0x0c7c	   0 */		.word	-1
/* 0x0c80	   0 */		.word	662
/* 0x0c84	   0 */		.word	8218
/* 0x0c88	   0 */		.word	2
/* 0x0c8c	   0 */		.word	344
/* 0x0c90	   0 */		.align	4
/* 0x0c90	   0 */		.word	-1
/* 0x0c94	   0 */		.word	-1
/* 0x0c98	   0 */		.word	662
/* 0x0c9c	   0 */		.word	4122
/* 0x0ca0	   0 */		.word	2
/* 0x0ca4	   0 */		.word	346
/* 0x0ca8	   0 */		.align	4
/* 0x0ca8	   0 */		.word	-1
/* 0x0cac	   0 */		.word	-1
/* 0x0cb0	   0 */		.word	662
/* 0x0cb4	   0 */		.word	4123
/* 0x0cb8	   0 */		.word	7
/* 0x0cbc	   0 */		.word	348
/* 0x0cc0	   0 */		.align	4
/* 0x0cc0	   0 */		.word	-1
/* 0x0cc4	   0 */		.word	-1
/* 0x0cc8	   0 */		.word	662
/* 0x0ccc	   0 */		.word	4145
/* 0x0cd0	   0 */		.word	7
/* 0x0cd4	   0 */		.word	355
/* 0x0cd8	   0 */		.align	4
/* 0x0cd8	   0 */		.word	-1
/* 0x0cdc	   0 */		.word	-1
/* 0x0ce0	   0 */		.word	659
/* 0x0ce4	   0 */		.word	8218
/* 0x0ce8	   0 */		.word	2
/* 0x0cec	   0 */		.word	362
/* 0x0cf0	   0 */		.align	4
/* 0x0cf0	   0 */		.word	-1
/* 0x0cf4	   0 */		.word	-1
/* 0x0cf8	   0 */		.word	659
/* 0x0cfc	   0 */		.word	4122
/* 0x0d00	   0 */		.word	2
/* 0x0d04	   0 */		.word	364
/* 0x0d08	   0 */		.align	4
/* 0x0d08	   0 */		.word	-1
/* 0x0d0c	   0 */		.word	-1
/* 0x0d10	   0 */		.word	659
/* 0x0d14	   0 */		.word	4123
/* 0x0d18	   0 */		.word	7
/* 0x0d1c	   0 */		.word	366
/* 0x0d20	   0 */		.align	4
/* 0x0d20	   0 */		.word	-1
/* 0x0d24	   0 */		.word	-1
/* 0x0d28	   0 */		.word	659
/* 0x0d2c	   0 */		.word	4145
/* 0x0d30	   0 */		.word	7
/* 0x0d34	   0 */		.word	373
/* 0x0d38	   0 */		.align	4
/* 0x0d38	   0 */		.word	-1
/* 0x0d3c	   0 */		.word	-1
/* 0x0d40	   0 */		.word	656
/* 0x0d44	   0 */		.word	8218
/* 0x0d48	   0 */		.word	2
/* 0x0d4c	   0 */		.word	380
/* 0x0d50	   0 */		.align	4
/* 0x0d50	   0 */		.word	-1
/* 0x0d54	   0 */		.word	-1
/* 0x0d58	   0 */		.word	656
/* 0x0d5c	   0 */		.word	4122
/* 0x0d60	   0 */		.word	2
/* 0x0d64	   0 */		.word	382
/* 0x0d68	   0 */		.align	4
/* 0x0d68	   0 */		.word	-1
/* 0x0d6c	   0 */		.word	-1
/* 0x0d70	   0 */		.word	656
/* 0x0d74	   0 */		.word	4123
/* 0x0d78	   0 */		.word	7
/* 0x0d7c	   0 */		.word	384
/* 0x0d80	   0 */		.align	4
/* 0x0d80	   0 */		.word	-1
/* 0x0d84	   0 */		.word	-1
/* 0x0d88	   0 */		.word	656
/* 0x0d8c	   0 */		.word	4145
/* 0x0d90	   0 */		.word	7
/* 0x0d94	   0 */		.word	391
/* 0x0d98	   0 */		.align	4
/* 0x0d98	   0 */		.word	-1
/* 0x0d9c	   0 */		.word	-1
/* 0x0da0	   0 */		.word	653
/* 0x0da4	   0 */		.word	8218
/* 0x0da8	   0 */		.word	2
/* 0x0dac	   0 */		.word	398
/* 0x0db0	   0 */		.align	4
/* 0x0db0	   0 */		.word	-1
/* 0x0db4	   0 */		.word	-1
/* 0x0db8	   0 */		.word	653
/* 0x0dbc	   0 */		.word	4122
/* 0x0dc0	   0 */		.word	2
/* 0x0dc4	   0 */		.word	400
/* 0x0dc8	   0 */		.align	4
/* 0x0dc8	   0 */		.word	-1
/* 0x0dcc	   0 */		.word	-1
/* 0x0dd0	   0 */		.word	653
/* 0x0dd4	   0 */		.word	4123
/* 0x0dd8	   0 */		.word	7
/* 0x0ddc	   0 */		.word	402
/* 0x0de0	   0 */		.align	4
/* 0x0de0	   0 */		.word	-1
/* 0x0de4	   0 */		.word	-1
/* 0x0de8	   0 */		.word	653
/* 0x0dec	   0 */		.word	4145
/* 0x0df0	   0 */		.word	7
/* 0x0df4	   0 */		.word	409
/* 0x0df8	   0 */		.align	4
/* 0x0df8	   0 */		.word	-1
/* 0x0dfc	   0 */		.word	-1
/* 0x0e00	   0 */		.word	650
/* 0x0e04	   0 */		.word	8218
/* 0x0e08	   0 */		.word	2
/* 0x0e0c	   0 */		.word	416
/* 0x0e10	   0 */		.align	4
/* 0x0e10	   0 */		.word	-1
/* 0x0e14	   0 */		.word	-1
/* 0x0e18	   0 */		.word	650
/* 0x0e1c	   0 */		.word	4122
/* 0x0e20	   0 */		.word	2
/* 0x0e24	   0 */		.word	418
/* 0x0e28	   0 */		.align	4
/* 0x0e28	   0 */		.word	-1
/* 0x0e2c	   0 */		.word	-1
/* 0x0e30	   0 */		.word	650
/* 0x0e34	   0 */		.word	4123
/* 0x0e38	   0 */		.word	7
/* 0x0e3c	   0 */		.word	420
/* 0x0e40	   0 */		.align	4
/* 0x0e40	   0 */		.word	-1
/* 0x0e44	   0 */		.word	-1
/* 0x0e48	   0 */		.word	650
/* 0x0e4c	   0 */		.word	4145
/* 0x0e50	   0 */		.word	7
/* 0x0e54	   0 */		.word	427
/* 0x0e58	   0 */		.align	4
/* 0x0e58	   0 */		.word	-1
/* 0x0e5c	   0 */		.word	-1
/* 0x0e60	   0 */		.word	647
/* 0x0e64	   0 */		.word	8218
/* 0x0e68	   0 */		.word	2
/* 0x0e6c	   0 */		.word	434
/* 0x0e70	   0 */		.align	4
/* 0x0e70	   0 */		.word	-1
/* 0x0e74	   0 */		.word	-1
/* 0x0e78	   0 */		.word	647
/* 0x0e7c	   0 */		.word	4122
/* 0x0e80	   0 */		.word	2
/* 0x0e84	   0 */		.word	436
/* 0x0e88	   0 */		.align	4
/* 0x0e88	   0 */		.word	-1
/* 0x0e8c	   0 */		.word	-1
/* 0x0e90	   0 */		.word	647
/* 0x0e94	   0 */		.word	4123
/* 0x0e98	   0 */		.word	7
/* 0x0e9c	   0 */		.word	438
/* 0x0ea0	   0 */		.align	4
/* 0x0ea0	   0 */		.word	-1
/* 0x0ea4	   0 */		.word	-1
/* 0x0ea8	   0 */		.word	647
/* 0x0eac	   0 */		.word	4145
/* 0x0eb0	   0 */		.word	7
/* 0x0eb4	   0 */		.word	445
/* 0x0eb8	   0 */		.align	4
/* 0x0eb8	   0 */		.word	-1
/* 0x0ebc	   0 */		.word	-1
/* 0x0ec0	   0 */		.word	644
/* 0x0ec4	   0 */		.word	8218
/* 0x0ec8	   0 */		.word	2
/* 0x0ecc	   0 */		.word	452
/* 0x0ed0	   0 */		.align	4
/* 0x0ed0	   0 */		.word	-1
/* 0x0ed4	   0 */		.word	-1
/* 0x0ed8	   0 */		.word	644
/* 0x0edc	   0 */		.word	4122
/* 0x0ee0	   0 */		.word	2
/* 0x0ee4	   0 */		.word	454
/* 0x0ee8	   0 */		.align	4
/* 0x0ee8	   0 */		.word	-1
/* 0x0eec	   0 */		.word	-1
/* 0x0ef0	   0 */		.word	644
/* 0x0ef4	   0 */		.word	4123
/* 0x0ef8	   0 */		.word	7
/* 0x0efc	   0 */		.word	456
/* 0x0f00	   0 */		.align	4
/* 0x0f00	   0 */		.word	-1
/* 0x0f04	   0 */		.word	-1
/* 0x0f08	   0 */		.word	644
/* 0x0f0c	   0 */		.word	4145
/* 0x0f10	   0 */		.word	7
/* 0x0f14	   0 */		.word	463
/* 0x0f18	   0 */		.align	4
/* 0x0f18	   0 */		.word	-1
/* 0x0f1c	   0 */		.word	-1
/* 0x0f20	   0 */		.word	641
/* 0x0f24	   0 */		.word	8218
/* 0x0f28	   0 */		.word	2
/* 0x0f2c	   0 */		.word	470
/* 0x0f30	   0 */		.align	4
/* 0x0f30	   0 */		.word	-1
/* 0x0f34	   0 */		.word	-1
/* 0x0f38	   0 */		.word	641
/* 0x0f3c	   0 */		.word	4122
/* 0x0f40	   0 */		.word	2
/* 0x0f44	   0 */		.word	472
/* 0x0f48	   0 */		.align	4
/* 0x0f48	   0 */		.word	-1
/* 0x0f4c	   0 */		.word	-1
/* 0x0f50	   0 */		.word	641
/* 0x0f54	   0 */		.word	4123
/* 0x0f58	   0 */		.word	7
/* 0x0f5c	   0 */		.word	474
/* 0x0f60	   0 */		.align	4
/* 0x0f60	   0 */		.word	-1
/* 0x0f64	   0 */		.word	-1
/* 0x0f68	   0 */		.word	641
/* 0x0f6c	   0 */		.word	4145
/* 0x0f70	   0 */		.word	7
/* 0x0f74	   0 */		.word	481
/* 0x0f78	   0 */		.align	4
/* 0x0f78	   0 */		.word	-1
/* 0x0f7c	   0 */		.word	-1
/* 0x0f80	   0 */		.word	636
/* 0x0f84	   0 */		.word	8218
/* 0x0f88	   0 */		.word	2
/* 0x0f8c	   0 */		.word	488
/* 0x0f90	   0 */		.align	4
/* 0x0f90	   0 */		.word	-1
/* 0x0f94	   0 */		.word	-1
/* 0x0f98	   0 */		.word	636
/* 0x0f9c	   0 */		.word	4122
/* 0x0fa0	   0 */		.word	2
/* 0x0fa4	   0 */		.word	490
/* 0x0fa8	   0 */		.align	4
/* 0x0fa8	   0 */		.word	-1
/* 0x0fac	   0 */		.word	-1
/* 0x0fb0	   0 */		.word	636
/* 0x0fb4	   0 */		.word	4123
/* 0x0fb8	   0 */		.word	7
/* 0x0fbc	   0 */		.word	492
/* 0x0fc0	   0 */		.align	4
/* 0x0fc0	   0 */		.word	-1
/* 0x0fc4	   0 */		.word	-1
/* 0x0fc8	   0 */		.word	636
/* 0x0fcc	   0 */		.word	4145
/* 0x0fd0	   0 */		.word	7
/* 0x0fd4	   0 */		.word	499
/* 0x0fd8	   0 */		.align	4
/* 0x0fd8	   0 */		.word	-1
/* 0x0fdc	   0 */		.word	-1
/* 0x0fe0	   0 */		.word	631
/* 0x0fe4	   0 */		.word	8218
/* 0x0fe8	   0 */		.word	2
/* 0x0fec	   0 */		.word	506
/* 0x0ff0	   0 */		.align	4
/* 0x0ff0	   0 */		.word	-1
/* 0x0ff4	   0 */		.word	-1
/* 0x0ff8	   0 */		.word	631
/* 0x0ffc	   0 */		.word	4122
/* 0x1000	   0 */		.word	2
/* 0x1004	   0 */		.word	508
/* 0x1008	   0 */		.align	4
/* 0x1008	   0 */		.word	-1
/* 0x100c	   0 */		.word	-1
/* 0x1010	   0 */		.word	631
/* 0x1014	   0 */		.word	4123
/* 0x1018	   0 */		.word	7
/* 0x101c	   0 */		.word	510
/* 0x1020	   0 */		.align	4
/* 0x1020	   0 */		.word	-1
/* 0x1024	   0 */		.word	-1
/* 0x1028	   0 */		.word	631
/* 0x102c	   0 */		.word	4145
/* 0x1030	   0 */		.word	7
/* 0x1034	   0 */		.word	517
/* 0x1038	   0 */		.align	4
/* 0x1038	   0 */		.word	-1
/* 0x103c	   0 */		.word	-1
/* 0x1040	   0 */		.word	631
/* 0x1044	   0 */		.word	8229
/* 0x1048	   0 */		.word	1
/* 0x104c	   0 */		.word	524
/* 0x1050	   0 */		.align	4
/* 0x1050	   0 */		.word	-1
/* 0x1054	   0 */		.word	-1
/* 0x1058	   0 */		.word	636
/* 0x105c	   0 */		.word	8229
/* 0x1060	   0 */		.word	1
/* 0x1064	   0 */		.word	525
/* 0x1068	   0 */		.align	4
/* 0x1068	   0 */		.word	-1
/* 0x106c	   0 */		.word	-1
/* 0x1070	   0 */		.word	641
/* 0x1074	   0 */		.word	8218
/* 0x1078	   0 */		.word	2
/* 0x107c	   0 */		.word	526
/* 0x1080	   0 */		.align	4
/* 0x1080	   0 */		.word	-1
/* 0x1084	   0 */		.word	-1
/* 0x1088	   0 */		.word	641
/* 0x108c	   0 */		.word	4122
/* 0x1090	   0 */		.word	2
/* 0x1094	   0 */		.word	528
/* 0x1098	   0 */		.align	4
/* 0x1098	   0 */		.word	-1
/* 0x109c	   0 */		.word	-1
/* 0x10a0	   0 */		.word	641
/* 0x10a4	   0 */		.word	4123
/* 0x10a8	   0 */		.word	7
/* 0x10ac	   0 */		.word	530
/* 0x10b0	   0 */		.align	4
/* 0x10b0	   0 */		.word	-1
/* 0x10b4	   0 */		.word	-1
/* 0x10b8	   0 */		.word	641
/* 0x10bc	   0 */		.word	4145
/* 0x10c0	   0 */		.word	7
/* 0x10c4	   0 */		.word	537
/* 0x10c8	   0 */		.align	4
/* 0x10c8	   0 */		.word	-1
/* 0x10cc	   0 */		.word	-1
/* 0x10d0	   0 */		.word	644
/* 0x10d4	   0 */		.word	8218
/* 0x10d8	   0 */		.word	2
/* 0x10dc	   0 */		.word	544
/* 0x10e0	   0 */		.align	4
/* 0x10e0	   0 */		.word	-1
/* 0x10e4	   0 */		.word	-1
/* 0x10e8	   0 */		.word	644
/* 0x10ec	   0 */		.word	4122
/* 0x10f0	   0 */		.word	2
/* 0x10f4	   0 */		.word	546
/* 0x10f8	   0 */		.align	4
/* 0x10f8	   0 */		.word	-1
/* 0x10fc	   0 */		.word	-1
/* 0x1100	   0 */		.word	644
/* 0x1104	   0 */		.word	4123
/* 0x1108	   0 */		.word	7
/* 0x110c	   0 */		.word	548
/* 0x1110	   0 */		.align	4
/* 0x1110	   0 */		.word	-1
/* 0x1114	   0 */		.word	-1
/* 0x1118	   0 */		.word	644
/* 0x111c	   0 */		.word	4145
/* 0x1120	   0 */		.word	7
/* 0x1124	   0 */		.word	555
/* 0x1128	   0 */		.align	4
/* 0x1128	   0 */		.word	-1
/* 0x112c	   0 */		.word	-1
/* 0x1130	   0 */		.word	647
/* 0x1134	   0 */		.word	8218
/* 0x1138	   0 */		.word	2
/* 0x113c	   0 */		.word	562
/* 0x1140	   0 */		.align	4
/* 0x1140	   0 */		.word	-1
/* 0x1144	   0 */		.word	-1
/* 0x1148	   0 */		.word	647
/* 0x114c	   0 */		.word	4122
/* 0x1150	   0 */		.word	2
/* 0x1154	   0 */		.word	564
/* 0x1158	   0 */		.align	4
/* 0x1158	   0 */		.word	-1
/* 0x115c	   0 */		.word	-1
/* 0x1160	   0 */		.word	647
/* 0x1164	   0 */		.word	4123
/* 0x1168	   0 */		.word	7
/* 0x116c	   0 */		.word	566
/* 0x1170	   0 */		.align	4
/* 0x1170	   0 */		.word	-1
/* 0x1174	   0 */		.word	-1
/* 0x1178	   0 */		.word	647
/* 0x117c	   0 */		.word	4145
/* 0x1180	   0 */		.word	7
/* 0x1184	   0 */		.word	573
/* 0x1188	   0 */		.align	4
/* 0x1188	   0 */		.word	-1
/* 0x118c	   0 */		.word	-1
/* 0x1190	   0 */		.word	650
/* 0x1194	   0 */		.word	8218
/* 0x1198	   0 */		.word	2
/* 0x119c	   0 */		.word	580
/* 0x11a0	   0 */		.align	4
/* 0x11a0	   0 */		.word	-1
/* 0x11a4	   0 */		.word	-1
/* 0x11a8	   0 */		.word	650
/* 0x11ac	   0 */		.word	4122
/* 0x11b0	   0 */		.word	2
/* 0x11b4	   0 */		.word	582
/* 0x11b8	   0 */		.align	4
/* 0x11b8	   0 */		.word	-1
/* 0x11bc	   0 */		.word	-1
/* 0x11c0	   0 */		.word	650
/* 0x11c4	   0 */		.word	4123
/* 0x11c8	   0 */		.word	7
/* 0x11cc	   0 */		.word	584
/* 0x11d0	   0 */		.align	4
/* 0x11d0	   0 */		.word	-1
/* 0x11d4	   0 */		.word	-1
/* 0x11d8	   0 */		.word	650
/* 0x11dc	   0 */		.word	4145
/* 0x11e0	   0 */		.word	7
/* 0x11e4	   0 */		.word	591
/* 0x11e8	   0 */		.align	4
/* 0x11e8	   0 */		.word	-1
/* 0x11ec	   0 */		.word	-1
/* 0x11f0	   0 */		.word	653
/* 0x11f4	   0 */		.word	8218
/* 0x11f8	   0 */		.word	2
/* 0x11fc	   0 */		.word	598
/* 0x1200	   0 */		.align	4
/* 0x1200	   0 */		.word	-1
/* 0x1204	   0 */		.word	-1
/* 0x1208	   0 */		.word	653
/* 0x120c	   0 */		.word	4122
/* 0x1210	   0 */		.word	2
/* 0x1214	   0 */		.word	600
/* 0x1218	   0 */		.align	4
/* 0x1218	   0 */		.word	-1
/* 0x121c	   0 */		.word	-1
/* 0x1220	   0 */		.word	653
/* 0x1224	   0 */		.word	4123
/* 0x1228	   0 */		.word	7
/* 0x122c	   0 */		.word	602
/* 0x1230	   0 */		.align	4
/* 0x1230	   0 */		.word	-1
/* 0x1234	   0 */		.word	-1
/* 0x1238	   0 */		.word	653
/* 0x123c	   0 */		.word	4145
/* 0x1240	   0 */		.word	7
/* 0x1244	   0 */		.word	609
/* 0x1248	   0 */		.align	4
/* 0x1248	   0 */		.word	-1
/* 0x124c	   0 */		.word	-1
/* 0x1250	   0 */		.word	656
/* 0x1254	   0 */		.word	8218
/* 0x1258	   0 */		.word	2
/* 0x125c	   0 */		.word	616
/* 0x1260	   0 */		.align	4
/* 0x1260	   0 */		.word	-1
/* 0x1264	   0 */		.word	-1
/* 0x1268	   0 */		.word	656
/* 0x126c	   0 */		.word	4122
/* 0x1270	   0 */		.word	2
/* 0x1274	   0 */		.word	618
/* 0x1278	   0 */		.align	4
/* 0x1278	   0 */		.word	-1
/* 0x127c	   0 */		.word	-1
/* 0x1280	   0 */		.word	656
/* 0x1284	   0 */		.word	4123
/* 0x1288	   0 */		.word	7
/* 0x128c	   0 */		.word	620
/* 0x1290	   0 */		.align	4
/* 0x1290	   0 */		.word	-1
/* 0x1294	   0 */		.word	-1
/* 0x1298	   0 */		.word	656
/* 0x129c	   0 */		.word	4145
/* 0x12a0	   0 */		.word	7
/* 0x12a4	   0 */		.word	627
/* 0x12a8	   0 */		.align	4
/* 0x12a8	   0 */		.word	-1
/* 0x12ac	   0 */		.word	-1
/* 0x12b0	   0 */		.word	659
/* 0x12b4	   0 */		.word	8218
/* 0x12b8	   0 */		.word	2
/* 0x12bc	   0 */		.word	634
/* 0x12c0	   0 */		.align	4
/* 0x12c0	   0 */		.word	-1
/* 0x12c4	   0 */		.word	-1
/* 0x12c8	   0 */		.word	659
/* 0x12cc	   0 */		.word	4122
/* 0x12d0	   0 */		.word	2
/* 0x12d4	   0 */		.word	636
/* 0x12d8	   0 */		.align	4
/* 0x12d8	   0 */		.word	-1
/* 0x12dc	   0 */		.word	-1
/* 0x12e0	   0 */		.word	659
/* 0x12e4	   0 */		.word	4123
/* 0x12e8	   0 */		.word	7
/* 0x12ec	   0 */		.word	638
/* 0x12f0	   0 */		.align	4
/* 0x12f0	   0 */		.word	-1
/* 0x12f4	   0 */		.word	-1
/* 0x12f8	   0 */		.word	659
/* 0x12fc	   0 */		.word	4145
/* 0x1300	   0 */		.word	7
/* 0x1304	   0 */		.word	645
/* 0x1308	   0 */		.align	4
/* 0x1308	   0 */		.word	-1
/* 0x130c	   0 */		.word	-1
/* 0x1310	   0 */		.word	662
/* 0x1314	   0 */		.word	8218
/* 0x1318	   0 */		.word	2
/* 0x131c	   0 */		.word	652
/* 0x1320	   0 */		.align	4
/* 0x1320	   0 */		.word	-1
/* 0x1324	   0 */		.word	-1
/* 0x1328	   0 */		.word	662
/* 0x132c	   0 */		.word	4122
/* 0x1330	   0 */		.word	2
/* 0x1334	   0 */		.word	654
/* 0x1338	   0 */		.align	4
/* 0x1338	   0 */		.word	-1
/* 0x133c	   0 */		.word	-1
/* 0x1340	   0 */		.word	662
/* 0x1344	   0 */		.word	4123
/* 0x1348	   0 */		.word	7
/* 0x134c	   0 */		.word	656
/* 0x1350	   0 */		.align	4
/* 0x1350	   0 */		.word	-1
/* 0x1354	   0 */		.word	-1
/* 0x1358	   0 */		.word	662
/* 0x135c	   0 */		.word	4145
/* 0x1360	   0 */		.word	7
/* 0x1364	   0 */		.word	663
/* 0x1368	   0 */		.align	4
/* 0x1368	   0 */		.word	-1
/* 0x136c	   0 */		.word	-1
/* 0x1370	   0 */		.word	675
/* 0x1374	   0 */		.word	16414
/* 0x1378	   0 */		.word	1
/* 0x137c	   0 */		.word	670
/* 0x1380	   0 */		.align	4
/* 0x1380	   0 */		.word	-1
/* 0x1384	   0 */		.word	-1
/* 0x1388	   0 */		.word	726
/* 0x138c	   0 */		.word	16414
/* 0x1390	   0 */		.word	1
/* 0x1394	   0 */		.word	671
/* 0x1398	   0 */		.align	4
/* 0x1398	   0 */		.word	-1
/* 0x139c	   0 */		.word	-1
/* 0x13a0	   0 */		.word	686
/* 0x13a4	   0 */		.word	65571
/* 0x13a8	   0 */		.word	1
/* 0x13ac	   0 */		.word	672
/* 0x13b0	   0 */		.align	4
/* 0x13b0	   0 */		.word	-1
/* 0x13b4	   0 */		.word	-1
/* 0x13b8	   0 */		.word	691
/* 0x13bc	   0 */		.word	65571
/* 0x13c0	   0 */		.word	1
/* 0x13c4	   0 */		.word	673
/* 0x13c8	   0 */		.align	4
/* 0x13c8	   0 */		.word	-1
/* 0x13cc	   0 */		.word	-1
/* 0x13d0	   0 */		.word	696
/* 0x13d4	   0 */		.word	65571
/* 0x13d8	   0 */		.word	1
/* 0x13dc	   0 */		.word	674
/* 0x13e0	   0 */		.align	4
/* 0x13e0	   0 */		.word	-1
/* 0x13e4	   0 */		.word	-1
/* 0x13e8	   0 */		.word	701
/* 0x13ec	   0 */		.word	65571
/* 0x13f0	   0 */		.word	1
/* 0x13f4	   0 */		.word	675
/* 0x13f8	   0 */		.align	4
/* 0x13f8	   0 */		.word	-1
/* 0x13fc	   0 */		.word	-1
/* 0x1400	   0 */		.word	706
/* 0x1404	   0 */		.word	65571
/* 0x1408	   0 */		.word	1
/* 0x140c	   0 */		.word	676
/* 0x1410	   0 */		.align	4
/* 0x1410	   0 */		.word	-1
/* 0x1414	   0 */		.word	-1
/* 0x1418	   0 */		.word	711
/* 0x141c	   0 */		.word	65571
/* 0x1420	   0 */		.word	1
/* 0x1424	   0 */		.word	677
/* 0x1428	   0 */		.align	4
/* 0x1428	   0 */		.word	-1
/* 0x142c	   0 */		.word	-1
/* 0x1430	   0 */		.word	716
/* 0x1434	   0 */		.word	65571
/* 0x1438	   0 */		.word	1
/* 0x143c	   0 */		.word	678
/* 0x1440	   0 */		.align	4
/* 0x1440	   0 */		.word	-1
/* 0x1444	   0 */		.word	-1
/* 0x1448	   0 */		.word	721
/* 0x144c	   0 */		.word	65571
/* 0x1450	   0 */		.word	1
/* 0x1454	   0 */		.word	679
/* 0x1458	   0 */		.align	4
/* 0x1458	   0 */		.word	-1
/* 0x145c	   0 */		.word	-1
/* 0x1460	   0 */		.word	686
/* 0x1464	   0 */		.word	4148
/* 0x1468	   0 */		.word	3
/* 0x146c	   0 */		.word	680
/* 0x1470	   0 */		.align	4
/* 0x1470	   0 */		.word	-1
/* 0x1474	   0 */		.word	-1
/* 0x1478	   0 */		.word	691
/* 0x147c	   0 */		.word	4148
/* 0x1480	   0 */		.word	3
/* 0x1484	   0 */		.word	683
/* 0x1488	   0 */		.align	4
/* 0x1488	   0 */		.word	-1
/* 0x148c	   0 */		.word	-1
/* 0x1490	   0 */		.word	696
/* 0x1494	   0 */		.word	4148
/* 0x1498	   0 */		.word	3
/* 0x149c	   0 */		.word	686
/* 0x14a0	   0 */		.align	4
/* 0x14a0	   0 */		.word	-1
/* 0x14a4	   0 */		.word	-1
/* 0x14a8	   0 */		.word	701
/* 0x14ac	   0 */		.word	4148
/* 0x14b0	   0 */		.word	3
/* 0x14b4	   0 */		.word	689
/* 0x14b8	   0 */		.align	4
/* 0x14b8	   0 */		.word	-1
/* 0x14bc	   0 */		.word	-1
/* 0x14c0	   0 */		.word	706
/* 0x14c4	   0 */		.word	4148
/* 0x14c8	   0 */		.word	3
/* 0x14cc	   0 */		.word	692
/* 0x14d0	   0 */		.align	4
/* 0x14d0	   0 */		.word	-1
/* 0x14d4	   0 */		.word	-1
/* 0x14d8	   0 */		.word	711
/* 0x14dc	   0 */		.word	4148
/* 0x14e0	   0 */		.word	3
/* 0x14e4	   0 */		.word	695
/* 0x14e8	   0 */		.align	4
/* 0x14e8	   0 */		.word	-1
/* 0x14ec	   0 */		.word	-1
/* 0x14f0	   0 */		.word	716
/* 0x14f4	   0 */		.word	4148
/* 0x14f8	   0 */		.word	3
/* 0x14fc	   0 */		.word	698
/* 0x1500	   0 */		.align	4
/* 0x1500	   0 */		.word	-1
/* 0x1504	   0 */		.word	-1
/* 0x1508	   0 */		.word	721
/* 0x150c	   0 */		.word	4148
/* 0x1510	   0 */		.word	3
/* 0x1514	   0 */		.word	701
/* 0x1518	   0 */		.align	4
/* 0x1518	   0 */		.word	-1
/* 0x151c	   0 */		.word	-1
/* 0x1520	   0 */		.word	675
/* 0x1524	   0 */		.word	131075
/* 0x1528	   0 */		.word	1
/* 0x152c	   0 */		.word	704
/* 0x1530	   0 */		.align	4
/* 0x1530	   0 */		.word	-1
/* 0x1534	   0 */		.word	-1
/* 0x1538	   0 */		.word	680
/* 0x153c	   0 */		.word	131075
/* 0x1540	   0 */		.word	1
/* 0x1544	   0 */		.word	705
/* 0x1548	   0 */		.align	4
/* 0x1548	   0 */		.word	-1
/* 0x154c	   0 */		.word	-1
/* 0x1550	   0 */		.word	683
/* 0x1554	   0 */		.word	131075
/* 0x1558	   0 */		.word	1
/* 0x155c	   0 */		.word	706
/* 0x1560	   0 */		.align	4
/* 0x1560	   0 */		.word	-1
/* 0x1564	   0 */		.word	-1
/* 0x1568	   0 */		.word	726
/* 0x156c	   0 */		.word	131075
/* 0x1570	   0 */		.word	1
/* 0x1574	   0 */		.word	707
/* 0x1578	   0 */		.align	4
/* 0x1578	   0 */		.word	-1
/* 0x157c	   0 */		.word	-1
/* 0x1580	   0 */		.word	683
/* 0x1584	   0 */		.word	131089
/* 0x1588	   0 */		.word	4
/* 0x158c	   0 */		.word	708
/* 0x1590	   0 */		.align	4
/* 0x1590	   0 */		.word	-1
/* 0x1594	   0 */		.word	-1
/* 0x1598	   0 */		.word	680
/* 0x159c	   0 */		.word	131089
/* 0x15a0	   0 */		.word	4
/* 0x15a4	   0 */		.word	712
/* 0x15a8	   0 */		.align	4
/* 0x15a8	   0 */		.word	-1
/* 0x15ac	   0 */		.word	-1
/* 0x15b0	   0 */		.word	683
/* 0x15b4	   0 */		.word	8218
/* 0x15b8	   0 */		.word	2
/* 0x15bc	   0 */		.word	716
/* 0x15c0	   0 */		.align	4
/* 0x15c0	   0 */		.word	-1
/* 0x15c4	   0 */		.word	-1
/* 0x15c8	   0 */		.word	683
/* 0x15cc	   0 */		.word	4122
/* 0x15d0	   0 */		.word	2
/* 0x15d4	   0 */		.word	718
/* 0x15d8	   0 */		.align	4
/* 0x15d8	   0 */		.word	-1
/* 0x15dc	   0 */		.word	-1
/* 0x15e0	   0 */		.word	683
/* 0x15e4	   0 */		.word	4123
/* 0x15e8	   0 */		.word	7
/* 0x15ec	   0 */		.word	720
/* 0x15f0	   0 */		.align	4
/* 0x15f0	   0 */		.word	-1
/* 0x15f4	   0 */		.word	-1
/* 0x15f8	   0 */		.word	683
/* 0x15fc	   0 */		.word	4145
/* 0x1600	   0 */		.word	7
/* 0x1604	   0 */		.word	727
/* 0x1608	   0 */		.align	4
/* 0x1608	   0 */		.word	-1
/* 0x160c	   0 */		.word	-1
/* 0x1610	   0 */		.word	680
/* 0x1614	   0 */		.word	8218
/* 0x1618	   0 */		.word	2
/* 0x161c	   0 */		.word	734
/* 0x1620	   0 */		.align	4
/* 0x1620	   0 */		.word	-1
/* 0x1624	   0 */		.word	-1
/* 0x1628	   0 */		.word	680
/* 0x162c	   0 */		.word	4122
/* 0x1630	   0 */		.word	2
/* 0x1634	   0 */		.word	736
/* 0x1638	   0 */		.align	4
/* 0x1638	   0 */		.word	-1
/* 0x163c	   0 */		.word	-1
/* 0x1640	   0 */		.word	680
/* 0x1644	   0 */		.word	4123
/* 0x1648	   0 */		.word	7
/* 0x164c	   0 */		.word	738
/* 0x1650	   0 */		.align	4
/* 0x1650	   0 */		.word	-1
/* 0x1654	   0 */		.word	-1
/* 0x1658	   0 */		.word	680
/* 0x165c	   0 */		.word	4145
/* 0x1660	   0 */		.word	7
/* 0x1664	   0 */		.word	745
/* 0x1668	   0 */		.align	4
/* 0x1668	   0 */		.word	-1
/* 0x166c	   0 */		.word	-1
/* 0x1670	   0 */		.word	680
/* 0x1674	   0 */		.word	8218
/* 0x1678	   0 */		.word	2
/* 0x167c	   0 */		.word	752
/* 0x1680	   0 */		.align	4
/* 0x1680	   0 */		.word	-1
/* 0x1684	   0 */		.word	-1
/* 0x1688	   0 */		.word	680
/* 0x168c	   0 */		.word	4122
/* 0x1690	   0 */		.word	2
/* 0x1694	   0 */		.word	754
/* 0x1698	   0 */		.align	4
/* 0x1698	   0 */		.word	-1
/* 0x169c	   0 */		.word	-1
/* 0x16a0	   0 */		.word	680
/* 0x16a4	   0 */		.word	4123
/* 0x16a8	   0 */		.word	7
/* 0x16ac	   0 */		.word	756
/* 0x16b0	   0 */		.align	4
/* 0x16b0	   0 */		.word	-1
/* 0x16b4	   0 */		.word	-1
/* 0x16b8	   0 */		.word	680
/* 0x16bc	   0 */		.word	4145
/* 0x16c0	   0 */		.word	7
/* 0x16c4	   0 */		.word	763
/* 0x16c8	   0 */		.align	4
/* 0x16c8	   0 */		.word	-1
/* 0x16cc	   0 */		.word	-1
/* 0x16d0	   0 */		.word	683
/* 0x16d4	   0 */		.word	8218
/* 0x16d8	   0 */		.word	2
/* 0x16dc	   0 */		.word	770
/* 0x16e0	   0 */		.align	4
/* 0x16e0	   0 */		.word	-1
/* 0x16e4	   0 */		.word	-1
/* 0x16e8	   0 */		.word	683
/* 0x16ec	   0 */		.word	4122
/* 0x16f0	   0 */		.word	2
/* 0x16f4	   0 */		.word	772
/* 0x16f8	   0 */		.align	4
/* 0x16f8	   0 */		.word	-1
/* 0x16fc	   0 */		.word	-1
/* 0x1700	   0 */		.word	683
/* 0x1704	   0 */		.word	4123
/* 0x1708	   0 */		.word	7
/* 0x170c	   0 */		.word	774
/* 0x1710	   0 */		.align	4
/* 0x1710	   0 */		.word	-1
/* 0x1714	   0 */		.word	-1
/* 0x1718	   0 */		.word	683
/* 0x171c	   0 */		.word	4145
/* 0x1720	   0 */		.word	7
/* 0x1724	   0 */		.word	781
/* 0x1728	   0 */		.align	4
/* 0x1728	   0 */		.word	-1
/* 0x172c	   0 */		.word	-1
/* 0x1730	   0 */		.word	736
/* 0x1734	   0 */		.word	16414
/* 0x1738	   0 */		.word	1
/* 0x173c	   0 */		.word	788
/* 0x1740	   0 */		.align	4
/* 0x1740	   0 */		.word	-1
/* 0x1744	   0 */		.word	-1
/* 0x1748	   0 */		.word	791
/* 0x174c	   0 */		.word	16414
/* 0x1750	   0 */		.word	1
/* 0x1754	   0 */		.word	789
/* 0x1758	   0 */		.align	4
/* 0x1758	   0 */		.word	-1
/* 0x175c	   0 */		.word	-1
/* 0x1760	   0 */		.word	741
/* 0x1764	   0 */		.word	65571
/* 0x1768	   0 */		.word	1
/* 0x176c	   0 */		.word	790
/* 0x1770	   0 */		.align	4
/* 0x1770	   0 */		.word	-1
/* 0x1774	   0 */		.word	-1
/* 0x1778	   0 */		.word	746
/* 0x177c	   0 */		.word	65571
/* 0x1780	   0 */		.word	1
/* 0x1784	   0 */		.word	791
/* 0x1788	   0 */		.align	4
/* 0x1788	   0 */		.word	-1
/* 0x178c	   0 */		.word	-1
/* 0x1790	   0 */		.word	751
/* 0x1794	   0 */		.word	65571
/* 0x1798	   0 */		.word	1
/* 0x179c	   0 */		.word	792
/* 0x17a0	   0 */		.align	4
/* 0x17a0	   0 */		.word	-1
/* 0x17a4	   0 */		.word	-1
/* 0x17a8	   0 */		.word	756
/* 0x17ac	   0 */		.word	65571
/* 0x17b0	   0 */		.word	1
/* 0x17b4	   0 */		.word	793
/* 0x17b8	   0 */		.align	4
/* 0x17b8	   0 */		.word	-1
/* 0x17bc	   0 */		.word	-1
/* 0x17c0	   0 */		.word	761
/* 0x17c4	   0 */		.word	65571
/* 0x17c8	   0 */		.word	1
/* 0x17cc	   0 */		.word	794
/* 0x17d0	   0 */		.align	4
/* 0x17d0	   0 */		.word	-1
/* 0x17d4	   0 */		.word	-1
/* 0x17d8	   0 */		.word	766
/* 0x17dc	   0 */		.word	65571
/* 0x17e0	   0 */		.word	1
/* 0x17e4	   0 */		.word	795
/* 0x17e8	   0 */		.align	4
/* 0x17e8	   0 */		.word	-1
/* 0x17ec	   0 */		.word	-1
/* 0x17f0	   0 */		.word	771
/* 0x17f4	   0 */		.word	65571
/* 0x17f8	   0 */		.word	1
/* 0x17fc	   0 */		.word	796
/* 0x1800	   0 */		.align	4
/* 0x1800	   0 */		.word	-1
/* 0x1804	   0 */		.word	-1
/* 0x1808	   0 */		.word	776
/* 0x180c	   0 */		.word	65571
/* 0x1810	   0 */		.word	1
/* 0x1814	   0 */		.word	797
/* 0x1818	   0 */		.align	4
/* 0x1818	   0 */		.word	-1
/* 0x181c	   0 */		.word	-1
/* 0x1820	   0 */		.word	781
/* 0x1824	   0 */		.word	65571
/* 0x1828	   0 */		.word	1
/* 0x182c	   0 */		.word	798
/* 0x1830	   0 */		.align	4
/* 0x1830	   0 */		.word	-1
/* 0x1834	   0 */		.word	-1
/* 0x1838	   0 */		.word	786
/* 0x183c	   0 */		.word	65571
/* 0x1840	   0 */		.word	1
/* 0x1844	   0 */		.word	799
/* 0x1848	   0 */		.align	4
/* 0x1848	   0 */		.word	-1
/* 0x184c	   0 */		.word	-1
/* 0x1850	   0 */		.word	741
/* 0x1854	   0 */		.word	4148
/* 0x1858	   0 */		.word	3
/* 0x185c	   0 */		.word	800
/* 0x1860	   0 */		.align	4
/* 0x1860	   0 */		.word	-1
/* 0x1864	   0 */		.word	-1
/* 0x1868	   0 */		.word	746
/* 0x186c	   0 */		.word	4148
/* 0x1870	   0 */		.word	3
/* 0x1874	   0 */		.word	803
/* 0x1878	   0 */		.align	4
/* 0x1878	   0 */		.word	-1
/* 0x187c	   0 */		.word	-1
/* 0x1880	   0 */		.word	751
/* 0x1884	   0 */		.word	4148
/* 0x1888	   0 */		.word	3
/* 0x188c	   0 */		.word	806
/* 0x1890	   0 */		.align	4
/* 0x1890	   0 */		.word	-1
/* 0x1894	   0 */		.word	-1
/* 0x1898	   0 */		.word	756
/* 0x189c	   0 */		.word	4148
/* 0x18a0	   0 */		.word	3
/* 0x18a4	   0 */		.word	809
/* 0x18a8	   0 */		.align	4
/* 0x18a8	   0 */		.word	-1
/* 0x18ac	   0 */		.word	-1
/* 0x18b0	   0 */		.word	761
/* 0x18b4	   0 */		.word	4148
/* 0x18b8	   0 */		.word	3
/* 0x18bc	   0 */		.word	812
/* 0x18c0	   0 */		.align	4
/* 0x18c0	   0 */		.word	-1
/* 0x18c4	   0 */		.word	-1
/* 0x18c8	   0 */		.word	766
/* 0x18cc	   0 */		.word	4148
/* 0x18d0	   0 */		.word	3
/* 0x18d4	   0 */		.word	815
/* 0x18d8	   0 */		.align	4
/* 0x18d8	   0 */		.word	-1
/* 0x18dc	   0 */		.word	-1
/* 0x18e0	   0 */		.word	771
/* 0x18e4	   0 */		.word	4148
/* 0x18e8	   0 */		.word	3
/* 0x18ec	   0 */		.word	818
/* 0x18f0	   0 */		.align	4
/* 0x18f0	   0 */		.word	-1
/* 0x18f4	   0 */		.word	-1
/* 0x18f8	   0 */		.word	776
/* 0x18fc	   0 */		.word	4148
/* 0x1900	   0 */		.word	3
/* 0x1904	   0 */		.word	821
/* 0x1908	   0 */		.align	4
/* 0x1908	   0 */		.word	-1
/* 0x190c	   0 */		.word	-1
/* 0x1910	   0 */		.word	781
/* 0x1914	   0 */		.word	4148
/* 0x1918	   0 */		.word	3
/* 0x191c	   0 */		.word	824
/* 0x1920	   0 */		.align	4
/* 0x1920	   0 */		.word	-1
/* 0x1924	   0 */		.word	-1
/* 0x1928	   0 */		.word	786
/* 0x192c	   0 */		.word	4148
/* 0x1930	   0 */		.word	3
/* 0x1934	   0 */		.word	827
/* 0x1938	   0 */		.align	4
/* 0x1938	   0 */		.word	-1
/* 0x193c	   0 */		.word	-1
/* 0x1940	   0 */		.word	736
/* 0x1944	   0 */		.word	131075
/* 0x1948	   0 */		.word	1
/* 0x194c	   0 */		.word	830
/* 0x1950	   0 */		.align	4
/* 0x1950	   0 */		.word	-1
/* 0x1954	   0 */		.word	-1
/* 0x1958	   0 */		.word	791
/* 0x195c	   0 */		.word	131075
/* 0x1960	   0 */		.word	1
/* 0x1964	   0 */		.word	831
/* 0x1968	   0 */		.align	4
/* 0x1968	   0 */		.word	-1
/* 0x196c	   0 */		.word	-1
/* 0x1970	   0 */		.word	786
/* 0x1974	   0 */		.word	8218
/* 0x1978	   0 */		.word	2
/* 0x197c	   0 */		.word	832
/* 0x1980	   0 */		.align	4
/* 0x1980	   0 */		.word	-1
/* 0x1984	   0 */		.word	-1
/* 0x1988	   0 */		.word	786
/* 0x198c	   0 */		.word	4122
/* 0x1990	   0 */		.word	2
/* 0x1994	   0 */		.word	834
/* 0x1998	   0 */		.align	4
/* 0x1998	   0 */		.word	-1
/* 0x199c	   0 */		.word	-1
/* 0x19a0	   0 */		.word	786
/* 0x19a4	   0 */		.word	4123
/* 0x19a8	   0 */		.word	7
/* 0x19ac	   0 */		.word	836
/* 0x19b0	   0 */		.align	4
/* 0x19b0	   0 */		.word	-1
/* 0x19b4	   0 */		.word	-1
/* 0x19b8	   0 */		.word	786
/* 0x19bc	   0 */		.word	4145
/* 0x19c0	   0 */		.word	7
/* 0x19c4	   0 */		.word	843
/* 0x19c8	   0 */		.align	4
/* 0x19c8	   0 */		.word	-1
/* 0x19cc	   0 */		.word	-1
/* 0x19d0	   0 */		.word	781
/* 0x19d4	   0 */		.word	8218
/* 0x19d8	   0 */		.word	2
/* 0x19dc	   0 */		.word	850
/* 0x19e0	   0 */		.align	4
/* 0x19e0	   0 */		.word	-1
/* 0x19e4	   0 */		.word	-1
/* 0x19e8	   0 */		.word	781
/* 0x19ec	   0 */		.word	4122
/* 0x19f0	   0 */		.word	2
/* 0x19f4	   0 */		.word	852
/* 0x19f8	   0 */		.align	4
/* 0x19f8	   0 */		.word	-1
/* 0x19fc	   0 */		.word	-1
/* 0x1a00	   0 */		.word	781
/* 0x1a04	   0 */		.word	4123
/* 0x1a08	   0 */		.word	7
/* 0x1a0c	   0 */		.word	854
/* 0x1a10	   0 */		.align	4
/* 0x1a10	   0 */		.word	-1
/* 0x1a14	   0 */		.word	-1
/* 0x1a18	   0 */		.word	781
/* 0x1a1c	   0 */		.word	4145
/* 0x1a20	   0 */		.word	7
/* 0x1a24	   0 */		.word	861
/* 0x1a28	   0 */		.align	4
/* 0x1a28	   0 */		.word	-1
/* 0x1a2c	   0 */		.word	-1
/* 0x1a30	   0 */		.word	776
/* 0x1a34	   0 */		.word	8218
/* 0x1a38	   0 */		.word	2
/* 0x1a3c	   0 */		.word	868
/* 0x1a40	   0 */		.align	4
/* 0x1a40	   0 */		.word	-1
/* 0x1a44	   0 */		.word	-1
/* 0x1a48	   0 */		.word	776
/* 0x1a4c	   0 */		.word	4122
/* 0x1a50	   0 */		.word	2
/* 0x1a54	   0 */		.word	870
/* 0x1a58	   0 */		.align	4
/* 0x1a58	   0 */		.word	-1
/* 0x1a5c	   0 */		.word	-1
/* 0x1a60	   0 */		.word	776
/* 0x1a64	   0 */		.word	4123
/* 0x1a68	   0 */		.word	7
/* 0x1a6c	   0 */		.word	872
/* 0x1a70	   0 */		.align	4
/* 0x1a70	   0 */		.word	-1
/* 0x1a74	   0 */		.word	-1
/* 0x1a78	   0 */		.word	776
/* 0x1a7c	   0 */		.word	4145
/* 0x1a80	   0 */		.word	7
/* 0x1a84	   0 */		.word	879
/* 0x1a88	   0 */		.align	4
/* 0x1a88	   0 */		.word	-1
/* 0x1a8c	   0 */		.word	-1
/* 0x1a90	   0 */		.word	771
/* 0x1a94	   0 */		.word	8218
/* 0x1a98	   0 */		.word	2
/* 0x1a9c	   0 */		.word	886
/* 0x1aa0	   0 */		.align	4
/* 0x1aa0	   0 */		.word	-1
/* 0x1aa4	   0 */		.word	-1
/* 0x1aa8	   0 */		.word	771
/* 0x1aac	   0 */		.word	4122
/* 0x1ab0	   0 */		.word	2
/* 0x1ab4	   0 */		.word	888
/* 0x1ab8	   0 */		.align	4
/* 0x1ab8	   0 */		.word	-1
/* 0x1abc	   0 */		.word	-1
/* 0x1ac0	   0 */		.word	771
/* 0x1ac4	   0 */		.word	4123
/* 0x1ac8	   0 */		.word	7
/* 0x1acc	   0 */		.word	890
/* 0x1ad0	   0 */		.align	4
/* 0x1ad0	   0 */		.word	-1
/* 0x1ad4	   0 */		.word	-1
/* 0x1ad8	   0 */		.word	771
/* 0x1adc	   0 */		.word	4145
/* 0x1ae0	   0 */		.word	7
/* 0x1ae4	   0 */		.word	897
/* 0x1ae8	   0 */		.align	4
/* 0x1ae8	   0 */		.word	-1
/* 0x1aec	   0 */		.word	-1
/* 0x1af0	   0 */		.word	766
/* 0x1af4	   0 */		.word	8218
/* 0x1af8	   0 */		.word	2
/* 0x1afc	   0 */		.word	904
/* 0x1b00	   0 */		.align	4
/* 0x1b00	   0 */		.word	-1
/* 0x1b04	   0 */		.word	-1
/* 0x1b08	   0 */		.word	766
/* 0x1b0c	   0 */		.word	4122
/* 0x1b10	   0 */		.word	2
/* 0x1b14	   0 */		.word	906
/* 0x1b18	   0 */		.align	4
/* 0x1b18	   0 */		.word	-1
/* 0x1b1c	   0 */		.word	-1
/* 0x1b20	   0 */		.word	766
/* 0x1b24	   0 */		.word	4123
/* 0x1b28	   0 */		.word	7
/* 0x1b2c	   0 */		.word	908
/* 0x1b30	   0 */		.align	4
/* 0x1b30	   0 */		.word	-1
/* 0x1b34	   0 */		.word	-1
/* 0x1b38	   0 */		.word	766
/* 0x1b3c	   0 */		.word	4145
/* 0x1b40	   0 */		.word	7
/* 0x1b44	   0 */		.word	915
/* 0x1b48	   0 */		.align	4
/* 0x1b48	   0 */		.word	-1
/* 0x1b4c	   0 */		.word	-1
/* 0x1b50	   0 */		.word	761
/* 0x1b54	   0 */		.word	8218
/* 0x1b58	   0 */		.word	2
/* 0x1b5c	   0 */		.word	922
/* 0x1b60	   0 */		.align	4
/* 0x1b60	   0 */		.word	-1
/* 0x1b64	   0 */		.word	-1
/* 0x1b68	   0 */		.word	761
/* 0x1b6c	   0 */		.word	4122
/* 0x1b70	   0 */		.word	2
/* 0x1b74	   0 */		.word	924
/* 0x1b78	   0 */		.align	4
/* 0x1b78	   0 */		.word	-1
/* 0x1b7c	   0 */		.word	-1
/* 0x1b80	   0 */		.word	761
/* 0x1b84	   0 */		.word	4123
/* 0x1b88	   0 */		.word	7
/* 0x1b8c	   0 */		.word	926
/* 0x1b90	   0 */		.align	4
/* 0x1b90	   0 */		.word	-1
/* 0x1b94	   0 */		.word	-1
/* 0x1b98	   0 */		.word	761
/* 0x1b9c	   0 */		.word	4145
/* 0x1ba0	   0 */		.word	7
/* 0x1ba4	   0 */		.word	933
/* 0x1ba8	   0 */		.align	4
/* 0x1ba8	   0 */		.word	-1
/* 0x1bac	   0 */		.word	-1
/* 0x1bb0	   0 */		.word	756
/* 0x1bb4	   0 */		.word	8218
/* 0x1bb8	   0 */		.word	2
/* 0x1bbc	   0 */		.word	940
/* 0x1bc0	   0 */		.align	4
/* 0x1bc0	   0 */		.word	-1
/* 0x1bc4	   0 */		.word	-1
/* 0x1bc8	   0 */		.word	756
/* 0x1bcc	   0 */		.word	4122
/* 0x1bd0	   0 */		.word	2
/* 0x1bd4	   0 */		.word	942
/* 0x1bd8	   0 */		.align	4
/* 0x1bd8	   0 */		.word	-1
/* 0x1bdc	   0 */		.word	-1
/* 0x1be0	   0 */		.word	756
/* 0x1be4	   0 */		.word	4123
/* 0x1be8	   0 */		.word	7
/* 0x1bec	   0 */		.word	944
/* 0x1bf0	   0 */		.align	4
/* 0x1bf0	   0 */		.word	-1
/* 0x1bf4	   0 */		.word	-1
/* 0x1bf8	   0 */		.word	756
/* 0x1bfc	   0 */		.word	4145
/* 0x1c00	   0 */		.word	7
/* 0x1c04	   0 */		.word	951
/* 0x1c08	   0 */		.align	4
/* 0x1c08	   0 */		.word	-1
/* 0x1c0c	   0 */		.word	-1
/* 0x1c10	   0 */		.word	751
/* 0x1c14	   0 */		.word	8218
/* 0x1c18	   0 */		.word	2
/* 0x1c1c	   0 */		.word	958
/* 0x1c20	   0 */		.align	4
/* 0x1c20	   0 */		.word	-1
/* 0x1c24	   0 */		.word	-1
/* 0x1c28	   0 */		.word	751
/* 0x1c2c	   0 */		.word	4122
/* 0x1c30	   0 */		.word	2
/* 0x1c34	   0 */		.word	960
/* 0x1c38	   0 */		.align	4
/* 0x1c38	   0 */		.word	-1
/* 0x1c3c	   0 */		.word	-1
/* 0x1c40	   0 */		.word	751
/* 0x1c44	   0 */		.word	4123
/* 0x1c48	   0 */		.word	7
/* 0x1c4c	   0 */		.word	962
/* 0x1c50	   0 */		.align	4
/* 0x1c50	   0 */		.word	-1
/* 0x1c54	   0 */		.word	-1
/* 0x1c58	   0 */		.word	751
/* 0x1c5c	   0 */		.word	4145
/* 0x1c60	   0 */		.word	7
/* 0x1c64	   0 */		.word	969
/* 0x1c68	   0 */		.align	4
/* 0x1c68	   0 */		.word	-1
/* 0x1c6c	   0 */		.word	-1
/* 0x1c70	   0 */		.word	746
/* 0x1c74	   0 */		.word	8218
/* 0x1c78	   0 */		.word	2
/* 0x1c7c	   0 */		.word	976
/* 0x1c80	   0 */		.align	4
/* 0x1c80	   0 */		.word	-1
/* 0x1c84	   0 */		.word	-1
/* 0x1c88	   0 */		.word	746
/* 0x1c8c	   0 */		.word	4122
/* 0x1c90	   0 */		.word	2
/* 0x1c94	   0 */		.word	978
/* 0x1c98	   0 */		.align	4
/* 0x1c98	   0 */		.word	-1
/* 0x1c9c	   0 */		.word	-1
/* 0x1ca0	   0 */		.word	746
/* 0x1ca4	   0 */		.word	4123
/* 0x1ca8	   0 */		.word	7
/* 0x1cac	   0 */		.word	980
/* 0x1cb0	   0 */		.align	4
/* 0x1cb0	   0 */		.word	-1
/* 0x1cb4	   0 */		.word	-1
/* 0x1cb8	   0 */		.word	746
/* 0x1cbc	   0 */		.word	4145
/* 0x1cc0	   0 */		.word	7
/* 0x1cc4	   0 */		.word	987
/* 0x1cc8	   0 */		.align	4
/* 0x1cc8	   0 */		.word	-1
/* 0x1ccc	   0 */		.word	-1
/* 0x1cd0	   0 */		.word	741
/* 0x1cd4	   0 */		.word	8218
/* 0x1cd8	   0 */		.word	2
/* 0x1cdc	   0 */		.word	994
/* 0x1ce0	   0 */		.align	4
/* 0x1ce0	   0 */		.word	-1
/* 0x1ce4	   0 */		.word	-1
/* 0x1ce8	   0 */		.word	741
/* 0x1cec	   0 */		.word	4122
/* 0x1cf0	   0 */		.word	2
/* 0x1cf4	   0 */		.word	996
/* 0x1cf8	   0 */		.align	4
/* 0x1cf8	   0 */		.word	-1
/* 0x1cfc	   0 */		.word	-1
/* 0x1d00	   0 */		.word	741
/* 0x1d04	   0 */		.word	4123
/* 0x1d08	   0 */		.word	7
/* 0x1d0c	   0 */		.word	998
/* 0x1d10	   0 */		.align	4
/* 0x1d10	   0 */		.word	-1
/* 0x1d14	   0 */		.word	-1
/* 0x1d18	   0 */		.word	741
/* 0x1d1c	   0 */		.word	4145
/* 0x1d20	   0 */		.word	7
/* 0x1d24	   0 */		.word	1005
/* 0x1d28	   0 */		.align	4
/* 0x1d28	   0 */		.word	-1
/* 0x1d2c	   0 */		.word	-1
/* 0x1d30	   0 */		.word	741
/* 0x1d34	   0 */		.word	8229
/* 0x1d38	   0 */		.word	1
/* 0x1d3c	   0 */		.word	1012
/* 0x1d40	   0 */		.align	4
/* 0x1d40	   0 */		.word	-1
/* 0x1d44	   0 */		.word	-1
/* 0x1d48	   0 */		.word	746
/* 0x1d4c	   0 */		.word	8229
/* 0x1d50	   0 */		.word	1
/* 0x1d54	   0 */		.word	1013
/* 0x1d58	   0 */		.align	4
/* 0x1d58	   0 */		.word	-1
/* 0x1d5c	   0 */		.word	-1
/* 0x1d60	   0 */		.word	751
/* 0x1d64	   0 */		.word	8229
/* 0x1d68	   0 */		.word	1
/* 0x1d6c	   0 */		.word	1014
/* 0x1d70	   0 */		.align	4
/* 0x1d70	   0 */		.word	-1
/* 0x1d74	   0 */		.word	-1
/* 0x1d78	   0 */		.word	756
/* 0x1d7c	   0 */		.word	8229
/* 0x1d80	   0 */		.word	1
/* 0x1d84	   0 */		.word	1015
/* 0x1d88	   0 */		.align	4
/* 0x1d88	   0 */		.word	-1
/* 0x1d8c	   0 */		.word	-1
/* 0x1d90	   0 */		.word	761
/* 0x1d94	   0 */		.word	8229
/* 0x1d98	   0 */		.word	1
/* 0x1d9c	   0 */		.word	1016
/* 0x1da0	   0 */		.align	4
/* 0x1da0	   0 */		.word	-1
/* 0x1da4	   0 */		.word	-1
/* 0x1da8	   0 */		.word	766
/* 0x1dac	   0 */		.word	8229
/* 0x1db0	   0 */		.word	1
/* 0x1db4	   0 */		.word	1017
/* 0x1db8	   0 */		.align	4
/* 0x1db8	   0 */		.word	-1
/* 0x1dbc	   0 */		.word	-1
/* 0x1dc0	   0 */		.word	771
/* 0x1dc4	   0 */		.word	8229
/* 0x1dc8	   0 */		.word	1
/* 0x1dcc	   0 */		.word	1018
/* 0x1dd0	   0 */		.align	4
/* 0x1dd0	   0 */		.word	-1
/* 0x1dd4	   0 */		.word	-1
/* 0x1dd8	   0 */		.word	776
/* 0x1ddc	   0 */		.word	8229
/* 0x1de0	   0 */		.word	1
/* 0x1de4	   0 */		.word	1019
/* 0x1de8	   0 */		.align	4
/* 0x1de8	   0 */		.word	-1
/* 0x1dec	   0 */		.word	-1
/* 0x1df0	   0 */		.word	781
/* 0x1df4	   0 */		.word	8229
/* 0x1df8	   0 */		.word	1
/* 0x1dfc	   0 */		.word	1020
/* 0x1e00	   0 */		.align	4
/* 0x1e00	   0 */		.word	-1
/* 0x1e04	   0 */		.word	-1
/* 0x1e08	   0 */		.word	786
/* 0x1e0c	   0 */		.word	8229
/* 0x1e10	   0 */		.word	1
/* 0x1e14	   0 */		.word	1021
/* 0x1e18	   0 */		.align	4
/* 0x1e18	   0 */		.word	-1
/* 0x1e1c	   0 */		.word	-1
/* 0x1e20	   0 */		.word	809
/* 0x1e24	   0 */		.word	16414
/* 0x1e28	   0 */		.word	1
/* 0x1e2c	   0 */		.word	1022
/* 0x1e30	   0 */		.align	4
/* 0x1e30	   0 */		.word	-1
/* 0x1e34	   0 */		.word	-1
/* 0x1e38	   0 */		.word	857
/* 0x1e3c	   0 */		.word	16414
/* 0x1e40	   0 */		.word	1
/* 0x1e44	   0 */		.word	1023
/* 0x1e48	   0 */		.align	4
/* 0x1e48	   0 */		.word	-1
/* 0x1e4c	   0 */		.word	-1
/* 0x1e50	   0 */		.word	860
/* 0x1e54	   0 */		.word	16409
/* 0x1e58	   0 */		.word	3
/* 0x1e5c	   0 */		.word	1024
/* 0x1e60	   0 */		.align	4
/* 0x1e60	   0 */		.word	-1
/* 0x1e64	   0 */		.word	-1
/* 0x1e68	   0 */		.word	809
/* 0x1e6c	   0 */		.word	131075
/* 0x1e70	   0 */		.word	1
/* 0x1e74	   0 */		.word	1027
/* 0x1e78	   0 */		.align	4
/* 0x1e78	   0 */		.word	-1
/* 0x1e7c	   0 */		.word	-1
/* 0x1e80	   0 */		.word	857
/* 0x1e84	   0 */		.word	131075
/* 0x1e88	   0 */		.word	1
/* 0x1e8c	   0 */		.word	1028
/* 0x1e90	   0 */		.align	4
/* 0x1e90	   0 */		.word	-1
/* 0x1e94	   0 */		.word	-1
/* 0x1e98	   0 */		.word	887
/* 0x1e9c	   0 */		.word	16414
/* 0x1ea0	   0 */		.word	1
/* 0x1ea4	   0 */		.word	1029
/* 0x1ea8	   0 */		.align	4
/* 0x1ea8	   0 */		.word	-1
/* 0x1eac	   0 */		.word	-1
/* 0x1eb0	   0 */		.word	889
/* 0x1eb4	   0 */		.word	16414
/* 0x1eb8	   0 */		.word	1
/* 0x1ebc	   0 */		.word	1030
/* 0x1ec0	   0 */		.align	4
/* 0x1ec0	   0 */		.word	-1
/* 0x1ec4	   0 */		.word	-1
/* 0x1ec8	   0 */		.word	893
/* 0x1ecc	   0 */		.word	16414
/* 0x1ed0	   0 */		.word	1
/* 0x1ed4	   0 */		.word	1031
/* 0x1ed8	   0 */		.align	4
/* 0x1ed8	   0 */		.word	-1
/* 0x1edc	   0 */		.word	-1
/* 0x1ee0	   0 */		.word	895
/* 0x1ee4	   0 */		.word	16414
/* 0x1ee8	   0 */		.word	1
/* 0x1eec	   0 */		.word	1032
/* 0x1ef0	   0 */		.align	4
/* 0x1ef0	   0 */		.word	-1
/* 0x1ef4	   0 */		.word	-1
/* 0x1ef8	   0 */		.word	917
/* 0x1efc	   0 */		.word	16414
/* 0x1f00	   0 */		.word	1
/* 0x1f04	   0 */		.word	1033
/* 0x1f08	   0 */		.align	4
/* 0x1f08	   0 */		.word	-1
/* 0x1f0c	   0 */		.word	-1
/* 0x1f10	   0 */		.word	928
/* 0x1f14	   0 */		.word	16414
/* 0x1f18	   0 */		.word	1
/* 0x1f1c	   0 */		.word	1034
/* 0x1f20	   0 */		.align	4
/* 0x1f20	   0 */		.word	-1
/* 0x1f24	   0 */		.word	-1
/* 0x1f28	   0 */		.word	951
/* 0x1f2c	   0 */		.word	16414
/* 0x1f30	   0 */		.word	1
/* 0x1f34	   0 */		.word	1035
/* 0x1f38	   0 */		.align	4
/* 0x1f38	   0 */		.word	-1
/* 0x1f3c	   0 */		.word	-1
/* 0x1f40	   0 */		.word	963
/* 0x1f44	   0 */		.word	16414
/* 0x1f48	   0 */		.word	1
/* 0x1f4c	   0 */		.word	1036
/* 0x1f50	   0 */		.align	4
/* 0x1f50	   0 */		.word	-1
/* 0x1f54	   0 */		.word	-1
/* 0x1f58	   0 */		.word	966
/* 0x1f5c	   0 */		.word	16414
/* 0x1f60	   0 */		.word	1
/* 0x1f64	   0 */		.word	1037
/* 0x1f68	   0 */		.align	4
/* 0x1f68	   0 */		.word	-1
/* 0x1f6c	   0 */		.word	-1
/* 0x1f70	   0 */		.word	915
/* 0x1f74	   0 */		.word	65571
/* 0x1f78	   0 */		.word	1
/* 0x1f7c	   0 */		.word	1038
/* 0x1f80	   0 */		.align	4
/* 0x1f80	   0 */		.word	-1
/* 0x1f84	   0 */		.word	-1
/* 0x1f88	   0 */		.word	949
/* 0x1f8c	   0 */		.word	65571
/* 0x1f90	   0 */		.word	1
/* 0x1f94	   0 */		.word	1039
/* 0x1f98	   0 */		.align	4
/* 0x1f98	   0 */		.word	-1
/* 0x1f9c	   0 */		.word	-1
/* 0x1fa0	   0 */		.word	956
/* 0x1fa4	   0 */		.word	131089
/* 0x1fa8	   0 */		.word	4
/* 0x1fac	   0 */		.word	1040
/* 0x1fb0	   0 */		.align	4
/* 0x1fb0	   0 */		.word	-1
/* 0x1fb4	   0 */		.word	-1
/* 0x1fb8	   0 */		.word	922
/* 0x1fbc	   0 */		.word	131089
/* 0x1fc0	   0 */		.word	4
/* 0x1fc4	   0 */		.word	1044
/* 0x1fc8	   0 */		.align	4
/* 0x1fc8	   0 */		.word	-1
/* 0x1fcc	   0 */		.word	-1
/* 0x1fd0	   0 */		.word	922
/* 0x1fd4	   0 */		.word	8218
/* 0x1fd8	   0 */		.word	2
/* 0x1fdc	   0 */		.word	1048
/* 0x1fe0	   0 */		.align	4
/* 0x1fe0	   0 */		.word	-1
/* 0x1fe4	   0 */		.word	-1
/* 0x1fe8	   0 */		.word	922
/* 0x1fec	   0 */		.word	4122
/* 0x1ff0	   0 */		.word	2
/* 0x1ff4	   0 */		.word	1050
/* 0x1ff8	   0 */		.align	4
/* 0x1ff8	   0 */		.word	-1
/* 0x1ffc	   0 */		.word	-1
/* 0x2000	   0 */		.word	922
/* 0x2004	   0 */		.word	4123
/* 0x2008	   0 */		.word	7
/* 0x200c	   0 */		.word	1052
/* 0x2010	   0 */		.align	4
/* 0x2010	   0 */		.word	-1
/* 0x2014	   0 */		.word	-1
/* 0x2018	   0 */		.word	922
/* 0x201c	   0 */		.word	4145
/* 0x2020	   0 */		.word	7
/* 0x2024	   0 */		.word	1059
/* 0x2028	   0 */		.align	4
/* 0x2028	   0 */		.word	-1
/* 0x202c	   0 */		.word	-1
/* 0x2030	   0 */		.word	922
/* 0x2034	   0 */		.word	8218
/* 0x2038	   0 */		.word	2
/* 0x203c	   0 */		.word	1066
/* 0x2040	   0 */		.align	4
/* 0x2040	   0 */		.word	-1
/* 0x2044	   0 */		.word	-1
/* 0x2048	   0 */		.word	922
/* 0x204c	   0 */		.word	4122
/* 0x2050	   0 */		.word	2
/* 0x2054	   0 */		.word	1068
/* 0x2058	   0 */		.align	4
/* 0x2058	   0 */		.word	-1
/* 0x205c	   0 */		.word	-1
/* 0x2060	   0 */		.word	922
/* 0x2064	   0 */		.word	4123
/* 0x2068	   0 */		.word	7
/* 0x206c	   0 */		.word	1070
/* 0x2070	   0 */		.align	4
/* 0x2070	   0 */		.word	-1
/* 0x2074	   0 */		.word	-1
/* 0x2078	   0 */		.word	922
/* 0x207c	   0 */		.word	4145
/* 0x2080	   0 */		.word	7
/* 0x2084	   0 */		.word	1077
/* 0x2088	   0 */		.align	4
/* 0x2088	   0 */		.word	-1
/* 0x208c	   0 */		.word	-1
/* 0x2090	   0 */		.word	956
/* 0x2094	   0 */		.word	8218
/* 0x2098	   0 */		.word	2
/* 0x209c	   0 */		.word	1084
/* 0x20a0	   0 */		.align	4
/* 0x20a0	   0 */		.word	-1
/* 0x20a4	   0 */		.word	-1
/* 0x20a8	   0 */		.word	956
/* 0x20ac	   0 */		.word	4122
/* 0x20b0	   0 */		.word	2
/* 0x20b4	   0 */		.word	1086
/* 0x20b8	   0 */		.align	4
/* 0x20b8	   0 */		.word	-1
/* 0x20bc	   0 */		.word	-1
/* 0x20c0	   0 */		.word	956
/* 0x20c4	   0 */		.word	4123
/* 0x20c8	   0 */		.word	7
/* 0x20cc	   0 */		.word	1088
/* 0x20d0	   0 */		.align	4
/* 0x20d0	   0 */		.word	-1
/* 0x20d4	   0 */		.word	-1
/* 0x20d8	   0 */		.word	956
/* 0x20dc	   0 */		.word	4145
/* 0x20e0	   0 */		.word	7
/* 0x20e4	   0 */		.word	1095
/* 0x20e8	   0 */		.align	4
/* 0x20e8	   0 */		.word	-1
/* 0x20ec	   0 */		.word	-1
/* 0x20f0	   0 */		.word	956
/* 0x20f4	   0 */		.word	8218
/* 0x20f8	   0 */		.word	2
/* 0x20fc	   0 */		.word	1102
/* 0x2100	   0 */		.align	4
/* 0x2100	   0 */		.word	-1
/* 0x2104	   0 */		.word	-1
/* 0x2108	   0 */		.word	956
/* 0x210c	   0 */		.word	4122
/* 0x2110	   0 */		.word	2
/* 0x2114	   0 */		.word	1104
/* 0x2118	   0 */		.align	4
/* 0x2118	   0 */		.word	-1
/* 0x211c	   0 */		.word	-1
/* 0x2120	   0 */		.word	956
/* 0x2124	   0 */		.word	4123
/* 0x2128	   0 */		.word	7
/* 0x212c	   0 */		.word	1106
/* 0x2130	   0 */		.align	4
/* 0x2130	   0 */		.word	-1
/* 0x2134	   0 */		.word	-1
/* 0x2138	   0 */		.word	956
/* 0x213c	   0 */		.word	4145
/* 0x2140	   0 */		.word	7
/* 0x2144	   0 */		.word	1113
/* 0x2148	   0 */		.word	8
/* 0x214c	   0 */		.word	17
/* 0x2150	   0 */		.word	0
/* 0x2154	   0 */		.word	0
/* 0x2158	   0 */		.word	8
/* 0x215c	   0 */		.word	41
/* 0x2160	   0 */		.word	61
/* 0x2164	   0 */		.word	64
/* 0x2168	   0 */		.word	67
/* 0x216c	   0 */		.word	61
/* 0x2170	   0 */		.word	70
/* 0x2174	   0 */		.word	99
/* 0x2178	   0 */		.word	99
/* 0x217c	   0 */		.word	10
/* 0x2180	   0 */		.word	99
/* 0x2184	   0 */		.word	4
/* 0x2188	   0 */		.word	99
/* 0x218c	   0 */		.word	0
/* 0x2190	   0 */		.word	0
/* 0x2194	   0 */		.word	5
/* 0x2198	   0 */		.word	0
/* 0x219c	   0 */		.word	0
/* 0x21a0	   0 */		.word	0
/* 0x21a4	   0 */		.word	99
/* 0x21a8	   0 */		.word	5
/* 0x21ac	   0 */		.word	5
/* 0x21b0	   0 */		.word	12
/* 0x21b4	   0 */		.word	0
/* 0x21b8	   0 */		.word	0
/* 0x21bc	   0 */		.word	0
/* 0x21c0	   0 */		.word	67
/* 0x21c4	   0 */		.word	61
/* 0x21c8	   0 */		.word	15
/* 0x21cc	   0 */		.word	61
/* 0x21d0	   0 */		.word	4
/* 0x21d4	   0 */		.word	61
/* 0x21d8	   0 */		.word	0
/* 0x21dc	   0 */		.word	0
/* 0x21e0	   0 */		.word	5
/* 0x21e4	   0 */		.word	0
/* 0x21e8	   0 */		.word	0
/* 0x21ec	   0 */		.word	0
/* 0x21f0	   0 */		.word	61
/* 0x21f4	   0 */		.word	5
/* 0x21f8	   0 */		.word	5
/* 0x21fc	   0 */		.word	12
/* 0x2200	   0 */		.word	0
/* 0x2204	   0 */		.word	0
/* 0x2208	   0 */		.word	0
/* 0x220c	   0 */		.word	64
/* 0x2210	   0 */		.word	18
/* 0x2214	   0 */		.word	64
/* 0x2218	   0 */		.word	2
/* 0x221c	   0 */		.word	64
/* 0x2220	   0 */		.word	0
/* 0x2224	   0 */		.word	1
/* 0x2228	   0 */		.word	0
/* 0x222c	   0 */		.word	3
/* 0x2230	   0 */		.word	1
/* 0x2234	   0 */		.word	0
/* 0x2238	   0 */		.word	64
/* 0x223c	   0 */		.word	6
/* 0x2240	   0 */		.word	5
/* 0x2244	   0 */		.word	8
/* 0x2248	   0 */		.word	0
/* 0x224c	   0 */		.word	0
/* 0x2250	   0 */		.word	2
/* 0x2254	   0 */		.word	103
/* 0x2258	   0 */		.word	123
/* 0x225c	   0 */		.word	126
/* 0x2260	   0 */		.word	129
/* 0x2264	   0 */		.word	123
/* 0x2268	   0 */		.word	70
/* 0x226c	   0 */		.word	132
/* 0x2270	   0 */		.word	123
/* 0x2274	   0 */		.word	6
/* 0x2278	   0 */		.word	123
/* 0x227c	   0 */		.word	4
/* 0x2280	   0 */		.word	123
/* 0x2284	   0 */		.word	0
/* 0x2288	   0 */		.word	0
/* 0x228c	   0 */		.word	2
/* 0x2290	   0 */		.word	0
/* 0x2294	   0 */		.word	0
/* 0x2298	   0 */		.word	0
/* 0x229c	   0 */		.word	123
/* 0x22a0	   0 */		.word	2
/* 0x22a4	   0 */		.word	2
/* 0x22a8	   0 */		.word	7
/* 0x22ac	   0 */		.word	0
/* 0x22b0	   0 */		.word	0
/* 0x22b4	   0 */		.word	0
/* 0x22b8	   0 */		.word	129
/* 0x22bc	   0 */		.word	126
/* 0x22c0	   0 */		.word	10
/* 0x22c4	   0 */		.word	126
/* 0x22c8	   0 */		.word	2
/* 0x22cc	   0 */		.word	126
/* 0x22d0	   0 */		.word	0
/* 0x22d4	   0 */		.word	1
/* 0x22d8	   0 */		.word	0
/* 0x22dc	   0 */		.word	3
/* 0x22e0	   0 */		.word	1
/* 0x22e4	   0 */		.word	0
/* 0x22e8	   0 */		.word	126
/* 0x22ec	   0 */		.word	3
/* 0x22f0	   0 */		.word	2
/* 0x22f4	   0 */		.word	5
/* 0x22f8	   0 */		.word	0
/* 0x22fc	   0 */		.word	0
/* 0x2300	   0 */		.word	3
/* 0x2304	   0 */		.word	132
/* 0x2308	   0 */		.word	4
/* 0x230c	   0 */		.word	132
/* 0x2310	   0 */		.word	4
/* 0x2314	   0 */		.word	132
/* 0x2318	   0 */		.word	0
/* 0x231c	   0 */		.word	0
/* 0x2320	   0 */		.word	2
/* 0x2324	   0 */		.word	0
/* 0x2328	   0 */		.word	0
/* 0x232c	   0 */		.word	0
/* 0x2330	   0 */		.word	132
/* 0x2334	   0 */		.word	2
/* 0x2338	   0 */		.word	2
/* 0x233c	   0 */		.word	7
/* 0x2340	   0 */		.word	0
/* 0x2344	   0 */		.word	0
/* 0x2348	   0 */		.word	0
/* 0x234c	   0 */		.word	136
/* 0x2350	   0 */		.word	158
/* 0x2354	   0 */		.word	161
/* 0x2358	   0 */		.word	164
/* 0x235c	   0 */		.word	158
/* 0x2360	   0 */		.word	70
/* 0x2364	   0 */		.word	167
/* 0x2368	   0 */		.word	158
/* 0x236c	   0 */		.word	3
/* 0x2370	   0 */		.word	158
/* 0x2374	   0 */		.word	4
/* 0x2378	   0 */		.word	158
/* 0x237c	   0 */		.word	0
/* 0x2380	   0 */		.word	0
/* 0x2384	   0 */		.word	1
/* 0x2388	   0 */		.word	0
/* 0x238c	   0 */		.word	0
/* 0x2390	   0 */		.word	0
/* 0x2394	   0 */		.word	158
/* 0x2398	   0 */		.word	1
/* 0x239c	   0 */		.word	1
/* 0x23a0	   0 */		.word	4
/* 0x23a4	   0 */		.word	0
/* 0x23a8	   0 */		.word	0
/* 0x23ac	   0 */		.word	0
/* 0x23b0	   0 */		.word	164
/* 0x23b4	   0 */		.word	161
/* 0x23b8	   0 */		.word	8
/* 0x23bc	   0 */		.word	161
/* 0x23c0	   0 */		.word	2
/* 0x23c4	   0 */		.word	161
/* 0x23c8	   0 */		.word	0
/* 0x23cc	   0 */		.word	1
/* 0x23d0	   0 */		.word	0
/* 0x23d4	   0 */		.word	3
/* 0x23d8	   0 */		.word	1
/* 0x23dc	   0 */		.word	0
/* 0x23e0	   0 */		.word	161
/* 0x23e4	   0 */		.word	2
/* 0x23e8	   0 */		.word	1
/* 0x23ec	   0 */		.word	4
/* 0x23f0	   0 */		.word	0
/* 0x23f4	   0 */		.word	0
/* 0x23f8	   0 */		.word	1
/* 0x23fc	   0 */		.word	167
/* 0x2400	   0 */		.word	2
/* 0x2404	   0 */		.word	167
/* 0x2408	   0 */		.word	4
/* 0x240c	   0 */		.word	167
/* 0x2410	   0 */		.word	0
/* 0x2414	   0 */		.word	0
/* 0x2418	   0 */		.word	1
/* 0x241c	   0 */		.word	0
/* 0x2420	   0 */		.word	0
/* 0x2424	   0 */		.word	0
/* 0x2428	   0 */		.word	167
/* 0x242c	   0 */		.word	1
/* 0x2430	   0 */		.word	1
/* 0x2434	   0 */		.word	4
/* 0x2438	   0 */		.word	0
/* 0x243c	   0 */		.word	0
/* 0x2440	   0 */		.word	0
/* 0x2444	   0 */		.word	8
/* 0x2448	   0 */		.word	8
/* 0x244c	   0 */		.word	8
/* 0x2450	   0 */		.word	8
/* 0x2454	   0 */		.word	8
/* 0x2458	   0 */		.word	8
/* 0x245c	   0 */		.word	8
/* 0x2460	   0 */		.word	8
/* 0x2464	   0 */		.word	8
/* 0x2468	   0 */		.word	8
/* 0x246c	   0 */		.word	17
/* 0x2470	   0 */		.word	0
/* 0x2474	   0 */		.word	0
/* 0x2478	   0 */		.word	8
/* 0x247c	   0 */		.word	8
/* 0x2480	   0 */		.word	8
/* 0x2484	   0 */		.word	8
/* 0x2488	   0 */		.word	8
/* 0x248c	   0 */		.word	171
/* 0x2490	   0 */		.word	175
/* 0x2494	   0 */		.word	179
/* 0x2498	   0 */		.word	183
/* 0x249c	   0 */		.word	187
/* 0x24a0	   0 */		.word	191
/* 0x24a4	   0 */		.word	195
/* 0x24a8	   0 */		.word	199
/* 0x24ac	   0 */		.word	203
/* 0x24b0	   0 */		.word	207
/* 0x24b4	   0 */		.word	211
/* 0x24b8	   0 */		.word	175
/* 0x24bc	   0 */		.word	215
/* 0x24c0	   0 */		.word	237
/* 0x24c4	   0 */		.word	179
/* 0x24c8	   0 */		.word	215
/* 0x24cc	   0 */		.word	241
/* 0x24d0	   0 */		.word	183
/* 0x24d4	   0 */		.word	70
/* 0x24d8	   0 */		.word	245
/* 0x24dc	   0 */		.word	187
/* 0x24e0	   0 */		.word	70
/* 0x24e4	   0 */		.word	249
/* 0x24e8	   0 */		.word	191
/* 0x24ec	   0 */		.word	70
/* 0x24f0	   0 */		.word	253
/* 0x24f4	   0 */		.word	195
/* 0x24f8	   0 */		.word	70
/* 0x24fc	   0 */		.word	257
/* 0x2500	   0 */		.word	199
/* 0x2504	   0 */		.word	70
/* 0x2508	   0 */		.word	261
/* 0x250c	   0 */		.word	203
/* 0x2510	   0 */		.word	70
/* 0x2514	   0 */		.word	265
/* 0x2518	   0 */		.word	207
/* 0x251c	   0 */		.word	70
/* 0x2520	   0 */		.word	269
/* 0x2524	   0 */		.word	211
/* 0x2528	   0 */		.word	70
/* 0x252c	   0 */		.word	273
/* 0x2530	   0 */		.word	8
/* 0x2534	   0 */		.word	8
/* 0x2538	   0 */		.word	8
/* 0x253c	   0 */		.word	8
/* 0x2540	   0 */		.word	241
/* 0x2544	   0 */		.word	2
/* 0x2548	   0 */		.word	241
/* 0x254c	   0 */		.word	8
/* 0x2550	   0 */		.word	241
/* 0x2554	   0 */		.word	1
/* 0x2558	   0 */		.word	1
/* 0x255c	   0 */		.word	2
/* 0x2560	   0 */		.word	1
/* 0x2564	   0 */		.word	0
/* 0x2568	   0 */		.word	0
/* 0x256c	   0 */		.word	241
/* 0x2570	   0 */		.word	0
/* 0x2574	   0 */		.word	0
/* 0x2578	   0 */		.word	4
/* 0x257c	   0 */		.word	0
/* 0x2580	   0 */		.word	0
/* 0x2584	   0 */		.word	0
/* 0x2588	   0 */		.word	237
/* 0x258c	   0 */		.word	2
/* 0x2590	   0 */		.word	237
/* 0x2594	   0 */		.word	8
/* 0x2598	   0 */		.word	237
/* 0x259c	   0 */		.word	1
/* 0x25a0	   0 */		.word	1
/* 0x25a4	   0 */		.word	2
/* 0x25a8	   0 */		.word	1
/* 0x25ac	   0 */		.word	0
/* 0x25b0	   0 */		.word	0
/* 0x25b4	   0 */		.word	237
/* 0x25b8	   0 */		.word	0
/* 0x25bc	   0 */		.word	0
/* 0x25c0	   0 */		.word	4
/* 0x25c4	   0 */		.word	0
/* 0x25c8	   0 */		.word	0
/* 0x25cc	   0 */		.word	0
/* 0x25d0	   0 */		.word	175
/* 0x25d4	   0 */		.word	179
/* 0x25d8	   0 */		.word	8
/* 0x25dc	   0 */		.word	8
/* 0x25e0	   0 */		.word	277
/* 0x25e4	   0 */		.word	281
/* 0x25e8	   0 */		.word	277
/* 0x25ec	   0 */		.word	215
/* 0x25f0	   0 */		.word	285
/* 0x25f4	   0 */		.word	281
/* 0x25f8	   0 */		.word	215
/* 0x25fc	   0 */		.word	289
/* 0x2600	   0 */		.word	8
/* 0x2604	   0 */		.word	293
/* 0x2608	   0 */		.word	293
/* 0x260c	   0 */		.word	293
/* 0x2610	   0 */		.word	293
/* 0x2614	   0 */		.word	293
/* 0x2618	   0 */		.word	293
/* 0x261c	   0 */		.word	293
/* 0x2620	   0 */		.word	293
/* 0x2624	   0 */		.word	8
/* 0x2628	   0 */		.word	293
/* 0x262c	   0 */		.word	2
/* 0x2630	   0 */		.word	300
/* 0x2634	   0 */		.word	305
/* 0x2638	   0 */		.word	293
/* 0x263c	   0 */		.word	2
/* 0x2640	   0 */		.word	310
/* 0x2644	   0 */		.word	315
/* 0x2648	   0 */		.word	293
/* 0x264c	   0 */		.word	2
/* 0x2650	   0 */		.word	320
/* 0x2654	   0 */		.word	325
/* 0x2658	   0 */		.word	293
/* 0x265c	   0 */		.word	2
/* 0x2660	   0 */		.word	330
/* 0x2664	   0 */		.word	335
/* 0x2668	   0 */		.word	293
/* 0x266c	   0 */		.word	2
/* 0x2670	   0 */		.word	340
/* 0x2674	   0 */		.word	345
/* 0x2678	   0 */		.word	293
/* 0x267c	   0 */		.word	2
/* 0x2680	   0 */		.word	350
/* 0x2684	   0 */		.word	355
/* 0x2688	   0 */		.word	293
/* 0x268c	   0 */		.word	2
/* 0x2690	   0 */		.word	360
/* 0x2694	   0 */		.word	365
/* 0x2698	   0 */		.word	293
/* 0x269c	   0 */		.word	2
/* 0x26a0	   0 */		.word	370
/* 0x26a4	   0 */		.word	375
/* 0x26a8	   0 */		.word	300
/* 0x26ac	   0 */		.word	6
/* 0x26b0	   0 */		.word	300
/* 0x26b4	   0 */		.word	1
/* 0x26b8	   0 */		.word	300
/* 0x26bc	   0 */		.word	0
/* 0x26c0	   0 */		.word	0
/* 0x26c4	   0 */		.word	0
/* 0x26c8	   0 */		.word	0
/* 0x26cc	   0 */		.word	0
/* 0x26d0	   0 */		.word	0
/* 0x26d4	   0 */		.word	300
/* 0x26d8	   0 */		.word	2
/* 0x26dc	   0 */		.word	2
/* 0x26e0	   0 */		.word	4
/* 0x26e4	   0 */		.word	0
/* 0x26e8	   0 */		.word	0
/* 0x26ec	   0 */		.word	0
/* 0x26f0	   0 */		.word	310
/* 0x26f4	   0 */		.word	6
/* 0x26f8	   0 */		.word	310
/* 0x26fc	   0 */		.word	1
/* 0x2700	   0 */		.word	310
/* 0x2704	   0 */		.word	0
/* 0x2708	   0 */		.word	0
/* 0x270c	   0 */		.word	0
/* 0x2710	   0 */		.word	0
/* 0x2714	   0 */		.word	0
/* 0x2718	   0 */		.word	0
/* 0x271c	   0 */		.word	310
/* 0x2720	   0 */		.word	2
/* 0x2724	   0 */		.word	2
/* 0x2728	   0 */		.word	4
/* 0x272c	   0 */		.word	0
/* 0x2730	   0 */		.word	0
/* 0x2734	   0 */		.word	0
/* 0x2738	   0 */		.word	320
/* 0x273c	   0 */		.word	6
/* 0x2740	   0 */		.word	320
/* 0x2744	   0 */		.word	1
/* 0x2748	   0 */		.word	320
/* 0x274c	   0 */		.word	0
/* 0x2750	   0 */		.word	0
/* 0x2754	   0 */		.word	0
/* 0x2758	   0 */		.word	0
/* 0x275c	   0 */		.word	0
/* 0x2760	   0 */		.word	0
/* 0x2764	   0 */		.word	320
/* 0x2768	   0 */		.word	2
/* 0x276c	   0 */		.word	2
/* 0x2770	   0 */		.word	4
/* 0x2774	   0 */		.word	0
/* 0x2778	   0 */		.word	0
/* 0x277c	   0 */		.word	0
/* 0x2780	   0 */		.word	330
/* 0x2784	   0 */		.word	6
/* 0x2788	   0 */		.word	330
/* 0x278c	   0 */		.word	1
/* 0x2790	   0 */		.word	330
/* 0x2794	   0 */		.word	0
/* 0x2798	   0 */		.word	0
/* 0x279c	   0 */		.word	0
/* 0x27a0	   0 */		.word	0
/* 0x27a4	   0 */		.word	0
/* 0x27a8	   0 */		.word	0
/* 0x27ac	   0 */		.word	330
/* 0x27b0	   0 */		.word	2
/* 0x27b4	   0 */		.word	2
/* 0x27b8	   0 */		.word	4
/* 0x27bc	   0 */		.word	0
/* 0x27c0	   0 */		.word	0
/* 0x27c4	   0 */		.word	0
/* 0x27c8	   0 */		.word	340
/* 0x27cc	   0 */		.word	6
/* 0x27d0	   0 */		.word	340
/* 0x27d4	   0 */		.word	1
/* 0x27d8	   0 */		.word	340
/* 0x27dc	   0 */		.word	0
/* 0x27e0	   0 */		.word	0
/* 0x27e4	   0 */		.word	0
/* 0x27e8	   0 */		.word	0
/* 0x27ec	   0 */		.word	0
/* 0x27f0	   0 */		.word	0
/* 0x27f4	   0 */		.word	340
/* 0x27f8	   0 */		.word	2
/* 0x27fc	   0 */		.word	2
/* 0x2800	   0 */		.word	4
/* 0x2804	   0 */		.word	0
/* 0x2808	   0 */		.word	0
/* 0x280c	   0 */		.word	0
/* 0x2810	   0 */		.word	350
/* 0x2814	   0 */		.word	6
/* 0x2818	   0 */		.word	350
/* 0x281c	   0 */		.word	1
/* 0x2820	   0 */		.word	350
/* 0x2824	   0 */		.word	0
/* 0x2828	   0 */		.word	0
/* 0x282c	   0 */		.word	0
/* 0x2830	   0 */		.word	0
/* 0x2834	   0 */		.word	0
/* 0x2838	   0 */		.word	0
/* 0x283c	   0 */		.word	350
/* 0x2840	   0 */		.word	2
/* 0x2844	   0 */		.word	2
/* 0x2848	   0 */		.word	4
/* 0x284c	   0 */		.word	0
/* 0x2850	   0 */		.word	0
/* 0x2854	   0 */		.word	0
/* 0x2858	   0 */		.word	360
/* 0x285c	   0 */		.word	6
/* 0x2860	   0 */		.word	360
/* 0x2864	   0 */		.word	1
/* 0x2868	   0 */		.word	360
/* 0x286c	   0 */		.word	0
/* 0x2870	   0 */		.word	0
/* 0x2874	   0 */		.word	0
/* 0x2878	   0 */		.word	0
/* 0x287c	   0 */		.word	0
/* 0x2880	   0 */		.word	0
/* 0x2884	   0 */		.word	360
/* 0x2888	   0 */		.word	2
/* 0x288c	   0 */		.word	2
/* 0x2890	   0 */		.word	4
/* 0x2894	   0 */		.word	0
/* 0x2898	   0 */		.word	0
/* 0x289c	   0 */		.word	0
/* 0x28a0	   0 */		.word	370
/* 0x28a4	   0 */		.word	6
/* 0x28a8	   0 */		.word	370
/* 0x28ac	   0 */		.word	1
/* 0x28b0	   0 */		.word	370
/* 0x28b4	   0 */		.word	0
/* 0x28b8	   0 */		.word	0
/* 0x28bc	   0 */		.word	0
/* 0x28c0	   0 */		.word	0
/* 0x28c4	   0 */		.word	0
/* 0x28c8	   0 */		.word	0
/* 0x28cc	   0 */		.word	370
/* 0x28d0	   0 */		.word	2
/* 0x28d4	   0 */		.word	2
/* 0x28d8	   0 */		.word	4
/* 0x28dc	   0 */		.word	0
/* 0x28e0	   0 */		.word	0
/* 0x28e4	   0 */		.word	0
/* 0x28e8	   0 */		.word	289
/* 0x28ec	   0 */		.word	2
/* 0x28f0	   0 */		.word	289
/* 0x28f4	   0 */		.word	8
/* 0x28f8	   0 */		.word	289
/* 0x28fc	   0 */		.word	1
/* 0x2900	   0 */		.word	1
/* 0x2904	   0 */		.word	2
/* 0x2908	   0 */		.word	1
/* 0x290c	   0 */		.word	0
/* 0x2910	   0 */		.word	0
/* 0x2914	   0 */		.word	289
/* 0x2918	   0 */		.word	0
/* 0x291c	   0 */		.word	0
/* 0x2920	   0 */		.word	4
/* 0x2924	   0 */		.word	0
/* 0x2928	   0 */		.word	0
/* 0x292c	   0 */		.word	0
/* 0x2930	   0 */		.word	285
/* 0x2934	   0 */		.word	2
/* 0x2938	   0 */		.word	285
/* 0x293c	   0 */		.word	8
/* 0x2940	   0 */		.word	285
/* 0x2944	   0 */		.word	1
/* 0x2948	   0 */		.word	1
/* 0x294c	   0 */		.word	2
/* 0x2950	   0 */		.word	1
/* 0x2954	   0 */		.word	0
/* 0x2958	   0 */		.word	0
/* 0x295c	   0 */		.word	285
/* 0x2960	   0 */		.word	0
/* 0x2964	   0 */		.word	0
/* 0x2968	   0 */		.word	4
/* 0x296c	   0 */		.word	0
/* 0x2970	   0 */		.word	0
/* 0x2974	   0 */		.word	0
/* 0x2978	   0 */		.word	277
/* 0x297c	   0 */		.word	281
/* 0x2980	   0 */		.word	375
/* 0x2984	   0 */		.word	3
/* 0x2988	   0 */		.word	375
/* 0x298c	   0 */		.word	1
/* 0x2990	   0 */		.word	375
/* 0x2994	   0 */		.word	1
/* 0x2998	   0 */		.word	1
/* 0x299c	   0 */		.word	0
/* 0x29a0	   0 */		.word	0
/* 0x29a4	   0 */		.word	0
/* 0x29a8	   0 */		.word	0
/* 0x29ac	   0 */		.word	375
/* 0x29b0	   0 */		.word	0
/* 0x29b4	   0 */		.word	0
/* 0x29b8	   0 */		.word	4
/* 0x29bc	   0 */		.word	0
/* 0x29c0	   0 */		.word	0
/* 0x29c4	   0 */		.word	0
/* 0x29c8	   0 */		.word	365
/* 0x29cc	   0 */		.word	3
/* 0x29d0	   0 */		.word	365
/* 0x29d4	   0 */		.word	1
/* 0x29d8	   0 */		.word	365
/* 0x29dc	   0 */		.word	1
/* 0x29e0	   0 */		.word	1
/* 0x29e4	   0 */		.word	0
/* 0x29e8	   0 */		.word	0
/* 0x29ec	   0 */		.word	0
/* 0x29f0	   0 */		.word	0
/* 0x29f4	   0 */		.word	365
/* 0x29f8	   0 */		.word	0
/* 0x29fc	   0 */		.word	0
/* 0x2a00	   0 */		.word	4
/* 0x2a04	   0 */		.word	0
/* 0x2a08	   0 */		.word	0
/* 0x2a0c	   0 */		.word	0
/* 0x2a10	   0 */		.word	355
/* 0x2a14	   0 */		.word	3
/* 0x2a18	   0 */		.word	355
/* 0x2a1c	   0 */		.word	1
/* 0x2a20	   0 */		.word	355
/* 0x2a24	   0 */		.word	1
/* 0x2a28	   0 */		.word	1
/* 0x2a2c	   0 */		.word	0
/* 0x2a30	   0 */		.word	0
/* 0x2a34	   0 */		.word	0
/* 0x2a38	   0 */		.word	0
/* 0x2a3c	   0 */		.word	355
/* 0x2a40	   0 */		.word	0
/* 0x2a44	   0 */		.word	0
/* 0x2a48	   0 */		.word	4
/* 0x2a4c	   0 */		.word	0
/* 0x2a50	   0 */		.word	0
/* 0x2a54	   0 */		.word	0
/* 0x2a58	   0 */		.word	345
/* 0x2a5c	   0 */		.word	3
/* 0x2a60	   0 */		.word	345
/* 0x2a64	   0 */		.word	1
/* 0x2a68	   0 */		.word	345
/* 0x2a6c	   0 */		.word	1
/* 0x2a70	   0 */		.word	1
/* 0x2a74	   0 */		.word	0
/* 0x2a78	   0 */		.word	0
/* 0x2a7c	   0 */		.word	0
/* 0x2a80	   0 */		.word	0
/* 0x2a84	   0 */		.word	345
/* 0x2a88	   0 */		.word	0
/* 0x2a8c	   0 */		.word	0
/* 0x2a90	   0 */		.word	4
/* 0x2a94	   0 */		.word	0
/* 0x2a98	   0 */		.word	0
/* 0x2a9c	   0 */		.word	0
/* 0x2aa0	   0 */		.word	335
/* 0x2aa4	   0 */		.word	3
/* 0x2aa8	   0 */		.word	335
/* 0x2aac	   0 */		.word	1
/* 0x2ab0	   0 */		.word	335
/* 0x2ab4	   0 */		.word	1
/* 0x2ab8	   0 */		.word	1
/* 0x2abc	   0 */		.word	0
/* 0x2ac0	   0 */		.word	0
/* 0x2ac4	   0 */		.word	0
/* 0x2ac8	   0 */		.word	0
/* 0x2acc	   0 */		.word	335
/* 0x2ad0	   0 */		.word	0
/* 0x2ad4	   0 */		.word	0
/* 0x2ad8	   0 */		.word	4
/* 0x2adc	   0 */		.word	0
/* 0x2ae0	   0 */		.word	0
/* 0x2ae4	   0 */		.word	0
/* 0x2ae8	   0 */		.word	325
/* 0x2aec	   0 */		.word	3
/* 0x2af0	   0 */		.word	325
/* 0x2af4	   0 */		.word	1
/* 0x2af8	   0 */		.word	325
/* 0x2afc	   0 */		.word	1
/* 0x2b00	   0 */		.word	1
/* 0x2b04	   0 */		.word	0
/* 0x2b08	   0 */		.word	0
/* 0x2b0c	   0 */		.word	0
/* 0x2b10	   0 */		.word	0
/* 0x2b14	   0 */		.word	325
/* 0x2b18	   0 */		.word	0
/* 0x2b1c	   0 */		.word	0
/* 0x2b20	   0 */		.word	4
/* 0x2b24	   0 */		.word	0
/* 0x2b28	   0 */		.word	0
/* 0x2b2c	   0 */		.word	0
/* 0x2b30	   0 */		.word	315
/* 0x2b34	   0 */		.word	3
/* 0x2b38	   0 */		.word	315
/* 0x2b3c	   0 */		.word	1
/* 0x2b40	   0 */		.word	315
/* 0x2b44	   0 */		.word	1
/* 0x2b48	   0 */		.word	1
/* 0x2b4c	   0 */		.word	0
/* 0x2b50	   0 */		.word	0
/* 0x2b54	   0 */		.word	0
/* 0x2b58	   0 */		.word	0
/* 0x2b5c	   0 */		.word	315
/* 0x2b60	   0 */		.word	0
/* 0x2b64	   0 */		.word	0
/* 0x2b68	   0 */		.word	4
/* 0x2b6c	   0 */		.word	0
/* 0x2b70	   0 */		.word	0
/* 0x2b74	   0 */		.word	0
/* 0x2b78	   0 */		.word	305
/* 0x2b7c	   0 */		.word	3
/* 0x2b80	   0 */		.word	305
/* 0x2b84	   0 */		.word	1
/* 0x2b88	   0 */		.word	305
/* 0x2b8c	   0 */		.word	1
/* 0x2b90	   0 */		.word	1
/* 0x2b94	   0 */		.word	0
/* 0x2b98	   0 */		.word	0
/* 0x2b9c	   0 */		.word	0
/* 0x2ba0	   0 */		.word	0
/* 0x2ba4	   0 */		.word	305
/* 0x2ba8	   0 */		.word	0
/* 0x2bac	   0 */		.word	0
/* 0x2bb0	   0 */		.word	4
/* 0x2bb4	   0 */		.word	0
/* 0x2bb8	   0 */		.word	0
/* 0x2bbc	   0 */		.word	0
/* 0x2bc0	   0 */		.word	8
/* 0x2bc4	   0 */		.word	8
/* 0x2bc8	   0 */		.word	380
/* 0x2bcc	   0 */		.word	384
/* 0x2bd0	   0 */		.word	388
/* 0x2bd4	   0 */		.word	392
/* 0x2bd8	   0 */		.word	396
/* 0x2bdc	   0 */		.word	400
/* 0x2be0	   0 */		.word	404
/* 0x2be4	   0 */		.word	408
/* 0x2be8	   0 */		.word	380
/* 0x2bec	   0 */		.word	70
/* 0x2bf0	   0 */		.word	412
/* 0x2bf4	   0 */		.word	384
/* 0x2bf8	   0 */		.word	70
/* 0x2bfc	   0 */		.word	416
/* 0x2c00	   0 */		.word	388
/* 0x2c04	   0 */		.word	70
/* 0x2c08	   0 */		.word	420
/* 0x2c0c	   0 */		.word	392
/* 0x2c10	   0 */		.word	70
/* 0x2c14	   0 */		.word	424
/* 0x2c18	   0 */		.word	396
/* 0x2c1c	   0 */		.word	70
/* 0x2c20	   0 */		.word	428
/* 0x2c24	   0 */		.word	400
/* 0x2c28	   0 */		.word	70
/* 0x2c2c	   0 */		.word	432
/* 0x2c30	   0 */		.word	404
/* 0x2c34	   0 */		.word	70
/* 0x2c38	   0 */		.word	436
/* 0x2c3c	   0 */		.word	408
/* 0x2c40	   0 */		.word	70
/* 0x2c44	   0 */		.word	440
/* 0x2c48	   0 */		.word	8
/* 0x2c4c	   0 */		.word	293
/* 0x2c50	   0 */		.word	293
/* 0x2c54	   0 */		.word	8
/* 0x2c58	   0 */		.word	293
/* 0x2c5c	   0 */		.word	2
/* 0x2c60	   0 */		.word	444
/* 0x2c64	   0 */		.word	449
/* 0x2c68	   0 */		.word	293
/* 0x2c6c	   0 */		.word	2
/* 0x2c70	   0 */		.word	454
/* 0x2c74	   0 */		.word	459
/* 0x2c78	   0 */		.word	444
/* 0x2c7c	   0 */		.word	6
/* 0x2c80	   0 */		.word	444
/* 0x2c84	   0 */		.word	1
/* 0x2c88	   0 */		.word	444
/* 0x2c8c	   0 */		.word	0
/* 0x2c90	   0 */		.word	0
/* 0x2c94	   0 */		.word	0
/* 0x2c98	   0 */		.word	0
/* 0x2c9c	   0 */		.word	0
/* 0x2ca0	   0 */		.word	0
/* 0x2ca4	   0 */		.word	444
/* 0x2ca8	   0 */		.word	2
/* 0x2cac	   0 */		.word	2
/* 0x2cb0	   0 */		.word	4
/* 0x2cb4	   0 */		.word	0
/* 0x2cb8	   0 */		.word	0
/* 0x2cbc	   0 */		.word	0
/* 0x2cc0	   0 */		.word	454
/* 0x2cc4	   0 */		.word	6
/* 0x2cc8	   0 */		.word	454
/* 0x2ccc	   0 */		.word	1
/* 0x2cd0	   0 */		.word	454
/* 0x2cd4	   0 */		.word	0
/* 0x2cd8	   0 */		.word	0
/* 0x2cdc	   0 */		.word	0
/* 0x2ce0	   0 */		.word	0
/* 0x2ce4	   0 */		.word	0
/* 0x2ce8	   0 */		.word	0
/* 0x2cec	   0 */		.word	454
/* 0x2cf0	   0 */		.word	2
/* 0x2cf4	   0 */		.word	2
/* 0x2cf8	   0 */		.word	4
/* 0x2cfc	   0 */		.word	0
/* 0x2d00	   0 */		.word	0
/* 0x2d04	   0 */		.word	0
/* 0x2d08	   0 */		.word	459
/* 0x2d0c	   0 */		.word	3
/* 0x2d10	   0 */		.word	459
/* 0x2d14	   0 */		.word	1
/* 0x2d18	   0 */		.word	459
/* 0x2d1c	   0 */		.word	1
/* 0x2d20	   0 */		.word	1
/* 0x2d24	   0 */		.word	0
/* 0x2d28	   0 */		.word	0
/* 0x2d2c	   0 */		.word	0
/* 0x2d30	   0 */		.word	0
/* 0x2d34	   0 */		.word	459
/* 0x2d38	   0 */		.word	0
/* 0x2d3c	   0 */		.word	0
/* 0x2d40	   0 */		.word	4
/* 0x2d44	   0 */		.word	0
/* 0x2d48	   0 */		.word	0
/* 0x2d4c	   0 */		.word	0
/* 0x2d50	   0 */		.word	449
/* 0x2d54	   0 */		.word	3
/* 0x2d58	   0 */		.word	449
/* 0x2d5c	   0 */		.word	1
/* 0x2d60	   0 */		.word	449
/* 0x2d64	   0 */		.word	1
/* 0x2d68	   0 */		.word	1
/* 0x2d6c	   0 */		.word	0
/* 0x2d70	   0 */		.word	0
/* 0x2d74	   0 */		.word	0
/* 0x2d78	   0 */		.word	0
/* 0x2d7c	   0 */		.word	449
/* 0x2d80	   0 */		.word	0
/* 0x2d84	   0 */		.word	0
/* 0x2d88	   0 */		.word	4
/* 0x2d8c	   0 */		.word	0
/* 0x2d90	   0 */		.word	0
/* 0x2d94	   0 */		.word	0
/* 0x2d98	   0 */		.word	8
/* 0x2d9c	   0 */		.word	8
/* 0x2da0	   0 */		.word	464
/* 0x2da4	   0 */		.word	468
/* 0x2da8	   0 */		.word	472
/* 0x2dac	   0 */		.word	476
/* 0x2db0	   0 */		.word	480
/* 0x2db4	   0 */		.word	484
/* 0x2db8	   0 */		.word	488
/* 0x2dbc	   0 */		.word	492
/* 0x2dc0	   0 */		.word	496
/* 0x2dc4	   0 */		.word	500
/* 0x2dc8	   0 */		.word	464
/* 0x2dcc	   0 */		.word	215
/* 0x2dd0	   0 */		.word	504
/* 0x2dd4	   0 */		.word	468
/* 0x2dd8	   0 */		.word	215
/* 0x2ddc	   0 */		.word	509
/* 0x2de0	   0 */		.word	472
/* 0x2de4	   0 */		.word	215
/* 0x2de8	   0 */		.word	514
/* 0x2dec	   0 */		.word	476
/* 0x2df0	   0 */		.word	215
/* 0x2df4	   0 */		.word	518
/* 0x2df8	   0 */		.word	480
/* 0x2dfc	   0 */		.word	215
/* 0x2e00	   0 */		.word	522
/* 0x2e04	   0 */		.word	484
/* 0x2e08	   0 */		.word	215
/* 0x2e0c	   0 */		.word	526
/* 0x2e10	   0 */		.word	488
/* 0x2e14	   0 */		.word	215
/* 0x2e18	   0 */		.word	530
/* 0x2e1c	   0 */		.word	492
/* 0x2e20	   0 */		.word	215
/* 0x2e24	   0 */		.word	534
/* 0x2e28	   0 */		.word	496
/* 0x2e2c	   0 */		.word	215
/* 0x2e30	   0 */		.word	538
/* 0x2e34	   0 */		.word	500
/* 0x2e38	   0 */		.word	215
/* 0x2e3c	   0 */		.word	543
/* 0x2e40	   0 */		.word	8
/* 0x2e44	   0 */		.word	8
/* 0x2e48	   0 */		.word	543
/* 0x2e4c	   0 */		.word	4
/* 0x2e50	   0 */		.word	543
/* 0x2e54	   0 */		.word	4
/* 0x2e58	   0 */		.word	543
/* 0x2e5c	   0 */		.word	1
/* 0x2e60	   0 */		.word	1
/* 0x2e64	   0 */		.word	2
/* 0x2e68	   0 */		.word	1
/* 0x2e6c	   0 */		.word	1
/* 0x2e70	   0 */		.word	0
/* 0x2e74	   0 */		.word	543
/* 0x2e78	   0 */		.word	1
/* 0x2e7c	   0 */		.word	1
/* 0x2e80	   0 */		.word	4
/* 0x2e84	   0 */		.word	0
/* 0x2e88	   0 */		.word	0
/* 0x2e8c	   0 */		.word	0
/* 0x2e90	   0 */		.word	538
/* 0x2e94	   0 */		.word	4
/* 0x2e98	   0 */		.word	538
/* 0x2e9c	   0 */		.word	4
/* 0x2ea0	   0 */		.word	538
/* 0x2ea4	   0 */		.word	1
/* 0x2ea8	   0 */		.word	1
/* 0x2eac	   0 */		.word	2
/* 0x2eb0	   0 */		.word	1
/* 0x2eb4	   0 */		.word	1
/* 0x2eb8	   0 */		.word	0
/* 0x2ebc	   0 */		.word	538
/* 0x2ec0	   0 */		.word	1
/* 0x2ec4	   0 */		.word	1
/* 0x2ec8	   0 */		.word	4
/* 0x2ecc	   0 */		.word	0
/* 0x2ed0	   0 */		.word	0
/* 0x2ed4	   0 */		.word	0
/* 0x2ed8	   0 */		.word	534
/* 0x2edc	   0 */		.word	4
/* 0x2ee0	   0 */		.word	534
/* 0x2ee4	   0 */		.word	4
/* 0x2ee8	   0 */		.word	534
/* 0x2eec	   0 */		.word	1
/* 0x2ef0	   0 */		.word	1
/* 0x2ef4	   0 */		.word	2
/* 0x2ef8	   0 */		.word	1
/* 0x2efc	   0 */		.word	1
/* 0x2f00	   0 */		.word	0
/* 0x2f04	   0 */		.word	534
/* 0x2f08	   0 */		.word	1
/* 0x2f0c	   0 */		.word	1
/* 0x2f10	   0 */		.word	4
/* 0x2f14	   0 */		.word	0
/* 0x2f18	   0 */		.word	0
/* 0x2f1c	   0 */		.word	0
/* 0x2f20	   0 */		.word	530
/* 0x2f24	   0 */		.word	4
/* 0x2f28	   0 */		.word	530
/* 0x2f2c	   0 */		.word	4
/* 0x2f30	   0 */		.word	530
/* 0x2f34	   0 */		.word	1
/* 0x2f38	   0 */		.word	1
/* 0x2f3c	   0 */		.word	2
/* 0x2f40	   0 */		.word	1
/* 0x2f44	   0 */		.word	1
/* 0x2f48	   0 */		.word	0
/* 0x2f4c	   0 */		.word	530
/* 0x2f50	   0 */		.word	1
/* 0x2f54	   0 */		.word	1
/* 0x2f58	   0 */		.word	4
/* 0x2f5c	   0 */		.word	0
/* 0x2f60	   0 */		.word	0
/* 0x2f64	   0 */		.word	0
/* 0x2f68	   0 */		.word	526
/* 0x2f6c	   0 */		.word	4
/* 0x2f70	   0 */		.word	526
/* 0x2f74	   0 */		.word	4
/* 0x2f78	   0 */		.word	526
/* 0x2f7c	   0 */		.word	1
/* 0x2f80	   0 */		.word	1
/* 0x2f84	   0 */		.word	2
/* 0x2f88	   0 */		.word	1
/* 0x2f8c	   0 */		.word	1
/* 0x2f90	   0 */		.word	0
/* 0x2f94	   0 */		.word	526
/* 0x2f98	   0 */		.word	1
/* 0x2f9c	   0 */		.word	1
/* 0x2fa0	   0 */		.word	4
/* 0x2fa4	   0 */		.word	0
/* 0x2fa8	   0 */		.word	0
/* 0x2fac	   0 */		.word	0
/* 0x2fb0	   0 */		.word	522
/* 0x2fb4	   0 */		.word	4
/* 0x2fb8	   0 */		.word	522
/* 0x2fbc	   0 */		.word	4
/* 0x2fc0	   0 */		.word	522
/* 0x2fc4	   0 */		.word	1
/* 0x2fc8	   0 */		.word	1
/* 0x2fcc	   0 */		.word	2
/* 0x2fd0	   0 */		.word	1
/* 0x2fd4	   0 */		.word	1
/* 0x2fd8	   0 */		.word	0
/* 0x2fdc	   0 */		.word	522
/* 0x2fe0	   0 */		.word	1
/* 0x2fe4	   0 */		.word	1
/* 0x2fe8	   0 */		.word	4
/* 0x2fec	   0 */		.word	0
/* 0x2ff0	   0 */		.word	0
/* 0x2ff4	   0 */		.word	0
/* 0x2ff8	   0 */		.word	518
/* 0x2ffc	   0 */		.word	4
/* 0x3000	   0 */		.word	518
/* 0x3004	   0 */		.word	4
/* 0x3008	   0 */		.word	518
/* 0x300c	   0 */		.word	1
/* 0x3010	   0 */		.word	1
/* 0x3014	   0 */		.word	2
/* 0x3018	   0 */		.word	1
/* 0x301c	   0 */		.word	1
/* 0x3020	   0 */		.word	0
/* 0x3024	   0 */		.word	518
/* 0x3028	   0 */		.word	1
/* 0x302c	   0 */		.word	1
/* 0x3030	   0 */		.word	4
/* 0x3034	   0 */		.word	0
/* 0x3038	   0 */		.word	0
/* 0x303c	   0 */		.word	0
/* 0x3040	   0 */		.word	514
/* 0x3044	   0 */		.word	4
/* 0x3048	   0 */		.word	514
/* 0x304c	   0 */		.word	4
/* 0x3050	   0 */		.word	514
/* 0x3054	   0 */		.word	1
/* 0x3058	   0 */		.word	1
/* 0x305c	   0 */		.word	2
/* 0x3060	   0 */		.word	1
/* 0x3064	   0 */		.word	1
/* 0x3068	   0 */		.word	0
/* 0x306c	   0 */		.word	514
/* 0x3070	   0 */		.word	1
/* 0x3074	   0 */		.word	1
/* 0x3078	   0 */		.word	4
/* 0x307c	   0 */		.word	0
/* 0x3080	   0 */		.word	0
/* 0x3084	   0 */		.word	0
/* 0x3088	   0 */		.word	509
/* 0x308c	   0 */		.word	2
/* 0x3090	   0 */		.word	509
/* 0x3094	   0 */		.word	4
/* 0x3098	   0 */		.word	509
/* 0x309c	   0 */		.word	0
/* 0x30a0	   0 */		.word	0
/* 0x30a4	   0 */		.word	2
/* 0x30a8	   0 */		.word	0
/* 0x30ac	   0 */		.word	0
/* 0x30b0	   0 */		.word	0
/* 0x30b4	   0 */		.word	509
/* 0x30b8	   0 */		.word	1
/* 0x30bc	   0 */		.word	1
/* 0x30c0	   0 */		.word	4
/* 0x30c4	   0 */		.word	0
/* 0x30c8	   0 */		.word	0
/* 0x30cc	   0 */		.word	0
/* 0x30d0	   0 */		.word	504
/* 0x30d4	   0 */		.word	2
/* 0x30d8	   0 */		.word	504
/* 0x30dc	   0 */		.word	4
/* 0x30e0	   0 */		.word	504
/* 0x30e4	   0 */		.word	0
/* 0x30e8	   0 */		.word	0
/* 0x30ec	   0 */		.word	2
/* 0x30f0	   0 */		.word	0
/* 0x30f4	   0 */		.word	0
/* 0x30f8	   0 */		.word	0
/* 0x30fc	   0 */		.word	504
/* 0x3100	   0 */		.word	1
/* 0x3104	   0 */		.word	1
/* 0x3108	   0 */		.word	4
/* 0x310c	   0 */		.word	0
/* 0x3110	   0 */		.word	0
/* 0x3114	   0 */		.word	0
/* 0x3118	   0 */		.word	464
/* 0x311c	   0 */		.word	468
/* 0x3120	   0 */		.word	472
/* 0x3124	   0 */		.word	476
/* 0x3128	   0 */		.word	480
/* 0x312c	   0 */		.word	484
/* 0x3130	   0 */		.word	488
/* 0x3134	   0 */		.word	492
/* 0x3138	   0 */		.word	496
/* 0x313c	   0 */		.word	500
/* 0x3140	   0 */		.word	8
/* 0x3144	   0 */		.word	8
/* 0x3148	   0 */		.word	17
/* 0x314c	   0 */		.word	0
/* 0x3150	   0 */		.word	0
/* 0x3154	   0 */		.word	8
/* 0x3158	   0 */		.word	8
/* 0x315c	   0 */		.word	548
/* 0x3160	   0 */		.word	8
/* 0x3164	   0 */		.word	563
/* 0x3168	   0 */		.word	8
/* 0x316c	   0 */		.word	587
/* 0x3170	   0 */		.word	610
/* 0x3174	   0 */		.word	587
/* 0x3178	   0 */		.word	624
/* 0x317c	   0 */		.word	633
/* 0x3180	   0 */		.word	642
/* 0x3184	   0 */		.word	646
/* 0x3188	   0 */		.word	293
/* 0x318c	   0 */		.word	2
/* 0x3190	   0 */		.word	650
/* 0x3194	   0 */		.word	655
/* 0x3198	   0 */		.word	293
/* 0x319c	   0 */		.word	2
/* 0x31a0	   0 */		.word	660
/* 0x31a4	   0 */		.word	665
/* 0x31a8	   0 */		.word	660
/* 0x31ac	   0 */		.word	6
/* 0x31b0	   0 */		.word	660
/* 0x31b4	   0 */		.word	1
/* 0x31b8	   0 */		.word	660
/* 0x31bc	   0 */		.word	0
/* 0x31c0	   0 */		.word	0
/* 0x31c4	   0 */		.word	0
/* 0x31c8	   0 */		.word	0
/* 0x31cc	   0 */		.word	0
/* 0x31d0	   0 */		.word	0
/* 0x31d4	   0 */		.word	660
/* 0x31d8	   0 */		.word	2
/* 0x31dc	   0 */		.word	2
/* 0x31e0	   0 */		.word	4
/* 0x31e4	   0 */		.word	0
/* 0x31e8	   0 */		.word	0
/* 0x31ec	   0 */		.word	0
/* 0x31f0	   0 */		.word	665
/* 0x31f4	   0 */		.word	3
/* 0x31f8	   0 */		.word	665
/* 0x31fc	   0 */		.word	1
/* 0x3200	   0 */		.word	665
/* 0x3204	   0 */		.word	1
/* 0x3208	   0 */		.word	1
/* 0x320c	   0 */		.word	0
/* 0x3210	   0 */		.word	0
/* 0x3214	   0 */		.word	0
/* 0x3218	   0 */		.word	0
/* 0x321c	   0 */		.word	665
/* 0x3220	   0 */		.word	0
/* 0x3224	   0 */		.word	0
/* 0x3228	   0 */		.word	4
/* 0x322c	   0 */		.word	0
/* 0x3230	   0 */		.word	0
/* 0x3234	   0 */		.word	0
/* 0x3238	   0 */		.word	650
/* 0x323c	   0 */		.word	6
/* 0x3240	   0 */		.word	650
/* 0x3244	   0 */		.word	1
/* 0x3248	   0 */		.word	650
/* 0x324c	   0 */		.word	0
/* 0x3250	   0 */		.word	0
/* 0x3254	   0 */		.word	0
/* 0x3258	   0 */		.word	0
/* 0x325c	   0 */		.word	0
/* 0x3260	   0 */		.word	0
/* 0x3264	   0 */		.word	650
/* 0x3268	   0 */		.word	2
/* 0x326c	   0 */		.word	2
/* 0x3270	   0 */		.word	4
/* 0x3274	   0 */		.word	0
/* 0x3278	   0 */		.word	0
/* 0x327c	   0 */		.word	0
/* 0x3280	   0 */		.word	655
/* 0x3284	   0 */		.word	3
/* 0x3288	   0 */		.word	655
/* 0x328c	   0 */		.word	1
/* 0x3290	   0 */		.word	655
/* 0x3294	   0 */		.word	1
/* 0x3298	   0 */		.word	1
/* 0x329c	   0 */		.word	0
/* 0x32a0	   0 */		.word	0
/* 0x32a4	   0 */		.word	0
/* 0x32a8	   0 */		.word	0
/* 0x32ac	   0 */		.word	655
/* 0x32b0	   0 */		.word	0
/* 0x32b4	   0 */		.word	0
/* 0x32b8	   0 */		.word	4
/* 0x32bc	   0 */		.word	0
/* 0x32c0	   0 */		.word	0
/* 0x32c4	   0 */		.word	0
/* 0x32c8	   0 */		.asciz	"pixel.c"
/* 0x32d0	   0 */		.asciz	"gl_error"
/* 0x32d9	   0 */		.asciz	"update_drawpixels_state"
/* 0x32f1	   0 */		.asciz	"gl_write_color_span"
/* 0x3305	   0 */		.asciz	"L1"
/* 0x3308	   0 */		.asciz	"L2"
/* 0x330b	   0 */		.asciz	"L3"
/* 0x330e	   0 */		.asciz	"dynamic-alias-disambiguation"
/* 0x332b	   0 */		.asciz	"L43"
/* 0x332f	   0 */		.asciz	"gl_write_index_span"
/* 0x3343	   0 */		.asciz	"L4"
/* 0x3346	   0 */		.asciz	"L5"
/* 0x3349	   0 */		.asciz	"L6"
/* 0x334c	   0 */		.asciz	"L45"
/* 0x3350	   0 */		.asciz	"gl_write_stencil_span"
/* 0x3366	   0 */		.asciz	"L7"
/* 0x3369	   0 */		.asciz	"L8"
/* 0x336c	   0 */		.asciz	"L9"
/* 0x336f	   0 */		.asciz	"L47"
/* 0x3373	   0 */		.asciz	"L10"
/* 0x3377	   0 */		.asciz	"L11"
/* 0x337b	   0 */		.asciz	"L12"
/* 0x337f	   0 */		.asciz	"L13"
/* 0x3383	   0 */		.asciz	"L14"
/* 0x3387	   0 */		.asciz	"L15"
/* 0x338b	   0 */		.asciz	"L16"
/* 0x338f	   0 */		.asciz	"L17"
/* 0x3393	   0 */		.asciz	"L18"
/* 0x3397	   0 */		.asciz	"L19"
/* 0x339b	   0 */		.asciz	"L20"
/* 0x339f	   0 */		.asciz	"improved-signed-index"
/* 0x33b5	   0 */		.asciz	"L63"
/* 0x33b9	   0 */		.asciz	"L65"
/* 0x33bd	   0 */		.asciz	"L61"
/* 0x33c1	   0 */		.asciz	"L59"
/* 0x33c5	   0 */		.asciz	"L57"
/* 0x33c9	   0 */		.asciz	"L55"
/* 0x33cd	   0 */		.asciz	"L53"
/* 0x33d1	   0 */		.asciz	"L51"
/* 0x33d5	   0 */		.asciz	"L49"
/* 0x33d9	   0 */		.asciz	"L67"
/* 0x33dd	   0 */		.asciz	"L21"
/* 0x33e1	   0 */		.asciz	"L22"
/* 0x33e5	   0 */		.asciz	"L71"
/* 0x33e9	   0 */		.asciz	"L69"
/* 0x33ed	   0 */		.asciz	"memcpy"
/* 0x33f4	   0 */		.asciz	"L108"
/* 0x33f9	   0 */		.asciz	"L109"
/* 0x33fe	   0 */		.asciz	"L110"
/* 0x3403	   0 */		.asciz	"L111"
/* 0x3408	   0 */		.asciz	"L112"
/* 0x340d	   0 */		.asciz	"L113"
/* 0x3412	   0 */		.asciz	"L114"
/* 0x3417	   0 */		.asciz	"L115"
/* 0x341c	   0 */		.asciz	"L116"
/* 0x3421	   0 */		.asciz	"L117"
/* 0x3426	   0 */		.asciz	"L118"
/* 0x342b	   0 */		.asciz	"L119"
/* 0x3430	   0 */		.asciz	"L120"
/* 0x3435	   0 */		.asciz	"L121"
/* 0x343a	   0 */		.asciz	"L122"
/* 0x343f	   0 */		.asciz	"L123"
/* 0x3444	   0 */		.asciz	"L23"
/* 0x3448	   0 */		.asciz	"L24"
/* 0x344c	   0 */		.asciz	"L25"
/* 0x3450	   0 */		.asciz	"L26"
/* 0x3454	   0 */		.asciz	"L27"
/* 0x3458	   0 */		.asciz	"L28"
/* 0x345c	   0 */		.asciz	"L29"
/* 0x3460	   0 */		.asciz	"L30"
/* 0x3464	   0 */		.asciz	"L83"
/* 0x3468	   0 */		.asciz	"L81"
/* 0x346c	   0 */		.asciz	"L79"
/* 0x3470	   0 */		.asciz	"L77"
/* 0x3474	   0 */		.asciz	"L75"
/* 0x3478	   0 */		.asciz	"L73"
/* 0x347c	   0 */		.asciz	"L87"
/* 0x3480	   0 */		.asciz	"L85"
/* 0x3484	   0 */		.asciz	"L124"
/* 0x3489	   0 */		.asciz	"L125"
/* 0x348e	   0 */		.asciz	"L126"
/* 0x3493	   0 */		.asciz	"L127"
/* 0x3498	   0 */		.asciz	"L31"
/* 0x349c	   0 */		.asciz	"L32"
/* 0x34a0	   0 */		.asciz	"L33"
/* 0x34a4	   0 */		.asciz	"L34"
/* 0x34a8	   0 */		.asciz	"L35"
/* 0x34ac	   0 */		.asciz	"L36"
/* 0x34b0	   0 */		.asciz	"L37"
/* 0x34b4	   0 */		.asciz	"L38"
/* 0x34b8	   0 */		.asciz	"L39"
/* 0x34bc	   0 */		.asciz	"L40"
/* 0x34c0	   0 */		.asciz	"L103"
/* 0x34c5	   0 */		.asciz	"L101"
/* 0x34ca	   0 */		.asciz	"L99"
/* 0x34ce	   0 */		.asciz	"L97"
/* 0x34d2	   0 */		.asciz	"L95"
/* 0x34d6	   0 */		.asciz	"L93"
/* 0x34da	   0 */		.asciz	"L91"
/* 0x34de	   0 */		.asciz	"L89"
/* 0x34e2	   0 */		.asciz	"L107"
/* 0x34e7	   0 */		.asciz	"L105"
/* 0x34ec	   0 */		.asciz	"gl_sizeof_type"
/* 0x34fb	   0 */		.asciz	"gl_components_in_format"
/* 0x3513	   0 */		.asciz	"gl_pixel_addr_in_image"
/* 0x352a	   0 */		.asciz	"gl_flip_bytes"
/* 0x3538	   0 */		.asciz	"gl_swap2"
/* 0x3541	   0 */		.asciz	"gl_swap4"
/* 0x354a	   0 */		.asciz	"L41"
/* 0x354e	   0 */		.asciz	"L42"
/* 0x3552	   0 */		.asciz	"L128"
/* 0x3557	   0 */		.asciz	"L129"
/* 0x355c	   0 */		.asciz	"L130"
/* 0x3561	   0 */		.asciz	"L131"

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
!   reloc[2]: knd=0, off=282, siz=4, lab1=update_drawpixels_state, lab2=, loff=0
!   reloc[3]: knd=0, off=286, siz=4, lab1=update_drawpixels_state, lab2=, loff=384
!   reloc[4]: knd=0, off=38092, siz=4, lab1=gl_PixelZoom, lab2=, loff=0
!   reloc[5]: knd=0, off=38096, siz=4, lab1=gl_PixelZoom, lab2=, loff=456
!   reloc[6]: knd=0, off=38192, siz=4, lab1=gl_write_zoomed_color_span, lab2=, loff=0
!   reloc[7]: knd=0, off=38196, siz=4, lab1=gl_write_zoomed_color_span, lab2=, loff=4088
!   reloc[8]: knd=0, off=38854, siz=4, lab1=gl_write_zoomed_index_span, lab2=, loff=0
!   reloc[9]: knd=0, off=38858, siz=4, lab1=gl_write_zoomed_index_span, lab2=, loff=2032
!   reloc[10]: knd=0, off=39262, siz=4, lab1=gl_write_zoomed_stencil_span, lab2=, loff=0
!   reloc[11]: knd=0, off=39266, siz=4, lab1=gl_write_zoomed_stencil_span, lab2=, loff=1392
!   reloc[12]: knd=0, off=39609, siz=4, lab1=gl_PixelStorei, lab2=, loff=0
!   reloc[13]: knd=0, off=39613, siz=4, lab1=gl_PixelStorei, lab2=, loff=1056
!   reloc[14]: knd=0, off=39698, siz=4, lab1=gl_PixelMapfv, lab2=, loff=0
!   reloc[15]: knd=0, off=39702, siz=4, lab1=gl_PixelMapfv, lab2=, loff=3404
!   reloc[16]: knd=0, off=39858, siz=4, lab1=gl_GetPixelMapfv, lab2=, loff=0
!   reloc[17]: knd=0, off=39862, siz=4, lab1=gl_GetPixelMapfv, lab2=, loff=4140
!   reloc[18]: knd=0, off=39961, siz=4, lab1=gl_GetPixelMapuiv, lab2=, loff=0
!   reloc[19]: knd=0, off=39965, siz=4, lab1=gl_GetPixelMapuiv, lab2=, loff=3724
!   reloc[20]: knd=0, off=40064, siz=4, lab1=gl_GetPixelMapusv, lab2=, loff=0
!   reloc[21]: knd=0, off=40068, siz=4, lab1=gl_GetPixelMapusv, lab2=, loff=5052
!   reloc[22]: knd=0, off=40172, siz=4, lab1=gl_PixelTransferf, lab2=, loff=0
!   reloc[23]: knd=0, off=40176, siz=4, lab1=gl_PixelTransferf, lab2=, loff=776
!   reloc[24]: knd=0, off=40265, siz=4, lab1=gl_unpack_pixels, lab2=, loff=0
!   reloc[25]: knd=0, off=40269, siz=4, lab1=gl_unpack_pixels, lab2=, loff=1432
	.section ".debug_info"
	.byte 0x00,0x00,0xa1,0x74,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "pixel.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  pixel.c -W0,-xp\\$XAa59JCfgJdL2pr.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCfgJdL2pr.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "update_drawpixels_state\0"
	.byte 0x03,0x01,0x51
	.uaword update_drawpixels_state
	.uaword update_drawpixels_state+384
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x3a
	.byte 0x03,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x50,0x03,0x91,0xc4,0x00,0x00,0x04
	.ascii "int\0"
	.byte 0x05,0x04,0x05,0x00,0x00,0x01,0x3a
	.ascii "GLint\0"
	.byte 0x03,0x06
	.ascii "HashTable\0"
	.byte 0x01,0x07,0x00,0x00,0x01,0x4d,0x04
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x05,0x00,0x00,0x01,0x5e
	.ascii "GLuint\0"
	.byte 0x03,0x04
	.ascii "float\0"
	.byte 0x04,0x04,0x05,0x00,0x00,0x01,0x77
	.ascii "GLfloat\0"
	.byte 0x03,0x04
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x01,0x41,0x10
	.byte 0x00,0x00,0x01,0xa7,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x0a,0x04,0x03,0x00,0x00
	.byte 0x31,0x43,0x0b
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
	.byte 0xa7
	.ascii "GLenum\0"
	.byte 0x03,0x04
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x05,0x00,0x00,0x31,0x50
	.ascii "GLubyte\0"
	.byte 0x03,0x07,0x00,0x00,0x31,0x61,0x04
	.ascii "void\0"
	.byte 0x05,0x00,0x07,0x00,0x00,0x31,0x74,0x0c
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x02,0x00,0x00,0x32,0x8a,0x0d
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "Border\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x08,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x0c,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x10,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x14,0x0d
	.ascii "Width2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x18,0x0d
	.ascii "Height2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x1c,0x0d
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x20,0x0d
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x24,0x0d
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x28,0x0d
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x2c,0x0d
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x30,0x0d
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0x6f,0x02,0x23,0x34,0x0d
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x38,0x00
	.byte 0x07,0x00,0x00,0x31,0x81,0x08,0x00,0x00
	.byte 0x32,0x8a,0x2c,0x00,0x00,0x32,0xa0,0x09
	.byte 0x00,0x00,0x01,0x8e,0x0a,0x00,0x0e,0x00
	.byte 0x00,0x31,0x61,0x04,0x00,0x00,0x00,0x32
	.byte 0xb3,0x0f,0x00,0x00,0x01,0x8e,0x03,0xff
	.byte 0x00,0x05,0x00,0x00,0x31,0x50
	.ascii "GLboolean\0"
	.byte 0x03,0x10
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x02,0x00,0x00,0x34,0x52,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "Name\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x04,0x0d
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x08,0x0d
	.ascii "Priority\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x0c,0x0d
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x01,0x96,0x02,0x23,0x10,0x0d
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x20,0x0d
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x24,0x0d
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x28,0x0d
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x2c,0x0d
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x30,0x0d
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x34,0x0d
	.ascii "Image\0"
	.byte 0x00,0x00,0x32,0x8f,0x02,0x23,0x38,0x0d
	.ascii "Palette\0"
	.byte 0x00,0x00,0x32,0xa0,0x02,0x23,0x64,0x0d
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xe4,0x08
	.byte 0x0d
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x43,0x03,0x23,0xe8,0x08
	.byte 0x0d
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x43,0x03,0x23,0xec,0x08
	.byte 0x0d
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xf0,0x08
	.byte 0x0d
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x7c,0x03,0x23,0xf4,0x08
	.byte 0x0d
	.ascii "Complete\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xf8,0x08
	.byte 0x0d
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x34,0xc8,0x03,0x23,0xfc,0x08
	.byte 0x0d
	.ascii "Next\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0x80,0x09
	.byte 0x00,0x11,0x00,0x00,0x32,0xc3,0x07,0x00
	.byte 0x00,0x34,0x52,0x11,0x00,0x00,0x01,0x77
	.byte 0x07,0x00,0x00,0x34,0x5c,0x11,0x00,0x00
	.byte 0x01,0x77,0x07,0x00,0x00,0x34,0x66,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x34
	.byte 0x70,0x11,0x00,0x00,0x01,0x77,0x07,0x00
	.byte 0x00,0x34,0x7a,0x07,0x00,0x00,0x31,0x50
	.byte 0x12,0x01,0x01,0x00,0x00,0x34,0xc3,0x13
	.byte 0x00,0x00,0x34,0x57,0x13,0x00,0x00,0x01
	.byte 0x5e,0x13,0x00,0x00,0x34,0x61,0x13,0x00
	.byte 0x00,0x34,0x6b,0x13,0x00,0x00,0x34,0x75
	.byte 0x13,0x00,0x00,0x34,0x7f,0x13,0x00,0x00
	.byte 0x34,0x84,0x13,0x00,0x00,0x34,0x84,0x13
	.byte 0x00,0x00,0x34,0x84,0x13,0x00,0x00,0x34
	.byte 0x84,0x00,0x07,0x00,0x00,0x34,0x89,0x05
	.byte 0x00,0x00,0x34,0xc3
	.ascii "TextureSampleFunc\0"
	.byte 0x02,0x07,0x00,0x00,0x32,0xc3,0x0c
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x02,0x00,0x00,0x35,0x81,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x01,0x59,0x02,0x23,0x04,0x0d
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x01,0x59,0x02,0x23,0x08,0x0d
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x34,0xe0,0x02,0x23,0x0c,0x0d
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x34,0xe0,0x02,0x23,0x10,0x0d
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x34,0xe0,0x02,0x23,0x14,0x0d
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x34,0xe0,0x02,0x23,0x18,0x00
	.byte 0x07,0x00,0x00,0x34,0xe5,0x10
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x02,0x00,0x00,0x3c,0x53,0x0d
	.ascii "Shared\0"
	.byte 0x00,0x00,0x35,0x81,0x02,0x23,0x00,0x0d
	.ascii "API\0"
	.byte 0x00,0x00,0x55,0x3e,0x02,0x23,0x04,0x0d
	.ascii "Save\0"
	.byte 0x00,0x00,0x55,0x3e,0x03,0x23,0xe0,0x05
	.byte 0x0d
	.ascii "Exec\0"
	.byte 0x00,0x00,0x55,0x3e,0x03,0x23,0xbc,0x0b
	.byte 0x0d
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0x99,0x03,0x23,0x98,0x11
	.byte 0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x66,0xcd,0x03,0x23,0x9c,0x11
	.byte 0x0d
	.ascii "Driver\0"
	.byte 0x00,0x00,0x6f,0xdc,0x03,0x23,0xa0,0x11
	.byte 0x0d
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x31,0x7c,0x03,0x23,0xf4,0x12
	.byte 0x0d
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x31,0x7c,0x03,0x23,0xf8,0x12
	.byte 0x0d
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xfc,0x12
	.byte 0x0d
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0x80,0x13
	.byte 0x0d
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x74,0x44,0x03,0x23,0x84,0x13
	.byte 0x0d
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x74,0x55,0x03,0x23,0xc4,0x13
	.byte 0x0d
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0x84,0x14
	.byte 0x0d
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x74,0x77,0x03,0x23,0x88,0x14
	.byte 0x0d
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0x88,0x24
	.byte 0x0d
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0x8c,0x24
	.byte 0x0d
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x74,0x89,0x03,0x23,0x90,0x24
	.byte 0x0d
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xd0,0x24
	.byte 0x0d
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x74,0xab,0x03,0x23,0xd4,0x24
	.byte 0x0d
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x74,0xce,0x03,0x23,0xd4,0x34
	.byte 0x0d
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xd4,0x36
	.byte 0x0d
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xd8,0x36
	.byte 0x0d
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x74,0xe0,0x03,0x23,0xdc,0x36
	.byte 0x0d
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0x9c,0x37
	.byte 0x0d
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x75,0x02,0x03,0x23,0xa0,0x37
	.byte 0x0d
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xa0,0x3c
	.byte 0x0d
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xa4,0x3c
	.byte 0x0d
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xa5,0x3c
	.byte 0x0d
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xa8,0x3c
	.byte 0x0d
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x75,0x68,0x03,0x23,0xac,0x3c
	.byte 0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x75,0x8a,0x03,0x23,0xec,0x3c
	.byte 0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x75,0xd7,0x03,0x23,0xfc,0x3c
	.byte 0x0d
	.ascii "Current\0"
	.byte 0x00,0x00,0x77,0xec,0x03,0x23,0xd4,0x3d
	.byte 0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x78,0xd6,0x03,0x23,0xb4,0x3e
	.byte 0x0d
	.ascii "Eval\0"
	.byte 0x00,0x00,0x79,0x29,0x03,0x23,0xc0,0x3e
	.byte 0x0d
	.ascii "Fog\0"
	.byte 0x00,0x00,0x7b,0x9f,0x03,0x23,0xf8,0x3e
	.byte 0x0d
	.ascii "Hint\0"
	.byte 0x00,0x00,0x7c,0x18,0x03,0x23,0xa0,0x3f
	.byte 0x0d
	.ascii "Light\0"
	.byte 0x00,0x00,0x81,0x23,0x03,0x23,0xb4,0x3f
	.byte 0x0d
	.ascii "Line\0"
	.byte 0x00,0x00,0x82,0x53,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0d
	.ascii "List\0"
	.byte 0x00,0x00,0x82,0xcc,0x04,0x23,0x94,0xdc
	.byte 0x02,0x0d
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x83,0xb2,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0d
	.ascii "Point\0"
	.byte 0x00,0x00,0x86,0x82,0x04,0x23,0x80,0xad
	.byte 0x03,0x0d
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x86,0xfb,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0d
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x88,0x2e,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0d
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x88,0x4d,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0d
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x88,0xa8,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0d
	.ascii "Texture\0"
	.byte 0x00,0x00,0x8a,0x02,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0d
	.ascii "Transform\0"
	.byte 0x00,0x00,0x8c,0x64,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0d
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x8c,0xde,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0d
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0d
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x8d,0x85,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0d
	.ascii "Array\0"
	.byte 0x00,0x00,0x8d,0x9b,0x04,0x23,0xac,0xba
	.byte 0x03,0x0d
	.ascii "Pack\0"
	.byte 0x00,0x00,0x90,0x46,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0d
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x90,0x46,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0d
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x91,0xc8,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0d
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x93,0x52,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0d
	.ascii "Select\0"
	.byte 0x00,0x00,0x93,0xc7,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0d
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0d
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0d
	.ascii "NewState\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0d
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0d
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0d
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0d
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0d
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0d
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0d
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0d
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x01,0x80,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0d
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x01,0x80,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0d
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x01,0x80,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0d
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0d
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0d
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0d
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0d
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x17,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0d
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x4a,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0d
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x80,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0d
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xbf,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0d
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xf5,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0d
	.ascii "VB\0"
	.byte 0x00,0x00,0x94,0x8c,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0d
	.ascii "PB\0"
	.byte 0x00,0x00,0x94,0xa0,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0d
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0d
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x07,0x00,0x00,0x35,0x86,0x12
	.byte 0x01,0x01,0x00,0x00,0x3c,0x6f,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x77,0x00,0x07,0x00
	.byte 0x00,0x3c,0x58,0x12,0x01,0x01,0x00,0x00
	.byte 0x3c,0x8b,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x77,0x00,0x07,0x00,0x00,0x3c,0x74,0x11
	.byte 0x00,0x00,0x01,0x5e,0x07,0x00,0x00,0x3c
	.byte 0x90,0x14,0x01,0x00,0x00,0x31,0x50,0x01
	.byte 0x00,0x00,0x3c,0xba,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x3c,0x95,0x13,0x00,0x00,0x34,0x84
	.byte 0x00,0x07,0x00,0x00,0x3c,0x9a,0x12,0x01
	.byte 0x01,0x00,0x00,0x3c,0xd1,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x00
	.byte 0x07,0x00,0x00,0x3c,0xbf,0x12,0x01,0x01
	.byte 0x00,0x00,0x3c,0xe8,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x00,0x07
	.byte 0x00,0x00,0x3c,0xd6,0x12,0x01,0x01,0x00
	.byte 0x00,0x3d,0x04,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x07,0x00,0x00,0x3c,0xed
	.byte 0x05,0x00,0x00,0x31,0x74
	.ascii "GLvoid\0"
	.byte 0x03,0x07,0x00,0x00,0x3d,0x09,0x0c
	.ascii "gl_image\0"
	.byte 0x24,0x02,0x00,0x00,0x3d,0xb8,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x08,0x0d
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x0c,0x0d
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x10,0x0d
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x14,0x0d
	.ascii "Data\0"
	.byte 0x00,0x00,0x3d,0x16,0x02,0x23,0x18,0x0d
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x1c,0x0d
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x20,0x00
	.byte 0x11,0x00,0x00,0x3d,0x1b,0x07,0x00,0x00
	.byte 0x3d,0xb8,0x12,0x01,0x01,0x00,0x00,0x3d
	.byte 0xf2,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x3d
	.byte 0xbd,0x00,0x07,0x00,0x00,0x3d,0xc2,0x12
	.byte 0x01,0x01,0x00,0x00,0x3e,0x18,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x00
	.byte 0x07,0x00,0x00,0x3d,0xf7,0x12,0x01,0x01
	.byte 0x00,0x00,0x3e,0x2f,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x00,0x07
	.byte 0x00,0x00,0x3e,0x1d,0x12,0x01,0x01,0x00
	.byte 0x00,0x3e,0x4b,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0xa7,0x00,0x07,0x00,0x00,0x3e,0x34
	.byte 0x12,0x01,0x01,0x00,0x00,0x3e,0x62,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x5e,0x00,0x07,0x00,0x00,0x3e,0x50,0x11
	.byte 0x00,0x00,0x31,0x74,0x07,0x00,0x00,0x3e
	.byte 0x67,0x12,0x01,0x01,0x00,0x00,0x3e,0x8d
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x3e,0x6c,0x00,0x07,0x00,0x00
	.byte 0x3e,0x71,0x12,0x01,0x01,0x00,0x00,0x3e
	.byte 0xa4,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x3e
	.byte 0x92,0x12,0x01,0x01,0x00,0x00,0x3e,0xca
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x00,0x07,0x00,0x00,0x3e,0xa9,0x12
	.byte 0x01,0x01,0x00,0x00,0x3e,0xf0,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x00
	.byte 0x07,0x00,0x00,0x3e,0xcf,0x04
	.ascii "double\0"
	.byte 0x04,0x08,0x12,0x01,0x01,0x00,0x00,0x3f
	.byte 0x11,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x3e,0xf5,0x00,0x07,0x00,0x00,0x3e
	.byte 0xff,0x12,0x01,0x01,0x00,0x00,0x3f,0x28
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x77,0x00,0x07,0x00,0x00,0x3f,0x16
	.byte 0x12,0x01,0x01,0x00,0x00,0x3f,0x3f,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x3f,0x2d,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x3f
	.byte 0x44,0x12,0x01,0x01,0x00,0x00,0x3f,0x65
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x3f,0x49,0x00
	.byte 0x07,0x00,0x00,0x3f,0x4e,0x12,0x01,0x01
	.byte 0x00,0x00,0x3f,0x86,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x77,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x00,0x07,0x00,0x00,0x3f,0x6a,0x11,0x00
	.byte 0x00,0x01,0x77,0x07,0x00,0x00,0x3f,0x8b
	.byte 0x12,0x01,0x01
	.byte 0x00,0x00,0x3f,0xa7,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x3f,0x90,0x00,0x07
	.byte 0x00,0x00,0x3f,0x95,0x12,0x01,0x01,0x00
	.byte 0x00,0x3f,0xcd,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x00,0x07,0x00,0x00
	.byte 0x3f,0xac,0x11,0x00,0x00,0x01,0x77,0x07
	.byte 0x00,0x00,0x3f,0xd2,0x12,0x01,0x01,0x00
	.byte 0x00,0x3f,0xee,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x3f,0xd7,0x00,0x07,0x00
	.byte 0x00,0x3f,0xdc,0x12,0x01,0x01,0x00,0x00
	.byte 0x40,0x14,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x31,0x50,0x13,0x00,0x00,0x31
	.byte 0x50,0x13,0x00,0x00,0x31,0x50,0x13,0x00
	.byte 0x00,0x31,0x50,0x00,0x07,0x00,0x00,0x3f
	.byte 0xf3,0x11,0x00,0x00,0x31,0x50,0x07,0x00
	.byte 0x00,0x40,0x19,0x12,0x01,0x01,0x00,0x00
	.byte 0x40,0x35,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x40,0x1e,0x00,0x07,0x00,0x00
	.byte 0x40,0x23,0x12,0x01,0x01,0x00,0x00,0x40
	.byte 0x5b,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x31,0x50,0x13,0x00,0x00,0x31,0x50
	.byte 0x13,0x00,0x00,0x31,0x50,0x13,0x00,0x00
	.byte 0x31,0x50,0x00,0x07,0x00,0x00,0x40,0x3a
	.byte 0x12,0x01,0x01,0x00,0x00,0x40,0x77,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0xa7,0x00,0x07
	.byte 0x00,0x00,0x40,0x60,0x11,0x00,0x00,0x31
	.byte 0x74,0x07,0x00,0x00,0x40,0x7c,0x12,0x01
	.byte 0x01,0x00,0x00,0x40,0xa7,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x40,0x81,0x00,0x07
	.byte 0x00,0x00,0x40,0x86,0x07,0x00,0x00,0x3d
	.byte 0x1b,0x12,0x01,0x01,0x00,0x00,0x40,0xcd
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x40,0xac,0x00,0x07,0x00,0x00
	.byte 0x40,0xb1,0x12,0x01,0x01,0x00,0x00,0x40
	.byte 0xee,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x40,0xac,0x00,0x07,0x00
	.byte 0x00,0x40,0xd2,0x12,0x01,0x01,0x00,0x00
	.byte 0x41,0x19,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0xa7
	.byte 0x00,0x07,0x00,0x00,0x40,0xf3,0x12,0x01
	.byte 0x01,0x00,0x00,0x41,0x4e,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x00,0x07,0x00
	.byte 0x00,0x41,0x1e,0x12,0x01,0x01,0x00,0x00
	.byte 0x41,0x88,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x00
	.byte 0x07,0x00,0x00,0x41,0x53,0x12,0x01,0x01
	.byte 0x00,0x00,0x41,0xb8,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x00
	.byte 0x07,0x00,0x00,0x41,0x8d,0x12,0x01,0x01
	.byte 0x00,0x00,0x41,0xf2,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x41,0xbd,0x12
	.byte 0x01,0x01,0x00,0x00,0x42,0x31,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x00,0x07,0x00,0x00,0x41,0xf7,0x12,0x01
	.byte 0x01,0x00,0x00,0x42,0x48,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x00
	.byte 0x07,0x00,0x00,0x42,0x36,0x12,0x01,0x01
	.byte 0x00,0x00,0x42,0x64,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x5e,0x13,0x00
	.byte 0x00,0x01,0x3a,0x00,0x07,0x00,0x00,0x42
	.byte 0x4d,0x11,0x00,0x00,0x01,0x5e,0x07,0x00
	.byte 0x00,0x42,0x69,0x12,0x01,0x01,0x00,0x00
	.byte 0x42,0x8a,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x42
	.byte 0x6e,0x00,0x07,0x00,0x00,0x42,0x73,0x12
	.byte 0x01,0x01,0x00,0x00,0x42,0xa1,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x00,0x07,0x00,0x00,0x42,0x8f,0x12,0x01
	.byte 0x01,0x00,0x00,0x42,0xb8,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x31,0x50,0x00
	.byte 0x07,0x00,0x00,0x42,0xa6,0x12,0x01,0x01
	.byte 0x00,0x00,0x42,0xd4,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x3e,0xf5,0x13,0x00
	.byte 0x00,0x3e,0xf5,0x00,0x07,0x00,0x00,0x42
	.byte 0xbd,0x12,0x01,0x01,0x00,0x00,0x42,0xeb
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x00,0x07,0x00,0x00,0x42,0xd9
	.byte 0x12,0x01,0x01,0x00,0x00,0x43,0x02,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x07,0x00,0x00,0x42,0xf0,0x12
	.byte 0x01,0x01,0x00,0x00,0x43,0x23,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x00,0x07,0x00,0x00,0x43,0x07
	.byte 0x12,0x01,0x01,0x00,0x00,0x43,0x3a,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x07,0x00,0x00,0x43,0x28,0x11
	.byte 0x00,0x00,0x31,0x74,0x07,0x00,0x00,0x43
	.byte 0x3f,0x12,0x01,0x01,0x00,0x00,0x43,0x6a
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x43
	.byte 0x44,0x00,0x07,0x00,0x00,0x43,0x49,0x11
	.byte 0x00,0x00,0x31,0x74,0x07,0x00,0x00,0x43
	.byte 0x6f,0x12,0x01,0x01,0x00,0x00,0x43,0x9f
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x43,0x74,0x00,0x07
	.byte 0x00,0x00,0x43,0x79,0x12,0x01,0x01,0x00
	.byte 0x00,0x43,0xb6,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x31,0x50,0x00,0x07,0x00
	.byte 0x00,0x43,0xa4,0x11,0x00,0x00,0x31,0x50
	.byte 0x07,0x00,0x00,0x43,0xbb,0x12,0x01,0x01
	.byte 0x00,0x00,0x43,0xdc,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x43,0xc0,0x00,0x07,0x00,0x00,0x43
	.byte 0xc5,0x12,0x01,0x01,0x00,0x00,0x43,0xf3
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x00,0x07,0x00,0x00,0x43,0xe1
	.byte 0x12,0x01,0x01,0x00,0x00,0x44,0x0a,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x07,0x00,0x00,0x43,0xf8,0x12
	.byte 0x01,0x01,0x00,0x00,0x44,0x1c,0x13,0x00
	.byte 0x00,0x3c,0x53,0x00,0x07,0x00,0x00,0x44
	.byte 0x0f,0x12,0x01,0x01,0x00,0x00,0x44,0x2e
	.byte 0x13,0x00,0x00,0x3c,0x53,0x00,0x07,0x00
	.byte 0x00,0x44,0x21,0x12,0x01,0x01,0x00,0x00
	.byte 0x44,0x45,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x77,0x00,0x07,0x00,0x00
	.byte 0x44,0x33,0x12,0x01,0x01,0x00,0x00,0x44
	.byte 0x61,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x00,0x07,0x00,0x00,0x44,0x4a,0x12,0x01
	.byte 0x01,0x00,0x00,0x44,0x82,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x44,0x66,0x12
	.byte 0x01,0x01,0x00,0x00,0x44,0xad,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x00,0x07,0x00,0x00
	.byte 0x44,0x87,0x12,0x01,0x01,0x00,0x00,0x44
	.byte 0xc4,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x3a,0x00,0x07,0x00,0x00,0x44
	.byte 0xb2,0x12,0x01,0x01,0x00,0x00,0x44,0xe0
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x00
	.byte 0x07,0x00,0x00,0x44,0xc9,0x07,0x00,0x00
	.byte 0x01,0x77,0x12,0x01,0x01,0x00,0x00,0x45
	.byte 0x06,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x44,0xe5,0x00,0x07,0x00
	.byte 0x00,0x44,0xea,0x12,0x01,0x01,0x00,0x00
	.byte 0x45,0x18,0x13,0x00,0x00,0x3c,0x53,0x00
	.byte 0x07,0x00,0x00,0x45,0x0b,0x12,0x01,0x01
	.byte 0x00,0x00,0x45,0x2a,0x13,0x00,0x00,0x3c
	.byte 0x53,0x00,0x07,0x00,0x00,0x45,0x1d,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x45
	.byte 0x2f,0x12,0x01,0x01,0x00,0x00,0x45,0x50
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x45,0x34,0x00
	.byte 0x07,0x00,0x00,0x45,0x39,0x12,0x01,0x01
	.byte 0x00,0x00,0x45,0x67,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x00,0x07
	.byte 0x00,0x00,0x45,0x55,0x12,0x01,0x01,0x00
	.byte 0x00,0x45,0x97,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x3e,0xf5,0x13,0x00,0x00
	.byte 0x3e,0xf5,0x13,0x00,0x00,0x3e,0xf5,0x13
	.byte 0x00,0x00,0x3e,0xf5,0x13,0x00,0x00,0x3e
	.byte 0xf5,0x13,0x00,0x00,0x3e,0xf5,0x00,0x07
	.byte 0x00,0x00,0x45,0x6c,0x14,0x01,0x00,0x00
	.byte 0x01,0x5e,0x01,0x00,0x00,0x45,0xb2,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x45,0x9c,0x07
	.byte 0x00,0x00,0x01,0x5e,0x12,0x01,0x01,0x00
	.byte 0x00,0x45,0xd3,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x45,0xb7,0x00,0x07,0x00,0x00,0x45,0xbc
	.byte 0x12,0x01,0x01,0x00,0x00,0x45,0xef,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x34,0x84,0x00,0x07
	.byte 0x00,0x00,0x45,0xd8,0x07,0x00,0x00,0x3e
	.byte 0xf5,0x12,0x01,0x01,0x00,0x00,0x46,0x10
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x45,0xf4,0x00
	.byte 0x07,0x00,0x00,0x45,0xf9,0x12,0x01,0x01
	.byte 0x00,0x00,0x46,0x36,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x31,0x7c,0x00,0x07,0x00
	.byte 0x00,0x46,0x15,0x07,0x00,0x00,0x01,0x3a
	.byte 0x12,0x01,0x01,0x00,0x00,0x46,0x5c,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x46,0x3b,0x00,0x07,0x00,0x00,0x46
	.byte 0x40,0x12,0x01,0x01,0x00,0x00,0x46,0x78
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x45,0xf4,0x00
	.byte 0x07,0x00,0x00,0x46,0x61,0x14,0x01,0x00
	.byte 0x00,0x01,0xa7,0x01,0x00,0x00,0x46,0x8e
	.byte 0x13,0x00,0x00,0x3c,0x53,0x00,0x07,0x00
	.byte 0x00,0x46,0x7d,0x12,0x01,0x01,0x00,0x00
	.byte 0x46,0xaa,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x44
	.byte 0xe5,0x00,0x07,0x00,0x00,0x46,0x93,0x12
	.byte 0x01,0x01,0x00,0x00,0x46,0xc6,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x46,0x3b,0x00,0x07,0x00
	.byte 0x00,0x46,0xaf,0x11,0x00,0x00,0x31,0x50
	.byte 0x07,0x00,0x00,0x46,0xcb,0x14,0x01,0x00
	.byte 0x00,0x46,0xd0,0x01,0x00,0x00,0x46,0xeb
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x00,0x07,0x00,0x00,0x46,0xd5
	.byte 0x12,0x01,0x01,0x00,0x00,0x47,0x0c,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x44,0xe5,0x00,0x07,0x00,0x00,0x46
	.byte 0xf0,0x12,0x01,0x01,0x00,0x00,0x47,0x2d
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x46,0x3b,0x00,0x07,0x00,0x00
	.byte 0x47,0x11,0x12,0x01,0x01,0x00,0x00,0x47
	.byte 0x4e,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x45,0xf4,0x00,0x07,0x00
	.byte 0x00,0x47,0x32,0x12,0x01,0x01,0x00,0x00
	.byte 0x47,0x6f,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x44,0xe5,0x00,0x07
	.byte 0x00,0x00,0x47,0x53,0x12,0x01,0x01,0x00
	.byte 0x00,0x47,0x90,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x46,0x3b,0x00
	.byte 0x07,0x00,0x00,0x47,0x74,0x12,0x01,0x01
	.byte 0x00,0x00,0x47,0xb1,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x44,0xe5
	.byte 0x00,0x07,0x00,0x00,0x47,0x95,0x12,0x01
	.byte 0x01,0x00,0x00,0x47,0xd2,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x46
	.byte 0x3b,0x00,0x07,0x00,0x00,0x47,0xb6,0x12
	.byte 0x01,0x01,0x00,0x00,0x47,0xee,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x44,0xe5,0x00,0x07,0x00
	.byte 0x00,0x47,0xd7,0x12,0x01,0x01,0x00,0x00
	.byte 0x48,0x0a,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x45
	.byte 0xb7,0x00,0x07,0x00,0x00,0x47,0xf3,0x04
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x07,0x00,0x00,0x48,0x0f,0x12
	.byte 0x01,0x01,0x00,0x00,0x48,0x3d,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x48,0x21,0x00,0x07,0x00
	.byte 0x00,0x48,0x26,0x07,0x00,0x00,0x31,0x7c
	.byte 0x12,0x01,0x01,0x00,0x00,0x48,0x5e,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x48,0x42,0x00,0x07
	.byte 0x00,0x00,0x48,0x47,0x12,0x01,0x01,0x00
	.byte 0x00,0x48,0x75,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x34,0x84,0x00,0x07,0x00
	.byte 0x00,0x48,0x63,0x11,0x00,0x00,0x01,0x5e
	.byte 0x07,0x00,0x00,0x48,0x7a,0x11,0x00,0x00
	.byte 0x01,0x77,0x07,0x00,0x00,0x48,0x84,0x12
	.byte 0x01,0x01,0x00,0x00,0x48,0xaa,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x48,0x7f,0x13,0x00,0x00
	.byte 0x48,0x89,0x00,0x07,0x00,0x00,0x48,0x8e
	.byte 0x12,0x01,0x01,0x00,0x00,0x48,0xcb,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x44,0xe5,0x00,0x07,0x00,0x00,0x48
	.byte 0xaf,0x12,0x01,0x01,0x00,0x00,0x48,0xec
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x46,0x3b,0x00,0x07,0x00,0x00
	.byte 0x48,0xd0,0x12,0x01,0x01,0x00,0x00,0x49
	.byte 0x0d,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x45,0xf4,0x00,0x07,0x00
	.byte 0x00,0x48,0xf1,0x12,0x01,0x01,0x00,0x00
	.byte 0x49,0x2e,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x44,0xe5,0x00,0x07
	.byte 0x00,0x00,0x49,0x12,0x12,0x01,0x01,0x00
	.byte 0x00,0x49,0x4f,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x46,0x3b,0x00
	.byte 0x07,0x00,0x00,0x49,0x33,0x12,0x01,0x01
	.byte 0x00,0x00,0x49,0x7a,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x31,0x7c,0x00,0x07,0x00,0x00,0x49,0x54
	.byte 0x12,0x01,0x01,0x00,0x00,0x49,0xa0,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x44,0xe5
	.byte 0x00,0x07,0x00,0x00,0x49,0x7f,0x12,0x01
	.byte 0x01,0x00,0x00,0x49,0xc6,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x46,0x3b,0x00,0x07
	.byte 0x00,0x00,0x49,0xa5,0x12,0x01,0x01,0x00
	.byte 0x00,0x49,0xe7,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x44,0xe5,0x00
	.byte 0x07,0x00,0x00,0x49,0xcb,0x12,0x01,0x01
	.byte 0x00,0x00,0x4a,0x08,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x46,0x3b
	.byte 0x00,0x07,0x00,0x00,0x49,0xec,0x12,0x01
	.byte 0x01,0x00,0x00,0x4a,0x24,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x00,0x07,0x00,0x00
	.byte 0x4a,0x0d,0x12,0x01,0x01,0x00,0x00,0x4a
	.byte 0x3b,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x4a
	.byte 0x29,0x12,0x01,0x01,0x00,0x00,0x4a,0x52
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x77,0x00,0x07,0x00,0x00,0x4a,0x40
	.byte 0x12,0x01,0x01,0x00,0x00,0x4a,0x69,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x4a,0x57,0x11
	.byte 0x00,0x00,0x31,0x74,0x07,0x00,0x00,0x4a
	.byte 0x6e,0x12,0x01,0x01,0x00,0x00,0x4a,0x94
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x4a,0x73,0x00,0x07,0x00,0x00
	.byte 0x4a,0x78,0x12,0x01,0x01,0x00,0x00,0x4a
	.byte 0xa6,0x13,0x00,0x00,0x3c,0x53,0x00,0x07
	.byte 0x00,0x00,0x4a,0x99,0x11,0x00,0x00,0x31
	.byte 0x74,0x07,0x00,0x00,0x4a,0xab,0x12,0x01
	.byte 0x01,0x00,0x00,0x4a,0xd1,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x4a
	.byte 0xb0,0x00,0x07,0x00,0x00,0x4a,0xb5,0x14
	.byte 0x01,0x00,0x00,0x31,0x50,0x01,0x00,0x00
	.byte 0x4a,0xec,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x00,0x07,0x00,0x00
	.byte 0x4a,0xd6,0x14,0x01,0x00,0x00,0x31,0x50
	.byte 0x01,0x00,0x00,0x4b,0x07,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x5e,0x00
	.byte 0x07,0x00,0x00,0x4a,0xf1,0x14,0x01,0x00
	.byte 0x00,0x31,0x50,0x01,0x00,0x00,0x4b,0x22
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x07,0x00,0x00,0x4b,0x0c
	.byte 0x11,0x00,0x00,0x01,0x77,0x07,0x00,0x00
	.byte 0x4b,0x27,0x12,0x01,0x01,0x00,0x00,0x4b
	.byte 0x48,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x4b,0x2c
	.byte 0x00,0x07,0x00,0x00,0x4b,0x31,0x11,0x00
	.byte 0x00,0x01,0x77,0x07,0x00,0x00,0x4b,0x4d
	.byte 0x12,0x01,0x01,0x00,0x00,0x4b,0x78,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0xa7,0x13,0x00
	.byte 0x00,0x4b,0x52,0x13,0x00,0x00,0x01,0x3a
	.byte 0x00,0x07,0x00,0x00,0x4b,0x57,0x12,0x01
	.byte 0x01,0x00,0x00,0x4b,0x94,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x48,0x0f,0x00,0x07,0x00,0x00
	.byte 0x4b,0x7d,0x12,0x01,0x01,0x00,0x00,0x4b
	.byte 0xab,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x77,0x00,0x07,0x00,0x00,0x4b
	.byte 0x99,0x12,0x01,0x01,0x00,0x00,0x4b,0xc2
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x07,0x00,0x00,0x4b,0xb0
	.byte 0x12,0x01,0x01,0x00,0x00,0x4b,0xd4,0x13
	.byte 0x00,0x00,0x3c,0x53,0x00,0x07,0x00,0x00
	.byte 0x4b,0xc7,0x11,0x00,0x00,0x01,0x77,0x07
	.byte 0x00,0x00,0x4b,0xd9,0x12,0x01,0x01,0x00
	.byte 0x00,0x4b,0xf5,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x4b,0xde,0x00,0x07,0x00
	.byte 0x00,0x4b,0xe3,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0x0c,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x5e,0x00,0x07,0x00,0x00
	.byte 0x4b,0xfa,0x12,0x01,0x01,0x00,0x00,0x4c
	.byte 0x23,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x00,0x07,0x00,0x00,0x4c
	.byte 0x11,0x11,0x00,0x00,0x01,0x77,0x07,0x00
	.byte 0x00,0x4c,0x28,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0x62,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x4c,0x2d,0x13,0x00,0x00
	.byte 0x31,0x50,0x00,0x07,0x00,0x00,0x4c,0x32
	.byte 0x11,0x00,0x00,0x01,0x77,0x07,0x00,0x00
	.byte 0x4c,0x67,0x12,0x01,0x01,0x00,0x00,0x4c
	.byte 0xb5,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x4c,0x6c
	.byte 0x13,0x00,0x00,0x31,0x50,0x00,0x07,0x00
	.byte 0x00,0x4c,0x71,0x12,0x01,0x01,0x00,0x00
	.byte 0x4c,0xd6,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x4c,0xba,0x12,0x01,0x01,0x00
	.byte 0x00,0x4d,0x06,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x4c,0xdb,0x11,0x00,0x00,0x01
	.byte 0x77,0x07,0x00,0x00,0x4d,0x0b,0x12,0x01
	.byte 0x01,0x00,0x00,0x4d,0x31,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x4d
	.byte 0x10,0x00,0x07,0x00,0x00,0x4d,0x15,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0x48,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x00,0x07,0x00,0x00,0x4d,0x36,0x11,0x00
	.byte 0x00,0x01,0x77,0x07,0x00,0x00,0x4d,0x4d
	.byte 0x12,0x01,0x01,0x00,0x00,0x4d,0x69,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x4d
	.byte 0x52,0x00,0x07,0x00,0x00,0x4d,0x57,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0x85,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x5e
	.byte 0x13,0x00,0x00,0x01,0xa7,0x00,0x07,0x00
	.byte 0x00,0x4d,0x6e,0x12,0x01,0x01,0x00,0x00
	.byte 0x4d,0xa6,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x4d,0x8a,0x11,0x00,0x00,0x01
	.byte 0x77,0x07,0x00,0x00,0x4d,0xab,0x12,0x01
	.byte 0x01,0x00,0x00,0x4d,0xc7,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x4d,0xb0,0x00
	.byte 0x07,0x00,0x00,0x4d,0xb5,0x11,0x00,0x00
	.byte 0x31,0x74,0x07,0x00,0x00,0x4d,0xcc,0x12
	.byte 0x01,0x01,0x00,0x00,0x4d,0xf2,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x4d,0xd1,0x00,0x07,0x00,0x00,0x4d,0xd6
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0x22,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x3e
	.byte 0xf5,0x13,0x00,0x00,0x3e,0xf5,0x13,0x00
	.byte 0x00,0x3e,0xf5,0x13,0x00,0x00,0x3e,0xf5
	.byte 0x13,0x00,0x00,0x3e,0xf5,0x13,0x00,0x00
	.byte 0x3e,0xf5,0x00,0x07,0x00,0x00,0x4d,0xf7
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0x39,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x77,0x00,0x07,0x00,0x00,0x4e,0x27,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x4e
	.byte 0x3e,0x12,0x01,0x01,0x00,0x00,0x4e,0x64
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x4e,0x43,0x00,0x07,0x00,0x00
	.byte 0x4e,0x48,0x12,0x01,0x01,0x00,0x00,0x4e
	.byte 0x80,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0x3a
	.byte 0x00,0x07,0x00,0x00,0x4e,0x69,0x12,0x01
	.byte 0x01,0x00,0x00,0x4e,0x9c,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0x77,0x00,0x07,0x00,0x00
	.byte 0x4e,0x85,0x12,0x01,0x01,0x00,0x00,0x4e
	.byte 0xb8,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x00,0x07,0x00,0x00,0x4e,0xa1,0x11,0x00
	.byte 0x00,0x01,0x77,0x07,0x00,0x00,0x4e,0xbd
	.byte 0x12,0x01,0x01,0x00,0x00,0x4e,0xde,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x4e,0xc2,0x00,0x07
	.byte 0x00,0x00,0x4e,0xc7,0x12,0x01,0x01,0x00
	.byte 0x00,0x4e,0xf5,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x77,0x00,0x07,0x00
	.byte 0x00,0x4e,0xe3,0x12,0x01,0x01,0x00,0x00
	.byte 0x4f,0x11,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x07,0x00,0x00,0x4e,0xfa,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0x2d,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x00,0x07,0x00
	.byte 0x00,0x4f,0x16,0x11,0x00,0x00,0x31,0x50
	.byte 0x07,0x00,0x00,0x4f,0x32,0x12,0x01,0x01
	.byte 0x00,0x00,0x4f,0x4e,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x4f,0x37,0x00,0x07
	.byte 0x00,0x00,0x4f,0x3c,0x12,0x01,0x01,0x00
	.byte 0x00,0x4f,0x60,0x13,0x00,0x00,0x3c,0x53
	.byte 0x00,0x07,0x00,0x00,0x4f,0x53,0x12,0x01
	.byte 0x01,0x00,0x00,0x4f,0x72,0x13,0x00,0x00
	.byte 0x3c,0x53,0x00,0x07,0x00,0x00,0x4f,0x65
	.byte 0x12,0x01,0x01,0x00,0x00,0x4f,0x84,0x13
	.byte 0x00,0x00,0x3c,0x53,0x00
	.byte 0x07,0x00,0x00,0x4f,0x77,0x12,0x01,0x01
	.byte 0x00,0x00,0x4f,0x96,0x13,0x00,0x00,0x3c
	.byte 0x53,0x00,0x07,0x00,0x00,0x4f,0x89,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0xad,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x5e
	.byte 0x00,0x07,0x00,0x00,0x4f,0x9b,0x12,0x01
	.byte 0x01,0x00,0x00,0x4f,0xc4,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x5e,0x00
	.byte 0x07,0x00,0x00,0x4f,0xb2,0x12,0x01,0x01
	.byte 0x00,0x00,0x4f,0xd6,0x13,0x00,0x00,0x3c
	.byte 0x53,0x00,0x07,0x00,0x00,0x4f,0xc9,0x12
	.byte 0x01,0x01,0x00,0x00,0x4f,0xed,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x5e
	.byte 0x00,0x07,0x00,0x00,0x4f,0xdb,0x12,0x01
	.byte 0x01,0x00,0x00,0x50,0x13,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x4f,0xf2,0x12,0x01,0x01,0x00
	.byte 0x00,0x50,0x2a,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x00,0x07,0x00
	.byte 0x00,0x50,0x18,0x12,0x01,0x01,0x00,0x00
	.byte 0x50,0x5f,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x31,0x7c,0x00,0x07,0x00,0x00,0x50,0x2f
	.byte 0x12,0x01,0x01,0x00,0x00,0x50,0x85,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x00,0x07,0x00,0x00,0x50,0x64,0x14,0x01
	.byte 0x00,0x00,0x01,0x3a,0x01,0x00,0x00,0x50
	.byte 0xa0,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x00,0x07,0x00,0x00,0x50
	.byte 0x8a,0x12,0x01,0x01,0x00,0x00,0x50,0xc6
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x00,0x07,0x00,0x00,0x50,0xa5,0x12
	.byte 0x01,0x01,0x00,0x00,0x50,0xe7,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x00,0x07,0x00,0x00,0x50,0xcb
	.byte 0x12,0x01,0x01,0x00,0x00,0x51,0x0d,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x00,0x07,0x00,0x00,0x50,0xec,0x12,0x01
	.byte 0x01,0x00,0x00,0x51,0x29,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x45,0xb7,0x00,0x07,0x00,0x00
	.byte 0x51,0x12,0x12,0x01,0x01,0x00,0x00,0x51
	.byte 0x40,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x00,0x07,0x00,0x00,0x51
	.byte 0x2e,0x12,0x01,0x01,0x00,0x00,0x51,0x61
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x5e,0x00,0x07,0x00,0x00
	.byte 0x51,0x45,0x12,0x01,0x01,0x00,0x00,0x51
	.byte 0x78,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x51
	.byte 0x66,0x12,0x01,0x01,0x00,0x00,0x51,0x99
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x00,0x07,0x00,0x00
	.byte 0x51,0x7d,0x12,0x01,0x01,0x00,0x00,0x51
	.byte 0xb5,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x00,0x07,0x00,0x00,0x51,0x9e,0x12,0x01
	.byte 0x01,0x00,0x00,0x51,0xdb,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x51,0xba,0x11,0x00,0x00,0x31
	.byte 0x74,0x07,0x00,0x00,0x51,0xe0,0x12,0x01
	.byte 0x01,0x00,0x00,0x52,0x0b,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x51,0xe5,0x00,0x07
	.byte 0x00,0x00,0x51,0xea,0x11,0x00,0x00,0x01
	.byte 0x77,0x07,0x00,0x00,0x52,0x10,0x12,0x01
	.byte 0x01,0x00,0x00,0x52,0x36,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x52
	.byte 0x15,0x00,0x07,0x00,0x00,0x52,0x1a,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x52
	.byte 0x3b,0x12,0x01,0x01,0x00,0x00,0x52,0x61
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x52,0x40,0x00,0x07,0x00,0x00
	.byte 0x52,0x45,0x12,0x01,0x01,0x00,0x00,0x52
	.byte 0x9b,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x40,0xac,0x00,0x07
	.byte 0x00,0x00,0x52,0x66,0x12,0x01,0x01,0x00
	.byte 0x00,0x52,0xda,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x40,0xac,0x00,0x07,0x00
	.byte 0x00,0x52,0xa0,0x12,0x01,0x01,0x00,0x00
	.byte 0x53,0x0f,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x40,0xac,0x00,0x07,0x00,0x00,0x52,0xdf
	.byte 0x12,0x01,0x01,0x00,0x00,0x53,0x4e,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x40
	.byte 0xac,0x00,0x07,0x00,0x00,0x53,0x14,0x12
	.byte 0x01,0x01,0x00,0x00,0x53,0x92,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0xa7,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x40,0xac,0x00,0x07,0x00
	.byte 0x00,0x53,0x53,0x12,0x01,0x01,0x00,0x00
	.byte 0x53,0xdb,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x40,0xac,0x00,0x07
	.byte 0x00,0x00,0x53,0x97,0x11,0x00,0x00,0x01
	.byte 0x77,0x07,0x00,0x00,0x53,0xe0,0x12,0x01
	.byte 0x01,0x00,0x00,0x54,0x06,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x53
	.byte 0xe5,0x00,0x07,0x00,0x00,0x53,0xea,0x12
	.byte 0x01,0x01,0x00,0x00,0x54,0x27,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x00,0x07,0x00,0x00,0x54,0x0b
	.byte 0x12,0x01,0x01,0x00,0x00,0x54,0x43,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x01,0x77,0x00,0x07
	.byte 0x00,0x00,0x54,0x2c,0x12,0x01,0x01,0x00
	.byte 0x00,0x54,0x64,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x00
	.byte 0x07,0x00,0x00,0x54,0x48,0x12,0x01,0x01
	.byte 0x00,0x00,0x54,0x8a,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x77,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x00,0x07,0x00
	.byte 0x00,0x54,0x69,0x11,0x00,0x00,0x01,0x77
	.byte 0x07,0x00,0x00,0x54,0x8f,0x12,0x01,0x01
	.byte 0x00,0x00,0x54,0xab,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x54,0x94,0x00,0x07
	.byte 0x00,0x00,0x54,0x99,0x11,0x00,0x00,0x31
	.byte 0x74,0x07,0x00,0x00,0x54,0xb0,0x12,0x01
	.byte 0x01,0x00,0x00,0x54,0xdb,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x54,0xb5,0x00,0x07
	.byte 0x00,0x00,0x54,0xba,0x12,0x01,0x01,0x00
	.byte 0x00,0x55,0x01,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x00,0x07,0x00,0x00
	.byte 0x54,0xe0,0x12,0x01,0x01,0x00,0x00,0x55
	.byte 0x27,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x77,0x13,0x00,0x00,0x01,0x77
	.byte 0x13,0x00,0x00,0x01,0x77,0x13,0x00,0x00
	.byte 0x01,0x77,0x00,0x07,0x00,0x00,0x55,0x06
	.byte 0x12,0x01,0x01,0x00,0x00,0x55,0x39,0x13
	.byte 0x00,0x00,0x3c,0x53,0x00,0x07,0x00,0x00
	.byte 0x55,0x2c,0x10
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x02,0x00,0x00,0x63,0xe2,0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x3c,0x6f,0x02,0x23,0x00,0x0d
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x3c,0x8b,0x02,0x23,0x04,0x0d
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x3c,0xba,0x02,0x23,0x08,0x0d
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x3c,0xd1,0x02,0x23,0x0c,0x0d
	.ascii "Begin\0"
	.byte 0x00,0x00,0x3c,0xe8,0x02,0x23,0x10,0x0d
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x3d,0x04,0x02,0x23,0x14,0x0d
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x3d,0xf2,0x02,0x23,0x18,0x0d
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x3e,0x18,0x02,0x23,0x1c,0x0d
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x3e,0x2f,0x02,0x23,0x20,0x0d
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x3e,0x4b,0x02,0x23,0x24,0x0d
	.ascii "CallList\0"
	.byte 0x00,0x00,0x3e,0x62,0x02,0x23,0x28,0x0d
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x3e,0x8d,0x02,0x23,0x2c,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x3e,0xa4,0x02,0x23,0x30,0x0d
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x3e,0xca,0x02,0x23,0x34,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x3e,0xf0,0x02,0x23,0x38,0x0d
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x3f,0x11,0x02,0x23,0x3c,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x3f,0x28,0x02,0x23,0x40,0x0d
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x3f,0x3f,0x02,0x23,0x44,0x0d
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x3f,0x65,0x02,0x23,0x48,0x0d
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x3f,0x86,0x02,0x23,0x4c,0x0d
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x3f,0xa7,0x02,0x23,0x50,0x0d
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x3f,0xcd,0x02,0x23,0x54,0x0d
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x3f,0xee,0x02,0x23,0x58,0x0d
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x40,0x14,0x02,0x23,0x5c,0x0d
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x40,0x35,0x02,0x23,0x60,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x40,0x5b,0x02,0x23,0x64,0x0d
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x40,0x77,0x02,0x23,0x68,0x0d
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x40,0xa7,0x02,0x23,0x6c,0x0d
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x40,0xcd,0x02,0x23,0x70,0x0d
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x40,0xee,0x02,0x23,0x74,0x0d
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x41,0x19,0x02,0x23,0x78,0x0d
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x41,0x4e,0x02,0x23,0x7c,0x0d
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x41,0x88,0x03,0x23,0x80,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x41,0xb8,0x03,0x23,0x84,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x41,0xf2,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x42,0x31,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x42,0x48,0x03,0x23,0x90,0x01
	.byte 0x0d
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x42,0x64,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x42,0x8a,0x03,0x23,0x98,0x01
	.byte 0x0d
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x42,0xa1,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x42,0xb8,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x42,0xd4,0x03,0x23,0xa4,0x01
	.byte 0x0d
	.ascii "Disable\0"
	.byte 0x00,0x00,0x42,0xeb,0x03,0x23,0xa8,0x01
	.byte 0x0d
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x43,0x02,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x43,0x23,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x43,0x3a,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x43,0x6a,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x43,0x9f,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x43,0xb6,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x43,0xdc,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "Enable\0"
	.byte 0x00,0x00,0x43,0xf3,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x44,0x0a,0x03,0x23,0xcc,0x01
	.byte 0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x44,0x1c,0x03,0x23,0xd0,0x01
	.byte 0x0d
	.ascii "EndList\0"
	.byte 0x00,0x00,0x44,0x2e,0x03,0x23,0xd4,0x01
	.byte 0x0d
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x44,0x45,0x03,0x23,0xd8,0x01
	.byte 0x0d
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x44,0x61,0x03,0x23,0xdc,0x01
	.byte 0x0d
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x44,0x82,0x03,0x23,0xe0,0x01
	.byte 0x0d
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x44,0xad,0x03,0x23,0xe4,0x01
	.byte 0x0d
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x44,0xc4,0x03,0x23,0xe8,0x01
	.byte 0x0d
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x44,0xe0,0x03,0x23,0xec,0x01
	.byte 0x0d
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x45,0x06,0x03,0x23,0xf0,0x01
	.byte 0x0d
	.ascii "Finish\0"
	.byte 0x00,0x00,0x45,0x18,0x03,0x23,0xf4,0x01
	.byte 0x0d
	.ascii "Flush\0"
	.byte 0x00,0x00,0x45,0x2a,0x03,0x23,0xf8,0x01
	.byte 0x0d
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x45,0x50,0x03,0x23,0xfc,0x01
	.byte 0x0d
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x45,0x67,0x03,0x23,0x80,0x02
	.byte 0x0d
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x45,0x97,0x03,0x23,0x84,0x02
	.byte 0x0d
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x45,0xb2,0x03,0x23,0x88,0x02
	.byte 0x0d
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x45,0xd3,0x03,0x23,0x8c,0x02
	.byte 0x0d
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x45,0xef,0x03,0x23,0x90,0x02
	.byte 0x0d
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x46,0x10,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x46,0x36,0x03,0x23,0x98,0x02
	.byte 0x0d
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x46,0x5c,0x03,0x23,0x9c,0x02
	.byte 0x0d
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x46,0x78,0x03,0x23,0xa0,0x02
	.byte 0x0d
	.ascii "GetError\0"
	.byte 0x00,0x00,0x46,0x8e,0x03,0x23,0xa4,0x02
	.byte 0x0d
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x46,0xaa,0x03,0x23,0xa8,0x02
	.byte 0x0d
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x46,0xc6,0x03,0x23,0xac,0x02
	.byte 0x0d
	.ascii "GetString\0"
	.byte 0x00,0x00,0x46,0xeb,0x03,0x23,0xb0,0x02
	.byte 0x0d
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x47,0x0c,0x03,0x23,0xb4,0x02
	.byte 0x0d
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x47,0x2d,0x03,0x23,0xb8,0x02
	.byte 0x0d
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x47,0x4e,0x03,0x23,0xbc,0x02
	.byte 0x0d
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x47,0x6f,0x03,0x23,0xc0,0x02
	.byte 0x0d
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x47,0x90,0x03,0x23,0xc4,0x02
	.byte 0x0d
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x47,0xb1,0x03,0x23,0xc8,0x02
	.byte 0x0d
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x47,0xd2,0x03,0x23,0xcc,0x02
	.byte 0x0d
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x47,0xee,0x03,0x23,0xd0,0x02
	.byte 0x0d
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x48,0x0a,0x03,0x23,0xd4,0x02
	.byte 0x0d
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x48,0x3d,0x03,0x23,0xd8,0x02
	.byte 0x0d
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x48,0x5e,0x03,0x23,0xdc,0x02
	.byte 0x0d
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x48,0x75,0x03,0x23,0xe0,0x02
	.byte 0x0d
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x48,0xaa,0x03,0x23,0xe4,0x02
	.byte 0x0d
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x48,0xcb,0x03,0x23,0xe8,0x02
	.byte 0x0d
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x48,0xec,0x03,0x23,0xec,0x02
	.byte 0x0d
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x49,0x0d,0x03,0x23,0xf0,0x02
	.byte 0x0d
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x49,0x2e,0x03,0x23,0xf4,0x02
	.byte 0x0d
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x49,0x4f,0x03,0x23,0xf8,0x02
	.byte 0x0d
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x49,0x7a,0x03,0x23,0xfc,0x02
	.byte 0x0d
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x49,0xa0,0x03,0x23,0x80,0x03
	.byte 0x0d
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x49,0xc6,0x03,0x23,0x84,0x03
	.byte 0x0d
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x49,0xe7,0x03,0x23,0x88,0x03
	.byte 0x0d
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x4a,0x08,0x03,0x23,0x8c,0x03
	.byte 0x0d
	.ascii "Hint\0"
	.byte 0x00,0x00,0x4a,0x24,0x03,0x23,0x90,0x03
	.byte 0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x4a,0x3b,0x03,0x23,0x94,0x03
	.byte 0x0d
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x4a,0x52,0x03,0x23,0x98,0x03
	.byte 0x0d
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x4a,0x69,0x03,0x23,0x9c,0x03
	.byte 0x0d
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x4a,0x94,0x03,0x23,0xa0,0x03
	.byte 0x0d
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x4a,0xa6,0x03,0x23,0xa4,0x03
	.byte 0x0d
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x4a,0xd1,0x03,0x23,0xa8,0x03
	.byte 0x0d
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x4a,0xec,0x03,0x23,0xac,0x03
	.byte 0x0d
	.ascii "IsList\0"
	.byte 0x00,0x00,0x4b,0x07,0x03,0x23,0xb0,0x03
	.byte 0x0d
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x4b,0x22,0x03,0x23,0xb4,0x03
	.byte 0x0d
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x4b,0x48,0x03,0x23,0xb8,0x03
	.byte 0x0d
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x4b,0x78,0x03,0x23,0xbc,0x03
	.byte 0x0d
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x4b,0x94,0x03,0x23,0xc0,0x03
	.byte 0x0d
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x4b,0xab,0x03,0x23,0xc4,0x03
	.byte 0x0d
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x4b,0xc2,0x03,0x23,0xc8,0x03
	.byte 0x0d
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x4b,0xd4,0x03,0x23,0xcc,0x03
	.byte 0x0d
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x4b,0xf5,0x03,0x23,0xd0,0x03
	.byte 0x0d
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x4c,0x0c,0x03,0x23,0xd4,0x03
	.byte 0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x4c,0x23,0x03,0x23,0xd8,0x03
	.byte 0x0d
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x4c,0x62,0x03,0x23,0xdc,0x03
	.byte 0x0d
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x4c,0xb5,0x03,0x23,0xe0,0x03
	.byte 0x0d
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x4c,0xd6,0x03,0x23,0xe4,0x03
	.byte 0x0d
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x4d,0x06,0x03,0x23,0xe8,0x03
	.byte 0x0d
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x4d,0x31,0x03,0x23,0xec,0x03
	.byte 0x0d
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x4d,0x48,0x03,0x23,0xf0,0x03
	.byte 0x0d
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x4d,0x69,0x03,0x23,0xf4,0x03
	.byte 0x0d
	.ascii "NewList\0"
	.byte 0x00,0x00,0x4d,0x85,0x03,0x23,0xf8,0x03
	.byte 0x0d
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x4d,0xa6,0x03,0x23,0xfc,0x03
	.byte 0x0d
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x4d,0xc7,0x03,0x23,0x80,0x04
	.byte 0x0d
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x4d,0xf2,0x03,0x23,0x84,0x04
	.byte 0x0d
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x4e,0x22,0x03,0x23,0x88,0x04
	.byte 0x0d
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x4e,0x39,0x03,0x23,0x8c,0x04
	.byte 0x0d
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x4e,0x64,0x03,0x23,0x90,0x04
	.byte 0x0d
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x4e,0x80,0x03,0x23,0x94,0x04
	.byte 0x0d
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x4e,0x9c,0x03,0x23,0x98,0x04
	.byte 0x0d
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x4e,0xb8,0x03,0x23,0x9c,0x04
	.byte 0x0d
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x4e,0xde,0x03,0x23,0xa0,0x04
	.byte 0x0d
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x4e,0xf5,0x03,0x23,0xa4,0x04
	.byte 0x0d
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x4f,0x11,0x03,0x23,0xa8,0x04
	.byte 0x0d
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x4f,0x2d,0x03,0x23,0xac,0x04
	.byte 0x0d
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x4f,0x4e,0x03,0x23,0xb0,0x04
	.byte 0x0d
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x4f,0x60,0x03,0x23,0xb4,0x04
	.byte 0x0d
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x4f,0x72,0x03,0x23,0xb8,0x04
	.byte 0x0d
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x4f,0x84,0x03,0x23,0xbc,0x04
	.byte 0x0d
	.ascii "PopName\0"
	.byte 0x00,0x00,0x4f,0x96,0x03,0x23,0xc0,0x04
	.byte 0x0d
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x4f,0xad,0x03,0x23,0xc4,0x04
	.byte 0x0d
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x4f,0xc4,0x03,0x23,0xc8,0x04
	.byte 0x0d
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x4f,0xd6,0x03,0x23,0xcc,0x04
	.byte 0x0d
	.ascii "PushName\0"
	.byte 0x00,0x00,0x4f,0xed,0x03,0x23,0xd0,0x04
	.byte 0x0d
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x50,0x13,0x03,0x23,0xd4,0x04
	.byte 0x0d
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x50,0x2a,0x03,0x23,0xd8,0x04
	.byte 0x0d
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x50,0x5f,0x03,0x23,0xdc,0x04
	.byte 0x0d
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x50,0x85,0x03,0x23,0xe0,0x04
	.byte 0x0d
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x50,0xa0,0x03,0x23,0xe4,0x04
	.byte 0x0d
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x50,0xc6,0x03,0x23,0xe8,0x04
	.byte 0x0d
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x50,0xe7,0x03,0x23,0xec,0x04
	.byte 0x0d
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x51,0x0d,0x03,0x23,0xf0,0x04
	.byte 0x0d
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x51,0x29,0x03,0x23,0xf4,0x04
	.byte 0x0d
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x51,0x40,0x03,0x23,0xf8,0x04
	.byte 0x0d
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x51,0x61,0x03,0x23,0xfc,0x04
	.byte 0x0d
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x51,0x78,0x03,0x23,0x80,0x05
	.byte 0x0d
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x51,0x99,0x03,0x23,0x84,0x05
	.byte 0x0d
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x51,0xb5,0x03,0x23,0x88,0x05
	.byte 0x0d
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x51,0xdb,0x03,0x23,0x8c,0x05
	.byte 0x0d
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x52,0x0b,0x03,0x23,0x90,0x05
	.byte 0x0d
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x52,0x36,0x03,0x23,0x94,0x05
	.byte 0x0d
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x52,0x61,0x03,0x23,0x98,0x05
	.byte 0x0d
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x52,0x9b,0x03,0x23,0x9c,0x05
	.byte 0x0d
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x52,0xda,0x03,0x23,0xa0,0x05
	.byte 0x0d
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x53,0x0f,0x03,0x23,0xa4,0x05
	.byte 0x0d
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x53,0x4e,0x03,0x23,0xa8,0x05
	.byte 0x0d
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x53,0x92,0x03,0x23,0xac,0x05
	.byte 0x0d
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x53,0xdb,0x03,0x23,0xb0,0x05
	.byte 0x0d
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x54,0x06,0x03,0x23,0xb4,0x05
	.byte 0x0d
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x54,0x27,0x03,0x23,0xb8,0x05
	.byte 0x0d
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x54,0x43,0x03,0x23,0xbc,0x05
	.byte 0x0d
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x54,0x64,0x03,0x23,0xc0,0x05
	.byte 0x0d
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x54,0x8a,0x03,0x23,0xc4,0x05
	.byte 0x0d
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x54,0xab,0x03,0x23,0xc8,0x05
	.byte 0x0d
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x54,0xdb,0x03,0x23,0xcc,0x05
	.byte 0x0d
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x55,0x01,0x03,0x23,0xd0,0x05
	.byte 0x0d
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x55,0x27,0x03,0x23,0xd4,0x05
	.byte 0x0d
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x55,0x39,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0c
	.ascii "gl_visual\0"
	.byte 0x4c,0x02,0x00,0x00,0x65,0x8a,0x0d
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x01,0x0d
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0d
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x0d
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x0c,0x0d
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x10,0x0d
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x14,0x0d
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x20,0x0d
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x24,0x0d
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x28,0x0d
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x2c,0x0d
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x30,0x0d
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x34,0x0d
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x38,0x0d
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x3c,0x0d
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x40,0x0d
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x44,0x0d
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x48,0x0d
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x49,0x00
	.byte 0x05,0x00,0x00,0x63,0xe2
	.ascii "GLvisual\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0x8a,0x05,0x00
	.byte 0x00,0x48,0x0f
	.ascii "GLdepth\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0x9e,0x05,0x00
	.byte 0x00,0x31,0x50
	.ascii "GLstencil\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0xb1,0x04
	.ascii "short\0"
	.byte 0x05,0x02,0x05,0x00,0x00,0x65,0xc6
	.ascii "GLaccum\0"
	.byte 0x02,0x07,0x00,0x00,0x65,0xcf,0x0c
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x02,0x00,0x00,0x66,0xb9,0x0d
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0x99,0x02,0x23,0x00,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x08,0x0d
	.ascii "Depth\0"
	.byte 0x00,0x00,0x65,0xac,0x02,0x23,0x0c,0x0d
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x65,0xc1,0x02,0x23,0x10,0x0d
	.ascii "Accum\0"
	.byte 0x00,0x00,0x65,0xdd,0x02,0x23,0x14,0x0d
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0x6f,0x02,0x23,0x18,0x0d
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0x6f,0x02,0x23,0x1c,0x0d
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0x6f,0x02,0x23,0x20,0x0d
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x24,0x0d
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x28,0x0d
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x2c,0x0d
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x30,0x00
	.byte 0x05,0x00,0x00,0x65,0xe2
	.ascii "GLframebuffer\0"
	.byte 0x02,0x07,0x00,0x00,0x66,0xb9,0x04
	.ascii "char\0"
	.byte 0x06,0x01,0x11,0x00,0x00,0x66,0xd2,0x07
	.byte 0x00,0x00,0x66,0xda,0x15,0x01,0x00,0x00
	.byte 0x66,0xdf,0x01,0x07,0x00,0x00,0x66,0xe4
	.byte 0x12,0x01,0x01,0x00,0x00,0x66,0xfd,0x13
	.byte 0x00,0x00,0x3c,0x53,0x00,0x07,0x00,0x00
	.byte 0x66,0xf0,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0x14,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x67
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x67,0x3a
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x31,0x50,0x13,0x00,0x00,0x31,0x50,0x13
	.byte 0x00,0x00,0x31,0x50,0x13,0x00,0x00,0x31
	.byte 0x50,0x00,0x07,0x00,0x00,0x67,0x19,0x12
	.byte 0x01,0x01,0x00,0x00,0x67,0x65,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x31,0x50
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x00,0x07,0x00,0x00
	.byte 0x67,0x3f,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0x7c,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x67
	.byte 0x6a,0x12,0x01,0x01,0x00,0x00,0x67,0xa2
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x31,0x50,0x13,0x00,0x00,0x31,0x50,0x13
	.byte 0x00,0x00,0x31,0x50,0x13,0x00,0x00,0x31
	.byte 0x50,0x00,0x07,0x00,0x00,0x67,0x81,0x14
	.byte 0x01,0x00,0x00,0x31,0x50,0x01,0x00,0x00
	.byte 0x67,0xbd,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0xa7,0x00,0x07,0x00,0x00
	.byte 0x67,0xa7,0x12,0x01,0x01,0x00,0x00,0x67
	.byte 0xd9,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x45,0xb7,0x13,0x00,0x00,0x45,0xb7
	.byte 0x00,0x07,0x00,0x00,0x67,0xc2,0x11,0x00
	.byte 0x00,0x31,0x50,0x07,0x00,0x00,0x67,0xde
	.byte 0x11,0x00,0x00,0x31,0x50,0x07,0x00,0x00
	.byte 0x67,0xe8,0x11,0x00,0x00,0x31,0x50,0x07
	.byte 0x00,0x00,0x67,0xf2,0x11,0x00,0x00,0x31
	.byte 0x50,0x07,0x00,0x00,0x67,0xfc,0x11,0x00
	.byte 0x00,0x31,0x50,0x07,0x00,0x00,0x68,0x06
	.byte 0x12,0x01,0x01,0x00,0x00,0x68,0x45,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x5e,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x67,0xe3
	.byte 0x13,0x00,0x00,0x67,0xed,0x13,0x00,0x00
	.byte 0x67,0xf7,0x13,0x00,0x00,0x68,0x01,0x13
	.byte 0x00,0x00,0x68,0x0b,0x00,0x07,0x00,0x00
	.byte 0x68,0x10,0x11,0x00,0x00,0x31,0x50,0x07
	.byte 0x00,0x00,0x68,0x4a,0x12,0x01,0x01,0x00
	.byte 0x00,0x68,0x75,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x5e,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x68,0x4f,0x00,0x07,0x00,0x00
	.byte 0x68,0x54,0x11,0x00,0x00,0x01,0x3a,0x07
	.byte 0x00,0x00,0x68,0x7a,0x11,0x00,0x00,0x01
	.byte 0x3a,0x07,0x00,0x00,0x68,0x84,0x11,0x00
	.byte 0x00,0x31,0x50,0x07,0x00,0x00,0x68,0x8e
	.byte 0x11,0x00,0x00,0x31,0x50,0x07,0x00,0x00
	.byte 0x68,0x98,0x11,0x00,0x00,0x31,0x50,0x07
	.byte 0x00,0x00,0x68,0xa2,0x11,0x00,0x00,0x31
	.byte 0x50,0x07,0x00,0x00,0x68,0xac,0x11,0x00
	.byte 0x00,0x31,0x50,0x07,0x00,0x00,0x68,0xb6
	.byte 0x12,0x01,0x01,0x00,0x00,0x68,0xf5,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x5e,0x13,0x00,0x00,0x68,0x7f,0x13,0x00
	.byte 0x00,0x68,0x89,0x13,0x00,0x00,0x68,0x93
	.byte 0x13,0x00,0x00,0x68,0x9d,0x13,0x00,0x00
	.byte 0x68,0xa7,0x13,0x00,0x00,0x68,0xb1,0x13
	.byte 0x00,0x00,0x68,0xbb,0x00,0x07,0x00,0x00
	.byte 0x68,0xc0,0x11,0x00,0x00,0x01,0x3a,0x07
	.byte 0x00,0x00,0x68,0xfa,0x11,0x00,0x00,0x01
	.byte 0x3a,0x07,0x00,0x00,0x69,0x04,0x11,0x00
	.byte 0x00,0x31,0x50,0x07,0x00,0x00,0x69,0x0e
	.byte 0x12,0x01,0x01,0x00,0x00,0x69,0x39,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x5e,0x13,0x00,0x00,0x68,0xff,0x13,0x00
	.byte 0x00,0x69,0x09,0x13,0x00,0x00,0x69,0x13
	.byte 0x00,0x07,0x00,0x00,0x69,0x18,0x11,0x00
	.byte 0x00,0x01,0x5e,0x07,0x00,0x00,0x69,0x3e
	.byte 0x11,0x00,0x00,0x31,0x50,0x07,0x00,0x00
	.byte 0x69,0x48,0x12,0x01,0x01,0x00,0x00,0x69
	.byte 0x78,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x69,0x43,0x13,0x00,0x00,0x69,0x4d,0x00
	.byte 0x07,0x00,0x00,0x69,0x52,0x11,0x00,0x00
	.byte 0x31,0x50,0x07,0x00,0x00,0x69,0x7d,0x12
	.byte 0x01,0x01,0x00,0x00,0x69,0xa8,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x5e
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x69,0x82,0x00
	.byte 0x07,0x00,0x00,0x69,0x87,0x11,0x00,0x00
	.byte 0x01,0x3a,0x07,0x00,0x00,0x69,0xad,0x11
	.byte 0x00,0x00,0x01,0x3a,0x07,0x00,0x00,0x69
	.byte 0xb7,0x11,0x00,0x00,0x01,0x5e,0x07,0x00
	.byte 0x00,0x69,0xc1,0x11,0x00,0x00,0x31,0x50
	.byte 0x07,0x00,0x00,0x69,0xcb,0x12,0x01,0x01
	.byte 0x00,0x00,0x69,0xfb,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x5e,0x13,0x00
	.byte 0x00,0x69,0xb2,0x13,0x00,0x00,0x69,0xbc
	.byte 0x13,0x00,0x00,0x69,0xc6,0x13,0x00,0x00
	.byte 0x69,0xd0,0x00,0x07,0x00,0x00,0x69,0xd5
	.byte 0x11,0x00,0x00,0x01,0x3a,0x07,0x00,0x00
	.byte 0x6a,0x00,0x11,0x00,0x00,0x01,0x3a,0x07
	.byte 0x00,0x00,0x6a,0x0a,0x11,0x00,0x00,0x31
	.byte 0x50,0x07,0x00,0x00,0x6a,0x14,0x12,0x01
	.byte 0x01,0x00,0x00,0x6a,0x3f,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x5e,0x13
	.byte 0x00,0x00,0x6a,0x05,0x13,0x00,0x00,0x6a
	.byte 0x0f,0x13,0x00,0x00,0x6a,0x19,0x00,0x07
	.byte 0x00,0x00,0x6a,0x1e,0x12,0x01,0x01,0x00
	.byte 0x00,0x6a,0x65,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x5e,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x45,0xb7,0x00,0x07,0x00,0x00
	.byte 0x6a,0x44,0x12,0x01,0x01,0x00,0x00,0x6a
	.byte 0x9a,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x01,0x5e,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x34,0x84,0x13,0x00,0x00,0x34,0x84,0x13
	.byte 0x00,0x00,0x34,0x84,0x13,0x00,0x00,0x34
	.byte 0x84,0x00,0x07,0x00,0x00,0x6a,0x6a,0x11
	.byte 0x00,0x00,0x01,0x3a,0x07,0x00,0x00,0x6a
	.byte 0x9f,0x11,0x00,0x00,0x01,0x3a,0x07,0x00
	.byte 0x00,0x6a,0xa9,0x11,0x00,0x00,0x31,0x50
	.byte 0x07,0x00,0x00,0x6a,0xb3,0x12,0x01,0x01
	.byte 0x00,0x00,0x6a,0xe3,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x5e,0x13,0x00
	.byte 0x00,0x6a,0xa4,0x13,0x00,0x00,0x6a,0xae
	.byte 0x13,0x00,0x00,0x45,0xb7,0x13,0x00,0x00
	.byte 0x6a,0xb8,0x00,0x07,0x00,0x00,0x6a,0xbd
	.byte 0x11,0x00,0x00,0x01,0x3a,0x07,0x00,0x00
	.byte 0x6a,0xe8,0x11,0x00,0x00,0x01,0x3a,0x07
	.byte 0x00,0x00,0x6a,0xf2,0x11,0x00,0x00,0x31
	.byte 0x50,0x07,0x00,0x00,0x6a,0xfc,0x12,0x01
	.byte 0x01,0x00,0x00,0x6b,0x3b,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0x5e,0x13
	.byte 0x00,0x00,0x6a,0xed,0x13,0x00,0x00,0x6a
	.byte 0xf7,0x13,0x00,0x00,0x34,0x84,0x13,0x00
	.byte 0x00,0x34,0x84,0x13,0x00,0x00,0x34,0x84
	.byte 0x13,0x00,0x00,0x34,0x84,0x13,0x00,0x00
	.byte 0x6b,0x01,0x00,0x07,0x00,0x00,0x6b,0x06
	.byte 0x12,0x01,0x01,0x00,0x00,0x6b,0x4d,0x13
	.byte 0x00,0x00,0x3c,0x53,0x00,0x07,0x00,0x00
	.byte 0x6b,0x40,0x12,0x01,0x01,0x00,0x00,0x6b
	.byte 0x5f,0x13,0x00,0x00,0x3c,0x53,0x00,0x07
	.byte 0x00,0x00,0x6b,0x52,0x14,0x01,0x00,0x00
	.byte 0x31,0x50,0x01,0x00,0x00,0x6b,0x7a,0x13
	.byte 0x00,0x00,0x3c,0x53,0x13,0x00,0x00,0x01
	.byte 0x5e,0x00,0x07,0x00,0x00,0x6b,0x64,0x14
	.byte 0x01,0x00,0x00,0x31,0x50,0x01,0x00,0x00
	.byte 0x6b,0xa4,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x31,0x50,0x13,0x00,0x00,0x31
	.byte 0x50,0x13,0x00,0x00,0x31,0x50,0x13,0x00
	.byte 0x00,0x31,0x50,0x00,0x07,0x00,0x00,0x6b
	.byte 0x7f,0x14,0x01,0x00,0x00,0x31,0x50,0x01
	.byte 0x00,0x00,0x6b,0xbf,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0xa7,0x00,0x07
	.byte 0x00,0x00,0x6b,0xa9,0x12,0x01,0x01,0x00
	.byte 0x00,0x6b,0xd6,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x31,0x50,0x00,0x07,0x00
	.byte 0x00,0x6b,0xc4,0x12,0x01,0x01,0x00,0x00
	.byte 0x6b,0xe8,0x13,0x00,0x00,0x3c,0x53,0x00
	.byte 0x07,0x00,0x00,0x6b,0xdb,0x12,0x01,0x01
	.byte 0x00,0x00,0x6c,0x04,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x77,0x13,0x00
	.byte 0x00,0x01,0x77,0x00,0x07,0x00,0x00,0x6b
	.byte 0xed,0x12,0x01,0x01,0x00,0x00,0x6c,0x16
	.byte 0x13,0x00,0x00,0x3c,0x53,0x00,0x07,0x00
	.byte 0x00,0x6c,0x09,0x12,0x01,0x01,0x00,0x00
	.byte 0x6c,0x28,0x13,0x00,0x00,0x3c,0x53,0x00
	.byte 0x07,0x00,0x00,0x6c,0x1b,0x11,0x00,0x00
	.byte 0x48,0x0f,0x07,0x00,0x00,0x6c,0x2d,0x14
	.byte 0x01,0x00,0x00,0x01,0x5e,0x01,0x00,0x00
	.byte 0x6c,0x61,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x5e,0x13,0x00,0x00,0x01
	.byte 0x3a,0x13,0x00,0x00,0x01,0x3a,0x13,0x00
	.byte 0x00,0x6c,0x32,0x13,0x00,0x00,0x34,0x84
	.byte 0x00,0x07,0x00,0x00,0x6c,0x37,0x11,0x00
	.byte 0x00,0x01,0x3a,0x07,0x00,0x00,0x6c,0x66
	.byte 0x11,0x00,0x00,0x01,0x3a,0x07,0x00,0x00
	.byte 0x6c,0x70,0x11,0x00,0x00,0x48,0x0f,0x07
	.byte 0x00,0x00,0x6c,0x7a,0x12,0x01,0x01,0x00
	.byte 0x00,0x6c,0xaa,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0x5e,0x13,0x00,0x00
	.byte 0x6c,0x6b,0x13,0x00,0x00,0x6c,0x75,0x13
	.byte 0x00,0x00,0x6c,0x7f,0x13,0x00,0x00,0x34
	.byte 0x84,0x00,0x07,0x00,0x00,0x6c,0x84,0x12
	.byte 0x01,0x01,0x00,0x00,0x6c,0xd0,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x5e
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x44,0xe5,0x00
	.byte 0x07,0x00,0x00,0x6c,0xaf,0x12,0x01,0x01
	.byte 0x00,0x00,0x6c,0xf6,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x5e,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x48,0x21,0x00,0x07,0x00
	.byte 0x00,0x6c,0xd5,0x12,0x01,0x01,0x00,0x00
	.byte 0x6d,0x12,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x01,0x5e,0x13,0x00,0x00,0x01
	.byte 0x5e,0x00,0x07,0x00,0x00,0x6c,0xfb,0x05
	.byte 0x00,0x00,0x6d,0x12
	.ascii "points_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0x45
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x5e,0x13
	.byte 0x00,0x00,0x01,0x5e,0x00,0x07,0x00,0x00
	.byte 0x6d,0x29,0x05,0x00,0x00,0x6d,0x45
	.ascii "line_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0x7b
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x5e,0x13
	.byte 0x00,0x00,0x01,0x5e,0x13,0x00,0x00,0x01
	.byte 0x5e,0x00,0x07,0x00,0x00,0x6d,0x5a,0x05
	.byte 0x00,0x00,0x6d,0x7b
	.ascii "triangle_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0xba
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x5e,0x13
	.byte 0x00,0x00,0x01,0x5e,0x13,0x00,0x00,0x01
	.byte 0x5e,0x13,0x00,0x00,0x01,0x5e,0x00,0x07
	.byte 0x00,0x00,0x6d,0x94,0x05,0x00,0x00,0x6d
	.byte 0xba
	.ascii "quad_func\0"
	.byte 0x02,0x12,0x01,0x01,0x00,0x00,0x6d,0xf0
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x07,0x00,0x00,0x6d,0xcf,0x05
	.byte 0x00,0x00,0x6d,0xf0
	.ascii "rect_func\0"
	.byte 0x02,0x11,0x00,0x00,0x31,0x74,0x07,0x00
	.byte 0x00,0x6e,0x05,0x14,0x01,0x00,0x00,0x31
	.byte 0x50,0x01,0x00,0x00,0x6e,0x48,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x3a,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x01
	.byte 0xa7,0x13,0x00,0x00,0x31,0x50,0x13,0x00
	.byte 0x00,0x6e,0x0a,0x00,0x07,0x00,0x00,0x6e
	.byte 0x0f,0x11,0x00,0x00,0x3d,0x1b,0x07,0x00
	.byte 0x00,0x6e,0x4d,0x14,0x01,0x00,0x00,0x31
	.byte 0x50,0x01,0x00,0x00,0x6e,0x8b,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0x3a,0x13,0x00,0x00
	.byte 0x01,0x77,0x13,0x00,0x00,0x01,0x77,0x13
	.byte 0x00,0x00,0x01,0x77,0x13,0x00,0x00,0x01
	.byte 0x77,0x13,0x00,0x00,0x6e,0x52,0x00,0x07
	.byte 0x00,0x00,0x6e,0x57,0x12,0x01,0x01,0x00
	.byte 0x00,0x6e,0xa2,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x00,0x07,0x00
	.byte 0x00,0x6e,0x90,0x12,0x01,0x01,0x00,0x00
	.byte 0x6e,0xb4,0x13,0x00,0x00,0x3c,0x53,0x00
	.byte 0x07,0x00,0x00,0x6e,0xa7,0x12,0x01,0x01
	.byte 0x00,0x00,0x6e,0xd0,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x01,0x5e,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x07,0x00,0x00,0x6e
	.byte 0xb9,0x14,0x01,0x00,0x00,0x31,0x50,0x01
	.byte 0x00,0x00,0x6e,0xeb,0x13,0x00,0x00,0x3c
	.byte 0x53,0x13,0x00,0x00,0x31,0x50,0x00,0x07
	.byte 0x00,0x00,0x6e,0xd5,0x11,0x00,0x00,0x01
	.byte 0x77,0x07,0x00,0x00,0x6e,0xf0,0x12,0x01
	.byte 0x01,0x00,0x00,0x6f,0x11,0x13,0x00,0x00
	.byte 0x3c,0x53,0x13,0x00,0x00,0x01,0xa7,0x13
	.byte 0x00,0x00,0x6e,0xf5,0x00,0x07,0x00,0x00
	.byte 0x6e,0xfa,0x11,0x00,0x00,0x31,0x81,0x07
	.byte 0x00,0x00,0x6f,0x16,0x12,0x01,0x01,0x00
	.byte 0x00,0x6f,0x46,0x13,0x00,0x00,0x3c,0x53
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x34,0xe0,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x6f
	.byte 0x1b,0x00,0x07,0x00,0x00,0x6f,0x20,0x11
	.byte 0x00,0x00,0x01,0x77,0x07,0x00,0x00,0x6f
	.byte 0x4b,0x12,0x01,0x01,0x00,0x00,0x6f,0x76
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x34,0xe0,0x13
	.byte 0x00,0x00,0x01,0xa7,0x13,0x00,0x00,0x6f
	.byte 0x50,0x00,0x07,0x00,0x00,0x6f,0x55,0x12
	.byte 0x01,0x01,0x00,0x00,0x6f,0x92,0x13,0x00
	.byte 0x00,0x3c,0x53,0x13,0x00,0x00,0x01,0xa7
	.byte 0x13,0x00,0x00,0x34,0xe0,0x00,0x07,0x00
	.byte 0x00,0x6f,0x7b,0x12,0x01,0x01,0x00,0x00
	.byte 0x6f,0xa9,0x13,0x00,0x00,0x3c,0x53,0x13
	.byte 0x00,0x00,0x34,0xe0,0x00,0x07,0x00,0x00
	.byte 0x6f,0x97,0x12,0x01,0x01,0x00,0x00,0x6f
	.byte 0xc0,0x13,0x00,0x00,0x3c,0x53,0x13,0x00
	.byte 0x00,0x34,0xe0,0x00,0x07,0x00,0x00,0x6f
	.byte 0xae,0x12,0x01,0x01,0x00,0x00,0x6f,0xd7
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x31,0x50,0x00,0x07,0x00,0x00,0x6f,0xc5
	.byte 0x0c
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x74,0x44,0x0d
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x66,0xeb,0x02,0x23,0x00,0x0d
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x66,0xfd,0x02,0x23,0x04,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x67,0x14,0x02,0x23,0x08,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x67,0x3a,0x02,0x23,0x0c,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x67,0x65,0x02,0x23,0x10,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x67,0x7c,0x02,0x23,0x14,0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x67,0xa2,0x02,0x23,0x18,0x0d
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x67,0xbd,0x02,0x23,0x1c,0x0d
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x67,0xd9,0x02,0x23,0x20,0x0d
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x68,0x45,0x02,0x23,0x24,0x0d
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x68,0x75,0x02,0x23,0x28,0x0d
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x68,0xf5,0x02,0x23,0x2c,0x0d
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x69,0x39,0x02,0x23,0x30,0x0d
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x69,0x78,0x02,0x23,0x34,0x0d
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x69,0xa8,0x02,0x23,0x38,0x0d
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x69,0xfb,0x02,0x23,0x3c,0x0d
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x6a,0x3f,0x02,0x23,0x40,0x0d
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x6a,0x65,0x02,0x23,0x44,0x0d
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x6a,0x9a,0x02,0x23,0x48,0x0d
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x6a,0xe3,0x02,0x23,0x4c,0x0d
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x6b,0x3b,0x02,0x23,0x50,0x0d
	.ascii "Finish\0"
	.byte 0x00,0x00,0x6b,0x4d,0x02,0x23,0x54,0x0d
	.ascii "Flush\0"
	.byte 0x00,0x00,0x6b,0x5f,0x02,0x23,0x58,0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x6b,0x7a,0x02,0x23,0x5c,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x6b,0xa4,0x02,0x23,0x60,0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x6b,0xbf,0x02,0x23,0x64,0x0d
	.ascii "Dither\0"
	.byte 0x00,0x00,0x6b,0xd6,0x02,0x23,0x68,0x0d
	.ascii "Error\0"
	.byte 0x00,0x00,0x6b,0xe8,0x02,0x23,0x6c,0x0d
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x6c,0x04,0x02,0x23,0x70,0x0d
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x16,0x02,0x23,0x74,0x0d
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x28,0x02,0x23,0x78,0x0d
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x6c,0x61,0x02,0x23,0x7c,0x0d
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x6c,0xaa,0x03,0x23,0x80,0x01
	.byte 0x0d
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x6c,0xd0,0x03,0x23,0x84,0x01
	.byte 0x0d
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x6c,0xf6,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x17,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x4a,0x03,0x23,0x90,0x01
	.byte 0x0d
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x80,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xbf,0x03,0x23,0x98,0x01
	.byte 0x0d
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xf5,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x6e,0x48,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x6e,0x8b,0x03,0x23,0xa4,0x01
	.byte 0x0d
	.ascii "Begin\0"
	.byte 0x00,0x00,0x6e,0xa2,0x03,0x23,0xa8,0x01
	.byte 0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x6e,0xb4,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x6e,0xd0,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x6e,0xeb,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x6f,0x11,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x6f,0x46,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x6f,0x76,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x6f,0x92,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x6f,0xa9,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xc0,0x03,0x23,0xcc,0x01
	.byte 0x0d
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xd7,0x03,0x23,0xd0,0x01
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x40,0x00
	.byte 0x00,0x74,0x55,0x09,0x00,0x00,0x01,0x8e
	.byte 0x0f,0x00,0x08,0x00,0x00,0x01,0x80,0x40
	.byte 0x00,0x00,0x74,0x66,0x09,0x00,0x00,0x01
	.byte 0x8e,0x0f,0x00,0x08,0x00,0x00,0x01,0x77
	.byte 0x40,0x00,0x00,0x74,0x77,0x09,0x00,0x00
	.byte 0x01,0x8e,0x0f,0x00,0x0e,0x00,0x00,0x74
	.byte 0x66,0x08,0x00,0x00,0x00,0x74,0x89,0x09
	.byte 0x00,0x00,0x01,0x8e,0x1f,0x00,0x08,0x00
	.byte 0x00,0x01,0x80,0x40,0x00,0x00,0x74,0x9a
	.byte 0x09,0x00,0x00,0x01,0x8e,0x0f,0x00,0x08
	.byte 0x00,0x00,0x01,0x77,0x40,0x00,0x00,0x74
	.byte 0xab,0x09,0x00,0x00,0x01,0x8e,0x0f,0x00
	.byte 0x0e,0x00,0x00,0x74,0x9a,0x08,0x00,0x00
	.byte 0x00,0x74,0xbd,0x09,0x00,0x00,0x01,0x8e
	.byte 0x1f,0x00,0x08,0x00,0x00,0x01,0x77,0x08
	.byte 0x00,0x00,0x74,0xce,0x09,0x00,0x00,0x01
	.byte 0x8e,0x01,0x00,0x0e,0x00,0x00,0x74,0xbd
	.byte 0x01,0x00,0x00,0x00,0x74,0xe0,0x09,0x00
	.byte 0x00,0x01,0x8e,0x1f,0x00,0x08,0x00,0x00
	.byte 0x01,0x80,0x40,0x00,0x00,0x74,0xf1,0x09
	.byte 0x00,0x00,0x01,0x8e,0x0f,0x00,0x08,0x00
	.byte 0x00,0x01,0x77,0x40,0x00,0x00,0x75,0x02
	.byte 0x09,0x00,0x00,0x01,0x8e,0x0f,0x00,0x0e
	.byte 0x00,0x00,0x74,0xf1,0x02,0x80,0x00,0x00
	.byte 0x75,0x14,0x09,0x00,0x00,0x01,0x8e,0x09
	.byte 0x00,0x05,0x00,0x00,0x01,0x5e
	.ascii "GLbitfield\0"
	.byte 0x03,0x07,0x00,0x00,0x75,0x2a,0x0c
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x02,0x00,0x00,0x75,0x68,0x0d
	.ascii "kind\0"
	.byte 0x00,0x00,0x75,0x14,0x02,0x23,0x00,0x0d
	.ascii "data\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x04,0x0d
	.ascii "next\0"
	.byte 0x00,0x00,0x75,0x25,0x02,0x23,0x08,0x00
	.byte 0x08,0x00,0x00,0x75,0x25,0x40,0x00,0x00
	.byte 0x75,0x79,0x09,0x00,0x00,0x01,0x8e,0x0f
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x10,0x00
	.byte 0x00,0x75,0x8a,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x0c
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x02,0x00,0x00,0x75,0xb5,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0x79,0x02,0x23,0x00,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x75,0xc6,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x10,0x00
	.byte 0x00,0x75,0xd7,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x0c
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x02,0x00,0x00,0x77,0x86,0x0d
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x00,0x0d
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xb5,0x02,0x23,0x04,0x0d
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x14,0x0d
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x18,0x0d
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x1c,0x0d
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x20,0x0d
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x24,0x0d
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x28,0x0d
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x2c,0x0d
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0x61,0x02,0x23,0x30,0x0d
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x31,0x0d
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x34,0x0d
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x38,0x0d
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x3c,0x0d
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x75,0xc6,0x02,0x23,0x40,0x0d
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x50,0x0d
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x54,0x0d
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x55,0x0d
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x56,0x0d
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x57,0x00
	.byte 0x08,0x00,0x00,0x31,0x61,0x04,0x00,0x00
	.byte 0x77,0x97,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x0c,0x00
	.byte 0x00,0x77,0xa8,0x09,0x00,0x00,0x01,0x8e
	.byte 0x02,0x00,0x08,0x00,0x00,0x01,0x80,0x10
	.byte 0x00,0x00,0x77,0xb9,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x08,0x00,0x00,0x01,0x80
	.byte 0x10,0x00,0x00,0x77,0xca,0x09,0x00,0x00
	.byte 0x01,0x8e,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x80,0x10,0x00,0x00,0x77,0xdb,0x09,0x00
	.byte 0x00,0x01,0x8e,0x03,0x00,0x08,0x00,0x00
	.byte 0x01,0x80,0x10,0x00,0x00,0x77,0xec,0x09
	.byte 0x00,0x00,0x01,0x8e,0x03,0x00,0x0c
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x02,0x00,0x00,0x78,0xd6,0x0d
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x77,0x86,0x02,0x23,0x00,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x04,0x0d
	.ascii "Normal\0"
	.byte 0x00,0x00,0x77,0x97,0x02,0x23,0x08,0x0d
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x77,0xa8,0x02,0x23,0x14,0x0d
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x77,0xb9,0x02,0x23,0x24,0x0d
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x34,0x0d
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x77,0xca,0x02,0x23,0x38,0x0d
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x48,0x0d
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x77,0xdb,0x02,0x23,0x4c,0x0d
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x5c,0x0d
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x5d,0x00
	.byte 0x0c
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x79,0x29,0x0d
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0d
	.ascii "Test\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x08,0x0d
	.ascii "Mask\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x09,0x00
	.byte 0x0c
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x02,0x00,0x00,0x7b,0x8e,0x0d
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x01,0x0d
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x02,0x0d
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x03,0x0d
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x04,0x0d
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x05,0x0d
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x06,0x0d
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x07,0x0d
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x08,0x0d
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x09,0x0d
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0a,0x0d
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0b,0x0d
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0c,0x0d
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0d,0x0d
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0e,0x0d
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0f,0x0d
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x10,0x0d
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x11,0x0d
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x12,0x0d
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x14,0x0d
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x20,0x0d
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x24,0x0d
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x28,0x0d
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x2c,0x0d
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x30,0x0d
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x34,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x7b,0x9f,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x0c
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x7c,0x18,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "Color\0"
	.byte 0x00,0x00,0x7b,0x8e,0x02,0x23,0x04,0x0d
	.ascii "Density\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x14,0x0d
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "End\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x20,0x0d
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x24,0x00
	.byte 0x0c
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x7c,0x96,0x0d
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x08,0x0d
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x0c,0x0d
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x10,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x7c,0xa7,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x10,0x00
	.byte 0x00,0x7c,0xb8,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x80,0x10
	.byte 0x00,0x00,0x7c,0xc9,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x08,0x00,0x00,0x01,0x80
	.byte 0x10,0x00,0x00,0x7c,0xda,0x09,0x00,0x00
	.byte 0x01,0x8e,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x80,0x10,0x00,0x00,0x7c,0xeb,0x09,0x00
	.byte 0x00,0x01,0x8e,0x03,0x00,0x10
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x02,0x00,0x00,0x7e,0xad,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7c,0x96,0x02,0x23,0x00,0x0d
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7c,0xa7,0x02,0x23,0x10,0x0d
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7c,0xb8,0x02,0x23,0x20,0x0d
	.ascii "Position\0"
	.byte 0x00,0x00,0x7c,0xc9,0x02,0x23,0x30,0x0d
	.ascii "Direction\0"
	.byte 0x00,0x00,0x7c,0xda,0x02,0x23,0x40,0x0d
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x50,0x0d
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x54,0x0d
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x58,0x0d
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x5c,0x0d
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x60,0x0d
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x64,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x68,0x0d
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x7e,0xad,0x02,0x23,0x6c,0x0d
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xb2,0x02,0x23,0x70,0x0d
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xc3,0x02,0x23,0x7c,0x0d
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x7e,0xd4,0x03,0x23,0x88,0x01
	.byte 0x0d
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x7e,0xf6,0x03,0x23,0x94,0x01
	.byte 0x0d
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x7f,0x1a,0x03,0x23,0x94,0x21
	.byte 0x0d
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x7f,0x3c,0x03,0x23,0xac,0x21
	.byte 0x0d
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x7f,0x5e,0x03,0x23,0xc4,0x21
	.byte 0x0d
	.ascii "dli\0"
	.byte 0x00,0x00,0x01,0x80,0x03,0x23,0xdc,0x21
	.byte 0x0d
	.ascii "sli\0"
	.byte 0x00,0x00,0x01,0x80,0x03,0x23,0xe0,0x21
	.byte 0x00,0x07,0x00,0x00,0x7c,0xeb,0x08,0x00
	.byte 0x00,0x01,0x80,0x0c,0x00,0x00,0x7e,0xc3
	.byte 0x09,0x00,0x00,0x01,0x8e,0x02,0x00,0x08
	.byte 0x00,0x00,0x01,0x80,0x0c,0x00,0x00,0x7e
	.byte 0xd4,0x09,0x00,0x00,0x01,0x8e,0x02,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x0c,0x00,0x00
	.byte 0x7e,0xe5,0x09,0x00,0x00,0x01,0x8e,0x02
	.byte 0x00,0x08,0x00,0x00,0x01,0x77,0x08,0x00
	.byte 0x00,0x7e,0xf6,0x09,0x00,0x00,0x01,0x8e
	.byte 0x01,0x00,0x0e,0x00,0x00,0x7e,0xe5,0x10
	.byte 0x00,0x00,0x00,0x7f,0x09,0x0f,0x00,0x00
	.byte 0x01,0x8e,0x01,0xff,0x00,0x08,0x00,0x00
	.byte 0x01,0x77,0x0c,0x00,0x00,0x7f,0x1a,0x09
	.byte 0x00,0x00,0x01,0x8e,0x02,0x00,0x08,0x00
	.byte 0x00,0x7f,0x09,0x18,0x00,0x00,0x7f,0x2b
	.byte 0x09,0x00,0x00,0x01,0x8e,0x01,0x00,0x08
	.byte 0x00,0x00,0x01,0x77,0x0c,0x00,0x00,0x7f
	.byte 0x3c,0x09,0x00,0x00,0x01,0x8e,0x02,0x00
	.byte 0x08,0x00,0x00,0x7f,0x2b,0x18,0x00,0x00
	.byte 0x7f,0x4d,0x09
	.byte 0x00,0x00,0x01,0x8e,0x01,0x00,0x08,0x00
	.byte 0x00,0x01,0x77,0x0c,0x00,0x00,0x7f,0x5e
	.byte 0x09,0x00,0x00,0x01,0x8e,0x02,0x00,0x08
	.byte 0x00,0x00,0x7f,0x4d,0x18,0x00,0x00,0x7f
	.byte 0x6f,0x09,0x00,0x00,0x01,0x8e,0x01,0x00
	.byte 0x0e,0x00,0x00,0x7c,0xeb,0x87,0x20,0x00
	.byte 0x00,0x7f,0x81,0x09,0x00,0x00,0x01,0x8e
	.byte 0x07,0x00,0x08,0x00,0x00,0x01,0x80,0x10
	.byte 0x00,0x00,0x7f,0x92,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x0c
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x02,0x00,0x00,0x7f,0xdc,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0x81,0x02,0x23,0x00,0x0d
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x10,0x0d
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x11,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x7f,0xed,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x10,0x00
	.byte 0x00,0x7f,0xfe,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x80,0x10
	.byte 0x00,0x00,0x80,0x0f,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x08,0x00,0x00,0x01,0x80
	.byte 0x10,0x00,0x00,0x80,0x20,0x09,0x00,0x00
	.byte 0x01,0x8e,0x03,0x00,0x0e,0x00,0x00,0x01
	.byte 0x80,0x03,0x20,0x00,0x00,0x80,0x33,0x0f
	.byte 0x00,0x00,0x01,0x8e,0x00,0xc7,0x00,0x10
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x02,0x00,0x00,0x80,0xef,0x0d
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0xdc,0x02,0x23,0x00,0x0d
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7f,0xed,0x02,0x23,0x10,0x0d
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7f,0xfe,0x02,0x23,0x20,0x0d
	.ascii "Emission\0"
	.byte 0x00,0x00,0x80,0x0f,0x02,0x23,0x30,0x0d
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x40,0x0d
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x44,0x0d
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x48,0x0d
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x4c,0x0d
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x80,0x20,0x02,0x23,0x50,0x00
	.byte 0x0e,0x00,0x00,0x80,0x33,0x06,0xe0,0x00
	.byte 0x00,0x81,0x01,0x09,0x00,0x00,0x01,0x8e
	.byte 0x01,0x00,0x08,0x00,0x00,0x01,0x77,0x10
	.byte 0x00,0x00,0x81,0x12,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x08,0x00,0x00,0x81,0x01
	.byte 0x20,0x00,0x00,0x81,0x23,0x09,0x00,0x00
	.byte 0x01,0x8e,0x01,0x00,0x10
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x02,0x00,0x00,0x82,0x44,0x0d
	.ascii "Light\0"
	.byte 0x00,0x00,0x7f,0x6f,0x02,0x23,0x00,0x0d
	.ascii "Model\0"
	.byte 0x00,0x00,0x7f,0x92,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0d
	.ascii "Material\0"
	.byte 0x00,0x00,0x80,0xef,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0d
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0x43,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x01,0x6a,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0d
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0d
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x7e,0xad,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0d
	.ascii "Fast\0"
	.byte 0x00,0x00,0x32,0xb3,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0d
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x81,0x12,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x05,0x00,0x00,0x48,0x0f
	.ascii "GLushort\0"
	.byte 0x03,0x0c
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x82,0xcc,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x01,0x0d
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x82,0x44,0x02,0x23,0x02,0x0d
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x00
	.byte 0x0c
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x02,0x00,0x00,0x82,0xf4,0x0d
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x00,0x00
	.byte 0x0e,0x00,0x00,0x01,0x41,0x04,0x00,0x00
	.byte 0x00,0x83,0x07,0x0f,0x00,0x00,0x01,0x8e
	.byte 0x00,0xff,0x00,0x0e,0x00,0x00,0x01,0x41
	.byte 0x04,0x00,0x00,0x00,0x83,0x1a,0x0f,0x00
	.byte 0x00,0x01,0x8e,0x00,0xff,0x00,0x0e,0x00
	.byte 0x00,0x01,0x80,0x04,0x00,0x00,0x00,0x83
	.byte 0x2d,0x0f,0x00,0x00,0x01,0x8e,0x00,0xff
	.byte 0x00,0x0e,0x00,0x00,0x01,0x80,0x04,0x00
	.byte 0x00,0x00,0x83,0x40,0x0f,0x00,0x00,0x01
	.byte 0x8e,0x00,0xff,0x00,0x0e,0x00,0x00,0x01
	.byte 0x80,0x04,0x00,0x00,0x00,0x83,0x53,0x0f
	.byte 0x00,0x00,0x01,0x8e,0x00,0xff,0x00,0x0e
	.byte 0x00,0x00,0x01,0x80,0x04,0x00,0x00,0x00
	.byte 0x83,0x66,0x0f,0x00,0x00,0x01,0x8e,0x00
	.byte 0xff,0x00,0x0e,0x00,0x00,0x01,0x80,0x04
	.byte 0x00,0x00,0x00,0x83,0x79,0x0f,0x00,0x00
	.byte 0x01,0x8e,0x00,0xff,0x00,0x0e,0x00,0x00
	.byte 0x01,0x80,0x04,0x00,0x00,0x00,0x83,0x8c
	.byte 0x0f,0x00,0x00,0x01,0x8e,0x00,0xff,0x00
	.byte 0x0e,0x00,0x00,0x01,0x80,0x04,0x00,0x00
	.byte 0x00,0x83,0x9f,0x0f,0x00,0x00,0x01,0x8e
	.byte 0x00,0xff,0x00,0x0e,0x00,0x00,0x01,0x80
	.byte 0x04,0x00,0x00,0x00,0x83,0xb2,0x0f,0x00
	.byte 0x00,0x01,0x8e,0x00,0xff,0x00,0x10
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x02,0x00,0x00,0x86,0x71,0x0d
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0d
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x0d
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x0c,0x0d
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x10,0x0d
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x14,0x0d
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x20,0x0d
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x24,0x0d
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x28,0x0d
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x2c,0x0d
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x30,0x0d
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x34,0x0d
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x35,0x0d
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x38,0x0d
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x3c,0x0d
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x40,0x0d
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x44,0x0d
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x48,0x0d
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x4c,0x0d
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x50,0x0d
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x54,0x0d
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x58,0x0d
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x5c,0x0d
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x60,0x0d
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x64,0x0d
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x82,0xf4,0x02,0x23,0x68,0x0d
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x83,0x07,0x03,0x23,0xe8,0x08
	.byte 0x0d
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x83,0x1a,0x03,0x23,0xe8,0x10
	.byte 0x0d
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x83,0x2d,0x03,0x23,0xe8,0x18
	.byte 0x0d
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x83,0x40,0x03,0x23,0xe8,0x20
	.byte 0x0d
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x83,0x53,0x03,0x23,0xe8,0x28
	.byte 0x0d
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x83,0x66,0x03,0x23,0xe8,0x30
	.byte 0x0d
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x83,0x79,0x03,0x23,0xe8,0x38
	.byte 0x0d
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x83,0x8c,0x03,0x23,0xe8,0x40
	.byte 0x0d
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x83,0x9f,0x03,0x23,0xe8,0x48
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x0c,0x00
	.byte 0x00,0x86,0x82,0x09,0x00,0x00,0x01,0x8e
	.byte 0x02,0x00,0x0c
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x02,0x00,0x00,0x86,0xfb,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "Size\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0d
	.ascii "Params\0"
	.byte 0x00,0x00,0x86,0x71,0x02,0x23,0x08,0x0d
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x14,0x0d
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x00
	.byte 0x0c
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x88,0x2e,0x0d
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x08,0x0d
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0c,0x0d
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x0d,0x0d
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x10,0x0d
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x14,0x0d
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x18,0x0d
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x19,0x0d
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x20,0x0d
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x24,0x0d
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x25,0x0d
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x26,0x0d
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x27,0x00
	.byte 0x08,0x00,0x00,0x01,0x6a,0x80,0x00,0x00
	.byte 0x88,0x3f,0x09,0x00,0x00,0x01,0x8e,0x1f
	.byte 0x00,0x05,0x00,0x00,0x01,0x3a
	.ascii "GLsizei\0"
	.byte 0x03,0x0c
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x88,0xa8,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x08,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x0c,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x10,0x00
	.byte 0x0c
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x02,0x00,0x00,0x89,0x56,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x00,0x0d
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x08,0x0d
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x0c,0x0d
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x10,0x0d
	.ascii "Ref\0"
	.byte 0x00,0x00,0x65,0xb1,0x02,0x23,0x14,0x0d
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x65,0xb1,0x02,0x23,0x15,0x0d
	.ascii "Clear\0"
	.byte 0x00,0x00,0x65,0xb1,0x02,0x23,0x16,0x0d
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x65,0xb1,0x02,0x23,0x17,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x89,0x67,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x08,0x00,0x00,0x01,0x80,0x10,0x00
	.byte 0x00,0x89,0x78,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x08,0x00,0x00,0x01,0x80,0x10
	.byte 0x00,0x00,0x89,0x89,0x09,0x00,0x00,0x01
	.byte 0x8e,0x03,0x00,0x08,0x00,0x00,0x01,0x80
	.byte 0x10,0x00,0x00,0x89,0x9a,0x09,0x00,0x00
	.byte 0x01,0x8e,0x03,0x00,0x08,0x00,0x00,0x01
	.byte 0x80,0x10,0x00,0x00,0x89,0xab,0x09,0x00
	.byte 0x00,0x01,0x8e,0x03,0x00,0x08,0x00,0x00
	.byte 0x01,0x80,0x10,0x00,0x00,0x89,0xbc,0x09
	.byte 0x00,0x00,0x01,0x8e,0x03,0x00,0x08,0x00
	.byte 0x00,0x01,0x80,0x10,0x00,0x00,0x89,0xcd
	.byte 0x09,0x00,0x00,0x01,0x8e,0x03,0x00,0x08
	.byte 0x00,0x00,0x01,0x80,0x10,0x00,0x00,0x89
	.byte 0xde,0x09,0x00,0x00,0x01,0x8e,0x03,0x00
	.byte 0x08,0x00,0x00,0x01,0x80,0x10,0x00,0x00
	.byte 0x89,0xef,0x09,0x00,0x00,0x01,0x8e,0x03
	.byte 0x00,0x0e,0x00,0x00,0x31,0x61,0x04,0x00
	.byte 0x00,0x00,0x8a,0x02,0x0f,0x00,0x00,0x01
	.byte 0x8e,0x03,0xff,0x00,0x10
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x02,0x00,0x00,0x8c,0x31,0x0d
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x00,0x0d
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x89,0x56,0x02,0x23,0x08,0x0d
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x18,0x0d
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x1c,0x0d
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x20,0x0d
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x24,0x0d
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x28,0x0d
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x89,0x67,0x02,0x23,0x2c,0x0d
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x89,0x78,0x02,0x23,0x3c,0x0d
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x89,0x89,0x02,0x23,0x4c,0x0d
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x89,0x9a,0x02,0x23,0x5c,0x0d
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x89,0xab,0x02,0x23,0x6c,0x0d
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x89,0xbc,0x02,0x23,0x7c,0x0d
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x89,0xcd,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x89,0xde,0x03,0x23,0x9c,0x01
	.byte 0x0d
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xac,0x01
	.byte 0x0d
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xb0,0x01
	.byte 0x0d
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "Current\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xb8,0x01
	.byte 0x0d
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xbc,0x01
	.byte 0x0d
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xc0,0x01
	.byte 0x0d
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x34,0xe0,0x03,0x23,0xc4,0x01
	.byte 0x0d
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0xc8,0x01
	.byte 0x0d
	.ascii "Palette\0"
	.byte 0x00,0x00,0x89,0xef,0x03,0x23,0xc9,0x01
	.byte 0x0d
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x6a,0x03,0x23,0xcc,0x09
	.byte 0x0d
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x43,0x03,0x23,0xd0,0x09
	.byte 0x0d
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x43,0x03,0x23,0xd4,0x09
	.byte 0x00,0x08,0x00,0x00,0x01,0x77,0x10,0x00
	.byte 0x00,0x8c,0x42,0x09,0x00,0x00,0x01,0x8e
	.byte 0x03,0x00,0x08,0x00,0x00,0x8c,0x31,0x60
	.byte 0x00,0x00,0x8c,0x53,0x09,0x00,0x00,0x01
	.byte 0x8e,0x05,0x00,0x08,0x00,0x00,0x32,0xb3
	.byte 0x06,0x00,0x00,0x8c,0x64,0x09,0x00,0x00
	.byte 0x01,0x8e,0x05,0x00,0x0c
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x02,0x00,0x00,0x8c,0xde,0x0d
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x8c,0x42,0x02,0x23,0x04,0x0d
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x8c,0x53,0x02,0x23,0x64,0x0d
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x6a,0x0d
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x6b,0x00
	.byte 0x0c
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x02,0x00,0x00,0x8d,0x85,0x0d
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x08,0x0d
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x0c,0x0d
	.ascii "Near\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x10,0x0d
	.ascii "Far\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x14,0x0d
	.ascii "Sx\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x18,0x0d
	.ascii "Sy\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x1c,0x0d
	.ascii "Sz\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x20,0x0d
	.ascii "Tx\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x24,0x0d
	.ascii "Ty\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x28,0x0d
	.ascii "Tz\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x2c,0x00
	.byte 0x08,0x00,0x00,0x75,0x25,0x40,0x00,0x00
	.byte 0x8d,0x96,0x09,0x00,0x00,0x01,0x8e,0x0f
	.byte 0x00,0x07,0x00,0x00,0x32,0xb3,0x0c
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x02,0x00,0x00,0x90,0x46,0x0d
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x04,0x0d
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x08,0x0d
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x0c,0x0d
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x10,0x0d
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x14,0x0d
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x18,0x0d
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x1c,0x0d
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x20,0x0d
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x24,0x0d
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x28,0x0d
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x2c,0x0d
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x30,0x0d
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x34,0x0d
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x38,0x0d
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x3c,0x0d
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x40,0x0d
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x44,0x0d
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x48,0x0d
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x4c,0x0d
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x50,0x0d
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x54,0x0d
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x58,0x0d
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x5c,0x0d
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x60,0x0d
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x64,0x0d
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x31,0x7c,0x02,0x23,0x68,0x0d
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x6c,0x0d
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x70,0x0d
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x88,0x3f,0x02,0x23,0x74,0x0d
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x8d,0x96,0x02,0x23,0x78,0x0d
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x7c,0x00
	.byte 0x0c
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x02,0x00,0x00,0x90,0xf5,0x0d
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x00,0x0d
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x04,0x0d
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x08,0x0d
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x0c,0x0d
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x10,0x0d
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0x41,0x02,0x23,0x14,0x0d
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x18,0x0d
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x19,0x00
	.byte 0x07,0x00,0x00,0x01,0x80,0x0c
	.ascii "gl_1d_map\0"
	.byte 0x14,0x02,0x00,0x00,0x91,0x4e,0x0d
	.ascii "Order\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x00,0x0d
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x04,0x0d
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x0d
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xf5,0x02,0x23,0x0c,0x0d
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x10,0x00
	.byte 0x0c
	.ascii "gl_2d_map\0"
	.byte 0x20,0x02,0x00,0x00,0x91,0xc8,0x0d
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x00,0x0d
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x04,0x0d
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x08,0x0d
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x0c,0x0d
	.ascii "v1\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x10,0x0d
	.ascii "v2\0"
	.byte 0x00,0x00,0x01,0x80,0x02,0x23,0x14,0x0d
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xf5,0x02,0x23,0x18,0x0d
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xb3,0x02,0x23,0x1c,0x00
	.byte 0x10
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x02,0x00,0x00,0x93,0x52,0x0d
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x00,0x0d
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x14,0x0d
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x28,0x0d
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x3c,0x0d
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x50,0x0d
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x64,0x0d
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x90,0xfa,0x02,0x23,0x78,0x0d
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x90,0xfa,0x03,0x23,0x8c,0x01
	.byte 0x0d
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x90,0xfa,0x03,0x23,0xa0,0x01
	.byte 0x0d
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xb4,0x01
	.byte 0x0d
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xd4,0x01
	.byte 0x0d
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xf4,0x01
	.byte 0x0d
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xb4,0x02
	.byte 0x0d
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xd4,0x02
	.byte 0x0d
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xf4,0x02
	.byte 0x0d
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0x94,0x03
	.byte 0x0d
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x91,0x4e,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0c
	.ascii "gl_feedback\0"
	.byte 0x14,0x02,0x00,0x00,0x93,0xb0,0x0d
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x43,0x02,0x23,0x00,0x0d
	.ascii "Mask\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x04,0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x90,0xf5,0x02,0x23,0x08,0x0d
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x0c,0x0d
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x10,0x00
	.byte 0x07,0x00,0x00,0x01,0x6a,0x0e,0x00,0x00
	.byte 0x01,0x6a,0x01,0x00,0x00,0x00,0x93,0xc7
	.byte 0x09,0x00,0x00,0x01,0x8e,0x3f,0x00,0x10
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x02,0x00,0x00,0x94,0x7c,0x0d
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x93,0xb0,0x02,0x23,0x00,0x0d
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x04,0x0d
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x08,0x0d
	.ascii "Hits\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x0c,0x0d
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x01,0x6a,0x02,0x23,0x10,0x0d
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x93,0xb5,0x02,0x23,0x14,0x0d
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x32,0xb3,0x03,0x23,0x94,0x02
	.byte 0x0d
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x01,0x80,0x03,0x23,0x98,0x02
	.byte 0x0d
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x01,0x80,0x03,0x23,0x9c,0x02
	.byte 0x00,0x06
	.ascii "vertex_buffer\0"
	.byte 0x01,0x07,0x00,0x00,0x94,0x7c,0x06
	.ascii "pixel_buffer\0"
	.byte 0x01,0x07,0x00,0x00,0x94,0x91,0x05,0x00
	.byte 0x00,0x35,0x86
	.ascii "GLcontext\0"
	.byte 0x02,0x07,0x00,0x00,0x94,0xa5,0x16
	.ascii "gl_PixelZoom\0"
	.byte 0x01,0x02,0x01,0x71
	.uaword gl_PixelZoom
	.uaword gl_PixelZoom+456
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x95,0x10
	.byte 0x03,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x70,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x80
	.ascii "xfactor\0"
	.byte 0x01,0x70,0x02,0x90,0x22,0x03,0x00,0x00
	.byte 0x01,0x80
	.ascii "yfactor\0"
	.byte 0x01,0x70,0x02,0x90,0x32,0x00,0x16
	.ascii "gl_write_zoomed_color_span\0"
	.byte 0x01,0x02,0x01,0x8d
	.uaword gl_write_zoomed_color_span
	.uaword gl_write_zoomed_color_span+4088
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x97,0x15
	.byte 0x03,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x88,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x6a
	.ascii "n\0"
	.byte 0x01,0x89,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x41
	.ascii "x\0"
	.byte 0x01,0x89,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x41
	.ascii "y\0"
	.byte 0x01,0x89,0x01,0x6b,0x03,0x00,0x00,0x97
	.byte 0x1a
	.ascii "z\0"
	.byte 0x01,0x89,0x01,0x6a,0x03,0x00,0x00,0x97
	.byte 0x24
	.ascii "red\0"
	.byte 0x01,0x8a,0x01,0x6d,0x03,0x00,0x00,0x97
	.byte 0x2e
	.ascii "green\0"
	.byte 0x01,0x8a,0x01,0x6c,0x03,0x00,0x00,0x97
	.byte 0x38
	.ascii "blue\0"
	.byte 0x01,0x8b,0x01,0x68,0x03,0x00,0x00,0x97
	.byte 0x42
	.ascii "alpha\0"
	.byte 0x01,0x8b,0x01,0x69,0x03,0x00,0x00,0x01
	.byte 0x41
	.ascii "y0\0"
	.byte 0x01,0x8c,0x01,0x64,0x17
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x8e,0x01
	.byte 0x60,0x17
	.ascii "r0\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x8f,0x02
	.byte 0x91,0x78,0x17
	.ascii "r1\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x8f,0x02
	.byte 0x91,0x74,0x17
	.ascii "row\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x8f,0x01
	.byte 0x55,0x17
	.ascii "r\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x8f,0x01
	.byte 0x6d,0x17
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x90,0x01
	.byte 0x5f,0x17
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x90,0x01
	.byte 0x64,0x17
	.ascii "skipcol\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x90,0x02
	.byte 0x91,0x60,0x17
	.ascii "zred\0"
	.byte 0x00,0x00,0x97,0x47,0x01,0x01,0x91,0x03
	.byte 0x91,0xc0,0x73,0x17
	.ascii "zgreen\0"
	.byte 0x00,0x00,0x97,0x5a,0x01,0x01,0x91,0x03
	.byte 0x91,0x80,0x67,0x17
	.ascii "zblue\0"
	.byte 0x00,0x00,0x97,0x6d,0x01,0x01,0x92,0x03
	.byte 0x91,0xc0,0x5a,0x17
	.ascii "zalpha\0"
	.byte 0x00,0x00,0x97,0x80,0x01,0x01,0x92,0x03
	.byte 0x91,0x80,0x4e,0x17
	.ascii "zdepth\0"
	.byte 0x00,0x00,0x97,0x93,0x01,0x01,0x93,0x04
	.byte 0x91,0x80,0xb5,0x7f,0x17
	.ascii "maxwidth\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x94,0x04
	.byte 0x91,0xdc,0xb4,0x7f,0x17
	.ascii "rtmp\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xa8,0x01
	.byte 0x5f,0x17
	.ascii "xscale\0"
	.byte 0x00,0x00,0x01,0x80,0x01,0x01,0xd4,0x04
	.byte 0x91,0xc8,0xb4,0x7f,0x18,0x42,0x46,0x0c
	.byte 0x2c,0x88,0x01,0x30,0x0c,0xcc,0x00,0x10
	.byte 0x30,0x90,0x01,0xe8,0x00,0x04,0x30,0x14
	.byte 0xc4,0x00,0xc4,0x00,0x24,0x14,0x84,0x01
	.byte 0x04,0x18,0x80,0x01,0x04,0xf4,0x00,0x14
	.byte 0xb4,0x01,0x04,0x34,0xec,0x00,0x20,0x24
	.byte 0x08,0xb0,0x01,0x28,0x18,0xdc,0x00,0x04
	.byte 0xcc,0x01,0x38,0x04,0x84,0x03,0xb4,0x03
	.byte 0x08,0xc8,0x00,0xf8,0x04,0x04,0x0c,0x10
	.byte 0x10,0xc4,0x00,0xc4,0x00,0x18,0x44,0x01
	.byte 0x0c,0x00,0x11,0x00,0x00,0x65,0x9e,0x07
	.byte 0x00,0x00,0x97,0x15,0x11,0x00,0x00,0x31
	.byte 0x61,0x07,0x00,0x00,0x97,0x1f,0x11,0x00
	.byte 0x00,0x31,0x61,0x07,0x00,0x00,0x97,0x29
	.byte 0x11,0x00,0x00,0x31,0x61,0x07,0x00,0x00
	.byte 0x97,0x33,0x11,0x00,0x00,0x31,0x61,0x07
	.byte 0x00,0x00,0x97,0x3d,0x0e,0x00,0x00,0x31
	.byte 0x61,0x06,0x40,0x00,0x00,0x97,0x5a,0x0f
	.byte 0x00,0x00,0x01,0x8e,0x06,0x3f,0x00,0x0e
	.byte 0x00,0x00,0x31,0x61,0x06,0x40,0x00,0x00
	.byte 0x97,0x6d,0x0f,0x00,0x00,0x01,0x8e,0x06
	.byte 0x3f,0x00,0x0e,0x00,0x00,0x31,0x61,0x06
	.byte 0x40,0x00,0x00,0x97,0x80,0x0f,0x00,0x00
	.byte 0x01,0x8e,0x06,0x3f,0x00,0x0e,0x00,0x00
	.byte 0x31,0x61,0x06,0x40,0x00,0x00,0x97,0x93
	.byte 0x0f,0x00,0x00,0x01,0x8e,0x06,0x3f,0x00
	.byte 0x0e,0x00,0x00,0x65,0x9e,0x0c,0x80,0x00
	.byte 0x00,0x97,0xa6,0x0f,0x00,0x00,0x01,0x8e
	.byte 0x06,0x3f,0x00,0x16
	.ascii "gl_write_zoomed_index_span\0"
	.byte 0x01,0x02,0x01,0xf0
	.uaword gl_write_zoomed_index_span
	.uaword gl_write_zoomed_index_span+2032
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x99,0x01
	.byte 0x03,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0xed,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x6a
	.ascii "n\0"
	.byte 0x01,0xee,0x03,0x91,0xc8,0x00,0x03,0x00
	.byte 0x00,0x01,0x41
	.ascii "x\0"
	.byte 0x01,0xee,0x01,0x6a,0x03,0x00,0x00,0x01
	.byte 0x41
	.ascii "y\0"
	.byte 0x01,0xee,0x01,0x6b,0x03,0x00,0x00,0x99
	.byte 0x06
	.ascii "z\0"
	.byte 0x01,0xee,0x01,0x6c,0x03,0x00,0x00,0x99
	.byte 0x10
	.ascii "indexes\0"
	.byte 0x01,0xef,0x01,0x6d,0x03,0x00,0x00,0x01
	.byte 0x41
	.ascii "y0\0"
	.byte 0x01,0xef,0x01,0x5b,0x17
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf1,0x01
	.byte 0x60,0x17
	.ascii "r0\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf2,0x01
	.byte 0x6b,0x17
	.ascii "r1\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf2,0x01
	.byte 0x61,0x17
	.ascii "row\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf2,0x01
	.byte 0x58,0x17
	.ascii "r\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf2,0x01
	.byte 0x6b,0x17
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf3,0x01
	.byte 0x5a,0x17
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf3,0x01
	.byte 0x58,0x17
	.ascii "skipcol\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf3,0x01
	.byte 0x62,0x17
	.ascii "zindexes\0"
	.byte 0x00,0x00,0x99,0x15,0x01,0x01,0xf4,0x03
	.byte 0x91,0x80,0x4e,0x17
	.ascii "zdepth\0"
	.byte 0x00,0x00,0x99,0x28,0x01,0x01,0xf5,0x04
	.byte 0x91,0x80,0xb5,0x7f,0x17
	.ascii "maxwidth\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0xf6,0x04
	.byte 0x91,0xdc,0xb4,0x7f,0x19
	.ascii "rtmp\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x0a
	.byte 0x01,0x67,0x19
	.ascii "xscale\0"
	.byte 0x00,0x00,0x01,0x80,0x01,0x01,0x01,0x33
	.byte 0x02,0x90,0x20,0x18,0x44,0x01,0x0c,0x00
	.byte 0x11,0x00,0x00,0x65,0x9e,0x07,0x00,0x00
	.byte 0x99,0x01,0x11,0x00,0x00,0x01,0x6a,0x07
	.byte 0x00,0x00,0x99,0x0b,0x0e,0x00,0x00,0x01
	.byte 0x6a,0x19,0x00,0x00,0x00,0x99,0x28,0x0f
	.byte 0x00,0x00,0x01,0x8e,0x06,0x3f,0x00,0x0e
	.byte 0x00,0x00,0x65,0x9e,0x0c,0x80,0x00,0x00
	.byte 0x99,0x3b,0x0f,0x00,0x00,0x01,0x8e,0x06
	.byte 0x3f,0x00,0x1a
	.ascii "gl_write_zoomed_stencil_span\0"
	.byte 0x01,0x02,0x01,0x01,0x4b
	.uaword gl_write_zoomed_stencil_span
	.uaword gl_write_zoomed_stencil_span+1392
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9a,0x87
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x01,0x48,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x01,0x6a
	.ascii "n\0"
	.byte 0x01,0x01,0x49,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0x41
	.ascii "x\0"
	.byte 0x01,0x01,0x49,0x01,0x6a,0x1b,0x00,0x00
	.byte 0x01,0x41
	.ascii "y\0"
	.byte 0x01,0x01,0x49,0x01,0x6b,0x1b,0x00,0x00
	.byte 0x9a,0x8c
	.ascii "stencil\0"
	.byte 0x01,0x01,0x4a,0x01,0x6d,0x1b,0x00,0x00
	.byte 0x01,0x41
	.ascii "y0\0"
	.byte 0x01,0x01,0x4a,0x01,0x6d,0x19
	.ascii "m\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4c
	.byte 0x01,0x60,0x19
	.ascii "r0\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4d
	.byte 0x01,0x6b,0x19
	.ascii "r1\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4d
	.byte 0x01,0x61,0x19
	.ascii "row\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4d
	.byte 0x01,0x61,0x19
	.ascii "r\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4d
	.byte 0x01,0x6b,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4e
	.byte 0x01,0x5c,0x19
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4e
	.byte 0x01,0x63,0x19
	.ascii "skipcol\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x4e
	.byte 0x01,0x62,0x19
	.ascii "zstencil\0"
	.byte 0x00,0x00,0x9a,0x91,0x01,0x01,0x01,0x4f
	.byte 0x03,0x91,0xc0,0x73,0x19
	.ascii "maxwidth\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x50
	.byte 0x03,0x91,0x9c,0x73,0x19
	.ascii "rtmp\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x01,0x64
	.byte 0x01,0x5f,0x19
	.ascii "xscale\0"
	.byte 0x00,0x00,0x01,0x80,0x01,0x01,0x01,0x8c
	.byte 0x02,0x90,0x20,0x18,0x44,0x01,0x04,0x00
	.byte 0x11,0x00,0x00,0x31,0x61,0x07,0x00,0x00
	.byte 0x9a,0x87,0x0e,0x00,0x00,0x31,0x61,0x06
	.byte 0x40,0x00,0x00,0x9a,0xa4,0x0f,0x00,0x00
	.byte 0x01,0x8e,0x06,0x3f,0x00,0x1a
	.ascii "gl_PixelStorei\0"
	.byte 0x01,0x02,0x01,0x01,0xa3
	.uaword gl_PixelStorei
	.uaword gl_PixelStorei+1056
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9a,0xfe
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x01,0xa2,0x01,0x68,0x1b,0x00,0x00
	.byte 0x31,0x43
	.ascii "pname\0"
	.byte 0x01,0x01,0xa2,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0x41
	.ascii "param\0"
	.byte 0x01,0x01,0xa2,0x03,0x91,0xcc,0x00,0x18
	.byte 0x44,0x01,0x04,0x00,0x1a
	.ascii "gl_PixelMapfv\0"
	.byte 0x01,0x02,0x01,0x02,0x0a
	.uaword gl_PixelMapfv
	.uaword gl_PixelMapfv+3404
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9b,0x91
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x02,0x08,0x01,0x68,0x1b,0x00,0x00
	.byte 0x31,0x43
	.ascii "map\0"
	.byte 0x01,0x02,0x09,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0x41
	.ascii "mapsize\0"
	.byte 0x01,0x02,0x09,0x03,0x91,0xcc,0x00,0x1b
	.byte 0x00,0x00,0x9b,0x96
	.ascii "values\0"
	.byte 0x01,0x02,0x09,0x01,0x6b,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x6a,0x01,0x01,0x02,0x0b
	.byte 0x01,0x52,0x19
	.ascii "p\0"
	.byte 0x00,0x00,0x01,0x6a,0x01,0x01,0x02,0x19
	.byte 0x01,0x6c,0x19
	.ascii "ok\0"
	.byte 0x00,0x00,0x32,0xb3,0x01,0x01,0x02,0x1a
	.byte 0x02,0x91,0x77,0x18,0x44,0x01,0x04,0x00
	.byte 0x11,0x00,0x00,0x01,0x80,0x07,0x00,0x00
	.byte 0x9b,0x91,0x1a
	.ascii "gl_GetPixelMapfv\0"
	.byte 0x01,0x02,0x01,0x02,0x6e
	.uaword gl_GetPixelMapfv
	.uaword gl_GetPixelMapfv+4140
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9c,0x01
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x02,0x6d,0x01,0x68,0x1b,0x00,0x00
	.byte 0x31,0x43
	.ascii "map\0"
	.byte 0x01,0x02,0x6d,0x01,0x69,0x1b,0x00,0x00
	.byte 0x90,0xf5
	.ascii "values\0"
	.byte 0x01,0x02,0x6d,0x01,0x67,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x6a,0x01,0x01,0x02,0x6f
	.byte 0x01,0x60,0x18,0x44,0x01,0x04,0x00,0x1a
	.ascii "gl_GetPixelMapuiv\0"
	.byte 0x01,0x02,0x01,0x02,0x9f
	.uaword gl_GetPixelMapuiv
	.uaword gl_GetPixelMapuiv+3724
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9c,0x68
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x02,0x9e,0x01,0x68,0x1b,0x00,0x00
	.byte 0x31,0x43
	.ascii "map\0"
	.byte 0x01,0x02,0x9e,0x01,0x69,0x1b,0x00,0x00
	.byte 0x93,0xb0
	.ascii "values\0"
	.byte 0x01,0x02,0x9e,0x01,0x6a,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x6a,0x01,0x01,0x02,0xa0
	.byte 0x01,0x62,0x18,0x44,0x01,0x04,0x00,0x1a
	.ascii "gl_GetPixelMapusv\0"
	.byte 0x01,0x02,0x01,0x02,0xdc
	.uaword gl_GetPixelMapusv
	.uaword gl_GetPixelMapusv+5052
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9c,0xcf
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x02,0xdb,0x01,0x68,0x1b,0x00,0x00
	.byte 0x31,0x43
	.ascii "map\0"
	.byte 0x01,0x02,0xdb,0x01,0x69,0x1b,0x00,0x00
	.byte 0x9c,0xcf
	.ascii "values\0"
	.byte 0x01,0x02,0xdb,0x01,0x5b,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x6a,0x01,0x01,0x02,0xdd
	.byte 0x01,0x55,0x18,0x44,0x01,0x04,0x00,0x07
	.byte 0x00,0x00,0x82,0x44,0x1a
	.ascii "gl_PixelTransferf\0"
	.byte 0x01,0x02,0x01,0x03,0x27
	.uaword gl_PixelTransferf
	.uaword gl_PixelTransferf+776
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9d,0x32
	.byte 0x1b,0x00,0x00,0x94,0xb5
	.ascii "ctx\0"
	.byte 0x01,0x03,0x26,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x31,0x43
	.ascii "pname\0"
	.byte 0x01,0x03,0x26,0x01,0x69,0x1b,0x00,0x00
	.byte 0x01,0x80
	.ascii "param\0"
	.byte 0x01,0x03,0x26,0x02,0x90,0x32,0x18,0x44
	.byte 0x01,0x04,0x00,0x1c
	.ascii "gl_unpack_pixels\0"
	.byte 0x01,0x02,0x01,0x03,0x74
	.uaword gl_unpack_pixels
	.uaword gl_unpack_pixels+1432
	.byte 0x01,0x6e,0x01,0x00,0x00,0x3d,0x16,0x01
	.byte 0x00,0x00,0x9e,0xd2,0x1b,0x00,0x00,0x94
	.byte 0xb5
	.ascii "ctx\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xc4,0x00,0x1b
	.byte 0x00,0x00,0x88,0x3f
	.ascii "width\0"
	.byte 0x01,0x03,0x71,0x03,0x91,0xc8,0x00,0x1b
	.byte 0x00,0x00,0x88,0x3f
	.ascii "height\0"
	.byte 0x01,0x03,0x71,0x03,0x91,0xcc,0x00,0x1b
	.byte 0x00,0x00,0x31,0x43
	.ascii "format\0"
	.byte 0x01,0x03,0x72,0x03,0x91,0xd0,0x00,0x1b
	.byte 0x00,0x00,0x31,0x43
	.ascii "type\0"
	.byte 0x01,0x03,0x72,0x03,0x91,0xd4,0x00,0x1b
	.byte 0x00,0x00,0x9e,0xd7
	.ascii "pixels\0"
	.byte 0x01,0x03,0x73,0x01,0x6d,0x19
	.ascii "s\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0x75
	.byte 0x02,0x91,0x78,0x19
	.ascii "n\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0x75
	.byte 0x02,0x91,0x74,0x19
	.ascii "bytes\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0x85
	.byte 0x02,0x91,0x70,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0x85
	.byte 0x01,0x6b,0x19
	.ascii "width_in_bytes\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0x85
	.byte 0x02,0x91,0x68,0x19
	.ascii "buffer\0"
	.byte 0x00,0x00,0x31,0x6f,0x01,0x01,0x03,0x86
	.byte 0x02,0x91,0x64,0x19
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0x6f,0x01,0x01,0x03,0x86
	.byte 0x01,0x65,0x19
	.ascii "src\0"
	.byte 0x00,0x00,0x3d,0x16,0x01,0x01,0x03,0x87
	.byte 0x02,0x91,0x5c,0x19
	.ascii "width_in_bytes\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0xa6
	.byte 0x02,0x91,0x50,0x19
	.ascii "bytes\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0xa6
	.byte 0x02,0x91,0x4c,0x19
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x41,0x01,0x01,0x03,0xa6
	.byte 0x01,0x61,0x19
	.ascii "buffer\0"
	.byte 0x00,0x00,0x31,0x6f,0x01,0x01,0x03,0xa7
	.byte 0x02,0x91,0x44,0x19
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0x6f,0x01,0x01,0x03,0xa7
	.byte 0x01,0x66,0x19
	.ascii "src\0"
	.byte 0x00,0x00,0x3d,0x16,0x01,0x01,0x03,0xa8
	.byte 0x03,0x91,0xbc,0x7f,0x18,0x42,0x0e,0x04
	.byte 0x04,0x18,0x20,0xb0,0x01,0x20,0xcc,0x03
	.byte 0xe0,0x00,0x28,0xc4,0x03,0x18,0x44,0x01
	.byte 0x04,0x00,0x11,0x00,0x00,0x3d,0x09,0x07
	.byte 0x00,0x00,0x9e,0xd2,0x11,0x00,0x00,0x31
	.byte 0x50,0x07,0x00,0x00,0x9e,0xdc,0x1d
	.ascii "gl_write_stencil_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9f,0x1f
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x9e
	.byte 0xe1,0x00,0x1d
	.ascii "gl_write_color_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9f,0x6f
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x48
	.byte 0x21,0x13,0x00,0x00,0x34,0x84,0x13,0x00
	.byte 0x00,0x34,0x84,0x13,0x00,0x00,0x34,0x84
	.byte 0x13,0x00,0x00,0x34,0x84,0x13,0x00,0x00
	.byte 0x01,0xa7,0x00,0x1d
	.ascii "gl_write_index_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9f,0xb0
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0x5e,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x48
	.byte 0x21,0x13,0x00,0x00,0x45,0xb7,0x13,0x00
	.byte 0x00,0x01,0xa7,0x00,0x07,0x00,0x00,0x90
	.byte 0x46,0x11,0x00,0x00,0x3d,0x09,0x07,0x00
	.byte 0x00,0x9f,0xb5,0x1e
	.ascii "gl_pixel_addr_in_image\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x3d,0x16,0x01
	.byte 0x00,0x00,0xa0,0x11,0x13,0x00,0x00,0x9f
	.byte 0xb0,0x13,0x00,0x00,0x9f,0xba,0x13,0x00
	.byte 0x00,0x01,0x3a,0x13,0x00,0x00,0x01,0x3a
	.byte 0x13,0x00,0x00,0x01,0xa7,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0x01,0x3a,0x13
	.byte 0x00,0x00,0x01,0x3a,0x13,0x00,0x00,0x01
	.byte 0x3a,0x00,0x1e
	.ascii "gl_components_in_format\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x41,0x01
	.byte 0x00,0x00,0xa0,0x3c,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x1e
	.ascii "gl_sizeof_type\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x41,0x01
	.byte 0x00,0x00,0xa0,0x5e,0x13,0x00,0x00,0x01
	.byte 0xa7,0x00,0x1d
	.ascii "gl_swap4\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0x7b
	.byte 0x13,0x00,0x00,0x45,0xb7,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x1d
	.ascii "gl_swap2\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0x98
	.byte 0x13,0x00,0x00,0x48,0x21,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x1d
	.ascii "gl_flip_bytes\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0xba
	.byte 0x13,0x00,0x00,0x34,0x84,0x13,0x00,0x00
	.byte 0x01,0x5e,0x00,0x11,0x00,0x00,0x66,0xd2
	.byte 0x07,0x00,0x00,0xa0,0xba,0x1d
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa0,0xe6
	.byte 0x13,0x00,0x00,0x3c,0x53,0x13,0x00,0x00
	.byte 0x01,0xa7,0x13,0x00,0x00,0xa0,0xbf,0x00
	.byte 0x11,0x00,0x00,0x31,0x74,0x07,0x00,0x00
	.byte 0xa0,0xe6,0x1e
	.ascii "memcpy\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x31,0x7c,0x01
	.byte 0x00,0x00,0xa1,0x14,0x13,0x00,0x00,0x31
	.byte 0x7c,0x13,0x00,0x00,0xa0,0xeb,0x13,0x00
	.byte 0x00,0x01,0x5e,0x00,0x1e
	.ascii "malloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x31,0x7c,0x01
	.byte 0x00,0x00,0xa1,0x2e,0x13,0x00,0x00,0x01
	.byte 0x5e,0x00,0x1d
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xa1,0x42
	.byte 0x13,0x00,0x00,0x31,0x7c,0x00,0x11,0x00
	.byte 0x00,0x66,0xd2,0x07,0x00,0x00,0xa1,0x42
	.byte 0x11,0x00,0x00,0x66,0xd2,0x07,0x00,0x00
	.byte 0xa1,0x4c,0x1f
	.ascii "__assert\0"
	.byte 0x01,0x01,0x01,0x01,0x13,0x00,0x00,0xa1
	.byte 0x47,0x13,0x00,0x00,0xa1,0x51,0x13,0x00
	.byte 0x00,0x01,0x3a,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=114, siz=4, lab1=update_drawpixels_state, lab2=, loff=0
!   reloc[1]: knd=0, off=161, siz=4, lab1=gl_PixelZoom, lab2=, loff=0
!   reloc[2]: knd=0, off=276, siz=4, lab1=gl_write_zoomed_color_span, lab2=, loff=0
!   reloc[3]: knd=0, off=1271, siz=4, lab1=gl_write_zoomed_index_span, lab2=, loff=0
!   reloc[4]: knd=0, off=1945, siz=4, lab1=gl_write_zoomed_stencil_span, lab2=, loff=0
!   reloc[5]: knd=0, off=2407, siz=4, lab1=gl_PixelStorei, lab2=, loff=0
!   reloc[6]: knd=0, off=2741, siz=4, lab1=gl_PixelMapfv, lab2=, loff=0
!   reloc[7]: knd=0, off=3262, siz=4, lab1=gl_GetPixelMapfv, lab2=, loff=0
!   reloc[8]: knd=0, off=3623, siz=4, lab1=gl_GetPixelMapuiv, lab2=, loff=0
!   reloc[9]: knd=0, off=3974, siz=4, lab1=gl_GetPixelMapusv, lab2=, loff=0
!   reloc[10]: knd=0, off=4521, siz=4, lab1=gl_PixelTransferf, lab2=, loff=0
!   reloc[11]: knd=0, off=4794, siz=4, lab1=gl_unpack_pixels, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x13,0xf3,0x00,0x02,0x00,0x00
	.byte 0x00,0x65,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x70,0x69,0x78,0x65,0x6c,0x2e,0x63,0x00
	.byte 0x01,0x00,0x00,0x74,0x79,0x70,0x65,0x73
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x67,0x6c
	.byte 0x2e,0x68,0x00,0x02,0x00,0x00,0x64,0x64
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x00,0x00
	.byte 0x05,0x02
	.uaword update_drawpixels_state
	.byte 0x06,0x03,0xde,0x00,0x01,0x02,0x04,0x03
	.byte 0x04,0x01,0x02,0x01,0x03,0x7c,0x01,0x02
	.byte 0x4e,0x03,0x01,0x01,0x02,0x07,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x04,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_PixelZoom
	.byte 0x06,0x03,0xf1,0x00,0x01,0x1a,0x10,0x0e
	.byte 0x14,0x12,0x11,0x02,0x06,0x03,0x6c,0x01
	.byte 0x02,0x01,0x03,0x15,0x01,0x02,0x02,0x03
	.byte 0x6b,0x01,0x02,0x01,0x03,0x18,0x01,0x02
	.byte 0x02,0x03,0x68,0x01,0x02,0x01,0x03,0x15
	.byte 0x01,0x11,0x02,0x01,0x03,0x69,0x01,0x02
	.byte 0x01,0x03,0x17,0x01,0x02,0x01,0x03,0x69
	.byte 0x01,0x02,0x32,0x03,0x04,0x01,0x02,0x01
	.byte 0x03,0x7c,0x01,0x02,0x03,0x03,0x04,0x01
	.byte 0x02,0x01,0x03,0x7c,0x01,0x5c,0x02,0x06
	.byte 0x03,0x18,0x01,0x02,0x01,0x03,0x68,0x01
	.byte 0x02,0x01,0x03,0x03,0x01,0x02,0x01,0x03
	.byte 0x15,0x01,0x02,0x01,0x03,0x6b,0x01,0x02
	.byte 0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_zoomed_color_span
	.byte 0x06,0x02,0x04,0x03,0x96,0x01,0x01,0x02
	.byte 0x08,0x03,0x76,0x01,0x02,0x01,0x03,0x0a
	.byte 0x01,0x02,0x01,0x03,0x76,0x01,0x02,0x01
	.byte 0x03,0x0a,0x01,0x24,0x02,0x03,0x03,0x0a
	.byte 0x01,0x12,0x11,0x12,0x10,0x0e,0x02,0x01
	.byte 0x03,0x79,0x01,0x02,0x01,0x03,0x08,0x01
	.byte 0x0e,0x02,0x01,0x03,0x79,0x01,0x02,0x01
	.byte 0x03,0x08,0x01,0x0e,0x02,0x01,0x03,0x7b
	.byte 0x01,0x02,0x01,0x03,0x7e,0x01,0x11,0x02
	.byte 0x01,0x03,0x06,0x01,0x12,0x02,0x02,0x03
	.byte 0x7b,0x01,0x02,0x01,0x03,0x06,0x01,0x0e
	.byte 0x02,0x01,0x03,0x7b,0x01,0x02,0x01,0x03
	.byte 0x06,0x01,0x0e,0x11,0x02,0x02,0x03,0x03
	.byte 0x01,0x19,0x10,0x12,0x02,0x02,0x03,0x05
	.byte 0x01,0x02,0x02,0x03,0x7c,0x01,0x02,0x01
	.byte 0x03,0x6a,0x01,0x02,0x02,0x03,0x1e,0x01
	.byte 0x02,0x01,0x03,0x7c,0x01,0x02,0x03,0x03
	.byte 0x66,0x01,0x02,0x01,0x03,0x1e,0x01,0x02
	.byte 0x04,0x03,0x62,0x01,0x02,0x07,0x03,0x25
	.byte 0x01,0x02,0x01,0x03,0x79,0x01,0x02,0x02
	.byte 0x03,0x62,0x01,0x02,0x01,0x03,0x25,0x01
	.byte 0x02,0x01,0x03,0x5b,0x01,0x02,0x05,0x03
	.byte 0x27,0x01,0x02,0x01,0x03,0x7e,0x01,0x11
	.byte 0x0e,0x02,0x01,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x06,0x01,0x02,0x01,0x03,0x7a,0x01
	.byte 0x02,0x01,0x03,0x06,0x01,0x02,0x02,0x03
	.byte 0x07,0x01,0x02,0x02,0x03,0x7a,0x01,0x02
	.byte 0x01,0x03,0x06,0x01,0x02,0x06,0x03,0x03
	.byte 0x01,0x1d,0x02,0x09,0x03,0x0b,0x01,0x0e
	.byte 0x20,0x0e,0x1c,0x02,0x01,0x03,0x6c,0x01
	.byte 0x02,0x02,0x03,0x04,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x02,0x03,0x03,0x04,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x04,0x03,0x0c,0x01,0x02,0x01
	.byte 0x03,0x74,0x01,0x11,0x02,0xb0,0x03,0x03
	.byte 0x01,0x01,0x0e,0x10,0x0e,0x2c,0x36,0x10
	.byte 0x10,0x02,0x01,0x03,0x7e,0x01,0x10,0x10
	.byte 0x0e,0x16,0x02,0x01,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x02,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x02,0x02
	.byte 0x03,0x04,0x01,0x14,0x14,0x02,0x02,0x03
	.byte 0x7c,0x01,0x14,0x02,0x01,0x03,0x7e,0x01
	.byte 0x15,0x10,0x14,0x14,0x02,0x02,0x03,0x7c
	.byte 0x01,0x14,0x14,0x14,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x01,0x03,0x04,0x01,0x10,0x02
	.byte 0x02,0x03,0x7c,0x01,0x14,0x14,0x14,0x14
	.byte 0x02,0x01,0x03,0x7a,0x01,0x02,0x01,0x03
	.byte 0x06,0x01,0x02,0x01,0x03,0x7a,0x01,0x10
	.byte 0x0e,0x10,0x0e,0x11,0x14,0x02,0x02,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7e,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x01,0x03,0x04
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x02,0x02
	.byte 0x03,0x05,0x01,0x02,0x01,0x03,0x7b,0x01
	.byte 0x02,0x01,0x03,0x05,0x01,0x02,0x01,0x03
	.byte 0x7b,0x01,0x02,0x01,0x03,0x06,0x01,0x02
	.byte 0x01,0x03,0x7a,0x01,0x02,0x01,0x03,0x06
	.byte 0x01,0x02,0x01,0x03,0x7a,0x01,0x18,0x02
	.byte 0x01,0x03,0x16,0x01,0x02,0x01,0x03,0x69
	.byte 0x01,0x28,0x0e,0x10,0x0e,0x20,0x36,0x10
	.byte 0x10,0x02,0x01,0x03,0x7e,0x01,0x10,0x11
	.byte 0x02,0x01,0x03,0x7e,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7d,0x01,0x12
	.byte 0x02,0x01,0x03,0x05,0x01,0x02,0x01,0x03
	.byte 0x7b,0x01,0x02,0x02,0x03,0x06,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x02,0x03,0x03,0x01,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7c,0x01,0x10,0x10
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x02,0x03
	.byte 0x04,0x01,0x10,0x02,0x01,0x03,0x7c,0x01
	.byte 0x10,0x10,0x10,0x10,0x02,0x01,0x03,0x7c
	.byte 0x01,0x10,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7c,0x01,0x0e,0x11,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7c,0x01,0x10,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7c,0x01,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7b,0x01,0x02,0x01,0x03
	.byte 0x06,0x01,0x02,0x01,0x03,0x7a,0x01,0x10
	.byte 0x0e,0x10,0x0e,0x02,0x01,0x03,0x06,0x01
	.byte 0x0e,0x0e,0x0e,0x0e,0x02,0x01,0x03,0x04
	.byte 0x01,0x0e,0x02,0x01,0x03,0x7b,0x01,0x02
	.byte 0x01,0x03,0x04,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x02,0x03,0x06,0x01,0x02,0x01
	.byte 0x03,0x7a,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x04,0x03,0x17,0x01
	.byte 0x02,0x01,0x03,0x73,0x01,0x10,0x0e,0x14
	.byte 0x30,0x0e,0x10,0x0e,0x1c,0x2a,0x10,0x40
	.byte 0x0e,0x18,0x02,0x01,0x03,0x7e,0x01,0x14
	.byte 0x10,0x02,0x02,0x03,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x12,0x02,0x02,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x02,0x01,0x03,0x04,0x01
	.byte 0x02,0x02,0x03,0x7d,0x01,0x02,0x01,0x03
	.byte 0x04,0x01,0x14,0x02,0x01,0x03,0x7b,0x01
	.byte 0x02,0x02,0x03,0x05,0x01,0x10,0x02,0x03
	.byte 0x03,0x7a,0x01,0x14,0x12,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x11,0x10,0x02,0x02,0x03
	.byte 0x7d,0x01,0x02,0x01,0x03,0x04,0x01,0x14
	.byte 0x02,0x01,0x03,0x7b,0x01,0x02,0x02,0x03
	.byte 0x05,0x01,0x10,0x02,0x03,0x03,0x79,0x01
	.byte 0x10,0x11,0x02,0x01,0x03,0x7d,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x10,0x02,0x01,0x03
	.byte 0x7c,0x01,0x02,0x01,0x03,0x04,0x01,0x10
	.byte 0x02,0x01,0x03,0x7b,0x01,0x02,0x01,0x03
	.byte 0x05,0x01,0x10,0x02,0x01,0x03,0x7a,0x01
	.byte 0x02,0x01,0x03,0x06,0x01,0x10,0x02,0x02
	.byte 0x03,0x79,0x01,0x02,0x01,0x03,0x07,0x01
	.byte 0x02,0x01,0x03,0x7b,0x01,0x0e,0x10,0x10
	.byte 0x14,0x14,0x14,0x02,0x02,0x03,0x7b,0x01
	.byte 0x02,0x03,0x03,0x06,0x01,0x02,0x03,0x03
	.byte 0x7a,0x01,0x10,0x0e,0x10,0x10,0x14,0x14
	.byte 0x14,0x10,0x0e,0x10,0x02,0x01,0x03,0x79
	.byte 0x01,0x02,0x01,0x03,0x07,0x01,0x02,0x01
	.byte 0x03,0x79,0x01,0x10,0x16,0x14,0x0e,0x10
	.byte 0x20,0x14,0x14,0x14,0x14,0x10,0x0e,0x02
	.byte 0x01,0x03,0x7a,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x01,0x03,0x79,0x01,0x02,0x01
	.byte 0x03,0x07,0x01,0x02,0x01,0x03,0x79,0x01
	.byte 0x1c,0x02,0x01,0x03,0x0b,0x01,0x21,0x02
	.byte 0x02,0x03,0x7e,0x01,0x15,0x02,0x02,0x03
	.byte 0x7e,0x01,0x15,0x02,0x11,0x03,0x7e,0x01
	.byte 0x11,0x02,0x04,0x03,0x7e,0x01,0x15,0x02
	.byte 0x01,0x03,0xb6,0x7f,0x01,0x02,0x02,0x03
	.byte 0x2c,0x01,0x02,0x09,0x03,0x03,0x01,0x02
	.byte 0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_zoomed_index_span
	.byte 0x06,0x02,0x03,0x03,0xf8,0x01,0x01,0x4c
	.byte 0x02,0x03,0x03,0x0a,0x01,0x12,0x11,0x0e
	.byte 0x10,0x0e,0x10,0x02,0x01,0x03,0x78,0x01
	.byte 0x02,0x01,0x03,0x07,0x01,0x10,0x02,0x01
	.byte 0x03,0x78,0x01,0x02,0x01,0x03,0x07,0x01
	.byte 0x10,0x02,0x01,0x03,0x78,0x01,0x11,0x02
	.byte 0x01,0x03,0x05,0x01,0x10,0x0e,0x10,0x02
	.byte 0x01,0x03,0x7a,0x01,0x02,0x01,0x03,0x05
	.byte 0x01,0x10,0x0e,0x10,0x10,0x02,0x02,0x03
	.byte 0x03,0x01,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x04,0x01,0x02,0x03,0x03,0x66,0x01,0x02
	.byte 0x02,0x03,0x1e,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x02,0x03,0x66,0x01,0x02,0x01
	.byte 0x03,0x1e,0x01,0x02,0x04,0x03,0x62,0x01
	.byte 0x02,0x07,0x03,0x25,0x01,0x02,0x01,0x03
	.byte 0x79,0x01,0x02,0x02,0x03,0x62,0x01,0x02
	.byte 0x01,0x03,0x25,0x01,0x02,0x01,0x03,0x5b
	.byte 0x01,0x02,0x05,0x03,0x27,0x01,0x12,0x02
	.byte 0x02,0x03,0x7e,0x01,0x02,0x02,0x03,0x06
	.byte 0x01,0x02,0x04,0x03,0x07,0x01,0x02,0x02
	.byte 0x03,0x7a,0x01,0x02,0x01,0x03,0x09,0x01
	.byte 0x1d,0x02,0x05,0x03,0x08,0x01,0x0e,0x18
	.byte 0x0e,0x14,0x02,0x01,0x03,0x6f,0x01,0x02
	.byte 0x02,0x03,0x04,0x01,0x02,0x03,0x03,0x03
	.byte 0x01,0x21,0x02,0x4b,0x03,0x01,0x01,0x0e
	.byte 0x14,0x0e,0x18,0x2e,0x10,0x10,0x02,0x01
	.byte 0x03,0x7e,0x01,0x10,0x10,0x02,0x01,0x03
	.byte 0x7e,0x01,0x02,0x03,0x03,0x03,0x01,0x12
	.byte 0x14,0x12,0x14,0x12,0x14,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x01,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x14,0x0e,0x11,0x10
	.byte 0x0e,0x02,0x01,0x03,0x7e,0x01,0x11,0x02
	.byte 0x01,0x03,0x7e,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7d,0x01,0x02,0x01
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7d,0x01
	.byte 0x18,0x02,0x01,0x03,0x10,0x01,0x02,0x01
	.byte 0x03,0x6f,0x01,0x1c,0x0e,0x10,0x0e,0x14
	.byte 0x1e,0x10,0x14,0x0e,0x16,0x02,0x01,0x03
	.byte 0x03,0x01,0x02,0x01,0x03,0x7e,0x01,0x0e
	.byte 0x11,0x0e,0x10,0x02,0x01,0x03,0x7e,0x01
	.byte 0x02,0x02,0x03,0x03,0x01,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x01,0x03,0x03,0x01,0x0e
	.byte 0x14,0x12,0x14,0x12,0x02,0x02,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x15,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x10,0x0e,0x02
	.byte 0x01,0x03,0x03,0x01,0x0e,0x10,0x02,0x01
	.byte 0x03,0x7d,0x01,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x04,0x03,0x11,0x01,0x02,0x01
	.byte 0x03,0x76,0x01,0x14,0x12,0x10,0x1c,0x0e
	.byte 0x10,0x0e,0x14,0x2e,0x10,0x4c,0x0e,0x1c
	.byte 0x02,0x01,0x03,0x7e,0x01,0x14,0x10,0x12
	.byte 0x11,0x02,0x01,0x03,0x7d,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x15,0x10,0x02,0x01,0x03,0x7d,0x01,0x02
	.byte 0x01,0x03,0x03,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x02,0x01,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x14,0x12,0x11,0x02,0x02
	.byte 0x03,0x7e,0x01,0x15,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x01,0x03,0x03,0x01,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x10,0x11
	.byte 0x02,0x02,0x03,0x7d,0x01,0x02,0x01,0x03
	.byte 0x04,0x01,0x02,0x01,0x03,0x7d,0x01,0x10
	.byte 0x0e,0x15,0x10,0x02,0x01,0x03,0x7e,0x01
	.byte 0x02,0x01,0x03,0x7e,0x01,0x02,0x01,0x03
	.byte 0x03,0x01,0x10,0x0e,0x02,0x01,0x03,0x7e
	.byte 0x01,0x11,0x10,0x02,0x01,0x03,0x7e,0x01
	.byte 0x0e,0x02,0x01,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7e,0x01,0x11,0x02,0x01,0x03,0x7d
	.byte 0x01,0x11,0x18,0x02,0x02,0x03,0x7d,0x01
	.byte 0x02,0x03,0x03,0x03,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x11,0x0e,0x10,0x10,0x18,0x02
	.byte 0x03,0x03,0x7c,0x01,0x10,0x16,0x14,0x0e
	.byte 0x10,0x1c,0x18,0x18,0x02,0x03,0x03,0x7c
	.byte 0x01,0x18,0x02,0x01,0x03,0x08,0x01,0x18
	.byte 0x0e,0x10,0x36,0x10,0x16,0x14,0x02,0x01
	.byte 0x03,0xbd,0x7f,0x01,0x02,0x02,0x03,0x2c
	.byte 0x01,0x02,0x08,0x03,0x03,0x01,0x02,0x01
	.byte 0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_write_zoomed_stencil_span
	.byte 0x06,0x02,0x01,0x03,0xd2,0x02,0x01,0x4c
	.byte 0x02,0x02,0x03,0x09,0x01,0x11,0x0e,0x10
	.byte 0x12,0x14,0x0e,0x02,0x02,0x03,0x79,0x01
	.byte 0x02,0x02,0x03,0x07,0x01,0x10,0x02,0x01
	.byte 0x03,0x78,0x01,0x11,0x02,0x01,0x03,0x05
	.byte 0x01,0x10,0x0e,0x10,0x02,0x01,0x03,0x7a
	.byte 0x01,0x02,0x01,0x03,0x06,0x01,0x0e,0x10
	.byte 0x0e,0x11,0x02,0x02,0x03,0x03,0x01,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x04,0x01,0x02
	.byte 0x03,0x03,0x66,0x01,0x02,0x02,0x03,0x1e
	.byte 0x01,0x02,0x01,0x03,0x7c,0x01,0x02,0x03
	.byte 0x03,0x66,0x01,0x02,0x01,0x03,0x1e,0x01
	.byte 0x02,0x04,0x03,0x62,0x01,0x02,0x07,0x03
	.byte 0x25,0x01,0x02,0x01,0x03,0x79,0x01,0x02
	.byte 0x02,0x03,0x62,0x01,0x02,0x01,0x03,0x25
	.byte 0x01,0x02,0x01,0x03,0x5b,0x01,0x02,0x05
	.byte 0x03,0x27,0x01,0x12,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x01,0x03,0x06,0x01,0x02,0x05
	.byte 0x03,0x07,0x01,0x02,0x02,0x03,0x7a,0x01
	.byte 0x02,0x01,0x03,0x09,0x01,0x19,0x02,0x05
	.byte 0x03,0x07,0x01,0x0e,0x14,0x0e,0x14,0x02
	.byte 0x01,0x03,0x70,0x01,0x02,0x02,0x03,0x04
	.byte 0x01,0x02,0x02,0x03,0x03,0x01,0x1d,0x45
	.byte 0x02,0x01,0x03,0x7e,0x01,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x19,0x02,0x05,0x03,0x7e
	.byte 0x01,0x11,0x02,0x02,0x03,0x7e,0x01,0x15
	.byte 0x02,0x06,0x03,0x7e,0x01,0x11,0x02,0x02
	.byte 0x03,0x7e,0x01,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x11,0x02,0x01,0x03,0x7e,0x01,0x15
	.byte 0x02,0x01,0x03,0x7e,0x01,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x19,0x02,0x01,0x03,0x0d
	.byte 0x01,0x02,0x01,0x03,0x73,0x01,0x02,0x01
	.byte 0x03,0x7e,0x01,0x19,0x02,0x03,0x03,0x7e
	.byte 0x01,0x11,0x02,0x04,0x03,0x7e,0x01,0x11
	.byte 0x02,0x03,0x03,0x7e,0x01,0x15,0x02,0x05
	.byte 0x03,0x7e,0x01,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x11,0x02,0x02,0x03,0x7e,0x01,0x15
	.byte 0x02,0x01,0x03,0x7e,0x01,0x15,0x02,0x01
	.byte 0x03,0x7e,0x01,0x11,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x04,0x03,0x0f,0x01,0x02,0x01
	.byte 0x03,0x77,0x01,0x10,0x12,0x11,0x12,0x14
	.byte 0x2a,0x10,0x44,0x0e,0x24,0x02,0x01,0x03
	.byte 0x7e,0x01,0x14,0x12,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7e,0x01,0x1c,0x14
	.byte 0x02,0x01,0x03,0x7e,0x01,0x19,0x02,0x01
	.byte 0x03,0x7e,0x01,0x1c,0x18,0x02,0x01,0x03
	.byte 0x7d,0x01,0x10,0x15,0x02,0x01,0x03,0x7d
	.byte 0x01,0x10,0x10,0x14,0x02,0x02,0x03,0x7e
	.byte 0x01,0x19,0x02,0x01,0x03,0x7e,0x01,0x10
	.byte 0x0e,0x10,0x0e,0x19,0x02,0x01,0x03,0x7d
	.byte 0x01,0x11,0x0e,0x11,0x0e,0x10,0x02,0x02
	.byte 0x03,0x7d,0x01,0x10,0x16,0x14,0x0e,0x10
	.byte 0x1c,0x18,0x02,0x02,0x03,0x7d,0x01,0x14
	.byte 0x02,0x01,0x03,0x07,0x01,0x1c,0x1a,0x10
	.byte 0x12,0x14,0x02,0x01,0x03,0xbf,0x7f,0x01
	.byte 0x02,0x02,0x03,0x2c,0x01,0x02,0x08,0x03
	.byte 0x03,0x01,0x02,0x01,0x00,0x01,0x01,0x00
	.byte 0x05,0x02
	.uaword gl_PixelStorei
	.byte 0x06,0x02,0x01,0x03,0xa5,0x03,0x01,0x02
	.byte 0x07,0x03,0x05,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x05,0x03,0x04,0x01,0x31,0x20
	.byte 0x02,0x01,0x03,0xb1,0x7d,0x01,0x02,0x01
	.byte 0x03,0xd1,0x02,0x01,0x20,0x02,0x01,0x03
	.byte 0xae,0x7d,0x01,0x02,0x01,0x03,0xd4,0x02
	.byte 0x01,0x14,0x02,0x06,0x03,0xab,0x7d,0x01
	.byte 0x02,0x01,0x03,0xd8,0x02,0x01,0x02,0x03
	.byte 0x03,0xa8,0x7d,0x01,0x02,0x01,0x03,0xdc
	.byte 0x02,0x01,0x14,0x02,0x06,0x03,0xa3,0x7d
	.byte 0x01,0x02,0x01,0x03,0xe0,0x02,0x01,0x02
	.byte 0x03,0x03,0xa0,0x7d,0x01,0x02,0x01,0x03
	.byte 0xe4,0x02,0x01,0x14,0x02,0x06,0x03,0x9b
	.byte 0x7d,0x01,0x02,0x01,0x03,0xe8,0x02,0x01
	.byte 0x02,0x03,0x03,0x98,0x7d,0x01,0x02,0x01
	.byte 0x03,0xec,0x02,0x01,0x02,0x07,0x03,0x04
	.byte 0x01,0x02,0x06,0x03,0x90,0x7d,0x01,0x02
	.byte 0x01,0x03,0xed,0x02,0x01,0x02,0x03,0x03
	.byte 0x93,0x7d,0x01,0x02,0x01,0x03,0xf4,0x02
	.byte 0x01,0x20,0x02,0x01,0x03,0x8b,0x7d,0x01
	.byte 0x02,0x01,0x03,0xf7,0x02,0x01,0x20,0x02
	.byte 0x01,0x03,0x88,0x7d,0x01,0x02,0x01,0x03
	.byte 0xfa,0x02,0x01,0x14,0x02,0x06,0x03,0x85
	.byte 0x7d,0x01,0x02,0x01,0x03,0xfe,0x02,0x01
	.byte 0x02,0x03,0x03,0x82,0x7d,0x01,0x02,0x01
	.byte 0x03,0x82,0x03,0x01,0x14,0x02,0x06,0x03
	.byte 0xfd,0x7c,0x01,0x02,0x01,0x03,0x86,0x03
	.byte 0x01,0x02,0x03,0x03,0xfa,0x7c,0x01,0x02
	.byte 0x01,0x03,0x8a,0x03,0x01,0x14,0x02,0x06
	.byte 0x03,0xf5,0x7c,0x01,0x02,0x01,0x03,0x8e
	.byte 0x03,0x01,0x02,0x03,0x03,0xf2,0x7c,0x01
	.byte 0x02,0x01,0x03,0x92,0x03,0x01,0x02,0x07
	.byte 0x03,0x04,0x01,0x02,0x06,0x03,0xea,0x7c
	.byte 0x01,0x02,0x01,0x03,0x93,0x03,0x01,0x02
	.byte 0x03,0x03,0xed,0x7c,0x01,0x02,0x01,0x03
	.byte 0x9a,0x03,0x01,0x02,0x05,0x03,0xe6,0x7c
	.byte 0x01,0x02,0x04,0x03,0x04,0x01,0x02,0x01
	.byte 0x03,0x7c,0x01,0x02,0x4c,0x03,0x01,0x01
	.byte 0x02,0x07,0x03,0xc8,0x02,0x01,0x02,0x02
	.byte 0x03,0xbb,0x7d,0x01,0x02,0x02,0x03,0xc5
	.byte 0x02,0x01,0x02,0x02,0x00,0x01,0x01,0x00
	.byte 0x05,0x02
	.uaword gl_PixelMapfv
	.byte 0x06,0x02,0x01,0x03,0x8c,0x04,0x01,0x28
	.byte 0x02,0x05,0x03,0x04,0x01,0x02,0x02,0x03
	.byte 0x05,0x01,0x02,0x01,0x03,0x7c,0x01,0x02
	.byte 0x05,0x03,0x04,0x01,0x02,0x02,0x03,0x04
	.byte 0x01,0x10,0x1a,0x14,0x02,0x01,0x03,0x06
	.byte 0x01,0x02,0x05,0x03,0x05,0x01,0x02,0x0b
	.byte 0x03,0x03,0x01,0x0e,0x10,0x0e,0x10,0x3c
	.byte 0x12,0x10,0x22,0x10,0x0e,0x10,0x12,0x10
	.byte 0x0e,0x10,0x12,0x14,0x5a,0x10,0x1e,0x10
	.byte 0x16,0x10,0x0e,0x10,0x0e,0x14,0x0e,0x10
	.byte 0x12,0x02,0x03,0x03,0x03,0x01,0x02,0x02
	.byte 0x03,0x7d,0x01,0x14,0x16,0x14,0x0e,0x10
	.byte 0x16,0x14,0x12,0x10,0x11,0x02,0x02,0x03
	.byte 0x03,0x01,0x0e,0x10,0x0e,0x10,0x34,0x0e
	.byte 0x10,0x0e,0x1c,0x22,0x10,0x0e,0x10,0x12
	.byte 0x10,0x0e,0x10,0x12,0x14,0x5a,0x10,0x1e
	.byte 0x10,0x16,0x10,0x0e,0x10,0x0e,0x14,0x0e
	.byte 0x10,0x12,0x02,0x03,0x03,0x7d,0x01,0x02
	.byte 0x02,0x03,0x03,0x01,0x18,0x16,0x14,0x0e
	.byte 0x10,0x16,0x14,0x12,0x10,0x02,0x01,0x03
	.byte 0x7c,0x01,0x02,0x02,0x03,0x09,0x01,0x0e
	.byte 0x10,0x0e,0x10,0x74,0x0e,0x10,0x22,0x10
	.byte 0x0e,0x14,0x12,0x18,0x02,0x01,0x03,0x76
	.byte 0x01,0x02,0x02,0x03,0x09,0x01,0x14,0x0e
	.byte 0x18,0x26,0x10,0x0e,0x10,0x0e,0x10,0x12
	.byte 0x10,0x02,0x01,0x03,0x76,0x01,0x02,0x02
	.byte 0x03,0x0f,0x01,0x0e,0x10,0x0e,0x10,0x74
	.byte 0x0e,0x10,0x22,0x10,0x0e,0x14,0x12,0x18
	.byte 0x02,0x01,0x03,0x70,0x01,0x02,0x02,0x03
	.byte 0x0f,0x01,0x20,0x2a,0x10,0x0e,0x10,0x0e
	.byte 0x10,0x12,0x10,0x02,0x01,0x03,0x70,0x01
	.byte 0x02,0x02,0x03,0x15,0x01,0x0e,0x10,0x0e
	.byte 0x10,0x74,0x0e,0x10,0x22,0x10,0x0e,0x14
	.byte 0x12,0x18,0x02,0x01,0x03,0x6a,0x01,0x02
	.byte 0x02,0x03,0x15,0x01,0x20,0x2a,0x10,0x0e
	.byte 0x10,0x0e,0x10,0x12,0x10,0x02,0x01,0x03
	.byte 0x6a,0x01,0x02,0x02,0x03,0x1b,0x01,0x0e
	.byte 0x10,0x0e,0x10,0x74,0x0e,0x10,0x22,0x10
	.byte 0x0e,0x14,0x12,0x18,0x02,0x01,0x03,0x64
	.byte 0x01,0x02,0x02,0x03,0x1b,0x01,0x20,0x2a
	.byte 0x10,0x0e,0x10,0x0e,0x10,0x12,0x10,0x02
	.byte 0x01,0x03,0x64,0x01,0x02,0x02,0x03,0x21
	.byte 0x01,0x0e,0x10,0x0e,0x10,0x74,0x0e,0x10
	.byte 0x22,0x10,0x0e,0x14,0x12,0x18,0x02,0x01
	.byte 0x03,0x5e,0x01,0x02,0x02,0x03,0x21,0x01
	.byte 0x14,0x0e,0x18,0x26,0x10,0x0e,0x10,0x0e
	.byte 0x10,0x12,0x10,0x02,0x01,0x03,0x5e,0x01
	.byte 0x02,0x02,0x03,0x27,0x01,0x0e,0x10,0x0e
	.byte 0x10,0x74,0x0e,0x10,0x22,0x10,0x0e,0x14
	.byte 0x12,0x18,0x02,0x01,0x03,0x58,0x01,0x02
	.byte 0x02,0x03,0x27,0x01,0x20,0x2a,0x10,0x0e
	.byte 0x10,0x0e,0x10,0x12,0x10,0x02,0x01,0x03
	.byte 0x58,0x01,0x02,0x02,0x03,0x2d,0x01,0x0e
	.byte 0x10,0x0e,0x10,0x74,0x0e,0x10,0x22,0x10
	.byte 0x0e,0x14,0x12,0x18,0x02,0x01,0x03,0x52
	.byte 0x01,0x02,0x02,0x03,0x2d,0x01,0x14,0x0e
	.byte 0x18,0x26,0x10,0x0e,0x10,0x0e,0x10,0x12
	.byte 0x10,0x02,0x01,0x03,0x52,0x01,0x02,0x02
	.byte 0x03,0x33,0x01,0x0e,0x10,0x0e,0x10,0x74
	.byte 0x0e,0x10,0x22,0x10,0x0e,0x14,0x12,0x18
	.byte 0x02,0x01,0x03,0x4c,0x01,0x02,0x02,0x03
	.byte 0x33,0x01,0x20,0x2a,0x10,0x0e,0x10,0x0e
	.byte 0x10,0x12,0x10,0x02,0x01,0x03,0x4c,0x01
	.byte 0x02,0x02,0x03,0x38,0x01,0x02,0x05,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_GetPixelMapfv
	.byte 0x06,0x02,0x01,0x03,0xf0,0x04,0x01,0x28
	.byte 0x02,0x05,0x03,0x03,0x01,0x2b,0x19,0x48
	.byte 0x0e,0x1c,0x22,0x10,0x0e,0x10,0x12,0x14
	.byte 0x16,0x14,0x5a,0x10,0x1e,0x10,0x16,0x10
	.byte 0x0e,0x10,0x0e,0x14,0x0e,0x10,0x12,0x02
	.byte 0x03,0x03,0x03,0x01,0x02,0x02,0x03,0x7d
	.byte 0x01,0x18,0x16,0x14,0x0e,0x10,0x16,0x14
	.byte 0x12,0x10,0x11,0x15,0x44,0x0e,0x18,0x22
	.byte 0x10,0x0e,0x10,0x12,0x14,0x16,0x14,0x5a
	.byte 0x10,0x1e,0x10,0x16,0x10,0x0e,0x10,0x0e
	.byte 0x14,0x0e,0x10,0x12,0x02,0x03,0x03,0x7e
	.byte 0x01,0x15,0x14,0x16,0x14,0x0e,0x10,0x16
	.byte 0x14,0x12,0x10,0x02,0x01,0x03,0x7d,0x01
	.byte 0x02,0x02,0x03,0x07,0x01,0x02,0x33,0x03
	.byte 0x79,0x01,0x02,0x02,0x03,0x07,0x01,0x02
	.byte 0x2a,0x03,0x79,0x01,0x02,0x02,0x03,0x07
	.byte 0x01,0x02,0x02,0x03,0x79,0x01,0x02,0x02
	.byte 0x03,0x0a,0x01,0x02,0x30,0x03,0x76,0x01
	.byte 0x02,0x02,0x03,0x0a,0x01,0x02,0x2b,0x03
	.byte 0x76,0x01,0x02,0x02,0x03,0x0a,0x01,0x02
	.byte 0x02,0x03,0x76,0x01,0x02,0x02,0x03,0x0d
	.byte 0x01,0x02,0x33,0x03,0x73,0x01,0x02,0x02
	.byte 0x03,0x0d,0x01,0x02,0x28,0x03,0x73,0x01
	.byte 0x02,0x02,0x03,0x0d,0x01,0x02,0x02,0x03
	.byte 0x73,0x01,0x02,0x02,0x03,0x10,0x01,0x02
	.byte 0x34,0x03,0x70,0x01,0x02,0x02,0x03,0x10
	.byte 0x01,0x02,0x28,0x03,0x70,0x01,0x02,0x02
	.byte 0x03,0x10,0x01,0x02,0x02,0x03,0x70,0x01
	.byte 0x02,0x02,0x03,0x13,0x01,0x02,0x34,0x03
	.byte 0x6d,0x01,0x02,0x02,0x03,0x13,0x01,0x02
	.byte 0x2b,0x03,0x6d,0x01,0x02,0x02,0x03,0x13
	.byte 0x01,0x02,0x02,0x03,0x6d,0x01,0x02,0x02
	.byte 0x03,0x16,0x01,0x02,0x33,0x03,0x6a,0x01
	.byte 0x02,0x02,0x03,0x16,0x01,0x02,0x2a,0x03
	.byte 0x6a,0x01,0x02,0x02,0x03,0x16,0x01,0x02
	.byte 0x02,0x03,0x6a,0x01,0x02,0x02,0x03,0x19
	.byte 0x01,0x02,0x33,0x03,0x67,0x01,0x02,0x02
	.byte 0x03,0x19,0x01,0x02,0x29,0x03,0x67,0x01
	.byte 0x02,0x02,0x03,0x19,0x01,0x02,0x02,0x03
	.byte 0x67,0x01,0x02,0x02,0x03,0x1c,0x01,0x02
	.byte 0x30,0x03,0x64,0x01,0x02,0x02,0x03,0x1c
	.byte 0x01,0x02,0x2a,0x03,0x64,0x01,0x02,0x02
	.byte 0x03,0x1c,0x01,0x02,0x02,0x03,0x64,0x01
	.byte 0x02,0x02,0x03,0x1f,0x01,0x02,0x05,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_GetPixelMapuiv
	.byte 0x06,0x02,0x01,0x03,0xa1,0x05,0x01,0x02
	.byte 0x07,0x03,0x04,0x01,0x02,0x01,0x03,0x7d
	.byte 0x01,0x02,0x05,0x03,0x03,0x01,0x35,0x02
	.byte 0x34,0x03,0x09,0x01,0x02,0x02,0x03,0x77
	.byte 0x01,0x02,0x2a,0x03,0x09,0x01,0x02,0x02
	.byte 0x03,0x77,0x01,0x02,0x02,0x03,0x09,0x01
	.byte 0x02,0x02,0x03,0x7a,0x01,0x02,0x2f,0x03
	.byte 0x06,0x01,0x02,0x02,0x03,0x7a,0x01,0x02
	.byte 0x29,0x03,0x06,0x01,0x02,0x02,0x03,0x7a
	.byte 0x01,0x02,0x02,0x03,0x06,0x01,0x02,0x02
	.byte 0x03,0x7d,0x01,0x88,0x0e,0x10,0x32,0x10
	.byte 0x1a,0x10,0x12,0x1c,0x11,0x02,0x02,0x03
	.byte 0x7d,0x01,0x18,0x0e,0x10,0x52,0x1c,0x11
	.byte 0x15,0x88,0x0e,0x10,0x32,0x10,0x1a,0x10
	.byte 0x12,0x1c,0x02,0x01,0x03,0x7d,0x01,0x15
	.byte 0x18,0x0e,0x10,0x52,0x1c,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x02,0x03,0x07,0x01,0x88
	.byte 0x0e,0x10,0x32,0x10,0x1a,0x10,0x12,0x1c
	.byte 0x02,0x01,0x03,0x78,0x01,0x02,0x02,0x03
	.byte 0x07,0x01,0x18,0x0e,0x10,0x52,0x1c,0x02
	.byte 0x01,0x03,0x78,0x01,0x02,0x02,0x03,0x0c
	.byte 0x01,0x88,0x0e,0x10,0x32,0x10,0x1a,0x10
	.byte 0x12,0x1c,0x02,0x01,0x03,0x73,0x01,0x02
	.byte 0x02,0x03,0x0c,0x01,0x18,0x0e,0x10,0x52
	.byte 0x1c,0x02,0x01,0x03,0x73,0x01,0x02,0x02
	.byte 0x03,0x11,0x01,0x88,0x0e,0x10,0x32,0x10
	.byte 0x1a,0x10,0x12,0x1c,0x02,0x01,0x03,0x6e
	.byte 0x01,0x02,0x02,0x03,0x11,0x01,0x18,0x0e
	.byte 0x10,0x52,0x1c,0x02,0x01,0x03,0x6e,0x01
	.byte 0x02,0x02,0x03,0x16,0x01,0x88,0x0e,0x10
	.byte 0x32,0x10,0x1a,0x10,0x12,0x1c,0x02,0x01
	.byte 0x03,0x69,0x01,0x02,0x02,0x03,0x16,0x01
	.byte 0x18,0x0e,0x10,0x52,0x1c,0x02,0x01,0x03
	.byte 0x69,0x01,0x02,0x02,0x03,0x1b,0x01,0x88
	.byte 0x0e,0x10,0x32,0x10,0x1a,0x10,0x12,0x1c
	.byte 0x02,0x01,0x03,0x64,0x01,0x02,0x02,0x03
	.byte 0x1b,0x01,0x18,0x0e,0x10,0x52,0x1c,0x02
	.byte 0x01,0x03,0x64,0x01,0x02,0x02,0x03,0x20
	.byte 0x01,0x88,0x0e,0x10,0x32,0x10,0x1a,0x10
	.byte 0x12,0x1c,0x02,0x01,0x03,0x5f,0x01,0x02
	.byte 0x02,0x03,0x20,0x01,0x18,0x0e,0x10,0x52
	.byte 0x1c,0x02,0x01,0x03,0x5f,0x01,0x02,0x02
	.byte 0x03,0x25,0x01,0x02,0x05,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_GetPixelMapusv
	.byte 0x06,0x02,0x01,0x03,0xde,0x05,0x01,0x28
	.byte 0x02,0x05,0x03,0x03,0x01,0x2f,0x19,0x3c
	.byte 0x0e,0x18,0x0e,0x18,0x16,0x10,0x0e,0x10
	.byte 0x12,0x10,0x0e,0x10,0x0e,0x14,0x1e,0x10
	.byte 0x0e,0x10,0x0e,0x14,0x0e,0x14,0x0e,0x10
	.byte 0x0e,0x02,0x03,0x03,0x03,0x01,0x02,0x02
	.byte 0x03,0x7d,0x01,0x18,0x16,0x10,0x0e,0x14
	.byte 0x1a,0x14,0x0e,0x10,0x11,0x15,0x3c,0x0e
	.byte 0x14,0x0e,0x18,0x16,0x10,0x0e,0x10,0x12
	.byte 0x10,0x0e,0x10,0x0e,0x14,0x1e,0x10,0x0e
	.byte 0x10,0x0e,0x14,0x0e,0x14,0x0e,0x10,0x0e
	.byte 0x02,0x03,0x03,0x7e,0x01,0x15,0x14,0x16
	.byte 0x10,0x0e
	.byte 0x14,0x1a,0x14,0x0e,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x02,0x02,0x03,0x07,0x01,0x40
	.byte 0x0e,0x14,0x0e,0x1c,0x5e,0x10,0x0e,0x10
	.byte 0x22,0x10,0x16,0x18,0x56,0x10,0x32,0x10
	.byte 0x32,0x10,0x0e,0x10,0x16,0x18,0x1a,0x14
	.byte 0x02,0x01,0x03,0x78,0x01,0x02,0x02,0x03
	.byte 0x07,0x01,0x18,0x0e,0x10,0x16,0x10,0x0e
	.byte 0x10,0x1a,0x10,0x02,0x01,0x03,0x78,0x01
	.byte 0x02,0x02,0x03,0x0c,0x01,0x44,0x0e,0x10
	.byte 0x0e,0x18,0x5e,0x10,0x0e,0x10,0x22,0x10
	.byte 0x16,0x18,0x56,0x10,0x32,0x10,0x32,0x10
	.byte 0x0e,0x10,0x16,0x18,0x1a,0x14,0x02,0x01
	.byte 0x03,0x73,0x01,0x02,0x02,0x03,0x0c,0x01
	.byte 0x18,0x0e,0x10,0x16,0x10,0x0e,0x10,0x1a
	.byte 0x10,0x02,0x01,0x03,0x73,0x01,0x02,0x02
	.byte 0x03,0x11,0x01,0x44,0x0e,0x20,0x5e,0x10
	.byte 0x0e,0x10,0x22,0x10,0x16,0x18,0x56,0x10
	.byte 0x32,0x10,0x32,0x10,0x0e,0x10,0x16,0x18
	.byte 0x1a,0x14,0x02,0x01,0x03,0x6e,0x01,0x02
	.byte 0x02,0x03,0x11,0x01,0x18,0x0e,0x10,0x16
	.byte 0x10,0x0e,0x10,0x1a,0x10,0x02,0x01,0x03
	.byte 0x6e,0x01,0x02,0x02,0x03,0x16,0x01,0x44
	.byte 0x0e,0x20,0x5e,0x10,0x0e,0x10,0x22,0x10
	.byte 0x16,0x18,0x56,0x10,0x32,0x10,0x32,0x10
	.byte 0x0e,0x10,0x16,0x18,0x1a,0x14,0x02,0x01
	.byte 0x03,0x69,0x01,0x02,0x02,0x03,0x16,0x01
	.byte 0x18,0x0e,0x10,0x16,0x10,0x0e,0x10,0x1a
	.byte 0x10,0x02,0x01,0x03,0x69,0x01,0x02,0x02
	.byte 0x03,0x1b,0x01,0x44,0x0e,0x20,0x5e,0x10
	.byte 0x0e,0x10,0x22,0x10,0x16,0x18,0x56,0x10
	.byte 0x32,0x10,0x32,0x10,0x0e,0x10,0x16,0x18
	.byte 0x1a,0x14,0x02,0x01,0x03,0x64,0x01,0x02
	.byte 0x02,0x03,0x1b,0x01,0x18,0x0e,0x10,0x16
	.byte 0x10,0x0e,0x10,0x1a,0x10,0x02,0x01,0x03
	.byte 0x64,0x01,0x02,0x02,0x03,0x20,0x01,0x44
	.byte 0x0e,0x20,0x5e,0x10,0x0e,0x10,0x22,0x10
	.byte 0x16,0x18,0x56,0x10,0x32,0x10,0x32,0x10
	.byte 0x0e,0x10,0x16,0x18,0x1a,0x14,0x02,0x01
	.byte 0x03,0x5f,0x01,0x02,0x02,0x03,0x20,0x01
	.byte 0x18,0x0e,0x10,0x16,0x10,0x0e,0x10,0x1a
	.byte 0x10,0x02,0x01,0x03,0x5f,0x01,0x02,0x02
	.byte 0x03,0x25,0x01,0x44,0x0e,0x1c,0x0e,0x10
	.byte 0x5e,0x10,0x0e,0x10,0x22,0x10,0x16,0x18
	.byte 0x56,0x10,0x32,0x10,0x32,0x10,0x0e,0x10
	.byte 0x16,0x18,0x1a,0x14,0x02,0x01,0x03,0x5a
	.byte 0x01,0x02,0x02,0x03,0x25,0x01,0x18,0x0e
	.byte 0x10,0x16,0x10,0x0e,0x10,0x1a,0x10,0x02
	.byte 0x01,0x03,0x5a,0x01,0x02,0x02,0x03,0x2a
	.byte 0x01,0x44,0x0e,0x1c,0x5e,0x10,0x0e,0x10
	.byte 0x22,0x10,0x16,0x18,0x56,0x10,0x32,0x10
	.byte 0x32,0x10,0x0e,0x10,0x16,0x18,0x1a,0x14
	.byte 0x02,0x01,0x03,0x55,0x01,0x02,0x02,0x03
	.byte 0x2a,0x01,0x18,0x0e,0x10,0x16,0x10,0x0e
	.byte 0x10,0x1a,0x10,0x02,0x01,0x03,0x55,0x01
	.byte 0x02,0x02,0x03,0x2f,0x01,0x02,0x05,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_PixelTransferf
	.byte 0x06,0x02,0x01,0x03,0xa7,0x06,0x01,0x2c
	.byte 0x02,0x05,0x03,0x04,0x01,0x02,0x0a,0x03
	.byte 0x29,0x01,0x14,0x02,0x01,0x03,0x88,0x7a
	.byte 0x01,0x02,0x01,0x03,0xd0,0x05,0x01,0x02
	.byte 0x02,0x03,0x04,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x20,0x02,0x01,0x03,0xaf,0x7a,0x01
	.byte 0x02,0x01,0x03,0xd3,0x05,0x01,0x02,0x02
	.byte 0x03,0x04,0x01,0x02,0x01,0x03,0x7c,0x01
	.byte 0x20,0x02,0x01,0x03,0xac,0x7a,0x01,0x02
	.byte 0x01,0x03,0xda,0x05,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x18,0x02,0x01,0x03,0xa9,0x7a
	.byte 0x01,0x02,0x01,0x03,0xdd,0x05,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x18,0x02,0x01,0x03
	.byte 0xa6,0x7a,0x01,0x02,0x01,0x03,0xdc,0x05
	.byte 0x01,0x14,0x02,0x01,0x03,0xa3,0x7a,0x01
	.byte 0x02,0x01,0x03,0xdf,0x05,0x01,0x14,0x02
	.byte 0x01,0x03,0xa0,0x7a,0x01,0x02,0x01,0x03
	.byte 0xe2,0x05,0x01,0x14,0x02,0x01,0x03,0x9d
	.byte 0x7a,0x01,0x02,0x01,0x03,0xe5,0x05,0x01
	.byte 0x14,0x02,0x01,0x03,0x9a,0x7a,0x01,0x02
	.byte 0x01,0x03,0xe8,0x05,0x01,0x14,0x02,0x01
	.byte 0x03,0x97,0x7a,0x01,0x02,0x01,0x03,0xeb
	.byte 0x05,0x01,0x14,0x02,0x01,0x03,0x94,0x7a
	.byte 0x01,0x02,0x01,0x03,0xee,0x05,0x01,0x14
	.byte 0x02,0x01,0x03,0x91,0x7a,0x01,0x02,0x01
	.byte 0x03,0xf1,0x05,0x01,0x14,0x02,0x01,0x03
	.byte 0x8e,0x7a,0x01,0x02,0x02,0x03,0xf4,0x05
	.byte 0x01,0x02,0x02,0x03,0x8c,0x7a,0x01,0x02
	.byte 0x03,0x03,0x04,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x02,0x4d,0x03,0x01,0x01,0x02,0x07
	.byte 0x03,0xca,0x05,0x01,0x02,0x02,0x03,0xb9
	.byte 0x7a,0x01,0x02,0x02,0x03,0xc7,0x05,0x01
	.byte 0x02,0x02,0x03,0x2f,0x01,0x02,0x05,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_unpack_pixels
	.byte 0x06,0x02,0x03,0x03,0xf6,0x06,0x01,0x18
	.byte 0x10,0x02,0x05,0x03,0x37,0x01,0x02,0x02
	.byte 0x03,0x47,0x01,0x02,0x01,0x03,0x06,0x01
	.byte 0x18,0x10,0x02,0x05,0x03,0x31,0x01,0x02
	.byte 0x02,0x03,0x53,0x01,0x02,0x04,0x03,0x07
	.byte 0x01,0x34,0x18,0x02,0x01,0x03,0x05,0x01
	.byte 0x02,0x01,0x03,0x1f,0x01,0x02,0x02,0x03
	.byte 0x61,0x01,0x2d,0x02,0x02,0x03,0x78,0x01
	.byte 0x02,0x01,0x03,0x07,0x01,0x18,0x11,0x02
	.byte 0x01,0x03,0x7d,0x01,0x02,0x02,0x03,0x03
	.byte 0x01,0x34,0x02,0x01,0x03,0x04,0x01,0x02
	.byte 0x2c,0x03,0x79,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x03,0x03,0x79,0x01,0x02,0x01
	.byte 0x03,0x07,0x01,0x02,0x2b,0x03,0x79,0x01
	.byte 0x02,0x01,0x03,0x07,0x01,0x02,0x02,0x03
	.byte 0x79,0x01,0x02,0x02,0x03,0x08,0x01,0x02
	.byte 0x01,0x03,0x78,0x01,0x11,0x02,0x01,0x03
	.byte 0x7e,0x01,0x02,0x01,0x03,0x0c,0x01,0x02
	.byte 0x01,0x03,0x78,0x01,0x02,0x02,0x03,0x19
	.byte 0x01,0x02,0x02,0x03,0x6f,0x01,0x24,0x02
	.byte 0x03,0x03,0x10,0x01,0x02,0x02,0x03,0x7a
	.byte 0x01,0x02,0x02,0x03,0x03,0x01,0x10,0x18
	.byte 0x02,0x01,0x03,0x06,0x01,0x02,0x01,0x03
	.byte 0x7b,0x01,0x02,0x02,0x03,0x05,0x01,0x02
	.byte 0x01,0x03,0x79,0x01,0x02,0x01,0x03,0x06
	.byte 0x01,0x18,0x11,0x02,0x01,0x03,0x7d,0x01
	.byte 0x02,0x02,0x03,0x03,0x01,0x34,0x02,0x01
	.byte 0x03,0x04,0x01,0x02,0x2c,0x03,0x79,0x01
	.byte 0x02,0x01,0x03,0x07,0x01,0x02,0x03,0x03
	.byte 0x79,0x01,0x02,0x01,0x03,0x07,0x01,0x02
	.byte 0x2b,0x03,0x79,0x01,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x02,0x03,0x79,0x01,0x02,0x02
	.byte 0x03,0x08,0x01,0x02,0x01,0x03,0x78,0x01
	.byte 0x11,0x02,0x01,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x0c,0x01,0x02,0x01,0x03,0x78,0x01
	.byte 0x02,0x02,0x03,0x77,0x01,0x02,0x02,0x03
	.byte 0x11,0x01,0x2c,0x14,0x02,0x05,0x03,0x6d
	.byte 0x01,0x02,0x02,0x03,0x15,0x01,0x14,0x02
	.byte 0x06,0x03,0x6a,0x01,0x02,0x04,0x00,0x01
	.byte 0x01
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
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x04,0x24
	.byte 0x00,0x03,0x08,0x3e,0x0b,0x0b,0x0b,0x00
	.byte 0x00,0x05,0x16,0x00,0x49,0x13,0x03,0x08
	.byte 0x3a,0x0b,0x00,0x00,0x06,0x13,0x00,0x03
	.byte 0x08,0x3c,0x0c,0x00,0x00,0x07,0x0f,0x00
	.byte 0x49,0x13,0x00,0x00,0x08,0x01,0x01,0x49
	.byte 0x13,0x0b,0x0b,0x01,0x13,0x00,0x00,0x09
	.byte 0x21,0x00,0x49,0x13,0x2f,0x0b,0x00,0x00
	.byte 0x0a,0x04,0x01,0x0b,0x0b,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x0b,0x28,0x00,0x03,0x08
	.byte 0x1c,0x0d,0x00,0x00,0x0c,0x13,0x01,0x03
	.byte 0x08,0x0b,0x0b,0x3a,0x0b,0x01,0x13,0x00
	.byte 0x00,0x0d,0x0d,0x00,0x03,0x08,0x49,0x13
	.byte 0x38,0x0a,0x00,0x00,0x0e,0x01,0x01,0x49
	.byte 0x13,0x0b,0x05,0x01,0x13,0x00,0x00,0x0f
	.byte 0x21,0x00,0x49,0x13,0x2f,0x05,0x00,0x00
	.byte 0x10,0x13,0x01,0x03,0x08,0x0b,0x05,0x3a
	.byte 0x0b,0x01,0x13,0x00,0x00,0x11,0x26,0x00
	.byte 0x49,0x13,0x00,0x00,0x12,0x15,0x01,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x13,0x05,0x00,0x49,0x13,0x00,0x00,0x14
	.byte 0x15,0x01,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x15,0x15,0x00
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x00
	.byte 0x00,0x16,0x2e,0x01,0x03,0x08,0x3f,0x0c
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x11,0x01
	.byte 0x12,0x01,0x40,0x0a,0x27,0x0c,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x17,0x34,0x00
	.byte 0x03,0x08,0x49,0x13,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x18,0x86
	.byte 0x84,0x01,0x00,0x92,0x44,0x0b,0x91,0x44
	.byte 0x09,0x00,0x00,0x19,0x34,0x00,0x03,0x08
	.byte 0x49,0x13,0x17,0x0b,0x3a,0x0b,0x3b,0x05
	.byte 0x02,0x0a,0x00,0x00,0x1a,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b
	.byte 0x05,0x11,0x01,0x12,0x01,0x40,0x0a,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x1b,0x05,0x00,0x49,0x13,0x03,0x08,0x3a
	.byte 0x0b,0x3b,0x05,0x02,0x0a,0x00,0x00,0x1c
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12,0x01
	.byte 0x40,0x0a,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x1d,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x1e
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x1f,0x2e,0x01,0x03,0x08
	.byte 0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x88,0x44
	.byte 0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x01,0x10,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa1,0x78,0x00,0x00,0x94,0xba
	.byte 0x67,0x6c,0x5f,0x50,0x69,0x78,0x65,0x6c
	.byte 0x5a,0x6f,0x6f,0x6d,0x00,0x00,0x00,0x95
	.byte 0x10,0x67,0x6c,0x5f,0x77,0x72,0x69,0x74
	.byte 0x65,0x5f,0x7a,0x6f,0x6f,0x6d,0x65,0x64
	.byte 0x5f,0x63,0x6f,0x6c,0x6f,0x72,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x97,0xa6
	.byte 0x67,0x6c,0x5f,0x77,0x72,0x69,0x74,0x65
	.byte 0x5f,0x7a,0x6f,0x6f,0x6d,0x65,0x64,0x5f
	.byte 0x69,0x6e,0x64,0x65,0x78,0x5f,0x73,0x70
	.byte 0x61,0x6e,0x00,0x00,0x00,0x99,0x3b,0x67
	.byte 0x6c,0x5f,0x77,0x72,0x69,0x74,0x65,0x5f
	.byte 0x7a,0x6f,0x6f,0x6d,0x65,0x64,0x5f,0x73
	.byte 0x74,0x65,0x6e,0x63,0x69,0x6c,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x9a,0xa4
	.byte 0x67,0x6c,0x5f,0x50,0x69,0x78,0x65,0x6c
	.byte 0x53,0x74,0x6f,0x72,0x65,0x69,0x00,0x00
	.byte 0x00,0x9a,0xfe,0x67,0x6c,0x5f,0x50,0x69
	.byte 0x78,0x65,0x6c,0x4d,0x61,0x70,0x66,0x76
	.byte 0x00,0x00,0x00,0x9b,0x9b,0x67,0x6c,0x5f
	.byte 0x47,0x65,0x74,0x50,0x69,0x78,0x65,0x6c
	.byte 0x4d,0x61,0x70,0x66,0x76,0x00,0x00,0x00
	.byte 0x9c,0x01,0x67,0x6c,0x5f,0x47,0x65,0x74
	.byte 0x50,0x69,0x78,0x65,0x6c,0x4d,0x61,0x70
	.byte 0x75,0x69,0x76,0x00,0x00,0x00,0x9c,0x68
	.byte 0x67,0x6c,0x5f,0x47,0x65,0x74,0x50,0x69
	.byte 0x78,0x65,0x6c,0x4d,0x61,0x70,0x75,0x73
	.byte 0x76,0x00,0x00,0x00,0x9c,0xd4,0x67,0x6c
	.byte 0x5f,0x50,0x69,0x78,0x65,0x6c,0x54,0x72
	.byte 0x61,0x6e,0x73,0x66,0x65,0x72,0x66,0x00
	.byte 0x00,0x00,0x9d,0x32,0x67,0x6c,0x5f,0x75
	.byte 0x6e,0x70,0x61,0x63,0x6b,0x5f,0x70,0x69
	.byte 0x78,0x65,0x6c,0x73,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0x2c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa1,0x78,0x00,0x00,0x00,0xfe
	.byte 0x75,0x70,0x64,0x61,0x74,0x65,0x5f,0x64
	.byte 0x72,0x61,0x77,0x70,0x69,0x78,0x65,0x6c
	.byte 0x73,0x5f,0x73,0x74,0x61,0x74,0x65,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x24,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xa1,0x78,0x00,0x00,0x01,0x41
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x01,0x6a,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x01,0x80,0x47,0x4c,0x66
	.byte 0x6c,0x6f,0x61,0x74,0x00,0x00,0x00,0x01
	.byte 0xa7,0x00,0x00,0x00,0x31,0x43,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x31
	.byte 0x61,0x47,0x4c,0x75,0x62,0x79,0x74,0x65
	.byte 0x00,0x00,0x00,0x31,0x81,0x67,0x6c,0x5f
	.byte 0x74,0x65,0x78,0x74,0x75,0x72,0x65,0x5f
	.byte 0x69,0x6d,0x61,0x67,0x65,0x00,0x00,0x00
	.byte 0x32,0xb3,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x34,0xc8
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x32,0xc3,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x34,0xe5,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x3d,0x09
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x3d,0x1b,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x55,0x3e
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x63
	.byte 0xe2,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x65,0x8a,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x65,0x9e,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x65,0xb1
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x65,0xcf,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x65,0xe2,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x66,0xb9,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x6d,0x17
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0x4a
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0x80,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0xbf
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0xf5,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x6f,0xdc,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x75,0x14,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x75
	.byte 0x2a,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x75,0x8a,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x75,0xd7
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x77,0xec,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x78,0xd6
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x79,0x29,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7b,0x9f,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x7c,0x18,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7c,0xeb,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x7f,0x92,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x80
	.byte 0x33,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x81
	.byte 0x23,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0x44,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x82,0x53,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0xcc,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x83,0xb2
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x86,0x82,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x86,0xfb
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x88,0x3f,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x88,0x4d,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x88,0xa8
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8a,0x02,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0x64,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0xde,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x8d,0x9b,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x90,0x46,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x90,0xfa
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x91,0x4e,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x91,0xc8,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x93,0x52,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x93,0xc7,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x35,0x86,0x67
	.byte 0x6c,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
	.byte 0x74,0x00,0x00,0x00,0x94,0xa5,0x47,0x4c
	.byte 0x63,0x6f,0x6e,0x74,0x65,0x78,0x74,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)assert.h\t1.10\t04/05/18 SMI"	! (/tmp/acompAAA.11174.oZaW0v:8)
	.ident	"@(#)stdio.h\t1.84\t04/09/28 SMI"	! (/tmp/acompAAA.11174.oZaW0v:9)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11174.oZaW0v:10)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11174.oZaW0v:11)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11174.oZaW0v:12)
	.ident	"@(#)stdio_iso.h\t1.8\t05/08/16 SMI"	! (/tmp/acompAAA.11174.oZaW0v:13)
	.ident	"@(#)va_list.h\t1.15\t04/11/19 SMI"	! (/tmp/acompAAA.11174.oZaW0v:14)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11174.oZaW0v:15)
	.ident	"@(#)stdio_impl.h\t1.15\t07/03/05 SMI"	! (/tmp/acompAAA.11174.oZaW0v:16)
	.ident	"@(#)stdio_c99.h\t1.2\t04/03/29 SMI"	! (/tmp/acompAAA.11174.oZaW0v:17)
	.ident	"@(#)stdlib.h\t1.51\t04/06/30 SMI"	! (/tmp/acompAAA.11174.oZaW0v:18)
	.ident	"@(#)stdlib_iso.h\t1.9\t04/09/28 SMI"	! (/tmp/acompAAA.11174.oZaW0v:19)
	.ident	"@(#)stdlib_c99.h\t1.2\t04/03/29 SMI"	! (/tmp/acompAAA.11174.oZaW0v:20)
	.ident	"@(#)string.h\t1.27\t07/01/14 SMI"	! (/tmp/acompAAA.11174.oZaW0v:21)
	.ident	"@(#)string_iso.h\t1.5\t04/06/18 SMI"	! (/tmp/acompAAA.11174.oZaW0v:22)
	.ident	"@(#)math.h\t2.24\t04/10/23 SMI"	! (/tmp/acompAAA.11174.oZaW0v:23)
	.ident	"@(#)math_iso.h\t1.9\t04/10/23 SMI"	! (/tmp/acompAAA.11174.oZaW0v:24)
	.ident	"@(#)math_c99.h\t1.9\t04/11/01 SMI"	! (/tmp/acompAAA.11174.oZaW0v:25)
	.ident	"@(#)floatingpoint.h\t2.9\t04/10/23 SMI"	! (/tmp/acompAAA.11174.oZaW0v:26)
	.ident	"@(#)ieeefp.h\t2.12\t04/10/23 SMI"	! (/tmp/acompAAA.11174.oZaW0v:27)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11174.oZaW0v:132)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11174.oZaW0v:133)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
