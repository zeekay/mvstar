{Model, View}          = require 'mvstar'
{Draggable, Droppable} = require 'mvstar/lib/dragdrop'

Img = Model
  defaults:
    src:    ''
    width:  0
    height: 0
  validators:
    src: (src) -> src != ''

ImgView = Draggable View
  model: Img
  # Cheap to completely mutate on change, no need to describe how to render
  # each model property.
  render: ->
    @el[prop] = @model[prop] for prop in @model
  template: -> '<img>'

Dropzone = Model
  defaults:
    drops: []

DropzoneView = Droppable View
  model: Dropzone

  # Render can either be a single function (when it's inexpensive) or a complex
  # object describing initial state and all state changes of each property
  render:
    # Initial state.
    drops: (drops) ->
      for d in drops
        @el.appendChild d.el

    # Various state changes
    'drops:add': (drop) ->
      @el.appendChild d.el

    'drops:remove': (drop) ->
      @el.removeChild d.el

  # Events update the model, but should not update the DOM (render does that).
  events:
    dropped: (event, dropped) ->
      @model.dropped.push dropped

  template: -> '<div></div>'
