#! /bin/sh

arch=$1; shift
LIBDIRS="$1"; shift
BINDIRS="$1"; shift
cc=${1+"$@"};

die()
{
    echo ${1+"$@"} >&2
    exit 1
}

if test -z "$LIBDIRS"; then
    die No directory where to search for libraries
fi

cross=`expr "$cc" : '\(.*\)gcc'`

for d in $LIBDIRS; do
    for f in $d/libc.so.[0-9] $d/libuClibc*.so $d/libc.a; do
	if test -e $f; then
	    if ! ${cross}readelf -h $f > /dev/null 2>&1; then
		die ${cross}readelf -h $f failed
	    fi
	    mach=`${cross}readelf -h $f \
		| sed 's/^  Machine: *\(.*\)$/\1/;t quit;d; :quit q'`
	    if test -z "$mach"; then
		die Machine not found in ${cross}readelf -h $f output
	    fi

	    case "$mach" in
		"ARM") sr_arch=arm;;
		"AArch64") sr_arch=aarch64;;
		*Blackfin) sr_arch=bfin;;
		*"Nios II") sr_arch=nios2;;
		"PowerPC64") sr_arch=ppc64;;
		"PowerPC") sr_arch=ppc;;
		*386) sr_arch=i686;;
		*X86-64) sr_arch=x86_64;;
		*"SuperH SH") sr_arch=sh4;;
		*) die Unrecognized machine type "$mach (expecting $arch type)";;
	    esac

	    if test "$sr_arch" = "$arch"; then
		exit 0
	    fi
	fi
    done
done

die No libc/$arch found in the following directories: $LIBDIRS
