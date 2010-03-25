
	.section	".text",#alloc,#execinstr,#progbits
	.file	"mmath.c"

	.section	".bss",#alloc,#write,#nobits

Bbss.bss:
	.global	$XAa59JCfgJdLmmr.sqrttab
	.align	2
	.global $XAa59JCfgJdLmmr.sqrttab

$XAa59JCfgJdLmmr.sqrttab:
	.skip	512
	.size	$XAa59JCfgJdLmmr.sqrttab,512
	.type	$XAa59JCfgJdLmmr.sqrttab,#object

	.section	".data",#alloc,#write,#progbits

Ddata.data:
	.global	$XBa59JCfgJdLmmr.gl_init_math.initialized
	.global $XBa59JCfgJdLmmr.gl_init_math.initialized

$XBa59JCfgJdLmmr.gl_init_math.initialized:
	.skip	1
	.type	$XBa59JCfgJdLmmr.gl_init_math.initialized,#object

	.section	".rodata",#alloc,#progbits
!
! CONSTANT POOL
!

Drodata.rodata:

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4
! FILE mmath.c

!    1		      !/* $Id: mmath.c,v 1.3 1997/07/24 01:23:16 brianp Exp $ */
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
!   25		      ! * $Log: mmath.c,v $
!   26		      ! * Revision 1.3  1997/07/24 01:23:16  brianp
!   27		      ! * changed precompiled header symbol from PCH to PC_HEADER
!   28		      ! *
!   29		      ! * Revision 1.2  1997/05/28 03:25:43  brianp
!   30		      ! * added precompiled header (PCH) support
!   31		      ! *
!   32		      ! * Revision 1.1  1997/05/01 01:41:54  brianp
!   33		      ! * Initial revision
!   34		      ! *
!   35		      ! */
!   38		      !#ifdef PC_HEADER
!   39		      !#include "all.h"
!   40		      !#else
!   41		      !#include "GL/gl.h"
!   42		      !#include "mmath.h"
!   43		      !#endif
!   47		      !/*
!   48		      ! * A High Speed, Low Precision Square Root
!   49		      ! * by Paul Lalonde and Robert Dawson
!   50		      ! * from "Graphics Gems", Academic Press, 1990
!   51		      ! */
!   53		      !/*
!   54		      ! * SPARC implementation of a fast square root by table 
!   55		      ! * lookup.
!   56		      ! * SPARC floating point format is as follows:
!   57		      ! *
!   58		      ! * BIT 31 	30 	23 	22 	0
!   59		      ! *     sign	exponent	mantissa
!   60		      ! */
!   61		      !static short sqrttab[0x100];    /* declare table of square roots */
!   63		      !static void init_sqrt(void)
!   64		      !{

!
! SUBROUTINE init_sqrt
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       

			init_sqrt:
/* 000000	  64 */		retl	! Result = 
/* 0x0004	     */		nop
/* 0x0008	   0 */		.type	init_sqrt,2
/* 0x0008	   0 */		.size	init_sqrt,(.-init_sqrt)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!   65		      !#ifdef FAST_MATH
!   66		      !   unsigned short i;
!   67		      !   float f;
!   68		      !   unsigned int *fi = (unsigned int *)&f;
!   69		      !                                /* to access the bits of a float in  */
!   70		      !                                /* C quickly we must misuse pointers */
!   72		      !   for(i=0; i<= 0x7f; i++) {
!   73		      !      *fi = 0;
!   75		      !      /*
!   76		      !       * Build a float with the bit pattern i as mantissa
!   77		      !       * and an exponent of 0, stored as 127
!   78		      !       */
!   80		      !      *fi = (i << 16) | (127 << 23);
!   81		      !      f = sqrt(f);
!   83		      !      /*
!   84		      !       * Take the square root then strip the first 7 bits of
!   85		      !       * the mantissa into the table
!   86		      !       */
!   88		      !      sqrttab[i] = (*fi & 0x7fffff) >> 16;
!   90		      !      /*
!   91		      !       * Repeat the process, this time with an exponent of
!   92		      !       * 1, stored as 128
!   93		      !       */
!   95		      !      *fi = 0;
!   96		      !      *fi = (i << 16) | (128 << 23);
!   97		      !      f = sqrt(f);
!   98		      !      sqrttab[i+0x80] = (*fi & 0x7fffff) >> 16;
!   99		      !   }
!  100		      !#endif /*FAST_MATH*/
!  101		      !}
!  104		      !float gl_sqrt( float x )
!  105		      !{

!
! SUBROUTINE gl_sqrt
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_sqrt
                       

			gl_sqrt:
/* 000000	 105 */		st	%o0,[%sp+68]

!  106		      !#ifdef FAST_MATH
!  107		      !   unsigned int *num = (unsigned int *)&x;
!  108		      !                                /* to access the bits of a float in C
!  109		      !                                 * we must misuse pointers */
!  110		      !                                                        
!  111		      !   short e;                     /* the exponent */
!  112		      !   if (x == 0.0F) return 0.0F;  /* check for square root of 0 */
!  113		      !   e = (*num >> 23) - 127;      /* get the exponent - on a SPARC the */
!  114		      !                                /* exponent is stored with 127 added */
!  115		      !   *num &= 0x7fffff;            /* leave only the mantissa */
!  116		      !   if (e & 0x01) *num |= 0x800000;
!  117		      !                                /* the exponent is odd so we have to */
!  118		      !                                /* look it up in the second half of  */
!  119		      !                                /* the lookup table, so we set the   */
!  120		      !                                /* high bit                                */
!  121		      !   e >>= 1;                     /* divide the exponent by two */
!  122		      !                                /* note that in C the shift */
!  123		      !                                /* operators are sign preserving */
!  124		      !                                /* for signed operands */
!  125		      !   /* Do the table lookup, based on the quaternary mantissa,
!  126		      !    * then reconstruct the result back into a float
!  127		      !    */
!  128		      !   *num = ((sqrttab[*num >> 16]) << 16) | ((e + 127) << 23);
!  129		      !   return x;
!  130		      !#else
!  131		      !   return sqrt(x);

/* 0x0004	 131 */		ld	[%sp+68],%f0
/* 0x0008	     */		fstod	%f0,%f2
/* 0x000c	     */		fsqrtd	%f2,%f4
/* 0x0010	     */		retl	! Result =  %f0
/* 0x0014	     */		fdtos	%f4,%f0
/* 0x0018	   0 */		.type	gl_sqrt,2
/* 0x0018	   0 */		.size	gl_sqrt,(.-gl_sqrt)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  132		      !#endif
!  133		      !}
!  137		      !/*
!  138		      ! * Initialize tables, etc for fast math functions.
!  139		      ! */
!  140		      !void gl_init_math(void)
!  141		      !{
!  142		      !   static GLboolean initialized = GL_FALSE;
!  144		      !   if (!initialized) {

!
! SUBROUTINE gl_init_math
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global gl_init_math
                       

			gl_init_math:
/* 000000	 144 */		sethi	%hi($XBa59JCfgJdLmmr.gl_init_math.initialized),%o4
/* 0x0004	     */		ldub	[%o4+%lo($XBa59JCfgJdLmmr.gl_init_math.initialized)],%o5
/* 0x0008	     */		cmp	%o5,0
/* 0x000c	     */		bne,pn	%icc,.L77000041

!  145		      !      init_sqrt();
!  148		      !      initialized = GL_TRUE;

/* 0x0010	 148 */		or	%g0,1,%o5

! Registers live out of gl_init_math: 
! o4 o5 sp o7 fp gsr 
! 
		                       
! predecessor blocks: gl_init_math

			.L77000046:
/* 0x0014	 148 */		stb	%o5,[%o4+%lo($XBa59JCfgJdLmmr.gl_init_math.initialized)]

! Registers live out of .L77000046: 
! sp o7 fp gsr 
! 
		                       
! predecessor blocks: .L77000046 gl_init_math

			.L77000041:
/* 0x0018	 148 */		retl	! Result = 
/* 0x001c	     */		nop
/* 0x0020	   0 */		.type	gl_init_math,2
/* 0x0020	   0 */		.size	gl_init_math,(.-gl_init_math)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	1
/* 0x000c	   0 */		.word	3
/* 0x0010	   0 */		.word	2
/* 0x0014	   0 */		.word	18
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	145
/* 0x0024	   0 */		.word	16409
/* 0x0028	   0 */		.word	3
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.word	8
/* 0x0034	   0 */		.word	0
/* 0x0038	   0 */		.word	0
/* 0x003c	   0 */		.asciz	"mmath.c"
/* 0x0044	   0 */		.asciz	"init_sqrt"

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
!   reloc[2]: knd=0, off=268, siz=4, lab1=init_sqrt, lab2=, loff=0
!   reloc[3]: knd=0, off=272, siz=4, lab1=init_sqrt, lab2=, loff=8
!   reloc[4]: knd=0, off=293, siz=4, lab1=gl_sqrt, lab2=, loff=0
!   reloc[5]: knd=0, off=297, siz=4, lab1=gl_sqrt, lab2=, loff=24
!   reloc[6]: knd=0, off=358, siz=4, lab1=gl_init_math, lab2=, loff=0
!   reloc[7]: knd=0, off=362, siz=4, lab1=gl_init_math, lab2=, loff=32
!   reloc[8]: knd=0, off=396, siz=4, lab1=$XBa59JCfgJdLmmr.gl_init_math.initialized, lab2=, loff=0
!   reloc[9]: knd=0, off=488, siz=4, lab1=$XAa59JCfgJdLmmr.sqrttab, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x02,0x08,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "mmath.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  mmath.c -W0,-xp\\$XAa59JCfgJdLmmr.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCfgJdLmmr.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "init_sqrt\0"
	.byte 0x03,0x01,0x40
	.uaword init_sqrt
	.uaword init_sqrt+8
	.byte 0x01,0x6e,0x01,0x01,0x03
	.ascii "gl_sqrt\0"
	.byte 0x01,0x02,0x01,0x69
	.uaword gl_sqrt
	.uaword gl_sqrt+24
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x4b,0x01
	.byte 0x00,0x00,0x01,0x4b,0x04,0x00,0x00,0x01
	.byte 0x4b
	.ascii "x\0"
	.byte 0x01,0x68,0x03,0x91,0xc4,0x00,0x05,0x44
	.byte 0x01,0x04,0x00,0x06
	.ascii "float\0"
	.byte 0x04,0x04,0x07
	.ascii "gl_init_math\0"
	.byte 0x01,0x02,0x01,0x8d
	.uaword gl_init_math
	.uaword gl_init_math+32
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x91
	.byte 0x08
	.ascii "initialized\0"
	.byte 0x00,0x00,0x01,0xa2,0x03,0x01,0x8e,0x05
	.byte 0x03
	.uaword $XBa59JCfgJdLmmr.gl_init_math.initialized
	.byte 0x00,0x06
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x09,0x00,0x00,0x01,0x91
	.ascii "GLboolean\0"
	.byte 0x02,0x06
	.ascii "short\0"
	.byte 0x05,0x02,0x06
	.ascii "long\0"
	.byte 0x05,0x04,0x0a,0x00,0x00,0x01,0xb2,0x02
	.byte 0x00,0x00,0x00,0x01,0xd6,0x0b,0x00,0x00
	.byte 0x01,0xbb,0x00,0xff,0x00,0x08
	.ascii "sqrttab\0"
	.byte 0x00,0x00,0x01,0xc3,0x03,0x01,0x3d,0x05
	.byte 0x03
	.uaword $XAa59JCfgJdLmmr.sqrttab
	.byte 0x06
	.ascii "double\0"
	.byte 0x04,0x08,0x0c
	.ascii "sqrt\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0xec,0x01
	.byte 0x0d,0x00,0x00,0x01,0xec,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=95, siz=4, lab1=gl_sqrt, lab2=, loff=0
!   reloc[1]: knd=0, off=114, siz=4, lab1=gl_init_math, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x00,0x81,0x00,0x02,0x00,0x00
	.byte 0x00,0x52,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x6d,0x6d,0x61,0x74,0x68,0x2e,0x63,0x00
	.byte 0x01,0x00,0x00,0x67,0x6c,0x2e,0x68,0x00
	.byte 0x02,0x00,0x00,0x00,0x00,0x05,0x02
	.uaword gl_sqrt
	.byte 0x06,0x02,0x01,0x03,0x82,0x01,0x01,0x02
	.byte 0x05,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword gl_init_math
	.byte 0x06,0x03,0x8f,0x01,0x01,0x02,0x04,0x03
	.byte 0x04,0x01,0x02,0x04,0x00,0x01,0x01
!  End sdCreateSection
!  Begin sdCreateSection : .debug_abbrev
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_abbrev"
	.byte 0x01,0x11,0x01,0x03,0x08,0x13,0x0b,0x1b
	.byte 0x08,0x85,0x44,0x08,0x87,0x44,0x08,0x25
	.byte 0x08,0x10,0x06,0x00,0x00,0x02,0x2e,0x00
	.byte 0x03,0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x0b
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x00,0x00,0x03,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x11,0x01,0x12,0x01,0x40,0x0a
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x01
	.byte 0x13,0x00,0x00,0x04,0x05,0x00,0x49,0x13
	.byte 0x03,0x08,0x3a,0x0b,0x3b,0x0b,0x02,0x0a
	.byte 0x00,0x00,0x05,0x86,0x84,0x01,0x00,0x92
	.byte 0x44,0x0b,0x91,0x44,0x09,0x00,0x00,0x06
	.byte 0x24,0x00,0x03,0x08,0x3e,0x0b,0x0b,0x0b
	.byte 0x00,0x00,0x07,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x11
	.byte 0x01,0x12,0x01,0x40,0x0a,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x08,0x34
	.byte 0x00,0x03,0x08,0x49,0x13,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x0b,0x02,0x0a,0x00,0x00,0x09
	.byte 0x16,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x00,0x00,0x0a,0x01,0x01,0x49,0x13,0x0b
	.byte 0x05,0x01,0x13,0x00,0x00,0x0b,0x21,0x00
	.byte 0x49,0x13,0x2f,0x05,0x00,0x00,0x0c,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x00,0x00
	.byte 0x0d,0x05,0x00,0x49,0x13,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x2c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0x18
	.byte 0x67,0x6c,0x5f,0x73,0x71,0x72,0x74,0x00
	.byte 0x00,0x00,0x01,0x54,0x67,0x6c,0x5f,0x69
	.byte 0x6e,0x69,0x74,0x5f,0x6d,0x61,0x74,0x68
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0x1c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x00,0xfe
	.byte 0x69,0x6e,0x69,0x74,0x5f,0x73,0x71,0x72
	.byte 0x74,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x00,0x1c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0xa2
	.byte 0x47,0x4c,0x62,0x6f,0x6f,0x6c,0x65,0x61
	.byte 0x6e,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_varnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_varnames"
	.byte 0x00,0x00,0x00,0x2c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0x76
	.byte 0x69,0x6e,0x69,0x74,0x69,0x61,0x6c,0x69
	.byte 0x7a,0x65,0x64,0x00,0x00,0x00,0x01,0xd6
	.byte 0x73,0x71,0x72,0x74,0x74,0x61,0x62,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)math.h\t2.24\t04/10/23 SMI"	! (/tmp/acompAAA.11161.BWaiZv:8)
	.ident	"@(#)math_iso.h\t1.9\t04/10/23 SMI"	! (/tmp/acompAAA.11161.BWaiZv:9)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11161.BWaiZv:10)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11161.BWaiZv:11)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11161.BWaiZv:12)
	.ident	"@(#)math_c99.h\t1.9\t04/11/01 SMI"	! (/tmp/acompAAA.11161.BWaiZv:13)
	.ident	"@(#)floatingpoint.h\t2.9\t04/10/23 SMI"	! (/tmp/acompAAA.11161.BWaiZv:14)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11161.BWaiZv:15)
	.ident	"@(#)ieeefp.h\t2.12\t04/10/23 SMI"	! (/tmp/acompAAA.11161.BWaiZv:16)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11161.BWaiZv:22)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11161.BWaiZv:30)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
