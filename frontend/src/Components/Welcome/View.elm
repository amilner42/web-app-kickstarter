module Components.Welcome.View exposing (..)

import Html exposing (Html, div, text)

import Components.Welcome.Messages exposing (Msg)
import Components.Welcome.Model exposing (Model)


{-| In the case that the view is not passed a model (Nothing), then it must
initialize the model. -}
view: Maybe(Model) -> Html Msg
view model =
  div [] [ text "Welcome Component"]
