module Models.ApiError exposing (ApiError(..), getErrorCodeFromBackendError, humanReadable)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{- COPIED from the backend, needs to stay up to date with the backend!

   export enum errorCodes {
     youAreUnauthorized = 1,
     emailAddressAlreadyRegistered,
     noAccountExistsForEmail,
     incorrectPasswordForEmail,
     phoneNumberAlreadyTaken,
     invalidMongoID,
     invalidEmail,
     invalidPassword,
     modelHasInvalidTypeStructure,     // This implies that the API was queried direclty with an incorrectly formed object.
     internalError,                    // For errors that are not handleable
     modelUnionTypeHasMultipleErrors,
     passwordDoesNotMatchConfirmPassword
   }
-}


{-| An error from the backend converted to a union.
-}
type ApiError
    = UnexpectedPayload
    | RawTimeout
    | RawNetworkError
    | YouAreUnauthorized
    | EmailAddressAlreadyRegistered
    | NoAccountExistsForEmail
    | IncorrectPasswordForEmail
    | PhoneNumberAlreadyTaken
    | InvalidMongoID
    | InvalidEmail
    | InvalidPassword
    | ModelHasInvalidTypeStructure
    | InternalError
    | ModelUnionTypeHasMultipleErrors
    | PasswordDoesNotMatchConfirmPassword


{-| An error from the backend still in Json form.
-}
type alias BackendError =
    { message : String
    , errorCode : Int
    }


{-| Gives a nice human readable representation of the `apiError`, this is
intended to be read by the user. Some of the errors below will never face the
users (if they use the webapp), but just for the sake of it I give all errors
a human readable message, in case they decide the API directly for instance.
-}
humanReadable : ApiError -> String
humanReadable apiError =
    case apiError of
        UnexpectedPayload ->
            "Unexpected payload recieved"

        RawTimeout ->
            "Ooo something went wrong, try again!"

        RawNetworkError ->
            "You seem to be disconnected from the internet!"

        YouAreUnauthorized ->
            "You are unauthorized!"

        EmailAddressAlreadyRegistered ->
            "Email already registered!"

        NoAccountExistsForEmail ->
            "That email is unregistered!"

        IncorrectPasswordForEmail ->
            "Incorrect password!"

        PhoneNumberAlreadyTaken ->
            "Phone number already registered"

        InvalidMongoID ->
            "Invalid MongoID"

        InvalidEmail ->
            "That's not even a valid email!"

        InvalidPassword ->
            "That password is not strong enough!"

        ModelHasInvalidTypeStructure ->
            "Model has invalid type structure!"

        InternalError ->
            "Internal error...try again later!"

        ModelUnionTypeHasMultipleErrors ->
            "Model union type has multiple errors"

        PasswordDoesNotMatchConfirmPassword ->
            "Passwords do not match!"


{-| Turns an errorCode integer from the backend to it's respective ApiError.
-}
fromErrorCode : Int -> ApiError
fromErrorCode errorCode =
    case errorCode of
        1 ->
            YouAreUnauthorized

        2 ->
            EmailAddressAlreadyRegistered

        3 ->
            NoAccountExistsForEmail

        4 ->
            IncorrectPasswordForEmail

        5 ->
            PhoneNumberAlreadyTaken

        6 ->
            InvalidMongoID

        7 ->
            InvalidEmail

        8 ->
            InvalidPassword

        9 ->
            ModelHasInvalidTypeStructure

        10 ->
            InternalError

        11 ->
            ModelUnionTypeHasMultipleErrors

        12 ->
            PasswordDoesNotMatchConfirmPassword

        _ ->
            InternalError


{-| Gets the error code from an error
-}
getErrorCodeFromBackendError : Http.Value -> ApiError
getErrorCodeFromBackendError response =
    case response of
        Http.Text string ->
            let
                backendErrorResult =
                    Decode.decodeString decodeBackendError string
            in
                case backendErrorResult of
                    Err error ->
                        UnexpectedPayload

                    Ok backendError ->
                        fromErrorCode backendError.errorCode

        Http.Blob blob ->
            UnexpectedPayload


{-| Decodes the API error from the backend `errorCodes` enum (top of file).
-}
decodeBackendError : Decode.Decoder BackendError
decodeBackendError =
    Decode.object2 BackendError
        ("message" := Decode.string)
        ("errorCode" := Decode.int)
