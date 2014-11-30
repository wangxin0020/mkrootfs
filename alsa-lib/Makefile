configure-args-y += \
	--disable-python

rootfs-y := \
	/usr/lib/alsa-lib/smixer/*.so \
	/usr/lib/libasound.so.* \
	/usr/share/alsa/alsa.conf.d/README

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
