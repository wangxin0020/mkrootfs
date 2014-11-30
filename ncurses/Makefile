configure-args-y += \
	--with-shared \
	--without-progs \
	--without-manpages \
	--without-ada \
	--without-gpm

rootfs-y := \
	/usr/share/terminfo/*/* \
	/usr/lib/libncurses.so.* \
	/usr/lib/libtinfo.so.*

compile: default-autotools-compile

staging: default-autotools-staging
	@cd $(pkginst)/usr/lib; \
	for lib in libncurses.so*; do \
		ln -sf $$lib `echo $$lib | sed -e 's,ncurses,tinfo,'`; \
	done

rootfs: default-rootfs

clean: default-clean
