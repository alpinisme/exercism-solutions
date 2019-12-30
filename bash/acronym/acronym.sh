#!/usr/bin/env bash

main () {
    words=($@)
    for each in $words ; do
        next=${each:0:1}
        if [[ $next =~ [A-Za-z] ]]; then
            result+=$next
        fi
    done
    echo ${result^^}
}

main "$@"
