#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Install it first: https://brew.sh/"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

brew bundle --file="$REPO_DIR/Brewfile"

echo
echo "Next:"
echo "  1. chezmoi init --apply https://github.com/adamcooper/dotfiles.git"
echo "  2. Edit ~/.config/chezmoi/chezmoi.toml and set role=personal or role=work"
echo "  3. Restart Ghostty or run: exec zsh"
