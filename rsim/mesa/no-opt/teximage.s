
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0
	.type	logbase2,#function
logbase2:
	save	%sp,-112,%sp

	! block 1
.L13:
	st	%i0,[%fp+68]

	! block 2
.L14:
.L16:

! File teximage.c:
!    1	/* $Id: teximage.c,v 1.31 1997/11/07 03:38:07 brianp Exp $ */
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
!   25	 * $Log: teximage.c,v $
!   26	 * Revision 1.31  1997/11/07 03:38:07  brianp
!   27	 * added stdio.h include for SunOS 4.x
!   28	 *
!   29	 * Revision 1.30  1997/11/02 20:20:30  brianp
!   30	 * rewrote gl_TexSubImage[123]D()
!   31	 *
!   32	 * Revision 1.29  1997/10/16 01:14:04  brianp
!   33	 * removed teximage Dirty flag
!   34	 *
!   35	 * Revision 1.28  1997/10/14 00:40:20  brianp
!   36	 * added DavidB's v19 fxmesa changes
!   37	 *
!   38	 * Revision 1.27  1997/09/29 23:28:14  brianp
!   39	 * updated for new device driver texture functions
!   40	 *
!   41	 * Revision 1.26  1997/09/28 15:29:03  brianp
!   42	 * initialize image->Depth = 1 in read_color_image() (Hiroki Honda)
!   43	 *
!   44	 * Revision 1.25  1997/09/27 00:14:39  brianp
!   45	 * added GL_EXT_paletted_texture extension
!   46	 *
!   47	 * Revision 1.24  1997/09/03 13:17:17  brianp
!   48	 * added a few pointer casts
!   49	 *
!   50	 * Revision 1.23  1997/08/23 18:40:46  brianp
!   51	 * glTexImage[123]D() with NULL image pointer is correctly handled now
!   52	 *
!   53	 * Revision 1.22  1997/08/11 01:23:29  brianp
!   54	 * added a few pointer casts
!   55	 *
!   56	 * Revision 1.21  1997/07/24 01:25:34  brianp
!   57	 * changed precompiled header symbol from PCH to PC_HEADER
!   58	 *
!   59	 * Revision 1.20  1997/07/05 16:21:17  brianp
!   60	 * fixed unitialized variable bug in gl_TexSubImage1D()
!   61	 *
!   62	 * Revision 1.19  1997/06/24 01:13:53  brianp
!   63	 * call gl_free_image() in gl_TexSubImage[123]D() if ref count==0
!   64	 *
!   65	 * Revision 1.18  1997/06/04 00:33:14  brianp
!   66	 * fixed reference count bug in gl_CopyTexImage1/2D() (Randy Frank)
!   67	 *
!   68	 * Revision 1.17  1997/05/28 03:26:49  brianp
!   69	 * added precompiled header (PCH) support
!   70	 *
!   71	 * Revision 1.16  1997/05/03 00:52:19  brianp
!   72	 * set texture object Dirty flag when changing texture image
!   73	 *
!   74	 * Revision 1.15  1997/04/20 20:29:11  brianp
!   75	 * replaced abort() with gl_problem()
!   76	 *
!   77	 * Revision 1.14  1997/03/04 19:18:29  brianp
!   78	 * added texture image Width2, Height2, and Depth2 fields
!   79	 *
!   80	 * Revision 1.13  1997/02/27 19:58:08  brianp
!   81	 * call gl_problem() instead of gl_warning()
!   82	 *
!   83	 * Revision 1.12  1997/02/09 18:53:05  brianp
!   84	 * added GL_EXT_texture3D support
!   85	 *
!   86	 * Revision 1.11  1997/01/16 03:35:10  brianp
!   87	 * added calls to device driver TexImage() function
!   88	 *
!   89	 * Revision 1.10  1997/01/09 21:26:46  brianp
!   90	 * gl_TexImage[12]D() didn't free the incoming image- a memory leak
!   91	 *
!   92	 * Revision 1.9  1997/01/09 19:55:52  brianp
!   93	 * fixed a few error messages
!   94	 *
!   95	 * Revision 1.8  1997/01/09 19:49:18  brianp
!   96	 * better error checking
!   97	 *
!   98	 * Revision 1.7  1996/12/02 18:59:54  brianp
!   99	 * added code to handle GL_COLOR_INDEX textures, per Randy Frank
!  100	 *
!  101	 * Revision 1.6  1996/11/07 04:13:24  brianp
!  102	 * all new texture image handling, now pixel scale, bias, mapping work
!  103	 *
!  104	 * Revision 1.5  1996/09/27 01:29:57  brianp
!  105	 * removed unused variables, fixed cut&paste bug in color scaling
!  106	 *
!  107	 * Revision 1.4  1996/09/26 22:35:10  brianp
!  108	 * fixed a few compiler warnings from IRIX 6 -n32 and -64 compiler
!  109	 *
!  110	 * Revision 1.3  1996/09/15 14:18:55  brianp
!  111	 * now use GLframebuffer and GLvisual
!  112	 *
!  113	 * Revision 1.2  1996/09/15 01:48:58  brianp
!  114	 * removed #define NULL 0
!  115	 *
!  116	 * Revision 1.1  1996/09/13 01:38:16  brianp
!  117	 * Initial revision
!  118	 *
!  119	 */
!  120	
!  122	#ifdef PC_HEADER
!  123	#include "all.h"
!  124	#else
!  125	#include <assert.h>
!  126	#include <stdio.h>
!  127	#include <stdlib.h>
!  128	#include <string.h>
!  129	#include "context.h"
!  130	#include "image.h"
!  131	#include "macros.h"
!  132	#include "pixel.h"
!  133	#include "span.h"
!  134	#include "teximage.h"
!  135	#include "types.h"
!  136	#endif
!  137	
!  139	/*
!  140	 * NOTES:
!  141	 *
!  142	 * The internal texture storage convension is an array of N GLubytes
!  143	 * where N = width * height * components.  There is no padding.
!  144	 */
!  145	
!  149	/*
!  150	 * Compute log base 2 of n.
!  151	 * If n isn't an exact power of two return -1.
!  152	 * If n<0 return -1.
!  153	 */
!  154	static int logbase2( int n )
!  155	{
!  156	   GLint i = 1;

	mov	1,%l0
	st	%l0,[%fp-8]

	! block 3
.L17:

!  157	   GLint log2 = 0;

	st	%g0,[%fp-12]

	! block 4
.L18:
.L20:

!  159	   if (n<0) {

	ld	[%fp+68],%l0
	cmp	%l0,0
	bge	.L19
	nop

	! block 5
.L21:
.L22:
.L23:
.L24:

!  160	      return -1;

	mov	-1,%l0
	ba	.L12
	st	%l0,[%fp-4]

	! block 6
.L25:
.L26:
.L19:
.L27:
.L28:
.L32:

!  161	   }
!  162	
!  163	   while ( n > i ) {

	ld	[%fp+68],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	ble	.L31
	nop

	! block 7
.L33:
.L29:
.L34:
.L35:
.L36:

!  164	      i *= 2;

	ld	[%fp-8],%l0
	sll	%l0,1,%l0
	st	%l0,[%fp-8]

	! block 8
.L37:

!  165	      log2++;

	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 9
.L38:
.L39:
.L40:
	ld	[%fp+68],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	bg	.L29
	nop

	! block 10
.L41:
.L31:
.L42:
.L43:
.L45:

!  166	   }
!  167	   if (i != n) {

	ld	[%fp-8],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	be	.L44
	nop

	! block 11
.L46:
.L47:
.L48:
.L49:

!  168	      return -1;

	mov	-1,%l0
	ba	.L12
	st	%l0,[%fp-4]

	! block 12
.L50:
.L51:
.L44:
.L52:
.L53:
.L54:

!  169	   }
!  170	   else {
!  171	      return log2;

	ld	[%fp-12],%l0
	ba	.L12
	st	%l0,[%fp-4]

	! block 13
.L55:
.L56:
.L57:

	! block 14
.L58:
.L59:
.L12:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	logbase2,(.-logbase2)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	decode_internal_format,#function
decode_internal_format:
	save	%sp,-104,%sp

	! block 1
.L62:
	st	%i0,[%fp+68]

	! block 2
.L63:
.L65:
.L68:

! File teximage.c:
!  172	   }
!  173	}
!  174	
!  177	/*
!  178	 * Given an internal texture format enum or 1, 2, 3, 4 return the
!  179	 * corresponding _base_ internal format:  GL_ALPHA, GL_LUMINANCE,
!  180	 * GL_LUMANCE_ALPHA, GL_INTENSITY, GL_RGB, or GL_RGBA.  Return -1 if
!  181	 * invalid enum.
!  182	 */
!  183	static GLint decode_internal_format( GLint format )
!  184	{
!  185	   switch (format) {

	ba	.L67
	nop

	! block 3
.L69:
.L70:
.L71:
.L72:
.L73:
.L74:
.L75:
.L76:

!  186	      case GL_ALPHA:
!  187	      case GL_ALPHA4:
!  188	      case GL_ALPHA8:
!  189	      case GL_ALPHA12:
!  190	      case GL_ALPHA16:
!  191	         return GL_ALPHA;

	sethi	%hi(0x1906),%l0
	or	%l0,%lo(0x1906),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 4
.L77:
.L78:
.L79:
.L80:
.L81:
.L82:
.L83:

!  192	      case 1:
!  193	      case GL_LUMINANCE:
!  194	      case GL_LUMINANCE4:
!  195	      case GL_LUMINANCE8:
!  196	      case GL_LUMINANCE12:
!  197	      case GL_LUMINANCE16:
!  198	         return GL_LUMINANCE;

	sethi	%hi(0x1909),%l0
	or	%l0,%lo(0x1909),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 5
.L84:
.L85:
.L86:
.L87:
.L88:
.L89:
.L90:
.L91:
.L92:

!  199	      case 2:
!  200	      case GL_LUMINANCE_ALPHA:
!  201	      case GL_LUMINANCE4_ALPHA4:
!  202	      case GL_LUMINANCE6_ALPHA2:
!  203	      case GL_LUMINANCE8_ALPHA8:
!  204	      case GL_LUMINANCE12_ALPHA4:
!  205	      case GL_LUMINANCE12_ALPHA12:
!  206	      case GL_LUMINANCE16_ALPHA16:
!  207	         return GL_LUMINANCE_ALPHA;

	sethi	%hi(0x190a),%l0
	or	%l0,%lo(0x190a),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 6
.L93:
.L94:
.L95:
.L96:
.L97:
.L98:

!  208	      case GL_INTENSITY:
!  209	      case GL_INTENSITY4:
!  210	      case GL_INTENSITY8:
!  211	      case GL_INTENSITY12:
!  212	      case GL_INTENSITY16:
!  213	         return GL_INTENSITY;

	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 7
.L99:
.L100:
.L101:
.L102:
.L103:
.L104:
.L105:
.L106:
.L107:
.L108:

!  214	      case 3:
!  215	      case GL_RGB:
!  216	      case GL_R3_G3_B2:
!  217	      case GL_RGB4:
!  218	      case GL_RGB5:
!  219	      case GL_RGB8:
!  220	      case GL_RGB10:
!  221	      case GL_RGB12:
!  222	      case GL_RGB16:
!  223	         return GL_RGB;

	sethi	%hi(0x1907),%l0
	or	%l0,%lo(0x1907),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 8
.L109:
.L110:
.L111:
.L112:
.L113:
.L114:
.L115:
.L116:
.L117:
.L118:

!  224	      case 4:
!  225	      case GL_RGBA:
!  226	      case GL_RGBA2:
!  227	      case GL_RGBA4:
!  228	      case GL_RGB5_A1:
!  229	      case GL_RGBA8:
!  230	      case GL_RGB10_A2:
!  231	      case GL_RGBA12:
!  232	      case GL_RGBA16:
!  233	         return GL_RGBA;

	sethi	%hi(0x1908),%l0
	or	%l0,%lo(0x1908),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 9
.L119:
.L120:
.L121:
.L122:
.L123:
.L124:
.L125:

!  234	      case GL_COLOR_INDEX1_EXT:
!  235	      case GL_COLOR_INDEX2_EXT:
!  236	      case GL_COLOR_INDEX4_EXT:
!  237	      case GL_COLOR_INDEX8_EXT:
!  238	      case GL_COLOR_INDEX12_EXT:
!  239	      case GL_COLOR_INDEX16_EXT:
!  240	         return GL_COLOR_INDEX;

	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 10
.L126:
.L127:

!  241	      default:
!  242	         return -1;  /* error */

	mov	-1,%l0
	ba	.L61
	st	%l0,[%fp-4]

	! block 11
.L128:
.L129:
.L67:
.L130:
	ld	[%fp+68],%l2
	sethi	%hi(0x804f),%l0
	or	%l0,%lo(0x804f),%l0
	cmp	%l2,%l0
	bge	.L_y0
	nop

	! block 12
	sethi	%hi(0x803b),%l0
	or	%l0,%lo(0x803b),%l0
	cmp	%l2,%l0
	bge	.L_y1
	nop

	! block 13
	sethi	%hi(0x1906),%l0
	or	%l0,%lo(0x1906),%l0
	cmp	%l2,%l0
	bge	.L_y2
	nop

	! block 14
	sub	%l2,1,%l0
	cmp	%l0,3
	bgu	.L126
	nop

	! block 15
	sll	%l0,2,%l1
	sethi	%hi(.L_y3-16),%l0
	or	%l0,%lo(.L_y3-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 16
.L_y2:
	sethi	%hi(0x2a10),%l0
	or	%l0,%lo(0x2a10),%l0
	cmp	%l2,%l0
	bge	.L_y4
	nop

	! block 17
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L126
	nop

	! block 18
	sll	%l0,2,%l1
	sethi	%hi(.L_y5-20),%l0
	or	%l0,%lo(.L_y5-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 19
.L_y4:
	sethi	%hi(0x2a10),%l0
	or	%l0,%lo(0x2a10),%l0
	cmp	%l2,%l0
	be	.L101
	nop

	! block 20
	ba	.L126
	nop

	! block 21
.L_y1:
	sethi	%hi(0x803b),%l1
	or	%l1,%lo(0x803b),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,18
	bgu	.L126
	nop

	! block 22
	sll	%l0,2,%l1
	sethi	%hi(.L_y6-76),%l0
	or	%l0,%lo(.L_y6-76),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 23
.L_y0:
	sethi	%hi(0x80e2),%l0
	or	%l0,%lo(0x80e2),%l0
	cmp	%l2,%l0
	bge	.L_y7
	nop

	! block 24
	sethi	%hi(0x804f),%l1
	or	%l1,%lo(0x804f),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,12
	bgu	.L126
	nop

	! block 25
	sll	%l0,2,%l1
	sethi	%hi(.L_y8-52),%l0
	or	%l0,%lo(.L_y8-52),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 26
.L_y7:
	sethi	%hi(0x80e2),%l1
	or	%l1,%lo(0x80e2),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L126
	nop

	! block 27
	sll	%l0,2,%l1
	sethi	%hi(.L_y9-24),%l0
	or	%l0,%lo(.L_y9-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 28
.L131:
.L132:

	! block 29
.L133:
.L134:
.L61:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	decode_internal_format,(.-decode_internal_format)

	.word	.L77
	.word	.L84
	.word	.L99
	.word	.L109
.L_y3:
	.word	.L71
	.word	.L100
	.word	.L110
	.word	.L78
	.word	.L85
.L_y5:
	.word	.L72
	.word	.L73
	.word	.L74
	.word	.L75
	.word	.L79
	.word	.L80
	.word	.L81
	.word	.L82
	.word	.L86
	.word	.L87
	.word	.L88
	.word	.L89
	.word	.L90
	.word	.L91
	.word	.L93
	.word	.L94
	.word	.L95
	.word	.L96
	.word	.L97
.L_y6:
	.word	.L102
	.word	.L103
	.word	.L104
	.word	.L105
	.word	.L106
	.word	.L107
	.word	.L111
	.word	.L112
	.word	.L113
	.word	.L114
	.word	.L115
	.word	.L116
	.word	.L117
.L_y8:
	.word	.L119
	.word	.L120
	.word	.L121
	.word	.L122
	.word	.L123
	.word	.L124
.L_y9:
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	components_in_intformat,#function
components_in_intformat:
	save	%sp,-104,%sp

	! block 1
.L137:
	st	%i0,[%fp+68]

	! block 2
.L138:
.L140:
.L143:

! File teximage.c:
!  243	   }
!  244	}
!  245	
!  248	/*
!  249	 * Given an internal texture format enum or 1, 2, 3, 4 return the
!  250	 * corresponding _base_ internal format:  GL_ALPHA, GL_LUMINANCE,
!  251	 * GL_LUMANCE_ALPHA, GL_INTENSITY, GL_RGB, or GL_RGBA.  Return the
!  252	 * number of components for the format.  Return -1 if invalid enum.
!  253	 */
!  254	static GLint components_in_intformat( GLint format )
!  255	{
!  256	   switch (format) {

	ba	.L142
	nop

	! block 3
.L144:
.L145:
.L146:
.L147:
.L148:
.L149:
.L150:
.L151:

!  257	      case GL_ALPHA:
!  258	      case GL_ALPHA4:
!  259	      case GL_ALPHA8:
!  260	      case GL_ALPHA12:
!  261	      case GL_ALPHA16:
!  262	         return 1;

	mov	1,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 4
.L152:
.L153:
.L154:
.L155:
.L156:
.L157:
.L158:

!  263	      case 1:
!  264	      case GL_LUMINANCE:
!  265	      case GL_LUMINANCE4:
!  266	      case GL_LUMINANCE8:
!  267	      case GL_LUMINANCE12:
!  268	      case GL_LUMINANCE16:
!  269	         return 1;

	mov	1,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 5
.L159:
.L160:
.L161:
.L162:
.L163:
.L164:
.L165:
.L166:
.L167:

!  270	      case 2:
!  271	      case GL_LUMINANCE_ALPHA:
!  272	      case GL_LUMINANCE4_ALPHA4:
!  273	      case GL_LUMINANCE6_ALPHA2:
!  274	      case GL_LUMINANCE8_ALPHA8:
!  275	      case GL_LUMINANCE12_ALPHA4:
!  276	      case GL_LUMINANCE12_ALPHA12:
!  277	      case GL_LUMINANCE16_ALPHA16:
!  278	         return 2;

	mov	2,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 6
.L168:
.L169:
.L170:
.L171:
.L172:
.L173:

!  279	      case GL_INTENSITY:
!  280	      case GL_INTENSITY4:
!  281	      case GL_INTENSITY8:
!  282	      case GL_INTENSITY12:
!  283	      case GL_INTENSITY16:
!  284	         return 1;

	mov	1,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 7
.L174:
.L175:
.L176:
.L177:
.L178:
.L179:
.L180:
.L181:
.L182:
.L183:

!  285	      case 3:
!  286	      case GL_RGB:
!  287	      case GL_R3_G3_B2:
!  288	      case GL_RGB4:
!  289	      case GL_RGB5:
!  290	      case GL_RGB8:
!  291	      case GL_RGB10:
!  292	      case GL_RGB12:
!  293	      case GL_RGB16:
!  294	         return 3;

	mov	3,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 8
.L184:
.L185:
.L186:
.L187:
.L188:
.L189:
.L190:
.L191:
.L192:
.L193:

!  295	      case 4:
!  296	      case GL_RGBA:
!  297	      case GL_RGBA2:
!  298	      case GL_RGBA4:
!  299	      case GL_RGB5_A1:
!  300	      case GL_RGBA8:
!  301	      case GL_RGB10_A2:
!  302	      case GL_RGBA12:
!  303	      case GL_RGBA16:
!  304	         return 4;

	mov	4,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 9
.L194:
.L195:
.L196:
.L197:
.L198:
.L199:
.L200:

!  305	      case GL_COLOR_INDEX1_EXT:
!  306	      case GL_COLOR_INDEX2_EXT:
!  307	      case GL_COLOR_INDEX4_EXT:
!  308	      case GL_COLOR_INDEX8_EXT:
!  309	      case GL_COLOR_INDEX12_EXT:
!  310	      case GL_COLOR_INDEX16_EXT:
!  311	         return 1;

	mov	1,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 10
.L201:
.L202:

!  312	      default:
!  313	         return -1;  /* error */

	mov	-1,%l0
	ba	.L136
	st	%l0,[%fp-4]

	! block 11
.L203:
.L204:
.L142:
.L205:
	ld	[%fp+68],%l2
	sethi	%hi(0x804f),%l0
	or	%l0,%lo(0x804f),%l0
	cmp	%l2,%l0
	bge	.L_y10
	nop

	! block 12
	sethi	%hi(0x803b),%l0
	or	%l0,%lo(0x803b),%l0
	cmp	%l2,%l0
	bge	.L_y11
	nop

	! block 13
	sethi	%hi(0x1906),%l0
	or	%l0,%lo(0x1906),%l0
	cmp	%l2,%l0
	bge	.L_y12
	nop

	! block 14
	sub	%l2,1,%l0
	cmp	%l0,3
	bgu	.L201
	nop

	! block 15
	sll	%l0,2,%l1
	sethi	%hi(.L_y13-16),%l0
	or	%l0,%lo(.L_y13-16),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 16
.L_y12:
	sethi	%hi(0x2a10),%l0
	or	%l0,%lo(0x2a10),%l0
	cmp	%l2,%l0
	bge	.L_y14
	nop

	! block 17
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L201
	nop

	! block 18
	sll	%l0,2,%l1
	sethi	%hi(.L_y15-20),%l0
	or	%l0,%lo(.L_y15-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 19
.L_y14:
	sethi	%hi(0x2a10),%l0
	or	%l0,%lo(0x2a10),%l0
	cmp	%l2,%l0
	be	.L176
	nop

	! block 20
	ba	.L201
	nop

	! block 21
.L_y11:
	sethi	%hi(0x803b),%l1
	or	%l1,%lo(0x803b),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,18
	bgu	.L201
	nop

	! block 22
	sll	%l0,2,%l1
	sethi	%hi(.L_y16-76),%l0
	or	%l0,%lo(.L_y16-76),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 23
.L_y10:
	sethi	%hi(0x80e2),%l0
	or	%l0,%lo(0x80e2),%l0
	cmp	%l2,%l0
	bge	.L_y17
	nop

	! block 24
	sethi	%hi(0x804f),%l1
	or	%l1,%lo(0x804f),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,12
	bgu	.L201
	nop

	! block 25
	sll	%l0,2,%l1
	sethi	%hi(.L_y18-52),%l0
	or	%l0,%lo(.L_y18-52),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 26
.L_y17:
	sethi	%hi(0x80e2),%l1
	or	%l1,%lo(0x80e2),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,5
	bgu	.L201
	nop

	! block 27
	sll	%l0,2,%l1
	sethi	%hi(.L_y19-24),%l0
	or	%l0,%lo(.L_y19-24),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 28
.L206:
.L207:

	! block 29
.L208:
.L209:
.L136:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	components_in_intformat,(.-components_in_intformat)

	.word	.L152
	.word	.L159
	.word	.L174
	.word	.L184
.L_y13:
	.word	.L146
	.word	.L175
	.word	.L185
	.word	.L153
	.word	.L160
.L_y15:
	.word	.L147
	.word	.L148
	.word	.L149
	.word	.L150
	.word	.L154
	.word	.L155
	.word	.L156
	.word	.L157
	.word	.L161
	.word	.L162
	.word	.L163
	.word	.L164
	.word	.L165
	.word	.L166
	.word	.L168
	.word	.L169
	.word	.L170
	.word	.L171
	.word	.L172
.L_y16:
	.word	.L177
	.word	.L178
	.word	.L179
	.word	.L180
	.word	.L181
	.word	.L182
	.word	.L186
	.word	.L187
	.word	.L188
	.word	.L189
	.word	.L190
	.word	.L191
	.word	.L192
.L_y18:
	.word	.L194
	.word	.L195
	.word	.L196
	.word	.L197
	.word	.L198
	.word	.L199
.L_y19:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_alloc_texture_image
	.type	gl_alloc_texture_image,#function
gl_alloc_texture_image:
	save	%sp,-104,%sp

	! block 1
.L212:
.L213:
.L215:

! File teximage.c:
!  314	   }
!  315	}
!  316	
!  319	struct gl_texture_image *gl_alloc_texture_image( void )
!  320	{
!  321	   return (struct gl_texture_image *) calloc( 1, sizeof(struct gl_texture_image) );

	mov	1,%o0
	call	calloc
	mov	60,%o1
	ba	.L211
	st	%o0,[%fp-4]

	! block 2

	! block 3
.L216:
.L217:
.L211:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_alloc_texture_image,(.-gl_alloc_texture_image)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_free_texture_image
	.type	gl_free_texture_image,#function
gl_free_texture_image:
	save	%sp,-96,%sp

	! block 1
.L220:
	st	%i0,[%fp+68]

	! block 2
.L221:
.L223:
.L225:

! File teximage.c:
!  322	}
!  323	
!  326	void gl_free_texture_image( struct gl_texture_image *teximage )
!  327	{
!  328	   if (teximage->Data) {

	ld	[%fp+68],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	be	.L224
	nop

	! block 3
.L226:
.L227:
.L228:
.L229:

!  329	      free( teximage->Data );

	ld	[%fp+68],%l0
	ld	[%l0+52],%l0
	call	free
	mov	%l0,%o0

	! block 4
.L230:
.L231:
.L224:
.L232:
.L233:

!  330	   }
!  331	   free( teximage );

	ld	[%fp+68],%l0
	call	free
	mov	%l0,%o0

	! block 5
.L234:
.L235:
.L219:
	jmp	%i7+8
	restore
	.size	gl_free_texture_image,(.-gl_free_texture_image)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	image_to_texture,#function
image_to_texture:
	save	%sp,-224,%sp

	! block 1
.L238:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L239:
.L241:

! File teximage.c:
!  332	}
!  333	
!  336	/*
!  337	 * Given a gl_image, apply the pixel transfer scale, bias, and mapping
!  338	 * to produce a gl_texture_image.  Convert image data to GLubytes.
!  339	 * Input:  image - the incoming gl_image
!  340	 *         internalFormat - desired format of resultant texture
!  341	 *         border - texture border width (0 or 1)
!  342	 * Return:  pointer to a gl_texture_image or NULL if an error occurs.
!  343	 */
!  344	static struct gl_texture_image *
!  345	image_to_texture( GLcontext *ctx, const struct gl_image *image,
!  346	                  GLenum internalFormat, GLint border )
!  347	{
!  348	   GLint components;
!  349	   struct gl_texture_image *texImage;
!  350	   GLint numPixels, pixel;
!  351	   GLboolean scaleOrBias;
!  352	
!  353	   assert(image);

	ld	[%fp+72],%l0
	cmp	%l0,%g0
	bne	.L243
	nop

	! block 3
.L244:
	sethi	%hi(.L245),%l0
	or	%l0,%lo(.L245),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	353,%o2
	ba	.L242
	nop

	! block 4
.L243:
	mov	1,%l0
	ba	.L247
	st	%l0,[%fp-28]

	! block 5
.L242:
	st	%g0,[%fp-28]

	! block 6
.L247:
.L248:

!  354	   assert(image->Width>0);

	ld	[%fp+72],%l0
	ld	[%l0+0],%l0
	cmp	%l0,0
	bg	.L250
	nop

	! block 7
.L251:
	sethi	%hi(.L252),%l0
	or	%l0,%lo(.L252),%l0
	add	%l0,16,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	354,%o2
	ba	.L249
	nop

	! block 8
.L250:
	mov	1,%l0
	ba	.L254
	st	%l0,[%fp-32]

	! block 9
.L249:
	st	%g0,[%fp-32]

	! block 10
.L254:
.L255:

!  355	   assert(image->Height>0);

	ld	[%fp+72],%l0
	ld	[%l0+4],%l0
	cmp	%l0,0
	bg	.L257
	nop

	! block 11
.L258:
	sethi	%hi(.L259),%l0
	or	%l0,%lo(.L259),%l0
	add	%l0,16,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	355,%o2
	ba	.L256
	nop

	! block 12
.L257:
	mov	1,%l0
	ba	.L261
	st	%l0,[%fp-36]

	! block 13
.L256:
	st	%g0,[%fp-36]

	! block 14
.L261:
.L262:

!  356	   assert(image->Depth>0);

	ld	[%fp+72],%l0
	ld	[%l0+8],%l0
	cmp	%l0,0
	bg	.L264
	nop

	! block 15
.L265:
	sethi	%hi(.L266),%l0
	or	%l0,%lo(.L266),%l0
	add	%l0,16,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	356,%o2
	ba	.L263
	nop

	! block 16
.L264:
	mov	1,%l0
	ba	.L268
	st	%l0,[%fp-40]

	! block 17
.L263:
	st	%g0,[%fp-40]

	! block 18
.L268:
.L269:

!  358	   /*   internalFormat = decode_internal_format(internalFormat);*/
!  359	   components = components_in_intformat(internalFormat);

	ld	[%fp+76],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 19
.L270:

!  360	   numPixels = image->Width * image->Height * image->Depth;

	ld	[%fp+72],%l0
	ld	[%l0+0],%l2
	ld	[%l0+4],%l1
	smul	%l2,%l1,%l2
	ld	[%l0+8],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-16]

	! block 20
.L271:

!  362	   texImage = gl_alloc_texture_image();

	call	gl_alloc_texture_image
	nop
	st	%o0,[%fp-12]

	! block 21
.L272:
.L274:

!  363	   if (!texImage)

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L273
	nop

	! block 22
.L275:
.L276:
.L277:

!  364	      return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 23
.L278:
.L273:
.L279:
.L280:

!  366	   texImage->Format = decode_internal_format(internalFormat);

	ld	[%fp+76],%l0
	call	decode_internal_format
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+0]

	! block 24
.L281:

!  367	   texImage->IntFormat = internalFormat;

	ld	[%fp+76],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+4]

	! block 25
.L282:

!  368	   texImage->Border = border;

	ld	[%fp+80],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+8]

	! block 26
.L283:

!  369	   texImage->Width = image->Width;

	ld	[%fp+72],%l0
	ld	[%l0+0],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+12]

	! block 27
.L284:

!  370	   texImage->Height = image->Height;

	ld	[%fp+72],%l0
	ld	[%l0+4],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+16]

	! block 28
.L285:

!  371	   texImage->Depth = image->Depth;

	ld	[%fp+72],%l0
	ld	[%l0+8],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+20]

	! block 29
.L286:

!  372	   texImage->WidthLog2 = logbase2(image->Width - 2*border);

	ld	[%fp+72],%l0
	ld	[%l0+0],%l2
	ld	[%fp+80],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+36]

	! block 30
.L287:
.L289:

!  373	   if (image->Height==1)  /* 1-D texture */

	ld	[%fp+72],%l0
	ld	[%l0+4],%l0
	cmp	%l0,1
	bne	.L288
	nop

	! block 31
.L290:
.L291:
.L292:

!  374	      texImage->HeightLog2 = 0;

	ld	[%fp-12],%l0
	st	%g0,[%l0+40]

	! block 32
.L293:
	ba	.L294
	nop

	! block 33
.L288:
.L295:
.L296:

!  375	   else
!  376	      texImage->HeightLog2 = logbase2(image->Height - 2*border);

	ld	[%fp+72],%l0
	ld	[%l0+4],%l2
	ld	[%fp+80],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+40]

	! block 34
.L297:
.L294:
.L298:
.L299:
.L301:

!  377	   if (image->Depth==1)   /* 2-D texture */

	ld	[%fp+72],%l0
	ld	[%l0+8],%l0
	cmp	%l0,1
	bne	.L300
	nop

	! block 35
.L302:
.L303:
.L304:

!  378	      texImage->DepthLog2 = 0;

	ld	[%fp-12],%l0
	st	%g0,[%l0+44]

	! block 36
.L305:
	ba	.L306
	nop

	! block 37
.L300:
.L307:
.L308:

!  379	   else
!  380	      texImage->DepthLog2 = logbase2(image->Depth - 2*border);

	ld	[%fp+72],%l0
	ld	[%l0+8],%l2
	ld	[%fp+80],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+44]

	! block 38
.L309:
.L306:
.L310:
.L311:

!  381	   texImage->Width2 = 1 << texImage->WidthLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+36],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+24]

	! block 39
.L312:

!  382	   texImage->Height2 = 1 << texImage->HeightLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+40],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+28]

	! block 40
.L313:

!  383	   texImage->Depth2 = 1 << texImage->DepthLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+44],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+32]

	! block 41
.L314:

!  384	   texImage->MaxLog2 = MAX2( texImage->WidthLog2, texImage->HeightLog2 );

	ld	[%fp-12],%l0
	ld	[%l0+36],%l1
	ld	[%l0+40],%l0
	cmp	%l1,%l0
	bleu	.L315
	nop

	! block 42
.L316:
	ld	[%fp-12],%l0
	ld	[%l0+36],%l0
	ba	.L317
	st	%l0,[%fp-44]

	! block 43
.L315:
	ld	[%fp-12],%l0
	ld	[%l0+40],%l0
	st	%l0,[%fp-44]

	! block 44
.L317:
	ld	[%fp-44],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+48]

	! block 45
.L318:

!  385	   texImage->Data = (GLubyte *) malloc( numPixels * components );

	ld	[%fp-16],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	call	malloc
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+52]

	! block 46
.L319:

!  387	   assert(texImage->WidthLog2>=0);

	ld	[%fp-12],%l0
	ld	[%l0+36],%l0
	cmp	%l0,0
	bgeu	.L321
	nop

	! block 47
.L322:
	sethi	%hi(.L323),%l0
	or	%l0,%lo(.L323),%l0
	add	%l0,24,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	387,%o2
	ba	.L320
	nop

	! block 48
.L321:
	mov	1,%l0
	ba	.L325
	st	%l0,[%fp-48]

	! block 49
.L320:
	st	%g0,[%fp-48]

	! block 50
.L325:
.L326:

!  388	   assert(texImage->HeightLog2>=0);

	ld	[%fp-12],%l0
	ld	[%l0+40],%l0
	cmp	%l0,0
	bgeu	.L328
	nop

	! block 51
.L329:
	sethi	%hi(.L330),%l0
	or	%l0,%lo(.L330),%l0
	add	%l0,24,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	388,%o2
	ba	.L327
	nop

	! block 52
.L328:
	mov	1,%l0
	ba	.L332
	st	%l0,[%fp-52]

	! block 53
.L327:
	st	%g0,[%fp-52]

	! block 54
.L332:
.L333:

!  389	   assert(texImage->DepthLog2>=0);

	ld	[%fp-12],%l0
	ld	[%l0+44],%l0
	cmp	%l0,0
	bgeu	.L335
	nop

	! block 55
.L336:
	sethi	%hi(.L337),%l0
	or	%l0,%lo(.L337),%l0
	add	%l0,24,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	389,%o2
	ba	.L334
	nop

	! block 56
.L335:
	mov	1,%l0
	ba	.L339
	st	%l0,[%fp-56]

	! block 57
.L334:
	st	%g0,[%fp-56]

	! block 58
.L339:
.L340:
.L342:

!  391	   if (!texImage->Data) {

	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	bne	.L341
	nop

	! block 59
.L343:
.L344:
.L345:
.L346:

!  392	      /* out of memory */
!  393	      gl_free_texture_image( texImage );

	ld	[%fp-12],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 60
.L347:

!  394	      return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 61
.L348:
.L349:
.L341:
.L350:
.L351:
.L353:

!  395	   }
!  396	
!  397	   /* Determine if scaling and/or biasing is needed */
!  398	   if (ctx->Pixel.RedScale!=1.0F   || ctx->Pixel.RedBias!=0.0F ||
!  399	       ctx->Pixel.GreenScale!=1.0F || ctx->Pixel.GreenBias!=0.0F ||
!  400	       ctx->Pixel.BlueScale!=1.0F  || ctx->Pixel.BlueBias!=0.0F ||
!  401	       ctx->Pixel.AlphaScale!=1.0F || ctx->Pixel.AlphaBias!=0.0F) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 62
.L355:
	ld	[%fp+68],%l0
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 63
.L356:
	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 64
.L357:
	ld	[%fp+68],%l0
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 65
.L358:
	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 66
.L359:
	ld	[%fp+68],%l0
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 67
.L360:
	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmps	%f5,%f4
	fbne	.L354
	nop

	! block 68
.L361:
	ld	[%fp+68],%l0
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmps	%f5,%f4
	fbe	.L352
	nop

	! block 69
.L362:
.L354:
.L363:
.L364:
.L365:

!  402	      scaleOrBias = GL_TRUE;

	mov	1,%l0
	stb	%l0,[%fp-21]

	! block 70
.L366:
.L367:
	ba	.L368
	nop

	! block 71
.L352:
.L369:
.L370:
.L371:

!  403	   }
!  404	   else {
!  405	      scaleOrBias = GL_FALSE;

	stb	%g0,[%fp-21]

	! block 72
.L372:
.L373:
.L368:
.L374:
.L375:
.L378:

!  406	   }
!  407	
!  408	   switch (image->Type) {

	ba	.L377
	nop

	! block 73
.L379:
.L380:
.L381:
.L382:
.L383:

!  409	      case GL_BITMAP:
!  410	         {
!  411	            GLint shift = ctx->Pixel.IndexShift;

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-60]

	! block 74
.L384:

!  412	            GLint offset = ctx->Pixel.IndexOffset;

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-64]

	! block 75
.L385:

!  413	            /* MapIto[RGBA]Size must be powers of two */
!  414	            GLint rMask = ctx->Pixel.MapItoRsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-68]

	! block 76
.L386:

!  415	            GLint gMask = ctx->Pixel.MapItoGsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-72]

	! block 77
.L387:

!  416	            GLint bMask = ctx->Pixel.MapItoBsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-76]

	! block 78
.L388:

!  417	            GLint aMask = ctx->Pixel.MapItoAsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-80]

	! block 79
.L389:

!  418	            GLint i, j;
!  419	            GLubyte *srcPtr = (GLubyte *) image->Data;

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	st	%l0,[%fp-92]

	! block 80
.L390:

!  421	            assert( image->Format==GL_COLOR_INDEX );

	ld	[%fp+72],%l0
	ld	[%l0+16],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L392
	nop

	! block 81
.L393:
	sethi	%hi(.L394),%l0
	or	%l0,%lo(.L394),%l0
	add	%l0,32,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	421,%o2
	ba	.L391
	nop

	! block 82
.L392:
	mov	1,%l0
	ba	.L396
	st	%l0,[%fp-96]

	! block 83
.L391:
	st	%g0,[%fp-96]

	! block 84
.L396:
.L397:
.L398:

!  423	            for (j=0; j<image->Height; j++) {

	st	%g0,[%fp-88]
	ld	[%fp+72],%l0
	ld	[%l0+4],%l0
	cmp	%g0,%l0
	bge	.L401
	nop

	! block 85
.L402:
.L399:
.L403:
.L404:
.L405:

!  424	               GLubyte bitMask = 128;

	mov	128,%l0
	stb	%l0,[%fp-97]

	! block 86
.L406:
.L407:

!  425	               for (i=0; i<image->Width; i++) {

	st	%g0,[%fp-84]
	ld	[%fp+72],%l0
	ld	[%l0+0],%l0
	cmp	%g0,%l0
	bge	.L410
	nop

	! block 87
.L411:
.L408:
.L412:
.L413:
.L414:

!  426	                  GLint index;
!  427	                  GLubyte red, green, blue, alpha;
!  428	
!  429	                  /* Fetch image color index */
!  430	                  index = (*srcPtr & bitMask) ? 1 : 0;

	ld	[%fp-92],%l0
	ldub	[%l0+0],%l0
	ldub	[%fp-97],%l1
	and	%l0,%l1,%l0
	cmp	%g0,%l0

	! block 88
.L416:

	! block 89
.L415:

	! block 90
.L417:
	addx	%g0,0,%l0
	st	%l0,[%fp-112]
	ld	[%fp-112],%l0
	st	%l0,[%fp-104]

	! block 91
.L418:

!  431	                  bitMask = bitMask >> 1;

	ldub	[%fp-97],%l0
	sra	%l0,1,%l0
	stb	%l0,[%fp-97]

	! block 92
.L419:
.L421:

!  432	                  if (bitMask==0) {

	ldub	[%fp-97],%l0
	cmp	%l0,0
	bne	.L420
	nop

	! block 93
.L422:
.L423:
.L424:
.L425:

!  433	                     bitMask = 128;

	mov	128,%l0
	stb	%l0,[%fp-97]

	! block 94
.L426:

!  434	                     srcPtr++;

	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]

	! block 95
.L427:
.L428:
.L420:
.L429:
.L430:
.L432:

!  435	                  }
!  436	                  /* apply index shift and offset */
!  437	                  if (shift>=0) {

	ld	[%fp-60],%l0
	cmp	%l0,0
	bl	.L431
	nop

	! block 96
.L433:
.L434:
.L435:
.L436:

!  438	                     index = (index << shift) + offset;

	ld	[%fp-104],%l0
	ld	[%fp-60],%l1
	sll	%l0,%l1,%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 97
.L437:
.L438:
	ba	.L439
	nop

	! block 98
.L431:
.L440:
.L441:
.L442:

!  439	                  }
!  440	                  else {
!  441	                     index = (index >> -shift) + offset;

	ld	[%fp-104],%l2
	ld	[%fp-60],%l0
	neg	%l0,%l1
	sra	%l2,%l1,%l0
	ld	[%fp-64],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-104]

	! block 99
.L443:
.L444:
.L439:
.L445:
.L446:

!  442	                  }
!  443	                  /* convert index to RGBA */
!  444	                  red   = (GLint) (ctx->Pixel.MapItoR[index & rMask] * 255.0F);

	ld	[%fp+68],%l2
	ld	[%fp-104],%l0
	ld	[%fp-68],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xb680),%l1
	or	%l1,%lo(0xb680),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-105]

	! block 100
.L447:

!  445	                  green = (GLint) (ctx->Pixel.MapItoG[index & gMask] * 255.0F);

	ld	[%fp+68],%l2
	ld	[%fp-104],%l0
	ld	[%fp-72],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xba80),%l1
	or	%l1,%lo(0xba80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-106]

	! block 101
.L448:

!  446	                  blue  = (GLint) (ctx->Pixel.MapItoB[index & bMask] * 255.0F);

	ld	[%fp+68],%l2
	ld	[%fp-104],%l0
	ld	[%fp-76],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xbe80),%l1
	or	%l1,%lo(0xbe80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-107]

	! block 102
.L449:

!  447	                  alpha = (GLint) (ctx->Pixel.MapItoA[index & aMask] * 255.0F);

	ld	[%fp+68],%l2
	ld	[%fp-104],%l0
	ld	[%fp-80],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xc280),%l1
	or	%l1,%lo(0xc280),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-108]

	! block 103
.L450:

!  449	                  /* store texel (components are GLubytes in [0,255]) */
!  450	                  pixel = j * image->Width + i;

	ld	[%fp-88],%l2
	ld	[%fp+72],%l0
	ld	[%l0+0],%l1
	smul	%l2,%l1,%l0
	ld	[%fp-84],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 104
.L451:
.L454:

!  451	                  switch (texImage->Format) {

	ba	.L453
	nop

	! block 105
.L455:
.L456:
.L457:
.L458:

!  452	                     case GL_ALPHA:
!  453	                        texImage->Data[pixel] = alpha;

	ldub	[%fp-108],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 106
.L459:

!  454	                        break;

	ba	.L452
	nop

	! block 107
.L460:
.L461:

!  455	                     case GL_LUMINANCE:
!  456	                        texImage->Data[pixel] = red;

	ldub	[%fp-105],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 108
.L462:

!  457	                        break;

	ba	.L452
	nop

	! block 109
.L463:
.L464:

!  458	                     case GL_LUMINANCE_ALPHA:
!  459	                        texImage->Data[pixel*2+0] = red;

	ldub	[%fp-105],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	stb	%l3,[%l2+%l1]

	! block 110
.L465:

!  460	                        texImage->Data[pixel*2+1] = alpha;

	ldub	[%fp-108],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 111
.L466:

!  461	                        break;

	ba	.L452
	nop

	! block 112
.L467:
.L468:

!  462	                     case GL_INTENSITY:
!  463	                        texImage->Data[pixel] = red;

	ldub	[%fp-105],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 113
.L469:

!  464	                        break;

	ba	.L452
	nop

	! block 114
.L470:
.L471:

!  465	                     case GL_RGB:
!  466	                        texImage->Data[pixel*3+0] = red;

	ldub	[%fp-105],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	stb	%l3,[%l2+%l1]

	! block 115
.L472:

!  467	                        texImage->Data[pixel*3+1] = green;

	ldub	[%fp-106],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 116
.L473:

!  468	                        texImage->Data[pixel*3+2] = blue;

	ldub	[%fp-107],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 117
.L474:

!  469	                        break;

	ba	.L452
	nop

	! block 118
.L475:
.L476:

!  470	                     case GL_RGBA:
!  471	                        texImage->Data[pixel*4+0] = red;

	ldub	[%fp-105],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	stb	%l3,[%l2+%l1]

	! block 119
.L477:

!  472	                        texImage->Data[pixel*4+1] = green;

	ldub	[%fp-106],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 120
.L478:

!  473	                        texImage->Data[pixel*4+2] = blue;

	ldub	[%fp-107],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 121
.L479:

!  474	                        texImage->Data[pixel*4+3] = alpha;

	ldub	[%fp-108],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+3]

	! block 122
.L480:

!  475	                        break;

	ba	.L452
	nop

	! block 123
.L481:
.L482:

!  476	                     default:
!  477	                        gl_problem(ctx,"Bad format in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L483),%l1
	or	%l1,%lo(.L483),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 124
.L484:

!  478	                        return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 125
.L485:
.L486:
.L453:
.L487:
	ld	[%fp-12],%l0
	ld	[%l0+0],%l2
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	bge	.L_y20
	nop

	! block 126
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L481
	nop

	! block 127
	sll	%l0,2,%l1
	sethi	%hi(.L_y21-20),%l0
	or	%l0,%lo(.L_y21-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 128
.L_y20:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	be	.L467
	nop

	! block 129
	ba	.L481
	nop

	! block 130
.L488:
.L452:
.L489:
.L490:
.L491:
.L492:
	ld	[%fp-84],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-84]
	ld	[%fp-84],%l1
	ld	[%fp+72],%l0
	ld	[%l0+0],%l0
	cmp	%l1,%l0
	bl	.L408
	nop

	! block 131
.L493:
.L410:
.L494:
.L495:
.L497:

!  479	                  }
!  480	               }
!  481	               if (bitMask!=128) {

	ldub	[%fp-97],%l0
	cmp	%l0,128
	be	.L496
	nop

	! block 132
.L498:
.L499:
.L500:
.L501:

!  482	                  srcPtr++;

	ld	[%fp-92],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-92]

	! block 133
.L502:
.L503:
.L496:
.L504:
.L505:
.L506:
.L507:
	ld	[%fp-88],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-88]
	ld	[%fp-88],%l1
	ld	[%fp+72],%l0
	ld	[%l0+4],%l0
	cmp	%l1,%l0
	bl	.L399
	nop

	! block 134
.L508:
.L401:
.L509:
.L510:
.L511:

!  483	               }
!  484	            }
!  485	         }
!  486	         break;

	ba	.L376
	nop

	! block 135
.L512:
.L513:
.L514:

!  488	      case GL_UNSIGNED_BYTE:
!  489	         for (pixel=0; pixel<numPixels; pixel++) {

	ld	[%fp-16],%l0
	cmp	%g0,%l0
	bge	.L517
	st	%g0,[%fp-20]

	! block 136
.L518:
.L515:
.L519:
.L520:
.L521:
.L524:

!  490	            GLubyte red, green, blue, alpha;
!  491	            switch (image->Format) {

	ba	.L523
	nop

	! block 137
.L525:
.L526:
.L527:
.L528:
.L530:

!  492	               case GL_COLOR_INDEX:
!  493	                  if (decode_internal_format(internalFormat)==GL_COLOR_INDEX) {

	ld	[%fp+76],%l0
	call	decode_internal_format
	mov	%l0,%o0
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%o0,%l0
	bne	.L529
	nop

	! block 138
.L531:
.L532:
.L533:
.L534:

!  494	                     /* a paletted texture */
!  495	                     GLint index = ((GLubyte*)image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	st	%l0,[%fp-64]

	! block 139
.L535:

!  496	                     red = index;

	ld	[%fp-64],%l0
	stb	%l0,[%fp-57]

	! block 140
.L536:
.L537:
	ba	.L538
	nop

	! block 141
.L529:
.L539:
.L540:
.L541:

!  497	                  }
!  498	                  else {
!  499	                     /* convert color index to RGBA */
!  500	                     GLint index = ((GLubyte*)image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	st	%l0,[%fp-64]

	! block 142
.L542:

!  501	                     red   = 255.0F * ctx->Pixel.MapItoR[index];

	ld	[%fp+68],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xb680),%l1
	or	%l1,%lo(0xb680),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-57]

	! block 143
.L543:

!  502	                     green = 255.0F * ctx->Pixel.MapItoG[index];

	ld	[%fp+68],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xba80),%l1
	or	%l1,%lo(0xba80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-58]

	! block 144
.L544:

!  503	                     blue  = 255.0F * ctx->Pixel.MapItoB[index];

	ld	[%fp+68],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xbe80),%l1
	or	%l1,%lo(0xbe80),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-59]

	! block 145
.L545:

!  504	                     alpha = 255.0F * ctx->Pixel.MapItoA[index];

	ld	[%fp+68],%l2
	ld	[%fp-64],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xc280),%l1
	or	%l1,%lo(0xc280),%l1
	ld	[%l0+%l1],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-116]
	ld	[%fp-116],%l0
	stb	%l0,[%fp-60]

	! block 146
.L546:
.L547:
.L538:
.L548:
.L549:

!  505	                  }
!  506	                  break;

	ba	.L522
	nop

	! block 147
.L550:
.L551:

!  507	               case GL_RGB:
!  508	                  /* Fetch image RGBA values */
!  509	                  red   = ((GLubyte*) image->Data)[pixel*3+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	ldub	[%l2+%l1],%l0
	stb	%l0,[%fp-57]

	! block 148
.L552:

!  510	                  green = ((GLubyte*) image->Data)[pixel*3+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	stb	%l0,[%fp-58]

	! block 149
.L553:

!  511	                  blue  = ((GLubyte*) image->Data)[pixel*3+2];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	stb	%l0,[%fp-59]

	! block 150
.L554:

!  512	                  alpha = 255;

	mov	255,%l0
	stb	%l0,[%fp-60]

	! block 151
.L555:

!  513	                  break;

	ba	.L522
	nop

	! block 152
.L556:
.L557:

!  514	               case GL_RGBA:
!  515	                  red   = ((GLubyte*) image->Data)[pixel*4+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ldub	[%l2+%l1],%l0
	stb	%l0,[%fp-57]

	! block 153
.L558:

!  516	                  green = ((GLubyte*) image->Data)[pixel*4+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	stb	%l0,[%fp-58]

	! block 154
.L559:

!  517	                  blue  = ((GLubyte*) image->Data)[pixel*4+2];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+2],%l0
	stb	%l0,[%fp-59]

	! block 155
.L560:

!  518	                  alpha = ((GLubyte*) image->Data)[pixel*4+3];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+3],%l0
	stb	%l0,[%fp-60]

	! block 156
.L561:

!  519	                  break;

	ba	.L522
	nop

	! block 157
.L562:
.L563:

!  520	               case GL_RED:
!  521	                  red   = ((GLubyte*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-57]

	! block 158
.L564:

!  522	                  green = 0;

	stb	%g0,[%fp-58]

	! block 159
.L565:

!  523	                  blue  = 0;

	stb	%g0,[%fp-59]

	! block 160
.L566:

!  524	                  alpha = 255;

	mov	255,%l0
	stb	%l0,[%fp-60]

	! block 161
.L567:

!  525	                  break;

	ba	.L522
	nop

	! block 162
.L568:
.L569:

!  526	               case GL_GREEN:
!  527	                  red   = 0;

	stb	%g0,[%fp-57]

	! block 163
.L570:

!  528	                  green = ((GLubyte*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-58]

	! block 164
.L571:

!  529	                  blue  = 0;

	stb	%g0,[%fp-59]

	! block 165
.L572:

!  530	                  alpha = 255;

	mov	255,%l0
	stb	%l0,[%fp-60]

	! block 166
.L573:

!  531	                  break;

	ba	.L522
	nop

	! block 167
.L574:
.L575:

!  532	               case GL_BLUE:
!  533	                  red   = 0;

	stb	%g0,[%fp-57]

	! block 168
.L576:

!  534	                  green = 0;

	stb	%g0,[%fp-58]

	! block 169
.L577:

!  535	                  blue  = ((GLubyte*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-59]

	! block 170
.L578:

!  536	                  alpha = 255;

	mov	255,%l0
	stb	%l0,[%fp-60]

	! block 171
.L579:

!  537	                  break;

	ba	.L522
	nop

	! block 172
.L580:
.L581:

!  538	               case GL_ALPHA:
!  539	                  red   = 0;

	stb	%g0,[%fp-57]

	! block 173
.L582:

!  540	                  green = 0;

	stb	%g0,[%fp-58]

	! block 174
.L583:

!  541	                  blue  = 0;

	stb	%g0,[%fp-59]

	! block 175
.L584:

!  542	                  alpha = ((GLubyte*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-60]

	! block 176
.L585:

!  543	                  break;

	ba	.L522
	nop

	! block 177
.L586:
.L587:

!  544	               case GL_LUMINANCE: 
!  545	                  red   = ((GLubyte*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l0
	stb	%l0,[%fp-57]

	! block 178
.L588:

!  546	                  green = red;

	ldub	[%fp-57],%l0
	stb	%l0,[%fp-58]

	! block 179
.L589:

!  547	                  blue  = red;

	ldub	[%fp-57],%l0
	stb	%l0,[%fp-59]

	! block 180
.L590:

!  548	                  alpha = 255;

	mov	255,%l0
	stb	%l0,[%fp-60]

	! block 181
.L591:

!  549	                  break;

	ba	.L522
	nop

	! block 182
.L592:
.L593:

!  550	              case GL_LUMINANCE_ALPHA:
!  551	                  red   = ((GLubyte*) image->Data)[pixel*2+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	ldub	[%l2+%l1],%l0
	stb	%l0,[%fp-57]

	! block 183
.L594:

!  552	                  green = red;

	ldub	[%fp-57],%l0
	stb	%l0,[%fp-58]

	! block 184
.L595:

!  553	                  blue  = red;

	ldub	[%fp-57],%l0
	stb	%l0,[%fp-59]

	! block 185
.L596:

!  554	                  alpha = ((GLubyte*) image->Data)[pixel*2+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	ldub	[%l0+1],%l0
	stb	%l0,[%fp-60]

	! block 186
.L597:

!  555	                  break;

	ba	.L522
	nop

	! block 187
.L598:
.L599:

!  556	              default:
!  557	                 gl_problem(ctx,"Bad format (2) in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L600),%l1
	or	%l1,%lo(.L600),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 188
.L601:

!  558	                 return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 189
.L602:
.L603:
.L523:
.L604:
	ld	[%fp+72],%l0
	ld	[%l0+16],%l0
	sethi	%hi(0x1900),%l1
	or	%l1,%lo(0x1900),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,10
	bgu	.L598
	nop

	! block 190
	sll	%l0,2,%l1
	sethi	%hi(.L_y22-44),%l0
	or	%l0,%lo(.L_y22-44),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 191
.L605:
.L522:
.L606:
.L607:
.L609:

!  559	            }
!  560	            
!  561	            if (scaleOrBias || ctx->Pixel.MapColorFlag) {

	ldub	[%fp-21],%l0
	cmp	%l0,%g0
	bne	.L610
	nop

	! block 192
.L611:
	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L608
	nop

	! block 193
.L612:
.L610:
.L613:
.L614:
.L615:

!  562	               /* Apply RGBA scale and bias */
!  563	               GLfloat r = red   * (1.0F/255.0F);

	ldub	[%fp-57],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fdivs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	st	%f4,[%fp-64]

	! block 194
.L616:

!  564	               GLfloat g = green * (1.0F/255.0F);

	ldub	[%fp-58],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fdivs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	st	%f4,[%fp-68]

	! block 195
.L617:

!  565	               GLfloat b = blue  * (1.0F/255.0F);

	ldub	[%fp-59],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fdivs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	st	%f4,[%fp-72]

	! block 196
.L618:

!  566	               GLfloat a = alpha * (1.0F/255.0F);

	ldub	[%fp-60],%l1
	sethi	%hi(0x43300000),%l0
	st	%l0,[%fp-128]
	st	%l1,[%fp-124]
	ldd	[%fp-128],%f6
	mov	0,%l0
	st	%l0,[%fp-124]
	ldd	[%fp-128],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f6
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fdivs	%f5,%f4,%f4
	fmuls	%f6,%f4,%f4
	st	%f4,[%fp-76]

	! block 197
.L619:
.L621:

!  567	               if (scaleOrBias) {

	ldub	[%fp-21],%l0
	cmp	%l0,%g0
	be	.L620
	nop

	! block 198
.L622:
.L623:
.L624:
.L625:

!  568	                  /* r,g,b,a now in [0,1] */
!  569	                  r = r * ctx->Pixel.RedScale   + ctx->Pixel.RedBias;

	ld	[%fp-64],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-64]

	! block 199
.L626:

!  570	                  g = g * ctx->Pixel.GreenScale + ctx->Pixel.GreenBias;

	ld	[%fp-68],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-68]

	! block 200
.L627:

!  571	                  b = b * ctx->Pixel.BlueScale  + ctx->Pixel.BlueBias;

	ld	[%fp-72],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-72]

	! block 201
.L628:

!  572	                  a = a * ctx->Pixel.AlphaScale + ctx->Pixel.AlphaBias;

	ld	[%fp-76],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-76]

	! block 202
.L629:

!  573	                  r = CLAMP( r, 0.0F, 1.0F );

	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L630
	nop

	! block 203
.L631:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L632
	st	%f4,[%fp-80]

	! block 204
.L630:
	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L633
	nop

	! block 205
.L634:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L635
	st	%f4,[%fp-84]

	! block 206
.L633:
	ld	[%fp-64],%f4
	st	%f4,[%fp-84]

	! block 207
.L635:
	ld	[%fp-84],%f4
	st	%f4,[%fp-80]

	! block 208
.L632:
	ld	[%fp-80],%f4
	st	%f4,[%fp-64]

	! block 209
.L636:

!  574	                  g = CLAMP( g, 0.0F, 1.0F );

	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L637
	nop

	! block 210
.L638:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L639
	st	%f4,[%fp-88]

	! block 211
.L637:
	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L640
	nop

	! block 212
.L641:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L642
	st	%f4,[%fp-92]

	! block 213
.L640:
	ld	[%fp-68],%f4
	st	%f4,[%fp-92]

	! block 214
.L642:
	ld	[%fp-92],%f4
	st	%f4,[%fp-88]

	! block 215
.L639:
	ld	[%fp-88],%f4
	st	%f4,[%fp-68]

	! block 216
.L643:

!  575	                  b = CLAMP( b, 0.0F, 1.0F );

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L644
	nop

	! block 217
.L645:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L646
	st	%f4,[%fp-96]

	! block 218
.L644:
	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L647
	nop

	! block 219
.L648:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L649
	st	%f4,[%fp-100]

	! block 220
.L647:
	ld	[%fp-72],%f4
	st	%f4,[%fp-100]

	! block 221
.L649:
	ld	[%fp-100],%f4
	st	%f4,[%fp-96]

	! block 222
.L646:
	ld	[%fp-96],%f4
	st	%f4,[%fp-72]

	! block 223
.L650:

!  576	                  a = CLAMP( a, 0.0F, 1.0F );

	ld	[%fp-76],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L651
	nop

	! block 224
.L652:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L653
	st	%f4,[%fp-104]

	! block 225
.L651:
	ld	[%fp-76],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L654
	nop

	! block 226
.L655:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L656
	st	%f4,[%fp-108]

	! block 227
.L654:
	ld	[%fp-76],%f4
	st	%f4,[%fp-108]

	! block 228
.L656:
	ld	[%fp-108],%f4
	st	%f4,[%fp-104]

	! block 229
.L653:
	ld	[%fp-104],%f4
	st	%f4,[%fp-76]

	! block 230
.L657:
.L658:
.L620:
.L659:
.L660:
.L662:

!  577	               }
!  578	               /* Apply pixel maps */
!  579	               if (ctx->Pixel.MapColorFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L661
	nop

	! block 231
.L663:
.L664:
.L665:
.L666:

!  580	                  GLint ir = (GLint) (r*ctx->Pixel.MapRtoRsize);

	ld	[%fp-64],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-80]

	! block 232
.L667:

!  581	                  GLint ig = (GLint) (g*ctx->Pixel.MapGtoGsize);

	ld	[%fp-68],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-84]

	! block 233
.L668:

!  582	                  GLint ib = (GLint) (b*ctx->Pixel.MapBtoBsize);

	ld	[%fp-72],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-88]

	! block 234
.L669:

!  583	                  GLint ia = (GLint) (a*ctx->Pixel.MapAtoAsize);

	ld	[%fp-76],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-92]

	! block 235
.L670:

!  584	                  r = ctx->Pixel.MapRtoR[ir];

	ld	[%fp+68],%l2
	ld	[%fp-80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xc680),%l1
	or	%l1,%lo(0xc680),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-64]

	! block 236
.L671:

!  585	                  g = ctx->Pixel.MapGtoG[ig];

	ld	[%fp+68],%l2
	ld	[%fp-84],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xca80),%l1
	or	%l1,%lo(0xca80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-68]

	! block 237
.L672:

!  586	                  b = ctx->Pixel.MapBtoB[ib];

	ld	[%fp+68],%l2
	ld	[%fp-88],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xce80),%l1
	or	%l1,%lo(0xce80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-72]

	! block 238
.L673:

!  587	                  a = ctx->Pixel.MapAtoA[ia];

	ld	[%fp+68],%l2
	ld	[%fp-92],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xd280),%l1
	or	%l1,%lo(0xd280),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-76]

	! block 239
.L674:
.L675:
.L661:
.L676:
.L677:

!  588	               }
!  589	               red   = (GLint) (r * 255.0F);

	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	stb	%l0,[%fp-57]

	! block 240
.L678:

!  590	               green = (GLint) (g * 255.0F);

	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	stb	%l0,[%fp-58]

	! block 241
.L679:

!  591	               blue  = (GLint) (b * 255.0F);

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	stb	%l0,[%fp-59]

	! block 242
.L680:

!  592	               alpha = (GLint) (a * 255.0F);

	ld	[%fp-76],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	stb	%l0,[%fp-60]

	! block 243
.L681:
.L682:
.L608:
.L683:
.L684:
.L687:

!  593	            }
!  594	
!  595	            /* store texel (components are GLubytes in [0,255]) */
!  596	            switch (texImage->Format) {

	ba	.L686
	nop

	! block 244
.L688:
.L689:
.L690:
.L691:

!  597	               case GL_COLOR_INDEX:
!  598	                  texImage->Data[pixel] = red; /* really an index */

	ldub	[%fp-57],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 245
.L692:

!  599	                  break;

	ba	.L685
	nop

	! block 246
.L693:
.L694:

!  600	               case GL_ALPHA:
!  601	                  texImage->Data[pixel] = alpha;

	ldub	[%fp-60],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 247
.L695:

!  602	                  break;

	ba	.L685
	nop

	! block 248
.L696:
.L697:

!  603	               case GL_LUMINANCE:
!  604	                  texImage->Data[pixel] = red;

	ldub	[%fp-57],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 249
.L698:

!  605	                  break;

	ba	.L685
	nop

	! block 250
.L699:
.L700:

!  606	               case GL_LUMINANCE_ALPHA:
!  607	                  texImage->Data[pixel*2+0] = red;

	ldub	[%fp-57],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	stb	%l3,[%l2+%l1]

	! block 251
.L701:

!  608	                  texImage->Data[pixel*2+1] = alpha;

	ldub	[%fp-60],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 252
.L702:

!  609	                  break;

	ba	.L685
	nop

	! block 253
.L703:
.L704:

!  610	               case GL_INTENSITY:
!  611	                  texImage->Data[pixel] = red;

	ldub	[%fp-57],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 254
.L705:

!  612	                  break;

	ba	.L685
	nop

	! block 255
.L706:
.L707:

!  613	               case GL_RGB:
!  614	                  texImage->Data[pixel*3+0] = red;

	ldub	[%fp-57],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	stb	%l3,[%l2+%l1]

	! block 256
.L708:

!  615	                  texImage->Data[pixel*3+1] = green;

	ldub	[%fp-58],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 257
.L709:

!  616	                  texImage->Data[pixel*3+2] = blue;

	ldub	[%fp-59],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 258
.L710:

!  617	                  break;

	ba	.L685
	nop

	! block 259
.L711:
.L712:

!  618	               case GL_RGBA:
!  619	                  texImage->Data[pixel*4+0] = red;

	ldub	[%fp-57],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	stb	%l3,[%l2+%l1]

	! block 260
.L713:

!  620	                  texImage->Data[pixel*4+1] = green;

	ldub	[%fp-58],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 261
.L714:

!  621	                  texImage->Data[pixel*4+2] = blue;

	ldub	[%fp-59],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 262
.L715:

!  622	                  texImage->Data[pixel*4+3] = alpha;

	ldub	[%fp-60],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+3]

	! block 263
.L716:

!  623	                  break;

	ba	.L685
	nop

	! block 264
.L717:
.L718:

!  624	               default:
!  625	                  gl_problem(ctx,"Bad format (3) in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L719),%l1
	or	%l1,%lo(.L719),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 265
.L720:

!  626	                  return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 266
.L721:
.L722:
.L686:
.L723:
	ld	[%fp-12],%l0
	ld	[%l0+0],%l2
	sethi	%hi(0x1906),%l0
	or	%l0,%lo(0x1906),%l0
	cmp	%l2,%l0
	bge	.L_y23
	nop

	! block 267
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l2,%l0
	be	.L690
	nop

	! block 268
	ba	.L717
	nop

	! block 269
.L_y23:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	bge	.L_y24
	nop

	! block 270
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L717
	nop

	! block 271
	sll	%l0,2,%l1
	sethi	%hi(.L_y25-20),%l0
	or	%l0,%lo(.L_y25-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 272
.L_y24:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	be	.L703
	nop

	! block 273
	ba	.L717
	nop

	! block 274
.L724:
.L685:
.L725:
.L726:
.L727:
.L728:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp-16],%l0
	cmp	%l1,%l0
	bl	.L515
	nop

	! block 275
.L729:
.L517:
.L730:
.L731:

!  627	            }
!  628	         }
!  629	         break;

	ba	.L376
	nop

	! block 276
.L732:
.L733:
.L734:

!  631	      case GL_FLOAT:
!  632	         for (pixel=0; pixel<numPixels; pixel++) {

	ld	[%fp-16],%l0
	cmp	%g0,%l0
	bge	.L737
	st	%g0,[%fp-20]

	! block 277
.L738:
.L735:
.L739:
.L740:
.L741:
.L744:

!  633	            GLfloat red, green, blue, alpha;
!  634	            switch (texImage->Format) {

	ba	.L743
	nop

	! block 278
.L745:
.L746:
.L747:
.L748:
.L750:

!  635	               case GL_COLOR_INDEX:
!  636	                  if (decode_internal_format(internalFormat)==GL_COLOR_INDEX) {

	ld	[%fp+76],%l0
	call	decode_internal_format
	mov	%l0,%o0
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%o0,%l0
	bne	.L749
	nop

	! block 279
.L751:
.L752:
.L753:
.L754:

!  637	                     /* a paletted texture */
!  638	                     GLint index = (GLint) ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-76]

	! block 280
.L755:

!  639	                     red = index;

	ld	[%fp-76],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	st	%f4,[%fp-60]

	! block 281
.L756:
.L757:
	ba	.L758
	nop

	! block 282
.L749:
.L759:
.L760:
.L761:

!  640	                  }
!  641	                  else {
!  642	                     GLint shift = ctx->Pixel.IndexShift;

	ld	[%fp+68],%l0
	sethi	%hi(0xae44),%l1
	or	%l1,%lo(0xae44),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-76]

	! block 283
.L762:

!  643	                     GLint offset = ctx->Pixel.IndexOffset;

	ld	[%fp+68],%l0
	sethi	%hi(0xae48),%l1
	or	%l1,%lo(0xae48),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-80]

	! block 284
.L763:

!  644	                     /* MapIto[RGBA]Size must be powers of two */
!  645	                     GLint rMask = ctx->Pixel.MapItoRsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae60),%l1
	or	%l1,%lo(0xae60),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-84]

	! block 285
.L764:

!  646	                     GLint gMask = ctx->Pixel.MapItoGsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae64),%l1
	or	%l1,%lo(0xae64),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-88]

	! block 286
.L765:

!  647	                     GLint bMask = ctx->Pixel.MapItoBsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae68),%l1
	or	%l1,%lo(0xae68),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-92]

	! block 287
.L766:

!  648	                     GLint aMask = ctx->Pixel.MapItoAsize-1;

	ld	[%fp+68],%l0
	sethi	%hi(0xae6c),%l1
	or	%l1,%lo(0xae6c),%l1
	ld	[%l0+%l1],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-96]

	! block 288
.L767:

!  649	                     /* Fetch image color index */
!  650	                     GLint index = (GLint) ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-100]

	! block 289
.L768:
.L770:

!  651	                     /* apply index shift and offset */
!  652	                     if (shift>=0) {

	ld	[%fp-76],%l0
	cmp	%l0,0
	bl	.L769
	nop

	! block 290
.L771:
.L772:
.L773:
.L774:

!  653	                        index = (index << shift) + offset;

	ld	[%fp-100],%l0
	ld	[%fp-76],%l1
	sll	%l0,%l1,%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 291
.L775:
.L776:
	ba	.L777
	nop

	! block 292
.L769:
.L778:
.L779:
.L780:

!  654	                     }
!  655	                     else {
!  656	                        index = (index >> -shift) + offset;

	ld	[%fp-100],%l2
	ld	[%fp-76],%l0
	neg	%l0,%l1
	sra	%l2,%l1,%l0
	ld	[%fp-80],%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-100]

	! block 293
.L781:
.L782:
.L777:
.L783:
.L784:

!  657	                     }
!  658	                     /* convert index to RGBA */
!  659	                     red   = ctx->Pixel.MapItoR[index & rMask];

	ld	[%fp+68],%l2
	ld	[%fp-100],%l0
	ld	[%fp-84],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xb680),%l1
	or	%l1,%lo(0xb680),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-60]

	! block 294
.L785:

!  660	                     green = ctx->Pixel.MapItoG[index & gMask];

	ld	[%fp+68],%l2
	ld	[%fp-100],%l0
	ld	[%fp-88],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xba80),%l1
	or	%l1,%lo(0xba80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-64]

	! block 295
.L786:

!  661	                     blue  = ctx->Pixel.MapItoB[index & bMask];

	ld	[%fp+68],%l2
	ld	[%fp-100],%l0
	ld	[%fp-92],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xbe80),%l1
	or	%l1,%lo(0xbe80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-68]

	! block 296
.L787:

!  662	                     alpha = ctx->Pixel.MapItoA[index & aMask];

	ld	[%fp+68],%l2
	ld	[%fp-100],%l0
	ld	[%fp-96],%l1
	and	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xc280),%l1
	or	%l1,%lo(0xc280),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-72]

	! block 297
.L788:
.L789:
.L758:
.L790:
.L791:

!  663	                  }
!  664	                  break;

	ba	.L742
	nop

	! block 298
.L792:
.L793:

!  665	               case GL_RGB:
!  666	                  /* Fetch image RGBA values */
!  667	                  red   = ((GLfloat*) image->Data)[pixel*3+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l3
	ld	[%fp-20],%l0
	sll	%l0,2,%l2
	sll	%l0,3,%l1
	add	%l2,%l1,%l1
	ld	[%l3+%l1],%f4
	st	%f4,[%fp-60]

	! block 299
.L794:

!  668	                  green = ((GLfloat*) image->Data)[pixel*3+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-64]

	! block 300
.L795:

!  669	                  blue  = ((GLfloat*) image->Data)[pixel*3+2];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-68]

	! block 301
.L796:

!  670	                  alpha = 1.0;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 302
.L797:

!  671	                  break;

	ba	.L742
	nop

	! block 303
.L798:
.L799:

!  672	               case GL_RGBA:
!  673	                  red   = ((GLfloat*) image->Data)[pixel*4+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,4,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-60]

	! block 304
.L800:

!  674	                  green = ((GLfloat*) image->Data)[pixel*4+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-64]

	! block 305
.L801:

!  675	                  blue  = ((GLfloat*) image->Data)[pixel*4+2];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+8],%f4
	st	%f4,[%fp-68]

	! block 306
.L802:

!  676	                  alpha = ((GLfloat*) image->Data)[pixel*4+3];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+12],%f4
	st	%f4,[%fp-72]

	! block 307
.L803:

!  677	                  break;

	ba	.L742
	nop

	! block 308
.L804:
.L805:

!  678	               case GL_RED:
!  679	                  red   = ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-60]

	! block 309
.L806:

!  680	                  green = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-64]

	! block 310
.L807:

!  681	                  blue  = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-68]

	! block 311
.L808:

!  682	                  alpha = 1.0;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 312
.L809:

!  683	                  break;

	ba	.L742
	nop

	! block 313
.L810:
.L811:

!  684	               case GL_GREEN:
!  685	                  red   = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 314
.L812:

!  686	                  green = ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-64]

	! block 315
.L813:

!  687	                  blue  = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-68]

	! block 316
.L814:

!  688	                  alpha = 1.0;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 317
.L815:

!  689	                  break;

	ba	.L742
	nop

	! block 318
.L816:
.L817:

!  690	               case GL_BLUE:
!  691	                  red   = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 319
.L818:

!  692	                  green = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-64]

	! block 320
.L819:

!  693	                  blue  = ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-68]

	! block 321
.L820:

!  694	                  alpha = 1.0;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 322
.L821:

!  695	                  break;

	ba	.L742
	nop

	! block 323
.L822:
.L823:

!  696	               case GL_ALPHA:
!  697	                  red   = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-60]

	! block 324
.L824:

!  698	                  green = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-64]

	! block 325
.L825:

!  699	                  blue  = 0.0;

	sethi	%hi(.L_cseg4),%l0
	ldd	[%l0+%lo(.L_cseg4)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-68]

	! block 326
.L826:

!  700	                  alpha = ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-72]

	! block 327
.L827:

!  701	                  break;

	ba	.L742
	nop

	! block 328
.L828:
.L829:

!  702	               case GL_LUMINANCE: 
!  703	                  red   = ((GLfloat*) image->Data)[pixel];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-60]

	! block 329
.L830:

!  704	                  green = red;

	ld	[%fp-60],%f4
	st	%f4,[%fp-64]

	! block 330
.L831:

!  705	                  blue  = red;

	ld	[%fp-60],%f4
	st	%f4,[%fp-68]

	! block 331
.L832:

!  706	                  alpha = 1.0;

	sethi	%hi(.L_cseg3),%l0
	ldd	[%l0+%lo(.L_cseg3)],%f4
	fdtos	%f4,%f4
	st	%f4,[%fp-72]

	! block 332
.L833:

!  707	                  break;

	ba	.L742
	nop

	! block 333
.L834:
.L835:

!  708	              case GL_LUMINANCE_ALPHA:
!  709	                  red   = ((GLfloat*) image->Data)[pixel*2+0];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,3,%l1
	ld	[%l2+%l1],%f4
	st	%f4,[%fp-60]

	! block 334
.L836:

!  710	                  green = red;

	ld	[%fp-60],%f4
	st	%f4,[%fp-64]

	! block 335
.L837:

!  711	                  blue  = red;

	ld	[%fp-60],%f4
	st	%f4,[%fp-68]

	! block 336
.L838:

!  712	                  alpha = ((GLfloat*) image->Data)[pixel*2+1];

	ld	[%fp+72],%l0
	ld	[%l0+24],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%f4
	st	%f4,[%fp-72]

	! block 337
.L839:

!  713	                  break;

	ba	.L742
	nop

	! block 338
.L840:
.L841:

!  714	               default:
!  715	                  gl_problem(ctx,"Bad format (4) in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L842),%l1
	or	%l1,%lo(.L842),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 339
.L843:

!  716	                  return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 340
.L844:
.L845:
.L743:
.L846:
	ld	[%fp-12],%l0
	ld	[%l0+0],%l0
	sethi	%hi(0x1900),%l1
	or	%l1,%lo(0x1900),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,10
	bgu	.L840
	nop

	! block 341
	sll	%l0,2,%l1
	sethi	%hi(.L_y26-44),%l0
	or	%l0,%lo(.L_y26-44),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 342
.L847:
.L742:
.L848:
.L849:
.L851:

!  717	            }
!  718	            
!  719	            if (image->Format!=GL_COLOR_INDEX) {

	ld	[%fp+72],%l0
	ld	[%l0+16],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L850
	nop

	! block 343
.L852:
.L853:
.L854:
.L855:
.L857:

!  720	               /* Apply RGBA scale and bias */
!  721	               if (scaleOrBias) {

	ldub	[%fp-21],%l0
	cmp	%l0,%g0
	be	.L856
	nop

	! block 344
.L858:
.L859:
.L860:
.L861:

!  722	                  red   = red   * ctx->Pixel.RedScale   + ctx->Pixel.RedBias;

	ld	[%fp-60],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae20),%l1
	or	%l1,%lo(0xae20),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae1c),%l1
	or	%l1,%lo(0xae1c),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-60]

	! block 345
.L862:

!  723	                  green = green * ctx->Pixel.GreenScale + ctx->Pixel.GreenBias;

	ld	[%fp-64],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae28),%l1
	or	%l1,%lo(0xae28),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae24),%l1
	or	%l1,%lo(0xae24),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-64]

	! block 346
.L863:

!  724	                  blue  = blue  * ctx->Pixel.BlueScale  + ctx->Pixel.BlueBias;

	ld	[%fp-68],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae30),%l1
	or	%l1,%lo(0xae30),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae2c),%l1
	or	%l1,%lo(0xae2c),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-68]

	! block 347
.L864:

!  725	                  alpha = alpha * ctx->Pixel.AlphaScale + ctx->Pixel.AlphaBias;

	ld	[%fp-72],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae38),%l1
	or	%l1,%lo(0xae38),%l1
	ld	[%l0+%l1],%f4
	fmuls	%f5,%f4,%f5
	sethi	%hi(0xae34),%l1
	or	%l1,%lo(0xae34),%l1
	ld	[%l0+%l1],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%fp-72]

	! block 348
.L865:

!  726	                  red   = CLAMP( red,    0.0F, 1.0F );

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L866
	nop

	! block 349
.L867:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L868
	st	%f4,[%fp-76]

	! block 350
.L866:
	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L869
	nop

	! block 351
.L870:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L871
	st	%f4,[%fp-80]

	! block 352
.L869:
	ld	[%fp-60],%f4
	st	%f4,[%fp-80]

	! block 353
.L871:
	ld	[%fp-80],%f4
	st	%f4,[%fp-76]

	! block 354
.L868:
	ld	[%fp-76],%f4
	st	%f4,[%fp-60]

	! block 355
.L872:

!  727	                  green = CLAMP( green,  0.0F, 1.0F );

	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L873
	nop

	! block 356
.L874:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L875
	st	%f4,[%fp-84]

	! block 357
.L873:
	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L876
	nop

	! block 358
.L877:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L878
	st	%f4,[%fp-88]

	! block 359
.L876:
	ld	[%fp-64],%f4
	st	%f4,[%fp-88]

	! block 360
.L878:
	ld	[%fp-88],%f4
	st	%f4,[%fp-84]

	! block 361
.L875:
	ld	[%fp-84],%f4
	st	%f4,[%fp-64]

	! block 362
.L879:

!  728	                  blue  = CLAMP( blue,   0.0F, 1.0F );

	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L880
	nop

	! block 363
.L881:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L882
	st	%f4,[%fp-92]

	! block 364
.L880:
	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L883
	nop

	! block 365
.L884:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L885
	st	%f4,[%fp-96]

	! block 366
.L883:
	ld	[%fp-68],%f4
	st	%f4,[%fp-96]

	! block 367
.L885:
	ld	[%fp-96],%f4
	st	%f4,[%fp-92]

	! block 368
.L882:
	ld	[%fp-92],%f4
	st	%f4,[%fp-68]

	! block 369
.L886:

!  729	                  alpha = CLAMP( alpha,  0.0F, 1.0F );

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbuge	.L887
	nop

	! block 370
.L888:
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	ba	.L889
	st	%f4,[%fp-100]

	! block 371
.L887:
	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fcmpes	%f5,%f4
	fbule	.L890
	nop

	! block 372
.L891:
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	ba	.L892
	st	%f4,[%fp-104]

	! block 373
.L890:
	ld	[%fp-72],%f4
	st	%f4,[%fp-104]

	! block 374
.L892:
	ld	[%fp-104],%f4
	st	%f4,[%fp-100]

	! block 375
.L889:
	ld	[%fp-100],%f4
	st	%f4,[%fp-72]

	! block 376
.L893:
.L894:
.L856:
.L895:
.L896:
.L898:

!  730	               }
!  731	               /* Apply pixel maps */
!  732	               if (ctx->Pixel.MapColorFlag) {

	ld	[%fp+68],%l0
	sethi	%hi(0xae4c),%l1
	or	%l1,%lo(0xae4c),%l1
	ldub	[%l0+%l1],%l0
	cmp	%l0,%g0
	be	.L897
	nop

	! block 377
.L899:
.L900:
.L901:
.L902:

!  733	                  GLint ir = (GLint) (red  *ctx->Pixel.MapRtoRsize);

	ld	[%fp-60],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae70),%l1
	or	%l1,%lo(0xae70),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-76]

	! block 378
.L903:

!  734	                  GLint ig = (GLint) (green*ctx->Pixel.MapGtoGsize);

	ld	[%fp-64],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae74),%l1
	or	%l1,%lo(0xae74),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-80]

	! block 379
.L904:

!  735	                  GLint ib = (GLint) (blue *ctx->Pixel.MapBtoBsize);

	ld	[%fp-68],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae78),%l1
	or	%l1,%lo(0xae78),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-84]

	! block 380
.L905:

!  736	                  GLint ia = (GLint) (alpha*ctx->Pixel.MapAtoAsize);

	ld	[%fp-72],%f5
	ld	[%fp+68],%l0
	sethi	%hi(0xae7c),%l1
	or	%l1,%lo(0xae7c),%l1
	ld	[%l0+%l1],%l0
	st	%l0,[%fp-128]
	ld	[%fp-128],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l0
	st	%l0,[%fp-88]

	! block 381
.L906:

!  737	                  red   = ctx->Pixel.MapRtoR[ir];

	ld	[%fp+68],%l2
	ld	[%fp-76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xc680),%l1
	or	%l1,%lo(0xc680),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-60]

	! block 382
.L907:

!  738	                  green = ctx->Pixel.MapGtoG[ig];

	ld	[%fp+68],%l2
	ld	[%fp-80],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xca80),%l1
	or	%l1,%lo(0xca80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-64]

	! block 383
.L908:

!  739	                  blue  = ctx->Pixel.MapBtoB[ib];

	ld	[%fp+68],%l2
	ld	[%fp-84],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xce80),%l1
	or	%l1,%lo(0xce80),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-68]

	! block 384
.L909:

!  740	                  alpha = ctx->Pixel.MapAtoA[ia];

	ld	[%fp+68],%l2
	ld	[%fp-88],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	sethi	%hi(0xd280),%l1
	or	%l1,%lo(0xd280),%l1
	ld	[%l0+%l1],%f4
	st	%f4,[%fp-72]

	! block 385
.L910:
.L911:
.L897:
.L912:
.L913:
.L914:
.L850:
.L915:
.L916:
.L919:

!  741	               }
!  742	            }
!  743	
!  744	            /* store texel (components are GLubytes in [0,255]) */
!  745	            switch (texImage->Format) {

	ba	.L918
	nop

	! block 386
.L920:
.L921:
.L922:
.L923:

!  746	               case GL_COLOR_INDEX:
!  747	                  /* a paletted texture */
!  748	                  texImage->Data[pixel] = (GLint) (red * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 387
.L924:

!  749	                  break;

	ba	.L917
	nop

	! block 388
.L925:
.L926:

!  750	               case GL_ALPHA:
!  751	                  texImage->Data[pixel] = (GLint) (alpha * 255.0F);

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 389
.L927:

!  752	                  break;

	ba	.L917
	nop

	! block 390
.L928:
.L929:

!  753	               case GL_LUMINANCE:
!  754	                  texImage->Data[pixel] = (GLint) (red * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 391
.L930:

!  755	                  break;

	ba	.L917
	nop

	! block 392
.L931:
.L932:

!  756	               case GL_LUMINANCE_ALPHA:
!  757	                  texImage->Data[pixel*2+0] = (GLint) (red * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	stb	%l3,[%l2+%l1]

	! block 393
.L933:

!  758	                  texImage->Data[pixel*2+1] = (GLint) (alpha * 255.0F);

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 394
.L934:

!  759	                  break;

	ba	.L917
	nop

	! block 395
.L935:
.L936:

!  760	               case GL_INTENSITY:
!  761	                  texImage->Data[pixel] = (GLint) (red * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l2
	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 396
.L937:

!  762	                  break;

	ba	.L917
	nop

	! block 397
.L938:
.L939:

!  763	               case GL_RGB:
!  764	                  texImage->Data[pixel*3+0] = (GLint) (red   * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	stb	%l3,[%l2+%l1]

	! block 398
.L940:

!  765	                  texImage->Data[pixel*3+1] = (GLint) (green * 255.0F);

	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 399
.L941:

!  766	                  texImage->Data[pixel*3+2] = (GLint) (blue  * 255.0F);

	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 400
.L942:

!  767	                  break;

	ba	.L917
	nop

	! block 401
.L943:
.L944:

!  768	               case GL_RGBA:
!  769	                  texImage->Data[pixel*4+0] = (GLint) (red   * 255.0F);

	ld	[%fp-60],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	stb	%l3,[%l2+%l1]

	! block 402
.L945:

!  770	                  texImage->Data[pixel*4+1] = (GLint) (green * 255.0F);

	ld	[%fp-64],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+1]

	! block 403
.L946:

!  771	                  texImage->Data[pixel*4+2] = (GLint) (blue  * 255.0F);

	ld	[%fp-68],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+2]

	! block 404
.L947:

!  772	                  texImage->Data[pixel*4+3] = (GLint) (alpha * 255.0F);

	ld	[%fp-72],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp-128]
	ld	[%fp-128],%l3
	ld	[%fp-12],%l0
	ld	[%l0+52],%l2
	ld	[%fp-20],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	stb	%l3,[%l0+3]

	! block 405
.L948:

!  773	                  break;

	ba	.L917
	nop

	! block 406
.L949:
.L950:

!  774	               default:
!  775	                  gl_problem(ctx,"Bad format (5) in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L951),%l1
	or	%l1,%lo(.L951),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 407
.L952:

!  776	                  return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 408
.L953:
.L954:
.L918:
.L955:
	ld	[%fp-12],%l0
	ld	[%l0+0],%l2
	sethi	%hi(0x1906),%l0
	or	%l0,%lo(0x1906),%l0
	cmp	%l2,%l0
	bge	.L_y27
	nop

	! block 409
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l2,%l0
	be	.L922
	nop

	! block 410
	ba	.L949
	nop

	! block 411
.L_y27:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	bge	.L_y28
	nop

	! block 412
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L949
	nop

	! block 413
	sll	%l0,2,%l1
	sethi	%hi(.L_y29-20),%l0
	or	%l0,%lo(.L_y29-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 414
.L_y28:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	be	.L935
	nop

	! block 415
	ba	.L949
	nop

	! block 416
.L956:
.L917:
.L957:
.L958:
.L959:
.L960:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp-16],%l0
	cmp	%l1,%l0
	bl	.L735
	nop

	! block 417
.L961:
.L737:
.L962:
.L963:

!  777	            }
!  778	         }
!  779	         break;

	ba	.L376
	nop

	! block 418
.L964:
.L965:

!  781	      default:
!  782	         gl_problem(ctx, "Bad image type in image_to_texture");

	ld	[%fp+68],%l0
	sethi	%hi(.L966),%l1
	or	%l1,%lo(.L966),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 419
.L967:

!  783	         return NULL;

	ba	.L237
	st	%g0,[%fp-4]

	! block 420
.L968:
.L969:
.L377:
.L970:
	ld	[%fp+72],%l0
	ld	[%l0+20],%l1
	sethi	%hi(0x1406),%l0
	or	%l0,%lo(0x1406),%l0
	cmp	%l1,%l0
	bge	.L_y30
	nop

	! block 421
	sethi	%hi(0x1401),%l0
	or	%l0,%lo(0x1401),%l0
	cmp	%l1,%l0
	be	.L512
	nop

	! block 422
	ba	.L964
	nop

	! block 423
.L_y30:
	sethi	%hi(0x1406),%l0
	or	%l0,%lo(0x1406),%l0
	cmp	%l1,%l0
	be	.L732
	nop

	! block 424
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L381
	nop

	! block 425
	ba	.L964
	nop

	! block 426
.L971:
.L376:
.L972:
.L973:

!  784	   }
!  785	
!  786	   return texImage;

	ld	[%fp-12],%l0
	ba	.L237
	st	%l0,[%fp-4]

	! block 427

	! block 428
.L974:
.L975:
.L237:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	image_to_texture,(.-image_to_texture)

	.word	.L457
	.word	.L470
	.word	.L475
	.word	.L460
	.word	.L463
.L_y21:
	.word	.L527
	.word	.L598
	.word	.L598
	.word	.L562
	.word	.L568
	.word	.L574
	.word	.L580
	.word	.L550
	.word	.L556
	.word	.L586
	.word	.L592
.L_y22:
	.word	.L693
	.word	.L706
	.word	.L711
	.word	.L696
	.word	.L699
.L_y25:
	.word	.L747
	.word	.L840
	.word	.L840
	.word	.L804
	.word	.L810
	.word	.L816
	.word	.L822
	.word	.L792
	.word	.L798
	.word	.L828
	.word	.L834
.L_y26:
	.word	.L925
	.word	.L938
	.word	.L943
	.word	.L928
	.word	.L931
.L_y29:
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	make_null_texture,#function
make_null_texture:
	save	%sp,-408,%sp

	! block 1
.L978:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L979:
.L981:

! File teximage.c:
!  787	}
!  788	
!  791	/*
!  792	 * glTexImage[123]D can accept a NULL image pointer.  In this case we
!  793	 * create a texture image with unspecified image contents per the OpenGL
!  794	 * spec.
!  795	 */
!  796	static struct gl_texture_image *
!  797	make_null_texture( GLcontext *ctx, GLenum internalFormat,
!  798	                   GLsizei width, GLsizei height, GLsizei depth, GLint border )
!  799	{
!  800	   GLint components;
!  801	   struct gl_texture_image *texImage;
!  802	   GLint numPixels;
!  803	
!  804	   /*internalFormat = decode_internal_format(internalFormat);*/
!  805	   components = components_in_intformat(internalFormat);

	ld	[%fp+72],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 3
.L982:

!  806	   numPixels = width * height * depth;

	ld	[%fp+76],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 4
.L983:

!  808	   texImage = gl_alloc_texture_image();

	call	gl_alloc_texture_image
	nop
	st	%o0,[%fp-12]

	! block 5
.L984:
.L986:

!  809	   if (!texImage)

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L985
	nop

	! block 6
.L987:
.L988:
.L989:

!  810	      return NULL;

	ba	.L977
	st	%g0,[%fp-4]

	! block 7
.L990:
.L985:
.L991:
.L992:

!  812	   texImage->Format = decode_internal_format(internalFormat);

	ld	[%fp+72],%l0
	call	decode_internal_format
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+0]

	! block 8
.L993:

!  813	   texImage->IntFormat = internalFormat;

	ld	[%fp+72],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+4]

	! block 9
.L994:

!  814	   texImage->Border = border;

	ld	[%fp+88],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+8]

	! block 10
.L995:

!  815	   texImage->Width = width;

	ld	[%fp+76],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+12]

	! block 11
.L996:

!  816	   texImage->Height = height;

	ld	[%fp+80],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+16]

	! block 12
.L997:

!  817	   texImage->Depth = depth;

	ld	[%fp+84],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+20]

	! block 13
.L998:

!  818	   texImage->WidthLog2 = logbase2(width - 2*border);

	ld	[%fp+76],%l2
	ld	[%fp+88],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+36]

	! block 14
.L999:
.L1001:

!  819	   if (height==1)  /* 1-D texture */

	ld	[%fp+80],%l0
	cmp	%l0,1
	bne	.L1000
	nop

	! block 15
.L1002:
.L1003:
.L1004:

!  820	      texImage->HeightLog2 = 0;

	ld	[%fp-12],%l0
	st	%g0,[%l0+40]

	! block 16
.L1005:
	ba	.L1006
	nop

	! block 17
.L1000:
.L1007:
.L1008:

!  821	   else
!  822	      texImage->HeightLog2 = logbase2(height - 2*border);

	ld	[%fp+80],%l2
	ld	[%fp+88],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+40]

	! block 18
.L1009:
.L1006:
.L1010:
.L1011:
.L1013:

!  823	   if (depth==1)   /* 2-D texture */

	ld	[%fp+84],%l0
	cmp	%l0,1
	bne	.L1012
	nop

	! block 19
.L1014:
.L1015:
.L1016:

!  824	      texImage->DepthLog2 = 0;

	ld	[%fp-12],%l0
	st	%g0,[%l0+44]

	! block 20
.L1017:
	ba	.L1018
	nop

	! block 21
.L1012:
.L1019:
.L1020:

!  825	   else
!  826	      texImage->DepthLog2 = logbase2(depth - 2*border);

	ld	[%fp+84],%l2
	ld	[%fp+88],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+44]

	! block 22
.L1021:
.L1018:
.L1022:
.L1023:

!  827	   texImage->Width2 = 1 << texImage->WidthLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+36],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+24]

	! block 23
.L1024:

!  828	   texImage->Height2 = 1 << texImage->HeightLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+40],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+28]

	! block 24
.L1025:

!  829	   texImage->Depth2 = 1 << texImage->DepthLog2;

	mov	1,%l2
	ld	[%fp-12],%l0
	ld	[%l0+44],%l1
	sll	%l2,%l1,%l1
	st	%l1,[%l0+32]

	! block 25
.L1026:

!  830	   texImage->MaxLog2 = MAX2( texImage->WidthLog2, texImage->HeightLog2 );

	ld	[%fp-12],%l0
	ld	[%l0+36],%l1
	ld	[%l0+40],%l0
	cmp	%l1,%l0
	bleu	.L1027
	nop

	! block 26
.L1028:
	ld	[%fp-12],%l0
	ld	[%l0+36],%l0
	ba	.L1029
	st	%l0,[%fp-20]

	! block 27
.L1027:
	ld	[%fp-12],%l0
	ld	[%l0+40],%l0
	st	%l0,[%fp-20]

	! block 28
.L1029:
	ld	[%fp-20],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+48]

	! block 29
.L1030:

!  832	   /* XXX should we really allocate memory for the image or let it be NULL? */
!  833	   /*texImage->Data = NULL;*/
!  834	
!  835	   texImage->Data = (GLubyte *) malloc( numPixels * components );

	ld	[%fp-16],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	call	malloc
	mov	%l0,%o0
	ld	[%fp-12],%l0
	st	%o0,[%l0+52]

	! block 30
.L1031:
.L1033:

!  837	   /*
!  838	    * Let's see if anyone finds this.  If glTexImage2D() is called with
!  839	    * a NULL image pointer then load the texture image with something
!  840	    * interesting instead of leaving it indeterminate.
!  841	    */
!  842	   if (texImage->Data) {

	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	be	.L1032
	nop

	! block 31
.L1034:
.L1035:
.L1036:
.L1038:

!  843	      char message[8][32] = {
!  844	         "   X   X  XXXXX   XXX     X    ",
!  845	         "   XX XX  X      X   X   X X   ",
!  846	         "   X X X  X      X      X   X  ",
!  847	         "   X   X  XXXX    XXX   XXXXX  ",
!  848	         "   X   X  X          X  X   X  ",
!  849	         "   X   X  X      X   X  X   X  ",
!  850	         "   X   X  XXXXX   XXX   X   X  ",
!  851	         "                               "
!  852	      };

	sethi	%hi(.L1037),%l0
	or	%l0,%lo(.L1037),%l0
	add	%fp,-276,%l1
	or	%g0,256,%g1
1:
	subcc	%g1,1,%g1
.L_y41:
	ldub	[%l0+%g1],%l2
	bg	1b
	stb	%l2,[%l1+%g1]

	! block 32
.L1039:

!  854	      GLubyte *imgPtr = texImage->Data;

	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-280]

	! block 33
.L1040:
.L1041:

!  855	      GLint i, j, k;
!  856	      for (i=0;i<height;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L1044
	st	%g0,[%fp-284]

	! block 34
.L1045:
.L1042:
.L1046:
.L1047:
.L1048:

!  857	         GLint srcRow = 7 - i % 8;

	ld	[%fp-284],%l2
	sra	%l2,31,%l0
	and	%l0,7,%l1
	add	%l2,%l1,%l0
	and	%l0,-8,%l1
	sub	%l2,%l1,%l0
	neg	%l0,%l0
	add	%l0,7,%l0
	st	%l0,[%fp-296]

	! block 35
.L1049:
.L1050:

!  858	         for (j=0;j<width;j++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L1053
	st	%g0,[%fp-288]

	! block 36
.L1054:
.L1051:
.L1055:
.L1056:
.L1057:

!  859	            GLint srcCol = j % 32;

	ld	[%fp-288],%l2
	sra	%l2,31,%l0
	and	%l0,31,%l1
	add	%l2,%l1,%l0
	and	%l0,-32,%l1
	sub	%l2,%l1,%l0
	st	%l0,[%fp-300]

	! block 37
.L1058:

!  860	            GLubyte texel = (message[srcRow][srcCol]=='X') ? 255 : 70;

	add	%fp,-276,%l2
	ld	[%fp-296],%l0
	sll	%l0,5,%l1
	add	%l2,%l1,%l0
	ld	[%fp-300],%l1
	ldsb	[%l0+%l1],%l0
	sub	%l0,88,%l0
	cmp	%g0,%l0

	! block 38
.L1060:

	! block 39
.L1059:

	! block 40
.L1061:
	addx	%g0,-1,%l1
	mov	185,%l0
	and	%l1,185,%l0
	add	%l0,70,%l0
	st	%l0,[%fp-308]
	ld	[%fp-308],%l0
	stb	%l0,[%fp-301]

	! block 41
.L1062:
.L1063:

!  861	            for (k=0;k<components;k++) {

	ld	[%fp-8],%l0
	cmp	%g0,%l0
	bge	.L1066
	st	%g0,[%fp-292]

	! block 42
.L1067:
.L1064:
.L1068:
.L1069:
.L1070:

!  862	               *imgPtr++ = texel;

	ldub	[%fp-301],%l1
	ld	[%fp-280],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-280],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-280]

	! block 43
.L1071:
.L1072:
.L1073:
	ld	[%fp-292],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-292]
	ld	[%fp-292],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	bl	.L1064
	nop

	! block 44
.L1074:
.L1066:
.L1075:
.L1076:
.L1077:
.L1078:
	ld	[%fp-288],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-288]
	ld	[%fp-288],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L1051
	nop

	! block 45
.L1079:
.L1053:
.L1080:
.L1081:
.L1082:
.L1083:
	ld	[%fp-284],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-284]
	ld	[%fp-284],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L1042
	nop

	! block 46
.L1084:
.L1044:
.L1085:
.L1086:
.L1087:
.L1032:
.L1088:
.L1089:

!  863	            }
!  864	         }
!  865	      }
!  866	   }
!  867	
!  868	   return texImage;

	ld	[%fp-12],%l0
	ba	.L977
	st	%l0,[%fp-4]

	! block 47

	! block 48
.L1090:
.L1091:
.L977:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	make_null_texture,(.-make_null_texture)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	texture_1d_error_check,#function
texture_1d_error_check:
	save	%sp,-104,%sp

	! block 1
.L1094:
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

	! block 2
.L1095:
.L1097:
.L1099:

! File teximage.c:
!  869	}
!  870	
!  874	/*
!  875	 * Test glTexImagee1D() parameters for errors.
!  876	 * Return:  GL_TRUE = an error was detected, GL_FALSE = no errors
!  877	 */
!  878	static GLboolean texture_1d_error_check( GLcontext *ctx, GLenum target,
!  879	                                         GLint level, GLenum internalFormat,
!  880	                                         GLenum format, GLenum type,
!  881	                                         GLint width, GLint border )
!  882	{
!  883	   GLint iformat;
!  884	   if (target!=GL_TEXTURE_1D && target!=GL_PROXY_TEXTURE_1D) {

	ld	[%fp+72],%l0
	cmp	%l0,3552
	be	.L1098
	nop

	! block 3
.L1100:
	ld	[%fp+72],%l1
	sethi	%hi(0x8063),%l0
	or	%l0,%lo(0x8063),%l0
	cmp	%l1,%l0
	be	.L1098
	nop

	! block 4
.L1101:
.L1102:
.L1103:
.L1104:

!  885	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1105),%l1
	or	%l1,%lo(.L1105),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 5
.L1106:

!  886	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 6
.L1107:
.L1108:
.L1098:
.L1109:
.L1110:
.L1112:

!  887	   }
!  888	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L1113
	nop

	! block 7
.L1114:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L1111
	nop

	! block 8
.L1115:
.L1113:
.L1116:
.L1117:
.L1118:

!  889	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage1D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1119),%l1
	or	%l1,%lo(.L1119),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 9
.L1120:

!  890	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 10
.L1121:
.L1122:
.L1111:
.L1123:
.L1124:

!  891	   }
!  892	   iformat = decode_internal_format( internalFormat );

	ld	[%fp+80],%l0
	call	decode_internal_format
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 11
.L1125:
.L1127:

!  893	   if (iformat<0) {

	ld	[%fp-8],%l0
	cmp	%l0,0
	bge	.L1126
	nop

	! block 12
.L1128:
.L1129:
.L1130:
.L1131:

!  894	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage1D(internalFormat)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1132),%l1
	or	%l1,%lo(.L1132),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 13
.L1133:

!  895	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 14
.L1134:
.L1135:
.L1126:
.L1136:
.L1137:
.L1139:

!  896	   }
!  897	   if (border!=0 && border!=1) {

	ld	[%fp+96],%l0
	cmp	%l0,0
	be	.L1138
	nop

	! block 15
.L1140:
	ld	[%fp+96],%l0
	cmp	%l0,1
	be	.L1138
	nop

	! block 16
.L1141:
.L1142:
.L1143:
.L1144:
.L1146:

!  898	      if (target!=GL_PROXY_TEXTURE_1D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8063),%l0
	or	%l0,%lo(0x8063),%l0
	cmp	%l1,%l0
	be	.L1145
	nop

	! block 17
.L1147:
.L1148:
.L1149:
.L1150:

!  899	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage1D(border)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1151),%l1
	or	%l1,%lo(.L1151),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L1152:
.L1153:
.L1145:
.L1154:
.L1155:

!  900	      }
!  901	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 19
.L1156:
.L1157:
.L1138:
.L1158:
.L1159:
.L1161:

!  902	   }
!  903	   if (width<2*border || width>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+92],%l1
	ld	[%fp+96],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1162
	nop

	! block 20
.L1163:
	ld	[%fp+92],%l0
	cmp	%l0,1026
	ble	.L1160
	nop

	! block 21
.L1164:
.L1162:
.L1165:
.L1166:
.L1167:
.L1169:

!  904	      if (target!=GL_PROXY_TEXTURE_1D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8063),%l0
	or	%l0,%lo(0x8063),%l0
	cmp	%l1,%l0
	be	.L1168
	nop

	! block 22
.L1170:
.L1171:
.L1172:
.L1173:

!  905	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage1D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1174),%l1
	or	%l1,%lo(.L1174),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 23
.L1175:
.L1176:
.L1168:
.L1177:
.L1178:

!  906	      }
!  907	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 24
.L1179:
.L1180:
.L1160:
.L1181:
.L1182:
.L1184:

!  908	   }
!  909	   if (logbase2( width-2*border )<0) {

	ld	[%fp+92],%l2
	ld	[%fp+96],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1183
	nop

	! block 25
.L1185:
.L1186:
.L1187:
.L1188:

!  910	      gl_error( ctx, GL_INVALID_VALUE,
!  911	               "glTexImage1D(width != 2^k + 2*border)");

	ld	[%fp+68],%l0
	sethi	%hi(.L1189),%l1
	or	%l1,%lo(.L1189),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 26
.L1190:

!  912	      return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 27
.L1191:
.L1192:
.L1183:
.L1193:
.L1194:
.L1197:

!  913	   }
!  914	   switch (format) {

	ba	.L1196
	nop

	! block 28
.L1198:
.L1199:
.L1200:
.L1201:
.L1202:
.L1203:
.L1204:
.L1205:
.L1206:
.L1207:
.L1208:
.L1209:

!  915	      case GL_COLOR_INDEX:
!  916	      case GL_RED:
!  917	      case GL_GREEN:
!  918	      case GL_BLUE:
!  919	      case GL_ALPHA:
!  920	      case GL_RGB:
!  921	      case GL_RGBA:
!  922	      case GL_LUMINANCE:
!  923	      case GL_LUMINANCE_ALPHA:
!  924	         /* OK */
!  925	         break;

	ba	.L1195
	nop

	! block 29
.L1210:
.L1211:

!  926	      default:
!  927	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage1D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1212),%l1
	or	%l1,%lo(.L1212),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 30
.L1213:

!  928	         return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 31
.L1214:
.L1215:
.L1196:
.L1216:
	ld	[%fp+84],%l0
	sethi	%hi(0x1900),%l1
	or	%l1,%lo(0x1900),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,10
	bgu	.L1210
	nop

	! block 32
	sll	%l0,2,%l1
	sethi	%hi(.L_y31-44),%l0
	or	%l0,%lo(.L_y31-44),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 33
.L1217:
.L1195:
.L1218:
.L1219:
.L1222:

!  929	   }
!  930	   switch (type) {

	ba	.L1221
	nop

	! block 34
.L1223:
.L1224:
.L1225:
.L1226:
.L1227:
.L1228:
.L1229:
.L1230:

!  931	      case GL_UNSIGNED_BYTE:
!  932	      case GL_BYTE:
!  933	      case GL_UNSIGNED_SHORT:
!  934	      case GL_SHORT:
!  935	      case GL_FLOAT:
!  936	         /* OK */
!  937	         break;

	ba	.L1220
	nop

	! block 35
.L1231:
.L1232:

!  938	      default:
!  939	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage1D(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1233),%l1
	or	%l1,%lo(.L1233),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 36
.L1234:

!  940	         return GL_TRUE;

	mov	1,%l0
	ba	.L1093
	stb	%l0,[%fp-1]

	! block 37
.L1235:
.L1236:
.L1221:
.L1237:
	ld	[%fp+88],%l0
	sethi	%hi(0x1400),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,6
	bgu	.L1231
	nop

	! block 38
	sll	%l0,2,%l1
	sethi	%hi(.L_y32-28),%l0
	or	%l0,%lo(.L_y32-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 39
.L1238:
.L1220:
.L1239:
.L1240:

!  941	   }
!  942	   return GL_FALSE;

	ba	.L1093
	stb	%g0,[%fp-1]

	! block 40

	! block 41
.L1241:
.L1242:
.L1093:
	ldub	[%fp-1],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	texture_1d_error_check,(.-texture_1d_error_check)

	.word	.L1200
	.word	.L1210
	.word	.L1210
	.word	.L1201
	.word	.L1202
	.word	.L1203
	.word	.L1204
	.word	.L1205
	.word	.L1206
	.word	.L1207
	.word	.L1208
.L_y31:
	.word	.L1226
	.word	.L1225
	.word	.L1228
	.word	.L1227
	.word	.L1231
	.word	.L1231
	.word	.L1229
.L_y32:
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	texture_2d_error_check,#function
texture_2d_error_check:
	save	%sp,-104,%sp

	! block 1
.L1245:
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
.L1246:
.L1248:
.L1250:

! File teximage.c:
!  943	}
!  944	
!  946	/*
!  947	 * Test glTexImagee2D() parameters for errors.
!  948	 * Return:  GL_TRUE = an error was detected, GL_FALSE = no errors
!  949	 */
!  950	static GLboolean texture_2d_error_check( GLcontext *ctx, GLenum target,
!  951	                                         GLint level, GLenum internalFormat,
!  952	                                         GLenum format, GLenum type,
!  953	                                         GLint width, GLint height,
!  954	                                         GLint border )
!  955	{
!  956	   GLint iformat;
!  957	   if (target!=GL_TEXTURE_2D && target!=GL_PROXY_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	be	.L1249
	nop

	! block 3
.L1251:
	ld	[%fp+72],%l1
	sethi	%hi(0x8064),%l0
	or	%l0,%lo(0x8064),%l0
	cmp	%l1,%l0
	be	.L1249
	nop

	! block 4
.L1252:
.L1253:
.L1254:
.L1255:

!  958	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage2D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1256),%l1
	or	%l1,%lo(.L1256),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 5
.L1257:

!  959	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 6
.L1258:
.L1259:
.L1249:
.L1260:
.L1261:
.L1263:

!  960	   }
!  961	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L1264
	nop

	! block 7
.L1265:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L1262
	nop

	! block 8
.L1266:
.L1264:
.L1267:
.L1268:
.L1269:

!  962	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage2D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1270),%l1
	or	%l1,%lo(.L1270),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 9
.L1271:

!  963	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 10
.L1272:
.L1273:
.L1262:
.L1274:
.L1275:

!  964	   }
!  965	   iformat = decode_internal_format( internalFormat );

	ld	[%fp+80],%l0
	call	decode_internal_format
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 11
.L1276:
.L1278:

!  966	   if (iformat<0) {

	ld	[%fp-8],%l0
	cmp	%l0,0
	bge	.L1277
	nop

	! block 12
.L1279:
.L1280:
.L1281:
.L1282:

!  967	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage2D(internalFormat)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1283),%l1
	or	%l1,%lo(.L1283),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 13
.L1284:

!  968	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 14
.L1285:
.L1286:
.L1277:
.L1287:
.L1288:
.L1290:

!  969	   }
!  970	   if (border!=0 && border!=1) {

	ld	[%fp+100],%l0
	cmp	%l0,0
	be	.L1289
	nop

	! block 15
.L1291:
	ld	[%fp+100],%l0
	cmp	%l0,1
	be	.L1289
	nop

	! block 16
.L1292:
.L1293:
.L1294:
.L1295:
.L1297:

!  971	      if (target!=GL_PROXY_TEXTURE_2D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8064),%l0
	or	%l0,%lo(0x8064),%l0
	cmp	%l1,%l0
	be	.L1296
	nop

	! block 17
.L1298:
.L1299:
.L1300:
.L1301:

!  972	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage2D(border)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1302),%l1
	or	%l1,%lo(.L1302),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L1303:
.L1304:
.L1296:
.L1305:
.L1306:

!  973	      }
!  974	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 19
.L1307:
.L1308:
.L1289:
.L1309:
.L1310:
.L1312:

!  975	   }
!  976	   if (width<2*border || width>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+92],%l1
	ld	[%fp+100],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1313
	nop

	! block 20
.L1314:
	ld	[%fp+92],%l0
	cmp	%l0,1026
	ble	.L1311
	nop

	! block 21
.L1315:
.L1313:
.L1316:
.L1317:
.L1318:
.L1320:

!  977	      if (target!=GL_PROXY_TEXTURE_2D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8064),%l0
	or	%l0,%lo(0x8064),%l0
	cmp	%l1,%l0
	be	.L1319
	nop

	! block 22
.L1321:
.L1322:
.L1323:
.L1324:

!  978	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage2D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1325),%l1
	or	%l1,%lo(.L1325),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 23
.L1326:
.L1327:
.L1319:
.L1328:
.L1329:

!  979	      }
!  980	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 24
.L1330:
.L1331:
.L1311:
.L1332:
.L1333:
.L1335:

!  981	   }
!  982	   if (height<2*border || height>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+96],%l1
	ld	[%fp+100],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1336
	nop

	! block 25
.L1337:
	ld	[%fp+96],%l0
	cmp	%l0,1026
	ble	.L1334
	nop

	! block 26
.L1338:
.L1336:
.L1339:
.L1340:
.L1341:
.L1343:

!  983	      if (target!=GL_PROXY_TEXTURE_2D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8064),%l0
	or	%l0,%lo(0x8064),%l0
	cmp	%l1,%l0
	be	.L1342
	nop

	! block 27
.L1344:
.L1345:
.L1346:
.L1347:

!  984	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage2D(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1348),%l1
	or	%l1,%lo(.L1348),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 28
.L1349:
.L1350:
.L1342:
.L1351:
.L1352:

!  985	      }
!  986	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 29
.L1353:
.L1354:
.L1334:
.L1355:
.L1356:
.L1358:

!  987	   }
!  988	   if (logbase2( width-2*border )<0) {

	ld	[%fp+92],%l2
	ld	[%fp+100],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1357
	nop

	! block 30
.L1359:
.L1360:
.L1361:
.L1362:

!  989	      gl_error( ctx,GL_INVALID_VALUE,
!  990	               "glTexImage2D(width != 2^k + 2*border)");

	ld	[%fp+68],%l0
	sethi	%hi(.L1363),%l1
	or	%l1,%lo(.L1363),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 31
.L1364:

!  991	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 32
.L1365:
.L1366:
.L1357:
.L1367:
.L1368:
.L1370:

!  992	   }
!  993	   if (logbase2( height-2*border )<0) {

	ld	[%fp+96],%l2
	ld	[%fp+100],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1369
	nop

	! block 33
.L1371:
.L1372:
.L1373:
.L1374:

!  994	      gl_error( ctx,GL_INVALID_VALUE,
!  995	               "glTexImage2D(height != 2^k + 2*border)");

	ld	[%fp+68],%l0
	sethi	%hi(.L1375),%l1
	or	%l1,%lo(.L1375),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 34
.L1376:

!  996	      return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 35
.L1377:
.L1378:
.L1369:
.L1379:
.L1380:
.L1383:

!  997	   }
!  998	   switch (format) {

	ba	.L1382
	nop

	! block 36
.L1384:
.L1385:
.L1386:
.L1387:
.L1388:
.L1389:
.L1390:
.L1391:
.L1392:
.L1393:
.L1394:
.L1395:

!  999	      case GL_COLOR_INDEX:
! 1000	      case GL_RED:
! 1001	      case GL_GREEN:
! 1002	      case GL_BLUE:
! 1003	      case GL_ALPHA:
! 1004	      case GL_RGB:
! 1005	      case GL_RGBA:
! 1006	      case GL_LUMINANCE:
! 1007	      case GL_LUMINANCE_ALPHA:
! 1008	         /* OK */
! 1009	         break;

	ba	.L1381
	nop

	! block 37
.L1396:
.L1397:

! 1010	      default:
! 1011	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage2D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1398),%l1
	or	%l1,%lo(.L1398),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 38
.L1399:

! 1012	         return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 39
.L1400:
.L1401:
.L1382:
.L1402:
	ld	[%fp+84],%l0
	sethi	%hi(0x1900),%l1
	or	%l1,%lo(0x1900),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,10
	bgu	.L1396
	nop

	! block 40
	sll	%l0,2,%l1
	sethi	%hi(.L_y33-44),%l0
	or	%l0,%lo(.L_y33-44),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 41
.L1403:
.L1381:
.L1404:
.L1405:
.L1408:

! 1013	   }
! 1014	   switch (type) {

	ba	.L1407
	nop

	! block 42
.L1409:
.L1410:
.L1411:
.L1412:
.L1413:
.L1414:
.L1415:
.L1416:
.L1417:
.L1418:

! 1015	      case GL_UNSIGNED_BYTE:
! 1016	      case GL_BYTE:
! 1017	      case GL_UNSIGNED_SHORT:
! 1018	      case GL_SHORT:
! 1019	      case GL_UNSIGNED_INT:
! 1020	      case GL_INT:
! 1021	      case GL_FLOAT:
! 1022	         /* OK */
! 1023	         break;

	ba	.L1406
	nop

	! block 43
.L1419:
.L1420:

! 1024	      default:
! 1025	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage2D(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1421),%l1
	or	%l1,%lo(.L1421),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 44
.L1422:

! 1026	         return GL_TRUE;

	mov	1,%l0
	ba	.L1244
	stb	%l0,[%fp-1]

	! block 45
.L1423:
.L1424:
.L1407:
.L1425:
	ld	[%fp+88],%l0
	sethi	%hi(0x1400),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,6
	bgu	.L1419
	nop

	! block 46
	sll	%l0,2,%l1
	sethi	%hi(.L_y34-28),%l0
	or	%l0,%lo(.L_y34-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 47
.L1426:
.L1406:
.L1427:
.L1428:

! 1027	   }
! 1028	   return GL_FALSE;

	ba	.L1244
	stb	%g0,[%fp-1]

	! block 48

	! block 49
.L1429:
.L1430:
.L1244:
	ldub	[%fp-1],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	texture_2d_error_check,(.-texture_2d_error_check)

	.word	.L1386
	.word	.L1396
	.word	.L1396
	.word	.L1387
	.word	.L1388
	.word	.L1389
	.word	.L1390
	.word	.L1391
	.word	.L1392
	.word	.L1393
	.word	.L1394
.L_y33:
	.word	.L1412
	.word	.L1411
	.word	.L1414
	.word	.L1413
	.word	.L1416
	.word	.L1415
	.word	.L1417
.L_y34:
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	texture_3d_error_check,#function
texture_3d_error_check:
	save	%sp,-104,%sp

	! block 1
.L1433:
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

	! block 2
.L1434:
.L1436:
.L1438:

! File teximage.c:
! 1029	}
! 1030	
! 1032	/*
! 1033	 * Test glTexImage3DEXT() parameters for errors.
! 1034	 * Return:  GL_TRUE = an error was detected, GL_FALSE = no errors
! 1035	 */
! 1036	static GLboolean texture_3d_error_check( GLcontext *ctx, GLenum target,
! 1037	                                         GLint level, GLenum internalFormat,
! 1038	                                         GLenum format, GLenum type,
! 1039	                                         GLint width, GLint height,
! 1040	                                         GLint depth, GLint border )
! 1041	{
! 1042	   GLint iformat;
! 1043	   if (target!=GL_TEXTURE_3D_EXT && target!=GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x806f),%l0
	or	%l0,%lo(0x806f),%l0
	cmp	%l1,%l0
	be	.L1437
	nop

	! block 3
.L1439:
	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	be	.L1437
	nop

	! block 4
.L1440:
.L1441:
.L1442:
.L1443:

! 1044	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage3DEXT(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1444),%l1
	or	%l1,%lo(.L1444),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 5
.L1445:

! 1045	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 6
.L1446:
.L1447:
.L1437:
.L1448:
.L1449:
.L1451:

! 1046	   }
! 1047	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L1452
	nop

	! block 7
.L1453:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L1450
	nop

	! block 8
.L1454:
.L1452:
.L1455:
.L1456:
.L1457:

! 1048	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1458),%l1
	or	%l1,%lo(.L1458),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 9
.L1459:

! 1049	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 10
.L1460:
.L1461:
.L1450:
.L1462:
.L1463:

! 1050	   }
! 1051	   iformat = decode_internal_format( internalFormat );

	ld	[%fp+80],%l0
	call	decode_internal_format
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 11
.L1464:
.L1466:

! 1052	   if (iformat<0) {

	ld	[%fp-8],%l0
	cmp	%l0,0
	bge	.L1465
	nop

	! block 12
.L1467:
.L1468:
.L1469:
.L1470:

! 1053	      gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(internalFormat)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1471),%l1
	or	%l1,%lo(.L1471),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 13
.L1472:

! 1054	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 14
.L1473:
.L1474:
.L1465:
.L1475:
.L1476:
.L1478:

! 1055	   }
! 1056	   if (border!=0 && border!=1) {

	ld	[%fp+104],%l0
	cmp	%l0,0
	be	.L1477
	nop

	! block 15
.L1479:
	ld	[%fp+104],%l0
	cmp	%l0,1
	be	.L1477
	nop

	! block 16
.L1480:
.L1481:
.L1482:
.L1483:
.L1485:

! 1057	      if (target!=GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	be	.L1484
	nop

	! block 17
.L1486:
.L1487:
.L1488:
.L1489:

! 1058	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(border)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1490),%l1
	or	%l1,%lo(.L1490),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L1491:
.L1492:
.L1484:
.L1493:
.L1494:

! 1059	      }
! 1060	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 19
.L1495:
.L1496:
.L1477:
.L1497:
.L1498:
.L1500:

! 1061	   }
! 1062	   if (width<2*border || width>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+92],%l1
	ld	[%fp+104],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1501
	nop

	! block 20
.L1502:
	ld	[%fp+92],%l0
	cmp	%l0,1026
	ble	.L1499
	nop

	! block 21
.L1503:
.L1501:
.L1504:
.L1505:
.L1506:
.L1508:

! 1063	      if (target!=GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	be	.L1507
	nop

	! block 22
.L1509:
.L1510:
.L1511:
.L1512:

! 1064	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1513),%l1
	or	%l1,%lo(.L1513),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 23
.L1514:
.L1515:
.L1507:
.L1516:
.L1517:

! 1065	      }
! 1066	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 24
.L1518:
.L1519:
.L1499:
.L1520:
.L1521:
.L1523:

! 1067	   }
! 1068	   if (height<2*border || height>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+96],%l1
	ld	[%fp+104],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1524
	nop

	! block 25
.L1525:
	ld	[%fp+96],%l0
	cmp	%l0,1026
	ble	.L1522
	nop

	! block 26
.L1526:
.L1524:
.L1527:
.L1528:
.L1529:
.L1531:

! 1069	      if (target!=GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	be	.L1530
	nop

	! block 27
.L1532:
.L1533:
.L1534:
.L1535:

! 1070	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1536),%l1
	or	%l1,%lo(.L1536),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 28
.L1537:
.L1538:
.L1530:
.L1539:
.L1540:

! 1071	      }
! 1072	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 29
.L1541:
.L1542:
.L1522:
.L1543:
.L1544:
.L1546:

! 1073	   }
! 1074	   if (depth<2*border || depth>2+MAX_TEXTURE_SIZE) {

	ld	[%fp+100],%l1
	ld	[%fp+104],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L1547
	nop

	! block 30
.L1548:
	ld	[%fp+100],%l0
	cmp	%l0,1026
	ble	.L1545
	nop

	! block 31
.L1549:
.L1547:
.L1550:
.L1551:
.L1552:
.L1554:

! 1075	      if (target!=GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	be	.L1553
	nop

	! block 32
.L1555:
.L1556:
.L1557:
.L1558:

! 1076	         gl_error( ctx, GL_INVALID_VALUE, "glTexImage3DEXT(depth)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1559),%l1
	or	%l1,%lo(.L1559),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 33
.L1560:
.L1561:
.L1553:
.L1562:
.L1563:

! 1077	      }
! 1078	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 34
.L1564:
.L1565:
.L1545:
.L1566:
.L1567:
.L1569:

! 1079	   }
! 1080	   if (logbase2( width-2*border )<0) {

	ld	[%fp+92],%l2
	ld	[%fp+104],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1568
	nop

	! block 35
.L1570:
.L1571:
.L1572:
.L1573:

! 1081	      gl_error( ctx,GL_INVALID_VALUE,
! 1082	               "glTexImage3DEXT(width != 2^k + 2*border))");

	ld	[%fp+68],%l0
	sethi	%hi(.L1574),%l1
	or	%l1,%lo(.L1574),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 36
.L1575:

! 1083	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 37
.L1576:
.L1577:
.L1568:
.L1578:
.L1579:
.L1581:

! 1084	   }
! 1085	   if (logbase2( height-2*border )<0) {

	ld	[%fp+96],%l2
	ld	[%fp+104],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1580
	nop

	! block 38
.L1582:
.L1583:
.L1584:
.L1585:

! 1086	      gl_error( ctx,GL_INVALID_VALUE,
! 1087	               "glTexImage3DEXT(height != 2^k + 2*border))");

	ld	[%fp+68],%l0
	sethi	%hi(.L1586),%l1
	or	%l1,%lo(.L1586),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 39
.L1587:

! 1088	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 40
.L1588:
.L1589:
.L1580:
.L1590:
.L1591:
.L1593:

! 1089	   }
! 1090	   if (logbase2( depth-2*border )<0) {

	ld	[%fp+100],%l2
	ld	[%fp+104],%l0
	sll	%l0,1,%l1
	sub	%l2,%l1,%l0
	call	logbase2
	mov	%l0,%o0
	cmp	%o0,0
	bge	.L1592
	nop

	! block 41
.L1594:
.L1595:
.L1596:
.L1597:

! 1091	      gl_error( ctx,GL_INVALID_VALUE,
! 1092	               "glTexImage3DEXT(depth  != 2^k + 2*border))");

	ld	[%fp+68],%l0
	sethi	%hi(.L1598),%l1
	or	%l1,%lo(.L1598),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 42
.L1599:

! 1093	      return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 43
.L1600:
.L1601:
.L1592:
.L1602:
.L1603:
.L1606:

! 1094	   }
! 1095	   switch (format) {

	ba	.L1605
	nop

	! block 44
.L1607:
.L1608:
.L1609:
.L1610:
.L1611:
.L1612:
.L1613:
.L1614:
.L1615:
.L1616:
.L1617:
.L1618:

! 1096	      case GL_COLOR_INDEX:
! 1097	      case GL_RED:
! 1098	      case GL_GREEN:
! 1099	      case GL_BLUE:
! 1100	      case GL_ALPHA:
! 1101	      case GL_RGB:
! 1102	      case GL_RGBA:
! 1103	      case GL_LUMINANCE:
! 1104	      case GL_LUMINANCE_ALPHA:
! 1105	         /* OK */
! 1106	         break;

	ba	.L1604
	nop

	! block 45
.L1619:
.L1620:

! 1107	      default:
! 1108	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage3DEXT(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1621),%l1
	or	%l1,%lo(.L1621),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 46
.L1622:

! 1109	         return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 47
.L1623:
.L1624:
.L1605:
.L1625:
	ld	[%fp+84],%l0
	sethi	%hi(0x1900),%l1
	or	%l1,%lo(0x1900),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,10
	bgu	.L1619
	nop

	! block 48
	sll	%l0,2,%l1
	sethi	%hi(.L_y35-44),%l0
	or	%l0,%lo(.L_y35-44),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 49
.L1626:
.L1604:
.L1627:
.L1628:
.L1631:

! 1110	   }
! 1111	   switch (type) {

	ba	.L1630
	nop

	! block 50
.L1632:
.L1633:
.L1634:
.L1635:
.L1636:
.L1637:
.L1638:
.L1639:
.L1640:
.L1641:

! 1112	      case GL_UNSIGNED_BYTE:
! 1113	      case GL_BYTE:
! 1114	      case GL_UNSIGNED_SHORT:
! 1115	      case GL_SHORT:
! 1116	      case GL_UNSIGNED_INT:
! 1117	      case GL_INT:
! 1118	      case GL_FLOAT:
! 1119	         /* OK */
! 1120	         break;

	ba	.L1629
	nop

	! block 51
.L1642:
.L1643:

! 1121	      default:
! 1122	         gl_error( ctx, GL_INVALID_ENUM, "glTexImage3DEXT(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1644),%l1
	or	%l1,%lo(.L1644),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 52
.L1645:

! 1123	         return GL_TRUE;

	mov	1,%l0
	ba	.L1432
	stb	%l0,[%fp-1]

	! block 53
.L1646:
.L1647:
.L1630:
.L1648:
	ld	[%fp+88],%l0
	sethi	%hi(0x1400),%l1
	sub	%l0,%l1,%l0
	cmp	%l0,6
	bgu	.L1642
	nop

	! block 54
	sll	%l0,2,%l1
	sethi	%hi(.L_y36-28),%l0
	or	%l0,%lo(.L_y36-28),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 55
.L1649:
.L1629:
.L1650:
.L1651:

! 1124	   }
! 1125	   return GL_FALSE;

	ba	.L1432
	stb	%g0,[%fp-1]

	! block 56

	! block 57
.L1652:
.L1653:
.L1432:
	ldub	[%fp-1],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	texture_3d_error_check,(.-texture_3d_error_check)

	.word	.L1609
	.word	.L1619
	.word	.L1619
	.word	.L1610
	.word	.L1611
	.word	.L1612
	.word	.L1613
	.word	.L1614
	.word	.L1615
	.word	.L1616
	.word	.L1617
.L_y35:
	.word	.L1635
	.word	.L1634
	.word	.L1637
	.word	.L1636
	.word	.L1639
	.word	.L1638
	.word	.L1640
.L_y36:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexImage1D
	.type	gl_TexImage1D,#function
gl_TexImage1D:
	save	%sp,-112,%sp

	! block 1
.L1656:
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
.L1657:
.L1659:
.L1661:

! File teximage.c:
! 1126	}
! 1127	
! 1130	/*
! 1131	 * Called from the API.  Note that width includes the border.
! 1132	 */
! 1133	void gl_TexImage1D( GLcontext *ctx,
! 1134	                    GLenum target, GLint level, GLint internalformat,
! 1135			    GLsizei width, GLint border, GLenum format,
! 1136			    GLenum type, struct gl_image *image )
! 1137	{
! 1138	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1660
	nop

	! block 3
.L1662:
.L1663:
.L1664:
.L1665:

! 1139	      gl_error( ctx, GL_INVALID_OPERATION, "glTexImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1666),%l1
	or	%l1,%lo(.L1666),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1667:

! 1140	      return;

	ba	.L1655
	nop

	! block 5
.L1668:
.L1669:
.L1660:
.L1670:
.L1671:
.L1673:

! 1141	   }
! 1142	
! 1143	   if (target==GL_TEXTURE_1D) {

	ld	[%fp+72],%l0
	cmp	%l0,3552
	bne	.L1672
	nop

	! block 6
.L1674:
.L1675:
.L1676:
.L1677:
.L1679:

! 1144	      struct gl_texture_image *teximage;
! 1145	      if (texture_1d_error_check( ctx, target, level, internalformat,
! 1146	                                  format, type, width, border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	call	texture_1d_error_check
	st	%l4,[%sp+96]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L1678
	nop

	! block 7
.L1680:
.L1681:
.L1682:
.L1683:

! 1147	         /* error in texture image was detected */
! 1148	         return;

	ba	.L1655
	nop

	! block 8
.L1684:
.L1685:
.L1678:
.L1686:
.L1687:
.L1689:

! 1149	      }
! 1150	
! 1151	      /* free current texture image, if any */
! 1152	      if (ctx->Texture.Current1D->Image[level]) {

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	cmp	%l0,%g0
	be	.L1688
	nop

	! block 9
.L1690:
.L1691:
.L1692:
.L1693:

! 1153	         gl_free_texture_image( ctx->Texture.Current1D->Image[level] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 10
.L1694:
.L1695:
.L1688:
.L1696:
.L1697:
.L1699:

! 1154	      }
! 1155	
! 1156	      /* make new texture from source image */
! 1157	      if (image) {

	ld	[%fp+100],%l0
	cmp	%l0,%g0
	be	.L1698
	nop

	! block 11
.L1700:
.L1701:
.L1702:
.L1703:

! 1158	         teximage = image_to_texture(ctx, image, internalformat, border);

	ld	[%fp+68],%l0
	ld	[%fp+100],%l1
	ld	[%fp+80],%l2
	ld	[%fp+88],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	image_to_texture
	mov	%l3,%o3
	st	%o0,[%fp-4]

	! block 12
.L1704:
.L1705:
	ba	.L1706
	nop

	! block 13
.L1698:
.L1707:
.L1708:
.L1709:

! 1159	      }
! 1160	      else {
! 1161	         teximage = make_null_texture(ctx, internalformat,
! 1162	                                      width, 1, 1, border);

	ld	[%fp+68],%l0
	ld	[%fp+80],%l1
	ld	[%fp+84],%l2
	ld	[%fp+88],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	1,%o3
	mov	1,%o4
	call	make_null_texture
	mov	%l3,%o5
	st	%o0,[%fp-4]

	! block 14
.L1710:
.L1711:
.L1706:
.L1712:
.L1713:

! 1163	      }
! 1164	
! 1165	      /* install new texture image */
! 1166	      ctx->Texture.Current1D->Image[level] = teximage;

	ld	[%fp-4],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+56]

	! block 15
.L1714:

! 1167	      ctx->Texture.Current1D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 16
.L1715:

! 1168	      ctx->NewState |= NEW_TEXTURING;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f4),%l1
	or	%l1,%lo(0xe0f4),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	or	%l0,4,%l0
	st	%l0,[%l1+0]

	! block 17
.L1716:
.L1718:

! 1170	      /* free the source image */
! 1171	      if (image && image->RefCount==0) {

	ld	[%fp+100],%l0
	cmp	%l0,%g0
	be	.L1717
	nop

	! block 18
.L1719:
	ld	[%fp+100],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L1717
	nop

	! block 19
.L1720:
.L1721:
.L1722:
.L1723:

! 1172	         /* if RefCount>0 then image must be in a display list */
! 1173	         gl_free_image(image);

	ld	[%fp+100],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 20
.L1724:
.L1725:
.L1717:
.L1726:
.L1727:
.L1729:

! 1174	      }
! 1175	
! 1176	      /* tell driver about change */
! 1177	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L1728
	nop

	! block 21
.L1730:
.L1731:
.L1732:
.L1733:

! 1178	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_1D,
! 1179	                                  ctx->Texture.Current1D,
! 1180	                                  level, internalformat, teximage );

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l5
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp-4],%l4
	mov	%l0,%o0
	mov	3552,%o1
	mov	%l1,%o2
	mov	%l2,%o3
	mov	%l3,%o4
	mov	%l4,%o5
	jmpl	%l5,%o7
	nop

	! block 22
.L1734:
.L1735:
.L1728:
.L1736:
.L1737:
.L1738:
	ba	.L1739
	nop

	! block 23
.L1672:
.L1740:
.L1741:
.L1743:

! 1181	      }
! 1182	   }
! 1183	   else if (target==GL_PROXY_TEXTURE_1D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8063),%l0
	or	%l0,%lo(0x8063),%l0
	cmp	%l1,%l0
	bne	.L1742
	nop

	! block 24
.L1744:
.L1745:
.L1746:
.L1747:
.L1749:

! 1184	      /* Proxy texture: check for errors and update proxy state */
! 1185	      if (texture_1d_error_check( ctx, target, level, internalformat,
! 1186	                                  format, type, width, border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	call	texture_1d_error_check
	st	%l4,[%sp+96]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L1748
	nop

	! block 25
.L1750:
.L1751:
.L1752:
.L1753:
.L1755:

! 1187	         if (level>=0 && level<MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L1754
	nop

	! block 26
.L1756:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bge	.L1754
	nop

	! block 27
.L1757:
.L1758:
.L1759:
.L1760:

! 1188	            MEMSET( ctx->Texture.Proxy1D->Image[level], 0,
! 1189	                    sizeof(struct gl_texture_image) );

	ld	[%fp+68],%l0
	sethi	%hi(0xd830),%l1
	or	%l1,%lo(0xd830),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	mov	%l0,%o0
	mov	%g0,%o1
	call	memset
	mov	60,%o2

	! block 28
.L1761:
.L1762:
.L1754:
.L1763:
.L1764:
.L1765:
	ba	.L1766
	nop

	! block 29
.L1748:
.L1767:
.L1768:
.L1769:

! 1190	         }
! 1191	      }
! 1192	      else {
! 1193	         ctx->Texture.Proxy1D->Image[level]->Format = internalformat;

	ld	[%fp+80],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd830),%l1
	or	%l1,%lo(0xd830),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+0]

	! block 30
.L1770:

! 1194	         ctx->Texture.Proxy1D->Image[level]->Border = border;

	ld	[%fp+88],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd830),%l1
	or	%l1,%lo(0xd830),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+8]

	! block 31
.L1771:

! 1195	         ctx->Texture.Proxy1D->Image[level]->Width = width;

	ld	[%fp+84],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd830),%l1
	or	%l1,%lo(0xd830),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+12]

	! block 32
.L1772:

! 1196	         ctx->Texture.Proxy1D->Image[level]->Height = 1;

	mov	1,%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd830),%l1
	or	%l1,%lo(0xd830),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+16]

	! block 33
.L1773:
.L1774:
.L1766:
.L1775:
.L1776:
.L1778:

! 1197	      }
! 1198	      if (image->RefCount==0) {

	ld	[%fp+100],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L1777
	nop

	! block 34
.L1779:
.L1780:
.L1781:
.L1782:

! 1199	         /* if RefCount>0 then image must be in a display list */
! 1200	         gl_free_image(image);

	ld	[%fp+100],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 35
.L1783:
.L1784:
.L1777:
.L1785:
.L1786:
.L1787:
	ba	.L1788
	nop

	! block 36
.L1742:
.L1789:
.L1790:
.L1791:

! 1201	      }
! 1202	   }
! 1203	   else {
! 1204	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage1D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1792),%l1
	or	%l1,%lo(.L1792),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 37
.L1793:

! 1205	      return;

	ba	.L1655
	nop

	! block 38
.L1794:
.L1795:
.L1788:
.L1796:
.L1797:
.L1739:
.L1798:

	! block 39
.L1799:
.L1800:
.L1655:
	jmp	%i7+8
	restore
	.size	gl_TexImage1D,(.-gl_TexImage1D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexImage2D
	.type	gl_TexImage2D,#function
gl_TexImage2D:
	save	%sp,-112,%sp

	! block 1
.L1803:
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

	! block 2
.L1804:
.L1806:
.L1808:

! File teximage.c:
! 1206	   }
! 1207	}
! 1208	
! 1212	/*
! 1213	 * Called by the API or display list executor.
! 1214	 * Note that width and height include the border.
! 1215	 */
! 1216	void gl_TexImage2D( GLcontext *ctx,
! 1217	                    GLenum target, GLint level, GLint internalformat,
! 1218	                    GLsizei width, GLsizei height, GLint border,
! 1219	                    GLenum format, GLenum type,
! 1220	                    struct gl_image *image )
! 1221	{
! 1222	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1807
	nop

	! block 3
.L1809:
.L1810:
.L1811:
.L1812:

! 1223	      gl_error( ctx, GL_INVALID_OPERATION, "glTexImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1813),%l1
	or	%l1,%lo(.L1813),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1814:

! 1224	      return;

	ba	.L1802
	nop

	! block 5
.L1815:
.L1816:
.L1807:
.L1817:
.L1818:
.L1820:

! 1225	   }
! 1226	
! 1227	   if (target==GL_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	bne	.L1819
	nop

	! block 6
.L1821:
.L1822:
.L1823:
.L1824:
.L1826:

! 1228	      struct gl_texture_image *teximage;
! 1229	      if (texture_2d_error_check( ctx, target, level, internalformat,
! 1230	                                  format, type, width, height, border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+96],%l5
	ld	[%fp+100],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%i0
	ld	[%fp+92],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	call	texture_2d_error_check
	st	%l4,[%sp+100]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L1825
	nop

	! block 7
.L1827:
.L1828:
.L1829:
.L1830:

! 1231	         /* error in texture image was detected */
! 1232	         return;

	ba	.L1802
	nop

	! block 8
.L1831:
.L1832:
.L1825:
.L1833:
.L1834:
.L1836:

! 1233	      }
! 1234	
! 1235	      /* free current texture image, if any */
! 1236	      if (ctx->Texture.Current2D->Image[level]) {

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	cmp	%l0,%g0
	be	.L1835
	nop

	! block 9
.L1837:
.L1838:
.L1839:
.L1840:

! 1237	         gl_free_texture_image( ctx->Texture.Current2D->Image[level] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 10
.L1841:
.L1842:
.L1835:
.L1843:
.L1844:
.L1846:

! 1238	      }
! 1239	
! 1240	      /* make new texture from source image */
! 1241	      if (image) {

	ld	[%fp+104],%l0
	cmp	%l0,%g0
	be	.L1845
	nop

	! block 11
.L1847:
.L1848:
.L1849:
.L1850:

! 1242	         teximage = image_to_texture(ctx, image, internalformat, border);

	ld	[%fp+68],%l0
	ld	[%fp+104],%l1
	ld	[%fp+80],%l2
	ld	[%fp+92],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	image_to_texture
	mov	%l3,%o3
	st	%o0,[%fp-4]

	! block 12
.L1851:
.L1852:
	ba	.L1853
	nop

	! block 13
.L1845:
.L1854:
.L1855:
.L1856:

! 1243	      }
! 1244	      else {
! 1245	         teximage = make_null_texture(ctx, internalformat,
! 1246	                                      width, height, 1, border);

	ld	[%fp+68],%l0
	ld	[%fp+80],%l1
	ld	[%fp+84],%l2
	ld	[%fp+88],%l3
	ld	[%fp+92],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	1,%o4
	call	make_null_texture
	mov	%l4,%o5
	st	%o0,[%fp-4]

	! block 14
.L1857:
.L1858:
.L1853:
.L1859:
.L1860:

! 1247	      }
! 1248	
! 1249	      /* install new texture image */
! 1250	      ctx->Texture.Current2D->Image[level] = teximage;

	ld	[%fp-4],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+56]

	! block 15
.L1861:

! 1251	      ctx->Texture.Current2D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 16
.L1862:

! 1252	      ctx->NewState |= NEW_TEXTURING;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f4),%l1
	or	%l1,%lo(0xe0f4),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	or	%l0,4,%l0
	st	%l0,[%l1+0]

	! block 17
.L1863:
.L1865:

! 1254	      /* free the source image */
! 1255	      if (image && image->RefCount==0) {

	ld	[%fp+104],%l0
	cmp	%l0,%g0
	be	.L1864
	nop

	! block 18
.L1866:
	ld	[%fp+104],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L1864
	nop

	! block 19
.L1867:
.L1868:
.L1869:
.L1870:

! 1256	         /* if RefCount>0 then image must be in a display list */
! 1257	         gl_free_image(image);

	ld	[%fp+104],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 20
.L1871:
.L1872:
.L1864:
.L1873:
.L1874:
.L1876:

! 1258	      }
! 1259	
! 1260	      /* tell driver about change */
! 1261	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L1875
	nop

	! block 21
.L1877:
.L1878:
.L1879:
.L1880:

! 1262	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_2D,
! 1263	                                  ctx->Texture.Current2D,
! 1264	                                  level, internalformat, teximage );

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l5
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp-4],%l4
	mov	%l0,%o0
	mov	3553,%o1
	mov	%l1,%o2
	mov	%l2,%o3
	mov	%l3,%o4
	mov	%l4,%o5
	jmpl	%l5,%o7
	nop

	! block 22
.L1881:
.L1882:
.L1875:
.L1883:
.L1884:
.L1885:
	ba	.L1886
	nop

	! block 23
.L1819:
.L1887:
.L1888:
.L1890:

! 1265	      }
! 1266	   }
! 1267	   else if (target==GL_PROXY_TEXTURE_2D) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8064),%l0
	or	%l0,%lo(0x8064),%l0
	cmp	%l1,%l0
	bne	.L1889
	nop

	! block 24
.L1891:
.L1892:
.L1893:
.L1894:
.L1896:

! 1268	      /* Proxy texture: check for errors and update proxy state */
! 1269	      if (texture_2d_error_check( ctx, target, level, internalformat,
! 1270	                                  format, type, width, height, border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+96],%l5
	ld	[%fp+100],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%i0
	ld	[%fp+92],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	call	texture_2d_error_check
	st	%l4,[%sp+100]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L1895
	nop

	! block 25
.L1897:
.L1898:
.L1899:
.L1900:
.L1902:

! 1271	         if (level>=0 && level<MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L1901
	nop

	! block 26
.L1903:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bge	.L1901
	nop

	! block 27
.L1904:
.L1905:
.L1906:
.L1907:

! 1272	            MEMSET( ctx->Texture.Proxy2D->Image[level], 0,
! 1273	                    sizeof(struct gl_texture_image) );

	ld	[%fp+68],%l0
	sethi	%hi(0xd834),%l1
	or	%l1,%lo(0xd834),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	mov	%l0,%o0
	mov	%g0,%o1
	call	memset
	mov	60,%o2

	! block 28
.L1908:
.L1909:
.L1901:
.L1910:
.L1911:
.L1912:
	ba	.L1913
	nop

	! block 29
.L1895:
.L1914:
.L1915:
.L1916:

! 1274	         }
! 1275	      }
! 1276	      else {
! 1277	         ctx->Texture.Proxy2D->Image[level]->Format = internalformat;

	ld	[%fp+80],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd834),%l1
	or	%l1,%lo(0xd834),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+0]

	! block 30
.L1917:

! 1278	         ctx->Texture.Proxy2D->Image[level]->Border = border;

	ld	[%fp+92],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd834),%l1
	or	%l1,%lo(0xd834),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+8]

	! block 31
.L1918:

! 1279	         ctx->Texture.Proxy2D->Image[level]->Width = width;

	ld	[%fp+84],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd834),%l1
	or	%l1,%lo(0xd834),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+12]

	! block 32
.L1919:

! 1280	         ctx->Texture.Proxy2D->Image[level]->Height = height;

	ld	[%fp+88],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd834),%l1
	or	%l1,%lo(0xd834),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+16]

	! block 33
.L1920:
.L1921:
.L1913:
.L1922:
.L1923:
.L1925:

! 1281	      }
! 1282	      if (image->RefCount==0) {

	ld	[%fp+104],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L1924
	nop

	! block 34
.L1926:
.L1927:
.L1928:
.L1929:

! 1283	         /* if RefCount>0 then image must be in a display list */
! 1284	         gl_free_image(image);

	ld	[%fp+104],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 35
.L1930:
.L1931:
.L1924:
.L1932:
.L1933:
.L1934:
	ba	.L1935
	nop

	! block 36
.L1889:
.L1936:
.L1937:
.L1938:

! 1285	      }
! 1286	   }
! 1287	   else {
! 1288	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage2D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1939),%l1
	or	%l1,%lo(.L1939),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 37
.L1940:

! 1289	      return;

	ba	.L1802
	nop

	! block 38
.L1941:
.L1942:
.L1935:
.L1943:
.L1944:
.L1886:
.L1945:

	! block 39
.L1946:
.L1947:
.L1802:
	jmp	%i7+8
	restore
	.size	gl_TexImage2D,(.-gl_TexImage2D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexImage3DEXT
	.type	gl_TexImage3DEXT,#function
gl_TexImage3DEXT:
	save	%sp,-120,%sp

	! block 1
.L1950:
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

	! block 2
.L1951:
.L1953:
.L1955:

! File teximage.c:
! 1290	   }
! 1291	}
! 1292	
! 1295	/*
! 1296	 * Called by the API or display list executor.
! 1297	 * Note that width and height include the border.
! 1298	 */
! 1299	void gl_TexImage3DEXT( GLcontext *ctx,
! 1300	                       GLenum target, GLint level, GLint internalformat,
! 1301	                       GLsizei width, GLsizei height, GLsizei depth,
! 1302	                       GLint border, GLenum format, GLenum type,
! 1303	                       struct gl_image *image )
! 1304	{
! 1305	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L1954
	nop

	! block 3
.L1956:
.L1957:
.L1958:
.L1959:

! 1306	      gl_error( ctx, GL_INVALID_OPERATION, "glTexImage3DEXT" );

	ld	[%fp+68],%l0
	sethi	%hi(.L1960),%l1
	or	%l1,%lo(.L1960),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L1961:

! 1307	      return;

	ba	.L1949
	nop

	! block 5
.L1962:
.L1963:
.L1954:
.L1964:
.L1965:
.L1967:

! 1308	   }
! 1309	
! 1310	   if (target==GL_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x806f),%l0
	or	%l0,%lo(0x806f),%l0
	cmp	%l1,%l0
	bne	.L1966
	nop

	! block 6
.L1968:
.L1969:
.L1970:
.L1971:
.L1973:

! 1311	      struct gl_texture_image *teximage;
! 1312	      if (texture_3d_error_check( ctx, target, level, internalformat,
! 1313	                                  format, type, width, height, depth,
! 1314	                                  border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+100],%l5
	ld	[%fp+104],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%i0
	ld	[%fp+92],%i1
	ld	[%fp+96],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	st	%i1,[%sp+100]
	call	texture_3d_error_check
	st	%l4,[%sp+104]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L1972
	nop

	! block 7
.L1974:
.L1975:
.L1976:
.L1977:

! 1315	         /* error in texture image was detected */
! 1316	         return;

	ba	.L1949
	nop

	! block 8
.L1978:
.L1979:
.L1972:
.L1980:
.L1981:
.L1983:

! 1317	      }
! 1318	
! 1319	      /* free current texture image, if any */
! 1320	      if (ctx->Texture.Current3D->Image[level]) {

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	cmp	%l0,%g0
	be	.L1982
	nop

	! block 9
.L1984:
.L1985:
.L1986:
.L1987:

! 1321	         gl_free_texture_image( ctx->Texture.Current3D->Image[level] );

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 10
.L1988:
.L1989:
.L1982:
.L1990:
.L1991:
.L1993:

! 1322	      }
! 1323	
! 1324	      /* make new texture from source image */
! 1325	      if (image) {

	ld	[%fp+108],%l0
	cmp	%l0,%g0
	be	.L1992
	nop

	! block 11
.L1994:
.L1995:
.L1996:
.L1997:

! 1326	         teximage = image_to_texture(ctx, image, internalformat, border);

	ld	[%fp+68],%l0
	ld	[%fp+108],%l1
	ld	[%fp+80],%l2
	ld	[%fp+96],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	image_to_texture
	mov	%l3,%o3
	st	%o0,[%fp-4]

	! block 12
.L1998:
.L1999:
	ba	.L2000
	nop

	! block 13
.L1992:
.L2001:
.L2002:
.L2003:

! 1327	      }
! 1328	      else {
! 1329	         teximage = make_null_texture(ctx, internalformat,
! 1330	                                      width, height, depth, border);

	ld	[%fp+68],%l0
	ld	[%fp+80],%l1
	ld	[%fp+84],%l2
	ld	[%fp+88],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	call	make_null_texture
	mov	%l4,%o5
	st	%o0,[%fp-4]

	! block 14
.L2004:
.L2005:
.L2000:
.L2006:
.L2007:

! 1331	      }
! 1332	
! 1333	      /* install new texture image */
! 1334	      ctx->Texture.Current3D->Image[level] = teximage;

	ld	[%fp-4],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%l3,[%l0+56]

	! block 15
.L2008:

! 1335	      ctx->Texture.Current3D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 16
.L2009:

! 1336	      ctx->NewState |= NEW_TEXTURING;

	ld	[%fp+68],%l0
	sethi	%hi(0xe0f4),%l1
	or	%l1,%lo(0xe0f4),%l1
	add	%l0,%l1,%l1
	ld	[%l1+0],%l0
	or	%l0,4,%l0
	st	%l0,[%l1+0]

	! block 17
.L2010:
.L2012:

! 1338	      /* free the source image */
! 1339	      if (image && image->RefCount==0) {

	ld	[%fp+108],%l0
	cmp	%l0,%g0
	be	.L2011
	nop

	! block 18
.L2013:
	ld	[%fp+108],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L2011
	nop

	! block 19
.L2014:
.L2015:
.L2016:
.L2017:

! 1340	         /* if RefCount>0 then image must be in a display list */
! 1341	         gl_free_image(image);

	ld	[%fp+108],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 20
.L2018:
.L2019:
.L2011:
.L2020:
.L2021:
.L2023:

! 1342	      }
! 1343	
! 1344	      /* tell driver about change */
! 1345	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L2022
	nop

	! block 21
.L2024:
.L2025:
.L2026:
.L2027:

! 1346	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_3D_EXT,
! 1347	                                  ctx->Texture.Current3D,
! 1348	                                  level, internalformat, teximage );

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l5
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp-4],%l4
	mov	%l0,%o0
	sethi	%hi(0x806f),%o1
	or	%o1,%lo(0x806f),%o1
	mov	%l1,%o2
	mov	%l2,%o3
	mov	%l3,%o4
	mov	%l4,%o5
	jmpl	%l5,%o7
	nop

	! block 22
.L2028:
.L2029:
.L2022:
.L2030:
.L2031:
.L2032:
	ba	.L2033
	nop

	! block 23
.L1966:
.L2034:
.L2035:
.L2037:

! 1349	      }
! 1350	   }
! 1351	   else if (target==GL_PROXY_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x8070),%l0
	or	%l0,%lo(0x8070),%l0
	cmp	%l1,%l0
	bne	.L2036
	nop

	! block 24
.L2038:
.L2039:
.L2040:
.L2041:
.L2043:

! 1352	      /* Proxy texture: check for errors and update proxy state */
! 1353	      if (texture_3d_error_check( ctx, target, level, internalformat,
! 1354	                                  format, type, width, height, depth,
! 1355	                                  border )) {

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+100],%l5
	ld	[%fp+104],%l6
	ld	[%fp+84],%l7
	ld	[%fp+88],%i0
	ld	[%fp+92],%i1
	ld	[%fp+96],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	st	%i1,[%sp+100]
	call	texture_3d_error_check
	st	%l4,[%sp+104]
	sll	%o0,24,%l0
	srl	%l0,24,%l0
	cmp	%l0,%g0
	be	.L2042
	nop

	! block 25
.L2044:
.L2045:
.L2046:
.L2047:
.L2049:

! 1356	         if (level>=0 && level<MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L2048
	nop

	! block 26
.L2050:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bge	.L2048
	nop

	! block 27
.L2051:
.L2052:
.L2053:
.L2054:

! 1357	            MEMSET( ctx->Texture.Proxy3D->Image[level], 0,
! 1358	                    sizeof(struct gl_texture_image) );

	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	mov	%l0,%o0
	mov	%g0,%o1
	call	memset
	mov	60,%o2

	! block 28
.L2055:
.L2056:
.L2048:
.L2057:
.L2058:
.L2059:
	ba	.L2060
	nop

	! block 29
.L2042:
.L2061:
.L2062:
.L2063:

! 1359	         }
! 1360	      }
! 1361	      else {
! 1362	         ctx->Texture.Proxy3D->Image[level]->Format = internalformat;

	ld	[%fp+80],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+0]

	! block 30
.L2064:

! 1363	         ctx->Texture.Proxy3D->Image[level]->Border = border;

	ld	[%fp+96],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+8]

	! block 31
.L2065:

! 1364	         ctx->Texture.Proxy3D->Image[level]->Width = width;

	ld	[%fp+84],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+12]

	! block 32
.L2066:

! 1365	         ctx->Texture.Proxy3D->Image[level]->Height = height;

	ld	[%fp+88],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+16]

	! block 33
.L2067:

! 1366	         ctx->Texture.Proxy3D->Image[level]->Depth  = depth;

	ld	[%fp+92],%l3
	ld	[%fp+68],%l0
	sethi	%hi(0xd838),%l1
	or	%l1,%lo(0xd838),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l3,[%l0+20]

	! block 34
.L2068:
.L2069:
.L2060:
.L2070:
.L2071:
.L2073:

! 1367	      }
! 1368	      if (image->RefCount==0) {

	ld	[%fp+108],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L2072
	nop

	! block 35
.L2074:
.L2075:
.L2076:
.L2077:

! 1369	         /* if RefCount>0 then image must be in a display list */
! 1370	         gl_free_image(image);

	ld	[%fp+108],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 36
.L2078:
.L2079:
.L2072:
.L2080:
.L2081:
.L2082:
	ba	.L2083
	nop

	! block 37
.L2036:
.L2084:
.L2085:
.L2086:

! 1371	      }
! 1372	   }
! 1373	   else {
! 1374	      gl_error( ctx, GL_INVALID_ENUM, "glTexImage3DEXT(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2087),%l1
	or	%l1,%lo(.L2087),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 38
.L2088:

! 1375	      return;

	ba	.L1949
	nop

	! block 39
.L2089:
.L2090:
.L2083:
.L2091:
.L2092:
.L2033:
.L2093:

	! block 40
.L2094:
.L2095:
.L1949:
	jmp	%i7+8
	restore
	.size	gl_TexImage3DEXT,(.-gl_TexImage3DEXT)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_GetTexImage
	.type	gl_GetTexImage,#function
gl_GetTexImage:
	save	%sp,-96,%sp

	! block 1
.L2098:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L2099:
.L2101:

! File teximage.c:
! 1376	   }
! 1377	}
! 1378	
! 1381	void gl_GetTexImage( GLcontext *ctx, GLenum target, GLint level, GLenum format,
! 1382	                     GLenum type, GLvoid *pixels )
! 1383	{
! 1384	   gl_problem(ctx, "glGetTexImage not implemented");

	ld	[%fp+68],%l0
	sethi	%hi(.L2102),%l1
	or	%l1,%lo(.L2102),%l1
	mov	%l0,%o0
	call	gl_problem
	mov	%l1,%o1

	! block 3
.L2103:
.L2104:
.L2097:
	jmp	%i7+8
	restore
	.size	gl_GetTexImage,(.-gl_GetTexImage)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_unpack_texsubimage
	.type	gl_unpack_texsubimage,#function
gl_unpack_texsubimage:
	save	%sp,-104,%sp

	! block 1
.L2107:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]

	! block 2
.L2108:
.L2110:
.L2112:

! File teximage.c:
! 1385	   /* TODO */
! 1386	}
! 1387	
! 1391	/*
! 1392	 * Unpack the image data given to glTexSubImage[123]D.
! 1393	 * This function is just a wrapper for gl_unpack_image() but it does
! 1394	 * some extra error checking.
! 1395	 */
! 1396	struct gl_image *
! 1397	gl_unpack_texsubimage( GLcontext *ctx, GLint width, GLint height, GLint depth,
! 1398	                       GLenum format, GLenum type, const GLvoid *pixels )
! 1399	{
! 1400	   if (type==GL_BITMAP && format!=GL_COLOR_INDEX) {

	ld	[%fp+88],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	bne	.L2111
	nop

	! block 3
.L2113:
	ld	[%fp+84],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L2111
	nop

	! block 4
.L2114:
.L2115:
.L2116:
.L2117:

! 1401	      return NULL;

	ba	.L2106
	st	%g0,[%fp-4]

	! block 5
.L2118:
.L2119:
.L2111:
.L2120:
.L2121:
.L2123:

! 1402	   }
! 1403	
! 1404	   if (format==GL_STENCIL_INDEX || format==GL_DEPTH_COMPONENT){

	ld	[%fp+84],%l1
	sethi	%hi(0x1901),%l0
	or	%l0,%lo(0x1901),%l0
	cmp	%l1,%l0
	be	.L2124
	nop

	! block 6
.L2125:
	ld	[%fp+84],%l1
	sethi	%hi(0x1902),%l0
	or	%l0,%lo(0x1902),%l0
	cmp	%l1,%l0
	bne	.L2122
	nop

	! block 7
.L2126:
.L2124:
.L2127:
.L2128:
.L2129:

! 1405	      return NULL;

	ba	.L2106
	st	%g0,[%fp-4]

	! block 8
.L2130:
.L2131:
.L2122:
.L2132:
.L2133:
.L2135:

! 1406	   }
! 1407	
! 1408	   if (gl_sizeof_type(type)<=0) {

	ld	[%fp+88],%l0
	call	gl_sizeof_type
	mov	%l0,%o0
	cmp	%o0,0
	bg	.L2134
	nop

	! block 9
.L2136:
.L2137:
.L2138:
.L2139:

! 1409	      return NULL;

	ba	.L2106
	st	%g0,[%fp-4]

	! block 10
.L2140:
.L2141:
.L2134:
.L2142:
.L2143:

! 1410	   }
! 1411	
! 1412	   return gl_unpack_image3D( ctx, width, height, depth, format, type, pixels );

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+84],%l5
	ld	[%fp+88],%l6
	ld	[%fp+92],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	call	gl_unpack_image3D
	st	%l4,[%sp+92]
	ba	.L2106
	st	%o0,[%fp-4]

	! block 11

	! block 12
.L2144:
.L2145:
.L2106:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	gl_unpack_texsubimage,(.-gl_unpack_texsubimage)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexSubImage1D
	.type	gl_TexSubImage1D,#function
gl_TexSubImage1D:
	save	%sp,-120,%sp

	! block 1
.L2148:
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

	! block 2
.L2149:
.L2151:
.L2153:

! File teximage.c:
! 1413	}
! 1414	
! 1417	void gl_TexSubImage1D( GLcontext *ctx,
! 1418	                       GLenum target, GLint level, GLint xoffset,
! 1419	                       GLsizei width, GLenum format, GLenum type,
! 1420	                       struct gl_image *image )
! 1421	{
! 1422	   struct gl_texture_image *destTex;
! 1423	
! 1424	   if (target!=GL_TEXTURE_1D) {

	ld	[%fp+72],%l0
	cmp	%l0,3552
	be	.L2152
	nop

	! block 3
.L2154:
.L2155:
.L2156:
.L2157:

! 1425	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2158),%l1
	or	%l1,%lo(.L2158),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L2159:

! 1426	      return;

	ba	.L2147
	nop

	! block 5
.L2160:
.L2161:
.L2152:
.L2162:
.L2163:
.L2165:

! 1427	   }
! 1428	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L2166
	nop

	! block 6
.L2167:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L2164
	nop

	! block 7
.L2168:
.L2166:
.L2169:
.L2170:
.L2171:

! 1429	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2172),%l1
	or	%l1,%lo(.L2172),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 8
.L2173:

! 1430	      return;

	ba	.L2147
	nop

	! block 9
.L2174:
.L2175:
.L2164:
.L2176:
.L2177:

! 1431	   }
! 1432	
! 1433	   destTex = ctx->Texture.Current1D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 10
.L2178:
.L2180:

! 1434	   if (!destTex) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	bne	.L2179
	nop

	! block 11
.L2181:
.L2182:
.L2183:
.L2184:

! 1435	      gl_error( ctx, GL_INVALID_OPERATION, "glTexSubImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2185),%l1
	or	%l1,%lo(.L2185),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 12
.L2186:

! 1436	      return;

	ba	.L2147
	nop

	! block 13
.L2187:
.L2188:
.L2179:
.L2189:
.L2190:
.L2192:

! 1437	   }
! 1438	
! 1439	   if (xoffset < -destTex->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2191
	nop

	! block 14
.L2193:
.L2194:
.L2195:
.L2196:

! 1440	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage1D(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2197),%l1
	or	%l1,%lo(.L2197),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L2198:

! 1441	      return;

	ba	.L2147
	nop

	! block 16
.L2199:
.L2200:
.L2191:
.L2201:
.L2202:
.L2204:

! 1442	   }
! 1443	   if (xoffset + width > destTex->Width + destTex->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+84],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2203
	nop

	! block 17
.L2205:
.L2206:
.L2207:
.L2208:

! 1444	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage1D(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2209),%l1
	or	%l1,%lo(.L2209),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L2210:

! 1445	      return;

	ba	.L2147
	nop

	! block 19
.L2211:
.L2212:
.L2203:
.L2213:
.L2214:
.L2216:

! 1446	   }
! 1447	
! 1448	   if (image) {

	ld	[%fp+96],%l0
	cmp	%l0,%g0
	be	.L2215
	nop

	! block 20
.L2217:
.L2218:
.L2219:
.L2220:

! 1449	      /* unpacking must have been error-free */
! 1450	      GLint texcomponents = components_in_intformat(destTex->Format);

	ld	[%fp-4],%l0
	ld	[%l0+0],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 21
.L2221:
.L2223:

! 1452	      if (image->Type==GL_UNSIGNED_BYTE && texcomponents==image->Components) {

	ld	[%fp+96],%l0
	ld	[%l0+20],%l1
	sethi	%hi(0x1401),%l0
	or	%l0,%lo(0x1401),%l0
	cmp	%l1,%l0
	bne	.L2222
	nop

	! block 22
.L2224:
	ld	[%fp-8],%l1
	ld	[%fp+96],%l0
	ld	[%l0+12],%l0
	cmp	%l1,%l0
	bne	.L2222
	nop

	! block 23
.L2225:
.L2226:
.L2227:
.L2228:

! 1453	         /* Simple case, just byte copy image data into texture image */
! 1454	         /* row by row. */
! 1455	         GLubyte *dst = destTex->Data + texcomponents * xoffset;

	ld	[%fp-4],%l0
	ld	[%l0+52],%l2
	ld	[%fp-8],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-12]

	! block 24
.L2229:

! 1456	         GLubyte *src = (GLubyte *) image->Data;

	ld	[%fp+96],%l0
	ld	[%l0+24],%l0
	st	%l0,[%fp-16]

	! block 25
.L2230:

! 1457	         MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-12],%l2
	ld	[%fp-16],%l3
	ld	[%fp+84],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 26
.L2231:
.L2232:
	ba	.L2233
	nop

	! block 27
.L2222:
.L2234:
.L2235:
.L2236:

! 1458	      }
! 1459	      else {
! 1460	         /* General case, convert image pixels into texels, scale, bias, etc */
! 1461	         struct gl_texture_image *subTexImg = image_to_texture(ctx, image,
! 1462	                                        destTex->IntFormat, destTex->Border);

	ld	[%fp+68],%l1
	ld	[%fp+96],%l2
	ld	[%fp-4],%l0
	ld	[%l0+4],%l3
	ld	[%l0+8],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l3,%o2
	call	image_to_texture
	mov	%l0,%o3
	st	%o0,[%fp-12]

	! block 28
.L2237:

! 1463	         GLubyte *dst = destTex->Data + texcomponents * xoffset;

	ld	[%fp-4],%l0
	ld	[%l0+52],%l2
	ld	[%fp-8],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-16]

	! block 29
.L2238:

! 1464	         GLubyte *src = subTexImg->Data;

	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-20]

	! block 30
.L2239:

! 1465	         MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-16],%l2
	ld	[%fp-20],%l3
	ld	[%fp+84],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 31
.L2240:

! 1466	         gl_free_texture_image(subTexImg);

	ld	[%fp-12],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 32
.L2241:
.L2242:
.L2233:
.L2243:
.L2244:
.L2246:

! 1467	      }
! 1468	
! 1469	      /* if the image's reference count is zero, delete it now */
! 1470	      if (image->RefCount==0) {

	ld	[%fp+96],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L2245
	nop

	! block 33
.L2247:
.L2248:
.L2249:
.L2250:

! 1471	         gl_free_image(image);

	ld	[%fp+96],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 34
.L2251:
.L2252:
.L2245:
.L2253:
.L2254:

! 1472	      }
! 1473	
! 1474	      ctx->Texture.Current1D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 35
.L2255:
.L2257:

! 1476	      /* tell driver about change */
! 1477	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L2256
	nop

	! block 36
.L2258:
.L2259:
.L2260:
.L2261:

! 1478	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_1D,
! 1479	                                  ctx->Texture.Current1D,
! 1480	                                  level, ctx->Texture.Current1D->Image[level]->IntFormat,
! 1481					  destTex );

	ld	[%fp+68],%l2
	ld	[%l2+2396],%l4
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l2+%l1],%l3
	ld	[%fp+76],%l5
	sll	%l5,2,%l1
	add	%l3,%l1,%l0
	ld	[%l0+56],%l0
	ld	[%l0+4],%l0
	ld	[%fp-4],%l1
	mov	%l2,%o0
	mov	3552,%o1
	mov	%l3,%o2
	mov	%l5,%o3
	mov	%l0,%o4
	mov	%l1,%o5
	jmpl	%l4,%o7
	nop

	! block 37
.L2262:
.L2263:
.L2256:
.L2264:
.L2265:
.L2266:
	ba	.L2267
	nop

	! block 38
.L2215:
.L2268:
.L2269:
.L2270:
.L2272:

! 1482	      }
! 1483	   }
! 1484	   else {
! 1485	      /* if no image, an error must have occured, do more testing now */
! 1486	      GLint components, size;
! 1487	
! 1488	      if (width<0) {

	ld	[%fp+84],%l0
	cmp	%l0,0
	bge	.L2271
	nop

	! block 39
.L2273:
.L2274:
.L2275:
.L2276:

! 1489	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage1D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2277),%l1
	or	%l1,%lo(.L2277),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 40
.L2278:

! 1490	         return;

	ba	.L2147
	nop

	! block 41
.L2279:
.L2280:
.L2271:
.L2281:
.L2282:
.L2284:

! 1491	      }
! 1492	      if (type==GL_BITMAP && format!=GL_COLOR_INDEX) {

	ld	[%fp+92],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	bne	.L2283
	nop

	! block 42
.L2285:
	ld	[%fp+88],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L2283
	nop

	! block 43
.L2286:
.L2287:
.L2288:
.L2289:

! 1493	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2290),%l1
	or	%l1,%lo(.L2290),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 44
.L2291:

! 1494	         return;

	ba	.L2147
	nop

	! block 45
.L2292:
.L2293:
.L2283:
.L2294:
.L2295:

! 1495	      }
! 1496	      components = components_in_intformat( format );

	ld	[%fp+88],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 46
.L2296:
.L2298:

! 1497	      if (components<0 || format==GL_STENCIL_INDEX
! 1498	          || format==GL_DEPTH_COMPONENT){

	ld	[%fp-8],%l0
	cmp	%l0,0
	bl	.L2299
	nop

	! block 47
.L2300:
	ld	[%fp+88],%l1
	sethi	%hi(0x1901),%l0
	or	%l0,%lo(0x1901),%l0
	cmp	%l1,%l0
	be	.L2299
	nop

	! block 48
.L2301:
	ld	[%fp+88],%l1
	sethi	%hi(0x1902),%l0
	or	%l0,%lo(0x1902),%l0
	cmp	%l1,%l0
	bne	.L2297
	nop

	! block 49
.L2302:
.L2299:
.L2303:
.L2304:
.L2305:

! 1499	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2306),%l1
	or	%l1,%lo(.L2306),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 50
.L2307:

! 1500	         return;

	ba	.L2147
	nop

	! block 51
.L2308:
.L2309:
.L2297:
.L2310:
.L2311:

! 1501	      }
! 1502	      size = gl_sizeof_type( type );

	ld	[%fp+92],%l0
	call	gl_sizeof_type
	mov	%l0,%o0
	st	%o0,[%fp-12]

	! block 52
.L2312:
.L2314:

! 1503	      if (size<=0) {

	ld	[%fp-12],%l0
	cmp	%l0,0
	bg	.L2313
	nop

	! block 53
.L2315:
.L2316:
.L2317:
.L2318:

! 1504	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2319),%l1
	or	%l1,%lo(.L2319),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 54
.L2320:

! 1505	         return;

	ba	.L2147
	nop

	! block 55
.L2321:
.L2322:
.L2313:
.L2323:
.L2324:

! 1506	      }
! 1507	      /* if we get here, probably ran out of memory during unpacking */
! 1508	      gl_error( ctx, GL_OUT_OF_MEMORY, "glTexSubImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2325),%l1
	or	%l1,%lo(.L2325),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 56
.L2326:
.L2327:
.L2267:
.L2328:

	! block 57
.L2329:
.L2330:
.L2147:
	jmp	%i7+8
	restore
	.size	gl_TexSubImage1D,(.-gl_TexSubImage1D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexSubImage2D
	.type	gl_TexSubImage2D,#function
gl_TexSubImage2D:
	save	%sp,-120,%sp

	! block 1
.L2333:
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

	! block 2
.L2334:
.L2336:
.L2338:

! File teximage.c:
! 1509	   }
! 1510	}
! 1511	
! 1514	void gl_TexSubImage2D( GLcontext *ctx,
! 1515	                       GLenum target, GLint level,
! 1516	                       GLint xoffset, GLint yoffset,
! 1517	                       GLsizei width, GLsizei height,
! 1518	                       GLenum format, GLenum type,
! 1519	                       struct gl_image *image )
! 1520	{
! 1521	   struct gl_texture_image *destTex;
! 1522	
! 1523	   if (target!=GL_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	be	.L2337
	nop

	! block 3
.L2339:
.L2340:
.L2341:
.L2342:

! 1524	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage2D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2343),%l1
	or	%l1,%lo(.L2343),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L2344:

! 1525	      return;

	ba	.L2332
	nop

	! block 5
.L2345:
.L2346:
.L2337:
.L2347:
.L2348:
.L2350:

! 1526	   }
! 1527	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L2351
	nop

	! block 6
.L2352:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L2349
	nop

	! block 7
.L2353:
.L2351:
.L2354:
.L2355:
.L2356:

! 1528	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage2D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2357),%l1
	or	%l1,%lo(.L2357),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 8
.L2358:

! 1529	      return;

	ba	.L2332
	nop

	! block 9
.L2359:
.L2360:
.L2349:
.L2361:
.L2362:

! 1530	   }
! 1531	
! 1532	   destTex = ctx->Texture.Current2D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 10
.L2363:
.L2365:

! 1533	   if (!destTex) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	bne	.L2364
	nop

	! block 11
.L2366:
.L2367:
.L2368:
.L2369:

! 1534	      gl_error( ctx, GL_INVALID_OPERATION, "glTexSubImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2370),%l1
	or	%l1,%lo(.L2370),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 12
.L2371:

! 1535	      return;

	ba	.L2332
	nop

	! block 13
.L2372:
.L2373:
.L2364:
.L2374:
.L2375:
.L2377:

! 1536	   }
! 1537	
! 1538	   if (xoffset < -destTex->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2376
	nop

	! block 14
.L2378:
.L2379:
.L2380:
.L2381:

! 1539	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2382),%l1
	or	%l1,%lo(.L2382),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L2383:

! 1540	      return;

	ba	.L2332
	nop

	! block 16
.L2384:
.L2385:
.L2376:
.L2386:
.L2387:
.L2389:

! 1541	   }
! 1542	   if (yoffset < -destTex->Border) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2388
	nop

	! block 17
.L2390:
.L2391:
.L2392:
.L2393:

! 1543	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(yoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2394),%l1
	or	%l1,%lo(.L2394),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L2395:

! 1544	      return;

	ba	.L2332
	nop

	! block 19
.L2396:
.L2397:
.L2388:
.L2398:
.L2399:
.L2401:

! 1545	   }
! 1546	   if (xoffset + width > destTex->Width + destTex->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+88],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2400
	nop

	! block 20
.L2402:
.L2403:
.L2404:
.L2405:

! 1547	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2406),%l1
	or	%l1,%lo(.L2406),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 21
.L2407:

! 1548	      return;

	ba	.L2332
	nop

	! block 22
.L2408:
.L2409:
.L2400:
.L2410:
.L2411:
.L2413:

! 1549	   }
! 1550	   if (yoffset + height > destTex->Height + destTex->Border) {

	ld	[%fp+84],%l0
	ld	[%fp+92],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+16],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2412
	nop

	! block 23
.L2414:
.L2415:
.L2416:
.L2417:

! 1551	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(yoffset+height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2418),%l1
	or	%l1,%lo(.L2418),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 24
.L2419:

! 1552	      return;

	ba	.L2332
	nop

	! block 25
.L2420:
.L2421:
.L2412:
.L2422:
.L2423:
.L2425:

! 1553	   }
! 1554	
! 1555	   if (image) {

	ld	[%fp+104],%l0
	cmp	%l0,%g0
	be	.L2424
	nop

	! block 26
.L2426:
.L2427:
.L2428:
.L2429:

! 1556	      /* unpacking must have been error-free */
! 1557	      GLint texcomponents = components_in_intformat(destTex->Format);

	ld	[%fp-4],%l0
	ld	[%l0+0],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 27
.L2430:
.L2432:

! 1559	      if (image->Type==GL_UNSIGNED_BYTE && texcomponents==image->Components) {

	ld	[%fp+104],%l0
	ld	[%l0+20],%l1
	sethi	%hi(0x1401),%l0
	or	%l0,%lo(0x1401),%l0
	cmp	%l1,%l0
	bne	.L2431
	nop

	! block 28
.L2433:
	ld	[%fp-8],%l1
	ld	[%fp+104],%l0
	ld	[%l0+12],%l0
	cmp	%l1,%l0
	bne	.L2431
	nop

	! block 29
.L2434:
.L2435:
.L2436:
.L2437:

! 1560	         /* Simple case, just byte copy image data into texture image */
! 1561	         /* row by row. */
! 1562	         GLubyte *dst = destTex->Data 
! 1563	                      + (yoffset * destTex->Width + xoffset) * texcomponents;

	ld	[%fp-4],%l0
	ld	[%l0+52],%l3
	ld	[%fp+84],%l2
	ld	[%l0+12],%l1
	smul	%l2,%l1,%l0
	ld	[%fp+80],%l1
	add	%l0,%l1,%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l3,%l1,%l0
	st	%l0,[%fp-12]

	! block 30
.L2438:

! 1564	         GLubyte *src = (GLubyte *) image->Data;

	ld	[%fp+104],%l0
	ld	[%l0+24],%l0
	st	%l0,[%fp-16]

	! block 31
.L2439:
.L2440:

! 1565	         GLint  j;
! 1566	         for (j=0;j<height;j++) {

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bge	.L2443
	st	%g0,[%fp-20]

	! block 32
.L2444:
.L2441:
.L2445:
.L2446:
.L2447:

! 1567	            MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-12],%l2
	ld	[%fp-16],%l3
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 33
.L2448:

! 1568	            dst += destTex->Width * texcomponents * sizeof(GLubyte);

	ld	[%fp-12],%l2
	ld	[%fp-4],%l0
	ld	[%l0+12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-12]

	! block 34
.L2449:

! 1569	            src += width * texcomponents * sizeof(GLubyte);

	ld	[%fp-16],%l2
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-16]

	! block 35
.L2450:
.L2451:
.L2452:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	bl	.L2441
	nop

	! block 36
.L2453:
.L2443:
.L2454:
.L2455:
.L2456:
	ba	.L2457
	nop

	! block 37
.L2431:
.L2458:
.L2459:
.L2460:

! 1570	         }
! 1571	      }
! 1572	      else {
! 1573	         /* General case, convert image pixels into texels, scale, bias, etc */
! 1574	         struct gl_texture_image *subTexImg = image_to_texture(ctx, image,
! 1575	                                        destTex->IntFormat, destTex->Border);

	ld	[%fp+68],%l1
	ld	[%fp+104],%l2
	ld	[%fp-4],%l0
	ld	[%l0+4],%l3
	ld	[%l0+8],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l3,%o2
	call	image_to_texture
	mov	%l0,%o3
	st	%o0,[%fp-12]

	! block 38
.L2461:

! 1576	         GLubyte *dst = destTex->Data
! 1577	                  + (yoffset * destTex->Width + xoffset) * texcomponents;

	ld	[%fp-4],%l0
	ld	[%l0+52],%l3
	ld	[%fp+84],%l2
	ld	[%l0+12],%l1
	smul	%l2,%l1,%l0
	ld	[%fp+80],%l1
	add	%l0,%l1,%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l3,%l1,%l0
	st	%l0,[%fp-16]

	! block 39
.L2462:

! 1578	         GLubyte *src = subTexImg->Data;

	ld	[%fp-12],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-20]

	! block 40
.L2463:
.L2464:

! 1579	         GLint j;
! 1580	         for (j=0;j<height;j++) {

	ld	[%fp+92],%l0
	cmp	%g0,%l0
	bge	.L2467
	st	%g0,[%fp-24]

	! block 41
.L2468:
.L2465:
.L2469:
.L2470:
.L2471:

! 1581	            MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-16],%l2
	ld	[%fp-20],%l3
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 42
.L2472:

! 1582	            dst += destTex->Width * texcomponents * sizeof(GLubyte);

	ld	[%fp-16],%l2
	ld	[%fp-4],%l0
	ld	[%l0+12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-16]

	! block 43
.L2473:

! 1583	            src += width * texcomponents * sizeof(GLubyte);

	ld	[%fp-20],%l2
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 44
.L2474:
.L2475:
.L2476:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+92],%l0
	cmp	%l1,%l0
	bl	.L2465
	nop

	! block 45
.L2477:
.L2467:
.L2478:
.L2479:

! 1584	         }
! 1585	         gl_free_texture_image(subTexImg);

	ld	[%fp-12],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 46
.L2480:
.L2481:
.L2457:
.L2482:
.L2483:
.L2485:

! 1586	      }
! 1587	
! 1588	      /* if the image's reference count is zero, delete it now */
! 1589	      if (image->RefCount==0) {

	ld	[%fp+104],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L2484
	nop

	! block 47
.L2486:
.L2487:
.L2488:
.L2489:

! 1590	         gl_free_image(image);

	ld	[%fp+104],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 48
.L2490:
.L2491:
.L2484:
.L2492:
.L2493:

! 1591	      }
! 1592	
! 1593	      ctx->Texture.Current2D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 49
.L2494:
.L2496:

! 1595	      /* tell driver about change */
! 1596	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L2495
	nop

	! block 50
.L2497:
.L2498:
.L2499:
.L2500:

! 1597	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_2D, ctx->Texture.Current2D,
! 1598	                                  level, ctx->Texture.Current2D->Image[level]->IntFormat,
! 1599					  destTex );

	ld	[%fp+68],%l2
	ld	[%l2+2396],%l4
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l2+%l1],%l3
	ld	[%fp+76],%l5
	sll	%l5,2,%l1
	add	%l3,%l1,%l0
	ld	[%l0+56],%l0
	ld	[%l0+4],%l0
	ld	[%fp-4],%l1
	mov	%l2,%o0
	mov	3553,%o1
	mov	%l3,%o2
	mov	%l5,%o3
	mov	%l0,%o4
	mov	%l1,%o5
	jmpl	%l4,%o7
	nop

	! block 51
.L2501:
.L2502:
.L2495:
.L2503:
.L2504:
.L2505:
	ba	.L2506
	nop

	! block 52
.L2424:
.L2507:
.L2508:
.L2509:
.L2511:

! 1600	      }
! 1601	   }
! 1602	   else {
! 1603	      /* if no image, an error must have occured, do more testing now */
! 1604	      GLint components, size;
! 1605	
! 1606	      if (width<0) {

	ld	[%fp+88],%l0
	cmp	%l0,0
	bge	.L2510
	nop

	! block 53
.L2512:
.L2513:
.L2514:
.L2515:

! 1607	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2516),%l1
	or	%l1,%lo(.L2516),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 54
.L2517:

! 1608	         return;

	ba	.L2332
	nop

	! block 55
.L2518:
.L2519:
.L2510:
.L2520:
.L2521:
.L2523:

! 1609	      }
! 1610	      if (height<0) {

	ld	[%fp+92],%l0
	cmp	%l0,0
	bge	.L2522
	nop

	! block 56
.L2524:
.L2525:
.L2526:
.L2527:

! 1611	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage2D(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2528),%l1
	or	%l1,%lo(.L2528),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 57
.L2529:

! 1612	         return;

	ba	.L2332
	nop

	! block 58
.L2530:
.L2531:
.L2522:
.L2532:
.L2533:
.L2535:

! 1613	      }
! 1614	      if (type==GL_BITMAP && format!=GL_COLOR_INDEX) {

	ld	[%fp+100],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	bne	.L2534
	nop

	! block 59
.L2536:
	ld	[%fp+96],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L2534
	nop

	! block 60
.L2537:
.L2538:
.L2539:
.L2540:

! 1615	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage1D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2541),%l1
	or	%l1,%lo(.L2541),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 61
.L2542:

! 1616	         return;

	ba	.L2332
	nop

	! block 62
.L2543:
.L2544:
.L2534:
.L2545:
.L2546:

! 1617	      }
! 1618	      components = gl_components_in_format( format );

	ld	[%fp+96],%l0
	call	gl_components_in_format
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 63
.L2547:
.L2549:

! 1619	      if (components<0 || format==GL_STENCIL_INDEX
! 1620	          || format==GL_DEPTH_COMPONENT){

	ld	[%fp-8],%l0
	cmp	%l0,0
	bl	.L2550
	nop

	! block 64
.L2551:
	ld	[%fp+96],%l1
	sethi	%hi(0x1901),%l0
	or	%l0,%lo(0x1901),%l0
	cmp	%l1,%l0
	be	.L2550
	nop

	! block 65
.L2552:
	ld	[%fp+96],%l1
	sethi	%hi(0x1902),%l0
	or	%l0,%lo(0x1902),%l0
	cmp	%l1,%l0
	bne	.L2548
	nop

	! block 66
.L2553:
.L2550:
.L2554:
.L2555:
.L2556:

! 1621	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage2D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2557),%l1
	or	%l1,%lo(.L2557),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 67
.L2558:

! 1622	         return;

	ba	.L2332
	nop

	! block 68
.L2559:
.L2560:
.L2548:
.L2561:
.L2562:

! 1623	      }
! 1624	      size = gl_sizeof_type( type );

	ld	[%fp+100],%l0
	call	gl_sizeof_type
	mov	%l0,%o0
	st	%o0,[%fp-12]

	! block 69
.L2563:
.L2565:

! 1625	      if (size<=0) {

	ld	[%fp-12],%l0
	cmp	%l0,0
	bg	.L2564
	nop

	! block 70
.L2566:
.L2567:
.L2568:
.L2569:

! 1626	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage2D(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2570),%l1
	or	%l1,%lo(.L2570),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 71
.L2571:

! 1627	         return;

	ba	.L2332
	nop

	! block 72
.L2572:
.L2573:
.L2564:
.L2574:
.L2575:

! 1628	      }
! 1629	      /* if we get here, probably ran out of memory during unpacking */
! 1630	      gl_error( ctx, GL_OUT_OF_MEMORY, "glTexSubImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2576),%l1
	or	%l1,%lo(.L2576),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 73
.L2577:
.L2578:
.L2506:
.L2579:

	! block 74
.L2580:
.L2581:
.L2332:
	jmp	%i7+8
	restore
	.size	gl_TexSubImage2D,(.-gl_TexSubImage2D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_TexSubImage3DEXT
	.type	gl_TexSubImage3DEXT,#function
gl_TexSubImage3DEXT:
	save	%sp,-136,%sp

	! block 1
.L2584:
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
	ld	[%fp+112],%l0
	st	%l0,[%fp+112]

	! block 2
.L2585:
.L2587:
.L2589:

! File teximage.c:
! 1631	   }
! 1632	}
! 1633	
! 1636	void gl_TexSubImage3DEXT( GLcontext *ctx,
! 1637	                          GLenum target, GLint level,
! 1638	                          GLint xoffset, GLint yoffset, GLint zoffset,
! 1639	                          GLsizei width, GLsizei height, GLsizei depth,
! 1640	                          GLenum format, GLenum type,
! 1641	                          struct gl_image *image )
! 1642	{
! 1643	   struct gl_texture_image *destTex;
! 1644	
! 1645	   if (target!=GL_TEXTURE_3D_EXT) {

	ld	[%fp+72],%l1
	sethi	%hi(0x806f),%l0
	or	%l0,%lo(0x806f),%l0
	cmp	%l1,%l0
	be	.L2588
	nop

	! block 3
.L2590:
.L2591:
.L2592:
.L2593:

! 1646	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage3DEXT(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2594),%l1
	or	%l1,%lo(.L2594),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L2595:

! 1647	      return;

	ba	.L2583
	nop

	! block 5
.L2596:
.L2597:
.L2588:
.L2598:
.L2599:
.L2601:

! 1648	   }
! 1649	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L2602
	nop

	! block 6
.L2603:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L2600
	nop

	! block 7
.L2604:
.L2602:
.L2605:
.L2606:
.L2607:

! 1650	      gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage3DEXT(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2608),%l1
	or	%l1,%lo(.L2608),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 8
.L2609:

! 1651	      return;

	ba	.L2583
	nop

	! block 9
.L2610:
.L2611:
.L2600:
.L2612:
.L2613:

! 1652	   }
! 1653	
! 1654	   destTex = ctx->Texture.Current3D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 10
.L2614:
.L2616:

! 1655	   if (!destTex) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	bne	.L2615
	nop

	! block 11
.L2617:
.L2618:
.L2619:
.L2620:

! 1656	      gl_error( ctx, GL_INVALID_OPERATION, "glTexSubImage3DEXT" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2621),%l1
	or	%l1,%lo(.L2621),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 12
.L2622:

! 1657	      return;

	ba	.L2583
	nop

	! block 13
.L2623:
.L2624:
.L2615:
.L2625:
.L2626:
.L2628:

! 1658	   }
! 1659	
! 1660	   if (xoffset < -destTex->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2627
	nop

	! block 14
.L2629:
.L2630:
.L2631:
.L2632:

! 1661	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2633),%l1
	or	%l1,%lo(.L2633),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L2634:

! 1662	      return;

	ba	.L2583
	nop

	! block 16
.L2635:
.L2636:
.L2627:
.L2637:
.L2638:
.L2640:

! 1663	   }
! 1664	   if (yoffset < -destTex->Border) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2639
	nop

	! block 17
.L2641:
.L2642:
.L2643:
.L2644:

! 1665	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(yoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2645),%l1
	or	%l1,%lo(.L2645),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 18
.L2646:

! 1666	      return;

	ba	.L2583
	nop

	! block 19
.L2647:
.L2648:
.L2639:
.L2649:
.L2650:
.L2652:

! 1667	   }
! 1668	   if (zoffset < -destTex->Border) {

	ld	[%fp+88],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L2651
	nop

	! block 20
.L2653:
.L2654:
.L2655:
.L2656:

! 1669	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(zoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2657),%l1
	or	%l1,%lo(.L2657),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 21
.L2658:

! 1670	      return;

	ba	.L2583
	nop

	! block 22
.L2659:
.L2660:
.L2651:
.L2661:
.L2662:
.L2664:

! 1671	   }
! 1672	   if (xoffset + width > destTex->Width+destTex->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+92],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2663
	nop

	! block 23
.L2665:
.L2666:
.L2667:
.L2668:

! 1673	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2669),%l1
	or	%l1,%lo(.L2669),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 24
.L2670:

! 1674	      return;

	ba	.L2583
	nop

	! block 25
.L2671:
.L2672:
.L2663:
.L2673:
.L2674:
.L2676:

! 1675	   }
! 1676	   if (yoffset + height > destTex->Height+destTex->Border) {

	ld	[%fp+84],%l0
	ld	[%fp+96],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+16],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2675
	nop

	! block 26
.L2677:
.L2678:
.L2679:
.L2680:

! 1677	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(yoffset+height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2681),%l1
	or	%l1,%lo(.L2681),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 27
.L2682:

! 1678	      return;

	ba	.L2583
	nop

	! block 28
.L2683:
.L2684:
.L2675:
.L2685:
.L2686:
.L2688:

! 1679	   }
! 1680	   if (zoffset + depth  > destTex->Depth+destTex->Border) {

	ld	[%fp+88],%l0
	ld	[%fp+100],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+20],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L2687
	nop

	! block 29
.L2689:
.L2690:
.L2691:
.L2692:

! 1681	      gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(zoffset+depth)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2693),%l1
	or	%l1,%lo(.L2693),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 30
.L2694:

! 1682	      return;

	ba	.L2583
	nop

	! block 31
.L2695:
.L2696:
.L2687:
.L2697:
.L2698:
.L2700:

! 1683	   }
! 1684	
! 1685	   if (image) {

	ld	[%fp+112],%l0
	cmp	%l0,%g0
	be	.L2699
	nop

	! block 32
.L2701:
.L2702:
.L2703:
.L2704:

! 1686	      /* unpacking must have been error-free */
! 1687	      GLint texcomponents = components_in_intformat(destTex->Format);

	ld	[%fp-4],%l0
	ld	[%l0+0],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 33
.L2705:

! 1688	      GLint dstRectArea = destTex->Width * destTex->Height;

	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+16],%l1
	smul	%l2,%l1,%l0
	st	%l0,[%fp-12]

	! block 34
.L2706:

! 1689	      GLint srcRectArea = width * height;

	ld	[%fp+92],%l0
	ld	[%fp+96],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 35
.L2707:
.L2709:

! 1691	      if (image->Type==GL_UNSIGNED_BYTE && texcomponents==image->Components) {

	ld	[%fp+112],%l0
	ld	[%l0+20],%l1
	sethi	%hi(0x1401),%l0
	or	%l0,%lo(0x1401),%l0
	cmp	%l1,%l0
	bne	.L2708
	nop

	! block 36
.L2710:
	ld	[%fp-8],%l1
	ld	[%fp+112],%l0
	ld	[%l0+12],%l0
	cmp	%l1,%l0
	bne	.L2708
	nop

	! block 37
.L2711:
.L2712:
.L2713:
.L2714:

! 1692	         /* Simple case, just byte copy image data into texture image */
! 1693	         /* row by row. */
! 1694	         GLubyte *dst = destTex->Data 
! 1695	               + (zoffset * dstRectArea +  yoffset * destTex->Width + xoffset)
! 1696	               * texcomponents;

	ld	[%fp-4],%l2
	ld	[%l2+52],%l4
	ld	[%fp+88],%l0
	ld	[%fp-12],%l1
	smul	%l0,%l1,%l3
	ld	[%fp+84],%l0
	ld	[%l2+12],%l1
	smul	%l0,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%fp+80],%l1
	add	%l0,%l1,%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l4,%l1,%l0
	st	%l0,[%fp-20]

	! block 38
.L2715:

! 1697	         GLubyte *src = (GLubyte *) image->Data;

	ld	[%fp+112],%l0
	ld	[%l0+24],%l0
	st	%l0,[%fp-24]

	! block 39
.L2716:
.L2717:

! 1698	         GLint j, k;
! 1699	         for(k=0;k<depth; k++) {

	ld	[%fp+100],%l0
	cmp	%g0,%l0
	bge	.L2720
	st	%g0,[%fp-32]

	! block 40
.L2721:
.L2718:
.L2722:
.L2723:
.L2724:
.L2725:

! 1700	           for (j=0;j<height;j++) {

	ld	[%fp+96],%l0
	cmp	%g0,%l0
	bge	.L2728
	st	%g0,[%fp-28]

	! block 41
.L2729:
.L2726:
.L2730:
.L2731:
.L2732:

! 1701	              MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-20],%l2
	ld	[%fp-24],%l3
	ld	[%fp+92],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 42
.L2733:

! 1702	              dst += destTex->Width * texcomponents;

	ld	[%fp-20],%l2
	ld	[%fp-4],%l0
	ld	[%l0+12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 43
.L2734:

! 1703	              src += width * texcomponents;

	ld	[%fp-24],%l2
	ld	[%fp+92],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-24]

	! block 44
.L2735:
.L2736:
.L2737:
	ld	[%fp-28],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-28]
	ld	[%fp-28],%l1
	ld	[%fp+96],%l0
	cmp	%l1,%l0
	bl	.L2726
	nop

	! block 45
.L2738:
.L2728:
.L2739:
.L2740:

! 1704	           }
! 1705	           dst += dstRectArea * texcomponents * sizeof(GLubyte);

	ld	[%fp-20],%l2
	ld	[%fp-12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-20]

	! block 46
.L2741:

! 1706	           src += srcRectArea * texcomponents * sizeof(GLubyte);

	ld	[%fp-24],%l2
	ld	[%fp-16],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-24]

	! block 47
.L2742:
.L2743:
.L2744:
	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]
	ld	[%fp-32],%l1
	ld	[%fp+100],%l0
	cmp	%l1,%l0
	bl	.L2718
	nop

	! block 48
.L2745:
.L2720:
.L2746:
.L2747:
.L2748:
	ba	.L2749
	nop

	! block 49
.L2708:
.L2750:
.L2751:
.L2752:

! 1707	         }
! 1708	      }
! 1709	      else {
! 1710	         /* General case, convert image pixels into texels, scale, bias, etc */
! 1711	         struct gl_texture_image *subTexImg = image_to_texture(ctx, image,
! 1712	                                        destTex->IntFormat, destTex->Border);

	ld	[%fp+68],%l1
	ld	[%fp+112],%l2
	ld	[%fp-4],%l0
	ld	[%l0+4],%l3
	ld	[%l0+8],%l0
	mov	%l1,%o0
	mov	%l2,%o1
	mov	%l3,%o2
	call	image_to_texture
	mov	%l0,%o3
	st	%o0,[%fp-20]

	! block 50
.L2753:

! 1713	         GLubyte *dst = destTex->Data 
! 1714	               + (zoffset * dstRectArea +  yoffset * destTex->Width + xoffset)
! 1715	               * texcomponents;

	ld	[%fp-4],%l2
	ld	[%l2+52],%l4
	ld	[%fp+88],%l0
	ld	[%fp-12],%l1
	smul	%l0,%l1,%l3
	ld	[%fp+84],%l0
	ld	[%l2+12],%l1
	smul	%l0,%l1,%l1
	add	%l3,%l1,%l0
	ld	[%fp+80],%l1
	add	%l0,%l1,%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l4,%l1,%l0
	st	%l0,[%fp-24]

	! block 51
.L2754:

! 1716	         GLubyte *src = subTexImg->Data;

	ld	[%fp-20],%l0
	ld	[%l0+52],%l0
	st	%l0,[%fp-28]

	! block 52
.L2755:
.L2756:

! 1717	         GLint j, k;
! 1718	         for(k=0;k<depth; k++) {

	ld	[%fp+100],%l0
	cmp	%g0,%l0
	bge	.L2759
	st	%g0,[%fp-36]

	! block 53
.L2760:
.L2757:
.L2761:
.L2762:
.L2763:
.L2764:

! 1719	           for (j=0;j<height;j++) {

	ld	[%fp+96],%l0
	cmp	%g0,%l0
	bge	.L2767
	st	%g0,[%fp-32]

	! block 54
.L2768:
.L2765:
.L2769:
.L2770:
.L2771:

! 1720	              MEMCPY( dst, src, width * texcomponents );

	ld	[%fp-24],%l2
	ld	[%fp-28],%l3
	ld	[%fp+92],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	call	memcpy
	mov	%l0,%o2

	! block 55
.L2772:

! 1721	              dst += destTex->Width * texcomponents;

	ld	[%fp-24],%l2
	ld	[%fp-4],%l0
	ld	[%l0+12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-24]

	! block 56
.L2773:

! 1722	              src += width * texcomponents;

	ld	[%fp-28],%l2
	ld	[%fp+92],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-28]

	! block 57
.L2774:
.L2775:
.L2776:
	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]
	ld	[%fp-32],%l1
	ld	[%fp+96],%l0
	cmp	%l1,%l0
	bl	.L2765
	nop

	! block 58
.L2777:
.L2767:
.L2778:
.L2779:

! 1723	           }
! 1724	           dst += dstRectArea * texcomponents * sizeof(GLubyte);

	ld	[%fp-24],%l2
	ld	[%fp-12],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-24]

	! block 59
.L2780:

! 1725	           src += srcRectArea * texcomponents * sizeof(GLubyte);

	ld	[%fp-28],%l2
	ld	[%fp-16],%l0
	ld	[%fp-8],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	st	%l0,[%fp-28]

	! block 60
.L2781:
.L2782:
.L2783:
	ld	[%fp-36],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-36]
	ld	[%fp-36],%l1
	ld	[%fp+100],%l0
	cmp	%l1,%l0
	bl	.L2757
	nop

	! block 61
.L2784:
.L2759:
.L2785:
.L2786:

! 1726	         }
! 1727	         gl_free_texture_image(subTexImg);

	ld	[%fp-20],%l0
	call	gl_free_texture_image
	mov	%l0,%o0

	! block 62
.L2787:
.L2788:
.L2749:
.L2789:
.L2790:
.L2792:

! 1728	      }
! 1729	      /* if the image's reference count is zero, delete it now */
! 1730	      if (image->RefCount==0) {

	ld	[%fp+112],%l0
	ld	[%l0+32],%l0
	cmp	%l0,0
	bne	.L2791
	nop

	! block 63
.L2793:
.L2794:
.L2795:
.L2796:

! 1731	         gl_free_image(image);

	ld	[%fp+112],%l0
	call	gl_free_image
	mov	%l0,%o0

	! block 64
.L2797:
.L2798:
.L2791:
.L2799:
.L2800:

! 1732	      }
! 1733	
! 1734	      ctx->Texture.Current3D->Dirty = GL_TRUE;

	mov	1,%l2
	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l0
	stb	%l2,[%l0+1136]

	! block 65
.L2801:
.L2803:

! 1736	      /* tell driver about change */
! 1737	      if (ctx->Driver.TexImage) {

	ld	[%fp+68],%l0
	ld	[%l0+2396],%l0
	cmp	%l0,%g0
	be	.L2802
	nop

	! block 66
.L2804:
.L2805:
.L2806:
.L2807:

! 1738	         (*ctx->Driver.TexImage)( ctx, GL_TEXTURE_3D_EXT,
! 1739	                                  ctx->Texture.Current3D,
! 1740	                                  level, ctx->Texture.Current3D->Image[level]->IntFormat,
! 1741					  destTex );

	ld	[%fp+68],%l2
	ld	[%l2+2396],%l4
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l2+%l1],%l3
	ld	[%fp+76],%l5
	sll	%l5,2,%l1
	add	%l3,%l1,%l0
	ld	[%l0+56],%l0
	ld	[%l0+4],%l0
	ld	[%fp-4],%l1
	mov	%l2,%o0
	sethi	%hi(0x806f),%o1
	or	%o1,%lo(0x806f),%o1
	mov	%l3,%o2
	mov	%l5,%o3
	mov	%l0,%o4
	mov	%l1,%o5
	jmpl	%l4,%o7
	nop

	! block 67
.L2808:
.L2809:
.L2802:
.L2810:
.L2811:
.L2812:
	ba	.L2813
	nop

	! block 68
.L2699:
.L2814:
.L2815:
.L2816:
.L2818:

! 1742	      }
! 1743	   }
! 1744	   else {
! 1745	      /* if no image, an error must have occured, do more testing now */
! 1746	      GLint components, size;
! 1747	
! 1748	      if (width<0) {

	ld	[%fp+92],%l0
	cmp	%l0,0
	bge	.L2817
	nop

	! block 69
.L2819:
.L2820:
.L2821:
.L2822:

! 1749	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2823),%l1
	or	%l1,%lo(.L2823),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 70
.L2824:

! 1750	         return;

	ba	.L2583
	nop

	! block 71
.L2825:
.L2826:
.L2817:
.L2827:
.L2828:
.L2830:

! 1751	      }
! 1752	      if (height<0) {

	ld	[%fp+96],%l0
	cmp	%l0,0
	bge	.L2829
	nop

	! block 72
.L2831:
.L2832:
.L2833:
.L2834:

! 1753	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2835),%l1
	or	%l1,%lo(.L2835),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 73
.L2836:

! 1754	         return;

	ba	.L2583
	nop

	! block 74
.L2837:
.L2838:
.L2829:
.L2839:
.L2840:
.L2842:

! 1755	      }
! 1756	      if (depth<0) {

	ld	[%fp+100],%l0
	cmp	%l0,0
	bge	.L2841
	nop

	! block 75
.L2843:
.L2844:
.L2845:
.L2846:

! 1757	         gl_error( ctx, GL_INVALID_VALUE, "glTexSubImage3DEXT(depth)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2847),%l1
	or	%l1,%lo(.L2847),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 76
.L2848:

! 1758	         return;

	ba	.L2583
	nop

	! block 77
.L2849:
.L2850:
.L2841:
.L2851:
.L2852:
.L2854:

! 1759	      }
! 1760	      if (type==GL_BITMAP && format!=GL_COLOR_INDEX) {

	ld	[%fp+108],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	bne	.L2853
	nop

	! block 78
.L2855:
	ld	[%fp+104],%l1
	sethi	%hi(0x1900),%l0
	or	%l0,%lo(0x1900),%l0
	cmp	%l1,%l0
	be	.L2853
	nop

	! block 79
.L2856:
.L2857:
.L2858:
.L2859:

! 1761	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage3DEXT(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2860),%l1
	or	%l1,%lo(.L2860),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 80
.L2861:

! 1762	         return;

	ba	.L2583
	nop

	! block 81
.L2862:
.L2863:
.L2853:
.L2864:
.L2865:

! 1763	      }
! 1764	      components = components_in_intformat( format );

	ld	[%fp+104],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-8]

	! block 82
.L2866:
.L2868:

! 1765	      if (components<0 || format==GL_STENCIL_INDEX
! 1766	          || format==GL_DEPTH_COMPONENT){

	ld	[%fp-8],%l0
	cmp	%l0,0
	bl	.L2869
	nop

	! block 83
.L2870:
	ld	[%fp+104],%l1
	sethi	%hi(0x1901),%l0
	or	%l0,%lo(0x1901),%l0
	cmp	%l1,%l0
	be	.L2869
	nop

	! block 84
.L2871:
	ld	[%fp+104],%l1
	sethi	%hi(0x1902),%l0
	or	%l0,%lo(0x1902),%l0
	cmp	%l1,%l0
	bne	.L2867
	nop

	! block 85
.L2872:
.L2869:
.L2873:
.L2874:
.L2875:

! 1767	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage3DEXT(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2876),%l1
	or	%l1,%lo(.L2876),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 86
.L2877:

! 1768	         return;

	ba	.L2583
	nop

	! block 87
.L2878:
.L2879:
.L2867:
.L2880:
.L2881:

! 1769	      }
! 1770	      size = gl_sizeof_type( type );

	ld	[%fp+108],%l0
	call	gl_sizeof_type
	mov	%l0,%o0
	st	%o0,[%fp-12]

	! block 88
.L2882:
.L2884:

! 1771	      if (size<=0) {

	ld	[%fp-12],%l0
	cmp	%l0,0
	bg	.L2883
	nop

	! block 89
.L2885:
.L2886:
.L2887:
.L2888:

! 1772	         gl_error( ctx, GL_INVALID_ENUM, "glTexSubImage3DEXT(type)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2889),%l1
	or	%l1,%lo(.L2889),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 90
.L2890:

! 1773	         return;

	ba	.L2583
	nop

	! block 91
.L2891:
.L2892:
.L2883:
.L2893:
.L2894:

! 1774	      }
! 1775	      /* if we get here, probably ran out of memory during unpacking */
! 1776	      gl_error( ctx, GL_OUT_OF_MEMORY, "glTexSubImage3DEXT" );

	ld	[%fp+68],%l0
	sethi	%hi(.L2895),%l1
	or	%l1,%lo(.L2895),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 92
.L2896:
.L2897:
.L2813:
.L2898:

	! block 93
.L2899:
.L2900:
.L2583:
	jmp	%i7+8
	restore
	.size	gl_TexSubImage3DEXT,(.-gl_TexSubImage3DEXT)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	read_color_image,#function
read_color_image:
	sethi	%hi(-6552),%g1
	or	%g1,%lo(-6552),%g1
	save	%sp,%g1,%sp

	! block 1
.L2903:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L2904:
.L2906:

! File teximage.c:
! 1777	   }
! 1778	}
! 1779	
! 1782	/*
! 1783	 * Read an RGBA image from the frame buffer.
! 1784	 * Input:  ctx - the context
! 1785	 *         x, y - lower left corner
! 1786	 *         width, height - size of region to read
! 1787	 *         format - one of GL_RED, GL_RGB, GL_LUMINANCE, etc.
! 1788	 * Return: gl_image pointer or NULL if out of memory
! 1789	 */
! 1790	static struct gl_image *read_color_image( GLcontext *ctx, GLint x, GLint y,
! 1791	                                          GLsizei width, GLsizei height,
! 1792	                                          GLint format )
! 1793	{
! 1794	   struct gl_image *image;
! 1795	   GLubyte *imgptr;
! 1796	   GLint components;
! 1797	   GLint i, j;
! 1798	
! 1799	   components = components_in_intformat( format );

	ld	[%fp+88],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-16]

	! block 3
.L2907:

! 1801	   /*
! 1802	    * Allocate image struct and image data buffer
! 1803	    */
! 1804	   image = (struct gl_image *) malloc( sizeof(struct gl_image) );

	call	malloc
	mov	36,%o0
	st	%o0,[%fp-8]

	! block 4
.L2908:
.L2910:

! 1805	   if (image) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L2909
	nop

	! block 5
.L2911:
.L2912:
.L2913:
.L2914:

! 1806	      image->Width = width;

	ld	[%fp+80],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+0]

	! block 6
.L2915:

! 1807	      image->Height = height;

	ld	[%fp+84],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+4]

	! block 7
.L2916:

! 1808	      image->Depth = 1;

	mov	1,%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+8]

	! block 8
.L2917:

! 1809	      image->Components = components;

	ld	[%fp-16],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+12]

	! block 9
.L2918:

! 1810	      image->Format = format;

	ld	[%fp+88],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+16]

	! block 10
.L2919:

! 1811	      image->Type = GL_UNSIGNED_BYTE;

	sethi	%hi(0x1401),%l1
	or	%l1,%lo(0x1401),%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+20]

	! block 11
.L2920:

! 1812	      image->RefCount = 0;

	ld	[%fp-8],%l0
	st	%g0,[%l0+32]

	! block 12
.L2921:

! 1813	      image->Data = (GLubyte *) malloc( width * height * components );

	ld	[%fp+80],%l0
	ld	[%fp+84],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-16],%l1
	smul	%l0,%l1,%l0
	call	malloc
	mov	%l0,%o0
	ld	[%fp-8],%l0
	st	%o0,[%l0+24]

	! block 13
.L2922:
.L2924:

! 1814	      if (!image->Data) {

	ld	[%fp-8],%l0
	ld	[%l0+24],%l0
	cmp	%l0,%g0
	bne	.L2923
	nop

	! block 14
.L2925:
.L2926:
.L2927:
.L2928:

! 1815	         free(image);

	ld	[%fp-8],%l0
	call	free
	mov	%l0,%o0

	! block 15
.L2929:

! 1816	         return NULL;

	ba	.L2902
	st	%g0,[%fp-4]

	! block 16
.L2930:
.L2931:
.L2923:
.L2932:
.L2933:
.L2934:
	ba	.L2935
	nop

	! block 17
.L2909:
.L2936:
.L2937:
.L2938:

! 1817	      }
! 1818	   }
! 1819	   else {
! 1820	      return NULL;

	ba	.L2902
	st	%g0,[%fp-4]

	! block 18
.L2939:
.L2940:
.L2935:
.L2941:
.L2942:

! 1821	   }
! 1822	
! 1823	   imgptr = (GLubyte *) image->Data;

	ld	[%fp-8],%l0
	ld	[%l0+24],%l0
	st	%l0,[%fp-12]

	! block 19
.L2943:

! 1825	   /* Select buffer to read from */
! 1826	   (void) (*ctx->Driver.SetBuffer)( ctx, ctx->Pixel.ReadBuffer );

	ld	[%fp+68],%l0
	ld	[%l0+2236],%l2
	sethi	%hi(0xae18),%l1
	or	%l1,%lo(0xae18),%l1
	ld	[%l0+%l1],%l1
	mov	%l0,%o0
	mov	%l1,%o1
	jmpl	%l2,%o7
	nop

	! block 20
.L2944:
.L2945:

! 1828	   for (j=0;j<height;j++) {

	ld	[%fp+84],%l0
	cmp	%g0,%l0
	bge	.L2948
	st	%g0,[%fp-24]

	! block 21
.L2949:
.L2946:
.L2950:
.L2951:
.L2952:

! 1829	      GLubyte red[MAX_WIDTH], green[MAX_WIDTH];
! 1830	      GLubyte blue[MAX_WIDTH], alpha[MAX_WIDTH];
! 1831	      gl_read_color_span( ctx, width, x, y+j, red, green, blue, alpha );

	ld	[%fp+68],%l2
	ld	[%fp+80],%l3
	ld	[%fp+72],%l5
	ld	[%fp+76],%l0
	ld	[%fp-24],%l1
	add	%l0,%l1,%l1
	add	%fp,-1624,%l6
	add	%fp,-3224,%l7
	sethi	0x4,%l0
	xor	%l0,-728,%l0
	add	%fp,%l0,%i0
	sethi	0x6,%l0
	xor	%l0,-280,%l0
	add	%fp,%l0,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	mov	%l5,%o2
	mov	%l1,%o3
	mov	%l6,%o4
	mov	%l7,%o5
	st	%i0,[%sp+92]
	call	gl_read_color_span
	st	%l0,[%sp+96]

	! block 22
.L2953:
.L2955:

! 1833	      if (!ctx->Visual->EightBitColor) {

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+20],%l0
	cmp	%l0,%g0
	bne	.L2954
	nop

	! block 23
.L2956:
.L2957:
.L2958:
.L2959:

! 1834	         /* scale red, green, blue, alpha values to range [0,255] */
! 1835	         GLfloat rscale = 255.0f * ctx->Visual->InvRedScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-284,%l0
	st	%f4,[%fp+%l0]

	! block 24
.L2960:

! 1836	         GLfloat gscale = 255.0f * ctx->Visual->InvGreenScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-288,%l0
	st	%f4,[%fp+%l0]

	! block 25
.L2961:

! 1837	         GLfloat bscale = 255.0f * ctx->Visual->InvBlueScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-292,%l0
	st	%f4,[%fp+%l0]

	! block 26
.L2962:

! 1838	         GLfloat ascale = 255.0f * ctx->Visual->InvAlphaScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-296,%l0
	st	%f4,[%fp+%l0]

	! block 27
.L2963:
.L2964:

! 1839	         for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L2967
	st	%g0,[%fp-20]

	! block 28
.L_y42:
	mov	0,%l5
	sethi	0x6,%l6
	xor	%l6,-300,%l6
	sethi	0x6,%l7
	xor	%l7,-304,%l7
	sethi	%hi(0x43300000),%i0
	add	%fp,-1624,%l4
.L2968:
.L2965:
.L2969:
.L2970:
.L2971:

! 1840	            red[i]   = (GLubyte) (GLint) (red[i]   * rscale);

	ld	[%fp-20],%l1
	ldub	[%l4+%l1],%l0
	st	%i0,[%fp+%l7]
	st	%l0,[%fp+%l6]
	ldd	[%fp+%l7],%f6
	st	%l5,[%fp+%l6]
	ldd	[%fp+%l7],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-284,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l7]
	ld	[%fp+%l7],%l2
	ld	[%fp-20],%l1
	stb	%l2,[%l4+%l1]

	! block 29
.L2972:

! 1841	            green[i] = (GLubyte) (GLint) (green[i] * gscale);

	add	%fp,-3224,%l3
	ld	[%fp-20],%l1
	ldub	[%l3+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-288,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l0
	ld	[%fp-20],%l1
	stb	%l0,[%l3+%l1]

	! block 30
.L2973:

! 1842	            blue[i]  = (GLubyte) (GLint) (blue[i]  * bscale);

	sethi	0x4,%l3
	xor	%l3,-728,%l3
	add	%fp,%l3,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-292,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l2
	add	%fp,%l3,%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 31
.L2974:

! 1843	            alpha[i] = (GLubyte) (GLint) (alpha[i] * ascale);

	sethi	0x6,%l3
	xor	%l3,-280,%l3
	add	%fp,%l3,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-296,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l2
	add	%fp,%l3,%l0
	ld	[%fp-20],%l1
	stb	%l2,[%l0+%l1]

	! block 32
.L2975:
.L2976:
.L2977:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L2965
	nop

	! block 33
.L2978:
.L2967:
.L2979:
.L2980:
.L2981:
.L2954:
.L2982:
.L2983:
.L2986:

! 1844	         }
! 1845	      }
! 1846	
! 1847	      switch (format) {

	ba	.L2985
	nop

	! block 34
.L2987:
.L2988:
.L2989:
.L2990:
.L2991:

! 1848	         case GL_ALPHA:
! 1849	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L2994
	st	%g0,[%fp-20]

	! block 35
.L_y43:
	sethi	0x6,%l2
	xor	%l2,-280,%l2
.L2995:
.L2992:
.L2996:
.L2997:
.L2998:

! 1850	               *imgptr++ = alpha[i];

	add	%fp,%l2,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 36
.L2999:
.L3000:
.L3001:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L2992
	nop

	! block 37
.L3002:
.L2994:
.L3003:
.L3004:

! 1851	            }
! 1852	            break;

	ba	.L2984
	nop

	! block 38
.L3005:
.L3006:
.L3007:

! 1853	         case GL_LUMINANCE:
! 1854	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3010
	st	%g0,[%fp-20]

	! block 39
.L_y44:
	add	%fp,-1624,%l2
.L3011:
.L3008:
.L3012:
.L3013:
.L3014:

! 1855	               *imgptr++ = red[i];

	ld	[%fp-20],%l1
	ldub	[%l2+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 40
.L3015:
.L3016:
.L3017:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3008
	nop

	! block 41
.L3018:
.L3010:
.L3019:
.L3020:

! 1856	            }
! 1857	            break;

	ba	.L2984
	nop

	! block 42
.L3021:
.L3022:
.L3023:

! 1858	         case GL_LUMINANCE_ALPHA:
! 1859	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3026
	st	%g0,[%fp-20]

	! block 43
.L_y45:
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	add	%fp,-1624,%l3
.L3027:
.L3024:
.L3028:
.L3029:
.L3030:

! 1860	               *imgptr++ = red[i];

	ld	[%fp-20],%l1
	ldub	[%l3+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 44
.L3031:

! 1861	               *imgptr++ = alpha[i];

	add	%fp,%l2,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 45
.L3032:
.L3033:
.L3034:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3024
	nop

	! block 46
.L3035:
.L3026:
.L3036:
.L3037:

! 1862	            }
! 1863	            break;

	ba	.L2984
	nop

	! block 47
.L3038:
.L3039:
.L3040:

! 1864	         case GL_INTENSITY:
! 1865	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3043
	st	%g0,[%fp-20]

	! block 48
.L_y46:
	add	%fp,-1624,%l2
.L3044:
.L3041:
.L3045:
.L3046:
.L3047:

! 1866	               *imgptr++ = red[i];

	ld	[%fp-20],%l1
	ldub	[%l2+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 49
.L3048:
.L3049:
.L3050:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3041
	nop

	! block 50
.L3051:
.L3043:
.L3052:
.L3053:

! 1867	            }
! 1868	            break;

	ba	.L2984
	nop

	! block 51
.L3054:
.L3055:
.L3056:

! 1869	         case GL_RGB:
! 1870	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3059
	st	%g0,[%fp-20]

	! block 52
.L_y47:
	sethi	0x4,%l2
	xor	%l2,-728,%l2
	add	%fp,-3224,%l3
	add	%fp,-1624,%l4
.L3060:
.L3057:
.L3061:
.L3062:
.L3063:

! 1871	               *imgptr++ = red[i];

	ld	[%fp-20],%l1
	ldub	[%l4+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 53
.L3064:

! 1872	               *imgptr++ = green[i];

	ld	[%fp-20],%l1
	ldub	[%l3+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 54
.L3065:

! 1873	               *imgptr++ = blue[i];

	add	%fp,%l2,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 55
.L3066:
.L3067:
.L3068:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3057
	nop

	! block 56
.L3069:
.L3059:
.L3070:
.L3071:

! 1874	            }
! 1875	            break;

	ba	.L2984
	nop

	! block 57
.L3072:
.L3073:
.L3074:

! 1876	         case GL_RGBA:
! 1877	            for (i=0;i<width;i++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3077
	st	%g0,[%fp-20]

	! block 58
.L_y48:
	sethi	0x6,%l3
	xor	%l3,-280,%l3
	sethi	0x4,%l2
	xor	%l2,-728,%l2
	add	%fp,-3224,%l5
	add	%fp,-1624,%l4
.L3078:
.L3075:
.L3079:
.L3080:
.L3081:

! 1878	               *imgptr++ = red[i];

	ld	[%fp-20],%l1
	ldub	[%l4+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 59
.L3082:

! 1879	               *imgptr++ = green[i];

	ld	[%fp-20],%l1
	ldub	[%l5+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 60
.L3083:

! 1880	               *imgptr++ = blue[i];

	add	%fp,%l2,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 61
.L3084:

! 1881	               *imgptr++ = alpha[i];

	add	%fp,%l3,%l0
	ld	[%fp-20],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp-12],%l0
	stb	%l1,[%l0+0]
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 62
.L3085:
.L3086:
.L3087:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3075
	nop

	! block 63
.L3088:
.L3077:
.L3089:
.L3090:

! 1882	            }
! 1883	            break;

	ba	.L2984
	nop

	! block 64
.L3091:
.L3092:
.L2985:
.L3093:
	ld	[%fp+88],%l2
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	bge	.L_y37
	nop

	! block 65
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L3094
	nop

	! block 66
	sll	%l0,2,%l1
	sethi	%hi(.L_y38-20),%l0
	or	%l0,%lo(.L_y38-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 67
.L_y37:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	be	.L3038
	nop

	! block 68
.L3094:
.L2984:
.L3095:
.L3096:
.L3097:
.L3098:
	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]
	ld	[%fp-24],%l1
	ld	[%fp+84],%l0
	cmp	%l1,%l0
	bl	.L2946
	nop

	! block 69
.L3099:
.L2948:
.L3100:
.L3101:

! 1884	      } /*switch*/
! 1885	
! 1886	   } /*for*/         
! 1887	
! 1888	   /* Restore drawing buffer */
! 1889	   (void) (*ctx->Driver.SetBuffer)( ctx, ctx->Color.DrawBuffer );

	ld	[%fp+68],%l0
	ld	[%l0+2236],%l2
	sethi	%hi(0x1e9c),%l1
	or	%l1,%lo(0x1e9c),%l1
	ld	[%l0+%l1],%l1
	mov	%l0,%o0
	mov	%l1,%o1
	jmpl	%l2,%o7
	nop

	! block 70
.L3102:

! 1891	   return image;

	ld	[%fp-8],%l0
	ba	.L2902
	st	%l0,[%fp-4]

	! block 71

	! block 72
.L3103:
.L3104:
.L2902:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	read_color_image,(.-read_color_image)

	.word	.L2989
	.word	.L3054
	.word	.L3072
	.word	.L3005
	.word	.L3021
.L_y38:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_CopyTexImage1D
	.type	gl_CopyTexImage1D,#function
gl_CopyTexImage1D:
	save	%sp,-112,%sp

	! block 1
.L3107:
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

	! block 2
.L3108:
.L3110:
.L3112:

! File teximage.c:
! 1892	}
! 1893	
! 1897	void gl_CopyTexImage1D( GLcontext *ctx,
! 1898	                        GLenum target, GLint level,
! 1899	                        GLenum internalformat,
! 1900	                        GLint x, GLint y,
! 1901	                        GLsizei width, GLint border )
! 1902	{
! 1903	   GLint format;
! 1904	   struct gl_image *teximage;
! 1905	
! 1906	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3111
	nop

	! block 3
.L3113:
.L3114:
.L3115:
.L3116:

! 1907	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3117),%l1
	or	%l1,%lo(.L3117),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3118:

! 1908	      return;

	ba	.L3106
	nop

	! block 5
.L3119:
.L3120:
.L3111:
.L3121:
.L3122:
.L3124:

! 1909	   }
! 1910	   if (target!=GL_TEXTURE_1D) {

	ld	[%fp+72],%l0
	cmp	%l0,3552
	be	.L3123
	nop

	! block 6
.L3125:
.L3126:
.L3127:
.L3128:

! 1911	      gl_error( ctx, GL_INVALID_ENUM, "glCopyTexImage1D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3129),%l1
	or	%l1,%lo(.L3129),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3130:

! 1912	      return;

	ba	.L3106
	nop

	! block 8
.L3131:
.L3132:
.L3123:
.L3133:
.L3134:
.L3136:

! 1913	   }
! 1914	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L3137
	nop

	! block 9
.L3138:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L3135
	nop

	! block 10
.L3139:
.L3137:
.L3140:
.L3141:
.L3142:

! 1915	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage1D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3143),%l1
	or	%l1,%lo(.L3143),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3144:

! 1916	      return;

	ba	.L3106
	nop

	! block 12
.L3145:
.L3146:
.L3135:
.L3147:
.L3148:
.L3150:

! 1917	   }
! 1918	   if (border!=0 && border!=1) {

	ld	[%fp+96],%l0
	cmp	%l0,0
	be	.L3149
	nop

	! block 13
.L3151:
	ld	[%fp+96],%l0
	cmp	%l0,1
	be	.L3149
	nop

	! block 14
.L3152:
.L3153:
.L3154:
.L3155:

! 1919	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage1D(border)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3156),%l1
	or	%l1,%lo(.L3156),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L3157:

! 1920	      return;

	ba	.L3106
	nop

	! block 16
.L3158:
.L3159:
.L3149:
.L3160:
.L3161:
.L3163:

! 1921	   }
! 1922	   if (width<2*border || width>2+MAX_TEXTURE_SIZE || width<0) {

	ld	[%fp+92],%l1
	ld	[%fp+96],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L3164
	nop

	! block 17
.L3165:
	ld	[%fp+92],%l0
	cmp	%l0,1026
	bg	.L3164
	nop

	! block 18
.L3166:
	ld	[%fp+92],%l0
	cmp	%l0,0
	bge	.L3162
	nop

	! block 19
.L3167:
.L3164:
.L3168:
.L3169:
.L3170:

! 1923	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage1D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3171),%l1
	or	%l1,%lo(.L3171),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 20
.L3172:

! 1924	      return;

	ba	.L3106
	nop

	! block 21
.L3173:
.L3174:
.L3162:
.L3175:
.L3176:

! 1925	   }
! 1926	   format = decode_internal_format( internalformat );

	ld	[%fp+80],%l0
	call	decode_internal_format
	mov	%l0,%o0
	st	%o0,[%fp-4]

	! block 22
.L3177:
.L3179:

! 1927	   if (format<0 || (internalformat>=1 && internalformat<=4)) {

	ld	[%fp-4],%l0
	cmp	%l0,0
	bl	.L3180
	nop

	! block 23
.L3181:
	ld	[%fp+80],%l0
	cmp	%l0,1
	bl	.L3178
	nop

	! block 24
.L3182:
	ld	[%fp+80],%l0
	cmp	%l0,4
	bg	.L3178
	nop

	! block 25
.L3183:
.L3180:
.L3184:
.L3185:
.L3186:

! 1928	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage1D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3187),%l1
	or	%l1,%lo(.L3187),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 26
.L3188:

! 1929	      return;

	ba	.L3106
	nop

	! block 27
.L3189:
.L3190:
.L3178:
.L3191:
.L3192:

! 1930	   }
! 1931	
! 1932	   teximage = read_color_image( ctx, x, y, width, 1, format );

	ld	[%fp+68],%l0
	ld	[%fp+84],%l1
	ld	[%fp+88],%l2
	ld	[%fp+92],%l3
	ld	[%fp-4],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	1,%o4
	call	read_color_image
	mov	%l4,%o5
	st	%o0,[%fp-8]

	! block 28
.L3193:
.L3195:

! 1933	   if (!teximage) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	bne	.L3194
	nop

	! block 29
.L3196:
.L3197:
.L3198:
.L3199:

! 1934	      gl_error( ctx, GL_OUT_OF_MEMORY, "glCopyTexImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3200),%l1
	or	%l1,%lo(.L3200),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 30
.L3201:

! 1935	      return;

	ba	.L3106
	nop

	! block 31
.L3202:
.L3203:
.L3194:
.L3204:
.L3205:

! 1936	   }
! 1937	
! 1938	   gl_TexImage1D( ctx, target, level, internalformat, width,
! 1939	                  border, GL_RGBA, GL_UNSIGNED_BYTE, teximage );

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l6
	sethi	%hi(0x1908),%l7
	or	%l7,%lo(0x1908),%l7
	sethi	%hi(0x1401),%i0
	or	%i0,%lo(0x1401),%i0
	ld	[%fp-8],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	call	gl_TexImage1D
	st	%l4,[%sp+100]

	! block 32
.L3206:
.L3207:
.L3106:
	jmp	%i7+8
	restore
	.size	gl_CopyTexImage1D,(.-gl_CopyTexImage1D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_CopyTexImage2D
	.type	gl_CopyTexImage2D,#function
gl_CopyTexImage2D:
	save	%sp,-120,%sp

	! block 1
.L3210:
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
.L3211:
.L3213:
.L3215:

! File teximage.c:
! 1941	   /* teximage was freed in gl_TexImage1D */
! 1942	}
! 1943	
! 1946	void gl_CopyTexImage2D( GLcontext *ctx,
! 1947	                        GLenum target, GLint level, GLenum internalformat,
! 1948	                        GLint x, GLint y, GLsizei width, GLsizei height,
! 1949	                        GLint border )
! 1950	{
! 1951	   GLint format;
! 1952	   struct gl_image *teximage;
! 1953	
! 1954	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3214
	nop

	! block 3
.L3216:
.L3217:
.L3218:
.L3219:

! 1955	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3220),%l1
	or	%l1,%lo(.L3220),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3221:

! 1956	      return;

	ba	.L3209
	nop

	! block 5
.L3222:
.L3223:
.L3214:
.L3224:
.L3225:
.L3227:

! 1957	   }
! 1958	   if (target!=GL_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	be	.L3226
	nop

	! block 6
.L3228:
.L3229:
.L3230:
.L3231:

! 1959	      gl_error( ctx, GL_INVALID_ENUM, "glCopyTexImage2D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3232),%l1
	or	%l1,%lo(.L3232),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3233:

! 1960	      return;

	ba	.L3209
	nop

	! block 8
.L3234:
.L3235:
.L3226:
.L3236:
.L3237:
.L3239:

! 1961	   }
! 1962	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L3240
	nop

	! block 9
.L3241:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L3238
	nop

	! block 10
.L3242:
.L3240:
.L3243:
.L3244:
.L3245:

! 1963	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage2D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3246),%l1
	or	%l1,%lo(.L3246),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3247:

! 1964	      return;

	ba	.L3209
	nop

	! block 12
.L3248:
.L3249:
.L3238:
.L3250:
.L3251:
.L3253:

! 1965	   }
! 1966	   if (border!=0 && border!=1) {

	ld	[%fp+100],%l0
	cmp	%l0,0
	be	.L3252
	nop

	! block 13
.L3254:
	ld	[%fp+100],%l0
	cmp	%l0,1
	be	.L3252
	nop

	! block 14
.L3255:
.L3256:
.L3257:
.L3258:

! 1967	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage2D(border)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3259),%l1
	or	%l1,%lo(.L3259),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 15
.L3260:

! 1968	      return;

	ba	.L3209
	nop

	! block 16
.L3261:
.L3262:
.L3252:
.L3263:
.L3264:
.L3266:

! 1969	   }
! 1970	   if (width<2*border || width>2+MAX_TEXTURE_SIZE || width<0) {

	ld	[%fp+92],%l1
	ld	[%fp+100],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L3267
	nop

	! block 17
.L3268:
	ld	[%fp+92],%l0
	cmp	%l0,1026
	bg	.L3267
	nop

	! block 18
.L3269:
	ld	[%fp+92],%l0
	cmp	%l0,0
	bge	.L3265
	nop

	! block 19
.L3270:
.L3267:
.L3271:
.L3272:
.L3273:

! 1971	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage2D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3274),%l1
	or	%l1,%lo(.L3274),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 20
.L3275:

! 1972	      return;

	ba	.L3209
	nop

	! block 21
.L3276:
.L3277:
.L3265:
.L3278:
.L3279:
.L3281:

! 1973	   }
! 1974	   if (height<2*border || height>2+MAX_TEXTURE_SIZE || height<0) {

	ld	[%fp+96],%l1
	ld	[%fp+100],%l0
	sll	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L3282
	nop

	! block 22
.L3283:
	ld	[%fp+96],%l0
	cmp	%l0,1026
	bg	.L3282
	nop

	! block 23
.L3284:
	ld	[%fp+96],%l0
	cmp	%l0,0
	bge	.L3280
	nop

	! block 24
.L3285:
.L3282:
.L3286:
.L3287:
.L3288:

! 1975	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage2D(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3289),%l1
	or	%l1,%lo(.L3289),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 25
.L3290:

! 1976	      return;

	ba	.L3209
	nop

	! block 26
.L3291:
.L3292:
.L3280:
.L3293:
.L3294:

! 1977	   }
! 1978	   format = decode_internal_format( internalformat );

	ld	[%fp+80],%l0
	call	decode_internal_format
	mov	%l0,%o0
	st	%o0,[%fp-4]

	! block 27
.L3295:
.L3297:

! 1979	   if (format<0 || (internalformat>=1 && internalformat<=4)) {

	ld	[%fp-4],%l0
	cmp	%l0,0
	bl	.L3298
	nop

	! block 28
.L3299:
	ld	[%fp+80],%l0
	cmp	%l0,1
	bl	.L3296
	nop

	! block 29
.L3300:
	ld	[%fp+80],%l0
	cmp	%l0,4
	bg	.L3296
	nop

	! block 30
.L3301:
.L3298:
.L3302:
.L3303:
.L3304:

! 1980	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexImage2D(format)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3305),%l1
	or	%l1,%lo(.L3305),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 31
.L3306:

! 1981	      return;

	ba	.L3209
	nop

	! block 32
.L3307:
.L3308:
.L3296:
.L3309:
.L3310:

! 1982	   }
! 1983	
! 1984	   teximage = read_color_image( ctx, x, y, width, height, format );

	ld	[%fp+68],%l0
	ld	[%fp+84],%l1
	ld	[%fp+88],%l2
	ld	[%fp+92],%l3
	ld	[%fp+96],%l5
	ld	[%fp-4],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	call	read_color_image
	mov	%l4,%o5
	st	%o0,[%fp-8]

	! block 33
.L3311:
.L3313:

! 1985	   if (!teximage) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	bne	.L3312
	nop

	! block 34
.L3314:
.L3315:
.L3316:
.L3317:

! 1986	      gl_error( ctx, GL_OUT_OF_MEMORY, "glCopyTexImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3318),%l1
	or	%l1,%lo(.L3318),%l1
	mov	%l0,%o0
	mov	1285,%o1
	call	gl_error
	mov	%l1,%o2

	! block 35
.L3319:

! 1987	      return;

	ba	.L3209
	nop

	! block 36
.L3320:
.L3321:
.L3312:
.L3322:
.L3323:

! 1988	   }
! 1989	
! 1990	   gl_TexImage2D( ctx, target, level, internalformat, width, height,
! 1991	                  border, GL_RGBA, GL_UNSIGNED_BYTE, teximage );

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	ld	[%fp+76],%l2
	ld	[%fp+80],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l6
	ld	[%fp+100],%l7
	sethi	%hi(0x1908),%i0
	or	%i0,%lo(0x1908),%i0
	sethi	%hi(0x1401),%i1
	or	%i1,%lo(0x1401),%i1
	ld	[%fp-8],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	st	%i1,[%sp+100]
	call	gl_TexImage2D
	st	%l4,[%sp+104]

	! block 37
.L3324:
.L3325:
.L3209:
	jmp	%i7+8
	restore
	.size	gl_CopyTexImage2D,(.-gl_CopyTexImage2D)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	copy_tex_sub_image,#function
copy_tex_sub_image:
	sethi	%hi(-6552),%g1
	or	%g1,%lo(-6552),%g1
	save	%sp,%g1,%sp

	! block 1
.L3328:
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
.L3329:
.L3331:

! File teximage.c:
! 1993	   /* teximage was freed in gl_TexImage2D */
! 1994	}
! 1995	
! 1999	/*
! 2000	 * Do the work of glCopyTexSubImage[12]D.
! 2001	 * TODO: apply pixel bias scale and mapping.
! 2002	 */
! 2003	static void copy_tex_sub_image( GLcontext *ctx, struct gl_texture_image *dest,
! 2004	                                GLint width, GLint height,
! 2005	                                GLint srcx, GLint srcy,
! 2006	                                GLint dstx, GLint dsty, GLint zoffset )
! 2007	{
! 2008	   GLint i, j;
! 2009	   GLint format, components, rectarea;
! 2010	
! 2011	   rectarea = width*height;

	ld	[%fp+76],%l0
	ld	[%fp+80],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp-20]

	! block 3
.L3332:

! 2012	   zoffset *= rectarea; 

	ld	[%fp+100],%l0
	ld	[%fp-20],%l1
	smul	%l0,%l1,%l0
	st	%l0,[%fp+100]

	! block 4
.L3333:

! 2013	   format = dest->Format;

	ld	[%fp+72],%l0
	ld	[%l0+0],%l0
	st	%l0,[%fp-12]

	! block 5
.L3334:

! 2014	   components = components_in_intformat( format );

	ld	[%fp-12],%l0
	call	components_in_intformat
	mov	%l0,%o0
	st	%o0,[%fp-16]

	! block 6
.L3335:
.L3336:

! 2016	   for (j=0;j<height;j++) {

	ld	[%fp+80],%l0
	cmp	%g0,%l0
	bge	.L3339
	st	%g0,[%fp-8]

	! block 7
.L3340:
.L3337:
.L3341:
.L3342:
.L3343:

! 2017	      GLubyte red[MAX_WIDTH], green[MAX_WIDTH];
! 2018	      GLubyte blue[MAX_WIDTH], alpha[MAX_WIDTH];
! 2019	      GLubyte *texptr;
! 2020	
! 2021	      gl_read_color_span( ctx, width, srcx, srcy+j, red, green, blue, alpha );

	ld	[%fp+68],%l2
	ld	[%fp+76],%l3
	ld	[%fp+84],%l5
	ld	[%fp+88],%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l1
	add	%fp,-1620,%l6
	add	%fp,-3220,%l7
	sethi	0x4,%l0
	xor	%l0,-724,%l0
	add	%fp,%l0,%i0
	sethi	0x6,%l0
	xor	%l0,-276,%l0
	add	%fp,%l0,%l0
	mov	%l2,%o0
	mov	%l3,%o1
	mov	%l5,%o2
	mov	%l1,%o3
	mov	%l6,%o4
	mov	%l7,%o5
	st	%i0,[%sp+92]
	call	gl_read_color_span
	st	%l0,[%sp+96]

	! block 8
.L3344:
.L3346:

! 2023	      if (!ctx->Visual->EightBitColor) {

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ldub	[%l0+20],%l0
	cmp	%l0,%g0
	bne	.L3345
	nop

	! block 9
.L3347:
.L3348:
.L3349:
.L3350:

! 2024	         /* scale red, green, blue, alpha values to range [0,255] */
! 2025	         GLfloat rscale = 255.0f * ctx->Visual->InvRedScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+24],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-284,%l0
	st	%f4,[%fp+%l0]

	! block 10
.L3351:

! 2026	         GLfloat gscale = 255.0f * ctx->Visual->InvGreenScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+28],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-288,%l0
	st	%f4,[%fp+%l0]

	! block 11
.L3352:

! 2027	         GLfloat bscale = 255.0f * ctx->Visual->InvBlueScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+32],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-292,%l0
	st	%f4,[%fp+%l0]

	! block 12
.L3353:

! 2028	         GLfloat ascale = 255.0f * ctx->Visual->InvAlphaScale;

	ld	[%fp+68],%l0
	ld	[%l0+2200],%l0
	ld	[%l0+36],%f5
	sethi	%hi(.L_cseg2),%l0
	ld	[%l0+%lo(.L_cseg2)],%f4
	fmuls	%f5,%f4,%f4
	sethi	0x6,%l0
	xor	%l0,-296,%l0
	st	%f4,[%fp+%l0]

	! block 13
.L3354:
.L3355:

! 2029	         for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3358
	st	%g0,[%fp-4]

	! block 14
.L_y49:
	mov	0,%l5
	sethi	0x6,%l6
	xor	%l6,-300,%l6
	sethi	0x6,%l7
	xor	%l7,-304,%l7
	sethi	%hi(0x43300000),%i0
	add	%fp,-1620,%l4
.L3359:
.L3356:
.L3360:
.L3361:
.L3362:

! 2030	            red[i]   = (GLubyte) (GLint) (red[i]   * rscale);

	ld	[%fp-4],%l1
	ldub	[%l4+%l1],%l0
	st	%i0,[%fp+%l7]
	st	%l0,[%fp+%l6]
	ldd	[%fp+%l7],%f6
	st	%l5,[%fp+%l6]
	ldd	[%fp+%l7],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-284,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l7]
	ld	[%fp+%l7],%l2
	ld	[%fp-4],%l1
	stb	%l2,[%l4+%l1]

	! block 15
.L3363:

! 2031	            green[i] = (GLubyte) (GLint) (green[i] * gscale);

	add	%fp,-3220,%l3
	ld	[%fp-4],%l1
	ldub	[%l3+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-288,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l0
	ld	[%fp-4],%l1
	stb	%l0,[%l3+%l1]

	! block 16
.L3364:

! 2032	            blue[i]  = (GLubyte) (GLint) (blue[i]  * bscale);

	sethi	0x4,%l3
	xor	%l3,-724,%l3
	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-292,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l2
	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 17
.L3365:

! 2033	            alpha[i] = (GLubyte) (GLint) (alpha[i] * ascale);

	sethi	0x6,%l3
	xor	%l3,-276,%l3
	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	sethi	%hi(0x43300000),%l0
	sethi	0x6,%l2
	xor	%l2,-304,%l2
	st	%l0,[%fp+%l2]
	sethi	0x6,%l0
	xor	%l0,-300,%l0
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f6
	mov	0,%l1
	st	%l1,[%fp+%l0]
	ldd	[%fp+%l2],%f4
	fsubd	%f6,%f4,%f4
	fabss	%f4,%f4
	fdtos	%f4,%f5
	sethi	0x6,%l0
	xor	%l0,-296,%l0
	ld	[%fp+%l0],%f4
	fmuls	%f5,%f4,%f4
	fstoi	%f4,%f4
	st	%f4,[%fp+%l2]
	ld	[%fp+%l2],%l2
	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 18
.L3366:
.L3367:
.L3368:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3356
	nop

	! block 19
.L3369:
.L3358:
.L3370:
.L3371:
.L3372:
.L3345:
.L3373:
.L3374:

! 2034	         }
! 2035	      }
! 2036	
! 2037	      texptr = dest->Data + ( zoffset + (dsty+j) * width + dstx) * components;

	ld	[%fp+72],%l0
	ld	[%l0+52],%l3
	ld	[%fp+100],%l2
	ld	[%fp+96],%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	ld	[%fp+76],%l1
	smul	%l0,%l1,%l1
	add	%l2,%l1,%l0
	ld	[%fp+92],%l1
	add	%l0,%l1,%l0
	ld	[%fp-16],%l1
	smul	%l0,%l1,%l1
	add	%l3,%l1,%l1
	sethi	0x6,%l0
	xor	%l0,-280,%l0
	st	%l1,[%fp+%l0]

	! block 20
.L3375:
.L3378:

! 2039	      switch (format) {

	ba	.L3377
	nop

	! block 21
.L3379:
.L3380:
.L3381:
.L3382:
.L3383:

! 2040	         case GL_ALPHA:
! 2041	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3386
	st	%g0,[%fp-4]

	! block 22
.L_y50:
	sethi	0x6,%l3
	xor	%l3,-280,%l3
	sethi	0x6,%l2
	xor	%l2,-276,%l2
.L3387:
.L3384:
.L3388:
.L3389:
.L3390:

! 2042	               *texptr++ = alpha[i];

	add	%fp,%l2,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+%l3],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l3],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l3]

	! block 23
.L3391:
.L3392:
.L3393:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3384
	nop

	! block 24
.L3394:
.L3386:
.L3395:
.L3396:

! 2043	            }
! 2044	            break;

	ba	.L3376
	nop

	! block 25
.L3397:
.L3398:
.L3399:

! 2045	         case GL_LUMINANCE:
! 2046	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3402
	st	%g0,[%fp-4]

	! block 26
.L_y51:
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	add	%fp,-1620,%l3
.L3403:
.L3400:
.L3404:
.L3405:
.L3406:

! 2047	               *texptr++ = red[i];

	ld	[%fp-4],%l1
	ldub	[%l3+%l1],%l1
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 27
.L3407:
.L3408:
.L3409:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3400
	nop

	! block 28
.L3410:
.L3402:
.L3411:
.L3412:

! 2048	            }
! 2049	            break;

	ba	.L3376
	nop

	! block 29
.L3413:
.L3414:
.L3415:

! 2050	         case GL_LUMINANCE_ALPHA:
! 2051	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3418
	st	%g0,[%fp-4]

	! block 30
.L_y52:
	sethi	0x6,%l3
	xor	%l3,-280,%l3
	sethi	0x6,%l5
	xor	%l5,-276,%l5
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	add	%fp,-1620,%l4
.L3419:
.L3416:
.L3420:
.L3421:
.L3422:

! 2052	               *texptr++ = red[i];

	ld	[%fp-4],%l1
	ldub	[%l4+%l1],%l1
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 31
.L3423:

! 2053	               *texptr++ = alpha[i];

	add	%fp,%l5,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	ld	[%fp+%l3],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l3],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l3]

	! block 32
.L3424:
.L3425:
.L3426:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3416
	nop

	! block 33
.L3427:
.L3418:
.L3428:
.L3429:

! 2054	            }
! 2055	            break;

	ba	.L3376
	nop

	! block 34
.L3430:
.L3431:
.L3432:

! 2056	         case GL_INTENSITY:
! 2057	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3435
	st	%g0,[%fp-4]

	! block 35
.L_y53:
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	add	%fp,-1620,%l3
.L3436:
.L3433:
.L3437:
.L3438:
.L3439:

! 2058	               *texptr++ = red[i];

	ld	[%fp-4],%l1
	ldub	[%l3+%l1],%l1
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 36
.L3440:
.L3441:
.L3442:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3433
	nop

	! block 37
.L3443:
.L3435:
.L3444:
.L3445:

! 2059	            }
! 2060	            break;

	ba	.L3376
	nop

	! block 38
.L3446:
.L3447:
.L3448:

! 2061	         case GL_RGB:
! 2062	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3451
	st	%g0,[%fp-4]

	! block 39
.L_y54:
	sethi	0x4,%l3
	xor	%l3,-724,%l3
	sethi	0x6,%l5
	xor	%l5,-280,%l5
	add	%fp,-3220,%l6
	sethi	0x6,%l7
	xor	%l7,-280,%l7
	add	%fp,-1620,%l4
.L3452:
.L3449:
.L3453:
.L3454:
.L3455:

! 2063	               *texptr++ = red[i];

	ld	[%fp-4],%l1
	ldub	[%l4+%l1],%l1
	ld	[%fp+%l7],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l7],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l7]

	! block 40
.L3456:

! 2064	               *texptr++ = green[i];

	ld	[%fp-4],%l1
	ldub	[%l6+%l1],%l1
	ld	[%fp+%l5],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l5],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l5]

	! block 41
.L3457:

! 2065	               *texptr++ = blue[i];

	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 42
.L3458:
.L3459:
.L3460:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3449
	nop

	! block 43
.L3461:
.L3451:
.L3462:
.L3463:

! 2066	            }
! 2067	            break;

	ba	.L3376
	nop

	! block 44
.L3464:
.L3465:
.L3466:

! 2068	         case GL_RGBA:
! 2069	            for (i=0;i<width;i++) {

	ld	[%fp+76],%l0
	cmp	%g0,%l0
	bge	.L3469
	st	%g0,[%fp-4]

	! block 45
.L_y55:
	sethi	0x4,%l3
	xor	%l3,-724,%l3
	sethi	0x6,%l5
	xor	%l5,-280,%l5
	add	%fp,-3220,%l6
	sethi	0x6,%l7
	xor	%l7,-280,%l7
	add	%fp,-1620,%l4
.L3470:
.L3467:
.L3471:
.L3472:
.L3473:

! 2070	               *texptr++ = red[i];

	ld	[%fp-4],%l1
	ldub	[%l4+%l1],%l1
	ld	[%fp+%l7],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l7],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l7]

	! block 46
.L3474:

! 2071	               *texptr++ = green[i];

	ld	[%fp-4],%l1
	ldub	[%l6+%l1],%l1
	ld	[%fp+%l5],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l5],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l5]

	! block 47
.L3475:

! 2072	               *texptr++ = blue[i];

	add	%fp,%l3,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 48
.L3476:

! 2073	               *texptr++ = alpha[i];

	sethi	0x6,%l0
	xor	%l0,-276,%l0
	add	%fp,%l0,%l0
	ld	[%fp-4],%l1
	ldub	[%l0+%l1],%l1
	sethi	0x6,%l2
	xor	%l2,-280,%l2
	ld	[%fp+%l2],%l0
	stb	%l1,[%l0+0]
	ld	[%fp+%l2],%l0
	add	%l0,1,%l0
	st	%l0,[%fp+%l2]

	! block 49
.L3477:
.L3478:
.L3479:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+76],%l0
	cmp	%l1,%l0
	bl	.L3467
	nop

	! block 50
.L3480:
.L3469:
.L3481:
.L3482:

! 2074	            }
! 2075	            break;

	ba	.L3376
	nop

	! block 51
.L3483:
.L3484:
.L3377:
.L3485:
	ld	[%fp-12],%l2
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	bge	.L_y39
	nop

	! block 52
	sethi	%hi(0x1906),%l1
	or	%l1,%lo(0x1906),%l1
	sub	%l2,%l1,%l0
	cmp	%l0,4
	bgu	.L3486
	nop

	! block 53
	sll	%l0,2,%l1
	sethi	%hi(.L_y40-20),%l0
	or	%l0,%lo(.L_y40-20),%l0
	ld	[%l0+%l1],%l0
	jmp	%l0
	nop

	! block 54
.L_y39:
	sethi	%hi(0x8049),%l0
	or	%l0,%lo(0x8049),%l0
	cmp	%l2,%l0
	be	.L3430
	nop

	! block 55
.L3486:
.L3376:
.L3487:
.L3488:
.L3489:
.L3490:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	ld	[%fp+80],%l0
	cmp	%l1,%l0
	bl	.L3337
	nop

	! block 56
.L3491:
.L3339:
.L3492:

	! block 57
.L3493:
.L3494:
.L3327:
	jmp	%i7+8
	restore
	.size	copy_tex_sub_image,(.-copy_tex_sub_image)

	.word	.L3381
	.word	.L3446
	.word	.L3464
	.word	.L3397
	.word	.L3413
.L_y40:
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_CopyTexSubImage1D
	.type	gl_CopyTexSubImage1D,#function
gl_CopyTexSubImage1D:
	save	%sp,-112,%sp

	! block 1
.L3497:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]
	ld	[%fp+92],%l0
	st	%l0,[%fp+92]

	! block 2
.L3498:
.L3500:
.L3502:

! File teximage.c:
! 2076	      } /*switch*/
! 2077	   } /*for*/         
! 2078	}
! 2079	
! 2083	void gl_CopyTexSubImage1D( GLcontext *ctx,
! 2084	                              GLenum target, GLint level,
! 2085	                              GLint xoffset, GLint x, GLint y, GLsizei width )
! 2086	{
! 2087	   struct gl_texture_image *teximage;
! 2088	
! 2089	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3501
	nop

	! block 3
.L3503:
.L3504:
.L3505:
.L3506:

! 2090	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3507),%l1
	or	%l1,%lo(.L3507),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3508:

! 2091	      return;

	ba	.L3496
	nop

	! block 5
.L3509:
.L3510:
.L3501:
.L3511:
.L3512:
.L3514:

! 2092	   }
! 2093	   if (target!=GL_TEXTURE_1D) {

	ld	[%fp+72],%l0
	cmp	%l0,3552
	be	.L3513
	nop

	! block 6
.L3515:
.L3516:
.L3517:
.L3518:

! 2094	      gl_error( ctx, GL_INVALID_ENUM, "glCopyTexSubImage1D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3519),%l1
	or	%l1,%lo(.L3519),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3520:

! 2095	      return;

	ba	.L3496
	nop

	! block 8
.L3521:
.L3522:
.L3513:
.L3523:
.L3524:
.L3526:

! 2096	   }
! 2097	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L3527
	nop

	! block 9
.L3528:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L3525
	nop

	! block 10
.L3529:
.L3527:
.L3530:
.L3531:
.L3532:

! 2098	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage1D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3533),%l1
	or	%l1,%lo(.L3533),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3534:

! 2099	      return;

	ba	.L3496
	nop

	! block 12
.L3535:
.L3536:
.L3525:
.L3537:
.L3538:
.L3540:

! 2100	   }
! 2101	   if (width<0) {

	ld	[%fp+92],%l0
	cmp	%l0,0
	bge	.L3539
	nop

	! block 13
.L3541:
.L3542:
.L3543:
.L3544:

! 2102	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage1D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3545),%l1
	or	%l1,%lo(.L3545),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 14
.L3546:

! 2103	      return;

	ba	.L3496
	nop

	! block 15
.L3547:
.L3548:
.L3539:
.L3549:
.L3550:

! 2104	   }
! 2105	
! 2106	   teximage = ctx->Texture.Current1D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd820),%l1
	or	%l1,%lo(0xd820),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 16
.L3551:
.L3553:

! 2108	   if (teximage) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L3552
	nop

	! block 17
.L3554:
.L3555:
.L3556:
.L3557:
.L3559:

! 2109	      if (xoffset < -teximage->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3558
	nop

	! block 18
.L3560:
.L3561:
.L3562:
.L3563:

! 2110	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage1D(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3564),%l1
	or	%l1,%lo(.L3564),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 19
.L3565:

! 2111	         return;

	ba	.L3496
	nop

	! block 20
.L3566:
.L3567:
.L3558:
.L3568:
.L3569:
.L3571:

! 2112	      }
! 2113	      /* NOTE: we're adding the border here, not subtracting! */
! 2114	      if (xoffset+width > teximage->Width+teximage->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+92],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3570
	nop

	! block 21
.L3572:
.L3573:
.L3574:
.L3575:

! 2115	         gl_error( ctx, GL_INVALID_VALUE,
! 2116	                   "glCopyTexSubImage1D(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3576),%l1
	or	%l1,%lo(.L3576),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 22
.L3577:

! 2117	         return;

	ba	.L3496
	nop

	! block 23
.L3578:
.L3579:
.L3570:
.L3580:
.L3581:
.L3583:

! 2118	      }
! 2119	      if (teximage->Data) {

	ld	[%fp-4],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	be	.L3582
	nop

	! block 24
.L3584:
.L3585:
.L3586:
.L3587:

! 2120	         copy_tex_sub_image( ctx, teximage, width, 1, x, y, xoffset, 0, 0 );

	ld	[%fp+68],%l0
	ld	[%fp-4],%l1
	ld	[%fp+92],%l2
	ld	[%fp+84],%l3
	ld	[%fp+88],%l5
	ld	[%fp+80],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	1,%o3
	mov	%l3,%o4
	mov	%l5,%o5
	st	%l4,[%sp+92]
	st	%g0,[%sp+96]
	call	copy_tex_sub_image
	st	%g0,[%sp+100]

	! block 25
.L3588:
.L3589:
.L3582:
.L3590:
.L3591:
.L3592:
	ba	.L3593
	nop

	! block 26
.L3552:
.L3594:
.L3595:
.L3596:

! 2121	      }
! 2122	   }
! 2123	   else {
! 2124	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage1D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3597),%l1
	or	%l1,%lo(.L3597),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 27
.L3598:
.L3599:
.L3593:
.L3600:

	! block 28
.L3601:
.L3602:
.L3496:
	jmp	%i7+8
	restore
	.size	gl_CopyTexSubImage1D,(.-gl_CopyTexSubImage1D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_CopyTexSubImage2D
	.type	gl_CopyTexSubImage2D,#function
gl_CopyTexSubImage2D:
	save	%sp,-112,%sp

	! block 1
.L3605:
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
.L3606:
.L3608:
.L3610:

! File teximage.c:
! 2125	   }
! 2126	}
! 2127	
! 2130	void gl_CopyTexSubImage2D( GLcontext *ctx,
! 2131	                              GLenum target, GLint level,
! 2132	                              GLint xoffset, GLint yoffset,
! 2133	                              GLint x, GLint y, GLsizei width, GLsizei height )
! 2134	{
! 2135	   struct gl_texture_image *teximage;
! 2136	
! 2137	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3609
	nop

	! block 3
.L3611:
.L3612:
.L3613:
.L3614:

! 2138	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3615),%l1
	or	%l1,%lo(.L3615),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3616:

! 2139	      return;

	ba	.L3604
	nop

	! block 5
.L3617:
.L3618:
.L3609:
.L3619:
.L3620:
.L3622:

! 2140	   }
! 2141	   if (target!=GL_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	be	.L3621
	nop

	! block 6
.L3623:
.L3624:
.L3625:
.L3626:

! 2142	      gl_error( ctx, GL_INVALID_ENUM, "glCopyTexSubImage2D(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3627),%l1
	or	%l1,%lo(.L3627),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3628:

! 2143	      return;

	ba	.L3604
	nop

	! block 8
.L3629:
.L3630:
.L3621:
.L3631:
.L3632:
.L3634:

! 2144	   }
! 2145	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L3635
	nop

	! block 9
.L3636:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L3633
	nop

	! block 10
.L3637:
.L3635:
.L3638:
.L3639:
.L3640:

! 2146	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage2D(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3641),%l1
	or	%l1,%lo(.L3641),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3642:

! 2147	      return;

	ba	.L3604
	nop

	! block 12
.L3643:
.L3644:
.L3633:
.L3645:
.L3646:
.L3648:

! 2148	   }
! 2149	   if (width<0) {

	ld	[%fp+96],%l0
	cmp	%l0,0
	bge	.L3647
	nop

	! block 13
.L3649:
.L3650:
.L3651:
.L3652:

! 2150	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage2D(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3653),%l1
	or	%l1,%lo(.L3653),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 14
.L3654:

! 2151	      return;

	ba	.L3604
	nop

	! block 15
.L3655:
.L3656:
.L3647:
.L3657:
.L3658:
.L3660:

! 2152	   }
! 2153	   if (height<0) {

	ld	[%fp+100],%l0
	cmp	%l0,0
	bge	.L3659
	nop

	! block 16
.L3661:
.L3662:
.L3663:
.L3664:

! 2154	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage2D(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3665),%l1
	or	%l1,%lo(.L3665),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 17
.L3666:

! 2155	      return;

	ba	.L3604
	nop

	! block 18
.L3667:
.L3668:
.L3659:
.L3669:
.L3670:

! 2156	   }
! 2157	
! 2158	   teximage = ctx->Texture.Current2D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd824),%l1
	or	%l1,%lo(0xd824),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 19
.L3671:
.L3673:

! 2160	   if (teximage) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L3672
	nop

	! block 20
.L3674:
.L3675:
.L3676:
.L3677:
.L3679:

! 2161	      if (xoffset < -teximage->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3678
	nop

	! block 21
.L3680:
.L3681:
.L3682:
.L3683:

! 2162	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage2D(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3684),%l1
	or	%l1,%lo(.L3684),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 22
.L3685:

! 2163	         return;

	ba	.L3604
	nop

	! block 23
.L3686:
.L3687:
.L3678:
.L3688:
.L3689:
.L3691:

! 2164	      }
! 2165	      if (yoffset < -teximage->Border) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3690
	nop

	! block 24
.L3692:
.L3693:
.L3694:
.L3695:

! 2166	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage2D(yoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3696),%l1
	or	%l1,%lo(.L3696),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 25
.L3697:

! 2167	         return;

	ba	.L3604
	nop

	! block 26
.L3698:
.L3699:
.L3690:
.L3700:
.L3701:
.L3703:

! 2168	      }
! 2169	      /* NOTE: we're adding the border here, not subtracting! */
! 2170	      if (xoffset+width > teximage->Width+teximage->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+96],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3702
	nop

	! block 27
.L3704:
.L3705:
.L3706:
.L3707:

! 2171	         gl_error( ctx, GL_INVALID_VALUE,
! 2172	                   "glCopyTexSubImage2D(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3708),%l1
	or	%l1,%lo(.L3708),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 28
.L3709:

! 2173	         return;

	ba	.L3604
	nop

	! block 29
.L3710:
.L3711:
.L3702:
.L3712:
.L3713:
.L3715:

! 2174	      }
! 2175	      if (yoffset+height > teximage->Height+teximage->Border) {

	ld	[%fp+84],%l0
	ld	[%fp+100],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+16],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3714
	nop

	! block 30
.L3716:
.L3717:
.L3718:
.L3719:

! 2176	         gl_error( ctx, GL_INVALID_VALUE,
! 2177	                   "glCopyTexSubImage2D(yoffset+height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3720),%l1
	or	%l1,%lo(.L3720),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 31
.L3721:

! 2178	         return;

	ba	.L3604
	nop

	! block 32
.L3722:
.L3723:
.L3714:
.L3724:
.L3725:
.L3727:

! 2179	      }
! 2180	
! 2181	      if (teximage->Data) {

	ld	[%fp-4],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	be	.L3726
	nop

	! block 33
.L3728:
.L3729:
.L3730:
.L3731:

! 2182	         copy_tex_sub_image( ctx, teximage, width, height,
! 2183	                             x, y, xoffset, yoffset, 0 );

	ld	[%fp+68],%l0
	ld	[%fp-4],%l1
	ld	[%fp+96],%l2
	ld	[%fp+100],%l3
	ld	[%fp+88],%l5
	ld	[%fp+92],%l6
	ld	[%fp+80],%l7
	ld	[%fp+84],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%l4,[%sp+96]
	call	copy_tex_sub_image
	st	%g0,[%sp+100]

	! block 34
.L3732:
.L3733:
.L3726:
.L3734:
.L3735:
.L3736:
	ba	.L3737
	nop

	! block 35
.L3672:
.L3738:
.L3739:
.L3740:

! 2184	      }
! 2185	   }
! 2186	   else {
! 2187	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage2D" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3741),%l1
	or	%l1,%lo(.L3741),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 36
.L3742:
.L3743:
.L3737:
.L3744:

	! block 37
.L3745:
.L3746:
.L3604:
	jmp	%i7+8
	restore
	.size	gl_CopyTexSubImage2D,(.-gl_CopyTexSubImage2D)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	gl_CopyTexSubImage3DEXT
	.type	gl_CopyTexSubImage3DEXT,#function
gl_CopyTexSubImage3DEXT:
	save	%sp,-112,%sp

	! block 1
.L3749:
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

	! block 2
.L3750:
.L3752:
.L3754:

! File teximage.c:
! 2188	   }
! 2189	}
! 2190	
! 2193	void gl_CopyTexSubImage3DEXT( GLcontext *ctx,
! 2194	                              GLenum target, GLint level,
! 2195	                              GLint xoffset, GLint yoffset, GLint zoffset,
! 2196	                              GLint x, GLint y, GLsizei width, GLsizei height )
! 2197	{
! 2198	   struct gl_texture_image *teximage;
! 2199	
! 2200	   if (INSIDE_BEGIN_END(ctx)) {

	ld	[%fp+68],%l0
	sethi	%hi(0xe0fc),%l1
	or	%l1,%lo(0xe0fc),%l1
	ld	[%l0+%l1],%l1
	sethi	%hi(0x1a00),%l0
	or	%l0,%lo(0x1a00),%l0
	cmp	%l1,%l0
	be	.L3753
	nop

	! block 3
.L3755:
.L3756:
.L3757:
.L3758:

! 2201	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage3DEXT" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3759),%l1
	or	%l1,%lo(.L3759),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 4
.L3760:

! 2202	      return;

	ba	.L3748
	nop

	! block 5
.L3761:
.L3762:
.L3753:
.L3763:
.L3764:
.L3766:

! 2203	   }
! 2204	   if (target!=GL_TEXTURE_2D) {

	ld	[%fp+72],%l0
	cmp	%l0,3553
	be	.L3765
	nop

	! block 6
.L3767:
.L3768:
.L3769:
.L3770:

! 2205	      gl_error( ctx, GL_INVALID_ENUM, "glCopyTexSubImage3DEXT(target)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3771),%l1
	or	%l1,%lo(.L3771),%l1
	mov	%l0,%o0
	mov	1280,%o1
	call	gl_error
	mov	%l1,%o2

	! block 7
.L3772:

! 2206	      return;

	ba	.L3748
	nop

	! block 8
.L3773:
.L3774:
.L3765:
.L3775:
.L3776:
.L3778:

! 2207	   }
! 2208	   if (level<0 || level>=MAX_TEXTURE_LEVELS) {

	ld	[%fp+76],%l0
	cmp	%l0,0
	bl	.L3779
	nop

	! block 9
.L3780:
	ld	[%fp+76],%l0
	cmp	%l0,11
	bl	.L3777
	nop

	! block 10
.L3781:
.L3779:
.L3782:
.L3783:
.L3784:

! 2209	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(level)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3785),%l1
	or	%l1,%lo(.L3785),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 11
.L3786:

! 2210	      return;

	ba	.L3748
	nop

	! block 12
.L3787:
.L3788:
.L3777:
.L3789:
.L3790:
.L3792:

! 2211	   }
! 2212	   if (width<0) {

	ld	[%fp+100],%l0
	cmp	%l0,0
	bge	.L3791
	nop

	! block 13
.L3793:
.L3794:
.L3795:
.L3796:

! 2213	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3797),%l1
	or	%l1,%lo(.L3797),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 14
.L3798:

! 2214	      return;

	ba	.L3748
	nop

	! block 15
.L3799:
.L3800:
.L3791:
.L3801:
.L3802:
.L3804:

! 2215	   }
! 2216	   if (height<0) {

	ld	[%fp+104],%l0
	cmp	%l0,0
	bge	.L3803
	nop

	! block 16
.L3805:
.L3806:
.L3807:
.L3808:

! 2217	      gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3809),%l1
	or	%l1,%lo(.L3809),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 17
.L3810:

! 2218	      return;

	ba	.L3748
	nop

	! block 18
.L3811:
.L3812:
.L3803:
.L3813:
.L3814:

! 2219	   }
! 2220	
! 2221	   teximage = ctx->Texture.Current3D->Image[level];

	ld	[%fp+68],%l0
	sethi	%hi(0xd828),%l1
	or	%l1,%lo(0xd828),%l1
	ld	[%l0+%l1],%l2
	ld	[%fp+76],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+56],%l0
	st	%l0,[%fp-4]

	! block 19
.L3815:
.L3817:

! 2222	   if (teximage) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L3816
	nop

	! block 20
.L3818:
.L3819:
.L3820:
.L3821:
.L3823:

! 2223	      if (xoffset < -teximage->Border) {

	ld	[%fp+80],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3822
	nop

	! block 21
.L3824:
.L3825:
.L3826:
.L3827:

! 2224	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(xoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3828),%l1
	or	%l1,%lo(.L3828),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 22
.L3829:

! 2225	         return;

	ba	.L3748
	nop

	! block 23
.L3830:
.L3831:
.L3822:
.L3832:
.L3833:
.L3835:

! 2226	      }
! 2227	      if (yoffset < -teximage->Border) {

	ld	[%fp+84],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3834
	nop

	! block 24
.L3836:
.L3837:
.L3838:
.L3839:

! 2228	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(yoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3840),%l1
	or	%l1,%lo(.L3840),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 25
.L3841:

! 2229	         return;

	ba	.L3748
	nop

	! block 26
.L3842:
.L3843:
.L3834:
.L3844:
.L3845:
.L3847:

! 2230	      }
! 2231	      if (zoffset < -teximage->Border) {

	ld	[%fp+88],%l1
	ld	[%fp-4],%l0
	ld	[%l0+8],%l0
	neg	%l0,%l0
	cmp	%l1,%l0
	bgeu	.L3846
	nop

	! block 27
.L3848:
.L3849:
.L3850:
.L3851:

! 2232	         gl_error( ctx, GL_INVALID_VALUE, "glCopyTexSubImage3DEXT(zoffset)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3852),%l1
	or	%l1,%lo(.L3852),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 28
.L3853:

! 2233	         return;

	ba	.L3748
	nop

	! block 29
.L3854:
.L3855:
.L3846:
.L3856:
.L3857:
.L3859:

! 2234	      }
! 2235	      /* NOTE: we're adding the border here, not subtracting! */
! 2236	      if (xoffset+width > teximage->Width+teximage->Border) {

	ld	[%fp+80],%l0
	ld	[%fp+100],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+12],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3858
	nop

	! block 30
.L3860:
.L3861:
.L3862:
.L3863:

! 2237	         gl_error( ctx, GL_INVALID_VALUE,
! 2238	                   "glCopyTexSubImage3DEXT(xoffset+width)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3864),%l1
	or	%l1,%lo(.L3864),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 31
.L3865:

! 2239	         return;

	ba	.L3748
	nop

	! block 32
.L3866:
.L3867:
.L3858:
.L3868:
.L3869:
.L3871:

! 2240	      }
! 2241	      if (yoffset+height > teximage->Height+teximage->Border) {

	ld	[%fp+84],%l0
	ld	[%fp+104],%l1
	add	%l0,%l1,%l3
	ld	[%fp-4],%l0
	ld	[%l0+16],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3870
	nop

	! block 33
.L3872:
.L3873:
.L3874:
.L3875:

! 2242	         gl_error( ctx, GL_INVALID_VALUE,
! 2243	                   "glCopyTexSubImage3DEXT(yoffset+height)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3876),%l1
	or	%l1,%lo(.L3876),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 34
.L3877:

! 2244	         return;

	ba	.L3748
	nop

	! block 35
.L3878:
.L3879:
.L3870:
.L3880:
.L3881:
.L3883:

! 2245	      }
! 2246	      if (zoffset > teximage->Depth+teximage->Border) {

	ld	[%fp+88],%l3
	ld	[%fp-4],%l0
	ld	[%l0+20],%l2
	ld	[%l0+8],%l1
	add	%l2,%l1,%l0
	cmp	%l3,%l0
	bleu	.L3882
	nop

	! block 36
.L3884:
.L3885:
.L3886:
.L3887:

! 2247	         gl_error( ctx, GL_INVALID_VALUE,
! 2248	                   "glCopyTexSubImage3DEXT(zoffset+depth)" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3888),%l1
	or	%l1,%lo(.L3888),%l1
	mov	%l0,%o0
	mov	1281,%o1
	call	gl_error
	mov	%l1,%o2

	! block 37
.L3889:

! 2249	         return;

	ba	.L3748
	nop

	! block 38
.L3890:
.L3891:
.L3882:
.L3892:
.L3893:
.L3895:

! 2250	      }
! 2251	
! 2252	      if (teximage->Data) {

	ld	[%fp-4],%l0
	ld	[%l0+52],%l0
	cmp	%l0,%g0
	be	.L3894
	nop

	! block 39
.L3896:
.L3897:
.L3898:
.L3899:

! 2253	         copy_tex_sub_image( ctx, teximage, width, height, 
! 2254	                             x, y, xoffset, yoffset, zoffset);

	ld	[%fp+68],%l0
	ld	[%fp-4],%l1
	ld	[%fp+100],%l2
	ld	[%fp+104],%l3
	ld	[%fp+92],%l5
	ld	[%fp+96],%l6
	ld	[%fp+80],%l7
	ld	[%fp+84],%i0
	ld	[%fp+88],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	mov	%l6,%o5
	st	%l7,[%sp+92]
	st	%i0,[%sp+96]
	call	copy_tex_sub_image
	st	%l4,[%sp+100]

	! block 40
.L3900:
.L3901:
.L3894:
.L3902:
.L3903:
.L3904:
	ba	.L3905
	nop

	! block 41
.L3816:
.L3906:
.L3907:
.L3908:

! 2255	      }
! 2256	   }
! 2257	   else {
! 2258	      gl_error( ctx, GL_INVALID_OPERATION, "glCopyTexSubImage3DEXT" );

	ld	[%fp+68],%l0
	sethi	%hi(.L3909),%l1
	or	%l1,%lo(.L3909),%l1
	mov	%l0,%o0
	mov	1282,%o1
	call	gl_error
	mov	%l1,%o2

	! block 42
.L3910:
.L3911:
.L3905:
.L3912:

	! block 43
.L3913:
.L3914:
.L3748:
	jmp	%i7+8
	restore
	.size	gl_CopyTexSubImage3DEXT,(.-gl_CopyTexSubImage3DEXT)
	.align	8

	.section	".rodata1",#alloc
	.align	4
.L245:
	.ascii	"image\000"
	.skip	2
	.type	.L245,#object
	.size	.L245,8
	.align	4
.L246:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L246,#object
	.size	.L246,12
	.align	4
.L252:
	.ascii	"image->Width>0\000"
	.skip	1
	.type	.L252,#object
	.size	.L252,16
	.align	4
.L253:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L253,#object
	.size	.L253,12
	.align	4
.L259:
	.ascii	"image->Height>0\000"
	.type	.L259,#object
	.size	.L259,16
	.align	4
.L260:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L260,#object
	.size	.L260,12
	.align	4
.L266:
	.ascii	"image->Depth>0\000"
	.skip	1
	.type	.L266,#object
	.size	.L266,16
	.align	4
.L267:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L267,#object
	.size	.L267,12
	.align	4
.L323:
	.ascii	"texImage->WidthLog2>=0\000"
	.skip	1
	.type	.L323,#object
	.size	.L323,24
	.align	4
.L324:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L324,#object
	.size	.L324,12
	.align	4
.L330:
	.ascii	"texImage->HeightLog2>=0\000"
	.type	.L330,#object
	.size	.L330,24
	.align	4
.L331:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L331,#object
	.size	.L331,12
	.align	4
.L337:
	.ascii	"texImage->DepthLog2>=0\000"
	.skip	1
	.type	.L337,#object
	.size	.L337,24
	.align	4
.L338:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L338,#object
	.size	.L338,12
	.align	4
.L394:
	.ascii	"image->Format==GL_COLOR_INDEX\000"
	.skip	2
	.type	.L394,#object
	.size	.L394,32
	.align	4
.L395:
	.ascii	"teximage.c\000"
	.skip	1
	.type	.L395,#object
	.size	.L395,12
	.align	4
.L483:
	.ascii	"Bad format in image_to_texture\000"
	.skip	1
	.type	.L483,#object
	.size	.L483,32
	.align	4
.L600:
	.ascii	"Bad format (2) in image_to_texture\000"
	.skip	1
	.type	.L600,#object
	.size	.L600,36
	.align	4
.L719:
	.ascii	"Bad format (3) in image_to_texture\000"
	.skip	1
	.type	.L719,#object
	.size	.L719,36
	.align	4
.L842:
	.ascii	"Bad format (4) in image_to_texture\000"
	.skip	1
	.type	.L842,#object
	.size	.L842,36
	.align	4
.L951:
	.ascii	"Bad format (5) in image_to_texture\000"
	.skip	1
	.type	.L951,#object
	.size	.L951,36
	.align	4
.L966:
	.ascii	"Bad image type in image_to_texture\000"
	.skip	1
	.type	.L966,#object
	.size	.L966,36

	.section	".rodata",#alloc
	.align	4
Drodata.rodata:
.L_cseg0:
	.word	0x3f800000
	.type	.L_cseg0,#object
	.size	.L_cseg0,4
	.align	4
.L_cseg1:
	.skip	4
	.type	.L_cseg1,#object
	.size	.L_cseg1,4
	.align	4
.L_cseg2:
	.word	0x437f0000
	.type	.L_cseg2,#object
	.size	.L_cseg2,4
	.align	8
.L_cseg3:
	.word	0x3ff00000,0x0
	.type	.L_cseg3,#object
	.size	.L_cseg3,8
	.align	8
.L_cseg4:
	.skip	8
	.type	.L_cseg4,#object
	.size	.L_cseg4,8
.L1037:
	.ascii	"   X   X  XXXXX   XXX     X    "
	.skip	1
	.ascii	"   XX XX  X      X   X   X X   "
	.skip	1
	.ascii	"   X X X  X      X      X   X  "
	.skip	1
	.ascii	"   X   X  XXXX    XXX   XXXXX  "
	.skip	1
	.ascii	"   X   X  X          X  X   X  "
	.skip	1
	.ascii	"   X   X  X      X   X  X   X  "
	.skip	1
	.ascii	"   X   X  XXXXX   XXX   X   X  "
	.skip	1
	.ascii	"                               "
	.skip	1
	.type	.L1037,#object
	.size	.L1037,256

	.section	".rodata1",#alloc
	.align	4
.L1105:
	.ascii	"glTexImage1D\000"
	.skip	3
	.type	.L1105,#object
	.size	.L1105,16
	.align	4
.L1119:
	.ascii	"glTexImage1D(level)\000"
	.type	.L1119,#object
	.size	.L1119,20
	.align	4
.L1132:
	.ascii	"glTexImage1D(internalFormat)\000"
	.skip	3
	.type	.L1132,#object
	.size	.L1132,32
	.align	4
.L1151:
	.ascii	"glTexImage1D(border)\000"
	.skip	3
	.type	.L1151,#object
	.size	.L1151,24
	.align	4
.L1174:
	.ascii	"glTexImage1D(width)\000"
	.type	.L1174,#object
	.size	.L1174,20
	.align	4
.L1189:
	.ascii	"glTexImage1D(width != 2^k + 2*border)\000"
	.skip	2
	.type	.L1189,#object
	.size	.L1189,40
	.align	4
.L1212:
	.ascii	"glTexImage1D(format)\000"
	.skip	3
	.type	.L1212,#object
	.size	.L1212,24
	.align	4
.L1233:
	.ascii	"glTexImage1D(type)\000"
	.skip	1
	.type	.L1233,#object
	.size	.L1233,20
	.align	4
.L1256:
	.ascii	"glTexImage2D(target)\000"
	.skip	3
	.type	.L1256,#object
	.size	.L1256,24
	.align	4
.L1270:
	.ascii	"glTexImage2D(level)\000"
	.type	.L1270,#object
	.size	.L1270,20
	.align	4
.L1283:
	.ascii	"glTexImage2D(internalFormat)\000"
	.skip	3
	.type	.L1283,#object
	.size	.L1283,32
	.align	4
.L1302:
	.ascii	"glTexImage2D(border)\000"
	.skip	3
	.type	.L1302,#object
	.size	.L1302,24
	.align	4
.L1325:
	.ascii	"glTexImage2D(width)\000"
	.type	.L1325,#object
	.size	.L1325,20
	.align	4
.L1348:
	.ascii	"glTexImage2D(height)\000"
	.skip	3
	.type	.L1348,#object
	.size	.L1348,24
	.align	4
.L1363:
	.ascii	"glTexImage2D(width != 2^k + 2*border)\000"
	.skip	2
	.type	.L1363,#object
	.size	.L1363,40
	.align	4
.L1375:
	.ascii	"glTexImage2D(height != 2^k + 2*border)\000"
	.skip	1
	.type	.L1375,#object
	.size	.L1375,40
	.align	4
.L1398:
	.ascii	"glTexImage2D(format)\000"
	.skip	3
	.type	.L1398,#object
	.size	.L1398,24
	.align	4
.L1421:
	.ascii	"glTexImage2D(type)\000"
	.skip	1
	.type	.L1421,#object
	.size	.L1421,20
	.align	4
.L1444:
	.ascii	"glTexImage3DEXT(target)\000"
	.type	.L1444,#object
	.size	.L1444,24
	.align	4
.L1458:
	.ascii	"glTexImage3DEXT(level)\000"
	.skip	1
	.type	.L1458,#object
	.size	.L1458,24
	.align	4
.L1471:
	.ascii	"glTexImage3DEXT(internalFormat)\000"
	.type	.L1471,#object
	.size	.L1471,32
	.align	4
.L1490:
	.ascii	"glTexImage3DEXT(border)\000"
	.type	.L1490,#object
	.size	.L1490,24
	.align	4
.L1513:
	.ascii	"glTexImage3DEXT(width)\000"
	.skip	1
	.type	.L1513,#object
	.size	.L1513,24
	.align	4
.L1536:
	.ascii	"glTexImage3DEXT(height)\000"
	.type	.L1536,#object
	.size	.L1536,24
	.align	4
.L1559:
	.ascii	"glTexImage3DEXT(depth)\000"
	.skip	1
	.type	.L1559,#object
	.size	.L1559,24
	.align	4
.L1574:
	.ascii	"glTexImage3DEXT(width != 2^k + 2*border))\000"
	.skip	2
	.type	.L1574,#object
	.size	.L1574,44
	.align	4
.L1586:
	.ascii	"glTexImage3DEXT(height != 2^k + 2*border))\000"
	.skip	1
	.type	.L1586,#object
	.size	.L1586,44
	.align	4
.L1598:
	.ascii	"glTexImage3DEXT(depth  != 2^k + 2*border))\000"
	.skip	1
	.type	.L1598,#object
	.size	.L1598,44
	.align	4
.L1621:
	.ascii	"glTexImage3DEXT(format)\000"
	.type	.L1621,#object
	.size	.L1621,24
	.align	4
.L1644:
	.ascii	"glTexImage3DEXT(type)\000"
	.skip	2
	.type	.L1644,#object
	.size	.L1644,24
	.align	4
.L1666:
	.ascii	"glTexImage1D\000"
	.skip	3
	.type	.L1666,#object
	.size	.L1666,16
	.align	4
.L1792:
	.ascii	"glTexImage1D(target)\000"
	.skip	3
	.type	.L1792,#object
	.size	.L1792,24
	.align	4
.L1813:
	.ascii	"glTexImage2D\000"
	.skip	3
	.type	.L1813,#object
	.size	.L1813,16
	.align	4
.L1939:
	.ascii	"glTexImage2D(target)\000"
	.skip	3
	.type	.L1939,#object
	.size	.L1939,24
	.align	4
.L1960:
	.ascii	"glTexImage3DEXT\000"
	.type	.L1960,#object
	.size	.L1960,16
	.align	4
.L2087:
	.ascii	"glTexImage3DEXT(target)\000"
	.type	.L2087,#object
	.size	.L2087,24
	.align	4
.L2102:
	.ascii	"glGetTexImage not implemented\000"
	.skip	2
	.type	.L2102,#object
	.size	.L2102,32
	.align	4
.L2158:
	.ascii	"glTexSubImage1D(target)\000"
	.type	.L2158,#object
	.size	.L2158,24
	.align	4
.L2172:
	.ascii	"glTexSubImage1D(level)\000"
	.skip	1
	.type	.L2172,#object
	.size	.L2172,24
	.align	4
.L2185:
	.ascii	"glTexSubImage1D\000"
	.type	.L2185,#object
	.size	.L2185,16
	.align	4
.L2197:
	.ascii	"glTexSubImage1D(xoffset)\000"
	.skip	3
	.type	.L2197,#object
	.size	.L2197,28
	.align	4
.L2209:
	.ascii	"glTexSubImage1D(xoffset+width)\000"
	.skip	1
	.type	.L2209,#object
	.size	.L2209,32
	.align	4
.L2277:
	.ascii	"glTexSubImage1D(width)\000"
	.skip	1
	.type	.L2277,#object
	.size	.L2277,24
	.align	4
.L2290:
	.ascii	"glTexSubImage1D(format)\000"
	.type	.L2290,#object
	.size	.L2290,24
	.align	4
.L2306:
	.ascii	"glTexSubImage1D(format)\000"
	.type	.L2306,#object
	.size	.L2306,24
	.align	4
.L2319:
	.ascii	"glTexSubImage1D(type)\000"
	.skip	2
	.type	.L2319,#object
	.size	.L2319,24
	.align	4
.L2325:
	.ascii	"glTexSubImage1D\000"
	.type	.L2325,#object
	.size	.L2325,16
	.align	4
.L2343:
	.ascii	"glTexSubImage2D(target)\000"
	.type	.L2343,#object
	.size	.L2343,24
	.align	4
.L2357:
	.ascii	"glTexSubImage2D(level)\000"
	.skip	1
	.type	.L2357,#object
	.size	.L2357,24
	.align	4
.L2370:
	.ascii	"glTexSubImage2D\000"
	.type	.L2370,#object
	.size	.L2370,16
	.align	4
.L2382:
	.ascii	"glTexSubImage2D(xoffset)\000"
	.skip	3
	.type	.L2382,#object
	.size	.L2382,28
	.align	4
.L2394:
	.ascii	"glTexSubImage2D(yoffset)\000"
	.skip	3
	.type	.L2394,#object
	.size	.L2394,28
	.align	4
.L2406:
	.ascii	"glTexSubImage2D(xoffset+width)\000"
	.skip	1
	.type	.L2406,#object
	.size	.L2406,32
	.align	4
.L2418:
	.ascii	"glTexSubImage2D(yoffset+height)\000"
	.type	.L2418,#object
	.size	.L2418,32
	.align	4
.L2516:
	.ascii	"glTexSubImage2D(width)\000"
	.skip	1
	.type	.L2516,#object
	.size	.L2516,24
	.align	4
.L2528:
	.ascii	"glTexSubImage2D(height)\000"
	.type	.L2528,#object
	.size	.L2528,24
	.align	4
.L2541:
	.ascii	"glTexSubImage1D(format)\000"
	.type	.L2541,#object
	.size	.L2541,24
	.align	4
.L2557:
	.ascii	"glTexSubImage2D(format)\000"
	.type	.L2557,#object
	.size	.L2557,24
	.align	4
.L2570:
	.ascii	"glTexSubImage2D(type)\000"
	.skip	2
	.type	.L2570,#object
	.size	.L2570,24
	.align	4
.L2576:
	.ascii	"glTexSubImage2D\000"
	.type	.L2576,#object
	.size	.L2576,16
	.align	4
.L2594:
	.ascii	"glTexSubImage3DEXT(target)\000"
	.skip	1
	.type	.L2594,#object
	.size	.L2594,28
	.align	4
.L2608:
	.ascii	"glTexSubImage3DEXT(level)\000"
	.skip	2
	.type	.L2608,#object
	.size	.L2608,28
	.align	4
.L2621:
	.ascii	"glTexSubImage3DEXT\000"
	.skip	1
	.type	.L2621,#object
	.size	.L2621,20
	.align	4
.L2633:
	.ascii	"glTexSubImage3DEXT(xoffset)\000"
	.type	.L2633,#object
	.size	.L2633,28
	.align	4
.L2645:
	.ascii	"glTexSubImage3DEXT(yoffset)\000"
	.type	.L2645,#object
	.size	.L2645,28
	.align	4
.L2657:
	.ascii	"glTexSubImage3DEXT(zoffset)\000"
	.type	.L2657,#object
	.size	.L2657,28
	.align	4
.L2669:
	.ascii	"glTexSubImage3DEXT(xoffset+width)\000"
	.skip	2
	.type	.L2669,#object
	.size	.L2669,36
	.align	4
.L2681:
	.ascii	"glTexSubImage3DEXT(yoffset+height)\000"
	.skip	1
	.type	.L2681,#object
	.size	.L2681,36
	.align	4
.L2693:
	.ascii	"glTexSubImage3DEXT(zoffset+depth)\000"
	.skip	2
	.type	.L2693,#object
	.size	.L2693,36
	.align	4
.L2823:
	.ascii	"glTexSubImage3DEXT(width)\000"
	.skip	2
	.type	.L2823,#object
	.size	.L2823,28
	.align	4
.L2835:
	.ascii	"glTexSubImage3DEXT(height)\000"
	.skip	1
	.type	.L2835,#object
	.size	.L2835,28
	.align	4
.L2847:
	.ascii	"glTexSubImage3DEXT(depth)\000"
	.skip	2
	.type	.L2847,#object
	.size	.L2847,28
	.align	4
.L2860:
	.ascii	"glTexSubImage3DEXT(format)\000"
	.skip	1
	.type	.L2860,#object
	.size	.L2860,28
	.align	4
.L2876:
	.ascii	"glTexSubImage3DEXT(format)\000"
	.skip	1
	.type	.L2876,#object
	.size	.L2876,28
	.align	4
.L2889:
	.ascii	"glTexSubImage3DEXT(type)\000"
	.skip	3
	.type	.L2889,#object
	.size	.L2889,28
	.align	4
.L2895:
	.ascii	"glTexSubImage3DEXT\000"
	.skip	1
	.type	.L2895,#object
	.size	.L2895,20
	.align	4
.L3117:
	.ascii	"glCopyTexImage1D\000"
	.skip	3
	.type	.L3117,#object
	.size	.L3117,20
	.align	4
.L3129:
	.ascii	"glCopyTexImage1D(target)\000"
	.skip	3
	.type	.L3129,#object
	.size	.L3129,28
	.align	4
.L3143:
	.ascii	"glCopyTexImage1D(level)\000"
	.type	.L3143,#object
	.size	.L3143,24
	.align	4
.L3156:
	.ascii	"glCopyTexImage1D(border)\000"
	.skip	3
	.type	.L3156,#object
	.size	.L3156,28
	.align	4
.L3171:
	.ascii	"glCopyTexImage1D(width)\000"
	.type	.L3171,#object
	.size	.L3171,24
	.align	4
.L3187:
	.ascii	"glCopyTexImage1D(format)\000"
	.skip	3
	.type	.L3187,#object
	.size	.L3187,28
	.align	4
.L3200:
	.ascii	"glCopyTexImage1D\000"
	.skip	3
	.type	.L3200,#object
	.size	.L3200,20
	.align	4
.L3220:
	.ascii	"glCopyTexImage2D\000"
	.skip	3
	.type	.L3220,#object
	.size	.L3220,20
	.align	4
.L3232:
	.ascii	"glCopyTexImage2D(target)\000"
	.skip	3
	.type	.L3232,#object
	.size	.L3232,28
	.align	4
.L3246:
	.ascii	"glCopyTexImage2D(level)\000"
	.type	.L3246,#object
	.size	.L3246,24
	.align	4
.L3259:
	.ascii	"glCopyTexImage2D(border)\000"
	.skip	3
	.type	.L3259,#object
	.size	.L3259,28
	.align	4
.L3274:
	.ascii	"glCopyTexImage2D(width)\000"
	.type	.L3274,#object
	.size	.L3274,24
	.align	4
.L3289:
	.ascii	"glCopyTexImage2D(height)\000"
	.skip	3
	.type	.L3289,#object
	.size	.L3289,28
	.align	4
.L3305:
	.ascii	"glCopyTexImage2D(format)\000"
	.skip	3
	.type	.L3305,#object
	.size	.L3305,28
	.align	4
.L3318:
	.ascii	"glCopyTexImage2D\000"
	.skip	3
	.type	.L3318,#object
	.size	.L3318,20
	.align	4
.L3507:
	.ascii	"glCopyTexSubImage1D\000"
	.type	.L3507,#object
	.size	.L3507,20
	.align	4
.L3519:
	.ascii	"glCopyTexSubImage1D(target)\000"
	.type	.L3519,#object
	.size	.L3519,28
	.align	4
.L3533:
	.ascii	"glCopyTexSubImage1D(level)\000"
	.skip	1
	.type	.L3533,#object
	.size	.L3533,28
	.align	4
.L3545:
	.ascii	"glCopyTexSubImage1D(width)\000"
	.skip	1
	.type	.L3545,#object
	.size	.L3545,28
	.align	4
.L3564:
	.ascii	"glCopyTexSubImage1D(xoffset)\000"
	.skip	3
	.type	.L3564,#object
	.size	.L3564,32
	.align	4
.L3576:
	.ascii	"glCopyTexSubImage1D(xoffset+width)\000"
	.skip	1
	.type	.L3576,#object
	.size	.L3576,36
	.align	4
.L3597:
	.ascii	"glCopyTexSubImage1D\000"
	.type	.L3597,#object
	.size	.L3597,20
	.align	4
.L3615:
	.ascii	"glCopyTexSubImage2D\000"
	.type	.L3615,#object
	.size	.L3615,20
	.align	4
.L3627:
	.ascii	"glCopyTexSubImage2D(target)\000"
	.type	.L3627,#object
	.size	.L3627,28
	.align	4
.L3641:
	.ascii	"glCopyTexSubImage2D(level)\000"
	.skip	1
	.type	.L3641,#object
	.size	.L3641,28
	.align	4
.L3653:
	.ascii	"glCopyTexSubImage2D(width)\000"
	.skip	1
	.type	.L3653,#object
	.size	.L3653,28
	.align	4
.L3665:
	.ascii	"glCopyTexSubImage2D(height)\000"
	.type	.L3665,#object
	.size	.L3665,28
	.align	4
.L3684:
	.ascii	"glCopyTexSubImage2D(xoffset)\000"
	.skip	3
	.type	.L3684,#object
	.size	.L3684,32
	.align	4
.L3696:
	.ascii	"glCopyTexSubImage2D(yoffset)\000"
	.skip	3
	.type	.L3696,#object
	.size	.L3696,32
	.align	4
.L3708:
	.ascii	"glCopyTexSubImage2D(xoffset+width)\000"
	.skip	1
	.type	.L3708,#object
	.size	.L3708,36
	.align	4
.L3720:
	.ascii	"glCopyTexSubImage2D(yoffset+height)\000"
	.type	.L3720,#object
	.size	.L3720,36
	.align	4
.L3741:
	.ascii	"glCopyTexSubImage2D\000"
	.type	.L3741,#object
	.size	.L3741,20
	.align	4
.L3759:
	.ascii	"glCopyTexSubImage3DEXT\000"
	.skip	1
	.type	.L3759,#object
	.size	.L3759,24
	.align	4
.L3771:
	.ascii	"glCopyTexSubImage3DEXT(target)\000"
	.skip	1
	.type	.L3771,#object
	.size	.L3771,32
	.align	4
.L3785:
	.ascii	"glCopyTexSubImage3DEXT(level)\000"
	.skip	2
	.type	.L3785,#object
	.size	.L3785,32
	.align	4
.L3797:
	.ascii	"glCopyTexSubImage3DEXT(width)\000"
	.skip	2
	.type	.L3797,#object
	.size	.L3797,32
	.align	4
.L3809:
	.ascii	"glCopyTexSubImage3DEXT(height)\000"
	.skip	1
	.type	.L3809,#object
	.size	.L3809,32
	.align	4
.L3828:
	.ascii	"glCopyTexSubImage3DEXT(xoffset)\000"
	.type	.L3828,#object
	.size	.L3828,32
	.align	4
.L3840:
	.ascii	"glCopyTexSubImage3DEXT(yoffset)\000"
	.type	.L3840,#object
	.size	.L3840,32
	.align	4
.L3852:
	.ascii	"glCopyTexSubImage3DEXT(zoffset)\000"
	.type	.L3852,#object
	.size	.L3852,32
	.align	4
.L3864:
	.ascii	"glCopyTexSubImage3DEXT(xoffset+width)\000"
	.skip	2
	.type	.L3864,#object
	.size	.L3864,40
	.align	4
.L3876:
	.ascii	"glCopyTexSubImage3DEXT(yoffset+height)\000"
	.skip	1
	.type	.L3876,#object
	.size	.L3876,40
	.align	4
.L3888:
	.ascii	"glCopyTexSubImage3DEXT(zoffset+depth)\000"
	.skip	2
	.type	.L3888,#object
	.size	.L3888,40
	.align	4
.L3909:
	.ascii	"glCopyTexSubImage3DEXT\000"
	.type	.L3909,#object
	.size	.L3909,23
	.section	".bss",#alloc,#write
Bbss.bss:
	.section	".data",#alloc,#write
Ddata.data:

	.file	"teximage.c"
	.ident	"@(#)assert.h	1.10	04/05/18 SMI"
	.ident	"@(#)stdio.h	1.84	04/09/28 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)stdio_iso.h	1.8	05/08/16 SMI"
	.ident	"@(#)va_list.h	1.15	04/11/19 SMI"
	.ident	"@(#)stdio_tag.h	1.4	04/09/28 SMI"
	.ident	"@(#)stdio_impl.h	1.15	07/03/05 SMI"
	.ident	"@(#)stdio_c99.h	1.2	04/03/29 SMI"
	.ident	"@(#)stdlib.h	1.51	04/06/30 SMI"
	.ident	"@(#)stdlib_iso.h	1.9	04/09/28 SMI"
	.ident	"@(#)stdlib_c99.h	1.2	04/03/29 SMI"
	.ident	"@(#)string.h	1.27	07/01/14 SMI"
	.ident	"@(#)string_iso.h	1.5	04/06/18 SMI"
	.ident	"@(#)math.h	2.24	04/10/23 SMI"
	.ident	"@(#)math_iso.h	1.9	04/10/23 SMI"
	.ident	"@(#)math_c99.h	1.9	04/11/01 SMI"
	.ident	"@(#)floatingpoint.h	2.9	04/10/23 SMI"
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
!   reloc[1]: knd=2, off=259, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=276, siz=4, lab1=logbase2, lab2=, loff=0
!   reloc[3]: knd=0, off=280, siz=4, lab1=.L59, lab2=, loff=0
!   reloc[4]: knd=0, off=385, siz=4, lab1=decode_internal_format, lab2=, loff=0
!   reloc[5]: knd=0, off=389, siz=4, lab1=.L134, lab2=, loff=0
!   reloc[6]: knd=0, off=452, siz=4, lab1=components_in_intformat, lab2=, loff=0
!   reloc[7]: knd=0, off=456, siz=4, lab1=.L209, lab2=, loff=0
!   reloc[8]: knd=0, off=520, siz=4, lab1=gl_alloc_texture_image, lab2=, loff=0
!   reloc[9]: knd=0, off=524, siz=4, lab1=.L217, lab2=, loff=0
!   reloc[10]: knd=0, off=13109, siz=4, lab1=gl_free_texture_image, lab2=, loff=0
!   reloc[11]: knd=0, off=13113, siz=4, lab1=.L235, lab2=, loff=0
!   reloc[12]: knd=0, off=13169, siz=4, lab1=image_to_texture, lab2=, loff=0
!   reloc[13]: knd=0, off=13173, siz=4, lab1=.L975, lab2=, loff=0
!   reloc[14]: knd=0, off=13378, siz=4, lab1=.L375, lab2=, loff=0
!   reloc[15]: knd=0, off=13382, siz=4, lab1=.L972, lab2=, loff=0
!   reloc[16]: knd=0, off=13387, siz=4, lab1=.L379, lab2=, loff=0
!   reloc[17]: knd=0, off=13391, siz=4, lab1=.L969, lab2=, loff=0
!   reloc[18]: knd=0, off=13396, siz=4, lab1=.L380, lab2=, loff=0
!   reloc[19]: knd=0, off=13400, siz=4, lab1=.L968, lab2=, loff=0
!   reloc[20]: knd=0, off=13405, siz=4, lab1=.L382, lab2=, loff=0
!   reloc[21]: knd=0, off=13409, siz=4, lab1=.L510, lab2=, loff=0
!   reloc[22]: knd=0, off=13577, siz=4, lab1=.L397, lab2=, loff=0
!   reloc[23]: knd=0, off=13581, siz=4, lab1=.L509, lab2=, loff=0
!   reloc[24]: knd=0, off=13586, siz=4, lab1=.L403, lab2=, loff=0
!   reloc[25]: knd=0, off=13590, siz=4, lab1=.L506, lab2=, loff=0
!   reloc[26]: knd=0, off=13595, siz=4, lab1=.L404, lab2=, loff=0
!   reloc[27]: knd=0, off=13599, siz=4, lab1=.L505, lab2=, loff=0
!   reloc[28]: knd=0, off=13625, siz=4, lab1=.L406, lab2=, loff=0
!   reloc[29]: knd=0, off=13629, siz=4, lab1=.L494, lab2=, loff=0
!   reloc[30]: knd=0, off=13634, siz=4, lab1=.L412, lab2=, loff=0
!   reloc[31]: knd=0, off=13638, siz=4, lab1=.L491, lab2=, loff=0
!   reloc[32]: knd=0, off=13643, siz=4, lab1=.L413, lab2=, loff=0
!   reloc[33]: knd=0, off=13647, siz=4, lab1=.L490, lab2=, loff=0
!   reloc[34]: knd=0, off=13751, siz=4, lab1=.L513, lab2=, loff=0
!   reloc[35]: knd=0, off=13755, siz=4, lab1=.L730, lab2=, loff=0
!   reloc[36]: knd=0, off=13760, siz=4, lab1=.L519, lab2=, loff=0
!   reloc[37]: knd=0, off=13764, siz=4, lab1=.L727, lab2=, loff=0
!   reloc[38]: knd=0, off=13769, siz=4, lab1=.L520, lab2=, loff=0
!   reloc[39]: knd=0, off=13773, siz=4, lab1=.L726, lab2=, loff=0
!   reloc[40]: knd=0, off=13847, siz=4, lab1=.L521, lab2=, loff=0
!   reloc[41]: knd=0, off=13851, siz=4, lab1=.L606, lab2=, loff=0
!   reloc[42]: knd=0, off=13856, siz=4, lab1=.L525, lab2=, loff=0
!   reloc[43]: knd=0, off=13860, siz=4, lab1=.L603, lab2=, loff=0
!   reloc[44]: knd=0, off=13865, siz=4, lab1=.L526, lab2=, loff=0
!   reloc[45]: knd=0, off=13869, siz=4, lab1=.L602, lab2=, loff=0
!   reloc[46]: knd=0, off=13874, siz=4, lab1=.L528, lab2=, loff=0
!   reloc[47]: knd=0, off=13878, siz=4, lab1=.L548, lab2=, loff=0
!   reloc[48]: knd=0, off=13883, siz=4, lab1=.L532, lab2=, loff=0
!   reloc[49]: knd=0, off=13887, siz=4, lab1=.L537, lab2=, loff=0
!   reloc[50]: knd=0, off=13892, siz=4, lab1=.L533, lab2=, loff=0
!   reloc[51]: knd=0, off=13896, siz=4, lab1=.L536, lab2=, loff=0
!   reloc[52]: knd=0, off=13921, siz=4, lab1=.L539, lab2=, loff=0
!   reloc[53]: knd=0, off=13925, siz=4, lab1=.L547, lab2=, loff=0
!   reloc[54]: knd=0, off=13930, siz=4, lab1=.L540, lab2=, loff=0
!   reloc[55]: knd=0, off=13934, siz=4, lab1=.L546, lab2=, loff=0
!   reloc[56]: knd=0, off=13963, siz=4, lab1=.L607, lab2=, loff=0
!   reloc[57]: knd=0, off=13967, siz=4, lab1=.L683, lab2=, loff=0
!   reloc[58]: knd=0, off=13972, siz=4, lab1=.L613, lab2=, loff=0
!   reloc[59]: knd=0, off=13976, siz=4, lab1=.L682, lab2=, loff=0
!   reloc[60]: knd=0, off=13981, siz=4, lab1=.L614, lab2=, loff=0
!   reloc[61]: knd=0, off=13985, siz=4, lab1=.L681, lab2=, loff=0
!   reloc[62]: knd=0, off=14049, siz=4, lab1=.L660, lab2=, loff=0
!   reloc[63]: knd=0, off=14053, siz=4, lab1=.L676, lab2=, loff=0
!   reloc[64]: knd=0, off=14058, siz=4, lab1=.L664, lab2=, loff=0
!   reloc[65]: knd=0, off=14062, siz=4, lab1=.L675, lab2=, loff=0
!   reloc[66]: knd=0, off=14067, siz=4, lab1=.L665, lab2=, loff=0
!   reloc[67]: knd=0, off=14071, siz=4, lab1=.L674, lab2=, loff=0
!   reloc[68]: knd=0, off=14149, siz=4, lab1=.L733, lab2=, loff=0
!   reloc[69]: knd=0, off=14153, siz=4, lab1=.L962, lab2=, loff=0
!   reloc[70]: knd=0, off=14158, siz=4, lab1=.L739, lab2=, loff=0
!   reloc[71]: knd=0, off=14162, siz=4, lab1=.L959, lab2=, loff=0
!   reloc[72]: knd=0, off=14167, siz=4, lab1=.L740, lab2=, loff=0
!   reloc[73]: knd=0, off=14171, siz=4, lab1=.L958, lab2=, loff=0
!   reloc[74]: knd=0, off=14247, siz=4, lab1=.L741, lab2=, loff=0
!   reloc[75]: knd=0, off=14251, siz=4, lab1=.L848, lab2=, loff=0
!   reloc[76]: knd=0, off=14256, siz=4, lab1=.L745, lab2=, loff=0
!   reloc[77]: knd=0, off=14260, siz=4, lab1=.L845, lab2=, loff=0
!   reloc[78]: knd=0, off=14265, siz=4, lab1=.L746, lab2=, loff=0
!   reloc[79]: knd=0, off=14269, siz=4, lab1=.L844, lab2=, loff=0
!   reloc[80]: knd=0, off=14274, siz=4, lab1=.L748, lab2=, loff=0
!   reloc[81]: knd=0, off=14278, siz=4, lab1=.L790, lab2=, loff=0
!   reloc[82]: knd=0, off=14283, siz=4, lab1=.L752, lab2=, loff=0
!   reloc[83]: knd=0, off=14287, siz=4, lab1=.L757, lab2=, loff=0
!   reloc[84]: knd=0, off=14292, siz=4, lab1=.L753, lab2=, loff=0
!   reloc[85]: knd=0, off=14296, siz=4, lab1=.L756, lab2=, loff=0
!   reloc[86]: knd=0, off=14322, siz=4, lab1=.L759, lab2=, loff=0
!   reloc[87]: knd=0, off=14326, siz=4, lab1=.L789, lab2=, loff=0
!   reloc[88]: knd=0, off=14331, siz=4, lab1=.L760, lab2=, loff=0
!   reloc[89]: knd=0, off=14335, siz=4, lab1=.L788, lab2=, loff=0
!   reloc[90]: knd=0, off=14480, siz=4, lab1=.L849, lab2=, loff=0
!   reloc[91]: knd=0, off=14484, siz=4, lab1=.L915, lab2=, loff=0
!   reloc[92]: knd=0, off=14489, siz=4, lab1=.L853, lab2=, loff=0
!   reloc[93]: knd=0, off=14493, siz=4, lab1=.L914, lab2=, loff=0
!   reloc[94]: knd=0, off=14498, siz=4, lab1=.L854, lab2=, loff=0
!   reloc[95]: knd=0, off=14502, siz=4, lab1=.L913, lab2=, loff=0
!   reloc[96]: knd=0, off=14507, siz=4, lab1=.L896, lab2=, loff=0
!   reloc[97]: knd=0, off=14511, siz=4, lab1=.L912, lab2=, loff=0
!   reloc[98]: knd=0, off=14516, siz=4, lab1=.L900, lab2=, loff=0
!   reloc[99]: knd=0, off=14520, siz=4, lab1=.L911, lab2=, loff=0
!   reloc[100]: knd=0, off=14525, siz=4, lab1=.L901, lab2=, loff=0
!   reloc[101]: knd=0, off=14529, siz=4, lab1=.L910, lab2=, loff=0
!   reloc[102]: knd=0, off=39839, siz=4, lab1=make_null_texture, lab2=, loff=0
!   reloc[103]: knd=0, off=39843, siz=4, lab1=.L1091, lab2=, loff=0
!   reloc[104]: knd=0, off=40043, siz=4, lab1=.L1031, lab2=, loff=0
!   reloc[105]: knd=0, off=40047, siz=4, lab1=.L1088, lab2=, loff=0
!   reloc[106]: knd=0, off=40052, siz=4, lab1=.L1035, lab2=, loff=0
!   reloc[107]: knd=0, off=40056, siz=4, lab1=.L1087, lab2=, loff=0
!   reloc[108]: knd=0, off=40061, siz=4, lab1=.L1036, lab2=, loff=0
!   reloc[109]: knd=0, off=40065, siz=4, lab1=.L1086, lab2=, loff=0
!   reloc[110]: knd=0, off=40156, siz=4, lab1=.L1040, lab2=, loff=0
!   reloc[111]: knd=0, off=40160, siz=4, lab1=.L1085, lab2=, loff=0
!   reloc[112]: knd=0, off=40165, siz=4, lab1=.L1046, lab2=, loff=0
!   reloc[113]: knd=0, off=40169, siz=4, lab1=.L1082, lab2=, loff=0
!   reloc[114]: knd=0, off=40174, siz=4, lab1=.L1047, lab2=, loff=0
!   reloc[115]: knd=0, off=40178, siz=4, lab1=.L1081, lab2=, loff=0
!   reloc[116]: knd=0, off=40203, siz=4, lab1=.L1049, lab2=, loff=0
!   reloc[117]: knd=0, off=40207, siz=4, lab1=.L1080, lab2=, loff=0
!   reloc[118]: knd=0, off=40212, siz=4, lab1=.L1055, lab2=, loff=0
!   reloc[119]: knd=0, off=40216, siz=4, lab1=.L1077, lab2=, loff=0
!   reloc[120]: knd=0, off=40221, siz=4, lab1=.L1056, lab2=, loff=0
!   reloc[121]: knd=0, off=40225, siz=4, lab1=.L1076, lab2=, loff=0
!   reloc[122]: knd=0, off=40345, siz=4, lab1=texture_1d_error_check, lab2=, loff=0
!   reloc[123]: knd=0, off=40349, siz=4, lab1=.L1242, lab2=, loff=0
!   reloc[124]: knd=0, off=40567, siz=4, lab1=texture_2d_error_check, lab2=, loff=0
!   reloc[125]: knd=0, off=40571, siz=4, lab1=.L1430, lab2=, loff=0
!   reloc[126]: knd=0, off=40808, siz=4, lab1=texture_3d_error_check, lab2=, loff=0
!   reloc[127]: knd=0, off=40812, siz=4, lab1=.L1653, lab2=, loff=0
!   reloc[128]: knd=0, off=41059, siz=4, lab1=gl_TexImage1D, lab2=, loff=0
!   reloc[129]: knd=0, off=41063, siz=4, lab1=.L1800, lab2=, loff=0
!   reloc[130]: knd=0, off=41247, siz=4, lab1=.L1671, lab2=, loff=0
!   reloc[131]: knd=0, off=41251, siz=4, lab1=.L1798, lab2=, loff=0
!   reloc[132]: knd=0, off=41256, siz=4, lab1=.L1675, lab2=, loff=0
!   reloc[133]: knd=0, off=41260, siz=4, lab1=.L1738, lab2=, loff=0
!   reloc[134]: knd=0, off=41265, siz=4, lab1=.L1676, lab2=, loff=0
!   reloc[135]: knd=0, off=41269, siz=4, lab1=.L1737, lab2=, loff=0
!   reloc[136]: knd=0, off=41318, siz=4, lab1=gl_TexImage2D, lab2=, loff=0
!   reloc[137]: knd=0, off=41322, siz=4, lab1=.L1947, lab2=, loff=0
!   reloc[138]: knd=0, off=41525, siz=4, lab1=.L1818, lab2=, loff=0
!   reloc[139]: knd=0, off=41529, siz=4, lab1=.L1945, lab2=, loff=0
!   reloc[140]: knd=0, off=41534, siz=4, lab1=.L1822, lab2=, loff=0
!   reloc[141]: knd=0, off=41538, siz=4, lab1=.L1885, lab2=, loff=0
!   reloc[142]: knd=0, off=41543, siz=4, lab1=.L1823, lab2=, loff=0
!   reloc[143]: knd=0, off=41547, siz=4, lab1=.L1884, lab2=, loff=0
!   reloc[144]: knd=0, off=41599, siz=4, lab1=gl_TexImage3DEXT, lab2=, loff=0
!   reloc[145]: knd=0, off=41603, siz=4, lab1=.L2095, lab2=, loff=0
!   reloc[146]: knd=0, off=41824, siz=4, lab1=.L1965, lab2=, loff=0
!   reloc[147]: knd=0, off=41828, siz=4, lab1=.L2093, lab2=, loff=0
!   reloc[148]: knd=0, off=41833, siz=4, lab1=.L1969, lab2=, loff=0
!   reloc[149]: knd=0, off=41837, siz=4, lab1=.L2032, lab2=, loff=0
!   reloc[150]: knd=0, off=41842, siz=4, lab1=.L1970, lab2=, loff=0
!   reloc[151]: knd=0, off=41846, siz=4, lab1=.L2031, lab2=, loff=0
!   reloc[152]: knd=0, off=41896, siz=4, lab1=gl_GetTexImage, lab2=, loff=0
!   reloc[153]: knd=0, off=41900, siz=4, lab1=.L2104, lab2=, loff=0
!   reloc[154]: knd=0, off=42049, siz=4, lab1=gl_unpack_texsubimage, lab2=, loff=0
!   reloc[155]: knd=0, off=42053, siz=4, lab1=.L2145, lab2=, loff=0
!   reloc[156]: knd=0, off=42229, siz=4, lab1=gl_TexSubImage1D, lab2=, loff=0
!   reloc[157]: knd=0, off=42233, siz=4, lab1=.L2330, lab2=, loff=0
!   reloc[158]: knd=0, off=42411, siz=4, lab1=.L2214, lab2=, loff=0
!   reloc[159]: knd=0, off=42415, siz=4, lab1=.L2328, lab2=, loff=0
!   reloc[160]: knd=0, off=42420, siz=4, lab1=.L2218, lab2=, loff=0
!   reloc[161]: knd=0, off=42424, siz=4, lab1=.L2266, lab2=, loff=0
!   reloc[162]: knd=0, off=42429, siz=4, lab1=.L2219, lab2=, loff=0
!   reloc[163]: knd=0, off=42433, siz=4, lab1=.L2265, lab2=, loff=0
!   reloc[164]: knd=0, off=42464, siz=4, lab1=.L2221, lab2=, loff=0
!   reloc[165]: knd=0, off=42468, siz=4, lab1=.L2243, lab2=, loff=0
!   reloc[166]: knd=0, off=42473, siz=4, lab1=.L2226, lab2=, loff=0
!   reloc[167]: knd=0, off=42477, siz=4, lab1=.L2232, lab2=, loff=0
!   reloc[168]: knd=0, off=42482, siz=4, lab1=.L2227, lab2=, loff=0
!   reloc[169]: knd=0, off=42486, siz=4, lab1=.L2231, lab2=, loff=0
!   reloc[170]: knd=0, off=42525, siz=4, lab1=.L2234, lab2=, loff=0
!   reloc[171]: knd=0, off=42529, siz=4, lab1=.L2242, lab2=, loff=0
!   reloc[172]: knd=0, off=42534, siz=4, lab1=.L2235, lab2=, loff=0
!   reloc[173]: knd=0, off=42538, siz=4, lab1=.L2241, lab2=, loff=0
!   reloc[174]: knd=0, off=42602, siz=4, lab1=.L2268, lab2=, loff=0
!   reloc[175]: knd=0, off=42606, siz=4, lab1=.L2327, lab2=, loff=0
!   reloc[176]: knd=0, off=42611, siz=4, lab1=.L2269, lab2=, loff=0
!   reloc[177]: knd=0, off=42615, siz=4, lab1=.L2326, lab2=, loff=0
!   reloc[178]: knd=0, off=42686, siz=4, lab1=gl_TexSubImage2D, lab2=, loff=0
!   reloc[179]: knd=0, off=42690, siz=4, lab1=.L2581, lab2=, loff=0
!   reloc[180]: knd=0, off=42907, siz=4, lab1=.L2423, lab2=, loff=0
!   reloc[181]: knd=0, off=42911, siz=4, lab1=.L2579, lab2=, loff=0
!   reloc[182]: knd=0, off=42916, siz=4, lab1=.L2427, lab2=, loff=0
!   reloc[183]: knd=0, off=42920, siz=4, lab1=.L2505, lab2=, loff=0
!   reloc[184]: knd=0, off=42925, siz=4, lab1=.L2428, lab2=, loff=0
!   reloc[185]: knd=0, off=42929, siz=4, lab1=.L2504, lab2=, loff=0
!   reloc[186]: knd=0, off=42960, siz=4, lab1=.L2430, lab2=, loff=0
!   reloc[187]: knd=0, off=42964, siz=4, lab1=.L2482, lab2=, loff=0
!   reloc[188]: knd=0, off=42969, siz=4, lab1=.L2435, lab2=, loff=0
!   reloc[189]: knd=0, off=42973, siz=4, lab1=.L2456, lab2=, loff=0
!   reloc[190]: knd=0, off=42978, siz=4, lab1=.L2436, lab2=, loff=0
!   reloc[191]: knd=0, off=42982, siz=4, lab1=.L2455, lab2=, loff=0
!   reloc[192]: knd=0, off=43035, siz=4, lab1=.L2458, lab2=, loff=0
!   reloc[193]: knd=0, off=43039, siz=4, lab1=.L2481, lab2=, loff=0
!   reloc[194]: knd=0, off=43044, siz=4, lab1=.L2459, lab2=, loff=0
!   reloc[195]: knd=0, off=43048, siz=4, lab1=.L2480, lab2=, loff=0
!   reloc[196]: knd=0, off=43126, siz=4, lab1=.L2507, lab2=, loff=0
!   reloc[197]: knd=0, off=43130, siz=4, lab1=.L2578, lab2=, loff=0
!   reloc[198]: knd=0, off=43135, siz=4, lab1=.L2508, lab2=, loff=0
!   reloc[199]: knd=0, off=43139, siz=4, lab1=.L2577, lab2=, loff=0
!   reloc[200]: knd=0, off=43213, siz=4, lab1=gl_TexSubImage3DEXT, lab2=, loff=0
!   reloc[201]: knd=0, off=43217, siz=4, lab1=.L2900, lab2=, loff=0
!   reloc[202]: knd=0, off=43472, siz=4, lab1=.L2698, lab2=, loff=0
!   reloc[203]: knd=0, off=43476, siz=4, lab1=.L2898, lab2=, loff=0
!   reloc[204]: knd=0, off=43481, siz=4, lab1=.L2702, lab2=, loff=0
!   reloc[205]: knd=0, off=43485, siz=4, lab1=.L2812, lab2=, loff=0
!   reloc[206]: knd=0, off=43490, siz=4, lab1=.L2703, lab2=, loff=0
!   reloc[207]: knd=0, off=43494, siz=4, lab1=.L2811, lab2=, loff=0
!   reloc[208]: knd=0, off=43573, siz=4, lab1=.L2707, lab2=, loff=0
!   reloc[209]: knd=0, off=43577, siz=4, lab1=.L2789, lab2=, loff=0
!   reloc[210]: knd=0, off=43582, siz=4, lab1=.L2712, lab2=, loff=0
!   reloc[211]: knd=0, off=43586, siz=4, lab1=.L2748, lab2=, loff=0
!   reloc[212]: knd=0, off=43591, siz=4, lab1=.L2713, lab2=, loff=0
!   reloc[213]: knd=0, off=43595, siz=4, lab1=.L2747, lab2=, loff=0
!   reloc[214]: knd=0, off=43662, siz=4, lab1=.L2750, lab2=, loff=0
!   reloc[215]: knd=0, off=43666, siz=4, lab1=.L2788, lab2=, loff=0
!   reloc[216]: knd=0, off=43671, siz=4, lab1=.L2751, lab2=, loff=0
!   reloc[217]: knd=0, off=43675, siz=4, lab1=.L2787, lab2=, loff=0
!   reloc[218]: knd=0, off=43767, siz=4, lab1=.L2814, lab2=, loff=0
!   reloc[219]: knd=0, off=43771, siz=4, lab1=.L2897, lab2=, loff=0
!   reloc[220]: knd=0, off=43776, siz=4, lab1=.L2815, lab2=, loff=0
!   reloc[221]: knd=0, off=43780, siz=4, lab1=.L2896, lab2=, loff=0
!   reloc[222]: knd=0, off=43850, siz=4, lab1=read_color_image, lab2=, loff=0
!   reloc[223]: knd=0, off=43854, siz=4, lab1=.L3104, lab2=, loff=0
!   reloc[224]: knd=0, off=44059, siz=4, lab1=.L2944, lab2=, loff=0
!   reloc[225]: knd=0, off=44063, siz=4, lab1=.L3100, lab2=, loff=0
!   reloc[226]: knd=0, off=44068, siz=4, lab1=.L2950, lab2=, loff=0
!   reloc[227]: knd=0, off=44072, siz=4, lab1=.L3097, lab2=, loff=0
!   reloc[228]: knd=0, off=44077, siz=4, lab1=.L2951, lab2=, loff=0
!   reloc[229]: knd=0, off=44081, siz=4, lab1=.L3096, lab2=, loff=0
!   reloc[230]: knd=0, off=44159, siz=4, lab1=.L2953, lab2=, loff=0
!   reloc[231]: knd=0, off=44163, siz=4, lab1=.L2982, lab2=, loff=0
!   reloc[232]: knd=0, off=44168, siz=4, lab1=.L2957, lab2=, loff=0
!   reloc[233]: knd=0, off=44172, siz=4, lab1=.L2981, lab2=, loff=0
!   reloc[234]: knd=0, off=44177, siz=4, lab1=.L2958, lab2=, loff=0
!   reloc[235]: knd=0, off=44181, siz=4, lab1=.L2980, lab2=, loff=0
!   reloc[236]: knd=0, off=44372, siz=4, lab1=gl_CopyTexImage1D, lab2=, loff=0
!   reloc[237]: knd=0, off=44376, siz=4, lab1=.L3207, lab2=, loff=0
!   reloc[238]: knd=0, off=44598, siz=4, lab1=gl_CopyTexImage2D, lab2=, loff=0
!   reloc[239]: knd=0, off=44602, siz=4, lab1=.L3325, lab2=, loff=0
!   reloc[240]: knd=0, off=44843, siz=4, lab1=copy_tex_sub_image, lab2=, loff=0
!   reloc[241]: knd=0, off=44847, siz=4, lab1=.L3494, lab2=, loff=0
!   reloc[242]: knd=0, off=45109, siz=4, lab1=.L3335, lab2=, loff=0
!   reloc[243]: knd=0, off=45113, siz=4, lab1=.L3492, lab2=, loff=0
!   reloc[244]: knd=0, off=45118, siz=4, lab1=.L3341, lab2=, loff=0
!   reloc[245]: knd=0, off=45122, siz=4, lab1=.L3489, lab2=, loff=0
!   reloc[246]: knd=0, off=45127, siz=4, lab1=.L3342, lab2=, loff=0
!   reloc[247]: knd=0, off=45131, siz=4, lab1=.L3488, lab2=, loff=0
!   reloc[248]: knd=0, off=45229, siz=4, lab1=.L3344, lab2=, loff=0
!   reloc[249]: knd=0, off=45233, siz=4, lab1=.L3373, lab2=, loff=0
!   reloc[250]: knd=0, off=45238, siz=4, lab1=.L3348, lab2=, loff=0
!   reloc[251]: knd=0, off=45242, siz=4, lab1=.L3372, lab2=, loff=0
!   reloc[252]: knd=0, off=45247, siz=4, lab1=.L3349, lab2=, loff=0
!   reloc[253]: knd=0, off=45251, siz=4, lab1=.L3371, lab2=, loff=0
!   reloc[254]: knd=0, off=45445, siz=4, lab1=gl_CopyTexSubImage1D, lab2=, loff=0
!   reloc[255]: knd=0, off=45449, siz=4, lab1=.L3602, lab2=, loff=0
!   reloc[256]: knd=0, off=45629, siz=4, lab1=gl_CopyTexSubImage2D, lab2=, loff=0
!   reloc[257]: knd=0, off=45633, siz=4, lab1=.L3746, lab2=, loff=0
!   reloc[258]: knd=0, off=45855, siz=4, lab1=gl_CopyTexSubImage3DEXT, lab2=, loff=0
!   reloc[259]: knd=0, off=45859, siz=4, lab1=.L3914, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0xb6,0x24,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "teximage.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  teximage.c -W0,-xp\\$XAa59JCSsd3L2LL.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCSsd3L2LL.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "logbase2\0"
	.byte 0x03,0x01,0x9b
	.uaword logbase2
	.uaword .L59
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x53,0x01
	.byte 0x00,0x00,0x01,0x53,0x03,0x00,0x00,0x01
	.byte 0x53
	.ascii "n\0"
	.byte 0x01,0x9a,0x03,0x91,0xc4,0x00,0x04
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x9c,0x02
	.byte 0x91,0x78,0x04
	.ascii "log2\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x9d,0x02
	.byte 0x91,0x74,0x00,0x05
	.ascii "int\0"
	.byte 0x05,0x04,0x06,0x00,0x00,0x01,0x53
	.ascii "GLint\0"
	.byte 0x02,0x02
	.ascii "decode_internal_format\0"
	.byte 0x03,0x01,0xb8
	.uaword decode_internal_format
	.uaword .L134
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x5a,0x01
	.byte 0x00,0x00,0x01,0xa8,0x03,0x00,0x00,0x01
	.byte 0x5a
	.ascii "format\0"
	.byte 0x01,0xb7,0x03,0x91,0xc4,0x00,0x00,0x02
	.ascii "components_in_intformat\0"
	.byte 0x03,0x01,0xff
	.uaword components_in_intformat
	.uaword .L209
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x5a,0x01
	.byte 0x00,0x00,0x01,0xeb,0x03,0x00,0x00,0x01
	.byte 0x5a
	.ascii "format\0"
	.byte 0x01,0xfe,0x03,0x91,0xc4,0x00,0x00,0x07
	.ascii "gl_alloc_texture_image\0"
	.byte 0x01,0x02,0x01,0x01,0x40
	.uaword gl_alloc_texture_image
	.uaword .L217
	.byte 0x01,0x6e,0x01,0x00,0x00,0x33,0x14,0x01
	.byte 0x08,0x04,0x02,0x00,0x00,0x31,0xb4,0x09
	.ascii "GL_FALSE\0"
	.byte 0x00,0x09
	.ascii "GL_TRUE\0"
	.byte 0x01,0x09
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x09
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x09
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x09
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x09
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x09
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x09
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x09
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x09
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x09
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x09
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x09
	.ascii "GL_LINES\0"
	.byte 0x01,0x09
	.ascii "GL_POINTS\0"
	.byte 0x00,0x09
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x09
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x09
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x09
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x09
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x09
	.ascii "GL_QUADS\0"
	.byte 0x07,0x09
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x09
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x09
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x09
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x09
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x09
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x09
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x09
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x09
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x09
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x09
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x09
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x09
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x09
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x09
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x09
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x09
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x09
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x09
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x09
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x09
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x09
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x09
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x09
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x09
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x09
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x09
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x09
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x09
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x09
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x09
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x09
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x09
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x09
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x09
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x09
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x09
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x09
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x09
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x09
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x09
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x09
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x09
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x09
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x09
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x09
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x09
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x09
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x09
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x09
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x09
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x09
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x09
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x09
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x09
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x09
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x09
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x09
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x09
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x09
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x09
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x09
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x09
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x09
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x09
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x09
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x09
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x09
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x09
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x09
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x09
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x09
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x09
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x09
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x09
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x09
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x09
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x09
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x09
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x09
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x09
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x09
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x09
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x09
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x09
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x09
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x09
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x09
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x09
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x09
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x09
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x09
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x09
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x09
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x09
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x09
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x09
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x09
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x09
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x09
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x09
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x09
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x09
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x09
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x09
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x09
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x09
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x09
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x09
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x09
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x09
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x09
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x09
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x09
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x09
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x09
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x09
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x09
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x09
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x09
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x09
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x09
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x09
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x09
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x09
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x09
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x09
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x09
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x09
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x09
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x09
	.ascii "GL_ZERO\0"
	.byte 0x00,0x09
	.ascii "GL_ONE\0"
	.byte 0x01,0x09
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x09
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x09
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x09
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x09
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x09
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x09
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x09
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x09
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x09
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x09
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x09
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x09
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x09
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x09
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x09
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x09
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x09
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x09
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x09
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x09
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x09
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x09
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x09
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x09
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x09
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x09
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x09
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x09
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x09
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x09
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x09
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x09
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x09
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x09
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x09
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x09
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x09
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x09
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x09
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x09
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x09
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x09
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x09
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x09
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x09
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x09
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x09
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x09
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x09
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x09
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x09
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x09
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x09
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x09
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x09
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x09
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x09
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x09
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x09
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x09
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x09
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x09
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x09
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x09
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x09
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x09
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x09
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x09
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x09
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x09
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x09
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x09
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x09
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x09
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x09
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x09
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x09
	.ascii "GL_NONE\0"
	.byte 0x00,0x09
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x09
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x09
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x09
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x09
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x09
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x09
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x09
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x09
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x09
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x09
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x09
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x09
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x09
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x09
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x09
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x09
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x09
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x09
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x09
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x09
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x09
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x09
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x09
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x09
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x09
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x09
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x09
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x09
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x09
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x09
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x09
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x09
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x09
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x09
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x09
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x09
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x09
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x09
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x09
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x09
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x09
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x09
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x09
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x09
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x09
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x09
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x09
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x09
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x09
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x09
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x09
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x09
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x09
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x09
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x09
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x09
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x09
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x09
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x09
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x09
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x09
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x09
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x09
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x09
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x09
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x09
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x09
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x09
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x09
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x09
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x09
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x09
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x09
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x09
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x09
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x09
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x09
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x09
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x09
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x09
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x09
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x09
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x09
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x09
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x09
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x09
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x09
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x09
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x09
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x09
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x09
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x09
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x09
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x09
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x09
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x09
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x09
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x09
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x09
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x09
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x09
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x09
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x09
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x09
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x09
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x09
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x09
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x09
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x09
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x09
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x09
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x09
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x09
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x09
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x09
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x09
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x09
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x09
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x09
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x09
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x09
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x09
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x09
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x09
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x09
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x09
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x09
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x09
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x09
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x09
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x09
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x09
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x09
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x09
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x09
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x09
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x09
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x09
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x09
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x09
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x09
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x09
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x09
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x09
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x09
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x09
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x09
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x09
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x09
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x09
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x09
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x09
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x09
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x09
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x09
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x09
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x09
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x09
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x09
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x09
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x09
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x09
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x09
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x09
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x09
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x09
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x09
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x09
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x09
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x09
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x09
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x09
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x09
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x09
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x09
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x09
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x09
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x09
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x09
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x09
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x09
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x09
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x09
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x09
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x09
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x09
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x09
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x09
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x09
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x09
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x09
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x09
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x09
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x09
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x09
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x09
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x09
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x09
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x09
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x09
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x09
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x09
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x09
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x09
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x09
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x09
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x09
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x09
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x09
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x09
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x09
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x09
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x09
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x09
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x09
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x09
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x09
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x09
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x09
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x09
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x09
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x09
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x09
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x09
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x09
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x09
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x09
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x09
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x09
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x09
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x09
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x09
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x09
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x09
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x09
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x09
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x09
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x09
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x09
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x09
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x09
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x09
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x09
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x09
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x09
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x09
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x09
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x09
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x09
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x09
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x09
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x09
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x09
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x09
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x09
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x09
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x09
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x09
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x09
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x09
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x09
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x09
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x09
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x09
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x09
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x09
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x09
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x09
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x09
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x09
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x09
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x09
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x09
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x09
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x09
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x09
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x09
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x09
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x09
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x09
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x09
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x09
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x09
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x09
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x09
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x09
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x09
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x09
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x09
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x09
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x09
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x09
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x09
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x09
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x09
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x09
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x06,0x00,0x00,0x02
	.byte 0x18
	.ascii "GLenum\0"
	.byte 0x02,0x05
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x06,0x00,0x00,0x31,0xc1
	.ascii "GLuint\0"
	.byte 0x02,0x05
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x06,0x00,0x00,0x31,0xda
	.ascii "GLubyte\0"
	.byte 0x02,0x0a,0x00,0x00,0x31,0xeb,0x05
	.ascii "void\0"
	.byte 0x05,0x00,0x0a,0x00,0x00,0x31,0xfe,0x0b
	.ascii "gl_texture_image\0"
	.byte 0x3c,0x03,0x00,0x00,0x33,0x14,0x0c
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "IntFormat\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "Border\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x08,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x0c,0x0c
	.ascii "Height\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x10,0x0c
	.ascii "Depth\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x14,0x0c
	.ascii "Width2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x18,0x0c
	.ascii "Height2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x1c,0x0c
	.ascii "Depth2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x20,0x0c
	.ascii "WidthLog2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x24,0x0c
	.ascii "HeightLog2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x28,0x0c
	.ascii "DepthLog2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x2c,0x0c
	.ascii "MaxLog2\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x30,0x0c
	.ascii "Data\0"
	.byte 0x00,0x00,0x31,0xf9,0x02,0x23,0x34,0x0c
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x38,0x00
	.byte 0x0a,0x00,0x00,0x32,0x0b,0x0d
	.ascii "gl_free_texture_image\0"
	.byte 0x01,0x02,0x01,0x01,0x47
	.uaword gl_free_texture_image
	.uaword .L235
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x33,0x5b
	.byte 0x0e,0x00,0x00,0x33,0x14
	.ascii "teximage\0"
	.byte 0x01,0x01,0x46,0x03,0x91,0xc4,0x00,0x00
	.byte 0x0f
	.ascii "image_to_texture\0"
	.byte 0x03,0x01,0x01,0x5b
	.uaword image_to_texture
	.uaword .L975
	.byte 0x01,0x6e,0x01,0x00,0x00,0x33,0x14,0x01
	.byte 0x00,0x00,0x39,0x12,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x01,0x59,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x9b,0x83
	.ascii "image\0"
	.byte 0x01,0x01,0x59,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalFormat\0"
	.byte 0x01,0x01,0x5a,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x01,0x5a,0x03,0x91,0xd0,0x00,0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x5c
	.byte 0x02,0x91,0x78,0x10
	.ascii "texImage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x01,0x5d
	.byte 0x02,0x91,0x74,0x10
	.ascii "numPixels\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x5e
	.byte 0x02,0x91,0x70,0x10
	.ascii "pixel\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x5e
	.byte 0x02,0x91,0x6c,0x10
	.ascii "scaleOrBias\0"
	.byte 0x00,0x00,0x39,0x77,0x01,0x01,0x01,0x5f
	.byte 0x02,0x91,0x6b,0x11
	.uaword .L375
	.uaword .L972
	.byte 0x11
	.uaword .L379
	.uaword .L969
	.byte 0x11
	.uaword .L380
	.uaword .L968
	.byte 0x11
	.uaword .L382
	.uaword .L510
	.byte 0x10
	.ascii "shift\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x9b
	.byte 0x02,0x91,0x44,0x10
	.ascii "offset\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x9c
	.byte 0x02,0x91,0x40,0x10
	.ascii "rMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x9e
	.byte 0x03,0x91,0xbc,0x7f,0x10
	.ascii "gMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0x9f
	.byte 0x03,0x91,0xb8,0x7f,0x10
	.ascii "bMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xa0
	.byte 0x03,0x91,0xb4,0x7f,0x10
	.ascii "aMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xa1
	.byte 0x03,0x91,0xb0,0x7f,0x10
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xa2
	.byte 0x03,0x91,0xac,0x7f,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xa2
	.byte 0x03,0x91,0xa8,0x7f,0x10
	.ascii "srcPtr\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x01,0xa3
	.byte 0x03,0x91,0xa4,0x7f,0x11
	.uaword .L397
	.uaword .L509
	.byte 0x11
	.uaword .L403
	.uaword .L506
	.byte 0x11
	.uaword .L404
	.uaword .L505
	.byte 0x10
	.ascii "bitMask\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xa8
	.byte 0x03,0x91,0x9f,0x7f,0x11
	.uaword .L406
	.uaword .L494
	.byte 0x11
	.uaword .L412
	.uaword .L491
	.byte 0x11
	.uaword .L413
	.uaword .L490
	.byte 0x10
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xaa
	.byte 0x03,0x91,0x98,0x7f,0x10
	.ascii "red\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xab
	.byte 0x03,0x91,0x97,0x7f,0x10
	.ascii "green\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xab
	.byte 0x03,0x91,0x96,0x7f,0x10
	.ascii "blue\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xab
	.byte 0x03,0x91,0x95,0x7f,0x10
	.ascii "alpha\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xab
	.byte 0x03,0x91,0x94,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x11
	.uaword .L513
	.uaword .L730
	.byte 0x11
	.uaword .L519
	.uaword .L727
	.byte 0x11
	.uaword .L520
	.uaword .L726
	.byte 0x10
	.ascii "red\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xea
	.byte 0x02,0x91,0x47,0x10
	.ascii "green\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xea
	.byte 0x02,0x91,0x46,0x10
	.ascii "blue\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xea
	.byte 0x02,0x91,0x45,0x10
	.ascii "alpha\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x01,0xea
	.byte 0x02,0x91,0x44,0x11
	.uaword .L521
	.uaword .L606
	.byte 0x11
	.uaword .L525
	.uaword .L603
	.byte 0x11
	.uaword .L526
	.uaword .L602
	.byte 0x11
	.uaword .L528
	.uaword .L548
	.byte 0x11
	.uaword .L532
	.uaword .L537
	.byte 0x11
	.uaword .L533
	.uaword .L536
	.byte 0x10
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xef
	.byte 0x02,0x91,0x40,0x00,0x00,0x11
	.uaword .L539
	.uaword .L547
	.byte 0x11
	.uaword .L540
	.uaword .L546
	.byte 0x10
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x01,0xf4
	.byte 0x02,0x91,0x40,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x11
	.uaword .L607
	.uaword .L683
	.byte 0x11
	.uaword .L613
	.uaword .L682
	.byte 0x11
	.uaword .L614
	.uaword .L681
	.byte 0x10
	.ascii "r\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x33
	.byte 0x02,0x91,0x40,0x10
	.ascii "g\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x34
	.byte 0x03,0x91,0xbc,0x7f,0x10
	.ascii "b\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x35
	.byte 0x03,0x91,0xb8,0x7f,0x10
	.ascii "a\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x36
	.byte 0x03,0x91,0xb4,0x7f,0x11
	.uaword .L660
	.uaword .L676
	.byte 0x11
	.uaword .L664
	.uaword .L675
	.byte 0x11
	.uaword .L665
	.uaword .L674
	.byte 0x10
	.ascii "ir\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x44
	.byte 0x03,0x91,0xb0,0x7f,0x10
	.ascii "ig\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x45
	.byte 0x03,0x91,0xac,0x7f,0x10
	.ascii "ib\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x46
	.byte 0x03,0x91,0xa8,0x7f,0x10
	.ascii "ia\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x47
	.byte 0x03,0x91,0xa4,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x11
	.uaword .L733
	.uaword .L962
	.byte 0x11
	.uaword .L739
	.uaword .L959
	.byte 0x11
	.uaword .L740
	.uaword .L958
	.byte 0x10
	.ascii "red\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x79
	.byte 0x02,0x91,0x44,0x10
	.ascii "green\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x79
	.byte 0x02,0x91,0x40,0x10
	.ascii "blue\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x79
	.byte 0x03,0x91,0xbc,0x7f,0x10
	.ascii "alpha\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x02,0x79
	.byte 0x03,0x91,0xb8,0x7f,0x11
	.uaword .L741
	.uaword .L848
	.byte 0x11
	.uaword .L745
	.uaword .L845
	.byte 0x11
	.uaword .L746
	.uaword .L844
	.byte 0x11
	.uaword .L748
	.uaword .L790
	.byte 0x11
	.uaword .L752
	.uaword .L757
	.byte 0x11
	.uaword .L753
	.uaword .L756
	.byte 0x10
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x7e
	.byte 0x03,0x91,0xb4,0x7f,0x00,0x00,0x11
	.uaword .L759
	.uaword .L789
	.byte 0x11
	.uaword .L760
	.uaword .L788
	.byte 0x10
	.ascii "shift\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x82
	.byte 0x03,0x91,0xb4,0x7f,0x10
	.ascii "offset\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x83
	.byte 0x03,0x91,0xb0,0x7f,0x10
	.ascii "rMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x85
	.byte 0x03,0x91,0xac,0x7f,0x10
	.ascii "gMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x86
	.byte 0x03,0x91,0xa8,0x7f,0x10
	.ascii "bMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x87
	.byte 0x03,0x91,0xa4,0x7f,0x10
	.ascii "aMask\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x88
	.byte 0x03,0x91,0xa0,0x7f,0x10
	.ascii "index\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0x8a
	.byte 0x03,0x91,0x9c,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x11
	.uaword .L849
	.uaword .L915
	.byte 0x11
	.uaword .L853
	.uaword .L914
	.byte 0x11
	.uaword .L854
	.uaword .L913
	.byte 0x11
	.uaword .L896
	.uaword .L912
	.byte 0x11
	.uaword .L900
	.uaword .L911
	.byte 0x11
	.uaword .L901
	.uaword .L910
	.byte 0x10
	.ascii "ir\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0xdd
	.byte 0x03,0x91,0xb4,0x7f,0x10
	.ascii "ig\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0xde
	.byte 0x03,0x91,0xb0,0x7f,0x10
	.ascii "ib\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0xdf
	.byte 0x03,0x91,0xac,0x7f,0x10
	.ascii "ia\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x02,0xe0
	.byte 0x03,0x91,0xa8,0x7f,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x12
	.ascii "HashTable\0"
	.byte 0x01,0x0a,0x00,0x00,0x39,0x12,0x05
	.ascii "float\0"
	.byte 0x04,0x04,0x06,0x00,0x00,0x39,0x23
	.ascii "GLfloat\0"
	.byte 0x02,0x05
	.ascii "long\0"
	.byte 0x05,0x04,0x13,0x00,0x00,0x01,0x5a,0x10
	.byte 0x00,0x00,0x39,0x53,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x33,0x14
	.byte 0x2c,0x00,0x00,0x39,0x64,0x14,0x00,0x00
	.byte 0x39,0x3a,0x0a,0x00,0x15,0x00,0x00,0x31
	.byte 0xeb,0x04,0x00,0x00,0x00,0x39,0x77,0x16
	.byte 0x00,0x00,0x39,0x3a,0x03,0xff,0x00,0x06
	.byte 0x00,0x00,0x31,0xda
	.ascii "GLboolean\0"
	.byte 0x02,0x17
	.ascii "gl_texture_object\0"
	.byte 0x04,0x84,0x03,0x00,0x00,0x3b,0x16,0x0c
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "Name\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x04,0x0c
	.ascii "Dimensions\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x08,0x0c
	.ascii "Priority\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x0c,0x0c
	.ascii "BorderColor\0"
	.byte 0x00,0x00,0x39,0x42,0x02,0x23,0x10,0x0c
	.ascii "WrapS\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x20,0x0c
	.ascii "WrapT\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x24,0x0c
	.ascii "WrapR\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x28,0x0c
	.ascii "MinFilter\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x2c,0x0c
	.ascii "MagFilter\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x30,0x0c
	.ascii "MinMagThresh\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x34,0x0c
	.ascii "Image\0"
	.byte 0x00,0x00,0x39,0x53,0x02,0x23,0x38,0x0c
	.ascii "Palette\0"
	.byte 0x00,0x00,0x39,0x64,0x02,0x23,0x64,0x0c
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xe4,0x08
	.byte 0x0c
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0xb4,0x03,0x23,0xe8,0x08
	.byte 0x0c
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0xb4,0x03,0x23,0xec,0x08
	.byte 0x0c
	.ascii "Dirty\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xf0,0x08
	.byte 0x0c
	.ascii "DriverData\0"
	.byte 0x00,0x00,0x32,0x06,0x03,0x23,0xf4,0x08
	.byte 0x0c
	.ascii "Complete\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xf8,0x08
	.byte 0x0c
	.ascii "SampleFunc\0"
	.byte 0x00,0x00,0x3b,0x8c,0x03,0x23,0xfc,0x08
	.byte 0x0c
	.ascii "Next\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0x80,0x09
	.byte 0x00,0x18,0x00,0x00,0x39,0x87,0x0a,0x00
	.byte 0x00,0x3b,0x16,0x18,0x00,0x00,0x39,0x23
	.byte 0x0a,0x00,0x00,0x3b,0x20,0x18,0x00,0x00
	.byte 0x39,0x23,0x0a,0x00,0x00,0x3b,0x2a,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x3b
	.byte 0x34,0x18,0x00,0x00,0x39,0x23,0x0a,0x00
	.byte 0x00,0x3b,0x3e,0x0a,0x00,0x00,0x31,0xda
	.byte 0x19,0x01,0x01,0x00,0x00,0x3b,0x87,0x1a
	.byte 0x00,0x00,0x3b,0x1b,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x3b,0x25,0x1a,0x00
	.byte 0x00,0x3b,0x2f,0x1a,0x00,0x00,0x3b,0x39
	.byte 0x1a,0x00,0x00,0x3b,0x43,0x1a,0x00,0x00
	.byte 0x3b,0x48,0x1a,0x00,0x00,0x3b,0x48,0x1a
	.byte 0x00,0x00,0x3b,0x48,0x1a,0x00,0x00,0x3b
	.byte 0x48,0x00,0x0a,0x00,0x00,0x3b,0x4d,0x06
	.byte 0x00,0x00,0x3b,0x87
	.ascii "TextureSampleFunc\0"
	.byte 0x03,0x0a,0x00,0x00,0x39,0x87,0x0b
	.ascii "gl_shared_state\0"
	.byte 0x1c,0x03,0x00,0x00,0x3c,0x45,0x0c
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "DisplayList\0"
	.byte 0x00,0x00,0x39,0x1e,0x02,0x23,0x04,0x0c
	.ascii "TexObjects\0"
	.byte 0x00,0x00,0x39,0x1e,0x02,0x23,0x08,0x0c
	.ascii "TexObjectList\0"
	.byte 0x00,0x00,0x3b,0xa4,0x02,0x23,0x0c,0x0c
	.ascii "Default1D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x02,0x23,0x10,0x0c
	.ascii "Default2D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x02,0x23,0x14,0x0c
	.ascii "Default3D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x02,0x23,0x18,0x00
	.byte 0x0a,0x00,0x00,0x3b,0xa9,0x17
	.ascii "gl_context\0"
	.byte 0xe1,0x40,0x03,0x00,0x00,0x43,0x17,0x0c
	.ascii "Shared\0"
	.byte 0x00,0x00,0x3c,0x45,0x02,0x23,0x00,0x0c
	.ascii "API\0"
	.byte 0x00,0x00,0x5c,0x02,0x02,0x23,0x04,0x0c
	.ascii "Save\0"
	.byte 0x00,0x00,0x5c,0x02,0x03,0x23,0xe0,0x05
	.byte 0x0c
	.ascii "Exec\0"
	.byte 0x00,0x00,0x5c,0x02,0x03,0x23,0xbc,0x0b
	.byte 0x0c
	.ascii "Visual\0"
	.byte 0x00,0x00,0x6c,0x5d,0x03,0x23,0x98,0x11
	.byte 0x0c
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x6d,0x91,0x03,0x23,0x9c,0x11
	.byte 0x0c
	.ascii "Driver\0"
	.byte 0x00,0x00,0x76,0xa0,0x03,0x23,0xa0,0x11
	.byte 0x0c
	.ascii "DriverCtx\0"
	.byte 0x00,0x00,0x32,0x06,0x03,0x23,0xf4,0x12
	.byte 0x0c
	.ascii "DriverMgrCtx\0"
	.byte 0x00,0x00,0x32,0x06,0x03,0x23,0xf8,0x12
	.byte 0x0c
	.ascii "NewModelViewMatrix\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xfc,0x12
	.byte 0x0c
	.ascii "ModelViewMatrixType\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0x80,0x13
	.byte 0x0c
	.ascii "ModelViewMatrix\0"
	.byte 0x00,0x00,0x7b,0x08,0x03,0x23,0x84,0x13
	.byte 0x0c
	.ascii "ModelViewInv\0"
	.byte 0x00,0x00,0x7b,0x19,0x03,0x23,0xc4,0x13
	.byte 0x0c
	.ascii "ModelViewStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0x84,0x14
	.byte 0x0c
	.ascii "ModelViewStack\0"
	.byte 0x00,0x00,0x7b,0x3b,0x03,0x23,0x88,0x14
	.byte 0x0c
	.ascii "NewProjectionMatrix\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0x88,0x24
	.byte 0x0c
	.ascii "ProjectionMatrixType\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0x8c,0x24
	.byte 0x0c
	.ascii "ProjectionMatrix\0"
	.byte 0x00,0x00,0x7b,0x4d,0x03,0x23,0x90,0x24
	.byte 0x0c
	.ascii "ProjectionStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xd0,0x24
	.byte 0x0c
	.ascii "ProjectionStack\0"
	.byte 0x00,0x00,0x7b,0x6f,0x03,0x23,0xd4,0x24
	.byte 0x0c
	.ascii "NearFarStack\0"
	.byte 0x00,0x00,0x7b,0x92,0x03,0x23,0xd4,0x34
	.byte 0x0c
	.ascii "NewTextureMatrix\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xd4,0x36
	.byte 0x0c
	.ascii "TextureMatrixType\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xd8,0x36
	.byte 0x0c
	.ascii "TextureMatrix\0"
	.byte 0x00,0x00,0x7b,0xa4,0x03,0x23,0xdc,0x36
	.byte 0x0c
	.ascii "TextureStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0x9c,0x37
	.byte 0x0c
	.ascii "TextureStack\0"
	.byte 0x00,0x00,0x7b,0xc6,0x03,0x23,0xa0,0x37
	.byte 0x0c
	.ascii "CallDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xa0,0x3c
	.byte 0x0c
	.ascii "ExecuteFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xa4,0x3c
	.byte 0x0c
	.ascii "CompileFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xa5,0x3c
	.byte 0x0c
	.ascii "AttribStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xa8,0x3c
	.byte 0x0c
	.ascii "AttribStack\0"
	.byte 0x00,0x00,0x7c,0x2c,0x03,0x23,0xac,0x3c
	.byte 0x0c
	.ascii "Accum\0"
	.byte 0x00,0x00,0x7c,0x4e,0x03,0x23,0xec,0x3c
	.byte 0x0c
	.ascii "Color\0"
	.byte 0x00,0x00,0x7c,0x9b,0x03,0x23,0xfc,0x3c
	.byte 0x0c
	.ascii "Current\0"
	.byte 0x00,0x00,0x7e,0xb0,0x03,0x23,0xd4,0x3d
	.byte 0x0c
	.ascii "Depth\0"
	.byte 0x00,0x00,0x7f,0x9a,0x03,0x23,0xb4,0x3e
	.byte 0x0c
	.ascii "Eval\0"
	.byte 0x00,0x00,0x7f,0xed,0x03,0x23,0xc0,0x3e
	.byte 0x0c
	.ascii "Fog\0"
	.byte 0x00,0x00,0x82,0x63,0x03,0x23,0xf8,0x3e
	.byte 0x0c
	.ascii "Hint\0"
	.byte 0x00,0x00,0x82,0xdc,0x03,0x23,0xa0,0x3f
	.byte 0x0c
	.ascii "Light\0"
	.byte 0x00,0x00,0x87,0xe7,0x03,0x23,0xb4,0x3f
	.byte 0x0c
	.ascii "Line\0"
	.byte 0x00,0x00,0x89,0x17,0x04,0x23,0x88,0xdc
	.byte 0x02,0x0c
	.ascii "List\0"
	.byte 0x00,0x00,0x89,0x90
	.byte 0x04,0x23,0x94,0xdc,0x02,0x0c
	.ascii "Pixel\0"
	.byte 0x00,0x00,0x8a,0x76,0x04,0x23,0x98,0xdc
	.byte 0x02,0x0c
	.ascii "Point\0"
	.byte 0x00,0x00,0x8d,0x46,0x04,0x23,0x80,0xad
	.byte 0x03,0x0c
	.ascii "Polygon\0"
	.byte 0x00,0x00,0x8d,0xbf,0x04,0x23,0xa0,0xad
	.byte 0x03,0x0c
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x8e,0xf2,0x04,0x23,0xc8,0xad
	.byte 0x03,0x0c
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x8f,0x11,0x04,0x23,0xc8,0xae
	.byte 0x03,0x0c
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x8f,0x6c,0x04,0x23,0xdc,0xae
	.byte 0x03,0x0c
	.ascii "Texture\0"
	.byte 0x00,0x00,0x90,0xc6,0x04,0x23,0xf4,0xae
	.byte 0x03,0x0c
	.ascii "Transform\0"
	.byte 0x00,0x00,0x93,0x28,0x04,0x23,0xcc,0xb8
	.byte 0x03,0x0c
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x93,0xa2,0x04,0x23,0xb8,0xb9
	.byte 0x03,0x0c
	.ascii "ClientAttribStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0xe8,0xb9
	.byte 0x03,0x0c
	.ascii "ClientAttribStack\0"
	.byte 0x00,0x00,0x94,0x49,0x04,0x23,0xec,0xb9
	.byte 0x03,0x0c
	.ascii "Array\0"
	.byte 0x00,0x00,0x94,0x5f,0x04,0x23,0xac,0xba
	.byte 0x03,0x0c
	.ascii "Pack\0"
	.byte 0x00,0x00,0x97,0x0a,0x04,0x23,0xac,0xbb
	.byte 0x03,0x0c
	.ascii "Unpack\0"
	.byte 0x00,0x00,0x97,0x0a,0x04,0x23,0xc8,0xbb
	.byte 0x03,0x0c
	.ascii "EvalMap\0"
	.byte 0x00,0x00,0x98,0x8c,0x04,0x23,0xe4,0xbb
	.byte 0x03,0x0c
	.ascii "Feedback\0"
	.byte 0x00,0x00,0x9a,0x16,0x04,0x23,0xb8,0xbf
	.byte 0x03,0x0c
	.ascii "Select\0"
	.byte 0x00,0x00,0x9a,0x8b,0x04,0x23,0xcc,0xbf
	.byte 0x03,0x0c
	.ascii "ErrorValue\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0xec,0xc1
	.byte 0x03,0x0c
	.ascii "DirectContext\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0xf0,0xc1
	.byte 0x03,0x0c
	.ascii "NewState\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0xf4,0xc1
	.byte 0x03,0x0c
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0xf8,0xc1
	.byte 0x03,0x0c
	.ascii "Primitive\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0xfc,0xc1
	.byte 0x03,0x0c
	.ascii "StippleCounter\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0x80,0xc2
	.byte 0x03,0x0c
	.ascii "ClipMask\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0x84,0xc2
	.byte 0x03,0x0c
	.ascii "RasterMask\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0x88,0xc2
	.byte 0x03,0x0c
	.ascii "LightTwoSide\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x8c,0xc2
	.byte 0x03,0x0c
	.ascii "DirectTriangles\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x8d,0xc2
	.byte 0x03,0x0c
	.ascii "PolygonZoffset\0"
	.byte 0x00,0x00,0x39,0x2c,0x04,0x23,0x90,0xc2
	.byte 0x03,0x0c
	.ascii "LineZoffset\0"
	.byte 0x00,0x00,0x39,0x2c,0x04,0x23,0x94,0xc2
	.byte 0x03,0x0c
	.ascii "PointZoffset\0"
	.byte 0x00,0x00,0x39,0x2c,0x04,0x23,0x98,0xc2
	.byte 0x03,0x0c
	.ascii "NeedNormals\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x9c,0xc2
	.byte 0x03,0x0c
	.ascii "FastDrawPixels\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x9d,0xc2
	.byte 0x03,0x0c
	.ascii "MutablePixels\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x9e,0xc2
	.byte 0x03,0x0c
	.ascii "MonoPixels\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x9f,0xc2
	.byte 0x03,0x0c
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x73,0xdb,0x04,0x23,0xa0,0xc2
	.byte 0x03,0x0c
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x74,0x0e,0x04,0x23,0xa4,0xc2
	.byte 0x03,0x0c
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x74,0x44,0x04,0x23,0xa8,0xc2
	.byte 0x03,0x0c
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x74,0x83,0x04,0x23,0xac,0xc2
	.byte 0x03,0x0c
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x74,0xb9,0x04,0x23,0xb0,0xc2
	.byte 0x03,0x0c
	.ascii "VB\0"
	.byte 0x00,0x00,0x9b,0x50,0x04,0x23,0xb4,0xc2
	.byte 0x03,0x0c
	.ascii "PB\0"
	.byte 0x00,0x00,0x9b,0x64,0x04,0x23,0xb8,0xc2
	.byte 0x03,0x0c
	.ascii "NoRaster\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0xbc,0xc2
	.byte 0x03,0x0c
	.ascii "NoDither\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0xbd,0xc2
	.byte 0x03,0x00,0x0a,0x00,0x00,0x3c,0x4a,0x19
	.byte 0x01,0x01,0x00,0x00,0x43,0x33,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x39,0x23,0x00,0x0a,0x00
	.byte 0x00,0x43,0x1c,0x19,0x01,0x01,0x00,0x00
	.byte 0x43,0x4f,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x43,0x38,0x18
	.byte 0x00,0x00,0x31,0xc1,0x0a,0x00,0x00,0x43
	.byte 0x54,0x1b,0x01,0x00,0x00,0x31,0xda,0x01
	.byte 0x00,0x00,0x43,0x7e,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x43,0x59,0x1a,0x00,0x00,0x3b,0x48
	.byte 0x00,0x0a,0x00,0x00,0x43,0x5e,0x19,0x01
	.byte 0x01,0x00,0x00,0x43,0x95,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x00
	.byte 0x0a,0x00,0x00,0x43,0x83,0x19,0x01,0x01
	.byte 0x00,0x00,0x43,0xac,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x00,0x0a
	.byte 0x00,0x00,0x43,0x9a,0x19,0x01,0x01,0x00
	.byte 0x00,0x43,0xc8,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x00,0x0a,0x00,0x00,0x43,0xb1
	.byte 0x06,0x00,0x00,0x31,0xfe
	.ascii "GLvoid\0"
	.byte 0x02,0x0a,0x00,0x00,0x43,0xcd,0x0b
	.ascii "gl_image\0"
	.byte 0x24,0x03,0x00,0x00,0x44,0x7c,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "Depth\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x08,0x0c
	.ascii "Components\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x0c,0x0c
	.ascii "Format\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x10,0x0c
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x14,0x0c
	.ascii "Data\0"
	.byte 0x00,0x00,0x43,0xda,0x02,0x23,0x18,0x0c
	.ascii "Interleaved\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x1c,0x0c
	.ascii "RefCount\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x20,0x00
	.byte 0x18,0x00,0x00,0x43,0xdf,0x0a,0x00,0x00
	.byte 0x44,0x7c,0x19,0x01,0x01,0x00,0x00,0x44
	.byte 0xb6,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x44
	.byte 0x81,0x00,0x0a,0x00,0x00,0x44,0x86,0x19
	.byte 0x01,0x01,0x00,0x00,0x44,0xdc,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x44,0xbb,0x19,0x01,0x01
	.byte 0x00,0x00,0x44,0xf3,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x00,0x0a
	.byte 0x00,0x00,0x44,0xe1,0x19,0x01,0x01,0x00
	.byte 0x00,0x45,0x0f,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x02,0x18,0x00,0x0a,0x00,0x00,0x44,0xf8
	.byte 0x19,0x01,0x01,0x00,0x00,0x45,0x26,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x00,0x0a,0x00,0x00,0x45,0x14,0x18
	.byte 0x00,0x00,0x31,0xfe,0x0a,0x00,0x00,0x45
	.byte 0x2b,0x19,0x01,0x01,0x00,0x00,0x45,0x51
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x45,0x30,0x00,0x0a,0x00,0x00
	.byte 0x45,0x35,0x19,0x01,0x01,0x00,0x00,0x45
	.byte 0x68,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x0a,0x00,0x00,0x45
	.byte 0x56,0x19,0x01,0x01,0x00,0x00,0x45,0x8e
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x45,0x6d,0x19
	.byte 0x01,0x01,0x00,0x00,0x45,0xb4,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x45,0x93,0x05
	.ascii "double\0"
	.byte 0x04,0x08,0x19,0x01,0x01,0x00,0x00,0x45
	.byte 0xd5,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x45,0xb9,0x00,0x0a,0x00,0x00,0x45
	.byte 0xc3,0x19,0x01,0x01,0x00,0x00,0x45,0xec
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x39,0x23,0x00,0x0a,0x00,0x00,0x45,0xda
	.byte 0x19,0x01,0x01,0x00,0x00,0x46,0x03,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x01
	.byte 0x53,0x00,0x0a,0x00,0x00,0x45,0xf1,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x46
	.byte 0x08,0x19,0x01,0x01,0x00,0x00,0x46,0x29
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x46,0x0d,0x00
	.byte 0x0a,0x00,0x00,0x46,0x12,0x19,0x01,0x01
	.byte 0x00,0x00,0x46,0x4a,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x39,0x23,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x46,0x2e,0x18,0x00
	.byte 0x00,0x39,0x23,0x0a,0x00,0x00,0x46,0x4f
	.byte 0x19,0x01,0x01,0x00,0x00,0x46,0x6b,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x46
	.byte 0x54,0x00,0x0a,0x00,0x00,0x46,0x59,0x19
	.byte 0x01,0x01,0x00,0x00,0x46,0x91,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x46,0x70,0x18,0x00,0x00
	.byte 0x39,0x23,0x0a,0x00,0x00,0x46,0x96,0x19
	.byte 0x01,0x01,0x00,0x00,0x46,0xb2,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x46,0x9b
	.byte 0x00,0x0a,0x00,0x00,0x46,0xa0,0x19,0x01
	.byte 0x01,0x00,0x00,0x46,0xd8,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x31,0xda,0x1a
	.byte 0x00,0x00,0x31,0xda,0x1a,0x00,0x00,0x31
	.byte 0xda,0x1a,0x00,0x00,0x31,0xda,0x00,0x0a
	.byte 0x00,0x00,0x46,0xb7,0x18,0x00,0x00,0x31
	.byte 0xda,0x0a,0x00,0x00,0x46,0xdd,0x19,0x01
	.byte 0x01,0x00,0x00,0x46,0xf9,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x46,0xe2,0x00
	.byte 0x0a,0x00,0x00,0x46,0xe7,0x19,0x01,0x01
	.byte 0x00,0x00,0x47,0x1f,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xda,0x1a,0x00
	.byte 0x00,0x31,0xda,0x1a,0x00,0x00,0x31,0xda
	.byte 0x1a,0x00,0x00,0x31,0xda,0x00,0x0a,0x00
	.byte 0x00,0x46,0xfe,0x19,0x01,0x01,0x00,0x00
	.byte 0x47,0x3b,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x00,0x0a,0x00,0x00,0x47,0x24,0x18
	.byte 0x00,0x00,0x31,0xfe,0x0a,0x00,0x00,0x47
	.byte 0x40,0x19,0x01,0x01,0x00,0x00,0x47,0x6b
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x47
	.byte 0x45,0x00,0x0a,0x00,0x00,0x47,0x4a,0x0a
	.byte 0x00,0x00,0x43,0xdf,0x19,0x01,0x01,0x00
	.byte 0x00,0x47,0x91,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x47,0x70,0x00
	.byte 0x0a,0x00,0x00,0x47,0x75,0x19,0x01,0x01
	.byte 0x00,0x00,0x47,0xb2,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x47,0x70
	.byte 0x00,0x0a,0x00,0x00,0x47,0x96,0x19,0x01
	.byte 0x01,0x00,0x00,0x47,0xdd,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x47
	.byte 0xb7,0x19,0x01,0x01,0x00,0x00,0x48,0x12
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x00,0x0a,0x00,0x00,0x47,0xe2,0x19,0x01
	.byte 0x01,0x00,0x00,0x48,0x4c,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x00,0x0a,0x00,0x00,0x48,0x17
	.byte 0x19,0x01,0x01,0x00,0x00,0x48,0x7c,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x00,0x0a,0x00,0x00,0x48,0x51
	.byte 0x19,0x01,0x01,0x00,0x00,0x48,0xb6,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x48,0x81,0x19,0x01,0x01,0x00,0x00,0x48
	.byte 0xf5,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x00,0x0a,0x00,0x00,0x48
	.byte 0xbb,0x19,0x01,0x01,0x00,0x00,0x49,0x0c
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x00,0x0a,0x00,0x00,0x48,0xfa
	.byte 0x19,0x01,0x01,0x00,0x00,0x49,0x28,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x01,0x53,0x00,0x0a
	.byte 0x00,0x00,0x49,0x11,0x18,0x00,0x00,0x31
	.byte 0xc1,0x0a,0x00,0x00,0x49,0x2d,0x19,0x01
	.byte 0x01,0x00,0x00,0x49,0x4e,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x49,0x32,0x00,0x0a,0x00,0x00
	.byte 0x49,0x37,0x19,0x01,0x01,0x00,0x00,0x49
	.byte 0x65,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x49
	.byte 0x53,0x19,0x01,0x01,0x00,0x00,0x49,0x7c
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xda,0x00,0x0a,0x00,0x00,0x49,0x6a
	.byte 0x19,0x01,0x01,0x00,0x00,0x49,0x98,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x45
	.byte 0xb9,0x1a,0x00,0x00,0x45,0xb9,0x00,0x0a
	.byte 0x00,0x00,0x49,0x81,0x19,0x01,0x01,0x00
	.byte 0x00,0x49,0xaf,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x00,0x0a,0x00
	.byte 0x00,0x49,0x9d,0x19,0x01,0x01,0x00,0x00
	.byte 0x49,0xc6,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x49,0xb4,0x19,0x01,0x01,0x00,0x00,0x49
	.byte 0xe7,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x00,0x0a,0x00
	.byte 0x00,0x49,0xcb,0x19,0x01,0x01,0x00,0x00
	.byte 0x49,0xfe,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x49,0xec,0x18,0x00,0x00,0x31,0xfe,0x0a
	.byte 0x00,0x00,0x4a,0x03,0x19,0x01,0x01,0x00
	.byte 0x00,0x4a,0x2e,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x4a,0x08,0x00,0x0a,0x00,0x00
	.byte 0x4a,0x0d,0x18,0x00,0x00,0x31,0xfe,0x0a
	.byte 0x00,0x00,0x4a,0x33,0x19,0x01,0x01,0x00
	.byte 0x00,0x4a,0x63,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x4a
	.byte 0x38,0x00,0x0a,0x00,0x00,0x4a,0x3d,0x19
	.byte 0x01,0x01,0x00,0x00,0x4a,0x7a,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xda
	.byte 0x00,0x0a,0x00,0x00,0x4a,0x68,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x4a,0x7f
	.byte 0x19,0x01,0x01,0x00,0x00,0x4a,0xa0,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x4a,0x84,0x00,0x0a
	.byte 0x00,0x00,0x4a,0x89,0x19,0x01,0x01,0x00
	.byte 0x00,0x4a,0xb7,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x00,0x0a,0x00
	.byte 0x00,0x4a,0xa5,0x19,0x01,0x01,0x00,0x00
	.byte 0x4a,0xce,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x4a,0xbc,0x19,0x01,0x01,0x00,0x00,0x4a
	.byte 0xe0,0x1a,0x00,0x00,0x43,0x17,0x00,0x0a
	.byte 0x00,0x00,0x4a,0xd3,0x19,0x01,0x01,0x00
	.byte 0x00,0x4a,0xf2,0x1a,0x00,0x00,0x43,0x17
	.byte 0x00,0x0a,0x00,0x00,0x4a,0xe5,0x19,0x01
	.byte 0x01,0x00,0x00,0x4b,0x09,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x4a,0xf7,0x19,0x01,0x01
	.byte 0x00,0x00,0x4b,0x25,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x39,0x23,0x1a,0x00
	.byte 0x00,0x39,0x23,0x00,0x0a,0x00,0x00,0x4b
	.byte 0x0e,0x19,0x01,0x01,0x00,0x00,0x4b,0x46
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x4b,0x2a,0x19,0x01,0x01,0x00,0x00,0x4b
	.byte 0x71,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x00
	.byte 0x0a,0x00,0x00,0x4b,0x4b,0x19,0x01,0x01
	.byte 0x00,0x00,0x4b,0x88,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x01,0x53,0x00,0x0a
	.byte 0x00,0x00,0x4b,0x76,0x19,0x01,0x01,0x00
	.byte 0x00,0x4b,0xa4,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x00,0x0a,0x00,0x00,0x4b,0x8d
	.byte 0x0a,0x00,0x00,0x39,0x23,0x19,0x01,0x01
	.byte 0x00,0x00,0x4b,0xca,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x4b,0xa9
	.byte 0x00,0x0a,0x00,0x00,0x4b,0xae,0x19,0x01
	.byte 0x01,0x00,0x00,0x4b,0xdc,0x1a,0x00,0x00
	.byte 0x43,0x17,0x00,0x0a,0x00,0x00,0x4b,0xcf
	.byte 0x19,0x01,0x01,0x00,0x00,0x4b,0xee,0x1a
	.byte 0x00,0x00,0x43,0x17,0x00,0x0a,0x00,0x00
	.byte 0x4b,0xe1,0x18,0x00,0x00,0x39,0x23,0x0a
	.byte 0x00,0x00,0x4b,0xf3,0x19,0x01,0x01,0x00
	.byte 0x00,0x4c,0x14,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4b,0xf8,0x00,0x0a,0x00,0x00,0x4b,0xfd
	.byte 0x19,0x01,0x01,0x00,0x00,0x4c,0x2b,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x00,0x0a,0x00,0x00,0x4c,0x19,0x19
	.byte 0x01,0x01,0x00,0x00,0x4c,0x5b,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x45,0xb9
	.byte 0x1a,0x00,0x00,0x45,0xb9,0x1a,0x00,0x00
	.byte 0x45,0xb9,0x1a,0x00,0x00,0x45,0xb9,0x1a
	.byte 0x00,0x00,0x45,0xb9,0x1a,0x00,0x00,0x45
	.byte 0xb9,0x00,0x0a,0x00,0x00,0x4c,0x30,0x1b
	.byte 0x01,0x00,0x00,0x31,0xc1,0x01,0x00,0x00
	.byte 0x4c,0x76,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x4c,0x60,0x0a,0x00,0x00,0x31,0xc1,0x19
	.byte 0x01,0x01,0x00,0x00,0x4c,0x97,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x4c,0x7b,0x00,0x0a,0x00
	.byte 0x00,0x4c,0x80,0x19,0x01,0x01,0x00,0x00
	.byte 0x4c,0xb3,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x3b
	.byte 0x48,0x00,0x0a,0x00,0x00,0x4c,0x9c,0x0a
	.byte 0x00,0x00,0x45,0xb9,0x19,0x01,0x01,0x00
	.byte 0x00,0x4c,0xd4,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4c,0xb8,0x00,0x0a,0x00,0x00,0x4c,0xbd
	.byte 0x19,0x01,0x01,0x00,0x00,0x4c,0xfa,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x32,0x06
	.byte 0x00,0x0a,0x00,0x00,0x4c,0xd9,0x0a,0x00
	.byte 0x00,0x01,0x53,0x19,0x01,0x01,0x00,0x00
	.byte 0x4d,0x20,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x4c,0xff,0x00,0x0a
	.byte 0x00,0x00,0x4d,0x04,0x19,0x01,0x01,0x00
	.byte 0x00,0x4d,0x3c,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4c,0xb8,0x00,0x0a,0x00,0x00,0x4d,0x25
	.byte 0x1b,0x01,0x00,0x00,0x02,0x18,0x01,0x00
	.byte 0x00,0x4d,0x52,0x1a,0x00,0x00,0x43,0x17
	.byte 0x00,0x0a,0x00,0x00,0x4d,0x41,0x19,0x01
	.byte 0x01,0x00,0x00,0x4d,0x6e,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x4b,0xa9,0x00,0x0a,0x00,0x00
	.byte 0x4d,0x57,0x19,0x01,0x01,0x00,0x00,0x4d
	.byte 0x8a,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x4c,0xff
	.byte 0x00,0x0a,0x00,0x00,0x4d,0x73,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x4d,0x8f
	.byte 0x1b,0x01,0x00,0x00,0x4d,0x94,0x01,0x00
	.byte 0x00,0x4d,0xaf,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x00,0x0a,0x00
	.byte 0x00,0x4d,0x99,0x19,0x01,0x01,0x00,0x00
	.byte 0x4d,0xd0,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x4b,0xa9,0x00,0x0a
	.byte 0x00,0x00,0x4d,0xb4,0x19,0x01,0x01,0x00
	.byte 0x00,0x4d,0xf1,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x4c,0xff,0x00
	.byte 0x0a,0x00,0x00,0x4d,0xd5,0x19,0x01,0x01
	.byte 0x00,0x00,0x4e,0x12,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x4c,0xb8
	.byte 0x00,0x0a,0x00,0x00,0x4d,0xf6,0x19,0x01
	.byte 0x01,0x00,0x00,0x4e,0x33,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x4b
	.byte 0xa9,0x00,0x0a,0x00,0x00,0x4e,0x17,0x19
	.byte 0x01,0x01,0x00,0x00,0x4e,0x54,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4c,0xff,0x00,0x0a,0x00,0x00,0x4e,0x38
	.byte 0x19,0x01,0x01,0x00,0x00,0x4e,0x75,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x4b,0xa9,0x00,0x0a,0x00,0x00,0x4e
	.byte 0x59,0x19,0x01,0x01,0x00,0x00,0x4e,0x96
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x4c,0xff,0x00,0x0a,0x00,0x00
	.byte 0x4e,0x7a,0x19,0x01,0x01,0x00,0x00,0x4e
	.byte 0xb2,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x4b,0xa9
	.byte 0x00,0x0a,0x00,0x00,0x4e,0x9b,0x19,0x01
	.byte 0x01,0x00,0x00,0x4e,0xce,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x4c,0x7b,0x00,0x0a,0x00,0x00
	.byte 0x4e,0xb7,0x05
	.ascii "unsigned short\0"
	.byte 0x07,0x02,0x0a,0x00,0x00,0x4e,0xd3,0x19
	.byte 0x01,0x01,0x00,0x00,0x4f,0x01,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x4e,0xe5,0x00,0x0a,0x00
	.byte 0x00,0x4e,0xea,0x0a,0x00,0x00,0x32,0x06
	.byte 0x19,0x01,0x01,0x00,0x00,0x4f,0x22,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x4f,0x06,0x00,0x0a
	.byte 0x00,0x00,0x4f,0x0b,0x19,0x01,0x01,0x00
	.byte 0x00,0x4f,0x39,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x3b,0x48,0x00,0x0a,0x00
	.byte 0x00,0x4f,0x27,0x18,0x00,0x00,0x31,0xc1
	.byte 0x0a,0x00,0x00,0x4f,0x3e,0x18,0x00,0x00
	.byte 0x39,0x23,0x0a,0x00,0x00,0x4f,0x48,0x19
	.byte 0x01,0x01,0x00,0x00,0x4f,0x6e,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x4f,0x43,0x1a,0x00,0x00
	.byte 0x4f,0x4d,0x00,0x0a,0x00,0x00,0x4f,0x52
	.byte 0x19,0x01,0x01,0x00,0x00,0x4f,0x8f,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x4b,0xa9,0x00,0x0a
	.byte 0x00,0x00,0x4f,0x73,0x19,0x01,0x01,0x00
	.byte 0x00,0x4f,0xb0,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x4c,0xff,0x00
	.byte 0x0a,0x00,0x00,0x4f,0x94,0x19,0x01,0x01
	.byte 0x00,0x00,0x4f,0xd1,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x4c,0xb8
	.byte 0x00,0x0a,0x00,0x00,0x4f,0xb5,0x19,0x01
	.byte 0x01,0x00,0x00,0x4f,0xf2,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x4b
	.byte 0xa9,0x00,0x0a,0x00,0x00,0x4f,0xd6,0x19
	.byte 0x01,0x01,0x00,0x00,0x50,0x13,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4c,0xff,0x00,0x0a,0x00,0x00,0x4f,0xf7
	.byte 0x19,0x01,0x01,0x00,0x00,0x50,0x3e,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x32,0x06,0x00,0x0a,0x00
	.byte 0x00,0x50,0x18,0x19,0x01,0x01,0x00,0x00
	.byte 0x50,0x64,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x4b,0xa9,0x00,0x0a,0x00,0x00,0x50
	.byte 0x43,0x19,0x01,0x01,0x00,0x00,0x50,0x8a
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x4c
	.byte 0xff,0x00,0x0a,0x00,0x00,0x50,0x69,0x19
	.byte 0x01,0x01,0x00,0x00,0x50,0xab,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x4b,0xa9,0x00,0x0a,0x00,0x00,0x50,0x8f
	.byte 0x19,0x01,0x01,0x00,0x00,0x50,0xcc,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x4c,0xff,0x00,0x0a,0x00,0x00,0x50
	.byte 0xb0,0x19,0x01,0x01,0x00,0x00,0x50,0xe8
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x02,0x18,0x00
	.byte 0x0a,0x00,0x00,0x50,0xd1,0x19,0x01,0x01
	.byte 0x00,0x00,0x50,0xff,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a
	.byte 0x00,0x00,0x50,0xed,0x19,0x01,0x01,0x00
	.byte 0x00,0x51,0x16,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x39,0x23,0x00,0x0a,0x00
	.byte 0x00,0x51,0x04,0x19,0x01,0x01,0x00,0x00
	.byte 0x51,0x2d,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x51,0x1b,0x18,0x00,0x00,0x31,0xfe,0x0a
	.byte 0x00,0x00,0x51,0x32,0x19,0x01,0x01,0x00
	.byte 0x00,0x51,0x58,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x51,0x37,0x00
	.byte 0x0a,0x00,0x00,0x51,0x3c,0x19,0x01,0x01
	.byte 0x00,0x00,0x51,0x6a,0x1a,0x00,0x00,0x43
	.byte 0x17,0x00,0x0a,0x00,0x00,0x51,0x5d,0x18
	.byte 0x00,0x00,0x31,0xfe,0x0a,0x00,0x00,0x51
	.byte 0x6f,0x19,0x01,0x01,0x00,0x00,0x51,0x95
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x51,0x74,0x00,0x0a,0x00,0x00
	.byte 0x51,0x79,0x1b,0x01,0x00,0x00,0x31,0xda
	.byte 0x01,0x00,0x00,0x51,0xb0,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x00
	.byte 0x0a,0x00,0x00,0x51,0x9a,0x1b,0x01,0x00
	.byte 0x00,0x31,0xda,0x01,0x00,0x00,0x51,0xcb
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x00,0x0a,0x00,0x00,0x51,0xb5
	.byte 0x1b,0x01,0x00,0x00,0x31,0xda,0x01,0x00
	.byte 0x00,0x51,0xe6,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a,0x00
	.byte 0x00,0x51,0xd0,0x18,0x00,0x00,0x39,0x23
	.byte 0x0a,0x00,0x00,0x51,0xeb,0x19,0x01,0x01
	.byte 0x00,0x00,0x52,0x0c,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x51,0xf0,0x00,0x0a,0x00,0x00,0x51
	.byte 0xf5,0x18,0x00,0x00,0x39,0x23,0x0a,0x00
	.byte 0x00,0x52,0x11,0x19,0x01,0x01,0x00,0x00
	.byte 0x52,0x3c,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x52,0x16,0x1a,0x00
	.byte 0x00,0x01,0x53,0x00,0x0a,0x00,0x00,0x52
	.byte 0x1b,0x19,0x01,0x01,0x00,0x00,0x52,0x58
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x4e,0xd3,0x00
	.byte 0x0a,0x00,0x00,0x52,0x41,0x19,0x01,0x01
	.byte 0x00,0x00,0x52,0x6f,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x39,0x23,0x00,0x0a
	.byte 0x00,0x00,0x52,0x5d,0x19,0x01,0x01,0x00
	.byte 0x00,0x52,0x86,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a,0x00
	.byte 0x00,0x52,0x74,0x19,0x01,0x01,0x00,0x00
	.byte 0x52,0x98,0x1a,0x00,0x00,0x43,0x17,0x00
	.byte 0x0a,0x00,0x00,0x52,0x8b,0x18,0x00,0x00
	.byte 0x39,0x23,0x0a,0x00,0x00,0x52,0x9d,0x19
	.byte 0x01,0x01,0x00,0x00,0x52,0xb9,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x52,0xa2
	.byte 0x00,0x0a,0x00,0x00,0x52,0xa7,0x19,0x01
	.byte 0x01,0x00,0x00,0x52,0xd0,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x31,0xc1,0x00
	.byte 0x0a,0x00,0x00,0x52,0xbe,0x19,0x01,0x01
	.byte 0x00,0x00,0x52,0xe7,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x00,0x0a
	.byte 0x00,0x00,0x52,0xd5,0x18,0x00,0x00,0x39
	.byte 0x23,0x0a,0x00,0x00,0x52,0xec,0x19,0x01
	.byte 0x01,0x00,0x00,0x53,0x26,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x52,0xf1
	.byte 0x1a,0x00,0x00,0x31,0xda,0x00,0x0a,0x00
	.byte 0x00,0x52,0xf6,0x18,0x00,0x00,0x39,0x23
	.byte 0x0a,0x00,0x00,0x53,0x2b,0x19,0x01,0x01
	.byte 0x00,0x00,0x53,0x79,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x53,0x30,0x1a,0x00,0x00,0x31,0xda
	.byte 0x00,0x0a,0x00,0x00,0x53,0x35,0x19,0x01
	.byte 0x01,0x00,0x00,0x53,0x9a,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x53,0x7e,0x19
	.byte 0x01,0x01,0x00,0x00,0x53,0xca,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x53,0x9f,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x53
	.byte 0xcf,0x19,0x01,0x01,0x00,0x00,0x53,0xf5
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x53,0xd4,0x00,0x0a,0x00,0x00
	.byte 0x53,0xd9,0x19,0x01,0x01,0x00,0x00,0x54
	.byte 0x0c,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x53
	.byte 0xfa,0x18,0x00,0x00,0x39,0x23,0x0a,0x00
	.byte 0x00,0x54,0x11,0x19,0x01,0x01,0x00,0x00
	.byte 0x54,0x2d,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x54,0x16,0x00,0x0a,0x00,0x00
	.byte 0x54,0x1b,0x19,0x01,0x01,0x00,0x00,0x54
	.byte 0x49,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x1a,0x00,0x00,0x02,0x18
	.byte 0x00,0x0a,0x00,0x00,0x54,0x32,0x19,0x01
	.byte 0x01,0x00,0x00,0x54,0x6a,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x54,0x4e,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x54
	.byte 0x6f,0x19,0x01,0x01,0x00,0x00,0x54,0x8b
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x54,0x74,0x00,0x0a,0x00,0x00,0x54,0x79
	.byte 0x18,0x00,0x00,0x31,0xfe,0x0a,0x00,0x00
	.byte 0x54,0x90,0x19,0x01,0x01,0x00,0x00,0x54
	.byte 0xb6,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x54,0x95,0x00,0x0a,0x00
	.byte 0x00,0x54,0x9a,0x19,0x01,0x01,0x00,0x00
	.byte 0x54,0xe6,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x45,0xb9,0x1a,0x00,0x00,0x45
	.byte 0xb9,0x1a,0x00,0x00,0x45,0xb9,0x1a,0x00
	.byte 0x00,0x45,0xb9,0x1a,0x00,0x00,0x45,0xb9
	.byte 0x1a,0x00,0x00,0x45,0xb9,0x00,0x0a,0x00
	.byte 0x00,0x54,0xbb,0x19,0x01,0x01,0x00,0x00
	.byte 0x54,0xfd,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x39,0x23,0x00,0x0a,0x00,0x00
	.byte 0x54,0xeb,0x18,0x00,0x00,0x39,0x23,0x0a
	.byte 0x00,0x00,0x55,0x02,0x19,0x01,0x01,0x00
	.byte 0x00,0x55,0x28,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x55,0x07,0x00
	.byte 0x0a,0x00,0x00,0x55,0x0c,0x19,0x01,0x01
	.byte 0x00,0x00,0x55,0x44,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x02,0x18,0x1a,0x00
	.byte 0x00,0x01,0x53,0x00,0x0a,0x00,0x00,0x55
	.byte 0x2d,0x19,0x01,0x01,0x00,0x00,0x55,0x60
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x55,0x49,0x19,0x01,0x01
	.byte 0x00,0x00,0x55,0x7c,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x39,0x23,0x1a,0x00
	.byte 0x00,0x39,0x23,0x00,0x0a,0x00,0x00,0x55
	.byte 0x65,0x18,0x00,0x00,0x39,0x23,0x0a,0x00
	.byte 0x00,0x55,0x81,0x19,0x01,0x01,0x00,0x00
	.byte 0x55,0xa2,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x55
	.byte 0x86,0x00,0x0a,0x00,0x00,0x55,0x8b,0x19
	.byte 0x01,0x01,0x00,0x00,0x55,0xb9,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x55,0xa7,0x19,0x01
	.byte 0x01,0x00,0x00,0x55,0xd5,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x55,0xbe,0x19,0x01,0x01,0x00,0x00,0x55
	.byte 0xf1,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x55,0xda,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x55,0xf6
	.byte 0x19,0x01,0x01,0x00,0x00,0x56,0x12,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x55
	.byte 0xfb,0x00,0x0a,0x00,0x00,0x56,0x00,0x19
	.byte 0x01,0x01,0x00,0x00,0x56,0x24,0x1a,0x00
	.byte 0x00,0x43,0x17,0x00,0x0a,0x00,0x00,0x56
	.byte 0x17,0x19,0x01,0x01,0x00,0x00,0x56,0x36
	.byte 0x1a,0x00,0x00,0x43,0x17,0x00,0x0a,0x00
	.byte 0x00,0x56,0x29,0x19,0x01,0x01,0x00,0x00
	.byte 0x56,0x48,0x1a,0x00,0x00,0x43,0x17,0x00
	.byte 0x0a,0x00,0x00,0x56,0x3b,0x19,0x01,0x01
	.byte 0x00,0x00,0x56,0x5a,0x1a,0x00,0x00,0x43
	.byte 0x17,0x00,0x0a,0x00,0x00,0x56,0x4d,0x19
	.byte 0x01,0x01,0x00,0x00,0x56,0x71,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xc1
	.byte 0x00,0x0a,0x00,0x00,0x56,0x5f,0x19,0x01
	.byte 0x01,0x00,0x00,0x56,0x88,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x31,0xc1,0x00
	.byte 0x0a,0x00,0x00,0x56,0x76,0x19,0x01,0x01
	.byte 0x00,0x00,0x56,0x9a,0x1a,0x00,0x00,0x43
	.byte 0x17,0x00,0x0a,0x00,0x00,0x56,0x8d,0x19
	.byte 0x01,0x01,0x00,0x00,0x56,0xb1,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xc1
	.byte 0x00,0x0a,0x00,0x00,0x56,0x9f,0x19,0x01
	.byte 0x01,0x00,0x00,0x56,0xd7,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x39,0x23,0x00,0x0a
	.byte 0x00,0x00,0x56,0xb6,0x19,0x01,0x01,0x00
	.byte 0x00,0x56,0xee,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x00,0x0a,0x00
	.byte 0x00,0x56,0xdc,0x19,0x01,0x01,0x00,0x00
	.byte 0x57,0x23,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x32,0x06,0x00,0x0a,0x00,0x00,0x56,0xf3
	.byte 0x19,0x01,0x01,0x00,0x00,0x57,0x49,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x39,0x23,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x57,0x28,0x1b,0x01
	.byte 0x00,0x00,0x01,0x53,0x01,0x00,0x00,0x57
	.byte 0x64,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x57
	.byte 0x4e,0x19,0x01,0x01,0x00,0x00,0x57,0x8a
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x00,0x0a,0x00,0x00,0x57,0x69,0x19
	.byte 0x01,0x01,0x00,0x00,0x57,0xab,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x00,0x0a,0x00,0x00,0x57,0x8f
	.byte 0x19,0x01,0x01,0x00,0x00,0x57,0xd1,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x00,0x0a,0x00,0x00,0x57,0xb0,0x19,0x01
	.byte 0x01,0x00,0x00,0x57,0xed,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x4c,0x7b,0x00,0x0a,0x00,0x00
	.byte 0x57,0xd6,0x19,0x01,0x01,0x00,0x00,0x58
	.byte 0x04,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x57
	.byte 0xf2,0x19,0x01,0x01,0x00,0x00,0x58,0x25
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x00,0x0a,0x00,0x00
	.byte 0x58,0x09,0x19,0x01,0x01,0x00,0x00,0x58
	.byte 0x3c,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x0a,0x00,0x00,0x58
	.byte 0x2a,0x19,0x01,0x01,0x00,0x00,0x58,0x5d
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x58,0x41,0x19,0x01,0x01,0x00,0x00,0x58
	.byte 0x79,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x58,0x62,0x19,0x01
	.byte 0x01,0x00,0x00,0x58,0x9f,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x39,0x23,0x00,0x0a
	.byte 0x00,0x00,0x58,0x7e,0x18,0x00,0x00,0x31
	.byte 0xfe,0x0a,0x00,0x00,0x58,0xa4,0x19,0x01
	.byte 0x01,0x00,0x00,0x58,0xcf,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x58,0xa9,0x00,0x0a
	.byte 0x00,0x00,0x58,0xae,0x18,0x00,0x00,0x39
	.byte 0x23,0x0a,0x00,0x00,0x58,0xd4,0x19,0x01
	.byte 0x01,0x00,0x00,0x58,0xfa,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x58
	.byte 0xd9,0x00,0x0a,0x00,0x00,0x58,0xde,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x58
	.byte 0xff,0x19,0x01,0x01,0x00,0x00,0x59,0x25
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x59,0x04,0x00,0x0a,0x00,0x00
	.byte 0x59,0x09,0x19,0x01,0x01,0x00,0x00,0x59
	.byte 0x5f,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x47,0x70,0x00,0x0a
	.byte 0x00,0x00,0x59,0x2a,0x19,0x01,0x01,0x00
	.byte 0x00,0x59,0x9e,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x47,0x70,0x00,0x0a,0x00
	.byte 0x00,0x59,0x64,0x19,0x01,0x01,0x00,0x00
	.byte 0x59,0xd3,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x47,0x70,0x00,0x0a,0x00,0x00,0x59,0xa3
	.byte 0x19,0x01,0x01,0x00,0x00,0x5a,0x12,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x47
	.byte 0x70,0x00,0x0a,0x00,0x00,0x59,0xd8,0x19
	.byte 0x01,0x01,0x00,0x00,0x5a,0x56,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x02,0x18,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x47,0x70,0x00,0x0a,0x00
	.byte 0x00,0x5a,0x17,0x19,0x01,0x01,0x00,0x00
	.byte 0x5a,0x9f,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x47,0x70,0x00,0x0a
	.byte 0x00,0x00,0x5a,0x5b,0x18,0x00,0x00,0x39
	.byte 0x23,0x0a,0x00,0x00,0x5a,0xa4,0x19,0x01
	.byte 0x01,0x00,0x00,0x5a,0xca,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x5a
	.byte 0xa9,0x00,0x0a,0x00,0x00,0x5a,0xae,0x19
	.byte 0x01,0x01,0x00,0x00,0x5a,0xeb,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x00,0x0a,0x00,0x00,0x5a,0xcf
	.byte 0x19,0x01,0x01,0x00,0x00,0x5b,0x07,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x39,0x23,0x00,0x0a
	.byte 0x00,0x00,0x5a,0xf0,0x19,0x01,0x01,0x00
	.byte 0x00,0x5b,0x28,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x00
	.byte 0x0a,0x00,0x00,0x5b,0x0c,0x19,0x01,0x01
	.byte 0x00,0x00,0x5b,0x4e,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x39,0x23,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x00,0x0a,0x00
	.byte 0x00,0x5b,0x2d,0x18,0x00,0x00,0x39,0x23
	.byte 0x0a,0x00,0x00,0x5b,0x53,0x19,0x01,0x01
	.byte 0x00,0x00,0x5b,0x6f,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x5b,0x58,0x00,0x0a
	.byte 0x00,0x00,0x5b,0x5d,0x18,0x00,0x00,0x31
	.byte 0xfe,0x0a,0x00,0x00,0x5b,0x74,0x19,0x01
	.byte 0x01,0x00,0x00,0x5b,0x9f,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x01
	.byte 0x53,0x1a,0x00,0x00,0x5b,0x79,0x00,0x0a
	.byte 0x00,0x00,0x5b,0x7e,0x19,0x01,0x01,0x00
	.byte 0x00,0x5b,0xc5,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x5b,0xa4,0x19,0x01,0x01,0x00,0x00,0x5b
	.byte 0xeb,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x1a,0x00,0x00,0x39,0x23,0x1a,0x00,0x00
	.byte 0x39,0x23,0x00,0x0a,0x00,0x00,0x5b,0xca
	.byte 0x19,0x01,0x01,0x00,0x00,0x5b,0xfd,0x1a
	.byte 0x00,0x00,0x43,0x17,0x00,0x0a,0x00,0x00
	.byte 0x5b,0xf0,0x17
	.ascii "gl_api_table\0"
	.byte 0x02,0xdc,0x03,0x00,0x00,0x6a,0xa6,0x0c
	.ascii "Accum\0"
	.byte 0x00,0x00,0x43,0x33,0x02,0x23,0x00,0x0c
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x43,0x4f,0x02,0x23,0x04,0x0c
	.ascii "AreTexturesResident\0"
	.byte 0x00,0x00,0x43,0x7e,0x02,0x23,0x08,0x0c
	.ascii "ArrayElement\0"
	.byte 0x00,0x00,0x43,0x95,0x02,0x23,0x0c,0x0c
	.ascii "Begin\0"
	.byte 0x00,0x00,0x43,0xac,0x02,0x23,0x10,0x0c
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x43,0xc8,0x02,0x23,0x14,0x0c
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x44,0xb6,0x02,0x23,0x18,0x0c
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x44,0xdc,0x02,0x23,0x1c,0x0c
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x44,0xf3,0x02,0x23,0x20,0x0c
	.ascii "BlendFunc\0"
	.byte 0x00,0x00,0x45,0x0f,0x02,0x23,0x24,0x0c
	.ascii "CallList\0"
	.byte 0x00,0x00,0x45,0x26,0x02,0x23,0x28,0x0c
	.ascii "CallLists\0"
	.byte 0x00,0x00,0x45,0x51,0x02,0x23,0x2c,0x0c
	.ascii "Clear\0"
	.byte 0x00,0x00,0x45,0x68,0x02,0x23,0x30,0x0c
	.ascii "ClearAccum\0"
	.byte 0x00,0x00,0x45,0x8e,0x02,0x23,0x34,0x0c
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x45,0xb4,0x02,0x23,0x38,0x0c
	.ascii "ClearDepth\0"
	.byte 0x00,0x00,0x45,0xd5,0x02,0x23,0x3c,0x0c
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x45,0xec,0x02,0x23,0x40,0x0c
	.ascii "ClearStencil\0"
	.byte 0x00,0x00,0x46,0x03,0x02,0x23,0x44,0x0c
	.ascii "ClipPlane\0"
	.byte 0x00,0x00,0x46,0x29,0x02,0x23,0x48,0x0c
	.ascii "Color3f\0"
	.byte 0x00,0x00,0x46,0x4a,0x02,0x23,0x4c,0x0c
	.ascii "Color3fv\0"
	.byte 0x00,0x00,0x46,0x6b,0x02,0x23,0x50,0x0c
	.ascii "Color4f\0"
	.byte 0x00,0x00,0x46,0x91,0x02,0x23,0x54,0x0c
	.ascii "Color4fv\0"
	.byte 0x00,0x00,0x46,0xb2,0x02,0x23,0x58,0x0c
	.ascii "Color4ub\0"
	.byte 0x00,0x00,0x46,0xd8,0x02,0x23,0x5c,0x0c
	.ascii "Color4ubv\0"
	.byte 0x00,0x00,0x46,0xf9,0x02,0x23,0x60,0x0c
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x47,0x1f,0x02,0x23,0x64,0x0c
	.ascii "ColorMaterial\0"
	.byte 0x00,0x00,0x47,0x3b,0x02,0x23,0x68,0x0c
	.ascii "ColorPointer\0"
	.byte 0x00,0x00,0x47,0x6b,0x02,0x23,0x6c,0x0c
	.ascii "ColorTable\0"
	.byte 0x00,0x00,0x47,0x91,0x02,0x23,0x70,0x0c
	.ascii "ColorSubTable\0"
	.byte 0x00,0x00,0x47,0xb2,0x02,0x23,0x74,0x0c
	.ascii "CopyPixels\0"
	.byte 0x00,0x00,0x47,0xdd,0x02,0x23,0x78,0x0c
	.ascii "CopyTexImage1D\0"
	.byte 0x00,0x00,0x48,0x12,0x02,0x23,0x7c,0x0c
	.ascii "CopyTexImage2D\0"
	.byte 0x00,0x00,0x48,0x4c,0x03,0x23,0x80,0x01
	.byte 0x0c
	.ascii "CopyTexSubImage1D\0"
	.byte 0x00,0x00,0x48,0x7c,0x03,0x23,0x84,0x01
	.byte 0x0c
	.ascii "CopyTexSubImage2D\0"
	.byte 0x00,0x00,0x48,0xb6,0x03,0x23,0x88,0x01
	.byte 0x0c
	.ascii "CopyTexSubImage3DEXT\0"
	.byte 0x00,0x00,0x48,0xf5,0x03,0x23,0x8c,0x01
	.byte 0x0c
	.ascii "CullFace\0"
	.byte 0x00,0x00,0x49,0x0c,0x03,0x23,0x90,0x01
	.byte 0x0c
	.ascii "DeleteLists\0"
	.byte 0x00,0x00,0x49,0x28,0x03,0x23,0x94,0x01
	.byte 0x0c
	.ascii "DeleteTextures\0"
	.byte 0x00,0x00,0x49,0x4e,0x03,0x23,0x98,0x01
	.byte 0x0c
	.ascii "DepthFunc\0"
	.byte 0x00,0x00,0x49,0x65,0x03,0x23,0x9c,0x01
	.byte 0x0c
	.ascii "DepthMask\0"
	.byte 0x00,0x00,0x49,0x7c,0x03,0x23,0xa0,0x01
	.byte 0x0c
	.ascii "DepthRange\0"
	.byte 0x00,0x00,0x49,0x98,0x03,0x23,0xa4,0x01
	.byte 0x0c
	.ascii "Disable\0"
	.byte 0x00,0x00,0x49,0xaf,0x03,0x23,0xa8,0x01
	.byte 0x0c
	.ascii "DisableClientState\0"
	.byte 0x00,0x00,0x49,0xc6
	.byte 0x03,0x23,0xac,0x01,0x0c
	.ascii "DrawArrays\0"
	.byte 0x00,0x00,0x49,0xe7,0x03,0x23,0xb0,0x01
	.byte 0x0c
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x49,0xfe,0x03,0x23,0xb4,0x01
	.byte 0x0c
	.ascii "DrawElements\0"
	.byte 0x00,0x00,0x4a,0x2e,0x03,0x23,0xb8,0x01
	.byte 0x0c
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x4a,0x63,0x03,0x23,0xbc,0x01
	.byte 0x0c
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x4a,0x7a,0x03,0x23,0xc0,0x01
	.byte 0x0c
	.ascii "EdgeFlagPointer\0"
	.byte 0x00,0x00,0x4a,0xa0,0x03,0x23,0xc4,0x01
	.byte 0x0c
	.ascii "Enable\0"
	.byte 0x00,0x00,0x4a,0xb7,0x03,0x23,0xc8,0x01
	.byte 0x0c
	.ascii "EnableClientState\0"
	.byte 0x00,0x00,0x4a,0xce,0x03,0x23,0xcc,0x01
	.byte 0x0c
	.ascii "End\0"
	.byte 0x00,0x00,0x4a,0xe0,0x03,0x23,0xd0,0x01
	.byte 0x0c
	.ascii "EndList\0"
	.byte 0x00,0x00,0x4a,0xf2,0x03,0x23,0xd4,0x01
	.byte 0x0c
	.ascii "EvalCoord1f\0"
	.byte 0x00,0x00,0x4b,0x09,0x03,0x23,0xd8,0x01
	.byte 0x0c
	.ascii "EvalCoord2f\0"
	.byte 0x00,0x00,0x4b,0x25,0x03,0x23,0xdc,0x01
	.byte 0x0c
	.ascii "EvalMesh1\0"
	.byte 0x00,0x00,0x4b,0x46,0x03,0x23,0xe0,0x01
	.byte 0x0c
	.ascii "EvalMesh2\0"
	.byte 0x00,0x00,0x4b,0x71,0x03,0x23,0xe4,0x01
	.byte 0x0c
	.ascii "EvalPoint1\0"
	.byte 0x00,0x00,0x4b,0x88,0x03,0x23,0xe8,0x01
	.byte 0x0c
	.ascii "EvalPoint2\0"
	.byte 0x00,0x00,0x4b,0xa4,0x03,0x23,0xec,0x01
	.byte 0x0c
	.ascii "FeedbackBuffer\0"
	.byte 0x00,0x00,0x4b,0xca,0x03,0x23,0xf0,0x01
	.byte 0x0c
	.ascii "Finish\0"
	.byte 0x00,0x00,0x4b,0xdc,0x03,0x23,0xf4,0x01
	.byte 0x0c
	.ascii "Flush\0"
	.byte 0x00,0x00,0x4b,0xee,0x03,0x23,0xf8,0x01
	.byte 0x0c
	.ascii "Fogfv\0"
	.byte 0x00,0x00,0x4c,0x14,0x03,0x23,0xfc,0x01
	.byte 0x0c
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x4c,0x2b,0x03,0x23,0x80,0x02
	.byte 0x0c
	.ascii "Frustum\0"
	.byte 0x00,0x00,0x4c,0x5b,0x03,0x23,0x84,0x02
	.byte 0x0c
	.ascii "GenLists\0"
	.byte 0x00,0x00,0x4c,0x76,0x03,0x23,0x88,0x02
	.byte 0x0c
	.ascii "GenTextures\0"
	.byte 0x00,0x00,0x4c,0x97,0x03,0x23,0x8c,0x02
	.byte 0x0c
	.ascii "GetBooleanv\0"
	.byte 0x00,0x00,0x4c,0xb3,0x03,0x23,0x90,0x02
	.byte 0x0c
	.ascii "GetClipPlane\0"
	.byte 0x00,0x00,0x4c,0xd4,0x03,0x23,0x94,0x02
	.byte 0x0c
	.ascii "GetColorTable\0"
	.byte 0x00,0x00,0x4c,0xfa,0x03,0x23,0x98,0x02
	.byte 0x0c
	.ascii "GetColorTableParameteriv\0"
	.byte 0x00,0x00,0x4d,0x20,0x03,0x23,0x9c,0x02
	.byte 0x0c
	.ascii "GetDoublev\0"
	.byte 0x00,0x00,0x4d,0x3c,0x03,0x23,0xa0,0x02
	.byte 0x0c
	.ascii "GetError\0"
	.byte 0x00,0x00,0x4d,0x52,0x03,0x23,0xa4,0x02
	.byte 0x0c
	.ascii "GetFloatv\0"
	.byte 0x00,0x00,0x4d,0x6e,0x03,0x23,0xa8,0x02
	.byte 0x0c
	.ascii "GetIntegerv\0"
	.byte 0x00,0x00,0x4d,0x8a,0x03,0x23,0xac,0x02
	.byte 0x0c
	.ascii "GetString\0"
	.byte 0x00,0x00,0x4d,0xaf,0x03,0x23,0xb0,0x02
	.byte 0x0c
	.ascii "GetLightfv\0"
	.byte 0x00,0x00,0x4d,0xd0,0x03,0x23,0xb4,0x02
	.byte 0x0c
	.ascii "GetLightiv\0"
	.byte 0x00,0x00,0x4d,0xf1,0x03,0x23,0xb8,0x02
	.byte 0x0c
	.ascii "GetMapdv\0"
	.byte 0x00,0x00,0x4e,0x12,0x03,0x23,0xbc,0x02
	.byte 0x0c
	.ascii "GetMapfv\0"
	.byte 0x00,0x00,0x4e,0x33,0x03,0x23,0xc0,0x02
	.byte 0x0c
	.ascii "GetMapiv\0"
	.byte 0x00,0x00,0x4e,0x54,0x03,0x23,0xc4,0x02
	.byte 0x0c
	.ascii "GetMaterialfv\0"
	.byte 0x00,0x00,0x4e,0x75,0x03,0x23,0xc8,0x02
	.byte 0x0c
	.ascii "GetMaterialiv\0"
	.byte 0x00,0x00,0x4e,0x96,0x03,0x23,0xcc,0x02
	.byte 0x0c
	.ascii "GetPixelMapfv\0"
	.byte 0x00,0x00,0x4e,0xb2,0x03,0x23,0xd0,0x02
	.byte 0x0c
	.ascii "GetPixelMapuiv\0"
	.byte 0x00,0x00,0x4e,0xce,0x03,0x23,0xd4,0x02
	.byte 0x0c
	.ascii "GetPixelMapusv\0"
	.byte 0x00,0x00,0x4f,0x01,0x03,0x23,0xd8,0x02
	.byte 0x0c
	.ascii "GetPointerv\0"
	.byte 0x00,0x00,0x4f,0x22,0x03,0x23,0xdc,0x02
	.byte 0x0c
	.ascii "GetPolygonStipple\0"
	.byte 0x00,0x00,0x4f,0x39,0x03,0x23,0xe0,0x02
	.byte 0x0c
	.ascii "PrioritizeTextures\0"
	.byte 0x00,0x00,0x4f,0x6e,0x03,0x23,0xe4,0x02
	.byte 0x0c
	.ascii "GetTexEnvfv\0"
	.byte 0x00,0x00,0x4f,0x8f,0x03,0x23,0xe8,0x02
	.byte 0x0c
	.ascii "GetTexEnviv\0"
	.byte 0x00,0x00,0x4f,0xb0,0x03,0x23,0xec,0x02
	.byte 0x0c
	.ascii "GetTexGendv\0"
	.byte 0x00,0x00,0x4f,0xd1,0x03,0x23,0xf0,0x02
	.byte 0x0c
	.ascii "GetTexGenfv\0"
	.byte 0x00,0x00,0x4f,0xf2,0x03,0x23,0xf4,0x02
	.byte 0x0c
	.ascii "GetTexGeniv\0"
	.byte 0x00,0x00,0x50,0x13,0x03,0x23,0xf8,0x02
	.byte 0x0c
	.ascii "GetTexImage\0"
	.byte 0x00,0x00,0x50,0x3e,0x03,0x23,0xfc,0x02
	.byte 0x0c
	.ascii "GetTexLevelParameterfv\0"
	.byte 0x00,0x00,0x50,0x64,0x03,0x23,0x80,0x03
	.byte 0x0c
	.ascii "GetTexLevelParameteriv\0"
	.byte 0x00,0x00,0x50,0x8a,0x03,0x23,0x84,0x03
	.byte 0x0c
	.ascii "GetTexParameterfv\0"
	.byte 0x00,0x00,0x50,0xab,0x03,0x23,0x88,0x03
	.byte 0x0c
	.ascii "GetTexParameteriv\0"
	.byte 0x00,0x00,0x50,0xcc,0x03,0x23,0x8c,0x03
	.byte 0x0c
	.ascii "Hint\0"
	.byte 0x00,0x00,0x50,0xe8,0x03,0x23,0x90,0x03
	.byte 0x0c
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x50,0xff,0x03,0x23,0x94,0x03
	.byte 0x0c
	.ascii "Indexf\0"
	.byte 0x00,0x00,0x51,0x16,0x03,0x23,0x98,0x03
	.byte 0x0c
	.ascii "Indexi\0"
	.byte 0x00,0x00,0x51,0x2d,0x03,0x23,0x9c,0x03
	.byte 0x0c
	.ascii "IndexPointer\0"
	.byte 0x00,0x00,0x51,0x58,0x03,0x23,0xa0,0x03
	.byte 0x0c
	.ascii "InitNames\0"
	.byte 0x00,0x00,0x51,0x6a,0x03,0x23,0xa4,0x03
	.byte 0x0c
	.ascii "InterleavedArrays\0"
	.byte 0x00,0x00,0x51,0x95,0x03,0x23,0xa8,0x03
	.byte 0x0c
	.ascii "IsEnabled\0"
	.byte 0x00,0x00,0x51,0xb0,0x03,0x23,0xac,0x03
	.byte 0x0c
	.ascii "IsList\0"
	.byte 0x00,0x00,0x51,0xcb,0x03,0x23,0xb0,0x03
	.byte 0x0c
	.ascii "IsTexture\0"
	.byte 0x00,0x00,0x51,0xe6,0x03,0x23,0xb4,0x03
	.byte 0x0c
	.ascii "LightModelfv\0"
	.byte 0x00,0x00,0x52,0x0c,0x03,0x23,0xb8,0x03
	.byte 0x0c
	.ascii "Lightfv\0"
	.byte 0x00,0x00,0x52,0x3c,0x03,0x23,0xbc,0x03
	.byte 0x0c
	.ascii "LineStipple\0"
	.byte 0x00,0x00,0x52,0x58,0x03,0x23,0xc0,0x03
	.byte 0x0c
	.ascii "LineWidth\0"
	.byte 0x00,0x00,0x52,0x6f,0x03,0x23,0xc4,0x03
	.byte 0x0c
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x52,0x86,0x03,0x23,0xc8,0x03
	.byte 0x0c
	.ascii "LoadIdentity\0"
	.byte 0x00,0x00,0x52,0x98,0x03,0x23,0xcc,0x03
	.byte 0x0c
	.ascii "LoadMatrixf\0"
	.byte 0x00,0x00,0x52,0xb9,0x03,0x23,0xd0,0x03
	.byte 0x0c
	.ascii "LoadName\0"
	.byte 0x00,0x00,0x52,0xd0,0x03,0x23,0xd4,0x03
	.byte 0x0c
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x52,0xe7,0x03,0x23,0xd8,0x03
	.byte 0x0c
	.ascii "Map1f\0"
	.byte 0x00,0x00,0x53,0x26,0x03,0x23,0xdc,0x03
	.byte 0x0c
	.ascii "Map2f\0"
	.byte 0x00,0x00,0x53,0x79,0x03,0x23,0xe0,0x03
	.byte 0x0c
	.ascii "MapGrid1f\0"
	.byte 0x00,0x00,0x53,0x9a,0x03,0x23,0xe4,0x03
	.byte 0x0c
	.ascii "MapGrid2f\0"
	.byte 0x00,0x00,0x53,0xca,0x03,0x23,0xe8,0x03
	.byte 0x0c
	.ascii "Materialfv\0"
	.byte 0x00,0x00,0x53,0xf5,0x03,0x23,0xec,0x03
	.byte 0x0c
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x54,0x0c,0x03,0x23,0xf0,0x03
	.byte 0x0c
	.ascii "MultMatrixf\0"
	.byte 0x00,0x00,0x54,0x2d,0x03,0x23,0xf4,0x03
	.byte 0x0c
	.ascii "NewList\0"
	.byte 0x00,0x00,0x54,0x49,0x03,0x23,0xf8,0x03
	.byte 0x0c
	.ascii "Normal3f\0"
	.byte 0x00,0x00,0x54,0x6a,0x03,0x23,0xfc,0x03
	.byte 0x0c
	.ascii "Normal3fv\0"
	.byte 0x00,0x00,0x54,0x8b,0x03,0x23,0x80,0x04
	.byte 0x0c
	.ascii "NormalPointer\0"
	.byte 0x00,0x00,0x54,0xb6,0x03,0x23,0x84,0x04
	.byte 0x0c
	.ascii "Ortho\0"
	.byte 0x00,0x00,0x54,0xe6,0x03,0x23,0x88,0x04
	.byte 0x0c
	.ascii "PassThrough\0"
	.byte 0x00,0x00,0x54,0xfd,0x03,0x23,0x8c,0x04
	.byte 0x0c
	.ascii "PixelMapfv\0"
	.byte 0x00,0x00,0x55,0x28,0x03,0x23,0x90,0x04
	.byte 0x0c
	.ascii "PixelStorei\0"
	.byte 0x00,0x00,0x55,0x44,0x03,0x23,0x94,0x04
	.byte 0x0c
	.ascii "PixelTransferf\0"
	.byte 0x00,0x00,0x55,0x60,0x03,0x23,0x98,0x04
	.byte 0x0c
	.ascii "PixelZoom\0"
	.byte 0x00,0x00,0x55,0x7c,0x03,0x23,0x9c,0x04
	.byte 0x0c
	.ascii "PointParameterfvEXT\0"
	.byte 0x00,0x00,0x55,0xa2,0x03,0x23,0xa0,0x04
	.byte 0x0c
	.ascii "PointSize\0"
	.byte 0x00,0x00,0x55,0xb9,0x03,0x23,0xa4,0x04
	.byte 0x0c
	.ascii "PolygonMode\0"
	.byte 0x00,0x00,0x55,0xd5,0x03,0x23,0xa8,0x04
	.byte 0x0c
	.ascii "PolygonOffset\0"
	.byte 0x00,0x00,0x55,0xf1,0x03,0x23,0xac,0x04
	.byte 0x0c
	.ascii "PolygonStipple\0"
	.byte 0x00,0x00,0x56,0x12,0x03,0x23,0xb0,0x04
	.byte 0x0c
	.ascii "PopAttrib\0"
	.byte 0x00,0x00,0x56,0x24,0x03,0x23,0xb4,0x04
	.byte 0x0c
	.ascii "PopClientAttrib\0"
	.byte 0x00,0x00,0x56,0x36,0x03,0x23,0xb8,0x04
	.byte 0x0c
	.ascii "PopMatrix\0"
	.byte 0x00,0x00,0x56,0x48,0x03,0x23,0xbc,0x04
	.byte 0x0c
	.ascii "PopName\0"
	.byte 0x00,0x00,0x56,0x5a,0x03,0x23,0xc0,0x04
	.byte 0x0c
	.ascii "PushAttrib\0"
	.byte 0x00,0x00,0x56,0x71,0x03,0x23,0xc4,0x04
	.byte 0x0c
	.ascii "PushClientAttrib\0"
	.byte 0x00,0x00,0x56,0x88,0x03,0x23,0xc8,0x04
	.byte 0x0c
	.ascii "PushMatrix\0"
	.byte 0x00,0x00,0x56,0x9a,0x03,0x23,0xcc,0x04
	.byte 0x0c
	.ascii "PushName\0"
	.byte 0x00,0x00,0x56,0xb1,0x03,0x23,0xd0,0x04
	.byte 0x0c
	.ascii "RasterPos4f\0"
	.byte 0x00,0x00,0x56,0xd7,0x03,0x23,0xd4,0x04
	.byte 0x0c
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x56,0xee,0x03,0x23,0xd8,0x04
	.byte 0x0c
	.ascii "ReadPixels\0"
	.byte 0x00,0x00,0x57,0x23,0x03,0x23,0xdc,0x04
	.byte 0x0c
	.ascii "Rectf\0"
	.byte 0x00,0x00,0x57,0x49,0x03,0x23,0xe0,0x04
	.byte 0x0c
	.ascii "RenderMode\0"
	.byte 0x00,0x00,0x57,0x64,0x03,0x23,0xe4,0x04
	.byte 0x0c
	.ascii "Rotatef\0"
	.byte 0x00,0x00,0x57,0x8a,0x03,0x23,0xe8,0x04
	.byte 0x0c
	.ascii "Scalef\0"
	.byte 0x00,0x00,0x57,0xab,0x03,0x23,0xec,0x04
	.byte 0x0c
	.ascii "Scissor\0"
	.byte 0x00,0x00,0x57,0xd1,0x03,0x23,0xf0,0x04
	.byte 0x0c
	.ascii "SelectBuffer\0"
	.byte 0x00,0x00,0x57,0xed,0x03,0x23,0xf4,0x04
	.byte 0x0c
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x58,0x04,0x03,0x23,0xf8,0x04
	.byte 0x0c
	.ascii "StencilFunc\0"
	.byte 0x00,0x00,0x58,0x25,0x03,0x23,0xfc,0x04
	.byte 0x0c
	.ascii "StencilMask\0"
	.byte 0x00,0x00,0x58,0x3c,0x03,0x23,0x80,0x05
	.byte 0x0c
	.ascii "StencilOp\0"
	.byte 0x00,0x00,0x58,0x5d,0x03,0x23,0x84,0x05
	.byte 0x0c
	.ascii "TexCoord2f\0"
	.byte 0x00,0x00,0x58,0x79,0x03,0x23,0x88,0x05
	.byte 0x0c
	.ascii "TexCoord4f\0"
	.byte 0x00,0x00,0x58,0x9f,0x03,0x23,0x8c,0x05
	.byte 0x0c
	.ascii "TexCoordPointer\0"
	.byte 0x00,0x00,0x58,0xcf,0x03,0x23,0x90,0x05
	.byte 0x0c
	.ascii "TexEnvfv\0"
	.byte 0x00,0x00,0x58,0xfa,0x03,0x23,0x94,0x05
	.byte 0x0c
	.ascii "TexGenfv\0"
	.byte 0x00,0x00,0x59,0x25,0x03,0x23,0x98,0x05
	.byte 0x0c
	.ascii "TexImage1D\0"
	.byte 0x00,0x00,0x59,0x5f,0x03,0x23,0x9c,0x05
	.byte 0x0c
	.ascii "TexImage2D\0"
	.byte 0x00,0x00,0x59,0x9e,0x03,0x23,0xa0,0x05
	.byte 0x0c
	.ascii "TexSubImage1D\0"
	.byte 0x00,0x00,0x59,0xd3,0x03,0x23,0xa4,0x05
	.byte 0x0c
	.ascii "TexSubImage2D\0"
	.byte 0x00,0x00,0x5a,0x12,0x03,0x23,0xa8,0x05
	.byte 0x0c
	.ascii "TexImage3DEXT\0"
	.byte 0x00,0x00,0x5a,0x56,0x03,0x23,0xac,0x05
	.byte 0x0c
	.ascii "TexSubImage3DEXT\0"
	.byte 0x00,0x00,0x5a,0x9f,0x03,0x23,0xb0,0x05
	.byte 0x0c
	.ascii "TexParameterfv\0"
	.byte 0x00,0x00,0x5a,0xca,0x03,0x23,0xb4,0x05
	.byte 0x0c
	.ascii "Translatef\0"
	.byte 0x00,0x00,0x5a,0xeb,0x03,0x23,0xb8,0x05
	.byte 0x0c
	.ascii "Vertex2f\0"
	.byte 0x00,0x00,0x5b,0x07,0x03,0x23,0xbc,0x05
	.byte 0x0c
	.ascii "Vertex3f\0"
	.byte 0x00,0x00,0x5b,0x28,0x03,0x23,0xc0,0x05
	.byte 0x0c
	.ascii "Vertex4f\0"
	.byte 0x00,0x00,0x5b,0x4e,0x03,0x23,0xc4,0x05
	.byte 0x0c
	.ascii "Vertex3fv\0"
	.byte 0x00,0x00,0x5b,0x6f,0x03,0x23,0xc8,0x05
	.byte 0x0c
	.ascii "VertexPointer\0"
	.byte 0x00,0x00,0x5b,0x9f,0x03,0x23,0xcc,0x05
	.byte 0x0c
	.ascii "Viewport\0"
	.byte 0x00,0x00,0x5b,0xc5,0x03,0x23,0xd0,0x05
	.byte 0x0c
	.ascii "WindowPos4fMESA\0"
	.byte 0x00,0x00,0x5b,0xeb,0x03,0x23,0xd4,0x05
	.byte 0x0c
	.ascii "ResizeBuffersMESA\0"
	.byte 0x00,0x00,0x5b,0xfd,0x03,0x23,0xd8,0x05
	.byte 0x00,0x0b
	.ascii "gl_visual\0"
	.byte 0x4c,0x03,0x00,0x00,0x6c,0x4e,0x0c
	.ascii "RGBAflag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "DBflag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x01,0x0c
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x04,0x0c
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x08,0x0c
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x0c,0x0c
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x10,0x0c
	.ascii "EightBitColor\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x14,0x0c
	.ascii "InvRedScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "InvGreenScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "InvBlueScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x20,0x0c
	.ascii "InvAlphaScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x24,0x0c
	.ascii "RedBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x28,0x0c
	.ascii "GreenBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x2c,0x0c
	.ascii "BlueBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x30,0x0c
	.ascii "AlphaBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x34,0x0c
	.ascii "IndexBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x38,0x0c
	.ascii "AccumBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x3c,0x0c
	.ascii "DepthBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x40,0x0c
	.ascii "StencilBits\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x44,0x0c
	.ascii "FrontAlphaEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x48,0x0c
	.ascii "BackAlphaEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x49,0x00
	.byte 0x06,0x00,0x00,0x6a,0xa6
	.ascii "GLvisual\0"
	.byte 0x03,0x0a,0x00,0x00,0x6c,0x4e,0x06,0x00
	.byte 0x00,0x4e,0xd3
	.ascii "GLdepth\0"
	.byte 0x03,0x0a,0x00,0x00,0x6c,0x62,0x06,0x00
	.byte 0x00,0x31,0xda
	.ascii "GLstencil\0"
	.byte 0x03,0x0a,0x00,0x00,0x6c,0x75,0x05
	.ascii "short\0"
	.byte 0x05,0x02,0x06,0x00,0x00,0x6c,0x8a
	.ascii "GLaccum\0"
	.byte 0x03,0x0a,0x00,0x00,0x6c,0x93,0x0b
	.ascii "gl_frame_buffer\0"
	.byte 0x34,0x03,0x00,0x00,0x6d,0x7d,0x0c
	.ascii "Visual\0"
	.byte 0x00,0x00,0x6c,0x5d,0x02,0x23,0x00,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "Height\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x08,0x0c
	.ascii "Depth\0"
	.byte 0x00,0x00,0x6c,0x70,0x02,0x23,0x0c,0x0c
	.ascii "Stencil\0"
	.byte 0x00,0x00,0x6c,0x85,0x02,0x23,0x10,0x0c
	.ascii "Accum\0"
	.byte 0x00,0x00,0x6c,0xa1,0x02,0x23,0x14,0x0c
	.ascii "FrontAlpha\0"
	.byte 0x00,0x00,0x31,0xf9,0x02,0x23,0x18,0x0c
	.ascii "BackAlpha\0"
	.byte 0x00,0x00,0x31,0xf9,0x02,0x23,0x1c,0x0c
	.ascii "Alpha\0"
	.byte 0x00,0x00,0x31,0xf9,0x02,0x23,0x20,0x0c
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x24,0x0c
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x28,0x0c
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x2c,0x0c
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x30,0x00
	.byte 0x06,0x00,0x00,0x6c,0xa6
	.ascii "GLframebuffer\0"
	.byte 0x03,0x0a,0x00,0x00,0x6d,0x7d,0x05
	.ascii "char\0"
	.byte 0x06,0x01,0x18,0x00,0x00,0x6d,0x96,0x0a
	.byte 0x00,0x00,0x6d,0x9e,0x1c,0x01,0x00,0x00
	.byte 0x6d,0xa3,0x01,0x0a,0x00,0x00,0x6d,0xa8
	.byte 0x19,0x01,0x01,0x00,0x00,0x6d,0xc1,0x1a
	.byte 0x00,0x00,0x43,0x17,0x00,0x0a,0x00,0x00
	.byte 0x6d,0xb4,0x19,0x01,0x01,0x00,0x00,0x6d
	.byte 0xd8,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x0a,0x00,0x00,0x6d
	.byte 0xc6,0x19,0x01,0x01,0x00,0x00,0x6d,0xfe
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xda,0x1a,0x00,0x00,0x31,0xda,0x1a
	.byte 0x00,0x00,0x31,0xda,0x1a,0x00,0x00,0x31
	.byte 0xda,0x00,0x0a,0x00,0x00,0x6d,0xdd,0x19
	.byte 0x01,0x01,0x00,0x00,0x6e,0x29,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xda
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x00,0x0a,0x00,0x00
	.byte 0x6e,0x03,0x19,0x01,0x01,0x00,0x00,0x6e
	.byte 0x40,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x0a,0x00,0x00,0x6e
	.byte 0x2e,0x19,0x01,0x01,0x00,0x00,0x6e,0x66
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xda,0x1a,0x00,0x00,0x31,0xda,0x1a
	.byte 0x00,0x00,0x31,0xda,0x1a,0x00,0x00,0x31
	.byte 0xda,0x00,0x0a,0x00,0x00,0x6e,0x45,0x1b
	.byte 0x01,0x00,0x00,0x31,0xda,0x01,0x00,0x00
	.byte 0x6e,0x81,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x02,0x18,0x00,0x0a,0x00,0x00
	.byte 0x6e,0x6b,0x19,0x01,0x01,0x00,0x00,0x6e
	.byte 0x9d,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x4c,0x7b,0x1a,0x00,0x00,0x4c,0x7b
	.byte 0x00,0x0a,0x00,0x00,0x6e,0x86,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x6e,0xa2
	.byte 0x18,0x00,0x00,0x31,0xda,0x0a,0x00,0x00
	.byte 0x6e,0xac,0x18,0x00,0x00,0x31,0xda,0x0a
	.byte 0x00,0x00,0x6e,0xb6,0x18,0x00,0x00,0x31
	.byte 0xda,0x0a,0x00,0x00,0x6e,0xc0,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x6e,0xca
	.byte 0x19,0x01,0x01,0x00,0x00,0x6f,0x09,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x6e,0xa7
	.byte 0x1a,0x00,0x00,0x6e,0xb1,0x1a,0x00,0x00
	.byte 0x6e,0xbb,0x1a,0x00,0x00,0x6e,0xc5,0x1a
	.byte 0x00,0x00,0x6e,0xcf,0x00,0x0a,0x00,0x00
	.byte 0x6e,0xd4,0x18,0x00,0x00,0x31,0xda,0x0a
	.byte 0x00,0x00,0x6f,0x0e,0x19,0x01,0x01,0x00
	.byte 0x00,0x6f,0x39,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x6f,0x13,0x00,0x0a,0x00,0x00
	.byte 0x6f,0x18,0x18,0x00,0x00,0x01,0x53,0x0a
	.byte 0x00,0x00,0x6f,0x3e,0x18,0x00,0x00,0x01
	.byte 0x53,0x0a,0x00,0x00,0x6f,0x48,0x18,0x00
	.byte 0x00,0x31,0xda,0x0a,0x00,0x00,0x6f,0x52
	.byte 0x18,0x00,0x00,0x31,0xda,0x0a,0x00,0x00
	.byte 0x6f,0x5c,0x18
	.byte 0x00,0x00,0x31,0xda,0x0a,0x00,0x00,0x6f
	.byte 0x66,0x18,0x00,0x00,0x31,0xda,0x0a,0x00
	.byte 0x00,0x6f,0x70,0x18,0x00,0x00,0x31,0xda
	.byte 0x0a,0x00,0x00,0x6f,0x7a,0x19,0x01,0x01
	.byte 0x00,0x00,0x6f,0xb9,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00
	.byte 0x00,0x6f,0x43,0x1a,0x00,0x00,0x6f,0x4d
	.byte 0x1a,0x00,0x00,0x6f,0x57,0x1a,0x00,0x00
	.byte 0x6f,0x61,0x1a,0x00,0x00,0x6f,0x6b,0x1a
	.byte 0x00,0x00,0x6f,0x75,0x1a,0x00,0x00,0x6f
	.byte 0x7f,0x00,0x0a,0x00,0x00,0x6f,0x84,0x18
	.byte 0x00,0x00,0x01,0x53,0x0a,0x00,0x00,0x6f
	.byte 0xbe,0x18,0x00,0x00,0x01,0x53,0x0a,0x00
	.byte 0x00,0x6f,0xc8,0x18,0x00,0x00,0x31,0xda
	.byte 0x0a,0x00,0x00,0x6f,0xd2,0x19,0x01,0x01
	.byte 0x00,0x00,0x6f,0xfd,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00
	.byte 0x00,0x6f,0xc3,0x1a,0x00,0x00,0x6f,0xcd
	.byte 0x1a,0x00,0x00,0x6f,0xd7,0x00,0x0a,0x00
	.byte 0x00,0x6f,0xdc,0x18,0x00,0x00,0x31,0xc1
	.byte 0x0a,0x00,0x00,0x70,0x02,0x18,0x00,0x00
	.byte 0x31,0xda,0x0a,0x00,0x00,0x70,0x0c,0x19
	.byte 0x01,0x01,0x00,0x00,0x70,0x3c,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xc1
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x70,0x07,0x1a
	.byte 0x00,0x00,0x70,0x11,0x00,0x0a,0x00,0x00
	.byte 0x70,0x16,0x18,0x00,0x00,0x31,0xda,0x0a
	.byte 0x00,0x00,0x70,0x41,0x19,0x01,0x01,0x00
	.byte 0x00,0x70,0x6c,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x70,0x46,0x00,0x0a,0x00,0x00
	.byte 0x70,0x4b,0x18,0x00,0x00,0x01,0x53,0x0a
	.byte 0x00,0x00,0x70,0x71,0x18,0x00,0x00,0x01
	.byte 0x53,0x0a,0x00,0x00,0x70,0x7b,0x18,0x00
	.byte 0x00,0x31,0xc1,0x0a,0x00,0x00,0x70,0x85
	.byte 0x18,0x00,0x00,0x31,0xda,0x0a,0x00,0x00
	.byte 0x70,0x8f,0x19,0x01,0x01,0x00,0x00,0x70
	.byte 0xbf,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x1a,0x00,0x00,0x70,0x76
	.byte 0x1a,0x00,0x00,0x70,0x80,0x1a,0x00,0x00
	.byte 0x70,0x8a,0x1a,0x00,0x00,0x70,0x94,0x00
	.byte 0x0a,0x00,0x00,0x70,0x99,0x18,0x00,0x00
	.byte 0x01,0x53,0x0a,0x00,0x00,0x70,0xc4,0x18
	.byte 0x00,0x00,0x01,0x53,0x0a,0x00,0x00,0x70
	.byte 0xce,0x18,0x00,0x00,0x31,0xda,0x0a,0x00
	.byte 0x00,0x70,0xd8,0x19,0x01,0x01,0x00,0x00
	.byte 0x71,0x03,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x1a,0x00,0x00,0x70
	.byte 0xc9,0x1a,0x00,0x00,0x70,0xd3,0x1a,0x00
	.byte 0x00,0x70,0xdd,0x00,0x0a,0x00,0x00,0x70
	.byte 0xe2,0x19,0x01,0x01,0x00,0x00,0x71,0x29
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x4c
	.byte 0x7b,0x00,0x0a,0x00,0x00,0x71,0x08,0x19
	.byte 0x01,0x01,0x00,0x00,0x71,0x5e,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x31,0xc1
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x3b,0x48,0x1a
	.byte 0x00,0x00,0x3b,0x48,0x1a,0x00,0x00,0x3b
	.byte 0x48,0x1a,0x00,0x00,0x3b,0x48,0x00,0x0a
	.byte 0x00,0x00,0x71,0x2e,0x18,0x00,0x00,0x01
	.byte 0x53,0x0a,0x00,0x00,0x71,0x63,0x18,0x00
	.byte 0x00,0x01,0x53,0x0a,0x00,0x00,0x71,0x6d
	.byte 0x18,0x00,0x00,0x31,0xda,0x0a,0x00,0x00
	.byte 0x71,0x77,0x19,0x01,0x01,0x00,0x00,0x71
	.byte 0xa7,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x1a,0x00,0x00,0x71,0x68
	.byte 0x1a,0x00,0x00,0x71,0x72,0x1a,0x00,0x00
	.byte 0x4c,0x7b,0x1a,0x00,0x00,0x71,0x7c,0x00
	.byte 0x0a,0x00,0x00,0x71,0x81,0x18,0x00,0x00
	.byte 0x01,0x53,0x0a,0x00,0x00,0x71,0xac,0x18
	.byte 0x00,0x00,0x01,0x53,0x0a,0x00,0x00,0x71
	.byte 0xb6,0x18,0x00,0x00,0x31,0xda,0x0a,0x00
	.byte 0x00,0x71,0xc0,0x19,0x01,0x01,0x00,0x00
	.byte 0x71,0xff,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x1a,0x00,0x00,0x71
	.byte 0xb1,0x1a,0x00,0x00,0x71,0xbb,0x1a,0x00
	.byte 0x00,0x3b,0x48,0x1a,0x00,0x00,0x3b,0x48
	.byte 0x1a,0x00,0x00,0x3b,0x48,0x1a,0x00,0x00
	.byte 0x3b,0x48,0x1a,0x00,0x00,0x71,0xc5,0x00
	.byte 0x0a,0x00,0x00,0x71,0xca,0x19,0x01,0x01
	.byte 0x00,0x00,0x72,0x11,0x1a,0x00,0x00,0x43
	.byte 0x17,0x00,0x0a,0x00,0x00,0x72,0x04,0x19
	.byte 0x01,0x01,0x00,0x00,0x72,0x23,0x1a,0x00
	.byte 0x00,0x43,0x17,0x00,0x0a,0x00,0x00,0x72
	.byte 0x16,0x1b,0x01,0x00,0x00,0x31,0xda,0x01
	.byte 0x00,0x00,0x72,0x3e,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a
	.byte 0x00,0x00,0x72,0x28,0x1b,0x01,0x00,0x00
	.byte 0x31,0xda,0x01,0x00,0x00,0x72,0x68,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xda,0x1a,0x00,0x00,0x31,0xda,0x1a,0x00
	.byte 0x00,0x31,0xda,0x1a,0x00,0x00,0x31,0xda
	.byte 0x00,0x0a,0x00,0x00,0x72,0x43,0x1b,0x01
	.byte 0x00,0x00,0x31,0xda,0x01,0x00,0x00,0x72
	.byte 0x83,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x02,0x18,0x00,0x0a,0x00,0x00,0x72
	.byte 0x6d,0x19,0x01,0x01,0x00,0x00,0x72,0x9a
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xda,0x00,0x0a,0x00,0x00,0x72,0x88
	.byte 0x19,0x01,0x01,0x00,0x00,0x72,0xac,0x1a
	.byte 0x00,0x00,0x43,0x17,0x00,0x0a,0x00,0x00
	.byte 0x72,0x9f,0x19,0x01,0x01,0x00,0x00,0x72
	.byte 0xc8,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x39,0x23,0x1a,0x00,0x00,0x39,0x23
	.byte 0x00,0x0a,0x00,0x00,0x72,0xb1,0x19,0x01
	.byte 0x01,0x00,0x00,0x72,0xda,0x1a,0x00,0x00
	.byte 0x43,0x17,0x00,0x0a,0x00,0x00,0x72,0xcd
	.byte 0x19,0x01,0x01,0x00,0x00,0x72,0xec,0x1a
	.byte 0x00,0x00,0x43,0x17,0x00,0x0a,0x00,0x00
	.byte 0x72,0xdf,0x18,0x00,0x00,0x4e,0xd3,0x0a
	.byte 0x00,0x00,0x72,0xf1,0x1b,0x01,0x00,0x00
	.byte 0x31,0xc1,0x01,0x00,0x00,0x73,0x25,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x72,0xf6
	.byte 0x1a,0x00,0x00,0x3b,0x48,0x00,0x0a,0x00
	.byte 0x00,0x72,0xfb,0x18,0x00,0x00,0x01,0x53
	.byte 0x0a,0x00,0x00,0x73,0x2a,0x18,0x00,0x00
	.byte 0x01,0x53,0x0a,0x00,0x00,0x73,0x34,0x18
	.byte 0x00,0x00,0x4e,0xd3,0x0a,0x00,0x00,0x73
	.byte 0x3e,0x19,0x01,0x01,0x00,0x00,0x73,0x6e
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x73,0x2f,0x1a
	.byte 0x00,0x00,0x73,0x39,0x1a,0x00,0x00,0x73
	.byte 0x43,0x1a,0x00,0x00,0x3b,0x48,0x00,0x0a
	.byte 0x00,0x00,0x73,0x48,0x19,0x01,0x01,0x00
	.byte 0x00,0x73,0x94,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x4b,0xa9,0x00,0x0a,0x00,0x00
	.byte 0x73,0x73,0x19,0x01,0x01,0x00,0x00,0x73
	.byte 0xba,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x4e,0xe5,0x00,0x0a,0x00,0x00,0x73,0x99
	.byte 0x19,0x01,0x01,0x00,0x00,0x73,0xd6,0x1a
	.byte 0x00,0x00,0x43,0x17,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a
	.byte 0x00,0x00,0x73,0xbf,0x06,0x00,0x00,0x73
	.byte 0xd6
	.ascii "points_func\0"
	.byte 0x03,0x19,0x01,0x01,0x00,0x00,0x74,0x09
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x31,0xc1,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x00,0x0a,0x00,0x00
	.byte 0x73,0xed,0x06,0x00,0x00,0x74,0x09
	.ascii "line_func\0"
	.byte 0x03,0x19,0x01,0x01,0x00,0x00,0x74,0x3f
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x31,0xc1,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x00,0x0a,0x00,0x00,0x74,0x1e,0x06
	.byte 0x00,0x00,0x74,0x3f
	.ascii "triangle_func\0"
	.byte 0x03,0x19,0x01,0x01,0x00,0x00,0x74,0x7e
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x31,0xc1,0x1a
	.byte 0x00,0x00,0x31,0xc1,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x31,0xc1,0x00,0x0a
	.byte 0x00,0x00,0x74,0x58,0x06,0x00,0x00,0x74
	.byte 0x7e
	.ascii "quad_func\0"
	.byte 0x03,0x19,0x01,0x01,0x00,0x00,0x74,0xb4
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x01
	.byte 0x53,0x00,0x0a,0x00,0x00,0x74,0x93,0x06
	.byte 0x00,0x00,0x74,0xb4
	.ascii "rect_func\0"
	.byte 0x03,0x18,0x00,0x00,0x31,0xfe,0x0a,0x00
	.byte 0x00,0x74,0xc9,0x1b,0x01,0x00,0x00,0x31
	.byte 0xda,0x01,0x00,0x00,0x75,0x0c,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x01,0x53,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x02
	.byte 0x18,0x1a,0x00,0x00,0x31,0xda,0x1a,0x00
	.byte 0x00,0x74,0xce,0x00,0x0a,0x00,0x00,0x74
	.byte 0xd3,0x18,0x00,0x00,0x43,0xdf,0x0a,0x00
	.byte 0x00,0x75,0x11,0x1b,0x01,0x00,0x00,0x31
	.byte 0xda,0x01,0x00,0x00,0x75,0x4f,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x01,0x53,0x1a,0x00,0x00
	.byte 0x39,0x23,0x1a,0x00,0x00,0x39,0x23,0x1a
	.byte 0x00,0x00,0x39,0x23,0x1a,0x00,0x00,0x39
	.byte 0x23,0x1a,0x00,0x00,0x75,0x16,0x00,0x0a
	.byte 0x00,0x00,0x75,0x1b,0x19,0x01,0x01,0x00
	.byte 0x00,0x75,0x66,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x00,0x0a,0x00
	.byte 0x00,0x75,0x54,0x19,0x01,0x01,0x00,0x00
	.byte 0x75,0x78,0x1a,0x00,0x00,0x43,0x17,0x00
	.byte 0x0a,0x00,0x00,0x75,0x6b,0x19,0x01,0x01
	.byte 0x00,0x00,0x75,0x94,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xc1,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x0a,0x00,0x00,0x75
	.byte 0x7d,0x1b,0x01,0x00,0x00,0x31,0xda,0x01
	.byte 0x00,0x00,0x75,0xaf,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x31,0xda,0x00,0x0a
	.byte 0x00,0x00,0x75,0x99,0x18,0x00,0x00,0x39
	.byte 0x23,0x0a,0x00,0x00,0x75,0xb4,0x19,0x01
	.byte 0x01,0x00,0x00,0x75,0xd5,0x1a,0x00,0x00
	.byte 0x43,0x17,0x1a,0x00,0x00,0x02,0x18,0x1a
	.byte 0x00,0x00,0x75,0xb9,0x00,0x0a,0x00,0x00
	.byte 0x75,0xbe,0x18,0x00,0x00,0x32,0x0b,0x0a
	.byte 0x00,0x00,0x75,0xda,0x19,0x01,0x01,0x00
	.byte 0x00,0x76,0x0a,0x1a,0x00,0x00,0x43,0x17
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x3b,0xa4,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x75
	.byte 0xdf,0x00,0x0a,0x00,0x00,0x75,0xe4,0x18
	.byte 0x00,0x00,0x39,0x23,0x0a,0x00,0x00,0x76
	.byte 0x0f,0x19,0x01,0x01,0x00,0x00,0x76,0x3a
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0x3b,0xa4,0x1a
	.byte 0x00,0x00,0x02,0x18,0x1a,0x00,0x00,0x76
	.byte 0x14,0x00,0x0a,0x00,0x00,0x76,0x19,0x19
	.byte 0x01,0x01,0x00,0x00,0x76,0x56,0x1a,0x00
	.byte 0x00,0x43,0x17,0x1a,0x00,0x00,0x02,0x18
	.byte 0x1a,0x00,0x00,0x3b,0xa4,0x00,0x0a,0x00
	.byte 0x00,0x76,0x3f,0x19,0x01,0x01,0x00,0x00
	.byte 0x76,0x6d,0x1a,0x00,0x00,0x43,0x17,0x1a
	.byte 0x00,0x00,0x3b,0xa4,0x00,0x0a,0x00,0x00
	.byte 0x76,0x5b,0x19,0x01,0x01,0x00,0x00,0x76
	.byte 0x84,0x1a,0x00,0x00,0x43,0x17,0x1a,0x00
	.byte 0x00,0x3b,0xa4,0x00,0x0a,0x00,0x00,0x76
	.byte 0x72,0x19,0x01,0x01,0x00,0x00,0x76,0x9b
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xda,0x00,0x0a,0x00,0x00,0x76,0x89
	.byte 0x0b
	.ascii "dd_function_table\0"
	.byte 0xd4,0x04,0x00,0x00,0x7b,0x08,0x0c
	.ascii "RendererString\0"
	.byte 0x00,0x00,0x6d,0xaf,0x02,0x23,0x00,0x0c
	.ascii "UpdateState\0"
	.byte 0x00,0x00,0x6d,0xc1,0x02,0x23,0x04,0x0c
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x6d,0xd8,0x02,0x23,0x08,0x0c
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x6d,0xfe,0x02,0x23,0x0c,0x0c
	.ascii "Clear\0"
	.byte 0x00,0x00,0x6e,0x29,0x02,0x23,0x10,0x0c
	.ascii "Index\0"
	.byte 0x00,0x00,0x6e,0x40,0x02,0x23,0x14,0x0c
	.ascii "Color\0"
	.byte 0x00,0x00,0x6e,0x66,0x02,0x23,0x18,0x0c
	.ascii "SetBuffer\0"
	.byte 0x00,0x00,0x6e,0x81,0x02,0x23,0x1c,0x0c
	.ascii "GetBufferSize\0"
	.byte 0x00,0x00,0x6e,0x9d,0x02,0x23,0x20,0x0c
	.ascii "WriteColorSpan\0"
	.byte 0x00,0x00,0x6f,0x09,0x02,0x23,0x24,0x0c
	.ascii "WriteMonocolorSpan\0"
	.byte 0x00,0x00,0x6f,0x39,0x02,0x23,0x28,0x0c
	.ascii "WriteColorPixels\0"
	.byte 0x00,0x00,0x6f,0xb9,0x02,0x23,0x2c,0x0c
	.ascii "WriteMonocolorPixels\0"
	.byte 0x00,0x00,0x6f,0xfd,0x02,0x23,0x30,0x0c
	.ascii "WriteIndexSpan\0"
	.byte 0x00,0x00,0x70,0x3c,0x02,0x23,0x34,0x0c
	.ascii "WriteMonoindexSpan\0"
	.byte 0x00,0x00,0x70,0x6c,0x02,0x23,0x38,0x0c
	.ascii "WriteIndexPixels\0"
	.byte 0x00,0x00,0x70,0xbf,0x02,0x23,0x3c,0x0c
	.ascii "WriteMonoindexPixels\0"
	.byte 0x00,0x00,0x71,0x03,0x02,0x23,0x40,0x0c
	.ascii "ReadIndexSpan\0"
	.byte 0x00,0x00,0x71,0x29,0x02,0x23,0x44,0x0c
	.ascii "ReadColorSpan\0"
	.byte 0x00,0x00,0x71,0x5e,0x02,0x23,0x48,0x0c
	.ascii "ReadIndexPixels\0"
	.byte 0x00,0x00,0x71,0xa7,0x02,0x23,0x4c,0x0c
	.ascii "ReadColorPixels\0"
	.byte 0x00,0x00,0x71,0xff,0x02,0x23,0x50,0x0c
	.ascii "Finish\0"
	.byte 0x00,0x00,0x72,0x11,0x02,0x23,0x54,0x0c
	.ascii "Flush\0"
	.byte 0x00,0x00,0x72,0x23,0x02,0x23,0x58,0x0c
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x72,0x3e,0x02,0x23,0x5c,0x0c
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x72,0x68,0x02,0x23,0x60,0x0c
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x72,0x83,0x02,0x23,0x64,0x0c
	.ascii "Dither\0"
	.byte 0x00,0x00,0x72,0x9a,0x02,0x23,0x68,0x0c
	.ascii "Error\0"
	.byte 0x00,0x00,0x72,0xac,0x02,0x23,0x6c,0x0c
	.ascii "NearFar\0"
	.byte 0x00,0x00,0x72,0xc8,0x02,0x23,0x70,0x0c
	.ascii "AllocDepthBuffer\0"
	.byte 0x00,0x00,0x72,0xda,0x02,0x23,0x74,0x0c
	.ascii "ClearDepthBuffer\0"
	.byte 0x00,0x00,0x72,0xec,0x02,0x23,0x78,0x0c
	.ascii "DepthTestSpan\0"
	.byte 0x00,0x00,0x73,0x25,0x02,0x23,0x7c,0x0c
	.ascii "DepthTestPixels\0"
	.byte 0x00,0x00,0x73,0x6e,0x03,0x23,0x80,0x01
	.byte 0x0c
	.ascii "ReadDepthSpanFloat\0"
	.byte 0x00,0x00,0x73,0x94,0x03,0x23,0x84,0x01
	.byte 0x0c
	.ascii "ReadDepthSpanInt\0"
	.byte 0x00,0x00,0x73,0xba,0x03,0x23,0x88,0x01
	.byte 0x0c
	.ascii "PointsFunc\0"
	.byte 0x00,0x00,0x73,0xdb,0x03,0x23,0x8c,0x01
	.byte 0x0c
	.ascii "LineFunc\0"
	.byte 0x00,0x00,0x74,0x0e,0x03,0x23,0x90,0x01
	.byte 0x0c
	.ascii "TriangleFunc\0"
	.byte 0x00,0x00,0x74,0x44,0x03,0x23,0x94,0x01
	.byte 0x0c
	.ascii "QuadFunc\0"
	.byte 0x00,0x00,0x74,0x83,0x03,0x23,0x98,0x01
	.byte 0x0c
	.ascii "RectFunc\0"
	.byte 0x00,0x00,0x74,0xb9,0x03,0x23,0x9c,0x01
	.byte 0x0c
	.ascii "DrawPixels\0"
	.byte 0x00,0x00,0x75,0x0c,0x03,0x23,0xa0,0x01
	.byte 0x0c
	.ascii "Bitmap\0"
	.byte 0x00,0x00,0x75,0x4f,0x03,0x23,0xa4,0x01
	.byte 0x0c
	.ascii "Begin\0"
	.byte 0x00,0x00,0x75,0x66,0x03,0x23,0xa8,0x01
	.byte 0x0c
	.ascii "End\0"
	.byte 0x00,0x00,0x75,0x78,0x03,0x23,0xac,0x01
	.byte 0x0c
	.ascii "RasterSetup\0"
	.byte 0x00,0x00,0x75,0x94,0x03,0x23,0xb0,0x01
	.byte 0x0c
	.ascii "RenderVB\0"
	.byte 0x00,0x00,0x75,0xaf,0x03,0x23,0xb4,0x01
	.byte 0x0c
	.ascii "TexEnv\0"
	.byte 0x00,0x00,0x75,0xd5,0x03,0x23,0xb8,0x01
	.byte 0x0c
	.ascii "TexImage\0"
	.byte 0x00,0x00,0x76,0x0a,0x03,0x23,0xbc,0x01
	.byte 0x0c
	.ascii "TexParameter\0"
	.byte 0x00,0x00,0x76,0x3a,0x03,0x23,0xc0,0x01
	.byte 0x0c
	.ascii "BindTexture\0"
	.byte 0x00,0x00,0x76,0x56,0x03,0x23,0xc4,0x01
	.byte 0x0c
	.ascii "DeleteTexture\0"
	.byte 0x00,0x00,0x76,0x6d,0x03,0x23,0xc8,0x01
	.byte 0x0c
	.ascii "UpdateTexturePalette\0"
	.byte 0x00,0x00,0x76,0x84,0x03,0x23,0xcc,0x01
	.byte 0x0c
	.ascii "UseGlobalTexturePalette\0"
	.byte 0x00,0x00,0x76,0x9b,0x03,0x23,0xd0,0x01
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x40,0x00
	.byte 0x00,0x7b,0x19,0x14,0x00,0x00,0x39,0x3a
	.byte 0x0f,0x00,0x13,0x00,0x00,0x39,0x2c,0x40
	.byte 0x00,0x00,0x7b,0x2a,0x14,0x00,0x00,0x39
	.byte 0x3a,0x0f,0x00,0x13,0x00,0x00,0x39,0x23
	.byte 0x40,0x00,0x00,0x7b,0x3b,0x14,0x00,0x00
	.byte 0x39,0x3a,0x0f,0x00,0x15,0x00,0x00,0x7b
	.byte 0x2a,0x08,0x00,0x00,0x00,0x7b,0x4d,0x14
	.byte 0x00,0x00,0x39,0x3a,0x1f,0x00,0x13,0x00
	.byte 0x00,0x39,0x2c,0x40,0x00,0x00,0x7b,0x5e
	.byte 0x14,0x00,0x00,0x39,0x3a,0x0f,0x00,0x13
	.byte 0x00,0x00,0x39,0x23,0x40,0x00,0x00,0x7b
	.byte 0x6f,0x14,0x00,0x00,0x39,0x3a,0x0f,0x00
	.byte 0x15,0x00,0x00,0x7b,0x5e,0x08,0x00,0x00
	.byte 0x00,0x7b,0x81,0x14,0x00,0x00,0x39,0x3a
	.byte 0x1f,0x00,0x13,0x00,0x00,0x39,0x23,0x08
	.byte 0x00,0x00,0x7b,0x92,0x14,0x00,0x00,0x39
	.byte 0x3a,0x01,0x00,0x15,0x00,0x00,0x7b,0x81
	.byte 0x01,0x00,0x00,0x00,0x7b,0xa4,0x14,0x00
	.byte 0x00,0x39,0x3a,0x1f,0x00,0x13,0x00,0x00
	.byte 0x39,0x2c,0x40,0x00,0x00,0x7b,0xb5,0x14
	.byte 0x00,0x00,0x39,0x3a,0x0f,0x00,0x13,0x00
	.byte 0x00,0x39,0x23,0x40,0x00,0x00,0x7b,0xc6
	.byte 0x14,0x00,0x00,0x39,0x3a,0x0f,0x00,0x15
	.byte 0x00,0x00,0x7b,0xb5,0x02,0x80,0x00,0x00
	.byte 0x7b,0xd8,0x14,0x00,0x00,0x39,0x3a,0x09
	.byte 0x00,0x06,0x00,0x00,0x31,0xc1
	.ascii "GLbitfield\0"
	.byte 0x02,0x0a,0x00,0x00,0x7b,0xee,0x0b
	.ascii "gl_attrib_node\0"
	.byte 0x0c,0x03,0x00,0x00,0x7c,0x2c,0x0c
	.ascii "kind\0"
	.byte 0x00,0x00,0x7b,0xd8,0x02,0x23,0x00,0x0c
	.ascii "data\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x04,0x0c
	.ascii "next\0"
	.byte 0x00,0x00,0x7b,0xe9,0x02,0x23,0x08,0x00
	.byte 0x13,0x00,0x00,0x7b,0xe9,0x40,0x00,0x00
	.byte 0x7c,0x3d,0x14,0x00,0x00,0x39,0x3a,0x0f
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x10,0x00
	.byte 0x00,0x7c,0x4e,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x0b
	.ascii "gl_accum_attrib\0"
	.byte 0x10,0x03,0x00,0x00,0x7c,0x79,0x0c
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x7c,0x3d,0x02,0x23,0x00,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x7c,0x8a,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x10,0x00
	.byte 0x00,0x7c,0x9b,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x0b
	.ascii "gl_colorbuffer_attrib\0"
	.byte 0x58,0x03,0x00,0x00,0x7e,0x4a,0x0c
	.ascii "ClearIndex\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x00,0x0c
	.ascii "ClearColor\0"
	.byte 0x00,0x00,0x7c,0x79,0x02,0x23,0x04,0x0c
	.ascii "IndexMask\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x14,0x0c
	.ascii "ColorMask\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x18,0x0c
	.ascii "SWmasking\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x1c,0x0c
	.ascii "DrawBuffer\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x20,0x0c
	.ascii "AlphaEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x24,0x0c
	.ascii "AlphaFunc\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x28,0x0c
	.ascii "AlphaRef\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x2c,0x0c
	.ascii "AlphaRefUbyte\0"
	.byte 0x00,0x00,0x31,0xeb,0x02,0x23,0x30,0x0c
	.ascii "BlendEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x31,0x0c
	.ascii "BlendSrc\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x34,0x0c
	.ascii "BlendDst\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x38,0x0c
	.ascii "BlendEquation\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x3c,0x0c
	.ascii "BlendColor\0"
	.byte 0x00,0x00,0x7c,0x8a,0x02,0x23,0x40,0x0c
	.ascii "LogicOp\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x50,0x0c
	.ascii "IndexLogicOpEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x54,0x0c
	.ascii "ColorLogicOpEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x55,0x0c
	.ascii "SWLogicOpEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x56,0x0c
	.ascii "DitherFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x57,0x00
	.byte 0x13,0x00,0x00,0x31,0xeb,0x04,0x00,0x00
	.byte 0x7e,0x5b,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x0c,0x00
	.byte 0x00,0x7e,0x6c,0x14,0x00,0x00,0x39,0x3a
	.byte 0x02,0x00,0x13,0x00,0x00,0x39,0x2c,0x10
	.byte 0x00,0x00,0x7e,0x7d,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x39,0x2c
	.byte 0x10,0x00,0x00,0x7e,0x8e,0x14,0x00,0x00
	.byte 0x39,0x3a,0x03,0x00,0x13,0x00,0x00,0x39
	.byte 0x2c,0x10,0x00,0x00,0x7e,0x9f,0x14,0x00
	.byte 0x00,0x39,0x3a,0x03,0x00,0x13,0x00,0x00
	.byte 0x39,0x2c,0x10,0x00,0x00,0x7e,0xb0,0x14
	.byte 0x00,0x00,0x39,0x3a,0x03,0x00,0x0b
	.ascii "gl_current_attrib\0"
	.byte 0x60,0x03,0x00,0x00,0x7f,0x9a,0x0c
	.ascii "ByteColor\0"
	.byte 0x00,0x00,0x7e,0x4a,0x02,0x23,0x00,0x0c
	.ascii "Index\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x04,0x0c
	.ascii "Normal\0"
	.byte 0x00,0x00,0x7e,0x5b,0x02,0x23,0x08,0x0c
	.ascii "TexCoord\0"
	.byte 0x00,0x00,0x7e,0x6c,0x02,0x23,0x14,0x0c
	.ascii "RasterPos\0"
	.byte 0x00,0x00,0x7e,0x7d,0x02,0x23,0x24,0x0c
	.ascii "RasterDistance\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x34,0x0c
	.ascii "RasterColor\0"
	.byte 0x00,0x00,0x7e,0x8e,0x02,0x23,0x38,0x0c
	.ascii "RasterIndex\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x48,0x0c
	.ascii "RasterTexCoord\0"
	.byte 0x00,0x00,0x7e,0x9f,0x02,0x23,0x4c,0x0c
	.ascii "RasterPosValid\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x5c,0x0c
	.ascii "EdgeFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x5d,0x00
	.byte 0x0b
	.ascii "gl_depthbuffer_attrib\0"
	.byte 0x0c,0x03,0x00,0x00,0x7f,0xed,0x0c
	.ascii "Func\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "Clear\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x04,0x0c
	.ascii "Test\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x08,0x0c
	.ascii "Mask\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x09,0x00
	.byte 0x0b
	.ascii "gl_eval_attrib\0"
	.byte 0x38,0x03,0x00,0x00,0x82,0x52,0x0c
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x01,0x0c
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x02,0x0c
	.ascii "Map1TextureCoord1\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x03,0x0c
	.ascii "Map1TextureCoord2\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x04,0x0c
	.ascii "Map1TextureCoord3\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x05,0x0c
	.ascii "Map1TextureCoord4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x06,0x0c
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x07,0x0c
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x08,0x0c
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x09,0x0c
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0a,0x0c
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0b,0x0c
	.ascii "Map2TextureCoord1\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0c,0x0c
	.ascii "Map2TextureCoord2\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0d,0x0c
	.ascii "Map2TextureCoord3\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0e,0x0c
	.ascii "Map2TextureCoord4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0f,0x0c
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x10,0x0c
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x11,0x0c
	.ascii "AutoNormal\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x12,0x0c
	.ascii "MapGrid1un\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x14,0x0c
	.ascii "MapGrid1u1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "MapGrid1u2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "MapGrid2un\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x20,0x0c
	.ascii "MapGrid2vn\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x24,0x0c
	.ascii "MapGrid2u1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x28,0x0c
	.ascii "MapGrid2u2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x2c,0x0c
	.ascii "MapGrid2v1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x30,0x0c
	.ascii "MapGrid2v2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x34,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x82,0x63,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x0b
	.ascii "gl_fog_attrib\0"
	.byte 0x28,0x03,0x00,0x00,0x82,0xdc,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "Color\0"
	.byte 0x00,0x00,0x82,0x52,0x02,0x23,0x04,0x0c
	.ascii "Density\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x14,0x0c
	.ascii "Start\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "End\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "Index\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x20,0x0c
	.ascii "Mode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x24,0x00
	.byte 0x0b
	.ascii "gl_hint_attrib\0"
	.byte 0x14,0x03,0x00,0x00,0x83,0x5a,0x0c
	.ascii "PerspectiveCorrection\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "PointSmooth\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "LineSmooth\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x08,0x0c
	.ascii "PolygonSmooth\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x0c,0x0c
	.ascii "Fog\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x10,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x83,0x6b,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x10,0x00
	.byte 0x00,0x83,0x7c,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x13,0x00,0x00,0x39,0x2c,0x10
	.byte 0x00,0x00,0x83,0x8d,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x39,0x2c
	.byte 0x10,0x00,0x00,0x83,0x9e,0x14,0x00,0x00
	.byte 0x39,0x3a,0x03,0x00,0x13,0x00,0x00,0x39
	.byte 0x2c,0x10,0x00,0x00,0x83,0xaf,0x14,0x00
	.byte 0x00,0x39,0x3a,0x03,0x00,0x17
	.ascii "gl_light\0"
	.byte 0x10,0xe4,0x03,0x00,0x00,0x85,0x71,0x0c
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x83,0x5a,0x02,0x23,0x00,0x0c
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x83,0x6b,0x02,0x23,0x10,0x0c
	.ascii "Specular\0"
	.byte 0x00,0x00,0x83,0x7c,0x02,0x23,0x20,0x0c
	.ascii "Position\0"
	.byte 0x00,0x00,0x83,0x8d,0x02,0x23,0x30,0x0c
	.ascii "Direction\0"
	.byte 0x00,0x00,0x83,0x9e,0x02,0x23,0x40,0x0c
	.ascii "SpotExponent\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x50,0x0c
	.ascii "SpotCutoff\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x54,0x0c
	.ascii "CosCutoff\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x58,0x0c
	.ascii "ConstantAttenuation\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x5c,0x0c
	.ascii "LinearAttenuation\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x60,0x0c
	.ascii "QuadraticAttenuation\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x64,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x68,0x0c
	.ascii "NextEnabled\0"
	.byte 0x00,0x00,0x85,0x71,0x02,0x23,0x6c,0x0c
	.ascii "VP_inf_norm\0"
	.byte 0x00,0x00,0x85,0x76,0x02,0x23,0x70,0x0c
	.ascii "h_inf_norm\0"
	.byte 0x00,0x00,0x85,0x87,0x02,0x23,0x7c,0x0c
	.ascii "NormDirection\0"
	.byte 0x00,0x00,0x85,0x98,0x03,0x23,0x88,0x01
	.byte 0x0c
	.ascii "SpotExpTable\0"
	.byte 0x00,0x00,0x85,0xba,0x03,0x23,0x94,0x01
	.byte 0x0c
	.ascii "MatAmbient\0"
	.byte 0x00,0x00,0x85,0xde,0x03,0x23,0x94,0x21
	.byte 0x0c
	.ascii "MatDiffuse\0"
	.byte 0x00,0x00,0x86,0x00,0x03,0x23,0xac,0x21
	.byte 0x0c
	.ascii "MatSpecular\0"
	.byte 0x00,0x00,0x86,0x22,0x03,0x23,0xc4,0x21
	.byte 0x0c
	.ascii "dli\0"
	.byte 0x00,0x00,0x39,0x2c,0x03,0x23,0xdc,0x21
	.byte 0x0c
	.ascii "sli\0"
	.byte 0x00,0x00,0x39,0x2c,0x03,0x23,0xe0,0x21
	.byte 0x00,0x0a,0x00,0x00,0x83,0xaf,0x13,0x00
	.byte 0x00,0x39,0x2c,0x0c,0x00,0x00,0x85,0x87
	.byte 0x14,0x00,0x00,0x39,0x3a,0x02,0x00,0x13
	.byte 0x00,0x00,0x39,0x2c,0x0c,0x00,0x00,0x85
	.byte 0x98,0x14,0x00,0x00,0x39,0x3a,0x02,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x0c,0x00,0x00
	.byte 0x85,0xa9,0x14,0x00,0x00,0x39,0x3a,0x02
	.byte 0x00,0x13,0x00,0x00,0x39,0x23,0x08,0x00
	.byte 0x00,0x85,0xba,0x14,0x00,0x00,0x39,0x3a
	.byte 0x01,0x00,0x15,0x00,0x00,0x85,0xa9,0x10
	.byte 0x00,0x00,0x00,0x85,0xcd,0x16,0x00,0x00
	.byte 0x39,0x3a,0x01,0xff,0x00,0x13,0x00,0x00
	.byte 0x39,0x23,0x0c,0x00,0x00,0x85,0xde,0x14
	.byte 0x00,0x00,0x39,0x3a,0x02,0x00,0x13,0x00
	.byte 0x00,0x85,0xcd,0x18,0x00,0x00,0x85,0xef
	.byte 0x14,0x00,0x00,0x39,0x3a,0x01,0x00,0x13
	.byte 0x00,0x00,0x39,0x23,0x0c,0x00,0x00,0x86
	.byte 0x00,0x14,0x00,0x00,0x39,0x3a,0x02,0x00
	.byte 0x13,0x00,0x00,0x85,0xef,0x18,0x00,0x00
	.byte 0x86,0x11,0x14,0x00,0x00,0x39,0x3a,0x01
	.byte 0x00,0x13,0x00,0x00,0x39,0x23,0x0c,0x00
	.byte 0x00,0x86,0x22,0x14,0x00,0x00,0x39,0x3a
	.byte 0x02,0x00,0x13,0x00,0x00,0x86,0x11,0x18
	.byte 0x00,0x00,0x86,0x33,0x14,0x00,0x00,0x39
	.byte 0x3a,0x01,0x00,0x15,0x00,0x00,0x83,0xaf
	.byte 0x87,0x20,0x00,0x00,0x86,0x45,0x14,0x00
	.byte 0x00,0x39,0x3a,0x07,0x00,0x13,0x00,0x00
	.byte 0x39,0x2c,0x10,0x00,0x00,0x86,0x56,0x14
	.byte 0x00,0x00,0x39,0x3a,0x03,0x00,0x0b
	.ascii "gl_lightmodel\0"
	.byte 0x14,0x03,0x00,0x00,0x86,0xa0,0x0c
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x86,0x45,0x02,0x23,0x00,0x0c
	.ascii "LocalViewer\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x10,0x0c
	.ascii "TwoSide\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x11,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x86,0xb1,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x10,0x00
	.byte 0x00,0x86,0xc2,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x13,0x00,0x00,0x39,0x2c,0x10
	.byte 0x00,0x00,0x86,0xd3,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x39,0x2c
	.byte 0x10,0x00,0x00,0x86,0xe4,0x14,0x00,0x00
	.byte 0x39,0x3a,0x03,0x00,0x15,0x00,0x00,0x39
	.byte 0x2c,0x03,0x20,0x00,0x00,0x86,0xf7,0x16
	.byte 0x00,0x00,0x39,0x3a,0x00,0xc7,0x00,0x17
	.ascii "gl_material\0"
	.byte 0x03,0x70,0x03,0x00,0x00,0x87,0xb3,0x0c
	.ascii "Ambient\0"
	.byte 0x00,0x00,0x86,0xa0,0x02,0x23,0x00,0x0c
	.ascii "Diffuse\0"
	.byte 0x00,0x00,0x86,0xb1,0x02,0x23,0x10,0x0c
	.ascii "Specular\0"
	.byte 0x00,0x00,0x86,0xc2,0x02,0x23,0x20,0x0c
	.ascii "Emission\0"
	.byte 0x00,0x00,0x86,0xd3,0x02,0x23,0x30,0x0c
	.ascii "Shininess\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x40,0x0c
	.ascii "AmbientIndex\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x44,0x0c
	.ascii "DiffuseIndex\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x48,0x0c
	.ascii "SpecularIndex\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x4c,0x0c
	.ascii "ShineTable\0"
	.byte 0x00,0x00,0x86,0xe4,0x02,0x23,0x50,0x00
	.byte 0x15,0x00,0x00,0x86,0xf7,0x06,0xe0,0x00
	.byte 0x00,0x87,0xc5,0x14,0x00,0x00,0x39,0x3a
	.byte 0x01,0x00,0x13,0x00,0x00,0x39,0x23,0x10
	.byte 0x00,0x00,0x87,0xd6,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x87,0xc5
	.byte 0x20,0x00,0x00,0x87,0xe7,0x14,0x00,0x00
	.byte 0x39,0x3a,0x01,0x00,0x17
	.ascii "gl_light_attrib\0"
	.byte 0x8e,0x54,0x03,0x00,0x00,0x89,0x08,0x0c
	.ascii "Light\0"
	.byte 0x00,0x00,0x86,0x33,0x02,0x23,0x00,0x0c
	.ascii "Model\0"
	.byte 0x00,0x00,0x86,0x56,0x04,0x23,0xa0,0x8e
	.byte 0x02,0x0c
	.ascii "Material\0"
	.byte 0x00,0x00,0x87,0xb3,0x04,0x23,0xb4,0x8e
	.byte 0x02,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0x94,0x9c
	.byte 0x02,0x0c
	.ascii "ShadeModel\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0x98,0x9c
	.byte 0x02,0x0c
	.ascii "ColorMaterialFace\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0x9c,0x9c
	.byte 0x02,0x0c
	.ascii "ColorMaterialMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x04,0x23,0xa0,0x9c
	.byte 0x02,0x0c
	.ascii "ColorMaterialBitmask\0"
	.byte 0x00,0x00,0x31,0xcd,0x04,0x23,0xa4,0x9c
	.byte 0x02,0x0c
	.ascii "ColorMaterialEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0xa8,0x9c
	.byte 0x02,0x0c
	.ascii "FirstEnabled\0"
	.byte 0x00,0x00,0x85,0x71,0x04,0x23,0xac,0x9c
	.byte 0x02,0x0c
	.ascii "Fast\0"
	.byte 0x00,0x00,0x39,0x77,0x04,0x23,0xb0,0x9c
	.byte 0x02,0x0c
	.ascii "BaseColor\0"
	.byte 0x00,0x00,0x87,0xd6,0x04,0x23,0xb4,0x9c
	.byte 0x02,0x00,0x06,0x00,0x00,0x4e,0xd3
	.ascii "GLushort\0"
	.byte 0x02,0x0b
	.ascii "gl_line_attrib\0"
	.byte 0x0c,0x03,0x00,0x00,0x89,0x90,0x0c
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x01,0x0c
	.ascii "StipplePattern\0"
	.byte 0x00,0x00,0x89,0x08,0x02,0x23,0x02,0x0c
	.ascii "StippleFactor\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x08,0x00
	.byte 0x0b
	.ascii "gl_list_attrib\0"
	.byte 0x04,0x03,0x00,0x00,0x89,0xb8,0x0c
	.ascii "ListBase\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x00,0x00
	.byte 0x15,0x00,0x00,0x01,0x5a,0x04,0x00,0x00
	.byte 0x00,0x89,0xcb,0x16,0x00,0x00,0x39,0x3a
	.byte 0x00,0xff,0x00,0x15,0x00,0x00,0x01,0x5a
	.byte 0x04,0x00,0x00,0x00,0x89,0xde,0x16,0x00
	.byte 0x00,0x39,0x3a,0x00,0xff,0x00,0x15,0x00
	.byte 0x00,0x39,0x2c,0x04,0x00,0x00,0x00,0x89
	.byte 0xf1,0x16,0x00,0x00,0x39,0x3a,0x00,0xff
	.byte 0x00,0x15,0x00,0x00,0x39,0x2c,0x04,0x00
	.byte 0x00,0x00,0x8a,0x04,0x16,0x00,0x00,0x39
	.byte 0x3a,0x00,0xff,0x00,0x15,0x00,0x00,0x39
	.byte 0x2c,0x04,0x00,0x00,0x00,0x8a,0x17,0x16
	.byte 0x00,0x00,0x39,0x3a,0x00,0xff,0x00,0x15
	.byte 0x00,0x00,0x39,0x2c,0x04,0x00,0x00,0x00
	.byte 0x8a,0x2a,0x16,0x00,0x00,0x39,0x3a,0x00
	.byte 0xff,0x00,0x15,0x00,0x00,0x39,0x2c,0x04
	.byte 0x00,0x00,0x00,0x8a,0x3d,0x16,0x00,0x00
	.byte 0x39,0x3a,0x00,0xff,0x00,0x15,0x00,0x00
	.byte 0x39,0x2c,0x04,0x00,0x00,0x00,0x8a,0x50
	.byte 0x16,0x00,0x00,0x39,0x3a,0x00,0xff,0x00
	.byte 0x15,0x00,0x00,0x39,0x2c,0x04,0x00,0x00
	.byte 0x00,0x8a,0x63,0x16,0x00,0x00,0x39,0x3a
	.byte 0x00,0xff,0x00,0x15,0x00,0x00,0x39,0x2c
	.byte 0x04,0x00,0x00,0x00,0x8a,0x76,0x16,0x00
	.byte 0x00,0x39,0x3a,0x00,0xff,0x00,0x17
	.ascii "gl_pixel_attrib\0"
	.byte 0x28,0x68,0x03,0x00,0x00,0x8d,0x35,0x0c
	.ascii "ReadBuffer\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "RedBias\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x04,0x0c
	.ascii "RedScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x08,0x0c
	.ascii "GreenBias\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x0c,0x0c
	.ascii "GreenScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x10,0x0c
	.ascii "BlueBias\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x14,0x0c
	.ascii "BlueScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "AlphaBias\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "AlphaScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x20,0x0c
	.ascii "DepthBias\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x24,0x0c
	.ascii "DepthScale\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x28,0x0c
	.ascii "IndexShift\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x2c,0x0c
	.ascii "IndexOffset\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x30,0x0c
	.ascii "MapColorFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x34,0x0c
	.ascii "MapStencilFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x35,0x0c
	.ascii "ZoomX\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x38,0x0c
	.ascii "ZoomY\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x3c,0x0c
	.ascii "MapStoSsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x40,0x0c
	.ascii "MapItoIsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x44,0x0c
	.ascii "MapItoRsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x48,0x0c
	.ascii "MapItoGsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x4c,0x0c
	.ascii "MapItoBsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x50,0x0c
	.ascii "MapItoAsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x54,0x0c
	.ascii "MapRtoRsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x58,0x0c
	.ascii "MapGtoGsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x5c,0x0c
	.ascii "MapBtoBsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x60,0x0c
	.ascii "MapAtoAsize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x64,0x0c
	.ascii "MapStoS\0"
	.byte 0x00,0x00,0x89,0xb8,0x02,0x23,0x68,0x0c
	.ascii "MapItoI\0"
	.byte 0x00,0x00,0x89,0xcb,0x03,0x23,0xe8,0x08
	.byte 0x0c
	.ascii "MapItoR\0"
	.byte 0x00,0x00,0x89,0xde,0x03,0x23,0xe8,0x10
	.byte 0x0c
	.ascii "MapItoG\0"
	.byte 0x00,0x00,0x89,0xf1,0x03,0x23,0xe8,0x18
	.byte 0x0c
	.ascii "MapItoB\0"
	.byte 0x00,0x00,0x8a,0x04,0x03,0x23,0xe8,0x20
	.byte 0x0c
	.ascii "MapItoA\0"
	.byte 0x00,0x00,0x8a,0x17,0x03,0x23,0xe8,0x28
	.byte 0x0c
	.ascii "MapRtoR\0"
	.byte 0x00,0x00,0x8a,0x2a,0x03,0x23,0xe8,0x30
	.byte 0x0c
	.ascii "MapGtoG\0"
	.byte 0x00,0x00,0x8a,0x3d,0x03,0x23,0xe8,0x38
	.byte 0x0c
	.ascii "MapBtoB\0"
	.byte 0x00,0x00,0x8a,0x50,0x03,0x23,0xe8,0x40
	.byte 0x0c
	.ascii "MapAtoA\0"
	.byte 0x00,0x00,0x8a,0x63,0x03,0x23,0xe8,0x48
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x0c,0x00
	.byte 0x00,0x8d,0x46,0x14,0x00,0x00,0x39,0x3a
	.byte 0x02,0x00,0x0b
	.ascii "gl_point_attrib\0"
	.byte 0x20,0x03,0x00,0x00,0x8d,0xbf,0x0c
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "Size\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x04,0x0c
	.ascii "Params\0"
	.byte 0x00,0x00,0x8d,0x35,0x02,0x23,0x08,0x0c
	.ascii "MinSize\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x14,0x0c
	.ascii "MaxSize\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "Threshold\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x00
	.byte 0x0b
	.ascii "gl_polygon_attrib\0"
	.byte 0x28,0x03,0x00,0x00,0x8e,0xf2,0x0c
	.ascii "FrontFace\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "FrontMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "BackMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x08,0x0c
	.ascii "Unfilled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0c,0x0c
	.ascii "CullFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x0d,0x0c
	.ascii "CullFaceMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x10,0x0c
	.ascii "CullBits\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x14,0x0c
	.ascii "SmoothFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x18,0x0c
	.ascii "StippleFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x19,0x0c
	.ascii "OffsetFactor\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "OffsetUnits\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x20,0x0c
	.ascii "OffsetPoint\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x24,0x0c
	.ascii "OffsetLine\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x25,0x0c
	.ascii "OffsetFill\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x26,0x0c
	.ascii "OffsetAny\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x27,0x00
	.byte 0x13,0x00,0x00,0x31,0xcd,0x80,0x00,0x00
	.byte 0x8f,0x03,0x14,0x00,0x00,0x39,0x3a,0x1f
	.byte 0x00,0x06,0x00,0x00,0x01,0x53
	.ascii "GLsizei\0"
	.byte 0x02,0x0b
	.ascii "gl_scissor_attrib\0"
	.byte 0x14,0x03,0x00,0x00,0x8f,0x6c,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x08,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x0c,0x0c
	.ascii "Height\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x10,0x00
	.byte 0x0b
	.ascii "gl_stencil_attrib\0"
	.byte 0x18,0x03,0x00,0x00,0x90,0x1a,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x00,0x0c
	.ascii "Function\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "FailFunc\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x08,0x0c
	.ascii "ZPassFunc\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x0c,0x0c
	.ascii "ZFailFunc\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x10,0x0c
	.ascii "Ref\0"
	.byte 0x00,0x00,0x6c,0x75,0x02,0x23,0x14,0x0c
	.ascii "ValueMask\0"
	.byte 0x00,0x00,0x6c,0x75,0x02,0x23,0x15,0x0c
	.ascii "Clear\0"
	.byte 0x00,0x00,0x6c,0x75,0x02,0x23,0x16,0x0c
	.ascii "WriteMask\0"
	.byte 0x00,0x00,0x6c,0x75,0x02,0x23,0x17,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x90,0x2b,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x13,0x00,0x00,0x39,0x2c,0x10,0x00
	.byte 0x00,0x90,0x3c,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x13,0x00,0x00,0x39,0x2c,0x10
	.byte 0x00,0x00,0x90,0x4d,0x14,0x00,0x00,0x39
	.byte 0x3a,0x03,0x00,0x13,0x00,0x00,0x39,0x2c
	.byte 0x10,0x00,0x00,0x90,0x5e,0x14,0x00,0x00
	.byte 0x39,0x3a,0x03,0x00,0x13,0x00,0x00,0x39
	.byte 0x2c,0x10,0x00,0x00,0x90,0x6f,0x14,0x00
	.byte 0x00,0x39,0x3a,0x03,0x00,0x13,0x00,0x00
	.byte 0x39,0x2c,0x10,0x00,0x00,0x90,0x80,0x14
	.byte 0x00,0x00,0x39,0x3a,0x03,0x00,0x13,0x00
	.byte 0x00,0x39,0x2c,0x10,0x00,0x00,0x90,0x91
	.byte 0x14,0x00,0x00,0x39,0x3a,0x03,0x00,0x13
	.byte 0x00,0x00,0x39,0x2c,0x10,0x00,0x00,0x90
	.byte 0xa2,0x14,0x00,0x00,0x39,0x3a,0x03,0x00
	.byte 0x13,0x00,0x00,0x39,0x2c,0x10,0x00,0x00
	.byte 0x90,0xb3,0x14,0x00,0x00,0x39,0x3a,0x03
	.byte 0x00,0x15,0x00,0x00,0x31,0xeb,0x04,0x00
	.byte 0x00,0x00,0x90,0xc6,0x16,0x00,0x00,0x39
	.byte 0x3a,0x03,0xff,0x00,0x17
	.ascii "gl_texture_attrib\0"
	.byte 0x04,0xd8,0x03,0x00,0x00,0x92,0xf5,0x0c
	.ascii "Enabled\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x00,0x0c
	.ascii "EnvMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "EnvColor\0"
	.byte 0x00,0x00,0x90,0x1a,0x02,0x23,0x08,0x0c
	.ascii "TexGenEnabled\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x18,0x0c
	.ascii "GenModeS\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x1c,0x0c
	.ascii "GenModeT\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x20,0x0c
	.ascii "GenModeR\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x24,0x0c
	.ascii "GenModeQ\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x28,0x0c
	.ascii "ObjectPlaneS\0"
	.byte 0x00,0x00,0x90,0x2b,0x02,0x23,0x2c,0x0c
	.ascii "ObjectPlaneT\0"
	.byte 0x00,0x00,0x90,0x3c,0x02,0x23,0x3c,0x0c
	.ascii "ObjectPlaneR\0"
	.byte 0x00,0x00,0x90,0x4d,0x02,0x23,0x4c,0x0c
	.ascii "ObjectPlaneQ\0"
	.byte 0x00,0x00,0x90,0x5e,0x02,0x23,0x5c,0x0c
	.ascii "EyePlaneS\0"
	.byte 0x00,0x00,0x90,0x6f,0x02,0x23,0x6c,0x0c
	.ascii "EyePlaneT\0"
	.byte 0x00,0x00,0x90,0x80,0x02,0x23,0x7c,0x0c
	.ascii "EyePlaneR\0"
	.byte 0x00,0x00,0x90,0x91,0x03,0x23,0x8c,0x01
	.byte 0x0c
	.ascii "EyePlaneQ\0"
	.byte 0x00,0x00,0x90,0xa2,0x03,0x23,0x9c,0x01
	.byte 0x0c
	.ascii "Current1D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xac,0x01
	.byte 0x0c
	.ascii "Current2D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xb0,0x01
	.byte 0x0c
	.ascii "Current3D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xb4,0x01
	.byte 0x0c
	.ascii "Current\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xb8,0x01
	.byte 0x0c
	.ascii "Proxy1D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xbc,0x01
	.byte 0x0c
	.ascii "Proxy2D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xc0,0x01
	.byte 0x0c
	.ascii "Proxy3D\0"
	.byte 0x00,0x00,0x3b,0xa4,0x03,0x23,0xc4,0x01
	.byte 0x0c
	.ascii "SharedPalette\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0xc8,0x01
	.byte 0x0c
	.ascii "Palette\0"
	.byte 0x00,0x00,0x90,0xb3,0x03,0x23,0xc9,0x01
	.byte 0x0c
	.ascii "PaletteSize\0"
	.byte 0x00,0x00,0x31,0xcd,0x03,0x23,0xcc,0x09
	.byte 0x0c
	.ascii "PaletteIntFormat\0"
	.byte 0x00,0x00,0x31,0xb4,0x03,0x23,0xd0,0x09
	.byte 0x0c
	.ascii "PaletteFormat\0"
	.byte 0x00,0x00,0x31,0xb4,0x03,0x23,0xd4,0x09
	.byte 0x00,0x13,0x00,0x00,0x39,0x23,0x10,0x00
	.byte 0x00,0x93,0x06,0x14,0x00,0x00,0x39,0x3a
	.byte 0x03,0x00,0x13,0x00,0x00,0x92,0xf5,0x60
	.byte 0x00,0x00,0x93,0x17,0x14,0x00,0x00,0x39
	.byte 0x3a,0x05,0x00,0x13,0x00,0x00,0x39,0x77
	.byte 0x06,0x00,0x00,0x93,0x28,0x14,0x00,0x00
	.byte 0x39,0x3a,0x05,0x00,0x0b
	.ascii "gl_transform_attrib\0"
	.byte 0x6c,0x03,0x00,0x00,0x93,0xa2,0x0c
	.ascii "MatrixMode\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "ClipEquation\0"
	.byte 0x00,0x00,0x93,0x06,0x02,0x23,0x04,0x0c
	.ascii "ClipEnabled\0"
	.byte 0x00,0x00,0x93,0x17,0x02,0x23,0x64,0x0c
	.ascii "AnyClip\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x6a,0x0c
	.ascii "Normalize\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x6b,0x00
	.byte 0x0b
	.ascii "gl_viewport_attrib\0"
	.byte 0x30,0x03,0x00,0x00,0x94,0x49,0x0c
	.ascii "X\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "Y\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "Width\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x08,0x0c
	.ascii "Height\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x0c,0x0c
	.ascii "Near\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x10,0x0c
	.ascii "Far\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x14,0x0c
	.ascii "Sx\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x18,0x0c
	.ascii "Sy\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x1c,0x0c
	.ascii "Sz\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x20,0x0c
	.ascii "Tx\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x24,0x0c
	.ascii "Ty\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x28,0x0c
	.ascii "Tz\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x2c,0x00
	.byte 0x13,0x00,0x00,0x7b,0xe9,0x40,0x00,0x00
	.byte 0x94,0x5a,0x14,0x00,0x00,0x39,0x3a,0x0f
	.byte 0x00,0x0a,0x00,0x00,0x39,0x77,0x0b
	.ascii "gl_array_attrib\0"
	.byte 0x80,0x03,0x00,0x00,0x97,0x0a,0x0c
	.ascii "VertexSize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "VertexType\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x04,0x0c
	.ascii "VertexStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x08,0x0c
	.ascii "VertexStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x0c,0x0c
	.ascii "VertexPtr\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x10,0x0c
	.ascii "VertexEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x14,0x0c
	.ascii "NormalType\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x18,0x0c
	.ascii "NormalStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x1c,0x0c
	.ascii "NormalStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x20,0x0c
	.ascii "NormalPtr\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x24,0x0c
	.ascii "NormalEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x28,0x0c
	.ascii "ColorSize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x2c,0x0c
	.ascii "ColorType\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x30,0x0c
	.ascii "ColorStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x34,0x0c
	.ascii "ColorStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x38,0x0c
	.ascii "ColorPtr\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x3c,0x0c
	.ascii "ColorEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x40,0x0c
	.ascii "IndexType\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x44,0x0c
	.ascii "IndexStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x48,0x0c
	.ascii "IndexStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x4c,0x0c
	.ascii "IndexPtr\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x50,0x0c
	.ascii "IndexEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x54,0x0c
	.ascii "TexCoordSize\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x58,0x0c
	.ascii "TexCoordType\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x5c,0x0c
	.ascii "TexCoordStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x60,0x0c
	.ascii "TexCoordStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x64,0x0c
	.ascii "TexCoordPtr\0"
	.byte 0x00,0x00,0x32,0x06,0x02,0x23,0x68,0x0c
	.ascii "TexCoordEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x6c,0x0c
	.ascii "EdgeFlagStride\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x70,0x0c
	.ascii "EdgeFlagStrideB\0"
	.byte 0x00,0x00,0x8f,0x03,0x02,0x23,0x74,0x0c
	.ascii "EdgeFlagPtr\0"
	.byte 0x00,0x00,0x94,0x5a,0x02,0x23,0x78,0x0c
	.ascii "EdgeFlagEnabled\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x7c,0x00
	.byte 0x0b
	.ascii "gl_pixelstore_attrib\0"
	.byte 0x1c,0x03,0x00,0x00,0x97,0xb9,0x0c
	.ascii "Alignment\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x00,0x0c
	.ascii "RowLength\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x04,0x0c
	.ascii "SkipPixels\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x08,0x0c
	.ascii "SkipRows\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x0c,0x0c
	.ascii "ImageHeight\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x10,0x0c
	.ascii "SkipImages\0"
	.byte 0x00,0x00,0x01,0x5a,0x02,0x23,0x14,0x0c
	.ascii "SwapBytes\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x18,0x0c
	.ascii "LsbFirst\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x19,0x00
	.byte 0x0a,0x00,0x00,0x39,0x2c,0x0b
	.ascii "gl_1d_map\0"
	.byte 0x14,0x03,0x00,0x00,0x98,0x12,0x0c
	.ascii "Order\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x00,0x0c
	.ascii "u1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x04,0x0c
	.ascii "u2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x08,0x0c
	.ascii "Points\0"
	.byte 0x00,0x00,0x97,0xb9,0x02,0x23,0x0c,0x0c
	.ascii "Retain\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x10,0x00
	.byte 0x0b
	.ascii "gl_2d_map\0"
	.byte 0x20,0x03,0x00,0x00,0x98,0x8c,0x0c
	.ascii "Uorder\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x00,0x0c
	.ascii "Vorder\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x04,0x0c
	.ascii "u1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x08,0x0c
	.ascii "u2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x0c,0x0c
	.ascii "v1\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x10,0x0c
	.ascii "v2\0"
	.byte 0x00,0x00,0x39,0x2c,0x02,0x23,0x14,0x0c
	.ascii "Points\0"
	.byte 0x00,0x00,0x97,0xb9,0x02,0x23,0x18,0x0c
	.ascii "Retain\0"
	.byte 0x00,0x00,0x39,0x77,0x02,0x23,0x1c,0x00
	.byte 0x17
	.ascii "gl_evaluators\0"
	.byte 0x01,0xd4,0x03,0x00,0x00,0x9a,0x16,0x0c
	.ascii "Map1Vertex3\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x00,0x0c
	.ascii "Map1Vertex4\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x14,0x0c
	.ascii "Map1Index\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x28,0x0c
	.ascii "Map1Color4\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x3c,0x0c
	.ascii "Map1Normal\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x50,0x0c
	.ascii "Map1Texture1\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x64,0x0c
	.ascii "Map1Texture2\0"
	.byte 0x00,0x00,0x97,0xbe,0x02,0x23,0x78,0x0c
	.ascii "Map1Texture3\0"
	.byte 0x00,0x00,0x97,0xbe,0x03,0x23,0x8c,0x01
	.byte 0x0c
	.ascii "Map1Texture4\0"
	.byte 0x00,0x00,0x97,0xbe,0x03,0x23,0xa0,0x01
	.byte 0x0c
	.ascii "Map2Vertex3\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xb4,0x01
	.byte 0x0c
	.ascii "Map2Vertex4\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xd4,0x01
	.byte 0x0c
	.ascii "Map2Index\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xf4,0x01
	.byte 0x0c
	.ascii "Map2Color4\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0x94,0x02
	.byte 0x0c
	.ascii "Map2Normal\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xb4,0x02
	.byte 0x0c
	.ascii "Map2Texture1\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xd4,0x02
	.byte 0x0c
	.ascii "Map2Texture2\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xf4,0x02
	.byte 0x0c
	.ascii "Map2Texture3\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0x94,0x03
	.byte 0x0c
	.ascii "Map2Texture4\0"
	.byte 0x00,0x00,0x98,0x12,0x03,0x23,0xb4,0x03
	.byte 0x00,0x0b
	.ascii "gl_feedback\0"
	.byte 0x14,0x03,0x00,0x00,0x9a,0x74,0x0c
	.ascii "Type\0"
	.byte 0x00,0x00,0x31,0xb4,0x02,0x23,0x00,0x0c
	.ascii "Mask\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x04,0x0c
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x97,0xb9,0x02,0x23,0x08,0x0c
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x0c,0x0c
	.ascii "Count\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x10,0x00
	.byte 0x0a,0x00,0x00,0x31,0xcd,0x15,0x00,0x00
	.byte 0x31,0xcd,0x01,0x00,0x00,0x00,0x9a,0x8b
	.byte 0x14,0x00,0x00,0x39,0x3a,0x3f,0x00,0x17
	.ascii "gl_selection\0"
	.byte 0x01,0x20,0x03,0x00,0x00,0x9b,0x40,0x0c
	.ascii "Buffer\0"
	.byte 0x00,0x00,0x9a,0x74,0x02,0x23,0x00,0x0c
	.ascii "BufferSize\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x04,0x0c
	.ascii "BufferCount\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x08,0x0c
	.ascii "Hits\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x0c,0x0c
	.ascii "NameStackDepth\0"
	.byte 0x00,0x00,0x31,0xcd,0x02,0x23,0x10,0x0c
	.ascii "NameStack\0"
	.byte 0x00,0x00,0x9a,0x79,0x02,0x23,0x14,0x0c
	.ascii "HitFlag\0"
	.byte 0x00,0x00,0x39,0x77,0x03,0x23,0x94,0x02
	.byte 0x0c
	.ascii "HitMinZ\0"
	.byte 0x00,0x00,0x39,0x2c,0x03,0x23,0x98,0x02
	.byte 0x0c
	.ascii "HitMaxZ\0"
	.byte 0x00,0x00,0x39,0x2c,0x03,0x23,0x9c,0x02
	.byte 0x00,0x12
	.ascii "vertex_buffer\0"
	.byte 0x01,0x0a,0x00,0x00,0x9b,0x40,0x12
	.ascii "pixel_buffer\0"
	.byte 0x01,0x0a,0x00,0x00,0x9b,0x55,0x06,0x00
	.byte 0x00,0x3c,0x4a
	.ascii "GLcontext\0"
	.byte 0x03,0x0a,0x00,0x00,0x9b,0x69,0x18,0x00
	.byte 0x00,0x43,0xdf,0x0a,0x00,0x00,0x9b,0x7e
	.byte 0x0f
	.ascii "make_null_texture\0"
	.byte 0x03,0x01,0x03,0x1f
	.uaword make_null_texture
	.uaword .L1091
	.byte 0x01,0x6e,0x01,0x00,0x00,0x33,0x14,0x01
	.byte 0x00,0x00,0x9d,0x5a,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x03,0x1d,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalFormat\0"
	.byte 0x01,0x03,0x1d,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x03,0x1e,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x03,0x1e,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "depth\0"
	.byte 0x01,0x03,0x1e,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x03,0x1e,0x03,0x91,0xd8,0x00,0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x20
	.byte 0x02,0x91,0x78,0x10
	.ascii "texImage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x03,0x21
	.byte 0x02,0x91,0x74,0x10
	.ascii "numPixels\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x22
	.byte 0x02,0x91,0x70,0x11
	.uaword .L1031
	.uaword .L1088
	.byte 0x11
	.uaword .L1035
	.uaword .L1087
	.byte 0x11
	.uaword .L1036
	.uaword .L1086
	.byte 0x10
	.ascii "message\0"
	.byte 0x00,0x00,0x9d,0x6b,0x01,0x01,0x03,0x4b
	.byte 0x03,0x91,0xec,0x7d,0x10
	.ascii "imgPtr\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x03,0x56
	.byte 0x03,0x91,0xe8,0x7d,0x10
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x57
	.byte 0x03,0x91,0xe4,0x7d,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x57
	.byte 0x03,0x91,0xe0,0x7d,0x10
	.ascii "k\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x57
	.byte 0x03,0x91,0xdc,0x7d,0x11
	.uaword .L1040
	.uaword .L1085
	.byte 0x11
	.uaword .L1046
	.uaword .L1082
	.byte 0x11
	.uaword .L1047
	.uaword .L1081
	.byte 0x10
	.ascii "srcRow\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x59
	.byte 0x03,0x91,0xd8,0x7d,0x11
	.uaword .L1049
	.uaword .L1080
	.byte 0x11
	.uaword .L1055
	.uaword .L1077
	.byte 0x11
	.uaword .L1056
	.uaword .L1076
	.byte 0x10
	.ascii "srcCol\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x5b
	.byte 0x03,0x91,0xd4,0x7d,0x10
	.ascii "texel\0"
	.byte 0x00,0x00,0x31,0xeb,0x01,0x01,0x03,0x5c
	.byte 0x03,0x91,0xd3,0x7d,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x1d,0x43,0x01
	.byte 0x00,0x00,0x13,0x00,0x00,0x6d,0x96,0x20
	.byte 0x00,0x00,0x9d,0x6b,0x14,0x00,0x00,0x39
	.byte 0x3a,0x1f,0x00,0x15,0x00,0x00,0x9d,0x5a
	.byte 0x01,0x00,0x00,0x00,0x9d,0x7d,0x14,0x00
	.byte 0x00,0x39,0x3a,0x07,0x00,0x0f
	.ascii "texture_1d_error_check\0"
	.byte 0x03,0x01,0x03,0x72
	.uaword texture_1d_error_check
	.uaword .L1242
	.byte 0x01,0x6e,0x01,0x00,0x00,0x39,0x77,0x01
	.byte 0x00,0x00,0x9e,0x5b,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x03,0x6e,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x03,0x6e,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x03,0x6f,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalFormat\0"
	.byte 0x01,0x03,0x6f,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x03,0x70,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "width\0"
	.byte 0x01,0x03,0x71,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x03,0x71,0x03,0x91,0xe0,0x00,0x10
	.ascii "iformat\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0x73
	.byte 0x02,0x91,0x78,0x00,0x0f
	.ascii "texture_2d_error_check\0"
	.byte 0x03,0x01,0x03,0xbb
	.uaword texture_2d_error_check
	.uaword .L1430
	.byte 0x01,0x6e,0x01,0x00,0x00,0x39,0x77,0x01
	.byte 0x00,0x00,0x9f,0x4c,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x03,0xb6,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x03,0xb6,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x03,0xb7,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalFormat\0"
	.byte 0x01,0x03,0xb7,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x03,0xb8,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x03,0xb8,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "width\0"
	.byte 0x01,0x03,0xb9,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "height\0"
	.byte 0x01,0x03,0xb9,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x03,0xba,0x03,0x91,0xe4,0x00,0x10
	.ascii "iformat\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x03,0xbc
	.byte 0x02,0x91,0x78,0x00,0x0f
	.ascii "texture_3d_error_check\0"
	.byte 0x03,0x01,0x04,0x11
	.uaword texture_3d_error_check
	.uaword .L1653
	.byte 0x01,0x6e,0x01,0x00,0x00,0x39,0x77,0x01
	.byte 0x00,0x00,0xa0,0x4f,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x04,0x0c,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x04,0x0c,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x04,0x0d,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalFormat\0"
	.byte 0x01,0x04,0x0d,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x04,0x0e,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x04,0x0e,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "width\0"
	.byte 0x01,0x04,0x0f,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "height\0"
	.byte 0x01,0x04,0x0f,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "depth\0"
	.byte 0x01,0x04,0x10,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x04,0x10,0x03,0x91,0xe8,0x00,0x10
	.ascii "iformat\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x04,0x12
	.byte 0x02,0x91,0x78,0x00,0x0d
	.ascii "gl_TexImage1D\0"
	.byte 0x01,0x02,0x01,0x04,0x71
	.uaword gl_TexImage1D
	.uaword .L1800
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa1,0x52
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x04,0x6d,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x04,0x6e,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x04,0x6e,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "internalformat\0"
	.byte 0x01,0x04,0x6e,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x04,0x6f,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x04,0x6f,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x04,0x6f,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x04,0x70,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x04,0x70,0x03,0x91,0xe4,0x00,0x11
	.uaword .L1671
	.uaword .L1798
	.byte 0x11
	.uaword .L1675
	.uaword .L1738
	.byte 0x11
	.uaword .L1676
	.uaword .L1737
	.byte 0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x04,0x78
	.byte 0x02,0x91,0x7c,0x00,0x00,0x00,0x00,0x0d
	.ascii "gl_TexImage2D\0"
	.byte 0x01,0x02,0x01,0x04,0xc5
	.uaword gl_TexImage2D
	.uaword .L1947
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa2,0x68
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x04,0xc0,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x04,0xc1,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x04,0xc1,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "internalformat\0"
	.byte 0x01,0x04,0xc1,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x04,0xc2,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x04,0xc2,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x04,0xc2,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x04,0xc3,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x04,0xc3,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x04,0xc4,0x03,0x91,0xe8,0x00,0x11
	.uaword .L1818
	.uaword .L1945
	.byte 0x11
	.uaword .L1822
	.uaword .L1885
	.byte 0x11
	.uaword .L1823
	.uaword .L1884
	.byte 0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x04,0xcc
	.byte 0x02,0x91,0x7c,0x00,0x00,0x00,0x00,0x0d
	.ascii "gl_TexImage3DEXT\0"
	.byte 0x01,0x02,0x01,0x05,0x18
	.uaword gl_TexImage3DEXT
	.uaword .L2095
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa3,0x93
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x05,0x13,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x05,0x14,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x05,0x14,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "internalformat\0"
	.byte 0x01,0x05,0x14,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x05,0x15,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x05,0x15,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "depth\0"
	.byte 0x01,0x05,0x15,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x05,0x16,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x05,0x16,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x05,0x16,0x03,0x91,0xe8,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x05,0x17,0x03,0x91,0xec,0x00,0x11
	.uaword .L1965
	.uaword .L2093
	.byte 0x11
	.uaword .L1969
	.uaword .L2032
	.byte 0x11
	.uaword .L1970
	.uaword .L2031
	.byte 0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x05,0x1f
	.byte 0x02,0x91,0x7c,0x00,0x00,0x00,0x00,0x0d
	.ascii "gl_GetTexImage\0"
	.byte 0x01,0x02,0x01,0x05,0x67
	.uaword gl_GetTexImage
	.uaword .L2104
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa4,0x25
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x05,0x65,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x05,0x65,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x05,0x65,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x05,0x65,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x05,0x66,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x43,0xda
	.ascii "pixels\0"
	.byte 0x01,0x05,0x66,0x03,0x91,0xd8,0x00,0x00
	.byte 0x1e
	.ascii "gl_unpack_texsubimage\0"
	.byte 0x01,0x02,0x01,0x05,0x77
	.uaword gl_unpack_texsubimage
	.uaword .L2145
	.byte 0x01,0x6e,0x01,0x00,0x00,0x47,0x70,0x01
	.byte 0x00,0x00,0xa4,0xd4,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x05,0x75,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "width\0"
	.byte 0x01,0x05,0x75,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "height\0"
	.byte 0x01,0x05,0x75,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "depth\0"
	.byte 0x01,0x05,0x75,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x05,0x76,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x05,0x76,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0xa4,0xd9
	.ascii "pixels\0"
	.byte 0x01,0x05,0x76,0x03,0x91,0xdc,0x00,0x00
	.byte 0x18,0x00,0x00,0x43,0xcd,0x0a,0x00,0x00
	.byte 0xa4,0xd4,0x0d
	.ascii "gl_TexSubImage1D\0"
	.byte 0x01,0x02,0x01,0x05,0x8d
	.uaword gl_TexSubImage1D
	.uaword .L2330
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa6,0xa7
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x05,0x89,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x05,0x8a,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x05,0x8a,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x05,0x8a,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x05,0x8b,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x05,0x8b,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x05,0x8b,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x05,0x8c,0x03,0x91,0xe0,0x00,0x10
	.ascii "destTex\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x05,0x8e
	.byte 0x02,0x91,0x7c,0x11
	.uaword .L2214
	.uaword .L2328
	.byte 0x11
	.uaword .L2218
	.uaword .L2266
	.byte 0x11
	.uaword .L2219
	.uaword .L2265
	.byte 0x10
	.ascii "texcomponents\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x05,0xaa
	.byte 0x02,0x91,0x78,0x11
	.uaword .L2221
	.uaword .L2243
	.byte 0x11
	.uaword .L2226
	.uaword .L2232
	.byte 0x11
	.uaword .L2227
	.uaword .L2231
	.byte 0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x05,0xaf
	.byte 0x02,0x91,0x74,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x05,0xb0
	.byte 0x02,0x91,0x70,0x00,0x00,0x11
	.uaword .L2234
	.uaword .L2242
	.byte 0x11
	.uaword .L2235
	.uaword .L2241
	.byte 0x10
	.ascii "subTexImg\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x05,0xb5
	.byte 0x02,0x91,0x74,0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x05,0xb7
	.byte 0x02,0x91,0x70,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x05,0xb8
	.byte 0x02,0x91,0x6c,0x00,0x00,0x00,0x00,0x00
	.byte 0x11
	.uaword .L2268
	.uaword .L2327
	.byte 0x11
	.uaword .L2269
	.uaword .L2326
	.byte 0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x05,0xce
	.byte 0x02,0x91,0x78,0x10
	.ascii "size\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x05,0xce
	.byte 0x02,0x91,0x74,0x00,0x00,0x00,0x00,0x0d
	.ascii "gl_TexSubImage2D\0"
	.byte 0x01,0x02,0x01,0x05,0xf0
	.uaword gl_TexSubImage2D
	.uaword .L2581
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xa8,0xb3
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x05,0xea,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x05,0xeb,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x05,0xeb,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x05,0xec,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "yoffset\0"
	.byte 0x01,0x05,0xec,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x05,0xed,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x05,0xed,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x05,0xee,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x05,0xee,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x05,0xef,0x03,0x91,0xe8,0x00,0x10
	.ascii "destTex\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x05,0xf1
	.byte 0x02,0x91,0x7c,0x11
	.uaword .L2423
	.uaword .L2579
	.byte 0x11
	.uaword .L2427
	.uaword .L2505
	.byte 0x11
	.uaword .L2428
	.uaword .L2504
	.byte 0x10
	.ascii "texcomponents\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x15
	.byte 0x02,0x91,0x78,0x11
	.uaword .L2430
	.uaword .L2482
	.byte 0x11
	.uaword .L2435
	.uaword .L2456
	.byte 0x11
	.uaword .L2436
	.uaword .L2455
	.byte 0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0x1a
	.byte 0x02,0x91,0x74,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0x1c
	.byte 0x02,0x91,0x70,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x1d
	.byte 0x02,0x91,0x6c,0x00,0x00,0x11
	.uaword .L2458
	.uaword .L2481
	.byte 0x11
	.uaword .L2459
	.uaword .L2480
	.byte 0x10
	.ascii "subTexImg\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x06,0x26
	.byte 0x02,0x91,0x74,0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0x28
	.byte 0x02,0x91,0x70,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0x2a
	.byte 0x02,0x91,0x6c,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x2b
	.byte 0x02,0x91,0x68,0x00,0x00,0x00,0x00,0x00
	.byte 0x11
	.uaword .L2507
	.uaword .L2578
	.byte 0x11
	.uaword .L2508
	.uaword .L2577
	.byte 0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x44
	.byte 0x02,0x91,0x78,0x10
	.ascii "size\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x44
	.byte 0x02,0x91,0x74,0x00,0x00,0x00,0x00,0x0d
	.ascii "gl_TexSubImage3DEXT\0"
	.byte 0x01,0x02,0x01,0x06,0x6a
	.uaword gl_TexSubImage3DEXT
	.uaword .L2900
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xab,0x34
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x06,0x64,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x06,0x65,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x06,0x65,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x06,0x66,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "yoffset\0"
	.byte 0x01,0x06,0x66,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "zoffset\0"
	.byte 0x01,0x06,0x66,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x06,0x67,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x06,0x67,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "depth\0"
	.byte 0x01,0x06,0x67,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "format\0"
	.byte 0x01,0x06,0x68,0x03,0x91,0xe8,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "type\0"
	.byte 0x01,0x06,0x68,0x03,0x91,0xec,0x00,0x0e
	.byte 0x00,0x00,0x47,0x70
	.ascii "image\0"
	.byte 0x01,0x06,0x69,0x03,0x91,0xf0,0x00,0x10
	.ascii "destTex\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x06,0x6b
	.byte 0x02,0x91,0x7c,0x11
	.uaword .L2698
	.uaword .L2898
	.byte 0x11
	.uaword .L2702
	.uaword .L2812
	.byte 0x11
	.uaword .L2703
	.uaword .L2811
	.byte 0x10
	.ascii "texcomponents\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x97
	.byte 0x02,0x91,0x78,0x10
	.ascii "dstRectArea\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x98
	.byte 0x02,0x91,0x74,0x10
	.ascii "srcRectArea\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0x99
	.byte 0x02,0x91,0x70,0x11
	.uaword .L2707
	.uaword .L2789
	.byte 0x11
	.uaword .L2712
	.uaword .L2748
	.byte 0x11
	.uaword .L2713
	.uaword .L2747
	.byte 0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0x9e
	.byte 0x02,0x91,0x6c,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0xa1
	.byte 0x02,0x91,0x68,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xa2
	.byte 0x02,0x91,0x64,0x10
	.ascii "k\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xa2
	.byte 0x02,0x91,0x60,0x00,0x00,0x11
	.uaword .L2750
	.uaword .L2788
	.byte 0x11
	.uaword .L2751
	.uaword .L2787
	.byte 0x10
	.ascii "subTexImg\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x06,0xaf
	.byte 0x02,0x91,0x6c,0x10
	.ascii "dst\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0xb1
	.byte 0x02,0x91,0x68,0x10
	.ascii "src\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x06,0xb4
	.byte 0x02,0x91,0x64,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xb5
	.byte 0x02,0x91,0x60,0x10
	.ascii "k\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xb5
	.byte 0x02,0x91,0x5c,0x00,0x00,0x00,0x00,0x00
	.byte 0x11
	.uaword .L2814
	.uaword .L2897
	.byte 0x11
	.uaword .L2815
	.uaword .L2896
	.byte 0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xd2
	.byte 0x02,0x91,0x78,0x10
	.ascii "size\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x06,0xd2
	.byte 0x02,0x91,0x74,0x00,0x00,0x00,0x00,0x0f
	.ascii "read_color_image\0"
	.byte 0x03,0x01,0x07,0x01
	.uaword read_color_image
	.uaword .L3104
	.byte 0x01,0x6e,0x01,0x00,0x00,0x47,0x70,0x01
	.byte 0x00,0x00,0xac,0xf0,0x0e,0x00,0x00,0x9b
	.byte 0x79
	.ascii "ctx\0"
	.byte 0x01,0x06,0xfe,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x06,0xfe,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x06,0xfe,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x06,0xff,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x06,0xff,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "format\0"
	.byte 0x01,0x07,0x00,0x03,0x91,0xd8,0x00,0x10
	.ascii "image\0"
	.byte 0x00,0x00,0x47,0x70,0x01,0x01,0x07,0x02
	.byte 0x02,0x91,0x78,0x10
	.ascii "imgptr\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x07,0x03
	.byte 0x02,0x91,0x74,0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0x04
	.byte 0x02,0x91,0x70,0x10
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0x05
	.byte 0x02,0x91,0x6c,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0x05
	.byte 0x02,0x91,0x68,0x11
	.uaword .L2944
	.uaword .L3100
	.byte 0x11
	.uaword .L2950
	.uaword .L3097
	.byte 0x11
	.uaword .L2951
	.uaword .L3096
	.byte 0x10
	.ascii "red\0"
	.byte 0x00,0x00,0xac,0xf0,0x01,0x01,0x07,0x25
	.byte 0x03,0x91,0xa8,0x73,0x10
	.ascii "green\0"
	.byte 0x00,0x00,0xad,0x03,0x01,0x01,0x07,0x25
	.byte 0x03,0x91,0xe8,0x66,0x10
	.ascii "blue\0"
	.byte 0x00,0x00,0xad,0x16,0x01,0x01,0x07,0x26
	.byte 0x03,0x91,0xa8,0x5a,0x10
	.ascii "alpha\0"
	.byte 0x00,0x00,0xad,0x29,0x01,0x01,0x07,0x26
	.byte 0x03,0x91,0xe8,0x4d,0x11
	.uaword .L2953
	.uaword .L2982
	.byte 0x11
	.uaword .L2957
	.uaword .L2981
	.byte 0x11
	.uaword .L2958
	.uaword .L2980
	.byte 0x10
	.ascii "rscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0x2b
	.byte 0x03,0x91,0xe4,0x4d,0x10
	.ascii "gscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0x2c
	.byte 0x03,0x91,0xe0,0x4d,0x10
	.ascii "bscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0x2d
	.byte 0x03,0x91,0xdc,0x4d,0x10
	.ascii "ascale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0x2e
	.byte 0x03,0x91,0xd8,0x4d,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x15,0x00,0x00,0x31,0xeb
	.byte 0x06,0x40,0x00,0x00,0xad,0x03,0x16,0x00
	.byte 0x00,0x39,0x3a,0x06,0x3f,0x00,0x15,0x00
	.byte 0x00,0x31,0xeb,0x06,0x40,0x00,0x00,0xad
	.byte 0x16,0x16,0x00,0x00,0x39,0x3a,0x06,0x3f
	.byte 0x00,0x15,0x00,0x00,0x31,0xeb,0x06,0x40
	.byte 0x00,0x00,0xad,0x29,0x16,0x00,0x00,0x39
	.byte 0x3a,0x06,0x3f,0x00,0x15,0x00,0x00,0x31
	.byte 0xeb,0x06,0x40,0x00,0x00,0xad,0x3c,0x16
	.byte 0x00,0x00,0x39,0x3a,0x06,0x3f,0x00,0x0d
	.ascii "gl_CopyTexImage1D\0"
	.byte 0x01,0x02,0x01,0x07,0x6e
	.uaword gl_CopyTexImage1D
	.uaword .L3207
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xae,0x1e
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x07,0x69,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x07,0x6a,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x07,0x6a,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalformat\0"
	.byte 0x01,0x07,0x6b,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x07,0x6c,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x07,0x6c,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x07,0x6d,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x07,0x6d,0x03,0x91,0xe0,0x00,0x10
	.ascii "format\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0x6f
	.byte 0x02,0x91,0x7c,0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x47,0x70,0x01,0x01,0x07,0x70
	.byte 0x02,0x91,0x78,0x00,0x0d
	.ascii "gl_CopyTexImage2D\0"
	.byte 0x01,0x02,0x01,0x07,0x9e
	.uaword gl_CopyTexImage2D
	.uaword .L3325
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xaf,0x13
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x07,0x9a,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x07,0x9b,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x07,0x9b,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "internalformat\0"
	.byte 0x01,0x07,0x9b,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x07,0x9c,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x07,0x9c,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x07,0x9c,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x07,0x9c,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "border\0"
	.byte 0x01,0x07,0x9d,0x03,0x91,0xe4,0x00,0x10
	.ascii "format\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0x9f
	.byte 0x02,0x91,0x7c,0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x47,0x70,0x01,0x01,0x07,0xa0
	.byte 0x02,0x91,0x78,0x00,0x1f
	.ascii "copy_tex_sub_image\0"
	.byte 0x03,0x01,0x07,0xd7
	.uaword copy_tex_sub_image
	.uaword .L3494
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xb1,0x1e
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x07,0xd3,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x33,0x14
	.ascii "dest\0"
	.byte 0x01,0x07,0xd3,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "width\0"
	.byte 0x01,0x07,0xd4,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "height\0"
	.byte 0x01,0x07,0xd4,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "srcx\0"
	.byte 0x01,0x07,0xd5,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "srcy\0"
	.byte 0x01,0x07,0xd5,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "dstx\0"
	.byte 0x01,0x07,0xd6,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "dsty\0"
	.byte 0x01,0x07,0xd6,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "zoffset\0"
	.byte 0x01,0x07,0xd6,0x03,0x91,0xe4,0x00,0x10
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0xd8
	.byte 0x02,0x91,0x7c,0x10
	.ascii "j\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0xd8
	.byte 0x02,0x91,0x78,0x10
	.ascii "format\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0xd9
	.byte 0x02,0x91,0x74,0x10
	.ascii "components\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0xd9
	.byte 0x02,0x91,0x70,0x10
	.ascii "rectarea\0"
	.byte 0x00,0x00,0x01,0x5a,0x01,0x01,0x07,0xd9
	.byte 0x02,0x91,0x6c,0x11
	.uaword .L3335
	.uaword .L3492
	.byte 0x11
	.uaword .L3341
	.uaword .L3489
	.byte 0x11
	.uaword .L3342
	.uaword .L3488
	.byte 0x10
	.ascii "red\0"
	.byte 0x00,0x00,0xb1,0x1e,0x01,0x01,0x07,0xe1
	.byte 0x03,0x91,0xac,0x73,0x10
	.ascii "green\0"
	.byte 0x00,0x00,0xb1,0x31,0x01,0x01,0x07,0xe1
	.byte 0x03,0x91,0xec,0x66,0x10
	.ascii "blue\0"
	.byte 0x00,0x00,0xb1,0x44,0x01,0x01,0x07,0xe2
	.byte 0x03,0x91,0xac,0x5a,0x10
	.ascii "alpha\0"
	.byte 0x00,0x00,0xb1,0x57,0x01,0x01,0x07,0xe2
	.byte 0x03,0x91,0xec,0x4d,0x10
	.ascii "texptr\0"
	.byte 0x00,0x00,0x31,0xf9,0x01,0x01,0x07,0xe3
	.byte 0x03,0x91,0xe8,0x4d,0x11
	.uaword .L3344
	.uaword .L3373
	.byte 0x11
	.uaword .L3348
	.uaword .L3372
	.byte 0x11
	.uaword .L3349
	.uaword .L3371
	.byte 0x10
	.ascii "rscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0xe9
	.byte 0x03,0x91,0xe4,0x4d,0x10
	.ascii "gscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0xea
	.byte 0x03,0x91,0xe0,0x4d,0x10
	.ascii "bscale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0xeb
	.byte 0x03,0x91,0xdc,0x4d,0x10
	.ascii "ascale\0"
	.byte 0x00,0x00,0x39,0x2c,0x01,0x01,0x07,0xec
	.byte 0x03,0x91,0xd8,0x4d,0x00,0x00,0x00,0x00
	.byte 0x00,0x00,0x00,0x15,0x00,0x00,0x31,0xeb
	.byte 0x06,0x40,0x00,0x00,0xb1,0x31,0x16,0x00
	.byte 0x00,0x39,0x3a,0x06,0x3f,0x00,0x15,0x00
	.byte 0x00,0x31,0xeb,0x06,0x40,0x00,0x00,0xb1
	.byte 0x44,0x16,0x00,0x00,0x39,0x3a,0x06,0x3f
	.byte 0x00,0x15,0x00,0x00,0x31,0xeb,0x06,0x40
	.byte 0x00,0x00,0xb1,0x57,0x16,0x00,0x00,0x39
	.byte 0x3a,0x06,0x3f,0x00,0x15,0x00,0x00,0x31
	.byte 0xeb,0x06,0x40,0x00,0x00,0xb1,0x6a,0x16
	.byte 0x00,0x00,0x39,0x3a,0x06,0x3f,0x00,0x0d
	.ascii "gl_CopyTexSubImage1D\0"
	.byte 0x01,0x02,0x01,0x08,0x26
	.uaword gl_CopyTexSubImage1D
	.uaword .L3602
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xb2,0x22
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x08,0x23,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x08,0x24,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x08,0x24,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x08,0x25,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x08,0x25,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x08,0x25,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x08,0x25,0x03,0x91,0xdc,0x00,0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x08,0x27
	.byte 0x02,0x91,0x7c,0x00,0x0d
	.ascii "gl_CopyTexSubImage2D\0"
	.byte 0x01,0x02,0x01,0x08,0x56
	.uaword gl_CopyTexSubImage2D
	.uaword .L3746
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xb3,0x01
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x08,0x52,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x08,0x53,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x08,0x53,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x08,0x54,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "yoffset\0"
	.byte 0x01,0x08,0x54,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x08,0x55,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x08,0x55,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x08,0x55,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x08,0x55,0x03,0x91,0xe4,0x00,0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x08,0x57
	.byte 0x02,0x91,0x7c,0x00,0x0d
	.ascii "gl_CopyTexSubImage3DEXT\0"
	.byte 0x01,0x02,0x01,0x08,0x95
	.uaword gl_CopyTexSubImage3DEXT
	.uaword .L3914
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0xb3,0xf7
	.byte 0x0e,0x00,0x00,0x9b,0x79
	.ascii "ctx\0"
	.byte 0x01,0x08,0x91,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x31,0xb4
	.ascii "target\0"
	.byte 0x01,0x08,0x92,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "level\0"
	.byte 0x01,0x08,0x92,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "xoffset\0"
	.byte 0x01,0x08,0x93,0x03,0x91,0xd0,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "yoffset\0"
	.byte 0x01,0x08,0x93,0x03,0x91,0xd4,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "zoffset\0"
	.byte 0x01,0x08,0x93,0x03,0x91,0xd8,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "x\0"
	.byte 0x01,0x08,0x94,0x03,0x91,0xdc,0x00,0x0e
	.byte 0x00,0x00,0x01,0x5a
	.ascii "y\0"
	.byte 0x01,0x08,0x94,0x03,0x91,0xe0,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "width\0"
	.byte 0x01,0x08,0x94,0x03,0x91,0xe4,0x00,0x0e
	.byte 0x00,0x00,0x8f,0x03
	.ascii "height\0"
	.byte 0x01,0x08,0x94,0x03,0x91,0xe8,0x00,0x10
	.ascii "teximage\0"
	.byte 0x00,0x00,0x33,0x14,0x01,0x01,0x08,0x96
	.byte 0x02,0x91,0x7c,0x00,0x20
	.ascii "gl_read_color_span\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xb4,0x3c
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x31,0xc1,0x1a,0x00,0x00,0x01,0x53,0x1a
	.byte 0x00,0x00,0x01,0x53,0x1a,0x00,0x00,0x3b
	.byte 0x48,0x1a,0x00,0x00,0x3b,0x48,0x1a,0x00
	.byte 0x00,0x3b,0x48,0x1a,0x00,0x00,0x3b,0x48
	.byte 0x00,0x20
	.ascii "gl_free_image\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xb4,0x59
	.byte 0x1a,0x00,0x00,0x47,0x70,0x00,0x18,0x00
	.byte 0x00,0x31,0xfe,0x0a,0x00,0x00,0xb4,0x59
	.byte 0x21
	.ascii "gl_unpack_image3D\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x47,0x70,0x01
	.byte 0x00,0x00,0xb4,0xa6,0x1a,0x00,0x00,0x43
	.byte 0x17,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x01,0x53,0x1a,0x00,0x00,0x01,0x53
	.byte 0x1a,0x00,0x00,0x02,0x18,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0xb4,0x5e,0x00
	.byte 0x21
	.ascii "gl_components_in_format\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x5a,0x01
	.byte 0x00,0x00,0xb4,0xd1,0x1a,0x00,0x00,0x02
	.byte 0x18,0x00,0x21
	.ascii "gl_sizeof_type\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x5a,0x01
	.byte 0x00,0x00,0xb4,0xf3,0x1a,0x00,0x00,0x02
	.byte 0x18,0x00,0x18,0x00,0x00,0x6d,0x96,0x0a
	.byte 0x00,0x00,0xb4,0xf3,0x20
	.ascii "gl_error\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xb5,0x1f
	.byte 0x1a,0x00,0x00,0x43,0x17,0x1a,0x00,0x00
	.byte 0x02,0x18,0x1a,0x00,0x00,0xb4,0xf8,0x00
	.byte 0x18,0x00,0x00,0x3c,0x4a,0x0a,0x00,0x00
	.byte 0xb5,0x1f,0x18,0x00,0x00,0x6d,0x96,0x0a
	.byte 0x00,0x00,0xb5,0x29,0x20
	.ascii "gl_problem\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xb5,0x52
	.byte 0x1a,0x00,0x00,0xb5,0x24,0x1a,0x00,0x00
	.byte 0xb5,0x2e,0x00,0x21
	.ascii "memset\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x32,0x06,0x01
	.byte 0x00,0x00,0xb5,0x76,0x1a,0x00,0x00,0x32
	.byte 0x06,0x1a,0x00,0x00,0x01,0x53,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x18,0x00,0x00,0x31
	.byte 0xfe,0x0a,0x00,0x00,0xb5,0x76,0x21
	.ascii "memcpy\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x32,0x06,0x01
	.byte 0x00,0x00,0xb5,0xa4,0x1a,0x00,0x00,0x32
	.byte 0x06,0x1a,0x00,0x00,0xb5,0x7b,0x1a,0x00
	.byte 0x00,0x31,0xc1,0x00,0x21
	.ascii "malloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x32,0x06,0x01
	.byte 0x00,0x00,0xb5,0xbe,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x00,0x20
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0xb5,0xd2
	.byte 0x1a,0x00,0x00,0x32,0x06,0x00,0x21
	.ascii "calloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x32,0x06,0x01
	.byte 0x00,0x00,0xb5,0xf1,0x1a,0x00,0x00,0x31
	.byte 0xc1,0x1a,0x00,0x00,0x31,0xc1,0x00,0x18
	.byte 0x00,0x00,0x6d,0x96,0x0a,0x00,0x00,0xb5
	.byte 0xf1,0x18,0x00,0x00,0x6d,0x96,0x0a,0x00
	.byte 0x00,0xb5,0xfb,0x22
	.ascii "__assert\0"
	.byte 0x01,0x01,0x01,0x01,0x1a,0x00,0x00,0xb5
	.byte 0xf6,0x1a,0x00,0x00,0xb6,0x00,0x1a,0x00
	.byte 0x00,0x01,0x53,0x00,0x00,0x00,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=128, siz=4, lab1=logbase2, lab2=, loff=0
!   reloc[1]: knd=0, off=135, siz=4, lab1=.L16, lab2=, loff=0
!   reloc[2]: knd=0, off=147, siz=4, lab1=.L17, lab2=, loff=0
!   reloc[3]: knd=0, off=155, siz=4, lab1=.L20, lab2=, loff=0
!   reloc[4]: knd=0, off=163, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[5]: knd=0, off=171, siz=4, lab1=.L32, lab2=, loff=0
!   reloc[6]: knd=0, off=181, siz=4, lab1=.L36, lab2=, loff=0
!   reloc[7]: knd=0, off=189, siz=4, lab1=.L37, lab2=, loff=0
!   reloc[8]: knd=0, off=197, siz=4, lab1=.L40, lab2=, loff=0
!   reloc[9]: knd=0, off=207, siz=4, lab1=.L45, lab2=, loff=0
!   reloc[10]: knd=0, off=217, siz=4, lab1=.L49, lab2=, loff=0
!   reloc[11]: knd=0, off=225, siz=4, lab1=.L54, lab2=, loff=0
!   reloc[12]: knd=0, off=235, siz=4, lab1=.L58, lab2=, loff=0
!   reloc[13]: knd=0, off=248, siz=4, lab1=decode_internal_format, lab2=, loff=0
!   reloc[14]: knd=0, off=255, siz=4, lab1=.L68, lab2=, loff=0
!   reloc[15]: knd=0, off=267, siz=4, lab1=.L76, lab2=, loff=0
!   reloc[16]: knd=0, off=277, siz=4, lab1=.L83, lab2=, loff=0
!   reloc[17]: knd=0, off=287, siz=4, lab1=.L92, lab2=, loff=0
!   reloc[18]: knd=0, off=297, siz=4, lab1=.L98, lab2=, loff=0
!   reloc[19]: knd=0, off=307, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[20]: knd=0, off=317, siz=4, lab1=.L118, lab2=, loff=0
!   reloc[21]: knd=0, off=327, siz=4, lab1=.L125, lab2=, loff=0
!   reloc[22]: knd=0, off=337, siz=4, lab1=.L127, lab2=, loff=0
!   reloc[23]: knd=0, off=345, siz=4, lab1=.L130, lab2=, loff=0
!   reloc[24]: knd=0, off=355, siz=4, lab1=.L133, lab2=, loff=0
!   reloc[25]: knd=0, off=370, siz=4, lab1=components_in_intformat, lab2=, loff=0
!   reloc[26]: knd=0, off=377, siz=4, lab1=.L143, lab2=, loff=0
!   reloc[27]: knd=0, off=389, siz=4, lab1=.L151, lab2=, loff=0
!   reloc[28]: knd=0, off=399, siz=4, lab1=.L158, lab2=, loff=0
!   reloc[29]: knd=0, off=409, siz=4, lab1=.L167, lab2=, loff=0
!   reloc[30]: knd=0, off=419, siz=4, lab1=.L173, lab2=, loff=0
!   reloc[31]: knd=0, off=429, siz=4, lab1=.L183, lab2=, loff=0
!   reloc[32]: knd=0, off=439, siz=4, lab1=.L193, lab2=, loff=0
!   reloc[33]: knd=0, off=449, siz=4, lab1=.L200, lab2=, loff=0
!   reloc[34]: knd=0, off=459, siz=4, lab1=.L202, lab2=, loff=0
!   reloc[35]: knd=0, off=467, siz=4, lab1=.L205, lab2=, loff=0
!   reloc[36]: knd=0, off=477, siz=4, lab1=.L208, lab2=, loff=0
!   reloc[37]: knd=0, off=492, siz=4, lab1=gl_alloc_texture_image, lab2=, loff=0
!   reloc[38]: knd=0, off=499, siz=4, lab1=.L215, lab2=, loff=0
!   reloc[39]: knd=0, off=511, siz=4, lab1=.L216, lab2=, loff=0
!   reloc[40]: knd=0, off=524, siz=4, lab1=gl_free_texture_image, lab2=, loff=0
!   reloc[41]: knd=0, off=531, siz=4, lab1=.L225, lab2=, loff=0
!   reloc[42]: knd=0, off=543, siz=4, lab1=.L229, lab2=, loff=0
!   reloc[43]: knd=0, off=551, siz=4, lab1=.L233, lab2=, loff=0
!   reloc[44]: knd=0, off=559, siz=4, lab1=.L234, lab2=, loff=0
!   reloc[45]: knd=0, off=572, siz=4, lab1=image_to_texture, lab2=, loff=0
!   reloc[46]: knd=0, off=579, siz=4, lab1=.L241, lab2=, loff=0
!   reloc[47]: knd=0, off=591, siz=4, lab1=.L248, lab2=, loff=0
!   reloc[48]: knd=0, off=599, siz=4, lab1=.L255, lab2=, loff=0
!   reloc[49]: knd=0, off=607, siz=4, lab1=.L262, lab2=, loff=0
!   reloc[50]: knd=0, off=615, siz=4, lab1=.L269, lab2=, loff=0
!   reloc[51]: knd=0, off=625, siz=4, lab1=.L270, lab2=, loff=0
!   reloc[52]: knd=0, off=633, siz=4, lab1=.L271, lab2=, loff=0
!   reloc[53]: knd=0, off=641, siz=4, lab1=.L274, lab2=, loff=0
!   reloc[54]: knd=0, off=649, siz=4, lab1=.L277, lab2=, loff=0
!   reloc[55]: knd=0, off=657, siz=4, lab1=.L280, lab2=, loff=0
!   reloc[56]: knd=0, off=665, siz=4, lab1=.L281, lab2=, loff=0
!   reloc[57]: knd=0, off=673, siz=4, lab1=.L282, lab2=, loff=0
!   reloc[58]: knd=0, off=681, siz=4, lab1=.L283, lab2=, loff=0
!   reloc[59]: knd=0, off=689, siz=4, lab1=.L284, lab2=, loff=0
!   reloc[60]: knd=0, off=697, siz=4, lab1=.L285, lab2=, loff=0
!   reloc[61]: knd=0, off=705, siz=4, lab1=.L286, lab2=, loff=0
!   reloc[62]: knd=0, off=713, siz=4, lab1=.L289, lab2=, loff=0
!   reloc[63]: knd=0, off=721, siz=4, lab1=.L292, lab2=, loff=0
!   reloc[64]: knd=0, off=729, siz=4, lab1=.L296, lab2=, loff=0
!   reloc[65]: knd=0, off=737, siz=4, lab1=.L301, lab2=, loff=0
!   reloc[66]: knd=0, off=745, siz=4, lab1=.L304, lab2=, loff=0
!   reloc[67]: knd=0, off=753, siz=4, lab1=.L308, lab2=, loff=0
!   reloc[68]: knd=0, off=761, siz=4, lab1=.L311, lab2=, loff=0
!   reloc[69]: knd=0, off=769, siz=4, lab1=.L312, lab2=, loff=0
!   reloc[70]: knd=0, off=777, siz=4, lab1=.L313, lab2=, loff=0
!   reloc[71]: knd=0, off=785, siz=4, lab1=.L314, lab2=, loff=0
!   reloc[72]: knd=0, off=793, siz=4, lab1=.L318, lab2=, loff=0
!   reloc[73]: knd=0, off=801, siz=4, lab1=.L319, lab2=, loff=0
!   reloc[74]: knd=0, off=809, siz=4, lab1=.L326, lab2=, loff=0
!   reloc[75]: knd=0, off=817, siz=4, lab1=.L333, lab2=, loff=0
!   reloc[76]: knd=0, off=825, siz=4, lab1=.L342, lab2=, loff=0
!   reloc[77]: knd=0, off=833, siz=4, lab1=.L346, lab2=, loff=0
!   reloc[78]: knd=0, off=841, siz=4, lab1=.L347, lab2=, loff=0
!   reloc[79]: knd=0, off=849, siz=4, lab1=.L353, lab2=, loff=0
!   reloc[80]: knd=0, off=859, siz=4, lab1=.L365, lab2=, loff=0
!   reloc[81]: knd=0, off=867, siz=4, lab1=.L371, lab2=, loff=0
!   reloc[82]: knd=0, off=877, siz=4, lab1=.L378, lab2=, loff=0
!   reloc[83]: knd=0, off=887, siz=4, lab1=.L383, lab2=, loff=0
!   reloc[84]: knd=0, off=897, siz=4, lab1=.L384, lab2=, loff=0
!   reloc[85]: knd=0, off=905, siz=4, lab1=.L385, lab2=, loff=0
!   reloc[86]: knd=0, off=913, siz=4, lab1=.L386, lab2=, loff=0
!   reloc[87]: knd=0, off=921, siz=4, lab1=.L387, lab2=, loff=0
!   reloc[88]: knd=0, off=929, siz=4, lab1=.L388, lab2=, loff=0
!   reloc[89]: knd=0, off=937, siz=4, lab1=.L389, lab2=, loff=0
!   reloc[90]: knd=0, off=945, siz=4, lab1=.L390, lab2=, loff=0
!   reloc[91]: knd=0, off=953, siz=4, lab1=.L398, lab2=, loff=0
!   reloc[92]: knd=0, off=961, siz=4, lab1=.L405, lab2=, loff=0
!   reloc[93]: knd=0, off=969, siz=4, lab1=.L407, lab2=, loff=0
!   reloc[94]: knd=0, off=977, siz=4, lab1=.L414, lab2=, loff=0
!   reloc[95]: knd=0, off=987, siz=4, lab1=.L418, lab2=, loff=0
!   reloc[96]: knd=0, off=995, siz=4, lab1=.L421, lab2=, loff=0
!   reloc[97]: knd=0, off=1003, siz=4, lab1=.L425, lab2=, loff=0
!   reloc[98]: knd=0, off=1011, siz=4, lab1=.L426, lab2=, loff=0
!   reloc[99]: knd=0, off=1019, siz=4, lab1=.L432, lab2=, loff=0
!   reloc[100]: knd=0, off=1029, siz=4, lab1=.L436, lab2=, loff=0
!   reloc[101]: knd=0, off=1037, siz=4, lab1=.L442, lab2=, loff=0
!   reloc[102]: knd=0, off=1047, siz=4, lab1=.L446, lab2=, loff=0
!   reloc[103]: knd=0, off=1057, siz=4, lab1=.L447, lab2=, loff=0
!   reloc[104]: knd=0, off=1065, siz=4, lab1=.L448, lab2=, loff=0
!   reloc[105]: knd=0, off=1073, siz=4, lab1=.L449, lab2=, loff=0
!   reloc[106]: knd=0, off=1081, siz=4, lab1=.L450, lab2=, loff=0
!   reloc[107]: knd=0, off=1091, siz=4, lab1=.L454, lab2=, loff=0
!   reloc[108]: knd=0, off=1099, siz=4, lab1=.L458, lab2=, loff=0
!   reloc[109]: knd=0, off=1107, siz=4, lab1=.L459, lab2=, loff=0
!   reloc[110]: knd=0, off=1115, siz=4, lab1=.L461, lab2=, loff=0
!   reloc[111]: knd=0, off=1123, siz=4, lab1=.L462, lab2=, loff=0
!   reloc[112]: knd=0, off=1131, siz=4, lab1=.L464, lab2=, loff=0
!   reloc[113]: knd=0, off=1139, siz=4, lab1=.L465, lab2=, loff=0
!   reloc[114]: knd=0, off=1147, siz=4, lab1=.L466, lab2=, loff=0
!   reloc[115]: knd=0, off=1155, siz=4, lab1=.L468, lab2=, loff=0
!   reloc[116]: knd=0, off=1163, siz=4, lab1=.L469, lab2=, loff=0
!   reloc[117]: knd=0, off=1171, siz=4, lab1=.L471, lab2=, loff=0
!   reloc[118]: knd=0, off=1179, siz=4, lab1=.L472, lab2=, loff=0
!   reloc[119]: knd=0, off=1187, siz=4, lab1=.L473, lab2=, loff=0
!   reloc[120]: knd=0, off=1195, siz=4, lab1=.L474, lab2=, loff=0
!   reloc[121]: knd=0, off=1203, siz=4, lab1=.L476, lab2=, loff=0
!   reloc[122]: knd=0, off=1211, siz=4, lab1=.L477, lab2=, loff=0
!   reloc[123]: knd=0, off=1219, siz=4, lab1=.L478, lab2=, loff=0
!   reloc[124]: knd=0, off=1227, siz=4, lab1=.L479, lab2=, loff=0
!   reloc[125]: knd=0, off=1235, siz=4, lab1=.L480, lab2=, loff=0
!   reloc[126]: knd=0, off=1243, siz=4, lab1=.L482, lab2=, loff=0
!   reloc[127]: knd=0, off=1251, siz=4, lab1=.L484, lab2=, loff=0
!   reloc[128]: knd=0, off=1259, siz=4, lab1=.L487, lab2=, loff=0
!   reloc[129]: knd=0, off=1269, siz=4, lab1=.L492, lab2=, loff=0
!   reloc[130]: knd=0, off=1279, siz=4, lab1=.L497, lab2=, loff=0
!   reloc[131]: knd=0, off=1289, siz=4, lab1=.L501, lab2=, loff=0
!   reloc[132]: knd=0, off=1297, siz=4, lab1=.L507, lab2=, loff=0
!   reloc[133]: knd=0, off=1307, siz=4, lab1=.L511, lab2=, loff=0
!   reloc[134]: knd=0, off=1317, siz=4, lab1=.L514, lab2=, loff=0
!   reloc[135]: knd=0, off=1327, siz=4, lab1=.L524, lab2=, loff=0
!   reloc[136]: knd=0, off=1335, siz=4, lab1=.L530, lab2=, loff=0
!   reloc[137]: knd=0, off=1343, siz=4, lab1=.L534, lab2=, loff=0
!   reloc[138]: knd=0, off=1351, siz=4, lab1=.L535, lab2=, loff=0
!   reloc[139]: knd=0, off=1359, siz=4, lab1=.L541, lab2=, loff=0
!   reloc[140]: knd=0, off=1369, siz=4, lab1=.L542, lab2=, loff=0
!   reloc[141]: knd=0, off=1377, siz=4, lab1=.L543, lab2=, loff=0
!   reloc[142]: knd=0, off=1385, siz=4, lab1=.L544, lab2=, loff=0
!   reloc[143]: knd=0, off=1393, siz=4, lab1=.L545, lab2=, loff=0
!   reloc[144]: knd=0, off=1401, siz=4, lab1=.L549, lab2=, loff=0
!   reloc[145]: knd=0, off=1409, siz=4, lab1=.L551, lab2=, loff=0
!   reloc[146]: knd=0, off=1419, siz=4, lab1=.L552, lab2=, loff=0
!   reloc[147]: knd=0, off=1427, siz=4, lab1=.L553, lab2=, loff=0
!   reloc[148]: knd=0, off=1435, siz=4, lab1=.L554, lab2=, loff=0
!   reloc[149]: knd=0, off=1443, siz=4, lab1=.L555, lab2=, loff=0
!   reloc[150]: knd=0, off=1451, siz=4, lab1=.L557, lab2=, loff=0
!   reloc[151]: knd=0, off=1459, siz=4, lab1=.L558, lab2=, loff=0
!   reloc[152]: knd=0, off=1467, siz=4, lab1=.L559, lab2=, loff=0
!   reloc[153]: knd=0, off=1475, siz=4, lab1=.L560, lab2=, loff=0
!   reloc[154]: knd=0, off=1483, siz=4, lab1=.L561, lab2=, loff=0
!   reloc[155]: knd=0, off=1491, siz=4, lab1=.L563, lab2=, loff=0
!   reloc[156]: knd=0, off=1499, siz=4, lab1=.L564, lab2=, loff=0
!   reloc[157]: knd=0, off=1507, siz=4, lab1=.L565, lab2=, loff=0
!   reloc[158]: knd=0, off=1515, siz=4, lab1=.L566, lab2=, loff=0
!   reloc[159]: knd=0, off=1523, siz=4, lab1=.L567, lab2=, loff=0
!   reloc[160]: knd=0, off=1531, siz=4, lab1=.L569, lab2=, loff=0
!   reloc[161]: knd=0, off=1539, siz=4, lab1=.L570, lab2=, loff=0
!   reloc[162]: knd=0, off=1547, siz=4, lab1=.L571, lab2=, loff=0
!   reloc[163]: knd=0, off=1555, siz=4, lab1=.L572, lab2=, loff=0
!   reloc[164]: knd=0, off=1563, siz=4, lab1=.L573, lab2=, loff=0
!   reloc[165]: knd=0, off=1571, siz=4, lab1=.L575, lab2=, loff=0
!   reloc[166]: knd=0, off=1579, siz=4, lab1=.L576, lab2=, loff=0
!   reloc[167]: knd=0, off=1587, siz=4, lab1=.L577, lab2=, loff=0
!   reloc[168]: knd=0, off=1595, siz=4, lab1=.L578, lab2=, loff=0
!   reloc[169]: knd=0, off=1603, siz=4, lab1=.L579, lab2=, loff=0
!   reloc[170]: knd=0, off=1611, siz=4, lab1=.L581, lab2=, loff=0
!   reloc[171]: knd=0, off=1619, siz=4, lab1=.L582, lab2=, loff=0
!   reloc[172]: knd=0, off=1627, siz=4, lab1=.L583, lab2=, loff=0
!   reloc[173]: knd=0, off=1635, siz=4, lab1=.L584, lab2=, loff=0
!   reloc[174]: knd=0, off=1643, siz=4, lab1=.L585, lab2=, loff=0
!   reloc[175]: knd=0, off=1651, siz=4, lab1=.L587, lab2=, loff=0
!   reloc[176]: knd=0, off=1659, siz=4, lab1=.L588, lab2=, loff=0
!   reloc[177]: knd=0, off=1667, siz=4, lab1=.L589, lab2=, loff=0
!   reloc[178]: knd=0, off=1675, siz=4, lab1=.L590, lab2=, loff=0
!   reloc[179]: knd=0, off=1683, siz=4, lab1=.L591, lab2=, loff=0
!   reloc[180]: knd=0, off=1691, siz=4, lab1=.L593, lab2=, loff=0
!   reloc[181]: knd=0, off=1699, siz=4, lab1=.L594, lab2=, loff=0
!   reloc[182]: knd=0, off=1707, siz=4, lab1=.L595, lab2=, loff=0
!   reloc[183]: knd=0, off=1715, siz=4, lab1=.L596, lab2=, loff=0
!   reloc[184]: knd=0, off=1723, siz=4, lab1=.L597, lab2=, loff=0
!   reloc[185]: knd=0, off=1731, siz=4, lab1=.L599, lab2=, loff=0
!   reloc[186]: knd=0, off=1739, siz=4, lab1=.L601, lab2=, loff=0
!   reloc[187]: knd=0, off=1747, siz=4, lab1=.L604, lab2=, loff=0
!   reloc[188]: knd=0, off=1758, siz=4, lab1=.L609, lab2=, loff=0
!   reloc[189]: knd=0, off=1769, siz=4, lab1=.L615, lab2=, loff=0
!   reloc[190]: knd=0, off=1777, siz=4, lab1=.L616, lab2=, loff=0
!   reloc[191]: knd=0, off=1785, siz=4, lab1=.L617, lab2=, loff=0
!   reloc[192]: knd=0, off=1793, siz=4, lab1=.L618, lab2=, loff=0
!   reloc[193]: knd=0, off=1801, siz=4, lab1=.L621, lab2=, loff=0
!   reloc[194]: knd=0, off=1809, siz=4, lab1=.L625, lab2=, loff=0
!   reloc[195]: knd=0, off=1817, siz=4, lab1=.L626, lab2=, loff=0
!   reloc[196]: knd=0, off=1825, siz=4, lab1=.L627, lab2=, loff=0
!   reloc[197]: knd=0, off=1833, siz=4, lab1=.L628, lab2=, loff=0
!   reloc[198]: knd=0, off=1841, siz=4, lab1=.L629, lab2=, loff=0
!   reloc[199]: knd=0, off=1849, siz=4, lab1=.L636, lab2=, loff=0
!   reloc[200]: knd=0, off=1857, siz=4, lab1=.L643, lab2=, loff=0
!   reloc[201]: knd=0, off=1865, siz=4, lab1=.L650, lab2=, loff=0
!   reloc[202]: knd=0, off=1873, siz=4, lab1=.L662, lab2=, loff=0
!   reloc[203]: knd=0, off=1883, siz=4, lab1=.L666, lab2=, loff=0
!   reloc[204]: knd=0, off=1891, siz=4, lab1=.L667, lab2=, loff=0
!   reloc[205]: knd=0, off=1899, siz=4, lab1=.L668, lab2=, loff=0
!   reloc[206]: knd=0, off=1907, siz=4, lab1=.L669, lab2=, loff=0
!   reloc[207]: knd=0, off=1915, siz=4, lab1=.L670, lab2=, loff=0
!   reloc[208]: knd=0, off=1923, siz=4, lab1=.L671, lab2=, loff=0
!   reloc[209]: knd=0, off=1931, siz=4, lab1=.L672, lab2=, loff=0
!   reloc[210]: knd=0, off=1939, siz=4, lab1=.L673, lab2=, loff=0
!   reloc[211]: knd=0, off=1947, siz=4, lab1=.L677, lab2=, loff=0
!   reloc[212]: knd=0, off=1955, siz=4, lab1=.L678, lab2=, loff=0
!   reloc[213]: knd=0, off=1963, siz=4, lab1=.L679, lab2=, loff=0
!   reloc[214]: knd=0, off=1971, siz=4, lab1=.L680, lab2=, loff=0
!   reloc[215]: knd=0, off=1979, siz=4, lab1=.L687, lab2=, loff=0
!   reloc[216]: knd=0, off=1989, siz=4, lab1=.L691, lab2=, loff=0
!   reloc[217]: knd=0, off=1997, siz=4, lab1=.L692, lab2=, loff=0
!   reloc[218]: knd=0, off=2005, siz=4, lab1=.L694, lab2=, loff=0
!   reloc[219]: knd=0, off=2013, siz=4, lab1=.L695, lab2=, loff=0
!   reloc[220]: knd=0, off=2021, siz=4, lab1=.L697, lab2=, loff=0
!   reloc[221]: knd=0, off=2029, siz=4, lab1=.L698, lab2=, loff=0
!   reloc[222]: knd=0, off=2037, siz=4, lab1=.L700, lab2=, loff=0
!   reloc[223]: knd=0, off=2045, siz=4, lab1=.L701, lab2=, loff=0
!   reloc[224]: knd=0, off=2053, siz=4, lab1=.L702, lab2=, loff=0
!   reloc[225]: knd=0, off=2061, siz=4, lab1=.L704, lab2=, loff=0
!   reloc[226]: knd=0, off=2069, siz=4, lab1=.L705, lab2=, loff=0
!   reloc[227]: knd=0, off=2077, siz=4, lab1=.L707, lab2=, loff=0
!   reloc[228]: knd=0, off=2085, siz=4, lab1=.L708, lab2=, loff=0
!   reloc[229]: knd=0, off=2093, siz=4, lab1=.L709, lab2=, loff=0
!   reloc[230]: knd=0, off=2101, siz=4, lab1=.L710, lab2=, loff=0
!   reloc[231]: knd=0, off=2109, siz=4, lab1=.L712, lab2=, loff=0
!   reloc[232]: knd=0, off=2117, siz=4, lab1=.L713, lab2=, loff=0
!   reloc[233]: knd=0, off=2125, siz=4, lab1=.L714, lab2=, loff=0
!   reloc[234]: knd=0, off=2133, siz=4, lab1=.L715, lab2=, loff=0
!   reloc[235]: knd=0, off=2141, siz=4, lab1=.L716, lab2=, loff=0
!   reloc[236]: knd=0, off=2149, siz=4, lab1=.L718, lab2=, loff=0
!   reloc[237]: knd=0, off=2157, siz=4, lab1=.L720, lab2=, loff=0
!   reloc[238]: knd=0, off=2165, siz=4, lab1=.L723, lab2=, loff=0
!   reloc[239]: knd=0, off=2175, siz=4, lab1=.L728, lab2=, loff=0
!   reloc[240]: knd=0, off=2186, siz=4, lab1=.L731, lab2=, loff=0
!   reloc[241]: knd=0, off=2197, siz=4, lab1=.L734, lab2=, loff=0
!   reloc[242]: knd=0, off=2207, siz=4, lab1=.L744, lab2=, loff=0
!   reloc[243]: knd=0, off=2215, siz=4, lab1=.L750, lab2=, loff=0
!   reloc[244]: knd=0, off=2223, siz=4, lab1=.L754, lab2=, loff=0
!   reloc[245]: knd=0, off=2231, siz=4, lab1=.L755, lab2=, loff=0
!   reloc[246]: knd=0, off=2239, siz=4, lab1=.L761, lab2=, loff=0
!   reloc[247]: knd=0, off=2249, siz=4, lab1=.L762, lab2=, loff=0
!   reloc[248]: knd=0, off=2257, siz=4, lab1=.L763, lab2=, loff=0
!   reloc[249]: knd=0, off=2265, siz=4, lab1=.L764, lab2=, loff=0
!   reloc[250]: knd=0, off=2273, siz=4, lab1=.L765, lab2=, loff=0
!   reloc[251]: knd=0, off=2281, siz=4, lab1=.L766, lab2=, loff=0
!   reloc[252]: knd=0, off=2289, siz=4, lab1=.L767, lab2=, loff=0
!   reloc[253]: knd=0, off=2297, siz=4, lab1=.L770, lab2=, loff=0
!   reloc[254]: knd=0, off=2305, siz=4, lab1=.L774, lab2=, loff=0
!   reloc[255]: knd=0, off=2313, siz=4, lab1=.L780, lab2=, loff=0
!   reloc[256]: knd=0, off=2323, siz=4, lab1=.L784, lab2=, loff=0
!   reloc[257]: knd=0, off=2333, siz=4, lab1=.L785, lab2=, loff=0
!   reloc[258]: knd=0, off=2341, siz=4, lab1=.L786, lab2=, loff=0
!   reloc[259]: knd=0, off=2349, siz=4, lab1=.L787, lab2=, loff=0
!   reloc[260]: knd=0, off=2357, siz=4, lab1=.L791, lab2=, loff=0
!   reloc[261]: knd=0, off=2365, siz=4, lab1=.L793, lab2=, loff=0
!   reloc[262]: knd=0, off=2375, siz=4, lab1=.L794, lab2=, loff=0
!   reloc[263]: knd=0, off=2383, siz=4, lab1=.L795, lab2=, loff=0
!   reloc[264]: knd=0, off=2391, siz=4, lab1=.L796, lab2=, loff=0
!   reloc[265]: knd=0, off=2399, siz=4, lab1=.L797, lab2=, loff=0
!   reloc[266]: knd=0, off=2407, siz=4, lab1=.L799, lab2=, loff=0
!   reloc[267]: knd=0, off=2415, siz=4, lab1=.L800, lab2=, loff=0
!   reloc[268]: knd=0, off=2423, siz=4, lab1=.L801, lab2=, loff=0
!   reloc[269]: knd=0, off=2431, siz=4, lab1=.L802, lab2=, loff=0
!   reloc[270]: knd=0, off=2439, siz=4, lab1=.L803, lab2=, loff=0
!   reloc[271]: knd=0, off=2447, siz=4, lab1=.L805, lab2=, loff=0
!   reloc[272]: knd=0, off=2455, siz=4, lab1=.L806, lab2=, loff=0
!   reloc[273]: knd=0, off=2463, siz=4, lab1=.L807, lab2=, loff=0
!   reloc[274]: knd=0, off=2471, siz=4, lab1=.L808, lab2=, loff=0
!   reloc[275]: knd=0, off=2479, siz=4, lab1=.L809, lab2=, loff=0
!   reloc[276]: knd=0, off=2487, siz=4, lab1=.L811, lab2=, loff=0
!   reloc[277]: knd=0, off=2495, siz=4, lab1=.L812, lab2=, loff=0
!   reloc[278]: knd=0, off=2503, siz=4, lab1=.L813, lab2=, loff=0
!   reloc[279]: knd=0, off=2511, siz=4, lab1=.L814, lab2=, loff=0
!   reloc[280]: knd=0, off=2519, siz=4, lab1=.L815, lab2=, loff=0
!   reloc[281]: knd=0, off=2527, siz=4, lab1=.L817, lab2=, loff=0
!   reloc[282]: knd=0, off=2535, siz=4, lab1=.L818, lab2=, loff=0
!   reloc[283]: knd=0, off=2543, siz=4, lab1=.L819, lab2=, loff=0
!   reloc[284]: knd=0, off=2551, siz=4, lab1=.L820, lab2=, loff=0
!   reloc[285]: knd=0, off=2559, siz=4, lab1=.L821, lab2=, loff=0
!   reloc[286]: knd=0, off=2567, siz=4, lab1=.L823, lab2=, loff=0
!   reloc[287]: knd=0, off=2575, siz=4, lab1=.L824, lab2=, loff=0
!   reloc[288]: knd=0, off=2583, siz=4, lab1=.L825, lab2=, loff=0
!   reloc[289]: knd=0, off=2591, siz=4, lab1=.L826, lab2=, loff=0
!   reloc[290]: knd=0, off=2599, siz=4, lab1=.L827, lab2=, loff=0
!   reloc[291]: knd=0, off=2607, siz=4, lab1=.L829, lab2=, loff=0
!   reloc[292]: knd=0, off=2615, siz=4, lab1=.L830, lab2=, loff=0
!   reloc[293]: knd=0, off=2623, siz=4, lab1=.L831, lab2=, loff=0
!   reloc[294]: knd=0, off=2631, siz=4, lab1=.L832, lab2=, loff=0
!   reloc[295]: knd=0, off=2639, siz=4, lab1=.L833, lab2=, loff=0
!   reloc[296]: knd=0, off=2647, siz=4, lab1=.L835, lab2=, loff=0
!   reloc[297]: knd=0, off=2655, siz=4, lab1=.L836, lab2=, loff=0
!   reloc[298]: knd=0, off=2663, siz=4, lab1=.L837, lab2=, loff=0
!   reloc[299]: knd=0, off=2671, siz=4, lab1=.L838, lab2=, loff=0
!   reloc[300]: knd=0, off=2679, siz=4, lab1=.L839, lab2=, loff=0
!   reloc[301]: knd=0, off=2687, siz=4, lab1=.L841, lab2=, loff=0
!   reloc[302]: knd=0, off=2695, siz=4, lab1=.L843, lab2=, loff=0
!   reloc[303]: knd=0, off=2703, siz=4, lab1=.L846, lab2=, loff=0
!   reloc[304]: knd=0, off=2714, siz=4, lab1=.L851, lab2=, loff=0
!   reloc[305]: knd=0, off=2725, siz=4, lab1=.L857, lab2=, loff=0
!   reloc[306]: knd=0, off=2733, siz=4, lab1=.L861, lab2=, loff=0
!   reloc[307]: knd=0, off=2741, siz=4, lab1=.L862, lab2=, loff=0
!   reloc[308]: knd=0, off=2749, siz=4, lab1=.L863, lab2=, loff=0
!   reloc[309]: knd=0, off=2757, siz=4, lab1=.L864, lab2=, loff=0
!   reloc[310]: knd=0, off=2765, siz=4, lab1=.L865, lab2=, loff=0
!   reloc[311]: knd=0, off=2773, siz=4, lab1=.L872, lab2=, loff=0
!   reloc[312]: knd=0, off=2781, siz=4, lab1=.L879, lab2=, loff=0
!   reloc[313]: knd=0, off=2789, siz=4, lab1=.L886, lab2=, loff=0
!   reloc[314]: knd=0, off=2797, siz=4, lab1=.L898, lab2=, loff=0
!   reloc[315]: knd=0, off=2807, siz=4, lab1=.L902, lab2=, loff=0
!   reloc[316]: knd=0, off=2815, siz=4, lab1=.L903, lab2=, loff=0
!   reloc[317]: knd=0, off=2823, siz=4, lab1=.L904, lab2=, loff=0
!   reloc[318]: knd=0, off=2831, siz=4, lab1=.L905, lab2=, loff=0
!   reloc[319]: knd=0, off=2839, siz=4, lab1=.L906, lab2=, loff=0
!   reloc[320]: knd=0, off=2847, siz=4, lab1=.L907, lab2=, loff=0
!   reloc[321]: knd=0, off=2855, siz=4, lab1=.L908, lab2=, loff=0
!   reloc[322]: knd=0, off=2863, siz=4, lab1=.L909, lab2=, loff=0
!   reloc[323]: knd=0, off=2871, siz=4, lab1=.L919, lab2=, loff=0
!   reloc[324]: knd=0, off=2881, siz=4, lab1=.L923, lab2=, loff=0
!   reloc[325]: knd=0, off=2891, siz=4, lab1=.L924, lab2=, loff=0
!   reloc[326]: knd=0, off=2899, siz=4, lab1=.L926, lab2=, loff=0
!   reloc[327]: knd=0, off=2907, siz=4, lab1=.L927, lab2=, loff=0
!   reloc[328]: knd=0, off=2915, siz=4, lab1=.L929, lab2=, loff=0
!   reloc[329]: knd=0, off=2923, siz=4, lab1=.L930, lab2=, loff=0
!   reloc[330]: knd=0, off=2931, siz=4, lab1=.L932, lab2=, loff=0
!   reloc[331]: knd=0, off=2939, siz=4, lab1=.L933, lab2=, loff=0
!   reloc[332]: knd=0, off=2947, siz=4, lab1=.L934, lab2=, loff=0
!   reloc[333]: knd=0, off=2955, siz=4, lab1=.L936, lab2=, loff=0
!   reloc[334]: knd=0, off=2963, siz=4, lab1=.L937, lab2=, loff=0
!   reloc[335]: knd=0, off=2971, siz=4, lab1=.L939, lab2=, loff=0
!   reloc[336]: knd=0, off=2979, siz=4, lab1=.L940, lab2=, loff=0
!   reloc[337]: knd=0, off=2987, siz=4, lab1=.L941, lab2=, loff=0
!   reloc[338]: knd=0, off=2995, siz=4, lab1=.L942, lab2=, loff=0
!   reloc[339]: knd=0, off=3003, siz=4, lab1=.L944, lab2=, loff=0
!   reloc[340]: knd=0, off=3011, siz=4, lab1=.L945, lab2=, loff=0
!   reloc[341]: knd=0, off=3019, siz=4, lab1=.L946, lab2=, loff=0
!   reloc[342]: knd=0, off=3027, siz=4, lab1=.L947, lab2=, loff=0
!   reloc[343]: knd=0, off=3035, siz=4, lab1=.L948, lab2=, loff=0
!   reloc[344]: knd=0, off=3043, siz=4, lab1=.L950, lab2=, loff=0
!   reloc[345]: knd=0, off=3051, siz=4, lab1=.L952, lab2=, loff=0
!   reloc[346]: knd=0, off=3059, siz=4, lab1=.L955, lab2=, loff=0
!   reloc[347]: knd=0, off=3069, siz=4, lab1=.L960, lab2=, loff=0
!   reloc[348]: knd=0, off=3080, siz=4, lab1=.L963, lab2=, loff=0
!   reloc[349]: knd=0, off=3091, siz=4, lab1=.L965, lab2=, loff=0
!   reloc[350]: knd=0, off=3101, siz=4, lab1=.L967, lab2=, loff=0
!   reloc[351]: knd=0, off=3109, siz=4, lab1=.L970, lab2=, loff=0
!   reloc[352]: knd=0, off=3120, siz=4, lab1=.L973, lab2=, loff=0
!   reloc[353]: knd=0, off=3131, siz=4, lab1=.L974, lab2=, loff=0
!   reloc[354]: knd=0, off=3144, siz=4, lab1=make_null_texture, lab2=, loff=0
!   reloc[355]: knd=0, off=3151, siz=4, lab1=.L981, lab2=, loff=0
!   reloc[356]: knd=0, off=3163, siz=4, lab1=.L982, lab2=, loff=0
!   reloc[357]: knd=0, off=3171, siz=4, lab1=.L983, lab2=, loff=0
!   reloc[358]: knd=0, off=3179, siz=4, lab1=.L986, lab2=, loff=0
!   reloc[359]: knd=0, off=3187, siz=4, lab1=.L989, lab2=, loff=0
!   reloc[360]: knd=0, off=3195, siz=4, lab1=.L992, lab2=, loff=0
!   reloc[361]: knd=0, off=3203, siz=4, lab1=.L993, lab2=, loff=0
!   reloc[362]: knd=0, off=3211, siz=4, lab1=.L994, lab2=, loff=0
!   reloc[363]: knd=0, off=3219, siz=4, lab1=.L995, lab2=, loff=0
!   reloc[364]: knd=0, off=3227, siz=4, lab1=.L996, lab2=, loff=0
!   reloc[365]: knd=0, off=3235, siz=4, lab1=.L997, lab2=, loff=0
!   reloc[366]: knd=0, off=3243, siz=4, lab1=.L998, lab2=, loff=0
!   reloc[367]: knd=0, off=3251, siz=4, lab1=.L1001, lab2=, loff=0
!   reloc[368]: knd=0, off=3259, siz=4, lab1=.L1004, lab2=, loff=0
!   reloc[369]: knd=0, off=3267, siz=4, lab1=.L1008, lab2=, loff=0
!   reloc[370]: knd=0, off=3275, siz=4, lab1=.L1013, lab2=, loff=0
!   reloc[371]: knd=0, off=3283, siz=4, lab1=.L1016, lab2=, loff=0
!   reloc[372]: knd=0, off=3291, siz=4, lab1=.L1020, lab2=, loff=0
!   reloc[373]: knd=0, off=3299, siz=4, lab1=.L1023, lab2=, loff=0
!   reloc[374]: knd=0, off=3307, siz=4, lab1=.L1024, lab2=, loff=0
!   reloc[375]: knd=0, off=3315, siz=4, lab1=.L1025, lab2=, loff=0
!   reloc[376]: knd=0, off=3323, siz=4, lab1=.L1026, lab2=, loff=0
!   reloc[377]: knd=0, off=3331, siz=4, lab1=.L1030, lab2=, loff=0
!   reloc[378]: knd=0, off=3341, siz=4, lab1=.L1033, lab2=, loff=0
!   reloc[379]: knd=0, off=3351, siz=4, lab1=.L1038, lab2=, loff=0
!   reloc[380]: knd=0, off=3361, siz=4, lab1=.L1039, lab2=, loff=0
!   reloc[381]: knd=0, off=3369, siz=4, lab1=.L1041, lab2=, loff=0
!   reloc[382]: knd=0, off=3377, siz=4, lab1=.L1048, lab2=, loff=0
!   reloc[383]: knd=0, off=3385, siz=4, lab1=.L1050, lab2=, loff=0
!   reloc[384]: knd=0, off=3393, siz=4, lab1=.L1057, lab2=, loff=0
!   reloc[385]: knd=0, off=3401, siz=4, lab1=.L1058, lab2=, loff=0
!   reloc[386]: knd=0, off=3409, siz=4, lab1=.L1063, lab2=, loff=0
!   reloc[387]: knd=0, off=3417, siz=4, lab1=.L1070, lab2=, loff=0
!   reloc[388]: knd=0, off=3425, siz=4, lab1=.L1073, lab2=, loff=0
!   reloc[389]: knd=0, off=3433, siz=4, lab1=.L1078, lab2=, loff=0
!   reloc[390]: knd=0, off=3443, siz=4, lab1=.L1083, lab2=, loff=0
!   reloc[391]: knd=0, off=3453, siz=4, lab1=.L1089, lab2=, loff=0
!   reloc[392]: knd=0, off=3463, siz=4, lab1=.L1090, lab2=, loff=0
!   reloc[393]: knd=0, off=3476, siz=4, lab1=texture_1d_error_check, lab2=, loff=0
!   reloc[394]: knd=0, off=3483, siz=4, lab1=.L1099, lab2=, loff=0
!   reloc[395]: knd=0, off=3495, siz=4, lab1=.L1104, lab2=, loff=0
!   reloc[396]: knd=0, off=3503, siz=4, lab1=.L1106, lab2=, loff=0
!   reloc[397]: knd=0, off=3511, siz=4, lab1=.L1112, lab2=, loff=0
!   reloc[398]: knd=0, off=3519, siz=4, lab1=.L1118, lab2=, loff=0
!   reloc[399]: knd=0, off=3527, siz=4, lab1=.L1120, lab2=, loff=0
!   reloc[400]: knd=0, off=3535, siz=4, lab1=.L1124, lab2=, loff=0
!   reloc[401]: knd=0, off=3543, siz=4, lab1=.L1127, lab2=, loff=0
!   reloc[402]: knd=0, off=3551, siz=4, lab1=.L1131, lab2=, loff=0
!   reloc[403]: knd=0, off=3559, siz=4, lab1=.L1133, lab2=, loff=0
!   reloc[404]: knd=0, off=3567, siz=4, lab1=.L1139, lab2=, loff=0
!   reloc[405]: knd=0, off=3575, siz=4, lab1=.L1146, lab2=, loff=0
!   reloc[406]: knd=0, off=3583, siz=4, lab1=.L1150, lab2=, loff=0
!   reloc[407]: knd=0, off=3591, siz=4, lab1=.L1155, lab2=, loff=0
!   reloc[408]: knd=0, off=3599, siz=4, lab1=.L1161, lab2=, loff=0
!   reloc[409]: knd=0, off=3607, siz=4, lab1=.L1169, lab2=, loff=0
!   reloc[410]: knd=0, off=3615, siz=4, lab1=.L1173, lab2=, loff=0
!   reloc[411]: knd=0, off=3623, siz=4, lab1=.L1178, lab2=, loff=0
!   reloc[412]: knd=0, off=3631, siz=4, lab1=.L1184, lab2=, loff=0
!   reloc[413]: knd=0, off=3639, siz=4, lab1=.L1188, lab2=, loff=0
!   reloc[414]: knd=0, off=3647, siz=4, lab1=.L1190, lab2=, loff=0
!   reloc[415]: knd=0, off=3655, siz=4, lab1=.L1197, lab2=, loff=0
!   reloc[416]: knd=0, off=3663, siz=4, lab1=.L1209, lab2=, loff=0
!   reloc[417]: knd=0, off=3673, siz=4, lab1=.L1211, lab2=, loff=0
!   reloc[418]: knd=0, off=3681, siz=4, lab1=.L1213, lab2=, loff=0
!   reloc[419]: knd=0, off=3689, siz=4, lab1=.L1216, lab2=, loff=0
!   reloc[420]: knd=0, off=3699, siz=4, lab1=.L1222, lab2=, loff=0
!   reloc[421]: knd=0, off=3709, siz=4, lab1=.L1230, lab2=, loff=0
!   reloc[422]: knd=0, off=3719, siz=4, lab1=.L1232, lab2=, loff=0
!   reloc[423]: knd=0, off=3727, siz=4, lab1=.L1234, lab2=, loff=0
!   reloc[424]: knd=0, off=3735, siz=4, lab1=.L1237, lab2=, loff=0
!   reloc[425]: knd=0, off=3745, siz=4, lab1=.L1240, lab2=, loff=0
!   reloc[426]: knd=0, off=3755, siz=4, lab1=.L1241, lab2=, loff=0
!   reloc[427]: knd=0, off=3768, siz=4, lab1=texture_2d_error_check, lab2=, loff=0
!   reloc[428]: knd=0, off=3775, siz=4, lab1=.L1250, lab2=, loff=0
!   reloc[429]: knd=0, off=3787, siz=4, lab1=.L1255, lab2=, loff=0
!   reloc[430]: knd=0, off=3795, siz=4, lab1=.L1257, lab2=, loff=0
!   reloc[431]: knd=0, off=3803, siz=4, lab1=.L1263, lab2=, loff=0
!   reloc[432]: knd=0, off=3811, siz=4, lab1=.L1269, lab2=, loff=0
!   reloc[433]: knd=0, off=3819, siz=4, lab1=.L1271, lab2=, loff=0
!   reloc[434]: knd=0, off=3827, siz=4, lab1=.L1275, lab2=, loff=0
!   reloc[435]: knd=0, off=3835, siz=4, lab1=.L1278, lab2=, loff=0
!   reloc[436]: knd=0, off=3843, siz=4, lab1=.L1282, lab2=, loff=0
!   reloc[437]: knd=0, off=3851, siz=4, lab1=.L1284, lab2=, loff=0
!   reloc[438]: knd=0, off=3859, siz=4, lab1=.L1290, lab2=, loff=0
!   reloc[439]: knd=0, off=3867, siz=4, lab1=.L1297, lab2=, loff=0
!   reloc[440]: knd=0, off=3875, siz=4, lab1=.L1301, lab2=, loff=0
!   reloc[441]: knd=0, off=3883, siz=4, lab1=.L1306, lab2=, loff=0
!   reloc[442]: knd=0, off=3891, siz=4, lab1=.L1312, lab2=, loff=0
!   reloc[443]: knd=0, off=3899, siz=4, lab1=.L1320, lab2=, loff=0
!   reloc[444]: knd=0, off=3907, siz=4, lab1=.L1324, lab2=, loff=0
!   reloc[445]: knd=0, off=3915, siz=4, lab1=.L1329, lab2=, loff=0
!   reloc[446]: knd=0, off=3923, siz=4, lab1=.L1335, lab2=, loff=0
!   reloc[447]: knd=0, off=3931, siz=4, lab1=.L1343, lab2=, loff=0
!   reloc[448]: knd=0, off=3939, siz=4, lab1=.L1347, lab2=, loff=0
!   reloc[449]: knd=0, off=3947, siz=4, lab1=.L1352, lab2=, loff=0
!   reloc[450]: knd=0, off=3955, siz=4, lab1=.L1358, lab2=, loff=0
!   reloc[451]: knd=0, off=3963, siz=4, lab1=.L1362, lab2=, loff=0
!   reloc[452]: knd=0, off=3971, siz=4, lab1=.L1364, lab2=, loff=0
!   reloc[453]: knd=0, off=3979, siz=4, lab1=.L1370, lab2=, loff=0
!   reloc[454]: knd=0, off=3987, siz=4, lab1=.L1374, lab2=, loff=0
!   reloc[455]: knd=0, off=3995, siz=4, lab1=.L1376, lab2=, loff=0
!   reloc[456]: knd=0, off=4003, siz=4, lab1=.L1383, lab2=, loff=0
!   reloc[457]: knd=0, off=4011, siz=4, lab1=.L1395, lab2=, loff=0
!   reloc[458]: knd=0, off=4021, siz=4, lab1=.L1397, lab2=, loff=0
!   reloc[459]: knd=0, off=4029, siz=4, lab1=.L1399, lab2=, loff=0
!   reloc[460]: knd=0, off=4037, siz=4, lab1=.L1402, lab2=, loff=0
!   reloc[461]: knd=0, off=4047, siz=4, lab1=.L1408, lab2=, loff=0
!   reloc[462]: knd=0, off=4057, siz=4, lab1=.L1418, lab2=, loff=0
!   reloc[463]: knd=0, off=4067, siz=4, lab1=.L1420, lab2=, loff=0
!   reloc[464]: knd=0, off=4075, siz=4, lab1=.L1422, lab2=, loff=0
!   reloc[465]: knd=0, off=4083, siz=4, lab1=.L1425, lab2=, loff=0
!   reloc[466]: knd=0, off=4093, siz=4, lab1=.L1428, lab2=, loff=0
!   reloc[467]: knd=0, off=4103, siz=4, lab1=.L1429, lab2=, loff=0
!   reloc[468]: knd=0, off=4116, siz=4, lab1=texture_3d_error_check, lab2=, loff=0
!   reloc[469]: knd=0, off=4123, siz=4, lab1=.L1438, lab2=, loff=0
!   reloc[470]: knd=0, off=4135, siz=4, lab1=.L1443, lab2=, loff=0
!   reloc[471]: knd=0, off=4143, siz=4, lab1=.L1445, lab2=, loff=0
!   reloc[472]: knd=0, off=4151, siz=4, lab1=.L1451, lab2=, loff=0
!   reloc[473]: knd=0, off=4159, siz=4, lab1=.L1457, lab2=, loff=0
!   reloc[474]: knd=0, off=4167, siz=4, lab1=.L1459, lab2=, loff=0
!   reloc[475]: knd=0, off=4175, siz=4, lab1=.L1463, lab2=, loff=0
!   reloc[476]: knd=0, off=4183, siz=4, lab1=.L1466, lab2=, loff=0
!   reloc[477]: knd=0, off=4191, siz=4, lab1=.L1470, lab2=, loff=0
!   reloc[478]: knd=0, off=4199, siz=4, lab1=.L1472, lab2=, loff=0
!   reloc[479]: knd=0, off=4207, siz=4, lab1=.L1478, lab2=, loff=0
!   reloc[480]: knd=0, off=4215, siz=4, lab1=.L1485, lab2=, loff=0
!   reloc[481]: knd=0, off=4223, siz=4, lab1=.L1489, lab2=, loff=0
!   reloc[482]: knd=0, off=4231, siz=4, lab1=.L1494, lab2=, loff=0
!   reloc[483]: knd=0, off=4239, siz=4, lab1=.L1500, lab2=, loff=0
!   reloc[484]: knd=0, off=4247, siz=4, lab1=.L1508, lab2=, loff=0
!   reloc[485]: knd=0, off=4255, siz=4, lab1=.L1512, lab2=, loff=0
!   reloc[486]: knd=0, off=4263, siz=4, lab1=.L1517, lab2=, loff=0
!   reloc[487]: knd=0, off=4271, siz=4, lab1=.L1523, lab2=, loff=0
!   reloc[488]: knd=0, off=4279, siz=4, lab1=.L1531, lab2=, loff=0
!   reloc[489]: knd=0, off=4287, siz=4, lab1=.L1535, lab2=, loff=0
!   reloc[490]: knd=0, off=4295, siz=4, lab1=.L1540, lab2=, loff=0
!   reloc[491]: knd=0, off=4303, siz=4, lab1=.L1546, lab2=, loff=0
!   reloc[492]: knd=0, off=4311, siz=4, lab1=.L1554, lab2=, loff=0
!   reloc[493]: knd=0, off=4319, siz=4, lab1=.L1558, lab2=, loff=0
!   reloc[494]: knd=0, off=4327, siz=4, lab1=.L1563, lab2=, loff=0
!   reloc[495]: knd=0, off=4335, siz=4, lab1=.L1569, lab2=, loff=0
!   reloc[496]: knd=0, off=4343, siz=4, lab1=.L1573, lab2=, loff=0
!   reloc[497]: knd=0, off=4351, siz=4, lab1=.L1575, lab2=, loff=0
!   reloc[498]: knd=0, off=4359, siz=4, lab1=.L1581, lab2=, loff=0
!   reloc[499]: knd=0, off=4367, siz=4, lab1=.L1585, lab2=, loff=0
!   reloc[500]: knd=0, off=4375, siz=4, lab1=.L1587, lab2=, loff=0
!   reloc[501]: knd=0, off=4383, siz=4, lab1=.L1593, lab2=, loff=0
!   reloc[502]: knd=0, off=4391, siz=4, lab1=.L1597, lab2=, loff=0
!   reloc[503]: knd=0, off=4399, siz=4, lab1=.L1599, lab2=, loff=0
!   reloc[504]: knd=0, off=4407, siz=4, lab1=.L1606, lab2=, loff=0
!   reloc[505]: knd=0, off=4415, siz=4, lab1=.L1618, lab2=, loff=0
!   reloc[506]: knd=0, off=4425, siz=4, lab1=.L1620, lab2=, loff=0
!   reloc[507]: knd=0, off=4433, siz=4, lab1=.L1622, lab2=, loff=0
!   reloc[508]: knd=0, off=4441, siz=4, lab1=.L1625, lab2=, loff=0
!   reloc[509]: knd=0, off=4451, siz=4, lab1=.L1631, lab2=, loff=0
!   reloc[510]: knd=0, off=4461, siz=4, lab1=.L1641, lab2=, loff=0
!   reloc[511]: knd=0, off=4471, siz=4, lab1=.L1643, lab2=, loff=0
!   reloc[512]: knd=0, off=4479, siz=4, lab1=.L1645, lab2=, loff=0
!   reloc[513]: knd=0, off=4487, siz=4, lab1=.L1648, lab2=, loff=0
!   reloc[514]: knd=0, off=4497, siz=4, lab1=.L1651, lab2=, loff=0
!   reloc[515]: knd=0, off=4507, siz=4, lab1=.L1652, lab2=, loff=0
!   reloc[516]: knd=0, off=4520, siz=4, lab1=gl_TexImage1D, lab2=, loff=0
!   reloc[517]: knd=0, off=4527, siz=4, lab1=.L1661, lab2=, loff=0
!   reloc[518]: knd=0, off=4539, siz=4, lab1=.L1665, lab2=, loff=0
!   reloc[519]: knd=0, off=4547, siz=4, lab1=.L1667, lab2=, loff=0
!   reloc[520]: knd=0, off=4555, siz=4, lab1=.L1673, lab2=, loff=0
!   reloc[521]: knd=0, off=4565, siz=4, lab1=.L1679, lab2=, loff=0
!   reloc[522]: knd=0, off=4575, siz=4, lab1=.L1683, lab2=, loff=0
!   reloc[523]: knd=0, off=4583, siz=4, lab1=.L1689, lab2=, loff=0
!   reloc[524]: knd=0, off=4593, siz=4, lab1=.L1693, lab2=, loff=0
!   reloc[525]: knd=0, off=4601, siz=4, lab1=.L1699, lab2=, loff=0
!   reloc[526]: knd=0, off=4611, siz=4, lab1=.L1703, lab2=, loff=0
!   reloc[527]: knd=0, off=4619, siz=4, lab1=.L1709, lab2=, loff=0
!   reloc[528]: knd=0, off=4629, siz=4, lab1=.L1713, lab2=, loff=0
!   reloc[529]: knd=0, off=4639, siz=4, lab1=.L1714, lab2=, loff=0
!   reloc[530]: knd=0, off=4647, siz=4, lab1=.L1715, lab2=, loff=0
!   reloc[531]: knd=0, off=4655, siz=4, lab1=.L1718, lab2=, loff=0
!   reloc[532]: knd=0, off=4665, siz=4, lab1=.L1723, lab2=, loff=0
!   reloc[533]: knd=0, off=4673, siz=4, lab1=.L1729, lab2=, loff=0
!   reloc[534]: knd=0, off=4683, siz=4, lab1=.L1733, lab2=, loff=0
!   reloc[535]: knd=0, off=4693, siz=4, lab1=.L1743, lab2=, loff=0
!   reloc[536]: knd=0, off=4703, siz=4, lab1=.L1749, lab2=, loff=0
!   reloc[537]: knd=0, off=4713, siz=4, lab1=.L1755, lab2=, loff=0
!   reloc[538]: knd=0, off=4721, siz=4, lab1=.L1760, lab2=, loff=0
!   reloc[539]: knd=0, off=4729, siz=4, lab1=.L1769, lab2=, loff=0
!   reloc[540]: knd=0, off=4739, siz=4, lab1=.L1770, lab2=, loff=0
!   reloc[541]: knd=0, off=4747, siz=4, lab1=.L1771, lab2=, loff=0
!   reloc[542]: knd=0, off=4755, siz=4, lab1=.L1772, lab2=, loff=0
!   reloc[543]: knd=0, off=4763, siz=4, lab1=.L1778, lab2=, loff=0
!   reloc[544]: knd=0, off=4771, siz=4, lab1=.L1782, lab2=, loff=0
!   reloc[545]: knd=0, off=4779, siz=4, lab1=.L1791, lab2=, loff=0
!   reloc[546]: knd=0, off=4789, siz=4, lab1=.L1793, lab2=, loff=0
!   reloc[547]: knd=0, off=4797, siz=4, lab1=.L1799, lab2=, loff=0
!   reloc[548]: knd=0, off=4810, siz=4, lab1=gl_TexImage2D, lab2=, loff=0
!   reloc[549]: knd=0, off=4817, siz=4, lab1=.L1808, lab2=, loff=0
!   reloc[550]: knd=0, off=4829, siz=4, lab1=.L1812, lab2=, loff=0
!   reloc[551]: knd=0, off=4837, siz=4, lab1=.L1814, lab2=, loff=0
!   reloc[552]: knd=0, off=4845, siz=4, lab1=.L1820, lab2=, loff=0
!   reloc[553]: knd=0, off=4855, siz=4, lab1=.L1826, lab2=, loff=0
!   reloc[554]: knd=0, off=4865, siz=4, lab1=.L1830, lab2=, loff=0
!   reloc[555]: knd=0, off=4873, siz=4, lab1=.L1836, lab2=, loff=0
!   reloc[556]: knd=0, off=4883, siz=4, lab1=.L1840, lab2=, loff=0
!   reloc[557]: knd=0, off=4891, siz=4, lab1=.L1846, lab2=, loff=0
!   reloc[558]: knd=0, off=4901, siz=4, lab1=.L1850, lab2=, loff=0
!   reloc[559]: knd=0, off=4909, siz=4, lab1=.L1856, lab2=, loff=0
!   reloc[560]: knd=0, off=4919, siz=4, lab1=.L1860, lab2=, loff=0
!   reloc[561]: knd=0, off=4929, siz=4, lab1=.L1861, lab2=, loff=0
!   reloc[562]: knd=0, off=4937, siz=4, lab1=.L1862, lab2=, loff=0
!   reloc[563]: knd=0, off=4945, siz=4, lab1=.L1865, lab2=, loff=0
!   reloc[564]: knd=0, off=4955, siz=4, lab1=.L1870, lab2=, loff=0
!   reloc[565]: knd=0, off=4963, siz=4, lab1=.L1876, lab2=, loff=0
!   reloc[566]: knd=0, off=4973, siz=4, lab1=.L1880, lab2=, loff=0
!   reloc[567]: knd=0, off=4983, siz=4, lab1=.L1890, lab2=, loff=0
!   reloc[568]: knd=0, off=4993, siz=4, lab1=.L1896, lab2=, loff=0
!   reloc[569]: knd=0, off=5003, siz=4, lab1=.L1902, lab2=, loff=0
!   reloc[570]: knd=0, off=5011, siz=4, lab1=.L1907, lab2=, loff=0
!   reloc[571]: knd=0, off=5019, siz=4, lab1=.L1916, lab2=, loff=0
!   reloc[572]: knd=0, off=5029, siz=4, lab1=.L1917, lab2=, loff=0
!   reloc[573]: knd=0, off=5037, siz=4, lab1=.L1918, lab2=, loff=0
!   reloc[574]: knd=0, off=5045, siz=4, lab1=.L1919, lab2=, loff=0
!   reloc[575]: knd=0, off=5053, siz=4, lab1=.L1925, lab2=, loff=0
!   reloc[576]: knd=0, off=5061, siz=4, lab1=.L1929, lab2=, loff=0
!   reloc[577]: knd=0, off=5069, siz=4, lab1=.L1938, lab2=, loff=0
!   reloc[578]: knd=0, off=5079, siz=4, lab1=.L1940, lab2=, loff=0
!   reloc[579]: knd=0, off=5087, siz=4, lab1=.L1946, lab2=, loff=0
!   reloc[580]: knd=0, off=5100, siz=4, lab1=gl_TexImage3DEXT, lab2=, loff=0
!   reloc[581]: knd=0, off=5107, siz=4, lab1=.L1955, lab2=, loff=0
!   reloc[582]: knd=0, off=5119, siz=4, lab1=.L1959, lab2=, loff=0
!   reloc[583]: knd=0, off=5127, siz=4, lab1=.L1961, lab2=, loff=0
!   reloc[584]: knd=0, off=5135, siz=4, lab1=.L1967, lab2=, loff=0
!   reloc[585]: knd=0, off=5145, siz=4, lab1=.L1973, lab2=, loff=0
!   reloc[586]: knd=0, off=5155, siz=4, lab1=.L1977, lab2=, loff=0
!   reloc[587]: knd=0, off=5163, siz=4, lab1=.L1983, lab2=, loff=0
!   reloc[588]: knd=0, off=5173, siz=4, lab1=.L1987, lab2=, loff=0
!   reloc[589]: knd=0, off=5181, siz=4, lab1=.L1993, lab2=, loff=0
!   reloc[590]: knd=0, off=5191, siz=4, lab1=.L1997, lab2=, loff=0
!   reloc[591]: knd=0, off=5199, siz=4, lab1=.L2003, lab2=, loff=0
!   reloc[592]: knd=0, off=5209, siz=4, lab1=.L2007, lab2=, loff=0
!   reloc[593]: knd=0, off=5219, siz=4, lab1=.L2008, lab2=, loff=0
!   reloc[594]: knd=0, off=5227, siz=4, lab1=.L2009, lab2=, loff=0
!   reloc[595]: knd=0, off=5235, siz=4, lab1=.L2012, lab2=, loff=0
!   reloc[596]: knd=0, off=5245, siz=4, lab1=.L2017, lab2=, loff=0
!   reloc[597]: knd=0, off=5253, siz=4, lab1=.L2023, lab2=, loff=0
!   reloc[598]: knd=0, off=5263, siz=4, lab1=.L2027, lab2=, loff=0
!   reloc[599]: knd=0, off=5273, siz=4, lab1=.L2037, lab2=, loff=0
!   reloc[600]: knd=0, off=5283, siz=4, lab1=.L2043, lab2=, loff=0
!   reloc[601]: knd=0, off=5293, siz=4, lab1=.L2049, lab2=, loff=0
!   reloc[602]: knd=0, off=5301, siz=4, lab1=.L2054, lab2=, loff=0
!   reloc[603]: knd=0, off=5309, siz=4, lab1=.L2063, lab2=, loff=0
!   reloc[604]: knd=0, off=5319, siz=4, lab1=.L2064, lab2=, loff=0
!   reloc[605]: knd=0, off=5327, siz=4, lab1=.L2065, lab2=, loff=0
!   reloc[606]: knd=0, off=5335, siz=4, lab1=.L2066, lab2=, loff=0
!   reloc[607]: knd=0, off=5343, siz=4, lab1=.L2067, lab2=, loff=0
!   reloc[608]: knd=0, off=5351, siz=4, lab1=.L2073, lab2=, loff=0
!   reloc[609]: knd=0, off=5359, siz=4, lab1=.L2077, lab2=, loff=0
!   reloc[610]: knd=0, off=5367, siz=4, lab1=.L2086, lab2=, loff=0
!   reloc[611]: knd=0, off=5377, siz=4, lab1=.L2088, lab2=, loff=0
!   reloc[612]: knd=0, off=5385, siz=4, lab1=.L2094, lab2=, loff=0
!   reloc[613]: knd=0, off=5398, siz=4, lab1=gl_GetTexImage, lab2=, loff=0
!   reloc[614]: knd=0, off=5405, siz=4, lab1=.L2101, lab2=, loff=0
!   reloc[615]: knd=0, off=5417, siz=4, lab1=.L2103, lab2=, loff=0
!   reloc[616]: knd=0, off=5430, siz=4, lab1=gl_unpack_texsubimage, lab2=, loff=0
!   reloc[617]: knd=0, off=5437, siz=4, lab1=.L2112, lab2=, loff=0
!   reloc[618]: knd=0, off=5449, siz=4, lab1=.L2117, lab2=, loff=0
!   reloc[619]: knd=0, off=5457, siz=4, lab1=.L2123, lab2=, loff=0
!   reloc[620]: knd=0, off=5467, siz=4, lab1=.L2129, lab2=, loff=0
!   reloc[621]: knd=0, off=5475, siz=4, lab1=.L2135, lab2=, loff=0
!   reloc[622]: knd=0, off=5485, siz=4, lab1=.L2139, lab2=, loff=0
!   reloc[623]: knd=0, off=5493, siz=4, lab1=.L2143, lab2=, loff=0
!   reloc[624]: knd=0, off=5503, siz=4, lab1=.L2144, lab2=, loff=0
!   reloc[625]: knd=0, off=5516, siz=4, lab1=gl_TexSubImage1D, lab2=, loff=0
!   reloc[626]: knd=0, off=5523, siz=4, lab1=.L2153, lab2=, loff=0
!   reloc[627]: knd=0, off=5535, siz=4, lab1=.L2157, lab2=, loff=0
!   reloc[628]: knd=0, off=5543, siz=4, lab1=.L2159, lab2=, loff=0
!   reloc[629]: knd=0, off=5551, siz=4, lab1=.L2165, lab2=, loff=0
!   reloc[630]: knd=0, off=5559, siz=4, lab1=.L2171, lab2=, loff=0
!   reloc[631]: knd=0, off=5567, siz=4, lab1=.L2173, lab2=, loff=0
!   reloc[632]: knd=0, off=5575, siz=4, lab1=.L2177, lab2=, loff=0
!   reloc[633]: knd=0, off=5585, siz=4, lab1=.L2180, lab2=, loff=0
!   reloc[634]: knd=0, off=5593, siz=4, lab1=.L2184, lab2=, loff=0
!   reloc[635]: knd=0, off=5601, siz=4, lab1=.L2186, lab2=, loff=0
!   reloc[636]: knd=0, off=5609, siz=4, lab1=.L2192, lab2=, loff=0
!   reloc[637]: knd=0, off=5619, siz=4, lab1=.L2196, lab2=, loff=0
!   reloc[638]: knd=0, off=5627, siz=4, lab1=.L2198, lab2=, loff=0
!   reloc[639]: knd=0, off=5635, siz=4, lab1=.L2204, lab2=, loff=0
!   reloc[640]: knd=0, off=5643, siz=4, lab1=.L2208, lab2=, loff=0
!   reloc[641]: knd=0, off=5651, siz=4, lab1=.L2210, lab2=, loff=0
!   reloc[642]: knd=0, off=5659, siz=4, lab1=.L2216, lab2=, loff=0
!   reloc[643]: knd=0, off=5669, siz=4, lab1=.L2220, lab2=, loff=0
!   reloc[644]: knd=0, off=5677, siz=4, lab1=.L2223, lab2=, loff=0
!   reloc[645]: knd=0, off=5685, siz=4, lab1=.L2228, lab2=, loff=0
!   reloc[646]: knd=0, off=5695, siz=4, lab1=.L2229, lab2=, loff=0
!   reloc[647]: knd=0, off=5703, siz=4, lab1=.L2230, lab2=, loff=0
!   reloc[648]: knd=0, off=5711, siz=4, lab1=.L2236, lab2=, loff=0
!   reloc[649]: knd=0, off=5721, siz=4, lab1=.L2237, lab2=, loff=0
!   reloc[650]: knd=0, off=5729, siz=4, lab1=.L2238, lab2=, loff=0
!   reloc[651]: knd=0, off=5737, siz=4, lab1=.L2239, lab2=, loff=0
!   reloc[652]: knd=0, off=5745, siz=4, lab1=.L2240, lab2=, loff=0
!   reloc[653]: knd=0, off=5753, siz=4, lab1=.L2246, lab2=, loff=0
!   reloc[654]: knd=0, off=5763, siz=4, lab1=.L2250, lab2=, loff=0
!   reloc[655]: knd=0, off=5771, siz=4, lab1=.L2254, lab2=, loff=0
!   reloc[656]: knd=0, off=5781, siz=4, lab1=.L2257, lab2=, loff=0
!   reloc[657]: knd=0, off=5791, siz=4, lab1=.L2261, lab2=, loff=0
!   reloc[658]: knd=0, off=5801, siz=4, lab1=.L2272, lab2=, loff=0
!   reloc[659]: knd=0, off=5811, siz=4, lab1=.L2276, lab2=, loff=0
!   reloc[660]: knd=0, off=5819, siz=4, lab1=.L2278, lab2=, loff=0
!   reloc[661]: knd=0, off=5827, siz=4, lab1=.L2284, lab2=, loff=0
!   reloc[662]: knd=0, off=5835, siz=4, lab1=.L2289, lab2=, loff=0
!   reloc[663]: knd=0, off=5843, siz=4, lab1=.L2291, lab2=, loff=0
!   reloc[664]: knd=0, off=5851, siz=4, lab1=.L2295, lab2=, loff=0
!   reloc[665]: knd=0, off=5859, siz=4, lab1=.L2298, lab2=, loff=0
!   reloc[666]: knd=0, off=5867, siz=4, lab1=.L2305, lab2=, loff=0
!   reloc[667]: knd=0, off=5875, siz=4, lab1=.L2307, lab2=, loff=0
!   reloc[668]: knd=0, off=5883, siz=4, lab1=.L2311, lab2=, loff=0
!   reloc[669]: knd=0, off=5891, siz=4, lab1=.L2314, lab2=, loff=0
!   reloc[670]: knd=0, off=5899, siz=4, lab1=.L2318, lab2=, loff=0
!   reloc[671]: knd=0, off=5907, siz=4, lab1=.L2320, lab2=, loff=0
!   reloc[672]: knd=0, off=5915, siz=4, lab1=.L2324, lab2=, loff=0
!   reloc[673]: knd=0, off=5925, siz=4, lab1=.L2329, lab2=, loff=0
!   reloc[674]: knd=0, off=5938, siz=4, lab1=gl_TexSubImage2D, lab2=, loff=0
!   reloc[675]: knd=0, off=5945, siz=4, lab1=.L2338, lab2=, loff=0
!   reloc[676]: knd=0, off=5957, siz=4, lab1=.L2342, lab2=, loff=0
!   reloc[677]: knd=0, off=5965, siz=4, lab1=.L2344, lab2=, loff=0
!   reloc[678]: knd=0, off=5973, siz=4, lab1=.L2350, lab2=, loff=0
!   reloc[679]: knd=0, off=5981, siz=4, lab1=.L2356, lab2=, loff=0
!   reloc[680]: knd=0, off=5989, siz=4, lab1=.L2358, lab2=, loff=0
!   reloc[681]: knd=0, off=5997, siz=4, lab1=.L2362, lab2=, loff=0
!   reloc[682]: knd=0, off=6007, siz=4, lab1=.L2365, lab2=, loff=0
!   reloc[683]: knd=0, off=6015, siz=4, lab1=.L2369, lab2=, loff=0
!   reloc[684]: knd=0, off=6023, siz=4, lab1=.L2371, lab2=, loff=0
!   reloc[685]: knd=0, off=6031, siz=4, lab1=.L2377, lab2=, loff=0
!   reloc[686]: knd=0, off=6041, siz=4, lab1=.L2381, lab2=, loff=0
!   reloc[687]: knd=0, off=6049, siz=4, lab1=.L2383, lab2=, loff=0
!   reloc[688]: knd=0, off=6057, siz=4, lab1=.L2389, lab2=, loff=0
!   reloc[689]: knd=0, off=6065, siz=4, lab1=.L2393, lab2=, loff=0
!   reloc[690]: knd=0, off=6073, siz=4, lab1=.L2395, lab2=, loff=0
!   reloc[691]: knd=0, off=6081, siz=4, lab1=.L2401, lab2=, loff=0
!   reloc[692]: knd=0, off=6089, siz=4, lab1=.L2405, lab2=, loff=0
!   reloc[693]: knd=0, off=6097, siz=4, lab1=.L2407, lab2=, loff=0
!   reloc[694]: knd=0, off=6105, siz=4, lab1=.L2413, lab2=, loff=0
!   reloc[695]: knd=0, off=6113, siz=4, lab1=.L2417, lab2=, loff=0
!   reloc[696]: knd=0, off=6121, siz=4, lab1=.L2419, lab2=, loff=0
!   reloc[697]: knd=0, off=6129, siz=4, lab1=.L2425, lab2=, loff=0
!   reloc[698]: knd=0, off=6139, siz=4, lab1=.L2429, lab2=, loff=0
!   reloc[699]: knd=0, off=6147, siz=4, lab1=.L2432, lab2=, loff=0
!   reloc[700]: knd=0, off=6155, siz=4, lab1=.L2437, lab2=, loff=0
!   reloc[701]: knd=0, off=6165, siz=4, lab1=.L2438, lab2=, loff=0
!   reloc[702]: knd=0, off=6173, siz=4, lab1=.L2440, lab2=, loff=0
!   reloc[703]: knd=0, off=6181, siz=4, lab1=.L2447, lab2=, loff=0
!   reloc[704]: knd=0, off=6189, siz=4, lab1=.L2448, lab2=, loff=0
!   reloc[705]: knd=0, off=6197, siz=4, lab1=.L2449, lab2=, loff=0
!   reloc[706]: knd=0, off=6205, siz=4, lab1=.L2452, lab2=, loff=0
!   reloc[707]: knd=0, off=6215, siz=4, lab1=.L2460, lab2=, loff=0
!   reloc[708]: knd=0, off=6225, siz=4, lab1=.L2461, lab2=, loff=0
!   reloc[709]: knd=0, off=6233, siz=4, lab1=.L2462, lab2=, loff=0
!   reloc[710]: knd=0, off=6241, siz=4, lab1=.L2464, lab2=, loff=0
!   reloc[711]: knd=0, off=6249, siz=4, lab1=.L2471, lab2=, loff=0
!   reloc[712]: knd=0, off=6257, siz=4, lab1=.L2472, lab2=, loff=0
!   reloc[713]: knd=0, off=6265, siz=4, lab1=.L2473, lab2=, loff=0
!   reloc[714]: knd=0, off=6273, siz=4, lab1=.L2476, lab2=, loff=0
!   reloc[715]: knd=0, off=6283, siz=4, lab1=.L2479, lab2=, loff=0
!   reloc[716]: knd=0, off=6293, siz=4, lab1=.L2485, lab2=, loff=0
!   reloc[717]: knd=0, off=6303, siz=4, lab1=.L2489, lab2=, loff=0
!   reloc[718]: knd=0, off=6311, siz=4, lab1=.L2493, lab2=, loff=0
!   reloc[719]: knd=0, off=6321, siz=4, lab1=.L2496, lab2=, loff=0
!   reloc[720]: knd=0, off=6331, siz=4, lab1=.L2500, lab2=, loff=0
!   reloc[721]: knd=0, off=6341, siz=4, lab1=.L2511, lab2=, loff=0
!   reloc[722]: knd=0, off=6351, siz=4, lab1=.L2515, lab2=, loff=0
!   reloc[723]: knd=0, off=6359, siz=4, lab1=.L2517, lab2=, loff=0
!   reloc[724]: knd=0, off=6367, siz=4, lab1=.L2523, lab2=, loff=0
!   reloc[725]: knd=0, off=6375, siz=4, lab1=.L2527, lab2=, loff=0
!   reloc[726]: knd=0, off=6383, siz=4, lab1=.L2529, lab2=, loff=0
!   reloc[727]: knd=0, off=6391, siz=4, lab1=.L2535, lab2=, loff=0
!   reloc[728]: knd=0, off=6399, siz=4, lab1=.L2540, lab2=, loff=0
!   reloc[729]: knd=0, off=6407, siz=4, lab1=.L2542, lab2=, loff=0
!   reloc[730]: knd=0, off=6415, siz=4, lab1=.L2546, lab2=, loff=0
!   reloc[731]: knd=0, off=6423, siz=4, lab1=.L2549, lab2=, loff=0
!   reloc[732]: knd=0, off=6431, siz=4, lab1=.L2556, lab2=, loff=0
!   reloc[733]: knd=0, off=6439, siz=4, lab1=.L2558, lab2=, loff=0
!   reloc[734]: knd=0, off=6447, siz=4, lab1=.L2562, lab2=, loff=0
!   reloc[735]: knd=0, off=6455, siz=4, lab1=.L2565, lab2=, loff=0
!   reloc[736]: knd=0, off=6463, siz=4, lab1=.L2569, lab2=, loff=0
!   reloc[737]: knd=0, off=6471, siz=4, lab1=.L2571, lab2=, loff=0
!   reloc[738]: knd=0, off=6479, siz=4, lab1=.L2575, lab2=, loff=0
!   reloc[739]: knd=0, off=6489, siz=4, lab1=.L2580, lab2=, loff=0
!   reloc[740]: knd=0, off=6502, siz=4, lab1=gl_TexSubImage3DEXT, lab2=, loff=0
!   reloc[741]: knd=0, off=6509, siz=4, lab1=.L2589, lab2=, loff=0
!   reloc[742]: knd=0, off=6521, siz=4, lab1=.L2593, lab2=, loff=0
!   reloc[743]: knd=0, off=6529, siz=4, lab1=.L2595, lab2=, loff=0
!   reloc[744]: knd=0, off=6537, siz=4, lab1=.L2601, lab2=, loff=0
!   reloc[745]: knd=0, off=6545, siz=4, lab1=.L2607, lab2=, loff=0
!   reloc[746]: knd=0, off=6553, siz=4, lab1=.L2609, lab2=, loff=0
!   reloc[747]: knd=0, off=6561, siz=4, lab1=.L2613, lab2=, loff=0
!   reloc[748]: knd=0, off=6571, siz=4, lab1=.L2616, lab2=, loff=0
!   reloc[749]: knd=0, off=6579, siz=4, lab1=.L2620, lab2=, loff=0
!   reloc[750]: knd=0, off=6587, siz=4, lab1=.L2622, lab2=, loff=0
!   reloc[751]: knd=0, off=6595, siz=4, lab1=.L2628, lab2=, loff=0
!   reloc[752]: knd=0, off=6605, siz=4, lab1=.L2632, lab2=, loff=0
!   reloc[753]: knd=0, off=6613, siz=4, lab1=.L2634, lab2=, loff=0
!   reloc[754]: knd=0, off=6621, siz=4, lab1=.L2640, lab2=, loff=0
!   reloc[755]: knd=0, off=6629, siz=4, lab1=.L2644, lab2=, loff=0
!   reloc[756]: knd=0, off=6637, siz=4, lab1=.L2646, lab2=, loff=0
!   reloc[757]: knd=0, off=6645, siz=4, lab1=.L2652, lab2=, loff=0
!   reloc[758]: knd=0, off=6653, siz=4, lab1=.L2656, lab2=, loff=0
!   reloc[759]: knd=0, off=6661, siz=4, lab1=.L2658, lab2=, loff=0
!   reloc[760]: knd=0, off=6669, siz=4, lab1=.L2664, lab2=, loff=0
!   reloc[761]: knd=0, off=6677, siz=4, lab1=.L2668, lab2=, loff=0
!   reloc[762]: knd=0, off=6685, siz=4, lab1=.L2670, lab2=, loff=0
!   reloc[763]: knd=0, off=6693, siz=4, lab1=.L2676, lab2=, loff=0
!   reloc[764]: knd=0, off=6701, siz=4, lab1=.L2680, lab2=, loff=0
!   reloc[765]: knd=0, off=6709, siz=4, lab1=.L2682, lab2=, loff=0
!   reloc[766]: knd=0, off=6717, siz=4, lab1=.L2688, lab2=, loff=0
!   reloc[767]: knd=0, off=6725, siz=4, lab1=.L2692, lab2=, loff=0
!   reloc[768]: knd=0, off=6733, siz=4, lab1=.L2694, lab2=, loff=0
!   reloc[769]: knd=0, off=6741, siz=4, lab1=.L2700, lab2=, loff=0
!   reloc[770]: knd=0, off=6751, siz=4, lab1=.L2704, lab2=, loff=0
!   reloc[771]: knd=0, off=6759, siz=4, lab1=.L2705, lab2=, loff=0
!   reloc[772]: knd=0, off=6767, siz=4, lab1=.L2706, lab2=, loff=0
!   reloc[773]: knd=0, off=6775, siz=4, lab1=.L2709, lab2=, loff=0
!   reloc[774]: knd=0, off=6783, siz=4, lab1=.L2714, lab2=, loff=0
!   reloc[775]: knd=0, off=6793, siz=4, lab1=.L2715, lab2=, loff=0
!   reloc[776]: knd=0, off=6801, siz=4, lab1=.L2717, lab2=, loff=0
!   reloc[777]: knd=0, off=6809, siz=4, lab1=.L2725, lab2=, loff=0
!   reloc[778]: knd=0, off=6817, siz=4, lab1=.L2732, lab2=, loff=0
!   reloc[779]: knd=0, off=6825, siz=4, lab1=.L2733, lab2=, loff=0
!   reloc[780]: knd=0, off=6833, siz=4, lab1=.L2734, lab2=, loff=0
!   reloc[781]: knd=0, off=6841, siz=4, lab1=.L2737, lab2=, loff=0
!   reloc[782]: knd=0, off=6851, siz=4, lab1=.L2740, lab2=, loff=0
!   reloc[783]: knd=0, off=6861, siz=4, lab1=.L2741, lab2=, loff=0
!   reloc[784]: knd=0, off=6869, siz=4, lab1=.L2744, lab2=, loff=0
!   reloc[785]: knd=0, off=6879, siz=4, lab1=.L2752, lab2=, loff=0
!   reloc[786]: knd=0, off=6889, siz=4, lab1=.L2753, lab2=, loff=0
!   reloc[787]: knd=0, off=6899, siz=4, lab1=.L2754, lab2=, loff=0
!   reloc[788]: knd=0, off=6907, siz=4, lab1=.L2756, lab2=, loff=0
!   reloc[789]: knd=0, off=6915, siz=4, lab1=.L2764, lab2=, loff=0
!   reloc[790]: knd=0, off=6923, siz=4, lab1=.L2771, lab2=, loff=0
!   reloc[791]: knd=0, off=6931, siz=4, lab1=.L2772, lab2=, loff=0
!   reloc[792]: knd=0, off=6939, siz=4, lab1=.L2773, lab2=, loff=0
!   reloc[793]: knd=0, off=6947, siz=4, lab1=.L2776, lab2=, loff=0
!   reloc[794]: knd=0, off=6957, siz=4, lab1=.L2779, lab2=, loff=0
!   reloc[795]: knd=0, off=6967, siz=4, lab1=.L2780, lab2=, loff=0
!   reloc[796]: knd=0, off=6975, siz=4, lab1=.L2783, lab2=, loff=0
!   reloc[797]: knd=0, off=6985, siz=4, lab1=.L2786, lab2=, loff=0
!   reloc[798]: knd=0, off=6995, siz=4, lab1=.L2792, lab2=, loff=0
!   reloc[799]: knd=0, off=7005, siz=4, lab1=.L2796, lab2=, loff=0
!   reloc[800]: knd=0, off=7013, siz=4, lab1=.L2800, lab2=, loff=0
!   reloc[801]: knd=0, off=7023, siz=4, lab1=.L2803, lab2=, loff=0
!   reloc[802]: knd=0, off=7033, siz=4, lab1=.L2807, lab2=, loff=0
!   reloc[803]: knd=0, off=7043, siz=4, lab1=.L2818, lab2=, loff=0
!   reloc[804]: knd=0, off=7053, siz=4, lab1=.L2822, lab2=, loff=0
!   reloc[805]: knd=0, off=7061, siz=4, lab1=.L2824, lab2=, loff=0
!   reloc[806]: knd=0, off=7069, siz=4, lab1=.L2830, lab2=, loff=0
!   reloc[807]: knd=0, off=7077, siz=4, lab1=.L2834, lab2=, loff=0
!   reloc[808]: knd=0, off=7085, siz=4, lab1=.L2836, lab2=, loff=0
!   reloc[809]: knd=0, off=7093, siz=4, lab1=.L2842, lab2=, loff=0
!   reloc[810]: knd=0, off=7101, siz=4, lab1=.L2846, lab2=, loff=0
!   reloc[811]: knd=0, off=7109, siz=4, lab1=.L2848, lab2=, loff=0
!   reloc[812]: knd=0, off=7117, siz=4, lab1=.L2854, lab2=, loff=0
!   reloc[813]: knd=0, off=7125, siz=4, lab1=.L2859, lab2=, loff=0
!   reloc[814]: knd=0, off=7133, siz=4, lab1=.L2861, lab2=, loff=0
!   reloc[815]: knd=0, off=7141, siz=4, lab1=.L2865, lab2=, loff=0
!   reloc[816]: knd=0, off=7149, siz=4, lab1=.L2868, lab2=, loff=0
!   reloc[817]: knd=0, off=7157, siz=4, lab1=.L2875, lab2=, loff=0
!   reloc[818]: knd=0, off=7165, siz=4, lab1=.L2877, lab2=, loff=0
!   reloc[819]: knd=0, off=7173, siz=4, lab1=.L2881, lab2=, loff=0
!   reloc[820]: knd=0, off=7181, siz=4, lab1=.L2884, lab2=, loff=0
!   reloc[821]: knd=0, off=7189, siz=4, lab1=.L2888, lab2=, loff=0
!   reloc[822]: knd=0, off=7197, siz=4, lab1=.L2890, lab2=, loff=0
!   reloc[823]: knd=0, off=7205, siz=4, lab1=.L2894, lab2=, loff=0
!   reloc[824]: knd=0, off=7215, siz=4, lab1=.L2899, lab2=, loff=0
!   reloc[825]: knd=0, off=7228, siz=4, lab1=read_color_image, lab2=, loff=0
!   reloc[826]: knd=0, off=7235, siz=4, lab1=.L2906, lab2=, loff=0
!   reloc[827]: knd=0, off=7247, siz=4, lab1=.L2907, lab2=, loff=0
!   reloc[828]: knd=0, off=7257, siz=4, lab1=.L2910, lab2=, loff=0
!   reloc[829]: knd=0, off=7265, siz=4, lab1=.L2914, lab2=, loff=0
!   reloc[830]: knd=0, off=7273, siz=4, lab1=.L2915, lab2=, loff=0
!   reloc[831]: knd=0, off=7281, siz=4, lab1=.L2916, lab2=, loff=0
!   reloc[832]: knd=0, off=7289, siz=4, lab1=.L2917, lab2=, loff=0
!   reloc[833]: knd=0, off=7297, siz=4, lab1=.L2918, lab2=, loff=0
!   reloc[834]: knd=0, off=7305, siz=4, lab1=.L2919, lab2=, loff=0
!   reloc[835]: knd=0, off=7313, siz=4, lab1=.L2920, lab2=, loff=0
!   reloc[836]: knd=0, off=7321, siz=4, lab1=.L2921, lab2=, loff=0
!   reloc[837]: knd=0, off=7329, siz=4, lab1=.L2924, lab2=, loff=0
!   reloc[838]: knd=0, off=7337, siz=4, lab1=.L2928, lab2=, loff=0
!   reloc[839]: knd=0, off=7345, siz=4, lab1=.L2929, lab2=, loff=0
!   reloc[840]: knd=0, off=7353, siz=4, lab1=.L2938, lab2=, loff=0
!   reloc[841]: knd=0, off=7363, siz=4, lab1=.L2942, lab2=, loff=0
!   reloc[842]: knd=0, off=7373, siz=4, lab1=.L2943, lab2=, loff=0
!   reloc[843]: knd=0, off=7383, siz=4, lab1=.L2945, lab2=, loff=0
!   reloc[844]: knd=0, off=7391, siz=4, lab1=.L2952, lab2=, loff=0
!   reloc[845]: knd=0, off=7401, siz=4, lab1=.L2955, lab2=, loff=0
!   reloc[846]: knd=0, off=7409, siz=4, lab1=.L2959, lab2=, loff=0
!   reloc[847]: knd=0, off=7417, siz=4, lab1=.L2960, lab2=, loff=0
!   reloc[848]: knd=0, off=7425, siz=4, lab1=.L2961, lab2=, loff=0
!   reloc[849]: knd=0, off=7433, siz=4, lab1=.L2962, lab2=, loff=0
!   reloc[850]: knd=0, off=7441, siz=4, lab1=.L2964, lab2=, loff=0
!   reloc[851]: knd=0, off=7449, siz=4, lab1=.L2971, lab2=, loff=0
!   reloc[852]: knd=0, off=7457, siz=4, lab1=.L2972, lab2=, loff=0
!   reloc[853]: knd=0, off=7465, siz=4, lab1=.L2973, lab2=, loff=0
!   reloc[854]: knd=0, off=7473, siz=4, lab1=.L2974, lab2=, loff=0
!   reloc[855]: knd=0, off=7481, siz=4, lab1=.L2977, lab2=, loff=0
!   reloc[856]: knd=0, off=7491, siz=4, lab1=.L2986, lab2=, loff=0
!   reloc[857]: knd=0, off=7501, siz=4, lab1=.L2991, lab2=, loff=0
!   reloc[858]: knd=0, off=7509, siz=4, lab1=.L2998, lab2=, loff=0
!   reloc[859]: knd=0, off=7517, siz=4, lab1=.L3001, lab2=, loff=0
!   reloc[860]: knd=0, off=7525, siz=4, lab1=.L3004, lab2=, loff=0
!   reloc[861]: knd=0, off=7535, siz=4, lab1=.L3007, lab2=, loff=0
!   reloc[862]: knd=0, off=7543, siz=4, lab1=.L3014, lab2=, loff=0
!   reloc[863]: knd=0, off=7551, siz=4, lab1=.L3017, lab2=, loff=0
!   reloc[864]: knd=0, off=7559, siz=4, lab1=.L3020, lab2=, loff=0
!   reloc[865]: knd=0, off=7569, siz=4, lab1=.L3023, lab2=, loff=0
!   reloc[866]: knd=0, off=7577, siz=4, lab1=.L3030, lab2=, loff=0
!   reloc[867]: knd=0, off=7585, siz=4, lab1=.L3031, lab2=, loff=0
!   reloc[868]: knd=0, off=7593, siz=4, lab1=.L3034, lab2=, loff=0
!   reloc[869]: knd=0, off=7603, siz=4, lab1=.L3037, lab2=, loff=0
!   reloc[870]: knd=0, off=7613, siz=4, lab1=.L3040, lab2=, loff=0
!   reloc[871]: knd=0, off=7621, siz=4, lab1=.L3047, lab2=, loff=0
!   reloc[872]: knd=0, off=7629, siz=4, lab1=.L3050, lab2=, loff=0
!   reloc[873]: knd=0, off=7637, siz=4, lab1=.L3053, lab2=, loff=0
!   reloc[874]: knd=0, off=7647, siz=4, lab1=.L3056, lab2=, loff=0
!   reloc[875]: knd=0, off=7655, siz=4, lab1=.L3063, lab2=, loff=0
!   reloc[876]: knd=0, off=7663, siz=4, lab1=.L3064, lab2=, loff=0
!   reloc[877]: knd=0, off=7671, siz=4, lab1=.L3065, lab2=, loff=0
!   reloc[878]: knd=0, off=7679, siz=4, lab1=.L3068, lab2=, loff=0
!   reloc[879]: knd=0, off=7689, siz=4, lab1=.L3071, lab2=, loff=0
!   reloc[880]: knd=0, off=7699, siz=4, lab1=.L3074, lab2=, loff=0
!   reloc[881]: knd=0, off=7707, siz=4, lab1=.L3081, lab2=, loff=0
!   reloc[882]: knd=0, off=7715, siz=4, lab1=.L3082, lab2=, loff=0
!   reloc[883]: knd=0, off=7723, siz=4, lab1=.L3083, lab2=, loff=0
!   reloc[884]: knd=0, off=7731, siz=4, lab1=.L3084, lab2=, loff=0
!   reloc[885]: knd=0, off=7739, siz=4, lab1=.L3087, lab2=, loff=0
!   reloc[886]: knd=0, off=7749, siz=4, lab1=.L3090, lab2=, loff=0
!   reloc[887]: knd=0, off=7759, siz=4, lab1=.L3093, lab2=, loff=0
!   reloc[888]: knd=0, off=7769, siz=4, lab1=.L3098, lab2=, loff=0
!   reloc[889]: knd=0, off=7779, siz=4, lab1=.L3101, lab2=, loff=0
!   reloc[890]: knd=0, off=7789, siz=4, lab1=.L3102, lab2=, loff=0
!   reloc[891]: knd=0, off=7797, siz=4, lab1=.L3103, lab2=, loff=0
!   reloc[892]: knd=0, off=7810, siz=4, lab1=gl_CopyTexImage1D, lab2=, loff=0
!   reloc[893]: knd=0, off=7817, siz=4, lab1=.L3112, lab2=, loff=0
!   reloc[894]: knd=0, off=7829, siz=4, lab1=.L3116, lab2=, loff=0
!   reloc[895]: knd=0, off=7837, siz=4, lab1=.L3118, lab2=, loff=0
!   reloc[896]: knd=0, off=7845, siz=4, lab1=.L3124, lab2=, loff=0
!   reloc[897]: knd=0, off=7853, siz=4, lab1=.L3128, lab2=, loff=0
!   reloc[898]: knd=0, off=7861, siz=4, lab1=.L3130, lab2=, loff=0
!   reloc[899]: knd=0, off=7869, siz=4, lab1=.L3136, lab2=, loff=0
!   reloc[900]: knd=0, off=7877, siz=4, lab1=.L3142, lab2=, loff=0
!   reloc[901]: knd=0, off=7885, siz=4, lab1=.L3144, lab2=, loff=0
!   reloc[902]: knd=0, off=7893, siz=4, lab1=.L3150, lab2=, loff=0
!   reloc[903]: knd=0, off=7901, siz=4, lab1=.L3155, lab2=, loff=0
!   reloc[904]: knd=0, off=7909, siz=4, lab1=.L3157, lab2=, loff=0
!   reloc[905]: knd=0, off=7917, siz=4, lab1=.L3163, lab2=, loff=0
!   reloc[906]: knd=0, off=7925, siz=4, lab1=.L3170, lab2=, loff=0
!   reloc[907]: knd=0, off=7933, siz=4, lab1=.L3172, lab2=, loff=0
!   reloc[908]: knd=0, off=7941, siz=4, lab1=.L3176, lab2=, loff=0
!   reloc[909]: knd=0, off=7949, siz=4, lab1=.L3179, lab2=, loff=0
!   reloc[910]: knd=0, off=7957, siz=4, lab1=.L3186, lab2=, loff=0
!   reloc[911]: knd=0, off=7965, siz=4, lab1=.L3188, lab2=, loff=0
!   reloc[912]: knd=0, off=7973, siz=4, lab1=.L3192, lab2=, loff=0
!   reloc[913]: knd=0, off=7983, siz=4, lab1=.L3195, lab2=, loff=0
!   reloc[914]: knd=0, off=7991, siz=4, lab1=.L3199, lab2=, loff=0
!   reloc[915]: knd=0, off=7999, siz=4, lab1=.L3201, lab2=, loff=0
!   reloc[916]: knd=0, off=8007, siz=4, lab1=.L3205, lab2=, loff=0
!   reloc[917]: knd=0, off=8017, siz=4, lab1=.L3206, lab2=, loff=0
!   reloc[918]: knd=0, off=8032, siz=4, lab1=gl_CopyTexImage2D, lab2=, loff=0
!   reloc[919]: knd=0, off=8039, siz=4, lab1=.L3215, lab2=, loff=0
!   reloc[920]: knd=0, off=8051, siz=4, lab1=.L3219, lab2=, loff=0
!   reloc[921]: knd=0, off=8059, siz=4, lab1=.L3221, lab2=, loff=0
!   reloc[922]: knd=0, off=8067, siz=4, lab1=.L3227, lab2=, loff=0
!   reloc[923]: knd=0, off=8075, siz=4, lab1=.L3231, lab2=, loff=0
!   reloc[924]: knd=0, off=8083, siz=4, lab1=.L3233, lab2=, loff=0
!   reloc[925]: knd=0, off=8091, siz=4, lab1=.L3239, lab2=, loff=0
!   reloc[926]: knd=0, off=8099, siz=4, lab1=.L3245, lab2=, loff=0
!   reloc[927]: knd=0, off=8107, siz=4, lab1=.L3247, lab2=, loff=0
!   reloc[928]: knd=0, off=8115, siz=4, lab1=.L3253, lab2=, loff=0
!   reloc[929]: knd=0, off=8123, siz=4, lab1=.L3258, lab2=, loff=0
!   reloc[930]: knd=0, off=8131, siz=4, lab1=.L3260, lab2=, loff=0
!   reloc[931]: knd=0, off=8139, siz=4, lab1=.L3266, lab2=, loff=0
!   reloc[932]: knd=0, off=8147, siz=4, lab1=.L3273, lab2=, loff=0
!   reloc[933]: knd=0, off=8155, siz=4, lab1=.L3275, lab2=, loff=0
!   reloc[934]: knd=0, off=8163, siz=4, lab1=.L3281, lab2=, loff=0
!   reloc[935]: knd=0, off=8171, siz=4, lab1=.L3288, lab2=, loff=0
!   reloc[936]: knd=0, off=8179, siz=4, lab1=.L3290, lab2=, loff=0
!   reloc[937]: knd=0, off=8187, siz=4, lab1=.L3294, lab2=, loff=0
!   reloc[938]: knd=0, off=8195, siz=4, lab1=.L3297, lab2=, loff=0
!   reloc[939]: knd=0, off=8203, siz=4, lab1=.L3304, lab2=, loff=0
!   reloc[940]: knd=0, off=8211, siz=4, lab1=.L3306, lab2=, loff=0
!   reloc[941]: knd=0, off=8219, siz=4, lab1=.L3310, lab2=, loff=0
!   reloc[942]: knd=0, off=8229, siz=4, lab1=.L3313, lab2=, loff=0
!   reloc[943]: knd=0, off=8237, siz=4, lab1=.L3317, lab2=, loff=0
!   reloc[944]: knd=0, off=8245, siz=4, lab1=.L3319, lab2=, loff=0
!   reloc[945]: knd=0, off=8253, siz=4, lab1=.L3323, lab2=, loff=0
!   reloc[946]: knd=0, off=8263, siz=4, lab1=.L3324, lab2=, loff=0
!   reloc[947]: knd=0, off=8278, siz=4, lab1=copy_tex_sub_image, lab2=, loff=0
!   reloc[948]: knd=0, off=8285, siz=4, lab1=.L3331, lab2=, loff=0
!   reloc[949]: knd=0, off=8297, siz=4, lab1=.L3332, lab2=, loff=0
!   reloc[950]: knd=0, off=8305, siz=4, lab1=.L3333, lab2=, loff=0
!   reloc[951]: knd=0, off=8313, siz=4, lab1=.L3334, lab2=, loff=0
!   reloc[952]: knd=0, off=8321, siz=4, lab1=.L3336, lab2=, loff=0
!   reloc[953]: knd=0, off=8329, siz=4, lab1=.L3343, lab2=, loff=0
!   reloc[954]: knd=0, off=8339, siz=4, lab1=.L3346, lab2=, loff=0
!   reloc[955]: knd=0, off=8347, siz=4, lab1=.L3350, lab2=, loff=0
!   reloc[956]: knd=0, off=8355, siz=4, lab1=.L3351, lab2=, loff=0
!   reloc[957]: knd=0, off=8363, siz=4, lab1=.L3352, lab2=, loff=0
!   reloc[958]: knd=0, off=8371, siz=4, lab1=.L3353, lab2=, loff=0
!   reloc[959]: knd=0, off=8379, siz=4, lab1=.L3355, lab2=, loff=0
!   reloc[960]: knd=0, off=8387, siz=4, lab1=.L3362, lab2=, loff=0
!   reloc[961]: knd=0, off=8395, siz=4, lab1=.L3363, lab2=, loff=0
!   reloc[962]: knd=0, off=8403, siz=4, lab1=.L3364, lab2=, loff=0
!   reloc[963]: knd=0, off=8411, siz=4, lab1=.L3365, lab2=, loff=0
!   reloc[964]: knd=0, off=8419, siz=4, lab1=.L3368, lab2=, loff=0
!   reloc[965]: knd=0, off=8429, siz=4, lab1=.L3374, lab2=, loff=0
!   reloc[966]: knd=0, off=8439, siz=4, lab1=.L3378, lab2=, loff=0
!   reloc[967]: knd=0, off=8447, siz=4, lab1=.L3383, lab2=, loff=0
!   reloc[968]: knd=0, off=8455, siz=4, lab1=.L3390, lab2=, loff=0
!   reloc[969]: knd=0, off=8463, siz=4, lab1=.L3393, lab2=, loff=0
!   reloc[970]: knd=0, off=8471, siz=4, lab1=.L3396, lab2=, loff=0
!   reloc[971]: knd=0, off=8481, siz=4, lab1=.L3399, lab2=, loff=0
!   reloc[972]: knd=0, off=8489, siz=4, lab1=.L3406, lab2=, loff=0
!   reloc[973]: knd=0, off=8497, siz=4, lab1=.L3409, lab2=, loff=0
!   reloc[974]: knd=0, off=8505, siz=4, lab1=.L3412, lab2=, loff=0
!   reloc[975]: knd=0, off=8515, siz=4, lab1=.L3415, lab2=, loff=0
!   reloc[976]: knd=0, off=8523, siz=4, lab1=.L3422, lab2=, loff=0
!   reloc[977]: knd=0, off=8531, siz=4, lab1=.L3423, lab2=, loff=0
!   reloc[978]: knd=0, off=8539, siz=4, lab1=.L3426, lab2=, loff=0
!   reloc[979]: knd=0, off=8549, siz=4, lab1=.L3429, lab2=, loff=0
!   reloc[980]: knd=0, off=8559, siz=4, lab1=.L3432, lab2=, loff=0
!   reloc[981]: knd=0, off=8567, siz=4, lab1=.L3439, lab2=, loff=0
!   reloc[982]: knd=0, off=8575, siz=4, lab1=.L3442, lab2=, loff=0
!   reloc[983]: knd=0, off=8583, siz=4, lab1=.L3445, lab2=, loff=0
!   reloc[984]: knd=0, off=8593, siz=4, lab1=.L3448, lab2=, loff=0
!   reloc[985]: knd=0, off=8601, siz=4, lab1=.L3455, lab2=, loff=0
!   reloc[986]: knd=0, off=8609, siz=4, lab1=.L3456, lab2=, loff=0
!   reloc[987]: knd=0, off=8617, siz=4, lab1=.L3457, lab2=, loff=0
!   reloc[988]: knd=0, off=8625, siz=4, lab1=.L3460, lab2=, loff=0
!   reloc[989]: knd=0, off=8635, siz=4, lab1=.L3463, lab2=, loff=0
!   reloc[990]: knd=0, off=8645, siz=4, lab1=.L3466, lab2=, loff=0
!   reloc[991]: knd=0, off=8653, siz=4, lab1=.L3473, lab2=, loff=0
!   reloc[992]: knd=0, off=8661, siz=4, lab1=.L3474, lab2=, loff=0
!   reloc[993]: knd=0, off=8669, siz=4, lab1=.L3475, lab2=, loff=0
!   reloc[994]: knd=0, off=8677, siz=4, lab1=.L3476, lab2=, loff=0
!   reloc[995]: knd=0, off=8685, siz=4, lab1=.L3479, lab2=, loff=0
!   reloc[996]: knd=0, off=8695, siz=4, lab1=.L3482, lab2=, loff=0
!   reloc[997]: knd=0, off=8705, siz=4, lab1=.L3485, lab2=, loff=0
!   reloc[998]: knd=0, off=8715, siz=4, lab1=.L3490, lab2=, loff=0
!   reloc[999]: knd=0, off=8725, siz=4, lab1=.L3493, lab2=, loff=0
!   reloc[1000]: knd=0, off=8740, siz=4, lab1=gl_CopyTexSubImage1D, lab2=, loff=0
!   reloc[1001]: knd=0, off=8747, siz=4, lab1=.L3502, lab2=, loff=0
!   reloc[1002]: knd=0, off=8759, siz=4, lab1=.L3506, lab2=, loff=0
!   reloc[1003]: knd=0, off=8767, siz=4, lab1=.L3508, lab2=, loff=0
!   reloc[1004]: knd=0, off=8775, siz=4, lab1=.L3514, lab2=, loff=0
!   reloc[1005]: knd=0, off=8783, siz=4, lab1=.L3518, lab2=, loff=0
!   reloc[1006]: knd=0, off=8791, siz=4, lab1=.L3520, lab2=, loff=0
!   reloc[1007]: knd=0, off=8799, siz=4, lab1=.L3526, lab2=, loff=0
!   reloc[1008]: knd=0, off=8807, siz=4, lab1=.L3532, lab2=, loff=0
!   reloc[1009]: knd=0, off=8815, siz=4, lab1=.L3534, lab2=, loff=0
!   reloc[1010]: knd=0, off=8823, siz=4, lab1=.L3540, lab2=, loff=0
!   reloc[1011]: knd=0, off=8831, siz=4, lab1=.L3544, lab2=, loff=0
!   reloc[1012]: knd=0, off=8839, siz=4, lab1=.L3546, lab2=, loff=0
!   reloc[1013]: knd=0, off=8847, siz=4, lab1=.L3550, lab2=, loff=0
!   reloc[1014]: knd=0, off=8857, siz=4, lab1=.L3553, lab2=, loff=0
!   reloc[1015]: knd=0, off=8865, siz=4, lab1=.L3559, lab2=, loff=0
!   reloc[1016]: knd=0, off=8873, siz=4, lab1=.L3563, lab2=, loff=0
!   reloc[1017]: knd=0, off=8881, siz=4, lab1=.L3565, lab2=, loff=0
!   reloc[1018]: knd=0, off=8889, siz=4, lab1=.L3571, lab2=, loff=0
!   reloc[1019]: knd=0, off=8899, siz=4, lab1=.L3575, lab2=, loff=0
!   reloc[1020]: knd=0, off=8907, siz=4, lab1=.L3577, lab2=, loff=0
!   reloc[1021]: knd=0, off=8915, siz=4, lab1=.L3583, lab2=, loff=0
!   reloc[1022]: knd=0, off=8923, siz=4, lab1=.L3587, lab2=, loff=0
!   reloc[1023]: knd=0, off=8931, siz=4, lab1=.L3596, lab2=, loff=0
!   reloc[1024]: knd=0, off=8941, siz=4, lab1=.L3601, lab2=, loff=0
!   reloc[1025]: knd=0, off=8954, siz=4, lab1=gl_CopyTexSubImage2D, lab2=, loff=0
!   reloc[1026]: knd=0, off=8961, siz=4, lab1=.L3610, lab2=, loff=0
!   reloc[1027]: knd=0, off=8973, siz=4, lab1=.L3614, lab2=, loff=0
!   reloc[1028]: knd=0, off=8981, siz=4, lab1=.L3616, lab2=, loff=0
!   reloc[1029]: knd=0, off=8989, siz=4, lab1=.L3622, lab2=, loff=0
!   reloc[1030]: knd=0, off=8997, siz=4, lab1=.L3626, lab2=, loff=0
!   reloc[1031]: knd=0, off=9005, siz=4, lab1=.L3628, lab2=, loff=0
!   reloc[1032]: knd=0, off=9013, siz=4, lab1=.L3634, lab2=, loff=0
!   reloc[1033]: knd=0, off=9021, siz=4, lab1=.L3640, lab2=, loff=0
!   reloc[1034]: knd=0, off=9029, siz=4, lab1=.L3642, lab2=, loff=0
!   reloc[1035]: knd=0, off=9037, siz=4, lab1=.L3648, lab2=, loff=0
!   reloc[1036]: knd=0, off=9045, siz=4, lab1=.L3652, lab2=, loff=0
!   reloc[1037]: knd=0, off=9053, siz=4, lab1=.L3654, lab2=, loff=0
!   reloc[1038]: knd=0, off=9061, siz=4, lab1=.L3660, lab2=, loff=0
!   reloc[1039]: knd=0, off=9069, siz=4, lab1=.L3664, lab2=, loff=0
!   reloc[1040]: knd=0, off=9077, siz=4, lab1=.L3666, lab2=, loff=0
!   reloc[1041]: knd=0, off=9085, siz=4, lab1=.L3670, lab2=, loff=0
!   reloc[1042]: knd=0, off=9095, siz=4, lab1=.L3673, lab2=, loff=0
!   reloc[1043]: knd=0, off=9103, siz=4, lab1=.L3679, lab2=, loff=0
!   reloc[1044]: knd=0, off=9111, siz=4, lab1=.L3683, lab2=, loff=0
!   reloc[1045]: knd=0, off=9119, siz=4, lab1=.L3685, lab2=, loff=0
!   reloc[1046]: knd=0, off=9127, siz=4, lab1=.L3691, lab2=, loff=0
!   reloc[1047]: knd=0, off=9135, siz=4, lab1=.L3695, lab2=, loff=0
!   reloc[1048]: knd=0, off=9143, siz=4, lab1=.L3697, lab2=, loff=0
!   reloc[1049]: knd=0, off=9151, siz=4, lab1=.L3703, lab2=, loff=0
!   reloc[1050]: knd=0, off=9161, siz=4, lab1=.L3707, lab2=, loff=0
!   reloc[1051]: knd=0, off=9169, siz=4, lab1=.L3709, lab2=, loff=0
!   reloc[1052]: knd=0, off=9177, siz=4, lab1=.L3715, lab2=, loff=0
!   reloc[1053]: knd=0, off=9185, siz=4, lab1=.L3719, lab2=, loff=0
!   reloc[1054]: knd=0, off=9193, siz=4, lab1=.L3721, lab2=, loff=0
!   reloc[1055]: knd=0, off=9201, siz=4, lab1=.L3727, lab2=, loff=0
!   reloc[1056]: knd=0, off=9211, siz=4, lab1=.L3731, lab2=, loff=0
!   reloc[1057]: knd=0, off=9219, siz=4, lab1=.L3740, lab2=, loff=0
!   reloc[1058]: knd=0, off=9229, siz=4, lab1=.L3745, lab2=, loff=0
!   reloc[1059]: knd=0, off=9242, siz=4, lab1=gl_CopyTexSubImage3DEXT, lab2=, loff=0
!   reloc[1060]: knd=0, off=9249, siz=4, lab1=.L3754, lab2=, loff=0
!   reloc[1061]: knd=0, off=9261, siz=4, lab1=.L3758, lab2=, loff=0
!   reloc[1062]: knd=0, off=9269, siz=4, lab1=.L3760, lab2=, loff=0
!   reloc[1063]: knd=0, off=9277, siz=4, lab1=.L3766, lab2=, loff=0
!   reloc[1064]: knd=0, off=9285, siz=4, lab1=.L3770, lab2=, loff=0
!   reloc[1065]: knd=0, off=9293, siz=4, lab1=.L3772, lab2=, loff=0
!   reloc[1066]: knd=0, off=9301, siz=4, lab1=.L3778, lab2=, loff=0
!   reloc[1067]: knd=0, off=9309, siz=4, lab1=.L3784, lab2=, loff=0
!   reloc[1068]: knd=0, off=9317, siz=4, lab1=.L3786, lab2=, loff=0
!   reloc[1069]: knd=0, off=9325, siz=4, lab1=.L3792, lab2=, loff=0
!   reloc[1070]: knd=0, off=9333, siz=4, lab1=.L3796, lab2=, loff=0
!   reloc[1071]: knd=0, off=9341, siz=4, lab1=.L3798, lab2=, loff=0
!   reloc[1072]: knd=0, off=9349, siz=4, lab1=.L3804, lab2=, loff=0
!   reloc[1073]: knd=0, off=9357, siz=4, lab1=.L3808, lab2=, loff=0
!   reloc[1074]: knd=0, off=9365, siz=4, lab1=.L3810, lab2=, loff=0
!   reloc[1075]: knd=0, off=9373, siz=4, lab1=.L3814, lab2=, loff=0
!   reloc[1076]: knd=0, off=9383, siz=4, lab1=.L3817, lab2=, loff=0
!   reloc[1077]: knd=0, off=9391, siz=4, lab1=.L3823, lab2=, loff=0
!   reloc[1078]: knd=0, off=9399, siz=4, lab1=.L3827, lab2=, loff=0
!   reloc[1079]: knd=0, off=9407, siz=4, lab1=.L3829, lab2=, loff=0
!   reloc[1080]: knd=0, off=9415, siz=4, lab1=.L3835, lab2=, loff=0
!   reloc[1081]: knd=0, off=9423, siz=4, lab1=.L3839, lab2=, loff=0
!   reloc[1082]: knd=0, off=9431, siz=4, lab1=.L3841, lab2=, loff=0
!   reloc[1083]: knd=0, off=9439, siz=4, lab1=.L3847, lab2=, loff=0
!   reloc[1084]: knd=0, off=9447, siz=4, lab1=.L3851, lab2=, loff=0
!   reloc[1085]: knd=0, off=9455, siz=4, lab1=.L3853, lab2=, loff=0
!   reloc[1086]: knd=0, off=9463, siz=4, lab1=.L3859, lab2=, loff=0
!   reloc[1087]: knd=0, off=9473, siz=4, lab1=.L3863, lab2=, loff=0
!   reloc[1088]: knd=0, off=9481, siz=4, lab1=.L3865, lab2=, loff=0
!   reloc[1089]: knd=0, off=9489, siz=4, lab1=.L3871, lab2=, loff=0
!   reloc[1090]: knd=0, off=9497, siz=4, lab1=.L3875, lab2=, loff=0
!   reloc[1091]: knd=0, off=9505, siz=4, lab1=.L3877, lab2=, loff=0
!   reloc[1092]: knd=0, off=9513, siz=4, lab1=.L3883, lab2=, loff=0
!   reloc[1093]: knd=0, off=9521, siz=4, lab1=.L3887, lab2=, loff=0
!   reloc[1094]: knd=0, off=9529, siz=4, lab1=.L3889, lab2=, loff=0
!   reloc[1095]: knd=0, off=9537, siz=4, lab1=.L3895, lab2=, loff=0
!   reloc[1096]: knd=0, off=9547, siz=4, lab1=.L3899, lab2=, loff=0
!   reloc[1097]: knd=0, off=9555, siz=4, lab1=.L3908, lab2=, loff=0
!   reloc[1098]: knd=0, off=9565, siz=4, lab1=.L3913, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x25,0x63,0x00,0x02,0x00,0x00
	.byte 0x00,0x73,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x74,0x65,0x78,0x69,0x6d
	.byte 0x61,0x67,0x65,0x2e,0x63,0x00,0x01,0x00
	.byte 0x00,0x67,0x6c,0x2e,0x68,0x00,0x02,0x00
	.byte 0x00,0x74,0x79,0x70,0x65,0x73,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x64,0x64,0x2e,0x68
	.byte 0x00,0x01,0x00,0x00,0x00,0x00,0x05,0x02
	.uaword logbase2
	.byte 0x00,0x05,0x02
	.uaword .L16
	.byte 0x06,0x03,0x9b,0x01,0x01,0x00,0x05,0x02
	.uaword .L17
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L20
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L24
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L32
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L36
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L37
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L40
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L45
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L49
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L54
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L58
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword decode_internal_format
	.byte 0x00,0x05,0x02
	.uaword .L68
	.byte 0x06,0x03,0xb8,0x01,0x01,0x00,0x05,0x02
	.uaword .L76
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L83
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L92
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L98
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L108
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L118
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L125
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L127
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L130
	.byte 0x03,0x47,0x01,0x00,0x05,0x02
	.uaword .L133
	.byte 0x03,0x3b,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword components_in_intformat
	.byte 0x00,0x05,0x02
	.uaword .L143
	.byte 0x06,0x03,0xff,0x01,0x01,0x00,0x05,0x02
	.uaword .L151
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L158
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L167
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L173
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L183
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L193
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L200
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L202
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L205
	.byte 0x03,0x47,0x01,0x00,0x05,0x02
	.uaword .L208
	.byte 0x03,0x3b,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_alloc_texture_image
	.byte 0x00,0x05,0x02
	.uaword .L215
	.byte 0x06,0x03,0xc0,0x02,0x01,0x00,0x05,0x02
	.uaword .L216
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_free_texture_image
	.byte 0x00,0x05,0x02
	.uaword .L225
	.byte 0x06,0x03,0xc7,0x02,0x01,0x00,0x05,0x02
	.uaword .L229
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L233
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L234
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword image_to_texture
	.byte 0x00,0x05,0x02
	.uaword .L241
	.byte 0x06,0x03,0xe0,0x02,0x01,0x00,0x05,0x02
	.uaword .L248
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L255
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L262
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L269
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L270
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L271
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L274
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L277
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L280
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L281
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L283
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L285
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L286
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L289
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L292
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L296
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L301
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L308
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L311
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L312
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L314
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L319
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L333
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L342
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L346
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L347
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L353
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L365
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L371
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L378
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L383
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L384
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L385
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L386
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L387
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L388
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L389
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L390
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L398
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L405
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L414
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L418
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L421
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L425
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L426
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L432
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L436
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L442
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L446
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L448
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L449
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L450
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L454
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L458
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L459
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L461
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L462
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L464
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L465
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L466
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L468
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L469
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L471
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L474
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L476
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L477
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L478
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L479
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L480
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L482
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L484
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L487
	.byte 0x03,0x65,0x01,0x00,0x05,0x02
	.uaword .L492
	.byte 0x03,0x66,0x01,0x00,0x05,0x02
	.uaword .L497
	.byte 0x03,0x38,0x01,0x00,0x05,0x02
	.uaword .L501
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L507
	.byte 0x03,0x45,0x01,0x00,0x05,0x02
	.uaword .L511
	.byte 0x03,0x3f,0x01,0x00,0x05,0x02
	.uaword .L514
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L524
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L530
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L534
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L535
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L541
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L542
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L543
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L545
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L549
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L551
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L552
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L553
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L554
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L555
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L557
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L558
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L559
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L560
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L561
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L563
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L564
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L566
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L567
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L569
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L570
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L571
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L572
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L573
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L575
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L576
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L578
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L579
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L581
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L582
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L583
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L584
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L585
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L587
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L588
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L589
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L590
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L591
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L593
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L594
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L595
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L596
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L597
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L599
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L601
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L604
	.byte 0x03,0xbd,0x7f,0x01,0x00,0x05,0x02
	.uaword .L609
	.byte 0x03,0xc6,0x00,0x01,0x00,0x05,0x02
	.uaword .L615
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L616
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L617
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L618
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L621
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L625
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L626
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L627
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L628
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L629
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L636
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L643
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L650
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L662
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L666
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L667
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L669
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L670
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L671
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L672
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L673
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L677
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L678
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L679
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L687
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
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
	.uaword .L702
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L704
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L707
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L708
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L709
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L710
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L712
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L713
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L716
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L718
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L720
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L723
	.byte 0x03,0x62,0x01,0x00,0x05,0x02
	.uaword .L728
	.byte 0x03,0x95,0x7f,0x01,0x00,0x05,0x02
	.uaword .L731
	.byte 0x03,0x8c,0x01,0x01,0x00,0x05,0x02
	.uaword .L734
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L744
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L750
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L754
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L755
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L761
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L762
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L763
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L764
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L765
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L766
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L767
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L770
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L774
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L780
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L784
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L785
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L786
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L787
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L791
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L793
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L794
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L795
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L797
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L799
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L800
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L801
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L802
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L803
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L805
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L806
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L807
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L809
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L811
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L813
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L815
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L817
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L818
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L819
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L820
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L821
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L823
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L824
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L825
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L826
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L827
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L829
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L830
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L831
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L832
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L833
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L835
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L836
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L837
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L838
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L839
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L841
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L843
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L846
	.byte 0x03,0xae,0x7f,0x01,0x00,0x05,0x02
	.uaword .L851
	.byte 0x03,0xd5,0x00,0x01,0x00,0x05,0x02
	.uaword .L857
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L862
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L863
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L864
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L865
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L872
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L879
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L886
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L898
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L902
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L903
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L904
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L905
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L906
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L907
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L908
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L909
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L919
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L923
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L924
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L926
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L927
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L929
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L930
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L932
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L933
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L934
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L936
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L937
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L939
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L940
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L941
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L942
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L944
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L945
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L946
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L947
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L948
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L950
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L952
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L955
	.byte 0x03,0x61,0x01,0x00,0x05,0x02
	.uaword .L960
	.byte 0x03,0x8f,0x7f,0x01,0x00,0x05,0x02
	.uaword .L963
	.byte 0x03,0x93,0x01,0x01,0x00,0x05,0x02
	.uaword .L965
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L967
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L970
	.byte 0x03,0x89,0x7d,0x01,0x00,0x05,0x02
	.uaword .L973
	.byte 0x03,0xfa,0x02,0x01,0x00,0x05,0x02
	.uaword .L974
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword make_null_texture
	.byte 0x00,0x05,0x02
	.uaword .L981
	.byte 0x06,0x03,0xa4,0x06,0x01,0x00,0x05,0x02
	.uaword .L982
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L983
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L986
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L989
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L992
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L993
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L994
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L995
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L996
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L997
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L998
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1001
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1004
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1008
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1013
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1016
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1020
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1023
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1024
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1025
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1026
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1030
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L1033
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1038
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1039
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1041
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1048
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1050
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1057
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1058
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1063
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1070
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1073
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L1078
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L1083
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L1089
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L1090
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword texture_1d_error_check
	.byte 0x00,0x05,0x02
	.uaword .L1099
	.byte 0x06,0x03,0xf3,0x06,0x01,0x00,0x05,0x02
	.uaword .L1104
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1106
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1112
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1118
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1120
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1124
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1127
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1131
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1133
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1139
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1146
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1150
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1155
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1161
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1169
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1173
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1184
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1188
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1190
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1197
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1209
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1213
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1216
	.byte 0x03,0x72,0x01,0x00,0x05,0x02
	.uaword .L1222
	.byte 0x03,0x10,0x01,0x00,0x05,0x02
	.uaword .L1230
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L1232
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1234
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1237
	.byte 0x03,0x76,0x01,0x00,0x05,0x02
	.uaword .L1240
	.byte 0x03,0x0c,0x01,0x00,0x05,0x02
	.uaword .L1241
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword texture_2d_error_check
	.byte 0x00,0x05,0x02
	.uaword .L1250
	.byte 0x06,0x03,0xbc,0x07,0x01,0x00,0x05,0x02
	.uaword .L1255
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1257
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1263
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1269
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1271
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1275
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1278
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1284
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1290
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1301
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1306
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1312
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1320
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1324
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1329
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1335
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1343
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1347
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1352
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1358
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1362
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1370
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1374
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1376
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1383
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1395
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1397
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1399
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1402
	.byte 0x03,0x72,0x01,0x00,0x05,0x02
	.uaword .L1408
	.byte 0x03,0x10,0x01,0x00,0x05,0x02
	.uaword .L1418
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L1420
	.byte 0x0d,0x00,0x05
	.byte 0x02
	.uaword .L1422
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1425
	.byte 0x03,0x74,0x01,0x00,0x05,0x02
	.uaword .L1428
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L1429
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword texture_3d_error_check
	.byte 0x00,0x05,0x02
	.uaword .L1438
	.byte 0x06,0x03,0x92,0x08,0x01,0x00,0x05,0x02
	.uaword .L1443
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1445
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1451
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1459
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1463
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1466
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1470
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1478
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1485
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1489
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1494
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1500
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1512
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1517
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1531
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1535
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1540
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1546
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1554
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1558
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1563
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1569
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1573
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1575
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1581
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1585
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1587
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1593
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1597
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1599
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1606
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1618
	.byte 0x03,0x0b,0x01,0x00,0x05,0x02
	.uaword .L1620
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1622
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1625
	.byte 0x03,0x72,0x01,0x00,0x05,0x02
	.uaword .L1631
	.byte 0x03,0x10,0x01,0x00,0x05,0x02
	.uaword .L1641
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L1643
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1645
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1648
	.byte 0x03,0x74,0x01,0x00,0x05,0x02
	.uaword .L1651
	.byte 0x03,0x0e,0x01,0x00,0x05,0x02
	.uaword .L1652
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexImage1D
	.byte 0x00,0x05,0x02
	.uaword .L1661
	.byte 0x06,0x03,0xf1,0x08,0x01,0x00,0x05,0x02
	.uaword .L1665
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1667
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1673
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1679
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1683
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1689
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1693
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1699
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1703
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1709
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1713
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1714
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1718
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1723
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1729
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1733
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1743
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1749
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1755
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1760
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1769
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1770
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1771
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1772
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1778
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1782
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1791
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1793
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1799
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexImage2D
	.byte 0x00,0x05,0x02
	.uaword .L1808
	.byte 0x06,0x03,0xc5,0x09,0x01,0x00,0x05,0x02
	.uaword .L1812
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1814
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1820
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1826
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1830
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1836
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1840
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1846
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1850
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1856
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1860
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1862
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1865
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1870
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1876
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1880
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1890
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1896
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1902
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1907
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1916
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1918
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1919
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1925
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1929
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1938
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1940
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1946
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexImage3DEXT
	.byte 0x00,0x05,0x02
	.uaword .L1955
	.byte 0x06,0x03,0x98,0x0a,0x01,0x00,0x05,0x02
	.uaword .L1959
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1961
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1967
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L1973
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1977
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L1983
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1987
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L1993
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L1997
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2003
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2007
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2008
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2009
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2012
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2017
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2023
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2027
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2037
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2043
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2049
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2054
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2063
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2064
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2065
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2066
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2067
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2073
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2077
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2086
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2088
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2094
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_GetTexImage
	.byte 0x00,0x05,0x02
	.uaword .L2101
	.byte 0x06,0x03,0xe7,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2103
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_unpack_texsubimage
	.byte 0x00,0x05,0x02
	.uaword .L2112
	.byte 0x06,0x03,0xf7,0x0a,0x01,0x00,0x05,0x02
	.uaword .L2117
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2123
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2129
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2135
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2139
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2143
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2144
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexSubImage1D
	.byte 0x00,0x05,0x02
	.uaword .L2153
	.byte 0x06,0x03,0x8f,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2157
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2159
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2165
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2171
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2173
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2177
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2180
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2184
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2186
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2192
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2196
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2198
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2204
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2208
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2210
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2216
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2220
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2223
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2228
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2229
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2230
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2236
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2237
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2238
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2240
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2246
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2250
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2254
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2257
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2261
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2272
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2276
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2278
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2284
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2289
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2291
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2295
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2298
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2305
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2307
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2311
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2314
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2318
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2320
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2324
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2329
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexSubImage2D
	.byte 0x00,0x05,0x02
	.uaword .L2338
	.byte 0x06,0x03,0xf2,0x0b,0x01,0x00,0x05,0x02
	.uaword .L2342
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2344
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2350
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2356
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2358
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2362
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2365
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2369
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2371
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2377
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2381
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2383
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2389
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2393
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2395
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2401
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2405
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2407
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2413
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2417
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2419
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2425
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2429
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2432
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2437
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2438
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2440
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2447
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2448
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2449
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2452
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2460
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L2461
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2462
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2464
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2471
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2472
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2476
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2479
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2485
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2489
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2493
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2496
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2500
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2511
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2517
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2523
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2527
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2529
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2535
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2540
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2542
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2546
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2549
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2556
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2558
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2562
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2569
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2571
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2575
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2580
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_TexSubImage3DEXT
	.byte 0x00,0x05,0x02
	.uaword .L2589
	.byte 0x06,0x03,0xec,0x0c,0x01,0x00,0x05,0x02
	.uaword .L2593
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2595
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2601
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2607
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2609
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2613
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2616
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2620
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2622
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2628
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2632
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2634
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2640
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2644
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2646
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2652
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2656
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2658
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2664
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2668
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2670
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2676
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2680
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2682
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2688
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2692
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2694
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2700
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2704
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2705
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2706
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2709
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2714
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2715
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2717
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2725
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2732
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2733
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2734
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2737
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2740
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2741
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2744
	.byte 0x03,0x79,0x01,0x00,0x05,0x02
	.uaword .L2752
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L2753
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2754
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2756
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2764
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2771
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2772
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2773
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2776
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L2779
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2780
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2783
	.byte 0x03,0x79,0x01,0x00,0x05,0x02
	.uaword .L2786
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L2792
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2800
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2803
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2807
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2818
	.byte 0x03,0x07,0x01,0x00,0x05,0x02
	.uaword .L2822
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2824
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2830
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2834
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2836
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2842
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2846
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2848
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2854
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2859
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2861
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2865
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2868
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2875
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2877
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2881
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2884
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2888
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2890
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2894
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2899
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword read_color_image
	.byte 0x00,0x05,0x02
	.uaword .L2906
	.byte 0x06,0x03,0x86,0x0e,0x01,0x00,0x05,0x02
	.uaword .L2907
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L2910
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2914
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2915
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2916
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2917
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2918
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2919
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2920
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2921
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2924
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2928
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2929
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2938
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L2942
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2943
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2945
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2952
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L2955
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2959
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2960
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2961
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2962
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2964
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2971
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2972
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2973
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2974
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L2977
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L2986
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L2991
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L2998
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3001
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3004
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3007
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3014
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3017
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3020
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3023
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3030
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3031
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3034
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3037
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3040
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3047
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3050
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3053
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3056
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3063
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3064
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3065
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3068
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L3071
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3074
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3081
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3082
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3083
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3084
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3087
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L3090
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L3093
	.byte 0x03,0x5c,0x01,0x00,0x05,0x02
	.uaword .L3098
	.byte 0x03,0x6d,0x01,0x00,0x05,0x02
	.uaword .L3101
	.byte 0x03,0x3d,0x01,0x00,0x05,0x02
	.uaword .L3102
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3103
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_CopyTexImage1D
	.byte 0x00,0x05,0x02
	.uaword .L3112
	.byte 0x06,0x03,0xf1,0x0e,0x01,0x00,0x05,0x02
	.uaword .L3116
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3118
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3124
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3128
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3130
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3136
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3142
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3144
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3150
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3155
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3157
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3163
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3170
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3172
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3176
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3179
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3186
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3188
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3192
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3195
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3199
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3201
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3205
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3206
	.byte 0x03,0x03,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_CopyTexImage2D
	.byte 0x00,0x05,0x02
	.uaword .L3215
	.byte 0x06,0x03,0xa1,0x0f,0x01,0x00,0x05,0x02
	.uaword .L3219
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3221
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3227
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3233
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3239
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3245
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3247
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3253
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3258
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3260
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3266
	.byte 0x0d,0x00,0x05
	.byte 0x02
	.uaword .L3273
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3275
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3281
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3288
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3290
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3294
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3297
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3306
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3310
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3317
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3319
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3323
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3324
	.byte 0x03,0x03,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword copy_tex_sub_image
	.byte 0x00,0x05,0x02
	.uaword .L3331
	.byte 0x06,0x03,0xda,0x0f,0x01,0x00,0x05,0x02
	.uaword .L3332
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3333
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3334
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3336
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3343
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3346
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3350
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3351
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3352
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3353
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3355
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3363
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3365
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3368
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L3374
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L3378
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3383
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3390
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3393
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3396
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3399
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3406
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3409
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3412
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3415
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3422
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3423
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3426
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L3429
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3432
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3439
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3442
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L3445
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3448
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3455
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3456
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3460
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L3463
	.byte 0x03,0x05,0x01,0x00,0x05,0x02
	.uaword .L3466
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3474
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3475
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3476
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3479
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L3482
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L3485
	.byte 0x03,0x5c,0x01,0x00,0x05,0x02
	.uaword .L3490
	.byte 0x03,0x69,0x01,0x00,0x05,0x02
	.uaword .L3493
	.byte 0x03,0x3e,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword gl_CopyTexSubImage1D
	.byte 0x00,0x05,0x02
	.uaword .L3502
	.byte 0x06,0x03,0xa8,0x10,0x01,0x00,0x05,0x02
	.uaword .L3506
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3508
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3514
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3518
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3520
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3526
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3532
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3534
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3540
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3544
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3546
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3550
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3553
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3559
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3563
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3565
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3571
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3575
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3577
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3583
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3587
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3596
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3601
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_CopyTexSubImage2D
	.byte 0x00,0x05,0x02
	.uaword .L3610
	.byte 0x06,0x03,0xd8,0x10,0x01,0x00,0x05,0x02
	.uaword .L3614
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3616
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3622
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3626
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3628
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3634
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3640
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3642
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3648
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3652
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3654
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3660
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3664
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3666
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3670
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3673
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3679
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3683
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3685
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3691
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3695
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3697
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3703
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3707
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3709
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3715
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3719
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3721
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3727
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3731
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3740
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3745
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword gl_CopyTexSubImage3DEXT
	.byte 0x00,0x05,0x02
	.uaword .L3754
	.byte 0x06,0x03,0x97,0x11,0x01,0x00,0x05,0x02
	.uaword .L3758
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3760
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3766
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3770
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3772
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3778
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3784
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3786
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3792
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3796
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3798
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3804
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3808
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3810
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3814
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3817
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3823
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3827
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3829
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3835
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3839
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3841
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3847
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3851
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3853
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3859
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3863
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3865
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3871
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3875
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3877
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3883
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3887
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3889
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L3895
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L3899
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L3908
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L3913
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x49,0x13,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x03,0x05,0x00,0x49,0x13,0x03,0x08
	.byte 0x3a,0x0b,0x3b,0x0b,0x02,0x0a,0x00,0x00
	.byte 0x04,0x34,0x00,0x03,0x08,0x49,0x13,0x17
	.byte 0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a,0x00
	.byte 0x00,0x05,0x24,0x00,0x03,0x08,0x3e,0x0b
	.byte 0x0b,0x0b,0x00,0x00,0x06,0x16,0x00,0x49
	.byte 0x13,0x03,0x08,0x3a,0x0b,0x00,0x00,0x07
	.byte 0x2e,0x00,0x03,0x08,0x3f,0x0c,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12,0x01
	.byte 0x40,0x0a,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x00,0x00,0x08,0x04,0x01,0x0b,0x0b
	.byte 0x3a,0x0b,0x01,0x13,0x00,0x00,0x09,0x28
	.byte 0x00,0x03,0x08,0x1c,0x0d,0x00,0x00,0x0a
	.byte 0x0f,0x00,0x49,0x13,0x00,0x00,0x0b,0x13
	.byte 0x01,0x03,0x08,0x0b,0x0b,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x0c,0x0d,0x00,0x03,0x08
	.byte 0x49,0x13,0x38,0x0a,0x00,0x00,0x0d,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x05,0x11,0x01,0x12,0x01,0x40
	.byte 0x0a,0x27,0x0c,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x0e,0x05,0x00,0x49,0x13,0x03
	.byte 0x08,0x3a,0x0b,0x3b,0x05,0x02,0x0a,0x00
	.byte 0x00,0x0f,0x2e,0x01,0x03,0x08,0x17,0x0b
	.byte 0x3a,0x0b,0x3b,0x05,0x11,0x01,0x12,0x01
	.byte 0x40,0x0a,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x10,0x34,0x00
	.byte 0x03,0x08,0x49,0x13,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x05,0x02,0x0a,0x00,0x00,0x11,0x0b
	.byte 0x01,0x11,0x01,0x12,0x01,0x00,0x00,0x12
	.byte 0x13,0x00,0x03,0x08,0x3c,0x0c,0x00,0x00
	.byte 0x13,0x01,0x01,0x49,0x13,0x0b,0x0b,0x01
	.byte 0x13,0x00,0x00,0x14,0x21,0x00,0x49,0x13
	.byte 0x2f,0x0b,0x00,0x00,0x15,0x01,0x01,0x49
	.byte 0x13,0x0b,0x05,0x01,0x13,0x00,0x00,0x16
	.byte 0x21,0x00,0x49,0x13,0x2f,0x05,0x00,0x00
	.byte 0x17,0x13,0x01,0x03,0x08,0x0b,0x05,0x3a
	.byte 0x0b,0x01,0x13,0x00,0x00,0x18,0x26,0x00
	.byte 0x49,0x13,0x00,0x00,0x19,0x15,0x01,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x1a,0x05,0x00,0x49,0x13,0x00,0x00,0x1b
	.byte 0x15,0x01,0x27,0x0c,0x49,0x13,0x88,0x44
	.byte 0x0b,0x01,0x13,0x00,0x00,0x1c,0x15,0x00
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x00
	.byte 0x00,0x1d,0x86,0x84,0x01,0x00,0x92,0x44
	.byte 0x0b,0x91,0x44,0x09,0x00,0x00,0x1e,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x05,0x11,0x01,0x12,0x01,0x40
	.byte 0x0a,0x27,0x0c,0x49,0x13,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x1f,0x2e,0x01,0x03
	.byte 0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x11
	.byte 0x01,0x12,0x01,0x40,0x0a,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x20,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x21,0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c
	.byte 0x0c,0x27,0x0c,0x49,0x13,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x22,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x01,0x68,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xb6,0x28,0x00,0x00,0x01,0xeb
	.byte 0x67,0x6c,0x5f,0x61,0x6c,0x6c,0x6f,0x63
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x69,0x6d,0x61,0x67,0x65,0x00,0x00
	.byte 0x00,0x33,0x19,0x67,0x6c,0x5f,0x66,0x72
	.byte 0x65,0x65,0x5f,0x74,0x65,0x78,0x74,0x75
	.byte 0x72,0x65,0x5f,0x69,0x6d,0x61,0x67,0x65
	.byte 0x00,0x00,0x00,0xa0,0x4f,0x67,0x6c,0x5f
	.byte 0x54,0x65,0x78,0x49,0x6d,0x61,0x67,0x65
	.byte 0x31,0x44,0x00,0x00,0x00,0xa1,0x52,0x67
	.byte 0x6c,0x5f,0x54,0x65,0x78,0x49,0x6d,0x61
	.byte 0x67,0x65,0x32,0x44,0x00,0x00,0x00,0xa2
	.byte 0x68,0x67,0x6c,0x5f,0x54,0x65,0x78,0x49
	.byte 0x6d,0x61,0x67,0x65,0x33,0x44,0x45,0x58
	.byte 0x54,0x00,0x00,0x00,0xa3,0x93,0x67,0x6c
	.byte 0x5f,0x47,0x65,0x74,0x54,0x65,0x78,0x49
	.byte 0x6d,0x61,0x67,0x65,0x00,0x00,0x00,0xa4
	.byte 0x25,0x67,0x6c,0x5f,0x75,0x6e,0x70,0x61
	.byte 0x63,0x6b,0x5f,0x74,0x65,0x78,0x73,0x75
	.byte 0x62,0x69,0x6d,0x61,0x67,0x65,0x00,0x00
	.byte 0x00,0xa4,0xde,0x67,0x6c,0x5f,0x54,0x65
	.byte 0x78,0x53,0x75,0x62,0x49,0x6d,0x61,0x67
	.byte 0x65,0x31,0x44,0x00,0x00,0x00,0xa6,0xa7
	.byte 0x67,0x6c,0x5f,0x54,0x65,0x78,0x53,0x75
	.byte 0x62,0x49,0x6d,0x61,0x67,0x65,0x32,0x44
	.byte 0x00,0x00,0x00,0xa8,0xb3,0x67,0x6c,0x5f
	.byte 0x54,0x65,0x78,0x53,0x75,0x62,0x49,0x6d
	.byte 0x61,0x67,0x65,0x33,0x44,0x45,0x58,0x54
	.byte 0x00,0x00,0x00,0xad,0x3c,0x67,0x6c,0x5f
	.byte 0x43,0x6f,0x70,0x79,0x54,0x65,0x78,0x49
	.byte 0x6d,0x61,0x67,0x65,0x31,0x44,0x00,0x00
	.byte 0x00,0xae,0x1e,0x67,0x6c,0x5f,0x43,0x6f
	.byte 0x70,0x79,0x54,0x65,0x78,0x49,0x6d,0x61
	.byte 0x67,0x65,0x32,0x44,0x00,0x00,0x00,0xb1
	.byte 0x6a,0x67,0x6c,0x5f,0x43,0x6f,0x70,0x79
	.byte 0x54,0x65,0x78,0x53,0x75,0x62,0x49,0x6d
	.byte 0x61,0x67,0x65,0x31,0x44,0x00,0x00,0x00
	.byte 0xb2,0x22,0x67,0x6c,0x5f,0x43,0x6f,0x70
	.byte 0x79,0x54,0x65,0x78,0x53,0x75,0x62,0x49
	.byte 0x6d,0x61,0x67,0x65,0x32,0x44,0x00,0x00
	.byte 0x00,0xb3,0x01,0x67,0x6c,0x5f,0x43,0x6f
	.byte 0x70,0x79,0x54,0x65,0x78,0x53,0x75,0x62
	.byte 0x49,0x6d,0x61,0x67,0x65,0x33,0x44,0x45
	.byte 0x58,0x54,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0xfc,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xb6,0x28,0x00,0x00,0x01,0x07
	.byte 0x6c,0x6f,0x67,0x62,0x61,0x73,0x65,0x32
	.byte 0x00,0x00,0x00,0x01,0x66,0x64,0x65,0x63
	.byte 0x6f,0x64,0x65,0x5f,0x69,0x6e,0x74,0x65
	.byte 0x72,0x6e,0x61,0x6c,0x5f,0x66,0x6f,0x72
	.byte 0x6d,0x61,0x74,0x00,0x00,0x00,0x01,0xa8
	.byte 0x63,0x6f,0x6d,0x70,0x6f,0x6e,0x65,0x6e
	.byte 0x74,0x73,0x5f,0x69,0x6e,0x5f,0x69,0x6e
	.byte 0x74,0x66,0x6f,0x72,0x6d,0x61,0x74,0x00
	.byte 0x00,0x00,0x33,0x5b,0x69,0x6d,0x61,0x67
	.byte 0x65,0x5f,0x74,0x6f,0x5f,0x74,0x65,0x78
	.byte 0x74,0x75,0x72,0x65,0x00,0x00,0x00,0x9b
	.byte 0x88,0x6d,0x61,0x6b,0x65,0x5f,0x6e,0x75
	.byte 0x6c,0x6c,0x5f,0x74,0x65,0x78,0x74,0x75
	.byte 0x72,0x65,0x00,0x00,0x00,0x9d,0x7d,0x74
	.byte 0x65,0x78,0x74,0x75,0x72,0x65,0x5f,0x31
	.byte 0x64,0x5f,0x65,0x72,0x72,0x6f,0x72,0x5f
	.byte 0x63,0x68,0x65,0x63,0x6b,0x00,0x00,0x00
	.byte 0x9e,0x5b,0x74,0x65,0x78,0x74,0x75,0x72
	.byte 0x65,0x5f,0x32,0x64,0x5f,0x65,0x72,0x72
	.byte 0x6f,0x72,0x5f,0x63,0x68,0x65,0x63,0x6b
	.byte 0x00,0x00,0x00,0x9f,0x4c,0x74,0x65,0x78
	.byte 0x74,0x75,0x72,0x65,0x5f,0x33,0x64,0x5f
	.byte 0x65,0x72,0x72,0x6f,0x72,0x5f,0x63,0x68
	.byte 0x65,0x63,0x6b,0x00,0x00,0x00,0xab,0x34
	.byte 0x72,0x65,0x61,0x64,0x5f,0x63,0x6f,0x6c
	.byte 0x6f,0x72,0x5f,0x69,0x6d,0x61,0x67,0x65
	.byte 0x00,0x00,0x00,0xaf,0x13,0x63,0x6f,0x70
	.byte 0x79,0x5f,0x74,0x65,0x78,0x5f,0x73,0x75
	.byte 0x62,0x5f,0x69,0x6d,0x61,0x67,0x65,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x04,0x24,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0xb6,0x28,0x00,0x00,0x01,0x5a
	.byte 0x47,0x4c,0x69,0x6e,0x74,0x00,0x00,0x00
	.byte 0x02,0x18,0x00,0x00,0x00,0x31,0xb4,0x47
	.byte 0x4c,0x65,0x6e,0x75,0x6d,0x00,0x00,0x00
	.byte 0x31,0xcd,0x47,0x4c,0x75,0x69,0x6e,0x74
	.byte 0x00,0x00,0x00,0x31,0xeb,0x47,0x4c,0x75
	.byte 0x62,0x79,0x74,0x65,0x00,0x00,0x00,0x32
	.byte 0x0b,0x67,0x6c,0x5f,0x74,0x65,0x78,0x74
	.byte 0x75,0x72,0x65,0x5f,0x69,0x6d,0x61,0x67
	.byte 0x65,0x00,0x00,0x00,0x39,0x2c,0x47,0x4c
	.byte 0x66,0x6c,0x6f,0x61,0x74,0x00,0x00,0x00
	.byte 0x39,0x77,0x47,0x4c,0x62,0x6f,0x6f,0x6c
	.byte 0x65,0x61,0x6e,0x00,0x00,0x00,0x3b,0x8c
	.byte 0x54,0x65,0x78,0x74,0x75,0x72,0x65,0x53
	.byte 0x61,0x6d,0x70,0x6c,0x65,0x46,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x39,0x87,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x6f,0x62,0x6a,0x65,0x63,0x74,0x00
	.byte 0x00,0x00,0x3b,0xa9,0x67,0x6c,0x5f,0x73
	.byte 0x68,0x61,0x72,0x65,0x64,0x5f,0x73,0x74
	.byte 0x61,0x74,0x65,0x00,0x00,0x00,0x43,0xcd
	.byte 0x47,0x4c,0x76,0x6f,0x69,0x64,0x00,0x00
	.byte 0x00,0x43,0xdf,0x67,0x6c,0x5f,0x69,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x5c,0x02
	.byte 0x67,0x6c,0x5f,0x61,0x70,0x69,0x5f,0x74
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x6a
	.byte 0xa6,0x67,0x6c,0x5f,0x76,0x69,0x73,0x75
	.byte 0x61,0x6c,0x00,0x00,0x00,0x6c,0x4e,0x47
	.byte 0x4c,0x76,0x69,0x73,0x75,0x61,0x6c,0x00
	.byte 0x00,0x00,0x6c,0x62,0x47,0x4c,0x64,0x65
	.byte 0x70,0x74,0x68,0x00,0x00,0x00,0x6c,0x75
	.byte 0x47,0x4c,0x73,0x74,0x65,0x6e,0x63,0x69
	.byte 0x6c,0x00,0x00,0x00,0x6c,0x93,0x47,0x4c
	.byte 0x61,0x63,0x63,0x75,0x6d,0x00,0x00,0x00
	.byte 0x6c,0xa6,0x67,0x6c,0x5f,0x66,0x72,0x61
	.byte 0x6d,0x65,0x5f,0x62,0x75,0x66,0x66,0x65
	.byte 0x72,0x00,0x00,0x00,0x6d,0x7d,0x47,0x4c
	.byte 0x66,0x72,0x61,0x6d,0x65,0x62,0x75,0x66
	.byte 0x66,0x65,0x72,0x00,0x00,0x00,0x73,0xdb
	.byte 0x70,0x6f,0x69,0x6e,0x74,0x73,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x74,0x0e
	.byte 0x6c,0x69,0x6e,0x65,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x74,0x44,0x74,0x72
	.byte 0x69,0x61,0x6e,0x67,0x6c,0x65,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x00,0x00,0x00,0x74,0x83
	.byte 0x71,0x75,0x61,0x64,0x5f,0x66,0x75,0x6e
	.byte 0x63,0x00,0x00,0x00,0x74,0xb9,0x72,0x65
	.byte 0x63,0x74,0x5f,0x66,0x75,0x6e,0x63,0x00
	.byte 0x00,0x00,0x76,0xa0,0x64,0x64,0x5f,0x66
	.byte 0x75,0x6e,0x63,0x74,0x69,0x6f,0x6e,0x5f
	.byte 0x74,0x61,0x62,0x6c,0x65,0x00,0x00,0x00
	.byte 0x7b,0xd8,0x47,0x4c,0x62,0x69,0x74,0x66
	.byte 0x69,0x65,0x6c,0x64,0x00,0x00,0x00,0x7b
	.byte 0xee,0x67,0x6c,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x5f,0x6e,0x6f,0x64,0x65,0x00
	.byte 0x00,0x00,0x7c,0x4e,0x67,0x6c,0x5f,0x61
	.byte 0x63,0x63,0x75,0x6d,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x7c,0x9b
	.byte 0x67,0x6c,0x5f,0x63,0x6f,0x6c,0x6f,0x72
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7e,0xb0,0x67,0x6c,0x5f,0x63,0x75,0x72
	.byte 0x72,0x65,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x7f,0x9a
	.byte 0x67,0x6c,0x5f,0x64,0x65,0x70,0x74,0x68
	.byte 0x62,0x75,0x66,0x66,0x65,0x72,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x7f,0xed,0x67,0x6c,0x5f,0x65,0x76,0x61
	.byte 0x6c,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x82,0x63,0x67,0x6c,0x5f
	.byte 0x66,0x6f,0x67,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x82,0xdc,0x67
	.byte 0x6c,0x5f,0x68,0x69,0x6e,0x74,0x5f,0x61
	.byte 0x74,0x74,0x72,0x69,0x62,0x00,0x00,0x00
	.byte 0x83,0xaf,0x67,0x6c,0x5f,0x6c,0x69,0x67
	.byte 0x68,0x74,0x00,0x00,0x00,0x86,0x56,0x67
	.byte 0x6c,0x5f,0x6c,0x69,0x67,0x68,0x74,0x6d
	.byte 0x6f,0x64,0x65,0x6c,0x00,0x00,0x00,0x86
	.byte 0xf7,0x67,0x6c,0x5f,0x6d,0x61,0x74,0x65
	.byte 0x72,0x69,0x61,0x6c,0x00,0x00,0x00,0x87
	.byte 0xe7,0x67,0x6c,0x5f,0x6c,0x69,0x67,0x68
	.byte 0x74,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x89,0x08,0x47,0x4c,0x75
	.byte 0x73,0x68,0x6f,0x72,0x74,0x00,0x00,0x00
	.byte 0x89,0x17,0x67,0x6c,0x5f,0x6c,0x69,0x6e
	.byte 0x65,0x5f,0x61,0x74,0x74,0x72,0x69,0x62
	.byte 0x00,0x00,0x00,0x89,0x90,0x67,0x6c,0x5f
	.byte 0x6c,0x69,0x73,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x8a,0x76
	.byte 0x67,0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x8d,0x46,0x67,0x6c,0x5f,0x70
	.byte 0x6f,0x69,0x6e,0x74,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x8d,0xbf
	.byte 0x67,0x6c,0x5f,0x70,0x6f,0x6c,0x79,0x67
	.byte 0x6f,0x6e,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x8f,0x03,0x47,0x4c
	.byte 0x73,0x69,0x7a,0x65,0x69,0x00,0x00,0x00
	.byte 0x8f,0x11,0x67,0x6c,0x5f,0x73,0x63,0x69
	.byte 0x73,0x73,0x6f,0x72,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x8f,0x6c
	.byte 0x67,0x6c,0x5f,0x73,0x74,0x65,0x6e,0x63
	.byte 0x69,0x6c,0x5f,0x61,0x74,0x74,0x72,0x69
	.byte 0x62,0x00,0x00,0x00,0x90,0xc6,0x67,0x6c
	.byte 0x5f,0x74,0x65,0x78,0x74,0x75,0x72,0x65
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x93,0x28,0x67,0x6c,0x5f,0x74
	.byte 0x72,0x61,0x6e,0x73,0x66,0x6f,0x72,0x6d
	.byte 0x5f,0x61,0x74,0x74,0x72,0x69,0x62,0x00
	.byte 0x00,0x00,0x93,0xa2,0x67,0x6c,0x5f,0x76
	.byte 0x69,0x65,0x77,0x70,0x6f,0x72,0x74,0x5f
	.byte 0x61,0x74,0x74,0x72,0x69,0x62,0x00,0x00
	.byte 0x00,0x94,0x5f,0x67,0x6c,0x5f,0x61,0x72
	.byte 0x72,0x61,0x79,0x5f,0x61,0x74,0x74,0x72
	.byte 0x69,0x62,0x00,0x00,0x00,0x97,0x0a,0x67
	.byte 0x6c,0x5f,0x70,0x69,0x78,0x65,0x6c,0x73
	.byte 0x74,0x6f,0x72,0x65,0x5f,0x61,0x74,0x74
	.byte 0x72,0x69,0x62,0x00,0x00,0x00,0x97,0xbe
	.byte 0x67,0x6c,0x5f,0x31,0x64,0x5f,0x6d,0x61
	.byte 0x70,0x00,0x00,0x00,0x98,0x12,0x67,0x6c
	.byte 0x5f,0x32,0x64,0x5f,0x6d,0x61,0x70,0x00
	.byte 0x00,0x00,0x98,0x8c,0x67,0x6c,0x5f,0x65
	.byte 0x76,0x61,0x6c,0x75,0x61,0x74,0x6f,0x72
	.byte 0x73,0x00,0x00,0x00,0x9a,0x16,0x67,0x6c
	.byte 0x5f,0x66,0x65,0x65,0x64,0x62,0x61,0x63
	.byte 0x6b,0x00,0x00,0x00,0x9a,0x8b,0x67,0x6c
	.byte 0x5f,0x73,0x65,0x6c,0x65,0x63,0x74,0x69
	.byte 0x6f,0x6e,0x00,0x00,0x00,0x3c,0x4a,0x67
	.byte 0x6c,0x5f,0x63,0x6f,0x6e,0x74,0x65,0x78
	.byte 0x74,0x00,0x00,0x00,0x9b,0x69,0x47,0x4c
	.byte 0x63,0x6f,0x6e,0x74,0x65,0x78,0x74,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
