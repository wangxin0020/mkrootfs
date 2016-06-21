rootfs-y += \
	/usr/bin/lsusb \
	/usr/bin/usbhid-dump \
	/usr/sbin/update-usbids.sh \
	/usr/share/usb.ids.gz

cppflags-y += -DWITH_GZFILEOP

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_USB)", \
	usbutils require CONFIG_USB in kernel configuration)

confcheck: default-confcheck
