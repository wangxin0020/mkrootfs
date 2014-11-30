cflags-y += -I$(srcdir) -I.

compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" CFLAGS="$(cflags-y)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += \
	PREFIX=/usr

rootfs-y := \
	/usr/lib/libiw.so.* \
	/usr/sbin/ifrename \
	/usr/sbin/iwconfig \
	/usr/sbin/iwevent \
	/usr/sbin/iwgetid \
	/usr/sbin/iwlist \
	/usr/sbin/iwpriv \
	/usr/sbin/iwspy

$(CURDIR)/Makefile: $(srcdir)/Makefile
	sed 's,srcdir = .,srcdir = $(srcdir),' $< > $@

compile: $(CURDIR)/Makefile $(deps)
	$(MAKE) $(compile-make-args-y)

staging:
	$(MAKE) $(staging-make-args-y) DESTDIR=$(pkginst) install-dynamic install-bin install-hdr

rootfs: default-rootfs

clean: default-clean
