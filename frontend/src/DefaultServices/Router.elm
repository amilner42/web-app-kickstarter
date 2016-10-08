module DefaultServices.Router exposing (..)

import String
import Navigation
import UrlParser exposing (s, (</>))
import Config
import Models.Route as Route


{-| Matchers for the urls.
-}
matchers : UrlParser.Parser (Route.Route -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.format Route.HomeComponent (s "")
        , UrlParser.format Route.WelcomeComponentRegister (s "welcome" </> s "register")
        , UrlParser.format Route.WelcomeComponentLogin (s "welcome" </> s "login")
        ]


{-| The Parser, currently intakes routes prefixed by hash.
-}
hashParser : Navigation.Location -> Result String Route.Route
hashParser location =
    location.hash
        |> String.dropLeft 1
        |> UrlParser.parse identity matchers


{-| The Navigation Parser (requires the parser)
-}
parser : Navigation.Parser (Result String Route.Route)
parser =
    Navigation.makeParser hashParser


{-| Gets the url for a route.
-}
toUrl : Route.Route -> String
toUrl route =
    case route of
        Route.HomeComponent ->
            Config.baseUrl ++ "#"

        Route.WelcomeComponentLogin ->
            Config.baseUrl ++ "#welcome/login"

        Route.WelcomeComponentRegister ->
            Config.baseUrl ++ "#welcome/register"


{-| Navigates to a given route.
-}
navigateTo : Route.Route -> Cmd msg
navigateTo route =
    Navigation.newUrl <| toUrl <| route
