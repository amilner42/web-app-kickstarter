module Models.User exposing (decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import DefaultServices.Util exposing (justValueOrNull)
import Types


-- The decoder for a user.
decoder: Decode.Decoder Types.User
decoder =
  Decode.object2 Types.User
    ("email" := Decode.string)
    (Decode.maybe("password" := Decode.string))

-- The encoder for a user.
encoder: Types.User -> Encode.Value
encoder user =
  Encode.object
    [
      ("email", Encode.string user.email),
      ("password", justValueOrNull Encode.string user.password)
    ]

-- Turns a user into a JSON string.
toJsonString: Types.User -> String
toJsonString userRecord =
    Encode.encode 0 (encoder userRecord)

-- Turns a JSON string into a user.
fromJsonString: String -> Result String Types.User
fromJsonString userJsonString =
    Decode.decodeString decoder userJsonString
