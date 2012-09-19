ifeq ($(MKR_BUSYBOX_CONFIG),defconfig)
defconfig:=y
endif

board-config = $(srctree)/boards/$(MKR_BOARD)/$(MKR_BUSYBOX_CONFIG)
defconfig-$(defconfig) = $(MAKE) $(args) defconfig && mv .config $@
defconfig-$(call not,$(defconfig)) = cp $(board-config) $@

# Configuring busybox
args := V=$(KBUILD_VERBOSE) -C $(srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(cross)ar" \
	EXTRA_CFLAGS="$(ARCH_FLAGS)" \
	EXTRA_LDFLAGS="$(ARCH_FLAGS)" \
	CROSS_COMPILE="$(cross)"

.mkr_config:  $(deps)
	$(Q)rm -f ../.busybox_config
	$(defconfig-y)

../.busybox_config: ;

.config: .mkr_config $(wildcard ../.busybox_config)
	@if [ -e ../.busybox_config ]; then \
		echo Resetting Linux configuration to .busybox_config; \
		cp ../.busybox_config .config; \
	else \
		echo Resetting busybox configuration to $(MKR_BUSYBOX_CONFIG); \
		cp .mkr_config .config; \
	fi

mkr-config: .mkr_config
	@echo Resetting busybox configuration to $(MKR_BUSYBOX_CONFIG); \
	$(Q)cp .mkr_config .config
	$(Q)rm -f ../.busybox_config

include/autoconf.h: .config ../.mkr.builddir
	cp .config saved-busybox-config
	test -f Makefile && $(MAKE) $(args) distclean || :
	mv saved-busybox-config .config
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	yes "" | $(MAKE) $(args) oldconfig

# Building busybox
compile: include/autoconf.h
	$(MAKE) $(args)

# Installing it
staging:
	$(MAKE) $(args) install

rootfs: default-copyall-rootfs

# Checking configuration
confcheck-$(call not,$(defconfig)) += \
	$(call confcheck-exists $(board-config),MKR_BUSYBOX_CONFIG)

confcheck: default-confcheck

# Catch-all target, allow to run all the targets (including the
# *config ones and clean)
%config: .config
	$(MAKE) $(args) $@

clean: .config
	$(MAKE) $(args) $@
