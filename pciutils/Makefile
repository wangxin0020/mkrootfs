rootfs-y += \
	/usr/lib/libpci.so.* \
	/usr/sbin/lspci \
	/usr/sbin/setpci \
	/usr/sbin/update-pciids \
	/usr/share/pci.ids.gz \

cflags-y += -Wall -W -Wno-parentheses -Wstrict-prototypes -Wmissing-prototypes \
	-I$(PWD)/pciutils/lib -DWITH_GZFILEOP -fPIC

compile-make-args-y := \
	SHARED=yes PREFIX=/usr LIBKMOD=no HWDB=no \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

staging-make-args-y += SHARED=yes PREFIX=/usr install-lib

Makefile: $(srcdir)/Makefile $(deps)
	echo "VPATH=$(srcdir)" > $@
	sed "s#\./configure#$(srcdir)/lib/configure#;s#-m 644 \$$(PCIINC_INS)#-m644 \$$(filter %.h,\$$^)#" $< >> $@
	mkdir -p lib
	echo "VPATH=$(srcdir)/lib" > lib/Makefile
	sed "s#=libpci\.ver#=$(srcdir)/lib/libpci.ver#" $(srcdir)/lib/Makefile >> lib/Makefile
	$(MAKE) clean

compile: Makefile
	$(configure-env-y) $(MAKE) $(compile-make-args-y)

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_PCI)", \
	pciutils require CONFIG_PCI in kernel configuration)

confcheck: default-confcheck
