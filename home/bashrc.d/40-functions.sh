# 40-functions.sh - Dependency-free functions

# Simple script creation
newscrpt() {
  touch "$1"
  chmod +x "$1"
  vi "$1"
}

# Python virtualenv activation
activate() {
  source bin/activate 2>/dev/null || source .venv/bin/activate
}

# Compile and run C program
out() {
  cc $1
  ./a.out
}

# Task-based commit
# $1 task number $2 msg
commit() {
  local task_ref="task$1"
  git commit -m "${!task_ref}

$2"
}

# Add SSH host
# $1 ip $2 alias $3 user (OPT)
add_ssh() {
  if [ "$1" = "--help" ]; then
    echo "Usage: add_ssh <ip/dns> <alias> [user]"
    return 0
  fi
  local user=${3:-root}
  ssh-copy-id "$user@$1"
  echo "
Host $2
    HostName $1
    User $user" >> ~/.ssh/config
}

# Prevent laptop sleep while a process runs
cafe() {
  systemd-inhibit --what=idle --why="Monitoring kerl build" bash -c "while kill -0 $1 2>/dev/null; do sleep 60; done"
}

# Secret extraction helper
secret() {
  local last_command=$(fc -ln -1)

  if [[ "$last_command" == secret* ]]; then
    echo "Error: Last command was 'secret'. Aborting to prevent loop." >&2
    return 1
  fi

  local base_cmd="${last_command% *}"
  local replacement="'jsonpath={.data.$1}' | base64 -d | clip.exe"
  local new_cmd="$base_cmd $replacement"

  echo "$new_cmd"
  eval "$new_cmd"
}
