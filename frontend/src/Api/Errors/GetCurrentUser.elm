module Api.Errors.GetCurrentUser exposing (Error, decoder)

import Json.Decode as Decode


type Error
    = NotLoggedIn


decoder : Decode.Decoder Error
decoder =
    Decode.succeed NotLoggedIn
