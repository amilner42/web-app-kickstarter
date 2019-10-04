module Page exposing (view)

{-| This allows you to insert a page, providing the navbar outline common to all pages.
-}

import Api.Core exposing (Cred)
import Asset
import Browser exposing (Document)
import Html exposing (Html, a, button, div, i, img, li, nav, p, span, strong, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Session exposing (Session)
import Viewer exposing (Viewer)


{-| Take a page's Html and frames it with a navbar.
-}
view :
    { mobileNavbarOpen : Bool, toggleMobileNavbar : msg }
    -> Maybe Viewer
    -> { title : String, content : Html pageMsg }
    -> (pageMsg -> msg)
    -> Document msg
view navConfig maybeViewer { title, content } toMsg =
    { title = title
    , body =
        viewNavbar navConfig maybeViewer
            :: List.map (Html.map toMsg) [ content ]
    }


{-| Render the navbar.

Will have log-in/sign-up or logout buttons according to whether there is a `Viewer`.

-}
viewNavbar : { mobileNavbarOpen : Bool, toggleMobileNavbar : msg } -> Maybe Viewer -> Html msg
viewNavbar { mobileNavbarOpen, toggleMobileNavbar } maybeViewer =
    nav [ class "navbar is-light" ]
        [ div
            [ class "navbar-brand" ]
            [ a
                [ class "navbar-item", href "https://github.com/amilner42/meen-kickstarter" ]
                [ img [ Asset.src Asset.githubLogo ] [] ]
            , div
                [ classList
                    [ ( "navbar-burger", True )
                    , ( "is-active", mobileNavbarOpen )
                    ]
                , onClick toggleMobileNavbar
                ]
                [ span [] [], span [] [], span [] [] ]
            ]
        , div
            [ classList
                [ ( "navbar-menu", True )
                , ( "is-active", mobileNavbarOpen )
                ]
            ]
            [ div
                [ class "navbar-start" ]
                [ a [ class "navbar-item", Route.href Route.Home ] [ text "Home" ]
                ]
            , div
                [ class "navbar-end" ]
                (case maybeViewer of
                    Nothing ->
                        [ a
                            [ class "navbar-item", Route.href Route.Register ]
                            [ text "Sign up" ]
                        , a
                            [ class "navbar-item", Route.href Route.Login ]
                            [ text "Log in" ]
                        ]

                    Just viewer ->
                        [ a
                            [ class "navbar-item", Route.href Route.Logout ]
                            [ text "Log out" ]
                        ]
                )
            ]
        ]
