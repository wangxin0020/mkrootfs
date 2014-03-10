configure-args-y += \
	--without-xen

configure-args-$(MKR_KEXEC_ZLIB) += --with-zlib
configure-args-$(call not, $(MKR_KEXEC_ZLIB)) += --without-zlib

configure-args-$(MKR_KEXEC_LZMA) += --with-lzma
configure-args-$(call not, $(MKR_KEXEC_LZMA)) += --without-lzma

rootfs-y := /usr/sbin/kexec
rootfs-$(MKR_KEXEC_TOOLS_KDUMP) += /usr/sbin/kdump

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
