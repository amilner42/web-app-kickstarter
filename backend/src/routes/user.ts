import passport from "passport";
import { FormError } from "../util/form";
import { User, UserDocument } from "../models/User";
import { Request, Response, NextFunction } from "express";
import { check, sanitize, validationResult } from "express-validator";
import "../config/passport";


/**
 * GET /me
 * Gets the currently logged in user.
 */
export const getCurrentUser = (req: Request, res: Response, next: NextFunction) => {

    if (req.user) {
        return res.json({ email: "test" });
    }

    return res.sendStatus(401);
};


export const postLoginValidator = [
    check("email", "Email is not valid").isEmail(),
    check("password", "Password cannot be blank").isLength({min: 1}),
    // eslint-disable-next-line @typescript-eslint/camelcase
    sanitize("email").normalizeEmail({ gmail_remove_dots: false })
];


/**
 * POST /login
 * Sign in using email and password.
 */
export const postLogin = (req: Request, res: Response, next: NextFunction) => {

    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        return res.status(403).json(errors.mapped());
    }

    passport.authenticate("local", (err: Error, user: UserDocument, formError: FormError) => {
        if (err) { return next(err); }
        if (!user) {
            return res.status(403).json(formError);
        }
        req.logIn(user, (err) => {
            if (err) { return next(err); }
            return res.json({ email: user.email });
        });
    })(req, res, next);
};


/**
 * POST /logout
 * Log out.
 */
export const postLogout = (req: Request, res: Response) => {
    req.logout();
    res.json({});
};


export const postRegisterValidator = [
    check("email", "Email is not valid").isEmail(),
    check("password", "Password must be at least 6 characters long").isLength({ min: 6 }),
    // eslint-disable-next-line @typescript-eslint/camelcase
    sanitize("email").normalizeEmail({ gmail_remove_dots: false })
];


/**
 * POST /signup
 * Create a new local account.
 */
export const postRegister = (req: Request, res: Response, next: NextFunction) => {

    const errors = validationResult(req);

    console.log(`err: ${JSON.stringify(errors)}`);

    if (!errors.isEmpty()) {
        return res.status(403).json(errors.mapped());
    }

    const user = new User({
        email: req.body.email,
        password: req.body.password
    });

    User.findOne({ email: req.body.email }, (err, existingUser) => {
        if (err) { return next(err); }
        if (existingUser) {
            return res.status(403).json({
                entire: [],
                fields: { "email": "Account with that email address already exists." }
            });
        }
        user.save((err) => {
            if (err) { return next(err); }
            req.logIn(user, (err) => {
                if (err) {
                    return next(err);
                }
                return res.json({ email: user.email });
            });
        });
    });
};
