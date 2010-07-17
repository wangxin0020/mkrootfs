defconfig := $(if $(findstring defconfig,$(MKR_LINUX_CONFIG)),y)
netdest := $(if $(findstring :, \
	$(MKR_LINUX_IMAGE_DEST)$(MKR_LINUX_EXTRA_INSTALL)),y)

# Getting the kernel version
# Upper Makefile checked that Makefile existed in Linux sources directory
$(foreach t,VERSION PATCHLEVEL SUBLEVEL, \
	$(eval $(shell grep '^$(t) =' $(srcdir)/Makefile)))
KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)

ifeq ($(defconfig),)
# board-config is $(MKR_LINUX_CONFIG), but if it contains the
# kernel version and can not be found, try another config file with the
# same name but a different version number
board-config := $(srctree)/boards/$(MKR_BOARD)/$(MKR_LINUX_CONFIG)
ifeq ($(wildcard $(board-config)),)
ifneq ($(findstring $(KERNELVERSION),$(board-config)),)
board-config-wildcard := $(subst $(KERNELVERSION),*,$(board-config))
board-config := $(lastword $(sort $(wildcard $(board-config-wildcard))))
endif
endif
else
board-config := $(MKR_LINUX_CONFIG)
endif

# Checking whether MKR_XENO changed
.mkr.cleaned: .mkr.srcdir $(O)/include/config/xeno.h $(O)/include/config/karch.h
	$(Q)rm -Rf * $(filter-out .mkr%,$(wildcard .[a-z]* ..[a-z]*)) && : > $@

# Patching the kernel with Xenomai
ifeq ($(MKR_XENO),y)
xeno-srcdir=$(call mksrcdir,$(MKR_XENO_SRCDIR))
.mkr.prepared: .mkr.cleaned
	$(Q)echo Preparing linux sources directory...
	$(Q)rm -f drivers/Makefile kernel/Makefile \
		arch/$(MKR_KARCH)/Makefile init/Kconfig; \
	lndir -silent -ignorelinks $(srcdir) > /dev/null && \
		$(xeno-srcdir)/scripts/prepare-kernel.sh \
			--linux=. --arch=$(MKR_KARCH) && \
	: > .mkr.prepared
	$(Q)echo Preparing linux sources directory...done.

# In maintainer mode, trigger prepare-kernel for every compilation
ifeq ($(MKR_XENO_MAINT),y)
.PHONY: FORCE
.mkr.prepared: FORCE
endif
deps += .mkr.prepared

else
configargs := -C $(srcdir) O=$(CURDIR)
endif

# Configuring the kernel
configargs += V=$(KBUILD_VERBOSE) ARCH=$(MKR_KARCH)

defconfig-$(call not,$(defconfig)) = \
	$(Q)test -n "$(board-config)" && cp $(board-config) $@ || :
defconfig-$(defconfig) = \
	$(MAKE) $(configargs) $(MKR_LINUX_CONFIG) && mv .config $@

config-deps-y += $(O)/include/config/linux/config.h
config-deps-$(call not,$(defconfig)) += $(O)/include/config/board.h

.mkr_config: $(config-deps-y)
	$(Q)rm -f ../.linux_config
	+$(defconfig-y)

../.linux_config: ;

.config: .mkr_config $(wildcard ../.linux_config)
	@if [ -e ../.linux_config ]; then \
		echo Resetting Linux configuration to .linux_config; \
		cp ../.linux_config .config; \
	else \
		echo Resetting Linux configuration to $(board-config);	\
		cp .mkr_config .config; \
	fi

mkr-config: .mkr_config
	@echo Resetting Linux configuration to $(board-config)
	cp .mkr_config .config
	rm -f ../.linux_config

include/generated/autoconf.h: .config $(deps) .mkr.cleaned
	yes "" | $(MAKE) $(configargs) oldconfig

# Building the kernel
# get CONFIG_MODULES from kernel configuration
$(eval $(shell grep '^CONFIG_MODULES=y' .config 2> /dev/null))

buildargs := $(configargs) CROSS_COMPILE=$(kcross) CC=$(KCC)

cp-$(netdest) := scp -p
cp-$(call not,$(netdest)) := cp -a

compile: include/generated/autoconf.h
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS) modules
else
	$(MAKE) $(buildargs) $(MKR_LINUX_TARGETS)
endif
	chmod a+r $(MKR_LINUX_IMAGE)
	$(cp-y) $(MKR_LINUX_IMAGE) $(MKR_LINUX_IMAGE_DEST)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
	chmod a+r $(MKR_LINUX_EXTRA_FILES)
	$(cp-y) $(MKR_LINUX_EXTRA_FILES) $(MKR_LINUX_EXTRA_INSTALL)
endif

staging:
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(pkginst) modules_install
endif

rootfs: default-copyall-rootfs

# Checking mkrootfs configuration for building the kernel
confcheck-$(call not, $(defconfig)) += \
	$(call confcheck-if, \
		test -z "$(board-config)", \
		No kernel configuration file found see MKR_LINUX_CONFIG) \
	$(call confcheck-exists,$(board-config),MKR_LINUX_CONFIG)
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
# *config ones, and clean)
%config: .config $(if $(MKR_XENO),.mkr.prepared)
	$(MAKE) $(configargs) $@

clean: .config
	$(MAKE) $(buildargs) $@
