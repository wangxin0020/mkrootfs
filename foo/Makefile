install: $(deps)
	@echo see if we need and make foo $(mkr-pkgdir)
	@echo MAKEFLAGS: $(MAKEFLAGS)
ifneq ($(CONFIG_FOO),)
	@echo making foo!
	@: > $@
endif

clean:
	$(RM) all
