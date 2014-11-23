Model        = require './model'
EventEmitter = require './event-emitter'

class ModelEmitter extends Model
  constructor: (state) ->
    super

    @emitter = new EventEmitter()
    @emitter.debug = true if @debug

  on: ->
    @emitter.on.apply @, arguments

  off: ->
    @emitter.off.apply @, arguments

  emit: ->
    @emitter.emit.apply @, arguments
