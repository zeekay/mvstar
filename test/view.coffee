mvstar = require '../lib'

describe 'View', ->
  describe '#render (template)', ->
    html = null

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
        view.render()
        html = view.el.html()
        done()

    it 'should use template in DOM', ->
      html.should.not.be.null
      html.should.equal 'Title'

  describe '#render (string)', ->
    html = null

    before ->
      class View extends mvstar.View
        html: '''
              <h1>Title</h1>
              '''

      view = new View()
      view.render()
      html = view.el.html()

    it 'should render string template', ->

      html.should.not.be.null
      html.should.equal 'Title'

  describe '#bindings', ->
    html = null

    before ->
      class View extends mvstar.View
        html: '''
              <div>
                <span id="text"></span>
                <span class="text"></span>
                <span class="formatted"></span>
                <img id="img">
                <span id="computed"></span>
                <span class="foo bar"></span>
              </div>
              '''

        bindings:
          textId:      'span#text'
          textClass:   'span.text'
          textFmted:   'span.formatted'
          src:         'img#img @src'
          ab:          'span#computed'
          classTarget: 'span.foo.bar @class'

        computed:
          ab: (a, b) -> [a, b]

        watching:
          ab: ['a', 'b']

        formatters:
          textFmted: (v) ->
            'textFmted=' + v

          ab: (v) ->
            v.join ','

          classTarget: (v) ->
            if v > 1
              'baz'
            else
              'qux'

      view = new View()
      view.set 'textId', 'foo'
      view.set 'textClass', 'bar'
      view.set 'textFmted', 'fmt'
      view.set 'a', 'a'
      view.set 'b', 'b'
      view.set 'src', 'www.baz.com'
      view.set 'classTarget', 1
      view.render()
      html = view.el.html()

    it 'should be render text bindings correctly', ->
      html.should.contain '<span id="text">foo</span>'
      html.should.contain '<span class="text">bar</span>'

    it 'should be render @src bindings correctly', ->
      html.should.contain '<img id="img" src="www.baz.com">'

    it 'should be render formatted values correctly', ->
      html.should.contain '<span class="formatted">textFmted=fmt</span>'

    it 'should be render computed properties correctly', ->
      html.should.contain '<span id="computed">a,b</span>'

    it 'should be render class attributes correctly', ->
      html.should.contain '<span class="foo bar qux"></span>'
