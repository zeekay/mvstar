proto =
  validates: (prop, fn) ->
    @validators[prop] = fn
  validate: ->
    for prop, fn of @validators
      unless fn @[prop]
        return false
    true

module.exports =
  Model: (options) ->
    Model = (obj = {}) ->
      unless @ instanceof Model
        return new Model obj

      for k,v of @defaults
        @[k] = v

      for k,v of obj
        @[k] = v
      @

    Model:: = Object.create proto
    Model::constructor = Model

    for k,v of options
      Model::[k] = v

    Model
