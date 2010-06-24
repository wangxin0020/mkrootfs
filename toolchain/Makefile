LIBDIRS = $(shell for d in `$(CC) $(MKR_ARCH_FLAGS) --print-search-dirs \
	| sed 's/^libraries: =\\(.*\\)$$/\\1/;t next;d;:next y/:/ /'`; do \
	if [ -e $$d ]; then cd $$d && pwd; fi; done | sort -u)

libs-y := \
	libc.so \
	libgcc_s.so \
	ld-linux.so \
	libnsl.so \
	libnss_files.so \
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

BINDIRS = $(shell for d in `$(CC) $(MKR_ARCH_FLAGS) --print-search-dirs \
	| sed 's/^libraries: =\\(.*\\)$$/\\1/;t next;d;:next \
	s,\\([^:]*\\),\\1bin \\1../bin,g;y/:/ /'`; do \
	if [ -e $$d ]; then cd $$d && pwd; fi; done | sort -u)

bins-y := \
	gdbserver \
	ldconfig \
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
	sed -i 's/bash/ash/g' $(MKR_STAGING)/bin/ldd

libs:
	mkdir -p $(MKR_STAGING)/lib; \
	rm -f $(MKR_STAGING)/lib32 $(MKR_STAGING)/lib64; \
	ln -s lib $(MKR_STAGING)/lib64; \
	ln -s lib $(MKR_STAGING)/lib32; \
	for l in $(libs-y); do \
		for d in $(LIBDIRS); do \
			if [ -e $$d/$$l.[0-9] ]; then \
				cp $$d/$$l.[0-9] $(MKR_STAGING)/lib; \
				break; \
			fi; \
		done; \
	done

install: bins libs

ifneq ($(MKR_ARCH_ARM),)
.mkr.eabi: $(mkr-deps)
	$(CC) -o $@ $(cflags-y) -E $(mkr-pkgdir)/arm-eabi-check.h

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
