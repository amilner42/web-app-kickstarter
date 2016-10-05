module Components.Welcome.Update exposing (update)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))


{-| TODO implement and doc... -}
update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    toDo = (model, Cmd.none)
  in
    case msg of
      Register ->
        toDo
      OnRegisterFailure httpError ->
        toDo
      OnRegisterSuccess user ->
        toDo
      Login ->
        toDo
      OnLoginSuccesss user ->
        toDo
      OnLoginFailure httpError ->
        toDo
      GoToLoginView ->
        toDo
      GoToRegisterView ->
        toDo
