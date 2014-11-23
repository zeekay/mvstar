class EventEmitter
  constructor: (opts) ->
    @debug         = opts.debug ? false
    @_listeners    = {}
    @_allListeners = []

  addListener: (event, callback) ->
    if event
      @_listeners[event] ?= []
      @_listeners[event].push callback
      # return the index of the newly added listener
      @_listeners[event].length - 1
    else
      @_allListeners.push callback
      @_allListeners.length - 1

  removeListener: (event, index) ->
    unless event
      return @removeAllListeners()

    if index?
      @_listeners[event][index] = null
    else
      @_listeners[event] = {}
    return

  removeAllListeners: ->
    @_listeners = {}
    return

  on: ->
    @addListener.apply @, arguments

  off: ->
    @removeListener.apply @, arguments

  emit: (event, args...) ->
    listeners = @_listeners[event] or []
    for listener in listeners
      if listener?
        listener.apply @, args

    args.unshift event

    for listener in @_allListeners
      listener.apply @, args

    if @debug
      console.log.apply console, args

module.exports = EventEmitter
