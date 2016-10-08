module Api exposing (getAccount, postLogin, postRegister)

import Http

import Models.ApiError as ApiError
import DefaultServices.Http as HttpService
import Config exposing (apiBaseUrl)
import Models.User as User
import Models.PassportUser as PassportUser
import Components.Messages exposing (Msg)


{-| Gets the users account, or an error if unauthenticated. -}
getAccount: (ApiError.ApiError-> b) -> (User.User -> b) -> Cmd b
getAccount = HttpService.get (apiBaseUrl ++ "account") User.decoder


{-| Logs user in and returns the user, unless invalid credentials. -}
postLogin: PassportUser.PassportUser -> (ApiError.ApiError -> b) -> (User.User -> b) -> Cmd b
postLogin user =
  HttpService.post (apiBaseUrl ++ "login") User.decoder (PassportUser.toJsonString user)


{-| Registers the user and returns the user, unless invalid new credentials. -}
postRegister: PassportUser.PassportUser -> (ApiError.ApiError -> b) -> (User.User -> b) -> Cmd b
postRegister user =
  HttpService.post (apiBaseUrl ++ "register") User.decoder (PassportUser.toJsonString user)
