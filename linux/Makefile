defconfig := $(if $(findstring defconfig,$(MKR_LINUX_CONFIG)),y)
netdest := $(if $(findstring :, \
	$(MKR_OUT_TFTP_DIRNAME)$(MKR_LINUX_EXTRA_INSTALL)),y)

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

defconfig-$(call not,$(defconfig)) = \
	if test -e "$(board-config)"; then \
		echo Resetting Linux configuration to $(board-config); \
		cp $(board-config) .config; \
	else \
		echo "No board config found (tried $(board-config))"; \
	fi

defconfig-$(defconfig) = \
	$(Q)echo Resetting Linux configuration to $(board-config); \
	$(MAKE) $(configargs) $(MKR_LINUX_CONFIG)

# Checking whether the .config must change
../.linux_config: $(O)/include/config/karch.h \
		$(O)/include/config/board.h \
		$(O)/include/config/linux/config.h
	$(Q)$(defconfig-y)
	$(Q)mv .config $@

.mkr.cleaned: $(wildcard $(O)/include/config/xeno/kernel.h  \
			$(O)/include/config/xeno.h \
			$(O)/include/config/karch.h \
			$(O)/include/config/board.h \
			$(O)/include/config/linux/config.h)
	$(Q)rm -Rf * $(filter-out .config .mkr.srcdir .mkr.log .mkr.filelist .mkr.dirlist,$(wildcard .[a-z]* ..[a-z]*)) && : > $@

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

.config: ../.linux_config $(ready)
	$(Q)cmp $< $@ || cp $< $@

mkr-config: $(ready)
	$(Q)$(defconfig-y)
	$(Q)cp .config ../.linux_config

include/generated/autoconf.h: .config ../.mkr.kvers \
	$(wildcard $(O)/include/config/xeno/kernel.h)
	yes "" | $(MAKE) $(configargs) oldconfig
	$(Q)cp .config ../.linux_config

# Building the kernel
# get CONFIG_MODULES from kernel configuration
$(eval $(shell grep '^CONFIG_MODULES=y' .config 2> /dev/null))

buildargs := $(configargs) CROSS_COMPILE=$(kcross) CC=$(KCC)
ifneq ($(MKR_LINUX_LOADADDR),)
buildargs += LOADADDR="$(MKR_LINUX_LOADADDR)"
endif

cp-$(netdest) := scp -p
cp-$(call not,$(netdest)) := cp -a

ZIMAGE_PATH = arch/$(KARCH)/boot/zImage
DT_BLOB=$(wildcard arch/$(KARCH)/boot/$(MKR_LINUX_DT_NAME) arch/$(KARCH)/boot/dts/$(MKR_LINUX_DT_NAME))

targets-y := $(MKR_LINUX_TARGETS)
targets-$(CONFIG_MODULES) += modules
targets-$(MKR_LINUX_DT_MERGED) += $(MKR_LINUX_DT_NAME)
targets-$(MKR_LINUX_DT) += $(MKR_LINUX_DT_NAME)

build: include/generated/autoconf.h
	$(MAKE) $(buildargs) $(targets-y)
	$(Q)cp .config ../.linux_config

copy-kernel: build
ifeq ($(MKR_LINUX_DT_MERGED),y)
	dt_blob=$(DT_BLOB); \
	cat $(ZIMAGE_PATH) $$dt_blob > zImage-dt ; \
	mkimage -A $(KARCH) -O linux -T kernel -C none \
		-a $(MKR_LINUX_LOADADDR) \
		-e $(MKR_LINUX_LOADADDR) -n Linux -d zImage-dt uImage
	chmod a+r uImage
	$(cp-y) uImage $(MKR_OUT_TFTP_DIRNAME)/kernel-$(MKR_OUT_TFTP_BASENAME)
else
	chmod a+r $(MKR_LINUX_IMAGE)
	$(cp-y) $(MKR_LINUX_IMAGE) $(MKR_OUT_TFTP_DIRNAME)/kernel-$(MKR_OUT_TFTP_BASENAME)
endif

copy-dtb: build
ifneq ($(strip $(MKR_LINUX_DT_NAME)),)
	dt_blob=$(DT_BLOB); \
	chmod a+r $$dt_blob; \
	$(cp-y) $$dt_blob $(MKR_OUT_TFTP_DIRNAME)/dtb-$(MKR_OUT_TFTP_BASENAME)
endif

compile-deps-y := build
compile-deps-$(MKR_OUT_TFTP) += copy-kernel
compile-deps-$(MKR_OUT_TFTP)-$(MKR_LINUX_DT) += copy-dtb

compile: $(compile-deps-y) $(compile-deps-y-y)
ifneq ($(strip $(MKR_LINUX_EXTRA_FILES)),)
	chmod a+r $(MKR_LINUX_EXTRA_FILES)
	$(cp-y) $(MKR_LINUX_EXTRA_FILES) $(MKR_LINUX_EXTRA_INSTALL)
endif

staging:
ifeq ($(CONFIG_MODULES),y)
	$(MAKE) $(buildargs) INSTALL_MOD_PATH=$(pkginst) modules_install firmware_install
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
confcheck-$(MKR_LINUX_DT_MERGED) += $(call confcheck-tool,mkimage,MKR_LINUX_DT_MERGED)
confcheck-$(MKR_LINUX_DT_MERGED) += $(call confcheck-if, \
	test -z "$(CONFIG_ARM_APPENDED_DTB)", \
	MKR_LINUX_DT_MERGED requires CONFIG_ARM_APPENDED_DTB in kernel configuration)
confcheck-$(MKR_LINUX_DT_MERGED) += $(call confcheck-if, \
	test -z "$(CONFIG_ARM_ATAG_DTB_COMPAT)", \
	MKR_LINUX_DT_MERGED requires CONFIG_ARM_ATAG_DTB_COMPAT in kernel configuration)
confcheck-$(MKR_LINUX_DT_MERGED) += $(call confcheck-not-empty, \
	MKR_LINUX_DT_NAME)
confcheck-$(MKR_LINUX_DT_MERGED) += $(call confcheck-not-empty, \
	MKR_LINUX_LOADADDR)
confcheck-$(MKR_OUT_INITRAMFS_GZ) += $(call confcheck-if, \
	test -z "$(CONFIG_RD_GZIP)", \
	initramfs Gzip compression requires CONFIG_RD_GZIP in kernel configuration)
confcheck-$(MKR_OUT_INITRAMFS_XZ) += $(call confcheck-if, \
	test -z "$(CONFIG_RD_XZ)", \
	initramfs Xz compression requires CONFIG_RD_XZ in kernel configuration)

confcheck: default-confcheck

# Catch-all target, allow to run all the targets (including the
# *config ones, and clean)
%config: .config
	$(MAKE) $(configargs) $@
	$(Q)cp .config ../.linux_config

clean: .config
	$(MAKE) $(buildargs) $@

.PHONY: FORCE
