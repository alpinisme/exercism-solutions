#!/usr/bin/env bash

main () {
    input=`echo $1`
   
    if [[ "$input" =~ \?$ && ! "$input" =~ [a-z] && "$input" =~ [A-Z] ]]; then
        echo "Calm down, I know what I'm doing!"
        
    elif [[ ! "$input" =~ [a-z] && "$input" =~ [A-Z] ]]; then
        echo "Whoa, chill out!"

    elif [[ "$input" =~ ^\s*$ ]]; then
        echo "Fine. Be that way!"

    elif [[ "$input" =~ \?$ ]]; then
        echo "Sure."

    else 
        echo "Whatever."
    fi
    echo $input

}

main "$@"
