exec = require('executive').interactive

option '-b', '--browser',                                                'run tests in browser'
option '-g', '--grep [filter]',                                          'test filter'
option '-t', '--test [file]',                                            'test to run'
option '-v', '--version [<newversion> | major | minor | patch | build]', 'new version'

task 'clean', 'clean project', (options) ->
  exec 'rm -rf lib'
  exec 'rm -rf .test'

task 'build', 'build project', (options) ->
  exec 'node_modules/.bin/coffee -bcm -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcm -o .test/ test/'

task 'watch', 'watch for changes and recompile project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcmw -o .test test/'

task 'test', 'run tests', (options) ->
  test = options.test ? '.test'
  if options.grep?
    grep = "--grep #{options.grep}"
  else
    grep = ''

  if options.browser
    test = test.substring(1)  # no need to use compiled JS
    exec "./node_modules/.bin/mocha-http
          --timeout 5000
          --browser
          #{test}"
  else
    exec "NODE_ENV=test ./node_modules/.bin/mocha
        --colors
        --reporter spec
        --timeout 5000
        --compilers coffee:coffee-script/register
        --require postmortem/register
        #{grep}
        #{test}"

task 'test:browser', 'run tests', (options) ->
  options.browser = true
  invoke 'test'

task 'gh-pages', 'Publish docs to gh-pages', ->
  brief = require 'brief'
  brief.update()

task 'publish', 'publish project', (options) ->
  newVersion = options.version ? 'patch'

  exec """
  git push
  npm version #{newVersion}
  npm publish
  """.split '\n'
