#! /bin/sh

SUFFIX=
case "$1" in
--32)
	SUFFIX=32
	shift
	;;
esac

compiler=${1+"$@"}
cross=`expr "$compiler" : '\(.*\)gcc'`
BINDIRS=
LIBDIRS=

set -e

# Find out to which ELF class belong the executables this compiler produces
tmpfile=".elfbin${SUFFIX}"
echo "int main(void) { return 0; }" | $compiler -xc -o "$tmpfile" -
elfclass=`${cross}readelf -h "$tmpfile" | grep Class: | cut -d: -f2`
elfloader=`${cross}readelf -l "$tmpfile" | \
sed 's/^.*interpreter: \([^]]*\).*$/\1/;t quit;d;t;:quit q'`
rm -f "$tmpfile"

# Get the directories
sysroot=`$compiler --print-sysroot 2>/dev/null`
if test -n "$sysroot" -a \! "$sysroot" = /; then
    for subd in sbin usr/sbin bin usr/bin usr/lib/bin usr/lib/sbin ../debug-root/usr/bin; do
	if [ -e "$sysroot/$subd" ]; then
	    BINDIRS="$BINDIRS `cd $sysroot/$subd && pwd`"
	fi
    done
    for subd in lib lib/arm-linux-gnueabihf usr/lib usr/lib/arm-linux-gnueabihf ../lib; do
	if [ -e "$sysroot/$subd" ]; then
	    LIBDIRS="$LIBDIRS `cd $sysroot/$subd && pwd`"
	fi
    done
else
    tmp_libdirs=`$compiler --print-search-dirs \
	| sed 's/^libraries: =\(.*\)$/\1/;t next;d;:next y/:/ /'`
    LIBDIRS=`for d in $tmp_libdirs; do \
	set -- "$d"/lib*.so.[0-9]; \
	[ -e "$1" ] || continue; \
	_elfclass=\`${cross}readelf -h "$1" | grep Class: | cut -d: -f2\` ;
	test "$_elfclass" = "$elfclass" && cd "$d" && pwd; \
    done | sort -u`
    BINDIRS=`for d in $LIBDIRS; do \
	for subd in bin ../bin sbin ../sbin ../debug-root/usr/bin; do \
	    if [ -d "$d/$subd" ]; then \
		cd "$d/$subd" && pwd; \
	    fi \
	done \
    done | sort -u`
fi

# Find the loader in the toolchain directories
loaderbase=`basename $elfloader`
for d in $LIBDIRS; do
    [ -e "$d/$loaderbase" ] || continue
    LOADER_SRC="$d/$loaderbase"
    break
done

# Find the loader fallback directory
for d in `strings -a $LOADER_SRC | grep '^/lib'`; do
    if [ -z "$LOADER_FALLBACK" ]; then
	LOADER_FALLBACK=`expr "$d" : '\(.*\)/'`
    fi
    if [ "$d" = "/lib/" ]; then
	LOADER_FALLBACK=""
	break
    fi
done

LIBDIRS=`echo $LIBDIRS`
BINDIRS=`echo $BINDIRS`
LOADER=`echo $elfloader`
LOADER_SRC=`echo $LOADER_SRC`
LOADER_FALLBACK=`echo $LOADER_FALLBACK`

cat <<EOF
LIBDIRS${SUFFIX}=`echo $LIBDIRS`
BINDIRS${SUFFIX}=`echo $BINDIRS`
LOADER${SUFFIX}=`echo $LOADER`
LOADER_SRC${SUFFIX}=`echo $LOADER_SRC`
LOADER_FALLBACK${SUFFIX}=`echo $LOADER_FALLBACK`
EOF
