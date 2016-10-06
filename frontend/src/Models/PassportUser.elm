module Models.PassportUser exposing (PassportUser, encoder, toJsonString)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| Passport uses the `username` field as opposed to email. -}
type alias PassportUser =
  { username: String
  , password: String
  }


{-| Encodes a passport user. -}
encoder: PassportUser -> Encode.Value
encoder passportUser =
  Encode.object
    [ ("username", Encode.string passportUser.username)
    , ("password", Encode.string passportUser.password)
    ]


{-| Converts a passport user to a string. -}
toJsonString: PassportUser -> String
toJsonString passportUser =
  Encode.encode 0 <| encoder <| passportUser
