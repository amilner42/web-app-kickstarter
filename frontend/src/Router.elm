module Router exposing (..)

import String
import Navigation
import UrlParser


{-| All of the app routes. -}
type Route
  = HomeComponent
  | WelcomeComponent


{-| Matchers for the urls. -}
matchers : UrlParser.Parser (Route -> a) a
matchers =
  UrlParser.oneOf
    [ UrlParser.format HomeComponent (UrlParser.s "")
    , UrlParser.format WelcomeComponent (UrlParser.s "welcome")
    ]


{-| The Parser, currently intakes routes prefixed by hash. -}
hashParser : Navigation.Location -> Result String Route
hashParser location =
  location.hash
    |> String.dropLeft 1
    |> UrlParser.parse identity matchers


{-| The Navigation Parser (requires the parser) -}
parser : Navigation.Parser (Result String Route)
parser =
  Navigation.makeParser hashParser
