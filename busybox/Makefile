ifeq ($(MKR_BUSYBOX_CONFIG),defconfig)
defconfig:=y
endif

board-config = $(srctree)/boards/$(MKR_BOARD)/$(MKR_BUSYBOX_CONFIG)
defconfig-$(defconfig) = $(MAKE) $(args) defconfig
defconfig-$(call not,$(defconfig)) = cp $(board-defconfig) .config

# Configuring busybox
args := V=$(KBUILD_VERBOSE) -C $(srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(cross)ar" \
	EXTRA_CFLAGS="$(ARCH_FLAGS)" \
	EXTRA_LDFLAGS="$(ARCH_FLAGS)" \
	CROSS_COMPILE="$(shell expr $(CC) : '\(.*\)gcc')" \

.config:  $(deps)
	@echo Resetting busybox configuration to $(MKR_BUSYBOX_CONFIG)
	$(defconfig-y)

include/autoconf.h: .config
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

# Catch-all target, allow to run all the targets (including the
# *config ones)
%:
	$(MAKE) $(args) $@
