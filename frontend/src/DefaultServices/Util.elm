module DefaultServices.Util exposing (justValueOrNull, resultOr)

import Json.Encode as Encode


{-| Useful for encoding, turns maybes into nulls / there actual value. -}
justValueOrNull: (a -> Encode.Value) -> Maybe a -> Encode.Value
justValueOrNull somethingToEncodeValue maybeSomething =
  case maybeSomething of
    Nothing -> Encode.null
    Just something -> somethingToEncodeValue something


{-| Result or ... -}
resultOr: Result a b -> b -> b
resultOr result default =
  case result of
    Ok valueB ->
      valueB
    Err valueA ->
      default
