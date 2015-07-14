rootfs-y :=					\
	/lib/libblkid.so.*			\
	/lib/libuuid.so.*			\
	/sbin/fsck.cramfs			\
	/sbin/mkfs.cramfs

configure-args-y +=				\
	--disable-nls				\
	--disable-libmount			\
	--disable-libsmartcols			\
	--disable-mount				\
	--disable-losetup			\
	--disable-fsck				\
	--disable-partx				\
	--disable-uuidd				\
	--disable-mountpoint			\
	--disable-fallocate			\
	--disable-unshare			\
	--disable-nsenter			\
	--disable-setpriv			\
	--disable-eject				\
	--disable-agetty			\
	--disable-minix				\
	--disable-fdformat			\
	--disable-hwclock			\
	--disable-wdctl				\
	--disable-switch_root			\
	--disable-pivot_root			\
	--disable-kill				\
	--disable-last				\
	--disable-utmpdump			\
	--disable-mesg				\
	--disable-raw				\
	--disable-rename			\
	--disable-login				\
	--disable-nologin			\
	--disable-sulogin			\
	--disable-su				\
	--disable-runuser			\
	--disable-ul				\
	--disable-more				\
	--disable-pg				\
	--disable-setterm			\
	--disable-schedutils			\
	--disable-bash-completion		\
	--disable-pylibmount			\
	--without-udev				\
	--without-ncurses			\
	--without-user				\
	--without-python

configure-args-$(call not, $(MKR_UTIL_LINUX_LIBUUID)) += --disable-libuuid
configure-args-$(call not, $(MKR_UTIL_LINUX_LIBBLKID)) += --disable-libblkid
configure-args-$(call not, $(MKR_UTIL_LINUX_CRAMFS)) += --disable-cramfs

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
