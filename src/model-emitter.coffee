Model        = require './model'
EventEmitter = require './event-emitter'

class ModelEmitter extends Model
  constructor: (state = {}) ->
    @emitter = new EventEmitter()
    @emitter.debug = true if @debug
    super

  on: ->
    @emitter.on.apply @emitter, arguments

  off: ->
    @emitter.off.apply @emitter, arguments

  emit: ->
    @emitter.emit.apply @emitter, arguments

module.exports = ModelEmitter
