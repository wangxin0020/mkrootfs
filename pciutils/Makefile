rootfs-y += \
	/usr/lib/libpci.so.* \
	/usr/sbin/lspci \
	/usr/sbin/setpci \
	/usr/sbin/update-pciids \
	/usr/share/pci.ids* \

cflags-y += -Wall -W -Wno-parentheses -Wstrict-prototypes -Wmissing-prototypes \
	-I$(PWD)/pciutils/lib -DWITH_GZFILEOP -fPIC

compile-make-args-y := \
	SHARED=yes PREFIX=/usr LIBKMOD=no HWDB=no \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

compile-make-args-$(MKR_PCIUTILS_ZLIB) += ZLIB=yes
compile-make-args-$(call not,$(MKR_PCIUTILS_ZLIB)) += ZLIB=no

staging-make-args-y += SHARED=yes PREFIX=/usr install-lib

staging-make-args-$(MKR_PCIUTILS_ZLIB) += ZLIB=yes
staging-make-args-$(call not,$(MKR_PCIUTILS_ZLIB)) += ZLIB=no

Makefile: $(srcdir)/Makefile $(deps)
	echo "VPATH=$(srcdir)" > $@
	sed "s#\./configure#$(srcdir)/lib/configure#;s#-m 644 \$$(PCIINC_INS)#-m 644 \$$(filter %.h,\$$^)#;s#install: all#install: \$$(PCI_IDS) all#;s#-m 644 \$$(PCI_IDS)#$$<#" $< >> $@

lib/Makefile: $(srcdir)/lib/Makefile
	mkdir -p lib
	echo "VPATH=$(srcdir)/lib" > $@
	sed "s#=libpci\.ver#=$(srcdir)/lib/libpci.ver#" $< >> $@

.makefiles.ready: Makefile lib/Makefile
	$(MAKE) clean
	: > $@

$(mkr-configured): .makefiles.ready

compile: lib/Makefile
	$(configure-env-y) $(MAKE) $(compile-make-args-y)

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_PCI)", \
	pciutils require CONFIG_PCI in kernel configuration)

confcheck: default-confcheck
