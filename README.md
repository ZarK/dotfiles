# Bootstrapping Your macOS Setup with Chezmoi Dotfiles

This guide helps you set up a new Mac from scratch using Homebrew and Chezmoi-managed dotfiles. Follow the steps in order.

*(Everything runs in the default Terminal until the Brewfile installs Ghostty in step 9 — switch to Ghostty after that.)*

## 1. Install 1Password (Credentials First)

Every later sign-in (Claude, GitHub, App Store extras) pulls credentials from 1Password, so it comes first. You sign in to it with the two things you carry in your head / Emergency Kit: account password and Secret Key.

1. **Install 1Password** from the Mac App Store (you signed in to your Apple ID during Setup Assistant)
2. **Launch 1Password** and sign in to your account

## 2. Install Claude Code (your AI setup assistant)

Get an AI helper before anything else is set up. The native installer needs nothing but curl — no Homebrew, no Node:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

The installer puts the binary in `~/.local/bin`, which a fresh Mac doesn't have on PATH yet — add it for this session (your dotfiles make it permanent later):

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Then start it and sign in with your Claude account (opens a browser; credentials from 1Password):

```sh
claude
```

From here on you can paste this README at Claude Code and let it drive the rest of the setup, or ask it for help whenever a step misbehaves.

## 3. Install Homebrew (standard location)

Use the official installer — it puts Homebrew in `/opt/homebrew`, installs the Xcode Command Line Tools if they're missing, and asks for your password once:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then put it on PATH for this session (your `.zprofile` handles this permanently once chezmoi applies):

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

> The standard location means bottled (pre-built) packages for everything — no building from source, and no apps confused by living outside `/Applications`.

## 4. Install GitHub CLI (`gh`)

```shell
brew install gh
```

This installs the `gh` command, which you'll use to authenticate with GitHub and manage your SSH keys.

## 5. Authenticate with GitHub (HTTPS)

Log in to your GitHub account via the CLI:

```shell
gh auth login
```

When prompted:

* Select **GitHub.com** (default).
* **Choose HTTPS** for Git operations (not SSH) when asked.
* Follow the instructions to authenticate (it will open a browser for OAuth or ask for a token).

After a successful login, `gh` is authorized to act on your behalf on GitHub (via HTTPS). You can verify by running `gh auth status` if curious.

## 6. Generate and Add an SSH Key

Next, set up SSH access for Git operations.

Each command below runs as-is and can be checked before moving on.

**a) Build a label for the key** (the `-C` comment is only a label; the hardware model beats the user-chosen Mac name, which can contain spaces and curly apostrophes — falls back to a sanitized hostname if `system_profiler` returns nothing):

  ```shell
  MODEL="$(system_profiler SPHardwareDataType 2>/dev/null | awk -F': ' '/Model Name|Chip/{printf "%s ", $2}')"
  [ -n "$MODEL" ] || MODEL="$(scutil --get ComputerName 2>/dev/null || hostname)"
  KEY_LABEL="$(whoami)@$(printf '%s' "$MODEL" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' '-' | sed -e 's/^-//' -e 's/-$//' -e 's/apple-//')"
  echo "$KEY_LABEL"
  ```

The echo should print something like `you@macbook-pro-m5-max`.

**b) Generate the key** (skips itself if one already exists). It prompts interactively: hit Enter to accept the default path, then choose a passphrase or leave it empty — don't paste anything else while it's asking:

  ```shell
  ls ~/.ssh/id_ed25519.pub 2>/dev/null || ssh-keygen -t ed25519 -C "$KEY_LABEL"
  ```

**c) Verify the key exists:**

  ```shell
  ssh-keygen -l -f ~/.ssh/id_ed25519.pub
  ```

**d) Give `gh` the key-management scope** (without it, the upload 404s):

  ```shell
  gh auth refresh -h github.com -s admin:public_key
  ```

**e) Upload the public key:**

  ```shell
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$KEY_LABEL"
  ```

**f) Verify it's on GitHub:**

  ```shell
  gh ssh-key list
  ```

**g) Add the same key as a signing key** (protected branches require signed commits; GitHub keeps signing keys separate from login keys, and this needs its own scope):

  ```shell
  gh auth refresh -h github.com -s admin:ssh_signing_key
  gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$KEY_LABEL"
  ```

`chezmoi apply` then configures git to sign every commit and tag with this key.

This command uses your logged-in GitHub CLI session to add the key to your GitHub account. If prompted for additional scopes or confirmation, follow along. After this, GitHub will trust logins from your Mac via that SSH key.

**Note:** If you set a passphrase on the key, macOS may ask for it when using the key. Consider adding the key to the ssh-agent (and macOS Keychain) for convenience, so you won't have to enter the passphrase every time.

## 7. Install Chezmoi

