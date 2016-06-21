configure-args-y += --prefix=/ltp \
	ac_cv_header_openssl_sha_h=no \
	ac_cv_header_sys_acl_h=no

configure-args-$(call not,$(MKR_LTP_NEW_AIO)) += \
	ac_cv_header_libaio_h=no

compile-make-args-y += \
	-f $(srcdir)/Makefile \
	top_srcdir="$(srcdir)" \
	top_builddir=`pwd`

compile-make-args-$(MKR_LTP_NEW_AIO) += \
	AIO_LIBS="-laio"

staging-make-args-y += \
	-f $(srcdir)/Makefile \
	top_srcdir="$(srcdir)" \
	top_builddir=`pwd` \
	SKIP_IDCHECK=1

rootfs-y := \
	/ltp/.installed \
	/ltp/bin/* \
	/ltp/IDcheck.sh \
	/ltp/runalltests.sh \
	/ltp/runltp \
	/ltp/runltplite.sh \
	/ltp/runtest/* \
	/ltp/scenario_groups/* \
	/ltp/testcases/bin/* \
	/ltp/testcases/bin/cpu_hotplug/* \
	/ltp/testcases/bin/cpu_hotplug/functional/* \
	/ltp/testcases/bin/cpu_hotplug/include/* \
	/ltp/testcases/bin/cpu_hotplug/tools/* \
	/ltp/testcases/bin/fs_bind/bin/* \
	/ltp/testcases/bin/fs_bind/bind/* \
	/ltp/testcases/bin/fs_bind/cloneNS/* \
	/ltp/testcases/bin/fs_bind/move/* \
	/ltp/testcases/bin/fs_bind/rbind/* \
	/ltp/testcases/bin/fs_bind/regression/* \
	/ltp/testcases/bin/ftrace_stress/* \
	/ltp/testcases/data/* \
	/ltp/testcases/testscripts/* \
	/ltp/testscripts \
	/ltp/ver_linux \
	/ltp/Version

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging
	: > $(pkginst)/ltp/.installed

rootfs: default-rootfs

clean: default-clean
