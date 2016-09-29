/// Module for defining errors-types to better manage application errors
/// programmatically.

import { errorCodes } from './types';


/**
 * A immutable base error for all errors in the application to extend.
 *
 * `errorCode`s provide a convenient way of programatically handling errors, all
 * errors should contain an `errorCode`.
 */
export class BaseError extends Error {

  constructor(errorMessage: string, public errorCode: errorCodes) {
    super(errorMessage);
  }
}

/**
 * To be used with all model validation when a model is invalid.
 */
export class InvalidModelError extends BaseError { }

/**
 * To be used when a union type has multiple custom errors from restrictions.
 *
 * The `catcher` of the error must go through the errors and decide which one
 * to send to the client.
 */
export class InvalidModelUnionTypeError extends InvalidModelError {

  public unionErrors: InvalidModelError[];

  constructor(errorMessage: string, unionErrors: InvalidModelError[]) {
    super(errorMessage, errorCodes.modelUnionTypeHasMultipleErrors);
    this.unionErrors = unionErrors;
  }
}
