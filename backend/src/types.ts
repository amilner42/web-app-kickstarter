/// Module for all typings specific to the app.

import { Handler } from "express";


/**
 * Format of the application's routes.
 */
export interface appRoutes {
  [routeUrl: string]: {
    [methodType: string]: Handler;
  }
}

/**
 * A `user`.
 */
export interface user {
  _id?: string;
  email: string;
  password?: string;
}

/**
 * A namespace for encapsulating all structures.
 *
 * Structures are used to model `type`s and `interface`s so that validation
 * can be performed at runtime based on the interface/type for a given
 * model. On top of the structure of a given model which can (hopefully) be
 * automatically created from a given interface/type, custom validation can
 * be added.
 */
export namespace structures {

  /**
   * A `typeStructure` is one of the following four categories.
   */
  export enum typeCategory {
    primitive,
    array,
    union,
    interface
  }

  /**
   * The 6 Javascript primitive types.
   */
  export enum primitiveType {
    string,
    number,
    boolean,
    null,
    undefined,
    symbol
  }

  /**
   * Every type should extend `baseType` so that it specifies what category
   * it is in, this makes programmtically sifting through types simpler.
   */
  export interface baseType {
    typeCategory: typeCategory;
  }

  /**
   * A restriction can be placed on any `restrictableType`, for which it should
   * `Promise.reject(new invalidModelError)` if the `modelInstance` is invalid,
   * otherwise it should `Promise.resolve()`` or simply return void.
   *
   * NOTE: There seems to be slightly strange behaviour when using throwing
   * errors instead of `reject`ing them, so avoid directly throwing errors.
   */
  export type restriction = (modelInstance: any) => void | Promise<void>;

  /**
   * A restrictable type represents a type which can have restrictions.
   * Currently all categories of types support restrictions except for
   * unions (because in a union, each type should have it's own
   * restrictions).
   */
  export interface restrictableType extends baseType {
    restriction?: restriction;
  }

  /**
   * A formal representation of the structure of a `type`.
   */
  export type typeStructure = primitiveStructure | arrayStructure | unionStructure | interfaceStructure;

 /**
  * A formal representation of the structure of an `interface`.
  */
  export interface interfaceStructure extends restrictableType {
    /**
     * The properties on the interface.
     */
    properties: {
      /**
       * Each property has a type.
       */
      [propertyName: string]: typeStructure;
    };
  }

  /**
   * A formal representation of the structure of a primitive.
   */
  export interface primitiveStructure extends restrictableType {
    /**
     * The primitive type.
     */
    type: primitiveType;
  }

  /**
   * A formal representation of the structure of an array.
   *
   * NOTE: The restrictions apply to the array itself, not the elements in
   * the array, the restrictions on the elements themselves will be
   * determined from the restrictions placed on the `type` of the element
   * itself.
   */
  export interface arrayStructure extends restrictableType {
    /**
     * The type of a single element in the array.
     */
    type: typeStructure;
  }

  /**
   * A formal representation of the structure of a union of types.
   *
   * NOTE: that a union has no restrictions because the restrcitions will be
   * present on each individual type in the union.
   */
  export interface unionStructure extends baseType {
    /**
     * A union of all the types in `types`.
     */
    types: typeStructure[];
  }
}

/**
 * All models (in `/models`) should export an implementation of this
 * interface.
 */
export interface model<T> {

  /**
   * Unique name, should be identical to the name of interface `T`.
   */
  name: string;

  /**
   * Prior to responding to an HTTP request with a model, this method should
   * be called to strip sensitive data, eg you don't wanna be sending the
   * user his data with the password attached.
   */
  stripSensitiveDataForResponse: (model: T) => T;
}

/**
 * All errorCodes for simpler programmatic communication between the client and
 * server.
 *
 * NOTE An identical enum should be kept on the frontend/backend.
 */
export enum errorCodes {
  youAreUnauthorized = 1,
  emailAddressAlreadyRegistered,
  noAccountExistsForEmail,
  incorrectPasswordForEmail,
  phoneNumberAlreadyTaken,
  invalidMongoID,
  invalidEmail,
  invalidPassword,
  modelHasInvalidTypeStructure,     // This implies that the API was queried direclty with an incorrectly formed object.
  internalError,                    // For errors that are not handleable
  modelUnionTypeHasMultipleErrors,
  passwordDoesNotMatchConfirmPassword
}
