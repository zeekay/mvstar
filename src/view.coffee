observe = require './observe'

prototype =
  autoRender: true

  initialize: (object) ->
    if object.constructor.name == 'Object' and @Model?
      @model = new @Model object
    else
      @model = object

    observe @model, @bindings, @

    if @autoRender
      @render object

  render: (ctx) ->
    @el = @template.apply @, ctx
    @

  remove: ->
    parent = @el.parentNode
    parent.removeChild @el if parent

  template: -> '<div></div>'

module.exports =
  View: (options) ->
    View = (object = {}) ->
      unless @ instanceof View
        return new View object

      @initialize object

    View:: = Object.create prototype
    View::constructor = View

    for k,v of options
      View::[k] = v

    View
