staging-make-args-y +=							       \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar"		       \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib"	       \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

Makefile: $(srcdir)/Makefile $(deps)
	rm -Rf * || :
	sed 's,srcdir=\.,srcdir=$(srcdir),g' $< > $@
	$(MAKE) clean

$(mkr-configured): Makefile

compile: Makefile

staging: default-autotools-staging

rootfs: default-copyall-rootfs

clean: default-clean
