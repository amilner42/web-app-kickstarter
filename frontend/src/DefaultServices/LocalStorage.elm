module DefaultServices.LocalStorage exposing (saveModel, onLoadModel)

import Types
import Ports
import Models.Model as Model

{-
  This module will not be needed soon, they are working on a cool localStorage
  cache system for elm, shoudl be released soon.

  This module requires a couple ports in the ports module and a script must be
  added to the index page.

  HTML (on index):

      <script>
        var modelKey = "model";
        var storedModel = localStorage.getItem(modelKey);
        var startingModel = storedModel ? JSON.parse(storedModel) : null;
        var elmApp = Elm.Main.fullscreen(startingModel);

        // Saves the model to local storage.
        elmApp.ports.saveModelToLocalStorage.subscribe(function(model) {
          localStorage.setItem(modelKey, JSON.stringify(model));
        });

        // Load the model from localStorage and send message to subscription over
        // port.
        elmApp.ports.loadModelFromLocalStorage.subscribe(function() {
          app.ports.onLoadModelFromLocalStorage.send(localStorage.getItem(modelKey))
        });
      </script>

    Ports:

    -- Saves the model to localstorage.
    port saveModelToLocalStorage : Encode.Value -> Cmd msg

    -- Loads the model from local storage.
    port loadModelFromLocalStorage : () -> Cmd msg

    -- Upon loading the model from local storage.
    port onLoadModelFromLocalStorage : (String -> msg) -> Sub msg
-}


-- Saves the model to localStorage using the port.
saveModel: Types.Model -> Cmd Types.Msg
saveModel model =
  Ports.saveModelToLocalStorage <| Model.encoder <| model


-- Will be used for the port subscription.
onLoadModel: String -> Types.Msg
onLoadModel modelAsStringFromStorage =
  case Model.fromJsonString modelAsStringFromStorage of
    Ok model ->
      Types.ModelLoadedFromLocalStorage model
    Err error ->
      Types.NoOp -- TODO deal with this
