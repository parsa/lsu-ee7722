
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0
	.type	ReadMesh,#function
ReadMesh:
	save	%sp,-144,%sp

	! block 1
.L13:
	st	%i0,[%fp+68]

	! block 2
.L14:
.L16:

! File mesa4.c:
!    1	/* mesa4.c */
!    2	     
!    3	     
!    4	/*
!    5	 * Mesa SPEC benchmark
!    6	 *
!    7	 * Brian Paul  brianp@elastic.avid.com 
!    8	 *
!    9	 *
!   10	 * This program renders images of a function of the form z = f(x, y). 
!   11	 *
!   12	 * The rendering of the function is drawn with filled, smooth-shaded, lit 
!   13	 * triangle strips.
!   14	 * The surface's geometry is computed only once. 
!   15	 *
!   16	 * Tunable parameters:
!   17	 *    WIDTH, HEIGHT = size of image to generate, in pixels. 
!   18	 *
!   19	 * Command line usage/parameters:
!   20	 *        mesa4 [-frames n] [-meshfile filename] [-ppmfile filename] 
!   21	 * where
!   22	 *    -frames specifies number of frames of animation (1000 is default) 
!   23	 *    -meshfile specifies name of input mesh ("mesa.mesh" is default)
!   24	 *    -ppmfile specifies the name of output ppm image file ("mesa.ppm" 
!   25	 *           is default)
!   26	 *
!   27	 *
!   28	 * Version history:
!   29	 *    mesa1.c   - original version sent to Rahul.
!   30	 *    mesa2.c   - updated to use a 1-D texture for constant lines of Z. 
!   31	 *    mesa3.c   - read mesh from file instead of generate during init. 
!   32	 *    mesa4.c   - write ASCII PPM file intead of binary.
!   33	 */
!   34	
!   35	/*
!   36	 * wwlk Revision history - minor stuff...
!   37	 *		- slightly smaller image so it doesn't clip to window borders.
!   38	 *		- rotate ends at zero Yrot. (Help validation I hope?)
!   39	 *		- limit Yrot to 0-360. (More help for validation.)
!   40	 *		- change to three lights! (Increase fp content of workload.)
!   41	 *		- Increase window to 1024x1024.
!   42	 */
!   43	/*
!   44	 * Rahul - 04/13/99
!   45	 * Changed image size from 1024 * 1024 to 1280 * 1024
!   46	 */
!   47	     
!   48	#include <stdio.h>
!   49	#include <stdlib.h>
!   50	#include <string.h>
!   51	#include <math.h>
!   52	#include "GL/osmesa.h"
!   53	#include "macros.h"     
!   54	     
!   55	/*
!   56	 * The frame buffer:
!   57	 */
!   58	
!   59	/*
!   60	 * wwlk
!   61	 *
!   62	 * This is another BIG knob in this mesa
!   63	 * benchmark, again order n^2.
!   64	 *
!   65	 * We have to be more sensitive this time, so....
!   66	 * Let's just increase the frame buffer size a bit.
!   67	 *
!   68	 * There's nothing wrong with 800x800, it is a
!   69	 * common window size, but with the mesh size
!   70	 * going up, we should probably up the frame buffer
!   71	 * just a bit as well.  Not as much!
!   72	 *
!   73	 * We'll only bring it up to 1024x1024.  This
!   74	 * is another common square graphics surface
!   75	 * size.
!   76	 *
!   77	 * SPEC OSG folks, yup, 1024x1024 sets up
!   78	 * some interesting power of two issues.
!   79	 * If this is a problem, 900x900 or 960x960
!   80	 * are also common sizes.
!   81	 *
!   82	 */
!   83	
!   84	/* #define WIDTH 800								   wwlk */
!   85	/* #define HEIGHT 800								   wwlk */
!   86	/* #define WIDTH 1024									wwlk */
!   87	#define WIDTH 1280									/* wwlk */
!   88	#define HEIGHT 1024									/* wwlk */
!   89	     
!   90	     
!   91	/*
!   92	 * The object we're rendering:
!   93	 */
!   94	static int NumRows, NumColumns;
!   95	static GLfloat *SurfaceV;
!   96	static GLfloat *SurfaceN;
!   97	static float Xmin = -10.0, Xmax = 10.0; 
!   98	static float Ymin = -10.0, Ymax = 10.0;
!   99	     
!  100	     
!  101	/*
!  102	 * Viewing parameters:
!  103	 */
!  104	
!  105	/*
!  106	 * wwlk
!  107	 *
!  108	 * Note, Yrot will get clobbered in Render later!
!  109	 */
!  110	
!  111	static GLfloat Xrot = -35.0, Yrot = 40.0;
!  112	     
!  113	     
!  114	     
!  115	/*
!  116	 * Read quadmesh from given file.
!  117	 */
!  118	static void ReadMesh(const char *filename) 
!  119	{
!  120	   int i, j;
!  121	   FILE *f = fopen(filename, "r");

	ld	[%fp+68],%l0
	sethi	%hi(.L17),%l1
	or	%l1,%lo(.L17),%l1
	mov	%l0,%o0
	call	fopen
	mov	%l1,%o1
	st	%o0,[%fp-12]

	! block 3
.L18:
.L20:

!  122	   if (!f) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L19
	nop

	! block 4
.L21:
.L22:
.L23:
.L24:

!  123	      printf("Error: couldn't open input mesh file: %s\n", filename); 

	sethi	%hi(.L25),%l0
	or	%l0,%lo(.L25),%l0
	ld	[%fp+68],%l1
	mov	%l0,%o0
	call	printf
	mov	%l1,%o1

	! block 5
.L26:

!  124	      exit(1);

	call	exit
	mov	1,%o0

	! block 6
.L27:
.L28:
.L19:
.L29:
.L30:

!  125	   }
!  126	     
!  127	   fscanf(f, "%d %d\n", &NumRows, &NumColumns); 

	ld	[%fp-12],%l0
	sethi	%hi(.L31),%l1
	or	%l1,%lo(.L31),%l1
	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l2
	or	%l2,%lo($XAa59JCTsd3LWaL.NumRows),%l2
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l3
	or	%l3,%lo($XAa59JCTsd3LWaL.NumColumns),%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	fscanf
	mov	%l3,%o3

	! block 7
.L32:
.L34:

!  128	   if (NumRows < 2) {

	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l0
	cmp	%l0,2
	bge	.L33
	nop

	! block 8
.L35:
.L36:
.L37:
.L38:

!  129	      printf("Error: number of mesh rows invalid\n"); 

	sethi	%hi(.L39),%l0
	or	%l0,%lo(.L39),%l0
	call	printf
	mov	%l0,%o0

	! block 9
.L40:

!  130	      exit(1);

	call	exit
	mov	1,%o0

	! block 10
.L41:
.L42:
.L33:
.L43:
.L44:
.L46:

!  131	   }
!  132	   if (NumColumns < 2) {

	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l0
	cmp	%l0,2
	bge	.L45
	nop

	! block 11
.L47:
.L48:
.L49:
.L50:

!  133	      printf("Error: number of mesh columns invalid\n"); 

	sethi	%hi(.L51),%l0
	or	%l0,%lo(.L51),%l0
	call	printf
	mov	%l0,%o0

	! block 12
.L52:

!  134	      exit(1);

	call	exit
	mov	1,%o0

	! block 13
.L53:
.L54:
.L45:
.L55:
.L56:

!  135	   }
!  136	     
!  137	   /* Allocate storage for mesh vertices and normal vectors */
!  138	   SurfaceV = (GLfloat *) malloc(NumRows * NumColumns * 3 * sizeof(GLfloat)); 

	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l2
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	st	%o0,[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)]

	! block 14
.L57:

!  139	   SurfaceN = (GLfloat *) malloc(NumRows * NumColumns * 3 * sizeof(GLfloat)); 

	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l2
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l1
	smul	%l2,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	call	malloc
	mov	%l0,%o0
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l0
	st	%o0,[%l0+%lo($XAa59JCTsd3LWaL.SurfaceN)]

	! block 15
.L58:
.L60:

!  140	   if (!SurfaceV || !SurfaceN) {

	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)],%l0
	cmp	%l0,%g0
	be	.L61
	nop

	! block 16
.L62:
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceN)],%l0
	cmp	%l0,%g0
	bne	.L59
	nop

	! block 17
.L63:
.L61:
.L64:
.L65:
.L66:

!  141	      printf("Error: unable to allocate memory for mesh data\n"); 

	sethi	%hi(.L67),%l0
	or	%l0,%lo(.L67),%l0
	call	printf
	mov	%l0,%o0

	! block 18
.L68:

!  142	      exit(1);

	call	exit
	mov	1,%o0

	! block 19
.L69:
.L70:
.L59:
.L71:
.L72:
.L73:

!  143	   }
!  144	     
!  145	   for (i=0; i<NumRows; i++) {

	st	%g0,[%fp-4]
	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l0
	cmp	%g0,%l0
	bge	.L76
	nop

	! block 20
.L77:
.L74:
.L78:
.L79:
.L80:
.L81:

!  146	      for (j=0; j<NumColumns; j++) {

	st	%g0,[%fp-8]
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l0
	cmp	%g0,%l0
	bge	.L84
	nop

	! block 21
.L_y0:
	add	%fp,-28,%l5
	add	%fp,-24,%l6
	add	%fp,-20,%l7
	sethi	%hi(.L90),%i0
	or	%i0,%lo(.L90),%i0
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l4
	or	%l4,%lo($XAa59JCTsd3LWaL.NumColumns),%l4
.L85:
.L82:
.L86:
.L87:
.L88:

!  147	      int k = (i * NumColumns + j) * 3;

	ld	[%fp-4],%l2
	ld	[%l4+0],%l1
	smul	%l2,%l1,%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 22
.L89:

!  148	      float vx, vy, vz, nx, ny, nz;
!  149	      fscanf(f, "%f %f %f  %f %f %f\n", &vx, &vy, &vz, &nx, &ny, &nz); 

	ld	[%fp-12],%l0
	add	%fp,-32,%l1
	add	%fp,-36,%l2
	add	%fp,-40,%l3
	mov	%l0,%o0
	mov	%i0,%o1
	mov	%l7,%o2
	mov	%l6,%o3
	mov	%l5,%o4
	mov	%l1,%o5
	st	%l2,[%sp+92]
	call	fscanf
	st	%l3,[%sp+96]

	! block 23
.L91:

!  150	      SurfaceV[k+0] = vx;

	ld	[%fp-20],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 24
.L92:

!  151	      SurfaceV[k+1] = vy;

	ld	[%fp-24],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+4]

	! block 25
.L93:

!  152	      SurfaceV[k+2] = vz;

	ld	[%fp-28],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 26
.L94:

!  153	      SurfaceN[k+0] = nx;

	ld	[%fp-32],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceN)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	st	%f4,[%l2+%l1]

	! block 27
.L95:

!  154	      SurfaceN[k+1] = ny;

	ld	[%fp-36],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceN)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+4]

	! block 28
.L96:

!  155	      SurfaceN[k+2] = nz;

	ld	[%fp-40],%f4
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceN)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	st	%f4,[%l0+8]

	! block 29
.L97:
.L98:
.L99:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l0
	cmp	%l1,%l0
	bl	.L82
	nop

	! block 30
.L100:
.L84:
.L101:
.L102:
.L103:
.L104:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l0
	cmp	%l1,%l0
	bl	.L74
	nop

	! block 31
.L105:
.L76:
.L106:
.L107:

!  156	      }
!  157	   }
!  158	     
!  159	   /* Mesh read successfully */
!  160	   fclose(f);

	ld	[%fp-12],%l0
	call	fclose
	mov	%l0,%o0

	! block 32
.L108:
.L109:
.L12:
	jmp	%i7+8
	restore
	.size	ReadMesh,(.-ReadMesh)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	DrawMesh,#function
DrawMesh:
	save	%sp,-112,%sp

	! block 1
.L112:
.L113:
.L115:
.L116:

! File mesa4.c:
!  161	}
!  162	     
!  163	     
!  164	     
!  165	     
!  166	/*
!  167	 * Draw the surface mesh.
!  168	 */
!  169	static void DrawMesh( void )
!  170	{
!  171	   int i, j;
!  172	     
!  173	   for (i=0; i < NumRows-1; i++) {

	st	%g0,[%fp-4]
	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l0
	sub	%l0,1,%l0
	cmp	%g0,%l0
	bge	.L119
	nop

	! block 2
.L120:
.L117:
.L121:
.L122:
.L123:

!  174	      glBegin(GL_TRIANGLE_STRIP);

	call	glBegin
	mov	5,%o0

	! block 3
.L124:
.L125:

!  175	      for (j=0; j < NumColumns; j++) {

	st	%g0,[%fp-8]
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l0
	cmp	%g0,%l0
	bge	.L128
	nop

	! block 4
.L_y1:
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l3
	or	%l3,%lo($XAa59JCTsd3LWaL.SurfaceN),%l3
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l5
	or	%l5,%lo($XAa59JCTsd3LWaL.SurfaceV),%l5
	sethi	%hi($XAa59JCTsd3LWaL.SurfaceN),%l6
	or	%l6,%lo($XAa59JCTsd3LWaL.SurfaceN),%l6
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l7
	or	%l7,%lo($XAa59JCTsd3LWaL.NumColumns),%l7
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l4
	or	%l4,%lo($XAa59JCTsd3LWaL.NumColumns),%l4
.L129:
.L126:
.L130:
.L131:
.L132:

!  176	      int k0 = ( i    * NumColumns + j) * 3; 

	ld	[%fp-4],%l2
	ld	[%l4+0],%l1
	smul	%l2,%l1,%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-12]

	! block 5
.L133:

!  177	      int k1 = ((i+1) * NumColumns + j) * 3;

	ld	[%fp-4],%l0
	add	%l0,1,%l2
	ld	[%l7+0],%l1
	smul	%l2,%l1,%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	sll	%l0,1,%l1
	add	%l0,%l1,%l0
	st	%l0,[%fp-16]

	! block 6
.L134:

!  178	         glNormal3fv(SurfaceN + k0);

	ld	[%l6+0],%l2
	ld	[%fp-12],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	call	glNormal3fv
	mov	%l0,%o0

	! block 7
.L135:

!  179	         glVertex3fv(SurfaceV + k0);

	ld	[%l5+0],%l2
	ld	[%fp-12],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	call	glVertex3fv
	mov	%l0,%o0

	! block 8
.L136:

!  180	         glNormal3fv(SurfaceN + k1);

	ld	[%l3+0],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	call	glNormal3fv
	mov	%l0,%o0

	! block 9
.L137:

!  181	         glVertex3fv(SurfaceV + k1);

	sethi	%hi($XAa59JCTsd3LWaL.SurfaceV),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.SurfaceV)],%l2
	ld	[%fp-16],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	call	glVertex3fv
	mov	%l0,%o0

	! block 10
.L138:
.L139:
.L140:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l1
	sethi	%hi($XAa59JCTsd3LWaL.NumColumns),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumColumns)],%l0
	cmp	%l1,%l0
	bl	.L126
	nop

	! block 11
.L141:
.L128:
.L142:
.L143:

!  182	      }
!  183	      glEnd();

	call	glEnd
	nop

	! block 12
.L144:
.L145:
.L146:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	sethi	%hi($XAa59JCTsd3LWaL.NumRows),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.NumRows)],%l0
	sub	%l0,1,%l0
	cmp	%l1,%l0
	bl	.L117
	nop

	! block 13
.L147:
.L119:
.L148:

	! block 14
.L149:
.L150:
.L111:
	jmp	%i7+8
	restore
	.size	DrawMesh,(.-DrawMesh)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	SPECWriteIntermediateImage,#function
SPECWriteIntermediateImage:
	save	%sp,-120,%sp

	! block 1
.L153:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]
	st	%i4,[%fp+84]
	st	%i5,[%fp+88]

	! block 2
.L154:
.L156:

! File mesa4.c:
!  184	   }
!  185	}
!  186	     
!  187	/* This is to write out some intermediate output so as to ensure that
!  188	 *   people do all the work
!  189	 */     
!  190	static void SPECWriteIntermediateImage( FILE *fip, FILE *fop, int width, int height, const void *buffer, int frame_count)
!  191	{
!  192	      int i, x, y;
!  193	      GLubyte *ptr = (GLubyte *) buffer;

	ld	[%fp+84],%l0
	st	%l0,[%fp-16]

	! block 3
.L157:

!  194	      int counter = 0;

	st	%g0,[%fp-20]

	! block 4
.L158:
.L160:

!  197	      if (fip)

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	be	.L159
	nop

	! block 5
.L161:
.L162:
.L163:
.L164:

!  198		{
!  199		  fscanf(fip, "%d %d", &x, &y); 

	ld	[%fp+68],%l0
	sethi	%hi(.L165),%l1
	or	%l1,%lo(.L165),%l1
	add	%fp,-8,%l2
	add	%fp,-12,%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	fscanf
	mov	%l3,%o3

	! block 6
.L166:

!  200		  y = y % height;

	ld	[%fp-12],%l0
	ld	[%fp+80],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%g1
	bvs,a	.+8
	sethi	%hi(0x80000000),%g1
	smul	%g1,%l1,%g1
	sub	%l0,%g1,%l0
	st	%l0,[%fp-12]

	! block 7
.L167:

!  201		  x = x % width; 

	ld	[%fp-8],%l0
	ld	[%fp+76],%l1
	sra	%l0,31,%g1
	wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,%l1,%g1
	bvs,a	.+8
	sethi	%hi(0x80000000),%g1
	smul	%g1,%l1,%g1
	sub	%l0,%g1,%l0
	st	%l0,[%fp-8]

	! block 8
.L168:

!  202		  i = (y*width + x) * 4;

	ld	[%fp-12],%l0
	ld	[%fp+76],%l1
	smul	%l0,%l1,%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-4]

	! block 9
.L169:
.L170:
.L159:
.L171:
.L172:
.L174:

!  203		}
!  204	      if (fop)

	ld	[%fp+72],%l0
	cmp	%l0,%g0
	be	.L173
	nop

	! block 10
.L175:
.L176:
.L177:
.L178:

!  205		{
!  206		  fprintf(fop, "%d %d %d %d\n", i, ptr[i], ptr[i+1], ptr[i+2]); 

	ld	[%fp+72],%l1
	sethi	%hi(.L179),%l3
	or	%l3,%lo(.L179),%l3
	ld	[%fp-4],%l2
	ld	[%fp-16],%l0
	add	%l0,%l2,%l0
	ldub	[%l0+0],%l5
	ldub	[%l0+1],%l6
	ldub	[%l0+2],%l0
	mov	%l1,%o0
	mov	%l3,%o1
	mov	%l2,%o2
	mov	%l5,%o3
	mov	%l6,%o4
	call	fprintf
	mov	%l0,%o5

	! block 11
.L180:
.L181:
.L173:
.L182:

	! block 12
.L183:
.L184:
.L152:
	jmp	%i7+8
	restore
	.size	SPECWriteIntermediateImage,(.-SPECWriteIntermediateImage)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	Render,#function
Render:
	save	%sp,-112,%sp

	! block 1
.L187:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L188:
.L190:

! File mesa4.c:
!  207		}
!  208	}
!  209	    
!  210	     
!  211	/*
!  212	 * This is the main rendering function.  We simply render the surface 
!  213	 * 'frames' times with different rotations.
!  214	 */
!  215	static void Render( int frames, int width, int height, const void *buffer  )
!  216	{
!  217	   int i;
!  218	   FILE *fip = fopen("numbers", "r"); 

	sethi	%hi(.L191),%l0
	or	%l0,%lo(.L191),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	call	fopen
	mov	%l1,%o1
	st	%o0,[%fp-8]

	! block 3
.L193:

!  219	   FILE *fop = fopen("mesa.log", "w"); 

	sethi	%hi(.L194),%l0
	or	%l0,%lo(.L194),%l0
	add	%l0,12,%l1
	mov	%l0,%o0
	call	fopen
	mov	%l1,%o1
	st	%o0,[%fp-12]

	! block 4
.L196:

!  220	   /* wwlk
!  221	    *
!  222		* OK, let's make verification a *bit* easier.
!  223		*
!  224		* If we rotate up from yrot=40degrees,
!  225		* and then add (frames-1)*5.0 to yrot,
!  226		* who knows where we'll end up.  Well,
!  227		* we know exactly where we end up, but
!  228		* it depends on how many frames.
!  229		*
!  230		* Instead, let's rotate so that the last
!  231		* frame yrot = 0.0!  Gosh, this is so
!  232		* obvious, I should have done it before.
!  233		*
!  234		*/
!  235	
!  236	   Yrot = -5.0F*(float)(frames-1);								/* wwlk */

	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fnegs	%f4,%f5
	ld	[%fp+68],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%f4
	fitos	%f4,%f4
	fmuls	%f5,%f4,%f4
	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	st	%f4,[%l0+%lo($XAa59JCTsd3LWaL.Yrot)]

	! block 5
.L197:
.L198:

!  237	   
!  238	   for (i=0; i<frames; i++) {

	ld	[%fp+68],%l0
	cmp	%g0,%l0
	bge	.L201
	st	%g0,[%fp-4]

	! block 6
.L202:
.L199:
.L203:
.L204:
.L205:
.L207:

!  239	      /* wwlk
!  240		   *
!  241		   * Limit Yrot to range 0-360
!  242		   * 
!  243		   * This is standard recommended practice in OpenGL
!  244		   * progamming.  Remember, OpenGL specifies angles
!  245		   * in degrees, not radians.  They'll get converted
!  246		   * to radians by Mesa, and Mesa says PI=3.1415926.
!  247		   *
!  248		   *
!  249		   */
!  250	
!  251		  if (Yrot > 360.0F) {

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Yrot)],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbule	.L206
	nop

	! block 7
.L208:
.L209:
.L210:
.L211:
.L215:

!  252			  while (Yrot > 360.0F) {

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Yrot)],%f5
	sethi	%hi(.L_cseg1),%l0
	ld	[%l0+%lo(.L_cseg1)],%f4
	fcmpes	%f5,%f4
	fbule	.L214
	nop

	! block 8
.L_y2:
	sethi	%hi(.L_cseg1),%l1
	or	%l1,%lo(.L_cseg1),%l1
	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l2
	or	%l2,%lo($XAa59JCTsd3LWaL.Yrot),%l2
	sethi	%hi(.L_cseg2),%l3
	or	%l3,%lo(.L_cseg2),%l3
	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	or	%l0,%lo($XAa59JCTsd3LWaL.Yrot),%l0
.L216:
.L212:
.L217:
.L218:
.L219:

!  253				  Yrot = Yrot - 360.0F;								/* wwlk */

	ld	[%l0+0],%f5
	ld	[%l3+0],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%l0+0]

	! block 9
.L220:
.L221:
.L222:
	ld	[%l2+0],%f5
	ld	[%l1+0],%f4
	fcmpes	%f5,%f4
	fbg	.L212
	nop

	! block 10
.L223:
.L214:
.L224:
.L225:
.L226:
	ba	.L227
	nop

	! block 11
.L206:
.L228:
.L229:
.L231:

!  254			  }
!  255		  }
!  256		  else if (Yrot < 0.0F) {									/* wwlk */

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Yrot)],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fcmpes	%f5,%f4
	fbuge	.L230
	nop

	! block 12
.L232:
.L233:
.L234:
.L235:
.L239:

!  257				while (Yrot < 0.0F ) {								/* wwlk */

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Yrot)],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f4
	fcmpes	%f5,%f4
	fbuge	.L238
	nop

	! block 13
.L_y3:
	sethi	%hi(.L_cseg3),%l1
	or	%l1,%lo(.L_cseg3),%l1
	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l2
	or	%l2,%lo($XAa59JCTsd3LWaL.Yrot),%l2
	sethi	%hi(.L_cseg1),%l3
	or	%l3,%lo(.L_cseg1),%l3
	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	or	%l0,%lo($XAa59JCTsd3LWaL.Yrot),%l0
.L240:
.L236:
.L241:
.L242:
.L243:

!  258					Yrot = Yrot + 360.0F;							/* wwlk */

	ld	[%l0+0],%f5
	ld	[%l3+0],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%l0+0]

	! block 14
.L244:
.L245:
.L246:
	ld	[%l2+0],%f5
	ld	[%l1+0],%f4
	fcmpes	%f5,%f4
	fbl	.L236
	nop

	! block 15
.L247:
.L238:
.L248:
.L249:
.L250:
.L230:
.L251:
.L252:
.L227:
.L253:
.L254:

!  259				}
!  260		  }															/* wwlk */
!  261		  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); 

	sethi	%hi(0x4100),%o0
	or	%o0,%lo(0x4100),%o0
	call	glClear
	nop

	! block 16
