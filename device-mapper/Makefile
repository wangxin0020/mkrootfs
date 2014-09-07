rootfs-y :=					\
	/sbin/dmsetup				\
	/lib/libdevmapper.so.*

configure-args-y +=				\
	--disable-readline			\
	--enable-pkgconfig

compile-make-args-y := device-mapper

compile: default-autotools-compile

staging:
	$(MAKE) DESTDIR=$(pkginst) install_device-mapper

rootfs: default-rootfs

clean: default-clean
