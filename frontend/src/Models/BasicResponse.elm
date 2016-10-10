module Models.BasicResponse exposing (BasicResponse, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| To avoid worrying about handling empty responses, we use a basic object
with a message always as opposed to an empty http body.
-}
type alias BasicResponse =
    { message : String }


{-| The BasicResponse `decoder`.
-}
decoder : Decode.Decoder BasicResponse
decoder =
    Decode.object1 BasicResponse
        ("message" := Decode.string)
