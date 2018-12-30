module Api.Api exposing (LoginError, RegisterError, hasLoginError, hasRegisterError, login, noLoginError, noRegisterError, register)

{-| This module strictly contains the routes to the API and their respective errors.

NOTE: Extra things that are unrelated to the API requests and handling their errors should most
likely be put in `Api.Core`.

-}

import Api.Core as Core
import Api.Endpoint as Endpoint
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode
import Viewer


-- LOGIN


type alias LoginBody =
    { email : String, password : String }


type alias LoginError =
    { emailOrPassword : List String }


noLoginError : LoginError
noLoginError =
    LoginError []


hasLoginError : LoginError -> Bool
hasLoginError =
    (/=) noLoginError


{-| Log a user in.
-}
login : LoginBody -> (Result.Result (Core.HttpError LoginError) Viewer.Viewer -> msg) -> Cmd.Cmd msg
login { email, password } handleResult =
    let
        user =
            Encode.object
                [ ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]

        body =
            Encode.object [ ( "user", user ) ]
                |> Http.jsonBody
    in
    Core.post
        Endpoint.login
        Nothing
        body
        (Core.expectJsonWithCred handleResult Viewer.decoder decodeLoginError)



-- REGISTER


type alias RegisterBody =
    { username : String, email : String, password : String }


type alias RegisterError =
    { username : List String
    , email : List String
    , password : List String
    }


noRegisterError : RegisterError
noRegisterError =
    RegisterError [] [] []


hasRegisterError : RegisterError -> Bool
hasRegisterError =
    (/=) noRegisterError


{-| Register a user.
-}
register : RegisterBody -> (Result.Result (Core.HttpError RegisterError) Viewer.Viewer -> msg) -> Cmd.Cmd msg
register { username, email, password } handleResult =
    let
        user =
            Encode.object
                [ ( "username", Encode.string username )
                , ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]

        body =
            Encode.object [ ( "user", user ) ]
                |> Http.jsonBody
    in
    Core.post
        Endpoint.users
        Nothing
        body
        (Core.expectJsonWithCred handleResult Viewer.decoder decodeRegisterError)



-- INTERNAL HELPERS


{-| Decode a single string error into a list with 1 string error.
-}
decodeFieldError : Decode.Decoder (List String)
decodeFieldError =
    Decode.string
        |> Decode.map (\err -> [ err ])


{-| Decode a list of string errors.
-}
decodeFieldErrors : Decode.Decoder (List String)
decodeFieldErrors =
    Decode.list Decode.string


decodeLoginError : Decode.Decoder LoginError
decodeLoginError =
    Decode.succeed LoginError
        |> optional "email or password" decodeFieldError []
        |> Decode.field "errors"


decodeRegisterError : Decode.Decoder RegisterError
decodeRegisterError =
    Decode.succeed RegisterError
        |> optional "username" decodeFieldError []
        |> optional "email" decodeFieldError []
        |> optional "password" decodeFieldError []
        |> Decode.field "errors"
