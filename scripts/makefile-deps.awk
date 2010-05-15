#! /usr/bin/awk -f

match($0, /MKR_([0-9A-Z_]*)/, sym) {
	do {
		if (sym[1] != "SHELL")
			list[gensub(/_/, "/", "g", tolower(sym[1]))] = 1;
		rest = substr($0, RSTART + RLENGTH + 1);
	} while (match(rest, /MKR_([0-9A-Z_]*)/, sym));
}

END {
	printf("pkg-opt-deps :=");
	for (s in list)
		printf(" \\\n    $(O)/include/config/"s".h");
	printf("\n\n$(pkg-opt-deps): ;\n\npkg-deps :=");
	printf(" \\\n    $(pkg-opt-deps)")
	printf(" \\\n    "FILENAME);
	printf(" \\\n    .mkr.makefile.deps");
	printf(" \\\n    scripts/makefile-deps.awk");
	printf("\n");
}
