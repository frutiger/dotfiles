export EDITOR=vim
export PAGER=less
export TZ="America/New_York"
export PATH=~/.local/bin:~/bin:$PATH
export PS1_SUFFIX="\u@\h \[[31m\]\w\[[0m\] [\j] \[[36m\]$\[[0m\] "

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

