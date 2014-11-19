Route = require './route'

class App
  constructor: (state = {}) ->
    @state   = state
    @_routes = {}
    @views   = []

  # global setup
  setup: ->
    $.cookie.json = true
    @

  addRoute: (path, cb) ->
    unless (route = @_routes[path])?
      route = new Route path

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

  start: ->
    @setupRoutes()
    @dispatchRoutes()
    @

  get: (k) ->
    @state[k]

  set: (k, v) ->
    @state[k] = v

  delete: (k) ->
    delete @state[k]

module.exports = App
