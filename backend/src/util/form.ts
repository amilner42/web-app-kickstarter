import { Request, Response, NextFunction } from "express";
import { validationResult, ValidationError, Result } from "express-validator";


export type FormError = {
  entire: string[];
  fields: Record<string, string[]>;
}


export const fromFieldErrors = (fieldErrors: Record<string, string[]>): FormError => {

  return { entire: [], fields: fieldErrors };
};


export const fromEntireErrors = (entireErrors: string[]): FormError => {

  return { entire: entireErrors, fields: { }};
};


export const fromExpressValidatorError = (err: Result<ValidationError>): FormError => {

  const errArray = err.array();

  const result: Record<string, string[]> = { };

  for (const validationError of errArray) {

    if (result[validationError.param]) {
      result[validationError.param].push(validationError.msg);
      continue;
    }

    result[validationError.param] = [ validationError.msg ];
  }

  return fromFieldErrors(result);
};


export const expressValidatorToFormErrorMiddleware = (req: Request, res: Response, next: NextFunction) => {

  const errors = validationResult(req);

  if (!errors.isEmpty()) {
      return res.status(403).json(fromExpressValidatorError(errors));
  }

  return next();
};
