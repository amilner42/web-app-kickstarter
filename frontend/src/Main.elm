module Main exposing (main)

{-| The entry-point to the application. This module should remain minimal.
-}

import Api.Api as Api
import Api.Core as Core exposing (Cred)
import Api.Errors.GetCurrentUser as GetCurrentUserError
import Api.Errors.Unknown as UnknownError
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


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { mobileNavbarOpen = False, pageModel = Redirect <| Session.Guest navKey }
    , Api.getCurrentUser (CompletedGetUser <| Route.fromUrl url)
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
    | ToggledMobileNavbar
    | CompletedGetUser (Maybe Route) (Result (Core.HttpError GetCurrentUserError.Error) Viewer.Viewer)
    | CompletedLogout (Result (Core.HttpError UnknownError.Error) ())
    | GotHomeMsg Home.Msg
    | GotLoginMsg Login.Msg
    | GotRegisterMsg Register.Msg


toSession : Model -> Session
toSession { pageModel } =
    case pageModel of
        Redirect session ->
            session

        NotFound session ->
            session

        Home homeModel ->
            homeModel.session

        Login loginModel ->
            loginModel.session

        Register registerModel ->
            registerModel.session


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
            , Api.logout CompletedLogout
            )

        Just Route.Home ->
            Home.init session
                |> updatePageModel Home GotHomeMsg model

        Just Route.Login ->
            -- Don't go to login if they are already signed in.
            case Session.viewer <| toSession model of
                Nothing ->
                    Login.init session
                        |> updatePageModel Login GotLoginMsg model

                Just _ ->
                    ( closeMobileNavbar
                    , Route.replaceUrl (Session.navKey session) Route.Home
                    )

        Just Route.Register ->
            -- Don't go to register if they are already signed in.
            case Session.viewer <| toSession model of
                Nothing ->
                    Register.init session
                        |> updatePageModel Register GotRegisterMsg model

                Just _ ->
                    ( closeMobileNavbar
                    , Route.replaceUrl (Session.navKey session) Route.Home
                    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        navKey =
            Session.navKey <| toSession model
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

        ( CompletedGetUser maybeRoute (Ok viewer), _ ) ->
            let
                newSession =
                    Session.fromViewer navKey (Just viewer)
            in
            ( { model | pageModel = Redirect newSession }
            , Route.replaceUrl navKey <| Maybe.withDefault Route.Home maybeRoute
            )

        ( CompletedGetUser maybeRoute (Err err), _ ) ->
            ( model
            , Route.replaceUrl navKey <| Maybe.withDefault Route.Home maybeRoute
            )

        ( CompletedLogout (Ok _), _ ) ->
            ( { model | pageModel = Redirect <| Session.Guest navKey }
            , Route.replaceUrl navKey Route.Home
            )

        -- TODO handle logout failure
        ( CompletedLogout (Err _), _ ) ->
            ( model, Cmd.none )

        ( GotLoginMsg pageMsg, Login login ) ->
            Login.update pageMsg login
                |> updatePageModel Login GotLoginMsg model

        -- Ignore message for wrong page.
        ( GotLoginMsg _, _ ) ->
            ( model, Cmd.none )

        ( GotRegisterMsg pageMsg, Register register ) ->
            Register.update pageMsg register
                |> updatePageModel Register GotRegisterMsg model

        -- Ignore message for wrong page.
        ( GotRegisterMsg _, _ ) ->
            ( model, Cmd.none )

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
