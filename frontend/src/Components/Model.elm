module Components.Model exposing (Model, cacheDecoder, cacheEncoder, toCacheJsonString, fromCacheJsonString)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Components.Home.Model as HomeModel
import Components.Welcome.Model as WelcomeModel
import Models.Route as Route
import DefaultServices.Util exposing (justValueOrNull)
import Models.User as User


{-| Base Component Model.
-}
type alias Model =
    { user : Maybe (User.User)
    , route : Route.Route
    , homeComponent : HomeModel.Model
    , welcomeComponent : WelcomeModel.Model
    }


{-| Base Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object4 Model
        ("user" := (Decode.maybe (User.cacheDecoder)))
        ("route" := Route.cacheDecoder)
        ("homeComponent" := (HomeModel.cacheDecoder))
        ("welcomeComponent" := (WelcomeModel.cacheDecoder))


{-| Base Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "user", justValueOrNull User.cacheEncoder model.user )
        , ( "route", Route.cacheEncoder model.route )
        , ( "homeComponent", HomeModel.cacheEncoder model.homeComponent )
        , ( "welcomeComponent", WelcomeModel.cacheEncoder model.welcomeComponent )
        ]


{-| Base Component `toCacheJsonString`.
-}
toCacheJsonString : Model -> String
toCacheJsonString model =
    Encode.encode 0 (cacheEncoder model)


{-| Base Component `fromCacheJsonString`.
-}
fromCacheJsonString : String -> Result String Model
fromCacheJsonString modelJsonString =
    Decode.decodeString cacheDecoder modelJsonString
