module Components.Welcome.Update exposing (update)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Models.Route as Route
import Models.ApiError as ApiError
import Api


{-| Welcome Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPasswordInput newPassword ->
            let
                welcomeComponent =
                    model.welcomeComponent

                newModel =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | password = newPassword }
                    }
            in
                ( wipeError newModel, Cmd.none )

        OnConfirmPasswordInput newConfirmPassword ->
            let
                welcomeComponent =
                    model.welcomeComponent

                newModel =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | confirmPassword = newConfirmPassword }
                    }
            in
                ( wipeError newModel, Cmd.none )

        OnEmailInput newEmail ->
            let
                welcomeComponent =
                    model.welcomeComponent

                newModel =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | email = newEmail }
                    }
            in
                ( wipeError newModel, Cmd.none )

        Register ->
            let
                passwordsMatch =
                    model.welcomeComponent.password == model.welcomeComponent.confirmPassword

                user =
                    { email = model.welcomeComponent.email
                    , password = model.welcomeComponent.password
                    }

                welcomeComponent =
                    model.welcomeComponent

                newModelIfPasswordsDontMatch =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | apiError = Just ApiError.PasswordDoesNotMatchConfirmPassword }
                    }
            in
                case passwordsMatch of
                    True ->
                        ( model, Api.postRegister user OnRegisterFailure OnRegisterSuccess )

                    False ->
                        ( newModelIfPasswordsDontMatch, Cmd.none )

        OnRegisterFailure newApiError ->
            let
                welcomeComponent =
                    model.welcomeComponent

                newModel =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | apiError = Just newApiError }
                    }
            in
                ( newModel, Cmd.none )

        OnRegisterSuccess newUser ->
            let
                newModel =
                    { model | user = Just newUser, route = Route.HomeComponentMain }
            in
                ( newModel, Router.navigateTo newModel.route )

        Login ->
            let
                user =
                    { email = model.welcomeComponent.email
                    , password = model.welcomeComponent.password
                    }
            in
                ( model, Api.postLogin user OnLoginFailure OnLoginSuccess )

        OnLoginSuccess newUser ->
            let
                newModel =
                    { model | user = Just newUser, route = Route.HomeComponentMain }
            in
                ( newModel, Router.navigateTo newModel.route )

        OnLoginFailure newApiError ->
            let
                welcomeComponent =
                    model.welcomeComponent

                newModel =
                    { model
                        | welcomeComponent =
                            { welcomeComponent | apiError = Just newApiError }
                    }
            in
                ( newModel, Cmd.none )

        GoToLoginView ->
            ( wipeError model, Router.navigateTo Route.WelcomeComponentLogin )

        GoToRegisterView ->
            ( wipeError model, Router.navigateTo Route.WelcomeComponentRegister )


{-| Wipes the `apiError` from the `model.welcomeComponent`.
-}
wipeError : Model -> Model
wipeError model =
    let
        welcomeComponent =
            model.welcomeComponent

        newModel =
            { model
                | welcomeComponent =
                    { welcomeComponent | apiError = Nothing }
            }
    in
        newModel
