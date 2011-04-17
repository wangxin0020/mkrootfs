configure-args-y += --without-zlib --without-lzma --without-xen

compile: default-autotools-compile

staging: default-autotools-staging

rootfs-y := /usr/sbin/kexec
rootfs-$(MKR_KEXEC_TOOLS_KDUMP) += /usr/sbin/kdump

rootfs: default-rootfs

clean: default-clean
