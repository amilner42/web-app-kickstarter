module Components.View exposing (view)

import Html exposing (div, text)

import Components.Model exposing (Model)
import Components.Messages exposing (Msg)


{-| The view for the application base component. -}
view: Model -> Html.Html Msg
view model =
  let
    loggedIn = case model.user of
      Nothing ->
        False
      Just user ->
        True

    -- showScreen = case loggedIn of
    --   False ->

  in
    div [] [ text <| toString <| loggedIn]
