{Collection, Model, View} = require 'mvstar'

User = Model
  defaults:
    name: ''
    email: ''

Users = Collection
  model: User
  fetch: ->
    @models = [
      User name: 'Zach', email: 'zach@kelling.com'
      User name: 'David', email: 'david@tai.com'
    ]

Table = View
  collection: Users
  template: -> '''
  <div>
    <table>
    </table>
  </div>
  '''
  render: ->
    # Get column headers from properties of first model in collection
    columns = (k for k,v of own @collection.first())
    # Create a header using column
    header = Header columns
    # Bind to table
    @bind 'table', header
    # Bind rows to after header
    rows = (Row model for model in @collection)
    @bind('table').after header, rows

Header = View
  template: -> '<tr></tr>'
  initialize: (@columns) ->
  render: ->
    @el.appendChild (Heading v) for v in @columns

Heading = View
  template: -> '<th></th>'
  initialize: (@value) ->
  render: ->
    @el.innerHTML = @value

Row = View
  model: User
  template: -> '<tr></tr>'
  render: ->
    for k,v of own @model
      @el.appendChild (Cell v)

Cell = View
  template: -> '<td></td>'
  initialize: (@value) ->
  render: ->
    @el.innerHTML = @value
