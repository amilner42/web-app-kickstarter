# Backend

The backend is fully coded in Typescript. If you are new to Typescript I
recommend reading/skimming through [basarat's guide](https://basarat.gitbooks.io/typescript/content/docs/getting-started.html),
it's a great book!

### File Structure

On the backend most files stay at top level, currently there is only one
directory (`models/`). From what I've learnt this seems to be a better practice
as it avoid nasty relative-pathing for imports and keeps the code simpler to
understand (it's a bit different on the frontend where the recursiveness of
the problem domain leads to more folders and sub-folders).

##### Models

All models used in the application (eg. User, think things that we send/recieve
to/from the frontend). Each model should be of type `Model<typeOfModel>` - this
will force you to add the basic helpful methods such as
`stripSensitiveDataForResponse`.

##### Top Level Files

- db.ts
  - This module allows for connection to the database by using the `collection`
    function, eg. to get the user collection you would `collection('user')` and
    add a `.then` because as per usual it's async.
- errors.ts
  - While relatively empty for now, this is where you will define the error
    hierarchy used in your application. For now just a few errors are defined.
- global_augmentations.ts
  - Should you choose to augment the global namespace, then you will put the
    augmentations in this file.
- main.ts
  - The main file, you will run this to run the full application.
- passport-local-auth-strategies.ts
  - Contains the passport strategies for signing up or signing in.
- routes.ts
  - Contains the routes (you might be used to the word _endpoints_) for the API,
    you should try to avoid putting a lot of logic in this file, simply put the
    routes (otherwise this file bloats).
- server.ts
  - Does all the configuration to get our express server up and running,
    including setting up the hosting for our static frontend.
- types.ts
  - As recommend by basarat (the typescript guy) it is nice to have a file
    where all your types live. It makes it easy to build more complex types
    without needing tons of imports. I originally had this sit in a namespace
    inside the global namespace (so you wouldn't even need to import `types.ts`)
    but do to errors with enums not compiling I switched it over to the
    `types.ts` file.
- util.ts
  - Similar to the frontend, all utilities (generally useful helper functions)
    should be put in this file.
- validifier.ts
  - Validifier is a module which contains validation helpers (such as
    `validEmail`), most importantly it contains a semi-complex validation helper
    called `validModel`. This function allows you to check the validity of
    incoming data by passing the data and a JSON object representing the model
    to the `validModel`, for which it will check that the incoming data does
    match the shape of the JSON object. Additionally you can attach async/sync
    validation at any parts of the object, this validation needs not check the
    type as that is done automatically prior to calling the restriction, but
    rather the restriction can enforce non-type related restrictions such as
    an email needing to be unique for sign up. This module is very powerful in
    that it allows you to write complex validation code in a maintainable simple
    way. To see an example of this, take a look at
    `passport-local-auth-strategies`, this module uses validation to make sure
    the user is ready for registration/login.
  - I will be adding an explanation in `docs/` that goes in more details and
    explains exactly how to use the `validModel` function.

##### Outside Src Directory

There are a few important folders outside the `src` directory:
- migrations
  - All migrations go here, refer to the README there to see the format of how
    to code migrations.
- tests
  - This is where all tests go, tests should end in `.test.ts`, refer to the
    existing tests (`tests/validifier.test.ts`) to see how to write tests.
- typings_manual
  - While manual typings go in `typings/`, not all modules have existing
    typings and thanks to module augmentation (introduced in TS 1.8) we can
    make our own module typings.
  - typings_manual is spit in two folders:
    - augmented_modules: Here we can make augmentations to modules that do have
      typings but where the typings are not correct (perhaps not up to date).
    - fill_in_modules: Here we create our own typings for modules that do not
      have any typings.

### Style Conventions

These are all my opinions on what keeps code clean, I make no claim with my
limited experience that these are objectively good styles to follow.
  - No `export default ...`
     - Same function can be named differently in different files :/
     - If you see a `const ...` you may think it's module-private, only to find it's exported at the bottom :/
  - `const ...` declarations at the top of the module, followed by `export const`
    - Makes it clear what's public and what's private, no surprises :)
  - Every module should have `/// Module for ...` at the top with a brief explanation of the module.
    - Makes it simple for developers joining your team to get the big picture.
  - Docs, docs everywhere :)
