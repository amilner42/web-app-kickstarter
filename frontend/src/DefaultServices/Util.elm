module DefaultServices.Util exposing (justValueOrNull)

import Json.Encode as Encode


-- Useful for encoding, turns maybes into nulls / there actual value.
justValueOrNull: (a -> Encode.Value) -> Maybe a -> Encode.Value
justValueOrNull somethingToEncodeValue maybeSomething =
  case maybeSomething of
    Nothing -> Encode.null
    Just something -> somethingToEncodeValue something
