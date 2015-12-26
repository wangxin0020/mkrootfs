cflags-y += -I$(srcdir) -I.

compile-make-args-y += \
	PREFIX=/usr CC="$(CC)" LDFLAGS="$(ldflags-y)"

staging-make-args-y += \
	PREFIX=/usr BINDIR=/usr/sbin

rootfs-y := \
	/usr/sbin/wpa_cli \
	/usr/sbin/wpa_passphrase \
	/usr/sbin/wpa_supplicant

$(CURDIR)/.mkr.makefile.ready: $(srcdir)/wpa_supplicant/Makefile $(pkgdir)/Makefile $(deps)
	rm -f $@
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
	: > $@

$(CURDIR)/wpa_supplicant/.config: $(CURDIR)/.mkr.makefile.ready
	rm -f $@
	echo CONFIG_DRIVER_HOSTAP=y > $@.tmp
	echo CONFIG_DRIVER_WEXT=y >> $@.tmp
	echo CONFIG_TLS=$(MKR_WPA_SUPPLICANT_CONFIG_TLS) >> $@.tmp
	echo CONFIG_TLSV12=y >> $@.tmp
	echo CONFIG_EAP_TLS=y >> $@.tmp
	echo CONFIG_EAP_FAST=y >> $@.tmp
	echo CONFIG_WPS=yes >> $@.tmp
	mv $@.tmp $@

compile: $(CURDIR)/wpa_supplicant/.config
	$(MAKE) -C $(CURDIR)/wpa_supplicant $(compile-make-args-y)

staging:
	$(MAKE) -C $(CURDIR)/wpa_supplicant $(staging-make-args-y) DESTDIR=$(pkginst) install

rootfs: default-rootfs

clean: default-clean
