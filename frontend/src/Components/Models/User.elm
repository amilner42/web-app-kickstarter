module Components.Models.User exposing (User, decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import DefaultServices.Util exposing (justValueOrNull)


{-| The User type. -}
type alias User =
  { email: String
  , password: Maybe(String)
  }


-- The decoder for a user.
decoder: Decode.Decoder User
decoder =
  Decode.object2 User
    ("email" := Decode.string)
    (Decode.maybe("password" := Decode.string))


-- The encoder for a user.
encoder: User -> Encode.Value
encoder user =
  Encode.object
    [ ("email", Encode.string user.email)
    , ("password", justValueOrNull Encode.string user.password)
    ]


-- Turns a user into a JSON string.
toJsonString: User -> String
toJsonString userRecord =
    Encode.encode 0 (encoder userRecord)


-- Turns a JSON string into a user.
fromJsonString: String -> Result String User
fromJsonString userJsonString =
    Decode.decodeString decoder userJsonString
