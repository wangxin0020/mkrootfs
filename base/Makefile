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
	$(pkgdir)/mkdevices.sh "$(pkginst)" < $(dev_txt)

dirs:
	for d in $(DIRS); do mkdir -p "$(pkginst)/$$d"; done
	chmod a+rwx+t "$(pkginst)/tmp"

skel:
	cd $(skeldir) && { \
		find . -! -type d -! -name '*~' | while read f; do { \
			install -D $$f "$(pkginst)/$$f"; \
			sed -i \
			's/@MKR_SERIAL_DEV@/'$(MKR_SERIAL_DEV)'/g;s/@MKR_SERIAL_BAUDRATE@/$(MKR_SERIAL_BAUDRATE)/g' \
		"$(pkginst)/$$f"; \
		}; \
		done; \
		install -D /etc/localtime "$(pkginst)/etc/localtime" || :; \
	}

staging: devices dirs skel

rootfs: default-copyall-rootfs

# Cleaning: nothing to do
clean: ;

# Checking configuration
confcheck-y := $(call confcheck-exists,$(dev_txt),MKR_BOARD)
confcheck-y += $(call confcheck-exists,$(skeldir),MKR_BOARD)
confcheck-$(MKR_OUT_NFS) += $(call confcheck-if, \
		test "$(CONFIG_ROOT_NFS)" != "y", \
		NFS root selected but not enabled in kernel configuration.)

confcheck: default-confcheck
