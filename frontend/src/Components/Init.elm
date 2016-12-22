module Components.Init exposing (init)

import DefaultServices.Util as Util
import Components.Welcome.Init as WelcomeInit
import Components.Home.Init as HomeInit
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Components.Update exposing (updateCacheIf)
import Models.Route as Route
import DefaultModel exposing (defaultModel)
import Navigation
import Router
import Maybe


{-| Base Component Init.
-}
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Maybe.withDefault
                Route.HomeComponentMain
                (Router.parseLocation location)

        defaultModelWithRoute : Model
        defaultModelWithRoute =
            { defaultModel | route = route }
    in
        updateCacheIf LoadModelFromLocalStorage defaultModelWithRoute False
