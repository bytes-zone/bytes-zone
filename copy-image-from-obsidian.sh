#!/usr/bin/env bash
set -euo pipefail

SRC="${@:-}"
if test -z "$SRC"; then
  echo "USAGE: ${0:-} filename.png"
  exit 1
fi

DEST="$(sed -E 's/ +/-/g' <<< "$SRC")"

cp "$HOME/Notes/media/$SRC" "static/images/$DEST"
