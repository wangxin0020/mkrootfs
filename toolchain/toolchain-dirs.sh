#! /bin/sh

compiler=${1+"$@"}
cross=`expr "$compiler" : '\(.*\)gcc'`
BINDIRS=
LIBDIRS=

set -e

# Find out to which ELF class belong the executables this compiler produces
echo "int foo(void) { return 0; }"|$compiler -xc -o .elfclass.o -c -
elfclass=`${cross}readelf -h .elfclass.o | grep Class: | cut -d: -f2`

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
	if [ -e "$d" ]; then \
            testfile="\`ls "$d"/lib*.so.[0-9]|head -1\`" ; \
	    _elfclass=\`${cross}readelf -h "$testfile" | grep Class: | cut -d: -f2\` ;
	    test "$_elfclass" = "$elfclass" && cd "$d" && pwd; \
	fi; \
    done | sort -u`
    BINDIRS=`for d in $LIBDIRS; do \
	for subd in bin ../bin sbin ../sbin ../debug-root/usr/bin; do \
	    if [ -e "$d/$subd" ]; then \
		cd "$d/$subd" && pwd; \
	    fi \
	done \
    done | sort -u`
fi

LIBDIRS=`echo $LIBDIRS`
BINDIRS=`echo $BINDIRS`

cat <<EOF
LIBDIRS=`echo $LIBDIRS`
BINDIRS=`echo $BINDIRS`
EOF
