configure-args-y += \
	bash_cv_func_sigsetjmp=yes \
	bash_cv_wcwidth_broken=no \
	--libdir=/lib \
	--disable-static \
	--enable-multibyte \
	--with-curses

rootfs-y += \
	/lib/libhistory.so* \
	/lib/libreadline.so*

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
