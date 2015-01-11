configure-args-y += \
	--bindir=/bin \
	--disable-nls \
	--enable-readline \
	--with-curses \
	--with-installed-readline

rootfs-y += \
	/bin/bash \
	/bin/sh

compile: default-autotools-compile

staging: default-autotools-staging
	ln -s bash $(pkginst)/bin/sh

rootfs: default-rootfs

clean: default-clean
