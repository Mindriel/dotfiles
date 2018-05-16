#!/usr/bin/env bash
set -ex
test $# = 0

TARGET_FILE="$HOME/.bashrc"
test -f "$TARGET_FILE"

PRETTY_RC_TILDE='~/dotfiles/bin/pretty.rc'
PRETTY_RC="$HOME/dotfiles/bin/pretty.rc"
test -f "$PRETTY_RC"

GITUJ=true

echo '' >> "$TARGET_FILE"
echo '##v pretty.rc v##' >> "$TARGET_FILE"

echo ". $PRETTY_RC_TILDE" >> "$TARGET_FILE"
echo 'PATH="$HOME/dotfiles/bin:$PATH"' >> "$TARGET_FILE"

### Recommended additions:
echo 'PATH="$HOME/bin:$PATH"' >> "$TARGET_FILE"
if [ "$GITUJ" = 'true' ]; then
  echo "GITUJ=${GITUJ}" >> "$TARGET_FILE"
fi

echo '#^# pretty.rc #^#' >> "$TARGET_FILE"
