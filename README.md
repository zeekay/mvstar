# mvstar
MV★ framework. No fancy virtual DOM. Minimal bits needed for sensible
client-side applications. Declarative one-way databinding. Event emitters.
Simple routing. Computed properties. Completely explicit. No dependencies
outside of a [dollar](http://jquery.org) [library](http://zeptojs.com).

## Views
Views encapsulate bits of DOM. Generally like Backbone views but with
declarative one-way databinding.

```coffeescript
class LineItem extends View
  # Can reference a template tag in the DOM, which will be used to create new
  # view instances
  template: '#line-item-template'

  # Or alternately bind to existing element:
  # el: '#line-item'

  # Declare bindings from state -> selectors in DOM. You can use @ to target
  # specific attrs.
  bindings:
    img:  'img.thumbnail @src'
    sku:  'input.sku     @value'
    name: 'a.title'

  # Computed properties, generated from different bits of state.
  computed:
    desc: (color, size) -> [color, size]

  # Watch for changes, and recompute on changes.
  watching:
    desc: ['color', 'size']

  # Format state before rendering into DOM.
  formatters:
    desc: (v) ->
      if v.length > 1
        v.join ' / '
      else
        v.join ''

  # Bind to events.
  events:
    'change .quantity input': 'updateQuantity'
    'click .remove-item':     'removeItem'

  # You need to manually unbind events if you define any.
  removeItem: ->
    @unbind()
    @remove()

  # Handle change event
  updateQuantity: (e, el) ->
    # Get quantity, el refers to current target of event
    quantity = parseInt $(el).val(), 10

    # Update quantity on state bound to this view
    @set 'quantity', quantity

    false
```

## Events
Extend from `mvstar.EventEmitter` and wire up things with events.

```coffeescript
class Cart extends EventEmitter
  constructor: (@cart) ->
    super
    @cart    ?= {}
    @subtotal = 0
    @quantity = 0

  get: (sku) ->
    @cart[sku]

  # You must manually emit things you care about.
  add: (item) ->
    @emit 'add', item

    @quantity += item.quantity
    @subtotal += item.quantity * item.price

    if (@get item.sku)?
      @cart[item.sku].quantity += item.quantity
    else
      @cart[item.sku] = item

    @

  remove: (sku) ->
    @emit 'remove', @cart[sku]
    delete @cart[sku]
    @

  clear: ->
    @emit 'clear'
    @cart = {}
    @
```
