#!/usr/bin/env bash
#
# I initially used if/then/else for the final ternary result
# but decided to use the boolean operators for "practice" and because
# this was a fairly straightforward ternary unlike the first if clause
# which I wanted to be explicit about. I also tried to be judicious in
# my use of quotation marks and avoid where unnecessary. But that is
# not always easy to tell in bash.
#
# other things I discovered: the loop can be very terse because
# the result variable does not need to be declared prior to then

main () {
    input="$1"
    length=${#input}

    if [[ ! "$input" =~ ^[0-9]+$ ]]; then
        echo "only integer inputs allowed"
        exit 1
    fi

    for (( i=0 ; i < $length ; i++ )) do
        (( result+=${input:i:1}**length )) 
    done

    [[ $result -eq $input ]] && echo "true" || echo "false"
}

main "$@"
