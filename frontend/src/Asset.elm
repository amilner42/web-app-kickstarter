module Asset exposing (Image, elmLogo, githubLogo, src)

{-| Assets, such as images, videos, and audio. (We only have images for now.)

We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!

-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attr


type Image
    = Image String



-- IMAGES


elmLogo : Image
elmLogo =
    image "elm-logo.png"


githubLogo : Image
githubLogo =
    image "github-logo.png"


image : String -> Image
image filename =
    Image ("/assets/images/" ++ filename)



-- USING IMAGES


src : Image -> Attribute msg
src (Image url) =
    Attr.src url
