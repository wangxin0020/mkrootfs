configure-args-y += \
	ac_cv_prog_ncursesw5_config=no \
	ac_cv_prog_ncurses5_config=no \
	--disable-xmlto

configure-args-$(MKR_ALSA_UTILS_ALSAMIXER) += --enable-alsamixer
configure-args-$(call not,$(MKR_ALSA_UTILS_ALSAMIXER)) += --disable-alsamixer

rootfs-y := \
	/usr/bin/aconnect \
	/usr/bin/alsaloop \
	/usr/bin/alsamixer \
	/usr/bin/alsaucm \
	/usr/bin/amidi \
	/usr/bin/amixer \
	/usr/bin/aplay \
	/usr/bin/aplaymidi \
	/usr/bin/arecord \
	/usr/bin/arecordmidi \
	/usr/bin/aseqdump \
	/usr/bin/aseqnet \
	/usr/bin/iecset \
	/usr/bin/speaker-test \
	/usr/sbin/alsaconf \
	/usr/sbin/alsactl

$(mkr-configured): $(default-autotools-configured)

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
