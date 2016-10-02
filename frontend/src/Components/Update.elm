module Components.Update exposing (update)

import Components.Messages exposing (Msg (..))
import Components.Model exposing (Model)
import DefaultServices.LocalStorage as LocalStorage
import Api


{-| Updates the application base component. -}
update: Msg -> Model -> (Model, Cmd Msg)
update msg model  =
  case msg of
    NoOp ->
      (model, Cmd.none )
    ModelLoadedFromLocalStorage model ->
      (model, Cmd.none)
    GetUser ->
      (model, getUser () )
    GetUserSuccess user ->
      let
        newModel = { model | user = Just user }
      in
        (newModel, LocalStorage.saveModel newModel)
    GetUserFailure err ->
      (model, Cmd.none)


{-| Gets the user from the API. -}
getUser: () -> Cmd Msg
getUser () =
  Api.getAccount GetUserFailure GetUserSuccess
