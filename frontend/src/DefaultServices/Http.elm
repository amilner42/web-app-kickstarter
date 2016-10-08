module DefaultServices.Http exposing (get, post)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import String
import Task
import Models.ApiError as ApiError


{- NOTE This module is designed to be used with a backend which serves errors
   back, refer to Models.ApiError to see the format of expected errors.
-}


{-| Private, just to put headers in one place.
-}
headers =
    { contentType =
        { json = ( "Content-Type", "application/json" )
        }
    }


{-| Private, for turning a raw error into an ApiError, then having the
onApiError handle it.
-}
onRawError : (ApiError.ApiError -> msg) -> Http.RawError -> msg
onRawError onApiError rawError =
    let
        apiError =
            case rawError of
                Http.RawTimeout ->
                    ApiError.RawTimeout

                Http.RawNetworkError ->
                    ApiError.RawNetworkError
    in
        onApiError apiError


{-| Private, for turning a raw success into a message, keeping in mind that a
raw success does not mean a 2xx, it just means that there was a response.
-}
onRawSuccess : (ApiError.ApiError -> msg) -> (decodedValue -> msg) -> Decode.Decoder decodedValue -> Http.Response -> msg
onRawSuccess onApiError onApiSuccess decoder response =
    if 200 <= response.status && response.status < 300 then
        case response.value of
            Http.Text string ->
                case (Decode.decodeString decoder string) of
                    Err error ->
                        onApiError ApiError.UnexpectedPayload

                    Ok decodedResponse ->
                        onApiSuccess decodedResponse

            Http.Blob blob ->
                onApiError ApiError.UnexpectedPayload
    else
        let
            apiError =
                ApiError.getErrorCodeFromBackendError response.value
        in
            onApiError apiError


{-| A HTTP get request.
-}
get : String -> Decode.Decoder a -> (ApiError.ApiError -> b) -> (a -> b) -> Cmd b
get url decoder onApiError onApiSuccess =
    let
        request =
            { verb = "GET"
            , headers = []
            , url = url
            , body = Http.empty
            }

        sendRequest =
            Http.send Http.defaultSettings request

        handleRawError =
            onRawError onApiError

        handleRawSuccess =
            onRawSuccess onApiError onApiSuccess decoder
    in
        Task.perform handleRawError handleRawSuccess sendRequest


{-| A HTTP post request, adds a JSON header.
-}
post : String -> Decode.Decoder a -> String -> (ApiError.ApiError -> b) -> (a -> b) -> Cmd b
post url decoder body onApiError onApiSuccess =
    let
        request =
            { verb = "POST"
            , headers = [ headers.contentType.json ]
            , url = url
            , body = Http.string body
            }

        sendRequest =
            Http.send Http.defaultSettings request

        handleRawError =
            onRawError onApiError

        handleRawSuccess =
            onRawSuccess onApiError onApiSuccess decoder
    in
        Task.perform handleRawError handleRawSuccess sendRequest
