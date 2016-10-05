module Components.Welcome.View exposing (..)

import Html exposing (Html, div, text)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg)
import DefaultServices.Util as Util
import DefaultServices.Router as Router


{-| In the case that the view is not passed a model (Nothing), then it must
initialize the model. -}
view: Model -> Html Msg
view model =
  Util.cssComponentNamespace
    "welcome"
    Nothing
    (
      div [] [ text <| Router.toUrl <| model.route ]
    )
