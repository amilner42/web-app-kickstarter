module Components.View exposing (view)

import Html exposing (div, text)
import Html.App

import Components.Model exposing (Model)
import Components.Messages exposing (Msg(..))
import Components.Home.View as HomeView
import Components.Welcome.View as WelcomeView
import Components.Models.Route as Route


{-| The view for the application base component. -}
view: Model -> Html.Html Msg
view model =
  let
    loggedIn = case model.user of
      Nothing ->
        False
      Just user ->
        True

    welcomeView =
      Html.App.map WelcomeMessage (WelcomeView.view model.welcomeComponent)

    homeView =
      Html.App.map HomeMessage (HomeView.view model.homeComponent)

    componentViewForRoute = case loggedIn of
      False ->
        welcomeView
      True ->
        -- For now this case is not needed, but for future if the user is
        -- loggedIn we want them to be able to go straight to their page.
        case model.route of
          Route.WelcomeComponent ->
            homeView
          Route.HomeComponent ->
            homeView
  in
    div [] [ componentViewForRoute ]
