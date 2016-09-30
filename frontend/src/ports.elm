port module Ports exposing(..)

import Types


-- Saves the model to localstorage.
port saveModelToLocalStorage : String -> Cmd msg

-- Loads the model from local storage.
port loadModelFromLocalStorage : () -> Cmd msg

-- Upon loading the model from local storage.
port onLoadModelFromLocalStorage : (String -> msg) -> Sub msg
