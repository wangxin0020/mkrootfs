DEVLIBNAME=libtomcrypt.so
LIBNAME=$(DEVLIBNAME).0

cflags-y += -fPIC -DPIC -I$(srcdir) -I. -I$(srcdir)/src/headers \
	-DLTC_SOURCE -DLTM_DESC

compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" CFLAGS="$(cflags-y)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += \
	PREFIX=/usr INSTALL_GROUP=root INSTALL_USER=root NODOCS=yes \
	AR="$(CC)" ARFLAGS="$(ldflags-y) -shared -Wl,-soname,$(LIBNAME) -o" \
	LIBNAME=$(LIBNAME) RANLIB=":"

rootfs-y := /usr/lib/$(LIBNAME)

$(CURDIR)/.mkr.makefile.ready: $(srcdir)/makefile $(deps)
	rm -f $@
	{ \
		echo srcdir = $(srcdir); \
		echo VPATH = $$\(srcdir\); \
		sed 's#$$(HEADERS)#$$\(patsubst %,$$\(srcdir\)/%,$$\(HEADERS\)\)#g;s#-I\.#-I$(srcdir)#g' $<; \
	} > $(CURDIR)/Makefile
	{  \
		cd $(srcdir); find src -type d; \
	} | while read d; do mkdir -p $(CURDIR)/$$d; done
	: > $@

compile: $(CURDIR)/.mkr.makefile.ready $(deps)
	$(MAKE) $(compile-make-args-y)

staging:
	$(MAKE) $(staging-make-args-y) DESTDIR=$(pkginst) install
	ln -s $(LIBNAME) $(pkginst)/usr/lib/$(DEVLIBNAME)

rootfs: default-rootfs

clean: default-clean