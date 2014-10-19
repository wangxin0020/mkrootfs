ifeq ($(MKR_SYSROOT_AUTO),y)
.mkr.toolchain_dirs: $(deps)
	$(pkgdir)/toolchain-dirs.sh $(CC) $(MKR_CFLAGS) > $@ || :

-include .mkr.toolchain_dirs
else
LIBDIRS=$(foreach d,lib usr/lib,$(MKR_SYSROOT)/$(d))
BINDIRS=$(foreach d,sbin bin usr/sbin usr/bin,$(MKR_SYSROOT)/$(d))
endif

ifeq ($(MKR_TOOLCHAIN32),y)
ifeq ($(MKR_SYSROOT_AUTO),y)
.mkr.toolchain_dirs32: $(deps32)
	$(pkgdir)/toolchain-dirs.sh --32 $(CC32) $(MKR_CFLAGS) > $@ || :

-include .mkr.toolchain_dirs32
else
LIBDIRS32=$(foreach d,lib lib32 usr/lib32,$(MKR_SYSROOT32)/$(d))
endif
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
			ldd) sed -i 's/bash/ash/g' "$(pkginst)/$$dest/$$b";; \
			esac; \
			break; \
		done; \
	done

libs:
	mkdir -p "$(pkginst)/lib" "$(pkginst)/usr/lib"
ifeq ($(MKR_ARM_FLOAT_VFP_HARD_ABI),y)
	ln -s . "$(pkginst)/lib/arm-linux-gnueabihf"; \
	ln -s . "$(pkginst)/usr/lib/arm-linux-gnueabihf"
endif
	loaderbase=$(shell basename $(LOADER)); \
	loaderdir=$(shell dirname $(LOADER)); \
	mkdir -p "$(pkginst)$$loaderdir"; \
	for l in $$loaderbase $(libs-y); do \
		for d in $(LIBDIRS); do \
			case "$$d" in \
			*usr/lib*) dest=usr/lib;; \
			*) dest=lib;; \
			esac; \
			case "$$l" in \
			"$$loaderbase") \
				file="$$d"/"$$l"; \
				dest="$$loaderdir";; \
			*.so) file="$$d"/"$$l".[0-9];; \
			*) file="$$d"/"$$l"-*.so;; \
			esac; \
			set -- "$$file"; \
			[ -e $$1 ] || continue; \
			cp --preserve=mode,timestamps $$1 "$(pkginst)/$$dest"; \
			break; \
		done; \
	done

libs32:
	mkdir -p "$(pkginst)/lib32" "$(pkginst)/usr/lib32"
	loaderbase=$(shell basename $(LOADER32)); \
	loaderdir=$(shell dirname $(LOADER32)); \
	mkdir -p "$(pkginst)$$loaderdir"; \
	for l in $$loaderbase $(libs-y); do \
		for d in $(LIBDIRS32); do \
			case "$$d" in \
			*usr/lib*) dest=usr/lib32;; \
			*) dest=lib32;; \
			esac; \
			case "$$l" in \
			"$$loaderbase") \
				file="$$d"/"$$l"; \
				dest="$$loaderdir";; \
			*.so) file="$$d"/"$$l".[0-9];; \
			*) file="$$d"/"$$l"-*.so;; \
			esac; \
			set -- "$$file"; \
			[ -e $$1 ] || continue; \
			cp --preserve=mode,timestamps $$1 "$(pkginst)/$$dest"; \
			break; \
		done; \
	done

libs32-$(MKR_TOOLCHAIN32) := libs32

staging: bins libs $(libs32-y)

rootfs: default-copyall-rootfs

clean: ;

# Configuration checks
confcheck-$(MKR_LIBSTDCPP) += $(call confcheck-tool, $(MKR_CXX), MKR_CXX)
confcheck-y += $(call confcheck-ifnot, \
	$(pkgdir)/toolchain-ok.sh \
		"$(ARCH)" "$(LIBDIRS)" "$(BINDIRS)" $(CC), \
	Error in toolchain, flags or sysroot settings\
	maybe SYSROOT_MANUAL is necessary?)

confcheck-$(MKR_TOOLCHAIN32) += $(call confcheck-ifnot, \
	$(pkgdir)/toolchain-ok.sh \
		"$(ARCH32)" "$(LIBDIRS32)" "$(BINDIRS32)" $(CC32), \
	Error in 32 bits toolchain, flags or sysroot settings\
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

confcheck: default-confcheck
