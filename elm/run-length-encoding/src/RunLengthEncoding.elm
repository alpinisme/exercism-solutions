module RunLengthEncoding exposing (decode, encode)

-- encoding


encode : String -> String
encode string =
    string |> String.foldr charsToTuples [] |> List.foldr tuplesToString ""


tuplesToString : ( Char, Int ) -> String -> String
tuplesToString ( char, int ) string =
    let
        stringWithCharAdded =
            String.cons char string
    in
    if int == 1 then
        stringWithCharAdded

    else
        String.fromInt int ++ stringWithCharAdded


charsToTuples : Char -> List ( Char, Int ) -> List ( Char, Int )
charsToTuples char accumulator =
    let
        lastTuple : Maybe ( Char, Int )
        lastTuple =
            List.head accumulator

        lastChar : Maybe Char
        lastChar =
            Maybe.map Tuple.first lastTuple

        lastNumber : Int
        lastNumber =
            Maybe.map Tuple.second lastTuple |> Maybe.withDefault 1

        isRepeatChar : Bool
        isRepeatChar =
            Maybe.map ((==) char) lastChar |> Maybe.withDefault False

        incrementOldTuple : List ( Char, Int )
        incrementOldTuple =
            List.tail accumulator
                |> Maybe.withDefault []
                |> (::) ( char, lastNumber + 1 )

        appendNewTuple : List ( Char, Int )
        appendNewTuple =
            ( char, 1 ) :: accumulator
    in
    if isRepeatChar then
        incrementOldTuple

    else
        appendNewTuple



-- decoding


decode : String -> String
decode string =
    String.foldl decodingReducer "" string


decodingReducer : Char -> String -> String
decodingReducer char string =
    let
        number : String
        number =
            findNumberInString "" string

        digits : Int
        digits =
            String.length number

        stringWithNumberRemoved : String
        stringWithNumberRemoved =
            String.dropRight digits string

        appendNumForNextPass : Char -> String
        appendNumForNextPass numChar =
            string ++ String.fromChar numChar

        replaceNumWithRepeatChar : Char -> String
        replaceNumWithRepeatChar charToRepeat =
            number
                |> repeatChar charToRepeat
                |> (++) stringWithNumberRemoved
    in
    if not (Char.isDigit char) then
        replaceNumWithRepeatChar char

    else
        appendNumForNextPass char


findNumberInString : String -> String -> String
findNumberInString digitsAlreadyFound string =
    let
        current =
            String.right 1 string
    in
    if isNumber current then
        findNumberInString (current ++ digitsAlreadyFound) (String.dropRight 1 string)

    else
        digitsAlreadyFound


repeatChar : Char -> String -> String
repeatChar char numString =
    let
        times =
            Maybe.withDefault 1 (String.toInt numString)
    in
    String.repeat times (String.fromChar char)


isNumber : String -> Bool
isNumber x =
    case String.toInt x of
        Just _ ->
            True

        Nothing ->
            False