.L255:

!  262	      glPushMatrix();

	call	glPushMatrix
	nop

	! block 17
.L256:

!  263	      glRotatef(-Xrot, 1, 0, 0);

	sethi	%hi($XAa59JCTsd3LWaL.Xrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Xrot)],%f4
	fnegs	%f4,%f4
	sethi	%hi(.L_cseg4),%l0
	ld	[%l0+%lo(.L_cseg4)],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f6
	st	%f4,[%sp+68]
	ld	[%sp+68],%o0
	st	%f5,[%sp+72]
	ld	[%sp+72],%o1
	st	%f6,[%sp+76]
	ld	[%sp+76],%o2
	st	%f6,[%sp+80]
	call	glRotatef
	ld	[%sp+80],%o3

	! block 18
.L257:

!  264	      glRotatef(Yrot, 0, 1, 0);

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l0
	ld	[%l0+%lo($XAa59JCTsd3LWaL.Yrot)],%f4
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f6
	sethi	%hi(.L_cseg4),%l0
	ld	[%l0+%lo(.L_cseg4)],%f5
	st	%f4,[%sp+68]
	ld	[%sp+68],%o0
	st	%f6,[%sp+72]
	ld	[%sp+72],%o1
	st	%f5,[%sp+76]
	ld	[%sp+76],%o2
	st	%f6,[%sp+80]
	call	glRotatef
	ld	[%sp+80],%o3

	! block 19
.L258:

!  265	      glRotatef(-90, 1, 0, 0);

	sethi	%hi(.L_cseg5),%l0
	ld	[%l0+%lo(.L_cseg5)],%f4
	sethi	%hi(.L_cseg4),%l0
	ld	[%l0+%lo(.L_cseg4)],%f5
	sethi	%hi(.L_cseg3),%l0
	ld	[%l0+%lo(.L_cseg3)],%f6
	st	%f4,[%sp+68]
	ld	[%sp+68],%o0
	st	%f5,[%sp+72]
	ld	[%sp+72],%o1
	st	%f6,[%sp+76]
	ld	[%sp+76],%o2
	st	%f6,[%sp+80]
	call	glRotatef
	ld	[%sp+80],%o3

	! block 20
.L259:

!  266	     
!  267	      SPECWriteIntermediateImage(fip, fop, width, height, buffer, i); 

	ld	[%fp-8],%l0
	ld	[%fp-12],%l1
	ld	[%fp+72],%l2
	ld	[%fp+76],%l3
	ld	[%fp+80],%l5
	ld	[%fp-4],%l4
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	mov	%l3,%o3
	mov	%l5,%o4
	call	SPECWriteIntermediateImage
	mov	%l4,%o5

	! block 21
.L260:

!  269	      DrawMesh();

	call	DrawMesh
	nop

	! block 22
.L261:

!  270	     
!  271	      glPopMatrix();

	call	glPopMatrix
	nop

	! block 23
.L262:

!  272	     
!  273		 
!  274	      Yrot += 5.0F;												/* wwlk */

	sethi	%hi($XAa59JCTsd3LWaL.Yrot),%l1
	ld	[%l1+%lo($XAa59JCTsd3LWaL.Yrot)],%f5
	sethi	%hi(.L_cseg0),%l0
	ld	[%l0+%lo(.L_cseg0)],%f4
	fadds	%f5,%f4,%f4
	st	%f4,[%l1+%lo($XAa59JCTsd3LWaL.Yrot)]

	! block 24
.L263:
.L264:
.L265:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L199
	nop

	! block 25
.L266:
.L201:
.L267:

	! block 26
.L268:
.L269:
.L186:
	jmp	%i7+8
	restore
	.size	Render,(.-Render)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	Reshape,#function
Reshape:
	save	%sp,-128,%sp

	! block 1
.L272:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L273:
.L275:

! File mesa4.c:
!  275	   }
!  276	}
!  277	     
!  278	     
!  279	/*
!  280	 * Called to setup the viewport, projection and viewing parameters. 
!  281	 */
!  282	static void Reshape( int width, int height ) 
!  283	{
!  284	   GLfloat w = (float) width / (float) height; 

	ld	[%fp+68],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%f4
	fitos	%f4,%f5
	ld	[%fp+72],%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%f4
	fitos	%f4,%f4
	fdivs	%f5,%f4,%f4
	st	%f4,[%fp-4]

	! block 3
.L276:

!  285	   glViewport( 0, 0, width, height );

	ld	[%fp+68],%l0
	ld	[%fp+72],%l1
	mov	%g0,%o0
	mov	%g0,%o1
	mov	%l0,%o2
	call	glViewport
	mov	%l1,%o3

	! block 4
.L277:

!  286	   glMatrixMode( GL_PROJECTION );

	sethi	%hi(0x1701),%o0
	or	%o0,%lo(0x1701),%o0
	call	glMatrixMode
	nop

	! block 5
.L278:

!  287	   glLoadIdentity();

	call	glLoadIdentity
	nop

	! block 6
.L279:

!  288	/* glFrustum( -w, w, -1.0, 1.0, 5.0, 100.0 );			   wwlk */ 
!  289	   glFrustum( -w*1.1, w*1.1, -1.1, 1.1, 5.0, 100.0 );	/* wwlk */

	ld	[%fp-4],%f6
	fnegs	%f6,%f4
	fstod	%f4,%f4
	sethi	%hi(.L_cseg6),%l0
	ldd	[%l0+%lo(.L_cseg6)],%f10
	fmuld	%f4,%f10,%f8
	fstod	%f6,%f4
	fmuld	%f4,%f10,%f4
	fmovs	%f11, %f7
	fnegs	%f10,%f6
	sethi	%hi(.L_cseg7),%l0
	ldd	[%l0+%lo(.L_cseg7)],%f12
	sethi	%hi(.L_cseg8),%l0
	ldd	[%l0+%lo(.L_cseg8)],%f14
	std	%f8,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o0
	or	%g0,%g1,%o1
	std	%f4,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o2
	or	%g0,%g1,%o3
	std	%f6,[%sp+88]
	ldx	[%sp+88],%g1
	srlx	%g1,32,%o4
	or	%g0,%g1,%o5
	st	%f10,[%sp+92]
	st	%f11,[%sp+96]
	st	%f12,[%sp+100]
	st	%f13,[%sp+104]
	st	%f14,[%sp+108]
	st	%f15,[%sp+112]
	call	glFrustum
	nop

	! block 7
.L280:

!  290	   glMatrixMode( GL_MODELVIEW );

	sethi	%hi(0x1700),%o0
	or	%o0,%lo(0x1700),%o0
	call	glMatrixMode
	nop

	! block 8
.L281:

!  291	   glLoadIdentity();

	call	glLoadIdentity
	nop

	! block 9
.L282:

!  292	   glTranslatef( 0.0, 0.0, -60.0 );

	sethi	%hi(.L_cseg9),%l0
	ldd	[%l0+%lo(.L_cseg9)],%f4
	fdtos	%f4,%f6
	sethi	%hi(.L_cseg10),%l0
	ldd	[%l0+%lo(.L_cseg10)],%f4
	fnegs	%f4,%f4
	fdtos	%f4,%f4
	st	%f6,[%sp+68]
	ld	[%sp+68],%o0
	st	%f6,[%sp+72]
	ld	[%sp+72],%o1
	st	%f4,[%sp+76]
	call	glTranslatef
	ld	[%sp+76],%o2

	! block 10
.L283:
.L284:
.L271:
	jmp	%i7+8
	restore
	.size	Reshape,(.-Reshape)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	Init,#function
Init:
	save	%sp,-368,%sp

	! block 1
.L287:
.L288:
.L299:

! File mesa4.c:
!  293	}
!  294	     
!  295	     
!  296	/*
!  297	 * Initialize library parameters.
!  298	 */
!  299	static void Init( void )
!  300	{
!  301	   GLint i;
!  302	   GLubyte texture[256];
!  303	   static GLfloat texPlane[4] = {0.0, 0.0, 0.1, 0.0}; 
!  304	   static GLfloat blue[4] = {0.2, 0.2, 1.0, 1.0}; 
!  305	   static GLfloat white[4] = {1.0, 1.0, 1.0, 1.0}; 
!  306	
!  307	   /* wwlk
!  308	    *
!  309		* OK, here's an arguable change.  Let's increase
!  310		* the number of lights.  We'll up it to three
!  311		* to get a slightly more theatrical look.
!  312		*
!  313		* We do this by using a grayred, a graygreen
!  314		* and a grayblue light.  In other words,
!  315		* build up a grey from three individual
!  316		* lights, sort of like on stage.
!  317		* We'll have the lights come from
!  318		* slightly different directions.
!  319		*
!  320		* The diffuse lighting calculation will
!  321		* hardly change at all.  The specular
!  322		* lighting calculation will tend to look
!  323		* a bit more dramatic - but just a bit.
!  324		*
!  325		* How common is this style of lighting?
!  326		* Probably more common than it ought to be.
!  327		* But honestly, not very.  However,
!  328		* more than one light is quite common.
!  329		* Which is why including another couple
!  330		* of lights can be defended.
!  331		*
!  332		* But this is the only change that might be in
!  333		* danger of approaching Glitz Buffer Overflow.
!  334		* (John Judy Phil and Paula will get the
!  335		* reference.)
!  336		*/
!  337	
!  338	   /* static GLfloat pos[4] = {0.0, 2.0, 5.0, 0.0};				   wwlk */
!  339	   static GLfloat posred[4] =    {0.0, 2.0, 5.0, 0.0};			/* wwlk */
!  340	   static GLfloat posgreen[4] =  {0.0, 2.5, 5.0, 0.0};			/* wwlk */
!  341	   static GLfloat posblue[4] =   {0.0, 2.0, 6.0, 0.0};			/* wwlk */
!  342	
!  343	   /* static GLfloat gray[4] = {0.5, 0.5, 0.5, 1.0};			   wwlk */ 
!  344	   static GLfloat grayred[4] =   {0.43F, 0.125F, 0.0625F, 1.0F};/* wwlk */
!  345	   static GLfloat graygreen[4] = {0.0625F, 0.45F, 0.125F, 1.0F};/* wwlk */
!  346	   static GLfloat grayblue[4] =  {0.125F, 0.0625F, 0.47F, 1.0F};/* wwlk */
!  347	   glEnable(GL_LIGHTING);

	call	glEnable
	mov	2896,%o0

	! block 2
.L300:

!  348	   glEnable(GL_LIGHT0);

	sethi	%hi(0x4000),%o0
	call	glEnable
	nop

	! block 3
.L301:

!  349	   glEnable(GL_LIGHT1);											/* wwlk */

	sethi	%hi(0x4001),%o0
	or	%o0,%lo(0x4001),%o0
	call	glEnable
	nop

	! block 4
.L302:

!  350	   glEnable(GL_LIGHT2);											/* wwlk */

	sethi	%hi(0x4002),%o0
	or	%o0,%lo(0x4002),%o0
	call	glEnable
	nop

	! block 5
.L303:

!  352	   glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, blue); 

	sethi	%hi($XBa59JCTsd3LWaL.Init.blue),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.blue),%l0
	mov	1032,%o0
	sethi	%hi(0x1602),%o1
	or	%o1,%lo(0x1602),%o1
	call	glMaterialfv
	mov	%l0,%o2

	! block 6
.L304:

!  353	   glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, white); 

	sethi	%hi($XBa59JCTsd3LWaL.Init.white),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.white),%l0
	mov	1032,%o0
	sethi	%hi(0x1202),%o1
	or	%o1,%lo(0x1202),%o1
	call	glMaterialfv
	mov	%l0,%o2

	! block 7
.L305:

!  354	   glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 15.0);

	sethi	%hi(.L_cseg11),%l0
	ldd	[%l0+%lo(.L_cseg11)],%f4
	fdtos	%f4,%f4
	mov	1032,%o0
	sethi	%hi(0x1601),%o1
	or	%o1,%lo(0x1601),%o1
	st	%f4,[%sp+76]
	call	glMaterialf
	ld	[%sp+76],%o2

	! block 8
.L306:

!  356	   /* glLightfv(GL_LIGHT0, GL_POSITION, pos);					   wwlk */
!  357	   /* glLightfv(GL_LIGHT0, GL_DIFFUSE, gray);					   wwlk */
!  358	   /* glLightfv(GL_LIGHT0, GL_SPECULAR, gray);					   wwlk */
!  359	
!  360	   glLightfv(GL_LIGHT0, GL_POSITION, posred);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.posred),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.posred),%l0
	sethi	%hi(0x4000),%o0
	sethi	%hi(0x1203),%o1
	or	%o1,%lo(0x1203),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 9
.L307:

!  361	   glLightfv(GL_LIGHT0, GL_DIFFUSE, grayred);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.grayred),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.grayred),%l0
	sethi	%hi(0x4000),%o0
	sethi	%hi(0x1201),%o1
	or	%o1,%lo(0x1201),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 10
.L308:

!  362	   glLightfv(GL_LIGHT0, GL_SPECULAR, grayred);			  /* wwlk 15-April-1999 */

	sethi	%hi($XBa59JCTsd3LWaL.Init.grayred),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.grayred),%l0
	sethi	%hi(0x4000),%o0
	sethi	%hi(0x1202),%o1
	or	%o1,%lo(0x1202),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 11
.L309:

!  364	   glLightfv(GL_LIGHT1, GL_POSITION, posgreen);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.posgreen),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.posgreen),%l0
	sethi	%hi(0x4001),%o0
	or	%o0,%lo(0x4001),%o0
	sethi	%hi(0x1203),%o1
	or	%o1,%lo(0x1203),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 12
.L310:

!  365	   glLightfv(GL_LIGHT1, GL_DIFFUSE, graygreen);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.graygreen),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.graygreen),%l0
	sethi	%hi(0x4001),%o0
	or	%o0,%lo(0x4001),%o0
	sethi	%hi(0x1201),%o1
	or	%o1,%lo(0x1201),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 13
.L311:

!  366	   glLightfv(GL_LIGHT1, GL_SPECULAR, graygreen);		  /* wwlk 15-April-1999 */

	sethi	%hi($XBa59JCTsd3LWaL.Init.graygreen),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.graygreen),%l0
	sethi	%hi(0x4001),%o0
	or	%o0,%lo(0x4001),%o0
	sethi	%hi(0x1202),%o1
	or	%o1,%lo(0x1202),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 14
.L312:

!  367	   
!  368	   glLightfv(GL_LIGHT2, GL_POSITION, posblue);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.posblue),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.posblue),%l0
	sethi	%hi(0x4002),%o0
	or	%o0,%lo(0x4002),%o0
	sethi	%hi(0x1203),%o1
	or	%o1,%lo(0x1203),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 15
.L313:

!  369	   glLightfv(GL_LIGHT2, GL_DIFFUSE, grayblue);					/* wwlk */

	sethi	%hi($XBa59JCTsd3LWaL.Init.grayblue),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.grayblue),%l0
	sethi	%hi(0x4002),%o0
	or	%o0,%lo(0x4002),%o0
	sethi	%hi(0x1201),%o1
	or	%o1,%lo(0x1201),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 16
.L314:

!  370	   glLightfv(GL_LIGHT2, GL_SPECULAR, grayblue);			  /* wwlk 15-April-1999 */

	sethi	%hi($XBa59JCTsd3LWaL.Init.grayblue),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.grayblue),%l0
	sethi	%hi(0x4002),%o0
	or	%o0,%lo(0x4002),%o0
	sethi	%hi(0x1202),%o1
	or	%o1,%lo(0x1202),%o1
	call	glLightfv
	mov	%l0,%o2

	! block 17
.L315:

!  372	   glEnable(GL_DEPTH_TEST);

	call	glEnable
	mov	2929,%o0

	! block 18
.L316:
.L317:

!  373	     
!  374	   /* Setup 1-D texture map to render lines of constant Z */ 
!  375	   for (i=0; i<256; i++) {

	st	%g0,[%fp-4]

	! block 19
.L321:
.L318:
.L322:
.L323:
.L324:
.L326:

!  376	      if ((i % 16) < 1) {

	ld	[%fp-4],%l2
	sra	%l2,31,%l0
	and	%l0,15,%l1
	add	%l2,%l1,%l0
	and	%l0,-16,%l1
	sub	%l2,%l1,%l0
	cmp	%l0,1
	bge	.L325
	nop

	! block 20
.L327:
.L328:
.L329:
.L330:

!  377	         texture[i] = 0;

	add	%fp,-260,%l0
	ld	[%fp-4],%l1
	stb	%g0,[%l0+%l1]

	! block 21
.L331:
.L332:
	ba	.L333
	nop

	! block 22
.L325:
.L334:
.L335:
.L336:

!  378	      }
!  379	      else {
!  380	         texture[i] = 255;

	mov	255,%l2
	add	%fp,-260,%l0
	ld	[%fp-4],%l1
	stb	%l2,[%l0+%l1]

	! block 23
.L337:
.L338:
.L333:
.L339:
.L340:
.L341:
.L342:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,256
	bl	.L318
	nop

	! block 24
.L343:
.L320:
.L344:
.L345:

!  381	      }
!  382	   }
!  383	   glTexImage1D(GL_TEXTURE_1D, 0, 1, 256, 0,
!  384	                GL_LUMINANCE, GL_UNSIGNED_BYTE, texture);

	sethi	%hi(0x1401),%l0
	or	%l0,%lo(0x1401),%l0
	add	%fp,-260,%l1
	mov	3552,%o0
	mov	%g0,%o1
	mov	1,%o2
	mov	256,%o3
	mov	%g0,%o4
	sethi	%hi(0x1909),%o5
	or	%o5,%lo(0x1909),%o5
	st	%l0,[%sp+92]
	call	glTexImage1D
	st	%l1,[%sp+96]

	! block 25
.L346:

!  385	   glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 

	mov	3552,%o0
	sethi	%hi(0x2801),%o1
	or	%o1,%lo(0x2801),%o1
	sethi	%hi(0x2601),%o2
	or	%o2,%lo(0x2601),%o2
	call	glTexParameteri
	nop

	! block 26
.L347:

!  386	   glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); 

	mov	3552,%o0
	sethi	%hi(0x2800),%o1
	sethi	%hi(0x2601),%o2
	or	%o2,%lo(0x2601),%o2
	call	glTexParameteri
	nop

	! block 27
.L348:

!  387	   glEnable(GL_TEXTURE_1D);

	call	glEnable
	mov	3552,%o0

	! block 28
.L349:

!  388	     
!  389	   glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_OBJECT_LINEAR); 

	sethi	%hi(0x2000),%o0
	sethi	%hi(0x2500),%o1
	or	%o1,%lo(0x2500),%o1
	sethi	%hi(0x2401),%o2
	or	%o2,%lo(0x2401),%o2
	call	glTexGeni
	nop

	! block 29
.L350:

!  390	   glTexGenfv(GL_S, GL_OBJECT_PLANE, texPlane); 

	sethi	%hi($XBa59JCTsd3LWaL.Init.texPlane),%l0
	or	%l0,%lo($XBa59JCTsd3LWaL.Init.texPlane),%l0
	sethi	%hi(0x2000),%o0
	sethi	%hi(0x2501),%o1
	or	%o1,%lo(0x2501),%o1
	call	glTexGenfv
	mov	%l0,%o2

	! block 30
.L351:

!  391	   glEnable(GL_TEXTURE_GEN_S);

	call	glEnable
	mov	3168,%o0

	! block 31
.L352:

!  392	     
!  393	   Reshape(WIDTH, HEIGHT);

	mov	1280,%o0
	call	Reshape
	mov	1024,%o1

	! block 32
.L353:
.L354:
.L286:
	jmp	%i7+8
	restore
	.size	Init,(.-Init)
	.align	8
	.align	8
	.skip	16

	! block 0
	.type	WriteImage,#function
WriteImage:
	save	%sp,-120,%sp

	! block 1
.L357:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]
	st	%i3,[%fp+80]

	! block 2
.L358:
.L360:

! File mesa4.c:
!  394	}
!  395	     
!  396	     
!  397	/*
!  398	 * Write current image in Buffer to the named file. 
!  399	 */
!  400	static void WriteImage( const char *filename, int width, int height,
!  401	                        const void *buffer )
!  402	{
!  403	   FILE *f = fopen( filename, "w" );

	ld	[%fp+68],%l0
	sethi	%hi(.L361),%l1
	or	%l1,%lo(.L361),%l1
	mov	%l0,%o0
	call	fopen
	mov	%l1,%o1
	st	%o0,[%fp-4]

	! block 3
.L362:
.L364:

!  404	   if (f) {

	ld	[%fp-4],%l0
	cmp	%l0,%g0
	be	.L363
	nop

	! block 4
.L365:
.L366:
.L367:
.L368:

!  405	      int i, x, y;
!  406	      GLubyte *ptr = (GLubyte *) buffer;

	ld	[%fp+80],%l0
	st	%l0,[%fp-20]

	! block 5
.L369:

!  407	      int counter = 0;

	st	%g0,[%fp-24]

	! block 6
.L370:

!  408	      fprintf(f, "P3\n");

	ld	[%fp-4],%l0
	sethi	%hi(.L371),%l1
	or	%l1,%lo(.L371),%l1
	mov	%l0,%o0
	call	fprintf
	mov	%l1,%o1

	! block 7
.L372:

!  409	      fprintf(f, "# ascii ppm file created by %s\n", "SPEC mesa177"); 

	ld	[%fp-4],%l0
	sethi	%hi(.L373),%l1
	or	%l1,%lo(.L373),%l1
	sethi	%hi(.L374),%l2
	or	%l2,%lo(.L374),%l2
	mov	%l0,%o0
	mov	%l1,%o1
	call	fprintf
	mov	%l2,%o2

	! block 8
.L375:

!  410	      fprintf(f, "%i %i\n", width, height);

	ld	[%fp-4],%l0
	sethi	%hi(.L376),%l1
	or	%l1,%lo(.L376),%l1
	ld	[%fp+72],%l2
	ld	[%fp+76],%l3
	mov	%l0,%o0
	mov	%l1,%o1
	mov	%l2,%o2
	call	fprintf
	mov	%l3,%o3

	! block 9
.L377:

!  411	      fprintf(f, "255\n");

	ld	[%fp-4],%l0
	sethi	%hi(.L378),%l1
	or	%l1,%lo(.L378),%l1
	mov	%l0,%o0
	call	fprintf
	mov	%l1,%o1

	! block 10
.L379:
.L380:

!  412	      for (y=HEIGHT-1; y>=0; y--) {

	mov	1023,%l0
	st	%l0,[%fp-16]

	! block 11
.L384:
.L381:
.L385:
.L386:
.L387:
.L388:

!  413	         for (x=0; x<WIDTH; x++) {

	st	%g0,[%fp-12]

	! block 12
.L392:
.L389:
.L393:
.L394:
.L395:

!  414	            i = (y*WIDTH + x) * 4;

	ld	[%fp-16],%l0
	sll	%l0,8,%l2
	sll	%l0,10,%l1
	add	%l2,%l1,%l0
	ld	[%fp-12],%l1
	add	%l0,%l1,%l0
	sll	%l0,2,%l0
	st	%l0,[%fp-8]

	! block 13
.L396:

!  415	            fprintf(f, " %d %d %d", ptr[i], ptr[i+1], ptr[i+2]); 

	ld	[%fp-4],%l2
	sethi	%hi(.L397),%l3
	or	%l3,%lo(.L397),%l3
	ld	[%fp-20],%l0
	ld	[%fp-8],%l1
	add	%l0,%l1,%l0
	ldub	[%l0+0],%l1
	ldub	[%l0+1],%l5
	ldub	[%l0+2],%l0
	mov	%l2,%o0
	mov	%l3,%o1
	mov	%l1,%o2
	mov	%l5,%o3
	call	fprintf
	mov	%l0,%o4

	! block 14
.L398:

!  416	            counter++;

	ld	[%fp-24],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-24]

	! block 15
.L399:
.L401:

!  417	            if (counter % 5 == 0)

	ld	[%fp-24],%l0
	sra	%l0,31,%g1
wr	%g0,%g1,%y
	nop
	nop
	nop
	sdivcc	%l0,5,%g1
	bvs,a	.+8
	sethi	%hi(0x80000000),%g1
	smul	%g1,5,%g1
	sub	%l0,%g1,%l0
	cmp	%l0,0
	bne	.L400
	nop

	! block 16
.L402:
.L403:
.L404:

!  418	               fprintf(f, "\n");

	ld	[%fp-4],%l0
	sethi	%hi(.L405),%l1
	or	%l1,%lo(.L405),%l1
	mov	%l0,%o0
	call	fprintf
	mov	%l1,%o1

	! block 17
.L406:
.L400:
.L407:
.L408:
.L409:
.L410:
	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]
	ld	[%fp-12],%l0
	cmp	%l0,1280
	bl	.L389
	nop

	! block 18
.L411:
.L391:
.L412:
.L413:
.L414:
.L415:
	ld	[%fp-16],%l0
	sub	%l0,1,%l0
	st	%l0,[%fp-16]
	ld	[%fp-16],%l0
	cmp	%l0,0
	bge	.L381
	nop

	! block 19
.L416:
.L383:
.L417:
.L418:

!  419	         }
!  420	      }
!  421	      fclose(f);

	ld	[%fp-4],%l0
	call	fclose
	mov	%l0,%o0

	! block 20
