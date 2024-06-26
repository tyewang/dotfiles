#plugins
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#env vars
export EDITOR=vim
export GREP_OPTIONS='--color'
export BROWSER=google-chrome
export TERM=screen-256color
export GOPATH=~/.go:$PWD
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export GREP_OPTIONS='--color'
export BSPWM_SOCKET=/tmp/bspwm-socket
export PANEL_FIFO=/tmp/panel-fifo
export XDG_CONFIG_HOME=$HOME/.config
export WORDCHARS=""

#ls color
LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

#options
set -o emacs
setopt EXTENDED_HISTORY # add timestamps to history
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt PROMPT_SUBST
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt AUTO_CD
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

#completion
autoload -U compinit
compinit
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case insensitive completion
zstyle ':completion:*:default' menu 'select=0' # menu-style
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

autoload edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

stty stop undef
stty start undef

# C-d to exit
exit_shell() {
  exit
}

zle -N exit_shell
bindkey "^d" exit_shell

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

#prompt
autoload colors
colors

export GIT_PROMPT_TIMEOUT=1

git_untracked_count() {
  count=`echo $(git ls-files --other --exclude-standard | wc -l)`
  if [ $count -eq 0 ]; then return; fi
  echo " %{$fg_bold[yellow]%}?%{$fg_no_bold[black]%}:%{$reset_color$fg[yellow]%}$count%{$reset_color%}"
}

git_modified_count() {
  count=`echo $(git ls-files -md | wc -l)`
  if [ $count -eq 0 ]; then return; fi
  echo " %{$fg_bold[red]%}M%{$fg_no_bold[black]%}:%{$reset_color$fg[red]%}$count%{$reset_color%}"
}

git_staged_count() {
  count=`echo $(git diff-index --cached --name-only HEAD 2>/dev/null | wc -l)`
  if [ $count -eq 0 ]; then return; fi
  echo " %{$fg_bold[green]%}S%{$fg_no_bold[black]%}:%{$reset_color$fg[green]%}$count%{$reset_color%}"
}

git_branch() {
  branch=$(git symbolic-ref HEAD --quiet 2> /dev/null)
  if [ -z $branch ]; then
    echo "%{$fg[yellow]%}$(git rev-parse --short HEAD)%{$reset_color%}"
  else
    echo "%{$fg[green]%}${branch#refs/heads/}%{$reset_color%}"
  fi
}

git_remote_difference() {
  has_origin=$(git remote | grep origin)
  if [ -z $has_origin ]; then return; fi

  branch=$(git symbolic-ref HEAD --quiet)
  if [ -z $branch ]; then return; fi

  remote=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
  ahead_by=`echo $(git log --oneline $remote..HEAD 2> /dev/null | wc -l)`
  behind_by=`echo $(git log --oneline HEAD..$remote 2> /dev/null | wc -l)`

  output=""
  if [ $ahead_by -gt 0 ]; then output="$output%{$fg_bold[white]%}↑%{$reset_color%}$ahead_by"; fi
  if [ $behind_by -gt 0 ]; then output="$output%{$fg_bold[white]%}↓%{$reset_color%}$behind_by"; fi

  echo $output
}

git_user() {
  user=$(git config user.name)
  if [ -z $user ]; then
    echo "%{$fg_bold[red]%}no user%{$fg[black]%}@%{$reset_color%}"
  else
    echo "$user%{$fg[black]%}@%{$reset_color%}"
  fi
}

in_git_repo() {
  if [ -d .git ]; then
    echo 0
  else
    echo $(git rev-parse --git-dir > /dev/null 2>&1; echo $?)
  fi
}

git_prompt_info() {
  if [[ $(in_git_repo) -gt 0 ]]; then return; fi
  print " $(git_user)$(git_branch)$(git_remote_difference)$(git_staged_count)$(git_modified_count)$(git_untracked_count)"
}

export PROMPT='%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[magenta]%}$%{$reset_color%} '


#path
export PATH=$HOME/.bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.go/bin:$PATH
export PATH="./node_modules/.bin":$PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYTHONDONTWRITEBYTECODE=1
pyenv virtualenvwrapper
