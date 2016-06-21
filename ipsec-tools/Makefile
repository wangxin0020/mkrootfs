rootfs-y +=					\
	/usr/sbin/plainrsa-gen			\
	/usr/sbin/racoon			\
	/usr/sbin/racoonctl			\
	/usr/sbin/setkey

LINUX_HEADERS := $(shell echo '\#include <linux/types.h>' | $(CC) -x c -E -M /dev/stdin | sed 's,^.* \([^ ]*\)/linux/types.h.*$$,\1,;t;d' )

configure-args-y += \
	--enable-hybrid \
	--enable-frag \
	--enable-stats \
	--enable-dpd \
	--enable-natt \
	--disable-security-context \
	--with-kernel-headers=$(LINUX_HEADERS) \
	--without-readline \
	--with-openssl=$(staging)/usr

# Force link to mkrootfs readline. This way, configure believes it is
# cross-compiling even if the host architecture is the same as the build
# architecture
ldflags-y += -lreadline -lncurses

cppflags-y += -D_GNU_SOURCE

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
