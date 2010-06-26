ifeq ($(MKR_SYSROOT_AUTO),y)
.mkr.toolchain_dirs: $(mkr-deps)
	$(mkr-pkgdir)/toolchain-dirs.sh $(CC) $(MKR_CFLAGS) > $@ || :

-include .mkr.toolchain_dirs
else
LIBDIRS=$(foreach d,lib usr/lib,$(MKR_SYSROOT)/$(d))
BINDIRS=$(foreach d,sbin bin usr/sbin usr/bin,$(MKR_SYSROOT)/$(d))
endif

libs-y := \
	ld-linux.so \
	libc.so \
	libnss_files.so \
	ld-uClibc.so \
	libuClibc \
	libgcc_s.so \
	libnsl.so \
	libdl.so \
	libcrypt.so
libs-$(MKR_LIBM) += \
	libm.so
libs-$(MKR_LIBRESOLV) += \
	libresolv.so \
	libnss_dns.so
libs-$(MKR_LIBPTHREAD) += \
	libpthread.so \
	librt.so \
	libthread_db.so
libs-$(MKR_LIBSTDCPP) += \
	libstdc++.so

bins-y := \
	gdbserver \
	ldconfig \
	ldconfig.real \
	ldd \
	lspci

bins:
	mkdir -p $(MKR_STAGING)/bin; \
	for b in $(bins-y); do \
		for d in $(BINDIRS); do \
			if [ -e $$d/$$b ]; then \
				cp $$d/$$b $(MKR_STAGING)/bin; \
				break; \
			fi; \
		done; \
	done; \
	sed -i 's/bash/ash/g' $(MKR_STAGING)/bin/ldd > /dev/null 2>&1 || :

libs:
	mkdir -p $(MKR_STAGING)/lib; \
	rm -f $(MKR_STAGING)/lib32 $(MKR_STAGING)/lib64; \
	ln -s lib $(MKR_STAGING)/lib64; \
	ln -s lib $(MKR_STAGING)/lib32; \
	for l in $(libs-y); do \
		case "$l" in \
		*.so) \
			for d in $(LIBDIRS); do \
				if [ -e $$d/$$l.[0-9] ]; then \
					cp $$d/$$l.[0-9] $(MKR_STAGING)/lib; \
					break; \
				fi; \
			done; \
			;; \
		*) \
			for d in $(LIBDIRS); do \
				if [ -e $$d/$$l-*.so ]; then \
					cp $$d/$$l-*.so $(MKR_STAGING)/lib; \
					break; \
				fi; \
			done; \
			;; \
		esac; \
	done

staging: bins libs

# Configuration checks

confcheck-y += $(call confcheck-tool,$(MKR_CC),MKR_CC)

confcheck-y += $(call confcheck-ifnot, \
	$(mkr-pkgdir)/toolchain-ok.sh \
		"$(ARCH)" "$(CC)" "$(LIBDIRS)" "$(BINDIRS)", \
	Error in toolchain or sysroot settings\
	maybe SYSROOT_MANUAL is necessary?)

ifneq ($(MKR_ARCH_ARM),)
.mkr.eabi: $(mkr-deps)
	$(CC) -o $@ $(cflags-y) -E $(mkr-pkgdir)/arm-eabi-check.h || :

-include .mkr.eabi

# Invalid configurations:
# CONFIG_AEABI CONFIG_OABI_COMPAT MKR_ARM_EABI
#     y			n		n
#     n			*		y

confcheck-$(MKR_ARM_EABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_AEABI)" != "y", \
		EABI toolchain but EABI not enabled in kernel configuration)

confcheck-$(CONFIG_AEABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_OABI_COMPAT)" != "y" \
			-a "$(MKR_ARM_EABI)" != "y", \
		EABI-only kernel with non-EABI toolchain)

confcheck-$(MKR_ARM_VFP) += \
	$(call confcheck-if, \
		test "$(CONFIG_VFP)" != "y" \
		VFP-enabled user-space with non-VFP kernel)
endif

confcheck: default-confcheck
