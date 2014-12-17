ifeq ($(MKR_SYSROOT_AUTO),y)
.mkr.toolchain_dirs: $(deps) $(pkgdir)/toolchain-dirs.sh
	$(pkgdir)/toolchain-dirs.sh $(CC) $(MKR_CFLAGS) > $@ || :

-include .mkr.toolchain_dirs
else
LIBDIRS=$(foreach d,lib usr/lib,$(MKR_SYSROOT)/$(d))
BINDIRS=$(foreach d,sbin bin usr/sbin usr/bin,$(MKR_SYSROOT)/$(d))
LOADER_SRC=$(wildcard $(MKR_SYSROOT)/lib/ld*.so.*)
LOADER=$(patsubst $(MKR_SYSROOT)%,%,$(LOADER_SRC))
endif

ifeq ($(MKR_TOOLCHAIN32),y)
ifeq ($(MKR_SYSROOT32_AUTO),y)
.mkr.toolchain_dirs32: $(deps32) $(pkgdir)/toolchain-dirs.sh
	$(pkgdir)/toolchain-dirs.sh --32 $(CC32) $(MKR_CFLAGS) > $@ || :

-include .mkr.toolchain_dirs32
else
LIBDIRS32=$(foreach d,lib lib32 usr/lib32,$(MKR_SYSROOT32)/$(d))
LOADER32=$(patsubst $(MKR_SYSROOT32)%,%,$(wildcard $(MKR_SYSROOT32)/lib/ld*.so.*))
endif
endif

ifeq ($(MKR_ARM_FLOAT_VFP),y)
.mkr.toolchain.arm.vfp.abi: $(deps) $(pkgdir)/toolchain-arm-vfp-abi.sh
	$(pkgdir)/toolchain-arm-vfp-abi.sh $(CC) $(MKR_CFLAGS) > $@ || :

staging: .mkr.toolchain.arm.vfp.abi
endif

libs-y += \
	libc.so \
	libnss_files.so \
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
libs-$(MKR_LIBUTIL) += \
	libutil.so

bins-y := \
	gdbserver \
	ldconfig \
	ldconfig.real \
	ldd

# Compiling: nothing to do
compile: ;

