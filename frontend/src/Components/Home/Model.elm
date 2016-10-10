module Components.Home.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { dataOne : String
    , dataTwo : String
    }


{-| Home Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "dataOne", Encode.string model.dataOne )
        , ( "dataTwo", Encode.string model.dataTwo )
        ]


{-| Home Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object2 Model
        ("dataOne" := Decode.string)
        ("dataTwo" := Decode.string)
