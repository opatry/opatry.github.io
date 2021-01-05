#!/usr/bin/env bash

set -euo pipefail

# do not use GitHub Actions hashFiles('output/**'), it doesn't seem to take file names into account
if [ -d "$1" ]; then
  find "$1" -type f -print0 | sort -z | xargs -0 shasum | shasum | cut -d ' ' -f1
else
  echo ""
fi
