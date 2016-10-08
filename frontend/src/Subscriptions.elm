module Subscriptions exposing (subscriptions)

import Ports
import DefaultServices.LocalStorage as LocalStorage
import Components.Model exposing (Model)
import Components.Messages exposing (Msg)


{-| All the application subscriptions.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Ports.onLoadModelFromLocalStorage LocalStorage.onLoadModel ]
