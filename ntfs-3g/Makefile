compile-$(call not, $(MKR_NTFS32)) := default-autotools-compile
config-$(call not, $(MKR_NTFS32)) := configure
lib-$(call not, $(MKR_NTFS32)) := lib
compile-$(MKR_NTFS32) := default-autotools-compile32
config-$(MKR_NTFS32) := configure32
lib-$(MKR_NTFS32) := lib32

$(config-y)-args-y += \
	--disable-ldconfig \
	--enable-posix-acls \
	--enable-xattr-mappings \
	--enable-extras \
	--with-fuse=external \
	--with-uuid \
	--with-hd

rootfs-y := \
	/bin/lowntfs-3g \
	/bin/ntfs-3g \
	/$(lib-y)/libntfs-3g.so.* \
	/sbin/mkfs.ntfs \
	/sbin/mount.lowntfs-3g \
	/sbin/mount.ntfs-3g \
	/usr/bin/ntfs-3g.probe \
	/usr/bin/ntfs-3g.secaudit \
	/usr/bin/ntfs-3g.usermap \
	/usr/bin/ntfscat \
	/usr/bin/ntfsck \
	/usr/bin/ntfscluster \
	/usr/bin/ntfscmp \
	/usr/bin/ntfsdump_logfile \
	/usr/bin/ntfsfix \
	/usr/bin/ntfsinfo \
	/usr/bin/ntfsls \
	/usr/bin/ntfsmftalloc \
	/usr/bin/ntfsmove \
	/usr/bin/ntfstruncate \
	/usr/bin/ntfswipe \
	/usr/sbin/mkntfs \
	/usr/sbin/ntfsclone \
	/usr/sbin/ntfscp \
	/usr/sbin/ntfslabel \
	/usr/sbin/ntfsresize \
	/usr/sbin/ntfsundelete

compile: $(compile-y)

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
