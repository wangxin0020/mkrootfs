CROSS_COMPILE := $(shell expr $(KCC) :  '\(.*\)gcc')

defconfig-p := $(if $(findstring defconfig, $(MKR_LINUX_DEFCONFIG)),y)
not-defconfig-p := $(if $(defconfig-p),,y)
netdest-p := $(if $(findstring :, $(MKR_LINUX_IMAGE_DEST)$(MKR_LINUX_EXTRA_INSTALL)),y)
not-netdest-p := $(if $(netdest-p),,y)

board-defconfig = $(srctree)/boards/$(MKR_BOARD)/$(MKR_LINUX_DEFCONFIG)

# Upper Makefile checked that Makefile existed in Linux sources directory
$(foreach t,VERSION PATCHLEVEL SUBLEVEL, \
	$(eval $(shell grep '^$(t) =' $(mkr-srcdir)/Makefile)))
KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Configuring the kernel
configargs := V=$(KBUILD_VERBOSE) -C $(mkr-srcdir) O=$(CURDIR) ARCH=$(MKR_KARCH)

defconfig-$(not-defconfig-p) := cp $(board-defconfig) $@
defconfig-$(defconfig-p) := $(MAKE) $(configargs) $(MKR_LINUX_DEFCONFIG)

.config: $(O)/include/config/linux/defconfig.h
	@echo Resetting Linux configuration to $(MKR_LINUX_DEFCONFIG)
	$(Q)$(defconfig-y) $@

include/linux/autoconf.h: .config $(mkr-deps)
	$(Q)$(MAKE) $(configargs) oldconfig

# Building the kernel
buildargs := $(configargs) CROSS_COMPILE=$(CROSS_COMPILE) CC=$(KCC)
cp-$(netdest-p) := scp -p
cp-$(not-netdest-p) := cp -a

install:
	$(call mkr-recurse,$(MKR_LINUX_TARGETS) modules,$(MAKE) $(buildargs))
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(MKR_STAGING) modules_install
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(MKR_ROOTFS) modules_install
	$(cp-y) $(MKR_LINUX_IMAGE) $(MKR_LINUX_IMAGE_DEST)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
	$(cp-y) $(MKR_LINUX_EXTRA_FILES) $(MKR_LINUX_EXTRA_INSTALL)
endif

# Catch-all target
%:
	$(MAKE) $(buildargs) $@

# Checking mkrootfs configuration for building the kernel
confcheck-$(not-defconfig-p) += $(call confcheck-exists,$(board-defconfig),MKR_LINUX_DEFCONFIG)
confcheck-$(netdest-p) += $(call confcheck-tool,scp,MKR_LINUX_IMAGE_DEST)
confcheck-y += $(call confcheck-not-empty, MKR_LINUX_TARGETS)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
confcheck-$(not-netdest-p) += $(call confcheck-exists,$(MKR_LINUX_EXTRA_INSTALL),MKR_LINUX_EXTRA_INSTALL)
endif
confcheck-y += $(call confcheck-tool,$(MKR_CC),MKR_CC)
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_KCC)

confcheck: default-confcheck
