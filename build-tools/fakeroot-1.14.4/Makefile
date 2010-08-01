config.status: $(O)/.mkr.builddir
	$(srctree)/build-tools/fakeroot-1.14.4/configure \
		--prefix=$(O)/build-tools \
		CC="$(HOSTCC)" CFLAGS=-O2

$(O)/build-tools/bin/fakeroot: config.status
	$(MAKE) install
