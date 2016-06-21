configure-args-y += \
	--libdir=/lib \
	--with-shared \
	--without-progs \
	--without-manpages \
	--without-ada \
	--without-gpm \
	--without-termlib \
	--enable-termcap \
	--enable-pc-files \
	--enable-tcap-names \
	--enable-hard-tabs

configure-args-$(MKR_NCURSES_WIDEC) += \
	--enable-widec

rootfs-y := \
	/usr/share/tabset/* \
	/lib/terminfo \
	/lib/libncurses.so.*

rootfs-$(call not,$(MKR_FULL_TERMINFO)) += \
	/usr/share/terminfo/l/* \
	/usr/share/terminfo/v/* \
	/usr/share/terminfo/x/*

rootfs-$(MKR_FULL_TERMINFO) += \
	/usr/share/terminfo/*/*

rootfs-$(MKR_NCURSES_WIDEC) += \
	/lib/libncursesw.so.*

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
