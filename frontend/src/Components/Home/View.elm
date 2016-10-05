module Components.Home.View exposing (..)

import Html exposing (Html, div, text)

import Components.Model exposing (Model)
import Components.Home.Messages exposing (Msg)


{-| In the case that the view is not passed a model (Nothing), then it must
initialize the model. -}
view: Model -> Html Msg
view model =
  div [] [ text "Home Component"]
