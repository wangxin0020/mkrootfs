configure-args-y += \
	--enable-8139 \
	--enable-eepro100 \
	--enable-pcnet32 \
	--enable-via-rhine \
	--enable-natsemi \
	--enable-tulip \
	--enable-smc91111 \
	--enable-loopback \
	--enable-3c59x \
	--enable-r8169 \
	--enable-rt2500 \
	--enable-e1000-new \
	--enable-e1000e \
	--enable-igb \
	--enable-ethpall \
	--enable-rtwlan \
	--enable-rtipv4 \
	--enable-icmp \
	--enable-udp \
	--enable-tcp \
	--enable-net-routing \
	--enable-router \
	--enable-rtpacket \
	--enable-rtcfg \
	--enable-rtmac \
	--enable-tdma \
	--enable-tdma-master \
	--enable-nomac \
	--enable-rtcap \
	--enable-proxy \
	--enable-proxy-arp \
	--with-linux=$(staging)/../linux \
	--with-module-dir=/lib/modules/rtnet

rootfs-y := \
	/usr/etc/rtnet.conf \
	/usr/etc/tdma.conf \
	/usr/sbin/nomaccfg \
	/usr/sbin/rtcfg \
	/usr/sbin/rtifconfig \
	/usr/sbin/rtiwconfig \
	/usr/sbin/rtnet \
	/usr/sbin/rtping \
	/usr/sbin/rtroute \
	/usr/sbin/tdmacfg \
	/lib/modules/rtnet

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
