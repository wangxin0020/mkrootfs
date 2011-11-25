dev_txt := $(srcdir)/dev.txt
skeldir := $(srcdir)/skel

DIRS= \
	/proc \
	/sys \
	/tmp \
	/etc/init.d \
	/root \
	/var \
	/mnt

ifeq ($(MKR_MOUNT),)
mount-dev-sed := \
	sed -i 's,@MKR_MOUNT_DEV@,\# /dev/null,g' "$(pkginst)/etc/fstab"; \
	sed -i 's,@MKR_MOUNT_DEV@,null \#,g'  "$(pkginst)/etc/init.d/rcS"; \
	sed -i 's,@MKR_MOUNT_DEV@,\# -null,g' "$(pkginst)/etc/mdev.conf"
else
mount-dev-sed := \
	sed -i 's,@MKR_MOUNT_DEV@,/dev/$(MKR_MOUNT_DEV),g' "$(pkginst)/etc/fstab"; \
	sed -i 's,@MKR_MOUNT_DEV@,$(MKR_MOUNT_DEV),g' "$(pkginst)/etc/init.d/rcS"; \
	sed -i 's,@MKR_MOUNT_DEV@,-$(MKR_MOUNT_DEV),g' "$(pkginst)/etc/mdev.conf"
endif

# Compiling: nothing to do
compile: ;

# Installing stuff
devices:
	$(pkgdir)/mkdevices.sh "$(pkginst)" < $(dev_txt)
ifeq ($(MKR_SERIAL_CUSTOM),y)
	echo 'crw-	$(MKR_SERIAL_MAJOR),$(MKR_SERIAL_MINOR) /dev/$(MKR_SERIAL_DEV)' | \
	$(pkgdir)/mkdevices.sh "$(pkginst)"
endif

dirs:
	for d in $(DIRS); do mkdir -p "$(pkginst)/$$d"; done
	chmod a+rwx+t "$(pkginst)/tmp" "$(pkginst)/root"

skel:
	cd $(skeldir) && { \
		find . -! -type d -! -name '*~' | while read f; do { \
			mkdir -p `dirname $(pkginst)/$$f`; \
			cp -dR --preserve=mode,timestamps $$f "$(pkginst)/$$f"; \
		}; \
		done; \
		cp -dR --preserve=mode,timestamps /etc/localtime "$(pkginst)/etc/localtime" || :; \
		sed -i \
			's/@MKR_SERIAL_DEV@/$(MKR_SERIAL_DEV)/g;s/@MKR_SERIAL_BAUDRATE@/$(MKR_SERIAL_BAUDRATE)/g' \
			"$(pkginst)/etc/inittab"; \
		$(mount-dev-sed); \
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
