#!/usr/bin/env sh

### Written so it is POSIX compliant. Does not require bash, can be run on dash, bash and any other POSIX compliant shell.

#readlink /proc/$$/exe
set -e

BASE_DIR=${1-"$HOME/repos"}
#SKIPS=('^.*[/-]build[/-].*$' 'sth_else') # bash
#SKIPS='^.*[/-]build[/-].*$ sth_else' # POSIX shell
SKIPS=`cat ~/bin/fetchAllRepos.SKIPS` # POSIX shell from file

[ -d "$1" ] && shift
[ $# != 0 ] && exit 1

fetchAll() {
  local FETCH_FAILED=''
  #for dir in ${GITS[@]}; do # bash
  #echo ${GITS} | tr ' ' '\n' | while read dir; do # this runs in a sub shell
  #for dir in $(echo ${GITS} | tr ' ' '\n'); do # can't handle spaces in paths
  find "$BASE_DIR" -name '.git' | while read dir; do
    if [ ! -e "$dir" ]; then
      echo "No such path as $dir" >&2
      exit 2
    fi
    local tmp="`dirname "$dir"`"
    local SKIP_FLAG=''

    #for skip in ${SKIPS[@]}; do # bash
    #echo ${SKIPS} | tr ' ' '\n' | while read skip; do # this runs in a sub shell
    for skip in $(echo ${SKIPS} | tr ' ' '\n'); do
      ( echo "$tmp" | grep -Eq ${skip} ) && SKIP_FLAG='true'
    done

    if [ -n "$SKIP_FLAG" ]; then
      printf ' -> %-100s skipped\n' "$tmp"
    else
      cd "$tmp"
      #local A=(`git remote`) # bash
      local A=`git remote`
      #printf ' -> %-100s remotes: %s\n' "$tmp" "${#A[@]}" # bash
      #remotes=`echo ${A} | tr ' ' '\n' | wc -l`
      local remotes=`echo ${A} | tr '\n' ' '`
      printf ' -> %-100s remotes: %s\n' "$tmp" "$remotes"
      #for a in ${A[@]}; do #bash
      for a in $(echo ${A}); do
        git fetch "$a" --tags --prune --prune-tags || FETCH_FAILED='true'
      done
    fi
  done

  if [ -n "$FETCH_FAILED" ]; then
    echo '' >&2
    echo 'A fetch failed, please check above prints' >&2
  fi
}

#GITS=(`find "$BASE_DIR" -name '.git'`) # bash
#GITS=`find "$BASE_DIR" -name '.git'` # can't handle spaces in paths
fetchAll
