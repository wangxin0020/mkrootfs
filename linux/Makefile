CROSS_COMPILE := $(shell expr $(KCC) : '\(.*\)gcc')

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
	$(defconfig-y) $@

include/config/auto.conf: .config $(mkr-deps)
	$(MAKE) $(configargs) oldconfig include/config/auto.conf

# Building the kernel
# Include kernel configuration to know the value of CONFIG_MODULES
-include include/config/auto.conf

buildargs := $(configargs) CROSS_COMPILE=$(CROSS_COMPILE) CC=$(KCC)

cp-$(netdest-p) := scp -p
cp-$(not-netdest-p) := cp -a

staging: include/config/auto.conf
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
confcheck-y += $(call confcheck-tool,$(MKR_KCC),MKR_KCC)

config-$(MKR_ARCH_PPC32) += \
	$(call confcheck-if, \
		test "$(CONFIG_PPC32)" != "y", \
		PowerPC 32 user-space with PowerPC 64 kernel configuration)

config-$(MKR_ARCH_PPC64) += \
	$(call confcheck-if, \
		test "$(CONFIG_PPC64)" != "y", \
		PowerPC 64 user-space with PowerPC 32 kernel configuration)

config-$(MKR_ARCH_X86_64) += \
	$(call confcheck-if, \
		test "$(CONFIG_X86_64)" != "y", \
		x86 64 user-space with x86 32 kernel configuration)

# on x86_64, the kernel may support a 32 bits filesystem if
# CONFIG_IA32_EMULATION is enabled.

config-$(MKR_ARCH_X86_32) += \
	$(call confcheck-if, \
		test "$(CONFIG_X86_32)" != "y" \
			-a "$(CONFIG_IA32_EMULATION)" != "y" \
		x86 32 user-space with pure x86 64 kernel configuration)

confcheck: default-confcheck