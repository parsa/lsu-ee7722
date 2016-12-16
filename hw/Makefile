
default:
	echo The only non-default target is clean.

DIRS = $(wildcard gpm/20[0-2][0-9]/hw[0-9][0-9]/) \
       $(wildcard gpup/20[0-2][0-9]/hw*[0-9]/)

.PHONY: clean $(DIRS)
clean: $(DIRS)

$(DIRS):
	$(MAKE) -C $@ clean
