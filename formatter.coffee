class Foo extends View
  bindings:
    count: '.counter @class'

  formatters:
    count: (v) ->
      count = @get 'count'

      if count != @get 'total'
        'bad'
      else
        ''
