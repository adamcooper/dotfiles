mkcd() {
  mkdir -p "$1" && cd "$1"
}

dev-session() {
  local session

  session="${1:-${PWD##*/}}"
  exec tmux new-session -A -s "${session//./-}"
}
