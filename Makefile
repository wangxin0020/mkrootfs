# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
# More info can be located in ./README
# Comments in this file are targeted only to the developer, do not
# expect to learn how to build the kernel reading this file.

# Do not:
# o  use make's built-in rules and variables
#    (this increases performance and avoids hard-to-debug behaviour);
MAKEFLAGS += -R
NODIRFLAG += --no-print-directory

# Avoid funny character set dependencies
unexport LC_ALL
LC_COLLATE=C
LC_NUMERIC=C
export LC_COLLATE LC_NUMERIC

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
# 2) Set MKR_BUILD_OUTPUT
# Set the environment variable MKR_BUILD_OUTPUT to point to the directory
# where the output files shall be placed.
# export MKR_BUILD_OUTPUT=dir/to/store/output/files/
# make
#
# The O= assignment takes precedence over the MKR_BUILD_OUTPUT environment
# variable.

ifeq ($(O),)
	O := $(PWD)/output
	MKR_BUILD_OUTPUT := $(O)
endif

# MKR_BUILD_SRC is set on invocation of make in OBJ directory
# MKR_BUILD_SRC is not intended to be used by the regular user (for now)
ifeq ($(MKR_BUILD_SRC),)

# OK, Make called in directory where kernel src resides
# Do we want to locate output files in a separate directory?
ifeq ("$(origin O)", "command line")
  MKR_BUILD_OUTPUT := $(O)
endif

# That's our default target when none is given on the command line
PHONY := _all
_all:

# Cancel implicit rules on top Makefile
$(CURDIR)/Makefile Makefile: ;

ifneq ($(MKR_BUILD_OUTPUT),)
# Invoke a second make in the output directory, passing relevant variables
# check that the output directory actually exists
saved-output := $(MKR_BUILD_OUTPUT)
MKR_BUILD_OUTPUT := $(shell cd $(MKR_BUILD_OUTPUT) && /bin/pwd)
$(if $(MKR_BUILD_OUTPUT),, \
     $(error output directory "$(saved-output)" does not exist))

PHONY += $(MAKECMDGOALS) sub-make

$(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
	$(Q)@:

sub-make: FORCE
	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) $(NODIRFLAG) -C $(MKR_BUILD_OUTPUT) \
	MKR_BUILD_SRC=$(CURDIR) \
	-f $(CURDIR)/Makefile \
	$(filter-out _all sub-make,$(MAKECMDGOALS))

# Leave processing to above invocation of make
skip-makefile := 1
endif # ifneq ($(MKR_BUILD_OUTPUT),)
endif # ifeq ($(MKR_BUILD_SRC),)

# We process the rest of the Makefile if this is the final invocation of make
ifeq ($(skip-makefile),)

# If building an external module we do not care about the all: rule
# but instead _all depend on modules
PHONY += all
_all: all

srctree		:= $(if $(MKR_BUILD_SRC),$(MKR_BUILD_SRC),$(CURDIR))
objtree		:= $(CURDIR)
src		:= $(srctree)
obj		:= $(objtree)

VPATH		:= $(srctree)

export srctree objtree VPATH

MKR_CONFIG	?= .config

# SHELL used by kbuild
MKR_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

HOSTCC       = gcc
HOSTCXX      = g++
HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
HOSTCXXFLAGS = -O2

export MKR_BUILD_SRC

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
$(srctree)/scripts/Kbuild.include: ;
include $(srctree)/scripts/Kbuild.include

# Make variables (CC, etc...)
AWK = awk
export AWK

# Files to ignore in find ... statements

RCS_FIND_IGNORE := \( -name SCCS -o -name BitKeeper -o -name .svn -o -name CVS -o -name .pc -o -name .hg -o -name .git \) -prune -o
export RCS_TAR_IGNORE := --exclude SCCS --exclude BitKeeper --exclude .svn --exclude CVS --exclude .pc --exclude .hg --exclude .git

# ===========================================================================
# Rules shared between *config targets and build targets

# Basic helpers built in scripts/
PHONY += scripts_basic
scripts_basic:
	$(Q)$(MAKE) $(NODIRFLAG) $(build)=scripts/basic
	$(Q)rm -f .tmp_quiet_recordmcount

# # To avoid any implicit rule to kick in, define an empty command.
# scripts/basic/%: scripts_basic ;

PHONY += outputmakefile
# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.
outputmakefile:
ifneq ($(MKR_BUILD_SRC),)
	$(Q)ln -fsn $(srctree) source
	$(Q)$(MKR_SHELL) $(srctree)/scripts/mkmakefile \
	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

# To make sure we do not include .config for any of the *config targets
# catch them early, and hand them over to scripts/kconfig/Makefile
# It is allowed to specify more targets when calling make, including
# mixing *config targets and build targets.
# For example 'make oldconfig all'.
# Detect when mixed targets is specified, and make a second invocation
# of make so .config is not included in this case either (for *config).

