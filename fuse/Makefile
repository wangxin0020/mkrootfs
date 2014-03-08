compile: default-autotools-compile

staging: default-autotools-staging

rootfs-y := \
	/dev/fuse \
	/usr/lib/libfuse.so.*

configure-args-y += --with-shared --disable-example

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_FUSE_FS)", \
	Fuse needs CONFIG_FUSE_FS in kernel configuration)

confcheck: default-confcheck
