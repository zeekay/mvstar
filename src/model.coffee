class Model
  defaults:   {}
  validators: {}
  transforms: {}

  constructor: (state = {}) ->
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

    validator = @validators[prop]
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

    tranform = @transforms[prop]

    if value?
      transform.call @, value, prop
    else
      @state[prop] = transform.call @, @state[prop], prop

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
