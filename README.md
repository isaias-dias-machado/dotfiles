# dotfiles

Personal configuration files, managed as symlinks from this repository.

## Layout

```
dotfiles/
├── .gitignore
├── README.md
├── install.sh                  # links every config module; no sudo, no network
├── verify.sh                   # checks that every expected symlink is correct
├── modules/
│   ├── helpers.sh              # shared functions (sourced, never executed)
│   ├── shell.sh                # ~/.bashrc
│   ├── git.sh                  # shared git settings + generated ~/.gitconfig
│   ├── vim.sh                  # ~/.vim, ~/.vimrc
│   ├── neovim.sh               # ~/.config/nvim
│   ├── tmux.sh                 # ~/.tmux.conf
│   ├── kitty.sh                # ~/.config/kitty
│   ├── zellij.sh               # ~/.config/zellij
│   ├── opencode.sh             # ~/.config/opencode (file-level)
│   ├── vscodium.sh             # ~/.config/VSCodium/User (file-level)
│   ├── scripts.sh              # ~/scripts
│   ├── misc.sh                 # ~/.tool-versions, ~/.clang-format
│   ├── dconf.sh                # loads GNOME settings (explicit, opt-in)
│   ├── packages.sh             # apt/docker/k8s/asdf/postgres (sudo, opt-in)
│   └── system.sh               # systemd units (sudo, opt-in)
├── config/
│   ├── nvim/                   # the canonical Neovim config (lazy.nvim)
│   ├── kitty/
│   ├── zellij/
│   ├── vim/                    # plug.vim, spell (plugged/ is gitignored)
│   ├── opencode/               # AGENTS.md, opencode.jsonc, cli.json, skills/
│   ├── vscodium/               # settings.json, keybindings.json, extensions.txt
│   └── dconf/settings.dump     # text dump from `dconf dump /`
├── home/
│   ├── .bashrc
│   ├── .bashrc.local           # per-machine overrides (gitignored)
│   ├── .bashrc.d/              # modular bashrc components
│   │   ├── 00-env.sh            # environment variables
│   │   ├── 10-core.sh           # core shell behavior
│   │   ├── 20-prompt.sh         # prompt and color setup
│   │   ├── 30-aliases.sh        # pure aliases
│   │   ├── 40-functions.sh      # dependency-free functions
│   │   ├── 50-fzf.sh            # fzf and ripgrep helpers
│   │   ├── 60-k8s.sh            # kubectl/helm/argocd helpers
│   │   ├── 70-tools.sh          # tool paths and tool-specific aliases
│   │   └── 99-local.sh          # loads ~/.bashrc.local
│   ├── .gitconfig              # shared settings only, no [user]
│   ├── .gitignore
│   ├── .vimrc
│   ├── .tmux.conf
│   ├── .tool-versions
│   └── .clang-format
├── scripts/                    # ~/scripts (tla, toggle_theme)
└── archive/                    # tracked, never installed
```

Rules:

- `config/<tool>/` is a directory the tool owns; `home/<file>` is a single
  dotfile in `$HOME`. Each module knows its own target, so the mapping is
  explicit.
- Mixed directories (`~/.config/opencode`, `~/.config/VSCodium/User`) mix
  tracked config with runtime state and secrets. They get **file-level
  links only**, never a directory symlink.

## Install

```bash
./install.sh              # links every config module
./modules/tmux.sh         # run a single module
DRY_RUN=1 ./install.sh    # preview every action without touching anything
```

`install.sh` takes no arguments and no flags. The only module that may reach
the network is `vscodium.sh` (it installs missing extensions from
`config/vscodium/extensions.txt`). For a strictly offline run, call the
other modules individually and skip `vscodium.sh`.

## What is not installed

- `archive/` — kept for reference only; never installed. Move a file back
  out of `archive/` to restore it manually.
- `modules/packages.sh` — apt/docker/kubernetes/helm/argocd/asdf/postgres
  provisioning. Requires sudo and network.
- `modules/system.sh` — systemd units (git-on-shutdown, dconf-on-shutdown).
  Requires sudo.
- `modules/dconf.sh` — loads `config/dconf/settings.dump` into GNOME with
  `dconf load /`. Loading a dump **overwrites current GNOME settings**, so
  it is never part of `install.sh`; run it explicitly.

## Remote server

### Option A: Symlink (recommended for managed machines)

```bash
# Clone the repo and link the shell module
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./modules/shell.sh
./verify.sh
```

The modular `.bashrc` loads each component only if its dependencies are present,
so fzf/k8s/tools modules will no-op safely on a bare server. Add machine-specific
settings to `~/.bashrc.local` (gitignored) on that host.

### Option B: Append (zero-risk for unmanaged machines)

```bash
# Clone the repo and append the bashrc.d block to the existing ~/.bashrc
# The original file is backed up to ~/.dotfiles-backup/<timestamp>/<bashrc>
# and can be restored later.

git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./modules/shell.sh --append
./verify.sh
```

The appended block is idempotent — running `./modules/shell.sh --append` again
will do nothing if the block is already present. To switch back to symlink mode
later, run `./modules/shell.sh` (it will back up the appended file before replacing it).

## Editing

Edit the files **in this repo**, not through the symlinks in `$HOME`.
Editing through a symlink edits the repo file and leaves the working tree
dirty; the git-on-shutdown service will commit and push that change.

## Secrets

Never commit secrets. The repo only ever holds non-secret settings:

- `~/.config/opencode/deepseek.key` (API key) and `service.json` (password)
  stay as real files in `~/.config/opencode/` — that directory is linked
  file-by-file precisely so they never enter the repo.
- `~/.gitconfig.local` holds your git identity (name/email). It is untracked
  and ignored; `~/.gitconfig` is a generated file that includes
  `home/.gitconfig` (shared settings) and `~/.gitconfig.local` (identity).
- VSCodium `globalStorage/`, `workspaceStorage/`, and `History/` are never
  linked.

`.gitignore` additionally ignores `config/opencode/*.key`,
`config/opencode/service.json`, and `home/.gitconfig.local` as defense in
depth.

## Backups and restore

Every `install.sh` run moves anything it replaces into a timestamped
directory: `~/.dotfiles-backup/<timestamp>/`. Nothing is deleted.

Restore everything from a backup:

```bash
cp -a ~/.dotfiles-backup/<timestamp>/. ~/
```

## Verification

```bash
./verify.sh
```

Checks every expected symlink (and the generated `~/.gitconfig` includes),
exits non-zero and prints `MISSING`/`WRONG` lines if anything drifted.

## New machine

```bash
git clone <this repo> ~/dotfiles
cd ~/dotfiles
./install.sh                       # links configs, installs VSCodium extensions
./modules/packages.sh              # optional: packages (sudo, network)
./modules/dconf.sh                 # optional: GNOME settings
./modules/system.sh                # optional: shutdown auto-sync units (sudo)
./verify.sh
```

Then set your identity once:

```bash
git config --file ~/.gitconfig.local user.name "Your Name"
git config --file ~/.gitconfig.local user.email "you@example.com"
```
