rootfs-y := /usr/bin/parted

configure-args-y += \
	--without-readline \
	LIBS="-lblkid -luuid -ldevmapper"

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-autotools-clean
