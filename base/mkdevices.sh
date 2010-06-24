#! /bin/sh

ROOTFS=$1
IFS="$IFS,"
while read type major minor file; do

    case "$type" in
    b*) test -e $ROOTFS$file || $SUDO mknod $ROOTFS$file b $major $minor;;
    c*) test -e $ROOTFS$file || $SUDO mknod $ROOTFS$file c $major $minor;;
    d*) mkdir -p $ROOTFS$major;;
    esac
done
