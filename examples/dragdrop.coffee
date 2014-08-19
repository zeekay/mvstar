{Model, View}          = require 'mvstar'
{Draggable, Droppable} = require './dragdrop'

Img = Model
  defaults:
    src:    ''
    width:  0
    height: 0
  validators:
    src: (src) -> src != ''

Dropzone = Model
  defaults:
    dropped: []

ImgView = Draggable View
  model: Img
  bindings:
    pull:
      src:    (src)    -> @el.src    = src
      height: (height) -> @el.height = height
      width:  (width)  -> @el.width  = width
  template: -> '<img>'

DropzoneView = Droppable View
  model: Dropzone
  bindings:
    pull:
      dropped: (dropped) ->
        span = @querySelector '.dropped'
        span.innerHTML = (d.el for d in dropped).join(', ')
    push:
      dropped: (event, dropped) ->
        @model.dropped.push dropped
        @el.appendChild dropped
  template: ->
    '''
    <div>
      <h1>
        Dropped: <span class="dropped"></span>
      </h1>
    </div>
    '''
