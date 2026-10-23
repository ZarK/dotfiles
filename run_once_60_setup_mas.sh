#!/usr/bin/env bash
set -uo pipefail

# Installs Mac App Store apps one at a time with `mas get`, which handles both
# never-gotten free apps and previously gotten ones. This script NEVER exits
# nonzero and never hangs chezmoi apply: each app gets a time limit, and a
# failed or timed-out app is reported at the end with the command to retry.
# Apps live here, not in the Brewfile: brew bundle runs `mas install` and then
# `mas get` for the same batch, doubling every App Store dialog, and a stuck
# dialog there blocks every later run_once script.

MAS="/opt/homebrew/bin/mas"
TIMEOUT="/opt/homebrew/bin/gtimeout"
PER_APP_SECONDS=600

APPS=(
  "1475387142 Tailscale"
  "803453959 Slack"
  "409183694 Keynote"
  "409203825 Numbers"
  "409201541 Pages"
  "1035236694 Commander One"
  "6743958600 Coffee Time"
)

if [ ! -x "$MAS" ]; then
  echo "WARNING: mas not found at $MAS - skipping Mac App Store apps."
  echo "Install it (brew install mas), then run: bash ~/.local/share/chezmoi/run_once_60_setup_mas.sh"
  exit 0
fi

# coreutils (Brewfile) provides gtimeout; without it, run with no time limit.
run_limited() {
  if [ -x "$TIMEOUT" ]; then
    "$TIMEOUT" "$PER_APP_SECONDS" "$@"
  else
    "$@"
  fi
}

installed_ids="$("$MAS" list 2>/dev/null | awk '{print $1}')"

missing=()
for entry in "${APPS[@]}"; do
  id="${entry%% *}"
  grep -qx "$id" <<<"$installed_ids" || missing+=("$entry")
done

if [ "${#missing[@]}" -eq 0 ]; then
  echo "Mac App Store apps: everything installed."
  exit 0
fi

echo "Installing ${#missing[@]} Mac App Store app(s) one at a time."
echo "If an App Store dialog appears for every app, Free Downloads is not set to"
echo "Never Require (README step 8); answer the dialogs or let each one time out."

# mas needs root to install; ask for the sudo password once, up front.
if ! sudo -v; then
  echo "WARNING: no sudo credentials - skipping Mac App Store apps."
  exit 0
fi

failed=()
for entry in "${missing[@]}"; do
  id="${entry%% *}"
  name="${entry#* }"
  echo "==> $name ($id)"
  sudo -n -v 2>/dev/null || sudo -v || true
  if ! run_limited sudo "$MAS" get "$id"; then
    failed+=("$entry")
  fi
done

echo ""
if [ "${#failed[@]}" -eq 0 ]; then
  echo "Mac App Store apps: everything installed."
else
  echo "WARNING: these Mac App Store apps were not installed:"
  for entry in "${failed[@]}"; do
    echo "  ${entry#* }: sudo mas get ${entry%% *}"
  done
  echo "Or rerun this script: bash ~/.local/share/chezmoi/run_once_60_setup_mas.sh"
  echo "Or get them by hand in App Store.app."
fi

exit 0
