'use strict';

require("./styles/styles.scss");

const {Elm} = require('./Main');
var storageKey = "store";
var flags = localStorage.getItem(storageKey);
var app = Elm.Main.init({flags: flags});

/** PORTS and SUBSCRIPTIONS */

// Save `val` to localStorage
app.ports.storeCache.subscribe(function(val) {
  if (val === null) {
    localStorage.removeItem(storageKey);
  } else {
    localStorage.setItem(storageKey, JSON.stringify(val));
  }
  // Report that the new session was stored succesfully.
  setTimeout(function() { app.ports.onStoreChange.send(val); }, 0);
});

// Whenever localStorage changes in another tab, report it if necessary.
window.addEventListener("storage", function(event) {
  if (event.storageArea === localStorage && event.key === storageKey) {
    app.ports.onStoreChange.send(event.newValue);
  }
}, false);
