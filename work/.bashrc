function flag {
  echo -n {}
  banner $1 | sed 's/#/{'$2'}/g' | sed 's/ /{Q5}/g'
}

