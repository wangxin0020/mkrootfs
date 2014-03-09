configure-args-y += \
	--enable-symlink-build \
	--enable-symlink-install \
	--enable-relative-symlinks \
	--enable-fsck \
	--disable-nls

rootfs-y += \
	/etc \
	/sbin \
	/usr/bin \
	/usr/sbin \
	/usr/lib

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
