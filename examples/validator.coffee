Img = Model
  defaults:
    src:    ''
    width:  0
    height: 0
  validators:
    src: (src) -> src != ''

# equiv to...
validator = (Model) ->
  Model.validates
    src: (src) -> src != ''
  Model

Img = validator Img
