#! /bin/sh

eval `resize`
width=`expr "$COLUMNS" '*' 80 / 100`
height=`expr "$LINES" '*' 80 / 100`
menuheight=`expr "$height" '*' 80 / 100`

for f in /usr/share/keymaps/*; do
    map=`basename $f .kmap.bin.xz`
    echo $map \"\"
done > /tmp/menu

if dialog --scrollbar --menu "Choose a keyboard map" $height $width $menuheight  --file /tmp/menu 2> /tmp/lang; then
    loadkeys `cat /tmp/lang`
fi
reset
