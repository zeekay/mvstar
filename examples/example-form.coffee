{Model, View} = require 'mvstar'

Form = Model
  defaults:
    inputs: []

Input = Model
  defaults:
    name:  ''
    value: ''
  validators:
    name: (name) -> name != ''

FormView = View
  model: Form
  map:
    'inputs': (inputs) ->
      @appendChild input for input in inputs
    'inputs:add': (inputs, added) ->
      @appendChild added
    'inputs:delete': (inputs, deleted) ->
      @removeChild deleted
  template: -> '<form></form>'

InputView = View
  model: Input
  map:
    name:  (@name)  ->
    value: (@value) ->
  template: -> '<input></input>'

# Usage
form = FormView
  inputs: [
    InputView name: 'bar', value: 1
    InputView name: 'baz', value: 2
  ]