module Page.Register exposing (Model, Msg, init, update, view)

{-| The registration page.
-}

import Api.Api as Api
import Api.Core as Core exposing (Cred)
import Api.Errors.Form as FormError
import Bulma
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route)
import Session exposing (Session)
import Viewer exposing (Viewer)



-- MODEL


type alias Model =
    { session : Session
    , form : Form
    , formError : FormError.Error
    }


type alias Form =
    { email : String
    , password : String
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , form =
            { email = ""
            , password = ""
            }
      , formError = FormError.empty
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
                            (List.map text <| model.formError.entire)
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
                            (FormError.getErrorForField "email" model.formError)
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
                            (FormError.getErrorForField "password" model.formError)
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
    | EnteredPassword String
    | CompletedRegister (Result (Core.HttpError FormError.Error) Viewer)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | formError = FormError.empty }
                    , register validForm CompletedRegister
                    )

                Err formError ->
                    ( { model | formError = formError }
                    , Cmd.none
                    )

        EnteredEmail email ->
            updateForm (\form -> { form | email = email }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        CompletedRegister (Err httpRegistrationError) ->
            ( { model | formError = FormError.fromHttpError httpRegistrationError }
            , Cmd.none
            )

        CompletedRegister (Ok viewer) ->
            let
                navKey =
                    Session.navKey model.session
            in
            ( { model | session = Session.fromViewer navKey (Just viewer) }
            , Route.replaceUrl navKey Route.Home
            )


{-| Helper function for `update`. Updates the form and returns Cmd.none.
-}
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )



-- FORM


{-| Marks that we've trimmed the form's fields, so we don't accidentally send it to the server
without having trimmed it.
-}
type TrimmedForm
    = Trimmed Form


{-| Passwords must be at least this many characters long.
-}
minPasswordChars : Int
minPasswordChars =
    6


{-| Trim the form and validate its fields. If there are errors, report them.
-}
validate : Form -> Result FormError.Error TrimmedForm
validate form =
    let
        trimmedForm =
            trimFields form

        registrationError =
            (FormError.fromFieldErrors << FormError.fieldErrorsFromList)
                [ ( "email"
                  , if String.isEmpty form.email then
                        Just [ "email can't be blank." ]

                    else
                        Nothing
                  )
                , ( "password"
                  , if String.isEmpty form.password then
                        Just [ "password can't be blank." ]

                    else if String.length form.password < minPasswordChars then
                        Just [ "password must be at least " ++ String.fromInt minPasswordChars ++ " characters long." ]

                    else
                        Nothing
                  )
                ]
    in
    if FormError.hasError registrationError then
        Err registrationError

    else
        Ok trimmedForm


{-| Trim fields prior to submission.
-}
trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { email = String.trim form.email
        , password = String.trim form.password
        }



-- HTTP


register : TrimmedForm -> (Result.Result (Core.HttpError FormError.Error) Viewer.Viewer -> msg) -> Cmd.Cmd msg
register (Trimmed form) =
    Api.register { email = form.email, password = form.password }
