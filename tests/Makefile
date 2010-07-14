# Can't use VPATH here, not sure why, but it may be because it is
# unexported in Makefile.pkgbuild
vpath % $(srcdir)

CPPFLAGS := -D_GNU_SOURCE -D_REENTRANT -DPIC -I. -I$(srcdir)
CXXFLAGS := $(cflags-y) -W -Wall -fPIC
CFLAGS := $(CXXFLAGS) -Wstrict-prototypes -Werror-implicit-function-declaration
LDFLAGS := $(ldflags-y) -rdynamic

ifeq ($(MKR_XENO),y)
XENO_CONFIG = DESTDIR="$(staging)" $(staging)/usr/bin/xeno-config

XENO_NATIVE_CPPFLAGS = $(shell $(XENO_CONFIG) --skin=native --cflags)
XENO_NATIVE_LIBS = $(shell $(XENO_CONFIG) --skin=native --ldflags)

XENO_POSIX_CPPFLAGS = $(shell $(XENO_CONFIG) --skin=posix --cflags)
XENO_POSIX_LIBS = $(shell $(XENO_CONFIG) --skin=posix --ldflags)
endif

bin_C_PROGRAMS = calibrator cyclictest_nonxeno
bin_SCRIPTS = dohell fcsehell

calibrator: calibrator.o
calibrator: LDLIBS += -lm

cyclictest_nonxeno: cyclictest.o
cyclictest_nonxeno: LDLIBS += -lpthread -lrt
cyclictest.o: CPPFLAGS+=-DVERSION_STRING=\"0.28\"

# Generic rules
all := $(bin_C_PROGRAMS) $(bin_CXX_PROGRAMS) $(bin_SCRIPTS)

compile: $(all)

staging:
	install -o 0 -D $(all) $(pkginst)/usr/bin

rootfs: default-copyall-rootfs

bin_cmd=-o $@ $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS)

$(bin_C_PROGRAMS): %:
	if test -z "$^"; then \
	echo You need to list which objects files $@ is made of.; \
	echo Add to Makefile something like:; \
	echo $@: foo.o bar.o; \
	exit 1; fi; \
	echo $(CC) $(bin_cmd); $(CC) $(bin_cmd)

$(bin_CXX_PROGRAMS): %:
	if test -z "$^"; then \
	echo You need to list which objects files $@ is made of.; \
	echo Add to Makefile something like:; \
	echo $@: foo.o bar.o; \
	exit 1; fi; \
	echo $(CXX) $(bin_cmd); $(CXX) $(bin_cmd)

# Automatic dependencies
DEPENDENCIES := \
	$(patsubst $(srcdir)/%.c, %.d, $(wildcard $(srcdir)/*.c)) \
	$(patsubst $(srcdir)/%.cc, %.d, $(wildcard $(srcdir)/*.cc)) \
	$(patsubst $(srcdir)/%.cxx, %.d, $(wildcard $(srcdir)/*.cxx)) \
	$(patsubst $(srcdir)/%.C, %.d, $(wildcard $(srcdir)/*.C))

ifneq ($(strip $(DEPENDENCIES)),)
mkdeps_cmd= -M $(CPPFLAGS) $< 2> /dev/null | \
	sed 's,\($*\)\.o[ :]*,\1.o $@: $$(deps) ,g' > $@; \
	test -s $@ || $(RM) $@

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
