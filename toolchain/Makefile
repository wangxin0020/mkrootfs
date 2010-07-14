ifeq ($(MKR_SYSROOT_AUTO),y)
.mkr.toolchain_dirs: $(deps)
	$(pkgdir)/toolchain-dirs.sh $(CC) $(MKR_CFLAGS) > $@ || :

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

# Compiling: nothing to do
compile: ;

# Installing stuff
bins:
	mkdir -p "$(pkginst)/bin" "$(pkginst)/sbin"\
		"$(pkginst)/usr/bin" "$(pkginst)/usr/sbin"; \
	for b in $(bins-y); do \
		for d in $(BINDIRS); do \
			bin="$$d/$$b"; \
			if [ -e "$$bin" ]; then \
				case "$$bin" in \
				*usr/bin/*) dest=usr/bin;; \
				*usr/sbin/*) dest=usr/sbin;; \
				*/sbin/*) dest=sbin;; \
				*) dest=bin;; \
				esac; \
				install -o 0 "$$bin" "$(pkginst)/$$dest"; \
				break; \
			fi; \
		done; \
	done; \
	sed -i 's/bash/ash/g' $(pkginst)/bin/ldd > /dev/null 2>&1 || :

libs:
	mkdir -p "$(pkginst)/lib" "$(pkginst)/usr/lib"; \
	rm -f "$(pkginst)/lib32" "$(pkginst)/lib64" \
		"$(pkginst)/usr/lib32" "$(pkginst)/usr/lib64"; \
	ln -s lib "$(pkginst)/lib64"; \
	ln -s lib "$(pkginst)/lib32"; \
	ln -s lib "$(pkginst)/usr/lib64"; \
	ln -s lib "$(pkginst)/usr/lib32"; \
	for l in $(libs-y); do \
		case "$$l" in \
		*.so) \
			for d in $(LIBDIRS); do \
				if [ -e "$$d"/"$$l".[0-9] ]; then \
					case "$$d"/"$$l".[0-9] in \
					*usr/lib*) dest=usr/lib;; \
					*) dest=lib;; \
					esac; \
					install -o 0 "$$d"/"$$l".[0-9] "$(pkginst)/$$dest"; \
					break; \
				fi; \
			done; \
			;; \
		*) \
			for d in $(LIBDIRS); do \
				if [ -e "$$d"/"$$l"-*.so ]; then \
					case "$$d"/"$$l"-*.so in \
					*usr/lib*) dest=usr/lib;; \
					*) dest=lib;; \
					esac; \
					install -o 0 "$$d"/"$$l"-*.so "$(pkginst)/$$dest"; \
					break; \
				fi; \
			done; \
			;; \
		esac; \
	done

staging: bins libs

rootfs: default-copyall-rootfs

# Configuration checks
confcheck-y += $(call confcheck-tool, $(MKR_CXX), MKR_CXX)
confcheck-y += $(call confcheck-ifnot, \
	$(pkgdir)/toolchain-ok.sh \
		"$(ARCH)" "$(CC)" "$(LIBDIRS)" "$(BINDIRS)", \
	Error in toolchain or sysroot settings\
	maybe SYSROOT_MANUAL is necessary?)


# ARM EABI check
ifeq ($(MKR_ARCH_ARM),y)
.mkr.arm.eabi: $(deps)
	$(CC) -o $@ $(cflags-y) -E $(pkgdir)/arm-eabi-check.h || :

-include .mkr.arm.eabi

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
		test "$(CONFIG_VFP)" != "y", \
		VFP-enabled user-space with non-VFP kernel)
endif

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
			-a "$(CONFIG_IA32_EMULATION)" != "y", \
		x86 32 user-space with x86 64 only kernel configuration)

confcheck: default-confcheck
