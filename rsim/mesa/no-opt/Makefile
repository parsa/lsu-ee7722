###############################################################################
# SPECtools98 
#   Version 0.3
#   This makefile should NOT be changed other than to customize for a 
#   particular benchmark.  Users may overide variables by placing them
#   in the Makefile.spec file.  Or by using the "runspec" program to 
#   build the Makefile.spec file for them.
###############################################################################
#	BENCHMARK	-- standard definitions for this benchmark

NUMBER    = 177
NAME      = mesa
EXEBASE   = mesa
BENCHLANG = C
SOURCES   = accum.c alpha.c alphabuf.c api1.c api2.c attrib.c \
	    bitmap.c blend.c clip.c colortab.c context.c copypix.c \
	    depth.c dlist.c drawpix.c enable.c eval.c feedback.c \
	    fog.c get.c hash.c image.c light.c lines.c logic.c \
	    masking.c matrix.c misc.c mmath.c osmesa.c pb.c pixel.c \
	    pointers.c points.c polygon.c quads.c rastpos.c \
	    readpix.c rect.c scissor.c shade.c span.c stencil.c \
	    teximage.c texobj.c texstate.c texture.c triangle.c \
	    varray.c vb.c vbfill.c vbrender.c vbxform.c winpos.c \
	    xform.c mesa4.c
NEED_MATH = yes

xSOURCES   = accum.c

# Include standard template for this suite

#-include Makefile.spec

MAKE_CORE = /home/faculty/koppel/sim/rs_bug_632/bin/make-core

SPECLANG         = /local/SUNWspro/bin
CC               = ${SPECLANG}/cc

OBJ = .o

BENCHMARK     = $(NUMBER).$(NAME)
FINAL_SOURCES = $(filter-out $(RM_SOURCES),$(SOURCES)) $(EXTRA_SOURCES)
OBJS          = $(addsuffix $(OBJ),$(basename $(FINAL_SOURCES)))


LD	      = cc
CFLAGS        = -fast -g -xtarget=ultraT2
CFLAGS        =  -g -xtarget=ultraT2
LDFLAGS       = 
MATH_LIBS     = -lm

.SUFFIXES: $(OBJ)

%$(OBJ): %.c Makefile
	$(CC) $(CFLAGS) -S $*.c
	$(CC) $(CFLAGS) -c $*.s

$(EXEBASE): $(OBJS)
	$(LD) -o $(EXEBASE) $(LDFLAGS) $^ $(LIBS) $(MATH_LIBS) 
	$(MAKE_CORE) $(EXEBASE)


#mesa:Makefile

all:mesa
