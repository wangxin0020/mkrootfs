#! /usr/bin/awk -f

match($0, /MKR_([0-9A-Z_]*)/) {
	rest = $0
	do {
		sym = tolower(substr(rest, RSTART, RLENGTH));
		gsub(/^mkr_/, "", sym);
		gsub(/_/, "/", sym);
		list[sym] = 1;
		rest = substr(rest, RSTART + RLENGTH + 1);
	} while (match(rest, /MKR_([0-9A-Z_]*)/));
}

END {
	printf("mkr-optdeps :=");
	for (s in list)
		printf(" \\\n    $(wildcard $(O)/include/config/"s".h)");
	printf("\n\n$(mkr-optdeps): ;\n\ndeps +=");
	printf(" \\\n    $(mkr-optdeps)")
	printf(" \\\n    .mkr.makefile.deps");
	printf(" \\\n    .mkr.srcdir");
	printf(" \\\n    $(O)/.mkr.toolchain");
	printf(" \\\n    "FILENAME);
	printf(" \\\n    $(srctree)/build-tools/Makefile.pkgbuild")
	printf(" \\\n    $(srctree)/build-tools/makefile-deps.awk\n")
	printf("\ndeps32 +=");
	printf(" \\\n    $(mkr-optdeps)")
	printf(" \\\n    .mkr.makefile.deps");
	printf(" \\\n    .mkr.srcdir");
	printf(" \\\n    $(O)/.mkr.toolchain32");
	printf(" \\\n    "FILENAME);
	printf(" \\\n    $(srctree)/build-tools/Makefile.pkgbuild")
	printf(" \\\n    $(srctree)/build-tools/makefile-deps.awk");
	printf("\n");
}
