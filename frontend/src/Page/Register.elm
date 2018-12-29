module Page.Register exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Api.Api as Api
import Api.Core as Core exposing (Cred)
import Browser.Navigation as Nav
import Bulma
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode
import Route exposing (Route)
import Session exposing (Session)
import Viewer exposing (Viewer)


-- MODEL


type alias Model =
    { session : Session
    , form : Form
    , formError : Core.FormError Api.RegisterError ClientError
    }


type alias Form =
    { email : String
    , username : String
    , password : String
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , formError = Core.NoError
      , form =
            { email = ""
            , username = ""
            , password = ""
            }
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Register"
    , content =
        section
            [ class "section is-medium" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "columns is-centered" ]
                    [ div [ class "column is-half" ]
                        [ h1 [ class "title has-text-centered" ] [ text "Sign Up" ]
                        , p
                            [ class "title is-size-7 has-text-danger has-text-centered" ]
                            (Core.getFormErrors
                                model.formError
                                (always [])
                                (always [])
                                |> List.map text
                            )
                        , Bulma.formControl
                            (\hasError ->
                                input
                                    [ classList [ ( "input", True ), ( "is-danger", hasError ) ]
                                    , placeholder "Username"
                                    , onInput EnteredUsername
                                    , value model.form.username
                                    ]
                                    []
                            )
                            (case model.formError of
                                Core.NoError ->
                                    []

                                Core.ClientError clientError ->
                                    clientError.username

                                Core.HttpError (Core.BadStatus _ httpError) ->
                                    httpError.username

                                Core.HttpError _ ->
                                    []
                            )
                        , Bulma.formControl
                            (\hasError ->
                                input
                                    [ classList [ ( "input", True ), ( "is-danger", hasError ) ]
                                    , placeholder "Email"
                                    , onInput EnteredEmail
                                    , value model.form.email
                                    ]
                                    []
                            )
                            (case model.formError of
                                Core.NoError ->
                                    []

                                Core.ClientError clientError ->
                                    clientError.email

                                Core.HttpError (Core.BadStatus _ httpError) ->
                                    httpError.email

                                Core.HttpError _ ->
                                    []
                            )
                        , Bulma.formControl
                            (\hasError ->
                                input
                                    [ classList [ ( "input", True ), ( "is-danger", hasError ) ]
                                    , placeholder "Password"
                                    , type_ "password"
                                    , onInput EnteredPassword
                                    , value model.form.password
                                    ]
                                    []
                            )
                            (case model.formError of
                                Core.NoError ->
                                    []

                                Core.ClientError clientError ->
                                    clientError.password

                                Core.HttpError (Core.BadStatus _ httpError) ->
                                    httpError.password

                                Core.HttpError _ ->
                                    []
                            )
                        , button
                            [ class "button button is-success is-fullwidth is-large"
                            , onClick SubmittedForm
                            ]
                            [ text "Sign up" ]
                        ]
                    ]
                ]
            ]
    }



-- UPDATE


type Msg
    = SubmittedForm
    | EnteredEmail String
    | EnteredUsername String
    | EnteredPassword String
    | CompletedRegister (Result (Core.HttpError Api.RegisterError) Viewer)
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | formError = Core.NoError }
                    , register validForm CompletedRegister
                    )

                Err clientError ->
                    ( { model | formError = Core.ClientError clientError }
                    , Cmd.none
                    )

        EnteredUsername username ->
            updateForm (\form -> { form | username = username }) model

        EnteredEmail email ->
            updateForm (\form -> { form | email = email }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        CompletedRegister (Err httpRegistrationError) ->
            ( { model | formError = Core.HttpError httpRegistrationError }
            , Cmd.none
            )

        CompletedRegister (Ok viewer) ->
            ( model
            , Viewer.store viewer
            )

        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )


{-| Helper function for `update`. Updates the form and returns Cmd.none.
Useful for recording form fields!
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session



-- FORM


{-| Marks that we've trimmed the form's fields, so we don't accidentally send
it to the server without having trimmed it!
-}
type TrimmedForm
    = Trimmed Form


{-| Trim the form and validate its fields. If there are errors, report them.
-}
validate : Form -> Result ClientError TrimmedForm
validate form =
    let
        trimmedForm =
            trimFields form

        registrationError =
            { username =
                if String.isEmpty form.username then
                    [ "username can't be blank." ]
                else
                    []
            , email =
                if String.isEmpty form.email then
                    [ "email can't be blank." ]
                else
                    []
            , password =
                if String.isEmpty form.password then
                    [ "password can't be blank." ]
                else if String.length form.password < Viewer.minPasswordChars then
                    [ "password must be at least " ++ String.fromInt Viewer.minPasswordChars ++ " characters long." ]
                else
                    []
            }
    in
    if Api.hasRegisterError registrationError then
        Err registrationError
    else
        Ok trimmedForm


{-| Trim fields prior to submission.
-}
trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { username = String.trim form.username
        , email = String.trim form.email
        , password = String.trim form.password
        }



-- HTTP


type alias ClientError =
    Api.RegisterError


hasClientError : ClientError -> Bool
hasClientError =
    Api.hasRegisterError


register : TrimmedForm -> (Result.Result (Core.HttpError Api.RegisterError) Viewer.Viewer -> msg) -> Cmd.Cmd msg
register (Trimmed form) =
    Api.register { username = form.username, email = form.email, password = form.password }
