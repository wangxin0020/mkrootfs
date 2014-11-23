#! /bin/sh

src=$2
srcdir=$(dirname $src)
common=${srcdir%/} 
dest=${1%/}/
while test "${dest#"$common"/}" = "$dest"; do
    common=${common%/*} up=../$up
done
dest=$up${dest#"$common"/}; 
dest=${dest%/}
dest=${dest:-.}

mkdir -p $srcdir
ln -s $dest $src
