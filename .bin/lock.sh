#!/bin/bash

HELPERS_DIR=$(dirname "$0")/helpers
. ${HELPERS_DIR}/req_exitOnFirstFail
. ${HELPERS_DIR}/req_noSudo
. ${HELPERS_DIR}/req_noArgs

cd $(dirname "$0")

if [ "$1" ] && [ "$1" != "fun" ]; then
  echo "Nope $1 !"
  exit 1
fi

# Constants
IMAGES_DIR="$HOME/O"
ANGRY_OWLS="${IMAGES_DIR}/AngryOwls"
WALLPAPERS="${IMAGES_DIR}/Wallpapers"
CYCATY_Z_WIEDZMINA="${IMAGES_DIR}/cytaty-z-opowiesci-o-wiedzminie-andrzeja-sapkowskiego"

# Proper script
CHOSEN_IMAGE="${CYCATY_Z_WIEDZMINA}"

if [ "$1" == "fun" ]; then
  scrot
  CHOSEN_IMAGE=$(ls *scrot* | sort -V | tail -n 1)
fi

if [ -d ${CHOSEN_IMAGE} ]; then
  LIST=($(ls ${CHOSEN_IMAGE}/*.png))
  N=`ls ${CHOSEN_IMAGE}/*.png | wc -l`
  R=$(( ( RANDOM % ${N} ) ))
  CHOSEN_IMAGE="${LIST[${R}]}"
fi

if [ -f ${CHOSEN_IMAGE} ]; then
  echo "PNG file: ${CHOSEN_IMAGE}"
else
  echo "ERROR! No such file: ${CHOSEN_IMAGE}"
  exit 2
fi

i3lock --image="${CHOSEN_IMAGE}" --color=000033 --tiling #--no-unlock-indicator

if [ "$1" == "fun" ]; then
  rm ${CHOSEN_IMAGE} 2> /dev/null
fi
