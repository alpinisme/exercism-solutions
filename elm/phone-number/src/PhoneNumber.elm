module PhoneNumber exposing (getNumber)


getNumber : String -> Maybe String
getNumber phoneNumber =
    String.foldr stripNonDigits (Just "") phoneNumber
        |> Maybe.andThen validate


validate : String -> Maybe String
validate number =
    let
        zeroes =
            String.indexes "0" number

        ones =
            String.indexes "1" number
    in
    if not <| String.length number == 10 then
        Nothing

    else if List.member 0 zeroes || List.member 4 zeroes || List.member 0 ones || List.member 4 ones then
        Nothing

    else
        Just number


stripNonDigits : Char -> Maybe String -> Maybe String
stripNonDigits char string =
    if List.member char [ '(', ')', '-', '.', ' ' ] then
        string

    else if Char.isDigit char then
        Maybe.map (String.cons char) string

    else
        Nothing
