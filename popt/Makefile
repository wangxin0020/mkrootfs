configure-args-y += \
	--disable-static

rootfs-y := \
	/usr/lib/libpopt.so.*

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
