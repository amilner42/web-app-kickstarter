module Page exposing (view)

{-| This allows you to insert a page, providing the navbar outline common to all pages.
-}

import Asset
import Browser exposing (Document)
import Html exposing (Html, a, button, div, i, img, li, nav, p, span, strong, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Route exposing (Route)


{-| Take a page's Html and frames it with a navbar.
-}
view :
    { mobileNavbarOpen : Bool, toggleMobileNavbar : msg }
    -> { title : String, content : Html pageMsg }
    -> (pageMsg -> msg)
    -> Document msg
view navConfig { title, content } toMsg =
    { title = title
    , body = viewNavbar navConfig :: List.map (Html.map toMsg) [ content ]
    }


{-| Render the navbar.
-}
viewNavbar : { mobileNavbarOpen : Bool, toggleMobileNavbar : msg } -> Html msg
viewNavbar { mobileNavbarOpen, toggleMobileNavbar } =
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
                [ class "navbar-end" ]
                [ a [ class "navbar-item", Route.href Route.Home ] [ text "Home" ]
                , a
                    [ class "navbar-item", Route.href Route.AboutUs ]
                    [ text "About Us" ]
                ]
            ]
        ]
