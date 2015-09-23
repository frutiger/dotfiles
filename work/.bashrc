source ~/.bash_completion.d/git-completion.bash

function flag {
  echo -n {}
  banner $1 | sed 's/#/{'$2'}/g' | sed 's/ /{Q5}/g'
}

function appinfra_merge {
  git push origin origin/dev/$1/$2:refs/heads/ci/m/master/$2
}

