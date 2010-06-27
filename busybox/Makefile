ifeq ($(MKR_BUSYBOX_CONFIG),defconfig)
defconfig:=y
else
not-defconfig:=y
endif

board-config = $(srctree)/boards/$(MKR_BOARD)/$(MKR_BUSYBOX_CONFIG)
defconfig-$(defconfig) = $(MAKE) $(configargs) defconfig
defconfig-$(not-defconfig) = cp $(board-defconfig)

# Configuring busybox
configargs := V=$(KBUILD_VERBOSE) -C $(mkr-srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(mkr-cross)ar" \
	EXTRA_CFLAGS="$(ARCH_FLAGS)" \
	EXTRA_LDFLAGS="$(ARCH_FLAGS)" \
	CROSS_COMPILE="$(shell expr $(CC) : '\(.*\)gcc')" \

.config:  $(mkr-deps)
	@echo Resetting busybox configuration to $(MKR_BUSYBOX_CONFIG)
	$(defconfig-y)

include/autoconf.h: .config
	cp .config saved-busybox-config
	test -f Makefile && $(MAKE) $(configargs) distclean || :
	mv saved-busybox-config .config
	$(MAKE) $(configargs) oldconfig

# Building busybox
buildargs = $(configargs) CONFIG_PREFIX=$(MKR_STAGING)

staging: include/autoconf.h
	$(MAKE) $(buildargs) install

# Catch-all target, allow to run all the targets (including the
# *config ones)
%:
	$(MAKE) $(buildargs) $@

# Checking configuration
confcheck-$(not-defconfig) += $(call confcheck-exists $(board-config),MKR_BUSYBOX_CONFIG)
