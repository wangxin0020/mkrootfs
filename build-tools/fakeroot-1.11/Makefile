config.status:
	$(srctree)/build-tools/fakeroot-1.11/configure \
		--prefix=$(O)/build-tools \
		CC="$(HOSTCC)" CFLAGS=-O2

$(O)/build-tools/bin/fakeroot: config.status
	$(MAKE) install
