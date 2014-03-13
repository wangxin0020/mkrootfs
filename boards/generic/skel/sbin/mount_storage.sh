#! /bin/sh

set -e

if test -z "$MDEV"; then
    MDEV=@MKR_SWAP_DEV@
fi

mntpt=/mnt/$MDEV

case "$ACTION" in
remove)
    if test "$MDEV" = @MKR_SWAP_DEV@; then
	mount -o remount,size=64M /tmp
	swapoff $mntpt/swap
    fi
    fstype=`sed 's,^/dev/'"$MDEV"' [^ ]* \([^ ]*\).*$,\1,;t;d' /proc/mounts`
    umount -f "/dev/$MDEV"
    test -n "$fstype" && modprobe -r "$fstype"
    ;;

add)
    mkdir -p $mntpt
    fstype=`blkid "/dev/$MDEV" | sed 's,.*TYPE="\(.*\)",\1,;t;d'`
    if test "$fstype" = "ntfs" -a -e /sbin/mount.ntfs-3g; then
	mount.ntfs-3g /dev/$MDEV $mntpt
    elif test -n "$fstype"; then
	mount -t "$fstype" /dev/$MDEV $mntpt
    else
	mount /dev/$MDEV $mntpt
    fi

    if test "$MDEV" = @MKR_SWAP_DEV@; then
	test -e $mntpt/swap || dd if=/dev/zero of=/mnt/swap bs=1M count=500
	mkswap $mntpt/swap
	swapon $mntpt/swap
	mount -o remount,size=500M /tmp
    fi
    ;;
esac
