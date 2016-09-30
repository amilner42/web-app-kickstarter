module DefaultServices.Http exposing (get, post)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import String
import Task

import Types


-- A HTTP get request.
get: String -> Decode.Decoder a -> (Http.Error -> Types.Msg) -> (a -> Types.Msg) -> Cmd Types.Msg
get url decoder onError onSuccess  =  Task.perform onError onSuccess (Http.get decoder url)

-- A HTTP post request.
post: String -> Decode.Decoder a -> String -> (Http.Error -> Types.Msg) -> (a -> Types.Msg) -> Cmd Types.Msg
post url decoder body onError onSuccess = Task.perform onError onSuccess (Http.post decoder url (Http.string body))
