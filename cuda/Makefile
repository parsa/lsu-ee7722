

default:
	echo The only non-default target is clean.

DIRS = intro-vtx-transform matrix-mult sort stencil stream intro-simple

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
