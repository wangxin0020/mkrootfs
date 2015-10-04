configure-args-y := \
	--zlib-compat \
	--prefix=/usr

configure-args-$(MKR_ARCH_X86_32) += --32
configure-args-$(MKR_ARCH_X86_64) += --64

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
