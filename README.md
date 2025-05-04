# Bootstrapping Your macOS Setup with Chezmoi Dotfiles

This guide helps you  set up a new Mac from scratch using Homebrew and Chezmoi-managed dotfiles. Follow the steps in order. 

*(Begin in the default Terminal for Step 1, then switch to Warp for all subsequent steps.)*

## 1. Install Warp Terminal

Install **Warp**, a modern Terminal app for macOS, using the official installation script. Run the following command in the default Terminal (not Warp):

```sh
curl https://warp.dev/install.sh | bash
```

For more details, visit [https://warp.dev](https://warp.dev).

Once Warp is installed, launch it and perform the rest of the setup in Warp.

## 2. Install Homebrew in `~/.homebrew` (Local User Install)

With Warp open, install Homebrew locally (to avoid any system-wide changes).

> This setup is also available as a Warp Workflow with the alias `init-homebrew`. You can run it instantly in Warp by searching for or typing `init-homebrew`. Alternatively, run the commands below manually:

```shell
cd ~
# Download Homebrew into .homebrew (no sudo needed)
mkdir -p .homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar -xz --strip-components 1 -C .homebrew

# Set up Homebrew in the PATH for the current session
eval "$(./homebrew/bin/brew shellenv)"

# Update Homebrew and fix permissions (as recommended by Homebrew)
brew update --force --quiet
chmod -R go-w "$(./homebrew/bin/brew --prefix)/share/zsh"
```

> **Note:** The above uses Homebrew’s “untar anywhere” approach to install it in your home directory. We avoid the default `/usr/local` or `/opt/homebrew` to keep everything local to your user.

## 3. Install GitHub CLI (`gh`)

Now use Homebrew to install the GitHub CLI tool. In Warp, run:

```shell
brew install gh
```

This installs the `gh` command, which you’ll use to authenticate with GitHub and manage your SSH keys.

## 4. Authenticate with GitHub (HTTPS)

Log in to your GitHub account via the CLI:

```shell
gh auth login
```

When prompted:

* Select **GitHub.com** (default).
* **Choose HTTPS** for Git operations (not SSH) when asked.
* Follow the instructions to authenticate (it will open a browser for OAuth or ask for a token).

After a successful login, `gh` is authorized to act on your behalf on GitHub (via HTTPS). You can verify by running `gh auth status` if curious.

## 5. Generate and Add an SSH Key

Next, set up SSH access for Git operations.

> You can run these steps instantly as Warp Workflows with the aliases `init-ssh-key` (for key generation) and `init-github-key` (for GitHub upload). Both workflows prompt for your email and automatically generate a descriptive, sanitized key title.

**Generate a new SSH key** (if you don’t have one on this machine). Use an Ed25519 key for security:

  ```shell
  ssh-keygen -t ed25519 -C "{email}"
  # Hit Enter to accept the default file path (~/.ssh/id_ed25519). Choose a passphrase (or leave empty for no passphrase) and confirm.
  ```

**Add the SSH key to GitHub**. Upload your public key to GitHub with the CLI, using a sanitized title:

  ```shell
  USER=$(whoami)
  HOST=$(scutil --get ComputerName | tr -d "’'\"" | tr ' ' '_')
  TITLE="$USER@$HOST"
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$TITLE"
  ```

This command uses your logged-in GitHub CLI session to add the key to your GitHub account. If prompted for additional scopes or confirmation, follow along. After this, GitHub will trust logins from your Mac via that SSH key.

**Note:** If you set a passphrase on the key, macOS may ask for it when using the key. Consider adding the key to the ssh-agent (and macOS Keychain) for convenience, so you won’t have to enter the passphrase every time.

## 6. Install Chezmoi

With Homebrew ready, install [Chezmoi](https://www.chezmoi.io/) (the dotfiles manager):

```shell
brew install chezmoi
```

This provides the `chezmoi` command, which you will use to pull down your dotfiles and apply them.

## 7. Pull and Apply Dotfiles with Chezmoi (via SSH)

> You can run this step instantly as a Warp Workflow with the alias `init-chezmoi`, or run the following command manually in Warp:

```shell
chezmoi init --apply git@github.com:ZarK/dotfiles.git
```

This command tells chezmoi to **clone your dotfiles repo over SSH** (using the `git@github.com:ZarK/dotfiles.git` URL) and immediately apply the configuration to your home directory.

* **What this does:** Chezmoi will download all your dotfiles and place them in the correct locations, applying templates if any. It will also execute any *“run once”* setup scripts in your dotfiles repo.

* **Homebrew Bundle (Brewfile):** Notably, the dotfiles repo contains a **Brewfile** and a `run_once_install.sh` script (or similarly named) that runs `brew bundle`. This script will automatically install all the Homebrew packages, casks, and fonts listed in your Brewfile. In other words, **all your apps and tools get installed for you during this step**. 🥳

  *You don’t need to manually run `brew bundle` — the Chezmoi init/apply process did it via that script.*  If you ever update your Brewfile, re-running the chezmoi apply or the script will install any new items.

## 8. Refresh Font Cache (for Nerd Fonts)

If your Brewfile included any Nerd Fonts (commonly used for development setups), macOS might not show the new fonts immediately. To ensure they appear in your apps and in Warp, refresh the macOS font cache:

```shell
fc-cache -f -v
```

You can now select the Nerd Fonts in Warp settings.

---

That’s it! 🎉 When your Mac comes back up, you should have your full development environment ready to go:

* Warp is installed as your Terminal.
* Homebrew (in `~/.homebrew`) is managing all your packages locally.
* Your GitHub CLI is authenticated, and your SSH key is set up for Git operations.
* All your dotfiles are in place (shell config, settings, etc., courtesy of Chezmoi).
* All apps and tools from your Brewfile are installed.
* Your Nerd Fonts are registered and ready to use (remember to select them in Warp or your IDE, if needed).

Now you can start using your machine with your customized setup. Enjoy your fully bootstrapped environment!
