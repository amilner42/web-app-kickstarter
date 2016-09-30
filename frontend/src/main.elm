port module Main exposing (..)

import Html exposing (div, button)
import Html.Events exposing (onClick)
import Html.App as App

import Ports
import Types
import Models.Model as Model


-- Maybe gets a model based on user localStorage.
main: Program (Maybe Types.Model)
main =
  App.programWithFlags
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- Initializes application.
init: Maybe Types.Model -> (Types.Model, Cmd Types.Msg)
init model =
  case model of
    Just model ->
      (model, Cmd.none)
    Nothing ->
      (Types.Model Nothing, Cmd.none)

-- Updates the application.
update: Types.Msg -> Types.Model -> (Types.Model, Cmd Types.Msg)
update msg model  =
  case msg of
    Types.DoNothing -> (model, Cmd.none )
    Types.ModelLoaded model -> (model, Cmd.none)

-- The applications subscriptions
subscriptions: Types.Model -> Sub Types.Msg
subscriptions model =
  Sub.batch [
    Ports.onLoadModelFromLocalStorage onLoadModelFromLocalStorage
  ]

-- A subscription to loading the model from local storage.
onLoadModelFromLocalStorage: String -> Types.Msg
onLoadModelFromLocalStorage modelAsStringFromStorage =
  case Model.fromJsonString modelAsStringFromStorage of
    Ok model -> Types.ModelLoaded model
    Err error -> Types.DoNothing -- TODO deal with this

-- The applications view.
view: Types.Model -> Html.Html Types.Msg
view model =
  let
    email = case model.user of
      Nothing -> "nothing"
      Just user -> user.email
  in
    div []
      [ button [ onClick Types.DoNothing ] [],
        div [] [ Html.text email]
      ]
