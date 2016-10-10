module Models.Route exposing (Route(..), cacheEncoder, cacheDecoder, urlParsers, toUrl)

import Json.Decode as Decode
import Json.Encode as Encode
import Config
import UrlParser exposing (s, (</>))


{-| All of the app routes.
-}
type Route
    = HomeComponentProfile
    | HomeComponentMain
    | WelcomeComponentLogin
    | WelcomeComponentRegister


{-| The Route `cacheEncoder`.
-}
cacheEncoder : Route -> Encode.Value
cacheEncoder route =
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


{-| The Route `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Route
cacheDecoder =
    let
        fromStringDecoder encodedRouteString =
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
    in
        Decode.string `Decode.andThen` fromStringDecoder


{-| The `urlParser`s needed by the `Router` to parse the route from the url.
-}
urlParsers =
    [ UrlParser.format HomeComponentMain (s "")
    , UrlParser.format HomeComponentProfile (s "profile")
    , UrlParser.format WelcomeComponentRegister (s "welcome" </> s "register")
    , UrlParser.format WelcomeComponentLogin (s "welcome" </> s "login")
    ]


{-| Converts a route to a url.
-}
toUrl : Route -> String
toUrl route =
    case route of
        HomeComponentMain ->
            Config.baseUrl ++ "#"

        HomeComponentProfile ->
            Config.baseUrl ++ "#profile"

        WelcomeComponentLogin ->
            Config.baseUrl ++ "#welcome/login"

        WelcomeComponentRegister ->
            Config.baseUrl ++ "#welcome/register"
