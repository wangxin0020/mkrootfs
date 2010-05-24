#! /usr/bin/awk -f

match($0, /MKR_([0-9A-Z_]*)/, sym) {
	rest = $0
	do {
		if (sym[1] != "SHELL")
			list[gensub(/_/, "/", "g", tolower(sym[1]))] = 1;
		rest = substr(rest, RSTART + RLENGTH + 1);
	} while (match(rest, /MKR_([0-9A-Z_]*)/, sym));
}

END {
	printf("mkr-optdeps :=");
	for (s in list)
		printf(" \\\n    $(wildcard $(O)/include/config/"s".h)");
	printf("\n\n$(mkr-optdeps): ;\n\nmkr-deps :=");
	printf(" \\\n    $(mkr-optdeps)")
	printf(" \\\n    .mkr.makefile.deps");
	printf(" \\\n    .mkr.srcdir");
	printf(" \\\n    $(O)/.mkr.toolchain");
	printf(" \\\n    "FILENAME);
	printf(" \\\n    $(srctree)/scripts/Makefile.pkgbuild")
	printf(" \\\n    scripts/makefile-deps.awk");
	printf("\n");
}
