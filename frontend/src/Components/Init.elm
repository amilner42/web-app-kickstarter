module Components.Init exposing (init)

import DefaultServices.Util as Util
import Router
import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import Components.Update exposing (update)


{-| Initializes the application -}
init: Result String Router.Route -> (Model, Cmd Msg)
init routeResult =
  let
    -- TODO logic here needs a re-think...
    route = Util.resultOr routeResult Router.WelcomeComponent
    defaultModel = { user = Nothing, route = route }
  in
    update LoadModelFromLocalStorage defaultModel
