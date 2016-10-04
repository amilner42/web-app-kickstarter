module Components.Messages exposing (..)

import Http

import Components.Models.User exposing (User)
import Components.Model exposing (Model)
import Components.Home.Messages as HomeMessages
import Components.Welcome.Messages as WelcomeMessages


{-| All the messages for the base component. -}
type Msg
  = NoOp
  | LoadModelFromLocalStorage
  | OnLoadModelFromLocalStorageSuccess Model
  | OnLoadModelFromLocalStorageFailure String
  | GetUser
  | OnGetUserSuccess User
  | OnGetUserFailure Http.Error
  | HomeMessage HomeMessages.Msg
  | WelcomeMessage WelcomeMessages.Msg
