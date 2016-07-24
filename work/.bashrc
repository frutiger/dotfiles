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

  dirs=()
  for target in $targets; do
    if [ -d "$target" ]; then
      dirs+=("$target")
    fi
  done

  if [ ${#dirs[@]} == "0" ]; then
    echo "$@" not found
  elif [ ${#dirs[@]} == "1" ]; then
    cd $dirs
  else
    select dir in ${dirs[@]}; do
      if [[ $dir ]]; then
        cd $dir
        break
      fi
    done
  fi
}

