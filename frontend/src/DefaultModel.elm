module DefaultModel exposing (defaultModel, defaultShared)

import Models.Route as Route
import Components.Model as Model
import Components.Home.Init as HomeInit
import Components.Welcome.Init as WelcomeInit


{-| The default model (`Components/Model.elm`) for the application.
-}
defaultModel : Model.Model
defaultModel =
    { shared = defaultShared
    , homeComponent = HomeInit.init
    , welcomeComponent = WelcomeInit.init
    }


{-| The defult shared model.
-}
defaultShared : Model.Shared
defaultShared =
    { user = Nothing
    , route = Route.WelcomeComponentLogin
    }
