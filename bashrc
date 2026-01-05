source $HOME/.env

get_kube_context() {
  local var=$(kubectl config current-context 2>/dev/null)
  echo "${var##*@}"
}

get_kube_namespace() {
  kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo default
}

source <(kubectl completion bash)
source <(helm completion bash)
source <(argocd completion bash)
source <(asdf completion bash)

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  PS1='[$(get_kube_context):$(get_kube_namespace)] \[\033[93m\]${PWD##*/}\[\033[93m\] ➤\[\033[00m\] '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  #alias grep='grep --color=auto'
  #alias fgrep='fgrep --color=auto'
  #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LIBGL_ALWAYS_SOFTWARE=1

#===============================FZF==================================
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
    vim +"$line_num" "$file"
  fi
}

fssh() {
  local host
  host=$(grep '^Host ' ~/.ssh/config | awk '{print $2}' | fzf)
  if [[ -n "$host" ]]; then
    ssh "$host"
  fi
}

fku() {
  local context
  context=$(kubectl config get-contexts -o name | fzf --preview 'kubectl config get-contexts {}')
  if [[ -n "$context" ]]; then
    kubectl config use-context "$context"
  fi
}

fkn() {
  local namespace
  namespace=$(kubectl get namespaces --no-headers -o custom-columns=NAME:.metadata.name | fzf --preview 'kubectl get pods --namespace {}')
  if [[ -n "$namespace" ]]; then
    kubectl config set-context --current --namespace="$namespace"
  fi
}

repos() {
  local dir
  # Find directories one level deep in the provided path (or current dir if none is given)
  # and pipe them to fzf for selection.
  basedir=$PROJECTS_DIR
  selection=$(find "$basedir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)

  if [[ -n "$selection" ]]; then
    cd "$basedir/$selection" || return
  fi

  export root="$basedir/$selection"
  fcd
  # file=$(fzf)

  # if [ -n "$file" ]; then
  # 	vi $file
  # fi
}

hacking() {
  local dir
  # Find directories one level deep in the provided path (or current dir if none is given)
  # and pipe them to fzf for selection.
  basedir=$HOME/hacking
  selection=$(find "$basedir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | fzf)

  if [[ -n "$selection" ]]; then
    cd "$basedir/$selection" || return
  fi

  export root="$basedir/$selection"
  fcd
  # file=$(fzf)

  # if [ -n "$file" ]; then
  # 	vi $file
  # fi
}

f() {
  $1 $(fzf)
}

ireb() {
  git add .
  git commit -m tmp
  git rebase -i HEAD~2
}

secret() {
  local last_command=$(fc -ln -1)

  if [[ "$last_command" == secret* ]]; then
    echo "Error: Last command was 'secret'. Aborting to prevent loop."
    return 1
  fi

  local base_cmd="${last_command% *}"

  local replacement="'jsonpath={.data.$1}' | base64 -d | clip.exe"

  local new_cmd="$base_cmd $replacement"

  echo "$new_cmd"

  eval "$new_cmd"
}

argocdlogin() {
  argocd login "$1" --grpc-web --grpc-web-root-path /argocd
}

# $1 ip $2 alias $3 user (OPT)
add_ssh() {
  if [ "$1" -eq "--help"]; then
    echo "Usage: add_ssh <ip/dns> <alias> [user]"
    exit 0
  fi
  local user=${3:-"root"}
  ssh-copy-id "$user@$1"
  echo "
Host $2
    HostName $1
    User $user" >>~/.ssh/config
}

cafe() {
  systemd-inhibit --what=idle --why="Monitoring kerl build" bash -c "while kill -0 $1 2>/dev/null; do sleep 60; done"
}

#====================================================================

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

alias vi=nvim
alias dotfiles='cd ~/dotfiles'
alias dfinstall='vi ~/dotfiles/install.sh'
alias w='vim ~/mywiki/wiki.md'
alias gl='git log --oneline'
alias brc='vi ~/dotfiles/bashrc'
alias _env='vi ~/.env'
alias sbrc='. ~/.bashrc'
alias vssh='vi ~/.ssh/config'
alias v='vi $(fzf)'
alias opn='xdg-open'
alias z='zellij'
alias key='cat $HOME/.secrets/key | clip.exe'
alias sup='vi ~/suporte/apontamentos.md'
alias wiki='vi ~/wiki.md'
alias amend='git commit --amend --no-edit'
alias force='git push --force-with-lease'
alias recommit='git add . && amend && force'
alias mt='mix test --color 2>&1| less -R'
alias os='cd ~/open-sources/'
alias tmp='TMP=$(mktemp -d) && cd $TMP'
alias otpbuild='KERL_CONFIGURE_OPTIONS="--without-wx --without-javac --without-et" \
kerl build git ~/open-sources/otp my-branch otp-local-dev'
alias snip='vi ~/.local/share/nvim/lazy/friendly-snippets/snippets'
alias snipex='vi ~/.vim/plugged/vim-snippets/snippets/elixir.snippets'
alias snipkube='vi ~/.vim/plugged/vim-kubernetes/UltiSnips/yaml.snippets'
alias tokengen='openssl rand -base64 32'
alias stashpull='git stash && git pull && git stash pop'
alias clip='xclip -selection clipboard'
alias db="psql -d $CUR_DATABASE"
alias droptestdb="MIX_ENV=test mix ecto.drop"

# $1 task number $2 msg
commit() {
  local task_ref="task$1"
  git commit -m "${!task_ref}

$2"
}

export FZF_DEFAULT_COMMAND='rg --files --hidden'
export ERL_AFLAGS='-kernel shell_history enabled  -kernel shell_history_path \".erl.history\"'
