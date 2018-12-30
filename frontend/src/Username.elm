module Username exposing (Username, decoder, encode, toHtml, toString, urlParser)

{-| A simple wrapper over the username of a user.
-}

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url.Parser


-- TYPES


type Username
    = Username String



-- SERIALIZATION


decoder : Decoder Username
decoder =
    Decode.map Username Decode.string


encode : Username -> Encode.Value
encode (Username username) =
    Encode.string username



-- HELPERS


toString : Username -> String
toString (Username username) =
    username


urlParser : Url.Parser.Parser (Username -> a) a
urlParser =
    Url.Parser.custom "USERNAME" (\str -> Just (Username str))


toHtml : Username -> Html msg
toHtml (Username username) =
    Html.text username
