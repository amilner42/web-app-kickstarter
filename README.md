# MEA2N Kickstarter

### Some Quick Credit

After a summer of working with [Radify](http://radify.io), a (hopefully) stable base
for mea2n applications was developed mostly by [Nate](https://github.com/nateabele) and
myself. Thank's to Radify's love for open-source, another kickstarter can be
launched into the community!

### General Idea

The focus of this kickstarter is to give you a well-documented *simple*
foundation for mea2n development including:
  - An intuitive file structure (frontend in `frontend`, backend in `backend`
    etc...)
  - A full typescript project with all typings *already* set up on both the
    frontend and the backend. Some really sweet stuff here with module
    augmentation and namespaces resolving in a *simple* developer experience.
  - The frontend is generated with the angular-cli, so you can cruise through
    your development automatically generating all your `services`, `components`
    etc...
  - Authentication done out of the box, register at `/register` and login at
    `/login`, duh!
  - Custom services added to the frontend, including the `globalStateService`
    for a *simple* way of monitoring your apps globalState in *one place*, an
    `authService` for logging-in/registering/logging-out, a `base-service` that
    all services extends that removes duplicate code, and some more...
  - Some routing already set up with `canActivate` guards including a
    welcome-page which already handles sign-up / log-in.
  - And more...

### Getting Started

If you're new to this kick-starter, you'll probably wanna go read
[getting-started](/docs/getting-started.md).

### Local Dependencies

The project only has 2 local dependencies, `node` and `npm`.
  - node ~ V6.0.0
  - npm ~ V3.10.3
  - monodb ~ V3.2.9

You don't _need_ these versions, but it's more likely to work properly if at
least the major versions are correct.

### Project File Structure

Let's keep it simple...
  - frontend in `/frontend`
  - backend in `/backend`
  - tooling scripts in `/bin`
  - extra docs in `/docs`

As well, the [frontend README](/frontend/README.md) and the
[backend README](/backend/README.md) each have a segment on their file
structure.


### Style Conventions

##### Frontend

The `frontend` is generated with the angular-cli so it already follows all the
style conventions...that was easy.

##### Backend

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

### Versioning

As this is a kickstarter and not a library, it seems unclear how I would go
about using [semantic versioning](http://semver.org/) (also I don't expect
anyone to ever update the kickstarter mid-project).

Instead we will use the following versioning: `<important-release>.<bug-fix>`

Similar to semantic versioning, the last digit represents bug fixes, you should
always use the latest bug-fix version of an important-release. The
important-release number represents what I consider to be an important release,
in other words if you were using version `1.4` and version `2.0` is released
then I highly recommend you go put in the time to understand `2.0`, each
important-release will likely be accompanied by a change-log. On the other hand,
if you were using version `1.4` and you are starting a new project and version
`2.x` hasn't been released, don't bother looking at all the tiny changes and
using the latest code from the `master` branch, instead focus on developing
faster and wasting less time, stick to the version you were using before and
are comfortable with!

### Contributing

Please :)

Standard github PR model, please make a meaningful PR which ideally is divided
into the following sections:
  - Closes
  - Description
  - Screenshots (if applicable)
  - Future (any possible future ideas that came up from this issue)

### Bugs / Feature Requests

Go make an issue, thanks! I'll take a look as soon as I can, this project is
currently being officially supported by me :)

### License

3-clause BSD License.

That being said, if you do make improvements to the kickstarter itself, I *ask* that you share your work (but I do not *force* it).

Additionally, if you happen to use this kickstarter at your organization/company/startup, I *ask* that you shoot me an email and let me know - make my day - but again I do not *force* this.
