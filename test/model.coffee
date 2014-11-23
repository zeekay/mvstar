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
        validators:
          name: (name) -> name?

      User = User
      done()

  it 'should set defaults for new instances', ->
    user = new User name: 'Sam'
    user.age.should.eq 0

  it 'should validate instances', ->
    user = new User()
    user.validate().should.eq false

    user = new User name: 'Sam'
    user.validate().should.eq true
