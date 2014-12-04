ModelEmitter = require './model-emitter'
Route        = require './route'

class App extends ModelEmitter
  prefix: ''

  constructor: (state = {}) ->
    super
    @_routes = {}
    @views   = []

    for k,v of state
      @state[k] = v

  addRoute: (path, cb) ->
    unless (route = @_routes[path])?
      route = new Route path, prefix: @prefix

    route.callbacks ?= []
    route.callbacks.push cb

    @_routes[path] = route

  # setup routing
  setupRoutes: ->
    for k, v of @routes
      if Array.isArray v
        for cb in v
          @addRoute k, cb
      else
        @addRoute k, v
    null

  dispatchRoutes: ->
    for _, route of @_routes
      if route.regexp.test location.pathname
        for cb in route.callbacks
          cb()
    null

  route: ->
    @setupRoutes()
    @dispatchRoutes()

module.exports = App
