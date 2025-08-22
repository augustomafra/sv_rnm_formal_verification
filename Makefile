include Makefile.conf

export ROOT_DIR := $(BUILD_DIR)
SUB_DIRS += tests/arithmetic
SUB_DIRS += tests/capacitor
#SUB_DIRS += tests/counter
SUB_DIRS += tests/flop_rnm
SUB_DIRS += tests/maurice2024
SUB_DIRS += tests/rnm_example

.PHONY: all clean build prove

all: prove

prove: build
	$(foreach subdir,$(SUB_DIRS),$(MAKE) -C $(subdir) $@;)

build:
	$(foreach subdir,$(SUB_DIRS),$(MAKE) -C $(subdir) $@;)

backup:
	$(foreach subdir,$(SUB_DIRS),$(MAKE) -C $(subdir) $@;)

clean:
	$(foreach subdir,$(SUB_DIRS),$(MAKE) -C $(subdir) $@;)
