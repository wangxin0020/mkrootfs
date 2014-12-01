cflags-y += -I$(srcdir) -I.

compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += \
	PREFIX=/usr BINDIR=/usr/sbin

rootfs-y := \
	/usr/sbin/wpa_cli \
	/usr/sbin/wpa_passphrase \
	/usr/sbin/wpa_supplicant

$(CURDIR)/wpa_supplicant/Makefile: $(srcdir)/wpa_supplicant/Makefile $(pkgdir)/Makefile $(deps)
	mkdir -p src
	{ cd $(srcdir); find src wpa_supplicant -name Makefile; } | \
	while read f; do \
		mkdir -p `dirname $$f`; \
		{ \
			echo srcdir=$(srcdir)/`dirname $$f`; \
			echo VPATH=$$\(srcdir\); \
			echo CFLAGS=$(cflags-y); \
			sed 's,include \.\.,include $$\(srcdir\)/..,' $(srcdir)/$$f; \
		} > $$f; \
	done
	mkdir -p wpa_supplicant/systemd

$(CURDIR)/wpa_supplicant/.config: $(CURDIR)/wpa_supplicant/Makefile
	rm -f $@
	$(MAKE) -C $(CURDIR)/wpa_supplicant mkconfig
	echo CONFIG_TLS=internal >> $@
	echo CONFIG_EAP_TLS=yes >> $@
	echo CONFIG_WPS=yes >> $@

compile: $(CURDIR)/wpa_supplicant/.config
	$(MAKE) -C $(CURDIR)/wpa_supplicant $(compile-make-args-y)

staging:
	$(MAKE) -C $(CURDIR)/wpa_supplicant $(staging-make-args-y) DESTDIR=$(pkginst) install

rootfs: default-rootfs

clean: default-clean
