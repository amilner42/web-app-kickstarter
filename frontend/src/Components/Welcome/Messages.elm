module Components.Welcome.Messages exposing (Msg)

import Http

import Models.User exposing (User)


{-| The messages for the welcome component. -}
type Msg
  = Register
  | OnRegisterSuccess User
  | OnRegisterFailure Http.Error
  | Login
  | OnLoginSuccesss User
  | OnLoginFailure Http.Error
  | GoToRegisterView
  | GoToLoginView
