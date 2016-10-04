module Components.Update exposing (update)

import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
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
      (model, Cmd.none)
    OnLoadModelFromLocalStorageFailure err ->
      (model, getUser ())
    GetUser ->
      (model, getUser () )
    OnGetUserSuccess user ->
      let
        newModel = { model | user = Just user }
      in
        (newModel, LocalStorage.saveModel newModel)
    OnGetUserFailure err ->
      (model, LocalStorage.saveModel model)
    HomeMessage msg ->
      (model, Cmd.none) -- TODO
    WelcomeMessage msg ->
      (model, Cmd.none) -- TODO


{-| Gets the user from the API. -}
getUser: () -> Cmd Msg
getUser () =
  Api.getAccount OnGetUserFailure OnGetUserSuccess
