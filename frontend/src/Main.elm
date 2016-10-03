port module Main exposing (..)

import Navigation

import Components.Init exposing (init)
import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import Components.View exposing (view)
import Components.Update exposing (update)
import DefaultServices.Util as Util
import Router
import Subscriptions exposing (subscriptions)


-- TODO need to drop the program flag, get local storage on init...

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
urlUpdate : Result String Router.Route -> Model -> ( Model, Cmd Msg )
urlUpdate routeResult model =
  let
    currentRoute = Util.resultOr routeResult Router.HomeComponent
  in
    ( { model | route = currentRoute }, Cmd.none )
