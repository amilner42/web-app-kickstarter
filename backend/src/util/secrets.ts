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

export const MONGODB_URI = IS_PROD ? process.env["MONGODB_URI"] : process.env["MONGODB_URI_LOCAL"];
export const WEB_CLIENT_ORIGIN = IS_PROD ? process.env["WEB_CLIENT_ORIGIN"] : "http://localhost:3000";

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
