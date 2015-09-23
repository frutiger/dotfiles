function phab {
  git diff --unified=20000 "$@" origin/master...@{u} | clip
}

if [ -z $SHELL_DEPTH ]; then
    export SHELL_DEPTH=0
else
    export SHELL_DEPTH=$[ $SHELL_DEPTH + 1 ]
fi

PS1="\[\e]2;$SHELL_DEPTH: \W\a\]\[[31m\]\w\[[0m\] [\j] \[[36m\]$\[[0m\] "

