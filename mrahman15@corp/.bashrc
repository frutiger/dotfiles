function go {
  if [ "$#" -ge 2 ]; then
    cd ~/trees/$1*/*/$2*
  else
    cd ~/repos/*/$1*
  fi
}

