pathtoRegexp = require('path-to-regexp')

class Route
  constructor: (path, options = {}) ->
    if path == '*'
      @path = '(.*)'
    else
      @path = path
    @keys = []
    @regexp = pathtoRegexp @path, @keys, options.sensitive, options.strict

module.exports = Route
