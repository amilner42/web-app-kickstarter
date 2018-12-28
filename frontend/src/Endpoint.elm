module Endpoint exposing (Endpoint, login, request, users)

{-| This module hides creates the opaque Endpoint type and keeps all endpoints within this file so this file serves
as the single source of truth for all app API endpoints.
-}

import Http
import Url.Builder exposing (QueryParameter)
import Username exposing (Username)


-- TYPES


{-| Get a URL to the app API.
-}
type Endpoint
    = Endpoint String



-- HELPERS


{-| Http.request, except it takes an Endpoint instead of a Url.
-}
request :
    { body : Http.Body
    , expect : Http.Expect msg
    , headers : List Http.Header
    , method : String
    , timeout : Maybe Float
    , url : Endpoint
    , tracker : Maybe String
    }
    -> Cmd msg
request config =
    Http.request
        { body = config.body
        , expect = config.expect
        , headers = config.headers
        , method = config.method
        , timeout = config.timeout
        , url = unwrap config.url
        , tracker = config.tracker
        }


unwrap : Endpoint -> String
unwrap (Endpoint str) =
    str


url : List String -> List QueryParameter -> Endpoint
url paths queryParams =
    let
        -- Webpack will set this to the API base URL according to prod/dev mode
        apiBaseUrl =
            "__WEBPACK_CONSTANT_API_BASE_URL__"
    in
    Url.Builder.crossOrigin apiBaseUrl
        paths
        queryParams
        |> Endpoint



-- ENDPOINTS


login : Endpoint
login =
    url [ "users", "login" ] []


users : Endpoint
users =
    url [ "users" ] []
