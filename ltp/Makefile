# Do not use distcc when compiling LTP as it actually slows down the
# compilation
LTP_PATH=$(shell echo $$PATH | sed 's/[^:]*distcc://g')

sync-$(call not,$(MKR_LTP_MAINT)) := cp -a
sync-$(MKR_LTP_MAINT) := rsync -a

create-stamp := $(mkr-staging)/ltp/.mkr.dir-created

$(create-stamp): $(mkr-deps)
	rm -Rf $(dir $@)
	mkdir -p $(dir $@)
	: > $@

# Sync the sources between the source tree and the staging directory
# In maintainer mode, trigger a sync for every compilation
ifeq ($(MKR_LTP_MAINT),y)
do-sync: $(create-stamp)
	$(sync-y) $(mkr-srcdir)/* $(mkr-staging)/ltp

$(mkr-staging)/ltp/configure: do-sync ;

mkt-configure-args-y += --enable-maintainer-mode
else
$(mkr-staging)/ltp/configure: $(create-stamp)
	$(sync-y) $(mkr-srcdir)/* $(mkr-staging)/ltp
endif

compile: ;

# Configure
$(mkr-staging)/ltp/config.status: $(mkr-staging)/ltp/configure
	cd $(dir $@) && ./configure $(mkr-configure-args-y)

# Build & install
staging: $(mkr-staging)/ltp/config.status
	cd $(mkr-staging)/ltp && PATH=$(LTP_PATH) $(MAKE) \
	CROSS_COMPILE="$(mkr-cross)" \
	CC="$(CC) $(cflags-y)" CXX="$(CXX) $(cflags-y)"
	for dir in \
		testcases/bin \
		testcases/kernel/io/stress_floppy/dumpdir \
		testcases/bin/dumpdir \
		output \
		results; \
	do mkdir -p $(mkr-staging)/ltp/$$dir || exit 1; done

rootfs: default-copyall-rootfs

confcheck-$(MKR_LTP_MAINT) := $(call confcheck-tool,rsync,MKR_LTP_MAINT)

confcheck: default-confcheck
