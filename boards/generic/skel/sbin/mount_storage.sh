#! /bin/sh

set -e

if test -z "$MDEV"; then
    MDEV=@MKR_SWAP_DEV@
fi

mntpt=/mnt/$MDEV
mkdir -p $mntpt
fsopt=`blkid "/dev/$MDEV" | sed 's,.*TYPE="\(.*\)",-t \1,;t;d'`
mount $fsopt /dev/$MDEV $mntpt

if test "$MDEV" = @MKR_SWAP_DEV@; then
    test -e $mntpt/swap || dd if=/dev/zero of=/mnt/swap bs=1M count=500
    mkswap $mntpt/swap
    swapon $mntpt/swap
    mount -o remount,size=500M /tmp
fi
