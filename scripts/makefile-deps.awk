#! /usr/bin/awk -f

match($0, /MKR_([0-9A-Z_]*)/, sym) {
	do {
		if (sym[1] != "SHELL")
			list[gensub(/_/, "/", "g", tolower(sym[1]))] = 1;
		rest = substr($0, RSTART + RLENGTH + 1);
	} while (match(rest, /MKR_([0-9A-Z_]*)/, sym));
}

END {
	printf("mkr-pkg-optdeps :=");
	for (s in list)
		printf(" \\\n    $(O)/include/config/"s".h");
	printf("\n\n$(mkr-pkg-optdeps): ;\n\nmkr-pkgdeps :=");
	printf(" \\\n    $(mkr-pkg-optdeps)")
	printf(" \\\n    "FILENAME);
	printf(" \\\n    .mkr.makefile.deps");
	printf(" \\\n    scripts/makefile-deps.awk");
	printf("\n");
}
