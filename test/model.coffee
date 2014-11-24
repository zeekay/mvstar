mvstar = require '../lib'
should = require('chai').should()

describe 'Model', ->
  User = null

  before (done) ->
    (require 'jsdom').env '', (err, window) ->
      throw err if err?

      global.$ = (require 'jquery') window

      class User extends mvstar.Model
        defaults:
          age: 0
          favoriteNumber: 7
        validators:
          name: (v) -> v?
          age:  (v) -> typeof v is 'number'
          favoriteNumber: (v) -> typeof v is 'number'
        transforms:
          age: (v) -> v + 21

      done()

  describe '#defaults', ->
    it 'should set defaults for new instances', ->
      user = new User()
      user.get('favoriteNumber').should.eq 7

      user = new User favoriteNumber: 8
      user.get('favoriteNumber').should.eq 8

  describe '#validators', ->
    it 'should validate instances', ->
      user = new User()
      user.validate().should.eq false

      user = new User name: 'Sam'
      user.validate().should.eq true

    it 'should validate values on set', ->
      user = new User()
      user.set('age', '12').should.eq false

    it 'should not allow set invalid values', ->
      user = new User()
      user.set 'age', '12'
      user.get('age').should.eq 21

  describe '#transforms', ->
    it 'should transform defaults', ->
      user = new User()
      user.get('age').should.eq 21

    it 'should transform on set', ->
      user = new User()
      user.set 'age', 21
      user.get('age').should.eq 42

    it 'should pass through properties without defined transforms', ->
      user = new User()
      user.transform('name', 'Bob').should.eq 'Bob'

  describe '#get', ->
    it 'should get values from state', ->
      user = new User name: 'Bob'
      user.get('name').should.eq 'Bob'

  describe '#set', ->
    it 'should set values to state', ->
      user = new User()
      user.set 'name', 'Bob'
      console.log user.get 'name'
      user.get('name').should.eq 'Bob'
