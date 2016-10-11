# Frontend

The frontend is fully coded in Elm. If you are new to Elm, it is worth checking
out the [main tutorial](https://guide.elm-lang.org/) to get a better grip of
what is going on.

### File Structure

##### Components

All components go in this directory, the base component is at root level
and nested components go inside directories such as `Components/Home`.

Each component has the following files:
- Init.elm
  - Each component is responsible for showing how to initialize it's model that
    way when a user first comes to the website we know how to populate the full
    model with defaults.
- Messages.elm
  - The `Msg` that will be passed to the `update` function of that component.
- Model.elm
  - The model that represents all the data needed for that component. The base
    component will put nested models in itself such as `homeComponent`. This is
    done for organizational purposes to make the model layout simpler and to
    avoid namespace collisions. All `update` functions (base component and
    nested components) will be given the full model (base component model)
    because they may need to change something out of their own model (eg. the
    home component may need to change the `user`.)
- Styles.scss
  - The styles for that component. I use a helper function from my util,
    `cssComponentNamespace` that makes divs with css classes for your component
    such as `home-component-wrapper` and `home-component`.
- Update.elm
  - The `update` function for the component, the `case ... of` will be taking
    in a message of the type declared in `Messages.elm`.
- View.elm
  - The view for the component, eg. it could be the view for the welcome page
    or the home page. Note that I have a single `View.elm` for both the home
    profile page and the home home page. A `View.elm` need not correspond to a
    single route, but rather it is simply the view for a single component.

##### Default Services

All file that go here represent default services that can be used from project
to project, you should **not** put stuff in DefaultServices that is
app-specific. Some useful default services are:
- Http (does the annoying part of handling http errors)
- Util (put all random functions that are useful in this file, "utilities")
- LocalStorage (handles interacting with localStorage)
- Router (handles routing)

##### Models

All application models should go here, this is not the same as the `Model.elm`
files which represent the application model, but rather models which represent
things like a `User` or a `Route`. Often these models will be sent/received
from the API so they will often have the functions:
- `encoder`
- `decoder`
- `fromJsonString`
- `toJsonString`

Note that there are two types of encoders/decoders you will see:
- `encoder` / `cacheEncoder`
- `decoder` / `cacheDecoder`
- `fromJsonString` / `fromCacheJsonString`
- `toCacheJsonString` / `toCacheJsonStrng`

The reason you see a duplicate of everything with a `cache` mode is because
there are two situations where we encode our data:
1. We are sending data to the API, in this case we want to encode everything
"normally".
2. We are `cache`ing the data in local storage, in this case we need to be a bit
careful because we don't want to `cache` passwords, we erase all sensitive data.

Follow the existing name convention so it's easy to find and use the correct
encoder/decoder based on the situation.

##### Styles

While we put component styles in the directories of their component (so it's
easy to find while developing) we also have some styles not specific to any
component, these are placed in this directory:
- Mixins.scss
  - Just useful mixins...
- Global.scss
  - Global styles, such as styles on `html` or `body` or classes that we want
    to be able to use in any component.
- Variables.scss
  - Just a list of app scss variables such as the colors used in the app.

##### Top Level Files

- Api.elm
  - All the connections to the API will be through this module, notice the
    naming convention of starting with `get` or `post`.
- Config.elm
  - Configuration for the app
- DefaultModel.elm
  - Provides the default model for the entire application
- Main.elm
  - Initialize the elm application here
- Ports.elm
  - All ports should be in this module
- Subscriptions.elm
  - All subscriptions should be in this module

### Style Conventions

Thanks to [elm-format](https://github.com/avh4/elm-format)https://github.com/avh4/elm-format
all the code can be automatically formatted and you need not have the slightest
care in the world about indentation and style conventions...oh Elm :)

I do recommend hooking it up to a plugin in your IDE of choice (I use Atom) so
that it automatically formats your elm code on save, it's very convenient.
