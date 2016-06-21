rootfs-y := /usr/bin/strace

configure-args-$(call not,$(MKR_STRACE_AIO)) += ac_cv_header_libaio_h=no

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
