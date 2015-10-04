configure-args-y += \
	--disable-udev \
	--with-crypto_backend=kernel

rootfs-y += \
	/usr/lib/libcryptsetup.so.* \
	/usr/sbin/cryptsetup \
	/usr/sbin/veritysetup

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
