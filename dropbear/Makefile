configure-args-y += \
	--prefix=/usr \
	--disable-zlib

compile-make-args-y += \
	PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 SCPPROGRESS=1

staging-make-args-y += \
	PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 SCPPROGRESS=1

rootfs-y += \
	/usr/bin \
	/usr/sbin

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
