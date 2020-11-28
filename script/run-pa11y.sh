#!/usr/bin/env bash
set -euo pipefail

zola serve &
ZOLA="$!"
trap 'kill $ZOLA' EXIT

while true; do
  if lsof -i :1111 | grep -q zola; then
    break
  fi
  sleep 1
done

EXIT=0

for url in localhost:1111 localhost:1111/kitchen-sink; do
  if ! pa11y -E pre --runner axe "$url"; then
    EXIT=1
  fi
done

exit "$EXIT"
