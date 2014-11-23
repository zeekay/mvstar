mvstar = require '../lib'

describe 'mvstar#View', ->
  view = null

  before (done) ->
    (require 'jsdom').env '', (err, window) ->
      throw err if err?

      global.$ = (require 'jquery') window

      class View extends mvstar.View
        html: '''
              <h1>Title</h1>
              '''

      view = new View()
      done()

  it 'should render templates', ->
    view.render()

    view.el.html().should.not.be.null
    view.el.html().should.equal 'Title'
