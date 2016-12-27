module Api exposing (getAccount, postLogin, postRegister, getLogOut)

import Models.ApiError as ApiError
import DefaultServices.Http as HttpService
import Config exposing (apiBaseUrl)
import Models.User as User
import Models.BasicResponse as BasicResponse


{-| Gets the users account, or an error if unauthenticated.
-}
getAccount : (ApiError.ApiError -> b) -> (User.User -> b) -> Cmd b
getAccount =
    HttpService.get (apiBaseUrl ++ "account") User.decoder


{-| Queries the API to log the user out, which should send a response to delete
the cookies.
-}
getLogOut : (ApiError.ApiError -> b) -> (BasicResponse.BasicResponse -> b) -> Cmd b
getLogOut =
    HttpService.get (apiBaseUrl ++ "logOut") BasicResponse.decoder


{-| Logs user in and returns the user, unless invalid credentials.
-}
postLogin : User.AuthUser -> (ApiError.ApiError -> b) -> (User.User -> b) -> Cmd b
postLogin user =
    HttpService.post (apiBaseUrl ++ "login") User.decoder (User.authEncoder user)


{-| Registers the user and returns the user, unless invalid new credentials.
-}
postRegister : User.AuthUser -> (ApiError.ApiError -> b) -> (User.User -> b) -> Cmd b
postRegister user =
    HttpService.post (apiBaseUrl ++ "register") User.decoder (User.authEncoder user)
