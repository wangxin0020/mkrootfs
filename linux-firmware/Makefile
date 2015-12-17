fwdir:=bins

force-$(MKR_LINUX_FW_UPDATE) = FORCE

.PHONY: FORCE

$(fwdir):
	git clone $(MKR_LINUX_FW_REPO) $@

refresh: $(fwdir) $(force-y)
	cd $< && git pull
	: > $@

compile: refresh

staging:
	cd $(fwdir) && find . -name .git -prune -o -type f -print | while read f; do \
		install -D $$f $(pkginst)/lib/firmware/$$f; \
	done

rootfs: default-copyall-rootfs

clean:
	-mv $(fwdir) $(fwdir).removed
	-$(RM) -R $(fwdir).removed
