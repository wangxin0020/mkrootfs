defconfig := $(if $(findstring defconfig,$(MKR_LINUX_DEFCONFIG)),y)
netdest := $(if $(findstring :, \
	$(MKR_LINUX_IMAGE_DEST)$(MKR_LINUX_EXTRA_INSTALL)),y)

board-defconfig = $(srctree)/boards/$(MKR_BOARD)/$(MKR_LINUX_DEFCONFIG)

# Getting the kernel version
# Upper Makefile checked that Makefile existed in Linux sources directory
$(foreach t,VERSION PATCHLEVEL SUBLEVEL, \
	$(eval $(shell grep '^$(t) =' $(mkr-srcdir)/Makefile)))
KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

# Checking whether MKR_XENO changed
.mkr.xeno: $(O)/include/config/xeno.h
	$(Q)rm -Rf * && : > $@

# Patching the kernel with Xenomai
ifeq ($(MKR_XENO),y)
mkr-xeno-srcdir=$(call mksrcdir,$(MKR_XENO_SRCDIR))

.mkr.prepared: .mkr.xeno
	$(Q)echo Preparing linux sources directory...
	$(Q)rm -f drivers/Makefile kernel/Makefile \
		arch/$(MKR_KARCH)/Makefile init/Kconfig; \
	lndir -silent -ignorelinks $(mkr-srcdir) && \
		$(mkr-xeno-srcdir)/scripts/prepare-kernel.sh \
			--linux=. --arch=$(MKR_KARCH) && \
	: > .mkr.prepared
	$(Q)echo Preparing linux sources directory...done.

config-deps-y += .mkr.prepared

# In maintainer mode, trigger prepare-kernel for every compilation
ifeq ($(MKR_XENO_MAINT),y)
.PHONY: .mkr.prepared
mkr-deps += .mkr.prepared
endif

else
configargs := -C $(mkr-srcdir) O=$(CURDIR)
endif

# Configuring the kernel
configargs += V=$(KBUILD_VERBOSE) ARCH=$(MKR_KARCH)

defconfig-$(call not,$(defconfig)) := cp $(board-defconfig) $@
defconfig-$(defconfig) := $(MAKE) $(configargs) $(MKR_LINUX_DEFCONFIG)

config-deps-y += $(O)/include/config/linux/defconfig.h
config-deps-$(call not,$(defconfig)) += $(O)/include/config/board.h

.config: $(config-deps-y)
	@echo Resetting Linux configuration to $(MKR_LINUX_DEFCONFIG)
	$(defconfig-y)

include/generated/autoconf.h: .config $(mkr-deps) .mkr.xeno
	$(MAKE) $(configargs) silentoldconfig

# Building the kernel
# get CONFIG_MODULES from kernel configuration
$(eval $(shell grep '^CONFIG_MODULES=y' .config 2> /dev/null))

buildargs := $(configargs) CROSS_COMPILE=$(mkr-kcross) CC=$(KCC)

cp-$(netdest) := scp -p
cp-$(call not,$(netdest)) := cp -a

compile: include/generated/autoconf.h
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS) modules
else
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS)
endif
	$(cp-y) $(MKR_LINUX_IMAGE) $(MKR_LINUX_IMAGE_DEST)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
	$(cp-y) $(MKR_LINUX_EXTRA_FILES) $(MKR_LINUX_EXTRA_INSTALL)
endif

staging:
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(mkr-pkginst) modules_install
endif

rootfs: default-copyall-rootfs

# Checking mkrootfs configuration for building the kernel
confcheck-$(call not, $(defconfig)) += \
	$(call confcheck-exists,$(board-defconfig),MKR_LINUX_DEFCONFIG)
confcheck-$(netdest) += $(call confcheck-tool,scp,MKR_LINUX_IMAGE_DEST)
confcheck-y += $(call confcheck-not-empty, MKR_LINUX_TARGETS)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
confcheck-$(call not, $(netdest)) += \
$(call confcheck-exists,$(MKR_LINUX_EXTRA_INSTALL),MKR_LINUX_EXTRA_INSTALL)
endif
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_CC)
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_KCC)
confcheck-$(MKR_XENO) += $(call confcheck-tool,lndir,MKR_XENO)

confcheck: default-confcheck

# Catch-all target, allow to run all the targets (including the
# *config ones)
%:
	$(MAKE) $(buildargs) $@
