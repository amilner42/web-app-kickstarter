# MEEN Kickstarter

[WARNING: Kickstarter Incomplete (working on it now...)]

### Some Quick Credit

After a summer of working with [Radify](http://radify.io), a (hopefully) stable base
for [mea2n applications](https://github.com/amilner42/mea2n-kickstarter) was
developed mostly by [Nate](https://github.com/nateabele) and
myself.

I then chopped off the a2, replacing it with e (Elm). Now we have meen stack.

### Quick Rant

Ahh where to begin...I realized there were fundamental problems with Angular,
with React, with all these Frontend frameworks. I realized my frame of mind was
off, I was building apps that were "easy" to develop on but they were very
"complex". I needed to go for "simple", and the "easy" would come over time.
This shift of mind was inspired by this incredible
[talk](https://www.youtube.com/watch?v=rI8tNMsozo0). I highly recommend watching
that...now. Then I discovered Elm, both faster than Angular 2 and React,
100% Type Inference, 0 runtime exceptions, forwards/backwards debugging, no
null/undefined ... the list goes on ...

Essentially, this kickstarter attempts to offer similar benefits to my last
[mea2n kickstarter](https://github.com/amilner42/mea2n-kickstarter), but uses
Elm for better **simple** software engineering.

### Local Dependencies

The project only has 4 local dependencies, `node` and `npm`, `mongodb` and
`elm`.
  - node ~ V6.0.0
  - npm ~ V3.10.3
  - monodb ~ V3.2.9
  - elm ~ v0.17

You don't _need_ these versions, but it's more likely to work properly if at
least the major versions are correct. For elm, do to it's wild nature you will
need exactly v0.17 (the latest), 0.18 is on the way and I will attempt to keep
up to date with Elm upgrades.

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

Format everything with elm-format, done. Yup...Elm...

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
