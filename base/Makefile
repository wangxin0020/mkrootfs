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

# Nothing to build
compile: ;

# Installing stuff
devices:
	$(mkr-pkgdir)/mkdevices.sh "$(mkr-staging)" < $(dev_txt)

# FIXME: needs fakeroot
dirs:
	for d in $(DIRS); do mkdir -p "$(mkr-staging)/$$d"; done
	chmod a+rwx+t "$(mkr-staging)/tmp"

skel:
	cd $(skeldir) && { \
		find . -! -type d | while read f; do { \
			install -D $$f "$(mkr-staging)/$$f"; \
			sed -i \
			's/@MKR_SERIAL_DEV@/'$(MKR_SERIAL_DEV)'/g;s/@MKR_SERIAL_BAUDRATE@/$(MKR_SERIAL_BAUDRATE)/g' \
		"$(mkr-staging)/$$f"; \
		}; \
		done; \
		install -D /etc/localtime "$(mkr-staging)/etc/localtime" || :; \
	}

staging: devices dirs skel

# Checking configuration
confcheck-y := $(call confcheck-exists,$(dev_txt),MKR_BOARD)
confcheck-y += $(call confcheck-exists,$(skeldir),MKR_BOARD)

confcheck: default-confcheck
