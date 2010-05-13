install: $(deps)
	@echo see if we need and make foo
ifneq ($(CONFIG_FOO),)
	@echo making foo!
	@: > $@
endif

clean:
	$(RM) all
