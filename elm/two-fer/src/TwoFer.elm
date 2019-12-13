module TwoFer exposing (twoFer)


twoFer : Maybe String -> String
twoFer name =
    case name of
        Just nm ->
            "One for " ++ nm ++ ", one for me."
        Nothing ->
            "One for you, one for me."
