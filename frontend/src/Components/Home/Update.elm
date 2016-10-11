module Components.Home.Update exposing (update)

import DefaultServices.Router as Router
import DefaultServices.LocalStorage as LocalStorage
import Components.Home.Messages exposing (Msg(..))
import Components.Home.Init as HomeInit
import Components.Welcome.Init as WelcomeInit
import Components.Model exposing (Model)
import Models.Route as Route
import Api
import DefaultModel exposing (defaultModel)


{-| Home Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToMainView ->
            let
                newModel =
                    { model | route = Route.HomeComponentMain }
            in
                ( newModel, Router.navigateTo newModel.route )

        GoToProfileView ->
            let
                newModel =
                    { model | route = Route.HomeComponentProfile }
            in
                ( newModel, Router.navigateTo newModel.route )

        OnDataOneChange newDataOne ->
            let
                homeComponent =
                    model.homeComponent

                newModel =
                    { model
                        | homeComponent =
                            { homeComponent | dataOne = newDataOne }
                    }
            in
                ( newModel, Cmd.none )

        OnDataTwoChange newDataTwo ->
            let
                homeComponent =
                    model.homeComponent

                newModel =
                    { model
                        | homeComponent =
                            { homeComponent | dataTwo = newDataTwo }
                    }
            in
                ( newModel, Cmd.none )

        LogOut ->
            ( model, Api.getLogOut OnLogOutFailure OnLogOutSuccess )

        OnLogOutFailure apiError ->
            let
                homeComponent =
                    model.homeComponent

                newModel =
                    { model
                        | homeComponent =
                            { homeComponent | logOutError = Just apiError }
                    }
            in
                ( newModel, Cmd.none )

        OnLogOutSuccess basicResponse ->
            ( defaultModel, Router.navigateTo Route.WelcomeComponentLogin )
