compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" CFLAGS="$(cflags-y)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += PREFIX=/usr

$(CURDIR)/Makefile: $(srcdir)/Makefile $(deps)
	sed 's,VPATH = src,VPATH = $(srcdir)/src,' $< > $@
	$(MAKE) clean

$(mkr-configured): $(CURDIR)/Makefile

compile:
	$(MAKE) $(compile-make-args-y)

staging:
	$(MAKE) $(staging-make-args-y) DESTDIR=$(pkginst) install-bin

rootfs: default-copyall-rootfs

clean: default-clean
