module DefaultServices.Router exposing (..)

import String
import Navigation
import Config
import UrlParser
import Models.Route as Route


{-| Matchers for the urls.
-}
matchers : UrlParser.Parser (Route.Route -> a) a
matchers =
    UrlParser.oneOf Route.urlParsers


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


{-| Navigates to a given route.
-}
navigateTo : Route.Route -> Cmd msg
navigateTo route =
    Navigation.newUrl <| Route.toUrl <| route
