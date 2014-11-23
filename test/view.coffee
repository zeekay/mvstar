mvstar = require '../lib'

describe 'View', ->
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

  describe 'View#render (string)', ->
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

    it 'should render string template', ->
      view.render()

      view.el.html().should.not.be.null
      view.el.html().should.equal 'Title'

  describe 'View#bindings', ->
    view = null

    before (done) ->
      (require 'jsdom').env '', (err, window) ->
        throw err if err?
        global.$ = (require 'jquery') window

        class View extends mvstar.View
          html: '''
                <div>
                  <span id="text"></span>
                  <span class="text"></span>
                  <img id="img">
                </div>
                '''

          bindings:
            textId:    'span#text'
            textClass: 'span.text'
            src:       'img#img @src'

        view = new View()
        done()

    it 'should be used to update DOM declaratively', ->
      view.render()
      view.set 'textId', 'foo'
      view.set 'textClass', 'bar'
      view.set 'src', 'www.baz.com'
      view.el.html().should.contain '<span id="text">foo</span>'
      view.el.html().should.contain '<span class="text">bar</span>'
      view.el.html().should.contain '<img id="img" src="www.baz.com">'
