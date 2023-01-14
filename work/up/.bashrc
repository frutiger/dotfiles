function flag {
  echo -n {}
  banner $1 | sed 's/#/{'$2'}/g' | sed 's/ /{Q5}/g'
}

function go_resolve {
  if [ "$#" -ge 2 ]; then
    echo ~/trees/*$1*/*$2* ~/trees/*$1*/*/*$2*
  else
    echo ~/trees/rp2/*$1* ~/code/*/*$1*
  fi
}

