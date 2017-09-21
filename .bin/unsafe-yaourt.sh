#!/bin/bash
set -e
export MAKEPKG="makepkg --skippgpcheck" && yaourt $1 --noconfirm
