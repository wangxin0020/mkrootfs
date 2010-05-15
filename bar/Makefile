config.status: $(pkg-deps)
ifneq ($(MKR_FOO_OPT),)
	@echo configuring bar with FOO_OPT
else
	@echo configuring bar without FOO_OPT
endif
	@: > $@

install: config.status
	@echo installing bar

