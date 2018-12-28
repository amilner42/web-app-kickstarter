module Page.NotFound exposing (view)

import Asset
import Html exposing (..)
import Html.Attributes exposing (..)


-- VIEW


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        section
            [ class "section is-medium", tabindex -1 ]
            [ div
                [ class "container" ]
                [ div
                    [ class "columns is-centered" ]
                    [ div
                        [ class "column is-half" ]
                        [ h1
                            [ class "title has-text-centered" ]
                            [ text "Page Not Found" ]
                        ]
                    ]
                ]
            ]
    }
