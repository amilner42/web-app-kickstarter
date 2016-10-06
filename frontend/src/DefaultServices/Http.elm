module DefaultServices.Http exposing (get, post)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import String
import Task


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
post: String -> Decode.Decoder a -> String -> (Http.Error -> b) -> (a -> b) -> Cmd b
post url decoder body onError onSuccess =
  let
    request =
      { verb = "POST"
      , headers = [ headers.contentType.json ]
      , url = url
      , body = Http.string body
      }

    sendRequest = Http.send Http.defaultSettings request
  in
    Task.perform onError onSuccess (Http.fromJson decoder sendRequest)
