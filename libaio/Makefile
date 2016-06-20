rootfs-y += \
	/usr/lib/libaio.so.*

cflags-y += -Wall -W -Wno-parentheses -Wstrict-prototypes \
	-Werror-implicit-function-declaration \
	-nostdlib -nostartfiles -Wall -I$(srcdir)/src -fPIC

compile-make-args-y := \
	prefix='$$(DESTDIR)/usr' \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

staging-make-args-y += prefix='$$(DESTDIR)/usr'

Makefile: $(srcdir)/Makefile $(deps)
	echo "VPATH=$(srcdir)" > $@
	cat $< >> $@

src/Makefile: $(srcdir)/src/Makefile Makefile
	mkdir -p src
	echo "VPATH=$(srcdir)/src" > $@
	sed 's#libaio\.map#$(srcdir)/src/libaio.map#;s#-m 644 libaio\.h#-m 644 $(srcdir)/src/libaio.h#' $< >> $@

harness/Makefile: $(srcdir)/harness/Makefile src/Makefile
	mkdir -p harness
	echo "VPATH=$(srcdir)/src" > $@
	cat $< >> $@
	$(MAKE) clean

compile: harness/Makefile
	$(configure-env-y) $(MAKE) $(compile-make-args-y)

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
