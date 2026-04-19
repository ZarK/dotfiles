#!/usr/bin/env bash
set -euo pipefail

BREWFILE="$HOME/.local/share/chezmoi/Brewfile"

if ! command -v mas &>/dev/null; then
  echo "mas is not installed yet; Mac App Store apps were not checked."
  exit 0
fi

if mas search "Tailscale" | grep -q "1475387142"; then
  cat <<EOF
Mac App Store connectivity looks OK.
Mac App Store apps are attempted during `brew bundle`, not by this script.
If any MAS apps are still missing, rerun:
  brew bundle --file="$BREWFILE"
EOF
else
  cat <<EOF
Mac App Store apps were not installed.
Sign in to App Store.app, then rerun:
  brew bundle --file="$BREWFILE"
EOF
fi
