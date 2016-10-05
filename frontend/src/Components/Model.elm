module Components.Model exposing (Model, decoder, encoder, toJsonString, fromJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode

import Components.Home.Model as HomeModel
import Components.Welcome.Model as WelcomeModel
import Models.Route as Route
import DefaultServices.Util exposing ( justValueOrNull )
import Models.User as User


{-| The model for the base component. Sub-component models are placed under
`<name>Component`, -}
type alias Model =
  { user: Maybe(User.User)
  , route: Route.Route
  , homeComponent: HomeModel.Model
  , welcomeComponent: WelcomeModel.Model
  }


{-| The decoder for the base component model. -}
decoder: Decode.Decoder Model
decoder =
  Decode.object4 Model
    ("user" := (Decode.maybe(User.decoder)))
    ("route" := Decode.string `Decode.andThen` Route.stringToDecoder)
    ("homeComponent" := (HomeModel.decoder))
    ("welcomeComponent" := (WelcomeModel.decoder))


{-| The encoder for the base component model. -}
encoder: Model -> Encode.Value
encoder model = Encode.object
    [ ("user", justValueOrNull User.encoder model.user)
    , ("route", Route.encoder model.route)
    , ("homeComponent", HomeModel.encoder model.homeComponent)
    , ("welcomeComponent", WelcomeModel.encoder model.welcomeComponent)
    ]


{-| Turns the base component model into a JSON string. -}
toJsonString: Model -> String
toJsonString model =
    Encode.encode 0 (encoder model)


{-| Turns a JSON string into the base component model. -}
fromJsonString: String -> Result String Model
fromJsonString modelJsonString =
    Decode.decodeString decoder modelJsonString
