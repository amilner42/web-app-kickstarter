module Components.Update exposing (update)

import Navigation

import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import Components.Models.Route as Route
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Api


{-| Updates the application base component. -}
update: Msg -> Model -> (Model, Cmd Msg)
update msg model  =
  case msg of
    NoOp ->
      (model, Cmd.none )
    LoadModelFromLocalStorage ->
      (model, LocalStorage.loadModel ())
    OnLoadModelFromLocalStorageSuccess model ->
      let
        routeUrl = Router.toUrl model.route
      in
        (model, Navigation.modifyUrl routeUrl)
    OnLoadModelFromLocalStorageFailure err ->
      (model, getUser ())
    GetUser ->
      (model, getUser ())
    OnGetUserSuccess user ->
      let
        newModel = { model | user = Just user }

        routeUrl = Router.toUrl newModel.route
      in
        (newModel, Cmd.batch
          [ (Navigation.modifyUrl routeUrl)
          , (LocalStorage.saveModel newModel)
          ]
        )
    OnGetUserFailure err ->
      let
        newModel = { model | route = Route.WelcomeComponent }

        routeUrl = Router.toUrl newModel.route
      in
        (model, Cmd.batch
          [ (Navigation.modifyUrl routeUrl)
          , (LocalStorage.saveModel newModel)
          ]
        )
    HomeMessage msg ->
      (model, Cmd.none) -- TODO
    WelcomeMessage msg ->
      (model, Cmd.none) -- TODO


{-| Gets the user from the API. -}
getUser: () -> Cmd Msg
getUser () =
  Api.getAccount OnGetUserFailure OnGetUserSuccess
