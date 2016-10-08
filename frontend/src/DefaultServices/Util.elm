module DefaultServices.Util exposing (..)

import Json.Encode as Encode
import Html exposing (Html, div)
import Html.Attributes exposing (class)


{-| Useful for encoding, turns maybes into nulls / there actual value.
-}
justValueOrNull : (a -> Encode.Value) -> Maybe a -> Encode.Value
justValueOrNull somethingToEncodeValue maybeSomething =
    case maybeSomething of
        Nothing ->
            Encode.null

        Just something ->
            somethingToEncodeValue something


{-| Result or ...
-}
resultOr : Result a b -> b -> b
resultOr result default =
    case result of
        Ok valueB ->
            valueB

        Err valueA ->
            default


{-| Creates a css namespace around some html
-}
cssNamespace : String -> Html msg -> Html msg
cssNamespace classNames html =
    div [ class classNames ]
        [ html ]


{-| Pass the component name such as "home" or "some-name". Returns a css
namespace for that component such as "home-component" wrapped in a div with
class name `home-component-wrapper`.
-}
cssComponentNamespace : String -> Maybe (String) -> Html msg -> Html msg
cssComponentNamespace componentName additionalClasses html =
    let
        className =
            componentName ++ "-component"

        wrapperClassName =
            className ++ "-wrapper"

        classes =
            case additionalClasses of
                Nothing ->
                    className

                Just extraClasses ->
                    className ++ " " ++ extraClasses
    in
        cssNamespace
            wrapperClassName
            (cssNamespace classes html)


{-| Returns true if `a` is nothing.
-}
isNothing : Maybe a -> Bool
isNothing maybeValue =
    case maybeValue of
        Nothing ->
            True

        Just something ->
            False


{-| Returns true if `a` is not nothing.
-}
isNotNothing : Maybe a -> Bool
isNotNothing maybeValue =
    not <| isNothing <| maybeValue


{-| Returns `baseClasses` if `boolean` is False, otherwise returns `baseClasses`
with `additionalClasses`. Basic helper for conditionally adding classes.
-}
withClassesIf : String -> String -> Bool -> String
withClassesIf baseClasses additionalClasses boolean =
    case boolean of
        True ->
            baseClasses ++ " " ++ additionalClasses

        False ->
            baseClasses
