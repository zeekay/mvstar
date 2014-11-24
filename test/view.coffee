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
    view = null

    before ->
      class View extends mvstar.View
        html: '''
              <div>
                <span class="class"></span>
                <span id="id"></span>
                <span id="formatted"></span>
                <span id="computed"></span>
                <span id="class-attr" class="foo bar"></span>

                <div id="data"></div>

                <img id="src">

                <input id="input-checked" type="checkbox">
                <input id="input-name">
                <input id="input-value">

                <select id="select-index">
                  <option value="optionA">optionA</option>
                  <option value="optionB">optionB</option>
                </select>

                <select id="select-value">
                  <option value="optionA">optionA</option>
                  <option value="optionB">optionB</option>
                </select>

                <textarea id="textarea-text"></textarea>
                <textarea id="textarea-value"></textarea>
              </div>
              '''

        bindings:
          class:         '.class'
          id:            '#id'
          formatted:     '#formatted'
          computed:      '#computed'
          classAttr:     '#class-attr @class'

          data:          '#data @data-foo'

          src:           '#src @src'

          inputChecked:  '#input-checked @checked'
          inputName:     '#input-name    @name'
          inputValue:    '#input-value   @value'

          selectIndex:   '#select-index @index'
          selectValue:   '#select-value @value'

          textareaText:  '#textarea-text'
          textareaValue: '#textarea-value @value'

        computed:
          computed: (a, b) -> [a, b]

        watching:
          computed: ['computedA', 'computedB']

        formatters:
          formatted: (v) ->
            'formatted=' + v

          computed: (v) ->
            v.join ','

      view = new View()

      view.set 'class',         'value'
      view.set 'id',            'value'
      view.set 'formatted',     'value'
      view.set 'computedA',     'valueA'
      view.set 'computedB',     'valueB'
      view.set 'classAttr',     'value'
      view.set 'data',          'value'
      view.set 'src',           'www.value.com'
      view.set 'inputChecked',  true
      view.set 'inputName',     'value'
      view.set 'inputValue',    'value'
      view.set 'selectIndex',   1
      view.set 'selectValue',   'optionA'
      view.set 'textareaText',  'value'
      view.set 'textareaValue', 'value'

      view.render()

      html = view.el.html()
      html

    it 'should bind using class as selector', ->
      html.should.contain '<span class="class">value</span>'

    it 'should bind using id as selector', ->
      html.should.contain '<span id="id">value</span>'

    it 'should bind formatted value to target', ->
      html.should.contain '<span id="formatted">formatted=value</span>'

    it 'should bind computed value to target', ->
      html.should.contain '<span id="computed">valueA,valueB</span>'

    it 'should bind to target\'s class attribute', ->
      html.should.contain '<span id="class-attr" class="foo bar value"></span>'

    it 'should bind to target\'s data attribute', ->
      html.should.contain '<div id="data" data-foo="value"></div>'

    it 'should bind to target\'s src attribute', ->
      html.should.contain '<img id="src" src="www.value.com">'

    it 'should set input as checked correctly', ->
      view.el.find('#input-checked').prop('checked').should.eq true

    it 'should set input\'s name attribute correctly', ->
      view.el.find('#input-name').attr('name').should.eq 'value'

    it 'should set input\'s value correctly', ->
      view.el.find('#input-value').val().should.eq 'value'

    it 'should set select\'s value correctly', ->
      view.el.find('#select-value').val().should.eq 'optionA'

    it 'should set selectIndex correctly', ->
      view.el.find('#select-index').prop('selectedIndex').should.eq 1

    it 'should set textarea text attribute correctly', ->
      html.should.contain '<textarea id="textarea-text">value</textarea>'

    it 'should set textarea\'s value correctly', ->
      html.should.contain '<textarea id="textarea-value">value</textarea>'

  describe '#get', ->
    view = null
    before ->
      class View extends mvstar.View
      view = new View state:
        a: 'a'
        b: 'b'

    it 'should get state correctly', ->
      view.get('a').should.eq 'a'
      view.get('b').should.eq 'b'

    it 'should set state correctly', ->
      view.set 'a', 'z'
      view.get('a').should.eq 'z'

      view.set 'b', 'x'
      view.get('b').should.eq 'x'
