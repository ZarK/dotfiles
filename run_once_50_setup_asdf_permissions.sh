#!/usr/bin/env bash
set -euo pipefail

# Fix asdf permissions if needed
if [ -f "/opt/homebrew/opt/asdf/libexec/asdf.sh" ] && [ ! -x "/opt/homebrew/opt/asdf/libexec/asdf.sh" ]; then
  chmod +x "/opt/homebrew/opt/asdf/libexec/asdf.sh"
  echo "Fixed asdf permissions"
fi

