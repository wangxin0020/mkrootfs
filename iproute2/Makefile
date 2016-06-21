rootfs-y +=					\
	/etc/iproute2/bpf_pinning		\
	/etc/iproute2/ematch_map		\
	/etc/iproute2/group			\
	/etc/iproute2/nl_protos			\
	/etc/iproute2/rt_dsfield		\
	/etc/iproute2/rt_protos			\
	/etc/iproute2/rt_realms			\
	/etc/iproute2/rt_scopes			\
	/etc/iproute2/rt_tables			\
	/sbin/bridge				\
	/sbin/ctstat				\
	/sbin/genl				\
	/sbin/ifcfg				\
	/sbin/ifstat				\
	/sbin/ip				\
	/sbin/lnstat				\
	/sbin/nstat				\
	/sbin/routef				\
	/sbin/routel				\
	/sbin/rtacct				\
	/sbin/rtmon				\
	/sbin/rtpr				\
	/sbin/rtstat				\
	/sbin/ss				\
	/sbin/tc				\
	/sbin/tipc				\
	/usr/lib/tc/experimental.dist		\
	/usr/lib/tc/m_ipt.so			\
	/usr/lib/tc/m_xt.so			\
	/usr/lib/tc/normal.dist			\
	/usr/lib/tc/pareto.dist			\
	/usr/lib/tc/paretonormal.dist

IPROUTE2_MAKEFILES=$(shell cd $(srcdir) && find . -name Makefile)

$(IPROUTE2_MAKEFILES): %Makefile: $(srcdir)/%Makefile $(deps)
	mkdir -p ./$*
	{ echo srcdir=$(srcdir)/$*; echo 'VPATH = $$(srcdir)'; echo 'CFLAGS += -I$$(srcdir) -I$$(srcdir)/../include'; grep -v '^srcdir' $<; } > $@

Config: $(IPROUTE2_MAKEFILES) $(srcdir)/configure
	$(configure-env-y) $(srcdir)/configure $(configure-args-y)
	$(configure-env-y) $(MAKE) clean

$(mkr-configured): Config

compile: default-autotools-compile

staging: default-autotools-staging

rootfs: default-rootfs

clean: default-clean
