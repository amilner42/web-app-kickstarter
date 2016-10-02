module Components.Messages exposing (..)

import Http

import Models.User exposing (User)
import Components.Model exposing (Model)


{-| All the messages for the base component. -}
type Msg
  = NoOp
  | ModelLoadedFromLocalStorage Model
  | GetUser
  | GetUserSuccess User
  | GetUserFailure Http.Error
