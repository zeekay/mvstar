class View
  el:         null
  bindings:   {}
  computed:   {}
  events:     {}
  formatters: {}
  watching:   {}

  mutators: require './mutators'

  constructor: (opts = {}) ->
    @el       ?= opts.el
    @id        = @_nextId @constructor.name
    @state     = opts.state ? {}
    @_events   = {}
    @_targets  = {}
    @_watchers = {}

    # Generate list of watchers per name
    for watcher, watched in @watching
      unless Array.isArray watched
        watched = [watched]

      for name in watched
        @_watchers[name] ?= []
        @_watchers[name].push watcher

    # Get or create element based on template/opts
    @el = @$el = @_getEl opts

    # find all elements in DOM.
    @_cacheTargets()

  # Set element for this view instance
  _getEl: (opts) ->
    # You can get an element for the view multiple ways:
    # 1. Use `opts.template` to create a new element.
    # 2. Use `opts.html` to create a new element.
    # 3. Pass it in as `opts.$el`
    # 4. Find it in DOM using @el selector.

    # Use opts.$el if provided
    return opts.$el if opts.$el

    # Generate template selector to create DOM
    return $($(@template).html()) if @template

    # Use string template
    return $(@html) if @html

    # Use selector defined in class
    return $(@el)

  # Get incrementally increasing ids.
  _nextId: do ->
    counter = 0
    (prefix) ->
      id = ++counter + ''
      prefix ? prefix + id

  # Find and cache binding targets.
  _cacheTargets: ->
    for name, targets of @bindings
      unless Array.isArray targets
        targets = [targets]

      # For each target cache based on selector
      for target in targets
        # only cache string-based selector targets
        if typeof target is 'string'
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
    # use attr-specific mutator, fall back to attr mutator
    mutator = @mutators[attr] ? @mutators.attr
    mutator @_targets[selector], attr, value
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

    # find formatter
    formatter = @formatters[name]

    # Update each target
    for target in targets
      if typeof target is 'string'
        @_renderSelector target, value, formatter
      else
        @_renderCallback target, value, name, formatter
    return

  # render a string selector binding
  _renderSelector: (target, value, formatter) ->
    [selector, attr] = @_splitTarget target

    # Format value and mutate DOM
    if formatter?
      value = formatter.call @, value, "#{selector} @#{attr}"

    @_mutateDom selector, attr, value

  # render a callback binding
  _renderCallback: (target, value, name, formatter) ->
    if formatter?
      value = formatter.call @, value, 'callback'
    target.call @, value, name

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
