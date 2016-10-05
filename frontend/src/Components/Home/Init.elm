module Components.Home.Init exposing (init)

import Components.Home.Model exposing (Model)
import Models.Home.ShowView exposing (ShowView(..))


{-| The initial home component model. -}
init: Model
init =
  { showView = Main
  }
