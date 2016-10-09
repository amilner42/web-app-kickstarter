module Models.Route exposing (Route(..), encoder, stringToDecoder)

import Json.Decode as Decode
import Json.Encode as Encode


{-| All of the app routes.
-}
type Route
    = HomeComponentProfile
    | HomeComponentMain
    | WelcomeComponentLogin
    | WelcomeComponentRegister


{-| Convert a Route to a string.
-}
encoder : Route -> Encode.Value
encoder route =
    let
        routeString =
            case route of
                HomeComponentProfile ->
                    "HomeComponentProfile"

                HomeComponentMain ->
                    "HomeComponentMain"

                WelcomeComponentLogin ->
                    "WelcomeComponentLogin"

                WelcomeComponentRegister ->
                    "WelcomeComponentRegister"
    in
        Encode.string routeString


{-| Decode route string to route.
-}
stringToDecoder : String -> Decode.Decoder Route
stringToDecoder encodedRouteString =
    case encodedRouteString of
        "HomeComponentProfile" ->
            Decode.succeed HomeComponentProfile

        "HomeComponentMain" ->
            Decode.succeed HomeComponentMain

        "WelcomeComponentLogin" ->
            Decode.succeed WelcomeComponentLogin

        "WelcomeComponentRegister" ->
            Decode.succeed WelcomeComponentRegister

        {- Technically string could be anything in local storage, `_` is a
           wildcard.
        -}
        _ ->
            Decode.fail <| encodedRouteString ++ " is not a valid route encoding!"
