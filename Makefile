include Makefile.conf

export ROOT_DIR := $(BUILD_DIR)
MAKEFILES += tests/arithmetic/Makefile
MAKEFILES += tests/capacitor/Makefile
#MAKEFILES += tests/counter/Makefile
MAKEFILES += tests/designers_guide/ch4/Makefile
MAKEFILES += tests/designers_guide/ch4/listing09/Makefile.prop0
MAKEFILES += tests/designers_guide/ch4/listing09/Makefile.prop1
MAKEFILES += tests/designers_guide/ch4/listing12/Makefile
MAKEFILES += tests/flop_rnm/Makefile
MAKEFILES += tests/keymaera_x/damped_oscillator/Makefile
MAKEFILES += tests/keymaera_x/event_triggered_ping_pong_ball/Makefile
MAKEFILES += tests/keymaera_x/event_triggered_ping_pong_ball/Makefile.with_invariant
MAKEFILES += tests/keymaera_x/forward_driving_car/Makefile
MAKEFILES += tests/keymaera_x/short_bouncing_ball/Makefile
MAKEFILES += tests/keymaera_x/short_bouncing_ball/Makefile.with_invariant
MAKEFILES += tests/maurice2024/Makefile.adc
MAKEFILES += tests/maurice2024/Makefile.adc_dac
MAKEFILES += tests/maurice2024/Makefile.dac
MAKEFILES += tests/maurice2024/Makefile.dac_adc
MAKEFILES += tests/rnm_example/Makefile

.PHONY: all clean build prove $(MAKEFILES)

all: prove

prove: build $(MAKEFILES)

$(MAKEFILES):
	$(MAKE) -C $(dir $@) -f $(notdir $@) prove

build:
	$(foreach makefile,$(MAKEFILES),$(MAKE) -C $(dir $(makefile)) -f $(notdir $(makefile)) $@;)

backup:
	$(foreach makefile,$(MAKEFILES),$(MAKE) -C $(dir $(makefile)) -f $(notdir $(makefile)) $@;)

clean:
	$(foreach makefile,$(MAKEFILES),$(MAKE) -C $(dir $(makefile)) -f $(notdir $(makefile)) $@;)
