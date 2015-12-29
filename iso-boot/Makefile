ISOLINUX_FILES=isolinux.bin menu.c32 ldlinux.c32 libutil.c32
INSTALL:=install -m 0644 -D

isobootdir := $(staging)/../boot.iso.d

rootfs-y :=

compile:

staging:
	$(RM) -r $(isobootdir)
	$(INSTALL) $(pkgdir)/isolinux.cfg $(isobootdir)/isolinux/isolinux.cfg
	for f in $(ISOLINUX_FILES); do \
		if test -e $(srcdir)/$$f; then \
			$(INSTALL) $(srcdir)/$$f $(isobootdir)/isolinux/$$f; \
		fi; \
	done

rootfs:

clean:
	$(RM) -r $(isobootdir)/isolinux

confcheck-$(MKR_OUT_ISO_BOOT) += $(call confcheck-ifnot,test -e $(MKR_OUT_ISO_BOOT_DIR)/isolinux.bin,isolinux binary not found. Check OUT_ISO_BOOT_DIR)
confcheck-$(MKR_OUT_ISO_BOOT) += $(call confcheck-tool-var,mkisofs,OUT_ISO_BOOT)
confcheck-$(MKR_OUT_ISO_HYBRID) += $(call confcheck-tool-var,isohybrid,OUT_ISO_HYBRID)

confcheck: default-confcheck
