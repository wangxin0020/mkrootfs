confcheck-y += $(call confcheck-if, \
	test "$(CONFIG_PACKET)" != "y", \
	libpcap requires CONFIG_PACKET in kernel configuration.)

configure-args-y += \
	--with-pcap=linux \
	--without-libnl \
	--disable-bluetooth \
	--disable-canusb \
	--disable-can \
	--disable-dbus

rootfs-y += /usr/lib/libpcap.so.*

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean

confcheck: default-confcheck
