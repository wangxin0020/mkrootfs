board-config = $(srctree)/boards/$(MKR_BOARD_NAME)/busybox-defconfig
defconfig-$(MKR_BUSYBOX_BOARD_DEFCONFIG) = $(MAKE) $(args) defconfig
defconfig-$(MKR_BUSYBOX_BOARD_CONFIG) = \
	if test -e "$(board-config)"; then \
		echo Resetting Busybox configuration to $(board-config); \
		cp $(board-config) .config; \
	else \
		echo "No board config found (tried $(board-config))"; \
		exit 1; \
	fi

# Configuring busybox
args := V=$(KBUILD_VERBOSE) SKIP_STRIP=y -C $(srcdir) O=$(CURDIR) \
	CC="$(CC)" CXX="$(CXX)" LD="$(CC) -nostdlib" AR="$(cross)ar" \
	EXTRA_CFLAGS="$(MKR_CFLAGS)" \
	EXTRA_LDFLAGS="$(MKR_LDFLAGS)" \
	CROSS_COMPILE="$(cross)"

../.busybox_config: \
	$(O)/include/config/arch.h \
	$(O)/include/config/board/name.h \
	$(wildcard $(O)/include/config/busybox/board/config.h \
		$(O)/include/config/busybox/board/defconfig.h)
	$(Q)$(defconfig-y)
	$(Q)sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)mv .config $@

.config: ../.busybox_config
	$(Q)cmp -s $< $@ || cp $< $@

.mkr.config: .config
	$(Q)tail -n +6 $< > .tmp.$@
	$(Q)if cmp -s .tmp.$@ $@; then rm .tmp.$@; else mv .tmp.$@ $@; fi

mkr-config:
	@echo Resetting busybox configuration to $(board-config); \
	$(Q)$(defconfig-y)
	$(Q)sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)cp .config ../.busybox_config

$(mkr-configured): .mkr.config ../.mkr.builddir .mkr.srcdir $(deps)

include/autoconf.h: $(mkr-configured)
	test -f Makefile && $(MAKE) $(args) distclean || :
	cp ../.busybox_config .config
	yes "" | $(MAKE) $(args) oldconfig
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config

# Building busybox
compile: include/autoconf.h
	$(MAKE) $(args)
	$(Q)cp .config ../.busybox_config

# Installing it
staging:
	$(MAKE) $(args) install

rootfs: default-copyall-rootfs

# Checking configuration
confcheck-$(call not,$(defconfig)) += \
	$(call confcheck-exists $(board-config),MKR_BUSYBOX_CONFIG)

confcheck: default-confcheck

clean: .config
	$(MAKE) $(args) $@

# Catch-all target, allow to run all the *config targets
%config: .config
	$(MAKE) $(args) $@
	sed -i 's,^CONFIG_PREFIX=.*$$,CONFIG_PREFIX="$(pkginst)",' .config
	$(Q)cp .config ../.busybox_config

$(pkgdir)/Kconfig: ;
