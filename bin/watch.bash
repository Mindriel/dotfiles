#!/usr/bin/env bash
set -e
test $# = 1
NAME=$1 && shift
while [ true ]; do
  ps aux | grep "$NAME" | grep -v "$0 $NAME" | grep -v "grep $NAME" || true
  sleep 1
  echo '=========='
done