With Homebrew ready, install [Chezmoi](https://www.chezmoi.io/) (the dotfiles manager):

```shell
brew install chezmoi
```

This provides the `chezmoi` command, which you will use to pull down your dotfiles and apply them.

## 8. Prepare the Mac App Store

Do both before running `chezmoi init --apply`:

1. Open the **Mac App Store** app and confirm you're signed in with your Apple ID.
2. Stop the App Store from asking for authentication on every free app. Open **System Settings → your name → Media & Purchases**:
   * Turn **Use Touch ID for Purchases** off. While it's on, macOS hides the password options and requires Touch ID for every download.
   * Set **Free Downloads** (it appears once Touch ID is off) to **Never Require**.

Skip the second item and every App Store app brings up its own authentication dialog during step 9. Being signed in to App Store.app does not prevent them. Turn Touch ID for Purchases back on after step 9 if you want it.

## 9. Pull and Apply Dotfiles with Chezmoi (via SSH)

```shell
chezmoi init --apply git@github.com:ZarK/dotfiles.git
```

This command tells chezmoi to **clone your dotfiles repo over SSH** (using the `git@github.com:ZarK/dotfiles.git` URL) and immediately apply the configuration to your home directory.

* **What this does:** Chezmoi will download all your dotfiles and place them in the correct locations, applying templates if any. It will also execute any *"run once"* setup scripts in your dotfiles repo.

* **Homebrew Bundle (Brewfile):** Notably, the dotfiles repo contains a **Brewfile** and a `run_once_install.sh` script (or similarly named) that runs `brew bundle`. This script will automatically install all the Homebrew packages, casks, and fonts listed in your Brewfile. In other words, **all your apps and tools get installed for you during this step**. 🥳

  *You don't need to manually run `brew bundle` - the Chezmoi init/apply process did it via that script.* If you ever update your Brewfile, rerunning chezmoi apply or the script will install any new items.

This step installs **Ghostty**, your terminal — switch to it for the rest of your session. GUI apps land in the standard `/Applications`.

## 10. Restore Secrets and Agent Memory

Two one-time restores bring back everything that doesn't belong in a public repo:

**Shell secrets** (API keys in `~/.zshrc.local`) come from 1Password. This is the only time 1Password is involved — after this, your shell just sources the plain file:

The restore script uses the `op` CLI (installed by the Brewfile), which must first be connected to the 1Password app: open **1Password → Settings → Developer** and enable **"Integrate with 1Password CLI"**, then verify it answers:

```shell
op whoami
```

If it says the account is not signed in: unlock the 1Password app, confirm the Developer toggle is on, then connect the CLI once and pick your account when prompted:

```shell
op signin
```

Then restore:

```shell
restore-shell-secrets
```

**Agent memory** (Claude Code per-project memory, Codex memories, agent policy files) comes from the private `agent-memory` repo:

```shell
gh repo clone ZarK/agent-memory ~/Github/agent-memory
~/Github/agent-memory/restore.sh
```

Skills and commands come with the `agent-skills` repo — clone that too if it isn't already in place.

## 11. Refresh Font Cache (for Nerd Fonts)

If your Brewfile included any Nerd Fonts (commonly used for development setups), macOS might not show the new fonts immediately. To ensure they appear in your apps, refresh the macOS font cache:

```shell
fc-cache -f -v
```

You can now select the Nerd Fonts in Ghostty's settings (and in Zed).

---

## 12. Mac App Store Apps

`chezmoi apply` installs these one at a time with `mas get` (`run_once_60_setup_mas.sh`), after the Brewfile. It asks for your macOS password once (mas needs root), and gives each app at most 10 minutes so a stuck App Store dialog can't hang the setup:

- **Tailscale** (1475387142): VPN and network mesh tool
- **Slack** (803453959): team chat
- **Keynote** (409183694), **Numbers** (409203825), **Pages** (409201541): Apple iWork suite
- **Commander One** (1035236694): dual-pane file manager
- **Coffee Time** (6743958600): prevent sleep utility

Any app that fails is listed at the end of the run with the command to retry it. To retry them all:

```shell
bash ~/.local/share/chezmoi/run_once_60_setup_mas.sh
```

That's it! 🎉 When your Mac comes back up, you should have your full development environment ready to go:

* 1Password holds the keys, and Claude Code helped you get here.
* Ghostty is installed as your terminal.
* Homebrew (in `/opt/homebrew`) is managing all your packages with bottled installs.
* Your GitHub CLI is authenticated, and your SSH key is set up for Git operations.
* All your dotfiles are in place (shell config, settings, etc., courtesy of Chezmoi).
* All apps and tools from your Brewfile are installed into `/Applications`.
* Your shell secrets and agent memory are restored.
* Your Nerd Fonts are registered and ready to use (select them in Ghostty or your IDE, if needed).

Now you can start using your machine with your customized setup. Enjoy your fully bootstrapped environment!
