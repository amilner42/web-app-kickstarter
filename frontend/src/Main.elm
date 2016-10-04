port module Main exposing (..)

import Navigation

import Components.Init exposing (init)
import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import Components.View exposing (view)
import Components.Update exposing (update)
import Components.Models.Route as Route
import DefaultServices.Util as Util
import DefaultServices.Router as Router
import DefaultServices.LocalStorage as LocalStorage
import Subscriptions exposing (subscriptions)


{-| The entry point to the elm application. The navigation module allows us to
use the `urlUpdate` field so we can essentially subscribe to url changes. -}
main: Program Never
main =
  Navigation.program Router.parser
    { init = init
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    , view = view
    }


{-| Updates the model `route` field when the route is updated. -}
urlUpdate : Result String Route.Route -> Model -> ( Model, Cmd Msg )
urlUpdate routeResult model =
  case routeResult of
    Ok route ->
      let
        newModel =
          { model | route = route }
      in
        (newModel, Cmd.none)
    Err err ->
      (model, Navigation.back 1)
