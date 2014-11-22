storeFn = (store, prop, fn) ->
  fns = store[prop]

  unless fns?
    store[store] = fn
    return store

  if Array.isArray fns
    fns.push fn
  else
    store[prop] = [fns, fn]

  return

class Model
  constructor: (state) ->
    @setDefaults()

    for k,v of state
      @[k] = v

    @transform()
    @

  defaults:   {}
  validators: {}
  transforms: {}

  setDefaults: ->
    for k,v of @defaults
      @[k] = v

  validates: (prop, fn) ->
    storeFn @validators, prop, fn
    @

  validate: ->
    for prop, fns of @validators
      unless Array.isArray fns
        fns = [fns]
      for fn in fns
        unless fn @[prop]
          return false
    true

  transforms: (prop, fn) ->
    storeFn @transforms, prop, fn
    @

  transform: ->
    for prop, fns of @transforms
      unless Array.isArray fns
        fns = [fns]
      for fn in fns
        @[prop] = fn prop
    @

module.exports = Model
