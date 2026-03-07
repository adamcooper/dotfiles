alias g='git'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gst='git status -sb'
alias v='nvim'

# Prefer fd if it is available under the Debian package name.
if command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi
