module Components.Home.Init exposing (init)

import Components.Home.Model exposing (Model)
import Models.Home.ShowView exposing (ShowView(..))


{-| Home Component Init. -}
init: Model
init =
  { showView = Main
  }
