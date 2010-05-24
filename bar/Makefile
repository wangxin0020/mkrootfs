install:

config.status: $(mkr-deps)
	@echo '$?' changed !
ifneq ($(MKR_FOO_OPT),)
	@echo configuring bar with FOO_OPT
else
	@echo configuring bar without FOO_OPT
endif
	@: > $@

install: config.status
	@echo scrdir: $(mkr-srcdir)
	@echo installing bar