.L419:
.L420:
.L363:
.L421:

	! block 21
.L422:
.L423:
.L356:
	jmp	%i7+8
	restore
	.size	WriteImage,(.-WriteImage)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	main
	.type	main,#function
main:
	save	%sp,-128,%sp

	! block 1
.L426:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L427:
.L429:

! File mesa4.c:
!  422	   }
!  423	}
!  424	     
!  425	     
!  426	int main(int argc, char *argv[])
!  427	{
!  428	   OSMesaContext ctx;
!  429	   void *buffer;
!  430	   int frames = 1000;

	mov	1000,%l0
	st	%l0,[%fp-16]

	! block 3
.L430:

!  431	   char *ppmFile = "mesa.ppm";

	sethi	%hi(.L431),%l0
	or	%l0,%lo(.L431),%l0
	st	%l0,[%fp-20]

	! block 4
.L432:

!  432	   char *meshFile = "mesa.mesh";

	sethi	%hi(.L433),%l0
	or	%l0,%lo(.L433),%l0
	st	%l0,[%fp-24]

	! block 5
.L434:

!  433	   char *intermediateResultsFile = "mesa.log"; 

	sethi	%hi(.L435),%l0
	or	%l0,%lo(.L435),%l0
	st	%l0,[%fp-28]

	! block 6
.L436:
.L437:

!  434	   int i;
!  435	
!  436	   for (i=1; i<argc; i++) {

	mov	1,%l0
	st	%l0,[%fp-32]
	mov	1,%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bge	.L440
	nop

	! block 7
.L441:
.L438:
.L442:
.L443:
.L444:
.L446:

!  437	      if (strcmp(argv[i],"-frames")==0) {

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(.L447),%l1
	or	%l1,%lo(.L447),%l1
	mov	%l0,%o0
	call	strcmp
	mov	%l1,%o1
	cmp	%o0,0
	bne	.L445
	nop

	! block 8
.L448:
.L449:
.L450:
.L451:
.L453:

!  438	      if (i+1 >= argc) {

	ld	[%fp-32],%l0
	add	%l0,1,%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L452
	nop

	! block 9
.L454:
.L455:
.L456:
.L457:

!  439	         printf("Error:  missing argument after -frames\n"); 

	sethi	%hi(.L458),%l0
	or	%l0,%lo(.L458),%l0
	call	printf
	mov	%l0,%o0

	! block 10
.L459:

!  440	         return 1;

	mov	1,%l0
	ba	.L425
	st	%l0,[%fp-4]

	! block 11
.L460:
.L461:
.L452:
.L462:
.L463:

!  441	      }
!  442	      frames = atoi(argv[i+1]);

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%l0
	call	atoi
	mov	%l0,%o0
	st	%o0,[%fp-16]

	! block 12
.L464:

!  443	      i++;

	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]

	! block 13
.L465:
.L467:

!  444	      if (frames <= 0) {

	ld	[%fp-16],%l0
	cmp	%l0,0
	bg	.L466
	nop

	! block 14
.L468:
.L469:
.L470:
.L471:

!  445	         printf("Error:  number of frames must be >= 1\n"); 

	sethi	%hi(.L472),%l0
	or	%l0,%lo(.L472),%l0
	call	printf
	mov	%l0,%o0

	! block 15
.L473:

!  446	         return 1;

	mov	1,%l0
	ba	.L425
	st	%l0,[%fp-4]

	! block 16
.L474:
.L475:
.L466:
.L476:
.L477:
.L478:
	ba	.L479
	nop

	! block 17
.L445:
.L480:
.L481:
.L483:

!  447	      }
!  448	      }
!  449	      else if (strcmp(argv[i],"-ppmfile")==0) { 

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(.L484),%l1
	or	%l1,%lo(.L484),%l1
	mov	%l0,%o0
	call	strcmp
	mov	%l1,%o1
	cmp	%o0,0
	bne	.L482
	nop

	! block 18
.L485:
.L486:
.L487:
.L488:
.L490:

!  450	      if (i+1 >= argc) {

	ld	[%fp-32],%l0
	add	%l0,1,%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L489
	nop

	! block 19
.L491:
.L492:
.L493:
.L494:

!  451	         printf("Error:  missing argument after -ppmfile\n"); 

	sethi	%hi(.L495),%l0
	or	%l0,%lo(.L495),%l0
	call	printf
	mov	%l0,%o0

	! block 20
.L496:

!  452	         return 1;

	mov	1,%l0
	ba	.L425
	st	%l0,[%fp-4]

	! block 21
.L497:
.L498:
.L489:
.L499:
.L500:

!  453	      }
!  454	      ppmFile = argv[i+1];

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%l0
	st	%l0,[%fp-20]

	! block 22
.L501:

!  455	      i++;

	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]

	! block 23
.L502:
.L503:
	ba	.L504
	nop

	! block 24
.L482:
.L505:
.L506:
.L508:

!  456	      }
!  457	      else if (strcmp(argv[i],"-meshfile")==0) { 

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	sethi	%hi(.L509),%l1
	or	%l1,%lo(.L509),%l1
	mov	%l0,%o0
	call	strcmp
	mov	%l1,%o1
	cmp	%o0,0
	bne	.L507
	nop

	! block 25
.L510:
.L511:
.L512:
.L513:
.L515:

!  458	      if (i+1 >= argc) {

	ld	[%fp-32],%l0
	add	%l0,1,%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L514
	nop

	! block 26
.L516:
.L517:
.L518:
.L519:

!  459	         printf("Error:  missing argument after -meshfile\n"); 

	sethi	%hi(.L520),%l0
	or	%l0,%lo(.L520),%l0
	call	printf
	mov	%l0,%o0

	! block 27
.L521:

!  460	         return 1;

	mov	1,%l0
	ba	.L425
	st	%l0,[%fp-4]

	! block 28
.L522:
.L523:
.L514:
.L524:
.L525:

!  461	      }
!  462	      meshFile = argv[i+1];

	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	add	%l2,%l1,%l0
	ld	[%l0+4],%l0
	st	%l0,[%fp-24]

	! block 29
.L526:

!  463	      i++;

	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]

	! block 30
.L527:
.L528:
	ba	.L529
	nop

	! block 31
.L507:
.L530:
.L531:
.L532:

!  464	      }
!  465	      else {
!  466	      printf("Error:  unexpect command line parameter: %s\n", argv[i]); 

	sethi	%hi(.L533),%l3
	or	%l3,%lo(.L533),%l3
	ld	[%fp+72],%l2
	ld	[%fp-32],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	mov	%l3,%o0
	call	printf
	mov	%l0,%o1

	! block 32
.L534:

!  467	      return 1;

	mov	1,%l0
	ba	.L425
	st	%l0,[%fp-4]

	! block 33
.L535:
.L536:
.L529:
.L537:
.L538:
.L504:
.L539:
.L540:
.L479:
.L541:
.L542:
.L543:
.L544:
	ld	[%fp-32],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-32]
	ld	[%fp-32],%l1
	ld	[%fp+68],%l0
	cmp	%l1,%l0
	bl	.L438
	nop

	! block 34
.L545:
.L440:
.L546:
.L547:

!  468	      }
!  469	   }
!  470	     
!  471	   /* Create an RGBA-mode context */
!  472	   ctx = OSMesaCreateContext( GL_RGBA, NULL );

	sethi	%hi(0x1908),%o0
	or	%o0,%lo(0x1908),%o0
	call	OSMesaCreateContext
	mov	%g0,%o1
	st	%o0,[%fp-8]

	! block 35
.L548:

!  473	     
!  474	   /* Allocate the image buffer */
!  475	   buffer = malloc( WIDTH * HEIGHT * 4 );

	sethi	%hi(0x500000),%o0
	call	malloc
	nop
	st	%o0,[%fp-12]

	! block 36
.L549:

!  476	     
!  477	   /* Bind the buffer to the context and make it current */ 
!  478	   OSMesaMakeCurrent( ctx, buffer, GL_UNSIGNED_BYTE, WIDTH, HEIGHT );

	ld	[%fp-8],%l0
	ld	[%fp-12],%l1
	mov	%l0,%o0
	mov	%l1,%o1
	sethi	%hi(0x1401),%o2
	or	%o2,%lo(0x1401),%o2
	mov	1280,%o3
	call	OSMesaMakeCurrent
	mov	1024,%o4

	! block 37
.L550:

!  479	     
!  480	   /* Initialize GL stuff */
!  481	   Init();

	call	Init
	nop

	! block 38
.L551:

!  482	     
!  483	   /* Load surface mesh */
!  484	   ReadMesh(meshFile);

	ld	[%fp-24],%l0
	call	ReadMesh
	mov	%l0,%o0

	! block 39
.L552:

!  485	     
!  486	   Render( frames, WIDTH, HEIGHT, buffer );

	ld	[%fp-16],%l0
	ld	[%fp-12],%l1
	mov	%l0,%o0
	mov	1280,%o1
	mov	1024,%o2
	call	Render
	mov	%l1,%o3

	! block 40
.L553:

!  487	     
!  488	   /* If an optional output filename is given write a PPM image file */ 
!  489	   WriteImage( ppmFile, WIDTH, HEIGHT, buffer );

	ld	[%fp-20],%l0
	ld	[%fp-12],%l1
	mov	%l0,%o0
	mov	1280,%o1
	mov	1024,%o2
	call	WriteImage
	mov	%l1,%o3

	! block 41
.L554:

!  490	     
!  491	   /* free the image buffer */
!  492	   free( buffer );

	ld	[%fp-12],%l0
	call	free
	mov	%l0,%o0

	! block 42
.L555:

!  493	     
!  494	   /* destroy the context */
!  495	   OSMesaDestroyContext( ctx );

	ld	[%fp-8],%l0
	call	OSMesaDestroyContext
	mov	%l0,%o0

	! block 43
.L556:

!  496	     
!  497	   return 0;

	ba	.L425
	st	%g0,[%fp-4]

	! block 44

	! block 45
.L557:
.L558:
.L425:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	main,(.-main)
	.align	8

	.section	".rodata1",#alloc
	.align	4
.L17:
	.ascii	"r\000"
	.skip	2
	.type	.L17,#object
	.size	.L17,4
	.align	4
.L25:
	.ascii	"Error: couldn't open input mesh file: %s\n\000"
	.skip	2
	.type	.L25,#object
	.size	.L25,44
	.align	4
.L31:
	.ascii	"%d %d\n\000"
	.skip	1
	.type	.L31,#object
	.size	.L31,8

	.section	".bss",#alloc,#write
	.align	4
Bbss.bss:
	.global	$XAa59JCTsd3LWaL.NumRows
$XAa59JCTsd3LWaL.NumRows:
	.skip	4
	.type	$XAa59JCTsd3LWaL.NumRows,#object
	.size	$XAa59JCTsd3LWaL.NumRows,4
	.align	4
	.global	$XAa59JCTsd3LWaL.NumColumns
$XAa59JCTsd3LWaL.NumColumns:
	.skip	4
	.type	$XAa59JCTsd3LWaL.NumColumns,#object
	.size	$XAa59JCTsd3LWaL.NumColumns,4

	.section	".rodata1",#alloc
	.align	4
.L39:
	.ascii	"Error: number of mesh rows invalid\n\000"
	.type	.L39,#object
	.size	.L39,36
	.align	4
.L51:
	.ascii	"Error: number of mesh columns invalid\n\000"
	.skip	1
	.type	.L51,#object
	.size	.L51,40

	.section	".bss",#alloc,#write
	.align	4
	.global	$XAa59JCTsd3LWaL.SurfaceV
$XAa59JCTsd3LWaL.SurfaceV:
	.skip	4
	.type	$XAa59JCTsd3LWaL.SurfaceV,#object
	.size	$XAa59JCTsd3LWaL.SurfaceV,4
	.align	4
	.global	$XAa59JCTsd3LWaL.SurfaceN
$XAa59JCTsd3LWaL.SurfaceN:
	.skip	4
	.type	$XAa59JCTsd3LWaL.SurfaceN,#object
	.size	$XAa59JCTsd3LWaL.SurfaceN,4

	.section	".rodata1",#alloc
	.align	4
.L67:
	.ascii	"Error: unable to allocate memory for mesh data\n\000"
	.type	.L67,#object
	.size	.L67,48
	.align	4
.L90:
	.ascii	"%f %f %f  %f %f %f\n\000"
	.type	.L90,#object
	.size	.L90,20
	.align	4
.L165:
	.ascii	"%d %d\000"
	.skip	2
	.type	.L165,#object
	.size	.L165,8
	.align	4
.L179:
	.ascii	"%d %d %d %d\n\000"
	.skip	3
	.type	.L179,#object
	.size	.L179,16
	.align	4
.L191:
	.ascii	"numbers\000"
	.type	.L191,#object
	.size	.L191,8
	.align	4
.L192:
	.ascii	"r\000"
	.skip	2
	.type	.L192,#object
	.size	.L192,4
	.align	4
.L194:
	.ascii	"mesa.log\000"
	.skip	3
	.type	.L194,#object
	.size	.L194,12
	.align	4
.L195:
	.ascii	"w\000"
	.skip	2
	.type	.L195,#object
	.size	.L195,4

	.section	".data",#alloc,#write
	.align	4
Ddata.data:
	.global	$XAa59JCTsd3LWaL.Yrot
$XAa59JCTsd3LWaL.Yrot:
	.word	0x42200000
	.type	$XAa59JCTsd3LWaL.Yrot,#object
	.size	$XAa59JCTsd3LWaL.Yrot,4
	.align	4
	.global	$XAa59JCTsd3LWaL.Xrot
$XAa59JCTsd3LWaL.Xrot:
	.word	0xc20c0000
	.type	$XAa59JCTsd3LWaL.Xrot,#object
	.size	$XAa59JCTsd3LWaL.Xrot,4

	.section	".rodata",#alloc
	.align	4
Drodata.rodata:
.L_cseg0:
	.word	0x40a00000
	.type	.L_cseg0,#object
	.size	.L_cseg0,4
	.align	4
.L_cseg1:
	.word	0x43b40000
	.type	.L_cseg1,#object
	.size	.L_cseg1,4
	.align	4
.L_cseg2:
	.word	0xc3b40000
	.type	.L_cseg2,#object
	.size	.L_cseg2,4
	.align	4
.L_cseg3:
	.skip	4
	.type	.L_cseg3,#object
	.size	.L_cseg3,4
	.align	4
.L_cseg4:
	.word	0x3f800000
	.type	.L_cseg4,#object
	.size	.L_cseg4,4
	.align	4
.L_cseg5:
	.word	0xc2b40000
	.type	.L_cseg5,#object
	.size	.L_cseg5,4
	.align	8
.L_cseg6:
	.word	0x3ff19999,0x9999999a
	.type	.L_cseg6,#object
	.size	.L_cseg6,8
	.align	8
.L_cseg7:
	.word	0x40140000,0x0
	.type	.L_cseg7,#object
	.size	.L_cseg7,8
	.align	8
.L_cseg8:
	.word	0x40590000,0x0
	.type	.L_cseg8,#object
	.size	.L_cseg8,8
	.align	8
.L_cseg9:
	.skip	8
	.type	.L_cseg9,#object
	.size	.L_cseg9,8
	.align	8
.L_cseg10:
	.word	0x404e0000,0x0
	.type	.L_cseg10,#object
	.size	.L_cseg10,8

	.section	".data",#alloc,#write
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.blue
$XBa59JCTsd3LWaL.Init.blue:
	.word	0x3e4ccccd,0x3e4ccccd,0x3f800000,0x3f800000
	.type	$XBa59JCTsd3LWaL.Init.blue,#object
	.size	$XBa59JCTsd3LWaL.Init.blue,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.white
$XBa59JCTsd3LWaL.Init.white:
	.word	0x3f800000,0x3f800000,0x3f800000,0x3f800000
	.type	$XBa59JCTsd3LWaL.Init.white,#object
	.size	$XBa59JCTsd3LWaL.Init.white,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.posred
$XBa59JCTsd3LWaL.Init.posred:
	.skip	4
	.word	0x40000000,0x40a00000
	.skip	4
	.type	$XBa59JCTsd3LWaL.Init.posred,#object
	.size	$XBa59JCTsd3LWaL.Init.posred,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.grayred
$XBa59JCTsd3LWaL.Init.grayred:
	.word	0x3edc28f6,0x3e000000,0x3d800000,0x3f800000
	.type	$XBa59JCTsd3LWaL.Init.grayred,#object
	.size	$XBa59JCTsd3LWaL.Init.grayred,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.posgreen
$XBa59JCTsd3LWaL.Init.posgreen:
	.skip	4
	.word	0x40200000,0x40a00000
	.skip	4
	.type	$XBa59JCTsd3LWaL.Init.posgreen,#object
	.size	$XBa59JCTsd3LWaL.Init.posgreen,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.graygreen
$XBa59JCTsd3LWaL.Init.graygreen:
	.word	0x3d800000,0x3ee66666,0x3e000000,0x3f800000
	.type	$XBa59JCTsd3LWaL.Init.graygreen,#object
	.size	$XBa59JCTsd3LWaL.Init.graygreen,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.posblue
$XBa59JCTsd3LWaL.Init.posblue:
	.skip	4
	.word	0x40000000,0x40c00000
	.skip	4
	.type	$XBa59JCTsd3LWaL.Init.posblue,#object
	.size	$XBa59JCTsd3LWaL.Init.posblue,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.grayblue
$XBa59JCTsd3LWaL.Init.grayblue:
	.word	0x3e000000,0x3d800000,0x3ef0a3d7,0x3f800000
	.type	$XBa59JCTsd3LWaL.Init.grayblue,#object
	.size	$XBa59JCTsd3LWaL.Init.grayblue,16
	.align	4
	.global	$XBa59JCTsd3LWaL.Init.texPlane
$XBa59JCTsd3LWaL.Init.texPlane:
	.skip	8
	.word	0x3dcccccd
	.skip	4
	.type	$XBa59JCTsd3LWaL.Init.texPlane,#object
	.size	$XBa59JCTsd3LWaL.Init.texPlane,16

	.section	".rodata",#alloc
	.align	8
.L_cseg11:
	.word	0x402e0000,0x0
	.type	.L_cseg11,#object
	.size	.L_cseg11,8

	.section	".rodata1",#alloc
	.align	4
.L361:
	.ascii	"w\000"
	.skip	2
	.type	.L361,#object
	.size	.L361,4
	.align	4
.L371:
	.ascii	"P3\n\000"
	.type	.L371,#object
	.size	.L371,4
	.align	4
.L373:
	.ascii	"# ascii ppm file created by %s\n\000"
	.type	.L373,#object
	.size	.L373,32

	.section	".data1",#alloc,#write
	.align	4
.L374:
	.ascii	"SPEC mesa177\000"
	.skip	3
	.type	.L374,#object
	.size	.L374,16

	.section	".rodata1",#alloc
	.align	4
.L376:
	.ascii	"%i %i\n\000"
	.skip	1
	.type	.L376,#object
	.size	.L376,8
	.align	4
.L378:
	.ascii	"255\n\000"
	.skip	3
	.type	.L378,#object
	.size	.L378,8
	.align	4
.L397:
	.ascii	" %d %d %d\000"
	.skip	2
	.type	.L397,#object
	.size	.L397,12
	.align	4
.L405:
	.ascii	"\n\000"
	.skip	2
	.type	.L405,#object
	.size	.L405,4

	.section	".data1",#alloc,#write
	.align	4
.L431:
	.ascii	"mesa.ppm\000"
	.skip	3
	.type	.L431,#object
	.size	.L431,12
	.align	4
.L433:
	.ascii	"mesa.mesh\000"
	.skip	2
	.type	.L433,#object
	.size	.L433,12
	.align	4
.L435:
	.ascii	"mesa.log\000"
	.type	.L435,#object
	.size	.L435,9

	.section	".rodata1",#alloc
	.align	4
.L447:
	.ascii	"-frames\000"
	.type	.L447,#object
	.size	.L447,8
	.align	4
.L458:
	.ascii	"Error:  missing argument after -frames\n\000"
	.type	.L458,#object
	.size	.L458,40
	.align	4
.L472:
	.ascii	"Error:  number of frames must be >= 1\n\000"
	.skip	1
	.type	.L472,#object
	.size	.L472,40
	.align	4
.L484:
	.ascii	"-ppmfile\000"
	.skip	3
	.type	.L484,#object
	.size	.L484,12
	.align	4
.L495:
	.ascii	"Error:  missing argument after -ppmfile\n\000"
	.skip	3
	.type	.L495,#object
	.size	.L495,44
	.align	4
.L509:
	.ascii	"-meshfile\000"
	.skip	2
	.type	.L509,#object
	.size	.L509,12
	.align	4
.L520:
	.ascii	"Error:  missing argument after -meshfile\n\000"
	.skip	2
	.type	.L520,#object
	.size	.L520,44
	.align	4
.L533:
	.ascii	"Error:  unexpect command line parameter: %s\n\000"
	.type	.L533,#object
	.size	.L533,45

	.section	".data",#alloc,#write
	.align	4
	.global	$XAa59JCTsd3LWaL.Xmin
$XAa59JCTsd3LWaL.Xmin:
	.word	0xc1200000
	.type	$XAa59JCTsd3LWaL.Xmin,#object
	.size	$XAa59JCTsd3LWaL.Xmin,4
	.align	4
	.global	$XAa59JCTsd3LWaL.Xmax
$XAa59JCTsd3LWaL.Xmax:
	.word	0x41200000
	.type	$XAa59JCTsd3LWaL.Xmax,#object
	.size	$XAa59JCTsd3LWaL.Xmax,4
	.align	4
	.global	$XAa59JCTsd3LWaL.Ymin
$XAa59JCTsd3LWaL.Ymin:
	.word	0xc1200000
	.type	$XAa59JCTsd3LWaL.Ymin,#object
	.size	$XAa59JCTsd3LWaL.Ymin,4
	.align	4
	.global	$XAa59JCTsd3LWaL.Ymax
$XAa59JCTsd3LWaL.Ymax:
	.word	0x41200000
	.type	$XAa59JCTsd3LWaL.Ymax,#object
	.size	$XAa59JCTsd3LWaL.Ymax,4

	.file	"mesa4.c"
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

	.global	__fsr_init_value
