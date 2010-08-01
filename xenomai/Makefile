# Configuration
configure-args-y += --includedir=/usr/include/xenomai
configure-args-$(MKR_XENO_MAINT) += --enable-maintainer-mode
configure-args-$(MKR_XENO_DEBUG) += --enable-debug

configure-args-$(MKR_XENO_SMP) += --enable-smp
configure-args-$(call not, $(MKR_XENO_SMP)) += --disable-smp

configure-args-$(MKR_XENO_SEP_TESTDIR) += --with-testdir="$(MKR_XENO_TESTDIR)"

ifneq ($(strip $(MKR_ARCH_X86_32)$(MKR_ARCH_X86_64)),)
configure-args-$(MKR_XENO_X86_SEP) += --enable-x86-sep
configure-args-$(call not, $(MKR_XENO_X86_SEP)) += --disable-x86-sep

configure-args-$(MKR_XENO_X86_TSC) += --enable-x86-tsc
configure-args-$(call not, $(MKR_XENO_X86_TSC)) += --disable-x86-tsc
endif

configure-args-$(MKR_XENO_THREAD) += --with-__thread
configure-args-$(call not, $(MKR_XENO_THREAD)) += --without-__thread

configure-args-$(MKR_XENO_DLOPEN) += --enable-dlopen-skins
configure-args-$(MKR_POSIX_MLOCKALL) += --enable-posix-auto-mlockall
configure-args-$(MKR_PSOS_MLOCKALL) += --enable-psos-auto-mlockall
configure-args-$(MKR_UITRON_MLOCKALL) += --enable-uitron-auto-mlockall

ifeq ($(MKR_ARCH_ARM),y)
-include ../toolchain/arm-eabi

configure-args-y += --enable-arm-mach="$(MKR_XENO_ARM_MACH)"
configure-args-$(TOOLCHAIN_ARM_EABI) += --enable-arm-eabi
endif

# Compilation
compile: default-autotools-compile

# Installation
staging: default-autotools-staging

rootfs-y := \
	/dev/rtheap \
	/dev/rtp*
rootfs-$(MKR_XENO_A4L) += \
	/usr/lib/libanalogy.so.* \
	/usr/bin/insn_read \
	/usr/bin/insn_write \
	/usr/bin/cmd_bits \
	/usr/bin/cmd_read \
	/usr/bin/cmd_write
rootfs-$(MKR_XENO_NATIVE) += \
	/usr/lib/libnative.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_POSIX) += \
	/usr/lib/libpthread_rt.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_PSOS) += \
	/usr/lib/libpsos.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_RTCAN) += \
	/usr/bin/rtcanrecv \
	/usr/bin/rtcansend
rootfs-$(MKR_XENO_RTDM) += \
	/usr/lib/librtdm.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_UITRON) += \
	/usr/lib/libuitron.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_VRTX) += \
	/usr/lib/libvrtx.so.* \
	/usr/lib/libxenomai.so.*
rootfs-$(MKR_XENO_VXWORKS) += \
	/usr/lib/libvxworks.so.* \
	/usr/lib/libxenomai.so.*

MKR_XENO_TESTDIR ?= /usr/bin

rootfs-$(MKR_XENO_TESTSUITE) += \
	$(MKR_XENO_TESTDIR)/arith \
	$(MKR_XENO_TESTDIR)/check-vdso \
	$(MKR_XENO_TESTDIR)/clocktest \
	$(MKR_XENO_TESTDIR)/cyclictest \
	$(MKR_XENO_TESTDIR)/cond-torture-native \
	$(MKR_XENO_TESTDIR)/cond-torture-posix \
	$(MKR_XENO_TESTDIR)/irqloop \
	$(MKR_XENO_TESTDIR)/klatency \
	$(MKR_XENO_TESTDIR)/latency \
	$(MKR_XENO_TESTDIR)/mutex-torture-native \
	$(MKR_XENO_TESTDIR)/mutex-torture-posix \
	$(MKR_XENO_TESTDIR)/rtdm \
	$(MKR_XENO_TESTDIR)/sigtest \
	$(MKR_XENO_TESTDIR)/switchtest \
	$(MKR_XENO_TESTDIR)/wakeup-time \
	/usr/bin/xeno-test \
	/usr/bin/xeno-load \
	/usr/share/xenomai/testsuite/*

rootfs: default-rootfs

clean: default-clean

# Checking configuration
confcheck-$(CONFIG_SMP) += $(call confcheck-if, \
	test "$(MKR_XENO_SMP)" != "y", \
	SMP kernel with non-SMP Xenomai user-space)

confcheck: default-confcheck
