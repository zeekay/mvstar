mvstar = require '../lib'
should = require('chai').should()

describe 'mvstar#View', ->
  View = mvstar.View
    template: -> '<div>'

  it 'should render templates', ->
    view = View()
    view.el.should.not.be.null
