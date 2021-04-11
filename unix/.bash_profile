export EDITOR=vim
export PAGER=less
export TZ="America/New_York"
export PATH=~/.local/bin:~/.cargo/bin:~/bin:$PATH:~/code/chromium/depot_tools
export XDG_CONFIG_HOME=$HOME/.config

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

