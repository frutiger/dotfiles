exec env - HOME=/home16/mrahman1 \
           SHELL=bash \
           PATH=/usr/local/bin:/bin:/usr/bin \
           LOGNAME=mrahman1 \
           TERM=xterm \
           KRB5CCNAME=$KRB5CCNAME \
           /opt/bb/bin/bash --noprofile --rcfile "~/.bash_profile" -
