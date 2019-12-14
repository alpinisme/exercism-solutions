module TwoFer exposing (twoFer)


twoFer : Maybe String -> String
twoFer name =
    let
        shareWith : String -> String
        shareWith person =
            "One for " ++ person ++ ", one for me."
    in
    Maybe.map shareWith name
        |> Maybe.withDefault (shareWith "you")
