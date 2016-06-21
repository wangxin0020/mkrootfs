configure-args-$(call not, $(MKR_FILE_ZLIB)) += \
	ac_cv_lib_z_gzopen=no

rootfs-y += \
	/usr/share/misc/magic.mgc \
	/usr/lib/libmagic.so.* \
	/usr/bin/file

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
