configure-args-y += \
	ac_cv_rl_version=5.0 \
	--bindir=/bin \
	--disable-nls \
	--enable-readline \
	--with-curses \
	--with-installed-readline=$(staging)/usr

rootfs-y += \
	/bin/bash \
	/bin/sh

compile: default-autotools-compile

staging: default-autotools-staging
	ln -s bash $(pkginst)/bin/sh

rootfs: default-rootfs

clean: default-clean
