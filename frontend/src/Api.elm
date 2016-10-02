module Api exposing (ApiRoute, getAccount, postLogin, postRegister)

import Http

import DefaultServices.Http as HttpService
import Models.User as User
import Components.Messages exposing (Msg)


{-| The result of calling an API route, you have to deal with both the sucess
and failure cases. -}
type alias ApiRoute a b = (Http.Error -> b) -> (a -> b) -> Cmd b


{-| The API base URL.

TODO Come up with a nice way to change this for production, probably using
environment variables. -}
apiBaseUrl: String
apiBaseUrl = "http://localhost:3000/api/"


{-| Gets the users account, or an error if unauthenticated. -}
getAccount: ApiRoute User.User Msg
getAccount = HttpService.get (apiBaseUrl ++ "account") User.decoder


{-| Logs user in and returns the user, unless invalid credentials. -}
postLogin: User.User -> ApiRoute User.User Msg
postLogin user =
  HttpService.post (apiBaseUrl ++ "login") User.decoder (User.toJsonString user)


{-| Registers the user and returns the user, unless invalid new credentials. -}
postRegister: User.User -> ApiRoute User.User Msg
postRegister user =
  HttpService.post (apiBaseUrl ++ "register") User.decoder (User.toJsonString user)
