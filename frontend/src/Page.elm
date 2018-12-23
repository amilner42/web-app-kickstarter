module Page exposing (Page(..), view, viewErrors)

import Api exposing (Cred)
import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Session exposing (Session)
import Username exposing (Username)
import Viewer exposing (Viewer)


{-| Determines which navbar link (if any) will be rendered as active.
-}
type Page
    = Other
    | Home
    | Login
    | Register


{-| Take a page's Html and frames it with a header and footer.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

-}
view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title ++ " - Conduit"
    , body = viewHeader page maybeViewer :: content :: [ viewFooter ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader page maybeViewer =
    nav [ class "navbar navbar-light" ]
        [ div [ class "container" ]
            [ a [ class "navbar-brand", Route.href Route.Home ]
                [ text "conduit" ]
            , ul [ class "nav navbar-nav pull-xs-right" ] <|
                navbarLink page Route.Home [ text "Home" ]
                    :: viewMenu page maybeViewer
            ]
        ]


viewMenu : Page -> Maybe Viewer -> List (Html msg)
viewMenu page maybeViewer =
    let
        linkTo =
            navbarLink page
    in
    case maybeViewer of
        Just viewer ->
            [ linkTo Route.Logout [ text "Sign out" ] ]

        Nothing ->
            [ linkTo Route.Login [ text "Sign in" ]
            , linkTo Route.Register [ text "Sign up" ]
            ]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [ class "container" ]
            [ a [ class "logo-font", href "/" ] [ text "conduit" ]
            , span [ class "attribution" ]
                [ text "An interactive learning project from "
                , a [ href "https://thinkster.io" ] [ text "Thinkster" ]
                , text ". Code & design licensed under MIT."
                ]
            ]
        ]


navbarLink : Page -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li
        [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( Register, Route.Register ) ->
            True

        _ ->
            False


{-| Render dismissable errors. We use this all over the place!
-}
viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""
    else
        div [] <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]
