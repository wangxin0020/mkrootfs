# Do not use distcc when compiling LTP as it actually slows down the
# compilation
LTP_PATH=$(shell echo $$PATH | sed 's/[^:]*distcc://g')

sync-$(call not,$(MKR_LTP_MAINT)) := cp --preserve=links,mode -R
sync-$(MKR_LTP_MAINT) := rsync -rlpgoD

create-stamp := .mkr.created

$(create-stamp): $(deps)
	rm -Rf *
	: > $@

# Sync the sources between the source tree and the build directory
# In maintainer mode, trigger a sync for every compilation
ifeq ($(MKR_LTP_MAINT),y)
do-sync: $(create-stamp)
	$(sync-y) $(srcdir)/* .

configure: do-sync ;

configure-args-y += --enable-maintainer-mode
else
configure: $(create-stamp)
	$(sync-y) $(srcdir)/* .
	if [ -e config.status ]; then \
		echo Something is very wrong !; \
		exit 1; \
	fi
endif

# Configure
config.status: configure
	./configure $(configure-args-y)

# Build
compile: config.status
	PATH=$(LTP_PATH) $(MAKE) CROSS_COMPILE="$(cross)" \
	CC="$(CC) $(ARCH_CFLAGS)" CXX="$(CXX) $(ARCH_LDFLAGS)" \
		AR="$(cross)ar" RANLIB="$(cross)ranlib"
	for dir in \
		testcases/bin \
		testcases/kernel/io/stress_floppy/dumpdir \
		testcases/bin/dumpdir \
		output \
		results; \
	do mkdir -p $$dir || exit 1; done

# Install
staging:
	mkdir -p $(pkginst)/ltp
	cp -alf * $(pkginst)/ltp

rootfs: default-copyall-rootfs

# Clean
clean: default-clean

# Check configuration
confcheck-$(MKR_LTP_MAINT) := $(call confcheck-tool,rsync,MKR_LTP_MAINT)

confcheck: default-confcheck
