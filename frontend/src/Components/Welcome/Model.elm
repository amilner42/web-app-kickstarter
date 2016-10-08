module Components.Welcome.Model exposing (Model, encoder, decoder)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))

import DefaultServices.Util as Util
import Models.ApiError as ApiError


{-| Welcome Component Model. -}
type alias Model =
  { email: String
  , password: String
  , confirmPassword: String
  , apiError: Maybe(ApiError.ApiError)
  }


{-| Welcome Component encoder. -}
encoder: Model -> Encode.Value
encoder model =
  Encode.object
    [ ("email", Encode.string model.email)
    , ("password", Encode.string "") -- we don't want to save the password to localStorage
    , ("confirmPassword", Encode.string "")
    , ("errorCode", Encode.null) -- we don't want errors to persist in localStorage
    ]


{-| Welcome Component decoder. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object4 Model
    ("email" := Decode.string)
    ("password" := Decode.string)
    ("confirmPassword" := Decode.string)
    ("errorCode" := Decode.null Nothing) -- we always save null to localStorage
