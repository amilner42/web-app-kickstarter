module DefaultServices.Http exposing (get, post)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import String
import Task

import Models.ApiError as ApiError

{- NOTE This module is designed to be used with a backend which serves errors
back, refer to Models.ApiError to see the format of expected errors. -}


{-| Private, just to put headers in one place. -}
headers =
  { contentType =
    { json = ( "Content-Type", "application/json" )
    }
  }


{-| A HTTP get request. -}
get: String -> Decode.Decoder a -> (Http.Error -> b) -> (a -> b) -> Cmd b
get url decoder onError onSuccess =
  Task.perform onError onSuccess (Http.get decoder url)


{-| A HTTP post request, adds a JSON header. -}
post: String -> Decode.Decoder a -> String -> (ApiError.ApiError -> b) -> (a -> b) -> Cmd b
post url decoder body onApiError onApiSuccess =
  let
    request =
      { verb = "POST"
      , headers = [ headers.contentType.json ]
      , url = url
      , body = Http.string body
      }

    sendRequest = Http.send Http.defaultSettings request

    {- Deals with tcp errors ('raw' errors). -}
    onRawError rawError =
      let
        apiError =
          case rawError of
            Http.RawTimeout ->
              ApiError.RawTimeout
            Http.RawNetworkError ->
              ApiError.RawNetworkError
      in
        onApiError apiError

    {- Deals with the tcp succeeding, but the request still possibly recieving
    a 400 (elm seperates tcp failing and http failing). -}
    onRawSuccess response =
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
  in
    Task.perform onRawError onRawSuccess sendRequest
