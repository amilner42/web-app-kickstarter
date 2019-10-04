import { fromFieldErrors } from "../util/form";
import { Request, Response, NextFunction } from "express";
import { check, sanitize, validationResult } from "express-validator";
import { Email, EmailDocument } from "../models/Email";


export const postAddEmailValidator = [
    check("email", "Email is not valid").isEmail(),
    sanitize("email").normalizeEmail({ gmail_remove_dots: false })
];


export const postAddEmail = (req: Request, res: Response, next: NextFunction) => {

    return Email.findOne({ email: req.body.email })
    .then((result) => {
        if (result) {
            return res.status(400).json(fromFieldErrors({ email: [ "This email is already subscribed!" ] }));
        }
    })
    .then(() => {
        const newEmail = new Email({ email: req.body.email });

        return newEmail.save();
    })
    .then(() => {
        return res.status(200).send({ ok: 1 });
    })
    .catch((err) => {
         return res.sendStatus(500);
    });

}
