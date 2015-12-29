#!/bin/sh
modules=" \
	boot \
	configfile \
	crypto \
	gettext \
	iso9660 \
	memdisk \
	part_gpt \
	part_msdos \
	search \
	tar \
	terminal"

pkgsrc="$1"; shift
source="$1"; shift
dest="$1"; shift

modlist="$dest/modules.list"

set -e

add_module()
{
    if grep -q $1 $modlist; then
	return
    fi

    echo $1 >> $modlist

    set -- `grep "^$m:" x86_64-efi/moddep.lst`
    shift
    while test $# -ge 1; do
	add_module $1
	shift
    done
}

# grub-mkstandalone -o bootx64.efi -O x86_64-efi -C auto --modules="part_gpt part_msdos iso9660" boot/grub/grub.cfg

rm -Rf "$dest/x86_64-efi" "$dest/boot"
mkdir -p "$dest/boot/grub/x86_64-efi" "$dest/x86_64-efi"
cd "$dest"
cp "$pkgsrc/grub-standalone.cfg" boot/grub/grub.cfg
cp "$source"/*.lst boot/grub/x86_64-efi

cp "$source/moddep.lst" "$source/kernel.img" x86_64-efi
: > $modlist
for m in $modules; do
    add_module $m
done
while read m; do
    cp $source/${m}.mod x86_64-efi
done < $modlist

tar cf memdisk.tar boot

grub-mkimage  -o bootx64.efi.tmp -O x86_64-efi -C xz -d `pwd`/x86_64-efi \
    -m memdisk.tar -p '(memdisk)/boot/grub' $modules
rm -Rf x86_64-efi boot memdisk.tar $modlist
mv bootx64.efi.tmp bootx64.efi
