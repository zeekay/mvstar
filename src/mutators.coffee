# Set arbitrary attribute `attr` to `value`
mutateAttr = ($el, attr, value) ->
  $el.attr attr, value

# Set `checked` property
mutateChecked = ($el, attr, value) ->
  $el.prop 'checked', value

# Applies custom classes to element
mutateClass = ($el, attr, value) ->
  unless (classes = $el.data 'mvstar-original-classes')?
    # Cache original classes (prior to any of our mangling)
    classes = $el.attr 'class'
    $el.data 'mvstar-original-classes', classes

  # remove all classes
  $el.removeClass()

  # merge our new classes with any original style classes
  $el.addClass "#{classes} #{value}"

# set selectedIndex of selects
mutateIndex = ($el, attr, value) ->
  $el.prop 'selectedIndex', value

# Update text content of element
mutateText = ($el, attr, value) ->
  $el.text value

# Update value `attr` but also correctly handles selects.
mutateValue = ($el, attr, value) ->
  $el.val value

module.exports =
  attr:          mutateAttr
  checked:       mutateChecked
  class:         mutateClass
  index:         mutateIndex
  selectedIndex: mutateIndex
  text:          mutateText
  value:         mutateValue
