#!/usr/bin/env sh
set -e
[ $# -gt 0 ] && exit 2
sudo mount -t vboxsf shared /media/shared
