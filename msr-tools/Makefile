rootfs-y += \
	/usr/sbin/cpuid \
	/usr/sbin/rdmsr \
	/usr/sbin/wrmsr

compile-make-args-y := \
	CC="$(CC)" CXX="$(CXX)" LD="$(cross)ld" AR="$(cross)ar" \
	STRIP="$(cross)strip" NM="$(cross)nm" RANLIB="$(cross)ranlib" \
	CPPFLAGS="$(cppflags-y)" CFLAGS="$(cflags-y)" CXXFLAGS="$(cxxflags-y)" \
	LDFLAGS="$(ldflags-y)"

Makefile: $(srcdir)/Makefile $(deps)
	echo "VPATH=$(srcdir)" > $@
	cat $< >> $@
	$(MAKE) clean

$(mkr-configured): Makefile

compile:
	$(MAKE) $(compile-make-args-y)

staging: 
	mkdir -p "$(pkginst)/usr/sbin"
	$(MAKE) sbindir="$(pkginst)/usr/sbin" install

rootfs: default-rootfs

clean: default-clean

confcheck-y += $(call confcheck-if, \
	test -z "$(CONFIG_X86_MSR)", \
	msr-tool require CONFIG_X86_MSR in kernel configuration)

confcheck: default-confcheck
