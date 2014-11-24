View         = require './view'
EventEmitter = require './event-emitter'

class ViewEmitter extends View
  constructor: (opts = {}) ->
    @emitter = new EventEmitter()
    @emitter.debug = true if @debug
    super

  on: ->
    @emitter.on.apply @, arguments

  off: ->
    @emitter.off.apply @, arguments

  emit: ->
    @emitter.emit.apply @, arguments

module.exports = ViewEmitter
