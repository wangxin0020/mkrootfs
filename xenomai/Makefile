# Configuration
mkr-configure-args-y += --includedir=/usr/include/xenomai
mkr-configure-args-$(MKR_XENO_MAINT) += --enable-maintainer-mode
mkr-configure-args-$(MKR_XENO_DEBUG) += --enable-debug

mkr-configure-args-$(MKR_XENO_SMP) += --enable-smp
mkr-configure-args-$(call not, $(MKR_XENO_SMP)) += --disable-smp

ifneq ($(strip $(MKR_ARCH_X86_32)$(MKR_ARCH_X86_64)),)
mkr-configure-args-$(MKR_XENO_X86_SEP) += --enable-x86-sep
mkr-configure-args-$(call not, $(MKR_XENO_X86_SEP)) += --disable-x86-sep

mkr-configure-args-$(MKR_XENO_X86_TSC) += --enable-x86-tsc
mkr-configure-args-$(call not, $(MKR_XENO_X86_TSC)) += --disable-x86-tsc
endif

mkr-configure-args-$(MKR_XENO_THREAD) += --with-__thread
mkr-configure-args-$(call not, $(MKR_XENO_THREAD)) += --without-__thread

mkr-configure-args-$(MKR_XENO_DLOPEN) += --enable-dlopen-skins
mkr-configure-args-$(MKR_POSIX_MLOCKALL) += --enable-posix-auto-mlockall
mkr-configure-args-$(MKR_PSOS_MLOCKALL) += --enable-psos-auto-mlockall
mkr-configure-args-$(MKR_UITRON_MLOCKALL) += --enable-uitron-auto-mlockall

ifeq ($(MKR_ARCH_ARM),y)
-include ../toolchain/.mkr.eabi

mkr-configure-args-y += --enable-arm-mach="$(MKR_XENO_ARM_MACH)"
mkr-configure-args-$(MKR_ARM_EABI) += --enable-arm-eabi
endif

# Compilation
staging: default-autotools-staging

# Checking configuration
confcheck-$(CONFIG_SMP) += $(call confcheck-if, \
	test "$(MKR_XENO_SMP)" = "n", \
	SMP kernel with non-SMP Xenomai user-space)

confcheck: default-confcheck
