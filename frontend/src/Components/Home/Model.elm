module Components.Home.Model exposing (Model, encoder, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))

import Models.Home.ShowView as ShowView


{-| The Home Component Model -}
type alias Model =
  { showView: ShowView.ShowView
  }


{-| The encoder for the home component model. -}
encoder: Model -> Encode.Value
encoder model = Encode.object
  [ ("showView", ShowView.encoder model.showView)
  ]


{-| The decoder for the home component model. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object1 Model
    ("showView" := Decode.string `Decode.andThen` ShowView.stringToDecoder)


{-| Turns the home component model into a JSON string. -}
toJsonString: Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Turns a JSON string into the home component model. -}
fromJsonString: String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
