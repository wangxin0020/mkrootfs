rootfs-y += \
	/etc/ssl/cert.pem \
	/etc/ssl/x509v3.cnf \
	/usr/lib/libcrypto.so.* \
	/usr/lib/libssl.so.* \
	/usr/lib/libtls.so.*

rootfs-$(MKR_LIBRESSL_OPENSSL) += \
	/etc/ssl/openssl.cnf \
	/usr/bin/openssl

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
