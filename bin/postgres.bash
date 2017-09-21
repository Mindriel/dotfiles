#!/usr/bin/env bash

HELPERS_DIR=$(dirname "$0")/helpers
. ${HELPERS_DIR}/req_exitOnFirstFail
. ${HELPERS_DIR}/req_noSudo
#. ${HELPERS_DIR}/req_noArgs
if [ $# != 1 ]; then
  echo "Usage: $(basename $0) <database>"
  exit 2
fi
DBS=(
  data
  zxc
)
DB=""
for elem in "${DBS[@]}"; do [[ $elem == "$1" ]] && DB=$elem || without+=("$elem"); done

if [ "$DB" == "" ]; then
  echo "For <database> choose one of:"
  printf " * %s\n" "${DBS[@]}"
  exit 3
fi

X=("a" "b c" "-d" "k j", "-f")
for elem in "${X[@]}"; do [[ $elem == -* ]] && with+=("$elem") || without+=("$elem"); done
printf "with:\n"
printf " * %s\n" "${with[@]}"
printf "without:\n"
printf " * %s\n" "${without[@]}"
exit 123

sudo rm -r /run/postgresql 2> /dev/null || true
sudo mkdir /run/postgresql
sudo chown postgres:postgres /run/postgresql
sudo su - postgres -c 'postgres -D $HOME/data'
