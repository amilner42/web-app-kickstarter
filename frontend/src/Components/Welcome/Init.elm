module Components.Welcome.Init exposing (init)

import Components.Welcome.Model exposing (Model)


-- The initial home component model.
init: Model
init =
  { email = ""
  , password = ""
  , confirmPassword = ""
  }
