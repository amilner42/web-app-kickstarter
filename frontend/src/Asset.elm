module Asset exposing (Image, githubLogo, src)

{-| Assets, such as images, videos, and audio.

Don't expose asset URLs directly; this module should be in charge of all of them. Better to have
a single source of truth.

-}

import Html exposing (..)
import Html.Attributes as Attr


type Image
    = Image String



-- IMAGES


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
