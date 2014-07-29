configure-args-y :=

configure-env-y := \
	prefix=/usr \
	CC="$(CC)" \
	CFLAGS="$(cflags-y)" \
	LDFLAGS="$(ldflags-y)"

rootfs-y := \
	/usr/lib/libz.so.*

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
