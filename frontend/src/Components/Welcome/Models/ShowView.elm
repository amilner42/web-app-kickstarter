module Components.Welcome.Models.ShowView exposing (ShowView, encoder, stringToDecoder)

import Json.Encode as Encode
import Json.Decode as Decode


{-| We can either be showing the login or the register views -}
type ShowView
  = Login
  | Register


{-| For encoding a ShowView. -}
encoder: ShowView -> Encode.Value
encoder showView =
  let
    showViewAsString = case showView of
      Login ->
        "Login"
      Register ->
        "Register"
  in
    Encode.string showViewAsString


{-| For decoding a ShowView. -}
stringToDecoder: String -> Decode.Decoder ShowView
stringToDecoder showViewAsString =
  case showViewAsString of
    "Login" ->
      Decode.succeed Login
    "Register" ->
      Decode.succeed Register
    _ ->
      Decode.fail (showViewAsString ++ " is not a valid ShowView")
