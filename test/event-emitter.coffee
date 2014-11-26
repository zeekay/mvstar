mvstar = require '../lib'

appendArguments = (array, args) ->
  array.concat Array::slice.call args, 0

compareArrays = (a,b) ->
  (JSON.stringify a).should.eq JSON.stringify b

describe 'EventEmitter', ->
  describe '#on', ->
    it 'should add event listeners', ->
      emitter = new mvstar.EventEmitter()

      foo = ->
      emitter.on 'foo', foo

      emitter._listeners['foo'][0].should.eq foo


  describe '#emit', ->
    it 'should send events to listeners', ->
      events = []
      emitter = new mvstar.EventEmitter()

      emitter.on 'foo', ->
        events = appendArguments events, arguments

      emitter.emit 'foo', 1
      compareArrays events, [ 1 ]

    it 'should send events to support multiple listeners', ->
      events = []
      emitter = new mvstar.EventEmitter()

      emitter.on 'foo', ->
        events = appendArguments events, arguments

      emitter.on 'foo', ->
        events = appendArguments events, arguments

      emitter.emit 'foo', 1
      emitter.emit 'foo', 1, 2
      emitter.emit 'foo', 1, 2, 3
      compareArrays events, [ 1, 1, 1, 2, 1, 2, 1, 2, 3, 1, 2, 3 ]


  describe '#off', ->
    it 'should allow listener to be removed', ->
      events = []
      emitter = new mvstar.EventEmitter()

      index = emitter.on 'foo', ->
        events = appendArguments events, arguments

      emitter.emit 'foo', 1
      emitter.off index
      emitter.emit 'foo', 2

      compareArrays events, [ 1 ]
