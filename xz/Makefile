configure-args-y += \
	--disable-lzmadec \
	--disable-lzmainfo \
	--disable-nls

configure-args-$(call not, $(MKR_XZ_XZ)) += \
	--disable-xz \
	--disable-xzdec \
	--disable-scripts

rootfs-y := \
	/usr/lib/liblzma.so.*
rootfs-$(MKR_XZ_XZ) += \
	/usr/bin/lzcat \
	/usr/bin/lzcmp \
	/usr/bin/lzdiff \
	/usr/bin/lzegrep \
	/usr/bin/lzfgrep \
	/usr/bin/lzgrep \
	/usr/bin/lzless \
	/usr/bin/lzma \
	/usr/bin/lzmore \
	/usr/bin/unlzma \
	/usr/bin/unxz \
	/usr/bin/xz \
	/usr/bin/xzcat \
	/usr/bin/xzcmp \
	/usr/bin/xzdec \
	/usr/bin/xzdiff \
	/usr/bin/xzegrep \
	/usr/bin/xzfgrep \
	/usr/bin/xzgrep \
	/usr/bin/xzless \
	/usr/bin/xzmore

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
