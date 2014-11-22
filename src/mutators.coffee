module.exports =
  # Applies custom classes to element
  class: ($el, attr, value) ->
    unless (classes = $el.data 'mvstar-original-classes')?
      # Cache original classes (prior to any of our mangling)
      classes = $el.attr 'class'
      $el.data 'mvstar-original-classes', classes

    # remove all classes
    $el.removeClass()

    # merge our new classes with any original style classes
    $el.addClass "#{classes} #{value}"

  # Update text content of element
  text: ($el, attr, value) ->
    $el.text value

  # Update any `attr` of element to `value`
  attr: ($el, attr, value) ->
    $el.attr attr, value
