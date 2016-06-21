configure-args-$(call not, $(MKR_DIALOG_WIDEC)) += \
	ac_cv_prog_NCURSES_CONFIG=$(staging)/usr/bin/ncurses6-config \
	--with-ncurses

configure-args-$(MKR_DIALOG_WIDEC) += \
	ac_cv_prog_NCURSES_CONFIG=$(staging)/usr/bin/ncursesw6-config \
	--with-ncursesw \
	--enable-widec

rootfs-y := /usr/bin/dialog

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
