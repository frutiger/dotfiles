if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
PROMPT_COMMAND='__git_ps1 "\u@\h \[[31m\]\w\[[0m\] [\j]" " \[[36m\]$\[[0m\] "'

