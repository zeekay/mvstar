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
  map:
    src:    (@src)    ->
    height: (@height) ->
    width:  (@width)  ->
  template: ->
    '<img draggable="true">'

DropzoneView = Droppable View
  model: Dropzone
  map:
    dropped: (dropped) ->
      span = @querySelector '.dropped'
      span.innerHTML = dropped.join(', ')
  on:
    dropped: (event, dropped) ->
      @model.dropped.push dropped
      @appendChild dropped
  template: ->
    '''
    <div>
      <h1>
        Dropped: <span class="dropped"></span>
      </h1>
    </div>
    '''