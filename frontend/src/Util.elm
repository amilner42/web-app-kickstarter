module Util exposing (divFieldControl)

{-| General utility functions not closely tied to an existing module can be put here.
-}

import Html exposing (..)
import Html.Attributes exposing (..)


-- HTML


{-| Nested divs when you need html within a field and control div.
-}
divFieldControl : Html msg -> Html msg
divFieldControl html =
    div [ class "field" ]
        [ div
            [ class "control" ]
            [ html ]
        ]
