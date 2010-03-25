
	.section	".text",#alloc,#execinstr,#progbits
	.file	"logic.c"

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

.L18:
	.ascii	"glLogicOp\000"
	.align	4
!
! CONSTANT POOL
!

.L38:
	.ascii	"glLogicOp\000"
	.align	4
!
! CONSTANT POOL
!

.L169:
	.ascii	"gl_logic error\000"
	.align	4
!
! CONSTANT POOL
!

.L300:
	.ascii	"gl_logic_pixels error\000"
	.align	4
!
! CONSTANT POOL
!

.L431:
	.ascii	"Bad function in gl_logicop_rgba_span\000"
	.align	4
!
! CONSTANT POOL
!

.L564:
	.ascii	"Bad function in gl_logicop_rgba_pixels\000"

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000101:
/* 000000	   0 */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0004	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0008	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x000c	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0010	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0014	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0018	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x001c	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0020	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0024	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0028	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x002c	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0030	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0034	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0038	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x003c	     */		.word	(.L77002029-(___const_seg_900000101+0x0))
/* 0x0040	   0 */		.type	___const_seg_900000101,1
/* 0x0040	   0 */		.size	___const_seg_900000101,(.-___const_seg_900000101)
/* 0x0040	   0 */		.align	4
! FILE logic.c

!    1		      !/* $Id: logic.c,v 1.7 1997/07/24 01:24:11 brianp Exp $ */
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
!   25		      ! * $Log: logic.c,v $
!   26		      ! * Revision 1.7  1997/07/24 01:24:11  brianp
!   27		      ! * changed precompiled header symbol from PCH to PC_HEADER
!   28		      ! *
!   29		      ! * Revision 1.6  1997/05/28 03:25:26  brianp
!   30		      ! * added precompiled header (PCH) support
!   31		      ! *
!   32		      ! * Revision 1.5  1997/04/20 20:28:49  brianp
!   33		      ! * replaced abort() with gl_problem()
!   34		      ! *
!   35		      ! * Revision 1.4  1997/03/04 18:56:57  brianp
!   36		      ! * added #include <stdlib.h> for abort()
!   37		      ! *
!   38		      ! * Revision 1.3  1997/01/28 22:16:31  brianp
!   39		      ! * added gl_logicop_rgba_span() and gl_logicop_rgba_pixels()
!   40		      ! *
!   41		      ! * Revision 1.2  1997/01/04 00:13:11  brianp
!   42		      ! * was using ! instead of ~ to invert pixel bits (ugh!)
!   43		      ! *
!   44		      ! * Revision 1.1  1996/09/13 01:38:16  brianp
!   45		      ! * Initial revision
!   46		      ! *
!   47		      ! */
!   50		      !#ifdef PC_HEADER
!   51		      !#include "all.h"
!   52		      !#else
!   53		      !#include <stdlib.h>
!   54		      !#include "alphabuf.h"
!   55		      !#include "context.h"
!   56		      !#include "dlist.h"
!   57		      !#include "logic.h"
!   58		      !#include "macros.h"
!   59		      !#include "pb.h"
!   60		      !#include "span.h"
!   61		      !#include "types.h"
!   62		      !#endif
!   66		      !void gl_LogicOp( GLcontext *ctx, GLenum opcode )
!   67		      !{

!
! SUBROUTINE gl_LogicOp
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_LogicOp
                       

			gl_LogicOp:
/* 000000	  67 */		save	%sp,-96,%sp

!   68		      !   if (INSIDE_BEGIN_END(ctx)) {

/* 0x0004	  68 */		sethi	%hi(0xe000),%l0
/* 0x0008	     */		add	%l0,252,%l7
/* 0x000c	     */		sethi	%hi(0x1800),%l6
/* 0x0010	     */		ld	[%i0+%l7],%l4
/* 0x0014	     */		add	%l6,512,%l5
/* 0x0018	     */		cmp	%l4,%l5
/* 0x001c	     */		be,pn	%icc,.L77002033
/* 0x0020	  69 */		sethi	%hi(.L18),%o1

! Registers live out of gl_LogicOp: 
! o1 sp l0 i0 i1 fp i7 gsr 
! 
		
!   69		      !      gl_error( ctx, GL_INVALID_OPERATION, "glLogicOp" );

                       
! predecessor blocks: gl_LogicOp

			.L77001995:
/* 0x0024	  69 */		add	%o1,%lo(.L18),%i2
/* 0x0028	     */		or	%g0,1282,%i1
/* 0x002c	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0030	     */		restore	%g0,0,%g0

!   70		      !      return;
!   71		      !   }
!   72		      !   switch (opcode) {

                       
! predecessor blocks: gl_LogicOp

			.L77002033:
/* 0x0034	  72 */		sethi	%hi(0x1400),%l3
/* 0x0038	     */		add	%l3,256,%l2
/* 0x003c	     */		sub	%i1,%l2,%l1
/* 0x0040	     */		cmp	%l1,15
/* 0x0044	     */		bgu,pn	%icc,.L77002031
/* 0x0048	     */		sethi	%hi(___const_seg_900000101),%g1

! Registers live out of .L77002033: 
! g1 sp l0 l1 i0 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002033

			.L900000113:
/* 0x004c	  72 */		add	%g1,%lo(___const_seg_900000101),%i3
/* 0x0050	     */		sll	%l1,2,%i4
/* 0x0054	     */		ld	[%i4+%i3],%i2
/* 0x0058	     */		jmpl	%i2+%i3,%g0
/* 0x005c	     */		nop

! Registers live out of .L900000113: 
! sp l0 i0 i1 fp i7 gsr 
! 
		
!   73		      !      case GL_CLEAR:
!   74		      !      case GL_SET:
!   75		      !      case GL_COPY:
!   76		      !      case GL_COPY_INVERTED:
!   77		      !      case GL_NOOP:
!   78		      !      case GL_INVERT:
!   79		      !      case GL_AND:
!   80		      !      case GL_NAND:
!   81		      !      case GL_OR:
!   82		      !      case GL_NOR:
!   83		      !      case GL_XOR:
!   84		      !      case GL_EQUIV:
!   85		      !      case GL_AND_REVERSE:
!   86		      !      case GL_AND_INVERTED:
!   87		      !      case GL_OR_REVERSE:
!   88		      !      case GL_OR_INVERTED:
!   89		      !         ctx->Color.LogicOp = opcode;
!   90		      !         ctx->NewState |= NEW_RASTER_OPS;

                       
! predecessor blocks: .L900000113

			.L77002029:
/* 0x0060	  90 */		add	%l0,244,%o2
/* 0x0064	     */		ld	[%i0+%o2],%o4
/* 0x0068	  89 */		sethi	%hi(0x1c00),%o7
/* 0x006c	     */		add	%o7,716,%o5
/* 0x0070	     */		st	%i1,[%i0+%o5]
/* 0x0074	  90 */		or	%o4,2,%o3
/* 0x0078	     */		st	%o3,[%i0+%o2]
/* 0x007c	  70 */		ret	! Result = 
/* 0x0080	     */		restore	%g0,0,%g0

!   91		      !	 return;
!   92		      !      default:
!   93		      !         gl_error( ctx, GL_INVALID_ENUM, "glLogicOp" );

                       
! predecessor blocks: .L77002033 .L900000113

			.L77002031:
/* 0x0084	  93 */		sethi	%hi(.L38),%i5
/* 0x0088	     */		add	%i5,%lo(.L38),%i2
/* 0x008c	     */		or	%g0,1280,%i1
/* 0x0090	     */		call	gl_error	! params =  %i0 %i1 %i2	! Result = 	! (tail call)
/* 0x0094	     */		restore	%g0,0,%g0
/* 0x0098	   0 */		.type	gl_LogicOp,2
/* 0x0098	   0 */		.size	gl_LogicOp,(.-gl_LogicOp)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000201:
/* 000000	   0 */		.word	(.L77002039-(___const_seg_900000201+0x0))
/* 0x0004	     */		.word	(.L77002111-(___const_seg_900000201+0x0))
/* 0x0008	     */		.word	(.L77002195-(___const_seg_900000201+0x0))
/* 0x000c	     */		.word	(.L77002256-(___const_seg_900000201+0x0))
/* 0x0010	     */		.word	(.L77002209-(___const_seg_900000201+0x0))
/* 0x0014	     */		.word	(.L77002083-(___const_seg_900000201+0x0))
/* 0x0018	     */		.word	(.L77002167-(___const_seg_900000201+0x0))
/* 0x001c	     */		.word	(.L77002139-(___const_seg_900000201+0x0))
/* 0x0020	     */		.word	(.L77002153-(___const_seg_900000201+0x0))
/* 0x0024	     */		.word	(.L77002181-(___const_seg_900000201+0x0))
/* 0x0028	     */		.word	(.L77002097-(___const_seg_900000201+0x0))
/* 0x002c	     */		.word	(.L77002223-(___const_seg_900000201+0x0))
/* 0x0030	     */		.word	(.L77002069-(___const_seg_900000201+0x0))
/* 0x0034	     */		.word	(.L77002237-(___const_seg_900000201+0x0))
/* 0x0038	     */		.word	(.L77002125-(___const_seg_900000201+0x0))
/* 0x003c	     */		.word	(.L77002053-(___const_seg_900000201+0x0))
/* 0x0040	   0 */		.type	___const_seg_900000201,1
/* 0x0040	   0 */		.size	___const_seg_900000201,(.-___const_seg_900000201)
/* 0x0040	   0 */		.align	4

!   94		      !	 return;
!   95		      !   }
!   96		      !}
!  101		      !/*
!  102		      ! * Apply the current logic operator to a span of CI pixels.  This is only
!  103		      ! * used if the device driver can't do logic ops.
!  104		      ! */
!  105		      !void gl_logicop_ci_span( GLcontext *ctx, GLuint n, GLint x, GLint y,
!  106		      !                         GLuint index[], GLubyte mask[] )
!  107		      !{

!
! SUBROUTINE gl_logicop_ci_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_logicop_ci_span
                       

			gl_logicop_ci_span:
/* 000000	 107 */		sethi	%hi(0x1800),%g1
/* 0x0004	     */		xor	%g1,-360,%g1
/* 0x0008	     */		save	%sp,%g1,%sp
/* 0x000c	   0 */		sethi	%hi(0x1800),%g1
/* 0x0010	   0 */		xor	%g1,-256,%g1
/* 0x0014	   0 */		add	%g1,%fp,%l3

!  108		      !   GLuint dest[MAX_WIDTH];
!  109		      !   GLuint i;
!  111		      !   /* Read dest values from frame buffer */
!  112		      !   (*ctx->Driver.ReadIndexSpan)( ctx, n, x, y, dest );

/* 0x0018	 112 */		sethi	%hi(0x1800),%g1
/* 0x001c	 107 */		or	%g0,%i3,%o3
/* 0x0020	 112 */		xor	%g1,-256,%g1
/* 0x0024	 107 */		or	%g0,%i2,%o2
/* 0x0028	 112 */		add	%g1,%fp,%o4
/* 0x002c	     */		or	%g0,%i1,%o1

!  114		      !   switch (ctx->Color.LogicOp) {

/* 0x0030	 114 */		sethi	%hi(0x1c00),%l5
/* 0x0034	     */		add	%l5,716,%l2
/* 0x0038	     */		sethi	%hi(0x1400),%l4
/* 0x003c	     */		add	%l4,256,%l0
/* 0x0040	 112 */		ld	[%i0+2276],%i3
/* 0x0044	     */		jmpl	%i3,%o7
/* 0x0048	     */		or	%g0,%i0,%o0
/* 0x004c	 114 */		ld	[%i0+%l2],%o4
/* 0x0050	     */		sub	%o4,%l0,%l6
/* 0x0054	     */		cmp	%l6,15
/* 0x0058	     */		bgu,pn	%icc,.L77002251
/* 0x005c	     */		sll	%l6,2,%i2

! Registers live out of gl_logicop_ci_span: 
! g1 o2 sp i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_logicop_ci_span

			.L900000227:
/* 0x0060	 114 */		sethi	%hi(___const_seg_900000201),%l1
/* 0x0064	     */		add	%l1,%lo(___const_seg_900000201),%o5
/* 0x0068	     */		sethi	%hi(0x7ffffc00),%o7
/* 0x006c	     */		ld	[%i2+%o5],%l7
/* 0x0070	     */		jmpl	%l7+%o5,%g0
/* 0x0074	     */		nop

! Registers live out of .L900000227: 
! g1 o2 sp o7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  115		      !      case GL_CLEAR:
!  116		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002039:
/* 0x0078	 116 */		cmp	%i1,0
/* 0x007c	     */		bleu,pn	%icc,.L77002256
/* 0x0080	     */		cmp	%i1,4

! Registers live out of .L77002039: 
! sp o7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002039

			.L77002286:
/* 0x0084	 116 */		bl,pn	%icc,.L77002637
/* 0x0088	     */		add	%o7,1022,%o7

! Registers live out of .L77002286: 
! sp o7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002286

			.L77002430:
/* 0x008c	 116 */		sub	%i4,%i5,%l5
/* 0x0090	     */		sll	%i1,2,%o3
/* 0x0094	     */		sub	%i5,%i4,%o2
/* 0x0098	     */		sra	%l5,0,%g5
/* 0x009c	     */		sra	%o3,0,%o1
/* 0x00a0	     */		sra	%o2,0,%o0
/* 0x00a4	     */		sra	%i1,0,%g2
/* 0x00a8	     */		sub	%o0,%o1,%g3
/* 0x00ac	     */		sub	%g5,%g2,%g4
/* 0x00b0	     */		srl	%i1,0,%o5
/* 0x00b4	     */		srlx	%g3,63,%i0
/* 0x00b8	     */		srlx	%g4,63,%i3
/* 0x00bc	     */		sub	%o5,%o7,%o4
/* 0x00c0	     */		xor	%i0,1,%l4
/* 0x00c4	     */		xor	%i3,1,%l2
/* 0x00c8	     */		srlx	%o4,63,%l1
/* 0x00cc	     */		or	%l2,%l4,%l0
/* 0x00d0	     */		and	%l1,1,%l7
/* 0x00d4	     */		andcc	%l7,%l0,%g0
/* 0x00d8	     */		be,a,pn	%icc,.L77002424
/* 0x00dc	     */		or	%g0,0,%i2

! Registers live out of .L77002430: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002430

			.L77002513:
/* 0x00e0	 116 */		add	%i1,-1,%o2

!  117		      !	    if (mask[i]) {

/* 0x00e4	 117 */		ldub	[%i5],%o3
/* 0x00e8	 116 */		or	%g0,0,%i0

! Registers live out of .L77002513: 
! o2 o3 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002047 .L77002513

			.L900000257:
/* 0x00ec	 117 */		cmp	%o3,0
/* 0x00f0	     */		be,pn	%icc,.L77002047
/* 0x00f4	 116 */		add	%i0,1,%i0

! Registers live out of .L900000257: 
! o2 o3 sp i0 i4 i5 fp i7 gsr 
! 
		
!  118		      !	       index[i] = 0;

                       
! predecessor blocks: .L900000257

			.L77002045:
/* 0x00f8	 118 */		st	%g0,[%i4]

! Registers live out of .L77002045: 
! o2 o3 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002045 .L900000257

			.L77002047:
/* 0x00fc	 116 */		cmp	%i0,%o2
/* 0x0100	     */		add	%i5,1,%i5
/* 0x0104	     */		add	%i4,4,%i4
/* 0x0108	     */		ble,a,pt	%icc,.L900000257
/* 0x010c	 117 */		ldub	[%i5],%o3

! Registers live out of .L77002047: 
! o2 o3 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002047

			.L77002427:
/* 0x0110	 116 */		ba	.L77002256
/* 0x0114	     */		nop

! Registers live out of .L77002427: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002286

			.L77002637:
/* 0x0118	 116 */		or	%g0,0,%i2

! Registers live out of .L77002637: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002430 .L77002637

			.L77002424:
/* 0x011c	 117 */		ldub	[%i2+%i5],%l3

! Registers live out of .L77002424: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002424 .L77002426

			.L900000256:
/* 0x0120	 117 */		cmp	%l3,0
/* 0x0124	     */		be,pn	%icc,.L77002426
/* 0x0128	 118 */		sll	%i2,2,%l6

! Registers live out of .L900000256: 
! sp l6 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000256

			.L77002425:
/* 0x012c	 118 */		st	%g0,[%l6+%i4]

! Registers live out of .L77002425: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002425 .L900000256

			.L77002426:
/* 0x0130	 116 */		add	%i2,1,%i2
/* 0x0134	     */		cmp	%i2,%i1
/* 0x0138	     */		bcs,a,pt	%icc,.L900000256
/* 0x013c	 117 */		ldub	[%i2+%i5],%l3

! Registers live out of .L77002426: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002426

			.L900000225:
/* 0x0140	 116 */		ba	.L77002256
/* 0x0144	     */		nop

! Registers live out of .L900000225: 
! sp fp i7 gsr 
! 
		
!  119		      !	    }
!  120		      !	 }
!  121		      !	 break;
!  122		      !      case GL_SET:
!  123		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002053:
/* 0x0148	 123 */		cmp	%i1,0
/* 0x014c	     */		bleu,pn	%icc,.L77002256
/* 0x0150	     */		cmp	%i1,4

! Registers live out of .L77002053: 
! sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002053

			.L77002287:
/* 0x0154	 123 */		bl,pn	%icc,.L77002665
/* 0x0158	     */		add	%o7,1022,%g3

! Registers live out of .L77002287: 
! g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002287

			.L77002440:
/* 0x015c	 123 */		sub	%i4,%i5,%l3
/* 0x0160	     */		sll	%i1,2,%l5
/* 0x0164	     */		sub	%i5,%i4,%o3
/* 0x0168	     */		sra	%l3,0,%g5
/* 0x016c	     */		sra	%l5,0,%o2
/* 0x0170	     */		sra	%o3,0,%o1
/* 0x0174	     */		sra	%i1,0,%g2
/* 0x0178	     */		sub	%o1,%o2,%o0
/* 0x017c	     */		sub	%g5,%g2,%o7
/* 0x0180	     */		srl	%i1,0,%g4
/* 0x0184	     */		srlx	%o0,63,%i0
/* 0x0188	     */		srlx	%o7,63,%i3
/* 0x018c	     */		sub	%g4,%g3,%o5
/* 0x0190	     */		xor	%i0,1,%l4
/* 0x0194	     */		xor	%i3,1,%l2
/* 0x0198	     */		srlx	%o5,63,%l1
/* 0x019c	     */		or	%l2,%l4,%l0
/* 0x01a0	     */		and	%l1,1,%l7
/* 0x01a4	     */		andcc	%l7,%l0,%g0
/* 0x01a8	     */		be,a,pn	%icc,.L77002603
/* 0x01ac	     */		or	%g0,0,%l3

! Registers live out of .L77002440: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002440

			.L77002499:
/* 0x01b0	 123 */		add	%i1,-1,%i1
/* 0x01b4	     */		or	%g0,0,%l3

!  124		      !	    if (mask[i]) {

/* 0x01b8	 124 */		ldub	[%i5],%l4
/* 0x01bc	 123 */		or	%g0,1,%g4

! Registers live out of .L77002499: 
! g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002061 .L77002499

			.L900000255:
/* 0x01c0	 124 */		cmp	%l4,0
/* 0x01c4	     */		be,pn	%icc,.L77002061
/* 0x01c8	 123 */		add	%l3,1,%l3

! Registers live out of .L900000255: 
! g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		
!  125		      !	       index[i] = 1;

                       
! predecessor blocks: .L900000255

			.L77002059:
/* 0x01cc	 125 */		st	%g4,[%i4]

! Registers live out of .L77002059: 
! g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002059 .L900000255

			.L77002061:
/* 0x01d0	 123 */		cmp	%l3,%i1
/* 0x01d4	     */		add	%i5,1,%i5
/* 0x01d8	     */		add	%i4,4,%i4
/* 0x01dc	     */		ble,a,pt	%icc,.L900000255
/* 0x01e0	 124 */		ldub	[%i5],%l4

! Registers live out of .L77002061: 
! g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002061

			.L77002437:
/* 0x01e4	 123 */		ba	.L77002256
/* 0x01e8	     */		nop

! Registers live out of .L77002437: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002287

			.L77002665:
/* 0x01ec	 123 */		or	%g0,0,%l3

! Registers live out of .L77002665: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002440 .L77002665

			.L77002603:
/* 0x01f0	 123 */		or	%g0,1,%i2
/* 0x01f4	 124 */		ldub	[%l3+%i5],%o4

! Registers live out of .L77002603: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002436 .L77002603

			.L900000254:
/* 0x01f8	 124 */		cmp	%o4,0
/* 0x01fc	     */		be,pn	%icc,.L77002436
/* 0x0200	 125 */		sll	%l3,2,%l6

! Registers live out of .L900000254: 
! o4 sp l6 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000254

			.L77002435:
/* 0x0204	 125 */		st	%i2,[%l6+%i4]

! Registers live out of .L77002435: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002435 .L900000254

			.L77002436:
/* 0x0208	 123 */		add	%l3,1,%l3
/* 0x020c	     */		cmp	%l3,%i1
/* 0x0210	     */		bcs,a,pt	%icc,.L900000254
/* 0x0214	 124 */		ldub	[%l3+%i5],%o4

! Registers live out of .L77002436: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002436

			.L900000224:
/* 0x0218	 123 */		ba	.L77002256
/* 0x021c	     */		nop

! Registers live out of .L900000224: 
! sp fp i7 gsr 
! 
		
!  126		      !	    }
!  127		      !	 }
!  128		      !	 break;
!  129		      !      case GL_COPY:
!  130		      !	 /* do nothing */
!  131		      !	 break;
!  132		      !      case GL_COPY_INVERTED:
!  133		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002069:
/* 0x0220	 133 */		cmp	%i1,0
/* 0x0224	     */		bleu,pn	%icc,.L77002256
/* 0x0228	     */		cmp	%i1,4

! Registers live out of .L77002069: 
! sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002069

			.L77002275:
/* 0x022c	 133 */		bl,pn	%icc,.L77002659
/* 0x0230	     */		add	%o7,1022,%o5

! Registers live out of .L77002275: 
! o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002275

			.L77002320:
/* 0x0234	 133 */		sll	%i1,2,%o2
/* 0x0238	     */		sub	%i4,%i5,%l3
/* 0x023c	     */		sub	%i5,%i4,%l0
/* 0x0240	     */		sra	%o2,0,%o1
/* 0x0244	     */		sra	%l3,0,%g5
/* 0x0248	     */		sra	%l0,0,%o0
/* 0x024c	     */		sra	%i1,0,%g2
/* 0x0250	     */		sub	%o0,%o1,%o7
/* 0x0254	     */		sub	%g5,%g2,%g3
/* 0x0258	     */		srl	%i1,0,%o4
/* 0x025c	     */		srlx	%o7,63,%i2
/* 0x0260	     */		srlx	%g3,63,%i3
/* 0x0264	     */		sub	%o4,%o5,%g4
/* 0x0268	     */		xor	%i2,1,%l4
/* 0x026c	     */		xor	%i3,1,%i0
/* 0x0270	     */		srlx	%g4,63,%l2
/* 0x0274	     */		or	%i0,%l4,%l1
/* 0x0278	     */		and	%l2,1,%l7
/* 0x027c	     */		andcc	%l7,%l1,%g0
/* 0x0280	     */		be,a,pn	%icc,.L77002314
/* 0x0284	     */		or	%g0,0,%o2

! Registers live out of .L77002320: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002320

			.L77002502:
/* 0x0288	 133 */		add	%i1,-1,%i2

!  134		      !	    if (mask[i]) {

/* 0x028c	 134 */		ldub	[%i5],%o4
/* 0x0290	 133 */		or	%g0,0,%i3

! Registers live out of .L77002502: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002077 .L77002502

			.L900000253:
/* 0x0294	 134 */		cmp	%o4,0
/* 0x0298	     */		be,pn	%icc,.L77002077
/* 0x029c	 133 */		add	%i3,1,%i3

! Registers live out of .L900000253: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		
!  135		      !	       index[i] = ~index[i];

                       
! predecessor blocks: .L900000253

			.L77002075:
/* 0x02a0	 135 */		ld	[%i4],%g3
/* 0x02a4	     */		xnor	%g3,0,%g2
/* 0x02a8	     */		st	%g2,[%i4]

! Registers live out of .L77002075: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002075 .L900000253

			.L77002077:
/* 0x02ac	 133 */		cmp	%i3,%i2
/* 0x02b0	     */		add	%i5,1,%i5
/* 0x02b4	     */		add	%i4,4,%i4
/* 0x02b8	     */		ble,a,pt	%icc,.L900000253
/* 0x02bc	 134 */		ldub	[%i5],%o4

! Registers live out of .L77002077: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002077

			.L77002317:
/* 0x02c0	 133 */		ba	.L77002256
/* 0x02c4	     */		nop

! Registers live out of .L77002317: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002275

			.L77002659:
/* 0x02c8	 133 */		or	%g0,0,%o2

! Registers live out of .L77002659: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002320 .L77002659

			.L77002314:
/* 0x02cc	 134 */		ldub	[%o2+%i5],%l3

! Registers live out of .L77002314: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002314 .L77002316

			.L900000252:
/* 0x02d0	 134 */		cmp	%l3,0
/* 0x02d4	     */		be,pn	%icc,.L77002316
/* 0x02d8	 135 */		sll	%o2,2,%o3

! Registers live out of .L900000252: 
! o2 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000252

			.L77002315:
/* 0x02dc	 135 */		ld	[%i4+%o3],%l6
/* 0x02e0	     */		xnor	%l6,0,%l5
/* 0x02e4	     */		st	%l5,[%i4+%o3]

! Registers live out of .L77002315: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002315 .L900000252

			.L77002316:
/* 0x02e8	 133 */		add	%o2,1,%o2
/* 0x02ec	     */		cmp	%o2,%i1
/* 0x02f0	     */		bcs,a,pt	%icc,.L900000252
/* 0x02f4	 134 */		ldub	[%o2+%i5],%l3

! Registers live out of .L77002316: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002316

			.L900000223:
/* 0x02f8	 133 */		ba	.L77002256
/* 0x02fc	     */		nop

! Registers live out of .L900000223: 
! sp fp i7 gsr 
! 
		
!  136		      !	    }
!  137		      !	 }
!  138		      !	 break;
!  139		      !      case GL_NOOP:
!  140		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002083:
/* 0x0300	 140 */		cmp	%i1,0
/* 0x0304	     */		bleu,pn	%icc,.L77002256
/* 0x0308	     */		cmp	%i1,6

! Registers live out of .L77002083: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002083

			.L77002282:
/* 0x030c	 140 */		bl,pn	%icc,.L77002645
/* 0x0310	     */		add	%o7,1022,%o3

! Registers live out of .L77002282: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002282

			.L77002390:
/* 0x0314	 140 */		sub	%i4,%l3,%g4
/* 0x0318	     */		sra	%g4,31,%o5
/* 0x031c	     */		xor	%g4,%o5,%l2
/* 0x0320	     */		sll	%i1,2,%g2
/* 0x0324	     */		sub	%i5,%i4,%g5
/* 0x0328	     */		sub	%i4,%i5,%l7
/* 0x032c	     */		sra	%g2,0,%o1
/* 0x0330	     */		sub	%l2,%o5,%l6
/* 0x0334	     */		sra	%g5,0,%o4
/* 0x0338	     */		sra	%l7,0,%g3
/* 0x033c	     */		sra	%i1,0,%g4
/* 0x0340	     */		sub	%o4,%o1,%o2
/* 0x0344	     */		sub	%g3,%g4,%o5
/* 0x0348	     */		srl	%i1,0,%g2
/* 0x034c	     */		sub	%g2,%o3,%g5
/* 0x0350	     */		srlx	%o2,63,%l1
/* 0x0354	     */		sra	%l6,0,%o0
/* 0x0358	     */		srlx	%o5,63,%l5
/* 0x035c	     */		sub	%o0,%o1,%o7
/* 0x0360	     */		xor	%l1,1,%i3
/* 0x0364	     */		xor	%l5,1,%i0
/* 0x0368	     */		srlx	%g5,63,%l4
/* 0x036c	     */		srlx	%o7,63,%i2
/* 0x0370	     */		or	%i0,%i3,%l2
/* 0x0374	     */		and	%l4,1,%o4
/* 0x0378	     */		xor	%i2,1,%l0
/* 0x037c	     */		and	%o4,%l2,%o3
/* 0x0380	     */		andcc	%o3,%l0,%g0
/* 0x0384	     */		be,a,pn	%icc,.L77002384
/* 0x0388	     */		or	%g0,0,%o1

! Registers live out of .L77002390: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002390

			.L77002509:
/* 0x038c	 140 */		sethi	%hi(0x1800),%g1
/* 0x0390	     */		xor	%g1,-256,%g1
/* 0x0394	     */		add	%i1,-1,%g5
/* 0x0398	     */		or	%g0,0,%l5

!  141		      !	    if (mask[i]) {

/* 0x039c	 141 */		ldub	[%i5],%o5
/* 0x03a0	 140 */		add	%g1,%fp,%l6

! Registers live out of .L77002509: 
! g5 o5 sp l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002091 .L77002509

			.L900000251:
/* 0x03a4	 141 */		cmp	%o5,0
/* 0x03a8	     */		be,pn	%icc,.L77002091
/* 0x03ac	 140 */		add	%l5,1,%l5

! Registers live out of .L900000251: 
! g5 o5 sp l5 l6 i4 i5 fp i7 gsr 
! 
		
!  142		      !	       index[i] = dest[i];

                       
! predecessor blocks: .L900000251

			.L77002089:
/* 0x03b0	 142 */		ld	[%l6],%o7
/* 0x03b4	     */		st	%o7,[%i4]

! Registers live out of .L77002089: 
! g5 o5 sp l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002089 .L900000251

			.L77002091:
/* 0x03b8	 140 */		cmp	%l5,%g5
/* 0x03bc	     */		add	%i5,1,%i5
/* 0x03c0	     */		add	%l6,4,%l6
/* 0x03c4	     */		add	%i4,4,%i4
/* 0x03c8	     */		ble,a,pt	%icc,.L900000251
/* 0x03cc	 141 */		ldub	[%i5],%o5

! Registers live out of .L77002091: 
! g5 o5 sp l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002091

			.L77002387:
/* 0x03d0	 140 */		ba	.L77002256
/* 0x03d4	     */		nop

! Registers live out of .L77002387: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002282

			.L77002645:
/* 0x03d8	 140 */		or	%g0,0,%o1

! Registers live out of .L77002645: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002390 .L77002645

			.L77002384:
/* 0x03dc	 141 */		ldub	[%o1+%i5],%l7

! Registers live out of .L77002384: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002384 .L77002386

			.L900000250:
/* 0x03e0	 141 */		cmp	%l7,0
/* 0x03e4	     */		be,pn	%icc,.L77002386
/* 0x03e8	 142 */		sll	%o1,2,%o2

! Registers live out of .L900000250: 
! g1 o1 o2 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000250

			.L77002385:
/* 0x03ec	 142 */		ld	[%o2+%l3],%l1
/* 0x03f0	     */		st	%l1,[%o2+%i4]

! Registers live out of .L77002385: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002385 .L900000250

			.L77002386:
/* 0x03f4	 140 */		add	%o1,1,%o1
/* 0x03f8	     */		cmp	%o1,%i1
/* 0x03fc	     */		bcs,a,pt	%icc,.L900000250
/* 0x0400	 141 */		ldub	[%o1+%i5],%l7

! Registers live out of .L77002386: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002386

			.L900000222:
/* 0x0404	 140 */		ba	.L77002256
/* 0x0408	     */		nop

! Registers live out of .L900000222: 
! sp fp i7 gsr 
! 
		
!  143		      !	    }
!  144		      !	 }
!  145		      !	 break;
!  146		      !      case GL_INVERT:
!  147		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002097:
/* 0x040c	 147 */		cmp	%i1,0
/* 0x0410	     */		bleu,pn	%icc,.L77002256
/* 0x0414	     */		cmp	%i1,6

! Registers live out of .L77002097: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002097

			.L77002277:
/* 0x0418	 147 */		bl,pn	%icc,.L77002655
/* 0x041c	     */		add	%o7,1022,%o2

! Registers live out of .L77002277: 
! g1 o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002277

			.L77002340:
/* 0x0420	 147 */		sub	%i4,%l3,%l6
/* 0x0424	     */		sra	%l6,31,%g2
/* 0x0428	     */		xor	%l6,%g2,%g4
/* 0x042c	     */		sll	%i1,2,%o4
/* 0x0430	     */		sub	%i5,%i4,%l5
/* 0x0434	     */		sub	%i4,%i5,%i2
/* 0x0438	     */		sub	%g4,%g2,%l4
/* 0x043c	     */		sra	%o4,0,%o1
/* 0x0440	     */		sra	%l5,0,%o3
/* 0x0444	     */		sra	%i2,0,%o5
/* 0x0448	     */		sra	%i1,0,%g3
/* 0x044c	     */		sub	%o3,%o1,%g5
/* 0x0450	     */		sub	%o5,%g3,%g4
/* 0x0454	     */		srl	%i1,0,%g2
/* 0x0458	     */		sra	%l4,0,%o0
/* 0x045c	     */		sub	%g2,%o2,%o4
/* 0x0460	     */		srlx	%g5,63,%i0
/* 0x0464	     */		srlx	%g4,63,%l1
/* 0x0468	     */		xor	%i0,1,%l7
/* 0x046c	     */		sub	%o0,%o1,%o7
/* 0x0470	     */		xor	%l1,1,%i3
/* 0x0474	     */		srlx	%o4,63,%l6
/* 0x0478	     */		srlx	%o7,63,%l2
/* 0x047c	     */		or	%i3,%l7,%l5
/* 0x0480	     */		and	%l6,1,%o3
/* 0x0484	     */		xor	%l2,1,%l0
/* 0x0488	     */		and	%o3,%l5,%o2
/* 0x048c	     */		andcc	%o2,%l0,%g0
/* 0x0490	     */		be,a,pn	%icc,.L77002334
/* 0x0494	     */		or	%g0,0,%l4

! Registers live out of .L77002340: 
! g1 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002340

			.L77002504:
/* 0x0498	 147 */		sethi	%hi(0x1800),%g1
/* 0x049c	     */		xor	%g1,-256,%g1
/* 0x04a0	     */		add	%i1,-1,%l7
/* 0x04a4	     */		or	%g0,0,%l1

!  148		      !	    if (mask[i]) {

/* 0x04a8	 148 */		ldub	[%i5],%o0
/* 0x04ac	 147 */		add	%g1,%fp,%l2

! Registers live out of .L77002504: 
! o0 sp l1 l2 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002105 .L77002504

			.L900000249:
/* 0x04b0	 148 */		cmp	%o0,0
/* 0x04b4	     */		be,pn	%icc,.L77002105
/* 0x04b8	 147 */		add	%l1,1,%l1

! Registers live out of .L900000249: 
! o0 sp l1 l2 l7 i4 i5 fp i7 gsr 
! 
		
!  149		      !	       index[i] = ~dest[i];

                       
! predecessor blocks: .L900000249

			.L77002103:
/* 0x04bc	 149 */		ld	[%l2],%l0
/* 0x04c0	     */		xnor	%l0,0,%o1
/* 0x04c4	     */		st	%o1,[%i4]

! Registers live out of .L77002103: 
! o0 sp l1 l2 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002103 .L900000249

			.L77002105:
/* 0x04c8	 147 */		cmp	%l1,%l7
/* 0x04cc	     */		add	%i5,1,%i5
/* 0x04d0	     */		add	%l2,4,%l2
/* 0x04d4	     */		add	%i4,4,%i4
/* 0x04d8	     */		ble,a,pt	%icc,.L900000249
/* 0x04dc	 148 */		ldub	[%i5],%o0

! Registers live out of .L77002105: 
! o0 sp l1 l2 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002105

			.L77002337:
/* 0x04e0	 147 */		ba	.L77002256
/* 0x04e4	     */		nop

! Registers live out of .L77002337: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002277

			.L77002655:
/* 0x04e8	 147 */		or	%g0,0,%l4

! Registers live out of .L77002655: 
! g1 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002340 .L77002655

			.L77002334:
/* 0x04ec	 148 */		ldub	[%l4+%i5],%o1

! Registers live out of .L77002334: 
! g1 o1 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002334 .L77002336

			.L900000248:
/* 0x04f0	 148 */		cmp	%o1,0
/* 0x04f4	     */		be,pn	%icc,.L77002336
/* 0x04f8	 149 */		sll	%l4,2,%i2

! Registers live out of .L900000248: 
! g1 o1 sp l4 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000248

			.L77002335:
/* 0x04fc	 149 */		ld	[%i2+%l3],%g5
/* 0x0500	     */		xnor	%g5,0,%i0
/* 0x0504	     */		st	%i0,[%i2+%i4]

! Registers live out of .L77002335: 
! g1 o1 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002335 .L900000248

			.L77002336:
/* 0x0508	 147 */		add	%l4,1,%l4
/* 0x050c	     */		cmp	%l4,%i1
/* 0x0510	     */		bcs,a,pt	%icc,.L900000248
/* 0x0514	 148 */		ldub	[%l4+%i5],%o1

! Registers live out of .L77002336: 
! g1 o1 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002336

			.L900000221:
/* 0x0518	 147 */		ba	.L77002256
/* 0x051c	     */		nop

! Registers live out of .L900000221: 
! sp fp i7 gsr 
! 
		
!  150		      !	    }
!  151		      !	 }
!  152		      !	 break;
!  153		      !      case GL_AND:
!  154		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002111:
/* 0x0520	 154 */		cmp	%i1,0
/* 0x0524	     */		bleu,pn	%icc,.L77002256
/* 0x0528	     */		cmp	%i1,6

! Registers live out of .L77002111: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002111

			.L77002285:
/* 0x052c	 154 */		bl,pn	%icc,.L77002639
/* 0x0530	     */		add	%o7,1022,%g3

! Registers live out of .L77002285: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002285

			.L77002420:
/* 0x0534	 154 */		sub	%i4,%l3,%l5
/* 0x0538	     */		sra	%l5,31,%o2
/* 0x053c	     */		xor	%l5,%o2,%o3
/* 0x0540	     */		sub	%o3,%o2,%l4
/* 0x0544	     */		sll	%i1,2,%o1
/* 0x0548	     */		sub	%i5,%i4,%o0
/* 0x054c	     */		sub	%i4,%i5,%g2
/* 0x0550	     */		sra	%o1,0,%g4
/* 0x0554	     */		sra	%o0,0,%o7
/* 0x0558	     */		sra	%g2,0,%o3
/* 0x055c	     */		sra	%i1,0,%o2
/* 0x0560	     */		sub	%o7,%g4,%g5
/* 0x0564	     */		sub	%o3,%o2,%o1
/* 0x0568	     */		srl	%i1,0,%o0
/* 0x056c	     */		sra	%l4,0,%o5
/* 0x0570	     */		sub	%o0,%g3,%o7
/* 0x0574	     */		srlx	%g5,63,%i0
/* 0x0578	     */		srlx	%o1,63,%l1
/* 0x057c	     */		sub	%o5,%g4,%o4
/* 0x0580	     */		xor	%i0,1,%i3
/* 0x0584	     */		xor	%l1,1,%l7
/* 0x0588	     */		srlx	%o7,63,%l6
/* 0x058c	     */		srlx	%o4,63,%l2
/* 0x0590	     */		or	%l7,%i3,%i2
/* 0x0594	     */		and	%l6,1,%l5
/* 0x0598	     */		xor	%l2,1,%l0
/* 0x059c	     */		and	%l5,%i2,%g3
/* 0x05a0	     */		andcc	%g3,%l0,%g0
/* 0x05a4	     */		be,a,pn	%icc,.L77002414
/* 0x05a8	     */		or	%g0,0,%o5

! Registers live out of .L77002420: 
! g1 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002420

			.L77002512:
/* 0x05ac	 154 */		sethi	%hi(0x1800),%g1
/* 0x05b0	     */		add	%i1,-1,%o2
/* 0x05b4	     */		xor	%g1,-256,%g1
/* 0x05b8	     */		or	%g0,0,%i0

!  155		      !	    if (mask[i]) {

/* 0x05bc	 155 */		ldub	[%i5],%i1
/* 0x05c0	 154 */		add	%g1,%fp,%o3

! Registers live out of .L77002512: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002119 .L77002512

			.L900000247:
/* 0x05c4	 155 */		cmp	%i1,0
/* 0x05c8	     */		be,pn	%icc,.L77002119
/* 0x05cc	 154 */		add	%i0,1,%i0

! Registers live out of .L900000247: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		
!  156		      !	       index[i] &= dest[i];

                       
! predecessor blocks: .L900000247

			.L77002117:
/* 0x05d0	 156 */		ld	[%i4],%g4
/* 0x05d4	     */		ld	[%o3],%l4
/* 0x05d8	     */		and	%g4,%l4,%l3
/* 0x05dc	     */		st	%l3,[%i4]

! Registers live out of .L77002117: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002117 .L900000247

			.L77002119:
/* 0x05e0	 154 */		cmp	%i0,%o2
/* 0x05e4	     */		add	%i5,1,%i5
/* 0x05e8	     */		add	%o3,4,%o3
/* 0x05ec	     */		add	%i4,4,%i4
/* 0x05f0	     */		ble,a,pt	%icc,.L900000247
/* 0x05f4	 155 */		ldub	[%i5],%i1

! Registers live out of .L77002119: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002119

			.L77002417:
/* 0x05f8	 154 */		ba	.L77002256
/* 0x05fc	     */		nop

! Registers live out of .L77002417: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002285

			.L77002639:
/* 0x0600	 154 */		or	%g0,0,%o5

! Registers live out of .L77002639: 
! g1 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002420 .L77002639

			.L77002414:
/* 0x0604	 155 */		ldub	[%o5+%i5],%l4

! Registers live out of .L77002414: 
! g1 o5 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002414 .L77002416

			.L900000246:
/* 0x0608	 155 */		cmp	%l4,0
/* 0x060c	     */		be,pn	%icc,.L77002416
/* 0x0610	 156 */		sll	%o5,2,%g4

! Registers live out of .L900000246: 
! g1 g4 o5 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000246

			.L77002415:
/* 0x0614	 156 */		ld	[%i4+%g4],%i0
/* 0x0618	     */		ld	[%g4+%l3],%g5
/* 0x061c	     */		and	%i0,%g5,%g2
/* 0x0620	     */		st	%g2,[%i4+%g4]

! Registers live out of .L77002415: 
! g1 o5 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002415 .L900000246

			.L77002416:
/* 0x0624	 154 */		add	%o5,1,%o5
/* 0x0628	     */		cmp	%o5,%i1
/* 0x062c	     */		bcs,a,pt	%icc,.L900000246
/* 0x0630	 155 */		ldub	[%o5+%i5],%l4

! Registers live out of .L77002416: 
! g1 o5 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002416

			.L900000220:
/* 0x0634	 154 */		ba	.L77002256
/* 0x0638	     */		nop

! Registers live out of .L900000220: 
! sp fp i7 gsr 
! 
		
!  157		      !	    }
!  158		      !	 }
!  159		      !	 break;
!  160		      !      case GL_NAND:
!  161		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002125:
/* 0x063c	 161 */		cmp	%i1,0
/* 0x0640	     */		bleu,pn	%icc,.L77002256
/* 0x0644	     */		cmp	%i1,6

! Registers live out of .L77002125: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002125

			.L77002288:
/* 0x0648	 161 */		bl,pn	%icc,.L77002663
/* 0x064c	     */		add	%o7,1022,%g3

! Registers live out of .L77002288: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002288

			.L77002450:
/* 0x0650	 161 */		sub	%i4,%l3,%o3
/* 0x0654	     */		sra	%o3,31,%o1
/* 0x0658	     */		xor	%o3,%o1,%o2
/* 0x065c	     */		sub	%o2,%o1,%l6
/* 0x0660	     */		sll	%i1,2,%o0
/* 0x0664	     */		sub	%i5,%i4,%g5
/* 0x0668	     */		sub	%i4,%i5,%i2
/* 0x066c	     */		sra	%o0,0,%g4
/* 0x0670	     */		sra	%g5,0,%g2
/* 0x0674	     */		sra	%i2,0,%o3
/* 0x0678	     */		sra	%i1,0,%o2
/* 0x067c	     */		sub	%g2,%g4,%o7
/* 0x0680	     */		sub	%o3,%o2,%o1
/* 0x0684	     */		srl	%i1,0,%o0
/* 0x0688	     */		sub	%o0,%g3,%g5
/* 0x068c	     */		srlx	%o7,63,%l7
/* 0x0690	     */		sra	%l6,0,%o5
/* 0x0694	     */		srlx	%o1,63,%i0
/* 0x0698	     */		sub	%o5,%g4,%o4
/* 0x069c	     */		xor	%l7,1,%i3
/* 0x06a0	     */		xor	%i0,1,%l4
/* 0x06a4	     */		srlx	%g5,63,%l2
/* 0x06a8	     */		srlx	%o4,63,%l5
/* 0x06ac	     */		or	%l4,%i3,%l1
/* 0x06b0	     */		and	%l2,1,%g2
/* 0x06b4	     */		xor	%l5,1,%l0
/* 0x06b8	     */		and	%g2,%l1,%g3
/* 0x06bc	     */		andcc	%g3,%l0,%g0
/* 0x06c0	     */		be,a,pn	%icc,.L77002444
/* 0x06c4	     */		or	%g0,0,%o4

! Registers live out of .L77002450: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002450

			.L77002500:
/* 0x06c8	 161 */		sethi	%hi(0x1800),%g1
/* 0x06cc	     */		xor	%g1,-256,%g1
/* 0x06d0	     */		add	%i1,-1,%i3
/* 0x06d4	     */		or	%g0,0,%i2

!  162		      !	    if (mask[i]) {

/* 0x06d8	 162 */		ldub	[%i5],%g2
/* 0x06dc	 161 */		add	%g1,%fp,%o4

! Registers live out of .L77002500: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002133 .L77002500

			.L900000245:
/* 0x06e0	 162 */		cmp	%g2,0
/* 0x06e4	     */		be,pn	%icc,.L77002133
/* 0x06e8	 161 */		add	%i2,1,%i2

! Registers live out of .L900000245: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		
!  163		      !	       index[i] = ~(index[i] & dest[i]);

                       
! predecessor blocks: .L900000245

			.L77002131:
/* 0x06ec	 163 */		ld	[%i4],%l5
/* 0x06f0	     */		ld	[%o4],%l6
/* 0x06f4	     */		and	%l5,%l6,%g5
/* 0x06f8	     */		xnor	%g5,0,%g3
/* 0x06fc	     */		st	%g3,[%i4]

! Registers live out of .L77002131: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002131 .L900000245

			.L77002133:
/* 0x0700	 161 */		cmp	%i2,%i3
/* 0x0704	     */		add	%i5,1,%i5
/* 0x0708	     */		add	%o4,4,%o4
/* 0x070c	     */		add	%i4,4,%i4
/* 0x0710	     */		ble,a,pt	%icc,.L900000245
/* 0x0714	 162 */		ldub	[%i5],%g2

! Registers live out of .L77002133: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002133

			.L77002447:
/* 0x0718	 161 */		ba	.L77002256
/* 0x071c	     */		nop

! Registers live out of .L77002447: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002288

			.L77002663:
/* 0x0720	 161 */		or	%g0,0,%o4

! Registers live out of .L77002663: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002450 .L77002663

			.L77002444:
/* 0x0724	 162 */		ldub	[%o4+%i5],%o5

! Registers live out of .L77002444: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002444 .L77002446

			.L900000244:
/* 0x0728	 162 */		cmp	%o5,0
/* 0x072c	     */		be,pn	%icc,.L77002446
/* 0x0730	 163 */		sll	%o4,2,%l6

! Registers live out of .L900000244: 
! g1 o4 o5 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000244

			.L77002445:
/* 0x0734	 163 */		ld	[%i4+%l6],%l7
/* 0x0738	     */		ld	[%l6+%l3],%o7
/* 0x073c	     */		and	%l7,%o7,%i2
/* 0x0740	     */		xnor	%i2,0,%g4
/* 0x0744	     */		st	%g4,[%i4+%l6]

! Registers live out of .L77002445: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002445 .L900000244

			.L77002446:
/* 0x0748	 161 */		add	%o4,1,%o4
/* 0x074c	     */		cmp	%o4,%i1
/* 0x0750	     */		bcs,a,pt	%icc,.L900000244
/* 0x0754	 162 */		ldub	[%o4+%i5],%o5

! Registers live out of .L77002446: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002446

			.L900000219:
/* 0x0758	 161 */		ba	.L77002256
/* 0x075c	     */		nop

! Registers live out of .L900000219: 
! sp fp i7 gsr 
! 
		
!  164		      !	    }
!  165		      !	 }
!  166		      !	 break;
!  167		      !      case GL_OR:
!  168		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002139:
/* 0x0760	 168 */		cmp	%i1,0
/* 0x0764	     */		bleu,pn	%icc,.L77002256
/* 0x0768	     */		cmp	%i1,6

! Registers live out of .L77002139: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002139

			.L77002280:
/* 0x076c	 168 */		bl,pn	%icc,.L77002649
/* 0x0770	     */		add	%o7,1022,%g3

! Registers live out of .L77002280: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002280

			.L77002370:
/* 0x0774	 168 */		sub	%i4,%l3,%o2
/* 0x0778	     */		sra	%o2,31,%o1
/* 0x077c	     */		xor	%o2,%o1,%l4
/* 0x0780	     */		sll	%i1,2,%o0
/* 0x0784	     */		sub	%i5,%i4,%o7
/* 0x0788	     */		sub	%i4,%i5,%l1
/* 0x078c	     */		sub	%l4,%o1,%l7
/* 0x0790	     */		sra	%o0,0,%g4
/* 0x0794	     */		sra	%o7,0,%o5
/* 0x0798	     */		sra	%l1,0,%g5
/* 0x079c	     */		sra	%i1,0,%o2
/* 0x07a0	     */		sub	%o5,%g4,%g2
/* 0x07a4	     */		sub	%g5,%o2,%o1
/* 0x07a8	     */		srl	%i1,0,%o0
/* 0x07ac	     */		sra	%l7,0,%o4
/* 0x07b0	     */		sub	%o0,%g3,%o7
/* 0x07b4	     */		srlx	%g2,63,%l2
/* 0x07b8	     */		srlx	%o1,63,%l5
/* 0x07bc	     */		sub	%o4,%g4,%o3
/* 0x07c0	     */		xor	%l2,1,%i3
/* 0x07c4	     */		xor	%l5,1,%i2
/* 0x07c8	     */		srlx	%o7,63,%i0
/* 0x07cc	     */		srlx	%o3,63,%l6
/* 0x07d0	     */		or	%i2,%i3,%l4
/* 0x07d4	     */		and	%i0,1,%o5
/* 0x07d8	     */		xor	%l6,1,%l0
/* 0x07dc	     */		and	%o5,%l4,%g3
/* 0x07e0	     */		andcc	%g3,%l0,%g0
/* 0x07e4	     */		be,a,pn	%icc,.L77002364
/* 0x07e8	     */		or	%g0,0,%o4

! Registers live out of .L77002370: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002370

			.L77002507:
/* 0x07ec	 168 */		sethi	%hi(0x1800),%g1
/* 0x07f0	     */		xor	%g1,-256,%g1
/* 0x07f4	     */		add	%i1,-1,%o5
/* 0x07f8	     */		or	%g0,0,%o7

!  169		      !	    if (mask[i]) {

/* 0x07fc	 169 */		ldub	[%i5],%l1
/* 0x0800	 168 */		add	%g1,%fp,%l7

! Registers live out of .L77002507: 
! o5 sp o7 l1 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002147 .L77002507

			.L900000243:
/* 0x0804	 169 */		cmp	%l1,0
/* 0x0808	     */		be,pn	%icc,.L77002147
/* 0x080c	 168 */		add	%o7,1,%o7

! Registers live out of .L900000243: 
! o5 sp o7 l1 l7 i4 i5 fp i7 gsr 
! 
		
!  170		      !	       index[i] |= dest[i];

                       
! predecessor blocks: .L900000243

			.L77002145:
/* 0x0810	 170 */		ld	[%i4],%o0
/* 0x0814	     */		ld	[%l7],%o1
/* 0x0818	     */		or	%o0,%o1,%l2
/* 0x081c	     */		st	%l2,[%i4]

! Registers live out of .L77002145: 
! o5 sp o7 l1 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002145 .L900000243

			.L77002147:
/* 0x0820	 168 */		cmp	%o7,%o5
/* 0x0824	     */		add	%i5,1,%i5
/* 0x0828	     */		add	%l7,4,%l7
/* 0x082c	     */		add	%i4,4,%i4
/* 0x0830	     */		ble,a,pt	%icc,.L900000243
/* 0x0834	 169 */		ldub	[%i5],%l1

! Registers live out of .L77002147: 
! o5 sp o7 l1 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002147

			.L77002367:
/* 0x0838	 168 */		ba	.L77002256
/* 0x083c	     */		nop

! Registers live out of .L77002367: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002280

			.L77002649:
/* 0x0840	 168 */		or	%g0,0,%o4

! Registers live out of .L77002649: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002370 .L77002649

			.L77002364:
/* 0x0844	 169 */		ldub	[%o4+%i5],%l7

! Registers live out of .L77002364: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002364 .L77002366

			.L900000242:
/* 0x0848	 169 */		cmp	%l7,0
/* 0x084c	     */		be,pn	%icc,.L77002366
/* 0x0850	 170 */		sll	%o4,2,%g4

! Registers live out of .L900000242: 
! g1 g4 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000242

			.L77002365:
/* 0x0854	 170 */		ld	[%i4+%g4],%l2
/* 0x0858	     */		ld	[%g4+%l3],%g2
/* 0x085c	     */		or	%l2,%g2,%l1
/* 0x0860	     */		st	%l1,[%i4+%g4]

! Registers live out of .L77002365: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002365 .L900000242

			.L77002366:
/* 0x0864	 168 */		add	%o4,1,%o4
/* 0x0868	     */		cmp	%o4,%i1
/* 0x086c	     */		bcs,a,pt	%icc,.L900000242
/* 0x0870	 169 */		ldub	[%o4+%i5],%l7

! Registers live out of .L77002366: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002366

			.L900000218:
/* 0x0874	 168 */		ba	.L77002256
/* 0x0878	     */		nop

! Registers live out of .L900000218: 
! sp fp i7 gsr 
! 
		
!  171		      !	    }
!  172		      !	 }
!  173		      !	 break;
!  174		      !      case GL_NOR:
!  175		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002153:
/* 0x087c	 175 */		cmp	%i1,0
/* 0x0880	     */		bleu,pn	%icc,.L77002256
/* 0x0884	     */		cmp	%i1,6

! Registers live out of .L77002153: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002153

			.L77002279:
/* 0x0888	 175 */		bl,pn	%icc,.L77002651
/* 0x088c	     */		add	%o7,1022,%o7

! Registers live out of .L77002279: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002279

			.L77002360:
/* 0x0890	 175 */		sub	%i4,%l3,%o3
/* 0x0894	     */		sra	%o3,31,%g5
/* 0x0898	     */		xor	%o3,%g5,%l6
/* 0x089c	     */		sll	%i1,2,%o2
/* 0x08a0	     */		sub	%i5,%i4,%o1
/* 0x08a4	     */		sub	%i4,%i5,%i2
/* 0x08a8	     */		sub	%l6,%g5,%i0
/* 0x08ac	     */		sra	%o2,0,%g3
/* 0x08b0	     */		sra	%o1,0,%o0
/* 0x08b4	     */		sra	%i2,0,%o4
/* 0x08b8	     */		sra	%i1,0,%o3
/* 0x08bc	     */		sub	%o0,%g3,%o5
/* 0x08c0	     */		sub	%o4,%o3,%g5
/* 0x08c4	     */		srl	%i1,0,%o2
/* 0x08c8	     */		sub	%o2,%o7,%o1
/* 0x08cc	     */		srlx	%o5,63,%l5
/* 0x08d0	     */		sra	%i0,0,%g2
/* 0x08d4	     */		srlx	%g5,63,%l2
/* 0x08d8	     */		sub	%g2,%g3,%g4
/* 0x08dc	     */		xor	%l5,1,%i3
/* 0x08e0	     */		xor	%l2,1,%l1
/* 0x08e4	     */		srlx	%o1,63,%l7
/* 0x08e8	     */		srlx	%g4,63,%l4
/* 0x08ec	     */		or	%l1,%i3,%l6
/* 0x08f0	     */		and	%l7,1,%o0
/* 0x08f4	     */		xor	%l4,1,%l0
/* 0x08f8	     */		and	%o0,%l6,%o7
/* 0x08fc	     */		andcc	%o7,%l0,%g0
/* 0x0900	     */		be,a,pn	%icc,.L77002354
/* 0x0904	     */		or	%g0,0,%g4

! Registers live out of .L77002360: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002360

			.L77002506:
/* 0x0908	 175 */		sethi	%hi(0x1800),%g1
/* 0x090c	     */		xor	%g1,-256,%g1
/* 0x0910	     */		add	%i1,-1,%l0
/* 0x0914	     */		or	%g0,0,%o2

!  176		      !	    if (mask[i]) {

/* 0x0918	 176 */		ldub	[%i5],%o3
/* 0x091c	 175 */		add	%g1,%fp,%i0

! Registers live out of .L77002506: 
! o2 o3 sp l0 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002161 .L77002506

			.L900000241:
/* 0x0920	 176 */		cmp	%o3,0
/* 0x0924	     */		be,pn	%icc,.L77002161
/* 0x0928	 175 */		add	%o2,1,%o2

! Registers live out of .L900000241: 
! o2 o3 sp l0 i0 i4 i5 fp i7 gsr 
! 
		
!  177		      !	       index[i] = ~(index[i] | dest[i]);

                       
! predecessor blocks: .L900000241

			.L77002159:
/* 0x092c	 177 */		ld	[%i4],%g4
/* 0x0930	     */		ld	[%i0],%l4
/* 0x0934	     */		or	%g4,%l4,%l3
/* 0x0938	     */		xnor	%l3,0,%i1
/* 0x093c	     */		st	%i1,[%i4]

! Registers live out of .L77002159: 
! o2 o3 sp l0 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002159 .L900000241

			.L77002161:
/* 0x0940	 175 */		cmp	%o2,%l0
/* 0x0944	     */		add	%i5,1,%i5
/* 0x0948	     */		add	%i0,4,%i0
/* 0x094c	     */		add	%i4,4,%i4
/* 0x0950	     */		ble,a,pt	%icc,.L900000241
/* 0x0954	 176 */		ldub	[%i5],%o3

! Registers live out of .L77002161: 
! o2 o3 sp l0 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002161

			.L77002357:
/* 0x0958	 175 */		ba	.L77002256
/* 0x095c	     */		nop

! Registers live out of .L77002357: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002279

			.L77002651:
/* 0x0960	 175 */		or	%g0,0,%g4

! Registers live out of .L77002651: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002360 .L77002651

			.L77002354:
/* 0x0964	 176 */		ldub	[%g4+%i5],%g2

! Registers live out of .L77002354: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002354 .L77002356

			.L900000240:
/* 0x0968	 176 */		cmp	%g2,0
/* 0x096c	     */		be,pn	%icc,.L77002356
/* 0x0970	 177 */		sll	%g4,2,%i0

! Registers live out of .L900000240: 
! g1 g2 g4 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000240

			.L77002355:
/* 0x0974	 177 */		ld	[%i4+%i0],%l5
/* 0x0978	     */		ld	[%i0+%l3],%o5
/* 0x097c	     */		or	%l5,%o5,%i2
/* 0x0980	     */		xnor	%i2,0,%g3
/* 0x0984	     */		st	%g3,[%i4+%i0]

! Registers live out of .L77002355: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002355 .L900000240

			.L77002356:
/* 0x0988	 175 */		add	%g4,1,%g4
/* 0x098c	     */		cmp	%g4,%i1
/* 0x0990	     */		bcs,a,pt	%icc,.L900000240
/* 0x0994	 176 */		ldub	[%g4+%i5],%g2

! Registers live out of .L77002356: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002356

			.L900000217:
/* 0x0998	 175 */		ba	.L77002256
/* 0x099c	     */		nop

! Registers live out of .L900000217: 
! sp fp i7 gsr 
! 
		
!  178		      !	    }
!  179		      !	 }
!  180		      !	 break;
!  181		      !      case GL_XOR:
!  182		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002167:
/* 0x09a0	 182 */		cmp	%i1,0
/* 0x09a4	     */		bleu,pn	%icc,.L77002256
/* 0x09a8	     */		cmp	%i1,6

! Registers live out of .L77002167: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002167

			.L77002281:
/* 0x09ac	 182 */		bl,pn	%icc,.L77002647
/* 0x09b0	     */		add	%o7,1022,%g3

! Registers live out of .L77002281: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002281

			.L77002380:
/* 0x09b4	 182 */		sub	%i4,%l3,%l6
/* 0x09b8	     */		sra	%l6,31,%o7
/* 0x09bc	     */		xor	%l6,%o7,%o0
/* 0x09c0	     */		sub	%o0,%o7,%i0
/* 0x09c4	     */		sll	%i1,2,%g4
/* 0x09c8	     */		sub	%i5,%i4,%o5
/* 0x09cc	     */		sub	%i4,%i5,%i2
/* 0x09d0	     */		sra	%g4,0,%o4
/* 0x09d4	     */		sra	%o5,0,%g2
/* 0x09d8	     */		sra	%i2,0,%o1
/* 0x09dc	     */		sra	%i1,0,%o0
/* 0x09e0	     */		sub	%g2,%o4,%g5
/* 0x09e4	     */		sub	%o1,%o0,%o7
/* 0x09e8	     */		srl	%i1,0,%g4
/* 0x09ec	     */		sra	%i0,0,%o3
/* 0x09f0	     */		sub	%g4,%g3,%o5
/* 0x09f4	     */		srlx	%g5,63,%l5
/* 0x09f8	     */		srlx	%o7,63,%l2
/* 0x09fc	     */		sub	%o3,%o4,%o2
/* 0x0a00	     */		xor	%l5,1,%i3
/* 0x0a04	     */		xor	%l2,1,%l1
/* 0x0a08	     */		srlx	%o5,63,%l7
/* 0x0a0c	     */		srlx	%o2,63,%l4
/* 0x0a10	     */		or	%l1,%i3,%l6
/* 0x0a14	     */		and	%l7,1,%g2
/* 0x0a18	     */		xor	%l4,1,%l0
/* 0x0a1c	     */		and	%g2,%l6,%g3
/* 0x0a20	     */		andcc	%g3,%l0,%g0
/* 0x0a24	     */		be,a,pn	%icc,.L77002374
/* 0x0a28	     */		or	%g0,0,%o3

! Registers live out of .L77002380: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002380

			.L77002508:
/* 0x0a2c	 182 */		sethi	%hi(0x1800),%g1
/* 0x0a30	     */		xor	%g1,-256,%g1
/* 0x0a34	     */		add	%i1,-1,%i3
/* 0x0a38	     */		or	%g0,0,%i2

!  183		      !	    if (mask[i]) {

/* 0x0a3c	 183 */		ldub	[%i5],%g2
/* 0x0a40	 182 */		add	%g1,%fp,%o4

! Registers live out of .L77002508: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002175 .L77002508

			.L900000239:
/* 0x0a44	 183 */		cmp	%g2,0
/* 0x0a48	     */		be,pn	%icc,.L77002175
/* 0x0a4c	 182 */		add	%i2,1,%i2

! Registers live out of .L900000239: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		
!  184		      !	       index[i] ^= dest[i];

                       
! predecessor blocks: .L900000239

			.L77002173:
/* 0x0a50	 184 */		ld	[%i4],%g5
/* 0x0a54	     */		ld	[%o4],%l5
/* 0x0a58	     */		xor	%g5,%l5,%g3
/* 0x0a5c	     */		st	%g3,[%i4]

! Registers live out of .L77002173: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002173 .L900000239

			.L77002175:
/* 0x0a60	 182 */		cmp	%i2,%i3
/* 0x0a64	     */		add	%i5,1,%i5
/* 0x0a68	     */		add	%o4,4,%o4
/* 0x0a6c	     */		add	%i4,4,%i4
/* 0x0a70	     */		ble,a,pt	%icc,.L900000239
/* 0x0a74	 183 */		ldub	[%i5],%g2

! Registers live out of .L77002175: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002175

			.L77002377:
/* 0x0a78	 182 */		ba	.L77002256
/* 0x0a7c	     */		nop

! Registers live out of .L77002377: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002281

			.L77002647:
/* 0x0a80	 182 */		or	%g0,0,%o3

! Registers live out of .L77002647: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002380 .L77002647

			.L77002374:
/* 0x0a84	 183 */		ldub	[%o3+%i5],%i0

! Registers live out of .L77002374: 
! g1 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002374 .L77002376

			.L900000238:
/* 0x0a88	 183 */		cmp	%i0,0
/* 0x0a8c	     */		be,pn	%icc,.L77002376
/* 0x0a90	 184 */		sll	%o3,2,%o4

! Registers live out of .L900000238: 
! g1 o3 o4 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000238

			.L77002375:
/* 0x0a94	 184 */		ld	[%i4+%o4],%l5
/* 0x0a98	     */		ld	[%o4+%l3],%g5
/* 0x0a9c	     */		xor	%l5,%g5,%i2
/* 0x0aa0	     */		st	%i2,[%i4+%o4]

! Registers live out of .L77002375: 
! g1 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002375 .L900000238

			.L77002376:
/* 0x0aa4	 182 */		add	%o3,1,%o3
/* 0x0aa8	     */		cmp	%o3,%i1
/* 0x0aac	     */		bcs,a,pt	%icc,.L900000238
/* 0x0ab0	 183 */		ldub	[%o3+%i5],%i0

! Registers live out of .L77002376: 
! g1 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002376

			.L900000216:
/* 0x0ab4	 182 */		ba	.L77002256
/* 0x0ab8	     */		nop

! Registers live out of .L900000216: 
! sp fp i7 gsr 
! 
		
!  185		      !	    }
!  186		      !	 }
!  187		      !	 break;
!  188		      !      case GL_EQUIV:
!  189		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002181:
/* 0x0abc	 189 */		cmp	%i1,0
/* 0x0ac0	     */		bleu,pn	%icc,.L77002256
/* 0x0ac4	     */		cmp	%i1,6

! Registers live out of .L77002181: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002181

			.L77002278:
/* 0x0ac8	 189 */		bl,pn	%icc,.L77002653
/* 0x0acc	     */		add	%o7,1022,%o1

! Registers live out of .L77002278: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002278

			.L77002350:
/* 0x0ad0	 189 */		sub	%i4,%l3,%l4
/* 0x0ad4	     */		sra	%l4,31,%o3
/* 0x0ad8	     */		xor	%l4,%o3,%o4
/* 0x0adc	     */		sll	%i1,2,%g5
/* 0x0ae0	     */		sub	%i5,%i4,%l2
/* 0x0ae4	     */		sub	%i4,%i5,%l1
/* 0x0ae8	     */		sub	%o4,%o3,%l7
/* 0x0aec	     */		sra	%g5,0,%o7
/* 0x0af0	     */		sra	%l2,0,%o2
/* 0x0af4	     */		sra	%l1,0,%g4
/* 0x0af8	     */		sra	%i1,0,%g2
/* 0x0afc	     */		sub	%o2,%o7,%o0
/* 0x0b00	     */		sub	%g4,%g2,%o4
/* 0x0b04	     */		srl	%i1,0,%o3
/* 0x0b08	     */		sub	%o3,%o1,%g5
/* 0x0b0c	     */		srlx	%o0,63,%i3
/* 0x0b10	     */		sra	%l7,0,%o5
/* 0x0b14	     */		srlx	%o4,63,%l5
/* 0x0b18	     */		sub	%o5,%o7,%g3
/* 0x0b1c	     */		xor	%i3,1,%i2
/* 0x0b20	     */		xor	%l5,1,%i0
/* 0x0b24	     */		srlx	%g5,63,%l4
/* 0x0b28	     */		srlx	%g3,63,%l6
/* 0x0b2c	     */		or	%i0,%i2,%l2
/* 0x0b30	     */		and	%l4,1,%o2
/* 0x0b34	     */		xor	%l6,1,%l0
/* 0x0b38	     */		and	%o2,%l2,%o1
/* 0x0b3c	     */		andcc	%o1,%l0,%g0
/* 0x0b40	     */		be,a,pn	%icc,.L77002344
/* 0x0b44	     */		or	%g0,0,%g3

! Registers live out of .L77002350: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002350

			.L77002505:
/* 0x0b48	 189 */		sethi	%hi(0x1800),%g1
/* 0x0b4c	     */		xor	%g1,-256,%g1
/* 0x0b50	     */		add	%i1,-1,%l6
/* 0x0b54	     */		or	%g0,0,%o5

!  190		      !	    if (mask[i]) {

/* 0x0b58	 190 */		ldub	[%i5],%l7
/* 0x0b5c	 189 */		add	%g1,%fp,%o7

! Registers live out of .L77002505: 
! o5 sp o7 l6 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002189 .L77002505

			.L900000237:
/* 0x0b60	 190 */		cmp	%l7,0
/* 0x0b64	     */		be,pn	%icc,.L77002189
/* 0x0b68	 189 */		add	%o5,1,%o5

! Registers live out of .L900000237: 
! o5 sp o7 l6 l7 i4 i5 fp i7 gsr 
! 
		
!  191		      !	       index[i] = ~(index[i] ^ dest[i]);

                       
! predecessor blocks: .L900000237

			.L77002187:
/* 0x0b6c	 191 */		ld	[%i4],%o0
/* 0x0b70	     */		ld	[%o7],%o1
/* 0x0b74	     */		xor	%o0,%o1,%l2
/* 0x0b78	     */		xnor	%l2,0,%l1
/* 0x0b7c	     */		st	%l1,[%i4]

! Registers live out of .L77002187: 
! o5 sp o7 l6 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002187 .L900000237

			.L77002189:
/* 0x0b80	 189 */		cmp	%o5,%l6
/* 0x0b84	     */		add	%i5,1,%i5
/* 0x0b88	     */		add	%o7,4,%o7
/* 0x0b8c	     */		add	%i4,4,%i4
/* 0x0b90	     */		ble,a,pt	%icc,.L900000237
/* 0x0b94	 190 */		ldub	[%i5],%l7

! Registers live out of .L77002189: 
! o5 sp o7 l6 l7 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002189

			.L77002347:
/* 0x0b98	 189 */		ba	.L77002256
/* 0x0b9c	     */		nop

! Registers live out of .L77002347: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002278

			.L77002653:
/* 0x0ba0	 189 */		or	%g0,0,%g3

! Registers live out of .L77002653: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002350 .L77002653

			.L77002344:
/* 0x0ba4	 190 */		ldub	[%g3+%i5],%o5

! Registers live out of .L77002344: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002344 .L77002346

			.L900000236:
/* 0x0ba8	 190 */		cmp	%o5,0
/* 0x0bac	     */		be,pn	%icc,.L77002346
/* 0x0bb0	 191 */		sll	%g3,2,%i3

! Registers live out of .L900000236: 
! g1 g3 o5 sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000236

			.L77002345:
/* 0x0bb4	 191 */		ld	[%i4+%i3],%l1
/* 0x0bb8	     */		ld	[%i3+%l3],%o0
/* 0x0bbc	     */		xor	%l1,%o0,%o7
/* 0x0bc0	     */		xnor	%o7,0,%l7
/* 0x0bc4	     */		st	%l7,[%i4+%i3]

! Registers live out of .L77002345: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002345 .L900000236

			.L77002346:
/* 0x0bc8	 189 */		add	%g3,1,%g3
/* 0x0bcc	     */		cmp	%g3,%i1
/* 0x0bd0	     */		bcs,a,pt	%icc,.L900000236
/* 0x0bd4	 190 */		ldub	[%g3+%i5],%o5

! Registers live out of .L77002346: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002346

			.L900000215:
/* 0x0bd8	 189 */		ba	.L77002256
/* 0x0bdc	     */		nop

! Registers live out of .L900000215: 
! sp fp i7 gsr 
! 
		
!  192		      !	    }
!  193		      !	 }
!  194		      !	 break;
!  195		      !      case GL_AND_REVERSE:
!  196		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002195:
/* 0x0be0	 196 */		cmp	%i1,0
/* 0x0be4	     */		bleu,pn	%icc,.L77002256
/* 0x0be8	     */		cmp	%i1,6

! Registers live out of .L77002195: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002195

			.L77002284:
/* 0x0bec	 196 */		bl,pn	%icc,.L77002641
/* 0x0bf0	     */		add	%o7,1022,%o7

! Registers live out of .L77002284: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002284

			.L77002410:
/* 0x0bf4	 196 */		sub	%i4,%l3,%o4
/* 0x0bf8	     */		sra	%o4,31,%o3
/* 0x0bfc	     */		xor	%o4,%o3,%l2
/* 0x0c00	     */		sll	%i1,2,%o2
/* 0x0c04	     */		sub	%i5,%i4,%o1
/* 0x0c08	     */		sub	%i4,%i5,%l7
/* 0x0c0c	     */		sub	%l2,%o3,%l6
/* 0x0c10	     */		sra	%o2,0,%g4
/* 0x0c14	     */		sra	%o1,0,%o0
/* 0x0c18	     */		sra	%l7,0,%g5
/* 0x0c1c	     */		sra	%i1,0,%o4
/* 0x0c20	     */		sub	%o0,%g4,%g3
/* 0x0c24	     */		sub	%g5,%o4,%o3
/* 0x0c28	     */		srl	%i1,0,%o2
/* 0x0c2c	     */		sra	%l6,0,%g2
/* 0x0c30	     */		sub	%o2,%o7,%o1
/* 0x0c34	     */		srlx	%g3,63,%l1
/* 0x0c38	     */		srlx	%o3,63,%l5
/* 0x0c3c	     */		sub	%g2,%g4,%o5
/* 0x0c40	     */		xor	%l1,1,%i3
/* 0x0c44	     */		xor	%l5,1,%i0
/* 0x0c48	     */		srlx	%o1,63,%l4
/* 0x0c4c	     */		srlx	%o5,63,%i2
/* 0x0c50	     */		or	%i0,%i3,%l2
/* 0x0c54	     */		and	%l4,1,%o0
/* 0x0c58	     */		xor	%i2,1,%l0
/* 0x0c5c	     */		and	%o0,%l2,%o7
/* 0x0c60	     */		andcc	%o7,%l0,%g0
/* 0x0c64	     */		be,a,pn	%icc,.L77002404
/* 0x0c68	     */		or	%g0,0,%g2

! Registers live out of .L77002410: 
! g1 g2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002410

			.L77002511:
/* 0x0c6c	 196 */		sethi	%hi(0x1800),%g1
/* 0x0c70	     */		add	%i1,-1,%o2
/* 0x0c74	     */		xor	%g1,-256,%g1
/* 0x0c78	     */		or	%g0,0,%i0

!  197		      !	    if (mask[i]) {

/* 0x0c7c	 197 */		ldub	[%i5],%i1
/* 0x0c80	 196 */		add	%g1,%fp,%o3

! Registers live out of .L77002511: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002203 .L77002511

			.L900000235:
/* 0x0c84	 197 */		cmp	%i1,0
/* 0x0c88	     */		be,pn	%icc,.L77002203
/* 0x0c8c	 196 */		add	%i0,1,%i0

! Registers live out of .L900000235: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		
!  198		      !	       index[i] = index[i] & ~dest[i];

                       
! predecessor blocks: .L900000235

			.L77002201:
/* 0x0c90	 198 */		ld	[%i4],%g4
/* 0x0c94	     */		ld	[%o3],%l4
/* 0x0c98	     */		andn	%g4,%l4,%l3
/* 0x0c9c	     */		st	%l3,[%i4]

! Registers live out of .L77002201: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002201 .L900000235

			.L77002203:
/* 0x0ca0	 196 */		cmp	%i0,%o2
/* 0x0ca4	     */		add	%i5,1,%i5
/* 0x0ca8	     */		add	%o3,4,%o3
/* 0x0cac	     */		add	%i4,4,%i4
/* 0x0cb0	     */		ble,a,pt	%icc,.L900000235
/* 0x0cb4	 197 */		ldub	[%i5],%i1

! Registers live out of .L77002203: 
! o2 o3 sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002203

			.L77002407:
/* 0x0cb8	 196 */		ba	.L77002256
/* 0x0cbc	     */		nop

! Registers live out of .L77002407: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002284

			.L77002641:
/* 0x0cc0	 196 */		or	%g0,0,%g2

! Registers live out of .L77002641: 
! g1 g2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002410 .L77002641

			.L77002404:
/* 0x0cc4	 197 */		ldub	[%g2+%i5],%l6

! Registers live out of .L77002404: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002404 .L77002406

			.L900000234:
/* 0x0cc8	 197 */		cmp	%l6,0
/* 0x0ccc	     */		be,pn	%icc,.L77002406
/* 0x0cd0	 198 */		sll	%g2,2,%g4

! Registers live out of .L900000234: 
! g1 g2 g4 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000234

			.L77002405:
/* 0x0cd4	 198 */		ld	[%i4+%g4],%l1
/* 0x0cd8	     */		ld	[%g4+%l3],%g3
/* 0x0cdc	     */		andn	%l1,%g3,%l7
/* 0x0ce0	     */		st	%l7,[%i4+%g4]

! Registers live out of .L77002405: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002405 .L900000234

			.L77002406:
/* 0x0ce4	 196 */		add	%g2,1,%g2
/* 0x0ce8	     */		cmp	%g2,%i1
/* 0x0cec	     */		bcs,a,pt	%icc,.L900000234
/* 0x0cf0	 197 */		ldub	[%g2+%i5],%l6

! Registers live out of .L77002406: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002406

			.L900000214:
/* 0x0cf4	 196 */		ba	.L77002256
/* 0x0cf8	     */		nop

! Registers live out of .L900000214: 
! sp fp i7 gsr 
! 
		
!  199		      !	    }
!  200		      !	 }
!  201		      !	 break;
!  202		      !      case GL_AND_INVERTED:
!  203		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002209:
/* 0x0cfc	 203 */		cmp	%i1,0
/* 0x0d00	     */		bleu,pn	%icc,.L77002256
/* 0x0d04	     */		cmp	%i1,6

! Registers live out of .L77002209: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002209

			.L77002283:
/* 0x0d08	 203 */		bl,pn	%icc,.L77002643
/* 0x0d0c	     */		add	%o7,1022,%o1

! Registers live out of .L77002283: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002283

			.L77002400:
/* 0x0d10	 203 */		sub	%i4,%l3,%o5
/* 0x0d14	     */		sra	%o5,31,%i2
/* 0x0d18	     */		xor	%o5,%i2,%g5
/* 0x0d1c	     */		sll	%i1,2,%o4
/* 0x0d20	     */		sub	%i5,%i4,%o3
/* 0x0d24	     */		sub	%i4,%i5,%i0
/* 0x0d28	     */		sub	%g5,%i2,%l4
/* 0x0d2c	     */		sra	%o4,0,%o7
/* 0x0d30	     */		sra	%o3,0,%o2
/* 0x0d34	     */		sra	%i0,0,%o5
/* 0x0d38	     */		sra	%i1,0,%g2
/* 0x0d3c	     */		sub	%o2,%o7,%o0
/* 0x0d40	     */		sub	%o5,%g2,%g5
/* 0x0d44	     */		srl	%i1,0,%o4
/* 0x0d48	     */		sra	%l4,0,%g3
/* 0x0d4c	     */		sub	%o4,%o1,%o3
/* 0x0d50	     */		srlx	%o0,63,%l5
/* 0x0d54	     */		srlx	%g5,63,%l1
/* 0x0d58	     */		sub	%g3,%o7,%g4
/* 0x0d5c	     */		xor	%l5,1,%i3
/* 0x0d60	     */		xor	%l1,1,%l7
/* 0x0d64	     */		srlx	%o3,63,%l6
/* 0x0d68	     */		srlx	%g4,63,%l2
/* 0x0d6c	     */		or	%l7,%i3,%i2
/* 0x0d70	     */		and	%l6,1,%o2
/* 0x0d74	     */		xor	%l2,1,%l0
/* 0x0d78	     */		and	%o2,%i2,%o1
/* 0x0d7c	     */		andcc	%o1,%l0,%g0
/* 0x0d80	     */		be,a,pn	%icc,.L77002394
/* 0x0d84	     */		or	%g0,0,%g3

! Registers live out of .L77002400: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002400

			.L77002510:
/* 0x0d88	 203 */		sethi	%hi(0x1800),%g1
/* 0x0d8c	     */		xor	%g1,-256,%g1
/* 0x0d90	     */		add	%i1,-1,%l0
/* 0x0d94	     */		or	%g0,0,%i3

!  204		      !	    if (mask[i]) {

/* 0x0d98	 204 */		ldub	[%i5],%o4
/* 0x0d9c	 203 */		add	%g1,%fp,%i2

! Registers live out of .L77002510: 
! o4 sp l0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002217 .L77002510

			.L900000233:
/* 0x0da0	 204 */		cmp	%o4,0
/* 0x0da4	     */		be,pn	%icc,.L77002217
/* 0x0da8	 203 */		add	%i3,1,%i3

! Registers live out of .L900000233: 
! o4 sp l0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  205		      !	       index[i] = ~index[i] & dest[i];

                       
! predecessor blocks: .L900000233

			.L77002215:
/* 0x0dac	 205 */		ld	[%i4],%g5
/* 0x0db0	     */		ld	[%i2],%g3
/* 0x0db4	     */		andn	%g3,%g5,%g2
/* 0x0db8	     */		st	%g2,[%i4]

! Registers live out of .L77002215: 
! o4 sp l0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002215 .L900000233

			.L77002217:
/* 0x0dbc	 203 */		cmp	%i3,%l0
/* 0x0dc0	     */		add	%i5,1,%i5
/* 0x0dc4	     */		add	%i2,4,%i2
/* 0x0dc8	     */		add	%i4,4,%i4
/* 0x0dcc	     */		ble,a,pt	%icc,.L900000233
/* 0x0dd0	 204 */		ldub	[%i5],%o4

! Registers live out of .L77002217: 
! o4 sp l0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002217

			.L77002397:
/* 0x0dd4	 203 */		ba	.L77002256
/* 0x0dd8	     */		nop

! Registers live out of .L77002397: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002283

			.L77002643:
/* 0x0ddc	 203 */		or	%g0,0,%g3

! Registers live out of .L77002643: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002400 .L77002643

			.L77002394:
/* 0x0de0	 204 */		ldub	[%g3+%i5],%l4

! Registers live out of .L77002394: 
! g1 g3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002394 .L77002396

			.L900000232:
/* 0x0de4	 204 */		cmp	%l4,0
/* 0x0de8	     */		be,pn	%icc,.L77002396
/* 0x0dec	 205 */		sll	%g3,2,%o7

! Registers live out of .L900000232: 
! g1 g3 sp o7 l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000232

			.L77002395:
/* 0x0df0	 205 */		ld	[%i4+%o7],%o0
/* 0x0df4	     */		ld	[%o7+%l3],%l5
/* 0x0df8	     */		andn	%l5,%o0,%i0
/* 0x0dfc	     */		st	%i0,[%i4+%o7]

! Registers live out of .L77002395: 
! g1 g3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002395 .L900000232

			.L77002396:
/* 0x0e00	 203 */		add	%g3,1,%g3
/* 0x0e04	     */		cmp	%g3,%i1
/* 0x0e08	     */		bcs,a,pt	%icc,.L900000232
/* 0x0e0c	 204 */		ldub	[%g3+%i5],%l4

! Registers live out of .L77002396: 
! g1 g3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002396

			.L900000213:
/* 0x0e10	 203 */		ba	.L77002256
/* 0x0e14	     */		nop

! Registers live out of .L900000213: 
! sp fp i7 gsr 
! 
		
!  206		      !	    }
!  207		      !	 }
!  208		      !	 break;
!  209		      !      case GL_OR_REVERSE:
!  210		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002223:
/* 0x0e18	 210 */		cmp	%i1,0
/* 0x0e1c	     */		bleu,pn	%icc,.L77002256
/* 0x0e20	     */		cmp	%i1,6

! Registers live out of .L77002223: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002223

			.L77002276:
/* 0x0e24	 210 */		bl,pn	%icc,.L77002657
/* 0x0e28	     */		add	%o7,1022,%g3

! Registers live out of .L77002276: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002276

			.L77002330:
/* 0x0e2c	 210 */		sub	%i4,%l3,%o0
/* 0x0e30	     */		sra	%o0,31,%l2
/* 0x0e34	     */		xor	%o0,%l2,%o7
/* 0x0e38	     */		sll	%i1,2,%o5
/* 0x0e3c	     */		sub	%i5,%i4,%l1
/* 0x0e40	     */		sub	%i4,%i5,%l6
/* 0x0e44	     */		sub	%o7,%l2,%l5
/* 0x0e48	     */		sra	%o5,0,%g4
/* 0x0e4c	     */		sra	%l1,0,%g2
/* 0x0e50	     */		sra	%l6,0,%g5
/* 0x0e54	     */		sra	%i1,0,%o1
/* 0x0e58	     */		sub	%g2,%g4,%o4
/* 0x0e5c	     */		sub	%g5,%o1,%o0
/* 0x0e60	     */		srl	%i1,0,%o7
/* 0x0e64	     */		sra	%l5,0,%o3
/* 0x0e68	     */		sub	%o7,%g3,%o5
/* 0x0e6c	     */		srlx	%o4,63,%l7
/* 0x0e70	     */		srlx	%o0,63,%i2
/* 0x0e74	     */		sub	%o3,%g4,%o2
/* 0x0e78	     */		xor	%l7,1,%i3
/* 0x0e7c	     */		xor	%i2,1,%i0
/* 0x0e80	     */		srlx	%o5,63,%l4
/* 0x0e84	     */		srlx	%o2,63,%l0
/* 0x0e88	     */		or	%i0,%i3,%l2
/* 0x0e8c	     */		and	%l4,1,%l1
/* 0x0e90	     */		xor	%l0,1,%g2
/* 0x0e94	     */		and	%l1,%l2,%g3
/* 0x0e98	     */		andcc	%g3,%g2,%g0
/* 0x0e9c	     */		be,a,pn	%icc,.L77002324
/* 0x0ea0	     */		or	%g0,0,%o3

! Registers live out of .L77002330: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002330

			.L77002503:
/* 0x0ea4	 210 */		sethi	%hi(0x1800),%g1
/* 0x0ea8	     */		xor	%g1,-256,%g1
/* 0x0eac	     */		add	%i1,-1,%l5
/* 0x0eb0	     */		or	%g0,0,%l6

!  211		      !	    if (mask[i]) {

/* 0x0eb4	 211 */		ldub	[%i5],%o7
/* 0x0eb8	 210 */		add	%g1,%fp,%o5

! Registers live out of .L77002503: 
! o5 sp o7 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002231 .L77002503

			.L900000231:
/* 0x0ebc	 211 */		cmp	%o7,0
/* 0x0ec0	     */		be,pn	%icc,.L77002231
/* 0x0ec4	 210 */		add	%l6,1,%l6

! Registers live out of .L900000231: 
! o5 sp o7 l5 l6 i4 i5 fp i7 gsr 
! 
		
!  212		      !	       index[i] = index[i] | ~dest[i];

                       
! predecessor blocks: .L900000231

			.L77002229:
/* 0x0ec8	 212 */		ld	[%i4],%l1
/* 0x0ecc	     */		ld	[%o5],%l2
/* 0x0ed0	     */		orn	%l1,%l2,%l7
/* 0x0ed4	     */		st	%l7,[%i4]

! Registers live out of .L77002229: 
! o5 sp o7 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002229 .L900000231

			.L77002231:
/* 0x0ed8	 210 */		cmp	%l6,%l5
/* 0x0edc	     */		add	%i5,1,%i5
/* 0x0ee0	     */		add	%o5,4,%o5
/* 0x0ee4	     */		add	%i4,4,%i4
/* 0x0ee8	     */		ble,a,pt	%icc,.L900000231
/* 0x0eec	 211 */		ldub	[%i5],%o7

! Registers live out of .L77002231: 
! o5 sp o7 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002231

			.L77002327:
/* 0x0ef0	 210 */		ba	.L77002256
/* 0x0ef4	     */		nop

! Registers live out of .L77002327: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002276

			.L77002657:
/* 0x0ef8	 210 */		or	%g0,0,%o3

! Registers live out of .L77002657: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002330 .L77002657

			.L77002324:
/* 0x0efc	 211 */		ldub	[%o3+%i5],%l5

! Registers live out of .L77002324: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002324 .L77002326

			.L900000230:
/* 0x0f00	 211 */		cmp	%l5,0
/* 0x0f04	     */		be,pn	%icc,.L77002326
/* 0x0f08	 212 */		sll	%o3,2,%g4

! Registers live out of .L900000230: 
! g1 g4 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000230

			.L77002325:
/* 0x0f0c	 212 */		ld	[%i4+%g4],%l7
/* 0x0f10	     */		ld	[%g4+%l3],%o4
/* 0x0f14	     */		orn	%l7,%o4,%l6
/* 0x0f18	     */		st	%l6,[%i4+%g4]

! Registers live out of .L77002325: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002325 .L900000230

			.L77002326:
/* 0x0f1c	 210 */		add	%o3,1,%o3
/* 0x0f20	     */		cmp	%o3,%i1
/* 0x0f24	     */		bcs,a,pt	%icc,.L900000230
/* 0x0f28	 211 */		ldub	[%o3+%i5],%l5

! Registers live out of .L77002326: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002326

			.L900000212:
/* 0x0f2c	 210 */		ba	.L77002256
/* 0x0f30	     */		nop

! Registers live out of .L900000212: 
! sp fp i7 gsr 
! 
		
!  213		      !	    }
!  214		      !	 }
!  215		      !	 break;
!  216		      !      case GL_OR_INVERTED:
!  217		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000227

			.L77002237:
/* 0x0f34	 217 */		cmp	%i1,0
/* 0x0f38	     */		bleu,pn	%icc,.L77002256
/* 0x0f3c	     */		cmp	%i1,6

! Registers live out of .L77002237: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002237

			.L77002274:
/* 0x0f40	 217 */		bl,pn	%icc,.L77002661
/* 0x0f44	     */		add	%o7,1022,%g3

! Registers live out of .L77002274: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002274

			.L77002310:
/* 0x0f48	 217 */		sub	%i4,%l3,%l0
/* 0x0f4c	     */		sra	%l0,31,%o0
/* 0x0f50	     */		xor	%l0,%o0,%o1
/* 0x0f54	     */		sub	%o1,%o0,%l4
/* 0x0f58	     */		sll	%i1,2,%o7
/* 0x0f5c	     */		sub	%i5,%i4,%o5
/* 0x0f60	     */		sub	%i4,%i5,%i2
/* 0x0f64	     */		sra	%o7,0,%o4
/* 0x0f68	     */		sra	%o5,0,%g5
/* 0x0f6c	     */		sra	%i2,0,%o2
/* 0x0f70	     */		sra	%i1,0,%o1
/* 0x0f74	     */		sub	%g5,%o4,%g2
/* 0x0f78	     */		sub	%o2,%o1,%o0
/* 0x0f7c	     */		srl	%i1,0,%o7
/* 0x0f80	     */		sra	%l4,0,%g4
/* 0x0f84	     */		sub	%o7,%g3,%o5
/* 0x0f88	     */		srlx	%g2,63,%i3
/* 0x0f8c	     */		srlx	%o0,63,%l2
/* 0x0f90	     */		sub	%g4,%o4,%o3
/* 0x0f94	     */		xor	%i3,1,%l1
/* 0x0f98	     */		xor	%l2,1,%l7
/* 0x0f9c	     */		srlx	%o5,63,%l6
/* 0x0fa0	     */		srlx	%o3,63,%i0
/* 0x0fa4	     */		or	%l7,%l1,%l5
/* 0x0fa8	     */		and	%l6,1,%g5
/* 0x0fac	     */		xor	%i0,1,%l0
/* 0x0fb0	     */		and	%g5,%l5,%g3
/* 0x0fb4	     */		andcc	%g3,%l0,%g0
/* 0x0fb8	     */		be,a,pn	%icc,.L77002304
/* 0x0fbc	     */		or	%g0,0,%g4

! Registers live out of .L77002310: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002310

			.L77002501:
/* 0x0fc0	 217 */		sethi	%hi(0x1800),%g1
/* 0x0fc4	     */		xor	%g1,-256,%g1
/* 0x0fc8	     */		add	%i1,-1,%o0
/* 0x0fcc	     */		or	%g0,0,%o1

!  218		      !	    if (mask[i]) {

/* 0x0fd0	 218 */		ldub	[%i5],%i0
/* 0x0fd4	 217 */		add	%g1,%fp,%o2

! Registers live out of .L77002501: 
! o0 o1 o2 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002245 .L77002501

			.L900000229:
/* 0x0fd8	 218 */		cmp	%i0,0
/* 0x0fdc	     */		be,pn	%icc,.L77002245
/* 0x0fe0	 217 */		add	%o1,1,%o1

! Registers live out of .L900000229: 
! o0 o1 o2 sp i0 i4 i5 fp i7 gsr 
! 
		
!  219		      !	       index[i] = ~index[i] | dest[i];

                       
! predecessor blocks: .L900000229

			.L77002243:
/* 0x0fe4	 219 */		ld	[%i4],%l3
/* 0x0fe8	     */		ld	[%o2],%i1
/* 0x0fec	     */		orn	%i1,%l3,%o3
/* 0x0ff0	     */		st	%o3,[%i4]

! Registers live out of .L77002243: 
! o0 o1 o2 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002243 .L900000229

			.L77002245:
/* 0x0ff4	 217 */		cmp	%o1,%o0
/* 0x0ff8	     */		add	%i5,1,%i5
/* 0x0ffc	     */		add	%o2,4,%o2
/* 0x1000	     */		add	%i4,4,%i4
/* 0x1004	     */		ble,a,pt	%icc,.L900000229
/* 0x1008	 218 */		ldub	[%i5],%i0

! Registers live out of .L77002245: 
! o0 o1 o2 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002245

			.L77002307:
/* 0x100c	 217 */		ba	.L77002256
/* 0x1010	     */		nop

! Registers live out of .L77002307: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002274

			.L77002661:
/* 0x1014	 217 */		or	%g0,0,%g4

! Registers live out of .L77002661: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002310 .L77002661

			.L77002304:
/* 0x1018	 218 */		ldub	[%g4+%i5],%l4

! Registers live out of .L77002304: 
! g1 g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002304 .L77002306

			.L900000228:
/* 0x101c	 218 */		cmp	%l4,0
/* 0x1020	     */		be,pn	%icc,.L77002306
/* 0x1024	 219 */		sll	%g4,2,%i3

! Registers live out of .L900000228: 
! g1 g4 sp l4 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000228

			.L77002305:
/* 0x1028	 219 */		ld	[%i4+%i3],%g2
/* 0x102c	     */		ld	[%i3+%l3],%i2
/* 0x1030	     */		orn	%i2,%g2,%o4
/* 0x1034	     */		st	%o4,[%i4+%i3]

! Registers live out of .L77002305: 
! g1 g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002305 .L900000228

			.L77002306:
/* 0x1038	 217 */		add	%g4,1,%g4
/* 0x103c	     */		cmp	%g4,%i1
/* 0x1040	     */		bcs,a,pt	%icc,.L900000228
/* 0x1044	 218 */		ldub	[%g4+%i5],%l4

! Registers live out of .L77002306: 
! g1 g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002306

			.L900000211:
/* 0x1048	 217 */		ba	.L77002256
/* 0x104c	     */		nop

! Registers live out of .L900000211: 
! sp fp i7 gsr 
! 
		
!  220		      !	    }
!  221		      !	 }
!  222		      !	 break;
!  223		      !      default:
!  224		      !	 gl_error( ctx, GL_INVALID_ENUM, "gl_logic error" );

                       
! predecessor blocks: gl_logicop_ci_span .L900000227

			.L77002251:
/* 0x1050	 224 */		or	%g0,1280,%o1
/* 0x1054	     */		or	%g0,%i0,%o0
/* 0x1058	     */		sethi	%hi(.L169),%i5
/* 0x105c	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x1060	     */		add	%i5,%lo(.L169),%o2

! Registers live out of .L77002251: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002039 .L77002053 .L77002069 .L77002083 .L77002097 .L77002111 .L77002125 .L77002139 .L77002153 .L77002167
! predecessor blocks: .L77002181 .L77002195 .L77002209 .L77002223 .L77002237 .L77002251 .L77002307 .L77002317 .L77002327 .L77002337 .L77002347
! predecessor blocks: .L77002357 .L77002367 .L77002377 .L77002387 .L77002397 .L77002407 .L77002417 .L77002427 .L77002437 .L77002447 .L900000211
! predecessor blocks: .L900000212 .L900000213 .L900000214 .L900000215 .L900000216 .L900000217 .L900000218 .L900000219 .L900000220 .L900000221 .L900000222
! predecessor blocks: .L900000223 .L900000224 .L900000225 .L900000227

			.L77002256:
/* 0x1064	 121 */		ret	! Result = 
/* 0x1068	     */		restore	%g0,0,%g0
/* 0x106c	   0 */		.type	gl_logicop_ci_span,2
/* 0x106c	   0 */		.size	gl_logicop_ci_span,(.-gl_logicop_ci_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000301:
/* 000000	   0 */		.word	(.L77002877-(___const_seg_900000301+0x0))
/* 0x0004	     */		.word	(.L77002949-(___const_seg_900000301+0x0))
/* 0x0008	     */		.word	(.L77003033-(___const_seg_900000301+0x0))
/* 0x000c	     */		.word	(.L77003094-(___const_seg_900000301+0x0))
/* 0x0010	     */		.word	(.L77003047-(___const_seg_900000301+0x0))
/* 0x0014	     */		.word	(.L77002921-(___const_seg_900000301+0x0))
/* 0x0018	     */		.word	(.L77003005-(___const_seg_900000301+0x0))
/* 0x001c	     */		.word	(.L77002977-(___const_seg_900000301+0x0))
/* 0x0020	     */		.word	(.L77002991-(___const_seg_900000301+0x0))
/* 0x0024	     */		.word	(.L77003019-(___const_seg_900000301+0x0))
/* 0x0028	     */		.word	(.L77002935-(___const_seg_900000301+0x0))
/* 0x002c	     */		.word	(.L77003061-(___const_seg_900000301+0x0))
/* 0x0030	     */		.word	(.L77002907-(___const_seg_900000301+0x0))
/* 0x0034	     */		.word	(.L77003075-(___const_seg_900000301+0x0))
/* 0x0038	     */		.word	(.L77002963-(___const_seg_900000301+0x0))
/* 0x003c	     */		.word	(.L77002891-(___const_seg_900000301+0x0))
/* 0x0040	   0 */		.type	___const_seg_900000301,1
/* 0x0040	   0 */		.size	___const_seg_900000301,(.-___const_seg_900000301)
/* 0x0040	   0 */		.align	4

!  225		      !   }
!  226		      !}
!  230		      !/*
!  231		      ! * Apply the current logic operator to an array of CI pixels.  This is only
!  232		      ! * used if the device driver can't do logic ops.
!  233		      ! */
!  234		      !void gl_logicop_ci_pixels( GLcontext *ctx,
!  235		      !                           GLuint n, const GLint x[], const GLint y[],
!  236		      !                           GLuint index[], GLubyte mask[] )
!  237		      !{

!
! SUBROUTINE gl_logicop_ci_pixels
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_logicop_ci_pixels
                       

			gl_logicop_ci_pixels:
/* 000000	 237 */		sethi	%hi(0x4800),%g1
/* 0x0004	     */		xor	%g1,-872,%g1
/* 0x0008	     */		save	%sp,%g1,%sp
/* 0x000c	   0 */		sethi	%hi(0x4800),%g1
/* 0x0010	   0 */		xor	%g1,-768,%g1
/* 0x0014	   0 */		add	%g1,%fp,%l3

!  238		      !   GLuint dest[PB_SIZE];
!  239		      !   GLuint i;
!  241		      !   /* Read dest values from frame buffer */
!  242		      !   (*ctx->Driver.ReadIndexPixels)( ctx, n, x, y, dest, mask );

/* 0x0018	 242 */		sethi	%hi(0x4800),%g1
/* 0x001c	 237 */		or	%g0,%i3,%o3
/* 0x0020	 242 */		xor	%g1,-768,%g1
/* 0x0024	 237 */		or	%g0,%i2,%o2
/* 0x0028	 242 */		add	%g1,%fp,%o4
/* 0x002c	     */		or	%g0,%i5,%o5
/* 0x0030	     */		or	%g0,%i1,%o1

!  244		      !   switch (ctx->Color.LogicOp) {

/* 0x0034	 244 */		sethi	%hi(0x1c00),%l5
/* 0x0038	     */		add	%l5,716,%l2
/* 0x003c	     */		sethi	%hi(0x1400),%l4
/* 0x0040	     */		add	%l4,256,%l0
/* 0x0044	 242 */		ld	[%i0+2284],%i3
/* 0x0048	     */		jmpl	%i3,%o7
/* 0x004c	     */		or	%g0,%i0,%o0
/* 0x0050	 244 */		ld	[%i0+%l2],%o4
/* 0x0054	     */		sub	%o4,%l0,%l6
/* 0x0058	     */		cmp	%l6,15
/* 0x005c	     */		bgu,pn	%icc,.L77003089
/* 0x0060	     */		sll	%l6,2,%i2

! Registers live out of gl_logicop_ci_pixels: 
! g1 o2 sp i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_logicop_ci_pixels

			.L900000327:
/* 0x0064	 244 */		sethi	%hi(___const_seg_900000301),%l1
/* 0x0068	     */		add	%l1,%lo(___const_seg_900000301),%o5
/* 0x006c	     */		sethi	%hi(0x7ffffc00),%o7
/* 0x0070	     */		ld	[%i2+%o5],%l7
/* 0x0074	     */		jmpl	%l7+%o5,%g0
/* 0x0078	     */		nop

! Registers live out of .L900000327: 
! g1 o2 sp o7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  245		      !      case GL_CLEAR:
!  246		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002877:
/* 0x007c	 246 */		cmp	%i1,0
/* 0x0080	     */		bleu,pn	%icc,.L77003094
/* 0x0084	     */		cmp	%i1,4

! Registers live out of .L77002877: 
! sp o7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002877

			.L77003124:
/* 0x0088	 246 */		bl,pn	%icc,.L77003475
/* 0x008c	     */		add	%o7,1022,%o7

! Registers live out of .L77003124: 
! sp o7 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003124

			.L77003268:
/* 0x0090	 246 */		sub	%i4,%i5,%l5
/* 0x0094	     */		sll	%i1,2,%o3
/* 0x0098	     */		sub	%i5,%i4,%o2
/* 0x009c	     */		sra	%l5,0,%g5
/* 0x00a0	     */		sra	%o3,0,%o1
/* 0x00a4	     */		sra	%o2,0,%o0
/* 0x00a8	     */		sra	%i1,0,%g2
/* 0x00ac	     */		sub	%o0,%o1,%g3
/* 0x00b0	     */		sub	%g5,%g2,%g4
/* 0x00b4	     */		srl	%i1,0,%o5
/* 0x00b8	     */		srlx	%g3,63,%l4
/* 0x00bc	     */		srlx	%g4,63,%i3
/* 0x00c0	     */		sub	%o5,%o7,%o4
/* 0x00c4	     */		xor	%l4,1,%l2
/* 0x00c8	     */		xor	%i3,1,%i0
/* 0x00cc	     */		srlx	%o4,63,%l1
/* 0x00d0	     */		or	%i0,%l2,%l0
/* 0x00d4	     */		and	%l1,1,%l7
/* 0x00d8	     */		andcc	%l7,%l0,%g0
/* 0x00dc	     */		be,a,pn	%icc,.L77003262
/* 0x00e0	     */		or	%g0,0,%i2

! Registers live out of .L77003268: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003268

			.L77003351:
/* 0x00e4	 246 */		add	%i1,-1,%o2

!  247		      !	    if (mask[i]) {

/* 0x00e8	 247 */		ldub	[%i5],%o3
/* 0x00ec	 246 */		or	%g0,0,%l1

! Registers live out of .L77003351: 
! o2 o3 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002885 .L77003351

			.L900000357:
/* 0x00f0	 247 */		cmp	%o3,0
/* 0x00f4	     */		be,pn	%icc,.L77002885
/* 0x00f8	 246 */		add	%l1,1,%l1

! Registers live out of .L900000357: 
! o2 o3 sp l1 i4 i5 fp i7 gsr 
! 
		
!  248		      !	       index[i] = 0;

                       
! predecessor blocks: .L900000357

			.L77002883:
/* 0x00fc	 248 */		st	%g0,[%i4]

! Registers live out of .L77002883: 
! o2 o3 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002883 .L900000357

			.L77002885:
/* 0x0100	 246 */		cmp	%l1,%o2
/* 0x0104	     */		add	%i5,1,%i5
/* 0x0108	     */		add	%i4,4,%i4
/* 0x010c	     */		ble,a,pt	%icc,.L900000357
/* 0x0110	 247 */		ldub	[%i5],%o3

! Registers live out of .L77002885: 
! o2 o3 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002885

			.L77003265:
/* 0x0114	 246 */		ba	.L77003094
/* 0x0118	     */		nop

! Registers live out of .L77003265: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003124

			.L77003475:
/* 0x011c	 246 */		or	%g0,0,%i2

! Registers live out of .L77003475: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003268 .L77003475

			.L77003262:
/* 0x0120	 247 */		ldub	[%i2+%i5],%l3

! Registers live out of .L77003262: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003262 .L77003264

			.L900000356:
/* 0x0124	 247 */		cmp	%l3,0
/* 0x0128	     */		be,pn	%icc,.L77003264
/* 0x012c	 248 */		sll	%i2,2,%l6

! Registers live out of .L900000356: 
! sp l6 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000356

			.L77003263:
/* 0x0130	 248 */		st	%g0,[%l6+%i4]

! Registers live out of .L77003263: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003263 .L900000356

			.L77003264:
/* 0x0134	 246 */		add	%i2,1,%i2
/* 0x0138	     */		cmp	%i2,%i1
/* 0x013c	     */		bcs,a,pt	%icc,.L900000356
/* 0x0140	 247 */		ldub	[%i2+%i5],%l3

! Registers live out of .L77003264: 
! sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003264

			.L900000325:
/* 0x0144	 246 */		ba	.L77003094
/* 0x0148	     */		nop

! Registers live out of .L900000325: 
! sp fp i7 gsr 
! 
		
!  249		      !	    }
!  250		      !	 }
!  251		      !	 break;
!  252		      !      case GL_SET:
!  253		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002891:
/* 0x014c	 253 */		cmp	%i1,0
/* 0x0150	     */		bleu,pn	%icc,.L77003094
/* 0x0154	     */		cmp	%i1,4

! Registers live out of .L77002891: 
! sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002891

			.L77003125:
/* 0x0158	 253 */		bl,pn	%icc,.L77003503
/* 0x015c	     */		add	%o7,1022,%g3

! Registers live out of .L77003125: 
! g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003125

			.L77003278:
/* 0x0160	 253 */		sub	%i4,%i5,%l3
/* 0x0164	     */		sll	%i1,2,%l5
/* 0x0168	     */		sub	%i5,%i4,%o3
/* 0x016c	     */		sra	%l3,0,%g5
/* 0x0170	     */		sra	%l5,0,%o2
/* 0x0174	     */		sra	%o3,0,%o1
/* 0x0178	     */		sra	%i1,0,%g2
/* 0x017c	     */		sub	%o1,%o2,%o0
/* 0x0180	     */		sub	%g5,%g2,%o7
/* 0x0184	     */		srl	%i1,0,%g4
/* 0x0188	     */		srlx	%o0,63,%l4
/* 0x018c	     */		srlx	%o7,63,%i3
/* 0x0190	     */		sub	%g4,%g3,%o5
/* 0x0194	     */		xor	%l4,1,%l2
/* 0x0198	     */		xor	%i3,1,%i0
/* 0x019c	     */		srlx	%o5,63,%l1
/* 0x01a0	     */		or	%i0,%l2,%l0
/* 0x01a4	     */		and	%l1,1,%l7
/* 0x01a8	     */		andcc	%l7,%l0,%g0
/* 0x01ac	     */		be,a,pn	%icc,.L77003441
/* 0x01b0	     */		or	%g0,0,%l3

! Registers live out of .L77003278: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003278

			.L77003337:
/* 0x01b4	 253 */		add	%i1,-1,%i1
/* 0x01b8	     */		or	%g0,0,%l3

!  254		      !	    if (mask[i]) {

/* 0x01bc	 254 */		ldub	[%i5],%l2
/* 0x01c0	 253 */		or	%g0,1,%g4

! Registers live out of .L77003337: 
! g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002899 .L77003337

			.L900000355:
/* 0x01c4	 254 */		cmp	%l2,0
/* 0x01c8	     */		be,pn	%icc,.L77002899
/* 0x01cc	 253 */		add	%l3,1,%l3

! Registers live out of .L900000355: 
! g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		
!  255		      !	       index[i] = 1;

                       
! predecessor blocks: .L900000355

			.L77002897:
/* 0x01d0	 255 */		st	%g4,[%i4]

! Registers live out of .L77002897: 
! g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002897 .L900000355

			.L77002899:
/* 0x01d4	 253 */		cmp	%l3,%i1
/* 0x01d8	     */		add	%i5,1,%i5
/* 0x01dc	     */		add	%i4,4,%i4
/* 0x01e0	     */		ble,a,pt	%icc,.L900000355
/* 0x01e4	 254 */		ldub	[%i5],%l2

! Registers live out of .L77002899: 
! g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002899

			.L77003275:
/* 0x01e8	 253 */		ba	.L77003094
/* 0x01ec	     */		nop

! Registers live out of .L77003275: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003125

			.L77003503:
/* 0x01f0	 253 */		or	%g0,0,%l3

! Registers live out of .L77003503: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003278 .L77003503

			.L77003441:
/* 0x01f4	 253 */		or	%g0,1,%i2
/* 0x01f8	 254 */		ldub	[%l3+%i5],%o4

! Registers live out of .L77003441: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003274 .L77003441

			.L900000354:
/* 0x01fc	 254 */		cmp	%o4,0
/* 0x0200	     */		be,pn	%icc,.L77003274
/* 0x0204	 255 */		sll	%l3,2,%l6

! Registers live out of .L900000354: 
! o4 sp l6 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000354

			.L77003273:
/* 0x0208	 255 */		st	%i2,[%l6+%i4]

! Registers live out of .L77003273: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003273 .L900000354

			.L77003274:
/* 0x020c	 253 */		add	%l3,1,%l3
/* 0x0210	     */		cmp	%l3,%i1
/* 0x0214	     */		bcs,a,pt	%icc,.L900000354
/* 0x0218	 254 */		ldub	[%l3+%i5],%o4

! Registers live out of .L77003274: 
! o4 sp i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003274

			.L900000324:
/* 0x021c	 253 */		ba	.L77003094
/* 0x0220	     */		nop

! Registers live out of .L900000324: 
! sp fp i7 gsr 
! 
		
!  256		      !	    }
!  257		      !	 }
!  258		      !	 break;
!  259		      !      case GL_COPY:
!  260		      !	 /* do nothing */
!  261		      !	 break;
!  262		      !      case GL_COPY_INVERTED:
!  263		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002907:
/* 0x0224	 263 */		cmp	%i1,0
/* 0x0228	     */		bleu,pn	%icc,.L77003094
/* 0x022c	     */		cmp	%i1,4

! Registers live out of .L77002907: 
! sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002907

			.L77003113:
/* 0x0230	 263 */		bl,pn	%icc,.L77003497
/* 0x0234	     */		add	%o7,1022,%o5

! Registers live out of .L77003113: 
! o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003113

			.L77003158:
/* 0x0238	 263 */		sll	%i1,2,%o2
/* 0x023c	     */		sub	%i4,%i5,%l3
/* 0x0240	     */		sub	%i5,%i4,%l0
/* 0x0244	     */		sra	%o2,0,%o1
/* 0x0248	     */		sra	%l3,0,%g5
/* 0x024c	     */		sra	%l0,0,%o0
/* 0x0250	     */		sra	%i1,0,%g2
/* 0x0254	     */		sub	%o0,%o1,%o7
/* 0x0258	     */		sub	%g5,%g2,%g3
/* 0x025c	     */		srl	%i1,0,%o4
/* 0x0260	     */		srlx	%o7,63,%l4
/* 0x0264	     */		srlx	%g3,63,%i3
/* 0x0268	     */		sub	%o4,%o5,%g4
/* 0x026c	     */		xor	%l4,1,%i2
/* 0x0270	     */		xor	%i3,1,%l2
/* 0x0274	     */		srlx	%g4,63,%l1
/* 0x0278	     */		or	%l2,%i2,%l7
/* 0x027c	     */		and	%l1,1,%i0
/* 0x0280	     */		andcc	%i0,%l7,%g0
/* 0x0284	     */		be,a,pn	%icc,.L77003152
/* 0x0288	     */		or	%g0,0,%o2

! Registers live out of .L77003158: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003158

			.L77003340:
/* 0x028c	 263 */		add	%i1,-1,%i2

!  264		      !	    if (mask[i]) {

/* 0x0290	 264 */		ldub	[%i5],%i3
/* 0x0294	 263 */		or	%g0,0,%o4

! Registers live out of .L77003340: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002915 .L77003340

			.L900000353:
/* 0x0298	 264 */		cmp	%i3,0
/* 0x029c	     */		be,pn	%icc,.L77002915
/* 0x02a0	 263 */		add	%o4,1,%o4

! Registers live out of .L900000353: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		
!  265		      !	       index[i] = ~index[i];

                       
! predecessor blocks: .L900000353

			.L77002913:
/* 0x02a4	 265 */		ld	[%i4],%g5
/* 0x02a8	     */		xnor	%g5,0,%g2
/* 0x02ac	     */		st	%g2,[%i4]

! Registers live out of .L77002913: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002913 .L900000353

			.L77002915:
/* 0x02b0	 263 */		cmp	%o4,%i2
/* 0x02b4	     */		add	%i5,1,%i5
/* 0x02b8	     */		add	%i4,4,%i4
/* 0x02bc	     */		ble,a,pt	%icc,.L900000353
/* 0x02c0	 264 */		ldub	[%i5],%i3

! Registers live out of .L77002915: 
! o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002915

			.L77003155:
/* 0x02c4	 263 */		ba	.L77003094
/* 0x02c8	     */		nop

! Registers live out of .L77003155: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003113

			.L77003497:
/* 0x02cc	 263 */		or	%g0,0,%o2

! Registers live out of .L77003497: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003158 .L77003497

			.L77003152:
/* 0x02d0	 264 */		ldub	[%o2+%i5],%l3

! Registers live out of .L77003152: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003152 .L77003154

			.L900000352:
/* 0x02d4	 264 */		cmp	%l3,0
/* 0x02d8	     */		be,pn	%icc,.L77003154
/* 0x02dc	 265 */		sll	%o2,2,%o3

! Registers live out of .L900000352: 
! o2 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000352

			.L77003153:
/* 0x02e0	 265 */		ld	[%i4+%o3],%l6
/* 0x02e4	     */		xnor	%l6,0,%l5
/* 0x02e8	     */		st	%l5,[%i4+%o3]

! Registers live out of .L77003153: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003153 .L900000352

			.L77003154:
/* 0x02ec	 263 */		add	%o2,1,%o2
/* 0x02f0	     */		cmp	%o2,%i1
/* 0x02f4	     */		bcs,a,pt	%icc,.L900000352
/* 0x02f8	 264 */		ldub	[%o2+%i5],%l3

! Registers live out of .L77003154: 
! o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003154

			.L900000323:
/* 0x02fc	 263 */		ba	.L77003094
/* 0x0300	     */		nop

! Registers live out of .L900000323: 
! sp fp i7 gsr 
! 
		
!  266		      !	    }
!  267		      !	 }
!  268		      !	 break;
!  269		      !      case GL_NOOP:
!  270		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002921:
/* 0x0304	 270 */		cmp	%i1,0
/* 0x0308	     */		bleu,pn	%icc,.L77003094
/* 0x030c	     */		cmp	%i1,6

! Registers live out of .L77002921: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002921

			.L77003120:
/* 0x0310	 270 */		bl,pn	%icc,.L77003483
/* 0x0314	     */		add	%o7,1022,%o3

! Registers live out of .L77003120: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003120

			.L77003228:
/* 0x0318	 270 */		sub	%i4,%l3,%g4
/* 0x031c	     */		sra	%g4,31,%o5
/* 0x0320	     */		xor	%g4,%o5,%i0
/* 0x0324	     */		sll	%i1,2,%g2
/* 0x0328	     */		sub	%i5,%i4,%g5
/* 0x032c	     */		sub	%i4,%i5,%l7
/* 0x0330	     */		sra	%g2,0,%o1
/* 0x0334	     */		sub	%i0,%o5,%l6
/* 0x0338	     */		sra	%g5,0,%o4
/* 0x033c	     */		sra	%l7,0,%g3
/* 0x0340	     */		sra	%i1,0,%g4
/* 0x0344	     */		sub	%o4,%o1,%o2
/* 0x0348	     */		sub	%g3,%g4,%o5
/* 0x034c	     */		srl	%i1,0,%g2
/* 0x0350	     */		sub	%g2,%o3,%g5
/* 0x0354	     */		srlx	%o2,63,%l1
/* 0x0358	     */		sra	%l6,0,%o0
/* 0x035c	     */		srlx	%o5,63,%l5
/* 0x0360	     */		sub	%o0,%o1,%o7
/* 0x0364	     */		xor	%l1,1,%i3
/* 0x0368	     */		xor	%l5,1,%l4
/* 0x036c	     */		srlx	%g5,63,%l2
/* 0x0370	     */		srlx	%o7,63,%i2
/* 0x0374	     */		or	%l4,%i3,%o4
/* 0x0378	     */		and	%l2,1,%i0
/* 0x037c	     */		xor	%i2,1,%l0
/* 0x0380	     */		and	%i0,%o4,%o3
/* 0x0384	     */		andcc	%o3,%l0,%g0
/* 0x0388	     */		be,a,pn	%icc,.L77003222
/* 0x038c	     */		or	%g0,0,%o1

! Registers live out of .L77003228: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003228

			.L77003347:
/* 0x0390	 270 */		sethi	%hi(0x4800),%g1
/* 0x0394	     */		xor	%g1,-768,%g1
/* 0x0398	     */		add	%i1,-1,%g3
/* 0x039c	     */		or	%g0,0,%l4

!  271		      !	    if (mask[i]) {

/* 0x03a0	 271 */		ldub	[%i5],%l6
/* 0x03a4	 270 */		add	%g1,%fp,%l5

! Registers live out of .L77003347: 
! g3 sp l4 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002929 .L77003347

			.L900000351:
/* 0x03a8	 271 */		cmp	%l6,0
/* 0x03ac	     */		be,pn	%icc,.L77002929
/* 0x03b0	 270 */		add	%l4,1,%l4

! Registers live out of .L900000351: 
! g3 sp l4 l5 l6 i4 i5 fp i7 gsr 
! 
		
!  272		      !	       index[i] = dest[i];

                       
! predecessor blocks: .L900000351

			.L77002927:
/* 0x03b4	 272 */		ld	[%l5],%o5
/* 0x03b8	     */		st	%o5,[%i4]

! Registers live out of .L77002927: 
! g3 sp l4 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002927 .L900000351

			.L77002929:
/* 0x03bc	 270 */		cmp	%l4,%g3
/* 0x03c0	     */		add	%i5,1,%i5
/* 0x03c4	     */		add	%l5,4,%l5
/* 0x03c8	     */		add	%i4,4,%i4
/* 0x03cc	     */		ble,a,pt	%icc,.L900000351
/* 0x03d0	 271 */		ldub	[%i5],%l6

! Registers live out of .L77002929: 
! g3 sp l4 l5 l6 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002929

			.L77003225:
/* 0x03d4	 270 */		ba	.L77003094
/* 0x03d8	     */		nop

! Registers live out of .L77003225: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003120

			.L77003483:
/* 0x03dc	 270 */		or	%g0,0,%o1

! Registers live out of .L77003483: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003228 .L77003483

			.L77003222:
/* 0x03e0	 271 */		ldub	[%o1+%i5],%l7

! Registers live out of .L77003222: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003222 .L77003224

			.L900000350:
/* 0x03e4	 271 */		cmp	%l7,0
/* 0x03e8	     */		be,pn	%icc,.L77003224
/* 0x03ec	 272 */		sll	%o1,2,%o2

! Registers live out of .L900000350: 
! g1 o1 o2 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000350

			.L77003223:
/* 0x03f0	 272 */		ld	[%o2+%l3],%l1
/* 0x03f4	     */		st	%l1,[%o2+%i4]

! Registers live out of .L77003223: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003223 .L900000350

			.L77003224:
/* 0x03f8	 270 */		add	%o1,1,%o1
/* 0x03fc	     */		cmp	%o1,%i1
/* 0x0400	     */		bcs,a,pt	%icc,.L900000350
/* 0x0404	 271 */		ldub	[%o1+%i5],%l7

! Registers live out of .L77003224: 
! g1 o1 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003224

			.L900000322:
/* 0x0408	 270 */		ba	.L77003094
/* 0x040c	     */		nop

! Registers live out of .L900000322: 
! sp fp i7 gsr 
! 
		
!  273		      !	    }
!  274		      !	 }
!  275		      !	 break;
!  276		      !      case GL_INVERT:
!  277		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002935:
/* 0x0410	 277 */		cmp	%i1,0
/* 0x0414	     */		bleu,pn	%icc,.L77003094
/* 0x0418	     */		cmp	%i1,6

! Registers live out of .L77002935: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002935

			.L77003115:
/* 0x041c	 277 */		bl,pn	%icc,.L77003493
/* 0x0420	     */		add	%o7,1022,%o2

! Registers live out of .L77003115: 
! g1 o2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003115

			.L77003178:
/* 0x0424	 277 */		sub	%i4,%l3,%l6
/* 0x0428	     */		sra	%l6,31,%g2
/* 0x042c	     */		xor	%l6,%g2,%g4
/* 0x0430	     */		sll	%i1,2,%o4
/* 0x0434	     */		sub	%i5,%i4,%l5
/* 0x0438	     */		sub	%i4,%i5,%i2
/* 0x043c	     */		sub	%g4,%g2,%l2
/* 0x0440	     */		sra	%o4,0,%o1
/* 0x0444	     */		sra	%l5,0,%o3
/* 0x0448	     */		sra	%i2,0,%o5
/* 0x044c	     */		sra	%i1,0,%g3
/* 0x0450	     */		sub	%o3,%o1,%g5
/* 0x0454	     */		sub	%o5,%g3,%g4
/* 0x0458	     */		srl	%i1,0,%g2
/* 0x045c	     */		sra	%l2,0,%o0
/* 0x0460	     */		sub	%g2,%o2,%o4
/* 0x0464	     */		srlx	%g5,63,%l4
/* 0x0468	     */		srlx	%g4,63,%l1
/* 0x046c	     */		xor	%l4,1,%l7
/* 0x0470	     */		sub	%o0,%o1,%o7
/* 0x0474	     */		xor	%l1,1,%i3
/* 0x0478	     */		srlx	%o4,63,%l6
/* 0x047c	     */		srlx	%o7,63,%i0
/* 0x0480	     */		or	%i3,%l7,%l5
/* 0x0484	     */		and	%l6,1,%o3
/* 0x0488	     */		xor	%i0,1,%l0
/* 0x048c	     */		and	%o3,%l5,%o2
/* 0x0490	     */		andcc	%o2,%l0,%g0
/* 0x0494	     */		be,a,pn	%icc,.L77003172
/* 0x0498	     */		or	%g0,0,%l2

! Registers live out of .L77003178: 
! g1 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003178

			.L77003342:
/* 0x049c	 277 */		sethi	%hi(0x4800),%g1
/* 0x04a0	     */		xor	%g1,-768,%g1
/* 0x04a4	     */		add	%i1,-1,%o7
/* 0x04a8	     */		or	%g0,0,%i0

!  278		      !	    if (mask[i]) {

/* 0x04ac	 278 */		ldub	[%i5],%o0
/* 0x04b0	 277 */		add	%g1,%fp,%l7

! Registers live out of .L77003342: 
! o0 sp o7 l7 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002943 .L77003342

			.L900000349:
/* 0x04b4	 278 */		cmp	%o0,0
/* 0x04b8	     */		be,pn	%icc,.L77002943
/* 0x04bc	 277 */		add	%i0,1,%i0

! Registers live out of .L900000349: 
! o0 sp o7 l7 i0 i4 i5 fp i7 gsr 
! 
		
!  279		      !	       index[i] = ~dest[i];

                       
! predecessor blocks: .L900000349

			.L77002941:
/* 0x04c0	 279 */		ld	[%l7],%l0
/* 0x04c4	     */		xnor	%l0,0,%o1
/* 0x04c8	     */		st	%o1,[%i4]

! Registers live out of .L77002941: 
! o0 sp o7 l7 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002941 .L900000349

			.L77002943:
/* 0x04cc	 277 */		cmp	%i0,%o7
/* 0x04d0	     */		add	%i5,1,%i5
/* 0x04d4	     */		add	%l7,4,%l7
/* 0x04d8	     */		add	%i4,4,%i4
/* 0x04dc	     */		ble,a,pt	%icc,.L900000349
/* 0x04e0	 278 */		ldub	[%i5],%o0

! Registers live out of .L77002943: 
! o0 sp o7 l7 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002943

			.L77003175:
/* 0x04e4	 277 */		ba	.L77003094
/* 0x04e8	     */		nop

! Registers live out of .L77003175: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003115

			.L77003493:
/* 0x04ec	 277 */		or	%g0,0,%l2

! Registers live out of .L77003493: 
! g1 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003178 .L77003493

			.L77003172:
/* 0x04f0	 278 */		ldub	[%l2+%i5],%o1

! Registers live out of .L77003172: 
! g1 o1 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003172 .L77003174

			.L900000348:
/* 0x04f4	 278 */		cmp	%o1,0
/* 0x04f8	     */		be,pn	%icc,.L77003174
/* 0x04fc	 279 */		sll	%l2,2,%l4

! Registers live out of .L900000348: 
! g1 o1 sp l2 l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000348

			.L77003173:
/* 0x0500	 279 */		ld	[%l4+%l3],%g5
/* 0x0504	     */		xnor	%g5,0,%i2
/* 0x0508	     */		st	%i2,[%l4+%i4]

! Registers live out of .L77003173: 
! g1 o1 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003173 .L900000348

			.L77003174:
/* 0x050c	 277 */		add	%l2,1,%l2
/* 0x0510	     */		cmp	%l2,%i1
/* 0x0514	     */		bcs,a,pt	%icc,.L900000348
/* 0x0518	 278 */		ldub	[%l2+%i5],%o1

! Registers live out of .L77003174: 
! g1 o1 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003174

			.L900000321:
/* 0x051c	 277 */		ba	.L77003094
/* 0x0520	     */		nop

! Registers live out of .L900000321: 
! sp fp i7 gsr 
! 
		
!  280		      !	    }
!  281		      !	 }
!  282		      !	 break;
!  283		      !      case GL_AND:
!  284		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002949:
/* 0x0524	 284 */		cmp	%i1,0
/* 0x0528	     */		bleu,pn	%icc,.L77003094
/* 0x052c	     */		cmp	%i1,6

! Registers live out of .L77002949: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002949

			.L77003123:
/* 0x0530	 284 */		bl,pn	%icc,.L77003477
/* 0x0534	     */		add	%o7,1022,%g3

! Registers live out of .L77003123: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003123

			.L77003258:
/* 0x0538	 284 */		sub	%i4,%l3,%l5
/* 0x053c	     */		sra	%l5,31,%o2
/* 0x0540	     */		xor	%l5,%o2,%o3
/* 0x0544	     */		sub	%o3,%o2,%l2
/* 0x0548	     */		sll	%i1,2,%o1
/* 0x054c	     */		sub	%i5,%i4,%o0
/* 0x0550	     */		sub	%i4,%i5,%g2
/* 0x0554	     */		sra	%o1,0,%g4
/* 0x0558	     */		sra	%o0,0,%o7
/* 0x055c	     */		sra	%g2,0,%o3
/* 0x0560	     */		sra	%i1,0,%o2
/* 0x0564	     */		sub	%o7,%g4,%g5
/* 0x0568	     */		sub	%o3,%o2,%o1
/* 0x056c	     */		srl	%i1,0,%o0
/* 0x0570	     */		sra	%l2,0,%o5
/* 0x0574	     */		sub	%o0,%g3,%o7
/* 0x0578	     */		srlx	%g5,63,%l4
/* 0x057c	     */		srlx	%o1,63,%l1
/* 0x0580	     */		sub	%o5,%g4,%o4
/* 0x0584	     */		xor	%l4,1,%i3
/* 0x0588	     */		xor	%l1,1,%l7
/* 0x058c	     */		srlx	%o7,63,%l6
/* 0x0590	     */		srlx	%o4,63,%i0
/* 0x0594	     */		or	%l7,%i3,%i2
/* 0x0598	     */		and	%l6,1,%l5
/* 0x059c	     */		xor	%i0,1,%l0
/* 0x05a0	     */		and	%l5,%i2,%g3
/* 0x05a4	     */		andcc	%g3,%l0,%g0
/* 0x05a8	     */		be,a,pn	%icc,.L77003252
/* 0x05ac	     */		or	%g0,0,%o5

! Registers live out of .L77003258: 
! g1 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003258

			.L77003350:
/* 0x05b0	 284 */		sethi	%hi(0x4800),%g1
/* 0x05b4	     */		add	%i1,-1,%o2
/* 0x05b8	     */		xor	%g1,-768,%g1
/* 0x05bc	     */		or	%g0,0,%l1

!  285		      !	    if (mask[i]) {

/* 0x05c0	 285 */		ldub	[%i5],%i1
/* 0x05c4	 284 */		add	%g1,%fp,%o3

! Registers live out of .L77003350: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002957 .L77003350

			.L900000347:
/* 0x05c8	 285 */		cmp	%i1,0
/* 0x05cc	     */		be,pn	%icc,.L77002957
/* 0x05d0	 284 */		add	%l1,1,%l1

! Registers live out of .L900000347: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		
!  286		      !	       index[i] &= dest[i];

                       
! predecessor blocks: .L900000347

			.L77002955:
/* 0x05d4	 286 */		ld	[%i4],%g4
/* 0x05d8	     */		ld	[%o3],%l2
/* 0x05dc	     */		and	%g4,%l2,%l3
/* 0x05e0	     */		st	%l3,[%i4]

! Registers live out of .L77002955: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002955 .L900000347

			.L77002957:
/* 0x05e4	 284 */		cmp	%l1,%o2
/* 0x05e8	     */		add	%i5,1,%i5
/* 0x05ec	     */		add	%o3,4,%o3
/* 0x05f0	     */		add	%i4,4,%i4
/* 0x05f4	     */		ble,a,pt	%icc,.L900000347
/* 0x05f8	 285 */		ldub	[%i5],%i1

! Registers live out of .L77002957: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002957

			.L77003255:
/* 0x05fc	 284 */		ba	.L77003094
/* 0x0600	     */		nop

! Registers live out of .L77003255: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003123

			.L77003477:
/* 0x0604	 284 */		or	%g0,0,%o5

! Registers live out of .L77003477: 
! g1 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003258 .L77003477

			.L77003252:
/* 0x0608	 285 */		ldub	[%o5+%i5],%l2

! Registers live out of .L77003252: 
! g1 o5 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003252 .L77003254

			.L900000346:
/* 0x060c	 285 */		cmp	%l2,0
/* 0x0610	     */		be,pn	%icc,.L77003254
/* 0x0614	 286 */		sll	%o5,2,%g4

! Registers live out of .L900000346: 
! g1 g4 o5 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000346

			.L77003253:
/* 0x0618	 286 */		ld	[%i4+%g4],%l4
/* 0x061c	     */		ld	[%g4+%l3],%g5
/* 0x0620	     */		and	%l4,%g5,%g2
/* 0x0624	     */		st	%g2,[%i4+%g4]

! Registers live out of .L77003253: 
! g1 o5 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003253 .L900000346

			.L77003254:
/* 0x0628	 284 */		add	%o5,1,%o5
/* 0x062c	     */		cmp	%o5,%i1
/* 0x0630	     */		bcs,a,pt	%icc,.L900000346
/* 0x0634	 285 */		ldub	[%o5+%i5],%l2

! Registers live out of .L77003254: 
! g1 o5 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003254

			.L900000320:
/* 0x0638	 284 */		ba	.L77003094
/* 0x063c	     */		nop

! Registers live out of .L900000320: 
! sp fp i7 gsr 
! 
		
!  287		      !	    }
!  288		      !	 }
!  289		      !	 break;
!  290		      !      case GL_NAND:
!  291		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002963:
/* 0x0640	 291 */		cmp	%i1,0
/* 0x0644	     */		bleu,pn	%icc,.L77003094
/* 0x0648	     */		cmp	%i1,6

! Registers live out of .L77002963: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002963

			.L77003126:
/* 0x064c	 291 */		bl,pn	%icc,.L77003501
/* 0x0650	     */		add	%o7,1022,%g3

! Registers live out of .L77003126: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003126

			.L77003288:
/* 0x0654	 291 */		sub	%i4,%l3,%o3
/* 0x0658	     */		sra	%o3,31,%o1
/* 0x065c	     */		xor	%o3,%o1,%o2
/* 0x0660	     */		sub	%o2,%o1,%l6
/* 0x0664	     */		sll	%i1,2,%o0
/* 0x0668	     */		sub	%i5,%i4,%g5
/* 0x066c	     */		sub	%i4,%i5,%i2
/* 0x0670	     */		sra	%o0,0,%g4
/* 0x0674	     */		sra	%g5,0,%g2
/* 0x0678	     */		sra	%i2,0,%o3
/* 0x067c	     */		sra	%i1,0,%o2
/* 0x0680	     */		sub	%g2,%g4,%o7
/* 0x0684	     */		sub	%o3,%o2,%o1
/* 0x0688	     */		srl	%i1,0,%o0
/* 0x068c	     */		sub	%o0,%g3,%g5
/* 0x0690	     */		srlx	%o7,63,%l7
/* 0x0694	     */		sra	%l6,0,%o5
/* 0x0698	     */		srlx	%o1,63,%l4
/* 0x069c	     */		sub	%o5,%g4,%o4
/* 0x06a0	     */		xor	%l7,1,%i3
/* 0x06a4	     */		xor	%l4,1,%i0
/* 0x06a8	     */		srlx	%g5,63,%l2
/* 0x06ac	     */		srlx	%o4,63,%l5
/* 0x06b0	     */		or	%i0,%i3,%l1
/* 0x06b4	     */		and	%l2,1,%g2
/* 0x06b8	     */		xor	%l5,1,%l0
/* 0x06bc	     */		and	%g2,%l1,%g3
/* 0x06c0	     */		andcc	%g3,%l0,%g0
/* 0x06c4	     */		be,a,pn	%icc,.L77003282
/* 0x06c8	     */		or	%g0,0,%o4

! Registers live out of .L77003288: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003288

			.L77003338:
/* 0x06cc	 291 */		sethi	%hi(0x4800),%g1
/* 0x06d0	     */		xor	%g1,-768,%g1
/* 0x06d4	     */		add	%i1,-1,%o4
/* 0x06d8	     */		or	%g0,0,%i3

!  292		      !	    if (mask[i]) {

/* 0x06dc	 292 */		ldub	[%i5],%g2
/* 0x06e0	 291 */		add	%g1,%fp,%i2

! Registers live out of .L77003338: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002971 .L77003338

			.L900000345:
/* 0x06e4	 292 */		cmp	%g2,0
/* 0x06e8	     */		be,pn	%icc,.L77002971
/* 0x06ec	 291 */		add	%i3,1,%i3

! Registers live out of .L900000345: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		
!  293		      !	       index[i] = ~(index[i] & dest[i]);

                       
! predecessor blocks: .L900000345

			.L77002969:
/* 0x06f0	 293 */		ld	[%i4],%l4
/* 0x06f4	     */		ld	[%i2],%l5
/* 0x06f8	     */		and	%l4,%l5,%g3
/* 0x06fc	     */		xnor	%g3,0,%g5
/* 0x0700	     */		st	%g5,[%i4]

! Registers live out of .L77002969: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002969 .L900000345

			.L77002971:
/* 0x0704	 291 */		cmp	%i3,%o4
/* 0x0708	     */		add	%i5,1,%i5
/* 0x070c	     */		add	%i2,4,%i2
/* 0x0710	     */		add	%i4,4,%i4
/* 0x0714	     */		ble,a,pt	%icc,.L900000345
/* 0x0718	 292 */		ldub	[%i5],%g2

! Registers live out of .L77002971: 
! g2 o4 sp i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002971

			.L77003285:
/* 0x071c	 291 */		ba	.L77003094
/* 0x0720	     */		nop

! Registers live out of .L77003285: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003126

			.L77003501:
/* 0x0724	 291 */		or	%g0,0,%o4

! Registers live out of .L77003501: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003288 .L77003501

			.L77003282:
/* 0x0728	 292 */		ldub	[%o4+%i5],%o5

! Registers live out of .L77003282: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003282 .L77003284

			.L900000344:
/* 0x072c	 292 */		cmp	%o5,0
/* 0x0730	     */		be,pn	%icc,.L77003284
/* 0x0734	 293 */		sll	%o4,2,%l6

! Registers live out of .L900000344: 
! g1 o4 o5 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000344

			.L77003283:
/* 0x0738	 293 */		ld	[%i4+%l6],%l7
/* 0x073c	     */		ld	[%l6+%l3],%o7
/* 0x0740	     */		and	%l7,%o7,%i2
/* 0x0744	     */		xnor	%i2,0,%g4
/* 0x0748	     */		st	%g4,[%i4+%l6]

! Registers live out of .L77003283: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003283 .L900000344

			.L77003284:
/* 0x074c	 291 */		add	%o4,1,%o4
/* 0x0750	     */		cmp	%o4,%i1
/* 0x0754	     */		bcs,a,pt	%icc,.L900000344
/* 0x0758	 292 */		ldub	[%o4+%i5],%o5

! Registers live out of .L77003284: 
! g1 o4 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003284

			.L900000319:
/* 0x075c	 291 */		ba	.L77003094
/* 0x0760	     */		nop

! Registers live out of .L900000319: 
! sp fp i7 gsr 
! 
		
!  294		      !	    }
!  295		      !	 }
!  296		      !	 break;
!  297		      !      case GL_OR:
!  298		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002977:
/* 0x0764	 298 */		cmp	%i1,0
/* 0x0768	     */		bleu,pn	%icc,.L77003094
/* 0x076c	     */		cmp	%i1,6

! Registers live out of .L77002977: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002977

			.L77003118:
/* 0x0770	 298 */		bl,pn	%icc,.L77003487
/* 0x0774	     */		add	%o7,1022,%g3

! Registers live out of .L77003118: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003118

			.L77003208:
/* 0x0778	 298 */		sub	%i4,%l3,%o2
/* 0x077c	     */		sra	%o2,31,%o1
/* 0x0780	     */		xor	%o2,%o1,%l2
/* 0x0784	     */		sll	%i1,2,%o0
/* 0x0788	     */		sub	%i5,%i4,%o7
/* 0x078c	     */		sub	%i4,%i5,%l1
/* 0x0790	     */		sub	%l2,%o1,%l7
/* 0x0794	     */		sra	%o0,0,%g4
/* 0x0798	     */		sra	%o7,0,%o5
/* 0x079c	     */		sra	%l1,0,%g5
/* 0x07a0	     */		sra	%i1,0,%o2
/* 0x07a4	     */		sub	%o5,%g4,%g2
/* 0x07a8	     */		sub	%g5,%o2,%o1
/* 0x07ac	     */		srl	%i1,0,%o0
/* 0x07b0	     */		sra	%l7,0,%o4
/* 0x07b4	     */		sub	%o0,%g3,%o7
/* 0x07b8	     */		srlx	%g2,63,%i0
/* 0x07bc	     */		srlx	%o1,63,%l5
/* 0x07c0	     */		sub	%o4,%g4,%o3
/* 0x07c4	     */		xor	%i0,1,%i3
/* 0x07c8	     */		xor	%l5,1,%i2
/* 0x07cc	     */		srlx	%o7,63,%l4
/* 0x07d0	     */		srlx	%o3,63,%l6
/* 0x07d4	     */		or	%i2,%i3,%l2
/* 0x07d8	     */		and	%l4,1,%o5
/* 0x07dc	     */		xor	%l6,1,%l0
/* 0x07e0	     */		and	%o5,%l2,%g3
/* 0x07e4	     */		andcc	%g3,%l0,%g0
/* 0x07e8	     */		be,a,pn	%icc,.L77003202
/* 0x07ec	     */		or	%g0,0,%o4

! Registers live out of .L77003208: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003208

			.L77003345:
/* 0x07f0	 298 */		sethi	%hi(0x4800),%g1
/* 0x07f4	     */		xor	%g1,-768,%g1
/* 0x07f8	     */		add	%i1,-1,%l6
/* 0x07fc	     */		or	%g0,0,%o5

!  299		      !	    if (mask[i]) {

/* 0x0800	 299 */		ldub	[%i5],%i0
/* 0x0804	 298 */		add	%g1,%fp,%o7

! Registers live out of .L77003345: 
! o5 sp o7 l6 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002985 .L77003345

			.L900000343:
/* 0x0808	 299 */		cmp	%i0,0
/* 0x080c	     */		be,pn	%icc,.L77002985
/* 0x0810	 298 */		add	%o5,1,%o5

! Registers live out of .L900000343: 
! o5 sp o7 l6 i0 i4 i5 fp i7 gsr 
! 
		
!  300		      !	       index[i] |= dest[i];

                       
! predecessor blocks: .L900000343

			.L77002983:
/* 0x0814	 300 */		ld	[%i4],%o0
/* 0x0818	     */		ld	[%o7],%o1
/* 0x081c	     */		or	%o0,%o1,%l7
/* 0x0820	     */		st	%l7,[%i4]

! Registers live out of .L77002983: 
! o5 sp o7 l6 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002983 .L900000343

			.L77002985:
/* 0x0824	 298 */		cmp	%o5,%l6
/* 0x0828	     */		add	%i5,1,%i5
/* 0x082c	     */		add	%o7,4,%o7
/* 0x0830	     */		add	%i4,4,%i4
/* 0x0834	     */		ble,a,pt	%icc,.L900000343
/* 0x0838	 299 */		ldub	[%i5],%i0

! Registers live out of .L77002985: 
! o5 sp o7 l6 i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002985

			.L77003205:
/* 0x083c	 298 */		ba	.L77003094
/* 0x0840	     */		nop

! Registers live out of .L77003205: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003118

			.L77003487:
/* 0x0844	 298 */		or	%g0,0,%o4

! Registers live out of .L77003487: 
! g1 o4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003208 .L77003487

			.L77003202:
/* 0x0848	 299 */		ldub	[%o4+%i5],%l7

! Registers live out of .L77003202: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003202 .L77003204

			.L900000342:
/* 0x084c	 299 */		cmp	%l7,0
/* 0x0850	     */		be,pn	%icc,.L77003204
/* 0x0854	 300 */		sll	%o4,2,%g4

! Registers live out of .L900000342: 
! g1 g4 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000342

			.L77003203:
/* 0x0858	 300 */		ld	[%i4+%g4],%i0
/* 0x085c	     */		ld	[%g4+%l3],%g2
/* 0x0860	     */		or	%i0,%g2,%l1
/* 0x0864	     */		st	%l1,[%i4+%g4]

! Registers live out of .L77003203: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003203 .L900000342

			.L77003204:
/* 0x0868	 298 */		add	%o4,1,%o4
/* 0x086c	     */		cmp	%o4,%i1
/* 0x0870	     */		bcs,a,pt	%icc,.L900000342
/* 0x0874	 299 */		ldub	[%o4+%i5],%l7

! Registers live out of .L77003204: 
! g1 o4 sp l7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003204

			.L900000318:
/* 0x0878	 298 */		ba	.L77003094
/* 0x087c	     */		nop

! Registers live out of .L900000318: 
! sp fp i7 gsr 
! 
		
!  301		      !	    }
!  302		      !	 }
!  303		      !	 break;
!  304		      !      case GL_NOR:
!  305		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77002991:
/* 0x0880	 305 */		cmp	%i1,0
/* 0x0884	     */		bleu,pn	%icc,.L77003094
/* 0x0888	     */		cmp	%i1,6

! Registers live out of .L77002991: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002991

			.L77003117:
/* 0x088c	 305 */		bl,pn	%icc,.L77003489
/* 0x0890	     */		add	%o7,1022,%o7

! Registers live out of .L77003117: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003117

			.L77003198:
/* 0x0894	 305 */		sub	%i4,%l3,%o3
/* 0x0898	     */		sra	%o3,31,%g5
/* 0x089c	     */		xor	%o3,%g5,%l6
/* 0x08a0	     */		sll	%i1,2,%o2
/* 0x08a4	     */		sub	%i5,%i4,%o1
/* 0x08a8	     */		sub	%i4,%i5,%i2
/* 0x08ac	     */		sub	%l6,%g5,%l4
/* 0x08b0	     */		sra	%o2,0,%g3
/* 0x08b4	     */		sra	%o1,0,%o0
/* 0x08b8	     */		sra	%i2,0,%o4
/* 0x08bc	     */		sra	%i1,0,%o3
/* 0x08c0	     */		sub	%o0,%g3,%o5
/* 0x08c4	     */		sub	%o4,%o3,%g5
/* 0x08c8	     */		srl	%i1,0,%o2
/* 0x08cc	     */		sub	%o2,%o7,%o1
/* 0x08d0	     */		srlx	%o5,63,%l5
/* 0x08d4	     */		sra	%l4,0,%g2
/* 0x08d8	     */		srlx	%g5,63,%i0
/* 0x08dc	     */		sub	%g2,%g3,%g4
/* 0x08e0	     */		xor	%l5,1,%i3
/* 0x08e4	     */		xor	%i0,1,%l1
/* 0x08e8	     */		srlx	%o1,63,%l7
/* 0x08ec	     */		srlx	%g4,63,%l2
/* 0x08f0	     */		or	%l1,%i3,%l6
/* 0x08f4	     */		and	%l7,1,%o0
/* 0x08f8	     */		xor	%l2,1,%l0
/* 0x08fc	     */		and	%o0,%l6,%o7
/* 0x0900	     */		andcc	%o7,%l0,%g0
/* 0x0904	     */		be,a,pn	%icc,.L77003192
/* 0x0908	     */		or	%g0,0,%g4

! Registers live out of .L77003198: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003198

			.L77003344:
/* 0x090c	 305 */		sethi	%hi(0x4800),%g1
/* 0x0910	     */		xor	%g1,-768,%g1
/* 0x0914	     */		add	%i1,-1,%l0
/* 0x0918	     */		or	%g0,0,%o2

!  306		      !	    if (mask[i]) {

/* 0x091c	 306 */		ldub	[%i5],%o3
/* 0x0920	 305 */		add	%g1,%fp,%l1

! Registers live out of .L77003344: 
! o2 o3 sp l0 l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002999 .L77003344

			.L900000341:
/* 0x0924	 306 */		cmp	%o3,0
/* 0x0928	     */		be,pn	%icc,.L77002999
/* 0x092c	 305 */		add	%o2,1,%o2

! Registers live out of .L900000341: 
! o2 o3 sp l0 l1 i4 i5 fp i7 gsr 
! 
		
!  307		      !	       index[i] = ~(index[i] | dest[i]);

                       
! predecessor blocks: .L900000341

			.L77002997:
/* 0x0930	 307 */		ld	[%i4],%g4
/* 0x0934	     */		ld	[%l1],%l2
/* 0x0938	     */		or	%g4,%l2,%l3
/* 0x093c	     */		xnor	%l3,0,%i1
/* 0x0940	     */		st	%i1,[%i4]

! Registers live out of .L77002997: 
! o2 o3 sp l0 l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002997 .L900000341

			.L77002999:
/* 0x0944	 305 */		cmp	%o2,%l0
/* 0x0948	     */		add	%i5,1,%i5
/* 0x094c	     */		add	%l1,4,%l1
/* 0x0950	     */		add	%i4,4,%i4
/* 0x0954	     */		ble,a,pt	%icc,.L900000341
/* 0x0958	 306 */		ldub	[%i5],%o3

! Registers live out of .L77002999: 
! o2 o3 sp l0 l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002999

			.L77003195:
/* 0x095c	 305 */		ba	.L77003094
/* 0x0960	     */		nop

! Registers live out of .L77003195: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003117

			.L77003489:
/* 0x0964	 305 */		or	%g0,0,%g4

! Registers live out of .L77003489: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003198 .L77003489

			.L77003192:
/* 0x0968	 306 */		ldub	[%g4+%i5],%g2

! Registers live out of .L77003192: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003192 .L77003194

			.L900000340:
/* 0x096c	 306 */		cmp	%g2,0
/* 0x0970	     */		be,pn	%icc,.L77003194
/* 0x0974	 307 */		sll	%g4,2,%l4

! Registers live out of .L900000340: 
! g1 g2 g4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000340

			.L77003193:
/* 0x0978	 307 */		ld	[%i4+%l4],%l5
/* 0x097c	     */		ld	[%l4+%l3],%o5
/* 0x0980	     */		or	%l5,%o5,%i2
/* 0x0984	     */		xnor	%i2,0,%g3
/* 0x0988	     */		st	%g3,[%i4+%l4]

! Registers live out of .L77003193: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003193 .L900000340

			.L77003194:
/* 0x098c	 305 */		add	%g4,1,%g4
/* 0x0990	     */		cmp	%g4,%i1
/* 0x0994	     */		bcs,a,pt	%icc,.L900000340
/* 0x0998	 306 */		ldub	[%g4+%i5],%g2

! Registers live out of .L77003194: 
! g1 g2 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003194

			.L900000317:
/* 0x099c	 305 */		ba	.L77003094
/* 0x09a0	     */		nop

! Registers live out of .L900000317: 
! sp fp i7 gsr 
! 
		
!  308		      !	    }
!  309		      !	 }
!  310		      !	 break;
!  311		      !      case GL_XOR:
!  312		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003005:
/* 0x09a4	 312 */		cmp	%i1,0
/* 0x09a8	     */		bleu,pn	%icc,.L77003094
/* 0x09ac	     */		cmp	%i1,6

! Registers live out of .L77003005: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003005

			.L77003119:
/* 0x09b0	 312 */		bl,pn	%icc,.L77003485
/* 0x09b4	     */		add	%o7,1022,%g3

! Registers live out of .L77003119: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003119

			.L77003218:
/* 0x09b8	 312 */		sub	%i4,%l3,%l6
/* 0x09bc	     */		sra	%l6,31,%o7
/* 0x09c0	     */		xor	%l6,%o7,%o0
/* 0x09c4	     */		sub	%o0,%o7,%l4
/* 0x09c8	     */		sll	%i1,2,%g4
/* 0x09cc	     */		sub	%i5,%i4,%o5
/* 0x09d0	     */		sub	%i4,%i5,%i2
/* 0x09d4	     */		sra	%g4,0,%o4
/* 0x09d8	     */		sra	%o5,0,%g2
/* 0x09dc	     */		sra	%i2,0,%o1
/* 0x09e0	     */		sra	%i1,0,%o0
/* 0x09e4	     */		sub	%g2,%o4,%g5
/* 0x09e8	     */		sub	%o1,%o0,%o7
/* 0x09ec	     */		srl	%i1,0,%g4
/* 0x09f0	     */		sra	%l4,0,%o3
/* 0x09f4	     */		sub	%g4,%g3,%o5
/* 0x09f8	     */		srlx	%g5,63,%l5
/* 0x09fc	     */		srlx	%o7,63,%i0
/* 0x0a00	     */		sub	%o3,%o4,%o2
/* 0x0a04	     */		xor	%l5,1,%i3
/* 0x0a08	     */		xor	%i0,1,%l1
/* 0x0a0c	     */		srlx	%o5,63,%l7
/* 0x0a10	     */		srlx	%o2,63,%l2
/* 0x0a14	     */		or	%l1,%i3,%l6
/* 0x0a18	     */		and	%l7,1,%g2
/* 0x0a1c	     */		xor	%l2,1,%l0
/* 0x0a20	     */		and	%g2,%l6,%g3
/* 0x0a24	     */		andcc	%g3,%l0,%g0
/* 0x0a28	     */		be,a,pn	%icc,.L77003212
/* 0x0a2c	     */		or	%g0,0,%o3

! Registers live out of .L77003218: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003218

			.L77003346:
/* 0x0a30	 312 */		sethi	%hi(0x4800),%g1
/* 0x0a34	     */		xor	%g1,-768,%g1
/* 0x0a38	     */		add	%i1,-1,%o4
/* 0x0a3c	     */		or	%g0,0,%i2

!  313		      !	    if (mask[i]) {

/* 0x0a40	 313 */		ldub	[%i5],%g5
/* 0x0a44	 312 */		add	%g1,%fp,%g2

! Registers live out of .L77003346: 
! g2 g5 o4 sp i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003013 .L77003346

			.L900000339:
/* 0x0a48	 313 */		cmp	%g5,0
/* 0x0a4c	     */		be,pn	%icc,.L77003013
/* 0x0a50	 312 */		add	%i2,1,%i2

! Registers live out of .L900000339: 
! g2 g5 o4 sp i2 i4 i5 fp i7 gsr 
! 
		
!  314		      !	       index[i] ^= dest[i];

                       
! predecessor blocks: .L900000339

			.L77003011:
/* 0x0a54	 314 */		ld	[%i4],%l4
/* 0x0a58	     */		ld	[%g2],%l5
/* 0x0a5c	     */		xor	%l4,%l5,%g3
/* 0x0a60	     */		st	%g3,[%i4]

! Registers live out of .L77003011: 
! g2 g5 o4 sp i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003011 .L900000339

			.L77003013:
/* 0x0a64	 312 */		cmp	%i2,%o4
/* 0x0a68	     */		add	%i5,1,%i5
/* 0x0a6c	     */		add	%g2,4,%g2
/* 0x0a70	     */		add	%i4,4,%i4
/* 0x0a74	     */		ble,a,pt	%icc,.L900000339
/* 0x0a78	 313 */		ldub	[%i5],%g5

! Registers live out of .L77003013: 
! g2 g5 o4 sp i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003013

			.L77003215:
/* 0x0a7c	 312 */		ba	.L77003094
/* 0x0a80	     */		nop

! Registers live out of .L77003215: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003119

			.L77003485:
/* 0x0a84	 312 */		or	%g0,0,%o3

! Registers live out of .L77003485: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003218 .L77003485

			.L77003212:
/* 0x0a88	 313 */		ldub	[%o3+%i5],%l4

! Registers live out of .L77003212: 
! g1 o3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003212 .L77003214

			.L900000338:
/* 0x0a8c	 313 */		cmp	%l4,0
/* 0x0a90	     */		be,pn	%icc,.L77003214
/* 0x0a94	 314 */		sll	%o3,2,%o4

! Registers live out of .L900000338: 
! g1 o3 o4 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000338

			.L77003213:
/* 0x0a98	 314 */		ld	[%i4+%o4],%l5
/* 0x0a9c	     */		ld	[%o4+%l3],%g5
/* 0x0aa0	     */		xor	%l5,%g5,%i2
/* 0x0aa4	     */		st	%i2,[%i4+%o4]

! Registers live out of .L77003213: 
! g1 o3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003213 .L900000338

			.L77003214:
/* 0x0aa8	 312 */		add	%o3,1,%o3
/* 0x0aac	     */		cmp	%o3,%i1
/* 0x0ab0	     */		bcs,a,pt	%icc,.L900000338
/* 0x0ab4	 313 */		ldub	[%o3+%i5],%l4

! Registers live out of .L77003214: 
! g1 o3 sp l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003214

			.L900000316:
/* 0x0ab8	 312 */		ba	.L77003094
/* 0x0abc	     */		nop

! Registers live out of .L900000316: 
! sp fp i7 gsr 
! 
		
!  315		      !	    }
!  316		      !	 }
!  317		      !	 break;
!  318		      !      case GL_EQUIV:
!  319		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003019:
/* 0x0ac0	 319 */		cmp	%i1,0
/* 0x0ac4	     */		bleu,pn	%icc,.L77003094
/* 0x0ac8	     */		cmp	%i1,6

! Registers live out of .L77003019: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003019

			.L77003116:
/* 0x0acc	 319 */		bl,pn	%icc,.L77003491
/* 0x0ad0	     */		add	%o7,1022,%o1

! Registers live out of .L77003116: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003116

			.L77003188:
/* 0x0ad4	 319 */		sub	%i4,%l3,%l2
/* 0x0ad8	     */		sra	%l2,31,%o3
/* 0x0adc	     */		xor	%l2,%o3,%o4
/* 0x0ae0	     */		sll	%i1,2,%g5
/* 0x0ae4	     */		sub	%i5,%i4,%i0
/* 0x0ae8	     */		sub	%i4,%i5,%l1
/* 0x0aec	     */		sub	%o4,%o3,%l7
/* 0x0af0	     */		sra	%g5,0,%o7
/* 0x0af4	     */		sra	%i0,0,%o2
/* 0x0af8	     */		sra	%l1,0,%g4
/* 0x0afc	     */		sra	%i1,0,%g2
/* 0x0b00	     */		sub	%o2,%o7,%o0
/* 0x0b04	     */		sub	%g4,%g2,%o4
/* 0x0b08	     */		srl	%i1,0,%o3
/* 0x0b0c	     */		sub	%o3,%o1,%g5
/* 0x0b10	     */		srlx	%o0,63,%i3
/* 0x0b14	     */		sra	%l7,0,%o5
/* 0x0b18	     */		srlx	%o4,63,%l5
/* 0x0b1c	     */		sub	%o5,%o7,%g3
/* 0x0b20	     */		xor	%i3,1,%i2
/* 0x0b24	     */		xor	%l5,1,%l4
/* 0x0b28	     */		srlx	%g5,63,%l2
/* 0x0b2c	     */		srlx	%g3,63,%l6
/* 0x0b30	     */		or	%l4,%i2,%o2
/* 0x0b34	     */		and	%l2,1,%i0
/* 0x0b38	     */		xor	%l6,1,%l0
/* 0x0b3c	     */		and	%i0,%o2,%o1
/* 0x0b40	     */		andcc	%o1,%l0,%g0
/* 0x0b44	     */		be,a,pn	%icc,.L77003182
/* 0x0b48	     */		or	%g0,0,%g3

! Registers live out of .L77003188: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003188

			.L77003343:
/* 0x0b4c	 319 */		sethi	%hi(0x4800),%g1
/* 0x0b50	     */		xor	%g1,-768,%g1
/* 0x0b54	     */		add	%i1,-1,%i3
/* 0x0b58	     */		or	%g0,0,%l6

!  320		      !	    if (mask[i]) {

/* 0x0b5c	 320 */		ldub	[%i5],%o7
/* 0x0b60	 319 */		add	%g1,%fp,%o5

! Registers live out of .L77003343: 
! o5 sp o7 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003027 .L77003343

			.L900000337:
/* 0x0b64	 320 */		cmp	%o7,0
/* 0x0b68	     */		be,pn	%icc,.L77003027
/* 0x0b6c	 319 */		add	%l6,1,%l6

! Registers live out of .L900000337: 
! o5 sp o7 l6 i3 i4 i5 fp i7 gsr 
! 
		
!  321		      !	       index[i] = ~(index[i] ^ dest[i]);

                       
! predecessor blocks: .L900000337

			.L77003025:
/* 0x0b70	 321 */		ld	[%i4],%o0
/* 0x0b74	     */		ld	[%o5],%o1
/* 0x0b78	     */		xor	%o0,%o1,%l7
/* 0x0b7c	     */		xnor	%l7,0,%i0
/* 0x0b80	     */		st	%i0,[%i4]

! Registers live out of .L77003025: 
! o5 sp o7 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003025 .L900000337

			.L77003027:
/* 0x0b84	 319 */		cmp	%l6,%i3
/* 0x0b88	     */		add	%i5,1,%i5
/* 0x0b8c	     */		add	%o5,4,%o5
/* 0x0b90	     */		add	%i4,4,%i4
/* 0x0b94	     */		ble,a,pt	%icc,.L900000337
/* 0x0b98	 320 */		ldub	[%i5],%o7

! Registers live out of .L77003027: 
! o5 sp o7 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003027

			.L77003185:
/* 0x0b9c	 319 */		ba	.L77003094
/* 0x0ba0	     */		nop

! Registers live out of .L77003185: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003116

			.L77003491:
/* 0x0ba4	 319 */		or	%g0,0,%g3

! Registers live out of .L77003491: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003188 .L77003491

			.L77003182:
/* 0x0ba8	 320 */		ldub	[%g3+%i5],%o5

! Registers live out of .L77003182: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003182 .L77003184

			.L900000336:
/* 0x0bac	 320 */		cmp	%o5,0
/* 0x0bb0	     */		be,pn	%icc,.L77003184
/* 0x0bb4	 321 */		sll	%g3,2,%i3

! Registers live out of .L900000336: 
! g1 g3 o5 sp i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000336

			.L77003183:
/* 0x0bb8	 321 */		ld	[%i4+%i3],%l1
/* 0x0bbc	     */		ld	[%i3+%l3],%o0
/* 0x0bc0	     */		xor	%l1,%o0,%o7
/* 0x0bc4	     */		xnor	%o7,0,%l7
/* 0x0bc8	     */		st	%l7,[%i4+%i3]

! Registers live out of .L77003183: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003183 .L900000336

			.L77003184:
/* 0x0bcc	 319 */		add	%g3,1,%g3
/* 0x0bd0	     */		cmp	%g3,%i1
/* 0x0bd4	     */		bcs,a,pt	%icc,.L900000336
/* 0x0bd8	 320 */		ldub	[%g3+%i5],%o5

! Registers live out of .L77003184: 
! g1 g3 o5 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003184

			.L900000315:
/* 0x0bdc	 319 */		ba	.L77003094
/* 0x0be0	     */		nop

! Registers live out of .L900000315: 
! sp fp i7 gsr 
! 
		
!  322		      !	    }
!  323		      !	 }
!  324		      !	 break;
!  325		      !      case GL_AND_REVERSE:
!  326		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003033:
/* 0x0be4	 326 */		cmp	%i1,0
/* 0x0be8	     */		bleu,pn	%icc,.L77003094
/* 0x0bec	     */		cmp	%i1,6

! Registers live out of .L77003033: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003033

			.L77003122:
/* 0x0bf0	 326 */		bl,pn	%icc,.L77003479
/* 0x0bf4	     */		add	%o7,1022,%o7

! Registers live out of .L77003122: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003122

			.L77003248:
/* 0x0bf8	 326 */		sub	%i4,%l3,%o4
/* 0x0bfc	     */		sra	%o4,31,%o3
/* 0x0c00	     */		xor	%o4,%o3,%i0
/* 0x0c04	     */		sll	%i1,2,%o2
/* 0x0c08	     */		sub	%i5,%i4,%o1
/* 0x0c0c	     */		sub	%i4,%i5,%l7
/* 0x0c10	     */		sub	%i0,%o3,%l6
/* 0x0c14	     */		sra	%o2,0,%g4
/* 0x0c18	     */		sra	%o1,0,%o0
/* 0x0c1c	     */		sra	%l7,0,%g5
/* 0x0c20	     */		sra	%i1,0,%o4
/* 0x0c24	     */		sub	%o0,%g4,%g3
/* 0x0c28	     */		sub	%g5,%o4,%o3
/* 0x0c2c	     */		srl	%i1,0,%o2
/* 0x0c30	     */		sra	%l6,0,%g2
/* 0x0c34	     */		sub	%o2,%o7,%o1
/* 0x0c38	     */		srlx	%g3,63,%l1
/* 0x0c3c	     */		srlx	%o3,63,%l5
/* 0x0c40	     */		sub	%g2,%g4,%o5
/* 0x0c44	     */		xor	%l1,1,%i3
/* 0x0c48	     */		xor	%l5,1,%l4
/* 0x0c4c	     */		srlx	%o1,63,%l2
/* 0x0c50	     */		srlx	%o5,63,%i2
/* 0x0c54	     */		or	%l4,%i3,%o0
/* 0x0c58	     */		and	%l2,1,%i0
/* 0x0c5c	     */		xor	%i2,1,%l0
/* 0x0c60	     */		and	%i0,%o0,%o7
/* 0x0c64	     */		andcc	%o7,%l0,%g0
/* 0x0c68	     */		be,a,pn	%icc,.L77003242
/* 0x0c6c	     */		or	%g0,0,%g2

! Registers live out of .L77003248: 
! g1 g2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003248

			.L77003349:
/* 0x0c70	 326 */		sethi	%hi(0x4800),%g1
/* 0x0c74	     */		add	%i1,-1,%o2
/* 0x0c78	     */		xor	%g1,-768,%g1
/* 0x0c7c	     */		or	%g0,0,%l1

!  327		      !	    if (mask[i]) {

/* 0x0c80	 327 */		ldub	[%i5],%i1
/* 0x0c84	 326 */		add	%g1,%fp,%o3

! Registers live out of .L77003349: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003041 .L77003349

			.L900000335:
/* 0x0c88	 327 */		cmp	%i1,0
/* 0x0c8c	     */		be,pn	%icc,.L77003041
/* 0x0c90	 326 */		add	%l1,1,%l1

! Registers live out of .L900000335: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		
!  328		      !	       index[i] = index[i] & ~dest[i];

                       
! predecessor blocks: .L900000335

			.L77003039:
/* 0x0c94	 328 */		ld	[%i4],%g4
/* 0x0c98	     */		ld	[%o3],%l2
/* 0x0c9c	     */		andn	%g4,%l2,%l3
/* 0x0ca0	     */		st	%l3,[%i4]

! Registers live out of .L77003039: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003039 .L900000335

			.L77003041:
/* 0x0ca4	 326 */		cmp	%l1,%o2
/* 0x0ca8	     */		add	%i5,1,%i5
/* 0x0cac	     */		add	%o3,4,%o3
/* 0x0cb0	     */		add	%i4,4,%i4
/* 0x0cb4	     */		ble,a,pt	%icc,.L900000335
/* 0x0cb8	 327 */		ldub	[%i5],%i1

! Registers live out of .L77003041: 
! o2 o3 sp l1 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003041

			.L77003245:
/* 0x0cbc	 326 */		ba	.L77003094
/* 0x0cc0	     */		nop

! Registers live out of .L77003245: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003122

			.L77003479:
/* 0x0cc4	 326 */		or	%g0,0,%g2

! Registers live out of .L77003479: 
! g1 g2 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003248 .L77003479

			.L77003242:
/* 0x0cc8	 327 */		ldub	[%g2+%i5],%l6

! Registers live out of .L77003242: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003242 .L77003244

			.L900000334:
/* 0x0ccc	 327 */		cmp	%l6,0
/* 0x0cd0	     */		be,pn	%icc,.L77003244
/* 0x0cd4	 328 */		sll	%g2,2,%g4

! Registers live out of .L900000334: 
! g1 g2 g4 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000334

			.L77003243:
/* 0x0cd8	 328 */		ld	[%i4+%g4],%l1
/* 0x0cdc	     */		ld	[%g4+%l3],%g3
/* 0x0ce0	     */		andn	%l1,%g3,%l7
/* 0x0ce4	     */		st	%l7,[%i4+%g4]

! Registers live out of .L77003243: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003243 .L900000334

			.L77003244:
/* 0x0ce8	 326 */		add	%g2,1,%g2
/* 0x0cec	     */		cmp	%g2,%i1
/* 0x0cf0	     */		bcs,a,pt	%icc,.L900000334
/* 0x0cf4	 327 */		ldub	[%g2+%i5],%l6

! Registers live out of .L77003244: 
! g1 g2 sp l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003244

			.L900000314:
/* 0x0cf8	 326 */		ba	.L77003094
/* 0x0cfc	     */		nop

! Registers live out of .L900000314: 
! sp fp i7 gsr 
! 
		
!  329		      !	    }
!  330		      !	 }
!  331		      !	 break;
!  332		      !      case GL_AND_INVERTED:
!  333		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003047:
/* 0x0d00	 333 */		cmp	%i1,0
/* 0x0d04	     */		bleu,pn	%icc,.L77003094
/* 0x0d08	     */		cmp	%i1,6

! Registers live out of .L77003047: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003047

			.L77003121:
/* 0x0d0c	 333 */		bl,pn	%icc,.L77003481
/* 0x0d10	     */		add	%o7,1022,%o1

! Registers live out of .L77003121: 
! g1 o1 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003121

			.L77003238:
/* 0x0d14	 333 */		sub	%i4,%l3,%o5
/* 0x0d18	     */		sra	%o5,31,%i2
/* 0x0d1c	     */		xor	%o5,%i2,%g5
/* 0x0d20	     */		sll	%i1,2,%o4
/* 0x0d24	     */		sub	%i5,%i4,%o3
/* 0x0d28	     */		sub	%i4,%i5,%l4
/* 0x0d2c	     */		sub	%g5,%i2,%l2
/* 0x0d30	     */		sra	%o4,0,%o7
/* 0x0d34	     */		sra	%o3,0,%o2
/* 0x0d38	     */		sra	%l4,0,%o5
/* 0x0d3c	     */		sra	%i1,0,%g2
/* 0x0d40	     */		sub	%o2,%o7,%o0
/* 0x0d44	     */		sub	%o5,%g2,%g5
/* 0x0d48	     */		srl	%i1,0,%o4
/* 0x0d4c	     */		sra	%l2,0,%g3
/* 0x0d50	     */		sub	%o4,%o1,%o3
/* 0x0d54	     */		srlx	%o0,63,%l5
/* 0x0d58	     */		srlx	%g5,63,%l1
/* 0x0d5c	     */		sub	%g3,%o7,%g4
/* 0x0d60	     */		xor	%l5,1,%i3
/* 0x0d64	     */		xor	%l1,1,%l7
/* 0x0d68	     */		srlx	%o3,63,%l6
/* 0x0d6c	     */		srlx	%g4,63,%i0
/* 0x0d70	     */		or	%l7,%i3,%i2
/* 0x0d74	     */		and	%l6,1,%o2
/* 0x0d78	     */		xor	%i0,1,%l0
/* 0x0d7c	     */		and	%o2,%i2,%o1
/* 0x0d80	     */		andcc	%o1,%l0,%g0
/* 0x0d84	     */		be,a,pn	%icc,.L77003232
/* 0x0d88	     */		or	%g0,0,%g3

! Registers live out of .L77003238: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003238

			.L77003348:
/* 0x0d8c	 333 */		sethi	%hi(0x4800),%g1
/* 0x0d90	     */		xor	%g1,-768,%g1
/* 0x0d94	     */		add	%i1,-1,%l0
/* 0x0d98	     */		or	%g0,0,%o4

!  334		      !	    if (mask[i]) {

/* 0x0d9c	 334 */		ldub	[%i5],%g2
/* 0x0da0	 333 */		add	%g1,%fp,%i2

! Registers live out of .L77003348: 
! g2 o4 sp l0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003055 .L77003348

			.L900000333:
/* 0x0da4	 334 */		cmp	%g2,0
/* 0x0da8	     */		be,pn	%icc,.L77003055
/* 0x0dac	 333 */		add	%o4,1,%o4

! Registers live out of .L900000333: 
! g2 o4 sp l0 i2 i4 i5 fp i7 gsr 
! 
		
!  335		      !	       index[i] = ~index[i] & dest[i];

                       
! predecessor blocks: .L900000333

			.L77003053:
/* 0x0db0	 335 */		ld	[%i4],%l4
/* 0x0db4	     */		ld	[%i2],%g3
/* 0x0db8	     */		andn	%g3,%l4,%g5
/* 0x0dbc	     */		st	%g5,[%i4]

! Registers live out of .L77003053: 
! g2 o4 sp l0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003053 .L900000333

			.L77003055:
/* 0x0dc0	 333 */		cmp	%o4,%l0
/* 0x0dc4	     */		add	%i5,1,%i5
/* 0x0dc8	     */		add	%i2,4,%i2
/* 0x0dcc	     */		add	%i4,4,%i4
/* 0x0dd0	     */		ble,a,pt	%icc,.L900000333
/* 0x0dd4	 334 */		ldub	[%i5],%g2

! Registers live out of .L77003055: 
! g2 o4 sp l0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003055

			.L77003235:
/* 0x0dd8	 333 */		ba	.L77003094
/* 0x0ddc	     */		nop

! Registers live out of .L77003235: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003121

			.L77003481:
/* 0x0de0	 333 */		or	%g0,0,%g3

! Registers live out of .L77003481: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003238 .L77003481

			.L77003232:
/* 0x0de4	 334 */		ldub	[%g3+%i5],%l2

! Registers live out of .L77003232: 
! g1 g3 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003232 .L77003234

			.L900000332:
/* 0x0de8	 334 */		cmp	%l2,0
/* 0x0dec	     */		be,pn	%icc,.L77003234
/* 0x0df0	 335 */		sll	%g3,2,%o7

! Registers live out of .L900000332: 
! g1 g3 sp o7 l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000332

			.L77003233:
/* 0x0df4	 335 */		ld	[%i4+%o7],%o0
/* 0x0df8	     */		ld	[%o7+%l3],%l5
/* 0x0dfc	     */		andn	%l5,%o0,%l4
/* 0x0e00	     */		st	%l4,[%i4+%o7]

! Registers live out of .L77003233: 
! g1 g3 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003233 .L900000332

			.L77003234:
/* 0x0e04	 333 */		add	%g3,1,%g3
/* 0x0e08	     */		cmp	%g3,%i1
/* 0x0e0c	     */		bcs,a,pt	%icc,.L900000332
/* 0x0e10	 334 */		ldub	[%g3+%i5],%l2

! Registers live out of .L77003234: 
! g1 g3 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003234

			.L900000313:
/* 0x0e14	 333 */		ba	.L77003094
/* 0x0e18	     */		nop

! Registers live out of .L900000313: 
! sp fp i7 gsr 
! 
		
!  336		      !	    }
!  337		      !	 }
!  338		      !	 break;
!  339		      !      case GL_OR_REVERSE:
!  340		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003061:
/* 0x0e1c	 340 */		cmp	%i1,0
/* 0x0e20	     */		bleu,pn	%icc,.L77003094
/* 0x0e24	     */		cmp	%i1,6

! Registers live out of .L77003061: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003061

			.L77003114:
/* 0x0e28	 340 */		bl,pn	%icc,.L77003495
/* 0x0e2c	     */		add	%o7,1022,%g3

! Registers live out of .L77003114: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003114

			.L77003168:
/* 0x0e30	 340 */		sub	%i4,%l3,%o0
/* 0x0e34	     */		sra	%o0,31,%i0
/* 0x0e38	     */		xor	%o0,%i0,%o7
/* 0x0e3c	     */		sll	%i1,2,%o5
/* 0x0e40	     */		sub	%i5,%i4,%l1
/* 0x0e44	     */		sub	%i4,%i5,%l6
/* 0x0e48	     */		sub	%o7,%i0,%l5
/* 0x0e4c	     */		sra	%o5,0,%g4
/* 0x0e50	     */		sra	%l1,0,%g2
/* 0x0e54	     */		sra	%l6,0,%g5
/* 0x0e58	     */		sra	%i1,0,%o1
/* 0x0e5c	     */		sub	%g2,%g4,%o4
/* 0x0e60	     */		sub	%g5,%o1,%o0
/* 0x0e64	     */		srl	%i1,0,%o7
/* 0x0e68	     */		sra	%l5,0,%o3
/* 0x0e6c	     */		sub	%o7,%g3,%o5
/* 0x0e70	     */		srlx	%o4,63,%l7
/* 0x0e74	     */		srlx	%o0,63,%l4
/* 0x0e78	     */		sub	%o3,%g4,%o2
/* 0x0e7c	     */		xor	%l7,1,%i3
/* 0x0e80	     */		xor	%l4,1,%i2
/* 0x0e84	     */		srlx	%o5,63,%l2
/* 0x0e88	     */		srlx	%o2,63,%l0
/* 0x0e8c	     */		or	%i2,%i3,%l1
/* 0x0e90	     */		and	%l2,1,%i0
/* 0x0e94	     */		xor	%l0,1,%g2
/* 0x0e98	     */		and	%i0,%l1,%g3
/* 0x0e9c	     */		andcc	%g3,%g2,%g0
/* 0x0ea0	     */		be,a,pn	%icc,.L77003162
/* 0x0ea4	     */		or	%g0,0,%o3

! Registers live out of .L77003168: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003168

			.L77003341:
/* 0x0ea8	 340 */		sethi	%hi(0x4800),%g1
/* 0x0eac	     */		xor	%g1,-768,%g1
/* 0x0eb0	     */		add	%i1,-1,%l5
/* 0x0eb4	     */		or	%g0,0,%i3

!  341		      !	    if (mask[i]) {

/* 0x0eb8	 341 */		ldub	[%i5],%o5
/* 0x0ebc	 340 */		add	%g1,%fp,%l6

! Registers live out of .L77003341: 
! o5 sp l5 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003069 .L77003341

			.L900000331:
/* 0x0ec0	 341 */		cmp	%o5,0
/* 0x0ec4	     */		be,pn	%icc,.L77003069
/* 0x0ec8	 340 */		add	%i3,1,%i3

! Registers live out of .L900000331: 
! o5 sp l5 l6 i3 i4 i5 fp i7 gsr 
! 
		
!  342		      !	       index[i] = index[i] | ~dest[i];

                       
! predecessor blocks: .L900000331

			.L77003067:
/* 0x0ecc	 342 */		ld	[%i4],%i0
/* 0x0ed0	     */		ld	[%l6],%l7
/* 0x0ed4	     */		orn	%i0,%l7,%o7
/* 0x0ed8	     */		st	%o7,[%i4]

! Registers live out of .L77003067: 
! o5 sp l5 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003067 .L900000331

			.L77003069:
/* 0x0edc	 340 */		cmp	%i3,%l5
/* 0x0ee0	     */		add	%i5,1,%i5
/* 0x0ee4	     */		add	%l6,4,%l6
/* 0x0ee8	     */		add	%i4,4,%i4
/* 0x0eec	     */		ble,a,pt	%icc,.L900000331
/* 0x0ef0	 341 */		ldub	[%i5],%o5

! Registers live out of .L77003069: 
! o5 sp l5 l6 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003069

			.L77003165:
/* 0x0ef4	 340 */		ba	.L77003094
/* 0x0ef8	     */		nop

! Registers live out of .L77003165: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003114

			.L77003495:
/* 0x0efc	 340 */		or	%g0,0,%o3

! Registers live out of .L77003495: 
! g1 o3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003168 .L77003495

			.L77003162:
/* 0x0f00	 341 */		ldub	[%o3+%i5],%l5

! Registers live out of .L77003162: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003162 .L77003164

			.L900000330:
/* 0x0f04	 341 */		cmp	%l5,0
/* 0x0f08	     */		be,pn	%icc,.L77003164
/* 0x0f0c	 342 */		sll	%o3,2,%g4

! Registers live out of .L900000330: 
! g1 g4 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000330

			.L77003163:
/* 0x0f10	 342 */		ld	[%i4+%g4],%l7
/* 0x0f14	     */		ld	[%g4+%l3],%o4
/* 0x0f18	     */		orn	%l7,%o4,%l6
/* 0x0f1c	     */		st	%l6,[%i4+%g4]

! Registers live out of .L77003163: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003163 .L900000330

			.L77003164:
/* 0x0f20	 340 */		add	%o3,1,%o3
/* 0x0f24	     */		cmp	%o3,%i1
/* 0x0f28	     */		bcs,a,pt	%icc,.L900000330
/* 0x0f2c	 341 */		ldub	[%o3+%i5],%l5

! Registers live out of .L77003164: 
! g1 o3 sp l5 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003164

			.L900000312:
/* 0x0f30	 340 */		ba	.L77003094
/* 0x0f34	     */		nop

! Registers live out of .L900000312: 
! sp fp i7 gsr 
! 
		
!  343		      !	    }
!  344		      !	 }
!  345		      !	 break;
!  346		      !      case GL_OR_INVERTED:
!  347		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000327

			.L77003075:
/* 0x0f38	 347 */		cmp	%i1,0
/* 0x0f3c	     */		bleu,pn	%icc,.L77003094
/* 0x0f40	     */		cmp	%i1,6

! Registers live out of .L77003075: 
! g1 sp o7 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003075

			.L77003112:
/* 0x0f44	 347 */		bl,pn	%icc,.L77003499
/* 0x0f48	     */		add	%o7,1022,%g3

! Registers live out of .L77003112: 
! g1 g3 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003112

			.L77003148:
/* 0x0f4c	 347 */		sub	%i4,%l3,%l0
/* 0x0f50	     */		sra	%l0,31,%o0
/* 0x0f54	     */		xor	%l0,%o0,%o1
/* 0x0f58	     */		sub	%o1,%o0,%l2
/* 0x0f5c	     */		sll	%i1,2,%o7
/* 0x0f60	     */		sub	%i5,%i4,%l4
/* 0x0f64	     */		sub	%i4,%i5,%i2
/* 0x0f68	     */		sra	%o7,0,%o4
/* 0x0f6c	     */		sra	%l4,0,%o5
/* 0x0f70	     */		sra	%i2,0,%o2
/* 0x0f74	     */		sra	%i1,0,%o1
/* 0x0f78	     */		sub	%o5,%o4,%g5
/* 0x0f7c	     */		sub	%o2,%o1,%o0
/* 0x0f80	     */		srl	%i1,0,%o7
/* 0x0f84	     */		sra	%l2,0,%g4
/* 0x0f88	     */		sub	%o7,%g3,%o5
/* 0x0f8c	     */		srlx	%g5,63,%g2
/* 0x0f90	     */		srlx	%o0,63,%l7
/* 0x0f94	     */		sub	%g4,%o4,%o3
/* 0x0f98	     */		xor	%g2,1,%i3
/* 0x0f9c	     */		xor	%l7,1,%i0
/* 0x0fa0	     */		srlx	%o5,63,%l6
/* 0x0fa4	     */		srlx	%o3,63,%l1
/* 0x0fa8	     */		or	%i0,%i3,%l5
/* 0x0fac	     */		and	%l6,1,%l4
/* 0x0fb0	     */		xor	%l1,1,%l0
/* 0x0fb4	     */		and	%l4,%l5,%g3
/* 0x0fb8	     */		andcc	%g3,%l0,%g0
/* 0x0fbc	     */		be,a,pn	%icc,.L77003142
/* 0x0fc0	     */		or	%g0,0,%g4

! Registers live out of .L77003148: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003148

			.L77003339:
/* 0x0fc4	 347 */		sethi	%hi(0x4800),%g1
/* 0x0fc8	     */		xor	%g1,-768,%g1
/* 0x0fcc	     */		add	%i1,-1,%o0
/* 0x0fd0	     */		or	%g0,0,%o1

!  348		      !	    if (mask[i]) {

/* 0x0fd4	 348 */		ldub	[%i5],%l1
/* 0x0fd8	 347 */		add	%g1,%fp,%o2

! Registers live out of .L77003339: 
! o0 o1 o2 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003083 .L77003339

			.L900000329:
/* 0x0fdc	 348 */		cmp	%l1,0
/* 0x0fe0	     */		be,pn	%icc,.L77003083
/* 0x0fe4	 347 */		add	%o1,1,%o1

! Registers live out of .L900000329: 
! o0 o1 o2 sp l1 i4 i5 fp i7 gsr 
! 
		
!  349		      !	       index[i] = ~index[i] | dest[i];

                       
! predecessor blocks: .L900000329

			.L77003081:
/* 0x0fe8	 349 */		ld	[%i4],%l3
/* 0x0fec	     */		ld	[%o2],%i1
/* 0x0ff0	     */		orn	%i1,%l3,%o3
/* 0x0ff4	     */		st	%o3,[%i4]

! Registers live out of .L77003081: 
! o0 o1 o2 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003081 .L900000329

			.L77003083:
/* 0x0ff8	 347 */		cmp	%o1,%o0
/* 0x0ffc	     */		add	%i5,1,%i5
/* 0x1000	     */		add	%o2,4,%o2
/* 0x1004	     */		add	%i4,4,%i4
/* 0x1008	     */		ble,a,pt	%icc,.L900000329
/* 0x100c	 348 */		ldub	[%i5],%l1

! Registers live out of .L77003083: 
! o0 o1 o2 sp l1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003083

			.L77003145:
/* 0x1010	 347 */		ba	.L77003094
/* 0x1014	     */		nop

! Registers live out of .L77003145: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003112

			.L77003499:
/* 0x1018	 347 */		or	%g0,0,%g4

! Registers live out of .L77003499: 
! g1 g4 sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003148 .L77003499

			.L77003142:
/* 0x101c	 348 */		ldub	[%g4+%i5],%l2

! Registers live out of .L77003142: 
! g1 g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003142 .L77003144

			.L900000328:
/* 0x1020	 348 */		cmp	%l2,0
/* 0x1024	     */		be,pn	%icc,.L77003144
/* 0x1028	 349 */		sll	%g4,2,%o4

! Registers live out of .L900000328: 
! g1 g4 o4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000328

			.L77003143:
/* 0x102c	 349 */		ld	[%i4+%o4],%g5
/* 0x1030	     */		ld	[%o4+%l3],%g2
/* 0x1034	     */		orn	%g2,%g5,%i2
/* 0x1038	     */		st	%i2,[%i4+%o4]

! Registers live out of .L77003143: 
! g1 g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003143 .L900000328

			.L77003144:
/* 0x103c	 347 */		add	%g4,1,%g4
/* 0x1040	     */		cmp	%g4,%i1
/* 0x1044	     */		bcs,a,pt	%icc,.L900000328
/* 0x1048	 348 */		ldub	[%g4+%i5],%l2

! Registers live out of .L77003144: 
! g1 g4 sp l2 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003144

			.L900000311:
/* 0x104c	 347 */		ba	.L77003094
/* 0x1050	     */		nop

! Registers live out of .L900000311: 
! sp fp i7 gsr 
! 
		
!  350		      !	    }
!  351		      !	 }
!  352		      !	 break;
!  353		      !      default:
!  354		      !	 gl_error( ctx, GL_INVALID_ENUM, "gl_logic_pixels error" );

                       
! predecessor blocks: gl_logicop_ci_pixels .L900000327

			.L77003089:
/* 0x1054	 354 */		or	%g0,1280,%o1
/* 0x1058	     */		or	%g0,%i0,%o0
/* 0x105c	     */		sethi	%hi(.L300),%i5
/* 0x1060	     */		call	gl_error	! params =  %o0 %o1 %o2	! Result = 
/* 0x1064	     */		add	%i5,%lo(.L300),%o2

! Registers live out of .L77003089: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77002877 .L77002891 .L77002907 .L77002921 .L77002935 .L77002949 .L77002963 .L77002977 .L77002991 .L77003005
! predecessor blocks: .L77003019 .L77003033 .L77003047 .L77003061 .L77003075 .L77003089 .L77003145 .L77003155 .L77003165 .L77003175 .L77003185
! predecessor blocks: .L77003195 .L77003205 .L77003215 .L77003225 .L77003235 .L77003245 .L77003255 .L77003265 .L77003275 .L77003285 .L900000311
! predecessor blocks: .L900000312 .L900000313 .L900000314 .L900000315 .L900000316 .L900000317 .L900000318 .L900000319 .L900000320 .L900000321 .L900000322
! predecessor blocks: .L900000323 .L900000324 .L900000325 .L900000327

			.L77003094:
/* 0x1068	 251 */		ret	! Result = 
/* 0x106c	     */		restore	%g0,0,%g0
/* 0x1070	   0 */		.type	gl_logicop_ci_pixels,2
/* 0x1070	   0 */		.size	gl_logicop_ci_pixels,(.-gl_logicop_ci_pixels)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000401:
/* 000000	   0 */		.word	(.L77003715-(___const_seg_900000401+0x0))
/* 0x0004	     */		.word	(.L77003787-(___const_seg_900000401+0x0))
/* 0x0008	     */		.word	(.L77003871-(___const_seg_900000401+0x0))
/* 0x000c	     */		.word	(.L77003932-(___const_seg_900000401+0x0))
/* 0x0010	     */		.word	(.L77003885-(___const_seg_900000401+0x0))
/* 0x0014	     */		.word	(.L77003759-(___const_seg_900000401+0x0))
/* 0x0018	     */		.word	(.L77003843-(___const_seg_900000401+0x0))
/* 0x001c	     */		.word	(.L77003815-(___const_seg_900000401+0x0))
/* 0x0020	     */		.word	(.L77003829-(___const_seg_900000401+0x0))
/* 0x0024	     */		.word	(.L77003857-(___const_seg_900000401+0x0))
/* 0x0028	     */		.word	(.L77003773-(___const_seg_900000401+0x0))
/* 0x002c	     */		.word	(.L77003899-(___const_seg_900000401+0x0))
/* 0x0030	     */		.word	(.L77003745-(___const_seg_900000401+0x0))
/* 0x0034	     */		.word	(.L77003913-(___const_seg_900000401+0x0))
/* 0x0038	     */		.word	(.L77003801-(___const_seg_900000401+0x0))
/* 0x003c	     */		.word	(.L77003729-(___const_seg_900000401+0x0))
/* 0x0040	   0 */		.type	___const_seg_900000401,1
/* 0x0040	   0 */		.size	___const_seg_900000401,(.-___const_seg_900000401)
/* 0x0040	   0 */		.align	4

!  355		      !   }
!  356		      !}
!  360		      !/*
!  361		      ! * Apply the current logic operator to a span of RGBA pixels.  This is only
!  362		      ! * used if the device driver can't do logic ops.
!  363		      ! */
!  364		      !void gl_logicop_rgba_span( GLcontext *ctx,
!  365		      !                           GLuint n, GLint x, GLint y,
!  366		      !                           GLubyte red[], GLubyte green[],
!  367		      !                           GLubyte blue[], GLubyte alpha[],
!  368		      !                           GLubyte mask[] )
!  369		      !{

!
! SUBROUTINE gl_logicop_rgba_span
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_logicop_rgba_span
                       

			gl_logicop_rgba_span:
/* 000000	 369 */		sethi	%hi(0x1800),%g1
/* 0x0004	     */		xor	%g1,-432,%g1
/* 0x0008	     */		save	%sp,%g1,%sp
/* 0x000c	   0 */		sethi	%hi(0x1800),%g1
/* 0x0010	   0 */		xor	%g1,-256,%g1
/* 0x0014	   0 */		add	%g1,%fp,%l0
/* 0x0018	   0 */		sethi	%hi(0x1000),%g1
/* 0x001c	   0 */		xor	%g1,-704,%g1
/* 0x0020	   0 */		add	%g1,%fp,%l1
/* 0x0024	 369 */		or	%g0,%i2,%o2
/* 0x0028	     */		or	%g0,%i3,%o3

!  370		      !   GLubyte rdest[MAX_WIDTH], gdest[MAX_WIDTH];
!  371		      !   GLubyte bdest[MAX_WIDTH], adest[MAX_WIDTH];
!  372		      !   GLuint i;
!  374		      !   /* Read span of current frame buffer pixels */
!  375		      !   gl_read_color_span( ctx, n, x, y, rdest, gdest, bdest, adest );

/* 0x002c	 375 */		add	%fp,-3200,%o5
/* 0x0030	     */		add	%fp,-1600,%o4
/* 0x0034	   0 */		add	%fp,-3200,%l6
/* 0x0038	 375 */		or	%g0,%i1,%o1

!  377		      !   /* apply logic op */
!  378		      !   switch (ctx->Color.LogicOp) {

/* 0x003c	 378 */		sethi	%hi(0x1c00),%i3
/* 0x0040	     */		sethi	%hi(0x1400),%l2
/* 0x0044	 375 */		st	%l1,[%sp+92]
/* 0x0048	     */		st	%l0,[%sp+96]
/* 0x004c	     */		call	gl_read_color_span	! params =  %o0 %o1 %o2 %o3 %o4 %o5 %sp %sp+92 %sp+96	! Result = 
/* 0x0050	     */		or	%g0,%i0,%o0
/* 0x0054	 378 */		add	%i3,716,%g2
/* 0x0058	     */		ld	[%i0+%g2],%o7
/* 0x005c	     */		add	%l2,256,%o4
/* 0x0060	     */		sub	%o7,%o4,%l5
/* 0x0064	     */		cmp	%l5,15
/* 0x0068	     */		bgu,pn	%icc,.L77003927
/* 0x006c	     */		sll	%l5,2,%i2

! Registers live out of gl_logicop_rgba_span: 
! g1 o1 sp l0 l1 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: gl_logicop_rgba_span

			.L900000465:
/* 0x0070	 378 */		sethi	%hi(___const_seg_900000401),%l7
/* 0x0074	     */		add	%l7,%lo(___const_seg_900000401),%l4
/* 0x0078	     */		ld	[%i2+%l4],%g3
/* 0x007c	     */		jmpl	%g3+%l4,%g0
/* 0x0080	     */		nop

! Registers live out of .L900000465: 
! g1 o1 sp l0 l1 l6 i0 i1 i4 i5 fp i7 gsr 
! 
		
!  379		      !      case GL_CLEAR:
!  380		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003715:
/* 0x0084	 380 */		cmp	%i1,0
/* 0x0088	     */		bleu,pn	%icc,.L77003932
/* 0x008c	     */		cmp	%i1,22

! Registers live out of .L77003715: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003715

			.L77003962:
/* 0x0090	 380 */		ld	[%fp+100],%i3
/* 0x0094	     */		bl,pn	%icc,.L77004325
/* 0x0098	     */		sub	%i5,%i4,%i0

! Registers live out of .L77003962: 
! sp i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003962

			.L77004114:
/* 0x009c	 380 */		sra	%i0,31,%i2
/* 0x00a0	     */		xor	%i0,%i2,%l4
/* 0x00a4	     */		sub	%l4,%i2,%l5
/* 0x00a8	     */		sra	%i1,0,%g2
/* 0x00ac	     */		sra	%l5,0,%o2
/* 0x00b0	     */		sub	%o2,%g2,%g3
/* 0x00b4	     */		sethi	%hi(0x7ffffc00),%o1
/* 0x00b8	     */		srlx	%g3,63,%g4
/* 0x00bc	     */		add	%o1,1022,%o4
/* 0x00c0	     */		srl	%i1,0,%o0
/* 0x00c4	     */		sub	%o0,%o4,%o3
/* 0x00c8	     */		xor	%g4,1,%g5
/* 0x00cc	     */		and	%g5,1,%l6
/* 0x00d0	     */		srlx	%o3,63,%l7
/* 0x00d4	     */		ld	[%fp+96],%i2
/* 0x00d8	     */		ld	[%fp+92],%i0
/* 0x00dc	     */		sub	%i2,%i5,%o7
/* 0x00e0	     */		sra	%o7,31,%l1
/* 0x00e4	     */		sub	%i2,%i4,%l2
/* 0x00e8	     */		xor	%o7,%l1,%o5
/* 0x00ec	     */		sra	%l2,31,%o2
/* 0x00f0	     */		sub	%o5,%l1,%g3
/* 0x00f4	     */		xor	%l2,%o2,%l0
/* 0x00f8	     */		sub	%i2,%i0,%l3
/* 0x00fc	     */		sub	%i2,%i3,%l4
/* 0x0100	     */		sub	%l0,%o2,%g4
/* 0x0104	     */		sra	%l3,31,%o1
/* 0x0108	     */		sra	%l4,31,%o0
/* 0x010c	     */		sub	%i0,%i5,%l5
/* 0x0110	     */		sub	%i0,%i4,%o5
/* 0x0114	     */		xor	%l4,%o0,%o4
/* 0x0118	     */		sra	%l5,31,%o7
/* 0x011c	     */		sra	%o5,31,%l1
/* 0x0120	     */		xor	%l3,%o1,%g5
/* 0x0124	     */		sub	%i0,%i3,%l0
/* 0x0128	     */		sub	%o4,%o0,%l4
/* 0x012c	     */		xor	%l5,%o7,%o3
/* 0x0130	     */		sra	%l0,31,%l3
/* 0x0134	     */		sub	%g5,%o1,%g5
/* 0x0138	     */		xor	%o5,%l1,%l2
/* 0x013c	     */		sub	%o3,%o7,%l5
/* 0x0140	     */		xor	%l0,%l3,%o2
/* 0x0144	     */		sub	%l2,%l1,%l2
/* 0x0148	     */		sra	%g3,0,%o1
/* 0x014c	     */		sra	%g4,0,%o0
/* 0x0150	     */		sub	%o2,%l3,%l1
/* 0x0154	     */		sub	%o1,%g2,%o4
/* 0x0158	     */		sub	%o0,%g2,%o3
/* 0x015c	     */		srlx	%o4,63,%g3
/* 0x0160	     */		srlx	%o3,63,%l0
/* 0x0164	     */		sra	%g5,0,%o7
/* 0x0168	     */		sra	%l4,0,%o2
/* 0x016c	     */		xor	%g3,1,%o1
/* 0x0170	     */		xor	%l0,1,%o4
/* 0x0174	     */		sub	%o7,%g2,%o5
/* 0x0178	     */		sub	%o2,%g2,%g4
/* 0x017c	     */		and	%o4,%o1,%o3
/* 0x0180	     */		srlx	%o5,63,%g5
/* 0x0184	     */		srlx	%g4,63,%l4
/* 0x0188	     */		sra	%l5,0,%o7
/* 0x018c	     */		xor	%g5,1,%o0
/* 0x0190	     */		sub	%o7,%g2,%o5
/* 0x0194	     */		sra	%l2,0,%g4
/* 0x0198	     */		sra	%l1,0,%o4
/* 0x019c	     */		and	%l7,%o0,%l7
/* 0x01a0	     */		srlx	%o5,63,%l5
/* 0x01a4	     */		sub	%g4,%g2,%o1
/* 0x01a8	     */		sub	%o4,%g2,%g5
/* 0x01ac	     */		and	%l7,%o3,%l0
/* 0x01b0	     */		xor	%l4,1,%l3
/* 0x01b4	     */		xor	%l5,1,%g3
/* 0x01b8	     */		srlx	%o1,63,%l2
/* 0x01bc	     */		srlx	%g5,63,%l1
/* 0x01c0	     */		and	%g3,%l3,%o2
/* 0x01c4	     */		xor	%l2,1,%o0
/* 0x01c8	     */		xor	%l1,1,%o3
/* 0x01cc	     */		and	%l0,%o2,%l4
/* 0x01d0	     */		and	%o3,%o0,%l7
/* 0x01d4	     */		and	%l4,%l7,%o7
/* 0x01d8	     */		andcc	%o7,%l6,%g0
/* 0x01dc	     */		be,a,pn	%icc,.L77004108
/* 0x01e0	     */		or	%g0,0,%l6

! Registers live out of .L77004114: 
! g2 sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004114

			.L77004115:
/* 0x01e4	 380 */		sub	%i4,%i3,%o2
/* 0x01e8	     */		sub	%i5,%i3,%g5
/* 0x01ec	     */		sra	%o2,31,%g4
/* 0x01f0	     */		sra	%g5,31,%o1
/* 0x01f4	     */		xor	%g5,%o1,%l6
/* 0x01f8	     */		xor	%o2,%g4,%g3
/* 0x01fc	     */		sub	%l6,%o1,%l3
/* 0x0200	     */		sub	%g3,%g4,%o4
/* 0x0204	     */		sra	%o4,0,%o0
/* 0x0208	     */		sra	%l3,0,%o7
/* 0x020c	     */		sub	%o0,%g2,%o3
/* 0x0210	     */		sub	%o7,%g2,%o5
/* 0x0214	     */		srlx	%o3,63,%l2
/* 0x0218	     */		srlx	%o5,63,%l1
/* 0x021c	     */		xor	%l2,1,%l7
/* 0x0220	     */		xor	%l1,1,%l0
/* 0x0224	     */		andcc	%l0,%l7,%g0
/* 0x0228	     */		be,a,pn	%icc,.L77004108
/* 0x022c	     */		or	%g0,0,%l6

! Registers live out of .L77004115: 
! sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004115

			.L77004201:
/* 0x0230	 380 */		add	%i1,-1,%l1

!  381		      !            if (mask[i]) {

/* 0x0234	 381 */		ldub	[%i3],%o3
/* 0x0238	 380 */		or	%g0,0,%o7

! Registers live out of .L77004201: 
! o3 sp o7 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003723 .L77004201

			.L900000499:
/* 0x023c	 381 */		cmp	%o3,0
/* 0x0240	     */		be,pn	%icc,.L77003723
/* 0x0244	 380 */		add	%o7,1,%o7

! Registers live out of .L900000499: 
! o3 sp o7 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  382		      !               red[i] = green[i] = blue[i] = alpha[i] = 0;

                       
! predecessor blocks: .L900000499

			.L77003721:
/* 0x0248	 382 */		stb	%g0,[%i2]
/* 0x024c	     */		stb	%g0,[%i0]
/* 0x0250	     */		stb	%g0,[%i5]
/* 0x0254	     */		stb	%g0,[%i4]

! Registers live out of .L77003721: 
! o3 sp o7 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003721 .L900000499

			.L77003723:
/* 0x0258	 380 */		cmp	%o7,%l1
/* 0x025c	     */		add	%i3,1,%i3
/* 0x0260	     */		add	%i2,1,%i2
/* 0x0264	     */		add	%i0,1,%i0
/* 0x0268	     */		add	%i5,1,%i5
/* 0x026c	     */		add	%i4,1,%i4
/* 0x0270	     */		ble,a,pt	%icc,.L900000499
/* 0x0274	 381 */		ldub	[%i3],%o3

! Registers live out of .L77003723: 
! o3 sp o7 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003723

			.L77004111:
/* 0x0278	 380 */		ba	.L77003932
/* 0x027c	     */		nop

! Registers live out of .L77004111: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003962

			.L77004325:
/* 0x0280	 380 */		ld	[%fp+92],%i0
/* 0x0284	     */		ld	[%fp+96],%i2
/* 0x0288	     */		or	%g0,0,%l6

! Registers live out of .L77004325: 
! sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004114 .L77004115 .L77004325

			.L77004108:
/* 0x028c	 381 */		ldub	[%l6+%i3],%g2

! Registers live out of .L77004108: 
! g2 sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004108 .L900000498

			.L900000497:
/* 0x0290	 381 */		cmp	%g2,0
/* 0x0294	     */		be,a,pn	%icc,.L900000498
/* 0x0298	 380 */		add	%l6,1,%l6

! Registers live out of .L900000497: 
! g2 sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000497

			.L77004109:
/* 0x029c	 382 */		stb	%g0,[%l6+%i2]
/* 0x02a0	     */		stb	%g0,[%l6+%i0]
/* 0x02a4	     */		stb	%g0,[%l6+%i5]
/* 0x02a8	     */		stb	%g0,[%l6+%i4]
/* 0x02ac	 380 */		add	%l6,1,%l6

! Registers live out of .L77004109: 
! g2 sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004109 .L900000497

			.L900000498:
/* 0x02b0	 380 */		cmp	%l6,%i1
/* 0x02b4	     */		bcs,a,pt	%icc,.L900000497
/* 0x02b8	 381 */		ldub	[%l6+%i3],%g2

! Registers live out of .L900000498: 
! g2 sp l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000498

			.L900000463:
/* 0x02bc	 380 */		ba	.L77003932
/* 0x02c0	     */		nop

! Registers live out of .L900000463: 
! sp fp i7 gsr 
! 
		
!  383		      !            }
!  384		      !         }
!  385		      !         break;
!  386		      !      case GL_SET:
!  387		      !         {
!  388		      !            GLubyte r = (GLint) ctx->Visual->RedScale;
!  389		      !            GLubyte g = (GLint) ctx->Visual->GreenScale;
!  390		      !            GLubyte b = (GLint) ctx->Visual->BlueScale;
!  391		      !            GLubyte a = (GLint) ctx->Visual->AlphaScale;
!  392		      !            for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003729:
/* 0x02c4	 392 */		cmp	%i1,0
/* 0x02c8	     */		bleu,pn	%icc,.L77003932
/* 0x02cc	 388 */		cmp	%i1,22

! Registers live out of .L77003729: 
! sp i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003729

			.L77003963:
/* 0x02d0	 388 */		ld	[%i0+2200],%l4
/* 0x02d4	     */		ld	[%fp+100],%i3
/* 0x02d8	     */		bl,pn	%icc,.L77004353
/* 0x02dc	 392 */		sub	%i4,%i5,%i0

! Registers live out of .L77003963: 
! sp l4 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003963

			.L77004125:
/* 0x02e0	 392 */		sub	%i4,%i3,%l0
/* 0x02e4	     */		sub	%i5,%i3,%l1
/* 0x02e8	     */		sra	%i0,31,%i2
/* 0x02ec	     */		sra	%l0,31,%g3
/* 0x02f0	     */		sra	%l1,31,%g5
/* 0x02f4	     */		xor	%i0,%i2,%g2
/* 0x02f8	     */		xor	%l0,%g3,%l6
/* 0x02fc	     */		xor	%l1,%g5,%o7
/* 0x0300	     */		sub	%g2,%i2,%l2
/* 0x0304	     */		sub	%l6,%g3,%o1
/* 0x0308	     */		sub	%o7,%g5,%o4
/* 0x030c	     */		sra	%i1,0,%o7
/* 0x0310	     */		sra	%l2,0,%o0
/* 0x0314	     */		sra	%o1,0,%g4
/* 0x0318	     */		sra	%o4,0,%o2
/* 0x031c	     */		sethi	%hi(0x7ffffc00),%g3
/* 0x0320	     */		sub	%o0,%o7,%o3
/* 0x0324	     */		sub	%o2,%o7,%g2
/* 0x0328	     */		add	%g3,1022,%g5
/* 0x032c	     */		srl	%i1,0,%o1
/* 0x0330	     */		sub	%o1,%g5,%o4
/* 0x0334	     */		srlx	%o3,63,%l5
/* 0x0338	     */		srlx	%g2,63,%l7
/* 0x033c	     */		xor	%l5,1,%i0
/* 0x0340	     */		srlx	%o4,63,%i2
/* 0x0344	     */		xor	%l7,1,%l6
/* 0x0348	     */		and	%i2,%i0,%l7
/* 0x034c	     */		sub	%g4,%o7,%o5
/* 0x0350	     */		srlx	%o5,63,%l3
/* 0x0354	     */		xor	%l3,1,%l5
/* 0x0358	     */		ld	[%fp+92],%i0
/* 0x035c	     */		ld	[%fp+96],%i2
/* 0x0360	     */		sub	%i4,%i0,%l0
/* 0x0364	     */		sub	%i4,%i2,%l2
/* 0x0368	     */		sra	%l0,31,%l1
/* 0x036c	     */		sra	%l2,31,%g4
/* 0x0370	     */		xor	%l0,%l1,%o0
/* 0x0374	     */		xor	%l2,%g4,%o3
/* 0x0378	     */		sub	%i5,%i0,%o5
/* 0x037c	     */		sra	%o5,31,%g2
/* 0x0380	     */		sub	%o0,%l1,%g3
/* 0x0384	     */		sub	%o3,%g4,%g4
/* 0x0388	     */		sub	%i5,%i2,%o1
/* 0x038c	     */		xor	%o5,%g2,%o2
/* 0x0390	     */		sra	%o1,31,%l1
/* 0x0394	     */		sra	%g4,0,%o0
/* 0x0398	     */		sra	%g3,0,%g3
/* 0x039c	     */		sub	%o2,%g2,%g5
/* 0x03a0	     */		xor	%o1,%l1,%l0
/* 0x03a4	     */		sub	%i0,%i2,%l3
/* 0x03a8	     */		sub	%g3,%o7,%o4
/* 0x03ac	     */		sub	%o0,%o7,%o3
/* 0x03b0	     */		sub	%l0,%l1,%l2
/* 0x03b4	     */		sra	%l3,31,%o2
/* 0x03b8	     */		srlx	%o4,63,%g2
/* 0x03bc	     */		srlx	%o3,63,%o0
/* 0x03c0	     */		xor	%l3,%o2,%o5
/* 0x03c4	     */		xor	%g2,1,%l1
/* 0x03c8	     */		xor	%o0,1,%o3
/* 0x03cc	     */		sub	%o5,%o2,%l3
/* 0x03d0	     */		and	%o3,%l1,%l0
/* 0x03d4	     */		sra	%g5,0,%o1
/* 0x03d8	     */		sub	%o1,%o7,%o4
/* 0x03dc	     */		and	%l7,%l0,%o2
/* 0x03e0	     */		srlx	%o4,63,%l7
/* 0x03e4	     */		sra	%l2,0,%g3
/* 0x03e8	     */		sra	%l3,0,%o4
/* 0x03ec	     */		sub	%g3,%o7,%g2
/* 0x03f0	     */		xor	%l7,1,%o5
/* 0x03f4	     */		srlx	%g2,63,%g4
/* 0x03f8	     */		sub	%o4,%o7,%o0
/* 0x03fc	     */		and	%o5,%l5,%l5
/* 0x0400	     */		xor	%g4,1,%g5
/* 0x0404	     */		srlx	%o0,63,%l2
/* 0x0408	     */		and	%o2,%l5,%o1
/* 0x040c	     */		and	%l6,%g5,%l6
/* 0x0410	     */		xor	%l2,1,%l3
/* 0x0414	     */		and	%o1,%l6,%l1
/* 0x0418	     */		and	%l3,1,%o3
/* 0x041c	     */		andcc	%l1,%o3,%g0
/* 0x0420	     */		be,a,pn	%icc,.L77004291
/* 0x0424	     */		or	%g0,0,%l5

! Registers live out of .L77004125: 
! sp o7 l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004125

			.L77004126:
/* 0x0428	 392 */		sub	%i2,%i3,%l0
/* 0x042c	     */		sub	%i0,%i3,%g3
/* 0x0430	     */		sra	%l0,31,%l1
/* 0x0434	     */		sra	%g3,31,%l2
/* 0x0438	     */		xor	%l0,%l1,%l6
/* 0x043c	     */		xor	%g3,%l2,%g5
/* 0x0440	     */		sub	%l6,%l1,%o1
/* 0x0444	     */		sub	%g5,%l2,%o3
/* 0x0448	     */		sra	%o1,0,%o4
/* 0x044c	     */		sra	%o3,0,%g4
/* 0x0450	     */		sub	%o4,%o7,%o0
/* 0x0454	     */		sub	%g4,%o7,%o5
/* 0x0458	     */		srlx	%o0,63,%l5
/* 0x045c	     */		srlx	%o5,63,%l3
/* 0x0460	     */		xor	%l5,1,%l7
/* 0x0464	     */		xor	%l3,1,%o2
/* 0x0468	     */		andcc	%o2,%l7,%g0
/* 0x046c	     */		be,a,pn	%icc,.L77004291
/* 0x0470	     */		or	%g0,0,%l5

! Registers live out of .L77004126: 
! sp l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004126

			.L77004187:
/* 0x0474	 388 */		ld	[%l4+4],%f26
/* 0x0478	 389 */		ld	[%l4+8],%f14
/* 0x047c	 390 */		ld	[%l4+12],%f22
/* 0x0480	 391 */		ld	[%l4+16],%f18

!  393		      !               if (mask[i]) {

/* 0x0484	 393 */		ldub	[%i3],%g4
/* 0x0488	 389 */		fstoi	%f14,%f16
/* 0x048c	     */		st	%f16,[%sp+120]
/* 0x0490	     */		ld	[%sp+120],%o0
/* 0x0494	 391 */		fstoi	%f18,%f20
/* 0x0498	     */		st	%f20,[%sp+128]
/* 0x049c	     */		ld	[%sp+128],%o2
/* 0x04a0	 390 */		fstoi	%f22,%f24
/* 0x04a4	     */		st	%f24,[%sp+124]
/* 0x04a8	 388 */		fstoi	%f26,%f28
/* 0x04ac	     */		st	%f28,[%sp+116]
/* 0x04b0	     */		ld	[%sp+116],%g5
/* 0x04b4	     */		add	%i1,-1,%l0
/* 0x04b8	 390 */		ld	[%sp+124],%o5
/* 0x04bc	 388 */		or	%g0,0,%i1

! Registers live out of .L77004187: 
! g4 g5 o0 o2 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003737 .L77004187

			.L900000496:
/* 0x04c0	 393 */		cmp	%g4,0
/* 0x04c4	     */		be,pn	%icc,.L77003737
/* 0x04c8	 392 */		add	%i1,1,%i1

! Registers live out of .L900000496: 
! g4 g5 o0 o2 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  394		      !                  red[i]   = r;

                       
! predecessor blocks: .L900000496

			.L77003735:
/* 0x04cc	 394 */		stb	%g5,[%i4]

!  395		      !                  green[i] = g;

/* 0x04d0	 395 */		stb	%o0,[%i5]

!  396		      !                  blue[i]  = b;

/* 0x04d4	 396 */		stb	%o5,[%i0]

!  397		      !                  alpha[i] = a;

/* 0x04d8	 397 */		stb	%o2,[%i2]

! Registers live out of .L77003735: 
! g4 g5 o0 o2 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003735 .L900000496

			.L77003737:
/* 0x04dc	 392 */		cmp	%i1,%l0
/* 0x04e0	     */		add	%i3,1,%i3
/* 0x04e4	     */		add	%i2,1,%i2
/* 0x04e8	     */		add	%i0,1,%i0
/* 0x04ec	     */		add	%i5,1,%i5
/* 0x04f0	     */		add	%i4,1,%i4
/* 0x04f4	     */		ble,a,pt	%icc,.L900000496
/* 0x04f8	 393 */		ldub	[%i3],%g4

! Registers live out of .L77003737: 
! g4 g5 o0 o2 o5 sp l0 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003737

			.L77004122:
/* 0x04fc	 392 */		ba	.L77003932
/* 0x0500	     */		nop

! Registers live out of .L77004122: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003963

			.L77004353:
/* 0x0504	 392 */		ld	[%fp+92],%i0
/* 0x0508	     */		ld	[%fp+96],%i2
/* 0x050c	     */		or	%g0,0,%l5

! Registers live out of .L77004353: 
! sp l4 l5 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004125 .L77004126 .L77004353

			.L77004291:
/* 0x0510	 388 */		ld	[%l4+4],%f8
/* 0x0514	 389 */		ld	[%l4+8],%f0
/* 0x0518	 390 */		ld	[%l4+12],%f2
/* 0x051c	 391 */		ld	[%l4+16],%f4
/* 0x0520	 393 */		ldub	[%l5+%i3],%o7
/* 0x0524	 389 */		fstoi	%f0,%f0
/* 0x0528	     */		st	%f0,[%sp+104]
/* 0x052c	     */		ld	[%sp+104],%l7
/* 0x0530	 391 */		fstoi	%f4,%f6
/* 0x0534	     */		st	%f6,[%sp+112]
/* 0x0538	     */		ld	[%sp+112],%l4
/* 0x053c	 390 */		fstoi	%f2,%f12
/* 0x0540	 388 */		fstoi	%f8,%f10
/* 0x0544	     */		st	%f10,[%sp+100]
/* 0x0548	 390 */		st	%f12,[%sp+108]
/* 0x054c	 388 */		ld	[%sp+100],%l0
/* 0x0550	 390 */		ld	[%sp+108],%o5

! Registers live out of .L77004291: 
! o5 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004291 .L900000494

			.L900000493:
/* 0x0554	 393 */		cmp	%o7,0
/* 0x0558	     */		be,a,pn	%icc,.L900000494
/* 0x055c	 392 */		add	%l5,1,%l5

! Registers live out of .L900000493: 
! o5 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000493

			.L77004120:
/* 0x0560	 394 */		stb	%l0,[%l5+%i4]
/* 0x0564	 395 */		stb	%l7,[%l5+%i5]
/* 0x0568	 396 */		stb	%o5,[%l5+%i0]
/* 0x056c	 397 */		stb	%l4,[%l5+%i2]
/* 0x0570	 392 */		add	%l5,1,%l5

! Registers live out of .L77004120: 
! o5 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004120 .L900000493

			.L900000494:
/* 0x0574	 392 */		cmp	%l5,%i1
/* 0x0578	     */		bcs,a,pt	%icc,.L900000493
/* 0x057c	 393 */		ldub	[%l5+%i3],%o7

! Registers live out of .L900000494: 
! o5 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000494

			.L900000462:
/* 0x0580	 392 */		ba	.L77003932
/* 0x0584	     */		nop

! Registers live out of .L900000462: 
! sp fp i7 gsr 
! 
		
!  398		      !               }
!  399		      !            }
!  400		      !         }
!  401		      !         break;
!  402		      !      case GL_COPY:
!  403		      !         /* do nothing */
!  404		      !         break;
!  405		      !      case GL_COPY_INVERTED:
!  406		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003745:
/* 0x0588	 406 */		cmp	%i1,0
/* 0x058c	     */		bleu,pn	%icc,.L77003932
/* 0x0590	     */		cmp	%i1,22

! Registers live out of .L77003745: 
! sp i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003745

			.L77003951:
/* 0x0594	 406 */		ld	[%fp+100],%i3
/* 0x0598	     */		bl,pn	%icc,.L77004347
/* 0x059c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003951: 
! sp i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003951

			.L77003983:
/* 0x05a0	 406 */		sub	%i4,%i3,%l4
/* 0x05a4	     */		sub	%i5,%i3,%l1
/* 0x05a8	     */		sra	%i0,31,%i2
/* 0x05ac	     */		sra	%l4,31,%l6
/* 0x05b0	     */		sra	%l1,31,%o3
/* 0x05b4	     */		xor	%i0,%i2,%g3
/* 0x05b8	     */		xor	%l4,%l6,%l0
/* 0x05bc	     */		xor	%l1,%o3,%g4
/* 0x05c0	     */		sub	%g3,%i2,%o7
/* 0x05c4	     */		sub	%l0,%l6,%g2
/* 0x05c8	     */		sub	%g4,%o3,%o2
/* 0x05cc	     */		sra	%i1,0,%o3
/* 0x05d0	     */		sra	%o7,0,%o1
/* 0x05d4	     */		sra	%g2,0,%o4
/* 0x05d8	     */		sethi	%hi(0x7ffffc00),%g4
/* 0x05dc	     */		sra	%o2,0,%g5
/* 0x05e0	     */		sub	%o1,%o3,%o0
/* 0x05e4	     */		add	%g4,1022,%o7
/* 0x05e8	     */		srl	%i1,0,%g2
/* 0x05ec	     */		sub	%g2,%o7,%o2
/* 0x05f0	     */		srlx	%o0,63,%l3
/* 0x05f4	     */		xor	%l3,1,%l2
/* 0x05f8	     */		srlx	%o2,63,%i0
/* 0x05fc	     */		and	%i0,%l2,%l6
/* 0x0600	     */		sub	%o4,%o3,%o5
/* 0x0604	     */		sub	%g5,%o3,%g3
/* 0x0608	     */		srlx	%o5,63,%l7
/* 0x060c	     */		srlx	%g3,63,%l5
/* 0x0610	     */		xor	%l7,1,%l4
/* 0x0614	     */		xor	%l5,1,%l5
/* 0x0618	     */		ld	[%fp+92],%i0
/* 0x061c	     */		ld	[%fp+96],%i2
/* 0x0620	     */		sub	%i4,%i0,%l0
/* 0x0624	     */		sub	%i4,%i2,%o0
/* 0x0628	     */		sub	%i5,%i0,%g5
/* 0x062c	     */		sra	%l0,31,%l1
/* 0x0630	     */		sra	%o0,31,%o5
/* 0x0634	     */		sra	%g5,31,%l3
/* 0x0638	     */		xor	%l0,%l1,%o1
/* 0x063c	     */		xor	%o0,%o5,%o4
/* 0x0640	     */		xor	%g5,%l3,%g3
/* 0x0644	     */		sub	%i5,%i2,%o7
/* 0x0648	     */		sub	%o1,%l1,%l7
/* 0x064c	     */		sub	%o4,%o5,%g4
/* 0x0650	     */		sub	%g3,%l3,%g5
/* 0x0654	     */		sra	%o7,31,%o2
/* 0x0658	     */		xor	%o7,%o2,%g2
/* 0x065c	     */		sub	%i0,%i2,%l0
/* 0x0660	     */		sra	%l7,0,%o0
/* 0x0664	     */		sra	%g4,0,%g3
/* 0x0668	     */		sub	%g2,%o2,%l2
/* 0x066c	     */		sra	%l0,31,%l1
/* 0x0670	     */		sub	%o0,%o3,%o4
/* 0x0674	     */		sub	%g3,%o3,%o7
/* 0x0678	     */		xor	%l0,%l1,%o1
/* 0x067c	     */		srlx	%o4,63,%o5
/* 0x0680	     */		srlx	%o7,63,%g2
/* 0x0684	     */		sub	%o1,%l1,%l3
/* 0x0688	     */		xor	%o5,1,%o2
/* 0x068c	     */		xor	%g2,1,%l0
/* 0x0690	     */		and	%l0,%o2,%l1
/* 0x0694	     */		sra	%g5,0,%o1
/* 0x0698	     */		and	%l6,%l1,%o4
/* 0x069c	     */		sub	%o1,%o3,%o0
/* 0x06a0	     */		sra	%l2,0,%o5
/* 0x06a4	     */		srlx	%o0,63,%l6
/* 0x06a8	     */		sub	%o5,%o3,%g4
/* 0x06ac	     */		sra	%l3,0,%g5
/* 0x06b0	     */		xor	%l6,1,%l7
/* 0x06b4	     */		srlx	%g4,63,%g3
/* 0x06b8	     */		sub	%g5,%o3,%o2
/* 0x06bc	     */		and	%l7,%l4,%l4
/* 0x06c0	     */		xor	%g3,1,%o7
/* 0x06c4	     */		srlx	%o2,63,%l0
/* 0x06c8	     */		and	%o4,%l4,%g2
/* 0x06cc	     */		and	%l5,%o7,%l5
/* 0x06d0	     */		xor	%l0,1,%l2
/* 0x06d4	     */		and	%g2,%l5,%o0
/* 0x06d8	     */		and	%l2,1,%o1
/* 0x06dc	     */		andcc	%o0,%o1,%g0
/* 0x06e0	     */		be,a,pn	%icc,.L77003977
/* 0x06e4	     */		or	%g0,0,%l1

! Registers live out of .L77003983: 
! o3 sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003983

			.L77003984:
/* 0x06e8	 406 */		sub	%i2,%i3,%l0
/* 0x06ec	     */		sub	%i0,%i3,%g4
/* 0x06f0	     */		sra	%l0,31,%l1
/* 0x06f4	     */		sra	%g4,31,%g2
/* 0x06f8	     */		xor	%l0,%l1,%l6
/* 0x06fc	     */		xor	%g4,%g2,%o7
/* 0x0700	     */		sub	%l6,%l1,%o2
/* 0x0704	     */		sub	%o7,%g2,%l7
/* 0x0708	     */		sra	%o2,0,%g5
/* 0x070c	     */		sra	%l7,0,%o0
/* 0x0710	     */		sub	%g5,%o3,%o1
/* 0x0714	     */		sub	%o0,%o3,%o4
/* 0x0718	     */		srlx	%o1,63,%l3
/* 0x071c	     */		srlx	%o4,63,%l5
/* 0x0720	     */		xor	%l3,1,%l2
/* 0x0724	     */		xor	%l5,1,%o5
/* 0x0728	     */		andcc	%o5,%l2,%g0
/* 0x072c	     */		be,a,pn	%icc,.L77003977
/* 0x0730	     */		or	%g0,0,%l1

! Registers live out of .L77003984: 
! sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003984

			.L77004190:
/* 0x0734	 406 */		add	%i1,-1,%l4

!  407		      !            if (mask[i]) {

/* 0x0738	 407 */		ldub	[%i3],%g3
/* 0x073c	 406 */		or	%g0,0,%l3

! Registers live out of .L77004190: 
! g3 sp l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003753 .L77004190

			.L900000492:
/* 0x0740	 407 */		cmp	%g3,0
/* 0x0744	     */		be,pn	%icc,.L77003753
/* 0x0748	 406 */		add	%l3,1,%l3

! Registers live out of .L900000492: 
! g3 sp l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  408		      !               red[i]   = ~red[i];

                       
! predecessor blocks: .L900000492

			.L77003751:
/* 0x074c	 408 */		ldub	[%i4],%o7

!  409		      !               green[i] = ~green[i];

/* 0x0750	 409 */		ldub	[%i5],%l5

!  410		      !               blue[i]  = ~blue[i];

/* 0x0754	 410 */		ldub	[%i0],%o4

!  411		      !               alpha[i] = ~alpha[i];

/* 0x0758	 411 */		ldub	[%i2],%l2
/* 0x075c	 408 */		xnor	%o7,0,%o1
/* 0x0760	     */		stb	%o1,[%i4]
/* 0x0764	 409 */		xnor	%l5,0,%l6
/* 0x0768	     */		stb	%l6,[%i5]
/* 0x076c	 410 */		xnor	%o4,0,%l7
/* 0x0770	     */		stb	%l7,[%i0]
/* 0x0774	 411 */		xnor	%l2,0,%g2
/* 0x0778	     */		stb	%g2,[%i2]

! Registers live out of .L77003751: 
! g3 sp l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003751 .L900000492

			.L77003753:
/* 0x077c	 406 */		cmp	%l3,%l4
/* 0x0780	     */		add	%i3,1,%i3
/* 0x0784	     */		add	%i2,1,%i2
/* 0x0788	     */		add	%i0,1,%i0
/* 0x078c	     */		add	%i5,1,%i5
/* 0x0790	     */		add	%i4,1,%i4
/* 0x0794	     */		ble,a,pt	%icc,.L900000492
/* 0x0798	 407 */		ldub	[%i3],%g3

! Registers live out of .L77003753: 
! g3 sp l4 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003753

			.L77003980:
/* 0x079c	 406 */		ba	.L77003932
/* 0x07a0	     */		nop

! Registers live out of .L77003980: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003951

			.L77004347:
/* 0x07a4	 406 */		ld	[%fp+92],%i0
/* 0x07a8	     */		ld	[%fp+96],%i2
/* 0x07ac	     */		or	%g0,0,%l1

! Registers live out of .L77004347: 
! sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003983 .L77003984 .L77004347

			.L77003977:
/* 0x07b0	 407 */		ldub	[%l1+%i3],%g3

! Registers live out of .L77003977: 
! g3 sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003977 .L900000491

			.L900000490:
/* 0x07b4	 407 */		cmp	%g3,0
/* 0x07b8	     */		be,a,pn	%icc,.L900000491
/* 0x07bc	 406 */		add	%l1,1,%l1

! Registers live out of .L900000490: 
! g3 sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000490

			.L77003978:
/* 0x07c0	 408 */		ldub	[%i4+%l1],%o3
/* 0x07c4	     */		xnor	%o3,0,%l3
/* 0x07c8	     */		stb	%l3,[%i4+%l1]
/* 0x07cc	 409 */		ldub	[%i5+%l1],%l6
/* 0x07d0	     */		xnor	%l6,0,%l7
/* 0x07d4	     */		stb	%l7,[%i5+%l1]
/* 0x07d8	 410 */		ldub	[%l1+%i0],%l4
/* 0x07dc	     */		xnor	%l4,0,%o4
/* 0x07e0	     */		stb	%o4,[%l1+%i0]
/* 0x07e4	 411 */		ldub	[%l1+%i2],%o5
/* 0x07e8	     */		xnor	%o5,0,%g4
/* 0x07ec	     */		stb	%g4,[%l1+%i2]
/* 0x07f0	 406 */		add	%l1,1,%l1

! Registers live out of .L77003978: 
! g3 sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003978 .L900000490

			.L900000491:
/* 0x07f4	 406 */		cmp	%l1,%i1
/* 0x07f8	     */		bcs,a,pt	%icc,.L900000490
/* 0x07fc	 407 */		ldub	[%l1+%i3],%g3

! Registers live out of .L900000491: 
! g3 sp l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000491

			.L900000461:
/* 0x0800	 406 */		ba	.L77003932
/* 0x0804	     */		nop

! Registers live out of .L900000461: 
! sp fp i7 gsr 
! 
		
!  412		      !            }
!  413		      !         }
!  414		      !         break;
!  415		      !      case GL_NOOP:
!  416		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003759:
/* 0x0808	 416 */		cmp	%i1,0
/* 0x080c	     */		bleu,pn	%icc,.L77003932
/* 0x0810	     */		cmp	%i1,54

! Registers live out of .L77003759: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003759

			.L77003958:
/* 0x0814	 416 */		ld	[%fp+100],%i3
/* 0x0818	     */		bl,pn	%icc,.L77004333
/* 0x081c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003958: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003958

			.L77004066:
/* 0x0820	 416 */		sra	%i0,31,%o1
/* 0x0824	     */		add	%fp,-1600,%l7
/* 0x0828	     */		sub	%i4,%l7,%o0
/* 0x082c	     */		xor	%i0,%o1,%i2
/* 0x0830	     */		sub	%i4,%l0,%g5
/* 0x0834	     */		sub	%i2,%o1,%l7
/* 0x0838	     */		sra	%o0,31,%g2
/* 0x083c	     */		sra	%g5,31,%o3
/* 0x0840	     */		sub	%i4,%i3,%i0
/* 0x0844	     */		xor	%o0,%g2,%o4
/* 0x0848	     */		xor	%g5,%o3,%o5
/* 0x084c	     */		sra	%i0,31,%i2
/* 0x0850	     */		sub	%o5,%o3,%o0
/* 0x0854	     */		xor	%i0,%i2,%o1
/* 0x0858	     */		sub	%o1,%i2,%o5
/* 0x085c	     */		sub	%i4,%l6,%o2
/* 0x0860	     */		sub	%i4,%l1,%l5
/* 0x0864	     */		sra	%o2,31,%g4
/* 0x0868	     */		sra	%l5,31,%o7
/* 0x086c	     */		xor	%o2,%g4,%l2
/* 0x0870	     */		xor	%l5,%o7,%l3
/* 0x0874	     */		sub	%l3,%o7,%o2
/* 0x0878	     */		sub	%o4,%g2,%l4
/* 0x087c	     */		sub	%l2,%g4,%g3
/* 0x0880	     */		sra	%l7,0,%g2
/* 0x0884	     */		sra	%l4,0,%o7
/* 0x0888	     */		sra	%o2,0,%g5
/* 0x088c	     */		sra	%g3,0,%g3
/* 0x0890	     */		sra	%o5,0,%o5
/* 0x0894	     */		ld	[%fp+96],%i2
/* 0x0898	     */		ld	[%fp+92],%i0
/* 0x089c	     */		sub	%i4,%i2,%o3
/* 0x08a0	     */		sra	%o3,31,%l3
/* 0x08a4	     */		xor	%o3,%l3,%o1
/* 0x08a8	     */		sub	%i4,%i0,%l2
/* 0x08ac	     */		sra	%l2,31,%o4
/* 0x08b0	     */		sub	%o1,%l3,%l7
/* 0x08b4	     */		sra	%i1,0,%o1
/* 0x08b8	     */		xor	%l2,%o4,%g4
/* 0x08bc	     */		sra	%o0,0,%o3
/* 0x08c0	     */		sub	%g4,%o4,%l5
/* 0x08c4	     */		sub	%g2,%o1,%o0
/* 0x08c8	     */		sub	%o7,%o1,%o2
/* 0x08cc	     */		sra	%l5,0,%g4
/* 0x08d0	     */		sra	%l7,0,%o4
/* 0x08d4	     */		srlx	%o0,63,%l4
/* 0x08d8	     */		srlx	%o2,63,%l2
/* 0x08dc	     */		sub	%g3,%o1,%g2
/* 0x08e0	     */		sub	%o3,%o1,%o7
/* 0x08e4	     */		sub	%o4,%o1,%o2
/* 0x08e8	     */		sub	%g5,%o1,%o0
/* 0x08ec	     */		sub	%g4,%o1,%g3
/* 0x08f0	     */		srlx	%o7,63,%g4
/* 0x08f4	     */		sub	%o5,%o1,%o4
/* 0x08f8	     */		srlx	%g2,63,%g2
/* 0x08fc	     */		srlx	%o0,63,%o0
/* 0x0900	     */		srlx	%g3,63,%g3
/* 0x0904	     */		srlx	%o2,63,%g5
/* 0x0908	     */		xor	%g2,1,%o7
/* 0x090c	     */		xor	%o0,1,%o5
/* 0x0910	     */		xor	%g3,1,%o3
/* 0x0914	     */		xor	%l4,1,%o2
/* 0x0918	     */		and	%o3,%o5,%l7
/* 0x091c	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x0920	     */		and	%o2,%o7,%l4
/* 0x0924	     */		add	%g2,1022,%o3
/* 0x0928	     */		srl	%i1,0,%g3
/* 0x092c	     */		sub	%g3,%o3,%o2
/* 0x0930	     */		xor	%l2,1,%l5
/* 0x0934	     */		srlx	%o2,63,%o0
/* 0x0938	     */		and	%o0,%l5,%g3
/* 0x093c	     */		xor	%g5,1,%l3
/* 0x0940	     */		xor	%g4,1,%o7
/* 0x0944	     */		srlx	%o4,63,%l2
/* 0x0948	     */		and	%g3,%l4,%o5
/* 0x094c	     */		and	%l3,%o7,%g5
/* 0x0950	     */		xor	%l2,1,%o4
/* 0x0954	     */		and	%o5,%l7,%o3
/* 0x0958	     */		and	%o4,1,%g4
/* 0x095c	     */		and	%o3,%g5,%o7
/* 0x0960	     */		andcc	%o7,%g4,%g0
/* 0x0964	     */		be,a,pn	%icc,.L77004060
/* 0x0968	     */		or	%g0,0,%l3

! Registers live out of .L77004066: 
! g1 o1 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004066

			.L77004067:
/* 0x096c	 416 */		sub	%i5,%i0,%o0
/* 0x0970	     */		sra	%o0,31,%l4
/* 0x0974	     */		xor	%o0,%l4,%o5
/* 0x0978	     */		add	%fp,-1600,%l2
/* 0x097c	     */		sub	%i5,%l2,%o4
/* 0x0980	     */		sub	%o5,%l4,%g2
/* 0x0984	     */		sub	%i5,%l1,%l5
/* 0x0988	     */		sra	%l5,31,%o7
/* 0x098c	     */		sra	%o4,31,%l4
/* 0x0990	     */		sub	%i5,%l6,%l7
/* 0x0994	     */		xor	%l5,%o7,%l3
/* 0x0998	     */		sra	%l7,31,%o0
/* 0x099c	     */		xor	%o4,%l4,%o5
/* 0x09a0	     */		sub	%i5,%i2,%g3
/* 0x09a4	     */		sub	%l3,%o7,%g5
/* 0x09a8	     */		sub	%i0,%l2,%o4
/* 0x09ac	     */		sra	%g3,31,%l5
/* 0x09b0	     */		sub	%i5,%l0,%o3
/* 0x09b4	     */		xor	%l7,%o0,%o2
/* 0x09b8	     */		xor	%g3,%l5,%l2
/* 0x09bc	     */		sra	%o3,31,%l3
/* 0x09c0	     */		sub	%o2,%o0,%o2
/* 0x09c4	     */		xor	%o3,%l3,%o7
/* 0x09c8	     */		sub	%i5,%i3,%o0
/* 0x09cc	     */		sub	%l2,%l5,%g3
/* 0x09d0	     */		sub	%o7,%l3,%l7
/* 0x09d4	     */		sra	%o0,31,%l2
/* 0x09d8	     */		sub	%o5,%l4,%g4
/* 0x09dc	     */		xor	%o0,%l2,%l4
/* 0x09e0	     */		sra	%o4,31,%l3
/* 0x09e4	     */		sub	%l4,%l2,%l5
/* 0x09e8	     */		xor	%o4,%l3,%o7
/* 0x09ec	     */		sub	%o7,%l3,%l2
/* 0x09f0	     */		sub	%i0,%l6,%o5
/* 0x09f4	     */		sub	%i0,%l1,%o3
/* 0x09f8	     */		sra	%o5,31,%o4
/* 0x09fc	     */		sra	%o3,31,%o7
/* 0x0a00	     */		xor	%o5,%o4,%o0
/* 0x0a04	     */		xor	%o3,%o7,%l4
/* 0x0a08	     */		sub	%o0,%o4,%l3
/* 0x0a0c	     */		sub	%l4,%o7,%l4
/* 0x0a10	     */		sra	%g2,0,%o0
/* 0x0a14	     */		sra	%g5,0,%o7
/* 0x0a18	     */		sub	%o7,%o1,%o4
/* 0x0a1c	     */		sub	%o0,%o1,%g2
/* 0x0a20	     */		srlx	%o4,63,%g5
/* 0x0a24	     */		srlx	%g2,63,%g2
/* 0x0a28	     */		xor	%g2,1,%o3
/* 0x0a2c	     */		xor	%g5,1,%o5
/* 0x0a30	     */		and	%o3,%o5,%o0
/* 0x0a34	     */		sra	%o2,0,%o2
/* 0x0a38	     */		sra	%g4,0,%g4
/* 0x0a3c	     */		sub	%o2,%o1,%o3
/* 0x0a40	     */		sub	%g4,%o1,%o5
/* 0x0a44	     */		srlx	%o3,63,%o2
/* 0x0a48	     */		srlx	%o5,63,%g4
/* 0x0a4c	     */		xor	%o2,1,%o4
/* 0x0a50	     */		xor	%g4,1,%o7
/* 0x0a54	     */		and	%o7,%o4,%g2
/* 0x0a58	     */		and	%g2,%o0,%o3
/* 0x0a5c	     */		sra	%l7,0,%o0
/* 0x0a60	     */		sra	%g3,0,%g3
/* 0x0a64	     */		sub	%g3,%o1,%g5
/* 0x0a68	     */		sub	%o0,%o1,%g2
/* 0x0a6c	     */		srlx	%g5,63,%g3
/* 0x0a70	     */		srlx	%g2,63,%l7
/* 0x0a74	     */		xor	%g3,1,%o5
/* 0x0a78	     */		xor	%l7,1,%g5
/* 0x0a7c	     */		and	%o5,%g5,%o2
/* 0x0a80	     */		and	%o3,%o2,%g2
/* 0x0a84	     */		sra	%l5,0,%o7
/* 0x0a88	     */		sra	%l2,0,%o2
/* 0x0a8c	     */		sub	%o7,%o1,%o4
/* 0x0a90	     */		sub	%o2,%o1,%o3
/* 0x0a94	     */		srlx	%o4,63,%l5
/* 0x0a98	     */		srlx	%o3,63,%l2
/* 0x0a9c	     */		xor	%l2,1,%o0
/* 0x0aa0	     */		xor	%l5,1,%g4
/* 0x0aa4	     */		and	%o0,%g4,%o4
/* 0x0aa8	     */		sra	%l3,0,%o0
/* 0x0aac	     */		sra	%l4,0,%o7
/* 0x0ab0	     */		sub	%o0,%o1,%g5
/* 0x0ab4	     */		sub	%o7,%o1,%g3
/* 0x0ab8	     */		srlx	%g5,63,%l3
/* 0x0abc	     */		srlx	%g3,63,%l4
/* 0x0ac0	     */		xor	%l3,1,%l7
/* 0x0ac4	     */		xor	%l4,1,%g5
/* 0x0ac8	     */		and	%g2,%o4,%o3
/* 0x0acc	     */		and	%g5,%l7,%o5
/* 0x0ad0	     */		andcc	%o3,%o5,%g0
/* 0x0ad4	     */		be,a,pn	%icc,.L77004060
/* 0x0ad8	     */		or	%g0,0,%l3

! Registers live out of .L77004067: 
! g1 o1 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004067

			.L77004068:
/* 0x0adc	 416 */		add	%fp,-1600,%o5
/* 0x0ae0	     */		sub	%i2,%o5,%g5
/* 0x0ae4	     */		sra	%g5,31,%o2
/* 0x0ae8	     */		sub	%i0,%i3,%o0
/* 0x0aec	     */		sub	%i0,%i2,%l7
/* 0x0af0	     */		sra	%o0,31,%o7
/* 0x0af4	     */		xor	%g5,%o2,%l2
/* 0x0af8	     */		sra	%l7,31,%o3
/* 0x0afc	     */		xor	%o0,%o7,%o5
/* 0x0b00	     */		sub	%l2,%o2,%l5
/* 0x0b04	     */		xor	%l7,%o3,%o4
/* 0x0b08	     */		sub	%i0,%l0,%g2
/* 0x0b0c	     */		sub	%o5,%o7,%l4
/* 0x0b10	     */		sra	%g2,31,%o0
/* 0x0b14	     */		sub	%i2,%l6,%g3
/* 0x0b18	     */		sub	%o4,%o3,%o2
/* 0x0b1c	     */		xor	%g2,%o0,%o3
/* 0x0b20	     */		sra	%g3,31,%o7
/* 0x0b24	     */		xor	%g3,%o7,%o5
/* 0x0b28	     */		sub	%o3,%o0,%g5
/* 0x0b2c	     */		sub	%i2,%i3,%g2
/* 0x0b30	     */		sub	%i2,%l0,%o3
/* 0x0b34	     */		sub	%o5,%o7,%g3
/* 0x0b38	     */		sra	%g2,31,%l3
/* 0x0b3c	     */		xor	%g2,%l3,%l2
/* 0x0b40	     */		sra	%o3,31,%o5
/* 0x0b44	     */		sub	%i2,%l1,%g4
/* 0x0b48	     */		sra	%g4,31,%o4
/* 0x0b4c	     */		xor	%o3,%o5,%o0
/* 0x0b50	     */		sub	%l2,%l3,%l3
/* 0x0b54	     */		sub	%o0,%o5,%l2
/* 0x0b58	     */		xor	%g4,%o4,%g4
/* 0x0b5c	     */		sub	%g4,%o4,%l7
/* 0x0b60	     */		sra	%l4,0,%o0
/* 0x0b64	     */		sra	%l5,0,%o7
/* 0x0b68	     */		sra	%o2,0,%o2
/* 0x0b6c	     */		sra	%g5,0,%g5
/* 0x0b70	     */		sub	%o0,%o1,%o5
/* 0x0b74	     */		sub	%o7,%o1,%o4
/* 0x0b78	     */		sub	%o2,%o1,%o3
/* 0x0b7c	     */		sub	%g5,%o1,%g2
/* 0x0b80	     */		srlx	%o5,63,%l4
/* 0x0b84	     */		srlx	%o4,63,%l5
/* 0x0b88	     */		srlx	%o3,63,%o2
/* 0x0b8c	     */		srlx	%g2,63,%g5
/* 0x0b90	     */		xor	%l4,1,%g4
/* 0x0b94	     */		xor	%l5,1,%o7
/* 0x0b98	     */		xor	%o2,1,%o4
/* 0x0b9c	     */		xor	%g5,1,%g2
/* 0x0ba0	     */		and	%o7,%g4,%o0
/* 0x0ba4	     */		and	%g2,%o4,%o3
/* 0x0ba8	     */		and	%o3,%o0,%g4
/* 0x0bac	     */		sra	%l7,0,%o5
/* 0x0bb0	     */		sra	%g3,0,%g3
/* 0x0bb4	     */		sub	%o5,%o1,%o7
/* 0x0bb8	     */		sub	%g3,%o1,%o0
/* 0x0bbc	     */		srlx	%o7,63,%l7
/* 0x0bc0	     */		srlx	%o0,63,%g3
/* 0x0bc4	     */		xor	%g3,1,%l5
/* 0x0bc8	     */		xor	%l7,1,%o5
/* 0x0bcc	     */		and	%o5,%l5,%l4
/* 0x0bd0	     */		and	%g4,%l4,%g2
/* 0x0bd4	     */		sra	%l3,0,%g4
/* 0x0bd8	     */		sub	%g4,%o1,%o4
/* 0x0bdc	     */		sra	%l2,0,%o7
/* 0x0be0	     */		sub	%o7,%o1,%o1
/* 0x0be4	     */		srlx	%o4,63,%l3
/* 0x0be8	     */		srlx	%o1,63,%l2
/* 0x0bec	     */		xor	%l3,1,%g5
/* 0x0bf0	     */		xor	%l2,1,%o2
/* 0x0bf4	     */		and	%g5,%o2,%o4
/* 0x0bf8	     */		andcc	%g2,%o4,%g0
/* 0x0bfc	     */		be,a,pn	%icc,.L77004060
/* 0x0c00	     */		or	%g0,0,%l3

! Registers live out of .L77004068: 
! g1 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004068

			.L77004197:
/* 0x0c04	 416 */		sethi	%hi(0x1000),%g1
/* 0x0c08	     */		xor	%g1,-704,%g1
/* 0x0c0c	     */		add	%g1,%fp,%o2
/* 0x0c10	     */		sethi	%hi(0x1800),%g1
/* 0x0c14	     */		add	%i1,-1,%o3
/* 0x0c18	     */		xor	%g1,-256,%g1
/* 0x0c1c	     */		or	%g0,0,%l1
/* 0x0c20	     */		add	%fp,-1600,%l0
/* 0x0c24	     */		add	%fp,-3200,%i1

!  417		      !            if (mask[i]) {

/* 0x0c28	 417 */		ldub	[%i3],%o0
/* 0x0c2c	 416 */		add	%g1,%fp,%o5

! Registers live out of .L77004197: 
! o0 o2 o3 o5 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003767 .L77004197

			.L900000489:
/* 0x0c30	 417 */		cmp	%o0,0
/* 0x0c34	     */		be,pn	%icc,.L77003767
/* 0x0c38	 416 */		add	%l1,1,%l1

! Registers live out of .L900000489: 
! o0 o2 o3 o5 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  418		      !               red[i]   = rdest[i];

                       
! predecessor blocks: .L900000489

			.L77003765:
/* 0x0c3c	 418 */		ldub	[%l0],%g2
/* 0x0c40	     */		stb	%g2,[%i4]

!  419		      !               green[i] = gdest[i];

/* 0x0c44	 419 */		ldub	[%i1],%g3
/* 0x0c48	     */		stb	%g3,[%i5]

!  420		      !               blue[i]  = bdest[i];

/* 0x0c4c	 420 */		ldub	[%o2],%g4
/* 0x0c50	     */		stb	%g4,[%i0]

!  421		      !               alpha[i] = adest[i];

/* 0x0c54	 421 */		ldub	[%o5],%g5
/* 0x0c58	     */		stb	%g5,[%i2]

! Registers live out of .L77003765: 
! o0 o2 o3 o5 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003765 .L900000489

			.L77003767:
/* 0x0c5c	 416 */		cmp	%l1,%o3
/* 0x0c60	     */		add	%i3,1,%i3
/* 0x0c64	     */		add	%o5,1,%o5
/* 0x0c68	     */		add	%o2,1,%o2
/* 0x0c6c	     */		add	%i1,1,%i1
/* 0x0c70	     */		add	%l0,1,%l0
/* 0x0c74	     */		add	%i2,1,%i2
/* 0x0c78	     */		add	%i0,1,%i0
/* 0x0c7c	     */		add	%i5,1,%i5
/* 0x0c80	     */		add	%i4,1,%i4
/* 0x0c84	     */		ble,a,pt	%icc,.L900000489
/* 0x0c88	 417 */		ldub	[%i3],%o0

! Registers live out of .L77003767: 
! o0 o2 o3 o5 sp l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003767

			.L77004063:
/* 0x0c8c	 416 */		ba	.L77003932
/* 0x0c90	     */		nop

! Registers live out of .L77004063: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003958

			.L77004333:
/* 0x0c94	 416 */		ld	[%fp+92],%i0
/* 0x0c98	     */		ld	[%fp+96],%i2
/* 0x0c9c	     */		or	%g0,0,%l3

! Registers live out of .L77004333: 
! g1 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004066 .L77004067 .L77004068 .L77004333

			.L77004060:
/* 0x0ca0	 417 */		ldub	[%l3+%i3],%l5

! Registers live out of .L77004060: 
! g1 sp l0 l1 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004060 .L77004062

			.L900000488:
/* 0x0ca4	 417 */		cmp	%l5,0
/* 0x0ca8	     */		be,pn	%icc,.L77004062
/* 0x0cac	 418 */		add	%fp,-1600,%l4

! Registers live out of .L900000488: 
! g1 sp l0 l1 l4 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000488

			.L77004061:
/* 0x0cb0	 418 */		ldub	[%l3+%l4],%o1
/* 0x0cb4	     */		stb	%o1,[%l3+%i4]
/* 0x0cb8	 419 */		ldub	[%l3+%l6],%g2
/* 0x0cbc	     */		stb	%g2,[%l3+%i5]
/* 0x0cc0	 420 */		ldub	[%l3+%l1],%o2
/* 0x0cc4	     */		stb	%o2,[%l3+%i0]
/* 0x0cc8	 421 */		ldub	[%l3+%l0],%l4
/* 0x0ccc	     */		stb	%l4,[%l3+%i2]

! Registers live out of .L77004061: 
! g1 sp l0 l1 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004061 .L900000488

			.L77004062:
/* 0x0cd0	 416 */		add	%l3,1,%l3
/* 0x0cd4	     */		cmp	%l3,%i1
/* 0x0cd8	     */		bcs,a,pn	%icc,.L900000488
/* 0x0cdc	 417 */		ldub	[%l3+%i3],%l5

! Registers live out of .L77004062: 
! g1 sp l0 l1 l5 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004062

			.L900000460:
/* 0x0ce0	 416 */		ba	.L77003932
/* 0x0ce4	     */		nop

! Registers live out of .L900000460: 
! sp fp i7 gsr 
! 
		
!  422		      !            }
!  423		      !         }
!  424		      !         break;
!  425		      !      case GL_INVERT:
!  426		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003773:
/* 0x0ce8	 426 */		cmp	%i1,0
/* 0x0cec	     */		bleu,pn	%icc,.L77003932
/* 0x0cf0	     */		cmp	%i1,54

! Registers live out of .L77003773: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003773

			.L77003953:
/* 0x0cf4	 426 */		ld	[%fp+100],%i3
/* 0x0cf8	     */		bl,pn	%icc,.L77004343
/* 0x0cfc	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003953: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003953

			.L77004006:
/* 0x0d00	 426 */		add	%fp,-1600,%o7
/* 0x0d04	     */		sub	%i4,%o7,%o1
/* 0x0d08	     */		sra	%i0,31,%o7
/* 0x0d0c	     */		xor	%i0,%o7,%i2
/* 0x0d10	     */		sra	%o1,31,%o0
/* 0x0d14	     */		sub	%i4,%l0,%g5
/* 0x0d18	     */		sub	%i2,%o7,%l7
/* 0x0d1c	     */		xor	%o1,%o0,%o4
/* 0x0d20	     */		sra	%g5,31,%o2
/* 0x0d24	     */		sub	%i4,%i3,%i0
/* 0x0d28	     */		sub	%o4,%o0,%l4
/* 0x0d2c	     */		xor	%g5,%o2,%o5
/* 0x0d30	     */		sra	%i0,31,%i2
/* 0x0d34	     */		sub	%o5,%o2,%o0
/* 0x0d38	     */		xor	%i0,%i2,%o7
/* 0x0d3c	     */		sub	%o7,%i2,%o5
/* 0x0d40	     */		sub	%i4,%l6,%o3
/* 0x0d44	     */		sub	%i4,%l1,%l5
/* 0x0d48	     */		sra	%o3,31,%g4
/* 0x0d4c	     */		sra	%l5,31,%g2
/* 0x0d50	     */		xor	%o3,%g4,%l2
/* 0x0d54	     */		xor	%l5,%g2,%l3
/* 0x0d58	     */		sub	%l3,%g2,%o3
/* 0x0d5c	     */		sra	%l7,0,%g2
/* 0x0d60	     */		sub	%l2,%g4,%g3
/* 0x0d64	     */		sra	%l4,0,%g4
/* 0x0d68	     */		sra	%o3,0,%g5
/* 0x0d6c	     */		sra	%o5,0,%o3
/* 0x0d70	     */		sra	%g3,0,%g3
/* 0x0d74	     */		ld	[%fp+96],%i2
/* 0x0d78	     */		ld	[%fp+92],%i0
/* 0x0d7c	     */		sub	%i4,%i2,%o2
/* 0x0d80	     */		sra	%o2,31,%l3
/* 0x0d84	     */		xor	%o2,%l3,%o7
/* 0x0d88	     */		sub	%o7,%l3,%l7
/* 0x0d8c	     */		sra	%i1,0,%o7
/* 0x0d90	     */		sub	%i4,%i0,%l2
/* 0x0d94	     */		sra	%o0,0,%o2
/* 0x0d98	     */		sra	%l2,31,%o4
/* 0x0d9c	     */		sub	%g2,%o7,%o0
/* 0x0da0	     */		xor	%l2,%o4,%o1
/* 0x0da4	     */		srlx	%o0,63,%g2
/* 0x0da8	     */		sub	%o1,%o4,%l5
/* 0x0dac	     */		sub	%g4,%o7,%o0
/* 0x0db0	     */		sra	%l5,0,%o1
/* 0x0db4	     */		srlx	%o0,63,%o5
/* 0x0db8	     */		sub	%g3,%o7,%g3
/* 0x0dbc	     */		srlx	%g3,63,%l2
/* 0x0dc0	     */		xor	%o5,1,%l5
/* 0x0dc4	     */		sub	%o3,%o7,%o3
/* 0x0dc8	     */		sub	%g5,%o7,%g3
/* 0x0dcc	     */		sub	%o1,%o7,%o0
/* 0x0dd0	     */		srlx	%o3,63,%o5
/* 0x0dd4	     */		sra	%l7,0,%o4
/* 0x0dd8	     */		xor	%g2,1,%l4
/* 0x0ddc	     */		srlx	%g3,63,%l3
/* 0x0de0	     */		xor	%l2,1,%o1
/* 0x0de4	     */		sub	%o4,%o7,%o4
/* 0x0de8	     */		xor	%o5,1,%o3
/* 0x0dec	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x0df0	     */		srlx	%o0,63,%g3
/* 0x0df4	     */		srlx	%o4,63,%g5
/* 0x0df8	     */		and	%l4,%o1,%l4
/* 0x0dfc	     */		add	%g2,1022,%g2
/* 0x0e00	     */		srl	%i1,0,%o5
/* 0x0e04	     */		xor	%l3,1,%o4
/* 0x0e08	     */		xor	%g3,1,%o0
/* 0x0e0c	     */		sub	%o5,%g2,%o1
/* 0x0e10	     */		and	%o0,%o4,%l7
/* 0x0e14	     */		sub	%o2,%o7,%g4
/* 0x0e18	     */		srlx	%o1,63,%g3
/* 0x0e1c	     */		and	%g3,%l5,%o4
/* 0x0e20	     */		srlx	%g4,63,%g4
/* 0x0e24	     */		xor	%g4,1,%o2
/* 0x0e28	     */		and	%o4,%l4,%o0
/* 0x0e2c	     */		xor	%g5,1,%l2
/* 0x0e30	     */		and	%l2,%o2,%l3
/* 0x0e34	     */		and	%o0,%l7,%g5
/* 0x0e38	     */		and	%o3,1,%g4
/* 0x0e3c	     */		and	%g5,%l3,%o2
/* 0x0e40	     */		andcc	%o2,%g4,%g0
/* 0x0e44	     */		be,a,pn	%icc,.L77004000
/* 0x0e48	     */		or	%g0,0,%o4

! Registers live out of .L77004006: 
! g1 o4 sp o7 l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004006

			.L77004007:
/* 0x0e4c	 426 */		sub	%i5,%i0,%o0
/* 0x0e50	     */		sra	%o0,31,%l4
/* 0x0e54	     */		xor	%o0,%l4,%g2
/* 0x0e58	     */		sub	%i5,%l1,%l5
/* 0x0e5c	     */		sra	%l5,31,%l3
/* 0x0e60	     */		sub	%i5,%l6,%l7
/* 0x0e64	     */		sub	%g2,%l4,%o0
/* 0x0e68	     */		xor	%l5,%l3,%o2
/* 0x0e6c	     */		sra	%l7,31,%g2
/* 0x0e70	     */		sub	%o2,%l3,%g5
/* 0x0e74	     */		xor	%l7,%g2,%o1
/* 0x0e78	     */		sub	%i5,%i2,%l2
/* 0x0e7c	     */		add	%fp,-1600,%o4
/* 0x0e80	     */		sub	%i5,%o4,%o3
/* 0x0e84	     */		sra	%l2,31,%l3
/* 0x0e88	     */		sub	%o1,%g2,%o2
/* 0x0e8c	     */		sra	%o3,31,%l4
/* 0x0e90	     */		xor	%l2,%l3,%o1
/* 0x0e94	     */		sub	%i5,%l0,%o5
/* 0x0e98	     */		xor	%o3,%l4,%l5
/* 0x0e9c	     */		sra	%o5,31,%l2
/* 0x0ea0	     */		sub	%i0,%o4,%o4
/* 0x0ea4	     */		sub	%o1,%l3,%g3
/* 0x0ea8	     */		sra	%o4,31,%l3
/* 0x0eac	     */		sub	%l5,%l4,%g4
/* 0x0eb0	     */		sub	%i5,%i3,%g2
/* 0x0eb4	     */		xor	%o5,%l2,%l7
/* 0x0eb8	     */		sra	%g2,31,%l4
/* 0x0ebc	     */		xor	%o4,%l3,%o1
/* 0x0ec0	     */		sub	%l7,%l2,%l7
/* 0x0ec4	     */		sub	%i0,%l6,%o5
/* 0x0ec8	     */		sub	%o1,%l3,%l2
/* 0x0ecc	     */		sra	%o5,31,%o4
/* 0x0ed0	     */		sub	%i0,%l1,%o3
/* 0x0ed4	     */		xor	%g2,%l4,%l5
/* 0x0ed8	     */		xor	%o5,%o4,%g2
/* 0x0edc	     */		sra	%o3,31,%o1
/* 0x0ee0	     */		sub	%l5,%l4,%l5
/* 0x0ee4	     */		sub	%g2,%o4,%l3
/* 0x0ee8	     */		xor	%o3,%o1,%l4
/* 0x0eec	     */		sub	%l4,%o1,%l4
/* 0x0ef0	     */		sra	%g5,0,%g2
/* 0x0ef4	     */		sra	%o0,0,%o0
/* 0x0ef8	     */		sub	%o0,%o7,%o3
/* 0x0efc	     */		sub	%g2,%o7,%o1
/* 0x0f00	     */		srlx	%o3,63,%o0
/* 0x0f04	     */		srlx	%o1,63,%g5
/* 0x0f08	     */		xor	%o0,1,%o3
/* 0x0f0c	     */		xor	%g5,1,%o5
/* 0x0f10	     */		and	%o3,%o5,%o1
/* 0x0f14	     */		sra	%o2,0,%o2
/* 0x0f18	     */		sra	%g4,0,%g4
/* 0x0f1c	     */		sub	%o2,%o7,%o4
/* 0x0f20	     */		sub	%g4,%o7,%o5
/* 0x0f24	     */		srlx	%o4,63,%o2
/* 0x0f28	     */		srlx	%o5,63,%g4
/* 0x0f2c	     */		xor	%o2,1,%o4
/* 0x0f30	     */		xor	%g4,1,%g2
/* 0x0f34	     */		and	%g2,%o4,%o0
/* 0x0f38	     */		and	%o0,%o1,%o2
/* 0x0f3c	     */		sra	%l7,0,%o0
/* 0x0f40	     */		sra	%g3,0,%g3
/* 0x0f44	     */		sub	%g3,%o7,%g5
/* 0x0f48	     */		sub	%o0,%o7,%o3
/* 0x0f4c	     */		srlx	%g5,63,%g3
/* 0x0f50	     */		srlx	%o3,63,%l7
/* 0x0f54	     */		xor	%g3,1,%o5
/* 0x0f58	     */		xor	%l7,1,%g5
/* 0x0f5c	     */		and	%o5,%g5,%o3
/* 0x0f60	     */		and	%o2,%o3,%o0
/* 0x0f64	     */		sra	%l5,0,%g2
/* 0x0f68	     */		sra	%l2,0,%o2
/* 0x0f6c	     */		sub	%g2,%o7,%o1
/* 0x0f70	     */		sub	%o2,%o7,%o4
/* 0x0f74	     */		srlx	%o1,63,%l5
/* 0x0f78	     */		srlx	%o4,63,%l2
/* 0x0f7c	     */		xor	%l2,1,%o1
/* 0x0f80	     */		xor	%l5,1,%g4
/* 0x0f84	     */		and	%o1,%g4,%o4
/* 0x0f88	     */		and	%o0,%o4,%o2
/* 0x0f8c	     */		sra	%l3,0,%o0
/* 0x0f90	     */		sra	%l4,0,%g2
/* 0x0f94	     */		sub	%o0,%o7,%o1
/* 0x0f98	     */		sub	%g2,%o7,%g3
/* 0x0f9c	     */		srlx	%o1,63,%l3
/* 0x0fa0	     */		srlx	%g3,63,%l4
/* 0x0fa4	     */		xor	%l3,1,%l7
/* 0x0fa8	     */		xor	%l4,1,%g5
/* 0x0fac	     */		and	%g5,%l7,%o5
/* 0x0fb0	     */		andcc	%o2,%o5,%g0
/* 0x0fb4	     */		be,a,pn	%icc,.L77004000
/* 0x0fb8	     */		or	%g0,0,%o4

! Registers live out of .L77004007: 
! g1 o4 sp o7 l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004007

			.L77004008:
/* 0x0fbc	 426 */		sub	%i0,%i2,%l7
/* 0x0fc0	     */		sra	%l7,31,%l3
/* 0x0fc4	     */		sub	%i0,%i3,%g5
/* 0x0fc8	     */		add	%fp,-1600,%l4
/* 0x0fcc	     */		sub	%i2,%l4,%o5
/* 0x0fd0	     */		sra	%g5,31,%o1
/* 0x0fd4	     */		xor	%l7,%l3,%o3
/* 0x0fd8	     */		sub	%i0,%l0,%o0
/* 0x0fdc	     */		xor	%g5,%o1,%l2
/* 0x0fe0	     */		sra	%o0,31,%g2
/* 0x0fe4	     */		sra	%o5,31,%l5
/* 0x0fe8	     */		sub	%o3,%l3,%o2
/* 0x0fec	     */		sub	%l2,%o1,%l4
/* 0x0ff0	     */		xor	%o5,%l5,%o4
/* 0x0ff4	     */		xor	%o0,%g2,%o3
/* 0x0ff8	     */		sub	%i2,%l6,%g3
/* 0x0ffc	     */		sra	%g3,31,%o1
/* 0x1000	     */		sub	%i2,%l1,%g4
/* 0x1004	     */		sub	%o4,%l5,%l5
/* 0x1008	     */		sub	%o3,%g2,%g5
/* 0x100c	     */		xor	%g3,%o1,%o0
/* 0x1010	     */		sra	%g4,31,%o4
/* 0x1014	     */		sub	%i2,%i3,%l2
/* 0x1018	     */		sub	%i2,%l0,%o3
/* 0x101c	     */		xor	%g4,%o4,%o5
/* 0x1020	     */		sra	%o3,31,%g2
/* 0x1024	     */		sub	%o0,%o1,%g3
/* 0x1028	     */		sra	%l2,31,%l3
/* 0x102c	     */		xor	%l2,%l3,%g4
/* 0x1030	     */		xor	%o3,%g2,%o0
/* 0x1034	     */		sub	%o5,%o4,%l7
/* 0x1038	     */		sub	%o0,%g2,%l2
/* 0x103c	     */		sra	%l4,0,%g2
/* 0x1040	     */		sra	%l5,0,%o5
/* 0x1044	     */		sra	%o2,0,%o2
/* 0x1048	     */		sra	%g5,0,%g5
/* 0x104c	     */		sub	%g2,%o7,%o1
/* 0x1050	     */		sub	%o5,%o7,%o4
/* 0x1054	     */		sub	%o2,%o7,%o3
/* 0x1058	     */		sub	%g5,%o7,%o0
/* 0x105c	     */		srlx	%o1,63,%l4
/* 0x1060	     */		srlx	%o4,63,%l5
/* 0x1064	     */		srlx	%o3,63,%o2
/* 0x1068	     */		srlx	%o0,63,%g5
/* 0x106c	     */		sub	%g4,%l3,%l3
/* 0x1070	     */		xor	%l4,1,%o1
/* 0x1074	     */		xor	%l5,1,%o5
/* 0x1078	     */		xor	%o2,1,%o4
/* 0x107c	     */		xor	%g5,1,%o3
/* 0x1080	     */		and	%o5,%o1,%g4
/* 0x1084	     */		and	%o3,%o4,%o0
/* 0x1088	     */		sra	%l7,0,%o1
/* 0x108c	     */		and	%o0,%g4,%o2
/* 0x1090	     */		sub	%o1,%o7,%o5
/* 0x1094	     */		sra	%g3,0,%g3
/* 0x1098	     */		sra	%l3,0,%g4
/* 0x109c	     */		sub	%g3,%o7,%g2
/* 0x10a0	     */		sub	%g4,%o7,%o4
/* 0x10a4	     */		sra	%l2,0,%o1
/* 0x10a8	     */		srlx	%g2,63,%g3
/* 0x10ac	     */		srlx	%o5,63,%l7
/* 0x10b0	     */		sub	%o1,%o7,%o7
/* 0x10b4	     */		srlx	%o4,63,%l3
/* 0x10b8	     */		xor	%g3,1,%g2
/* 0x10bc	     */		xor	%l7,1,%l4
/* 0x10c0	     */		srlx	%o7,63,%l2
/* 0x10c4	     */		and	%l4,%g2,%l5
/* 0x10c8	     */		xor	%l3,1,%g5
/* 0x10cc	     */		xor	%l2,1,%o5
/* 0x10d0	     */		and	%g5,%o5,%o4
/* 0x10d4	     */		and	%o2,%l5,%o3
/* 0x10d8	     */		andcc	%o3,%o4,%g0
/* 0x10dc	     */		be,a,pn	%icc,.L77004000
/* 0x10e0	     */		or	%g0,0,%o4

! Registers live out of .L77004008: 
! g1 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004008

			.L77004192:
/* 0x10e4	 426 */		sethi	%hi(0x1000),%g1
/* 0x10e8	     */		xor	%g1,-704,%g1
/* 0x10ec	     */		add	%g1,%fp,%l4
/* 0x10f0	     */		sethi	%hi(0x1800),%g1
/* 0x10f4	     */		xor	%g1,-256,%g1
/* 0x10f8	     */		add	%i1,-1,%l7
/* 0x10fc	     */		or	%g0,0,%o4
/* 0x1100	     */		add	%fp,-1600,%l6
/* 0x1104	     */		add	%fp,-3200,%l5

!  427		      !            if (mask[i]) {

/* 0x1108	 427 */		ldub	[%i3],%o1
/* 0x110c	 426 */		add	%g1,%fp,%l3

! Registers live out of .L77004192: 
! o1 o4 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003781 .L77004192

			.L900000487:
/* 0x1110	 427 */		cmp	%o1,0
/* 0x1114	     */		be,pn	%icc,.L77003781
/* 0x1118	 426 */		add	%o4,1,%o4

! Registers live out of .L900000487: 
! o1 o4 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  428		      !               red[i]   = ~rdest[i];

                       
! predecessor blocks: .L900000487

			.L77003779:
/* 0x111c	 428 */		ldub	[%l6],%o5

!  429		      !               green[i] = ~gdest[i];

/* 0x1120	 429 */		ldub	[%l5],%i1

!  430		      !               blue[i]  = ~bdest[i];

/* 0x1124	 430 */		ldub	[%l4],%l1

!  431		      !               alpha[i] = ~adest[i];

/* 0x1128	 431 */		ldub	[%l3],%l2
/* 0x112c	 428 */		xnor	%o5,0,%o2
/* 0x1130	     */		stb	%o2,[%i4]
/* 0x1134	 429 */		xnor	%i1,0,%l0
/* 0x1138	     */		stb	%l0,[%i5]
/* 0x113c	 430 */		xnor	%l1,0,%o3
/* 0x1140	     */		stb	%o3,[%i0]
/* 0x1144	 431 */		xnor	%l2,0,%o7
/* 0x1148	     */		stb	%o7,[%i2]

! Registers live out of .L77003779: 
! o1 o4 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003779 .L900000487

			.L77003781:
/* 0x114c	 426 */		cmp	%o4,%l7
/* 0x1150	     */		add	%i3,1,%i3
/* 0x1154	     */		add	%l3,1,%l3
/* 0x1158	     */		add	%l4,1,%l4
/* 0x115c	     */		add	%l5,1,%l5
/* 0x1160	     */		add	%l6,1,%l6
/* 0x1164	     */		add	%i2,1,%i2
/* 0x1168	     */		add	%i0,1,%i0
/* 0x116c	     */		add	%i5,1,%i5
/* 0x1170	     */		add	%i4,1,%i4
/* 0x1174	     */		ble,a,pt	%icc,.L900000487
/* 0x1178	 427 */		ldub	[%i3],%o1

! Registers live out of .L77003781: 
! o1 o4 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003781

			.L77004003:
/* 0x117c	 426 */		ba	.L77003932
/* 0x1180	     */		nop

! Registers live out of .L77004003: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003953

			.L77004343:
/* 0x1184	 426 */		ld	[%fp+92],%i0
/* 0x1188	     */		ld	[%fp+96],%i2
/* 0x118c	     */		or	%g0,0,%o4

! Registers live out of .L77004343: 
! g1 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004006 .L77004007 .L77004008 .L77004343

			.L77004000:
/* 0x1190	 427 */		ldub	[%o4+%i3],%g3

! Registers live out of .L77004000: 
! g1 g3 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004000 .L77004002

			.L900000486:
/* 0x1194	 427 */		cmp	%g3,0
/* 0x1198	     */		be,pn	%icc,.L77004002
/* 0x119c	 428 */		add	%fp,-1600,%g4

! Registers live out of .L900000486: 
! g1 g3 g4 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000486

			.L77004001:
/* 0x11a0	 428 */		ldub	[%o4+%g4],%o7
/* 0x11a4	     */		xnor	%o7,0,%g2
/* 0x11a8	     */		stb	%g2,[%o4+%i4]
/* 0x11ac	 429 */		ldub	[%o4+%l6],%o1
/* 0x11b0	     */		xnor	%o1,0,%l4
/* 0x11b4	     */		stb	%l4,[%o4+%i5]
/* 0x11b8	 430 */		ldub	[%o4+%l1],%l5
/* 0x11bc	     */		xnor	%l5,0,%l2
/* 0x11c0	     */		stb	%l2,[%o4+%i0]
/* 0x11c4	 431 */		ldub	[%o4+%l0],%o5
/* 0x11c8	     */		xnor	%o5,0,%o3
/* 0x11cc	     */		stb	%o3,[%o4+%i2]

! Registers live out of .L77004001: 
! g1 g3 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004001 .L900000486

			.L77004002:
/* 0x11d0	 426 */		add	%o4,1,%o4
/* 0x11d4	     */		cmp	%o4,%i1
/* 0x11d8	     */		bcs,a,pn	%icc,.L900000486
/* 0x11dc	 427 */		ldub	[%o4+%i3],%g3

! Registers live out of .L77004002: 
! g1 g3 o4 sp l0 l1 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004002

			.L900000459:
/* 0x11e0	 426 */		ba	.L77003932
/* 0x11e4	     */		nop

! Registers live out of .L900000459: 
! sp fp i7 gsr 
! 
		
!  432		      !            }
!  433		      !         }
!  434		      !         break;
!  435		      !      case GL_AND:
!  436		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003787:
/* 0x11e8	 436 */		cmp	%i1,0
/* 0x11ec	     */		bleu,pn	%icc,.L77003932
/* 0x11f0	     */		cmp	%i1,54

! Registers live out of .L77003787: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003787

			.L77003961:
/* 0x11f4	 436 */		ld	[%fp+100],%i3
/* 0x11f8	     */		bl,pn	%icc,.L77004327
/* 0x11fc	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003961: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003961

			.L77004102:
/* 0x1200	 436 */		sra	%i0,31,%o2
/* 0x1204	     */		add	%fp,-1600,%g4
/* 0x1208	     */		sub	%i4,%g4,%o7
/* 0x120c	     */		xor	%i0,%o2,%i2
/* 0x1210	     */		sub	%i4,%l6,%o5
/* 0x1214	     */		sub	%i2,%o2,%l7
/* 0x1218	     */		sra	%o5,31,%g4
/* 0x121c	     */		sub	%i4,%i3,%i0
/* 0x1220	     */		xor	%o5,%g4,%l2
/* 0x1224	     */		sra	%i0,31,%i2
/* 0x1228	     */		sub	%i4,%l0,%g5
/* 0x122c	     */		sra	%g5,31,%o0
/* 0x1230	     */		xor	%i0,%i2,%o5
/* 0x1234	     */		sra	%o7,31,%o4
/* 0x1238	     */		xor	%g5,%o0,%o3
/* 0x123c	     */		sub	%i4,%l1,%l5
/* 0x1240	     */		xor	%o7,%o4,%o1
/* 0x1244	     */		sra	%l5,31,%g2
/* 0x1248	     */		sub	%o3,%o0,%o2
/* 0x124c	     */		sub	%l2,%g4,%g3
/* 0x1250	     */		sub	%o1,%o4,%l4
/* 0x1254	     */		xor	%l5,%g2,%l3
/* 0x1258	     */		sub	%o5,%i2,%o0
/* 0x125c	     */		sub	%l3,%g2,%l2
/* 0x1260	     */		sra	%g3,0,%o7
/* 0x1264	     */		sra	%o2,0,%g3
/* 0x1268	     */		sra	%i1,0,%o2
/* 0x126c	     */		sra	%l7,0,%g2
/* 0x1270	     */		sra	%l4,0,%o1
/* 0x1274	     */		sra	%l2,0,%g4
/* 0x1278	     */		sub	%o1,%o2,%o1
/* 0x127c	     */		srlx	%o1,63,%l2
/* 0x1280	     */		sub	%g4,%o2,%o1
/* 0x1284	     */		sub	%g3,%o2,%g4
/* 0x1288	     */		srlx	%g4,63,%g3
/* 0x128c	     */		ld	[%fp+92],%i0
/* 0x1290	     */		ld	[%fp+96],%i2
/* 0x1294	     */		sub	%i4,%i0,%o4
/* 0x1298	     */		sra	%o4,31,%l3
/* 0x129c	     */		xor	%o4,%l3,%l5
/* 0x12a0	     */		sub	%i4,%i2,%g5
/* 0x12a4	     */		sra	%o0,0,%o4
/* 0x12a8	     */		sra	%g5,31,%o5
/* 0x12ac	     */		sub	%g2,%o2,%o0
/* 0x12b0	     */		sub	%l5,%l3,%l7
/* 0x12b4	     */		xor	%g5,%o5,%o3
/* 0x12b8	     */		srlx	%o0,63,%g2
/* 0x12bc	     */		sra	%l7,0,%g5
/* 0x12c0	     */		sub	%o7,%o2,%o0
/* 0x12c4	     */		sub	%o3,%o5,%l4
/* 0x12c8	     */		sub	%g5,%o2,%o7
/* 0x12cc	     */		srlx	%o0,63,%l3
/* 0x12d0	     */		srlx	%o1,63,%l5
/* 0x12d4	     */		srlx	%o7,63,%o5
/* 0x12d8	     */		xor	%g2,1,%o7
/* 0x12dc	     */		xor	%l3,1,%o1
/* 0x12e0	     */		sra	%l4,0,%o3
/* 0x12e4	     */		and	%o1,%o7,%g5
/* 0x12e8	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x12ec	     */		sub	%o3,%o2,%o0
/* 0x12f0	     */		sub	%o4,%o2,%o4
/* 0x12f4	     */		add	%g2,1022,%g2
/* 0x12f8	     */		srl	%i1,0,%o7
/* 0x12fc	     */		srlx	%o0,63,%g4
/* 0x1300	     */		srlx	%o4,63,%o1
/* 0x1304	     */		sub	%o7,%g2,%o7
/* 0x1308	     */		xor	%l2,1,%l4
/* 0x130c	     */		xor	%l5,1,%o3
/* 0x1310	     */		xor	%o5,1,%o0
/* 0x1314	     */		srlx	%o7,63,%o4
/* 0x1318	     */		and	%o3,%o0,%l5
/* 0x131c	     */		and	%o4,%l4,%o5
/* 0x1320	     */		xor	%g4,1,%l7
/* 0x1324	     */		xor	%g3,1,%l3
/* 0x1328	     */		and	%o5,%g5,%o0
/* 0x132c	     */		and	%l3,%l7,%o3
/* 0x1330	     */		xor	%o1,1,%l2
/* 0x1334	     */		and	%o0,%l5,%g3
/* 0x1338	     */		and	%l2,1,%g4
/* 0x133c	     */		and	%g3,%o3,%l7
/* 0x1340	     */		andcc	%l7,%g4,%g0
/* 0x1344	     */		be,a,pn	%icc,.L77004096
/* 0x1348	     */		or	%g0,0,%l4

! Registers live out of .L77004102: 
! g1 o2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004102

			.L77004103:
/* 0x134c	 436 */		sub	%i5,%i0,%o0
/* 0x1350	     */		sra	%o0,31,%l4
/* 0x1354	     */		xor	%o0,%l4,%l3
/* 0x1358	     */		sub	%i5,%l1,%l5
/* 0x135c	     */		add	%fp,-1600,%o7
/* 0x1360	     */		sub	%i5,%o7,%g3
/* 0x1364	     */		sub	%l3,%l4,%o1
/* 0x1368	     */		sra	%l5,31,%l2
/* 0x136c	     */		sub	%i5,%l6,%l7
/* 0x1370	     */		xor	%l5,%l2,%o5
/* 0x1374	     */		sra	%l7,31,%l3
/* 0x1378	     */		sra	%g3,31,%l4
/* 0x137c	     */		xor	%l7,%l3,%o4
/* 0x1380	     */		xor	%g3,%l4,%l5
/* 0x1384	     */		sub	%o5,%l2,%g5
/* 0x1388	     */		sub	%o4,%l3,%o0
/* 0x138c	     */		sub	%i5,%i2,%g2
/* 0x1390	     */		sub	%l5,%l4,%g4
/* 0x1394	     */		sub	%i0,%o7,%o4
/* 0x1398	     */		sra	%g2,31,%o5
/* 0x139c	     */		sub	%i5,%i3,%l5
/* 0x13a0	     */		xor	%g2,%o5,%o7
/* 0x13a4	     */		sra	%l5,31,%l3
/* 0x13a8	     */		xor	%l5,%l3,%g2
/* 0x13ac	     */		sub	%i5,%l0,%o3
/* 0x13b0	     */		sub	%o7,%o5,%g3
/* 0x13b4	     */		sub	%g2,%l3,%l5
/* 0x13b8	     */		sra	%o4,31,%o5
/* 0x13bc	     */		sra	%o3,31,%l7
/* 0x13c0	     */		sub	%i0,%l6,%o7
/* 0x13c4	     */		xor	%o3,%l7,%l2
/* 0x13c8	     */		xor	%o4,%o5,%l4
/* 0x13cc	     */		sra	%o7,31,%g2
/* 0x13d0	     */		xor	%o7,%g2,%o4
/* 0x13d4	     */		sub	%l2,%l7,%l7
/* 0x13d8	     */		sub	%i0,%l1,%o3
/* 0x13dc	     */		sub	%l4,%o5,%l2
/* 0x13e0	     */		sra	%o3,31,%o7
/* 0x13e4	     */		sub	%o4,%g2,%l3
/* 0x13e8	     */		xor	%o3,%o7,%l4
/* 0x13ec	     */		sub	%l4,%o7,%l4
/* 0x13f0	     */		sra	%o1,0,%o3
/* 0x13f4	     */		sra	%g5,0,%g2
/* 0x13f8	     */		sub	%o3,%o2,%o5
/* 0x13fc	     */		sub	%g2,%o2,%o7
/* 0x1400	     */		srlx	%o5,63,%o1
/* 0x1404	     */		srlx	%o7,63,%g5
/* 0x1408	     */		xor	%o1,1,%o3
/* 0x140c	     */		xor	%g5,1,%o5
/* 0x1410	     */		and	%o5,%o3,%o7
/* 0x1414	     */		sra	%o0,0,%o1
/* 0x1418	     */		sra	%g4,0,%g4
/* 0x141c	     */		sub	%g4,%o2,%o4
/* 0x1420	     */		sra	%l7,0,%o3
/* 0x1424	     */		sub	%o1,%o2,%o0
/* 0x1428	     */		sra	%g3,0,%g3
/* 0x142c	     */		srlx	%o4,63,%g4
/* 0x1430	     */		sub	%g3,%o2,%g5
/* 0x1434	     */		sub	%o3,%o2,%o5
/* 0x1438	     */		srlx	%o0,63,%o0
/* 0x143c	     */		xor	%o0,1,%o1
/* 0x1440	     */		xor	%g4,1,%o4
/* 0x1444	     */		srlx	%g5,63,%g3
/* 0x1448	     */		srlx	%o5,63,%l7
/* 0x144c	     */		and	%o4,%o1,%g2
/* 0x1450	     */		xor	%g3,1,%g5
/* 0x1454	     */		xor	%l7,1,%o3
/* 0x1458	     */		and	%g2,%o7,%o0
/* 0x145c	     */		and	%o3,%g5,%o5
/* 0x1460	     */		and	%o0,%o5,%o4
/* 0x1464	     */		sra	%l5,0,%g2
/* 0x1468	     */		sra	%l2,0,%o1
/* 0x146c	     */		sub	%g2,%o2,%o7
/* 0x1470	     */		sub	%o1,%o2,%o0
/* 0x1474	     */		srlx	%o7,63,%l5
/* 0x1478	     */		srlx	%o0,63,%l2
/* 0x147c	     */		xor	%l5,1,%g4
/* 0x1480	     */		xor	%l2,1,%o7
/* 0x1484	     */		and	%o7,%g4,%o1
/* 0x1488	     */		and	%o4,%o1,%o0
/* 0x148c	     */		sra	%l3,0,%o4
/* 0x1490	     */		sra	%l4,0,%g2
/* 0x1494	     */		sub	%o4,%o2,%o5
/* 0x1498	     */		sub	%g2,%o2,%g3
/* 0x149c	     */		srlx	%g3,63,%l4
/* 0x14a0	     */		srlx	%o5,63,%l3
/* 0x14a4	     */		xor	%l4,1,%g5
/* 0x14a8	     */		xor	%l3,1,%l7
/* 0x14ac	     */		and	%g5,%l7,%o3
/* 0x14b0	     */		andcc	%o0,%o3,%g0
/* 0x14b4	     */		be,a,pn	%icc,.L77004096
/* 0x14b8	     */		or	%g0,0,%l4

! Registers live out of .L77004103: 
! g1 o2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004103

			.L77004104:
/* 0x14bc	 436 */		add	%fp,-1600,%l4
/* 0x14c0	     */		sub	%i2,%l4,%l5
/* 0x14c4	     */		sra	%l5,31,%o4
/* 0x14c8	     */		sub	%i0,%i2,%g5
/* 0x14cc	     */		xor	%l5,%o4,%l2
/* 0x14d0	     */		sra	%g5,31,%o3
/* 0x14d4	     */		sub	%l2,%o4,%l5
/* 0x14d8	     */		xor	%g5,%o3,%o0
/* 0x14dc	     */		sub	%i0,%i3,%o5
/* 0x14e0	     */		sra	%o5,31,%o1
/* 0x14e4	     */		sub	%i0,%l0,%l7
/* 0x14e8	     */		sub	%o0,%o3,%o4
/* 0x14ec	     */		xor	%o5,%o1,%l3
/* 0x14f0	     */		sra	%l7,31,%o3
/* 0x14f4	     */		sub	%i2,%l6,%g3
/* 0x14f8	     */		xor	%l7,%o3,%o0
/* 0x14fc	     */		sra	%g3,31,%o5
/* 0x1500	     */		sub	%l3,%o1,%l4
/* 0x1504	     */		xor	%g3,%o5,%o7
/* 0x1508	     */		sub	%o0,%o3,%g5
/* 0x150c	     */		sub	%i2,%i3,%g2
/* 0x1510	     */		sub	%i2,%l0,%o0
/* 0x1514	     */		sub	%o7,%o5,%g3
/* 0x1518	     */		sra	%g2,31,%l3
/* 0x151c	     */		xor	%g2,%l3,%l2
/* 0x1520	     */		sra	%o0,31,%o7
/* 0x1524	     */		sub	%i2,%l1,%g4
/* 0x1528	     */		sra	%g4,31,%o1
/* 0x152c	     */		xor	%o0,%o7,%o3
/* 0x1530	     */		sub	%l2,%l3,%l3
/* 0x1534	     */		sub	%o3,%o7,%l2
/* 0x1538	     */		xor	%g4,%o1,%g4
/* 0x153c	     */		sub	%g4,%o1,%l7
/* 0x1540	     */		sra	%l4,0,%o7
/* 0x1544	     */		sra	%l5,0,%o5
/* 0x1548	     */		sra	%o4,0,%o4
/* 0x154c	     */		sra	%g5,0,%g5
/* 0x1550	     */		sub	%o7,%o2,%g2
/* 0x1554	     */		sub	%o5,%o2,%o1
/* 0x1558	     */		sub	%o4,%o2,%o0
/* 0x155c	     */		sub	%g5,%o2,%o3
/* 0x1560	     */		srlx	%g2,63,%l4
/* 0x1564	     */		srlx	%o1,63,%l5
/* 0x1568	     */		srlx	%o0,63,%o4
/* 0x156c	     */		srlx	%o3,63,%g5
/* 0x1570	     */		xor	%l4,1,%g4
/* 0x1574	     */		xor	%l5,1,%o5
/* 0x1578	     */		xor	%o4,1,%g2
/* 0x157c	     */		xor	%g5,1,%o1
/* 0x1580	     */		and	%o5,%g4,%o7
/* 0x1584	     */		and	%g2,%o1,%o0
/* 0x1588	     */		and	%o0,%o7,%g4
/* 0x158c	     */		sra	%l7,0,%g2
/* 0x1590	     */		sra	%g3,0,%g3
/* 0x1594	     */		sub	%g2,%o2,%o5
/* 0x1598	     */		sub	%g3,%o2,%o7
/* 0x159c	     */		srlx	%o5,63,%l7
/* 0x15a0	     */		srlx	%o7,63,%g3
/* 0x15a4	     */		xor	%l7,1,%l4
/* 0x15a8	     */		xor	%g3,1,%o3
/* 0x15ac	     */		and	%l4,%o3,%l5
/* 0x15b0	     */		and	%g4,%l5,%g2
/* 0x15b4	     */		sra	%l3,0,%g4
/* 0x15b8	     */		sub	%g4,%o2,%o1
/* 0x15bc	     */		sra	%l2,0,%o5
/* 0x15c0	     */		sub	%o5,%o2,%o2
/* 0x15c4	     */		srlx	%o1,63,%l3
/* 0x15c8	     */		srlx	%o2,63,%l2
/* 0x15cc	     */		xor	%l3,1,%g5
/* 0x15d0	     */		xor	%l2,1,%o4
/* 0x15d4	     */		and	%g5,%o4,%o1
/* 0x15d8	     */		andcc	%g2,%o1,%g0
/* 0x15dc	     */		be,a,pn	%icc,.L77004096
/* 0x15e0	     */		or	%g0,0,%l4

! Registers live out of .L77004104: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004104

			.L77004200:
/* 0x15e4	 436 */		sethi	%hi(0x1000),%g1
/* 0x15e8	     */		xor	%g1,-704,%g1
/* 0x15ec	     */		add	%g1,%fp,%g2
/* 0x15f0	     */		sethi	%hi(0x1800),%g1
/* 0x15f4	     */		xor	%g1,-256,%g1
/* 0x15f8	     */		add	%i1,-1,%o0
/* 0x15fc	     */		or	%g0,0,%g5
/* 0x1600	     */		add	%fp,-1600,%g4
/* 0x1604	     */		add	%fp,-3200,%g3

!  437		      !            if (mask[i]) {

/* 0x1608	 437 */		ldub	[%i3],%o4
/* 0x160c	 436 */		add	%g1,%fp,%l7

! Registers live out of .L77004200: 
! g2 g3 g4 g5 o0 o4 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003795 .L77004200

			.L900000485:
/* 0x1610	 437 */		cmp	%o4,0
/* 0x1614	     */		be,pn	%icc,.L77003795
/* 0x1618	 436 */		add	%g5,1,%g5

! Registers live out of .L900000485: 
! g2 g3 g4 g5 o0 o4 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  438		      !               red[i]   &= rdest[i];

                       
! predecessor blocks: .L900000485

			.L77003793:
/* 0x161c	 438 */		ldub	[%i4],%i1

!  439		      !               green[i] &= gdest[i];

/* 0x1620	 439 */		ldub	[%i5],%o3

!  440		      !               blue[i]  &= bdest[i];

/* 0x1624	 440 */		ldub	[%i0],%l3

!  441		      !               alpha[i] &= adest[i];

/* 0x1628	 441 */		ldub	[%i2],%l6
/* 0x162c	 438 */		ldub	[%g4],%o2
/* 0x1630	 439 */		ldub	[%g3],%l1
/* 0x1634	 440 */		ldub	[%g2],%o7
/* 0x1638	 441 */		ldub	[%l7],%l5
/* 0x163c	 438 */		and	%i1,%o2,%l0
/* 0x1640	     */		stb	%l0,[%i4]
/* 0x1644	 439 */		and	%o3,%l1,%l2
/* 0x1648	     */		stb	%l2,[%i5]
/* 0x164c	 440 */		and	%l3,%o7,%l4
/* 0x1650	     */		stb	%l4,[%i0]
/* 0x1654	 441 */		and	%l6,%l5,%o1
/* 0x1658	     */		stb	%o1,[%i2]

! Registers live out of .L77003793: 
! g2 g3 g4 g5 o0 o4 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003793 .L900000485

			.L77003795:
/* 0x165c	 436 */		cmp	%g5,%o0
/* 0x1660	     */		add	%i3,1,%i3
/* 0x1664	     */		add	%l7,1,%l7
/* 0x1668	     */		add	%g2,1,%g2
/* 0x166c	     */		add	%g3,1,%g3
/* 0x1670	     */		add	%g4,1,%g4
/* 0x1674	     */		add	%i2,1,%i2
/* 0x1678	     */		add	%i0,1,%i0
/* 0x167c	     */		add	%i5,1,%i5
/* 0x1680	     */		add	%i4,1,%i4
/* 0x1684	     */		ble,a,pt	%icc,.L900000485
/* 0x1688	 437 */		ldub	[%i3],%o4

! Registers live out of .L77003795: 
! g2 g3 g4 g5 o0 o4 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003795

			.L77004099:
/* 0x168c	 436 */		ba	.L77003932
/* 0x1690	     */		nop

! Registers live out of .L77004099: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003961

			.L77004327:
/* 0x1694	 436 */		ld	[%fp+92],%i0
/* 0x1698	     */		ld	[%fp+96],%i2
/* 0x169c	     */		or	%g0,0,%l4

! Registers live out of .L77004327: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004102 .L77004103 .L77004104 .L77004327

			.L77004096:
/* 0x16a0	 437 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004096: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004096 .L77004098

			.L900000484:
/* 0x16a4	 437 */		cmp	%g3,0
/* 0x16a8	     */		be,pn	%icc,.L77004098
/* 0x16ac	 438 */		add	%fp,-1600,%g5

! Registers live out of .L900000484: 
! g1 g3 g5 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000484

			.L77004097:
/* 0x16b0	 438 */		ldub	[%l4+%g5],%o2
/* 0x16b4	     */		ldub	[%i4+%l4],%g2
/* 0x16b8	     */		and	%g2,%o2,%o7
/* 0x16bc	     */		stb	%o7,[%i4+%l4]
/* 0x16c0	 439 */		ldub	[%l4+%l6],%g5
/* 0x16c4	     */		ldub	[%i5+%l4],%l3
/* 0x16c8	     */		and	%l3,%g5,%o1
/* 0x16cc	     */		stb	%o1,[%i5+%l4]
/* 0x16d0	 440 */		ldub	[%l4+%l1],%l2
/* 0x16d4	     */		ldub	[%l4+%i0],%o4
/* 0x16d8	     */		and	%o4,%l2,%o5
/* 0x16dc	     */		stb	%o5,[%l4+%i0]
/* 0x16e0	 441 */		ldub	[%l4+%l0],%l5
/* 0x16e4	     */		ldub	[%l4+%i2],%o0
/* 0x16e8	     */		and	%o0,%l5,%o3
/* 0x16ec	     */		stb	%o3,[%l4+%i2]

! Registers live out of .L77004097: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004097 .L900000484

			.L77004098:
/* 0x16f0	 436 */		add	%l4,1,%l4
/* 0x16f4	     */		cmp	%l4,%i1
/* 0x16f8	     */		bcs,a,pn	%icc,.L900000484
/* 0x16fc	 437 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004098: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004098

			.L900000458:
/* 0x1700	 436 */		ba	.L77003932
/* 0x1704	     */		nop

! Registers live out of .L900000458: 
! sp fp i7 gsr 
! 
		
!  442		      !            }
!  443		      !         }
!  444		      !         break;
!  445		      !      case GL_NAND:
!  446		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003801:
/* 0x1708	 446 */		cmp	%i1,0
/* 0x170c	     */		bleu,pn	%icc,.L77003932
/* 0x1710	     */		cmp	%i1,54

! Registers live out of .L77003801: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003801

			.L77003964:
/* 0x1714	 446 */		ld	[%fp+100],%i3
/* 0x1718	     */		bl,pn	%icc,.L77004351
/* 0x171c	     */		sub	%i4,%i5,%i2

! Registers live out of .L77003964: 
! g1 sp l0 l1 l6 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003964

			.L77004136:
/* 0x1720	 446 */		add	%fp,-1600,%i0
/* 0x1724	     */		sub	%i4,%i0,%o1
/* 0x1728	     */		sra	%i2,31,%o2
/* 0x172c	     */		xor	%i2,%o2,%i0
/* 0x1730	     */		sub	%i4,%l6,%o5
/* 0x1734	     */		sub	%i0,%o2,%l7
/* 0x1738	     */		sra	%o5,31,%g4
/* 0x173c	     */		sub	%i4,%l1,%l5
/* 0x1740	     */		xor	%o5,%g4,%l2
/* 0x1744	     */		sra	%l5,31,%g2
/* 0x1748	     */		sub	%i4,%i3,%i0
/* 0x174c	     */		sub	%l2,%g4,%g3
/* 0x1750	     */		xor	%l5,%g2,%l3
/* 0x1754	     */		sra	%i0,31,%i2
/* 0x1758	     */		sub	%l3,%g2,%l2
/* 0x175c	     */		xor	%i0,%i2,%o5
/* 0x1760	     */		sub	%o5,%i2,%g2
/* 0x1764	     */		sub	%i4,%l0,%g5
/* 0x1768	     */		sra	%g5,31,%o0
/* 0x176c	     */		sra	%o1,31,%o7
/* 0x1770	     */		xor	%g5,%o0,%o3
/* 0x1774	     */		xor	%o1,%o7,%o4
/* 0x1778	     */		sub	%o3,%o0,%o2
/* 0x177c	     */		sub	%o4,%o7,%l4
/* 0x1780	     */		sra	%g3,0,%o1
/* 0x1784	     */		sra	%l7,0,%o7
/* 0x1788	     */		sra	%l4,0,%g4
/* 0x178c	     */		sra	%l2,0,%g5
/* 0x1790	     */		ld	[%fp+96],%i2
/* 0x1794	     */		ld	[%fp+92],%i0
/* 0x1798	     */		sub	%i4,%i2,%o3
/* 0x179c	     */		sra	%o3,31,%o5
/* 0x17a0	     */		sub	%i4,%i0,%o4
/* 0x17a4	     */		sra	%o4,31,%l3
/* 0x17a8	     */		xor	%o3,%o5,%o0
/* 0x17ac	     */		xor	%o4,%l3,%l5
/* 0x17b0	     */		sub	%o0,%o5,%g3
/* 0x17b4	     */		sra	%o2,0,%o3
/* 0x17b8	     */		sra	%i1,0,%o2
/* 0x17bc	     */		sra	%g3,0,%o4
/* 0x17c0	     */		sub	%o7,%o2,%g3
/* 0x17c4	     */		sub	%g4,%o2,%o7
/* 0x17c8	     */		srlx	%o7,63,%l4
/* 0x17cc	     */		sub	%l5,%l3,%l7
/* 0x17d0	     */		srlx	%g3,63,%l2
/* 0x17d4	     */		sub	%g5,%o2,%o7
/* 0x17d8	     */		sub	%o1,%o2,%o1
/* 0x17dc	     */		srlx	%o7,63,%l5
/* 0x17e0	     */		sub	%o3,%o2,%g3
/* 0x17e4	     */		srlx	%o1,63,%o1
/* 0x17e8	     */		sra	%g2,0,%o5
/* 0x17ec	     */		sub	%o4,%o2,%o3
/* 0x17f0	     */		xor	%o1,1,%g5
/* 0x17f4	     */		xor	%l2,1,%o7
/* 0x17f8	     */		sub	%o5,%o2,%o4
/* 0x17fc	     */		and	%g5,%o7,%o7
/* 0x1800	     */		srlx	%o4,63,%o1
/* 0x1804	     */		sra	%l7,0,%o0
/* 0x1808	     */		xor	%l4,1,%g5
/* 0x180c	     */		xor	%o1,1,%l4
/* 0x1810	     */		srlx	%g3,63,%l7
/* 0x1814	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x1818	     */		sub	%o0,%o2,%o0
/* 0x181c	     */		add	%g2,1022,%o1
/* 0x1820	     */		srl	%i1,0,%g3
/* 0x1824	     */		srlx	%o3,63,%g4
/* 0x1828	     */		srlx	%o0,63,%o0
/* 0x182c	     */		sub	%g3,%o1,%g3
/* 0x1830	     */		xor	%l5,1,%l3
/* 0x1834	     */		xor	%o0,1,%o3
/* 0x1838	     */		srlx	%g3,63,%o4
/* 0x183c	     */		and	%l3,%o3,%l5
/* 0x1840	     */		and	%o4,%g5,%o0
/* 0x1844	     */		xor	%g4,1,%o5
/* 0x1848	     */		xor	%l7,1,%l2
/* 0x184c	     */		and	%o0,%o7,%o3
/* 0x1850	     */		and	%l2,%o5,%l3
/* 0x1854	     */		and	%o3,%l5,%g4
/* 0x1858	     */		and	%l4,1,%l7
/* 0x185c	     */		and	%g4,%l3,%o5
/* 0x1860	     */		andcc	%o5,%l7,%g0
/* 0x1864	     */		be,a,pn	%icc,.L77004130
/* 0x1868	     */		or	%g0,0,%l4

! Registers live out of .L77004136: 
! g1 o2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004136

			.L77004137:
/* 0x186c	 446 */		sub	%i5,%i0,%o4
/* 0x1870	     */		sra	%o4,31,%l4
/* 0x1874	     */		sub	%i5,%l1,%l5
/* 0x1878	     */		xor	%o4,%l4,%o1
/* 0x187c	     */		sra	%l5,31,%o5
/* 0x1880	     */		sub	%i5,%l6,%l7
/* 0x1884	     */		add	%fp,-1600,%l2
/* 0x1888	     */		sub	%i5,%l2,%g3
/* 0x188c	     */		xor	%l5,%o5,%l3
/* 0x1890	     */		sra	%l7,31,%o4
/* 0x1894	     */		sub	%o1,%l4,%g2
/* 0x1898	     */		sub	%l3,%o5,%g5
/* 0x189c	     */		sra	%g3,31,%l4
/* 0x18a0	     */		sub	%i5,%l0,%o3
/* 0x18a4	     */		xor	%l7,%o4,%o0
/* 0x18a8	     */		xor	%g3,%l4,%o1
/* 0x18ac	     */		sra	%o3,31,%l3
/* 0x18b0	     */		sub	%i5,%i2,%o7
/* 0x18b4	     */		sub	%o0,%o4,%o0
/* 0x18b8	     */		sub	%i0,%l2,%o4
/* 0x18bc	     */		sra	%o7,31,%l5
/* 0x18c0	     */		xor	%o3,%l3,%o5
/* 0x18c4	     */		sub	%o1,%l4,%g4
/* 0x18c8	     */		xor	%o7,%l5,%l2
/* 0x18cc	     */		sub	%o5,%l3,%l7
/* 0x18d0	     */		sub	%i5,%i3,%o1
/* 0x18d4	     */		sra	%o1,31,%l4
/* 0x18d8	     */		sra	%o4,31,%l3
/* 0x18dc	     */		sub	%l2,%l5,%g3
/* 0x18e0	     */		xor	%o1,%l4,%o7
/* 0x18e4	     */		sub	%i0,%l6,%o5
/* 0x18e8	     */		xor	%o4,%l3,%l2
/* 0x18ec	     */		sub	%o7,%l4,%l5
/* 0x18f0	     */		sra	%o5,31,%o4
/* 0x18f4	     */		sub	%i0,%l1,%o3
/* 0x18f8	     */		xor	%o5,%o4,%o1
/* 0x18fc	     */		sub	%l2,%l3,%l2
/* 0x1900	     */		sra	%o3,31,%l4
/* 0x1904	     */		sub	%o1,%o4,%l3
/* 0x1908	     */		xor	%o3,%l4,%o7
/* 0x190c	     */		sub	%o7,%l4,%l4
/* 0x1910	     */		sra	%g5,0,%o1
/* 0x1914	     */		sra	%g2,0,%g2
/* 0x1918	     */		sub	%g2,%o2,%o7
/* 0x191c	     */		sub	%o1,%o2,%g5
/* 0x1920	     */		srlx	%o7,63,%g2
/* 0x1924	     */		srlx	%g5,63,%g5
/* 0x1928	     */		xor	%g2,1,%o3
/* 0x192c	     */		xor	%g5,1,%o5
/* 0x1930	     */		and	%o5,%o3,%o1
/* 0x1934	     */		sra	%o0,0,%o0
/* 0x1938	     */		sra	%g4,0,%g4
/* 0x193c	     */		sub	%o0,%o2,%o4
/* 0x1940	     */		sub	%g4,%o2,%o3
/* 0x1944	     */		srlx	%o4,63,%o0
/* 0x1948	     */		srlx	%o3,63,%g4
/* 0x194c	     */		xor	%o0,1,%o4
/* 0x1950	     */		xor	%g4,1,%o7
/* 0x1954	     */		and	%o7,%o4,%g2
/* 0x1958	     */		and	%g2,%o1,%o0
/* 0x195c	     */		sra	%l7,0,%g2
/* 0x1960	     */		sra	%g3,0,%g3
/* 0x1964	     */		sub	%g3,%o2,%o5
/* 0x1968	     */		sub	%g2,%o2,%o7
/* 0x196c	     */		srlx	%o5,63,%g3
/* 0x1970	     */		srlx	%o7,63,%l7
/* 0x1974	     */		xor	%g3,1,%g5
/* 0x1978	     */		xor	%l7,1,%o3
/* 0x197c	     */		and	%o3,%g5,%o5
/* 0x1980	     */		and	%o0,%o5,%o7
/* 0x1984	     */		sra	%l5,0,%o1
/* 0x1988	     */		sra	%l2,0,%o0
/* 0x198c	     */		sub	%o1,%o2,%g5
/* 0x1990	     */		sub	%o0,%o2,%o4
/* 0x1994	     */		srlx	%g5,63,%l5
/* 0x1998	     */		srlx	%o4,63,%l2
/* 0x199c	     */		xor	%l5,1,%g4
/* 0x19a0	     */		xor	%l2,1,%o1
/* 0x19a4	     */		and	%o1,%g4,%o4
/* 0x19a8	     */		and	%o7,%o4,%o0
/* 0x19ac	     */		sra	%l3,0,%o7
/* 0x19b0	     */		sra	%l4,0,%g2
/* 0x19b4	     */		sub	%o7,%o2,%g4
/* 0x19b8	     */		sub	%g2,%o2,%g3
/* 0x19bc	     */		srlx	%g3,63,%l4
/* 0x19c0	     */		srlx	%g4,63,%l3
/* 0x19c4	     */		xor	%l4,1,%g5
/* 0x19c8	     */		xor	%l3,1,%l7
/* 0x19cc	     */		and	%g5,%l7,%o3
/* 0x19d0	     */		andcc	%o0,%o3,%g0
/* 0x19d4	     */		be,a,pn	%icc,.L77004130
/* 0x19d8	     */		or	%g0,0,%l4

! Registers live out of .L77004137: 
! g1 o2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004137

			.L77004138:
/* 0x19dc	 446 */		add	%fp,-1600,%l7
/* 0x19e0	     */		sub	%i2,%l7,%g5
/* 0x19e4	     */		sra	%g5,31,%o3
/* 0x19e8	     */		sub	%i0,%i3,%o0
/* 0x19ec	     */		sra	%o0,31,%l3
/* 0x19f0	     */		xor	%g5,%o3,%o5
/* 0x19f4	     */		sub	%i0,%i2,%l2
/* 0x19f8	     */		xor	%o0,%l3,%o1
/* 0x19fc	     */		sub	%o5,%o3,%l5
/* 0x1a00	     */		sra	%l2,31,%o4
/* 0x1a04	     */		sub	%i2,%l6,%g3
/* 0x1a08	     */		sub	%o1,%l3,%l4
/* 0x1a0c	     */		xor	%l2,%o4,%l7
/* 0x1a10	     */		sra	%g3,31,%o5
/* 0x1a14	     */		sub	%i0,%l0,%g2
/* 0x1a18	     */		sra	%g2,31,%o7
/* 0x1a1c	     */		xor	%g3,%o5,%o1
/* 0x1a20	     */		sub	%l7,%o4,%o0
/* 0x1a24	     */		sub	%i2,%l1,%g4
/* 0x1a28	     */		xor	%g2,%o7,%o4
/* 0x1a2c	     */		sra	%g4,31,%l2
/* 0x1a30	     */		sub	%i2,%l0,%o3
/* 0x1a34	     */		sub	%o1,%o5,%g3
/* 0x1a38	     */		sra	%o3,31,%o1
/* 0x1a3c	     */		sub	%o4,%o7,%g5
/* 0x1a40	     */		sub	%i2,%i3,%g2
/* 0x1a44	     */		xor	%g4,%l2,%g4
/* 0x1a48	     */		sub	%g4,%l2,%l7
/* 0x1a4c	     */		xor	%o3,%o1,%o7
/* 0x1a50	     */		sra	%g2,31,%l3
/* 0x1a54	     */		xor	%g2,%l3,%o4
/* 0x1a58	     */		sub	%o7,%o1,%l2
/* 0x1a5c	     */		sub	%o4,%l3,%l3
/* 0x1a60	     */		sra	%l4,0,%o7
/* 0x1a64	     */		sra	%l5,0,%o5
/* 0x1a68	     */		sra	%o0,0,%o0
/* 0x1a6c	     */		sra	%g5,0,%g5
/* 0x1a70	     */		sub	%o7,%o2,%o1
/* 0x1a74	     */		sub	%o5,%o2,%o3
/* 0x1a78	     */		sub	%o0,%o2,%o4
/* 0x1a7c	     */		sub	%g5,%o2,%g2
/* 0x1a80	     */		srlx	%o1,63,%l4
/* 0x1a84	     */		srlx	%o3,63,%l5
/* 0x1a88	     */		srlx	%o4,63,%o0
/* 0x1a8c	     */		srlx	%g2,63,%g5
/* 0x1a90	     */		xor	%l4,1,%g4
/* 0x1a94	     */		xor	%l5,1,%o5
/* 0x1a98	     */		xor	%o0,1,%o3
/* 0x1a9c	     */		xor	%g5,1,%g2
/* 0x1aa0	     */		and	%o5,%g4,%o7
/* 0x1aa4	     */		and	%o3,%g2,%o4
/* 0x1aa8	     */		and	%o4,%o7,%g4
/* 0x1aac	     */		sra	%l7,0,%o1
/* 0x1ab0	     */		sra	%g3,0,%g3
/* 0x1ab4	     */		sub	%g3,%o2,%o7
/* 0x1ab8	     */		sub	%o1,%o2,%o5
/* 0x1abc	     */		srlx	%o7,63,%g3
/* 0x1ac0	     */		srlx	%o5,63,%l7
/* 0x1ac4	     */		xor	%g3,1,%l5
/* 0x1ac8	     */		xor	%l7,1,%o1
/* 0x1acc	     */		and	%o1,%l5,%l4
/* 0x1ad0	     */		and	%g4,%l4,%o7
/* 0x1ad4	     */		sra	%l3,0,%g4
/* 0x1ad8	     */		sub	%g4,%o2,%o3
/* 0x1adc	     */		sra	%l2,0,%o5
/* 0x1ae0	     */		sub	%o5,%o2,%o2
/* 0x1ae4	     */		srlx	%o3,63,%l3
/* 0x1ae8	     */		srlx	%o2,63,%l2
/* 0x1aec	     */		xor	%l3,1,%g5
/* 0x1af0	     */		xor	%l2,1,%o0
/* 0x1af4	     */		and	%g5,%o0,%g2
/* 0x1af8	     */		andcc	%o7,%g2,%g0
/* 0x1afc	     */		be,a,pn	%icc,.L77004130
/* 0x1b00	     */		or	%g0,0,%l4

! Registers live out of .L77004138: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004138

			.L77004188:
/* 0x1b04	 446 */		sethi	%hi(0x1000),%g1
/* 0x1b08	     */		xor	%g1,-704,%g1
/* 0x1b0c	     */		add	%g1,%fp,%l4
/* 0x1b10	     */		sethi	%hi(0x1800),%g1
/* 0x1b14	     */		xor	%g1,-256,%g1
/* 0x1b18	     */		add	%i1,-1,%g2
/* 0x1b1c	     */		or	%g0,0,%l7
/* 0x1b20	     */		add	%fp,-1600,%l6
/* 0x1b24	     */		add	%fp,-3200,%l5

!  447		      !            if (mask[i]) {

/* 0x1b28	 447 */		ldub	[%i3],%o5
/* 0x1b2c	 446 */		add	%g1,%fp,%l3

! Registers live out of .L77004188: 
! g2 o5 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003809 .L77004188

			.L900000483:
/* 0x1b30	 447 */		cmp	%o5,0
/* 0x1b34	     */		be,pn	%icc,.L77003809
/* 0x1b38	 446 */		add	%l7,1,%l7

! Registers live out of .L900000483: 
! g2 o5 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  448		      !               red[i]   = ~(red[i]   & rdest[i]);

                       
! predecessor blocks: .L900000483

			.L77003807:
/* 0x1b3c	 448 */		ldub	[%i4],%o4
/* 0x1b40	     */		ldub	[%l6],%o1

!  449		      !               green[i] = ~(green[i] & gdest[i]);

/* 0x1b44	 449 */		ldub	[%i5],%l1

!  450		      !               blue[i]  = ~(blue[i]  & bdest[i]);

/* 0x1b48	 450 */		ldub	[%i0],%o3

!  451		      !               alpha[i] = ~(alpha[i] & adest[i]);

/* 0x1b4c	 451 */		ldub	[%i2],%o0
/* 0x1b50	 449 */		ldub	[%l5],%o5
/* 0x1b54	 448 */		and	%o4,%o1,%o2
/* 0x1b58	 450 */		ldub	[%l4],%l0
/* 0x1b5c	 449 */		and	%l1,%o5,%l2
/* 0x1b60	 451 */		ldub	[%l3],%g5
/* 0x1b64	 450 */		and	%o3,%l0,%g3
/* 0x1b68	 448 */		xnor	%o2,0,%i1
/* 0x1b6c	     */		stb	%i1,[%i4]
/* 0x1b70	 451 */		and	%o0,%g5,%o1
/* 0x1b74	 449 */		xnor	%l2,0,%o7
/* 0x1b78	     */		stb	%o7,[%i5]
/* 0x1b7c	 450 */		xnor	%g3,0,%g4
/* 0x1b80	     */		stb	%g4,[%i0]
/* 0x1b84	 451 */		xnor	%o1,0,%o4
/* 0x1b88	     */		stb	%o4,[%i2]

! Registers live out of .L77003807: 
! g2 o5 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003807 .L900000483

			.L77003809:
/* 0x1b8c	 446 */		cmp	%l7,%g2
/* 0x1b90	     */		add	%i3,1,%i3
/* 0x1b94	     */		add	%l3,1,%l3
/* 0x1b98	     */		add	%l4,1,%l4
/* 0x1b9c	     */		add	%l5,1,%l5
/* 0x1ba0	     */		add	%l6,1,%l6
/* 0x1ba4	     */		add	%i2,1,%i2
/* 0x1ba8	     */		add	%i0,1,%i0
/* 0x1bac	     */		add	%i5,1,%i5
/* 0x1bb0	     */		add	%i4,1,%i4
/* 0x1bb4	     */		ble,a,pt	%icc,.L900000483
/* 0x1bb8	 447 */		ldub	[%i3],%o5

! Registers live out of .L77003809: 
! g2 o5 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003809

			.L77004133:
/* 0x1bbc	 446 */		ba	.L77003932
/* 0x1bc0	     */		nop

! Registers live out of .L77004133: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003964

			.L77004351:
/* 0x1bc4	 446 */		ld	[%fp+92],%i0
/* 0x1bc8	     */		ld	[%fp+96],%i2
/* 0x1bcc	     */		or	%g0,0,%l4

! Registers live out of .L77004351: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004136 .L77004137 .L77004138 .L77004351

			.L77004130:
/* 0x1bd0	 447 */		ldub	[%l4+%i3],%g2

! Registers live out of .L77004130: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004130 .L77004132

			.L900000482:
/* 0x1bd4	 447 */		cmp	%g2,0
/* 0x1bd8	     */		be,pn	%icc,.L77004132
/* 0x1bdc	 448 */		add	%fp,-1600,%l3

! Registers live out of .L900000482: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000482

			.L77004131:
/* 0x1be0	 448 */		ldub	[%l4+%l3],%o2
/* 0x1be4	     */		ldub	[%i4+%l4],%g2
/* 0x1be8	     */		and	%g2,%o2,%g3
/* 0x1bec	     */		xnor	%g3,0,%o7
/* 0x1bf0	     */		stb	%o7,[%i4+%l4]
/* 0x1bf4	 449 */		ldub	[%l4+%l6],%g5
/* 0x1bf8	     */		ldub	[%i5+%l4],%l2
/* 0x1bfc	     */		and	%l2,%g5,%o1
/* 0x1c00	     */		xnor	%o1,0,%o4
/* 0x1c04	     */		stb	%o4,[%i5+%l4]
/* 0x1c08	 450 */		ldub	[%l4+%l1],%o0
/* 0x1c0c	     */		ldub	[%l4+%i0],%l5
/* 0x1c10	     */		and	%l5,%o0,%o3
/* 0x1c14	     */		xnor	%o3,0,%l3
/* 0x1c18	     */		stb	%l3,[%l4+%i0]
/* 0x1c1c	 451 */		ldub	[%l4+%l0],%g4
/* 0x1c20	     */		ldub	[%l4+%i2],%l7
/* 0x1c24	     */		and	%l7,%g4,%o5
/* 0x1c28	     */		xnor	%o5,0,%o2
/* 0x1c2c	     */		stb	%o2,[%l4+%i2]

! Registers live out of .L77004131: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004131 .L900000482

			.L77004132:
/* 0x1c30	 446 */		add	%l4,1,%l4
/* 0x1c34	     */		cmp	%l4,%i1
/* 0x1c38	     */		bcs,a,pn	%icc,.L900000482
/* 0x1c3c	 447 */		ldub	[%l4+%i3],%g2

! Registers live out of .L77004132: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004132

			.L900000457:
/* 0x1c40	 446 */		ba	.L77003932
/* 0x1c44	     */		nop

! Registers live out of .L900000457: 
! sp fp i7 gsr 
! 
		
!  452		      !            }
!  453		      !         }
!  454		      !         break;
!  455		      !      case GL_OR:
!  456		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003815:
/* 0x1c48	 456 */		cmp	%i1,0
/* 0x1c4c	     */		bleu,pn	%icc,.L77003932
/* 0x1c50	     */		cmp	%i1,54

! Registers live out of .L77003815: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003815

			.L77003956:
/* 0x1c54	 456 */		ld	[%fp+100],%i3
/* 0x1c58	     */		bl,pn	%icc,.L77004337
/* 0x1c5c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003956: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003956

			.L77004042:
/* 0x1c60	 456 */		sra	%i0,31,%o1
/* 0x1c64	     */		xor	%i0,%o1,%i2
/* 0x1c68	     */		sub	%i2,%o1,%l7
/* 0x1c6c	     */		sub	%i4,%l6,%o5
/* 0x1c70	     */		sub	%i4,%i3,%i0
/* 0x1c74	     */		sra	%o5,31,%g4
/* 0x1c78	     */		sra	%i0,31,%i2
/* 0x1c7c	     */		xor	%o5,%g4,%l2
/* 0x1c80	     */		xor	%i0,%i2,%o1
/* 0x1c84	     */		add	%fp,-1600,%g5
/* 0x1c88	     */		sub	%i4,%g5,%o4
/* 0x1c8c	     */		sub	%o1,%i2,%o5
/* 0x1c90	     */		sub	%i4,%l1,%l5
/* 0x1c94	     */		sub	%i4,%l0,%g5
/* 0x1c98	     */		sra	%l5,31,%g2
/* 0x1c9c	     */		sra	%g5,31,%o7
/* 0x1ca0	     */		xor	%l5,%g2,%o0
/* 0x1ca4	     */		xor	%g5,%o7,%o3
/* 0x1ca8	     */		sub	%l2,%g4,%g3
/* 0x1cac	     */		sub	%o0,%g2,%l2
/* 0x1cb0	     */		sra	%o4,31,%l3
/* 0x1cb4	     */		sub	%o3,%o7,%o0
/* 0x1cb8	     */		xor	%o4,%l3,%o2
/* 0x1cbc	     */		sra	%l7,0,%g2
/* 0x1cc0	     */		sub	%o2,%l3,%l4
/* 0x1cc4	     */		sra	%l4,0,%g4
/* 0x1cc8	     */		sra	%l2,0,%o7
/* 0x1ccc	     */		sra	%g3,0,%g3
/* 0x1cd0	     */		sra	%o0,0,%o0
/* 0x1cd4	     */		ld	[%fp+96],%i2
/* 0x1cd8	     */		ld	[%fp+92],%i0
/* 0x1cdc	     */		sub	%i4,%i2,%g5
/* 0x1ce0	     */		sra	%g5,31,%o1
/* 0x1ce4	     */		xor	%g5,%o1,%o3
/* 0x1ce8	     */		sub	%o3,%o1,%l7
/* 0x1cec	     */		sub	%i4,%i0,%o4
/* 0x1cf0	     */		sra	%i1,0,%o1
/* 0x1cf4	     */		sra	%o4,31,%l3
/* 0x1cf8	     */		xor	%o4,%l3,%o2
/* 0x1cfc	     */		sub	%g2,%o1,%g5
/* 0x1d00	     */		sub	%o2,%l3,%l5
/* 0x1d04	     */		sub	%g4,%o1,%g2
/* 0x1d08	     */		sra	%l5,0,%o2
/* 0x1d0c	     */		srlx	%g5,63,%l2
/* 0x1d10	     */		srlx	%g2,63,%l4
/* 0x1d14	     */		sra	%l7,0,%o3
/* 0x1d18	     */		sub	%g3,%o1,%g5
/* 0x1d1c	     */		sub	%o7,%o1,%g2
/* 0x1d20	     */		sub	%o2,%o1,%g4
/* 0x1d24	     */		sra	%o5,0,%o4
/* 0x1d28	     */		srlx	%g5,63,%l3
/* 0x1d2c	     */		srlx	%g2,63,%o5
/* 0x1d30	     */		srlx	%g4,63,%l5
/* 0x1d34	     */		sub	%o3,%o1,%o2
/* 0x1d38	     */		sub	%o0,%o1,%o0
/* 0x1d3c	     */		srlx	%o0,63,%g3
/* 0x1d40	     */		srlx	%o2,63,%g4
/* 0x1d44	     */		xor	%l2,1,%g2
/* 0x1d48	     */		xor	%l3,1,%o7
/* 0x1d4c	     */		and	%o7,%g2,%g5
/* 0x1d50	     */		xor	%g4,1,%o3
/* 0x1d54	     */		xor	%g3,1,%l7
/* 0x1d58	     */		and	%l7,%o3,%l3
/* 0x1d5c	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x1d60	     */		add	%g2,1022,%o3
/* 0x1d64	     */		srl	%i1,0,%g3
/* 0x1d68	     */		xor	%o5,1,%o0
/* 0x1d6c	     */		xor	%l5,1,%o2
/* 0x1d70	     */		sub	%g3,%o3,%o7
/* 0x1d74	     */		xor	%l4,1,%l4
/* 0x1d78	     */		and	%o0,%o2,%l5
/* 0x1d7c	     */		srlx	%o7,63,%o5
/* 0x1d80	     */		and	%o5,%l4,%o2
/* 0x1d84	     */		sub	%o4,%o1,%o4
/* 0x1d88	     */		srlx	%o4,63,%l2
/* 0x1d8c	     */		and	%o2,%g5,%o0
/* 0x1d90	     */		xor	%l2,1,%o4
/* 0x1d94	     */		and	%o0,%l5,%g3
/* 0x1d98	     */		and	%o4,1,%g4
/* 0x1d9c	     */		and	%g3,%l3,%o3
/* 0x1da0	     */		andcc	%o3,%g4,%g0
/* 0x1da4	     */		be,a,pn	%icc,.L77004036
/* 0x1da8	     */		or	%g0,0,%l4

! Registers live out of .L77004042: 
! g1 o1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004042

			.L77004043:
/* 0x1dac	 456 */		sub	%i5,%i0,%g2
/* 0x1db0	     */		sra	%g2,31,%l4
/* 0x1db4	     */		xor	%g2,%l4,%l3
/* 0x1db8	     */		sub	%i5,%l1,%l5
/* 0x1dbc	     */		add	%fp,-1600,%o0
/* 0x1dc0	     */		sub	%i5,%o0,%o4
/* 0x1dc4	     */		sub	%l3,%l4,%g2
/* 0x1dc8	     */		sra	%l5,31,%l2
/* 0x1dcc	     */		xor	%l5,%l2,%o7
/* 0x1dd0	     */		sra	%o4,31,%l4
/* 0x1dd4	     */		sub	%o7,%l2,%g5
/* 0x1dd8	     */		xor	%o4,%l4,%l5
/* 0x1ddc	     */		sub	%i5,%i2,%o5
/* 0x1de0	     */		sub	%i0,%o0,%o4
/* 0x1de4	     */		sra	%o5,31,%l2
/* 0x1de8	     */		sub	%i5,%l6,%l7
/* 0x1dec	     */		sra	%l7,31,%l3
/* 0x1df0	     */		xor	%o5,%l2,%o0
/* 0x1df4	     */		xor	%l7,%l3,%o2
/* 0x1df8	     */		sub	%i5,%l0,%o3
/* 0x1dfc	     */		sub	%l5,%l4,%g4
/* 0x1e00	     */		sub	%o0,%l2,%g3
/* 0x1e04	     */		sub	%o2,%l3,%o7
/* 0x1e08	     */		sub	%i5,%i3,%l5
/* 0x1e0c	     */		sra	%o3,31,%l7
/* 0x1e10	     */		sra	%o4,31,%l2
/* 0x1e14	     */		xor	%o3,%l7,%o2
/* 0x1e18	     */		sra	%l5,31,%l3
/* 0x1e1c	     */		xor	%o4,%l2,%o0
/* 0x1e20	     */		xor	%l5,%l3,%l4
/* 0x1e24	     */		sub	%i0,%l1,%o3
/* 0x1e28	     */		sub	%o0,%l2,%l2
/* 0x1e2c	     */		sub	%l4,%l3,%l5
/* 0x1e30	     */		sra	%o3,31,%o0
/* 0x1e34	     */		sub	%i0,%l6,%o5
/* 0x1e38	     */		sra	%o5,31,%o4
/* 0x1e3c	     */		sub	%o2,%l7,%l7
/* 0x1e40	     */		xor	%o3,%o0,%l4
/* 0x1e44	     */		xor	%o5,%o4,%o2
/* 0x1e48	     */		sra	%g2,0,%o3
/* 0x1e4c	     */		sub	%o3,%o1,%o5
/* 0x1e50	     */		sub	%o2,%o4,%l3
/* 0x1e54	     */		srlx	%o5,63,%g2
/* 0x1e58	     */		xor	%g2,1,%o3
/* 0x1e5c	     */		sra	%o7,0,%o2
/* 0x1e60	     */		sub	%o2,%o1,%g2
/* 0x1e64	     */		sub	%l4,%o0,%l4
/* 0x1e68	     */		srlx	%g2,63,%o7
/* 0x1e6c	     */		sra	%g5,0,%o0
/* 0x1e70	     */		xor	%o7,1,%o2
/* 0x1e74	     */		sra	%g4,0,%g4
/* 0x1e78	     */		sub	%g4,%o1,%o7
/* 0x1e7c	     */		sub	%o0,%o1,%g5
/* 0x1e80	     */		srlx	%o7,63,%g4
/* 0x1e84	     */		srlx	%g5,63,%g5
/* 0x1e88	     */		xor	%g5,1,%o5
/* 0x1e8c	     */		xor	%g4,1,%o0
/* 0x1e90	     */		and	%o5,%o3,%o4
/* 0x1e94	     */		and	%o0,%o2,%g2
/* 0x1e98	     */		and	%g2,%o4,%o7
/* 0x1e9c	     */		sra	%l7,0,%o3
/* 0x1ea0	     */		sra	%g3,0,%g3
/* 0x1ea4	     */		sub	%g3,%o1,%o4
/* 0x1ea8	     */		sub	%o3,%o1,%o5
/* 0x1eac	     */		srlx	%o4,63,%g3
/* 0x1eb0	     */		srlx	%o5,63,%l7
/* 0x1eb4	     */		xor	%g3,1,%g5
/* 0x1eb8	     */		xor	%l7,1,%o3
/* 0x1ebc	     */		and	%o3,%g5,%o5
/* 0x1ec0	     */		sra	%l5,0,%o0
/* 0x1ec4	     */		sub	%o0,%o1,%g5
/* 0x1ec8	     */		sra	%l2,0,%o2
/* 0x1ecc	     */		sra	%l3,0,%o0
/* 0x1ed0	     */		srlx	%g5,63,%l5
/* 0x1ed4	     */		sub	%o2,%o1,%g2
/* 0x1ed8	     */		sub	%o0,%o1,%g5
/* 0x1edc	     */		srlx	%g2,63,%l2
/* 0x1ee0	     */		sra	%l4,0,%o0
/* 0x1ee4	     */		sub	%o0,%o1,%g2
/* 0x1ee8	     */		srlx	%g2,63,%l4
/* 0x1eec	     */		srlx	%g5,63,%l3
/* 0x1ef0	     */		xor	%l5,1,%g4
/* 0x1ef4	     */		xor	%l2,1,%o4
/* 0x1ef8	     */		xor	%l4,1,%g5
/* 0x1efc	     */		and	%o7,%o5,%g3
/* 0x1f00	     */		and	%o4,%g4,%o2
/* 0x1f04	     */		xor	%l3,1,%l7
/* 0x1f08	     */		and	%g3,%o2,%o7
/* 0x1f0c	     */		and	%g5,%l7,%o3
/* 0x1f10	     */		andcc	%o7,%o3,%g0
/* 0x1f14	     */		be,a,pn	%icc,.L77004036
/* 0x1f18	     */		or	%g0,0,%l4

! Registers live out of .L77004043: 
! g1 o1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004043

			.L77004044:
/* 0x1f1c	 456 */		add	%fp,-1600,%g4
/* 0x1f20	     */		sub	%i2,%g4,%l2
/* 0x1f24	     */		sra	%l2,31,%o2
/* 0x1f28	     */		sub	%i0,%i3,%o3
/* 0x1f2c	     */		sub	%i0,%i2,%l7
/* 0x1f30	     */		sra	%o3,31,%g5
/* 0x1f34	     */		xor	%l2,%o2,%o7
/* 0x1f38	     */		sra	%l7,31,%o5
/* 0x1f3c	     */		xor	%o3,%g5,%o0
/* 0x1f40	     */		sub	%o7,%o2,%l5
/* 0x1f44	     */		xor	%l7,%o5,%o4
/* 0x1f48	     */		sub	%i0,%l0,%g2
/* 0x1f4c	     */		sra	%g2,31,%o3
/* 0x1f50	     */		sub	%i2,%l6,%g3
/* 0x1f54	     */		sub	%o4,%o5,%o2
/* 0x1f58	     */		sub	%o0,%g5,%l4
/* 0x1f5c	     */		xor	%g2,%o3,%o5
/* 0x1f60	     */		sra	%g3,31,%o7
/* 0x1f64	     */		xor	%g3,%o7,%o0
/* 0x1f68	     */		sub	%o5,%o3,%g5
/* 0x1f6c	     */		sub	%i2,%i3,%g2
/* 0x1f70	     */		sub	%i2,%l0,%o5
/* 0x1f74	     */		sub	%o0,%o7,%g3
/* 0x1f78	     */		sra	%g2,31,%l3
/* 0x1f7c	     */		xor	%g2,%l3,%l2
/* 0x1f80	     */		sra	%o5,31,%o0
/* 0x1f84	     */		sub	%i2,%l1,%g4
/* 0x1f88	     */		sra	%g4,31,%o4
/* 0x1f8c	     */		xor	%o5,%o0,%o3
/* 0x1f90	     */		sub	%l2,%l3,%l3
/* 0x1f94	     */		sub	%o3,%o0,%l2
/* 0x1f98	     */		xor	%g4,%o4,%g4
/* 0x1f9c	     */		sub	%g4,%o4,%l7
/* 0x1fa0	     */		sra	%l4,0,%o3
/* 0x1fa4	     */		sra	%l5,0,%o7
/* 0x1fa8	     */		sra	%o2,0,%o2
/* 0x1fac	     */		sra	%g5,0,%g5
/* 0x1fb0	     */		sub	%o3,%o1,%o0
/* 0x1fb4	     */		sub	%o7,%o1,%o4
/* 0x1fb8	     */		sub	%o2,%o1,%o5
/* 0x1fbc	     */		sub	%g5,%o1,%g2
/* 0x1fc0	     */		srlx	%o0,63,%l4
/* 0x1fc4	     */		srlx	%o4,63,%l5
/* 0x1fc8	     */		srlx	%o5,63,%o2
/* 0x1fcc	     */		srlx	%g2,63,%g5
/* 0x1fd0	     */		xor	%l4,1,%g4
/* 0x1fd4	     */		xor	%l5,1,%o7
/* 0x1fd8	     */		xor	%o2,1,%o5
/* 0x1fdc	     */		xor	%g5,1,%o4
/* 0x1fe0	     */		and	%o7,%g4,%o3
/* 0x1fe4	     */		and	%o5,%o4,%g2
/* 0x1fe8	     */		and	%g2,%o3,%g4
/* 0x1fec	     */		sra	%l7,0,%o0
/* 0x1ff0	     */		sra	%g3,0,%g3
/* 0x1ff4	     */		sub	%o0,%o1,%o7
/* 0x1ff8	     */		sub	%g3,%o1,%o3
/* 0x1ffc	     */		srlx	%o7,63,%l7
/* 0x2000	     */		srlx	%o3,63,%g3
/* 0x2004	     */		xor	%g3,1,%l5
/* 0x2008	     */		xor	%l7,1,%o0
/* 0x200c	     */		and	%o0,%l5,%l4
/* 0x2010	     */		and	%g4,%l4,%o5
/* 0x2014	     */		sra	%l3,0,%g4
/* 0x2018	     */		sub	%g4,%o1,%o4
/* 0x201c	     */		sra	%l2,0,%o7
/* 0x2020	     */		sub	%o7,%o1,%o1
/* 0x2024	     */		srlx	%o4,63,%l3
/* 0x2028	     */		srlx	%o1,63,%l2
/* 0x202c	     */		xor	%l3,1,%g5
/* 0x2030	     */		xor	%l2,1,%o2
/* 0x2034	     */		and	%g5,%o2,%o4
/* 0x2038	     */		andcc	%o5,%o4,%g0
/* 0x203c	     */		be,a,pn	%icc,.L77004036
/* 0x2040	     */		or	%g0,0,%l4

! Registers live out of .L77004044: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004044

			.L77004195:
/* 0x2044	 456 */		sethi	%hi(0x1000),%g1
/* 0x2048	     */		xor	%g1,-704,%g1
/* 0x204c	     */		add	%g1,%fp,%g2
/* 0x2050	     */		sethi	%hi(0x1800),%g1
/* 0x2054	     */		xor	%g1,-256,%g1
/* 0x2058	     */		add	%i1,-1,%o0
/* 0x205c	     */		or	%g0,0,%g5
/* 0x2060	     */		add	%fp,-1600,%g4
/* 0x2064	     */		add	%fp,-3200,%g3

!  457		      !            if (mask[i]) {

/* 0x2068	 457 */		ldub	[%i3],%o7
/* 0x206c	 456 */		add	%g1,%fp,%l7

! Registers live out of .L77004195: 
! g2 g3 g4 g5 o0 sp o7 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003823 .L77004195

			.L900000481:
/* 0x2070	 457 */		cmp	%o7,0
/* 0x2074	     */		be,pn	%icc,.L77003823
/* 0x2078	 456 */		add	%g5,1,%g5

! Registers live out of .L900000481: 
! g2 g3 g4 g5 o0 sp o7 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  458		      !               red[i]   |= rdest[i];

                       
! predecessor blocks: .L900000481

			.L77003821:
/* 0x207c	 458 */		ldub	[%i4],%o5

!  459		      !               green[i] |= gdest[i];

/* 0x2080	 459 */		ldub	[%i5],%o2

!  460		      !               blue[i]  |= bdest[i];

/* 0x2084	 460 */		ldub	[%i0],%l3

!  461		      !               alpha[i] |= adest[i];

/* 0x2088	 461 */		ldub	[%i2],%l6
/* 0x208c	 458 */		ldub	[%g4],%o4
/* 0x2090	 459 */		ldub	[%g3],%l1
/* 0x2094	 460 */		ldub	[%g2],%i1
/* 0x2098	 461 */		ldub	[%l7],%l5
/* 0x209c	 458 */		or	%o5,%o4,%l0
/* 0x20a0	     */		stb	%l0,[%i4]
/* 0x20a4	 459 */		or	%o2,%l1,%l2
/* 0x20a8	     */		stb	%l2,[%i5]
/* 0x20ac	 460 */		or	%l3,%i1,%l4
/* 0x20b0	     */		stb	%l4,[%i0]
/* 0x20b4	 461 */		or	%l6,%l5,%o3
/* 0x20b8	     */		stb	%o3,[%i2]

! Registers live out of .L77003821: 
! g2 g3 g4 g5 o0 sp o7 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003821 .L900000481

			.L77003823:
/* 0x20bc	 456 */		cmp	%g5,%o0
/* 0x20c0	     */		add	%i3,1,%i3
/* 0x20c4	     */		add	%l7,1,%l7
/* 0x20c8	     */		add	%g2,1,%g2
/* 0x20cc	     */		add	%g3,1,%g3
/* 0x20d0	     */		add	%g4,1,%g4
/* 0x20d4	     */		add	%i2,1,%i2
/* 0x20d8	     */		add	%i0,1,%i0
/* 0x20dc	     */		add	%i5,1,%i5
/* 0x20e0	     */		add	%i4,1,%i4
/* 0x20e4	     */		ble,a,pt	%icc,.L900000481
/* 0x20e8	 457 */		ldub	[%i3],%o7

! Registers live out of .L77003823: 
! g2 g3 g4 g5 o0 sp o7 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003823

			.L77004039:
/* 0x20ec	 456 */		ba	.L77003932
/* 0x20f0	     */		nop

! Registers live out of .L77004039: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003956

			.L77004337:
/* 0x20f4	 456 */		ld	[%fp+92],%i0
/* 0x20f8	     */		ld	[%fp+96],%i2
/* 0x20fc	     */		or	%g0,0,%l4

! Registers live out of .L77004337: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004042 .L77004043 .L77004044 .L77004337

			.L77004036:
/* 0x2100	 457 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004036: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004036 .L77004038

			.L900000480:
/* 0x2104	 457 */		cmp	%g3,0
/* 0x2108	     */		be,pn	%icc,.L77004038
/* 0x210c	 458 */		add	%fp,-1600,%o2

! Registers live out of .L900000480: 
! g1 g3 o2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000480

			.L77004037:
/* 0x2110	 458 */		ldub	[%l4+%o2],%o1
/* 0x2114	     */		ldub	[%i4+%l4],%g2
/* 0x2118	     */		or	%g2,%o1,%o7
/* 0x211c	     */		stb	%o7,[%i4+%l4]
/* 0x2120	 459 */		ldub	[%l4+%l6],%g5
/* 0x2124	     */		ldub	[%i5+%l4],%l7
/* 0x2128	     */		or	%l7,%g5,%l2
/* 0x212c	     */		stb	%l2,[%i5+%l4]
/* 0x2130	 460 */		ldub	[%l4+%l1],%o4
/* 0x2134	     */		ldub	[%l4+%i0],%o5
/* 0x2138	     */		or	%o5,%o4,%o2
/* 0x213c	     */		stb	%o2,[%l4+%i0]
/* 0x2140	 461 */		ldub	[%l4+%l0],%l5
/* 0x2144	     */		ldub	[%l4+%i2],%o0
/* 0x2148	     */		or	%o0,%l5,%l3
/* 0x214c	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004037: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004037 .L900000480

			.L77004038:
/* 0x2150	 456 */		add	%l4,1,%l4
/* 0x2154	     */		cmp	%l4,%i1
/* 0x2158	     */		bcs,a,pn	%icc,.L900000480
/* 0x215c	 457 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004038: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004038

			.L900000456:
/* 0x2160	 456 */		ba	.L77003932
/* 0x2164	     */		nop

! Registers live out of .L900000456: 
! sp fp i7 gsr 
! 
		
!  462		      !            }
!  463		      !         }
!  464		      !         break;
!  465		      !      case GL_NOR:
!  466		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003829:
/* 0x2168	 466 */		cmp	%i1,0
/* 0x216c	     */		bleu,pn	%icc,.L77003932
/* 0x2170	     */		cmp	%i1,54

! Registers live out of .L77003829: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003829

			.L77003955:
/* 0x2174	 466 */		ld	[%fp+100],%i3
/* 0x2178	     */		bl,pn	%icc,.L77004339
/* 0x217c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003955: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003955

			.L77004030:
/* 0x2180	 466 */		sra	%i0,31,%o0
/* 0x2184	     */		xor	%i0,%o0,%i2
/* 0x2188	     */		sub	%i4,%l6,%o2
/* 0x218c	     */		sub	%i4,%l0,%g5
/* 0x2190	     */		add	%fp,-1600,%o3
/* 0x2194	     */		sub	%i4,%o3,%o1
/* 0x2198	     */		sub	%i2,%o0,%l7
/* 0x219c	     */		sra	%o2,31,%g4
/* 0x21a0	     */		sra	%g5,31,%o5
/* 0x21a4	     */		sub	%i4,%i3,%i0
/* 0x21a8	     */		xor	%o2,%g4,%l2
/* 0x21ac	     */		xor	%g5,%o5,%o3
/* 0x21b0	     */		sra	%i0,31,%i2
/* 0x21b4	     */		sub	%o3,%o5,%o0
/* 0x21b8	     */		xor	%i0,%i2,%o2
/* 0x21bc	     */		sub	%o2,%i2,%o5
/* 0x21c0	     */		sub	%i4,%l1,%l5
/* 0x21c4	     */		sra	%l5,31,%g2
/* 0x21c8	     */		xor	%l5,%g2,%l3
/* 0x21cc	     */		sub	%l2,%g4,%g3
/* 0x21d0	     */		sub	%l3,%g2,%l2
/* 0x21d4	     */		sra	%o1,31,%o7
/* 0x21d8	     */		xor	%o1,%o7,%o4
/* 0x21dc	     */		sra	%l7,0,%g2
/* 0x21e0	     */		sub	%o4,%o7,%l4
/* 0x21e4	     */		sra	%l2,0,%o7
/* 0x21e8	     */		sra	%l4,0,%g4
/* 0x21ec	     */		sra	%g3,0,%g3
/* 0x21f0	     */		sra	%o5,0,%o5
/* 0x21f4	     */		ld	[%fp+96],%i2
/* 0x21f8	     */		ld	[%fp+92],%i0
/* 0x21fc	     */		sub	%i4,%i2,%g5
/* 0x2200	     */		sra	%g5,31,%l3
/* 0x2204	     */		xor	%g5,%l3,%o3
/* 0x2208	     */		sub	%o3,%l3,%l7
/* 0x220c	     */		sub	%i4,%i0,%o1
/* 0x2210	     */		sra	%o1,31,%l5
/* 0x2214	     */		sra	%o0,0,%o3
/* 0x2218	     */		sra	%i1,0,%o0
/* 0x221c	     */		xor	%o1,%l5,%o4
/* 0x2220	     */		sub	%g2,%o0,%o1
/* 0x2224	     */		sub	%o4,%l5,%o2
/* 0x2228	     */		srlx	%o1,63,%l2
/* 0x222c	     */		sra	%o2,0,%g5
/* 0x2230	     */		sub	%g4,%o0,%o1
/* 0x2234	     */		sub	%g3,%o0,%o2
/* 0x2238	     */		srlx	%o1,63,%l4
/* 0x223c	     */		srlx	%o2,63,%l3
/* 0x2240	     */		sub	%g5,%o0,%g2
/* 0x2244	     */		sub	%o3,%o0,%o1
/* 0x2248	     */		sra	%l7,0,%o4
/* 0x224c	     */		sub	%o7,%o0,%o7
/* 0x2250	     */		srlx	%o7,63,%l5
/* 0x2254	     */		srlx	%g2,63,%o2
/* 0x2258	     */		srlx	%o1,63,%g3
/* 0x225c	     */		sub	%o4,%o0,%o4
/* 0x2260	     */		srlx	%o4,63,%g4
/* 0x2264	     */		xor	%l2,1,%o7
/* 0x2268	     */		xor	%l3,1,%g2
/* 0x226c	     */		sub	%o5,%o0,%o1
/* 0x2270	     */		and	%g2,%o7,%g5
/* 0x2274	     */		xor	%l5,1,%o5
/* 0x2278	     */		xor	%o2,1,%o4
/* 0x227c	     */		and	%o5,%o4,%l5
/* 0x2280	     */		sethi	%hi(0x7ffffc00),%o7
/* 0x2284	     */		srl	%i1,0,%o5
/* 0x2288	     */		add	%o7,1022,%g2
/* 0x228c	     */		sub	%o5,%g2,%g2
/* 0x2290	     */		xor	%l4,1,%l4
/* 0x2294	     */		srlx	%g2,63,%o2
/* 0x2298	     */		and	%o2,%l4,%o4
/* 0x229c	     */		xor	%g4,1,%o3
/* 0x22a0	     */		srlx	%o1,63,%l2
/* 0x22a4	     */		xor	%g3,1,%l7
/* 0x22a8	     */		and	%o4,%g5,%o5
/* 0x22ac	     */		and	%l7,%o3,%l3
/* 0x22b0	     */		xor	%l2,1,%o1
/* 0x22b4	     */		and	%o5,%l5,%g3
/* 0x22b8	     */		and	%o1,1,%g4
/* 0x22bc	     */		and	%g3,%l3,%o3
/* 0x22c0	     */		andcc	%o3,%g4,%g0
/* 0x22c4	     */		be,a,pn	%icc,.L77004024
/* 0x22c8	     */		or	%g0,0,%l4

! Registers live out of .L77004030: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004030

			.L77004031:
/* 0x22cc	 466 */		sub	%i5,%i0,%g2
/* 0x22d0	     */		sra	%g2,31,%l4
/* 0x22d4	     */		xor	%g2,%l4,%o1
/* 0x22d8	     */		sub	%i5,%l1,%l5
/* 0x22dc	     */		add	%fp,-1600,%o5
/* 0x22e0	     */		sub	%i5,%o5,%o4
/* 0x22e4	     */		sub	%o1,%l4,%g2
/* 0x22e8	     */		sra	%l5,31,%o7
/* 0x22ec	     */		sub	%i5,%l6,%l7
/* 0x22f0	     */		xor	%l5,%o7,%l3
/* 0x22f4	     */		sra	%l7,31,%o1
/* 0x22f8	     */		sra	%o4,31,%l4
/* 0x22fc	     */		sub	%l3,%o7,%g5
/* 0x2300	     */		xor	%l7,%o1,%l2
/* 0x2304	     */		xor	%o4,%l4,%l5
/* 0x2308	     */		sub	%i5,%i2,%g3
/* 0x230c	     */		sub	%l2,%o1,%o2
/* 0x2310	     */		sub	%i0,%o5,%o4
/* 0x2314	     */		sra	%g3,31,%l3
/* 0x2318	     */		sub	%i5,%l0,%o3
/* 0x231c	     */		xor	%g3,%l3,%o5
/* 0x2320	     */		sra	%o3,31,%l2
/* 0x2324	     */		xor	%o3,%l2,%o7
/* 0x2328	     */		sub	%o5,%l3,%g3
/* 0x232c	     */		sub	%o7,%l2,%l7
/* 0x2330	     */		sra	%o4,31,%l3
/* 0x2334	     */		sub	%l5,%l4,%g4
/* 0x2338	     */		sub	%i5,%i3,%o1
/* 0x233c	     */		sra	%o1,31,%l4
/* 0x2340	     */		xor	%o4,%l3,%o7
/* 0x2344	     */		sub	%i0,%l6,%o5
/* 0x2348	     */		sub	%o7,%l3,%l2
/* 0x234c	     */		sra	%o5,31,%o4
/* 0x2350	     */		sub	%i0,%l1,%o3
/* 0x2354	     */		xor	%o1,%l4,%l5
/* 0x2358	     */		xor	%o5,%o4,%o1
/* 0x235c	     */		sra	%o3,31,%o7
/* 0x2360	     */		sub	%l5,%l4,%l5
/* 0x2364	     */		sub	%o1,%o4,%l3
/* 0x2368	     */		xor	%o3,%o7,%l4
/* 0x236c	     */		sub	%l4,%o7,%l4
/* 0x2370	     */		sra	%g2,0,%o1
/* 0x2374	     */		sra	%g5,0,%o4
/* 0x2378	     */		sub	%o1,%o0,%o7
/* 0x237c	     */		sub	%o4,%o0,%o5
/* 0x2380	     */		srlx	%o7,63,%g2
/* 0x2384	     */		srlx	%o5,63,%g5
/* 0x2388	     */		xor	%g2,1,%o3
/* 0x238c	     */		xor	%g5,1,%o5
/* 0x2390	     */		and	%o5,%o3,%o1
/* 0x2394	     */		sra	%o2,0,%o3
/* 0x2398	     */		sra	%g4,0,%g4
/* 0x239c	     */		sub	%g4,%o0,%g2
/* 0x23a0	     */		sub	%o3,%o0,%o2
/* 0x23a4	     */		srlx	%g2,63,%g4
/* 0x23a8	     */		srlx	%o2,63,%o2
/* 0x23ac	     */		xor	%o2,1,%o4
/* 0x23b0	     */		xor	%g4,1,%o7
/* 0x23b4	     */		and	%o7,%o4,%g2
/* 0x23b8	     */		and	%g2,%o1,%o5
/* 0x23bc	     */		sra	%l7,0,%o1
/* 0x23c0	     */		sra	%g3,0,%g3
/* 0x23c4	     */		sub	%g3,%o0,%g5
/* 0x23c8	     */		sub	%o1,%o0,%o7
/* 0x23cc	     */		srlx	%g5,63,%g3
/* 0x23d0	     */		srlx	%o7,63,%l7
/* 0x23d4	     */		xor	%g3,1,%g5
/* 0x23d8	     */		xor	%l7,1,%o3
/* 0x23dc	     */		and	%o3,%g5,%o2
/* 0x23e0	     */		and	%o5,%o2,%o7
/* 0x23e4	     */		sra	%l5,0,%o4
/* 0x23e8	     */		sra	%l2,0,%o3
/* 0x23ec	     */		sub	%o4,%o0,%o5
/* 0x23f0	     */		sub	%o3,%o0,%o2
/* 0x23f4	     */		srlx	%o5,63,%l5
/* 0x23f8	     */		srlx	%o2,63,%l2
/* 0x23fc	     */		xor	%l5,1,%g4
/* 0x2400	     */		xor	%l2,1,%o1
/* 0x2404	     */		and	%o1,%g4,%o4
/* 0x2408	     */		sra	%l3,0,%o1
/* 0x240c	     */		sra	%l4,0,%g2
/* 0x2410	     */		sub	%o1,%o0,%g4
/* 0x2414	     */		sub	%g2,%o0,%g3
/* 0x2418	     */		srlx	%g3,63,%l4
/* 0x241c	     */		srlx	%g4,63,%l3
/* 0x2420	     */		xor	%l4,1,%g5
/* 0x2424	     */		xor	%l3,1,%l7
/* 0x2428	     */		and	%o7,%o4,%o5
/* 0x242c	     */		and	%g5,%l7,%o3
/* 0x2430	     */		andcc	%o5,%o3,%g0
/* 0x2434	     */		be,a,pn	%icc,.L77004024
/* 0x2438	     */		or	%g0,0,%l4

! Registers live out of .L77004031: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004031

			.L77004032:
/* 0x243c	 466 */		sub	%i0,%i3,%o3
/* 0x2440	     */		sub	%i0,%i2,%l7
/* 0x2444	     */		add	%fp,-1600,%o1
/* 0x2448	     */		sub	%i2,%o1,%g5
/* 0x244c	     */		sra	%o3,31,%o7
/* 0x2450	     */		sra	%l7,31,%o2
/* 0x2454	     */		xor	%o3,%o7,%o1
/* 0x2458	     */		sub	%i0,%l0,%g2
/* 0x245c	     */		xor	%l7,%o2,%o5
/* 0x2460	     */		sub	%o1,%o7,%l4
/* 0x2464	     */		sra	%g5,31,%o4
/* 0x2468	     */		sra	%g2,31,%o3
/* 0x246c	     */		sub	%i2,%l6,%g3
/* 0x2470	     */		sub	%o5,%o2,%o5
/* 0x2474	     */		xor	%g5,%o4,%l2
/* 0x2478	     */		xor	%g2,%o3,%o2
/* 0x247c	     */		sra	%g3,31,%o7
/* 0x2480	     */		xor	%g3,%o7,%o1
/* 0x2484	     */		sub	%o2,%o3,%g5
/* 0x2488	     */		sub	%i2,%i3,%g2
/* 0x248c	     */		sub	%l2,%o4,%l5
/* 0x2490	     */		sub	%i2,%l0,%o2
/* 0x2494	     */		sub	%o1,%o7,%g3
/* 0x2498	     */		sra	%g2,31,%l3
/* 0x249c	     */		xor	%g2,%l3,%l2
/* 0x24a0	     */		sra	%o2,31,%o1
/* 0x24a4	     */		sub	%i2,%l1,%g4
/* 0x24a8	     */		sra	%g4,31,%o4
/* 0x24ac	     */		xor	%o2,%o1,%o3
/* 0x24b0	     */		sub	%l2,%l3,%l3
/* 0x24b4	     */		sub	%o3,%o1,%l2
/* 0x24b8	     */		xor	%g4,%o4,%g4
/* 0x24bc	     */		sub	%g4,%o4,%l7
/* 0x24c0	     */		sra	%l4,0,%o3
/* 0x24c4	     */		sra	%l5,0,%o7
/* 0x24c8	     */		sra	%o5,0,%o5
/* 0x24cc	     */		sra	%g5,0,%g5
/* 0x24d0	     */		sub	%o3,%o0,%o1
/* 0x24d4	     */		sub	%o7,%o0,%o4
/* 0x24d8	     */		sub	%o5,%o0,%o2
/* 0x24dc	     */		sub	%g5,%o0,%g2
/* 0x24e0	     */		srlx	%o1,63,%l4
/* 0x24e4	     */		srlx	%o4,63,%l5
/* 0x24e8	     */		srlx	%o2,63,%o5
/* 0x24ec	     */		srlx	%g2,63,%g5
/* 0x24f0	     */		xor	%l4,1,%g4
/* 0x24f4	     */		xor	%l5,1,%o7
/* 0x24f8	     */		xor	%o5,1,%o2
/* 0x24fc	     */		xor	%g5,1,%o4
/* 0x2500	     */		and	%o7,%g4,%o3
/* 0x2504	     */		and	%o2,%o4,%g2
/* 0x2508	     */		and	%g2,%o3,%g4
/* 0x250c	     */		sra	%l7,0,%o1
/* 0x2510	     */		sra	%g3,0,%g3
/* 0x2514	     */		sub	%o1,%o0,%o7
/* 0x2518	     */		sub	%g3,%o0,%o3
/* 0x251c	     */		srlx	%o7,63,%l7
/* 0x2520	     */		srlx	%o3,63,%g3
/* 0x2524	     */		xor	%g3,1,%l5
/* 0x2528	     */		xor	%l7,1,%o1
/* 0x252c	     */		and	%o1,%l5,%l4
/* 0x2530	     */		and	%g4,%l4,%o2
/* 0x2534	     */		sra	%l3,0,%g4
/* 0x2538	     */		sub	%g4,%o0,%o4
/* 0x253c	     */		sra	%l2,0,%o7
/* 0x2540	     */		sub	%o7,%o0,%o0
/* 0x2544	     */		srlx	%o4,63,%l3
/* 0x2548	     */		srlx	%o0,63,%l2
/* 0x254c	     */		xor	%l3,1,%g5
/* 0x2550	     */		xor	%l2,1,%o5
/* 0x2554	     */		and	%g5,%o5,%o4
/* 0x2558	     */		andcc	%o2,%o4,%g0
/* 0x255c	     */		be,a,pn	%icc,.L77004024
/* 0x2560	     */		or	%g0,0,%l4

! Registers live out of .L77004032: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004032

			.L77004194:
/* 0x2564	 466 */		sethi	%hi(0x1000),%g1
/* 0x2568	     */		xor	%g1,-704,%g1
/* 0x256c	     */		add	%g1,%fp,%l4
/* 0x2570	     */		sethi	%hi(0x1800),%g1
/* 0x2574	     */		xor	%g1,-256,%g1
/* 0x2578	     */		add	%i1,-1,%g2
/* 0x257c	     */		or	%g0,0,%l7
/* 0x2580	     */		add	%fp,-1600,%l6
/* 0x2584	     */		add	%fp,-3200,%l5

!  467		      !            if (mask[i]) {

/* 0x2588	 467 */		ldub	[%i3],%o1
/* 0x258c	 466 */		add	%g1,%fp,%l3

! Registers live out of .L77004194: 
! g2 o1 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003837 .L77004194

			.L900000479:
/* 0x2590	 467 */		cmp	%o1,0
/* 0x2594	     */		be,pn	%icc,.L77003837
/* 0x2598	 466 */		add	%l7,1,%l7

! Registers live out of .L900000479: 
! g2 o1 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  468		      !               red[i]   = ~(red[i]   | rdest[i]);

                       
! predecessor blocks: .L900000479

			.L77003835:
/* 0x259c	 468 */		ldub	[%i4],%o7
/* 0x25a0	     */		ldub	[%l6],%o3

!  469		      !               green[i] = ~(green[i] | gdest[i]);

/* 0x25a4	 469 */		ldub	[%i5],%l1

!  470		      !               blue[i]  = ~(blue[i]  | bdest[i]);

/* 0x25a8	 470 */		ldub	[%i0],%o2

!  471		      !               alpha[i] = ~(alpha[i] | adest[i]);

/* 0x25ac	 471 */		ldub	[%i2],%o0
/* 0x25b0	 469 */		ldub	[%l5],%o1
/* 0x25b4	 468 */		or	%o7,%o3,%o4
/* 0x25b8	 470 */		ldub	[%l4],%l0
/* 0x25bc	 469 */		or	%l1,%o1,%l2
/* 0x25c0	 471 */		ldub	[%l3],%g5
/* 0x25c4	 470 */		or	%o2,%l0,%g3
/* 0x25c8	 468 */		xnor	%o4,0,%o5
/* 0x25cc	     */		stb	%o5,[%i4]
/* 0x25d0	 471 */		or	%o0,%g5,%o3
/* 0x25d4	 469 */		xnor	%l2,0,%i1
/* 0x25d8	     */		stb	%i1,[%i5]
/* 0x25dc	 470 */		xnor	%g3,0,%g4
/* 0x25e0	     */		stb	%g4,[%i0]
/* 0x25e4	 471 */		xnor	%o3,0,%o7
/* 0x25e8	     */		stb	%o7,[%i2]

! Registers live out of .L77003835: 
! g2 o1 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003835 .L900000479

			.L77003837:
/* 0x25ec	 466 */		cmp	%l7,%g2
/* 0x25f0	     */		add	%i3,1,%i3
/* 0x25f4	     */		add	%l3,1,%l3
/* 0x25f8	     */		add	%l4,1,%l4
/* 0x25fc	     */		add	%l5,1,%l5
/* 0x2600	     */		add	%l6,1,%l6
/* 0x2604	     */		add	%i2,1,%i2
/* 0x2608	     */		add	%i0,1,%i0
/* 0x260c	     */		add	%i5,1,%i5
/* 0x2610	     */		add	%i4,1,%i4
/* 0x2614	     */		ble,a,pt	%icc,.L900000479
/* 0x2618	 467 */		ldub	[%i3],%o1

! Registers live out of .L77003837: 
! g2 o1 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003837

			.L77004027:
/* 0x261c	 466 */		ba	.L77003932
/* 0x2620	     */		nop

! Registers live out of .L77004027: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003955

			.L77004339:
/* 0x2624	 466 */		ld	[%fp+92],%i0
/* 0x2628	     */		ld	[%fp+96],%i2
/* 0x262c	     */		or	%g0,0,%l4

! Registers live out of .L77004339: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004030 .L77004031 .L77004032 .L77004339

			.L77004024:
/* 0x2630	 467 */		ldub	[%l4+%i3],%o7

! Registers live out of .L77004024: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004024 .L77004026

			.L900000478:
/* 0x2634	 467 */		cmp	%o7,0
/* 0x2638	     */		be,pn	%icc,.L77004026
/* 0x263c	 468 */		add	%fp,-1600,%g3

! Registers live out of .L900000478: 
! g1 g3 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000478

			.L77004025:
/* 0x2640	 468 */		ldub	[%l4+%g3],%o0
/* 0x2644	     */		ldub	[%i4+%l4],%o7
/* 0x2648	     */		or	%o7,%o0,%g2
/* 0x264c	     */		xnor	%g2,0,%g5
/* 0x2650	     */		stb	%g5,[%i4+%l4]
/* 0x2654	 469 */		ldub	[%l4+%l6],%l7
/* 0x2658	     */		ldub	[%i5+%l4],%l2
/* 0x265c	     */		or	%l2,%l7,%o1
/* 0x2660	     */		xnor	%o1,0,%o2
/* 0x2664	     */		stb	%o2,[%i5+%l4]
/* 0x2668	 470 */		ldub	[%l4+%l1],%o4
/* 0x266c	     */		ldub	[%l4+%i0],%l5
/* 0x2670	     */		or	%l5,%o4,%o5
/* 0x2674	     */		xnor	%o5,0,%l3
/* 0x2678	     */		stb	%l3,[%l4+%i0]
/* 0x267c	 471 */		ldub	[%l4+%l0],%g3
/* 0x2680	     */		ldub	[%l4+%i2],%g4
/* 0x2684	     */		or	%g4,%g3,%o3
/* 0x2688	     */		xnor	%o3,0,%o0
/* 0x268c	     */		stb	%o0,[%l4+%i2]

! Registers live out of .L77004025: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004025 .L900000478

			.L77004026:
/* 0x2690	 466 */		add	%l4,1,%l4
/* 0x2694	     */		cmp	%l4,%i1
/* 0x2698	     */		bcs,a,pn	%icc,.L900000478
/* 0x269c	 467 */		ldub	[%l4+%i3],%o7

! Registers live out of .L77004026: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004026

			.L900000455:
/* 0x26a0	 466 */		ba	.L77003932
/* 0x26a4	     */		nop

! Registers live out of .L900000455: 
! sp fp i7 gsr 
! 
		
!  472		      !            }
!  473		      !         }
!  474		      !         break;
!  475		      !      case GL_XOR:
!  476		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003843:
/* 0x26a8	 476 */		cmp	%i1,0
/* 0x26ac	     */		bleu,pn	%icc,.L77003932
/* 0x26b0	     */		cmp	%i1,54

! Registers live out of .L77003843: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003843

			.L77003957:
/* 0x26b4	 476 */		ld	[%fp+100],%i3
/* 0x26b8	     */		bl,pn	%icc,.L77004335
/* 0x26bc	     */		sub	%i4,%i5,%i2

! Registers live out of .L77003957: 
! g1 sp l0 l1 l6 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003957

			.L77004054:
/* 0x26c0	 476 */		add	%fp,-1600,%i0
/* 0x26c4	     */		sub	%i4,%i0,%o0
/* 0x26c8	     */		sra	%i2,31,%o1
/* 0x26cc	     */		xor	%i2,%o1,%i0
/* 0x26d0	     */		sub	%i0,%o1,%l7
/* 0x26d4	     */		sub	%i4,%l0,%g5
/* 0x26d8	     */		sra	%o0,31,%l3
/* 0x26dc	     */		sra	%g5,31,%o5
/* 0x26e0	     */		sub	%i4,%i3,%i0
/* 0x26e4	     */		xor	%o0,%l3,%o4
/* 0x26e8	     */		xor	%g5,%o5,%o3
/* 0x26ec	     */		sra	%i0,31,%i2
/* 0x26f0	     */		sub	%o3,%o5,%o0
/* 0x26f4	     */		xor	%i0,%i2,%o1
/* 0x26f8	     */		sub	%o1,%i2,%o5
/* 0x26fc	     */		sub	%i4,%l6,%g4
/* 0x2700	     */		sub	%i4,%l1,%l5
/* 0x2704	     */		sra	%g4,31,%o2
/* 0x2708	     */		sra	%l5,31,%o7
/* 0x270c	     */		xor	%g4,%o2,%l2
/* 0x2710	     */		sub	%o4,%l3,%l4
/* 0x2714	     */		xor	%l5,%o7,%g2
/* 0x2718	     */		sub	%g2,%o7,%g4
/* 0x271c	     */		sub	%l2,%o2,%g3
/* 0x2720	     */		sra	%l7,0,%g2
/* 0x2724	     */		sra	%g4,0,%g5
/* 0x2728	     */		sra	%g3,0,%g3
/* 0x272c	     */		sra	%l4,0,%o7
/* 0x2730	     */		sra	%o5,0,%o5
/* 0x2734	     */		ld	[%fp+96],%i2
/* 0x2738	     */		ld	[%fp+92],%i0
/* 0x273c	     */		sub	%i4,%i2,%o3
/* 0x2740	     */		sra	%o3,31,%l3
/* 0x2744	     */		xor	%o3,%l3,%o1
/* 0x2748	     */		sub	%i4,%i0,%l2
/* 0x274c	     */		sra	%l2,31,%o4
/* 0x2750	     */		sub	%o1,%l3,%l7
/* 0x2754	     */		sra	%i1,0,%o1
/* 0x2758	     */		xor	%l2,%o4,%o2
/* 0x275c	     */		sra	%o0,0,%o3
/* 0x2760	     */		sub	%o2,%o4,%l5
/* 0x2764	     */		sub	%g2,%o1,%o0
/* 0x2768	     */		sra	%l7,0,%o4
/* 0x276c	     */		srlx	%o0,63,%l2
/* 0x2770	     */		sub	%g5,%o1,%g4
/* 0x2774	     */		sra	%l5,0,%o2
/* 0x2778	     */		srlx	%g4,63,%l3
/* 0x277c	     */		sub	%o4,%o1,%g2
/* 0x2780	     */		sub	%g3,%o1,%o0
/* 0x2784	     */		sub	%o2,%o1,%o2
/* 0x2788	     */		sub	%o7,%o1,%g3
/* 0x278c	     */		srlx	%o2,63,%l5
/* 0x2790	     */		srlx	%g2,63,%g4
/* 0x2794	     */		srlx	%o0,63,%o0
/* 0x2798	     */		xor	%l2,1,%g2
/* 0x279c	     */		xor	%o0,1,%o7
/* 0x27a0	     */		sub	%o5,%o1,%o2
/* 0x27a4	     */		srlx	%g3,63,%l4
/* 0x27a8	     */		sub	%o3,%o1,%o3
/* 0x27ac	     */		srlx	%o3,63,%g3
/* 0x27b0	     */		and	%o7,%g2,%g5
/* 0x27b4	     */		srlx	%o2,63,%l2
/* 0x27b8	     */		xor	%l3,1,%o5
/* 0x27bc	     */		xor	%l5,1,%o4
/* 0x27c0	     */		xor	%g4,1,%o3
/* 0x27c4	     */		xor	%l2,1,%o7
/* 0x27c8	     */		and	%o5,%o4,%l5
/* 0x27cc	     */		and	%o7,1,%g4
/* 0x27d0	     */		sethi	%hi(0x7ffffc00),%o0
/* 0x27d4	     */		add	%o0,1022,%o5
/* 0x27d8	     */		srl	%i1,0,%o7
/* 0x27dc	     */		sub	%o7,%o5,%g2
/* 0x27e0	     */		xor	%l4,1,%l4
/* 0x27e4	     */		srlx	%g2,63,%o2
/* 0x27e8	     */		and	%o2,%l4,%o4
/* 0x27ec	     */		xor	%g3,1,%l7
/* 0x27f0	     */		and	%o4,%g5,%o5
/* 0x27f4	     */		and	%l7,%o3,%l3
/* 0x27f8	     */		and	%o5,%l5,%g3
/* 0x27fc	     */		and	%g3,%l3,%o3
/* 0x2800	     */		andcc	%o3,%g4,%g0
/* 0x2804	     */		be,a,pn	%icc,.L77004048
/* 0x2808	     */		or	%g0,0,%l4

! Registers live out of .L77004054: 
! g1 o1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004054

			.L77004055:
/* 0x280c	 476 */		sub	%i5,%i0,%o2
/* 0x2810	     */		sub	%i5,%l1,%l5
/* 0x2814	     */		sra	%o2,31,%l4
/* 0x2818	     */		sra	%l5,31,%o5
/* 0x281c	     */		xor	%o2,%l4,%o0
/* 0x2820	     */		xor	%l5,%o5,%l3
/* 0x2824	     */		add	%fp,-1600,%o4
/* 0x2828	     */		sub	%i5,%o4,%g3
/* 0x282c	     */		sub	%o0,%l4,%o7
/* 0x2830	     */		sub	%i5,%l6,%l7
/* 0x2834	     */		sub	%i5,%i2,%g2
/* 0x2838	     */		sub	%l3,%o5,%g5
/* 0x283c	     */		sra	%l7,31,%o0
/* 0x2840	     */		sra	%g3,31,%l4
/* 0x2844	     */		sra	%g2,31,%l3
/* 0x2848	     */		xor	%l7,%o0,%l2
/* 0x284c	     */		xor	%g3,%l4,%l5
/* 0x2850	     */		xor	%g2,%l3,%o5
/* 0x2854	     */		sub	%i5,%l0,%o3
/* 0x2858	     */		sub	%l2,%o0,%o2
/* 0x285c	     */		sub	%i0,%o4,%o4
/* 0x2860	     */		sub	%o5,%l3,%g3
/* 0x2864	     */		sra	%o3,31,%l7
/* 0x2868	     */		xor	%o3,%l7,%l2
/* 0x286c	     */		sra	%o4,31,%l3
/* 0x2870	     */		sub	%l5,%l4,%g4
/* 0x2874	     */		sub	%i5,%i3,%o0
/* 0x2878	     */		xor	%o4,%l3,%l4
/* 0x287c	     */		sub	%l2,%l7,%l7
/* 0x2880	     */		sra	%o0,31,%l5
/* 0x2884	     */		xor	%o0,%l5,%g2
/* 0x2888	     */		sub	%l4,%l3,%l2
/* 0x288c	     */		sub	%i0,%l6,%o5
/* 0x2890	     */		sub	%i0,%l1,%o3
/* 0x2894	     */		sra	%o5,31,%o4
/* 0x2898	     */		sub	%g2,%l5,%l5
/* 0x289c	     */		sra	%o3,31,%l4
/* 0x28a0	     */		xor	%o5,%o4,%o0
/* 0x28a4	     */		xor	%o3,%l4,%g2
/* 0x28a8	     */		sub	%o0,%o4,%l3
/* 0x28ac	     */		sub	%g2,%l4,%l4
/* 0x28b0	     */		sra	%o7,0,%o5
/* 0x28b4	     */		sra	%g5,0,%g5
/* 0x28b8	     */		sub	%o5,%o1,%o0
/* 0x28bc	     */		sub	%g5,%o1,%g2
/* 0x28c0	     */		srlx	%o0,63,%o7
/* 0x28c4	     */		srlx	%g2,63,%g5
/* 0x28c8	     */		xor	%o7,1,%o3
/* 0x28cc	     */		xor	%g5,1,%o5
/* 0x28d0	     */		and	%o5,%o3,%o0
/* 0x28d4	     */		sra	%o2,0,%o7
/* 0x28d8	     */		sra	%g4,0,%g4
/* 0x28dc	     */		sub	%o7,%o1,%o4
/* 0x28e0	     */		sub	%g4,%o1,%o3
/* 0x28e4	     */		srlx	%o4,63,%o2
/* 0x28e8	     */		srlx	%o3,63,%g4
/* 0x28ec	     */		xor	%o2,1,%o4
/* 0x28f0	     */		xor	%g4,1,%g2
/* 0x28f4	     */		and	%g2,%o4,%o7
/* 0x28f8	     */		and	%o7,%o0,%g4
/* 0x28fc	     */		sra	%l7,0,%o5
/* 0x2900	     */		sra	%g3,0,%g3
/* 0x2904	     */		sub	%g3,%o1,%o2
/* 0x2908	     */		sub	%o5,%o1,%o0
/* 0x290c	     */		srlx	%o2,63,%g3
/* 0x2910	     */		srlx	%o0,63,%l7
/* 0x2914	     */		xor	%g3,1,%g5
/* 0x2918	     */		xor	%l7,1,%o3
/* 0x291c	     */		and	%o3,%g5,%o5
/* 0x2920	     */		sra	%l5,0,%g5
/* 0x2924	     */		sra	%l2,0,%o7
/* 0x2928	     */		sub	%g5,%o1,%g2
/* 0x292c	     */		sub	%o7,%o1,%o4
/* 0x2930	     */		srlx	%g2,63,%l5
/* 0x2934	     */		srlx	%o4,63,%l2
/* 0x2938	     */		xor	%l5,1,%o2
/* 0x293c	     */		xor	%l2,1,%o0
/* 0x2940	     */		and	%g4,%o5,%g3
/* 0x2944	     */		and	%o0,%o2,%o4
/* 0x2948	     */		and	%g3,%o4,%o5
/* 0x294c	     */		sra	%l3,0,%g4
/* 0x2950	     */		sra	%l4,0,%g2
/* 0x2954	     */		sub	%g4,%o1,%o4
/* 0x2958	     */		sub	%g2,%o1,%o7
/* 0x295c	     */		srlx	%o7,63,%l4
/* 0x2960	     */		srlx	%o4,63,%l3
/* 0x2964	     */		xor	%l4,1,%g5
/* 0x2968	     */		xor	%l3,1,%l7
/* 0x296c	     */		and	%g5,%l7,%o3
/* 0x2970	     */		andcc	%o5,%o3,%g0
/* 0x2974	     */		be,a,pn	%icc,.L77004048
/* 0x2978	     */		or	%g0,0,%l4

! Registers live out of .L77004055: 
! g1 o1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004055

			.L77004056:
/* 0x297c	 476 */		add	%fp,-1600,%o7
/* 0x2980	     */		sub	%i2,%o7,%o5
/* 0x2984	     */		sub	%i0,%i3,%l2
/* 0x2988	     */		sra	%l2,31,%o0
/* 0x298c	     */		sra	%o5,31,%o3
/* 0x2990	     */		sub	%i0,%i2,%l7
/* 0x2994	     */		xor	%l2,%o0,%o4
/* 0x2998	     */		xor	%o5,%o3,%g5
/* 0x299c	     */		sra	%l7,31,%o2
/* 0x29a0	     */		sub	%i2,%l6,%g3
/* 0x29a4	     */		sub	%o4,%o0,%l4
/* 0x29a8	     */		sra	%g3,31,%o5
/* 0x29ac	     */		sub	%i0,%l0,%g2
/* 0x29b0	     */		xor	%l7,%o2,%o7
/* 0x29b4	     */		sub	%g5,%o3,%l5
/* 0x29b8	     */		sra	%g2,31,%o4
/* 0x29bc	     */		xor	%g3,%o5,%o0
/* 0x29c0	     */		sub	%i2,%l1,%g4
/* 0x29c4	     */		sub	%o7,%o2,%o7
/* 0x29c8	     */		xor	%g2,%o4,%o2
/* 0x29cc	     */		sra	%g4,31,%l2
/* 0x29d0	     */		sub	%i2,%l0,%o3
/* 0x29d4	     */		sub	%o0,%o5,%g3
/* 0x29d8	     */		sra	%o3,31,%o0
/* 0x29dc	     */		sub	%o2,%o4,%g5
/* 0x29e0	     */		sub	%i2,%i3,%g2
/* 0x29e4	     */		xor	%g4,%l2,%g4
/* 0x29e8	     */		sub	%g4,%l2,%l7
/* 0x29ec	     */		xor	%o3,%o0,%o4
/* 0x29f0	     */		sra	%g2,31,%l3
/* 0x29f4	     */		xor	%g2,%l3,%o2
/* 0x29f8	     */		sub	%o4,%o0,%l2
/* 0x29fc	     */		sub	%o2,%l3,%l3
/* 0x2a00	     */		sra	%l4,0,%o4
/* 0x2a04	     */		sra	%l5,0,%o5
/* 0x2a08	     */		sra	%o7,0,%o7
/* 0x2a0c	     */		sra	%g5,0,%g5
/* 0x2a10	     */		sub	%o4,%o1,%o0
/* 0x2a14	     */		sub	%o5,%o1,%o3
/* 0x2a18	     */		sub	%o7,%o1,%o2
/* 0x2a1c	     */		sub	%g5,%o1,%g2
/* 0x2a20	     */		srlx	%o0,63,%l4
/* 0x2a24	     */		srlx	%o3,63,%l5
/* 0x2a28	     */		srlx	%o2,63,%o7
/* 0x2a2c	     */		srlx	%g2,63,%g5
/* 0x2a30	     */		xor	%l4,1,%g4
/* 0x2a34	     */		xor	%l5,1,%o5
/* 0x2a38	     */		xor	%o7,1,%o3
/* 0x2a3c	     */		xor	%g5,1,%g2
/* 0x2a40	     */		and	%o5,%g4,%o4
/* 0x2a44	     */		and	%o3,%g2,%o2
/* 0x2a48	     */		and	%o2,%o4,%g4
/* 0x2a4c	     */		sra	%l7,0,%o0
/* 0x2a50	     */		sra	%g3,0,%g3
/* 0x2a54	     */		sub	%g3,%o1,%o4
/* 0x2a58	     */		sub	%o0,%o1,%o5
/* 0x2a5c	     */		srlx	%o4,63,%g3
/* 0x2a60	     */		srlx	%o5,63,%l7
/* 0x2a64	     */		xor	%g3,1,%l5
/* 0x2a68	     */		xor	%l7,1,%o0
/* 0x2a6c	     */		and	%o0,%l5,%l4
/* 0x2a70	     */		and	%g4,%l4,%o4
/* 0x2a74	     */		sra	%l3,0,%g4
/* 0x2a78	     */		sub	%g4,%o1,%o3
/* 0x2a7c	     */		sra	%l2,0,%o5
/* 0x2a80	     */		sub	%o5,%o1,%o1
/* 0x2a84	     */		srlx	%o3,63,%l3
/* 0x2a88	     */		srlx	%o1,63,%l2
/* 0x2a8c	     */		xor	%l3,1,%g5
/* 0x2a90	     */		xor	%l2,1,%o7
/* 0x2a94	     */		and	%g5,%o7,%g2
/* 0x2a98	     */		andcc	%o4,%g2,%g0
/* 0x2a9c	     */		be,a,pn	%icc,.L77004048
/* 0x2aa0	     */		or	%g0,0,%l4

! Registers live out of .L77004056: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004056

			.L77004196:
/* 0x2aa4	 476 */		sethi	%hi(0x1000),%g1
/* 0x2aa8	     */		xor	%g1,-704,%g1
/* 0x2aac	     */		add	%g1,%fp,%g2
/* 0x2ab0	     */		sethi	%hi(0x1800),%g1
/* 0x2ab4	     */		add	%i1,-1,%o0
/* 0x2ab8	     */		xor	%g1,-256,%g1
/* 0x2abc	     */		or	%g0,0,%g5
/* 0x2ac0	     */		add	%fp,-1600,%g4
/* 0x2ac4	     */		add	%fp,-3200,%g3

!  477		      !            if (mask[i]) {

/* 0x2ac8	 477 */		ldub	[%i3],%i1
/* 0x2acc	 476 */		add	%g1,%fp,%l7

! Registers live out of .L77004196: 
! g2 g3 g4 g5 o0 sp l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003851 .L77004196

			.L900000477:
/* 0x2ad0	 477 */		cmp	%i1,0
/* 0x2ad4	     */		be,pn	%icc,.L77003851
/* 0x2ad8	 476 */		add	%g5,1,%g5

! Registers live out of .L900000477: 
! g2 g3 g4 g5 o0 sp l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  478		      !               red[i]   ^= rdest[i];

                       
! predecessor blocks: .L900000477

			.L77003849:
/* 0x2adc	 478 */		ldub	[%i4],%o1

!  479		      !               green[i] ^= gdest[i];

/* 0x2ae0	 479 */		ldub	[%i5],%o4

!  480		      !               blue[i]  ^= bdest[i];

/* 0x2ae4	 480 */		ldub	[%i0],%o2

!  481		      !               alpha[i] ^= adest[i];

/* 0x2ae8	 481 */		ldub	[%i2],%l5
/* 0x2aec	 478 */		ldub	[%g4],%o7
/* 0x2af0	 479 */		ldub	[%g3],%l1
/* 0x2af4	 480 */		ldub	[%g2],%o5
/* 0x2af8	 481 */		ldub	[%l7],%l4
/* 0x2afc	 478 */		xor	%o1,%o7,%l0
/* 0x2b00	     */		stb	%l0,[%i4]
/* 0x2b04	 479 */		xor	%o4,%l1,%l2
/* 0x2b08	     */		stb	%l2,[%i5]
/* 0x2b0c	 480 */		xor	%o2,%o5,%l3
/* 0x2b10	     */		stb	%l3,[%i0]
/* 0x2b14	 481 */		xor	%l5,%l4,%l6
/* 0x2b18	     */		stb	%l6,[%i2]

! Registers live out of .L77003849: 
! g2 g3 g4 g5 o0 sp l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003849 .L900000477

			.L77003851:
/* 0x2b1c	 476 */		cmp	%g5,%o0
/* 0x2b20	     */		add	%i3,1,%i3
/* 0x2b24	     */		add	%l7,1,%l7
/* 0x2b28	     */		add	%g2,1,%g2
/* 0x2b2c	     */		add	%g3,1,%g3
/* 0x2b30	     */		add	%g4,1,%g4
/* 0x2b34	     */		add	%i2,1,%i2
/* 0x2b38	     */		add	%i0,1,%i0
/* 0x2b3c	     */		add	%i5,1,%i5
/* 0x2b40	     */		add	%i4,1,%i4
/* 0x2b44	     */		ble,a,pt	%icc,.L900000477
/* 0x2b48	 477 */		ldub	[%i3],%i1

! Registers live out of .L77003851: 
! g2 g3 g4 g5 o0 sp l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003851

			.L77004051:
/* 0x2b4c	 476 */		ba	.L77003932
/* 0x2b50	     */		nop

! Registers live out of .L77004051: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003957

			.L77004335:
/* 0x2b54	 476 */		ld	[%fp+92],%i0
/* 0x2b58	     */		ld	[%fp+96],%i2
/* 0x2b5c	     */		or	%g0,0,%l4

! Registers live out of .L77004335: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004054 .L77004055 .L77004056 .L77004335

			.L77004048:
/* 0x2b60	 477 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004048: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004048 .L77004050

			.L900000476:
/* 0x2b64	 477 */		cmp	%g3,0
/* 0x2b68	     */		be,pn	%icc,.L77004050
/* 0x2b6c	 478 */		add	%fp,-1600,%l3

! Registers live out of .L900000476: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000476

			.L77004049:
/* 0x2b70	 478 */		ldub	[%l4+%l3],%o1
/* 0x2b74	     */		ldub	[%i4+%l4],%o0
/* 0x2b78	     */		xor	%o0,%o1,%g2
/* 0x2b7c	     */		stb	%g2,[%i4+%l4]
/* 0x2b80	 479 */		ldub	[%l4+%l6],%g5
/* 0x2b84	     */		ldub	[%i5+%l4],%l7
/* 0x2b88	     */		xor	%l7,%g5,%l2
/* 0x2b8c	     */		stb	%l2,[%i5+%l4]
/* 0x2b90	 480 */		ldub	[%l4+%l1],%o7
/* 0x2b94	     */		ldub	[%l4+%i0],%o2
/* 0x2b98	     */		xor	%o2,%o7,%o4
/* 0x2b9c	     */		stb	%o4,[%l4+%i0]
/* 0x2ba0	 481 */		ldub	[%l4+%l0],%l5
/* 0x2ba4	     */		ldub	[%l4+%i2],%o5
/* 0x2ba8	     */		xor	%o5,%l5,%l3
/* 0x2bac	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004049: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004049 .L900000476

			.L77004050:
/* 0x2bb0	 476 */		add	%l4,1,%l4
/* 0x2bb4	     */		cmp	%l4,%i1
/* 0x2bb8	     */		bcs,a,pn	%icc,.L900000476
/* 0x2bbc	 477 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004050: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004050

			.L900000454:
/* 0x2bc0	 476 */		ba	.L77003932
/* 0x2bc4	     */		nop

! Registers live out of .L900000454: 
! sp fp i7 gsr 
! 
		
!  482		      !            }
!  483		      !         }
!  484		      !         break;
!  485		      !      case GL_EQUIV:
!  486		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003857:
/* 0x2bc8	 486 */		cmp	%i1,0
/* 0x2bcc	     */		bleu,pn	%icc,.L77003932
/* 0x2bd0	     */		cmp	%i1,54

! Registers live out of .L77003857: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003857

			.L77003954:
/* 0x2bd4	 486 */		ld	[%fp+100],%i3
/* 0x2bd8	     */		bl,pn	%icc,.L77004341
/* 0x2bdc	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003954: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003954

			.L77004018:
/* 0x2be0	 486 */		sra	%i0,31,%o0
/* 0x2be4	     */		sub	%i4,%l6,%o2
/* 0x2be8	     */		xor	%i0,%o0,%i2
/* 0x2bec	     */		sra	%o2,31,%g4
/* 0x2bf0	     */		sub	%i4,%l1,%l5
/* 0x2bf4	     */		sub	%i2,%o0,%l7
/* 0x2bf8	     */		xor	%o2,%g4,%l2
/* 0x2bfc	     */		sra	%l5,31,%o4
/* 0x2c00	     */		sub	%i4,%i3,%i0
/* 0x2c04	     */		xor	%l5,%o4,%l3
/* 0x2c08	     */		sra	%i0,31,%i2
/* 0x2c0c	     */		sub	%l2,%g4,%g3
/* 0x2c10	     */		sub	%l3,%o4,%l2
/* 0x2c14	     */		xor	%i0,%i2,%o2
/* 0x2c18	     */		sub	%o2,%i2,%o4
/* 0x2c1c	     */		sub	%i4,%l0,%g5
/* 0x2c20	     */		sra	%g5,31,%o5
/* 0x2c24	     */		add	%fp,-1600,%g2
/* 0x2c28	     */		sub	%i4,%g2,%o1
/* 0x2c2c	     */		xor	%g5,%o5,%o3
/* 0x2c30	     */		sra	%o1,31,%g2
/* 0x2c34	     */		sub	%o3,%o5,%o0
/* 0x2c38	     */		xor	%o1,%g2,%o7
/* 0x2c3c	     */		sub	%o7,%g2,%l4
/* 0x2c40	     */		sra	%l7,0,%g2
/* 0x2c44	     */		sra	%g3,0,%g3
/* 0x2c48	     */		sra	%l2,0,%o7
/* 0x2c4c	     */		sra	%o4,0,%o4
/* 0x2c50	     */		sra	%l4,0,%g4
/* 0x2c54	     */		ld	[%fp+96],%i2
/* 0x2c58	     */		ld	[%fp+92],%i0
/* 0x2c5c	     */		sub	%i4,%i2,%g5
/* 0x2c60	     */		sra	%g5,31,%o5
/* 0x2c64	     */		xor	%g5,%o5,%o3
/* 0x2c68	     */		sub	%i4,%i0,%o1
/* 0x2c6c	     */		sra	%o1,31,%l3
/* 0x2c70	     */		sra	%o0,0,%g5
/* 0x2c74	     */		sra	%i1,0,%o0
/* 0x2c78	     */		xor	%o1,%l3,%l5
/* 0x2c7c	     */		sub	%g2,%o0,%o1
/* 0x2c80	     */		srlx	%o1,63,%g2
/* 0x2c84	     */		sub	%l5,%l3,%o2
/* 0x2c88	     */		sub	%g3,%o0,%o1
/* 0x2c8c	     */		srlx	%o1,63,%l3
/* 0x2c90	     */		sub	%o3,%o5,%l7
/* 0x2c94	     */		sub	%o7,%o0,%o1
/* 0x2c98	     */		sra	%o2,0,%o2
/* 0x2c9c	     */		sra	%l7,0,%o3
/* 0x2ca0	     */		srlx	%o1,63,%l5
/* 0x2ca4	     */		sub	%o2,%o0,%o7
/* 0x2ca8	     */		srlx	%o7,63,%o5
/* 0x2cac	     */		sub	%o3,%o0,%o2
/* 0x2cb0	     */		sub	%o4,%o0,%o1
/* 0x2cb4	     */		sub	%g5,%o0,%g5
/* 0x2cb8	     */		srlx	%g5,63,%g3
/* 0x2cbc	     */		xor	%g2,1,%o7
/* 0x2cc0	     */		xor	%l5,1,%o3
/* 0x2cc4	     */		xor	%o5,1,%o4
/* 0x2cc8	     */		xor	%l3,1,%l2
/* 0x2ccc	     */		and	%o3,%o4,%l5
/* 0x2cd0	     */		xor	%g3,1,%l7
/* 0x2cd4	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x2cd8	     */		and	%l2,%o7,%g5
/* 0x2cdc	     */		sub	%g4,%o0,%g4
/* 0x2ce0	     */		add	%g2,1022,%o3
/* 0x2ce4	     */		srl	%i1,0,%g3
/* 0x2ce8	     */		sub	%g3,%o3,%o7
/* 0x2cec	     */		srlx	%g4,63,%l4
/* 0x2cf0	     */		xor	%l4,1,%l4
/* 0x2cf4	     */		srlx	%o7,63,%o5
/* 0x2cf8	     */		srlx	%o2,63,%g4
/* 0x2cfc	     */		and	%o5,%l4,%o4
/* 0x2d00	     */		xor	%g4,1,%o2
/* 0x2d04	     */		srlx	%o1,63,%l2
/* 0x2d08	     */		and	%o4,%g5,%o3
/* 0x2d0c	     */		and	%l7,%o2,%l3
/* 0x2d10	     */		xor	%l2,1,%o1
/* 0x2d14	     */		and	%o3,%l5,%g3
/* 0x2d18	     */		and	%o1,1,%g4
/* 0x2d1c	     */		and	%g3,%l3,%o2
/* 0x2d20	     */		andcc	%o2,%g4,%g0
/* 0x2d24	     */		be,a,pn	%icc,.L77004012
/* 0x2d28	     */		or	%g0,0,%l4

! Registers live out of .L77004018: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004018

			.L77004019:
/* 0x2d2c	 486 */		sub	%i5,%i0,%g2
/* 0x2d30	     */		sra	%g2,31,%l4
/* 0x2d34	     */		xor	%g2,%l4,%o7
/* 0x2d38	     */		sub	%i5,%l1,%l5
/* 0x2d3c	     */		add	%fp,-1600,%l2
/* 0x2d40	     */		sub	%i5,%l2,%o4
/* 0x2d44	     */		sra	%l5,31,%o1
/* 0x2d48	     */		sub	%i5,%l6,%l7
/* 0x2d4c	     */		sub	%o7,%l4,%g2
/* 0x2d50	     */		xor	%l5,%o1,%l3
/* 0x2d54	     */		sra	%l7,31,%o7
/* 0x2d58	     */		sra	%o4,31,%l4
/* 0x2d5c	     */		xor	%o4,%l4,%l5
/* 0x2d60	     */		sub	%i5,%i2,%o5
/* 0x2d64	     */		sub	%l3,%o1,%g5
/* 0x2d68	     */		xor	%l7,%o7,%o2
/* 0x2d6c	     */		sub	%i0,%l2,%o4
/* 0x2d70	     */		sra	%o5,31,%l3
/* 0x2d74	     */		sub	%o2,%o7,%o2
/* 0x2d78	     */		xor	%o5,%l3,%l2
/* 0x2d7c	     */		sub	%i5,%l0,%o3
/* 0x2d80	     */		sub	%l5,%l4,%g4
/* 0x2d84	     */		sub	%i5,%i3,%o7
/* 0x2d88	     */		sra	%o7,31,%l4
/* 0x2d8c	     */		sub	%l2,%l3,%g3
/* 0x2d90	     */		sra	%o3,31,%l7
/* 0x2d94	     */		xor	%o3,%l7,%o1
/* 0x2d98	     */		sra	%o4,31,%l3
/* 0x2d9c	     */		sub	%i0,%l6,%o5
/* 0x2da0	     */		xor	%o7,%l4,%l5
/* 0x2da4	     */		sra	%o5,31,%o7
/* 0x2da8	     */		sub	%o1,%l7,%l7
/* 0x2dac	     */		xor	%o4,%l3,%l2
/* 0x2db0	     */		xor	%o5,%o7,%o1
/* 0x2db4	     */		sub	%l2,%l3,%l2
/* 0x2db8	     */		sub	%o1,%o7,%l3
/* 0x2dbc	     */		sub	%i0,%l1,%o3
/* 0x2dc0	     */		sra	%g2,0,%g2
/* 0x2dc4	     */		sra	%g5,0,%g5
/* 0x2dc8	     */		sra	%o3,31,%o4
/* 0x2dcc	     */		sub	%l5,%l4,%l5
/* 0x2dd0	     */		sub	%g2,%o0,%o1
/* 0x2dd4	     */		sub	%g5,%o0,%o7
/* 0x2dd8	     */		xor	%o3,%o4,%l4
/* 0x2ddc	     */		srlx	%o1,63,%g2
/* 0x2de0	     */		srlx	%o7,63,%g5
/* 0x2de4	     */		sub	%l4,%o4,%l4
/* 0x2de8	     */		xor	%g2,1,%o3
/* 0x2dec	     */		xor	%g5,1,%o5
/* 0x2df0	     */		and	%o5,%o3,%o1
/* 0x2df4	     */		sra	%o2,0,%o4
/* 0x2df8	     */		sra	%g4,0,%g4
/* 0x2dfc	     */		sub	%o4,%o0,%o5
/* 0x2e00	     */		sub	%g4,%o0,%o3
/* 0x2e04	     */		srlx	%o5,63,%o2
/* 0x2e08	     */		srlx	%o3,63,%g4
/* 0x2e0c	     */		xor	%o2,1,%o7
/* 0x2e10	     */		xor	%g4,1,%o4
/* 0x2e14	     */		and	%o4,%o7,%g2
/* 0x2e18	     */		and	%g2,%o1,%o5
/* 0x2e1c	     */		sra	%l7,0,%g2
/* 0x2e20	     */		sra	%g3,0,%g3
/* 0x2e24	     */		sub	%g3,%o0,%o2
/* 0x2e28	     */		sub	%g2,%o0,%o1
/* 0x2e2c	     */		srlx	%o2,63,%g3
/* 0x2e30	     */		srlx	%o1,63,%l7
/* 0x2e34	     */		xor	%g3,1,%g5
/* 0x2e38	     */		xor	%l7,1,%o3
/* 0x2e3c	     */		and	%o3,%g5,%o2
/* 0x2e40	     */		sra	%l5,0,%g5
/* 0x2e44	     */		sra	%l2,0,%o4
/* 0x2e48	     */		and	%o5,%o2,%g2
/* 0x2e4c	     */		sub	%g5,%o0,%o7
/* 0x2e50	     */		sub	%o4,%o0,%o5
/* 0x2e54	     */		srlx	%o7,63,%l5
/* 0x2e58	     */		srlx	%o5,63,%l2
/* 0x2e5c	     */		xor	%l5,1,%g4
/* 0x2e60	     */		xor	%l2,1,%o1
/* 0x2e64	     */		and	%o1,%g4,%o7
/* 0x2e68	     */		and	%g2,%o7,%o5
/* 0x2e6c	     */		sra	%l3,0,%o7
/* 0x2e70	     */		sra	%l4,0,%o4
/* 0x2e74	     */		sub	%o7,%o0,%g5
/* 0x2e78	     */		sub	%o4,%o0,%g3
/* 0x2e7c	     */		srlx	%g3,63,%l4
/* 0x2e80	     */		srlx	%g5,63,%l3
/* 0x2e84	     */		xor	%l4,1,%g5
/* 0x2e88	     */		xor	%l3,1,%l7
/* 0x2e8c	     */		and	%g5,%l7,%o3
/* 0x2e90	     */		andcc	%o5,%o3,%g0
/* 0x2e94	     */		be,a,pn	%icc,.L77004012
/* 0x2e98	     */		or	%g0,0,%l4

! Registers live out of .L77004019: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004019

			.L77004020:
/* 0x2e9c	 486 */		add	%fp,-1600,%l5
/* 0x2ea0	     */		sub	%i2,%l5,%o2
/* 0x2ea4	     */		sub	%i0,%i3,%g5
/* 0x2ea8	     */		sub	%i0,%i2,%l7
/* 0x2eac	     */		sra	%g5,31,%o1
/* 0x2eb0	     */		sra	%l7,31,%l3
/* 0x2eb4	     */		sra	%o2,31,%l5
/* 0x2eb8	     */		xor	%g5,%o1,%l2
/* 0x2ebc	     */		xor	%o2,%l5,%o4
/* 0x2ec0	     */		xor	%l7,%l3,%o5
/* 0x2ec4	     */		sub	%i0,%l0,%g2
/* 0x2ec8	     */		sub	%l2,%o1,%l4
/* 0x2ecc	     */		sra	%g2,31,%o3
/* 0x2ed0	     */		sub	%i2,%l6,%g3
/* 0x2ed4	     */		sub	%o5,%l3,%o2
/* 0x2ed8	     */		xor	%g2,%o3,%o5
/* 0x2edc	     */		sra	%g3,31,%o1
/* 0x2ee0	     */		xor	%g3,%o1,%o7
/* 0x2ee4	     */		sub	%o5,%o3,%g5
/* 0x2ee8	     */		sub	%i2,%i3,%g2
/* 0x2eec	     */		sub	%i2,%l0,%o5
/* 0x2ef0	     */		sub	%o7,%o1,%g3
/* 0x2ef4	     */		sra	%g2,31,%l3
/* 0x2ef8	     */		xor	%g2,%l3,%l2
/* 0x2efc	     */		sra	%o5,31,%o7
/* 0x2f00	     */		sub	%o4,%l5,%l5
/* 0x2f04	     */		sub	%i2,%l1,%g4
/* 0x2f08	     */		sra	%g4,31,%o4
/* 0x2f0c	     */		xor	%o5,%o7,%o3
/* 0x2f10	     */		sub	%l2,%l3,%l3
/* 0x2f14	     */		sub	%o3,%o7,%l2
/* 0x2f18	     */		xor	%g4,%o4,%g4
/* 0x2f1c	     */		sub	%g4,%o4,%l7
/* 0x2f20	     */		sra	%l4,0,%o3
/* 0x2f24	     */		sra	%l5,0,%o1
/* 0x2f28	     */		sra	%o2,0,%o2
/* 0x2f2c	     */		sra	%g5,0,%g5
/* 0x2f30	     */		sub	%o3,%o0,%o7
/* 0x2f34	     */		sub	%o1,%o0,%o4
/* 0x2f38	     */		sub	%o2,%o0,%o5
/* 0x2f3c	     */		sub	%g5,%o0,%g2
/* 0x2f40	     */		srlx	%o7,63,%l4
/* 0x2f44	     */		srlx	%o4,63,%l5
/* 0x2f48	     */		srlx	%o5,63,%o2
/* 0x2f4c	     */		srlx	%g2,63,%g5
/* 0x2f50	     */		xor	%l4,1,%g4
/* 0x2f54	     */		xor	%l5,1,%o1
/* 0x2f58	     */		xor	%o2,1,%o5
/* 0x2f5c	     */		xor	%g5,1,%o4
/* 0x2f60	     */		and	%o1,%g4,%o3
/* 0x2f64	     */		and	%o5,%o4,%g2
/* 0x2f68	     */		and	%g2,%o3,%g4
/* 0x2f6c	     */		sra	%l7,0,%o7
/* 0x2f70	     */		sra	%g3,0,%g3
/* 0x2f74	     */		sub	%o7,%o0,%o1
/* 0x2f78	     */		sub	%g3,%o0,%o3
/* 0x2f7c	     */		srlx	%o1,63,%l7
/* 0x2f80	     */		srlx	%o3,63,%g3
/* 0x2f84	     */		xor	%g3,1,%l5
/* 0x2f88	     */		xor	%l7,1,%o7
/* 0x2f8c	     */		and	%o7,%l5,%l4
/* 0x2f90	     */		and	%g4,%l4,%o5
/* 0x2f94	     */		sra	%l3,0,%g4
/* 0x2f98	     */		sub	%g4,%o0,%o4
/* 0x2f9c	     */		sra	%l2,0,%o1
/* 0x2fa0	     */		sub	%o1,%o0,%o0
/* 0x2fa4	     */		srlx	%o4,63,%l3
/* 0x2fa8	     */		srlx	%o0,63,%l2
/* 0x2fac	     */		xor	%l3,1,%g5
/* 0x2fb0	     */		xor	%l2,1,%o2
/* 0x2fb4	     */		and	%g5,%o2,%o4
/* 0x2fb8	     */		andcc	%o5,%o4,%g0
/* 0x2fbc	     */		be,a,pn	%icc,.L77004012
/* 0x2fc0	     */		or	%g0,0,%l4

! Registers live out of .L77004020: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004020

			.L77004193:
/* 0x2fc4	 486 */		sethi	%hi(0x1000),%g1
/* 0x2fc8	     */		xor	%g1,-704,%g1
/* 0x2fcc	     */		add	%g1,%fp,%l4
/* 0x2fd0	     */		sethi	%hi(0x1800),%g1
/* 0x2fd4	     */		xor	%g1,-256,%g1
/* 0x2fd8	     */		add	%i1,-1,%g2
/* 0x2fdc	     */		or	%g0,0,%l7
/* 0x2fe0	     */		add	%fp,-1600,%l6
/* 0x2fe4	     */		add	%fp,-3200,%l5

!  487		      !            if (mask[i]) {

/* 0x2fe8	 487 */		ldub	[%i3],%o3
/* 0x2fec	 486 */		add	%g1,%fp,%l3

! Registers live out of .L77004193: 
! g2 o3 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003865 .L77004193

			.L900000475:
/* 0x2ff0	 487 */		cmp	%o3,0
/* 0x2ff4	     */		be,pn	%icc,.L77003865
/* 0x2ff8	 486 */		add	%l7,1,%l7

! Registers live out of .L900000475: 
! g2 o3 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  488		      !               red[i]   = ~(red[i]   ^ rdest[i]);

                       
! predecessor blocks: .L900000475

			.L77003863:
/* 0x2ffc	 488 */		ldub	[%i4],%i1
/* 0x3000	     */		ldub	[%l6],%o0

!  489		      !               green[i] = ~(green[i] ^ gdest[i]);

/* 0x3004	 489 */		ldub	[%i5],%l1

!  490		      !               blue[i]  = ~(blue[i]  ^ bdest[i]);

/* 0x3008	 490 */		ldub	[%i0],%o4

!  491		      !               alpha[i] = ~(alpha[i] ^ adest[i]);

/* 0x300c	 491 */		ldub	[%i2],%g4
/* 0x3010	 489 */		ldub	[%l5],%o3
/* 0x3014	 488 */		xor	%i1,%o0,%o7
/* 0x3018	 490 */		ldub	[%l4],%l0
/* 0x301c	 489 */		xor	%l1,%o3,%l2
/* 0x3020	 491 */		ldub	[%l3],%g5
/* 0x3024	 490 */		xor	%o4,%l0,%o2
/* 0x3028	 488 */		xnor	%o7,0,%o1
/* 0x302c	     */		stb	%o1,[%i4]
/* 0x3030	 491 */		xor	%g4,%g5,%o0
/* 0x3034	 489 */		xnor	%l2,0,%o5
/* 0x3038	     */		stb	%o5,[%i5]
/* 0x303c	 490 */		xnor	%o2,0,%g3
/* 0x3040	     */		stb	%g3,[%i0]
/* 0x3044	 491 */		xnor	%o0,0,%i1
/* 0x3048	     */		stb	%i1,[%i2]

! Registers live out of .L77003863: 
! g2 o3 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003863 .L900000475

			.L77003865:
/* 0x304c	 486 */		cmp	%l7,%g2
/* 0x3050	     */		add	%i3,1,%i3
/* 0x3054	     */		add	%l3,1,%l3
/* 0x3058	     */		add	%l4,1,%l4
/* 0x305c	     */		add	%l5,1,%l5
/* 0x3060	     */		add	%l6,1,%l6
/* 0x3064	     */		add	%i2,1,%i2
/* 0x3068	     */		add	%i0,1,%i0
/* 0x306c	     */		add	%i5,1,%i5
/* 0x3070	     */		add	%i4,1,%i4
/* 0x3074	     */		ble,a,pt	%icc,.L900000475
/* 0x3078	 487 */		ldub	[%i3],%o3

! Registers live out of .L77003865: 
! g2 o3 sp l4 l5 l6 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003865

			.L77004015:
/* 0x307c	 486 */		ba	.L77003932
/* 0x3080	     */		nop

! Registers live out of .L77004015: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003954

			.L77004341:
/* 0x3084	 486 */		ld	[%fp+92],%i0
/* 0x3088	     */		ld	[%fp+96],%i2
/* 0x308c	     */		or	%g0,0,%l4

! Registers live out of .L77004341: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004018 .L77004019 .L77004020 .L77004341

			.L77004012:
/* 0x3090	 487 */		ldub	[%l4+%i3],%g2

! Registers live out of .L77004012: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004012 .L77004014

			.L900000474:
/* 0x3094	 487 */		cmp	%g2,0
/* 0x3098	     */		be,pn	%icc,.L77004014
/* 0x309c	 488 */		add	%fp,-1600,%l7

! Registers live out of .L900000474: 
! g1 g2 sp l0 l1 l4 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000474

			.L77004013:
/* 0x30a0	 488 */		ldub	[%l4+%l7],%o0
/* 0x30a4	     */		ldub	[%i4+%l4],%g2
/* 0x30a8	     */		xor	%g2,%o0,%o7
/* 0x30ac	     */		xnor	%o7,0,%g5
/* 0x30b0	     */		stb	%g5,[%i4+%l4]
/* 0x30b4	 489 */		ldub	[%l4+%l6],%l7
/* 0x30b8	     */		ldub	[%i5+%l4],%l2
/* 0x30bc	     */		xor	%l2,%l7,%o1
/* 0x30c0	     */		xnor	%o1,0,%o5
/* 0x30c4	     */		stb	%o5,[%i5+%l4]
/* 0x30c8	 490 */		ldub	[%l4+%l1],%o4
/* 0x30cc	     */		ldub	[%l4+%i0],%l5
/* 0x30d0	     */		xor	%l5,%o4,%o3
/* 0x30d4	     */		xnor	%o3,0,%l3
/* 0x30d8	     */		stb	%l3,[%l4+%i0]
/* 0x30dc	 491 */		ldub	[%l4+%l0],%g3
/* 0x30e0	     */		ldub	[%l4+%i2],%g4
/* 0x30e4	     */		xor	%g4,%g3,%o2
/* 0x30e8	     */		xnor	%o2,0,%o0
/* 0x30ec	     */		stb	%o0,[%l4+%i2]

! Registers live out of .L77004013: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004013 .L900000474

			.L77004014:
/* 0x30f0	 486 */		add	%l4,1,%l4
/* 0x30f4	     */		cmp	%l4,%i1
/* 0x30f8	     */		bcs,a,pn	%icc,.L900000474
/* 0x30fc	 487 */		ldub	[%l4+%i3],%g2

! Registers live out of .L77004014: 
! g1 g2 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004014

			.L900000453:
/* 0x3100	 486 */		ba	.L77003932
/* 0x3104	     */		nop

! Registers live out of .L900000453: 
! sp fp i7 gsr 
! 
		
!  492		      !            }
!  493		      !         }
!  494		      !         break;
!  495		      !      case GL_AND_REVERSE:
!  496		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003871:
/* 0x3108	 496 */		cmp	%i1,0
/* 0x310c	     */		bleu,pn	%icc,.L77003932
/* 0x3110	     */		cmp	%i1,54

! Registers live out of .L77003871: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003871

			.L77003960:
/* 0x3114	 496 */		ld	[%fp+100],%i3
/* 0x3118	     */		bl,pn	%icc,.L77004329
/* 0x311c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003960: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003960

			.L77004090:
/* 0x3120	 496 */		sra	%i0,31,%o0
/* 0x3124	     */		xor	%i0,%o0,%i2
/* 0x3128	     */		sub	%i4,%l6,%o7
/* 0x312c	     */		sub	%i4,%l0,%g5
/* 0x3130	     */		add	%fp,-1600,%o3
/* 0x3134	     */		sub	%i4,%o3,%o1
/* 0x3138	     */		sub	%i2,%o0,%l7
/* 0x313c	     */		sra	%o7,31,%g4
/* 0x3140	     */		sra	%g5,31,%o5
/* 0x3144	     */		sub	%i4,%i3,%i0
/* 0x3148	     */		xor	%o7,%g4,%l2
/* 0x314c	     */		xor	%g5,%o5,%o3
/* 0x3150	     */		sra	%i0,31,%i2
/* 0x3154	     */		sub	%o3,%o5,%o0
/* 0x3158	     */		xor	%i0,%i2,%o7
/* 0x315c	     */		sub	%o7,%i2,%o5
/* 0x3160	     */		sub	%i4,%l1,%l5
/* 0x3164	     */		sra	%l5,31,%g2
/* 0x3168	     */		xor	%l5,%g2,%l3
/* 0x316c	     */		sub	%l2,%g4,%g3
/* 0x3170	     */		sub	%l3,%g2,%l2
/* 0x3174	     */		sra	%o1,31,%o4
/* 0x3178	     */		xor	%o1,%o4,%o2
/* 0x317c	     */		sra	%l7,0,%g2
/* 0x3180	     */		sub	%o2,%o4,%l4
/* 0x3184	     */		sra	%l4,0,%o7
/* 0x3188	     */		sra	%l2,0,%o1
/* 0x318c	     */		sra	%g3,0,%g3
/* 0x3190	     */		sra	%o5,0,%o5
/* 0x3194	     */		ld	[%fp+96],%i2
/* 0x3198	     */		ld	[%fp+92],%i0
/* 0x319c	     */		sub	%i4,%i2,%g5
/* 0x31a0	     */		sra	%g5,31,%l3
/* 0x31a4	     */		xor	%g5,%l3,%o3
/* 0x31a8	     */		sub	%o3,%l3,%l7
/* 0x31ac	     */		sub	%i4,%i0,%g4
/* 0x31b0	     */		sra	%g4,31,%o4
/* 0x31b4	     */		sra	%o0,0,%o3
/* 0x31b8	     */		sra	%i1,0,%o0
/* 0x31bc	     */		xor	%g4,%o4,%o2
/* 0x31c0	     */		sub	%g2,%o0,%g4
/* 0x31c4	     */		sub	%o2,%o4,%l5
/* 0x31c8	     */		srlx	%g4,63,%g2
/* 0x31cc	     */		sub	%o7,%o0,%g4
/* 0x31d0	     */		sub	%o1,%o0,%o2
/* 0x31d4	     */		sra	%l5,0,%g5
/* 0x31d8	     */		sra	%l7,0,%o4
/* 0x31dc	     */		srlx	%g4,63,%l4
/* 0x31e0	     */		srlx	%o2,63,%l2
/* 0x31e4	     */		sub	%g3,%o0,%g3
/* 0x31e8	     */		srlx	%g3,63,%l3
/* 0x31ec	     */		sub	%g5,%o0,%o1
/* 0x31f0	     */		sub	%o3,%o0,%o2
/* 0x31f4	     */		sub	%o4,%o0,%g4
/* 0x31f8	     */		srlx	%o1,63,%l5
/* 0x31fc	     */		srlx	%o2,63,%g3
/* 0x3200	     */		srlx	%g4,63,%g4
/* 0x3204	     */		xor	%g2,1,%o1
/* 0x3208	     */		xor	%l3,1,%o7
/* 0x320c	     */		xor	%g4,1,%o3
/* 0x3210	     */		xor	%g3,1,%l7
/* 0x3214	     */		and	%o7,%o1,%g5
/* 0x3218	     */		and	%l7,%o3,%l3
/* 0x321c	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x3220	     */		sub	%o5,%o0,%o2
/* 0x3224	     */		add	%g2,1022,%o3
/* 0x3228	     */		srl	%i1,0,%o1
/* 0x322c	     */		xor	%l2,1,%o5
/* 0x3230	     */		xor	%l5,1,%o4
/* 0x3234	     */		sub	%o1,%o3,%o1
/* 0x3238	     */		and	%o5,%o4,%l5
/* 0x323c	     */		xor	%l4,1,%o7
/* 0x3240	     */		srlx	%o1,63,%l2
/* 0x3244	     */		and	%l2,%o7,%o4
/* 0x3248	     */		srlx	%o2,63,%l4
/* 0x324c	     */		and	%o4,%g5,%o5
/* 0x3250	     */		xor	%l4,1,%o2
/* 0x3254	     */		and	%o5,%l5,%g3
/* 0x3258	     */		and	%o2,1,%g4
/* 0x325c	     */		and	%g3,%l3,%o3
/* 0x3260	     */		andcc	%o3,%g4,%g0
/* 0x3264	     */		be,a,pn	%icc,.L77004084
/* 0x3268	     */		or	%g0,0,%l4

! Registers live out of .L77004090: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004090

			.L77004091:
/* 0x326c	 496 */		sub	%i5,%i0,%g2
/* 0x3270	     */		sub	%i5,%l1,%l5
/* 0x3274	     */		sra	%g2,31,%l4
/* 0x3278	     */		sra	%l5,31,%l2
/* 0x327c	     */		xor	%g2,%l4,%o7
/* 0x3280	     */		xor	%l5,%l2,%l3
/* 0x3284	     */		add	%fp,-1600,%o1
/* 0x3288	     */		sub	%i5,%o1,%o4
/* 0x328c	     */		sub	%o7,%l4,%g2
/* 0x3290	     */		sub	%i5,%l6,%l7
/* 0x3294	     */		sub	%l3,%l2,%g5
/* 0x3298	     */		sra	%l7,31,%l4
/* 0x329c	     */		sra	%o4,31,%l3
/* 0x32a0	     */		xor	%l7,%l4,%o2
/* 0x32a4	     */		xor	%o4,%l3,%l5
/* 0x32a8	     */		sub	%i5,%i2,%o5
/* 0x32ac	     */		sub	%o2,%l4,%o7
/* 0x32b0	     */		sub	%i0,%o1,%o4
/* 0x32b4	     */		sra	%o5,31,%l2
/* 0x32b8	     */		xor	%o5,%l2,%o1
/* 0x32bc	     */		sub	%i5,%l0,%o3
/* 0x32c0	     */		sub	%l5,%l3,%g4
/* 0x32c4	     */		sub	%i5,%i3,%l4
/* 0x32c8	     */		sra	%l4,31,%l3
/* 0x32cc	     */		sub	%o1,%l2,%g3
/* 0x32d0	     */		sra	%o3,31,%l7
/* 0x32d4	     */		xor	%o3,%l7,%o2
/* 0x32d8	     */		sub	%i0,%l6,%o5
/* 0x32dc	     */		xor	%l4,%l3,%l5
/* 0x32e0	     */		sra	%o4,31,%l2
/* 0x32e4	     */		xor	%o4,%l2,%o1
/* 0x32e8	     */		sra	%o5,31,%l4
/* 0x32ec	     */		sub	%o2,%l7,%l7
/* 0x32f0	     */		sub	%i0,%l1,%o3
/* 0x32f4	     */		xor	%o5,%l4,%o2
/* 0x32f8	     */		sra	%o3,31,%o4
/* 0x32fc	     */		sub	%l5,%l3,%l5
/* 0x3300	     */		sub	%o1,%l2,%l2
/* 0x3304	     */		sub	%o2,%l4,%l3
/* 0x3308	     */		xor	%o3,%o4,%o1
/* 0x330c	     */		sub	%o1,%o4,%l4
/* 0x3310	     */		sra	%g2,0,%o4
/* 0x3314	     */		sub	%o4,%o0,%o3
/* 0x3318	     */		srlx	%o3,63,%g2
/* 0x331c	     */		xor	%g2,1,%o3
/* 0x3320	     */		sra	%o7,0,%o2
/* 0x3324	     */		sub	%o2,%o0,%g2
/* 0x3328	     */		srlx	%g2,63,%o7
/* 0x332c	     */		xor	%o7,1,%o2
/* 0x3330	     */		sra	%g5,0,%g5
/* 0x3334	     */		sra	%g4,0,%g4
/* 0x3338	     */		sub	%g5,%o0,%o5
/* 0x333c	     */		sub	%g4,%o0,%o7
/* 0x3340	     */		srlx	%o5,63,%g5
/* 0x3344	     */		srlx	%o7,63,%g4
/* 0x3348	     */		xor	%g5,1,%o5
/* 0x334c	     */		xor	%g4,1,%o4
/* 0x3350	     */		and	%o5,%o3,%o1
/* 0x3354	     */		and	%o4,%o2,%g2
/* 0x3358	     */		and	%g2,%o1,%o5
/* 0x335c	     */		sra	%l7,0,%o4
/* 0x3360	     */		sra	%g3,0,%g3
/* 0x3364	     */		sub	%g3,%o0,%o1
/* 0x3368	     */		sub	%o4,%o0,%o3
/* 0x336c	     */		srlx	%o1,63,%g3
/* 0x3370	     */		srlx	%o3,63,%l7
/* 0x3374	     */		xor	%g3,1,%g5
/* 0x3378	     */		xor	%l7,1,%o3
/* 0x337c	     */		and	%o3,%g5,%o7
/* 0x3380	     */		sra	%l5,0,%g5
/* 0x3384	     */		sra	%l2,0,%o2
/* 0x3388	     */		and	%o5,%o7,%o4
/* 0x338c	     */		sub	%g5,%o0,%o5
/* 0x3390	     */		sub	%o2,%o0,%g2
/* 0x3394	     */		srlx	%o5,63,%l5
/* 0x3398	     */		srlx	%g2,63,%l2
/* 0x339c	     */		xor	%l5,1,%g4
/* 0x33a0	     */		xor	%l2,1,%o1
/* 0x33a4	     */		and	%o1,%g4,%o2
/* 0x33a8	     */		sra	%l3,0,%g5
/* 0x33ac	     */		and	%o4,%o2,%o5
/* 0x33b0	     */		sra	%l4,0,%g2
/* 0x33b4	     */		sub	%g5,%o0,%o2
/* 0x33b8	     */		sub	%g2,%o0,%g3
/* 0x33bc	     */		srlx	%g3,63,%l4
/* 0x33c0	     */		srlx	%o2,63,%l3
/* 0x33c4	     */		xor	%l4,1,%g5
/* 0x33c8	     */		xor	%l3,1,%l7
/* 0x33cc	     */		and	%g5,%l7,%o3
/* 0x33d0	     */		andcc	%o5,%o3,%g0
/* 0x33d4	     */		be,a,pn	%icc,.L77004084
/* 0x33d8	     */		or	%g0,0,%l4

! Registers live out of .L77004091: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004091

			.L77004092:
/* 0x33dc	 496 */		sub	%i0,%i3,%o7
/* 0x33e0	     */		add	%fp,-1600,%o2
/* 0x33e4	     */		sub	%i2,%o2,%o1
/* 0x33e8	     */		sra	%o7,31,%g5
/* 0x33ec	     */		sub	%i0,%i2,%l7
/* 0x33f0	     */		xor	%o7,%g5,%o2
/* 0x33f4	     */		sra	%l7,31,%o5
/* 0x33f8	     */		sub	%o2,%g5,%l4
/* 0x33fc	     */		sra	%o1,31,%l3
/* 0x3400	     */		xor	%l7,%o5,%o4
/* 0x3404	     */		sub	%i0,%l0,%g2
/* 0x3408	     */		xor	%o1,%l3,%l2
/* 0x340c	     */		sra	%g2,31,%o3
/* 0x3410	     */		sub	%i2,%l6,%g3
/* 0x3414	     */		sub	%o4,%o5,%o2
/* 0x3418	     */		xor	%g2,%o3,%o5
/* 0x341c	     */		sra	%g3,31,%o1
/* 0x3420	     */		sub	%l2,%l3,%l5
/* 0x3424	     */		xor	%g3,%o1,%o7
/* 0x3428	     */		sub	%o5,%o3,%g5
/* 0x342c	     */		sub	%i2,%i3,%g2
/* 0x3430	     */		sub	%i2,%l0,%o5
/* 0x3434	     */		sub	%o7,%o1,%g3
/* 0x3438	     */		sra	%g2,31,%l3
/* 0x343c	     */		xor	%g2,%l3,%l2
/* 0x3440	     */		sra	%o5,31,%o7
/* 0x3444	     */		sub	%i2,%l1,%g4
/* 0x3448	     */		sra	%g4,31,%o4
/* 0x344c	     */		xor	%o5,%o7,%o3
/* 0x3450	     */		sub	%l2,%l3,%l3
/* 0x3454	     */		sub	%o3,%o7,%l2
/* 0x3458	     */		xor	%g4,%o4,%g4
/* 0x345c	     */		sub	%g4,%o4,%l7
/* 0x3460	     */		sra	%l4,0,%o3
/* 0x3464	     */		sra	%l5,0,%o1
/* 0x3468	     */		sra	%o2,0,%o2
/* 0x346c	     */		sra	%g5,0,%g5
/* 0x3470	     */		sub	%o3,%o0,%o7
/* 0x3474	     */		sub	%o1,%o0,%o4
/* 0x3478	     */		sub	%o2,%o0,%o5
/* 0x347c	     */		sub	%g5,%o0,%g2
/* 0x3480	     */		srlx	%o7,63,%l4
/* 0x3484	     */		srlx	%o4,63,%l5
/* 0x3488	     */		srlx	%o5,63,%o2
/* 0x348c	     */		srlx	%g2,63,%g5
/* 0x3490	     */		xor	%l4,1,%g4
/* 0x3494	     */		xor	%l5,1,%o1
/* 0x3498	     */		xor	%o2,1,%o5
/* 0x349c	     */		xor	%g5,1,%o4
/* 0x34a0	     */		and	%o1,%g4,%o3
/* 0x34a4	     */		and	%o5,%o4,%g2
/* 0x34a8	     */		and	%g2,%o3,%g4
/* 0x34ac	     */		sra	%l7,0,%o7
/* 0x34b0	     */		sra	%g3,0,%g3
/* 0x34b4	     */		sub	%o7,%o0,%o1
/* 0x34b8	     */		sub	%g3,%o0,%o3
/* 0x34bc	     */		srlx	%o1,63,%l7
/* 0x34c0	     */		srlx	%o3,63,%g3
/* 0x34c4	     */		xor	%g3,1,%l5
/* 0x34c8	     */		xor	%l7,1,%o7
/* 0x34cc	     */		and	%o7,%l5,%l4
/* 0x34d0	     */		and	%g4,%l4,%o5
/* 0x34d4	     */		sra	%l3,0,%g4
/* 0x34d8	     */		sub	%g4,%o0,%o4
/* 0x34dc	     */		sra	%l2,0,%o1
/* 0x34e0	     */		sub	%o1,%o0,%o0
/* 0x34e4	     */		srlx	%o4,63,%l3
/* 0x34e8	     */		srlx	%o0,63,%l2
/* 0x34ec	     */		xor	%l3,1,%g5
/* 0x34f0	     */		xor	%l2,1,%o2
/* 0x34f4	     */		and	%g5,%o2,%o4
/* 0x34f8	     */		andcc	%o5,%o4,%g0
/* 0x34fc	     */		be,a,pn	%icc,.L77004084
/* 0x3500	     */		or	%g0,0,%l4

! Registers live out of .L77004092: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004092

			.L77004199:
/* 0x3504	 496 */		sethi	%hi(0x1000),%g1
/* 0x3508	     */		xor	%g1,-704,%g1
/* 0x350c	     */		add	%g1,%fp,%l7
/* 0x3510	     */		sethi	%hi(0x1800),%g1
/* 0x3514	     */		xor	%g1,-256,%g1
/* 0x3518	     */		add	%i1,-1,%g4
/* 0x351c	     */		or	%g0,0,%g5
/* 0x3520	     */		add	%fp,-1600,%g3
/* 0x3524	     */		add	%fp,-3200,%g2

!  497		      !            if (mask[i]) {

/* 0x3528	 497 */		ldub	[%i3],%o2
/* 0x352c	 496 */		add	%g1,%fp,%l3

! Registers live out of .L77004199: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003879 .L77004199

			.L900000473:
/* 0x3530	 497 */		cmp	%o2,0
/* 0x3534	     */		be,pn	%icc,.L77003879
/* 0x3538	 496 */		add	%g5,1,%g5

! Registers live out of .L900000473: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  498		      !               red[i]   = red[i]   & ~rdest[i];

                       
! predecessor blocks: .L900000473

			.L77003877:
/* 0x353c	 498 */		ldub	[%i4],%l0

!  499		      !               green[i] = green[i] & ~gdest[i];

/* 0x3540	 499 */		ldub	[%i5],%o7

!  500		      !               blue[i]  = blue[i]  & ~bdest[i];

/* 0x3544	 500 */		ldub	[%i0],%l4

!  501		      !               alpha[i] = alpha[i] & ~adest[i];

/* 0x3548	 501 */		ldub	[%i2],%l5
/* 0x354c	 498 */		ldub	[%g3],%i1
/* 0x3550	 499 */		ldub	[%g2],%l1
/* 0x3554	 500 */		ldub	[%l7],%l2
/* 0x3558	 501 */		ldub	[%l3],%o5
/* 0x355c	 498 */		andn	%l0,%i1,%o3
/* 0x3560	     */		stb	%o3,[%i4]
/* 0x3564	 499 */		andn	%o7,%l1,%o1
/* 0x3568	     */		stb	%o1,[%i5]
/* 0x356c	 500 */		andn	%l4,%l2,%o4
/* 0x3570	     */		stb	%o4,[%i0]
/* 0x3574	 501 */		andn	%l5,%o5,%l6
/* 0x3578	     */		stb	%l6,[%i2]

! Registers live out of .L77003877: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003877 .L900000473

			.L77003879:
/* 0x357c	 496 */		cmp	%g5,%g4
/* 0x3580	     */		add	%i3,1,%i3
/* 0x3584	     */		add	%l3,1,%l3
/* 0x3588	     */		add	%l7,1,%l7
/* 0x358c	     */		add	%g2,1,%g2
/* 0x3590	     */		add	%g3,1,%g3
/* 0x3594	     */		add	%i2,1,%i2
/* 0x3598	     */		add	%i0,1,%i0
/* 0x359c	     */		add	%i5,1,%i5
/* 0x35a0	     */		add	%i4,1,%i4
/* 0x35a4	     */		ble,a,pt	%icc,.L900000473
/* 0x35a8	 497 */		ldub	[%i3],%o2

! Registers live out of .L77003879: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003879

			.L77004087:
/* 0x35ac	 496 */		ba	.L77003932
/* 0x35b0	     */		nop

! Registers live out of .L77004087: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003960

			.L77004329:
/* 0x35b4	 496 */		ld	[%fp+92],%i0
/* 0x35b8	     */		ld	[%fp+96],%i2
/* 0x35bc	     */		or	%g0,0,%l4

! Registers live out of .L77004329: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004090 .L77004091 .L77004092 .L77004329

			.L77004084:
/* 0x35c0	 497 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004084: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004084 .L77004086

			.L900000472:
/* 0x35c4	 497 */		cmp	%g3,0
/* 0x35c8	     */		be,pn	%icc,.L77004086
/* 0x35cc	 498 */		add	%fp,-1600,%g3

! Registers live out of .L900000472: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000472

			.L77004085:
/* 0x35d0	 498 */		ldub	[%l4+%g3],%o0
/* 0x35d4	     */		ldub	[%i4+%l4],%g2
/* 0x35d8	     */		andn	%g2,%o0,%o1
/* 0x35dc	     */		stb	%o1,[%i4+%l4]
/* 0x35e0	 499 */		ldub	[%l4+%l6],%g5
/* 0x35e4	     */		ldub	[%i5+%l4],%o7
/* 0x35e8	     */		andn	%o7,%g5,%l7
/* 0x35ec	     */		stb	%l7,[%i5+%l4]
/* 0x35f0	 500 */		ldub	[%l4+%l1],%o2
/* 0x35f4	     */		ldub	[%l4+%i0],%l2
/* 0x35f8	     */		andn	%l2,%o2,%o4
/* 0x35fc	     */		stb	%o4,[%l4+%i0]
/* 0x3600	 501 */		ldub	[%l4+%l0],%l5
/* 0x3604	     */		ldub	[%l4+%i2],%o5
/* 0x3608	     */		andn	%o5,%l5,%l3
/* 0x360c	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004085: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004085 .L900000472

			.L77004086:
/* 0x3610	 496 */		add	%l4,1,%l4
/* 0x3614	     */		cmp	%l4,%i1
/* 0x3618	     */		bcs,a,pn	%icc,.L900000472
/* 0x361c	 497 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004086: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004086

			.L900000452:
/* 0x3620	 496 */		ba	.L77003932
/* 0x3624	     */		nop

! Registers live out of .L900000452: 
! sp fp i7 gsr 
! 
		
!  502		      !            }
!  503		      !         }
!  504		      !         break;
!  505		      !      case GL_AND_INVERTED:
!  506		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003885:
/* 0x3628	 506 */		cmp	%i1,0
/* 0x362c	     */		bleu,pn	%icc,.L77003932
/* 0x3630	     */		cmp	%i1,54

! Registers live out of .L77003885: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003885

			.L77003959:
/* 0x3634	 506 */		ld	[%fp+100],%i3
/* 0x3638	     */		bl,pn	%icc,.L77004331
/* 0x363c	     */		sub	%i4,%i5,%i0

! Registers live out of .L77003959: 
! g1 sp l0 l1 l6 i0 i1 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003959

			.L77004078:
/* 0x3640	 506 */		add	%fp,-1600,%o0
/* 0x3644	     */		sub	%i4,%o0,%o1
/* 0x3648	     */		sra	%i0,31,%o0
/* 0x364c	     */		xor	%i0,%o0,%i2
/* 0x3650	     */		sub	%i4,%l6,%o2
/* 0x3654	     */		sub	%i2,%o0,%l7
/* 0x3658	     */		sra	%o2,31,%g4
/* 0x365c	     */		sub	%i4,%l0,%g5
/* 0x3660	     */		sub	%i4,%i3,%i0
/* 0x3664	     */		xor	%o2,%g4,%l2
/* 0x3668	     */		sra	%g5,31,%o5
/* 0x366c	     */		sra	%i0,31,%i2
/* 0x3670	     */		xor	%g5,%o5,%o3
/* 0x3674	     */		xor	%i0,%i2,%o2
/* 0x3678	     */		sub	%o2,%i2,%g5
/* 0x367c	     */		sub	%i4,%l1,%l5
/* 0x3680	     */		sra	%l5,31,%g2
/* 0x3684	     */		xor	%l5,%g2,%l3
/* 0x3688	     */		sub	%o3,%o5,%o0
/* 0x368c	     */		sub	%l2,%g4,%g3
/* 0x3690	     */		sub	%l3,%g2,%l2
/* 0x3694	     */		sra	%o1,31,%o7
/* 0x3698	     */		xor	%o1,%o7,%o4
/* 0x369c	     */		sub	%o4,%o7,%l4
/* 0x36a0	     */		sra	%l7,0,%g2
/* 0x36a4	     */		sra	%l4,0,%o7
/* 0x36a8	     */		sra	%l2,0,%o1
/* 0x36ac	     */		sra	%g3,0,%g3
/* 0x36b0	     */		ld	[%fp+96],%i2
/* 0x36b4	     */		ld	[%fp+92],%i0
/* 0x36b8	     */		sub	%i4,%i2,%o3
/* 0x36bc	     */		sra	%o3,31,%l3
/* 0x36c0	     */		xor	%o3,%l3,%o5
/* 0x36c4	     */		sub	%i4,%i0,%g4
/* 0x36c8	     */		sra	%g4,31,%l5
/* 0x36cc	     */		sra	%o0,0,%o3
/* 0x36d0	     */		sra	%i1,0,%o0
/* 0x36d4	     */		xor	%g4,%l5,%o4
/* 0x36d8	     */		sub	%o5,%l3,%l7
/* 0x36dc	     */		sra	%g5,0,%o5
/* 0x36e0	     */		sub	%g2,%o0,%g4
/* 0x36e4	     */		srlx	%g4,63,%l2
/* 0x36e8	     */		sub	%o7,%o0,%g5
/* 0x36ec	     */		sub	%o4,%l5,%o2
/* 0x36f0	     */		sub	%g3,%o0,%g4
/* 0x36f4	     */		sub	%o3,%o0,%g2
/* 0x36f8	     */		srlx	%g5,63,%l4
/* 0x36fc	     */		sra	%l7,0,%o4
/* 0x3700	     */		sub	%o1,%o0,%g5
/* 0x3704	     */		srlx	%g2,63,%g3
/* 0x3708	     */		srlx	%g4,63,%l3
/* 0x370c	     */		srlx	%g5,63,%l5
/* 0x3710	     */		sub	%o4,%o0,%g2
/* 0x3714	     */		sra	%o2,0,%o2
/* 0x3718	     */		sub	%o2,%o0,%g5
/* 0x371c	     */		srlx	%g2,63,%g4
/* 0x3720	     */		srlx	%g5,63,%o2
/* 0x3724	     */		xor	%l2,1,%o1
/* 0x3728	     */		xor	%l3,1,%o7
/* 0x372c	     */		sub	%o5,%o0,%g2
/* 0x3730	     */		and	%o7,%o1,%g5
/* 0x3734	     */		xor	%g4,1,%o5
/* 0x3738	     */		xor	%g3,1,%l7
/* 0x373c	     */		and	%l7,%o5,%l3
/* 0x3740	     */		sethi	%hi(0x7ffffc00),%o1
/* 0x3744	     */		add	%o1,1022,%o5
/* 0x3748	     */		srl	%i1,0,%o7
/* 0x374c	     */		xor	%l5,1,%o3
/* 0x3750	     */		xor	%o2,1,%o4
/* 0x3754	     */		sub	%o7,%o5,%o7
/* 0x3758	     */		xor	%l4,1,%l4
/* 0x375c	     */		and	%o3,%o4,%l5
/* 0x3760	     */		srlx	%o7,63,%o2
/* 0x3764	     */		and	%o2,%l4,%o4
/* 0x3768	     */		srlx	%g2,63,%l2
/* 0x376c	     */		and	%o4,%g5,%o3
/* 0x3770	     */		xor	%l2,1,%g2
/* 0x3774	     */		and	%o3,%l5,%g3
/* 0x3778	     */		and	%g2,1,%g4
/* 0x377c	     */		and	%g3,%l3,%o5
/* 0x3780	     */		andcc	%o5,%g4,%g0
/* 0x3784	     */		be,a,pn	%icc,.L77004072
/* 0x3788	     */		or	%g0,0,%l4

! Registers live out of .L77004078: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004078

			.L77004079:
/* 0x378c	 506 */		sub	%i5,%i0,%g2
/* 0x3790	     */		sub	%i5,%l1,%l5
/* 0x3794	     */		sra	%g2,31,%l4
/* 0x3798	     */		sra	%l5,31,%o7
/* 0x379c	     */		xor	%g2,%l4,%o1
/* 0x37a0	     */		xor	%l5,%o7,%l3
/* 0x37a4	     */		add	%fp,-1600,%o4
/* 0x37a8	     */		sub	%i5,%o4,%g3
/* 0x37ac	     */		sub	%o1,%l4,%g2
/* 0x37b0	     */		sub	%l3,%o7,%g5
/* 0x37b4	     */		sub	%i5,%l6,%l7
/* 0x37b8	     */		sub	%i5,%i2,%o5
/* 0x37bc	     */		sra	%l7,31,%o1
/* 0x37c0	     */		sra	%g3,31,%l4
/* 0x37c4	     */		sra	%o5,31,%l3
/* 0x37c8	     */		xor	%l7,%o1,%l2
/* 0x37cc	     */		xor	%g3,%l4,%l5
/* 0x37d0	     */		xor	%o5,%l3,%o7
/* 0x37d4	     */		sub	%i5,%l0,%o3
/* 0x37d8	     */		sub	%l2,%o1,%o2
/* 0x37dc	     */		sub	%i0,%o4,%o4
/* 0x37e0	     */		sub	%o7,%l3,%g3
/* 0x37e4	     */		sra	%o3,31,%l7
/* 0x37e8	     */		xor	%o3,%l7,%l2
/* 0x37ec	     */		sra	%o4,31,%l3
/* 0x37f0	     */		sub	%l5,%l4,%g4
/* 0x37f4	     */		sub	%i5,%i3,%o1
/* 0x37f8	     */		sra	%o1,31,%l4
/* 0x37fc	     */		xor	%o4,%l3,%o7
/* 0x3800	     */		sub	%l2,%l7,%l7
/* 0x3804	     */		sub	%o7,%l3,%l2
/* 0x3808	     */		sub	%i0,%l6,%o5
/* 0x380c	     */		sub	%i0,%l1,%o3
/* 0x3810	     */		xor	%o1,%l4,%l5
/* 0x3814	     */		sra	%o5,31,%o4
/* 0x3818	     */		sra	%o3,31,%o7
/* 0x381c	     */		sub	%l5,%l4,%l5
/* 0x3820	     */		xor	%o5,%o4,%o1
/* 0x3824	     */		xor	%o3,%o7,%l4
/* 0x3828	     */		sub	%o1,%o4,%l3
/* 0x382c	     */		sub	%l4,%o7,%l4
/* 0x3830	     */		sra	%g2,0,%o7
/* 0x3834	     */		sra	%g5,0,%o4
/* 0x3838	     */		sub	%o7,%o0,%o1
/* 0x383c	     */		sub	%o4,%o0,%g5
/* 0x3840	     */		srlx	%o1,63,%g2
/* 0x3844	     */		srlx	%g5,63,%g5
/* 0x3848	     */		xor	%g2,1,%o3
/* 0x384c	     */		xor	%g5,1,%o5
/* 0x3850	     */		and	%o5,%o3,%o1
/* 0x3854	     */		sra	%o2,0,%o3
/* 0x3858	     */		sra	%g4,0,%g4
/* 0x385c	     */		sub	%o3,%o0,%o5
/* 0x3860	     */		sub	%g4,%o0,%g2
/* 0x3864	     */		srlx	%o5,63,%o2
/* 0x3868	     */		srlx	%g2,63,%g4
/* 0x386c	     */		xor	%o2,1,%o4
/* 0x3870	     */		xor	%g4,1,%o7
/* 0x3874	     */		and	%o7,%o4,%g2
/* 0x3878	     */		and	%g2,%o1,%o5
/* 0x387c	     */		sra	%l7,0,%o7
/* 0x3880	     */		sra	%g3,0,%g3
/* 0x3884	     */		sub	%g3,%o0,%o2
/* 0x3888	     */		sub	%o7,%o0,%o1
/* 0x388c	     */		srlx	%o2,63,%g3
/* 0x3890	     */		srlx	%o1,63,%l7
/* 0x3894	     */		xor	%g3,1,%g5
/* 0x3898	     */		xor	%l7,1,%o3
/* 0x389c	     */		and	%o3,%g5,%o2
/* 0x38a0	     */		sra	%l5,0,%o4
/* 0x38a4	     */		sra	%l2,0,%o3
/* 0x38a8	     */		and	%o5,%o2,%o7
/* 0x38ac	     */		sub	%o4,%o0,%g5
/* 0x38b0	     */		sub	%o3,%o0,%o5
/* 0x38b4	     */		srlx	%g5,63,%l5
/* 0x38b8	     */		srlx	%o5,63,%l2
/* 0x38bc	     */		xor	%l5,1,%g4
/* 0x38c0	     */		xor	%l2,1,%o1
/* 0x38c4	     */		and	%o1,%g4,%o4
/* 0x38c8	     */		sra	%l3,0,%g3
/* 0x38cc	     */		and	%o7,%o4,%o5
/* 0x38d0	     */		sub	%g3,%o0,%o4
/* 0x38d4	     */		sra	%l4,0,%g2
/* 0x38d8	     */		sub	%g2,%o0,%g3
/* 0x38dc	     */		srlx	%g3,63,%l4
/* 0x38e0	     */		srlx	%o4,63,%l3
/* 0x38e4	     */		xor	%l4,1,%g5
/* 0x38e8	     */		xor	%l3,1,%l7
/* 0x38ec	     */		and	%g5,%l7,%o3
/* 0x38f0	     */		andcc	%o5,%o3,%g0
/* 0x38f4	     */		be,a,pn	%icc,.L77004072
/* 0x38f8	     */		or	%g0,0,%l4

! Registers live out of .L77004079: 
! g1 o0 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004079

			.L77004080:
/* 0x38fc	 506 */		add	%fp,-1600,%l5
/* 0x3900	     */		sub	%i2,%l5,%o7
/* 0x3904	     */		sra	%o7,31,%l2
/* 0x3908	     */		sub	%i0,%i3,%o3
/* 0x390c	     */		sub	%i0,%i2,%l7
/* 0x3910	     */		sra	%o3,31,%g5
/* 0x3914	     */		xor	%o7,%l2,%o2
/* 0x3918	     */		sra	%l7,31,%o5
/* 0x391c	     */		xor	%o3,%g5,%o1
/* 0x3920	     */		sub	%o2,%l2,%l5
/* 0x3924	     */		xor	%l7,%o5,%o4
/* 0x3928	     */		sub	%i0,%l0,%g2
/* 0x392c	     */		sra	%g2,31,%o3
/* 0x3930	     */		sub	%i2,%l6,%g3
/* 0x3934	     */		sub	%o4,%o5,%o2
/* 0x3938	     */		sub	%o1,%g5,%l4
/* 0x393c	     */		xor	%g2,%o3,%o5
/* 0x3940	     */		sra	%g3,31,%o7
/* 0x3944	     */		xor	%g3,%o7,%o1
/* 0x3948	     */		sub	%o5,%o3,%g5
/* 0x394c	     */		sub	%i2,%i3,%g2
/* 0x3950	     */		sub	%i2,%l0,%o5
/* 0x3954	     */		sub	%o1,%o7,%g3
/* 0x3958	     */		sra	%g2,31,%l3
/* 0x395c	     */		xor	%g2,%l3,%l2
/* 0x3960	     */		sra	%o5,31,%o1
/* 0x3964	     */		sub	%i2,%l1,%g4
/* 0x3968	     */		sra	%g4,31,%o4
/* 0x396c	     */		xor	%o5,%o1,%o3
/* 0x3970	     */		sub	%l2,%l3,%l3
/* 0x3974	     */		sub	%o3,%o1,%l2
/* 0x3978	     */		xor	%g4,%o4,%g4
/* 0x397c	     */		sub	%g4,%o4,%l7
/* 0x3980	     */		sra	%l4,0,%o3
/* 0x3984	     */		sra	%l5,0,%o7
/* 0x3988	     */		sra	%o2,0,%o2
/* 0x398c	     */		sra	%g5,0,%g5
/* 0x3990	     */		sub	%o3,%o0,%o1
/* 0x3994	     */		sub	%o7,%o0,%o4
/* 0x3998	     */		sub	%o2,%o0,%o5
/* 0x399c	     */		sub	%g5,%o0,%g2
/* 0x39a0	     */		srlx	%o1,63,%l4
/* 0x39a4	     */		srlx	%o4,63,%l5
/* 0x39a8	     */		srlx	%o5,63,%o2
/* 0x39ac	     */		srlx	%g2,63,%g5
/* 0x39b0	     */		xor	%l4,1,%g4
/* 0x39b4	     */		xor	%l5,1,%o7
/* 0x39b8	     */		xor	%o2,1,%o5
/* 0x39bc	     */		xor	%g5,1,%o4
/* 0x39c0	     */		and	%o7,%g4,%o3
/* 0x39c4	     */		and	%o5,%o4,%g2
/* 0x39c8	     */		and	%g2,%o3,%g4
/* 0x39cc	     */		sra	%l7,0,%o1
/* 0x39d0	     */		sra	%g3,0,%g3
/* 0x39d4	     */		sub	%o1,%o0,%o7
/* 0x39d8	     */		sub	%g3,%o0,%o3
/* 0x39dc	     */		srlx	%o7,63,%l7
/* 0x39e0	     */		srlx	%o3,63,%g3
/* 0x39e4	     */		xor	%g3,1,%l5
/* 0x39e8	     */		xor	%l7,1,%o1
/* 0x39ec	     */		and	%o1,%l5,%l4
/* 0x39f0	     */		and	%g4,%l4,%o5
/* 0x39f4	     */		sra	%l3,0,%g4
/* 0x39f8	     */		sub	%g4,%o0,%o4
/* 0x39fc	     */		sra	%l2,0,%o7
/* 0x3a00	     */		sub	%o7,%o0,%o0
/* 0x3a04	     */		srlx	%o4,63,%l3
/* 0x3a08	     */		srlx	%o0,63,%l2
/* 0x3a0c	     */		xor	%l3,1,%g5
/* 0x3a10	     */		xor	%l2,1,%o2
/* 0x3a14	     */		and	%g5,%o2,%o4
/* 0x3a18	     */		andcc	%o5,%o4,%g0
/* 0x3a1c	     */		be,a,pn	%icc,.L77004072
/* 0x3a20	     */		or	%g0,0,%l4

! Registers live out of .L77004080: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004080

			.L77004198:
/* 0x3a24	 506 */		sethi	%hi(0x1000),%g1
/* 0x3a28	     */		xor	%g1,-704,%g1
/* 0x3a2c	     */		add	%g1,%fp,%l7
/* 0x3a30	     */		sethi	%hi(0x1800),%g1
/* 0x3a34	     */		xor	%g1,-256,%g1
/* 0x3a38	     */		add	%i1,-1,%o0
/* 0x3a3c	     */		or	%g0,0,%g4
/* 0x3a40	     */		add	%fp,-1600,%g3
/* 0x3a44	     */		add	%fp,-3200,%g2

!  507		      !            if (mask[i]) {

/* 0x3a48	 507 */		ldub	[%i3],%o2
/* 0x3a4c	 506 */		add	%g1,%fp,%l3

! Registers live out of .L77004198: 
! g2 g3 g4 o0 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003893 .L77004198

			.L900000471:
/* 0x3a50	 507 */		cmp	%o2,0
/* 0x3a54	     */		be,pn	%icc,.L77003893
/* 0x3a58	 506 */		add	%g4,1,%g4

! Registers live out of .L900000471: 
! g2 g3 g4 o0 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  508		      !               red[i]   = ~red[i]   & rdest[i];

                       
! predecessor blocks: .L900000471

			.L77003891:
/* 0x3a5c	 508 */		ldub	[%i4],%i1

!  509		      !               green[i] = ~green[i] & gdest[i];

/* 0x3a60	 509 */		ldub	[%i5],%l1

!  510		      !               blue[i]  = ~blue[i]  & bdest[i];

/* 0x3a64	 510 */		ldub	[%i0],%l2

!  511		      !               alpha[i] = ~alpha[i] & adest[i];

/* 0x3a68	 511 */		ldub	[%i2],%o5
/* 0x3a6c	 508 */		ldub	[%g3],%l0
/* 0x3a70	 509 */		ldub	[%g2],%o7
/* 0x3a74	 510 */		ldub	[%l7],%l4
/* 0x3a78	 511 */		ldub	[%l3],%l5
/* 0x3a7c	 508 */		andn	%l0,%i1,%o3
/* 0x3a80	     */		stb	%o3,[%i4]
/* 0x3a84	 509 */		andn	%o7,%l1,%o1
/* 0x3a88	     */		stb	%o1,[%i5]
/* 0x3a8c	 510 */		andn	%l4,%l2,%o4
/* 0x3a90	     */		stb	%o4,[%i0]
/* 0x3a94	 511 */		andn	%l5,%o5,%l6
/* 0x3a98	     */		stb	%l6,[%i2]

! Registers live out of .L77003891: 
! g2 g3 g4 o0 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003891 .L900000471

			.L77003893:
/* 0x3a9c	 506 */		cmp	%g4,%o0
/* 0x3aa0	     */		add	%i3,1,%i3
/* 0x3aa4	     */		add	%l3,1,%l3
/* 0x3aa8	     */		add	%l7,1,%l7
/* 0x3aac	     */		add	%g2,1,%g2
/* 0x3ab0	     */		add	%g3,1,%g3
/* 0x3ab4	     */		add	%i2,1,%i2
/* 0x3ab8	     */		add	%i0,1,%i0
/* 0x3abc	     */		add	%i5,1,%i5
/* 0x3ac0	     */		add	%i4,1,%i4
/* 0x3ac4	     */		ble,a,pt	%icc,.L900000471
/* 0x3ac8	 507 */		ldub	[%i3],%o2

! Registers live out of .L77003893: 
! g2 g3 g4 o0 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003893

			.L77004075:
/* 0x3acc	 506 */		ba	.L77003932
/* 0x3ad0	     */		nop

! Registers live out of .L77004075: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003959

			.L77004331:
/* 0x3ad4	 506 */		ld	[%fp+92],%i0
/* 0x3ad8	     */		ld	[%fp+96],%i2
/* 0x3adc	     */		or	%g0,0,%l4

! Registers live out of .L77004331: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004078 .L77004079 .L77004080 .L77004331

			.L77004072:
/* 0x3ae0	 507 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004072: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004072 .L77004074

			.L900000470:
/* 0x3ae4	 507 */		cmp	%g3,0
/* 0x3ae8	     */		be,pn	%icc,.L77004074
/* 0x3aec	 508 */		add	%fp,-1600,%g2

! Registers live out of .L900000470: 
! g1 g2 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000470

			.L77004073:
/* 0x3af0	 508 */		ldub	[%l4+%g2],%o1
/* 0x3af4	     */		ldub	[%i4+%l4],%o0
/* 0x3af8	     */		andn	%o1,%o0,%o7
/* 0x3afc	     */		stb	%o7,[%i4+%l4]
/* 0x3b00	 509 */		ldub	[%i5+%l4],%g5
/* 0x3b04	     */		ldub	[%l4+%l6],%l7
/* 0x3b08	     */		andn	%l7,%g5,%l2
/* 0x3b0c	     */		stb	%l2,[%i5+%l4]
/* 0x3b10	 510 */		ldub	[%l4+%i0],%g2
/* 0x3b14	     */		ldub	[%l4+%l1],%o2
/* 0x3b18	     */		andn	%o2,%g2,%o4
/* 0x3b1c	     */		stb	%o4,[%l4+%i0]
/* 0x3b20	 511 */		ldub	[%l4+%i2],%l5
/* 0x3b24	     */		ldub	[%l4+%l0],%o3
/* 0x3b28	     */		andn	%o3,%l5,%l3
/* 0x3b2c	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004073: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004073 .L900000470

			.L77004074:
/* 0x3b30	 506 */		add	%l4,1,%l4
/* 0x3b34	     */		cmp	%l4,%i1
/* 0x3b38	     */		bcs,a,pn	%icc,.L900000470
/* 0x3b3c	 507 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77004074: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004074

			.L900000451:
/* 0x3b40	 506 */		ba	.L77003932
/* 0x3b44	     */		nop

! Registers live out of .L900000451: 
! sp fp i7 gsr 
! 
		
!  512		      !            }
!  513		      !         }
!  514		      !         break;
!  515		      !      case GL_OR_REVERSE:
!  516		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003899:
/* 0x3b48	 516 */		cmp	%i1,0
/* 0x3b4c	     */		bleu,pn	%icc,.L77003932
/* 0x3b50	     */		cmp	%i1,54

! Registers live out of .L77003899: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003899

			.L77003952:
/* 0x3b54	 516 */		ld	[%fp+100],%i3
/* 0x3b58	     */		bl,pn	%icc,.L77004345
/* 0x3b5c	     */		sub	%i4,%i5,%i2

! Registers live out of .L77003952: 
! g1 sp l0 l1 l6 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003952

			.L77003994:
/* 0x3b60	 516 */		add	%fp,-1600,%i0
/* 0x3b64	     */		sub	%i4,%i0,%o0
/* 0x3b68	     */		sra	%i2,31,%o7
/* 0x3b6c	     */		xor	%i2,%o7,%i0
/* 0x3b70	     */		sub	%i0,%o7,%l7
/* 0x3b74	     */		sub	%i4,%l0,%g5
/* 0x3b78	     */		sra	%o0,31,%o4
/* 0x3b7c	     */		sra	%g5,31,%o5
/* 0x3b80	     */		sub	%i4,%i3,%i0
/* 0x3b84	     */		xor	%o0,%o4,%o1
/* 0x3b88	     */		xor	%g5,%o5,%o3
/* 0x3b8c	     */		sra	%i0,31,%i2
/* 0x3b90	     */		sub	%o3,%o5,%o0
/* 0x3b94	     */		xor	%i0,%i2,%o7
/* 0x3b98	     */		sub	%i4,%l6,%g4
/* 0x3b9c	     */		sub	%o7,%i2,%o5
/* 0x3ba0	     */		sra	%g4,31,%o2
/* 0x3ba4	     */		sub	%i4,%l1,%l5
/* 0x3ba8	     */		xor	%g4,%o2,%l2
/* 0x3bac	     */		sra	%l5,31,%g2
/* 0x3bb0	     */		xor	%l5,%g2,%l3
/* 0x3bb4	     */		sub	%l2,%o2,%g3
/* 0x3bb8	     */		sub	%l3,%g2,%l2
/* 0x3bbc	     */		sub	%o1,%o4,%l4
/* 0x3bc0	     */		sra	%l7,0,%g2
/* 0x3bc4	     */		sra	%g3,0,%g3
/* 0x3bc8	     */		sra	%l4,0,%g4
/* 0x3bcc	     */		sra	%l2,0,%g5
/* 0x3bd0	     */		sra	%o5,0,%o5
/* 0x3bd4	     */		ld	[%fp+96],%i2
/* 0x3bd8	     */		ld	[%fp+92],%i0
/* 0x3bdc	     */		sub	%i4,%i2,%o3
/* 0x3be0	     */		sra	%o3,31,%l3
/* 0x3be4	     */		xor	%o3,%l3,%o7
/* 0x3be8	     */		sub	%i4,%i0,%o2
/* 0x3bec	     */		sra	%o2,31,%o4
/* 0x3bf0	     */		sub	%o7,%l3,%l7
/* 0x3bf4	     */		sra	%i1,0,%o7
/* 0x3bf8	     */		xor	%o2,%o4,%o1
/* 0x3bfc	     */		sra	%o0,0,%o3
/* 0x3c00	     */		sub	%o1,%o4,%l5
/* 0x3c04	     */		sub	%g2,%o7,%o0
/* 0x3c08	     */		sra	%l5,0,%o2
/* 0x3c0c	     */		sub	%g3,%o7,%g2
/* 0x3c10	     */		sub	%g4,%o7,%g3
/* 0x3c14	     */		sub	%o2,%o7,%o1
/* 0x3c18	     */		sra	%l7,0,%o4
/* 0x3c1c	     */		srlx	%o0,63,%l2
/* 0x3c20	     */		sub	%g5,%o7,%g4
/* 0x3c24	     */		srlx	%o1,63,%l5
/* 0x3c28	     */		srlx	%g3,63,%l4
/* 0x3c2c	     */		srlx	%g4,63,%o0
/* 0x3c30	     */		sub	%o4,%o7,%o2
/* 0x3c34	     */		sub	%o5,%o7,%o1
/* 0x3c38	     */		sub	%o3,%o7,%g3
/* 0x3c3c	     */		srlx	%o2,63,%g4
/* 0x3c40	     */		xor	%o0,1,%o5
/* 0x3c44	     */		xor	%l5,1,%o4
/* 0x3c48	     */		srlx	%g2,63,%g2
/* 0x3c4c	     */		srlx	%g3,63,%g3
/* 0x3c50	     */		xor	%g2,1,%o2
/* 0x3c54	     */		and	%o5,%o4,%l5
/* 0x3c58	     */		xor	%g4,1,%o3
/* 0x3c5c	     */		xor	%g3,1,%l3
/* 0x3c60	     */		xor	%l2,1,%g5
/* 0x3c64	     */		and	%l3,%o3,%o5
/* 0x3c68	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x3c6c	     */		and	%o2,%g5,%g5
/* 0x3c70	     */		add	%g2,1022,%o3
/* 0x3c74	     */		srl	%i1,0,%g3
/* 0x3c78	     */		sub	%g3,%o3,%o2
/* 0x3c7c	     */		srlx	%o1,63,%l7
/* 0x3c80	     */		xor	%l4,1,%l4
/* 0x3c84	     */		srlx	%o2,63,%o1
/* 0x3c88	     */		and	%o1,%l4,%o0
/* 0x3c8c	     */		and	%o0,%g5,%o4
/* 0x3c90	     */		xor	%l7,1,%l2
/* 0x3c94	     */		and	%o4,%l5,%g3
/* 0x3c98	     */		and	%l2,1,%g4
/* 0x3c9c	     */		and	%g3,%o5,%o3
/* 0x3ca0	     */		andcc	%o3,%g4,%g0
/* 0x3ca4	     */		be,a,pn	%icc,.L77003988
/* 0x3ca8	     */		or	%g0,0,%l4

! Registers live out of .L77003994: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003994

			.L77003995:
/* 0x3cac	 516 */		sub	%i5,%i0,%g2
/* 0x3cb0	     */		sra	%g2,31,%l4
/* 0x3cb4	     */		xor	%g2,%l4,%o4
/* 0x3cb8	     */		sub	%o4,%l4,%g2
/* 0x3cbc	     */		sub	%i5,%l1,%l5
/* 0x3cc0	     */		sub	%i5,%l6,%l7
/* 0x3cc4	     */		sra	%l5,31,%o0
/* 0x3cc8	     */		sra	%l7,31,%o4
/* 0x3ccc	     */		add	%fp,-1600,%o1
/* 0x3cd0	     */		sub	%i5,%o1,%g3
/* 0x3cd4	     */		xor	%l5,%o0,%l3
/* 0x3cd8	     */		xor	%l7,%o4,%l2
/* 0x3cdc	     */		sub	%l2,%o4,%o2
/* 0x3ce0	     */		sra	%g3,31,%l4
/* 0x3ce4	     */		sub	%i5,%i2,%o5
/* 0x3ce8	     */		sub	%l3,%o0,%g5
/* 0x3cec	     */		xor	%g3,%l4,%l5
/* 0x3cf0	     */		sub	%i0,%o1,%o4
/* 0x3cf4	     */		sra	%o5,31,%l3
/* 0x3cf8	     */		xor	%o5,%l3,%o1
/* 0x3cfc	     */		sub	%i5,%l0,%o3
/* 0x3d00	     */		sub	%l5,%l4,%g4
/* 0x3d04	     */		sra	%o3,31,%l2
/* 0x3d08	     */		sub	%i5,%i3,%l5
/* 0x3d0c	     */		sub	%o1,%l3,%g3
/* 0x3d10	     */		xor	%o3,%l2,%o0
/* 0x3d14	     */		sra	%l5,31,%o1
/* 0x3d18	     */		sub	%o0,%l2,%l7
/* 0x3d1c	     */		xor	%l5,%o1,%l4
/* 0x3d20	     */		sra	%o4,31,%l3
/* 0x3d24	     */		sub	%l4,%o1,%l5
/* 0x3d28	     */		xor	%o4,%l3,%o0
/* 0x3d2c	     */		sub	%i0,%l6,%o5
/* 0x3d30	     */		sub	%o0,%l3,%l2
/* 0x3d34	     */		sra	%o5,31,%l4
/* 0x3d38	     */		sub	%i0,%l1,%o3
/* 0x3d3c	     */		xor	%o5,%l4,%o4
/* 0x3d40	     */		sra	%o3,31,%o0
/* 0x3d44	     */		sub	%o4,%l4,%l3
/* 0x3d48	     */		xor	%o3,%o0,%o1
/* 0x3d4c	     */		sub	%o1,%o0,%l4
/* 0x3d50	     */		sra	%g2,0,%o5
/* 0x3d54	     */		sub	%o5,%o7,%o0
/* 0x3d58	     */		srlx	%o0,63,%g2
/* 0x3d5c	     */		xor	%g2,1,%o3
/* 0x3d60	     */		sra	%g5,0,%g5
/* 0x3d64	     */		sub	%g5,%o7,%g2
/* 0x3d68	     */		srlx	%g2,63,%g5
/* 0x3d6c	     */		xor	%g5,1,%o5
/* 0x3d70	     */		and	%o5,%o3,%o0
/* 0x3d74	     */		sra	%o2,0,%o3
/* 0x3d78	     */		sra	%g4,0,%g4
/* 0x3d7c	     */		sub	%o3,%o7,%o1
/* 0x3d80	     */		sub	%g4,%o7,%o4
/* 0x3d84	     */		srlx	%o1,63,%o2
/* 0x3d88	     */		srlx	%o4,63,%g4
/* 0x3d8c	     */		xor	%o2,1,%o1
/* 0x3d90	     */		xor	%g4,1,%o4
/* 0x3d94	     */		and	%o4,%o1,%g2
/* 0x3d98	     */		and	%g2,%o0,%g4
/* 0x3d9c	     */		sra	%l7,0,%o5
/* 0x3da0	     */		sra	%g3,0,%g3
/* 0x3da4	     */		sub	%g3,%o7,%o2
/* 0x3da8	     */		sub	%o5,%o7,%o0
/* 0x3dac	     */		srlx	%o2,63,%g3
/* 0x3db0	     */		srlx	%o0,63,%l7
/* 0x3db4	     */		xor	%g3,1,%g5
/* 0x3db8	     */		xor	%l7,1,%o3
/* 0x3dbc	     */		and	%o3,%g5,%o5
/* 0x3dc0	     */		sra	%l5,0,%g5
/* 0x3dc4	     */		sub	%g5,%o7,%g2
/* 0x3dc8	     */		and	%g4,%o5,%o4
/* 0x3dcc	     */		sra	%l2,0,%o3
/* 0x3dd0	     */		srlx	%g2,63,%l5
/* 0x3dd4	     */		sub	%o3,%o7,%o1
/* 0x3dd8	     */		sra	%l3,0,%g4
/* 0x3ddc	     */		sra	%l4,0,%g2
/* 0x3de0	     */		srlx	%o1,63,%l2
/* 0x3de4	     */		sub	%g4,%o7,%g5
/* 0x3de8	     */		sub	%g2,%o7,%g3
/* 0x3dec	     */		srlx	%g3,63,%l4
/* 0x3df0	     */		srlx	%g5,63,%l3
/* 0x3df4	     */		xor	%l5,1,%o2
/* 0x3df8	     */		xor	%l2,1,%o0
/* 0x3dfc	     */		xor	%l4,1,%g5
/* 0x3e00	     */		and	%o0,%o2,%o1
/* 0x3e04	     */		xor	%l3,1,%l7
/* 0x3e08	     */		and	%o4,%o1,%o5
/* 0x3e0c	     */		and	%g5,%l7,%o3
/* 0x3e10	     */		andcc	%o5,%o3,%g0
/* 0x3e14	     */		be,a,pn	%icc,.L77003988
/* 0x3e18	     */		or	%g0,0,%l4

! Registers live out of .L77003995: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003995

			.L77003996:
/* 0x3e1c	 516 */		add	%fp,-1600,%o0
/* 0x3e20	     */		sub	%i2,%o0,%o2
/* 0x3e24	     */		sub	%i0,%i3,%l3
/* 0x3e28	     */		sub	%i0,%i2,%l7
/* 0x3e2c	     */		sra	%l3,31,%g5
/* 0x3e30	     */		sra	%l7,31,%o5
/* 0x3e34	     */		sra	%o2,31,%l5
/* 0x3e38	     */		xor	%l3,%g5,%o0
/* 0x3e3c	     */		xor	%o2,%l5,%o1
/* 0x3e40	     */		xor	%l7,%o5,%l2
/* 0x3e44	     */		sub	%i0,%l0,%g2
/* 0x3e48	     */		sub	%o0,%g5,%l4
/* 0x3e4c	     */		sra	%g2,31,%o3
/* 0x3e50	     */		sub	%i2,%l6,%g3
/* 0x3e54	     */		sub	%l2,%o5,%o2
/* 0x3e58	     */		xor	%g2,%o3,%o5
/* 0x3e5c	     */		sra	%g3,31,%o0
/* 0x3e60	     */		xor	%g3,%o0,%o4
/* 0x3e64	     */		sub	%o5,%o3,%g5
/* 0x3e68	     */		sub	%i2,%i3,%g2
/* 0x3e6c	     */		sub	%i2,%l0,%o5
/* 0x3e70	     */		sub	%o4,%o0,%g3
/* 0x3e74	     */		sra	%g2,31,%l3
/* 0x3e78	     */		xor	%g2,%l3,%l2
/* 0x3e7c	     */		sra	%o5,31,%o4
/* 0x3e80	     */		sub	%o1,%l5,%l5
/* 0x3e84	     */		sub	%i2,%l1,%g4
/* 0x3e88	     */		sra	%g4,31,%o1
/* 0x3e8c	     */		xor	%o5,%o4,%o3
/* 0x3e90	     */		sub	%l2,%l3,%l3
/* 0x3e94	     */		sub	%o3,%o4,%l2
/* 0x3e98	     */		xor	%g4,%o1,%g4
/* 0x3e9c	     */		sub	%g4,%o1,%l7
/* 0x3ea0	     */		sra	%l4,0,%o3
/* 0x3ea4	     */		sra	%l5,0,%o0
/* 0x3ea8	     */		sra	%o2,0,%o2
/* 0x3eac	     */		sra	%g5,0,%g5
/* 0x3eb0	     */		sub	%o3,%o7,%o4
/* 0x3eb4	     */		sub	%o0,%o7,%o1
/* 0x3eb8	     */		sub	%o2,%o7,%o5
/* 0x3ebc	     */		sub	%g5,%o7,%g2
/* 0x3ec0	     */		srlx	%o4,63,%l4
/* 0x3ec4	     */		srlx	%o1,63,%l5
/* 0x3ec8	     */		srlx	%o5,63,%o2
/* 0x3ecc	     */		srlx	%g2,63,%g5
/* 0x3ed0	     */		xor	%l4,1,%g4
/* 0x3ed4	     */		xor	%l5,1,%o0
/* 0x3ed8	     */		xor	%o2,1,%o5
/* 0x3edc	     */		xor	%g5,1,%o1
/* 0x3ee0	     */		and	%o0,%g4,%o3
/* 0x3ee4	     */		and	%o5,%o1,%g2
/* 0x3ee8	     */		and	%g2,%o3,%g4
/* 0x3eec	     */		sra	%l7,0,%o4
/* 0x3ef0	     */		sra	%g3,0,%g3
/* 0x3ef4	     */		sub	%o4,%o7,%o0
/* 0x3ef8	     */		sub	%g3,%o7,%o3
/* 0x3efc	     */		srlx	%o0,63,%l7
/* 0x3f00	     */		srlx	%o3,63,%g3
/* 0x3f04	     */		xor	%g3,1,%l5
/* 0x3f08	     */		xor	%l7,1,%o4
/* 0x3f0c	     */		and	%o4,%l5,%l4
/* 0x3f10	     */		and	%g4,%l4,%o5
/* 0x3f14	     */		sra	%l3,0,%g4
/* 0x3f18	     */		sub	%g4,%o7,%o1
/* 0x3f1c	     */		sra	%l2,0,%o0
/* 0x3f20	     */		sub	%o0,%o7,%o7
/* 0x3f24	     */		srlx	%o1,63,%l3
/* 0x3f28	     */		srlx	%o7,63,%l2
/* 0x3f2c	     */		xor	%l3,1,%g5
/* 0x3f30	     */		xor	%l2,1,%o2
/* 0x3f34	     */		and	%g5,%o2,%o1
/* 0x3f38	     */		andcc	%o5,%o1,%g0
/* 0x3f3c	     */		be,a,pn	%icc,.L77003988
/* 0x3f40	     */		or	%g0,0,%l4

! Registers live out of .L77003996: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003996

			.L77004191:
/* 0x3f44	 516 */		sethi	%hi(0x1000),%g1
/* 0x3f48	     */		xor	%g1,-704,%g1
/* 0x3f4c	     */		add	%g1,%fp,%l7
/* 0x3f50	     */		sethi	%hi(0x1800),%g1
/* 0x3f54	     */		xor	%g1,-256,%g1
/* 0x3f58	     */		add	%i1,-1,%g5
/* 0x3f5c	     */		or	%g0,0,%g4
/* 0x3f60	     */		add	%fp,-1600,%g3
/* 0x3f64	     */		add	%fp,-3200,%g2

!  517		      !            if (mask[i]) {

/* 0x3f68	 517 */		ldub	[%i3],%o2
/* 0x3f6c	 516 */		add	%g1,%fp,%l3

! Registers live out of .L77004191: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003907 .L77004191

			.L900000469:
/* 0x3f70	 517 */		cmp	%o2,0
/* 0x3f74	     */		be,pn	%icc,.L77003907
/* 0x3f78	 516 */		add	%g4,1,%g4

! Registers live out of .L900000469: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  518		      !               red[i]   = red[i]   | ~rdest[i];

                       
! predecessor blocks: .L900000469

			.L77003905:
/* 0x3f7c	 518 */		ldub	[%i4],%l0

!  519		      !               green[i] = green[i] | ~gdest[i];

/* 0x3f80	 519 */		ldub	[%i5],%o7

!  520		      !               blue[i]  = blue[i]  | ~bdest[i];

/* 0x3f84	 520 */		ldub	[%i0],%l4

!  521		      !               alpha[i] = alpha[i] | ~adest[i];

/* 0x3f88	 521 */		ldub	[%i2],%l5
/* 0x3f8c	 518 */		ldub	[%g3],%i1
/* 0x3f90	 519 */		ldub	[%g2],%l1
/* 0x3f94	 520 */		ldub	[%l7],%l2
/* 0x3f98	 521 */		ldub	[%l3],%o5
/* 0x3f9c	 518 */		orn	%l0,%i1,%o3
/* 0x3fa0	     */		stb	%o3,[%i4]
/* 0x3fa4	 519 */		orn	%o7,%l1,%o1
/* 0x3fa8	     */		stb	%o1,[%i5]
/* 0x3fac	 520 */		orn	%l4,%l2,%o4
/* 0x3fb0	     */		stb	%o4,[%i0]
/* 0x3fb4	 521 */		orn	%l5,%o5,%l6
/* 0x3fb8	     */		stb	%l6,[%i2]

! Registers live out of .L77003905: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003905 .L900000469

			.L77003907:
/* 0x3fbc	 516 */		cmp	%g4,%g5
/* 0x3fc0	     */		add	%i3,1,%i3
/* 0x3fc4	     */		add	%l3,1,%l3
/* 0x3fc8	     */		add	%l7,1,%l7
/* 0x3fcc	     */		add	%g2,1,%g2
/* 0x3fd0	     */		add	%g3,1,%g3
/* 0x3fd4	     */		add	%i2,1,%i2
/* 0x3fd8	     */		add	%i0,1,%i0
/* 0x3fdc	     */		add	%i5,1,%i5
/* 0x3fe0	     */		add	%i4,1,%i4
/* 0x3fe4	     */		ble,a,pt	%icc,.L900000469
/* 0x3fe8	 517 */		ldub	[%i3],%o2

! Registers live out of .L77003907: 
! g2 g3 g4 g5 o2 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003907

			.L77003991:
/* 0x3fec	 516 */		ba	.L77003932
/* 0x3ff0	     */		nop

! Registers live out of .L77003991: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003952

			.L77004345:
/* 0x3ff4	 516 */		ld	[%fp+92],%i0
/* 0x3ff8	     */		ld	[%fp+96],%i2
/* 0x3ffc	     */		or	%g0,0,%l4

! Registers live out of .L77004345: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003994 .L77003995 .L77003996 .L77004345

			.L77003988:
/* 0x4000	 517 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77003988: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003988 .L77003990

			.L900000468:
/* 0x4004	 517 */		cmp	%g3,0
/* 0x4008	     */		be,pn	%icc,.L77003990
/* 0x400c	 518 */		add	%fp,-1600,%l3

! Registers live out of .L900000468: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000468

			.L77003989:
/* 0x4010	 518 */		ldub	[%l4+%l3],%o7
/* 0x4014	     */		ldub	[%i4+%l4],%g2
/* 0x4018	     */		orn	%g2,%o7,%o2
/* 0x401c	     */		stb	%o2,[%i4+%l4]
/* 0x4020	 519 */		ldub	[%l4+%l6],%g5
/* 0x4024	     */		ldub	[%i5+%l4],%l3
/* 0x4028	     */		orn	%l3,%g5,%l7
/* 0x402c	     */		stb	%l7,[%i5+%l4]
/* 0x4030	 520 */		ldub	[%l4+%l1],%l2
/* 0x4034	     */		ldub	[%l4+%i0],%o1
/* 0x4038	     */		orn	%o1,%l2,%o0
/* 0x403c	     */		stb	%o0,[%l4+%i0]
/* 0x4040	 521 */		ldub	[%l4+%l0],%l5
/* 0x4044	     */		ldub	[%l4+%i2],%o4
/* 0x4048	     */		orn	%o4,%l5,%o5
/* 0x404c	     */		stb	%o5,[%l4+%i2]

! Registers live out of .L77003989: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003989 .L900000468

			.L77003990:
/* 0x4050	 516 */		add	%l4,1,%l4
/* 0x4054	     */		cmp	%l4,%i1
/* 0x4058	     */		bcs,a,pn	%icc,.L900000468
/* 0x405c	 517 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77003990: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003990

			.L900000450:
/* 0x4060	 516 */		ba	.L77003932
/* 0x4064	     */		nop

! Registers live out of .L900000450: 
! sp fp i7 gsr 
! 
		
!  522		      !            }
!  523		      !         }
!  524		      !         break;
!  525		      !      case GL_OR_INVERTED:
!  526		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000465

			.L77003913:
/* 0x4068	 526 */		cmp	%i1,0
/* 0x406c	     */		bleu,pn	%icc,.L77003932
/* 0x4070	     */		cmp	%i1,54

! Registers live out of .L77003913: 
! g1 sp l0 l1 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003913

			.L77003950:
/* 0x4074	 526 */		ld	[%fp+100],%i3
/* 0x4078	     */		bl,pn	%icc,.L77004349
/* 0x407c	     */		sub	%i4,%i5,%i2

! Registers live out of .L77003950: 
! g1 sp l0 l1 l6 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003950

			.L77003971:
/* 0x4080	 526 */		sra	%i2,31,%o7
/* 0x4084	     */		xor	%i2,%o7,%i0
/* 0x4088	     */		sub	%i0,%o7,%l7
/* 0x408c	     */		add	%fp,-1600,%o2
/* 0x4090	     */		sub	%i4,%o2,%o5
/* 0x4094	     */		sub	%i4,%i3,%i0
/* 0x4098	     */		sra	%o5,31,%l3
/* 0x409c	     */		sra	%i0,31,%i2
/* 0x40a0	     */		xor	%o5,%l3,%o4
/* 0x40a4	     */		xor	%i0,%i2,%o7
/* 0x40a8	     */		sub	%i4,%l6,%o1
/* 0x40ac	     */		sra	%o1,31,%g4
/* 0x40b0	     */		sub	%i4,%l1,%l5
/* 0x40b4	     */		sub	%o7,%i2,%o5
/* 0x40b8	     */		xor	%o1,%g4,%l2
/* 0x40bc	     */		sra	%l5,31,%o0
/* 0x40c0	     */		sub	%i4,%l0,%g5
/* 0x40c4	     */		xor	%l5,%o0,%g2
/* 0x40c8	     */		sra	%g5,31,%o3
/* 0x40cc	     */		sub	%l2,%g4,%g3
/* 0x40d0	     */		sub	%o4,%l3,%l4
/* 0x40d4	     */		sub	%g2,%o0,%l2
/* 0x40d8	     */		xor	%g5,%o3,%o2
/* 0x40dc	     */		sub	%o2,%o3,%g2
/* 0x40e0	     */		sra	%l7,0,%o1
/* 0x40e4	     */		sra	%l4,0,%g4
/* 0x40e8	     */		sra	%l2,0,%g5
/* 0x40ec	     */		sra	%g3,0,%g3
/* 0x40f0	     */		sra	%o5,0,%o5
/* 0x40f4	     */		ld	[%fp+92],%i0
/* 0x40f8	     */		ld	[%fp+96],%i2
/* 0x40fc	     */		sub	%i4,%i0,%o4
/* 0x4100	     */		sub	%i4,%i2,%o0
/* 0x4104	     */		sra	%o4,31,%l3
/* 0x4108	     */		sra	%o0,31,%o3
/* 0x410c	     */		xor	%o4,%l3,%l5
/* 0x4110	     */		xor	%o0,%o3,%o2
/* 0x4114	     */		sub	%l5,%l3,%o7
/* 0x4118	     */		sub	%o2,%o3,%l7
/* 0x411c	     */		sra	%o7,0,%o2
/* 0x4120	     */		sra	%i1,0,%o7
/* 0x4124	     */		sra	%g2,0,%o3
/* 0x4128	     */		sub	%o1,%o7,%g2
/* 0x412c	     */		srlx	%g2,63,%o1
/* 0x4130	     */		sub	%g4,%o7,%g2
/* 0x4134	     */		srlx	%g2,63,%l4
/* 0x4138	     */		sub	%g5,%o7,%g2
/* 0x413c	     */		sra	%l7,0,%o4
/* 0x4140	     */		sub	%g3,%o7,%o0
/* 0x4144	     */		sub	%o2,%o7,%g5
/* 0x4148	     */		sub	%o4,%o7,%o4
/* 0x414c	     */		srlx	%o0,63,%l3
/* 0x4150	     */		sub	%o3,%o7,%o2
/* 0x4154	     */		srlx	%o4,63,%g4
/* 0x4158	     */		srlx	%g2,63,%l5
/* 0x415c	     */		srlx	%g5,63,%o0
/* 0x4160	     */		srlx	%o2,63,%g3
/* 0x4164	     */		sub	%o5,%o7,%o4
/* 0x4168	     */		xor	%l5,1,%o2
/* 0x416c	     */		xor	%o0,1,%o5
/* 0x4170	     */		and	%o2,%o5,%l5
/* 0x4174	     */		sethi	%hi(0x7ffffc00),%g2
/* 0x4178	     */		xor	%o1,1,%g5
/* 0x417c	     */		srl	%i1,0,%o5
/* 0x4180	     */		add	%g2,1022,%g2
/* 0x4184	     */		sub	%o5,%g2,%o1
/* 0x4188	     */		xor	%l3,1,%l2
/* 0x418c	     */		xor	%l4,1,%l4
/* 0x4190	     */		srlx	%o1,63,%o0
/* 0x4194	     */		and	%o0,%l4,%o5
/* 0x4198	     */		and	%l2,%g5,%g5
/* 0x419c	     */		xor	%g4,1,%o3
/* 0x41a0	     */		srlx	%o4,63,%l2
/* 0x41a4	     */		xor	%g3,1,%l7
/* 0x41a8	     */		and	%o5,%g5,%o2
/* 0x41ac	     */		and	%l7,%o3,%l3
/* 0x41b0	     */		xor	%l2,1,%o4
/* 0x41b4	     */		and	%o2,%l5,%g3
/* 0x41b8	     */		and	%o4,1,%g4
/* 0x41bc	     */		and	%g3,%l3,%o3
/* 0x41c0	     */		andcc	%o3,%g4,%g0
/* 0x41c4	     */		be,a,pn	%icc,.L77003965
/* 0x41c8	     */		or	%g0,0,%l4

! Registers live out of .L77003971: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003971

			.L77003972:
/* 0x41cc	 526 */		sub	%i5,%i0,%o1
/* 0x41d0	     */		sra	%o1,31,%l4
/* 0x41d4	     */		xor	%o1,%l4,%o4
/* 0x41d8	     */		sub	%i5,%l1,%l5
/* 0x41dc	     */		sub	%o4,%l4,%o0
/* 0x41e0	     */		sra	%l5,31,%l3
/* 0x41e4	     */		sub	%i5,%l6,%l7
/* 0x41e8	     */		xor	%l5,%l3,%o2
/* 0x41ec	     */		sra	%l7,31,%o4
/* 0x41f0	     */		sub	%o2,%l3,%g5
/* 0x41f4	     */		xor	%l7,%o4,%l2
/* 0x41f8	     */		add	%fp,-1600,%o5
/* 0x41fc	     */		sub	%i5,%l0,%o3
/* 0x4200	     */		sub	%i5,%o5,%g3
/* 0x4204	     */		sub	%l2,%o4,%o1
/* 0x4208	     */		sra	%o3,31,%l3
/* 0x420c	     */		sub	%i5,%i2,%g2
/* 0x4210	     */		sra	%g3,31,%l4
/* 0x4214	     */		sub	%i0,%o5,%o4
/* 0x4218	     */		sra	%g2,31,%o2
/* 0x421c	     */		xor	%o3,%l3,%l2
/* 0x4220	     */		xor	%g3,%l4,%l5
/* 0x4224	     */		xor	%g2,%o2,%o5
/* 0x4228	     */		sub	%l2,%l3,%l7
/* 0x422c	     */		sub	%o5,%o2,%g3
/* 0x4230	     */		sra	%o4,31,%l2
/* 0x4234	     */		xor	%o4,%l2,%o2
/* 0x4238	     */		sub	%i0,%l6,%o5
/* 0x423c	     */		sra	%o5,31,%o4
/* 0x4240	     */		xor	%o5,%o4,%l3
/* 0x4244	     */		sub	%l3,%o4,%l3
/* 0x4248	     */		sub	%l5,%l4,%g4
/* 0x424c	     */		sra	%o0,0,%o4
/* 0x4250	     */		sub	%i5,%i3,%l5
/* 0x4254	     */		sub	%o4,%o7,%o5
/* 0x4258	     */		sra	%l5,31,%l4
/* 0x425c	     */		sub	%o2,%l2,%l2
/* 0x4260	     */		srlx	%o5,63,%o0
/* 0x4264	     */		xor	%l5,%l4,%g2
/* 0x4268	     */		xor	%o0,1,%o2
/* 0x426c	     */		sub	%g2,%l4,%l5
/* 0x4270	     */		sub	%i0,%l1,%o3
/* 0x4274	     */		sra	%g5,0,%o0
/* 0x4278	     */		sra	%o3,31,%l4
/* 0x427c	     */		sub	%o0,%o7,%g5
/* 0x4280	     */		xor	%o3,%l4,%g2
/* 0x4284	     */		srlx	%g5,63,%g5
/* 0x4288	     */		xor	%g5,1,%o3
/* 0x428c	     */		and	%o3,%o2,%o5
/* 0x4290	     */		sub	%g2,%l4,%l4
/* 0x4294	     */		sra	%o1,0,%o2
/* 0x4298	     */		sra	%g4,0,%g4
/* 0x429c	     */		sub	%o2,%o7,%g2
/* 0x42a0	     */		sub	%g4,%o7,%o3
/* 0x42a4	     */		srlx	%g2,63,%o1
/* 0x42a8	     */		srlx	%o3,63,%g4
/* 0x42ac	     */		xor	%o1,1,%o4
/* 0x42b0	     */		xor	%g4,1,%g2
/* 0x42b4	     */		and	%g2,%o4,%o0
/* 0x42b8	     */		and	%o0,%o5,%o3
/* 0x42bc	     */		sra	%l7,0,%o4
/* 0x42c0	     */		sra	%g3,0,%g3
/* 0x42c4	     */		sub	%g3,%o7,%o1
/* 0x42c8	     */		sub	%o4,%o7,%o5
/* 0x42cc	     */		srlx	%o1,63,%g3
/* 0x42d0	     */		srlx	%o5,63,%l7
/* 0x42d4	     */		xor	%g3,1,%g5
/* 0x42d8	     */		xor	%l7,1,%o2
/* 0x42dc	     */		and	%o2,%g5,%o1
/* 0x42e0	     */		sra	%l5,0,%o0
/* 0x42e4	     */		sra	%l2,0,%o2
/* 0x42e8	     */		sub	%o0,%o7,%g5
/* 0x42ec	     */		sub	%o2,%o7,%g2
/* 0x42f0	     */		and	%o3,%o1,%g3
/* 0x42f4	     */		sra	%l3,0,%o0
/* 0x42f8	     */		srlx	%g2,63,%l2
/* 0x42fc	     */		sub	%o0,%o7,%o1
/* 0x4300	     */		sra	%l4,0,%g2
/* 0x4304	     */		srlx	%g5,63,%l5
/* 0x4308	     */		sub	%g2,%o7,%o0
/* 0x430c	     */		srlx	%o0,63,%l4
/* 0x4310	     */		xor	%l5,1,%g4
/* 0x4314	     */		xor	%l2,1,%o5
/* 0x4318	     */		srlx	%o1,63,%l3
/* 0x431c	     */		xor	%l4,1,%g5
/* 0x4320	     */		and	%o5,%g4,%o4
/* 0x4324	     */		xor	%l3,1,%l7
/* 0x4328	     */		and	%g3,%o4,%o3
/* 0x432c	     */		and	%g5,%l7,%o2
/* 0x4330	     */		andcc	%o3,%o2,%g0
/* 0x4334	     */		be,a,pn	%icc,.L77003965
/* 0x4338	     */		or	%g0,0,%l4

! Registers live out of .L77003972: 
! g1 sp o7 l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003972

			.L77003973:
/* 0x433c	 526 */		add	%fp,-1600,%g5
/* 0x4340	     */		sub	%i2,%g5,%l5
/* 0x4344	     */		sra	%l5,31,%o0
/* 0x4348	     */		xor	%l5,%o0,%o1
/* 0x434c	     */		sub	%i0,%i3,%o2
/* 0x4350	     */		sra	%o2,31,%l2
/* 0x4354	     */		sub	%o1,%o0,%l5
/* 0x4358	     */		sub	%i0,%i2,%o3
/* 0x435c	     */		sub	%i2,%l6,%o4
/* 0x4360	     */		xor	%o2,%l2,%g5
/* 0x4364	     */		sra	%o3,31,%l3
/* 0x4368	     */		sra	%o4,31,%o0
/* 0x436c	     */		sub	%i0,%l0,%g2
/* 0x4370	     */		sub	%g5,%l2,%l4
/* 0x4374	     */		xor	%o3,%l3,%l7
/* 0x4378	     */		sra	%g2,31,%o1
/* 0x437c	     */		xor	%o4,%o0,%o4
/* 0x4380	     */		sub	%i2,%l1,%o5
/* 0x4384	     */		sra	%o5,31,%g4
/* 0x4388	     */		sub	%l7,%l3,%o2
/* 0x438c	     */		xor	%g2,%o1,%g2
/* 0x4390	     */		sub	%i2,%i3,%l2
/* 0x4394	     */		sub	%i2,%l0,%o3
/* 0x4398	     */		sub	%o4,%o0,%g3
/* 0x439c	     */		sra	%o3,31,%o4
/* 0x43a0	     */		sub	%g2,%o1,%g5
/* 0x43a4	     */		xor	%o5,%g4,%o5
/* 0x43a8	     */		sra	%l2,31,%l3
/* 0x43ac	     */		sub	%o5,%g4,%l7
/* 0x43b0	     */		xor	%l2,%l3,%g2
/* 0x43b4	     */		xor	%o3,%o4,%o1
/* 0x43b8	     */		sub	%o1,%o4,%l2
/* 0x43bc	     */		sub	%g2,%l3,%l3
/* 0x43c0	     */		sra	%l4,0,%g4
/* 0x43c4	     */		sra	%l5,0,%o0
/* 0x43c8	     */		sra	%o2,0,%o2
/* 0x43cc	     */		sra	%g5,0,%g5
/* 0x43d0	     */		sub	%g4,%o7,%o1
/* 0x43d4	     */		sub	%o0,%o7,%o3
/* 0x43d8	     */		sub	%o2,%o7,%g2
/* 0x43dc	     */		sub	%g5,%o7,%o4
/* 0x43e0	     */		srlx	%o1,63,%l4
/* 0x43e4	     */		srlx	%o3,63,%l5
/* 0x43e8	     */		srlx	%g2,63,%o2
/* 0x43ec	     */		srlx	%o4,63,%g5
/* 0x43f0	     */		xor	%l4,1,%o5
/* 0x43f4	     */		xor	%l5,1,%o0
/* 0x43f8	     */		xor	%o2,1,%g2
/* 0x43fc	     */		xor	%g5,1,%o3
/* 0x4400	     */		and	%o0,%o5,%g4
/* 0x4404	     */		and	%g2,%o3,%o1
/* 0x4408	     */		sra	%g3,0,%g3
/* 0x440c	     */		sub	%g3,%o7,%o5
/* 0x4410	     */		and	%o1,%g4,%o2
/* 0x4414	     */		srlx	%o5,63,%g3
/* 0x4418	     */		sra	%l7,0,%o1
/* 0x441c	     */		sra	%l3,0,%g4
/* 0x4420	     */		sub	%o1,%o7,%o0
/* 0x4424	     */		sub	%g4,%o7,%o3
/* 0x4428	     */		sra	%l2,0,%o5
/* 0x442c	     */		srlx	%o0,63,%l7
/* 0x4430	     */		sub	%o5,%o7,%o7
/* 0x4434	     */		xor	%l7,1,%l4
/* 0x4438	     */		srlx	%o3,63,%l3
/* 0x443c	     */		xor	%g3,1,%o4
/* 0x4440	     */		srlx	%o7,63,%l2
/* 0x4444	     */		and	%l4,%o4,%l5
/* 0x4448	     */		xor	%l3,1,%g5
/* 0x444c	     */		xor	%l2,1,%o0
/* 0x4450	     */		and	%o2,%l5,%g2
/* 0x4454	     */		and	%g5,%o0,%o3
/* 0x4458	     */		andcc	%g2,%o3,%g0
/* 0x445c	     */		be,a,pn	%icc,.L77003965
/* 0x4460	     */		or	%g0,0,%l4

! Registers live out of .L77003973: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003973

			.L77004189:
/* 0x4464	 526 */		sethi	%hi(0x1000),%g1
/* 0x4468	     */		xor	%g1,-704,%g1
/* 0x446c	     */		add	%g1,%fp,%g2
/* 0x4470	     */		sethi	%hi(0x1800),%g1
/* 0x4474	     */		xor	%g1,-256,%g1
/* 0x4478	     */		add	%i1,-1,%o0
/* 0x447c	     */		or	%g0,0,%g5
/* 0x4480	     */		add	%fp,-1600,%g4
/* 0x4484	     */		add	%fp,-3200,%g3

!  527		      !            if (mask[i]) {

/* 0x4488	 527 */		ldub	[%i3],%l3
/* 0x448c	 526 */		add	%g1,%fp,%l7

! Registers live out of .L77004189: 
! g2 g3 g4 g5 o0 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003921 .L77004189

			.L900000467:
/* 0x4490	 527 */		cmp	%l3,0
/* 0x4494	     */		be,pn	%icc,.L77003921
/* 0x4498	 526 */		add	%g5,1,%g5

! Registers live out of .L900000467: 
! g2 g3 g4 g5 o0 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  528		      !               red[i]   = ~red[i]   | rdest[i];

                       
! predecessor blocks: .L900000467

			.L77003919:
/* 0x449c	 528 */		ldub	[%i4],%i1

!  529		      !               green[i] = ~green[i] | gdest[i];

/* 0x44a0	 529 */		ldub	[%i5],%l1

!  530		      !               blue[i]  = ~blue[i]  | bdest[i];

/* 0x44a4	 530 */		ldub	[%i0],%l2

!  531		      !               alpha[i] = ~alpha[i] | adest[i];

/* 0x44a8	 531 */		ldub	[%i2],%l5
/* 0x44ac	 528 */		ldub	[%g4],%l0
/* 0x44b0	 529 */		ldub	[%g3],%o7
/* 0x44b4	 530 */		ldub	[%g2],%o4
/* 0x44b8	 531 */		ldub	[%l7],%l6
/* 0x44bc	 528 */		orn	%l0,%i1,%o3
/* 0x44c0	     */		stb	%o3,[%i4]
/* 0x44c4	 529 */		orn	%o7,%l1,%o1
/* 0x44c8	     */		stb	%o1,[%i5]
/* 0x44cc	 530 */		orn	%o4,%l2,%o5
/* 0x44d0	     */		stb	%o5,[%i0]
/* 0x44d4	 531 */		orn	%l6,%l5,%o2
/* 0x44d8	     */		stb	%o2,[%i2]

! Registers live out of .L77003919: 
! g2 g3 g4 g5 o0 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003919 .L900000467

			.L77003921:
/* 0x44dc	 526 */		cmp	%g5,%o0
/* 0x44e0	     */		add	%i3,1,%i3
/* 0x44e4	     */		add	%l7,1,%l7
/* 0x44e8	     */		add	%g2,1,%g2
/* 0x44ec	     */		add	%g3,1,%g3
/* 0x44f0	     */		add	%g4,1,%g4
/* 0x44f4	     */		add	%i2,1,%i2
/* 0x44f8	     */		add	%i0,1,%i0
/* 0x44fc	     */		add	%i5,1,%i5
/* 0x4500	     */		add	%i4,1,%i4
/* 0x4504	     */		ble,a,pt	%icc,.L900000467
/* 0x4508	 527 */		ldub	[%i3],%l3

! Registers live out of .L77003921: 
! g2 g3 g4 g5 o0 sp l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003921

			.L77003968:
/* 0x450c	 526 */		ba	.L77003932
/* 0x4510	     */		nop

! Registers live out of .L77003968: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003950

			.L77004349:
/* 0x4514	 526 */		ld	[%fp+92],%i0
/* 0x4518	     */		ld	[%fp+96],%i2
/* 0x451c	     */		or	%g0,0,%l4

! Registers live out of .L77004349: 
! g1 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003971 .L77003972 .L77003973 .L77004349

			.L77003965:
/* 0x4520	 527 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77003965: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003965 .L77003967

			.L900000466:
/* 0x4524	 527 */		cmp	%g3,0
/* 0x4528	     */		be,pn	%icc,.L77003967
/* 0x452c	 528 */		add	%fp,-1600,%o3

! Registers live out of .L900000466: 
! g1 g3 o3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000466

			.L77003966:
/* 0x4530	 528 */		ldub	[%i4+%l4],%o7
/* 0x4534	     */		ldub	[%l4+%o3],%g2
/* 0x4538	     */		orn	%g2,%o7,%o1
/* 0x453c	     */		stb	%o1,[%i4+%l4]
/* 0x4540	 529 */		ldub	[%i5+%l4],%g5
/* 0x4544	     */		ldub	[%l4+%l6],%l7
/* 0x4548	     */		orn	%l7,%g5,%l2
/* 0x454c	     */		stb	%l2,[%i5+%l4]
/* 0x4550	 530 */		ldub	[%l4+%i0],%o4
/* 0x4554	     */		ldub	[%l4+%l1],%o0
/* 0x4558	     */		orn	%o0,%o4,%o5
/* 0x455c	     */		stb	%o5,[%l4+%i0]
/* 0x4560	 531 */		ldub	[%l4+%i2],%l5
/* 0x4564	     */		ldub	[%l4+%l0],%o2
/* 0x4568	     */		orn	%o2,%l5,%l3
/* 0x456c	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77003966: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003966 .L900000466

			.L77003967:
/* 0x4570	 526 */		add	%l4,1,%l4
/* 0x4574	     */		cmp	%l4,%i1
/* 0x4578	     */		bcs,a,pn	%icc,.L900000466
/* 0x457c	 527 */		ldub	[%l4+%i3],%g3

! Registers live out of .L77003967: 
! g1 g3 sp l0 l1 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003967

			.L900000449:
/* 0x4580	 526 */		ba	.L77003932
/* 0x4584	     */		nop

! Registers live out of .L900000449: 
! sp fp i7 gsr 
! 
		
!  532		      !            }
!  533		      !         }
!  534		      !         break;
!  535		      !      default:
!  536		      !         /* should never happen */
!  537		      !         gl_problem(ctx, "Bad function in gl_logicop_rgba_span");

                       
! predecessor blocks: gl_logicop_rgba_span .L900000465

			.L77003927:
/* 0x4588	 537 */		or	%g0,%i0,%o0
/* 0x458c	     */		sethi	%hi(.L431),%i4
/* 0x4590	     */		call	gl_problem	! params =  %o0 %o1	! Result = 
/* 0x4594	     */		add	%i4,%lo(.L431),%o1

! Registers live out of .L77003927: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77003715 .L77003729 .L77003745 .L77003759 .L77003773 .L77003787 .L77003801 .L77003815 .L77003829 .L77003843
! predecessor blocks: .L77003857 .L77003871 .L77003885 .L77003899 .L77003913 .L77003927 .L77003968 .L77003980 .L77003991 .L77004003 .L77004015
! predecessor blocks: .L77004027 .L77004039 .L77004051 .L77004063 .L77004075 .L77004087 .L77004099 .L77004111 .L77004122 .L77004133 .L900000449
! predecessor blocks: .L900000450 .L900000451 .L900000452 .L900000453 .L900000454 .L900000455 .L900000456 .L900000457 .L900000458 .L900000459 .L900000460
! predecessor blocks: .L900000461 .L900000462 .L900000463 .L900000465

			.L77003932:
/* 0x4598	 385 */		ret	! Result = 
/* 0x459c	     */		restore	%g0,0,%g0
/* 0x45a0	   0 */		.type	gl_logicop_rgba_span,2
/* 0x45a0	   0 */		.size	gl_logicop_rgba_span,(.-gl_logicop_rgba_span)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	8
!
! CONSTANT POOL
!
                       

			___const_seg_900000601:
/* 000000	   0 */		.word	(.L77004623-(___const_seg_900000601+0x0))
/* 0x0004	     */		.word	(.L77004695-(___const_seg_900000601+0x0))
/* 0x0008	     */		.word	(.L77004779-(___const_seg_900000601+0x0))
/* 0x000c	     */		.word	(.L77004840-(___const_seg_900000601+0x0))
/* 0x0010	     */		.word	(.L77004793-(___const_seg_900000601+0x0))
/* 0x0014	     */		.word	(.L77004667-(___const_seg_900000601+0x0))
/* 0x0018	     */		.word	(.L77004751-(___const_seg_900000601+0x0))
/* 0x001c	     */		.word	(.L77004723-(___const_seg_900000601+0x0))
/* 0x0020	     */		.word	(.L77004737-(___const_seg_900000601+0x0))
/* 0x0024	     */		.word	(.L77004765-(___const_seg_900000601+0x0))
/* 0x0028	     */		.word	(.L77004681-(___const_seg_900000601+0x0))
/* 0x002c	     */		.word	(.L77004807-(___const_seg_900000601+0x0))
/* 0x0030	     */		.word	(.L77004653-(___const_seg_900000601+0x0))
/* 0x0034	     */		.word	(.L77004821-(___const_seg_900000601+0x0))
/* 0x0038	     */		.word	(.L77004709-(___const_seg_900000601+0x0))
/* 0x003c	     */		.word	(.L77004637-(___const_seg_900000601+0x0))
/* 0x0040	   0 */		.type	___const_seg_900000601,1
/* 0x0040	   0 */		.size	___const_seg_900000601,(.-___const_seg_900000601)
/* 0x0040	   0 */		.align	4

!  538		      !         return;
!  539		      !   }
!  540		      !}
!  544		      !/*
!  545		      ! * Apply the current logic operator to an array of RGBA pixels.  This is only
!  546		      ! * used if the device driver can't do logic ops.
!  547		      ! */
!  548		      !void gl_logicop_rgba_pixels( GLcontext *ctx,
!  549		      !                             GLuint n, const GLint x[], const GLint y[],
!  550		      !                             GLubyte red[], GLubyte green[],
!  551		      !                             GLubyte blue[], GLubyte alpha[],
!  552		      !                             GLubyte mask[] )
!  553		      !{

!
! SUBROUTINE gl_logicop_rgba_pixels
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_logicop_rgba_pixels
                       

			gl_logicop_rgba_pixels:
/* 000000	 553 */		sethi	%hi(0x4800),%g1
/* 0x0004	     */		xor	%g1,-968,%g1
/* 0x0008	     */		save	%sp,%g1,%sp
/* 0x000c	   0 */		sethi	%hi(0x4800),%g1
/* 0x0010	   0 */		xor	%g1,-768,%g1
/* 0x0014	   0 */		add	%g1,%fp,%l1
/* 0x0018	   0 */		sethi	%hi(0x3800),%g1
/* 0x001c	   0 */		xor	%g1,-64,%g1
/* 0x0020	   0 */		add	%g1,%fp,%l2
/* 0x0024	   0 */		sethi	%hi(0x2400),%g1
/* 0x0028	   0 */		xor	%g1,-384,%g1
/* 0x002c	   0 */		add	%g1,%fp,%l6

!  554		      !   GLubyte rdest[PB_SIZE], gdest[PB_SIZE], bdest[PB_SIZE], adest[PB_SIZE];
!  555		      !   GLuint i;
!  557		      !   /* Read pixels from current color buffer */
!  558		      !   (*ctx->Driver.ReadColorPixels)( ctx, n, x, y, rdest, gdest, bdest, adest, mask
!  558		      > );

/* 0x0030	 558 */		sethi	%hi(0x2400),%g1
/* 0x0034	     */		xor	%g1,-384,%g1
/* 0x0038	     */		add	%g1,%fp,%o5
/* 0x003c	     */		sllx	%l1,32,%o0
/* 0x0040	     */		sethi	%hi(0x1000),%g1
/* 0x0044	     */		xor	%g1,-704,%g1
/* 0x0048	     */		add	%g1,%fp,%o4
/* 0x004c	     */		or	%g0,%i3,%o3
/* 0x0050	     */		or	%g0,%i2,%o2
/* 0x0054	     */		or	%g0,%i1,%o1
/* 0x0058	 553 */		ld	[%fp+100],%l0
/* 0x005c	 558 */		ld	[%i0+2288],%l7
/* 0x0060	     */		st	%l2,[%sp+92]
/* 0x0064	     */		srl	%l0,0,%o7
/* 0x0068	     */		or	%o0,%o7,%g3
/* 0x006c	     */		stx	%g3,[%sp+96]
/* 0x0070	     */		jmpl	%l7,%o7
/* 0x0074	     */		or	%g0,%i0,%o0

!  559		      !   if (ctx->RasterMask & ALPHABUF_BIT) {

/* 0x0078	 559 */		sethi	%hi(0xe000),%o7
/* 0x007c	     */		add	%o7,264,%l4
/* 0x0080	     */		ld	[%i0+%l4],%o1
/* 0x0084	     */		andcc	%o1,256,%g0
/* 0x0088	     */		be,pn	%icc,.L77004837
/* 0x008c	 564 */		sethi	%hi(0x1400),%l7

! Registers live out of gl_logicop_rgba_pixels: 
! o1 o4 sp l0 l1 l2 l6 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  560		      !      gl_read_alpha_pixels( ctx, n, x, y, adest, mask );

                       
! predecessor blocks: gl_logicop_rgba_pixels

			.L77004619:
/* 0x0090	 560 */		sethi	%hi(0x4800),%g1
/* 0x0094	     */		xor	%g1,-768,%g1
/* 0x0098	     */		add	%g1,%fp,%g1
/* 0x009c	     */		or	%g0,%i3,%o3
/* 0x00a0	     */		or	%g0,%i2,%o2
/* 0x00a4	     */		or	%g0,%l0,%o5
/* 0x00a8	     */		or	%g0,%i1,%o1
/* 0x00ac	     */		or	%g0,%i0,%o0
/* 0x00b0	     */		call	gl_read_alpha_pixels	! params =  %o0 %o1 %o2 %o3 %o4 %o5	! Result = 
/* 0x00b4	     */		or	%g0,%g1,%o4

! Registers live out of .L77004619: 
! o1 sp l0 l1 l2 l6 l7 i0 i1 i4 i5 fp i7 gsr 
! 
		
!  561		      !   }
!  563		      !   /* apply logic op */
!  564		      !   switch (ctx->Color.LogicOp) {

                       
! predecessor blocks: .L77004619 gl_logicop_rgba_pixels

			.L77004837:
/* 0x00b8	 564 */		sethi	%hi(0x1c00),%i2
/* 0x00bc	     */		add	%i2,716,%o0
/* 0x00c0	     */		ld	[%i0+%o0],%g5
/* 0x00c4	     */		add	%l7,256,%i3
/* 0x00c8	     */		sub	%g5,%i3,%i3
/* 0x00cc	     */		cmp	%i3,15
/* 0x00d0	     */		bgu,pn	%icc,.L77004835
/* 0x00d4	     */		sll	%i3,2,%i2

! Registers live out of .L77004837: 
! o1 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004837

			.L900000640:
/* 0x00d8	 564 */		sethi	%hi(___const_seg_900000601),%g4
/* 0x00dc	     */		add	%g4,%lo(___const_seg_900000601),%o7
/* 0x00e0	   0 */		sethi	%hi(0x7ffffc00),%o2
/* 0x00e4	 564 */		ld	[%i2+%o7],%l5
/* 0x00e8	     */		jmpl	%l5+%o7,%g0
/* 0x00ec	     */		nop

! Registers live out of .L900000640: 
! o1 o2 sp l0 l1 l2 l6 i0 i1 i4 i5 fp i7 gsr 
! 
		
!  565		      !      case GL_CLEAR:
!  566		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004623:
/* 0x00f0	 566 */		cmp	%i1,0
/* 0x00f4	     */		bleu,pn	%icc,.L77004840
/* 0x00f8	     */		cmp	%i1,22

! Registers live out of .L77004623: 
! o2 sp l0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004623

			.L77004870:
/* 0x00fc	 566 */		bl,pn	%icc,.L77005235
/* 0x0100	     */		add	%o2,1022,%o2

! Registers live out of .L77004870: 
! o2 sp l0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004870

			.L77005022:
/* 0x0104	 566 */		sub	%i5,%i4,%i0
/* 0x0108	     */		sra	%i0,31,%i2
/* 0x010c	     */		xor	%i0,%i2,%l4
/* 0x0110	     */		sub	%l4,%i2,%l5
/* 0x0114	     */		sra	%i1,0,%o5
/* 0x0118	     */		sra	%l5,0,%o3
/* 0x011c	     */		sub	%o3,%o5,%g3
/* 0x0120	     */		srl	%i1,0,%g5
/* 0x0124	     */		sub	%g5,%o2,%g2
/* 0x0128	     */		srlx	%g3,63,%g4
/* 0x012c	     */		xor	%g4,1,%l6
/* 0x0130	     */		srlx	%g2,63,%l7
/* 0x0134	     */		and	%l6,1,%l6
/* 0x0138	     */		ld	[%fp+96],%i2
/* 0x013c	     */		ld	[%fp+92],%i0
/* 0x0140	     */		sub	%i2,%i5,%o1
/* 0x0144	     */		sra	%o1,31,%o7
/* 0x0148	     */		sub	%i2,%i4,%l2
/* 0x014c	     */		xor	%o1,%o7,%o4
/* 0x0150	     */		sra	%l2,31,%l1
/* 0x0154	     */		sub	%i2,%i0,%l3
/* 0x0158	     */		sub	%o4,%o7,%g3
/* 0x015c	     */		xor	%l2,%l1,%o0
/* 0x0160	     */		sra	%l3,31,%o3
/* 0x0164	     */		sub	%i0,%i5,%l5
/* 0x0168	     */		sub	%i2,%l0,%l4
/* 0x016c	     */		sub	%o0,%l1,%g4
/* 0x0170	     */		xor	%l3,%o3,%i3
/* 0x0174	     */		sra	%l4,31,%g2
/* 0x0178	     */		sra	%l5,31,%o4
/* 0x017c	     */		sub	%i0,%i4,%o7
/* 0x0180	     */		sub	%i3,%o3,%g5
/* 0x0184	     */		xor	%l4,%g2,%o2
/* 0x0188	     */		xor	%l5,%o4,%o1
/* 0x018c	     */		sra	%o7,31,%o0
/* 0x0190	     */		sub	%i0,%l0,%l3
/* 0x0194	     */		sub	%o2,%g2,%l4
/* 0x0198	     */		sub	%o1,%o4,%l5
/* 0x019c	     */		xor	%o7,%o0,%l2
/* 0x01a0	     */		sra	%l3,31,%l1
/* 0x01a4	     */		sra	%g3,0,%o3
/* 0x01a8	     */		xor	%l3,%l1,%i3
/* 0x01ac	     */		sub	%l2,%o0,%l2
/* 0x01b0	     */		sub	%o3,%o5,%o2
/* 0x01b4	     */		sra	%g4,0,%g2
/* 0x01b8	     */		sra	%g5,0,%o4
/* 0x01bc	     */		sub	%i3,%l1,%l1
/* 0x01c0	     */		srlx	%o2,63,%o0
/* 0x01c4	     */		sub	%g2,%o5,%o1
/* 0x01c8	     */		sub	%o4,%o5,%o7
/* 0x01cc	     */		sra	%l4,0,%g3
/* 0x01d0	     */		srlx	%o1,63,%i3
/* 0x01d4	     */		srlx	%o7,63,%o2
/* 0x01d8	     */		sub	%g3,%o5,%g4
/* 0x01dc	     */		xor	%o0,1,%l3
/* 0x01e0	     */		xor	%i3,1,%o3
/* 0x01e4	     */		xor	%o2,1,%g5
/* 0x01e8	     */		srlx	%g4,63,%o1
/* 0x01ec	     */		sra	%l5,0,%o4
/* 0x01f0	     */		and	%o3,%l3,%g2
/* 0x01f4	     */		and	%l7,%g5,%l7
/* 0x01f8	     */		sub	%o4,%o5,%o7
/* 0x01fc	     */		sra	%l2,0,%g4
/* 0x0200	     */		sra	%l1,0,%o2
/* 0x0204	     */		srlx	%o7,63,%l4
/* 0x0208	     */		sub	%g4,%o5,%o3
/* 0x020c	     */		sub	%o2,%o5,%g5
/* 0x0210	     */		and	%l7,%g2,%i3
/* 0x0214	     */		xor	%o1,1,%o0
/* 0x0218	     */		xor	%l4,1,%l5
/* 0x021c	     */		srlx	%o3,63,%l2
/* 0x0220	     */		srlx	%g5,63,%l1
/* 0x0224	     */		and	%l5,%o0,%g3
/* 0x0228	     */		xor	%l2,1,%g2
/* 0x022c	     */		xor	%l1,1,%l7
/* 0x0230	     */		and	%i3,%g3,%l3
/* 0x0234	     */		and	%l7,%g2,%o1
/* 0x0238	     */		and	%l3,%o1,%o4
/* 0x023c	     */		andcc	%o4,%l6,%g0
/* 0x0240	     */		be,a,pn	%icc,.L77005016
/* 0x0244	     */		or	%g0,0,%l6

! Registers live out of .L77005022: 
! o5 sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005022

			.L77005023:
/* 0x0248	 566 */		sub	%i4,%l0,%o3
/* 0x024c	     */		sub	%i5,%l0,%g4
/* 0x0250	     */		sra	%o3,31,%o2
/* 0x0254	     */		sra	%g4,31,%g5
/* 0x0258	     */		xor	%g4,%g5,%l6
/* 0x025c	     */		xor	%o3,%o2,%g3
/* 0x0260	     */		sub	%l6,%g5,%l3
/* 0x0264	     */		sub	%g3,%o2,%g2
/* 0x0268	     */		sra	%g2,0,%o1
/* 0x026c	     */		sra	%l3,0,%o7
/* 0x0270	     */		sub	%o1,%o5,%o4
/* 0x0274	     */		sub	%o7,%o5,%o0
/* 0x0278	     */		srlx	%o4,63,%l2
/* 0x027c	     */		srlx	%o0,63,%l1
/* 0x0280	     */		xor	%l2,1,%l7
/* 0x0284	     */		xor	%l1,1,%i3
/* 0x0288	     */		andcc	%i3,%l7,%g0
/* 0x028c	     */		be,a,pn	%icc,.L77005016
/* 0x0290	     */		or	%g0,0,%l6

! Registers live out of .L77005023: 
! sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005023

			.L77005109:
/* 0x0294	 566 */		add	%i1,-1,%l1

!  567		      !            if (mask[i]) {

/* 0x0298	 567 */		ldub	[%l0],%o1
/* 0x029c	 566 */		or	%g0,0,%i3

! Registers live out of .L77005109: 
! o1 sp l0 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004631 .L77005109

			.L900000674:
/* 0x02a0	 567 */		cmp	%o1,0
/* 0x02a4	     */		be,pn	%icc,.L77004631
/* 0x02a8	 566 */		add	%i3,1,%i3

! Registers live out of .L900000674: 
! o1 sp l0 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  568		      !               red[i] = green[i] = blue[i] = alpha[i] = 0;

                       
! predecessor blocks: .L900000674

			.L77004629:
/* 0x02ac	 568 */		stb	%g0,[%i2]
/* 0x02b0	     */		stb	%g0,[%i0]
/* 0x02b4	     */		stb	%g0,[%i5]
/* 0x02b8	     */		stb	%g0,[%i4]

! Registers live out of .L77004629: 
! o1 sp l0 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004629 .L900000674

			.L77004631:
/* 0x02bc	 566 */		cmp	%i3,%l1
/* 0x02c0	     */		add	%l0,1,%l0
/* 0x02c4	     */		add	%i2,1,%i2
/* 0x02c8	     */		add	%i0,1,%i0
/* 0x02cc	     */		add	%i5,1,%i5
/* 0x02d0	     */		add	%i4,1,%i4
/* 0x02d4	     */		ble,a,pt	%icc,.L900000674
/* 0x02d8	 567 */		ldub	[%l0],%o1

! Registers live out of .L77004631: 
! o1 sp l0 l1 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004631

			.L77005019:
/* 0x02dc	 566 */		ba	.L77004840
/* 0x02e0	     */		nop

! Registers live out of .L77005019: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004870

			.L77005235:
/* 0x02e4	 566 */		ld	[%fp+92],%i0
/* 0x02e8	     */		ld	[%fp+96],%i2
/* 0x02ec	     */		or	%g0,0,%l6

! Registers live out of .L77005235: 
! sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005022 .L77005023 .L77005235

			.L77005016:
/* 0x02f0	 567 */		ldub	[%l6+%l0],%o5

! Registers live out of .L77005016: 
! o5 sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005016 .L900000673

			.L900000672:
/* 0x02f4	 567 */		cmp	%o5,0
/* 0x02f8	     */		be,a,pn	%icc,.L900000673
/* 0x02fc	 566 */		add	%l6,1,%l6

! Registers live out of .L900000672: 
! o5 sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000672

			.L77005017:
/* 0x0300	 568 */		stb	%g0,[%l6+%i2]
/* 0x0304	     */		stb	%g0,[%l6+%i0]
/* 0x0308	     */		stb	%g0,[%l6+%i5]
/* 0x030c	     */		stb	%g0,[%l6+%i4]
/* 0x0310	 566 */		add	%l6,1,%l6

! Registers live out of .L77005017: 
! o5 sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005017 .L900000672

			.L900000673:
/* 0x0314	 566 */		cmp	%l6,%i1
/* 0x0318	     */		bcs,a,pt	%icc,.L900000672
/* 0x031c	 567 */		ldub	[%l6+%l0],%o5

! Registers live out of .L900000673: 
! o5 sp l0 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000673

			.L900000638:
/* 0x0320	 566 */		ba	.L77004840
/* 0x0324	     */		nop

! Registers live out of .L900000638: 
! sp fp i7 gsr 
! 
		
!  569		      !            }
!  570		      !         }
!  571		      !         break;
!  572		      !      case GL_SET:
!  573		      !         {
!  574		      !            GLubyte r = (GLint) ctx->Visual->RedScale;
!  575		      !            GLubyte g = (GLint) ctx->Visual->GreenScale;
!  576		      !            GLubyte b = (GLint) ctx->Visual->BlueScale;
!  577		      !            GLubyte a = (GLint) ctx->Visual->AlphaScale;
!  578		      !            for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004637:
/* 0x0328	 578 */		cmp	%i1,0
/* 0x032c	     */		bleu,pn	%icc,.L77004840
/* 0x0330	 574 */		cmp	%i1,22

! Registers live out of .L77004637: 
! o2 sp l0 i0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004637

			.L77004871:
/* 0x0334	 574 */		ld	[%i0+2200],%l4
/* 0x0338	     */		bl,pn	%icc,.L77005263
/* 0x033c	 578 */		add	%o2,1022,%o1

! Registers live out of .L77004871: 
! o1 sp l0 l4 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004871

			.L77005033:
/* 0x0340	 578 */		sub	%i4,%i5,%i0
/* 0x0344	     */		sub	%i4,%l0,%l6
/* 0x0348	     */		sub	%i5,%l0,%l1
/* 0x034c	     */		sra	%i0,31,%i2
/* 0x0350	     */		sra	%l6,31,%o7
/* 0x0354	     */		sra	%l1,31,%g2
/* 0x0358	     */		xor	%i0,%i2,%o5
/* 0x035c	     */		xor	%l6,%o7,%i3
/* 0x0360	     */		xor	%l1,%g2,%g5
/* 0x0364	     */		sub	%o5,%i2,%l2
/* 0x0368	     */		sub	%i3,%o7,%o4
/* 0x036c	     */		sub	%g5,%g2,%o0
/* 0x0370	     */		sra	%i1,0,%o7
/* 0x0374	     */		sra	%l2,0,%o3
/* 0x0378	     */		sra	%o0,0,%o2
/* 0x037c	     */		sub	%o3,%o7,%g3
/* 0x0380	     */		sub	%o2,%o7,%g5
/* 0x0384	     */		srl	%i1,0,%g2
/* 0x0388	     */		srlx	%g3,63,%l5
/* 0x038c	     */		srlx	%g5,63,%l7
/* 0x0390	     */		sub	%g2,%o1,%o1
/* 0x0394	     */		xor	%l5,1,%i0
/* 0x0398	     */		srlx	%o1,63,%i2
/* 0x039c	     */		xor	%l7,1,%l6
/* 0x03a0	     */		and	%i2,%i0,%l7
/* 0x03a4	     */		sra	%o4,0,%g4
/* 0x03a8	     */		sub	%g4,%o7,%o5
/* 0x03ac	     */		srlx	%o5,63,%l3
/* 0x03b0	     */		xor	%l3,1,%l5
/* 0x03b4	     */		ld	[%fp+92],%i0
/* 0x03b8	     */		ld	[%fp+96],%i2
/* 0x03bc	     */		sub	%i4,%i0,%i3
/* 0x03c0	     */		sra	%i3,31,%l1
/* 0x03c4	     */		sub	%i4,%i2,%l2
/* 0x03c8	     */		xor	%i3,%l1,%o4
/* 0x03cc	     */		sra	%l2,31,%o3
/* 0x03d0	     */		xor	%l2,%o3,%o0
/* 0x03d4	     */		sub	%i5,%i0,%o2
/* 0x03d8	     */		sub	%o4,%l1,%g3
/* 0x03dc	     */		sra	%o2,31,%g5
/* 0x03e0	     */		sub	%o0,%o3,%g4
/* 0x03e4	     */		sub	%i5,%i2,%g2
/* 0x03e8	     */		sra	%g3,0,%g3
/* 0x03ec	     */		sra	%g2,31,%l1
/* 0x03f0	     */		xor	%o2,%g5,%o5
/* 0x03f4	     */		sub	%g3,%o7,%o1
/* 0x03f8	     */		sra	%g4,0,%g4
/* 0x03fc	     */		xor	%g2,%l1,%i3
/* 0x0400	     */		sub	%i0,%i2,%l3
/* 0x0404	     */		srlx	%o1,63,%o2
/* 0x0408	     */		sub	%g4,%o7,%o4
/* 0x040c	     */		sub	%i3,%l1,%l2
/* 0x0410	     */		sra	%l3,31,%o3
/* 0x0414	     */		srlx	%o4,63,%o1
/* 0x0418	     */		xor	%l3,%o3,%o0
/* 0x041c	     */		sub	%o5,%g5,%o5
/* 0x0420	     */		xor	%o2,1,%l1
/* 0x0424	     */		xor	%o1,1,%o4
/* 0x0428	     */		sub	%o0,%o3,%l3
/* 0x042c	     */		and	%o4,%l1,%i3
/* 0x0430	     */		sra	%o5,0,%g5
/* 0x0434	     */		sub	%g5,%o7,%g2
/* 0x0438	     */		and	%l7,%i3,%o3
/* 0x043c	     */		srlx	%g2,63,%l7
/* 0x0440	     */		sra	%l2,0,%g3
/* 0x0444	     */		sra	%l3,0,%g2
/* 0x0448	     */		sub	%g3,%o7,%o2
/* 0x044c	     */		xor	%l7,1,%o0
/* 0x0450	     */		srlx	%o2,63,%g4
/* 0x0454	     */		sub	%g2,%o7,%o1
/* 0x0458	     */		and	%o0,%l5,%l5
/* 0x045c	     */		xor	%g4,1,%o5
/* 0x0460	     */		srlx	%o1,63,%l2
/* 0x0464	     */		and	%o3,%l5,%g5
/* 0x0468	     */		and	%l6,%o5,%l6
/* 0x046c	     */		xor	%l2,1,%l3
/* 0x0470	     */		and	%g5,%l6,%l1
/* 0x0474	     */		and	%l3,1,%o4
/* 0x0478	     */		andcc	%l1,%o4,%g0
/* 0x047c	     */		be,a,pn	%icc,.L77005199
/* 0x0480	     */		or	%g0,0,%l5

! Registers live out of .L77005033: 
! sp o7 l0 l4 l5 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005033

			.L77005034:
/* 0x0484	 578 */		sub	%i2,%l0,%l6
/* 0x0488	     */		sub	%i0,%l0,%l2
/* 0x048c	     */		sra	%l6,31,%l1
/* 0x0490	     */		sra	%l2,31,%o1
/* 0x0494	     */		xor	%l6,%l1,%i3
/* 0x0498	     */		xor	%l2,%o1,%g5
/* 0x049c	     */		sub	%i3,%l1,%g2
/* 0x04a0	     */		sub	%g5,%o1,%o3
/* 0x04a4	     */		sra	%g2,0,%o4
/* 0x04a8	     */		sra	%o3,0,%g3
/* 0x04ac	     */		sub	%o4,%o7,%o0
/* 0x04b0	     */		sub	%g3,%o7,%g4
/* 0x04b4	     */		srlx	%o0,63,%l5
/* 0x04b8	     */		srlx	%g4,63,%l3
/* 0x04bc	     */		xor	%l5,1,%l7
/* 0x04c0	     */		xor	%l3,1,%o2
/* 0x04c4	     */		andcc	%o2,%l7,%g0
/* 0x04c8	     */		be,a,pn	%icc,.L77005199
/* 0x04cc	     */		or	%g0,0,%l5

! Registers live out of .L77005034: 
! sp l0 l4 l5 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005034

			.L77005095:
/* 0x04d0	 574 */		ld	[%l4+4],%f26
/* 0x04d4	 575 */		ld	[%l4+8],%f14
/* 0x04d8	 576 */		ld	[%l4+12],%f22
/* 0x04dc	 577 */		ld	[%l4+16],%f18

!  579		      !               if (mask[i]) {

/* 0x04e0	 579 */		ldub	[%l0],%g4
/* 0x04e4	 575 */		fstoi	%f14,%f16
/* 0x04e8	     */		st	%f16,[%sp+124]
/* 0x04ec	     */		ld	[%sp+124],%o0
/* 0x04f0	 577 */		fstoi	%f18,%f20
/* 0x04f4	     */		st	%f20,[%sp+132]
/* 0x04f8	     */		ld	[%sp+132],%o7
/* 0x04fc	 576 */		fstoi	%f22,%f24
/* 0x0500	     */		st	%f24,[%sp+128]
/* 0x0504	 574 */		fstoi	%f26,%f28
/* 0x0508	     */		st	%f28,[%sp+120]
/* 0x050c	     */		ld	[%sp+120],%g5
/* 0x0510	     */		add	%i1,-1,%o2
/* 0x0514	 576 */		ld	[%sp+128],%o5
/* 0x0518	 574 */		or	%g0,0,%i1

! Registers live out of .L77005095: 
! g4 g5 o0 o2 o5 sp o7 l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004645 .L77005095

			.L900000671:
/* 0x051c	 579 */		cmp	%g4,0
/* 0x0520	     */		be,pn	%icc,.L77004645
/* 0x0524	 578 */		add	%i1,1,%i1

! Registers live out of .L900000671: 
! g4 g5 o0 o2 o5 sp o7 l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  580		      !                  red[i]   = r;

                       
! predecessor blocks: .L900000671

			.L77004643:
/* 0x0528	 580 */		stb	%g5,[%i4]

!  581		      !                  green[i] = g;

/* 0x052c	 581 */		stb	%o0,[%i5]

!  582		      !                  blue[i]  = b;

/* 0x0530	 582 */		stb	%o5,[%i0]

!  583		      !                  alpha[i] = a;

/* 0x0534	 583 */		stb	%o7,[%i2]

! Registers live out of .L77004643: 
! g4 g5 o0 o2 o5 sp o7 l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004643 .L900000671

			.L77004645:
/* 0x0538	 578 */		cmp	%i1,%o2
/* 0x053c	     */		add	%l0,1,%l0
/* 0x0540	     */		add	%i2,1,%i2
/* 0x0544	     */		add	%i0,1,%i0
/* 0x0548	     */		add	%i5,1,%i5
/* 0x054c	     */		add	%i4,1,%i4
/* 0x0550	     */		ble,a,pt	%icc,.L900000671
/* 0x0554	 579 */		ldub	[%l0],%g4

! Registers live out of .L77004645: 
! g4 g5 o0 o2 o5 sp o7 l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004645

			.L77005030:
/* 0x0558	 578 */		ba	.L77004840
/* 0x055c	     */		nop

! Registers live out of .L77005030: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004871

			.L77005263:
/* 0x0560	 578 */		ld	[%fp+92],%i0
/* 0x0564	     */		ld	[%fp+96],%i2
/* 0x0568	     */		or	%g0,0,%l5

! Registers live out of .L77005263: 
! sp l0 l4 l5 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005033 .L77005034 .L77005263

			.L77005199:
/* 0x056c	 574 */		ld	[%l4+4],%f8
/* 0x0570	 575 */		ld	[%l4+8],%f0
/* 0x0574	 576 */		ld	[%l4+12],%f2
/* 0x0578	 577 */		ld	[%l4+16],%f4
/* 0x057c	 579 */		ldub	[%l5+%l0],%o7
/* 0x0580	 575 */		fstoi	%f0,%f0
/* 0x0584	     */		st	%f0,[%sp+108]
/* 0x0588	     */		ld	[%sp+108],%l7
/* 0x058c	 577 */		fstoi	%f4,%f6
/* 0x0590	     */		st	%f6,[%sp+116]
/* 0x0594	     */		ld	[%sp+116],%l4
/* 0x0598	 576 */		fstoi	%f2,%f12
/* 0x059c	 574 */		fstoi	%f8,%f10
/* 0x05a0	     */		st	%f10,[%sp+104]
/* 0x05a4	 576 */		st	%f12,[%sp+112]
/* 0x05a8	 574 */		ld	[%sp+104],%i3
/* 0x05ac	 576 */		ld	[%sp+112],%o0

! Registers live out of .L77005199: 
! o0 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005199 .L900000669

			.L900000668:
/* 0x05b0	 579 */		cmp	%o7,0
/* 0x05b4	     */		be,a,pn	%icc,.L900000669
/* 0x05b8	 578 */		add	%l5,1,%l5

! Registers live out of .L900000668: 
! o0 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000668

			.L77005028:
/* 0x05bc	 580 */		stb	%i3,[%l5+%i4]
/* 0x05c0	 581 */		stb	%l7,[%l5+%i5]
/* 0x05c4	 582 */		stb	%o0,[%l5+%i0]
/* 0x05c8	 583 */		stb	%l4,[%l5+%i2]
/* 0x05cc	 578 */		add	%l5,1,%l5

! Registers live out of .L77005028: 
! o0 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005028 .L900000668

			.L900000669:
/* 0x05d0	 578 */		cmp	%l5,%i1
/* 0x05d4	     */		bcs,a,pt	%icc,.L900000668
/* 0x05d8	 579 */		ldub	[%l5+%l0],%o7

! Registers live out of .L900000669: 
! o0 sp o7 l0 l4 l5 l7 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000669

			.L900000637:
/* 0x05dc	 578 */		ba	.L77004840
/* 0x05e0	     */		nop

! Registers live out of .L900000637: 
! sp fp i7 gsr 
! 
		
!  584		      !               }
!  585		      !            }
!  586		      !         }
!  587		      !         break;
!  588		      !      case GL_COPY:
!  589		      !         /* do nothing */
!  590		      !         break;
!  591		      !      case GL_COPY_INVERTED:
!  592		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004653:
/* 0x05e4	 592 */		cmp	%i1,0
/* 0x05e8	     */		bleu,pn	%icc,.L77004840
/* 0x05ec	     */		cmp	%i1,22

! Registers live out of .L77004653: 
! o2 sp l0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004653

			.L77004859:
/* 0x05f0	 592 */		bl,pn	%icc,.L77005257
/* 0x05f4	     */		add	%o2,1022,%g3

! Registers live out of .L77004859: 
! g3 sp l0 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004859

			.L77004891:
/* 0x05f8	 592 */		sub	%i4,%i5,%i0
/* 0x05fc	     */		sub	%i5,%l0,%l1
/* 0x0600	     */		sra	%i0,31,%i2
/* 0x0604	     */		sra	%l1,31,%o0
/* 0x0608	     */		sub	%i4,%l0,%l4
/* 0x060c	     */		xor	%i0,%i2,%o5
/* 0x0610	     */		sra	%l4,31,%g4
/* 0x0614	     */		xor	%l1,%o0,%o7
/* 0x0618	     */		sub	%o5,%i2,%l2
/* 0x061c	     */		xor	%l4,%g4,%l6
/* 0x0620	     */		sub	%o7,%o0,%o1
/* 0x0624	     */		sra	%i1,0,%o7
/* 0x0628	     */		sub	%l6,%g4,%l7
/* 0x062c	     */		sra	%l2,0,%g2
/* 0x0630	     */		sub	%g2,%o7,%o4
/* 0x0634	     */		srl	%i1,0,%g4
/* 0x0638	     */		srlx	%o4,63,%l5
/* 0x063c	     */		sub	%g4,%g3,%g3
/* 0x0640	     */		xor	%l5,1,%i0
/* 0x0644	     */		srlx	%g3,63,%i2
/* 0x0648	     */		and	%i2,%i0,%l6
/* 0x064c	     */		sra	%l7,0,%g5
/* 0x0650	     */		sra	%o1,0,%o3
/* 0x0654	     */		sub	%g5,%o7,%o2
/* 0x0658	     */		srlx	%o2,63,%l3
/* 0x065c	     */		sub	%o3,%o7,%o5
/* 0x0660	     */		srlx	%o5,63,%i3
/* 0x0664	     */		xor	%l3,1,%l4
/* 0x0668	     */		xor	%i3,1,%l5
/* 0x066c	     */		ld	[%fp+92],%i0
/* 0x0670	     */		ld	[%fp+96],%i2
/* 0x0674	     */		sub	%i4,%i0,%o0
/* 0x0678	     */		sub	%i4,%i2,%l2
/* 0x067c	     */		sra	%o0,31,%l1
/* 0x0680	     */		sra	%l2,31,%g2
/* 0x0684	     */		sub	%i5,%i0,%o4
/* 0x0688	     */		xor	%l2,%g2,%o1
/* 0x068c	     */		sra	%o4,31,%o2
/* 0x0690	     */		xor	%o0,%l1,%l7
/* 0x0694	     */		sub	%o1,%g2,%g4
/* 0x0698	     */		sub	%l7,%l1,%l7
/* 0x069c	     */		sub	%i5,%i2,%o3
/* 0x06a0	     */		xor	%o4,%o2,%g5
/* 0x06a4	     */		sra	%o3,31,%i3
/* 0x06a8	     */		sub	%g5,%o2,%g5
/* 0x06ac	     */		sub	%i0,%i2,%l3
/* 0x06b0	     */		sra	%l7,0,%o1
/* 0x06b4	     */		sra	%g4,0,%o4
/* 0x06b8	     */		xor	%o3,%i3,%o5
/* 0x06bc	     */		sra	%l3,31,%o0
/* 0x06c0	     */		sub	%o1,%o7,%g2
/* 0x06c4	     */		sub	%o4,%o7,%o2
/* 0x06c8	     */		sub	%o5,%i3,%l2
/* 0x06cc	     */		xor	%l3,%o0,%g3
/* 0x06d0	     */		srlx	%g2,63,%l1
/* 0x06d4	     */		srlx	%o2,63,%o3
/* 0x06d8	     */		sub	%g3,%o0,%l3
/* 0x06dc	     */		xor	%l1,1,%o5
/* 0x06e0	     */		xor	%o3,1,%i3
/* 0x06e4	     */		and	%i3,%o5,%l7
/* 0x06e8	     */		sra	%g5,0,%g3
/* 0x06ec	     */		sub	%g3,%o7,%o0
/* 0x06f0	     */		and	%l6,%l7,%g2
/* 0x06f4	     */		sra	%l2,0,%g4
/* 0x06f8	     */		srlx	%o0,63,%l6
/* 0x06fc	     */		sub	%g4,%o7,%o4
/* 0x0700	     */		sra	%l3,0,%g5
/* 0x0704	     */		srlx	%o4,63,%o2
/* 0x0708	     */		xor	%l6,1,%o1
/* 0x070c	     */		sub	%g5,%o7,%o5
/* 0x0710	     */		xor	%o2,1,%o3
/* 0x0714	     */		and	%o1,%l4,%l4
/* 0x0718	     */		srlx	%o5,63,%i3
/* 0x071c	     */		and	%g2,%l4,%l1
/* 0x0720	     */		and	%l5,%o3,%l5
/* 0x0724	     */		xor	%i3,1,%l2
/* 0x0728	     */		and	%l1,%l5,%o0
/* 0x072c	     */		and	%l2,1,%g3
/* 0x0730	     */		andcc	%o0,%g3,%g0
/* 0x0734	     */		be,a,pn	%icc,.L77004885
/* 0x0738	     */		or	%g0,0,%o2

! Registers live out of .L77004891: 
! o2 sp o7 l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004891

			.L77004892:
/* 0x073c	 592 */		sub	%i2,%l0,%l6
/* 0x0740	     */		sub	%i0,%l0,%l2
/* 0x0744	     */		sra	%l6,31,%l1
/* 0x0748	     */		sra	%l2,31,%o0
/* 0x074c	     */		xor	%l6,%l1,%g4
/* 0x0750	     */		xor	%l2,%o0,%g3
/* 0x0754	     */		sub	%g4,%l1,%l7
/* 0x0758	     */		sub	%g3,%o0,%g2
/* 0x075c	     */		sra	%l7,0,%g5
/* 0x0760	     */		sra	%g2,0,%o4
/* 0x0764	     */		sub	%o4,%o7,%o2
/* 0x0768	     */		sub	%g5,%o7,%o1
/* 0x076c	     */		srlx	%o2,63,%l5
/* 0x0770	     */		srlx	%o1,63,%i3
/* 0x0774	     */		xor	%i3,1,%o3
/* 0x0778	     */		xor	%l5,1,%l3
/* 0x077c	     */		andcc	%l3,%o3,%g0
/* 0x0780	     */		be,a,pn	%icc,.L77004885
/* 0x0784	     */		or	%g0,0,%o2

! Registers live out of .L77004892: 
! o2 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004892

			.L77005098:
/* 0x0788	 592 */		add	%i1,-1,%l4

!  593		      !            if (mask[i]) {

/* 0x078c	 593 */		ldub	[%l0],%g3
/* 0x0790	 592 */		or	%g0,0,%l3

! Registers live out of .L77005098: 
! g3 sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004661 .L77005098

			.L900000667:
/* 0x0794	 593 */		cmp	%g3,0
/* 0x0798	     */		be,pn	%icc,.L77004661
/* 0x079c	 592 */		add	%l3,1,%l3

! Registers live out of .L900000667: 
! g3 sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  594		      !               red[i]   = ~red[i];

                       
! predecessor blocks: .L900000667

			.L77004659:
/* 0x07a0	 594 */		ldub	[%i4],%o1

!  595		      !               green[i] = ~green[i];

/* 0x07a4	 595 */		ldub	[%i5],%l5

!  596		      !               blue[i]  = ~blue[i];

/* 0x07a8	 596 */		ldub	[%i0],%o3

!  597		      !               alpha[i] = ~alpha[i];

/* 0x07ac	 597 */		ldub	[%i2],%l2
/* 0x07b0	 594 */		xnor	%o1,0,%o4
/* 0x07b4	     */		stb	%o4,[%i4]
/* 0x07b8	 595 */		xnor	%l5,0,%l6
/* 0x07bc	     */		stb	%l6,[%i5]
/* 0x07c0	 596 */		xnor	%o3,0,%l7
/* 0x07c4	     */		stb	%l7,[%i0]
/* 0x07c8	 597 */		xnor	%l2,0,%g2
/* 0x07cc	     */		stb	%g2,[%i2]

! Registers live out of .L77004659: 
! g3 sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004659 .L900000667

			.L77004661:
/* 0x07d0	 592 */		cmp	%l3,%l4
/* 0x07d4	     */		add	%l0,1,%l0
/* 0x07d8	     */		add	%i2,1,%i2
/* 0x07dc	     */		add	%i0,1,%i0
/* 0x07e0	     */		add	%i5,1,%i5
/* 0x07e4	     */		add	%i4,1,%i4
/* 0x07e8	     */		ble,a,pt	%icc,.L900000667
/* 0x07ec	 593 */		ldub	[%l0],%g3

! Registers live out of .L77004661: 
! g3 sp l0 l4 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004661

			.L77004888:
/* 0x07f0	 592 */		ba	.L77004840
/* 0x07f4	     */		nop

! Registers live out of .L77004888: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004859

			.L77005257:
/* 0x07f8	 592 */		ld	[%fp+92],%i0
/* 0x07fc	     */		ld	[%fp+96],%i2
/* 0x0800	     */		or	%g0,0,%o2

! Registers live out of .L77005257: 
! o2 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004891 .L77004892 .L77005257

			.L77004885:
/* 0x0804	 593 */		ldub	[%o2+%l0],%o4

! Registers live out of .L77004885: 
! o2 o4 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004885 .L900000666

			.L900000665:
/* 0x0808	 593 */		cmp	%o4,0
/* 0x080c	     */		be,a,pn	%icc,.L900000666
/* 0x0810	 592 */		add	%o2,1,%o2

! Registers live out of .L900000665: 
! o2 o4 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000665

			.L77004886:
/* 0x0814	 594 */		ldub	[%i4+%o2],%o7
/* 0x0818	     */		xnor	%o7,0,%l3
/* 0x081c	     */		stb	%l3,[%i4+%o2]
/* 0x0820	 595 */		ldub	[%i5+%o2],%l7
/* 0x0824	     */		xnor	%l7,0,%l6
/* 0x0828	     */		stb	%l6,[%i5+%o2]
/* 0x082c	 596 */		ldub	[%o2+%i0],%o1
/* 0x0830	     */		xnor	%o1,0,%l4
/* 0x0834	     */		stb	%l4,[%o2+%i0]
/* 0x0838	 597 */		ldub	[%o2+%i2],%g2
/* 0x083c	     */		xnor	%g2,0,%g4
/* 0x0840	     */		stb	%g4,[%o2+%i2]
/* 0x0844	 592 */		add	%o2,1,%o2

! Registers live out of .L77004886: 
! o2 o4 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004886 .L900000665

			.L900000666:
/* 0x0848	 592 */		cmp	%o2,%i1
/* 0x084c	     */		bcs,a,pt	%icc,.L900000665
/* 0x0850	 593 */		ldub	[%o2+%l0],%o4

! Registers live out of .L900000666: 
! o2 o4 sp l0 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000666

			.L900000636:
/* 0x0854	 592 */		ba	.L77004840
/* 0x0858	     */		nop

! Registers live out of .L900000636: 
! sp fp i7 gsr 
! 
		
!  598		      !            }
!  599		      !         }
!  600		      !         break;
!  601		      !      case GL_NOOP:
!  602		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004667:
/* 0x085c	 602 */		cmp	%i1,0
/* 0x0860	     */		bleu,pn	%icc,.L77004840
/* 0x0864	     */		cmp	%i1,54

! Registers live out of .L77004667: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004667

			.L77004866:
/* 0x0868	 602 */		bl,pn	%icc,.L77005243
/* 0x086c	     */		add	%o2,1022,%o7

! Registers live out of .L77004866: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004866

			.L77004974:
/* 0x0870	 602 */		sethi	%hi(0x1000),%g1
/* 0x0874	     */		xor	%g1,-704,%g1
/* 0x0878	     */		sub	%i4,%i5,%i2
/* 0x087c	     */		add	%g1,%fp,%i0
/* 0x0880	     */		sub	%i4,%i0,%o2
/* 0x0884	     */		sra	%i2,31,%o0
/* 0x0888	     */		xor	%i2,%o0,%i0
/* 0x088c	     */		sub	%i4,%l1,%o3
/* 0x0890	     */		sra	%o3,31,%i2
/* 0x0894	     */		sub	%i0,%o0,%l7
/* 0x0898	     */		xor	%o3,%i2,%o5
/* 0x089c	     */		sub	%i4,%l6,%i3
/* 0x08a0	     */		sra	%i3,31,%o4
/* 0x08a4	     */		sra	%o2,31,%g2
/* 0x08a8	     */		sub	%o5,%i2,%o0
/* 0x08ac	     */		sub	%i4,%l2,%l5
/* 0x08b0	     */		xor	%i3,%o4,%g4
/* 0x08b4	     */		xor	%o2,%g2,%l3
/* 0x08b8	     */		sra	%l5,31,%g5
/* 0x08bc	     */		sub	%l3,%g2,%l4
/* 0x08c0	     */		xor	%l5,%g5,%o1
/* 0x08c4	     */		sub	%g4,%o4,%g3
/* 0x08c8	     */		sub	%i4,%l0,%i0
/* 0x08cc	     */		sub	%o1,%g5,%g2
/* 0x08d0	     */		sra	%i0,31,%g4
/* 0x08d4	     */		xor	%i0,%g4,%i3
/* 0x08d8	     */		sub	%i3,%g4,%l3
/* 0x08dc	     */		sra	%l7,0,%o1
/* 0x08e0	     */		sra	%l4,0,%g4
/* 0x08e4	     */		sra	%g3,0,%g3
/* 0x08e8	     */		ld	[%fp+96],%i2
/* 0x08ec	     */		ld	[%fp+92],%i0
/* 0x08f0	     */		sub	%i4,%i2,%g5
/* 0x08f4	     */		sra	%g5,31,%o5
/* 0x08f8	     */		xor	%g5,%o5,%o3
/* 0x08fc	     */		sub	%o3,%o5,%i3
/* 0x0900	     */		sub	%i4,%i0,%o4
/* 0x0904	     */		sra	%o0,0,%o3
/* 0x0908	     */		sra	%i1,0,%o0
/* 0x090c	     */		sra	%o4,31,%l5
/* 0x0910	     */		sra	%g2,0,%g5
/* 0x0914	     */		xor	%o4,%l5,%o2
/* 0x0918	     */		sub	%o1,%o0,%g2
/* 0x091c	     */		sub	%o2,%l5,%l7
/* 0x0920	     */		srlx	%g2,63,%l4
/* 0x0924	     */		sra	%l7,0,%o2
/* 0x0928	     */		sub	%g5,%o0,%g2
/* 0x092c	     */		srlx	%g2,63,%l7
/* 0x0930	     */		sra	%i3,0,%o4
/* 0x0934	     */		sub	%o2,%o0,%g2
/* 0x0938	     */		sub	%g4,%o0,%g4
/* 0x093c	     */		sra	%l3,0,%o5
/* 0x0940	     */		srlx	%g4,63,%l5
/* 0x0944	     */		sub	%o3,%o0,%o2
/* 0x0948	     */		sub	%o4,%o0,%o1
/* 0x094c	     */		sub	%g3,%o0,%g3
/* 0x0950	     */		srlx	%g3,63,%l3
/* 0x0954	     */		srlx	%o2,63,%g4
/* 0x0958	     */		srlx	%o1,63,%g5
/* 0x095c	     */		srlx	%g2,63,%g3
/* 0x0960	     */		xor	%l4,1,%o4
/* 0x0964	     */		xor	%l3,1,%o1
/* 0x0968	     */		sub	%o5,%o0,%o2
/* 0x096c	     */		xor	%g5,1,%i3
/* 0x0970	     */		and	%o4,%o1,%l4
/* 0x0974	     */		srlx	%o2,63,%g2
/* 0x0978	     */		srl	%i1,0,%g5
/* 0x097c	     */		xor	%l5,1,%o1
/* 0x0980	     */		xor	%l7,1,%o2
/* 0x0984	     */		xor	%g3,1,%o3
/* 0x0988	     */		sub	%g5,%o7,%o7
/* 0x098c	     */		and	%o3,%o2,%l7
/* 0x0990	     */		srlx	%o7,63,%l5
/* 0x0994	     */		and	%l5,%o1,%o2
/* 0x0998	     */		xor	%g4,1,%o5
/* 0x099c	     */		and	%o2,%l4,%o3
/* 0x09a0	     */		and	%i3,%o5,%l3
/* 0x09a4	     */		xor	%g2,1,%o4
/* 0x09a8	     */		and	%o3,%l7,%g4
/* 0x09ac	     */		and	%o4,1,%g3
/* 0x09b0	     */		and	%g4,%l3,%g5
/* 0x09b4	     */		andcc	%g5,%g3,%g0
/* 0x09b8	     */		be,a,pn	%icc,.L77004968
/* 0x09bc	     */		or	%g0,0,%o1

! Registers live out of .L77004974: 
! o0 o1 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004974

			.L77004975:
/* 0x09c0	 602 */		sub	%i5,%i0,%o5
/* 0x09c4	     */		sub	%i5,%l2,%l5
/* 0x09c8	     */		sethi	%hi(0x1000),%g1
/* 0x09cc	     */		sra	%o5,31,%l4
/* 0x09d0	     */		sra	%l5,31,%o4
/* 0x09d4	     */		xor	%g1,-704,%g1
/* 0x09d8	     */		xor	%o5,%l4,%o7
/* 0x09dc	     */		xor	%l5,%o4,%l3
/* 0x09e0	     */		add	%g1,%fp,%i3
/* 0x09e4	     */		sub	%i5,%i3,%g3
/* 0x09e8	     */		sub	%o7,%l4,%o1
/* 0x09ec	     */		sub	%l3,%o4,%g5
/* 0x09f0	     */		sub	%i5,%i2,%g2
/* 0x09f4	     */		sra	%g3,31,%l4
/* 0x09f8	     */		sub	%i0,%i3,%o4
/* 0x09fc	     */		sra	%g2,31,%l3
/* 0x0a00	     */		sub	%i5,%l6,%l7
/* 0x0a04	     */		sra	%l7,31,%o5
/* 0x0a08	     */		xor	%g3,%l4,%l5
/* 0x0a0c	     */		xor	%g2,%l3,%i3
/* 0x0a10	     */		xor	%l7,%o5,%o2
/* 0x0a14	     */		sub	%i5,%l1,%o3
/* 0x0a18	     */		sub	%l5,%l4,%g4
/* 0x0a1c	     */		sub	%i3,%l3,%g3
/* 0x0a20	     */		sub	%o2,%o5,%o7
/* 0x0a24	     */		sra	%o4,31,%l3
/* 0x0a28	     */		sub	%i5,%l0,%l5
/* 0x0a2c	     */		sra	%o3,31,%l7
/* 0x0a30	     */		xor	%o3,%l7,%o2
/* 0x0a34	     */		sra	%l5,31,%l4
/* 0x0a38	     */		sub	%i0,%l6,%o5
/* 0x0a3c	     */		xor	%o4,%l3,%i3
/* 0x0a40	     */		xor	%l5,%l4,%g2
/* 0x0a44	     */		sra	%o5,31,%o4
/* 0x0a48	     */		sub	%o2,%l7,%l7
/* 0x0a4c	     */		sub	%g2,%l4,%l5
/* 0x0a50	     */		xor	%o5,%o4,%o2
/* 0x0a54	     */		sub	%i0,%l2,%o3
/* 0x0a58	     */		sub	%i3,%l3,%i3
/* 0x0a5c	     */		sub	%o2,%o4,%l3
/* 0x0a60	     */		sra	%o3,31,%l4
/* 0x0a64	     */		sra	%o1,0,%o5
/* 0x0a68	     */		xor	%o3,%l4,%g2
/* 0x0a6c	     */		sub	%o5,%o0,%o4
/* 0x0a70	     */		sub	%g2,%l4,%l4
/* 0x0a74	     */		srlx	%o4,63,%o1
/* 0x0a78	     */		xor	%o1,1,%o3
/* 0x0a7c	     */		sra	%g5,0,%g2
/* 0x0a80	     */		sub	%g2,%o0,%o1
/* 0x0a84	     */		srlx	%o1,63,%g5
/* 0x0a88	     */		xor	%g5,1,%o5
/* 0x0a8c	     */		and	%o3,%o5,%o4
/* 0x0a90	     */		sra	%o7,0,%o2
/* 0x0a94	     */		sub	%o2,%o0,%o3
/* 0x0a98	     */		srlx	%o3,63,%o7
/* 0x0a9c	     */		xor	%o7,1,%o2
/* 0x0aa0	     */		sra	%g4,0,%g4
/* 0x0aa4	     */		sub	%g4,%o0,%o7
/* 0x0aa8	     */		srlx	%o7,63,%g4
/* 0x0aac	     */		xor	%g4,1,%g2
/* 0x0ab0	     */		and	%g2,%o2,%o1
/* 0x0ab4	     */		and	%o1,%o4,%o7
/* 0x0ab8	     */		sra	%l7,0,%o5
/* 0x0abc	     */		sra	%g3,0,%g3
/* 0x0ac0	     */		sub	%g3,%o0,%g5
/* 0x0ac4	     */		sub	%o5,%o0,%o4
/* 0x0ac8	     */		srlx	%g5,63,%g3
/* 0x0acc	     */		srlx	%o4,63,%l7
/* 0x0ad0	     */		xor	%g3,1,%o3
/* 0x0ad4	     */		xor	%l7,1,%g5
/* 0x0ad8	     */		and	%o3,%g5,%o5
/* 0x0adc	     */		sra	%l5,0,%g2
/* 0x0ae0	     */		sra	%i3,0,%o2
/* 0x0ae4	     */		sub	%g2,%o0,%o1
/* 0x0ae8	     */		sub	%o2,%o0,%o3
/* 0x0aec	     */		srlx	%o1,63,%l5
/* 0x0af0	     */		srlx	%o3,63,%i3
/* 0x0af4	     */		and	%o7,%o5,%g3
/* 0x0af8	     */		xor	%i3,1,%o4
/* 0x0afc	     */		xor	%l5,1,%g4
/* 0x0b00	     */		and	%o4,%g4,%o2
/* 0x0b04	     */		sra	%l3,0,%o7
/* 0x0b08	     */		sra	%l4,0,%g2
/* 0x0b0c	     */		sub	%g2,%o0,%o1
/* 0x0b10	     */		sub	%o7,%o0,%o4
/* 0x0b14	     */		srlx	%o1,63,%l4
/* 0x0b18	     */		srlx	%o4,63,%l3
/* 0x0b1c	     */		xor	%l3,1,%l7
/* 0x0b20	     */		xor	%l4,1,%g5
/* 0x0b24	     */		and	%g3,%o2,%o5
/* 0x0b28	     */		and	%g5,%l7,%o3
/* 0x0b2c	     */		andcc	%o5,%o3,%g0
/* 0x0b30	     */		be,a,pn	%icc,.L77004968
/* 0x0b34	     */		or	%g0,0,%o1

! Registers live out of .L77004975: 
! o0 o1 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004975

			.L77004976:
/* 0x0b38	 602 */		sethi	%hi(0x1000),%g1
/* 0x0b3c	     */		xor	%g1,-704,%g1
/* 0x0b40	     */		add	%g1,%fp,%l7
/* 0x0b44	     */		sub	%i2,%l7,%o4
/* 0x0b48	     */		sra	%o4,31,%o2
/* 0x0b4c	     */		sub	%i0,%i2,%l7
/* 0x0b50	     */		xor	%o4,%o2,%o1
/* 0x0b54	     */		sra	%l7,31,%l3
/* 0x0b58	     */		sub	%i0,%l0,%i3
/* 0x0b5c	     */		sra	%i3,31,%g5
/* 0x0b60	     */		sub	%o1,%o2,%l5
/* 0x0b64	     */		xor	%l7,%l3,%o3
/* 0x0b68	     */		sub	%i0,%l1,%g2
/* 0x0b6c	     */		xor	%i3,%g5,%o7
/* 0x0b70	     */		sra	%g2,31,%o5
/* 0x0b74	     */		sub	%i2,%l6,%g3
/* 0x0b78	     */		sub	%o3,%l3,%o2
/* 0x0b7c	     */		sub	%o7,%g5,%l4
/* 0x0b80	     */		xor	%g2,%o5,%o3
/* 0x0b84	     */		sra	%g3,31,%o4
/* 0x0b88	     */		xor	%g3,%o4,%o7
/* 0x0b8c	     */		sub	%o3,%o5,%g5
/* 0x0b90	     */		sub	%i2,%l0,%g2
/* 0x0b94	     */		sub	%i2,%l1,%o3
/* 0x0b98	     */		sub	%o7,%o4,%g3
/* 0x0b9c	     */		sra	%g2,31,%l3
/* 0x0ba0	     */		xor	%g2,%l3,%i3
/* 0x0ba4	     */		sra	%o3,31,%o7
/* 0x0ba8	     */		sub	%i2,%l2,%g4
/* 0x0bac	     */		sra	%g4,31,%o1
/* 0x0bb0	     */		xor	%o3,%o7,%o5
/* 0x0bb4	     */		sub	%i3,%l3,%l3
/* 0x0bb8	     */		sub	%o5,%o7,%i3
/* 0x0bbc	     */		xor	%g4,%o1,%g4
/* 0x0bc0	     */		sub	%g4,%o1,%l7
/* 0x0bc4	     */		sra	%l4,0,%o5
/* 0x0bc8	     */		sra	%l5,0,%o4
/* 0x0bcc	     */		sra	%o2,0,%o2
/* 0x0bd0	     */		sra	%g5,0,%g5
/* 0x0bd4	     */		sub	%o5,%o0,%o7
/* 0x0bd8	     */		sub	%o4,%o0,%o1
/* 0x0bdc	     */		sub	%o2,%o0,%o3
/* 0x0be0	     */		sub	%g5,%o0,%g2
/* 0x0be4	     */		srlx	%o7,63,%l4
/* 0x0be8	     */		srlx	%o1,63,%l5
/* 0x0bec	     */		srlx	%o3,63,%o2
/* 0x0bf0	     */		srlx	%g2,63,%g5
/* 0x0bf4	     */		xor	%l4,1,%g4
/* 0x0bf8	     */		xor	%l5,1,%o4
/* 0x0bfc	     */		xor	%o2,1,%o1
/* 0x0c00	     */		xor	%g5,1,%g2
/* 0x0c04	     */		and	%o4,%g4,%o5
/* 0x0c08	     */		and	%g2,%o1,%o3
/* 0x0c0c	     */		and	%o3,%o5,%g4
/* 0x0c10	     */		sra	%l7,0,%o7
/* 0x0c14	     */		sra	%g3,0,%g3
/* 0x0c18	     */		sub	%o7,%o0,%o4
/* 0x0c1c	     */		sub	%g3,%o0,%o5
/* 0x0c20	     */		srlx	%o4,63,%l7
/* 0x0c24	     */		srlx	%o5,63,%g3
/* 0x0c28	     */		xor	%g3,1,%l5
/* 0x0c2c	     */		xor	%l7,1,%o7
/* 0x0c30	     */		and	%o7,%l5,%l4
/* 0x0c34	     */		and	%g4,%l4,%g2
/* 0x0c38	     */		sra	%l3,0,%g4
/* 0x0c3c	     */		sub	%g4,%o0,%o1
/* 0x0c40	     */		sra	%i3,0,%o4
/* 0x0c44	     */		sub	%o4,%o0,%o0
/* 0x0c48	     */		srlx	%o1,63,%l3
/* 0x0c4c	     */		srlx	%o0,63,%i3
/* 0x0c50	     */		xor	%l3,1,%g5
/* 0x0c54	     */		xor	%i3,1,%o2
/* 0x0c58	     */		and	%g5,%o2,%o1
/* 0x0c5c	     */		andcc	%g2,%o1,%g0
/* 0x0c60	     */		be,a,pn	%icc,.L77004968
/* 0x0c64	     */		or	%g0,0,%o1

! Registers live out of .L77004976: 
! o1 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004976

			.L77005105:
/* 0x0c68	 602 */		sethi	%hi(0x1000),%g1
/* 0x0c6c	     */		xor	%g1,-704,%g1
/* 0x0c70	     */		add	%g1,%fp,%o2
/* 0x0c74	     */		sethi	%hi(0x2400),%g1
/* 0x0c78	     */		xor	%g1,-384,%g1
/* 0x0c7c	     */		add	%i1,-1,%l1
/* 0x0c80	     */		add	%g1,%fp,%i1
/* 0x0c84	     */		sethi	%hi(0x3800),%g1
/* 0x0c88	     */		xor	%g1,-64,%g1
/* 0x0c8c	     */		add	%g1,%fp,%o7
/* 0x0c90	     */		sethi	%hi(0x4800),%g1
/* 0x0c94	     */		xor	%g1,-768,%g1
/* 0x0c98	     */		or	%g0,0,%i3

!  603		      !            if (mask[i]) {

/* 0x0c9c	 603 */		ldub	[%l0],%o0
/* 0x0ca0	 602 */		add	%g1,%fp,%o5

! Registers live out of .L77005105: 
! o0 o2 o5 sp o7 l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004675 .L77005105

			.L900000664:
/* 0x0ca4	 603 */		cmp	%o0,0
/* 0x0ca8	     */		be,pn	%icc,.L77004675
/* 0x0cac	 602 */		add	%i3,1,%i3

! Registers live out of .L900000664: 
! o0 o2 o5 sp o7 l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  604		      !               red[i]   = rdest[i];

                       
! predecessor blocks: .L900000664

			.L77004673:
/* 0x0cb0	 604 */		ldub	[%o2],%g2
/* 0x0cb4	     */		stb	%g2,[%i4]

!  605		      !               green[i] = gdest[i];

/* 0x0cb8	 605 */		ldub	[%i1],%g3
/* 0x0cbc	     */		stb	%g3,[%i5]

!  606		      !               blue[i]  = bdest[i];

/* 0x0cc0	 606 */		ldub	[%o7],%g4
/* 0x0cc4	     */		stb	%g4,[%i0]

!  607		      !               alpha[i] = adest[i];

/* 0x0cc8	 607 */		ldub	[%o5],%g5
/* 0x0ccc	     */		stb	%g5,[%i2]

! Registers live out of .L77004673: 
! o0 o2 o5 sp o7 l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004673 .L900000664

			.L77004675:
/* 0x0cd0	 602 */		cmp	%i3,%l1
/* 0x0cd4	     */		add	%l0,1,%l0
/* 0x0cd8	     */		add	%o5,1,%o5
/* 0x0cdc	     */		add	%o7,1,%o7
/* 0x0ce0	     */		add	%i1,1,%i1
/* 0x0ce4	     */		add	%o2,1,%o2
/* 0x0ce8	     */		add	%i2,1,%i2
/* 0x0cec	     */		add	%i0,1,%i0
/* 0x0cf0	     */		add	%i5,1,%i5
/* 0x0cf4	     */		add	%i4,1,%i4
/* 0x0cf8	     */		ble,a,pt	%icc,.L900000664
/* 0x0cfc	 603 */		ldub	[%l0],%o0

! Registers live out of .L77004675: 
! o0 o2 o5 sp o7 l0 l1 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004675

			.L77004971:
/* 0x0d00	 602 */		ba	.L77004840
/* 0x0d04	     */		nop

! Registers live out of .L77004971: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004866

			.L77005243:
/* 0x0d08	 602 */		ld	[%fp+92],%i0
/* 0x0d0c	     */		ld	[%fp+96],%i2
/* 0x0d10	     */		or	%g0,0,%o1

! Registers live out of .L77005243: 
! o1 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004974 .L77004975 .L77004976 .L77005243

			.L77004968:
/* 0x0d14	 603 */		ldub	[%o1+%l0],%l4

! Registers live out of .L77004968: 
! o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004968 .L77004970

			.L900000663:
/* 0x0d18	 603 */		cmp	%l4,0
/* 0x0d1c	     */		be,pn	%icc,.L77004970
/* 0x0d20	 604 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000663: 
! g1 o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000663

			.L77004969:
/* 0x0d24	 604 */		xor	%g1,-704,%g1
/* 0x0d28	     */		add	%g1,%fp,%l4
/* 0x0d2c	     */		ldub	[%o1+%l4],%o0
/* 0x0d30	     */		stb	%o0,[%o1+%i4]
/* 0x0d34	 605 */		ldub	[%o1+%l6],%o5
/* 0x0d38	     */		stb	%o5,[%o1+%i5]
/* 0x0d3c	 606 */		ldub	[%o1+%l2],%i3
/* 0x0d40	     */		stb	%i3,[%o1+%i0]
/* 0x0d44	 607 */		ldub	[%o1+%l1],%o7
/* 0x0d48	     */		stb	%o7,[%o1+%i2]

! Registers live out of .L77004969: 
! o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004969 .L900000663

			.L77004970:
/* 0x0d4c	 602 */		add	%o1,1,%o1
/* 0x0d50	     */		cmp	%o1,%i1
/* 0x0d54	     */		bcs,a,pn	%icc,.L900000663
/* 0x0d58	 603 */		ldub	[%o1+%l0],%l4

! Registers live out of .L77004970: 
! o1 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004970

			.L900000635:
/* 0x0d5c	 602 */		ba	.L77004840
/* 0x0d60	     */		nop

! Registers live out of .L900000635: 
! sp fp i7 gsr 
! 
		
!  608		      !            }
!  609		      !         }
!  610		      !         break;
!  611		      !      case GL_INVERT:
!  612		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004681:
/* 0x0d64	 612 */		cmp	%i1,0
/* 0x0d68	     */		bleu,pn	%icc,.L77004840
/* 0x0d6c	     */		cmp	%i1,54

! Registers live out of .L77004681: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004681

			.L77004861:
/* 0x0d70	 612 */		bl,pn	%icc,.L77005253
/* 0x0d74	     */		add	%o2,1022,%o7

! Registers live out of .L77004861: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004861

			.L77004914:
/* 0x0d78	 612 */		sethi	%hi(0x1000),%g1
/* 0x0d7c	     */		xor	%g1,-704,%g1
/* 0x0d80	     */		sub	%i4,%i5,%i2
/* 0x0d84	     */		add	%g1,%fp,%i0
/* 0x0d88	     */		sub	%i4,%i0,%o4
/* 0x0d8c	     */		sra	%i2,31,%o0
/* 0x0d90	     */		xor	%i2,%o0,%i0
/* 0x0d94	     */		sub	%i4,%l6,%o2
/* 0x0d98	     */		sub	%i4,%l1,%o5
/* 0x0d9c	     */		sra	%o2,31,%g4
/* 0x0da0	     */		sra	%o5,31,%i2
/* 0x0da4	     */		sub	%i0,%o0,%l7
/* 0x0da8	     */		xor	%o2,%g4,%i3
/* 0x0dac	     */		xor	%o5,%i2,%o3
/* 0x0db0	     */		sub	%o3,%i2,%o0
/* 0x0db4	     */		sub	%i3,%g4,%g3
/* 0x0db8	     */		sub	%i4,%l0,%i0
/* 0x0dbc	     */		sra	%o4,31,%l3
/* 0x0dc0	     */		sra	%i0,31,%i3
/* 0x0dc4	     */		xor	%o4,%l3,%o1
/* 0x0dc8	     */		xor	%i0,%i3,%o2
/* 0x0dcc	     */		sub	%o1,%l3,%l4
/* 0x0dd0	     */		sub	%i4,%l2,%l5
/* 0x0dd4	     */		sra	%l5,31,%g5
/* 0x0dd8	     */		sub	%o2,%i3,%l3
/* 0x0ddc	     */		xor	%l5,%g5,%g2
/* 0x0de0	     */		sub	%g2,%g5,%l5
/* 0x0de4	     */		sra	%l7,0,%o1
/* 0x0de8	     */		sra	%g3,0,%g3
/* 0x0dec	     */		sra	%l4,0,%g4
/* 0x0df0	     */		ld	[%fp+96],%i2
/* 0x0df4	     */		ld	[%fp+92],%i0
/* 0x0df8	     */		sub	%i4,%i2,%o5
/* 0x0dfc	     */		sra	%o5,31,%i3
/* 0x0e00	     */		xor	%o5,%i3,%o3
/* 0x0e04	     */		sub	%i4,%i0,%o4
/* 0x0e08	     */		sra	%o4,31,%g5
/* 0x0e0c	     */		sub	%o3,%i3,%l7
/* 0x0e10	     */		xor	%o4,%g5,%g2
/* 0x0e14	     */		sra	%o0,0,%o3
/* 0x0e18	     */		sra	%i1,0,%o0
/* 0x0e1c	     */		sub	%g2,%g5,%o2
/* 0x0e20	     */		sub	%o1,%o0,%g2
/* 0x0e24	     */		sra	%l3,0,%o5
/* 0x0e28	     */		sub	%g3,%o0,%o1
/* 0x0e2c	     */		sra	%l5,0,%g5
/* 0x0e30	     */		srlx	%g2,63,%l4
/* 0x0e34	     */		srlx	%o1,63,%l3
/* 0x0e38	     */		sra	%l7,0,%o4
/* 0x0e3c	     */		sub	%g4,%o0,%o1
/* 0x0e40	     */		sub	%g5,%o0,%g2
/* 0x0e44	     */		srlx	%o1,63,%l5
/* 0x0e48	     */		sub	%o4,%o0,%g5
/* 0x0e4c	     */		xor	%l3,1,%o1
/* 0x0e50	     */		srlx	%g5,63,%g5
/* 0x0e54	     */		xor	%g5,1,%l3
/* 0x0e58	     */		xor	%l4,1,%o4
/* 0x0e5c	     */		sra	%o2,0,%o2
/* 0x0e60	     */		srlx	%g2,63,%i3
/* 0x0e64	     */		and	%o4,%o1,%l4
/* 0x0e68	     */		sub	%o2,%o0,%g3
/* 0x0e6c	     */		srl	%i1,0,%g5
/* 0x0e70	     */		srlx	%g3,63,%g3
/* 0x0e74	     */		sub	%o3,%o0,%g4
/* 0x0e78	     */		xor	%l5,1,%o1
/* 0x0e7c	     */		sub	%o5,%o0,%g2
/* 0x0e80	     */		sub	%g5,%o7,%o7
/* 0x0e84	     */		xor	%i3,1,%o5
/* 0x0e88	     */		xor	%g3,1,%o3
/* 0x0e8c	     */		srlx	%o7,63,%l5
/* 0x0e90	     */		and	%o3,%o5,%l7
/* 0x0e94	     */		srlx	%g4,63,%g4
/* 0x0e98	     */		and	%l5,%o1,%i3
/* 0x0e9c	     */		xor	%g4,1,%o2
/* 0x0ea0	     */		srlx	%g2,63,%g2
/* 0x0ea4	     */		and	%i3,%l4,%o5
/* 0x0ea8	     */		and	%l3,%o2,%o3
/* 0x0eac	     */		xor	%g2,1,%o4
/* 0x0eb0	     */		and	%o5,%l7,%g4
/* 0x0eb4	     */		and	%o4,1,%g3
/* 0x0eb8	     */		and	%g4,%o3,%g5
/* 0x0ebc	     */		andcc	%g5,%g3,%g0
/* 0x0ec0	     */		be,a,pn	%icc,.L77004908
/* 0x0ec4	     */		or	%g0,0,%l3

! Registers live out of .L77004914: 
! o0 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004914

			.L77004915:
/* 0x0ec8	 612 */		sub	%i5,%i0,%o5
/* 0x0ecc	     */		sethi	%hi(0x1000),%g1
/* 0x0ed0	     */		sra	%o5,31,%l4
/* 0x0ed4	     */		sub	%i5,%l2,%l5
/* 0x0ed8	     */		xor	%g1,-704,%g1
/* 0x0edc	     */		xor	%o5,%l4,%o7
/* 0x0ee0	     */		sra	%l5,31,%o4
/* 0x0ee4	     */		add	%g1,%fp,%o1
/* 0x0ee8	     */		sub	%i5,%o1,%g4
/* 0x0eec	     */		sub	%o7,%l4,%g2
/* 0x0ef0	     */		xor	%l5,%o4,%l3
/* 0x0ef4	     */		sub	%i5,%l6,%l7
/* 0x0ef8	     */		sub	%l3,%o4,%g5
/* 0x0efc	     */		sra	%l7,31,%o5
/* 0x0f00	     */		sra	%g4,31,%l4
/* 0x0f04	     */		sub	%i5,%i2,%g3
/* 0x0f08	     */		xor	%l7,%o5,%i3
/* 0x0f0c	     */		xor	%g4,%l4,%o7
/* 0x0f10	     */		sub	%i0,%o1,%o4
/* 0x0f14	     */		sra	%g3,31,%l5
/* 0x0f18	     */		sub	%i5,%l1,%o3
/* 0x0f1c	     */		xor	%g3,%l5,%o1
/* 0x0f20	     */		sra	%o3,31,%l3
/* 0x0f24	     */		sub	%i3,%o5,%o2
/* 0x0f28	     */		sub	%o7,%l4,%g4
/* 0x0f2c	     */		xor	%o3,%l3,%i3
/* 0x0f30	     */		sub	%i5,%l0,%o7
/* 0x0f34	     */		sub	%o1,%l5,%g3
/* 0x0f38	     */		sub	%i3,%l3,%l7
/* 0x0f3c	     */		sra	%o7,31,%o1
/* 0x0f40	     */		xor	%o7,%o1,%l4
/* 0x0f44	     */		sra	%o4,31,%l3
/* 0x0f48	     */		sub	%l4,%o1,%l5
/* 0x0f4c	     */		sub	%i0,%l6,%o5
/* 0x0f50	     */		sub	%i0,%l2,%o3
/* 0x0f54	     */		xor	%o4,%l3,%i3
/* 0x0f58	     */		sra	%o5,31,%o4
/* 0x0f5c	     */		sra	%o3,31,%o1
/* 0x0f60	     */		xor	%o5,%o4,%o7
/* 0x0f64	     */		sub	%i3,%l3,%i3
/* 0x0f68	     */		xor	%o3,%o1,%l4
/* 0x0f6c	     */		sub	%o7,%o4,%l3
/* 0x0f70	     */		sra	%g2,0,%o3
/* 0x0f74	     */		sub	%o3,%o0,%o4
/* 0x0f78	     */		srlx	%o4,63,%g2
/* 0x0f7c	     */		xor	%g2,1,%o3
/* 0x0f80	     */		sub	%l4,%o1,%l4
/* 0x0f84	     */		sra	%g5,0,%g2
/* 0x0f88	     */		sra	%o2,0,%o2
/* 0x0f8c	     */		sra	%g4,0,%g4
/* 0x0f90	     */		sub	%o2,%o0,%o1
/* 0x0f94	     */		sub	%g4,%o0,%o7
/* 0x0f98	     */		sub	%g2,%o0,%g5
/* 0x0f9c	     */		srlx	%o1,63,%o2
/* 0x0fa0	     */		srlx	%o7,63,%g4
/* 0x0fa4	     */		srlx	%g5,63,%g5
/* 0x0fa8	     */		xor	%g5,1,%o5
/* 0x0fac	     */		xor	%o2,1,%o1
/* 0x0fb0	     */		xor	%g4,1,%o7
/* 0x0fb4	     */		and	%o3,%o5,%o4
/* 0x0fb8	     */		and	%o7,%o1,%g2
/* 0x0fbc	     */		and	%g2,%o4,%o2
/* 0x0fc0	     */		sra	%l7,0,%o3
/* 0x0fc4	     */		sra	%g3,0,%g3
/* 0x0fc8	     */		sub	%g3,%o0,%o5
/* 0x0fcc	     */		sub	%o3,%o0,%o4
/* 0x0fd0	     */		srlx	%o5,63,%g3
/* 0x0fd4	     */		srlx	%o4,63,%l7
/* 0x0fd8	     */		xor	%g3,1,%o5
/* 0x0fdc	     */		xor	%l7,1,%g5
/* 0x0fe0	     */		and	%o5,%g5,%o3
/* 0x0fe4	     */		and	%o2,%o3,%o7
/* 0x0fe8	     */		sra	%l5,0,%g2
/* 0x0fec	     */		sra	%i3,0,%o2
/* 0x0ff0	     */		sub	%g2,%o0,%g5
/* 0x0ff4	     */		sub	%o2,%o0,%o1
/* 0x0ff8	     */		srlx	%g5,63,%l5
/* 0x0ffc	     */		srlx	%o1,63,%i3
/* 0x1000	     */		xor	%i3,1,%o4
/* 0x1004	     */		xor	%l5,1,%g4
/* 0x1008	     */		and	%o4,%g4,%o1
/* 0x100c	     */		sra	%l3,0,%o4
/* 0x1010	     */		sra	%l4,0,%g2
/* 0x1014	     */		sub	%o4,%o0,%o2
/* 0x1018	     */		sub	%g2,%o0,%g3
/* 0x101c	     */		srlx	%o2,63,%l3
/* 0x1020	     */		srlx	%g3,63,%l4
/* 0x1024	     */		xor	%l3,1,%l7
/* 0x1028	     */		xor	%l4,1,%g5
/* 0x102c	     */		and	%o7,%o1,%o3
/* 0x1030	     */		and	%g5,%l7,%o5
/* 0x1034	     */		andcc	%o3,%o5,%g0
/* 0x1038	     */		be,a,pn	%icc,.L77004908
/* 0x103c	     */		or	%g0,0,%l3

! Registers live out of .L77004915: 
! o0 sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004915

			.L77004916:
/* 0x1040	 612 */		sethi	%hi(0x1000),%g1
/* 0x1044	     */		xor	%g1,-704,%g1
/* 0x1048	     */		add	%g1,%fp,%l4
/* 0x104c	     */		sub	%i2,%l4,%o4
/* 0x1050	     */		sub	%i0,%l0,%o1
/* 0x1054	     */		sra	%o1,31,%g5
/* 0x1058	     */		sra	%o4,31,%o3
/* 0x105c	     */		xor	%o1,%g5,%o7
/* 0x1060	     */		xor	%o4,%o3,%o2
/* 0x1064	     */		sub	%i0,%i2,%o5
/* 0x1068	     */		sub	%i2,%l6,%g3
/* 0x106c	     */		sub	%o7,%g5,%l4
/* 0x1070	     */		sra	%o5,31,%l3
/* 0x1074	     */		sra	%g3,31,%o4
/* 0x1078	     */		sub	%i0,%l1,%g2
/* 0x107c	     */		sub	%o2,%o3,%l5
/* 0x1080	     */		xor	%o5,%l3,%l7
/* 0x1084	     */		sra	%g2,31,%o1
/* 0x1088	     */		xor	%g3,%o4,%o7
/* 0x108c	     */		sub	%i2,%l2,%g4
/* 0x1090	     */		xor	%g2,%o1,%o5
/* 0x1094	     */		sra	%g4,31,%i3
/* 0x1098	     */		sub	%i2,%l1,%o3
/* 0x109c	     */		sub	%o7,%o4,%g3
/* 0x10a0	     */		sra	%o3,31,%o7
/* 0x10a4	     */		sub	%l7,%l3,%o2
/* 0x10a8	     */		sub	%o5,%o1,%g5
/* 0x10ac	     */		sub	%i2,%l0,%g2
/* 0x10b0	     */		xor	%g4,%i3,%g4
/* 0x10b4	     */		sub	%g4,%i3,%l7
/* 0x10b8	     */		xor	%o3,%o7,%o1
/* 0x10bc	     */		sra	%g2,31,%l3
/* 0x10c0	     */		xor	%g2,%l3,%o5
/* 0x10c4	     */		sub	%o1,%o7,%i3
/* 0x10c8	     */		sub	%o5,%l3,%l3
/* 0x10cc	     */		sra	%l4,0,%o1
/* 0x10d0	     */		sra	%l5,0,%o4
/* 0x10d4	     */		sra	%o2,0,%o2
/* 0x10d8	     */		sra	%g5,0,%g5
/* 0x10dc	     */		sub	%o1,%o0,%o7
/* 0x10e0	     */		sub	%o4,%o0,%o3
/* 0x10e4	     */		sub	%o2,%o0,%o5
/* 0x10e8	     */		sub	%g5,%o0,%g2
/* 0x10ec	     */		srlx	%o7,63,%l4
/* 0x10f0	     */		srlx	%o3,63,%l5
/* 0x10f4	     */		srlx	%o5,63,%o2
/* 0x10f8	     */		srlx	%g2,63,%g5
/* 0x10fc	     */		xor	%l4,1,%g4
/* 0x1100	     */		xor	%l5,1,%o4
/* 0x1104	     */		xor	%o2,1,%o3
/* 0x1108	     */		xor	%g5,1,%g2
/* 0x110c	     */		and	%o4,%g4,%o1
/* 0x1110	     */		and	%g2,%o3,%o5
/* 0x1114	     */		and	%o5,%o1,%g4
/* 0x1118	     */		sra	%l7,0,%o7
/* 0x111c	     */		sra	%g3,0,%g3
/* 0x1120	     */		sub	%o7,%o0,%o4
/* 0x1124	     */		sub	%g3,%o0,%o1
/* 0x1128	     */		srlx	%o4,63,%l7
/* 0x112c	     */		srlx	%o1,63,%g3
/* 0x1130	     */		xor	%g3,1,%l5
/* 0x1134	     */		xor	%l7,1,%o7
/* 0x1138	     */		and	%o7,%l5,%l4
/* 0x113c	     */		and	%g4,%l4,%g2
/* 0x1140	     */		sra	%l3,0,%g4
/* 0x1144	     */		sub	%g4,%o0,%o3
/* 0x1148	     */		sra	%i3,0,%o4
/* 0x114c	     */		sub	%o4,%o0,%o0
/* 0x1150	     */		srlx	%o3,63,%l3
/* 0x1154	     */		srlx	%o0,63,%i3
/* 0x1158	     */		xor	%l3,1,%g5
/* 0x115c	     */		xor	%i3,1,%o2
/* 0x1160	     */		and	%g5,%o2,%o3
/* 0x1164	     */		andcc	%g2,%o3,%g0
/* 0x1168	     */		be,a,pn	%icc,.L77004908
/* 0x116c	     */		or	%g0,0,%l3

! Registers live out of .L77004916: 
! sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004916

			.L77005100:
/* 0x1170	 612 */		sethi	%hi(0x1000),%g1
/* 0x1174	     */		xor	%g1,-704,%g1
/* 0x1178	     */		add	%g1,%fp,%l6
/* 0x117c	     */		sethi	%hi(0x2400),%g1
/* 0x1180	     */		xor	%g1,-384,%g1
/* 0x1184	     */		add	%g1,%fp,%l5
/* 0x1188	     */		sethi	%hi(0x3800),%g1
/* 0x118c	     */		xor	%g1,-64,%g1
/* 0x1190	     */		add	%g1,%fp,%l4
/* 0x1194	     */		sethi	%hi(0x4800),%g1
/* 0x1198	     */		xor	%g1,-768,%g1
/* 0x119c	     */		add	%i1,-1,%l7
/* 0x11a0	     */		or	%g0,0,%o3

!  613		      !            if (mask[i]) {

/* 0x11a4	 613 */		ldub	[%l0],%o4
/* 0x11a8	 612 */		add	%g1,%fp,%l3

! Registers live out of .L77005100: 
! o3 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004689 .L77005100

			.L900000662:
/* 0x11ac	 613 */		cmp	%o4,0
/* 0x11b0	     */		be,pn	%icc,.L77004689
/* 0x11b4	 612 */		add	%o3,1,%o3

! Registers live out of .L900000662: 
! o3 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  614		      !               red[i]   = ~rdest[i];

                       
! predecessor blocks: .L900000662

			.L77004687:
/* 0x11b8	 614 */		ldub	[%l6],%o5

!  615		      !               green[i] = ~gdest[i];

/* 0x11bc	 615 */		ldub	[%l5],%i1

!  616		      !               blue[i]  = ~bdest[i];

/* 0x11c0	 616 */		ldub	[%l4],%i3

!  617		      !               alpha[i] = ~adest[i];

/* 0x11c4	 617 */		ldub	[%l3],%l2
/* 0x11c8	 614 */		xnor	%o5,0,%o7
/* 0x11cc	     */		stb	%o7,[%i4]
/* 0x11d0	 615 */		xnor	%i1,0,%o2
/* 0x11d4	     */		stb	%o2,[%i5]
/* 0x11d8	 616 */		xnor	%i3,0,%l1
/* 0x11dc	     */		stb	%l1,[%i0]
/* 0x11e0	 617 */		xnor	%l2,0,%o1
/* 0x11e4	     */		stb	%o1,[%i2]

! Registers live out of .L77004687: 
! o3 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004687 .L900000662

			.L77004689:
/* 0x11e8	 612 */		cmp	%o3,%l7
/* 0x11ec	     */		add	%l0,1,%l0
/* 0x11f0	     */		add	%l3,1,%l3
/* 0x11f4	     */		add	%l4,1,%l4
/* 0x11f8	     */		add	%l5,1,%l5
/* 0x11fc	     */		add	%l6,1,%l6
/* 0x1200	     */		add	%i2,1,%i2
/* 0x1204	     */		add	%i0,1,%i0
/* 0x1208	     */		add	%i5,1,%i5
/* 0x120c	     */		add	%i4,1,%i4
/* 0x1210	     */		ble,a,pt	%icc,.L900000662
/* 0x1214	 613 */		ldub	[%l0],%o4

! Registers live out of .L77004689: 
! o3 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004689

			.L77004911:
/* 0x1218	 612 */		ba	.L77004840
/* 0x121c	     */		nop

! Registers live out of .L77004911: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004861

			.L77005253:
/* 0x1220	 612 */		ld	[%fp+92],%i0
/* 0x1224	     */		ld	[%fp+96],%i2
/* 0x1228	     */		or	%g0,0,%l3

! Registers live out of .L77005253: 
! sp l0 l1 l2 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004914 .L77004915 .L77004916 .L77005253

			.L77004908:
/* 0x122c	 613 */		ldub	[%l3+%l0],%i3

! Registers live out of .L77004908: 
! sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004908 .L77004910

			.L900000661:
/* 0x1230	 613 */		cmp	%i3,0
/* 0x1234	     */		be,pn	%icc,.L77004910
/* 0x1238	 614 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000661: 
! g1 sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000661

			.L77004909:
/* 0x123c	 614 */		xor	%g1,-704,%g1
/* 0x1240	     */		add	%g1,%fp,%o0
/* 0x1244	     */		ldub	[%l3+%o0],%o0
/* 0x1248	     */		xnor	%o0,0,%o2
/* 0x124c	     */		stb	%o2,[%l3+%i4]
/* 0x1250	 615 */		ldub	[%l3+%l6],%o7
/* 0x1254	     */		xnor	%o7,0,%l4
/* 0x1258	     */		stb	%l4,[%l3+%i5]
/* 0x125c	 616 */		ldub	[%l3+%l2],%o1
/* 0x1260	     */		xnor	%o1,0,%g2
/* 0x1264	     */		stb	%g2,[%l3+%i0]
/* 0x1268	 617 */		ldub	[%l3+%l1],%o4
/* 0x126c	     */		xnor	%o4,0,%l5
/* 0x1270	     */		stb	%l5,[%l3+%i2]

! Registers live out of .L77004909: 
! sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004909 .L900000661

			.L77004910:
/* 0x1274	 612 */		add	%l3,1,%l3
/* 0x1278	     */		cmp	%l3,%i1
/* 0x127c	     */		bcs,a,pn	%icc,.L900000661
/* 0x1280	 613 */		ldub	[%l3+%l0],%i3

! Registers live out of .L77004910: 
! sp l0 l1 l2 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004910

			.L900000634:
/* 0x1284	 612 */		ba	.L77004840
/* 0x1288	     */		nop

! Registers live out of .L900000634: 
! sp fp i7 gsr 
! 
		
!  618		      !            }
!  619		      !         }
!  620		      !         break;
!  621		      !      case GL_AND:
!  622		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004695:
/* 0x128c	 622 */		cmp	%i1,0
/* 0x1290	     */		bleu,pn	%icc,.L77004840
/* 0x1294	     */		cmp	%i1,54

! Registers live out of .L77004695: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004695

			.L77004869:
/* 0x1298	 622 */		bl,pn	%icc,.L77005237
/* 0x129c	     */		add	%o2,1022,%o7

! Registers live out of .L77004869: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004869

			.L77005010:
/* 0x12a0	 622 */		sethi	%hi(0x1000),%g1
/* 0x12a4	     */		sub	%i4,%i5,%i0
/* 0x12a8	     */		sub	%i4,%l6,%o0
/* 0x12ac	     */		xor	%g1,-704,%g1
/* 0x12b0	     */		sra	%i0,31,%o2
/* 0x12b4	     */		sra	%o0,31,%g4
/* 0x12b8	     */		add	%g1,%fp,%g2
/* 0x12bc	     */		sub	%i4,%g2,%o1
/* 0x12c0	     */		xor	%i0,%o2,%i2
/* 0x12c4	     */		xor	%o0,%g4,%i3
/* 0x12c8	     */		sub	%i2,%o2,%l7
/* 0x12cc	     */		sra	%o1,31,%l3
/* 0x12d0	     */		sub	%i4,%l0,%o0
/* 0x12d4	     */		xor	%o1,%l3,%o4
/* 0x12d8	     */		sra	%o0,31,%i2
/* 0x12dc	     */		sub	%i3,%g4,%g3
/* 0x12e0	     */		sub	%i4,%l1,%o3
/* 0x12e4	     */		sub	%o4,%l3,%l4
/* 0x12e8	     */		sra	%o3,31,%i0
/* 0x12ec	     */		xor	%o0,%i2,%i3
/* 0x12f0	     */		xor	%o3,%i0,%o5
/* 0x12f4	     */		sub	%i3,%i2,%l3
/* 0x12f8	     */		sub	%o5,%i0,%o2
/* 0x12fc	     */		sub	%i4,%l2,%l5
/* 0x1300	     */		sra	%l5,31,%g5
/* 0x1304	     */		xor	%l5,%g5,%g2
/* 0x1308	     */		sub	%g2,%g5,%l5
/* 0x130c	     */		sra	%l7,0,%o1
/* 0x1310	     */		sra	%l4,0,%g4
/* 0x1314	     */		sra	%g3,0,%g3
/* 0x1318	     */		ld	[%fp+96],%i2
/* 0x131c	     */		ld	[%fp+92],%i0
/* 0x1320	     */		sub	%i4,%i2,%o3
/* 0x1324	     */		sra	%o3,31,%i3
/* 0x1328	     */		sub	%i4,%i0,%o4
/* 0x132c	     */		sra	%o4,31,%g5
/* 0x1330	     */		xor	%o3,%i3,%o5
/* 0x1334	     */		xor	%o4,%g5,%g2
/* 0x1338	     */		sra	%o2,0,%o3
/* 0x133c	     */		sra	%i1,0,%o2
/* 0x1340	     */		sub	%g2,%g5,%o0
/* 0x1344	     */		sub	%o1,%o2,%g2
/* 0x1348	     */		sub	%g4,%o2,%o1
/* 0x134c	     */		sub	%o5,%i3,%l7
/* 0x1350	     */		sra	%l5,0,%g5
/* 0x1354	     */		srlx	%o1,63,%l4
/* 0x1358	     */		sra	%o0,0,%o0
/* 0x135c	     */		sra	%l7,0,%o4
/* 0x1360	     */		srlx	%g2,63,%i3
/* 0x1364	     */		sub	%g5,%o2,%g4
/* 0x1368	     */		sub	%o0,%o2,%o1
/* 0x136c	     */		sra	%l3,0,%o5
/* 0x1370	     */		sub	%g3,%o2,%g3
/* 0x1374	     */		srlx	%g3,63,%l3
/* 0x1378	     */		srlx	%g4,63,%l5
/* 0x137c	     */		srlx	%o1,63,%l7
/* 0x1380	     */		sub	%o4,%o2,%g2
/* 0x1384	     */		srlx	%g2,63,%g4
/* 0x1388	     */		xor	%i3,1,%o1
/* 0x138c	     */		xor	%l3,1,%o4
/* 0x1390	     */		sub	%o5,%o2,%o5
/* 0x1394	     */		sub	%o3,%o2,%o0
/* 0x1398	     */		and	%o4,%o1,%g5
/* 0x139c	     */		srlx	%o5,63,%g2
/* 0x13a0	     */		xor	%l7,1,%o3
/* 0x13a4	     */		xor	%g2,1,%o4
/* 0x13a8	     */		and	%o4,1,%l7
/* 0x13ac	     */		srl	%i1,0,%o4
/* 0x13b0	     */		xor	%l5,1,%o5
/* 0x13b4	     */		xor	%l4,1,%o1
/* 0x13b8	     */		sub	%o4,%o7,%o7
/* 0x13bc	     */		and	%o5,%o3,%l5
/* 0x13c0	     */		srlx	%o7,63,%l4
/* 0x13c4	     */		srlx	%o0,63,%g3
/* 0x13c8	     */		and	%l4,%o1,%o3
/* 0x13cc	     */		xor	%g3,1,%i3
/* 0x13d0	     */		xor	%g4,1,%o0
/* 0x13d4	     */		and	%o3,%g5,%o5
/* 0x13d8	     */		and	%i3,%o0,%l3
/* 0x13dc	     */		and	%o5,%l5,%g3
/* 0x13e0	     */		and	%g3,%l3,%g4
/* 0x13e4	     */		andcc	%g4,%l7,%g0
/* 0x13e8	     */		be,a,pn	%icc,.L77005004
/* 0x13ec	     */		or	%g0,0,%l4

! Registers live out of .L77005010: 
! o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005010

			.L77005011:
/* 0x13f0	 622 */		sub	%i5,%i0,%o1
/* 0x13f4	     */		sethi	%hi(0x1000),%g1
/* 0x13f8	     */		sra	%o1,31,%l4
/* 0x13fc	     */		xor	%g1,-704,%g1
/* 0x1400	     */		xor	%o1,%l4,%o5
/* 0x1404	     */		sub	%i5,%l2,%l5
/* 0x1408	     */		add	%g1,%fp,%o7
/* 0x140c	     */		sub	%i5,%o7,%o4
/* 0x1410	     */		sub	%o5,%l4,%g2
/* 0x1414	     */		sra	%l5,31,%i3
/* 0x1418	     */		xor	%l5,%i3,%l3
/* 0x141c	     */		sra	%o4,31,%l4
/* 0x1420	     */		sub	%i5,%l6,%l7
/* 0x1424	     */		sub	%l3,%i3,%g5
/* 0x1428	     */		sra	%l7,31,%o1
/* 0x142c	     */		xor	%o4,%l4,%o5
/* 0x1430	     */		sub	%i5,%i2,%g3
/* 0x1434	     */		sub	%i5,%l1,%o3
/* 0x1438	     */		sub	%i0,%o7,%o4
/* 0x143c	     */		sra	%g3,31,%l5
/* 0x1440	     */		sra	%o3,31,%l3
/* 0x1444	     */		xor	%l7,%o1,%o0
/* 0x1448	     */		xor	%g3,%l5,%o7
/* 0x144c	     */		xor	%o3,%l3,%i3
/* 0x1450	     */		sub	%o0,%o1,%o0
/* 0x1454	     */		sub	%i3,%l3,%l7
/* 0x1458	     */		sub	%i5,%l0,%o1
/* 0x145c	     */		sub	%o7,%l5,%g3
/* 0x1460	     */		sra	%o1,31,%o7
/* 0x1464	     */		sra	%o4,31,%l3
/* 0x1468	     */		sub	%o5,%l4,%g4
/* 0x146c	     */		xor	%o1,%o7,%l4
/* 0x1470	     */		sub	%i0,%l6,%o5
/* 0x1474	     */		xor	%o4,%l3,%i3
/* 0x1478	     */		sub	%l4,%o7,%l5
/* 0x147c	     */		sra	%o5,31,%o4
/* 0x1480	     */		sub	%i0,%l2,%o3
/* 0x1484	     */		xor	%o5,%o4,%o1
/* 0x1488	     */		sra	%o3,31,%o7
/* 0x148c	     */		sub	%i3,%l3,%i3
/* 0x1490	     */		sub	%o1,%o4,%l3
/* 0x1494	     */		xor	%o3,%o7,%l4
/* 0x1498	     */		sub	%l4,%o7,%l4
/* 0x149c	     */		sra	%g2,0,%o1
/* 0x14a0	     */		sra	%g5,0,%o5
/* 0x14a4	     */		sub	%o1,%o2,%o7
/* 0x14a8	     */		sub	%o5,%o2,%o4
/* 0x14ac	     */		srlx	%o7,63,%g2
/* 0x14b0	     */		srlx	%o4,63,%g5
/* 0x14b4	     */		xor	%g2,1,%o3
/* 0x14b8	     */		xor	%g5,1,%o5
/* 0x14bc	     */		and	%o5,%o3,%o1
/* 0x14c0	     */		sra	%o0,0,%g2
/* 0x14c4	     */		sra	%g4,0,%g4
/* 0x14c8	     */		sub	%g4,%o2,%o3
/* 0x14cc	     */		sub	%g2,%o2,%o0
/* 0x14d0	     */		srlx	%o3,63,%g4
/* 0x14d4	     */		srlx	%o0,63,%o0
/* 0x14d8	     */		xor	%o0,1,%o4
/* 0x14dc	     */		xor	%g4,1,%o7
/* 0x14e0	     */		and	%o7,%o4,%g2
/* 0x14e4	     */		and	%g2,%o1,%o5
/* 0x14e8	     */		sra	%l7,0,%o1
/* 0x14ec	     */		sra	%g3,0,%g3
/* 0x14f0	     */		sub	%g3,%o2,%g5
/* 0x14f4	     */		sub	%o1,%o2,%o7
/* 0x14f8	     */		srlx	%g5,63,%g3
/* 0x14fc	     */		srlx	%o7,63,%l7
/* 0x1500	     */		xor	%g3,1,%g5
/* 0x1504	     */		xor	%l7,1,%o3
/* 0x1508	     */		and	%o3,%g5,%o0
/* 0x150c	     */		and	%o5,%o0,%o7
/* 0x1510	     */		sra	%l5,0,%o5
/* 0x1514	     */		sra	%i3,0,%g2
/* 0x1518	     */		sub	%o5,%o2,%o4
/* 0x151c	     */		sub	%g2,%o2,%o0
/* 0x1520	     */		srlx	%o4,63,%l5
/* 0x1524	     */		srlx	%o0,63,%i3
/* 0x1528	     */		xor	%i3,1,%o1
/* 0x152c	     */		xor	%l5,1,%g4
/* 0x1530	     */		and	%o1,%g4,%o4
/* 0x1534	     */		and	%o7,%o4,%o5
/* 0x1538	     */		sra	%l3,0,%o1
/* 0x153c	     */		sra	%l4,0,%g2
/* 0x1540	     */		sub	%o1,%o2,%o7
/* 0x1544	     */		sub	%g2,%o2,%g3
/* 0x1548	     */		srlx	%g3,63,%l4
/* 0x154c	     */		srlx	%o7,63,%l3
/* 0x1550	     */		xor	%l4,1,%g5
/* 0x1554	     */		xor	%l3,1,%l7
/* 0x1558	     */		and	%g5,%l7,%o3
/* 0x155c	     */		andcc	%o5,%o3,%g0
/* 0x1560	     */		be,a,pn	%icc,.L77005004
/* 0x1564	     */		or	%g0,0,%l4

! Registers live out of .L77005011: 
! o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005011

			.L77005012:
/* 0x1568	 622 */		sethi	%hi(0x1000),%g1
/* 0x156c	     */		xor	%g1,-704,%g1
/* 0x1570	     */		sub	%i0,%l0,%o7
/* 0x1574	     */		add	%g1,%fp,%o0
/* 0x1578	     */		sub	%i2,%o0,%l5
/* 0x157c	     */		sub	%i0,%i2,%g5
/* 0x1580	     */		sra	%o7,31,%l4
/* 0x1584	     */		xor	%o7,%l4,%o0
/* 0x1588	     */		sra	%l5,31,%o3
/* 0x158c	     */		sra	%g5,31,%o1
/* 0x1590	     */		sub	%i2,%l6,%g3
/* 0x1594	     */		xor	%l5,%o3,%i3
/* 0x1598	     */		xor	%g5,%o1,%l7
/* 0x159c	     */		sra	%g3,31,%o7
/* 0x15a0	     */		sub	%i0,%l1,%g2
/* 0x15a4	     */		sub	%o0,%l4,%l4
/* 0x15a8	     */		sub	%i3,%o3,%l5
/* 0x15ac	     */		sra	%g2,31,%o4
/* 0x15b0	     */		xor	%g3,%o7,%o5
/* 0x15b4	     */		sub	%l7,%o1,%o0
/* 0x15b8	     */		sub	%i2,%l2,%g4
/* 0x15bc	     */		xor	%g2,%o4,%o1
/* 0x15c0	     */		sra	%g4,31,%i3
/* 0x15c4	     */		sub	%i2,%l1,%o3
/* 0x15c8	     */		sub	%o5,%o7,%g3
/* 0x15cc	     */		sra	%o3,31,%o5
/* 0x15d0	     */		sub	%o1,%o4,%g5
/* 0x15d4	     */		sub	%i2,%l0,%g2
/* 0x15d8	     */		xor	%g4,%i3,%g4
/* 0x15dc	     */		sub	%g4,%i3,%l7
/* 0x15e0	     */		xor	%o3,%o5,%o4
/* 0x15e4	     */		sra	%g2,31,%l3
/* 0x15e8	     */		xor	%g2,%l3,%o1
/* 0x15ec	     */		sub	%o4,%o5,%i3
/* 0x15f0	     */		sub	%o1,%l3,%l3
/* 0x15f4	     */		sra	%l4,0,%o4
/* 0x15f8	     */		sra	%l5,0,%o7
/* 0x15fc	     */		sra	%o0,0,%o0
/* 0x1600	     */		sra	%g5,0,%g5
/* 0x1604	     */		sub	%o4,%o2,%o5
/* 0x1608	     */		sub	%o7,%o2,%o3
/* 0x160c	     */		sub	%o0,%o2,%o1
/* 0x1610	     */		sub	%g5,%o2,%g2
/* 0x1614	     */		srlx	%o5,63,%l4
/* 0x1618	     */		srlx	%o3,63,%l5
/* 0x161c	     */		srlx	%o1,63,%o0
/* 0x1620	     */		srlx	%g2,63,%g5
/* 0x1624	     */		xor	%l4,1,%g4
/* 0x1628	     */		xor	%l5,1,%o7
/* 0x162c	     */		xor	%o0,1,%o3
/* 0x1630	     */		xor	%g5,1,%g2
/* 0x1634	     */		and	%o7,%g4,%o4
/* 0x1638	     */		and	%o3,%g2,%o1
/* 0x163c	     */		and	%o1,%o4,%g4
/* 0x1640	     */		sra	%l7,0,%o5
/* 0x1644	     */		sra	%g3,0,%g3
/* 0x1648	     */		sub	%g3,%o2,%o4
/* 0x164c	     */		sub	%o5,%o2,%o7
/* 0x1650	     */		srlx	%o4,63,%g3
/* 0x1654	     */		srlx	%o7,63,%l7
/* 0x1658	     */		xor	%g3,1,%l5
/* 0x165c	     */		xor	%l7,1,%o5
/* 0x1660	     */		and	%o5,%l5,%l4
/* 0x1664	     */		and	%g4,%l4,%o4
/* 0x1668	     */		sra	%l3,0,%g4
/* 0x166c	     */		sub	%g4,%o2,%o3
/* 0x1670	     */		sra	%i3,0,%o7
/* 0x1674	     */		sub	%o7,%o2,%o2
/* 0x1678	     */		srlx	%o3,63,%l3
/* 0x167c	     */		srlx	%o2,63,%i3
/* 0x1680	     */		xor	%l3,1,%g5
/* 0x1684	     */		xor	%i3,1,%o0
/* 0x1688	     */		and	%g5,%o0,%g2
/* 0x168c	     */		andcc	%o4,%g2,%g0
/* 0x1690	     */		be,a,pn	%icc,.L77005004
/* 0x1694	     */		or	%g0,0,%l4

! Registers live out of .L77005012: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005012

			.L77005108:
/* 0x1698	 622 */		sethi	%hi(0x1000),%g1
/* 0x169c	     */		xor	%g1,-704,%g1
/* 0x16a0	     */		add	%g1,%fp,%g4
/* 0x16a4	     */		sethi	%hi(0x2400),%g1
/* 0x16a8	     */		xor	%g1,-384,%g1
/* 0x16ac	     */		add	%g1,%fp,%g3
/* 0x16b0	     */		sethi	%hi(0x3800),%g1
/* 0x16b4	     */		xor	%g1,-64,%g1
/* 0x16b8	     */		add	%g1,%fp,%g2
/* 0x16bc	     */		sethi	%hi(0x4800),%g1
/* 0x16c0	     */		xor	%g1,-768,%g1
/* 0x16c4	     */		add	%i1,-1,%o0
/* 0x16c8	     */		or	%g0,0,%g5

!  623		      !            if (mask[i]) {

/* 0x16cc	 623 */		ldub	[%l0],%o3
/* 0x16d0	 622 */		add	%g1,%fp,%l7

! Registers live out of .L77005108: 
! g2 g3 g4 g5 o0 o3 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004703 .L77005108

			.L900000660:
/* 0x16d4	 623 */		cmp	%o3,0
/* 0x16d8	     */		be,pn	%icc,.L77004703
/* 0x16dc	 622 */		add	%g5,1,%g5

! Registers live out of .L900000660: 
! g2 g3 g4 g5 o0 o3 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  624		      !               red[i]   &= rdest[i];

                       
! predecessor blocks: .L900000660

			.L77004701:
/* 0x16e0	 624 */		ldub	[%i4],%i1

!  625		      !               green[i] &= gdest[i];

/* 0x16e4	 625 */		ldub	[%i5],%l1

!  626		      !               blue[i]  &= bdest[i];

/* 0x16e8	 626 */		ldub	[%i0],%l3

!  627		      !               alpha[i] &= adest[i];

/* 0x16ec	 627 */		ldub	[%i2],%l6
/* 0x16f0	 624 */		ldub	[%g4],%o7
/* 0x16f4	 625 */		ldub	[%g3],%i3
/* 0x16f8	 626 */		ldub	[%g2],%o1
/* 0x16fc	 627 */		ldub	[%l7],%l5
/* 0x1700	 624 */		and	%i1,%o7,%o2
/* 0x1704	     */		stb	%o2,[%i4]
/* 0x1708	 625 */		and	%l1,%i3,%l2
/* 0x170c	     */		stb	%l2,[%i5]
/* 0x1710	 626 */		and	%l3,%o1,%l4
/* 0x1714	     */		stb	%l4,[%i0]
/* 0x1718	 627 */		and	%l6,%l5,%o4
/* 0x171c	     */		stb	%o4,[%i2]

! Registers live out of .L77004701: 
! g2 g3 g4 g5 o0 o3 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004701 .L900000660

			.L77004703:
/* 0x1720	 622 */		cmp	%g5,%o0
/* 0x1724	     */		add	%l0,1,%l0
/* 0x1728	     */		add	%l7,1,%l7
/* 0x172c	     */		add	%g2,1,%g2
/* 0x1730	     */		add	%g3,1,%g3
/* 0x1734	     */		add	%g4,1,%g4
/* 0x1738	     */		add	%i2,1,%i2
/* 0x173c	     */		add	%i0,1,%i0
/* 0x1740	     */		add	%i5,1,%i5
/* 0x1744	     */		add	%i4,1,%i4
/* 0x1748	     */		ble,a,pt	%icc,.L900000660
/* 0x174c	 623 */		ldub	[%l0],%o3

! Registers live out of .L77004703: 
! g2 g3 g4 g5 o0 o3 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004703

			.L77005007:
/* 0x1750	 622 */		ba	.L77004840
/* 0x1754	     */		nop

! Registers live out of .L77005007: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004869

			.L77005237:
/* 0x1758	 622 */		ld	[%fp+92],%i0
/* 0x175c	     */		ld	[%fp+96],%i2
/* 0x1760	     */		or	%g0,0,%l4

! Registers live out of .L77005237: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005010 .L77005011 .L77005012 .L77005237

			.L77005004:
/* 0x1764	 623 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77005004: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005004 .L77005006

			.L900000659:
/* 0x1768	 623 */		cmp	%g3,0
/* 0x176c	     */		be,pn	%icc,.L77005006
/* 0x1770	 624 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000659: 
! g1 g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000659

			.L77005005:
/* 0x1774	 624 */		xor	%g1,-704,%g1
/* 0x1778	     */		add	%g1,%fp,%g5
/* 0x177c	     */		ldub	[%l4+%g5],%o2
/* 0x1780	     */		ldub	[%i4+%l4],%o0
/* 0x1784	     */		and	%o0,%o2,%i3
/* 0x1788	     */		stb	%i3,[%i4+%l4]
/* 0x178c	 625 */		ldub	[%l4+%l6],%o7
/* 0x1790	     */		ldub	[%i5+%l4],%g5
/* 0x1794	     */		and	%g5,%o7,%o1
/* 0x1798	     */		stb	%o1,[%i5+%l4]
/* 0x179c	 626 */		ldub	[%l4+%l2],%g2
/* 0x17a0	     */		ldub	[%l4+%i0],%o4
/* 0x17a4	     */		and	%o4,%g2,%o3
/* 0x17a8	     */		stb	%o3,[%l4+%i0]
/* 0x17ac	 627 */		ldub	[%l4+%l1],%l5
/* 0x17b0	     */		ldub	[%l4+%i2],%o5
/* 0x17b4	     */		and	%o5,%l5,%l3
/* 0x17b8	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77005005: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005005 .L900000659

			.L77005006:
/* 0x17bc	 622 */		add	%l4,1,%l4
/* 0x17c0	     */		cmp	%l4,%i1
/* 0x17c4	     */		bcs,a,pn	%icc,.L900000659
/* 0x17c8	 623 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77005006: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005006

			.L900000633:
/* 0x17cc	 622 */		ba	.L77004840
/* 0x17d0	     */		nop

! Registers live out of .L900000633: 
! sp fp i7 gsr 
! 
		
!  628		      !            }
!  629		      !         }
!  630		      !         break;
!  631		      !      case GL_NAND:
!  632		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004709:
/* 0x17d4	 632 */		cmp	%i1,0
/* 0x17d8	     */		bleu,pn	%icc,.L77004840
/* 0x17dc	     */		cmp	%i1,54

! Registers live out of .L77004709: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004709

			.L77004872:
/* 0x17e0	 632 */		bl,pn	%icc,.L77005261
/* 0x17e4	     */		add	%o2,1022,%o7

! Registers live out of .L77004872: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004872

			.L77005044:
/* 0x17e8	 632 */		sethi	%hi(0x1000),%g1
/* 0x17ec	     */		sub	%i4,%i5,%i0
/* 0x17f0	     */		sub	%i4,%l6,%o5
/* 0x17f4	     */		xor	%g1,-704,%g1
/* 0x17f8	     */		sra	%i0,31,%o2
/* 0x17fc	     */		sra	%o5,31,%g4
/* 0x1800	     */		add	%g1,%fp,%l4
/* 0x1804	     */		sub	%i4,%l4,%o4
/* 0x1808	     */		xor	%i0,%o2,%i2
/* 0x180c	     */		xor	%o5,%g4,%i3
/* 0x1810	     */		sub	%i2,%o2,%l7
/* 0x1814	     */		sra	%o4,31,%o0
/* 0x1818	     */		sub	%i4,%l0,%o5
/* 0x181c	     */		xor	%o4,%o0,%l3
/* 0x1820	     */		sra	%o5,31,%i2
/* 0x1824	     */		sub	%i3,%g4,%g3
/* 0x1828	     */		sub	%l3,%o0,%l4
/* 0x182c	     */		xor	%o5,%i2,%i3
/* 0x1830	     */		sub	%i4,%l1,%o3
/* 0x1834	     */		sra	%o3,31,%i0
/* 0x1838	     */		sub	%i3,%i2,%l3
/* 0x183c	     */		sub	%i4,%l2,%l5
/* 0x1840	     */		sra	%l5,31,%g5
/* 0x1844	     */		xor	%o3,%i0,%o1
/* 0x1848	     */		xor	%l5,%g5,%g2
/* 0x184c	     */		sub	%o1,%i0,%o2
/* 0x1850	     */		sub	%g2,%g5,%l5
/* 0x1854	     */		sra	%l7,0,%o1
/* 0x1858	     */		sra	%g3,0,%g3
/* 0x185c	     */		sra	%l4,0,%g4
/* 0x1860	     */		ld	[%fp+96],%i2
/* 0x1864	     */		ld	[%fp+92],%i0
/* 0x1868	     */		sub	%i4,%i2,%g5
/* 0x186c	     */		sra	%g5,31,%o5
/* 0x1870	     */		xor	%g5,%o5,%o3
/* 0x1874	     */		sub	%i4,%i0,%o4
/* 0x1878	     */		sra	%o4,31,%g2
/* 0x187c	     */		sub	%o3,%o5,%i3
/* 0x1880	     */		xor	%o4,%g2,%o0
/* 0x1884	     */		sra	%o2,0,%o3
/* 0x1888	     */		sra	%i1,0,%o2
/* 0x188c	     */		sub	%o0,%g2,%l7
/* 0x1890	     */		sub	%o1,%o2,%g2
/* 0x1894	     */		sra	%l7,0,%o0
/* 0x1898	     */		sra	%i3,0,%o4
/* 0x189c	     */		sub	%g3,%o2,%o1
/* 0x18a0	     */		sub	%g4,%o2,%g4
/* 0x18a4	     */		sub	%o3,%o2,%o3
/* 0x18a8	     */		srlx	%g4,63,%l4
/* 0x18ac	     */		srlx	%o3,63,%g3
/* 0x18b0	     */		sra	%l5,0,%g5
/* 0x18b4	     */		sub	%o0,%o2,%o0
/* 0x18b8	     */		sub	%o4,%o2,%o4
/* 0x18bc	     */		sra	%l3,0,%o5
/* 0x18c0	     */		srlx	%o0,63,%l7
/* 0x18c4	     */		srlx	%o4,63,%g4
/* 0x18c8	     */		srlx	%g2,63,%g2
/* 0x18cc	     */		srlx	%o1,63,%o1
/* 0x18d0	     */		sub	%g5,%o2,%g5
/* 0x18d4	     */		xor	%g3,1,%i3
/* 0x18d8	     */		srlx	%g5,63,%l5
/* 0x18dc	     */		xor	%g2,1,%o4
/* 0x18e0	     */		xor	%o1,1,%o0
/* 0x18e4	     */		sub	%o5,%o2,%o3
/* 0x18e8	     */		srl	%i1,0,%g3
/* 0x18ec	     */		and	%o0,%o4,%g5
/* 0x18f0	     */		srlx	%o3,63,%g2
/* 0x18f4	     */		sub	%g3,%o7,%o7
/* 0x18f8	     */		xor	%l5,1,%l3
/* 0x18fc	     */		xor	%l7,1,%o3
/* 0x1900	     */		xor	%l4,1,%o1
/* 0x1904	     */		srlx	%o7,63,%o0
/* 0x1908	     */		and	%l3,%o3,%l5
/* 0x190c	     */		and	%o0,%o1,%l4
/* 0x1910	     */		and	%l4,%g5,%o3
/* 0x1914	     */		xor	%g4,1,%o5
/* 0x1918	     */		and	%i3,%o5,%l3
/* 0x191c	     */		xor	%g2,1,%o4
/* 0x1920	     */		and	%o3,%l5,%g3
/* 0x1924	     */		and	%o4,1,%l7
/* 0x1928	     */		and	%g3,%l3,%g4
/* 0x192c	     */		andcc	%g4,%l7,%g0
/* 0x1930	     */		be,a,pn	%icc,.L77005038
/* 0x1934	     */		or	%g0,0,%l4

! Registers live out of .L77005044: 
! o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005044

			.L77005045:
/* 0x1938	 632 */		sub	%i5,%i0,%o7
/* 0x193c	     */		sra	%o7,31,%l4
/* 0x1940	     */		sub	%i5,%l2,%l5
/* 0x1944	     */		xor	%o7,%l4,%o5
/* 0x1948	     */		sra	%l5,31,%o4
/* 0x194c	     */		sub	%i5,%l6,%l7
/* 0x1950	     */		sethi	%hi(0x1000),%g1
/* 0x1954	     */		xor	%l5,%o4,%l3
/* 0x1958	     */		sra	%l7,31,%o7
/* 0x195c	     */		xor	%g1,-704,%g1
/* 0x1960	     */		sub	%l3,%o4,%g5
/* 0x1964	     */		xor	%l7,%o7,%o0
/* 0x1968	     */		add	%g1,%fp,%i3
/* 0x196c	     */		sub	%i5,%i2,%g3
/* 0x1970	     */		sub	%i5,%l1,%o3
/* 0x1974	     */		sub	%i5,%i3,%g4
/* 0x1978	     */		sub	%o5,%l4,%g2
/* 0x197c	     */		sub	%o0,%o7,%o1
/* 0x1980	     */		sub	%i0,%i3,%o4
/* 0x1984	     */		sra	%g3,31,%l5
/* 0x1988	     */		sra	%o3,31,%l3
/* 0x198c	     */		sra	%g4,31,%l4
/* 0x1990	     */		xor	%g3,%l5,%i3
/* 0x1994	     */		xor	%o3,%l3,%o0
/* 0x1998	     */		xor	%g4,%l4,%o5
/* 0x199c	     */		sub	%o0,%l3,%l7
/* 0x19a0	     */		sub	%i5,%l0,%o7
/* 0x19a4	     */		sub	%i3,%l5,%g3
/* 0x19a8	     */		sra	%o7,31,%i3
/* 0x19ac	     */		sra	%o4,31,%l3
/* 0x19b0	     */		sub	%o5,%l4,%g4
/* 0x19b4	     */		xor	%o7,%i3,%l4
/* 0x19b8	     */		xor	%o4,%l3,%o0
/* 0x19bc	     */		sub	%i0,%l6,%o5
/* 0x19c0	     */		sub	%l4,%i3,%l5
/* 0x19c4	     */		sra	%o5,31,%o4
/* 0x19c8	     */		sub	%o0,%l3,%i3
/* 0x19cc	     */		xor	%o5,%o4,%o7
/* 0x19d0	     */		sub	%o7,%o4,%l3
/* 0x19d4	     */		sub	%i0,%l2,%o3
/* 0x19d8	     */		sra	%g2,0,%o5
/* 0x19dc	     */		sra	%o3,31,%o0
/* 0x19e0	     */		sub	%o5,%o2,%o4
/* 0x19e4	     */		xor	%o3,%o0,%l4
/* 0x19e8	     */		srlx	%o4,63,%g2
/* 0x19ec	     */		xor	%g2,1,%o3
/* 0x19f0	     */		sra	%g5,0,%g2
/* 0x19f4	     */		sub	%g2,%o2,%g5
/* 0x19f8	     */		srlx	%g5,63,%g5
/* 0x19fc	     */		sub	%l4,%o0,%l4
/* 0x1a00	     */		xor	%g5,1,%o5
/* 0x1a04	     */		and	%o5,%o3,%o7
/* 0x1a08	     */		sra	%o1,0,%o0
/* 0x1a0c	     */		sub	%o0,%o2,%o3
/* 0x1a10	     */		srlx	%o3,63,%o1
/* 0x1a14	     */		xor	%o1,1,%o4
/* 0x1a18	     */		sra	%g4,0,%g4
/* 0x1a1c	     */		sub	%g4,%o2,%o1
/* 0x1a20	     */		srlx	%o1,63,%g4
/* 0x1a24	     */		xor	%g4,1,%o0
/* 0x1a28	     */		and	%o0,%o4,%g2
/* 0x1a2c	     */		and	%g2,%o7,%o1
/* 0x1a30	     */		sra	%l7,0,%o5
/* 0x1a34	     */		sra	%g3,0,%g3
/* 0x1a38	     */		sub	%g3,%o2,%o7
/* 0x1a3c	     */		sub	%o5,%o2,%o4
/* 0x1a40	     */		srlx	%o7,63,%g3
/* 0x1a44	     */		srlx	%o4,63,%l7
/* 0x1a48	     */		xor	%g3,1,%g5
/* 0x1a4c	     */		xor	%l7,1,%o3
/* 0x1a50	     */		and	%o3,%g5,%o5
/* 0x1a54	     */		sra	%l5,0,%g2
/* 0x1a58	     */		sra	%i3,0,%o0
/* 0x1a5c	     */		sub	%g2,%o2,%g5
/* 0x1a60	     */		sub	%o0,%o2,%o3
/* 0x1a64	     */		srlx	%g5,63,%l5
/* 0x1a68	     */		srlx	%o3,63,%i3
/* 0x1a6c	     */		xor	%l5,1,%g4
/* 0x1a70	     */		xor	%i3,1,%o7
/* 0x1a74	     */		sra	%l3,0,%o0
/* 0x1a78	     */		and	%o7,%g4,%o4
/* 0x1a7c	     */		sub	%o0,%o2,%g4
/* 0x1a80	     */		sra	%l4,0,%o0
/* 0x1a84	     */		sub	%o0,%o2,%g2
/* 0x1a88	     */		srlx	%g2,63,%l4
/* 0x1a8c	     */		srlx	%g4,63,%l3
/* 0x1a90	     */		xor	%l4,1,%g5
/* 0x1a94	     */		and	%o1,%o5,%g3
/* 0x1a98	     */		xor	%l3,1,%l7
/* 0x1a9c	     */		and	%g3,%o4,%o1
/* 0x1aa0	     */		and	%g5,%l7,%o3
/* 0x1aa4	     */		andcc	%o1,%o3,%g0
/* 0x1aa8	     */		be,a,pn	%icc,.L77005038
/* 0x1aac	     */		or	%g0,0,%l4

! Registers live out of .L77005045: 
! o2 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005045

			.L77005046:
/* 0x1ab0	 632 */		sethi	%hi(0x1000),%g1
/* 0x1ab4	     */		xor	%g1,-704,%g1
/* 0x1ab8	     */		add	%g1,%fp,%l7
/* 0x1abc	     */		sub	%i2,%l7,%o4
/* 0x1ac0	     */		sub	%i0,%l0,%o0
/* 0x1ac4	     */		sra	%o0,31,%g5
/* 0x1ac8	     */		sra	%o4,31,%l3
/* 0x1acc	     */		sub	%i0,%i2,%i3
/* 0x1ad0	     */		xor	%o0,%g5,%o5
/* 0x1ad4	     */		xor	%o4,%l3,%o3
/* 0x1ad8	     */		sra	%i3,31,%o7
/* 0x1adc	     */		sub	%i2,%l6,%g3
/* 0x1ae0	     */		sub	%o5,%g5,%l4
/* 0x1ae4	     */		xor	%i3,%o7,%l7
/* 0x1ae8	     */		sra	%g3,31,%o4
/* 0x1aec	     */		sub	%i0,%l1,%g2
/* 0x1af0	     */		sub	%o3,%l3,%l5
/* 0x1af4	     */		sra	%g2,31,%o1
/* 0x1af8	     */		xor	%g3,%o4,%o5
/* 0x1afc	     */		sub	%l7,%o7,%o0
/* 0x1b00	     */		sub	%i2,%l2,%g4
/* 0x1b04	     */		xor	%g2,%o1,%o7
/* 0x1b08	     */		sra	%g4,31,%i3
/* 0x1b0c	     */		sub	%i2,%l1,%o3
/* 0x1b10	     */		sub	%o5,%o4,%g3
/* 0x1b14	     */		sra	%o3,31,%o5
/* 0x1b18	     */		sub	%o7,%o1,%g5
/* 0x1b1c	     */		sub	%i2,%l0,%g2
/* 0x1b20	     */		xor	%g4,%i3,%g4
/* 0x1b24	     */		sub	%g4,%i3,%l7
/* 0x1b28	     */		xor	%o3,%o5,%o1
/* 0x1b2c	     */		sra	%g2,31,%l3
/* 0x1b30	     */		xor	%g2,%l3,%o7
/* 0x1b34	     */		sub	%o1,%o5,%i3
/* 0x1b38	     */		sub	%o7,%l3,%l3
/* 0x1b3c	     */		sra	%l4,0,%o1
/* 0x1b40	     */		sra	%l5,0,%o4
/* 0x1b44	     */		sra	%o0,0,%o0
/* 0x1b48	     */		sra	%g5,0,%g5
/* 0x1b4c	     */		sub	%o1,%o2,%o5
/* 0x1b50	     */		sub	%o4,%o2,%o3
/* 0x1b54	     */		sub	%o0,%o2,%o7
/* 0x1b58	     */		sub	%g5,%o2,%g2
/* 0x1b5c	     */		srlx	%o5,63,%l4
/* 0x1b60	     */		srlx	%o3,63,%l5
/* 0x1b64	     */		srlx	%o7,63,%o0
/* 0x1b68	     */		srlx	%g2,63,%g5
/* 0x1b6c	     */		xor	%l4,1,%g4
/* 0x1b70	     */		xor	%l5,1,%o4
/* 0x1b74	     */		xor	%o0,1,%o3
/* 0x1b78	     */		xor	%g5,1,%g2
/* 0x1b7c	     */		and	%o4,%g4,%o1
/* 0x1b80	     */		and	%o3,%g2,%o7
/* 0x1b84	     */		and	%o7,%o1,%g4
/* 0x1b88	     */		sra	%l7,0,%o5
/* 0x1b8c	     */		sra	%g3,0,%g3
/* 0x1b90	     */		sub	%g3,%o2,%o1
/* 0x1b94	     */		sub	%o5,%o2,%o4
/* 0x1b98	     */		srlx	%o1,63,%g3
/* 0x1b9c	     */		srlx	%o4,63,%l7
/* 0x1ba0	     */		xor	%g3,1,%l5
/* 0x1ba4	     */		xor	%l7,1,%o5
/* 0x1ba8	     */		and	%o5,%l5,%l4
/* 0x1bac	     */		and	%g4,%l4,%o1
/* 0x1bb0	     */		sra	%l3,0,%g4
/* 0x1bb4	     */		sub	%g4,%o2,%o3
/* 0x1bb8	     */		sra	%i3,0,%o4
/* 0x1bbc	     */		sub	%o4,%o2,%o2
/* 0x1bc0	     */		srlx	%o3,63,%l3
/* 0x1bc4	     */		srlx	%o2,63,%i3
/* 0x1bc8	     */		xor	%l3,1,%g5
/* 0x1bcc	     */		xor	%i3,1,%o0
/* 0x1bd0	     */		and	%g5,%o0,%g2
/* 0x1bd4	     */		andcc	%o1,%g2,%g0
/* 0x1bd8	     */		be,a,pn	%icc,.L77005038
/* 0x1bdc	     */		or	%g0,0,%l4

! Registers live out of .L77005046: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005046

			.L77005096:
/* 0x1be0	 632 */		sethi	%hi(0x1000),%g1
/* 0x1be4	     */		xor	%g1,-704,%g1
/* 0x1be8	     */		add	%g1,%fp,%l6
/* 0x1bec	     */		sethi	%hi(0x2400),%g1
/* 0x1bf0	     */		xor	%g1,-384,%g1
/* 0x1bf4	     */		add	%g1,%fp,%l5
/* 0x1bf8	     */		sethi	%hi(0x3800),%g1
/* 0x1bfc	     */		xor	%g1,-64,%g1
/* 0x1c00	     */		add	%g1,%fp,%l4
/* 0x1c04	     */		sethi	%hi(0x4800),%g1
/* 0x1c08	     */		xor	%g1,-768,%g1
/* 0x1c0c	     */		add	%i1,-1,%g2
/* 0x1c10	     */		or	%g0,0,%l7

!  633		      !            if (mask[i]) {

/* 0x1c14	 633 */		ldub	[%l0],%o5
/* 0x1c18	 632 */		add	%g1,%fp,%l3

! Registers live out of .L77005096: 
! g2 o5 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004717 .L77005096

			.L900000658:
/* 0x1c1c	 633 */		cmp	%o5,0
/* 0x1c20	     */		be,pn	%icc,.L77004717
/* 0x1c24	 632 */		add	%l7,1,%l7

! Registers live out of .L900000658: 
! g2 o5 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  634		      !               red[i]   = ~(red[i]   & rdest[i]);

                       
! predecessor blocks: .L900000658

			.L77004715:
/* 0x1c28	 634 */		ldub	[%i4],%o3
/* 0x1c2c	     */		ldub	[%l6],%o4

!  635		      !               green[i] = ~(green[i] & gdest[i]);

/* 0x1c30	 635 */		ldub	[%i5],%o7

!  636		      !               blue[i]  = ~(blue[i]  & bdest[i]);

/* 0x1c34	 636 */		ldub	[%i0],%l1

!  637		      !               alpha[i] = ~(alpha[i] & adest[i]);

/* 0x1c38	 637 */		ldub	[%i2],%o0
/* 0x1c3c	 635 */		ldub	[%l5],%o5
/* 0x1c40	 634 */		and	%o3,%o4,%i1
/* 0x1c44	 636 */		ldub	[%l4],%i3
/* 0x1c48	 635 */		and	%o7,%o5,%l2
/* 0x1c4c	 637 */		ldub	[%l3],%g5
/* 0x1c50	 636 */		and	%l1,%i3,%g3
/* 0x1c54	 634 */		xnor	%i1,0,%o2
/* 0x1c58	     */		stb	%o2,[%i4]
/* 0x1c5c	 637 */		and	%o0,%g5,%o4
/* 0x1c60	 635 */		xnor	%l2,0,%o1
/* 0x1c64	     */		stb	%o1,[%i5]
/* 0x1c68	 636 */		xnor	%g3,0,%g4
/* 0x1c6c	     */		stb	%g4,[%i0]
/* 0x1c70	 637 */		xnor	%o4,0,%o3
/* 0x1c74	     */		stb	%o3,[%i2]

! Registers live out of .L77004715: 
! g2 o5 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004715 .L900000658

			.L77004717:
/* 0x1c78	 632 */		cmp	%l7,%g2
/* 0x1c7c	     */		add	%l0,1,%l0
/* 0x1c80	     */		add	%l3,1,%l3
/* 0x1c84	     */		add	%l4,1,%l4
/* 0x1c88	     */		add	%l5,1,%l5
/* 0x1c8c	     */		add	%l6,1,%l6
/* 0x1c90	     */		add	%i2,1,%i2
/* 0x1c94	     */		add	%i0,1,%i0
/* 0x1c98	     */		add	%i5,1,%i5
/* 0x1c9c	     */		add	%i4,1,%i4
/* 0x1ca0	     */		ble,a,pt	%icc,.L900000658
/* 0x1ca4	 633 */		ldub	[%l0],%o5

! Registers live out of .L77004717: 
! g2 o5 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004717

			.L77005041:
/* 0x1ca8	 632 */		ba	.L77004840
/* 0x1cac	     */		nop

! Registers live out of .L77005041: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004872

			.L77005261:
/* 0x1cb0	 632 */		ld	[%fp+92],%i0
/* 0x1cb4	     */		ld	[%fp+96],%i2
/* 0x1cb8	     */		or	%g0,0,%l4

! Registers live out of .L77005261: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005044 .L77005045 .L77005046 .L77005261

			.L77005038:
/* 0x1cbc	 633 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77005038: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005038 .L77005040

			.L900000657:
/* 0x1cc0	 633 */		cmp	%o5,0
/* 0x1cc4	     */		be,pn	%icc,.L77005040
/* 0x1cc8	 634 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000657: 
! g1 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000657

			.L77005039:
/* 0x1ccc	 634 */		xor	%g1,-704,%g1
/* 0x1cd0	     */		add	%g1,%fp,%l3
/* 0x1cd4	     */		ldub	[%l4+%l3],%o2
/* 0x1cd8	     */		ldub	[%i4+%l4],%o5
/* 0x1cdc	     */		and	%o5,%o2,%i3
/* 0x1ce0	     */		xnor	%i3,0,%o7
/* 0x1ce4	     */		stb	%o7,[%i4+%l4]
/* 0x1ce8	 635 */		ldub	[%l4+%l6],%g5
/* 0x1cec	     */		ldub	[%i5+%l4],%o1
/* 0x1cf0	     */		and	%o1,%g5,%g2
/* 0x1cf4	     */		xnor	%g2,0,%o4
/* 0x1cf8	     */		stb	%o4,[%i5+%l4]
/* 0x1cfc	 636 */		ldub	[%l4+%l2],%o0
/* 0x1d00	     */		ldub	[%l4+%i0],%l5
/* 0x1d04	     */		and	%l5,%o0,%o3
/* 0x1d08	     */		xnor	%o3,0,%l3
/* 0x1d0c	     */		stb	%l3,[%l4+%i0]
/* 0x1d10	 637 */		ldub	[%l4+%l1],%g3
/* 0x1d14	     */		ldub	[%l4+%i2],%l7
/* 0x1d18	     */		and	%l7,%g3,%g4
/* 0x1d1c	     */		xnor	%g4,0,%o2
/* 0x1d20	     */		stb	%o2,[%l4+%i2]

! Registers live out of .L77005039: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005039 .L900000657

			.L77005040:
/* 0x1d24	 632 */		add	%l4,1,%l4
/* 0x1d28	     */		cmp	%l4,%i1
/* 0x1d2c	     */		bcs,a,pn	%icc,.L900000657
/* 0x1d30	 633 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77005040: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005040

			.L900000632:
/* 0x1d34	 632 */		ba	.L77004840
/* 0x1d38	     */		nop

! Registers live out of .L900000632: 
! sp fp i7 gsr 
! 
		
!  638		      !            }
!  639		      !         }
!  640		      !         break;
!  641		      !      case GL_OR:
!  642		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004723:
/* 0x1d3c	 642 */		cmp	%i1,0
/* 0x1d40	     */		bleu,pn	%icc,.L77004840
/* 0x1d44	     */		cmp	%i1,54

! Registers live out of .L77004723: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004723

			.L77004864:
/* 0x1d48	 642 */		bl,pn	%icc,.L77005247
/* 0x1d4c	     */		add	%o2,1022,%o7

! Registers live out of .L77004864: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004864

			.L77004950:
/* 0x1d50	 642 */		sub	%i4,%i5,%i2
/* 0x1d54	     */		sra	%i2,31,%o0
/* 0x1d58	     */		sub	%i4,%l6,%o5
/* 0x1d5c	     */		xor	%i2,%o0,%i0
/* 0x1d60	     */		sra	%o5,31,%g4
/* 0x1d64	     */		sub	%i4,%l1,%o3
/* 0x1d68	     */		sethi	%hi(0x1000),%g1
/* 0x1d6c	     */		sub	%i0,%o0,%l7
/* 0x1d70	     */		xor	%o5,%g4,%i3
/* 0x1d74	     */		sra	%o3,31,%i2
/* 0x1d78	     */		xor	%g1,-704,%g1
/* 0x1d7c	     */		xor	%o3,%i2,%o2
/* 0x1d80	     */		sub	%i3,%g4,%g3
/* 0x1d84	     */		sub	%i4,%l0,%i0
/* 0x1d88	     */		add	%g1,%fp,%g5
/* 0x1d8c	     */		sub	%i4,%g5,%o4
/* 0x1d90	     */		sub	%o2,%i2,%o0
/* 0x1d94	     */		sra	%i0,31,%i3
/* 0x1d98	     */		sra	%o4,31,%l3
/* 0x1d9c	     */		xor	%i0,%i3,%o5
/* 0x1da0	     */		xor	%o4,%l3,%o1
/* 0x1da4	     */		sub	%i4,%l2,%l5
/* 0x1da8	     */		sub	%o1,%l3,%l4
/* 0x1dac	     */		sra	%l5,31,%g5
/* 0x1db0	     */		xor	%l5,%g5,%g2
/* 0x1db4	     */		sub	%o5,%i3,%l3
/* 0x1db8	     */		sub	%g2,%g5,%l5
/* 0x1dbc	     */		sra	%l7,0,%o1
/* 0x1dc0	     */		sra	%g3,0,%g3
/* 0x1dc4	     */		sra	%l4,0,%g4
/* 0x1dc8	     */		ld	[%fp+96],%i2
/* 0x1dcc	     */		ld	[%fp+92],%i0
/* 0x1dd0	     */		sub	%i4,%i2,%o3
/* 0x1dd4	     */		sra	%o3,31,%i3
/* 0x1dd8	     */		sub	%i4,%i0,%o4
/* 0x1ddc	     */		sra	%o4,31,%g5
/* 0x1de0	     */		xor	%o3,%i3,%o5
/* 0x1de4	     */		xor	%o4,%g5,%g2
/* 0x1de8	     */		sra	%o0,0,%o3
/* 0x1dec	     */		sra	%i1,0,%o0
/* 0x1df0	     */		sub	%g2,%g5,%o2
/* 0x1df4	     */		sub	%o1,%o0,%g2
/* 0x1df8	     */		sub	%g3,%o0,%o1
/* 0x1dfc	     */		sra	%l5,0,%g5
/* 0x1e00	     */		sub	%g4,%o0,%g3
/* 0x1e04	     */		sub	%o5,%i3,%l7
/* 0x1e08	     */		sub	%g5,%o0,%g4
/* 0x1e0c	     */		srlx	%g2,63,%i3
/* 0x1e10	     */		srlx	%g4,63,%l5
/* 0x1e14	     */		sra	%o2,0,%o2
/* 0x1e18	     */		sra	%l7,0,%o4
/* 0x1e1c	     */		srlx	%g3,63,%l4
/* 0x1e20	     */		sub	%o2,%o0,%g4
/* 0x1e24	     */		sub	%o3,%o0,%g2
/* 0x1e28	     */		srlx	%g2,63,%g3
/* 0x1e2c	     */		sub	%o4,%o0,%o2
/* 0x1e30	     */		srlx	%o1,63,%o1
/* 0x1e34	     */		xor	%i3,1,%o4
/* 0x1e38	     */		xor	%o1,1,%g2
/* 0x1e3c	     */		sra	%l3,0,%o5
/* 0x1e40	     */		srlx	%g4,63,%l7
/* 0x1e44	     */		and	%g2,%o4,%g5
/* 0x1e48	     */		srlx	%o2,63,%g4
/* 0x1e4c	     */		sub	%o5,%o0,%o4
/* 0x1e50	     */		xor	%l5,1,%l3
/* 0x1e54	     */		xor	%l7,1,%o3
/* 0x1e58	     */		and	%l3,%o3,%l5
/* 0x1e5c	     */		xor	%g3,1,%o2
/* 0x1e60	     */		xor	%g4,1,%o5
/* 0x1e64	     */		and	%o2,%o5,%l3
/* 0x1e68	     */		srl	%i1,0,%o2
/* 0x1e6c	     */		sub	%o2,%o7,%o7
/* 0x1e70	     */		xor	%l4,1,%o1
/* 0x1e74	     */		srlx	%o7,63,%g2
/* 0x1e78	     */		and	%g2,%o1,%l4
/* 0x1e7c	     */		and	%l4,%g5,%o3
/* 0x1e80	     */		srlx	%o4,63,%i3
/* 0x1e84	     */		xor	%i3,1,%o4
/* 0x1e88	     */		and	%o3,%l5,%g3
/* 0x1e8c	     */		and	%o4,1,%l7
/* 0x1e90	     */		and	%g3,%l3,%g4
/* 0x1e94	     */		andcc	%g4,%l7,%g0
/* 0x1e98	     */		be,a,pn	%icc,.L77004944
/* 0x1e9c	     */		or	%g0,0,%l4

! Registers live out of .L77004950: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004950

			.L77004951:
/* 0x1ea0	 642 */		sub	%i5,%i0,%g2
/* 0x1ea4	     */		sethi	%hi(0x1000),%g1
/* 0x1ea8	     */		sra	%g2,31,%l4
/* 0x1eac	     */		xor	%g1,-704,%g1
/* 0x1eb0	     */		xor	%g2,%l4,%o7
/* 0x1eb4	     */		sub	%i5,%l2,%l5
/* 0x1eb8	     */		add	%g1,%fp,%o5
/* 0x1ebc	     */		sub	%i5,%o5,%o4
/* 0x1ec0	     */		sub	%o7,%l4,%g2
/* 0x1ec4	     */		sra	%l5,31,%o1
/* 0x1ec8	     */		sub	%i5,%l6,%l7
/* 0x1ecc	     */		xor	%l5,%o1,%l3
/* 0x1ed0	     */		sra	%l7,31,%o7
/* 0x1ed4	     */		sra	%o4,31,%l4
/* 0x1ed8	     */		sub	%l3,%o1,%g5
/* 0x1edc	     */		xor	%l7,%o7,%i3
/* 0x1ee0	     */		xor	%o4,%l4,%l5
/* 0x1ee4	     */		sub	%i5,%i2,%g3
/* 0x1ee8	     */		sub	%i0,%o5,%o4
/* 0x1eec	     */		sra	%g3,31,%l3
/* 0x1ef0	     */		sub	%i5,%l1,%o3
/* 0x1ef4	     */		sub	%i3,%o7,%o2
/* 0x1ef8	     */		xor	%g3,%l3,%o5
/* 0x1efc	     */		sra	%o3,31,%i3
/* 0x1f00	     */		xor	%o3,%i3,%o1
/* 0x1f04	     */		sub	%o5,%l3,%g3
/* 0x1f08	     */		sub	%o1,%i3,%l7
/* 0x1f0c	     */		sra	%o4,31,%l3
/* 0x1f10	     */		sub	%l5,%l4,%g4
/* 0x1f14	     */		sub	%i5,%l0,%o7
/* 0x1f18	     */		sra	%o7,31,%l4
/* 0x1f1c	     */		xor	%o4,%l3,%o1
/* 0x1f20	     */		sub	%o1,%l3,%i3
/* 0x1f24	     */		sub	%i0,%l6,%o5
/* 0x1f28	     */		sub	%i0,%l2,%o3
/* 0x1f2c	     */		xor	%o7,%l4,%l5
/* 0x1f30	     */		sra	%o5,31,%o4
/* 0x1f34	     */		sra	%o3,31,%o1
/* 0x1f38	     */		sub	%l5,%l4,%l5
/* 0x1f3c	     */		xor	%o5,%o4,%o7
/* 0x1f40	     */		xor	%o3,%o1,%l4
/* 0x1f44	     */		sub	%o7,%o4,%l3
/* 0x1f48	     */		sra	%g2,0,%o3
/* 0x1f4c	     */		sub	%o3,%o0,%o7
/* 0x1f50	     */		srlx	%o7,63,%g2
/* 0x1f54	     */		xor	%g2,1,%o3
/* 0x1f58	     */		sra	%g5,0,%o5
/* 0x1f5c	     */		sra	%o2,0,%o2
/* 0x1f60	     */		sra	%g4,0,%g4
/* 0x1f64	     */		sub	%o2,%o0,%o4
/* 0x1f68	     */		sub	%g4,%o0,%g2
/* 0x1f6c	     */		sub	%o5,%o0,%g5
/* 0x1f70	     */		sub	%l4,%o1,%l4
/* 0x1f74	     */		srlx	%o4,63,%o2
/* 0x1f78	     */		srlx	%g2,63,%g4
/* 0x1f7c	     */		srlx	%g5,63,%g5
/* 0x1f80	     */		xor	%g5,1,%o5
/* 0x1f84	     */		xor	%o2,1,%o4
/* 0x1f88	     */		xor	%g4,1,%o1
/* 0x1f8c	     */		and	%o5,%o3,%o7
/* 0x1f90	     */		and	%o1,%o4,%g2
/* 0x1f94	     */		and	%g2,%o7,%o5
/* 0x1f98	     */		sra	%l7,0,%o3
/* 0x1f9c	     */		sra	%g3,0,%g3
/* 0x1fa0	     */		sub	%g3,%o0,%o1
/* 0x1fa4	     */		sub	%o3,%o0,%o7
/* 0x1fa8	     */		srlx	%o1,63,%g3
/* 0x1fac	     */		srlx	%o7,63,%l7
/* 0x1fb0	     */		xor	%g3,1,%g5
/* 0x1fb4	     */		xor	%l7,1,%o3
/* 0x1fb8	     */		and	%o3,%g5,%o2
/* 0x1fbc	     */		and	%o5,%o2,%o1
/* 0x1fc0	     */		sra	%l5,0,%o5
/* 0x1fc4	     */		sra	%i3,0,%o2
/* 0x1fc8	     */		sub	%o5,%o0,%g5
/* 0x1fcc	     */		sub	%o2,%o0,%o4
/* 0x1fd0	     */		srlx	%g5,63,%l5
/* 0x1fd4	     */		srlx	%o4,63,%i3
/* 0x1fd8	     */		xor	%l5,1,%g4
/* 0x1fdc	     */		xor	%i3,1,%o7
/* 0x1fe0	     */		and	%o7,%g4,%o4
/* 0x1fe4	     */		and	%o1,%o4,%o2
/* 0x1fe8	     */		sra	%l3,0,%o1
/* 0x1fec	     */		sra	%l4,0,%g2
/* 0x1ff0	     */		sub	%o1,%o0,%o5
/* 0x1ff4	     */		sub	%g2,%o0,%g3
/* 0x1ff8	     */		srlx	%g3,63,%l4
/* 0x1ffc	     */		srlx	%o5,63,%l3
/* 0x2000	     */		xor	%l4,1,%g5
/* 0x2004	     */		xor	%l3,1,%l7
/* 0x2008	     */		and	%g5,%l7,%o3
/* 0x200c	     */		andcc	%o2,%o3,%g0
/* 0x2010	     */		be,a,pn	%icc,.L77004944
/* 0x2014	     */		or	%g0,0,%l4

! Registers live out of .L77004951: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004951

			.L77004952:
/* 0x2018	 642 */		sethi	%hi(0x1000),%g1
/* 0x201c	     */		xor	%g1,-704,%g1
/* 0x2020	     */		add	%g1,%fp,%g2
/* 0x2024	     */		sub	%i2,%g2,%g5
/* 0x2028	     */		sra	%g5,31,%o2
/* 0x202c	     */		sub	%i0,%l0,%o5
/* 0x2030	     */		sub	%i0,%i2,%l7
/* 0x2034	     */		sra	%o5,31,%o7
/* 0x2038	     */		xor	%g5,%o2,%o1
/* 0x203c	     */		sra	%l7,31,%o3
/* 0x2040	     */		xor	%o5,%o7,%i3
/* 0x2044	     */		sub	%o1,%o2,%l5
/* 0x2048	     */		xor	%l7,%o3,%o4
/* 0x204c	     */		sub	%i0,%l1,%g2
/* 0x2050	     */		sra	%g2,31,%o5
/* 0x2054	     */		sub	%i2,%l6,%g3
/* 0x2058	     */		sub	%o4,%o3,%o2
/* 0x205c	     */		sub	%i3,%o7,%l4
/* 0x2060	     */		xor	%g2,%o5,%o3
/* 0x2064	     */		sra	%g3,31,%o1
/* 0x2068	     */		xor	%g3,%o1,%o7
/* 0x206c	     */		sub	%o3,%o5,%g5
/* 0x2070	     */		sub	%i2,%l0,%g2
/* 0x2074	     */		sub	%i2,%l1,%o3
/* 0x2078	     */		sub	%o7,%o1,%g3
/* 0x207c	     */		sra	%g2,31,%l3
/* 0x2080	     */		xor	%g2,%l3,%i3
/* 0x2084	     */		sra	%o3,31,%o7
/* 0x2088	     */		sub	%i2,%l2,%g4
/* 0x208c	     */		sra	%g4,31,%o4
/* 0x2090	     */		xor	%o3,%o7,%o5
/* 0x2094	     */		sub	%i3,%l3,%l3
/* 0x2098	     */		sub	%o5,%o7,%i3
/* 0x209c	     */		xor	%g4,%o4,%g4
/* 0x20a0	     */		sub	%g4,%o4,%l7
/* 0x20a4	     */		sra	%l4,0,%o5
/* 0x20a8	     */		sra	%l5,0,%o1
/* 0x20ac	     */		sra	%o2,0,%o2
/* 0x20b0	     */		sra	%g5,0,%g5
/* 0x20b4	     */		sub	%o5,%o0,%o7
/* 0x20b8	     */		sub	%o1,%o0,%o4
/* 0x20bc	     */		sub	%o2,%o0,%o3
/* 0x20c0	     */		sub	%g5,%o0,%g2
/* 0x20c4	     */		srlx	%o7,63,%l4
/* 0x20c8	     */		srlx	%o4,63,%l5
/* 0x20cc	     */		srlx	%o3,63,%o2
/* 0x20d0	     */		srlx	%g2,63,%g5
/* 0x20d4	     */		xor	%l4,1,%g4
/* 0x20d8	     */		xor	%l5,1,%o1
/* 0x20dc	     */		xor	%o2,1,%o3
/* 0x20e0	     */		xor	%g5,1,%o4
/* 0x20e4	     */		and	%o1,%g4,%o5
/* 0x20e8	     */		and	%o3,%o4,%g2
/* 0x20ec	     */		and	%g2,%o5,%g4
/* 0x20f0	     */		sra	%l7,0,%o7
/* 0x20f4	     */		sra	%g3,0,%g3
/* 0x20f8	     */		sub	%o7,%o0,%o1
/* 0x20fc	     */		sub	%g3,%o0,%o5
/* 0x2100	     */		srlx	%o1,63,%l7
/* 0x2104	     */		srlx	%o5,63,%g3
/* 0x2108	     */		xor	%g3,1,%l5
/* 0x210c	     */		xor	%l7,1,%o7
/* 0x2110	     */		and	%o7,%l5,%l4
/* 0x2114	     */		and	%g4,%l4,%o3
/* 0x2118	     */		sra	%l3,0,%g4
/* 0x211c	     */		sub	%g4,%o0,%o4
/* 0x2120	     */		sra	%i3,0,%o1
/* 0x2124	     */		sub	%o1,%o0,%o0
/* 0x2128	     */		srlx	%o4,63,%l3
/* 0x212c	     */		srlx	%o0,63,%i3
/* 0x2130	     */		xor	%l3,1,%g5
/* 0x2134	     */		xor	%i3,1,%o2
/* 0x2138	     */		and	%g5,%o2,%o4
/* 0x213c	     */		andcc	%o3,%o4,%g0
/* 0x2140	     */		be,a,pn	%icc,.L77004944
/* 0x2144	     */		or	%g0,0,%l4

! Registers live out of .L77004952: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004952

			.L77005103:
/* 0x2148	 642 */		sethi	%hi(0x1000),%g1
/* 0x214c	     */		xor	%g1,-704,%g1
/* 0x2150	     */		add	%g1,%fp,%g4
/* 0x2154	     */		sethi	%hi(0x2400),%g1
/* 0x2158	     */		xor	%g1,-384,%g1
/* 0x215c	     */		add	%g1,%fp,%g3
/* 0x2160	     */		sethi	%hi(0x3800),%g1
/* 0x2164	     */		xor	%g1,-64,%g1
/* 0x2168	     */		add	%g1,%fp,%g2
/* 0x216c	     */		sethi	%hi(0x4800),%g1
/* 0x2170	     */		xor	%g1,-768,%g1
/* 0x2174	     */		add	%i1,-1,%o0
/* 0x2178	     */		or	%g0,0,%g5

!  643		      !            if (mask[i]) {

/* 0x217c	 643 */		ldub	[%l0],%o1
/* 0x2180	 642 */		add	%g1,%fp,%l7

! Registers live out of .L77005103: 
! g2 g3 g4 g5 o0 o1 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004731 .L77005103

			.L900000656:
/* 0x2184	 643 */		cmp	%o1,0
/* 0x2188	     */		be,pn	%icc,.L77004731
/* 0x218c	 642 */		add	%g5,1,%g5

! Registers live out of .L900000656: 
! g2 g3 g4 g5 o0 o1 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  644		      !               red[i]   |= rdest[i];

                       
! predecessor blocks: .L900000656

			.L77004729:
/* 0x2190	 644 */		ldub	[%i4],%o5

!  645		      !               green[i] |= gdest[i];

/* 0x2194	 645 */		ldub	[%i5],%l1

!  646		      !               blue[i]  |= bdest[i];

/* 0x2198	 646 */		ldub	[%i0],%l3

!  647		      !               alpha[i] |= adest[i];

/* 0x219c	 647 */		ldub	[%i2],%l6
/* 0x21a0	 644 */		ldub	[%g4],%o3
/* 0x21a4	 645 */		ldub	[%g3],%i3
/* 0x21a8	 646 */		ldub	[%g2],%i1
/* 0x21ac	 647 */		ldub	[%l7],%l5
/* 0x21b0	 644 */		or	%o5,%o3,%o7
/* 0x21b4	     */		stb	%o7,[%i4]
/* 0x21b8	 645 */		or	%l1,%i3,%l2
/* 0x21bc	     */		stb	%l2,[%i5]
/* 0x21c0	 646 */		or	%l3,%i1,%l4
/* 0x21c4	     */		stb	%l4,[%i0]
/* 0x21c8	 647 */		or	%l6,%l5,%o2
/* 0x21cc	     */		stb	%o2,[%i2]

! Registers live out of .L77004729: 
! g2 g3 g4 g5 o0 o1 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004729 .L900000656

			.L77004731:
/* 0x21d0	 642 */		cmp	%g5,%o0
/* 0x21d4	     */		add	%l0,1,%l0
/* 0x21d8	     */		add	%l7,1,%l7
/* 0x21dc	     */		add	%g2,1,%g2
/* 0x21e0	     */		add	%g3,1,%g3
/* 0x21e4	     */		add	%g4,1,%g4
/* 0x21e8	     */		add	%i2,1,%i2
/* 0x21ec	     */		add	%i0,1,%i0
/* 0x21f0	     */		add	%i5,1,%i5
/* 0x21f4	     */		add	%i4,1,%i4
/* 0x21f8	     */		ble,a,pt	%icc,.L900000656
/* 0x21fc	 643 */		ldub	[%l0],%o1

! Registers live out of .L77004731: 
! g2 g3 g4 g5 o0 o1 sp l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004731

			.L77004947:
/* 0x2200	 642 */		ba	.L77004840
/* 0x2204	     */		nop

! Registers live out of .L77004947: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004864

			.L77005247:
/* 0x2208	 642 */		ld	[%fp+92],%i0
/* 0x220c	     */		ld	[%fp+96],%i2
/* 0x2210	     */		or	%g0,0,%l4

! Registers live out of .L77005247: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004950 .L77004951 .L77004952 .L77005247

			.L77004944:
/* 0x2214	 643 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004944: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004944 .L77004946

			.L900000655:
/* 0x2218	 643 */		cmp	%g3,0
/* 0x221c	     */		be,pn	%icc,.L77004946
/* 0x2220	 644 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000655: 
! g1 g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000655

			.L77004945:
/* 0x2224	 644 */		xor	%g1,-704,%g1
/* 0x2228	     */		add	%g1,%fp,%g4
/* 0x222c	     */		ldub	[%l4+%g4],%o0
/* 0x2230	     */		ldub	[%i4+%l4],%o5
/* 0x2234	     */		or	%o5,%o0,%o2
/* 0x2238	     */		stb	%o2,[%i4+%l4]
/* 0x223c	 645 */		ldub	[%l4+%l6],%o7
/* 0x2240	     */		ldub	[%i5+%l4],%g5
/* 0x2244	     */		or	%g5,%o7,%o1
/* 0x2248	     */		stb	%o1,[%i5+%l4]
/* 0x224c	 646 */		ldub	[%l4+%l2],%i3
/* 0x2250	     */		ldub	[%l4+%i0],%o4
/* 0x2254	     */		or	%o4,%i3,%g2
/* 0x2258	     */		stb	%g2,[%l4+%i0]
/* 0x225c	 647 */		ldub	[%l4+%l1],%l5
/* 0x2260	     */		ldub	[%l4+%i2],%o3
/* 0x2264	     */		or	%o3,%l5,%l3
/* 0x2268	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004945: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004945 .L900000655

			.L77004946:
/* 0x226c	 642 */		add	%l4,1,%l4
/* 0x2270	     */		cmp	%l4,%i1
/* 0x2274	     */		bcs,a,pn	%icc,.L900000655
/* 0x2278	 643 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004946: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004946

			.L900000631:
/* 0x227c	 642 */		ba	.L77004840
/* 0x2280	     */		nop

! Registers live out of .L900000631: 
! sp fp i7 gsr 
! 
		
!  648		      !            }
!  649		      !         }
!  650		      !         break;
!  651		      !      case GL_NOR:
!  652		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004737:
/* 0x2284	 652 */		cmp	%i1,0
/* 0x2288	     */		bleu,pn	%icc,.L77004840
/* 0x228c	     */		cmp	%i1,54

! Registers live out of .L77004737: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004737

			.L77004863:
/* 0x2290	 652 */		bl,pn	%icc,.L77005249
/* 0x2294	     */		add	%o2,1022,%o7

! Registers live out of .L77004863: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004863

			.L77004938:
/* 0x2298	 652 */		sub	%i4,%i5,%i2
/* 0x229c	     */		sethi	%hi(0x1000),%g1
/* 0x22a0	     */		sra	%i2,31,%o0
/* 0x22a4	     */		sub	%i4,%l6,%o2
/* 0x22a8	     */		xor	%g1,-704,%g1
/* 0x22ac	     */		xor	%i2,%o0,%i0
/* 0x22b0	     */		sra	%o2,31,%g4
/* 0x22b4	     */		sub	%i4,%l1,%o3
/* 0x22b8	     */		add	%g1,%fp,%g3
/* 0x22bc	     */		sub	%i4,%g3,%o1
/* 0x22c0	     */		sub	%i0,%o0,%l7
/* 0x22c4	     */		xor	%o2,%g4,%i3
/* 0x22c8	     */		sra	%o3,31,%i2
/* 0x22cc	     */		xor	%o3,%i2,%o5
/* 0x22d0	     */		sub	%i3,%g4,%g3
/* 0x22d4	     */		sub	%i4,%l0,%i0
/* 0x22d8	     */		sub	%o5,%i2,%o0
/* 0x22dc	     */		sra	%i0,31,%i3
/* 0x22e0	     */		sra	%o1,31,%l3
/* 0x22e4	     */		xor	%i0,%i3,%o2
/* 0x22e8	     */		xor	%o1,%l3,%o4
/* 0x22ec	     */		sub	%i4,%l2,%l5
/* 0x22f0	     */		sub	%o4,%l3,%l4
/* 0x22f4	     */		sra	%l5,31,%g5
/* 0x22f8	     */		xor	%l5,%g5,%g2
/* 0x22fc	     */		sub	%o2,%i3,%l3
/* 0x2300	     */		sub	%g2,%g5,%l5
/* 0x2304	     */		sra	%l7,0,%o1
/* 0x2308	     */		sra	%l4,0,%g4
/* 0x230c	     */		sra	%g3,0,%g3
/* 0x2310	     */		ld	[%fp+96],%i2
/* 0x2314	     */		ld	[%fp+92],%i0
/* 0x2318	     */		sub	%i4,%i2,%o3
/* 0x231c	     */		sra	%o3,31,%i3
/* 0x2320	     */		sub	%i4,%i0,%o4
/* 0x2324	     */		sra	%o4,31,%g5
/* 0x2328	     */		xor	%o3,%i3,%o5
/* 0x232c	     */		xor	%o4,%g5,%g2
/* 0x2330	     */		sra	%o0,0,%o3
/* 0x2334	     */		sra	%i1,0,%o0
/* 0x2338	     */		sub	%g2,%g5,%o2
/* 0x233c	     */		sra	%l5,0,%g5
/* 0x2340	     */		sub	%o1,%o0,%g2
/* 0x2344	     */		sub	%o5,%i3,%l7
/* 0x2348	     */		sub	%g5,%o0,%o1
/* 0x234c	     */		srlx	%g2,63,%i3
/* 0x2350	     */		srlx	%o1,63,%l5
/* 0x2354	     */		sra	%o2,0,%o2
/* 0x2358	     */		sra	%l7,0,%o4
/* 0x235c	     */		sra	%l3,0,%o5
/* 0x2360	     */		sub	%g4,%o0,%g2
/* 0x2364	     */		sub	%o2,%o0,%o1
/* 0x2368	     */		sub	%g3,%o0,%g3
/* 0x236c	     */		sub	%o4,%o0,%o4
/* 0x2370	     */		srlx	%g3,63,%l3
/* 0x2374	     */		srlx	%o1,63,%o2
/* 0x2378	     */		sub	%o3,%o0,%g5
/* 0x237c	     */		srlx	%o4,63,%g4
/* 0x2380	     */		srlx	%g5,63,%g3
/* 0x2384	     */		xor	%i3,1,%o1
/* 0x2388	     */		xor	%l3,1,%o4
/* 0x238c	     */		xor	%g4,1,%l7
/* 0x2390	     */		srlx	%g2,63,%l4
/* 0x2394	     */		and	%o4,%o1,%g5
/* 0x2398	     */		srl	%i1,0,%g4
/* 0x239c	     */		xor	%l4,1,%o1
/* 0x23a0	     */		sub	%o5,%o0,%g2
/* 0x23a4	     */		sub	%g4,%o7,%o7
/* 0x23a8	     */		xor	%l5,1,%o5
/* 0x23ac	     */		xor	%o2,1,%o3
/* 0x23b0	     */		srlx	%o7,63,%l4
/* 0x23b4	     */		and	%o5,%o3,%l5
/* 0x23b8	     */		and	%l4,%o1,%o2
/* 0x23bc	     */		xor	%g3,1,%i3
/* 0x23c0	     */		srlx	%g2,63,%g2
/* 0x23c4	     */		and	%o2,%g5,%o3
/* 0x23c8	     */		and	%i3,%l7,%l3
/* 0x23cc	     */		xor	%g2,1,%o4
/* 0x23d0	     */		and	%o3,%l5,%o5
/* 0x23d4	     */		and	%o4,1,%g3
/* 0x23d8	     */		and	%o5,%l3,%g4
/* 0x23dc	     */		andcc	%g4,%g3,%g0
/* 0x23e0	     */		be,a,pn	%icc,.L77004932
/* 0x23e4	     */		or	%g0,0,%l4

! Registers live out of .L77004938: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004938

			.L77004939:
/* 0x23e8	 652 */		sub	%i5,%i0,%o5
/* 0x23ec	     */		sra	%o5,31,%o7
/* 0x23f0	     */		sub	%i5,%l2,%l5
/* 0x23f4	     */		sethi	%hi(0x1000),%g1
/* 0x23f8	     */		sra	%l5,31,%l4
/* 0x23fc	     */		sub	%i5,%l6,%l7
/* 0x2400	     */		xor	%o5,%o7,%g2
/* 0x2404	     */		xor	%g1,-704,%g1
/* 0x2408	     */		xor	%l5,%l4,%l3
/* 0x240c	     */		sra	%l7,31,%o5
/* 0x2410	     */		add	%g1,%fp,%o4
/* 0x2414	     */		sub	%i5,%o4,%g3
/* 0x2418	     */		sub	%l3,%l4,%g5
/* 0x241c	     */		xor	%l7,%o5,%o1
/* 0x2420	     */		sub	%i5,%i2,%i3
/* 0x2424	     */		sub	%o1,%o5,%o2
/* 0x2428	     */		sra	%g3,31,%l5
/* 0x242c	     */		sra	%i3,31,%l3
/* 0x2430	     */		sub	%g2,%o7,%g2
/* 0x2434	     */		xor	%g3,%l5,%o7
/* 0x2438	     */		xor	%i3,%l3,%o1
/* 0x243c	     */		sub	%i5,%l1,%o3
/* 0x2440	     */		sra	%o3,31,%i3
/* 0x2444	     */		sub	%o7,%l5,%g4
/* 0x2448	     */		sub	%i5,%l0,%l4
/* 0x244c	     */		sub	%i0,%o4,%o4
/* 0x2450	     */		sub	%o1,%l3,%g3
/* 0x2454	     */		sra	%o4,31,%l3
/* 0x2458	     */		xor	%o3,%i3,%l7
/* 0x245c	     */		sra	%l4,31,%l5
/* 0x2460	     */		xor	%l4,%l5,%o7
/* 0x2464	     */		xor	%o4,%l3,%o1
/* 0x2468	     */		sub	%l7,%i3,%l7
/* 0x246c	     */		sub	%i0,%l6,%o5
/* 0x2470	     */		sub	%o1,%l3,%i3
/* 0x2474	     */		sra	%o5,31,%l4
/* 0x2478	     */		sub	%i0,%l2,%o3
/* 0x247c	     */		xor	%o5,%l4,%o4
/* 0x2480	     */		sra	%o3,31,%o1
/* 0x2484	     */		sub	%o7,%l5,%l5
/* 0x2488	     */		sub	%o4,%l4,%l3
/* 0x248c	     */		xor	%o3,%o1,%o7
/* 0x2490	     */		sub	%o7,%o1,%l4
/* 0x2494	     */		sra	%g5,0,%o7
/* 0x2498	     */		sra	%g2,0,%g2
/* 0x249c	     */		sub	%g2,%o0,%o1
/* 0x24a0	     */		sub	%o7,%o0,%o5
/* 0x24a4	     */		srlx	%o1,63,%g2
/* 0x24a8	     */		srlx	%o5,63,%g5
/* 0x24ac	     */		xor	%g2,1,%o3
/* 0x24b0	     */		xor	%g5,1,%o5
/* 0x24b4	     */		and	%o5,%o3,%o7
/* 0x24b8	     */		sra	%o2,0,%o3
/* 0x24bc	     */		sra	%g4,0,%g4
/* 0x24c0	     */		sub	%g4,%o0,%o4
/* 0x24c4	     */		sub	%o3,%o0,%o2
/* 0x24c8	     */		srlx	%o4,63,%g4
/* 0x24cc	     */		srlx	%o2,63,%o2
/* 0x24d0	     */		xor	%o2,1,%o1
/* 0x24d4	     */		xor	%g4,1,%o4
/* 0x24d8	     */		and	%o4,%o1,%g2
/* 0x24dc	     */		and	%g2,%o7,%o5
/* 0x24e0	     */		sra	%l7,0,%g2
/* 0x24e4	     */		sra	%g3,0,%g3
/* 0x24e8	     */		sub	%g3,%o0,%g5
/* 0x24ec	     */		sub	%g2,%o0,%o1
/* 0x24f0	     */		srlx	%g5,63,%g3
/* 0x24f4	     */		srlx	%o1,63,%l7
/* 0x24f8	     */		xor	%g3,1,%g5
/* 0x24fc	     */		xor	%l7,1,%o3
/* 0x2500	     */		and	%o3,%g5,%o2
/* 0x2504	     */		and	%o5,%o2,%o4
/* 0x2508	     */		sra	%l5,0,%o7
/* 0x250c	     */		sra	%i3,0,%o3
/* 0x2510	     */		sub	%o7,%o0,%o5
/* 0x2514	     */		sub	%o3,%o0,%o2
/* 0x2518	     */		srlx	%o5,63,%l5
/* 0x251c	     */		srlx	%o2,63,%i3
/* 0x2520	     */		xor	%i3,1,%o7
/* 0x2524	     */		xor	%l5,1,%g4
/* 0x2528	     */		and	%o7,%g4,%o1
/* 0x252c	     */		sra	%l3,0,%o7
/* 0x2530	     */		sra	%l4,0,%g2
/* 0x2534	     */		sub	%o7,%o0,%g5
/* 0x2538	     */		sub	%g2,%o0,%g3
/* 0x253c	     */		srlx	%g3,63,%l4
/* 0x2540	     */		srlx	%g5,63,%l3
/* 0x2544	     */		xor	%l4,1,%g5
/* 0x2548	     */		xor	%l3,1,%l7
/* 0x254c	     */		and	%o4,%o1,%o5
/* 0x2550	     */		and	%g5,%l7,%o3
/* 0x2554	     */		andcc	%o5,%o3,%g0
/* 0x2558	     */		be,a,pn	%icc,.L77004932
/* 0x255c	     */		or	%g0,0,%l4

! Registers live out of .L77004939: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004939

			.L77004940:
/* 0x2560	 652 */		sethi	%hi(0x1000),%g1
/* 0x2564	     */		xor	%g1,-704,%g1
/* 0x2568	     */		sub	%i0,%l0,%o5
/* 0x256c	     */		add	%g1,%fp,%o3
/* 0x2570	     */		sub	%i2,%o3,%g5
/* 0x2574	     */		sra	%o5,31,%o7
/* 0x2578	     */		sub	%i0,%i2,%l7
/* 0x257c	     */		xor	%o5,%o7,%o2
/* 0x2580	     */		sra	%g5,31,%i3
/* 0x2584	     */		sra	%l7,31,%o3
/* 0x2588	     */		sub	%o2,%o7,%l4
/* 0x258c	     */		xor	%g5,%i3,%o1
/* 0x2590	     */		xor	%l7,%o3,%o4
/* 0x2594	     */		sub	%i0,%l1,%g2
/* 0x2598	     */		sub	%o1,%i3,%l5
/* 0x259c	     */		sra	%g2,31,%o5
/* 0x25a0	     */		sub	%i2,%l6,%g3
/* 0x25a4	     */		sub	%o4,%o3,%o2
/* 0x25a8	     */		xor	%g2,%o5,%o3
/* 0x25ac	     */		sra	%g3,31,%o1
/* 0x25b0	     */		xor	%g3,%o1,%o7
/* 0x25b4	     */		sub	%o3,%o5,%g5
/* 0x25b8	     */		sub	%i2,%l0,%g2
/* 0x25bc	     */		sub	%i2,%l1,%o3
/* 0x25c0	     */		sub	%o7,%o1,%g3
/* 0x25c4	     */		sra	%g2,31,%l3
/* 0x25c8	     */		xor	%g2,%l3,%i3
/* 0x25cc	     */		sra	%o3,31,%o7
/* 0x25d0	     */		sub	%i2,%l2,%g4
/* 0x25d4	     */		sra	%g4,31,%o4
/* 0x25d8	     */		xor	%o3,%o7,%o5
/* 0x25dc	     */		sub	%i3,%l3,%l3
/* 0x25e0	     */		sub	%o5,%o7,%i3
/* 0x25e4	     */		xor	%g4,%o4,%g4
/* 0x25e8	     */		sub	%g4,%o4,%l7
/* 0x25ec	     */		sra	%l4,0,%o5
/* 0x25f0	     */		sra	%l5,0,%o1
/* 0x25f4	     */		sra	%o2,0,%o2
/* 0x25f8	     */		sra	%g5,0,%g5
/* 0x25fc	     */		sub	%o5,%o0,%o7
/* 0x2600	     */		sub	%o1,%o0,%o4
/* 0x2604	     */		sub	%o2,%o0,%o3
/* 0x2608	     */		sub	%g5,%o0,%g2
/* 0x260c	     */		srlx	%o7,63,%l4
/* 0x2610	     */		srlx	%o4,63,%l5
/* 0x2614	     */		srlx	%o3,63,%o2
/* 0x2618	     */		srlx	%g2,63,%g5
/* 0x261c	     */		xor	%l4,1,%g4
/* 0x2620	     */		xor	%l5,1,%o1
/* 0x2624	     */		xor	%o2,1,%o3
/* 0x2628	     */		xor	%g5,1,%o4
/* 0x262c	     */		and	%o1,%g4,%o5
/* 0x2630	     */		and	%o3,%o4,%g2
/* 0x2634	     */		and	%g2,%o5,%g4
/* 0x2638	     */		sra	%l7,0,%o7
/* 0x263c	     */		sra	%g3,0,%g3
/* 0x2640	     */		sub	%o7,%o0,%o1
/* 0x2644	     */		sub	%g3,%o0,%o5
/* 0x2648	     */		srlx	%o1,63,%l7
/* 0x264c	     */		srlx	%o5,63,%g3
/* 0x2650	     */		xor	%g3,1,%l5
/* 0x2654	     */		xor	%l7,1,%o7
/* 0x2658	     */		and	%o7,%l5,%l4
/* 0x265c	     */		and	%g4,%l4,%o3
/* 0x2660	     */		sra	%l3,0,%g4
/* 0x2664	     */		sub	%g4,%o0,%o4
/* 0x2668	     */		sra	%i3,0,%o1
/* 0x266c	     */		sub	%o1,%o0,%o0
/* 0x2670	     */		srlx	%o4,63,%l3
/* 0x2674	     */		srlx	%o0,63,%i3
/* 0x2678	     */		xor	%l3,1,%g5
/* 0x267c	     */		xor	%i3,1,%o2
/* 0x2680	     */		and	%g5,%o2,%o4
/* 0x2684	     */		andcc	%o3,%o4,%g0
/* 0x2688	     */		be,a,pn	%icc,.L77004932
/* 0x268c	     */		or	%g0,0,%l4

! Registers live out of .L77004940: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004940

			.L77005102:
/* 0x2690	 652 */		sethi	%hi(0x1000),%g1
/* 0x2694	     */		xor	%g1,-704,%g1
/* 0x2698	     */		add	%g1,%fp,%l6
/* 0x269c	     */		sethi	%hi(0x2400),%g1
/* 0x26a0	     */		xor	%g1,-384,%g1
/* 0x26a4	     */		add	%g1,%fp,%l5
/* 0x26a8	     */		sethi	%hi(0x3800),%g1
/* 0x26ac	     */		xor	%g1,-64,%g1
/* 0x26b0	     */		add	%g1,%fp,%l4
/* 0x26b4	     */		sethi	%hi(0x4800),%g1
/* 0x26b8	     */		xor	%g1,-768,%g1
/* 0x26bc	     */		add	%i1,-1,%g2
/* 0x26c0	     */		or	%g0,0,%l7

!  653		      !            if (mask[i]) {

/* 0x26c4	 653 */		ldub	[%l0],%o4
/* 0x26c8	 652 */		add	%g1,%fp,%l3

! Registers live out of .L77005102: 
! g2 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004745 .L77005102

			.L900000654:
/* 0x26cc	 653 */		cmp	%o4,0
/* 0x26d0	     */		be,pn	%icc,.L77004745
/* 0x26d4	 652 */		add	%l7,1,%l7

! Registers live out of .L900000654: 
! g2 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  654		      !               red[i]   = ~(red[i]   | rdest[i]);

                       
! predecessor blocks: .L900000654

			.L77004743:
/* 0x26d8	 654 */		ldub	[%i4],%o1
/* 0x26dc	     */		ldub	[%l6],%o2

!  655		      !               green[i] = ~(green[i] | gdest[i]);

/* 0x26e0	 655 */		ldub	[%i5],%o3

!  656		      !               blue[i]  = ~(blue[i]  | bdest[i]);

/* 0x26e4	 656 */		ldub	[%i0],%l1

!  657		      !               alpha[i] = ~(alpha[i] | adest[i]);

/* 0x26e8	 657 */		ldub	[%i2],%o0
/* 0x26ec	 655 */		ldub	[%l5],%o4
/* 0x26f0	 654 */		or	%o1,%o2,%o5
/* 0x26f4	 656 */		ldub	[%l4],%i3
/* 0x26f8	 655 */		or	%o3,%o4,%l2
/* 0x26fc	 657 */		ldub	[%l3],%g5
/* 0x2700	 656 */		or	%l1,%i3,%g3
/* 0x2704	 654 */		xnor	%o5,0,%o7
/* 0x2708	     */		stb	%o7,[%i4]
/* 0x270c	 657 */		or	%o0,%g5,%o2
/* 0x2710	 655 */		xnor	%l2,0,%i1
/* 0x2714	     */		stb	%i1,[%i5]
/* 0x2718	 656 */		xnor	%g3,0,%g4
/* 0x271c	     */		stb	%g4,[%i0]
/* 0x2720	 657 */		xnor	%o2,0,%o1
/* 0x2724	     */		stb	%o1,[%i2]

! Registers live out of .L77004743: 
! g2 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004743 .L900000654

			.L77004745:
/* 0x2728	 652 */		cmp	%l7,%g2
/* 0x272c	     */		add	%l0,1,%l0
/* 0x2730	     */		add	%l3,1,%l3
/* 0x2734	     */		add	%l4,1,%l4
/* 0x2738	     */		add	%l5,1,%l5
/* 0x273c	     */		add	%l6,1,%l6
/* 0x2740	     */		add	%i2,1,%i2
/* 0x2744	     */		add	%i0,1,%i0
/* 0x2748	     */		add	%i5,1,%i5
/* 0x274c	     */		add	%i4,1,%i4
/* 0x2750	     */		ble,a,pt	%icc,.L900000654
/* 0x2754	 653 */		ldub	[%l0],%o4

! Registers live out of .L77004745: 
! g2 o4 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004745

			.L77004935:
/* 0x2758	 652 */		ba	.L77004840
/* 0x275c	     */		nop

! Registers live out of .L77004935: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004863

			.L77005249:
/* 0x2760	 652 */		ld	[%fp+92],%i0
/* 0x2764	     */		ld	[%fp+96],%i2
/* 0x2768	     */		or	%g0,0,%l4

! Registers live out of .L77005249: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004938 .L77004939 .L77004940 .L77005249

			.L77004932:
/* 0x276c	 653 */		ldub	[%l4+%l0],%l7

! Registers live out of .L77004932: 
! sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004932 .L77004934

			.L900000653:
/* 0x2770	 653 */		cmp	%l7,0
/* 0x2774	     */		be,pn	%icc,.L77004934
/* 0x2778	 654 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000653: 
! g1 sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000653

			.L77004933:
/* 0x277c	 654 */		xor	%g1,-704,%g1
/* 0x2780	     */		add	%g1,%fp,%l5
/* 0x2784	     */		ldub	[%l4+%l5],%o0
/* 0x2788	     */		ldub	[%i4+%l4],%l7
/* 0x278c	     */		or	%l7,%o0,%i3
/* 0x2790	     */		xnor	%i3,0,%o7
/* 0x2794	     */		stb	%o7,[%i4+%l4]
/* 0x2798	 655 */		ldub	[%l4+%l6],%g5
/* 0x279c	     */		ldub	[%i5+%l4],%o1
/* 0x27a0	     */		or	%o1,%g5,%g2
/* 0x27a4	     */		xnor	%g2,0,%o4
/* 0x27a8	     */		stb	%o4,[%i5+%l4]
/* 0x27ac	 656 */		ldub	[%l4+%l2],%o2
/* 0x27b0	     */		ldub	[%l4+%i0],%l5
/* 0x27b4	     */		or	%l5,%o2,%o3
/* 0x27b8	     */		xnor	%o3,0,%l3
/* 0x27bc	     */		stb	%l3,[%l4+%i0]
/* 0x27c0	 657 */		ldub	[%l4+%l1],%o5
/* 0x27c4	     */		ldub	[%l4+%i2],%g3
/* 0x27c8	     */		or	%g3,%o5,%g4
/* 0x27cc	     */		xnor	%g4,0,%o0
/* 0x27d0	     */		stb	%o0,[%l4+%i2]

! Registers live out of .L77004933: 
! sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004933 .L900000653

			.L77004934:
/* 0x27d4	 652 */		add	%l4,1,%l4
/* 0x27d8	     */		cmp	%l4,%i1
/* 0x27dc	     */		bcs,a,pn	%icc,.L900000653
/* 0x27e0	 653 */		ldub	[%l4+%l0],%l7

! Registers live out of .L77004934: 
! sp l0 l1 l2 l4 l6 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004934

			.L900000630:
/* 0x27e4	 652 */		ba	.L77004840
/* 0x27e8	     */		nop

! Registers live out of .L900000630: 
! sp fp i7 gsr 
! 
		
!  658		      !            }
!  659		      !         }
!  660		      !         break;
!  661		      !      case GL_XOR:
!  662		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004751:
/* 0x27ec	 662 */		cmp	%i1,0
/* 0x27f0	     */		bleu,pn	%icc,.L77004840
/* 0x27f4	     */		cmp	%i1,54

! Registers live out of .L77004751: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004751

			.L77004865:
/* 0x27f8	 662 */		bl,pn	%icc,.L77005245
/* 0x27fc	     */		add	%o2,1022,%o7

! Registers live out of .L77004865: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004865

			.L77004962:
/* 0x2800	 662 */		sethi	%hi(0x1000),%g1
/* 0x2804	     */		xor	%g1,-704,%g1
/* 0x2808	     */		add	%g1,%fp,%o0
/* 0x280c	     */		sub	%i4,%o0,%o4
/* 0x2810	     */		sub	%i4,%i5,%i2
/* 0x2814	     */		sra	%i2,31,%o0
/* 0x2818	     */		xor	%i2,%o0,%i0
/* 0x281c	     */		sub	%i4,%l6,%g4
/* 0x2820	     */		sub	%i4,%l1,%o3
/* 0x2824	     */		sra	%g4,31,%o2
/* 0x2828	     */		sra	%o3,31,%i2
/* 0x282c	     */		sub	%i0,%o0,%l7
/* 0x2830	     */		xor	%g4,%o2,%i3
/* 0x2834	     */		xor	%o3,%i2,%o5
/* 0x2838	     */		sub	%o5,%i2,%o0
/* 0x283c	     */		sub	%i4,%l2,%l5
/* 0x2840	     */		sub	%i3,%o2,%g3
/* 0x2844	     */		sub	%i4,%l0,%i0
/* 0x2848	     */		sra	%l5,31,%g5
/* 0x284c	     */		sra	%i0,31,%i3
/* 0x2850	     */		xor	%l5,%g5,%g2
/* 0x2854	     */		xor	%i0,%i3,%g4
/* 0x2858	     */		sra	%o4,31,%o1
/* 0x285c	     */		sub	%g2,%g5,%l5
/* 0x2860	     */		xor	%o4,%o1,%l3
/* 0x2864	     */		sub	%l3,%o1,%l4
/* 0x2868	     */		sub	%g4,%i3,%l3
/* 0x286c	     */		sra	%l7,0,%o1
/* 0x2870	     */		sra	%l4,0,%g4
/* 0x2874	     */		sra	%g3,0,%g3
/* 0x2878	     */		ld	[%fp+96],%i2
/* 0x287c	     */		ld	[%fp+92],%i0
/* 0x2880	     */		sub	%i4,%i2,%g5
/* 0x2884	     */		sra	%g5,31,%o5
/* 0x2888	     */		xor	%g5,%o5,%o3
/* 0x288c	     */		sub	%i4,%i0,%o2
/* 0x2890	     */		sra	%o2,31,%g2
/* 0x2894	     */		sub	%o3,%o5,%i3
/* 0x2898	     */		xor	%o2,%g2,%o4
/* 0x289c	     */		sra	%o0,0,%o3
/* 0x28a0	     */		sra	%i1,0,%o0
/* 0x28a4	     */		sub	%o4,%g2,%l7
/* 0x28a8	     */		sra	%i3,0,%o4
/* 0x28ac	     */		sub	%o1,%o0,%g2
/* 0x28b0	     */		srlx	%g2,63,%i3
/* 0x28b4	     */		sra	%l5,0,%g5
/* 0x28b8	     */		sub	%g3,%o0,%g2
/* 0x28bc	     */		sub	%g4,%o0,%o1
/* 0x28c0	     */		sub	%g5,%o0,%g5
/* 0x28c4	     */		sra	%l7,0,%o2
/* 0x28c8	     */		sra	%l3,0,%o5
/* 0x28cc	     */		srlx	%o1,63,%l4
/* 0x28d0	     */		srlx	%g5,63,%l5
/* 0x28d4	     */		sub	%o3,%o0,%g3
/* 0x28d8	     */		srlx	%g2,63,%l3
/* 0x28dc	     */		sub	%o2,%o0,%g5
/* 0x28e0	     */		xor	%i3,1,%o1
/* 0x28e4	     */		srlx	%g3,63,%g3
/* 0x28e8	     */		srlx	%g5,63,%l7
/* 0x28ec	     */		xor	%l3,1,%o2
/* 0x28f0	     */		sub	%o5,%o0,%o3
/* 0x28f4	     */		xor	%g3,1,%i3
/* 0x28f8	     */		and	%o2,%o1,%g5
/* 0x28fc	     */		sub	%o4,%o0,%g4
/* 0x2900	     */		srlx	%o3,63,%g2
/* 0x2904	     */		srl	%i1,0,%g3
/* 0x2908	     */		xor	%l5,1,%o3
/* 0x290c	     */		xor	%l7,1,%o4
/* 0x2910	     */		xor	%l4,1,%o1
/* 0x2914	     */		sub	%g3,%o7,%o7
/* 0x2918	     */		and	%o3,%o4,%l5
/* 0x291c	     */		srlx	%o7,63,%l4
/* 0x2920	     */		and	%l4,%o1,%o4
/* 0x2924	     */		srlx	%g4,63,%g4
/* 0x2928	     */		xor	%g4,1,%o5
/* 0x292c	     */		and	%o4,%g5,%o3
/* 0x2930	     */		and	%i3,%o5,%l3
/* 0x2934	     */		xor	%g2,1,%o2
/* 0x2938	     */		and	%o3,%l5,%g3
/* 0x293c	     */		and	%o2,1,%l7
/* 0x2940	     */		and	%g3,%l3,%g4
/* 0x2944	     */		andcc	%g4,%l7,%g0
/* 0x2948	     */		be,a,pn	%icc,.L77004956
/* 0x294c	     */		or	%g0,0,%l4

! Registers live out of .L77004962: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004962

			.L77004963:
/* 0x2950	 662 */		sub	%i5,%i0,%o5
/* 0x2954	     */		sethi	%hi(0x1000),%g1
/* 0x2958	     */		sra	%o5,31,%l4
/* 0x295c	     */		xor	%g1,-704,%g1
/* 0x2960	     */		xor	%o5,%l4,%l3
/* 0x2964	     */		sub	%i5,%l2,%l5
/* 0x2968	     */		sub	%i5,%l6,%l7
/* 0x296c	     */		add	%g1,%fp,%o1
/* 0x2970	     */		sub	%i5,%o1,%g3
/* 0x2974	     */		sub	%l3,%l4,%g2
/* 0x2978	     */		sra	%l5,31,%i3
/* 0x297c	     */		sra	%l7,31,%o5
/* 0x2980	     */		xor	%l5,%i3,%o4
/* 0x2984	     */		sra	%g3,31,%l4
/* 0x2988	     */		sub	%i5,%l1,%o3
/* 0x298c	     */		xor	%l7,%o5,%o2
/* 0x2990	     */		xor	%g3,%l4,%l3
/* 0x2994	     */		sub	%i5,%i2,%o7
/* 0x2998	     */		sub	%o4,%i3,%g5
/* 0x299c	     */		sra	%o3,31,%l7
/* 0x29a0	     */		sub	%i0,%o1,%o4
/* 0x29a4	     */		sra	%o7,31,%l5
/* 0x29a8	     */		xor	%o3,%l7,%i3
/* 0x29ac	     */		sub	%l3,%l4,%g4
/* 0x29b0	     */		xor	%o7,%l5,%o1
/* 0x29b4	     */		sub	%i5,%l0,%l4
/* 0x29b8	     */		sub	%i3,%l7,%l7
/* 0x29bc	     */		sra	%l4,31,%l3
/* 0x29c0	     */		sub	%o2,%o5,%o2
/* 0x29c4	     */		sub	%o1,%l5,%g3
/* 0x29c8	     */		sra	%o4,31,%i3
/* 0x29cc	     */		xor	%l4,%l3,%o7
/* 0x29d0	     */		xor	%o4,%i3,%o1
/* 0x29d4	     */		sub	%i0,%l6,%o5
/* 0x29d8	     */		sra	%o5,31,%l4
/* 0x29dc	     */		sub	%i0,%l2,%o3
/* 0x29e0	     */		sub	%o1,%i3,%i3
/* 0x29e4	     */		sub	%o7,%l3,%l5
/* 0x29e8	     */		xor	%o5,%l4,%o4
/* 0x29ec	     */		sra	%o3,31,%o1
/* 0x29f0	     */		sub	%o4,%l4,%l3
/* 0x29f4	     */		xor	%o3,%o1,%o7
/* 0x29f8	     */		sub	%o7,%o1,%l4
/* 0x29fc	     */		sra	%g2,0,%o7
/* 0x2a00	     */		sra	%g5,0,%g5
/* 0x2a04	     */		sub	%o7,%o0,%o5
/* 0x2a08	     */		sub	%g5,%o0,%o4
/* 0x2a0c	     */		srlx	%o5,63,%g2
/* 0x2a10	     */		srlx	%o4,63,%g5
/* 0x2a14	     */		xor	%g2,1,%o3
/* 0x2a18	     */		xor	%g5,1,%o5
/* 0x2a1c	     */		and	%o5,%o3,%o4
/* 0x2a20	     */		sra	%o2,0,%g2
/* 0x2a24	     */		sra	%g4,0,%g4
/* 0x2a28	     */		sub	%g2,%o0,%o1
/* 0x2a2c	     */		sub	%g4,%o0,%o3
/* 0x2a30	     */		srlx	%o1,63,%o2
/* 0x2a34	     */		srlx	%o3,63,%g4
/* 0x2a38	     */		xor	%o2,1,%o7
/* 0x2a3c	     */		xor	%g4,1,%o1
/* 0x2a40	     */		and	%o1,%o7,%g2
/* 0x2a44	     */		sra	%l7,0,%o7
/* 0x2a48	     */		sra	%g3,0,%g3
/* 0x2a4c	     */		sub	%g3,%o0,%o2
/* 0x2a50	     */		sub	%o7,%o0,%o5
/* 0x2a54	     */		and	%g2,%o4,%g4
/* 0x2a58	     */		srlx	%o2,63,%g3
/* 0x2a5c	     */		srlx	%o5,63,%l7
/* 0x2a60	     */		xor	%g3,1,%g5
/* 0x2a64	     */		xor	%l7,1,%o3
/* 0x2a68	     */		sra	%i3,0,%g2
/* 0x2a6c	     */		and	%o3,%g5,%o5
/* 0x2a70	     */		sub	%g2,%o0,%o1
/* 0x2a74	     */		and	%g4,%o5,%g3
/* 0x2a78	     */		sra	%l5,0,%g5
/* 0x2a7c	     */		sra	%l3,0,%g2
/* 0x2a80	     */		srlx	%o1,63,%i3
/* 0x2a84	     */		sub	%g5,%o0,%o4
/* 0x2a88	     */		sub	%g2,%o0,%g4
/* 0x2a8c	     */		sra	%l4,0,%o1
/* 0x2a90	     */		srlx	%o4,63,%l5
/* 0x2a94	     */		sub	%o1,%o0,%g2
/* 0x2a98	     */		srlx	%g2,63,%l4
/* 0x2a9c	     */		xor	%l5,1,%o2
/* 0x2aa0	     */		xor	%i3,1,%o4
/* 0x2aa4	     */		srlx	%g4,63,%l3
/* 0x2aa8	     */		xor	%l4,1,%g5
/* 0x2aac	     */		and	%o4,%o2,%o7
/* 0x2ab0	     */		xor	%l3,1,%l7
/* 0x2ab4	     */		and	%g3,%o7,%o5
/* 0x2ab8	     */		and	%g5,%l7,%o3
/* 0x2abc	     */		andcc	%o5,%o3,%g0
/* 0x2ac0	     */		be,a,pn	%icc,.L77004956
/* 0x2ac4	     */		or	%g0,0,%l4

! Registers live out of .L77004963: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004963

			.L77004964:
/* 0x2ac8	 662 */		sethi	%hi(0x1000),%g1
/* 0x2acc	     */		sub	%i0,%l0,%o4
/* 0x2ad0	     */		xor	%g1,-704,%g1
/* 0x2ad4	     */		sra	%o4,31,%o3
/* 0x2ad8	     */		sub	%i0,%i2,%l7
/* 0x2adc	     */		add	%g1,%fp,%o7
/* 0x2ae0	     */		sub	%i2,%o7,%l5
/* 0x2ae4	     */		xor	%o4,%o3,%o2
/* 0x2ae8	     */		sra	%l7,31,%i3
/* 0x2aec	     */		sub	%i2,%l6,%g3
/* 0x2af0	     */		sub	%o2,%o3,%l4
/* 0x2af4	     */		sra	%l5,31,%l3
/* 0x2af8	     */		xor	%l7,%i3,%o5
/* 0x2afc	     */		sra	%g3,31,%o4
/* 0x2b00	     */		sub	%i0,%l1,%g2
/* 0x2b04	     */		xor	%l5,%l3,%g5
/* 0x2b08	     */		sra	%g2,31,%o7
/* 0x2b0c	     */		xor	%g3,%o4,%o1
/* 0x2b10	     */		sub	%o5,%i3,%o2
/* 0x2b14	     */		sub	%i2,%l2,%g4
/* 0x2b18	     */		sub	%g5,%l3,%l5
/* 0x2b1c	     */		xor	%g2,%o7,%o5
/* 0x2b20	     */		sra	%g4,31,%i3
/* 0x2b24	     */		sub	%i2,%l1,%o3
/* 0x2b28	     */		sub	%o1,%o4,%g3
/* 0x2b2c	     */		sra	%o3,31,%o1
/* 0x2b30	     */		sub	%o5,%o7,%g5
/* 0x2b34	     */		sub	%i2,%l0,%g2
/* 0x2b38	     */		xor	%g4,%i3,%g4
/* 0x2b3c	     */		sub	%g4,%i3,%l7
/* 0x2b40	     */		xor	%o3,%o1,%o7
/* 0x2b44	     */		sra	%g2,31,%l3
/* 0x2b48	     */		xor	%g2,%l3,%o5
/* 0x2b4c	     */		sub	%o7,%o1,%i3
/* 0x2b50	     */		sub	%o5,%l3,%l3
/* 0x2b54	     */		sra	%l4,0,%o7
/* 0x2b58	     */		sra	%l5,0,%o4
/* 0x2b5c	     */		sra	%o2,0,%o2
/* 0x2b60	     */		sra	%g5,0,%g5
/* 0x2b64	     */		sub	%o7,%o0,%o1
/* 0x2b68	     */		sub	%o4,%o0,%o3
/* 0x2b6c	     */		sub	%o2,%o0,%o5
/* 0x2b70	     */		sub	%g5,%o0,%g2
/* 0x2b74	     */		srlx	%o1,63,%l4
/* 0x2b78	     */		srlx	%o3,63,%l5
/* 0x2b7c	     */		srlx	%o5,63,%o2
/* 0x2b80	     */		srlx	%g2,63,%g5
/* 0x2b84	     */		xor	%l4,1,%g4
/* 0x2b88	     */		xor	%l5,1,%o4
/* 0x2b8c	     */		xor	%o2,1,%o3
/* 0x2b90	     */		xor	%g5,1,%g2
/* 0x2b94	     */		and	%o4,%g4,%o7
/* 0x2b98	     */		and	%o3,%g2,%o5
/* 0x2b9c	     */		and	%o5,%o7,%g4
/* 0x2ba0	     */		sra	%l7,0,%o1
/* 0x2ba4	     */		sra	%g3,0,%g3
/* 0x2ba8	     */		sub	%g3,%o0,%o7
/* 0x2bac	     */		sub	%o1,%o0,%o4
/* 0x2bb0	     */		srlx	%o7,63,%g3
/* 0x2bb4	     */		srlx	%o4,63,%l7
/* 0x2bb8	     */		xor	%g3,1,%l5
/* 0x2bbc	     */		xor	%l7,1,%o1
/* 0x2bc0	     */		and	%o1,%l5,%l4
/* 0x2bc4	     */		and	%g4,%l4,%o7
/* 0x2bc8	     */		sra	%l3,0,%g4
/* 0x2bcc	     */		sub	%g4,%o0,%o3
/* 0x2bd0	     */		sra	%i3,0,%o4
/* 0x2bd4	     */		sub	%o4,%o0,%o0
/* 0x2bd8	     */		srlx	%o3,63,%l3
/* 0x2bdc	     */		srlx	%o0,63,%i3
/* 0x2be0	     */		xor	%l3,1,%g5
/* 0x2be4	     */		xor	%i3,1,%o2
/* 0x2be8	     */		and	%g5,%o2,%g2
/* 0x2bec	     */		andcc	%o7,%g2,%g0
/* 0x2bf0	     */		be,a,pn	%icc,.L77004956
/* 0x2bf4	     */		or	%g0,0,%l4

! Registers live out of .L77004964: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004964

			.L77005104:
/* 0x2bf8	 662 */		sethi	%hi(0x1000),%g1
/* 0x2bfc	     */		xor	%g1,-704,%g1
/* 0x2c00	     */		add	%g1,%fp,%g4
/* 0x2c04	     */		sethi	%hi(0x2400),%g1
/* 0x2c08	     */		xor	%g1,-384,%g1
/* 0x2c0c	     */		add	%g1,%fp,%g3
/* 0x2c10	     */		sethi	%hi(0x3800),%g1
/* 0x2c14	     */		xor	%g1,-64,%g1
/* 0x2c18	     */		add	%g1,%fp,%g2
/* 0x2c1c	     */		sethi	%hi(0x4800),%g1
/* 0x2c20	     */		add	%i1,-1,%o0
/* 0x2c24	     */		xor	%g1,-768,%g1
/* 0x2c28	     */		or	%g0,0,%g5

!  663		      !            if (mask[i]) {

/* 0x2c2c	 663 */		ldub	[%l0],%i1
/* 0x2c30	 662 */		add	%g1,%fp,%l7

! Registers live out of .L77005104: 
! g2 g3 g4 g5 o0 sp l0 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004759 .L77005104

			.L900000652:
/* 0x2c34	 663 */		cmp	%i1,0
/* 0x2c38	     */		be,pn	%icc,.L77004759
/* 0x2c3c	 662 */		add	%g5,1,%g5

! Registers live out of .L900000652: 
! g2 g3 g4 g5 o0 sp l0 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		
!  664		      !               red[i]   ^= rdest[i];

                       
! predecessor blocks: .L900000652

			.L77004757:
/* 0x2c40	 664 */		ldub	[%i4],%o4

!  665		      !               green[i] ^= gdest[i];

/* 0x2c44	 665 */		ldub	[%i5],%l1

!  666		      !               blue[i]  ^= bdest[i];

/* 0x2c48	 666 */		ldub	[%i0],%o7

!  667		      !               alpha[i] ^= adest[i];

/* 0x2c4c	 667 */		ldub	[%i2],%l5
/* 0x2c50	 664 */		ldub	[%g4],%o1
/* 0x2c54	 665 */		ldub	[%g3],%i3
/* 0x2c58	 666 */		ldub	[%g2],%o5
/* 0x2c5c	 667 */		ldub	[%l7],%l4
/* 0x2c60	 664 */		xor	%o4,%o1,%o3
/* 0x2c64	     */		stb	%o3,[%i4]
/* 0x2c68	 665 */		xor	%l1,%i3,%l2
/* 0x2c6c	     */		stb	%l2,[%i5]
/* 0x2c70	 666 */		xor	%o7,%o5,%l3
/* 0x2c74	     */		stb	%l3,[%i0]
/* 0x2c78	 667 */		xor	%l5,%l4,%l6
/* 0x2c7c	     */		stb	%l6,[%i2]

! Registers live out of .L77004757: 
! g2 g3 g4 g5 o0 sp l0 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004757 .L900000652

			.L77004759:
/* 0x2c80	 662 */		cmp	%g5,%o0
/* 0x2c84	     */		add	%l0,1,%l0
/* 0x2c88	     */		add	%l7,1,%l7
/* 0x2c8c	     */		add	%g2,1,%g2
/* 0x2c90	     */		add	%g3,1,%g3
/* 0x2c94	     */		add	%g4,1,%g4
/* 0x2c98	     */		add	%i2,1,%i2
/* 0x2c9c	     */		add	%i0,1,%i0
/* 0x2ca0	     */		add	%i5,1,%i5
/* 0x2ca4	     */		add	%i4,1,%i4
/* 0x2ca8	     */		ble,a,pt	%icc,.L900000652
/* 0x2cac	 663 */		ldub	[%l0],%i1

! Registers live out of .L77004759: 
! g2 g3 g4 g5 o0 sp l0 l7 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004759

			.L77004959:
/* 0x2cb0	 662 */		ba	.L77004840
/* 0x2cb4	     */		nop

! Registers live out of .L77004959: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004865

			.L77005245:
/* 0x2cb8	 662 */		ld	[%fp+92],%i0
/* 0x2cbc	     */		ld	[%fp+96],%i2
/* 0x2cc0	     */		or	%g0,0,%l4

! Registers live out of .L77005245: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004962 .L77004963 .L77004964 .L77005245

			.L77004956:
/* 0x2cc4	 663 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004956: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004956 .L77004958

			.L900000651:
/* 0x2cc8	 663 */		cmp	%g3,0
/* 0x2ccc	     */		be,pn	%icc,.L77004958
/* 0x2cd0	 664 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000651: 
! g1 g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000651

			.L77004957:
/* 0x2cd4	 664 */		xor	%g1,-704,%g1
/* 0x2cd8	     */		add	%g1,%fp,%l3
/* 0x2cdc	     */		ldub	[%l4+%l3],%o0
/* 0x2ce0	     */		ldub	[%i4+%l4],%o5
/* 0x2ce4	     */		xor	%o5,%o0,%i3
/* 0x2ce8	     */		stb	%i3,[%i4+%l4]
/* 0x2cec	 665 */		ldub	[%l4+%l6],%o7
/* 0x2cf0	     */		ldub	[%i5+%l4],%g5
/* 0x2cf4	     */		xor	%g5,%o7,%o1
/* 0x2cf8	     */		stb	%o1,[%i5+%l4]
/* 0x2cfc	 666 */		ldub	[%l4+%l2],%g2
/* 0x2d00	     */		ldub	[%l4+%i0],%o2
/* 0x2d04	     */		xor	%o2,%g2,%o4
/* 0x2d08	     */		stb	%o4,[%l4+%i0]
/* 0x2d0c	 667 */		ldub	[%l4+%l1],%l5
/* 0x2d10	     */		ldub	[%l4+%i2],%o3
/* 0x2d14	     */		xor	%o3,%l5,%l3
/* 0x2d18	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004957: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004957 .L900000651

			.L77004958:
/* 0x2d1c	 662 */		add	%l4,1,%l4
/* 0x2d20	     */		cmp	%l4,%i1
/* 0x2d24	     */		bcs,a,pn	%icc,.L900000651
/* 0x2d28	 663 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004958: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004958

			.L900000629:
/* 0x2d2c	 662 */		ba	.L77004840
/* 0x2d30	     */		nop

! Registers live out of .L900000629: 
! sp fp i7 gsr 
! 
		
!  668		      !            }
!  669		      !         }
!  670		      !         break;
!  671		      !      case GL_EQUIV:
!  672		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004765:
/* 0x2d34	 672 */		cmp	%i1,0
/* 0x2d38	     */		bleu,pn	%icc,.L77004840
/* 0x2d3c	     */		cmp	%i1,54

! Registers live out of .L77004765: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004765

			.L77004862:
/* 0x2d40	 672 */		bl,pn	%icc,.L77005251
/* 0x2d44	     */		add	%o2,1022,%o7

! Registers live out of .L77004862: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004862

			.L77004926:
/* 0x2d48	 672 */		sub	%i4,%i5,%i2
/* 0x2d4c	     */		sethi	%hi(0x1000),%g1
/* 0x2d50	     */		sra	%i2,31,%o0
/* 0x2d54	     */		xor	%g1,-704,%g1
/* 0x2d58	     */		xor	%i2,%o0,%i0
/* 0x2d5c	     */		sub	%i4,%l6,%i3
/* 0x2d60	     */		sub	%i4,%l1,%o3
/* 0x2d64	     */		add	%g1,%fp,%l7
/* 0x2d68	     */		sub	%i4,%l7,%o4
/* 0x2d6c	     */		sra	%i3,31,%o1
/* 0x2d70	     */		sra	%o3,31,%i2
/* 0x2d74	     */		sub	%i0,%o0,%l7
/* 0x2d78	     */		xor	%i3,%o1,%g4
/* 0x2d7c	     */		xor	%o3,%i2,%o5
/* 0x2d80	     */		sub	%o5,%i2,%o0
/* 0x2d84	     */		sub	%i4,%l2,%l5
/* 0x2d88	     */		sub	%g4,%o1,%g3
/* 0x2d8c	     */		sub	%i4,%l0,%i0
/* 0x2d90	     */		sra	%l5,31,%g5
/* 0x2d94	     */		sra	%i0,31,%g4
/* 0x2d98	     */		xor	%l5,%g5,%g2
/* 0x2d9c	     */		xor	%i0,%g4,%i3
/* 0x2da0	     */		sra	%o4,31,%l3
/* 0x2da4	     */		sub	%g2,%g5,%l5
/* 0x2da8	     */		xor	%o4,%l3,%o2
/* 0x2dac	     */		sub	%o2,%l3,%l4
/* 0x2db0	     */		sub	%i3,%g4,%l3
/* 0x2db4	     */		sra	%l7,0,%o1
/* 0x2db8	     */		sra	%g3,0,%g3
/* 0x2dbc	     */		sra	%l4,0,%g4
/* 0x2dc0	     */		ld	[%fp+96],%i2
/* 0x2dc4	     */		ld	[%fp+92],%i0
/* 0x2dc8	     */		sub	%i4,%i2,%g5
/* 0x2dcc	     */		sra	%g5,31,%o5
/* 0x2dd0	     */		xor	%g5,%o5,%o3
/* 0x2dd4	     */		sub	%i4,%i0,%o4
/* 0x2dd8	     */		sra	%o4,31,%g2
/* 0x2ddc	     */		sub	%o3,%o5,%i3
/* 0x2de0	     */		xor	%o4,%g2,%o2
/* 0x2de4	     */		sra	%o0,0,%o3
/* 0x2de8	     */		sra	%i1,0,%o0
/* 0x2dec	     */		sub	%o2,%g2,%l7
/* 0x2df0	     */		sub	%o1,%o0,%g2
/* 0x2df4	     */		srlx	%g2,63,%o1
/* 0x2df8	     */		sra	%l3,0,%o5
/* 0x2dfc	     */		sub	%g3,%o0,%g2
/* 0x2e00	     */		sra	%l5,0,%g5
/* 0x2e04	     */		sra	%i3,0,%o4
/* 0x2e08	     */		srlx	%g2,63,%l3
/* 0x2e0c	     */		sub	%g5,%o0,%g3
/* 0x2e10	     */		sub	%o4,%o0,%g2
/* 0x2e14	     */		sra	%l7,0,%o2
/* 0x2e18	     */		srlx	%g3,63,%l5
/* 0x2e1c	     */		xor	%o1,1,%o4
/* 0x2e20	     */		sub	%o2,%o0,%o2
/* 0x2e24	     */		sub	%o3,%o0,%o3
/* 0x2e28	     */		srlx	%o2,63,%l7
/* 0x2e2c	     */		srlx	%o3,63,%g3
/* 0x2e30	     */		sub	%o5,%o0,%o1
/* 0x2e34	     */		xor	%l5,1,%o5
/* 0x2e38	     */		xor	%l7,1,%o3
/* 0x2e3c	     */		xor	%l3,1,%o2
/* 0x2e40	     */		and	%o5,%o3,%l5
/* 0x2e44	     */		sub	%g4,%o0,%g4
/* 0x2e48	     */		srlx	%g4,63,%l4
/* 0x2e4c	     */		and	%o2,%o4,%g5
/* 0x2e50	     */		srl	%i1,0,%o5
/* 0x2e54	     */		xor	%l4,1,%o4
/* 0x2e58	     */		sub	%o5,%o7,%o7
/* 0x2e5c	     */		srlx	%g2,63,%g4
/* 0x2e60	     */		srlx	%o7,63,%l4
/* 0x2e64	     */		and	%l4,%o4,%o3
/* 0x2e68	     */		srlx	%o1,63,%g2
/* 0x2e6c	     */		xor	%g3,1,%o1
/* 0x2e70	     */		xor	%g4,1,%i3
/* 0x2e74	     */		and	%o3,%g5,%o5
/* 0x2e78	     */		and	%o1,%i3,%l3
/* 0x2e7c	     */		xor	%g2,1,%o2
/* 0x2e80	     */		and	%o5,%l5,%g3
/* 0x2e84	     */		and	%o2,1,%l7
/* 0x2e88	     */		and	%g3,%l3,%g4
/* 0x2e8c	     */		andcc	%g4,%l7,%g0
/* 0x2e90	     */		be,a,pn	%icc,.L77004920
/* 0x2e94	     */		or	%g0,0,%l4

! Registers live out of .L77004926: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004926

			.L77004927:
/* 0x2e98	 672 */		sub	%i5,%i0,%o5
/* 0x2e9c	     */		sethi	%hi(0x1000),%g1
/* 0x2ea0	     */		sra	%o5,31,%l4
/* 0x2ea4	     */		sub	%i5,%l2,%l5
/* 0x2ea8	     */		xor	%g1,-704,%g1
/* 0x2eac	     */		xor	%o5,%l4,%o1
/* 0x2eb0	     */		sra	%l5,31,%o4
/* 0x2eb4	     */		sub	%i5,%l6,%l7
/* 0x2eb8	     */		add	%g1,%fp,%i3
/* 0x2ebc	     */		sub	%i5,%i3,%g4
/* 0x2ec0	     */		sub	%o1,%l4,%g2
/* 0x2ec4	     */		xor	%l5,%o4,%l3
/* 0x2ec8	     */		sra	%l7,31,%o5
/* 0x2ecc	     */		xor	%l7,%o5,%o2
/* 0x2ed0	     */		sra	%g4,31,%l4
/* 0x2ed4	     */		sub	%i5,%i2,%g3
/* 0x2ed8	     */		sub	%i5,%l1,%o3
/* 0x2edc	     */		sub	%l3,%o4,%g5
/* 0x2ee0	     */		xor	%g4,%l4,%o1
/* 0x2ee4	     */		sub	%i0,%i3,%o4
/* 0x2ee8	     */		sra	%g3,31,%l5
/* 0x2eec	     */		sra	%o3,31,%l3
/* 0x2ef0	     */		sub	%o2,%o5,%o7
/* 0x2ef4	     */		xor	%g3,%l5,%i3
/* 0x2ef8	     */		xor	%o3,%l3,%o2
/* 0x2efc	     */		sub	%o1,%l4,%g4
/* 0x2f00	     */		sub	%o2,%l3,%l7
/* 0x2f04	     */		sub	%i5,%l0,%o1
/* 0x2f08	     */		sub	%i3,%l5,%g3
/* 0x2f0c	     */		sra	%o1,31,%i3
/* 0x2f10	     */		sra	%o4,31,%l3
/* 0x2f14	     */		xor	%o1,%i3,%l4
/* 0x2f18	     */		xor	%o4,%l3,%o2
/* 0x2f1c	     */		sub	%i0,%l6,%o5
/* 0x2f20	     */		sub	%l4,%i3,%l5
/* 0x2f24	     */		sra	%o5,31,%o4
/* 0x2f28	     */		sub	%o2,%l3,%i3
/* 0x2f2c	     */		xor	%o5,%o4,%o1
/* 0x2f30	     */		sub	%o1,%o4,%l3
/* 0x2f34	     */		sub	%i0,%l2,%o3
/* 0x2f38	     */		sra	%g2,0,%o4
/* 0x2f3c	     */		sra	%g5,0,%g5
/* 0x2f40	     */		sra	%o3,31,%o2
/* 0x2f44	     */		sub	%g5,%o0,%o1
/* 0x2f48	     */		sub	%o4,%o0,%g2
/* 0x2f4c	     */		xor	%o3,%o2,%l4
/* 0x2f50	     */		srlx	%o1,63,%g5
/* 0x2f54	     */		srlx	%g2,63,%g2
/* 0x2f58	     */		xor	%g2,1,%o3
/* 0x2f5c	     */		xor	%g5,1,%o5
/* 0x2f60	     */		and	%o5,%o3,%o1
/* 0x2f64	     */		sra	%o7,0,%o7
/* 0x2f68	     */		sra	%g4,0,%g4
/* 0x2f6c	     */		sub	%o7,%o0,%o5
/* 0x2f70	     */		sub	%g4,%o0,%o3
/* 0x2f74	     */		sub	%l4,%o2,%l4
/* 0x2f78	     */		srlx	%o5,63,%o7
/* 0x2f7c	     */		srlx	%o3,63,%g4
/* 0x2f80	     */		xor	%o7,1,%o4
/* 0x2f84	     */		xor	%g4,1,%o2
/* 0x2f88	     */		and	%o2,%o4,%g2
/* 0x2f8c	     */		and	%g2,%o1,%o5
/* 0x2f90	     */		sra	%l7,0,%o4
/* 0x2f94	     */		sra	%g3,0,%g3
/* 0x2f98	     */		sub	%g3,%o0,%o2
/* 0x2f9c	     */		sub	%o4,%o0,%g2
/* 0x2fa0	     */		srlx	%o2,63,%g3
/* 0x2fa4	     */		srlx	%g2,63,%l7
/* 0x2fa8	     */		xor	%g3,1,%g5
/* 0x2fac	     */		xor	%l7,1,%o3
/* 0x2fb0	     */		and	%o3,%g5,%o7
/* 0x2fb4	     */		and	%o5,%o7,%o2
/* 0x2fb8	     */		sra	%l3,0,%o3
/* 0x2fbc	     */		sra	%l5,0,%g5
/* 0x2fc0	     */		sub	%o3,%o0,%g3
/* 0x2fc4	     */		sra	%i3,0,%o7
/* 0x2fc8	     */		sub	%g5,%o0,%o1
/* 0x2fcc	     */		sub	%o7,%o0,%o5
/* 0x2fd0	     */		srlx	%g3,63,%l3
/* 0x2fd4	     */		sra	%l4,0,%g2
/* 0x2fd8	     */		srlx	%o1,63,%l5
/* 0x2fdc	     */		srlx	%o5,63,%i3
/* 0x2fe0	     */		sub	%g2,%o0,%g3
/* 0x2fe4	     */		srlx	%g3,63,%l4
/* 0x2fe8	     */		xor	%l5,1,%g4
/* 0x2fec	     */		xor	%i3,1,%o1
/* 0x2ff0	     */		xor	%l4,1,%g5
/* 0x2ff4	     */		and	%o1,%g4,%o4
/* 0x2ff8	     */		xor	%l3,1,%l7
/* 0x2ffc	     */		and	%o2,%o4,%o5
/* 0x3000	     */		and	%g5,%l7,%o3
/* 0x3004	     */		andcc	%o5,%o3,%g0
/* 0x3008	     */		be,a,pn	%icc,.L77004920
/* 0x300c	     */		or	%g0,0,%l4

! Registers live out of .L77004927: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004927

			.L77004928:
/* 0x3010	 672 */		sethi	%hi(0x1000),%g1
/* 0x3014	     */		xor	%g1,-704,%g1
/* 0x3018	     */		add	%g1,%fp,%o2
/* 0x301c	     */		sub	%i2,%o2,%o1
/* 0x3020	     */		sra	%o1,31,%o2
/* 0x3024	     */		sub	%i0,%l0,%i3
/* 0x3028	     */		sra	%i3,31,%g5
/* 0x302c	     */		xor	%o1,%o2,%o4
/* 0x3030	     */		sub	%i0,%i2,%o3
/* 0x3034	     */		xor	%i3,%g5,%o7
/* 0x3038	     */		sub	%o4,%o2,%l5
/* 0x303c	     */		sra	%o3,31,%l3
/* 0x3040	     */		sub	%i2,%l6,%g3
/* 0x3044	     */		sub	%o7,%g5,%l4
/* 0x3048	     */		xor	%o3,%l3,%o5
/* 0x304c	     */		sra	%g3,31,%o4
/* 0x3050	     */		sub	%i0,%l1,%g2
/* 0x3054	     */		sra	%g2,31,%o7
/* 0x3058	     */		xor	%g3,%o4,%o1
/* 0x305c	     */		sub	%o5,%l3,%o2
/* 0x3060	     */		sub	%i2,%l2,%g4
/* 0x3064	     */		xor	%g2,%o7,%o5
/* 0x3068	     */		sra	%g4,31,%i3
/* 0x306c	     */		sub	%i2,%l1,%o3
/* 0x3070	     */		sub	%o1,%o4,%g3
/* 0x3074	     */		sra	%o3,31,%o1
/* 0x3078	     */		sub	%o5,%o7,%g5
/* 0x307c	     */		sub	%i2,%l0,%g2
/* 0x3080	     */		xor	%g4,%i3,%g4
/* 0x3084	     */		sub	%g4,%i3,%l7
/* 0x3088	     */		xor	%o3,%o1,%o7
/* 0x308c	     */		sra	%g2,31,%l3
/* 0x3090	     */		xor	%g2,%l3,%o5
/* 0x3094	     */		sub	%o7,%o1,%i3
/* 0x3098	     */		sub	%o5,%l3,%l3
/* 0x309c	     */		sra	%l4,0,%o7
/* 0x30a0	     */		sra	%l5,0,%o4
/* 0x30a4	     */		sra	%o2,0,%o2
/* 0x30a8	     */		sra	%g5,0,%g5
/* 0x30ac	     */		sub	%o7,%o0,%o1
/* 0x30b0	     */		sub	%o4,%o0,%o3
/* 0x30b4	     */		sub	%o2,%o0,%o5
/* 0x30b8	     */		sub	%g5,%o0,%g2
/* 0x30bc	     */		srlx	%o1,63,%l4
/* 0x30c0	     */		srlx	%o3,63,%l5
/* 0x30c4	     */		srlx	%o5,63,%o2
/* 0x30c8	     */		srlx	%g2,63,%g5
/* 0x30cc	     */		xor	%l4,1,%g4
/* 0x30d0	     */		xor	%l5,1,%o4
/* 0x30d4	     */		xor	%o2,1,%o3
/* 0x30d8	     */		xor	%g5,1,%g2
/* 0x30dc	     */		and	%o4,%g4,%o7
/* 0x30e0	     */		and	%o3,%g2,%o5
/* 0x30e4	     */		and	%o5,%o7,%g4
/* 0x30e8	     */		sra	%l7,0,%o1
/* 0x30ec	     */		sra	%g3,0,%g3
/* 0x30f0	     */		sub	%g3,%o0,%o7
/* 0x30f4	     */		sub	%o1,%o0,%o4
/* 0x30f8	     */		srlx	%o7,63,%g3
/* 0x30fc	     */		srlx	%o4,63,%l7
/* 0x3100	     */		xor	%g3,1,%l5
/* 0x3104	     */		xor	%l7,1,%o1
/* 0x3108	     */		and	%o1,%l5,%l4
/* 0x310c	     */		and	%g4,%l4,%o7
/* 0x3110	     */		sra	%l3,0,%g4
/* 0x3114	     */		sub	%g4,%o0,%o3
/* 0x3118	     */		sra	%i3,0,%o4
/* 0x311c	     */		sub	%o4,%o0,%o0
/* 0x3120	     */		srlx	%o3,63,%l3
/* 0x3124	     */		srlx	%o0,63,%i3
/* 0x3128	     */		xor	%l3,1,%g5
/* 0x312c	     */		xor	%i3,1,%o2
/* 0x3130	     */		and	%g5,%o2,%g2
/* 0x3134	     */		andcc	%o7,%g2,%g0
/* 0x3138	     */		be,a,pn	%icc,.L77004920
/* 0x313c	     */		or	%g0,0,%l4

! Registers live out of .L77004928: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004928

			.L77005101:
/* 0x3140	 672 */		sethi	%hi(0x1000),%g1
/* 0x3144	     */		xor	%g1,-704,%g1
/* 0x3148	     */		add	%g1,%fp,%l6
/* 0x314c	     */		sethi	%hi(0x2400),%g1
/* 0x3150	     */		xor	%g1,-384,%g1
/* 0x3154	     */		add	%g1,%fp,%l5
/* 0x3158	     */		sethi	%hi(0x3800),%g1
/* 0x315c	     */		xor	%g1,-64,%g1
/* 0x3160	     */		add	%g1,%fp,%l4
/* 0x3164	     */		sethi	%hi(0x4800),%g1
/* 0x3168	     */		xor	%g1,-768,%g1
/* 0x316c	     */		add	%i1,-1,%g2
/* 0x3170	     */		or	%g0,0,%l7

!  673		      !            if (mask[i]) {

/* 0x3174	 673 */		ldub	[%l0],%o2
/* 0x3178	 672 */		add	%g1,%fp,%l3

! Registers live out of .L77005101: 
! g2 o2 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004773 .L77005101

			.L900000650:
/* 0x317c	 673 */		cmp	%o2,0
/* 0x3180	     */		be,pn	%icc,.L77004773
/* 0x3184	 672 */		add	%l7,1,%l7

! Registers live out of .L900000650: 
! g2 o2 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  674		      !               red[i]   = ~(red[i]   ^ rdest[i]);

                       
! predecessor blocks: .L900000650

			.L77004771:
/* 0x3188	 674 */		ldub	[%i4],%i1
/* 0x318c	     */		ldub	[%l6],%o0

!  675		      !               green[i] = ~(green[i] ^ gdest[i]);

/* 0x3190	 675 */		ldub	[%i5],%o1

!  676		      !               blue[i]  = ~(blue[i]  ^ bdest[i]);

/* 0x3194	 676 */		ldub	[%i0],%l1

!  677		      !               alpha[i] = ~(alpha[i] ^ adest[i]);

/* 0x3198	 677 */		ldub	[%i2],%g5
/* 0x319c	 675 */		ldub	[%l5],%o2
/* 0x31a0	 674 */		xor	%i1,%o0,%o4
/* 0x31a4	 676 */		ldub	[%l4],%i3
/* 0x31a8	 675 */		xor	%o1,%o2,%l2
/* 0x31ac	 677 */		ldub	[%l3],%g4
/* 0x31b0	 676 */		xor	%l1,%i3,%o7
/* 0x31b4	 674 */		xnor	%o4,0,%o3
/* 0x31b8	     */		stb	%o3,[%i4]
/* 0x31bc	 677 */		xor	%g5,%g4,%o0
/* 0x31c0	 675 */		xnor	%l2,0,%o5
/* 0x31c4	     */		stb	%o5,[%i5]
/* 0x31c8	 676 */		xnor	%o7,0,%g3
/* 0x31cc	     */		stb	%g3,[%i0]
/* 0x31d0	 677 */		xnor	%o0,0,%i1
/* 0x31d4	     */		stb	%i1,[%i2]

! Registers live out of .L77004771: 
! g2 o2 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004771 .L900000650

			.L77004773:
/* 0x31d8	 672 */		cmp	%l7,%g2
/* 0x31dc	     */		add	%l0,1,%l0
/* 0x31e0	     */		add	%l3,1,%l3
/* 0x31e4	     */		add	%l4,1,%l4
/* 0x31e8	     */		add	%l5,1,%l5
/* 0x31ec	     */		add	%l6,1,%l6
/* 0x31f0	     */		add	%i2,1,%i2
/* 0x31f4	     */		add	%i0,1,%i0
/* 0x31f8	     */		add	%i5,1,%i5
/* 0x31fc	     */		add	%i4,1,%i4
/* 0x3200	     */		ble,a,pt	%icc,.L900000650
/* 0x3204	 673 */		ldub	[%l0],%o2

! Registers live out of .L77004773: 
! g2 o2 sp l0 l4 l5 l6 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004773

			.L77004923:
/* 0x3208	 672 */		ba	.L77004840
/* 0x320c	     */		nop

! Registers live out of .L77004923: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004862

			.L77005251:
/* 0x3210	 672 */		ld	[%fp+92],%i0
/* 0x3214	     */		ld	[%fp+96],%i2
/* 0x3218	     */		or	%g0,0,%l4

! Registers live out of .L77005251: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004926 .L77004927 .L77004928 .L77005251

			.L77004920:
/* 0x321c	 673 */		ldub	[%l4+%l0],%i3

! Registers live out of .L77004920: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004920 .L77004922

			.L900000649:
/* 0x3220	 673 */		cmp	%i3,0
/* 0x3224	     */		be,pn	%icc,.L77004922
/* 0x3228	 674 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000649: 
! g1 sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000649

			.L77004921:
/* 0x322c	 674 */		xor	%g1,-704,%g1
/* 0x3230	     */		add	%g1,%fp,%o7
/* 0x3234	     */		ldub	[%l4+%o7],%o0
/* 0x3238	     */		ldub	[%i4+%l4],%i3
/* 0x323c	     */		xor	%i3,%o0,%o1
/* 0x3240	     */		xnor	%o1,0,%o7
/* 0x3244	     */		stb	%o7,[%i4+%l4]
/* 0x3248	 675 */		ldub	[%l4+%l6],%g5
/* 0x324c	     */		ldub	[%i5+%l4],%o4
/* 0x3250	     */		xor	%o4,%g5,%g2
/* 0x3254	     */		xnor	%g2,0,%o2
/* 0x3258	     */		stb	%o2,[%i5+%l4]
/* 0x325c	 676 */		ldub	[%l4+%l2],%o3
/* 0x3260	     */		ldub	[%l4+%i0],%l5
/* 0x3264	     */		xor	%l5,%o3,%o5
/* 0x3268	     */		xnor	%o5,0,%l3
/* 0x326c	     */		stb	%l3,[%l4+%i0]
/* 0x3270	 677 */		ldub	[%l4+%l1],%g3
/* 0x3274	     */		ldub	[%l4+%i2],%l7
/* 0x3278	     */		xor	%l7,%g3,%g4
/* 0x327c	     */		xnor	%g4,0,%o0
/* 0x3280	     */		stb	%o0,[%l4+%i2]

! Registers live out of .L77004921: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004921 .L900000649

			.L77004922:
/* 0x3284	 672 */		add	%l4,1,%l4
/* 0x3288	     */		cmp	%l4,%i1
/* 0x328c	     */		bcs,a,pn	%icc,.L900000649
/* 0x3290	 673 */		ldub	[%l4+%l0],%i3

! Registers live out of .L77004922: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004922

			.L900000628:
/* 0x3294	 672 */		ba	.L77004840
/* 0x3298	     */		nop

! Registers live out of .L900000628: 
! sp fp i7 gsr 
! 
		
!  678		      !            }
!  679		      !         }
!  680		      !         break;
!  681		      !      case GL_AND_REVERSE:
!  682		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004779:
/* 0x329c	 682 */		cmp	%i1,0
/* 0x32a0	     */		bleu,pn	%icc,.L77004840
/* 0x32a4	     */		cmp	%i1,54

! Registers live out of .L77004779: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004779

			.L77004868:
/* 0x32a8	 682 */		bl,pn	%icc,.L77005239
/* 0x32ac	     */		add	%o2,1022,%o7

! Registers live out of .L77004868: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004868

			.L77004998:
/* 0x32b0	 682 */		sethi	%hi(0x1000),%g1
/* 0x32b4	     */		sub	%i4,%i5,%i0
/* 0x32b8	     */		sub	%i4,%l6,%o2
/* 0x32bc	     */		xor	%g1,-704,%g1
/* 0x32c0	     */		sra	%i0,31,%o0
/* 0x32c4	     */		sra	%o2,31,%g4
/* 0x32c8	     */		add	%g1,%fp,%o3
/* 0x32cc	     */		sub	%i4,%o3,%o1
/* 0x32d0	     */		xor	%i0,%o0,%i2
/* 0x32d4	     */		xor	%o2,%g4,%i3
/* 0x32d8	     */		sub	%i2,%o0,%l7
/* 0x32dc	     */		sra	%o1,31,%l3
/* 0x32e0	     */		sub	%i4,%l0,%o2
/* 0x32e4	     */		xor	%o1,%l3,%o4
/* 0x32e8	     */		sra	%o2,31,%i2
/* 0x32ec	     */		sub	%i3,%g4,%g3
/* 0x32f0	     */		sub	%i4,%l1,%o3
/* 0x32f4	     */		sub	%o4,%l3,%l4
/* 0x32f8	     */		sra	%o3,31,%i0
/* 0x32fc	     */		xor	%o2,%i2,%i3
/* 0x3300	     */		xor	%o3,%i0,%o5
/* 0x3304	     */		sub	%i3,%i2,%l3
/* 0x3308	     */		sub	%o5,%i0,%o0
/* 0x330c	     */		sub	%i4,%l2,%l5
/* 0x3310	     */		sra	%l5,31,%g5
/* 0x3314	     */		xor	%l5,%g5,%g2
/* 0x3318	     */		sub	%g2,%g5,%l5
/* 0x331c	     */		sra	%l7,0,%o1
/* 0x3320	     */		sra	%g3,0,%g3
/* 0x3324	     */		sra	%l4,0,%g4
/* 0x3328	     */		ld	[%fp+96],%i2
/* 0x332c	     */		ld	[%fp+92],%i0
/* 0x3330	     */		sub	%i4,%i2,%o3
/* 0x3334	     */		sra	%o3,31,%i3
/* 0x3338	     */		sub	%i4,%i0,%o4
/* 0x333c	     */		sra	%o4,31,%g5
/* 0x3340	     */		xor	%o3,%i3,%o5
/* 0x3344	     */		xor	%o4,%g5,%g2
/* 0x3348	     */		sra	%o0,0,%o3
/* 0x334c	     */		sra	%i1,0,%o0
/* 0x3350	     */		sub	%g2,%g5,%o2
/* 0x3354	     */		sub	%o5,%i3,%l7
/* 0x3358	     */		sub	%o1,%o0,%g2
/* 0x335c	     */		srlx	%g2,63,%i3
/* 0x3360	     */		sra	%l5,0,%g5
/* 0x3364	     */		sub	%g3,%o0,%g2
/* 0x3368	     */		sra	%l7,0,%o4
/* 0x336c	     */		sub	%g4,%o0,%g3
/* 0x3370	     */		sub	%g5,%o0,%o1
/* 0x3374	     */		srlx	%g3,63,%l4
/* 0x3378	     */		sub	%o3,%o0,%g4
/* 0x337c	     */		sub	%o4,%o0,%g5
/* 0x3380	     */		srlx	%g2,63,%g2
/* 0x3384	     */		sra	%l3,0,%o5
/* 0x3388	     */		srlx	%g4,63,%g3
/* 0x338c	     */		xor	%g2,1,%o4
/* 0x3390	     */		srlx	%g5,63,%g4
/* 0x3394	     */		sub	%o5,%o0,%g2
/* 0x3398	     */		srlx	%o1,63,%l5
/* 0x339c	     */		xor	%g4,1,%o5
/* 0x33a0	     */		xor	%i3,1,%o1
/* 0x33a4	     */		srl	%i1,0,%g4
/* 0x33a8	     */		sra	%o2,0,%o2
/* 0x33ac	     */		and	%o4,%o1,%g5
/* 0x33b0	     */		sub	%g4,%o7,%o7
/* 0x33b4	     */		sub	%o2,%o0,%o2
/* 0x33b8	     */		srlx	%o2,63,%o2
/* 0x33bc	     */		xor	%l4,1,%o1
/* 0x33c0	     */		srlx	%o7,63,%o4
/* 0x33c4	     */		xor	%l5,1,%l3
/* 0x33c8	     */		xor	%o2,1,%o3
/* 0x33cc	     */		and	%o4,%o1,%l4
/* 0x33d0	     */		and	%l3,%o3,%l5
/* 0x33d4	     */		and	%l4,%g5,%o2
/* 0x33d8	     */		srlx	%g2,63,%i3
/* 0x33dc	     */		xor	%g3,1,%l7
/* 0x33e0	     */		and	%l7,%o5,%o3
/* 0x33e4	     */		xor	%i3,1,%g2
/* 0x33e8	     */		and	%o2,%l5,%l3
/* 0x33ec	     */		and	%g2,1,%g3
/* 0x33f0	     */		and	%l3,%o3,%g4
/* 0x33f4	     */		andcc	%g4,%g3,%g0
/* 0x33f8	     */		be,a,pn	%icc,.L77004992
/* 0x33fc	     */		or	%g0,0,%l4

! Registers live out of .L77004998: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004998

			.L77004999:
/* 0x3400	 682 */		sub	%i5,%i0,%o5
/* 0x3404	     */		sethi	%hi(0x1000),%g1
/* 0x3408	     */		sra	%o5,31,%l4
/* 0x340c	     */		xor	%g1,-704,%g1
/* 0x3410	     */		xor	%o5,%l4,%l3
/* 0x3414	     */		sub	%i5,%l2,%l5
/* 0x3418	     */		sub	%i5,%l6,%l7
/* 0x341c	     */		add	%g1,%fp,%o1
/* 0x3420	     */		sub	%i5,%o1,%g3
/* 0x3424	     */		sub	%l3,%l4,%g2
/* 0x3428	     */		sra	%l5,31,%i3
/* 0x342c	     */		sra	%l7,31,%o5
/* 0x3430	     */		xor	%l5,%i3,%o4
/* 0x3434	     */		sra	%g3,31,%l4
/* 0x3438	     */		sub	%i5,%l1,%o3
/* 0x343c	     */		xor	%l7,%o5,%o2
/* 0x3440	     */		xor	%g3,%l4,%l3
/* 0x3444	     */		sub	%i5,%i2,%o7
/* 0x3448	     */		sub	%o4,%i3,%g5
/* 0x344c	     */		sra	%o3,31,%l7
/* 0x3450	     */		sub	%i0,%o1,%o4
/* 0x3454	     */		sra	%o7,31,%l5
/* 0x3458	     */		xor	%o3,%l7,%i3
/* 0x345c	     */		sub	%l3,%l4,%g4
/* 0x3460	     */		xor	%o7,%l5,%o1
/* 0x3464	     */		sub	%i5,%l0,%l4
/* 0x3468	     */		sub	%i3,%l7,%l7
/* 0x346c	     */		sra	%l4,31,%l3
/* 0x3470	     */		sub	%o1,%l5,%g3
/* 0x3474	     */		sra	%o4,31,%i3
/* 0x3478	     */		sub	%o2,%o5,%o2
/* 0x347c	     */		xor	%l4,%l3,%o7
/* 0x3480	     */		xor	%o4,%i3,%o1
/* 0x3484	     */		sub	%i0,%l6,%o5
/* 0x3488	     */		sra	%o5,31,%l4
/* 0x348c	     */		sub	%i0,%l2,%o3
/* 0x3490	     */		sub	%o1,%i3,%i3
/* 0x3494	     */		sub	%o7,%l3,%l5
/* 0x3498	     */		xor	%o5,%l4,%o4
/* 0x349c	     */		sra	%o3,31,%o1
/* 0x34a0	     */		sub	%o4,%l4,%l3
/* 0x34a4	     */		xor	%o3,%o1,%o7
/* 0x34a8	     */		sub	%o7,%o1,%l4
/* 0x34ac	     */		sra	%g2,0,%o3
/* 0x34b0	     */		sra	%g5,0,%g5
/* 0x34b4	     */		sub	%o3,%o0,%o1
/* 0x34b8	     */		sub	%g5,%o0,%o7
/* 0x34bc	     */		srlx	%o1,63,%g2
/* 0x34c0	     */		srlx	%o7,63,%g5
/* 0x34c4	     */		xor	%g2,1,%o3
/* 0x34c8	     */		xor	%g5,1,%o5
/* 0x34cc	     */		and	%o5,%o3,%o7
/* 0x34d0	     */		sra	%o2,0,%o2
/* 0x34d4	     */		sra	%g4,0,%g4
/* 0x34d8	     */		sub	%o2,%o0,%o5
/* 0x34dc	     */		sub	%g4,%o0,%o4
/* 0x34e0	     */		srlx	%o5,63,%o2
/* 0x34e4	     */		srlx	%o4,63,%g4
/* 0x34e8	     */		xor	%o2,1,%o1
/* 0x34ec	     */		xor	%g4,1,%o4
/* 0x34f0	     */		and	%o4,%o1,%g2
/* 0x34f4	     */		and	%g2,%o7,%o5
/* 0x34f8	     */		sra	%l7,0,%o3
/* 0x34fc	     */		sra	%g3,0,%g3
/* 0x3500	     */		sub	%g3,%o0,%g2
/* 0x3504	     */		sub	%o3,%o0,%o1
/* 0x3508	     */		srlx	%g2,63,%g3
/* 0x350c	     */		srlx	%o1,63,%l7
/* 0x3510	     */		xor	%g3,1,%g5
/* 0x3514	     */		xor	%l7,1,%o3
/* 0x3518	     */		and	%o3,%g5,%o2
/* 0x351c	     */		and	%o5,%o2,%o4
/* 0x3520	     */		sra	%i3,0,%o2
/* 0x3524	     */		sra	%l5,0,%g5
/* 0x3528	     */		sub	%o2,%o0,%o5
/* 0x352c	     */		sub	%g5,%o0,%o7
/* 0x3530	     */		sra	%l3,0,%o2
/* 0x3534	     */		sra	%l4,0,%g2
/* 0x3538	     */		srlx	%o7,63,%l5
/* 0x353c	     */		srlx	%o5,63,%i3
/* 0x3540	     */		sub	%o2,%o0,%g5
/* 0x3544	     */		sub	%g2,%o0,%g3
/* 0x3548	     */		srlx	%g3,63,%l4
/* 0x354c	     */		srlx	%g5,63,%l3
/* 0x3550	     */		xor	%l5,1,%g4
/* 0x3554	     */		xor	%i3,1,%o7
/* 0x3558	     */		xor	%l4,1,%g5
/* 0x355c	     */		and	%o7,%g4,%o1
/* 0x3560	     */		xor	%l3,1,%l7
/* 0x3564	     */		and	%o4,%o1,%o5
/* 0x3568	     */		and	%g5,%l7,%o3
/* 0x356c	     */		andcc	%o5,%o3,%g0
/* 0x3570	     */		be,a,pn	%icc,.L77004992
/* 0x3574	     */		or	%g0,0,%l4

! Registers live out of .L77004999: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004999

			.L77005000:
/* 0x3578	 682 */		sethi	%hi(0x1000),%g1
/* 0x357c	     */		xor	%g1,-704,%g1
/* 0x3580	     */		add	%g1,%fp,%g4
/* 0x3584	     */		sub	%i2,%g4,%g5
/* 0x3588	     */		sra	%g5,31,%o4
/* 0x358c	     */		sub	%i0,%l0,%o2
/* 0x3590	     */		sra	%o2,31,%o7
/* 0x3594	     */		xor	%g5,%o4,%o1
/* 0x3598	     */		sub	%i0,%i2,%l7
/* 0x359c	     */		xor	%o2,%o7,%i3
/* 0x35a0	     */		sub	%o1,%o4,%l5
/* 0x35a4	     */		sra	%l7,31,%o5
/* 0x35a8	     */		sub	%i2,%l6,%g3
/* 0x35ac	     */		sub	%i3,%o7,%l4
/* 0x35b0	     */		xor	%l7,%o5,%o3
/* 0x35b4	     */		sra	%g3,31,%o4
/* 0x35b8	     */		sub	%i0,%l1,%g2
/* 0x35bc	     */		sra	%g2,31,%o7
/* 0x35c0	     */		xor	%g3,%o4,%o1
/* 0x35c4	     */		sub	%o3,%o5,%o2
/* 0x35c8	     */		sub	%i2,%l2,%g4
/* 0x35cc	     */		xor	%g2,%o7,%o5
/* 0x35d0	     */		sra	%g4,31,%i3
/* 0x35d4	     */		sub	%i2,%l1,%o3
/* 0x35d8	     */		sub	%o1,%o4,%g3
/* 0x35dc	     */		sra	%o3,31,%o1
/* 0x35e0	     */		sub	%o5,%o7,%g5
/* 0x35e4	     */		sub	%i2,%l0,%g2
/* 0x35e8	     */		xor	%g4,%i3,%g4
/* 0x35ec	     */		sub	%g4,%i3,%l7
/* 0x35f0	     */		xor	%o3,%o1,%o7
/* 0x35f4	     */		sra	%g2,31,%l3
/* 0x35f8	     */		xor	%g2,%l3,%o5
/* 0x35fc	     */		sub	%o7,%o1,%i3
/* 0x3600	     */		sub	%o5,%l3,%l3
/* 0x3604	     */		sra	%l4,0,%o7
/* 0x3608	     */		sra	%l5,0,%o4
/* 0x360c	     */		sra	%o2,0,%o2
/* 0x3610	     */		sra	%g5,0,%g5
/* 0x3614	     */		sub	%o7,%o0,%o1
/* 0x3618	     */		sub	%o4,%o0,%o3
/* 0x361c	     */		sub	%o2,%o0,%o5
/* 0x3620	     */		sub	%g5,%o0,%g2
/* 0x3624	     */		srlx	%o1,63,%l4
/* 0x3628	     */		srlx	%o3,63,%l5
/* 0x362c	     */		srlx	%o5,63,%o2
/* 0x3630	     */		srlx	%g2,63,%g5
/* 0x3634	     */		xor	%l4,1,%g4
/* 0x3638	     */		xor	%l5,1,%o4
/* 0x363c	     */		xor	%o2,1,%o3
/* 0x3640	     */		xor	%g5,1,%g2
/* 0x3644	     */		and	%o4,%g4,%o7
/* 0x3648	     */		and	%o3,%g2,%o5
/* 0x364c	     */		and	%o5,%o7,%g4
/* 0x3650	     */		sra	%l7,0,%o1
/* 0x3654	     */		sra	%g3,0,%g3
/* 0x3658	     */		sub	%g3,%o0,%o7
/* 0x365c	     */		sub	%o1,%o0,%o4
/* 0x3660	     */		srlx	%o7,63,%g3
/* 0x3664	     */		srlx	%o4,63,%l7
/* 0x3668	     */		xor	%g3,1,%l5
/* 0x366c	     */		xor	%l7,1,%o1
/* 0x3670	     */		and	%o1,%l5,%l4
/* 0x3674	     */		and	%g4,%l4,%o7
/* 0x3678	     */		sra	%l3,0,%g4
/* 0x367c	     */		sub	%g4,%o0,%o3
/* 0x3680	     */		sra	%i3,0,%o4
/* 0x3684	     */		sub	%o4,%o0,%o0
/* 0x3688	     */		srlx	%o3,63,%l3
/* 0x368c	     */		srlx	%o0,63,%i3
/* 0x3690	     */		xor	%l3,1,%g5
/* 0x3694	     */		xor	%i3,1,%o2
/* 0x3698	     */		and	%g5,%o2,%g2
/* 0x369c	     */		andcc	%o7,%g2,%g0
/* 0x36a0	     */		be,a,pn	%icc,.L77004992
/* 0x36a4	     */		or	%g0,0,%l4

! Registers live out of .L77005000: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77005000

			.L77005107:
/* 0x36a8	 682 */		sethi	%hi(0x1000),%g1
/* 0x36ac	     */		xor	%g1,-704,%g1
/* 0x36b0	     */		add	%g1,%fp,%g3
/* 0x36b4	     */		sethi	%hi(0x2400),%g1
/* 0x36b8	     */		xor	%g1,-384,%g1
/* 0x36bc	     */		add	%g1,%fp,%g2
/* 0x36c0	     */		sethi	%hi(0x3800),%g1
/* 0x36c4	     */		xor	%g1,-64,%g1
/* 0x36c8	     */		add	%g1,%fp,%l7
/* 0x36cc	     */		sethi	%hi(0x4800),%g1
/* 0x36d0	     */		xor	%g1,-768,%g1
/* 0x36d4	     */		add	%i1,-1,%g5
/* 0x36d8	     */		or	%g0,0,%g4

!  683		      !            if (mask[i]) {

/* 0x36dc	 683 */		ldub	[%l0],%l4
/* 0x36e0	 682 */		add	%g1,%fp,%o7

! Registers live out of .L77005107: 
! g2 g3 g4 g5 sp o7 l0 l4 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004787 .L77005107

			.L900000648:
/* 0x36e4	 683 */		cmp	%l4,0
/* 0x36e8	     */		be,pn	%icc,.L77004787
/* 0x36ec	 682 */		add	%g4,1,%g4

! Registers live out of .L900000648: 
! g2 g3 g4 g5 sp o7 l0 l4 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  684		      !               red[i]   = red[i]   & ~rdest[i];

                       
! predecessor blocks: .L900000648

			.L77004785:
/* 0x36f0	 684 */		ldub	[%i4],%i3

!  685		      !               green[i] = green[i] & ~gdest[i];

/* 0x36f4	 685 */		ldub	[%i5],%l1

!  686		      !               blue[i]  = blue[i]  & ~bdest[i];

/* 0x36f8	 686 */		ldub	[%i0],%o3

!  687		      !               alpha[i] = alpha[i] & ~adest[i];

/* 0x36fc	 687 */		ldub	[%i2],%l5
/* 0x3700	 684 */		ldub	[%g3],%i1
/* 0x3704	 685 */		ldub	[%g2],%o1
/* 0x3708	 686 */		ldub	[%l7],%o4
/* 0x370c	 687 */		ldub	[%o7],%l3
/* 0x3710	 684 */		andn	%i3,%i1,%o2
/* 0x3714	     */		stb	%o2,[%i4]
/* 0x3718	 685 */		andn	%l1,%o1,%l2
/* 0x371c	     */		stb	%l2,[%i5]
/* 0x3720	 686 */		andn	%o3,%o4,%o5
/* 0x3724	     */		stb	%o5,[%i0]
/* 0x3728	 687 */		andn	%l5,%l3,%l6
/* 0x372c	     */		stb	%l6,[%i2]

! Registers live out of .L77004785: 
! g2 g3 g4 g5 sp o7 l0 l4 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004785 .L900000648

			.L77004787:
/* 0x3730	 682 */		cmp	%g4,%g5
/* 0x3734	     */		add	%l0,1,%l0
/* 0x3738	     */		add	%o7,1,%o7
/* 0x373c	     */		add	%l7,1,%l7
/* 0x3740	     */		add	%g2,1,%g2
/* 0x3744	     */		add	%g3,1,%g3
/* 0x3748	     */		add	%i2,1,%i2
/* 0x374c	     */		add	%i0,1,%i0
/* 0x3750	     */		add	%i5,1,%i5
/* 0x3754	     */		add	%i4,1,%i4
/* 0x3758	     */		ble,a,pt	%icc,.L900000648
/* 0x375c	 683 */		ldub	[%l0],%l4

! Registers live out of .L77004787: 
! g2 g3 g4 g5 sp o7 l0 l4 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004787

			.L77004995:
/* 0x3760	 682 */		ba	.L77004840
/* 0x3764	     */		nop

! Registers live out of .L77004995: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004868

			.L77005239:
/* 0x3768	 682 */		ld	[%fp+92],%i0
/* 0x376c	     */		ld	[%fp+96],%i2
/* 0x3770	     */		or	%g0,0,%l4

! Registers live out of .L77005239: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004998 .L77004999 .L77005000 .L77005239

			.L77004992:
/* 0x3774	 683 */		ldub	[%l4+%l0],%l3

! Registers live out of .L77004992: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004992 .L77004994

			.L900000647:
/* 0x3778	 683 */		cmp	%l3,0
/* 0x377c	     */		be,pn	%icc,.L77004994
/* 0x3780	 684 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000647: 
! g1 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000647

			.L77004993:
/* 0x3784	 684 */		xor	%g1,-704,%g1
/* 0x3788	     */		add	%g1,%fp,%g3
/* 0x378c	     */		ldub	[%l4+%g3],%o0
/* 0x3790	     */		ldub	[%i4+%l4],%o5
/* 0x3794	     */		andn	%o5,%o0,%l7
/* 0x3798	     */		stb	%l7,[%i4+%l4]
/* 0x379c	 685 */		ldub	[%l4+%l6],%o7
/* 0x37a0	     */		ldub	[%i5+%l4],%g5
/* 0x37a4	     */		andn	%g5,%o7,%o1
/* 0x37a8	     */		stb	%o1,[%i5+%l4]
/* 0x37ac	 686 */		ldub	[%l4+%l2],%i3
/* 0x37b0	     */		ldub	[%l4+%i0],%g2
/* 0x37b4	     */		andn	%g2,%i3,%o4
/* 0x37b8	     */		stb	%o4,[%l4+%i0]
/* 0x37bc	 687 */		ldub	[%l4+%l1],%l5
/* 0x37c0	     */		ldub	[%l4+%i2],%o2
/* 0x37c4	     */		andn	%o2,%l5,%o3
/* 0x37c8	     */		stb	%o3,[%l4+%i2]

! Registers live out of .L77004993: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004993 .L900000647

			.L77004994:
/* 0x37cc	 682 */		add	%l4,1,%l4
/* 0x37d0	     */		cmp	%l4,%i1
/* 0x37d4	     */		bcs,a,pn	%icc,.L900000647
/* 0x37d8	 683 */		ldub	[%l4+%l0],%l3

! Registers live out of .L77004994: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004994

			.L900000627:
/* 0x37dc	 682 */		ba	.L77004840
/* 0x37e0	     */		nop

! Registers live out of .L900000627: 
! sp fp i7 gsr 
! 
		
!  688		      !            }
!  689		      !         }
!  690		      !         break;
!  691		      !      case GL_AND_INVERTED:
!  692		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004793:
/* 0x37e4	 692 */		cmp	%i1,0
/* 0x37e8	     */		bleu,pn	%icc,.L77004840
/* 0x37ec	     */		cmp	%i1,54

! Registers live out of .L77004793: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004793

			.L77004867:
/* 0x37f0	 692 */		bl,pn	%icc,.L77005241
/* 0x37f4	     */		add	%o2,1022,%o7

! Registers live out of .L77004867: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004867

			.L77004986:
/* 0x37f8	 692 */		sethi	%hi(0x1000),%g1
/* 0x37fc	     */		sub	%i4,%i5,%i0
/* 0x3800	     */		sub	%i4,%l6,%o2
/* 0x3804	     */		xor	%g1,-704,%g1
/* 0x3808	     */		sra	%i0,31,%o0
/* 0x380c	     */		sra	%o2,31,%g4
/* 0x3810	     */		add	%g1,%fp,%o4
/* 0x3814	     */		xor	%i0,%o0,%i2
/* 0x3818	     */		xor	%o2,%g4,%i3
/* 0x381c	     */		sub	%i4,%o4,%o4
/* 0x3820	     */		sub	%i2,%o0,%l7
/* 0x3824	     */		sra	%o4,31,%l3
/* 0x3828	     */		sub	%i4,%l0,%o2
/* 0x382c	     */		xor	%o4,%l3,%g2
/* 0x3830	     */		sra	%o2,31,%i2
/* 0x3834	     */		sub	%i3,%g4,%g3
/* 0x3838	     */		sub	%i4,%l1,%o3
/* 0x383c	     */		sub	%g2,%l3,%l4
/* 0x3840	     */		sra	%o3,31,%i0
/* 0x3844	     */		xor	%o2,%i2,%i3
/* 0x3848	     */		xor	%o3,%i0,%o5
/* 0x384c	     */		sub	%i3,%i2,%l3
/* 0x3850	     */		sub	%o5,%i0,%o0
/* 0x3854	     */		sub	%i4,%l2,%l5
/* 0x3858	     */		sra	%l5,31,%g5
/* 0x385c	     */		xor	%l5,%g5,%o1
/* 0x3860	     */		sub	%o1,%g5,%l5
/* 0x3864	     */		sra	%l7,0,%o1
/* 0x3868	     */		sra	%g3,0,%g3
/* 0x386c	     */		sra	%l4,0,%g4
/* 0x3870	     */		ld	[%fp+96],%i2
/* 0x3874	     */		ld	[%fp+92],%i0
/* 0x3878	     */		sub	%i4,%i2,%o3
/* 0x387c	     */		sra	%o3,31,%i3
/* 0x3880	     */		sub	%i4,%i0,%o4
/* 0x3884	     */		sra	%o4,31,%g5
/* 0x3888	     */		xor	%o3,%i3,%o5
/* 0x388c	     */		xor	%o4,%g5,%g2
/* 0x3890	     */		sra	%o0,0,%o3
/* 0x3894	     */		sra	%i1,0,%o0
/* 0x3898	     */		sub	%g2,%g5,%o2
/* 0x389c	     */		sub	%o1,%o0,%g2
/* 0x38a0	     */		sra	%l5,0,%g5
/* 0x38a4	     */		sub	%g3,%o0,%o1
/* 0x38a8	     */		sub	%o5,%i3,%l7
/* 0x38ac	     */		sub	%g5,%o0,%g3
/* 0x38b0	     */		sra	%l3,0,%o5
/* 0x38b4	     */		srlx	%g3,63,%l5
/* 0x38b8	     */		sra	%o2,0,%o2
/* 0x38bc	     */		srlx	%o1,63,%l3
/* 0x38c0	     */		sub	%o2,%o0,%g3
/* 0x38c4	     */		sra	%l7,0,%o4
/* 0x38c8	     */		srlx	%g3,63,%o2
/* 0x38cc	     */		sub	%o3,%o0,%o1
/* 0x38d0	     */		srlx	%g2,63,%i3
/* 0x38d4	     */		srlx	%o1,63,%g3
/* 0x38d8	     */		sub	%o4,%o0,%o3
/* 0x38dc	     */		xor	%i3,1,%o1
/* 0x38e0	     */		xor	%l3,1,%o4
/* 0x38e4	     */		sub	%g4,%o0,%g2
/* 0x38e8	     */		and	%o4,%o1,%g5
/* 0x38ec	     */		srlx	%o3,63,%g4
/* 0x38f0	     */		sub	%o5,%o0,%o1
/* 0x38f4	     */		xor	%l5,1,%o5
/* 0x38f8	     */		xor	%o2,1,%o3
/* 0x38fc	     */		and	%o5,%o3,%l5
/* 0x3900	     */		srlx	%g2,63,%l4
/* 0x3904	     */		srl	%i1,0,%o5
/* 0x3908	     */		xor	%l4,1,%o4
/* 0x390c	     */		sub	%o5,%o7,%o7
/* 0x3910	     */		srlx	%o7,63,%l4
/* 0x3914	     */		and	%l4,%o4,%o2
/* 0x3918	     */		srlx	%o1,63,%g2
/* 0x391c	     */		xor	%g3,1,%i3
/* 0x3920	     */		xor	%g4,1,%l7
/* 0x3924	     */		and	%o2,%g5,%o3
/* 0x3928	     */		and	%i3,%l7,%l3
/* 0x392c	     */		xor	%g2,1,%o1
/* 0x3930	     */		and	%o3,%l5,%o5
/* 0x3934	     */		and	%o1,1,%g3
/* 0x3938	     */		and	%o5,%l3,%g4
/* 0x393c	     */		andcc	%g4,%g3,%g0
/* 0x3940	     */		be,a,pn	%icc,.L77004980
/* 0x3944	     */		or	%g0,0,%l4

! Registers live out of .L77004986: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004986

			.L77004987:
/* 0x3948	 692 */		sub	%i5,%i0,%g2
/* 0x394c	     */		sethi	%hi(0x1000),%g1
/* 0x3950	     */		sra	%g2,31,%l4
/* 0x3954	     */		xor	%g1,-704,%g1
/* 0x3958	     */		xor	%g2,%l4,%o7
/* 0x395c	     */		sub	%i5,%l2,%l5
/* 0x3960	     */		add	%g1,%fp,%o5
/* 0x3964	     */		sub	%i5,%o5,%o4
/* 0x3968	     */		sub	%o7,%l4,%g2
/* 0x396c	     */		sra	%l5,31,%o1
/* 0x3970	     */		sub	%i5,%l6,%l7
/* 0x3974	     */		xor	%l5,%o1,%l3
/* 0x3978	     */		sra	%l7,31,%o7
/* 0x397c	     */		sra	%o4,31,%l4
/* 0x3980	     */		sub	%l3,%o1,%g5
/* 0x3984	     */		xor	%l7,%o7,%i3
/* 0x3988	     */		xor	%o4,%l4,%l5
/* 0x398c	     */		sub	%i5,%i2,%g3
/* 0x3990	     */		sub	%i3,%o7,%o2
/* 0x3994	     */		sub	%i0,%o5,%o4
/* 0x3998	     */		sra	%g3,31,%l3
/* 0x399c	     */		sub	%i5,%l1,%o3
/* 0x39a0	     */		xor	%g3,%l3,%o5
/* 0x39a4	     */		sra	%o3,31,%i3
/* 0x39a8	     */		xor	%o3,%i3,%o1
/* 0x39ac	     */		sub	%o5,%l3,%g3
/* 0x39b0	     */		sub	%o1,%i3,%l7
/* 0x39b4	     */		sra	%o4,31,%l3
/* 0x39b8	     */		sub	%l5,%l4,%g4
/* 0x39bc	     */		sub	%i5,%l0,%o7
/* 0x39c0	     */		sra	%o7,31,%l4
/* 0x39c4	     */		xor	%o4,%l3,%o1
/* 0x39c8	     */		sub	%o1,%l3,%i3
/* 0x39cc	     */		sub	%i0,%l6,%o5
/* 0x39d0	     */		sub	%i0,%l2,%o3
/* 0x39d4	     */		xor	%o7,%l4,%l5
/* 0x39d8	     */		sra	%o5,31,%o4
/* 0x39dc	     */		sra	%o3,31,%o1
/* 0x39e0	     */		sub	%l5,%l4,%l5
/* 0x39e4	     */		xor	%o5,%o4,%o7
/* 0x39e8	     */		xor	%o3,%o1,%l4
/* 0x39ec	     */		sub	%o7,%o4,%l3
/* 0x39f0	     */		sub	%l4,%o1,%l4
/* 0x39f4	     */		sra	%g2,0,%o4
/* 0x39f8	     */		sra	%g5,0,%o1
/* 0x39fc	     */		sub	%o4,%o0,%g2
/* 0x3a00	     */		sub	%o1,%o0,%g5
/* 0x3a04	     */		srlx	%g2,63,%g2
/* 0x3a08	     */		srlx	%g5,63,%g5
/* 0x3a0c	     */		xor	%g2,1,%o3
/* 0x3a10	     */		xor	%g5,1,%o5
/* 0x3a14	     */		and	%o5,%o3,%o4
/* 0x3a18	     */		sra	%o2,0,%o3
/* 0x3a1c	     */		sra	%g4,0,%g4
/* 0x3a20	     */		sub	%o3,%o0,%o7
/* 0x3a24	     */		sub	%g4,%o0,%o5
/* 0x3a28	     */		srlx	%o7,63,%o2
/* 0x3a2c	     */		srlx	%o5,63,%g4
/* 0x3a30	     */		xor	%o2,1,%o7
/* 0x3a34	     */		xor	%g4,1,%o1
/* 0x3a38	     */		and	%o1,%o7,%g2
/* 0x3a3c	     */		and	%g2,%o4,%o5
/* 0x3a40	     */		sra	%l7,0,%o4
/* 0x3a44	     */		sra	%g3,0,%g3
/* 0x3a48	     */		sub	%g3,%o0,%o2
/* 0x3a4c	     */		sub	%o4,%o0,%g2
/* 0x3a50	     */		srlx	%o2,63,%g3
/* 0x3a54	     */		srlx	%g2,63,%l7
/* 0x3a58	     */		xor	%g3,1,%g5
/* 0x3a5c	     */		xor	%l7,1,%o3
/* 0x3a60	     */		and	%o3,%g5,%o2
/* 0x3a64	     */		sra	%i3,0,%o3
/* 0x3a68	     */		sub	%o3,%o0,%o7
/* 0x3a6c	     */		sra	%l5,0,%o1
/* 0x3a70	     */		sra	%l3,0,%o3
/* 0x3a74	     */		sub	%o1,%o0,%g5
/* 0x3a78	     */		sub	%o3,%o0,%g3
/* 0x3a7c	     */		srlx	%g3,63,%l3
/* 0x3a80	     */		sra	%l4,0,%o1
/* 0x3a84	     */		srlx	%g5,63,%l5
/* 0x3a88	     */		srlx	%o7,63,%i3
/* 0x3a8c	     */		sub	%o1,%o0,%g3
/* 0x3a90	     */		srlx	%g3,63,%l4
/* 0x3a94	     */		xor	%l5,1,%g4
/* 0x3a98	     */		xor	%i3,1,%o4
/* 0x3a9c	     */		xor	%l4,1,%g5
/* 0x3aa0	     */		and	%o5,%o2,%g2
/* 0x3aa4	     */		and	%o4,%g4,%o7
/* 0x3aa8	     */		xor	%l3,1,%l7
/* 0x3aac	     */		and	%g2,%o7,%o5
/* 0x3ab0	     */		and	%g5,%l7,%o3
/* 0x3ab4	     */		andcc	%o5,%o3,%g0
/* 0x3ab8	     */		be,a,pn	%icc,.L77004980
/* 0x3abc	     */		or	%g0,0,%l4

! Registers live out of .L77004987: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004987

			.L77004988:
/* 0x3ac0	 692 */		sethi	%hi(0x1000),%g1
/* 0x3ac4	     */		xor	%g1,-704,%g1
/* 0x3ac8	     */		sub	%i0,%l0,%o5
/* 0x3acc	     */		sub	%i0,%i2,%l7
/* 0x3ad0	     */		add	%g1,%fp,%l5
/* 0x3ad4	     */		sub	%i2,%l5,%o1
/* 0x3ad8	     */		sra	%o5,31,%g5
/* 0x3adc	     */		sra	%l7,31,%o3
/* 0x3ae0	     */		xor	%o5,%g5,%o7
/* 0x3ae4	     */		sra	%o1,31,%o4
/* 0x3ae8	     */		sub	%i0,%l1,%g2
/* 0x3aec	     */		xor	%l7,%o3,%o2
/* 0x3af0	     */		xor	%o1,%o4,%i3
/* 0x3af4	     */		sra	%g2,31,%o5
/* 0x3af8	     */		sub	%i2,%l6,%g3
/* 0x3afc	     */		sub	%o2,%o3,%o2
/* 0x3b00	     */		sub	%o7,%g5,%l4
/* 0x3b04	     */		xor	%g2,%o5,%o3
/* 0x3b08	     */		sra	%g3,31,%o1
/* 0x3b0c	     */		xor	%g3,%o1,%o7
/* 0x3b10	     */		sub	%o3,%o5,%g5
/* 0x3b14	     */		sub	%i2,%l0,%g2
/* 0x3b18	     */		sub	%i3,%o4,%l5
/* 0x3b1c	     */		sub	%i2,%l1,%o3
/* 0x3b20	     */		sub	%o7,%o1,%g3
/* 0x3b24	     */		sra	%g2,31,%l3
/* 0x3b28	     */		xor	%g2,%l3,%i3
/* 0x3b2c	     */		sra	%o3,31,%o7
/* 0x3b30	     */		sub	%i2,%l2,%g4
/* 0x3b34	     */		sra	%g4,31,%o4
/* 0x3b38	     */		xor	%o3,%o7,%o5
/* 0x3b3c	     */		sub	%i3,%l3,%l3
/* 0x3b40	     */		sub	%o5,%o7,%i3
/* 0x3b44	     */		xor	%g4,%o4,%g4
/* 0x3b48	     */		sub	%g4,%o4,%l7
/* 0x3b4c	     */		sra	%l4,0,%o5
/* 0x3b50	     */		sra	%l5,0,%o1
/* 0x3b54	     */		sra	%o2,0,%o2
/* 0x3b58	     */		sra	%g5,0,%g5
/* 0x3b5c	     */		sub	%o5,%o0,%o7
/* 0x3b60	     */		sub	%o1,%o0,%o4
/* 0x3b64	     */		sub	%o2,%o0,%o3
/* 0x3b68	     */		sub	%g5,%o0,%g2
/* 0x3b6c	     */		srlx	%o7,63,%l4
/* 0x3b70	     */		srlx	%o4,63,%l5
/* 0x3b74	     */		srlx	%o3,63,%o2
/* 0x3b78	     */		srlx	%g2,63,%g5
/* 0x3b7c	     */		xor	%l4,1,%g4
/* 0x3b80	     */		xor	%l5,1,%o1
/* 0x3b84	     */		xor	%o2,1,%o3
/* 0x3b88	     */		xor	%g5,1,%o4
/* 0x3b8c	     */		and	%o1,%g4,%o5
/* 0x3b90	     */		and	%o3,%o4,%g2
/* 0x3b94	     */		and	%g2,%o5,%g4
/* 0x3b98	     */		sra	%l7,0,%o7
/* 0x3b9c	     */		sra	%g3,0,%g3
/* 0x3ba0	     */		sub	%o7,%o0,%o1
/* 0x3ba4	     */		sub	%g3,%o0,%o5
/* 0x3ba8	     */		srlx	%o1,63,%l7
/* 0x3bac	     */		srlx	%o5,63,%g3
/* 0x3bb0	     */		xor	%g3,1,%l5
/* 0x3bb4	     */		xor	%l7,1,%o7
/* 0x3bb8	     */		and	%o7,%l5,%l4
/* 0x3bbc	     */		and	%g4,%l4,%o3
/* 0x3bc0	     */		sra	%l3,0,%g4
/* 0x3bc4	     */		sub	%g4,%o0,%o4
/* 0x3bc8	     */		sra	%i3,0,%o1
/* 0x3bcc	     */		sub	%o1,%o0,%o0
/* 0x3bd0	     */		srlx	%o4,63,%l3
/* 0x3bd4	     */		srlx	%o0,63,%i3
/* 0x3bd8	     */		xor	%l3,1,%g5
/* 0x3bdc	     */		xor	%i3,1,%o2
/* 0x3be0	     */		and	%g5,%o2,%o4
/* 0x3be4	     */		andcc	%o3,%o4,%g0
/* 0x3be8	     */		be,a,pn	%icc,.L77004980
/* 0x3bec	     */		or	%g0,0,%l4

! Registers live out of .L77004988: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004988

			.L77005106:
/* 0x3bf0	 692 */		sethi	%hi(0x1000),%g1
/* 0x3bf4	     */		xor	%g1,-704,%g1
/* 0x3bf8	     */		add	%g1,%fp,%g4
/* 0x3bfc	     */		sethi	%hi(0x2400),%g1
/* 0x3c00	     */		xor	%g1,-384,%g1
/* 0x3c04	     */		add	%g1,%fp,%g3
/* 0x3c08	     */		sethi	%hi(0x3800),%g1
/* 0x3c0c	     */		xor	%g1,-64,%g1
/* 0x3c10	     */		add	%g1,%fp,%g2
/* 0x3c14	     */		sethi	%hi(0x4800),%g1
/* 0x3c18	     */		xor	%g1,-768,%g1
/* 0x3c1c	     */		add	%i1,-1,%o0
/* 0x3c20	     */		or	%g0,0,%g5

!  693		      !            if (mask[i]) {

/* 0x3c24	 693 */		ldub	[%l0],%o7
/* 0x3c28	 692 */		add	%g1,%fp,%l7

! Registers live out of .L77005106: 
! g2 g3 g4 g5 o0 sp o7 l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004801 .L77005106

			.L900000646:
/* 0x3c2c	 693 */		cmp	%o7,0
/* 0x3c30	     */		be,pn	%icc,.L77004801
/* 0x3c34	 692 */		add	%g5,1,%g5

! Registers live out of .L900000646: 
! g2 g3 g4 g5 o0 sp o7 l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		
!  694		      !               red[i]   = ~red[i]   & rdest[i];

                       
! predecessor blocks: .L900000646

			.L77004799:
/* 0x3c38	 694 */		ldub	[%i4],%i1

!  695		      !               green[i] = ~green[i] & gdest[i];

/* 0x3c3c	 695 */		ldub	[%i5],%l1

!  696		      !               blue[i]  = ~blue[i]  & bdest[i];

/* 0x3c40	 696 */		ldub	[%i0],%o3

!  697		      !               alpha[i] = ~alpha[i] & adest[i];

/* 0x3c44	 697 */		ldub	[%i2],%l5
/* 0x3c48	 694 */		ldub	[%g4],%o2
/* 0x3c4c	 695 */		ldub	[%g3],%l2
/* 0x3c50	 696 */		ldub	[%g2],%o5
/* 0x3c54	 697 */		ldub	[%l7],%l6
/* 0x3c58	 694 */		andn	%o2,%i1,%o1
/* 0x3c5c	     */		stb	%o1,[%i4]
/* 0x3c60	 695 */		andn	%l2,%l1,%o4
/* 0x3c64	     */		stb	%o4,[%i5]
/* 0x3c68	 696 */		andn	%o5,%o3,%l3
/* 0x3c6c	     */		stb	%l3,[%i0]
/* 0x3c70	 697 */		andn	%l6,%l5,%l4
/* 0x3c74	     */		stb	%l4,[%i2]

! Registers live out of .L77004799: 
! g2 g3 g4 g5 o0 sp o7 l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004799 .L900000646

			.L77004801:
/* 0x3c78	 692 */		cmp	%g5,%o0
/* 0x3c7c	     */		add	%l0,1,%l0
/* 0x3c80	     */		add	%l7,1,%l7
/* 0x3c84	     */		add	%g2,1,%g2
/* 0x3c88	     */		add	%g3,1,%g3
/* 0x3c8c	     */		add	%g4,1,%g4
/* 0x3c90	     */		add	%i2,1,%i2
/* 0x3c94	     */		add	%i0,1,%i0
/* 0x3c98	     */		add	%i5,1,%i5
/* 0x3c9c	     */		add	%i4,1,%i4
/* 0x3ca0	     */		ble,a,pt	%icc,.L900000646
/* 0x3ca4	 693 */		ldub	[%l0],%o7

! Registers live out of .L77004801: 
! g2 g3 g4 g5 o0 sp o7 l0 l7 i0 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004801

			.L77004983:
/* 0x3ca8	 692 */		ba	.L77004840
/* 0x3cac	     */		nop

! Registers live out of .L77004983: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004867

			.L77005241:
/* 0x3cb0	 692 */		ld	[%fp+92],%i0
/* 0x3cb4	     */		ld	[%fp+96],%i2
/* 0x3cb8	     */		or	%g0,0,%l4

! Registers live out of .L77005241: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004986 .L77004987 .L77004988 .L77005241

			.L77004980:
/* 0x3cbc	 693 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77004980: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004980 .L77004982

			.L900000645:
/* 0x3cc0	 693 */		cmp	%o5,0
/* 0x3cc4	     */		be,pn	%icc,.L77004982
/* 0x3cc8	 694 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000645: 
! g1 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000645

			.L77004981:
/* 0x3ccc	 694 */		xor	%g1,-704,%g1
/* 0x3cd0	     */		add	%g1,%fp,%o2
/* 0x3cd4	     */		ldub	[%l4+%o2],%l7
/* 0x3cd8	     */		ldub	[%i4+%l4],%o0
/* 0x3cdc	     */		andn	%l7,%o0,%i3
/* 0x3ce0	     */		stb	%i3,[%i4+%l4]
/* 0x3ce4	 695 */		ldub	[%i5+%l4],%o7
/* 0x3ce8	     */		ldub	[%l4+%l6],%g5
/* 0x3cec	     */		andn	%g5,%o7,%o4
/* 0x3cf0	     */		stb	%o4,[%i5+%l4]
/* 0x3cf4	 696 */		ldub	[%l4+%i0],%g2
/* 0x3cf8	     */		ldub	[%l4+%l2],%o1
/* 0x3cfc	     */		andn	%o1,%g2,%o2
/* 0x3d00	     */		stb	%o2,[%l4+%i0]
/* 0x3d04	 697 */		ldub	[%l4+%i2],%l5
/* 0x3d08	     */		ldub	[%l4+%l1],%o3
/* 0x3d0c	     */		andn	%o3,%l5,%l3
/* 0x3d10	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004981: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004981 .L900000645

			.L77004982:
/* 0x3d14	 692 */		add	%l4,1,%l4
/* 0x3d18	     */		cmp	%l4,%i1
/* 0x3d1c	     */		bcs,a,pn	%icc,.L900000645
/* 0x3d20	 693 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77004982: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004982

			.L900000626:
/* 0x3d24	 692 */		ba	.L77004840
/* 0x3d28	     */		nop

! Registers live out of .L900000626: 
! sp fp i7 gsr 
! 
		
!  698		      !            }
!  699		      !         }
!  700		      !         break;
!  701		      !      case GL_OR_REVERSE:
!  702		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004807:
/* 0x3d2c	 702 */		cmp	%i1,0
/* 0x3d30	     */		bleu,pn	%icc,.L77004840
/* 0x3d34	     */		cmp	%i1,54

! Registers live out of .L77004807: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004807

			.L77004860:
/* 0x3d38	 702 */		bl,pn	%icc,.L77005255
/* 0x3d3c	     */		add	%o2,1022,%o7

! Registers live out of .L77004860: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004860

			.L77004902:
/* 0x3d40	 702 */		sub	%i4,%i5,%i2
/* 0x3d44	     */		sra	%i2,31,%o0
/* 0x3d48	     */		xor	%i2,%o0,%i0
/* 0x3d4c	     */		sub	%i4,%l1,%o3
/* 0x3d50	     */		sethi	%hi(0x1000),%g1
/* 0x3d54	     */		sra	%o3,31,%i2
/* 0x3d58	     */		sub	%i4,%l6,%o5
/* 0x3d5c	     */		xor	%g1,-704,%g1
/* 0x3d60	     */		sub	%i0,%o0,%l7
/* 0x3d64	     */		sra	%o5,31,%g4
/* 0x3d68	     */		xor	%o3,%i2,%o2
/* 0x3d6c	     */		add	%g1,%fp,%g5
/* 0x3d70	     */		sub	%i4,%g5,%o4
/* 0x3d74	     */		xor	%o5,%g4,%i3
/* 0x3d78	     */		sub	%o2,%i2,%o0
/* 0x3d7c	     */		sra	%o4,31,%l3
/* 0x3d80	     */		sub	%i3,%g4,%g3
/* 0x3d84	     */		sub	%i4,%l0,%i0
/* 0x3d88	     */		xor	%o4,%l3,%o1
/* 0x3d8c	     */		sra	%i0,31,%i3
/* 0x3d90	     */		sub	%o1,%l3,%l4
/* 0x3d94	     */		xor	%i0,%i3,%o5
/* 0x3d98	     */		sub	%o5,%i3,%l3
/* 0x3d9c	     */		sub	%i4,%l2,%l5
/* 0x3da0	     */		sra	%l5,31,%g5
/* 0x3da4	     */		xor	%l5,%g5,%g2
/* 0x3da8	     */		sub	%g2,%g5,%l5
/* 0x3dac	     */		sra	%l7,0,%o1
/* 0x3db0	     */		sra	%g3,0,%g3
/* 0x3db4	     */		sra	%l4,0,%g4
/* 0x3db8	     */		ld	[%fp+96],%i2
/* 0x3dbc	     */		ld	[%fp+92],%i0
/* 0x3dc0	     */		sub	%i4,%i2,%o3
/* 0x3dc4	     */		sra	%o3,31,%i3
/* 0x3dc8	     */		xor	%o3,%i3,%o5
/* 0x3dcc	     */		sub	%i4,%i0,%o4
/* 0x3dd0	     */		sra	%o0,0,%o3
/* 0x3dd4	     */		sra	%i1,0,%o0
/* 0x3dd8	     */		sra	%o4,31,%g5
/* 0x3ddc	     */		sub	%o5,%i3,%l7
/* 0x3de0	     */		xor	%o4,%g5,%g2
/* 0x3de4	     */		sra	%l3,0,%o5
/* 0x3de8	     */		sub	%g3,%o0,%g3
/* 0x3dec	     */		sub	%g2,%g5,%o2
/* 0x3df0	     */		srlx	%g3,63,%l3
/* 0x3df4	     */		sub	%o1,%o0,%g2
/* 0x3df8	     */		sub	%g4,%o0,%g3
/* 0x3dfc	     */		srlx	%g3,63,%l4
/* 0x3e00	     */		sub	%o3,%o0,%o1
/* 0x3e04	     */		sra	%l7,0,%o4
/* 0x3e08	     */		srlx	%g2,63,%i3
/* 0x3e0c	     */		srlx	%o1,63,%g3
/* 0x3e10	     */		sra	%l5,0,%g5
/* 0x3e14	     */		sub	%o4,%o0,%o3
/* 0x3e18	     */		xor	%i3,1,%o1
/* 0x3e1c	     */		sra	%o2,0,%o2
/* 0x3e20	     */		sub	%g5,%o0,%g5
/* 0x3e24	     */		srlx	%g5,63,%l5
/* 0x3e28	     */		sub	%o2,%o0,%g2
/* 0x3e2c	     */		srlx	%o3,63,%g4
/* 0x3e30	     */		xor	%l3,1,%o4
/* 0x3e34	     */		xor	%g3,1,%i3
/* 0x3e38	     */		srlx	%g2,63,%o2
/* 0x3e3c	     */		and	%o4,%o1,%g5
/* 0x3e40	     */		sub	%o5,%o0,%o3
/* 0x3e44	     */		srl	%i1,0,%g3
/* 0x3e48	     */		xor	%l4,1,%o1
/* 0x3e4c	     */		srlx	%o3,63,%g2
/* 0x3e50	     */		sub	%g3,%o7,%o7
/* 0x3e54	     */		xor	%l5,1,%o5
/* 0x3e58	     */		xor	%o2,1,%o3
/* 0x3e5c	     */		srlx	%o7,63,%l4
/* 0x3e60	     */		and	%o5,%o3,%l5
/* 0x3e64	     */		and	%l4,%o1,%o2
/* 0x3e68	     */		xor	%g4,1,%l7
/* 0x3e6c	     */		and	%o2,%g5,%o3
/* 0x3e70	     */		and	%i3,%l7,%l3
/* 0x3e74	     */		xor	%g2,1,%o4
/* 0x3e78	     */		and	%o3,%l5,%o5
/* 0x3e7c	     */		and	%o4,1,%g4
/* 0x3e80	     */		and	%o5,%l3,%g3
/* 0x3e84	     */		andcc	%g3,%g4,%g0
/* 0x3e88	     */		be,a,pn	%icc,.L77004896
/* 0x3e8c	     */		or	%g0,0,%l4

! Registers live out of .L77004902: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004902

			.L77004903:
/* 0x3e90	 702 */		sub	%i5,%i0,%o4
/* 0x3e94	     */		sethi	%hi(0x1000),%g1
/* 0x3e98	     */		sra	%o4,31,%l4
/* 0x3e9c	     */		xor	%g1,-704,%g1
/* 0x3ea0	     */		xor	%o4,%l4,%o7
/* 0x3ea4	     */		sub	%i5,%l2,%l5
/* 0x3ea8	     */		sub	%i5,%l6,%l7
/* 0x3eac	     */		add	%g1,%fp,%o5
/* 0x3eb0	     */		sub	%i5,%o5,%g4
/* 0x3eb4	     */		sub	%o7,%l4,%g2
/* 0x3eb8	     */		sra	%l5,31,%o1
/* 0x3ebc	     */		sra	%l7,31,%o4
/* 0x3ec0	     */		xor	%l5,%o1,%l3
/* 0x3ec4	     */		xor	%l7,%o4,%i3
/* 0x3ec8	     */		sra	%g4,31,%l4
/* 0x3ecc	     */		sub	%l3,%o1,%g5
/* 0x3ed0	     */		sub	%i3,%o4,%o2
/* 0x3ed4	     */		xor	%g4,%l4,%o7
/* 0x3ed8	     */		sub	%i5,%i2,%g3
/* 0x3edc	     */		sub	%i5,%l1,%o3
/* 0x3ee0	     */		sub	%i0,%o5,%o4
/* 0x3ee4	     */		sra	%g3,31,%l5
/* 0x3ee8	     */		sra	%o3,31,%l3
/* 0x3eec	     */		sub	%o7,%l4,%g4
/* 0x3ef0	     */		sub	%i5,%l0,%i3
/* 0x3ef4	     */		xor	%g3,%l5,%o5
/* 0x3ef8	     */		xor	%o3,%l3,%o1
/* 0x3efc	     */		sra	%i3,31,%l4
/* 0x3f00	     */		sub	%o1,%l3,%l7
/* 0x3f04	     */		xor	%i3,%l4,%o7
/* 0x3f08	     */		sub	%o5,%l5,%g3
/* 0x3f0c	     */		sub	%o7,%l4,%l5
/* 0x3f10	     */		sra	%o4,31,%l3
/* 0x3f14	     */		sub	%i0,%l6,%o5
/* 0x3f18	     */		xor	%o4,%l3,%o1
/* 0x3f1c	     */		sra	%o5,31,%o7
/* 0x3f20	     */		sub	%o1,%l3,%i3
/* 0x3f24	     */		xor	%o5,%o7,%o4
/* 0x3f28	     */		sub	%o4,%o7,%l3
/* 0x3f2c	     */		sub	%i0,%l2,%o3
/* 0x3f30	     */		sra	%g2,0,%o7
/* 0x3f34	     */		sra	%o3,31,%o1
/* 0x3f38	     */		sub	%o7,%o0,%o5
/* 0x3f3c	     */		xor	%o3,%o1,%l4
/* 0x3f40	     */		srlx	%o5,63,%g2
/* 0x3f44	     */		xor	%g2,1,%o3
/* 0x3f48	     */		sra	%g5,0,%o4
/* 0x3f4c	     */		sub	%o4,%o0,%g2
/* 0x3f50	     */		srlx	%g2,63,%g5
/* 0x3f54	     */		xor	%g5,1,%o5
/* 0x3f58	     */		and	%o5,%o3,%o4
/* 0x3f5c	     */		sub	%l4,%o1,%l4
/* 0x3f60	     */		sra	%o2,0,%o3
/* 0x3f64	     */		sra	%g4,0,%g4
/* 0x3f68	     */		sub	%g4,%o0,%o1
/* 0x3f6c	     */		sub	%o3,%o0,%o2
/* 0x3f70	     */		srlx	%o1,63,%g4
/* 0x3f74	     */		srlx	%o2,63,%o2
/* 0x3f78	     */		xor	%o2,1,%o7
/* 0x3f7c	     */		xor	%g4,1,%o1
/* 0x3f80	     */		and	%o1,%o7,%g2
/* 0x3f84	     */		sra	%l7,0,%o7
/* 0x3f88	     */		sra	%g3,0,%g3
/* 0x3f8c	     */		sub	%g3,%o0,%g5
/* 0x3f90	     */		sub	%o7,%o0,%o5
/* 0x3f94	     */		srlx	%g5,63,%g3
/* 0x3f98	     */		srlx	%o5,63,%l7
/* 0x3f9c	     */		xor	%g3,1,%g5
/* 0x3fa0	     */		xor	%l7,1,%o3
/* 0x3fa4	     */		and	%g2,%o4,%o2
/* 0x3fa8	     */		and	%o3,%g5,%o5
/* 0x3fac	     */		sra	%l5,0,%o4
/* 0x3fb0	     */		sra	%i3,0,%o3
/* 0x3fb4	     */		and	%o2,%o5,%o1
/* 0x3fb8	     */		sub	%o4,%o0,%g2
/* 0x3fbc	     */		sub	%o3,%o0,%o2
/* 0x3fc0	     */		srlx	%g2,63,%l5
/* 0x3fc4	     */		srlx	%o2,63,%i3
/* 0x3fc8	     */		xor	%l5,1,%g4
/* 0x3fcc	     */		xor	%i3,1,%o4
/* 0x3fd0	     */		and	%o4,%g4,%o7
/* 0x3fd4	     */		and	%o1,%o7,%o2
/* 0x3fd8	     */		sra	%l3,0,%o7
/* 0x3fdc	     */		sra	%l4,0,%g2
/* 0x3fe0	     */		sub	%o7,%o0,%g4
/* 0x3fe4	     */		sub	%g2,%o0,%g3
/* 0x3fe8	     */		srlx	%g3,63,%l4
/* 0x3fec	     */		srlx	%g4,63,%l3
/* 0x3ff0	     */		xor	%l4,1,%g5
/* 0x3ff4	     */		xor	%l3,1,%l7
/* 0x3ff8	     */		and	%g5,%l7,%o3
/* 0x3ffc	     */		andcc	%o2,%o3,%g0
/* 0x4000	     */		be,a,pn	%icc,.L77004896
/* 0x4004	     */		or	%g0,0,%l4

! Registers live out of .L77004903: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004903

			.L77004904:
/* 0x4008	 702 */		sethi	%hi(0x1000),%g1
/* 0x400c	     */		xor	%g1,-704,%g1
/* 0x4010	     */		add	%g1,%fp,%g2
/* 0x4014	     */		sub	%i2,%g2,%o2
/* 0x4018	     */		sra	%o2,31,%o1
/* 0x401c	     */		xor	%o2,%o1,%o7
/* 0x4020	     */		sub	%i0,%l0,%o5
/* 0x4024	     */		sub	%i0,%i2,%l7
/* 0x4028	     */		sra	%o5,31,%g5
/* 0x402c	     */		sub	%o7,%o1,%l5
/* 0x4030	     */		sra	%l7,31,%i3
/* 0x4034	     */		sub	%i2,%l6,%g3
/* 0x4038	     */		xor	%o5,%g5,%o3
/* 0x403c	     */		xor	%l7,%i3,%o4
/* 0x4040	     */		sra	%g3,31,%o1
/* 0x4044	     */		sub	%i0,%l1,%g2
/* 0x4048	     */		sub	%o3,%g5,%l4
/* 0x404c	     */		sra	%g2,31,%o5
/* 0x4050	     */		xor	%g3,%o1,%o7
/* 0x4054	     */		sub	%o4,%i3,%o2
/* 0x4058	     */		sub	%i2,%l2,%g4
/* 0x405c	     */		xor	%g2,%o5,%o4
/* 0x4060	     */		sra	%g4,31,%i3
/* 0x4064	     */		sub	%i2,%l1,%o3
/* 0x4068	     */		sub	%o7,%o1,%g3
/* 0x406c	     */		sra	%o3,31,%o7
/* 0x4070	     */		sub	%o4,%o5,%g5
/* 0x4074	     */		sub	%i2,%l0,%g2
/* 0x4078	     */		xor	%g4,%i3,%g4
/* 0x407c	     */		sub	%g4,%i3,%l7
/* 0x4080	     */		xor	%o3,%o7,%o5
/* 0x4084	     */		sra	%g2,31,%l3
/* 0x4088	     */		xor	%g2,%l3,%o4
/* 0x408c	     */		sub	%o5,%o7,%i3
/* 0x4090	     */		sub	%o4,%l3,%l3
/* 0x4094	     */		sra	%l4,0,%o5
/* 0x4098	     */		sra	%l5,0,%o7
/* 0x409c	     */		sra	%o2,0,%o2
/* 0x40a0	     */		sra	%g5,0,%g5
/* 0x40a4	     */		sub	%o5,%o0,%o3
/* 0x40a8	     */		sub	%o7,%o0,%o1
/* 0x40ac	     */		sub	%o2,%o0,%o4
/* 0x40b0	     */		sub	%g5,%o0,%g2
/* 0x40b4	     */		srlx	%o3,63,%l4
/* 0x40b8	     */		srlx	%o1,63,%l5
/* 0x40bc	     */		srlx	%o4,63,%o2
/* 0x40c0	     */		srlx	%g2,63,%g5
/* 0x40c4	     */		xor	%l4,1,%g4
/* 0x40c8	     */		xor	%l5,1,%o1
/* 0x40cc	     */		xor	%o2,1,%o3
/* 0x40d0	     */		xor	%g5,1,%g2
/* 0x40d4	     */		and	%o1,%g4,%o5
/* 0x40d8	     */		and	%o3,%g2,%o4
/* 0x40dc	     */		and	%o4,%o5,%g4
/* 0x40e0	     */		sra	%l7,0,%o3
/* 0x40e4	     */		sra	%g3,0,%g3
/* 0x40e8	     */		sub	%o3,%o0,%o7
/* 0x40ec	     */		sub	%g3,%o0,%o5
/* 0x40f0	     */		srlx	%o7,63,%l7
/* 0x40f4	     */		srlx	%o5,63,%g3
/* 0x40f8	     */		xor	%g3,1,%l5
/* 0x40fc	     */		xor	%l7,1,%o7
/* 0x4100	     */		and	%o7,%l5,%l4
/* 0x4104	     */		and	%g4,%l4,%o3
/* 0x4108	     */		sra	%l3,0,%g4
/* 0x410c	     */		sub	%g4,%o0,%o1
/* 0x4110	     */		srlx	%o1,63,%l3
/* 0x4114	     */		sra	%i3,0,%o1
/* 0x4118	     */		sub	%o1,%o0,%o0
/* 0x411c	     */		srlx	%o0,63,%i3
/* 0x4120	     */		xor	%l3,1,%g5
/* 0x4124	     */		xor	%i3,1,%o2
/* 0x4128	     */		and	%g5,%o2,%g2
/* 0x412c	     */		andcc	%o3,%g2,%g0
/* 0x4130	     */		be,a,pn	%icc,.L77004896
/* 0x4134	     */		or	%g0,0,%l4

! Registers live out of .L77004904: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004904

			.L77005099:
/* 0x4138	 702 */		sethi	%hi(0x1000),%g1
/* 0x413c	     */		xor	%g1,-704,%g1
/* 0x4140	     */		add	%g1,%fp,%g4
/* 0x4144	     */		sethi	%hi(0x2400),%g1
/* 0x4148	     */		xor	%g1,-384,%g1
/* 0x414c	     */		add	%g1,%fp,%g3
/* 0x4150	     */		sethi	%hi(0x3800),%g1
/* 0x4154	     */		xor	%g1,-64,%g1
/* 0x4158	     */		add	%g1,%fp,%g2
/* 0x415c	     */		sethi	%hi(0x4800),%g1
/* 0x4160	     */		xor	%g1,-768,%g1
/* 0x4164	     */		add	%i1,-1,%i3
/* 0x4168	     */		or	%g0,0,%g5

!  703		      !            if (mask[i]) {

/* 0x416c	 703 */		ldub	[%l0],%o7
/* 0x4170	 702 */		add	%g1,%fp,%l7

! Registers live out of .L77005099: 
! g2 g3 g4 g5 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004815 .L77005099

			.L900000644:
/* 0x4174	 703 */		cmp	%o7,0
/* 0x4178	     */		be,pn	%icc,.L77004815
/* 0x417c	 702 */		add	%g5,1,%g5

! Registers live out of .L900000644: 
! g2 g3 g4 g5 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  704		      !               red[i]   = red[i]   | ~rdest[i];

                       
! predecessor blocks: .L900000644

			.L77004813:
/* 0x4180	 704 */		ldub	[%i4],%o2

!  705		      !               green[i] = green[i] | ~gdest[i];

/* 0x4184	 705 */		ldub	[%i5],%l2

!  706		      !               blue[i]  = blue[i]  | ~bdest[i];

/* 0x4188	 706 */		ldub	[%i0],%o5

!  707		      !               alpha[i] = alpha[i] | ~adest[i];

/* 0x418c	 707 */		ldub	[%i2],%l6
/* 0x4190	 704 */		ldub	[%g4],%i1
/* 0x4194	 705 */		ldub	[%g3],%l1
/* 0x4198	 706 */		ldub	[%g2],%o3
/* 0x419c	 707 */		ldub	[%l7],%l5
/* 0x41a0	 704 */		orn	%o2,%i1,%o1
/* 0x41a4	     */		stb	%o1,[%i4]
/* 0x41a8	 705 */		orn	%l2,%l1,%o4
/* 0x41ac	     */		stb	%o4,[%i5]
/* 0x41b0	 706 */		orn	%o5,%o3,%l3
/* 0x41b4	     */		stb	%l3,[%i0]
/* 0x41b8	 707 */		orn	%l6,%l5,%l4
/* 0x41bc	     */		stb	%l4,[%i2]

! Registers live out of .L77004813: 
! g2 g3 g4 g5 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004813 .L900000644

			.L77004815:
/* 0x41c0	 702 */		cmp	%g5,%i3
/* 0x41c4	     */		add	%l0,1,%l0
/* 0x41c8	     */		add	%l7,1,%l7
/* 0x41cc	     */		add	%g2,1,%g2
/* 0x41d0	     */		add	%g3,1,%g3
/* 0x41d4	     */		add	%g4,1,%g4
/* 0x41d8	     */		add	%i2,1,%i2
/* 0x41dc	     */		add	%i0,1,%i0
/* 0x41e0	     */		add	%i5,1,%i5
/* 0x41e4	     */		add	%i4,1,%i4
/* 0x41e8	     */		ble,a,pt	%icc,.L900000644
/* 0x41ec	 703 */		ldub	[%l0],%o7

! Registers live out of .L77004815: 
! g2 g3 g4 g5 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004815

			.L77004899:
/* 0x41f0	 702 */		ba	.L77004840
/* 0x41f4	     */		nop

! Registers live out of .L77004899: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004860

			.L77005255:
/* 0x41f8	 702 */		ld	[%fp+92],%i0
/* 0x41fc	     */		ld	[%fp+96],%i2
/* 0x4200	     */		or	%g0,0,%l4

! Registers live out of .L77005255: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004902 .L77004903 .L77004904 .L77005255

			.L77004896:
/* 0x4204	 703 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77004896: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004896 .L77004898

			.L900000643:
/* 0x4208	 703 */		cmp	%o5,0
/* 0x420c	     */		be,pn	%icc,.L77004898
/* 0x4210	 704 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000643: 
! g1 o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000643

			.L77004897:
/* 0x4214	 704 */		xor	%g1,-704,%g1
/* 0x4218	     */		add	%g1,%fp,%l3
/* 0x421c	     */		ldub	[%l4+%l3],%o0
/* 0x4220	     */		ldub	[%i4+%l4],%l7
/* 0x4224	     */		orn	%l7,%o0,%i3
/* 0x4228	     */		stb	%i3,[%i4+%l4]
/* 0x422c	 705 */		ldub	[%l4+%l6],%o7
/* 0x4230	     */		ldub	[%i5+%l4],%g5
/* 0x4234	     */		orn	%g5,%o7,%o1
/* 0x4238	     */		stb	%o1,[%i5+%l4]
/* 0x423c	 706 */		ldub	[%l4+%l2],%g2
/* 0x4240	     */		ldub	[%l4+%i0],%o4
/* 0x4244	     */		orn	%o4,%g2,%o2
/* 0x4248	     */		stb	%o2,[%l4+%i0]
/* 0x424c	 707 */		ldub	[%l4+%l1],%l5
/* 0x4250	     */		ldub	[%l4+%i2],%o3
/* 0x4254	     */		orn	%o3,%l5,%l3
/* 0x4258	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004897: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004897 .L900000643

			.L77004898:
/* 0x425c	 702 */		add	%l4,1,%l4
/* 0x4260	     */		cmp	%l4,%i1
/* 0x4264	     */		bcs,a,pn	%icc,.L900000643
/* 0x4268	 703 */		ldub	[%l4+%l0],%o5

! Registers live out of .L77004898: 
! o5 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004898

			.L900000625:
/* 0x426c	 702 */		ba	.L77004840
/* 0x4270	     */		nop

! Registers live out of .L900000625: 
! sp fp i7 gsr 
! 
		
!  708		      !            }
!  709		      !         }
!  710		      !         break;
!  711		      !      case GL_OR_INVERTED:
!  712		      !         for (i=0;i<n;i++) {

                       
! predecessor blocks: .L900000640

			.L77004821:
/* 0x4274	 712 */		cmp	%i1,0
/* 0x4278	     */		bleu,pn	%icc,.L77004840
/* 0x427c	     */		cmp	%i1,54

! Registers live out of .L77004821: 
! o2 sp l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004821

			.L77004858:
/* 0x4280	 712 */		bl,pn	%icc,.L77005259
/* 0x4284	     */		add	%o2,1022,%o7

! Registers live out of .L77004858: 
! sp o7 l0 l1 l2 l6 i1 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004858

			.L77004879:
/* 0x4288	 712 */		sethi	%hi(0x1000),%g1
/* 0x428c	     */		sub	%i4,%i5,%i0
/* 0x4290	     */		sub	%i4,%l6,%o5
/* 0x4294	     */		xor	%g1,-704,%g1
/* 0x4298	     */		sra	%i0,31,%o0
/* 0x429c	     */		sra	%o5,31,%g4
/* 0x42a0	     */		add	%g1,%fp,%o3
/* 0x42a4	     */		sub	%i4,%o3,%o1
/* 0x42a8	     */		xor	%i0,%o0,%i2
/* 0x42ac	     */		xor	%o5,%g4,%i3
/* 0x42b0	     */		sub	%i2,%o0,%l7
/* 0x42b4	     */		sra	%o1,31,%l3
/* 0x42b8	     */		sub	%i4,%l0,%o5
/* 0x42bc	     */		xor	%o1,%l3,%o4
/* 0x42c0	     */		sra	%o5,31,%i2
/* 0x42c4	     */		sub	%i3,%g4,%g3
/* 0x42c8	     */		sub	%i4,%l1,%o3
/* 0x42cc	     */		sub	%o4,%l3,%l4
/* 0x42d0	     */		sra	%o3,31,%i0
/* 0x42d4	     */		xor	%o5,%i2,%i3
/* 0x42d8	     */		xor	%o3,%i0,%o2
/* 0x42dc	     */		sub	%i3,%i2,%l3
/* 0x42e0	     */		sub	%o2,%i0,%o0
/* 0x42e4	     */		sub	%i4,%l2,%l5
/* 0x42e8	     */		sra	%l5,31,%g5
/* 0x42ec	     */		xor	%l5,%g5,%g2
/* 0x42f0	     */		sub	%g2,%g5,%l5
/* 0x42f4	     */		sra	%l7,0,%o1
/* 0x42f8	     */		sra	%g3,0,%g3
/* 0x42fc	     */		sra	%l4,0,%g4
/* 0x4300	     */		ld	[%fp+96],%i2
/* 0x4304	     */		ld	[%fp+92],%i0
/* 0x4308	     */		sub	%i4,%i2,%o3
/* 0x430c	     */		sra	%o3,31,%i3
/* 0x4310	     */		sub	%i4,%i0,%o4
/* 0x4314	     */		sra	%o4,31,%g5
/* 0x4318	     */		xor	%o3,%i3,%o5
/* 0x431c	     */		xor	%o4,%g5,%g2
/* 0x4320	     */		sra	%o0,0,%o3
/* 0x4324	     */		sra	%i1,0,%o0
/* 0x4328	     */		sub	%g2,%g5,%o2
/* 0x432c	     */		sub	%o5,%i3,%l7
/* 0x4330	     */		sub	%o1,%o0,%g2
/* 0x4334	     */		srlx	%g2,63,%i3
/* 0x4338	     */		sra	%l3,0,%o5
/* 0x433c	     */		sub	%g3,%o0,%g2
/* 0x4340	     */		srlx	%g2,63,%l3
/* 0x4344	     */		sra	%l5,0,%g5
/* 0x4348	     */		sub	%g4,%o0,%g2
/* 0x434c	     */		sra	%l7,0,%o4
/* 0x4350	     */		sub	%g5,%o0,%g4
/* 0x4354	     */		sra	%o2,0,%o2
/* 0x4358	     */		srlx	%g4,63,%l5
/* 0x435c	     */		sub	%o2,%o0,%g5
/* 0x4360	     */		sub	%o4,%o0,%o1
/* 0x4364	     */		sub	%o3,%o0,%o2
/* 0x4368	     */		srlx	%o1,63,%g4
/* 0x436c	     */		srlx	%o2,63,%g3
/* 0x4370	     */		xor	%i3,1,%o1
/* 0x4374	     */		srlx	%g5,63,%l7
/* 0x4378	     */		xor	%l3,1,%o4
/* 0x437c	     */		xor	%g4,1,%o2
/* 0x4380	     */		xor	%g3,1,%i3
/* 0x4384	     */		and	%o4,%o1,%g5
/* 0x4388	     */		and	%i3,%o2,%l3
/* 0x438c	     */		srlx	%g2,63,%l4
/* 0x4390	     */		sub	%o5,%o0,%o4
/* 0x4394	     */		srl	%i1,0,%o2
/* 0x4398	     */		xor	%l5,1,%o5
/* 0x439c	     */		xor	%l7,1,%o3
/* 0x43a0	     */		xor	%l4,1,%o1
/* 0x43a4	     */		sub	%o2,%o7,%o7
/* 0x43a8	     */		and	%o5,%o3,%l5
/* 0x43ac	     */		srlx	%o7,63,%l4
/* 0x43b0	     */		and	%l4,%o1,%o3
/* 0x43b4	     */		srlx	%o4,63,%g2
/* 0x43b8	     */		and	%o3,%g5,%o5
/* 0x43bc	     */		xor	%g2,1,%o4
/* 0x43c0	     */		and	%o5,%l5,%g3
/* 0x43c4	     */		and	%o4,1,%l7
/* 0x43c8	     */		and	%g3,%l3,%g4
/* 0x43cc	     */		andcc	%g4,%l7,%g0
/* 0x43d0	     */		be,a,pn	%icc,.L77004873
/* 0x43d4	     */		or	%g0,0,%l4

! Registers live out of .L77004879: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004879

			.L77004880:
/* 0x43d8	 712 */		sub	%i5,%i0,%o1
/* 0x43dc	     */		sra	%o1,31,%l4
/* 0x43e0	     */		sub	%i5,%l2,%l5
/* 0x43e4	     */		xor	%o1,%l4,%o5
/* 0x43e8	     */		sra	%l5,31,%o7
/* 0x43ec	     */		sub	%i5,%l6,%l7
/* 0x43f0	     */		sethi	%hi(0x1000),%g1
/* 0x43f4	     */		xor	%l5,%o7,%l3
/* 0x43f8	     */		sra	%l7,31,%o1
/* 0x43fc	     */		xor	%g1,-704,%g1
/* 0x4400	     */		xor	%l7,%o1,%i3
/* 0x4404	     */		sub	%i5,%i2,%g3
/* 0x4408	     */		sub	%l3,%o7,%g5
/* 0x440c	     */		add	%g1,%fp,%o4
/* 0x4410	     */		sub	%i5,%o4,%g4
/* 0x4414	     */		sub	%o5,%l4,%g2
/* 0x4418	     */		sub	%i3,%o1,%o2
/* 0x441c	     */		sra	%g3,31,%l3
/* 0x4420	     */		sub	%i5,%l1,%o3
/* 0x4424	     */		sra	%g4,31,%l4
/* 0x4428	     */		xor	%g3,%l3,%l5
/* 0x442c	     */		sra	%o3,31,%i3
/* 0x4430	     */		xor	%g4,%l4,%o5
/* 0x4434	     */		xor	%o3,%i3,%o7
/* 0x4438	     */		sub	%i0,%o4,%o4
/* 0x443c	     */		sub	%l5,%l3,%g3
/* 0x4440	     */		sub	%o7,%i3,%l7
/* 0x4444	     */		sra	%o4,31,%l3
/* 0x4448	     */		sub	%o5,%l4,%g4
/* 0x444c	     */		sub	%i5,%l0,%o1
/* 0x4450	     */		xor	%o4,%l3,%o7
/* 0x4454	     */		sub	%i0,%l6,%o5
/* 0x4458	     */		sra	%o1,31,%l5
/* 0x445c	     */		xor	%o1,%l5,%l4
/* 0x4460	     */		sub	%o7,%l3,%i3
/* 0x4464	     */		sra	%o5,31,%o4
/* 0x4468	     */		sub	%i0,%l2,%o3
/* 0x446c	     */		xor	%o5,%o4,%o1
/* 0x4470	     */		sra	%o3,31,%o7
/* 0x4474	     */		sub	%l4,%l5,%l5
/* 0x4478	     */		sub	%o1,%o4,%l3
/* 0x447c	     */		xor	%o3,%o7,%l4
/* 0x4480	     */		sub	%l4,%o7,%l4
/* 0x4484	     */		sra	%g2,0,%o1
/* 0x4488	     */		sra	%g5,0,%g5
/* 0x448c	     */		sub	%o1,%o0,%o7
/* 0x4490	     */		sub	%g5,%o0,%o5
/* 0x4494	     */		srlx	%o7,63,%g2
/* 0x4498	     */		srlx	%o5,63,%g5
/* 0x449c	     */		xor	%g2,1,%o3
/* 0x44a0	     */		xor	%g5,1,%o5
/* 0x44a4	     */		and	%o5,%o3,%o1
/* 0x44a8	     */		sra	%o2,0,%o4
/* 0x44ac	     */		sra	%g4,0,%g4
/* 0x44b0	     */		sub	%o4,%o0,%g2
/* 0x44b4	     */		sub	%g4,%o0,%o3
/* 0x44b8	     */		srlx	%g2,63,%o2
/* 0x44bc	     */		srlx	%o3,63,%g4
/* 0x44c0	     */		xor	%o2,1,%o4
/* 0x44c4	     */		xor	%g4,1,%o7
/* 0x44c8	     */		and	%o7,%o4,%g2
/* 0x44cc	     */		and	%g2,%o1,%o5
/* 0x44d0	     */		sra	%l7,0,%o1
/* 0x44d4	     */		sra	%g3,0,%g3
/* 0x44d8	     */		sub	%g3,%o0,%o2
/* 0x44dc	     */		sub	%o1,%o0,%o7
/* 0x44e0	     */		srlx	%o2,63,%g3
/* 0x44e4	     */		srlx	%o7,63,%l7
/* 0x44e8	     */		xor	%g3,1,%g5
/* 0x44ec	     */		xor	%l7,1,%o3
/* 0x44f0	     */		and	%o3,%g5,%o2
/* 0x44f4	     */		and	%o5,%o2,%o7
/* 0x44f8	     */		sra	%l5,0,%g5
/* 0x44fc	     */		sra	%i3,0,%o4
/* 0x4500	     */		sub	%g5,%o0,%o5
/* 0x4504	     */		sub	%o4,%o0,%g2
/* 0x4508	     */		srlx	%o5,63,%l5
/* 0x450c	     */		srlx	%g2,63,%i3
/* 0x4510	     */		xor	%i3,1,%o1
/* 0x4514	     */		xor	%l5,1,%g4
/* 0x4518	     */		and	%o1,%g4,%o4
/* 0x451c	     */		sra	%l3,0,%o1
/* 0x4520	     */		sra	%l4,0,%g2
/* 0x4524	     */		sub	%o1,%o0,%o5
/* 0x4528	     */		sub	%g2,%o0,%g3
/* 0x452c	     */		srlx	%g3,63,%l4
/* 0x4530	     */		srlx	%o5,63,%l3
/* 0x4534	     */		xor	%l4,1,%g5
/* 0x4538	     */		xor	%l3,1,%l7
/* 0x453c	     */		and	%o7,%o4,%o2
/* 0x4540	     */		and	%g5,%l7,%o3
/* 0x4544	     */		andcc	%o2,%o3,%g0
/* 0x4548	     */		be,a,pn	%icc,.L77004873
/* 0x454c	     */		or	%g0,0,%l4

! Registers live out of .L77004880: 
! o0 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004880

			.L77004881:
/* 0x4550	 712 */		sethi	%hi(0x1000),%g1
/* 0x4554	     */		xor	%g1,-704,%g1
/* 0x4558	     */		add	%g1,%fp,%g4
/* 0x455c	     */		sub	%i2,%g4,%l5
/* 0x4560	     */		sra	%l5,31,%o7
/* 0x4564	     */		sub	%i0,%l0,%o3
/* 0x4568	     */		sra	%o3,31,%o5
/* 0x456c	     */		xor	%l5,%o7,%i3
/* 0x4570	     */		sub	%i0,%i2,%l7
/* 0x4574	     */		xor	%o3,%o5,%g5
/* 0x4578	     */		sub	%i3,%o7,%l5
/* 0x457c	     */		sra	%l7,31,%l3
/* 0x4580	     */		sub	%i2,%l6,%g3
/* 0x4584	     */		sub	%g5,%o5,%l4
/* 0x4588	     */		xor	%l7,%l3,%o1
/* 0x458c	     */		sra	%g3,31,%o7
/* 0x4590	     */		sub	%i0,%l1,%g2
/* 0x4594	     */		sra	%g2,31,%o4
/* 0x4598	     */		xor	%g3,%o7,%o5
/* 0x459c	     */		sub	%o1,%l3,%o2
/* 0x45a0	     */		sub	%i2,%l2,%g4
/* 0x45a4	     */		xor	%g2,%o4,%o1
/* 0x45a8	     */		sra	%g4,31,%i3
/* 0x45ac	     */		sub	%i2,%l1,%o3
/* 0x45b0	     */		sub	%o5,%o7,%g3
/* 0x45b4	     */		sra	%o3,31,%o5
/* 0x45b8	     */		sub	%o1,%o4,%g5
/* 0x45bc	     */		sub	%i2,%l0,%g2
/* 0x45c0	     */		xor	%g4,%i3,%g4
/* 0x45c4	     */		sub	%g4,%i3,%l7
/* 0x45c8	     */		xor	%o3,%o5,%o4
/* 0x45cc	     */		sra	%g2,31,%l3
/* 0x45d0	     */		xor	%g2,%l3,%o1
/* 0x45d4	     */		sub	%o4,%o5,%i3
/* 0x45d8	     */		sub	%o1,%l3,%l3
/* 0x45dc	     */		sra	%l4,0,%o4
/* 0x45e0	     */		sra	%l5,0,%o5
/* 0x45e4	     */		sra	%o2,0,%o2
/* 0x45e8	     */		sra	%g5,0,%g5
/* 0x45ec	     */		sub	%o4,%o0,%o3
/* 0x45f0	     */		sub	%o5,%o0,%o7
/* 0x45f4	     */		sub	%o2,%o0,%o1
/* 0x45f8	     */		sub	%g5,%o0,%g2
/* 0x45fc	     */		srlx	%o3,63,%l4
/* 0x4600	     */		srlx	%o7,63,%l5
/* 0x4604	     */		srlx	%o1,63,%o2
/* 0x4608	     */		srlx	%g2,63,%g5
/* 0x460c	     */		xor	%l4,1,%g4
/* 0x4610	     */		xor	%l5,1,%o7
/* 0x4614	     */		xor	%o2,1,%o3
/* 0x4618	     */		xor	%g5,1,%g2
/* 0x461c	     */		and	%o7,%g4,%o4
/* 0x4620	     */		and	%o3,%g2,%o1
/* 0x4624	     */		and	%o1,%o4,%g4
/* 0x4628	     */		sra	%l7,0,%o3
/* 0x462c	     */		sra	%g3,0,%g3
/* 0x4630	     */		sub	%o3,%o0,%o5
/* 0x4634	     */		sub	%g3,%o0,%o4
/* 0x4638	     */		srlx	%o5,63,%l7
/* 0x463c	     */		srlx	%o4,63,%g3
/* 0x4640	     */		xor	%g3,1,%l5
/* 0x4644	     */		xor	%l7,1,%o5
/* 0x4648	     */		and	%o5,%l5,%l4
/* 0x464c	     */		and	%g4,%l4,%o3
/* 0x4650	     */		sra	%l3,0,%g4
/* 0x4654	     */		sub	%g4,%o0,%o7
/* 0x4658	     */		srlx	%o7,63,%l3
/* 0x465c	     */		sra	%i3,0,%o7
/* 0x4660	     */		sub	%o7,%o0,%o0
/* 0x4664	     */		srlx	%o0,63,%i3
/* 0x4668	     */		xor	%l3,1,%g5
/* 0x466c	     */		xor	%i3,1,%o2
/* 0x4670	     */		and	%g5,%o2,%g2
/* 0x4674	     */		andcc	%o3,%g2,%g0
/* 0x4678	     */		be,a,pn	%icc,.L77004873
/* 0x467c	     */		or	%g0,0,%l4

! Registers live out of .L77004881: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004881

			.L77005097:
/* 0x4680	 712 */		sethi	%hi(0x1000),%g1
/* 0x4684	     */		xor	%g1,-704,%g1
/* 0x4688	     */		add	%g1,%fp,%g4
/* 0x468c	     */		sethi	%hi(0x2400),%g1
/* 0x4690	     */		xor	%g1,-384,%g1
/* 0x4694	     */		add	%g1,%fp,%g3
/* 0x4698	     */		sethi	%hi(0x3800),%g1
/* 0x469c	     */		xor	%g1,-64,%g1
/* 0x46a0	     */		add	%g1,%fp,%g2
/* 0x46a4	     */		sethi	%hi(0x4800),%g1
/* 0x46a8	     */		xor	%g1,-768,%g1
/* 0x46ac	     */		add	%i1,-1,%o0
/* 0x46b0	     */		or	%g0,0,%i3

!  713		      !            if (mask[i]) {

/* 0x46b4	 713 */		ldub	[%l0],%o7
/* 0x46b8	 712 */		add	%g1,%fp,%l7

! Registers live out of .L77005097: 
! g2 g3 g4 o0 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004829 .L77005097

			.L900000642:
/* 0x46bc	 713 */		cmp	%o7,0
/* 0x46c0	     */		be,pn	%icc,.L77004829
/* 0x46c4	 712 */		add	%i3,1,%i3

! Registers live out of .L900000642: 
! g2 g3 g4 o0 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		
!  714		      !               red[i]   = ~red[i]   | rdest[i];

                       
! predecessor blocks: .L900000642

			.L77004827:
/* 0x46c8	 714 */		ldub	[%i4],%i1

!  715		      !               green[i] = ~green[i] | gdest[i];

/* 0x46cc	 715 */		ldub	[%i5],%l1

!  716		      !               blue[i]  = ~blue[i]  | bdest[i];

/* 0x46d0	 716 */		ldub	[%i0],%o3

!  717		      !               alpha[i] = ~alpha[i] | adest[i];

/* 0x46d4	 717 */		ldub	[%i2],%l5
/* 0x46d8	 714 */		ldub	[%g4],%o2
/* 0x46dc	 715 */		ldub	[%g3],%l2
/* 0x46e0	 716 */		ldub	[%g2],%o5
/* 0x46e4	 717 */		ldub	[%l7],%l6
/* 0x46e8	 714 */		orn	%o2,%i1,%o1
/* 0x46ec	     */		stb	%o1,[%i4]
/* 0x46f0	 715 */		orn	%l2,%l1,%o4
/* 0x46f4	     */		stb	%o4,[%i5]
/* 0x46f8	 716 */		orn	%o5,%o3,%l3
/* 0x46fc	     */		stb	%l3,[%i0]
/* 0x4700	 717 */		orn	%l6,%l5,%l4
/* 0x4704	     */		stb	%l4,[%i2]

! Registers live out of .L77004827: 
! g2 g3 g4 o0 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004827 .L900000642

			.L77004829:
/* 0x4708	 712 */		cmp	%i3,%o0
/* 0x470c	     */		add	%l0,1,%l0
/* 0x4710	     */		add	%l7,1,%l7
/* 0x4714	     */		add	%g2,1,%g2
/* 0x4718	     */		add	%g3,1,%g3
/* 0x471c	     */		add	%g4,1,%g4
/* 0x4720	     */		add	%i2,1,%i2
/* 0x4724	     */		add	%i0,1,%i0
/* 0x4728	     */		add	%i5,1,%i5
/* 0x472c	     */		add	%i4,1,%i4
/* 0x4730	     */		ble,a,pt	%icc,.L900000642
/* 0x4734	 713 */		ldub	[%l0],%o7

! Registers live out of .L77004829: 
! g2 g3 g4 o0 sp o7 l0 l7 i0 i2 i3 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004829

			.L77004876:
/* 0x4738	 712 */		ba	.L77004840
/* 0x473c	     */		nop

! Registers live out of .L77004876: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004858

			.L77005259:
/* 0x4740	 712 */		ld	[%fp+92],%i0
/* 0x4744	     */		ld	[%fp+96],%i2
/* 0x4748	     */		or	%g0,0,%l4

! Registers live out of .L77005259: 
! sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004879 .L77004880 .L77004881 .L77005259

			.L77004873:
/* 0x474c	 713 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004873: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004873 .L77004875

			.L900000641:
/* 0x4750	 713 */		cmp	%g3,0
/* 0x4754	     */		be,pn	%icc,.L77004875
/* 0x4758	 714 */		sethi	%hi(0x1000),%g1

! Registers live out of .L900000641: 
! g1 g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000641

			.L77004874:
/* 0x475c	 714 */		xor	%g1,-704,%g1
/* 0x4760	     */		add	%g1,%fp,%g3
/* 0x4764	     */		ldub	[%i4+%l4],%o0
/* 0x4768	     */		ldub	[%l4+%g3],%o2
/* 0x476c	     */		orn	%o2,%o0,%i3
/* 0x4770	     */		stb	%i3,[%i4+%l4]
/* 0x4774	 715 */		ldub	[%i5+%l4],%o7
/* 0x4778	     */		ldub	[%l4+%l6],%g5
/* 0x477c	     */		orn	%g5,%o7,%o1
/* 0x4780	     */		stb	%o1,[%i5+%l4]
/* 0x4784	 716 */		ldub	[%l4+%i0],%g2
/* 0x4788	     */		ldub	[%l4+%l2],%o4
/* 0x478c	     */		orn	%o4,%g2,%o3
/* 0x4790	     */		stb	%o3,[%l4+%i0]
/* 0x4794	 717 */		ldub	[%l4+%i2],%l5
/* 0x4798	     */		ldub	[%l4+%l1],%o5
/* 0x479c	     */		orn	%o5,%l5,%l3
/* 0x47a0	     */		stb	%l3,[%l4+%i2]

! Registers live out of .L77004874: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004874 .L900000641

			.L77004875:
/* 0x47a4	 712 */		add	%l4,1,%l4
/* 0x47a8	     */		cmp	%l4,%i1
/* 0x47ac	     */		bcs,a,pn	%icc,.L900000641
/* 0x47b0	 713 */		ldub	[%l4+%l0],%g3

! Registers live out of .L77004875: 
! g3 sp l0 l1 l2 l4 l6 i0 i1 i2 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004875

			.L900000624:
/* 0x47b4	 712 */		ba	.L77004840
/* 0x47b8	     */		nop

! Registers live out of .L900000624: 
! sp fp i7 gsr 
! 
		
!  718		      !            }
!  719		      !         }
!  720		      !         break;
!  721		      !      default:
!  722		      !         /* should never happen */
!  723		      !         gl_problem(ctx, "Bad function in gl_logicop_rgba_pixels");

                       
! predecessor blocks: .L77004837 .L900000640

			.L77004835:
/* 0x47bc	 723 */		or	%g0,%i0,%o0
/* 0x47c0	     */		sethi	%hi(.L564),%i4
/* 0x47c4	     */		call	gl_problem	! params =  %o0 %o1	! Result = 
/* 0x47c8	     */		add	%i4,%lo(.L564),%o1

! Registers live out of .L77004835: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L77004623 .L77004637 .L77004653 .L77004667 .L77004681 .L77004695 .L77004709 .L77004723 .L77004737 .L77004751
! predecessor blocks: .L77004765 .L77004779 .L77004793 .L77004807 .L77004821 .L77004835 .L77004876 .L77004888 .L77004899 .L77004911 .L77004923
! predecessor blocks: .L77004935 .L77004947 .L77004959 .L77004971 .L77004983 .L77004995 .L77005007 .L77005019 .L77005030 .L77005041 .L900000624
! predecessor blocks: .L900000625 .L900000626 .L900000627 .L900000628 .L900000629 .L900000630 .L900000631 .L900000632 .L900000633 .L900000634 .L900000635
! predecessor blocks: .L900000636 .L900000637 .L900000638 .L900000640

			.L77004840:
/* 0x47cc	 571 */		ret	! Result = 
/* 0x47d0	     */		restore	%g0,0,%g0
/* 0x47d4	   0 */		.type	gl_logicop_rgba_pixels,2
/* 0x47d4	   0 */		.size	gl_logicop_rgba_pixels,(.-gl_logicop_rgba_pixels)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	130
/* 0x000c	   0 */		.word	250
/* 0x0010	   0 */		.word	126
/* 0x0014	   0 */		.word	608
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	69
/* 0x0024	   0 */		.word	16414
/* 0x0028	   0 */		.word	1
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.align	4
/* 0x0030	   0 */		.word	-1
/* 0x0034	   0 */		.word	-1
/* 0x0038	   0 */		.word	93
/* 0x003c	   0 */		.word	16414
/* 0x0040	   0 */		.word	1
/* 0x0044	   0 */		.word	1
/* 0x0048	   0 */		.align	4
/* 0x0048	   0 */		.word	-1
/* 0x004c	   0 */		.word	-1
/* 0x0050	   0 */		.word	69
/* 0x0054	   0 */		.word	131075
/* 0x0058	   0 */		.word	1
/* 0x005c	   0 */		.word	2
/* 0x0060	   0 */		.align	4
/* 0x0060	   0 */		.word	-1
/* 0x0064	   0 */		.word	-1
/* 0x0068	   0 */		.word	93
/* 0x006c	   0 */		.word	131075
/* 0x0070	   0 */		.word	1
/* 0x0074	   0 */		.word	3
/* 0x0078	   0 */		.align	4
/* 0x0078	   0 */		.word	-1
/* 0x007c	   0 */		.word	-1
/* 0x0080	   0 */		.word	224
/* 0x0084	   0 */		.word	16414
/* 0x0088	   0 */		.word	1
/* 0x008c	   0 */		.word	4
/* 0x0090	   0 */		.align	4
/* 0x0090	   0 */		.word	-1
/* 0x0094	   0 */		.word	-1
/* 0x0098	   0 */		.word	116
/* 0x009c	   0 */		.word	65571
/* 0x00a0	   0 */		.word	1
/* 0x00a4	   0 */		.word	5
/* 0x00a8	   0 */		.align	4
/* 0x00a8	   0 */		.word	-1
/* 0x00ac	   0 */		.word	-1
/* 0x00b0	   0 */		.word	123
/* 0x00b4	   0 */		.word	65571
/* 0x00b8	   0 */		.word	1
/* 0x00bc	   0 */		.word	6
/* 0x00c0	   0 */		.align	4
/* 0x00c0	   0 */		.word	-1
/* 0x00c4	   0 */		.word	-1
/* 0x00c8	   0 */		.word	133
/* 0x00cc	   0 */		.word	65571
/* 0x00d0	   0 */		.word	1
/* 0x00d4	   0 */		.word	7
/* 0x00d8	   0 */		.align	4
/* 0x00d8	   0 */		.word	-1
/* 0x00dc	   0 */		.word	-1
/* 0x00e0	   0 */		.word	140
/* 0x00e4	   0 */		.word	65571
/* 0x00e8	   0 */		.word	1
/* 0x00ec	   0 */		.word	8
/* 0x00f0	   0 */		.align	4
/* 0x00f0	   0 */		.word	-1
/* 0x00f4	   0 */		.word	-1
/* 0x00f8	   0 */		.word	147
/* 0x00fc	   0 */		.word	65571
/* 0x0100	   0 */		.word	1
/* 0x0104	   0 */		.word	9
/* 0x0108	   0 */		.align	4
/* 0x0108	   0 */		.word	-1
/* 0x010c	   0 */		.word	-1
/* 0x0110	   0 */		.word	154
/* 0x0114	   0 */		.word	65571
/* 0x0118	   0 */		.word	1
/* 0x011c	   0 */		.word	10
/* 0x0120	   0 */		.align	4
/* 0x0120	   0 */		.word	-1
/* 0x0124	   0 */		.word	-1
/* 0x0128	   0 */		.word	161
/* 0x012c	   0 */		.word	65571
/* 0x0130	   0 */		.word	1
/* 0x0134	   0 */		.word	11
/* 0x0138	   0 */		.align	4
/* 0x0138	   0 */		.word	-1
/* 0x013c	   0 */		.word	-1
/* 0x0140	   0 */		.word	168
/* 0x0144	   0 */		.word	65571
/* 0x0148	   0 */		.word	1
/* 0x014c	   0 */		.word	12
/* 0x0150	   0 */		.align	4
/* 0x0150	   0 */		.word	-1
/* 0x0154	   0 */		.word	-1
/* 0x0158	   0 */		.word	175
/* 0x015c	   0 */		.word	65571
/* 0x0160	   0 */		.word	1
/* 0x0164	   0 */		.word	13
/* 0x0168	   0 */		.align	4
/* 0x0168	   0 */		.word	-1
/* 0x016c	   0 */		.word	-1
/* 0x0170	   0 */		.word	182
/* 0x0174	   0 */		.word	65571
/* 0x0178	   0 */		.word	1
/* 0x017c	   0 */		.word	14
/* 0x0180	   0 */		.align	4
/* 0x0180	   0 */		.word	-1
/* 0x0184	   0 */		.word	-1
/* 0x0188	   0 */		.word	189
/* 0x018c	   0 */		.word	65571
/* 0x0190	   0 */		.word	1
/* 0x0194	   0 */		.word	15
/* 0x0198	   0 */		.align	4
/* 0x0198	   0 */		.word	-1
/* 0x019c	   0 */		.word	-1
/* 0x01a0	   0 */		.word	196
/* 0x01a4	   0 */		.word	65571
/* 0x01a8	   0 */		.word	1
/* 0x01ac	   0 */		.word	16
/* 0x01b0	   0 */		.align	4
/* 0x01b0	   0 */		.word	-1
/* 0x01b4	   0 */		.word	-1
/* 0x01b8	   0 */		.word	203
/* 0x01bc	   0 */		.word	65571
/* 0x01c0	   0 */		.word	1
/* 0x01c4	   0 */		.word	17
/* 0x01c8	   0 */		.align	4
/* 0x01c8	   0 */		.word	-1
/* 0x01cc	   0 */		.word	-1
/* 0x01d0	   0 */		.word	210
/* 0x01d4	   0 */		.word	65571
/* 0x01d8	   0 */		.word	1
/* 0x01dc	   0 */		.word	18
/* 0x01e0	   0 */		.align	4
/* 0x01e0	   0 */		.word	-1
/* 0x01e4	   0 */		.word	-1
/* 0x01e8	   0 */		.word	217
/* 0x01ec	   0 */		.word	65571
/* 0x01f0	   0 */		.word	1
/* 0x01f4	   0 */		.word	19
/* 0x01f8	   0 */		.align	4
/* 0x01f8	   0 */		.word	-1
/* 0x01fc	   0 */		.word	-1
/* 0x0200	   0 */		.word	116
/* 0x0204	   0 */		.word	4148
/* 0x0208	   0 */		.word	3
/* 0x020c	   0 */		.word	20
/* 0x0210	   0 */		.align	4
/* 0x0210	   0 */		.word	-1
/* 0x0214	   0 */		.word	-1
/* 0x0218	   0 */		.word	123
/* 0x021c	   0 */		.word	4148
/* 0x0220	   0 */		.word	3
/* 0x0224	   0 */		.word	23
/* 0x0228	   0 */		.align	4
/* 0x0228	   0 */		.word	-1
/* 0x022c	   0 */		.word	-1
/* 0x0230	   0 */		.word	133
/* 0x0234	   0 */		.word	4148
/* 0x0238	   0 */		.word	3
/* 0x023c	   0 */		.word	26
/* 0x0240	   0 */		.align	4
/* 0x0240	   0 */		.word	-1
/* 0x0244	   0 */		.word	-1
/* 0x0248	   0 */		.word	140
/* 0x024c	   0 */		.word	4148
/* 0x0250	   0 */		.word	3
/* 0x0254	   0 */		.word	29
/* 0x0258	   0 */		.align	4
/* 0x0258	   0 */		.word	-1
/* 0x025c	   0 */		.word	-1
/* 0x0260	   0 */		.word	147
/* 0x0264	   0 */		.word	4148
/* 0x0268	   0 */		.word	3
/* 0x026c	   0 */		.word	32
/* 0x0270	   0 */		.align	4
/* 0x0270	   0 */		.word	-1
/* 0x0274	   0 */		.word	-1
/* 0x0278	   0 */		.word	154
/* 0x027c	   0 */		.word	4148
/* 0x0280	   0 */		.word	3
/* 0x0284	   0 */		.word	35
/* 0x0288	   0 */		.align	4
/* 0x0288	   0 */		.word	-1
/* 0x028c	   0 */		.word	-1
/* 0x0290	   0 */		.word	161
/* 0x0294	   0 */		.word	4148
/* 0x0298	   0 */		.word	3
/* 0x029c	   0 */		.word	38
/* 0x02a0	   0 */		.align	4
/* 0x02a0	   0 */		.word	-1
/* 0x02a4	   0 */		.word	-1
/* 0x02a8	   0 */		.word	168
/* 0x02ac	   0 */		.word	4148
/* 0x02b0	   0 */		.word	3
/* 0x02b4	   0 */		.word	41
/* 0x02b8	   0 */		.align	4
/* 0x02b8	   0 */		.word	-1
/* 0x02bc	   0 */		.word	-1
/* 0x02c0	   0 */		.word	175
/* 0x02c4	   0 */		.word	4148
/* 0x02c8	   0 */		.word	3
/* 0x02cc	   0 */		.word	44
/* 0x02d0	   0 */		.align	4
/* 0x02d0	   0 */		.word	-1
/* 0x02d4	   0 */		.word	-1
/* 0x02d8	   0 */		.word	182
/* 0x02dc	   0 */		.word	4148
/* 0x02e0	   0 */		.word	3
/* 0x02e4	   0 */		.word	47
/* 0x02e8	   0 */		.align	4
/* 0x02e8	   0 */		.word	-1
/* 0x02ec	   0 */		.word	-1
/* 0x02f0	   0 */		.word	189
/* 0x02f4	   0 */		.word	4148
/* 0x02f8	   0 */		.word	3
/* 0x02fc	   0 */		.word	50
/* 0x0300	   0 */		.align	4
/* 0x0300	   0 */		.word	-1
/* 0x0304	   0 */		.word	-1
/* 0x0308	   0 */		.word	196
/* 0x030c	   0 */		.word	4148
/* 0x0310	   0 */		.word	3
/* 0x0314	   0 */		.word	53
/* 0x0318	   0 */		.align	4
/* 0x0318	   0 */		.word	-1
/* 0x031c	   0 */		.word	-1
/* 0x0320	   0 */		.word	203
/* 0x0324	   0 */		.word	4148
/* 0x0328	   0 */		.word	3
/* 0x032c	   0 */		.word	56
/* 0x0330	   0 */		.align	4
/* 0x0330	   0 */		.word	-1
/* 0x0334	   0 */		.word	-1
/* 0x0338	   0 */		.word	210
/* 0x033c	   0 */		.word	4148
/* 0x0340	   0 */		.word	3
/* 0x0344	   0 */		.word	59
/* 0x0348	   0 */		.align	4
/* 0x0348	   0 */		.word	-1
/* 0x034c	   0 */		.word	-1
/* 0x0350	   0 */		.word	217
/* 0x0354	   0 */		.word	4148
/* 0x0358	   0 */		.word	3
/* 0x035c	   0 */		.word	62
/* 0x0360	   0 */		.align	4
/* 0x0360	   0 */		.word	-1
/* 0x0364	   0 */		.word	-1
/* 0x0368	   0 */		.word	354
/* 0x036c	   0 */		.word	16414
/* 0x0370	   0 */		.word	1
/* 0x0374	   0 */		.word	65
/* 0x0378	   0 */		.align	4
/* 0x0378	   0 */		.word	-1
/* 0x037c	   0 */		.word	-1
/* 0x0380	   0 */		.word	246
/* 0x0384	   0 */		.word	65571
/* 0x0388	   0 */		.word	1
/* 0x038c	   0 */		.word	66
/* 0x0390	   0 */		.align	4
/* 0x0390	   0 */		.word	-1
/* 0x0394	   0 */		.word	-1
/* 0x0398	   0 */		.word	253
/* 0x039c	   0 */		.word	65571
/* 0x03a0	   0 */		.word	1
/* 0x03a4	   0 */		.word	67
/* 0x03a8	   0 */		.align	4
/* 0x03a8	   0 */		.word	-1
/* 0x03ac	   0 */		.word	-1
/* 0x03b0	   0 */		.word	263
/* 0x03b4	   0 */		.word	65571
/* 0x03b8	   0 */		.word	1
/* 0x03bc	   0 */		.word	68
/* 0x03c0	   0 */		.align	4
/* 0x03c0	   0 */		.word	-1
/* 0x03c4	   0 */		.word	-1
/* 0x03c8	   0 */		.word	270
/* 0x03cc	   0 */		.word	65571
/* 0x03d0	   0 */		.word	1
/* 0x03d4	   0 */		.word	69
/* 0x03d8	   0 */		.align	4
/* 0x03d8	   0 */		.word	-1
/* 0x03dc	   0 */		.word	-1
/* 0x03e0	   0 */		.word	277
/* 0x03e4	   0 */		.word	65571
/* 0x03e8	   0 */		.word	1
/* 0x03ec	   0 */		.word	70
/* 0x03f0	   0 */		.align	4
/* 0x03f0	   0 */		.word	-1
/* 0x03f4	   0 */		.word	-1
/* 0x03f8	   0 */		.word	284
/* 0x03fc	   0 */		.word	65571
/* 0x0400	   0 */		.word	1
/* 0x0404	   0 */		.word	71
/* 0x0408	   0 */		.align	4
/* 0x0408	   0 */		.word	-1
/* 0x040c	   0 */		.word	-1
/* 0x0410	   0 */		.word	291
/* 0x0414	   0 */		.word	65571
/* 0x0418	   0 */		.word	1
/* 0x041c	   0 */		.word	72
/* 0x0420	   0 */		.align	4
/* 0x0420	   0 */		.word	-1
/* 0x0424	   0 */		.word	-1
/* 0x0428	   0 */		.word	298
/* 0x042c	   0 */		.word	65571
/* 0x0430	   0 */		.word	1
/* 0x0434	   0 */		.word	73
/* 0x0438	   0 */		.align	4
/* 0x0438	   0 */		.word	-1
/* 0x043c	   0 */		.word	-1
/* 0x0440	   0 */		.word	305
/* 0x0444	   0 */		.word	65571
/* 0x0448	   0 */		.word	1
/* 0x044c	   0 */		.word	74
/* 0x0450	   0 */		.align	4
/* 0x0450	   0 */		.word	-1
/* 0x0454	   0 */		.word	-1
/* 0x0458	   0 */		.word	312
/* 0x045c	   0 */		.word	65571
/* 0x0460	   0 */		.word	1
/* 0x0464	   0 */		.word	75
/* 0x0468	   0 */		.align	4
/* 0x0468	   0 */		.word	-1
/* 0x046c	   0 */		.word	-1
/* 0x0470	   0 */		.word	319
/* 0x0474	   0 */		.word	65571
/* 0x0478	   0 */		.word	1
/* 0x047c	   0 */		.word	76
/* 0x0480	   0 */		.align	4
/* 0x0480	   0 */		.word	-1
/* 0x0484	   0 */		.word	-1
/* 0x0488	   0 */		.word	326
/* 0x048c	   0 */		.word	65571
/* 0x0490	   0 */		.word	1
/* 0x0494	   0 */		.word	77
/* 0x0498	   0 */		.align	4
/* 0x0498	   0 */		.word	-1
/* 0x049c	   0 */		.word	-1
/* 0x04a0	   0 */		.word	333
/* 0x04a4	   0 */		.word	65571
/* 0x04a8	   0 */		.word	1
/* 0x04ac	   0 */		.word	78
/* 0x04b0	   0 */		.align	4
/* 0x04b0	   0 */		.word	-1
/* 0x04b4	   0 */		.word	-1
/* 0x04b8	   0 */		.word	340
/* 0x04bc	   0 */		.word	65571
/* 0x04c0	   0 */		.word	1
/* 0x04c4	   0 */		.word	79
/* 0x04c8	   0 */		.align	4
/* 0x04c8	   0 */		.word	-1
/* 0x04cc	   0 */		.word	-1
/* 0x04d0	   0 */		.word	347
/* 0x04d4	   0 */		.word	65571
/* 0x04d8	   0 */		.word	1
/* 0x04dc	   0 */		.word	80
/* 0x04e0	   0 */		.align	4
/* 0x04e0	   0 */		.word	-1
/* 0x04e4	   0 */		.word	-1
/* 0x04e8	   0 */		.word	246
/* 0x04ec	   0 */		.word	4148
/* 0x04f0	   0 */		.word	3
/* 0x04f4	   0 */		.word	81
/* 0x04f8	   0 */		.align	4
/* 0x04f8	   0 */		.word	-1
/* 0x04fc	   0 */		.word	-1
/* 0x0500	   0 */		.word	253
/* 0x0504	   0 */		.word	4148
/* 0x0508	   0 */		.word	3
/* 0x050c	   0 */		.word	84
/* 0x0510	   0 */		.align	4
/* 0x0510	   0 */		.word	-1
/* 0x0514	   0 */		.word	-1
/* 0x0518	   0 */		.word	263
/* 0x051c	   0 */		.word	4148
/* 0x0520	   0 */		.word	3
/* 0x0524	   0 */		.word	87
/* 0x0528	   0 */		.align	4
/* 0x0528	   0 */		.word	-1
/* 0x052c	   0 */		.word	-1
/* 0x0530	   0 */		.word	270
/* 0x0534	   0 */		.word	4148
/* 0x0538	   0 */		.word	3
/* 0x053c	   0 */		.word	90
/* 0x0540	   0 */		.align	4
/* 0x0540	   0 */		.word	-1
/* 0x0544	   0 */		.word	-1
/* 0x0548	   0 */		.word	277
/* 0x054c	   0 */		.word	4148
/* 0x0550	   0 */		.word	3
/* 0x0554	   0 */		.word	93
/* 0x0558	   0 */		.align	4
/* 0x0558	   0 */		.word	-1
/* 0x055c	   0 */		.word	-1
/* 0x0560	   0 */		.word	284
/* 0x0564	   0 */		.word	4148
/* 0x0568	   0 */		.word	3
/* 0x056c	   0 */		.word	96
/* 0x0570	   0 */		.align	4
/* 0x0570	   0 */		.word	-1
/* 0x0574	   0 */		.word	-1
/* 0x0578	   0 */		.word	291
/* 0x057c	   0 */		.word	4148
/* 0x0580	   0 */		.word	3
/* 0x0584	   0 */		.word	99
/* 0x0588	   0 */		.align	4
/* 0x0588	   0 */		.word	-1
/* 0x058c	   0 */		.word	-1
/* 0x0590	   0 */		.word	298
/* 0x0594	   0 */		.word	4148
/* 0x0598	   0 */		.word	3
/* 0x059c	   0 */		.word	102
/* 0x05a0	   0 */		.align	4
/* 0x05a0	   0 */		.word	-1
/* 0x05a4	   0 */		.word	-1
/* 0x05a8	   0 */		.word	305
/* 0x05ac	   0 */		.word	4148
/* 0x05b0	   0 */		.word	3
/* 0x05b4	   0 */		.word	105
/* 0x05b8	   0 */		.align	4
/* 0x05b8	   0 */		.word	-1
/* 0x05bc	   0 */		.word	-1
/* 0x05c0	   0 */		.word	312
/* 0x05c4	   0 */		.word	4148
/* 0x05c8	   0 */		.word	3
/* 0x05cc	   0 */		.word	108
/* 0x05d0	   0 */		.align	4
/* 0x05d0	   0 */		.word	-1
/* 0x05d4	   0 */		.word	-1
/* 0x05d8	   0 */		.word	319
/* 0x05dc	   0 */		.word	4148
/* 0x05e0	   0 */		.word	3
/* 0x05e4	   0 */		.word	111
/* 0x05e8	   0 */		.align	4
/* 0x05e8	   0 */		.word	-1
/* 0x05ec	   0 */		.word	-1
/* 0x05f0	   0 */		.word	326
/* 0x05f4	   0 */		.word	4148
/* 0x05f8	   0 */		.word	3
/* 0x05fc	   0 */		.word	114
/* 0x0600	   0 */		.align	4
/* 0x0600	   0 */		.word	-1
/* 0x0604	   0 */		.word	-1
/* 0x0608	   0 */		.word	333
/* 0x060c	   0 */		.word	4148
/* 0x0610	   0 */		.word	3
/* 0x0614	   0 */		.word	117
/* 0x0618	   0 */		.align	4
/* 0x0618	   0 */		.word	-1
/* 0x061c	   0 */		.word	-1
/* 0x0620	   0 */		.word	340
/* 0x0624	   0 */		.word	4148
/* 0x0628	   0 */		.word	3
/* 0x062c	   0 */		.word	120
/* 0x0630	   0 */		.align	4
/* 0x0630	   0 */		.word	-1
/* 0x0634	   0 */		.word	-1
/* 0x0638	   0 */		.word	347
/* 0x063c	   0 */		.word	4148
/* 0x0640	   0 */		.word	3
/* 0x0644	   0 */		.word	123
/* 0x0648	   0 */		.align	4
/* 0x0648	   0 */		.word	-1
/* 0x064c	   0 */		.word	-1
/* 0x0650	   0 */		.word	375
/* 0x0654	   0 */		.word	16414
/* 0x0658	   0 */		.word	1
/* 0x065c	   0 */		.word	126
/* 0x0660	   0 */		.align	4
/* 0x0660	   0 */		.word	-1
/* 0x0664	   0 */		.word	-1
/* 0x0668	   0 */		.word	537
/* 0x066c	   0 */		.word	16414
/* 0x0670	   0 */		.word	1
/* 0x0674	   0 */		.word	127
/* 0x0678	   0 */		.align	4
/* 0x0678	   0 */		.word	-1
/* 0x067c	   0 */		.word	-1
/* 0x0680	   0 */		.word	380
/* 0x0684	   0 */		.word	65571
/* 0x0688	   0 */		.word	1
/* 0x068c	   0 */		.word	128
/* 0x0690	   0 */		.align	4
/* 0x0690	   0 */		.word	-1
/* 0x0694	   0 */		.word	-1
/* 0x0698	   0 */		.word	392
/* 0x069c	   0 */		.word	65571
/* 0x06a0	   0 */		.word	1
/* 0x06a4	   0 */		.word	129
/* 0x06a8	   0 */		.align	4
/* 0x06a8	   0 */		.word	-1
/* 0x06ac	   0 */		.word	-1
/* 0x06b0	   0 */		.word	406
/* 0x06b4	   0 */		.word	65571
/* 0x06b8	   0 */		.word	1
/* 0x06bc	   0 */		.word	130
/* 0x06c0	   0 */		.align	4
/* 0x06c0	   0 */		.word	-1
/* 0x06c4	   0 */		.word	-1
/* 0x06c8	   0 */		.word	416
/* 0x06cc	   0 */		.word	65571
/* 0x06d0	   0 */		.word	1
/* 0x06d4	   0 */		.word	131
/* 0x06d8	   0 */		.align	4
/* 0x06d8	   0 */		.word	-1
/* 0x06dc	   0 */		.word	-1
/* 0x06e0	   0 */		.word	426
/* 0x06e4	   0 */		.word	65571
/* 0x06e8	   0 */		.word	1
/* 0x06ec	   0 */		.word	132
/* 0x06f0	   0 */		.align	4
/* 0x06f0	   0 */		.word	-1
/* 0x06f4	   0 */		.word	-1
/* 0x06f8	   0 */		.word	436
/* 0x06fc	   0 */		.word	65571
/* 0x0700	   0 */		.word	1
/* 0x0704	   0 */		.word	133
/* 0x0708	   0 */		.align	4
/* 0x0708	   0 */		.word	-1
/* 0x070c	   0 */		.word	-1
/* 0x0710	   0 */		.word	446
/* 0x0714	   0 */		.word	65571
/* 0x0718	   0 */		.word	1
/* 0x071c	   0 */		.word	134
/* 0x0720	   0 */		.align	4
/* 0x0720	   0 */		.word	-1
/* 0x0724	   0 */		.word	-1
/* 0x0728	   0 */		.word	456
/* 0x072c	   0 */		.word	65571
/* 0x0730	   0 */		.word	1
/* 0x0734	   0 */		.word	135
/* 0x0738	   0 */		.align	4
/* 0x0738	   0 */		.word	-1
/* 0x073c	   0 */		.word	-1
/* 0x0740	   0 */		.word	466
/* 0x0744	   0 */		.word	65571
/* 0x0748	   0 */		.word	1
/* 0x074c	   0 */		.word	136
/* 0x0750	   0 */		.align	4
/* 0x0750	   0 */		.word	-1
/* 0x0754	   0 */		.word	-1
/* 0x0758	   0 */		.word	476
/* 0x075c	   0 */		.word	65571
/* 0x0760	   0 */		.word	1
/* 0x0764	   0 */		.word	137
/* 0x0768	   0 */		.align	4
/* 0x0768	   0 */		.word	-1
/* 0x076c	   0 */		.word	-1
/* 0x0770	   0 */		.word	486
/* 0x0774	   0 */		.word	65571
/* 0x0778	   0 */		.word	1
/* 0x077c	   0 */		.word	138
/* 0x0780	   0 */		.align	4
/* 0x0780	   0 */		.word	-1
/* 0x0784	   0 */		.word	-1
/* 0x0788	   0 */		.word	496
/* 0x078c	   0 */		.word	65571
/* 0x0790	   0 */		.word	1
/* 0x0794	   0 */		.word	139
/* 0x0798	   0 */		.align	4
/* 0x0798	   0 */		.word	-1
/* 0x079c	   0 */		.word	-1
/* 0x07a0	   0 */		.word	506
/* 0x07a4	   0 */		.word	65571
/* 0x07a8	   0 */		.word	1
/* 0x07ac	   0 */		.word	140
/* 0x07b0	   0 */		.align	4
/* 0x07b0	   0 */		.word	-1
/* 0x07b4	   0 */		.word	-1
/* 0x07b8	   0 */		.word	516
/* 0x07bc	   0 */		.word	65571
/* 0x07c0	   0 */		.word	1
/* 0x07c4	   0 */		.word	141
/* 0x07c8	   0 */		.align	4
/* 0x07c8	   0 */		.word	-1
/* 0x07cc	   0 */		.word	-1
/* 0x07d0	   0 */		.word	526
/* 0x07d4	   0 */		.word	65571
/* 0x07d8	   0 */		.word	1
/* 0x07dc	   0 */		.word	142
/* 0x07e0	   0 */		.align	4
/* 0x07e0	   0 */		.word	-1
/* 0x07e4	   0 */		.word	-1
/* 0x07e8	   0 */		.word	380
/* 0x07ec	   0 */		.word	4148
/* 0x07f0	   0 */		.word	3
/* 0x07f4	   0 */		.word	143
/* 0x07f8	   0 */		.align	4
/* 0x07f8	   0 */		.word	-1
/* 0x07fc	   0 */		.word	-1
/* 0x0800	   0 */		.word	392
/* 0x0804	   0 */		.word	4148
/* 0x0808	   0 */		.word	3
/* 0x080c	   0 */		.word	146
/* 0x0810	   0 */		.align	4
/* 0x0810	   0 */		.word	-1
/* 0x0814	   0 */		.word	-1
/* 0x0818	   0 */		.word	406
/* 0x081c	   0 */		.word	4148
/* 0x0820	   0 */		.word	3
/* 0x0824	   0 */		.word	149
/* 0x0828	   0 */		.align	4
/* 0x0828	   0 */		.word	-1
/* 0x082c	   0 */		.word	-1
/* 0x0830	   0 */		.word	416
/* 0x0834	   0 */		.word	4148
/* 0x0838	   0 */		.word	3
/* 0x083c	   0 */		.word	152
/* 0x0840	   0 */		.align	4
/* 0x0840	   0 */		.word	-1
/* 0x0844	   0 */		.word	-1
/* 0x0848	   0 */		.word	426
/* 0x084c	   0 */		.word	4148
/* 0x0850	   0 */		.word	3
/* 0x0854	   0 */		.word	155
/* 0x0858	   0 */		.align	4
/* 0x0858	   0 */		.word	-1
/* 0x085c	   0 */		.word	-1
/* 0x0860	   0 */		.word	436
/* 0x0864	   0 */		.word	4148
/* 0x0868	   0 */		.word	3
/* 0x086c	   0 */		.word	158
/* 0x0870	   0 */		.align	4
/* 0x0870	   0 */		.word	-1
/* 0x0874	   0 */		.word	-1
/* 0x0878	   0 */		.word	446
/* 0x087c	   0 */		.word	4148
/* 0x0880	   0 */		.word	3
/* 0x0884	   0 */		.word	161
/* 0x0888	   0 */		.align	4
/* 0x0888	   0 */		.word	-1
/* 0x088c	   0 */		.word	-1
/* 0x0890	   0 */		.word	456
/* 0x0894	   0 */		.word	4148
/* 0x0898	   0 */		.word	3
/* 0x089c	   0 */		.word	164
/* 0x08a0	   0 */		.align	4
/* 0x08a0	   0 */		.word	-1
/* 0x08a4	   0 */		.word	-1
/* 0x08a8	   0 */		.word	466
/* 0x08ac	   0 */		.word	4148
/* 0x08b0	   0 */		.word	3
/* 0x08b4	   0 */		.word	167
/* 0x08b8	   0 */		.align	4
/* 0x08b8	   0 */		.word	-1
/* 0x08bc	   0 */		.word	-1
/* 0x08c0	   0 */		.word	476
/* 0x08c4	   0 */		.word	4148
/* 0x08c8	   0 */		.word	3
/* 0x08cc	   0 */		.word	170
/* 0x08d0	   0 */		.align	4
/* 0x08d0	   0 */		.word	-1
/* 0x08d4	   0 */		.word	-1
/* 0x08d8	   0 */		.word	486
/* 0x08dc	   0 */		.word	4148
/* 0x08e0	   0 */		.word	3
/* 0x08e4	   0 */		.word	173
/* 0x08e8	   0 */		.align	4
/* 0x08e8	   0 */		.word	-1
/* 0x08ec	   0 */		.word	-1
/* 0x08f0	   0 */		.word	496
/* 0x08f4	   0 */		.word	4148
/* 0x08f8	   0 */		.word	3
/* 0x08fc	   0 */		.word	176
/* 0x0900	   0 */		.align	4
/* 0x0900	   0 */		.word	-1
/* 0x0904	   0 */		.word	-1
/* 0x0908	   0 */		.word	506
/* 0x090c	   0 */		.word	4148
/* 0x0910	   0 */		.word	3
/* 0x0914	   0 */		.word	179
/* 0x0918	   0 */		.align	4
/* 0x0918	   0 */		.word	-1
/* 0x091c	   0 */		.word	-1
/* 0x0920	   0 */		.word	516
/* 0x0924	   0 */		.word	4148
/* 0x0928	   0 */		.word	3
/* 0x092c	   0 */		.word	182
/* 0x0930	   0 */		.align	4
/* 0x0930	   0 */		.word	-1
/* 0x0934	   0 */		.word	-1
/* 0x0938	   0 */		.word	526
/* 0x093c	   0 */		.word	4148
/* 0x0940	   0 */		.word	3
/* 0x0944	   0 */		.word	185
/* 0x0948	   0 */		.align	4
/* 0x0948	   0 */		.word	-1
/* 0x094c	   0 */		.word	-1
/* 0x0950	   0 */		.word	560
/* 0x0954	   0 */		.word	16414
/* 0x0958	   0 */		.word	1
/* 0x095c	   0 */		.word	188
/* 0x0960	   0 */		.align	4
/* 0x0960	   0 */		.word	-1
/* 0x0964	   0 */		.word	-1
/* 0x0968	   0 */		.word	723
/* 0x096c	   0 */		.word	16414
/* 0x0970	   0 */		.word	1
/* 0x0974	   0 */		.word	189
/* 0x0978	   0 */		.align	4
/* 0x0978	   0 */		.word	-1
/* 0x097c	   0 */		.word	-1
/* 0x0980	   0 */		.word	566
/* 0x0984	   0 */		.word	65571
/* 0x0988	   0 */		.word	1
/* 0x098c	   0 */		.word	190
/* 0x0990	   0 */		.align	4
/* 0x0990	   0 */		.word	-1
/* 0x0994	   0 */		.word	-1
/* 0x0998	   0 */		.word	578
/* 0x099c	   0 */		.word	65571
/* 0x09a0	   0 */		.word	1
/* 0x09a4	   0 */		.word	191
/* 0x09a8	   0 */		.align	4
/* 0x09a8	   0 */		.word	-1
/* 0x09ac	   0 */		.word	-1
/* 0x09b0	   0 */		.word	592
/* 0x09b4	   0 */		.word	65571
/* 0x09b8	   0 */		.word	1
/* 0x09bc	   0 */		.word	192
/* 0x09c0	   0 */		.align	4
/* 0x09c0	   0 */		.word	-1
/* 0x09c4	   0 */		.word	-1
/* 0x09c8	   0 */		.word	602
/* 0x09cc	   0 */		.word	65571
/* 0x09d0	   0 */		.word	1
/* 0x09d4	   0 */		.word	193
/* 0x09d8	   0 */		.align	4
/* 0x09d8	   0 */		.word	-1
/* 0x09dc	   0 */		.word	-1
/* 0x09e0	   0 */		.word	612
/* 0x09e4	   0 */		.word	65571
/* 0x09e8	   0 */		.word	1
/* 0x09ec	   0 */		.word	194
/* 0x09f0	   0 */		.align	4
/* 0x09f0	   0 */		.word	-1
/* 0x09f4	   0 */		.word	-1
/* 0x09f8	   0 */		.word	622
/* 0x09fc	   0 */		.word	65571
/* 0x0a00	   0 */		.word	1
/* 0x0a04	   0 */		.word	195
/* 0x0a08	   0 */		.align	4
/* 0x0a08	   0 */		.word	-1
/* 0x0a0c	   0 */		.word	-1
/* 0x0a10	   0 */		.word	632
/* 0x0a14	   0 */		.word	65571
/* 0x0a18	   0 */		.word	1
/* 0x0a1c	   0 */		.word	196
/* 0x0a20	   0 */		.align	4
/* 0x0a20	   0 */		.word	-1
/* 0x0a24	   0 */		.word	-1
/* 0x0a28	   0 */		.word	642
/* 0x0a2c	   0 */		.word	65571
/* 0x0a30	   0 */		.word	1
/* 0x0a34	   0 */		.word	197
/* 0x0a38	   0 */		.align	4
/* 0x0a38	   0 */		.word	-1
/* 0x0a3c	   0 */		.word	-1
/* 0x0a40	   0 */		.word	652
/* 0x0a44	   0 */		.word	65571
/* 0x0a48	   0 */		.word	1
/* 0x0a4c	   0 */		.word	198
/* 0x0a50	   0 */		.align	4
/* 0x0a50	   0 */		.word	-1
/* 0x0a54	   0 */		.word	-1
/* 0x0a58	   0 */		.word	662
/* 0x0a5c	   0 */		.word	65571
/* 0x0a60	   0 */		.word	1
/* 0x0a64	   0 */		.word	199
/* 0x0a68	   0 */		.align	4
/* 0x0a68	   0 */		.word	-1
/* 0x0a6c	   0 */		.word	-1
/* 0x0a70	   0 */		.word	672
/* 0x0a74	   0 */		.word	65571
/* 0x0a78	   0 */		.word	1
/* 0x0a7c	   0 */		.word	200
/* 0x0a80	   0 */		.align	4
/* 0x0a80	   0 */		.word	-1
/* 0x0a84	   0 */		.word	-1
/* 0x0a88	   0 */		.word	682
/* 0x0a8c	   0 */		.word	65571
/* 0x0a90	   0 */		.word	1
/* 0x0a94	   0 */		.word	201
/* 0x0a98	   0 */		.align	4
/* 0x0a98	   0 */		.word	-1
/* 0x0a9c	   0 */		.word	-1
/* 0x0aa0	   0 */		.word	692
/* 0x0aa4	   0 */		.word	65571
/* 0x0aa8	   0 */		.word	1
/* 0x0aac	   0 */		.word	202
/* 0x0ab0	   0 */		.align	4
/* 0x0ab0	   0 */		.word	-1
/* 0x0ab4	   0 */		.word	-1
/* 0x0ab8	   0 */		.word	702
/* 0x0abc	   0 */		.word	65571
/* 0x0ac0	   0 */		.word	1
/* 0x0ac4	   0 */		.word	203
/* 0x0ac8	   0 */		.align	4
/* 0x0ac8	   0 */		.word	-1
/* 0x0acc	   0 */		.word	-1
/* 0x0ad0	   0 */		.word	712
/* 0x0ad4	   0 */		.word	65571
/* 0x0ad8	   0 */		.word	1
/* 0x0adc	   0 */		.word	204
/* 0x0ae0	   0 */		.align	4
/* 0x0ae0	   0 */		.word	-1
/* 0x0ae4	   0 */		.word	-1
/* 0x0ae8	   0 */		.word	566
/* 0x0aec	   0 */		.word	4148
/* 0x0af0	   0 */		.word	3
/* 0x0af4	   0 */		.word	205
/* 0x0af8	   0 */		.align	4
/* 0x0af8	   0 */		.word	-1
/* 0x0afc	   0 */		.word	-1
/* 0x0b00	   0 */		.word	578
/* 0x0b04	   0 */		.word	4148
/* 0x0b08	   0 */		.word	3
/* 0x0b0c	   0 */		.word	208
/* 0x0b10	   0 */		.align	4
/* 0x0b10	   0 */		.word	-1
/* 0x0b14	   0 */		.word	-1
/* 0x0b18	   0 */		.word	592
/* 0x0b1c	   0 */		.word	4148
/* 0x0b20	   0 */		.word	3
/* 0x0b24	   0 */		.word	211
/* 0x0b28	   0 */		.align	4
/* 0x0b28	   0 */		.word	-1
/* 0x0b2c	   0 */		.word	-1
/* 0x0b30	   0 */		.word	602
/* 0x0b34	   0 */		.word	4148
/* 0x0b38	   0 */		.word	3
/* 0x0b3c	   0 */		.word	214
/* 0x0b40	   0 */		.align	4
/* 0x0b40	   0 */		.word	-1
/* 0x0b44	   0 */		.word	-1
/* 0x0b48	   0 */		.word	612
/* 0x0b4c	   0 */		.word	4148
/* 0x0b50	   0 */		.word	3
/* 0x0b54	   0 */		.word	217
/* 0x0b58	   0 */		.align	4
/* 0x0b58	   0 */		.word	-1
/* 0x0b5c	   0 */		.word	-1
/* 0x0b60	   0 */		.word	622
/* 0x0b64	   0 */		.word	4148
/* 0x0b68	   0 */		.word	3
/* 0x0b6c	   0 */		.word	220
/* 0x0b70	   0 */		.align	4
/* 0x0b70	   0 */		.word	-1
/* 0x0b74	   0 */		.word	-1
/* 0x0b78	   0 */		.word	632
/* 0x0b7c	   0 */		.word	4148
/* 0x0b80	   0 */		.word	3
/* 0x0b84	   0 */		.word	223
/* 0x0b88	   0 */		.align	4
/* 0x0b88	   0 */		.word	-1
/* 0x0b8c	   0 */		.word	-1
/* 0x0b90	   0 */		.word	642
/* 0x0b94	   0 */		.word	4148
/* 0x0b98	   0 */		.word	3
/* 0x0b9c	   0 */		.word	226
/* 0x0ba0	   0 */		.align	4
/* 0x0ba0	   0 */		.word	-1
/* 0x0ba4	   0 */		.word	-1
/* 0x0ba8	   0 */		.word	652
/* 0x0bac	   0 */		.word	4148
/* 0x0bb0	   0 */		.word	3
/* 0x0bb4	   0 */		.word	229
/* 0x0bb8	   0 */		.align	4
/* 0x0bb8	   0 */		.word	-1
/* 0x0bbc	   0 */		.word	-1
/* 0x0bc0	   0 */		.word	662
/* 0x0bc4	   0 */		.word	4148
/* 0x0bc8	   0 */		.word	3
/* 0x0bcc	   0 */		.word	232
/* 0x0bd0	   0 */		.align	4
/* 0x0bd0	   0 */		.word	-1
/* 0x0bd4	   0 */		.word	-1
/* 0x0bd8	   0 */		.word	672
/* 0x0bdc	   0 */		.word	4148
/* 0x0be0	   0 */		.word	3
/* 0x0be4	   0 */		.word	235
/* 0x0be8	   0 */		.align	4
/* 0x0be8	   0 */		.word	-1
/* 0x0bec	   0 */		.word	-1
/* 0x0bf0	   0 */		.word	682
/* 0x0bf4	   0 */		.word	4148
/* 0x0bf8	   0 */		.word	3
/* 0x0bfc	   0 */		.word	238
/* 0x0c00	   0 */		.align	4
/* 0x0c00	   0 */		.word	-1
/* 0x0c04	   0 */		.word	-1
/* 0x0c08	   0 */		.word	692
/* 0x0c0c	   0 */		.word	4148
/* 0x0c10	   0 */		.word	3
/* 0x0c14	   0 */		.word	241
/* 0x0c18	   0 */		.align	4
/* 0x0c18	   0 */		.word	-1
/* 0x0c1c	   0 */		.word	-1
/* 0x0c20	   0 */		.word	702
/* 0x0c24	   0 */		.word	4148
/* 0x0c28	   0 */		.word	3
/* 0x0c2c	   0 */		.word	244
/* 0x0c30	   0 */		.align	4
/* 0x0c30	   0 */		.word	-1
/* 0x0c34	   0 */		.word	-1
/* 0x0c38	   0 */		.word	712
/* 0x0c3c	   0 */		.word	4148
/* 0x0c40	   0 */		.word	3
/* 0x0c44	   0 */		.word	247
/* 0x0c48	   0 */		.word	8
/* 0x0c4c	   0 */		.word	8
/* 0x0c50	   0 */		.word	8
/* 0x0c54	   0 */		.word	8
/* 0x0c58	   0 */		.word	8
/* 0x0c5c	   0 */		.word	17
/* 0x0c60	   0 */		.word	20
/* 0x0c64	   0 */		.word	23
/* 0x0c68	   0 */		.word	26
/* 0x0c6c	   0 */		.word	29
/* 0x0c70	   0 */		.word	32
/* 0x0c74	   0 */		.word	35
/* 0x0c78	   0 */		.word	38
/* 0x0c7c	   0 */		.word	41
/* 0x0c80	   0 */		.word	44
/* 0x0c84	   0 */		.word	48
/* 0x0c88	   0 */		.word	52
/* 0x0c8c	   0 */		.word	56
/* 0x0c90	   0 */		.word	60
/* 0x0c94	   0 */		.word	64
/* 0x0c98	   0 */		.word	17
/* 0x0c9c	   0 */		.word	68
/* 0x0ca0	   0 */		.word	97
/* 0x0ca4	   0 */		.word	20
/* 0x0ca8	   0 */		.word	68
/* 0x0cac	   0 */		.word	101
/* 0x0cb0	   0 */		.word	23
/* 0x0cb4	   0 */		.word	68
/* 0x0cb8	   0 */		.word	105
/* 0x0cbc	   0 */		.word	26
/* 0x0cc0	   0 */		.word	68
/* 0x0cc4	   0 */		.word	109
/* 0x0cc8	   0 */		.word	29
/* 0x0ccc	   0 */		.word	68
/* 0x0cd0	   0 */		.word	113
/* 0x0cd4	   0 */		.word	32
/* 0x0cd8	   0 */		.word	68
/* 0x0cdc	   0 */		.word	117
/* 0x0ce0	   0 */		.word	35
/* 0x0ce4	   0 */		.word	68
/* 0x0ce8	   0 */		.word	121
/* 0x0cec	   0 */		.word	38
/* 0x0cf0	   0 */		.word	68
/* 0x0cf4	   0 */		.word	125
/* 0x0cf8	   0 */		.word	41
/* 0x0cfc	   0 */		.word	68
/* 0x0d00	   0 */		.word	129
/* 0x0d04	   0 */		.word	44
/* 0x0d08	   0 */		.word	68
/* 0x0d0c	   0 */		.word	133
/* 0x0d10	   0 */		.word	48
/* 0x0d14	   0 */		.word	68
/* 0x0d18	   0 */		.word	137
/* 0x0d1c	   0 */		.word	52
/* 0x0d20	   0 */		.word	68
/* 0x0d24	   0 */		.word	141
/* 0x0d28	   0 */		.word	56
/* 0x0d2c	   0 */		.word	68
/* 0x0d30	   0 */		.word	145
/* 0x0d34	   0 */		.word	60
/* 0x0d38	   0 */		.word	68
/* 0x0d3c	   0 */		.word	149
/* 0x0d40	   0 */		.word	64
/* 0x0d44	   0 */		.word	68
/* 0x0d48	   0 */		.word	153
/* 0x0d4c	   0 */		.word	8
/* 0x0d50	   0 */		.word	157
/* 0x0d54	   0 */		.word	161
/* 0x0d58	   0 */		.word	165
/* 0x0d5c	   0 */		.word	169
/* 0x0d60	   0 */		.word	173
/* 0x0d64	   0 */		.word	177
/* 0x0d68	   0 */		.word	181
/* 0x0d6c	   0 */		.word	185
/* 0x0d70	   0 */		.word	189
/* 0x0d74	   0 */		.word	193
/* 0x0d78	   0 */		.word	197
/* 0x0d7c	   0 */		.word	201
/* 0x0d80	   0 */		.word	205
/* 0x0d84	   0 */		.word	209
/* 0x0d88	   0 */		.word	213
/* 0x0d8c	   0 */		.word	157
/* 0x0d90	   0 */		.word	68
/* 0x0d94	   0 */		.word	217
/* 0x0d98	   0 */		.word	161
/* 0x0d9c	   0 */		.word	68
/* 0x0da0	   0 */		.word	222
/* 0x0da4	   0 */		.word	165
/* 0x0da8	   0 */		.word	68
/* 0x0dac	   0 */		.word	227
/* 0x0db0	   0 */		.word	169
/* 0x0db4	   0 */		.word	68
/* 0x0db8	   0 */		.word	231
/* 0x0dbc	   0 */		.word	173
/* 0x0dc0	   0 */		.word	68
/* 0x0dc4	   0 */		.word	236
/* 0x0dc8	   0 */		.word	177
/* 0x0dcc	   0 */		.word	68
/* 0x0dd0	   0 */		.word	240
/* 0x0dd4	   0 */		.word	181
/* 0x0dd8	   0 */		.word	68
/* 0x0ddc	   0 */		.word	245
/* 0x0de0	   0 */		.word	185
/* 0x0de4	   0 */		.word	68
/* 0x0de8	   0 */		.word	250
/* 0x0dec	   0 */		.word	189
/* 0x0df0	   0 */		.word	68
/* 0x0df4	   0 */		.word	255
/* 0x0df8	   0 */		.word	193
/* 0x0dfc	   0 */		.word	68
/* 0x0e00	   0 */		.word	260
/* 0x0e04	   0 */		.word	197
/* 0x0e08	   0 */		.word	68
/* 0x0e0c	   0 */		.word	265
/* 0x0e10	   0 */		.word	201
/* 0x0e14	   0 */		.word	68
/* 0x0e18	   0 */		.word	269
/* 0x0e1c	   0 */		.word	205
/* 0x0e20	   0 */		.word	68
/* 0x0e24	   0 */		.word	274
/* 0x0e28	   0 */		.word	209
/* 0x0e2c	   0 */		.word	68
/* 0x0e30	   0 */		.word	279
/* 0x0e34	   0 */		.word	213
/* 0x0e38	   0 */		.word	68
/* 0x0e3c	   0 */		.word	283
/* 0x0e40	   0 */		.word	287
/* 0x0e44	   0 */		.word	306
/* 0x0e48	   0 */		.word	317
/* 0x0e4c	   0 */		.word	321
/* 0x0e50	   0 */		.word	325
/* 0x0e54	   0 */		.word	329
/* 0x0e58	   0 */		.word	333
/* 0x0e5c	   0 */		.word	337
/* 0x0e60	   0 */		.word	341
/* 0x0e64	   0 */		.word	345
/* 0x0e68	   0 */		.word	349
/* 0x0e6c	   0 */		.word	353
/* 0x0e70	   0 */		.word	357
/* 0x0e74	   0 */		.word	361
/* 0x0e78	   0 */		.word	365
/* 0x0e7c	   0 */		.word	369
/* 0x0e80	   0 */		.word	373
/* 0x0e84	   0 */		.word	317
/* 0x0e88	   0 */		.word	68
/* 0x0e8c	   0 */		.word	377
/* 0x0e90	   0 */		.word	321
/* 0x0e94	   0 */		.word	68
/* 0x0e98	   0 */		.word	382
/* 0x0e9c	   0 */		.word	325
/* 0x0ea0	   0 */		.word	68
/* 0x0ea4	   0 */		.word	387
/* 0x0ea8	   0 */		.word	329
/* 0x0eac	   0 */		.word	68
/* 0x0eb0	   0 */		.word	392
/* 0x0eb4	   0 */		.word	333
/* 0x0eb8	   0 */		.word	68
/* 0x0ebc	   0 */		.word	397
/* 0x0ec0	   0 */		.word	337
/* 0x0ec4	   0 */		.word	68
/* 0x0ec8	   0 */		.word	402
/* 0x0ecc	   0 */		.word	341
/* 0x0ed0	   0 */		.word	68
/* 0x0ed4	   0 */		.word	407
/* 0x0ed8	   0 */		.word	345
/* 0x0edc	   0 */		.word	68
/* 0x0ee0	   0 */		.word	412
/* 0x0ee4	   0 */		.word	349
/* 0x0ee8	   0 */		.word	68
/* 0x0eec	   0 */		.word	417
/* 0x0ef0	   0 */		.word	353
/* 0x0ef4	   0 */		.word	68
/* 0x0ef8	   0 */		.word	422
/* 0x0efc	   0 */		.word	357
/* 0x0f00	   0 */		.word	68
/* 0x0f04	   0 */		.word	427
/* 0x0f08	   0 */		.word	361
/* 0x0f0c	   0 */		.word	68
/* 0x0f10	   0 */		.word	432
/* 0x0f14	   0 */		.word	365
/* 0x0f18	   0 */		.word	68
/* 0x0f1c	   0 */		.word	437
/* 0x0f20	   0 */		.word	369
/* 0x0f24	   0 */		.word	68
/* 0x0f28	   0 */		.word	442
/* 0x0f2c	   0 */		.word	373
/* 0x0f30	   0 */		.word	68
/* 0x0f34	   0 */		.word	447
/* 0x0f38	   0 */		.word	452
/* 0x0f3c	   0 */		.word	306
/* 0x0f40	   0 */		.word	473
/* 0x0f44	   0 */		.word	477
/* 0x0f48	   0 */		.word	481
/* 0x0f4c	   0 */		.word	485
/* 0x0f50	   0 */		.word	489
/* 0x0f54	   0 */		.word	493
/* 0x0f58	   0 */		.word	497
/* 0x0f5c	   0 */		.word	501
/* 0x0f60	   0 */		.word	505
/* 0x0f64	   0 */		.word	509
/* 0x0f68	   0 */		.word	513
/* 0x0f6c	   0 */		.word	517
/* 0x0f70	   0 */		.word	521
/* 0x0f74	   0 */		.word	525
/* 0x0f78	   0 */		.word	529
/* 0x0f7c	   0 */		.word	473
/* 0x0f80	   0 */		.word	68
/* 0x0f84	   0 */		.word	533
/* 0x0f88	   0 */		.word	477
/* 0x0f8c	   0 */		.word	68
/* 0x0f90	   0 */		.word	538
/* 0x0f94	   0 */		.word	481
/* 0x0f98	   0 */		.word	68
/* 0x0f9c	   0 */		.word	543
/* 0x0fa0	   0 */		.word	485
/* 0x0fa4	   0 */		.word	68
/* 0x0fa8	   0 */		.word	548
/* 0x0fac	   0 */		.word	489
/* 0x0fb0	   0 */		.word	68
/* 0x0fb4	   0 */		.word	553
/* 0x0fb8	   0 */		.word	493
/* 0x0fbc	   0 */		.word	68
/* 0x0fc0	   0 */		.word	558
/* 0x0fc4	   0 */		.word	497
/* 0x0fc8	   0 */		.word	68
/* 0x0fcc	   0 */		.word	563
/* 0x0fd0	   0 */		.word	501
/* 0x0fd4	   0 */		.word	68
/* 0x0fd8	   0 */		.word	568
/* 0x0fdc	   0 */		.word	505
/* 0x0fe0	   0 */		.word	68
/* 0x0fe4	   0 */		.word	573
/* 0x0fe8	   0 */		.word	509
/* 0x0fec	   0 */		.word	68
/* 0x0ff0	   0 */		.word	578
/* 0x0ff4	   0 */		.word	513
/* 0x0ff8	   0 */		.word	68
/* 0x0ffc	   0 */		.word	583
/* 0x1000	   0 */		.word	517
/* 0x1004	   0 */		.word	68
/* 0x1008	   0 */		.word	588
/* 0x100c	   0 */		.word	521
/* 0x1010	   0 */		.word	68
/* 0x1014	   0 */		.word	593
/* 0x1018	   0 */		.word	525
/* 0x101c	   0 */		.word	68
/* 0x1020	   0 */		.word	598
/* 0x1024	   0 */		.word	529
/* 0x1028	   0 */		.word	68
/* 0x102c	   0 */		.word	603
/* 0x1030	   0 */		.asciz	"logic.c"
/* 0x1038	   0 */		.asciz	"gl_error"
/* 0x1041	   0 */		.asciz	"L1"
/* 0x1044	   0 */		.asciz	"L2"
/* 0x1047	   0 */		.asciz	"L3"
/* 0x104a	   0 */		.asciz	"L4"
/* 0x104d	   0 */		.asciz	"L5"
/* 0x1050	   0 */		.asciz	"L6"
/* 0x1053	   0 */		.asciz	"L7"
/* 0x1056	   0 */		.asciz	"L8"
/* 0x1059	   0 */		.asciz	"L9"
/* 0x105c	   0 */		.asciz	"L10"
/* 0x1060	   0 */		.asciz	"L11"
/* 0x1064	   0 */		.asciz	"L12"
/* 0x1068	   0 */		.asciz	"L13"
/* 0x106c	   0 */		.asciz	"L14"
/* 0x1070	   0 */		.asciz	"L15"
/* 0x1074	   0 */		.asciz	"dynamic-alias-disambiguation"
/* 0x1091	   0 */		.asciz	"L85"
/* 0x1095	   0 */		.asciz	"L87"
/* 0x1099	   0 */		.asciz	"L63"
/* 0x109d	   0 */		.asciz	"L77"
/* 0x10a1	   0 */		.asciz	"L67"
/* 0x10a5	   0 */		.asciz	"L83"
/* 0x10a9	   0 */		.asciz	"L89"
/* 0x10ad	   0 */		.asciz	"L73"
/* 0x10b1	   0 */		.asciz	"L71"
/* 0x10b5	   0 */		.asciz	"L75"
/* 0x10b9	   0 */		.asciz	"L69"
/* 0x10bd	   0 */		.asciz	"L81"
/* 0x10c1	   0 */		.asciz	"L79"
/* 0x10c5	   0 */		.asciz	"L65"
/* 0x10c9	   0 */		.asciz	"L61"
/* 0x10cd	   0 */		.asciz	"L16"
/* 0x10d1	   0 */		.asciz	"L17"
/* 0x10d5	   0 */		.asciz	"L18"
/* 0x10d9	   0 */		.asciz	"L19"
/* 0x10dd	   0 */		.asciz	"L20"
/* 0x10e1	   0 */		.asciz	"L21"
/* 0x10e5	   0 */		.asciz	"L22"
/* 0x10e9	   0 */		.asciz	"L23"
/* 0x10ed	   0 */		.asciz	"L24"
/* 0x10f1	   0 */		.asciz	"L25"
/* 0x10f5	   0 */		.asciz	"L26"
/* 0x10f9	   0 */		.asciz	"L27"
/* 0x10fd	   0 */		.asciz	"L28"
/* 0x1101	   0 */		.asciz	"L29"
/* 0x1105	   0 */		.asciz	"L30"
/* 0x1109	   0 */		.asciz	"L115"
/* 0x110e	   0 */		.asciz	"L117"
/* 0x1113	   0 */		.asciz	"L93"
/* 0x1117	   0 */		.asciz	"L107"
/* 0x111c	   0 */		.asciz	"L97"
/* 0x1120	   0 */		.asciz	"L113"
/* 0x1125	   0 */		.asciz	"L119"
/* 0x112a	   0 */		.asciz	"L103"
/* 0x112f	   0 */		.asciz	"L101"
/* 0x1134	   0 */		.asciz	"L105"
/* 0x1139	   0 */		.asciz	"L99"
/* 0x113d	   0 */		.asciz	"L111"
/* 0x1142	   0 */		.asciz	"L109"
/* 0x1147	   0 */		.asciz	"L95"
/* 0x114b	   0 */		.asciz	"L91"
/* 0x114f	   0 */		.asciz	"gl_read_color_span"
/* 0x1162	   0 */		.asciz	"gl_problem"
/* 0x116d	   0 */		.asciz	"L31"
/* 0x1171	   0 */		.asciz	"L32"
/* 0x1175	   0 */		.asciz	"L33"
/* 0x1179	   0 */		.asciz	"L34"
/* 0x117d	   0 */		.asciz	"L35"
/* 0x1181	   0 */		.asciz	"L36"
/* 0x1185	   0 */		.asciz	"L37"
/* 0x1189	   0 */		.asciz	"L38"
/* 0x118d	   0 */		.asciz	"L39"
/* 0x1191	   0 */		.asciz	"L40"
/* 0x1195	   0 */		.asciz	"L41"
/* 0x1199	   0 */		.asciz	"L42"
/* 0x119d	   0 */		.asciz	"L43"
/* 0x11a1	   0 */		.asciz	"L44"
/* 0x11a5	   0 */		.asciz	"L45"
/* 0x11a9	   0 */		.asciz	"L145"
/* 0x11ae	   0 */		.asciz	"L147"
/* 0x11b3	   0 */		.asciz	"L123"
/* 0x11b8	   0 */		.asciz	"L137"
/* 0x11bd	   0 */		.asciz	"L127"
/* 0x11c2	   0 */		.asciz	"L143"
/* 0x11c7	   0 */		.asciz	"L149"
/* 0x11cc	   0 */		.asciz	"L133"
/* 0x11d1	   0 */		.asciz	"L131"
/* 0x11d6	   0 */		.asciz	"L135"
/* 0x11db	   0 */		.asciz	"L129"
/* 0x11e0	   0 */		.asciz	"L141"
/* 0x11e5	   0 */		.asciz	"L139"
/* 0x11ea	   0 */		.asciz	"L125"
/* 0x11ef	   0 */		.asciz	"L121"
/* 0x11f4	   0 */		.asciz	"gl_read_alpha_pixels"
/* 0x1209	   0 */		.asciz	"L46"
/* 0x120d	   0 */		.asciz	"L47"
/* 0x1211	   0 */		.asciz	"L48"
/* 0x1215	   0 */		.asciz	"L49"
/* 0x1219	   0 */		.asciz	"L50"
/* 0x121d	   0 */		.asciz	"L51"
/* 0x1221	   0 */		.asciz	"L52"
/* 0x1225	   0 */		.asciz	"L53"
/* 0x1229	   0 */		.asciz	"L54"
/* 0x122d	   0 */		.asciz	"L55"
/* 0x1231	   0 */		.asciz	"L56"
/* 0x1235	   0 */		.asciz	"L57"
/* 0x1239	   0 */		.asciz	"L58"
/* 0x123d	   0 */		.asciz	"L59"
/* 0x1241	   0 */		.asciz	"L60"
/* 0x1245	   0 */		.asciz	"L175"
/* 0x124a	   0 */		.asciz	"L177"
/* 0x124f	   0 */		.asciz	"L153"
/* 0x1254	   0 */		.asciz	"L167"
/* 0x1259	   0 */		.asciz	"L157"
/* 0x125e	   0 */		.asciz	"L173"
/* 0x1263	   0 */		.asciz	"L179"
/* 0x1268	   0 */		.asciz	"L163"
/* 0x126d	   0 */		.asciz	"L161"
/* 0x1272	   0 */		.asciz	"L165"
/* 0x1277	   0 */		.asciz	"L159"
/* 0x127c	   0 */		.asciz	"L171"
/* 0x1281	   0 */		.asciz	"L169"
/* 0x1286	   0 */		.asciz	"L155"
/* 0x128b	   0 */		.asciz	"L151"

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
!   reloc[2]: knd=0, off=270, siz=4, lab1=gl_LogicOp, lab2=, loff=0
!   reloc[3]: knd=0, off=274, siz=4, lab1=gl_LogicOp, lab2=, loff=152
!   reloc[4]: knd=0, off=38590, siz=4, lab1=gl_logicop_ci_span, lab2=, loff=0
!   reloc[5]: knd=0, off=38594, siz=4, lab1=gl_logicop_ci_span, lab2=, loff=4204
!   reloc[6]: knd=0, off=38768, siz=4, lab1=gl_logicop_ci_pixels, lab2=, loff=0
!   reloc[7]: knd=0, off=38772, siz=4, lab1=gl_logicop_ci_pixels, lab2=, loff=4208
!   reloc[8]: knd=0, off=38968, siz=4, lab1=gl_logicop_rgba_span, lab2=, loff=0
!   reloc[9]: knd=0, off=38972, siz=4, lab1=gl_logicop_rgba_span, lab2=, loff=17824
!   reloc[10]: knd=0, off=39377, siz=4, lab1=gl_logicop_rgba_pixels, lab2=, loff=0
!   reloc[11]: knd=0, off=39381, siz=4, lab1=gl_logicop_rgba_pixels, lab2=, loff=18388
	.section ".debug_info"
	.byte 0x00,0x00,0x9c,0x60,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "logic.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  logic.c -W0,-xp\\$XAa59JCfgJdL2gr.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCfgJdL2gr.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "gl_LogicOp\0"
	.byte 0x01,0x02,0x01,0x43
	.uaword gl_LogicOp
	.uaword gl_LogicOp+152
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x42
	.byte 0x03,0x00,0x00,0x96,0xa1
	.ascii "ctx\0"
	.byte 0x01,0x42,0x01,0x68,0x03,0x00,0x00,0x31
	.byte 0x4b
	.ascii "opcode\0"
	.byte 0x01,0x42,0x03,0x91,0xc8,0x00,0x04,0x44
	.byte 0x01,0x04,0x00,0x05
	.ascii "int\0"
	.byte 0x05,0x04,0x06,0x00,0x00,0x01,0x42
	.ascii "GLint\0"
	.byte 0x03,0x07
	.ascii "HashTable\0"
	.byte 0x01,0x08,0x00,0x00,0x01,0x55,0x05
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x06,0x00,0x00,0x01,0x66
	.ascii "GLuint\0"
	.byte 0x03,0x05
	.ascii "float\0"
	.byte 0x04,0x04,0x06,0x00,0x00,0x01,0x7f
	.ascii "GLfloat\0"
	.byte 0x03,0x05
	.ascii "long\0"
	.byte 0x05,0x04,0x09,0x00,0x00,0x01,0x49,0x10
	.byte 0x00,0x00,0x01,0xaf,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x0b,0x04,0x03,0x00,0x00
	.byte 0x31,0x4b,0x0c
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
	.byte 0x80,0x0c
	.byte 0x0c
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
	.byte 0xaf
	.ascii "GLenum\0"
	.byte 0x03,0x05
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x06,0x00,0x00,0x31,0x58
	.ascii "GLubyte\0"
	.byte 0x03,0x08,0x00,0x00,0x31,0x69,0x05
	.ascii "void\0"
	.byte 0x05,0x00,0x08,0x00,0x00,0x31,0x7c,0x0d
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x02,0x00,0x00,0x32,0x92,0x0e
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "Border\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x08,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x0c,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x10,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x14,0x0e
	.ascii "Width2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x18,0x0e
	.ascii "Height2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x1c,0x0e
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x20,0x0e
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x24,0x0e
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x28,0x0e
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x2c,0x0e
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x30,0x0e
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0x77,0x02,0x23,0x34,0x0e
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x38,0x00
	.byte 0x08,0x00,0x00,0x31,0x89,0x09,0x00,0x00
	.byte 0x32,0x92,0x2c,0x00,0x00,0x32,0xa8,0x0a
	.byte 0x00,0x00,0x01,0x96,0x0a,0x00,0x0f,0x00
	.byte 0x00,0x31,0x69,0x04,0x00,0x00,0x00,0x32
	.byte 0xbb,0x10,0x00,0x00,0x01,0x96,0x03,0xff
	.byte 0x00,0x06,0x00,0x00,0x31,0x58
	.ascii "GLboolean\0"
	.byte 0x03,0x11
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x02,0x00,0x00,0x34,0x5a,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "Name\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x04,0x0e
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x08,0x0e
	.ascii "Priority\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x0c,0x0e
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x01,0x9e,0x02,0x23,0x10,0x0e
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x20,0x0e
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x24,0x0e
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x28,0x0e
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x2c,0x0e
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x30,0x0e
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x34,0x0e
	.ascii "Image\0"
	.byte 0x00,0x00,0x32,0x97,0x02,0x23,0x38,0x0e
	.ascii "Palette\0"
	.byte 0x00,0x00,0x32,0xa8,0x02,0x23,0x64,0x0e
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xe4,0x08
	.byte 0x0e
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x4b,0x03,0x23,0xe8,0x08
	.byte 0x0e
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x4b,0x03,0x23,0xec,0x08
	.byte 0x0e
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xf0,0x08
	.byte 0x0e
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x31,0x84,0x03,0x23,0xf4,0x08
	.byte 0x0e
	.ascii "Complete\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xf8,0x08
	.byte 0x0e
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x34,0xd0,0x03,0x23,0xfc,0x08
	.byte 0x0e
	.ascii "Next\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0x80,0x09
	.byte 0x00,0x12,0x00,0x00,0x32,0xcb,0x08,0x00
	.byte 0x00,0x34,0x5a,0x12,0x00,0x00,0x01,0x7f
	.byte 0x08,0x00,0x00,0x34,0x64,0x12,0x00,0x00
	.byte 0x01,0x7f,0x08,0x00,0x00,0x34,0x6e,0x12
	.byte 0x00,0x00,0x01,0x7f,0x08,0x00,0x00,0x34
	.byte 0x78,0x12,0x00,0x00,0x01,0x7f,0x08,0x00
	.byte 0x00,0x34,0x82,0x08,0x00,0x00,0x31,0x58
	.byte 0x13,0x01,0x01,0x00,0x00,0x34,0xcb,0x14
	.byte 0x00,0x00,0x34,0x5f,0x14,0x00,0x00,0x01
	.byte 0x66,0x14,0x00,0x00,0x34,0x69,0x14,0x00
	.byte 0x00,0x34,0x73,0x14,0x00,0x00,0x34,0x7d
	.byte 0x14,0x00,0x00,0x34,0x87,0x14,0x00,0x00
	.byte 0x34,0x8c,0x14,0x00,0x00,0x34,0x8c,0x14
	.byte 0x00,0x00,0x34,0x8c,0x14,0x00,0x00,0x34
	.byte 0x8c,0x00,0x08,0x00,0x00,0x34,0x91,0x06
	.byte 0x00,0x00,0x34,0xcb
	.ascii "TextureSampleFunc\0"
	.byte 0x02,0x08,0x00,0x00,0x32,0xcb,0x0d
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x02,0x00,0x00,0x35,0x89,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x01,0x61,0x02,0x23,0x04,0x0e
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x01,0x61,0x02,0x23,0x08,0x0e
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x34,0xe8,0x02,0x23,0x0c,0x0e
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x34,0xe8,0x02,0x23,0x10,0x0e
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x34,0xe8,0x02,0x23,0x14,0x0e
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x34,0xe8,0x02,0x23,0x18,0x00
	.byte 0x08,0x00,0x00,0x34,0xed,0x11
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x02,0x00,0x00,0x3c,0x5b,0x0e
	.ascii "Shared\0"
	.byte 0x00,0x00,0x35,0x89,0x02,0x23,0x00,0x0e
	.ascii "API\0"
	.byte 0x00,0x00,0x55,0x46,0x02,0x23,0x04,0x0e
	.ascii "Save\0"
	.byte 0x00,0x00,0x55,0x46,0x03,0x23,0xe0,0x05
	.byte 0x0e
	.ascii "Exec\0"
	.byte 0x00,0x00,0x55,0x46,0x03,0x23,0xbc,0x0b
	.byte 0x0e
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xa1,0x03,0x23,0x98,0x11
	.byte 0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x66,0xd5,0x03,0x23,0x9c,0x11
	.byte 0x0e
	.ascii "Driver\0"
	.byte 0x00,0x00,0x6f,0xe4,0x03,0x23,0xa0,0x11
	.byte 0x0e
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x31,0x84,0x03,0x23,0xf4,0x12
	.byte 0x0e
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x31,0x84,0x03,0x23,0xf8,0x12
	.byte 0x0e
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xfc,0x12
	.byte 0x0e
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0x80,0x13
	.byte 0x0e
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x74,0x4c,0x03,0x23,0x84,0x13
	.byte 0x0e
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x74,0x5d,0x03,0x23,0xc4,0x13
	.byte 0x0e
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0x84,0x14
	.byte 0x0e
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x74,0x7f,0x03,0x23,0x88,0x14
	.byte 0x0e
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0x88,0x24
	.byte 0x0e
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0x8c,0x24
	.byte 0x0e
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x74,0x91,0x03,0x23,0x90,0x24
	.byte 0x0e
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xd0,0x24
	.byte 0x0e
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x74,0xb3,0x03,0x23,0xd4,0x24
	.byte 0x0e
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x74,0xd6,0x03,0x23,0xd4,0x34
	.byte 0x0e
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xd4,0x36
	.byte 0x0e
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xd8,0x36
	.byte 0x0e
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x74,0xe8,0x03,0x23,0xdc,0x36
	.byte 0x0e
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0x9c,0x37
	.byte 0x0e
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x75,0x0a,0x03,0x23,0xa0,0x37
	.byte 0x0e
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xa0,0x3c
	.byte 0x0e
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xa4,0x3c
	.byte 0x0e
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xa5,0x3c
	.byte 0x0e
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xa8,0x3c
	.byte 0x0e
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x75,0x70,0x03,0x23,0xac,0x3c
	.byte 0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x75,0x92,0x03,0x23,0xec,0x3c
	.byte 0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x75,0xdf,0x03,0x23,0xfc,0x3c
	.byte 0x0e
	.ascii "Current\0"
	.byte 0x00,0x00,0x77,0xf4,0x03,0x23,0xd4,0x3d
	.byte 0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x78,0xde,0x03,0x23,0xb4,0x3e
	.byte 0x0e
	.ascii "Eval\0"
	.byte 0x00,0x00,0x79,0x31,0x03,0x23,0xc0,0x3e
	.byte 0x0e
	.ascii "Fog\0"
	.byte 0x00,0x00,0x7b,0xa7,0x03,0x23,0xf8,0x3e
	.byte 0x0e
	.ascii "Hint\0"
	.byte 0x00,0x00,0x7c,0x20,0x03,0x23,0xa0,0x3f
	.byte 0x0e
	.ascii "Light\0"
	.byte 0x00,0x00,0x81,0x2b,0x03,0x23,0xb4,0x3f
	.byte 0x0e
	.ascii "Line\0"
	.byte 0x00,0x00,0x82,0x5b,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0e
	.ascii "List\0"
	.byte 0x00,0x00,0x82,0xd4,0x04,0x23,0x94,0xdc
	.byte 0x02,0x0e
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x83,0xba,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0e
	.ascii "Point\0"
	.byte 0x00,0x00,0x86,0x8a,0x04,0x23,0x80,0xad
	.byte 0x03,0x0e
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x87,0x03,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0e
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x88,0x36,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0e
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x88,0x55,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0e
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x88,0xb0,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0e
	.ascii "Texture\0"
	.byte 0x00,0x00,0x8a,0x0a,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0e
	.ascii "Transform\0"
	.byte 0x00,0x00,0x8c,0x6c,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0e
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x8c,0xe6,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0e
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0e
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x8d,0x8d,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0e
	.ascii "Array\0"
	.byte 0x00,0x00,0x8d,0xa3,0x04,0x23,0xac,0xba
	.byte 0x03,0x0e
	.ascii "Pack\0"
	.byte 0x00,0x00,0x90,0x4e,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0e
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x90,0x4e,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0e
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x91,0xd0,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0e
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x93,0x5a,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0e
	.ascii "Select\0"
	.byte 0x00,0x00,0x93,0xcf,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0e
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0e
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0e
	.ascii "NewState\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0e
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0e
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0e
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0e
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0e
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0e
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0e
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0e
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x01,0x88,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0e
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x01,0x88,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0e
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x01,0x88,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0e
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0e
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0e
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0e
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0e
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x1f,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0e
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x52,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0e
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x88,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0e
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xc7,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0e
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xfd,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0e
	.ascii "VB\0"
	.byte 0x00,0x00,0x94,0x94,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0e
	.ascii "PB\0"
	.byte 0x00,0x00,0x96,0x8c,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0e
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0e
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x08,0x00,0x00,0x35,0x8e,0x13
	.byte 0x01,0x01,0x00,0x00,0x3c,0x77,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0x7f,0x00,0x08,0x00
	.byte 0x00,0x3c,0x60,0x13,0x01,0x01,0x00,0x00
	.byte 0x3c,0x93,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0x7f,0x00,0x08,0x00,0x00,0x3c,0x7c,0x12
	.byte 0x00,0x00,0x01,0x66,0x08,0x00,0x00,0x3c
	.byte 0x98,0x15,0x01,0x00,0x00,0x31,0x58,0x01
	.byte 0x00,0x00,0x3c,0xc2,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x3c,0x9d,0x14,0x00,0x00,0x34,0x8c
	.byte 0x00,0x08,0x00,0x00,0x3c,0xa2,0x13,0x01
	.byte 0x01,0x00,0x00,0x3c,0xd9,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x42,0x00
	.byte 0x08,0x00,0x00,0x3c,0xc7,0x13,0x01,0x01
	.byte 0x00,0x00,0x3c,0xf0,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x00,0x08
	.byte 0x00,0x00,0x3c,0xde,0x13,0x01,0x01,0x00
	.byte 0x00,0x3d,0x0c,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0x66,0x00,0x08,0x00,0x00,0x3c,0xf5
	.byte 0x06,0x00,0x00,0x31,0x7c
	.ascii "GLvoid\0"
	.byte 0x03,0x08,0x00,0x00,0x3d,0x11,0x0d
	.ascii "gl_image\0"
	.byte 0x24,0x02,0x00,0x00,0x3d,0xc0,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x08,0x0e
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x0c,0x0e
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x10,0x0e
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x14,0x0e
	.ascii "Data\0"
	.byte 0x00,0x00,0x3d,0x1e,0x02,0x23,0x18,0x0e
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x1c,0x0e
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x20,0x00
	.byte 0x12,0x00,0x00,0x3d,0x23,0x08,0x00,0x00
	.byte 0x3d,0xc0,0x13,0x01,0x01,0x00,0x00,0x3d
	.byte 0xfa,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x3d
	.byte 0xc5,0x00,0x08,0x00,0x00,0x3d,0xca,0x13
	.byte 0x01,0x01,0x00,0x00,0x3e,0x20,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x00
	.byte 0x08,0x00,0x00,0x3d,0xff,0x13,0x01,0x01
	.byte 0x00,0x00,0x3e,0x37,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x00,0x08
	.byte 0x00,0x00,0x3e,0x25,0x13,0x01,0x01,0x00
	.byte 0x00,0x3e,0x53,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x00,0x08,0x00,0x00,0x3e,0x3c
	.byte 0x13,0x01,0x01,0x00,0x00,0x3e,0x6a,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x00,0x08,0x00,0x00,0x3e,0x58,0x12
	.byte 0x00,0x00,0x31,0x7c,0x08,0x00,0x00,0x3e
	.byte 0x6f,0x13,0x01,0x01,0x00,0x00,0x3e,0x95
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x3e,0x74,0x00,0x08,0x00,0x00
	.byte 0x3e,0x79,0x13,0x01,0x01,0x00,0x00,0x3e
	.byte 0xac,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x00,0x08,0x00,0x00,0x3e
	.byte 0x9a,0x13,0x01,0x01,0x00,0x00,0x3e,0xd2
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x00,0x08,0x00,0x00,0x3e,0xb1,0x13
	.byte 0x01,0x01,0x00,0x00,0x3e,0xf8,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x00
	.byte 0x08,0x00,0x00,0x3e,0xd7,0x05
	.ascii "double\0"
	.byte 0x04,0x08,0x13,0x01,0x01,0x00,0x00,0x3f
	.byte 0x19,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x3e,0xfd,0x00,0x08,0x00,0x00,0x3f
	.byte 0x07,0x13,0x01,0x01,0x00,0x00,0x3f,0x30
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x00,0x08,0x00,0x00,0x3f,0x1e
	.byte 0x13,0x01,0x01,0x00,0x00,0x3f,0x47,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x00,0x08,0x00,0x00,0x3f,0x35,0x12
	.byte 0x00,0x00,0x01,0x7f,0x08,0x00,0x00,0x3f
	.byte 0x4c,0x13,0x01,0x01,0x00,0x00,0x3f,0x6d
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x3f,0x51,0x00
	.byte 0x08,0x00,0x00,0x3f,0x56,0x13,0x01,0x01
	.byte 0x00,0x00,0x3f,0x8e,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x00,0x08,0x00,0x00,0x3f,0x72,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08
	.byte 0x00,0x00,0x3f,0x93,0x13,0x01,0x01,0x00
	.byte 0x00,0x3f,0xaf,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x3f,0x98,0x00,0x08,0x00
	.byte 0x00,0x3f,0x9d,0x13,0x01,0x01,0x00,0x00
	.byte 0x3f,0xd5,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x00,0x08,0x00,0x00,0x3f
	.byte 0xb4,0x12,0x00,0x00,0x01,0x7f,0x08,0x00
	.byte 0x00,0x3f,0xda,0x13,0x01,0x01,0x00,0x00
	.byte 0x3f,0xf6,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x3f,0xdf,0x00,0x08,0x00,0x00
	.byte 0x3f,0xe4,0x13,0x01,0x01,0x00,0x00,0x40
	.byte 0x1c,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x31,0x58,0x14,0x00,0x00,0x31,0x58
	.byte 0x14,0x00,0x00,0x31,0x58,0x14,0x00,0x00
	.byte 0x31,0x58,0x00,0x08,0x00,0x00,0x3f,0xfb
	.byte 0x12,0x00,0x00,0x31,0x58,0x08,0x00,0x00
	.byte 0x40,0x21,0x13,0x01,0x01,0x00,0x00,0x40
	.byte 0x3d,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x40,0x26,0x00,0x08,0x00,0x00,0x40
	.byte 0x2b,0x13,0x01,0x01,0x00,0x00,0x40,0x63
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x31,0x58,0x14,0x00,0x00,0x31,0x58,0x14
	.byte 0x00,0x00,0x31,0x58,0x14,0x00,0x00,0x31
	.byte 0x58,0x00,0x08,0x00,0x00,0x40,0x42,0x13
	.byte 0x01,0x01,0x00,0x00,0x40,0x7f,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x40,0x68,0x12,0x00,0x00,0x31,0x7c
	.byte 0x08,0x00,0x00,0x40,0x84,0x13,0x01,0x01
	.byte 0x00,0x00,0x40,0xaf,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x40,0x89,0x00,0x08,0x00
	.byte 0x00,0x40,0x8e,0x08,0x00,0x00,0x3d,0x23
	.byte 0x13,0x01,0x01,0x00,0x00,0x40,0xd5,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x40,0xb4,0x00,0x08,0x00,0x00,0x40
	.byte 0xb9,0x13,0x01,0x01,0x00,0x00,0x40,0xf6
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x40,0xb4,0x00,0x08,0x00,0x00
	.byte 0x40,0xda,0x13,0x01,0x01,0x00,0x00,0x41
	.byte 0x21,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0xaf,0x00
	.byte 0x08,0x00,0x00,0x40,0xfb,0x13,0x01,0x01
	.byte 0x00,0x00,0x41,0x56,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x00,0x08,0x00,0x00
	.byte 0x41,0x26,0x13,0x01,0x01,0x00,0x00,0x41
	.byte 0x90,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x00,0x08
	.byte 0x00,0x00,0x41,0x5b,0x13,0x01,0x01,0x00
	.byte 0x00,0x41,0xc0,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x00,0x08
	.byte 0x00,0x00,0x41,0x95,0x13,0x01,0x01,0x00
	.byte 0x00,0x41,0xfa,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x00,0x08,0x00,0x00,0x41,0xc5,0x13,0x01
	.byte 0x01,0x00,0x00,0x42,0x39,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x00
	.byte 0x08,0x00,0x00,0x41,0xff,0x13,0x01,0x01
	.byte 0x00,0x00,0x42,0x50,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x00,0x08
	.byte 0x00,0x00,0x42,0x3e,0x13,0x01,0x01,0x00
	.byte 0x00,0x42,0x6c,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x66,0x14,0x00,0x00
	.byte 0x01,0x42,0x00,0x08,0x00,0x00,0x42,0x55
	.byte 0x12,0x00,0x00,0x01,0x66,0x08,0x00,0x00
	.byte 0x42,0x71,0x13,0x01,0x01,0x00,0x00,0x42
	.byte 0x92,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x42,0x76
	.byte 0x00,0x08,0x00,0x00,0x42,0x7b,0x13,0x01
	.byte 0x01,0x00,0x00,0x42,0xa9,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x00
	.byte 0x08,0x00,0x00,0x42,0x97,0x13,0x01,0x01
	.byte 0x00,0x00,0x42,0xc0,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x31,0x58,0x00,0x08
	.byte 0x00,0x00,0x42,0xae,0x13,0x01,0x01,0x00
	.byte 0x00,0x42,0xdc,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x3e,0xfd,0x14,0x00,0x00
	.byte 0x3e,0xfd,0x00,0x08,0x00,0x00,0x42,0xc5
	.byte 0x13,0x01,0x01,0x00,0x00,0x42,0xf3,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x00,0x08,0x00,0x00,0x42,0xe1,0x13
	.byte 0x01,0x01,0x00,0x00,0x43,0x0a,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x00,0x08,0x00,0x00,0x42,0xf8,0x13,0x01
	.byte 0x01,0x00,0x00,0x43,0x2b,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x00,0x08,0x00,0x00,0x43,0x0f,0x13
	.byte 0x01,0x01,0x00,0x00,0x43,0x42,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x00,0x08,0x00,0x00,0x43,0x30,0x12,0x00
	.byte 0x00,0x31,0x7c,0x08,0x00,0x00,0x43,0x47
	.byte 0x13,0x01,0x01,0x00,0x00,0x43,0x72,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x43,0x4c
	.byte 0x00,0x08,0x00,0x00,0x43,0x51,0x12,0x00
	.byte 0x00,0x31,0x7c,0x08,0x00,0x00,0x43,0x77
	.byte 0x13,0x01,0x01,0x00,0x00,0x43,0xa7,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x43,0x7c,0x00,0x08,0x00
	.byte 0x00,0x43,0x81,0x13,0x01,0x01,0x00,0x00
	.byte 0x43,0xbe,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x31,0x58,0x00,0x08,0x00,0x00
	.byte 0x43,0xac,0x12,0x00,0x00,0x31,0x58,0x08
	.byte 0x00,0x00,0x43,0xc3,0x13,0x01,0x01,0x00
	.byte 0x00,0x43,0xe4,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x43,0xc8,0x00,0x08,0x00,0x00,0x43,0xcd
	.byte 0x13,0x01,0x01,0x00,0x00,0x43,0xfb,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x00,0x08,0x00,0x00,0x43,0xe9,0x13
	.byte 0x01,0x01,0x00,0x00,0x44,0x12,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x00,0x08,0x00,0x00,0x44,0x00,0x13,0x01
	.byte 0x01,0x00,0x00,0x44,0x24,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x00,0x08,0x00,0x00,0x44,0x17
	.byte 0x13,0x01,0x01,0x00,0x00,0x44,0x36,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x00,0x08,0x00,0x00
	.byte 0x44,0x29,0x13,0x01,0x01,0x00,0x00,0x44
	.byte 0x4d,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x7f,0x00,0x08,0x00,0x00,0x44
	.byte 0x3b,0x13,0x01,0x01,0x00,0x00,0x44,0x69
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x00
	.byte 0x08,0x00,0x00,0x44,0x52,0x13,0x01,0x01
	.byte 0x00,0x00,0x44,0x8a,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x00,0x08,0x00,0x00,0x44,0x6e,0x13,0x01
	.byte 0x01,0x00,0x00,0x44,0xb5,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x00,0x08,0x00,0x00,0x44
	.byte 0x8f,0x13,0x01,0x01,0x00,0x00,0x44,0xcc
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x42,0x00,0x08,0x00,0x00,0x44,0xba
	.byte 0x13,0x01,0x01,0x00,0x00,0x44,0xe8,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x00,0x08
	.byte 0x00,0x00,0x44,0xd1,0x08,0x00,0x00,0x01
	.byte 0x7f,0x13,0x01,0x01,0x00,0x00,0x45,0x0e
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x44,0xed,0x00,0x08,0x00,0x00
	.byte 0x44,0xf2,0x13,0x01,0x01,0x00,0x00,0x45
	.byte 0x20,0x14,0x00,0x00,0x3c,0x5b,0x00,0x08
	.byte 0x00,0x00,0x45,0x13,0x13,0x01,0x01,0x00
	.byte 0x00,0x45,0x32,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x00,0x08,0x00,0x00,0x45,0x25,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x45,0x37
	.byte 0x13,0x01,0x01,0x00,0x00,0x45,0x58,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x45,0x3c,0x00,0x08
	.byte 0x00,0x00,0x45,0x41,0x13,0x01,0x01,0x00
	.byte 0x00,0x45,0x6f,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x45,0x5d,0x13,0x01,0x01,0x00,0x00
	.byte 0x45,0x9f,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x3e,0xfd,0x14,0x00,0x00,0x3e
	.byte 0xfd,0x14,0x00,0x00,0x3e,0xfd,0x14,0x00
	.byte 0x00,0x3e,0xfd,0x14,0x00,0x00,0x3e,0xfd
	.byte 0x14,0x00,0x00,0x3e,0xfd,0x00,0x08,0x00
	.byte 0x00,0x45,0x74,0x15,0x01,0x00,0x00,0x01
	.byte 0x66,0x01,0x00,0x00,0x45,0xba,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x42
	.byte 0x00,0x08,0x00,0x00,0x45,0xa4,0x08,0x00
	.byte 0x00,0x01,0x66,0x13,0x01,0x01,0x00,0x00
	.byte 0x45,0xdb,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x45
	.byte 0xbf,0x00,0x08,0x00,0x00,0x45,0xc4,0x13
	.byte 0x01,0x01,0x00,0x00,0x45,0xf7,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x34,0x8c,0x00,0x08,0x00
	.byte 0x00,0x45,0xe0,0x08,0x00,0x00,0x3e,0xfd
	.byte 0x13,0x01,0x01,0x00,0x00,0x46,0x18,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x45,0xfc,0x00,0x08
	.byte 0x00,0x00,0x46,0x01,0x13,0x01,0x01,0x00
	.byte 0x00,0x46,0x3e,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x31,0x84,0x00,0x08,0x00,0x00
	.byte 0x46,0x1d,0x08,0x00,0x00,0x01,0x42,0x13
	.byte 0x01,0x01,0x00,0x00,0x46,0x64,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x46,0x43,0x00,0x08,0x00,0x00,0x46,0x48
	.byte 0x13,0x01,0x01,0x00,0x00,0x46,0x80,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x45,0xfc,0x00,0x08
	.byte 0x00,0x00,0x46,0x69,0x15,0x01,0x00,0x00
	.byte 0x01,0xaf,0x01,0x00,0x00,0x46,0x96,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x00,0x08,0x00,0x00
	.byte 0x46,0x85,0x13,0x01,0x01,0x00,0x00,0x46
	.byte 0xb2,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x44,0xed
	.byte 0x00,0x08,0x00,0x00,0x46,0x9b,0x13,0x01
	.byte 0x01,0x00,0x00,0x46,0xce,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x46,0x43,0x00,0x08,0x00,0x00
	.byte 0x46,0xb7,0x12,0x00,0x00,0x31,0x58,0x08
	.byte 0x00,0x00,0x46,0xd3,0x15,0x01,0x00,0x00
	.byte 0x46,0xd8,0x01,0x00,0x00,0x46,0xf3,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x00,0x08,0x00,0x00,0x46,0xdd,0x13
	.byte 0x01,0x01,0x00,0x00,0x47,0x14,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x44,0xed,0x00,0x08,0x00,0x00,0x46,0xf8
	.byte 0x13,0x01,0x01,0x00,0x00,0x47,0x35,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x46,0x43,0x00,0x08,0x00,0x00,0x47
	.byte 0x19,0x13,0x01,0x01,0x00,0x00,0x47,0x56
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x45,0xfc,0x00,0x08,0x00,0x00
	.byte 0x47,0x3a,0x13,0x01,0x01,0x00,0x00,0x47
	.byte 0x77,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x44,0xed,0x00,0x08,0x00
	.byte 0x00,0x47,0x5b,0x13,0x01,0x01,0x00,0x00
	.byte 0x47,0x98,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x46,0x43,0x00,0x08
	.byte 0x00,0x00,0x47,0x7c,0x13,0x01,0x01,0x00
	.byte 0x00,0x47,0xb9,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x44,0xed,0x00
	.byte 0x08,0x00,0x00,0x47,0x9d,0x13,0x01,0x01
	.byte 0x00,0x00,0x47,0xda,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x46,0x43
	.byte 0x00,0x08,0x00,0x00,0x47,0xbe,0x13,0x01
	.byte 0x01,0x00,0x00,0x47,0xf6,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x44,0xed,0x00,0x08,0x00,0x00
	.byte 0x47,0xdf,0x13,0x01,0x01,0x00,0x00,0x48
	.byte 0x12,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x45,0xbf
	.byte 0x00,0x08,0x00,0x00,0x47,0xfb,0x05
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x08,0x00,0x00,0x48,0x17,0x13
	.byte 0x01,0x01,0x00,0x00,0x48,0x45,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x48,0x29,0x00,0x08,0x00
	.byte 0x00,0x48,0x2e,0x08,0x00,0x00,0x31,0x84
	.byte 0x13,0x01,0x01,0x00,0x00,0x48,0x66,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x48,0x4a,0x00,0x08
	.byte 0x00,0x00,0x48,0x4f,0x13,0x01,0x01,0x00
	.byte 0x00,0x48,0x7d,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x34,0x8c,0x00,0x08,0x00
	.byte 0x00,0x48,0x6b,0x12,0x00,0x00,0x01,0x66
	.byte 0x08,0x00,0x00,0x48,0x82,0x12,0x00,0x00
	.byte 0x01,0x7f,0x08,0x00,0x00,0x48,0x8c,0x13
	.byte 0x01,0x01,0x00,0x00,0x48,0xb2,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x48,0x87,0x14,0x00,0x00
	.byte 0x48,0x91,0x00,0x08,0x00,0x00,0x48,0x96
	.byte 0x13,0x01,0x01,0x00,0x00,0x48,0xd3,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x44,0xed,0x00,0x08,0x00,0x00,0x48
	.byte 0xb7,0x13,0x01,0x01,0x00,0x00,0x48,0xf4
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x46,0x43,0x00,0x08,0x00,0x00
	.byte 0x48,0xd8,0x13,0x01,0x01,0x00,0x00,0x49
	.byte 0x15,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x45,0xfc,0x00,0x08,0x00
	.byte 0x00,0x48,0xf9,0x13,0x01,0x01,0x00,0x00
	.byte 0x49,0x36,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x44,0xed,0x00,0x08
	.byte 0x00,0x00,0x49,0x1a,0x13,0x01,0x01,0x00
	.byte 0x00,0x49,0x57,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x46,0x43,0x00
	.byte 0x08,0x00,0x00,0x49,0x3b,0x13,0x01,0x01
	.byte 0x00,0x00,0x49,0x82,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x31,0x84,0x00,0x08,0x00,0x00,0x49,0x5c
	.byte 0x13,0x01,0x01,0x00,0x00,0x49,0xa8,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x44,0xed
	.byte 0x00,0x08,0x00,0x00,0x49,0x87,0x13,0x01
	.byte 0x01,0x00,0x00,0x49,0xce,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x46,0x43,0x00,0x08
	.byte 0x00,0x00,0x49,0xad,0x13,0x01,0x01,0x00
	.byte 0x00,0x49,0xef,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x44,0xed,0x00
	.byte 0x08,0x00,0x00,0x49,0xd3,0x13,0x01,0x01
	.byte 0x00,0x00,0x4a,0x10,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x46,0x43
	.byte 0x00,0x08,0x00,0x00,0x49,0xf4,0x13,0x01
	.byte 0x01,0x00,0x00,0x4a,0x2c,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0xaf,0x00,0x08,0x00,0x00
	.byte 0x4a,0x15,0x13,0x01,0x01,0x00,0x00,0x4a
	.byte 0x43,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x00,0x08,0x00,0x00,0x4a
	.byte 0x31,0x13,0x01,0x01,0x00,0x00,0x4a,0x5a
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x00,0x08,0x00,0x00,0x4a,0x48
	.byte 0x13,0x01,0x01,0x00,0x00,0x4a,0x71,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x00,0x08,0x00,0x00,0x4a,0x5f,0x12
	.byte 0x00,0x00,0x31,0x7c,0x08,0x00,0x00,0x4a
	.byte 0x76,0x13,0x01,0x01,0x00,0x00,0x4a,0x9c
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x4a,0x7b,0x00,0x08,0x00,0x00
	.byte 0x4a,0x80,0x13,0x01,0x01,0x00,0x00,0x4a
	.byte 0xae,0x14,0x00,0x00,0x3c,0x5b,0x00,0x08
	.byte 0x00,0x00,0x4a,0xa1,0x12,0x00,0x00,0x31
	.byte 0x7c,0x08,0x00,0x00,0x4a,0xb3,0x13,0x01
	.byte 0x01,0x00,0x00,0x4a,0xd9,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x4a
	.byte 0xb8,0x00,0x08,0x00,0x00,0x4a,0xbd,0x15
	.byte 0x01,0x00,0x00,0x31,0x58,0x01,0x00,0x00
	.byte 0x4a,0xf4,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x00,0x08,0x00,0x00
	.byte 0x4a,0xde,0x15,0x01,0x00,0x00,0x31,0x58
	.byte 0x01,0x00,0x00,0x4b,0x0f,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x66,0x00
	.byte 0x08,0x00,0x00,0x4a,0xf9,0x15,0x01,0x00
	.byte 0x00,0x31,0x58,0x01,0x00,0x00,0x4b,0x2a
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x00,0x08,0x00,0x00,0x4b,0x14
	.byte 0x12,0x00,0x00,0x01,0x7f,0x08,0x00,0x00
	.byte 0x4b,0x2f,0x13,0x01,0x01,0x00,0x00,0x4b
	.byte 0x50,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x4b,0x34
	.byte 0x00,0x08,0x00,0x00,0x4b,0x39,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x4b,0x55
	.byte 0x13,0x01,0x01,0x00,0x00,0x4b,0x80,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x4b,0x5a,0x14,0x00,0x00,0x01,0x42
	.byte 0x00,0x08,0x00,0x00,0x4b,0x5f,0x13,0x01
	.byte 0x01,0x00,0x00,0x4b,0x9c,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x48,0x17,0x00,0x08,0x00,0x00
	.byte 0x4b,0x85,0x13,0x01,0x01,0x00,0x00,0x4b
	.byte 0xb3,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x7f,0x00,0x08,0x00,0x00,0x4b
	.byte 0xa1,0x13,0x01,0x01,0x00,0x00,0x4b,0xca
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x00,0x08,0x00,0x00,0x4b,0xb8
	.byte 0x13,0x01,0x01,0x00,0x00,0x4b,0xdc,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x00,0x08,0x00,0x00
	.byte 0x4b,0xcf,0x12,0x00,0x00,0x01,0x7f,0x08
	.byte 0x00,0x00,0x4b,0xe1,0x13,0x01,0x01,0x00
	.byte 0x00,0x4b,0xfd,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x4b,0xe6,0x00,0x08,0x00
	.byte 0x00,0x4b,0xeb,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0x14,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x66,0x00,0x08,0x00,0x00
	.byte 0x4c,0x02,0x13,0x01,0x01,0x00,0x00,0x4c
	.byte 0x2b,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x00,0x08,0x00,0x00,0x4c
	.byte 0x19,0x12,0x00,0x00,0x01,0x7f,0x08,0x00
	.byte 0x00,0x4c,0x30,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0x6a,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x4c,0x35,0x14,0x00,0x00
	.byte 0x31,0x58,0x00,0x08,0x00,0x00,0x4c,0x3a
	.byte 0x12,0x00,0x00,0x01,0x7f,0x08,0x00,0x00
	.byte 0x4c,0x6f,0x13,0x01,0x01,0x00,0x00,0x4c
	.byte 0xbd,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x4c,0x74
	.byte 0x14,0x00,0x00,0x31,0x58,0x00,0x08,0x00
	.byte 0x00,0x4c,0x79,0x13,0x01,0x01,0x00,0x00
	.byte 0x4c,0xde,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x00,0x08
	.byte 0x00,0x00,0x4c,0xc2,0x13,0x01,0x01,0x00
	.byte 0x00,0x4d,0x0e,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x00,0x08
	.byte 0x00,0x00,0x4c,0xe3,0x12,0x00,0x00,0x01
	.byte 0x7f,0x08,0x00,0x00,0x4d,0x13,0x13,0x01
	.byte 0x01,0x00,0x00,0x4d,0x39,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x4d
	.byte 0x18,0x00,0x08,0x00,0x00,0x4d,0x1d,0x13
	.byte 0x01,0x01,0x00,0x00,0x4d,0x50,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x00,0x08,0x00,0x00,0x4d,0x3e,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x4d,0x55
	.byte 0x13,0x01,0x01,0x00,0x00,0x4d,0x71,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x4d
	.byte 0x5a,0x00,0x08,0x00,0x00,0x4d,0x5f,0x13
	.byte 0x01,0x01,0x00,0x00,0x4d,0x8d,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x66
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x4d,0x76,0x13,0x01,0x01,0x00,0x00
	.byte 0x4d,0xae,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x00,0x08
	.byte 0x00,0x00,0x4d,0x92,0x12,0x00,0x00,0x01
	.byte 0x7f,0x08,0x00,0x00,0x4d,0xb3,0x13,0x01
	.byte 0x01,0x00,0x00,0x4d,0xcf,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x4d,0xb8,0x00
	.byte 0x08,0x00,0x00,0x4d,0xbd,0x12,0x00,0x00
	.byte 0x31,0x7c,0x08,0x00,0x00,0x4d,0xd4,0x13
	.byte 0x01,0x01,0x00,0x00,0x4d,0xfa,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x4d,0xd9,0x00,0x08,0x00,0x00,0x4d,0xde
	.byte 0x13,0x01,0x01,0x00,0x00,0x4e,0x2a,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x3e
	.byte 0xfd,0x14,0x00,0x00,0x3e,0xfd,0x14,0x00
	.byte 0x00,0x3e,0xfd,0x14,0x00,0x00,0x3e,0xfd
	.byte 0x14,0x00,0x00,0x3e,0xfd,0x14,0x00,0x00
	.byte 0x3e,0xfd,0x00,0x08,0x00,0x00,0x4d,0xff
	.byte 0x13,0x01,0x01,0x00,0x00,0x4e,0x41,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x7f,0x00,0x08,0x00,0x00,0x4e,0x2f,0x12
	.byte 0x00,0x00,0x01,0x7f,0x08,0x00,0x00,0x4e
	.byte 0x46,0x13,0x01,0x01,0x00,0x00,0x4e,0x6c
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x4e,0x4b,0x00,0x08,0x00,0x00
	.byte 0x4e,0x50,0x13,0x01,0x01,0x00,0x00,0x4e
	.byte 0x88,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0x42
	.byte 0x00,0x08,0x00,0x00,0x4e,0x71,0x13,0x01
	.byte 0x01,0x00,0x00,0x4e,0xa4,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x7f,0x00,0x08,0x00,0x00
	.byte 0x4e,0x8d,0x13,0x01,0x01,0x00,0x00,0x4e
	.byte 0xc0,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x00,0x08,0x00,0x00,0x4e,0xa9,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x4e,0xc5
	.byte 0x13,0x01,0x01,0x00,0x00,0x4e,0xe6,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x4e,0xca,0x00,0x08
	.byte 0x00,0x00,0x4e,0xcf,0x13,0x01,0x01,0x00
	.byte 0x00,0x4e,0xfd,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x7f,0x00,0x08,0x00
	.byte 0x00,0x4e,0xeb,0x13,0x01,0x01,0x00,0x00
	.byte 0x4f,0x19,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x00,0x08,0x00,0x00,0x4f,0x02,0x13
	.byte 0x01,0x01,0x00,0x00,0x4f,0x35,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x00,0x08,0x00
	.byte 0x00,0x4f,0x1e,0x12,0x00,0x00,0x31,0x58
	.byte 0x08,0x00,0x00,0x4f,0x3a,0x13,0x01,0x01
	.byte 0x00,0x00,0x4f,0x56,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x4f,0x3f,0x00,0x08
	.byte 0x00,0x00,0x4f,0x44,0x13,0x01,0x01,0x00
	.byte 0x00,0x4f,0x68,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x00,0x08,0x00,0x00,0x4f,0x5b,0x13,0x01
	.byte 0x01,0x00,0x00,0x4f,0x7a,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x00,0x08,0x00,0x00,0x4f,0x6d
	.byte 0x13,0x01,0x01
	.byte 0x00,0x00,0x4f,0x8c,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x00,0x08,0x00,0x00,0x4f,0x7f,0x13
	.byte 0x01,0x01,0x00,0x00,0x4f,0x9e,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x00,0x08,0x00,0x00,0x4f
	.byte 0x91,0x13,0x01,0x01,0x00,0x00,0x4f,0xb5
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x00,0x08,0x00,0x00,0x4f,0xa3
	.byte 0x13,0x01,0x01,0x00,0x00,0x4f,0xcc,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x00,0x08,0x00,0x00,0x4f,0xba,0x13
	.byte 0x01,0x01,0x00,0x00,0x4f,0xde,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x00,0x08,0x00,0x00,0x4f
	.byte 0xd1,0x13,0x01,0x01,0x00,0x00,0x4f,0xf5
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x00,0x08,0x00,0x00,0x4f,0xe3
	.byte 0x13,0x01,0x01,0x00,0x00,0x50,0x1b,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x00,0x08,0x00,0x00,0x4f,0xfa,0x13,0x01
	.byte 0x01,0x00,0x00,0x50,0x32,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x00
	.byte 0x08,0x00,0x00,0x50,0x20,0x13,0x01,0x01
	.byte 0x00,0x00,0x50,0x67,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x31,0x84,0x00,0x08,0x00,0x00
	.byte 0x50,0x37,0x13,0x01,0x01,0x00,0x00,0x50
	.byte 0x8d,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x00,0x08,0x00,0x00,0x50,0x6c
	.byte 0x15,0x01,0x00,0x00,0x01,0x42,0x01,0x00
	.byte 0x00,0x50,0xa8,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x50,0x92,0x13,0x01,0x01,0x00,0x00
	.byte 0x50,0xce,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x00,0x08,0x00,0x00,0x50
	.byte 0xad,0x13,0x01,0x01,0x00,0x00,0x50,0xef
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x00,0x08,0x00,0x00
	.byte 0x50,0xd3,0x13,0x01,0x01,0x00,0x00,0x51
	.byte 0x15,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x00,0x08,0x00,0x00,0x50,0xf4
	.byte 0x13,0x01,0x01,0x00,0x00,0x51,0x31,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x45,0xbf,0x00,0x08
	.byte 0x00,0x00,0x51,0x1a,0x13,0x01,0x01,0x00
	.byte 0x00,0x51,0x48,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x51,0x36,0x13,0x01,0x01,0x00,0x00
	.byte 0x51,0x69,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x66,0x00,0x08
	.byte 0x00,0x00,0x51,0x4d,0x13,0x01,0x01,0x00
	.byte 0x00,0x51,0x80,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x66,0x00,0x08,0x00
	.byte 0x00,0x51,0x6e,0x13,0x01,0x01,0x00,0x00
	.byte 0x51,0xa1,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x00,0x08
	.byte 0x00,0x00,0x51,0x85,0x13,0x01,0x01,0x00
	.byte 0x00,0x51,0xbd,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x00,0x08,0x00,0x00,0x51,0xa6
	.byte 0x13,0x01,0x01,0x00,0x00,0x51,0xe3,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x00,0x08,0x00,0x00,0x51,0xc2,0x12,0x00
	.byte 0x00,0x31,0x7c,0x08,0x00,0x00,0x51,0xe8
	.byte 0x13,0x01,0x01,0x00,0x00,0x52,0x13,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x51,0xed
	.byte 0x00,0x08,0x00,0x00,0x51,0xf2,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x52,0x18
	.byte 0x13,0x01,0x01,0x00,0x00,0x52,0x3e,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x52,0x1d,0x00,0x08,0x00,0x00,0x52
	.byte 0x22,0x12,0x00,0x00,0x01,0x7f,0x08,0x00
	.byte 0x00,0x52,0x43,0x13,0x01,0x01,0x00,0x00
	.byte 0x52,0x69,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x52,0x48,0x00,0x08
	.byte 0x00,0x00,0x52,0x4d,0x13,0x01,0x01,0x00
	.byte 0x00,0x52,0xa3,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x40,0xb4
	.byte 0x00,0x08,0x00,0x00,0x52,0x6e,0x13,0x01
	.byte 0x01,0x00,0x00,0x52,0xe2,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x40,0xb4,0x00
	.byte 0x08,0x00,0x00,0x52,0xa8,0x13,0x01,0x01
	.byte 0x00,0x00,0x53,0x17,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x40,0xb4,0x00,0x08,0x00,0x00
	.byte 0x52,0xe7,0x13,0x01,0x01,0x00,0x00,0x53
	.byte 0x56,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x40,0xb4,0x00,0x08,0x00,0x00,0x53
	.byte 0x1c,0x13,0x01,0x01,0x00,0x00,0x53,0x9a
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x40,0xb4,0x00
	.byte 0x08,0x00,0x00,0x53,0x5b,0x13,0x01,0x01
	.byte 0x00,0x00,0x53,0xe3,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x40,0xb4
	.byte 0x00,0x08,0x00,0x00,0x53,0x9f,0x12,0x00
	.byte 0x00,0x01,0x7f,0x08,0x00,0x00,0x53,0xe8
	.byte 0x13,0x01,0x01,0x00,0x00,0x54,0x0e,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x53,0xed,0x00,0x08,0x00,0x00,0x53
	.byte 0xf2,0x13,0x01,0x01,0x00,0x00,0x54,0x2f
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x00,0x08,0x00,0x00
	.byte 0x54,0x13,0x13,0x01,0x01,0x00,0x00,0x54
	.byte 0x4b,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x7f,0x14,0x00,0x00,0x01,0x7f
	.byte 0x00,0x08,0x00,0x00,0x54,0x34,0x13,0x01
	.byte 0x01,0x00,0x00,0x54,0x6c,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x00,0x08,0x00,0x00,0x54,0x50,0x13
	.byte 0x01,0x01,0x00,0x00,0x54,0x92,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x7f
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x00
	.byte 0x08,0x00,0x00,0x54,0x71,0x12,0x00,0x00
	.byte 0x01,0x7f,0x08,0x00,0x00,0x54,0x97,0x13
	.byte 0x01,0x01,0x00,0x00,0x54,0xb3,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x54,0x9c
	.byte 0x00,0x08,0x00,0x00,0x54,0xa1,0x12,0x00
	.byte 0x00,0x31,0x7c,0x08,0x00,0x00,0x54,0xb8
	.byte 0x13,0x01,0x01,0x00,0x00,0x54,0xe3,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0xaf,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x54,0xbd
	.byte 0x00,0x08,0x00,0x00,0x54,0xc2,0x13,0x01
	.byte 0x01,0x00,0x00,0x55,0x09,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x00,0x08
	.byte 0x00,0x00,0x54,0xe8,0x13,0x01,0x01,0x00
	.byte 0x00,0x55,0x2f,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x7f,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x00,0x08,0x00,0x00
	.byte 0x55,0x0e,0x13,0x01,0x01,0x00,0x00,0x55
	.byte 0x41,0x14,0x00,0x00,0x3c,0x5b,0x00,0x08
	.byte 0x00,0x00,0x55,0x34,0x11
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x02,0x00,0x00,0x63,0xea,0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x3c,0x77,0x02,0x23,0x00,0x0e
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x3c,0x93,0x02,0x23,0x04,0x0e
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x3c,0xc2,0x02,0x23,0x08,0x0e
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x3c,0xd9,0x02,0x23,0x0c,0x0e
	.ascii "Begin\0"
	.byte 0x00,0x00,0x3c,0xf0,0x02,0x23,0x10,0x0e
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x3d,0x0c,0x02,0x23,0x14,0x0e
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x3d,0xfa,0x02,0x23,0x18,0x0e
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x3e,0x20,0x02,0x23,0x1c,0x0e
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x3e,0x37,0x02,0x23,0x20,0x0e
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x3e,0x53,0x02,0x23,0x24,0x0e
	.ascii "CallList\0"
	.byte 0x00,0x00,0x3e,0x6a,0x02,0x23,0x28,0x0e
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x3e,0x95,0x02,0x23,0x2c,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x3e,0xac,0x02,0x23,0x30,0x0e
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x3e,0xd2,0x02,0x23,0x34,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x3e,0xf8,0x02,0x23,0x38,0x0e
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x3f,0x19,0x02,0x23,0x3c,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x3f,0x30,0x02,0x23,0x40,0x0e
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x3f,0x47,0x02,0x23,0x44,0x0e
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x3f,0x6d,0x02,0x23,0x48,0x0e
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x3f,0x8e,0x02,0x23,0x4c,0x0e
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x3f,0xaf,0x02,0x23,0x50,0x0e
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x3f,0xd5,0x02,0x23,0x54,0x0e
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x3f,0xf6,0x02,0x23,0x58,0x0e
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x40,0x1c,0x02,0x23,0x5c,0x0e
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x40,0x3d,0x02,0x23,0x60,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x40,0x63,0x02,0x23,0x64,0x0e
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x40,0x7f,0x02,0x23,0x68,0x0e
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x40,0xaf,0x02,0x23,0x6c,0x0e
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x40,0xd5,0x02,0x23,0x70,0x0e
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x40,0xf6,0x02,0x23,0x74,0x0e
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x41,0x21,0x02,0x23,0x78,0x0e
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x41,0x56,0x02,0x23,0x7c,0x0e
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x41,0x90,0x03,0x23,0x80,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x41,0xc0,0x03,0x23,0x84,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x41,0xfa,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x42,0x39,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x42,0x50,0x03,0x23,0x90,0x01
	.byte 0x0e
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x42,0x6c,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x42,0x92,0x03,0x23,0x98,0x01
	.byte 0x0e
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x42,0xa9,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x42,0xc0,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x42,0xdc,0x03,0x23,0xa4,0x01
	.byte 0x0e
	.ascii "Disable\0"
	.byte 0x00,0x00,0x42,0xf3,0x03,0x23,0xa8,0x01
	.byte 0x0e
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x43,0x0a,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x43,0x2b,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x43,0x42,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x43,0x72,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x43,0xa7,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x43,0xbe,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x43,0xe4,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "Enable\0"
	.byte 0x00,0x00,0x43,0xfb,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x44,0x12,0x03,0x23,0xcc,0x01
	.byte 0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x44,0x24,0x03,0x23,0xd0,0x01
	.byte 0x0e
	.ascii "EndList\0"
	.byte 0x00,0x00,0x44,0x36,0x03,0x23,0xd4,0x01
	.byte 0x0e
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x44,0x4d,0x03,0x23,0xd8,0x01
	.byte 0x0e
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x44,0x69,0x03,0x23,0xdc,0x01
	.byte 0x0e
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x44,0x8a,0x03,0x23,0xe0,0x01
	.byte 0x0e
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x44,0xb5,0x03,0x23,0xe4,0x01
	.byte 0x0e
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x44,0xcc,0x03,0x23,0xe8,0x01
	.byte 0x0e
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x44,0xe8,0x03,0x23,0xec,0x01
	.byte 0x0e
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x45,0x0e,0x03,0x23,0xf0,0x01
	.byte 0x0e
	.ascii "Finish\0"
	.byte 0x00,0x00,0x45,0x20,0x03,0x23,0xf4,0x01
	.byte 0x0e
	.ascii "Flush\0"
	.byte 0x00,0x00,0x45,0x32,0x03,0x23,0xf8,0x01
	.byte 0x0e
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x45,0x58,0x03,0x23,0xfc,0x01
	.byte 0x0e
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x45,0x6f,0x03,0x23,0x80,0x02
	.byte 0x0e
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x45,0x9f,0x03,0x23,0x84,0x02
	.byte 0x0e
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x45,0xba,0x03,0x23,0x88,0x02
	.byte 0x0e
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x45,0xdb,0x03,0x23,0x8c,0x02
	.byte 0x0e
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x45,0xf7,0x03,0x23,0x90,0x02
	.byte 0x0e
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x46,0x18,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x46,0x3e,0x03,0x23,0x98,0x02
	.byte 0x0e
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x46,0x64,0x03,0x23,0x9c,0x02
	.byte 0x0e
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x46,0x80,0x03,0x23,0xa0,0x02
	.byte 0x0e
	.ascii "GetError\0"
	.byte 0x00,0x00,0x46,0x96,0x03,0x23,0xa4,0x02
	.byte 0x0e
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x46,0xb2,0x03,0x23,0xa8,0x02
	.byte 0x0e
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x46,0xce,0x03,0x23,0xac,0x02
	.byte 0x0e
	.ascii "GetString\0"
	.byte 0x00,0x00,0x46,0xf3,0x03,0x23,0xb0,0x02
	.byte 0x0e
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x47,0x14,0x03,0x23,0xb4,0x02
	.byte 0x0e
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x47,0x35,0x03,0x23,0xb8,0x02
	.byte 0x0e
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x47,0x56,0x03,0x23,0xbc,0x02
	.byte 0x0e
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x47,0x77,0x03,0x23,0xc0,0x02
	.byte 0x0e
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x47,0x98,0x03,0x23,0xc4,0x02
	.byte 0x0e
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x47,0xb9,0x03,0x23,0xc8,0x02
	.byte 0x0e
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x47,0xda,0x03,0x23,0xcc,0x02
	.byte 0x0e
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x47,0xf6,0x03,0x23,0xd0,0x02
	.byte 0x0e
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x48,0x12,0x03,0x23,0xd4,0x02
	.byte 0x0e
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x48,0x45,0x03,0x23,0xd8,0x02
	.byte 0x0e
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x48,0x66,0x03,0x23,0xdc,0x02
	.byte 0x0e
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x48,0x7d,0x03,0x23,0xe0,0x02
	.byte 0x0e
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x48,0xb2,0x03,0x23,0xe4,0x02
	.byte 0x0e
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x48,0xd3,0x03,0x23,0xe8,0x02
	.byte 0x0e
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x48,0xf4,0x03,0x23,0xec,0x02
	.byte 0x0e
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x49,0x15,0x03,0x23,0xf0,0x02
	.byte 0x0e
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x49,0x36,0x03,0x23,0xf4,0x02
	.byte 0x0e
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x49,0x57,0x03,0x23,0xf8,0x02
	.byte 0x0e
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x49,0x82,0x03,0x23,0xfc,0x02
	.byte 0x0e
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x49,0xa8,0x03,0x23,0x80,0x03
	.byte 0x0e
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x49,0xce,0x03,0x23,0x84,0x03
	.byte 0x0e
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x49,0xef,0x03,0x23,0x88,0x03
	.byte 0x0e
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x4a,0x10,0x03,0x23,0x8c,0x03
	.byte 0x0e
	.ascii "Hint\0"
	.byte 0x00,0x00,0x4a,0x2c,0x03,0x23,0x90,0x03
	.byte 0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x4a,0x43,0x03,0x23,0x94,0x03
	.byte 0x0e
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x4a,0x5a,0x03,0x23,0x98,0x03
	.byte 0x0e
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x4a,0x71,0x03,0x23,0x9c,0x03
	.byte 0x0e
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x4a,0x9c,0x03,0x23,0xa0,0x03
	.byte 0x0e
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x4a,0xae,0x03,0x23,0xa4,0x03
	.byte 0x0e
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x4a,0xd9,0x03,0x23,0xa8,0x03
	.byte 0x0e
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x4a,0xf4,0x03,0x23,0xac,0x03
	.byte 0x0e
	.ascii "IsList\0"
	.byte 0x00,0x00,0x4b,0x0f,0x03,0x23,0xb0,0x03
	.byte 0x0e
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x4b,0x2a,0x03,0x23,0xb4,0x03
	.byte 0x0e
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x4b,0x50,0x03,0x23,0xb8,0x03
	.byte 0x0e
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x4b,0x80,0x03,0x23,0xbc,0x03
	.byte 0x0e
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x4b,0x9c,0x03,0x23,0xc0,0x03
	.byte 0x0e
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x4b,0xb3,0x03,0x23,0xc4,0x03
	.byte 0x0e
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x4b,0xca,0x03,0x23,0xc8,0x03
	.byte 0x0e
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x4b,0xdc,0x03,0x23,0xcc,0x03
	.byte 0x0e
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x4b,0xfd,0x03,0x23,0xd0,0x03
	.byte 0x0e
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x4c,0x14,0x03,0x23,0xd4,0x03
	.byte 0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x4c,0x2b,0x03,0x23,0xd8,0x03
	.byte 0x0e
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x4c,0x6a,0x03,0x23,0xdc,0x03
	.byte 0x0e
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x4c,0xbd,0x03,0x23,0xe0,0x03
	.byte 0x0e
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x4c,0xde,0x03,0x23,0xe4,0x03
	.byte 0x0e
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x4d,0x0e,0x03,0x23,0xe8,0x03
	.byte 0x0e
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x4d,0x39,0x03,0x23,0xec,0x03
	.byte 0x0e
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x4d,0x50,0x03,0x23,0xf0,0x03
	.byte 0x0e
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x4d,0x71,0x03,0x23,0xf4,0x03
	.byte 0x0e
	.ascii "NewList\0"
	.byte 0x00,0x00,0x4d,0x8d,0x03,0x23,0xf8,0x03
	.byte 0x0e
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x4d,0xae,0x03,0x23,0xfc,0x03
	.byte 0x0e
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x4d,0xcf,0x03,0x23,0x80,0x04
	.byte 0x0e
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x4d,0xfa,0x03,0x23,0x84,0x04
	.byte 0x0e
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x4e,0x2a,0x03,0x23,0x88,0x04
	.byte 0x0e
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x4e,0x41,0x03,0x23,0x8c,0x04
	.byte 0x0e
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x4e,0x6c,0x03,0x23,0x90,0x04
	.byte 0x0e
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x4e,0x88,0x03,0x23,0x94,0x04
	.byte 0x0e
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x4e,0xa4,0x03,0x23,0x98,0x04
	.byte 0x0e
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x4e,0xc0,0x03,0x23,0x9c,0x04
	.byte 0x0e
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x4e,0xe6,0x03,0x23,0xa0,0x04
	.byte 0x0e
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x4e,0xfd,0x03,0x23,0xa4,0x04
	.byte 0x0e
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x4f,0x19,0x03,0x23,0xa8,0x04
	.byte 0x0e
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x4f,0x35,0x03,0x23,0xac,0x04
	.byte 0x0e
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x4f,0x56,0x03,0x23,0xb0,0x04
	.byte 0x0e
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x4f,0x68,0x03,0x23,0xb4,0x04
	.byte 0x0e
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x4f,0x7a,0x03,0x23,0xb8,0x04
	.byte 0x0e
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x4f,0x8c,0x03,0x23,0xbc,0x04
	.byte 0x0e
	.ascii "PopName\0"
	.byte 0x00,0x00,0x4f,0x9e,0x03,0x23,0xc0,0x04
	.byte 0x0e
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x4f,0xb5,0x03,0x23,0xc4,0x04
	.byte 0x0e
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x4f,0xcc,0x03,0x23,0xc8,0x04
	.byte 0x0e
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x4f,0xde,0x03,0x23,0xcc,0x04
	.byte 0x0e
	.ascii "PushName\0"
	.byte 0x00,0x00,0x4f,0xf5,0x03,0x23,0xd0,0x04
	.byte 0x0e
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x50,0x1b,0x03,0x23,0xd4,0x04
	.byte 0x0e
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x50,0x32,0x03,0x23,0xd8,0x04
	.byte 0x0e
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x50,0x67,0x03,0x23,0xdc,0x04
	.byte 0x0e
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x50,0x8d,0x03,0x23,0xe0,0x04
	.byte 0x0e
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x50,0xa8,0x03,0x23,0xe4,0x04
	.byte 0x0e
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x50,0xce,0x03,0x23,0xe8,0x04
	.byte 0x0e
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x50,0xef,0x03,0x23,0xec,0x04
	.byte 0x0e
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x51,0x15,0x03,0x23,0xf0,0x04
	.byte 0x0e
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x51,0x31,0x03,0x23,0xf4,0x04
	.byte 0x0e
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x51,0x48,0x03,0x23,0xf8,0x04
	.byte 0x0e
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x51,0x69,0x03,0x23,0xfc,0x04
	.byte 0x0e
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x51,0x80,0x03,0x23,0x80,0x05
	.byte 0x0e
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x51,0xa1,0x03,0x23,0x84,0x05
	.byte 0x0e
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x51,0xbd,0x03,0x23,0x88,0x05
	.byte 0x0e
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x51,0xe3,0x03,0x23,0x8c,0x05
	.byte 0x0e
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x52,0x13,0x03,0x23,0x90,0x05
	.byte 0x0e
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x52,0x3e,0x03,0x23,0x94,0x05
	.byte 0x0e
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x52,0x69,0x03,0x23,0x98,0x05
	.byte 0x0e
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x52,0xa3,0x03,0x23,0x9c,0x05
	.byte 0x0e
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x52,0xe2,0x03,0x23,0xa0,0x05
	.byte 0x0e
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x53,0x17,0x03,0x23,0xa4,0x05
	.byte 0x0e
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x53,0x56,0x03,0x23,0xa8,0x05
	.byte 0x0e
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x53,0x9a,0x03,0x23,0xac,0x05
	.byte 0x0e
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x53,0xe3,0x03,0x23,0xb0,0x05
	.byte 0x0e
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x54,0x0e,0x03,0x23,0xb4,0x05
	.byte 0x0e
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x54,0x2f,0x03,0x23,0xb8,0x05
	.byte 0x0e
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x54,0x4b,0x03,0x23,0xbc,0x05
	.byte 0x0e
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x54,0x6c,0x03,0x23,0xc0,0x05
	.byte 0x0e
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x54,0x92,0x03,0x23,0xc4,0x05
	.byte 0x0e
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x54,0xb3,0x03,0x23,0xc8,0x05
	.byte 0x0e
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x54,0xe3,0x03,0x23,0xcc,0x05
	.byte 0x0e
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x55,0x09,0x03,0x23,0xd0,0x05
	.byte 0x0e
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x55,0x2f,0x03,0x23,0xd4,0x05
	.byte 0x0e
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x55,0x41,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0d
	.ascii "gl_visual\0"
	.byte 0x4c,0x02,0x00,0x00,0x65,0x92,0x0e
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x01,0x0e
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x04,0x0e
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x08,0x0e
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x0c,0x0e
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x10,0x0e
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x14,0x0e
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x20,0x0e
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x24,0x0e
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x28,0x0e
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x2c,0x0e
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x30,0x0e
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x34,0x0e
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x38,0x0e
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x3c,0x0e
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x40,0x0e
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x44,0x0e
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x48,0x0e
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x49,0x00
	.byte 0x06,0x00,0x00,0x63,0xea
	.ascii "GLvisual\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0x92,0x06,0x00
	.byte 0x00,0x48,0x17
	.ascii "GLdepth\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xa6,0x06,0x00
	.byte 0x00,0x31,0x58
	.ascii "GLstencil\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xb9,0x05
	.ascii "short\0"
	.byte 0x05,0x02,0x06,0x00,0x00,0x65,0xce
	.ascii "GLaccum\0"
	.byte 0x02,0x08,0x00,0x00,0x65,0xd7,0x0d
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x02,0x00,0x00,0x66,0xc1,0x0e
	.ascii "Visual\0"
	.byte 0x00,0x00,0x65,0xa1,0x02,0x23,0x00,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x08,0x0e
	.ascii "Depth\0"
	.byte 0x00,0x00,0x65,0xb4,0x02,0x23,0x0c,0x0e
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x65,0xc9,0x02,0x23,0x10,0x0e
	.ascii "Accum\0"
	.byte 0x00,0x00,0x65,0xe5,0x02,0x23,0x14,0x0e
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0x77,0x02,0x23,0x18,0x0e
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0x77,0x02,0x23,0x1c,0x0e
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0x77,0x02,0x23,0x20,0x0e
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x24,0x0e
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x28,0x0e
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x2c,0x0e
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x30,0x00
	.byte 0x06,0x00,0x00,0x65,0xea
	.ascii "GLframebuffer\0"
	.byte 0x02,0x08,0x00,0x00,0x66,0xc1,0x05
	.ascii "char\0"
	.byte 0x06,0x01,0x12,0x00,0x00,0x66,0xda,0x08
	.byte 0x00,0x00,0x66,0xe2,0x16,0x01,0x00,0x00
	.byte 0x66,0xe7,0x01,0x08,0x00,0x00,0x66,0xec
	.byte 0x13,0x01,0x01,0x00,0x00,0x67,0x05,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x00,0x08,0x00,0x00
	.byte 0x66,0xf8,0x13,0x01,0x01,0x00,0x00,0x67
	.byte 0x1c,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x00,0x08,0x00,0x00,0x67
	.byte 0x0a,0x13,0x01,0x01,0x00,0x00,0x67,0x42
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x31,0x58,0x14,0x00,0x00,0x31,0x58,0x14
	.byte 0x00,0x00,0x31,0x58,0x14,0x00,0x00,0x31
	.byte 0x58,0x00,0x08,0x00,0x00,0x67,0x21,0x13
	.byte 0x01,0x01,0x00,0x00,0x67,0x6d,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x31,0x58
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x00,0x08,0x00,0x00
	.byte 0x67,0x47,0x13,0x01,0x01,0x00,0x00,0x67
	.byte 0x84,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x00,0x08,0x00,0x00,0x67
	.byte 0x72,0x13,0x01,0x01,0x00,0x00,0x67,0xaa
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x31,0x58,0x14,0x00,0x00,0x31,0x58,0x14
	.byte 0x00,0x00,0x31,0x58,0x14,0x00,0x00,0x31
	.byte 0x58,0x00,0x08,0x00,0x00,0x67,0x89,0x15
	.byte 0x01,0x00,0x00,0x31,0x58,0x01,0x00,0x00
	.byte 0x67,0xc5,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0xaf,0x00,0x08,0x00,0x00
	.byte 0x67,0xaf,0x13,0x01,0x01,0x00,0x00,0x67
	.byte 0xe1,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x45,0xbf,0x14,0x00,0x00,0x45,0xbf
	.byte 0x00,0x08,0x00,0x00,0x67,0xca,0x12,0x00
	.byte 0x00,0x31,0x58,0x08,0x00,0x00,0x67,0xe6
	.byte 0x12,0x00,0x00,0x31,0x58,0x08,0x00,0x00
	.byte 0x67,0xf0,0x12,0x00,0x00,0x31,0x58,0x08
	.byte 0x00,0x00,0x67,0xfa,0x12,0x00,0x00,0x31
	.byte 0x58,0x08,0x00,0x00,0x68,0x04,0x12,0x00
	.byte 0x00,0x31,0x58,0x08,0x00,0x00,0x68,0x0e
	.byte 0x13,0x01,0x01,0x00,0x00,0x68,0x4d,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x67,0xeb
	.byte 0x14,0x00,0x00,0x67,0xf5,0x14,0x00,0x00
	.byte 0x67,0xff,0x14,0x00,0x00,0x68,0x09,0x14
	.byte 0x00,0x00,0x68,0x13,0x00,0x08,0x00,0x00
	.byte 0x68,0x18,0x12,0x00,0x00,0x31,0x58,0x08
	.byte 0x00,0x00,0x68,0x52,0x13,0x01,0x01,0x00
	.byte 0x00,0x68,0x7d,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x66,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x68,0x57,0x00,0x08,0x00,0x00
	.byte 0x68,0x5c,0x12,0x00,0x00,0x01,0x42,0x08
	.byte 0x00,0x00,0x68,0x82,0x12,0x00,0x00,0x01
	.byte 0x42,0x08,0x00,0x00,0x68,0x8c,0x12,0x00
	.byte 0x00,0x31,0x58,0x08,0x00,0x00,0x68,0x96
	.byte 0x12,0x00,0x00,0x31,0x58,0x08,0x00,0x00
	.byte 0x68,0xa0,0x12,0x00,0x00,0x31,0x58,0x08
	.byte 0x00,0x00,0x68,0xaa,0x12,0x00,0x00,0x31
	.byte 0x58,0x08,0x00,0x00,0x68,0xb4,0x12,0x00
	.byte 0x00,0x31,0x58,0x08,0x00,0x00,0x68,0xbe
	.byte 0x13,0x01,0x01,0x00,0x00,0x68,0xfd,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x14,0x00,0x00,0x68,0x87,0x14,0x00
	.byte 0x00,0x68,0x91,0x14,0x00,0x00,0x68,0x9b
	.byte 0x14,0x00,0x00,0x68,0xa5,0x14,0x00,0x00
	.byte 0x68,0xaf,0x14,0x00,0x00,0x68,0xb9,0x14
	.byte 0x00,0x00,0x68,0xc3,0x00,0x08,0x00,0x00
	.byte 0x68,0xc8,0x12,0x00,0x00,0x01,0x42,0x08
	.byte 0x00,0x00,0x69,0x02,0x12,0x00,0x00,0x01
	.byte 0x42,0x08,0x00,0x00,0x69,0x0c,0x12,0x00
	.byte 0x00,0x31,0x58,0x08,0x00,0x00,0x69,0x16
	.byte 0x13,0x01,0x01,0x00,0x00,0x69,0x41,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x14,0x00,0x00,0x69,0x07,0x14,0x00
	.byte 0x00,0x69,0x11,0x14,0x00,0x00,0x69,0x1b
	.byte 0x00,0x08,0x00,0x00,0x69,0x20,0x12,0x00
	.byte 0x00,0x01,0x66,0x08,0x00,0x00,0x69,0x46
	.byte 0x12,0x00,0x00,0x31,0x58,0x08,0x00,0x00
	.byte 0x69,0x50,0x13,0x01,0x01,0x00,0x00,0x69
	.byte 0x80,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x69,0x4b,0x14,0x00,0x00,0x69,0x55,0x00
	.byte 0x08,0x00,0x00,0x69,0x5a,0x12,0x00,0x00
	.byte 0x31,0x58,0x08,0x00,0x00,0x69,0x85,0x13
	.byte 0x01,0x01,0x00,0x00,0x69,0xb0,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x66
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x69,0x8a,0x00
	.byte 0x08,0x00,0x00,0x69,0x8f,0x12,0x00,0x00
	.byte 0x01,0x42,0x08,0x00,0x00,0x69,0xb5,0x12
	.byte 0x00,0x00,0x01,0x42,0x08,0x00,0x00,0x69
	.byte 0xbf,0x12,0x00,0x00,0x01,0x66,0x08,0x00
	.byte 0x00,0x69,0xc9,0x12,0x00,0x00,0x31,0x58
	.byte 0x08,0x00,0x00,0x69,0xd3,0x13,0x01,0x01
	.byte 0x00,0x00,0x6a,0x03,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x66,0x14,0x00
	.byte 0x00,0x69,0xba,0x14,0x00,0x00,0x69,0xc4
	.byte 0x14,0x00,0x00,0x69,0xce,0x14,0x00,0x00
	.byte 0x69,0xd8,0x00,0x08,0x00,0x00,0x69,0xdd
	.byte 0x12,0x00,0x00,0x01,0x42,0x08,0x00,0x00
	.byte 0x6a,0x08,0x12,0x00,0x00,0x01,0x42,0x08
	.byte 0x00,0x00,0x6a,0x12,0x12,0x00,0x00,0x31
	.byte 0x58,0x08,0x00,0x00,0x6a,0x1c,0x13,0x01
	.byte 0x01,0x00,0x00,0x6a,0x47,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x66,0x14
	.byte 0x00,0x00,0x6a,0x0d,0x14,0x00,0x00,0x6a
	.byte 0x17,0x14,0x00,0x00,0x6a,0x21,0x00,0x08
	.byte 0x00,0x00,0x6a,0x26,0x13,0x01,0x01,0x00
	.byte 0x00,0x6a,0x6d,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x66,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x45,0xbf,0x00,0x08,0x00,0x00
	.byte 0x6a,0x4c,0x13,0x01,0x01,0x00,0x00,0x6a
	.byte 0xa2,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0x66,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x34,0x8c,0x14,0x00,0x00,0x34,0x8c,0x14
	.byte 0x00,0x00,0x34,0x8c,0x14,0x00,0x00,0x34
	.byte 0x8c,0x00,0x08,0x00,0x00,0x6a,0x72,0x12
	.byte 0x00,0x00,0x01,0x42,0x08,0x00,0x00,0x6a
	.byte 0xa7,0x12,0x00,0x00,0x01,0x42,0x08,0x00
	.byte 0x00,0x6a,0xb1,0x12,0x00,0x00,0x31,0x58
	.byte 0x08,0x00,0x00,0x6a,0xbb,0x13,0x01,0x01
	.byte 0x00,0x00,0x6a,0xeb,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x66,0x14,0x00
	.byte 0x00,0x6a,0xac,0x14,0x00,0x00,0x6a,0xb6
	.byte 0x14,0x00,0x00,0x45,0xbf,0x14,0x00,0x00
	.byte 0x6a,0xc0,0x00,0x08,0x00,0x00,0x6a,0xc5
	.byte 0x12,0x00,0x00,0x01,0x42,0x08,0x00,0x00
	.byte 0x6a,0xf0,0x12,0x00,0x00,0x01,0x42,0x08
	.byte 0x00,0x00,0x6a,0xfa,0x12,0x00,0x00,0x31
	.byte 0x58,0x08,0x00,0x00,0x6b,0x04,0x13,0x01
	.byte 0x01,0x00,0x00,0x6b,0x43,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0x66,0x14
	.byte 0x00,0x00,0x6a,0xf5,0x14,0x00,0x00,0x6a
	.byte 0xff,0x14,0x00,0x00,0x34,0x8c,0x14,0x00
	.byte 0x00,0x34,0x8c,0x14,0x00,0x00,0x34,0x8c
	.byte 0x14,0x00,0x00,0x34,0x8c,0x14,0x00,0x00
	.byte 0x6b,0x09,0x00,0x08,0x00,0x00,0x6b,0x0e
	.byte 0x13,0x01,0x01,0x00,0x00,0x6b,0x55,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x00,0x08,0x00,0x00
	.byte 0x6b,0x48,0x13,0x01,0x01,0x00,0x00,0x6b
	.byte 0x67,0x14,0x00,0x00,0x3c,0x5b,0x00,0x08
	.byte 0x00,0x00,0x6b,0x5a,0x15,0x01,0x00,0x00
	.byte 0x31,0x58,0x01,0x00,0x00,0x6b,0x82,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0x66,0x00,0x08,0x00,0x00,0x6b,0x6c,0x15
	.byte 0x01,0x00,0x00,0x31,0x58,0x01,0x00,0x00
	.byte 0x6b,0xac,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x31,0x58,0x14,0x00,0x00,0x31
	.byte 0x58,0x14,0x00,0x00,0x31,0x58,0x14,0x00
	.byte 0x00,0x31,0x58,0x00,0x08,0x00,0x00,0x6b
	.byte 0x87,0x15,0x01,0x00,0x00,0x31,0x58,0x01
	.byte 0x00,0x00,0x6b,0xc7,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0xaf,0x00,0x08
	.byte 0x00,0x00,0x6b,0xb1,0x13,0x01,0x01,0x00
	.byte 0x00,0x6b,0xde,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x31,0x58,0x00,0x08,0x00
	.byte 0x00,0x6b,0xcc,0x13,0x01,0x01,0x00,0x00
	.byte 0x6b,0xf0,0x14,0x00,0x00,0x3c,0x5b,0x00
	.byte 0x08,0x00,0x00,0x6b,0xe3,0x13,0x01,0x01
	.byte 0x00,0x00,0x6c,0x0c,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x7f,0x14,0x00
	.byte 0x00,0x01,0x7f,0x00,0x08,0x00,0x00,0x6b
	.byte 0xf5,0x13,0x01,0x01,0x00,0x00,0x6c,0x1e
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x00,0x08,0x00
	.byte 0x00,0x6c,0x11,0x13,0x01,0x01,0x00,0x00
	.byte 0x6c,0x30,0x14,0x00,0x00,0x3c,0x5b,0x00
	.byte 0x08,0x00,0x00,0x6c,0x23,0x12,0x00,0x00
	.byte 0x48,0x17,0x08,0x00,0x00,0x6c,0x35,0x15
	.byte 0x01,0x00,0x00,0x01,0x66,0x01,0x00,0x00
	.byte 0x6c,0x69,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x66,0x14,0x00,0x00,0x01
	.byte 0x42,0x14,0x00,0x00,0x01,0x42,0x14,0x00
	.byte 0x00,0x6c,0x3a,0x14,0x00,0x00,0x34,0x8c
	.byte 0x00,0x08,0x00,0x00,0x6c,0x3f,0x12,0x00
	.byte 0x00,0x01,0x42,0x08,0x00,0x00,0x6c,0x6e
	.byte 0x12,0x00,0x00,0x01,0x42,0x08,0x00,0x00
	.byte 0x6c,0x78,0x12,0x00,0x00,0x48,0x17,0x08
	.byte 0x00,0x00,0x6c,0x82,0x13,0x01,0x01,0x00
	.byte 0x00,0x6c,0xb2,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0x66,0x14,0x00,0x00
	.byte 0x6c,0x73,0x14,0x00,0x00,0x6c,0x7d,0x14
	.byte 0x00,0x00,0x6c,0x87,0x14,0x00,0x00,0x34
	.byte 0x8c,0x00,0x08,0x00,0x00,0x6c,0x8c,0x13
	.byte 0x01,0x01,0x00,0x00,0x6c,0xd8,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x66
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x44,0xed,0x00
	.byte 0x08,0x00,0x00,0x6c,0xb7,0x13,0x01,0x01
	.byte 0x00,0x00,0x6c,0xfe,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x66,0x14,0x00
	.byte 0x00,0x01,0x42,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x48,0x29,0x00,0x08,0x00
	.byte 0x00,0x6c,0xdd,0x13,0x01,0x01,0x00,0x00
	.byte 0x6d,0x1a,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x01,0x66,0x14,0x00,0x00,0x01
	.byte 0x66,0x00,0x08,0x00,0x00,0x6d,0x03,0x06
	.byte 0x00,0x00,0x6d,0x1a
	.ascii "points_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0x4d
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x14,0x00,0x00,0x01,0x66,0x14
	.byte 0x00,0x00,0x01,0x66,0x00,0x08,0x00,0x00
	.byte 0x6d,0x31,0x06,0x00,0x00,0x6d,0x4d
	.ascii "line_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0x83
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x14,0x00,0x00,0x01,0x66,0x14
	.byte 0x00,0x00,0x01,0x66,0x14,0x00,0x00,0x01
	.byte 0x66,0x00,0x08,0x00,0x00,0x6d,0x62,0x06
	.byte 0x00,0x00,0x6d,0x83
	.ascii "triangle_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0xc2
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x14,0x00,0x00,0x01,0x66,0x14
	.byte 0x00,0x00,0x01,0x66,0x14,0x00,0x00,0x01
	.byte 0x66,0x14,0x00,0x00,0x01,0x66,0x00,0x08
	.byte 0x00,0x00,0x6d,0x9c,0x06,0x00,0x00,0x6d
	.byte 0xc2
	.ascii "quad_func\0"
	.byte 0x02,0x13,0x01,0x01,0x00,0x00,0x6d,0xf8
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x01
	.byte 0x42,0x00,0x08,0x00,0x00,0x6d,0xd7,0x06
	.byte 0x00,0x00,0x6d,0xf8
	.ascii "rect_func\0"
	.byte 0x02,0x12,0x00,0x00,0x31,0x7c,0x08,0x00
	.byte 0x00,0x6e,0x0d,0x15,0x01,0x00,0x00,0x31
	.byte 0x58,0x01,0x00,0x00,0x6e,0x50,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x42,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0xaf,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x31,0x58,0x14,0x00
	.byte 0x00,0x6e,0x12,0x00,0x08,0x00,0x00,0x6e
	.byte 0x17,0x12,0x00,0x00,0x3d,0x23,0x08,0x00
	.byte 0x00,0x6e,0x55,0x15,0x01,0x00,0x00,0x31
	.byte 0x58,0x01,0x00,0x00,0x6e,0x93,0x14,0x00
	.byte 0x00,0x3c,0x5b,0x14,0x00,0x00,0x01,0x42
	.byte 0x14,0x00,0x00,0x01,0x42,0x14,0x00,0x00
	.byte 0x01,0x7f,0x14,0x00,0x00,0x01,0x7f,0x14
	.byte 0x00,0x00,0x01,0x7f,0x14,0x00,0x00,0x01
	.byte 0x7f,0x14,0x00,0x00,0x6e,0x5a,0x00,0x08
	.byte 0x00,0x00,0x6e,0x5f,0x13,0x01,0x01,0x00
	.byte 0x00,0x6e,0xaa,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x00,0x08,0x00
	.byte 0x00,0x6e,0x98,0x13,0x01,0x01,0x00,0x00
	.byte 0x6e,0xbc,0x14,0x00,0x00,0x3c,0x5b,0x00
	.byte 0x08,0x00,0x00,0x6e,0xaf,0x13,0x01,0x01
	.byte 0x00,0x00,0x6e,0xd8,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x66,0x14,0x00
	.byte 0x00,0x01,0x66,0x00,0x08,0x00,0x00,0x6e
	.byte 0xc1,0x15,0x01,0x00,0x00,0x31,0x58,0x01
	.byte 0x00,0x00,0x6e,0xf3,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x31,0x58,0x00,0x08
	.byte 0x00,0x00,0x6e,0xdd,0x12,0x00,0x00,0x01
	.byte 0x7f,0x08,0x00,0x00,0x6e,0xf8,0x13,0x01
	.byte 0x01,0x00,0x00,0x6f,0x19,0x14,0x00,0x00
	.byte 0x3c,0x5b,0x14,0x00,0x00,0x01,0xaf,0x14
	.byte 0x00,0x00,0x6e,0xfd,0x00,0x08,0x00,0x00
	.byte 0x6f,0x02,0x12,0x00,0x00,0x31,0x89,0x08
	.byte 0x00,0x00,0x6f,0x1e,0x13,0x01,0x01,0x00
	.byte 0x00,0x6f,0x4e,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x34,0xe8,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x6f
	.byte 0x23,0x00,0x08,0x00,0x00,0x6f,0x28
	.byte 0x12,0x00,0x00,0x01,0x7f,0x08,0x00,0x00
	.byte 0x6f,0x53,0x13,0x01,0x01,0x00,0x00,0x6f
	.byte 0x7e,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x01,0xaf,0x14,0x00,0x00,0x34,0xe8
	.byte 0x14,0x00,0x00,0x01,0xaf,0x14,0x00,0x00
	.byte 0x6f,0x58,0x00,0x08,0x00,0x00,0x6f,0x5d
	.byte 0x13,0x01,0x01,0x00,0x00,0x6f,0x9a,0x14
	.byte 0x00,0x00,0x3c,0x5b,0x14,0x00,0x00,0x01
	.byte 0xaf,0x14,0x00,0x00,0x34,0xe8,0x00,0x08
	.byte 0x00,0x00,0x6f,0x83,0x13,0x01,0x01,0x00
	.byte 0x00,0x6f,0xb1,0x14,0x00,0x00,0x3c,0x5b
	.byte 0x14,0x00,0x00,0x34,0xe8,0x00,0x08,0x00
	.byte 0x00,0x6f,0x9f,0x13,0x01,0x01,0x00,0x00
	.byte 0x6f,0xc8,0x14,0x00,0x00,0x3c,0x5b,0x14
	.byte 0x00,0x00,0x34,0xe8,0x00,0x08,0x00,0x00
	.byte 0x6f,0xb6,0x13,0x01,0x01,0x00,0x00,0x6f
	.byte 0xdf,0x14,0x00,0x00,0x3c,0x5b,0x14,0x00
	.byte 0x00,0x31,0x58,0x00,0x08,0x00,0x00,0x6f
	.byte 0xcd,0x0d
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x74,0x4c,0x0e
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x66,0xf3,0x02,0x23,0x00,0x0e
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x67,0x05,0x02,0x23,0x04,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x67,0x1c,0x02,0x23,0x08,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x67,0x42,0x02,0x23,0x0c,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x67,0x6d,0x02,0x23,0x10,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x67,0x84,0x02,0x23,0x14,0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x67,0xaa,0x02,0x23,0x18,0x0e
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x67,0xc5,0x02,0x23,0x1c,0x0e
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x67,0xe1,0x02,0x23,0x20,0x0e
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x68,0x4d,0x02,0x23,0x24,0x0e
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x68,0x7d,0x02,0x23,0x28,0x0e
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x68,0xfd,0x02,0x23,0x2c,0x0e
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x69,0x41,0x02,0x23,0x30,0x0e
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x69,0x80,0x02,0x23,0x34,0x0e
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x69,0xb0,0x02,0x23,0x38,0x0e
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x6a,0x03,0x02,0x23,0x3c,0x0e
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x6a,0x47,0x02,0x23,0x40,0x0e
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x6a,0x6d,0x02,0x23,0x44,0x0e
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x6a,0xa2,0x02,0x23,0x48,0x0e
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x6a,0xeb,0x02,0x23,0x4c,0x0e
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x6b,0x43,0x02,0x23,0x50,0x0e
	.ascii "Finish\0"
	.byte 0x00,0x00,0x6b,0x55,0x02,0x23,0x54,0x0e
	.ascii "Flush\0"
	.byte 0x00,0x00,0x6b,0x67,0x02,0x23,0x58,0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x6b,0x82,0x02,0x23,0x5c,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x6b,0xac,0x02,0x23,0x60,0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x6b,0xc7,0x02,0x23,0x64,0x0e
	.ascii "Dither\0"
	.byte 0x00,0x00,0x6b,0xde,0x02,0x23,0x68,0x0e
	.ascii "Error\0"
	.byte 0x00,0x00,0x6b,0xf0,0x02,0x23,0x6c,0x0e
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x6c,0x0c,0x02,0x23,0x70,0x0e
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x1e,0x02,0x23,0x74,0x0e
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x6c,0x30,0x02,0x23,0x78,0x0e
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x6c,0x69,0x02,0x23,0x7c,0x0e
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x6c,0xb2,0x03,0x23,0x80,0x01
	.byte 0x0e
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x6c,0xd8,0x03,0x23,0x84,0x01
	.byte 0x0e
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x6c,0xfe,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x6d,0x1f,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x6d,0x52,0x03,0x23,0x90,0x01
	.byte 0x0e
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x6d,0x88,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x6d,0xc7,0x03,0x23,0x98,0x01
	.byte 0x0e
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x6d,0xfd,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x6e,0x50,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x6e,0x93,0x03,0x23,0xa4,0x01
	.byte 0x0e
	.ascii "Begin\0"
	.byte 0x00,0x00,0x6e,0xaa,0x03,0x23,0xa8,0x01
	.byte 0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x6e,0xbc,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x6e,0xd8,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x6e,0xf3,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x6f,0x19,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x6f,0x4e,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x6f,0x7e,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x6f,0x9a,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x6f,0xb1,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xc8,0x03,0x23,0xcc,0x01
	.byte 0x0e
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x6f,0xdf,0x03,0x23,0xd0,0x01
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x40,0x00
	.byte 0x00,0x74,0x5d,0x0a,0x00,0x00,0x01,0x96
	.byte 0x0f,0x00,0x09,0x00,0x00,0x01,0x88,0x40
	.byte 0x00,0x00,0x74,0x6e,0x0a,0x00,0x00,0x01
	.byte 0x96,0x0f,0x00,0x09,0x00,0x00,0x01,0x7f
	.byte 0x40,0x00,0x00,0x74,0x7f,0x0a,0x00,0x00
	.byte 0x01,0x96,0x0f,0x00,0x0f,0x00,0x00,0x74
	.byte 0x6e,0x08,0x00,0x00,0x00,0x74,0x91,0x0a
	.byte 0x00,0x00,0x01,0x96,0x1f,0x00,0x09,0x00
	.byte 0x00,0x01,0x88,0x40,0x00,0x00,0x74,0xa2
	.byte 0x0a,0x00,0x00,0x01,0x96,0x0f,0x00,0x09
	.byte 0x00,0x00,0x01,0x7f,0x40,0x00,0x00,0x74
	.byte 0xb3,0x0a,0x00,0x00,0x01,0x96,0x0f,0x00
	.byte 0x0f,0x00,0x00,0x74,0xa2,0x08,0x00,0x00
	.byte 0x00,0x74,0xc5,0x0a,0x00,0x00,0x01,0x96
	.byte 0x1f,0x00,0x09,0x00,0x00,0x01,0x7f,0x08
	.byte 0x00,0x00,0x74,0xd6,0x0a,0x00,0x00,0x01
	.byte 0x96,0x01,0x00,0x0f,0x00,0x00,0x74,0xc5
	.byte 0x01,0x00,0x00,0x00,0x74,0xe8,0x0a,0x00
	.byte 0x00,0x01,0x96,0x1f,0x00,0x09,0x00,0x00
	.byte 0x01,0x88,0x40,0x00,0x00,0x74,0xf9,0x0a
	.byte 0x00,0x00,0x01,0x96,0x0f,0x00,0x09,0x00
	.byte 0x00,0x01,0x7f,0x40,0x00,0x00,0x75,0x0a
	.byte 0x0a,0x00,0x00,0x01,0x96,0x0f,0x00,0x0f
	.byte 0x00,0x00,0x74,0xf9,0x02,0x80,0x00,0x00
	.byte 0x75,0x1c,0x0a,0x00,0x00,0x01,0x96,0x09
	.byte 0x00,0x06,0x00,0x00,0x01,0x66
	.ascii "GLbitfield\0"
	.byte 0x03,0x08,0x00,0x00,0x75,0x32,0x0d
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x02,0x00,0x00,0x75,0x70,0x0e
	.ascii "kind\0"
	.byte 0x00,0x00,0x75,0x1c,0x02,0x23,0x00,0x0e
	.ascii "data\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x04,0x0e
	.ascii "next\0"
	.byte 0x00,0x00,0x75,0x2d,0x02,0x23,0x08,0x00
	.byte 0x09,0x00,0x00,0x75,0x2d,0x40,0x00,0x00
	.byte 0x75,0x81,0x0a,0x00,0x00,0x01,0x96,0x0f
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x10,0x00
	.byte 0x00,0x75,0x92,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x0d
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x02,0x00,0x00,0x75,0xbd,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0x81,0x02,0x23,0x00,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x75,0xce,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x10,0x00
	.byte 0x00,0x75,0xdf,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x0d
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x02,0x00,0x00,0x77,0x8e,0x0e
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x00,0x0e
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x75,0xbd,0x02,0x23,0x04,0x0e
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x14,0x0e
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x18,0x0e
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x1c,0x0e
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x20,0x0e
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x24,0x0e
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x28,0x0e
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x2c,0x0e
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0x69,0x02,0x23,0x30,0x0e
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x31,0x0e
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x34,0x0e
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x38,0x0e
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x3c,0x0e
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x75,0xce,0x02,0x23,0x40,0x0e
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x50,0x0e
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x54,0x0e
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x55,0x0e
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x56,0x0e
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x57,0x00
	.byte 0x09,0x00,0x00,0x31,0x69,0x04,0x00,0x00
	.byte 0x77,0x9f,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x0c,0x00
	.byte 0x00,0x77,0xb0,0x0a,0x00,0x00,0x01,0x96
	.byte 0x02,0x00,0x09,0x00,0x00,0x01,0x88,0x10
	.byte 0x00,0x00,0x77,0xc1,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x09,0x00,0x00,0x01,0x88
	.byte 0x10,0x00,0x00,0x77,0xd2,0x0a,0x00,0x00
	.byte 0x01,0x96,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0x88,0x10,0x00,0x00,0x77,0xe3,0x0a,0x00
	.byte 0x00,0x01,0x96,0x03,0x00,0x09,0x00,0x00
	.byte 0x01,0x88,0x10,0x00,0x00,0x77,0xf4,0x0a
	.byte 0x00,0x00,0x01,0x96,0x03,0x00,0x0d
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x02,0x00,0x00,0x78,0xde,0x0e
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x77,0x8e,0x02,0x23,0x00,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x04,0x0e
	.ascii "Normal\0"
	.byte 0x00,0x00,0x77,0x9f,0x02,0x23,0x08,0x0e
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x77,0xb0,0x02,0x23,0x14,0x0e
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x77,0xc1,0x02,0x23,0x24,0x0e
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x34,0x0e
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x77,0xd2,0x02,0x23,0x38,0x0e
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x48,0x0e
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x77,0xe3,0x02,0x23,0x4c,0x0e
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x5c,0x0e
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x5d,0x00
	.byte 0x0d
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x79,0x31,0x0e
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x04,0x0e
	.ascii "Test\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x08,0x0e
	.ascii "Mask\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x09,0x00
	.byte 0x0d
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x02,0x00,0x00,0x7b,0x96,0x0e
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x01,0x0e
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x02,0x0e
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x03,0x0e
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x04,0x0e
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x05,0x0e
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x06,0x0e
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x07,0x0e
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x08,0x0e
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x09,0x0e
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0a,0x0e
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0b,0x0e
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0c,0x0e
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0d,0x0e
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0e,0x0e
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0f,0x0e
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x10,0x0e
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x11,0x0e
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x12,0x0e
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x14,0x0e
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x20,0x0e
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x24,0x0e
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x28,0x0e
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x2c,0x0e
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x30,0x0e
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x34,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x7b,0xa7,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x0d
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x7c,0x20,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "Color\0"
	.byte 0x00,0x00,0x7b,0x96,0x02,0x23,0x04,0x0e
	.ascii "Density\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x14,0x0e
	.ascii "Start\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "End\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "Index\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x20,0x0e
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x24,0x00
	.byte 0x0d
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x7c,0x9e,0x0e
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x08,0x0e
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x0c,0x0e
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x10,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x7c,0xaf,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x10,0x00
	.byte 0x00,0x7c,0xc0,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0x88,0x10
	.byte 0x00,0x00,0x7c,0xd1,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x09,0x00,0x00,0x01,0x88
	.byte 0x10,0x00,0x00,0x7c,0xe2,0x0a,0x00,0x00
	.byte 0x01,0x96,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0x88,0x10,0x00,0x00,0x7c,0xf3,0x0a,0x00
	.byte 0x00,0x01,0x96,0x03,0x00,0x11
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x02,0x00,0x00,0x7e,0xb5,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7c,0x9e,0x02,0x23,0x00,0x0e
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7c,0xaf,0x02,0x23,0x10,0x0e
	.ascii "Specular\0"
	.byte 0x00,0x00,0x7c,0xc0,0x02,0x23,0x20,0x0e
	.ascii "Position\0"
	.byte 0x00,0x00,0x7c,0xd1,0x02,0x23,0x30,0x0e
	.ascii "Direction\0"
	.byte 0x00,0x00,0x7c,0xe2,0x02,0x23,0x40,0x0e
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x50,0x0e
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x54,0x0e
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x58,0x0e
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x5c,0x0e
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x60,0x0e
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x64,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x68,0x0e
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x7e,0xb5,0x02,0x23,0x6c,0x0e
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xba,0x02,0x23,0x70,0x0e
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x7e,0xcb,0x02,0x23,0x7c,0x0e
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x7e,0xdc,0x03,0x23,0x88,0x01
	.byte 0x0e
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x7e,0xfe,0x03,0x23,0x94,0x01
	.byte 0x0e
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x7f,0x22,0x03,0x23,0x94,0x21
	.byte 0x0e
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x7f,0x44,0x03,0x23,0xac,0x21
	.byte 0x0e
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x7f,0x66,0x03,0x23,0xc4,0x21
	.byte 0x0e
	.ascii "dli\0"
	.byte 0x00,0x00,0x01,0x88,0x03,0x23,0xdc,0x21
	.byte 0x0e
	.ascii "sli\0"
	.byte 0x00,0x00,0x01,0x88,0x03,0x23,0xe0,0x21
	.byte 0x00,0x08,0x00,0x00,0x7c,0xf3,0x09,0x00
	.byte 0x00,0x01,0x88,0x0c,0x00,0x00,0x7e,0xcb
	.byte 0x0a,0x00,0x00,0x01,0x96,0x02,0x00,0x09
	.byte 0x00,0x00,0x01,0x88,0x0c,0x00,0x00,0x7e
	.byte 0xdc,0x0a,0x00,0x00,0x01,0x96,0x02,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x0c,0x00,0x00
	.byte 0x7e,0xed,0x0a,0x00,0x00,0x01,0x96,0x02
	.byte 0x00,0x09,0x00,0x00,0x01,0x7f,0x08,0x00
	.byte 0x00,0x7e,0xfe,0x0a,0x00,0x00,0x01,0x96
	.byte 0x01,0x00,0x0f,0x00,0x00,0x7e,0xed,0x10
	.byte 0x00,0x00,0x00,0x7f,0x11,0x10,0x00,0x00
	.byte 0x01,0x96,0x01,0xff,0x00,0x09,0x00,0x00
	.byte 0x01,0x7f,0x0c,0x00,0x00,0x7f,0x22,0x0a
	.byte 0x00,0x00,0x01,0x96,0x02,0x00,0x09,0x00
	.byte 0x00,0x7f,0x11,0x18,0x00,0x00,0x7f,0x33
	.byte 0x0a,0x00,0x00,0x01,0x96,0x01,0x00,0x09
	.byte 0x00,0x00,0x01,0x7f,0x0c,0x00,0x00,0x7f
	.byte 0x44,0x0a
	.byte 0x00,0x00,0x01,0x96,0x02,0x00,0x09,0x00
	.byte 0x00,0x7f,0x33,0x18,0x00,0x00,0x7f,0x55
	.byte 0x0a,0x00,0x00,0x01,0x96,0x01,0x00,0x09
	.byte 0x00,0x00,0x01,0x7f,0x0c,0x00,0x00,0x7f
	.byte 0x66,0x0a,0x00,0x00,0x01,0x96,0x02,0x00
	.byte 0x09,0x00,0x00,0x7f,0x55,0x18,0x00,0x00
	.byte 0x7f,0x77,0x0a,0x00,0x00,0x01,0x96,0x01
	.byte 0x00,0x0f,0x00,0x00,0x7c,0xf3,0x87,0x20
	.byte 0x00,0x00,0x7f,0x89,0x0a,0x00,0x00,0x01
	.byte 0x96,0x07,0x00,0x09,0x00,0x00,0x01,0x88
	.byte 0x10,0x00,0x00,0x7f,0x9a,0x0a,0x00,0x00
	.byte 0x01,0x96,0x03,0x00,0x0d
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x02,0x00,0x00,0x7f,0xe4,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0x89,0x02,0x23,0x00,0x0e
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x10,0x0e
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x11,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x7f,0xf5,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x10,0x00
	.byte 0x00,0x80,0x06,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0x88,0x10
	.byte 0x00,0x00,0x80,0x17,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x09,0x00,0x00,0x01,0x88
	.byte 0x10,0x00,0x00,0x80,0x28,0x0a,0x00,0x00
	.byte 0x01,0x96,0x03,0x00,0x0f,0x00,0x00,0x01
	.byte 0x88,0x03,0x20,0x00,0x00,0x80,0x3b,0x10
	.byte 0x00,0x00,0x01,0x96,0x00,0xc7,0x00,0x11
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x02,0x00,0x00,0x80,0xf7,0x0e
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x7f,0xe4,0x02,0x23,0x00,0x0e
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x7f,0xf5,0x02,0x23,0x10,0x0e
	.ascii "Specular\0"
	.byte 0x00,0x00,0x80,0x06,0x02,0x23,0x20,0x0e
	.ascii "Emission\0"
	.byte 0x00,0x00,0x80,0x17,0x02,0x23,0x30,0x0e
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x40,0x0e
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x44,0x0e
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x48,0x0e
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x4c,0x0e
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x80,0x28,0x02,0x23,0x50,0x00
	.byte 0x0f,0x00,0x00,0x80,0x3b,0x06,0xe0,0x00
	.byte 0x00,0x81,0x09,0x0a,0x00,0x00,0x01,0x96
	.byte 0x01,0x00,0x09,0x00,0x00,0x01,0x7f,0x10
	.byte 0x00,0x00,0x81,0x1a,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x09,0x00,0x00,0x81,0x09
	.byte 0x20,0x00,0x00,0x81,0x2b,0x0a,0x00,0x00
	.byte 0x01,0x96,0x01,0x00,0x11
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x02,0x00,0x00,0x82,0x4c,0x0e
	.ascii "Light\0"
	.byte 0x00,0x00,0x7f,0x77,0x02,0x23,0x00,0x0e
	.ascii "Model\0"
	.byte 0x00,0x00,0x7f,0x9a,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0e
	.ascii "Material\0"
	.byte 0x00,0x00,0x80,0xf7,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0e
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0e
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0e
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x7e,0xb5,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0e
	.ascii "Fast\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0e
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x81,0x1a,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x06,0x00,0x00,0x48,0x17
	.ascii "GLushort\0"
	.byte 0x03,0x0d
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x02,0x00,0x00,0x82,0xd4,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x01,0x0e
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x82,0x4c,0x02,0x23,0x02,0x0e
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x08,0x00
	.byte 0x0d
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x02,0x00,0x00,0x82,0xfc,0x0e
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x00,0x00
	.byte 0x0f,0x00,0x00,0x01,0x49,0x04,0x00,0x00
	.byte 0x00,0x83,0x0f,0x10,0x00,0x00,0x01,0x96
	.byte 0x00,0xff,0x00,0x0f,0x00,0x00,0x01,0x49
	.byte 0x04,0x00,0x00,0x00,0x83,0x22,0x10,0x00
	.byte 0x00,0x01,0x96,0x00,0xff,0x00,0x0f,0x00
	.byte 0x00,0x01,0x88,0x04,0x00,0x00,0x00,0x83
	.byte 0x35,0x10,0x00,0x00,0x01,0x96,0x00,0xff
	.byte 0x00,0x0f,0x00,0x00,0x01,0x88,0x04,0x00
	.byte 0x00,0x00,0x83,0x48,0x10,0x00,0x00,0x01
	.byte 0x96,0x00,0xff,0x00,0x0f,0x00,0x00,0x01
	.byte 0x88,0x04,0x00,0x00,0x00,0x83,0x5b,0x10
	.byte 0x00,0x00,0x01,0x96,0x00,0xff,0x00,0x0f
	.byte 0x00,0x00,0x01,0x88,0x04,0x00,0x00,0x00
	.byte 0x83,0x6e,0x10,0x00,0x00,0x01,0x96,0x00
	.byte 0xff,0x00,0x0f,0x00,0x00,0x01,0x88,0x04
	.byte 0x00,0x00,0x00,0x83,0x81,0x10,0x00,0x00
	.byte 0x01,0x96,0x00,0xff,0x00,0x0f,0x00,0x00
	.byte 0x01,0x88,0x04,0x00,0x00,0x00,0x83,0x94
	.byte 0x10,0x00,0x00,0x01,0x96,0x00,0xff,0x00
	.byte 0x0f,0x00,0x00,0x01,0x88,0x04,0x00,0x00
	.byte 0x00,0x83,0xa7,0x10,0x00,0x00,0x01,0x96
	.byte 0x00,0xff,0x00,0x0f,0x00,0x00,0x01,0x88
	.byte 0x04,0x00,0x00,0x00,0x83,0xba,0x10,0x00
	.byte 0x00,0x01,0x96,0x00,0xff,0x00,0x11
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x02,0x00,0x00,0x86,0x79,0x0e
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x04,0x0e
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x08,0x0e
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x0c,0x0e
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x10,0x0e
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x14,0x0e
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x20,0x0e
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x24,0x0e
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x28,0x0e
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x2c,0x0e
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x30,0x0e
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x34,0x0e
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x35,0x0e
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x38,0x0e
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x3c,0x0e
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x40,0x0e
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x44,0x0e
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x48,0x0e
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x4c,0x0e
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x50,0x0e
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x54,0x0e
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x58,0x0e
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x5c,0x0e
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x60,0x0e
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x64,0x0e
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x82,0xfc,0x02,0x23,0x68,0x0e
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x83,0x0f,0x03,0x23,0xe8,0x08
	.byte 0x0e
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x83,0x22,0x03,0x23,0xe8,0x10
	.byte 0x0e
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x83,0x35,0x03,0x23,0xe8,0x18
	.byte 0x0e
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x83,0x48,0x03,0x23,0xe8,0x20
	.byte 0x0e
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x83,0x5b,0x03,0x23,0xe8,0x28
	.byte 0x0e
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x83,0x6e,0x03,0x23,0xe8,0x30
	.byte 0x0e
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x83,0x81,0x03,0x23,0xe8,0x38
	.byte 0x0e
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x83,0x94,0x03,0x23,0xe8,0x40
	.byte 0x0e
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x83,0xa7,0x03,0x23,0xe8,0x48
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x0c,0x00
	.byte 0x00,0x86,0x8a,0x0a,0x00,0x00,0x01,0x96
	.byte 0x02,0x00,0x0d
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x02,0x00,0x00,0x87,0x03,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "Size\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x04,0x0e
	.ascii "Params\0"
	.byte 0x00,0x00,0x86,0x79,0x02,0x23,0x08,0x0e
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x14,0x0e
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x00
	.byte 0x0d
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x02,0x00,0x00,0x88,0x36,0x0e
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x08,0x0e
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0c,0x0e
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x0d,0x0e
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x10,0x0e
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x14,0x0e
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x18,0x0e
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x19,0x0e
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x20,0x0e
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x24,0x0e
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x25,0x0e
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x26,0x0e
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x27,0x00
	.byte 0x09,0x00,0x00,0x01,0x72,0x80,0x00,0x00
	.byte 0x88,0x47,0x0a,0x00,0x00,0x01,0x96,0x1f
	.byte 0x00,0x06,0x00,0x00,0x01,0x42
	.ascii "GLsizei\0"
	.byte 0x03,0x0d
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x02,0x00,0x00,0x88,0xb0,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x08,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x0c,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x10,0x00
	.byte 0x0d
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x02,0x00,0x00,0x89,0x5e,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x00,0x0e
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x08,0x0e
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x0c,0x0e
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x10,0x0e
	.ascii "Ref\0"
	.byte 0x00,0x00,0x65,0xb9,0x02,0x23,0x14,0x0e
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x65,0xb9,0x02,0x23,0x15,0x0e
	.ascii "Clear\0"
	.byte 0x00,0x00,0x65,0xb9,0x02,0x23,0x16,0x0e
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x65,0xb9,0x02,0x23,0x17,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x89,0x6f,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x09,0x00,0x00,0x01,0x88,0x10,0x00
	.byte 0x00,0x89,0x80,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x09,0x00,0x00,0x01,0x88,0x10
	.byte 0x00,0x00,0x89,0x91,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x09,0x00,0x00,0x01,0x88
	.byte 0x10,0x00,0x00,0x89,0xa2,0x0a,0x00,0x00
	.byte 0x01,0x96,0x03,0x00,0x09,0x00,0x00,0x01
	.byte 0x88,0x10,0x00,0x00,0x89,0xb3,0x0a,0x00
	.byte 0x00,0x01,0x96,0x03,0x00,0x09,0x00,0x00
	.byte 0x01,0x88,0x10,0x00,0x00,0x89,0xc4,0x0a
	.byte 0x00,0x00,0x01,0x96,0x03,0x00,0x09,0x00
	.byte 0x00,0x01,0x88,0x10,0x00,0x00,0x89,0xd5
	.byte 0x0a,0x00,0x00,0x01,0x96,0x03,0x00,0x09
	.byte 0x00,0x00,0x01,0x88,0x10,0x00,0x00,0x89
	.byte 0xe6,0x0a,0x00,0x00,0x01,0x96,0x03,0x00
	.byte 0x09,0x00,0x00,0x01,0x88,0x10,0x00,0x00
	.byte 0x89,0xf7,0x0a,0x00,0x00,0x01,0x96,0x03
	.byte 0x00,0x0f,0x00,0x00,0x31,0x69,0x04,0x00
	.byte 0x00,0x00,0x8a,0x0a,0x10,0x00,0x00,0x01
	.byte 0x96,0x03,0xff,0x00,0x11
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x02,0x00,0x00,0x8c,0x39,0x0e
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x00,0x0e
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x89,0x5e,0x02,0x23,0x08,0x0e
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x18,0x0e
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x1c,0x0e
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x20,0x0e
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x24,0x0e
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x28,0x0e
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x89,0x6f,0x02,0x23,0x2c,0x0e
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x89,0x80,0x02,0x23,0x3c,0x0e
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x89,0x91,0x02,0x23,0x4c,0x0e
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x89,0xa2,0x02,0x23,0x5c,0x0e
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x89,0xb3,0x02,0x23,0x6c,0x0e
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x89,0xc4,0x02,0x23,0x7c,0x0e
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x89,0xd5,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x89,0xe6,0x03,0x23,0x9c,0x01
	.byte 0x0e
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xac,0x01
	.byte 0x0e
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xb0,0x01
	.byte 0x0e
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "Current\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xb8,0x01
	.byte 0x0e
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xbc,0x01
	.byte 0x0e
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xc0,0x01
	.byte 0x0e
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x34,0xe8,0x03,0x23,0xc4,0x01
	.byte 0x0e
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0xc8,0x01
	.byte 0x0e
	.ascii "Palette\0"
	.byte 0x00,0x00,0x89,0xf7,0x03,0x23,0xc9,0x01
	.byte 0x0e
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x01,0x72,0x03,0x23,0xcc,0x09
	.byte 0x0e
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0x4b,0x03,0x23,0xd0,0x09
	.byte 0x0e
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0x4b,0x03,0x23,0xd4,0x09
	.byte 0x00,0x09,0x00,0x00,0x01,0x7f,0x10,0x00
	.byte 0x00,0x8c,0x4a,0x0a,0x00,0x00,0x01,0x96
	.byte 0x03,0x00,0x09,0x00,0x00,0x8c,0x39,0x60
	.byte 0x00,0x00,0x8c,0x5b,0x0a,0x00,0x00,0x01
	.byte 0x96,0x05,0x00,0x09,0x00,0x00,0x32,0xbb
	.byte 0x06,0x00,0x00,0x8c,0x6c,0x0a,0x00,0x00
	.byte 0x01,0x96,0x05,0x00,0x0d
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x02,0x00,0x00,0x8c,0xe6,0x0e
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x8c,0x4a,0x02,0x23,0x04,0x0e
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x8c,0x5b,0x02,0x23,0x64,0x0e
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x6a,0x0e
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x6b,0x00
	.byte 0x0d
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x02,0x00,0x00,0x8d,0x8d,0x0e
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "Width\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x08,0x0e
	.ascii "Height\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x0c,0x0e
	.ascii "Near\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x10,0x0e
	.ascii "Far\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x14,0x0e
	.ascii "Sx\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x18,0x0e
	.ascii "Sy\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x1c,0x0e
	.ascii "Sz\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x20,0x0e
	.ascii "Tx\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x24,0x0e
	.ascii "Ty\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x28,0x0e
	.ascii "Tz\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x2c,0x00
	.byte 0x09,0x00,0x00,0x75,0x2d,0x40,0x00,0x00
	.byte 0x8d,0x9e,0x0a,0x00,0x00,0x01,0x96,0x0f
	.byte 0x00,0x08,0x00,0x00,0x32,0xbb,0x0d
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x02,0x00,0x00,0x90,0x4e,0x0e
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x04,0x0e
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x08,0x0e
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x0c,0x0e
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x10,0x0e
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x14,0x0e
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x18,0x0e
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x1c,0x0e
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x20,0x0e
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x24,0x0e
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x28,0x0e
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x2c,0x0e
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x30,0x0e
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x34,0x0e
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x38,0x0e
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x3c,0x0e
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x40,0x0e
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x44,0x0e
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x48,0x0e
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x4c,0x0e
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x50,0x0e
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x54,0x0e
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x58,0x0e
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x5c,0x0e
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x60,0x0e
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x64,0x0e
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x31,0x84,0x02,0x23,0x68,0x0e
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x6c,0x0e
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x70,0x0e
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x88,0x47,0x02,0x23,0x74,0x0e
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x8d,0x9e,0x02,0x23,0x78,0x0e
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x7c,0x00
	.byte 0x0d
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x02,0x00,0x00,0x90,0xfd,0x0e
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x00,0x0e
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x04,0x0e
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x08,0x0e
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x0c,0x0e
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x10,0x0e
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0x49,0x02,0x23,0x14,0x0e
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x18,0x0e
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x19,0x00
	.byte 0x08,0x00,0x00,0x01,0x88,0x0d
	.ascii "gl_1d_map\0"
	.byte 0x14,0x02,0x00,0x00,0x91,0x56,0x0e
	.ascii "Order\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x00,0x0e
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x04,0x0e
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x08,0x0e
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xfd,0x02,0x23,0x0c,0x0e
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x10,0x00
	.byte 0x0d
	.ascii "gl_2d_map\0"
	.byte 0x20,0x02,0x00,0x00,0x91,0xd0,0x0e
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x00,0x0e
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x04,0x0e
	.ascii "u1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x08,0x0e
	.ascii "u2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x0c,0x0e
	.ascii "v1\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x10,0x0e
	.ascii "v2\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x14,0x0e
	.ascii "Points\0"
	.byte 0x00,0x00,0x90,0xfd,0x02,0x23,0x18,0x0e
	.ascii "Retain\0"
	.byte 0x00,0x00,0x32,0xbb,0x02,0x23,0x1c,0x00
	.byte 0x11
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x02,0x00,0x00,0x93,0x5a,0x0e
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x00,0x0e
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x14,0x0e
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x28,0x0e
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x3c,0x0e
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x50,0x0e
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x64,0x0e
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x91,0x02,0x02,0x23,0x78,0x0e
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x91,0x02,0x03,0x23,0x8c,0x01
	.byte 0x0e
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x91,0x02,0x03,0x23,0xa0,0x01
	.byte 0x0e
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xb4,0x01
	.byte 0x0e
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xd4,0x01
	.byte 0x0e
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xf4,0x01
	.byte 0x0e
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xb4,0x02
	.byte 0x0e
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xd4,0x02
	.byte 0x0e
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xf4,0x02
	.byte 0x0e
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0x94,0x03
	.byte 0x0e
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x91,0x56,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0d
	.ascii "gl_feedback\0"
	.byte 0x14,0x02,0x00,0x00,0x93,0xb8,0x0e
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0x4b,0x02,0x23,0x00,0x0e
	.ascii "Mask\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x04,0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x90,0xfd,0x02,0x23,0x08,0x0e
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x0c,0x0e
	.ascii "Count\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x10,0x00
	.byte 0x08,0x00,0x00,0x01,0x72,0x0f,0x00,0x00
	.byte 0x01,0x72,0x01,0x00,0x00,0x00,0x93,0xcf
	.byte 0x0a,0x00,0x00,0x01,0x96,0x3f,0x00,0x11
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x02,0x00,0x00,0x94,0x84,0x0e
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x93,0xb8,0x02,0x23,0x00,0x0e
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x04,0x0e
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x08,0x0e
	.ascii "Hits\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x0c,0x0e
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x01,0x72,0x02,0x23,0x10,0x0e
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x93,0xbd,0x02,0x23,0x14,0x0e
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x32,0xbb,0x03,0x23,0x94,0x02
	.byte 0x0e
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x01,0x88,0x03,0x23,0x98,0x02
	.byte 0x0e
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x01,0x88,0x03,0x23,0x9c,0x02
	.byte 0x00,0x07
	.ascii "vertex_buffer\0"
	.byte 0x01,0x08,0x00,0x00,0x94,0x84,0x0f,0x00
	.byte 0x00,0x01,0x49,0x4b,0x00,0x00,0x00,0x94
	.byte 0xac,0x10,0x00,0x00,0x01,0x96,0x12,0xbf
	.byte 0x00,0x0f,0x00,0x00,0x01,0x49,0x4b,0x00
	.byte 0x00,0x00,0x94,0xbf,0x10,0x00,0x00,0x01
	.byte 0x96,0x12,0xbf,0x00,0x0f,0x00,0x00,0x65
	.byte 0xa6,0x25,0x80,0x00,0x00,0x94,0xd2,0x10
	.byte 0x00,0x00,0x01,0x96,0x12,0xbf,0x00,0x0f
	.byte 0x00,0x00,0x31,0x69,0x12,0xc0,0x00,0x00
	.byte 0x94,0xe5,0x10,0x00,0x00,0x01,0x96,0x12
	.byte 0xbf,0x00,0x0f,0x00,0x00,0x31,0x69,0x12
	.byte 0xc0,0x00,0x00,0x94,0xf8,0x10,0x00,0x00
	.byte 0x01,0x96,0x12,0xbf,0x00,0x0f,0x00,0x00
	.byte 0x31,0x69,0x12,0xc0,0x00,0x00,0x95,0x0b
	.byte 0x10,0x00,0x00,0x01,0x96,0x12,0xbf,0x00
	.byte 0x0f,0x00,0x00,0x31,0x69,0x12,0xc0,0x00
	.byte 0x00,0x95,0x1e,0x10,0x00,0x00,0x01,0x96
	.byte 0x12,0xbf,0x00,0x0f,0x00,0x00,0x01,0x72
	.byte 0x4b,0x00,0x00,0x00,0x95,0x31,0x10,0x00
	.byte 0x00,0x01,0x96,0x12,0xbf,0x00,0x0f,0x00
	.byte 0x00,0x01,0x88,0x4b,0x00,0x00,0x00,0x95
	.byte 0x44,0x10,0x00,0x00,0x01,0x96,0x12,0xbf
	.byte 0x00,0x0f,0x00,0x00,0x01,0x88,0x4b,0x00
	.byte 0x00,0x00,0x95,0x57,0x10,0x00,0x00,0x01
	.byte 0x96,0x12,0xbf,0x00,0x0f,0x00,0x00,0x01
	.byte 0x88,0x4b,0x00,0x00,0x00,0x95,0x6a,0x10
	.byte 0x00,0x00,0x01,0x96,0x12,0xbf,0x00,0x0f
	.byte 0x00,0x00,0x01,0x88,0x4b,0x00,0x00,0x00
	.byte 0x95,0x7d,0x10,0x00,0x00,0x01,0x96,0x12
	.byte 0xbf,0x00,0x09,0x00,0x00,0x01,0x49,0x10
	.byte 0x00,0x00,0x95,0x8e,0x0a,0x00,0x00,0x01
	.byte 0x96,0x03,0x00,0x17
	.ascii "pixel_buffer\0"
	.byte 0x00,0x02,0x7d,0xa0,0x05,0x00,0x00,0x96
	.byte 0x8c,0x0e
	.ascii "x\0"
	.byte 0x00,0x00,0x94,0x99,0x02,0x23,0x00,0x0e
	.ascii "y\0"
	.byte 0x00,0x00,0x94,0xac,0x04,0x23,0x80,0x96
	.byte 0x01,0x0e
	.ascii "z\0"
	.byte 0x00,0x00,0x94,0xbf,0x04,0x23,0x80,0xac
	.byte 0x02,0x0e
	.ascii "r\0"
	.byte 0x00,0x00,0x94,0xd2,0x04,0x23,0x80,0xf7
	.byte 0x02,0x0e
	.ascii "g\0"
	.byte 0x00,0x00,0x94,0xe5,0x04,0x23,0xc0,0x9c
	.byte 0x03,0x0e
	.ascii "b\0"
	.byte 0x00,0x00,0x94,0xf8,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0e
	.ascii "a\0"
	.byte 0x00,0x00,0x95,0x0b,0x04,0x23,0xc0,0xe7
	.byte 0x03,0x0e
	.ascii "i\0"
	.byte 0x00,0x00,0x95,0x1e,0x04,0x23,0x80,0x8d
	.byte 0x04,0x0e
	.ascii "s\0"
	.byte 0x00,0x00,0x95,0x31,0x04,0x23,0x80,0xa3
	.byte 0x05,0x0e
	.ascii "t\0"
	.byte 0x00,0x00,0x95,0x44,0x04,0x23,0x80,0xb9
	.byte 0x06,0x0e
	.ascii "u\0"
	.byte 0x00,0x00,0x95,0x57,0x04,0x23,0x80,0xcf
	.byte 0x07,0x0e
	.ascii "lambda\0"
	.byte 0x00,0x00,0x95,0x6a,0x04,0x23,0x80,0xe5
	.byte 0x08,0x0e
	.ascii "color\0"
	.byte 0x00,0x00,0x95,0x7d,0x04,0x23,0x80,0xfb
	.byte 0x09,0x0e
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0x90,0xfb
	.byte 0x09,0x0e
	.ascii "count\0"
	.byte 0x00,0x00,0x01,0x72,0x04,0x23,0x94,0xfb
	.byte 0x09,0x0e
	.ascii "mono\0"
	.byte 0x00,0x00,0x32,0xbb,0x04,0x23,0x98,0xfb
	.byte 0x09,0x0e
	.ascii "primitive\0"
	.byte 0x00,0x00,0x31,0x4b,0x04,0x23,0x9c,0xfb
	.byte 0x09,0x00,0x08,0x00,0x00,0x95,0x8e,0x06
	.byte 0x00,0x00,0x35,0x8e
	.ascii "GLcontext\0"
	.byte 0x02,0x08,0x00,0x00,0x96,0x91,0x02
	.ascii "gl_logicop_ci_span\0"
	.byte 0x01,0x02,0x01,0x6b
	.uaword gl_logicop_ci_span
	.uaword gl_logicop_ci_span+4204
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x97,0x43
	.byte 0x03,0x00,0x00,0x96,0xa1
	.ascii "ctx\0"
	.byte 0x01,0x69,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x72
	.ascii "n\0"
	.byte 0x01,0x69,0x01,0x69,0x03,0x00,0x00,0x01
	.byte 0x49
	.ascii "x\0"
	.byte 0x01,0x69,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x01,0x49
	.ascii "y\0"
	.byte 0x01,0x69,0x03,0x91,0xd0,0x00,0x03,0x00
	.byte 0x00,0x93,0xb8
	.ascii "index\0"
	.byte 0x01,0x6a,0x03,0x91,0xd4,0x00,0x03,0x00
	.byte 0x00,0x31,0x77
	.ascii "mask\0"
	.byte 0x01,0x6a,0x01,0x6d,0x18
	.ascii "dest\0"
	.byte 0x00,0x00,0x97,0x43,0x01,0x01,0x6c,0x03
	.byte 0x91,0x80,0x4e,0x18
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x72,0x01,0x01,0x6d,0x01
	.byte 0x63,0x04,0x44,0x01,0x18,0x00,0x0f,0x00
	.byte 0x00,0x01,0x72,0x19,0x00,0x00,0x00,0x97
	.byte 0x56,0x10,0x00,0x00,0x01,0x96,0x06,0x3f
	.byte 0x00,0x02
	.ascii "gl_logicop_ci_pixels\0"
	.byte 0x01,0x02,0x01,0xed
	.uaword gl_logicop_ci_pixels
	.uaword gl_logicop_ci_pixels+4208
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x97,0xf6
	.byte 0x03,0x00,0x00,0x96,0xa1
	.ascii "ctx\0"
	.byte 0x01,0xea,0x03,0x91,0xc4,0x00,0x03,0x00
	.byte 0x00,0x01,0x72
	.ascii "n\0"
	.byte 0x01,0xeb,0x01,0x69,0x03,0x00,0x00,0x97
	.byte 0xfb
	.ascii "x\0"
	.byte 0x01,0xeb,0x03,0x91,0xcc,0x00,0x03,0x00
	.byte 0x00,0x98,0x05
	.ascii "y\0"
	.byte 0x01,0xeb,0x03,0x91,0xd0,0x00,0x03,0x00
	.byte 0x00,0x93,0xb8
	.ascii "index\0"
	.byte 0x01,0xec,0x03,0x91,0xd4,0x00,0x03,0x00
	.byte 0x00,0x31,0x77
	.ascii "mask\0"
	.byte 0x01,0xec,0x01,0x6d,0x18
	.ascii "dest\0"
	.byte 0x00,0x00,0x98,0x0a,0x01,0x01,0xee,0x04
	.byte 0x91,0x80,0xea,0x7e,0x18
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x72,0x01,0x01,0xef,0x01
	.byte 0x63,0x04,0x44,0x01,0x18,0x00,0x12,0x00
	.byte 0x00,0x01,0x49,0x08,0x00,0x00,0x97,0xf6
	.byte 0x12,0x00,0x00,0x01,0x49,0x08,0x00,0x00
	.byte 0x98,0x00,0x0f,0x00,0x00,0x01,0x72,0x4b
	.byte 0x00,0x00,0x00,0x98,0x1d,0x10,0x00,0x00
	.byte 0x01,0x96,0x12,0xbf,0x00,0x19
	.ascii "gl_logicop_rgba_span\0"
	.byte 0x01,0x02,0x01,0x01,0x71
	.uaword gl_logicop_rgba_span
	.uaword gl_logicop_rgba_span+17824
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x99,0x68
	.byte 0x1a,0x00,0x00,0x96,0xa1
	.ascii "ctx\0"
	.byte 0x01,0x01,0x6c,0x01,0x68,0x1a,0x00,0x00
	.byte 0x01,0x72
	.ascii "n\0"
	.byte 0x01,0x01,0x6d,0x01,0x69,0x1a,0x00,0x00
	.byte 0x01,0x49
	.ascii "x\0"
	.byte 0x01,0x01,0x6d,0x03,0x91,0xcc,0x00,0x1a
	.byte 0x00,0x00,0x01,0x49
	.ascii "y\0"
	.byte 0x01,0x01,0x6d,0x03,0x91,0xd0,0x00,0x1a
	.byte 0x00,0x00,0x31,0x77
	.ascii "red\0"
	.byte 0x01,0x01,0x6e,0x03,0x91,0xd4,0x00,0x1a
	.byte 0x00,0x00,0x31,0x77
	.ascii "green\0"
	.byte 0x01,0x01,0x6e,0x03,0x91,0xd8,0x00,0x1a
	.byte 0x00,0x00,0x31,0x77
	.ascii "blue\0"
	.byte 0x01,0x01,0x6f,0x01,0x68,0x1a,0x00,0x00
	.byte 0x31,0x77
	.ascii "alpha\0"
	.byte 0x01,0x01,0x6f,0x01,0x6a,0x1a,0x00,0x00
	.byte 0x31,0x77
	.ascii "mask\0"
	.byte 0x01,0x01,0x70,0x01,0x6b,0x1b
	.ascii "rdest\0"
	.byte 0x00,0x00,0x99,0x68,0x01,0x01,0x01,0x72
	.byte 0x03,0x91,0xc0,0x73,0x1b
	.ascii "gdest\0"
	.byte 0x00,0x00,0x99,0x7b,0x01,0x01,0x01,0x72
	.byte 0x03,0x91,0x80,0x67,0x1b
	.ascii "bdest\0"
	.byte 0x00,0x00,0x99,0x8e,0x01,0x01,0x01,0x73
	.byte 0x03,0x91,0xc0,0x5a,0x1b
	.ascii "adest\0"
	.byte 0x00,0x00,0x99,0xa1,0x01,0x01,0x01,0x73
	.byte 0x03,0x91,0x80,0x4e,0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x72,0x01,0x01,0x01,0x74
	.byte 0x01,0x64,0x1b
	.ascii "r\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x01,0x84
	.byte 0x03,0x91,0xfb,0x4d,0x1b
	.ascii "g\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x01,0x85
	.byte 0x03,0x91,0xfa,0x4d,0x1b
	.ascii "b\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x01,0x86
	.byte 0x03,0x91,0xf9,0x4d,0x1b
	.ascii "a\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x01,0x87
	.byte 0x03,0x91,0xf8,0x4d,0x04,0x44,0x01,0x2c
	.byte 0x00,0x0f,0x00,0x00,0x31,0x69,0x06,0x40
	.byte 0x00,0x00,0x99,0x7b,0x10,0x00,0x00,0x01
	.byte 0x96,0x06,0x3f,0x00,0x0f,0x00,0x00,0x31
	.byte 0x69,0x06,0x40,0x00,0x00,0x99,0x8e,0x10
	.byte 0x00,0x00,0x01,0x96,0x06,0x3f,0x00,0x0f
	.byte 0x00,0x00,0x31,0x69,0x06,0x40,0x00,0x00
	.byte 0x99,0xa1,0x10,0x00,0x00,0x01,0x96,0x06
	.byte 0x3f,0x00,0x0f,0x00,0x00,0x31,0x69,0x06
	.byte 0x40,0x00,0x00,0x99,0xb4,0x10,0x00,0x00
	.byte 0x01,0x96,0x06,0x3f,0x00,0x19
	.ascii "gl_logicop_rgba_pixels\0"
	.byte 0x01,0x02,0x01,0x02,0x29
	.uaword gl_logicop_rgba_pixels
	.uaword gl_logicop_rgba_pixels+18388
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x9b,0x06
	.byte 0x1a,0x00,0x00,0x96,0xa1
	.ascii "ctx\0"
	.byte 0x01,0x02,0x24,0x03,0x91,0xc4,0x00,0x1a
	.byte 0x00,0x00,0x01,0x72
	.ascii "n\0"
	.byte 0x01,0x02,0x25,0x01,0x69,0x1a,0x00,0x00
	.byte 0x9b,0x0b
	.ascii "x\0"
	.byte 0x01,0x02,0x25,0x01,0x6a,0x1a,0x00,0x00
	.byte 0x9b,0x15
	.ascii "y\0"
	.byte 0x01,0x02,0x25,0x01,0x6b,0x1a,0x00,0x00
	.byte 0x31,0x77
	.ascii "red\0"
	.byte 0x01,0x02,0x26,0x03,0x91,0xd4,0x00,0x1a
	.byte 0x00,0x00,0x31,0x77
	.ascii "green\0"
	.byte 0x01,0x02,0x26,0x03,0x91,0xd8,0x00,0x1a
	.byte 0x00,0x00,0x31,0x77
	.ascii "blue\0"
	.byte 0x01,0x02,0x27,0x01,0x68,0x1a,0x00,0x00
	.byte 0x31,0x77
	.ascii "alpha\0"
	.byte 0x01,0x02,0x27,0x01,0x6a,0x1a,0x00,0x00
	.byte 0x31,0x77
	.ascii "mask\0"
	.byte 0x01,0x02,0x28,0x01,0x60,0x1b
	.ascii "rdest\0"
	.byte 0x00,0x00,0x9b,0x1a,0x01,0x01,0x02,0x2a
	.byte 0x03,0x91,0xc0,0x5a,0x1b
	.ascii "gdest\0"
	.byte 0x00,0x00,0x9b,0x2d,0x01,0x01,0x02,0x2a
	.byte 0x04,0x91,0x80,0xb5,0x7f,0x1b
	.ascii "bdest\0"
	.byte 0x00,0x00,0x9b,0x40,0x01,0x01,0x02,0x2a
	.byte 0x04,0x91,0xc0,0x8f,0x7f,0x1b
	.ascii "adest\0"
	.byte 0x00,0x00,0x9b,0x53,0x01,0x01,0x02,0x2a
	.byte 0x04,0x91,0x80,0xea,0x7e,0x1b
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x72,0x01,0x01,0x02,0x2b
	.byte 0x01,0x64,0x1b
	.ascii "r\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x02,0x3e
	.byte 0x04,0x91,0xfb,0xe9,0x7e,0x1b
	.ascii "g\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x02,0x3f
	.byte 0x04,0x91,0xfa,0xe9,0x7e,0x1b
	.ascii "b\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x02,0x40
	.byte 0x04,0x91,0xf9,0xe9,0x7e,0x1b
	.ascii "a\0"
	.byte 0x00,0x00,0x31,0x69,0x01,0x01,0x02,0x41
	.byte 0x04,0x91,0xf8,0xe9,0x7e,0x04,0x44,0x01
	.byte 0x30,0x00,0x12,0x00,0x00,0x01,0x49,0x08
	.byte 0x00,0x00,0x9b,0x06,0x12,0x00,0x00,0x01
	.byte 0x49,0x08,0x00,0x00,0x9b,0x10,0x0f,0x00
	.byte 0x00,0x31,0x69,0x12,0xc0,0x00,0x00,0x9b
	.byte 0x2d,0x10,0x00,0x00,0x01,0x96,0x12,0xbf
	.byte 0x00,0x0f,0x00,0x00,0x31,0x69,0x12,0xc0
	.byte 0x00,0x00,0x9b,0x40,0x10,0x00,0x00,0x01
	.byte 0x96,0x12,0xbf,0x00,0x0f,0x00,0x00,0x31
	.byte 0x69,0x12,0xc0,0x00,0x00,0x9b,0x53,0x10
	.byte 0x00,0x00,0x01,0x96,0x12,0xbf,0x00,0x0f
	.byte 0x00,0x00,0x31,0x69,0x12,0xc0,0x00,0x00
	.byte 0x9b,0x66,0x10,0x00,0x00,0x01,0x96,0x12
	.byte 0xbf,0x00,0x1c
	.ascii "gl_read_color_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9b,0xab
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0x66,0x14,0x00,0x00,0x01,0x42,0x14
	.byte 0x00,0x00,0x01,0x42,0x14,0x00,0x00,0x34
	.byte 0x8c,0x14,0x00,0x00,0x34,0x8c,0x14,0x00
	.byte 0x00,0x34,0x8c,0x14,0x00,0x00,0x34,0x8c
	.byte 0x00,0x12,0x00,0x00,0x66,0xda,0x08,0x00
	.byte 0x00,0x9b,0xab,0x1c
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9b,0xd7
	.byte 0x14,0x00,0x00,0x3c,0x5b,0x14,0x00,0x00
	.byte 0x01,0xaf,0x14,0x00,0x00,0x9b,0xb0,0x00
	.byte 0x12,0x00,0x00,0x35,0x8e,0x08,0x00,0x00
	.byte 0x9b,0xd7,0x12,0x00,0x00,0x66,0xda,0x08
	.byte 0x00,0x00,0x9b,0xe1,0x1c
	.ascii "gl_problem\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x9c,0x0a
	.byte 0x14,0x00,0x00,0x9b,0xdc,0x14,0x00,0x00
	.byte 0x9b,0xe6,0x00,0x12,0x00,0x00,0x01,0x42
	.byte 0x08,0x00,0x00,0x9c,0x0a,0x12,0x00,0x00
	.byte 0x01,0x42,0x08,0x00,0x00,0x9c,0x14,0x12
	.byte 0x00,0x00,0x31,0x58,0x08,0x00,0x00,0x9c
	.byte 0x1e,0x1d
	.ascii "gl_read_alpha_pixels\0"
	.byte 0x01,0x01,0x01,0x01,0x14,0x00,0x00,0x3c
	.byte 0x5b,0x14,0x00,0x00,0x01,0x66,0x14,0x00
	.byte 0x00,0x9c,0x0f,0x14,0x00,0x00,0x9c,0x19
	.byte 0x14,0x00,0x00,0x34,0x8c,0x14,0x00,0x00
	.byte 0x9c,0x23,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=122, siz=4, lab1=gl_LogicOp, lab2=, loff=0
!   reloc[1]: knd=0, off=164, siz=4, lab1=gl_logicop_ci_span, lab2=, loff=0
!   reloc[2]: knd=0, off=589, siz=4, lab1=gl_logicop_ci_pixels, lab2=, loff=0
!   reloc[3]: knd=0, off=1014, siz=4, lab1=gl_logicop_rgba_span, lab2=, loff=0
!   reloc[4]: knd=0, off=1880, siz=4, lab1=gl_logicop_rgba_pixels, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x0a,0xbe,0x00,0x02,0x00,0x00
	.byte 0x00,0x6d,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x6c,0x6f,0x67,0x69,0x63,0x2e,0x63,0x00
	.byte 0x01,0x00,0x00,0x74,0x79,0x70,0x65,0x73
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x67,0x6c
	.byte 0x2e,0x68,0x00,0x02,0x00,0x00,0x64,0x64
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x70,0x62
	.byte 0x2e,0x68,0x00,0x01,0x00,0x00,0x00,0x00
	.byte 0x05,0x02
	.uaword gl_LogicOp
	.byte 0x06,0x02,0x01,0x03,0xc3,0x00,0x01,0x28
	.byte 0x02,0x05,0x03,0x03,0x01,0x02,0x0b,0x03
	.byte 0x12,0x01,0x12,0x18,0x02,0x02,0x03,0x6c
	.byte 0x01,0x02,0x02,0x03,0x17,0x01,0x02,0x05
	.byte 0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_logicop_ci_span
	.byte 0x06,0x02,0x06,0x03,0xef,0x00,0x01,0x13
	.byte 0x13,0x15,0x02,0x04,0x03,0x7e,0x01,0x19
	.byte 0x39,0x78,0x0e,0x10,0x12,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x1c,0x0e,0x18,0x18,0x02
	.byte 0x02,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0x7c,0x0e,0x10,0x12,0x11
	.byte 0x02,0x01,0x03,0x7e,0x01,0x1c,0x0e,0x1c
	.byte 0x18,0x02,0x02,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x0a,0x01,0x78,0x0e,0x10
	.byte 0x12,0x11,0x02,0x03,0x03,0x7e,0x01,0x1c
	.byte 0x0e,0x18,0x18,0x02,0x04,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x02,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x03,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x03
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x04,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x05,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x06,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x04,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x05,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x05
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x06,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x05,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x06,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x04,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x05,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x04
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x05,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x04,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x05,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0x02
	.byte 0x05,0x03,0x99,0x7f,0x01,0x02,0x02,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_logicop_ci_pixels
	.byte 0x06,0x02,0x06,0x03,0xf1,0x01,0x01,0x13
	.byte 0x13,0x19,0x02,0x04,0x03,0x7e,0x01,0x19
	.byte 0x39,0x78,0x0e,0x10,0x12,0x11,0x02,0x01
	.byte 0x03,0x7e,0x01,0x1c,0x0e,0x18,0x18,0x02
	.byte 0x02,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0x7c,0x0e,0x10,0x12,0x11
	.byte 0x02,0x01,0x03,0x7e,0x01,0x1c,0x0e,0x1c
	.byte 0x18,0x02,0x02,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x0a,0x01,0x78,0x0e,0x10
	.byte 0x12,0x11,0x02,0x03,0x03,0x7e,0x01,0x1c
	.byte 0x0e,0x18,0x18,0x02,0x04,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x02,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x03,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x03
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x04,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x05,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x06,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x04,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x05,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x05
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x06,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x05,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x06,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0xa8
	.byte 0x0e,0x10,0x12,0x11,0x02,0x04,0x03,0x7e
	.byte 0x01,0x20,0x0e,0x18,0x18,0x02,0x05,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x07
	.byte 0x01,0xa8,0x0e,0x10,0x12,0x11,0x02,0x04
	.byte 0x03,0x7e,0x01,0x20,0x0e,0x18,0x18,0x02
	.byte 0x05,0x03,0x7e,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x07,0x01,0xa8,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x20,0x0e,0x18
	.byte 0x18,0x02,0x05,0x03,0x7e,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x07,0x01,0xa8,0x0e,0x10
	.byte 0x12,0x11,0x02,0x04,0x03,0x7e,0x01,0x20
	.byte 0x0e,0x18,0x18,0x02,0x05,0x03,0x7e,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x07,0x01,0x02
	.byte 0x05,0x03,0x99,0x7f,0x01,0x02,0x02,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_logicop_rgba_span
	.byte 0x06,0x02,0x0b,0x03,0xf6,0x02,0x01,0x02
	.byte 0x04,0x03,0x03,0x01,0x02,0x02,0x03,0x7d
	.byte 0x01,0x02,0x04,0x03,0x03,0x01,0x3d,0x02
	.byte 0x6c,0x03,0x01,0x01,0x0e,0x10,0x12,0x11
	.byte 0x02,0x04,0x03,0x7e,0x01,0x28,0x0e,0x20
	.byte 0x16,0x11,0x02,0x04,0x03,0x7e,0x01,0x18
	.byte 0x0e,0x02,0x02,0x03,0x0c,0x01,0x02,0x02
	.byte 0x03,0x7c,0x01,0x02,0x04,0x03,0x04,0x01
	.byte 0x02,0x66,0x03,0x7c,0x01,0x10,0x10,0x10
	.byte 0x11,0x02,0x01,0x03,0x7c,0x01,0x19,0x16
	.byte 0x02,0x02,0x03,0x7e,0x01,0x1d,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x01,0x03,0x05,0x01
	.byte 0x12,0x11,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7b,0x01,0x28,0x0e,0x02,0x05,0x03,0x7c
	.byte 0x01,0x10,0x10,0x10,0x11,0x02,0x01,0x03
	.byte 0x7c,0x01,0x19,0x16,0x02,0x01,0x03,0x7e
	.byte 0x01,0x15,0x02,0x01,0x03,0x7e,0x01,0x11
	.byte 0x02,0x01,0x03,0x03,0x01,0x12,0x11,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7b,0x01,0x18
	.byte 0x0e,0x02,0x02,0x03,0x0e,0x01,0x02,0x6c
	.byte 0x03,0x01,0x01,0x0e,0x10,0x12,0x11,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7d,0x01,0x14
	.byte 0x14,0x14,0x02,0x02,0x03,0x7b,0x01,0x28
	.byte 0x0e,0x20,0x16,0x11,0x18,0x18,0x18,0x02
	.byte 0x03,0x03,0x7b,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x0a,0x01,0x02,0x88,0x02,0x03,0x01
	.byte 0x01,0x0e,0x10,0x12,0x11,0x14,0x14,0x14
	.byte 0x02,0x02,0x03,0x7b,0x01,0x38,0x0e,0x20
	.byte 0x18,0x18,0x14,0x14,0x02,0x02,0x03,0x7b
	.byte 0x01,0x18,0x0e,0x02,0x02,0x03,0x0a,0x01
	.byte 0x02,0x88,0x02,0x03,0x01,0x01,0x0e,0x10
	.byte 0x12,0x11,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x14,0x14,0x14,0x02,0x02,0x03
	.byte 0x7b,0x01,0x38,0x0e,0x20,0x18,0x1c,0x18
	.byte 0x18,0x02,0x03,0x03,0x7b,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x0a,0x01,0x02,0x88,0x02
	.byte 0x03,0x01,0x01,0x0e,0x10,0x12,0x11,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7d,0x01,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7d,0x01,0x14
	.byte 0x14,0x14,0x02,0x02,0x03,0x7b,0x01,0x38
	.byte 0x0e,0x20,0x18,0x20,0x1c,0x1c,0x02,0x04
	.byte 0x03,0x7b,0x01,0x18,0x0e,0x02,0x02,0x03
	.byte 0x0a,0x01,0x02,0x88,0x02,0x03,0x01,0x01
	.byte 0x0e,0x10,0x12,0x11,0x14,0x10,0x10,0x02
	.byte 0x01,0x03,0x7e,0x01,0x0e,0x11,0x0e,0x11
	.byte 0x0e,0x02,0x01,0x03,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x14,0x14,0x02,0x02,0x03,0x7b,0x01,0x38
	.byte 0x0e,0x20,0x18,0x24,0x20,0x20,0x02,0x05
	.byte 0x03,0x7b,0x01,0x18,0x0e,0x02,0x02,0x03
	.byte 0x0a,0x01,0x02,0x88,0x02,0x03,0x01,0x01
	.byte 0x0e,0x10,0x12,0x11,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7d,0x01,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7d,0x01,0x14,0x14,0x14,0x02
	.byte 0x02,0x03,0x7b,0x01,0x38,0x0e,0x20,0x18
	.byte 0x20,0x1c,0x1c,0x02,0x04,0x03,0x7b,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x0a,0x01,0x02
	.byte 0x88,0x02,0x03,0x01,0x01,0x0e,0x10,0x12
	.byte 0x11,0x14,0x10,0x10,0x02,0x01,0x03,0x7e
	.byte 0x01,0x0e,0x11,0x0e,0x11,0x0e,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7e,0x01,0x14,0x14,0x02
	.byte 0x02,0x03,0x7b,0x01,0x38,0x0e,0x20,0x18
	.byte 0x24,0x20,0x20,0x02,0x05,0x03,0x7b,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x0a,0x01,0x02
	.byte 0x88,0x02,0x03,0x01,0x01,0x0e,0x10,0x12
	.byte 0x11,0x10,0x10,0x10,0x02,0x01,0x03,0x7d
	.byte 0x01,0x10,0x10,0x10,0x02,0x01,0x03,0x7d
	.byte 0x01,0x14,0x14,0x14,0x02,0x02,0x03,0x7b
	.byte 0x01,0x38,0x0e,0x20,0x18,0x20,0x1c,0x1c
	.byte 0x02,0x04,0x03,0x7b,0x01,0x18,0x0e,0x02
	.byte 0x02,0x03,0x0a,0x01,0x02,0x88,0x02,0x03
	.byte 0x01,0x01,0x0e,0x10,0x12,0x11,0x14,0x10
	.byte 0x10,0x02,0x01,0x03,0x7e,0x01,0x0e,0x11
	.byte 0x0e,0x11,0x0e,0x02,0x01,0x03,0x7e,0x01
	.byte 0x02,0x02,0x03,0x03,0x01,0x02,0x01,0x03
	.byte 0x7e,0x01,0x14,0x14,0x02,0x02,0x03,0x7b
	.byte 0x01,0x38,0x0e,0x20,0x18,0x24,0x20,0x20
	.byte 0x02,0x05,0x03,0x7b,0x01,0x18,0x0e,0x02
	.byte 0x02,0x03,0x0a,0x01,0x02,0x88,0x02,0x03
	.byte 0x01,0x01,0x0e,0x10,0x12,0x11,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7d,0x01,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7d,0x01,0x14,0x14
	.byte 0x14,0x02,0x02,0x03,0x7b,0x01,0x38,0x0e
	.byte 0x20,0x18,0x20,0x1c,0x1c,0x02,0x04,0x03
	.byte 0x7b,0x01,0x18,0x0e,0x02,0x02,0x03,0x0a
	.byte 0x01,0x02,0x88,0x02,0x03,0x01,0x01,0x0e
	.byte 0x10,0x12,0x11,0x10,0x10,0x10,0x02,0x01
	.byte 0x03,0x7d,0x01,0x10,0x10,0x10,0x02,0x01
	.byte 0x03,0x7d,0x01,0x14,0x14,0x14,0x02,0x02
	.byte 0x03,0x7b,0x01,0x38,0x0e,0x20,0x18,0x20
	.byte 0x1c,0x1c,0x02,0x04,0x03,0x7b,0x01,0x18
	.byte 0x0e,0x02,0x02,0x03,0x0a,0x01,0x02,0x88
	.byte 0x02,0x03,0x01,0x01,0x0e,0x10,0x12,0x11
	.byte 0x10,0x10,0x10,0x02,0x01,0x03,0x7d,0x01
	.byte 0x10,0x10,0x10,0x02,0x01,0x03,0x7d,0x01
	.byte 0x14,0x14,0x14,0x02,0x02,0x03,0x7b,0x01
	.byte 0x38,0x0e,0x20,0x18,0x20,0x1c,0x1c,0x02
	.byte 0x04,0x03,0x7b,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x0a,0x01,0x02,0x88,0x02,0x03,0x01
	.byte 0x01,0x0e,0x10,0x12,0x11,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7d,0x01,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7d,0x01,0x14,0x14,0x14
	.byte 0x02,0x02,0x03,0x7b,0x01,0x38,0x0e,0x20
	.byte 0x18,0x20,0x1c,0x1c,0x02,0x04,0x03,0x7b
	.byte 0x01,0x18,0x0e,0x02,0x02,0x03,0x0b,0x01
	.byte 0x02,0x04,0x03,0xe8,0x7e,0x01,0x02,0x02
	.byte 0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_logicop_rgba_pixels
	.byte 0x06,0x02,0x0c,0x03,0xad,0x04,0x01,0x02
	.byte 0x0a,0x03,0x7b,0x01,0x02,0x01,0x03,0x05
	.byte 0x01,0x28,0x02,0x05,0x03,0x05,0x01,0x02
	.byte 0x01,0x03,0x7c,0x01,0x02,0x0a,0x03,0x04
	.byte 0x01,0x45,0x02,0x6a,0x03,0x01,0x01,0x0e
	.byte 0x10,0x12,0x11,0x02,0x04,0x03,0x7e,0x01
	.byte 0x28,0x0e,0x20,0x16,0x11,0x02,0x04,0x03
	.byte 0x7e,0x01,0x18,0x0e,0x02,0x02,0x03,0x0c
	.byte 0x01,0x02,0x02,0x03,0x7c,0x01,0x02,0x03
	.byte 0x03,0x04,0x01,0x02,0x65,0x03,0x7c,0x01
	.byte 0x10,0x10,0x10,0x11,0x02,0x01,0x03,0x7c
	.byte 0x01,0x19,0x16,0x02,0x02,0x03,0x7e,0x01
	.byte 0x1d,0x02,0x01,0x03,0x7e,0x01,0x02,0x01
	.byte 0x03,0x05,0x01,0x12,0x11,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7b,0x01,0x28,0x0e,0x02
	.byte 0x05,0x03,0x7c,0x01,0x10,0x10,0x10,0x11
	.byte 0x02,0x01,0x03,0x7c,0x01,0x19,0x16,0x02
	.byte 0x01,0x03,0x7e,0x01,0x15,0x02,0x01,0x03
	.byte 0x7e,0x01,0x11,0x02,0x01,0x03,0x03,0x01
	.byte 0x12,0x11,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7b,0x01,0x18,0x0e,0x02,0x02,0x03,0x0e
	.byte 0x01,0x02,0x6a,0x03,0x01,0x01,0x0e,0x10
	.byte 0x12,0x11,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x14,0x14,0x14,0x02,0x02,0x03
	.byte 0x7b,0x01,0x28,0x0e,0x20,0x16,0x11,0x18
	.byte 0x18,0x18,0x02,0x03,0x03,0x7b,0x01,0x18
	.byte 0x0e,0x02,0x02,0x03,0x0a,0x01,0x02,0x90
	.byte 0x02,0x03,0x01,0x01,0x0e,0x10,0x12,0x11
	.byte 0x14,0x14,0x14,0x02,0x02,0x03,0x7b,0x01
	.byte 0x38,0x0e,0x20,0x18,0x20,0x14,0x14,0x02
	.byte 0x02,0x03,0x7b,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x0a,0x01,0x02,0x90,0x02,0x03,0x01
	.byte 0x01,0x0e,0x10,0x12,0x11,0x10,0x10,0x10
	.byte 0x02,0x01,0x03,0x7d,0x01,0x14,0x14,0x14
	.byte 0x02,0x02,0x03,0x7b,0x01,0x38,0x0e,0x20
	.byte 0x18,0x24,0x18,0x18,0x02,0x03,0x03,0x7b
	.byte 0x01,0x18,0x0e,0x02,0x02,0x03,0x0a,0x01
	.byte 0x02,0x90,0x02,0x03,0x01,0x01,0x0e,0x10
	.byte 0x12,0x11,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x10,0x10,0x10,0x02,0x01,0x03
	.byte 0x7d,0x01,0x14,0x14,0x14,0x02,0x02,0x03
	.byte 0x7b,0x01,0x38,0x0e,0x20,0x18,0x28,0x1c
	.byte 0x1c,0x02,0x04,0x03,0x7b,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x0a,0x01,0x02,0x90,0x02
	.byte 0x03,0x01,0x01,0x0e,0x10,0x12,0x11,0x14
	.byte 0x10,0x10,0x02,0x01,0x03,0x7e,0x01,0x0e
	.byte 0x11,0x0e,0x11,0x0e,0x02,0x01,0x03,0x7e
	.byte 0x01,0x02,0x02,0x03,0x03,0x01,0x02,0x01
	.byte 0x03,0x7e,0x01,0x14,0x14,0x02,0x02,0x03
	.byte 0x7b,0x01,0x38,0x0e,0x20,0x18,0x2c,0x20
	.byte 0x20,0x02,0x05,0x03,0x7b,0x01,0x18,0x0e
	.byte 0x02,0x02,0x03,0x0a,0x01,0x02,0x90,0x02
	.byte 0x03,0x01,0x01,0x0e,0x10,0x12,0x11,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7d,0x01,0x10
	.byte 0x10,0x10,0x02,0x01,0x03,0x7d,0x01,0x14
	.byte 0x14,0x14,0x02,0x02,0x03,0x7b,0x01,0x38
	.byte 0x0e,0x20,0x18,0x28,0x1c,0x1c,0x02,0x04
	.byte 0x03,0x7b,0x01,0x18,0x0e,0x02,0x02,0x03
	.byte 0x0a,0x01,0x02,0x90,0x02,0x03,0x01,0x01
	.byte 0x0e,0x10,0x12,0x11,0x14,0x10,0x10,0x02
	.byte 0x01,0x03,0x7e,0x01,0x0e,0x11,0x0e,0x11
	.byte 0x0e,0x02,0x01,0x03,0x7e,0x01,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x7e,0x01
	.byte 0x14,0x14,0x02,0x02,0x03,0x7b,0x01,0x38
	.byte 0x0e,0x20,0x18,0x2c,0x20,0x20,0x02,0x05
	.byte 0x03,0x7b,0x01,0x18,0x0e,0x02,0x02,0x03
	.byte 0x0a,0x01,0x02,0x90,0x02,0x03,0x01,0x01
	.byte 0x0e,0x10,0x12,0x11,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7d,0x01,0x10,0x10,0x10,0x02
	.byte 0x01,0x03,0x7d,0x01,0x14,0x14,0x14,0x02
	.byte 0x02,0x03,0x7b,0x01,0x38,0x0e,0x20,0x18
	.byte 0x28,0x1c,0x1c,0x02,0x04,0x03,0x7b,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x0a,0x01,0x02
	.byte 0x90,0x02,0x03,0x01,0x01,0x0e,0x10,0x12
	.byte 0x11,0x14,0x10,0x10,0x02,0x01,0x03,0x7e
	.byte 0x01,0x0e,0x11,0x0e,0x11,0x0e,0x02,0x01
	.byte 0x03,0x7e,0x01,0x02,0x02,0x03,0x03,0x01
	.byte 0x02,0x01,0x03,0x7e,0x01,0x14,0x14,0x02
	.byte 0x02,0x03,0x7b,0x01,0x38,0x0e,0x20,0x18
	.byte 0x2c,0x20,0x20,0x02,0x05,0x03,0x7b,0x01
	.byte 0x18,0x0e,0x02,0x02,0x03,0x0a,0x01,0x02
	.byte 0x90,0x02,0x03,0x01,0x01,0x0e,0x10,0x12
	.byte 0x11,0x10,0x10,0x10,0x02,0x01,0x03,0x7d
	.byte 0x01,0x10,0x10,0x10,0x02,0x01,0x03,0x7d
	.byte 0x01,0x14,0x14,0x14,0x02,0x02,0x03,0x7b
	.byte 0x01,0x38,0x0e,0x20,0x18,0x28,0x1c,0x1c
	.byte 0x02,0x04,0x03,0x7b,0x01,0x18,0x0e,0x02
	.byte 0x02,0x03,0x0a,0x01,0x02,0x90,0x02,0x03
	.byte 0x01,0x01,0x0e,0x10,0x12,0x11,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7d,0x01,0x10,0x10
	.byte 0x10,0x02,0x01,0x03,0x7d,0x01,0x14,0x14
	.byte 0x14,0x02,0x02,0x03,0x7b,0x01,0x38,0x0e
	.byte 0x20,0x18,0x28,0x1c,0x1c,0x02,0x04,0x03
	.byte 0x7b,0x01,0x18,0x0e,0x02,0x02,0x03,0x0a
	.byte 0x01,0x02,0x90,0x02,0x03,0x01,0x01,0x0e
	.byte 0x10,0x12,0x11,0x10,0x10,0x10,0x02,0x01
	.byte 0x03,0x7d,0x01,0x10,0x10,0x10,0x02,0x01
	.byte 0x03,0x7d,0x01,0x14,0x14,0x14,0x02,0x02
	.byte 0x03,0x7b,0x01,0x38,0x0e,0x20,0x18,0x28
	.byte 0x1c,0x1c,0x02,0x04,0x03,0x7b,0x01,0x18
	.byte 0x0e,0x02,0x02,0x03,0x0a,0x01,0x02,0x90
	.byte 0x02,0x03,0x01,0x01,0x0e,0x10,0x12,0x11
	.byte 0x10,0x10,0x10,0x02,0x01,0x03,0x7d,0x01
	.byte 0x10,0x10,0x10,0x02,0x01,0x03,0x7d,0x01
	.byte 0x14,0x14,0x14,0x02,0x02,0x03,0x7b,0x01
	.byte 0x38,0x0e,0x20,0x18,0x28,0x1c,0x1c,0x02
	.byte 0x04,0x03,0x7b,0x01,0x18,0x0e,0x02,0x02
	.byte 0x03,0x0b,0x01,0x02,0x04,0x03,0xe8,0x7e
	.byte 0x01,0x02,0x02,0x00,0x01,0x01
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
	.byte 0x04,0x86,0x84,0x01,0x00,0x92,0x44,0x0b
	.byte 0x91,0x44,0x09,0x00,0x00,0x05,0x24,0x00
	.byte 0x03,0x08,0x3e,0x0b,0x0b,0x0b,0x00,0x00
	.byte 0x06,0x16,0x00,0x49,0x13,0x03,0x08,0x3a
	.byte 0x0b,0x00,0x00,0x07,0x13,0x00,0x03,0x08
	.byte 0x3c,0x0c,0x00,0x00,0x08,0x0f,0x00,0x49
	.byte 0x13,0x00,0x00,0x09,0x01,0x01,0x49,0x13
	.byte 0x0b,0x0b,0x01,0x13,0x00,0x00,0x0a,0x21
	.byte 0x00,0x49,0x13,0x2f,0x0b,0x00,0x00,0x0b
	.byte 0x04,0x01,0x0b,0x0b,0x3a,0x0b,0x01,0x13
	.byte 0x00,0x00,0x0c,0x28,0x00,0x03,0x08,0x1c
	.byte 0x0d,0x00,0x00,0x0d,0x13,0x01,0x03,0x08
	.byte 0x0b,0x0b,0x3a,0x0b,0x01,0x13,0x00,0x00
	.byte 0x0e,0x0d,0x00,0x03,0x08,0x49,0x13,0x38
	.byte 0x0a,0x00,0x00,0x0f,0x01,0x01,0x49,0x13
	.byte 0x0b,0x05,0x01,0x13,0x00,0x00,0x10,0x21
	.byte 0x00,0x49,0x13,0x2f,0x05,0x00,0x00,0x11
	.byte 0x13,0x01,0x03,0x08,0x0b,0x05,0x3a,0x0b
	.byte 0x01,0x13,0x00,0x00,0x12,0x26,0x00,0x49
	.byte 0x13,0x00,0x00,0x13,0x15,0x01,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x14
	.byte 0x05,0x00,0x49,0x13,0x00,0x00,0x15,0x15
	.byte 0x01,0x27,0x0c,0x49,0x13,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x16,0x15,0x00,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x00,0x00
	.byte 0x17,0x13,0x01,0x03,0x08,0x0b,0x06,0x3a
	.byte 0x0b,0x01,0x13,0x00,0x00,0x18,0x34,0x00
	.byte 0x03,0x08,0x49,0x13,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x19,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x05,0x11,0x01,0x12,0x01,0x40
	.byte 0x0a,0x27,0x0c,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x1a,0x05,0x00,0x49,0x13,0x03
	.byte 0x08,0x3a,0x0b,0x3b,0x05,0x02,0x0a,0x00
	.byte 0x00,0x1b,0x34,0x00,0x03,0x08,0x49,0x13
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x02,0x0a
	.byte 0x00,0x00,0x1c,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x3c,0x0c,0x27,0x0c,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x1d,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x84,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x9c,0x64,0x00,0x00,0x00,0xfe
	.byte 0x67,0x6c,0x5f,0x4c,0x6f,0x67,0x69,0x63
	.byte 0x4f,0x70,0x00,0x00,0x00,0x96,0xa6,0x67
	.byte 0x6c,0x5f,0x6c,0x6f,0x67,0x69,0x63,0x6f
	.byte 0x70,0x5f,0x63,0x69,0x5f,0x73,0x70,0x61
	.byte 0x6e,0x00,0x00,0x00,0x97,0x56,0x67,0x6c
	.byte 0x5f,0x6c,0x6f,0x67,0x69,0x63,0x6f,0x70
	.byte 0x5f,0x63,0x69,0x5f,0x70,0x69,0x78,0x65
	.byte 0x6c,0x73,0x00,0x00,0x00,0x98,0x1d,0x67
	.byte 0x6c,0x5f,0x6c,0x6f,0x67,0x69,0x63,0x6f
	.byte 0x70,0x5f,0x72,0x67,0x62,0x61,0x5f,0x73
	.byte 0x70,0x61,0x6e,0x00,0x00,0x00,0x99,0xb4
	.byte 0x67,0x6c,0x5f,0x6c,0x6f,0x67,0x69,0x63
	.byte 0x6f,0x70,0x5f,0x72,0x67,0x62,0x61,0x5f
	.byte 0x70,0x69,0x78,0x65,0x6c,0x73,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x34,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x9c,0x64,0x00,0x00,0x01,0x49
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x01,0x72,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x01,0x88,0x47,0x4c,0x66
	.byte 0x6c,0x6f,0x61,0x74,0x00,0x00,0x00,0x01
	.byte 0xaf,0x00,0x00,0x00,0x31,0x4b,0x47,0x4c
	.byte 0x65,0x6e,0x75,0x6d,0x00,0x00,0x00,0x31
	.byte 0x69,0x47,0x4c,0x75,0x62,0x79,0x74,0x65
	.byte 0x00,0x00,0x00,0x31,0x89,0x67,0x6c,0x5f
	.byte 0x74,0x65,0x78,0x74,0x75,0x72,0x65,0x5f
	.byte 0x69,0x6d,0x61,0x67,0x65,0x00,0x00,0x00
	.byte 0x32,0xbb,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x34,0xd0
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x32,0xcb,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x34,0xed,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x3d,0x11
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x3d,0x23,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x55,0x46
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x63
	.byte 0xea,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x65,0x92,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x65,0xa6,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x65,0xb9
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x65,0xd7,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x65,0xea,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x66,0xc1,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x6d,0x1f
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0x52
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0x88,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x6d,0xc7
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x6d,0xfd,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x6f,0xe4,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x75,0x1c,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x75
	.byte 0x32,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x75,0x92,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x75,0xdf
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x77,0xf4,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x78,0xde
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x79,0x31,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x7b,0xa7,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x7c,0x20,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7c,0xf3,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x7f,0x9a,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x80
	.byte 0x3b,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x81
	.byte 0x2b,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0x4c,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x82,0x5b,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0xd4,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x83,0xba
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x86,0x8a,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x87,0x03
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x88,0x47,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x88,0x55,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x88,0xb0
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8a,0x0a,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0x6c,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8c,0xe6,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x8d,0xa3,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x90,0x4e,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x91,0x02
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x91,0x56,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x91,0xd0,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x93,0x5a,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x93,0xcf,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x95,0x8e,0x70
	.byte 0x69,0x78,0x65,0x6c,0x5f,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x35,0x8e
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6e,0x74,0x65
	.byte 0x78,0x74,0x00,0x00,0x00,0x96,0x91,0x47
	.byte 0x4c,0x63,0x6f,0x6e,0x74,0x65,0x78,0x74
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)stdlib.h\t1.51\t04/06/30 SMI"	! (/tmp/acompAAA.11138.tRaqWv:8)
	.ident	"@(#)stdlib_iso.h\t1.9\t04/09/28 SMI"	! (/tmp/acompAAA.11138.tRaqWv:9)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11138.tRaqWv:10)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11138.tRaqWv:11)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11138.tRaqWv:12)
	.ident	"@(#)stdlib_c99.h\t1.2\t04/03/29 SMI"	! (/tmp/acompAAA.11138.tRaqWv:13)
	.ident	"@(#)math.h\t2.24\t04/10/23 SMI"	! (/tmp/acompAAA.11138.tRaqWv:14)
	.ident	"@(#)math_iso.h\t1.9\t04/10/23 SMI"	! (/tmp/acompAAA.11138.tRaqWv:15)
	.ident	"@(#)math_c99.h\t1.9\t04/11/01 SMI"	! (/tmp/acompAAA.11138.tRaqWv:16)
	.ident	"@(#)floatingpoint.h\t2.9\t04/10/23 SMI"	! (/tmp/acompAAA.11138.tRaqWv:17)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11138.tRaqWv:18)
	.ident	"@(#)ieeefp.h\t2.12\t04/10/23 SMI"	! (/tmp/acompAAA.11138.tRaqWv:19)
	.ident	"@(#)string.h\t1.27\t07/01/14 SMI"	! (/tmp/acompAAA.11138.tRaqWv:20)
	.ident	"@(#)string_iso.h\t1.5\t04/06/18 SMI"	! (/tmp/acompAAA.11138.tRaqWv:21)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11138.tRaqWv:45)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11138.tRaqWv:46)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
