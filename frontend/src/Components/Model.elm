module Components.Model exposing (Model, cacheDecoder, cacheEncoder)

import Json.Decode as Decode exposing (field)
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
    Decode.map4 Model
        (field "user" (Decode.maybe (User.cacheDecoder)))
        (field "route" Route.cacheDecoder)
        (field "homeComponent" (HomeModel.cacheDecoder))
        (field "welcomeComponent" (WelcomeModel.cacheDecoder))


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
