module Page.Home exposing (Model, Msg, init, initModel, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Api.Api as Api
import Api.Core as Core
import Api.Errors.Form as FormError
import Browser.Navigation as Nav
import Bulma
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MODEL


type alias Model =
    { navKey : Nav.Key
    , email : String
    , emailFormError : FormError.Error
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( initModel navKey, Cmd.none )


initModel : Nav.Key -> Model
initModel navKey =
    { navKey = navKey, email = "", emailFormError = FormError.empty }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content =
        section
            [ class "section is-medium" ]
            [ div
                [ class "container" ]
                [ div
                    [ class "columns is-centered" ]
                    [ div [ class "column is-half" ]
                        [ p
                            [ class "title is-size-7 has-text-danger has-text-centered" ]
                            (List.map text <| model.emailFormError.entire)
                        , Bulma.formControl
                            (\hasError ->
                                input
                                    [ classList [ ( "input", True ), ( "is-danger", hasError ) ]
                                    , placeholder "Email"
                                    , onInput OnEmailInput
                                    , value model.email
                                    ]
                                    []
                            )
                            (FormError.getErrorForField "email" model.emailFormError)
                        , button
                            [ class "button is-success is-fullwidth is-large"
                            , onClick AddEmail
                            ]
                            [ text "Subscribe For Updates" ]
                        ]
                    ]
                ]
            ]
    }



-- UPDATE


type Msg
    = OnEmailInput String
    | AddEmail
    | CompletedAddEmail (Result (Core.HttpError FormError.Error) ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnEmailInput email ->
            ( { model | email = email }, Cmd.none )

        AddEmail ->
            ( model
            , Api.addEmail model.email CompletedAddEmail
            )

        CompletedAddEmail (Err httpError) ->
            ( { model | emailFormError = FormError.fromHttpError httpError }, Cmd.none )

        CompletedAddEmail (Ok _) ->
            ( { model | email = "", emailFormError = FormError.empty }, Cmd.none )
