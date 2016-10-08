module Components.View exposing (view)

import Html exposing (div, text)
import Html.App
import Html.Attributes exposing (class)
import Components.Model exposing (Model)
import Components.Messages exposing (Msg(..))
import Components.Home.View as HomeView
import Components.Welcome.View as WelcomeView
import DefaultServices.Util as Util
import Models.Route as Route


{-| Base Component View.
-}
view : Model -> Html.Html Msg
view model =
    let
        loggedIn =
            case model.user of
                Nothing ->
                    False

                Just user ->
                    True

        welcomeView =
            Html.App.map WelcomeMessage (WelcomeView.view model)

        homeView =
            Html.App.map HomeMessage (HomeView.view model)

        componentViewForRoute =
            case loggedIn of
                False ->
                    welcomeView

                True ->
                    {- For now this case is not needed, but for future if the
                       user is loggedIn we want them to be able to go straight
                       to their page.
                    -}
                    case model.route of
                        Route.WelcomeComponentRegister ->
                            homeView

                        Route.WelcomeComponentLogin ->
                            homeView

                        Route.HomeComponentMain ->
                            homeView

                        Route.HomeComponentProfile ->
                            homeView
    in
        Util.cssComponentNamespace
            "base"
            Nothing
            componentViewForRoute
