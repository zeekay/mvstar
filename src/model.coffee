class Model
  defaults:   {}
  validators: {}
  transforms: {}

  constructor: (state = {}) ->
    @state = {}

    @setDefaults()
    @transform()

    for prop, value of state
      @set prop, value

  setDefaults: ->
    for prop, value of @defaults
      @state[prop] = value
    @

  validate: (prop, value) ->
    unless prop?
      return @validateAll()

    unless (validator = @validators[prop])?
      return true

    value ?= @state[prop]

    validator.call @, value, prop

  validateAll: ->
    for prop of @validators
      unless @validate prop
        return false
    true

  transform: (prop, value) ->
    unless prop?
      return @transformAll()

    unless (transform = @transforms[prop])?
      return value

    if value?
      transform.call @, value, prop
    else
      @state[prop] = transform.call @, @state[prop], prop

  transformAll: ->
    for prop of @transforms
      @transform prop
    @

  # Get property
  get: (prop) ->
    @state[prop]

  # Set property to `value`
  set: (prop, value) ->
    unless @validate prop, value
      return false
    @state[prop] = @transform prop, value
    return true

  # Remove property from model
  remove: (prop, value) ->
    @state[prop] = undefined

  # Update several properties at once
  update: (state) ->
    ret = true
    for prop, value of state
      unless @set prop, value
        ret = false
    return ret

module.exports = Model
