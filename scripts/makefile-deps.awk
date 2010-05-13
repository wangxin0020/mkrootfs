#! /usr/bin/awk -f

match($0, /CONFIG_([0-9A-Z_]*)/, sym) {
	do {
		list[gensub(/_/, "/", "g", tolower(sym[1]))] = 1;
		rest = substr($0, RSTART + RLENGTH + 1);
	} while (match(rest, /CONFIG_([0-9A-Z_]*)/, sym));
}

END {
	printf("deps :=");
	printf(" \\\n    "FILENAME);
	printf(" \\\n    .mkr.makefile.deps");
	for (s in list)
		printf(" \\\n    $(O)/include/config/"s".h");
	printf("\n");
}
