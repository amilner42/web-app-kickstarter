# MEEN Kickstarter

### Credit

After a summer of working with [Radify](http://radify.io), a (hopefully) stable
base for [mea2n applications](https://github.com/amilner42/mea2n-kickstarter)
was developed mostly by @nateabele and myself. I then switched the Angular 2 for
Elm, leaving us with meen-stack. While trying to build the `frontend`, an
[example app](https://github.com/sporto/elm-tutorial-app/) created by @sporto
was of great use to me. So huge thanks to both of them!

### Quick Rant

Ahh where to begin...I realized there were fundamental problems with Angular,
with React, with all these front-end frameworks. I realized my frame of mind was
off, I was building apps that were "easy" to develop on but they were very
"complex". I needed to go for "simple", and the "easy" would come over time.
This shift of mind was inspired by this incredible
[talk](https://www.youtube.com/watch?v=rI8tNMsozo0). I highly recommend watching
that...now. Then I discovered Elm, both faster than Angular 2 and React,
with incredibly strong type inference, almost no runtime exceptions,
forwards/backwards debugging, no null/undefined ... the list goes on ...

Essentially, this kickstarter attempts to offer similar benefits to my last
[mea2n kickstarter](https://github.com/amilner42/mea2n-kickstarter), but uses
Elm for better **simple** software engineering.

### Local Dependencies

The project only has 3 local dependencies, `node` and `npm`, and `mongodb`.
  - node ~ V6.0.0
  - npm ~ V3.10.3
  - monodb ~ V3.2.9

You don't _need_ these versions, but it's more likely to work properly if at
least the major versions are correct.

### Set Up

Once you have those local dependencies, simply run `./bin/install.sh` to install
all node/elm modules as well as typings...that's it!

### Developing

To develop run `./bin/dev.sh` and that will compile your frontend and backend
code, watch for changes, and host it on localhost:3000.

My IDE of choice to develop in is Atom, I have a soft spot in my heart for
Github (lots of <3). If you do choose to use Atom, you can get beautiful auto
complete for BOTH the frontend (Elm) and the backend (Typescript) by getting
the following atom plugins:
  - elmjutsu : A combination of elm goodies wrapped up in one plugin.
  - elm-format : Allows you to run elm-format on save, very convenient.
  - atom-typescript : the only typescript plugin you will ever need.

I highly recommend getting Atom with the plugins above, it'll only take a few
minutes and your development experience across the full stack will be great!

### Project File Structure

Let's keep it simple...
  - frontend in `/frontend`
  - backend in `/backend`
  - tooling scripts in `/bin`
  - extra docs in `/docs`

As well, the [frontend README](/frontend/README.md) and the
[backend README](/backend/README.md) each have a segment on their file
structure.

### Versioning

As this is a kickstarter and not a library, it seems unclear how I would go
about using [semantic versioning](http://semver.org/) (also I don't expect
anyone to ever update the kickstarter mid-project). So for now I will be simply
upgrading the version (eg. 2 to 3) when I think enough new stuff is in the
new version that it's worth upgrading (maybe I'll try and have a change-log...
we'll see...).

### Contributing

Please :)

Standard github PR model, please make a meaningful PR which ideally is divided
into the following sections:
  - Closes
  - Description
  - Screenshots (if applicable)
  - Future (any possible future ideas that came up from this issue)

Doc fixes can be sent without much care and are always appreciated.

### Bugs / Feature Requests

Go make an issue, thanks! I'll take a look as soon as I can, this project is
currently being actively worked on by me.

### License

3-clause BSD License.

That being said, if you do make improvements to the kickstarter itself, I *ask*
that you share your work (but I do not *force* it).
