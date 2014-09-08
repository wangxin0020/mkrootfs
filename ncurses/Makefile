configure-args-y += \
	--with-shared \
	--without-progs \
	--without-manpages

rootfs-y := \
	/usr/share/terminfo/*/* \
	/usr/lib/libncurses.so.*

compile: default-autotools-compile

staging: default-autotools-staging
	@cd $(pkginst)/usr/lib; \
	for lib in libncurses.so*; do \
		ln -sf $$lib `echo $$lib | sed -e 's,ncurses,tinfo,'`; \
	done

rootfs: default-rootfs

clean: default-clean
