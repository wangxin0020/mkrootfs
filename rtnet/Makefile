configure-env-y += \
	DESTDIR=$(staging)

krelease = $(shell cat $(staging)/../linux/include/config/kernel.release)
moddir = /lib/modules/$(krelease)/extra/rtnet

configure-args-y += \
	--enable-ethpall \
	--enable-rtipv4 \
	--enable-icmp \
	--enable-udp \
	--enable-tcp \
	--enable-net-routing \
	--enable-rtpacket \
	--enable-nomac \
	--enable-tdma \
	--enable-rtcap \
	--enable-proxy \
	--enable-examples \
	--enable-multicast \
	--enable-vlan \
	--with-linux=$(staging)/../linux \
	--with-module-dir=$(moddir) \
	--with-rtext-config=$(staging)/usr/bin/xeno-config

configure-args-$(MKR_ARCH_X86_32) += \
	--enable-eepro100 \
	--enable-r8169 \
	--enable-e1000-new \
	--enable-e1000e \
	--enable-igb

configure-args-$(MKR_ARCH_X86_64) += \
	--enable-eepro100 \
	--enable-r8169 \
	--enable-e1000-new \
	--enable-e1000e \
	--enable-igb

configure-args-$(MKR_ARCH_ARM) += \
	--enable-macb

rootfs-y := \
	/usr/etc/rtnet.conf \
	/usr/etc/tdma.conf \
	/usr/sbin/nomaccfg \
	/usr/sbin/rtcfg \
	/usr/sbin/rtifconfig \
	/usr/sbin/rtiwconfig \
	/usr/sbin/rtifupdown.sh \
	/usr/sbin/rtnet \
	/usr/sbin/rtping \
	/usr/sbin/rtroute \
	/usr/sbin/tdmacfg \
	/usr/sbin/rtvconfig \
	$(moddir)/* \
	$(moddir)/examples/xenomai/native/* \
	$(moddir)/examples/xenomai/posix/* \
	/usr/examples/generic/* \
	/usr/examples/xenomai/native/* \
	/usr/examples/xenomai/posix/* \
	/etc/default/rtnet.example

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
