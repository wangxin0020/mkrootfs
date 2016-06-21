configure-args-y += \
	ac_cv_rl_version=6.0 \
	--bindir=/bin \
	--disable-nls \
	--enable-readline \
	--with-curses \
	--with-installed-readline=$(staging)/

rootfs-y += \
	/bin/bash \
	/bin/sh

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging
	ln -s bash $(pkginst)/bin/sh

rootfs: default-rootfs

clean: default-clean
