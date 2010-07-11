#! /bin/sh

srctree="$1"; shift
basedirs="$1"; shift
srcdir="$1"

case "$srcdir" in
~*|/*)
	{ ls -1d $srcdir | sort -r | head -n 1; } 2> /dev/null
	exit 0
	;;
esac

# Path is relative
IFS=:
for basedir in $basedirs; do
    eval basedir="$basedir"
    case "$basedir" in
	/*) ;;
	*) basedir="$srctree/$basedir"
	    ;;
    esac

    result=`{ ls -1d "$basedir"/$srcdir | sort -r | head -n 1; } 2> /dev/null`
    if [ -n "$result" ]; then
	echo $result
	exit 0
    fi
done
exit 1
