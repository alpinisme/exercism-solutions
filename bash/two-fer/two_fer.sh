#!/usr/bin/env bash

main() {
  if [ -z "$1" ]; then
    name="you"
  else 
    name=$1
  fi
  echo "One for $name, one for me."
}
	
main "$@"
