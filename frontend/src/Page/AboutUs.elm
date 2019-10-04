module Page.AboutUs exposing (view)

{-| A blank page.
-}

import Html exposing (..)
import Html.Attributes exposing (..)


view : { title : String, content : Html msg }
view =
    { title = "About"
    , content =
        section
            [ class "section is-medium" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "columns is-centered" ]
                    [ div
                        [ class "column is-half" ]
                        [ h1
                            [ class "title has-text-centered" ]
                            [ text "About Us" ]
                        , div
                            [ class "content has-text-centered" ]
                            [ text "Content Here" ]
                        ]
                    ]
                ]
            ]
    }
