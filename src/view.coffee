class View
  constructor: (obj) ->
    unless @ instanceof View
      return new View obj

    if obj.constructor.name == 'Object' and @Model?
      @model = new @Model obj
    else
      @model = obj

module.exports =
  View: (options) ->
    class _View extends View
    for k,v of options
      _View::[k] = v
    _View
