module Components.Welcome.View exposing (..)

import Html exposing (Html, div, text, button, h1, input, form, a)
import Html.Attributes exposing (class, placeholder, type', value)
import Html.Events exposing (onClick, onInput)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.Util as Util
import DefaultServices.Router as Router
import Models.Route as Route


{-| In the case that the view is not passed a model (Nothing), then it must
initialize the model. -}
view: Model -> Html Msg
view model =
  Util.cssComponentNamespace
    "welcome"
    Nothing
    (
      div [] [ displayViewForRoute model ]
    )


{-| The welcome login view -}
loginView: Model -> Html Msg
loginView model =
  div
    [ ]
    [ h1
      [ class "title" ]
      [ text "Login" ]
    , form
      [ ]
      [ input
        [ placeholder "Email"
        , onInput OnEmailInput
        , value model.welcomeComponent.email
        ]
        [ ]
      , input
        [ placeholder "Password"
        , type' "password"
        , onInput OnPasswordInput
        , value model.welcomeComponent.password
        ]
        [ ]
      , button
        [ ]
        [ text "Login" ]
      ]
    , a
      [ onClick GoToRegisterView ]
      [ text "Don't have an account?"]
    ]


{-| The welcome register view -}
registerView: Model -> Html Msg
registerView model =
  div
    [ ]
    [ h1
      [ class "title" ]
      [ text "Register" ]
    , form
      [ ]
      [ input
        [ placeholder "Email"
        , onInput OnEmailInput
        , value model.welcomeComponent.email
        ]
        [ ]
      , input
        [ placeholder "Password"
        , type' "password"
        , onInput OnPasswordInput
        , value model.welcomeComponent.password
        ]
        [ ]
      , input
        [ placeholder "Confirm Password"
        , type' "password"
        , onInput OnConfirmPasswordInput
        , value model.welcomeComponent.confirmPassword
        ]
        [ ]
      , button
        [ ]
        [ text "Register"]
      ]
    , a
      [ onClick GoToLoginView ]
      [ text "Already have an account?" ]
    ]


{-| Displays the welcome sub-view based on the sub-route (login or register) -}
displayViewForRoute: Model -> Html Msg
displayViewForRoute model =
  let
    route =
      model.route
  in
    case route of
      Route.WelcomeComponentLogin ->
        loginView model
      Route.WelcomeComponentRegister ->
        registerView model
      _ ->
        loginView model -- TODO think about this case, although it should never happen...
