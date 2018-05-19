function go_resolve {
  if [ "$#" -ge 2 ]; then
    echo ~/trees/*$1*/*$2* ~/trees/*$1*/*/*$2*
  else
    echo ~/trees/*$1* ~/code/*/*$1*
  fi
}

