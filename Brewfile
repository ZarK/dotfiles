###############################################################################
# Formulae (CLI tools installed into /opt/homebrew/bin)
###############################################################################
tap "jundot/omlx", "https://github.com/jundot/omlx"

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
brew "omlx"                     # local MLX inference server
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
# brew "bun"  # Cannot be installed via Homebrew, installed by run_once_install_other.sh
# claude / opencode / codex CLIs install via their own installers, not brew

###############################################################################
# Casks (GUI apps / fonts)
###############################################################################
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
cask "google-drive"
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
# Mac App Store apps (installed via mas)
###############################################################################
# Note: You need to be signed in to the Mac App Store app for these to work
# Homebrew Bundle attempts these installs during `brew bundle`
# If they are skipped or fail, sign in to App Store.app and rerun:
#   brew bundle --file="$HOME/.local/share/chezmoi/Brewfile"
mas "Tailscale", id: 1475387142
mas "Slack", id: 803453959
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Infuse", id: 1136220934
mas "CleanMyMac", id: 1339170533
mas "Commander One", id: 1035236694
mas "Coffee Time", id: 6743958600
