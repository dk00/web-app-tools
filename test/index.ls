units =
  utils: \Utilities
  react: 'Wrapped React API'
  \fetch-params : 'Fetch parameters'
  collection: \Collection
  routing: \Routing

function test units, dirname
  require \livescript
  tape = require \tape
  register = require \../register
  register if process.argv.length > 2 then {} else plugins: [\istanbul]
  list = if process.argv.length > 2 then process.argv.slice 2
  else Object.keys units
  list.for-each (name) ->
    tape units[name] || name, (require "#dirname/#name" .default)

test units, __dirname
