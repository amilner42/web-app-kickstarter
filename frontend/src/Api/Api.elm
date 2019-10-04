module Api.Api exposing (addEmail)

{-| This module contains the `Cmd.Cmd`s to access API routes.
-}

import Api.Core as Core
import Api.Endpoint as Endpoint
import Api.Errors.Form as FormError
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode


standardTimeout =
    Just (seconds 10)


addEmail : String -> (Result.Result (Core.HttpError FormError.Error) () -> msg) -> Cmd.Cmd msg
addEmail email handleResult =
    Core.post
        Endpoint.emails
        standardTimeout
        Nothing
        (Http.jsonBody <| Encode.object [ ( "email", Encode.string email ) ])
        (Core.expectJson handleResult (Decode.succeed ()) FormError.decoder)



-- INTERNAL HELPERS


{-| Convert seconds to milliseconds.
-}
seconds : Float -> Float
seconds =
    (*) 1000
