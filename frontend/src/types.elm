module Types exposing (..)

import Http

{- Fundamental To Elm Architecture
   The app `Msg`.
-}
type Msg = DoNothing
  | ModelLoaded Model

{- Fundamental To Elm Architecture
   The app `Model`.
-}
type alias Model = { user: Maybe(User) }

-- A user.
type alias User =
  {
    email: String,
    password: Maybe(String)
  }

{- Every Api route will return one of these (possibly needing an additional body
   param first if it is a POST request)
-}
type alias ApiRoute a = (Http.Error -> Msg) -> (a -> Msg) -> Cmd Msg
