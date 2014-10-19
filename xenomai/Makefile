compile-$(call not, $(MKR_XENO32)) := default-autotools-compile
config-$(call not, $(MKR_XENO32)) := configure
lib-$(call not, $(MKR_XENO32)) := lib
compile-$(MKR_XENO32) := default-autotools-compile32
config-$(MKR_XENO32) := configure32
lib-$(MKR_XENO32) := lib32

ifeq ($(MKR_XENO32),y)
configure := configure32
compile-target := default-autotools-compile32
libdir := lib32
else
configure := configure
compile-target := default-autotools-compile
libdir := lib
endif

# Configuration
$(config-y)-args-y += --includedir=/usr/include/xenomai --disable-doc-install
$(config-y)-args-$(MKR_XENO_MAINT) += --enable-maintainer-mode

$(config-y)-args-$(MKR_XENO_SMP) += --enable-smp
$(config-y)-args-$(call not, $(MKR_XENO_SMP)) += --disable-smp

$(config-y)-args-$(MKR_XENO_SEP_TESTDIR) += --with-testdir="$(MKR_XENO_TESTDIR)"

ifneq ($(strip $(MKR_ARCH_X86_32)$(MKR_ARCH_X86_64)),)
ifeq ($(strip $(MKR_XENO_FORGE)),y)
# Xenomai forge
$(config-y)-args-$(MKR_XENO_X86_VSYSCALL) += --enable-x86-vsyscall
$(config-y)-args-$(call not, $(MKR_XENO_X86_VSYSCALL)) += --disable-x86-vsyscall
else
# Xenomai classic
$(config-y)-args-$(MKR_XENO_X86_VSYSCALL) += --enable-x86-sep
$(config-y)-args-$(call not, $(MKR_XENO_X86_VSYSCALL)) += --disable-x86-sep
endif
$(config-y)-args-$(MKR_XENO_X86_TSC) += --enable-x86-tsc
$(config-y)-args-$(call not, $(MKR_XENO_X86_TSC)) += --disable-x86-tsc
endif

ifeq ($(strip $(MKR_XENO_FORGE)),y)
# Xenomai forge
$(config-y)-args-$(MKR_XENO_THREAD) += --enable-tls
$(config-y)-args-$(call not, $(MKR_XENO_THREAD)) += --disable-tls
$(config-y)-args-$(MKR_XENO_DEBUG_NONE) += --disable-debug
$(config-y)-args-$(MKR_XENO_DEBUG_SYMBOLS) += --enable-debug=symbols
$(config-y)-args-$(MKR_XENO_DEBUG_PARTIAL) += --enable-debug=partial
$(config-y)-args-$(MKR_XENO_DEBUG_FULL) += --enable-debug=full
$(config-y)-args-$(MKR_XENO_VALGRIND) += --enable-valgrind-client
$(config-y)-args-$(call not, $(MKR_XENO_VALGRIND)) += --disable-valgrind-client
common-libs-y += /usr/$(lib-y)/libcopperplate.so.*
common-libs-$(MKR_XENO_COBALT) += /usr/$(lib-y)/libcobalt.so.*

else
# Xenomai classic
$(config-y)-args-$(MKR_XENO_THREAD) += --with-__thread
$(config-y)-args-$(call not, $(MKR_XENO_THREAD)) += --without-__thread
$(config-y)-args-$(MKR_XENO_DEBUG) += --enable-debug
$(config-y)-args-$(call not, $(MKR_XENO_DEBUG)) += --disable-debug
common-libs-y := /usr/$(lib-y)/libxenomai.so.*
endif

$(config-y)-args-$(MKR_XENO_DLOPEN) += --enable-dlopen-skins
$(config-y)-args-$(MKR_POSIX_MLOCKALL) += --enable-posix-auto-mlockall
$(config-y)-args-$(MKR_PSOS_MLOCKALL) += --enable-psos-auto-mlockall
$(config-y)-args-$(MKR_UITRON_MLOCKALL) += --enable-uitron-auto-mlockall

