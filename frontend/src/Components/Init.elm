module Components.Init exposing (init)

import DefaultServices.Util as Util
import DefaultServices.Router as Router
import Components.Welcome.Init as WelcomeInit
import Components.Home.Init as HomeInit
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Components.Update exposing (update)
import Models.Route as Route


{-| Base Component Init.
-}
init : Result String Route.Route -> ( Model, Cmd Msg )
init routeResult =
    let
        route =
            Util.resultOr routeResult Route.HomeComponentMain

        {- This is the first interesting case of Elm type inference not doing the
           job perfectly. I say update takes a `model`, but I think because it
           doesn't use anything Elm doesn't make it pass in a full model, but then
           update calls other thing and causes runtime probelms with localStorage.
           TODO report to github elm issues
        -}
        defaultModel : Model
        defaultModel =
            { user = Nothing
            , route = route
            , homeComponent = HomeInit.init
            , welcomeComponent = WelcomeInit.init
            }
    in
        update LoadModelFromLocalStorage defaultModel
