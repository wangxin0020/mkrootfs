configure-args-y += --prefix=/ltp

compile-make-args-y += \
	-f $(srcdir)/Makefile \
	top_srcdir="$(srcdir)" \
	top_builddir=`pwd`

staging-make-args-y += \
	-f $(srcdir)/Makefile \
	top_srcdir="$(srcdir)" \
	top_builddir=`pwd` \
	SKIP_IDCHECK=1

rootfs-y := \
	/ltp/.installed \
	/ltp/bin \
	/ltp/IDcheck.sh \
	/ltp/runalltests.sh \
	/ltp/runltp \
	/ltp/runltplite.sh \
	/ltp/runtest \
	/ltp/scenario_groups \
	/ltp/testcases \
	/ltp/testscripts \
	/ltp/ver_linux \
	/ltp/Version

compile: default-autotools-compile

staging: default-autotools-staging
	: > $(pkginst)/ltp/.installed

rootfs: default-rootfs

clean: default-clean
