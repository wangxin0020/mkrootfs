configure-args-y += \
	--disable-udev

rootfs-y += \
	/usr/lib/libusb-1.0.so.*

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
