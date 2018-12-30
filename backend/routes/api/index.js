const router = require('express').Router();

router.use('/', require('./users'));

// Return Mongoose validation errors to the client.
router.use(function(err, req, res, next){
  if(err.name === 'ValidationError'){
    return res.status(422).json({
      errors: Object.keys(err.errors).reduce(function(errors, key){
        // Set errors so they can be printed on the client.
        errors[key] = `${key} ${err.errors[key].message}`;

        return errors;
      }, {})
    });
  }

  return next(err);
});

module.exports = router;
