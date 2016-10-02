port module Main exposing (..)

import Html exposing (div, button)
import Html.Events exposing (onClick)
import Html.App as App
import Json.Encode as Encode
import Task

import Subscriptions exposing (subscriptions)
import Components.Model exposing (Model)
import Components.Update exposing (update)
import Components.View exposing (view)
import Components.Messages exposing (Msg (..))


{-| The entry point to the elm application. Accepts the model as a flag that way
the state can be cached in local storage and completely reopened when the user
opens their browser. -}
main: Program (Maybe Model)
main =
  App.programWithFlags
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


{-| Initializes the application -}
init: Maybe Model -> (Model, Cmd Msg)
init model =
  case model of
    Just model ->
      (model, Cmd.none)
    Nothing ->
      (update GetUser { user = Nothing })
