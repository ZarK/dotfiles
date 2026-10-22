# Bootstrapping Your macOS Setup with Chezmoi Dotfiles

This guide helps you set up a new Mac from scratch using Homebrew and Chezmoi-managed dotfiles. Follow the steps in order.

*(Everything runs in the default Terminal until the Brewfile installs Ghostty in step 10 — switch to Ghostty after that.)*

## 1. Install Claude Code (your AI setup assistant)

Get an AI helper before anything else. The native installer needs nothing but curl — no Homebrew, no Node:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

Then start it and sign in with your Claude account (opens a browser):

```sh
claude
```

From here on you can paste this README at Claude Code and let it drive the rest of the setup, or ask it for help whenever a step misbehaves.

## 2. Install 1Password (Early Setup)

Before continuing, set up 1Password for credential management:

```shell
# Create the ~/Applications folder for user-installed apps
mkdir -p ~/Applications
```

1. **Install 1Password** from the Mac App Store (search for "1Password")
2. **Move 1Password** from `/Applications` to `~/Applications` (drag and drop in Finder)
3. **Launch 1Password** from `~/Applications` and sign in to your account

This early setup ensures you have secure credential management available throughout the bootstrap process. You'll need it in step 11 to restore your shell secrets.

## 3. Install Homebrew in `~/.homebrew` (Local User Install)

Install Homebrew locally (to avoid any system-wide changes):

```shell
cd ~
# Download Homebrew into .homebrew (no sudo needed)
mkdir -p .homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar -xz --strip-components 1 -C .homebrew
```

**Note:** The PATH setup, updates, and permissions will be properly configured when you run chezmoi later. For now, just having Homebrew downloaded is sufficient.

> **Note:** The above uses Homebrew's "untar anywhere" approach to install it in your home directory. We avoid the default `/usr/local` or `/opt/homebrew` to keep everything local to your user.

## 4. Install XCode Command Line Tools

These are required to install further developer tools like GitHub CLI

```shell
xcode-select --install
```

## 5. Install GitHub CLI (`gh`)

Now use Homebrew to install the GitHub CLI tool:

```shell
~/.homebrew/bin/brew install gh
```

This installs the `gh` command, which you'll use to authenticate with GitHub and manage your SSH keys.

## 6. Authenticate with GitHub (HTTPS)

Log in to your GitHub account via the CLI:

```shell
gh auth login
```

When prompted:

* Select **GitHub.com** (default).
* **Choose HTTPS** for Git operations (not SSH) when asked.
* Follow the instructions to authenticate (it will open a browser for OAuth or ask for a token).

After a successful login, `gh` is authorized to act on your behalf on GitHub (via HTTPS). You can verify by running `gh auth status` if curious.

## 7. Generate and Add an SSH Key

Next, set up SSH access for Git operations.

