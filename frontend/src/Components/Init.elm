module Components.Init exposing (init)

import DefaultServices.Util as Util
import Router
import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import Components.Update exposing (update)
import Components.Models.Route as Route


{-| Initializes the application -}
init: Result String Route.Route -> (Model, Cmd Msg)
init routeResult =
  let
    route = Util.resultOr routeResult Route.HomeComponent

    -- This is the first interesting case of Elm type inference not doing the
    -- job perfectly. I say update takes a `model`, but I think because it
    -- doesn't use anything Elm doesn't make it pass in a full model, but then
    -- update calls other thing and causes runtime probelms with localStorage.
    -- TODO report to github elm issues
    defaultModel: Model
    defaultModel =
      { user = Nothing
      , route = route
      , homeComponent = Nothing
      , welcomeComponent = Nothing
      }
  in
    update LoadModelFromLocalStorage defaultModel
