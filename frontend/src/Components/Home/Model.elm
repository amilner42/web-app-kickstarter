module Components.Home.Model exposing (Model, encoder, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { dataOne : String
    , dataTwo : String
    }


{-| Home Component encoder.
-}
encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "dataOne", Encode.string model.dataOne )
        , ( "dataTwo", Encode.string model.dataTwo )
        ]


{-| Home Component decoder.
-}
decoder : Decode.Decoder Model
decoder =
    Decode.object2 Model
        ("dataOne" := Decode.string)
        ("dataTwo" := Decode.string)
