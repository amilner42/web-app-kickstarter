module Components.Model exposing (Model, decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import Components.Home.Model as HomeModel
import Components.Welcome.Model as WelcomeModel
import Models.Route as Route
import DefaultServices.Util exposing ( justValueOrNull )
import Models.User as User


{-| Base Component Model. -}
type alias Model =
  { user: Maybe(User.User)
  , route: Route.Route
  , homeComponent: HomeModel.Model
  , welcomeComponent: WelcomeModel.Model
  }


{-| Base Component decoder. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object4 Model
    ("user" := (Decode.maybe(User.decoder)))
    ("route" := Decode.string `Decode.andThen` Route.stringToDecoder)
    ("homeComponent" := (HomeModel.decoder))
    ("welcomeComponent" := (WelcomeModel.decoder))


{-| Base Component encoder. -}
encoder: Model -> Encode.Value
encoder model = Encode.object
    [ ("user", justValueOrNull User.encoder model.user)
    , ("route", Route.encoder model.route)
    , ("homeComponent", HomeModel.encoder model.homeComponent)
    , ("welcomeComponent", WelcomeModel.encoder model.welcomeComponent)
    ]


{-| Base Component `toJsonString`. -}
toJsonString: Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Base Component `fromJsonString`. -}
fromJsonString: String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
