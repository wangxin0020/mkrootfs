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

# Compiling: nothing to do
compile: ;

# Installing stuff
devices:
	$(mkr-pkgdir)/mkdevices.sh "$(mkr-pkginst)" < $(dev_txt)

dirs:
	for d in $(DIRS); do mkdir -p "$(mkr-pkginst)/$$d"; done
	chmod a+rwx+t "$(mkr-pkginst)/tmp"

skel:
	cd $(skeldir) && { \
		find . -! -type d -! -name '*~' | while read f; do { \
			install -D $$f "$(mkr-pkginst)/$$f"; \
			sed -i \
			's/@MKR_SERIAL_DEV@/'$(MKR_SERIAL_DEV)'/g;s/@MKR_SERIAL_BAUDRATE@/$(MKR_SERIAL_BAUDRATE)/g' \
		"$(mkr-pkginst)/$$f"; \
		}; \
		done; \
		install -D /etc/localtime "$(mkr-pkginst)/etc/localtime" || :; \
	}

staging: devices dirs skel

# Checking configuration
confcheck-y := $(call confcheck-exists,$(dev_txt),MKR_BOARD)
confcheck-y += $(call confcheck-exists,$(skeldir),MKR_BOARD)

confcheck: default-confcheck
