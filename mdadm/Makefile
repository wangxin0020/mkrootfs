rootfs-y := /sbin/mdadm

compile-make-args-y +=							       \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar"		       \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib"	       \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

staging-make-args-y +=							       \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar"		       \
	NM="$(cross)nm" RANLIB="$(cross)ranlib"	       \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

Makefile: $(srcdir)/Makefile $(deps)
	rm -Rf * || :
	{ echo VPATH=$(srcdir); cat $<; } > $@
	$(MAKE) $(compile-make-args-y) clean

$(mkr-configured): Makefile

compile: ;

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
