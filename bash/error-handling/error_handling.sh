#!/usr/bin/env bash

main () {
     usage="Usage: ./error_handling <greetee>"

     if [[ $# -ne 1 ]]; then
         echo "$usage"
         exit 1
     else
         echo "Hello, $1"
     fi
}
 
main "$@"
