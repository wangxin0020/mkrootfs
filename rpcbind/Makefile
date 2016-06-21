configure-args-y += \
	--with-rpcuser=daemon --with-systemdsystemunitdir=no

rootfs-y += \
	/usr/bin/rpcbind \
	/usr/bin/rpcinfo

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
