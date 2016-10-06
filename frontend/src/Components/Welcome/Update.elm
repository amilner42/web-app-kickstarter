module Components.Welcome.Update exposing (update)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Models.Route as Route


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    toDo = (model, Cmd.none)
  in
    case msg of
      OnPasswordInput newPassword ->
        let
          welcomeComponent = model.welcomeComponent

          newModel =
            { model | welcomeComponent =
              { welcomeComponent | password = newPassword}
            }
        in
          (newModel, Cmd.none)
      OnConfirmPasswordInput newConfirmPassword ->
        let
          welcomeComponent = model.welcomeComponent

          newModel =
            { model | welcomeComponent =
              { welcomeComponent | confirmPassword = newConfirmPassword }
            }
        in
          (newModel, Cmd.none)
      OnEmailInput newEmail ->
        let
          welcomeComponent = model.welcomeComponent

          newModel =
            { model | welcomeComponent =
              { welcomeComponent | email = newEmail }
            }
        in
          (newModel, LocalStorage.saveModel newModel)
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
        (model, Router.navigateTo Route.WelcomeComponentLogin)
      GoToRegisterView ->
        (model, Router.navigateTo Route.WelcomeComponentRegister)
