#!/bin/bash

fullname=$(basename "$1")
#extension="${fullname##*.}"  # does not work for files without ext
extension=$([[ "$fullname" = *.* ]] && echo ".${fullname##*.}" || echo '')
filename="${fullname%.*}"
outfname=${filename}_PRETTY.json

echo   "\$1        : $1"
echo    "fullname  : $fullname"
echo    "extension : $extension"
echo    "filename  : $filename"
echo -e "\nOutput filename: $outfname\n"

python -m json.tool "$1" > "$outfname"

