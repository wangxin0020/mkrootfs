ifneq ($(MKR_ARCH_ARM),)
.mkr.eabi: $(mkr-deps)
	$(Q)CFLAGS="$(shell echo $(cflags-y))"; \
	$(CC) -o $@ $$CFLAGS -E $(mkr-pkgdir)/arm-eabi-check.h

-include .mkr.eabi

# Invalid configurations:
# CONFIG_AEABI CONFIG_OABI_COMPAT MKR_ARM_EABI
#     y			n		n
#     n			*		y

confcheck-$(MKR_ARM_EABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_AEABI)" != "y", \
		EABI toolchain but EABI not enabled in kernel configuration)

confcheck-$(CONFIG_AEABI) += \
	$(call confcheck-if, \
		test "$(CONFIG_OABI_COMPAT)" != "y" \
			-a "$(MKR_ARM_EABI)" != "y", \
		EABI-only kernel with non-EABI toolchain)
endif

confcheck: default-confcheck

install-staging:

install:
