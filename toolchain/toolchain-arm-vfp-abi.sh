#! /bin/sh
# Some ARM toolchains (CodeSourcery for instance) generate soft-float binaries
# even with the -mfpu option. -mfloat-abi=softfp must be added in that case

set -e

ARM_VFP_ABI=
compiler=${1+"$@"}
cross=`expr "$compiler" : '\(.*\)gcc'`

tmpfile=".vfpbin"
echo "int main(void) { return 0; }" | $compiler -xc -o "$tmpfile" -
abi=`${cross}readelf -h "$tmpfile" | \
sed 's/^.*Flags:.*hard-float ABI.*$/hard-float/;t quit;d;:quit q'`
rm "$tmpfile"

if [ "$abi" = "hard-float" ]; then
    echo ARM_VFP_ABI=-mfloat-abi=hard
else
    echo ARM_VFP_ABI=-mfloat-abi=softfp
fi
