mvstar = require '../lib'

describe 'View', ->
  view = null

  describe 'View#render (template)', ->
    view = null

    before (done) ->
      (require 'jsdom').env '''
      <script id="html-template" type="text/javascript">
      <h1>Title</h1>
      </script>
      ''', (err, window) ->
        throw err if err?
        global.$ = (require 'jquery') window

        class View extends mvstar.View
          template: '#html-template'

        view = new View()

        done()

    it 'should use template in DOM', ->
      view.render()
      view.el.html().should.not.be.null
      view.el.html().should.equal 'Title'

  describe 'View#render (template)', ->
    view = null

    before (done) ->
      (require 'jsdom').env '', (err, window) ->
        throw err if err?
        global.$ = (require 'jquery') window
        done()

    it 'should render string template', ->
      class View extends mvstar.View
        html: '''
              <h1>Title</h1>
              '''

      view = new View()
      view.render()

      view.el.html().should.not.be.null
      view.el.html().should.equal 'Title'
