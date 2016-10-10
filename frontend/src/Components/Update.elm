module Components.Update exposing (update, updateCacheIf)

import Navigation
import Components.Home.Update as HomeUpdate
import Components.Welcome.Update as WelcomeUpdate
import Components.Welcome.Init as WelcomeInit
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Models.Route as Route
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Api


{-| Base Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateCacheIf msg model True


{-| Sometimes we don't want to save to the cache, for example when the website
originally loads if we save to cache we end up loading what we saved (the
default model) instead of what was in their before.
-}
updateCacheIf : Msg -> Model -> Bool -> ( Model, Cmd Msg )
updateCacheIf msg model shouldCache =
    let
        ( newModel, newCmd ) =
            case msg of
                NoOp ->
                    ( model, Cmd.none )

                LoadModelFromLocalStorage ->
                    ( model, LocalStorage.loadModel () )

                OnLoadModelFromLocalStorageSuccess newModel ->
                    ( newModel, Router.navigateTo model.route )

                OnLoadModelFromLocalStorageFailure err ->
                    ( model, getUser () )

                GetUser ->
                    ( model, getUser () )

                OnGetUserSuccess user ->
                    let
                        newModel =
                            { model | user = Just user }
                    in
                        ( newModel, Router.navigateTo newModel.route )

                OnGetUserFailure newApiError ->
                    let
                        newModel =
                            { model | route = Route.WelcomeComponentRegister }
                    in
                        ( model, Router.navigateTo newModel.route )

                HomeMessage subMsg ->
                    let
                        ( newModel, newSubMsg ) =
                            HomeUpdate.update subMsg model
                    in
                        ( newModel, Cmd.map HomeMessage newSubMsg )

                WelcomeMessage subMsg ->
                    let
                        ( newModel, newSubMsg ) =
                            WelcomeUpdate.update subMsg model
                    in
                        ( newModel, Cmd.map WelcomeMessage newSubMsg )
    in
        case shouldCache of
            True ->
                ( newModel
                , Cmd.batch
                    [ newCmd
                    , LocalStorage.saveModel newModel
                    ]
                )

            False ->
                ( newModel, newCmd )


{-| Gets the user from the API.
-}
getUser : () -> Cmd Msg
getUser () =
    Api.getAccount OnGetUserFailure OnGetUserSuccess
