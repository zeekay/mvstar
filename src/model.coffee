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
      unless validator.call @, value, prop
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
        value = transform.call @, value, prop
      value
    else
      for transform in transforms
        @state[prop] = transform.call @, value, prop
      @state[prop]

  transformAll: ->
    for prop of @transforms
      @transform prop
    @

  get: (prop) ->
    @state[prop]

  set: (prop, value) ->
    unless @validate prop, value
      return false

    @state[prop] = @transform prop, value

module.exports = Model
