mvstar = require '../lib'

describe 'mvstar', ->
  it 'should expose Model and View constructors', ->
    mvstar.App.should.exist
    mvstar.Model.should.exist
    mvstar.View.should.exist
