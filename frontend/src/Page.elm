module Page exposing (view)

{-| The top-level page has a navbar and content from a sub-page.
-}

import Api.Core exposing (Cred)
import Asset
import Browser exposing (Document)
import Html exposing (Html, a, button, div, i, img, li, nav, p, span, strong, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Session exposing (Session)
import Username exposing (Username)
import Viewer exposing (Viewer)


{-| Take a page's Html and frames it with a header.

The caller provides the `Viewer` to render the appropriate navbar.

-}
view : Maybe Viewer -> { title : String, content : Html msg } -> Document msg
view maybeViewer { title, content } =
    { title = title
    , body = viewNavbar maybeViewer :: [ content ]
    }


{-| Render the navbar.

Will have log-in/sign-up or logout buttons according to whether there is a `Viewer`.

-}
viewNavbar : Maybe Viewer -> Html msg
viewNavbar maybeViewer =
    nav [ class "navbar is-light" ]
        [ div
            [ class "navbar-brand" ]
            [ a
                [ class "navbar-item", href "https://github.com/amilner42/meen-kickstarter" ]
                [ img [ Asset.src Asset.githubLogo ] [] ]
            , div [ class "navbar-burger" ] [ span [] [], span [] [], span [] [] ]
            ]
        , div [ classList [ ( "navbar-menu", True ) ] ]
            [ div
                [ class "navbar-start" ]
                [ a [ class "navbar-item", Route.href Route.Home ] [ text "Home" ]
                ]
            , div
                [ class "navbar-end" ]
                [ div
                    [ class "navbar-item" ]
                    [ div [ class "buttons" ] <|
                        case maybeViewer of
                            Nothing ->
                                [ a
                                    [ class "button is-light", Route.href Route.Register ]
                                    [ text "Sign up" ]
                                , a
                                    [ class "button is-light", Route.href Route.Login ]
                                    [ text "Log in" ]
                                ]

                            Just viewer ->
                                [ a
                                    [ class "button is-light", Route.href Route.Logout ]
                                    [ text "Log out" ]
                                ]
                    ]
                ]
            ]
        ]
