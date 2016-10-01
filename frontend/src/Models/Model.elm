module Models.Model exposing (decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import Models.User as User
import Types
import DefaultServices.Util exposing ( justValueOrNull )


-- The decoder for the model.
decoder: Decode.Decoder Types.Model
decoder =
  Decode.object1 Types.Model
    ("user" := (Decode.maybe(User.decoder)))

-- The encoder for the model.
encoder: Types.Model -> Encode.Value
encoder model =
  Encode.object
    [
      ("user", justValueOrNull User.encoder model.user)
    ]

-- Turns a model into a JSON string.
toJsonString: Types.Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)

-- Turns a JSON string into a model.
fromJsonString: String -> Result String Types.Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
