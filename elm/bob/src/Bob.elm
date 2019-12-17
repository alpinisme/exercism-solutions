module Bob exposing (hey)


hey : String -> String
hey input =
    let
        remark =
            String.trim input

        isSilence : Bool
        isSilence =
            String.isEmpty remark

        isYelling : Bool
        isYelling =
            String.any Char.isUpper remark && (not <| String.any Char.isLower remark) 

        isQuestion : Bool
        isQuestion =
            String.endsWith "?" remark
    in
    if isSilence then
        "Fine. Be that way!"

    else if isYelling && isQuestion then
        "Calm down, I know what I'm doing!"

    else if isYelling then
        "Whoa, chill out!"

    else if isQuestion then
        "Sure."

    else
        "Whatever."
