module Api.Core exposing (Cred, HttpError(..), delete, expectJson, expectJsonWithCred, get, getEmail, post, put)

{-| This module provides all http helpers.

1.  Provides the private `Cred` opaque type which you can only get from an HttpRequest.
2.  Provides HTTP-request helpers which use `Endpoint` and `HttpError`
3.  Provides a modified `Http.Error` type and respective helpers.

-}

import Api.Endpoint as Endpoint exposing (Endpoint)
import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (required)
import Json.Encode as Encode
import Url exposing (Url)


{-| Keep this private so the only way to create this is on an HttpRequest.
-}
type Cred
    = Cred String


getEmail : Cred -> String
getEmail (Cred email) =
    email


decodeCredAnd : Decode.Decoder (Cred -> a) -> Decode.Decoder a
decodeCredAnd decoder =
    let
        decodeCred =
            Decode.field "email" Decode.string |> Decode.map Cred
    in
    Decode.map2 (\fromEmail email -> fromEmail email)
        decoder
        decodeCred


{-| All possible HTTP errors, similar to `Http.Error` but `Http.BadStatus` will include the response body.
-}
type HttpError errorBody
    = BadUrl String
    | Timeout
    | NetworkError
    | BadSuccessBody String -- String is the decode failure explanatory string
    | BadErrorBody String -- String is the decode failure explanatory string
    | BadStatus Int errorBody


{-| Similar to `Http.expectJson` but this uses our custom `HttpError`.
-}
expectJson :
    (Result (HttpError errorBody) successBody -> msg)
    -> Decode.Decoder successBody
    -> Decode.Decoder errorBody
    -> Http.Expect msg
expectJson toMsg successDecoder errorDecoder =
    Http.expectStringResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (BadUrl url)

                Http.Timeout_ ->
                    Err Timeout

                Http.NetworkError_ ->
                    Err NetworkError

                Http.BadStatus_ metadata body ->
                    case Decode.decodeString errorDecoder body of
                        Ok value ->
                            Err <| BadStatus metadata.statusCode value

                        Err err ->
                            Err <| BadErrorBody <| Decode.errorToString err

                Http.GoodStatus_ metadata body ->
                    case Decode.decodeString successDecoder body of
                        Ok value ->
                            Ok value

                        Err err ->
                            Err <| BadSuccessBody <| Decode.errorToString err


{-| Similar to `expectJson` above but expects an email in the response. This is required because `Email` is opaque.
-}
expectJsonWithCred :
    (Result (HttpError errorBody) successBody -> msg)
    -> Decode.Decoder (Cred -> successBody)
    -> Decode.Decoder errorBody
    -> Http.Expect msg
expectJsonWithCred toMsg successDecoder errorDecoder =
    Http.expectStringResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (BadUrl url)

                Http.Timeout_ ->
                    Err Timeout

                Http.NetworkError_ ->
                    Err NetworkError

                Http.BadStatus_ metadata body ->
                    case Decode.decodeString errorDecoder body of
                        Ok value ->
                            Err <| BadStatus metadata.statusCode value

                        Err err ->
                            Err <| BadErrorBody <| Decode.errorToString err

                Http.GoodStatus_ metadata body ->
                    case Decode.decodeString (decodeCredAnd successDecoder) body of
                        Ok value ->
                            Ok value

                        Err err ->
                            Err <| BadSuccessBody <| Decode.errorToString err



-- HTTP METHODS


get : Endpoint -> Maybe Float -> Maybe String -> Http.Expect a -> Cmd.Cmd a
get endpoint timeout tracker expect =
    Endpoint.request
        { method = "GET"
        , endpoint = endpoint
        , expect = expect
        , headers = []
        , body = Http.emptyBody
        , timeout = timeout
        , tracker = tracker
        }


put : Endpoint -> Maybe Float -> Maybe String -> Http.Body -> Http.Expect a -> Cmd.Cmd a
put endpoint timeout tracker body expect =
    Endpoint.request
        { method = "PUT"
        , endpoint = endpoint
        , expect = expect
        , headers = []
        , body = body
        , timeout = timeout
        , tracker = tracker
        }


post : Endpoint -> Maybe Float -> Maybe String -> Http.Body -> Http.Expect a -> Cmd.Cmd a
post endpoint timeout tracker body expect =
    Endpoint.request
        { method = "POST"
        , endpoint = endpoint
        , expect = expect
        , headers = []
        , body = body
        , timeout = timeout
        , tracker = tracker
        }


delete : Endpoint -> Maybe Float -> Maybe String -> Http.Body -> Http.Expect a -> Cmd.Cmd a
delete endpoint timeout tracker body expect =
    Endpoint.request
        { method = "DELETE"
        , endpoint = endpoint
        , expect = expect
        , headers = []
        , body = body
        , timeout = timeout
        , tracker = tracker
        }