no-dot-config-targets := clean mrproper distclean \
			 help

config-targets := 0
mixed-targets  := 0
dot-config     := 1

ifneq ($(filter $(no-dot-config-targets), $(MAKECMDGOALS)),)
	ifeq ($(filter-out $(no-dot-config-targets), $(MAKECMDGOALS)),)
		dot-config := 0
	endif
endif

ifneq ($(filter config %config,$(MAKECMDGOALS)),)
      config-targets := 1
      ifneq ($(filter-out config %config,$(MAKECMDGOALS)),)
	     mixed-targets := 1
      endif
endif

ifeq ($(mixed-targets),1)
# ===========================================================================
# We're called with mixed targets (*config and build targets).
# Handle them one by one.

%:: FORCE
	$(Q)$(MAKE) -C $(srctree) MKR_BUILD_SRC= $@

else
ifeq ($(config-targets),1)
# ===========================================================================
# *config targets only - make sure prerequisites are updated, and descend
# in scripts/kconfig to make the *config target

export MKR_CONFIG

config: scripts_basic outputmakefile FORCE
	$(Q)mkdir -p include/config
	$(Q)$(MAKE) $(NODIRFLAG) $(build)=scripts/kconfig $@

%config: scripts_basic outputmakefile FORCE
	$(Q)mkdir -p include/config
	$(Q)$(MAKE) $(NODIRFLAG) $(build)=scripts/kconfig $@

else
# ===========================================================================
# Build targets only - this includes vmlinux, arch specific targets, clean
# targets and others. In general all targets except *config targets.

# Additional helpers built in scripts/
# Carefully list dependencies so we do not try to build scripts twice
# in parallel
# PHONY += scripts
# scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
# 	$(MAKE) $(build)=$(@)

ifeq ($(dot-config),1)

_may-prefix = $(shell if expr ""$(2) : '^/' > /dev/null; then echo $(2); else echo $(1)/$(2); fi)
_newest = $(lastword $(sort $(wildcard $(strip $(1)))))
mkr-basedir = $(call _may-prefix,$(srctree),$(MKR_SRC_BASEDIR))
mksrcdir = $(call _newest,$(call _may-prefix,$(mkr-basedir),$(1)))
checksrcdir = $(if $(call mksrcdir,$($(1))),:,\
	echo Error: $(call _may-prefix,$(mkr-basedir),$($(1))) not found, see $(1); false)

# Read in config
-include include/config/auto.conf

# Read in dependencies to all Kconfig* files, make sure to run
# oldconfig if changes are detected.
-include include/config/auto.conf.cmd

# To avoid any implicit rule to kick in, define an empty command
$(MKR_CONFIG) include/config/auto.conf.cmd: ;

# If .config is newer than include/config/auto.conf, someone tinkered
# with it and forgot to run make oldconfig.
# if auto.conf.cmd is missing then we are probably in a cleaned tree so
# we execute the config step to be sure to catch updated Kconfig files
include/config/%.conf: $(MKR_CONFIG) include/config/auto.conf.cmd
	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
else
# Dummy target needed, because used as prerequisite
include/config/auto.conf: ;
endif # $(dot-config)

# The all: target is the default when no target is given on the
# command line.
# This allow a user to issue only 'make' to build a kernel including modules
# Defaults vmlinux but it is usually overridden in the arch makefile
pkg-targets = $(foreach t,$(1),$(patsubst %,%/$(t),$(packages)))

all: $(call pkg-targets,install)
PHONY += $(call pkg-targets,clean install)

# Handle descending into subdirectories listed in $(vmlinux-dirs)
# Preset locale variables to speed up the build process. Limit locale
# tweaks to this spot to avoid wrong language settings when running
# make menuconfig etc.
# Error messages still appears in the original language

linux/%:
	mkdir -p linux
	$(MAKE) $(call pkg-build,linux/) $*

confcheck-srcdirs = $(foreach p, \
			$(packages), \
			$(call checksrcdir,$($(p)/srcdir-var)) || success=false;)
confcheck-awk = type $(AWK) > /dev/null 2>&1 || { \
	echo Error: $(AWK) not found, use PATH or AWK on make command line; \
	success=false; };
confcheck-lnxmf = test -e $(linux/srcdir)/Makefile || { \
	echo Linux kernel Makefile \($(linux/srcdir)/Makefile\) not found; \
	success=false; };
sub-confcheck = { mkdir -p $(1) && \
	$(MAKE) $(call pkg-build,$(1)) $(if $(V),,-s) confcheck; } || success=false;

.mkr.basecheck: include/config/auto.conf
	$(Q)$(confcheck-awk) \
	$(confcheck-srcdirs) \
	$(confcheck-lnxmf) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

