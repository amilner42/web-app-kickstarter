module Bulma exposing (formControl)

{-| General utility functions not closely tied to an existing module can be put here.
-}

import Html exposing (..)
import Html.Attributes exposing (..)


-- HTML


{-| A simple bulma form control with possible field-specific errors.
-}
formControl : (Bool -> Html msg) -> List String -> Html msg
formControl html errors =
    div [ class "field" ] <|
        [ div
            [ class "control" ]
            [ html <| not <| List.isEmpty errors ]
        ]
            ++ List.map
                (\error -> p [ class "help is-danger" ] [ text error ])
                errors
