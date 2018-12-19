/// Module for app encapsulating app configuration.

/**
 * Config for the backend.
 */
export const APP_CONFIG = {
  "app": {
    "baseUrl": "https://example.com", // TODO-STARTER
    "secondsBeforeReloginNeeded": 1000 * 60 * 60 * 24 * 365 * 10, // TODO-STARTER
    "expressSessionSecretKey": "changeThisSecretKey", // TODO-STARTER
    "expressSessionCookieName": "meenSession", // TODO-STARTER
    "isHttps": false,
    "port": 3001,
    "apiSuffix": "/api"
  },
  "db": {
    "url": "mongodb://localhost:27017/meenKickstarter" // TODO-STARTER
  }
}
