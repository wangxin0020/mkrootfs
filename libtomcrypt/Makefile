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

$(CURDIR)/Makefile: $(srcdir)/makefile $(deps)
	rm -f $@
	{ \
		echo srcdir = $(srcdir); \
		echo VPATH = $$\(srcdir\); \
		sed 's#$$(HEADERS)#$$\(patsubst %,$$\(srcdir\)/%,$$\(HEADERS\)\)#g;s#-I\.#-I$(srcdir)#g' $<; \
	} > $@
	{  \
		cd $(srcdir); find src -type d; \
	} | while read d; do mkdir -p $(CURDIR)/$$d; done
	$(MAKE) clean

$(mkr-configured): $(CURDIR)/Makefile

compile:
	$(MAKE) $(compile-make-args-y)

staging:
	$(MAKE) $(staging-make-args-y) DESTDIR=$(pkginst) install
	ln -s $(LIBNAME) $(pkginst)/usr/lib/$(DEVLIBNAME)

rootfs: default-rootfs

clean: default-clean
