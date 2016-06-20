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
    fstype=`blkid "/dev/$MDEV" | sed 's,.*TYPE="\([^"]*\)".*,\1,;t;d'`
    umount -f "/dev/$MDEV"
    test -n "$fstype" && modprobe -r "$fstype"
    rmdir "$mntpt"
    ;;

add)
    mkdir -p $mntpt
    fstype=`blkid "/dev/$MDEV" | sed 's,.*TYPE="\([^"]*\)".*,\1,;t;d'`

    case "$fstype" in
	*fat*)
	    if test -x /usr/sbin/fsck.fat; then
		/usr/sbin/fsck.fat -waV "/dev/$MDEV" || :
	    fi
	    ;;
	ext2)
	    if test -x /usr/sbin/e2fsck; then
		/usr/sbin/e2fsck -p "/dev/$MDEV" || :
	    fi
	    ;;
    esac

    if test "$fstype" = "swap"; then
	if swapon /dev/$MDEV; then
	    size=`awk '/^\/dev\/'"$MDEV"'/ { print $3 }' /proc/swaps`
	    mount -o remount,size=${size}k /tmp
	fi
	rmdir $mntpt
    elif test "$fstype" = "ntfs" -a -e /sbin/mount.ntfs-3g; then
	mount.ntfs-3g /dev/$MDEV $mntpt || { rmdir $mntpt; exit 1; }
    elif test -n "$fstype"; then
	mount -t "$fstype" /dev/$MDEV $mntpt || { rmdir $mntpt; exit 1; }
    else
	mount /dev/$MDEV $mntpt || { rmdir $mntpt; exit 1; }
    fi

    if test "$MDEV" = @MKR_SWAP_DEV@; then
	test -e $mntpt/swap || {
	    if [ ! -e /dev/zero ]; then
		mknod /dev/zero c 1 5
	    fi
	    dd if=/dev/zero of=$mntpt/swap bs=1M count=500
	}
	mkswap $mntpt/swap
	swapon $mntpt/swap
	mount -o remount,size=500M /tmp
    fi
    ;;
esac
