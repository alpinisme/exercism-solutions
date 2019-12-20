module Leap exposing (isLeapYear)


isLeapYear : Int -> Bool
isLeapYear year =
    let
        isDivisibleBy divisor =
            remainderBy divisor year == 0
    in
    isDivisibleBy 4 && (not (isDivisibleBy 100) || isDivisibleBy 400)
