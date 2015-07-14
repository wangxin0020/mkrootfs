rootfs-y := \
	/usr/lib/libparted-fs-resize.so.* \
	/usr/lib/libparted.so.* \
	/usr/sbin/parted \
	/usr/sbin/partprobe

configure-args-y += \
	--without-readline \
	LIBS="-lblkid -luuid -ldevmapper"

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-autotools-clean
