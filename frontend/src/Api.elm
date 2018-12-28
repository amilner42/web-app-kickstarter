port module Api exposing (Cred, addServerError, application, decodeErrors, delete, get, login, logout, post, put, register, storeCredWith, username, viewerChanges)

{-| This module is responsible for communicating to the app API.
-}

import Browser
import Browser.Navigation as Nav
import Endpoint exposing (Endpoint)
import Http exposing (Body, Expect)
import Json.Decode as Decode exposing (Decoder, Value, decodeString, field, string)
import Json.Decode.Pipeline as Pipeline exposing (optional, required)
import Json.Encode as Encode
import Url exposing (Url)
import Username exposing (Username)


-- CRED


{-| The authentication credentials for the Viewer (that is, the currently logged-in user.)
This includes:

  - The cred's Username
  - The cred's authentication token
    By design, there is no way to access the token directly as a String.
    It can be encoded for persistence, and it can be added to a header
    to a HttpBuilder for a request, but that's it.
    This token should never be rendered to the end user, and with this API, it
    can't be!

-}
type Cred
    = Cred Username String


username : Cred -> Username
username (Cred val _) =
    val


credHeader : Cred -> Http.Header
credHeader (Cred _ str) =
    Http.header "authorization" ("Token " ++ str)


{-| It's important that this is never exposed!
We expose `login` and `application` instead, so we can be certain that if anyone
ever has access to a `Cred` value, it came from either the login API endpoint
or was passed in via flags.
-}
credDecoder : Decoder Cred
credDecoder =
    Decode.succeed Cred
        |> required "username" Username.decoder
        |> required "token" Decode.string



-- PERSISTENCE


decode : Decoder (Cred -> viewer) -> Value -> Result Decode.Error viewer
decode decoder value =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue Decode.string value
        |> Result.andThen (\str -> Decode.decodeString (Decode.field "user" (decoderFromCred decoder)) str)


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



-- SERIALIZATION
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


storageDecoder : Decoder (Cred -> viewer) -> Decoder viewer
storageDecoder viewerDecoder =
    Decode.field "user" (decoderFromCred viewerDecoder)



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



-- HTTP API


{-| Log a user in.
-}
login : Http.Body -> (Result.Result Http.Error a -> msg) -> Decode.Decoder (Cred -> a) -> Cmd.Cmd msg
login body handleResult decoder =
    post Endpoint.login Nothing body <|
        Http.expectJson handleResult (Decode.field "user" <| decoderFromCred decoder)


{-| Register a user.
-}
register : Http.Body -> (Result.Result Http.Error a -> msg) -> Decode.Decoder (Cred -> a) -> Cmd.Cmd msg
register body handleResult decoder =
    post Endpoint.users Nothing body <|
        Http.expectJson handleResult (Decode.field "user" <| decoderFromCred decoder)


{-| Helper method that will decode the credentials for you so you don't have to do that every time you
create a decoder.
-}
decoderFromCred : Decoder (Cred -> a) -> Decoder a
decoderFromCred decoder =
    Decode.map2 (\fromCred cred -> fromCred cred)
        decoder
        credDecoder



-- ERRORS


addServerError : List String -> List String
addServerError list =
    "Server error" :: list


{-| Many API endpoints include an "errors" field in their BadStatus responses.

TODO

-}
decodeErrors : Http.Error -> List String
decodeErrors error =
    case error of
        Http.BadStatus intError ->
            [ "Http Bad Status: " ++ String.fromInt intError ]

        err ->
            [ "Server error" ]
