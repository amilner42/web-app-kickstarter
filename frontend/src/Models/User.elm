module Models.User
    exposing
        ( User
        , encoder
        , decoder
        , cacheDecoder
        , cacheEncoder
        , toJsonString
        , fromJsonString
        , AuthUser
        , authEncoder
        , toAuthJsonString
        )

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import DefaultServices.Util exposing (justValueOrNull)


{-| The User type.
-}
type alias User =
    { email : String
    , password : Maybe (String)
    }


{-| The User `decoder`.
-}
decoder : Decode.Decoder User
decoder =
    Decode.object2 User
        ("email" := Decode.string)
        (Decode.maybe ("password" := Decode.string))


{-| The User `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder User
cacheDecoder =
    decoder


{-| The user `encoder`.
-}
encoder : User -> Encode.Value
encoder user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "password", justValueOrNull Encode.string user.password )
        ]


{-| The User `cacheEncoder`.
-}
cacheEncoder : User -> Encode.Value
cacheEncoder user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "password", Encode.null )
        ]


{-| Turns a user into a JSON string.
-}
toJsonString : User -> String
toJsonString userRecord =
    Encode.encode 0 (encoder userRecord)


{-| The User `toCacheJsonString`
-}
toCacheJsonString : User -> String
toCacheJsonString userRecord =
    Encode.encode 0 (cacheEncoder userRecord)


{-| The User `fromJsonString`.
-}
fromJsonString : String -> Result String User
fromJsonString userJsonString =
    Decode.decodeString decoder userJsonString


{-| The User `fromCacheJsonString`.
-}
fromCacheJsonString : String -> Result String User
fromCacheJsonString userJsonString =
    Decode.decodeString cacheDecoder userJsonString


{-| For authentication we only send an email and password.
-}
type alias AuthUser =
    { email : String
    , password : String
    }


{-| Encodes the user for the initial authentication request (login/register).
-}
authEncoder : AuthUser -> Encode.Value
authEncoder authUser =
    Encode.object
        [ ( "email", Encode.string authUser.email )
        , ( "password", Encode.string authUser.password )
        ]


{-| Converts an authUser to a string.
-}
toAuthJsonString : AuthUser -> String
toAuthJsonString authUser =
    Encode.encode 0 <| authEncoder <| authUser
