module Page.Home exposing (Model, Msg, init, update, view)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Api.Core exposing (Cred)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Session exposing (Session)
import Viewer



-- MODEL


type alias Model =
    { session : Session }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )



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
                    [ div
                        [ class "column is-half" ]
                        [ h1
                            [ class "title has-text-centered" ]
                            [ text "Home Page" ]
                        , div
                            [ class "content has-text-centered" ]
                            [ text <|
                                case Session.viewer model.session of
                                    Nothing ->
                                        "Guest"

                                    Just viewer ->
                                        "Logged In: " ++ Viewer.getEmail viewer
                            ]
                        ]
                    ]
                ]
            ]
    }



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
