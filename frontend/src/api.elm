module Api exposing (api)

import Http

import DefaultServices.Http as HttpService
import Models.User as User
import Types


-- TODO come up with a nice way to change this for production. Probably
-- environment variables is the way to go.
apiBaseUrl = "localhost:3000/api/"

-- Gets the users account, or an error if unauthenticated.
getAccount: Types.ApiRoute Types.User
getAccount = HttpService.get (apiBaseUrl ++ "account") User.decoder

-- Logs user in and returns the user, unless invalid credentials.
postLogin: Types.User -> Types.ApiRoute Types.User
postLogin user =
  HttpService.post (apiBaseUrl ++ "login") User.decoder (User.toJsonString user)

-- Registers the user and returns the user, unless invalid new credentials.
postRegister: Types.User -> Types.ApiRoute Types.User
postRegister user =
  HttpService.post (apiBaseUrl ++ "register") User.decoder (User.toJsonString user)

-- Exposed
-- The API is all accessed through this object.
api = {
  get = {
    account = getAccount
  },
  post = {
    login = postLogin,
    register = postRegister
  }
  }