$(config-y)-args-$(MKR_XENO_ATOMIC_BUILTINS) += --with-atomic-ops=builtins
$(config-y)-args-$(MKR_XENO_ATOMIC_ADHOC) += --with-atomic-ops=adhoc

ifeq ($(MKR_ARCH_ARM),y)
-include ../toolchain/arm-eabi

$(config-y)-args-y += --enable-arm-mach="$(MKR_XENO_ARM_MACH)" --enable-arm-tsc="$(MKR_XENO_ARM_MACH)"
$(config-y)-args-$(TOOLCHAIN_ARM_EABI) += --enable-arm-eabi
$(config-y)-args-y += --enable-arm-arch="$(MKR_ARM_ARCH)"
endif

$(config-y)-args-$(MKR_XENO_COBALT) += --with-core=cobalt
$(config-y)-args-$(MKR_XENO_MERCURY) += --with-core=mercury

$(config-y)-args-$(MKR_XENO_FORGE_MONOTONIC_RAW) += --enable-clock-monotonic-raw
$(config-y)-args-$(MKR_XENO_FORGE_REGISTRY) += --enable-registry
$(config-y)-args-$(MKR_XENO_FORGE_LORES_CLOCK) += --enable-lores-clock
$(config-y)-args-$(MKR_XENO_FORGE_ASSERT) += --enable-assert
$(config-y)-args-$(MKR_XENO_FORGE_ASYNC_CANCEL) += --enable-async-cancel
$(config-y)-args-$(MKR_XENO_FORGE_PSHARED) += --enable-pshared

# Compilation
compile: $(compile-y)

# Installation
staging: default-autotools-staging

rootfs-y := \
	/dev/rtheap \
	/dev/rtp* \
	/usr/sbin/autotune \
	/usr/sbin/rtcanconfig \
	/usr/sbin/rtps \
	/usr/sbin/slackspot \
	/usr/sbin/version \
	/usr/bin/clock_settime
rootfs-$(MKR_XENO_FORGE_REGISTRY) += \
	/usr/bin/sysregd
rootfs-$(MKR_XENO_A4L) += \
	/usr/$(lib-y)/libanalogy.so.* \
	/usr/sbin/analogy_config \
	/usr/bin/insn_read \
	/usr/bin/insn_write \
	/usr/bin/cmd_bits \
	/usr/bin/cmd_read \
	/usr/bin/cmd_write \
	/usr/bin/wf_generate
rootfs-$(MKR_XENO_NATIVE) += \
	/usr/$(lib-y)/libalchemy.so.* \
	/usr/$(lib-y)/libnative.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_POSIX) += \
	/usr/$(lib-y)/libpthread_rt.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_PSOS) += \
	/usr/$(lib-y)/libpsos.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_RTCAN) += \
	/usr/bin/rtcanrecv \
	/usr/bin/rtcansend
rootfs-$(MKR_XENO_RTDM) += \
	/usr/$(lib-y)/librtdm.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_UITRON) += \
	/usr/$(lib-y)/libuitron.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_VRTX) += \
	/usr/$(lib-y)/libvrtx.so.* \
	$(common-libs-y)
rootfs-$(MKR_XENO_VXWORKS) += \
	/usr/$(lib-y)/libvxworks.so.* \
	$(common-libs-y)

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
	/usr/bin/dohell \
	/usr/bin/smokey \
	/usr/$(lib-y)/libtrank.so.* \
	/usr/$(lib-y)/libsmokey.so.*

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
ifeq ($(MKR_ARCH_X86_64),y)
confcheck-$(MKR_FUSE32) += $(call confcheck-if, \
	test -z "$(MKR_XENO32)", \
	MKR_FUSE32 must be disabled if MKR_XENO32 is disabled)
endif
confcheck-$(MKR_XENO_FORGE) += $(call confcheck-if, \
	test -n "$(CONFIG_IPIPE_LEGACY)", \
	CONFIG_IPIPE_LEGACY must be disabled with Xenomai Cobalt)
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
