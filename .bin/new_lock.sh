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

RESOLUTION_REGEX="[0-9]\+x[0-9]\+"
RESOLUTION=`xdpyinfo | grep -o "dimensions:[ ]\+${RESOLUTION_REGEX}" | grep -o "${RESOLUTION_REGEX}"`
#RESOLUTIONS=`xrandr | grep '*' | grep -o "${RESOLUTION_REGEX}"`

RESOLUTION_REGEX="[0-9]\+x[0-9]\++[0-9]\++[0-9]\+"
RESOLUTIONS=`xrandr | grep ' connected' | grep -o "${RESOLUTION_REGEX}"`
echo "Resolution:  ${RESOLUTION}"
echo -e "\n  Resolutions:\n${RESOLUTIONS} \n  Resolutions.\n"

######
# LEFT 1600x900+0+908
######
LEFT_IMAGE="/tmp/left.png"
TMP_IMAGE="/tmp/lockscreen.png"
RESOLUTION="1600x900" #HACK
EXTENT="1600x1808" #HACK
convert "${CHOSEN_IMAGE}" -resize ${RESOLUTION} -size ${RESOLUTION} xc:black +swap -gravity center -composite "${TMP_IMAGE}"
convert "${TMP_IMAGE}" -background white -gravity south -extent ${EXTENT} "${LEFT_IMAGE}"

######
# MIDDLE 1080x1920+1600+0
######
MIDDLE_IMAGE="/tmp/middle.png"
TMP_IMAGE="/tmp/lockscreen.png"
RESOLUTION="1080x1920" #HACK
EXTENT="1080x1920" #HACK
convert "${CHOSEN_IMAGE}" -resize ${RESOLUTION} -size ${RESOLUTION} xc:black +swap -gravity center -composite "${TMP_IMAGE}"
convert "${TMP_IMAGE}" -background white -gravity south -extent ${EXTENT} "${MIDDLE_IMAGE}"

######
# RIGHT 1920x1080+2680+412
######
RIGHT_IMAGE="/tmp/right.png"
TMP_IMAGE="/tmp/lockscreen.png"
RESOLUTION="1920x1080" #HACK
EXTENT="1920x1492" #HACK
convert "${CHOSEN_IMAGE}" -resize ${RESOLUTION} -size ${RESOLUTION} xc:black +swap -gravity center -composite "${TMP_IMAGE}"
convert "${TMP_IMAGE}" -background white -gravity south -extent ${EXTENT} "${RIGHT_IMAGE}"

######
# Glue and lock
######
echo "Temp lockscreen image: ${LEFT_IMAGE}"
echo "Temp lockscreen image: ${MIDDLE_IMAGE}"
echo "Temp lockscreen image: ${RIGHT_IMAGE}"
LOCK_IMAGE="/tmp/lockscreen.png"
#montage [0-5].png -tile 5x1 -geometry +0+0 ${LOCK_IMAGE}
montage ${LEFT_IMAGE} ${MIDDLE_IMAGE} ${RIGHT_IMAGE} -tile 3x1 -geometry +0+20 ${LOCK_IMAGE}
echo "Montaged lockscreen image: ${LOCK_IMAGE}"

ls -ltah /tmp/*.png
identify /tmp/*.png

#i3lock --image="${LOCK_IMAGE}" --color=000033 --tiling

if [ "$1" == "fun" ]; then
  rm ${CHOSEN_IMAGE} 2> /dev/null
fi
