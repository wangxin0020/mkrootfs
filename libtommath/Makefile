DEVLIBNAME=libtommath.so
LIBNAME=$(DEVLIBNAME).0

cflags-y += -I$(srcdir) -I. -fPIC -DPIC

compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" CFLAGS="$(cflags-y)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += \
	PREFIX=/usr INSTALL_GROUP=root INSTALL_USER=root \
	AR="$(CC)" ARFLAGS="$(ldflags-y) -shared -Wl,-soname,$(LIBNAME) -o" LIBNAME=$(LIBNAME)

rootfs-y := /usr/lib/$(LIBNAME)

$(CURDIR)/.mkr.makefile.ready: $(srcdir)/makefile $(deps) $(pkgdir)/Makefile
	rm -f $@
	{ \
		echo srcdir = $(srcdir); \
		echo VPATH = $$\(srcdir\); \
		sed 's#$$(HEADERS)#$$\(patsubst %,$$\(srcdir\)/%,$$\(HEADERS\)\)#g;/ranlib/d' $<; \
	} > $(CURDIR)/Makefile
	mkdir -p $(CURDIR)/etc $(CURDIR)/pics
	echo clean: > $(CURDIR)/etc/Makefile
	echo clean: > $(CURDIR)/pics/Makefile
	: > $@

compile: $(CURDIR)/.mkr.makefile.ready $(deps)
	$(MAKE) $(compile-make-args-y)

staging:
	$(MAKE) $(staging-make-args-y) DESTDIR=$(pkginst) install
	ln -s $(LIBNAME) $(pkginst)/usr/lib/$(DEVLIBNAME)

rootfs: default-rootfs

clean: default-clean $(CURDIR)/Makefile
