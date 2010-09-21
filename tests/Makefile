c-exes-y = calibrator cyclictest_nonxeno
scripts-y = noltp_hell
scripts-$(MKR_TESTS_LTP) += dohell

all := $(c-exes-y) $(cxx-exes-y) $(scripts-y)

# Flags
CPPFLAGS := -D_GNU_SOURCE -D_REENTRANT -DPIC -I. -I$(srcdir)
CXXFLAGS := $(cflags-y) -W -Wall -fPIC
CFLAGS := $(CXXFLAGS) -Wstrict-prototypes -Werror-implicit-function-declaration
LDFLAGS := $(ldflags-y) -rdynamic

ifeq ($(MKR_TESTS_XENO),y)
XENO_CONFIG = DESTDIR="$(staging)" $(staging)/usr/bin/xeno-config

XENO_NATIVE_CPPFLAGS = $(shell $(XENO_CONFIG) --skin=native --cflags)
XENO_NATIVE_LIBS = $(shell $(XENO_CONFIG) --skin=native --ldflags)

XENO_POSIX_CPPFLAGS = $(shell $(XENO_CONFIG) --skin=posix --cflags)
XENO_POSIX_LIBS = $(shell $(XENO_CONFIG) --skin=posix --ldflags)
endif

# Per-exe rules
calibrator: calibrator.o
calibrator: LDLIBS += -lm

cyclictest_nonxeno: cyclictest.o
cyclictest_nonxeno: LDLIBS += -lpthread -lrt
cyclictest.o: CPPFLAGS+=-DVERSION_STRING=\"0.28\"

# Rules
# Can't use VPATH here, not sure why, but it may be because it is
# unexported in Makefile.pkgbuild
vpath % $(srcdir)

compile: $(all)

staging-all: $(all)
	install -o 0 -d $(pkginst)/usr/bin
	install -o 0 $^ $(pkginst)/usr/bin

staging: staging-all

rootfs: default-copyall-rootfs

clean:
	rm -f $(c-exes-y) $(cxx-exes-y) *.o *.d

ifneq ($(wildcard Kbuild),)
compile: modules

staging: modules_install

clean: modules_clean
endif

bin_cmd=-o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

$(c-exes-y): %:
	@if test -z "$^"; then \
	echo You need to list which objects files $@ is made of.; \
	echo Add to Makefile something like:; \
	echo $@: foo.o bar.o; \
	exit 1; fi; \
	echo $(CC) $(bin_cmd); $(CC) $(bin_cmd)

$(cxx-exes-y): %:
	@if test -z "$^"; then \
	echo You need to list which objects files $@ is made of.; \
	echo Add to Makefile something like:; \
	echo $@: foo.o bar.o; \
	exit 1; fi; \
	echo $(CXX) $(bin_cmd); $(CXX) $(bin_cmd)

%.o: %.c
	$(CC) -o $@ -c $< $(CPPFLAGS) $(CFLAGS)

%.o: %.cc
	$(CXX) -o $@ -c $< $(CPPFLAGS) $(CXXFLAGS)

%.o: %.cxx
	$(CXX) -o $@ -c $< $(CPPFLAGS) $(CXXFLAGS)

%.o: %.C
	$(CXX) -o $@ -c $< $(CPPFLAGS) $(CXXFLAGS)

# Kernel modules
ifneq ($(wildcard $(srcdir)/Kbuild),)
KBUILD=$(O)/linux

.PHONY: modules modules_install modules_clean
modules modules_install:
	ln -sf $(srcdir)/Kbuild $(srcdir)/*.[chS] .
	$(MAKE) -C $(KBUILD) M=$(CURDIR) ARCH=$(KARCH) CC="$(KCC)" \
		CROSS_COMPILE=$(kcross) \
		INSTALL_MOD_PATH=$(pkginst) $@

modules_install: modules

modules_clean:
	if [ -e Kbuild ]; then \
		$(MAKE) -C $(KBUILD) M=$(CURDIR) ARCH=$(KARCH) CC="$(KCC)" \
			CROSS_COMPILE=$(kcross) clean; \
		rm -f Module.symvers modules.order Kbuild *.[chS]; \
	fi
else
modules modules_install modules_clean:
endif

# Automatic dependencies
DEPENDENCIES := \
	$(patsubst $(srcdir)/%.c, %.d, $(wildcard $(srcdir)/*.c)) \
	$(patsubst $(srcdir)/%.cc, %.d, $(wildcard $(srcdir)/*.cc)) \
	$(patsubst $(srcdir)/%.cxx, %.d, $(wildcard $(srcdir)/*.cxx)) \
	$(patsubst $(srcdir)/%.C, %.d, $(wildcard $(srcdir)/*.C))

ifneq ($(filter compile, $(MAKECMDGOALS)),)
ifneq ($(strip $(DEPENDENCIES)),)
mkdeps_cmd= -M $(CPPFLAGS) $< 2> /dev/null | \
	sed 's,\($*\)\.o[ :]*,\1.o $@: $$(deps) ,g' > $@; \
	test -s $@ || rm -f $@

%.d: %.c
	@$(CC) $(mkdeps_cmd)

%.d: %.cc
	@$(CXX) $(mkdeps_cmd)

%.d: %.cxx
	@$(CXX) $(mkdeps_cmd)

%.d: %.C
	@$(CXX) $(mkdeps_cmd)

-include $(DEPENDENCIES)
endif
endif
