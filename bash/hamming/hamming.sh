#!/usr/bin/env bash

main () {
    if [[ $# != 2 ]]; then
        echo "Usage: hamming.sh <string1> <string2>"
        exit 1
    elif [[  ${#1} -ne ${#2} ]]; then
        echo "left and right strands must be of equal length"
        exit 1
    fi
    
    count=0
    for (( i=0 ; i<${#1} ; i++ )); do
        [[ "${1:i:1}" !=  "${2:i:1}" ]] && (( count++ ))
    done

    echo $count
}

main "$@"
