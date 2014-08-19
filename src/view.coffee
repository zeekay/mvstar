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

  renderTemplate: (ctx) ->
    if @_cachedEl?
      # Clone node, rather than re-rendering template for each instance.
      @el = @_cachedEl.cloneNode true
      return @

    # Generate element template
    el = @template.call @

    # Coerce strings to HTML dom fragments
    if typeof el is 'string' or el instanceof String
      div = createElement 'div'
      div.insertAdjacentHTML 'afterbegin', el
      el = div.removeChild childNodes[0]

    # Cache on prototype so it can be reused
    @el = @::_cachedEl = el

    @

  render: (ctx) ->
    @renderTemplate ctx
    for prop, fn in @bindings
      if (value = @model[prop]?)
        fn.call @, value

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
