port module Main exposing (..)

import Navigation
import Components.Init exposing (init)
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Components.View exposing (view)
import Components.Update exposing (update)
import Models.Route as Route
import DefaultServices.Util as Util
import Router
import DefaultServices.LocalStorage as LocalStorage
import Subscriptions exposing (subscriptions)


{-| The entry point to the elm application. The navigation module allows us to
use the `urlUpdate` field so we can essentially subscribe to url changes.
-}
main : Program Never Model Msg
main =
    Navigation.program
        OnLocationChange
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
