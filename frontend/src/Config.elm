module Config exposing (baseUrl, apiBaseUrl)

{-| The app base url. Needs to be changed for production.
-}


baseUrl : String
baseUrl =
    "http://localhost:3000/"


{-| The app api url.
-}
apiBaseUrl : String
apiBaseUrl =
    baseUrl ++ "api/"
