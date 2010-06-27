CROSS_COMPILE := $(shell expr $(KCC) : '\(.*\)gcc')

defconfig := $(if $(findstring defconfig, $(MKR_LINUX_DEFCONFIG)),y)
not-defconfig := $(if $(defconfig),,y)
netdest := $(if $(findstring :, $(MKR_LINUX_IMAGE_DEST)$(MKR_LINUX_EXTRA_INSTALL)),y)
not-netdest := $(if $(netdest),,y)

board-defconfig = $(srctree)/boards/$(MKR_BOARD)/$(MKR_LINUX_DEFCONFIG)

# Upper Makefile checked that Makefile existed in Linux sources directory
$(foreach t,VERSION PATCHLEVEL SUBLEVEL, \
	$(eval $(shell grep '^$(t) =' $(mkr-srcdir)/Makefile)))
KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Configuring the kernel
configargs := V=$(KBUILD_VERBOSE) -C $(mkr-srcdir) O=$(CURDIR) ARCH=$(MKR_KARCH)

defconfig-$(not-defconfig) := cp $(board-defconfig) $@
defconfig-$(defconfig) := $(MAKE) $(configargs) $(MKR_LINUX_DEFCONFIG)

config-deps-y := $(O)/include/config/linux/defconfig.h
config-deps-$(not-defconfig) += $(O)/include/config/board.h

.config: $(config-deps-y)
	@echo Resetting Linux configuration to $(MKR_LINUX_DEFCONFIG)
	$(defconfig-y)

include/linux/autoconf.h: .config $(mkr-deps)
	$(MAKE) $(configargs) oldconfig

# Building the kernel
# get CONFIG_MODULES from kernel configuration
$(eval $(shell grep '^CONFIG_MODULES=y' .config 2> /dev/null))

buildargs := $(configargs) CROSS_COMPILE=$(CROSS_COMPILE) CC=$(KCC)

cp-$(netdest) := scp -p
cp-$(not-netdest) := cp -a

staging: include/linux/autoconf.h
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS) modules
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(MKR_STAGING) modules_install
else
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS)
endif
	$(cp-y) $(MKR_LINUX_IMAGE) $(MKR_LINUX_IMAGE_DEST)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
	$(cp-y) $(MKR_LINUX_EXTRA_FILES) $(MKR_LINUX_EXTRA_INSTALL)
endif

# Catch-all target, allow to run all the targets (including the
# *config ones)
%:
	$(MAKE) $(buildargs) $@

# Checking mkrootfs configuration for building the kernel
confcheck-$(not-defconfig) += $(call confcheck-exists,$(board-defconfig),MKR_LINUX_DEFCONFIG)
confcheck-$(netdest) += $(call confcheck-tool,scp,MKR_LINUX_IMAGE_DEST)
confcheck-y += $(call confcheck-not-empty, MKR_LINUX_TARGETS)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
confcheck-$(not-netdest) += $(call confcheck-exists,$(MKR_LINUX_EXTRA_INSTALL),MKR_LINUX_EXTRA_INSTALL)
endif
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_CC)
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_KCC)

confcheck: default-confcheck
