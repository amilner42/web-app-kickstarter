module Page exposing (Page(..), view, viewErrors)

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


{-| Determines which navbar link (if any) will be rendered as active.
-}
type Page
    = Other
    | Home
    | Login
    | Register


{-| Take a page's Html and frames it with a header.

The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.

-}
view : Maybe Viewer -> Page -> { title : String, content : Html msg } -> Document msg
view maybeViewer page { title, content } =
    { title = title
    , body = viewHeader page maybeViewer :: [ content ]
    }


viewHeader : Page -> Maybe Viewer -> Html msg
viewHeader activePage maybeViewer =
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
