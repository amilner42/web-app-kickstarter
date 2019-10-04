module Viewer exposing (Viewer, cred, decoder)

{-| The logged-in user currently viewing this page.
-}

import Api.Core as Core
import Json.Decode as Decode



-- TYPES


type Viewer
    = Viewer Core.Cred



-- INFO


cred : Viewer -> Core.Cred
cred (Viewer val) =
    val


decoder : Decode.Decoder (Core.Cred -> Viewer)
decoder =
    Decode.succeed Viewer
