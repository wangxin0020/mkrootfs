configure-args-y += \
	--disable-static \
	--enable-host-shared \
	--without-expat \
	--with-curses \
	--with-system-readline \
	--disable-nls \
	--disable-sim \
	--disable-gdbserver

configure-args-$(MKR_GDB_ZLIB) += --with-zlib
configure-args-$(call not, $(MKR_GDB_ZLIB)) += --without-zlib

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs-y := /usr/bin/gdb

rootfs: default-rootfs

clean: default-clean
