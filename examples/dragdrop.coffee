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
  # Cheap to completely mutate on change, no need to describe bindings, just
  # re-render entire view on any model changes.
  render: ->
    @el[prop] = @model[prop] for prop in @model
  template: -> '<img>'

Dropzone = Model
  defaults:
    drops: []

DropzoneView = Droppable View
  model: Dropzone
  # Expensive to re-render entire view, so we'll declare bindings to describe
  # how to re-render on model changes.
  render: ->
    for d in @model.drops
      @el.appendChild d.el

  bindings:
    # Various state changes
    'drops:add': (d) ->
      @el.appendChild d.el
    'drops:remove': (d) ->
      @el.removeChild d.el

  # Events update the model, but should not update the DOM, that should be left
  # to render/bindings.
  events:
    drop: (d) ->
      @addDrop d
    dragstart: (d) ->
      @removeDrop d

  # You should never mutate the DOM manually, just update the model and let
  # render/bindings do the work!
  removeDrop: (idx) ->
    @model.drops.pop idx
  addDrop: (d) ->
    @model.drops.push d

  template: -> '<div></div>'

# Create some dropzones
dropzone1 = DropzoneView
  drops: [
    ImgView src: 'image1.jpg',
    ImgView src: 'image2.jpg',
  ]
dropzone2 = DropzoneView()

# Render them
document.body.appendChild dropzone1.render().el
document.body.appendChild dropzone2.render().el

# Programmatically move a drop
drop = dropzone1.removeDrop()
dropzone2.addDrop drop
