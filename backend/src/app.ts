import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import mongoose from "mongoose";
import bluebird from "bluebird";
import { MONGODB_URI, WEB_CLIENT_ORIGIN } from "./util/secrets";
import { expressValidatorToFormErrorMiddleware } from "./util/form";
import * as emailRoutes from "./routes/email";

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

// Express configuration
app.set("port", process.env.PORT || 3001);
app.use(cors({ credentials: true, origin: WEB_CLIENT_ORIGIN }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());


/**
 * Primary app routes.
 */
app.post('/emails', emailRoutes.postAddEmailValidator, expressValidatorToFormErrorMiddleware, emailRoutes.postAddEmail);


export default app;
