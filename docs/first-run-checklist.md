# First-Run Checklist

Use this on each machine as you adopt the new setup.

## 1. Install baseline tools

### macOS

```sh
./scripts/bootstrap-macos.sh
```

### Linux

```sh
./scripts/bootstrap-linux.sh
```

## 2. Apply the shared config

```sh
chezmoi init --apply https://github.com/adamcooper/dotfiles.git
```

Then edit `~/.config/chezmoi/chezmoi.toml`.

Set:

- personal Mac: `role = "personal"`
- work machine: `role = "work"`
- remote dev host: `role = "remote"`

Optional:

- set `use_starship = true` if you want Starship
- set `use_atuin = true` if you want Atuin on that machine

On macOS, `./scripts/bootstrap-macos.sh` installs both tools. On Linux, install
the corresponding binary before enabling either flag.

Re-apply after changes:

```sh
chezmoi apply
```

## 3. Validate shell behavior

Check:

- `echo $SHELL`
- `zsh --version`
- `command -v chezmoi mise direnv zoxide fzf rg nvim tmux`
- `command -v fd || command -v fdfind`
- `echo $EDITOR`
- `echo $XDG_CONFIG_HOME`
- if enabled, `command -v starship` and `command -v atuin`

Confirm:

- prompt looks right
- `ls` and `ll` behave as expected
- `z repo-name` works after you have visited a few directories
- `ctrl-r` history search still behaves the way you expect
- `ctrl-t` file search works inside a repo

## 4. Validate editor and terminal

Check:

- Ghostty starts cleanly and uses the expected font
- `nvim` opens without errors
- `tmux` starts without errors
- in a repo, `dev-session` attaches or creates a session

## 5. Machine-specific follow-up

### Personal machine

- decide whether to enable Starship
- decide whether local-only Atuin is worth it
- add any personal SSH host aliases locally first

### Work machine

Before applying work-specific tweaks, capture:

- current `~/.zshrc` or equivalent shell startup files
- current Git editor/signing/credential setup
- any company-required PATH entries
- any SSH config that should remain local only

Put work-only settings in:

- `~/.config/zsh/local.zsh`
- `~/.gitconfig.local`

Promote only stable shared defaults back into this repo.

## 6. Consolidation pass

After both Macs are running well:

1. Compare local overrides.
2. Move genuinely shared settings into the templates in this repo.
3. Keep work-only constraints local.
4. Remove any legacy files you no longer rely on.
