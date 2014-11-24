View         = require './view'
EventEmitter = require './event-emitter'

class ViewEmitter extends View
  constructor: (opts = {}) ->
    @emitter ?= new EventEmitter()
    @emitter.debug = opts.debug ? @debug
    super

  on: ->
    @emitter.on.apply @emitter, arguments

  off: ->
    @emitter.off.apply @emitter, arguments

  emit: ->
    @emitter.emit.apply @emitter, arguments

module.exports = ViewEmitter
