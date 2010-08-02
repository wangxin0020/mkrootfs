# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not
# expect to learn how to build the kernel reading this file.

# Avoid funny character set dependencies
unexport LC_ALL
LC_COLLATE=C
LC_NUMERIC=C
export LC_COLLATE LC_NUMERIC

# Do not:
# o  use make's built-in rules and variables
#    (this increases performance and avoids hard-to-debug behaviour);
# o  print "Entering directory ...";
MAKEFLAGS += -rR --no-print-directory

# We are using a recursive build, so we need to do a little thinking
# to get the ordering right.
#
# Most importantly: sub-Makefiles should only ever modify files in
# their own directory. If in some directory we have a dependency on
# a file in another dir (which doesn't happen often, but it's often
# unavoidable when linking the built-in.o targets which finally
# turn into vmlinux), we will call a sub make in that other dir, and
# after that we are sure that everything which is in that other dir
# is now up to date.
#
# The only cases where we need to modify files which have global
# effects are thus separated out and done before the recursive
# descending is started. They are now explicitly listed as the
# prepare rule.

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands

ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

# kbuild supports saving output files in a separate directory.
# To locate output files in a separate directory two syntaxes are supported.
# In both cases the working directory must be the root of the kernel src.
# 1) O=
# Use "make O=dir/to/store/output/files/"
#
# 2) Set mkr-build-output
# Set the environment variable mkr-build-output to point to the directory
# where the output files shall be placed.
# export mkr-build-output=dir/to/store/output/files/
# make
#
# The O= assignment takes precedence over the mkr-build-output environment
# variable.
#
# We enforce a value for O if none was passed on the command-line

ifeq ($(strip $(O)$(mkr-build-output)$(mkr-build-src)),)
PARALLEL=$(if $(findstring j,$(MAKEFLAGS)),, \
	-j $(shell grep -c '^processor' /proc/cpuinfo))

.PHONY: all
all:
	@mkdir -p build && $(MAKE) $(PARALLEL) O=$(CURDIR)/build $(MAKECMDGOALS)

 $(MAKECMDGOALS): all ;
else

# mkr-build-src is set on invocation of make in OBJ directory
# mkr-build-src is not intended to be used by the regular user (for now)
ifeq ($(mkr-build-src),)

# OK, Make called in directory where kernel src resides
# Do we want to locate output files in a separate directory?
ifeq ("$(origin O)", "command line")
  mkr-build-output := $(O)
endif

# That's our default target when none is given on the command line
PHONY := _all
_all:

# Cancel implicit rules on top Makefile
$(CURDIR)/Makefile Makefile: ;

ifneq ($(mkr-build-output),)
# Invoke a second make in the output directory, passing relevant variables
# check that the output directory actually exists
saved-output := $(mkr-build-output)
mkr-build-output := $(shell cd $(mkr-build-output) && /bin/pwd)
$(if $(mkr-build-output),, \
     $(error output directory "$(saved-output)" does not exist))

PHONY += $(MAKECMDGOALS) sub-make

