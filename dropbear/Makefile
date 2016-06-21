configure-args-y += --disable-bundled-libtom LIBS="-ltommath"

configure-args-$(MKR_DROPBEAR_ZLIB) += --enable-zlib
configure-args-$(call not, $(MKR_DROPBEAR_ZLIB)) += --disable-zlib

compile-make-args-y += \
	PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 SCPPROGRESS=1

staging-make-args-y += \
	PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 SCPPROGRESS=1

rootfs-y += \
	/usr/bin/dbclient \
	/usr/bin/dropbearkey \
	/usr/bin/dropbearmulti \
	/usr/bin/scp \
	/usr/sbin/dropbear

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