__fsr_init_value = 0x0
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
!   reloc[2]: knd=0, off=281, siz=4, lab1=$XAa59JCTsd3LWaL.Xmin, lab2=, loff=0
!   reloc[3]: knd=0, off=300, siz=4, lab1=$XAa59JCTsd3LWaL.Xmax, lab2=, loff=0
!   reloc[4]: knd=0, off=319, siz=4, lab1=$XAa59JCTsd3LWaL.Ymin, lab2=, loff=0
!   reloc[5]: knd=0, off=338, siz=4, lab1=$XAa59JCTsd3LWaL.Ymax, lab2=, loff=0
!   reloc[6]: knd=0, off=371, siz=4, lab1=$XAa59JCTsd3LWaL.Xrot, lab2=, loff=0
!   reloc[7]: knd=0, off=390, siz=4, lab1=$XAa59JCTsd3LWaL.Yrot, lab2=, loff=0
!   reloc[8]: knd=0, off=407, siz=4, lab1=ReadMesh, lab2=, loff=0
!   reloc[9]: knd=0, off=411, siz=4, lab1=.L109, lab2=, loff=0
!   reloc[10]: knd=0, off=483, siz=4, lab1=.L72, lab2=, loff=0
!   reloc[11]: knd=0, off=487, siz=4, lab1=.L106, lab2=, loff=0
!   reloc[12]: knd=0, off=492, siz=4, lab1=.L78, lab2=, loff=0
!   reloc[13]: knd=0, off=496, siz=4, lab1=.L103, lab2=, loff=0
!   reloc[14]: knd=0, off=501, siz=4, lab1=.L79, lab2=, loff=0
!   reloc[15]: knd=0, off=505, siz=4, lab1=.L102, lab2=, loff=0
!   reloc[16]: knd=0, off=510, siz=4, lab1=.L80, lab2=, loff=0
!   reloc[17]: knd=0, off=514, siz=4, lab1=.L101, lab2=, loff=0
!   reloc[18]: knd=0, off=519, siz=4, lab1=.L86, lab2=, loff=0
!   reloc[19]: knd=0, off=523, siz=4, lab1=.L98, lab2=, loff=0
!   reloc[20]: knd=0, off=528, siz=4, lab1=.L87, lab2=, loff=0
!   reloc[21]: knd=0, off=532, siz=4, lab1=.L97, lab2=, loff=0
!   reloc[22]: knd=0, off=948, siz=4, lab1=DrawMesh, lab2=, loff=0
!   reloc[23]: knd=0, off=952, siz=4, lab1=.L150, lab2=, loff=0
!   reloc[24]: knd=0, off=991, siz=4, lab1=.L115, lab2=, loff=0
!   reloc[25]: knd=0, off=995, siz=4, lab1=.L148, lab2=, loff=0
!   reloc[26]: knd=0, off=1000, siz=4, lab1=.L121, lab2=, loff=0
!   reloc[27]: knd=0, off=1004, siz=4, lab1=.L145, lab2=, loff=0
!   reloc[28]: knd=0, off=1009, siz=4, lab1=.L122, lab2=, loff=0
!   reloc[29]: knd=0, off=1013, siz=4, lab1=.L144, lab2=, loff=0
!   reloc[30]: knd=0, off=1018, siz=4, lab1=.L124, lab2=, loff=0
!   reloc[31]: knd=0, off=1022, siz=4, lab1=.L142, lab2=, loff=0
!   reloc[32]: knd=0, off=1027, siz=4, lab1=.L130, lab2=, loff=0
!   reloc[33]: knd=0, off=1031, siz=4, lab1=.L139, lab2=, loff=0
!   reloc[34]: knd=0, off=1036, siz=4, lab1=.L131, lab2=, loff=0
!   reloc[35]: knd=0, off=1040, siz=4, lab1=.L138, lab2=, loff=0
!   reloc[36]: knd=0, off=1110, siz=4, lab1=SPECWriteIntermediateImage, lab2=, loff=0
!   reloc[37]: knd=0, off=1114, siz=4, lab1=.L184, lab2=, loff=0
!   reloc[38]: knd=0, off=1354, siz=4, lab1=Render, lab2=, loff=0
!   reloc[39]: knd=0, off=1358, siz=4, lab1=.L269, lab2=, loff=0
!   reloc[40]: knd=0, off=1508, siz=4, lab1=Reshape, lab2=, loff=0
!   reloc[41]: knd=0, off=1512, siz=4, lab1=.L284, lab2=, loff=0
!   reloc[42]: knd=0, off=1586, siz=4, lab1=Init, lab2=, loff=0
!   reloc[43]: knd=0, off=1590, siz=4, lab1=.L354, lab2=, loff=0
!   reloc[44]: knd=0, off=1657, siz=4, lab1=$XBa59JCTsd3LWaL.Init.texPlane, lab2=, loff=0
!   reloc[45]: knd=0, off=1677, siz=4, lab1=$XBa59JCTsd3LWaL.Init.blue, lab2=, loff=0
!   reloc[46]: knd=0, off=1698, siz=4, lab1=$XBa59JCTsd3LWaL.Init.white, lab2=, loff=0
!   reloc[47]: knd=0, off=1720, siz=4, lab1=$XBa59JCTsd3LWaL.Init.posred, lab2=, loff=0
!   reloc[48]: knd=0, off=1744, siz=4, lab1=$XBa59JCTsd3LWaL.Init.posgreen, lab2=, loff=0
!   reloc[49]: knd=0, off=1767, siz=4, lab1=$XBa59JCTsd3LWaL.Init.posblue, lab2=, loff=0
!   reloc[50]: knd=0, off=1790, siz=4, lab1=$XBa59JCTsd3LWaL.Init.grayred, lab2=, loff=0
!   reloc[51]: knd=0, off=1815, siz=4, lab1=$XBa59JCTsd3LWaL.Init.graygreen, lab2=, loff=0
!   reloc[52]: knd=0, off=1839, siz=4, lab1=$XBa59JCTsd3LWaL.Init.grayblue, lab2=, loff=0
!   reloc[53]: knd=0, off=2052, siz=4, lab1=WriteImage, lab2=, loff=0
!   reloc[54]: knd=0, off=2056, siz=4, lab1=.L423, lab2=, loff=0
!   reloc[55]: knd=0, off=2160, siz=4, lab1=.L362, lab2=, loff=0
!   reloc[56]: knd=0, off=2164, siz=4, lab1=.L421, lab2=, loff=0
!   reloc[57]: knd=0, off=2169, siz=4, lab1=.L366, lab2=, loff=0
!   reloc[58]: knd=0, off=2173, siz=4, lab1=.L420, lab2=, loff=0
!   reloc[59]: knd=0, off=2178, siz=4, lab1=.L367, lab2=, loff=0
!   reloc[60]: knd=0, off=2182, siz=4, lab1=.L419, lab2=, loff=0
!   reloc[61]: knd=0, off=2300, siz=4, lab1=main, lab2=, loff=0
!   reloc[62]: knd=0, off=2304, siz=4, lab1=.L558, lab2=, loff=0
!   reloc[63]: knd=0, off=2581, siz=4, lab1=$XAa59JCTsd3LWaL.SurfaceN, lab2=, loff=0
!   reloc[64]: knd=0, off=2604, siz=4, lab1=$XAa59JCTsd3LWaL.SurfaceV, lab2=, loff=0
!   reloc[65]: knd=0, off=2629, siz=4, lab1=$XAa59JCTsd3LWaL.NumColumns, lab2=, loff=0
!   reloc[66]: knd=0, off=2651, siz=4, lab1=$XAa59JCTsd3LWaL.NumRows, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x3e,0xe0,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "mesa4.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  mesa4.c -W0,-xp\\$XAa59JCTsd3LWaL.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCTsd3LWaL.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "float\0"
	.byte 0x04,0x04,0x03
	.ascii "Xmin\0"
	.byte 0x00,0x00,0x01,0x01,0x03,0x01,0x61,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Xmin
	.byte 0x03
	.ascii "Xmax\0"
	.byte 0x00,0x00,0x01,0x01,0x03,0x01,0x61,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Xmax
	.byte 0x03
	.ascii "Ymin\0"
	.byte 0x00,0x00,0x01,0x01,0x03,0x01,0x62,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Ymin
	.byte 0x03
	.ascii "Ymax\0"
	.byte 0x00,0x00,0x01,0x01,0x03,0x01,0x62,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Ymax
	.byte 0x04,0x00,0x00,0x01,0x01
	.ascii "GLfloat\0"
	.byte 0x02,0x03
	.ascii "Xrot\0"
	.byte 0x00,0x00,0x01,0x56,0x03,0x01,0x6f,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Xrot
	.byte 0x03
	.ascii "Yrot\0"
	.byte 0x00,0x00,0x01,0x56,0x03,0x01,0x6f,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.Yrot
	.byte 0x05
	.ascii "ReadMesh\0"
	.byte 0x03,0x01,0x77
	.uaword ReadMesh
	.uaword .L109
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x02,0x80
	.byte 0x06,0x00,0x00,0x02,0x8d
	.ascii "filename\0"
	.byte 0x01,0x76,0x03,0x91,0xc4,0x00,0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x78,0x02
	.byte 0x91,0x7c,0x03
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x78,0x02
	.byte 0x91,0x78,0x03
	.ascii "f\0"
	.byte 0x00,0x00,0x03,0xa2,0x01,0x01,0x79,0x02
	.byte 0x91,0x74,0x07
	.uaword .L72
	.uaword .L106
	.byte 0x07
	.uaword .L78
	.uaword .L103
	.byte 0x07
	.uaword .L79
	.uaword .L102
	.byte 0x07
	.uaword .L80
	.uaword .L101
	.byte 0x07
	.uaword .L86
	.uaword .L98
	.byte 0x07
	.uaword .L87
	.uaword .L97
	.byte 0x03
	.ascii "k\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x93,0x02
	.byte 0x91,0x70,0x03
	.ascii "vx\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x6c,0x03
	.ascii "vy\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x68,0x03
	.ascii "vz\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x64,0x03
	.ascii "nx\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x60,0x03
	.ascii "ny\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x5c,0x03
	.ascii "nz\0"
	.byte 0x00,0x00,0x01,0x01,0x01,0x01,0x94,0x02
	.byte 0x91,0x58,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x02
	.ascii "char\0"
	.byte 0x06,0x01,0x08,0x00,0x00,0x02,0x80,0x09
	.byte 0x00,0x00,0x02,0x88,0x02
	.ascii "int\0"
	.byte 0x05,0x04,0x02
	.ascii "unsigned char\0"
	.byte 0x08,0x01,0x09,0x00,0x00,0x02,0x99,0x02
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x0a
	.ascii "__FILE\0"
	.byte 0x10,0x03,0x00,0x00,0x03,0x97,0x0b
	.ascii "_cnt\0"
	.byte 0x00,0x00,0x02,0x92,0x02,0x23,0x00,0x0b
	.ascii "_ptr\0"
	.byte 0x00,0x00,0x02,0xaa,0x02,0x23,0x04,0x0b
	.ascii "_base\0"
	.byte 0x00,0x00,0x02,0xaa,0x02,0x23,0x08,0x0b
	.ascii "_flag\0"
	.byte 0x00,0x00,0x02,0x99,0x02,0x23,0x0c,0x0b
	.ascii "_file\0"
	.byte 0x00,0x00,0x02,0x99,0x02,0x23,0x0d,0x0c
	.ascii "__orientation\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x10,0x02,0x0c
	.ascii "__ionolock\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x12,0x01,0x0c
	.ascii "__seekable\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x13,0x01,0x0c
	.ascii "__extendedfd\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x14,0x01,0x0c
	.ascii "__xf_nocheck\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x15,0x01,0x0c
	.ascii "__filler\0"
	.byte 0x00,0x00,0x02,0xaf,0x02,0x23,0x0c,0x04
	.byte 0x16,0x0a,0x00,0x04,0x00,0x00,0x02,0xbb
	.ascii "FILE\0"
	.byte 0x04,0x09,0x00,0x00,0x03,0x97,0x05
	.ascii "DrawMesh\0"
	.byte 0x03,0x01,0xaa
	.uaword DrawMesh
	.uaword .L150
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x04,0x37
	.byte 0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xab,0x02
	.byte 0x91,0x7c,0x03
	.ascii "j\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xab,0x02
	.byte 0x91,0x78,0x07
	.uaword .L115
	.uaword .L148
	.byte 0x07
	.uaword .L121
	.uaword .L145
	.byte 0x07
	.uaword .L122
	.uaword .L144
	.byte 0x07
	.uaword .L124
	.uaword .L142
	.byte 0x07
	.uaword .L130
	.uaword .L139
	.byte 0x07
	.uaword .L131
	.uaword .L138
	.byte 0x03
	.ascii "k0\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xb0,0x02
	.byte 0x91,0x74,0x03
	.ascii "k1\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xb1,0x02
	.byte 0x91,0x70,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x05
	.ascii "SPECWriteIntermediateImage\0"
	.byte 0x03,0x01,0xbf
	.uaword SPECWriteIntermediateImage
	.uaword .L184
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x05,0x1a
	.byte 0x06,0x00,0x00,0x03,0xa2
	.ascii "fip\0"
	.byte 0x01,0xbe,0x03,0x91,0xc4,0x00,0x06,0x00
	.byte 0x00,0x03,0xa2
	.ascii "fop\0"
	.byte 0x01,0xbe,0x03,0x91,0xc8,0x00,0x06,0x00
	.byte 0x00,0x02,0x92
	.ascii "width\0"
	.byte 0x01,0xbe,0x03,0x91,0xcc,0x00,0x06,0x00
	.byte 0x00,0x02,0x92
	.ascii "height\0"
	.byte 0x01,0xbe,0x03,0x91,0xd0,0x00,0x06,0x00
	.byte 0x00,0x05,0x27
	.ascii "buffer\0"
	.byte 0x01,0xbe,0x03,0x91,0xd4,0x00,0x06,0x00
	.byte 0x00,0x02,0x92
	.ascii "frame_count\0"
	.byte 0x01,0xbe,0x03,0x91,0xd8,0x00,0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xc0,0x02
	.byte 0x91,0x7c,0x03
	.ascii "x\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xc0,0x02
	.byte 0x91,0x78,0x03
	.ascii "y\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xc0,0x02
	.byte 0x91,0x74,0x03
	.ascii "ptr\0"
	.byte 0x00,0x00,0x05,0x3a,0x01,0x01,0xc1,0x02
	.byte 0x91,0x70,0x03
	.ascii "counter\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xc2,0x02
	.byte 0x91,0x6c,0x00,0x02
	.ascii "void\0"
	.byte 0x05,0x00,0x08,0x00,0x00,0x05,0x1a,0x09
	.byte 0x00,0x00,0x05,0x22,0x04,0x00,0x00,0x02
	.byte 0x99
	.ascii "GLubyte\0"
	.byte 0x02,0x09,0x00,0x00,0x05,0x2c,0x05
	.ascii "Render\0"
	.byte 0x03,0x01,0xd8
	.uaword Render
	.uaword .L269
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x05,0xcd
	.byte 0x06,0x00,0x00,0x02,0x92
	.ascii "frames\0"
	.byte 0x01,0xd7,0x03,0x91,0xc4,0x00,0x06,0x00
	.byte 0x00,0x02,0x92
	.ascii "width\0"
	.byte 0x01,0xd7,0x03,0x91,0xc8,0x00,0x06,0x00
	.byte 0x00,0x02,0x92
	.ascii "height\0"
	.byte 0x01,0xd7,0x03,0x91,0xcc,0x00,0x06,0x00
	.byte 0x00,0x05,0xd2
	.ascii "buffer\0"
	.byte 0x01,0xd7,0x03,0x91,0xd0,0x00,0x03
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0xd9,0x02
	.byte 0x91,0x7c,0x03
	.ascii "fip\0"
	.byte 0x00,0x00,0x03,0xa2,0x01,0x01,0xda,0x02
	.byte 0x91,0x78,0x03
	.ascii "fop\0"
	.byte 0x00,0x00,0x03,0xa2,0x01,0x01,0xdb,0x02
	.byte 0x91,0x74,0x00,0x08,0x00,0x00,0x05,0x1a
	.byte 0x09,0x00,0x00,0x05,0xcd,0x0d
	.ascii "Reshape\0"
	.byte 0x03,0x01,0x01,0x1b
	.uaword Reshape
	.uaword .L284
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x06,0x28
	.byte 0x0e,0x00,0x00,0x02,0x92
	.ascii "width\0"
	.byte 0x01,0x01,0x1a,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x02,0x92
	.ascii "height\0"
	.byte 0x01,0x01,0x1a,0x03,0x91,0xc8,0x00,0x0f
	.ascii "w\0"
	.byte 0x00,0x00,0x01,0x56,0x01,0x01,0x01,0x1c
	.byte 0x02,0x91,0x7c,0x00,0x0d
	.ascii "Init\0"
	.byte 0x03,0x01,0x01,0x2c
	.uaword Init
	.uaword .L354
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x07,0x34
	.byte 0x0f
	.ascii "i\0"
	.byte 0x00,0x00,0x07,0x34,0x01,0x01,0x01,0x2d
	.byte 0x02,0x91,0x7c,0x0f
	.ascii "texture\0"
	.byte 0x00,0x00,0x07,0x48,0x01,0x01,0x01,0x2e
	.byte 0x03,0x91,0xfc,0x7d,0x0f
	.ascii "texPlane\0"
	.byte 0x00,0x00,0x07,0x5b,0x03,0x01,0x01,0x2f
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.texPlane
	.byte 0x0f
	.ascii "blue\0"
	.byte 0x00,0x00,0x07,0x6c,0x03,0x01,0x01,0x30
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.blue
	.byte 0x0f
	.ascii "white\0"
	.byte 0x00,0x00,0x07,0x7d,0x03,0x01,0x01,0x31
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.white
	.byte 0x0f
	.ascii "posred\0"
	.byte 0x00,0x00,0x07,0x8e,0x03,0x01,0x01,0x53
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.posred
	.byte 0x0f
	.ascii "posgreen\0"
	.byte 0x00,0x00,0x07,0x9f,0x03,0x01,0x01,0x54
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.posgreen
	.byte 0x0f
	.ascii "posblue\0"
	.byte 0x00,0x00,0x07,0xb0,0x03,0x01,0x01,0x55
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.posblue
	.byte 0x0f
	.ascii "grayred\0"
	.byte 0x00,0x00,0x07,0xc1,0x03,0x01,0x01,0x58
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.grayred
	.byte 0x0f
	.ascii "graygreen\0"
	.byte 0x00,0x00,0x07,0xd2,0x03,0x01,0x01,0x59
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.graygreen
	.byte 0x0f
	.ascii "grayblue\0"
	.byte 0x00,0x00,0x07,0xe3,0x03,0x01,0x01,0x5a
	.byte 0x05,0x03
	.uaword $XBa59JCTsd3LWaL.Init.grayblue
	.byte 0x00,0x04,0x00,0x00,0x02,0x92
	.ascii "GLint\0"
	.byte 0x02,0x02
	.ascii "long\0"
	.byte 0x05,0x04,0x10,0x00,0x00,0x05,0x2c,0x01
	.byte 0x00,0x00,0x00,0x07,0x5b,0x11,0x00,0x00
	.byte 0x07,0x40,0x00,0xff,0x00,0x12,0x00,0x00
	.byte 0x01,0x56,0x10,0x00,0x00,0x07,0x6c,0x13
	.byte 0x00,0x00,0x07,0x40,0x03,0x00,0x12,0x00
	.byte 0x00,0x01,0x56,0x10,0x00,0x00,0x07,0x7d
	.byte 0x13,0x00,0x00,0x07,0x40,0x03,0x00,0x12
	.byte 0x00,0x00,0x01,0x56,0x10,0x00,0x00,0x07
	.byte 0x8e,0x13,0x00,0x00,0x07,0x40,0x03,0x00
	.byte 0x12,0x00,0x00,0x01,0x56,0x10,0x00,0x00
	.byte 0x07,0x9f,0x13,0x00,0x00,0x07,0x40,0x03
	.byte 0x00,0x12,0x00,0x00,0x01,0x56,0x10,0x00
	.byte 0x00,0x07,0xb0,0x13,0x00,0x00,0x07,0x40
	.byte 0x03,0x00,0x12,0x00,0x00,0x01,0x56,0x10
	.byte 0x00,0x00,0x07,0xc1,0x13,0x00,0x00,0x07
	.byte 0x40,0x03,0x00,0x12,0x00,0x00,0x01,0x56
	.byte 0x10,0x00,0x00,0x07,0xd2,0x13,0x00,0x00
	.byte 0x07,0x40,0x03,0x00,0x12,0x00,0x00,0x01
	.byte 0x56,0x10,0x00,0x00,0x07,0xe3,0x13,0x00
	.byte 0x00,0x07,0x40,0x03,0x00,0x12,0x00,0x00
	.byte 0x01,0x56,0x10,0x00,0x00,0x07,0xf4,0x13
	.byte 0x00,0x00,0x07,0x40,0x03,0x00,0x0d
	.ascii "WriteImage\0"
	.byte 0x03,0x01,0x01,0x92
	.uaword WriteImage
	.uaword .L423
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x08,0xdc
	.byte 0x0e,0x00,0x00,0x08,0xe1
	.ascii "filename\0"
	.byte 0x01,0x01,0x90,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x02,0x92
	.ascii "width\0"
	.byte 0x01,0x01,0x90,0x03,0x91,0xc8,0x00,0x0e
	.byte 0x00,0x00,0x02,0x92
	.ascii "height\0"
	.byte 0x01,0x01,0x90,0x03,0x91,0xcc,0x00,0x0e
	.byte 0x00,0x00,0x08,0xeb
	.ascii "buffer\0"
	.byte 0x01,0x01,0x91,0x03,0x91,0xd0,0x00,0x0f
	.ascii "f\0"
	.byte 0x00,0x00,0x03,0xa2,0x01,0x01,0x01,0x93
	.byte 0x02,0x91,0x7c,0x07
	.uaword .L362
	.uaword .L421
	.byte 0x07
	.uaword .L366
	.uaword .L420
	.byte 0x07
	.uaword .L367
	.uaword .L419
	.byte 0x0f
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0x95
	.byte 0x02,0x91,0x78,0x0f
	.ascii "x\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0x95
	.byte 0x02,0x91,0x74,0x0f
	.ascii "y\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0x95
	.byte 0x02,0x91,0x70,0x0f
	.ascii "ptr\0"
	.byte 0x00,0x00,0x05,0x3a,0x01,0x01,0x01,0x96
	.byte 0x02,0x91,0x6c,0x0f
	.ascii "counter\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0x97
	.byte 0x02,0x91,0x68,0x00,0x00,0x00,0x00,0x08
	.byte 0x00,0x00,0x02,0x80,0x09,0x00,0x00,0x08
	.byte 0xdc,0x08,0x00,0x00,0x05,0x1a,0x09,0x00
	.byte 0x00,0x08,0xe6,0x14
	.ascii "main\0"
	.byte 0x01,0x02,0x02,0x01,0x01,0xab
	.uaword main
	.uaword .L558
	.byte 0x01,0x6e,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x09,0xc4,0x0e,0x00,0x00,0x02
	.byte 0x92
	.ascii "argc\0"
	.byte 0x01,0x01,0xaa,0x03,0x91,0xc4,0x00,0x0e
	.byte 0x00,0x00,0x09,0xc9
	.ascii "argv\0"
	.byte 0x01,0x01,0xaa,0x03,0x91,0xc8,0x00,0x0f
	.ascii "ctx\0"
	.byte 0x00,0x00,0x09,0xe4,0x01,0x01,0x01,0xac
	.byte 0x02,0x91,0x78,0x0f
	.ascii "buffer\0"
	.byte 0x00,0x00,0x09,0xf8,0x01,0x01,0x01,0xad
	.byte 0x02,0x91,0x74,0x0f
	.ascii "frames\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0xae
	.byte 0x02,0x91,0x70,0x0f
	.ascii "ppmFile\0"
	.byte 0x00,0x00,0x09,0xc4,0x01,0x01,0x01,0xaf
	.byte 0x02,0x91,0x6c,0x0f
	.ascii "meshFile\0"
	.byte 0x00,0x00,0x09,0xc4,0x01,0x01,0x01,0xb0
	.byte 0x02,0x91,0x68,0x0f
	.ascii "intermediateResultsFile\0"
	.byte 0x00,0x00,0x09,0xc4,0x01,0x01,0x01,0xb1
	.byte 0x02,0x91,0x64,0x0f
	.ascii "i\0"
	.byte 0x00,0x00,0x02,0x92,0x01,0x01,0x01,0xb2
	.byte 0x02,0x91,0x60,0x00,0x09,0x00,0x00,0x02
	.byte 0x80,0x09,0x00,0x00,0x09,0xc4,0x15
	.ascii "osmesa_context\0"
	.byte 0x01,0x09,0x00,0x00,0x09,0xce,0x04,0x00
	.byte 0x00,0x09,0xdf
	.ascii "OSMesaContext\0"
	.byte 0x05,0x09,0x00,0x00,0x05,0x1a,0x09,0x00
	.byte 0x00,0x01,0x56,0x03
	.ascii "SurfaceN\0"
	.byte 0x00,0x00,0x09,0xfd,0x03,0x01,0x60,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.SurfaceN
	.byte 0x03
	.ascii "SurfaceV\0"
	.byte 0x00,0x00,0x09,0xfd,0x03,0x01,0x5f,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.SurfaceV
	.byte 0x03
	.ascii "NumColumns\0"
	.byte 0x00,0x00,0x02,0x92,0x03,0x01,0x5e,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.NumColumns
	.byte 0x03
	.ascii "NumRows\0"
	.byte 0x00,0x00,0x02,0x92,0x03,0x01,0x5e,0x05
	.byte 0x03
	.uaword $XAa59JCTsd3LWaL.NumRows
	.byte 0x09,0x00,0x00,0x09,0xce,0x09,0x00,0x00
	.byte 0x05,0x1a,0x16,0x04,0x02,0x00,0x00,0x3a
	.byte 0x05,0x17
	.ascii "GL_FALSE\0"
	.byte 0x00,0x17
	.ascii "GL_TRUE\0"
	.byte 0x01,0x17
	.ascii "GL_BYTE\0"
	.byte 0x80,0x28,0x17
	.ascii "GL_UNSIGNED_BYTE\0"
	.byte 0x81,0x28,0x17
	.ascii "GL_SHORT\0"
	.byte 0x82,0x28,0x17
	.ascii "GL_UNSIGNED_SHORT\0"
	.byte 0x83,0x28,0x17
	.ascii "GL_INT\0"
	.byte 0x84,0x28,0x17
	.ascii "GL_UNSIGNED_INT\0"
	.byte 0x85,0x28,0x17
	.ascii "GL_FLOAT\0"
	.byte 0x86,0x28,0x17
	.ascii "GL_DOUBLE\0"
	.byte 0x8a,0x28,0x17
	.ascii "GL_2_BYTES\0"
	.byte 0x87,0x28,0x17
	.ascii "GL_3_BYTES\0"
	.byte 0x88,0x28,0x17
	.ascii "GL_4_BYTES\0"
	.byte 0x89,0x28,0x17
	.ascii "GL_LINES\0"
	.byte 0x01,0x17
	.ascii "GL_POINTS\0"
	.byte 0x00,0x17
	.ascii "GL_LINE_STRIP\0"
	.byte 0x03,0x17
	.ascii "GL_LINE_LOOP\0"
	.byte 0x02,0x17
	.ascii "GL_TRIANGLES\0"
	.byte 0x04,0x17
	.ascii "GL_TRIANGLE_STRIP\0"
	.byte 0x05,0x17
	.ascii "GL_TRIANGLE_FAN\0"
	.byte 0x06,0x17
	.ascii "GL_QUADS\0"
	.byte 0x07,0x17
	.ascii "GL_QUAD_STRIP\0"
	.byte 0x08,0x17
	.ascii "GL_POLYGON\0"
	.byte 0x09,0x17
	.ascii "GL_EDGE_FLAG\0"
	.byte 0xc3,0x16,0x17
	.ascii "GL_VERTEX_ARRAY\0"
	.byte 0xf4,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY\0"
	.byte 0xf5,0x80,0x02,0x17
	.ascii "GL_COLOR_ARRAY\0"
	.byte 0xf6,0x80,0x02,0x17
	.ascii "GL_INDEX_ARRAY\0"
	.byte 0xf7,0x80,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY\0"
	.byte 0xf8,0x80,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY\0"
	.byte 0xf9,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_SIZE\0"
	.byte 0xfa,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_TYPE\0"
	.byte 0xfb,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_STRIDE\0"
	.byte 0xfc,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_TYPE\0"
	.byte 0xfe,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_STRIDE\0"
	.byte 0xff,0x80,0x02,0x17
	.ascii "GL_COLOR_ARRAY_SIZE\0"
	.byte 0x81,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_TYPE\0"
	.byte 0x82,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_STRIDE\0"
	.byte 0x83,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_TYPE\0"
	.byte 0x85,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_STRIDE\0"
	.byte 0x86,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE\0"
	.byte 0x88,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE\0"
	.byte 0x89,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE\0"
	.byte 0x8a,0x81,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE\0"
	.byte 0x8c,0x81,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_POINTER\0"
	.byte 0x8e,0x81,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_POINTER\0"
	.byte 0x8f,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_POINTER\0"
	.byte 0x90,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_POINTER\0"
	.byte 0x91,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER\0"
	.byte 0x92,0x81,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER\0"
	.byte 0x93,0x81,0x02,0x17
	.ascii "GL_V2F\0"
	.byte 0xa0,0xd4,0x00,0x17
	.ascii "GL_V3F\0"
	.byte 0xa1,0xd4,0x00,0x17
	.ascii "GL_C4UB_V2F\0"
	.byte 0xa2,0xd4,0x00,0x17
	.ascii "GL_C4UB_V3F\0"
	.byte 0xa3,0xd4,0x00,0x17
	.ascii "GL_C3F_V3F\0"
	.byte 0xa4,0xd4,0x00,0x17
	.ascii "GL_N3F_V3F\0"
	.byte 0xa5,0xd4,0x00,0x17
	.ascii "GL_C4F_N3F_V3F\0"
	.byte 0xa6,0xd4,0x00,0x17
	.ascii "GL_T2F_V3F\0"
	.byte 0xa7,0xd4,0x00,0x17
	.ascii "GL_T4F_V4F\0"
	.byte 0xa8,0xd4,0x00,0x17
	.ascii "GL_T2F_C4UB_V3F\0"
	.byte 0xa9,0xd4,0x00,0x17
	.ascii "GL_T2F_C3F_V3F\0"
	.byte 0xaa,0xd4,0x00,0x17
	.ascii "GL_T2F_N3F_V3F\0"
	.byte 0xab,0xd4,0x00,0x17
	.ascii "GL_T2F_C4F_N3F_V3F\0"
	.byte 0xac,0xd4,0x00,0x17
	.ascii "GL_T4F_C4F_N3F_V4F\0"
	.byte 0xad,0xd4,0x00,0x17
	.ascii "GL_MATRIX_MODE\0"
	.byte 0xa0,0x17,0x17
	.ascii "GL_MODELVIEW\0"
	.byte 0x80,0x2e,0x17
	.ascii "GL_PROJECTION\0"
	.byte 0x81,0x2e,0x17
	.ascii "GL_TEXTURE\0"
	.byte 0x82,0x2e,0x17
	.ascii "GL_POINT_SMOOTH\0"
	.byte 0x90,0x16,0x17
	.ascii "GL_POINT_SIZE\0"
	.byte 0x91,0x16,0x17
	.ascii "GL_POINT_SIZE_GRANULARITY\0"
	.byte 0x93,0x16,0x17
	.ascii "GL_POINT_SIZE_RANGE\0"
	.byte 0x92,0x16,0x17
	.ascii "GL_LINE_SMOOTH\0"
	.byte 0xa0,0x16,0x17
	.ascii "GL_LINE_STIPPLE\0"
	.byte 0xa4,0x16,0x17
	.ascii "GL_LINE_STIPPLE_PATTERN\0"
	.byte 0xa5,0x16,0x17
	.ascii "GL_LINE_STIPPLE_REPEAT\0"
	.byte 0xa6,0x16,0x17
	.ascii "GL_LINE_WIDTH\0"
	.byte 0xa1,0x16,0x17
	.ascii "GL_LINE_WIDTH_GRANULARITY\0"
	.byte 0xa3,0x16,0x17
	.ascii "GL_LINE_WIDTH_RANGE\0"
	.byte 0xa2,0x16,0x17
	.ascii "GL_POINT\0"
	.byte 0x80,0x36,0x17
	.ascii "GL_LINE\0"
	.byte 0x81,0x36,0x17
	.ascii "GL_FILL\0"
	.byte 0x82,0x36,0x17
	.ascii "GL_CCW\0"
	.byte 0x81,0x12,0x17
	.ascii "GL_CW\0"
	.byte 0x80,0x12,0x17
	.ascii "GL_FRONT\0"
	.byte 0x84,0x08,0x17
	.ascii "GL_BACK\0"
	.byte 0x85,0x08,0x17
	.ascii "GL_CULL_FACE\0"
	.byte 0xc4,0x16,0x17
	.ascii "GL_CULL_FACE_MODE\0"
	.byte 0xc5,0x16,0x17
	.ascii "GL_POLYGON_SMOOTH\0"
	.byte 0xc1,0x16,0x17
	.ascii "GL_POLYGON_STIPPLE\0"
	.byte 0xc2,0x16,0x17
	.ascii "GL_FRONT_FACE\0"
	.byte 0xc6,0x16,0x17
	.ascii "GL_POLYGON_MODE\0"
	.byte 0xc0,0x16,0x17
	.ascii "GL_POLYGON_OFFSET_FACTOR\0"
	.byte 0xb8,0x80,0x02,0x17
	.ascii "GL_POLYGON_OFFSET_UNITS\0"
	.byte 0x80,0xd4,0x00,0x17
	.ascii "GL_POLYGON_OFFSET_POINT\0"
	.byte 0x81,0xd4,0x00,0x17
	.ascii "GL_POLYGON_OFFSET_LINE\0"
	.byte 0x82,0xd4,0x00,0x17
	.ascii "GL_POLYGON_OFFSET_FILL\0"
	.byte 0xb7,0x80,0x02,0x17
	.ascii "GL_COMPILE\0"
	.byte 0x80,0x26,0x17
	.ascii "GL_COMPILE_AND_EXECUTE\0"
	.byte 0x81,0x26,0x17
	.ascii "GL_LIST_BASE\0"
	.byte 0xb2,0x16,0x17
	.ascii "GL_LIST_INDEX\0"
	.byte 0xb3,0x16,0x17
	.ascii "GL_LIST_MODE\0"
	.byte 0xb0,0x16,0x17
	.ascii "GL_NEVER\0"
	.byte 0x80,0x04,0x17
	.ascii "GL_LESS\0"
	.byte 0x81,0x04,0x17
	.ascii "GL_GEQUAL\0"
	.byte 0x86,0x04,0x17
	.ascii "GL_LEQUAL\0"
	.byte 0x83,0x04,0x17
	.ascii "GL_GREATER\0"
	.byte 0x84,0x04,0x17
	.ascii "GL_NOTEQUAL\0"
	.byte 0x85,0x04,0x17
	.ascii "GL_EQUAL\0"
	.byte 0x82,0x04,0x17
	.ascii "GL_ALWAYS\0"
	.byte 0x87,0x04,0x17
	.ascii "GL_DEPTH_TEST\0"
	.byte 0xf1,0x16,0x17
	.ascii "GL_DEPTH_BITS\0"
	.byte 0xd6,0x1a,0x17
	.ascii "GL_DEPTH_CLEAR_VALUE\0"
	.byte 0xf3,0x16,0x17
	.ascii "GL_DEPTH_FUNC\0"
	.byte 0xf4,0x16,0x17
	.ascii "GL_DEPTH_RANGE\0"
	.byte 0xf0,0x16,0x17
	.ascii "GL_DEPTH_WRITEMASK\0"
	.byte 0xf2,0x16,0x17
	.ascii "GL_DEPTH_COMPONENT\0"
	.byte 0x82,0x32,0x17
	.ascii "GL_LIGHTING\0"
	.byte 0xd0,0x16,0x17
	.ascii "GL_LIGHT0\0"
	.byte 0x80,0x80,0x01,0x17
	.ascii "GL_LIGHT1\0"
	.byte 0x81,0x80,0x01,0x17
	.ascii "GL_LIGHT2\0"
	.byte 0x82,0x80,0x01,0x17
	.ascii "GL_LIGHT3\0"
	.byte 0x83,0x80,0x01,0x17
	.ascii "GL_LIGHT4\0"
	.byte 0x84,0x80,0x01,0x17
	.ascii "GL_LIGHT5\0"
	.byte 0x85,0x80,0x01,0x17
	.ascii "GL_LIGHT6\0"
	.byte 0x86,0x80,0x01,0x17
	.ascii "GL_LIGHT7\0"
	.byte 0x87,0x80,0x01,0x17
	.ascii "GL_SPOT_EXPONENT\0"
	.byte 0x85,0x24,0x17
	.ascii "GL_SPOT_CUTOFF\0"
	.byte 0x86,0x24,0x17
	.ascii "GL_CONSTANT_ATTENUATION\0"
	.byte 0x87,0x24,0x17
	.ascii "GL_LINEAR_ATTENUATION\0"
	.byte 0x88,0x24,0x17
	.ascii "GL_QUADRATIC_ATTENUATION\0"
	.byte 0x89,0x24,0x17
	.ascii "GL_AMBIENT\0"
	.byte 0x80,0x24,0x17
	.ascii "GL_DIFFUSE\0"
	.byte 0x81,0x24,0x17
	.ascii "GL_SPECULAR\0"
	.byte 0x82,0x24,0x17
	.ascii "GL_SHININESS\0"
	.byte 0x81,0x2c,0x17
	.ascii "GL_EMISSION\0"
	.byte 0x80,0x2c,0x17
	.ascii "GL_POSITION\0"
	.byte 0x83,0x24,0x17
	.ascii "GL_SPOT_DIRECTION\0"
	.byte 0x84,0x24,0x17
	.ascii "GL_AMBIENT_AND_DIFFUSE\0"
	.byte 0x82,0x2c,0x17
	.ascii "GL_COLOR_INDEXES\0"
	.byte 0x83,0x2c,0x17
	.ascii "GL_LIGHT_MODEL_TWO_SIDE\0"
	.byte 0xd2,0x16,0x17
	.ascii "GL_LIGHT_MODEL_LOCAL_VIEWER\0"
	.byte 0xd1,0x16,0x17
	.ascii "GL_LIGHT_MODEL_AMBIENT\0"
	.byte 0xd3,0x16,0x17
	.ascii "GL_FRONT_AND_BACK\0"
	.byte 0x88,0x08,0x17
	.ascii "GL_SHADE_MODEL\0"
	.byte 0xd4,0x16,0x17
	.ascii "GL_FLAT\0"
	.byte 0x80,0x3a,0x17
	.ascii "GL_SMOOTH\0"
	.byte 0x81,0x3a,0x17
	.ascii "GL_COLOR_MATERIAL\0"
	.byte 0xd7,0x16,0x17
	.ascii "GL_COLOR_MATERIAL_FACE\0"
	.byte 0xd5,0x16,0x17
	.ascii "GL_COLOR_MATERIAL_PARAMETER\0"
	.byte 0xd6,0x16,0x17
	.ascii "GL_NORMALIZE\0"
	.byte 0xa1,0x17,0x17
	.ascii "GL_CLIP_PLANE0\0"
	.byte 0x80,0xe0,0x00,0x17
	.ascii "GL_CLIP_PLANE1\0"
	.byte 0x81,0xe0,0x00,0x17
	.ascii "GL_CLIP_PLANE2\0"
	.byte 0x82,0xe0,0x00,0x17
	.ascii "GL_CLIP_PLANE3\0"
	.byte 0x83,0xe0,0x00,0x17
	.ascii "GL_CLIP_PLANE4\0"
	.byte 0x84,0xe0,0x00,0x17
	.ascii "GL_CLIP_PLANE5\0"
	.byte 0x85,0xe0,0x00,0x17
	.ascii "GL_ACCUM_RED_BITS\0"
	.byte 0xd8,0x1a,0x17
	.ascii "GL_ACCUM_GREEN_BITS\0"
	.byte 0xd9,0x1a,0x17
	.ascii "GL_ACCUM_BLUE_BITS\0"
	.byte 0xda,0x1a,0x17
	.ascii "GL_ACCUM_ALPHA_BITS\0"
	.byte 0xdb,0x1a,0x17
	.ascii "GL_ACCUM_CLEAR_VALUE\0"
	.byte 0x80,0x17,0x17
	.ascii "GL_ACCUM\0"
	.byte 0x80,0x02,0x17
	.ascii "GL_ADD\0"
	.byte 0x84,0x02,0x17
	.ascii "GL_LOAD\0"
	.byte 0x81,0x02,0x17
	.ascii "GL_MULT\0"
	.byte 0x83,0x02,0x17
	.ascii "GL_RETURN\0"
	.byte 0x82,0x02,0x17
	.ascii "GL_ALPHA_TEST\0"
	.byte 0xc0,0x17,0x17
	.ascii "GL_ALPHA_TEST_REF\0"
	.byte 0xc2,0x17,0x17
	.ascii "GL_ALPHA_TEST_FUNC\0"
	.byte 0xc1,0x17,0x17
	.ascii "GL_BLEND\0"
	.byte 0xe2,0x17,0x17
	.ascii "GL_BLEND_SRC\0"
	.byte 0xe1,0x17,0x17
	.ascii "GL_BLEND_DST\0"
	.byte 0xe0,0x17,0x17
	.ascii "GL_ZERO\0"
	.byte 0x00,0x17
	.ascii "GL_ONE\0"
	.byte 0x01,0x17
	.ascii "GL_SRC_COLOR\0"
	.byte 0x80,0x06,0x17
	.ascii "GL_ONE_MINUS_SRC_COLOR\0"
	.byte 0x81,0x06,0x17
	.ascii "GL_DST_COLOR\0"
	.byte 0x86,0x06,0x17
	.ascii "GL_ONE_MINUS_DST_COLOR\0"
	.byte 0x87,0x06,0x17
	.ascii "GL_SRC_ALPHA\0"
	.byte 0x82,0x06,0x17
	.ascii "GL_ONE_MINUS_SRC_ALPHA\0"
	.byte 0x83,0x06,0x17
	.ascii "GL_DST_ALPHA\0"
	.byte 0x84,0x06,0x17
	.ascii "GL_ONE_MINUS_DST_ALPHA\0"
	.byte 0x85,0x06,0x17
	.ascii "GL_SRC_ALPHA_SATURATE\0"
	.byte 0x88,0x06,0x17
	.ascii "GL_CONSTANT_COLOR\0"
	.byte 0x81,0x80,0x02,0x17
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR\0"
	.byte 0x82,0x80,0x02,0x17
	.ascii "GL_CONSTANT_ALPHA\0"
	.byte 0x83,0x80,0x02,0x17
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA\0"
	.byte 0x84,0x80,0x02,0x17
	.ascii "GL_FEEDBACK\0"
	.byte 0x81,0x38,0x17
	.ascii "GL_RENDER\0"
	.byte 0x80,0x38,0x17
	.ascii "GL_SELECT\0"
	.byte 0x82,0x38,0x17
	.ascii "GL_2D\0"
	.byte 0x80,0x0c,0x17
	.ascii "GL_3D\0"
	.byte 0x81,0x0c,0x17
	.ascii "GL_3D_COLOR\0"
	.byte 0x82,0x0c,0x17
	.ascii "GL_3D_COLOR_TEXTURE\0"
	.byte 0x83,0x0c,0x17
	.ascii "GL_4D_COLOR_TEXTURE\0"
	.byte 0x84,0x0c,0x17
	.ascii "GL_POINT_TOKEN\0"
	.byte 0x81,0x0e,0x17
	.ascii "GL_LINE_TOKEN\0"
	.byte 0x82,0x0e,0x17
	.ascii "GL_LINE_RESET_TOKEN\0"
	.byte 0x87,0x0e,0x17
	.ascii "GL_POLYGON_TOKEN\0"
	.byte 0x83,0x0e,0x17
	.ascii "GL_BITMAP_TOKEN\0"
	.byte 0x84,0x0e,0x17
	.ascii "GL_DRAW_PIXEL_TOKEN\0"
	.byte 0x85,0x0e,0x17
	.ascii "GL_COPY_PIXEL_TOKEN\0"
	.byte 0x86,0x0e,0x17
	.ascii "GL_PASS_THROUGH_TOKEN\0"
	.byte 0x80,0x0e,0x17
	.ascii "GL_FEEDBACK_BUFFER_POINTER\0"
	.byte 0xf0,0x1b,0x17
	.ascii "GL_FEEDBACK_BUFFER_SIZE\0"
	.byte 0xf1,0x1b,0x17
	.ascii "GL_FEEDBACK_BUFFER_TYPE\0"
	.byte 0xf2,0x1b,0x17
	.ascii "GL_FOG\0"
	.byte 0xe0,0x16,0x17
	.ascii "GL_FOG_MODE\0"
	.byte 0xe5,0x16,0x17
	.ascii "GL_FOG_DENSITY\0"
	.byte 0xe2,0x16,0x17
	.ascii "GL_FOG_COLOR\0"
	.byte 0xe6,0x16,0x17
	.ascii "GL_FOG_INDEX\0"
	.byte 0xe1,0x16,0x17
	.ascii "GL_FOG_START\0"
	.byte 0xe3,0x16,0x17
	.ascii "GL_FOG_END\0"
	.byte 0xe4,0x16,0x17
	.ascii "GL_LINEAR\0"
	.byte 0x81,0xcc,0x00,0x17
	.ascii "GL_EXP\0"
	.byte 0x80,0x10,0x17
	.ascii "GL_EXP2\0"
	.byte 0x81,0x10,0x17
	.ascii "GL_LOGIC_OP\0"
	.byte 0xf1,0x17,0x17
	.ascii "GL_INDEX_LOGIC_OP\0"
	.byte 0xf1,0x17,0x17
	.ascii "GL_COLOR_LOGIC_OP\0"
	.byte 0xf2,0x17,0x17
	.ascii "GL_LOGIC_OP_MODE\0"
	.byte 0xf0,0x17,0x17
	.ascii "GL_CLEAR\0"
	.byte 0x80,0x2a,0x17
	.ascii "GL_SET\0"
	.byte 0x8f,0x2a,0x17
	.ascii "GL_COPY\0"
	.byte 0x83,0x2a,0x17
	.ascii "GL_COPY_INVERTED\0"
	.byte 0x8c,0x2a,0x17
	.ascii "GL_NOOP\0"
	.byte 0x85,0x2a,0x17
	.ascii "GL_INVERT\0"
	.byte 0x8a,0x2a,0x17
	.ascii "GL_AND\0"
	.byte 0x81,0x2a,0x17
	.ascii "GL_NAND\0"
	.byte 0x8e,0x2a,0x17
	.ascii "GL_OR\0"
	.byte 0x87,0x2a,0x17
	.ascii "GL_NOR\0"
	.byte 0x88,0x2a,0x17
	.ascii "GL_XOR\0"
	.byte 0x86,0x2a,0x17
	.ascii "GL_EQUIV\0"
	.byte 0x89,0x2a,0x17
	.ascii "GL_AND_REVERSE\0"
	.byte 0x82,0x2a,0x17
	.ascii "GL_AND_INVERTED\0"
	.byte 0x84,0x2a,0x17
	.ascii "GL_OR_REVERSE\0"
	.byte 0x8b,0x2a,0x17
	.ascii "GL_OR_INVERTED\0"
	.byte 0x8d,0x2a,0x17
	.ascii "GL_STENCIL_TEST\0"
	.byte 0x90,0x17,0x17
	.ascii "GL_STENCIL_WRITEMASK\0"
	.byte 0x98,0x17,0x17
	.ascii "GL_STENCIL_BITS\0"
	.byte 0xd7,0x1a,0x17
	.ascii "GL_STENCIL_FUNC\0"
	.byte 0x92,0x17,0x17
	.ascii "GL_STENCIL_VALUE_MASK\0"
	.byte 0x93,0x17,0x17
	.ascii "GL_STENCIL_REF\0"
	.byte 0x97,0x17,0x17
	.ascii "GL_STENCIL_FAIL\0"
	.byte 0x94,0x17,0x17
	.ascii "GL_STENCIL_PASS_DEPTH_PASS\0"
	.byte 0x96,0x17,0x17
	.ascii "GL_STENCIL_PASS_DEPTH_FAIL\0"
	.byte 0x95,0x17,0x17
	.ascii "GL_STENCIL_CLEAR_VALUE\0"
	.byte 0x91,0x17,0x17
	.ascii "GL_STENCIL_INDEX\0"
	.byte 0x81,0x32,0x17
	.ascii "GL_KEEP\0"
	.byte 0x80,0x3c,0x17
	.ascii "GL_REPLACE\0"
	.byte 0x81,0x3c,0x17
	.ascii "GL_INCR\0"
	.byte 0x82,0x3c,0x17
	.ascii "GL_DECR\0"
	.byte 0x83,0x3c,0x17
	.ascii "GL_NONE\0"
	.byte 0x00,0x17
	.ascii "GL_LEFT\0"
	.byte 0x86,0x08,0x17
	.ascii "GL_RIGHT\0"
	.byte 0x87,0x08,0x17
	.ascii "GL_FRONT_LEFT\0"
	.byte 0x80,0x08,0x17
	.ascii "GL_FRONT_RIGHT\0"
	.byte 0x81,0x08,0x17
	.ascii "GL_BACK_LEFT\0"
	.byte 0x82,0x08,0x17
	.ascii "GL_BACK_RIGHT\0"
	.byte 0x83,0x08,0x17
	.ascii "GL_AUX0\0"
	.byte 0x89,0x08,0x17
	.ascii "GL_AUX1\0"
	.byte 0x8a,0x08,0x17
	.ascii "GL_AUX2\0"
	.byte 0x8b,0x08,0x17
	.ascii "GL_AUX3\0"
	.byte 0x8c,0x08,0x17
	.ascii "GL_COLOR_INDEX\0"
	.byte 0x80,0x32,0x17
	.ascii "GL_RED\0"
	.byte 0x83,0x32,0x17
	.ascii "GL_GREEN\0"
	.byte 0x84,0x32,0x17
	.ascii "GL_BLUE\0"
	.byte 0x85,0x32,0x17
	.ascii "GL_ALPHA\0"
	.byte 0x86,0x32,0x17
	.ascii "GL_LUMINANCE\0"
	.byte 0x89,0x32,0x17
	.ascii "GL_LUMINANCE_ALPHA\0"
	.byte 0x8a,0x32,0x17
	.ascii "GL_ALPHA_BITS\0"
	.byte 0xd5,0x1a,0x17
	.ascii "GL_RED_BITS\0"
	.byte 0xd2,0x1a,0x17
	.ascii "GL_GREEN_BITS\0"
	.byte 0xd3,0x1a,0x17
	.ascii "GL_BLUE_BITS\0"
	.byte 0xd4,0x1a,0x17
	.ascii "GL_INDEX_BITS\0"
	.byte 0xd1,0x1a,0x17
	.ascii "GL_SUBPIXEL_BITS\0"
	.byte 0xd0,0x1a,0x17
	.ascii "GL_AUX_BUFFERS\0"
	.byte 0x80,0x18,0x17
	.ascii "GL_READ_BUFFER\0"
	.byte 0x82,0x18,0x17
	.ascii "GL_DRAW_BUFFER\0"
	.byte 0x81,0x18,0x17
	.ascii "GL_DOUBLEBUFFER\0"
	.byte 0xb2,0x18,0x17
	.ascii "GL_STEREO\0"
	.byte 0xb3,0x18,0x17
	.ascii "GL_BITMAP\0"
	.byte 0x80,0x34,0x17
	.ascii "GL_COLOR\0"
	.byte 0x80,0x30,0x17
	.ascii "GL_DEPTH\0"
	.byte 0x81,0x30,0x17
	.ascii "GL_STENCIL\0"
	.byte 0x82,0x30,0x17
	.ascii "GL_DITHER\0"
	.byte 0xd0,0x17,0x17
	.ascii "GL_RGB\0"
	.byte 0x87,0x32,0x17
	.ascii "GL_RGBA\0"
	.byte 0x88,0x32,0x17
	.ascii "GL_MAX_LIST_NESTING\0"
	.byte 0xb1,0x16,0x17
	.ascii "GL_MAX_ATTRIB_STACK_DEPTH\0"
	.byte 0xb5,0x1a,0x17
	.ascii "GL_MAX_MODELVIEW_STACK_DEPTH\0"
	.byte 0xb6,0x1a,0x17
	.ascii "GL_MAX_NAME_STACK_DEPTH\0"
	.byte 0xb7,0x1a,0x17
	.ascii "GL_MAX_PROJECTION_STACK_DEPTH\0"
	.byte 0xb8,0x1a,0x17
	.ascii "GL_MAX_TEXTURE_STACK_DEPTH\0"
	.byte 0xb9,0x1a,0x17
	.ascii "GL_MAX_EVAL_ORDER\0"
	.byte 0xb0,0x1a,0x17
	.ascii "GL_MAX_LIGHTS\0"
	.byte 0xb1,0x1a,0x17
	.ascii "GL_MAX_CLIP_PLANES\0"
	.byte 0xb2,0x1a,0x17
	.ascii "GL_MAX_TEXTURE_SIZE\0"
	.byte 0xb3,0x1a,0x17
	.ascii "GL_MAX_PIXEL_MAP_TABLE\0"
	.byte 0xb4,0x1a,0x17
	.ascii "GL_MAX_VIEWPORT_DIMS\0"
	.byte 0xba,0x1a,0x17
	.ascii "GL_MAX_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xbb,0x1a,0x17
	.ascii "GL_ATTRIB_STACK_DEPTH\0"
	.byte 0xb0,0x17,0x17
	.ascii "GL_CLIENT_ATTRIB_STACK_DEPTH\0"
	.byte 0xb1,0x17,0x17
	.ascii "GL_COLOR_CLEAR_VALUE\0"
	.byte 0xa2,0x18,0x17
	.ascii "GL_COLOR_WRITEMASK\0"
	.byte 0xa3,0x18,0x17
	.ascii "GL_CURRENT_INDEX\0"
	.byte 0x81,0x16,0x17
	.ascii "GL_CURRENT_COLOR\0"
	.byte 0x80,0x16,0x17
	.ascii "GL_CURRENT_NORMAL\0"
	.byte 0x82,0x16,0x17
	.ascii "GL_CURRENT_RASTER_COLOR\0"
	.byte 0x84,0x16,0x17
	.ascii "GL_CURRENT_RASTER_DISTANCE\0"
	.byte 0x89,0x16,0x17
	.ascii "GL_CURRENT_RASTER_INDEX\0"
	.byte 0x85,0x16,0x17
	.ascii "GL_CURRENT_RASTER_POSITION\0"
	.byte 0x87,0x16,0x17
	.ascii "GL_CURRENT_RASTER_TEXTURE_COORDS\0"
	.byte 0x86,0x16,0x17
	.ascii "GL_CURRENT_RASTER_POSITION_VALID\0"
	.byte 0x88,0x16,0x17
	.ascii "GL_CURRENT_TEXTURE_COORDS\0"
	.byte 0x83,0x16,0x17
	.ascii "GL_INDEX_CLEAR_VALUE\0"
	.byte 0xa0,0x18,0x17
	.ascii "GL_INDEX_MODE\0"
	.byte 0xb0,0x18,0x17
	.ascii "GL_INDEX_WRITEMASK\0"
	.byte 0xa1,0x18,0x17
	.ascii "GL_MODELVIEW_MATRIX\0"
	.byte 0xa6,0x17,0x17
	.ascii "GL_MODELVIEW_STACK_DEPTH\0"
	.byte 0xa3,0x17,0x17
	.ascii "GL_NAME_STACK_DEPTH\0"
	.byte 0xf0,0x1a,0x17
	.ascii "GL_PROJECTION_MATRIX\0"
	.byte 0xa7,0x17,0x17
	.ascii "GL_PROJECTION_STACK_DEPTH\0"
	.byte 0xa4,0x17,0x17
	.ascii "GL_RENDER_MODE\0"
	.byte 0xc0,0x18,0x17
	.ascii "GL_RGBA_MODE\0"
	.byte 0xb1,0x18,0x17
	.ascii "GL_TEXTURE_MATRIX\0"
	.byte 0xa8,0x17,0x17
	.ascii "GL_TEXTURE_STACK_DEPTH\0"
	.byte 0xa5,0x17,0x17
	.ascii "GL_VIEWPORT\0"
	.byte 0xa2,0x17,0x17
	.ascii "GL_AUTO_NORMAL\0"
	.byte 0x80,0x1b,0x17
	.ascii "GL_MAP1_COLOR_4\0"
	.byte 0x90,0x1b,0x17
	.ascii "GL_MAP1_GRID_DOMAIN\0"
	.byte 0xd0,0x1b,0x17
	.ascii "GL_MAP1_GRID_SEGMENTS\0"
	.byte 0xd1,0x1b,0x17
	.ascii "GL_MAP1_INDEX\0"
	.byte 0x91,0x1b,0x17
	.ascii "GL_MAP1_NORMAL\0"
	.byte 0x92,0x1b,0x17
	.ascii "GL_MAP1_TEXTURE_COORD_1\0"
	.byte 0x93,0x1b,0x17
	.ascii "GL_MAP1_TEXTURE_COORD_2\0"
	.byte 0x94,0x1b,0x17
	.ascii "GL_MAP1_TEXTURE_COORD_3\0"
	.byte 0x95,0x1b,0x17
	.ascii "GL_MAP1_TEXTURE_COORD_4\0"
	.byte 0x96,0x1b,0x17
	.ascii "GL_MAP1_VERTEX_3\0"
	.byte 0x97,0x1b,0x17
	.ascii "GL_MAP1_VERTEX_4\0"
	.byte 0x98,0x1b,0x17
	.ascii "GL_MAP2_COLOR_4\0"
	.byte 0xb0,0x1b,0x17
	.ascii "GL_MAP2_GRID_DOMAIN\0"
	.byte 0xd2,0x1b,0x17
	.ascii "GL_MAP2_GRID_SEGMENTS\0"
	.byte 0xd3,0x1b,0x17
	.ascii "GL_MAP2_INDEX\0"
	.byte 0xb1,0x1b,0x17
	.ascii "GL_MAP2_NORMAL\0"
	.byte 0xb2,0x1b,0x17
	.ascii "GL_MAP2_TEXTURE_COORD_1\0"
	.byte 0xb3,0x1b,0x17
	.ascii "GL_MAP2_TEXTURE_COORD_2\0"
	.byte 0xb4,0x1b,0x17
	.ascii "GL_MAP2_TEXTURE_COORD_3\0"
	.byte 0xb5,0x1b,0x17
	.ascii "GL_MAP2_TEXTURE_COORD_4\0"
	.byte 0xb6,0x1b,0x17
	.ascii "GL_MAP2_VERTEX_3\0"
	.byte 0xb7,0x1b,0x17
	.ascii "GL_MAP2_VERTEX_4\0"
	.byte 0xb8,0x1b,0x17
	.ascii "GL_COEFF\0"
	.byte 0x80,0x14,0x17
	.ascii "GL_DOMAIN\0"
	.byte 0x82,0x14,0x17
	.ascii "GL_ORDER\0"
	.byte 0x81,0x14,0x17
	.ascii "GL_FOG_HINT\0"
	.byte 0xd4,0x18,0x17
	.ascii "GL_LINE_SMOOTH_HINT\0"
	.byte 0xd2,0x18,0x17
	.ascii "GL_PERSPECTIVE_CORRECTION_HINT\0"
	.byte 0xd0,0x18,0x17
	.ascii "GL_POINT_SMOOTH_HINT\0"
	.byte 0xd1,0x18,0x17
	.ascii "GL_POLYGON_SMOOTH_HINT\0"
	.byte 0xd3,0x18,0x17
	.ascii "GL_DONT_CARE\0"
	.byte 0x80,0x22,0x17
	.ascii "GL_FASTEST\0"
	.byte 0x81,0x22,0x17
	.ascii "GL_NICEST\0"
	.byte 0x82,0x22,0x17
	.ascii "GL_SCISSOR_TEST\0"
	.byte 0x91,0x18,0x17
	.ascii "GL_SCISSOR_BOX\0"
	.byte 0x90,0x18,0x17
	.ascii "GL_MAP_COLOR\0"
	.byte 0x90,0x1a,0x17
	.ascii "GL_MAP_STENCIL\0"
	.byte 0x91,0x1a,0x17
	.ascii "GL_INDEX_SHIFT\0"
	.byte 0x92,0x1a,0x17
	.ascii "GL_INDEX_OFFSET\0"
	.byte 0x93,0x1a,0x17
	.ascii "GL_RED_SCALE\0"
	.byte 0x94,0x1a,0x17
	.ascii "GL_RED_BIAS\0"
	.byte 0x95,0x1a,0x17
	.ascii "GL_GREEN_SCALE\0"
	.byte 0x98,0x1a,0x17
	.ascii "GL_GREEN_BIAS\0"
	.byte 0x99,0x1a,0x17
	.ascii "GL_BLUE_SCALE\0"
	.byte 0x9a,0x1a,0x17
	.ascii "GL_BLUE_BIAS\0"
	.byte 0x9b,0x1a,0x17
	.ascii "GL_ALPHA_SCALE\0"
	.byte 0x9c,0x1a,0x17
	.ascii "GL_ALPHA_BIAS\0"
	.byte 0x9d,0x1a,0x17
	.ascii "GL_DEPTH_SCALE\0"
	.byte 0x9e,0x1a,0x17
	.ascii "GL_DEPTH_BIAS\0"
	.byte 0x9f,0x1a,0x17
	.ascii "GL_PIXEL_MAP_S_TO_S_SIZE\0"
	.byte 0xb1,0x19,0x17
	.ascii "GL_PIXEL_MAP_I_TO_I_SIZE\0"
	.byte 0xb0,0x19,0x17
	.ascii "GL_PIXEL_MAP_I_TO_R_SIZE\0"
	.byte 0xb2,0x19,0x17
	.ascii "GL_PIXEL_MAP_I_TO_G_SIZE\0"
	.byte 0xb3,0x19,0x17
	.ascii "GL_PIXEL_MAP_I_TO_B_SIZE\0"
	.byte 0xb4,0x19,0x17
	.ascii "GL_PIXEL_MAP_I_TO_A_SIZE\0"
	.byte 0xb5,0x19,0x17
	.ascii "GL_PIXEL_MAP_R_TO_R_SIZE\0"
	.byte 0xb6,0x19,0x17
	.ascii "GL_PIXEL_MAP_G_TO_G_SIZE\0"
	.byte 0xb7,0x19,0x17
	.ascii "GL_PIXEL_MAP_B_TO_B_SIZE\0"
	.byte 0xb8,0x19,0x17
	.ascii "GL_PIXEL_MAP_A_TO_A_SIZE\0"
	.byte 0xb9,0x19,0x17
	.ascii "GL_PIXEL_MAP_S_TO_S\0"
	.byte 0xf1,0x18,0x17
	.ascii "GL_PIXEL_MAP_I_TO_I\0"
	.byte 0xf0,0x18,0x17
	.ascii "GL_PIXEL_MAP_I_TO_R\0"
	.byte 0xf2,0x18,0x17
	.ascii "GL_PIXEL_MAP_I_TO_G\0"
	.byte 0xf3,0x18,0x17
	.ascii "GL_PIXEL_MAP_I_TO_B\0"
	.byte 0xf4,0x18,0x17
	.ascii "GL_PIXEL_MAP_I_TO_A\0"
	.byte 0xf5,0x18,0x17
	.ascii "GL_PIXEL_MAP_R_TO_R\0"
	.byte 0xf6,0x18,0x17
	.ascii "GL_PIXEL_MAP_G_TO_G\0"
	.byte 0xf7,0x18,0x17
	.ascii "GL_PIXEL_MAP_B_TO_B\0"
	.byte 0xf8,0x18,0x17
	.ascii "GL_PIXEL_MAP_A_TO_A\0"
	.byte 0xf9,0x18,0x17
	.ascii "GL_PACK_ALIGNMENT\0"
	.byte 0x85,0x1a,0x17
	.ascii "GL_PACK_LSB_FIRST\0"
	.byte 0x81,0x1a,0x17
	.ascii "GL_PACK_ROW_LENGTH\0"
	.byte 0x82,0x1a,0x17
	.ascii "GL_PACK_SKIP_PIXELS\0"
	.byte 0x84,0x1a,0x17
	.ascii "GL_PACK_SKIP_ROWS\0"
	.byte 0x83,0x1a,0x17
	.ascii "GL_PACK_SWAP_BYTES\0"
	.byte 0x80,0x1a,0x17
	.ascii "GL_UNPACK_ALIGNMENT\0"
	.byte 0xf5,0x19,0x17
	.ascii "GL_UNPACK_LSB_FIRST\0"
	.byte 0xf1,0x19,0x17
	.ascii "GL_UNPACK_ROW_LENGTH\0"
	.byte 0xf2,0x19,0x17
	.ascii "GL_UNPACK_SKIP_PIXELS\0"
	.byte 0xf4,0x19,0x17
	.ascii "GL_UNPACK_SKIP_ROWS\0"
	.byte 0xf3,0x19,0x17
	.ascii "GL_UNPACK_SWAP_BYTES\0"
	.byte 0xf0,0x19,0x17
	.ascii "GL_ZOOM_X\0"
	.byte 0x96,0x1a,0x17
	.ascii "GL_ZOOM_Y\0"
	.byte 0x97,0x1a,0x17
	.ascii "GL_TEXTURE_ENV\0"
	.byte 0x80,0xc6,0x00,0x17
	.ascii "GL_TEXTURE_ENV_MODE\0"
	.byte 0x80,0xc4,0x00,0x17
	.ascii "GL_TEXTURE_1D\0"
	.byte 0xe0,0x1b,0x17
	.ascii "GL_TEXTURE_2D\0"
	.byte 0xe1,0x1b,0x17
	.ascii "GL_TEXTURE_WRAP_S\0"
	.byte 0x82,0xd0,0x00,0x17
	.ascii "GL_TEXTURE_WRAP_T\0"
	.byte 0x83,0xd0,0x00,0x17
	.ascii "GL_TEXTURE_MAG_FILTER\0"
	.byte 0x80,0xd0,0x00,0x17
	.ascii "GL_TEXTURE_MIN_FILTER\0"
	.byte 0x81,0xd0,0x00,0x17
	.ascii "GL_TEXTURE_ENV_COLOR\0"
	.byte 0x81,0xc4,0x00,0x17
	.ascii "GL_TEXTURE_GEN_S\0"
	.byte 0xe0,0x18,0x17
	.ascii "GL_TEXTURE_GEN_T\0"
	.byte 0xe1,0x18,0x17
	.ascii "GL_TEXTURE_GEN_MODE\0"
	.byte 0x80,0xca,0x00,0x17
	.ascii "GL_TEXTURE_BORDER_COLOR\0"
	.byte 0x84,0x20,0x17
	.ascii "GL_TEXTURE_WIDTH\0"
	.byte 0x80,0x20,0x17
	.ascii "GL_TEXTURE_HEIGHT\0"
	.byte 0x81,0x20,0x17
	.ascii "GL_TEXTURE_BORDER\0"
	.byte 0x85,0x20,0x17
	.ascii "GL_TEXTURE_COMPONENTS\0"
	.byte 0x83,0x20,0x17
	.ascii "GL_TEXTURE_RED_SIZE\0"
	.byte 0xdc,0x80,0x02,0x17
	.ascii "GL_TEXTURE_GREEN_SIZE\0"
	.byte 0xdd,0x80,0x02,0x17
	.ascii "GL_TEXTURE_BLUE_SIZE\0"
	.byte 0xde,0x80,0x02,0x17
	.ascii "GL_TEXTURE_ALPHA_SIZE\0"
	.byte 0xdf,0x80,0x02,0x17
	.ascii "GL_TEXTURE_LUMINANCE_SIZE\0"
	.byte 0xe0,0x80,0x02,0x17
	.ascii "GL_TEXTURE_INTENSITY_SIZE\0"
	.byte 0xe1,0x80,0x02,0x17
	.ascii "GL_NEAREST_MIPMAP_NEAREST\0"
	.byte 0x80,0xce,0x00,0x17
	.ascii "GL_NEAREST_MIPMAP_LINEAR\0"
	.byte 0x82,0xce,0x00,0x17
	.ascii "GL_LINEAR_MIPMAP_NEAREST\0"
	.byte 0x81,0xce,0x00,0x17
	.ascii "GL_LINEAR_MIPMAP_LINEAR\0"
	.byte 0x83,0xce,0x00,0x17
	.ascii "GL_OBJECT_LINEAR\0"
	.byte 0x81,0xc8,0x00,0x17
	.ascii "GL_OBJECT_PLANE\0"
	.byte 0x81,0xca,0x00,0x17
	.ascii "GL_EYE_LINEAR\0"
	.byte 0x80,0xc8,0x00,0x17
	.ascii "GL_EYE_PLANE\0"
	.byte 0x82,0xca,0x00,0x17
	.ascii "GL_SPHERE_MAP\0"
	.byte 0x82,0xc8,0x00,0x17
	.ascii "GL_DECAL\0"
	.byte 0x81,0xc2,0x00,0x17
	.ascii "GL_MODULATE\0"
	.byte 0x80,0xc2,0x00,0x17
	.ascii "GL_NEAREST\0"
	.byte 0x80,0xcc,0x00,0x17
	.ascii "GL_REPEAT\0"
	.byte 0x81,0xd2,0x00,0x17
	.ascii "GL_CLAMP\0"
	.byte 0x80,0xd2,0x00,0x17
	.ascii "GL_S\0"
	.byte 0x80,0xc0,0x00,0x17
	.ascii "GL_T\0"
	.byte 0x81,0xc0,0x00,0x17
	.ascii "GL_R\0"
	.byte 0x82,0xc0,0x00,0x17
	.ascii "GL_Q\0"
	.byte 0x83,0xc0,0x00,0x17
	.ascii "GL_TEXTURE_GEN_R\0"
	.byte 0xe2,0x18,0x17
	.ascii "GL_TEXTURE_GEN_Q\0"
	.byte 0xe3,0x18,0x17
	.ascii "GL_PROXY_TEXTURE_1D\0"
	.byte 0xe3,0x80,0x02,0x17
	.ascii "GL_PROXY_TEXTURE_2D\0"
	.byte 0xe4,0x80,0x02,0x17
	.ascii "GL_TEXTURE_PRIORITY\0"
	.byte 0xe6,0x80,0x02,0x17
	.ascii "GL_TEXTURE_RESIDENT\0"
	.byte 0xe7,0x80,0x02,0x17
	.ascii "GL_TEXTURE_BINDING_1D\0"
	.byte 0xe8,0x80,0x02,0x17
	.ascii "GL_TEXTURE_BINDING_2D\0"
	.byte 0xe9,0x80,0x02,0x17
	.ascii "GL_ALPHA4\0"
	.byte 0xbb,0x80,0x02,0x17
	.ascii "GL_ALPHA8\0"
	.byte 0xbc,0x80,0x02,0x17
	.ascii "GL_ALPHA12\0"
	.byte 0xbd,0x80,0x02,0x17
	.ascii "GL_ALPHA16\0"
	.byte 0xbe,0x80,0x02,0x17
	.ascii "GL_LUMINANCE4\0"
	.byte 0xbf,0x80,0x02,0x17
	.ascii "GL_LUMINANCE8\0"
	.byte 0xc0,0x80,0x02,0x17
	.ascii "GL_LUMINANCE12\0"
	.byte 0xc1,0x80,0x02,0x17
	.ascii "GL_LUMINANCE16\0"
	.byte 0xc2,0x80,0x02,0x17
	.ascii "GL_LUMINANCE4_ALPHA4\0"
	.byte 0xc3,0x80,0x02,0x17
	.ascii "GL_LUMINANCE6_ALPHA2\0"
	.byte 0xc4,0x80,0x02,0x17
	.ascii "GL_LUMINANCE8_ALPHA8\0"
	.byte 0xc5,0x80,0x02,0x17
	.ascii "GL_LUMINANCE12_ALPHA4\0"
	.byte 0xc6,0x80,0x02,0x17
	.ascii "GL_LUMINANCE12_ALPHA12\0"
	.byte 0xc7,0x80,0x02,0x17
	.ascii "GL_LUMINANCE16_ALPHA16\0"
	.byte 0xc8,0x80,0x02,0x17
	.ascii "GL_INTENSITY\0"
	.byte 0xc9,0x80,0x02,0x17
	.ascii "GL_INTENSITY4\0"
	.byte 0xca,0x80,0x02,0x17
	.ascii "GL_INTENSITY8\0"
	.byte 0xcb,0x80,0x02,0x17
	.ascii "GL_INTENSITY12\0"
	.byte 0xcc,0x80,0x02,0x17
	.ascii "GL_INTENSITY16\0"
	.byte 0xcd,0x80,0x02,0x17
	.ascii "GL_R3_G3_B2\0"
	.byte 0x90,0xd4,0x00,0x17
	.ascii "GL_RGB4\0"
	.byte 0xcf,0x80,0x02,0x17
	.ascii "GL_RGB5\0"
	.byte 0xd0,0x80,0x02,0x17
	.ascii "GL_RGB8\0"
	.byte 0xd1,0x80,0x02,0x17
	.ascii "GL_RGB10\0"
	.byte 0xd2,0x80,0x02,0x17
	.ascii "GL_RGB12\0"
	.byte 0xd3,0x80,0x02,0x17
	.ascii "GL_RGB16\0"
	.byte 0xd4,0x80,0x02,0x17
	.ascii "GL_RGBA2\0"
	.byte 0xd5,0x80,0x02,0x17
	.ascii "GL_RGBA4\0"
	.byte 0xd6,0x80,0x02,0x17
	.ascii "GL_RGB5_A1\0"
	.byte 0xd7,0x80,0x02,0x17
	.ascii "GL_RGBA8\0"
	.byte 0xd8,0x80,0x02,0x17
	.ascii "GL_RGB10_A2\0"
	.byte 0xd9,0x80,0x02,0x17
	.ascii "GL_RGBA12\0"
	.byte 0xda,0x80,0x02,0x17
	.ascii "GL_RGBA16\0"
	.byte 0xdb,0x80,0x02,0x17
	.ascii "GL_VENDOR\0"
	.byte 0x80,0x3e,0x17
	.ascii "GL_RENDERER\0"
	.byte 0x81,0x3e,0x17
	.ascii "GL_VERSION\0"
	.byte 0x82,0x3e,0x17
	.ascii "GL_EXTENSIONS\0"
	.byte 0x83,0x3e,0x17
	.ascii "GL_INVALID_VALUE\0"
	.byte 0x81,0x0a,0x17
	.ascii "GL_INVALID_ENUM\0"
	.byte 0x80,0x0a,0x17
	.ascii "GL_INVALID_OPERATION\0"
	.byte 0x82,0x0a,0x17
	.ascii "GL_STACK_OVERFLOW\0"
	.byte 0x83,0x0a,0x17
	.ascii "GL_STACK_UNDERFLOW\0"
	.byte 0x84,0x0a,0x17
	.ascii "GL_OUT_OF_MEMORY\0"
	.byte 0x85,0x0a,0x17
	.ascii "GL_CONSTANT_COLOR_EXT\0"
	.byte 0x81,0x80,0x02,0x17
	.ascii "GL_ONE_MINUS_CONSTANT_COLOR_EXT\0"
	.byte 0x82,0x80,0x02,0x17
	.ascii "GL_CONSTANT_ALPHA_EXT\0"
	.byte 0x83,0x80,0x02,0x17
	.ascii "GL_ONE_MINUS_CONSTANT_ALPHA_EXT\0"
	.byte 0x84,0x80,0x02,0x17
	.ascii "GL_BLEND_EQUATION_EXT\0"
	.byte 0x89,0x80,0x02,0x17
	.ascii "GL_MIN_EXT\0"
	.byte 0x87,0x80,0x02,0x17
	.ascii "GL_MAX_EXT\0"
	.byte 0x88,0x80,0x02,0x17
	.ascii "GL_FUNC_ADD_EXT\0"
	.byte 0x86,0x80,0x02,0x17
	.ascii "GL_FUNC_SUBTRACT_EXT\0"
	.byte 0x8a,0x80,0x02,0x17
	.ascii "GL_FUNC_REVERSE_SUBTRACT_EXT\0"
	.byte 0x8b,0x80,0x02,0x17
	.ascii "GL_BLEND_COLOR_EXT\0"
	.byte 0x85,0x80,0x02,0x17
	.ascii "GL_POLYGON_OFFSET_EXT\0"
	.byte 0xb7,0x80,0x02,0x17
	.ascii "GL_POLYGON_OFFSET_FACTOR_EXT\0"
	.byte 0xb8,0x80,0x02,0x17
	.ascii "GL_POLYGON_OFFSET_BIAS_EXT\0"
	.byte 0xb9,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_EXT\0"
	.byte 0xf4,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_EXT\0"
	.byte 0xf5,0x80,0x02,0x17
	.ascii "GL_COLOR_ARRAY_EXT\0"
	.byte 0xf6,0x80,0x02,0x17
	.ascii "GL_INDEX_ARRAY_EXT\0"
	.byte 0xf7,0x80,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_EXT\0"
	.byte 0xf8,0x80,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_EXT\0"
	.byte 0xf9,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_SIZE_EXT\0"
	.byte 0xfa,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_TYPE_EXT\0"
	.byte 0xfb,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_STRIDE_EXT\0"
	.byte 0xfc,0x80,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_COUNT_EXT\0"
	.byte 0xfd,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_TYPE_EXT\0"
	.byte 0xfe,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_STRIDE_EXT\0"
	.byte 0xff,0x80,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_COUNT_EXT\0"
	.byte 0x80,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_SIZE_EXT\0"
	.byte 0x81,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_TYPE_EXT\0"
	.byte 0x82,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_STRIDE_EXT\0"
	.byte 0x83,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_COUNT_EXT\0"
	.byte 0x84,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_TYPE_EXT\0"
	.byte 0x85,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_STRIDE_EXT\0"
	.byte 0x86,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_COUNT_EXT\0"
	.byte 0x87,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_SIZE_EXT\0"
	.byte 0x88,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_TYPE_EXT\0"
	.byte 0x89,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_STRIDE_EXT\0"
	.byte 0x8a,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_COUNT_EXT\0"
	.byte 0x8b,0x81,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_STRIDE_EXT\0"
	.byte 0x8c,0x81,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_COUNT_EXT\0"
	.byte 0x8d,0x81,0x02,0x17
	.ascii "GL_VERTEX_ARRAY_POINTER_EXT\0"
	.byte 0x8e,0x81,0x02,0x17
	.ascii "GL_NORMAL_ARRAY_POINTER_EXT\0"
	.byte 0x8f,0x81,0x02,0x17
	.ascii "GL_COLOR_ARRAY_POINTER_EXT\0"
	.byte 0x90,0x81,0x02,0x17
	.ascii "GL_INDEX_ARRAY_POINTER_EXT\0"
	.byte 0x91,0x81,0x02,0x17
	.ascii "GL_TEXTURE_COORD_ARRAY_POINTER_EXT\0"
	.byte 0x92,0x81,0x02,0x17
	.ascii "GL_EDGE_FLAG_ARRAY_POINTER_EXT\0"
	.byte 0x93,0x81,0x02,0x17
	.ascii "GL_TEXTURE_PRIORITY_EXT\0"
	.byte 0xe6,0x80,0x02,0x17
	.ascii "GL_TEXTURE_RESIDENT_EXT\0"
	.byte 0xe7,0x80,0x02,0x17
	.ascii "GL_TEXTURE_1D_BINDING_EXT\0"
	.byte 0xe8,0x80,0x02,0x17
	.ascii "GL_TEXTURE_2D_BINDING_EXT\0"
	.byte 0xe9,0x80,0x02,0x17
	.ascii "GL_PACK_SKIP_IMAGES_EXT\0"
	.byte 0xeb,0x80,0x02,0x17
	.ascii "GL_PACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xec,0x80,0x02,0x17
	.ascii "GL_UNPACK_SKIP_IMAGES_EXT\0"
	.byte 0xed,0x80,0x02,0x17
	.ascii "GL_UNPACK_IMAGE_HEIGHT_EXT\0"
	.byte 0xee,0x80,0x02,0x17
	.ascii "GL_TEXTURE_3D_EXT\0"
	.byte 0xef,0x80,0x02,0x17
	.ascii "GL_PROXY_TEXTURE_3D_EXT\0"
	.byte 0xf0,0x80,0x02,0x17
	.ascii "GL_TEXTURE_DEPTH_EXT\0"
	.byte 0xf1,0x80,0x02,0x17
	.ascii "GL_TEXTURE_WRAP_R_EXT\0"
	.byte 0xf2,0x80,0x02,0x17
	.ascii "GL_MAX_3D_TEXTURE_SIZE_EXT\0"
	.byte 0xf3,0x80,0x02,0x17
	.ascii "GL_TEXTURE_3D_BINDING_EXT\0"
	.byte 0xea,0x80,0x02,0x17
	.ascii "GL_TABLE_TOO_LARGE_EXT\0"
	.byte 0xb1,0x80,0x02,0x17
	.ascii "GL_COLOR_TABLE_FORMAT_EXT\0"
	.byte 0xd8,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_WIDTH_EXT\0"
	.byte 0xd9,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_RED_SIZE_EXT\0"
	.byte 0xda,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_GREEN_SIZE_EXT\0"
	.byte 0xdb,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_BLUE_SIZE_EXT\0"
	.byte 0xdc,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_ALPHA_SIZE_EXT\0"
	.byte 0xdd,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_LUMINANCE_SIZE_EXT\0"
	.byte 0xde,0x81,0x02,0x17
	.ascii "GL_COLOR_TABLE_INTENSITY_SIZE_EXT\0"
	.byte 0xdf,0x81,0x02,0x17
	.ascii "GL_TEXTURE_INDEX_SIZE_EXT\0"
	.byte 0xe1,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX1_EXT\0"
	.byte 0xe2,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX2_EXT\0"
	.byte 0xe3,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX4_EXT\0"
	.byte 0xe4,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX8_EXT\0"
	.byte 0xe5,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX12_EXT\0"
	.byte 0xe6,0x81,0x02,0x17
	.ascii "GL_COLOR_INDEX16_EXT\0"
	.byte 0xe7,0x81,0x02,0x17
	.ascii "GL_SHARED_TEXTURE_PALETTE_EXT\0"
	.byte 0xfb,0x83,0x02,0x17
	.ascii "GL_POINT_SIZE_MIN_EXT\0"
	.byte 0xa6,0x82,0x02,0x17
	.ascii "GL_POINT_SIZE_MAX_EXT\0"
	.byte 0xa7,0x82,0x02,0x17
	.ascii "GL_POINT_FADE_THRESHOLD_SIZE_EXT\0"
	.byte 0xa8,0x82,0x02,0x17
	.ascii "GL_DISTANCE_ATTENUATION_EXT\0"
	.byte 0xa9,0x82,0x02,0x00,0x04,0x00,0x00,0x02
	.byte 0x99
	.ascii "GLboolean\0"
	.byte 0x02,0x18
	.ascii "OSMesaMakeCurrent\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x3a,0x05,0x01
	.byte 0x00,0x00,0x3a,0x4e,0x19,0x00,0x00,0x0a
	.byte 0x5f,0x19,0x00,0x00,0x0a,0x64,0x19,0x00
	.byte 0x00,0x0a,0x69,0x19,0x00,0x00,0x02,0x92
	.byte 0x19,0x00,0x00,0x02,0x92,0x00,0x1a
	.ascii "OSMesaDestroyContext\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3a,0x72
	.byte 0x19,0x00,0x00,0x09,0xdf,0x00,0x18
	.ascii "OSMesaCreateContext\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x09,0xe4,0x01
	.byte 0x00,0x00,0x3a,0x9e,0x19,0x00,0x00,0x0a
	.byte 0x69,0x19,0x00,0x00,0x09,0xe4,0x00,0x08
	.byte 0x00,0x00,0x05,0x1a,0x09,0x00,0x00,0x3a
	.byte 0x9e,0x1a
	.ascii "glTexImage1D\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3a,0xe7
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x02,0x92,0x19,0x00,0x00,0x02,0x92,0x19
	.byte 0x00,0x00,0x02,0x92,0x19,0x00,0x00,0x02
	.byte 0x92,0x19,0x00,0x00,0x0a,0x69,0x19,0x00
	.byte 0x00,0x0a,0x69,0x19,0x00,0x00,0x3a,0xa3
	.byte 0x00,0x1a
	.ascii "glTexParameteri\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0x10
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x02,0x92,0x00
	.byte 0x08,0x00,0x00,0x01,0x01,0x09,0x00,0x00
	.byte 0x3b,0x10,0x1a
	.ascii "glTexGenfv\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0x3e
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x3b,0x15,0x00
	.byte 0x1a
	.ascii "glTexGeni\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0x61
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x02,0x92,0x00
	.byte 0x08,0x00,0x00,0x01,0x01,0x09,0x00,0x00
	.byte 0x3b,0x61,0x1a
	.ascii "glMaterialfv\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0x91
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x3b,0x66,0x00
	.byte 0x1a
	.ascii "glMaterialf\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0xb6
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x01,0x01,0x00
	.byte 0x08,0x00,0x00,0x01,0x01,0x09,0x00,0x00
	.byte 0x3b,0xb6,0x1a
	.ascii "glLightfv\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3b,0xe3
	.byte 0x19,0x00,0x00,0x0a,0x69,0x19,0x00,0x00
	.byte 0x0a,0x69,0x19,0x00,0x00,0x3b,0xbb,0x00
	.byte 0x08,0x00,0x00,0x01,0x01,0x09,0x00,0x00
	.byte 0x3b,0xe3,0x1a
	.ascii "glNormal3fv\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0x08
	.byte 0x19,0x00,0x00,0x3b,0xe8,0x00,0x08,0x00
	.byte 0x00,0x01,0x01,0x09,0x00,0x00,0x3c,0x08
	.byte 0x1a
	.ascii "glVertex3fv\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0x2d
	.byte 0x19,0x00,0x00,0x3c,0x0d,0x00,0x1b
	.ascii "glEnd\0"
	.byte 0x01,0x01,0x01,0x01,0x1a
	.ascii "glBegin\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0x4f
	.byte 0x19,0x00,0x00,0x0a,0x69,0x00,0x1a
	.ascii "glTranslatef\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0x75
	.byte 0x19,0x00,0x00,0x01,0x01,0x19,0x00,0x00
	.byte 0x01,0x01,0x19,0x00,0x00,0x01,0x01,0x00
	.byte 0x1a
	.ascii "glRotatef\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0x9d
	.byte 0x19,0x00,0x00,0x01,0x01,0x19,0x00,0x00
	.byte 0x01,0x01,0x19,0x00,0x00,0x01,0x01,0x19
	.byte 0x00,0x00,0x01,0x01,0x00,0x1b
	.ascii "glLoadIdentity\0"
	.byte 0x01,0x01,0x01,0x01,0x1b
	.ascii "glPopMatrix\0"
	.byte 0x01,0x01,0x01,0x01,0x1b
	.ascii "glPushMatrix\0"
	.byte 0x01,0x01,0x01,0x01,0x1a
	.ascii "glViewport\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3c,0xfd
	.byte 0x19,0x00,0x00,0x02,0x92,0x19,0x00,0x00
	.byte 0x02,0x92,0x19,0x00,0x00,0x02,0x92,0x19
	.byte 0x00,0x00,0x02,0x92,0x00,0x02
	.ascii "double\0"
	.byte 0x04,0x08,0x1a
	.ascii "glFrustum\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0x39
	.byte 0x19,0x00,0x00,0x3c,0xfd,0x19,0x00,0x00
	.byte 0x3c,0xfd,0x19,0x00,0x00,0x3c,0xfd,0x19
	.byte 0x00,0x00,0x3c,0xfd,0x19,0x00,0x00,0x3c
	.byte 0xfd,0x19,0x00,0x00,0x3c,0xfd,0x00,0x1a
	.ascii "glMatrixMode\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0x55
	.byte 0x19,0x00,0x00,0x0a,0x69,0x00,0x1a
	.ascii "glEnable\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0x6d
	.byte 0x19,0x00,0x00,0x0a,0x69,0x00,0x1a
	.ascii "glClear\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0x84
	.byte 0x19,0x00,0x00,0x02,0xaf,0x00,0x08,0x00
	.byte 0x00,0x02,0x80,0x09,0x00,0x00,0x3d,0x84
	.byte 0x08,0x00,0x00,0x02,0x80,0x09,0x00,0x00
	.byte 0x3d,0x8e,0x18
	.ascii "strcmp\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x3d,0xb7,0x19,0x00,0x00,0x3d
	.byte 0x89,0x19,0x00,0x00,0x3d,0x93,0x00,0x18
	.ascii "malloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x09,0xf8,0x01
	.byte 0x00,0x00,0x3d,0xd1,0x19,0x00,0x00,0x02
	.byte 0xaf,0x00,0x1a
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0xe5
	.byte 0x19,0x00,0x00,0x09,0xf8,0x00,0x1a
	.ascii "exit\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x3d,0xf9
	.byte 0x19,0x00,0x00,0x02,0x92,0x00,0x08,0x00
	.byte 0x00,0x02,0x80,0x09,0x00,0x00,0x3d,0xf9
	.byte 0x18
	.ascii "atoi\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x3e,0x1b,0x19,0x00,0x00,0x3d
	.byte 0xfe,0x00,0x08,0x00,0x00,0x02,0x80,0x09
	.byte 0x00,0x00,0x3e,0x1b,0x18
	.ascii "printf\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x3e,0x40,0x19,0x00,0x00,0x3e
	.byte 0x20,0x1c,0x00,0x09,0x00,0x00,0x02,0xbb
	.byte 0x08,0x00,0x00,0x02,0x80,0x09,0x00,0x00
	.byte 0x3e,0x45,0x18
	.ascii "fscanf\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x3e,0x6f,0x19,0x00,0x00,0x3e
	.byte 0x40,0x19,0x00,0x00,0x3e,0x4a,0x1c,0x00
	.byte 0x08,0x00,0x00,0x02,0x80,0x09,0x00,0x00
	.byte 0x3e,0x6f,0x18
	.ascii "fprintf\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x00,0x00,0x3e,0x9a,0x19,0x00,0x00,0x3e
	.byte 0x40,0x19,0x00,0x00,0x3e,0x74,0x1c,0x00
	.byte 0x08,0x00,0x00,0x02,0x80,0x09,0x00,0x00
	.byte 0x3e,0x9a,0x08,0x00,0x00,0x02,0x80,0x09
	.byte 0x00,0x00,0x3e,0xa4,0x18
	.ascii "fopen\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x03,0xa2,0x01
	.byte 0x00,0x00,0x3e,0xcc,0x19,0x00,0x00,0x3e
	.byte 0x9f,0x19,0x00,0x00,0x3e,0xa9,0x00,0x1d
	.ascii "fclose\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x02,0x92,0x01
	.byte 0x19,0x00,0x00,0x3e,0x40,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=179, siz=4, lab1=ReadMesh, lab2=, loff=0
