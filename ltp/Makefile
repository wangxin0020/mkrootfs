# Do not use distcc when compiling LTP as it actually slows down the
# compilation
LTP_PATH=$(shell echo $$PATH | sed 's/[^:]*distcc://g')

sync-$(call not,$(MKR_LTP_MAINT)) := cp -a
sync-$(MKR_LTP_MAINT) := rsync -a

create-stamp := $(MKR_STAGING)/ltp/.mkr.dir-created

$(create-stamp): $(mkr-deps)
	rm -Rf $(dir $@)
	mkdir -p $(dir $@)
	: > $@

# Sync the sources between the source tree and the staging directory
# In maintainer mode, trigger a sync for every compilation
ifeq ($(MKR_LTP_MAINT),y)
do-sync: $(create-stamp)
	$(sync-y) $(mkr-srcdir)/* $(MKR_STAGING)/ltp

$(MKR_STAGING)/ltp/configure: do-sync ;

mkt-configure-args-y += --enable-maintainer-mode
else
$(MKR_STAGING)/ltp/configure: $(create-stamp)
	$(sync-y) $(mkr-srcdir)/* $(MKR_STAGING)/ltp
endif

compile: ;

# Configure
$(MKR_STAGING)/ltp/config.status: $(MKR_STAGING)/ltp/configure
	cd $(dir $@) && ./configure $(mkr-configure-args-y)

# Build
staging: $(MKR_STAGING)/ltp/config.status
	cd $(MKR_STAGING)/ltp && PATH=$(LTP_PATH) $(MAKE) \
	CROSS_COMPILE="$(mkr-cross)" \
	CC="$(CC) $(cflags-y)" CXX="$(CXX) $(cflags-y)"
	for dir in \
		testcases/bin \
		testcases/kernel/io/stress_floppy/dumpdir \
		testcases/bin/dumpdir \
		output \
		results; \
	do mkdir -p $(MKR_STAGING)/ltp/$$dir || exit 1; done

confcheck-$(MKR_LTP_MAINT) := $(call confcheck-tool,rsync,MKR_LTP_MAINT)

confcheck: default-confcheck
