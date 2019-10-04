'use strict';

require("./styles/styles.scss");

const {Elm} = require('./Main');
var storageKey = "store";
var flags = localStorage.getItem(storageKey);
var app = Elm.Main.init({flags: flags});
