module Api.Errors.Unknown exposing (Error, decoder)

import Json.Decode as Decode


type Error
    = Unknown


decoder : Decode.Decoder Error
decoder =
    Decode.succeed Unknown
