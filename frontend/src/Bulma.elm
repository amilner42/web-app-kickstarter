module Bulma exposing (formControl)

{-| Helpers for working with html and css with Bulma.

Bulma: <https://bulma.io/>

NOTE: There is a package for working with Bulma in Elm but I don't want to use it in this
kickstarter without having used it a bit and made sure it's helpful.

-}

import Html exposing (..)
import Html.Attributes exposing (..)



-- HTML


{-| A simple bulma form control with possible field-specific errors.

This will send your html in your control a bool representing whether there is currently
an error, this is helpful for changing css classes on the input.

-}
formControl : (Bool -> Html msg) -> List String -> Html msg
formControl htmlInput errors =
    div [ class "field" ] <|
        [ div
            [ class "control" ]
            [ htmlInput <| not <| List.isEmpty errors ]
        ]
            ++ List.map
                (\error -> p [ class "help is-danger" ] [ text error ])
                errors
