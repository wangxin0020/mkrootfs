#! /bin/sh

reset
stty sane
eval `resize`
width=`expr "$COLUMNS" '*' 80 / 100`
height=`expr "$LINES" '*' 80 / 100`
menuheight=`expr "$height" '*' 80 / 100`

step=0
while :; do
    case "$step" in
	0)
	    cat > /tmp/menu <<EOF
--clear --no-cancel --menu "What to do next?" $height $width $menuheight
1 "Get a shell"
2 "Run xeno-test"
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		case `cat /tmp/choice` in
		    1)
			console=`sed 's/.*console=\([^, ]*\).*$/\1/;t;s/.*/tty1/' /proc/cmdline`
			clear
			exec /sbin/getty -n -l /sbin/autologin.sh 0 "$console"
			;;
		    2)
			step=1
			;;
		esac
	    fi
	    ;;
	1)
	    cat > /tmp/menu<<EOF
--clear --cancel-label Back --scrollbar --menu "Choose a partition for I/O stress (data on the partition are not destroyed)" $height $width $menuheight
none ""
EOF
	    for f in /mnt/*; do
		part=`basename $f`
		fstype=`sed 's,^/dev/'"$part"' [^ ]* \([^ ]*\).*$,\1,;t;d' /proc/mounts`
		case "$part" in
		    sd[a-z][0-9]*)
			dev=`expr "$part" : '\(sd[a-z]\)'`
			desc=`/usr/bin/sdinfo "/dev/$dev"`
			echo "$part \"$fstype $desc\""
			;;
		    hd[a-z][0-9]*|mmcblk*p*|md[0-9]*p*)
			echo "$part $fstype"
			;;
		esac
	    done >> /tmp/menu

	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		iostress=`cat /tmp/choice`
		step=2
	    else
		clear
		exit 1
	    fi
	    ;;
	2)
	    cat > /tmp/menu <<EOF
--clear --cancel-label Back --menu "Choose the program used to create load" $height $width $menuheight
LTP ""
Hackbench ""
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		case `cat /tmp/choice` in
		    LTP)
			load="-l /ltp"
			step=4
			;;
		    Hackbench)
			step=3
			;;
		esac
	    else
		step=1
	    fi
	    ;;
	3)
	    if test "$load" = "-l /ltp"; then
		step=2
		continue
	    fi
	    cat > /tmp/menu <<EOF
--clear --cancel-label Back --inputbox "Test duration in seconds" $height $width 7200
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		load="-b /ltp/testcases/bin/hackbench `cat /tmp/choice`"
		step=4
	    else
		step=2
	    fi
	    ;;
	4)
	    cat > /tmp/menu <<EOF
--clear --cancel-label Back --inputbox "Choose the IP used to create network load (leave empty for no network load)" $height $width
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		server=`cat /tmp/choice`
		if test -z "$server"; then
		    step=6
		else
		    step=5
		fi
	    else
		step=3
	    fi
	    ;;
	5)
	    if test -z "$server"; then
		step=4
		continue
	    fi
	    cat > /tmp/menu <<EOF
--clear --cancel-label Back --inputbox "Choose the port number used to create network load" $height $width 9
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		port=`cat /tmp/choice`
		step=6
	    else
		step=4
	    fi
	    ;;
	6)
	    cat > /tmp/menu <<EOF
--clear --cancel-label Back --inputbox "Latency test period in micro-seconds" $height $width 100
EOF
	    if dialog --colors --file /tmp/menu 2> /tmp/choice; then
		latency_period=`cat /tmp/choice`
		step=7
	    else
		step=5
	    fi
	    ;;
	7)
	    break
	    ;;
	esac
done

reset
if test -n "$server"; then
    dohell_opts="-s $server"
fi
if test -n "$port"; then
    dohell_opts="$dohell_opts -p $port"
fi
dohell_opts="$dohell_opts $load"
if test "$iostress" != "none"; then
    dohell_opts="-m /mnt/$iostress $dohell_opts"
fi
xeno-test -l "dohell $dohell_opts" -- -p $latency_period -g /root/histo
echo Latency results have been saved in /root/histo, they can be processed
echo with the gnuplot script scripts/histo.gp in xenomai sources

console=`sed 's/.*console=\([^, ]*\).*$/\1/;t;s/.*/tty1/' /proc/cmdline`
exec /sbin/getty -n -l /sbin/autologin.sh 0 "$console"
