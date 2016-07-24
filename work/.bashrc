function flag {
  echo -n {}
  banner $1 | sed 's/#/{'$2'}/g' | sed 's/ /{Q5}/g'
}

function appinfra_merge {
  git push origin origin/dev/$1/$2:refs/heads/ci/m/master/$2
}

function go_resolve {
  if [ "$#" -ge 2 ]; then
    echo ~/trees/*$1*/*/*$2* ~/trees/*$1*/*$2*
  else
    echo ~/code/*/*$1*
  fi
}

