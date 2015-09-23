PS1="\[\e]2;\h\a\]$PS1_SUFFIX"

alias sf="symfind -A"
alias sfpp="symfind -AC"

function pnewtask {
  PREV_UMASK=`umask`
  umask 0002
  /bb/bin/pnewtask $*
  umask $PREV_UMASK
}

