function go {
  if [ "$#" -ge 2 ]; then
    cd /trees/$1*/*/$2*
  else
    cd /code/*/$1*
  fi
}

