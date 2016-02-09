function go {
  if [ "$#" -ge 2 ]; then
    cd /c/dev/trees/*$1*/*/*$2*
  else
    cd /c/dev/repos/*/*$1*
  fi
}

