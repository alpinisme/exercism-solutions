module RunLengthEncoding exposing (decode, encode)

import Regex



-- encoding


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
    string |> String.foldr encodingReducer "" |> requiredAnnoyinglyVerboseRegexFunction regex (\_ -> "")


encodingReducer : Char -> String -> String
encodingReducer char string =
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
            |> Maybe.withDefault "Uh, oh..."

    else
        "1" ++ newLetter ++ string


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



-- decoding


decode : String -> String
decode string =
    String.foldl decodingReducer "" string


decodingReducer : Char -> String -> String
decodingReducer char string =
    let
        newLetter : String
        newLetter =
            String.fromChar char

        number =
            findNumber "" string

        numberLength =
            String.length number
    in
    if not (isNumber newLetter) then
        number
            |> repeatString newLetter
            |> (++) (String.dropRight numberLength string)

    else
        string ++ newLetter


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
repeatString string numString =
    let
        times =
            Maybe.withDefault 1 (String.toInt numString)
    in
    String.repeat times string



-- helper


isNumber : String -> Bool
isNumber x =
    case String.toInt x of
        Just _ ->
            True

        Nothing ->
            False