View = require 'mvstar/lib/view'

formatCurrency = (v) -> v

class LineItemView extends View
  template: '#line-item-template'

  bindings:
    img:        'img.thumbnail   @src'
    sku:        'input.sku       @value'
    slug:       'input.slug      @value'
    name:       'a.title'
    desc:       'div.desc'
    price:      '.price span'
    quantity:   '.quantity input @value'
    index:     ['input.sku       @name'
                'input.slug      @name'
                '.quantity input @name']

  computed:
    desc: (color, size) -> [color, size]

  watching:
    desc: ['color', 'size']

  formatters:
    desc: (v) ->
      if v.length > 1
        v.join ' / '
      else
        v.join ''

    index: (v, selector) ->
      switch selector
        when 'input.sku @name'
          "Order.Items.#{v}.Variant.SKU"
        when 'input.slug @name'
          "Order.Items.#{v}.Product.Slug"
        when '.quantity input @name'
          "Order.Items.#{v}.Quantity"

    price: (v) ->
      formatCurrency v

  events:
    # Dismiss on click, escape, and scroll
    'change .quantity input': 'updateQuantity'

    # Prevent user pressing enter
    'keypress input,select': (e) ->
      if e.keyCode isnt 13
        true
      else
        @updateQuantity(e)
        false

    # Handle lineItem removals
    'click .remove-item': ->
      cart = app.get('cart')
      cart.remove(@state.sku)
      @destroy()

  updateQuantity: (event, el) ->
    # Get quantity
    quantity = parseInt($(el).val(), 10)

    # Prevent less than one quantity
    if quantity < 1 || isNaN quantity
      quantity = 1

    # Update quantity
    @set 'quantity', quantity

    # Update line item
    cart = app.get('cart')
    cart.set(@state.sku, @state)

  destroy: ->
    @unbind()
    @$el.animate {opacity: "toggle"}, 500, 'swing', => @$el.remove()

module.exports = LineItemView
