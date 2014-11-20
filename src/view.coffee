# returns incremental ids
nextId = do ->
  counter = 0
  (prefix) ->
    id = ++counter + ''
    prefix ? prefix + id

class View
  el:         null
  bindings:   {}
  computed:   {}
  events:     {}
  formatters: {}
  watching:   {}

  constructor: (opts = {}) ->
    @el ?= opts.el

    # You can get an element for the view multiple ways:
    # 1. Pass it in as $el
    # 2. Use a template to create a new element.
    # 3. Find it in DOM using @el selector.
    if opts.$el
      @$el = opts.$el
    else
      if @template
        @$el = $($(@template).html())
      else
        @$el = $(@el)

    @id         = nextId @constructor.name
    @state      = opts.state ? {}
    @_events    = {}
    @_targets = {}
    @_watchers = {}

    # Generate list of watchers per name
    for watcher, watched in @watching
      unless Array.isArray watched
        watched = [watched]

      for name in watched
        @_watchers[name] ?= []
        @_watchers[name].push watcher

    # find all elements in DOM.
    @_cacheTargets()

    @render() unless not opts.autoRender

  # Find and cache binding targets.
  _cacheTargets: ->
    for name, targets of @bindings
      unless Array.isArray targets
        targets = [targets]

      # For each target cache based on selector
      for target in targets
        [selector, attr] = @_splitTarget target

        unless @_targets[selector]?
          @_targets[selector] = @$el.find selector

  _computeComputed: (name) ->
    args = []
    for sources in @watching[name]
      unless Array.isArray sources
        sources = [sources]

      for src in sources
        args.push @state[src]

    value = @computed[name].apply @, args

  _mutateDom: (selector, attr, value) ->
    if attr == 'text'
      @_targets[selector].text value
    else
      @_targets[selector].attr attr, value
    return

  # This translates a state change to it's intended target(s).
  _renderBindings: (name, value) ->
    # Check if this is a computed property
    if @computed[name]?
      value = @_computeComputed name

    # Get list of targets for this binding name
    targets = @bindings[name]
    unless Array.isArray targets
      targets = [targets]

    # Update each target
    for target in targets
      [selector, attr] = @_splitTarget target

      # Format value and mutate DOM
      if (formatter = @formatters[name])?
        _value = formatter value, "#{selector} @#{attr}"
      else
        _value = value

      @_mutateDom selector, attr, _value

    return

  # Split event name / selector
  _splitEvent: (e) ->
    [event, selector...] = e.split /\s+/
    selector = selector.join ' '

    unless selector
      $el = @$el
      return [$el, event]

    # allow global event binding
    switch selector
      when 'document'
        $el = $(document)
      when 'window'
        $el = $(window)
      else
        $el = @$el.find selector

    [$el, event]

  # Split target selector + attr, if attr is none use text.
  _splitTarget: (target) ->
    if target.indexOf '@' != -1
      [selector, attr] = target.split /\s+@/
    else
      [selector, attr] = [target, null]

    unless attr?
      attr = 'text'

    [selector, attr]

  # Get value from state for name.
  get: (name) ->
    @state[name]

  # Set name to value.
  set: (name, value) ->
    @state[name] = value

    # Render our binding
    if @bindings[name]?
      @_renderBindings name, value

    # Force anything watching us to be recomputed
    if (watchers = @_watchers[name])?
      for watcher in watchers
        @_renderBindings watcher

  # Render current state according to bindings.
  render: (state) ->
    if state?
      # update state
      for k,v of state
        @set k, v
    else
      for name, targets of @bindings
        @_renderBindings name, @state[name]
    @

  # Bind an event to a callback
  bindEvent: (selector, callback) ->
    [$el, eventName] = @_splitEvent selector

    if typeof callback is 'string'
      callback = @[callback]

    $el.on "#{eventName}.#{@id}", (event) =>
      callback.call @, event, event.currentTarget
    @

  # Unbind callbacks from an event
  unbindEvent: (selector) ->
    [$el, eventName] = @_splitEvent selector
    $el.off "#{eventName}.#{@id}"
    @

  # Bind all events
  bind: ->
    for selector, callback of @events
      @bindEvent selector, callback
    @


  # Unbind all events
  unbind: ->
    for selector, callback of @events
      @unbindEvent selector, callback
    @

  # Remove this element from it's parent
  remove: ->
    @$el.remove()

module.exports = View
