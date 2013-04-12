compile: default-autotools-compile

staging: default-autotools-staging
	@cd $(pkginst)/usr/lib; \
	for lib in libncurses.so*; do \
		ln -s $$lib `echo $$lib | sed -e 's,ncurses,tinfo,'`; \
	done

rootfs-y := /usr/lib/libncurses.so.*

configure-args-y += --with-shared --without-manpages

rootfs: default-rootfs

clean: default-clean
