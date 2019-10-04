import express from "express";
import expressSession from "express-session";
import bodyParser from "body-parser";
import cors from "cors";
import connectMongo from "connect-mongo";
import mongoose from "mongoose";
import passport from "passport";
import bluebird from "bluebird";
import { MONGODB_URI, SESSION_SECRET, WEB_CLIENT_ORIGIN, COOKIE_NAME,  COOKIE_EXPIRY_MILLI } from "./util/secrets";
import { expressValidatorToFormErrorMiddleware } from "./util/form";
import cookieParser from "cookie-parser";

import * as userRoutes from "./routes/user";


// Create Express server
const app = express();

// Connect to MongoDB
const mongoUrl = MONGODB_URI;
mongoose.Promise = bluebird;

mongoose.connect(mongoUrl, { useNewUrlParser: true, useCreateIndex: true, useUnifiedTopology: true } ).then(
    () => { /** ready to use. The `mongoose.connect()` promise resolves to undefined. */ },
).catch(err => {
    console.log("MongoDB connection error. Please make sure MongoDB is running. " + err);
    // process.exit();
});

const MongoStore = connectMongo(expressSession);

// Express configuration
app.set("port", process.env.PORT || 3001);
app.use(cors({ credentials: true, origin: WEB_CLIENT_ORIGIN }));
app.use(cookieParser(SESSION_SECRET));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(expressSession({
    resave: true,
    saveUninitialized: true,
    secret: SESSION_SECRET,
    name: COOKIE_NAME,
    cookie: { maxAge: COOKIE_EXPIRY_MILLI, sameSite: false },
    store: new MongoStore({ mongooseConnection: mongoose.connection })
}));
app.use(passport.initialize());
app.use(passport.session());
require("./config/passport");

/**
 * Primary app routes.
 */
app.post("/login", userRoutes.postLoginValidator, expressValidatorToFormErrorMiddleware, userRoutes.postLogin);
app.post("/logout", userRoutes.postLogout);
app.get("/me", userRoutes.getCurrentUser);
app.post("/users", userRoutes.postRegisterValidator, expressValidatorToFormErrorMiddleware, userRoutes.postRegister);


export default app;
