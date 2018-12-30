module Page.Blank exposing (view)

{-| A blank page.
-}

import Html exposing (Html)


view : { title : String, content : Html msg }
view =
    { title = ""
    , content = Html.text ""
    }
