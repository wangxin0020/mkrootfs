configure-args-y += \
	--enable-symlink-build \
	--enable-symlink-install \
	--enable-relative-symlinks \
	--enable-fsck \
	--disable-nls

rootfs-y += \
	/usr/bin/chattr \
	/usr/bin/lsattr \
	/usr/bin/uuidgen \
	/usr/etc/mke2fs.conf \
	/usr/lib/e2initrd_helper \
	/usr/sbin/badblocks \
	/usr/sbin/blkid \
	/usr/sbin/debugfs \
	/usr/sbin/dumpe2fs \
	/usr/sbin/e2freefrag \
	/usr/sbin/e2fsck \
	/usr/sbin/e2image \
	/usr/sbin/e2label \
	/usr/sbin/e2undo \
	/usr/sbin/e4defrag \
	/usr/sbin/filefrag \
	/usr/sbin/findfs \
	/usr/sbin/fsck \
	/usr/sbin/fsck.ext2 \
	/usr/sbin/fsck.ext3 \
	/usr/sbin/fsck.ext4 \
	/usr/sbin/fsck.ext4dev \
	/usr/sbin/logsave \
	/usr/sbin/mke2fs \
	/usr/sbin/mkfs.ext2 \
	/usr/sbin/mkfs.ext3 \
	/usr/sbin/mkfs.ext4 \
	/usr/sbin/mkfs.ext4dev \
	/usr/sbin/mklost+found \
	/usr/sbin/resize2fs \
	/usr/sbin/tune2fs \
	/usr/sbin/uuidd

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
