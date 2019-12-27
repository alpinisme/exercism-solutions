module RunLengthEncoding exposing (decode, encode)

import Parser exposing ((|=), Parser, Step(..))



-- encoding


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


type alias CharCount =
    ( Char, Int )


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



-- decode


decode : String -> String
decode string =
    Parser.run parser string
        |> Result.withDefault []
        |> List.map (\c -> String.repeat c.count c.char)
        |> String.concat
        |> String.reverse


type alias Count =
    { count : Int
    , char : String
    }


countParser : Parser Count
countParser =
    Parser.succeed Count
        |= Parser.oneOf
            [ Parser.succeed identity
                |= Parser.int
            , Parser.succeed 1
            ]
        |= (Parser.getChompedString <| Parser.chompIf (\char -> Char.isAlpha char || char == ' '))


parser : Parser (List Count)
parser =
    Parser.loop []
        (\counts ->
            Parser.oneOf
                [ Parser.succeed (\count -> Loop (count :: counts))
                    |= countParser
                , Parser.succeed ()
                    |> Parser.map (\_ -> Done counts)
                ]
        )
