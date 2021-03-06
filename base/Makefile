skeldir := $(srcdir)/skel

DIRS= \
	/dev \
	/proc \
	/sys \
	/tmp \
	/etc/init.d \
	/root \
	/var \
	/mnt

vars-subst := \
	sed -e 's,@MKR_SWAP_DEV@,$(MKR_SWAP_DEV),g' \
	  -e 's,@MKR_SECURE_NETWORK@,$(if $(MKR_SECURE_NETWORK),true,false),g' \
	  -e 's,@MKR_BASE_SHELL@,$(MKR_BASE_SHELL),g'

$(mkr-configured): $(deps)

# Compiling: nothing to do
compile: ;

# Installing stuff
dirs:
	for d in $(DIRS); do mkdir -p "$(pkginst)/$$d"; done
	chmod a+rwx+t "$(pkginst)/tmp" "$(pkginst)/root"

skel:
	cd $(skeldir) && { \
		find . -! -type d -! -name '*~' | while read f; do { \
			mkdir -p `dirname $(pkginst)/$$f`; \
			$(vars-subst) $$f > "$(pkginst)/$$f"; \
			chmod --reference="$$f" "$(pkginst)/$$f"; \
		}; \
		done; \
		cp -L --preserve=mode,timestamps /etc/localtime "$(pkginst)/etc/localtime" || :; \
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

staging-y := dirs skel
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
