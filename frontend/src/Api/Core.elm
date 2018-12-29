port module Api.Core exposing (Cred, FormError(..), HttpError(..), application, delete, expectJson, expectJsonWithCred, get, logout, post, put, storeCredWith, username, viewerChanges)

{-| This module provides a few core API-related responsibilities:

  - Providing the opaque Cred type
  - Providing HTTP helpers which use Endpoint, all http requests should be through these helpers
  - Handling the main `Application` which uses Cred so must be in here to prevent circular deps

This module does NOT contain the actual routes to the API though, refer to the `Api.Api` module for those routes.

-}

import Api.Endpoint as Endpoint exposing (Endpoint)
import Browser
import Browser.Navigation as Nav
import Http exposing (Body, Expect)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode as Encode
import Url exposing (Url)
import Username exposing (Username)


-- CRED


{-| The authentication credentials for the Viewer (that is, the currently logged-in user.), this includes:

  - The cred's Username
  - The cred's authentication token

By design, there is no way to access the token directly as a String. It can be encoded for persistence, and it can be
added to a header to a HttpBuilder for a request, but that's it. This token should never be rendered to the end user,
and with this API, it can't be!

-}
type Cred
    = Cred Username String


username : Cred -> Username
username (Cred val _) =
    val


credHeader : Cred -> Http.Header
credHeader (Cred _ str) =
    Http.header "authorization" ("Token " ++ str)


{-| Decodes credentials.

NOTE: Do not expose this method

-}
credDecoder : Decoder Cred
credDecoder =
    Decode.succeed Cred
        |> required "username" Username.decoder
        |> required "token" Decode.string


{-| Helper method to prevent repeatedely decoding credentials in all decoders.

NOTE: Do not expose this method.

-}
decodeCredAnd : Decoder (Cred -> a) -> Decoder a
decodeCredAnd decoder =
    Decode.map2 (\fromCred cred -> fromCred cred)
        decoder
        (Decode.field "user" credDecoder)



-- PERSISTENCE


storageDecoder : Decoder (Cred -> viewer) -> Decoder viewer
storageDecoder viewerDecoder =
    decodeCredAnd viewerDecoder


port onStoreChange : (Value -> msg) -> Sub msg


viewerChanges : (Maybe viewer -> msg) -> Decoder (Cred -> viewer) -> Sub msg
viewerChanges toMsg decoder =
    onStoreChange (\value -> toMsg (decodeFromChange decoder value))


decodeFromChange : Decoder (Cred -> viewer) -> Value -> Maybe viewer
decodeFromChange viewerDecoder val =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue (storageDecoder viewerDecoder) val
        |> Result.toMaybe


storeCredWith : Cred -> Cmd msg
storeCredWith (Cred uname token) =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "username", Username.encode uname )
                        , ( "token", Encode.string token )
                        ]
                  )
                ]
    in
    storeCache (Just json)


logout : Cmd msg
logout =
    storeCache Nothing


port storeCache : Maybe Value -> Cmd msg



-- APPLICATION


application :
    Decoder (Cred -> viewer)
    ->
        { init : Maybe viewer -> Url -> Nav.Key -> ( model, Cmd msg )
        , onUrlChange : Url -> msg
        , onUrlRequest : Browser.UrlRequest -> msg
        , subscriptions : model -> Sub msg
        , update : msg -> model -> ( model, Cmd msg )
        , view : model -> Browser.Document msg
        }
    -> Program Value model msg
application viewerDecoder config =
    let
        init flags url navKey =
            let
                maybeViewer =
                    Decode.decodeValue Decode.string flags
                        |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
                        |> Result.toMaybe
            in
            config.init maybeViewer url navKey
    in
    Browser.application
        { init = init
        , onUrlChange = config.onUrlChange
        , onUrlRequest = config.onUrlRequest
        , subscriptions = config.subscriptions
        , update = config.update
        , view = config.view
        }



-- HTTP HELPERS


{-| All possible HTTP errors, similar to `Http.Error` but `Http.BasStatus` will include the response body making
it much more practical for displaying errors from the server.

NOTE: Realistically you would never display the BadSuccessBody/BadErrorBody decode error string to the user but
I am still keeping it because it'll be useful during development. In production you can just ignore that string
and display the error you were going to display regardless.

-}
type HttpError errorBody
    = BadUrl String
    | Timeout
    | NetworkError
    | BadSuccessBody String -- String is the decode failure explanatory string
    | BadErrorBody String -- String is the decode failure explanatory string
    | BadStatus Int errorBody


{-| A form can have errors or get errors prior to the http request in the client or after from the server.
-}
type FormError serverError clientError
    = NoError
    | HttpError (HttpError serverError)
    | ClientError clientError


{-| Similar to `Http.expectJson` but this uses our custom `HttpError` which has a body on the server error response
instead of just a status code.
-}
expectJson : (Result (HttpError errorBody) successBody -> msg) -> Decode.Decoder successBody -> Decode.Decoder errorBody -> Expect msg
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


{-| Similar to `expectJson` but needed when expecting credentials in the response.
-}
expectJsonWithCred : (Result (HttpError errorBody) successBody -> msg) -> Decode.Decoder (Cred -> successBody) -> Decode.Decoder errorBody -> Expect msg
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


get : Endpoint -> Maybe Cred -> Http.Expect a -> Cmd.Cmd a
get url maybeCred expect =
    Endpoint.request
        { method = "GET"
        , url = url
        , expect = expect
        , headers =
            case maybeCred of
                Just cred ->
                    [ credHeader cred ]

                Nothing ->
                    []
        , body = Http.emptyBody

        -- TODO nothing?
        , timeout = Nothing
        , tracker = Nothing
        }


put : Endpoint -> Cred -> Body -> Http.Expect a -> Cmd.Cmd a
put url cred body expect =
    Endpoint.request
        { method = "PUT"
        , url = url
        , expect = expect
        , headers = [ credHeader cred ]
        , body = body

        -- TODO nothing?
        , timeout = Nothing
        , tracker = Nothing
        }


post : Endpoint -> Maybe Cred -> Body -> Http.Expect a -> Cmd.Cmd a
post url maybeCred body expect =
    Endpoint.request
        { method = "POST"
        , url = url
        , expect = expect
        , headers =
            case maybeCred of
                Just cred ->
                    [ credHeader cred ]

                Nothing ->
                    []
        , body = body

        -- TODO nothing?
        , timeout = Nothing
        , tracker = Nothing
        }


delete : Endpoint -> Cred -> Body -> Http.Expect a -> Cmd.Cmd a
delete url cred body expect =
    Endpoint.request
        { method = "DELETE"
        , url = url
        , expect = expect
        , headers = [ credHeader cred ]
        , body = body

        -- TODO nothing?
        , timeout = Nothing
        , tracker = Nothing
        }
