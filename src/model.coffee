class Model
  constructor: (obj) ->
    unless @ instanceof Model
      return new Model obj
  validates: (prop, fn) ->
    @validators[prop] = fn
  validate: ->
    for prop, fn of @validators
      unless fn @[prop]
        return false
    true

module.exports =
  Model: (options) ->
    class _Model extends Model
    for k,v of options
      _Model::[k] = v
    _Model
