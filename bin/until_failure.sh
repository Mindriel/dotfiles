#!/usr/bin/env bash
set -e

#while $@; do :; done
#exit 0

# Alternative version:
TIMES=$1
shift

for (( i=1; i<=$TIMES; i++ )); do
   echo -e "\n=============================== Running $i time ============================\n"
   $@
done

