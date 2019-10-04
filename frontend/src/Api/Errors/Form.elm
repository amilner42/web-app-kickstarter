module Api.Errors.Form exposing (Error, decoder, empty, fieldErrorsFromList, fromEntireErrors, fromFieldErrors, fromHttpError, getErrorForField, hasError)

import Api.Core as Core
import Dict
import Json.Decode as Decode


{-| A form can have errors on the entire form or field-specific errors.
-}
type alias Error =
    { entire : List String
    , fields : Dict.Dict String (List String)
    }


empty : Error
empty =
    Error [] <| Dict.empty


hasError : Error -> Bool
hasError =
    (/=) empty


getErrorForField : String -> Error -> List String
getErrorForField field error =
    error.fields
        |> Dict.get field
        |> Maybe.withDefault []


fromFieldErrors : Dict.Dict String (List String) -> Error
fromFieldErrors fieldErrors =
    { empty | fields = fieldErrors }


fieldErrorsFromList : List ( String, Maybe (List String) ) -> Dict.Dict String (List String)
fieldErrorsFromList maybeFieldErrors =
    maybeFieldErrors
        |> List.filterMap
            (\( fieldName, maybeErrorsForField ) ->
                maybeErrorsForField
                    |> Maybe.map (\errorsForField -> ( fieldName, errorsForField ))
            )
        |> Dict.fromList


fromEntireErrors : List String -> Error
fromEntireErrors entireFormErrors =
    { empty | entire = entireFormErrors }


fromHttpError : Core.HttpError Error -> Error
fromHttpError httpError =
    case httpError of
        Core.BadUrl string ->
            fromEntireErrors [ "Internal Error" ]

        Core.Timeout ->
            fromEntireErrors [ "Request Timed Out" ]

        Core.NetworkError ->
            fromEntireErrors [ "Internet Connection Error" ]

        Core.BadSuccessBody string ->
            fromEntireErrors [ "Internal Error" ]

        Core.BadErrorBody string ->
            fromEntireErrors [ "Internal Error" ]

        Core.BadStatus int error ->
            error


decoder : Decode.Decoder Error
decoder =
    Decode.map2 Error
        (Decode.field "entire" (Decode.list Decode.string))
        (Decode.field "fields" (Decode.dict (Decode.list Decode.string)))
