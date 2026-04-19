#!/usr/bin/env bash
set -euo pipefail

AI_HOME="${AI_HOME:-$HOME/.ai}"

if command -v brew >/dev/null 2>&1; then
	BREW_BIN="$(command -v brew)"
else
	BREW_BIN="${HOMEBREW_PREFIX:-$HOME/.homebrew}/bin/brew"
fi

require_cmd() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf 'Missing required command: %s\n' "$1" >&2
		exit 1
	fi
}

if [ ! -x "$BREW_BIN" ]; then
	printf 'Homebrew was not found at %s\n' "$BREW_BIN" >&2
	printf 'Install or fix Homebrew first, then rerun %s/install.sh\n' "$AI_HOME" >&2
	exit 1
fi

mkdir -p "$HOME/models"

"$BREW_BIN" tap jundot/omlx https://github.com/jundot/omlx >/dev/null 2>&1 || true

if ! command -v node >/dev/null 2>&1; then
	"$BREW_BIN" install node
fi

if ! command -v omlx >/dev/null 2>&1; then
	"$BREW_BIN" install omlx
fi

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

if ! command -v openclaw >/dev/null 2>&1; then
	if command -v bun >/dev/null 2>&1; then
		bun add --global openclaw@latest
	else
		require_cmd npm
		npm install -g openclaw@latest
	fi
fi

printf 'AI tooling is installed.\n'
printf 'Next steps:\n'
printf '  1. source ~/.zshrc\n'
printf '  2. ai-model download --manifest\n'
printf '  3. ai-serve start\n'
printf '  4. ai-openclaw configure\n'
