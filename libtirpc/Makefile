configure-args-y += \
	--disable-gssapi \
	--disable-ipv6 \
	--sysconfdir=/etc

rootfs-y := \
	/etc/netconfig \
	/usr/lib/libtirpc.so.*

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
