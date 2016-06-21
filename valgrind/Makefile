configure-args-$(MKR_ARCH_ARM) := \
	--target=arm-none-linux-gnueabi \
	--host=armv7-none-linux-gnueabi \
	--prefix=/usr \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" LDFLAGS="$(ldflags-y)"

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-copyall-rootfs

clean: default-clean
