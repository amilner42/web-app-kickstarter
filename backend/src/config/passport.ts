import passport from "passport";
import passportLocal from "passport-local";

import { User } from "../models/User";
import * as Form from "../util/form";

const LocalStrategy = passportLocal.Strategy;


passport.serializeUser<any, any>((user, done) => {
    done(undefined, user.id);
});


passport.deserializeUser((id, done) => {
    User.findById(id, (err, user) => {
        done(err, user);
    });
});


/**
 * Sign in using Email and Password.
 */
passport.use(new LocalStrategy(
    { usernameField: "email", passwordField: "password" },
    (email, password, done) => {
        User.findOne({ email: email.toLowerCase() }, (err, user: any) => {
            if (err) { return done(err); }
            if (!user) {
                const formError: Form.FormError = Form.fromFieldErrors({
                    email: [ `Email ${email} not found.` ]
                });

                return done(undefined, false, formError);
            }
            user.comparePassword(password, (err: Error, isMatch: boolean) => {
                if (err) { return done(err); }
                if (isMatch) {
                    return done(undefined, user);
                }

                const formError: Form.FormError = Form.fromEntireErrors([
                    "Invalid email or password."
                ]);

                return done(undefined, false, formError);
            });
        });
    })
);
