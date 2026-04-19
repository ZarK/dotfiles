#!/usr/bin/env bash
set -euo pipefail

# Fix asdf permissions if needed
if [ -f "$HOME/.homebrew/opt/asdf/libexec/asdf.sh" ] && [ ! -x "$HOME/.homebrew/opt/asdf/libexec/asdf.sh" ]; then
  chmod +x "$HOME/.homebrew/opt/asdf/libexec/asdf.sh"
  echo "Fixed asdf permissions"
fi

