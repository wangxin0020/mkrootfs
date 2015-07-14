rootfs-y :=					\
	/usr/sbin/dmsetup				\
	/usr/lib/libdevmapper.so.*

configure-args-y +=				\
	ac_cv_func_malloc_0_nonnull=yes		\
	--disable-readline			\
	--enable-pkgconfig

compile-make-args-y := device-mapper

compile: default-autotools-compile

staging:
	$(MAKE) DESTDIR=$(pkginst) install_device-mapper

rootfs: default-rootfs

clean: default-clean
