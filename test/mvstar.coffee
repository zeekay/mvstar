mvstar = require '../lib'
should = require('chai').should()

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
