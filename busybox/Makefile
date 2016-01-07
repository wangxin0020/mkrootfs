ifeq ($(MKR_BUSYBOX_CONFIG),defconfig)
defconfig:=y
endif

board-config = $(srctree)/boards/$(MKR_BOARD)/$(MKR_BUSYBOX_CONFIG)
defconfig-$(defconfig) = $(MAKE) $(args) defconfig
defconfig-$(call not,$(defconfig)) = cp $(board-config) .config

# Configuring busybox
args := V=$(KBUILD_VERBOSE) SKIP_STRIP=y -C $(srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(cross)ar" \
	EXTRA_CFLAGS="$(MKR_CFLAGS)" \
	EXTRA_LDFLAGS="$(MKR_LDFLAGS)" \
	CROSS_COMPILE="$(cross)"

../.busybox_config: \
	$(O)/include/config/arch.h \
	$(O)/include/config/board.h \
	$(O)/include/config/busybox/config.h
	$(Q)$(defconfig-y)
	$(Q)sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)mv .config $@

.config: ../.busybox_config
	$(Q)cmp $< $@ || cp $< $@

mkr-config:
	@echo Resetting busybox configuration to $(board-config); \
	$(Q)$(defconfig-y)
	$(Q)sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)cp .config ../.busybox_config

include/autoconf.h: .config ../.mkr.builddir .mkr.srcdir
	test -f Makefile && $(MAKE) $(args) distclean || :
	cp ../.busybox_config .config
	yes "" | $(MAKE) $(args) oldconfig
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config

# Building busybox
compile: include/autoconf.h
	$(MAKE) $(args)
	$(Q)cp .config ../.busybox_config

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
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)cp .config ../.busybox_config

clean: .config
	$(MAKE) $(args) $@
