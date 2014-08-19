preventDefault = (fn = ->) ->
  ->
    event = arguments[0]
    event.preventDefault() if event.preventDefault?
    fn.apply @, arguments
    false

module.exports =
  preventDefault: preventDefault
