class EventEmitter
  constructor: ->
    @_dollar = $(@)

  emit: (event, data...) ->
    @_dollar.trigger event, data

  once: (event, callback) ->
    @_dollar.one event, (event, data...) =>
      callback.apply @, data

  on: (event, callback) ->
    @_dollar.bind event, (event, data...) =>
      callback.apply @, data

  off: (event, callback) ->
    @_dollar.unbind event, callback

module.exports = EventEmitter
