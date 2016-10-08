module Components.Home.View exposing (..)

import Html exposing (Html, div, text)
import Components.Model exposing (Model)
import Components.Home.Messages exposing (Msg)


{-| Home Component View.
-}
view : Model -> Html Msg
view model =
    div [] [ text "Home Component" ]
