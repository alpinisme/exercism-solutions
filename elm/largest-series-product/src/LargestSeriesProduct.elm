module LargestSeriesProduct exposing (largestProduct)

import Maybe.Extra


largestProduct : Int -> String -> Maybe Int
largestProduct length series =
    case compare length 0 of
        GT ->
            toListInt series
                |> makeSublists length []
                |> List.map List.product
                |> List.maximum

        EQ ->
            Just 1

        LT ->
            Nothing


toListInt : String -> List Int
toListInt string =
    String.toList string
        |> List.map (\c -> String.toInt (String.fromChar c))
        |> Maybe.Extra.combine
        |> Maybe.withDefault []


makeSublists : Int -> List (List Int) -> List Int -> List (List Int)
makeSublists length accumulator list =
    if List.length list < length then
        accumulator

    else
        makeSublists length (List.take length list :: accumulator) (Maybe.withDefault [] (List.tail list))
