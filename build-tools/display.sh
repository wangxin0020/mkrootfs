#! /bin/sh

set -e

mutex_lock()
{
    mutex="$1"

    while ! (set -C; echo $$ > "$mutex") > /dev/null 2>&1; do
	if owner=`cat "$mutex" 2> /dev/null` && ! kill -0 "$owner"; then
	    rm -f "$mutex"
	elif test -n "$owner" -a "$owner" = $$; then
	    echo "mutex_lock: we (pid $$) already own mutex $mutex"
	fi
	sleep 0.1
    done
}

mutex_unlock()
{
    mutex="$1"

    if test -e "$mutex" && test $$ = `cat "$mutex"`; then
	rm -f "$mutex"
	return 0
    fi

    if ! test -e "$mutex"; then
	echo "mutex_unlock: mutex $mutex does not exist"
	return -1
    fi

    echo "mutex_unlock: we (pid $$) do not own mutex $mutex (owned by `cat "$mutex"`)"
    return -1
}

cmd="$1"; shift

case "$cmd" in
    "lock") mutex_lock .mkr.displaylock;;
    "unlock") mutex_unlock .mkr.displaylock;;
    "locked-echo") mutex_lock .mkr.displaylock
	echo ${1+"$@"}
	mutex_unlock .mkr.displaylock
	;;
    *) echo Unknown command "$cmd"
	exit 1
	;;
esac
