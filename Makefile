# Master makefile
#
# Only used for cleaning.  For building the makefiles in the
# subdirectories must be individually run.


default:
	echo The only non-default target is clean.

MAIN_DIRS = gpup cuda proj-base gpgpu hw cpu-only

# The clean target on older makefiles will wastefully build code in theses dirs.
FDEPS = util lib

DIRS = $(MAIN_DIRS) $(FDEPS)

.PHONY: clean main_clean $(DIRS)

main_clean: $(MAIN_DIRS)

clean: main_clean $(FDEPS)

$(MAIN_DIRS):
	$(MAKE) -C $@ clean

$(FDEPS): main_clean
	$(MAKE) -C $@ clean
