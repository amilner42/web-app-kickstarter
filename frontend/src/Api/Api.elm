module Api.Api exposing (getCurrentUser, login, logout, register)

{-| This module contains the `Cmd.Cmd`s to access API routes.
-}

import Api.Core as Core
import Api.Endpoint as Endpoint
import Api.Errors.Form as FormError
import Api.Errors.GetCurrentUser as GetCurrentUserError
import Api.Errors.Unknown as UnknownError
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode
import Viewer


standardTimeout =
    Just (seconds 10)



-- GET CURRENT LOGGED IN USER


getCurrentUser : (Result.Result (Core.HttpError GetCurrentUserError.Error) Viewer.Viewer -> msg) -> Cmd.Cmd msg
getCurrentUser handleResult =
    Core.get
        Endpoint.me
        standardTimeout
        Nothing
        (Core.expectJsonWithCred handleResult Viewer.decoder GetCurrentUserError.decoder)



-- LOGIN


type alias LoginBody =
    { email : String, password : String }


login : LoginBody -> (Result.Result (Core.HttpError FormError.Error) Viewer.Viewer -> msg) -> Cmd.Cmd msg
login { email, password } handleResult =
    let
        encodedLoginData =
            Encode.object
                [ ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]

        body =
            Http.jsonBody encodedLoginData
    in
    Core.post
        Endpoint.login
        (Just (seconds 10))
        Nothing
        body
        (Core.expectJsonWithCred handleResult Viewer.decoder FormError.decoder)



-- REGISTER


type alias RegisterBody =
    { email : String, password : String }


register : RegisterBody -> (Result.Result (Core.HttpError FormError.Error) Viewer.Viewer -> msg) -> Cmd.Cmd msg
register { email, password } handleResult =
    let
        encodedUserRegisterData =
            Encode.object
                [ ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]

        body =
            Http.jsonBody encodedUserRegisterData
    in
    Core.post
        Endpoint.users
        (Just (seconds 10))
        Nothing
        body
        (Core.expectJsonWithCred handleResult Viewer.decoder FormError.decoder)



-- LOGOUT


logout : (Result.Result (Core.HttpError UnknownError.Error) () -> msg) -> Cmd.Cmd msg
logout handleResult =
    Core.post
        Endpoint.logout
        (Just (seconds 10))
        Nothing
        Http.emptyBody
        (Core.expectJson handleResult (Decode.succeed ()) UnknownError.decoder)



-- INTERNAL HELPERS


{-| Convert seconds to milliseconds.
-}
seconds : Float -> Float
seconds =
    (*) 1000
