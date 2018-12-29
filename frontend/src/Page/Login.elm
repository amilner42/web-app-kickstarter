module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| The login page.
-}

import Api.Api as Api
import Api.Core as Core exposing (Cred)
import Browser.Navigation as Nav
import Bulma
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode as Encode
import Route exposing (Route)
import Session exposing (Session)
import Viewer exposing (Viewer)


-- MODEL


type alias Model =
    { session : Session
    , form : Form
    , formError : Core.FormError Api.LoginError ClientError
    }


type alias Form =
    { email : String
    , password : String
    }


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , formError = Core.NoError
      , form =
            { email = ""
            , password = ""
            }
      }
    , Cmd.none
    )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login"
    , content =
        section
            [ class "section is-medium" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "columns is-centered" ]
                    [ div [ class "column is-half" ]
                        [ h1 [ class "title has-text-centered" ] [ text "Log In" ]
                        , p
                            [ class "title is-size-7 has-text-danger has-text-centered" ]
                            (Core.getFormErrors
                                model.formError
                                (\serverError -> serverError.emailOrPassword)
                                (always [])
                                |> List.map text
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
                                    []

                                Core.HttpError _ ->
                                    []
                            )
                        , Bulma.formControl
                            (\hasError ->
                                input
                                    [ classList [ ( "input", True ), ( "is-danger", hasError ) ]
                                    , placeholder "password"
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
                                    []

                                Core.HttpError _ ->
                                    []
                            )
                        , button
                            [ class "button is-success is-fullwidth is-large"
                            , onClick SubmittedForm
                            ]
                            [ text "Log in" ]
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
    | CompletedLogin (Result (Core.HttpError Api.LoginError) Viewer)
    | GotSession Session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmittedForm ->
            case validate model.form of
                Ok validForm ->
                    ( { model | formError = Core.NoError }
                    , login validForm CompletedLogin
                    )

                Err loginError ->
                    ( { model | formError = Core.ClientError loginError }
                    , Cmd.none
                    )

        EnteredEmail email ->
            updateForm (\form -> { form | email = email }) model

        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model

        CompletedLogin (Err httpLoginError) ->
            ( { model | formError = Core.HttpError <| httpLoginError }
            , Cmd.none
            )

        CompletedLogin (Ok viewer) ->
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

        loginError =
            { email =
                if String.isEmpty form.email then
                    [ "email can't be blank" ]
                else
                    []
            , password =
                if String.isEmpty form.password then
                    [ "password can't be blank" ]
                else
                    []
            }
    in
    if hasClientError loginError then
        Err loginError
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


emptyClientError : ClientError
emptyClientError =
    ClientError [] []


hasClientError : ClientError -> Bool
hasClientError =
    (/=) emptyClientError


type alias ClientError =
    { email : List String
    , password : List String
    }


login : TrimmedForm -> (Result.Result (Core.HttpError Api.LoginError) Viewer.Viewer -> msg) -> Cmd.Cmd msg
login (Trimmed form) =
    Api.login { email = form.email, password = form.password }



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
