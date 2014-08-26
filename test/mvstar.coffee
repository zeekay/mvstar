mvstar = require '../lib'
should = require('chai').should()

describe 'mvstar', ->
  it 'should expose Model and View constructors', ->
    mvstar.View.should.exist
    mvstar.Model.should.exist
    mvstar.Model.should.exist
