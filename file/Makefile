configure-args-y += \
	ac_cv_lib_z_gzopen=no \
	--prefix=/usr

rootfs-y += \
	/usr/share/misc \
	/usr/lib \
	/usr/bin

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
