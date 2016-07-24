PS1=$PS1_SUFFIX

HISTFILESIZE=1048576
HISTSIZE=1048576
PROMPT_COMMAND='history -a'
shopt -s histappend
shopt -s cmdhist

alias g=gvim
alias vim='vim -X'

alias gdi='git vimdiff'
alias gds='git diff --stat'
alias gdn='git diff --name-only --relative'
alias gitf='git fetch --prune --tags --all'

alias grep='grep --color'
alias less='less -n'

function lw {
  less $(which $1)
}

function latest {
  ls -1t "$1"* | head -1
}

function lessl {
  less $(latest $1)
}

function sshwap {
  pushd ~/.ssh >/dev/null
  fullpath=$(readlink -f id_rsa)
  fullpath=${fullpath#$PWD/}
  fullpath=${fullpath%/id_rsa}
  echo "Currently $fullpath"
  select dir in $(find * -type d)
  do
    if [[ ! $dir ]]
    then
      echo "Nothing!"
      break
    fi

    rm id_rsa{,.pub}
    ln -s ~/.ssh/$dir/id_rsa id_rsa
    ln -s ~/.ssh/$dir/id_rsa.pub id_rsa.pub
    break
  done
  popd >/dev/null
}

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

