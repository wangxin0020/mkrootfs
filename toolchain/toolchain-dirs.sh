#! /bin/sh

compiler=${1+"$@"}
BINDIRS=
LIBDIRS=

set -e

# Get the directories
if $compiler --print-sysroot > /dev/null 2>&1; then
    sysroot=`$compiler --print-sysroot`
    for subd in sbin usr/sbin bin usr/bin usr/lib/bin usr/lib/sbin; do
	if [ -e "$sysroot/$subd" ]; then
	    BINDIRS="$BINDIRS `cd $sysroot/$subd && pwd`"
	fi
    done
    for subd in lib usr/lib; do
	if [ -e "$sysroot/$subd" ]; then
	    LIBDIRS="$LIBDIRS `cd $sysroot/$subd && pwd`"
	fi
    done
else
    tmp_libdirs=`$compiler --print-search-dirs \
	| sed 's/^libraries: =\(.*\)$/\1/;t next;d;:next y/:/ /'`
    LIBDIRS=`for d in $tmp_libdirs; do \
	if [ -e "$d" ]; then \
	    cd "$d" && pwd; \
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
