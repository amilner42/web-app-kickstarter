module Components.Welcome.Update exposing (update)

import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Models.Route as Route

import Api


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
        let
          -- TODO check if passwords match on frontend
          user =
            { username = model.welcomeComponent.email
            , password = model.welcomeComponent.password
            }
        in
          (model, Api.postRegister user OnRegisterFailure OnRegisterSuccess)
      OnRegisterFailure httpError ->
        toDo
      OnRegisterSuccess newUser ->
        let
          newModel = { model | user = Just newUser, route = Route.HomeComponent }
        in
        (newModel
        , Cmd.batch
          [ LocalStorage.saveModel newModel
          , Router.navigateTo newModel.route
          ]
        )
      Login ->
        let
          user =
            { username = model.welcomeComponent.email
            , password = model.welcomeComponent.password
            }
        in
          (model, Api.postLogin user OnLoginFailure OnLoginSuccess)
      OnLoginSuccess newUser ->
        let
          newModel = { model | user = Just newUser, route = Route.HomeComponent }
        in
        (newModel
        , Cmd.batch
          [ LocalStorage.saveModel newModel
          , Router.navigateTo newModel.route
          ]
        )
      OnLoginFailure httpError ->
        toDo
      GoToLoginView ->
        (model, Router.navigateTo Route.WelcomeComponentLogin)
      GoToRegisterView ->
        (model, Router.navigateTo Route.WelcomeComponentRegister)
