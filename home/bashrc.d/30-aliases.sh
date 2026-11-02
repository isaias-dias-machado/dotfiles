# 30-aliases.sh - Pure aliases (no dependencies)

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Convenience aliases
alias dotfiles='cd ~/dotfiles'
alias dfinstall='vi ~/dotfiles/install.sh'
alias w='vi ~/mywiki/wiki.md'
alias gl='git log --oneline'
alias brc='vi ~/dotfiles/home/.bashrc'
alias _env='vi ~/.env'
alias sbrc='. ~/.bashrc'
alias vssh='vi ~/.ssh/config'
alias opn='xdg-open'
alias z='zellij'
alias key='cat $HOME/.secrets/key | clip.exe'
alias sup='vi ~/suporte/apontamentos.md'
alias wiki='vi ~/wiki.md'
alias amend='git commit --amend --no-edit'
alias force='git push --force-with-lease'
alias mt='mix test --color 2>&1| less -R'
alias os='cd ~/open-sources/'
alias tmp='TMP=$(mktemp -d) && cd $TMP'
alias tokengen='openssl rand -base64 32'
alias stashpull='git stash && git pull && git stash pop'
alias clip='xclip -selection clipboard'
alias emacs='emacs -nw'
alias confignvim='cd ~/.config/nvim/'
