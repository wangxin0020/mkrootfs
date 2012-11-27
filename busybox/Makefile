ifeq ($(MKR_BUSYBOX_CONFIG),defconfig)
defconfig:=y
endif

board-config = $(srctree)/boards/$(MKR_BOARD)/$(MKR_BUSYBOX_CONFIG)
defconfig-$(defconfig) = $(MAKE) $(args) defconfig
defconfig-$(call not,$(defconfig)) = cp $(board-config) .config

# Configuring busybox
args := V=$(KBUILD_VERBOSE) -C $(srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(cross)ar" \
	EXTRA_CFLAGS="$(MKR_CFLAGS)" \
	EXTRA_LDFLAGS="$(MKR_LDFLAGS)" \
	CROSS_COMPILE="$(cross)"

.mkr.cleanconf: \
	$(O)/include/config/arch.h \
	$(O)/include/config/board.h \
	$(O)/include/config/busybox/config.h
	$(Q)$(RM) .config ../.busybox_config && : > $@

.config: .mkr.cleanconf
	$(Q)if [ ! -e $@ ]; then \
		if [ ! -e ../.busybox_config ]; then \
			echo Resetting busybox configuration to $(board-config); \
			$(defconfig-y); \
		else \
			echo Resetting Linux configuration to .busybox_config; \
			cp ../.busybox_config $@; \
		fi; \
	fi

mkr-config:
	@echo Resetting busybox configuration to $(board-config); \
	$(Q)$(RM) ../.busybox_config; \
	$(defconfig-y)
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config

include/autoconf.h: .config ../.mkr.builddir .mkr.srcdir
	cp .config saved-busybox-config
	test -f Makefile && $(MAKE) $(args) distclean || :
	mv saved-busybox-config .config
	yes "" | $(MAKE) $(args) oldconfig
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config

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
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config

clean: .config
	$(MAKE) $(args) $@
