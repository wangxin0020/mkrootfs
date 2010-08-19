#! /bin/sh

set -e

test -n "$MDEV"

mount /dev/$MDEV /mnt
test -e /mnt/swap || dd if=/dev/zero of=/mnt/swap bs=1M count=500
mkswap /mnt/swap
swapon /mnt/swap
mount -o remount,size=500M /tmp
