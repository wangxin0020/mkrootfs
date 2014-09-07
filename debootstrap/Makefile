Makefile: $(srcdir)/Makefile $(deps)
	rm -Rf * || :
	sed 's,srcdir=\.,srcdir=$(srcdir),g' $< > $@

compile: Makefile

staging: default-autotools-staging

rootfs: default-copyall-rootfs

clean: default-clean
