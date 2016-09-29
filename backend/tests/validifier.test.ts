/// <reference path="../typings_manual/index.d.ts" />

import assert from 'assert';
import Bluebird from 'bluebird';
import R from "ramda";

import { validPhone, validEmail, validPassword, validMongoID,
  validModel } from '../src/validifier';
import { structures, errorCodes } from '../src/types';
import { InvalidModelError } from '../src/errors';
import { assertPromiseDoesntError, assertPromiseDoesError,
  assertPromiseErrorsWithCode } from './util';
import { isNullOrUndefined } from '../src/util';


describe('Validifier', function() {

  describe('#validPhone', function() {

    it('should return false if the email is undefined', function() {
      assert.equal(false, validPhone(undefined));
    });

    it('should return false if the email is null', function() {
      assert.equal(false, validPhone(null));
    });

    it('should return false if the phone number contains a char', function() {
      assert.equal(false, validPhone("604343a232"));
    });

    it('should return false if the phone number is 1 char', function() {
      assert.equal(false, validPhone("1"));
    });

    it('should return true if a valid phone number is passed', function() {
      const validPhoneNumbers = ["6049822922", "23222", "123456789012345"];

      R.map((validPhoneNumber) => {
        assert.equal(true, validPhone(validPhoneNumber));
      }, validPhoneNumbers);
    });

    it('should return false if a phone number is longer than 15 chars', function() {
      assert.equal(false, validPhone("1234567890123456"));
    });
  });

  describe('#validEmail', function() {

    it('should return false if the email is undefined', function() {
      assert.equal(false, validEmail(undefined));
    });

    it('should return false if the email is null', function() {
      assert.equal(false, validEmail(null));
    });

    it('should return false if the email has no @', function() {
      const invalidEmails = ["asdf", "asdf.gmail.com", "asdfATgmail.com"];

      R.map((email) => {
        assert.equal(false, validEmail(email));
      }, invalidEmails);
    });

    it('should return false if the email ends with an @', function() {
      const invalidEmail = "bla@";

      assert.equal(false, validEmail(invalidEmail));
    });

    it('should return false if the email starts with an @', function() {
      const invalidEmail = "@gmail.com";

      assert.equal(false, validEmail(invalidEmail));
    });

    it('should return true for valid emails', function() {
      const validEmails = ["bla@gmail.com", "bilbo@yahoo.ca", "what_what@b.ca"];

      R.map((email) => {
        assert.equal(true, validEmail(email));
      }, validEmails);
    });
  });

  describe('#validPassword', function() {

    it('should return false if the password is undefined', function() {
      assert.equal(false, validPassword(undefined));
    });

    it('should return false if the password is null', function() {
      assert.equal(false, validPassword(null));
    });

    it('should return false if the password is <= 6 chars', function() {
      assert.equal(false, validPassword("123456"));
    });
  });

  describe('#validMongoID', function() {

    it('should return false if the ID is undefined', function() {
      assert.equal(false, validMongoID(undefined));
    });

    it('should return false if the ID is null', function() {
      assert.equal(false, validMongoID(null));
    });

    it('should return false if the ID is not 24 hex chars', function() {
      const invalidMongoIDs = ["23", "12345678901234567890123-", "12345678901234567890123G"];

      R.map((invalidMongoID) => {
        assert.equal(false, validMongoID(invalidMongoID));
      }, invalidMongoIDs);
    });

    it('should return true if the ID is 24 hex chars ', function() {
      const validMongoIDs = ["123456789012345678901234", "12a456F890a2345d78901234"];

      R.map((aValidMongoID) => {
        assert.equal(true, validMongoID(aValidMongoID));
      }, validMongoIDs);
    });
  });

  describe('#validModel', function() {

    const stringType: structures.primitiveStructure = {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string
    };

    const stringTypeWithRestriction: structures.primitiveStructure = {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (theString: string) => {
        if(isNullOrUndefined(theString)) {
          // Reject with random errorCode
          return Promise.reject(new InvalidModelError(
            "String must not be null or undefined", errorCodes.internalError
          ));
        }

        if(theString.length < 5) {
          // Reject with random errorCode
          return Promise.reject(new InvalidModelError(
            "String must be at least 5 chars", errorCodes.internalError
          ));
        }
      }
    }

    const booleanTypeWithAsyncRestriction: structures.primitiveStructure = {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.boolean,
      restriction: (booleanValue: boolean) => {
        return new Promise((resolve, reject) => {
          if(booleanValue) {
            reject(new InvalidModelError('Some error message...', errorCodes.internalError));
            return;
          }

          resolve();
        });
      }
    }

    const stringTypeWithRestrictionUnionStringTypeWithRestriction: structures.unionStructure = {
      typeCategory: structures.typeCategory.union,
      types: [stringTypeWithRestriction, stringTypeWithRestriction]
    };

    const numberType: structures.primitiveStructure = {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.number
    };

    const arrayOfStringType: structures.arrayStructure = {
      typeCategory: structures.typeCategory.array,
      type: stringType
    };

    const shallowInterfaceType: structures.interfaceStructure = {
      typeCategory: structures.typeCategory.interface,
      properties: {
        someNumber: numberType,
        someString: stringType,
        someArrayOfString: arrayOfStringType
      }
    };

    // Force the `someNumber` and `someString` to be equal (eg. "5" and 5).
    const shallowInterfaceTypeWithRestrictions: structures.interfaceStructure = {
      typeCategory: structures.typeCategory.interface,
      properties: {
        someNumber: numberType,
        someString: stringType
      },
      restriction: (shallowInterface: {someNumber: number, someString: string}) => {
        if(!isNullOrUndefined(shallowInterface.someNumber) &&
           !isNullOrUndefined(shallowInterface.someString)) {

          if((parseInt(shallowInterface.someString) != shallowInterface.someNumber)) {
            // random error code, but meaningful message for test output.
            return Promise.reject(new InvalidModelError(
              "The someNumber and someString properties must be the same number",
              errorCodes.internalError
            ));
          }
        }
      }
    }

    const arrayOfShallowInterface: structures.arrayStructure = {
      typeCategory: structures.typeCategory.array,
      type: shallowInterfaceType
    };

    const stringUnionNumberType: structures.unionStructure = {
      typeCategory: structures.typeCategory.union,
      types: [
        stringType,
        numberType
      ]
    };

    const stringTypeWithRestrictionUnionNumber = {
      typeCategory: structures.typeCategory.union,
      types: [
        stringTypeWithRestriction,
        numberType
      ]
    };

    const shallowInterfaceTypeObject = {
      someNumber: 5,
      someString: "asdf",
      someArrayOfString: ["asdf", "asdf"]
    };

    const deepInterfaceType = {
      typeCategory: structures.typeCategory.interface,
      properties: {
        subInterface: shallowInterfaceType,
        otherSubInterface: {
          typeCategory: structures.typeCategory.interface,
          properties: {
            someNumber: numberType,
            someString: stringType,
            subInterface: shallowInterfaceType
          }
        },
        someNumber: numberType,
        someArrayOfString: arrayOfStringType
      }
    };

    const deepInterfaceTypeObject = {
      subInterface: shallowInterfaceTypeObject,
      otherSubInterface: {
        someNumber: 5,
        someString: "23222",
        subInterface: shallowInterfaceTypeObject
      },
      someNumber: 5,
      someArrayOfString: ["asdf"]
    };

    it('should error on an invalid primitive type', function(done) {
      assertPromiseDoesError(validModel(5, stringType), done);
    });

    it('should allow a valid primtive type', function(done) {
      assertPromiseDoesntError(validModel("5", stringType), done);
    });

    it('should error on an invalid array of primitives', function(done) {
      assertPromiseDoesError(validModel(["23", "2322", 5], arrayOfStringType), done);
    });

    it('should allow a valid array of primitives', function(done) {
      assertPromiseDoesntError(validModel(["23", "2322", "5"], arrayOfStringType), done);
    });

    it('should allow undefined or null as valid types', function(done) {
      assertPromiseDoesntError(Bluebird.all([
        validModel(undefined, numberType),
        validModel(null, numberType),
        validModel(undefined, arrayOfStringType),
        validModel(null, arrayOfStringType),
        validModel(undefined, shallowInterfaceType),
        validModel(null, shallowInterfaceType),
        validModel(undefined, stringUnionNumberType),
        validModel(null, stringUnionNumberType),
      ]), done);
    });

    it('should allow a valid shallow interface', function(done) {
      assertPromiseDoesntError(
        validModel(shallowInterfaceTypeObject, shallowInterfaceType),
        done
      );
    });

    it('should error on an invalid shallow interface', function(done) {
      assertPromiseDoesError(Bluebird.all([
        validModel(
          {
            someNumber: 5,
            someString: "asdf",
            someArrayOfString: ["asdf", "asdf", 4]
          },
          shallowInterfaceType
        ),
        validModel(
          {
            someNumber: 5,
            someString: "asdf",
            someArrayOfString: ["asdf"],
            thisPropertyShouldntBeHere: 5
          },
          shallowInterfaceType
        )
      ]), done);
    });

    it('should allow a valid union of primitives', function(done) {
      assertPromiseDoesntError(Bluebird.all([
        validModel(5, stringUnionNumberType),
        validModel("string", stringUnionNumberType)
      ]), done);
    });

    it('should error on an invalid union of primitives', function(done) {
      assertPromiseDoesError(Bluebird.all([
        validModel({}, stringUnionNumberType),
        validModel([], stringUnionNumberType)
      ]), done);
    });

    it('should allow an empty array for an array of any type', function(done) {
      assertPromiseDoesntError(Bluebird.all([
        validModel([], arrayOfStringType),
        validModel([], arrayOfShallowInterface)
      ]), done);
    });

    it('should allow a valid deep interface', function(done) {
      assertPromiseDoesntError(
        validModel(deepInterfaceTypeObject, deepInterfaceType),
        done
      );
    });

    it('should error on an invalid deep interface', function(done) {
      assertPromiseDoesError(
        validModel({
          subInterface: shallowInterfaceTypeObject,
          otherSubInterface: {
            someNumber: "thisShouldBeANumber",
            someString: "23222",
            subInterface: shallowInterfaceTypeObject
          },
          someNumber: 5,
          someArrayOfString: ["asdf"]
        }, deepInterfaceType),
        done
      );
    });

    it('should allow a valid primitive type that also passes the restriction', function(done) {
      assertPromiseDoesntError(
        validModel("asdfasd", stringTypeWithRestriction),
        done
      );
    });

    it('should error on a valid primitive type that does not pass the restriction', function(done) {
      assertPromiseDoesError(
        validModel("asdf", stringTypeWithRestriction),
        done
      );
    });

    it('should error on a valid shallow interface type that does not pass the interface restriction', function(done) {
      assertPromiseDoesError(
        validModel({
          someNumber: 5,
          someString: "6"
        }, shallowInterfaceTypeWithRestrictions),
        done
      );
    });

    it('should allow a valid shalow interface type that does pass the interface restriction', function(done) {
      assertPromiseDoesntError(
        validModel({
          someNumber: 5,
          someString: "5"
        }, shallowInterfaceTypeWithRestrictions),
        done
      );
    });

    it(`should throw an error with code modelHasInvalidTypeStructure if all
        parts of the union throw a modelHasInvalidTypeStructure`, function(done) {
      assertPromiseErrorsWithCode(
        validModel([], stringUnionNumberType),
        errorCodes.modelHasInvalidTypeStructure,
        done
      );
    });

    it(`should throw an error with code of custom error if a single restrction
        from the union throws an error`, function(done) {
      assertPromiseErrorsWithCode(
        validModel("asdf", stringTypeWithRestrictionUnionNumber),
        errorCodes.internalError,
        done
      );
    });

    it(`should throw an error with errorCode modelUnionTypeHasMultipleErrors if
        multiple restrictions are broken in the union`, function(done) {
      assertPromiseErrorsWithCode(
        validModel("asdf", stringTypeWithRestrictionUnionStringTypeWithRestriction),
        errorCodes.modelUnionTypeHasMultipleErrors,
        done
      );
    });

    it('should error if valid type does not pass async restriction', function(done) {
      assertPromiseDoesError(
        validModel(true, booleanTypeWithAsyncRestriction),
        done
      );
    });

    it('should allow a valid type that passes async restriction', function(done) {
      assertPromiseDoesntError(
        validModel(false, booleanTypeWithAsyncRestriction),
        done
      );
    });
  });
});
