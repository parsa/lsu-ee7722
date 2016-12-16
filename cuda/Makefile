

default:
	echo The only non-default target is clean.

DIRS = intro-vtx-transform matrix-mult sort stencil stream

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
