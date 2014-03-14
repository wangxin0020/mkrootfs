configure-args-y += \
	--without-expat \
	--with-curses \
	--disable-nls \
	--disable-sim \
	--disable-gdbserver

configure-args-$(MKR_GDB_ZLIB) += --with-zlib
configure-args-$(call not, $(MKR_GDB_ZLIB)) += --without-zlib

compile: default-autotools-compile

staging: default-autotools-staging

rootfs-y := /usr/bin/gdb

rootfs: default-rootfs

clean: default-clean
