module Main exposing (main)

{-| The entry-point to the application. This module should remain minimal.
-}

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Page
import Page.AboutUs as AboutUs
import Page.Blank as Blank
import Page.Home as Home
import Page.NotFound as NotFound
import Route exposing (Route)
import Url exposing (Url)



-- MODEL


type alias Model =
    { mobileNavbarOpen : Bool
    , pageModel : PageModel
    }


toNavKey : Model -> Nav.Key
toNavKey model =
    case model.pageModel of
        Redirect navKey ->
            navKey

        NotFound navKey ->
            navKey

        AboutUs navKey ->
            navKey

        Home { navKey } ->
            navKey


type PageModel
    = Redirect Nav.Key
    | NotFound Nav.Key
    | AboutUs Nav.Key
    | Home Home.Model


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { mobileNavbarOpen = False, pageModel = Home <| Home.initModel navKey }
    , Cmd.none
    )



-- VIEW


view : Model -> Document Msg
view model =
    let
        viewPage toMsg pageView =
            let
                { title, body } =
                    Page.view
                        { mobileNavbarOpen = model.mobileNavbarOpen
                        , toggleMobileNavbar = ToggledMobileNavbar
                        }
                        pageView
                        toMsg
            in
            { title = title
            , body = body
            }
    in
    case model.pageModel of
        Redirect _ ->
            viewPage (\_ -> Ignored) Blank.view

        NotFound _ ->
            viewPage (\_ -> Ignored) NotFound.view

        Home home ->
            viewPage GotHomeMsg (Home.view home)

        AboutUs _ ->
            viewPage (\_ -> Ignored) AboutUs.view



-- UPDATE


type Msg
    = Ignored
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | ToggledMobileNavbar
    | GotHomeMsg Home.Msg


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        navKey =
            toNavKey model

        closeMobileNavbar =
            { model | mobileNavbarOpen = False }
    in
    case maybeRoute of
        Nothing ->
            ( { mobileNavbarOpen = False, pageModel = NotFound navKey }
            , Cmd.none
            )

        Just Route.Root ->
            ( closeMobileNavbar
            , Route.replaceUrl navKey Route.Home
            )

        Just Route.AboutUs ->
            ( { mobileNavbarOpen = False, pageModel = AboutUs navKey }
            , Cmd.none
            )

        Just Route.Home ->
            Home.init navKey
                |> updatePageModel Home GotHomeMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        navKey =
            toNavKey model
    in
    case ( msg, model.pageModel ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl navKey (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( ToggledMobileNavbar, _ ) ->
            ( { model | mobileNavbarOpen = not model.mobileNavbarOpen }
            , Cmd.none
            )

        ( GotHomeMsg pageMsg, Home home ) ->
            Home.update pageMsg home
                |> updatePageModel Home GotHomeMsg model

        -- Ignore message for wrong page.
        ( GotHomeMsg _, _ ) ->
            ( model, Cmd.none )


{-| For updating the model given a page model and page msg.

This update will close the mobileNavbar.

-}
updatePageModel :
    (pageModel -> PageModel)
    -> (pageMsg -> Msg)
    -> Model
    -> ( pageModel, Cmd pageMsg )
    -> ( Model, Cmd Msg )
updatePageModel toPageModel toMsg model ( pageModel, pageCmd ) =
    ( { model
        | mobileNavbarOpen = False
        , pageModel = toPageModel pageModel
      }
    , Cmd.map toMsg pageCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
