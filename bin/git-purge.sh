#!/bin/bash

HELPERS_DIR=$(dirname "$0")/helpers
. ${HELPERS_DIR}/req_exitOnFirstFail
. ${HELPERS_DIR}/req_noSudo
. ${HELPERS_DIR}/req_noArgs

GIT_IGNORE=".gitignore"
BACKUP=".gitignore_backup"

if [ -f .gitignore ]; then
  cp ${GIT_IGNORE} ${BACKUP}
  echo -e ".idea/\n${BACKUP}" > ${GIT_IGNORE}
  git clean -df
  mv ${BACKUP} ${GIT_IGNORE}
else
  echo -e "No '.gitignore' found.\n  Doing simple 'git clean -df'."
  git clean -df
fi
