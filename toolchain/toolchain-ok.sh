#! /bin/sh

arch=$1; shift
cc=$1; shift
LIBDIRS="$1"; shift
BINDIRS="$1"; shift

die()
{
    echo ${1+"$@"} >&2
    exit 1
}

if test -z "$LIBDIRS"; then
    die No directory where to search for libraries
fi

cross=`expr $cc : '\(.*\)gcc'`

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
		*Blackfin) sr_arch=bfin;;
		*"Nios II") sr_arch=nios2;;
		"PowerPC64") sr_arch=ppc64;;
		"PowerPC") sr_arch=ppc;;
		*386) sr_arch=i686;;
		*X86-64) sr_arch=x86_64;;
		*) die Unrecognized machine type "$mach";;
	    esac

	    if test "$sr_arch" == "$arch"; then
		exit 0
	    else
		die Architecture mismatch, libc found in sysroot \($f\) is for $sr_arch whereas selected architecture is $arch
	    fi
	fi
    done
done

die No libc found in the following directories: $LIBDIRS
