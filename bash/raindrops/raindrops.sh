#!/usr/bin/env bash


### Notes to self ###

# (( exp )) evaluates exp according to c arithmetic to return a Boolean
# $(( exp )) evaluates exp according to c arithmetic to return result
# I could have been less explicit therefore and used (( $1 % 2 )) as a Boolean test
# and then used a || operator to do the string concat
# another user did this, and also showed that the initial definition of the empty string
# is unnecessary:


main () {
    output=""
    if [[ $(( $1 % 3 )) -eq 0 ]]; then output+="Pling"
    fi
    if [[ $(( $1 % 5 )) -eq 0 ]]; then output+="Plang"
    fi
    if [[ $(( $1 % 7 )) -eq 0 ]]; then output+="Plong"
    fi

    if [[ -z $output ]]; then output=$1
    fi
    echo $output
}

main "$@"
