module SpaceAge exposing (Planet(..), ageOn)


type Planet
    = Mercury
    | Venus
    | Earth
    | Mars
    | Jupiter
    | Saturn
    | Uranus
    | Neptune


ageOn : Planet -> Float -> Float
ageOn planet seconds =
    let
        ageOnEarth =
            seconds / 31557600.0
    in
    case planet of
        Mercury ->
            ageOnEarth / 0.2408467 

        Venus ->
            ageOnEarth /  0.61519726 

        Earth ->
            ageOnEarth

        Mars ->
            ageOnEarth /  1.8808158

        Jupiter ->
            ageOnEarth /  11.862615 

        Saturn ->
            ageOnEarth /  29.447498 

        Uranus ->
             ageOnEarth / 84.016846 

        Neptune ->
            ageOnEarth /  164.79132
