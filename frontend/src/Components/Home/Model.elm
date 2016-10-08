module Components.Home.Model exposing (Model, encoder, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Models.Home.ShowView as ShowView


{-| Home Component Model.
-}
type alias Model =
    { showView : ShowView.ShowView
    }


{-| Home Component encoder.
-}
encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "showView", ShowView.encoder model.showView )
        ]


{-| Home Component decoder.
-}
decoder : Decode.Decoder Model
decoder =
    Decode.object1 Model
        ("showView" := Decode.string `Decode.andThen` ShowView.stringToDecoder)


{-| Home Component `toJsonString`.
-}
toJsonString : Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Home Component `fromJsonString`.
-}
fromJsonString : String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
