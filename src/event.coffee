class Emitter
  constructor: (options = {}) ->
    @_handlers = {}
    @debug     = options.debug ? false

  addListener: (event, callback) ->
    @_handlers[event] ?= []
    @_handlers[event].push callback
    # return the index of the newly added handler
    @_handlers[event].length - 1

  removeListener: (event, index) ->
    # allow an error to be thrown if there are no
    # handlers defined
    @_handlers[event][index] = null

  on: ->
    @addListener.apply @, arguments

  off: ->
    @removeListener.apply @, arguments

  emit: (event, args...) ->
    handlers = @_handlers[event] or []
    for handler in handlers
      if handler?
        handler.apply @, args
    if @debug
      console.log.apply console, args

preventDefault = (fn = ->) ->
  ->
    event = arguments[0]
    event.preventDefault() if event.preventDefault?
    fn.apply @, arguments
    false

module.exports =
  Emitter:        Emitter
  preventDefault: preventDefault
