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

mount-dev-sed := \
	sed -i 's,@MKR_SWAP_DEV@,$(MKR_SWAP_DEV),g'

secure-access-sed := \
	sed -i 's,@MKR_SECURE_NETWORK@,$(if $(MKR_SECURE_NETWORK),true,false),g'

# Compiling: nothing to do
compile: ;

# Installing stuff
devices:
	$(pkgdir)/mkdevices.sh "$(pkginst)" < $(dev_txt)

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
		cp -L --preserve=mode,timestamps /etc/localtime "$(pkginst)/etc/localtime" || :; \
		$(mount-dev-sed) "$(pkginst)/sbin/mount_storage.sh"; \
		chmod a+rx "$(pkginst)/sbin/mount_storage.sh"; \
		$(secure-access-sed) "$(pkginst)/etc/init.d/rcS"; \
		chmod a+rx "$(pkginst)/etc/init.d/rcS"; \
	}

one-map:
	mkdir -p $(pkginst)/usr/share/keymaps $(pkginst)/etc
	cp -d --preserve=mode,timestamps $(pkgdir)/kmaps/$(MKR_KEYBOARD_MAP_NAME).kmap.bin.xz $(pkginst)/usr/share/keymaps
	ln -s /usr/share/keymaps/$(MKR_KEYBOARD_MAP_NAME).kmap.bin.xz $(pkginst)/etc/defkeymap.bin.xz

all-maps:
	mkdir -p $(pkginst)/usr/share/keymaps
	cp -d --preserve=mode,timestamps $(pkgdir)/kmaps/* $(pkginst)/usr/share/keymaps

chooser:
	mkdir -p $(pkginst)/usr/bin
	cp -d --preserve=mode,timestamps $(pkgdir)/keymap-chooser.sh $(pkginst)/usr/bin/keymap-chooser.sh

staging-y := devices dirs skel
staging-$(MKR_KEYBOARD_ONE_MAP) += one-map
staging-$(MKR_KEYBOARD_ALL_MAPS) += all-maps
staging-$(MKR_KEYBOARD_CHOOSER) += chooser

staging: $(staging-y)

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
