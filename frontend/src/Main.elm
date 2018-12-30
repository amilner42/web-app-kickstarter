module Main exposing (main)

{-| The entry-point to the application. This module should remain minimal.
-}

import Api.Core as Core exposing (Cred)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Page
import Page.Blank as Blank
import Page.Home as Home
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Register as Register
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)
import Viewer exposing (Viewer)


-- MODEL


type alias Model =
    { mobileNavbarOpen : Bool
    , pageModel : PageModel
    }


type PageModel
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Register Register.Model


init : Maybe Viewer -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeViewer url navKey =
    changeRouteTo
        (Route.fromUrl url)
        { mobileNavbarOpen = False
        , pageModel = Redirect (Session.fromViewer navKey maybeViewer)
        }



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
                        (Session.viewer (toSession model))
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

        Login login ->
            viewPage GotLoginMsg (Login.view login)

        Register register ->
            viewPage GotRegisterMsg (Register.view register)



-- UPDATE


type Msg
    = Ignored
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg Home.Msg
    | GotLoginMsg Login.Msg
    | GotRegisterMsg Register.Msg
    | GotSession Session
    | ToggledMobileNavbar


toSession : Model -> Session
toSession { pageModel } =
    case pageModel of
        Redirect session ->
            session

        NotFound session ->
            session

        Home home ->
            Home.toSession home

        Login login ->
            Login.toSession login

        Register register ->
            Register.toSession register


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model

        closeMobileNavbar =
            { model | mobileNavbarOpen = False }
    in
    case maybeRoute of
        Nothing ->
            ( { mobileNavbarOpen = False, pageModel = NotFound session }
            , Cmd.none
            )

        Just Route.Root ->
            ( closeMobileNavbar
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        Just Route.Logout ->
            ( closeMobileNavbar
            , Core.logout
            )

        Just Route.Home ->
            Home.init session
                |> updatePageModel Home GotHomeMsg model

        Just Route.Login ->
            Login.init session
                |> updatePageModel Login GotLoginMsg model

        Just Route.Register ->
            Register.init session
                |> updatePageModel Register GotRegisterMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
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
                            , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
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

        ( GotLoginMsg pageMsg, Login login ) ->
            Login.update pageMsg login
                |> updatePageModel Login GotLoginMsg model

        ( GotRegisterMsg pageMsg, Register register ) ->
            Register.update pageMsg register
                |> updatePageModel Register GotRegisterMsg model

        ( GotHomeMsg pageMsg, Home home ) ->
            Home.update pageMsg home
                |> updatePageModel Home GotHomeMsg model

        ( GotSession session, Redirect _ ) ->
            ( { model | pageModel = Redirect session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
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
    case model.pageModel of
        NotFound _ ->
            Sub.none

        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))

        Home home ->
            Sub.map GotHomeMsg (Home.subscriptions home)

        Login login ->
            Sub.map GotLoginMsg (Login.subscriptions login)

        Register register ->
            Sub.map GotRegisterMsg (Register.subscriptions register)



-- MAIN


main : Program Decode.Value Model Msg
main =
    Core.application Viewer.decoder
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
