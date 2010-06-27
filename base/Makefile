boarddir := $(srctree)/boards/$(MKR_BOARD)
dev_txt := $(boarddir)/dev.txt
skeldir := $(boarddir)/skel

DIRS= \
	/proc \
	/sys \
	/tmp \
	/etc/init.d \
	/root \
	/var \
	/mnt

# Installing stuff
devices:
	 $(mkr-pkgdir)/mkdevices.sh $(MKR_STAGING) < $(dev_txt)

dirs:
	for d in $(DIRS); do mkdir -p $(MKR_STAGING)/$$d; done
	chmod a+rwx+t $(MKR_STAGING)/tmp

skel:
	cd $(skeldir) && { \
		find . -! -type d | while read f; do { \
			mkdir -p $(MKR_STAGING)/`dirname $$f`; \
			cp -a $$f $(MKR_STAGING)/$$f; \
			sed -i \
			's/@MKR_SERIAL_DEV@/'$(MKR_SERIAL_DEV)'/g;s/@MKR_SERIAL_BAUDRATE@/$(MKR_SERIAL_BAUDRATE)/g' \
		$(MKR_STAGING)/$$f; \
		}; \
		done; \
		cp -a /etc/localtime $(MKR_STAGING)/etc/localtime || :; \
	}

staging: devices dirs skel

# Checking configuration
confcheck-y := $(call confcheck-exists,$(dev_txt),MKR_BOARD)
confcheck-y += $(call confcheck-exists,$(skeldir),MKR_BOARD)

confcheck: default-confcheck
