source ~/.bash_completion.d/git-completion.bash

function flag {
  echo -n {}
  banner $1 | sed 's/#/{'$2'}/g' | sed 's/ /{Q5}/g'
}

function appinfra_merge {
  git push origin origin/dev/$1/$2:refs/heads/ci/m/master/$2
}

function go {
  if [ "$#" -ge 2 ]; then
    targets=$(echo ~/trees/*$1*/*/*$2* ~/trees/*$1*/*$2*)
  else
    targets=$(echo ~/code/*/*$1*)
  fi

  if [ $(echo $targets | wc -w) == "1" ]; then
    target=$targets
  else
    select target in $targets; do
      if [[ $target ]]; then break; fi
    done
  fi

  cd $target
}

