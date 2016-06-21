# Do not use distcc when compiling LTP as it actually slows down the
# compilation
LTP_PATH=$(shell echo $$PATH | sed 's/[^:]*distcc://g')

sync-$(call not,$(MKR_LTP_OLD_MAINT)) := cp -a
sync-$(MKR_LTP_OLD_MAINT) := rsync -a

create-stamp := .mkr.created

$(create-stamp): $(deps)
	rm -Rf *
	: > $@

# Sync the sources between the source tree and the build directory
# In maintainer mode, trigger a sync for every compilation
ifeq ($(MKR_LTP_OLD_MAINT),y)
do-sync: $(create-stamp)
	$(sync-y) $(srcdir)/* .

configure: do-sync ;

# Configure (maintainer mode)
config.status: configure
	./configure $(configure-args-y) --enable-maintainer-mode
	$(MAKE) clean
else
# Configure
config.status: $(create-stamp)
	$(sync-y) $(srcdir)/* .
	./configure $(configure-args-y)
	$(MAKE) clean
endif

$(mkr-configured): config.status

# Build
compile:
	PATH=$(LTP_PATH) $(MAKE) CROSS_COMPILE="$(cross)" \
	CC="$(CC) $(ARCH_FLAGS)" CXX="$(CXX) $(ARCH_FLAGS)" \
		AR="$(cross)ar" RANLIB="$(cross)ranlib"
	for dir in \
		testcases/bin \
		testcases/kernel/io/stress_floppy/dumpdir \
		testcases/bin/dumpdir \
		output \
		results; \
	do mkdir -p $$dir || exit 1; done

# Install, we use custom install rules in order to preserve timestamps
staging:
	mkdir -p $(pkginst)/ltp $(staging)/ltp
	cp -alf * $(pkginst)/ltp
	cp -alf * $(staging)/ltp

rootfs:
	mkdir -p $(rootfs)/ltp
	cp -alf * $(rootfs)/ltp

# Clean
clean: default-clean

# Check configuration
confcheck-y := $(call confcheck-tool,lex,MKR_LTP_OLD)

confcheck: default-confcheck
