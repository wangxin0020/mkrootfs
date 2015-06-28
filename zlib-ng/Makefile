configure-args-y := \
	--zlib-compat \
	--prefix=/usr

configure-env-y := \
	CHOST="$(MKR_CONFIGURE_HOST)" \
	CC="$(CC)" \
	CFLAGS="$(cflags-y)" \
	LDFLAGS="$(ldflags-y)"

rootfs-y := \
	/usr/lib/libz.so.*

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
