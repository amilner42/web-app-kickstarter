module Viewer exposing (Viewer, decoder, getCred, getEmail)

{-| The logged-in user currently viewing this page.
-}

import Api.Core as Core
import Json.Decode as Decode



-- TYPES


type Viewer
    = Viewer Core.Cred



-- INFO


getCred : Viewer -> Core.Cred
getCred (Viewer cred) =
    cred


getEmail : Viewer -> String
getEmail (Viewer cred) =
    Core.getEmail cred


decoder : Decode.Decoder (Core.Cred -> Viewer)
decoder =
    Decode.succeed Viewer
