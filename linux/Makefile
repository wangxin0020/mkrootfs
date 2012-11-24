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

# Checking whether the .config must change
.mkr.cleanconf: \
	$(O)/include/config/karch.h \
	$(O)/include/config/board.h \
	$(O)/include/config/linux/config.h
	$(Q)$(RM) .config ../.linux_config && : > $@

.mkr.cleaned: $(wildcard $(O)/include/config/xeno/kernel.h  \
			$(O)/include/config/xeno.h) .mkr.cleanconf
	$(Q)rm -Rf * $(filter-out .config .mkr.cleanconf .mkr.srcdir .mkr.log .mkr.filelist .mkr.dirlist,$(wildcard .[a-z]* ..[a-z]*)) && : > $@

# Patching the kernel with Xenomai
ifeq ($(MKR_XENO_KERNEL),y)

lndir-$(call not $(MKR_XENO_MAINT)) := cp -sfR
lndir-$(MKR_XENO_MAINT) := lndir -silent -ignorelinks

xeno-srcdir=$(call mksrcdir,$(MKR_XENO_SRCDIR))

.mkr.cleaned: $(wildcard $(O)/include/config/linux/srcdir.h \
			$(O)/include/config/xeno/srcdir.h) ../.mkr.kvers

.mkr.prepared: .mkr.cleaned
	$(Q)echo Preparing linux sources directory...
	$(Q)rm -f drivers/Makefile kernel/Makefile \
		arch/$(KARCH)/Makefile init/Kconfig; \
	$(lndir-y) $(srcdir)/. . > /dev/null 2>&1 && \
		$(xeno-srcdir)/scripts/prepare-kernel.sh \
			--default --linux=. --arch=$(KARCH) && \
	: > $@
	$(Q)echo Preparing linux sources directory...done.

# In maintainer mode, trigger prepare-kernel for every compilation
ifeq ($(MKR_XENO_MAINT),y)
.mkr.prepared: FORCE
endif
ready := .mkr.prepared
else
ready := .mkr.cleaned

configargs := -C $(srcdir) O=$(CURDIR)
endif

# Configuring the kernel
configargs += V=$(KBUILD_VERBOSE) ARCH=$(KARCH)

defconfig-$(call not,$(defconfig)) = \
	test -n "$(board-config)" && cp $(board-config) .config || :
defconfig-$(defconfig) = \
	$(MAKE) $(configargs) $(MKR_LINUX_CONFIG)

.config: $(ready)
	$(Q)if [ ! -e $@ ]; then \
		if [ ! -e ../.linux_config ]; then \
			echo Resetting Linux configuration to $(board-config); \
			$(defconfig-y); \
		else \
			echo Resetting Linux configuration to .linux_config; \
			cp ../.linux_config $@; \
		fi; \
	fi

mkr-config: $(ready)
	$(Q)echo Resetting Linux configuration to $(board-config); \
	$(RM) ../.linux_config; \
	$(defconfig-y)

include/generated/autoconf.h: .config ../.mkr.kvers \
	$(wildcard $(O)/include/config/xeno/kernel.h)
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
confcheck-$(MKR_XENO_MAINT) += $(call confcheck-tool,lndir,MKR_XENO)
ifeq ($(MKR_XENO_KERNEL),y)
ipipe := $(wildcard $(call mksrcdir,$(MKR_LINUX_SRCDIR))/arch/$(KARCH)/include/asm/ipipe.h)
confcheck-$(MKR_XENO_MAINT) += $(if $(ipipe),,echo Maintainer mode only works with I-pipe patched kernel sources; success=false;)
endif

confcheck: default-confcheck

# Catch-all target, allow to run all the targets (including the
# *config ones, and clean)
%config: .config
	$(MAKE) $(configargs) $@

clean: .config
	$(MAKE) $(buildargs) $@

.PHONY: FORCE
