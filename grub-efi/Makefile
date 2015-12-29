INSTALL:=install -m 0644 -D

isobootdir := $(staging)/../boot.iso.d

rootfs-y :=

bootx64.efi: $(pkgdir)/Makefile $(deps) $(pkgdir)/mkefi.sh $(pkgdir)/grub-standalone.cfg
	$(pkgdir)/mkefi.sh $(pkgdir) $(srcdir) `pwd`

efiboot.img: bootx64.efi
	CYL=$$(((`du -b $< | awk '{ print $$1 }'` + 32767) / 16384)) && \
	dd if=/dev/zero of=$@.tmp bs=16384 count=$$CYL && \
	mformat -i $@.tmp -t $$CYL -s 32 -h 1
	mmd -i $@.tmp ::EFI ::EFI/Boot
	mcopy -i $@.tmp $< ::EFI/Boot/bootx64.efi
	mv $@.tmp $@

compile: bootx64.efi efiboot.img

staging:
	$(INSTALL) efiboot.img $(isobootdir)/isolinux/efiboot.img
	$(INSTALL) bootx64.efi $(isobootdir)/EFI/Boot/bootx64.efi
	$(INSTALL) $(pkgdir)/grub.cfg $(isobootdir)/boot/grub/grub.cfg
	$(INSTALL) -d $(isobootdir)/boot/grub/x86_64-efi
	$(INSTALL) $(srcdir)/*.mod $(isobootdir)/boot/grub/x86_64-efi
	$(INSTALL) $(srcdir)/*.lst $(isobootdir)/boot/grub/x86_64-efi
	$(INSTALL) $(pkgdir)/dejavusansmono.pf2 $(isobootdir)/boot/grub

rootfs:

clean:
	$(RM) -r bootx64.efi efiboot.img $(isobootdir)/boot \
		$(isobootdir)/EFI $(isobootdir)/isolinux/efiboot.img

confcheck-$(MKR_GRUB_EFI) += \
	$(call confcheck-tool-var,grub-mkimage,GRUB_EFI) \
	$(call confcheck-tool-var,mtools,GRUB_EFI)

confcheck: default-confcheck
