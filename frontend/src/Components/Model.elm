module Components.Model exposing (Model, decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import Models.User as User
import DefaultServices.Util exposing ( justValueOrNull )
import Router


{-| The model for the base component. -}
type alias Model =
  { user: Maybe(User.User)
  , route: Router.Route }


{-| The decoder for the base component model. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object2 Model
    ("user" := (Decode.maybe(User.decoder)))
    ("route" := Decode.string `Decode.andThen` routeDecoder)


{-| The encoder for the base component model. -}
encoder: Model -> Encode.Value
encoder model = Encode.object
    [ ("user", justValueOrNull User.encoder model.user)
    , ("route", routeEncoder model.route)
    ]


{-| Turns the base component model into a JSON string. -}
toJsonString: Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Turns a JSON string into the base component model. -}
fromJsonString: String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString


{-| Private function for converting a Route to a string for encoding -}
routeEncoder: Router.Route -> Encode.Value
routeEncoder route =
  let
    routeString =
      case route of
        Router.HomeComponent ->
          "HomeComponent"
        Router.WelcomeComponent ->
          "WelcomeComponent"
  in
    Encode.string routeString


{-| Private function for decoding route string to route -}
routeDecoder: String -> Decode.Decoder Router.Route
routeDecoder encodedRouteString =
  case encodedRouteString of
    "HomeComponent" ->
      Decode.succeed Router.HomeComponent
    "WelcomeComponent" ->
      Decode.succeed Router.WelcomeComponent
    _ -> -- Technically string could be anything in local storage, _ is a wildcard
      Decode.fail <| encodedRouteString ++ " is not a valid route encoding!"
