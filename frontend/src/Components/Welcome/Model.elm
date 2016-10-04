module Components.Welcome.Model exposing (Model, encoder, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))

import Components.Welcome.Models.ShowView as ShowView


{-| The Welcome Component Model. -}
type alias Model =
  { email: String
  , password: String
  , confirmPassword: String
  , showView: ShowView.ShowView
  }


{-| The welcome component model encoder. -}
encoder: Model -> Encode.Value
encoder model =
  Encode.object
    [ ("email", Encode.string model.email)
    , ("password", Encode.string "") -- we don't want to save the password to localStorage
    , ("confirmPassword", Encode.string "")
    , ("showView", ShowView.encoder model.showView)
    ]


{-| The welcome component model decoder. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object4 Model
    ("email" := Decode.string)
    ("password" := Decode.string)
    ("confirmPassword" := Decode.string)
    ("showView" := Decode.string `Decode.andThen` ShowView.stringToDecoder)
