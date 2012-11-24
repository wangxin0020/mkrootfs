# Configuration
configure-args-y += --includedir=/usr/include/xenomai --disable-doc-install --disable-async-cancel --disable-lores-clock
configure-args-$(MKR_XENO_MAINT) += --enable-maintainer-mode
configure-args-$(MKR_XENO_DEBUG) += --enable-debug
configure-args-$(call not, $(MKR_XENO_DEBUG)) += --disable-debug

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
configure-args-y += --enable-arm-arch="$(MKR_ARM_ARCH)"
endif

configure-args-$(MKR_XENO_COBALT) += --with-core=cobalt
configure-args-$(MKR_XENO_MERCURY) += --with-core=mercury

configure-args-$(MKR_XENO_FORGE_MONOTONIC_RAW) += --enable-clock-monotonic-raw
configure-args-$(MKR_XENO_FORGE_REGISTRY) += --enable-registry
configure-args-$(MKR_XENO_MERCURY_LORES_CLOCK) += --enable-lores-clock
configure-args-$(MKR_XENO_MERCURY_ASSERT) += --enable-assert
configure-args-$(MKR_XENO_MERCURY_ASYNC_CANCEL) += --enable-async-cancel
configure-args-$(MKR_XENO_MERCURY_PSHARED) += --enable-pshared

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
	$(MKR_XENO_TESTDIR)/latency \
	$(MKR_XENO_TESTDIR)/mutex-torture-native \
	$(MKR_XENO_TESTDIR)/mutex-torture-posix \
	$(MKR_XENO_TESTDIR)/switchtest \
	$(MKR_XENO_TESTDIR)/wakeup-time \
	$(MKR_XENO_TESTDIR)/regression/* \
	/usr/bin/xeno-test* \
	/usr/bin/xeno-regression-test \
	/usr/bin/xeno-load \
	/usr/bin/dohell

rootfs-$(MKR_XENO_TESTSUITE_UNFREQUENT) += \
	$(MKR_XENO_TESTDIR)/irqloop \
	$(MKR_XENO_TESTDIR)/klatency \
	$(MKR_XENO_TESTDIR)/rtdm \
	$(MKR_XENO_TESTDIR)/sigtest
ifneq ($(strip $(MKR_ARCH_X86_32)$(MKR_ARCH_X86_64)),)
rootfs-$(MKR_XENO_TESTSUITE_UNFREQUENT) += \
	$(MKR_XENO_TESTDIR)/irqbench
endif

rootfs: default-rootfs

clean: default-clean

# Checking configuration
confcheck-$(CONFIG_SMP) += $(call confcheck-if, \
	test "$(MKR_XENO_SMP)" != "y", \
	SMP kernel with non-SMP Xenomai user-space)

ifeq ($(MKR_XENO_KERNEL),y)
confcheck-$(MKR_XENO_A4L) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_ANALOGY)", \
	MKR_XENO_A4L needs CONFIG_XENO_DRIVERS_ANALOGY in kernel configuration)
confcheck-$(MKR_XENO_RTCAN) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_CAN)", \
	MKR_XENO_RTCAN needs CONFIG_XENO_DRIVERS_RTCAN in kernel configuration)
confcheck-$(MKR_XENO_TESTSUITE) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_TIMERBENCH)", \
	MKR_XENO_TESTSUITE needs CONFIG_XENO_DRIVERS_TIMERBENCH in kernel configuration)
confcheck-$(MKR_XENO_TESTSUITE) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_SWITCHTEST)", \
	MKR_XENO_TESTSUITE needs CONFIG_XENO_DRIVERS_SWITCHTEST in kernel configuration)
confcheck-$(MKR_XENO_TESTSUITE_UNFREQUENT) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_IRQBENCH)", \
	MKR_XENO_TESTSUITE_UNFREQUENT needs CONFIG_XENO_DRIVERS_IRQBENCH in kernel configuration)
confcheck-$(MKR_XENO_TESTSUITE_UNFREQUENT) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_RTDMTEST)", \
	MKR_XENO_TESTSUITE_UNFREQUENT needs CONFIG_XENO_DRIVERS_RTDMTEST in kernel configuration)
confcheck-$(MKR_XENO_TESTSUITE_UNFREQUENT) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_DRIVERS_KLATENCY)", \
	MKR_XENO_TESTSUITE_UNFREQUENT needs CONFIG_XENO_DRIVERS_KLATENCY in kernel configuration)
endif

ifeq ($(MKR_XENO_CLASSIC),y)
confcheck-$(MKR_XENO_USERSPACE) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_OPT_PERVASIVE)" , \
	Xenomai user-space support needs CONFIG_XENO_OPT_PERVASIVE in kernel configuration)
confcheck-$(MKR_XENO_NATIVE) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_NATIVE)", \
	MKR_XENO_NATIVE needs CONFIG_XENO_SKIN_NATIVE in kernel configuration)
confcheck-$(MKR_XENO_POSIX) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_POSIX)", \
	MKR_XENO_POSIX needs CONFIG_XENO_SKIN_POSIX in kernel configuration)
confcheck-$(MKR_XENO_PSOS) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_PSOS)", \
	MKR_XENO_PSOS needs CONFIG_XENO_SKIN_PSOS in kernel configuration)
confcheck-$(MKR_XENO_RTDM) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_RTDM)", \
	MKR_XENO_RTDM needs CONFIG_XENO_SKIN_RTDM in kernel configuration)
confcheck-$(MKR_XENO_UITRON) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_UITRON)", \
	MKR_XENO_UITRON needs CONFIG_XENO_SKIN_UITRON in kernel configuration)
confcheck-$(MKR_XENO_VRTX) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_VRTX)", \
	MKR_XENO_VRTX needs CONFIG_XENO_SKIN_VRTX in kernel configuration)
confcheck-$(MKR_XENO_VXWORKS) += $(call confcheck-if, \
	test -z "$(CONFIG_XENO_SKIN_VXWORKS)", \
	MKR_XENO_VXWORKS needs CONFIG_XENO_SKIN_VXWORKS in kernel configuration)
endif

confcheck: default-confcheck
