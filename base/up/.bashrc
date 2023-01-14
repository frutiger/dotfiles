PS1="\u@\h \[[31m\]\w\[[0m\] [\j]\n\[[36m\]$\[[0m\] "

HISTFILESIZE=1048576
HISTSIZE=1048576
PROMPT_COMMAND='history -a'
shopt -s histappend
shopt -s cmdhist

alias gdi='git vimdiff'
alias gds='git diff --stat'
alias gitf='git fetch --prune --tags --all'

alias grep='grep --color'
alias less='less -n'

function go_resolve {
  echo ~/code/*/*$1*
}

function go {
  targets=$(go_resolve $@)

  dirs=()
  for target in $targets; do
    if [ -d "$target" ]; then
      dirs+=("$target")
    fi
  done

  if [ ${#dirs[@]} == "0" ]; then
    echo "$@" not found
  elif [ ${#dirs[@]} == "1" ]; then
    cd $dirs
  else
    select dir in ${dirs[@]}; do
      if [[ $dir ]]; then
        cd $dir
        break
      fi
    done
  fi
}

