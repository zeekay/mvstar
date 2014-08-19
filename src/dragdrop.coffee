{preventDefault} = require './event'

Draggable = (view) ->
  view.on
    dragenter: preventDefault()
    dragleave: preventDefault()
    dragover:  preventDefault()
    dragstart: (e) ->
      # store id on element, so it can be referenced from dropzone
      e.dataTransfer.setData 'application/x-id', @id

    render: (el) ->
      # Ensure element is draggable
      el.draggable = true

Droppable = (view) ->
  view.on
    dragenter: preventDefault()
    dragend:   preventDefault()
    dragover:  preventDefault (e) ->
      e.dataTransfer.dropEffect = 'move'
    drop: preventDefault (e) ->
      id = e.dataTransfer.getData 'application/x-id'
      dropped = document.getElementById id
      @emit 'dropped', e, dropped

module.exports =
  Draggable: Draggable
  Droppable: Droppable
