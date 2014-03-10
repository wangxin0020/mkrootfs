configure-args-y += \
	--disable-ldconfig \
	--enable-posix-acls \
	--enable-xattr-mappings \
	--enable-extras \
	--with-fuse=external \
	--with-uuid \
	--with-hd

rootfs-y := \
	/bin \
	/lib \
	/sbin \
	/usr/bin \
	/usr/sbin

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
