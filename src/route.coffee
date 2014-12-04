pathtoRegexp = require('path-to-regexp')

class Route
  constructor: (path, opts = {}) ->
    # Convert * routes
    path = ':star*' if path == '*'

    # Ensure leading /
    path = '/' + path.replace /^\//, ''

    # Add prefix
    if opts.prefix?
      prefix = ('/' + opts.prefix.replace /^\//, '').replace /\/$/, ''
      path = prefix + path

    @keys = []
    @regexp = pathtoRegexp path, @keys, opts.sensitive, opts.strict
    @path = path

module.exports = Route
