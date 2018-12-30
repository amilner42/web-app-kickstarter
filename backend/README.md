# Backend

### Introduction

Project forked from [here](https://github.com/gothinkster/node-express-realworld-example-app) and
then stripped down. Refer to that repo if you want to see an example of how to build an API
using this technology.

This is a very minimal starting point so it's barely opinionated beyond the choice of the technology
itself. It's just the skeleton of a very standard node/express/mongo/mongoose application which uses
JWT for authentication.

### Env variables

```javascript
// Env variables
const isProduction = process.env.NODE_ENV === 'production';
const mongoProdURI = process.env.MONGODB_URI; // In dev defaults to 'kickstarter'
const port = process.env.PORT; // Defaults to 3001
```
