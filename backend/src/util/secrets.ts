import logger from "./logger";
import dotenv from "dotenv";
import fs from "fs";

if (fs.existsSync(".env")) {
    logger.debug("Using .env file to supply config environment variables");
    dotenv.config({ path: ".env" });
} else {
    logger.debug("Using .env.example file to supply config environment variables");
    dotenv.config({ path: ".env.example" });  // you can delete this after you create your own .env file!
}
export const ENVIRONMENT = process.env.NODE_ENV;
export const IS_PROD = ENVIRONMENT === "production"; // Anything else is treated as 'dev'

export const SESSION_SECRET = process.env["SESSION_SECRET"];
export const MONGODB_URI = IS_PROD ? process.env["MONGODB_URI"] : process.env["MONGODB_URI_LOCAL"];
export const WEB_CLIENT_ORIGIN = IS_PROD ? process.env["WEB_CLIENT_ORIGIN"] : "http://localhost:3000";
export const COOKIE_EXPIRY_MILLI = IS_PROD ? parseInt(process.env["COOKIE_EXPIRY_MILLI"]) : 7 * 24 * 60 * 60 * 1000;
export const COOKIE_NAME = IS_PROD ? process.env["COOKIE_NAME"] : "devCookieName";

if (!SESSION_SECRET) {
    logger.error("No client secret. Set SESSION_SECRET environment variable.");
    process.exit(1);
}

if (!MONGODB_URI) {
    if (IS_PROD) {
        logger.error("No mongo connection string. Set MONGODB_URI environment variable.");
    } else {
        logger.error("No mongo connection string. Set MONGODB_URI_LOCAL environment variable.");
    }
    process.exit(1);
}

if (!WEB_CLIENT_ORIGIN) {
    logger.error("No web client origin defined.");
    process.exit(1);
}

if (!COOKIE_EXPIRY_MILLI) {
    logger.error("No cookie expiry. Set COOKIE_EXPIRY_MILLI environment variable.");
}

if (!COOKIE_NAME) {
    logger.error("No cookie name. Set COOKIE_NAME environment variable.");
}
