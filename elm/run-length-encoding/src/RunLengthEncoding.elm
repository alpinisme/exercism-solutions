module RunLengthEncoding exposing (decode, encode)

-- encoding


type alias CharCount =
    ( Char, Int )


encode : String -> String
encode string =
    let
        performCharCountingFold : ( Char, String ) -> ( CharCount, List CharCount )
        performCharCountingFold ( char, str ) =
            String.foldl countCharRepetitions ( ( char, 1 ), [] ) str

        reattachCounter : ( CharCount, List CharCount ) -> List CharCount
        reattachCounter ( tuple, list ) =
            tuple :: list
    in
    String.uncons string
        |> Maybe.map performCharCountingFold
        |> Maybe.map reattachCounter
        |> Maybe.withDefault []
        |> List.foldl stringifyCounts ""


countCharRepetitions : Char -> ( CharCount, List CharCount ) -> ( CharCount, List CharCount )
countCharRepetitions char ( ( lastChar, count ), accumulator ) =
    if char == lastChar then
        ( ( char, count + 1 ), accumulator )

    else
        ( ( char, 1 ), ( lastChar, count ) :: accumulator )


stringifyCounts : CharCount -> String -> String
stringifyCounts ( char, count ) accumulator =
    let
        accumulatorWithChar =
            String.cons char accumulator
    in
    if count == 1 then
        accumulatorWithChar

    else
        String.fromInt count ++ accumulatorWithChar



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

-- new section


