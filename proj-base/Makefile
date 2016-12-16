

DIRS = balls boxes spring

default:
	echo The only non-default target is clean.

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