$(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
	$(Q)@:

sub-make: FORCE
	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(mkr-build-output) \
	mkr-build-src=$(CURDIR) \
	-f $(CURDIR)/Makefile \
	$(filter-out _all sub-make,$(MAKECMDGOALS))

# Leave processing to above invocation of make
skip-makefile := 1
endif # ifneq ($(mkr-build-output),)
endif # ifeq ($(mkr-build-src),)

# We process the rest of the Makefile if this is the final invocation of make
ifeq ($(skip-makefile),)

# If building an external module we do not care about the all: rule
# but instead _all depend on modules
PHONY += all
_all: all

srctree		:= $(if $(mkr-build-src),$(mkr-build-src),$(CURDIR))
objtree		:= $(CURDIR)
src		:= $(srctree)
obj		:= $(objtree)

VPATH		:= $(srctree)

export srctree objtree VPATH

mkr-config	?= .config

# SHELL used by kbuild
mkr-shell := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

HOSTCC       = gcc
HOSTCXX      = g++
HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS = -O2

not = $(if $(strip $(1)),,y)

export mkr-build-src

# Beautify output
# ---------------------------------------------------------------------------
#
# Normally, we echo the whole command before executing it. By making
# that echo $($(quiet)$(cmd)), we now have the possibility to set
# $(quiet) to choose other forms of output instead, e.g.
#
#         quiet_cmd_cc_o_c = Compiling $(RELDIR)/$@
#         cmd_cc_o_c       = $(CC) $(c_flags) -c -o $@ $<
#
# If $(quiet) is empty, the whole command will be printed.
# If it is set to "quiet_", only the short version will be printed.
# If it is set to "silent_", nothing will be printed at all, since
# the variable $(silent_cmd_cc_o_c) doesn't exist.
#
# A simple variant is to prefix commands with $(Q) - that's useful
# for commands that shall be hidden in non-verbose mode.
#
#	$(Q)ln $@ :<
#
# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.

ifeq ($(KBUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif

# If the user is running make -s (silent mode), suppress echoing of
# commands

ifneq ($(findstring s,$(MAKEFLAGS)),)
  quiet=silent_
endif

export quiet Q KBUILD_VERBOSE
export HOSTCC HOSTCXX HOSTCFLAGS HOSTCXXFLAGS

# We need some generic definitions (do not try to remake the file).
$(srctree)/build-tools/Kbuild.include: ;
include $(srctree)/build-tools/Kbuild.include

# Make variables (CC, etc...)
AWK = awk
export AWK

# Files to ignore in find ... statements

RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o
export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exclude CVS --exclude .pc --exclude .hg --exclude .git

# ===========================================================================
# Rules shared between *config targets and build targets

# Basic helpers built in build-tools/
PHONY += build-tools_basic
build-tools_basic:
	$(Q)$(MAKE) $(build)=build-tools/basic
	$(Q)rm -f .tmp_quiet_recordmcount

# # To avoid any implicit rule to kick in, define an empty command.
# build-tools/basic/%: build-tools_basic ;

PHONY += outputmakefile
# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.
outputmakefile:
ifneq ($(mkr-build-src),)
	$(Q)ln -fsn $(srctree) source
	$(Q)$(mkr-shell) $(srctree)/build-tools/mkmakefile \
	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

# To make sure we do not include .config for any of the *config targets
# catch them early, and hand them over to build-tools/kconfig/Makefile
# It is allowed to specify more targets when calling make, including
# mixing *config targets and build targets.
# For example 'make oldconfig all'.
# Detect when mixed targets is specified, and make a second invocation
# of make so .config is not included in this case either (for *config).

allconfigs := oldconfig xconfig gconfig menuconfig config defconfig \
	silentoldconfig localmodconfig localyesconfig \
	allyesconfig allnoconfig allmodconfig

no-dot-config-targets := help

config-targets := 0
mixed-targets  := 0
dot-config     := 1

ifneq ($(filter $(no-dot-config-targets), $(MAKECMDGOALS)),)
	ifeq ($(filter-out $(no-dot-config-targets), $(MAKECMDGOALS)),)
		dot-config := 0
	endif
endif

boards := $(notdir $(wildcard $(srctree)/boards/*_defconfig))
packages-dirs := $(notdir $(patsubst %/,%,$(dir $(wildcard $(srctree)/*/Kconfig))))

ifneq ($(filter $(allconfigs) $(boards),$(MAKECMDGOALS)),)
      config-targets := 1
      ifneq ($(filter-out $(allconfigs) $(boards),$(MAKECMDGOALS)),)
	     mixed-targets := 1
      endif
endif

ifeq ($(mixed-targets),1)
# ===========================================================================
# We're called with mixed targets (*config and build targets).
# Handle them one by one.

%:: FORCE
	$(Q)$(MAKE) -C $(srctree) mkr-build-src= $@

else
ifeq ($(config-targets),1)
# ===========================================================================
# *config targets only - make sure prerequisites are updated, and descend
# in build-tools/kconfig to make the *config target

export mkr-config

$(allconfigs): %: build-tools_basic outputmakefile FORCE
	$(Q)mkdir -p include/config
	$(Q)$(MAKE) $(build)=build-tools/kconfig $@

$(boards): %: build-tools_basic outputmakefile FORCE
	$(Q)mkdir -p include/config
	$(Q)$(MAKE) $(build)=build-tools/kconfig $@

else
# ===========================================================================
# Build targets only - this includes vmlinux, arch specific targets, clean
# targets and others. In general all targets except *config targets.

# Additional helpers built in build-tools/
# Carefully list dependencies so we do not try to build build-tools twice
# in parallel
# PHONY += build-tools
# build-tools: build-tools_basic include/config/auto.conf include/config/tristate.conf
# 	$(MAKE) $(build)=$(@)

ifeq ($(dot-config),1)

mksrcdir=$(shell $(srctree)/build-tools/mksrcdir.sh \
		"$(srctree)" "$(MKR_SRC_BASEDIR)" "$(1)")
checksrcdir = $(if $(call mksrcdir,$($(1))),:,\
	echo Error: $($(1)) not found in $(MKSR_SRC_BASEDIR), see $(1); false)

# Read in config
-include include/config/auto.conf

# Read in dependencies to all Kconfig* files, make sure to run
# oldconfig if changes are detected.
-include include/config/auto.conf.cmd

# To avoid any implicit rule to kick in, define an empty command
$(mkr-config) include/config/auto.conf.cmd: ;

# If .config is newer than include/config/auto.conf, someone tinkered
# with it and forgot to run make oldconfig.
# if auto.conf.cmd is missing then we are probably in a cleaned tree so
# we execute the config step to be sure to catch updated Kconfig files
include/config/%.conf: $(mkr-config) include/config/auto.conf.cmd
	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
else
# Dummy target needed, because used as prerequisite
include/config/auto.conf: ;
endif # $(dot-config)

only-packages:=$(filter $(packages),$(MAKECMDGOALS))
ifeq ($(strip $(only-packages)),)
only-packages:=$(packages)
endif

PHONY += $(only-packages)
$(only-packages): %: all

# The all: target is the default when no target is given on the
# command line.
# This allow a user to issue only 'make' to build a kernel including modules
# Defaults vmlinux but it is usually overridden in the arch makefile
only-pkg-targets = $(foreach t,$(1),$(patsubst %,%/$(t),$(only-packages)))
pkg-targets = $(foreach t,$(1),$(patsubst %,%/$(t),$(packages)))

rootfs-$(MKR_SKIP_ROOTFS) := staging
rootfs-$(call not,$(MKR_SKIP_ROOTFS)) := rootfs

outputs-y := $(rootfs-y)
outputs-$(MKR_OUT_TAR) += rootfs.tar
outputs-$(MKR_OUT_NFS) += nfsroot

all: $(outputs-y) clean-removed-packages

mkr-fakeroot = touch $(dir $@).mkr.fakeroot; $(O)/build-tools/bin/fakeroot \
	-i $(dir $@).mkr.fakeroot -s $(dir $@).mkr.fakeroot
mkr-shortlog = $(srctree)/build-tools/shortlog.awk
mkr-lock = . $(srctree)/build-tools/display.sh lock
mkr-unlock = . $(srctree)/build-tools/display.sh unlock
mkr-locked-echo = . $(srctree)/build-tools/display.sh locked-echo

$(patsubst %, linux/%, $(allconfigs) mkr-config): %: check-computed-variables
	$(Q)mkdir -p linux
	$(Q)$(MAKE) $(call pkg-recurse,linux/) $(notdir $@)
	$(Q)if [ -e linux/.config ]; then \
		cp -a linux/.config .linux_config; \
	fi

 linux/.config:
	$(Q)mkdir -p linux
	$(Q)$(MAKE) $(call pkg-recurse,linux/) $(notdir $@)

linux/%_defconfig:
	$(Q)mkdir -p linux
	$(Q)$(MAKE) $(call pkg-recurse,linux/) $(notdir $@)
	$(Q)if [ -e linux/.config ]; then \
		cp -a linux/.config .linux_config; \
	fi

$(patsubst %, busybox/%, $(allconfigs) mkr-config): \
	%: prepare check-computed-variables
	$(Q)mkdir -p busybox
	$(Q)$(MAKE) $(call pkg-recurse,busybox/) $(notdir $@)
	$(Q)if [ -e busybox/.config ]; then \
		cp -a busybox/.config .busybox_config; \
	fi

confcheck-srcdirs = $(foreach p, \
			$(packages), \
			$(call checksrcdir,$($(p)/srcdir-var)) \
			|| success=false;)
confcheck-awk = type $(AWK) > /dev/null 2>&1 || { \
	echo Error: $(AWK) not found, use PATH or AWK on make command line; \
	success=false; };
confcheck-lnxmf = test -e $(linux/srcdir)/Makefile || { \
	echo Linux kernel Makefile \($(linux/srcdir)/Makefile\) not found; \
	success=false; };
sub-confcheck = { mkdir -p $(2) && \
	$(1) $(call pkg-recurse,$(2)) $(if $(V),,-s) confcheck; } \
		|| success=false;

confcheck-tool = type $(1) > /dev/null 2>&1 || { \
	echo Error: Command $(1) not found, mkrootfs needs it, \
please install it; \
	success=false; };

confcheck-tool-var = type $(1) > /dev/null 2>&1 || { \
	echo Error: Command $(1) not found, install it or see $(2); \
	success=false; };

output-confcheck-y = \
	$(call confcheck-tool,cmp) \
	$(call confcheck-tool,rsync) \
	$(call confcheck-tool,find) \
	$(call confcheck-tool,xargs) \
	$(call confcheck-tool,yes)

output-confcheck-$(call not,$(MKR_SKIP_ROOTFS)) += \
	$(call confcheck-tool-var,$(cross)strip,SKIP_ROOTFS)
output-confcheck-$(MKR_OUT_NFS) += \
	$(call confcheck-tool-var,hexdump,OUT_NFS)
output-confcheck-$(MKR_OUT_TGZ) += \
	$(call confcheck-tool-var,tar,OUT_TGZ)

.mkr.basecheck: include/config/auto.conf
	$(Q)$(confcheck-awk) \
	$(confcheck-srcdirs) \
	$(confcheck-lnxmf) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

linux/.mkr.confcheck: .mkr.basecheck linux/.config
	$(Q)success=:; $(call sub-confcheck,$(MAKE),linux/) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

.mkr.confcheck: linux/.mkr.confcheck
	$(Q)success=:;$(foreach t,$(filter-out linux,$(packages)), \
				$(call sub-confcheck,$(MAKE),$(t)/)) \
	$(output-confcheck-y) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

ARCH:=$(MKR_ARCH)
ARCH_FLAGS:=$(MKR_ARCH_FLAGS)

PHONY+=FORCE
check-computed-variables: FORCE
	$(Q){ \
	echo ARCH=$(MKR_ARCH); \
	echo CC='$(shell which $(MKR_CC))'; \
	echo CCVERSION='$(shell $(MKR_CC) -v 2>&1 | tail -n 1)'; \
	echo CFLAGS=$(MKR_CFLAGS); \
	echo LDFLAGS=$(MKR_LDFLAGS); \
	} > .tmp.mkr.toolchain; \
	if ! cmp -s .tmp.mkr.toolchain .mkr.toolchain; then \
		mv .tmp.mkr.toolchain .mkr.toolchain; \
	else \
		rm -f .tmp.mkr.toolchain; \
	fi; \
	/bin/echo -n -e $(foreach p,$(packages), \
		$(p) $(call mksrcdir,$($($(p)/srcdir-var)))\\n) | \
	while read p srcdir; do \
		echo "srcdir=$$srcdir" > .tmp.mkr.srcdir; \
		if ! cmp -s .tmp.mkr.srcdir $$p/.mkr.srcdir; then \
			mkdir -p $$p; \
			mv .tmp.mkr.srcdir $$p/.mkr.srcdir; \
		else \
			rm -f .tmp.mkr.srcdir; \
		fi; \
	done

.mkr.builddir: FORCE
	$(Q)echo builddir=$(O) > .tmp.mkr.builddir; \
	if ! cmp -s .tmp.mkr.builddir .mkr.builddir; then \
		mv .tmp.mkr.builddir .mkr.builddir; \
	else \
		rm -f .tmp.mkr.builddir; \
	fi; \

remove-displayed: FORCE
	$(Q)rm -f .mkr.displayed

mkr-run-and-log-on-failure = \
	mkdir -p $(2); \
	$(mkr-locked-echo) $(1)...; \
	if ! { $(3); } >> $(2).mkr.log 2>&1; then \
		$(mkr-shortlog) $(2).mkr.log > $(2).mkr.shortlog; \
		$(mkr-lock); echo '+++' $(1)... failed; \
		if [ ! -e .mkr.displayed ]; then \
			cat $(2).mkr.shortlog; \
			echo '+++' Use make $(2)log for more details; \
		else \
			echo '+++' Use make $(2)shortlog or $(2)log for more details; \
		fi; \
		: > .mkr.displayed; \
		$(mkr-unlock); exit 1; \
	fi; \
	$(mkr-locked-echo) $(1)... done

mkr-run-and-log = \
	mkdir -p $(2); \
	$(mkr-locked-echo) $(1)...; \
	if ! { $(3); } >> $(2).mkr.log 2>&1; then \
		$(mkr-shortlog) $(2).mkr.log > $(2).mkr.shortlog; \
		$(mkr-lock); echo '+++' $(1)... failed; \
		if [ ! -e .mkr.displayed ]; then \
			cat $(2).mkr.shortlog; \
			echo '+++' Use make $(2)log for more details; \
		else \
			echo '+++' Use make $(2)shortlog or $(2)log for more details; \
		fi; \
		: > .mkr.displayed; \
		$(mkr-unlock); exit 1; \
	else \
		$(mkr-shortlog) $(2).mkr.log > $(2).mkr.shortlog; \
		if [ -s $(2).mkr.shortlog ]; then \
			$(mkr-lock); \
			echo '+++' $(1)... done, with warnings; \
			if [ ! -e .mkr.displayed ]; then \
				cat $(2).mkr.shortlog; \
				echo '+++' Use make $(2)log for more details; \
			else \
				echo '+++' Use make $(2)shortlog or $(2)log for more details; \
			fi; : > .mkr.displayed; $(mkr-unlock); \
		else \
			$(mkr-locked-echo) $(1)... done; \
		fi; \
	fi

mkr-run-staging-$(call not,$(MKR_SKIP_ROOTFS)) = $(mkr-run-and-log-on-failure)
mkr-run-staging-$(MKR_SKIP_ROOTFS) = $(mkr-run-and-log)

build-tools/bin/fakeroot: .mkr.builddir
	$(Q)rm -f build-tools/fakeroot/.mkr.log
	$(Q)$(call mkr-run-and-log, \
		Building build system fakeroot, \
		build-tools/fakeroot/, \
		$(MAKE) -C build-tools/fakeroot \
			-f $(srctree)/build-tools/fakeroot-1.14.4/Makefile \
			$(O)/build-tools/bin/fakeroot)

PHONY += $(call pkg-targets,compile)
$(call pkg-targets,compile): \
	%/compile: prepare check-computed-variables .mkr.builddir
	$(Q)rm -f $(dir $@).mkr.log
	$(Q)$(call mkr-run-and-log-on-failure, \
		Building package $(dir $@) using $($(strip $(dir $@))srcdir), \
		$(dir $@), \
		$(MAKE) $(call pkg-recurse,$(dir $@)) $(notdir $@))

PHONY += $(call pkg-targets,staging)
$(call pkg-targets,staging): %/staging: %/compile build-tools/bin/fakeroot
	$(Q)$(mkr-fakeroot) sh -c '{ \
		mkr_pkginst=$(dir $@).mkr.inst; \
		mkdir -p $$mkr_pkginst; \
		$(call mkr-run-staging-y, \
			Installing package $(dir $@) in staging directory, \
			$(dir $@), \
			$(MAKE) $(call pkg-recurse,$(dir $@)) $(notdir $@)); \
		{ cd $$mkr_pkginst && find . -! -type d; } \
			| sort > $(dir $@)/.mkr.newfilelist; \
		{ cd $$mkr_pkginst && find . -type d; } \
			| grep -v ^\.$$ | sort -r > $(dir $@)/.mkr.newdirlist; \
		if [ -e $(dir $@)/.mkr.filelist ]; then \
			comm -2 -3 $(dir $@)/.mkr.filelist \
				$(dir $@)/.mkr.newfilelist \
			| { mkdir -p staging; cd staging && xargs -r rm -f; }; \
		fi; if [ -e $(dir $@)/.mkr.dirlist ]; then \
			comm -2 -3 $(dir $@)/.mkr.dirlist \
				$(dir $@)/.mkr.newdirlist \
			| { mkdir -p staging; cd staging && xargs -r \
				rmdir --ignore-fail-on-non-empty; }; \
		fi; \
		mv $(dir $@)/.mkr.newfilelist $(dir $@)/.mkr.filelist; \
		mv $(dir $@)/.mkr.newdirlist $(dir $@)/.mkr.dirlist; \
		if ! rsync -rlpgoDc $$mkr_pkginst/ staging/; then \
			$(mkr-locked-echo) rsync failed, please try again; \
			rm -f $(dir $@).mkr.fakeroot; \
			cat $(dir $@).mkr.filelist 2> /dev/null | \
			{ cd staging; xargs -r rm -f; } > /dev/null 2>&1; \
			cat $(dir $@).mkr.filelist 2> /dev/null | \
			{ cd rootfs; xargs -r rm -f; } > /dev/null 2>&1; \
			cat $(dir $@).mkr.dirlist 2> /dev/null | \
			{ cd staging; xargs -r rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
			cat $(dir $@).mkr.dirlist 2> /dev/null | \
			{ cd rootfs; xargs -r rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
		fi; \
		rm -Rf $$mkr_pkginst; \
	}'

PHONY += staging
staging: $(call only-pkg-targets,staging)
	$(Q)cat $(wildcard $(call pkg-targets,.mkr.fakeroot)) > .mkr.fakeroot

PHONY += $(call pkg-targets,log)
$(call pkg-targets,log): %:
	$(Q)cat $(dir $@).mkr.log 2> /dev/null || :

PHONY += $(call pkg-targets,shortlog)
$(call pkg-targets,shortlog): %:
	$(Q)cat $(dir $@).mkr.shortlog 2> /dev/null || :

# Rootfs rules, only needed if not skipping rootfs generation.
ifneq ($(MKR_SKIP_ROOTFS),y)
PHONY += $(call pkg-targets,rootfs)
$(call pkg-targets,rootfs): %/rootfs: %/staging
	$(Q)$(call mkr-run-and-log, \
		Installing package $(dir $@) in rootfs directory, \
		$(dir $@), \
		$(mkr-fakeroot) $(MAKE) $(call pkg-recurse,$(dir $@)) $(notdir $@))

ifneq ($(MKR_CC),)
cross := $(shell expr $(MKR_CC) : '\(.*\)gcc')
endif

PHONY += rootfs
rootfs: $(call only-pkg-targets,rootfs)
	$(Q)find rootfs -type f -! -name '*.ko' -! -name '*.so' \
		$(if $(wildcard .mkr.fakeroot),-newer .mkr.fakeroot) | \
		xargs -r $(cross)strip > /dev/null 2>&1 || :
	$(Q)cat $(call pkg-targets,.mkr.fakeroot) > .mkr.fakeroot
endif

dis_packages:=$(filter-out $(packages),$(all_packages))

PHONY += clean-removed-packages
clean-removed-packages:
	$(Q)lists="$(wildcard $(foreach p,$(dis_packages),$(p)/.mkr.filelist))"; \
	rm -f $(foreach p,$(dis_packages),$(p)/.mkr.fakeroot); \
	if [ -n "$$lists" ]; then \
		cat $$lists | \
			{ cd staging; xargs -r rm -f; } > /dev/null 2>&1; \
		cat $$lists | \
			{ cd rootfs; xargs -r rm -f; } > /dev/null 2>&1; \
		rm -f $$lists; \
	fi; \
	lists="$(wildcard $(foreach p,$(dis_packages),$(p)/.mkr.dirlist))"; \
	if [ -n "$$lists" ]; then \
		cat $$lists | { cd staging; xargs -r \
			rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
		cat $$lists | { cd rootfs; xargs -r \
			rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
		rm -f $$lists; \
	fi

$(dis_packages): FORCE
	@echo Package $@ is not enabled in the configuration.; false

$(foreach p,$(dis_packages),$(p)/%): FORCE
	@echo Package $@ is not enabled in the configuration.; false

ifeq ($(MKR_OUT_NFS),y)
.rsyncd.secrets: .mkr.builddir
	$(Q)PASS=`hexdump -e '"%08x"' -n 4 /dev/urandom`; \
	umask 077; \
	echo $$PASS > .rsync.pass; \
	echo root:$$PASS > .rsyncd.secrets

.rsync.port:
	echo $(MKR_OUT_RSYNCD_PORT) > .rsync.port

.rsyncd.pid: .rsyncd.secrets .rsync.port
	$(Q)first=:; LIMIT=`expr $(MKR_OUT_RSYNCD_PORT) + 100`; \
	rm -f .rsyncd.pid; \
	while [ ! -e .rsyncd.pid ]; do \
		PORT=`cat .rsync.port`; \
		$(mkr-locked-echo) Launching rsync on port $$PORT...; \
		sudo rsync --daemon --port=$$PORT \
			--config=$(srctree)/build-tools/rsyncd.conf; \
		sleep 1; \
		if [ ! -e .rsyncd.pid ]; then \
			$(mkr-locked-echo) Launching rsync on port $$PORT... failed; \
			if $$first; then \
				PORT=$(MKR_OUT_RSYNCD_PORT); \
			else \
				PORT=`expr $$PORT + 1`; \
			fi; \
			if [ "$$PORT" -eq "$$LIMIT" ]; then \
				$(mkr-locked-echo) Unable to launch rsync daemon. Giving up.; \
				exit 1; \
			fi; \
			echo $$PORT > .rsync.port; \
			first=false; \
		else \
			$(mkr-locked-echo) Launching rsync on port $$PORT... done; \
			exit 0; \
		fi; \
	done

PHONY += nfsroot
nfsroot: $(rootfs-y) .rsyncd.pid
	$(Q)echo Synchronizing NFS root...
	$(Q)mkdir -p nfsroot; \
	PORT=`cat .rsync.port`; \
	if ! $(O)/build-tools/bin/fakeroot -i .mkr.fakeroot \
		rsync --password-file=.rsync.pass --delete -a \
		--exclude /ltp/testcases/bin/* \
		--exclude /ltp/output/* --exclude /ltp/results/* \
		--exclude /ltp/.installed --exclude /root/* \
		--exclude /etc/ld.so.cache \
		$(rootfs-y)/* rsync://root@localhost:$$PORT/nfsroot; then \
		echo Synchronizing NFS root failed, erasing rsync configuration; \
		echo Please try again; \
		rm -Rf .rsync* .mkr.fakeroot */.mkr.fakeroot staging rootfs; \
	else \
		echo Synchronizing NFS root... done; \
	fi
endif

ifeq ($(MKR_OUT_TAR),y)
PHONY += rootfs.tar
rootfs.tar: $(rootfs-y)
	$(Q)echo Generating $@...
	$(Q)tar -C $(rootfs-y) -cf $@ .
	$(Q)echo Generating $@... done
endif

# Things we need to do before we recursively start building the kernel
# or the modules are listed in "prepare".
# A multi level approach is used. prepareN is processed before prepareN-1.
# archprepare is used in arch Makefiles and when processed asm symlink,
# version.h and build-tools_basic is processed / created.

# Listed in dependency order
PHONY += prepare archprepare prepare0 prepare1 prepare2

# prepare2 creates a makefile if using a separate output directory
prepare2: outputmakefile remove-displayed

prepare1: prepare2 include/config/auto.conf

archprepare: prepare1 build-tools_basic

prepare0: archprepare FORCE
	$(Q)$(MAKE) $(build)=.

# All the preparing..
prepare: prepare0 .mkr.confcheck

# Generate some files
# ---------------------------------------------------------------------------

###
# make clean     Delete most generated files
# make mrproper  Delete the current configuration, and all generated files

# Per package clean target
PHONY += $(call pkg-targets,clean)
$(call pkg-targets,clean): %:
	$(Q)echo Cleaning $(dir $@)...; \
	if [ -e $(dir $@) ] \
		&& ! $(MAKE) $(call pkg-recurse,$(dir $@)) $(notdir $@) \
		> /dev/null 2>&1; then \
		echo Cleaning $(dir $@)... failed; \
		exit 1; \
	else \
		rm -f $(dir $@).mkr.fakeroot; \
		cat $(dir $@).mkr.filelist 2> /dev/null | \
		{ cd staging; xargs -r rm -f; } > /dev/null 2>&1; \
		cat $(dir $@).mkr.filelist 2> /dev/null | \
		{ cd rootfs; xargs -r rm -f; } > /dev/null 2>&1; \
		cat $(dir $@).mkr.dirlist 2> /dev/null | \
		{ cd staging; xargs -r rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
		cat $(dir $@).mkr.dirlist 2> /dev/null | { \
		cd rootfs; xargs -r rmdir --ignore-fail-on-non-empty; } > /dev/null 2>&1; \
		echo Cleaning $(dir $@)... done; \
	fi

clean: $(call pkg-targets,clean)
	$(Q)rm -Rf staging/* rootfs/* .mkr.fakeroot */.mkr.fakeroot

# mrproper - Delete all generated files, including .config
#
ifeq ($(MKR_OUT_NFS),y)
PHONY += clean-nfsroot
clean-nfsroot: .rsyncd.pid
	$(Q)if [ -e nfsroot ]; then \
		mkdir -p staging; \
		rm -Rf staging/*; \
		PORT=`cat .rsync.port`; \
		rsync --password-file=.rsync.pass --delete -a staging/ \
			rsync://root@localhost:$$PORT/nfsroot; \
	fi

clean: clean-nfsroot

mrproper: clean-nfsroot
endif

PHONY += mrproper
mrproper:
	$(Q)rm -Rf .config $(filter-out .mkr.builddir,$(wildcard .mkr.*)) *

# distclean
#
PHONY += distclean
distclean: mrproper
	@find $(srctree) $(RCS_FIND_IGNORE) -name build -prune -o \
		\( -name '*.orig' -o -name '*.rej' -o -name '*~' \
		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
		-o -name '.*.rej' \
		-o -name '*%' -o -name '.*.cmd' -o -name 'core' \) \
		-type f -print | xargs rm -f

# Brief documentation of the typical targets used
# ---------------------------------------------------------------------------

help:
	@echo  'Cleaning targets:'
	@echo  '  clean		  - Remove most generated files but keep the config and'
	@echo  '                    Makefiles'
	@echo  '  mrproper	  - Remove all generated files + config + various backup files'
	@echo  '  distclean	  - mrproper + remove editor backup and patch files'
	@echo  ''
	@echo  'Configuration targets:'
	@$(MAKE) -f $(srctree)/build-tools/kconfig/Makefile help
	@echo  ''
	@echo  'Pre-canned board configurations:'
	@$(foreach b, $(boards), \
		printf "  %-24s - %s board configuration\\n" $(b) $(subst _defconfig,,$(b));)
	@echo  ''
	@echo  'Other generic targets:'
	@echo  '  all		  - Build all targets marked with [*]'
	@echo  '* staging         - Build all packages and install them in the staging directory'
	@echo  '* rootfs          - Copy and strip from staging on the files useful at run-time'
	@echo  '* nfsroot         - Copy rootfs in a directory shared through NFS'
	@echo  '  package         - build package and if need be, update the staging, rootfs'
	@echo  '                  and nfsroot directories. The available packages are:'
	@$(foreach p,$(packages-dirs), \
	echo  '                   . $(p)';)
	@echo  ''
	@echo  '  package/target  - run target in the package build directory, where target is'
	@echo  '                  one of compile, staging, rootfs, clean, shortlog, log,'
	@echo  '                  or one of the *config targets for busybox and linux.'
	@echo  ''
	@echo  '                  busybox and linux also have a mkr-config target which'
	@echo  '                  restores their .config from mkrootfs configuration.'
	@echo  ''
	@echo  '                  The log and shortlog target print the last compilation log.'
	@echo  ''
	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
	@echo  'For further info see the ./README file'


help-board-dirs := $(addprefix help-,$(board-dirs))

help-boards: $(help-board-dirs)

boards-per-dir = $(notdir $(wildcard $(srctree)/arch/$(SRCARCH)/configs/$*/*_defconfig))

$(help-board-dirs): help-%:
	@echo  'Architecture specific targets ($(SRCARCH) $*):'
	@$(if $(boards-per-dir), \
		$(foreach b, $(boards-per-dir), \
		printf "  %-24s - Build for %s\\n" $*/$(b) $(subst _defconfig,,$(b));) \
		echo '')

endif #ifeq ($(config-targets),1)
endif #ifeq ($(mixed-targets),1)

endif	# skip-makefile

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
endif
