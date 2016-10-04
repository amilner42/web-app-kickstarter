module Components.Home.Models.ShowView exposing (ShowView(..), encoder, stringToDecoder)

import Json.Encode as Encode
import Json.Decode as Decode


{-| We can either be showing the profile or the main tab -}
type ShowView
  = Main
  | Profile


{-| For encoding a ShowView. -}
encoder: ShowView -> Encode.Value
encoder showView =
  let
    showViewAsString = case showView of
      Main ->
        "Main"
      Profile ->
        "Profile"
  in
    Encode.string showViewAsString


{-| For decoding a showView -}
stringToDecoder: String -> Decode.Decoder ShowView
stringToDecoder showViewAsString =
  case showViewAsString of
    "Main" ->
      Decode.succeed Main
    "Profile" ->
      Decode.succeed Profile
    _ ->
      Decode.fail (showViewAsString ++ " is not a valid showView")
