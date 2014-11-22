mvstar = null
view = null

describe 'mvstar#View', ->
  before ->
    (require 'jsdom').jsdom()
    global.$ = require 'jquery'
    mvstar = require '../lib'

    class View extends mvstar.View
      html: '<div></div>'

    view = new View()

  it 'should render templates', ->
    view.el.should.not.be.null
