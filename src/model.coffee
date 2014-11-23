class Model
  defaults:   {}
  validators: {}
  transforms: {}

  constructor: (state) ->
    @state = {}

    @setDefaults()

    for prop, value of state
      @state[prop] = value

    @transform()

  setDefaults: ->
    for prop, value of @defaults
      @state[prop] = value
    @

  validate: (prop, value) ->
    unless prop?
      return @validateAll()

    value ?= @state[prop]

    validators = @validators[prop]
    unless Array.isArray validators
      validators = [validators]

    for validator in validators
      unless validator.call @, prop, value
        return false
    true

  validateAll: ->
    for prop of @validators
      unless @validate prop
        return false
    true

  transform: (prop, value) ->
    unless prop?
      return @transformAll()

    transforms = @transforms[prop]
    unless Array.isArray transforms
      transforms = [transforms]

    if value?
      for transform in transforms
        value = transform.call @, prop, value
      value
    else
      for transform in transforms
        @state[prop] = transform.call @, prop, value
      @state[prop]

  transformAll: ->
    for prop of @transforms
      @transform prop
    @

module.exports = Model
