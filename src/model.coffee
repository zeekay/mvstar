prototype =
  initialize: (object) ->
    for k,v of @defaults
      @[k] = v

    for k,v of object
      @[k] = v
    @

  validates: (prop, fn) ->
    @validators[prop] = fn

  validate: ->
    for prop, fn of @validators
      unless fn @[prop]
        return false
    true

module.exports =
  Model: (options) ->
    Model = (object = {}) ->
      unless @ instanceof Model
        return new Model object

      @initialize object

    Model:: = Object.create prototype
    Model::constructor = Model

    for k,v of options
      Model::[k] = v

    Model
