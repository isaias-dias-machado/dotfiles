# 50-fzf.sh - FZF and ripgrep helpers
# Guard: only load if fzf is available
command -v fzf >/dev/null 2>&1 || return 0

# FZF directory navigation
fcd() {
  local dir
  if command -v fd &>/dev/null; then
    dir=$(fd --type d . | fzf)
  else
    dir=$(find . -type d | fzf)
  fi

  # If a directory was selected, cd into it.
  if [ -n "$dir" ]; then
    cd "$dir" || return
  fi
}

# FZF ripgrep file search with preview
frg() {
  # Search for a pattern in files using ripgrep and select a result with fzf.
  local line
  line=$(rg --line-number --no-heading --color=always . | fzf --ansi \
    --preview "echo {} | cut -d: -f1,2 | sed 's/:/ /' | xargs bat --color=always --highlight-line" \
    --preview-window "up,60%,border-top")

  # If a line was selected, open the file in Vim at that line number.
  if [ -n "$line" ]; then
    local file
    local line_num
    file=$(echo "$line" | cut -d: -f1)
    line_num=$(echo "$line" | cut -d: -f2)
    vi +"$line_num" "$file"
  fi
}

# FZF geany file search
# Guard: only load if geany is available
command -v geany >/dev/null 2>&1 || return 0

gg() {
  # Search for a pattern in files using ripgrep and select a result with fzf.
  local line
  line=$(rg --line-number --no-heading --color=always . | fzf --ansi \
    --preview "echo {} | cut -d: -f1,2 | sed 's/:/ /'" \
    --preview-window "up,60%,border-top")

  # If a line was selected, open the file in Geany at that line number.
  if [ -n "$line" ]; then
    local file
    local line_num
    file=$(echo "$line" | cut -d: -f1)
    line_num=$(echo "$line" | cut -d: -f2)
    geany "$file":"$line_num"
  fi
}

# FZF SSH host selection
fssh() {
  local host
  host=$(grep '^Host ' ~/.ssh/config | awk '{print $2}' | fzf)
  if [[ -n "$host" ]]; then
    ssh "$host"
  fi
}

# Generic fzf selector for any command
f() {
  $1 $(fzf)
}

# FZF kubectl context selection
fku() {
  local context
  context=$(kubectl config get-contexts -o name | fzf --preview 'kubectl config get-contexts {}')
  if [[ -n "$context" ]]; then
    kubectl config use-context "$context"
  fi
}

# FZF kubectl namespace selection
fkn() {
  local namespace
  namespace=$(kubectl get namespaces --no-headers -o custom-columns=NAME:.metadata.name | fzf --preview 'kubectl get pods --namespace {}')
  if [[ -n "$namespace" ]]; then
    kubectl config set-context --current --namespace="$namespace"
  fi
}

# Projects directory navigation
repos() {
  local basedir=$PROJECTS_DIR
  local selection=$(find "$basedir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)

  if [[ -n "$selection" ]]; then
    cd "$basedir/$selection" || return
  fi

  export root="$basedir/$selection"
  fcd
}

# Hacking directory navigation
hacking() {
  local basedir=$HOME/hacking
  local selection=$(find "$basedir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)

  if [[ -n "$selection" ]]; then
    cd "$basedir/$selection" || return
  fi

  export root="$basedir/$selection"
  fcd
}

# Default FZF command
FZF_DEFAULT_COMMAND='rg --files --hidden'
