# Master makefile
#
# Only used for cleaning.  For building the makefiles in the
# subdirectories must be individually run.


default:
	echo The only non-default target is clean.

DIRS = gpup cuda proj-base gpgpu hw cpu-only util lib

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
