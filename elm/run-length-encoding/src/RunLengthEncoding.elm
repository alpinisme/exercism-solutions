module RunLengthEncoding exposing (decode, doTheThing, encode)

import Regex


doTheThing : Char -> String -> Maybe String
doTheThing char string =
    let
        newLetter =
            String.fromChar char

        oldNum =
            getOldNum string

        oldNumLength =
            String.length oldNum

        oldLetter =
            String.slice oldNumLength (oldNumLength + 1) string

        isNumber x =
            case String.toInt x of
                Just _ ->
                    True

                Nothing ->
                    False

        getOldNum : String -> String
        getOldNum str =
            let
                leftLetter =
                    String.left 1 str
            in
            if isNumber leftLetter then
                leftLetter ++ getOldNum (String.dropLeft 1 str)

            else
                ""

        appendBefore a b =
            b ++ a
    in
    if oldLetter == newLetter then
        String.toInt oldNum
            |> Maybe.map ((+) 1)
            |> Maybe.map String.fromInt
            |> Maybe.map (appendBefore (String.dropLeft oldNumLength string))

    else
        Just ("1" ++ newLetter ++ string)


folder : Char -> String -> String
folder char string =
    case doTheThing char string of
        Just result ->
            result

        Nothing ->
            "I'm failing"


encode : String -> String
encode string =
    let
        requiredAnnoyinglyVerboseRegexFunction userRegex replacer str =
            case Regex.fromString userRegex of
                Nothing ->
                    string

                Just safeRegex ->
                    Regex.replace safeRegex replacer str

        regex =
            "^1(?=[^0-9])|(?<=[^0-9])1(?=[^0-9])"
    in
    string |> String.foldr folder "" |> requiredAnnoyinglyVerboseRegexFunction regex (\_ -> "")


decode : String -> String
decode string =
    "Please implement this function"



{- slice for second letter. convert char to string and compare
   if the same, grab the first character and increment
   if different, append 1 + the new characters
-}
