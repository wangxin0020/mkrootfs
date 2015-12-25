configure-args-y += \
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

configure-args-$(MKR_NCURSES_WIDEC) += --enable-widec

rootfs-y := \
	/usr/share/terminfo/*/* \
	/usr/share/tabset/* \
	/usr/lib/terminfo \
	/usr/lib/libncurses.so.* \
	/usr/lib/libtinfo.so.* \
	/usr/lib/libtic.so.*

rootfs-$(MKR_NCURSES_WIDEC) += /usr/lib/libncursesw.so.*

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
