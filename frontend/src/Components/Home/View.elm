module Components.Home.View exposing (..)

import Models.Route as Route
import Html exposing (Html, div, text, button, input, h1, h3)
import Html.Attributes exposing (class, placeholder, value, hidden)
import Html.Events exposing (onClick, onInput)
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
    div []
        [ h1
            []
            [ text "Profile View" ]
        , h3
            []
            [ text <|
                "Notice going back and forth (navigation) works between the"
                    ++ " home view and the profile view."
            ]
        , button
            [ onClick LogOut ]
            [ text "Log out" ]
        , div
            [ hidden <| Util.isNothing model.homeComponent.logOutError ]
            [ text "Cannot log out right now, try again shortly." ]
        ]


{-| The Main view.
-}
mainView : Model -> Html Msg
mainView model =
    div []
        [ h1
            []
            [ text "Main View" ]
        , h3
            []
            [ text <|
                "Check out cacheing by entering data and closing/reopening"
                    ++ " browser"
            ]
        , input
            [ onInput OnDataOneChange
            , placeholder "Random data 1"
            , value model.homeComponent.dataOne
            ]
            []
        , input
            [ onInput OnDataTwoChange
            , placeholder "Random data 2"
            , value model.homeComponent.dataTwo
            ]
            []
        ]