linux/.mkr.confcheck: .mkr.basecheck
	$(Q)success=:; $(call sub-confcheck,linux/) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

linux/.config: linux/.mkr.confcheck
linux/include/config/auto.conf: linux/.config

nolinux-pkgs := $(filter-out linux,$(packages))

.mkr.confcheck: linux/include/config/auto.conf
	$(Q)success=:;$(foreach t,$(nolinux-pkgs), \
				$(call sub-confcheck,$(t)/)) \
	$$success && : > $@ || { echo Configuration check failed.; false; }

# $(confcheck-targets): %: include/config/auto.conf linux/.mkr.confcheck
# 	$(Q)mkdir -p $(dir $@)
# 	$(Q)$(MAKE) $(call pkg-build,$(dir $@)) $(notdir $@)

$(call pkg-targets,clean install): %: prepare
	$(Q)echo Building $(dir $@)...
	fakeroot -s $(O)/foobar $(MAKE) $(call pkg-build,$(dir $@)) $(notdir $@)

# Things we need to do before we recursively start building the kernel
# or the modules are listed in "prepare".
# A multi level approach is used. prepareN is processed before prepareN-1.
# archprepare is used in arch Makefiles and when processed asm symlink,
# version.h and scripts_basic is processed / created.

# Listed in dependency order
PHONY += prepare archprepare prepare0 prepare1 prepare2

# prepare2 creates a makefile if using a separate output directory
prepare2: outputmakefile

prepare1: prepare2 include/config/auto.conf

archprepare: prepare1 scripts_basic

prepare0: archprepare FORCE
	$(Q)$(MAKE) $(build)=.

# All the preparing..
prepare: prepare0 .mkr.confcheck

# Generate some files
# ---------------------------------------------------------------------------

###
# make clean     Delete most generated files
# make mrproper  Delete the current configuration, and all generated files

# Directories & files removed with 'make clean'
CLEAN_DIRS  += $(packages)

# Directories & files removed with 'make mrproper'
MRPROPER_DIRS  += include scripts
MRPROPER_FILES += .config .config.old

# clean - Delete most, but leave enough to build external modules
#
clean: rm-dirs  := $(CLEAN_DIRS)

PHONY += clean

clean: $(clean-dirs)
	$(call cmd,rmdirs)
	@find . \
		\( -name '*.[oas]' -o -name '.*.cmd' -o -name '.*.d' \) \
		-type f -print | xargs rm -f

# mrproper - Delete all generated files, including .config
#
mrproper: rm-dirs  := $(wildcard $(MRPROPER_DIRS))
mrproper: rm-files := $(wildcard $(MRPROPER_FILES))

PHONY += mrproper

mrproper: clean
	$(call cmd,rmdirs)
	$(call cmd,rmfiles)

# distclean
#
PHONY += distclean

distclean: mrproper
	@find $(srctree) $(RCS_FIND_IGNORE) \
		\( -name '*.orig' -o -name '*.rej' -o -name '*~' \
		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
		-o -name '.*.rej' -o -size 0 \
		-o -name '*%' -o -name '.*.cmd' -o -name 'core' \) \
		-type f -print | xargs rm -f

# FIXME
help:
	@echo  'Cleaning targets:'
	@echo  '  clean		  - Remove most generated files but keep the config and'
	@echo  '                    enough build support to build external modules'
	@echo  '  mrproper	  - Remove all generated files + config + various backup files'
	@echo  '  distclean	  - mrproper + remove editor backup and patch files'
	@echo  ''
	@echo  'Configuration targets:'
	@$(MAKE) -f $(srctree)/scripts/kconfig/Makefile help
	@echo  ''
	@echo  'Other generic targets:'
	@echo  '  all		  - Build all targets marked with [*]'
	@echo  '  dir/            - Build all files in dir and below'
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

# Single targets
# ---------------------------------------------------------------------------
# Single targets are compatible with:
# - build with mixed source and output
# - build with separate output dir 'make O=...'
# - external modules
#
#  target-dir => where to store outputfile
#  build-dir  => directory in kernel source tree to use

build-dir  = $(patsubst %/,%,$(dir $@))
target-dir = $(dir $@)

# FIXME Should go into a make.lib or something
# ===========================================================================

quiet_cmd_rmdirs = $(if $(wildcard $(rm-dirs)),CLEAN   $(wildcard $(rm-dirs)))
      cmd_rmdirs = rm -rf $(rm-dirs)

quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files)))
      cmd_rmfiles = rm -f $(rm-files)

# read all saved command lines

targets := $(wildcard $(sort $(targets)))
cmd_files := $(wildcard .*.cmd $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))

ifneq ($(cmd_files),)
  $(cmd_files): ;	# Do not try to update included dependency files
  include $(cmd_files)
endif

endif	# skip-makefile

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)
