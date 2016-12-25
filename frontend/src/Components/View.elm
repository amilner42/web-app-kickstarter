module Components.View exposing (view)

import Html exposing (div, text)
import Html.Attributes exposing (class)
import Components.Model exposing (Model)
import Components.Messages exposing (Msg(..))
import Components.Home.View as HomeView
import Components.Welcome.View as WelcomeView
import DefaultServices.Util as Util
import Models.Route as Route


{-| Loads the correct view depending on the route we are on.

NOTE: The way we structure the routing we don't need to do ANY checking here
to see if the route being loaded is correct (eg. maybe their loading a route
that needs auth but they're not logged in) because that logic is already
handled in `handleLocationChange`. At the point this function is called, the
user has already changed their route, we've already approved that the route
change is good and updated the model, and now we just need to render it.
-}
viewForRoute : Model -> Html.Html Msg
viewForRoute model =
    let
        renderedWelcomeView =
            welcomeView model

        renderedHomeView =
            homeView model
    in
        case model.route of
            Route.WelcomeComponentRegister ->
                renderedWelcomeView

            Route.WelcomeComponentLogin ->
                renderedWelcomeView

            Route.HomeComponentMain ->
                renderedHomeView

            Route.HomeComponentProfile ->
                renderedHomeView


{-| The welcome view.
-}
welcomeView : Model -> Html.Html Msg
welcomeView model =
    Html.map WelcomeMessage (WelcomeView.view model)


{-| The home view.
-}
homeView : Model -> Html.Html Msg
homeView model =
    Html.map HomeMessage (HomeView.view model)


{-| Base component view.
-}
view : Model -> Html.Html Msg
view model =
    div
        [ class "base-component-wrapper" ]
        [ div
            [ class "base-component" ]
            [ viewForRoute model ]
        ]
