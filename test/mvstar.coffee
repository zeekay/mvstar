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

describe 'mvstar#Model', ->
  User = mvstar.Model
    defaults:
      age: 0
    validators:
      name: (name) -> name?

  it 'should set defaults for new instances', ->
    user = User name: 'Sam'
    user.age.should.eq 0

  it 'should validate instances', ->
    user = User()
    user.validate().should.eq false
    user = User name: 'Sam'
    user.validate().should.eq true

describe 'mvstar#View', ->
  View = mvstar.View
    template: -> '<div>'

  it 'should render templates', ->
    view = View()
    view.el.should.not.be.null
