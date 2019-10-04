# Frontend

### Introduction

Project structure forked from
[this semi-official open source elm SPA example](https://github.com/rtfeldman/elm-spa-example). I've
added webpack thanks to [this repo](https://github.com/simonh1000/elm-webpack-starter) being a
helpful example.

For css I've went with [Bulma](https://bulma.io/), a free and open-source solution. I have minimal
css though and scss is already set up so you can easily switch to another framework or go vanilla.

For the build pipeline I went with [webpack](https://webpack.js.org/) which is a simple and powerful
tool.

### Goals

- [x] Have a production ready build-pipeline
- [x] Have a nice dev experience
    - [x] Simple build commands
    - [x] Hot reloading
- [x] Do things the elm-way: have things be data structure oriented and avoid a component-centric approach.
- [x] Have things be mobile-friendly.


### Set Up

```bash
cd frontend;
npm install;
```

##### NOTE

Do a find-and-replace after your fork and replace all "TODO-STARTER" with appropriate values for your app.

### Developing

```bash
cd frontend;
npm run dev;
```

### Production

```bash
cd frontend;
# Output static assets into dist/
npm run prod;
```
