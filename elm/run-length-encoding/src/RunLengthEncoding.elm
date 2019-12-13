module RunLengthEncoding exposing (decode, doTheOtherThing, doTheThing, encode)

import Regex


isNumber : String -> Bool
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


appendBefore : String -> String -> String
appendBefore a b =
    b ++ a


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
                    str

                Just safeRegex ->
                    Regex.replace safeRegex replacer str

        regex =
            "^1(?=[^0-9])|(?<=[^0-9])1(?=[^0-9])"
    in
    string |> String.foldr folder "" |> requiredAnnoyinglyVerboseRegexFunction regex (\_ -> "")


decode : String -> String
decode string =
    String.foldl doTheOtherThing "" string


doTheOtherThing : Char -> String -> String
doTheOtherThing char string =
    let
        newChar : String
        newChar =
            String.fromChar char

        number =
            findNumber "" string

        numberLength =
            String.length number

        findNumber : String -> String -> String
        findNumber acc str =
            let
                current =
                    String.right 1 str
            in
            if isNumber current then
                findNumber (current ++ acc) (String.dropRight 1 str)

            else
                acc

        repeatString : String -> String -> String
        repeatString str numString =
            let
                times =
                    Maybe.withDefault 1 (String.toInt numString)
            in
            String.repeat times str
    in
    if not (isNumber newChar) then
        number
            |> repeatString newChar
            |> (++) (String.dropRight numberLength string)

    else
        string ++ newChar
