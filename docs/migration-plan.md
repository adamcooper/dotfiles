# Migration Plan

This repo uses a shared `chezmoi` source tree built around a modern `zsh`
workflow.

The immediate goal is consistency across:

- personal macOS machine
- work machine
- future disposable remote dev hosts

This public repo is intentionally limited to user-level configuration. Remote
server bootstrap details such as `cloud-init`, Tailscale auth flows, and AI
tool provisioning should live in a separate private repo or password-manager
notes so they are not exposed publicly.

## Principles

- Keep `zsh` as the base shell everywhere.
- Keep shell config thin and readable.
- Share as much config as possible.
- Isolate machine-specific differences through `chezmoi` data, not file forks.
- Keep server bootstrap and deployment concerns outside this public repo.

## Scope

This repo should own:

- Git configuration
- `zsh` startup files and aliases/functions
- `ghostty` config
- `tmux` config for remote development
- `nvim` baseline config
- `mise` and `direnv` baseline config
- SSH client defaults and host aliases

This repo should not own:

- `cloud-init`
- server credentials or auth tokens
- Tailscale auth keys
- deployment manifests for apps
- machine inventory or private hostnames if those should stay private

## Rollout sequence

### Phase 1: Personal machine

1. Install the baseline tools.
2. Apply this repo with `chezmoi`.
3. Set `role = "personal"` in `~/.config/chezmoi/chezmoi.toml`.
4. Validate the daily shell workflow in Ghostty and VS Code.
5. Trim any settings that feel noisy or unnecessary before rolling further.

### Phase 2: Work machine

1. Inventory the current shell/editor/git setup on the work machine.
2. Identify what should become shared defaults versus work-only overrides.
3. Apply this repo with `chezmoi`.
4. Set `role = "work"` in `~/.config/chezmoi/chezmoi.toml`.
5. Move work-specific differences into:
   - `~/.config/zsh/local.zsh`
   - `~/.gitconfig.local`
   - optional role-based templating in this repo if the differences are stable

The rule for consolidation is:

- if a setting is useful on personal and work machines, move it into the shared
  repo
- if a setting only exists because of work constraints, keep it local or role
  gated

### Phase 3: Consolidation pass

After both Macs are running this stack:

1. Compare the local overrides on each machine.
2. Promote stable common settings into shared templates.
3. Keep only the minimum machine-specific overrides.
4. Keep `home/` as the only source of truth.

### Phase 4: Remote dev hosts

Handle remote server bootstrap separately in a private workflow. After the
machine exists and base packages are installed, apply this repo with `chezmoi`
and set `role = "remote"`.

## Work machine checklist

Capture these before applying the shared config:

- current shell and shell startup files
- current Git editor, signing, and credential helper settings
- current SSH config and host aliases
- existing Neovim/Vim preferences you still care about
- any company-specific CLI tools or PATH entries
- any restrictions on Homebrew, package installs, or credential storage

## Open decisions

- Whether to enable `starship` on either Mac after a week of real use
- Whether to enable `atuin` on any machine
- How much Neovim config should live here versus remain minimal
- Whether host aliases for fixed remote machines belong in the public repo or in
  local SSH overrides
