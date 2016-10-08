module Components.Update exposing (update)

import Navigation

import Components.Welcome.Update as WelcomeUpdate
import Components.Welcome.Init as WelcomeInit

import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)

import Models.Route as Route

import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Api


{-| Base Component Update. -}
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
    OnGetUserFailure newApiError ->
      let
        newModel = { model | route = Route.WelcomeComponentRegister }

        routeUrl = Router.toUrl newModel.route
      in
        (model, Cmd.batch
          [ (Navigation.modifyUrl routeUrl)
          , (LocalStorage.saveModel newModel)
          ]
        )
    HomeMessage subMsg ->
      (model, Cmd.none) -- TODO
    WelcomeMessage subMsg ->
      let
        (newModel, newSubMsg) =
          WelcomeUpdate.update subMsg model
      in
        (newModel, Cmd.map WelcomeMessage newSubMsg)


{-| Gets the user from the API. -}
getUser: () -> Cmd Msg
getUser () =
  Api.getAccount OnGetUserFailure OnGetUserSuccess
