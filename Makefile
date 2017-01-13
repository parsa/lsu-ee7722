
default:
	echo The only non-default target is clean.

DIRS = gpup cuda proj-base gpgpu hw cpu-only util

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
