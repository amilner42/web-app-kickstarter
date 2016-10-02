module Components.Model exposing (Model, decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import Models.User as User
import DefaultServices.Util exposing ( justValueOrNull )


{-| The model for the base component. -}
type alias Model = { user: Maybe(User.User) }


{-| The decoder for the base component model. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object1 Model
    ("user" := (Decode.maybe(User.decoder)))


{-| The encoder for the base component model. -}
encoder: Model -> Encode.Value
encoder model =
  Encode.object [ ("user", justValueOrNull User.encoder model.user) ]


{-| Turns the base component model into a JSON string. -}
toJsonString: Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Turns a JSON string into the base component model. -}
fromJsonString: String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
