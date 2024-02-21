#!/usr/bin/env bash
set -euo pipefail
set -x

IMAGE="$(
  nix build \
    --json \
    --print-build-logs \
    --builders "" \
    --max-jobs 2 \
    --eval-store auto \
    --store ssh-ng://eu.nixbuild.net \
    --system x86_64-linux \
    .#container | \
    jq -r '.[0].outputs.out'
)"

nix copy \
  --from ssh-ng://eu.nixbuild.net \
  --no-check-sigs \
  "$IMAGE"

docker load < "$IMAGE"