# Installing stuff
bins:
	mkdir -p "$(pkginst)/bin" "$(pkginst)/sbin"\
		"$(pkginst)/usr/bin" "$(pkginst)/usr/sbin"; \
	for b in $(bins-y); do \
		for d in $(BINDIRS); do \
			bin="$$d/$$b"; \
			[ -e "$$bin" ] || continue; \
			case "$$bin" in \
			*usr/bin/*) dest=usr/bin;; \
			*usr/sbin/*) dest=usr/sbin;; \
			*/sbin/*) dest=sbin;; \
			*) dest=bin;; \
			esac; \
			cp --preserve=timestamps "$$bin" "$(pkginst)/$$dest"; \
			case "$$b" in \
			ldd) sed -i 's,^#!.*$$,#! /bin/ash,g' "$(pkginst)/$$dest/$$b"; \
				chmod a+rx "$(pkginst)/$$dest/$$b";; \
			esac; \
			break; \
		done; \
	done

libs:
	mkdir -p "$(pkginst)/lib" "$(pkginst)/usr/lib"
	if [ -n "$(LOADER_FALLBACK)" ]; then \
		$(srctree)/build-tools/relln.sh \
			"$(pkginst)/lib" "$(pkginst)$(LOADER_FALLBACK)"; \
	fi
	mkdir -p "$(pkginst)$(shell dirname $(LOADER))"
	cp --preserve=mode,timestamps "$(LOADER_SRC)" "$(pkginst)/$(LOADER)"
	for l in $(libs-y); do \
		for d in $(LIBDIRS); do \
			case "$$d" in \
			*usr/lib*) dest=usr/lib;; \
			*) dest=lib;; \
			esac; \
			case "$$l" in \
			*.so) file="$$d"/"$$l".[0-9];; \
			*) file="$$d"/"$$l"-*.so;; \
			esac; \
			set -- $$file; \
			[ -e $$1 ] || continue; \
			cp --preserve=mode,timestamps $$1 "$(pkginst)/$$dest"; \
			break; \
		done; \
	done

libs32:
	mkdir -p "$(pkginst)/lib32" "$(pkginst)/usr/lib32"
	mkdir -p "$(pkginst)$(shell dirname $(LOADER32))"
	cp --preserve=mode,timestamps "$(LOADER_SRC32)" "$(pkginst)/$(LOADER32)"
	for l in $(libs-y); do \
		for d in $(LIBDIRS32); do \
			case "$$d" in \
			*usr/lib*) dest=usr/lib32;; \
			*) dest=lib32;; \
			esac; \
			case "$$l" in \
			*.so) file="$$d"/"$$l".[0-9];; \
			*) file="$$d"/"$$l"-*.so;; \
			esac; \
			set -- $$file; \
			[ -e $$1 ] || continue; \
			cp --preserve=mode,timestamps $$1 "$(pkginst)/$$dest"; \
			break; \
		done; \
	done

libs32-$(MKR_TOOLCHAIN32) := libs32

.PHONY: bin libs libs32
staging: bins libs $(libs32-y)

rootfs: default-copyall-rootfs

clean: ;

# Configuration checks
confcheck-$(MKR_LIBSTDCPP) += $(call confcheck-tool, $(MKR_CXX), MKR_CXX)
confcheck-y += $(call confcheck-ifnot, \
	$(pkgdir)/toolchain-ok.sh \
		"$(ARCH)" "$(LIBDIRS)" "$(BINDIRS)" $(CC), \
	Error in toolchain or flags or sysroot settings\
	maybe SYSROOT_MANUAL is necessary?)

confcheck-$(MKR_TOOLCHAIN32) += $(call confcheck-ifnot, \
	$(pkgdir)/toolchain-ok.sh \
		"$(ARCH32)" "$(LIBDIRS32)" "$(BINDIRS32)" $(CC32), \
	Error in 32 bits toolchain or flags or sysroot settings\
	maybe SYSROOT32_MANUAL is necessary?)

# ARM EABI check
ifeq ($(MKR_ARCH_ARM),y)
arm-eabi: $(deps)
	$(CC) -o $@ $(cflags-y) -E $(pkgdir)/arm-eabi-check.h || :

-include arm-eabi

# Invalid configurations:
# CONFIG_AEABI CONFIG_OABI_COMPAT TOOLCHAIN_ARM_EABI
#     y			n		n
#     n			*		y

confcheck-$(TOOLCHAIN_ARM_EABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_AEABI)" != "y", \
		EABI toolchain but EABI not enabled in kernel configuration)

confcheck-$(CONFIG_AEABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_OABI_COMPAT)" != "y" \
			-a "$(TOOLCHAIN_ARM_EABI)" != "y", \
		EABI-only kernel with non-EABI toolchain)

confcheck-$(MKR_ARM_VFP) += \
	$(call confcheck-if, \
		test "$(CONFIG_VFP)" != "y", \
		VFP-enabled user-space with non-VFP kernel)
endif

confcheck-$(MKR_ARCH_PPC32) += \
	$(call confcheck-if, \
		test "$(CONFIG_PPC32)" != "y", \
		PowerPC 32 user-space with PowerPC 64 kernel configuration)

confcheck-$(MKR_ARCH_PPC64) += \
	$(call confcheck-if, \
		test "$(CONFIG_PPC64)" != "y", \
		PowerPC 64 user-space with PowerPC 32 kernel configuration)

confcheck-$(MKR_ARCH_X86_64) += \
	$(call confcheck-if, \
		test "$(CONFIG_X86_64)" != "y", \
		x86 64 user-space with x86 32 kernel configuration)

# on x86_64, the kernel may support a 32 bits filesystem if
# CONFIG_IA32_EMULATION is enabled.

confcheck-$(MKR_ARCH_X86_32) += \
	$(call confcheck-if, \
		test "$(CONFIG_X86_32)" != "y" \
			-a "$(CONFIG_IA32_EMULATION)" != "y", \
		x86 32 user-space with x86 64 only kernel configuration)

ifeq ($(MKR_ARCH_X86_64),y)
confcheck-$(MKR_TOOLCHAIN32) += $(call confcheck-if, \
	test -z "$(CONFIG_IA32_EMULATION)", \
	MKR_TOOLCHAIN32 needs CONFIG_IA32_EMULATION on x86_64)
endif

confcheck: default-confcheck
