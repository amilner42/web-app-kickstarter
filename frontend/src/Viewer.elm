module Viewer exposing (Viewer, cred, decoder, store, username)

{-| The logged-in user currently viewing this page. It stores the username along with
`Api.Core.Cred` so it's impossible to have a `Viewer.Viewer` if you aren't logged in.
-}

import Api.Core as Core exposing (Cred)
import Json.Decode as Decode exposing (Decoder)
import Username exposing (Username)


-- TYPES


type Viewer
    = Viewer Cred



-- INFO


cred : Viewer -> Cred
cred (Viewer val) =
    val


username : Viewer -> Username
username (Viewer val) =
    Core.username val



-- SERIALIZATION


decoder : Decoder (Cred -> Viewer)
decoder =
    Decode.succeed Viewer


store : Viewer -> Cmd msg
store (Viewer credVal) =
    Core.storeCredWith credVal
