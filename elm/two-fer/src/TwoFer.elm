module TwoFer exposing (twoFer)


twoFer : Maybe String -> String
twoFer name =
    let
        person =
            name |> Maybe.withDefault "you"
    in
    "One for " ++ person ++ ", one for me."
