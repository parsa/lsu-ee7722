

DIRS = balls boxes spring links

default:
	echo The only non-default target is clean.

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
