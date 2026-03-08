#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y \
    bat \
    build-essential \
    curl \
    direnv \
    fd-find \
    fzf \
    git \
    neovim \
    ripgrep \
    tmux \
    unzip \
    zsh
else
  echo "Add package bootstrap support for this distro in scripts/bootstrap-linux.sh"
  exit 1
fi

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo
echo "Next:"
echo "  1. chezmoi init --apply https://github.com/adamcooper/dotfiles.git"
echo "  2. Edit ~/.config/chezmoi/chezmoi.toml and set role=remote"
echo "  3. If you enable use_starship/use_atuin, install those tools first"
echo "  4. Start tmux and run dev-session inside a repo"
