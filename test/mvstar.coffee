mvstar = require '../lib'
should = require('chai').should()

Model = mvstar.Model
View = mvstar.View

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
  pull:
    'inputs': (inputs) ->
      @el.appendChild input.el for input in inputs
    'inputs:add': (inputs, added) ->
      @el.appendChild added
    'inputs:delete': (inputs, deleted) ->
      @el.removeChild deleted
  template: -> '<form></form>'

InputView = View
  model: Input
  pull:
    name:  (name)  -> @el.name  = name
    value: (value) -> @el.value = value
  push:
    'name:changed':  (name)  -> @model.name  = name
    'value:changed': (value) -> @model.value = value
  template: -> '<input></input>'

# Usage
form = FormView
  inputs: [
    InputView name: 'bar', value: 1
    InputView name: 'baz', value: 2
  ]

form.render()
document.body.appendChild form.el

describe 'mvstar', ->
  it 'should expose Model and View constructors', ->
    mvstar.View.should.exist
    mvstar.Model.should.exist