!   reloc[1]: knd=0, off=186, siz=4, lab1=.L16, lab2=, loff=0
!   reloc[2]: knd=0, off=198, siz=4, lab1=.L20, lab2=, loff=0
!   reloc[3]: knd=0, off=206, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[4]: knd=0, off=214, siz=4, lab1=.L26, lab2=, loff=0
!   reloc[5]: knd=0, off=222, siz=4, lab1=.L30, lab2=, loff=0
!   reloc[6]: knd=0, off=232, siz=4, lab1=.L34, lab2=, loff=0
!   reloc[7]: knd=0, off=240, siz=4, lab1=.L38, lab2=, loff=0
!   reloc[8]: knd=0, off=248, siz=4, lab1=.L40, lab2=, loff=0
!   reloc[9]: knd=0, off=256, siz=4, lab1=.L46, lab2=, loff=0
!   reloc[10]: knd=0, off=264, siz=4, lab1=.L50, lab2=, loff=0
!   reloc[11]: knd=0, off=272, siz=4, lab1=.L52, lab2=, loff=0
!   reloc[12]: knd=0, off=280, siz=4, lab1=.L56, lab2=, loff=0
!   reloc[13]: knd=0, off=290, siz=4, lab1=.L57, lab2=, loff=0
!   reloc[14]: knd=0, off=298, siz=4, lab1=.L60, lab2=, loff=0
!   reloc[15]: knd=0, off=306, siz=4, lab1=.L66, lab2=, loff=0
!   reloc[16]: knd=0, off=314, siz=4, lab1=.L68, lab2=, loff=0
!   reloc[17]: knd=0, off=322, siz=4, lab1=.L73, lab2=, loff=0
!   reloc[18]: knd=0, off=332, siz=4, lab1=.L81, lab2=, loff=0
!   reloc[19]: knd=0, off=340, siz=4, lab1=.L88, lab2=, loff=0
!   reloc[20]: knd=0, off=348, siz=4, lab1=.L89, lab2=, loff=0
!   reloc[21]: knd=0, off=356, siz=4, lab1=.L91, lab2=, loff=0
!   reloc[22]: knd=0, off=364, siz=4, lab1=.L92, lab2=, loff=0
!   reloc[23]: knd=0, off=372, siz=4, lab1=.L93, lab2=, loff=0
!   reloc[24]: knd=0, off=380, siz=4, lab1=.L94, lab2=, loff=0
!   reloc[25]: knd=0, off=388, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[26]: knd=0, off=396, siz=4, lab1=.L96, lab2=, loff=0
!   reloc[27]: knd=0, off=404, siz=4, lab1=.L99, lab2=, loff=0
!   reloc[28]: knd=0, off=414, siz=4, lab1=.L104, lab2=, loff=0
!   reloc[29]: knd=0, off=422, siz=4, lab1=.L107, lab2=, loff=0
!   reloc[30]: knd=0, off=432, siz=4, lab1=.L108, lab2=, loff=0
!   reloc[31]: knd=0, off=445, siz=4, lab1=DrawMesh, lab2=, loff=0
!   reloc[32]: knd=0, off=452, siz=4, lab1=.L116, lab2=, loff=0
!   reloc[33]: knd=0, off=464, siz=4, lab1=.L123, lab2=, loff=0
!   reloc[34]: knd=0, off=472, siz=4, lab1=.L125, lab2=, loff=0
!   reloc[35]: knd=0, off=480, siz=4, lab1=.L132, lab2=, loff=0
!   reloc[36]: knd=0, off=488, siz=4, lab1=.L133, lab2=, loff=0
!   reloc[37]: knd=0, off=496, siz=4, lab1=.L134, lab2=, loff=0
!   reloc[38]: knd=0, off=504, siz=4, lab1=.L135, lab2=, loff=0
!   reloc[39]: knd=0, off=512, siz=4, lab1=.L136, lab2=, loff=0
!   reloc[40]: knd=0, off=520, siz=4, lab1=.L137, lab2=, loff=0
!   reloc[41]: knd=0, off=528, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[42]: knd=0, off=538, siz=4, lab1=.L143, lab2=, loff=0
!   reloc[43]: knd=0, off=548, siz=4, lab1=.L146, lab2=, loff=0
!   reloc[44]: knd=0, off=558, siz=4, lab1=.L149, lab2=, loff=0
!   reloc[45]: knd=0, off=573, siz=4, lab1=SPECWriteIntermediateImage, lab2=, loff=0
!   reloc[46]: knd=0, off=580, siz=4, lab1=.L156, lab2=, loff=0
!   reloc[47]: knd=0, off=592, siz=4, lab1=.L157, lab2=, loff=0
!   reloc[48]: knd=0, off=600, siz=4, lab1=.L160, lab2=, loff=0
!   reloc[49]: knd=0, off=610, siz=4, lab1=.L164, lab2=, loff=0
!   reloc[50]: knd=0, off=618, siz=4, lab1=.L166, lab2=, loff=0
!   reloc[51]: knd=0, off=626, siz=4, lab1=.L167, lab2=, loff=0
!   reloc[52]: knd=0, off=634, siz=4, lab1=.L168, lab2=, loff=0
!   reloc[53]: knd=0, off=642, siz=4, lab1=.L174, lab2=, loff=0
!   reloc[54]: knd=0, off=650, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[55]: knd=0, off=658, siz=4, lab1=.L183, lab2=, loff=0
!   reloc[56]: knd=0, off=671, siz=4, lab1=Render, lab2=, loff=0
!   reloc[57]: knd=0, off=678, siz=4, lab1=.L190, lab2=, loff=0
!   reloc[58]: knd=0, off=690, siz=4, lab1=.L193, lab2=, loff=0
!   reloc[59]: knd=0, off=698, siz=4, lab1=.L196, lab2=, loff=0
!   reloc[60]: knd=0, off=708, siz=4, lab1=.L198, lab2=, loff=0
!   reloc[61]: knd=0, off=716, siz=4, lab1=.L207, lab2=, loff=0
!   reloc[62]: knd=0, off=726, siz=4, lab1=.L215, lab2=, loff=0
!   reloc[63]: knd=0, off=734, siz=4, lab1=.L219, lab2=, loff=0
!   reloc[64]: knd=0, off=742, siz=4, lab1=.L222, lab2=, loff=0
!   reloc[65]: knd=0, off=750, siz=4, lab1=.L231, lab2=, loff=0
!   reloc[66]: knd=0, off=760, siz=4, lab1=.L239, lab2=, loff=0
!   reloc[67]: knd=0, off=768, siz=4, lab1=.L243, lab2=, loff=0
!   reloc[68]: knd=0, off=776, siz=4, lab1=.L246, lab2=, loff=0
!   reloc[69]: knd=0, off=784, siz=4, lab1=.L254, lab2=, loff=0
!   reloc[70]: knd=0, off=794, siz=4, lab1=.L255, lab2=, loff=0
!   reloc[71]: knd=0, off=802, siz=4, lab1=.L256, lab2=, loff=0
!   reloc[72]: knd=0, off=810, siz=4, lab1=.L257, lab2=, loff=0
!   reloc[73]: knd=0, off=818, siz=4, lab1=.L258, lab2=, loff=0
!   reloc[74]: knd=0, off=826, siz=4, lab1=.L259, lab2=, loff=0
!   reloc[75]: knd=0, off=834, siz=4, lab1=.L260, lab2=, loff=0
!   reloc[76]: knd=0, off=842, siz=4, lab1=.L261, lab2=, loff=0
!   reloc[77]: knd=0, off=850, siz=4, lab1=.L262, lab2=, loff=0
!   reloc[78]: knd=0, off=860, siz=4, lab1=.L265, lab2=, loff=0
!   reloc[79]: knd=0, off=870, siz=4, lab1=.L268, lab2=, loff=0
!   reloc[80]: knd=0, off=885, siz=4, lab1=Reshape, lab2=, loff=0
!   reloc[81]: knd=0, off=892, siz=4, lab1=.L275, lab2=, loff=0
!   reloc[82]: knd=0, off=904, siz=4, lab1=.L276, lab2=, loff=0
!   reloc[83]: knd=0, off=912, siz=4, lab1=.L277, lab2=, loff=0
!   reloc[84]: knd=0, off=920, siz=4, lab1=.L278, lab2=, loff=0
!   reloc[85]: knd=0, off=928, siz=4, lab1=.L279, lab2=, loff=0
!   reloc[86]: knd=0, off=936, siz=4, lab1=.L280, lab2=, loff=0
!   reloc[87]: knd=0, off=944, siz=4, lab1=.L281, lab2=, loff=0
!   reloc[88]: knd=0, off=952, siz=4, lab1=.L282, lab2=, loff=0
!   reloc[89]: knd=0, off=960, siz=4, lab1=.L283, lab2=, loff=0
!   reloc[90]: knd=0, off=973, siz=4, lab1=Init, lab2=, loff=0
!   reloc[91]: knd=0, off=980, siz=4, lab1=.L299, lab2=, loff=0
!   reloc[92]: knd=0, off=992, siz=4, lab1=.L300, lab2=, loff=0
!   reloc[93]: knd=0, off=1000, siz=4, lab1=.L301, lab2=, loff=0
!   reloc[94]: knd=0, off=1008, siz=4, lab1=.L302, lab2=, loff=0
!   reloc[95]: knd=0, off=1016, siz=4, lab1=.L303, lab2=, loff=0
!   reloc[96]: knd=0, off=1024, siz=4, lab1=.L304, lab2=, loff=0
!   reloc[97]: knd=0, off=1032, siz=4, lab1=.L305, lab2=, loff=0
!   reloc[98]: knd=0, off=1040, siz=4, lab1=.L306, lab2=, loff=0
!   reloc[99]: knd=0, off=1050, siz=4, lab1=.L307, lab2=, loff=0
!   reloc[100]: knd=0, off=1058, siz=4, lab1=.L308, lab2=, loff=0
!   reloc[101]: knd=0, off=1066, siz=4, lab1=.L309, lab2=, loff=0
!   reloc[102]: knd=0, off=1074, siz=4, lab1=.L310, lab2=, loff=0
!   reloc[103]: knd=0, off=1082, siz=4, lab1=.L311, lab2=, loff=0
!   reloc[104]: knd=0, off=1090, siz=4, lab1=.L312, lab2=, loff=0
!   reloc[105]: knd=0, off=1098, siz=4, lab1=.L313, lab2=, loff=0
!   reloc[106]: knd=0, off=1106, siz=4, lab1=.L314, lab2=, loff=0
!   reloc[107]: knd=0, off=1114, siz=4, lab1=.L315, lab2=, loff=0
!   reloc[108]: knd=0, off=1122, siz=4, lab1=.L317, lab2=, loff=0
!   reloc[109]: knd=0, off=1132, siz=4, lab1=.L326, lab2=, loff=0
!   reloc[110]: knd=0, off=1140, siz=4, lab1=.L330, lab2=, loff=0
!   reloc[111]: knd=0, off=1148, siz=4, lab1=.L336, lab2=, loff=0
!   reloc[112]: knd=0, off=1158, siz=4, lab1=.L342, lab2=, loff=0
!   reloc[113]: knd=0, off=1168, siz=4, lab1=.L345, lab2=, loff=0
!   reloc[114]: knd=0, off=1178, siz=4, lab1=.L346, lab2=, loff=0
!   reloc[115]: knd=0, off=1186, siz=4, lab1=.L347, lab2=, loff=0
!   reloc[116]: knd=0, off=1194, siz=4, lab1=.L348, lab2=, loff=0
!   reloc[117]: knd=0, off=1202, siz=4, lab1=.L349, lab2=, loff=0
!   reloc[118]: knd=0, off=1210, siz=4, lab1=.L350, lab2=, loff=0
!   reloc[119]: knd=0, off=1218, siz=4, lab1=.L351, lab2=, loff=0
!   reloc[120]: knd=0, off=1226, siz=4, lab1=.L352, lab2=, loff=0
!   reloc[121]: knd=0, off=1234, siz=4, lab1=.L353, lab2=, loff=0
!   reloc[122]: knd=0, off=1247, siz=4, lab1=WriteImage, lab2=, loff=0
!   reloc[123]: knd=0, off=1254, siz=4, lab1=.L360, lab2=, loff=0
!   reloc[124]: knd=0, off=1266, siz=4, lab1=.L364, lab2=, loff=0
!   reloc[125]: knd=0, off=1274, siz=4, lab1=.L368, lab2=, loff=0
!   reloc[126]: knd=0, off=1282, siz=4, lab1=.L369, lab2=, loff=0
!   reloc[127]: knd=0, off=1290, siz=4, lab1=.L370, lab2=, loff=0
!   reloc[128]: knd=0, off=1298, siz=4, lab1=.L372, lab2=, loff=0
!   reloc[129]: knd=0, off=1306, siz=4, lab1=.L375, lab2=, loff=0
!   reloc[130]: knd=0, off=1314, siz=4, lab1=.L377, lab2=, loff=0
!   reloc[131]: knd=0, off=1322, siz=4, lab1=.L380, lab2=, loff=0
!   reloc[132]: knd=0, off=1330, siz=4, lab1=.L388, lab2=, loff=0
!   reloc[133]: knd=0, off=1338, siz=4, lab1=.L395, lab2=, loff=0
!   reloc[134]: knd=0, off=1346, siz=4, lab1=.L396, lab2=, loff=0
!   reloc[135]: knd=0, off=1354, siz=4, lab1=.L398, lab2=, loff=0
!   reloc[136]: knd=0, off=1362, siz=4, lab1=.L401, lab2=, loff=0
!   reloc[137]: knd=0, off=1370, siz=4, lab1=.L404, lab2=, loff=0
!   reloc[138]: knd=0, off=1378, siz=4, lab1=.L410, lab2=, loff=0
!   reloc[139]: knd=0, off=1388, siz=4, lab1=.L415, lab2=, loff=0
!   reloc[140]: knd=0, off=1396, siz=4, lab1=.L418, lab2=, loff=0
!   reloc[141]: knd=0, off=1406, siz=4, lab1=.L422, lab2=, loff=0
!   reloc[142]: knd=0, off=1419, siz=4, lab1=main, lab2=, loff=0
!   reloc[143]: knd=0, off=1426, siz=4, lab1=.L429, lab2=, loff=0
!   reloc[144]: knd=0, off=1438, siz=4, lab1=.L430, lab2=, loff=0
!   reloc[145]: knd=0, off=1446, siz=4, lab1=.L432, lab2=, loff=0
!   reloc[146]: knd=0, off=1454, siz=4, lab1=.L434, lab2=, loff=0
!   reloc[147]: knd=0, off=1462, siz=4, lab1=.L437, lab2=, loff=0
!   reloc[148]: knd=0, off=1472, siz=4, lab1=.L446, lab2=, loff=0
!   reloc[149]: knd=0, off=1480, siz=4, lab1=.L453, lab2=, loff=0
!   reloc[150]: knd=0, off=1488, siz=4, lab1=.L457, lab2=, loff=0
!   reloc[151]: knd=0, off=1496, siz=4, lab1=.L459, lab2=, loff=0
!   reloc[152]: knd=0, off=1504, siz=4, lab1=.L463, lab2=, loff=0
!   reloc[153]: knd=0, off=1512, siz=4, lab1=.L464, lab2=, loff=0
!   reloc[154]: knd=0, off=1520, siz=4, lab1=.L467, lab2=, loff=0
!   reloc[155]: knd=0, off=1528, siz=4, lab1=.L471, lab2=, loff=0
!   reloc[156]: knd=0, off=1536, siz=4, lab1=.L473, lab2=, loff=0
!   reloc[157]: knd=0, off=1544, siz=4, lab1=.L483, lab2=, loff=0
!   reloc[158]: knd=0, off=1554, siz=4, lab1=.L490, lab2=, loff=0
!   reloc[159]: knd=0, off=1562, siz=4, lab1=.L494, lab2=, loff=0
!   reloc[160]: knd=0, off=1570, siz=4, lab1=.L496, lab2=, loff=0
!   reloc[161]: knd=0, off=1578, siz=4, lab1=.L500, lab2=, loff=0
!   reloc[162]: knd=0, off=1586, siz=4, lab1=.L501, lab2=, loff=0
!   reloc[163]: knd=0, off=1594, siz=4, lab1=.L508, lab2=, loff=0
!   reloc[164]: knd=0, off=1602, siz=4, lab1=.L515, lab2=, loff=0
!   reloc[165]: knd=0, off=1610, siz=4, lab1=.L519, lab2=, loff=0
!   reloc[166]: knd=0, off=1618, siz=4, lab1=.L521, lab2=, loff=0
!   reloc[167]: knd=0, off=1626, siz=4, lab1=.L525, lab2=, loff=0
!   reloc[168]: knd=0, off=1634, siz=4, lab1=.L526, lab2=, loff=0
!   reloc[169]: knd=0, off=1642, siz=4, lab1=.L532, lab2=, loff=0
!   reloc[170]: knd=0, off=1652, siz=4, lab1=.L534, lab2=, loff=0
!   reloc[171]: knd=0, off=1660, siz=4, lab1=.L544, lab2=, loff=0
!   reloc[172]: knd=0, off=1670, siz=4, lab1=.L547, lab2=, loff=0
!   reloc[173]: knd=0, off=1680, siz=4, lab1=.L548, lab2=, loff=0
!   reloc[174]: knd=0, off=1690, siz=4, lab1=.L549, lab2=, loff=0
!   reloc[175]: knd=0, off=1700, siz=4, lab1=.L550, lab2=, loff=0
!   reloc[176]: knd=0, off=1710, siz=4, lab1=.L551, lab2=, loff=0
!   reloc[177]: knd=0, off=1720, siz=4, lab1=.L552, lab2=, loff=0
!   reloc[178]: knd=0, off=1728, siz=4, lab1=.L553, lab2=, loff=0
!   reloc[179]: knd=0, off=1738, siz=4, lab1=.L554, lab2=, loff=0
!   reloc[180]: knd=0, off=1748, siz=4, lab1=.L555, lab2=, loff=0
!   reloc[181]: knd=0, off=1758, siz=4, lab1=.L556, lab2=, loff=0
!   reloc[182]: knd=0, off=1766, siz=4, lab1=.L557, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x06,0xec,0x00,0x02,0x00,0x00
	.byte 0x00,0xa6,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x2f,0x75,0x73,0x72,0x2f,0x69
	.byte 0x6e,0x63,0x6c,0x75,0x64,0x65,0x00,0x2f
	.byte 0x75,0x73,0x72,0x2f,0x69,0x6e,0x63,0x6c
	.byte 0x75,0x64,0x65,0x2f,0x69,0x73,0x6f,0x00
	.byte 0x00,0x6d,0x65,0x73,0x61,0x34,0x2e,0x63
	.byte 0x00,0x01,0x00,0x00,0x67,0x6c,0x2e,0x68
	.byte 0x00,0x02,0x00,0x00,0x73,0x74,0x64,0x69
	.byte 0x6f,0x5f,0x69,0x6d,0x70,0x6c,0x2e,0x68
	.byte 0x00,0x03,0x00,0x00,0x73,0x74,0x64,0x69
	.byte 0x6f,0x5f,0x69,0x73,0x6f,0x2e,0x68,0x00
	.byte 0x04,0x00,0x00,0x6f,0x73,0x6d,0x65,0x73
	.byte 0x61,0x2e,0x68,0x00,0x02,0x00,0x00,0x00
	.byte 0x00,0x05,0x02
	.uaword ReadMesh
	.byte 0x00,0x05,0x02
	.uaword .L16
	.byte 0x06,0x03,0xf8,0x00,0x01,0x00,0x05,0x02
	.uaword .L20
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L24
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L26
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L30
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L34
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L38
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L40
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L46
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L50
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L52
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L56
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L57
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L60
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L66
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L68
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L73
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L81
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L88
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L89
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L91
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L92
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L93
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L94
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L95
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L96
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L99
	.byte 0x03,0x77,0x01,0x00,0x05,0x02
	.uaword .L104
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L107
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L108
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword DrawMesh
	.byte 0x00,0x05,0x02
	.uaword .L116
	.byte 0x06,0x03,0xac,0x01,0x01,0x00,0x05,0x02
	.uaword .L123
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L125
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L132
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L133
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L134
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L135
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L137
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L140
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L143
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L146
	.byte 0x03,0x76,0x01,0x00,0x05,0x02
	.uaword .L149
	.byte 0x03,0x0c,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword SPECWriteIntermediateImage
	.byte 0x00,0x05,0x02
	.uaword .L156
	.byte 0x06,0x03,0xc0,0x01,0x01,0x00,0x05,0x02
	.uaword .L157
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L160
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L164
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L166
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L174
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L178
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L183
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword Render
	.byte 0x00,0x05,0x02
	.uaword .L190
	.byte 0x06,0x03,0xd9,0x01,0x01,0x00,0x05,0x02
	.uaword .L193
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L196
	.byte 0x03,0x11,0x01,0x00,0x05,0x02
	.uaword .L198
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L207
	.byte 0x03,0x0d,0x01,0x00,0x05,0x02
	.uaword .L215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L219
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L222
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L231
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L239
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L243
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L246
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L254
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L255
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L256
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L257
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L258
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L259
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L260
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L261
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L262
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L265
	.byte 0x03,0x5c,0x01,0x00,0x05,0x02
	.uaword .L268
	.byte 0x03,0x26,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword Reshape
	.byte 0x00,0x05,0x02
	.uaword .L275
	.byte 0x06,0x03,0x9b,0x02,0x01,0x00,0x05,0x02
	.uaword .L276
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L277
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L278
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L279
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L280
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L281
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L282
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L283
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword Init
	.byte 0x00,0x05,0x02
	.uaword .L299
	.byte 0x06,0x03,0xda,0x02,0x01,0x00,0x05,0x02
	.uaword .L300
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L301
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L302
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L303
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L305
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L306
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L307
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L308
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L309
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L310
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L311
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L312
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L313
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L314
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L315
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L317
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L326
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L330
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L336
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L342
	.byte 0x03,0x7b,0x01,0x00,0x05,0x02
	.uaword .L345
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L346
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L347
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L349
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L350
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L351
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L352
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L353
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword WriteImage
	.byte 0x00,0x05,0x02
	.uaword .L360
	.byte 0x06,0x03,0x92,0x03,0x01,0x00,0x05,0x02
	.uaword .L364
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L368
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L369
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L370
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L372
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L375
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L377
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L380
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L388
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L395
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L396
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L398
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L401
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L404
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L410
	.byte 0x03,0x7b,0x01,0x00,0x05,0x02
	.uaword .L415
	.byte 0x0a,0x00,0x05,0x02
	.uaword .L418
	.byte 0x03,0x09,0x01,0x00,0x05,0x02
	.uaword .L422
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword main
	.byte 0x00,0x05,0x02
	.uaword .L429
	.byte 0x06,0x03,0xad,0x03,0x01,0x00,0x05,0x02
	.uaword .L430
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L432
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L434
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L437
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L446
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L453
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L457
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L459
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L463
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L464
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L467
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L471
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L473
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L483
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L490
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L494
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L496
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L500
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L501
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L508
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L515
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L519
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L521
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L525
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L526
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L532
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L534
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L544
	.byte 0x03,0x61,0x01,0x00,0x05,0x02
	.uaword .L547
	.byte 0x03,0x24,0x01,0x00,0x05,0x02
	.uaword .L548
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L549
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L550
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L551
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L552
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L553
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L554
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L555
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L556
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L557
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01
!  End sdCreateSection
!  Begin sdCreateSection : .debug_abbrev
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_abbrev"
	.byte 0x01,0x11,0x01,0x03,0x08,0x13,0x0b,0x1b
	.byte 0x08,0x85,0x44,0x08,0x87,0x44,0x08,0x25
	.byte 0x08,0x10,0x06,0x00,0x00,0x02,0x24,0x00
	.byte 0x03,0x08,0x3e,0x0b,0x0b,0x0b,0x00,0x00
	.byte 0x03,0x34,0x00,0x03,0x08,0x49,0x13,0x17
	.byte 0x0b,0x3a,0x0b,0x3b,0x0b,0x02,0x0a,0x00
	.byte 0x00,0x04,0x16,0x00,0x49,0x13,0x03,0x08
	.byte 0x3a,0x0b,0x00,0x00,0x05,0x2e,0x01,0x03
	.byte 0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x0b,0x11
	.byte 0x01,0x12,0x01,0x40,0x0a,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x06,0x05
	.byte 0x00,0x49,0x13,0x03,0x08,0x3a,0x0b,0x3b
	.byte 0x0b,0x02,0x0a,0x00,0x00,0x07,0x0b,0x01
	.byte 0x11,0x01,0x12,0x01,0x00,0x00,0x08,0x26
	.byte 0x00,0x49,0x13,0x00,0x00,0x09,0x0f,0x00
	.byte 0x49,0x13,0x00,0x00,0x0a,0x13,0x01,0x03
	.byte 0x08,0x0b,0x0b,0x3a,0x0b,0x01,0x13,0x00
	.byte 0x00,0x0b,0x0d,0x00,0x03,0x08,0x49,0x13
	.byte 0x38,0x0a,0x00,0x00,0x0c,0x0d,0x00,0x03
	.byte 0x08,0x49,0x13,0x38,0x0a,0x0b,0x0b,0x0c
	.byte 0x0b,0x0d,0x0b,0x00,0x00,0x0d,0x2e,0x01
	.byte 0x03,0x08,0x17,0x0b,0x3a,0x0b,0x3b,0x05
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x0e
	.byte 0x05,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x3b,0x05,0x02,0x0a,0x00,0x00,0x0f,0x34
	.byte 0x00,0x03,0x08,0x49,0x13,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x05,0x02,0x0a,0x00,0x00,0x10
	.byte 0x01,0x01,0x49,0x13,0x0b,0x05,0x01,0x13
	.byte 0x00,0x00,0x11,0x21,0x00,0x49,0x13,0x2f
	.byte 0x05,0x00,0x00,0x12,0x01,0x01,0x49,0x13
	.byte 0x0b,0x0b,0x01,0x13,0x00,0x00,0x13,0x21
	.byte 0x00,0x49,0x13,0x2f,0x0b,0x00,0x00,0x14
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x17,0x0b
	.byte 0x36,0x0b,0x3a,0x0b,0x3b,0x05,0x11,0x01
	.byte 0x12,0x01,0x40,0x0a,0x27,0x0c,0x49,0x13
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x15
	.byte 0x13,0x00,0x03,0x08,0x3c,0x0c,0x00,0x00
	.byte 0x16,0x04,0x01,0x0b,0x0b,0x3a,0x0b,0x01
	.byte 0x13,0x00,0x00,0x17,0x28,0x00,0x03,0x08
	.byte 0x1c,0x0d,0x00,0x00,0x18,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x49
	.byte 0x13,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x19,0x05,0x00,0x49,0x13,0x00,0x00,0x1a
	.byte 0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c
	.byte 0x27,0x0c,0x88,0x44,0x0b,0x01,0x13,0x00
	.byte 0x00,0x1b,0x2e,0x00,0x03,0x08,0x3f,0x0c
	.byte 0x3c,0x0c,0x27,0x0c,0x88,0x44,0x0b,0x00
	.byte 0x00,0x1c,0x18,0x00,0x00,0x00,0x1d,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x18,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x3e,0xe4,0x00,0x00,0x08,0xf0
	.byte 0x6d,0x61,0x69,0x6e,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_funcnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_funcnames"
	.byte 0x00,0x00,0x00,0x78,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x3e,0xe4,0x00,0x00,0x01,0x8a
	.byte 0x52,0x65,0x61,0x64,0x4d,0x65,0x73,0x68
	.byte 0x00,0x00,0x00,0x03,0xa7,0x44,0x72,0x61
	.byte 0x77,0x4d,0x65,0x73,0x68,0x00,0x00,0x00
	.byte 0x04,0x37,0x53,0x50,0x45,0x43,0x57,0x72
	.byte 0x69,0x74,0x65,0x49,0x6e,0x74,0x65,0x72
	.byte 0x6d,0x65,0x64,0x69,0x61,0x74,0x65,0x49
	.byte 0x6d,0x61,0x67,0x65,0x00,0x00,0x00,0x05
	.byte 0x3f,0x52,0x65,0x6e,0x64,0x65,0x72,0x00
	.byte 0x00,0x00,0x05,0xd7,0x52,0x65,0x73,0x68
	.byte 0x61,0x70,0x65,0x00,0x00,0x00,0x06,0x28
	.byte 0x49,0x6e,0x69,0x74,0x00,0x00,0x00,0x07
	.byte 0xf4,0x57,0x72,0x69,0x74,0x65,0x49,0x6d
	.byte 0x61,0x67,0x65,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x00,0x6c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x3e,0xe4,0x00,0x00,0x01,0x56
	.byte 0x47,0x4c,0x66,0x6c,0x6f,0x61,0x74,0x00
	.byte 0x00,0x00,0x02,0xbb,0x5f,0x5f,0x46,0x49
	.byte 0x4c,0x45,0x00,0x00,0x00,0x03,0x97,0x46
	.byte 0x49,0x4c,0x45,0x00,0x00,0x00,0x05,0x2c
	.byte 0x47,0x4c,0x75,0x62,0x79,0x74,0x65,0x00
	.byte 0x00,0x00,0x07,0x34,0x47,0x4c,0x69,0x6e
	.byte 0x74,0x00,0x00,0x00,0x09,0xe4,0x4f,0x53
	.byte 0x4d,0x65,0x73,0x61,0x43,0x6f,0x6e,0x74
	.byte 0x65,0x78,0x74,0x00,0x00,0x00,0x0a,0x69
	.byte 0x00,0x00,0x00,0x3a,0x05,0x47,0x4c,0x62
	.byte 0x6f,0x6f,0x6c,0x65,0x61,0x6e,0x00,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_varnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_varnames"
	.byte 0x00,0x00,0x00,0xe4,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x3e,0xe4,0x00,0x00,0x01,0x0a
	.byte 0x58,0x6d,0x69,0x6e,0x00,0x00,0x00,0x01
	.byte 0x1d,0x58,0x6d,0x61,0x78,0x00,0x00,0x00
	.byte 0x01,0x30,0x59,0x6d,0x69,0x6e,0x00,0x00
	.byte 0x00,0x01,0x43,0x59,0x6d,0x61,0x78,0x00
	.byte 0x00,0x00,0x01,0x64,0x58,0x72,0x6f,0x74
	.byte 0x00,0x00,0x00,0x01,0x77,0x59,0x72,0x6f
	.byte 0x74,0x00,0x00,0x00,0x06,0x65,0x74,0x65
	.byte 0x78,0x50,0x6c,0x61,0x6e,0x65,0x00,0x00
	.byte 0x00,0x06,0x7d,0x62,0x6c,0x75,0x65,0x00
	.byte 0x00,0x00,0x06,0x91,0x77,0x68,0x69,0x74
	.byte 0x65,0x00,0x00,0x00,0x06,0xa6,0x70,0x6f
	.byte 0x73,0x72,0x65,0x64,0x00,0x00,0x00,0x06
	.byte 0xbc,0x70,0x6f,0x73,0x67,0x72,0x65,0x65
	.byte 0x6e,0x00,0x00,0x00,0x06,0xd4,0x70,0x6f
	.byte 0x73,0x62,0x6c,0x75,0x65,0x00,0x00,0x00
	.byte 0x06,0xeb,0x67,0x72,0x61,0x79,0x72,0x65
	.byte 0x64,0x00,0x00,0x00,0x07,0x02,0x67,0x72
	.byte 0x61,0x79,0x67,0x72,0x65,0x65,0x6e,0x00
	.byte 0x00,0x00,0x07,0x1b,0x67,0x72,0x61,0x79
	.byte 0x62,0x6c,0x75,0x65,0x00,0x00,0x00,0x0a
	.byte 0x02,0x53,0x75,0x72,0x66,0x61,0x63,0x65
	.byte 0x4e,0x00,0x00,0x00,0x0a,0x19,0x53,0x75
	.byte 0x72,0x66,0x61,0x63,0x65,0x56,0x00,0x00
	.byte 0x00,0x0a,0x30,0x4e,0x75,0x6d,0x43,0x6f
	.byte 0x6c,0x75,0x6d,0x6e,0x73,0x00,0x00,0x00
	.byte 0x0a,0x49,0x4e,0x75,0x6d,0x52,0x6f,0x77
	.byte 0x73,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
