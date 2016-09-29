/// Module for encapsulating all validation logic and helpers.

import R from "ramda";
import Bluebird from "bluebird";

import { isNullOrUndefined } from './util';
import { InvalidModelError, InvalidModelUnionTypeError } from './errors';
import { errorCodes, structures } from './types';


/**
 * Regex for superficially valid phone number.
 *
 * @credit: http://stackoverflow.com/questions/6478875/regular-expression-matching-e-164-formatted-phone-numbers
 */
export const validPhone = (phoneNumber: string) => /^\+?[1-9]\d{1,14}$/.test(phoneNumber);

/**
 * Regex for superficially valid email.
 *
 * @credit: http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
 */
export const validEmail = (email: string) => /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);


/**
 * Checks that a password is considered "strong" enough.
 *
 * Currently we only require 6-char passwords.
 */
export const validPassword = (password: string) => {
  return !(isNullOrUndefined(password)) && (password.length > 6);
}

/**
 * Checks if an id is a valid mongo ID.
 *
 * Currently only checking 24 hex chars.
 */
export const validMongoID = (id: string = ""): boolean => {
  return /^[0-9a-fA-F]{24}$/.test(id);
}

/**
 * Helper for asserting a model has a valid structure.
 *
 * A valid structure means:
 *  - No extra properties are present anywhere in the object.
 *  - All neccessary properties are present.
 *  - Every property has the correct type
 *  - All restrictions are met for that property.
 *
 * @param modelInstance An instane of the model being validified
 * @param typeStructure A representation of the valid type structure
 * @returns Promise to nothing, representing sucess/error of the function.
 */
export const validModel = (modelInstance: any,
    typeStructure: structures.typeStructure): Promise<void> => {

  /**
   * If a restriction exists, checks it.
   *
   * Wraps everything in a promise to change the return type of the restriction
   * from `void | Promis<void>`  to `Promise<void>`.
   */
  const modelInstanceFollowsRestriction =
      (restriction: structures.restriction): Promise<void> => {
    // If no restriction then the model follows the restriction.
    if(!restriction) {
      return Promise.resolve();
    }

    // Let `.then` convert our `void | Promise<void>` to `Promise<void>`.
    return new Promise((resolve, reject) => {
      resolve();
    })
    .then(() => {
      return restriction(modelInstance);
    });
  }

  return new Promise((resolve, reject) => {
    // Deal with the 4 categories of types separately.
    switch(typeStructure.typeCategory) {

      // Primitive Type
      case structures.typeCategory.primitive:
        const primitiveStructure = typeStructure as structures.primitiveStructure;
        const primitiveType =  structures.primitiveType[primitiveStructure.type];

        if(isNullOrUndefined(modelInstance)) {
          resolve(modelInstanceFollowsRestriction(primitiveStructure.restriction));
          return;
        }

        if(typeof modelInstance != primitiveType) {
          throw new InvalidModelError(
            "Model has incorrect type", errorCodes.modelHasInvalidTypeStructure
          );
        }

        resolve(modelInstanceFollowsRestriction(primitiveStructure.restriction));
        return;

      // Array Type
      case structures.typeCategory.array:
        const arrayStructure = typeStructure as structures.arrayStructure;

        if(isNullOrUndefined(modelInstance)) {
          resolve(modelInstanceFollowsRestriction(arrayStructure.restriction));
          return;
        }

        if(!Array.isArray(modelInstance)) {
          throw new InvalidModelError(
            "Model has incorrect type", errorCodes.modelHasInvalidTypeStructure
          );
        }

        resolve(
          Bluebird.map(
            modelInstance,
            (arrayElement: any) => {
              return validModel(arrayElement, arrayStructure.type);
            }
          )
          .then(() => {
            return modelInstanceFollowsRestriction(arrayStructure.restriction);
          })
        );
        return;

      // Union of Types
      case structures.typeCategory.union:
        const unionStructure = typeStructure as structures.unionStructure;

        resolve(
          Bluebird.any(
            R.map((typeStructure: structures.typeStructure) => {
              return validModel(modelInstance, typeStructure);
            }, unionStructure.types)
          ).catch(Bluebird.AggregateError, (errors) => {
            // If all the errors are `modelHasInvalidTypeStructure` then we can
            // just pass that along. If all are `modelHasInvalidTypeStructure`
            // then we can just pass the custom error along as that was likely
            // the part of the union being targetted. If multiple custom errors
            // are generated (rare case), then all custom errors are passed
            const nonModelHasInvalidTypeStructureErrorCodes: InvalidModelError[] = [];
            errors.forEach((error: InvalidModelError) => {
              if((error as InvalidModelError).errorCode != errorCodes.modelHasInvalidTypeStructure) {
                nonModelHasInvalidTypeStructureErrorCodes.push(error);
              }
            });

            switch(nonModelHasInvalidTypeStructureErrorCodes.length) {
              case 0:
                throw new InvalidModelError(
                  "Model has incorrect type", errorCodes.modelHasInvalidTypeStructure
                );
              case 1:
                throw nonModelHasInvalidTypeStructureErrorCodes[0];
              default:
                throw new InvalidModelUnionTypeError(
                  "Multiple Union non-type-structure errors",
                  nonModelHasInvalidTypeStructureErrorCodes
                );
            }
          })
        );
        return;

      // Interface Type (object)
      case structures.typeCategory.interface:
        const interfaceStructure = typeStructure as structures.interfaceStructure;

        if(isNullOrUndefined(modelInstance)) {
          resolve(modelInstanceFollowsRestriction(interfaceStructure.restriction));
          return;
        }

        if(typeof modelInstance != "object") {
          throw new InvalidModelError(
            "Model has incorrect type", errorCodes.modelHasInvalidTypeStructure
          );
        }

        // Unspecified properties on `modeInstance` not allowed.
        for(let modelProperty in modelInstance) {
          if(!interfaceStructure.properties[modelProperty]) {
            throw new InvalidModelError(
              "Model has incorrect type", errorCodes.modelHasInvalidTypeStructure
            );
          }
        }

        // Verify each expected property (from structure) is valid on
        // `modelInstance`.
        resolve(
          Bluebird.map(
            Object.keys(interfaceStructure.properties),
            (key: string) => {
              return validModel(modelInstance[key], interfaceStructure.properties[key]);
            }
          )
          .then(() => {
            return modelInstanceFollowsRestriction(interfaceStructure.restriction);
          })
        )
        return;
    }
  });
}
