# Dotfiles

This repo is now structured as a `chezmoi` source tree for a modern `zsh`
workflow shared across:

- a personal macOS machine
- a work machine with light customization
- disposable remote coding servers after user-level bootstrap

The stack this repo is designed for:

- `chezmoi` for user-level dotfiles
- `zsh` as the base shell everywhere
- `mise` for runtimes and project tool versions
- `tmux` only on remote coding hosts
- `Neovim` remotely and `VS Code` locally
- separate private bootstrap for provisioning disposable Linux dev servers

## Repo layout

- `home/`: the chezmoi source state root
- `docs/`: rollout notes and migration planning
- `scripts/`: local and Linux bootstrap helpers

`home/` currently manages:

- `.gitconfig`, `.gitconfig.local`, `.gitignore`
- `.zshenv`, `.zprofile`, `.zshrc`
- `~/.config/zsh/*`
- `~/.config/tmux/tmux.conf`
- `~/.config/nvim/init.lua`
- `~/.config/mise/config.toml`
- `~/.config/ghostty/config`
- `~/.config/starship.toml`
- `~/.ssh/config`

## Bootstrap

### macOS

```sh
./scripts/bootstrap-macos.sh
chezmoi init --apply https://github.com/adamcooper/dotfiles.git
```

Then edit `~/.config/chezmoi/chezmoi.toml` and set:

- `role = "personal"` on your personal machine
- `role = "work"` on your work machine

### Linux / remote dev host

```sh
./scripts/bootstrap-linux.sh
chezmoi init --apply https://github.com/adamcooper/dotfiles.git
```

Then set `role = "remote"` in `~/.config/chezmoi/chezmoi.toml`.

## Machine roles

The generated `~/.config/chezmoi/chezmoi.toml` contains a small amount of
machine-local data:

- `role = "personal"` for your main macOS machine
- `role = "work"` for your work machine
- `role = "remote"` for disposable Linux coding boxes
- `use_starship = true` if you want a Starship prompt
- `use_atuin = true` if you want Atuin on that specific machine

This keeps one shared repo while allowing small per-machine differences.
The default prompt stays simple and built-in unless you explicitly enable
Starship on a machine.

## Remote dev workflow

Keep machine bootstrap details in a separate private repo or notes. This public
repo should be applied only after the remote machine already exists and has the
base packages installed.

The intended remote user-space stack is:

- `zsh`
- `tmux`
- `nvim`
- `mise`
- `direnv`
- `zoxide`
- `fzf`

Inside a repo, run `dev-session` to attach or create a `tmux` session named
after the current directory.

## Notes

- This repo does not assume Nix.
- `mise` handles runtimes and project tools; keep global tools minimal.
- Keep shell history separate per machine.
- Keep bootstrap and deployment concerns (`cloud-init`, `Docker`, `Kamal`)
  separate from user dotfiles.
- `home/` is the only source of truth.
- The rollout/consolidation plan lives in [`docs/migration-plan.md`](docs/migration-plan.md).
- The per-machine rollout checklist lives in [`docs/first-run-checklist.md`](docs/first-run-checklist.md).
