rootfs-y += \
	/usr/lib/libip4tc.so.* \
	/usr/lib/libip6tc.so.* \
	/usr/lib/libiptc.so.* \
	/usr/lib/libxtables.so.* \
	/usr/lib/xtables/*.so \
	/usr/sbin/arptables-compat \
	/usr/sbin/ebtables-compat \
	/usr/sbin/ip6tables* \
	/usr/sbin/iptables* \
	/usr/sbin/xtables*

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
