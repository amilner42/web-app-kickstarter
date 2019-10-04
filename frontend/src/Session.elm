module Session exposing (Session(..), cred, fromViewer, navKey, viewer)

{-| A session contains a `Nav.Key` and a `Viewer.Viewer` if you are logged-in.
-}

import Api.Core as Core exposing (Cred)
import Browser.Navigation as Nav
import Viewer exposing (Viewer)


type Session
    = LoggedIn Nav.Key Viewer
    | Guest Nav.Key


viewer : Session -> Maybe Viewer
viewer session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


cred : Session -> Maybe Cred
cred session =
    case session of
        LoggedIn _ val ->
            Just (Viewer.getCred val)

        Guest _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key


fromViewer : Nav.Key -> Maybe Viewer -> Session
fromViewer key maybeViewer =
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
