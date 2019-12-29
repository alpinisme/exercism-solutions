module LargestSeriesProduct exposing (largestProduct)

import Maybe.Extra


largestProduct : Int -> String -> Maybe Int
largestProduct length series =
    case compare length 0 of
        GT ->
            toIntList series
                |> makeSublists length 
                |> List.map List.product
                |> List.maximum

        EQ ->
            Just 1

        LT ->
            Nothing


toIntList : String -> List Int
toIntList string =
    String.toList string
        |> List.map (\c -> String.toInt (String.fromChar c))
        |> Maybe.Extra.combine
        |> Maybe.withDefault []


makeSublists : Int -> List Int -> List (List Int)
makeSublists length series =
    let
        step : List Int -> List (List Int) -> List (List Int)
        step list accumulator =

            if List.length list < length then
                accumulator

            else
                step  (Maybe.withDefault [] (List.tail list)) (List.take length list :: accumulator)
    in
    step series []
