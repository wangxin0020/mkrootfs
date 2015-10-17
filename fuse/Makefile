compile-$(call not, $(MKR_FUSE32)) := default-autotools-compile
config-$(call not, $(MKR_FUSE32)) := configure
lib-$(call not, $(MKR_FUSE32)) := lib
compile-$(MKR_FUSE32) := default-autotools-compile32
config-$(MKR_FUSE32) := configure32
lib-$(MKR_FUSE32) := lib32

compile: $(compile-y)

staging: default-autotools-staging

rootfs-y := \
	/dev/fuse \
	/sbin/mount.fuse \
	/usr/bin/fusermount \
	/usr/bin/ulockmgr_server \
	/usr/$(lib-y)/libfuse.so.* \
	/usr/$(lib-y)/libulockmgr.so.*

$(config-y)-args-y += --with-shared --disable-example

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_FUSE_FS)", \
	Fuse needs CONFIG_FUSE_FS in kernel configuration)

confcheck: default-confcheck
