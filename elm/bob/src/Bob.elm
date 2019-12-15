module Bob exposing (hey)


hey : String -> String
hey input =
    let
        remark =
            String.trim input

        isSilence : Bool
        isSilence =
            remark == ""

        isYelling : Bool
        isYelling =
            String.toUpper remark == remark && not (String.toLower remark == remark)

        isQuestion : Bool
        isQuestion =
            String.right 1 remark == "?"
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
