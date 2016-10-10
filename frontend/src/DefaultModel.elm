module DefaultModel exposing (defaultModel)

import Models.Route as Route
import Components.Model as Model
import Components.Home.Init as HomeInit
import Components.Welcome.Init as WelcomeInit


{-| The default model (`Components/Model.elm`) for the application.
-}
defaultModel : Model.Model
defaultModel =
    { user = Nothing
    , route = Route.WelcomeComponentLogin
    , homeComponent = HomeInit.init
    , welcomeComponent = WelcomeInit.init
    }
