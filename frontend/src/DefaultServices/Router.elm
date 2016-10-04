module DefaultServices.Router exposing (..)

import String
import Navigation
import UrlParser

import Config
import Components.Models.Route as Route


{-| Matchers for the urls. -}
matchers : UrlParser.Parser (Route.Route -> a) a
matchers =
  UrlParser.oneOf
    [ UrlParser.format Route.HomeComponent (UrlParser.s "")
    , UrlParser.format Route.WelcomeComponent (UrlParser.s "welcome")
    ]


{-| The Parser, currently intakes routes prefixed by hash. -}
hashParser : Navigation.Location -> Result String Route.Route
hashParser location =
  location.hash
    |> String.dropLeft 1
    |> UrlParser.parse identity matchers


{-| The Navigation Parser (requires the parser) -}
parser : Navigation.Parser (Result String Route.Route)
parser =
  Navigation.makeParser hashParser


{-| Gets the url for a route. -}
toUrl: Route.Route -> String
toUrl route =
  case route of
    Route.HomeComponent ->
      Config.baseUrl ++ "#"
    Route.WelcomeComponent ->
      Config.baseUrl ++ "#welcome"
