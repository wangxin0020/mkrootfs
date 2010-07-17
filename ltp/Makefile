# Do not use distcc when compiling LTP as it actually slows down the
# compilation
LTP_PATH=$(shell echo $$PATH | sed 's/[^:]*distcc://g')

sync-$(call not,$(MKR_LTP_MAINT)) := cp -a
sync-$(MKR_LTP_MAINT) := rsync -a

create-stamp := $(staging)/ltp/.mkr.dir-created

$(create-stamp): $(deps)
	rm -Rf $(dir $@)
	mkdir -p $(dir $@)
	: > $@

# Sync the sources between the source tree and the staging directory
# In maintainer mode, trigger a sync for every compilation
ifeq ($(MKR_LTP_MAINT),y)
do-sync: $(create-stamp)
	$(sync-y) $(srcdir)/* $(staging)/ltp

$(staging)/ltp/configure: do-sync ;

mkt-configure-args-y += --enable-maintainer-mode
else
$(staging)/ltp/configure: $(create-stamp)
	$(sync-y) $(srcdir)/* $(staging)/ltp
endif

compile: ;

# Configure
$(staging)/ltp/config.status: $(staging)/ltp/configure
	cd $(dir $@) && ./configure $(configure-args-y)

# Build & install
staging: $(staging)/ltp/config.status
	cd $(staging)/ltp && PATH=$(LTP_PATH) $(MAKE) \
	CROSS_COMPILE="$(cross)" \
	CC="$(CC) $(ARCH_CFLAGS)" CXX="$(CXX) $(ARCH_LDFLAGS)" \
		AR="$(cross)ar" RANLIB="$(cross)ranlib"
	for dir in \
		testcases/bin \
		testcases/kernel/io/stress_floppy/dumpdir \
		testcases/bin/dumpdir \
		output \
		results; \
	do mkdir -p $(staging)/ltp/$$dir || exit 1; done

rootfs: default-copyall-rootfs

# Cleaning
clean: ;

# Checking configuration
confcheck-$(MKR_LTP_MAINT) := $(call confcheck-tool,rsync,MKR_LTP_MAINT)

confcheck: default-confcheck