**Generate a new SSH key** (if you don't have one on this machine). Use an Ed25519 key for security:

  ```shell
  ssh-keygen -t ed25519 -C "{email}"
  # Hit Enter to accept the default file path (~/.ssh/id_ed25519). Choose a passphrase (or leave empty for no passphrase) and confirm.
  ```

**Add the SSH key to GitHub**. First, ensure GitHub CLI has the required scopes, then upload your public key:

  ```shell
  # Refresh GitHub auth with required scopes
  gh auth refresh -h github.com -s admin:public_key

  # Add SSH key with sanitized title
  USER=$(whoami)
  HOST=$(scutil --get ComputerName | tr -d "''\"" | tr ' ' '_')
  TITLE="$USER@$HOST"
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$TITLE"
  ```

This command uses your logged-in GitHub CLI session to add the key to your GitHub account. If prompted for additional scopes or confirmation, follow along. After this, GitHub will trust logins from your Mac via that SSH key.

**Note:** If you set a passphrase on the key, macOS may ask for it when using the key. Consider adding the key to the ssh-agent (and macOS Keychain) for convenience, so you won't have to enter the passphrase every time.

## 8. Install Chezmoi

With Homebrew ready, install [Chezmoi](https://www.chezmoi.io/) (the dotfiles manager):

```shell
brew install chezmoi
```

This provides the `chezmoi` command, which you will use to pull down your dotfiles and apply them.

## 9. Sign in to Mac App Store

Open the **Mac App Store** app and sign in with your Apple ID before running `chezmoi init --apply`. This lets Homebrew Bundle attempt the Mac App Store installs in your Brewfile. If they are skipped or fail, rerun `brew bundle --file ~/.local/share/chezmoi/Brewfile` after signing in.

## 10. Pull and Apply Dotfiles with Chezmoi (via SSH)

```shell
chezmoi init --apply git@github.com:ZarK/dotfiles.git
```

This command tells chezmoi to **clone your dotfiles repo over SSH** (using the `git@github.com:ZarK/dotfiles.git` URL) and immediately apply the configuration to your home directory.

* **What this does:** Chezmoi will download all your dotfiles and place them in the correct locations, applying templates if any. It will also execute any *"run once"* setup scripts in your dotfiles repo.

* **Homebrew Bundle (Brewfile):** Notably, the dotfiles repo contains a **Brewfile** and a `run_once_install.sh` script (or similarly named) that runs `brew bundle`. This script will automatically install all the Homebrew packages, casks, and fonts listed in your Brewfile. In other words, **all your apps and tools get installed for you during this step**. 🥳

  *You don't need to manually run `brew bundle` - the Chezmoi init/apply process did it via that script.* If you ever update your Brewfile, rerunning chezmoi apply or the script will install any new items.

This step installs **Ghostty**, your terminal — switch to it for the rest of your session.

## 11. Restore Secrets and Agent Memory

Two one-time restores bring back everything that doesn't belong in a public repo:

**Shell secrets** (API keys in `~/.zshrc.local`) come from 1Password. This is the only time 1Password is involved — after this, your shell just sources the plain file:

```shell
restore-shell-secrets
```

**Agent memory** (Claude Code per-project memory, Codex memories, agent policy files) comes from the private `agent-memory` repo:

```shell
gh repo clone ZarK/agent-memory ~/Github/agent-memory
~/Github/agent-memory/restore.sh
```

Skills and commands come with the `agent-skills` repo — clone that too if it isn't already in place.

## 12. Refresh Font Cache (for Nerd Fonts)

If your Brewfile included any Nerd Fonts (commonly used for development setups), macOS might not show the new fonts immediately. To ensure they appear in your apps, refresh the macOS font cache:

```shell
fc-cache -f -v
```

You can now select the Nerd Fonts in Ghostty's settings (and in Zed).

---

## 13. Mac App Store Apps

The following Mac App Store apps are attempted during the `brew bundle` step (provided you completed step 9):

- **Tailscale** (1475387142): VPN and network mesh tool
- **Slack** (803453959): team chat
- **Keynote** (409183694), **Numbers** (409203825), **Pages** (409201541): Apple iWork suite
- **Infuse** (1136220934): video player
- **CleanMyMac** (1339170533): system maintenance
- **Commander One** (1035236694): dual-pane file manager
- **Coffee Time** (6743958600): prevent sleep utility

These apps are handled by the `mas` command line tool during the `brew bundle` step. On current macOS versions, `mas account` is not a reliable health check, and installs may still require you to be signed in to App Store.app and to rerun `brew bundle --file ~/.local/share/chezmoi/Brewfile` afterward.

That's it! 🎉 When your Mac comes back up, you should have your full development environment ready to go:

* Claude Code is installed and helped you get here.
* Ghostty is installed as your terminal.
* Homebrew (in `~/.homebrew`) is managing all your packages locally.
* Your GitHub CLI is authenticated, and your SSH key is set up for Git operations.
* All your dotfiles are in place (shell config, settings, etc., courtesy of Chezmoi).
* All apps and tools from your Brewfile are installed.
* Your shell secrets and agent memory are restored.
* Your Nerd Fonts are registered and ready to use (select them in Ghostty or your IDE, if needed).

Now you can start using your machine with your customized setup. Enjoy your fully bootstrapped environment!
