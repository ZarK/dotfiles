###############################################################################
# Formulae (CLI tools installed into /opt/homebrew/bin)
###############################################################################

brew "asdf"                     # runtime version manager
brew "starship"                 # prompt
brew "zoxide"                   # smart cd
brew "fzf"                      # fuzzy finder
brew "ripgrep"                  # fast grep
brew "fd"                       # find replacement
brew "eza"                      # modern ls
brew "bat"                      # cat with syntax
brew "gh"                       # GitHub CLI
brew "python@3.12"              # Python 3.12
brew "git"                      # git CLI tools
brew "chezmoi"                  # dot-file manager (self-host)
brew "uv"                       # package manager for Python
brew "fontconfig"               # font configuration library for better font management
brew "mas"                      # Mac App Store CLI
brew "tmux"                     # terminal multiplexer
brew "coreutils"                # GNU core utilities
brew "czkawka"                  # duplicate file utility
brew "ffmpeg"                   # media conversion and processing tools
brew "imagemagick"              # image conversion and processing
brew "exiftool"                 # read/write media metadata
brew "rsync"                    # file sync, newer than the macOS built-in
brew "shellcheck"               # shell script linter
brew "shfmt"                    # shell script formatter
brew "marksman"                 # Markdown LSP (used by Zed)
brew "bats-core"                # Bash test framework
# pnpm installs standalone via run_once_30 (needs no node; node comes from asdf)
# claude / opencode / codex CLIs install via their own installers, not brew

###############################################################################
# Casks (GUI apps / fonts)
###############################################################################
cask_args adopt: true               # adopt manually pre-installed apps instead of failing
cask "ghostty"                      # terminal
# 1Password app comes from the Mac App Store in README step 1 (before brew exists)
cask "1password-cli"
cask "font-hack-nerd-font"
cask "font-fira-code-nerd-font"
cask "raycast"
cask "vivaldi"
cask "zed"
cask "cursor"
cask "visual-studio-code"
cask "claude"
cask "chatgpt"
cask "obsidian"
cask "orbstack"
cask "displaylink"              # DisplayLink Manager for docked monitors
cask "vlc"
cask "keka"
cask "beekeeper-studio"          # SQL editor (beekeeperstudio.io)
cask "licecap"                   # animated screen capture (cockos.com)
# Not in Homebrew — install manually from official sources:
#   Task Manager TMOG (com.tmog.taskmanager)
#   Grok Bot (com.anysphere.sand — legit: developed inside Cursor/Anysphere,
#   branded as a Grok product after the xAI acquisition)
cask "proton-drive"
cask "proton-mail"
cask "protonvpn"
# cask "tailscale"  # Requires system components; installed via mas below

###############################################################################
# Mac App Store apps
###############################################################################
# Not listed here: run_once_60_setup_mas.sh installs them one at a time with
# `mas get` (brew bundle would try every app twice and can block chezmoi apply).
