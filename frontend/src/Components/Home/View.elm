module Components.Home.View exposing (..)

import Models.Route as Route
import Html exposing (Html, div, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import DefaultServices.Util as Util
import Components.Model exposing (Model)
import Components.Home.Messages exposing (Msg(..))


{-| Home Component View.
-}
view : Model -> Html Msg
view model =
    Util.cssComponentNamespace
        "home"
        Nothing
        (div []
            [ navbar model
            , displayViewForRoute model
            ]
        )


{-| Displays the correct view based on the model.
-}
displayViewForRoute : Model -> Html Msg
displayViewForRoute model =
    case model.route of
        Route.HomeComponentMain ->
            mainView model

        Route.HomeComponentProfile ->
            profileView model

        -- This should never happen.
        _ ->
            mainView model


{-| Horizontal navbar to go above the views.
-}
navbar : Model -> Html Msg
navbar model =
    let
        profileViewSelected =
            model.route == Route.HomeComponentProfile

        mainViewSelected =
            model.route == Route.HomeComponentMain
    in
        div [ class "nav" ]
            [ div
                [ class <| Util.withClassesIf "nav-btn left" "selected" mainViewSelected
                , onClick GoToMainView
                ]
                [ text "Home" ]
            , div
                [ class <| Util.withClassesIf "nav-btn right" "selected" profileViewSelected
                , onClick GoToProfileView
                ]
                [ text "Profile" ]
            ]


{-| The Profile view.
-}
profileView : Model -> Html Msg
profileView model =
    div [] [ text "The profile view!" ]


{-| The Main view.
-}
mainView : Model -> Html Msg
mainView model =
    div [] [ text "The main view!" ]
