module Components.Home.Model exposing (Model, encoder, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { data1 : String
    , data2 : String
    }


{-| Home Component encoder.
-}
encoder : Model -> Encode.Value
encoder model =
    Encode.object
        [ ( "data1", Encode.string model.data1 )
        , ( "data2", Encode.string model.data2 )
        ]


{-| Home Component decoder.
-}
decoder : Decode.Decoder Model
decoder =
    Decode.object2 Model
        ("data1" := Decode.string)
        ("data2" := Decode.string)
