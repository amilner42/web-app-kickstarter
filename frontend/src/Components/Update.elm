module Components.Update exposing (update, updateCacheIf)

import Navigation
import Components.Home.Update as HomeUpdate
import Components.Welcome.Update as WelcomeUpdate
import Components.Welcome.Init as WelcomeInit
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Models.Route as Route
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Util as Util
import Router
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

                OnLocationChange location ->
                    let
                        newRoute =
                            Router.parseLocation location
                    in
                        handleLocationChange newRoute model

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


{-| Updates the model `route` field when the route is updated. This function
handles the cases where the user is logged in and goes to an unauth-page like
welcome or where the user isn't logged in and goes to an auth-page. You simply
need to specify `routesNotNeedingAuth`, `defaultUnauthRoute`, and
`defaultAuthRoute` in your `Routes` model. It also handles users going to
routes that don't exist (just goes `back` to the route they were on before).
-}
handleLocationChange : Maybe Route.Route -> Model -> ( Model, Cmd msg )
handleLocationChange routeResult model =
    case routeResult of
        Nothing ->
            ( model, Navigation.back 1 )

        Just route ->
            let
                loggedIn =
                    Util.isNotNothing model.user

                routeNeedsAuth =
                    not <| List.member route Route.routesNotNeedingAuth

                modelWithRoute route =
                    { model | route = route }
            in
                case loggedIn of
                    False ->
                        case routeNeedsAuth of
                            -- not logged in, route doesn't need auth, good
                            False ->
                                let
                                    newModel =
                                        modelWithRoute route
                                in
                                    ( newModel, LocalStorage.saveModel newModel )

                            -- not logged in, route needs auth, bad - redirect.
                            True ->
                                let
                                    newModel =
                                        modelWithRoute Route.defaultUnauthRoute

                                    newCmd =
                                        Cmd.batch
                                            [ Router.navigateTo newModel.route
                                            , LocalStorage.saveModel newModel
                                            ]
                                in
                                    ( newModel, newCmd )

                    True ->
                        case routeNeedsAuth of
                            -- logged in, route doesn't need auth, bad - redirect.
                            False ->
                                let
                                    newModel =
                                        modelWithRoute Route.defaultAuthRoute

                                    newCmd =
                                        Cmd.batch
                                            [ Router.navigateTo newModel.route
                                            , LocalStorage.saveModel newModel
                                            ]
                                in
                                    ( newModel, newCmd )

                            -- logged in, route needs auth, good.
                            True ->
                                let
                                    newModel =
                                        modelWithRoute route
                                in
                                    ( newModel, LocalStorage.saveModel newModel )
