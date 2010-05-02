
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0
	.type	init_sqrt,#function
init_sqrt:
	save	%sp,-96,%sp

	! block 1
.L13:
.L14:

	! block 2
.L16:
.L17:
.L12:
	jmp	%i7+8
	restore
	.size	init_sqrt,(.-init_sqrt)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_sqrt
	.type	gl_sqrt,#function
gl_sqrt:
	save	%sp,-104,%sp

	! block 1
.L20:
	st	%i0,[%fp+68]

	! block 2
.L21:
.L23:

! File mmath.c:
!    1	/* $Id: mmath.c,v 1.3 1997/07/24 01:23:16 brianp Exp $ */
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
!   25	 * $Log: mmath.c,v $
!   26	 * Revision 1.3  1997/07/24 01:23:16  brianp
!   27	 * changed precompiled header symbol from PCH to PC_HEADER
!   28	 *
!   29	 * Revision 1.2  1997/05/28 03:25:43  brianp
!   30	 * added precompiled header (PCH) support
!   31	 *
!   32	 * Revision 1.1  1997/05/01 01:41:54  brianp
!   33	 * Initial revision
!   34	 *
!   35	 */
!   36	
!   38	#ifdef PC_HEADER
!   39	#include "all.h"
!   40	#else
!   41	#include "GL/gl.h"
!   42	#include "mmath.h"
!   43	#endif
!   44	
!   47	/*
!   48	 * A High Speed, Low Precision Square Root
!   49	 * by Paul Lalonde and Robert Dawson
!   50	 * from "Graphics Gems", Academic Press, 1990
!   51	 */
!   52	
!   53	/*
!   54	 * SPARC implementation of a fast square root by table 
!   55	 * lookup.
!   56	 * SPARC floating point format is as follows:
!   57	 *
!   58	 * BIT 31 	30 	23 	22 	0
!   59	 *     sign	exponent	mantissa
!   60	 */
!   61	static short sqrttab[0x100];    /* declare table of square roots */
!   62	
!   63	static void init_sqrt(void)
!   64	{
!   65	#ifdef FAST_MATH
!   66	   unsigned short i;
!   67	   float f;
!   68	   unsigned int *fi = (unsigned int *)&f;
!   69	                                /* to access the bits of a float in  */
!   70	                                /* C quickly we must misuse pointers */
!   71	
!   72	   for(i=0; i<= 0x7f; i++) {
!   73	      *fi = 0;
!   74	
!   75	      /*
!   76	       * Build a float with the bit pattern i as mantissa
!   77	       * and an exponent of 0, stored as 127
!   78	       */
!   79	
!   80	      *fi = (i << 16) | (127 << 23);
!   81	      f = sqrt(f);
!   82	
!   83	      /*
!   84	       * Take the square root then strip the first 7 bits of
!   85	       * the mantissa into the table
!   86	       */
!   87	
!   88	      sqrttab[i] = (*fi & 0x7fffff) >> 16;
!   89	
!   90	      /*
!   91	       * Repeat the process, this time with an exponent of
!   92	       * 1, stored as 128
!   93	       */
!   94	
!   95	      *fi = 0;
!   96	      *fi = (i << 16) | (128 << 23);
!   97	      f = sqrt(f);
!   98	      sqrttab[i+0x80] = (*fi & 0x7fffff) >> 16;
!   99	   }
!  100	#endif /*FAST_MATH*/
!  101	}
!  102	
!  104	float gl_sqrt( float x )
!  105	{
!  106	#ifdef FAST_MATH
!  107	   unsigned int *num = (unsigned int *)&x;
!  108	                                /* to access the bits of a float in C
!  109	                                 * we must misuse pointers */
!  110	                                                        
!  111	   short e;                     /* the exponent */
!  112	   if (x == 0.0F) return 0.0F;  /* check for square root of 0 */
!  113	   e = (*num >> 23) - 127;      /* get the exponent - on a SPARC the */
!  114	                                /* exponent is stored with 127 added */
!  115	   *num &= 0x7fffff;            /* leave only the mantissa */
!  116	   if (e & 0x01) *num |= 0x800000;
!  117	                                /* the exponent is odd so we have to */
!  118	                                /* look it up in the second half of  */
!  119	                                /* the lookup table, so we set the   */
!  120	                                /* high bit                                */
!  121	   e >>= 1;                     /* divide the exponent by two */
!  122	                                /* note that in C the shift */
!  123	                                /* operators are sign preserving */
!  124	                                /* for signed operands */
!  125	   /* Do the table lookup, based on the quaternary mantissa,
!  126	    * then reconstruct the result back into a float
!  127	    */
!  128	   *num = ((sqrttab[*num >> 16]) << 16) | ((e + 127) << 23);
!  129	   return x;
!  130	#else
!  131	   return sqrt(x);

	ld	[%fp+68],%f4
	fstod	%f4,%f4
	std	%f4,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o0
	or	%g0,%g1,%o1
	call	sqrt
	nop
	fdtos	%f0,%f4
	ba	.L19
	st	%f4,[%fp-4]

	! block 3

	! block 4
.L24:
.L25:
.L19:
	ld	[%fp-4],%f4
	fmovs	%f4,%f0
	jmp	%i7+8
	restore
	.size	gl_sqrt,(.-gl_sqrt)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_init_math
	.type	gl_init_math,#function
gl_init_math:
	save	%sp,-96,%sp

	! block 1
.L28:
.L29:
.L32:
.L34:

! File mmath.c:
!  132	#endif
!  133	}
!  134	
!  137	/*
!  138	 * Initialize tables, etc for fast math functions.
!  139	 */
!  140	void gl_init_math(void)
!  141	{
!  142	   static GLboolean initialized = GL_FALSE;
!  143	
!  144	   if (!initialized) {

	sethi	%hi($XBa59JCSsd3Lm9K.gl_init_math.initialized),%l0
	ldub	[%l0+%lo($XBa59JCSsd3Lm9K.gl_init_math.initialized)],%l0
	cmp	%l0,%g0
	bne	.L33
	nop

	! block 2
.L35:
.L36:
.L37:
.L38:

!  145	      init_sqrt();

	call	init_sqrt
	nop

	! block 3
.L39:

!  148	      initialized = GL_TRUE;

	mov	1,%l1
	sethi	%hi($XBa59JCSsd3Lm9K.gl_init_math.initialized),%l0
	stb	%l1,[%l0+%lo($XBa59JCSsd3Lm9K.gl_init_math.initialized)]

	! block 4
.L40:
.L41:
.L33:
.L42:

	! block 5
.L43:
.L44:
.L27:
	jmp	%i7+8
	restore
	.size	gl_init_math,(.-gl_init_math)
	.align	8

	.section	".data",#alloc,#write
Ddata.data:
	.global	$XBa59JCSsd3Lm9K.gl_init_math.initialized
$XBa59JCSsd3Lm9K.gl_init_math.initialized:
	.skip	1
	.type	$XBa59JCSsd3Lm9K.gl_init_math.initialized,#object
	.size	$XBa59JCSsd3Lm9K.gl_init_math.initialized,1

	.section	".bss",#alloc,#write
	.align	2
Bbss.bss:
	.global	$XAa59JCSsd3Lm9K.sqrttab
$XAa59JCSsd3Lm9K.sqrttab:
	.skip	512
	.type	$XAa59JCSsd3Lm9K.sqrttab,#object
	.size	$XAa59JCSsd3Lm9K.sqrttab,512
	.section	".rodata",#alloc
Drodata.rodata:

	.file	"mmath.c"
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
!   reloc[2]: knd=0, off=271, siz=4, lab1=init_sqrt, lab2=, loff=0
!   reloc[3]: knd=0, off=275, siz=4, lab1=.L17, lab2=, loff=0
!   reloc[4]: knd=0, off=296, siz=4, lab1=gl_sqrt, lab2=, loff=0
!   reloc[5]: knd=0, off=300, siz=4, lab1=.L25, lab2=, loff=0
!   reloc[6]: knd=0, off=357, siz=4, lab1=gl_init_math, lab2=, loff=0
!   reloc[7]: knd=0, off=361, siz=4, lab1=.L44, lab2=, loff=0
!   reloc[8]: knd=0, off=395, siz=4, lab1=$XBa59JCSsd3Lm9K.gl_init_math.initialized, lab2=, loff=0
!   reloc[9]: knd=0, off=487, siz=4, lab1=$XAa59JCSsd3Lm9K.sqrttab, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x02,0x08,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "mmath.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  mmath.c -W0,-xp\\$XAa59JCSsd3Lm9K.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCSsd3Lm9K.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "init_sqrt\0"
	.byte 0x03,0x01,0x40
	.uaword init_sqrt
	.uaword .L17
	.byte 0x01,0x6e,0x01,0x01,0x03
	.ascii "gl_sqrt\0"
	.byte 0x01,0x02,0x01,0x69
	.uaword gl_sqrt
	.uaword .L25
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x4a,0x01
	.byte 0x00,0x00,0x01,0x4a,0x04,0x00,0x00,0x01
	.byte 0x4a
	.ascii "x\0"
	.byte 0x01,0x68,0x03,0x91,0xc4,0x00,0x00,0x05
	.ascii "float\0"
	.byte 0x04,0x04,0x06
	.ascii "gl_init_math\0"
	.byte 0x01,0x02,0x01,0x8d
	.uaword gl_init_math
	.uaword .L44
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x01,0x90
	.byte 0x07
	.ascii "initialized\0"
	.byte 0x00,0x00,0x01,0xa1,0x03,0x01,0x8e,0x05
	.byte 0x03
	.uaword $XBa59JCSsd3Lm9K.gl_init_math.initialized
	.byte 0x00,0x05
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x08,0x00,0x00,0x01,0x90
	.ascii "GLboolean\0"
	.byte 0x02,0x05
	.ascii "short\0"
	.byte 0x05,0x02,0x05
	.ascii "long\0"
	.byte 0x05,0x04,0x09,0x00,0x00,0x01,0xb1,0x02
	.byte 0x00,0x00,0x00,0x01,0xd5,0x0a,0x00,0x00
	.byte 0x01,0xba,0x00,0xff,0x00,0x07
	.ascii "sqrttab\0"
	.byte 0x00,0x00,0x01,0xc2,0x03,0x01,0x3d,0x05
	.byte 0x03
	.uaword $XAa59JCSsd3Lm9K.sqrttab
	.byte 0x05
	.ascii "double\0"
	.byte 0x04,0x08,0x0b
	.ascii "sqrt\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0xeb,0x01
	.byte 0x0c,0x00,0x00,0x01,0xeb,0x00,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=106, siz=4, lab1=init_sqrt, lab2=, loff=0
!   reloc[1]: knd=0, off=113, siz=4, lab1=.L16, lab2=, loff=0
!   reloc[2]: knd=0, off=130, siz=4, lab1=gl_sqrt, lab2=, loff=0
!   reloc[3]: knd=0, off=137, siz=4, lab1=.L23, lab2=, loff=0
!   reloc[4]: knd=0, off=149, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[5]: knd=0, off=162, siz=4, lab1=gl_init_math, lab2=, loff=0
!   reloc[6]: knd=0, off=169, siz=4, lab1=.L34, lab2=, loff=0
!   reloc[7]: knd=0, off=181, siz=4, lab1=.L38, lab2=, loff=0
!   reloc[8]: knd=0, off=189, siz=4, lab1=.L39, lab2=, loff=0
!   reloc[9]: knd=0, off=199, siz=4, lab1=.L43, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x00,0xcd,0x00,0x02,0x00,0x00
	.byte 0x00,0x5d,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x6d,0x6d,0x61,0x74,0x68
	.byte 0x2e,0x63,0x00,0x01,0x00,0x00,0x67,0x6c
	.byte 0x2e,0x68,0x00,0x02,0x00,0x00,0x00,0x00
	.byte 0x05,0x02
	.uaword init_sqrt
	.byte 0x00,0x05,0x02
	.uaword .L16
	.byte 0x06,0x03,0xe4,0x00,0x01,0x02,0x01,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword gl_sqrt
	.byte 0x00,0x05,0x02
	.uaword .L23
	.byte 0x06,0x03,0x82,0x01,0x01,0x00,0x05,0x02
	.uaword .L24
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_init_math
	.byte 0x00,0x05,0x02
	.uaword .L34
	.byte 0x06,0x03,0x8f,0x01,0x01,0x00,0x05,0x02
	.uaword .L38
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L39
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L43
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x00,0x00,0x05,0x24,0x00,0x03,0x08,0x3e
	.byte 0x0b,0x0b,0x0b,0x00,0x00,0x06,0x2e,0x01
	.byte 0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x11,0x01,0x12,0x01,0x40,0x0a
	.byte 0x27,0x0c,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x07,0x34,0x00,0x03,0x08,0x49,0x13
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a
	.byte 0x00,0x00,0x08,0x16,0x00,0x49,0x13,0x03
	.byte 0x08,0x3a,0x0b,0x00,0x00,0x09,0x01,0x01
	.byte 0x49,0x13,0x0b,0x05,0x01,0x13,0x00,0x00
	.byte 0x0a,0x21,0x00,0x49,0x13,0x2f,0x05,0x00
	.byte 0x00,0x0b,0x2e,0x01,0x03,0x08,0x3f,0x0c
	.byte 0x3c,0x0c,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x00,0x00,0x0c,0x05,0x00,0x49,0x13
	.byte 0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x2c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0x1b
	.byte 0x67,0x6c,0x5f,0x73,0x71,0x72,0x74,0x00
	.byte 0x00,0x00,0x01,0x53,0x67,0x6c,0x5f,0x69
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
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0x01
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
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0xa1
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
	.byte 0x00,0x00,0x02,0x0c,0x00,0x00,0x01,0x75
	.byte 0x69,0x6e,0x69,0x74,0x69,0x61,0x6c,0x69
	.byte 0x7a,0x65,0x64,0x00,0x00,0x00,0x01,0xd5
	.byte 0x73,0x71,0x72,0x74,0x74,0x61,0x62,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
