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
  template: -> '<table></table>'
  render: ->
    for model in @collection
      @el.appendChild (Row model).el

Row = View
  model: User
  template: -> '<tr></tr>'
  render: ->
    for k,v of own @model
      @el.appendChild (Cell @model, k)

Cell = View
  model: User
  template: -> '<td></td>'
  render: ->
    @el.innerHTML = @model[@column]
