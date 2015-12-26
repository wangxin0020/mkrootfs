configure-args-y := \
	--host="$(MKR_CONFIGURE_HOST)" \
	--build=x86_64-unknown-linux-gnu \
	--prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--with-sysroot="$(staging)" \
	--disable-strip \
	--disable-etc-default-login \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-pututline \
	--disable-pututxline \
	--without-ssh1 \
	--with-zlib=$(staging)/usr \
	--with-ssl-dir=$(staging)/usr \
	--with-ssl-engine \
	--with-privsep-user=nobody \
	--without-shadow \
	--with-4in6 \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)gcc" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

rootfs-y += \
	/etc/moduli \
	/etc/ssh_config \
	/etc/sshd_config \
	/usr/bin/scp \
	/usr/bin/sftp \
	/usr/bin/slogin \
	/usr/bin/ssh \
	/usr/bin/ssh-add \
	/usr/bin/ssh-agent \
	/usr/bin/ssh-keygen \
	/usr/bin/ssh-keyscan \
	/usr/libexec/sftp-server \
	/usr/libexec/ssh-keysign \
	/usr/libexec/ssh-pkcs11-helper \
	/usr/sbin/sshd

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
