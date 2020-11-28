#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nodePackages.node2nix coreutils
set -euo pipefail

cd "$(dirname "$(realpath "${0:-}")")"
node2nix .
