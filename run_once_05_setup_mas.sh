#!/usr/bin/env bash
set -euo pipefail

if ! command -v mas &>/dev/null; then
  echo "mas not found"
  exit 1
fi

if mas search "Tailscale" | grep -q "1475387142"; then
  echo "Mac App Store connectivity verified"
else
  echo "Mac App Store not accessible - ensure you're signed in to the Mac App Store app"
fi

