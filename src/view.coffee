proto =
  render: ->
  remove: ->

module.exports =
  View: (options) ->
    View = (obj = {}) ->
      unless @ instanceof View
        return new View obj

      if obj.constructor.name == 'Object' and @Model?
        @model = new @Model obj
      else
        @model = obj

    View:: = Object.create proto
    View::constructor = View

    for k,v of options
      View::[k] = v

    View
