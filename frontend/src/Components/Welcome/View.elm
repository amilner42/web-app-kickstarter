module Components.Welcome.View exposing (view)

import Html exposing (Html, div, text, button, h1, input, form, a)
import Html.Attributes exposing (class, placeholder, type_, value, hidden, disabled, classList)
import Html.Events exposing (onClick, onInput)
import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.Util as Util
import Models.Route as Route
import Models.ApiError as ApiError


{-| The welcome View.
-}
view : Model -> Html Msg
view model =
    div
        [ class "welcome-component-wrapper" ]
        [ div
            [ class "welcome-component" ]
            [ div
                []
                [ displayViewForRoute model
                ]
            ]
        ]


{-| Creates an error box with an appropriate message if there is an error,
otherwise simply stays hidden.
-}
errorBox : Maybe (ApiError.ApiError) -> Html Msg
errorBox maybeApiError =
    let
        humanReadable maybeApiError =
            case maybeApiError of
                -- Hidden when no error so this doesn't matter
                Nothing ->
                    ""

                Just apiError ->
                    ApiError.humanReadable apiError
    in
        div
            [ class "welcome-error-box"
            , hidden <| Util.isNothing <| maybeApiError
            ]
            [ text <| humanReadable <| maybeApiError ]


{-| The welcome login view
-}
loginView : Model -> Html Msg
loginView model =
    let
        currentError =
            model.welcomeComponent.apiError

        highlightEmail =
            currentError == Just ApiError.NoAccountExistsForEmail

        hightlightPassword =
            currentError == Just ApiError.IncorrectPasswordForEmail

        incompleteForm =
            List.member
                ""
                [ model.welcomeComponent.email
                , model.welcomeComponent.password
                ]

        invalidForm =
            incompleteForm || Util.isNotNothing currentError
    in
        div
            []
            [ h1
                [ class "title" ]
                [ text "Login" ]
            , div
                [ class "welcome-form" ]
                [ input
                    [ classList [ ( "input-error-highlight", highlightEmail ) ]
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ classList [ ( "input-error-highlight", hightlightPassword ) ]
                    , placeholder "Password"
                    , type_ "password"
                    , onInput OnPasswordInput
                    , value model.welcomeComponent.password
                    ]
                    []
                , errorBox currentError
                , button
                    [ onClick Login
                    , disabled invalidForm
                    ]
                    [ text "Login" ]
                ]
            , a
                [ onClick GoToRegisterView ]
                [ text "Don't have an account?" ]
            ]


{-| The welcome register view
-}
registerView : Model -> Html Msg
registerView model =
    let
        currentError =
            model.welcomeComponent.apiError

        highlightEmail =
            List.member
                currentError
                [ Just ApiError.InvalidEmail
                , Just ApiError.EmailAddressAlreadyRegistered
                ]

        hightlightPassword =
            List.member
                currentError
                [ Just ApiError.InvalidPassword
                , Just ApiError.PasswordDoesNotMatchConfirmPassword
                ]

        incompleteForm =
            List.member
                ""
                [ model.welcomeComponent.email
                , model.welcomeComponent.password
                , model.welcomeComponent.confirmPassword
                ]

        invalidForm =
            incompleteForm || Util.isNotNothing currentError
    in
        div
            []
            [ h1
                [ class "title" ]
                [ text "Register" ]
            , div
                [ class "welcome-form" ]
                [ input
                    [ classList [ ( "input-error-highlight", highlightEmail ) ]
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ classList [ ( "input-error-highlight", hightlightPassword ) ]
                    , placeholder "Password"
                    , type_ "password"
                    , onInput OnPasswordInput
                    , value model.welcomeComponent.password
                    ]
                    []
                , input
                    [ classList [ ( "input-error-highlight", hightlightPassword ) ]
                    , placeholder "Confirm Password"
                    , type_ "password"
                    , onInput OnConfirmPasswordInput
                    , value model.welcomeComponent.confirmPassword
                    ]
                    []
                , errorBox currentError
                , button
                    [ onClick Register
                    , disabled invalidForm
                    ]
                    [ text "Register" ]
                ]
            , a
                [ onClick GoToLoginView ]
                [ text "Already have an account?" ]
            ]


{-| Displays the welcome sub-view based on the sub-route (login or register)
-}
displayViewForRoute : Model -> Html Msg
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
                -- TODO think about this case, although it should never happen.
                loginView model
